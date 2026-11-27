
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for (i = 1; i < argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	19e000ef          	jal	1c6 <atoi>
  2c:	2ec000ef          	jal	318 <kill>
  for (i = 1; i < argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2b0000ef          	jal	2e8 <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
<<<<<<< HEAD
  44:	92058593          	addi	a1,a1,-1760 # 960 <malloc+0xfc>
  48:	4509                	li	a0,2
  4a:	73c000ef          	jal	786 <fprintf>
=======
  44:	94058593          	addi	a1,a1,-1728 # 980 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	75a000ef          	jal	7a4 <fprintf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  4e:	4505                	li	a0,1
  50:	298000ef          	jal	2e8 <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  5c:	fa5ff0ef          	jal	0 <main>
  exit(r);
  60:	288000ef          	jal	2e8 <exit>

0000000000000064 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e422                	sd	s0,8(sp)
  68:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  6a:	87aa                	mv	a5,a0
  6c:	0585                	addi	a1,a1,1
  6e:	0785                	addi	a5,a5,1
  70:	fff5c703          	lbu	a4,-1(a1)
  74:	fee78fa3          	sb	a4,-1(a5)
  78:	fb75                	bnez	a4,6c <strcpy+0x8>
    ;
  return os;
}
  7a:	6422                	ld	s0,8(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	1141                	addi	sp,sp,-16
  82:	e422                	sd	s0,8(sp)
  84:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x1e>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x1e>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	6422                	ld	s0,8(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strlen>:

uint
strlen(const char *s)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e422                	sd	s0,8(sp)
  b0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b2:	00054783          	lbu	a5,0(a0)
  b6:	cf91                	beqz	a5,d2 <strlen+0x26>
  b8:	0505                	addi	a0,a0,1
  ba:	87aa                	mv	a5,a0
  bc:	86be                	mv	a3,a5
  be:	0785                	addi	a5,a5,1
  c0:	fff7c703          	lbu	a4,-1(a5)
  c4:	ff65                	bnez	a4,bc <strlen+0x10>
  c6:	40a6853b          	subw	a0,a3,a0
  ca:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  cc:	6422                	ld	s0,8(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret
  for (n = 0; s[n]; n++)
  d2:	4501                	li	a0,0
  d4:	bfe5                	j	cc <strlen+0x20>

00000000000000d6 <memset>:

void *
memset(void *dst, int c, uint n)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  dc:	ca19                	beqz	a2,f2 <memset+0x1c>
  de:	87aa                	mv	a5,a0
  e0:	1602                	slli	a2,a2,0x20
  e2:	9201                	srli	a2,a2,0x20
  e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  ec:	0785                	addi	a5,a5,1
  ee:	fee79de3          	bne	a5,a4,e8 <memset+0x12>
  }
  return dst;
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret

00000000000000f8 <strchr>:

char *
strchr(const char *s, char c)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  for (; *s; s++)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb99                	beqz	a5,118 <strchr+0x20>
    if (*s == c)
 104:	00f58763          	beq	a1,a5,112 <strchr+0x1a>
  for (; *s; s++)
 108:	0505                	addi	a0,a0,1
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbfd                	bnez	a5,104 <strchr+0xc>
      return (char *)s;
  return 0;
 110:	4501                	li	a0,0
}
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret
  return 0;
 118:	4501                	li	a0,0
 11a:	bfe5                	j	112 <strchr+0x1a>

000000000000011c <gets>:

char *
gets(char *buf, int max)
{
 11c:	711d                	addi	sp,sp,-96
 11e:	ec86                	sd	ra,88(sp)
 120:	e8a2                	sd	s0,80(sp)
 122:	e4a6                	sd	s1,72(sp)
 124:	e0ca                	sd	s2,64(sp)
 126:	fc4e                	sd	s3,56(sp)
 128:	f852                	sd	s4,48(sp)
 12a:	f456                	sd	s5,40(sp)
 12c:	f05a                	sd	s6,32(sp)
 12e:	ec5e                	sd	s7,24(sp)
 130:	1080                	addi	s0,sp,96
 132:	8baa                	mv	s7,a0
 134:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 136:	892a                	mv	s2,a0
 138:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 13a:	4aa9                	li	s5,10
 13c:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 13e:	89a6                	mv	s3,s1
 140:	2485                	addiw	s1,s1,1
 142:	0344d663          	bge	s1,s4,16e <gets+0x52>
    cc = read(0, &c, 1);
 146:	4605                	li	a2,1
 148:	faf40593          	addi	a1,s0,-81
 14c:	4501                	li	a0,0
 14e:	1b2000ef          	jal	300 <read>
    if (cc < 1)
 152:	00a05e63          	blez	a0,16e <gets+0x52>
    buf[i++] = c;
 156:	faf44783          	lbu	a5,-81(s0)
 15a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 15e:	01578763          	beq	a5,s5,16c <gets+0x50>
 162:	0905                	addi	s2,s2,1
 164:	fd679de3          	bne	a5,s6,13e <gets+0x22>
    buf[i++] = c;
 168:	89a6                	mv	s3,s1
 16a:	a011                	j	16e <gets+0x52>
 16c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16e:	99de                	add	s3,s3,s7
 170:	00098023          	sb	zero,0(s3)
  return buf;
}
 174:	855e                	mv	a0,s7
 176:	60e6                	ld	ra,88(sp)
 178:	6446                	ld	s0,80(sp)
 17a:	64a6                	ld	s1,72(sp)
 17c:	6906                	ld	s2,64(sp)
 17e:	79e2                	ld	s3,56(sp)
 180:	7a42                	ld	s4,48(sp)
 182:	7aa2                	ld	s5,40(sp)
 184:	7b02                	ld	s6,32(sp)
 186:	6be2                	ld	s7,24(sp)
 188:	6125                	addi	sp,sp,96
 18a:	8082                	ret

000000000000018c <stat>:

int
stat(const char *n, struct stat *st)
{
 18c:	1101                	addi	sp,sp,-32
 18e:	ec06                	sd	ra,24(sp)
 190:	e822                	sd	s0,16(sp)
 192:	e04a                	sd	s2,0(sp)
 194:	1000                	addi	s0,sp,32
 196:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	4581                	li	a1,0
 19a:	18e000ef          	jal	328 <open>
  if (fd < 0)
 19e:	02054263          	bltz	a0,1c2 <stat+0x36>
 1a2:	e426                	sd	s1,8(sp)
 1a4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a6:	85ca                	mv	a1,s2
 1a8:	198000ef          	jal	340 <fstat>
 1ac:	892a                	mv	s2,a0
  close(fd);
 1ae:	8526                	mv	a0,s1
 1b0:	160000ef          	jal	310 <close>
  return r;
 1b4:	64a2                	ld	s1,8(sp)
}
 1b6:	854a                	mv	a0,s2
 1b8:	60e2                	ld	ra,24(sp)
 1ba:	6442                	ld	s0,16(sp)
 1bc:	6902                	ld	s2,0(sp)
 1be:	6105                	addi	sp,sp,32
 1c0:	8082                	ret
    return -1;
 1c2:	597d                	li	s2,-1
 1c4:	bfcd                	j	1b6 <stat+0x2a>

00000000000001c6 <atoi>:

int
atoi(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1cc:	00054683          	lbu	a3,0(a0)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	4625                	li	a2,9
 1da:	02f66863          	bltu	a2,a5,20a <atoi+0x44>
 1de:	872a                	mv	a4,a0
  n = 0;
 1e0:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1e2:	0705                	addi	a4,a4,1
 1e4:	0025179b          	slliw	a5,a0,0x2
 1e8:	9fa9                	addw	a5,a5,a0
 1ea:	0017979b          	slliw	a5,a5,0x1
 1ee:	9fb5                	addw	a5,a5,a3
 1f0:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1f4:	00074683          	lbu	a3,0(a4)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	fef671e3          	bgeu	a2,a5,1e2 <atoi+0x1c>
  return n;
}
 204:	6422                	ld	s0,8(sp)
 206:	0141                	addi	sp,sp,16
 208:	8082                	ret
  n = 0;
 20a:	4501                	li	a0,0
 20c:	bfe5                	j	204 <atoi+0x3e>

000000000000020e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e422                	sd	s0,8(sp)
 212:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 214:	02b57463          	bgeu	a0,a1,23c <memmove+0x2e>
    while (n-- > 0)
 218:	00c05f63          	blez	a2,236 <memmove+0x28>
 21c:	1602                	slli	a2,a2,0x20
 21e:	9201                	srli	a2,a2,0x20
 220:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 224:	872a                	mv	a4,a0
      *dst++ = *src++;
 226:	0585                	addi	a1,a1,1
 228:	0705                	addi	a4,a4,1
 22a:	fff5c683          	lbu	a3,-1(a1)
 22e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 232:	fef71ae3          	bne	a4,a5,226 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 236:	6422                	ld	s0,8(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
    dst += n;
 23c:	00c50733          	add	a4,a0,a2
    src += n;
 240:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 242:	fec05ae3          	blez	a2,236 <memmove+0x28>
 246:	fff6079b          	addiw	a5,a2,-1
 24a:	1782                	slli	a5,a5,0x20
 24c:	9381                	srli	a5,a5,0x20
 24e:	fff7c793          	not	a5,a5
 252:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 254:	15fd                	addi	a1,a1,-1
 256:	177d                	addi	a4,a4,-1
 258:	0005c683          	lbu	a3,0(a1)
 25c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 260:	fee79ae3          	bne	a5,a4,254 <memmove+0x46>
 264:	bfc9                	j	236 <memmove+0x28>

0000000000000266 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e422                	sd	s0,8(sp)
 26a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26c:	ca05                	beqz	a2,29c <memcmp+0x36>
 26e:	fff6069b          	addiw	a3,a2,-1
 272:	1682                	slli	a3,a3,0x20
 274:	9281                	srli	a3,a3,0x20
 276:	0685                	addi	a3,a3,1
 278:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27a:	00054783          	lbu	a5,0(a0)
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00e79863          	bne	a5,a4,292 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 286:	0505                	addi	a0,a0,1
    p2++;
 288:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28a:	fed518e3          	bne	a0,a3,27a <memcmp+0x14>
  }
  return 0;
 28e:	4501                	li	a0,0
 290:	a019                	j	296 <memcmp+0x30>
      return *p1 - *p2;
 292:	40e7853b          	subw	a0,a5,a4
}
 296:	6422                	ld	s0,8(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfe5                	j	296 <memcmp+0x30>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	f67ff0ef          	jal	20e <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <sbrk>:

char *
sbrk(int n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2bc:	4585                	li	a1,1
 2be:	0b2000ef          	jal	370 <sys_sbrk>
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <sbrklazy>:

char *
sbrklazy(int n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d2:	4589                	li	a1,2
 2d4:	09c000ef          	jal	370 <sys_sbrk>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e0:	4885                	li	a7,1
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e8:	4889                	li	a7,2
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f0:	488d                	li	a7,3
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f8:	4891                	li	a7,4
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <read>:
.global read
read:
 li a7, SYS_read
 300:	4895                	li	a7,5
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <write>:
.global write
write:
 li a7, SYS_write
 308:	48c1                	li	a7,16
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <close>:
.global close
close:
 li a7, SYS_close
 310:	48d5                	li	a7,21
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <kill>:
.global kill
kill:
 li a7, SYS_kill
 318:	4899                	li	a7,6
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exec>:
.global exec
exec:
 li a7, SYS_exec
 320:	489d                	li	a7,7
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <open>:
.global open
open:
 li a7, SYS_open
 328:	48bd                	li	a7,15
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 330:	48c5                	li	a7,17
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 338:	48c9                	li	a7,18
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 340:	48a1                	li	a7,8
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <link>:
.global link
link:
 li a7, SYS_link
 348:	48cd                	li	a7,19
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 350:	48d1                	li	a7,20
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 358:	48a5                	li	a7,9
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <dup>:
.global dup
dup:
 li a7, SYS_dup
 360:	48a9                	li	a7,10
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 368:	48ad                	li	a7,11
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 370:	48b1                	li	a7,12
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pause>:
.global pause
pause:
 li a7, SYS_pause
 378:	48b5                	li	a7,13
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 380:	48b9                	li	a7,14
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sync>:
.global sync
sync:
 li a7, SYS_sync
 388:	48d9                	li	a7,22
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <ps>:
.global ps
ps:
 li a7, SYS_ps
 390:	48dd                	li	a7,23
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 398:	48e1                	li	a7,24
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3a0:	48e5                	li	a7,25
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3a8:	48e9                	li	a7,26
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3b0:	48ed                	li	a7,27
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3b8:	48f1                	li	a7,28
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3c0:	48f5                	li	a7,29
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3c8:	48f9                	li	a7,30
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3d0:	48fd                	li	a7,31
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3d8:	02000893          	li	a7,32
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <halt>:
.global halt
halt:
 li a7, SYS_halt
 3e2:	02100893          	li	a7,33
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 3ec:	02200893          	li	a7,34
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 3f6:	02300893          	li	a7,35
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 400:	02400893          	li	a7,36
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 40a:	02500893          	li	a7,37
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 414:	02600893          	li	a7,38
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 41e:	02700893          	li	a7,39
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

<<<<<<< HEAD
0000000000000428 <putc>:
=======
0000000000000428 <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 428:	02800893          	li	a7,40
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 432:	02900893          	li	a7,41
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 43c:	02a00893          	li	a7,42
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 428:	1101                	addi	sp,sp,-32
 42a:	ec06                	sd	ra,24(sp)
 42c:	e822                	sd	s0,16(sp)
 42e:	1000                	addi	s0,sp,32
 430:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 434:	4605                	li	a2,1
 436:	fef40593          	addi	a1,s0,-17
 43a:	ecfff0ef          	jal	308 <write>
}
 43e:	60e2                	ld	ra,24(sp)
 440:	6442                	ld	s0,16(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret

0000000000000446 <printint>:
=======
 446:	1101                	addi	sp,sp,-32
 448:	ec06                	sd	ra,24(sp)
 44a:	e822                	sd	s0,16(sp)
 44c:	1000                	addi	s0,sp,32
 44e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 452:	4605                	li	a2,1
 454:	fef40593          	addi	a1,s0,-17
 458:	eb1ff0ef          	jal	308 <write>
}
 45c:	60e2                	ld	ra,24(sp)
 45e:	6442                	ld	s0,16(sp)
 460:	6105                	addi	sp,sp,32
 462:	8082                	ret

0000000000000464 <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 446:	715d                	addi	sp,sp,-80
 448:	e486                	sd	ra,72(sp)
 44a:	e0a2                	sd	s0,64(sp)
 44c:	f84a                	sd	s2,48(sp)
 44e:	0880                	addi	s0,sp,80
 450:	892a                	mv	s2,a0
=======
 464:	715d                	addi	sp,sp,-80
 466:	e486                	sd	ra,72(sp)
 468:	e0a2                	sd	s0,64(sp)
 46a:	f84a                	sd	s2,48(sp)
 46c:	0880                	addi	s0,sp,80
 46e:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 452:	c299                	beqz	a3,458 <printint+0x12>
 454:	0805c363          	bltz	a1,4da <printint+0x94>
  neg = 0;
 458:	4881                	li	a7,0
 45a:	fb840693          	addi	a3,s0,-72
=======
 470:	c299                	beqz	a3,476 <printint+0x12>
 472:	0805c363          	bltz	a1,4f8 <printint+0x94>
  neg = 0;
 476:	4881                	li	a7,0
 478:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 45e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 460:	00000517          	auipc	a0,0x0
 464:	52050513          	addi	a0,a0,1312 # 980 <digits>
 468:	883e                	mv	a6,a5
 46a:	2785                	addiw	a5,a5,1
 46c:	02c5f733          	remu	a4,a1,a2
 470:	972a                	add	a4,a4,a0
 472:	00074703          	lbu	a4,0(a4)
 476:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 47a:	872e                	mv	a4,a1
 47c:	02c5d5b3          	divu	a1,a1,a2
 480:	0685                	addi	a3,a3,1
 482:	fec773e3          	bgeu	a4,a2,468 <printint+0x22>
  if (neg)
 486:	00088b63          	beqz	a7,49c <printint+0x56>
    buf[i++] = '-';
 48a:	fd078793          	addi	a5,a5,-48
 48e:	97a2                	add	a5,a5,s0
 490:	02d00713          	li	a4,45
 494:	fee78423          	sb	a4,-24(a5)
 498:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 49c:	02f05a63          	blez	a5,4d0 <printint+0x8a>
 4a0:	fc26                	sd	s1,56(sp)
 4a2:	f44e                	sd	s3,40(sp)
 4a4:	fb840713          	addi	a4,s0,-72
 4a8:	00f704b3          	add	s1,a4,a5
 4ac:	fff70993          	addi	s3,a4,-1
 4b0:	99be                	add	s3,s3,a5
 4b2:	37fd                	addiw	a5,a5,-1
 4b4:	1782                	slli	a5,a5,0x20
 4b6:	9381                	srli	a5,a5,0x20
 4b8:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4bc:	fff4c583          	lbu	a1,-1(s1)
 4c0:	854a                	mv	a0,s2
 4c2:	f67ff0ef          	jal	428 <putc>
  while (--i >= 0)
 4c6:	14fd                	addi	s1,s1,-1
 4c8:	ff349ae3          	bne	s1,s3,4bc <printint+0x76>
 4cc:	74e2                	ld	s1,56(sp)
 4ce:	79a2                	ld	s3,40(sp)
}
 4d0:	60a6                	ld	ra,72(sp)
 4d2:	6406                	ld	s0,64(sp)
 4d4:	7942                	ld	s2,48(sp)
 4d6:	6161                	addi	sp,sp,80
 4d8:	8082                	ret
    x = -xx;
 4da:	40b005b3          	neg	a1,a1
    neg = 1;
 4de:	4885                	li	a7,1
    x = -xx;
 4e0:	bfad                	j	45a <printint+0x14>

00000000000004e2 <vprintf>:
=======
 47c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 47e:	00000517          	auipc	a0,0x0
 482:	52250513          	addi	a0,a0,1314 # 9a0 <digits>
 486:	883e                	mv	a6,a5
 488:	2785                	addiw	a5,a5,1
 48a:	02c5f733          	remu	a4,a1,a2
 48e:	972a                	add	a4,a4,a0
 490:	00074703          	lbu	a4,0(a4)
 494:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 498:	872e                	mv	a4,a1
 49a:	02c5d5b3          	divu	a1,a1,a2
 49e:	0685                	addi	a3,a3,1
 4a0:	fec773e3          	bgeu	a4,a2,486 <printint+0x22>
  if (neg)
 4a4:	00088b63          	beqz	a7,4ba <printint+0x56>
    buf[i++] = '-';
 4a8:	fd078793          	addi	a5,a5,-48
 4ac:	97a2                	add	a5,a5,s0
 4ae:	02d00713          	li	a4,45
 4b2:	fee78423          	sb	a4,-24(a5)
 4b6:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4ba:	02f05a63          	blez	a5,4ee <printint+0x8a>
 4be:	fc26                	sd	s1,56(sp)
 4c0:	f44e                	sd	s3,40(sp)
 4c2:	fb840713          	addi	a4,s0,-72
 4c6:	00f704b3          	add	s1,a4,a5
 4ca:	fff70993          	addi	s3,a4,-1
 4ce:	99be                	add	s3,s3,a5
 4d0:	37fd                	addiw	a5,a5,-1
 4d2:	1782                	slli	a5,a5,0x20
 4d4:	9381                	srli	a5,a5,0x20
 4d6:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4da:	fff4c583          	lbu	a1,-1(s1)
 4de:	854a                	mv	a0,s2
 4e0:	f67ff0ef          	jal	446 <putc>
  while (--i >= 0)
 4e4:	14fd                	addi	s1,s1,-1
 4e6:	ff349ae3          	bne	s1,s3,4da <printint+0x76>
 4ea:	74e2                	ld	s1,56(sp)
 4ec:	79a2                	ld	s3,40(sp)
}
 4ee:	60a6                	ld	ra,72(sp)
 4f0:	6406                	ld	s0,64(sp)
 4f2:	7942                	ld	s2,48(sp)
 4f4:	6161                	addi	sp,sp,80
 4f6:	8082                	ret
    x = -xx;
 4f8:	40b005b3          	neg	a1,a1
    neg = 1;
 4fc:	4885                	li	a7,1
    x = -xx;
 4fe:	bfad                	j	478 <printint+0x14>

0000000000000500 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 4e2:	711d                	addi	sp,sp,-96
 4e4:	ec86                	sd	ra,88(sp)
 4e6:	e8a2                	sd	s0,80(sp)
 4e8:	e0ca                	sd	s2,64(sp)
 4ea:	1080                	addi	s0,sp,96
=======
 500:	711d                	addi	sp,sp,-96
 502:	ec86                	sd	ra,88(sp)
 504:	e8a2                	sd	s0,80(sp)
 506:	e0ca                	sd	s2,64(sp)
 508:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 4ec:	0005c903          	lbu	s2,0(a1)
 4f0:	28090663          	beqz	s2,77c <vprintf+0x29a>
 4f4:	e4a6                	sd	s1,72(sp)
 4f6:	fc4e                	sd	s3,56(sp)
 4f8:	f852                	sd	s4,48(sp)
 4fa:	f456                	sd	s5,40(sp)
 4fc:	f05a                	sd	s6,32(sp)
 4fe:	ec5e                	sd	s7,24(sp)
 500:	e862                	sd	s8,16(sp)
 502:	e466                	sd	s9,8(sp)
 504:	8b2a                	mv	s6,a0
 506:	8a2e                	mv	s4,a1
 508:	8bb2                	mv	s7,a2
  state = 0;
 50a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 50c:	4481                	li	s1,0
 50e:	4701                	li	a4,0
=======
 50a:	0005c903          	lbu	s2,0(a1)
 50e:	28090663          	beqz	s2,79a <vprintf+0x29a>
 512:	e4a6                	sd	s1,72(sp)
 514:	fc4e                	sd	s3,56(sp)
 516:	f852                	sd	s4,48(sp)
 518:	f456                	sd	s5,40(sp)
 51a:	f05a                	sd	s6,32(sp)
 51c:	ec5e                	sd	s7,24(sp)
 51e:	e862                	sd	s8,16(sp)
 520:	e466                	sd	s9,8(sp)
 522:	8b2a                	mv	s6,a0
 524:	8a2e                	mv	s4,a1
 526:	8bb2                	mv	s7,a2
  state = 0;
 528:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 52a:	4481                	li	s1,0
 52c:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 510:	02500a93          	li	s5,37
=======
 52e:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 514:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 518:	06c00c93          	li	s9,108
 51c:	a005                	j	53c <vprintf+0x5a>
        putc(fd, c0);
 51e:	85ca                	mv	a1,s2
 520:	855a                	mv	a0,s6
 522:	f07ff0ef          	jal	428 <putc>
 526:	a019                	j	52c <vprintf+0x4a>
    } else if (state == '%') {
 528:	03598263          	beq	s3,s5,54c <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 52c:	2485                	addiw	s1,s1,1
 52e:	8726                	mv	a4,s1
 530:	009a07b3          	add	a5,s4,s1
 534:	0007c903          	lbu	s2,0(a5)
 538:	22090a63          	beqz	s2,76c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 53c:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 540:	fe0994e3          	bnez	s3,528 <vprintf+0x46>
      if (c0 == '%') {
 544:	fd579de3          	bne	a5,s5,51e <vprintf+0x3c>
        state = '%';
 548:	89be                	mv	s3,a5
 54a:	b7cd                	j	52c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 54c:	00ea06b3          	add	a3,s4,a4
 550:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 554:	8636                	mv	a2,a3
      if (c1)
 556:	c681                	beqz	a3,55e <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 558:	9752                	add	a4,a4,s4
 55a:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 55e:	05878363          	beq	a5,s8,5a4 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 562:	05978d63          	beq	a5,s9,5bc <vprintf+0xda>
=======
 532:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 536:	06c00c93          	li	s9,108
 53a:	a005                	j	55a <vprintf+0x5a>
        putc(fd, c0);
 53c:	85ca                	mv	a1,s2
 53e:	855a                	mv	a0,s6
 540:	f07ff0ef          	jal	446 <putc>
 544:	a019                	j	54a <vprintf+0x4a>
    } else if (state == '%') {
 546:	03598263          	beq	s3,s5,56a <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 54a:	2485                	addiw	s1,s1,1
 54c:	8726                	mv	a4,s1
 54e:	009a07b3          	add	a5,s4,s1
 552:	0007c903          	lbu	s2,0(a5)
 556:	22090a63          	beqz	s2,78a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 55a:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 55e:	fe0994e3          	bnez	s3,546 <vprintf+0x46>
      if (c0 == '%') {
 562:	fd579de3          	bne	a5,s5,53c <vprintf+0x3c>
        state = '%';
 566:	89be                	mv	s3,a5
 568:	b7cd                	j	54a <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 56a:	00ea06b3          	add	a3,s4,a4
 56e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 572:	8636                	mv	a2,a3
      if (c1)
 574:	c681                	beqz	a3,57c <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 576:	9752                	add	a4,a4,s4
 578:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 57c:	05878363          	beq	a5,s8,5c2 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 580:	05978d63          	beq	a5,s9,5da <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 566:	07500713          	li	a4,117
 56a:	0ee78763          	beq	a5,a4,658 <vprintf+0x176>
=======
 584:	07500713          	li	a4,117
 588:	0ee78763          	beq	a5,a4,676 <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 56e:	07800713          	li	a4,120
 572:	12e78963          	beq	a5,a4,6a4 <vprintf+0x1c2>
=======
 58c:	07800713          	li	a4,120
 590:	12e78963          	beq	a5,a4,6c2 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 576:	07000713          	li	a4,112
 57a:	14e78e63          	beq	a5,a4,6d6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 57e:	06300713          	li	a4,99
 582:	18e78e63          	beq	a5,a4,71e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 586:	07300713          	li	a4,115
 58a:	1ae78463          	beq	a5,a4,732 <vprintf+0x250>
=======
 594:	07000713          	li	a4,112
 598:	14e78e63          	beq	a5,a4,6f4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 59c:	06300713          	li	a4,99
 5a0:	18e78e63          	beq	a5,a4,73c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5a4:	07300713          	li	a4,115
 5a8:	1ae78463          	beq	a5,a4,750 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 58e:	02500713          	li	a4,37
 592:	04e79563          	bne	a5,a4,5dc <vprintf+0xfa>
        putc(fd, '%');
 596:	02500593          	li	a1,37
 59a:	855a                	mv	a0,s6
 59c:	e8dff0ef          	jal	428 <putc>
=======
 5ac:	02500713          	li	a4,37
 5b0:	04e79563          	bne	a5,a4,5fa <vprintf+0xfa>
        putc(fd, '%');
 5b4:	02500593          	li	a1,37
 5b8:	855a                	mv	a0,s6
 5ba:	e8dff0ef          	jal	446 <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 5a0:	4981                	li	s3,0
 5a2:	b769                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e95ff0ef          	jal	446 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bf8d                	j	52c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5bc:	06400793          	li	a5,100
 5c0:	02f68963          	beq	a3,a5,5f2 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5c4:	06c00793          	li	a5,108
 5c8:	04f68263          	beq	a3,a5,60c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5cc:	07500793          	li	a5,117
 5d0:	0af68063          	beq	a3,a5,670 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5d4:	07800793          	li	a5,120
 5d8:	0ef68263          	beq	a3,a5,6bc <vprintf+0x1da>
        putc(fd, '%');
 5dc:	02500593          	li	a1,37
 5e0:	855a                	mv	a0,s6
 5e2:	e47ff0ef          	jal	428 <putc>
        putc(fd, c0);
 5e6:	85ca                	mv	a1,s2
 5e8:	855a                	mv	a0,s6
 5ea:	e3fff0ef          	jal	428 <putc>
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	bf35                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e47ff0ef          	jal	446 <printint>
        i += 1;
 604:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
        i += 1;
 60a:	b70d                	j	52c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 60c:	06400793          	li	a5,100
 610:	02f60763          	beq	a2,a5,63e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 614:	07500793          	li	a5,117
 618:	06f60963          	beq	a2,a5,68a <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 61c:	07800793          	li	a5,120
 620:	faf61ee3          	bne	a2,a5,5dc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4641                	li	a2,16
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e15ff0ef          	jal	446 <printint>
        i += 2;
 636:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 2;
 63c:	bdc5                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	008b8913          	addi	s2,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	dfbff0ef          	jal	446 <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bdd9                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4629                	li	a2,10
 660:	000be583          	lwu	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	de1ff0ef          	jal	446 <printint>
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd7d                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 670:	008b8913          	addi	s2,s7,8
 674:	4681                	li	a3,0
 676:	4629                	li	a2,10
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	dc9ff0ef          	jal	446 <printint>
        i += 1;
 682:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
        i += 1;
 688:	b555                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8913          	addi	s2,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dafff0ef          	jal	446 <printint>
        i += 2;
 69c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
        i += 2;
 6a2:	b569                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a4:	008b8913          	addi	s2,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4641                	li	a2,16
 6ac:	000be583          	lwu	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	d95ff0ef          	jal	446 <printint>
 6b6:	8bca                	mv	s7,s2
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bd8d                	j	52c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	008b8913          	addi	s2,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4641                	li	a2,16
 6c4:	000bb583          	ld	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	d7dff0ef          	jal	446 <printint>
        i += 1;
 6ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d0:	8bca                	mv	s7,s2
      state = 0;
 6d2:	4981                	li	s3,0
        i += 1;
 6d4:	bda1                	j	52c <vprintf+0x4a>
 6d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d8:	008b8d13          	addi	s10,s7,8
 6dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e0:	03000593          	li	a1,48
 6e4:	855a                	mv	a0,s6
 6e6:	d43ff0ef          	jal	428 <putc>
  putc(fd, 'x');
 6ea:	07800593          	li	a1,120
 6ee:	855a                	mv	a0,s6
 6f0:	d39ff0ef          	jal	428 <putc>
 6f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f6:	00000b97          	auipc	s7,0x0
 6fa:	28ab8b93          	addi	s7,s7,650 # 980 <digits>
 6fe:	03c9d793          	srli	a5,s3,0x3c
 702:	97de                	add	a5,a5,s7
 704:	0007c583          	lbu	a1,0(a5)
 708:	855a                	mv	a0,s6
 70a:	d1fff0ef          	jal	428 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70e:	0992                	slli	s3,s3,0x4
 710:	397d                	addiw	s2,s2,-1
 712:	fe0916e3          	bnez	s2,6fe <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 716:	8bea                	mv	s7,s10
      state = 0;
 718:	4981                	li	s3,0
 71a:	6d02                	ld	s10,0(sp)
 71c:	bd01                	j	52c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 71e:	008b8913          	addi	s2,s7,8
 722:	000bc583          	lbu	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	d01ff0ef          	jal	428 <putc>
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bbf5                	j	52c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 732:	008b8993          	addi	s3,s7,8
 736:	000bb903          	ld	s2,0(s7)
 73a:	00090f63          	beqz	s2,758 <vprintf+0x276>
        for (; *s; s++)
 73e:	00094583          	lbu	a1,0(s2)
 742:	c195                	beqz	a1,766 <vprintf+0x284>
          putc(fd, *s);
 744:	855a                	mv	a0,s6
 746:	ce3ff0ef          	jal	428 <putc>
        for (; *s; s++)
 74a:	0905                	addi	s2,s2,1
 74c:	00094583          	lbu	a1,0(s2)
 750:	f9f5                	bnez	a1,744 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 752:	8bce                	mv	s7,s3
      state = 0;
 754:	4981                	li	s3,0
 756:	bbd9                	j	52c <vprintf+0x4a>
          s = "(null)";
 758:	00000917          	auipc	s2,0x0
 75c:	22090913          	addi	s2,s2,544 # 978 <malloc+0x114>
        for (; *s; s++)
 760:	02800593          	li	a1,40
 764:	b7c5                	j	744 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 766:	8bce                	mv	s7,s3
      state = 0;
 768:	4981                	li	s3,0
 76a:	b3c9                	j	52c <vprintf+0x4a>
 76c:	64a6                	ld	s1,72(sp)
 76e:	79e2                	ld	s3,56(sp)
 770:	7a42                	ld	s4,48(sp)
 772:	7aa2                	ld	s5,40(sp)
 774:	7b02                	ld	s6,32(sp)
 776:	6be2                	ld	s7,24(sp)
 778:	6c42                	ld	s8,16(sp)
 77a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 77c:	60e6                	ld	ra,88(sp)
 77e:	6446                	ld	s0,80(sp)
 780:	6906                	ld	s2,64(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret

0000000000000786 <fprintf>:
=======
 5be:	4981                	li	s3,0
 5c0:	b769                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e95ff0ef          	jal	464 <printint>
 5d4:	8bca                	mv	s7,s2
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	bf8d                	j	54a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5da:	06400793          	li	a5,100
 5de:	02f68963          	beq	a3,a5,610 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5e2:	06c00793          	li	a5,108
 5e6:	04f68263          	beq	a3,a5,62a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5ea:	07500793          	li	a5,117
 5ee:	0af68063          	beq	a3,a5,68e <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5f2:	07800793          	li	a5,120
 5f6:	0ef68263          	beq	a3,a5,6da <vprintf+0x1da>
        putc(fd, '%');
 5fa:	02500593          	li	a1,37
 5fe:	855a                	mv	a0,s6
 600:	e47ff0ef          	jal	446 <putc>
        putc(fd, c0);
 604:	85ca                	mv	a1,s2
 606:	855a                	mv	a0,s6
 608:	e3fff0ef          	jal	446 <putc>
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bf35                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	008b8913          	addi	s2,s7,8
 614:	4685                	li	a3,1
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	e47ff0ef          	jal	464 <printint>
        i += 1;
 622:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b70d                	j	54a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 62a:	06400793          	li	a5,100
 62e:	02f60763          	beq	a2,a5,65c <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 632:	07500793          	li	a5,117
 636:	06f60963          	beq	a2,a5,6a8 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 63a:	07800793          	li	a5,120
 63e:	faf61ee3          	bne	a2,a5,5fa <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 642:	008b8913          	addi	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000bb583          	ld	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	e15ff0ef          	jal	464 <printint>
        i += 2;
 654:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
        i += 2;
 65a:	bdc5                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65c:	008b8913          	addi	s2,s7,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	dfbff0ef          	jal	464 <printint>
        i += 2;
 66e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	bdd9                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 676:	008b8913          	addi	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000be583          	lwu	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	de1ff0ef          	jal	464 <printint>
 688:	8bca                	mv	s7,s2
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd7d                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b8913          	addi	s2,s7,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000bb583          	ld	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	dc9ff0ef          	jal	464 <printint>
        i += 1;
 6a0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
        i += 1;
 6a6:	b555                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	dafff0ef          	jal	464 <printint>
        i += 2;
 6ba:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 2;
 6c0:	b569                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4641                	li	a2,16
 6ca:	000be583          	lwu	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	d95ff0ef          	jal	464 <printint>
 6d4:	8bca                	mv	s7,s2
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	bd8d                	j	54a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6da:	008b8913          	addi	s2,s7,8
 6de:	4681                	li	a3,0
 6e0:	4641                	li	a2,16
 6e2:	000bb583          	ld	a1,0(s7)
 6e6:	855a                	mv	a0,s6
 6e8:	d7dff0ef          	jal	464 <printint>
        i += 1;
 6ec:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
        i += 1;
 6f2:	bda1                	j	54a <vprintf+0x4a>
 6f4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f6:	008b8d13          	addi	s10,s7,8
 6fa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fe:	03000593          	li	a1,48
 702:	855a                	mv	a0,s6
 704:	d43ff0ef          	jal	446 <putc>
  putc(fd, 'x');
 708:	07800593          	li	a1,120
 70c:	855a                	mv	a0,s6
 70e:	d39ff0ef          	jal	446 <putc>
 712:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	00000b97          	auipc	s7,0x0
 718:	28cb8b93          	addi	s7,s7,652 # 9a0 <digits>
 71c:	03c9d793          	srli	a5,s3,0x3c
 720:	97de                	add	a5,a5,s7
 722:	0007c583          	lbu	a1,0(a5)
 726:	855a                	mv	a0,s6
 728:	d1fff0ef          	jal	446 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72c:	0992                	slli	s3,s3,0x4
 72e:	397d                	addiw	s2,s2,-1
 730:	fe0916e3          	bnez	s2,71c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 734:	8bea                	mv	s7,s10
      state = 0;
 736:	4981                	li	s3,0
 738:	6d02                	ld	s10,0(sp)
 73a:	bd01                	j	54a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 73c:	008b8913          	addi	s2,s7,8
 740:	000bc583          	lbu	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	d01ff0ef          	jal	446 <putc>
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bbf5                	j	54a <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 750:	008b8993          	addi	s3,s7,8
 754:	000bb903          	ld	s2,0(s7)
 758:	00090f63          	beqz	s2,776 <vprintf+0x276>
        for (; *s; s++)
 75c:	00094583          	lbu	a1,0(s2)
 760:	c195                	beqz	a1,784 <vprintf+0x284>
          putc(fd, *s);
 762:	855a                	mv	a0,s6
 764:	ce3ff0ef          	jal	446 <putc>
        for (; *s; s++)
 768:	0905                	addi	s2,s2,1
 76a:	00094583          	lbu	a1,0(s2)
 76e:	f9f5                	bnez	a1,762 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 770:	8bce                	mv	s7,s3
      state = 0;
 772:	4981                	li	s3,0
 774:	bbd9                	j	54a <vprintf+0x4a>
          s = "(null)";
 776:	00000917          	auipc	s2,0x0
 77a:	22290913          	addi	s2,s2,546 # 998 <malloc+0x116>
        for (; *s; s++)
 77e:	02800593          	li	a1,40
 782:	b7c5                	j	762 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	b3c9                	j	54a <vprintf+0x4a>
 78a:	64a6                	ld	s1,72(sp)
 78c:	79e2                	ld	s3,56(sp)
 78e:	7a42                	ld	s4,48(sp)
 790:	7aa2                	ld	s5,40(sp)
 792:	7b02                	ld	s6,32(sp)
 794:	6be2                	ld	s7,24(sp)
 796:	6c42                	ld	s8,16(sp)
 798:	6ca2                	ld	s9,8(sp)
    }
  }
}
 79a:	60e6                	ld	ra,88(sp)
 79c:	6446                	ld	s0,80(sp)
 79e:	6906                	ld	s2,64(sp)
 7a0:	6125                	addi	sp,sp,96
 7a2:	8082                	ret

00000000000007a4 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 786:	715d                	addi	sp,sp,-80
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e010                	sd	a2,0(s0)
 790:	e414                	sd	a3,8(s0)
 792:	e818                	sd	a4,16(s0)
 794:	ec1c                	sd	a5,24(s0)
 796:	03043023          	sd	a6,32(s0)
 79a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a2:	8622                	mv	a2,s0
 7a4:	d3fff0ef          	jal	4e2 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6161                	addi	sp,sp,80
 7ae:	8082                	ret

00000000000007b0 <printf>:
=======
 7a4:	715d                	addi	sp,sp,-80
 7a6:	ec06                	sd	ra,24(sp)
 7a8:	e822                	sd	s0,16(sp)
 7aa:	1000                	addi	s0,sp,32
 7ac:	e010                	sd	a2,0(s0)
 7ae:	e414                	sd	a3,8(s0)
 7b0:	e818                	sd	a4,16(s0)
 7b2:	ec1c                	sd	a5,24(s0)
 7b4:	03043023          	sd	a6,32(s0)
 7b8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c0:	8622                	mv	a2,s0
 7c2:	d3fff0ef          	jal	500 <vprintf>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6161                	addi	sp,sp,80
 7cc:	8082                	ret

00000000000007ce <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e40c                	sd	a1,8(s0)
 7ba:	e810                	sd	a2,16(s0)
 7bc:	ec14                	sd	a3,24(s0)
 7be:	f018                	sd	a4,32(s0)
 7c0:	f41c                	sd	a5,40(s0)
 7c2:	03043823          	sd	a6,48(s0)
 7c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	00840613          	addi	a2,s0,8
 7ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	d0dff0ef          	jal	4e2 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
=======
 7ce:	711d                	addi	sp,sp,-96
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e40c                	sd	a1,8(s0)
 7d8:	e810                	sd	a2,16(s0)
 7da:	ec14                	sd	a3,24(s0)
 7dc:	f018                	sd	a4,32(s0)
 7de:	f41c                	sd	a5,40(s0)
 7e0:	03043823          	sd	a6,48(s0)
 7e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	00840613          	addi	a2,s0,8
 7ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f0:	85aa                	mv	a1,a0
 7f2:	4505                	li	a0,1
 7f4:	d0dff0ef          	jal	500 <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6125                	addi	sp,sp,96
 7fe:	8082                	ret

0000000000000800 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e422                	sd	s0,8(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	8147b783          	ld	a5,-2028(a5) # 1000 <freep>
 7f4:	a02d                	j	81e <free+0x3c>
=======
 800:	1141                	addi	sp,sp,-16
 802:	e422                	sd	s0,8(sp)
 804:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 806:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	00000797          	auipc	a5,0x0
 80e:	7f67b783          	ld	a5,2038(a5) # 1000 <freep>
 812:	a02d                	j	83c <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 7f6:	4618                	lw	a4,8(a2)
 7f8:	9f2d                	addw	a4,a4,a1
 7fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fe:	6398                	ld	a4,0(a5)
 800:	6310                	ld	a2,0(a4)
 802:	a83d                	j	840 <free+0x5e>
=======
 814:	4618                	lw	a4,8(a2)
 816:	9f2d                	addw	a4,a4,a1
 818:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6310                	ld	a2,0(a4)
 820:	a83d                	j	85e <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 804:	ff852703          	lw	a4,-8(a0)
 808:	9f31                	addw	a4,a4,a2
 80a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80c:	ff053683          	ld	a3,-16(a0)
 810:	a091                	j	854 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x3a>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x4a>
{
 81c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x30>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059813          	slli	a6,a1,0x20
 836:	01c85713          	srli	a4,a6,0x1c
 83a:	9736                	add	a4,a4,a3
 83c:	fae60de3          	beq	a2,a4,7f6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 844:	4790                	lw	a2,8(a5)
 846:	02061593          	slli	a1,a2,0x20
 84a:	01c5d713          	srli	a4,a1,0x1c
 84e:	973e                	add	a4,a4,a5
 850:	fae68ae3          	beq	a3,a4,804 <free+0x22>
    p->s.ptr = bp->s.ptr;
 854:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
}
 85e:	6422                	ld	s0,8(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret

0000000000000864 <malloc>:
=======
 822:	ff852703          	lw	a4,-8(a0)
 826:	9f31                	addw	a4,a4,a2
 828:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82a:	ff053683          	ld	a3,-16(a0)
 82e:	a091                	j	872 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	6398                	ld	a4,0(a5)
 832:	00e7e463          	bltu	a5,a4,83a <free+0x3a>
 836:	00e6ea63          	bltu	a3,a4,84a <free+0x4a>
{
 83a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	fed7fae3          	bgeu	a5,a3,830 <free+0x30>
 840:	6398                	ld	a4,0(a5)
 842:	00e6e463          	bltu	a3,a4,84a <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	fee7eae3          	bltu	a5,a4,83a <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 84a:	ff852583          	lw	a1,-8(a0)
 84e:	6390                	ld	a2,0(a5)
 850:	02059813          	slli	a6,a1,0x20
 854:	01c85713          	srli	a4,a6,0x1c
 858:	9736                	add	a4,a4,a3
 85a:	fae60de3          	beq	a2,a4,814 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 85e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 862:	4790                	lw	a2,8(a5)
 864:	02061593          	slli	a1,a2,0x20
 868:	01c5d713          	srli	a4,a1,0x1c
 86c:	973e                	add	a4,a4,a5
 86e:	fae68ae3          	beq	a3,a4,822 <free+0x22>
    p->s.ptr = bp->s.ptr;
 872:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
}
 87c:	6422                	ld	s0,8(sp)
 87e:	0141                	addi	sp,sp,16
 880:	8082                	ret

0000000000000882 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 864:	7139                	addi	sp,sp,-64
 866:	fc06                	sd	ra,56(sp)
 868:	f822                	sd	s0,48(sp)
 86a:	f426                	sd	s1,40(sp)
 86c:	ec4e                	sd	s3,24(sp)
 86e:	0080                	addi	s0,sp,64
=======
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f426                	sd	s1,40(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 870:	02051493          	slli	s1,a0,0x20
 874:	9081                	srli	s1,s1,0x20
 876:	04bd                	addi	s1,s1,15
 878:	8091                	srli	s1,s1,0x4
 87a:	0014899b          	addiw	s3,s1,1
 87e:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 880:	00000517          	auipc	a0,0x0
 884:	78053503          	ld	a0,1920(a0) # 1000 <freep>
 888:	c915                	beqz	a0,8bc <malloc+0x58>
=======
 88e:	02051493          	slli	s1,a0,0x20
 892:	9081                	srli	s1,s1,0x20
 894:	04bd                	addi	s1,s1,15
 896:	8091                	srli	s1,s1,0x4
 898:	0014899b          	addiw	s3,s1,1
 89c:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 89e:	00000517          	auipc	a0,0x0
 8a2:	76253503          	ld	a0,1890(a0) # 1000 <freep>
 8a6:	c915                	beqz	a0,8da <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 88a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 88c:	4798                	lw	a4,8(a5)
 88e:	08977a63          	bgeu	a4,s1,922 <malloc+0xbe>
 892:	f04a                	sd	s2,32(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 89a:	8a4e                	mv	s4,s3
 89c:	0009871b          	sext.w	a4,s3
 8a0:	6685                	lui	a3,0x1
 8a2:	00d77363          	bgeu	a4,a3,8a8 <malloc+0x44>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
=======
 8a8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8aa:	4798                	lw	a4,8(a5)
 8ac:	08977a63          	bgeu	a4,s1,940 <malloc+0xbe>
 8b0:	f04a                	sd	s2,32(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8b8:	8a4e                	mv	s4,s3
 8ba:	0009871b          	sext.w	a4,s3
 8be:	6685                	lui	a3,0x1
 8c0:	00d77363          	bgeu	a4,a3,8c6 <malloc+0x44>
 8c4:	6a05                	lui	s4,0x1
 8c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ca:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 8b0:	00000917          	auipc	s2,0x0
 8b4:	75090913          	addi	s2,s2,1872 # 1000 <freep>
  if (p == SBRK_ERROR)
 8b8:	5afd                	li	s5,-1
 8ba:	a081                	j	8fa <malloc+0x96>
 8bc:	f04a                	sd	s2,32(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c4:	00000797          	auipc	a5,0x0
 8c8:	74c78793          	addi	a5,a5,1868 # 1010 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8da:	b7c1                	j	89a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	a8a9                	j	93a <malloc+0xd6>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	efbff0ef          	jal	7e2 <free>
  return freep;
 8ec:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 8f0:	c12d                	beqz	a0,952 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f4:	4798                	lw	a4,8(a5)
 8f6:	02977263          	bgeu	a4,s1,91a <malloc+0xb6>
    if (p == freep)
 8fa:	00093703          	ld	a4,0(s2)
 8fe:	853e                	mv	a0,a5
 900:	fef719e3          	bne	a4,a5,8f2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 904:	8552                	mv	a0,s4
 906:	9afff0ef          	jal	2b4 <sbrk>
  if (p == SBRK_ERROR)
 90a:	fd551ce3          	bne	a0,s5,8e2 <malloc+0x7e>
        return 0;
 90e:	4501                	li	a0,0
 910:	7902                	ld	s2,32(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	a03d                	j	946 <malloc+0xe2>
 91a:	7902                	ld	s2,32(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 922:	fae48de3          	beq	s1,a4,8dc <malloc+0x78>
        p->s.size -= nunits;
 926:	4137073b          	subw	a4,a4,s3
 92a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92c:	02071693          	slli	a3,a4,0x20
 930:	01c6d713          	srli	a4,a3,0x1c
 934:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 936:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93a:	00000717          	auipc	a4,0x0
 93e:	6ca73323          	sd	a0,1734(a4) # 1000 <freep>
      return (void *)(p + 1);
 942:	01078513          	addi	a0,a5,16
  }
}
 946:	70e2                	ld	ra,56(sp)
 948:	7442                	ld	s0,48(sp)
 94a:	74a2                	ld	s1,40(sp)
 94c:	69e2                	ld	s3,24(sp)
 94e:	6121                	addi	sp,sp,64
 950:	8082                	ret
 952:	7902                	ld	s2,32(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
 95a:	b7f5                	j	946 <malloc+0xe2>
=======
 8ce:	00000917          	auipc	s2,0x0
 8d2:	73290913          	addi	s2,s2,1842 # 1000 <freep>
  if (p == SBRK_ERROR)
 8d6:	5afd                	li	s5,-1
 8d8:	a081                	j	918 <malloc+0x96>
 8da:	f04a                	sd	s2,32(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e2:	00000797          	auipc	a5,0x0
 8e6:	72e78793          	addi	a5,a5,1838 # 1010 <base>
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
 8f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8f8:	b7c1                	j	8b8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	e118                	sd	a4,0(a0)
 8fe:	a8a9                	j	958 <malloc+0xd6>
  hp->s.size = nu;
 900:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 904:	0541                	addi	a0,a0,16
 906:	efbff0ef          	jal	800 <free>
  return freep;
 90a:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 90e:	c12d                	beqz	a0,970 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 910:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 912:	4798                	lw	a4,8(a5)
 914:	02977263          	bgeu	a4,s1,938 <malloc+0xb6>
    if (p == freep)
 918:	00093703          	ld	a4,0(s2)
 91c:	853e                	mv	a0,a5
 91e:	fef719e3          	bne	a4,a5,910 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 922:	8552                	mv	a0,s4
 924:	991ff0ef          	jal	2b4 <sbrk>
  if (p == SBRK_ERROR)
 928:	fd551ce3          	bne	a0,s5,900 <malloc+0x7e>
        return 0;
 92c:	4501                	li	a0,0
 92e:	7902                	ld	s2,32(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
 936:	a03d                	j	964 <malloc+0xe2>
 938:	7902                	ld	s2,32(sp)
 93a:	6a42                	ld	s4,16(sp)
 93c:	6aa2                	ld	s5,8(sp)
 93e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 940:	fae48de3          	beq	s1,a4,8fa <malloc+0x78>
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
 968:	74a2                	ld	s1,40(sp)
 96a:	69e2                	ld	s3,24(sp)
 96c:	6121                	addi	sp,sp,64
 96e:	8082                	ret
 970:	7902                	ld	s2,32(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
 978:	b7f5                	j	964 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
