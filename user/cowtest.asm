
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
  24:	98050513          	addi	a0,a0,-1664 # 9a0 <malloc+0x11c>
  28:	7a4000ef          	jal	7cc <printf>

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
  48:	93c50513          	addi	a0,a0,-1732 # 980 <malloc+0xfc>
  4c:	780000ef          	jal	7cc <printf>
    exit(1);
  50:	4505                	li	a0,1
  52:	338000ef          	jal	38a <exit>
    printf("cowtest: first fork failed\n");
  56:	00001517          	auipc	a0,0x1
  5a:	95a50513          	addi	a0,a0,-1702 # 9b0 <malloc+0x12c>
  5e:	76e000ef          	jal	7cc <printf>
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
  76:	95e50513          	addi	a0,a0,-1698 # 9d0 <malloc+0x14c>
  7a:	752000ef          	jal	7cc <printf>

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
  98:	95450513          	addi	a0,a0,-1708 # 9e8 <malloc+0x164>
  9c:	730000ef          	jal	7cc <printf>
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
  b4:	95850513          	addi	a0,a0,-1704 # a08 <malloc+0x184>
  b8:	714000ef          	jal	7cc <printf>

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

0000000000000452 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 452:	1101                	addi	sp,sp,-32
 454:	ec06                	sd	ra,24(sp)
 456:	e822                	sd	s0,16(sp)
 458:	1000                	addi	s0,sp,32
 45a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45e:	4605                	li	a2,1
 460:	fef40593          	addi	a1,s0,-17
 464:	f47ff0ef          	jal	3aa <write>
}
 468:	60e2                	ld	ra,24(sp)
 46a:	6442                	ld	s0,16(sp)
 46c:	6105                	addi	sp,sp,32
 46e:	8082                	ret

0000000000000470 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 470:	715d                	addi	sp,sp,-80
 472:	e486                	sd	ra,72(sp)
 474:	e0a2                	sd	s0,64(sp)
 476:	fc26                	sd	s1,56(sp)
 478:	f84a                	sd	s2,48(sp)
 47a:	f44e                	sd	s3,40(sp)
 47c:	0880                	addi	s0,sp,80
 47e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 480:	c299                	beqz	a3,486 <printint+0x16>
 482:	0605cc63          	bltz	a1,4fa <printint+0x8a>
  neg = 0;
 486:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 488:	fb840313          	addi	t1,s0,-72
  neg = 0;
 48c:	869a                	mv	a3,t1
  i = 0;
 48e:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 490:	00000817          	auipc	a6,0x0
 494:	59880813          	addi	a6,a6,1432 # a28 <digits>
 498:	88be                	mv	a7,a5
 49a:	0017851b          	addiw	a0,a5,1
 49e:	87aa                	mv	a5,a0
 4a0:	02c5f733          	remu	a4,a1,a2
 4a4:	9742                	add	a4,a4,a6
 4a6:	00074703          	lbu	a4,0(a4)
 4aa:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4ae:	872e                	mv	a4,a1
 4b0:	02c5d5b3          	divu	a1,a1,a2
 4b4:	0685                	addi	a3,a3,1
 4b6:	fec771e3          	bgeu	a4,a2,498 <printint+0x28>
  if (neg)
 4ba:	000e0c63          	beqz	t3,4d2 <printint+0x62>
    buf[i++] = '-';
 4be:	fd050793          	addi	a5,a0,-48
 4c2:	00878533          	add	a0,a5,s0
 4c6:	02d00793          	li	a5,45
 4ca:	fef50423          	sb	a5,-24(a0)
 4ce:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4d2:	fff7899b          	addiw	s3,a5,-1
 4d6:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4da:	fff4c583          	lbu	a1,-1(s1)
 4de:	854a                	mv	a0,s2
 4e0:	f73ff0ef          	jal	452 <putc>
  while (--i >= 0)
 4e4:	39fd                	addiw	s3,s3,-1
 4e6:	14fd                	addi	s1,s1,-1
 4e8:	fe09d9e3          	bgez	s3,4da <printint+0x6a>
}
 4ec:	60a6                	ld	ra,72(sp)
 4ee:	6406                	ld	s0,64(sp)
 4f0:	74e2                	ld	s1,56(sp)
 4f2:	7942                	ld	s2,48(sp)
 4f4:	79a2                	ld	s3,40(sp)
 4f6:	6161                	addi	sp,sp,80
 4f8:	8082                	ret
    x = -xx;
 4fa:	40b005b3          	neg	a1,a1
    neg = 1;
 4fe:	4e05                	li	t3,1
    x = -xx;
 500:	b761                	j	488 <printint+0x18>

0000000000000502 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 502:	711d                	addi	sp,sp,-96
 504:	ec86                	sd	ra,88(sp)
 506:	e8a2                	sd	s0,80(sp)
 508:	e4a6                	sd	s1,72(sp)
 50a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 50c:	0005c483          	lbu	s1,0(a1)
 510:	28048463          	beqz	s1,798 <vprintf+0x296>
 514:	e0ca                	sd	s2,64(sp)
 516:	fc4e                	sd	s3,56(sp)
 518:	f852                	sd	s4,48(sp)
 51a:	f456                	sd	s5,40(sp)
 51c:	f05a                	sd	s6,32(sp)
 51e:	ec5e                	sd	s7,24(sp)
 520:	e862                	sd	s8,16(sp)
 522:	e466                	sd	s9,8(sp)
 524:	8b2a                	mv	s6,a0
 526:	8a2e                	mv	s4,a1
 528:	8bb2                	mv	s7,a2
  state = 0;
 52a:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 52c:	4901                	li	s2,0
 52e:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 530:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 534:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 538:	06c00c93          	li	s9,108
 53c:	a00d                	j	55e <vprintf+0x5c>
        putc(fd, c0);
 53e:	85a6                	mv	a1,s1
 540:	855a                	mv	a0,s6
 542:	f11ff0ef          	jal	452 <putc>
 546:	a019                	j	54c <vprintf+0x4a>
    } else if (state == '%') {
 548:	03598363          	beq	s3,s5,56e <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 54c:	0019079b          	addiw	a5,s2,1
 550:	893e                	mv	s2,a5
 552:	873e                	mv	a4,a5
 554:	97d2                	add	a5,a5,s4
 556:	0007c483          	lbu	s1,0(a5)
 55a:	22048763          	beqz	s1,788 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 55e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 562:	fe0993e3          	bnez	s3,548 <vprintf+0x46>
      if (c0 == '%') {
 566:	fd579ce3          	bne	a5,s5,53e <vprintf+0x3c>
        state = '%';
 56a:	89be                	mv	s3,a5
 56c:	b7c5                	j	54c <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 56e:	00ea06b3          	add	a3,s4,a4
 572:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 576:	8636                	mv	a2,a3
      if (c1)
 578:	c681                	beqz	a3,580 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 57a:	9752                	add	a4,a4,s4
 57c:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 580:	05878263          	beq	a5,s8,5c4 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 584:	05978c63          	beq	a5,s9,5dc <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 588:	07500713          	li	a4,117
 58c:	0ee78663          	beq	a5,a4,678 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 590:	07800713          	li	a4,120
 594:	12e78863          	beq	a5,a4,6c4 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 598:	07000713          	li	a4,112
 59c:	14e78d63          	beq	a5,a4,6f6 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5a0:	06300713          	li	a4,99
 5a4:	18e78c63          	beq	a5,a4,73c <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5a8:	07300713          	li	a4,115
 5ac:	1ae78263          	beq	a5,a4,750 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5b0:	02500713          	li	a4,37
 5b4:	04e79463          	bne	a5,a4,5fc <vprintf+0xfa>
        putc(fd, '%');
 5b8:	85ba                	mv	a1,a4
 5ba:	855a                	mv	a0,s6
 5bc:	e97ff0ef          	jal	452 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b769                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c4:	008b8493          	addi	s1,s7,8
 5c8:	4685                	li	a3,1
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e9fff0ef          	jal	470 <printint>
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf8d                	j	54c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5dc:	06400793          	li	a5,100
 5e0:	02f68963          	beq	a3,a5,612 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5e4:	06c00793          	li	a5,108
 5e8:	04f68263          	beq	a3,a5,62c <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5ec:	07500793          	li	a5,117
 5f0:	0af68063          	beq	a3,a5,690 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5f4:	07800793          	li	a5,120
 5f8:	0ef68263          	beq	a3,a5,6dc <vprintf+0x1da>
        putc(fd, '%');
 5fc:	02500593          	li	a1,37
 600:	855a                	mv	a0,s6
 602:	e51ff0ef          	jal	452 <putc>
        putc(fd, c0);
 606:	85a6                	mv	a1,s1
 608:	855a                	mv	a0,s6
 60a:	e49ff0ef          	jal	452 <putc>
      state = 0;
 60e:	4981                	li	s3,0
 610:	bf35                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	008b8493          	addi	s1,s7,8
 616:	4685                	li	a3,1
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e51ff0ef          	jal	470 <printint>
        i += 1;
 624:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
        i += 1;
 62a:	b70d                	j	54c <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 62c:	06400793          	li	a5,100
 630:	02f60763          	beq	a2,a5,65e <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 634:	07500793          	li	a5,117
 638:	06f60963          	beq	a2,a5,6aa <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 63c:	07800793          	li	a5,120
 640:	faf61ee3          	bne	a2,a5,5fc <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	e1fff0ef          	jal	470 <printint>
        i += 2;
 656:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	bdc5                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e05ff0ef          	jal	470 <printint>
        i += 2;
 670:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
        i += 2;
 676:	bdd9                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000be583          	lwu	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	debff0ef          	jal	470 <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bd7d                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	dd3ff0ef          	jal	470 <printint>
        i += 1;
 6a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 1;
 6a8:	b555                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	db9ff0ef          	jal	470 <printint>
        i += 2;
 6bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 2;
 6c2:	b569                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4641                	li	a2,16
 6cc:	000be583          	lwu	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	d9fff0ef          	jal	470 <printint>
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	bd8d                	j	54c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	d87ff0ef          	jal	470 <printint>
        i += 1;
 6ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
        i += 1;
 6f4:	bda1                	j	54c <vprintf+0x4a>
 6f6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f8:	008b8d13          	addi	s10,s7,8
 6fc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 700:	03000593          	li	a1,48
 704:	855a                	mv	a0,s6
 706:	d4dff0ef          	jal	452 <putc>
  putc(fd, 'x');
 70a:	07800593          	li	a1,120
 70e:	855a                	mv	a0,s6
 710:	d43ff0ef          	jal	452 <putc>
 714:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 716:	00000b97          	auipc	s7,0x0
 71a:	312b8b93          	addi	s7,s7,786 # a28 <digits>
 71e:	03c9d793          	srli	a5,s3,0x3c
 722:	97de                	add	a5,a5,s7
 724:	0007c583          	lbu	a1,0(a5)
 728:	855a                	mv	a0,s6
 72a:	d29ff0ef          	jal	452 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72e:	0992                	slli	s3,s3,0x4
 730:	34fd                	addiw	s1,s1,-1
 732:	f4f5                	bnez	s1,71e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 734:	8bea                	mv	s7,s10
      state = 0;
 736:	4981                	li	s3,0
 738:	6d02                	ld	s10,0(sp)
 73a:	bd09                	j	54c <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 73c:	008b8493          	addi	s1,s7,8
 740:	000bc583          	lbu	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	d0dff0ef          	jal	452 <putc>
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
 74e:	bbfd                	j	54c <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 750:	008b8993          	addi	s3,s7,8
 754:	000bb483          	ld	s1,0(s7)
 758:	cc91                	beqz	s1,774 <vprintf+0x272>
        for (; *s; s++)
 75a:	0004c583          	lbu	a1,0(s1)
 75e:	c195                	beqz	a1,782 <vprintf+0x280>
          putc(fd, *s);
 760:	855a                	mv	a0,s6
 762:	cf1ff0ef          	jal	452 <putc>
        for (; *s; s++)
 766:	0485                	addi	s1,s1,1
 768:	0004c583          	lbu	a1,0(s1)
 76c:	f9f5                	bnez	a1,760 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bbe9                	j	54c <vprintf+0x4a>
          s = "(null)";
 774:	00000497          	auipc	s1,0x0
 778:	2ac48493          	addi	s1,s1,684 # a20 <malloc+0x19c>
        for (; *s; s++)
 77c:	02800593          	li	a1,40
 780:	b7c5                	j	760 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 782:	8bce                	mv	s7,s3
      state = 0;
 784:	4981                	li	s3,0
 786:	b3d9                	j	54c <vprintf+0x4a>
 788:	6906                	ld	s2,64(sp)
 78a:	79e2                	ld	s3,56(sp)
 78c:	7a42                	ld	s4,48(sp)
 78e:	7aa2                	ld	s5,40(sp)
 790:	7b02                	ld	s6,32(sp)
 792:	6be2                	ld	s7,24(sp)
 794:	6c42                	ld	s8,16(sp)
 796:	6ca2                	ld	s9,8(sp)
    }
  }
}
 798:	60e6                	ld	ra,88(sp)
 79a:	6446                	ld	s0,80(sp)
 79c:	64a6                	ld	s1,72(sp)
 79e:	6125                	addi	sp,sp,96
 7a0:	8082                	ret

00000000000007a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a2:	715d                	addi	sp,sp,-80
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e010                	sd	a2,0(s0)
 7ac:	e414                	sd	a3,8(s0)
 7ae:	e818                	sd	a4,16(s0)
 7b0:	ec1c                	sd	a5,24(s0)
 7b2:	03043023          	sd	a6,32(s0)
 7b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	8622                	mv	a2,s0
 7bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c0:	d43ff0ef          	jal	502 <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6161                	addi	sp,sp,80
 7ca:	8082                	ret

00000000000007cc <printf>:

void
printf(const char *fmt, ...)
{
 7cc:	711d                	addi	sp,sp,-96
 7ce:	ec06                	sd	ra,24(sp)
 7d0:	e822                	sd	s0,16(sp)
 7d2:	1000                	addi	s0,sp,32
 7d4:	e40c                	sd	a1,8(s0)
 7d6:	e810                	sd	a2,16(s0)
 7d8:	ec14                	sd	a3,24(s0)
 7da:	f018                	sd	a4,32(s0)
 7dc:	f41c                	sd	a5,40(s0)
 7de:	03043823          	sd	a6,48(s0)
 7e2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	00840613          	addi	a2,s0,8
 7ea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ee:	85aa                	mv	a1,a0
 7f0:	4505                	li	a0,1
 7f2:	d11ff0ef          	jal	502 <vprintf>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6125                	addi	sp,sp,96
 7fc:	8082                	ret

00000000000007fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fe:	1141                	addi	sp,sp,-16
 800:	e406                	sd	ra,8(sp)
 802:	e022                	sd	s0,0(sp)
 804:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 806:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	00000797          	auipc	a5,0x0
 80e:	7f67b783          	ld	a5,2038(a5) # 1000 <freep>
 812:	a02d                	j	83c <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 814:	4618                	lw	a4,8(a2)
 816:	9f2d                	addw	a4,a4,a1
 818:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6310                	ld	a2,0(a4)
 820:	a83d                	j	85e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 822:	ff852703          	lw	a4,-8(a0)
 826:	9f31                	addw	a4,a4,a2
 828:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82a:	ff053683          	ld	a3,-16(a0)
 82e:	a091                	j	872 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	6398                	ld	a4,0(a5)
 832:	00e7e463          	bltu	a5,a4,83a <free+0x3c>
 836:	00e6ea63          	bltu	a3,a4,84a <free+0x4c>
{
 83a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83c:	fed7fae3          	bgeu	a5,a3,830 <free+0x32>
 840:	6398                	ld	a4,0(a5)
 842:	00e6e463          	bltu	a3,a4,84a <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	fee7eae3          	bltu	a5,a4,83a <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 84a:	ff852583          	lw	a1,-8(a0)
 84e:	6390                	ld	a2,0(a5)
 850:	02059813          	slli	a6,a1,0x20
 854:	01c85713          	srli	a4,a6,0x1c
 858:	9736                	add	a4,a4,a3
 85a:	fae60de3          	beq	a2,a4,814 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 85e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 862:	4790                	lw	a2,8(a5)
 864:	02061593          	slli	a1,a2,0x20
 868:	01c5d713          	srli	a4,a1,0x1c
 86c:	973e                	add	a4,a4,a5
 86e:	fae68ae3          	beq	a3,a4,822 <free+0x24>
    p->s.ptr = bp->s.ptr;
 872:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 874:	00000717          	auipc	a4,0x0
 878:	78f73623          	sd	a5,1932(a4) # 1000 <freep>
}
 87c:	60a2                	ld	ra,8(sp)
 87e:	6402                	ld	s0,0(sp)
 880:	0141                	addi	sp,sp,16
 882:	8082                	ret

0000000000000884 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 884:	7139                	addi	sp,sp,-64
 886:	fc06                	sd	ra,56(sp)
 888:	f822                	sd	s0,48(sp)
 88a:	f04a                	sd	s2,32(sp)
 88c:	ec4e                	sd	s3,24(sp)
 88e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 890:	02051993          	slli	s3,a0,0x20
 894:	0209d993          	srli	s3,s3,0x20
 898:	09bd                	addi	s3,s3,15
 89a:	0049d993          	srli	s3,s3,0x4
 89e:	2985                	addiw	s3,s3,1
 8a0:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8a2:	00000517          	auipc	a0,0x0
 8a6:	75e53503          	ld	a0,1886(a0) # 1000 <freep>
 8aa:	c905                	beqz	a0,8da <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ac:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ae:	4798                	lw	a4,8(a5)
 8b0:	09377663          	bgeu	a4,s3,93c <malloc+0xb8>
 8b4:	f426                	sd	s1,40(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8bc:	8a4e                	mv	s4,s3
 8be:	6705                	lui	a4,0x1
 8c0:	00e9f363          	bgeu	s3,a4,8c6 <malloc+0x42>
 8c4:	6a05                	lui	s4,0x1
 8c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8ce:	00000497          	auipc	s1,0x0
 8d2:	73248493          	addi	s1,s1,1842 # 1000 <freep>
  if (p == SBRK_ERROR)
 8d6:	5afd                	li	s5,-1
 8d8:	a83d                	j	916 <malloc+0x92>
 8da:	f426                	sd	s1,40(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e2:	00000797          	auipc	a5,0x0
 8e6:	72e78793          	addi	a5,a5,1838 # 1010 <base>
 8ea:	00000717          	auipc	a4,0x0
 8ee:	70f73b23          	sd	a5,1814(a4) # 1000 <freep>
 8f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8f8:	b7d1                	j	8bc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8fa:	6398                	ld	a4,0(a5)
 8fc:	e118                	sd	a4,0(a0)
 8fe:	a899                	j	954 <malloc+0xd0>
  hp->s.size = nu;
 900:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 904:	0541                	addi	a0,a0,16
 906:	ef9ff0ef          	jal	7fe <free>
  return freep;
 90a:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 90c:	c125                	beqz	a0,96c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 90e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 910:	4798                	lw	a4,8(a5)
 912:	03277163          	bgeu	a4,s2,934 <malloc+0xb0>
    if (p == freep)
 916:	6098                	ld	a4,0(s1)
 918:	853e                	mv	a0,a5
 91a:	fef71ae3          	bne	a4,a5,90e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 91e:	8552                	mv	a0,s4
 920:	a37ff0ef          	jal	356 <sbrk>
  if (p == SBRK_ERROR)
 924:	fd551ee3          	bne	a0,s5,900 <malloc+0x7c>
        return 0;
 928:	4501                	li	a0,0
 92a:	74a2                	ld	s1,40(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	a03d                	j	960 <malloc+0xdc>
 934:	74a2                	ld	s1,40(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 93c:	fae90fe3          	beq	s2,a4,8fa <malloc+0x76>
        p->s.size -= nunits;
 940:	4137073b          	subw	a4,a4,s3
 944:	c798                	sw	a4,8(a5)
        p += p->s.size;
 946:	02071693          	slli	a3,a4,0x20
 94a:	01c6d713          	srli	a4,a3,0x1c
 94e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 950:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 954:	00000717          	auipc	a4,0x0
 958:	6aa73623          	sd	a0,1708(a4) # 1000 <freep>
      return (void *)(p + 1);
 95c:	01078513          	addi	a0,a5,16
  }
}
 960:	70e2                	ld	ra,56(sp)
 962:	7442                	ld	s0,48(sp)
 964:	7902                	ld	s2,32(sp)
 966:	69e2                	ld	s3,24(sp)
 968:	6121                	addi	sp,sp,64
 96a:	8082                	ret
 96c:	74a2                	ld	s1,40(sp)
 96e:	6a42                	ld	s4,16(sp)
 970:	6aa2                	ld	s5,8(sp)
 972:	6b02                	ld	s6,0(sp)
 974:	b7f5                	j	960 <malloc+0xdc>
