
user/_setpriority:     file format elf64-littleriscv


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
  int pid;
  int priority;

  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
    printf("Usage: setpriority <pid> <priority>\n");
  12:	00001517          	auipc	a0,0x1
  16:	97e50513          	addi	a0,a0,-1666 # 990 <malloc+0xfc>
  1a:	7c2000ef          	jal	7dc <printf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	316000ef          	jal	336 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	e04a                	sd	s2,0(sp)
  28:	84ae                	mv	s1,a1
  }

  pid = atoi(argv[1]);
  2a:	6588                	ld	a0,8(a1)
  2c:	1dc000ef          	jal	208 <atoi>
  30:	892a                	mv	s2,a0
  priority = atoi(argv[2]);
  32:	6888                	ld	a0,16(s1)
  34:	1d4000ef          	jal	208 <atoi>
  38:	84aa                	mv	s1,a0

  if(setpriority(pid, priority) < 0){
  3a:	85aa                	mv	a1,a0
  3c:	854a                	mv	a0,s2
  3e:	3a8000ef          	jal	3e6 <setpriority>
  42:	00054d63          	bltz	a0,5c <main+0x5c>
    printf("setpriority: failed\n");
    exit(1);
  }

  printf("Process %d priority set to %d\n", pid, priority);
  46:	8626                	mv	a2,s1
  48:	85ca                	mv	a1,s2
  4a:	00001517          	auipc	a0,0x1
  4e:	98650513          	addi	a0,a0,-1658 # 9d0 <malloc+0x13c>
  52:	78a000ef          	jal	7dc <printf>
  exit(0);
  56:	4501                	li	a0,0
  58:	2de000ef          	jal	336 <exit>
    printf("setpriority: failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	95c50513          	addi	a0,a0,-1700 # 9b8 <malloc+0x124>
  64:	778000ef          	jal	7dc <printf>
    exit(1);
  68:	4505                	li	a0,1
  6a:	2cc000ef          	jal	336 <exit>

000000000000006e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  6e:	1141                	addi	sp,sp,-16
  70:	e406                	sd	ra,8(sp)
  72:	e022                	sd	s0,0(sp)
  74:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  76:	f8bff0ef          	jal	0 <main>
  exit(r);
  7a:	2bc000ef          	jal	336 <exit>

000000000000007e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  86:	87aa                	mv	a5,a0
  88:	0585                	addi	a1,a1,1
  8a:	0785                	addi	a5,a5,1
  8c:	fff5c703          	lbu	a4,-1(a1)
  90:	fee78fa3          	sb	a4,-1(a5)
  94:	fb75                	bnez	a4,88 <strcpy+0xa>
    ;
  return os;
}
  96:	60a2                	ld	ra,8(sp)
  98:	6402                	ld	s0,0(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  a6:	00054783          	lbu	a5,0(a0)
  aa:	cb91                	beqz	a5,be <strcmp+0x20>
  ac:	0005c703          	lbu	a4,0(a1)
  b0:	00f71763          	bne	a4,a5,be <strcmp+0x20>
    p++, q++;
  b4:	0505                	addi	a0,a0,1
  b6:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b8:	00054783          	lbu	a5,0(a0)
  bc:	fbe5                	bnez	a5,ac <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  be:	0005c503          	lbu	a0,0(a1)
}
  c2:	40a7853b          	subw	a0,a5,a0
  c6:	60a2                	ld	ra,8(sp)
  c8:	6402                	ld	s0,0(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret

00000000000000ce <strlen>:

uint
strlen(const char *s)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  d6:	00054783          	lbu	a5,0(a0)
  da:	cf99                	beqz	a5,f8 <strlen+0x2a>
  dc:	0505                	addi	a0,a0,1
  de:	87aa                	mv	a5,a0
  e0:	86be                	mv	a3,a5
  e2:	0785                	addi	a5,a5,1
  e4:	fff7c703          	lbu	a4,-1(a5)
  e8:	ff65                	bnez	a4,e0 <strlen+0x12>
  ea:	40a6853b          	subw	a0,a3,a0
  ee:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  for (n = 0; s[n]; n++)
  f8:	4501                	li	a0,0
  fa:	bfdd                	j	f0 <strlen+0x22>

00000000000000fc <memset>:

void *
memset(void *dst, int c, uint n)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 104:	ca19                	beqz	a2,11a <memset+0x1e>
 106:	87aa                	mv	a5,a0
 108:	1602                	slli	a2,a2,0x20
 10a:	9201                	srli	a2,a2,0x20
 10c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 110:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 114:	0785                	addi	a5,a5,1
 116:	fee79de3          	bne	a5,a4,110 <memset+0x14>
  }
  return dst;
}
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strchr>:

char *
strchr(const char *s, char c)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  for (; *s; s++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf81                	beqz	a5,146 <strchr+0x24>
    if (*s == c)
 130:	00f58763          	beq	a1,a5,13e <strchr+0x1c>
  for (; *s; s++)
 134:	0505                	addi	a0,a0,1
 136:	00054783          	lbu	a5,0(a0)
 13a:	fbfd                	bnez	a5,130 <strchr+0xe>
      return (char *)s;
  return 0;
 13c:	4501                	li	a0,0
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  return 0;
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strchr+0x1c>

000000000000014a <gets>:

char *
gets(char *buf, int max)
{
 14a:	7159                	addi	sp,sp,-112
 14c:	f486                	sd	ra,104(sp)
 14e:	f0a2                	sd	s0,96(sp)
 150:	eca6                	sd	s1,88(sp)
 152:	e8ca                	sd	s2,80(sp)
 154:	e4ce                	sd	s3,72(sp)
 156:	e0d2                	sd	s4,64(sp)
 158:	fc56                	sd	s5,56(sp)
 15a:	f85a                	sd	s6,48(sp)
 15c:	f45e                	sd	s7,40(sp)
 15e:	f062                	sd	s8,32(sp)
 160:	ec66                	sd	s9,24(sp)
 162:	e86a                	sd	s10,16(sp)
 164:	1880                	addi	s0,sp,112
 166:	8caa                	mv	s9,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 16e:	f9f40b13          	addi	s6,s0,-97
 172:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 174:	4ba9                	li	s7,10
 176:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 178:	8d26                	mv	s10,s1
 17a:	0014899b          	addiw	s3,s1,1
 17e:	84ce                	mv	s1,s3
 180:	0349d563          	bge	s3,s4,1aa <gets+0x60>
    cc = read(0, &c, 1);
 184:	8656                	mv	a2,s5
 186:	85da                	mv	a1,s6
 188:	4501                	li	a0,0
 18a:	1c4000ef          	jal	34e <read>
    if (cc < 1)
 18e:	00a05e63          	blez	a0,1aa <gets+0x60>
    buf[i++] = c;
 192:	f9f44783          	lbu	a5,-97(s0)
 196:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 19a:	01778763          	beq	a5,s7,1a8 <gets+0x5e>
 19e:	0905                	addi	s2,s2,1
 1a0:	fd879ce3          	bne	a5,s8,178 <gets+0x2e>
    buf[i++] = c;
 1a4:	8d4e                	mv	s10,s3
 1a6:	a011                	j	1aa <gets+0x60>
 1a8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1aa:	9d66                	add	s10,s10,s9
 1ac:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1b0:	8566                	mv	a0,s9
 1b2:	70a6                	ld	ra,104(sp)
 1b4:	7406                	ld	s0,96(sp)
 1b6:	64e6                	ld	s1,88(sp)
 1b8:	6946                	ld	s2,80(sp)
 1ba:	69a6                	ld	s3,72(sp)
 1bc:	6a06                	ld	s4,64(sp)
 1be:	7ae2                	ld	s5,56(sp)
 1c0:	7b42                	ld	s6,48(sp)
 1c2:	7ba2                	ld	s7,40(sp)
 1c4:	7c02                	ld	s8,32(sp)
 1c6:	6ce2                	ld	s9,24(sp)
 1c8:	6d42                	ld	s10,16(sp)
 1ca:	6165                	addi	sp,sp,112
 1cc:	8082                	ret

00000000000001ce <stat>:

int
stat(const char *n, struct stat *st)
{
 1ce:	1101                	addi	sp,sp,-32
 1d0:	ec06                	sd	ra,24(sp)
 1d2:	e822                	sd	s0,16(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	4581                	li	a1,0
 1dc:	19a000ef          	jal	376 <open>
  if (fd < 0)
 1e0:	02054263          	bltz	a0,204 <stat+0x36>
 1e4:	e426                	sd	s1,8(sp)
 1e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	1a4000ef          	jal	38e <fstat>
 1ee:	892a                	mv	s2,a0
  close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	16c000ef          	jal	35e <close>
  return r;
 1f6:	64a2                	ld	s1,8(sp)
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	597d                	li	s2,-1
 206:	bfcd                	j	1f8 <stat+0x2a>

0000000000000208 <atoi>:

int
atoi(const char *s)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e406                	sd	ra,8(sp)
 20c:	e022                	sd	s0,0(sp)
 20e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 210:	00054683          	lbu	a3,0(a0)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	4625                	li	a2,9
 21e:	02f66963          	bltu	a2,a5,250 <atoi+0x48>
 222:	872a                	mv	a4,a0
  n = 0;
 224:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 226:	0705                	addi	a4,a4,1
 228:	0025179b          	slliw	a5,a0,0x2
 22c:	9fa9                	addw	a5,a5,a0
 22e:	0017979b          	slliw	a5,a5,0x1
 232:	9fb5                	addw	a5,a5,a3
 234:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 238:	00074683          	lbu	a3,0(a4)
 23c:	fd06879b          	addiw	a5,a3,-48
 240:	0ff7f793          	zext.b	a5,a5
 244:	fef671e3          	bgeu	a2,a5,226 <atoi+0x1e>
  return n;
}
 248:	60a2                	ld	ra,8(sp)
 24a:	6402                	ld	s0,0(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
  n = 0;
 250:	4501                	li	a0,0
 252:	bfdd                	j	248 <atoi+0x40>

0000000000000254 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	addi	sp,sp,-16
 256:	e406                	sd	ra,8(sp)
 258:	e022                	sd	s0,0(sp)
 25a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25c:	02b57563          	bgeu	a0,a1,286 <memmove+0x32>
    while (n-- > 0)
 260:	00c05f63          	blez	a2,27e <memmove+0x2a>
 264:	1602                	slli	a2,a2,0x20
 266:	9201                	srli	a2,a2,0x20
 268:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26c:	872a                	mv	a4,a0
      *dst++ = *src++;
 26e:	0585                	addi	a1,a1,1
 270:	0705                	addi	a4,a4,1
 272:	fff5c683          	lbu	a3,-1(a1)
 276:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 27a:	fee79ae3          	bne	a5,a4,26e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret
    dst += n;
 286:	00c50733          	add	a4,a0,a2
    src += n;
 28a:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 28c:	fec059e3          	blez	a2,27e <memmove+0x2a>
 290:	fff6079b          	addiw	a5,a2,-1
 294:	1782                	slli	a5,a5,0x20
 296:	9381                	srli	a5,a5,0x20
 298:	fff7c793          	not	a5,a5
 29c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29e:	15fd                	addi	a1,a1,-1
 2a0:	177d                	addi	a4,a4,-1
 2a2:	0005c683          	lbu	a3,0(a1)
 2a6:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2aa:	fef71ae3          	bne	a4,a5,29e <memmove+0x4a>
 2ae:	bfc1                	j	27e <memmove+0x2a>

00000000000002b0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b8:	ca0d                	beqz	a2,2ea <memcmp+0x3a>
 2ba:	fff6069b          	addiw	a3,a2,-1
 2be:	1682                	slli	a3,a3,0x20
 2c0:	9281                	srli	a3,a3,0x20
 2c2:	0685                	addi	a3,a3,1
 2c4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00e79863          	bne	a5,a4,2de <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2d2:	0505                	addi	a0,a0,1
    p2++;
 2d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d6:	fed518e3          	bne	a0,a3,2c6 <memcmp+0x16>
  }
  return 0;
 2da:	4501                	li	a0,0
 2dc:	a019                	j	2e2 <memcmp+0x32>
      return *p1 - *p2;
 2de:	40e7853b          	subw	a0,a5,a4
}
 2e2:	60a2                	ld	ra,8(sp)
 2e4:	6402                	ld	s0,0(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret
  return 0;
 2ea:	4501                	li	a0,0
 2ec:	bfdd                	j	2e2 <memcmp+0x32>

00000000000002ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f6:	f5fff0ef          	jal	254 <memmove>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrk>:

char *
sbrk(int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 30a:	4585                	li	a1,1
 30c:	0b2000ef          	jal	3be <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <sbrklazy>:

char *
sbrklazy(int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e406                	sd	ra,8(sp)
 31c:	e022                	sd	s0,0(sp)
 31e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 320:	4589                	li	a1,2
 322:	09c000ef          	jal	3be <sys_sbrk>
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32e:	4885                	li	a7,1
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <exit>:
.global exit
exit:
 li a7, SYS_exit
 336:	4889                	li	a7,2
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <wait>:
.global wait
wait:
 li a7, SYS_wait
 33e:	488d                	li	a7,3
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 346:	4891                	li	a7,4
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <read>:
.global read
read:
 li a7, SYS_read
 34e:	4895                	li	a7,5
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <write>:
.global write
write:
 li a7, SYS_write
 356:	48c1                	li	a7,16
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <close>:
.global close
close:
 li a7, SYS_close
 35e:	48d5                	li	a7,21
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <kill>:
.global kill
kill:
 li a7, SYS_kill
 366:	4899                	li	a7,6
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <exec>:
.global exec
exec:
 li a7, SYS_exec
 36e:	489d                	li	a7,7
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <open>:
.global open
open:
 li a7, SYS_open
 376:	48bd                	li	a7,15
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37e:	48c5                	li	a7,17
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 386:	48c9                	li	a7,18
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38e:	48a1                	li	a7,8
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <link>:
.global link
link:
 li a7, SYS_link
 396:	48cd                	li	a7,19
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39e:	48d1                	li	a7,20
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a6:	48a5                	li	a7,9
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ae:	48a9                	li	a7,10
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b6:	48ad                	li	a7,11
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3be:	48b1                	li	a7,12
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c6:	48b5                	li	a7,13
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ce:	48b9                	li	a7,14
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3d6:	48d9                	li	a7,22
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <ps>:
.global ps
ps:
 li a7, SYS_ps
 3de:	48dd                	li	a7,23
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3e6:	48e1                	li	a7,24
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3ee:	48e5                	li	a7,25
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3f6:	48e9                	li	a7,26
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <trace>:
.global trace
trace:
 li a7, SYS_trace
 3fe:	48ed                	li	a7,27
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 406:	48f1                	li	a7,28
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 40e:	48f5                	li	a7,29
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 416:	48f9                	li	a7,30
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 41e:	48fd                	li	a7,31
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 426:	02000893          	li	a7,32
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <halt>:
.global halt
halt:
 li a7, SYS_halt
 430:	02100893          	li	a7,33
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 43a:	02200893          	li	a7,34
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 444:	02300893          	li	a7,35
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 44e:	02400893          	li	a7,36
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 458:	02500893          	li	a7,37
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 462:	1101                	addi	sp,sp,-32
 464:	ec06                	sd	ra,24(sp)
 466:	e822                	sd	s0,16(sp)
 468:	1000                	addi	s0,sp,32
 46a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46e:	4605                	li	a2,1
 470:	fef40593          	addi	a1,s0,-17
 474:	ee3ff0ef          	jal	356 <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 480:	715d                	addi	sp,sp,-80
 482:	e486                	sd	ra,72(sp)
 484:	e0a2                	sd	s0,64(sp)
 486:	fc26                	sd	s1,56(sp)
 488:	f84a                	sd	s2,48(sp)
 48a:	f44e                	sd	s3,40(sp)
 48c:	0880                	addi	s0,sp,80
 48e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 490:	c299                	beqz	a3,496 <printint+0x16>
 492:	0605cc63          	bltz	a1,50a <printint+0x8a>
  neg = 0;
 496:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 498:	fb840313          	addi	t1,s0,-72
  neg = 0;
 49c:	869a                	mv	a3,t1
  i = 0;
 49e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4a0:	00000817          	auipc	a6,0x0
 4a4:	55880813          	addi	a6,a6,1368 # 9f8 <digits>
 4a8:	88be                	mv	a7,a5
 4aa:	0017851b          	addiw	a0,a5,1
 4ae:	87aa                	mv	a5,a0
 4b0:	02c5f733          	remu	a4,a1,a2
 4b4:	9742                	add	a4,a4,a6
 4b6:	00074703          	lbu	a4,0(a4)
 4ba:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4be:	872e                	mv	a4,a1
 4c0:	02c5d5b3          	divu	a1,a1,a2
 4c4:	0685                	addi	a3,a3,1
 4c6:	fec771e3          	bgeu	a4,a2,4a8 <printint+0x28>
  if (neg)
 4ca:	000e0c63          	beqz	t3,4e2 <printint+0x62>
    buf[i++] = '-';
 4ce:	fd050793          	addi	a5,a0,-48
 4d2:	00878533          	add	a0,a5,s0
 4d6:	02d00793          	li	a5,45
 4da:	fef50423          	sb	a5,-24(a0)
 4de:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4e2:	fff7899b          	addiw	s3,a5,-1
 4e6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4ea:	fff4c583          	lbu	a1,-1(s1)
 4ee:	854a                	mv	a0,s2
 4f0:	f73ff0ef          	jal	462 <putc>
  while (--i >= 0)
 4f4:	39fd                	addiw	s3,s3,-1
 4f6:	14fd                	addi	s1,s1,-1
 4f8:	fe09d9e3          	bgez	s3,4ea <printint+0x6a>
}
 4fc:	60a6                	ld	ra,72(sp)
 4fe:	6406                	ld	s0,64(sp)
 500:	74e2                	ld	s1,56(sp)
 502:	7942                	ld	s2,48(sp)
 504:	79a2                	ld	s3,40(sp)
 506:	6161                	addi	sp,sp,80
 508:	8082                	ret
    x = -xx;
 50a:	40b005b3          	neg	a1,a1
    neg = 1;
 50e:	4e05                	li	t3,1
    x = -xx;
 510:	b761                	j	498 <printint+0x18>

0000000000000512 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 512:	711d                	addi	sp,sp,-96
 514:	ec86                	sd	ra,88(sp)
 516:	e8a2                	sd	s0,80(sp)
 518:	e4a6                	sd	s1,72(sp)
 51a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 51c:	0005c483          	lbu	s1,0(a1)
 520:	28048463          	beqz	s1,7a8 <vprintf+0x296>
 524:	e0ca                	sd	s2,64(sp)
 526:	fc4e                	sd	s3,56(sp)
 528:	f852                	sd	s4,48(sp)
 52a:	f456                	sd	s5,40(sp)
 52c:	f05a                	sd	s6,32(sp)
 52e:	ec5e                	sd	s7,24(sp)
 530:	e862                	sd	s8,16(sp)
 532:	e466                	sd	s9,8(sp)
 534:	8b2a                	mv	s6,a0
 536:	8a2e                	mv	s4,a1
 538:	8bb2                	mv	s7,a2
  state = 0;
 53a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 53c:	4901                	li	s2,0
 53e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 540:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 544:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 548:	06c00c93          	li	s9,108
 54c:	a00d                	j	56e <vprintf+0x5c>
        putc(fd, c0);
 54e:	85a6                	mv	a1,s1
 550:	855a                	mv	a0,s6
 552:	f11ff0ef          	jal	462 <putc>
 556:	a019                	j	55c <vprintf+0x4a>
    } else if (state == '%') {
 558:	03598363          	beq	s3,s5,57e <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 55c:	0019079b          	addiw	a5,s2,1
 560:	893e                	mv	s2,a5
 562:	873e                	mv	a4,a5
 564:	97d2                	add	a5,a5,s4
 566:	0007c483          	lbu	s1,0(a5)
 56a:	22048763          	beqz	s1,798 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 56e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 572:	fe0993e3          	bnez	s3,558 <vprintf+0x46>
      if (c0 == '%') {
 576:	fd579ce3          	bne	a5,s5,54e <vprintf+0x3c>
        state = '%';
 57a:	89be                	mv	s3,a5
 57c:	b7c5                	j	55c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 57e:	00ea06b3          	add	a3,s4,a4
 582:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 586:	8636                	mv	a2,a3
      if (c1)
 588:	c681                	beqz	a3,590 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 58a:	9752                	add	a4,a4,s4
 58c:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 590:	05878263          	beq	a5,s8,5d4 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 594:	05978c63          	beq	a5,s9,5ec <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 598:	07500713          	li	a4,117
 59c:	0ee78663          	beq	a5,a4,688 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5a0:	07800713          	li	a4,120
 5a4:	12e78863          	beq	a5,a4,6d4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5a8:	07000713          	li	a4,112
 5ac:	14e78d63          	beq	a5,a4,706 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5b0:	06300713          	li	a4,99
 5b4:	18e78c63          	beq	a5,a4,74c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5b8:	07300713          	li	a4,115
 5bc:	1ae78263          	beq	a5,a4,760 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5c0:	02500713          	li	a4,37
 5c4:	04e79463          	bne	a5,a4,60c <vprintf+0xfa>
        putc(fd, '%');
 5c8:	85ba                	mv	a1,a4
 5ca:	855a                	mv	a0,s6
 5cc:	e97ff0ef          	jal	462 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b769                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4685                	li	a3,1
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	e9fff0ef          	jal	480 <printint>
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bf8d                	j	55c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5ec:	06400793          	li	a5,100
 5f0:	02f68963          	beq	a3,a5,622 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5f4:	06c00793          	li	a5,108
 5f8:	04f68263          	beq	a3,a5,63c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5fc:	07500793          	li	a5,117
 600:	0af68063          	beq	a3,a5,6a0 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 604:	07800793          	li	a5,120
 608:	0ef68263          	beq	a3,a5,6ec <vprintf+0x1da>
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	855a                	mv	a0,s6
 612:	e51ff0ef          	jal	462 <putc>
        putc(fd, c0);
 616:	85a6                	mv	a1,s1
 618:	855a                	mv	a0,s6
 61a:	e49ff0ef          	jal	462 <putc>
      state = 0;
 61e:	4981                	li	s3,0
 620:	bf35                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	008b8493          	addi	s1,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e51ff0ef          	jal	480 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b70d                	j	55c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 63c:	06400793          	li	a5,100
 640:	02f60763          	beq	a2,a5,66e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 644:	07500793          	li	a5,117
 648:	06f60963          	beq	a2,a5,6ba <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 64c:	07800793          	li	a5,120
 650:	faf61ee3          	bne	a2,a5,60c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e1fff0ef          	jal	480 <printint>
        i += 2;
 666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bdc5                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	008b8493          	addi	s1,s7,8
 672:	4685                	li	a3,1
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	e05ff0ef          	jal	480 <printint>
        i += 2;
 680:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
        i += 2;
 686:	bdd9                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000be583          	lwu	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	debff0ef          	jal	480 <printint>
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
 69e:	bd7d                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8493          	addi	s1,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	dd3ff0ef          	jal	480 <printint>
        i += 1;
 6b2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
        i += 1;
 6b8:	b555                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	db9ff0ef          	jal	480 <printint>
        i += 2;
 6cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	b569                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4641                	li	a2,16
 6dc:	000be583          	lwu	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	d9fff0ef          	jal	480 <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bd8d                	j	55c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4641                	li	a2,16
 6f4:	000bb583          	ld	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	d87ff0ef          	jal	480 <printint>
        i += 1;
 6fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
        i += 1;
 704:	bda1                	j	55c <vprintf+0x4a>
 706:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 708:	008b8d13          	addi	s10,s7,8
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	855a                	mv	a0,s6
 716:	d4dff0ef          	jal	462 <putc>
  putc(fd, 'x');
 71a:	07800593          	li	a1,120
 71e:	855a                	mv	a0,s6
 720:	d43ff0ef          	jal	462 <putc>
 724:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	2d2b8b93          	addi	s7,s7,722 # 9f8 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	855a                	mv	a0,s6
 73a:	d29ff0ef          	jal	462 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	slli	s3,s3,0x4
 740:	34fd                	addiw	s1,s1,-1
 742:	f4f5                	bnez	s1,72e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 744:	8bea                	mv	s7,s10
      state = 0;
 746:	4981                	li	s3,0
 748:	6d02                	ld	s10,0(sp)
 74a:	bd09                	j	55c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 74c:	008b8493          	addi	s1,s7,8
 750:	000bc583          	lbu	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	d0dff0ef          	jal	462 <putc>
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbfd                	j	55c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 760:	008b8993          	addi	s3,s7,8
 764:	000bb483          	ld	s1,0(s7)
 768:	cc91                	beqz	s1,784 <vprintf+0x272>
        for (; *s; s++)
 76a:	0004c583          	lbu	a1,0(s1)
 76e:	c195                	beqz	a1,792 <vprintf+0x280>
          putc(fd, *s);
 770:	855a                	mv	a0,s6
 772:	cf1ff0ef          	jal	462 <putc>
        for (; *s; s++)
 776:	0485                	addi	s1,s1,1
 778:	0004c583          	lbu	a1,0(s1)
 77c:	f9f5                	bnez	a1,770 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	bbe9                	j	55c <vprintf+0x4a>
          s = "(null)";
 784:	00000497          	auipc	s1,0x0
 788:	26c48493          	addi	s1,s1,620 # 9f0 <malloc+0x15c>
        for (; *s; s++)
 78c:	02800593          	li	a1,40
 790:	b7c5                	j	770 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	b3d9                	j	55c <vprintf+0x4a>
 798:	6906                	ld	s2,64(sp)
 79a:	79e2                	ld	s3,56(sp)
 79c:	7a42                	ld	s4,48(sp)
 79e:	7aa2                	ld	s5,40(sp)
 7a0:	7b02                	ld	s6,32(sp)
 7a2:	6be2                	ld	s7,24(sp)
 7a4:	6c42                	ld	s8,16(sp)
 7a6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a8:	60e6                	ld	ra,88(sp)
 7aa:	6446                	ld	s0,80(sp)
 7ac:	64a6                	ld	s1,72(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b2:	715d                	addi	sp,sp,-80
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e010                	sd	a2,0(s0)
 7bc:	e414                	sd	a3,8(s0)
 7be:	e818                	sd	a4,16(s0)
 7c0:	ec1c                	sd	a5,24(s0)
 7c2:	03043023          	sd	a6,32(s0)
 7c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	8622                	mv	a2,s0
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	d43ff0ef          	jal	512 <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6161                	addi	sp,sp,80
 7da:	8082                	ret

00000000000007dc <printf>:

void
printf(const char *fmt, ...)
{
 7dc:	711d                	addi	sp,sp,-96
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e40c                	sd	a1,8(s0)
 7e6:	e810                	sd	a2,16(s0)
 7e8:	ec14                	sd	a3,24(s0)
 7ea:	f018                	sd	a4,32(s0)
 7ec:	f41c                	sd	a5,40(s0)
 7ee:	03043823          	sd	a6,48(s0)
 7f2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	00840613          	addi	a2,s0,8
 7fa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7fe:	85aa                	mv	a1,a0
 800:	4505                	li	a0,1
 802:	d11ff0ef          	jal	512 <vprintf>
}
 806:	60e2                	ld	ra,24(sp)
 808:	6442                	ld	s0,16(sp)
 80a:	6125                	addi	sp,sp,96
 80c:	8082                	ret

000000000000080e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 80e:	1141                	addi	sp,sp,-16
 810:	e406                	sd	ra,8(sp)
 812:	e022                	sd	s0,0(sp)
 814:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 816:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81a:	00000797          	auipc	a5,0x0
 81e:	7e67b783          	ld	a5,2022(a5) # 1000 <freep>
 822:	a02d                	j	84c <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 824:	4618                	lw	a4,8(a2)
 826:	9f2d                	addw	a4,a4,a1
 828:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82c:	6398                	ld	a4,0(a5)
 82e:	6310                	ld	a2,0(a4)
 830:	a83d                	j	86e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 832:	ff852703          	lw	a4,-8(a0)
 836:	9f31                	addw	a4,a4,a2
 838:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83a:	ff053683          	ld	a3,-16(a0)
 83e:	a091                	j	882 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x3c>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x4c>
{
 84a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x32>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	fae60de3          	beq	a2,a4,824 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	fae68ae3          	beq	a3,a4,832 <free+0x24>
    p->s.ptr = bp->s.ptr;
 882:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
}
 88c:	60a2                	ld	ra,8(sp)
 88e:	6402                	ld	s0,0(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret

0000000000000894 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 894:	7139                	addi	sp,sp,-64
 896:	fc06                	sd	ra,56(sp)
 898:	f822                	sd	s0,48(sp)
 89a:	f04a                	sd	s2,32(sp)
 89c:	ec4e                	sd	s3,24(sp)
 89e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8a0:	02051993          	slli	s3,a0,0x20
 8a4:	0209d993          	srli	s3,s3,0x20
 8a8:	09bd                	addi	s3,s3,15
 8aa:	0049d993          	srli	s3,s3,0x4
 8ae:	2985                	addiw	s3,s3,1
 8b0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8b2:	00000517          	auipc	a0,0x0
 8b6:	74e53503          	ld	a0,1870(a0) # 1000 <freep>
 8ba:	c905                	beqz	a0,8ea <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8bc:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8be:	4798                	lw	a4,8(a5)
 8c0:	09377663          	bgeu	a4,s3,94c <malloc+0xb8>
 8c4:	f426                	sd	s1,40(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8cc:	8a4e                	mv	s4,s3
 8ce:	6705                	lui	a4,0x1
 8d0:	00e9f363          	bgeu	s3,a4,8d6 <malloc+0x42>
 8d4:	6a05                	lui	s4,0x1
 8d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8de:	00000497          	auipc	s1,0x0
 8e2:	72248493          	addi	s1,s1,1826 # 1000 <freep>
  if (p == SBRK_ERROR)
 8e6:	5afd                	li	s5,-1
 8e8:	a83d                	j	926 <malloc+0x92>
 8ea:	f426                	sd	s1,40(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8f2:	00000797          	auipc	a5,0x0
 8f6:	71e78793          	addi	a5,a5,1822 # 1010 <base>
 8fa:	00000717          	auipc	a4,0x0
 8fe:	70f73323          	sd	a5,1798(a4) # 1000 <freep>
 902:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 904:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 908:	b7d1                	j	8cc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	e118                	sd	a4,0(a0)
 90e:	a899                	j	964 <malloc+0xd0>
  hp->s.size = nu;
 910:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 914:	0541                	addi	a0,a0,16
 916:	ef9ff0ef          	jal	80e <free>
  return freep;
 91a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 91c:	c125                	beqz	a0,97c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 91e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 920:	4798                	lw	a4,8(a5)
 922:	03277163          	bgeu	a4,s2,944 <malloc+0xb0>
    if (p == freep)
 926:	6098                	ld	a4,0(s1)
 928:	853e                	mv	a0,a5
 92a:	fef71ae3          	bne	a4,a5,91e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 92e:	8552                	mv	a0,s4
 930:	9d3ff0ef          	jal	302 <sbrk>
  if (p == SBRK_ERROR)
 934:	fd551ee3          	bne	a0,s5,910 <malloc+0x7c>
        return 0;
 938:	4501                	li	a0,0
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	a03d                	j	970 <malloc+0xdc>
 944:	74a2                	ld	s1,40(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 94c:	fae90fe3          	beq	s2,a4,90a <malloc+0x76>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	02071693          	slli	a3,a4,0x20
 95a:	01c6d713          	srli	a4,a3,0x1c
 95e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 960:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 964:	00000717          	auipc	a4,0x0
 968:	68a73e23          	sd	a0,1692(a4) # 1000 <freep>
      return (void *)(p + 1);
 96c:	01078513          	addi	a0,a5,16
  }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6121                	addi	sp,sp,64
 97a:	8082                	ret
 97c:	74a2                	ld	s1,40(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	b7f5                	j	970 <malloc+0xdc>
