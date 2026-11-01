
user/_ln:     file format elf64-littleriscv


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
  if (argc != 3) {
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	96058593          	addi	a1,a1,-1696 # 970 <malloc+0xfc>
  18:	4509                	li	a0,2
  1a:	778000ef          	jal	792 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2f6000ef          	jal	316 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	34a000ef          	jal	376 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2e0000ef          	jal	316 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	94a58593          	addi	a1,a1,-1718 # 988 <malloc+0x114>
  46:	4509                	li	a0,2
  48:	74a000ef          	jal	792 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2bc000ef          	jal	316 <exit>

000000000000005e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf99                	beqz	a5,d8 <strlen+0x2a>
  bc:	0505                	addi	a0,a0,1
  be:	87aa                	mv	a5,a0
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
  ce:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret
  for (n = 0; s[n]; n++)
  d8:	4501                	li	a0,0
  da:	bfdd                	j	d0 <strlen+0x22>

00000000000000dc <memset>:

void *
memset(void *dst, int c, uint n)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e4:	ca19                	beqz	a2,fa <memset+0x1e>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x14>
  }
  return dst;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strchr>:

char *
strchr(const char *s, char c)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  for (; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cf81                	beqz	a5,126 <strchr+0x24>
    if (*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1c>
  for (; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xe>
      return (char *)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret
  return 0;
 126:	4501                	li	a0,0
 128:	bfdd                	j	11e <strchr+0x1c>

000000000000012a <gets>:

char *
gets(char *buf, int max)
{
 12a:	7159                	addi	sp,sp,-112
 12c:	f486                	sd	ra,104(sp)
 12e:	f0a2                	sd	s0,96(sp)
 130:	eca6                	sd	s1,88(sp)
 132:	e8ca                	sd	s2,80(sp)
 134:	e4ce                	sd	s3,72(sp)
 136:	e0d2                	sd	s4,64(sp)
 138:	fc56                	sd	s5,56(sp)
 13a:	f85a                	sd	s6,48(sp)
 13c:	f45e                	sd	s7,40(sp)
 13e:	f062                	sd	s8,32(sp)
 140:	ec66                	sd	s9,24(sp)
 142:	e86a                	sd	s10,16(sp)
 144:	1880                	addi	s0,sp,112
 146:	8caa                	mv	s9,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 14e:	f9f40b13          	addi	s6,s0,-97
 152:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 154:	4ba9                	li	s7,10
 156:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 158:	8d26                	mv	s10,s1
 15a:	0014899b          	addiw	s3,s1,1
 15e:	84ce                	mv	s1,s3
 160:	0349d563          	bge	s3,s4,18a <gets+0x60>
    cc = read(0, &c, 1);
 164:	8656                	mv	a2,s5
 166:	85da                	mv	a1,s6
 168:	4501                	li	a0,0
 16a:	1c4000ef          	jal	32e <read>
    if (cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x60>
    buf[i++] = c;
 172:	f9f44783          	lbu	a5,-97(s0)
 176:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 17a:	01778763          	beq	a5,s7,188 <gets+0x5e>
 17e:	0905                	addi	s2,s2,1
 180:	fd879ce3          	bne	a5,s8,158 <gets+0x2e>
    buf[i++] = c;
 184:	8d4e                	mv	s10,s3
 186:	a011                	j	18a <gets+0x60>
 188:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 18a:	9d66                	add	s10,s10,s9
 18c:	000d0023          	sb	zero,0(s10)
  return buf;
}
 190:	8566                	mv	a0,s9
 192:	70a6                	ld	ra,104(sp)
 194:	7406                	ld	s0,96(sp)
 196:	64e6                	ld	s1,88(sp)
 198:	6946                	ld	s2,80(sp)
 19a:	69a6                	ld	s3,72(sp)
 19c:	6a06                	ld	s4,64(sp)
 19e:	7ae2                	ld	s5,56(sp)
 1a0:	7b42                	ld	s6,48(sp)
 1a2:	7ba2                	ld	s7,40(sp)
 1a4:	7c02                	ld	s8,32(sp)
 1a6:	6ce2                	ld	s9,24(sp)
 1a8:	6d42                	ld	s10,16(sp)
 1aa:	6165                	addi	sp,sp,112
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	19a000ef          	jal	356 <open>
  if (fd < 0)
 1c0:	02054263          	bltz	a0,1e4 <stat+0x36>
 1c4:	e426                	sd	s1,8(sp)
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	1a4000ef          	jal	36e <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	16c000ef          	jal	33e <close>
  return r;
 1d6:	64a2                	ld	s1,8(sp)
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfcd                	j	1d8 <stat+0x2a>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1f0:	00054683          	lbu	a3,0(a0)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	4625                	li	a2,9
 1fe:	02f66963          	bltu	a2,a5,230 <atoi+0x48>
 202:	872a                	mv	a4,a0
  n = 0;
 204:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 206:	0705                	addi	a4,a4,1
 208:	0025179b          	slliw	a5,a0,0x2
 20c:	9fa9                	addw	a5,a5,a0
 20e:	0017979b          	slliw	a5,a5,0x1
 212:	9fb5                	addw	a5,a5,a3
 214:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 218:	00074683          	lbu	a3,0(a4)
 21c:	fd06879b          	addiw	a5,a3,-48
 220:	0ff7f793          	zext.b	a5,a5
 224:	fef671e3          	bgeu	a2,a5,206 <atoi+0x1e>
  return n;
}
 228:	60a2                	ld	ra,8(sp)
 22a:	6402                	ld	s0,0(sp)
 22c:	0141                	addi	sp,sp,16
 22e:	8082                	ret
  n = 0;
 230:	4501                	li	a0,0
 232:	bfdd                	j	228 <atoi+0x40>

0000000000000234 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 234:	1141                	addi	sp,sp,-16
 236:	e406                	sd	ra,8(sp)
 238:	e022                	sd	s0,0(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57563          	bgeu	a0,a1,266 <memmove+0x32>
    while (n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x2a>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 25a:	fee79ae3          	bne	a5,a4,24e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 26c:	fec059e3          	blez	a2,25e <memmove+0x2a>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 28a:	fef71ae3          	bne	a4,a5,27e <memmove+0x4a>
 28e:	bfc1                	j	25e <memmove+0x2a>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 298:	ca0d                	beqz	a2,2ca <memcmp+0x3a>
 29a:	fff6069b          	addiw	a3,a2,-1
 29e:	1682                	slli	a3,a3,0x20
 2a0:	9281                	srli	a3,a3,0x20
 2a2:	0685                	addi	a3,a3,1
 2a4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	0005c703          	lbu	a4,0(a1)
 2ae:	00e79863          	bne	a5,a4,2be <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2b2:	0505                	addi	a0,a0,1
    p2++;
 2b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b6:	fed518e3          	bne	a0,a3,2a6 <memcmp+0x16>
  }
  return 0;
 2ba:	4501                	li	a0,0
 2bc:	a019                	j	2c2 <memcmp+0x32>
      return *p1 - *p2;
 2be:	40e7853b          	subw	a0,a5,a4
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <memcmp+0x32>

00000000000002ce <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d6:	f5fff0ef          	jal	234 <memmove>
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret

00000000000002e2 <sbrk>:

char *
sbrk(int n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ea:	4585                	li	a1,1
 2ec:	0b2000ef          	jal	39e <sys_sbrk>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <sbrklazy>:

char *
sbrklazy(int n)
{
 2f8:	1141                	addi	sp,sp,-16
 2fa:	e406                	sd	ra,8(sp)
 2fc:	e022                	sd	s0,0(sp)
 2fe:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 300:	4589                	li	a1,2
 302:	09c000ef          	jal	39e <sys_sbrk>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30e:	4885                	li	a7,1
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <exit>:
.global exit
exit:
 li a7, SYS_exit
 316:	4889                	li	a7,2
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <wait>:
.global wait
wait:
 li a7, SYS_wait
 31e:	488d                	li	a7,3
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 326:	4891                	li	a7,4
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <read>:
.global read
read:
 li a7, SYS_read
 32e:	4895                	li	a7,5
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <write>:
.global write
write:
 li a7, SYS_write
 336:	48c1                	li	a7,16
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <close>:
.global close
close:
 li a7, SYS_close
 33e:	48d5                	li	a7,21
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <kill>:
.global kill
kill:
 li a7, SYS_kill
 346:	4899                	li	a7,6
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <exec>:
.global exec
exec:
 li a7, SYS_exec
 34e:	489d                	li	a7,7
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <open>:
.global open
open:
 li a7, SYS_open
 356:	48bd                	li	a7,15
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35e:	48c5                	li	a7,17
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 366:	48c9                	li	a7,18
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36e:	48a1                	li	a7,8
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <link>:
.global link
link:
 li a7, SYS_link
 376:	48cd                	li	a7,19
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37e:	48d1                	li	a7,20
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 386:	48a5                	li	a7,9
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <dup>:
.global dup
dup:
 li a7, SYS_dup
 38e:	48a9                	li	a7,10
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 396:	48ad                	li	a7,11
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 39e:	48b1                	li	a7,12
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a6:	48b5                	li	a7,13
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ae:	48b9                	li	a7,14
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3b6:	48d9                	li	a7,22
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <ps>:
.global ps
ps:
 li a7, SYS_ps
 3be:	48dd                	li	a7,23
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3c6:	48e1                	li	a7,24
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3ce:	48e5                	li	a7,25
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3d6:	48e9                	li	a7,26
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <trace>:
.global trace
trace:
 li a7, SYS_trace
 3de:	48ed                	li	a7,27
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 3e6:	48f1                	li	a7,28
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3ee:	48f5                	li	a7,29
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 3f6:	48f9                	li	a7,30
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 3fe:	48fd                	li	a7,31
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 406:	02000893          	li	a7,32
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <halt>:
.global halt
halt:
 li a7, SYS_halt
 410:	02100893          	li	a7,33
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 41a:	02200893          	li	a7,34
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 424:	02300893          	li	a7,35
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 42e:	02400893          	li	a7,36
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 438:	02500893          	li	a7,37
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 442:	1101                	addi	sp,sp,-32
 444:	ec06                	sd	ra,24(sp)
 446:	e822                	sd	s0,16(sp)
 448:	1000                	addi	s0,sp,32
 44a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44e:	4605                	li	a2,1
 450:	fef40593          	addi	a1,s0,-17
 454:	ee3ff0ef          	jal	336 <write>
}
 458:	60e2                	ld	ra,24(sp)
 45a:	6442                	ld	s0,16(sp)
 45c:	6105                	addi	sp,sp,32
 45e:	8082                	ret

0000000000000460 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 460:	715d                	addi	sp,sp,-80
 462:	e486                	sd	ra,72(sp)
 464:	e0a2                	sd	s0,64(sp)
 466:	fc26                	sd	s1,56(sp)
 468:	f84a                	sd	s2,48(sp)
 46a:	f44e                	sd	s3,40(sp)
 46c:	0880                	addi	s0,sp,80
 46e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 470:	c299                	beqz	a3,476 <printint+0x16>
 472:	0605cc63          	bltz	a1,4ea <printint+0x8a>
  neg = 0;
 476:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 478:	fb840313          	addi	t1,s0,-72
  neg = 0;
 47c:	869a                	mv	a3,t1
  i = 0;
 47e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 480:	00000817          	auipc	a6,0x0
 484:	52880813          	addi	a6,a6,1320 # 9a8 <digits>
 488:	88be                	mv	a7,a5
 48a:	0017851b          	addiw	a0,a5,1
 48e:	87aa                	mv	a5,a0
 490:	02c5f733          	remu	a4,a1,a2
 494:	9742                	add	a4,a4,a6
 496:	00074703          	lbu	a4,0(a4)
 49a:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 49e:	872e                	mv	a4,a1
 4a0:	02c5d5b3          	divu	a1,a1,a2
 4a4:	0685                	addi	a3,a3,1
 4a6:	fec771e3          	bgeu	a4,a2,488 <printint+0x28>
  if (neg)
 4aa:	000e0c63          	beqz	t3,4c2 <printint+0x62>
    buf[i++] = '-';
 4ae:	fd050793          	addi	a5,a0,-48
 4b2:	00878533          	add	a0,a5,s0
 4b6:	02d00793          	li	a5,45
 4ba:	fef50423          	sb	a5,-24(a0)
 4be:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4c2:	fff7899b          	addiw	s3,a5,-1
 4c6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ca:	fff4c583          	lbu	a1,-1(s1)
 4ce:	854a                	mv	a0,s2
 4d0:	f73ff0ef          	jal	442 <putc>
  while (--i >= 0)
 4d4:	39fd                	addiw	s3,s3,-1
 4d6:	14fd                	addi	s1,s1,-1
 4d8:	fe09d9e3          	bgez	s3,4ca <printint+0x6a>
}
 4dc:	60a6                	ld	ra,72(sp)
 4de:	6406                	ld	s0,64(sp)
 4e0:	74e2                	ld	s1,56(sp)
 4e2:	7942                	ld	s2,48(sp)
 4e4:	79a2                	ld	s3,40(sp)
 4e6:	6161                	addi	sp,sp,80
 4e8:	8082                	ret
    x = -xx;
 4ea:	40b005b3          	neg	a1,a1
    neg = 1;
 4ee:	4e05                	li	t3,1
    x = -xx;
 4f0:	b761                	j	478 <printint+0x18>

00000000000004f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f2:	711d                	addi	sp,sp,-96
 4f4:	ec86                	sd	ra,88(sp)
 4f6:	e8a2                	sd	s0,80(sp)
 4f8:	e4a6                	sd	s1,72(sp)
 4fa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4fc:	0005c483          	lbu	s1,0(a1)
 500:	28048463          	beqz	s1,788 <vprintf+0x296>
 504:	e0ca                	sd	s2,64(sp)
 506:	fc4e                	sd	s3,56(sp)
 508:	f852                	sd	s4,48(sp)
 50a:	f456                	sd	s5,40(sp)
 50c:	f05a                	sd	s6,32(sp)
 50e:	ec5e                	sd	s7,24(sp)
 510:	e862                	sd	s8,16(sp)
 512:	e466                	sd	s9,8(sp)
 514:	8b2a                	mv	s6,a0
 516:	8a2e                	mv	s4,a1
 518:	8bb2                	mv	s7,a2
  state = 0;
 51a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 51c:	4901                	li	s2,0
 51e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 520:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 524:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 528:	06c00c93          	li	s9,108
 52c:	a00d                	j	54e <vprintf+0x5c>
        putc(fd, c0);
 52e:	85a6                	mv	a1,s1
 530:	855a                	mv	a0,s6
 532:	f11ff0ef          	jal	442 <putc>
 536:	a019                	j	53c <vprintf+0x4a>
    } else if (state == '%') {
 538:	03598363          	beq	s3,s5,55e <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 53c:	0019079b          	addiw	a5,s2,1
 540:	893e                	mv	s2,a5
 542:	873e                	mv	a4,a5
 544:	97d2                	add	a5,a5,s4
 546:	0007c483          	lbu	s1,0(a5)
 54a:	22048763          	beqz	s1,778 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 54e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 552:	fe0993e3          	bnez	s3,538 <vprintf+0x46>
      if (c0 == '%') {
 556:	fd579ce3          	bne	a5,s5,52e <vprintf+0x3c>
        state = '%';
 55a:	89be                	mv	s3,a5
 55c:	b7c5                	j	53c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 55e:	00ea06b3          	add	a3,s4,a4
 562:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 566:	8636                	mv	a2,a3
      if (c1)
 568:	c681                	beqz	a3,570 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 56a:	9752                	add	a4,a4,s4
 56c:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 570:	05878263          	beq	a5,s8,5b4 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 574:	05978c63          	beq	a5,s9,5cc <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 578:	07500713          	li	a4,117
 57c:	0ee78663          	beq	a5,a4,668 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 580:	07800713          	li	a4,120
 584:	12e78863          	beq	a5,a4,6b4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 588:	07000713          	li	a4,112
 58c:	14e78d63          	beq	a5,a4,6e6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 590:	06300713          	li	a4,99
 594:	18e78c63          	beq	a5,a4,72c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 598:	07300713          	li	a4,115
 59c:	1ae78263          	beq	a5,a4,740 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5a0:	02500713          	li	a4,37
 5a4:	04e79463          	bne	a5,a4,5ec <vprintf+0xfa>
        putc(fd, '%');
 5a8:	85ba                	mv	a1,a4
 5aa:	855a                	mv	a0,s6
 5ac:	e97ff0ef          	jal	442 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b769                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e9fff0ef          	jal	460 <printint>
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bf8d                	j	53c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5cc:	06400793          	li	a5,100
 5d0:	02f68963          	beq	a3,a5,602 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5d4:	06c00793          	li	a5,108
 5d8:	04f68263          	beq	a3,a5,61c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5dc:	07500793          	li	a5,117
 5e0:	0af68063          	beq	a3,a5,680 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5e4:	07800793          	li	a5,120
 5e8:	0ef68263          	beq	a3,a5,6cc <vprintf+0x1da>
        putc(fd, '%');
 5ec:	02500593          	li	a1,37
 5f0:	855a                	mv	a0,s6
 5f2:	e51ff0ef          	jal	442 <putc>
        putc(fd, c0);
 5f6:	85a6                	mv	a1,s1
 5f8:	855a                	mv	a0,s6
 5fa:	e49ff0ef          	jal	442 <putc>
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bf35                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e51ff0ef          	jal	460 <printint>
        i += 1;
 614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 1;
 61a:	b70d                	j	53c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 61c:	06400793          	li	a5,100
 620:	02f60763          	beq	a2,a5,64e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 624:	07500793          	li	a5,117
 628:	06f60963          	beq	a2,a5,69a <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 62c:	07800793          	li	a5,120
 630:	faf61ee3          	bne	a2,a5,5ec <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4641                	li	a2,16
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	e1fff0ef          	jal	460 <printint>
        i += 2;
 646:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
        i += 2;
 64c:	bdc5                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	008b8493          	addi	s1,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e05ff0ef          	jal	460 <printint>
        i += 2;
 660:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	bdd9                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4629                	li	a2,10
 670:	000be583          	lwu	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	debff0ef          	jal	460 <printint>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd7d                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 680:	008b8493          	addi	s1,s7,8
 684:	4681                	li	a3,0
 686:	4629                	li	a2,10
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	dd3ff0ef          	jal	460 <printint>
        i += 1;
 692:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
        i += 1;
 698:	b555                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	008b8493          	addi	s1,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	db9ff0ef          	jal	460 <printint>
        i += 2;
 6ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	8ba6                	mv	s7,s1
      state = 0;
 6b0:	4981                	li	s3,0
        i += 2;
 6b2:	b569                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b4:	008b8493          	addi	s1,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4641                	li	a2,16
 6bc:	000be583          	lwu	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	d9fff0ef          	jal	460 <printint>
 6c6:	8ba6                	mv	s7,s1
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd8d                	j	53c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6cc:	008b8493          	addi	s1,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4641                	li	a2,16
 6d4:	000bb583          	ld	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	d87ff0ef          	jal	460 <printint>
        i += 1;
 6de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e0:	8ba6                	mv	s7,s1
      state = 0;
 6e2:	4981                	li	s3,0
        i += 1;
 6e4:	bda1                	j	53c <vprintf+0x4a>
 6e6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e8:	008b8d13          	addi	s10,s7,8
 6ec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f0:	03000593          	li	a1,48
 6f4:	855a                	mv	a0,s6
 6f6:	d4dff0ef          	jal	442 <putc>
  putc(fd, 'x');
 6fa:	07800593          	li	a1,120
 6fe:	855a                	mv	a0,s6
 700:	d43ff0ef          	jal	442 <putc>
 704:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 706:	00000b97          	auipc	s7,0x0
 70a:	2a2b8b93          	addi	s7,s7,674 # 9a8 <digits>
 70e:	03c9d793          	srli	a5,s3,0x3c
 712:	97de                	add	a5,a5,s7
 714:	0007c583          	lbu	a1,0(a5)
 718:	855a                	mv	a0,s6
 71a:	d29ff0ef          	jal	442 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	0992                	slli	s3,s3,0x4
 720:	34fd                	addiw	s1,s1,-1
 722:	f4f5                	bnez	s1,70e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 724:	8bea                	mv	s7,s10
      state = 0;
 726:	4981                	li	s3,0
 728:	6d02                	ld	s10,0(sp)
 72a:	bd09                	j	53c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 72c:	008b8493          	addi	s1,s7,8
 730:	000bc583          	lbu	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d0dff0ef          	jal	442 <putc>
 73a:	8ba6                	mv	s7,s1
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bbfd                	j	53c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 740:	008b8993          	addi	s3,s7,8
 744:	000bb483          	ld	s1,0(s7)
 748:	cc91                	beqz	s1,764 <vprintf+0x272>
        for (; *s; s++)
 74a:	0004c583          	lbu	a1,0(s1)
 74e:	c195                	beqz	a1,772 <vprintf+0x280>
          putc(fd, *s);
 750:	855a                	mv	a0,s6
 752:	cf1ff0ef          	jal	442 <putc>
        for (; *s; s++)
 756:	0485                	addi	s1,s1,1
 758:	0004c583          	lbu	a1,0(s1)
 75c:	f9f5                	bnez	a1,750 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	bbe9                	j	53c <vprintf+0x4a>
          s = "(null)";
 764:	00000497          	auipc	s1,0x0
 768:	23c48493          	addi	s1,s1,572 # 9a0 <malloc+0x12c>
        for (; *s; s++)
 76c:	02800593          	li	a1,40
 770:	b7c5                	j	750 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 772:	8bce                	mv	s7,s3
      state = 0;
 774:	4981                	li	s3,0
 776:	b3d9                	j	53c <vprintf+0x4a>
 778:	6906                	ld	s2,64(sp)
 77a:	79e2                	ld	s3,56(sp)
 77c:	7a42                	ld	s4,48(sp)
 77e:	7aa2                	ld	s5,40(sp)
 780:	7b02                	ld	s6,32(sp)
 782:	6be2                	ld	s7,24(sp)
 784:	6c42                	ld	s8,16(sp)
 786:	6ca2                	ld	s9,8(sp)
    }
  }
}
 788:	60e6                	ld	ra,88(sp)
 78a:	6446                	ld	s0,80(sp)
 78c:	64a6                	ld	s1,72(sp)
 78e:	6125                	addi	sp,sp,96
 790:	8082                	ret

0000000000000792 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 792:	715d                	addi	sp,sp,-80
 794:	ec06                	sd	ra,24(sp)
 796:	e822                	sd	s0,16(sp)
 798:	1000                	addi	s0,sp,32
 79a:	e010                	sd	a2,0(s0)
 79c:	e414                	sd	a3,8(s0)
 79e:	e818                	sd	a4,16(s0)
 7a0:	ec1c                	sd	a5,24(s0)
 7a2:	03043023          	sd	a6,32(s0)
 7a6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7aa:	8622                	mv	a2,s0
 7ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b0:	d43ff0ef          	jal	4f2 <vprintf>
}
 7b4:	60e2                	ld	ra,24(sp)
 7b6:	6442                	ld	s0,16(sp)
 7b8:	6161                	addi	sp,sp,80
 7ba:	8082                	ret

00000000000007bc <printf>:

void
printf(const char *fmt, ...)
{
 7bc:	711d                	addi	sp,sp,-96
 7be:	ec06                	sd	ra,24(sp)
 7c0:	e822                	sd	s0,16(sp)
 7c2:	1000                	addi	s0,sp,32
 7c4:	e40c                	sd	a1,8(s0)
 7c6:	e810                	sd	a2,16(s0)
 7c8:	ec14                	sd	a3,24(s0)
 7ca:	f018                	sd	a4,32(s0)
 7cc:	f41c                	sd	a5,40(s0)
 7ce:	03043823          	sd	a6,48(s0)
 7d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d6:	00840613          	addi	a2,s0,8
 7da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7de:	85aa                	mv	a1,a0
 7e0:	4505                	li	a0,1
 7e2:	d11ff0ef          	jal	4f2 <vprintf>
}
 7e6:	60e2                	ld	ra,24(sp)
 7e8:	6442                	ld	s0,16(sp)
 7ea:	6125                	addi	sp,sp,96
 7ec:	8082                	ret

00000000000007ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ee:	1141                	addi	sp,sp,-16
 7f0:	e406                	sd	ra,8(sp)
 7f2:	e022                	sd	s0,0(sp)
 7f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7f6:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fa:	00001797          	auipc	a5,0x1
 7fe:	8067b783          	ld	a5,-2042(a5) # 1000 <freep>
 802:	a02d                	j	82c <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 804:	4618                	lw	a4,8(a2)
 806:	9f2d                	addw	a4,a4,a1
 808:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6398                	ld	a4,0(a5)
 80e:	6310                	ld	a2,0(a4)
 810:	a83d                	j	84e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9f31                	addw	a4,a4,a2
 818:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053683          	ld	a3,-16(a0)
 81e:	a091                	j	862 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6398                	ld	a4,0(a5)
 822:	00e7e463          	bltu	a5,a4,82a <free+0x3c>
 826:	00e6ea63          	bltu	a3,a4,83a <free+0x4c>
{
 82a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fed7fae3          	bgeu	a5,a3,820 <free+0x32>
 830:	6398                	ld	a4,0(a5)
 832:	00e6e463          	bltu	a3,a4,83a <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	fee7eae3          	bltu	a5,a4,82a <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059813          	slli	a6,a1,0x20
 844:	01c85713          	srli	a4,a6,0x1c
 848:	9736                	add	a4,a4,a3
 84a:	fae60de3          	beq	a2,a4,804 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 852:	4790                	lw	a2,8(a5)
 854:	02061593          	slli	a1,a2,0x20
 858:	01c5d713          	srli	a4,a1,0x1c
 85c:	973e                	add	a4,a4,a5
 85e:	fae68ae3          	beq	a3,a4,812 <free+0x24>
    p->s.ptr = bp->s.ptr;
 862:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
}
 86c:	60a2                	ld	ra,8(sp)
 86e:	6402                	ld	s0,0(sp)
 870:	0141                	addi	sp,sp,16
 872:	8082                	ret

0000000000000874 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 874:	7139                	addi	sp,sp,-64
 876:	fc06                	sd	ra,56(sp)
 878:	f822                	sd	s0,48(sp)
 87a:	f04a                	sd	s2,32(sp)
 87c:	ec4e                	sd	s3,24(sp)
 87e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 880:	02051993          	slli	s3,a0,0x20
 884:	0209d993          	srli	s3,s3,0x20
 888:	09bd                	addi	s3,s3,15
 88a:	0049d993          	srli	s3,s3,0x4
 88e:	2985                	addiw	s3,s3,1
 890:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 892:	00000517          	auipc	a0,0x0
 896:	76e53503          	ld	a0,1902(a0) # 1000 <freep>
 89a:	c905                	beqz	a0,8ca <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 89c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 89e:	4798                	lw	a4,8(a5)
 8a0:	09377663          	bgeu	a4,s3,92c <malloc+0xb8>
 8a4:	f426                	sd	s1,40(sp)
 8a6:	e852                	sd	s4,16(sp)
 8a8:	e456                	sd	s5,8(sp)
 8aa:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ac:	8a4e                	mv	s4,s3
 8ae:	6705                	lui	a4,0x1
 8b0:	00e9f363          	bgeu	s3,a4,8b6 <malloc+0x42>
 8b4:	6a05                	lui	s4,0x1
 8b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8be:	00000497          	auipc	s1,0x0
 8c2:	74248493          	addi	s1,s1,1858 # 1000 <freep>
  if (p == SBRK_ERROR)
 8c6:	5afd                	li	s5,-1
 8c8:	a83d                	j	906 <malloc+0x92>
 8ca:	f426                	sd	s1,40(sp)
 8cc:	e852                	sd	s4,16(sp)
 8ce:	e456                	sd	s5,8(sp)
 8d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8d2:	00000797          	auipc	a5,0x0
 8d6:	73e78793          	addi	a5,a5,1854 # 1010 <base>
 8da:	00000717          	auipc	a4,0x0
 8de:	72f73323          	sd	a5,1830(a4) # 1000 <freep>
 8e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8e8:	b7d1                	j	8ac <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	e118                	sd	a4,0(a0)
 8ee:	a899                	j	944 <malloc+0xd0>
  hp->s.size = nu;
 8f0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8f4:	0541                	addi	a0,a0,16
 8f6:	ef9ff0ef          	jal	7ee <free>
  return freep;
 8fa:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8fc:	c125                	beqz	a0,95c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8fe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 900:	4798                	lw	a4,8(a5)
 902:	03277163          	bgeu	a4,s2,924 <malloc+0xb0>
    if (p == freep)
 906:	6098                	ld	a4,0(s1)
 908:	853e                	mv	a0,a5
 90a:	fef71ae3          	bne	a4,a5,8fe <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 90e:	8552                	mv	a0,s4
 910:	9d3ff0ef          	jal	2e2 <sbrk>
  if (p == SBRK_ERROR)
 914:	fd551ee3          	bne	a0,s5,8f0 <malloc+0x7c>
        return 0;
 918:	4501                	li	a0,0
 91a:	74a2                	ld	s1,40(sp)
 91c:	6a42                	ld	s4,16(sp)
 91e:	6aa2                	ld	s5,8(sp)
 920:	6b02                	ld	s6,0(sp)
 922:	a03d                	j	950 <malloc+0xdc>
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 92c:	fae90fe3          	beq	s2,a4,8ea <malloc+0x76>
        p->s.size -= nunits;
 930:	4137073b          	subw	a4,a4,s3
 934:	c798                	sw	a4,8(a5)
        p += p->s.size;
 936:	02071693          	slli	a3,a4,0x20
 93a:	01c6d713          	srli	a4,a3,0x1c
 93e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 940:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 944:	00000717          	auipc	a4,0x0
 948:	6aa73e23          	sd	a0,1724(a4) # 1000 <freep>
      return (void *)(p + 1);
 94c:	01078513          	addi	a0,a5,16
  }
}
 950:	70e2                	ld	ra,56(sp)
 952:	7442                	ld	s0,48(sp)
 954:	7902                	ld	s2,32(sp)
 956:	69e2                	ld	s3,24(sp)
 958:	6121                	addi	sp,sp,64
 95a:	8082                	ret
 95c:	74a2                	ld	s1,40(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
 964:	b7f5                	j	950 <malloc+0xdc>
