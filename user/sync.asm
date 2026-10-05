
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

00000000000003a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	1000                	addi	s0,sp,32
 3aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ae:	4605                	li	a2,1
 3b0:	fef40593          	addi	a1,s0,-17
 3b4:	f47ff0ef          	jal	2fa <write>
}
 3b8:	60e2                	ld	ra,24(sp)
 3ba:	6442                	ld	s0,16(sp)
 3bc:	6105                	addi	sp,sp,32
 3be:	8082                	ret

00000000000003c0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3c0:	715d                	addi	sp,sp,-80
 3c2:	e486                	sd	ra,72(sp)
 3c4:	e0a2                	sd	s0,64(sp)
 3c6:	fc26                	sd	s1,56(sp)
 3c8:	f84a                	sd	s2,48(sp)
 3ca:	f44e                	sd	s3,40(sp)
 3cc:	0880                	addi	s0,sp,80
 3ce:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3d0:	c299                	beqz	a3,3d6 <printint+0x16>
 3d2:	0605cc63          	bltz	a1,44a <printint+0x8a>
  neg = 0;
 3d6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d8:	fb840313          	addi	t1,s0,-72
  neg = 0;
 3dc:	869a                	mv	a3,t1
  i = 0;
 3de:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 3e0:	00000817          	auipc	a6,0x0
 3e4:	4f880813          	addi	a6,a6,1272 # 8d8 <digits>
 3e8:	88be                	mv	a7,a5
 3ea:	0017851b          	addiw	a0,a5,1
 3ee:	87aa                	mv	a5,a0
 3f0:	02c5f733          	remu	a4,a1,a2
 3f4:	9742                	add	a4,a4,a6
 3f6:	00074703          	lbu	a4,0(a4)
 3fa:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 3fe:	872e                	mv	a4,a1
 400:	02c5d5b3          	divu	a1,a1,a2
 404:	0685                	addi	a3,a3,1
 406:	fec771e3          	bgeu	a4,a2,3e8 <printint+0x28>
  if (neg)
 40a:	000e0c63          	beqz	t3,422 <printint+0x62>
    buf[i++] = '-';
 40e:	fd050793          	addi	a5,a0,-48
 412:	00878533          	add	a0,a5,s0
 416:	02d00793          	li	a5,45
 41a:	fef50423          	sb	a5,-24(a0)
 41e:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 422:	fff7899b          	addiw	s3,a5,-1
 426:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 42a:	fff4c583          	lbu	a1,-1(s1)
 42e:	854a                	mv	a0,s2
 430:	f73ff0ef          	jal	3a2 <putc>
  while (--i >= 0)
 434:	39fd                	addiw	s3,s3,-1
 436:	14fd                	addi	s1,s1,-1
 438:	fe09d9e3          	bgez	s3,42a <printint+0x6a>
}
 43c:	60a6                	ld	ra,72(sp)
 43e:	6406                	ld	s0,64(sp)
 440:	74e2                	ld	s1,56(sp)
 442:	7942                	ld	s2,48(sp)
 444:	79a2                	ld	s3,40(sp)
 446:	6161                	addi	sp,sp,80
 448:	8082                	ret
    x = -xx;
 44a:	40b005b3          	neg	a1,a1
    neg = 1;
 44e:	4e05                	li	t3,1
    x = -xx;
 450:	b761                	j	3d8 <printint+0x18>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 45c:	0005c483          	lbu	s1,0(a1)
 460:	28048463          	beqz	s1,6e8 <vprintf+0x296>
 464:	e0ca                	sd	s2,64(sp)
 466:	fc4e                	sd	s3,56(sp)
 468:	f852                	sd	s4,48(sp)
 46a:	f456                	sd	s5,40(sp)
 46c:	f05a                	sd	s6,32(sp)
 46e:	ec5e                	sd	s7,24(sp)
 470:	e862                	sd	s8,16(sp)
 472:	e466                	sd	s9,8(sp)
 474:	8b2a                	mv	s6,a0
 476:	8a2e                	mv	s4,a1
 478:	8bb2                	mv	s7,a2
  state = 0;
 47a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 47c:	4901                	li	s2,0
 47e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 480:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 484:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 488:	06c00c93          	li	s9,108
 48c:	a00d                	j	4ae <vprintf+0x5c>
        putc(fd, c0);
 48e:	85a6                	mv	a1,s1
 490:	855a                	mv	a0,s6
 492:	f11ff0ef          	jal	3a2 <putc>
 496:	a019                	j	49c <vprintf+0x4a>
    } else if (state == '%') {
 498:	03598363          	beq	s3,s5,4be <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 49c:	0019079b          	addiw	a5,s2,1
 4a0:	893e                	mv	s2,a5
 4a2:	873e                	mv	a4,a5
 4a4:	97d2                	add	a5,a5,s4
 4a6:	0007c483          	lbu	s1,0(a5)
 4aa:	22048763          	beqz	s1,6d8 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 4ae:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4b2:	fe0993e3          	bnez	s3,498 <vprintf+0x46>
      if (c0 == '%') {
 4b6:	fd579ce3          	bne	a5,s5,48e <vprintf+0x3c>
        state = '%';
 4ba:	89be                	mv	s3,a5
 4bc:	b7c5                	j	49c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 4be:	00ea06b3          	add	a3,s4,a4
 4c2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4c6:	8636                	mv	a2,a3
      if (c1)
 4c8:	c681                	beqz	a3,4d0 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 4ca:	9752                	add	a4,a4,s4
 4cc:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 4d0:	05878263          	beq	a5,s8,514 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 4d4:	05978c63          	beq	a5,s9,52c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4d8:	07500713          	li	a4,117
 4dc:	0ee78663          	beq	a5,a4,5c8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 4e0:	07800713          	li	a4,120
 4e4:	12e78863          	beq	a5,a4,614 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 4e8:	07000713          	li	a4,112
 4ec:	14e78d63          	beq	a5,a4,646 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 4f0:	06300713          	li	a4,99
 4f4:	18e78c63          	beq	a5,a4,68c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 4f8:	07300713          	li	a4,115
 4fc:	1ae78263          	beq	a5,a4,6a0 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 500:	02500713          	li	a4,37
 504:	04e79463          	bne	a5,a4,54c <vprintf+0xfa>
        putc(fd, '%');
 508:	85ba                	mv	a1,a4
 50a:	855a                	mv	a0,s6
 50c:	e97ff0ef          	jal	3a2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 510:	4981                	li	s3,0
 512:	b769                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b8493          	addi	s1,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	e9fff0ef          	jal	3c0 <printint>
 526:	8ba6                	mv	s7,s1
      state = 0;
 528:	4981                	li	s3,0
 52a:	bf8d                	j	49c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 52c:	06400793          	li	a5,100
 530:	02f68963          	beq	a3,a5,562 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 534:	06c00793          	li	a5,108
 538:	04f68263          	beq	a3,a5,57c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 53c:	07500793          	li	a5,117
 540:	0af68063          	beq	a3,a5,5e0 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 544:	07800793          	li	a5,120
 548:	0ef68263          	beq	a3,a5,62c <vprintf+0x1da>
        putc(fd, '%');
 54c:	02500593          	li	a1,37
 550:	855a                	mv	a0,s6
 552:	e51ff0ef          	jal	3a2 <putc>
        putc(fd, c0);
 556:	85a6                	mv	a1,s1
 558:	855a                	mv	a0,s6
 55a:	e49ff0ef          	jal	3a2 <putc>
      state = 0;
 55e:	4981                	li	s3,0
 560:	bf35                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 562:	008b8493          	addi	s1,s7,8
 566:	4685                	li	a3,1
 568:	4629                	li	a2,10
 56a:	000bb583          	ld	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e51ff0ef          	jal	3c0 <printint>
        i += 1;
 574:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 576:	8ba6                	mv	s7,s1
      state = 0;
 578:	4981                	li	s3,0
        i += 1;
 57a:	b70d                	j	49c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 57c:	06400793          	li	a5,100
 580:	02f60763          	beq	a2,a5,5ae <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 584:	07500793          	li	a5,117
 588:	06f60963          	beq	a2,a5,5fa <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 58c:	07800793          	li	a5,120
 590:	faf61ee3          	bne	a2,a5,54c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 594:	008b8493          	addi	s1,s7,8
 598:	4681                	li	a3,0
 59a:	4641                	li	a2,16
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e1fff0ef          	jal	3c0 <printint>
        i += 2;
 5a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	bdc5                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e05ff0ef          	jal	3c0 <printint>
        i += 2;
 5c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
        i += 2;
 5c6:	bdd9                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000be583          	lwu	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	debff0ef          	jal	3c0 <printint>
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bd7d                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	dd3ff0ef          	jal	3c0 <printint>
        i += 1;
 5f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 1;
 5f8:	b555                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	db9ff0ef          	jal	3c0 <printint>
        i += 2;
 60c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	b569                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000be583          	lwu	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	d9fff0ef          	jal	3c0 <printint>
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	bd8d                	j	49c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	d87ff0ef          	jal	3c0 <printint>
        i += 1;
 63e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
        i += 1;
 644:	bda1                	j	49c <vprintf+0x4a>
 646:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 648:	008b8d13          	addi	s10,s7,8
 64c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 650:	03000593          	li	a1,48
 654:	855a                	mv	a0,s6
 656:	d4dff0ef          	jal	3a2 <putc>
  putc(fd, 'x');
 65a:	07800593          	li	a1,120
 65e:	855a                	mv	a0,s6
 660:	d43ff0ef          	jal	3a2 <putc>
 664:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	272b8b93          	addi	s7,s7,626 # 8d8 <digits>
 66e:	03c9d793          	srli	a5,s3,0x3c
 672:	97de                	add	a5,a5,s7
 674:	0007c583          	lbu	a1,0(a5)
 678:	855a                	mv	a0,s6
 67a:	d29ff0ef          	jal	3a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 67e:	0992                	slli	s3,s3,0x4
 680:	34fd                	addiw	s1,s1,-1
 682:	f4f5                	bnez	s1,66e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 684:	8bea                	mv	s7,s10
      state = 0;
 686:	4981                	li	s3,0
 688:	6d02                	ld	s10,0(sp)
 68a:	bd09                	j	49c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 68c:	008b8493          	addi	s1,s7,8
 690:	000bc583          	lbu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d0dff0ef          	jal	3a2 <putc>
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bbfd                	j	49c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6a0:	008b8993          	addi	s3,s7,8
 6a4:	000bb483          	ld	s1,0(s7)
 6a8:	cc91                	beqz	s1,6c4 <vprintf+0x272>
        for (; *s; s++)
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	c195                	beqz	a1,6d2 <vprintf+0x280>
          putc(fd, *s);
 6b0:	855a                	mv	a0,s6
 6b2:	cf1ff0ef          	jal	3a2 <putc>
        for (; *s; s++)
 6b6:	0485                	addi	s1,s1,1
 6b8:	0004c583          	lbu	a1,0(s1)
 6bc:	f9f5                	bnez	a1,6b0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6be:	8bce                	mv	s7,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	bbe9                	j	49c <vprintf+0x4a>
          s = "(null)";
 6c4:	00000497          	auipc	s1,0x0
 6c8:	20c48493          	addi	s1,s1,524 # 8d0 <malloc+0xfc>
        for (; *s; s++)
 6cc:	02800593          	li	a1,40
 6d0:	b7c5                	j	6b0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6d2:	8bce                	mv	s7,s3
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b3d9                	j	49c <vprintf+0x4a>
 6d8:	6906                	ld	s2,64(sp)
 6da:	79e2                	ld	s3,56(sp)
 6dc:	7a42                	ld	s4,48(sp)
 6de:	7aa2                	ld	s5,40(sp)
 6e0:	7b02                	ld	s6,32(sp)
 6e2:	6be2                	ld	s7,24(sp)
 6e4:	6c42                	ld	s8,16(sp)
 6e6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6e8:	60e6                	ld	ra,88(sp)
 6ea:	6446                	ld	s0,80(sp)
 6ec:	64a6                	ld	s1,72(sp)
 6ee:	6125                	addi	sp,sp,96
 6f0:	8082                	ret

00000000000006f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f2:	715d                	addi	sp,sp,-80
 6f4:	ec06                	sd	ra,24(sp)
 6f6:	e822                	sd	s0,16(sp)
 6f8:	1000                	addi	s0,sp,32
 6fa:	e010                	sd	a2,0(s0)
 6fc:	e414                	sd	a3,8(s0)
 6fe:	e818                	sd	a4,16(s0)
 700:	ec1c                	sd	a5,24(s0)
 702:	03043023          	sd	a6,32(s0)
 706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	8622                	mv	a2,s0
 70c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 710:	d43ff0ef          	jal	452 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <printf>:

void
printf(const char *fmt, ...)
{
 71c:	711d                	addi	sp,sp,-96
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e40c                	sd	a1,8(s0)
 726:	e810                	sd	a2,16(s0)
 728:	ec14                	sd	a3,24(s0)
 72a:	f018                	sd	a4,32(s0)
 72c:	f41c                	sd	a5,40(s0)
 72e:	03043823          	sd	a6,48(s0)
 732:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	00840613          	addi	a2,s0,8
 73a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73e:	85aa                	mv	a1,a0
 740:	4505                	li	a0,1
 742:	d11ff0ef          	jal	452 <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret

000000000000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	1141                	addi	sp,sp,-16
 750:	e406                	sd	ra,8(sp)
 752:	e022                	sd	s0,0(sp)
 754:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 756:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75a:	00001797          	auipc	a5,0x1
 75e:	8a67b783          	ld	a5,-1882(a5) # 1000 <freep>
 762:	a02d                	j	78c <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 764:	4618                	lw	a4,8(a2)
 766:	9f2d                	addw	a4,a4,a1
 768:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	6398                	ld	a4,0(a5)
 76e:	6310                	ld	a2,0(a4)
 770:	a83d                	j	7ae <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 772:	ff852703          	lw	a4,-8(a0)
 776:	9f31                	addw	a4,a4,a2
 778:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77a:	ff053683          	ld	a3,-16(a0)
 77e:	a091                	j	7c2 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	6398                	ld	a4,0(a5)
 782:	00e7e463          	bltu	a5,a4,78a <free+0x3c>
 786:	00e6ea63          	bltu	a3,a4,79a <free+0x4c>
{
 78a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	fed7fae3          	bgeu	a5,a3,780 <free+0x32>
 790:	6398                	ld	a4,0(a5)
 792:	00e6e463          	bltu	a3,a4,79a <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 796:	fee7eae3          	bltu	a5,a4,78a <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 79a:	ff852583          	lw	a1,-8(a0)
 79e:	6390                	ld	a2,0(a5)
 7a0:	02059813          	slli	a6,a1,0x20
 7a4:	01c85713          	srli	a4,a6,0x1c
 7a8:	9736                	add	a4,a4,a3
 7aa:	fae60de3          	beq	a2,a4,764 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ae:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 7b2:	4790                	lw	a2,8(a5)
 7b4:	02061593          	slli	a1,a2,0x20
 7b8:	01c5d713          	srli	a4,a1,0x1c
 7bc:	973e                	add	a4,a4,a5
 7be:	fae68ae3          	beq	a3,a4,772 <free+0x24>
    p->s.ptr = bp->s.ptr;
 7c2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c4:	00001717          	auipc	a4,0x1
 7c8:	82f73e23          	sd	a5,-1988(a4) # 1000 <freep>
}
 7cc:	60a2                	ld	ra,8(sp)
 7ce:	6402                	ld	s0,0(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f04a                	sd	s2,32(sp)
 7dc:	ec4e                	sd	s3,24(sp)
 7de:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7e0:	02051993          	slli	s3,a0,0x20
 7e4:	0209d993          	srli	s3,s3,0x20
 7e8:	09bd                	addi	s3,s3,15
 7ea:	0049d993          	srli	s3,s3,0x4
 7ee:	2985                	addiw	s3,s3,1
 7f0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 7f2:	00001517          	auipc	a0,0x1
 7f6:	80e53503          	ld	a0,-2034(a0) # 1000 <freep>
 7fa:	c905                	beqz	a0,82a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 7fc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 7fe:	4798                	lw	a4,8(a5)
 800:	09377663          	bgeu	a4,s3,88c <malloc+0xb8>
 804:	f426                	sd	s1,40(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 80c:	8a4e                	mv	s4,s3
 80e:	6705                	lui	a4,0x1
 810:	00e9f363          	bgeu	s3,a4,816 <malloc+0x42>
 814:	6a05                	lui	s4,0x1
 816:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 81e:	00000497          	auipc	s1,0x0
 822:	7e248493          	addi	s1,s1,2018 # 1000 <freep>
  if (p == SBRK_ERROR)
 826:	5afd                	li	s5,-1
 828:	a83d                	j	866 <malloc+0x92>
 82a:	f426                	sd	s1,40(sp)
 82c:	e852                	sd	s4,16(sp)
 82e:	e456                	sd	s5,8(sp)
 830:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 832:	00000797          	auipc	a5,0x0
 836:	7de78793          	addi	a5,a5,2014 # 1010 <base>
 83a:	00000717          	auipc	a4,0x0
 83e:	7cf73323          	sd	a5,1990(a4) # 1000 <freep>
 842:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 844:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 848:	b7d1                	j	80c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 84a:	6398                	ld	a4,0(a5)
 84c:	e118                	sd	a4,0(a0)
 84e:	a899                	j	8a4 <malloc+0xd0>
  hp->s.size = nu;
 850:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 854:	0541                	addi	a0,a0,16
 856:	ef9ff0ef          	jal	74e <free>
  return freep;
 85a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 85c:	c125                	beqz	a0,8bc <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 85e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 860:	4798                	lw	a4,8(a5)
 862:	03277163          	bgeu	a4,s2,884 <malloc+0xb0>
    if (p == freep)
 866:	6098                	ld	a4,0(s1)
 868:	853e                	mv	a0,a5
 86a:	fef71ae3          	bne	a4,a5,85e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 86e:	8552                	mv	a0,s4
 870:	a37ff0ef          	jal	2a6 <sbrk>
  if (p == SBRK_ERROR)
 874:	fd551ee3          	bne	a0,s5,850 <malloc+0x7c>
        return 0;
 878:	4501                	li	a0,0
 87a:	74a2                	ld	s1,40(sp)
 87c:	6a42                	ld	s4,16(sp)
 87e:	6aa2                	ld	s5,8(sp)
 880:	6b02                	ld	s6,0(sp)
 882:	a03d                	j	8b0 <malloc+0xdc>
 884:	74a2                	ld	s1,40(sp)
 886:	6a42                	ld	s4,16(sp)
 888:	6aa2                	ld	s5,8(sp)
 88a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 88c:	fae90fe3          	beq	s2,a4,84a <malloc+0x76>
        p->s.size -= nunits;
 890:	4137073b          	subw	a4,a4,s3
 894:	c798                	sw	a4,8(a5)
        p += p->s.size;
 896:	02071693          	slli	a3,a4,0x20
 89a:	01c6d713          	srli	a4,a3,0x1c
 89e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8a0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74a73e23          	sd	a0,1884(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ac:	01078513          	addi	a0,a5,16
  }
}
 8b0:	70e2                	ld	ra,56(sp)
 8b2:	7442                	ld	s0,48(sp)
 8b4:	7902                	ld	s2,32(sp)
 8b6:	69e2                	ld	s3,24(sp)
 8b8:	6121                	addi	sp,sp,64
 8ba:	8082                	ret
 8bc:	74a2                	ld	s1,40(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	b7f5                	j	8b0 <malloc+0xdc>
