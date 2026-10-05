
user/_mkdir:     file format elf64-littleriscv


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
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for (i = 1; i < argc; i++) {
    if (mkdir(argv[i]) < 0) {
  26:	6088                	ld	a0,0(s1)
  28:	36e000ef          	jal	396 <mkdir>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for (i = 1; i < argc; i++) {
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2f6000ef          	jal	32e <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	8e058593          	addi	a1,a1,-1824 # 920 <malloc+0xf8>
  48:	4509                	li	a0,2
  4a:	6fc000ef          	jal	746 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2de000ef          	jal	32e <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	8e258593          	addi	a1,a1,-1822 # 938 <malloc+0x110>
  5e:	4509                	li	a0,2
  60:	6e6000ef          	jal	746 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

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
  72:	2bc000ef          	jal	32e <exit>

0000000000000076 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf99                	beqz	a5,f0 <strlen+0x2a>
  d4:	0505                	addi	a0,a0,1
  d6:	87aa                	mv	a5,a0
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
  e6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e8:	60a2                	ld	ra,8(sp)
  ea:	6402                	ld	s0,0(sp)
  ec:	0141                	addi	sp,sp,16
  ee:	8082                	ret
  for (n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfdd                	j	e8 <strlen+0x22>

00000000000000f4 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e406                	sd	ra,8(sp)
  f8:	e022                	sd	s0,0(sp)
  fa:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fc:	ca19                	beqz	a2,112 <memset+0x1e>
  fe:	87aa                	mv	a5,a0
 100:	1602                	slli	a2,a2,0x20
 102:	9201                	srli	a2,a2,0x20
 104:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 108:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10c:	0785                	addi	a5,a5,1
 10e:	fee79de3          	bne	a5,a4,108 <memset+0x14>
  }
  return dst;
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char *
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  for (; *s; s++)
 122:	00054783          	lbu	a5,0(a0)
 126:	cf81                	beqz	a5,13e <strchr+0x24>
    if (*s == c)
 128:	00f58763          	beq	a1,a5,136 <strchr+0x1c>
  for (; *s; s++)
 12c:	0505                	addi	a0,a0,1
 12e:	00054783          	lbu	a5,0(a0)
 132:	fbfd                	bnez	a5,128 <strchr+0xe>
      return (char *)s;
  return 0;
 134:	4501                	li	a0,0
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  return 0;
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strchr+0x1c>

0000000000000142 <gets>:

char *
gets(char *buf, int max)
{
 142:	7159                	addi	sp,sp,-112
 144:	f486                	sd	ra,104(sp)
 146:	f0a2                	sd	s0,96(sp)
 148:	eca6                	sd	s1,88(sp)
 14a:	e8ca                	sd	s2,80(sp)
 14c:	e4ce                	sd	s3,72(sp)
 14e:	e0d2                	sd	s4,64(sp)
 150:	fc56                	sd	s5,56(sp)
 152:	f85a                	sd	s6,48(sp)
 154:	f45e                	sd	s7,40(sp)
 156:	f062                	sd	s8,32(sp)
 158:	ec66                	sd	s9,24(sp)
 15a:	e86a                	sd	s10,16(sp)
 15c:	1880                	addi	s0,sp,112
 15e:	8caa                	mv	s9,a0
 160:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 162:	892a                	mv	s2,a0
 164:	4481                	li	s1,0
    cc = read(0, &c, 1);
 166:	f9f40b13          	addi	s6,s0,-97
 16a:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 16c:	4ba9                	li	s7,10
 16e:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 170:	8d26                	mv	s10,s1
 172:	0014899b          	addiw	s3,s1,1
 176:	84ce                	mv	s1,s3
 178:	0349d563          	bge	s3,s4,1a2 <gets+0x60>
    cc = read(0, &c, 1);
 17c:	8656                	mv	a2,s5
 17e:	85da                	mv	a1,s6
 180:	4501                	li	a0,0
 182:	1c4000ef          	jal	346 <read>
    if (cc < 1)
 186:	00a05e63          	blez	a0,1a2 <gets+0x60>
    buf[i++] = c;
 18a:	f9f44783          	lbu	a5,-97(s0)
 18e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 192:	01778763          	beq	a5,s7,1a0 <gets+0x5e>
 196:	0905                	addi	s2,s2,1
 198:	fd879ce3          	bne	a5,s8,170 <gets+0x2e>
    buf[i++] = c;
 19c:	8d4e                	mv	s10,s3
 19e:	a011                	j	1a2 <gets+0x60>
 1a0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1a2:	9d66                	add	s10,s10,s9
 1a4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1a8:	8566                	mv	a0,s9
 1aa:	70a6                	ld	ra,104(sp)
 1ac:	7406                	ld	s0,96(sp)
 1ae:	64e6                	ld	s1,88(sp)
 1b0:	6946                	ld	s2,80(sp)
 1b2:	69a6                	ld	s3,72(sp)
 1b4:	6a06                	ld	s4,64(sp)
 1b6:	7ae2                	ld	s5,56(sp)
 1b8:	7b42                	ld	s6,48(sp)
 1ba:	7ba2                	ld	s7,40(sp)
 1bc:	7c02                	ld	s8,32(sp)
 1be:	6ce2                	ld	s9,24(sp)
 1c0:	6d42                	ld	s10,16(sp)
 1c2:	6165                	addi	sp,sp,112
 1c4:	8082                	ret

00000000000001c6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c6:	1101                	addi	sp,sp,-32
 1c8:	ec06                	sd	ra,24(sp)
 1ca:	e822                	sd	s0,16(sp)
 1cc:	e04a                	sd	s2,0(sp)
 1ce:	1000                	addi	s0,sp,32
 1d0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d2:	4581                	li	a1,0
 1d4:	19a000ef          	jal	36e <open>
  if (fd < 0)
 1d8:	02054263          	bltz	a0,1fc <stat+0x36>
 1dc:	e426                	sd	s1,8(sp)
 1de:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e0:	85ca                	mv	a1,s2
 1e2:	1a4000ef          	jal	386 <fstat>
 1e6:	892a                	mv	s2,a0
  close(fd);
 1e8:	8526                	mv	a0,s1
 1ea:	16c000ef          	jal	356 <close>
  return r;
 1ee:	64a2                	ld	s1,8(sp)
}
 1f0:	854a                	mv	a0,s2
 1f2:	60e2                	ld	ra,24(sp)
 1f4:	6442                	ld	s0,16(sp)
 1f6:	6902                	ld	s2,0(sp)
 1f8:	6105                	addi	sp,sp,32
 1fa:	8082                	ret
    return -1;
 1fc:	597d                	li	s2,-1
 1fe:	bfcd                	j	1f0 <stat+0x2a>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66963          	bltu	a2,a5,248 <atoi+0x48>
 21a:	872a                	mv	a4,a0
  n = 0;
 21c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1e>
  return n;
}
 240:	60a2                	ld	ra,8(sp)
 242:	6402                	ld	s0,0(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfdd                	j	240 <atoi+0x40>

000000000000024c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57563          	bgeu	a0,a1,27e <memmove+0x32>
    while (n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x2a>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 284:	fec059e3          	blez	a2,276 <memmove+0x2a>
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x4a>
 2a6:	bfc1                	j	276 <memmove+0x2a>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	ca0d                	beqz	a2,2e2 <memcmp+0x3a>
 2b2:	fff6069b          	addiw	a3,a2,-1
 2b6:	1682                	slli	a3,a3,0x20
 2b8:	9281                	srli	a3,a3,0x20
 2ba:	0685                	addi	a3,a3,1
 2bc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2be:	00054783          	lbu	a5,0(a0)
 2c2:	0005c703          	lbu	a4,0(a1)
 2c6:	00e79863          	bne	a5,a4,2d6 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2ca:	0505                	addi	a0,a0,1
    p2++;
 2cc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ce:	fed518e3          	bne	a0,a3,2be <memcmp+0x16>
  }
  return 0;
 2d2:	4501                	li	a0,0
 2d4:	a019                	j	2da <memcmp+0x32>
      return *p1 - *p2;
 2d6:	40e7853b          	subw	a0,a5,a4
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfdd                	j	2da <memcmp+0x32>

00000000000002e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ee:	f5fff0ef          	jal	24c <memmove>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <sbrk>:

char *
sbrk(int n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 302:	4585                	li	a1,1
 304:	0b2000ef          	jal	3b6 <sys_sbrk>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <sbrklazy>:

char *
sbrklazy(int n)
{
 310:	1141                	addi	sp,sp,-16
 312:	e406                	sd	ra,8(sp)
 314:	e022                	sd	s0,0(sp)
 316:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 318:	4589                	li	a1,2
 31a:	09c000ef          	jal	3b6 <sys_sbrk>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 326:	4885                	li	a7,1
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <exit>:
.global exit
exit:
 li a7, SYS_exit
 32e:	4889                	li	a7,2
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <wait>:
.global wait
wait:
 li a7, SYS_wait
 336:	488d                	li	a7,3
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33e:	4891                	li	a7,4
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <read>:
.global read
read:
 li a7, SYS_read
 346:	4895                	li	a7,5
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <write>:
.global write
write:
 li a7, SYS_write
 34e:	48c1                	li	a7,16
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <close>:
.global close
close:
 li a7, SYS_close
 356:	48d5                	li	a7,21
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <kill>:
.global kill
kill:
 li a7, SYS_kill
 35e:	4899                	li	a7,6
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <exec>:
.global exec
exec:
 li a7, SYS_exec
 366:	489d                	li	a7,7
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <open>:
.global open
open:
 li a7, SYS_open
 36e:	48bd                	li	a7,15
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 376:	48c5                	li	a7,17
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37e:	48c9                	li	a7,18
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 386:	48a1                	li	a7,8
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <link>:
.global link
link:
 li a7, SYS_link
 38e:	48cd                	li	a7,19
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 396:	48d1                	li	a7,20
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39e:	48a5                	li	a7,9
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a6:	48a9                	li	a7,10
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ae:	48ad                	li	a7,11
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b6:	48b1                	li	a7,12
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <pause>:
.global pause
pause:
 li a7, SYS_pause
 3be:	48b5                	li	a7,13
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c6:	48b9                	li	a7,14
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <sync>:
.global sync
sync:
 li a7, SYS_sync
 3ce:	48d9                	li	a7,22
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3d6:	48dd                	li	a7,23
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3de:	48e1                	li	a7,24
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3e6:	48e5                	li	a7,25
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3ee:	48e9                	li	a7,26
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f6:	1101                	addi	sp,sp,-32
 3f8:	ec06                	sd	ra,24(sp)
 3fa:	e822                	sd	s0,16(sp)
 3fc:	1000                	addi	s0,sp,32
 3fe:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 402:	4605                	li	a2,1
 404:	fef40593          	addi	a1,s0,-17
 408:	f47ff0ef          	jal	34e <write>
}
 40c:	60e2                	ld	ra,24(sp)
 40e:	6442                	ld	s0,16(sp)
 410:	6105                	addi	sp,sp,32
 412:	8082                	ret

0000000000000414 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 414:	715d                	addi	sp,sp,-80
 416:	e486                	sd	ra,72(sp)
 418:	e0a2                	sd	s0,64(sp)
 41a:	fc26                	sd	s1,56(sp)
 41c:	f84a                	sd	s2,48(sp)
 41e:	f44e                	sd	s3,40(sp)
 420:	0880                	addi	s0,sp,80
 422:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 424:	c299                	beqz	a3,42a <printint+0x16>
 426:	0605cc63          	bltz	a1,49e <printint+0x8a>
  neg = 0;
 42a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 42c:	fb840313          	addi	t1,s0,-72
  neg = 0;
 430:	869a                	mv	a3,t1
  i = 0;
 432:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 434:	00000817          	auipc	a6,0x0
 438:	52c80813          	addi	a6,a6,1324 # 960 <digits>
 43c:	88be                	mv	a7,a5
 43e:	0017851b          	addiw	a0,a5,1
 442:	87aa                	mv	a5,a0
 444:	02c5f733          	remu	a4,a1,a2
 448:	9742                	add	a4,a4,a6
 44a:	00074703          	lbu	a4,0(a4)
 44e:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 452:	872e                	mv	a4,a1
 454:	02c5d5b3          	divu	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec771e3          	bgeu	a4,a2,43c <printint+0x28>
  if (neg)
 45e:	000e0c63          	beqz	t3,476 <printint+0x62>
    buf[i++] = '-';
 462:	fd050793          	addi	a5,a0,-48
 466:	00878533          	add	a0,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef50423          	sb	a5,-24(a0)
 472:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 476:	fff7899b          	addiw	s3,a5,-1
 47a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 47e:	fff4c583          	lbu	a1,-1(s1)
 482:	854a                	mv	a0,s2
 484:	f73ff0ef          	jal	3f6 <putc>
  while (--i >= 0)
 488:	39fd                	addiw	s3,s3,-1
 48a:	14fd                	addi	s1,s1,-1
 48c:	fe09d9e3          	bgez	s3,47e <printint+0x6a>
}
 490:	60a6                	ld	ra,72(sp)
 492:	6406                	ld	s0,64(sp)
 494:	74e2                	ld	s1,56(sp)
 496:	7942                	ld	s2,48(sp)
 498:	79a2                	ld	s3,40(sp)
 49a:	6161                	addi	sp,sp,80
 49c:	8082                	ret
    x = -xx;
 49e:	40b005b3          	neg	a1,a1
    neg = 1;
 4a2:	4e05                	li	t3,1
    x = -xx;
 4a4:	b761                	j	42c <printint+0x18>

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	711d                	addi	sp,sp,-96
 4a8:	ec86                	sd	ra,88(sp)
 4aa:	e8a2                	sd	s0,80(sp)
 4ac:	e4a6                	sd	s1,72(sp)
 4ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4b0:	0005c483          	lbu	s1,0(a1)
 4b4:	28048463          	beqz	s1,73c <vprintf+0x296>
 4b8:	e0ca                	sd	s2,64(sp)
 4ba:	fc4e                	sd	s3,56(sp)
 4bc:	f852                	sd	s4,48(sp)
 4be:	f456                	sd	s5,40(sp)
 4c0:	f05a                	sd	s6,32(sp)
 4c2:	ec5e                	sd	s7,24(sp)
 4c4:	e862                	sd	s8,16(sp)
 4c6:	e466                	sd	s9,8(sp)
 4c8:	8b2a                	mv	s6,a0
 4ca:	8a2e                	mv	s4,a1
 4cc:	8bb2                	mv	s7,a2
  state = 0;
 4ce:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4d0:	4901                	li	s2,0
 4d2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4dc:	06c00c93          	li	s9,108
 4e0:	a00d                	j	502 <vprintf+0x5c>
        putc(fd, c0);
 4e2:	85a6                	mv	a1,s1
 4e4:	855a                	mv	a0,s6
 4e6:	f11ff0ef          	jal	3f6 <putc>
 4ea:	a019                	j	4f0 <vprintf+0x4a>
    } else if (state == '%') {
 4ec:	03598363          	beq	s3,s5,512 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 4f0:	0019079b          	addiw	a5,s2,1
 4f4:	893e                	mv	s2,a5
 4f6:	873e                	mv	a4,a5
 4f8:	97d2                	add	a5,a5,s4
 4fa:	0007c483          	lbu	s1,0(a5)
 4fe:	22048763          	beqz	s1,72c <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 502:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 506:	fe0993e3          	bnez	s3,4ec <vprintf+0x46>
      if (c0 == '%') {
 50a:	fd579ce3          	bne	a5,s5,4e2 <vprintf+0x3c>
        state = '%';
 50e:	89be                	mv	s3,a5
 510:	b7c5                	j	4f0 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 512:	00ea06b3          	add	a3,s4,a4
 516:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 51a:	8636                	mv	a2,a3
      if (c1)
 51c:	c681                	beqz	a3,524 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 51e:	9752                	add	a4,a4,s4
 520:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 524:	05878263          	beq	a5,s8,568 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 528:	05978c63          	beq	a5,s9,580 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 52c:	07500713          	li	a4,117
 530:	0ee78663          	beq	a5,a4,61c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 534:	07800713          	li	a4,120
 538:	12e78863          	beq	a5,a4,668 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 53c:	07000713          	li	a4,112
 540:	14e78d63          	beq	a5,a4,69a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 544:	06300713          	li	a4,99
 548:	18e78c63          	beq	a5,a4,6e0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 54c:	07300713          	li	a4,115
 550:	1ae78263          	beq	a5,a4,6f4 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 554:	02500713          	li	a4,37
 558:	04e79463          	bne	a5,a4,5a0 <vprintf+0xfa>
        putc(fd, '%');
 55c:	85ba                	mv	a1,a4
 55e:	855a                	mv	a0,s6
 560:	e97ff0ef          	jal	3f6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 564:	4981                	li	s3,0
 566:	b769                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 568:	008b8493          	addi	s1,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e9fff0ef          	jal	414 <printint>
 57a:	8ba6                	mv	s7,s1
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bf8d                	j	4f0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 580:	06400793          	li	a5,100
 584:	02f68963          	beq	a3,a5,5b6 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 588:	06c00793          	li	a5,108
 58c:	04f68263          	beq	a3,a5,5d0 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 590:	07500793          	li	a5,117
 594:	0af68063          	beq	a3,a5,634 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 598:	07800793          	li	a5,120
 59c:	0ef68263          	beq	a3,a5,680 <vprintf+0x1da>
        putc(fd, '%');
 5a0:	02500593          	li	a1,37
 5a4:	855a                	mv	a0,s6
 5a6:	e51ff0ef          	jal	3f6 <putc>
        putc(fd, c0);
 5aa:	85a6                	mv	a1,s1
 5ac:	855a                	mv	a0,s6
 5ae:	e49ff0ef          	jal	3f6 <putc>
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bf35                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e51ff0ef          	jal	414 <printint>
        i += 1;
 5c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	b70d                	j	4f0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5d0:	06400793          	li	a5,100
 5d4:	02f60763          	beq	a2,a5,602 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5d8:	07500793          	li	a5,117
 5dc:	06f60963          	beq	a2,a5,64e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5e0:	07800793          	li	a5,120
 5e4:	faf61ee3          	bne	a2,a5,5a0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e1fff0ef          	jal	414 <printint>
        i += 2;
 5fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	bdc5                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e05ff0ef          	jal	414 <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bdd9                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000be583          	lwu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	debff0ef          	jal	414 <printint>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	bd7d                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	dd3ff0ef          	jal	414 <printint>
        i += 1;
 646:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8ba6                	mv	s7,s1
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b555                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8493          	addi	s1,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	db9ff0ef          	jal	414 <printint>
        i += 2;
 660:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	8ba6                	mv	s7,s1
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	b569                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 668:	008b8493          	addi	s1,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000be583          	lwu	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	d9fff0ef          	jal	414 <printint>
 67a:	8ba6                	mv	s7,s1
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd8d                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	008b8493          	addi	s1,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d87ff0ef          	jal	414 <printint>
        i += 1;
 692:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
        i += 1;
 698:	bda1                	j	4f0 <vprintf+0x4a>
 69a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69c:	008b8d13          	addi	s10,s7,8
 6a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a4:	03000593          	li	a1,48
 6a8:	855a                	mv	a0,s6
 6aa:	d4dff0ef          	jal	3f6 <putc>
  putc(fd, 'x');
 6ae:	07800593          	li	a1,120
 6b2:	855a                	mv	a0,s6
 6b4:	d43ff0ef          	jal	3f6 <putc>
 6b8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ba:	00000b97          	auipc	s7,0x0
 6be:	2a6b8b93          	addi	s7,s7,678 # 960 <digits>
 6c2:	03c9d793          	srli	a5,s3,0x3c
 6c6:	97de                	add	a5,a5,s7
 6c8:	0007c583          	lbu	a1,0(a5)
 6cc:	855a                	mv	a0,s6
 6ce:	d29ff0ef          	jal	3f6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d2:	0992                	slli	s3,s3,0x4
 6d4:	34fd                	addiw	s1,s1,-1
 6d6:	f4f5                	bnez	s1,6c2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6d8:	8bea                	mv	s7,s10
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	6d02                	ld	s10,0(sp)
 6de:	bd09                	j	4f0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6e0:	008b8493          	addi	s1,s7,8
 6e4:	000bc583          	lbu	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	d0dff0ef          	jal	3f6 <putc>
 6ee:	8ba6                	mv	s7,s1
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bbfd                	j	4f0 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6f4:	008b8993          	addi	s3,s7,8
 6f8:	000bb483          	ld	s1,0(s7)
 6fc:	cc91                	beqz	s1,718 <vprintf+0x272>
        for (; *s; s++)
 6fe:	0004c583          	lbu	a1,0(s1)
 702:	c195                	beqz	a1,726 <vprintf+0x280>
          putc(fd, *s);
 704:	855a                	mv	a0,s6
 706:	cf1ff0ef          	jal	3f6 <putc>
        for (; *s; s++)
 70a:	0485                	addi	s1,s1,1
 70c:	0004c583          	lbu	a1,0(s1)
 710:	f9f5                	bnez	a1,704 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	bbe9                	j	4f0 <vprintf+0x4a>
          s = "(null)";
 718:	00000497          	auipc	s1,0x0
 71c:	24048493          	addi	s1,s1,576 # 958 <malloc+0x130>
        for (; *s; s++)
 720:	02800593          	li	a1,40
 724:	b7c5                	j	704 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 726:	8bce                	mv	s7,s3
      state = 0;
 728:	4981                	li	s3,0
 72a:	b3d9                	j	4f0 <vprintf+0x4a>
 72c:	6906                	ld	s2,64(sp)
 72e:	79e2                	ld	s3,56(sp)
 730:	7a42                	ld	s4,48(sp)
 732:	7aa2                	ld	s5,40(sp)
 734:	7b02                	ld	s6,32(sp)
 736:	6be2                	ld	s7,24(sp)
 738:	6c42                	ld	s8,16(sp)
 73a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 73c:	60e6                	ld	ra,88(sp)
 73e:	6446                	ld	s0,80(sp)
 740:	64a6                	ld	s1,72(sp)
 742:	6125                	addi	sp,sp,96
 744:	8082                	ret

0000000000000746 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 746:	715d                	addi	sp,sp,-80
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e010                	sd	a2,0(s0)
 750:	e414                	sd	a3,8(s0)
 752:	e818                	sd	a4,16(s0)
 754:	ec1c                	sd	a5,24(s0)
 756:	03043023          	sd	a6,32(s0)
 75a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	8622                	mv	a2,s0
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	d43ff0ef          	jal	4a6 <vprintf>
}
 768:	60e2                	ld	ra,24(sp)
 76a:	6442                	ld	s0,16(sp)
 76c:	6161                	addi	sp,sp,80
 76e:	8082                	ret

0000000000000770 <printf>:

void
printf(const char *fmt, ...)
{
 770:	711d                	addi	sp,sp,-96
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e40c                	sd	a1,8(s0)
 77a:	e810                	sd	a2,16(s0)
 77c:	ec14                	sd	a3,24(s0)
 77e:	f018                	sd	a4,32(s0)
 780:	f41c                	sd	a5,40(s0)
 782:	03043823          	sd	a6,48(s0)
 786:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78a:	00840613          	addi	a2,s0,8
 78e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 792:	85aa                	mv	a1,a0
 794:	4505                	li	a0,1
 796:	d11ff0ef          	jal	4a6 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a2:	1141                	addi	sp,sp,-16
 7a4:	e406                	sd	ra,8(sp)
 7a6:	e022                	sd	s0,0(sp)
 7a8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7aa:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	00001797          	auipc	a5,0x1
 7b2:	8527b783          	ld	a5,-1966(a5) # 1000 <freep>
 7b6:	a02d                	j	7e0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7b8:	4618                	lw	a4,8(a2)
 7ba:	9f2d                	addw	a4,a4,a1
 7bc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	6398                	ld	a4,0(a5)
 7c2:	6310                	ld	a2,0(a4)
 7c4:	a83d                	j	802 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7c6:	ff852703          	lw	a4,-8(a0)
 7ca:	9f31                	addw	a4,a4,a2
 7cc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ce:	ff053683          	ld	a3,-16(a0)
 7d2:	a091                	j	816 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e7e463          	bltu	a5,a4,7de <free+0x3c>
 7da:	00e6ea63          	bltu	a3,a4,7ee <free+0x4c>
{
 7de:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	fed7fae3          	bgeu	a5,a3,7d4 <free+0x32>
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e6e463          	bltu	a3,a4,7ee <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	fee7eae3          	bltu	a5,a4,7de <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7ee:	ff852583          	lw	a1,-8(a0)
 7f2:	6390                	ld	a2,0(a5)
 7f4:	02059813          	slli	a6,a1,0x20
 7f8:	01c85713          	srli	a4,a6,0x1c
 7fc:	9736                	add	a4,a4,a3
 7fe:	fae60de3          	beq	a2,a4,7b8 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 806:	4790                	lw	a2,8(a5)
 808:	02061593          	slli	a1,a2,0x20
 80c:	01c5d713          	srli	a4,a1,0x1c
 810:	973e                	add	a4,a4,a5
 812:	fae68ae3          	beq	a3,a4,7c6 <free+0x24>
    p->s.ptr = bp->s.ptr;
 816:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
}
 820:	60a2                	ld	ra,8(sp)
 822:	6402                	ld	s0,0(sp)
 824:	0141                	addi	sp,sp,16
 826:	8082                	ret

0000000000000828 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 828:	7139                	addi	sp,sp,-64
 82a:	fc06                	sd	ra,56(sp)
 82c:	f822                	sd	s0,48(sp)
 82e:	f04a                	sd	s2,32(sp)
 830:	ec4e                	sd	s3,24(sp)
 832:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 834:	02051993          	slli	s3,a0,0x20
 838:	0209d993          	srli	s3,s3,0x20
 83c:	09bd                	addi	s3,s3,15
 83e:	0049d993          	srli	s3,s3,0x4
 842:	2985                	addiw	s3,s3,1
 844:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 846:	00000517          	auipc	a0,0x0
 84a:	7ba53503          	ld	a0,1978(a0) # 1000 <freep>
 84e:	c905                	beqz	a0,87e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 850:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 852:	4798                	lw	a4,8(a5)
 854:	09377663          	bgeu	a4,s3,8e0 <malloc+0xb8>
 858:	f426                	sd	s1,40(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 860:	8a4e                	mv	s4,s3
 862:	6705                	lui	a4,0x1
 864:	00e9f363          	bgeu	s3,a4,86a <malloc+0x42>
 868:	6a05                	lui	s4,0x1
 86a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 86e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 872:	00000497          	auipc	s1,0x0
 876:	78e48493          	addi	s1,s1,1934 # 1000 <freep>
  if (p == SBRK_ERROR)
 87a:	5afd                	li	s5,-1
 87c:	a83d                	j	8ba <malloc+0x92>
 87e:	f426                	sd	s1,40(sp)
 880:	e852                	sd	s4,16(sp)
 882:	e456                	sd	s5,8(sp)
 884:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 886:	00000797          	auipc	a5,0x0
 88a:	78a78793          	addi	a5,a5,1930 # 1010 <base>
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
 896:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 898:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 89c:	b7d1                	j	860 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	e118                	sd	a4,0(a0)
 8a2:	a899                	j	8f8 <malloc+0xd0>
  hp->s.size = nu;
 8a4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8a8:	0541                	addi	a0,a0,16
 8aa:	ef9ff0ef          	jal	7a2 <free>
  return freep;
 8ae:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8b0:	c125                	beqz	a0,910 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8b2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8b4:	4798                	lw	a4,8(a5)
 8b6:	03277163          	bgeu	a4,s2,8d8 <malloc+0xb0>
    if (p == freep)
 8ba:	6098                	ld	a4,0(s1)
 8bc:	853e                	mv	a0,a5
 8be:	fef71ae3          	bne	a4,a5,8b2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8c2:	8552                	mv	a0,s4
 8c4:	a37ff0ef          	jal	2fa <sbrk>
  if (p == SBRK_ERROR)
 8c8:	fd551ee3          	bne	a0,s5,8a4 <malloc+0x7c>
        return 0;
 8cc:	4501                	li	a0,0
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	a03d                	j	904 <malloc+0xdc>
 8d8:	74a2                	ld	s1,40(sp)
 8da:	6a42                	ld	s4,16(sp)
 8dc:	6aa2                	ld	s5,8(sp)
 8de:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e0:	fae90fe3          	beq	s2,a4,89e <malloc+0x76>
        p->s.size -= nunits;
 8e4:	4137073b          	subw	a4,a4,s3
 8e8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ea:	02071693          	slli	a3,a4,0x20
 8ee:	01c6d713          	srli	a4,a3,0x1c
 8f2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8f4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70a73423          	sd	a0,1800(a4) # 1000 <freep>
      return (void *)(p + 1);
 900:	01078513          	addi	a0,a5,16
  }
}
 904:	70e2                	ld	ra,56(sp)
 906:	7442                	ld	s0,48(sp)
 908:	7902                	ld	s2,32(sp)
 90a:	69e2                	ld	s3,24(sp)
 90c:	6121                	addi	sp,sp,64
 90e:	8082                	ret
 910:	74a2                	ld	s1,40(sp)
 912:	6a42                	ld	s4,16(sp)
 914:	6aa2                	ld	s5,8(sp)
 916:	6b02                	ld	s6,0(sp)
 918:	b7f5                	j	904 <malloc+0xdc>
