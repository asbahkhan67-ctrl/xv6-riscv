
user/_sync:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sync();
   8:	372000ef          	jal	37a <sync>
  exit(0);
   c:	4501                	li	a0,0
   e:	2cc000ef          	jal	2da <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2bc000ef          	jal	2da <exit>

0000000000000022 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf99                	beqz	a5,9c <strlen+0x2a>
  80:	0505                	addi	a0,a0,1
  82:	87aa                	mv	a5,a0
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
  92:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret
  for (n = 0; s[n]; n++)
  9c:	4501                	li	a0,0
  9e:	bfdd                	j	94 <strlen+0x22>

00000000000000a0 <memset>:

void *
memset(void *dst, int c, uint n)
{
  a0:	1141                	addi	sp,sp,-16
  a2:	e406                	sd	ra,8(sp)
  a4:	e022                	sd	s0,0(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  a8:	ca19                	beqz	a2,be <memset+0x1e>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x14>
  }
  return dst;
}
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strchr>:

char *
strchr(const char *s, char c)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  for (; *s; s++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf81                	beqz	a5,ea <strchr+0x24>
    if (*s == c)
  d4:	00f58763          	beq	a1,a5,e2 <strchr+0x1c>
  for (; *s; s++)
  d8:	0505                	addi	a0,a0,1
  da:	00054783          	lbu	a5,0(a0)
  de:	fbfd                	bnez	a5,d4 <strchr+0xe>
      return (char *)s;
  return 0;
  e0:	4501                	li	a0,0
}
  e2:	60a2                	ld	ra,8(sp)
  e4:	6402                	ld	s0,0(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  return 0;
  ea:	4501                	li	a0,0
  ec:	bfdd                	j	e2 <strchr+0x1c>

00000000000000ee <gets>:

char *
gets(char *buf, int max)
{
  ee:	7159                	addi	sp,sp,-112
  f0:	f486                	sd	ra,104(sp)
  f2:	f0a2                	sd	s0,96(sp)
  f4:	eca6                	sd	s1,88(sp)
  f6:	e8ca                	sd	s2,80(sp)
  f8:	e4ce                	sd	s3,72(sp)
  fa:	e0d2                	sd	s4,64(sp)
  fc:	fc56                	sd	s5,56(sp)
  fe:	f85a                	sd	s6,48(sp)
 100:	f45e                	sd	s7,40(sp)
 102:	f062                	sd	s8,32(sp)
 104:	ec66                	sd	s9,24(sp)
 106:	e86a                	sd	s10,16(sp)
 108:	1880                	addi	s0,sp,112
 10a:	8caa                	mv	s9,a0
 10c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 10e:	892a                	mv	s2,a0
 110:	4481                	li	s1,0
    cc = read(0, &c, 1);
 112:	f9f40b13          	addi	s6,s0,-97
 116:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 118:	4ba9                	li	s7,10
 11a:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 11c:	8d26                	mv	s10,s1
 11e:	0014899b          	addiw	s3,s1,1
 122:	84ce                	mv	s1,s3
 124:	0349d563          	bge	s3,s4,14e <gets+0x60>
    cc = read(0, &c, 1);
 128:	8656                	mv	a2,s5
 12a:	85da                	mv	a1,s6
 12c:	4501                	li	a0,0
 12e:	1c4000ef          	jal	2f2 <read>
    if (cc < 1)
 132:	00a05e63          	blez	a0,14e <gets+0x60>
    buf[i++] = c;
 136:	f9f44783          	lbu	a5,-97(s0)
 13a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 13e:	01778763          	beq	a5,s7,14c <gets+0x5e>
 142:	0905                	addi	s2,s2,1
 144:	fd879ce3          	bne	a5,s8,11c <gets+0x2e>
    buf[i++] = c;
 148:	8d4e                	mv	s10,s3
 14a:	a011                	j	14e <gets+0x60>
 14c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 14e:	9d66                	add	s10,s10,s9
 150:	000d0023          	sb	zero,0(s10)
  return buf;
}
 154:	8566                	mv	a0,s9
 156:	70a6                	ld	ra,104(sp)
 158:	7406                	ld	s0,96(sp)
 15a:	64e6                	ld	s1,88(sp)
 15c:	6946                	ld	s2,80(sp)
 15e:	69a6                	ld	s3,72(sp)
 160:	6a06                	ld	s4,64(sp)
 162:	7ae2                	ld	s5,56(sp)
 164:	7b42                	ld	s6,48(sp)
 166:	7ba2                	ld	s7,40(sp)
 168:	7c02                	ld	s8,32(sp)
 16a:	6ce2                	ld	s9,24(sp)
 16c:	6d42                	ld	s10,16(sp)
 16e:	6165                	addi	sp,sp,112
 170:	8082                	ret

0000000000000172 <stat>:

int
stat(const char *n, struct stat *st)
{
 172:	1101                	addi	sp,sp,-32
 174:	ec06                	sd	ra,24(sp)
 176:	e822                	sd	s0,16(sp)
 178:	e04a                	sd	s2,0(sp)
 17a:	1000                	addi	s0,sp,32
 17c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17e:	4581                	li	a1,0
 180:	19a000ef          	jal	31a <open>
  if (fd < 0)
 184:	02054263          	bltz	a0,1a8 <stat+0x36>
 188:	e426                	sd	s1,8(sp)
 18a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18c:	85ca                	mv	a1,s2
 18e:	1a4000ef          	jal	332 <fstat>
 192:	892a                	mv	s2,a0
  close(fd);
 194:	8526                	mv	a0,s1
 196:	16c000ef          	jal	302 <close>
  return r;
 19a:	64a2                	ld	s1,8(sp)
}
 19c:	854a                	mv	a0,s2
 19e:	60e2                	ld	ra,24(sp)
 1a0:	6442                	ld	s0,16(sp)
 1a2:	6902                	ld	s2,0(sp)
 1a4:	6105                	addi	sp,sp,32
 1a6:	8082                	ret
    return -1;
 1a8:	597d                	li	s2,-1
 1aa:	bfcd                	j	19c <stat+0x2a>

00000000000001ac <atoi>:

int
atoi(const char *s)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1b4:	00054683          	lbu	a3,0(a0)
 1b8:	fd06879b          	addiw	a5,a3,-48
 1bc:	0ff7f793          	zext.b	a5,a5
 1c0:	4625                	li	a2,9
 1c2:	02f66963          	bltu	a2,a5,1f4 <atoi+0x48>
 1c6:	872a                	mv	a4,a0
  n = 0;
 1c8:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1ca:	0705                	addi	a4,a4,1
 1cc:	0025179b          	slliw	a5,a0,0x2
 1d0:	9fa9                	addw	a5,a5,a0
 1d2:	0017979b          	slliw	a5,a5,0x1
 1d6:	9fb5                	addw	a5,a5,a3
 1d8:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1dc:	00074683          	lbu	a3,0(a4)
 1e0:	fd06879b          	addiw	a5,a3,-48
 1e4:	0ff7f793          	zext.b	a5,a5
 1e8:	fef671e3          	bgeu	a2,a5,1ca <atoi+0x1e>
  return n;
}
 1ec:	60a2                	ld	ra,8(sp)
 1ee:	6402                	ld	s0,0(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret
  n = 0;
 1f4:	4501                	li	a0,0
 1f6:	bfdd                	j	1ec <atoi+0x40>

00000000000001f8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1f8:	1141                	addi	sp,sp,-16
 1fa:	e406                	sd	ra,8(sp)
 1fc:	e022                	sd	s0,0(sp)
 1fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 200:	02b57563          	bgeu	a0,a1,22a <memmove+0x32>
    while (n-- > 0)
 204:	00c05f63          	blez	a2,222 <memmove+0x2a>
 208:	1602                	slli	a2,a2,0x20
 20a:	9201                	srli	a2,a2,0x20
 20c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 210:	872a                	mv	a4,a0
      *dst++ = *src++;
 212:	0585                	addi	a1,a1,1
 214:	0705                	addi	a4,a4,1
 216:	fff5c683          	lbu	a3,-1(a1)
 21a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 21e:	fee79ae3          	bne	a5,a4,212 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 222:	60a2                	ld	ra,8(sp)
 224:	6402                	ld	s0,0(sp)
 226:	0141                	addi	sp,sp,16
 228:	8082                	ret
    dst += n;
 22a:	00c50733          	add	a4,a0,a2
    src += n;
 22e:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 230:	fec059e3          	blez	a2,222 <memmove+0x2a>
 234:	fff6079b          	addiw	a5,a2,-1
 238:	1782                	slli	a5,a5,0x20
 23a:	9381                	srli	a5,a5,0x20
 23c:	fff7c793          	not	a5,a5
 240:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 242:	15fd                	addi	a1,a1,-1
 244:	177d                	addi	a4,a4,-1
 246:	0005c683          	lbu	a3,0(a1)
 24a:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 24e:	fef71ae3          	bne	a4,a5,242 <memmove+0x4a>
 252:	bfc1                	j	222 <memmove+0x2a>

0000000000000254 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25c:	ca0d                	beqz	a2,28e <memcmp+0x3a>
 25e:	fff6069b          	addiw	a3,a2,-1
 262:	1682                	slli	a3,a3,0x20
 264:	9281                	srli	a3,a3,0x20
 266:	0685                	addi	a3,a3,1
 268:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79863          	bne	a5,a4,282 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x16>
  }
  return 0;
 27e:	4501                	li	a0,0
 280:	a019                	j	286 <memcmp+0x32>
      return *p1 - *p2;
 282:	40e7853b          	subw	a0,a5,a4
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
  return 0;
 28e:	4501                	li	a0,0
 290:	bfdd                	j	286 <memcmp+0x32>

0000000000000292 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29a:	f5fff0ef          	jal	1f8 <memmove>
}
 29e:	60a2                	ld	ra,8(sp)
 2a0:	6402                	ld	s0,0(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <sbrk>:

char *
sbrk(int n)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ae:	4585                	li	a1,1
 2b0:	0b2000ef          	jal	362 <sys_sbrk>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <sbrklazy>:

char *
sbrklazy(int n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c4:	4589                	li	a1,2
 2c6:	09c000ef          	jal	362 <sys_sbrk>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d2:	4885                	li	a7,1
 ecall
 2d4:	00000073          	ecall
 ret
 2d8:	8082                	ret

00000000000002da <exit>:
.global exit
exit:
 li a7, SYS_exit
 2da:	4889                	li	a7,2
 ecall
 2dc:	00000073          	ecall
 ret
 2e0:	8082                	ret

00000000000002e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e2:	488d                	li	a7,3
 ecall
 2e4:	00000073          	ecall
 ret
 2e8:	8082                	ret

00000000000002ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ea:	4891                	li	a7,4
 ecall
 2ec:	00000073          	ecall
 ret
 2f0:	8082                	ret

00000000000002f2 <read>:
.global read
read:
 li a7, SYS_read
 2f2:	4895                	li	a7,5
 ecall
 2f4:	00000073          	ecall
 ret
 2f8:	8082                	ret

00000000000002fa <write>:
.global write
write:
 li a7, SYS_write
 2fa:	48c1                	li	a7,16
 ecall
 2fc:	00000073          	ecall
 ret
 300:	8082                	ret

0000000000000302 <close>:
.global close
close:
 li a7, SYS_close
 302:	48d5                	li	a7,21
 ecall
 304:	00000073          	ecall
 ret
 308:	8082                	ret

000000000000030a <kill>:
.global kill
kill:
 li a7, SYS_kill
 30a:	4899                	li	a7,6
 ecall
 30c:	00000073          	ecall
 ret
 310:	8082                	ret

0000000000000312 <exec>:
.global exec
exec:
 li a7, SYS_exec
 312:	489d                	li	a7,7
 ecall
 314:	00000073          	ecall
 ret
 318:	8082                	ret

000000000000031a <open>:
.global open
open:
 li a7, SYS_open
 31a:	48bd                	li	a7,15
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 322:	48c5                	li	a7,17
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32a:	48c9                	li	a7,18
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 332:	48a1                	li	a7,8
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <link>:
.global link
link:
 li a7, SYS_link
 33a:	48cd                	li	a7,19
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 342:	48d1                	li	a7,20
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34a:	48a5                	li	a7,9
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <dup>:
.global dup
dup:
 li a7, SYS_dup
 352:	48a9                	li	a7,10
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35a:	48ad                	li	a7,11
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 362:	48b1                	li	a7,12
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <pause>:
.global pause
pause:
 li a7, SYS_pause
 36a:	48b5                	li	a7,13
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 372:	48b9                	li	a7,14
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <sync>:
.global sync
sync:
 li a7, SYS_sync
 37a:	48d9                	li	a7,22
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <ps>:
.global ps
ps:
 li a7, SYS_ps
 382:	48dd                	li	a7,23
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 38a:	48e1                	li	a7,24
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 392:	48e5                	li	a7,25
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 39a:	48e9                	li	a7,26
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3a2:	48ed                	li	a7,27
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3aa:	48f1                	li	a7,28
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3b2:	48f5                	li	a7,29
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3ba:	48f9                	li	a7,30
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3c2:	48fd                	li	a7,31
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3ca:	02000893          	li	a7,32
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <halt>:
.global halt
halt:
 li a7, SYS_halt
 3d4:	02100893          	li	a7,33
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 3de:	02200893          	li	a7,34
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 3e8:	02300893          	li	a7,35
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 3f2:	02400893          	li	a7,36
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 3fc:	02500893          	li	a7,37
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 412:	4605                	li	a2,1
 414:	fef40593          	addi	a1,s0,-17
 418:	ee3ff0ef          	jal	2fa <write>
}
 41c:	60e2                	ld	ra,24(sp)
 41e:	6442                	ld	s0,16(sp)
 420:	6105                	addi	sp,sp,32
 422:	8082                	ret

0000000000000424 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 424:	715d                	addi	sp,sp,-80
 426:	e486                	sd	ra,72(sp)
 428:	e0a2                	sd	s0,64(sp)
 42a:	fc26                	sd	s1,56(sp)
 42c:	f84a                	sd	s2,48(sp)
 42e:	f44e                	sd	s3,40(sp)
 430:	0880                	addi	s0,sp,80
 432:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 434:	c299                	beqz	a3,43a <printint+0x16>
 436:	0605cc63          	bltz	a1,4ae <printint+0x8a>
  neg = 0;
 43a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 43c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 440:	869a                	mv	a3,t1
  i = 0;
 442:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 444:	00000817          	auipc	a6,0x0
 448:	4f480813          	addi	a6,a6,1268 # 938 <digits>
 44c:	88be                	mv	a7,a5
 44e:	0017851b          	addiw	a0,a5,1
 452:	87aa                	mv	a5,a0
 454:	02c5f733          	remu	a4,a1,a2
 458:	9742                	add	a4,a4,a6
 45a:	00074703          	lbu	a4,0(a4)
 45e:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 462:	872e                	mv	a4,a1
 464:	02c5d5b3          	divu	a1,a1,a2
 468:	0685                	addi	a3,a3,1
 46a:	fec771e3          	bgeu	a4,a2,44c <printint+0x28>
  if (neg)
 46e:	000e0c63          	beqz	t3,486 <printint+0x62>
    buf[i++] = '-';
 472:	fd050793          	addi	a5,a0,-48
 476:	00878533          	add	a0,a5,s0
 47a:	02d00793          	li	a5,45
 47e:	fef50423          	sb	a5,-24(a0)
 482:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 486:	fff7899b          	addiw	s3,a5,-1
 48a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 48e:	fff4c583          	lbu	a1,-1(s1)
 492:	854a                	mv	a0,s2
 494:	f73ff0ef          	jal	406 <putc>
  while (--i >= 0)
 498:	39fd                	addiw	s3,s3,-1
 49a:	14fd                	addi	s1,s1,-1
 49c:	fe09d9e3          	bgez	s3,48e <printint+0x6a>
}
 4a0:	60a6                	ld	ra,72(sp)
 4a2:	6406                	ld	s0,64(sp)
 4a4:	74e2                	ld	s1,56(sp)
 4a6:	7942                	ld	s2,48(sp)
 4a8:	79a2                	ld	s3,40(sp)
 4aa:	6161                	addi	sp,sp,80
 4ac:	8082                	ret
    x = -xx;
 4ae:	40b005b3          	neg	a1,a1
    neg = 1;
 4b2:	4e05                	li	t3,1
    x = -xx;
 4b4:	b761                	j	43c <printint+0x18>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	28048463          	beqz	s1,74c <vprintf+0x296>
 4c8:	e0ca                	sd	s2,64(sp)
 4ca:	fc4e                	sd	s3,56(sp)
 4cc:	f852                	sd	s4,48(sp)
 4ce:	f456                	sd	s5,40(sp)
 4d0:	f05a                	sd	s6,32(sp)
 4d2:	ec5e                	sd	s7,24(sp)
 4d4:	e862                	sd	s8,16(sp)
 4d6:	e466                	sd	s9,8(sp)
 4d8:	8b2a                	mv	s6,a0
 4da:	8a2e                	mv	s4,a1
 4dc:	8bb2                	mv	s7,a2
  state = 0;
 4de:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4e0:	4901                	li	s2,0
 4e2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4e8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4ec:	06c00c93          	li	s9,108
 4f0:	a00d                	j	512 <vprintf+0x5c>
        putc(fd, c0);
 4f2:	85a6                	mv	a1,s1
 4f4:	855a                	mv	a0,s6
 4f6:	f11ff0ef          	jal	406 <putc>
 4fa:	a019                	j	500 <vprintf+0x4a>
    } else if (state == '%') {
 4fc:	03598363          	beq	s3,s5,522 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 500:	0019079b          	addiw	a5,s2,1
 504:	893e                	mv	s2,a5
 506:	873e                	mv	a4,a5
 508:	97d2                	add	a5,a5,s4
 50a:	0007c483          	lbu	s1,0(a5)
 50e:	22048763          	beqz	s1,73c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 512:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 516:	fe0993e3          	bnez	s3,4fc <vprintf+0x46>
      if (c0 == '%') {
 51a:	fd579ce3          	bne	a5,s5,4f2 <vprintf+0x3c>
        state = '%';
 51e:	89be                	mv	s3,a5
 520:	b7c5                	j	500 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 522:	00ea06b3          	add	a3,s4,a4
 526:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 52a:	8636                	mv	a2,a3
      if (c1)
 52c:	c681                	beqz	a3,534 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 52e:	9752                	add	a4,a4,s4
 530:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 534:	05878263          	beq	a5,s8,578 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 538:	05978c63          	beq	a5,s9,590 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 53c:	07500713          	li	a4,117
 540:	0ee78663          	beq	a5,a4,62c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 544:	07800713          	li	a4,120
 548:	12e78863          	beq	a5,a4,678 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 54c:	07000713          	li	a4,112
 550:	14e78d63          	beq	a5,a4,6aa <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 554:	06300713          	li	a4,99
 558:	18e78c63          	beq	a5,a4,6f0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 55c:	07300713          	li	a4,115
 560:	1ae78263          	beq	a5,a4,704 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 564:	02500713          	li	a4,37
 568:	04e79463          	bne	a5,a4,5b0 <vprintf+0xfa>
        putc(fd, '%');
 56c:	85ba                	mv	a1,a4
 56e:	855a                	mv	a0,s6
 570:	e97ff0ef          	jal	406 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 574:	4981                	li	s3,0
 576:	b769                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 578:	008b8493          	addi	s1,s7,8
 57c:	4685                	li	a3,1
 57e:	4629                	li	a2,10
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	e9fff0ef          	jal	424 <printint>
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
 58e:	bf8d                	j	500 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 590:	06400793          	li	a5,100
 594:	02f68963          	beq	a3,a5,5c6 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 598:	06c00793          	li	a5,108
 59c:	04f68263          	beq	a3,a5,5e0 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5a0:	07500793          	li	a5,117
 5a4:	0af68063          	beq	a3,a5,644 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5a8:	07800793          	li	a5,120
 5ac:	0ef68263          	beq	a3,a5,690 <vprintf+0x1da>
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e51ff0ef          	jal	406 <putc>
        putc(fd, c0);
 5ba:	85a6                	mv	a1,s1
 5bc:	855a                	mv	a0,s6
 5be:	e49ff0ef          	jal	406 <putc>
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bf35                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e51ff0ef          	jal	424 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
        i += 1;
 5de:	b70d                	j	500 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5e0:	06400793          	li	a5,100
 5e4:	02f60763          	beq	a2,a5,612 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5e8:	07500793          	li	a5,117
 5ec:	06f60963          	beq	a2,a5,65e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5f0:	07800793          	li	a5,120
 5f4:	faf61ee3          	bne	a2,a5,5b0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e1fff0ef          	jal	424 <printint>
        i += 2;
 60a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	bdc5                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	008b8493          	addi	s1,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e05ff0ef          	jal	424 <printint>
        i += 2;
 624:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	bdd9                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	debff0ef          	jal	424 <printint>
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	bd7d                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	dd3ff0ef          	jal	424 <printint>
        i += 1;
 656:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 1;
 65c:	b555                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	db9ff0ef          	jal	424 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	b569                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000be583          	lwu	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d9fff0ef          	jal	424 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd8d                	j	500 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4641                	li	a2,16
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d87ff0ef          	jal	424 <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 1;
 6a8:	bda1                	j	500 <vprintf+0x4a>
 6aa:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b8d13          	addi	s10,s7,8
 6b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	855a                	mv	a0,s6
 6ba:	d4dff0ef          	jal	406 <putc>
  putc(fd, 'x');
 6be:	07800593          	li	a1,120
 6c2:	855a                	mv	a0,s6
 6c4:	d43ff0ef          	jal	406 <putc>
 6c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ca:	00000b97          	auipc	s7,0x0
 6ce:	26eb8b93          	addi	s7,s7,622 # 938 <digits>
 6d2:	03c9d793          	srli	a5,s3,0x3c
 6d6:	97de                	add	a5,a5,s7
 6d8:	0007c583          	lbu	a1,0(a5)
 6dc:	855a                	mv	a0,s6
 6de:	d29ff0ef          	jal	406 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	0992                	slli	s3,s3,0x4
 6e4:	34fd                	addiw	s1,s1,-1
 6e6:	f4f5                	bnez	s1,6d2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6e8:	8bea                	mv	s7,s10
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	6d02                	ld	s10,0(sp)
 6ee:	bd09                	j	500 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6f0:	008b8493          	addi	s1,s7,8
 6f4:	000bc583          	lbu	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d0dff0ef          	jal	406 <putc>
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
 702:	bbfd                	j	500 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 704:	008b8993          	addi	s3,s7,8
 708:	000bb483          	ld	s1,0(s7)
 70c:	cc91                	beqz	s1,728 <vprintf+0x272>
        for (; *s; s++)
 70e:	0004c583          	lbu	a1,0(s1)
 712:	c195                	beqz	a1,736 <vprintf+0x280>
          putc(fd, *s);
 714:	855a                	mv	a0,s6
 716:	cf1ff0ef          	jal	406 <putc>
        for (; *s; s++)
 71a:	0485                	addi	s1,s1,1
 71c:	0004c583          	lbu	a1,0(s1)
 720:	f9f5                	bnez	a1,714 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	bbe9                	j	500 <vprintf+0x4a>
          s = "(null)";
 728:	00000497          	auipc	s1,0x0
 72c:	20848493          	addi	s1,s1,520 # 930 <malloc+0xf8>
        for (; *s; s++)
 730:	02800593          	li	a1,40
 734:	b7c5                	j	714 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 736:	8bce                	mv	s7,s3
      state = 0;
 738:	4981                	li	s3,0
 73a:	b3d9                	j	500 <vprintf+0x4a>
 73c:	6906                	ld	s2,64(sp)
 73e:	79e2                	ld	s3,56(sp)
 740:	7a42                	ld	s4,48(sp)
 742:	7aa2                	ld	s5,40(sp)
 744:	7b02                	ld	s6,32(sp)
 746:	6be2                	ld	s7,24(sp)
 748:	6c42                	ld	s8,16(sp)
 74a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	64a6                	ld	s1,72(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	8622                	mv	a2,s0
 770:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 774:	d43ff0ef          	jal	4b6 <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6161                	addi	sp,sp,80
 77e:	8082                	ret

0000000000000780 <printf>:

void
printf(const char *fmt, ...)
{
 780:	711d                	addi	sp,sp,-96
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e40c                	sd	a1,8(s0)
 78a:	e810                	sd	a2,16(s0)
 78c:	ec14                	sd	a3,24(s0)
 78e:	f018                	sd	a4,32(s0)
 790:	f41c                	sd	a5,40(s0)
 792:	03043823          	sd	a6,48(s0)
 796:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	00840613          	addi	a2,s0,8
 79e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a2:	85aa                	mv	a1,a0
 7a4:	4505                	li	a0,1
 7a6:	d11ff0ef          	jal	4b6 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e406                	sd	ra,8(sp)
 7b6:	e022                	sd	s0,0(sp)
 7b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00001797          	auipc	a5,0x1
 7c2:	8427b783          	ld	a5,-1982(a5) # 1000 <freep>
 7c6:	a02d                	j	7f0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7c8:	4618                	lw	a4,8(a2)
 7ca:	9f2d                	addw	a4,a4,a1
 7cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6398                	ld	a4,0(a5)
 7d2:	6310                	ld	a2,0(a4)
 7d4:	a83d                	j	812 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7d6:	ff852703          	lw	a4,-8(a0)
 7da:	9f31                	addw	a4,a4,a2
 7dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7de:	ff053683          	ld	a3,-16(a0)
 7e2:	a091                	j	826 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e7e463          	bltu	a5,a4,7ee <free+0x3c>
 7ea:	00e6ea63          	bltu	a3,a4,7fe <free+0x4c>
{
 7ee:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fed7fae3          	bgeu	a5,a3,7e4 <free+0x32>
 7f4:	6398                	ld	a4,0(a5)
 7f6:	00e6e463          	bltu	a3,a4,7fe <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	fee7eae3          	bltu	a5,a4,7ee <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7fe:	ff852583          	lw	a1,-8(a0)
 802:	6390                	ld	a2,0(a5)
 804:	02059813          	slli	a6,a1,0x20
 808:	01c85713          	srli	a4,a6,0x1c
 80c:	9736                	add	a4,a4,a3
 80e:	fae60de3          	beq	a2,a4,7c8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 816:	4790                	lw	a2,8(a5)
 818:	02061593          	slli	a1,a2,0x20
 81c:	01c5d713          	srli	a4,a1,0x1c
 820:	973e                	add	a4,a4,a5
 822:	fae68ae3          	beq	a3,a4,7d6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 826:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 828:	00000717          	auipc	a4,0x0
 82c:	7cf73c23          	sd	a5,2008(a4) # 1000 <freep>
}
 830:	60a2                	ld	ra,8(sp)
 832:	6402                	ld	s0,0(sp)
 834:	0141                	addi	sp,sp,16
 836:	8082                	ret

0000000000000838 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 838:	7139                	addi	sp,sp,-64
 83a:	fc06                	sd	ra,56(sp)
 83c:	f822                	sd	s0,48(sp)
 83e:	f04a                	sd	s2,32(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 844:	02051993          	slli	s3,a0,0x20
 848:	0209d993          	srli	s3,s3,0x20
 84c:	09bd                	addi	s3,s3,15
 84e:	0049d993          	srli	s3,s3,0x4
 852:	2985                	addiw	s3,s3,1
 854:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 856:	00000517          	auipc	a0,0x0
 85a:	7aa53503          	ld	a0,1962(a0) # 1000 <freep>
 85e:	c905                	beqz	a0,88e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 860:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 862:	4798                	lw	a4,8(a5)
 864:	09377663          	bgeu	a4,s3,8f0 <malloc+0xb8>
 868:	f426                	sd	s1,40(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 870:	8a4e                	mv	s4,s3
 872:	6705                	lui	a4,0x1
 874:	00e9f363          	bgeu	s3,a4,87a <malloc+0x42>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 882:	00000497          	auipc	s1,0x0
 886:	77e48493          	addi	s1,s1,1918 # 1000 <freep>
  if (p == SBRK_ERROR)
 88a:	5afd                	li	s5,-1
 88c:	a83d                	j	8ca <malloc+0x92>
 88e:	f426                	sd	s1,40(sp)
 890:	e852                	sd	s4,16(sp)
 892:	e456                	sd	s5,8(sp)
 894:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 896:	00000797          	auipc	a5,0x0
 89a:	77a78793          	addi	a5,a5,1914 # 1010 <base>
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
 8a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8ac:	b7d1                	j	870 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	a899                	j	908 <malloc+0xd0>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	ef9ff0ef          	jal	7b2 <free>
  return freep;
 8be:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8c0:	c125                	beqz	a0,920 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8c4:	4798                	lw	a4,8(a5)
 8c6:	03277163          	bgeu	a4,s2,8e8 <malloc+0xb0>
    if (p == freep)
 8ca:	6098                	ld	a4,0(s1)
 8cc:	853e                	mv	a0,a5
 8ce:	fef71ae3          	bne	a4,a5,8c2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	9d3ff0ef          	jal	2a6 <sbrk>
  if (p == SBRK_ERROR)
 8d8:	fd551ee3          	bne	a0,s5,8b4 <malloc+0x7c>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xdc>
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8f0:	fae90fe3          	beq	s2,a4,8ae <malloc+0x76>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void *)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xdc>
