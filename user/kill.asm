
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
  28:	1c6000ef          	jal	1ee <atoi>
  2c:	320000ef          	jal	34c <kill>
  for (i = 1; i < argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	2e4000ef          	jal	31c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8d058593          	addi	a1,a1,-1840 # 910 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	6ea000ef          	jal	734 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2cc000ef          	jal	31c <exit>

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
  60:	2bc000ef          	jal	31c <exit>

0000000000000064 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  64:	1141                	addi	sp,sp,-16
  66:	e406                	sd	ra,8(sp)
  68:	e022                	sd	s0,0(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0xa>
    ;
  return os;
}
  7c:	60a2                	ld	ra,8(sp)
  7e:	6402                	ld	s0,0(sp)
  80:	0141                	addi	sp,sp,16
  82:	8082                	ret

0000000000000084 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  8c:	00054783          	lbu	a5,0(a0)
  90:	cb91                	beqz	a5,a4 <strcmp+0x20>
  92:	0005c703          	lbu	a4,0(a1)
  96:	00f71763          	bne	a4,a5,a4 <strcmp+0x20>
    p++, q++;
  9a:	0505                	addi	a0,a0,1
  9c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	fbe5                	bnez	a5,92 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  a4:	0005c503          	lbu	a0,0(a1)
}
  a8:	40a7853b          	subw	a0,a5,a0
  ac:	60a2                	ld	ra,8(sp)
  ae:	6402                	ld	s0,0(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e406                	sd	ra,8(sp)
  b8:	e022                	sd	s0,0(sp)
  ba:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	cf99                	beqz	a5,de <strlen+0x2a>
  c2:	0505                	addi	a0,a0,1
  c4:	87aa                	mv	a5,a0
  c6:	86be                	mv	a3,a5
  c8:	0785                	addi	a5,a5,1
  ca:	fff7c703          	lbu	a4,-1(a5)
  ce:	ff65                	bnez	a4,c6 <strlen+0x12>
  d0:	40a6853b          	subw	a0,a3,a0
  d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for (n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfdd                	j	d6 <strlen+0x22>

00000000000000e2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  ea:	ca19                	beqz	a2,100 <memset+0x1e>
  ec:	87aa                	mv	a5,a0
  ee:	1602                	slli	a2,a2,0x20
  f0:	9201                	srli	a2,a2,0x20
  f2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  fa:	0785                	addi	a5,a5,1
  fc:	fee79de3          	bne	a5,a4,f6 <memset+0x14>
  }
  return dst;
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret

0000000000000108 <strchr>:

char *
strchr(const char *s, char c)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 110:	00054783          	lbu	a5,0(a0)
 114:	cf81                	beqz	a5,12c <strchr+0x24>
    if (*s == c)
 116:	00f58763          	beq	a1,a5,124 <strchr+0x1c>
  for (; *s; s++)
 11a:	0505                	addi	a0,a0,1
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbfd                	bnez	a5,116 <strchr+0xe>
      return (char *)s;
  return 0;
 122:	4501                	li	a0,0
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfdd                	j	124 <strchr+0x1c>

0000000000000130 <gets>:

char *
gets(char *buf, int max)
{
 130:	7159                	addi	sp,sp,-112
 132:	f486                	sd	ra,104(sp)
 134:	f0a2                	sd	s0,96(sp)
 136:	eca6                	sd	s1,88(sp)
 138:	e8ca                	sd	s2,80(sp)
 13a:	e4ce                	sd	s3,72(sp)
 13c:	e0d2                	sd	s4,64(sp)
 13e:	fc56                	sd	s5,56(sp)
 140:	f85a                	sd	s6,48(sp)
 142:	f45e                	sd	s7,40(sp)
 144:	f062                	sd	s8,32(sp)
 146:	ec66                	sd	s9,24(sp)
 148:	e86a                	sd	s10,16(sp)
 14a:	1880                	addi	s0,sp,112
 14c:	8caa                	mv	s9,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
 154:	f9f40b13          	addi	s6,s0,-97
 158:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 15a:	4ba9                	li	s7,10
 15c:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 15e:	8d26                	mv	s10,s1
 160:	0014899b          	addiw	s3,s1,1
 164:	84ce                	mv	s1,s3
 166:	0349d563          	bge	s3,s4,190 <gets+0x60>
    cc = read(0, &c, 1);
 16a:	8656                	mv	a2,s5
 16c:	85da                	mv	a1,s6
 16e:	4501                	li	a0,0
 170:	1c4000ef          	jal	334 <read>
    if (cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x60>
    buf[i++] = c;
 178:	f9f44783          	lbu	a5,-97(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 180:	01778763          	beq	a5,s7,18e <gets+0x5e>
 184:	0905                	addi	s2,s2,1
 186:	fd879ce3          	bne	a5,s8,15e <gets+0x2e>
    buf[i++] = c;
 18a:	8d4e                	mv	s10,s3
 18c:	a011                	j	190 <gets+0x60>
 18e:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 190:	9d66                	add	s10,s10,s9
 192:	000d0023          	sb	zero,0(s10)
  return buf;
}
 196:	8566                	mv	a0,s9
 198:	70a6                	ld	ra,104(sp)
 19a:	7406                	ld	s0,96(sp)
 19c:	64e6                	ld	s1,88(sp)
 19e:	6946                	ld	s2,80(sp)
 1a0:	69a6                	ld	s3,72(sp)
 1a2:	6a06                	ld	s4,64(sp)
 1a4:	7ae2                	ld	s5,56(sp)
 1a6:	7b42                	ld	s6,48(sp)
 1a8:	7ba2                	ld	s7,40(sp)
 1aa:	7c02                	ld	s8,32(sp)
 1ac:	6ce2                	ld	s9,24(sp)
 1ae:	6d42                	ld	s10,16(sp)
 1b0:	6165                	addi	sp,sp,112
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e04a                	sd	s2,0(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c0:	4581                	li	a1,0
 1c2:	19a000ef          	jal	35c <open>
  if (fd < 0)
 1c6:	02054263          	bltz	a0,1ea <stat+0x36>
 1ca:	e426                	sd	s1,8(sp)
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	1a4000ef          	jal	374 <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	16c000ef          	jal	344 <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x2a>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66963          	bltu	a2,a5,236 <atoi+0x48>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1e>
  return n;
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  n = 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <atoi+0x40>

000000000000023a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57563          	bgeu	a0,a1,26c <memmove+0x32>
    while (n-- > 0)
 246:	00c05f63          	blez	a2,264 <memmove+0x2a>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
      *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 260:	fee79ae3          	bne	a5,a4,254 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 264:	60a2                	ld	ra,8(sp)
 266:	6402                	ld	s0,0(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
    dst += n;
 26c:	00c50733          	add	a4,a0,a2
    src += n;
 270:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 272:	fec059e3          	blez	a2,264 <memmove+0x2a>
 276:	fff6079b          	addiw	a5,a2,-1
 27a:	1782                	slli	a5,a5,0x20
 27c:	9381                	srli	a5,a5,0x20
 27e:	fff7c793          	not	a5,a5
 282:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 284:	15fd                	addi	a1,a1,-1
 286:	177d                	addi	a4,a4,-1
 288:	0005c683          	lbu	a3,0(a1)
 28c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 290:	fef71ae3          	bne	a4,a5,284 <memmove+0x4a>
 294:	bfc1                	j	264 <memmove+0x2a>

0000000000000296 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	ca0d                	beqz	a2,2d0 <memcmp+0x3a>
 2a0:	fff6069b          	addiw	a3,a2,-1
 2a4:	1682                	slli	a3,a3,0x20
 2a6:	9281                	srli	a3,a3,0x20
 2a8:	0685                	addi	a3,a3,1
 2aa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	0005c703          	lbu	a4,0(a1)
 2b4:	00e79863          	bne	a5,a4,2c4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b8:	0505                	addi	a0,a0,1
    p2++;
 2ba:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2bc:	fed518e3          	bne	a0,a3,2ac <memcmp+0x16>
  }
  return 0;
 2c0:	4501                	li	a0,0
 2c2:	a019                	j	2c8 <memcmp+0x32>
      return *p1 - *p2;
 2c4:	40e7853b          	subw	a0,a5,a4
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  return 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <memcmp+0x32>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f5fff0ef          	jal	23a <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	0b2000ef          	jal	3a4 <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	09c000ef          	jal	3a4 <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sync>:
.global sync
sync:
 li a7, SYS_sync
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3c4:	48dd                	li	a7,23
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3cc:	48e1                	li	a7,24
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3d4:	48e5                	li	a7,25
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3dc:	48e9                	li	a7,26
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	f47ff0ef          	jal	33c <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 402:	715d                	addi	sp,sp,-80
 404:	e486                	sd	ra,72(sp)
 406:	e0a2                	sd	s0,64(sp)
 408:	fc26                	sd	s1,56(sp)
 40a:	f84a                	sd	s2,48(sp)
 40c:	f44e                	sd	s3,40(sp)
 40e:	0880                	addi	s0,sp,80
 410:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 412:	c299                	beqz	a3,418 <printint+0x16>
 414:	0605cc63          	bltz	a1,48c <printint+0x8a>
  neg = 0;
 418:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 41a:	fb840313          	addi	t1,s0,-72
  neg = 0;
 41e:	869a                	mv	a3,t1
  i = 0;
 420:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 422:	00000817          	auipc	a6,0x0
 426:	50e80813          	addi	a6,a6,1294 # 930 <digits>
 42a:	88be                	mv	a7,a5
 42c:	0017851b          	addiw	a0,a5,1
 430:	87aa                	mv	a5,a0
 432:	02c5f733          	remu	a4,a1,a2
 436:	9742                	add	a4,a4,a6
 438:	00074703          	lbu	a4,0(a4)
 43c:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 440:	872e                	mv	a4,a1
 442:	02c5d5b3          	divu	a1,a1,a2
 446:	0685                	addi	a3,a3,1
 448:	fec771e3          	bgeu	a4,a2,42a <printint+0x28>
  if (neg)
 44c:	000e0c63          	beqz	t3,464 <printint+0x62>
    buf[i++] = '-';
 450:	fd050793          	addi	a5,a0,-48
 454:	00878533          	add	a0,a5,s0
 458:	02d00793          	li	a5,45
 45c:	fef50423          	sb	a5,-24(a0)
 460:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 464:	fff7899b          	addiw	s3,a5,-1
 468:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 46c:	fff4c583          	lbu	a1,-1(s1)
 470:	854a                	mv	a0,s2
 472:	f73ff0ef          	jal	3e4 <putc>
  while (--i >= 0)
 476:	39fd                	addiw	s3,s3,-1
 478:	14fd                	addi	s1,s1,-1
 47a:	fe09d9e3          	bgez	s3,46c <printint+0x6a>
}
 47e:	60a6                	ld	ra,72(sp)
 480:	6406                	ld	s0,64(sp)
 482:	74e2                	ld	s1,56(sp)
 484:	7942                	ld	s2,48(sp)
 486:	79a2                	ld	s3,40(sp)
 488:	6161                	addi	sp,sp,80
 48a:	8082                	ret
    x = -xx;
 48c:	40b005b3          	neg	a1,a1
    neg = 1;
 490:	4e05                	li	t3,1
    x = -xx;
 492:	b761                	j	41a <printint+0x18>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 49e:	0005c483          	lbu	s1,0(a1)
 4a2:	28048463          	beqz	s1,72a <vprintf+0x296>
 4a6:	e0ca                	sd	s2,64(sp)
 4a8:	fc4e                	sd	s3,56(sp)
 4aa:	f852                	sd	s4,48(sp)
 4ac:	f456                	sd	s5,40(sp)
 4ae:	f05a                	sd	s6,32(sp)
 4b0:	ec5e                	sd	s7,24(sp)
 4b2:	e862                	sd	s8,16(sp)
 4b4:	e466                	sd	s9,8(sp)
 4b6:	8b2a                	mv	s6,a0
 4b8:	8a2e                	mv	s4,a1
 4ba:	8bb2                	mv	s7,a2
  state = 0;
 4bc:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4be:	4901                	li	s2,0
 4c0:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4ca:	06c00c93          	li	s9,108
 4ce:	a00d                	j	4f0 <vprintf+0x5c>
        putc(fd, c0);
 4d0:	85a6                	mv	a1,s1
 4d2:	855a                	mv	a0,s6
 4d4:	f11ff0ef          	jal	3e4 <putc>
 4d8:	a019                	j	4de <vprintf+0x4a>
    } else if (state == '%') {
 4da:	03598363          	beq	s3,s5,500 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 4de:	0019079b          	addiw	a5,s2,1
 4e2:	893e                	mv	s2,a5
 4e4:	873e                	mv	a4,a5
 4e6:	97d2                	add	a5,a5,s4
 4e8:	0007c483          	lbu	s1,0(a5)
 4ec:	22048763          	beqz	s1,71a <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 4f0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4f4:	fe0993e3          	bnez	s3,4da <vprintf+0x46>
      if (c0 == '%') {
 4f8:	fd579ce3          	bne	a5,s5,4d0 <vprintf+0x3c>
        state = '%';
 4fc:	89be                	mv	s3,a5
 4fe:	b7c5                	j	4de <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 500:	00ea06b3          	add	a3,s4,a4
 504:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 508:	8636                	mv	a2,a3
      if (c1)
 50a:	c681                	beqz	a3,512 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 50c:	9752                	add	a4,a4,s4
 50e:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 512:	05878263          	beq	a5,s8,556 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 516:	05978c63          	beq	a5,s9,56e <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 51a:	07500713          	li	a4,117
 51e:	0ee78663          	beq	a5,a4,60a <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 522:	07800713          	li	a4,120
 526:	12e78863          	beq	a5,a4,656 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 52a:	07000713          	li	a4,112
 52e:	14e78d63          	beq	a5,a4,688 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 532:	06300713          	li	a4,99
 536:	18e78c63          	beq	a5,a4,6ce <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 53a:	07300713          	li	a4,115
 53e:	1ae78263          	beq	a5,a4,6e2 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 542:	02500713          	li	a4,37
 546:	04e79463          	bne	a5,a4,58e <vprintf+0xfa>
        putc(fd, '%');
 54a:	85ba                	mv	a1,a4
 54c:	855a                	mv	a0,s6
 54e:	e97ff0ef          	jal	3e4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 552:	4981                	li	s3,0
 554:	b769                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e9fff0ef          	jal	402 <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf8d                	j	4de <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 56e:	06400793          	li	a5,100
 572:	02f68963          	beq	a3,a5,5a4 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 576:	06c00793          	li	a5,108
 57a:	04f68263          	beq	a3,a5,5be <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 57e:	07500793          	li	a5,117
 582:	0af68063          	beq	a3,a5,622 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 586:	07800793          	li	a5,120
 58a:	0ef68263          	beq	a3,a5,66e <vprintf+0x1da>
        putc(fd, '%');
 58e:	02500593          	li	a1,37
 592:	855a                	mv	a0,s6
 594:	e51ff0ef          	jal	3e4 <putc>
        putc(fd, c0);
 598:	85a6                	mv	a1,s1
 59a:	855a                	mv	a0,s6
 59c:	e49ff0ef          	jal	3e4 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bf35                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e51ff0ef          	jal	402 <printint>
        i += 1;
 5b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
        i += 1;
 5bc:	b70d                	j	4de <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5be:	06400793          	li	a5,100
 5c2:	02f60763          	beq	a2,a5,5f0 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5c6:	07500793          	li	a5,117
 5ca:	06f60963          	beq	a2,a5,63c <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5ce:	07800793          	li	a5,120
 5d2:	faf61ee3          	bne	a2,a5,58e <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e1fff0ef          	jal	402 <printint>
        i += 2;
 5e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	bdc5                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e05ff0ef          	jal	402 <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bdd9                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	debff0ef          	jal	402 <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bd7d                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	dd3ff0ef          	jal	402 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b555                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	db9ff0ef          	jal	402 <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	b569                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	d9fff0ef          	jal	402 <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd8d                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	d87ff0ef          	jal	402 <printint>
        i += 1;
 680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	bda1                	j	4de <vprintf+0x4a>
 688:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 68a:	008b8d13          	addi	s10,s7,8
 68e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 692:	03000593          	li	a1,48
 696:	855a                	mv	a0,s6
 698:	d4dff0ef          	jal	3e4 <putc>
  putc(fd, 'x');
 69c:	07800593          	li	a1,120
 6a0:	855a                	mv	a0,s6
 6a2:	d43ff0ef          	jal	3e4 <putc>
 6a6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	00000b97          	auipc	s7,0x0
 6ac:	288b8b93          	addi	s7,s7,648 # 930 <digits>
 6b0:	03c9d793          	srli	a5,s3,0x3c
 6b4:	97de                	add	a5,a5,s7
 6b6:	0007c583          	lbu	a1,0(a5)
 6ba:	855a                	mv	a0,s6
 6bc:	d29ff0ef          	jal	3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c0:	0992                	slli	s3,s3,0x4
 6c2:	34fd                	addiw	s1,s1,-1
 6c4:	f4f5                	bnez	s1,6b0 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6c6:	8bea                	mv	s7,s10
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	6d02                	ld	s10,0(sp)
 6cc:	bd09                	j	4de <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6ce:	008b8493          	addi	s1,s7,8
 6d2:	000bc583          	lbu	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d0dff0ef          	jal	3e4 <putc>
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
 6e0:	bbfd                	j	4de <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6e2:	008b8993          	addi	s3,s7,8
 6e6:	000bb483          	ld	s1,0(s7)
 6ea:	cc91                	beqz	s1,706 <vprintf+0x272>
        for (; *s; s++)
 6ec:	0004c583          	lbu	a1,0(s1)
 6f0:	c195                	beqz	a1,714 <vprintf+0x280>
          putc(fd, *s);
 6f2:	855a                	mv	a0,s6
 6f4:	cf1ff0ef          	jal	3e4 <putc>
        for (; *s; s++)
 6f8:	0485                	addi	s1,s1,1
 6fa:	0004c583          	lbu	a1,0(s1)
 6fe:	f9f5                	bnez	a1,6f2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	bbe9                	j	4de <vprintf+0x4a>
          s = "(null)";
 706:	00000497          	auipc	s1,0x0
 70a:	22248493          	addi	s1,s1,546 # 928 <malloc+0x112>
        for (; *s; s++)
 70e:	02800593          	li	a1,40
 712:	b7c5                	j	6f2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 714:	8bce                	mv	s7,s3
      state = 0;
 716:	4981                	li	s3,0
 718:	b3d9                	j	4de <vprintf+0x4a>
 71a:	6906                	ld	s2,64(sp)
 71c:	79e2                	ld	s3,56(sp)
 71e:	7a42                	ld	s4,48(sp)
 720:	7aa2                	ld	s5,40(sp)
 722:	7b02                	ld	s6,32(sp)
 724:	6be2                	ld	s7,24(sp)
 726:	6c42                	ld	s8,16(sp)
 728:	6ca2                	ld	s9,8(sp)
    }
  }
}
 72a:	60e6                	ld	ra,88(sp)
 72c:	6446                	ld	s0,80(sp)
 72e:	64a6                	ld	s1,72(sp)
 730:	6125                	addi	sp,sp,96
 732:	8082                	ret

0000000000000734 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 734:	715d                	addi	sp,sp,-80
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	e010                	sd	a2,0(s0)
 73e:	e414                	sd	a3,8(s0)
 740:	e818                	sd	a4,16(s0)
 742:	ec1c                	sd	a5,24(s0)
 744:	03043023          	sd	a6,32(s0)
 748:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	8622                	mv	a2,s0
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	d43ff0ef          	jal	494 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	addi	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	addi	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	addi	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	d11ff0ef          	jal	494 <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6125                	addi	sp,sp,96
 78e:	8082                	ret

0000000000000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	1141                	addi	sp,sp,-16
 792:	e406                	sd	ra,8(sp)
 794:	e022                	sd	s0,0(sp)
 796:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 798:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	00001797          	auipc	a5,0x1
 7a0:	8647b783          	ld	a5,-1948(a5) # 1000 <freep>
 7a4:	a02d                	j	7ce <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7a6:	4618                	lw	a4,8(a2)
 7a8:	9f2d                	addw	a4,a4,a1
 7aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ae:	6398                	ld	a4,0(a5)
 7b0:	6310                	ld	a2,0(a4)
 7b2:	a83d                	j	7f0 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7b4:	ff852703          	lw	a4,-8(a0)
 7b8:	9f31                	addw	a4,a4,a2
 7ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7bc:	ff053683          	ld	a3,-16(a0)
 7c0:	a091                	j	804 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e7e463          	bltu	a5,a4,7cc <free+0x3c>
 7c8:	00e6ea63          	bltu	a3,a4,7dc <free+0x4c>
{
 7cc:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	fed7fae3          	bgeu	a5,a3,7c2 <free+0x32>
 7d2:	6398                	ld	a4,0(a5)
 7d4:	00e6e463          	bltu	a3,a4,7dc <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d8:	fee7eae3          	bltu	a5,a4,7cc <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7dc:	ff852583          	lw	a1,-8(a0)
 7e0:	6390                	ld	a2,0(a5)
 7e2:	02059813          	slli	a6,a1,0x20
 7e6:	01c85713          	srli	a4,a6,0x1c
 7ea:	9736                	add	a4,a4,a3
 7ec:	fae60de3          	beq	a2,a4,7a6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 7f4:	4790                	lw	a2,8(a5)
 7f6:	02061593          	slli	a1,a2,0x20
 7fa:	01c5d713          	srli	a4,a1,0x1c
 7fe:	973e                	add	a4,a4,a5
 800:	fae68ae3          	beq	a3,a4,7b4 <free+0x24>
    p->s.ptr = bp->s.ptr;
 804:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 806:	00000717          	auipc	a4,0x0
 80a:	7ef73d23          	sd	a5,2042(a4) # 1000 <freep>
}
 80e:	60a2                	ld	ra,8(sp)
 810:	6402                	ld	s0,0(sp)
 812:	0141                	addi	sp,sp,16
 814:	8082                	ret

0000000000000816 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 816:	7139                	addi	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f04a                	sd	s2,32(sp)
 81e:	ec4e                	sd	s3,24(sp)
 820:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 822:	02051993          	slli	s3,a0,0x20
 826:	0209d993          	srli	s3,s3,0x20
 82a:	09bd                	addi	s3,s3,15
 82c:	0049d993          	srli	s3,s3,0x4
 830:	2985                	addiw	s3,s3,1
 832:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 834:	00000517          	auipc	a0,0x0
 838:	7cc53503          	ld	a0,1996(a0) # 1000 <freep>
 83c:	c905                	beqz	a0,86c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 83e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 840:	4798                	lw	a4,8(a5)
 842:	09377663          	bgeu	a4,s3,8ce <malloc+0xb8>
 846:	f426                	sd	s1,40(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 84e:	8a4e                	mv	s4,s3
 850:	6705                	lui	a4,0x1
 852:	00e9f363          	bgeu	s3,a4,858 <malloc+0x42>
 856:	6a05                	lui	s4,0x1
 858:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 860:	00000497          	auipc	s1,0x0
 864:	7a048493          	addi	s1,s1,1952 # 1000 <freep>
  if (p == SBRK_ERROR)
 868:	5afd                	li	s5,-1
 86a:	a83d                	j	8a8 <malloc+0x92>
 86c:	f426                	sd	s1,40(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 874:	00000797          	auipc	a5,0x0
 878:	79c78793          	addi	a5,a5,1948 # 1010 <base>
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
 884:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 886:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 88a:	b7d1                	j	84e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	e118                	sd	a4,0(a0)
 890:	a899                	j	8e6 <malloc+0xd0>
  hp->s.size = nu;
 892:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 896:	0541                	addi	a0,a0,16
 898:	ef9ff0ef          	jal	790 <free>
  return freep;
 89c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 89e:	c125                	beqz	a0,8fe <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8a0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8a2:	4798                	lw	a4,8(a5)
 8a4:	03277163          	bgeu	a4,s2,8c6 <malloc+0xb0>
    if (p == freep)
 8a8:	6098                	ld	a4,0(s1)
 8aa:	853e                	mv	a0,a5
 8ac:	fef71ae3          	bne	a4,a5,8a0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	a37ff0ef          	jal	2e8 <sbrk>
  if (p == SBRK_ERROR)
 8b6:	fd551ee3          	bne	a0,s5,892 <malloc+0x7c>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	74a2                	ld	s1,40(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	a03d                	j	8f2 <malloc+0xdc>
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8ce:	fae90fe3          	beq	s2,a4,88c <malloc+0x76>
        p->s.size -= nunits;
 8d2:	4137073b          	subw	a4,a4,s3
 8d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d8:	02071693          	slli	a3,a4,0x20
 8dc:	01c6d713          	srli	a4,a3,0x1c
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70a73d23          	sd	a0,1818(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	7902                	ld	s2,32(sp)
 8f8:	69e2                	ld	s3,24(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	b7f5                	j	8f2 <malloc+0xdc>
