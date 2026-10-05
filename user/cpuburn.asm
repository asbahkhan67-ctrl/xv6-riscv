
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

00000000000003c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c0:	1101                	addi	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	1000                	addi	s0,sp,32
 3c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3cc:	4605                	li	a2,1
 3ce:	fef40593          	addi	a1,s0,-17
 3d2:	f47ff0ef          	jal	318 <write>
}
 3d6:	60e2                	ld	ra,24(sp)
 3d8:	6442                	ld	s0,16(sp)
 3da:	6105                	addi	sp,sp,32
 3dc:	8082                	ret

00000000000003de <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3de:	715d                	addi	sp,sp,-80
 3e0:	e486                	sd	ra,72(sp)
 3e2:	e0a2                	sd	s0,64(sp)
 3e4:	fc26                	sd	s1,56(sp)
 3e6:	f84a                	sd	s2,48(sp)
 3e8:	f44e                	sd	s3,40(sp)
 3ea:	0880                	addi	s0,sp,80
 3ec:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3ee:	c299                	beqz	a3,3f4 <printint+0x16>
 3f0:	0605cc63          	bltz	a1,468 <printint+0x8a>
  neg = 0;
 3f4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3f6:	fb840313          	addi	t1,s0,-72
  neg = 0;
 3fa:	869a                	mv	a3,t1
  i = 0;
 3fc:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 3fe:	00000817          	auipc	a6,0x0
 402:	4fa80813          	addi	a6,a6,1274 # 8f8 <digits>
 406:	88be                	mv	a7,a5
 408:	0017851b          	addiw	a0,a5,1
 40c:	87aa                	mv	a5,a0
 40e:	02c5f733          	remu	a4,a1,a2
 412:	9742                	add	a4,a4,a6
 414:	00074703          	lbu	a4,0(a4)
 418:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 41c:	872e                	mv	a4,a1
 41e:	02c5d5b3          	divu	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec771e3          	bgeu	a4,a2,406 <printint+0x28>
  if (neg)
 428:	000e0c63          	beqz	t3,440 <printint+0x62>
    buf[i++] = '-';
 42c:	fd050793          	addi	a5,a0,-48
 430:	00878533          	add	a0,a5,s0
 434:	02d00793          	li	a5,45
 438:	fef50423          	sb	a5,-24(a0)
 43c:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 440:	fff7899b          	addiw	s3,a5,-1
 444:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 448:	fff4c583          	lbu	a1,-1(s1)
 44c:	854a                	mv	a0,s2
 44e:	f73ff0ef          	jal	3c0 <putc>
  while (--i >= 0)
 452:	39fd                	addiw	s3,s3,-1
 454:	14fd                	addi	s1,s1,-1
 456:	fe09d9e3          	bgez	s3,448 <printint+0x6a>
}
 45a:	60a6                	ld	ra,72(sp)
 45c:	6406                	ld	s0,64(sp)
 45e:	74e2                	ld	s1,56(sp)
 460:	7942                	ld	s2,48(sp)
 462:	79a2                	ld	s3,40(sp)
 464:	6161                	addi	sp,sp,80
 466:	8082                	ret
    x = -xx;
 468:	40b005b3          	neg	a1,a1
    neg = 1;
 46c:	4e05                	li	t3,1
    x = -xx;
 46e:	b761                	j	3f6 <printint+0x18>

0000000000000470 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 470:	711d                	addi	sp,sp,-96
 472:	ec86                	sd	ra,88(sp)
 474:	e8a2                	sd	s0,80(sp)
 476:	e4a6                	sd	s1,72(sp)
 478:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 47a:	0005c483          	lbu	s1,0(a1)
 47e:	28048463          	beqz	s1,706 <vprintf+0x296>
 482:	e0ca                	sd	s2,64(sp)
 484:	fc4e                	sd	s3,56(sp)
 486:	f852                	sd	s4,48(sp)
 488:	f456                	sd	s5,40(sp)
 48a:	f05a                	sd	s6,32(sp)
 48c:	ec5e                	sd	s7,24(sp)
 48e:	e862                	sd	s8,16(sp)
 490:	e466                	sd	s9,8(sp)
 492:	8b2a                	mv	s6,a0
 494:	8a2e                	mv	s4,a1
 496:	8bb2                	mv	s7,a2
  state = 0;
 498:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 49a:	4901                	li	s2,0
 49c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 49e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4a6:	06c00c93          	li	s9,108
 4aa:	a00d                	j	4cc <vprintf+0x5c>
        putc(fd, c0);
 4ac:	85a6                	mv	a1,s1
 4ae:	855a                	mv	a0,s6
 4b0:	f11ff0ef          	jal	3c0 <putc>
 4b4:	a019                	j	4ba <vprintf+0x4a>
    } else if (state == '%') {
 4b6:	03598363          	beq	s3,s5,4dc <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 4ba:	0019079b          	addiw	a5,s2,1
 4be:	893e                	mv	s2,a5
 4c0:	873e                	mv	a4,a5
 4c2:	97d2                	add	a5,a5,s4
 4c4:	0007c483          	lbu	s1,0(a5)
 4c8:	22048763          	beqz	s1,6f6 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 4cc:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4d0:	fe0993e3          	bnez	s3,4b6 <vprintf+0x46>
      if (c0 == '%') {
 4d4:	fd579ce3          	bne	a5,s5,4ac <vprintf+0x3c>
        state = '%';
 4d8:	89be                	mv	s3,a5
 4da:	b7c5                	j	4ba <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 4dc:	00ea06b3          	add	a3,s4,a4
 4e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4e4:	8636                	mv	a2,a3
      if (c1)
 4e6:	c681                	beqz	a3,4ee <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 4e8:	9752                	add	a4,a4,s4
 4ea:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 4ee:	05878263          	beq	a5,s8,532 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 4f2:	05978c63          	beq	a5,s9,54a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4f6:	07500713          	li	a4,117
 4fa:	0ee78663          	beq	a5,a4,5e6 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 4fe:	07800713          	li	a4,120
 502:	12e78863          	beq	a5,a4,632 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 506:	07000713          	li	a4,112
 50a:	14e78d63          	beq	a5,a4,664 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 50e:	06300713          	li	a4,99
 512:	18e78c63          	beq	a5,a4,6aa <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 516:	07300713          	li	a4,115
 51a:	1ae78263          	beq	a5,a4,6be <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 51e:	02500713          	li	a4,37
 522:	04e79463          	bne	a5,a4,56a <vprintf+0xfa>
        putc(fd, '%');
 526:	85ba                	mv	a1,a4
 528:	855a                	mv	a0,s6
 52a:	e97ff0ef          	jal	3c0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 52e:	4981                	li	s3,0
 530:	b769                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 532:	008b8493          	addi	s1,s7,8
 536:	4685                	li	a3,1
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	855a                	mv	a0,s6
 540:	e9fff0ef          	jal	3de <printint>
 544:	8ba6                	mv	s7,s1
      state = 0;
 546:	4981                	li	s3,0
 548:	bf8d                	j	4ba <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 54a:	06400793          	li	a5,100
 54e:	02f68963          	beq	a3,a5,580 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 552:	06c00793          	li	a5,108
 556:	04f68263          	beq	a3,a5,59a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 55a:	07500793          	li	a5,117
 55e:	0af68063          	beq	a3,a5,5fe <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 562:	07800793          	li	a5,120
 566:	0ef68263          	beq	a3,a5,64a <vprintf+0x1da>
        putc(fd, '%');
 56a:	02500593          	li	a1,37
 56e:	855a                	mv	a0,s6
 570:	e51ff0ef          	jal	3c0 <putc>
        putc(fd, c0);
 574:	85a6                	mv	a1,s1
 576:	855a                	mv	a0,s6
 578:	e49ff0ef          	jal	3c0 <putc>
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bf35                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	008b8493          	addi	s1,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000bb583          	ld	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	e51ff0ef          	jal	3de <printint>
        i += 1;
 592:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
        i += 1;
 598:	b70d                	j	4ba <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 59a:	06400793          	li	a5,100
 59e:	02f60763          	beq	a2,a5,5cc <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5a2:	07500793          	li	a5,117
 5a6:	06f60963          	beq	a2,a5,618 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5aa:	07800793          	li	a5,120
 5ae:	faf61ee3          	bne	a2,a5,56a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b2:	008b8493          	addi	s1,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4641                	li	a2,16
 5ba:	000bb583          	ld	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e1fff0ef          	jal	3de <printint>
        i += 2;
 5c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
        i += 2;
 5ca:	bdc5                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5cc:	008b8493          	addi	s1,s7,8
 5d0:	4685                	li	a3,1
 5d2:	4629                	li	a2,10
 5d4:	000bb583          	ld	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	e05ff0ef          	jal	3de <printint>
        i += 2;
 5de:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
        i += 2;
 5e4:	bdd9                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000be583          	lwu	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	debff0ef          	jal	3de <printint>
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bd7d                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fe:	008b8493          	addi	s1,s7,8
 602:	4681                	li	a3,0
 604:	4629                	li	a2,10
 606:	000bb583          	ld	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	dd3ff0ef          	jal	3de <printint>
        i += 1;
 610:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	8ba6                	mv	s7,s1
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b555                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	008b8493          	addi	s1,s7,8
 61c:	4681                	li	a3,0
 61e:	4629                	li	a2,10
 620:	000bb583          	ld	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	db9ff0ef          	jal	3de <printint>
        i += 2;
 62a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
        i += 2;
 630:	b569                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000be583          	lwu	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	d9fff0ef          	jal	3de <printint>
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
 648:	bd8d                	j	4ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4681                	li	a3,0
 650:	4641                	li	a2,16
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	d87ff0ef          	jal	3de <printint>
        i += 1;
 65c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
        i += 1;
 662:	bda1                	j	4ba <vprintf+0x4a>
 664:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 666:	008b8d13          	addi	s10,s7,8
 66a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 66e:	03000593          	li	a1,48
 672:	855a                	mv	a0,s6
 674:	d4dff0ef          	jal	3c0 <putc>
  putc(fd, 'x');
 678:	07800593          	li	a1,120
 67c:	855a                	mv	a0,s6
 67e:	d43ff0ef          	jal	3c0 <putc>
 682:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 684:	00000b97          	auipc	s7,0x0
 688:	274b8b93          	addi	s7,s7,628 # 8f8 <digits>
 68c:	03c9d793          	srli	a5,s3,0x3c
 690:	97de                	add	a5,a5,s7
 692:	0007c583          	lbu	a1,0(a5)
 696:	855a                	mv	a0,s6
 698:	d29ff0ef          	jal	3c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69c:	0992                	slli	s3,s3,0x4
 69e:	34fd                	addiw	s1,s1,-1
 6a0:	f4f5                	bnez	s1,68c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6a2:	8bea                	mv	s7,s10
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	6d02                	ld	s10,0(sp)
 6a8:	bd09                	j	4ba <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	000bc583          	lbu	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	d0dff0ef          	jal	3c0 <putc>
 6b8:	8ba6                	mv	s7,s1
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	bbfd                	j	4ba <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6be:	008b8993          	addi	s3,s7,8
 6c2:	000bb483          	ld	s1,0(s7)
 6c6:	cc91                	beqz	s1,6e2 <vprintf+0x272>
        for (; *s; s++)
 6c8:	0004c583          	lbu	a1,0(s1)
 6cc:	c195                	beqz	a1,6f0 <vprintf+0x280>
          putc(fd, *s);
 6ce:	855a                	mv	a0,s6
 6d0:	cf1ff0ef          	jal	3c0 <putc>
        for (; *s; s++)
 6d4:	0485                	addi	s1,s1,1
 6d6:	0004c583          	lbu	a1,0(s1)
 6da:	f9f5                	bnez	a1,6ce <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6dc:	8bce                	mv	s7,s3
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bbe9                	j	4ba <vprintf+0x4a>
          s = "(null)";
 6e2:	00000497          	auipc	s1,0x0
 6e6:	20e48493          	addi	s1,s1,526 # 8f0 <malloc+0xfe>
        for (; *s; s++)
 6ea:	02800593          	li	a1,40
 6ee:	b7c5                	j	6ce <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	b3d9                	j	4ba <vprintf+0x4a>
 6f6:	6906                	ld	s2,64(sp)
 6f8:	79e2                	ld	s3,56(sp)
 6fa:	7a42                	ld	s4,48(sp)
 6fc:	7aa2                	ld	s5,40(sp)
 6fe:	7b02                	ld	s6,32(sp)
 700:	6be2                	ld	s7,24(sp)
 702:	6c42                	ld	s8,16(sp)
 704:	6ca2                	ld	s9,8(sp)
    }
  }
}
 706:	60e6                	ld	ra,88(sp)
 708:	6446                	ld	s0,80(sp)
 70a:	64a6                	ld	s1,72(sp)
 70c:	6125                	addi	sp,sp,96
 70e:	8082                	ret

0000000000000710 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 710:	715d                	addi	sp,sp,-80
 712:	ec06                	sd	ra,24(sp)
 714:	e822                	sd	s0,16(sp)
 716:	1000                	addi	s0,sp,32
 718:	e010                	sd	a2,0(s0)
 71a:	e414                	sd	a3,8(s0)
 71c:	e818                	sd	a4,16(s0)
 71e:	ec1c                	sd	a5,24(s0)
 720:	03043023          	sd	a6,32(s0)
 724:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 728:	8622                	mv	a2,s0
 72a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72e:	d43ff0ef          	jal	470 <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6161                	addi	sp,sp,80
 738:	8082                	ret

000000000000073a <printf>:

void
printf(const char *fmt, ...)
{
 73a:	711d                	addi	sp,sp,-96
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e40c                	sd	a1,8(s0)
 744:	e810                	sd	a2,16(s0)
 746:	ec14                	sd	a3,24(s0)
 748:	f018                	sd	a4,32(s0)
 74a:	f41c                	sd	a5,40(s0)
 74c:	03043823          	sd	a6,48(s0)
 750:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 754:	00840613          	addi	a2,s0,8
 758:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75c:	85aa                	mv	a1,a0
 75e:	4505                	li	a0,1
 760:	d11ff0ef          	jal	470 <vprintf>
}
 764:	60e2                	ld	ra,24(sp)
 766:	6442                	ld	s0,16(sp)
 768:	6125                	addi	sp,sp,96
 76a:	8082                	ret

000000000000076c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76c:	1141                	addi	sp,sp,-16
 76e:	e406                	sd	ra,8(sp)
 770:	e022                	sd	s0,0(sp)
 772:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 774:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	00001797          	auipc	a5,0x1
 77c:	8887b783          	ld	a5,-1912(a5) # 1000 <freep>
 780:	a02d                	j	7aa <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 782:	4618                	lw	a4,8(a2)
 784:	9f2d                	addw	a4,a4,a1
 786:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	6398                	ld	a4,0(a5)
 78c:	6310                	ld	a2,0(a4)
 78e:	a83d                	j	7cc <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 790:	ff852703          	lw	a4,-8(a0)
 794:	9f31                	addw	a4,a4,a2
 796:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 798:	ff053683          	ld	a3,-16(a0)
 79c:	a091                	j	7e0 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79e:	6398                	ld	a4,0(a5)
 7a0:	00e7e463          	bltu	a5,a4,7a8 <free+0x3c>
 7a4:	00e6ea63          	bltu	a3,a4,7b8 <free+0x4c>
{
 7a8:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	fed7fae3          	bgeu	a5,a3,79e <free+0x32>
 7ae:	6398                	ld	a4,0(a5)
 7b0:	00e6e463          	bltu	a3,a4,7b8 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	fee7eae3          	bltu	a5,a4,7a8 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7b8:	ff852583          	lw	a1,-8(a0)
 7bc:	6390                	ld	a2,0(a5)
 7be:	02059813          	slli	a6,a1,0x20
 7c2:	01c85713          	srli	a4,a6,0x1c
 7c6:	9736                	add	a4,a4,a3
 7c8:	fae60de3          	beq	a2,a4,782 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 7d0:	4790                	lw	a2,8(a5)
 7d2:	02061593          	slli	a1,a2,0x20
 7d6:	01c5d713          	srli	a4,a1,0x1c
 7da:	973e                	add	a4,a4,a5
 7dc:	fae68ae3          	beq	a3,a4,790 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7e0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e2:	00001717          	auipc	a4,0x1
 7e6:	80f73f23          	sd	a5,-2018(a4) # 1000 <freep>
}
 7ea:	60a2                	ld	ra,8(sp)
 7ec:	6402                	ld	s0,0(sp)
 7ee:	0141                	addi	sp,sp,16
 7f0:	8082                	ret

00000000000007f2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7f2:	7139                	addi	sp,sp,-64
 7f4:	fc06                	sd	ra,56(sp)
 7f6:	f822                	sd	s0,48(sp)
 7f8:	f04a                	sd	s2,32(sp)
 7fa:	ec4e                	sd	s3,24(sp)
 7fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7fe:	02051993          	slli	s3,a0,0x20
 802:	0209d993          	srli	s3,s3,0x20
 806:	09bd                	addi	s3,s3,15
 808:	0049d993          	srli	s3,s3,0x4
 80c:	2985                	addiw	s3,s3,1
 80e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 810:	00000517          	auipc	a0,0x0
 814:	7f053503          	ld	a0,2032(a0) # 1000 <freep>
 818:	c905                	beqz	a0,848 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 81a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 81c:	4798                	lw	a4,8(a5)
 81e:	09377663          	bgeu	a4,s3,8aa <malloc+0xb8>
 822:	f426                	sd	s1,40(sp)
 824:	e852                	sd	s4,16(sp)
 826:	e456                	sd	s5,8(sp)
 828:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 82a:	8a4e                	mv	s4,s3
 82c:	6705                	lui	a4,0x1
 82e:	00e9f363          	bgeu	s3,a4,834 <malloc+0x42>
 832:	6a05                	lui	s4,0x1
 834:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 838:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 83c:	00000497          	auipc	s1,0x0
 840:	7c448493          	addi	s1,s1,1988 # 1000 <freep>
  if (p == SBRK_ERROR)
 844:	5afd                	li	s5,-1
 846:	a83d                	j	884 <malloc+0x92>
 848:	f426                	sd	s1,40(sp)
 84a:	e852                	sd	s4,16(sp)
 84c:	e456                	sd	s5,8(sp)
 84e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 850:	00000797          	auipc	a5,0x0
 854:	7c078793          	addi	a5,a5,1984 # 1010 <base>
 858:	00000717          	auipc	a4,0x0
 85c:	7af73423          	sd	a5,1960(a4) # 1000 <freep>
 860:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 862:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 866:	b7d1                	j	82a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 868:	6398                	ld	a4,0(a5)
 86a:	e118                	sd	a4,0(a0)
 86c:	a899                	j	8c2 <malloc+0xd0>
  hp->s.size = nu;
 86e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 872:	0541                	addi	a0,a0,16
 874:	ef9ff0ef          	jal	76c <free>
  return freep;
 878:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 87a:	c125                	beqz	a0,8da <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 87c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 87e:	4798                	lw	a4,8(a5)
 880:	03277163          	bgeu	a4,s2,8a2 <malloc+0xb0>
    if (p == freep)
 884:	6098                	ld	a4,0(s1)
 886:	853e                	mv	a0,a5
 888:	fef71ae3          	bne	a4,a5,87c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 88c:	8552                	mv	a0,s4
 88e:	a37ff0ef          	jal	2c4 <sbrk>
  if (p == SBRK_ERROR)
 892:	fd551ee3          	bne	a0,s5,86e <malloc+0x7c>
        return 0;
 896:	4501                	li	a0,0
 898:	74a2                	ld	s1,40(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	a03d                	j	8ce <malloc+0xdc>
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8aa:	fae90fe3          	beq	s2,a4,868 <malloc+0x76>
        p->s.size -= nunits;
 8ae:	4137073b          	subw	a4,a4,s3
 8b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b4:	02071693          	slli	a3,a4,0x20
 8b8:	01c6d713          	srli	a4,a3,0x1c
 8bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72a73f23          	sd	a0,1854(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ca:	01078513          	addi	a0,a5,16
  }
}
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	7902                	ld	s2,32(sp)
 8d4:	69e2                	ld	s3,24(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
 8da:	74a2                	ld	s1,40(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
 8e2:	b7f5                	j	8ce <malloc+0xdc>
