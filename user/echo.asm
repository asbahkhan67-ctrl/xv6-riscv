
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  int i;

  for (i = 1; i < argc; i++) {
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if (i + 1 < argc) {
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	96cb0b13          	addi	s6,s6,-1684 # 9a0 <malloc+0xfe>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	320000ef          	jal	364 <write>
  for (i = 1; i < argc; i++) {
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	306000ef          	jal	364 <write>
    if (i + 1 < argc) {
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	94058593          	addi	a1,a1,-1728 # 9a8 <malloc+0x106>
  70:	8532                	mv	a0,a2
  72:	2f2000ef          	jal	364 <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2cc000ef          	jal	344 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	2bc000ef          	jal	344 <exit>

000000000000008c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf99                	beqz	a5,106 <strlen+0x2a>
  ea:	0505                	addi	a0,a0,1
  ec:	87aa                	mv	a5,a0
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
  fc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for (n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfdd                	j	fe <strlen+0x22>

000000000000010a <memset>:

void *
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 112:	ca19                	beqz	a2,128 <memset+0x1e>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x14>
  }
  return dst;
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char *
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  for (; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf81                	beqz	a5,154 <strchr+0x24>
    if (*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1c>
  for (; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xe>
      return (char *)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfdd                	j	14c <strchr+0x1c>

0000000000000158 <gets>:

char *
gets(char *buf, int max)
{
 158:	7159                	addi	sp,sp,-112
 15a:	f486                	sd	ra,104(sp)
 15c:	f0a2                	sd	s0,96(sp)
 15e:	eca6                	sd	s1,88(sp)
 160:	e8ca                	sd	s2,80(sp)
 162:	e4ce                	sd	s3,72(sp)
 164:	e0d2                	sd	s4,64(sp)
 166:	fc56                	sd	s5,56(sp)
 168:	f85a                	sd	s6,48(sp)
 16a:	f45e                	sd	s7,40(sp)
 16c:	f062                	sd	s8,32(sp)
 16e:	ec66                	sd	s9,24(sp)
 170:	e86a                	sd	s10,16(sp)
 172:	1880                	addi	s0,sp,112
 174:	8caa                	mv	s9,a0
 176:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 178:	892a                	mv	s2,a0
 17a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 17c:	f9f40b13          	addi	s6,s0,-97
 180:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 182:	4ba9                	li	s7,10
 184:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 186:	8d26                	mv	s10,s1
 188:	0014899b          	addiw	s3,s1,1
 18c:	84ce                	mv	s1,s3
 18e:	0349d563          	bge	s3,s4,1b8 <gets+0x60>
    cc = read(0, &c, 1);
 192:	8656                	mv	a2,s5
 194:	85da                	mv	a1,s6
 196:	4501                	li	a0,0
 198:	1c4000ef          	jal	35c <read>
    if (cc < 1)
 19c:	00a05e63          	blez	a0,1b8 <gets+0x60>
    buf[i++] = c;
 1a0:	f9f44783          	lbu	a5,-97(s0)
 1a4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1a8:	01778763          	beq	a5,s7,1b6 <gets+0x5e>
 1ac:	0905                	addi	s2,s2,1
 1ae:	fd879ce3          	bne	a5,s8,186 <gets+0x2e>
    buf[i++] = c;
 1b2:	8d4e                	mv	s10,s3
 1b4:	a011                	j	1b8 <gets+0x60>
 1b6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b8:	9d66                	add	s10,s10,s9
 1ba:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1be:	8566                	mv	a0,s9
 1c0:	70a6                	ld	ra,104(sp)
 1c2:	7406                	ld	s0,96(sp)
 1c4:	64e6                	ld	s1,88(sp)
 1c6:	6946                	ld	s2,80(sp)
 1c8:	69a6                	ld	s3,72(sp)
 1ca:	6a06                	ld	s4,64(sp)
 1cc:	7ae2                	ld	s5,56(sp)
 1ce:	7b42                	ld	s6,48(sp)
 1d0:	7ba2                	ld	s7,40(sp)
 1d2:	7c02                	ld	s8,32(sp)
 1d4:	6ce2                	ld	s9,24(sp)
 1d6:	6d42                	ld	s10,16(sp)
 1d8:	6165                	addi	sp,sp,112
 1da:	8082                	ret

00000000000001dc <stat>:

int
stat(const char *n, struct stat *st)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	19a000ef          	jal	384 <open>
  if (fd < 0)
 1ee:	02054263          	bltz	a0,212 <stat+0x36>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	1a4000ef          	jal	39c <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	16c000ef          	jal	36c <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	597d                	li	s2,-1
 214:	bfcd                	j	206 <stat+0x2a>

0000000000000216 <atoi>:

int
atoi(const char *s)
{
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 21e:	00054683          	lbu	a3,0(a0)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	4625                	li	a2,9
 22c:	02f66963          	bltu	a2,a5,25e <atoi+0x48>
 230:	872a                	mv	a4,a0
  n = 0;
 232:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 234:	0705                	addi	a4,a4,1
 236:	0025179b          	slliw	a5,a0,0x2
 23a:	9fa9                	addw	a5,a5,a0
 23c:	0017979b          	slliw	a5,a5,0x1
 240:	9fb5                	addw	a5,a5,a3
 242:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 246:	00074683          	lbu	a3,0(a4)
 24a:	fd06879b          	addiw	a5,a3,-48
 24e:	0ff7f793          	zext.b	a5,a5
 252:	fef671e3          	bgeu	a2,a5,234 <atoi+0x1e>
  return n;
}
 256:	60a2                	ld	ra,8(sp)
 258:	6402                	ld	s0,0(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
  n = 0;
 25e:	4501                	li	a0,0
 260:	bfdd                	j	256 <atoi+0x40>

0000000000000262 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26a:	02b57563          	bgeu	a0,a1,294 <memmove+0x32>
    while (n-- > 0)
 26e:	00c05f63          	blez	a2,28c <memmove+0x2a>
 272:	1602                	slli	a2,a2,0x20
 274:	9201                	srli	a2,a2,0x20
 276:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27a:	872a                	mv	a4,a0
      *dst++ = *src++;
 27c:	0585                	addi	a1,a1,1
 27e:	0705                	addi	a4,a4,1
 280:	fff5c683          	lbu	a3,-1(a1)
 284:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
    dst += n;
 294:	00c50733          	add	a4,a0,a2
    src += n;
 298:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 29a:	fec059e3          	blez	a2,28c <memmove+0x2a>
 29e:	fff6079b          	addiw	a5,a2,-1
 2a2:	1782                	slli	a5,a5,0x20
 2a4:	9381                	srli	a5,a5,0x20
 2a6:	fff7c793          	not	a5,a5
 2aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ac:	15fd                	addi	a1,a1,-1
 2ae:	177d                	addi	a4,a4,-1
 2b0:	0005c683          	lbu	a3,0(a1)
 2b4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x4a>
 2bc:	bfc1                	j	28c <memmove+0x2a>

00000000000002be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c6:	ca0d                	beqz	a2,2f8 <memcmp+0x3a>
 2c8:	fff6069b          	addiw	a3,a2,-1
 2cc:	1682                	slli	a3,a3,0x20
 2ce:	9281                	srli	a3,a3,0x20
 2d0:	0685                	addi	a3,a3,1
 2d2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2d4:	00054783          	lbu	a5,0(a0)
 2d8:	0005c703          	lbu	a4,0(a1)
 2dc:	00e79863          	bne	a5,a4,2ec <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e0:	0505                	addi	a0,a0,1
    p2++;
 2e2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e4:	fed518e3          	bne	a0,a3,2d4 <memcmp+0x16>
  }
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	a019                	j	2f0 <memcmp+0x32>
      return *p1 - *p2;
 2ec:	40e7853b          	subw	a0,a5,a4
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	addi	sp,sp,16
 2f6:	8082                	ret
  return 0;
 2f8:	4501                	li	a0,0
 2fa:	bfdd                	j	2f0 <memcmp+0x32>

00000000000002fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fc:	1141                	addi	sp,sp,-16
 2fe:	e406                	sd	ra,8(sp)
 300:	e022                	sd	s0,0(sp)
 302:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 304:	f5fff0ef          	jal	262 <memmove>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <sbrk>:

char *
sbrk(int n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 318:	4585                	li	a1,1
 31a:	0b2000ef          	jal	3cc <sys_sbrk>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <sbrklazy>:

char *
sbrklazy(int n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32e:	4589                	li	a1,2
 330:	09c000ef          	jal	3cc <sys_sbrk>
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33c:	4885                	li	a7,1
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <exit>:
.global exit
exit:
 li a7, SYS_exit
 344:	4889                	li	a7,2
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <wait>:
.global wait
wait:
 li a7, SYS_wait
 34c:	488d                	li	a7,3
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 354:	4891                	li	a7,4
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <read>:
.global read
read:
 li a7, SYS_read
 35c:	4895                	li	a7,5
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <write>:
.global write
write:
 li a7, SYS_write
 364:	48c1                	li	a7,16
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <close>:
.global close
close:
 li a7, SYS_close
 36c:	48d5                	li	a7,21
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <kill>:
.global kill
kill:
 li a7, SYS_kill
 374:	4899                	li	a7,6
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exec>:
.global exec
exec:
 li a7, SYS_exec
 37c:	489d                	li	a7,7
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <open>:
.global open
open:
 li a7, SYS_open
 384:	48bd                	li	a7,15
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38c:	48c5                	li	a7,17
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 394:	48c9                	li	a7,18
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39c:	48a1                	li	a7,8
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <link>:
.global link
link:
 li a7, SYS_link
 3a4:	48cd                	li	a7,19
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ac:	48d1                	li	a7,20
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b4:	48a5                	li	a7,9
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3bc:	48a9                	li	a7,10
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c4:	48ad                	li	a7,11
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3cc:	48b1                	li	a7,12
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d4:	48b5                	li	a7,13
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3dc:	48b9                	li	a7,14
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3e4:	48d9                	li	a7,22
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <ps>:
.global ps
ps:
 li a7, SYS_ps
 3ec:	48dd                	li	a7,23
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3f4:	48e1                	li	a7,24
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3fc:	48e5                	li	a7,25
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 404:	48e9                	li	a7,26
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <trace>:
.global trace
trace:
 li a7, SYS_trace
 40c:	48ed                	li	a7,27
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 414:	48f1                	li	a7,28
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 41c:	48f5                	li	a7,29
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 424:	48f9                	li	a7,30
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 42c:	48fd                	li	a7,31
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 434:	02000893          	li	a7,32
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <halt>:
.global halt
halt:
 li a7, SYS_halt
 43e:	02100893          	li	a7,33
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 448:	02200893          	li	a7,34
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 452:	02300893          	li	a7,35
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 45c:	02400893          	li	a7,36
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 466:	02500893          	li	a7,37
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	1000                	addi	s0,sp,32
 478:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 47c:	4605                	li	a2,1
 47e:	fef40593          	addi	a1,s0,-17
 482:	ee3ff0ef          	jal	364 <write>
}
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret

000000000000048e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 48e:	715d                	addi	sp,sp,-80
 490:	e486                	sd	ra,72(sp)
 492:	e0a2                	sd	s0,64(sp)
 494:	fc26                	sd	s1,56(sp)
 496:	f84a                	sd	s2,48(sp)
 498:	f44e                	sd	s3,40(sp)
 49a:	0880                	addi	s0,sp,80
 49c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 49e:	c299                	beqz	a3,4a4 <printint+0x16>
 4a0:	0605cc63          	bltz	a1,518 <printint+0x8a>
  neg = 0;
 4a4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a6:	fb840313          	addi	t1,s0,-72
  neg = 0;
 4aa:	869a                	mv	a3,t1
  i = 0;
 4ac:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4ae:	00000817          	auipc	a6,0x0
 4b2:	50a80813          	addi	a6,a6,1290 # 9b8 <digits>
 4b6:	88be                	mv	a7,a5
 4b8:	0017851b          	addiw	a0,a5,1
 4bc:	87aa                	mv	a5,a0
 4be:	02c5f733          	remu	a4,a1,a2
 4c2:	9742                	add	a4,a4,a6
 4c4:	00074703          	lbu	a4,0(a4)
 4c8:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4cc:	872e                	mv	a4,a1
 4ce:	02c5d5b3          	divu	a1,a1,a2
 4d2:	0685                	addi	a3,a3,1
 4d4:	fec771e3          	bgeu	a4,a2,4b6 <printint+0x28>
  if (neg)
 4d8:	000e0c63          	beqz	t3,4f0 <printint+0x62>
    buf[i++] = '-';
 4dc:	fd050793          	addi	a5,a0,-48
 4e0:	00878533          	add	a0,a5,s0
 4e4:	02d00793          	li	a5,45
 4e8:	fef50423          	sb	a5,-24(a0)
 4ec:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4f0:	fff7899b          	addiw	s3,a5,-1
 4f4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4f8:	fff4c583          	lbu	a1,-1(s1)
 4fc:	854a                	mv	a0,s2
 4fe:	f73ff0ef          	jal	470 <putc>
  while (--i >= 0)
 502:	39fd                	addiw	s3,s3,-1
 504:	14fd                	addi	s1,s1,-1
 506:	fe09d9e3          	bgez	s3,4f8 <printint+0x6a>
}
 50a:	60a6                	ld	ra,72(sp)
 50c:	6406                	ld	s0,64(sp)
 50e:	74e2                	ld	s1,56(sp)
 510:	7942                	ld	s2,48(sp)
 512:	79a2                	ld	s3,40(sp)
 514:	6161                	addi	sp,sp,80
 516:	8082                	ret
    x = -xx;
 518:	40b005b3          	neg	a1,a1
    neg = 1;
 51c:	4e05                	li	t3,1
    x = -xx;
 51e:	b761                	j	4a6 <printint+0x18>

0000000000000520 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 520:	711d                	addi	sp,sp,-96
 522:	ec86                	sd	ra,88(sp)
 524:	e8a2                	sd	s0,80(sp)
 526:	e4a6                	sd	s1,72(sp)
 528:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 52a:	0005c483          	lbu	s1,0(a1)
 52e:	28048463          	beqz	s1,7b6 <vprintf+0x296>
 532:	e0ca                	sd	s2,64(sp)
 534:	fc4e                	sd	s3,56(sp)
 536:	f852                	sd	s4,48(sp)
 538:	f456                	sd	s5,40(sp)
 53a:	f05a                	sd	s6,32(sp)
 53c:	ec5e                	sd	s7,24(sp)
 53e:	e862                	sd	s8,16(sp)
 540:	e466                	sd	s9,8(sp)
 542:	8b2a                	mv	s6,a0
 544:	8a2e                	mv	s4,a1
 546:	8bb2                	mv	s7,a2
  state = 0;
 548:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 54a:	4901                	li	s2,0
 54c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 54e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 552:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 556:	06c00c93          	li	s9,108
 55a:	a00d                	j	57c <vprintf+0x5c>
        putc(fd, c0);
 55c:	85a6                	mv	a1,s1
 55e:	855a                	mv	a0,s6
 560:	f11ff0ef          	jal	470 <putc>
 564:	a019                	j	56a <vprintf+0x4a>
    } else if (state == '%') {
 566:	03598363          	beq	s3,s5,58c <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 56a:	0019079b          	addiw	a5,s2,1
 56e:	893e                	mv	s2,a5
 570:	873e                	mv	a4,a5
 572:	97d2                	add	a5,a5,s4
 574:	0007c483          	lbu	s1,0(a5)
 578:	22048763          	beqz	s1,7a6 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 57c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 580:	fe0993e3          	bnez	s3,566 <vprintf+0x46>
      if (c0 == '%') {
 584:	fd579ce3          	bne	a5,s5,55c <vprintf+0x3c>
        state = '%';
 588:	89be                	mv	s3,a5
 58a:	b7c5                	j	56a <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 58c:	00ea06b3          	add	a3,s4,a4
 590:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 594:	8636                	mv	a2,a3
      if (c1)
 596:	c681                	beqz	a3,59e <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 598:	9752                	add	a4,a4,s4
 59a:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 59e:	05878263          	beq	a5,s8,5e2 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5a2:	05978c63          	beq	a5,s9,5fa <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5a6:	07500713          	li	a4,117
 5aa:	0ee78663          	beq	a5,a4,696 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5ae:	07800713          	li	a4,120
 5b2:	12e78863          	beq	a5,a4,6e2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5b6:	07000713          	li	a4,112
 5ba:	14e78d63          	beq	a5,a4,714 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5be:	06300713          	li	a4,99
 5c2:	18e78c63          	beq	a5,a4,75a <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5c6:	07300713          	li	a4,115
 5ca:	1ae78263          	beq	a5,a4,76e <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5ce:	02500713          	li	a4,37
 5d2:	04e79463          	bne	a5,a4,61a <vprintf+0xfa>
        putc(fd, '%');
 5d6:	85ba                	mv	a1,a4
 5d8:	855a                	mv	a0,s6
 5da:	e97ff0ef          	jal	470 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b769                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e9fff0ef          	jal	48e <printint>
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bf8d                	j	56a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5fa:	06400793          	li	a5,100
 5fe:	02f68963          	beq	a3,a5,630 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 602:	06c00793          	li	a5,108
 606:	04f68263          	beq	a3,a5,64a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 60a:	07500793          	li	a5,117
 60e:	0af68063          	beq	a3,a5,6ae <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 612:	07800793          	li	a5,120
 616:	0ef68263          	beq	a3,a5,6fa <vprintf+0x1da>
        putc(fd, '%');
 61a:	02500593          	li	a1,37
 61e:	855a                	mv	a0,s6
 620:	e51ff0ef          	jal	470 <putc>
        putc(fd, c0);
 624:	85a6                	mv	a1,s1
 626:	855a                	mv	a0,s6
 628:	e49ff0ef          	jal	470 <putc>
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf35                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8493          	addi	s1,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e51ff0ef          	jal	48e <printint>
        i += 1;
 642:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 1;
 648:	b70d                	j	56a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 64a:	06400793          	li	a5,100
 64e:	02f60763          	beq	a2,a5,67c <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 652:	07500793          	li	a5,117
 656:	06f60963          	beq	a2,a5,6c8 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 65a:	07800793          	li	a5,120
 65e:	faf61ee3          	bne	a2,a5,61a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e1fff0ef          	jal	48e <printint>
        i += 2;
 674:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	bdc5                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 67c:	008b8493          	addi	s1,s7,8
 680:	4685                	li	a3,1
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e05ff0ef          	jal	48e <printint>
        i += 2;
 68e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	bdd9                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4629                	li	a2,10
 69e:	000be583          	lwu	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	debff0ef          	jal	48e <printint>
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bd7d                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4629                	li	a2,10
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	dd3ff0ef          	jal	48e <printint>
        i += 1;
 6c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
        i += 1;
 6c6:	b555                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4629                	li	a2,10
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	db9ff0ef          	jal	48e <printint>
        i += 2;
 6da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	b569                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e2:	008b8493          	addi	s1,s7,8
 6e6:	4681                	li	a3,0
 6e8:	4641                	li	a2,16
 6ea:	000be583          	lwu	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d9fff0ef          	jal	48e <printint>
 6f4:	8ba6                	mv	s7,s1
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	bd8d                	j	56a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fa:	008b8493          	addi	s1,s7,8
 6fe:	4681                	li	a3,0
 700:	4641                	li	a2,16
 702:	000bb583          	ld	a1,0(s7)
 706:	855a                	mv	a0,s6
 708:	d87ff0ef          	jal	48e <printint>
        i += 1;
 70c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	8ba6                	mv	s7,s1
      state = 0;
 710:	4981                	li	s3,0
        i += 1;
 712:	bda1                	j	56a <vprintf+0x4a>
 714:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 716:	008b8d13          	addi	s10,s7,8
 71a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71e:	03000593          	li	a1,48
 722:	855a                	mv	a0,s6
 724:	d4dff0ef          	jal	470 <putc>
  putc(fd, 'x');
 728:	07800593          	li	a1,120
 72c:	855a                	mv	a0,s6
 72e:	d43ff0ef          	jal	470 <putc>
 732:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 734:	00000b97          	auipc	s7,0x0
 738:	284b8b93          	addi	s7,s7,644 # 9b8 <digits>
 73c:	03c9d793          	srli	a5,s3,0x3c
 740:	97de                	add	a5,a5,s7
 742:	0007c583          	lbu	a1,0(a5)
 746:	855a                	mv	a0,s6
 748:	d29ff0ef          	jal	470 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74c:	0992                	slli	s3,s3,0x4
 74e:	34fd                	addiw	s1,s1,-1
 750:	f4f5                	bnez	s1,73c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 752:	8bea                	mv	s7,s10
      state = 0;
 754:	4981                	li	s3,0
 756:	6d02                	ld	s10,0(sp)
 758:	bd09                	j	56a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 75a:	008b8493          	addi	s1,s7,8
 75e:	000bc583          	lbu	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	d0dff0ef          	jal	470 <putc>
 768:	8ba6                	mv	s7,s1
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bbfd                	j	56a <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 76e:	008b8993          	addi	s3,s7,8
 772:	000bb483          	ld	s1,0(s7)
 776:	cc91                	beqz	s1,792 <vprintf+0x272>
        for (; *s; s++)
 778:	0004c583          	lbu	a1,0(s1)
 77c:	c195                	beqz	a1,7a0 <vprintf+0x280>
          putc(fd, *s);
 77e:	855a                	mv	a0,s6
 780:	cf1ff0ef          	jal	470 <putc>
        for (; *s; s++)
 784:	0485                	addi	s1,s1,1
 786:	0004c583          	lbu	a1,0(s1)
 78a:	f9f5                	bnez	a1,77e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 78c:	8bce                	mv	s7,s3
      state = 0;
 78e:	4981                	li	s3,0
 790:	bbe9                	j	56a <vprintf+0x4a>
          s = "(null)";
 792:	00000497          	auipc	s1,0x0
 796:	21e48493          	addi	s1,s1,542 # 9b0 <malloc+0x10e>
        for (; *s; s++)
 79a:	02800593          	li	a1,40
 79e:	b7c5                	j	77e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 7a0:	8bce                	mv	s7,s3
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	b3d9                	j	56a <vprintf+0x4a>
 7a6:	6906                	ld	s2,64(sp)
 7a8:	79e2                	ld	s3,56(sp)
 7aa:	7a42                	ld	s4,48(sp)
 7ac:	7aa2                	ld	s5,40(sp)
 7ae:	7b02                	ld	s6,32(sp)
 7b0:	6be2                	ld	s7,24(sp)
 7b2:	6c42                	ld	s8,16(sp)
 7b4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7b6:	60e6                	ld	ra,88(sp)
 7b8:	6446                	ld	s0,80(sp)
 7ba:	64a6                	ld	s1,72(sp)
 7bc:	6125                	addi	sp,sp,96
 7be:	8082                	ret

00000000000007c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c0:	715d                	addi	sp,sp,-80
 7c2:	ec06                	sd	ra,24(sp)
 7c4:	e822                	sd	s0,16(sp)
 7c6:	1000                	addi	s0,sp,32
 7c8:	e010                	sd	a2,0(s0)
 7ca:	e414                	sd	a3,8(s0)
 7cc:	e818                	sd	a4,16(s0)
 7ce:	ec1c                	sd	a5,24(s0)
 7d0:	03043023          	sd	a6,32(s0)
 7d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7d8:	8622                	mv	a2,s0
 7da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7de:	d43ff0ef          	jal	520 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6161                	addi	sp,sp,80
 7e8:	8082                	ret

00000000000007ea <printf>:

void
printf(const char *fmt, ...)
{
 7ea:	711d                	addi	sp,sp,-96
 7ec:	ec06                	sd	ra,24(sp)
 7ee:	e822                	sd	s0,16(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	e40c                	sd	a1,8(s0)
 7f4:	e810                	sd	a2,16(s0)
 7f6:	ec14                	sd	a3,24(s0)
 7f8:	f018                	sd	a4,32(s0)
 7fa:	f41c                	sd	a5,40(s0)
 7fc:	03043823          	sd	a6,48(s0)
 800:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 804:	00840613          	addi	a2,s0,8
 808:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 80c:	85aa                	mv	a1,a0
 80e:	4505                	li	a0,1
 810:	d11ff0ef          	jal	520 <vprintf>
}
 814:	60e2                	ld	ra,24(sp)
 816:	6442                	ld	s0,16(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 81c:	1141                	addi	sp,sp,-16
 81e:	e406                	sd	ra,8(sp)
 820:	e022                	sd	s0,0(sp)
 822:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 824:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	00000797          	auipc	a5,0x0
 82c:	7d87b783          	ld	a5,2008(a5) # 1000 <freep>
 830:	a02d                	j	85a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 832:	4618                	lw	a4,8(a2)
 834:	9f2d                	addw	a4,a4,a1
 836:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	6398                	ld	a4,0(a5)
 83c:	6310                	ld	a2,0(a4)
 83e:	a83d                	j	87c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 840:	ff852703          	lw	a4,-8(a0)
 844:	9f31                	addw	a4,a4,a2
 846:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 848:	ff053683          	ld	a3,-16(a0)
 84c:	a091                	j	890 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x3c>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x4c>
{
 858:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x32>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	slli	a6,a1,0x20
 872:	01c85713          	srli	a4,a6,0x1c
 876:	9736                	add	a4,a4,a3
 878:	fae60de3          	beq	a2,a4,832 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	slli	a1,a2,0x20
 886:	01c5d713          	srli	a4,a1,0x1c
 88a:	973e                	add	a4,a4,a5
 88c:	fae68ae3          	beq	a3,a4,840 <free+0x24>
    p->s.ptr = bp->s.ptr;
 890:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret

00000000000008a2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8a2:	7139                	addi	sp,sp,-64
 8a4:	fc06                	sd	ra,56(sp)
 8a6:	f822                	sd	s0,48(sp)
 8a8:	f04a                	sd	s2,32(sp)
 8aa:	ec4e                	sd	s3,24(sp)
 8ac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8ae:	02051993          	slli	s3,a0,0x20
 8b2:	0209d993          	srli	s3,s3,0x20
 8b6:	09bd                	addi	s3,s3,15
 8b8:	0049d993          	srli	s3,s3,0x4
 8bc:	2985                	addiw	s3,s3,1
 8be:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8c0:	00000517          	auipc	a0,0x0
 8c4:	74053503          	ld	a0,1856(a0) # 1000 <freep>
 8c8:	c905                	beqz	a0,8f8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ca:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8cc:	4798                	lw	a4,8(a5)
 8ce:	09377663          	bgeu	a4,s3,95a <malloc+0xb8>
 8d2:	f426                	sd	s1,40(sp)
 8d4:	e852                	sd	s4,16(sp)
 8d6:	e456                	sd	s5,8(sp)
 8d8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8da:	8a4e                	mv	s4,s3
 8dc:	6705                	lui	a4,0x1
 8de:	00e9f363          	bgeu	s3,a4,8e4 <malloc+0x42>
 8e2:	6a05                	lui	s4,0x1
 8e4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8ec:	00000497          	auipc	s1,0x0
 8f0:	71448493          	addi	s1,s1,1812 # 1000 <freep>
  if (p == SBRK_ERROR)
 8f4:	5afd                	li	s5,-1
 8f6:	a83d                	j	934 <malloc+0x92>
 8f8:	f426                	sd	s1,40(sp)
 8fa:	e852                	sd	s4,16(sp)
 8fc:	e456                	sd	s5,8(sp)
 8fe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 900:	00000797          	auipc	a5,0x0
 904:	71078793          	addi	a5,a5,1808 # 1010 <base>
 908:	00000717          	auipc	a4,0x0
 90c:	6ef73c23          	sd	a5,1784(a4) # 1000 <freep>
 910:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 912:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 916:	b7d1                	j	8da <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 918:	6398                	ld	a4,0(a5)
 91a:	e118                	sd	a4,0(a0)
 91c:	a899                	j	972 <malloc+0xd0>
  hp->s.size = nu;
 91e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 922:	0541                	addi	a0,a0,16
 924:	ef9ff0ef          	jal	81c <free>
  return freep;
 928:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 92a:	c125                	beqz	a0,98a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 92c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 92e:	4798                	lw	a4,8(a5)
 930:	03277163          	bgeu	a4,s2,952 <malloc+0xb0>
    if (p == freep)
 934:	6098                	ld	a4,0(s1)
 936:	853e                	mv	a0,a5
 938:	fef71ae3          	bne	a4,a5,92c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 93c:	8552                	mv	a0,s4
 93e:	9d3ff0ef          	jal	310 <sbrk>
  if (p == SBRK_ERROR)
 942:	fd551ee3          	bne	a0,s5,91e <malloc+0x7c>
        return 0;
 946:	4501                	li	a0,0
 948:	74a2                	ld	s1,40(sp)
 94a:	6a42                	ld	s4,16(sp)
 94c:	6aa2                	ld	s5,8(sp)
 94e:	6b02                	ld	s6,0(sp)
 950:	a03d                	j	97e <malloc+0xdc>
 952:	74a2                	ld	s1,40(sp)
 954:	6a42                	ld	s4,16(sp)
 956:	6aa2                	ld	s5,8(sp)
 958:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 95a:	fae90fe3          	beq	s2,a4,918 <malloc+0x76>
        p->s.size -= nunits;
 95e:	4137073b          	subw	a4,a4,s3
 962:	c798                	sw	a4,8(a5)
        p += p->s.size;
 964:	02071693          	slli	a3,a4,0x20
 968:	01c6d713          	srli	a4,a3,0x1c
 96c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 972:	00000717          	auipc	a4,0x0
 976:	68a73723          	sd	a0,1678(a4) # 1000 <freep>
      return (void *)(p + 1);
 97a:	01078513          	addi	a0,a5,16
  }
}
 97e:	70e2                	ld	ra,56(sp)
 980:	7442                	ld	s0,48(sp)
 982:	7902                	ld	s2,32(sp)
 984:	69e2                	ld	s3,24(sp)
 986:	6121                	addi	sp,sp,64
 988:	8082                	ret
 98a:	74a2                	ld	s1,40(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	b7f5                	j	97e <malloc+0xdc>
