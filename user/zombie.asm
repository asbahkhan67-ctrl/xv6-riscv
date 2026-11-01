
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

00000000000003ae <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ae:	48ed                	li	a7,27
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3b6:	48f1                	li	a7,28
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3be:	48f5                	li	a7,29
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3c6:	48f9                	li	a7,30
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3ce:	48fd                	li	a7,31
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 3d6:	02000893          	li	a7,32
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <halt>:
.global halt
halt:
 li a7, SYS_halt
 3e0:	02100893          	li	a7,33
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 3ea:	02200893          	li	a7,34
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 3f4:	02300893          	li	a7,35
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 3fe:	02400893          	li	a7,36
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 408:	02500893          	li	a7,37
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 412:	1101                	addi	sp,sp,-32
 414:	ec06                	sd	ra,24(sp)
 416:	e822                	sd	s0,16(sp)
 418:	1000                	addi	s0,sp,32
 41a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 41e:	4605                	li	a2,1
 420:	fef40593          	addi	a1,s0,-17
 424:	ee3ff0ef          	jal	306 <write>
}
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6105                	addi	sp,sp,32
 42e:	8082                	ret

0000000000000430 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 430:	715d                	addi	sp,sp,-80
 432:	e486                	sd	ra,72(sp)
 434:	e0a2                	sd	s0,64(sp)
 436:	fc26                	sd	s1,56(sp)
 438:	f84a                	sd	s2,48(sp)
 43a:	f44e                	sd	s3,40(sp)
 43c:	0880                	addi	s0,sp,80
 43e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 440:	c299                	beqz	a3,446 <printint+0x16>
 442:	0605cc63          	bltz	a1,4ba <printint+0x8a>
  neg = 0;
 446:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 448:	fb840313          	addi	t1,s0,-72
  neg = 0;
 44c:	869a                	mv	a3,t1
  i = 0;
 44e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 450:	00000817          	auipc	a6,0x0
 454:	4f880813          	addi	a6,a6,1272 # 948 <digits>
 458:	88be                	mv	a7,a5
 45a:	0017851b          	addiw	a0,a5,1
 45e:	87aa                	mv	a5,a0
 460:	02c5f733          	remu	a4,a1,a2
 464:	9742                	add	a4,a4,a6
 466:	00074703          	lbu	a4,0(a4)
 46a:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 46e:	872e                	mv	a4,a1
 470:	02c5d5b3          	divu	a1,a1,a2
 474:	0685                	addi	a3,a3,1
 476:	fec771e3          	bgeu	a4,a2,458 <printint+0x28>
  if (neg)
 47a:	000e0c63          	beqz	t3,492 <printint+0x62>
    buf[i++] = '-';
 47e:	fd050793          	addi	a5,a0,-48
 482:	00878533          	add	a0,a5,s0
 486:	02d00793          	li	a5,45
 48a:	fef50423          	sb	a5,-24(a0)
 48e:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 492:	fff7899b          	addiw	s3,a5,-1
 496:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 49a:	fff4c583          	lbu	a1,-1(s1)
 49e:	854a                	mv	a0,s2
 4a0:	f73ff0ef          	jal	412 <putc>
  while (--i >= 0)
 4a4:	39fd                	addiw	s3,s3,-1
 4a6:	14fd                	addi	s1,s1,-1
 4a8:	fe09d9e3          	bgez	s3,49a <printint+0x6a>
}
 4ac:	60a6                	ld	ra,72(sp)
 4ae:	6406                	ld	s0,64(sp)
 4b0:	74e2                	ld	s1,56(sp)
 4b2:	7942                	ld	s2,48(sp)
 4b4:	79a2                	ld	s3,40(sp)
 4b6:	6161                	addi	sp,sp,80
 4b8:	8082                	ret
    x = -xx;
 4ba:	40b005b3          	neg	a1,a1
    neg = 1;
 4be:	4e05                	li	t3,1
    x = -xx;
 4c0:	b761                	j	448 <printint+0x18>

00000000000004c2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c2:	711d                	addi	sp,sp,-96
 4c4:	ec86                	sd	ra,88(sp)
 4c6:	e8a2                	sd	s0,80(sp)
 4c8:	e4a6                	sd	s1,72(sp)
 4ca:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4cc:	0005c483          	lbu	s1,0(a1)
 4d0:	28048463          	beqz	s1,758 <vprintf+0x296>
 4d4:	e0ca                	sd	s2,64(sp)
 4d6:	fc4e                	sd	s3,56(sp)
 4d8:	f852                	sd	s4,48(sp)
 4da:	f456                	sd	s5,40(sp)
 4dc:	f05a                	sd	s6,32(sp)
 4de:	ec5e                	sd	s7,24(sp)
 4e0:	e862                	sd	s8,16(sp)
 4e2:	e466                	sd	s9,8(sp)
 4e4:	8b2a                	mv	s6,a0
 4e6:	8a2e                	mv	s4,a1
 4e8:	8bb2                	mv	s7,a2
  state = 0;
 4ea:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4ec:	4901                	li	s2,0
 4ee:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4f4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4f8:	06c00c93          	li	s9,108
 4fc:	a00d                	j	51e <vprintf+0x5c>
        putc(fd, c0);
 4fe:	85a6                	mv	a1,s1
 500:	855a                	mv	a0,s6
 502:	f11ff0ef          	jal	412 <putc>
 506:	a019                	j	50c <vprintf+0x4a>
    } else if (state == '%') {
 508:	03598363          	beq	s3,s5,52e <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 50c:	0019079b          	addiw	a5,s2,1
 510:	893e                	mv	s2,a5
 512:	873e                	mv	a4,a5
 514:	97d2                	add	a5,a5,s4
 516:	0007c483          	lbu	s1,0(a5)
 51a:	22048763          	beqz	s1,748 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 51e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 522:	fe0993e3          	bnez	s3,508 <vprintf+0x46>
      if (c0 == '%') {
 526:	fd579ce3          	bne	a5,s5,4fe <vprintf+0x3c>
        state = '%';
 52a:	89be                	mv	s3,a5
 52c:	b7c5                	j	50c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 52e:	00ea06b3          	add	a3,s4,a4
 532:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 536:	8636                	mv	a2,a3
      if (c1)
 538:	c681                	beqz	a3,540 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 53a:	9752                	add	a4,a4,s4
 53c:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 540:	05878263          	beq	a5,s8,584 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 544:	05978c63          	beq	a5,s9,59c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 548:	07500713          	li	a4,117
 54c:	0ee78663          	beq	a5,a4,638 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 550:	07800713          	li	a4,120
 554:	12e78863          	beq	a5,a4,684 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 558:	07000713          	li	a4,112
 55c:	14e78d63          	beq	a5,a4,6b6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 560:	06300713          	li	a4,99
 564:	18e78c63          	beq	a5,a4,6fc <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 568:	07300713          	li	a4,115
 56c:	1ae78263          	beq	a5,a4,710 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 570:	02500713          	li	a4,37
 574:	04e79463          	bne	a5,a4,5bc <vprintf+0xfa>
        putc(fd, '%');
 578:	85ba                	mv	a1,a4
 57a:	855a                	mv	a0,s6
 57c:	e97ff0ef          	jal	412 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 580:	4981                	li	s3,0
 582:	b769                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 584:	008b8493          	addi	s1,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e9fff0ef          	jal	430 <printint>
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
 59a:	bf8d                	j	50c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 59c:	06400793          	li	a5,100
 5a0:	02f68963          	beq	a3,a5,5d2 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5a4:	06c00793          	li	a5,108
 5a8:	04f68263          	beq	a3,a5,5ec <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5ac:	07500793          	li	a5,117
 5b0:	0af68063          	beq	a3,a5,650 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5b4:	07800793          	li	a5,120
 5b8:	0ef68263          	beq	a3,a5,69c <vprintf+0x1da>
        putc(fd, '%');
 5bc:	02500593          	li	a1,37
 5c0:	855a                	mv	a0,s6
 5c2:	e51ff0ef          	jal	412 <putc>
        putc(fd, c0);
 5c6:	85a6                	mv	a1,s1
 5c8:	855a                	mv	a0,s6
 5ca:	e49ff0ef          	jal	412 <putc>
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bf35                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	e51ff0ef          	jal	430 <printint>
        i += 1;
 5e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
        i += 1;
 5ea:	b70d                	j	50c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ec:	06400793          	li	a5,100
 5f0:	02f60763          	beq	a2,a5,61e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5f4:	07500793          	li	a5,117
 5f8:	06f60963          	beq	a2,a5,66a <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5fc:	07800793          	li	a5,120
 600:	faf61ee3          	bne	a2,a5,5bc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	008b8493          	addi	s1,s7,8
 608:	4681                	li	a3,0
 60a:	4641                	li	a2,16
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	e1fff0ef          	jal	430 <printint>
        i += 2;
 616:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
        i += 2;
 61c:	bdc5                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	008b8493          	addi	s1,s7,8
 622:	4685                	li	a3,1
 624:	4629                	li	a2,10
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e05ff0ef          	jal	430 <printint>
        i += 2;
 630:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	bdd9                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000be583          	lwu	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	debff0ef          	jal	430 <printint>
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd7d                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	008b8493          	addi	s1,s7,8
 654:	4681                	li	a3,0
 656:	4629                	li	a2,10
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	dd3ff0ef          	jal	430 <printint>
        i += 1;
 662:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	b555                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	db9ff0ef          	jal	430 <printint>
        i += 2;
 67c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
        i += 2;
 682:	b569                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000be583          	lwu	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	d9fff0ef          	jal	430 <printint>
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
 69a:	bd8d                	j	50c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4641                	li	a2,16
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	d87ff0ef          	jal	430 <printint>
        i += 1;
 6ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b0:	8ba6                	mv	s7,s1
      state = 0;
 6b2:	4981                	li	s3,0
        i += 1;
 6b4:	bda1                	j	50c <vprintf+0x4a>
 6b6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6b8:	008b8d13          	addi	s10,s7,8
 6bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c0:	03000593          	li	a1,48
 6c4:	855a                	mv	a0,s6
 6c6:	d4dff0ef          	jal	412 <putc>
  putc(fd, 'x');
 6ca:	07800593          	li	a1,120
 6ce:	855a                	mv	a0,s6
 6d0:	d43ff0ef          	jal	412 <putc>
 6d4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d6:	00000b97          	auipc	s7,0x0
 6da:	272b8b93          	addi	s7,s7,626 # 948 <digits>
 6de:	03c9d793          	srli	a5,s3,0x3c
 6e2:	97de                	add	a5,a5,s7
 6e4:	0007c583          	lbu	a1,0(a5)
 6e8:	855a                	mv	a0,s6
 6ea:	d29ff0ef          	jal	412 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ee:	0992                	slli	s3,s3,0x4
 6f0:	34fd                	addiw	s1,s1,-1
 6f2:	f4f5                	bnez	s1,6de <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6f4:	8bea                	mv	s7,s10
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	6d02                	ld	s10,0(sp)
 6fa:	bd09                	j	50c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6fc:	008b8493          	addi	s1,s7,8
 700:	000bc583          	lbu	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	d0dff0ef          	jal	412 <putc>
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bbfd                	j	50c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 710:	008b8993          	addi	s3,s7,8
 714:	000bb483          	ld	s1,0(s7)
 718:	cc91                	beqz	s1,734 <vprintf+0x272>
        for (; *s; s++)
 71a:	0004c583          	lbu	a1,0(s1)
 71e:	c195                	beqz	a1,742 <vprintf+0x280>
          putc(fd, *s);
 720:	855a                	mv	a0,s6
 722:	cf1ff0ef          	jal	412 <putc>
        for (; *s; s++)
 726:	0485                	addi	s1,s1,1
 728:	0004c583          	lbu	a1,0(s1)
 72c:	f9f5                	bnez	a1,720 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	bbe9                	j	50c <vprintf+0x4a>
          s = "(null)";
 734:	00000497          	auipc	s1,0x0
 738:	20c48493          	addi	s1,s1,524 # 940 <malloc+0xfc>
        for (; *s; s++)
 73c:	02800593          	li	a1,40
 740:	b7c5                	j	720 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 742:	8bce                	mv	s7,s3
      state = 0;
 744:	4981                	li	s3,0
 746:	b3d9                	j	50c <vprintf+0x4a>
 748:	6906                	ld	s2,64(sp)
 74a:	79e2                	ld	s3,56(sp)
 74c:	7a42                	ld	s4,48(sp)
 74e:	7aa2                	ld	s5,40(sp)
 750:	7b02                	ld	s6,32(sp)
 752:	6be2                	ld	s7,24(sp)
 754:	6c42                	ld	s8,16(sp)
 756:	6ca2                	ld	s9,8(sp)
    }
  }
}
 758:	60e6                	ld	ra,88(sp)
 75a:	6446                	ld	s0,80(sp)
 75c:	64a6                	ld	s1,72(sp)
 75e:	6125                	addi	sp,sp,96
 760:	8082                	ret

0000000000000762 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 762:	715d                	addi	sp,sp,-80
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e010                	sd	a2,0(s0)
 76c:	e414                	sd	a3,8(s0)
 76e:	e818                	sd	a4,16(s0)
 770:	ec1c                	sd	a5,24(s0)
 772:	03043023          	sd	a6,32(s0)
 776:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	8622                	mv	a2,s0
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	d43ff0ef          	jal	4c2 <vprintf>
}
 784:	60e2                	ld	ra,24(sp)
 786:	6442                	ld	s0,16(sp)
 788:	6161                	addi	sp,sp,80
 78a:	8082                	ret

000000000000078c <printf>:

void
printf(const char *fmt, ...)
{
 78c:	711d                	addi	sp,sp,-96
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e40c                	sd	a1,8(s0)
 796:	e810                	sd	a2,16(s0)
 798:	ec14                	sd	a3,24(s0)
 79a:	f018                	sd	a4,32(s0)
 79c:	f41c                	sd	a5,40(s0)
 79e:	03043823          	sd	a6,48(s0)
 7a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	00840613          	addi	a2,s0,8
 7aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ae:	85aa                	mv	a1,a0
 7b0:	4505                	li	a0,1
 7b2:	d11ff0ef          	jal	4c2 <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6125                	addi	sp,sp,96
 7bc:	8082                	ret

00000000000007be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7be:	1141                	addi	sp,sp,-16
 7c0:	e406                	sd	ra,8(sp)
 7c2:	e022                	sd	s0,0(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a02d                	j	7fc <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7d4:	4618                	lw	a4,8(a2)
 7d6:	9f2d                	addw	a4,a4,a1
 7d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	6310                	ld	a2,0(a4)
 7e0:	a83d                	j	81e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7e2:	ff852703          	lw	a4,-8(a0)
 7e6:	9f31                	addw	a4,a4,a2
 7e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ea:	ff053683          	ld	a3,-16(a0)
 7ee:	a091                	j	832 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	6398                	ld	a4,0(a5)
 7f2:	00e7e463          	bltu	a5,a4,7fa <free+0x3c>
 7f6:	00e6ea63          	bltu	a3,a4,80a <free+0x4c>
{
 7fa:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	fed7fae3          	bgeu	a5,a3,7f0 <free+0x32>
 800:	6398                	ld	a4,0(a5)
 802:	00e6e463          	bltu	a3,a4,80a <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 806:	fee7eae3          	bltu	a5,a4,7fa <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 80a:	ff852583          	lw	a1,-8(a0)
 80e:	6390                	ld	a2,0(a5)
 810:	02059813          	slli	a6,a1,0x20
 814:	01c85713          	srli	a4,a6,0x1c
 818:	9736                	add	a4,a4,a3
 81a:	fae60de3          	beq	a2,a4,7d4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 81e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 822:	4790                	lw	a2,8(a5)
 824:	02061593          	slli	a1,a2,0x20
 828:	01c5d713          	srli	a4,a1,0x1c
 82c:	973e                	add	a4,a4,a5
 82e:	fae68ae3          	beq	a3,a4,7e2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 832:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
}
 83c:	60a2                	ld	ra,8(sp)
 83e:	6402                	ld	s0,0(sp)
 840:	0141                	addi	sp,sp,16
 842:	8082                	ret

0000000000000844 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f04a                	sd	s2,32(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 850:	02051993          	slli	s3,a0,0x20
 854:	0209d993          	srli	s3,s3,0x20
 858:	09bd                	addi	s3,s3,15
 85a:	0049d993          	srli	s3,s3,0x4
 85e:	2985                	addiw	s3,s3,1
 860:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 862:	00000517          	auipc	a0,0x0
 866:	79e53503          	ld	a0,1950(a0) # 1000 <freep>
 86a:	c905                	beqz	a0,89a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 86c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 86e:	4798                	lw	a4,8(a5)
 870:	09377663          	bgeu	a4,s3,8fc <malloc+0xb8>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	6705                	lui	a4,0x1
 880:	00e9f363          	bgeu	s3,a4,886 <malloc+0x42>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 88e:	00000497          	auipc	s1,0x0
 892:	77248493          	addi	s1,s1,1906 # 1000 <freep>
  if (p == SBRK_ERROR)
 896:	5afd                	li	s5,-1
 898:	a83d                	j	8d6 <malloc+0x92>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8b8:	b7d1                	j	87c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a899                	j	914 <malloc+0xd0>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	ef9ff0ef          	jal	7be <free>
  return freep;
 8ca:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8cc:	c125                	beqz	a0,92c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ce:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8d0:	4798                	lw	a4,8(a5)
 8d2:	03277163          	bgeu	a4,s2,8f4 <malloc+0xb0>
    if (p == freep)
 8d6:	6098                	ld	a4,0(s1)
 8d8:	853e                	mv	a0,a5
 8da:	fef71ae3          	bne	a4,a5,8ce <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	9d3ff0ef          	jal	2b2 <sbrk>
  if (p == SBRK_ERROR)
 8e4:	fd551ee3          	bne	a0,s5,8c0 <malloc+0x7c>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	a03d                	j	920 <malloc+0xdc>
 8f4:	74a2                	ld	s1,40(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8fc:	fae90fe3          	beq	s2,a4,8ba <malloc+0x76>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	slli	a3,a4,0x20
 90a:	01c6d713          	srli	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void *)(p + 1);
 91c:	01078513          	addi	a0,a5,16
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	7902                	ld	s2,32(sp)
 926:	69e2                	ld	s3,24(sp)
 928:	6121                	addi	sp,sp,64
 92a:	8082                	ret
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	b7f5                	j	920 <malloc+0xdc>
