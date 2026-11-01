
user/_cowtest:     file format elf64-littleriscv


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
  char *p;
  int pid1, pid2;

  p = sbrk(4096);
   8:	6505                	lui	a0,0x1
   a:	34c000ef          	jal	356 <sbrk>

  if(p == (char*)-1){
   e:	57fd                	li	a5,-1
  10:	02f50963          	beq	a0,a5,42 <main+0x42>
  14:	e426                	sd	s1,8(sp)
  16:	84aa                	mv	s1,a0
    printf("cowtest: sbrk failed\n");
    exit(1);
  }

  *p = 'A';
  18:	04100593          	li	a1,65
  1c:	00b50023          	sb	a1,0(a0) # 1000 <freep>

  printf("Original: %c\n", *p);
  20:	00001517          	auipc	a0,0x1
  24:	9e050513          	addi	a0,a0,-1568 # a00 <malloc+0x118>
  28:	009000ef          	jal	830 <printf>

  pid1 = fork();
  2c:	356000ef          	jal	382 <fork>

  if(pid1 < 0){
  30:	02054363          	bltz	a0,56 <main+0x56>
    printf("cowtest: first fork failed\n");
    exit(1);
  }

  if(pid1 == 0){
  34:	e915                	bnez	a0,68 <main+0x68>
    *p = 'B';
  36:	04200793          	li	a5,66
  3a:	00f48023          	sb	a5,0(s1)
    exit(0);
  3e:	34c000ef          	jal	38a <exit>
  42:	e426                	sd	s1,8(sp)
    printf("cowtest: sbrk failed\n");
  44:	00001517          	auipc	a0,0x1
  48:	99c50513          	addi	a0,a0,-1636 # 9e0 <malloc+0xf8>
  4c:	7e4000ef          	jal	830 <printf>
    exit(1);
  50:	4505                	li	a0,1
  52:	338000ef          	jal	38a <exit>
    printf("cowtest: first fork failed\n");
  56:	00001517          	auipc	a0,0x1
  5a:	9ba50513          	addi	a0,a0,-1606 # a10 <malloc+0x128>
  5e:	7d2000ef          	jal	830 <printf>
    exit(1);
  62:	4505                	li	a0,1
  64:	326000ef          	jal	38a <exit>
  }

  wait(0);
  68:	4501                	li	a0,0
  6a:	328000ef          	jal	392 <wait>
  printf("After child 1: %c\n", *p);
  6e:	0004c583          	lbu	a1,0(s1)
  72:	00001517          	auipc	a0,0x1
  76:	9be50513          	addi	a0,a0,-1602 # a30 <malloc+0x148>
  7a:	7b6000ef          	jal	830 <printf>

  pid2 = fork();
  7e:	304000ef          	jal	382 <fork>

  if(pid2 < 0){
  82:	00054963          	bltz	a0,94 <main+0x94>
    printf("cowtest: second fork failed\n");
    exit(1);
  }

  if(pid2 == 0){
  86:	e105                	bnez	a0,a6 <main+0xa6>
    *p = 'C';
  88:	04300793          	li	a5,67
  8c:	00f48023          	sb	a5,0(s1)
    exit(0);
  90:	2fa000ef          	jal	38a <exit>
    printf("cowtest: second fork failed\n");
  94:	00001517          	auipc	a0,0x1
  98:	9b450513          	addi	a0,a0,-1612 # a48 <malloc+0x160>
  9c:	794000ef          	jal	830 <printf>
    exit(1);
  a0:	4505                	li	a0,1
  a2:	2e8000ef          	jal	38a <exit>
  }

  wait(0);
  a6:	4501                	li	a0,0
  a8:	2ea000ef          	jal	392 <wait>
  printf("After child 2: %c\n", *p);
  ac:	0004c583          	lbu	a1,0(s1)
  b0:	00001517          	auipc	a0,0x1
  b4:	9b850513          	addi	a0,a0,-1608 # a68 <malloc+0x180>
  b8:	778000ef          	jal	830 <printf>

  exit(0);
  bc:	4501                	li	a0,0
  be:	2cc000ef          	jal	38a <exit>

00000000000000c2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ca:	f37ff0ef          	jal	0 <main>
  exit(r);
  ce:	2bc000ef          	jal	38a <exit>

00000000000000d2 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  da:	87aa                	mv	a5,a0
  dc:	0585                	addi	a1,a1,1
  de:	0785                	addi	a5,a5,1
  e0:	fff5c703          	lbu	a4,-1(a1)
  e4:	fee78fa3          	sb	a4,-1(a5)
  e8:	fb75                	bnez	a4,dc <strcpy+0xa>
    ;
  return os;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x20>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x20>
    p++, q++;
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	60a2                	ld	ra,8(sp)
 11c:	6402                	ld	s0,0(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	addi	sp,sp,-16
 124:	e406                	sd	ra,8(sp)
 126:	e022                	sd	s0,0(sp)
 128:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 12a:	00054783          	lbu	a5,0(a0)
 12e:	cf99                	beqz	a5,14c <strlen+0x2a>
 130:	0505                	addi	a0,a0,1
 132:	87aa                	mv	a5,a0
 134:	86be                	mv	a3,a5
 136:	0785                	addi	a5,a5,1
 138:	fff7c703          	lbu	a4,-1(a5)
 13c:	ff65                	bnez	a4,134 <strlen+0x12>
 13e:	40a6853b          	subw	a0,a3,a0
 142:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 144:	60a2                	ld	ra,8(sp)
 146:	6402                	ld	s0,0(sp)
 148:	0141                	addi	sp,sp,16
 14a:	8082                	ret
  for (n = 0; s[n]; n++)
 14c:	4501                	li	a0,0
 14e:	bfdd                	j	144 <strlen+0x22>

0000000000000150 <memset>:

void *
memset(void *dst, int c, uint n)
{
 150:	1141                	addi	sp,sp,-16
 152:	e406                	sd	ra,8(sp)
 154:	e022                	sd	s0,0(sp)
 156:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 158:	ca19                	beqz	a2,16e <memset+0x1e>
 15a:	87aa                	mv	a5,a0
 15c:	1602                	slli	a2,a2,0x20
 15e:	9201                	srli	a2,a2,0x20
 160:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 164:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 168:	0785                	addi	a5,a5,1
 16a:	fee79de3          	bne	a5,a4,164 <memset+0x14>
  }
  return dst;
}
 16e:	60a2                	ld	ra,8(sp)
 170:	6402                	ld	s0,0(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strchr>:

char *
strchr(const char *s, char c)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf81                	beqz	a5,19a <strchr+0x24>
    if (*s == c)
 184:	00f58763          	beq	a1,a5,192 <strchr+0x1c>
  for (; *s; s++)
 188:	0505                	addi	a0,a0,1
 18a:	00054783          	lbu	a5,0(a0)
 18e:	fbfd                	bnez	a5,184 <strchr+0xe>
      return (char *)s;
  return 0;
 190:	4501                	li	a0,0
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret
  return 0;
 19a:	4501                	li	a0,0
 19c:	bfdd                	j	192 <strchr+0x1c>

000000000000019e <gets>:

char *
gets(char *buf, int max)
{
 19e:	7159                	addi	sp,sp,-112
 1a0:	f486                	sd	ra,104(sp)
 1a2:	f0a2                	sd	s0,96(sp)
 1a4:	eca6                	sd	s1,88(sp)
 1a6:	e8ca                	sd	s2,80(sp)
 1a8:	e4ce                	sd	s3,72(sp)
 1aa:	e0d2                	sd	s4,64(sp)
 1ac:	fc56                	sd	s5,56(sp)
 1ae:	f85a                	sd	s6,48(sp)
 1b0:	f45e                	sd	s7,40(sp)
 1b2:	f062                	sd	s8,32(sp)
 1b4:	ec66                	sd	s9,24(sp)
 1b6:	e86a                	sd	s10,16(sp)
 1b8:	1880                	addi	s0,sp,112
 1ba:	8caa                	mv	s9,a0
 1bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1be:	892a                	mv	s2,a0
 1c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c2:	f9f40b13          	addi	s6,s0,-97
 1c6:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1c8:	4ba9                	li	s7,10
 1ca:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 1cc:	8d26                	mv	s10,s1
 1ce:	0014899b          	addiw	s3,s1,1
 1d2:	84ce                	mv	s1,s3
 1d4:	0349d563          	bge	s3,s4,1fe <gets+0x60>
    cc = read(0, &c, 1);
 1d8:	8656                	mv	a2,s5
 1da:	85da                	mv	a1,s6
 1dc:	4501                	li	a0,0
 1de:	1c4000ef          	jal	3a2 <read>
    if (cc < 1)
 1e2:	00a05e63          	blez	a0,1fe <gets+0x60>
    buf[i++] = c;
 1e6:	f9f44783          	lbu	a5,-97(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1ee:	01778763          	beq	a5,s7,1fc <gets+0x5e>
 1f2:	0905                	addi	s2,s2,1
 1f4:	fd879ce3          	bne	a5,s8,1cc <gets+0x2e>
    buf[i++] = c;
 1f8:	8d4e                	mv	s10,s3
 1fa:	a011                	j	1fe <gets+0x60>
 1fc:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1fe:	9d66                	add	s10,s10,s9
 200:	000d0023          	sb	zero,0(s10)
  return buf;
}
 204:	8566                	mv	a0,s9
 206:	70a6                	ld	ra,104(sp)
 208:	7406                	ld	s0,96(sp)
 20a:	64e6                	ld	s1,88(sp)
 20c:	6946                	ld	s2,80(sp)
 20e:	69a6                	ld	s3,72(sp)
 210:	6a06                	ld	s4,64(sp)
 212:	7ae2                	ld	s5,56(sp)
 214:	7b42                	ld	s6,48(sp)
 216:	7ba2                	ld	s7,40(sp)
 218:	7c02                	ld	s8,32(sp)
 21a:	6ce2                	ld	s9,24(sp)
 21c:	6d42                	ld	s10,16(sp)
 21e:	6165                	addi	sp,sp,112
 220:	8082                	ret

0000000000000222 <stat>:

int
stat(const char *n, struct stat *st)
{
 222:	1101                	addi	sp,sp,-32
 224:	ec06                	sd	ra,24(sp)
 226:	e822                	sd	s0,16(sp)
 228:	e04a                	sd	s2,0(sp)
 22a:	1000                	addi	s0,sp,32
 22c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22e:	4581                	li	a1,0
 230:	19a000ef          	jal	3ca <open>
  if (fd < 0)
 234:	02054263          	bltz	a0,258 <stat+0x36>
 238:	e426                	sd	s1,8(sp)
 23a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23c:	85ca                	mv	a1,s2
 23e:	1a4000ef          	jal	3e2 <fstat>
 242:	892a                	mv	s2,a0
  close(fd);
 244:	8526                	mv	a0,s1
 246:	16c000ef          	jal	3b2 <close>
  return r;
 24a:	64a2                	ld	s1,8(sp)
}
 24c:	854a                	mv	a0,s2
 24e:	60e2                	ld	ra,24(sp)
 250:	6442                	ld	s0,16(sp)
 252:	6902                	ld	s2,0(sp)
 254:	6105                	addi	sp,sp,32
 256:	8082                	ret
    return -1;
 258:	597d                	li	s2,-1
 25a:	bfcd                	j	24c <stat+0x2a>

000000000000025c <atoi>:

int
atoi(const char *s)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 264:	00054683          	lbu	a3,0(a0)
 268:	fd06879b          	addiw	a5,a3,-48
 26c:	0ff7f793          	zext.b	a5,a5
 270:	4625                	li	a2,9
 272:	02f66963          	bltu	a2,a5,2a4 <atoi+0x48>
 276:	872a                	mv	a4,a0
  n = 0;
 278:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 27a:	0705                	addi	a4,a4,1
 27c:	0025179b          	slliw	a5,a0,0x2
 280:	9fa9                	addw	a5,a5,a0
 282:	0017979b          	slliw	a5,a5,0x1
 286:	9fb5                	addw	a5,a5,a3
 288:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 28c:	00074683          	lbu	a3,0(a4)
 290:	fd06879b          	addiw	a5,a3,-48
 294:	0ff7f793          	zext.b	a5,a5
 298:	fef671e3          	bgeu	a2,a5,27a <atoi+0x1e>
  return n;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  n = 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <atoi+0x40>

00000000000002a8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b0:	02b57563          	bgeu	a0,a1,2da <memmove+0x32>
    while (n-- > 0)
 2b4:	00c05f63          	blez	a2,2d2 <memmove+0x2a>
 2b8:	1602                	slli	a2,a2,0x20
 2ba:	9201                	srli	a2,a2,0x20
 2bc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c0:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c2:	0585                	addi	a1,a1,1
 2c4:	0705                	addi	a4,a4,1
 2c6:	fff5c683          	lbu	a3,-1(a1)
 2ca:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2ce:	fee79ae3          	bne	a5,a4,2c2 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
    dst += n;
 2da:	00c50733          	add	a4,a0,a2
    src += n;
 2de:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2e0:	fec059e3          	blez	a2,2d2 <memmove+0x2a>
 2e4:	fff6079b          	addiw	a5,a2,-1
 2e8:	1782                	slli	a5,a5,0x20
 2ea:	9381                	srli	a5,a5,0x20
 2ec:	fff7c793          	not	a5,a5
 2f0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f2:	15fd                	addi	a1,a1,-1
 2f4:	177d                	addi	a4,a4,-1
 2f6:	0005c683          	lbu	a3,0(a1)
 2fa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2fe:	fef71ae3          	bne	a4,a5,2f2 <memmove+0x4a>
 302:	bfc1                	j	2d2 <memmove+0x2a>

0000000000000304 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 30c:	ca0d                	beqz	a2,33e <memcmp+0x3a>
 30e:	fff6069b          	addiw	a3,a2,-1
 312:	1682                	slli	a3,a3,0x20
 314:	9281                	srli	a3,a3,0x20
 316:	0685                	addi	a3,a3,1
 318:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 31a:	00054783          	lbu	a5,0(a0)
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00e79863          	bne	a5,a4,332 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 326:	0505                	addi	a0,a0,1
    p2++;
 328:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32a:	fed518e3          	bne	a0,a3,31a <memcmp+0x16>
  }
  return 0;
 32e:	4501                	li	a0,0
 330:	a019                	j	336 <memcmp+0x32>
      return *p1 - *p2;
 332:	40e7853b          	subw	a0,a5,a4
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <memcmp+0x32>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	f5fff0ef          	jal	2a8 <memmove>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <sbrk>:

char *
sbrk(int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35e:	4585                	li	a1,1
 360:	0b2000ef          	jal	412 <sys_sbrk>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <sbrklazy>:

char *
sbrklazy(int n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 374:	4589                	li	a1,2
 376:	09c000ef          	jal	412 <sys_sbrk>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 382:	4885                	li	a7,1
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exit>:
.global exit
exit:
 li a7, SYS_exit
 38a:	4889                	li	a7,2
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <wait>:
.global wait
wait:
 li a7, SYS_wait
 392:	488d                	li	a7,3
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39a:	4891                	li	a7,4
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <read>:
.global read
read:
 li a7, SYS_read
 3a2:	4895                	li	a7,5
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <write>:
.global write
write:
 li a7, SYS_write
 3aa:	48c1                	li	a7,16
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <close>:
.global close
close:
 li a7, SYS_close
 3b2:	48d5                	li	a7,21
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <open>:
.global open
open:
 li a7, SYS_open
 3ca:	48bd                	li	a7,15
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d2:	48c5                	li	a7,17
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3da:	48c9                	li	a7,18
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e2:	48a1                	li	a7,8
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <link>:
.global link
link:
 li a7, SYS_link
 3ea:	48cd                	li	a7,19
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f2:	48d1                	li	a7,20
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fa:	48a5                	li	a7,9
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <dup>:
.global dup
dup:
 li a7, SYS_dup
 402:	48a9                	li	a7,10
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40a:	48ad                	li	a7,11
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 412:	48b1                	li	a7,12
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <pause>:
.global pause
pause:
 li a7, SYS_pause
 41a:	48b5                	li	a7,13
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 422:	48b9                	li	a7,14
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sync>:
.global sync
sync:
 li a7, SYS_sync
 42a:	48d9                	li	a7,22
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <ps>:
.global ps
ps:
 li a7, SYS_ps
 432:	48dd                	li	a7,23
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 43a:	48e1                	li	a7,24
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 442:	48e5                	li	a7,25
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 44a:	48e9                	li	a7,26
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <trace>:
.global trace
trace:
 li a7, SYS_trace
 452:	48ed                	li	a7,27
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 45a:	48f1                	li	a7,28
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 462:	48f5                	li	a7,29
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 46a:	48f9                	li	a7,30
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 472:	48fd                	li	a7,31
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 47a:	02000893          	li	a7,32
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <halt>:
.global halt
halt:
 li a7, SYS_halt
 484:	02100893          	li	a7,33
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 48e:	02200893          	li	a7,34
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 498:	02300893          	li	a7,35
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 4a2:	02400893          	li	a7,36
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 4ac:	02500893          	li	a7,37
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b6:	1101                	addi	sp,sp,-32
 4b8:	ec06                	sd	ra,24(sp)
 4ba:	e822                	sd	s0,16(sp)
 4bc:	1000                	addi	s0,sp,32
 4be:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c2:	4605                	li	a2,1
 4c4:	fef40593          	addi	a1,s0,-17
 4c8:	ee3ff0ef          	jal	3aa <write>
}
 4cc:	60e2                	ld	ra,24(sp)
 4ce:	6442                	ld	s0,16(sp)
 4d0:	6105                	addi	sp,sp,32
 4d2:	8082                	ret

00000000000004d4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4d4:	715d                	addi	sp,sp,-80
 4d6:	e486                	sd	ra,72(sp)
 4d8:	e0a2                	sd	s0,64(sp)
 4da:	fc26                	sd	s1,56(sp)
 4dc:	f84a                	sd	s2,48(sp)
 4de:	f44e                	sd	s3,40(sp)
 4e0:	0880                	addi	s0,sp,80
 4e2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4e4:	c299                	beqz	a3,4ea <printint+0x16>
 4e6:	0605cc63          	bltz	a1,55e <printint+0x8a>
  neg = 0;
 4ea:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4ec:	fb840313          	addi	t1,s0,-72
  neg = 0;
 4f0:	869a                	mv	a3,t1
  i = 0;
 4f2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4f4:	00000817          	auipc	a6,0x0
 4f8:	59480813          	addi	a6,a6,1428 # a88 <digits>
 4fc:	88be                	mv	a7,a5
 4fe:	0017851b          	addiw	a0,a5,1
 502:	87aa                	mv	a5,a0
 504:	02c5f733          	remu	a4,a1,a2
 508:	9742                	add	a4,a4,a6
 50a:	00074703          	lbu	a4,0(a4)
 50e:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 512:	872e                	mv	a4,a1
 514:	02c5d5b3          	divu	a1,a1,a2
 518:	0685                	addi	a3,a3,1
 51a:	fec771e3          	bgeu	a4,a2,4fc <printint+0x28>
  if (neg)
 51e:	000e0c63          	beqz	t3,536 <printint+0x62>
    buf[i++] = '-';
 522:	fd050793          	addi	a5,a0,-48
 526:	00878533          	add	a0,a5,s0
 52a:	02d00793          	li	a5,45
 52e:	fef50423          	sb	a5,-24(a0)
 532:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 536:	fff7899b          	addiw	s3,a5,-1
 53a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 53e:	fff4c583          	lbu	a1,-1(s1)
 542:	854a                	mv	a0,s2
 544:	f73ff0ef          	jal	4b6 <putc>
  while (--i >= 0)
 548:	39fd                	addiw	s3,s3,-1
 54a:	14fd                	addi	s1,s1,-1
 54c:	fe09d9e3          	bgez	s3,53e <printint+0x6a>
}
 550:	60a6                	ld	ra,72(sp)
 552:	6406                	ld	s0,64(sp)
 554:	74e2                	ld	s1,56(sp)
 556:	7942                	ld	s2,48(sp)
 558:	79a2                	ld	s3,40(sp)
 55a:	6161                	addi	sp,sp,80
 55c:	8082                	ret
    x = -xx;
 55e:	40b005b3          	neg	a1,a1
    neg = 1;
 562:	4e05                	li	t3,1
    x = -xx;
 564:	b761                	j	4ec <printint+0x18>

0000000000000566 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 566:	711d                	addi	sp,sp,-96
 568:	ec86                	sd	ra,88(sp)
 56a:	e8a2                	sd	s0,80(sp)
 56c:	e4a6                	sd	s1,72(sp)
 56e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 570:	0005c483          	lbu	s1,0(a1)
 574:	28048463          	beqz	s1,7fc <vprintf+0x296>
 578:	e0ca                	sd	s2,64(sp)
 57a:	fc4e                	sd	s3,56(sp)
 57c:	f852                	sd	s4,48(sp)
 57e:	f456                	sd	s5,40(sp)
 580:	f05a                	sd	s6,32(sp)
 582:	ec5e                	sd	s7,24(sp)
 584:	e862                	sd	s8,16(sp)
 586:	e466                	sd	s9,8(sp)
 588:	8b2a                	mv	s6,a0
 58a:	8a2e                	mv	s4,a1
 58c:	8bb2                	mv	s7,a2
  state = 0;
 58e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 590:	4901                	li	s2,0
 592:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 594:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 598:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 59c:	06c00c93          	li	s9,108
 5a0:	a00d                	j	5c2 <vprintf+0x5c>
        putc(fd, c0);
 5a2:	85a6                	mv	a1,s1
 5a4:	855a                	mv	a0,s6
 5a6:	f11ff0ef          	jal	4b6 <putc>
 5aa:	a019                	j	5b0 <vprintf+0x4a>
    } else if (state == '%') {
 5ac:	03598363          	beq	s3,s5,5d2 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 5b0:	0019079b          	addiw	a5,s2,1
 5b4:	893e                	mv	s2,a5
 5b6:	873e                	mv	a4,a5
 5b8:	97d2                	add	a5,a5,s4
 5ba:	0007c483          	lbu	s1,0(a5)
 5be:	22048763          	beqz	s1,7ec <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 5c2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5c6:	fe0993e3          	bnez	s3,5ac <vprintf+0x46>
      if (c0 == '%') {
 5ca:	fd579ce3          	bne	a5,s5,5a2 <vprintf+0x3c>
        state = '%';
 5ce:	89be                	mv	s3,a5
 5d0:	b7c5                	j	5b0 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5d2:	00ea06b3          	add	a3,s4,a4
 5d6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5da:	8636                	mv	a2,a3
      if (c1)
 5dc:	c681                	beqz	a3,5e4 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 5de:	9752                	add	a4,a4,s4
 5e0:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5e4:	05878263          	beq	a5,s8,628 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5e8:	05978c63          	beq	a5,s9,640 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5ec:	07500713          	li	a4,117
 5f0:	0ee78663          	beq	a5,a4,6dc <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5f4:	07800713          	li	a4,120
 5f8:	12e78863          	beq	a5,a4,728 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5fc:	07000713          	li	a4,112
 600:	14e78d63          	beq	a5,a4,75a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 604:	06300713          	li	a4,99
 608:	18e78c63          	beq	a5,a4,7a0 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 60c:	07300713          	li	a4,115
 610:	1ae78263          	beq	a5,a4,7b4 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 614:	02500713          	li	a4,37
 618:	04e79463          	bne	a5,a4,660 <vprintf+0xfa>
        putc(fd, '%');
 61c:	85ba                	mv	a1,a4
 61e:	855a                	mv	a0,s6
 620:	e97ff0ef          	jal	4b6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 624:	4981                	li	s3,0
 626:	b769                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 628:	008b8493          	addi	s1,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000ba583          	lw	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e9fff0ef          	jal	4d4 <printint>
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	bf8d                	j	5b0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 640:	06400793          	li	a5,100
 644:	02f68963          	beq	a3,a5,676 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 648:	06c00793          	li	a5,108
 64c:	04f68263          	beq	a3,a5,690 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 650:	07500793          	li	a5,117
 654:	0af68063          	beq	a3,a5,6f4 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 658:	07800793          	li	a5,120
 65c:	0ef68263          	beq	a3,a5,740 <vprintf+0x1da>
        putc(fd, '%');
 660:	02500593          	li	a1,37
 664:	855a                	mv	a0,s6
 666:	e51ff0ef          	jal	4b6 <putc>
        putc(fd, c0);
 66a:	85a6                	mv	a1,s1
 66c:	855a                	mv	a0,s6
 66e:	e49ff0ef          	jal	4b6 <putc>
      state = 0;
 672:	4981                	li	s3,0
 674:	bf35                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8493          	addi	s1,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	e51ff0ef          	jal	4d4 <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b70d                	j	5b0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 690:	06400793          	li	a5,100
 694:	02f60763          	beq	a2,a5,6c2 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 698:	07500793          	li	a5,117
 69c:	06f60963          	beq	a2,a5,70e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6a0:	07800793          	li	a5,120
 6a4:	faf61ee3          	bne	a2,a5,660 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	008b8493          	addi	s1,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000bb583          	ld	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	e1fff0ef          	jal	4d4 <printint>
        i += 2;
 6ba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
        i += 2;
 6c0:	bdc5                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	4685                	li	a3,1
 6c8:	4629                	li	a2,10
 6ca:	000bb583          	ld	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	e05ff0ef          	jal	4d4 <printint>
        i += 2;
 6d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bdd9                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000be583          	lwu	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	debff0ef          	jal	4d4 <printint>
 6ee:	8ba6                	mv	s7,s1
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bd7d                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f4:	008b8493          	addi	s1,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4629                	li	a2,10
 6fc:	000bb583          	ld	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	dd3ff0ef          	jal	4d4 <printint>
        i += 1;
 706:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 708:	8ba6                	mv	s7,s1
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b555                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 70e:	008b8493          	addi	s1,s7,8
 712:	4681                	li	a3,0
 714:	4629                	li	a2,10
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	db9ff0ef          	jal	4d4 <printint>
        i += 2;
 720:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
        i += 2;
 726:	b569                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 728:	008b8493          	addi	s1,s7,8
 72c:	4681                	li	a3,0
 72e:	4641                	li	a2,16
 730:	000be583          	lwu	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d9fff0ef          	jal	4d4 <printint>
 73a:	8ba6                	mv	s7,s1
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bd8d                	j	5b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 740:	008b8493          	addi	s1,s7,8
 744:	4681                	li	a3,0
 746:	4641                	li	a2,16
 748:	000bb583          	ld	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	d87ff0ef          	jal	4d4 <printint>
        i += 1;
 752:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 754:	8ba6                	mv	s7,s1
      state = 0;
 756:	4981                	li	s3,0
        i += 1;
 758:	bda1                	j	5b0 <vprintf+0x4a>
 75a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 75c:	008b8d13          	addi	s10,s7,8
 760:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 764:	03000593          	li	a1,48
 768:	855a                	mv	a0,s6
 76a:	d4dff0ef          	jal	4b6 <putc>
  putc(fd, 'x');
 76e:	07800593          	li	a1,120
 772:	855a                	mv	a0,s6
 774:	d43ff0ef          	jal	4b6 <putc>
 778:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 77a:	00000b97          	auipc	s7,0x0
 77e:	30eb8b93          	addi	s7,s7,782 # a88 <digits>
 782:	03c9d793          	srli	a5,s3,0x3c
 786:	97de                	add	a5,a5,s7
 788:	0007c583          	lbu	a1,0(a5)
 78c:	855a                	mv	a0,s6
 78e:	d29ff0ef          	jal	4b6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 792:	0992                	slli	s3,s3,0x4
 794:	34fd                	addiw	s1,s1,-1
 796:	f4f5                	bnez	s1,782 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 798:	8bea                	mv	s7,s10
      state = 0;
 79a:	4981                	li	s3,0
 79c:	6d02                	ld	s10,0(sp)
 79e:	bd09                	j	5b0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7a0:	008b8493          	addi	s1,s7,8
 7a4:	000bc583          	lbu	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	d0dff0ef          	jal	4b6 <putc>
 7ae:	8ba6                	mv	s7,s1
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bbfd                	j	5b0 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7b4:	008b8993          	addi	s3,s7,8
 7b8:	000bb483          	ld	s1,0(s7)
 7bc:	cc91                	beqz	s1,7d8 <vprintf+0x272>
        for (; *s; s++)
 7be:	0004c583          	lbu	a1,0(s1)
 7c2:	c195                	beqz	a1,7e6 <vprintf+0x280>
          putc(fd, *s);
 7c4:	855a                	mv	a0,s6
 7c6:	cf1ff0ef          	jal	4b6 <putc>
        for (; *s; s++)
 7ca:	0485                	addi	s1,s1,1
 7cc:	0004c583          	lbu	a1,0(s1)
 7d0:	f9f5                	bnez	a1,7c4 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 7d2:	8bce                	mv	s7,s3
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	bbe9                	j	5b0 <vprintf+0x4a>
          s = "(null)";
 7d8:	00000497          	auipc	s1,0x0
 7dc:	2a848493          	addi	s1,s1,680 # a80 <malloc+0x198>
        for (; *s; s++)
 7e0:	02800593          	li	a1,40
 7e4:	b7c5                	j	7c4 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 7e6:	8bce                	mv	s7,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b3d9                	j	5b0 <vprintf+0x4a>
 7ec:	6906                	ld	s2,64(sp)
 7ee:	79e2                	ld	s3,56(sp)
 7f0:	7a42                	ld	s4,48(sp)
 7f2:	7aa2                	ld	s5,40(sp)
 7f4:	7b02                	ld	s6,32(sp)
 7f6:	6be2                	ld	s7,24(sp)
 7f8:	6c42                	ld	s8,16(sp)
 7fa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7fc:	60e6                	ld	ra,88(sp)
 7fe:	6446                	ld	s0,80(sp)
 800:	64a6                	ld	s1,72(sp)
 802:	6125                	addi	sp,sp,96
 804:	8082                	ret

0000000000000806 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 806:	715d                	addi	sp,sp,-80
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e010                	sd	a2,0(s0)
 810:	e414                	sd	a3,8(s0)
 812:	e818                	sd	a4,16(s0)
 814:	ec1c                	sd	a5,24(s0)
 816:	03043023          	sd	a6,32(s0)
 81a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81e:	8622                	mv	a2,s0
 820:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 824:	d43ff0ef          	jal	566 <vprintf>
}
 828:	60e2                	ld	ra,24(sp)
 82a:	6442                	ld	s0,16(sp)
 82c:	6161                	addi	sp,sp,80
 82e:	8082                	ret

0000000000000830 <printf>:

void
printf(const char *fmt, ...)
{
 830:	711d                	addi	sp,sp,-96
 832:	ec06                	sd	ra,24(sp)
 834:	e822                	sd	s0,16(sp)
 836:	1000                	addi	s0,sp,32
 838:	e40c                	sd	a1,8(s0)
 83a:	e810                	sd	a2,16(s0)
 83c:	ec14                	sd	a3,24(s0)
 83e:	f018                	sd	a4,32(s0)
 840:	f41c                	sd	a5,40(s0)
 842:	03043823          	sd	a6,48(s0)
 846:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 84a:	00840613          	addi	a2,s0,8
 84e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 852:	85aa                	mv	a1,a0
 854:	4505                	li	a0,1
 856:	d11ff0ef          	jal	566 <vprintf>
}
 85a:	60e2                	ld	ra,24(sp)
 85c:	6442                	ld	s0,16(sp)
 85e:	6125                	addi	sp,sp,96
 860:	8082                	ret

0000000000000862 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 862:	1141                	addi	sp,sp,-16
 864:	e406                	sd	ra,8(sp)
 866:	e022                	sd	s0,0(sp)
 868:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 86a:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	00000797          	auipc	a5,0x0
 872:	7927b783          	ld	a5,1938(a5) # 1000 <freep>
 876:	a02d                	j	8a0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 878:	4618                	lw	a4,8(a2)
 87a:	9f2d                	addw	a4,a4,a1
 87c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	6310                	ld	a2,0(a4)
 884:	a83d                	j	8c2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 886:	ff852703          	lw	a4,-8(a0)
 88a:	9f31                	addw	a4,a4,a2
 88c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 88e:	ff053683          	ld	a3,-16(a0)
 892:	a091                	j	8d6 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	6398                	ld	a4,0(a5)
 896:	00e7e463          	bltu	a5,a4,89e <free+0x3c>
 89a:	00e6ea63          	bltu	a3,a4,8ae <free+0x4c>
{
 89e:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	fed7fae3          	bgeu	a5,a3,894 <free+0x32>
 8a4:	6398                	ld	a4,0(a5)
 8a6:	00e6e463          	bltu	a3,a4,8ae <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	fee7eae3          	bltu	a5,a4,89e <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 8ae:	ff852583          	lw	a1,-8(a0)
 8b2:	6390                	ld	a2,0(a5)
 8b4:	02059813          	slli	a6,a1,0x20
 8b8:	01c85713          	srli	a4,a6,0x1c
 8bc:	9736                	add	a4,a4,a3
 8be:	fae60de3          	beq	a2,a4,878 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8c2:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8c6:	4790                	lw	a2,8(a5)
 8c8:	02061593          	slli	a1,a2,0x20
 8cc:	01c5d713          	srli	a4,a1,0x1c
 8d0:	973e                	add	a4,a4,a5
 8d2:	fae68ae3          	beq	a3,a4,886 <free+0x24>
    p->s.ptr = bp->s.ptr;
 8d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72f73423          	sd	a5,1832(a4) # 1000 <freep>
}
 8e0:	60a2                	ld	ra,8(sp)
 8e2:	6402                	ld	s0,0(sp)
 8e4:	0141                	addi	sp,sp,16
 8e6:	8082                	ret

00000000000008e8 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8e8:	7139                	addi	sp,sp,-64
 8ea:	fc06                	sd	ra,56(sp)
 8ec:	f822                	sd	s0,48(sp)
 8ee:	f04a                	sd	s2,32(sp)
 8f0:	ec4e                	sd	s3,24(sp)
 8f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8f4:	02051993          	slli	s3,a0,0x20
 8f8:	0209d993          	srli	s3,s3,0x20
 8fc:	09bd                	addi	s3,s3,15
 8fe:	0049d993          	srli	s3,s3,0x4
 902:	2985                	addiw	s3,s3,1
 904:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 906:	00000517          	auipc	a0,0x0
 90a:	6fa53503          	ld	a0,1786(a0) # 1000 <freep>
 90e:	c905                	beqz	a0,93e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 910:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 912:	4798                	lw	a4,8(a5)
 914:	09377663          	bgeu	a4,s3,9a0 <malloc+0xb8>
 918:	f426                	sd	s1,40(sp)
 91a:	e852                	sd	s4,16(sp)
 91c:	e456                	sd	s5,8(sp)
 91e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 920:	8a4e                	mv	s4,s3
 922:	6705                	lui	a4,0x1
 924:	00e9f363          	bgeu	s3,a4,92a <malloc+0x42>
 928:	6a05                	lui	s4,0x1
 92a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 932:	00000497          	auipc	s1,0x0
 936:	6ce48493          	addi	s1,s1,1742 # 1000 <freep>
  if (p == SBRK_ERROR)
 93a:	5afd                	li	s5,-1
 93c:	a83d                	j	97a <malloc+0x92>
 93e:	f426                	sd	s1,40(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 946:	00000797          	auipc	a5,0x0
 94a:	6ca78793          	addi	a5,a5,1738 # 1010 <base>
 94e:	00000717          	auipc	a4,0x0
 952:	6af73923          	sd	a5,1714(a4) # 1000 <freep>
 956:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 958:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 95c:	b7d1                	j	920 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 95e:	6398                	ld	a4,0(a5)
 960:	e118                	sd	a4,0(a0)
 962:	a899                	j	9b8 <malloc+0xd0>
  hp->s.size = nu;
 964:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 968:	0541                	addi	a0,a0,16
 96a:	ef9ff0ef          	jal	862 <free>
  return freep;
 96e:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 970:	c125                	beqz	a0,9d0 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 972:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 974:	4798                	lw	a4,8(a5)
 976:	03277163          	bgeu	a4,s2,998 <malloc+0xb0>
    if (p == freep)
 97a:	6098                	ld	a4,0(s1)
 97c:	853e                	mv	a0,a5
 97e:	fef71ae3          	bne	a4,a5,972 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 982:	8552                	mv	a0,s4
 984:	9d3ff0ef          	jal	356 <sbrk>
  if (p == SBRK_ERROR)
 988:	fd551ee3          	bne	a0,s5,964 <malloc+0x7c>
        return 0;
 98c:	4501                	li	a0,0
 98e:	74a2                	ld	s1,40(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
 996:	a03d                	j	9c4 <malloc+0xdc>
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9a0:	fae90fe3          	beq	s2,a4,95e <malloc+0x76>
        p->s.size -= nunits;
 9a4:	4137073b          	subw	a4,a4,s3
 9a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9aa:	02071693          	slli	a3,a4,0x20
 9ae:	01c6d713          	srli	a4,a3,0x1c
 9b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b8:	00000717          	auipc	a4,0x0
 9bc:	64a73423          	sd	a0,1608(a4) # 1000 <freep>
      return (void *)(p + 1);
 9c0:	01078513          	addi	a0,a5,16
  }
}
 9c4:	70e2                	ld	ra,56(sp)
 9c6:	7442                	ld	s0,48(sp)
 9c8:	7902                	ld	s2,32(sp)
 9ca:	69e2                	ld	s3,24(sp)
 9cc:	6121                	addi	sp,sp,64
 9ce:	8082                	ret
 9d0:	74a2                	ld	s1,40(sp)
 9d2:	6a42                	ld	s4,16(sp)
 9d4:	6aa2                	ld	s5,8(sp)
 9d6:	6b02                	ld	s6,0(sp)
 9d8:	b7f5                	j	9c4 <malloc+0xdc>
