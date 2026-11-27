
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d763          	bge	a5,a0,38 <main+0x38>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for (i = 1; i < argc; i++) {
    if (unlink(argv[i]) < 0) {
  26:	6088                	ld	a0,0(s1)
  28:	322000ef          	jal	34a <unlink>
  2c:	02054263          	bltz	a0,50 <main+0x50>
  for (i = 1; i < argc; i++) {
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a02d                	j	60 <main+0x60>
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  3c:	00001597          	auipc	a1,0x1
<<<<<<< HEAD
  40:	93458593          	addi	a1,a1,-1740 # 970 <malloc+0xfa>
  44:	4509                	li	a0,2
  46:	752000ef          	jal	798 <fprintf>
=======
  40:	95458593          	addi	a1,a1,-1708 # 990 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	770000ef          	jal	7b6 <fprintf>
>>>>>>> e18456e (Updated xv6-riscv)
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2ae000ef          	jal	2fa <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  50:	6090                	ld	a2,0(s1)
  52:	00001597          	auipc	a1,0x1
<<<<<<< HEAD
  56:	93658593          	addi	a1,a1,-1738 # 988 <malloc+0x112>
  5a:	4509                	li	a0,2
  5c:	73c000ef          	jal	798 <fprintf>
=======
  56:	95658593          	addi	a1,a1,-1706 # 9a8 <malloc+0x114>
  5a:	4509                	li	a0,2
  5c:	75a000ef          	jal	7b6 <fprintf>
>>>>>>> e18456e (Updated xv6-riscv)
      break;
    }
  }

  exit(0);
  60:	4501                	li	a0,0
  62:	298000ef          	jal	2fa <exit>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	288000ef          	jal	2fa <exit>

0000000000000076 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e422                	sd	s0,8(sp)
  7a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  7c:	87aa                	mv	a5,a0
  7e:	0585                	addi	a1,a1,1
  80:	0785                	addi	a5,a5,1
  82:	fff5c703          	lbu	a4,-1(a1)
  86:	fee78fa3          	sb	a4,-1(a5)
  8a:	fb75                	bnez	a4,7e <strcpy+0x8>
    ;
  return os;
}
  8c:	6422                	ld	s0,8(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret

0000000000000092 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	cb91                	beqz	a5,b0 <strcmp+0x1e>
  9e:	0005c703          	lbu	a4,0(a1)
  a2:	00f71763          	bne	a4,a5,b0 <strcmp+0x1e>
    p++, q++;
  a6:	0505                	addi	a0,a0,1
  a8:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	fbe5                	bnez	a5,9e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b0:	0005c503          	lbu	a0,0(a1)
}
  b4:	40a7853b          	subw	a0,a5,a0
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strlen>:

uint
strlen(const char *s)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cf91                	beqz	a5,e4 <strlen+0x26>
  ca:	0505                	addi	a0,a0,1
  cc:	87aa                	mv	a5,a0
  ce:	86be                	mv	a3,a5
  d0:	0785                	addi	a5,a5,1
  d2:	fff7c703          	lbu	a4,-1(a5)
  d6:	ff65                	bnez	a4,ce <strlen+0x10>
  d8:	40a6853b          	subw	a0,a3,a0
  dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  for (n = 0; s[n]; n++)
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strlen+0x20>

00000000000000e8 <memset>:

void *
memset(void *dst, int c, uint n)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  ee:	ca19                	beqz	a2,104 <memset+0x1c>
  f0:	87aa                	mv	a5,a0
  f2:	1602                	slli	a2,a2,0x20
  f4:	9201                	srli	a2,a2,0x20
  f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fa:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  fe:	0785                	addi	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <memset+0x12>
  }
  return dst;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret

000000000000010a <strchr>:

char *
strchr(const char *s, char c)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e422                	sd	s0,8(sp)
 10e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cb99                	beqz	a5,12a <strchr+0x20>
    if (*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1a>
  for (; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xc>
      return (char *)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret
  return 0;
 12a:	4501                	li	a0,0
 12c:	bfe5                	j	124 <strchr+0x1a>

000000000000012e <gets>:

char *
gets(char *buf, int max)
{
 12e:	711d                	addi	sp,sp,-96
 130:	ec86                	sd	ra,88(sp)
 132:	e8a2                	sd	s0,80(sp)
 134:	e4a6                	sd	s1,72(sp)
 136:	e0ca                	sd	s2,64(sp)
 138:	fc4e                	sd	s3,56(sp)
 13a:	f852                	sd	s4,48(sp)
 13c:	f456                	sd	s5,40(sp)
 13e:	f05a                	sd	s6,32(sp)
 140:	ec5e                	sd	s7,24(sp)
 142:	1080                	addi	s0,sp,96
 144:	8baa                	mv	s7,a0
 146:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 148:	892a                	mv	s2,a0
 14a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 14c:	4aa9                	li	s5,10
 14e:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 150:	89a6                	mv	s3,s1
 152:	2485                	addiw	s1,s1,1
 154:	0344d663          	bge	s1,s4,180 <gets+0x52>
    cc = read(0, &c, 1);
 158:	4605                	li	a2,1
 15a:	faf40593          	addi	a1,s0,-81
 15e:	4501                	li	a0,0
 160:	1b2000ef          	jal	312 <read>
    if (cc < 1)
 164:	00a05e63          	blez	a0,180 <gets+0x52>
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 170:	01578763          	beq	a5,s5,17e <gets+0x50>
 174:	0905                	addi	s2,s2,1
 176:	fd679de3          	bne	a5,s6,150 <gets+0x22>
    buf[i++] = c;
 17a:	89a6                	mv	s3,s1
 17c:	a011                	j	180 <gets+0x52>
 17e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 180:	99de                	add	s3,s3,s7
 182:	00098023          	sb	zero,0(s3)
  return buf;
}
 186:	855e                	mv	a0,s7
 188:	60e6                	ld	ra,88(sp)
 18a:	6446                	ld	s0,80(sp)
 18c:	64a6                	ld	s1,72(sp)
 18e:	6906                	ld	s2,64(sp)
 190:	79e2                	ld	s3,56(sp)
 192:	7a42                	ld	s4,48(sp)
 194:	7aa2                	ld	s5,40(sp)
 196:	7b02                	ld	s6,32(sp)
 198:	6be2                	ld	s7,24(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	18e000ef          	jal	33a <open>
  if (fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	198000ef          	jal	352 <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	160000ef          	jal	322 <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	597d                	li	s2,-1
 1d6:	bfcd                	j	1c8 <stat+0x2a>

00000000000001d8 <atoi>:

int
atoi(const char *s)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1de:	00054683          	lbu	a3,0(a0)
 1e2:	fd06879b          	addiw	a5,a3,-48
 1e6:	0ff7f793          	zext.b	a5,a5
 1ea:	4625                	li	a2,9
 1ec:	02f66863          	bltu	a2,a5,21c <atoi+0x44>
 1f0:	872a                	mv	a4,a0
  n = 0;
 1f2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1f4:	0705                	addi	a4,a4,1
 1f6:	0025179b          	slliw	a5,a0,0x2
 1fa:	9fa9                	addw	a5,a5,a0
 1fc:	0017979b          	slliw	a5,a5,0x1
 200:	9fb5                	addw	a5,a5,a3
 202:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 206:	00074683          	lbu	a3,0(a4)
 20a:	fd06879b          	addiw	a5,a3,-48
 20e:	0ff7f793          	zext.b	a5,a5
 212:	fef671e3          	bgeu	a2,a5,1f4 <atoi+0x1c>
  return n;
}
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
  n = 0;
 21c:	4501                	li	a0,0
 21e:	bfe5                	j	216 <atoi+0x3e>

0000000000000220 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 226:	02b57463          	bgeu	a0,a1,24e <memmove+0x2e>
    while (n-- > 0)
 22a:	00c05f63          	blez	a2,248 <memmove+0x28>
 22e:	1602                	slli	a2,a2,0x20
 230:	9201                	srli	a2,a2,0x20
 232:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 236:	872a                	mv	a4,a0
      *dst++ = *src++;
 238:	0585                	addi	a1,a1,1
 23a:	0705                	addi	a4,a4,1
 23c:	fff5c683          	lbu	a3,-1(a1)
 240:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 244:	fef71ae3          	bne	a4,a5,238 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 248:	6422                	ld	s0,8(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret
    dst += n;
 24e:	00c50733          	add	a4,a0,a2
    src += n;
 252:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 254:	fec05ae3          	blez	a2,248 <memmove+0x28>
 258:	fff6079b          	addiw	a5,a2,-1
 25c:	1782                	slli	a5,a5,0x20
 25e:	9381                	srli	a5,a5,0x20
 260:	fff7c793          	not	a5,a5
 264:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 266:	15fd                	addi	a1,a1,-1
 268:	177d                	addi	a4,a4,-1
 26a:	0005c683          	lbu	a3,0(a1)
 26e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x46>
 276:	bfc9                	j	248 <memmove+0x28>

0000000000000278 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27e:	ca05                	beqz	a2,2ae <memcmp+0x36>
 280:	fff6069b          	addiw	a3,a2,-1
 284:	1682                	slli	a3,a3,0x20
 286:	9281                	srli	a3,a3,0x20
 288:	0685                	addi	a3,a3,1
 28a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28c:	00054783          	lbu	a5,0(a0)
 290:	0005c703          	lbu	a4,0(a1)
 294:	00e79863          	bne	a5,a4,2a4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 298:	0505                	addi	a0,a0,1
    p2++;
 29a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29c:	fed518e3          	bne	a0,a3,28c <memcmp+0x14>
  }
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	a019                	j	2a8 <memcmp+0x30>
      return *p1 - *p2;
 2a4:	40e7853b          	subw	a0,a5,a4
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <memcmp+0x30>

00000000000002b2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ba:	f67ff0ef          	jal	220 <memmove>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <sbrk>:

char *
sbrk(int n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ce:	4585                	li	a1,1
 2d0:	0b2000ef          	jal	382 <sys_sbrk>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <sbrklazy>:

char *
sbrklazy(int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2e4:	4589                	li	a1,2
 2e6:	09c000ef          	jal	382 <sys_sbrk>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f2:	4885                	li	a7,1
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <exit>:
.global exit
exit:
 li a7, SYS_exit
 2fa:	4889                	li	a7,2
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <wait>:
.global wait
wait:
 li a7, SYS_wait
 302:	488d                	li	a7,3
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 30a:	4891                	li	a7,4
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <read>:
.global read
read:
 li a7, SYS_read
 312:	4895                	li	a7,5
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <write>:
.global write
write:
 li a7, SYS_write
 31a:	48c1                	li	a7,16
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <close>:
.global close
close:
 li a7, SYS_close
 322:	48d5                	li	a7,21
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <kill>:
.global kill
kill:
 li a7, SYS_kill
 32a:	4899                	li	a7,6
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exec>:
.global exec
exec:
 li a7, SYS_exec
 332:	489d                	li	a7,7
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <open>:
.global open
open:
 li a7, SYS_open
 33a:	48bd                	li	a7,15
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 342:	48c5                	li	a7,17
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 34a:	48c9                	li	a7,18
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 352:	48a1                	li	a7,8
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <link>:
.global link
link:
 li a7, SYS_link
 35a:	48cd                	li	a7,19
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 362:	48d1                	li	a7,20
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 36a:	48a5                	li	a7,9
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <dup>:
.global dup
dup:
 li a7, SYS_dup
 372:	48a9                	li	a7,10
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 37a:	48ad                	li	a7,11
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 382:	48b1                	li	a7,12
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pause>:
.global pause
pause:
 li a7, SYS_pause
 38a:	48b5                	li	a7,13
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 392:	48b9                	li	a7,14
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <sync>:
.global sync
sync:
 li a7, SYS_sync
 39a:	48d9                	li	a7,22
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3a2:	48dd                	li	a7,23
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3aa:	48e1                	li	a7,24
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3b2:	48e5                	li	a7,25
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3ba:	48e9                	li	a7,26
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c2:	48ed                	li	a7,27
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3ca:	48f1                	li	a7,28
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3d2:	48f5                	li	a7,29
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3da:	48f9                	li	a7,30
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3e2:	48fd                	li	a7,31
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3ea:	02000893          	li	a7,32
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <halt>:
.global halt
halt:
 li a7, SYS_halt
 3f4:	02100893          	li	a7,33
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 3fe:	02200893          	li	a7,34
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 408:	02300893          	li	a7,35
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 412:	02400893          	li	a7,36
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 41c:	02500893          	li	a7,37
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 426:	02600893          	li	a7,38
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 430:	02700893          	li	a7,39
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

<<<<<<< HEAD
000000000000043a <putc>:
=======
000000000000043a <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 43a:	02800893          	li	a7,40
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 444:	02900893          	li	a7,41
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 44e:	02a00893          	li	a7,42
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	ecfff0ef          	jal	31a <write>
}
 450:	60e2                	ld	ra,24(sp)
 452:	6442                	ld	s0,16(sp)
 454:	6105                	addi	sp,sp,32
 456:	8082                	ret

0000000000000458 <printint>:
=======
 458:	1101                	addi	sp,sp,-32
 45a:	ec06                	sd	ra,24(sp)
 45c:	e822                	sd	s0,16(sp)
 45e:	1000                	addi	s0,sp,32
 460:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 464:	4605                	li	a2,1
 466:	fef40593          	addi	a1,s0,-17
 46a:	eb1ff0ef          	jal	31a <write>
}
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	6105                	addi	sp,sp,32
 474:	8082                	ret

0000000000000476 <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 458:	715d                	addi	sp,sp,-80
 45a:	e486                	sd	ra,72(sp)
 45c:	e0a2                	sd	s0,64(sp)
 45e:	f84a                	sd	s2,48(sp)
 460:	0880                	addi	s0,sp,80
 462:	892a                	mv	s2,a0
=======
 476:	715d                	addi	sp,sp,-80
 478:	e486                	sd	ra,72(sp)
 47a:	e0a2                	sd	s0,64(sp)
 47c:	f84a                	sd	s2,48(sp)
 47e:	0880                	addi	s0,sp,80
 480:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 464:	c299                	beqz	a3,46a <printint+0x12>
 466:	0805c363          	bltz	a1,4ec <printint+0x94>
  neg = 0;
 46a:	4881                	li	a7,0
 46c:	fb840693          	addi	a3,s0,-72
=======
 482:	c299                	beqz	a3,488 <printint+0x12>
 484:	0805c363          	bltz	a1,50a <printint+0x94>
  neg = 0;
 488:	4881                	li	a7,0
 48a:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 470:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 472:	00000517          	auipc	a0,0x0
 476:	53e50513          	addi	a0,a0,1342 # 9b0 <digits>
 47a:	883e                	mv	a6,a5
 47c:	2785                	addiw	a5,a5,1
 47e:	02c5f733          	remu	a4,a1,a2
 482:	972a                	add	a4,a4,a0
 484:	00074703          	lbu	a4,0(a4)
 488:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 48c:	872e                	mv	a4,a1
 48e:	02c5d5b3          	divu	a1,a1,a2
 492:	0685                	addi	a3,a3,1
 494:	fec773e3          	bgeu	a4,a2,47a <printint+0x22>
  if (neg)
 498:	00088b63          	beqz	a7,4ae <printint+0x56>
    buf[i++] = '-';
 49c:	fd078793          	addi	a5,a5,-48
 4a0:	97a2                	add	a5,a5,s0
 4a2:	02d00713          	li	a4,45
 4a6:	fee78423          	sb	a4,-24(a5)
 4aa:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4ae:	02f05a63          	blez	a5,4e2 <printint+0x8a>
 4b2:	fc26                	sd	s1,56(sp)
 4b4:	f44e                	sd	s3,40(sp)
 4b6:	fb840713          	addi	a4,s0,-72
 4ba:	00f704b3          	add	s1,a4,a5
 4be:	fff70993          	addi	s3,a4,-1
 4c2:	99be                	add	s3,s3,a5
 4c4:	37fd                	addiw	a5,a5,-1
 4c6:	1782                	slli	a5,a5,0x20
 4c8:	9381                	srli	a5,a5,0x20
 4ca:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4ce:	fff4c583          	lbu	a1,-1(s1)
 4d2:	854a                	mv	a0,s2
 4d4:	f67ff0ef          	jal	43a <putc>
  while (--i >= 0)
 4d8:	14fd                	addi	s1,s1,-1
 4da:	ff349ae3          	bne	s1,s3,4ce <printint+0x76>
 4de:	74e2                	ld	s1,56(sp)
 4e0:	79a2                	ld	s3,40(sp)
}
 4e2:	60a6                	ld	ra,72(sp)
 4e4:	6406                	ld	s0,64(sp)
 4e6:	7942                	ld	s2,48(sp)
 4e8:	6161                	addi	sp,sp,80
 4ea:	8082                	ret
    x = -xx;
 4ec:	40b005b3          	neg	a1,a1
    neg = 1;
 4f0:	4885                	li	a7,1
    x = -xx;
 4f2:	bfad                	j	46c <printint+0x14>

00000000000004f4 <vprintf>:
=======
 48e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 490:	00000517          	auipc	a0,0x0
 494:	54050513          	addi	a0,a0,1344 # 9d0 <digits>
 498:	883e                	mv	a6,a5
 49a:	2785                	addiw	a5,a5,1
 49c:	02c5f733          	remu	a4,a1,a2
 4a0:	972a                	add	a4,a4,a0
 4a2:	00074703          	lbu	a4,0(a4)
 4a6:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4aa:	872e                	mv	a4,a1
 4ac:	02c5d5b3          	divu	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec773e3          	bgeu	a4,a2,498 <printint+0x22>
  if (neg)
 4b6:	00088b63          	beqz	a7,4cc <printint+0x56>
    buf[i++] = '-';
 4ba:	fd078793          	addi	a5,a5,-48
 4be:	97a2                	add	a5,a5,s0
 4c0:	02d00713          	li	a4,45
 4c4:	fee78423          	sb	a4,-24(a5)
 4c8:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 4cc:	02f05a63          	blez	a5,500 <printint+0x8a>
 4d0:	fc26                	sd	s1,56(sp)
 4d2:	f44e                	sd	s3,40(sp)
 4d4:	fb840713          	addi	a4,s0,-72
 4d8:	00f704b3          	add	s1,a4,a5
 4dc:	fff70993          	addi	s3,a4,-1
 4e0:	99be                	add	s3,s3,a5
 4e2:	37fd                	addiw	a5,a5,-1
 4e4:	1782                	slli	a5,a5,0x20
 4e6:	9381                	srli	a5,a5,0x20
 4e8:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 4ec:	fff4c583          	lbu	a1,-1(s1)
 4f0:	854a                	mv	a0,s2
 4f2:	f67ff0ef          	jal	458 <putc>
  while (--i >= 0)
 4f6:	14fd                	addi	s1,s1,-1
 4f8:	ff349ae3          	bne	s1,s3,4ec <printint+0x76>
 4fc:	74e2                	ld	s1,56(sp)
 4fe:	79a2                	ld	s3,40(sp)
}
 500:	60a6                	ld	ra,72(sp)
 502:	6406                	ld	s0,64(sp)
 504:	7942                	ld	s2,48(sp)
 506:	6161                	addi	sp,sp,80
 508:	8082                	ret
    x = -xx;
 50a:	40b005b3          	neg	a1,a1
    neg = 1;
 50e:	4885                	li	a7,1
    x = -xx;
 510:	bfad                	j	48a <printint+0x14>

0000000000000512 <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 4f4:	711d                	addi	sp,sp,-96
 4f6:	ec86                	sd	ra,88(sp)
 4f8:	e8a2                	sd	s0,80(sp)
 4fa:	e0ca                	sd	s2,64(sp)
 4fc:	1080                	addi	s0,sp,96
=======
 512:	711d                	addi	sp,sp,-96
 514:	ec86                	sd	ra,88(sp)
 516:	e8a2                	sd	s0,80(sp)
 518:	e0ca                	sd	s2,64(sp)
 51a:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 4fe:	0005c903          	lbu	s2,0(a1)
 502:	28090663          	beqz	s2,78e <vprintf+0x29a>
 506:	e4a6                	sd	s1,72(sp)
 508:	fc4e                	sd	s3,56(sp)
 50a:	f852                	sd	s4,48(sp)
 50c:	f456                	sd	s5,40(sp)
 50e:	f05a                	sd	s6,32(sp)
 510:	ec5e                	sd	s7,24(sp)
 512:	e862                	sd	s8,16(sp)
 514:	e466                	sd	s9,8(sp)
 516:	8b2a                	mv	s6,a0
 518:	8a2e                	mv	s4,a1
 51a:	8bb2                	mv	s7,a2
  state = 0;
 51c:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 51e:	4481                	li	s1,0
 520:	4701                	li	a4,0
=======
 51c:	0005c903          	lbu	s2,0(a1)
 520:	28090663          	beqz	s2,7ac <vprintf+0x29a>
 524:	e4a6                	sd	s1,72(sp)
 526:	fc4e                	sd	s3,56(sp)
 528:	f852                	sd	s4,48(sp)
 52a:	f456                	sd	s5,40(sp)
 52c:	f05a                	sd	s6,32(sp)
 52e:	ec5e                	sd	s7,24(sp)
 530:	e862                	sd	s8,16(sp)
 532:	e466                	sd	s9,8(sp)
 534:	8b2a                	mv	s6,a0
 536:	8a2e                	mv	s4,a1
 538:	8bb2                	mv	s7,a2
  state = 0;
 53a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 53c:	4481                	li	s1,0
 53e:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 522:	02500a93          	li	s5,37
=======
 540:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 526:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 52a:	06c00c93          	li	s9,108
 52e:	a005                	j	54e <vprintf+0x5a>
        putc(fd, c0);
 530:	85ca                	mv	a1,s2
 532:	855a                	mv	a0,s6
 534:	f07ff0ef          	jal	43a <putc>
 538:	a019                	j	53e <vprintf+0x4a>
    } else if (state == '%') {
 53a:	03598263          	beq	s3,s5,55e <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 53e:	2485                	addiw	s1,s1,1
 540:	8726                	mv	a4,s1
 542:	009a07b3          	add	a5,s4,s1
 546:	0007c903          	lbu	s2,0(a5)
 54a:	22090a63          	beqz	s2,77e <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 54e:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 552:	fe0994e3          	bnez	s3,53a <vprintf+0x46>
      if (c0 == '%') {
 556:	fd579de3          	bne	a5,s5,530 <vprintf+0x3c>
        state = '%';
 55a:	89be                	mv	s3,a5
 55c:	b7cd                	j	53e <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 55e:	00ea06b3          	add	a3,s4,a4
 562:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 566:	8636                	mv	a2,a3
      if (c1)
 568:	c681                	beqz	a3,570 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 56a:	9752                	add	a4,a4,s4
 56c:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 570:	05878363          	beq	a5,s8,5b6 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 574:	05978d63          	beq	a5,s9,5ce <vprintf+0xda>
=======
 544:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 548:	06c00c93          	li	s9,108
 54c:	a005                	j	56c <vprintf+0x5a>
        putc(fd, c0);
 54e:	85ca                	mv	a1,s2
 550:	855a                	mv	a0,s6
 552:	f07ff0ef          	jal	458 <putc>
 556:	a019                	j	55c <vprintf+0x4a>
    } else if (state == '%') {
 558:	03598263          	beq	s3,s5,57c <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 55c:	2485                	addiw	s1,s1,1
 55e:	8726                	mv	a4,s1
 560:	009a07b3          	add	a5,s4,s1
 564:	0007c903          	lbu	s2,0(a5)
 568:	22090a63          	beqz	s2,79c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 56c:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 570:	fe0994e3          	bnez	s3,558 <vprintf+0x46>
      if (c0 == '%') {
 574:	fd579de3          	bne	a5,s5,54e <vprintf+0x3c>
        state = '%';
 578:	89be                	mv	s3,a5
 57a:	b7cd                	j	55c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 57c:	00ea06b3          	add	a3,s4,a4
 580:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 584:	8636                	mv	a2,a3
      if (c1)
 586:	c681                	beqz	a3,58e <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 588:	9752                	add	a4,a4,s4
 58a:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 58e:	05878363          	beq	a5,s8,5d4 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 592:	05978d63          	beq	a5,s9,5ec <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 578:	07500713          	li	a4,117
 57c:	0ee78763          	beq	a5,a4,66a <vprintf+0x176>
=======
 596:	07500713          	li	a4,117
 59a:	0ee78763          	beq	a5,a4,688 <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 580:	07800713          	li	a4,120
 584:	12e78963          	beq	a5,a4,6b6 <vprintf+0x1c2>
=======
 59e:	07800713          	li	a4,120
 5a2:	12e78963          	beq	a5,a4,6d4 <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 588:	07000713          	li	a4,112
 58c:	14e78e63          	beq	a5,a4,6e8 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 590:	06300713          	li	a4,99
 594:	18e78e63          	beq	a5,a4,730 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 598:	07300713          	li	a4,115
 59c:	1ae78463          	beq	a5,a4,744 <vprintf+0x250>
=======
 5a6:	07000713          	li	a4,112
 5aa:	14e78e63          	beq	a5,a4,706 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5ae:	06300713          	li	a4,99
 5b2:	18e78e63          	beq	a5,a4,74e <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5b6:	07300713          	li	a4,115
 5ba:	1ae78463          	beq	a5,a4,762 <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 5a0:	02500713          	li	a4,37
 5a4:	04e79563          	bne	a5,a4,5ee <vprintf+0xfa>
        putc(fd, '%');
 5a8:	02500593          	li	a1,37
 5ac:	855a                	mv	a0,s6
 5ae:	e8dff0ef          	jal	43a <putc>
=======
 5be:	02500713          	li	a4,37
 5c2:	04e79563          	bne	a5,a4,60c <vprintf+0xfa>
        putc(fd, '%');
 5c6:	02500593          	li	a1,37
 5ca:	855a                	mv	a0,s6
 5cc:	e8dff0ef          	jal	458 <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 5b2:	4981                	li	s3,0
 5b4:	b769                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000ba583          	lw	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e95ff0ef          	jal	458 <printint>
 5c8:	8bca                	mv	s7,s2
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bf8d                	j	53e <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5ce:	06400793          	li	a5,100
 5d2:	02f68963          	beq	a3,a5,604 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5d6:	06c00793          	li	a5,108
 5da:	04f68263          	beq	a3,a5,61e <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5de:	07500793          	li	a5,117
 5e2:	0af68063          	beq	a3,a5,682 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5e6:	07800793          	li	a5,120
 5ea:	0ef68263          	beq	a3,a5,6ce <vprintf+0x1da>
        putc(fd, '%');
 5ee:	02500593          	li	a1,37
 5f2:	855a                	mv	a0,s6
 5f4:	e47ff0ef          	jal	43a <putc>
        putc(fd, c0);
 5f8:	85ca                	mv	a1,s2
 5fa:	855a                	mv	a0,s6
 5fc:	e3fff0ef          	jal	43a <putc>
      state = 0;
 600:	4981                	li	s3,0
 602:	bf35                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	008b8913          	addi	s2,s7,8
 608:	4685                	li	a3,1
 60a:	4629                	li	a2,10
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	e47ff0ef          	jal	458 <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b70d                	j	53e <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 61e:	06400793          	li	a5,100
 622:	02f60763          	beq	a2,a5,650 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 626:	07500793          	li	a5,117
 62a:	06f60963          	beq	a2,a5,69c <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 62e:	07800793          	li	a5,120
 632:	faf61ee3          	bne	a2,a5,5ee <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	008b8913          	addi	s2,s7,8
 63a:	4681                	li	a3,0
 63c:	4641                	li	a2,16
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e15ff0ef          	jal	458 <printint>
        i += 2;
 648:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	bdc5                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	008b8913          	addi	s2,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	dfbff0ef          	jal	458 <printint>
        i += 2;
 662:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	bdd9                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66a:	008b8913          	addi	s2,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000be583          	lwu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	de1ff0ef          	jal	458 <printint>
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
 680:	bd7d                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8913          	addi	s2,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	dc9ff0ef          	jal	458 <printint>
        i += 1;
 694:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 1;
 69a:	b555                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	dafff0ef          	jal	458 <printint>
        i += 2;
 6ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	8bca                	mv	s7,s2
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	b569                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000be583          	lwu	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	d95ff0ef          	jal	458 <printint>
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bd8d                	j	53e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	d7dff0ef          	jal	458 <printint>
        i += 1;
 6e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 1;
 6e6:	bda1                	j	53e <vprintf+0x4a>
 6e8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ea:	008b8d13          	addi	s10,s7,8
 6ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f2:	03000593          	li	a1,48
 6f6:	855a                	mv	a0,s6
 6f8:	d43ff0ef          	jal	43a <putc>
  putc(fd, 'x');
 6fc:	07800593          	li	a1,120
 700:	855a                	mv	a0,s6
 702:	d39ff0ef          	jal	43a <putc>
 706:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 708:	00000b97          	auipc	s7,0x0
 70c:	2a8b8b93          	addi	s7,s7,680 # 9b0 <digits>
 710:	03c9d793          	srli	a5,s3,0x3c
 714:	97de                	add	a5,a5,s7
 716:	0007c583          	lbu	a1,0(a5)
 71a:	855a                	mv	a0,s6
 71c:	d1fff0ef          	jal	43a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 720:	0992                	slli	s3,s3,0x4
 722:	397d                	addiw	s2,s2,-1
 724:	fe0916e3          	bnez	s2,710 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 728:	8bea                	mv	s7,s10
      state = 0;
 72a:	4981                	li	s3,0
 72c:	6d02                	ld	s10,0(sp)
 72e:	bd01                	j	53e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 730:	008b8913          	addi	s2,s7,8
 734:	000bc583          	lbu	a1,0(s7)
 738:	855a                	mv	a0,s6
 73a:	d01ff0ef          	jal	43a <putc>
 73e:	8bca                	mv	s7,s2
      state = 0;
 740:	4981                	li	s3,0
 742:	bbf5                	j	53e <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 744:	008b8993          	addi	s3,s7,8
 748:	000bb903          	ld	s2,0(s7)
 74c:	00090f63          	beqz	s2,76a <vprintf+0x276>
        for (; *s; s++)
 750:	00094583          	lbu	a1,0(s2)
 754:	c195                	beqz	a1,778 <vprintf+0x284>
          putc(fd, *s);
 756:	855a                	mv	a0,s6
 758:	ce3ff0ef          	jal	43a <putc>
        for (; *s; s++)
 75c:	0905                	addi	s2,s2,1
 75e:	00094583          	lbu	a1,0(s2)
 762:	f9f5                	bnez	a1,756 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 764:	8bce                	mv	s7,s3
      state = 0;
 766:	4981                	li	s3,0
 768:	bbd9                	j	53e <vprintf+0x4a>
          s = "(null)";
 76a:	00000917          	auipc	s2,0x0
 76e:	23e90913          	addi	s2,s2,574 # 9a8 <malloc+0x132>
        for (; *s; s++)
 772:	02800593          	li	a1,40
 776:	b7c5                	j	756 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 778:	8bce                	mv	s7,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b3c9                	j	53e <vprintf+0x4a>
 77e:	64a6                	ld	s1,72(sp)
 780:	79e2                	ld	s3,56(sp)
 782:	7a42                	ld	s4,48(sp)
 784:	7aa2                	ld	s5,40(sp)
 786:	7b02                	ld	s6,32(sp)
 788:	6be2                	ld	s7,24(sp)
 78a:	6c42                	ld	s8,16(sp)
 78c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 78e:	60e6                	ld	ra,88(sp)
 790:	6446                	ld	s0,80(sp)
 792:	6906                	ld	s2,64(sp)
 794:	6125                	addi	sp,sp,96
 796:	8082                	ret

0000000000000798 <fprintf>:
=======
 5d0:	4981                	li	s3,0
 5d2:	b769                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e95ff0ef          	jal	476 <printint>
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bf8d                	j	55c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5ec:	06400793          	li	a5,100
 5f0:	02f68963          	beq	a3,a5,622 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5f4:	06c00793          	li	a5,108
 5f8:	04f68263          	beq	a3,a5,63c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5fc:	07500793          	li	a5,117
 600:	0af68063          	beq	a3,a5,6a0 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 604:	07800793          	li	a5,120
 608:	0ef68263          	beq	a3,a5,6ec <vprintf+0x1da>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	855a                	mv	a0,s6
 612:	e47ff0ef          	jal	458 <putc>
        putc(fd, c0);
 616:	85ca                	mv	a1,s2
 618:	855a                	mv	a0,s6
 61a:	e3fff0ef          	jal	458 <putc>
      state = 0;
 61e:	4981                	li	s3,0
 620:	bf35                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8913          	addi	s2,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e47ff0ef          	jal	476 <printint>
        i += 1;
 634:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b70d                	j	55c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 63c:	06400793          	li	a5,100
 640:	02f60763          	beq	a2,a5,66e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 644:	07500793          	li	a5,117
 648:	06f60963          	beq	a2,a5,6ba <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 64c:	07800793          	li	a5,120
 650:	faf61ee3          	bne	a2,a5,60c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8913          	addi	s2,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e15ff0ef          	jal	476 <printint>
        i += 2;
 666:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bdc5                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8913          	addi	s2,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dfbff0ef          	jal	476 <printint>
        i += 2;
 680:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bdd9                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000be583          	lwu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	de1ff0ef          	jal	476 <printint>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bd7d                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8913          	addi	s2,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dc9ff0ef          	jal	476 <printint>
        i += 1;
 6b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
        i += 1;
 6b8:	b555                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	dafff0ef          	jal	476 <printint>
        i += 2;
 6cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	b569                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000be583          	lwu	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d95ff0ef          	jal	476 <printint>
 6e6:	8bca                	mv	s7,s2
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd8d                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	008b8913          	addi	s2,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000bb583          	ld	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d7dff0ef          	jal	476 <printint>
        i += 1;
 6fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
        i += 1;
 704:	bda1                	j	55c <vprintf+0x4a>
 706:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 708:	008b8d13          	addi	s10,s7,8
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	855a                	mv	a0,s6
 716:	d43ff0ef          	jal	458 <putc>
  putc(fd, 'x');
 71a:	07800593          	li	a1,120
 71e:	855a                	mv	a0,s6
 720:	d39ff0ef          	jal	458 <putc>
 724:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	2aab8b93          	addi	s7,s7,682 # 9d0 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	855a                	mv	a0,s6
 73a:	d1fff0ef          	jal	458 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	slli	s3,s3,0x4
 740:	397d                	addiw	s2,s2,-1
 742:	fe0916e3          	bnez	s2,72e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 746:	8bea                	mv	s7,s10
      state = 0;
 748:	4981                	li	s3,0
 74a:	6d02                	ld	s10,0(sp)
 74c:	bd01                	j	55c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 74e:	008b8913          	addi	s2,s7,8
 752:	000bc583          	lbu	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	d01ff0ef          	jal	458 <putc>
 75c:	8bca                	mv	s7,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	bbf5                	j	55c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 762:	008b8993          	addi	s3,s7,8
 766:	000bb903          	ld	s2,0(s7)
 76a:	00090f63          	beqz	s2,788 <vprintf+0x276>
        for (; *s; s++)
 76e:	00094583          	lbu	a1,0(s2)
 772:	c195                	beqz	a1,796 <vprintf+0x284>
          putc(fd, *s);
 774:	855a                	mv	a0,s6
 776:	ce3ff0ef          	jal	458 <putc>
        for (; *s; s++)
 77a:	0905                	addi	s2,s2,1
 77c:	00094583          	lbu	a1,0(s2)
 780:	f9f5                	bnez	a1,774 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 782:	8bce                	mv	s7,s3
      state = 0;
 784:	4981                	li	s3,0
 786:	bbd9                	j	55c <vprintf+0x4a>
          s = "(null)";
 788:	00000917          	auipc	s2,0x0
 78c:	24090913          	addi	s2,s2,576 # 9c8 <malloc+0x134>
        for (; *s; s++)
 790:	02800593          	li	a1,40
 794:	b7c5                	j	774 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	b3c9                	j	55c <vprintf+0x4a>
 79c:	64a6                	ld	s1,72(sp)
 79e:	79e2                	ld	s3,56(sp)
 7a0:	7a42                	ld	s4,48(sp)
 7a2:	7aa2                	ld	s5,40(sp)
 7a4:	7b02                	ld	s6,32(sp)
 7a6:	6be2                	ld	s7,24(sp)
 7a8:	6c42                	ld	s8,16(sp)
 7aa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7ac:	60e6                	ld	ra,88(sp)
 7ae:	6446                	ld	s0,80(sp)
 7b0:	6906                	ld	s2,64(sp)
 7b2:	6125                	addi	sp,sp,96
 7b4:	8082                	ret

00000000000007b6 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 798:	715d                	addi	sp,sp,-80
 79a:	ec06                	sd	ra,24(sp)
 79c:	e822                	sd	s0,16(sp)
 79e:	1000                	addi	s0,sp,32
 7a0:	e010                	sd	a2,0(s0)
 7a2:	e414                	sd	a3,8(s0)
 7a4:	e818                	sd	a4,16(s0)
 7a6:	ec1c                	sd	a5,24(s0)
 7a8:	03043023          	sd	a6,32(s0)
 7ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b4:	8622                	mv	a2,s0
 7b6:	d3fff0ef          	jal	4f4 <vprintf>
}
 7ba:	60e2                	ld	ra,24(sp)
 7bc:	6442                	ld	s0,16(sp)
 7be:	6161                	addi	sp,sp,80
 7c0:	8082                	ret

00000000000007c2 <printf>:
=======
 7b6:	715d                	addi	sp,sp,-80
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	addi	s0,sp,32
 7be:	e010                	sd	a2,0(s0)
 7c0:	e414                	sd	a3,8(s0)
 7c2:	e818                	sd	a4,16(s0)
 7c4:	ec1c                	sd	a5,24(s0)
 7c6:	03043023          	sd	a6,32(s0)
 7ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d2:	8622                	mv	a2,s0
 7d4:	d3fff0ef          	jal	512 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6161                	addi	sp,sp,80
 7de:	8082                	ret

00000000000007e0 <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 7c2:	711d                	addi	sp,sp,-96
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	e40c                	sd	a1,8(s0)
 7cc:	e810                	sd	a2,16(s0)
 7ce:	ec14                	sd	a3,24(s0)
 7d0:	f018                	sd	a4,32(s0)
 7d2:	f41c                	sd	a5,40(s0)
 7d4:	03043823          	sd	a6,48(s0)
 7d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7dc:	00840613          	addi	a2,s0,8
 7e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e4:	85aa                	mv	a1,a0
 7e6:	4505                	li	a0,1
 7e8:	d0dff0ef          	jal	4f4 <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6125                	addi	sp,sp,96
 7f2:	8082                	ret

00000000000007f4 <free>:
=======
 7e0:	711d                	addi	sp,sp,-96
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e40c                	sd	a1,8(s0)
 7ea:	e810                	sd	a2,16(s0)
 7ec:	ec14                	sd	a3,24(s0)
 7ee:	f018                	sd	a4,32(s0)
 7f0:	f41c                	sd	a5,40(s0)
 7f2:	03043823          	sd	a6,48(s0)
 7f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	00840613          	addi	a2,s0,8
 7fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 802:	85aa                	mv	a1,a0
 804:	4505                	li	a0,1
 806:	d0dff0ef          	jal	512 <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6125                	addi	sp,sp,96
 810:	8082                	ret

0000000000000812 <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 7f4:	1141                	addi	sp,sp,-16
 7f6:	e422                	sd	s0,8(sp)
 7f8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7fa:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	00001797          	auipc	a5,0x1
 802:	8027b783          	ld	a5,-2046(a5) # 1000 <freep>
 806:	a02d                	j	830 <free+0x3c>
=======
 812:	1141                	addi	sp,sp,-16
 814:	e422                	sd	s0,8(sp)
 816:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 818:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	00000797          	auipc	a5,0x0
 820:	7e47b783          	ld	a5,2020(a5) # 1000 <freep>
 824:	a02d                	j	84e <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 808:	4618                	lw	a4,8(a2)
 80a:	9f2d                	addw	a4,a4,a1
 80c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	6398                	ld	a4,0(a5)
 812:	6310                	ld	a2,0(a4)
 814:	a83d                	j	852 <free+0x5e>
=======
 826:	4618                	lw	a4,8(a2)
 828:	9f2d                	addw	a4,a4,a1
 82a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82e:	6398                	ld	a4,0(a5)
 830:	6310                	ld	a2,0(a4)
 832:	a83d                	j	870 <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 816:	ff852703          	lw	a4,-8(a0)
 81a:	9f31                	addw	a4,a4,a2
 81c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81e:	ff053683          	ld	a3,-16(a0)
 822:	a091                	j	866 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 824:	6398                	ld	a4,0(a5)
 826:	00e7e463          	bltu	a5,a4,82e <free+0x3a>
 82a:	00e6ea63          	bltu	a3,a4,83e <free+0x4a>
{
 82e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	fed7fae3          	bgeu	a5,a3,824 <free+0x30>
 834:	6398                	ld	a4,0(a5)
 836:	00e6e463          	bltu	a3,a4,83e <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83a:	fee7eae3          	bltu	a5,a4,82e <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 83e:	ff852583          	lw	a1,-8(a0)
 842:	6390                	ld	a2,0(a5)
 844:	02059813          	slli	a6,a1,0x20
 848:	01c85713          	srli	a4,a6,0x1c
 84c:	9736                	add	a4,a4,a3
 84e:	fae60de3          	beq	a2,a4,808 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 856:	4790                	lw	a2,8(a5)
 858:	02061593          	slli	a1,a2,0x20
 85c:	01c5d713          	srli	a4,a1,0x1c
 860:	973e                	add	a4,a4,a5
 862:	fae68ae3          	beq	a3,a4,816 <free+0x22>
    p->s.ptr = bp->s.ptr;
 866:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 868:	00000717          	auipc	a4,0x0
 86c:	78f73c23          	sd	a5,1944(a4) # 1000 <freep>
}
 870:	6422                	ld	s0,8(sp)
 872:	0141                	addi	sp,sp,16
 874:	8082                	ret

0000000000000876 <malloc>:
=======
 834:	ff852703          	lw	a4,-8(a0)
 838:	9f31                	addw	a4,a4,a2
 83a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83c:	ff053683          	ld	a3,-16(a0)
 840:	a091                	j	884 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 842:	6398                	ld	a4,0(a5)
 844:	00e7e463          	bltu	a5,a4,84c <free+0x3a>
 848:	00e6ea63          	bltu	a3,a4,85c <free+0x4a>
{
 84c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	fed7fae3          	bgeu	a5,a3,842 <free+0x30>
 852:	6398                	ld	a4,0(a5)
 854:	00e6e463          	bltu	a3,a4,85c <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	fee7eae3          	bltu	a5,a4,84c <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 85c:	ff852583          	lw	a1,-8(a0)
 860:	6390                	ld	a2,0(a5)
 862:	02059813          	slli	a6,a1,0x20
 866:	01c85713          	srli	a4,a6,0x1c
 86a:	9736                	add	a4,a4,a3
 86c:	fae60de3          	beq	a2,a4,826 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 874:	4790                	lw	a2,8(a5)
 876:	02061593          	slli	a1,a2,0x20
 87a:	01c5d713          	srli	a4,a1,0x1c
 87e:	973e                	add	a4,a4,a5
 880:	fae68ae3          	beq	a3,a4,834 <free+0x22>
    p->s.ptr = bp->s.ptr;
 884:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 886:	00000717          	auipc	a4,0x0
 88a:	76f73d23          	sd	a5,1914(a4) # 1000 <freep>
}
 88e:	6422                	ld	s0,8(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret

0000000000000894 <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 876:	7139                	addi	sp,sp,-64
 878:	fc06                	sd	ra,56(sp)
 87a:	f822                	sd	s0,48(sp)
 87c:	f426                	sd	s1,40(sp)
 87e:	ec4e                	sd	s3,24(sp)
 880:	0080                	addi	s0,sp,64
=======
 894:	7139                	addi	sp,sp,-64
 896:	fc06                	sd	ra,56(sp)
 898:	f822                	sd	s0,48(sp)
 89a:	f426                	sd	s1,40(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 882:	02051493          	slli	s1,a0,0x20
 886:	9081                	srli	s1,s1,0x20
 888:	04bd                	addi	s1,s1,15
 88a:	8091                	srli	s1,s1,0x4
 88c:	0014899b          	addiw	s3,s1,1
 890:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 892:	00000517          	auipc	a0,0x0
 896:	76e53503          	ld	a0,1902(a0) # 1000 <freep>
 89a:	c915                	beqz	a0,8ce <malloc+0x58>
=======
 8a0:	02051493          	slli	s1,a0,0x20
 8a4:	9081                	srli	s1,s1,0x20
 8a6:	04bd                	addi	s1,s1,15
 8a8:	8091                	srli	s1,s1,0x4
 8aa:	0014899b          	addiw	s3,s1,1
 8ae:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8b0:	00000517          	auipc	a0,0x0
 8b4:	75053503          	ld	a0,1872(a0) # 1000 <freep>
 8b8:	c915                	beqz	a0,8ec <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 89c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 89e:	4798                	lw	a4,8(a5)
 8a0:	08977a63          	bgeu	a4,s1,934 <malloc+0xbe>
 8a4:	f04a                	sd	s2,32(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ac:	8a4e                	mv	s4,s3
 8ae:	0009871b          	sext.w	a4,s3
 8b2:	6685                	lui	a3,0x1
 8b4:	00d77363          	bgeu	a4,a3,8ba <malloc+0x44>
 8b8:	6a05                	lui	s4,0x1
 8ba:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8be:	004a1a1b          	slliw	s4,s4,0x4
=======
 8ba:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8bc:	4798                	lw	a4,8(a5)
 8be:	08977a63          	bgeu	a4,s1,952 <malloc+0xbe>
 8c2:	f04a                	sd	s2,32(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ca:	8a4e                	mv	s4,s3
 8cc:	0009871b          	sext.w	a4,s3
 8d0:	6685                	lui	a3,0x1
 8d2:	00d77363          	bgeu	a4,a3,8d8 <malloc+0x44>
 8d6:	6a05                	lui	s4,0x1
 8d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8dc:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 8c2:	00000917          	auipc	s2,0x0
 8c6:	73e90913          	addi	s2,s2,1854 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ca:	5afd                	li	s5,-1
 8cc:	a081                	j	90c <malloc+0x96>
 8ce:	f04a                	sd	s2,32(sp)
 8d0:	e852                	sd	s4,16(sp)
 8d2:	e456                	sd	s5,8(sp)
 8d4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d6:	00000797          	auipc	a5,0x0
 8da:	73a78793          	addi	a5,a5,1850 # 1010 <base>
 8de:	00000717          	auipc	a4,0x0
 8e2:	72f73123          	sd	a5,1826(a4) # 1000 <freep>
 8e6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8ec:	b7c1                	j	8ac <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ee:	6398                	ld	a4,0(a5)
 8f0:	e118                	sd	a4,0(a0)
 8f2:	a8a9                	j	94c <malloc+0xd6>
  hp->s.size = nu;
 8f4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8f8:	0541                	addi	a0,a0,16
 8fa:	efbff0ef          	jal	7f4 <free>
  return freep;
 8fe:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 902:	c12d                	beqz	a0,964 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 904:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 906:	4798                	lw	a4,8(a5)
 908:	02977263          	bgeu	a4,s1,92c <malloc+0xb6>
    if (p == freep)
 90c:	00093703          	ld	a4,0(s2)
 910:	853e                	mv	a0,a5
 912:	fef719e3          	bne	a4,a5,904 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 916:	8552                	mv	a0,s4
 918:	9afff0ef          	jal	2c6 <sbrk>
  if (p == SBRK_ERROR)
 91c:	fd551ce3          	bne	a0,s5,8f4 <malloc+0x7e>
        return 0;
 920:	4501                	li	a0,0
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	a03d                	j	958 <malloc+0xe2>
 92c:	7902                	ld	s2,32(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 934:	fae48de3          	beq	s1,a4,8ee <malloc+0x78>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	02071693          	slli	a3,a4,0x20
 942:	01c6d713          	srli	a4,a3,0x1c
 946:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 948:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94c:	00000717          	auipc	a4,0x0
 950:	6aa73a23          	sd	a0,1716(a4) # 1000 <freep>
      return (void *)(p + 1);
 954:	01078513          	addi	a0,a5,16
  }
}
 958:	70e2                	ld	ra,56(sp)
 95a:	7442                	ld	s0,48(sp)
 95c:	74a2                	ld	s1,40(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6121                	addi	sp,sp,64
 962:	8082                	ret
 964:	7902                	ld	s2,32(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	b7f5                	j	958 <malloc+0xe2>
=======
 8e0:	00000917          	auipc	s2,0x0
 8e4:	72090913          	addi	s2,s2,1824 # 1000 <freep>
  if (p == SBRK_ERROR)
 8e8:	5afd                	li	s5,-1
 8ea:	a081                	j	92a <malloc+0x96>
 8ec:	f04a                	sd	s2,32(sp)
 8ee:	e852                	sd	s4,16(sp)
 8f0:	e456                	sd	s5,8(sp)
 8f2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f4:	00000797          	auipc	a5,0x0
 8f8:	71c78793          	addi	a5,a5,1820 # 1010 <base>
 8fc:	00000717          	auipc	a4,0x0
 900:	70f73223          	sd	a5,1796(a4) # 1000 <freep>
 904:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 906:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 90a:	b7c1                	j	8ca <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	e118                	sd	a4,0(a0)
 910:	a8a9                	j	96a <malloc+0xd6>
  hp->s.size = nu;
 912:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 916:	0541                	addi	a0,a0,16
 918:	efbff0ef          	jal	812 <free>
  return freep;
 91c:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 920:	c12d                	beqz	a0,982 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 922:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 924:	4798                	lw	a4,8(a5)
 926:	02977263          	bgeu	a4,s1,94a <malloc+0xb6>
    if (p == freep)
 92a:	00093703          	ld	a4,0(s2)
 92e:	853e                	mv	a0,a5
 930:	fef719e3          	bne	a4,a5,922 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 934:	8552                	mv	a0,s4
 936:	991ff0ef          	jal	2c6 <sbrk>
  if (p == SBRK_ERROR)
 93a:	fd551ce3          	bne	a0,s5,912 <malloc+0x7e>
        return 0;
 93e:	4501                	li	a0,0
 940:	7902                	ld	s2,32(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	a03d                	j	976 <malloc+0xe2>
 94a:	7902                	ld	s2,32(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 952:	fae48de3          	beq	s1,a4,90c <malloc+0x78>
        p->s.size -= nunits;
 956:	4137073b          	subw	a4,a4,s3
 95a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 95c:	02071693          	slli	a3,a4,0x20
 960:	01c6d713          	srli	a4,a3,0x1c
 964:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 966:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96a:	00000717          	auipc	a4,0x0
 96e:	68a73b23          	sd	a0,1686(a4) # 1000 <freep>
      return (void *)(p + 1);
 972:	01078513          	addi	a0,a5,16
  }
}
 976:	70e2                	ld	ra,56(sp)
 978:	7442                	ld	s0,48(sp)
 97a:	74a2                	ld	s1,40(sp)
 97c:	69e2                	ld	s3,24(sp)
 97e:	6121                	addi	sp,sp,64
 980:	8082                	ret
 982:	7902                	ld	s2,32(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	b7f5                	j	976 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
