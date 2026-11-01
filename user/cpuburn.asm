
user/_cpuburn:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  volatile uint64 i;

  for(;;){
    for(i = 0; i < 1000000000ULL; i++)
   8:	3b9ad737          	lui	a4,0x3b9ad
   c:	9ff70713          	addi	a4,a4,-1537 # 3b9ac9ff <base+0x3b9ab9ef>
  10:	fe043423          	sd	zero,-24(s0)
  14:	fe843783          	ld	a5,-24(s0)
  18:	fef76ce3          	bltu	a4,a5,10 <main+0x10>
  1c:	fe843783          	ld	a5,-24(s0)
  20:	0785                	addi	a5,a5,1
  22:	fef43423          	sd	a5,-24(s0)
  26:	fe843783          	ld	a5,-24(s0)
  2a:	fef779e3          	bgeu	a4,a5,1c <main+0x1c>
  2e:	b7cd                	j	10 <main+0x10>

0000000000000030 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  38:	fc9ff0ef          	jal	0 <main>
  exit(r);
  3c:	2bc000ef          	jal	2f8 <exit>

0000000000000040 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  40:	1141                	addi	sp,sp,-16
  42:	e406                	sd	ra,8(sp)
  44:	e022                	sd	s0,0(sp)
  46:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  48:	87aa                	mv	a5,a0
  4a:	0585                	addi	a1,a1,1
  4c:	0785                	addi	a5,a5,1
  4e:	fff5c703          	lbu	a4,-1(a1)
  52:	fee78fa3          	sb	a4,-1(a5)
  56:	fb75                	bnez	a4,4a <strcpy+0xa>
    ;
  return os;
}
  58:	60a2                	ld	ra,8(sp)
  5a:	6402                	ld	s0,0(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	addi	sp,sp,-16
  62:	e406                	sd	ra,8(sp)
  64:	e022                	sd	s0,0(sp)
  66:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	cb91                	beqz	a5,80 <strcmp+0x20>
  6e:	0005c703          	lbu	a4,0(a1)
  72:	00f71763          	bne	a4,a5,80 <strcmp+0x20>
    p++, q++;
  76:	0505                	addi	a0,a0,1
  78:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	fbe5                	bnez	a5,6e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  80:	0005c503          	lbu	a0,0(a1)
}
  84:	40a7853b          	subw	a0,a5,a0
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	addi	sp,sp,16
  8e:	8082                	ret

0000000000000090 <strlen>:

uint
strlen(const char *s)
{
  90:	1141                	addi	sp,sp,-16
  92:	e406                	sd	ra,8(sp)
  94:	e022                	sd	s0,0(sp)
  96:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  98:	00054783          	lbu	a5,0(a0)
  9c:	cf99                	beqz	a5,ba <strlen+0x2a>
  9e:	0505                	addi	a0,a0,1
  a0:	87aa                	mv	a5,a0
  a2:	86be                	mv	a3,a5
  a4:	0785                	addi	a5,a5,1
  a6:	fff7c703          	lbu	a4,-1(a5)
  aa:	ff65                	bnez	a4,a2 <strlen+0x12>
  ac:	40a6853b          	subw	a0,a3,a0
  b0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  b2:	60a2                	ld	ra,8(sp)
  b4:	6402                	ld	s0,0(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret
  for (n = 0; s[n]; n++)
  ba:	4501                	li	a0,0
  bc:	bfdd                	j	b2 <strlen+0x22>

00000000000000be <memset>:

void *
memset(void *dst, int c, uint n)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  c6:	ca19                	beqz	a2,dc <memset+0x1e>
  c8:	87aa                	mv	a5,a0
  ca:	1602                	slli	a2,a2,0x20
  cc:	9201                	srli	a2,a2,0x20
  ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  d6:	0785                	addi	a5,a5,1
  d8:	fee79de3          	bne	a5,a4,d2 <memset+0x14>
  }
  return dst;
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strchr>:

char *
strchr(const char *s, char c)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  for (; *s; s++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf81                	beqz	a5,108 <strchr+0x24>
    if (*s == c)
  f2:	00f58763          	beq	a1,a5,100 <strchr+0x1c>
  for (; *s; s++)
  f6:	0505                	addi	a0,a0,1
  f8:	00054783          	lbu	a5,0(a0)
  fc:	fbfd                	bnez	a5,f2 <strchr+0xe>
      return (char *)s;
  return 0;
  fe:	4501                	li	a0,0
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  return 0;
 108:	4501                	li	a0,0
 10a:	bfdd                	j	100 <strchr+0x1c>

000000000000010c <gets>:

char *
gets(char *buf, int max)
{
 10c:	7159                	addi	sp,sp,-112
 10e:	f486                	sd	ra,104(sp)
 110:	f0a2                	sd	s0,96(sp)
 112:	eca6                	sd	s1,88(sp)
 114:	e8ca                	sd	s2,80(sp)
 116:	e4ce                	sd	s3,72(sp)
 118:	e0d2                	sd	s4,64(sp)
 11a:	fc56                	sd	s5,56(sp)
 11c:	f85a                	sd	s6,48(sp)
 11e:	f45e                	sd	s7,40(sp)
 120:	f062                	sd	s8,32(sp)
 122:	ec66                	sd	s9,24(sp)
 124:	e86a                	sd	s10,16(sp)
 126:	1880                	addi	s0,sp,112
 128:	8caa                	mv	s9,a0
 12a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 12c:	892a                	mv	s2,a0
 12e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 130:	f9f40b13          	addi	s6,s0,-97
 134:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 136:	4ba9                	li	s7,10
 138:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 13a:	8d26                	mv	s10,s1
 13c:	0014899b          	addiw	s3,s1,1
 140:	84ce                	mv	s1,s3
 142:	0349d563          	bge	s3,s4,16c <gets+0x60>
    cc = read(0, &c, 1);
 146:	8656                	mv	a2,s5
 148:	85da                	mv	a1,s6
 14a:	4501                	li	a0,0
 14c:	1c4000ef          	jal	310 <read>
    if (cc < 1)
 150:	00a05e63          	blez	a0,16c <gets+0x60>
    buf[i++] = c;
 154:	f9f44783          	lbu	a5,-97(s0)
 158:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 15c:	01778763          	beq	a5,s7,16a <gets+0x5e>
 160:	0905                	addi	s2,s2,1
 162:	fd879ce3          	bne	a5,s8,13a <gets+0x2e>
    buf[i++] = c;
 166:	8d4e                	mv	s10,s3
 168:	a011                	j	16c <gets+0x60>
 16a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 16c:	9d66                	add	s10,s10,s9
 16e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 172:	8566                	mv	a0,s9
 174:	70a6                	ld	ra,104(sp)
 176:	7406                	ld	s0,96(sp)
 178:	64e6                	ld	s1,88(sp)
 17a:	6946                	ld	s2,80(sp)
 17c:	69a6                	ld	s3,72(sp)
 17e:	6a06                	ld	s4,64(sp)
 180:	7ae2                	ld	s5,56(sp)
 182:	7b42                	ld	s6,48(sp)
 184:	7ba2                	ld	s7,40(sp)
 186:	7c02                	ld	s8,32(sp)
 188:	6ce2                	ld	s9,24(sp)
 18a:	6d42                	ld	s10,16(sp)
 18c:	6165                	addi	sp,sp,112
 18e:	8082                	ret

0000000000000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	1101                	addi	sp,sp,-32
 192:	ec06                	sd	ra,24(sp)
 194:	e822                	sd	s0,16(sp)
 196:	e04a                	sd	s2,0(sp)
 198:	1000                	addi	s0,sp,32
 19a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19c:	4581                	li	a1,0
 19e:	19a000ef          	jal	338 <open>
  if (fd < 0)
 1a2:	02054263          	bltz	a0,1c6 <stat+0x36>
 1a6:	e426                	sd	s1,8(sp)
 1a8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1aa:	85ca                	mv	a1,s2
 1ac:	1a4000ef          	jal	350 <fstat>
 1b0:	892a                	mv	s2,a0
  close(fd);
 1b2:	8526                	mv	a0,s1
 1b4:	16c000ef          	jal	320 <close>
  return r;
 1b8:	64a2                	ld	s1,8(sp)
}
 1ba:	854a                	mv	a0,s2
 1bc:	60e2                	ld	ra,24(sp)
 1be:	6442                	ld	s0,16(sp)
 1c0:	6902                	ld	s2,0(sp)
 1c2:	6105                	addi	sp,sp,32
 1c4:	8082                	ret
    return -1;
 1c6:	597d                	li	s2,-1
 1c8:	bfcd                	j	1ba <stat+0x2a>

00000000000001ca <atoi>:

int
atoi(const char *s)
{
 1ca:	1141                	addi	sp,sp,-16
 1cc:	e406                	sd	ra,8(sp)
 1ce:	e022                	sd	s0,0(sp)
 1d0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1d2:	00054683          	lbu	a3,0(a0)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	4625                	li	a2,9
 1e0:	02f66963          	bltu	a2,a5,212 <atoi+0x48>
 1e4:	872a                	mv	a4,a0
  n = 0;
 1e6:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1e8:	0705                	addi	a4,a4,1
 1ea:	0025179b          	slliw	a5,a0,0x2
 1ee:	9fa9                	addw	a5,a5,a0
 1f0:	0017979b          	slliw	a5,a5,0x1
 1f4:	9fb5                	addw	a5,a5,a3
 1f6:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1fa:	00074683          	lbu	a3,0(a4)
 1fe:	fd06879b          	addiw	a5,a3,-48
 202:	0ff7f793          	zext.b	a5,a5
 206:	fef671e3          	bgeu	a2,a5,1e8 <atoi+0x1e>
  return n;
}
 20a:	60a2                	ld	ra,8(sp)
 20c:	6402                	ld	s0,0(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  n = 0;
 212:	4501                	li	a0,0
 214:	bfdd                	j	20a <atoi+0x40>

0000000000000216 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21e:	02b57563          	bgeu	a0,a1,248 <memmove+0x32>
    while (n-- > 0)
 222:	00c05f63          	blez	a2,240 <memmove+0x2a>
 226:	1602                	slli	a2,a2,0x20
 228:	9201                	srli	a2,a2,0x20
 22a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22e:	872a                	mv	a4,a0
      *dst++ = *src++;
 230:	0585                	addi	a1,a1,1
 232:	0705                	addi	a4,a4,1
 234:	fff5c683          	lbu	a3,-1(a1)
 238:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 23c:	fee79ae3          	bne	a5,a4,230 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 240:	60a2                	ld	ra,8(sp)
 242:	6402                	ld	s0,0(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
    dst += n;
 248:	00c50733          	add	a4,a0,a2
    src += n;
 24c:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 24e:	fec059e3          	blez	a2,240 <memmove+0x2a>
 252:	fff6079b          	addiw	a5,a2,-1
 256:	1782                	slli	a5,a5,0x20
 258:	9381                	srli	a5,a5,0x20
 25a:	fff7c793          	not	a5,a5
 25e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 260:	15fd                	addi	a1,a1,-1
 262:	177d                	addi	a4,a4,-1
 264:	0005c683          	lbu	a3,0(a1)
 268:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 26c:	fef71ae3          	bne	a4,a5,260 <memmove+0x4a>
 270:	bfc1                	j	240 <memmove+0x2a>

0000000000000272 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 272:	1141                	addi	sp,sp,-16
 274:	e406                	sd	ra,8(sp)
 276:	e022                	sd	s0,0(sp)
 278:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27a:	ca0d                	beqz	a2,2ac <memcmp+0x3a>
 27c:	fff6069b          	addiw	a3,a2,-1
 280:	1682                	slli	a3,a3,0x20
 282:	9281                	srli	a3,a3,0x20
 284:	0685                	addi	a3,a3,1
 286:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 294:	0505                	addi	a0,a0,1
    p2++;
 296:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x16>
  }
  return 0;
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x32>
      return *p1 - *p2;
 2a0:	40e7853b          	subw	a0,a5,a4
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  return 0;
 2ac:	4501                	li	a0,0
 2ae:	bfdd                	j	2a4 <memcmp+0x32>

00000000000002b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b8:	f5fff0ef          	jal	216 <memmove>
}
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <sbrk>:

char *
sbrk(int n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2cc:	4585                	li	a1,1
 2ce:	0b2000ef          	jal	380 <sys_sbrk>
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret

00000000000002da <sbrklazy>:

char *
sbrklazy(int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2e2:	4589                	li	a1,2
 2e4:	09c000ef          	jal	380 <sys_sbrk>
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f0:	4885                	li	a7,1
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f8:	4889                	li	a7,2
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <wait>:
.global wait
wait:
 li a7, SYS_wait
 300:	488d                	li	a7,3
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 308:	4891                	li	a7,4
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <read>:
.global read
read:
 li a7, SYS_read
 310:	4895                	li	a7,5
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <write>:
.global write
write:
 li a7, SYS_write
 318:	48c1                	li	a7,16
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <close>:
.global close
close:
 li a7, SYS_close
 320:	48d5                	li	a7,21
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <kill>:
.global kill
kill:
 li a7, SYS_kill
 328:	4899                	li	a7,6
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <exec>:
.global exec
exec:
 li a7, SYS_exec
 330:	489d                	li	a7,7
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <open>:
.global open
open:
 li a7, SYS_open
 338:	48bd                	li	a7,15
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 340:	48c5                	li	a7,17
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 348:	48c9                	li	a7,18
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 350:	48a1                	li	a7,8
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <link>:
.global link
link:
 li a7, SYS_link
 358:	48cd                	li	a7,19
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 360:	48d1                	li	a7,20
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 368:	48a5                	li	a7,9
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <dup>:
.global dup
dup:
 li a7, SYS_dup
 370:	48a9                	li	a7,10
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 378:	48ad                	li	a7,11
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 380:	48b1                	li	a7,12
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <pause>:
.global pause
pause:
 li a7, SYS_pause
 388:	48b5                	li	a7,13
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 390:	48b9                	li	a7,14
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sync>:
.global sync
sync:
 li a7, SYS_sync
 398:	48d9                	li	a7,22
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3a0:	48dd                	li	a7,23
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3a8:	48e1                	li	a7,24
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3b0:	48e5                	li	a7,25
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3b8:	48e9                	li	a7,26
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c0:	48ed                	li	a7,27
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3c8:	48f1                	li	a7,28
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3d0:	48f5                	li	a7,29
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3d8:	48f9                	li	a7,30
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3e0:	48fd                	li	a7,31
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3e8:	02000893          	li	a7,32
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <halt>:
.global halt
halt:
 li a7, SYS_halt
 3f2:	02100893          	li	a7,33
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 3fc:	02200893          	li	a7,34
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 406:	02300893          	li	a7,35
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 410:	02400893          	li	a7,36
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 41a:	02500893          	li	a7,37
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 424:	1101                	addi	sp,sp,-32
 426:	ec06                	sd	ra,24(sp)
 428:	e822                	sd	s0,16(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 430:	4605                	li	a2,1
 432:	fef40593          	addi	a1,s0,-17
 436:	ee3ff0ef          	jal	318 <write>
}
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret

0000000000000442 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 442:	715d                	addi	sp,sp,-80
 444:	e486                	sd	ra,72(sp)
 446:	e0a2                	sd	s0,64(sp)
 448:	fc26                	sd	s1,56(sp)
 44a:	f84a                	sd	s2,48(sp)
 44c:	f44e                	sd	s3,40(sp)
 44e:	0880                	addi	s0,sp,80
 450:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 452:	c299                	beqz	a3,458 <printint+0x16>
 454:	0605cc63          	bltz	a1,4cc <printint+0x8a>
  neg = 0;
 458:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 45a:	fb840313          	addi	t1,s0,-72
  neg = 0;
 45e:	869a                	mv	a3,t1
  i = 0;
 460:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 462:	00000817          	auipc	a6,0x0
 466:	4f680813          	addi	a6,a6,1270 # 958 <digits>
 46a:	88be                	mv	a7,a5
 46c:	0017851b          	addiw	a0,a5,1
 470:	87aa                	mv	a5,a0
 472:	02c5f733          	remu	a4,a1,a2
 476:	9742                	add	a4,a4,a6
 478:	00074703          	lbu	a4,0(a4)
 47c:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 480:	872e                	mv	a4,a1
 482:	02c5d5b3          	divu	a1,a1,a2
 486:	0685                	addi	a3,a3,1
 488:	fec771e3          	bgeu	a4,a2,46a <printint+0x28>
  if (neg)
 48c:	000e0c63          	beqz	t3,4a4 <printint+0x62>
    buf[i++] = '-';
 490:	fd050793          	addi	a5,a0,-48
 494:	00878533          	add	a0,a5,s0
 498:	02d00793          	li	a5,45
 49c:	fef50423          	sb	a5,-24(a0)
 4a0:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4a4:	fff7899b          	addiw	s3,a5,-1
 4a8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ac:	fff4c583          	lbu	a1,-1(s1)
 4b0:	854a                	mv	a0,s2
 4b2:	f73ff0ef          	jal	424 <putc>
  while (--i >= 0)
 4b6:	39fd                	addiw	s3,s3,-1
 4b8:	14fd                	addi	s1,s1,-1
 4ba:	fe09d9e3          	bgez	s3,4ac <printint+0x6a>
}
 4be:	60a6                	ld	ra,72(sp)
 4c0:	6406                	ld	s0,64(sp)
 4c2:	74e2                	ld	s1,56(sp)
 4c4:	7942                	ld	s2,48(sp)
 4c6:	79a2                	ld	s3,40(sp)
 4c8:	6161                	addi	sp,sp,80
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005b3          	neg	a1,a1
    neg = 1;
 4d0:	4e05                	li	t3,1
    x = -xx;
 4d2:	b761                	j	45a <printint+0x18>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	711d                	addi	sp,sp,-96
 4d6:	ec86                	sd	ra,88(sp)
 4d8:	e8a2                	sd	s0,80(sp)
 4da:	e4a6                	sd	s1,72(sp)
 4dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4de:	0005c483          	lbu	s1,0(a1)
 4e2:	28048463          	beqz	s1,76a <vprintf+0x296>
 4e6:	e0ca                	sd	s2,64(sp)
 4e8:	fc4e                	sd	s3,56(sp)
 4ea:	f852                	sd	s4,48(sp)
 4ec:	f456                	sd	s5,40(sp)
 4ee:	f05a                	sd	s6,32(sp)
 4f0:	ec5e                	sd	s7,24(sp)
 4f2:	e862                	sd	s8,16(sp)
 4f4:	e466                	sd	s9,8(sp)
 4f6:	8b2a                	mv	s6,a0
 4f8:	8a2e                	mv	s4,a1
 4fa:	8bb2                	mv	s7,a2
  state = 0;
 4fc:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4fe:	4901                	li	s2,0
 500:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 50a:	06c00c93          	li	s9,108
 50e:	a00d                	j	530 <vprintf+0x5c>
        putc(fd, c0);
 510:	85a6                	mv	a1,s1
 512:	855a                	mv	a0,s6
 514:	f11ff0ef          	jal	424 <putc>
 518:	a019                	j	51e <vprintf+0x4a>
    } else if (state == '%') {
 51a:	03598363          	beq	s3,s5,540 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 51e:	0019079b          	addiw	a5,s2,1
 522:	893e                	mv	s2,a5
 524:	873e                	mv	a4,a5
 526:	97d2                	add	a5,a5,s4
 528:	0007c483          	lbu	s1,0(a5)
 52c:	22048763          	beqz	s1,75a <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 530:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 534:	fe0993e3          	bnez	s3,51a <vprintf+0x46>
      if (c0 == '%') {
 538:	fd579ce3          	bne	a5,s5,510 <vprintf+0x3c>
        state = '%';
 53c:	89be                	mv	s3,a5
 53e:	b7c5                	j	51e <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 540:	00ea06b3          	add	a3,s4,a4
 544:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 548:	8636                	mv	a2,a3
      if (c1)
 54a:	c681                	beqz	a3,552 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 54c:	9752                	add	a4,a4,s4
 54e:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 552:	05878263          	beq	a5,s8,596 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 556:	05978c63          	beq	a5,s9,5ae <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 55a:	07500713          	li	a4,117
 55e:	0ee78663          	beq	a5,a4,64a <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 562:	07800713          	li	a4,120
 566:	12e78863          	beq	a5,a4,696 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 56a:	07000713          	li	a4,112
 56e:	14e78d63          	beq	a5,a4,6c8 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 572:	06300713          	li	a4,99
 576:	18e78c63          	beq	a5,a4,70e <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 57a:	07300713          	li	a4,115
 57e:	1ae78263          	beq	a5,a4,722 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 582:	02500713          	li	a4,37
 586:	04e79463          	bne	a5,a4,5ce <vprintf+0xfa>
        putc(fd, '%');
 58a:	85ba                	mv	a1,a4
 58c:	855a                	mv	a0,s6
 58e:	e97ff0ef          	jal	424 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 592:	4981                	li	s3,0
 594:	b769                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 596:	008b8493          	addi	s1,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	e9fff0ef          	jal	442 <printint>
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bf8d                	j	51e <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5ae:	06400793          	li	a5,100
 5b2:	02f68963          	beq	a3,a5,5e4 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5b6:	06c00793          	li	a5,108
 5ba:	04f68263          	beq	a3,a5,5fe <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5be:	07500793          	li	a5,117
 5c2:	0af68063          	beq	a3,a5,662 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5c6:	07800793          	li	a5,120
 5ca:	0ef68263          	beq	a3,a5,6ae <vprintf+0x1da>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e51ff0ef          	jal	424 <putc>
        putc(fd, c0);
 5d8:	85a6                	mv	a1,s1
 5da:	855a                	mv	a0,s6
 5dc:	e49ff0ef          	jal	424 <putc>
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	bf35                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e51ff0ef          	jal	442 <printint>
        i += 1;
 5f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
        i += 1;
 5fc:	b70d                	j	51e <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5fe:	06400793          	li	a5,100
 602:	02f60763          	beq	a2,a5,630 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 606:	07500793          	li	a5,117
 60a:	06f60963          	beq	a2,a5,67c <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 60e:	07800793          	li	a5,120
 612:	faf61ee3          	bne	a2,a5,5ce <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e1fff0ef          	jal	442 <printint>
        i += 2;
 628:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bdc5                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8493          	addi	s1,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e05ff0ef          	jal	442 <printint>
        i += 2;
 642:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bdd9                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000be583          	lwu	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	debff0ef          	jal	442 <printint>
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	bd7d                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	dd3ff0ef          	jal	442 <printint>
        i += 1;
 674:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 1;
 67a:	b555                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	db9ff0ef          	jal	442 <printint>
        i += 2;
 68e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	b569                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000be583          	lwu	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	d9fff0ef          	jal	442 <printint>
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd8d                	j	51e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	d87ff0ef          	jal	442 <printint>
        i += 1;
 6c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	bda1                	j	51e <vprintf+0x4a>
 6c8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b8d13          	addi	s10,s7,8
 6ce:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d2:	03000593          	li	a1,48
 6d6:	855a                	mv	a0,s6
 6d8:	d4dff0ef          	jal	424 <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	855a                	mv	a0,s6
 6e2:	d43ff0ef          	jal	424 <putc>
 6e6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6e8:	00000b97          	auipc	s7,0x0
 6ec:	270b8b93          	addi	s7,s7,624 # 958 <digits>
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97de                	add	a5,a5,s7
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	855a                	mv	a0,s6
 6fc:	d29ff0ef          	jal	424 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 700:	0992                	slli	s3,s3,0x4
 702:	34fd                	addiw	s1,s1,-1
 704:	f4f5                	bnez	s1,6f0 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 706:	8bea                	mv	s7,s10
      state = 0;
 708:	4981                	li	s3,0
 70a:	6d02                	ld	s10,0(sp)
 70c:	bd09                	j	51e <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 70e:	008b8493          	addi	s1,s7,8
 712:	000bc583          	lbu	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	d0dff0ef          	jal	424 <putc>
 71c:	8ba6                	mv	s7,s1
      state = 0;
 71e:	4981                	li	s3,0
 720:	bbfd                	j	51e <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 722:	008b8993          	addi	s3,s7,8
 726:	000bb483          	ld	s1,0(s7)
 72a:	cc91                	beqz	s1,746 <vprintf+0x272>
        for (; *s; s++)
 72c:	0004c583          	lbu	a1,0(s1)
 730:	c195                	beqz	a1,754 <vprintf+0x280>
          putc(fd, *s);
 732:	855a                	mv	a0,s6
 734:	cf1ff0ef          	jal	424 <putc>
        for (; *s; s++)
 738:	0485                	addi	s1,s1,1
 73a:	0004c583          	lbu	a1,0(s1)
 73e:	f9f5                	bnez	a1,732 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 740:	8bce                	mv	s7,s3
      state = 0;
 742:	4981                	li	s3,0
 744:	bbe9                	j	51e <vprintf+0x4a>
          s = "(null)";
 746:	00000497          	auipc	s1,0x0
 74a:	20a48493          	addi	s1,s1,522 # 950 <malloc+0xfa>
        for (; *s; s++)
 74e:	02800593          	li	a1,40
 752:	b7c5                	j	732 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 754:	8bce                	mv	s7,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	b3d9                	j	51e <vprintf+0x4a>
 75a:	6906                	ld	s2,64(sp)
 75c:	79e2                	ld	s3,56(sp)
 75e:	7a42                	ld	s4,48(sp)
 760:	7aa2                	ld	s5,40(sp)
 762:	7b02                	ld	s6,32(sp)
 764:	6be2                	ld	s7,24(sp)
 766:	6c42                	ld	s8,16(sp)
 768:	6ca2                	ld	s9,8(sp)
    }
  }
}
 76a:	60e6                	ld	ra,88(sp)
 76c:	6446                	ld	s0,80(sp)
 76e:	64a6                	ld	s1,72(sp)
 770:	6125                	addi	sp,sp,96
 772:	8082                	ret

0000000000000774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 774:	715d                	addi	sp,sp,-80
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e010                	sd	a2,0(s0)
 77e:	e414                	sd	a3,8(s0)
 780:	e818                	sd	a4,16(s0)
 782:	ec1c                	sd	a5,24(s0)
 784:	03043023          	sd	a6,32(s0)
 788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	8622                	mv	a2,s0
 78e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 792:	d43ff0ef          	jal	4d4 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6161                	addi	sp,sp,80
 79c:	8082                	ret

000000000000079e <printf>:

void
printf(const char *fmt, ...)
{
 79e:	711d                	addi	sp,sp,-96
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e40c                	sd	a1,8(s0)
 7a8:	e810                	sd	a2,16(s0)
 7aa:	ec14                	sd	a3,24(s0)
 7ac:	f018                	sd	a4,32(s0)
 7ae:	f41c                	sd	a5,40(s0)
 7b0:	03043823          	sd	a6,48(s0)
 7b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	00840613          	addi	a2,s0,8
 7bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c0:	85aa                	mv	a1,a0
 7c2:	4505                	li	a0,1
 7c4:	d11ff0ef          	jal	4d4 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	1141                	addi	sp,sp,-16
 7d2:	e406                	sd	ra,8(sp)
 7d4:	e022                	sd	s0,0(sp)
 7d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d8:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	00001797          	auipc	a5,0x1
 7e0:	8247b783          	ld	a5,-2012(a5) # 1000 <freep>
 7e4:	a02d                	j	80e <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7e6:	4618                	lw	a4,8(a2)
 7e8:	9f2d                	addw	a4,a4,a1
 7ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ee:	6398                	ld	a4,0(a5)
 7f0:	6310                	ld	a2,0(a4)
 7f2:	a83d                	j	830 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7f4:	ff852703          	lw	a4,-8(a0)
 7f8:	9f31                	addw	a4,a4,a2
 7fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fc:	ff053683          	ld	a3,-16(a0)
 800:	a091                	j	844 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	6398                	ld	a4,0(a5)
 804:	00e7e463          	bltu	a5,a4,80c <free+0x3c>
 808:	00e6ea63          	bltu	a3,a4,81c <free+0x4c>
{
 80c:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	fed7fae3          	bgeu	a5,a3,802 <free+0x32>
 812:	6398                	ld	a4,0(a5)
 814:	00e6e463          	bltu	a3,a4,81c <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	fee7eae3          	bltu	a5,a4,80c <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 81c:	ff852583          	lw	a1,-8(a0)
 820:	6390                	ld	a2,0(a5)
 822:	02059813          	slli	a6,a1,0x20
 826:	01c85713          	srli	a4,a6,0x1c
 82a:	9736                	add	a4,a4,a3
 82c:	fae60de3          	beq	a2,a4,7e6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 834:	4790                	lw	a2,8(a5)
 836:	02061593          	slli	a1,a2,0x20
 83a:	01c5d713          	srli	a4,a1,0x1c
 83e:	973e                	add	a4,a4,a5
 840:	fae68ae3          	beq	a3,a4,7f4 <free+0x24>
    p->s.ptr = bp->s.ptr;
 844:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
}
 84e:	60a2                	ld	ra,8(sp)
 850:	6402                	ld	s0,0(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f04a                	sd	s2,32(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 862:	02051993          	slli	s3,a0,0x20
 866:	0209d993          	srli	s3,s3,0x20
 86a:	09bd                	addi	s3,s3,15
 86c:	0049d993          	srli	s3,s3,0x4
 870:	2985                	addiw	s3,s3,1
 872:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 874:	00000517          	auipc	a0,0x0
 878:	78c53503          	ld	a0,1932(a0) # 1000 <freep>
 87c:	c905                	beqz	a0,8ac <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 87e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 880:	4798                	lw	a4,8(a5)
 882:	09377663          	bgeu	a4,s3,90e <malloc+0xb8>
 886:	f426                	sd	s1,40(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 88e:	8a4e                	mv	s4,s3
 890:	6705                	lui	a4,0x1
 892:	00e9f363          	bgeu	s3,a4,898 <malloc+0x42>
 896:	6a05                	lui	s4,0x1
 898:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8a0:	00000497          	auipc	s1,0x0
 8a4:	76048493          	addi	s1,s1,1888 # 1000 <freep>
  if (p == SBRK_ERROR)
 8a8:	5afd                	li	s5,-1
 8aa:	a83d                	j	8e8 <malloc+0x92>
 8ac:	f426                	sd	s1,40(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b4:	00000797          	auipc	a5,0x0
 8b8:	75c78793          	addi	a5,a5,1884 # 1010 <base>
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74f73223          	sd	a5,1860(a4) # 1000 <freep>
 8c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8ca:	b7d1                	j	88e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	a899                	j	926 <malloc+0xd0>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8d6:	0541                	addi	a0,a0,16
 8d8:	ef9ff0ef          	jal	7d0 <free>
  return freep;
 8dc:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8de:	c125                	beqz	a0,93e <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e2:	4798                	lw	a4,8(a5)
 8e4:	03277163          	bgeu	a4,s2,906 <malloc+0xb0>
    if (p == freep)
 8e8:	6098                	ld	a4,0(s1)
 8ea:	853e                	mv	a0,a5
 8ec:	fef71ae3          	bne	a4,a5,8e0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f0:	8552                	mv	a0,s4
 8f2:	9d3ff0ef          	jal	2c4 <sbrk>
  if (p == SBRK_ERROR)
 8f6:	fd551ee3          	bne	a0,s5,8d2 <malloc+0x7c>
        return 0;
 8fa:	4501                	li	a0,0
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	a03d                	j	932 <malloc+0xdc>
 906:	74a2                	ld	s1,40(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 90e:	fae90fe3          	beq	s2,a4,8cc <malloc+0x76>
        p->s.size -= nunits;
 912:	4137073b          	subw	a4,a4,s3
 916:	c798                	sw	a4,8(a5)
        p += p->s.size;
 918:	02071693          	slli	a3,a4,0x20
 91c:	01c6d713          	srli	a4,a3,0x1c
 920:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 922:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 926:	00000717          	auipc	a4,0x0
 92a:	6ca73d23          	sd	a0,1754(a4) # 1000 <freep>
      return (void *)(p + 1);
 92e:	01078513          	addi	a0,a5,16
  }
}
 932:	70e2                	ld	ra,56(sp)
 934:	7442                	ld	s0,48(sp)
 936:	7902                	ld	s2,32(sp)
 938:	69e2                	ld	s3,24(sp)
 93a:	6121                	addi	sp,sp,64
 93c:	8082                	ret
 93e:	74a2                	ld	s1,40(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	b7f5                	j	932 <malloc+0xdc>
