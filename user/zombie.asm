
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (fork() > 0)
   8:	2d6000ef          	jal	2de <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5); // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2d4000ef          	jal	2e6 <exit>
    pause(5); // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	35e000ef          	jal	376 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	2bc000ef          	jal	2e6 <exit>

000000000000002e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf99                	beqz	a5,a8 <strlen+0x2a>
  8c:	0505                	addi	a0,a0,1
  8e:	87aa                	mv	a5,a0
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
  9e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for (n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfdd                	j	a0 <strlen+0x22>

00000000000000ac <memset>:

void *
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  b4:	ca19                	beqz	a2,ca <memset+0x1e>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x14>
  }
  return dst;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char *
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  for (; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf81                	beqz	a5,f6 <strchr+0x24>
    if (*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1c>
  for (; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xe>
      return (char *)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret
  return 0;
  f6:	4501                	li	a0,0
  f8:	bfdd                	j	ee <strchr+0x1c>

00000000000000fa <gets>:

char *
gets(char *buf, int max)
{
  fa:	7159                	addi	sp,sp,-112
  fc:	f486                	sd	ra,104(sp)
  fe:	f0a2                	sd	s0,96(sp)
 100:	eca6                	sd	s1,88(sp)
 102:	e8ca                	sd	s2,80(sp)
 104:	e4ce                	sd	s3,72(sp)
 106:	e0d2                	sd	s4,64(sp)
 108:	fc56                	sd	s5,56(sp)
 10a:	f85a                	sd	s6,48(sp)
 10c:	f45e                	sd	s7,40(sp)
 10e:	f062                	sd	s8,32(sp)
 110:	ec66                	sd	s9,24(sp)
 112:	e86a                	sd	s10,16(sp)
 114:	1880                	addi	s0,sp,112
 116:	8caa                	mv	s9,a0
 118:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 11a:	892a                	mv	s2,a0
 11c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11e:	f9f40b13          	addi	s6,s0,-97
 122:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 124:	4ba9                	li	s7,10
 126:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 128:	8d26                	mv	s10,s1
 12a:	0014899b          	addiw	s3,s1,1
 12e:	84ce                	mv	s1,s3
 130:	0349d563          	bge	s3,s4,15a <gets+0x60>
    cc = read(0, &c, 1);
 134:	8656                	mv	a2,s5
 136:	85da                	mv	a1,s6
 138:	4501                	li	a0,0
 13a:	1c4000ef          	jal	2fe <read>
    if (cc < 1)
 13e:	00a05e63          	blez	a0,15a <gets+0x60>
    buf[i++] = c;
 142:	f9f44783          	lbu	a5,-97(s0)
 146:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 14a:	01778763          	beq	a5,s7,158 <gets+0x5e>
 14e:	0905                	addi	s2,s2,1
 150:	fd879ce3          	bne	a5,s8,128 <gets+0x2e>
    buf[i++] = c;
 154:	8d4e                	mv	s10,s3
 156:	a011                	j	15a <gets+0x60>
 158:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 15a:	9d66                	add	s10,s10,s9
 15c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 160:	8566                	mv	a0,s9
 162:	70a6                	ld	ra,104(sp)
 164:	7406                	ld	s0,96(sp)
 166:	64e6                	ld	s1,88(sp)
 168:	6946                	ld	s2,80(sp)
 16a:	69a6                	ld	s3,72(sp)
 16c:	6a06                	ld	s4,64(sp)
 16e:	7ae2                	ld	s5,56(sp)
 170:	7b42                	ld	s6,48(sp)
 172:	7ba2                	ld	s7,40(sp)
 174:	7c02                	ld	s8,32(sp)
 176:	6ce2                	ld	s9,24(sp)
 178:	6d42                	ld	s10,16(sp)
 17a:	6165                	addi	sp,sp,112
 17c:	8082                	ret

000000000000017e <stat>:

int
stat(const char *n, struct stat *st)
{
 17e:	1101                	addi	sp,sp,-32
 180:	ec06                	sd	ra,24(sp)
 182:	e822                	sd	s0,16(sp)
 184:	e04a                	sd	s2,0(sp)
 186:	1000                	addi	s0,sp,32
 188:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18a:	4581                	li	a1,0
 18c:	19a000ef          	jal	326 <open>
  if (fd < 0)
 190:	02054263          	bltz	a0,1b4 <stat+0x36>
 194:	e426                	sd	s1,8(sp)
 196:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 198:	85ca                	mv	a1,s2
 19a:	1a4000ef          	jal	33e <fstat>
 19e:	892a                	mv	s2,a0
  close(fd);
 1a0:	8526                	mv	a0,s1
 1a2:	16c000ef          	jal	30e <close>
  return r;
 1a6:	64a2                	ld	s1,8(sp)
}
 1a8:	854a                	mv	a0,s2
 1aa:	60e2                	ld	ra,24(sp)
 1ac:	6442                	ld	s0,16(sp)
 1ae:	6902                	ld	s2,0(sp)
 1b0:	6105                	addi	sp,sp,32
 1b2:	8082                	ret
    return -1;
 1b4:	597d                	li	s2,-1
 1b6:	bfcd                	j	1a8 <stat+0x2a>

00000000000001b8 <atoi>:

int
atoi(const char *s)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1c0:	00054683          	lbu	a3,0(a0)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	4625                	li	a2,9
 1ce:	02f66963          	bltu	a2,a5,200 <atoi+0x48>
 1d2:	872a                	mv	a4,a0
  n = 0;
 1d4:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1d6:	0705                	addi	a4,a4,1
 1d8:	0025179b          	slliw	a5,a0,0x2
 1dc:	9fa9                	addw	a5,a5,a0
 1de:	0017979b          	slliw	a5,a5,0x1
 1e2:	9fb5                	addw	a5,a5,a3
 1e4:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1e8:	00074683          	lbu	a3,0(a4)
 1ec:	fd06879b          	addiw	a5,a3,-48
 1f0:	0ff7f793          	zext.b	a5,a5
 1f4:	fef671e3          	bgeu	a2,a5,1d6 <atoi+0x1e>
  return n;
}
 1f8:	60a2                	ld	ra,8(sp)
 1fa:	6402                	ld	s0,0(sp)
 1fc:	0141                	addi	sp,sp,16
 1fe:	8082                	ret
  n = 0;
 200:	4501                	li	a0,0
 202:	bfdd                	j	1f8 <atoi+0x40>

0000000000000204 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20c:	02b57563          	bgeu	a0,a1,236 <memmove+0x32>
    while (n-- > 0)
 210:	00c05f63          	blez	a2,22e <memmove+0x2a>
 214:	1602                	slli	a2,a2,0x20
 216:	9201                	srli	a2,a2,0x20
 218:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21c:	872a                	mv	a4,a0
      *dst++ = *src++;
 21e:	0585                	addi	a1,a1,1
 220:	0705                	addi	a4,a4,1
 222:	fff5c683          	lbu	a3,-1(a1)
 226:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 22a:	fee79ae3          	bne	a5,a4,21e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
    dst += n;
 236:	00c50733          	add	a4,a0,a2
    src += n;
 23a:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 23c:	fec059e3          	blez	a2,22e <memmove+0x2a>
 240:	fff6079b          	addiw	a5,a2,-1
 244:	1782                	slli	a5,a5,0x20
 246:	9381                	srli	a5,a5,0x20
 248:	fff7c793          	not	a5,a5
 24c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24e:	15fd                	addi	a1,a1,-1
 250:	177d                	addi	a4,a4,-1
 252:	0005c683          	lbu	a3,0(a1)
 256:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x4a>
 25e:	bfc1                	j	22e <memmove+0x2a>

0000000000000260 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca0d                	beqz	a2,29a <memcmp+0x3a>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x16>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x32>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  return 0;
 29a:	4501                	li	a0,0
 29c:	bfdd                	j	292 <memcmp+0x32>

000000000000029e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a6:	f5fff0ef          	jal	204 <memmove>
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret

00000000000002b2 <sbrk>:

char *
sbrk(int n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ba:	4585                	li	a1,1
 2bc:	0b2000ef          	jal	36e <sys_sbrk>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <sbrklazy>:

char *
sbrklazy(int n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d0:	4589                	li	a1,2
 2d2:	09c000ef          	jal	36e <sys_sbrk>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <pause>:
.global pause
pause:
 li a7, SYS_pause
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <sync>:
.global sync
sync:
 li a7, SYS_sync
 386:	48d9                	li	a7,22
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <ps>:
.global ps
ps:
 li a7, SYS_ps
 38e:	48dd                	li	a7,23
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 396:	48e1                	li	a7,24
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 39e:	48e5                	li	a7,25
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3a6:	48e9                	li	a7,26
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	f47ff0ef          	jal	306 <write>
}
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	6105                	addi	sp,sp,32
 3ca:	8082                	ret

00000000000003cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3cc:	715d                	addi	sp,sp,-80
 3ce:	e486                	sd	ra,72(sp)
 3d0:	e0a2                	sd	s0,64(sp)
 3d2:	fc26                	sd	s1,56(sp)
 3d4:	f84a                	sd	s2,48(sp)
 3d6:	f44e                	sd	s3,40(sp)
 3d8:	0880                	addi	s0,sp,80
 3da:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3dc:	c299                	beqz	a3,3e2 <printint+0x16>
 3de:	0605cc63          	bltz	a1,456 <printint+0x8a>
  neg = 0;
 3e2:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3e4:	fb840313          	addi	t1,s0,-72
  neg = 0;
 3e8:	869a                	mv	a3,t1
  i = 0;
 3ea:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	4fc80813          	addi	a6,a6,1276 # 8e8 <digits>
 3f4:	88be                	mv	a7,a5
 3f6:	0017851b          	addiw	a0,a5,1
 3fa:	87aa                	mv	a5,a0
 3fc:	02c5f733          	remu	a4,a1,a2
 400:	9742                	add	a4,a4,a6
 402:	00074703          	lbu	a4,0(a4)
 406:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 40a:	872e                	mv	a4,a1
 40c:	02c5d5b3          	divu	a1,a1,a2
 410:	0685                	addi	a3,a3,1
 412:	fec771e3          	bgeu	a4,a2,3f4 <printint+0x28>
  if (neg)
 416:	000e0c63          	beqz	t3,42e <printint+0x62>
    buf[i++] = '-';
 41a:	fd050793          	addi	a5,a0,-48
 41e:	00878533          	add	a0,a5,s0
 422:	02d00793          	li	a5,45
 426:	fef50423          	sb	a5,-24(a0)
 42a:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 42e:	fff7899b          	addiw	s3,a5,-1
 432:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 436:	fff4c583          	lbu	a1,-1(s1)
 43a:	854a                	mv	a0,s2
 43c:	f73ff0ef          	jal	3ae <putc>
  while (--i >= 0)
 440:	39fd                	addiw	s3,s3,-1
 442:	14fd                	addi	s1,s1,-1
 444:	fe09d9e3          	bgez	s3,436 <printint+0x6a>
}
 448:	60a6                	ld	ra,72(sp)
 44a:	6406                	ld	s0,64(sp)
 44c:	74e2                	ld	s1,56(sp)
 44e:	7942                	ld	s2,48(sp)
 450:	79a2                	ld	s3,40(sp)
 452:	6161                	addi	sp,sp,80
 454:	8082                	ret
    x = -xx;
 456:	40b005b3          	neg	a1,a1
    neg = 1;
 45a:	4e05                	li	t3,1
    x = -xx;
 45c:	b761                	j	3e4 <printint+0x18>

000000000000045e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45e:	711d                	addi	sp,sp,-96
 460:	ec86                	sd	ra,88(sp)
 462:	e8a2                	sd	s0,80(sp)
 464:	e4a6                	sd	s1,72(sp)
 466:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 468:	0005c483          	lbu	s1,0(a1)
 46c:	28048463          	beqz	s1,6f4 <vprintf+0x296>
 470:	e0ca                	sd	s2,64(sp)
 472:	fc4e                	sd	s3,56(sp)
 474:	f852                	sd	s4,48(sp)
 476:	f456                	sd	s5,40(sp)
 478:	f05a                	sd	s6,32(sp)
 47a:	ec5e                	sd	s7,24(sp)
 47c:	e862                	sd	s8,16(sp)
 47e:	e466                	sd	s9,8(sp)
 480:	8b2a                	mv	s6,a0
 482:	8a2e                	mv	s4,a1
 484:	8bb2                	mv	s7,a2
  state = 0;
 486:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 488:	4901                	li	s2,0
 48a:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 48c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 490:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 494:	06c00c93          	li	s9,108
 498:	a00d                	j	4ba <vprintf+0x5c>
        putc(fd, c0);
 49a:	85a6                	mv	a1,s1
 49c:	855a                	mv	a0,s6
 49e:	f11ff0ef          	jal	3ae <putc>
 4a2:	a019                	j	4a8 <vprintf+0x4a>
    } else if (state == '%') {
 4a4:	03598363          	beq	s3,s5,4ca <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 4a8:	0019079b          	addiw	a5,s2,1
 4ac:	893e                	mv	s2,a5
 4ae:	873e                	mv	a4,a5
 4b0:	97d2                	add	a5,a5,s4
 4b2:	0007c483          	lbu	s1,0(a5)
 4b6:	22048763          	beqz	s1,6e4 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 4ba:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4be:	fe0993e3          	bnez	s3,4a4 <vprintf+0x46>
      if (c0 == '%') {
 4c2:	fd579ce3          	bne	a5,s5,49a <vprintf+0x3c>
        state = '%';
 4c6:	89be                	mv	s3,a5
 4c8:	b7c5                	j	4a8 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 4ca:	00ea06b3          	add	a3,s4,a4
 4ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4d2:	8636                	mv	a2,a3
      if (c1)
 4d4:	c681                	beqz	a3,4dc <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 4d6:	9752                	add	a4,a4,s4
 4d8:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 4dc:	05878263          	beq	a5,s8,520 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 4e0:	05978c63          	beq	a5,s9,538 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4e4:	07500713          	li	a4,117
 4e8:	0ee78663          	beq	a5,a4,5d4 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 4ec:	07800713          	li	a4,120
 4f0:	12e78863          	beq	a5,a4,620 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 4f4:	07000713          	li	a4,112
 4f8:	14e78d63          	beq	a5,a4,652 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 4fc:	06300713          	li	a4,99
 500:	18e78c63          	beq	a5,a4,698 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 504:	07300713          	li	a4,115
 508:	1ae78263          	beq	a5,a4,6ac <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 50c:	02500713          	li	a4,37
 510:	04e79463          	bne	a5,a4,558 <vprintf+0xfa>
        putc(fd, '%');
 514:	85ba                	mv	a1,a4
 516:	855a                	mv	a0,s6
 518:	e97ff0ef          	jal	3ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 51c:	4981                	li	s3,0
 51e:	b769                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 520:	008b8493          	addi	s1,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	e9fff0ef          	jal	3cc <printint>
 532:	8ba6                	mv	s7,s1
      state = 0;
 534:	4981                	li	s3,0
 536:	bf8d                	j	4a8 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 538:	06400793          	li	a5,100
 53c:	02f68963          	beq	a3,a5,56e <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 540:	06c00793          	li	a5,108
 544:	04f68263          	beq	a3,a5,588 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 548:	07500793          	li	a5,117
 54c:	0af68063          	beq	a3,a5,5ec <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 550:	07800793          	li	a5,120
 554:	0ef68263          	beq	a3,a5,638 <vprintf+0x1da>
        putc(fd, '%');
 558:	02500593          	li	a1,37
 55c:	855a                	mv	a0,s6
 55e:	e51ff0ef          	jal	3ae <putc>
        putc(fd, c0);
 562:	85a6                	mv	a1,s1
 564:	855a                	mv	a0,s6
 566:	e49ff0ef          	jal	3ae <putc>
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf35                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e51ff0ef          	jal	3cc <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
        i += 1;
 586:	b70d                	j	4a8 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 588:	06400793          	li	a5,100
 58c:	02f60763          	beq	a2,a5,5ba <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 590:	07500793          	li	a5,117
 594:	06f60963          	beq	a2,a5,606 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 598:	07800793          	li	a5,120
 59c:	faf61ee3          	bne	a2,a5,558 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000bb583          	ld	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e1fff0ef          	jal	3cc <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bdc5                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4685                	li	a3,1
 5c0:	4629                	li	a2,10
 5c2:	000bb583          	ld	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e05ff0ef          	jal	3cc <printint>
        i += 2;
 5cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
        i += 2;
 5d2:	bdd9                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000be583          	lwu	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	debff0ef          	jal	3cc <printint>
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bd7d                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dd3ff0ef          	jal	3cc <printint>
        i += 1;
 5fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 1;
 604:	b555                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000bb583          	ld	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	db9ff0ef          	jal	3cc <printint>
        i += 2;
 618:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	8ba6                	mv	s7,s1
      state = 0;
 61c:	4981                	li	s3,0
        i += 2;
 61e:	b569                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 620:	008b8493          	addi	s1,s7,8
 624:	4681                	li	a3,0
 626:	4641                	li	a2,16
 628:	000be583          	lwu	a1,0(s7)
 62c:	855a                	mv	a0,s6
 62e:	d9fff0ef          	jal	3cc <printint>
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	bd8d                	j	4a8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000bb583          	ld	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d87ff0ef          	jal	3cc <printint>
        i += 1;
 64a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
        i += 1;
 650:	bda1                	j	4a8 <vprintf+0x4a>
 652:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 654:	008b8d13          	addi	s10,s7,8
 658:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	855a                	mv	a0,s6
 662:	d4dff0ef          	jal	3ae <putc>
  putc(fd, 'x');
 666:	07800593          	li	a1,120
 66a:	855a                	mv	a0,s6
 66c:	d43ff0ef          	jal	3ae <putc>
 670:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	276b8b93          	addi	s7,s7,630 # 8e8 <digits>
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	855a                	mv	a0,s6
 686:	d29ff0ef          	jal	3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68a:	0992                	slli	s3,s3,0x4
 68c:	34fd                	addiw	s1,s1,-1
 68e:	f4f5                	bnez	s1,67a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 690:	8bea                	mv	s7,s10
      state = 0;
 692:	4981                	li	s3,0
 694:	6d02                	ld	s10,0(sp)
 696:	bd09                	j	4a8 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 698:	008b8493          	addi	s1,s7,8
 69c:	000bc583          	lbu	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	d0dff0ef          	jal	3ae <putc>
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bbfd                	j	4a8 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6ac:	008b8993          	addi	s3,s7,8
 6b0:	000bb483          	ld	s1,0(s7)
 6b4:	cc91                	beqz	s1,6d0 <vprintf+0x272>
        for (; *s; s++)
 6b6:	0004c583          	lbu	a1,0(s1)
 6ba:	c195                	beqz	a1,6de <vprintf+0x280>
          putc(fd, *s);
 6bc:	855a                	mv	a0,s6
 6be:	cf1ff0ef          	jal	3ae <putc>
        for (; *s; s++)
 6c2:	0485                	addi	s1,s1,1
 6c4:	0004c583          	lbu	a1,0(s1)
 6c8:	f9f5                	bnez	a1,6bc <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bbe9                	j	4a8 <vprintf+0x4a>
          s = "(null)";
 6d0:	00000497          	auipc	s1,0x0
 6d4:	21048493          	addi	s1,s1,528 # 8e0 <malloc+0x100>
        for (; *s; s++)
 6d8:	02800593          	li	a1,40
 6dc:	b7c5                	j	6bc <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b3d9                	j	4a8 <vprintf+0x4a>
 6e4:	6906                	ld	s2,64(sp)
 6e6:	79e2                	ld	s3,56(sp)
 6e8:	7a42                	ld	s4,48(sp)
 6ea:	7aa2                	ld	s5,40(sp)
 6ec:	7b02                	ld	s6,32(sp)
 6ee:	6be2                	ld	s7,24(sp)
 6f0:	6c42                	ld	s8,16(sp)
 6f2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6f4:	60e6                	ld	ra,88(sp)
 6f6:	6446                	ld	s0,80(sp)
 6f8:	64a6                	ld	s1,72(sp)
 6fa:	6125                	addi	sp,sp,96
 6fc:	8082                	ret

00000000000006fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fe:	715d                	addi	sp,sp,-80
 700:	ec06                	sd	ra,24(sp)
 702:	e822                	sd	s0,16(sp)
 704:	1000                	addi	s0,sp,32
 706:	e010                	sd	a2,0(s0)
 708:	e414                	sd	a3,8(s0)
 70a:	e818                	sd	a4,16(s0)
 70c:	ec1c                	sd	a5,24(s0)
 70e:	03043023          	sd	a6,32(s0)
 712:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 716:	8622                	mv	a2,s0
 718:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 71c:	d43ff0ef          	jal	45e <vprintf>
}
 720:	60e2                	ld	ra,24(sp)
 722:	6442                	ld	s0,16(sp)
 724:	6161                	addi	sp,sp,80
 726:	8082                	ret

0000000000000728 <printf>:

void
printf(const char *fmt, ...)
{
 728:	711d                	addi	sp,sp,-96
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	addi	s0,sp,32
 730:	e40c                	sd	a1,8(s0)
 732:	e810                	sd	a2,16(s0)
 734:	ec14                	sd	a3,24(s0)
 736:	f018                	sd	a4,32(s0)
 738:	f41c                	sd	a5,40(s0)
 73a:	03043823          	sd	a6,48(s0)
 73e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	00840613          	addi	a2,s0,8
 746:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74a:	85aa                	mv	a1,a0
 74c:	4505                	li	a0,1
 74e:	d11ff0ef          	jal	45e <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret

000000000000075a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 75a:	1141                	addi	sp,sp,-16
 75c:	e406                	sd	ra,8(sp)
 75e:	e022                	sd	s0,0(sp)
 760:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 762:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	00001797          	auipc	a5,0x1
 76a:	89a7b783          	ld	a5,-1894(a5) # 1000 <freep>
 76e:	a02d                	j	798 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 770:	4618                	lw	a4,8(a2)
 772:	9f2d                	addw	a4,a4,a1
 774:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 778:	6398                	ld	a4,0(a5)
 77a:	6310                	ld	a2,0(a4)
 77c:	a83d                	j	7ba <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 77e:	ff852703          	lw	a4,-8(a0)
 782:	9f31                	addw	a4,a4,a2
 784:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 786:	ff053683          	ld	a3,-16(a0)
 78a:	a091                	j	7ce <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	6398                	ld	a4,0(a5)
 78e:	00e7e463          	bltu	a5,a4,796 <free+0x3c>
 792:	00e6ea63          	bltu	a3,a4,7a6 <free+0x4c>
{
 796:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	fed7fae3          	bgeu	a5,a3,78c <free+0x32>
 79c:	6398                	ld	a4,0(a5)
 79e:	00e6e463          	bltu	a3,a4,7a6 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a2:	fee7eae3          	bltu	a5,a4,796 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7a6:	ff852583          	lw	a1,-8(a0)
 7aa:	6390                	ld	a2,0(a5)
 7ac:	02059813          	slli	a6,a1,0x20
 7b0:	01c85713          	srli	a4,a6,0x1c
 7b4:	9736                	add	a4,a4,a3
 7b6:	fae60de3          	beq	a2,a4,770 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 7be:	4790                	lw	a2,8(a5)
 7c0:	02061593          	slli	a1,a2,0x20
 7c4:	01c5d713          	srli	a4,a1,0x1c
 7c8:	973e                	add	a4,a4,a5
 7ca:	fae68ae3          	beq	a3,a4,77e <free+0x24>
    p->s.ptr = bp->s.ptr;
 7ce:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d0:	00001717          	auipc	a4,0x1
 7d4:	82f73823          	sd	a5,-2000(a4) # 1000 <freep>
}
 7d8:	60a2                	ld	ra,8(sp)
 7da:	6402                	ld	s0,0(sp)
 7dc:	0141                	addi	sp,sp,16
 7de:	8082                	ret

00000000000007e0 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7e0:	7139                	addi	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f04a                	sd	s2,32(sp)
 7e8:	ec4e                	sd	s3,24(sp)
 7ea:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 7ec:	02051993          	slli	s3,a0,0x20
 7f0:	0209d993          	srli	s3,s3,0x20
 7f4:	09bd                	addi	s3,s3,15
 7f6:	0049d993          	srli	s3,s3,0x4
 7fa:	2985                	addiw	s3,s3,1
 7fc:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 7fe:	00001517          	auipc	a0,0x1
 802:	80253503          	ld	a0,-2046(a0) # 1000 <freep>
 806:	c905                	beqz	a0,836 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 808:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 80a:	4798                	lw	a4,8(a5)
 80c:	09377663          	bgeu	a4,s3,898 <malloc+0xb8>
 810:	f426                	sd	s1,40(sp)
 812:	e852                	sd	s4,16(sp)
 814:	e456                	sd	s5,8(sp)
 816:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 818:	8a4e                	mv	s4,s3
 81a:	6705                	lui	a4,0x1
 81c:	00e9f363          	bgeu	s3,a4,822 <malloc+0x42>
 820:	6a05                	lui	s4,0x1
 822:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 826:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 82a:	00000497          	auipc	s1,0x0
 82e:	7d648493          	addi	s1,s1,2006 # 1000 <freep>
  if (p == SBRK_ERROR)
 832:	5afd                	li	s5,-1
 834:	a83d                	j	872 <malloc+0x92>
 836:	f426                	sd	s1,40(sp)
 838:	e852                	sd	s4,16(sp)
 83a:	e456                	sd	s5,8(sp)
 83c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 83e:	00000797          	auipc	a5,0x0
 842:	7d278793          	addi	a5,a5,2002 # 1010 <base>
 846:	00000717          	auipc	a4,0x0
 84a:	7af73d23          	sd	a5,1978(a4) # 1000 <freep>
 84e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 850:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 854:	b7d1                	j	818 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 856:	6398                	ld	a4,0(a5)
 858:	e118                	sd	a4,0(a0)
 85a:	a899                	j	8b0 <malloc+0xd0>
  hp->s.size = nu;
 85c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 860:	0541                	addi	a0,a0,16
 862:	ef9ff0ef          	jal	75a <free>
  return freep;
 866:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 868:	c125                	beqz	a0,8c8 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 86a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 86c:	4798                	lw	a4,8(a5)
 86e:	03277163          	bgeu	a4,s2,890 <malloc+0xb0>
    if (p == freep)
 872:	6098                	ld	a4,0(s1)
 874:	853e                	mv	a0,a5
 876:	fef71ae3          	bne	a4,a5,86a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 87a:	8552                	mv	a0,s4
 87c:	a37ff0ef          	jal	2b2 <sbrk>
  if (p == SBRK_ERROR)
 880:	fd551ee3          	bne	a0,s5,85c <malloc+0x7c>
        return 0;
 884:	4501                	li	a0,0
 886:	74a2                	ld	s1,40(sp)
 888:	6a42                	ld	s4,16(sp)
 88a:	6aa2                	ld	s5,8(sp)
 88c:	6b02                	ld	s6,0(sp)
 88e:	a03d                	j	8bc <malloc+0xdc>
 890:	74a2                	ld	s1,40(sp)
 892:	6a42                	ld	s4,16(sp)
 894:	6aa2                	ld	s5,8(sp)
 896:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 898:	fae90fe3          	beq	s2,a4,856 <malloc+0x76>
        p->s.size -= nunits;
 89c:	4137073b          	subw	a4,a4,s3
 8a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a2:	02071693          	slli	a3,a4,0x20
 8a6:	01c6d713          	srli	a4,a3,0x1c
 8aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b0:	00000717          	auipc	a4,0x0
 8b4:	74a73823          	sd	a0,1872(a4) # 1000 <freep>
      return (void *)(p + 1);
 8b8:	01078513          	addi	a0,a5,16
  }
}
 8bc:	70e2                	ld	ra,56(sp)
 8be:	7442                	ld	s0,48(sp)
 8c0:	7902                	ld	s2,32(sp)
 8c2:	69e2                	ld	s3,24(sp)
 8c4:	6121                	addi	sp,sp,64
 8c6:	8082                	ret
 8c8:	74a2                	ld	s1,40(sp)
 8ca:	6a42                	ld	s4,16(sp)
 8cc:	6aa2                	ld	s5,8(sp)
 8ce:	6b02                	ld	s6,0(sp)
 8d0:	b7f5                	j	8bc <malloc+0xdc>
