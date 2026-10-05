
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
  16:	91e50513          	addi	a0,a0,-1762 # 930 <malloc+0x100>
  1a:	75e000ef          	jal	778 <printf>
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
  4e:	92650513          	addi	a0,a0,-1754 # 970 <malloc+0x140>
  52:	726000ef          	jal	778 <printf>
  exit(0);
  56:	4501                	li	a0,0
  58:	2de000ef          	jal	336 <exit>
    printf("setpriority: failed\n");
  5c:	00001517          	auipc	a0,0x1
  60:	8fc50513          	addi	a0,a0,-1796 # 958 <malloc+0x128>
  64:	714000ef          	jal	778 <printf>
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

00000000000003fe <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fe:	1101                	addi	sp,sp,-32
 400:	ec06                	sd	ra,24(sp)
 402:	e822                	sd	s0,16(sp)
 404:	1000                	addi	s0,sp,32
 406:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 40a:	4605                	li	a2,1
 40c:	fef40593          	addi	a1,s0,-17
 410:	f47ff0ef          	jal	356 <write>
}
 414:	60e2                	ld	ra,24(sp)
 416:	6442                	ld	s0,16(sp)
 418:	6105                	addi	sp,sp,32
 41a:	8082                	ret

000000000000041c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 41c:	715d                	addi	sp,sp,-80
 41e:	e486                	sd	ra,72(sp)
 420:	e0a2                	sd	s0,64(sp)
 422:	fc26                	sd	s1,56(sp)
 424:	f84a                	sd	s2,48(sp)
 426:	f44e                	sd	s3,40(sp)
 428:	0880                	addi	s0,sp,80
 42a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 42c:	c299                	beqz	a3,432 <printint+0x16>
 42e:	0605cc63          	bltz	a1,4a6 <printint+0x8a>
  neg = 0;
 432:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 434:	fb840313          	addi	t1,s0,-72
  neg = 0;
 438:	869a                	mv	a3,t1
  i = 0;
 43a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 43c:	00000817          	auipc	a6,0x0
 440:	55c80813          	addi	a6,a6,1372 # 998 <digits>
 444:	88be                	mv	a7,a5
 446:	0017851b          	addiw	a0,a5,1
 44a:	87aa                	mv	a5,a0
 44c:	02c5f733          	remu	a4,a1,a2
 450:	9742                	add	a4,a4,a6
 452:	00074703          	lbu	a4,0(a4)
 456:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 45a:	872e                	mv	a4,a1
 45c:	02c5d5b3          	divu	a1,a1,a2
 460:	0685                	addi	a3,a3,1
 462:	fec771e3          	bgeu	a4,a2,444 <printint+0x28>
  if (neg)
 466:	000e0c63          	beqz	t3,47e <printint+0x62>
    buf[i++] = '-';
 46a:	fd050793          	addi	a5,a0,-48
 46e:	00878533          	add	a0,a5,s0
 472:	02d00793          	li	a5,45
 476:	fef50423          	sb	a5,-24(a0)
 47a:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 47e:	fff7899b          	addiw	s3,a5,-1
 482:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 486:	fff4c583          	lbu	a1,-1(s1)
 48a:	854a                	mv	a0,s2
 48c:	f73ff0ef          	jal	3fe <putc>
  while (--i >= 0)
 490:	39fd                	addiw	s3,s3,-1
 492:	14fd                	addi	s1,s1,-1
 494:	fe09d9e3          	bgez	s3,486 <printint+0x6a>
}
 498:	60a6                	ld	ra,72(sp)
 49a:	6406                	ld	s0,64(sp)
 49c:	74e2                	ld	s1,56(sp)
 49e:	7942                	ld	s2,48(sp)
 4a0:	79a2                	ld	s3,40(sp)
 4a2:	6161                	addi	sp,sp,80
 4a4:	8082                	ret
    x = -xx;
 4a6:	40b005b3          	neg	a1,a1
    neg = 1;
 4aa:	4e05                	li	t3,1
    x = -xx;
 4ac:	b761                	j	434 <printint+0x18>

00000000000004ae <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ae:	711d                	addi	sp,sp,-96
 4b0:	ec86                	sd	ra,88(sp)
 4b2:	e8a2                	sd	s0,80(sp)
 4b4:	e4a6                	sd	s1,72(sp)
 4b6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4b8:	0005c483          	lbu	s1,0(a1)
 4bc:	28048463          	beqz	s1,744 <vprintf+0x296>
 4c0:	e0ca                	sd	s2,64(sp)
 4c2:	fc4e                	sd	s3,56(sp)
 4c4:	f852                	sd	s4,48(sp)
 4c6:	f456                	sd	s5,40(sp)
 4c8:	f05a                	sd	s6,32(sp)
 4ca:	ec5e                	sd	s7,24(sp)
 4cc:	e862                	sd	s8,16(sp)
 4ce:	e466                	sd	s9,8(sp)
 4d0:	8b2a                	mv	s6,a0
 4d2:	8a2e                	mv	s4,a1
 4d4:	8bb2                	mv	s7,a2
  state = 0;
 4d6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4d8:	4901                	li	s2,0
 4da:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4e0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4e4:	06c00c93          	li	s9,108
 4e8:	a00d                	j	50a <vprintf+0x5c>
        putc(fd, c0);
 4ea:	85a6                	mv	a1,s1
 4ec:	855a                	mv	a0,s6
 4ee:	f11ff0ef          	jal	3fe <putc>
 4f2:	a019                	j	4f8 <vprintf+0x4a>
    } else if (state == '%') {
 4f4:	03598363          	beq	s3,s5,51a <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 4f8:	0019079b          	addiw	a5,s2,1
 4fc:	893e                	mv	s2,a5
 4fe:	873e                	mv	a4,a5
 500:	97d2                	add	a5,a5,s4
 502:	0007c483          	lbu	s1,0(a5)
 506:	22048763          	beqz	s1,734 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 50a:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 50e:	fe0993e3          	bnez	s3,4f4 <vprintf+0x46>
      if (c0 == '%') {
 512:	fd579ce3          	bne	a5,s5,4ea <vprintf+0x3c>
        state = '%';
 516:	89be                	mv	s3,a5
 518:	b7c5                	j	4f8 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 51a:	00ea06b3          	add	a3,s4,a4
 51e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 522:	8636                	mv	a2,a3
      if (c1)
 524:	c681                	beqz	a3,52c <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 526:	9752                	add	a4,a4,s4
 528:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 52c:	05878263          	beq	a5,s8,570 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 530:	05978c63          	beq	a5,s9,588 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 534:	07500713          	li	a4,117
 538:	0ee78663          	beq	a5,a4,624 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 53c:	07800713          	li	a4,120
 540:	12e78863          	beq	a5,a4,670 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 544:	07000713          	li	a4,112
 548:	14e78d63          	beq	a5,a4,6a2 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 54c:	06300713          	li	a4,99
 550:	18e78c63          	beq	a5,a4,6e8 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 554:	07300713          	li	a4,115
 558:	1ae78263          	beq	a5,a4,6fc <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 55c:	02500713          	li	a4,37
 560:	04e79463          	bne	a5,a4,5a8 <vprintf+0xfa>
        putc(fd, '%');
 564:	85ba                	mv	a1,a4
 566:	855a                	mv	a0,s6
 568:	e97ff0ef          	jal	3fe <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 56c:	4981                	li	s3,0
 56e:	b769                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 570:	008b8493          	addi	s1,s7,8
 574:	4685                	li	a3,1
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	e9fff0ef          	jal	41c <printint>
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
 586:	bf8d                	j	4f8 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 588:	06400793          	li	a5,100
 58c:	02f68963          	beq	a3,a5,5be <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 590:	06c00793          	li	a5,108
 594:	04f68263          	beq	a3,a5,5d8 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 598:	07500793          	li	a5,117
 59c:	0af68063          	beq	a3,a5,63c <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5a0:	07800793          	li	a5,120
 5a4:	0ef68263          	beq	a3,a5,688 <vprintf+0x1da>
        putc(fd, '%');
 5a8:	02500593          	li	a1,37
 5ac:	855a                	mv	a0,s6
 5ae:	e51ff0ef          	jal	3fe <putc>
        putc(fd, c0);
 5b2:	85a6                	mv	a1,s1
 5b4:	855a                	mv	a0,s6
 5b6:	e49ff0ef          	jal	3fe <putc>
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bf35                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e51ff0ef          	jal	41c <printint>
        i += 1;
 5d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
        i += 1;
 5d6:	b70d                	j	4f8 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5d8:	06400793          	li	a5,100
 5dc:	02f60763          	beq	a2,a5,60a <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5e0:	07500793          	li	a5,117
 5e4:	06f60963          	beq	a2,a5,656 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5e8:	07800793          	li	a5,120
 5ec:	faf61ee3          	bne	a2,a5,5a8 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e1fff0ef          	jal	41c <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bdc5                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e05ff0ef          	jal	41c <printint>
        i += 2;
 61c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
        i += 2;
 622:	bdd9                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000be583          	lwu	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	debff0ef          	jal	41c <printint>
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	bd7d                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dd3ff0ef          	jal	41c <printint>
        i += 1;
 64e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 1;
 654:	b555                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	db9ff0ef          	jal	41c <printint>
        i += 2;
 668:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	b569                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000be583          	lwu	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	d9fff0ef          	jal	41c <printint>
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bd8d                	j	4f8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d87ff0ef          	jal	41c <printint>
        i += 1;
 69a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	bda1                	j	4f8 <vprintf+0x4a>
 6a2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6a4:	008b8d13          	addi	s10,s7,8
 6a8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ac:	03000593          	li	a1,48
 6b0:	855a                	mv	a0,s6
 6b2:	d4dff0ef          	jal	3fe <putc>
  putc(fd, 'x');
 6b6:	07800593          	li	a1,120
 6ba:	855a                	mv	a0,s6
 6bc:	d43ff0ef          	jal	3fe <putc>
 6c0:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c2:	00000b97          	auipc	s7,0x0
 6c6:	2d6b8b93          	addi	s7,s7,726 # 998 <digits>
 6ca:	03c9d793          	srli	a5,s3,0x3c
 6ce:	97de                	add	a5,a5,s7
 6d0:	0007c583          	lbu	a1,0(a5)
 6d4:	855a                	mv	a0,s6
 6d6:	d29ff0ef          	jal	3fe <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6da:	0992                	slli	s3,s3,0x4
 6dc:	34fd                	addiw	s1,s1,-1
 6de:	f4f5                	bnez	s1,6ca <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6e0:	8bea                	mv	s7,s10
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	6d02                	ld	s10,0(sp)
 6e6:	bd09                	j	4f8 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	000bc583          	lbu	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	d0dff0ef          	jal	3fe <putc>
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
 6fa:	bbfd                	j	4f8 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 6fc:	008b8993          	addi	s3,s7,8
 700:	000bb483          	ld	s1,0(s7)
 704:	cc91                	beqz	s1,720 <vprintf+0x272>
        for (; *s; s++)
 706:	0004c583          	lbu	a1,0(s1)
 70a:	c195                	beqz	a1,72e <vprintf+0x280>
          putc(fd, *s);
 70c:	855a                	mv	a0,s6
 70e:	cf1ff0ef          	jal	3fe <putc>
        for (; *s; s++)
 712:	0485                	addi	s1,s1,1
 714:	0004c583          	lbu	a1,0(s1)
 718:	f9f5                	bnez	a1,70c <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bbe9                	j	4f8 <vprintf+0x4a>
          s = "(null)";
 720:	00000497          	auipc	s1,0x0
 724:	27048493          	addi	s1,s1,624 # 990 <malloc+0x160>
        for (; *s; s++)
 728:	02800593          	li	a1,40
 72c:	b7c5                	j	70c <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	b3d9                	j	4f8 <vprintf+0x4a>
 734:	6906                	ld	s2,64(sp)
 736:	79e2                	ld	s3,56(sp)
 738:	7a42                	ld	s4,48(sp)
 73a:	7aa2                	ld	s5,40(sp)
 73c:	7b02                	ld	s6,32(sp)
 73e:	6be2                	ld	s7,24(sp)
 740:	6c42                	ld	s8,16(sp)
 742:	6ca2                	ld	s9,8(sp)
    }
  }
}
 744:	60e6                	ld	ra,88(sp)
 746:	6446                	ld	s0,80(sp)
 748:	64a6                	ld	s1,72(sp)
 74a:	6125                	addi	sp,sp,96
 74c:	8082                	ret

000000000000074e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74e:	715d                	addi	sp,sp,-80
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e010                	sd	a2,0(s0)
 758:	e414                	sd	a3,8(s0)
 75a:	e818                	sd	a4,16(s0)
 75c:	ec1c                	sd	a5,24(s0)
 75e:	03043023          	sd	a6,32(s0)
 762:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	8622                	mv	a2,s0
 768:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76c:	d43ff0ef          	jal	4ae <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6161                	addi	sp,sp,80
 776:	8082                	ret

0000000000000778 <printf>:

void
printf(const char *fmt, ...)
{
 778:	711d                	addi	sp,sp,-96
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e40c                	sd	a1,8(s0)
 782:	e810                	sd	a2,16(s0)
 784:	ec14                	sd	a3,24(s0)
 786:	f018                	sd	a4,32(s0)
 788:	f41c                	sd	a5,40(s0)
 78a:	03043823          	sd	a6,48(s0)
 78e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 792:	00840613          	addi	a2,s0,8
 796:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79a:	85aa                	mv	a1,a0
 79c:	4505                	li	a0,1
 79e:	d11ff0ef          	jal	4ae <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e406                	sd	ra,8(sp)
 7ae:	e022                	sd	s0,0(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00001797          	auipc	a5,0x1
 7ba:	84a7b783          	ld	a5,-1974(a5) # 1000 <freep>
 7be:	a02d                	j	7e8 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9f2d                	addw	a4,a4,a1
 7c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6310                	ld	a2,0(a4)
 7cc:	a83d                	j	80a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 7ce:	ff852703          	lw	a4,-8(a0)
 7d2:	9f31                	addw	a4,a4,a2
 7d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d6:	ff053683          	ld	a3,-16(a0)
 7da:	a091                	j	81e <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	6398                	ld	a4,0(a5)
 7de:	00e7e463          	bltu	a5,a4,7e6 <free+0x3c>
 7e2:	00e6ea63          	bltu	a3,a4,7f6 <free+0x4c>
{
 7e6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	fed7fae3          	bgeu	a5,a3,7dc <free+0x32>
 7ec:	6398                	ld	a4,0(a5)
 7ee:	00e6e463          	bltu	a3,a4,7f6 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	fee7eae3          	bltu	a5,a4,7e6 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 7f6:	ff852583          	lw	a1,-8(a0)
 7fa:	6390                	ld	a2,0(a5)
 7fc:	02059813          	slli	a6,a1,0x20
 800:	01c85713          	srli	a4,a6,0x1c
 804:	9736                	add	a4,a4,a3
 806:	fae60de3          	beq	a2,a4,7c0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 80a:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 80e:	4790                	lw	a2,8(a5)
 810:	02061593          	slli	a1,a2,0x20
 814:	01c5d713          	srli	a4,a1,0x1c
 818:	973e                	add	a4,a4,a5
 81a:	fae68ae3          	beq	a3,a4,7ce <free+0x24>
    p->s.ptr = bp->s.ptr;
 81e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 820:	00000717          	auipc	a4,0x0
 824:	7ef73023          	sd	a5,2016(a4) # 1000 <freep>
}
 828:	60a2                	ld	ra,8(sp)
 82a:	6402                	ld	s0,0(sp)
 82c:	0141                	addi	sp,sp,16
 82e:	8082                	ret

0000000000000830 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 830:	7139                	addi	sp,sp,-64
 832:	fc06                	sd	ra,56(sp)
 834:	f822                	sd	s0,48(sp)
 836:	f04a                	sd	s2,32(sp)
 838:	ec4e                	sd	s3,24(sp)
 83a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 83c:	02051993          	slli	s3,a0,0x20
 840:	0209d993          	srli	s3,s3,0x20
 844:	09bd                	addi	s3,s3,15
 846:	0049d993          	srli	s3,s3,0x4
 84a:	2985                	addiw	s3,s3,1
 84c:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 84e:	00000517          	auipc	a0,0x0
 852:	7b253503          	ld	a0,1970(a0) # 1000 <freep>
 856:	c905                	beqz	a0,886 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 858:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 85a:	4798                	lw	a4,8(a5)
 85c:	09377663          	bgeu	a4,s3,8e8 <malloc+0xb8>
 860:	f426                	sd	s1,40(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 868:	8a4e                	mv	s4,s3
 86a:	6705                	lui	a4,0x1
 86c:	00e9f363          	bgeu	s3,a4,872 <malloc+0x42>
 870:	6a05                	lui	s4,0x1
 872:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 876:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 87a:	00000497          	auipc	s1,0x0
 87e:	78648493          	addi	s1,s1,1926 # 1000 <freep>
  if (p == SBRK_ERROR)
 882:	5afd                	li	s5,-1
 884:	a83d                	j	8c2 <malloc+0x92>
 886:	f426                	sd	s1,40(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 88e:	00000797          	auipc	a5,0x0
 892:	78278793          	addi	a5,a5,1922 # 1010 <base>
 896:	00000717          	auipc	a4,0x0
 89a:	76f73523          	sd	a5,1898(a4) # 1000 <freep>
 89e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a0:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8a4:	b7d1                	j	868 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	e118                	sd	a4,0(a0)
 8aa:	a899                	j	900 <malloc+0xd0>
  hp->s.size = nu;
 8ac:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8b0:	0541                	addi	a0,a0,16
 8b2:	ef9ff0ef          	jal	7aa <free>
  return freep;
 8b6:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8b8:	c125                	beqz	a0,918 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ba:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8bc:	4798                	lw	a4,8(a5)
 8be:	03277163          	bgeu	a4,s2,8e0 <malloc+0xb0>
    if (p == freep)
 8c2:	6098                	ld	a4,0(s1)
 8c4:	853e                	mv	a0,a5
 8c6:	fef71ae3          	bne	a4,a5,8ba <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ca:	8552                	mv	a0,s4
 8cc:	a37ff0ef          	jal	302 <sbrk>
  if (p == SBRK_ERROR)
 8d0:	fd551ee3          	bne	a0,s5,8ac <malloc+0x7c>
        return 0;
 8d4:	4501                	li	a0,0
 8d6:	74a2                	ld	s1,40(sp)
 8d8:	6a42                	ld	s4,16(sp)
 8da:	6aa2                	ld	s5,8(sp)
 8dc:	6b02                	ld	s6,0(sp)
 8de:	a03d                	j	90c <malloc+0xdc>
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8e8:	fae90fe3          	beq	s2,a4,8a6 <malloc+0x76>
        p->s.size -= nunits;
 8ec:	4137073b          	subw	a4,a4,s3
 8f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f2:	02071693          	slli	a3,a4,0x20
 8f6:	01c6d713          	srli	a4,a3,0x1c
 8fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 900:	00000717          	auipc	a4,0x0
 904:	70a73023          	sd	a0,1792(a4) # 1000 <freep>
      return (void *)(p + 1);
 908:	01078513          	addi	a0,a5,16
  }
}
 90c:	70e2                	ld	ra,56(sp)
 90e:	7442                	ld	s0,48(sp)
 910:	7902                	ld	s2,32(sp)
 912:	69e2                	ld	s3,24(sp)
 914:	6121                	addi	sp,sp,64
 916:	8082                	ret
 918:	74a2                	ld	s1,40(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	b7f5                	j	90c <malloc+0xdc>
