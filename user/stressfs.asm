
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	a1278793          	addi	a5,a5,-1518 # a30 <malloc+0x122>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	9cc50513          	addi	a0,a0,-1588 # a00 <malloc+0xf2>
  3c:	01b000ef          	jal	856 <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	12a000ef          	jal	176 <memset>

  for (i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if (fork() > 0)
  54:	354000ef          	jal	3a8 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for (i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	9b450513          	addi	a0,a0,-1612 # a18 <malloc+0x10a>
  6c:	7ea000ef          	jal	856 <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	36e000ef          	jal	3f0 <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for (i = 0; i < 20; i++) {
    // printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	338000ef          	jal	3d0 <write>
  for (i = 0; i < 20; i++) {
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  }
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	336000ef          	jal	3d8 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	98250513          	addi	a0,a0,-1662 # a28 <malloc+0x11a>
  ae:	7a8000ef          	jal	856 <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	338000ef          	jal	3f0 <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2fa000ef          	jal	3c8 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	300000ef          	jal	3d8 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2da000ef          	jal	3b8 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2cc000ef          	jal	3b0 <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2bc000ef          	jal	3b0 <exit>

00000000000000f8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf99                	beqz	a5,172 <strlen+0x2a>
 156:	0505                	addi	a0,a0,1
 158:	87aa                	mv	a5,a0
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
 168:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for (n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strlen+0x22>

0000000000000176 <memset>:

void *
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 17e:	ca19                	beqz	a2,194 <memset+0x1e>
 180:	87aa                	mv	a5,a0
 182:	1602                	slli	a2,a2,0x20
 184:	9201                	srli	a2,a2,0x20
 186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 18e:	0785                	addi	a5,a5,1
 190:	fee79de3          	bne	a5,a4,18a <memset+0x14>
  }
  return dst;
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char *
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf81                	beqz	a5,1c0 <strchr+0x24>
    if (*s == c)
 1aa:	00f58763          	beq	a1,a5,1b8 <strchr+0x1c>
  for (; *s; s++)
 1ae:	0505                	addi	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbfd                	bnez	a5,1aa <strchr+0xe>
      return (char *)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strchr+0x1c>

00000000000001c4 <gets>:

char *
gets(char *buf, int max)
{
 1c4:	7159                	addi	sp,sp,-112
 1c6:	f486                	sd	ra,104(sp)
 1c8:	f0a2                	sd	s0,96(sp)
 1ca:	eca6                	sd	s1,88(sp)
 1cc:	e8ca                	sd	s2,80(sp)
 1ce:	e4ce                	sd	s3,72(sp)
 1d0:	e0d2                	sd	s4,64(sp)
 1d2:	fc56                	sd	s5,56(sp)
 1d4:	f85a                	sd	s6,48(sp)
 1d6:	f45e                	sd	s7,40(sp)
 1d8:	f062                	sd	s8,32(sp)
 1da:	ec66                	sd	s9,24(sp)
 1dc:	e86a                	sd	s10,16(sp)
 1de:	1880                	addi	s0,sp,112
 1e0:	8caa                	mv	s9,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e8:	f9f40b13          	addi	s6,s0,-97
 1ec:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1ee:	4ba9                	li	s7,10
 1f0:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 1f2:	8d26                	mv	s10,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d563          	bge	s3,s4,224 <gets+0x60>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	1c4000ef          	jal	3c8 <read>
    if (cc < 1)
 208:	00a05e63          	blez	a0,224 <gets+0x60>
    buf[i++] = c;
 20c:	f9f44783          	lbu	a5,-97(s0)
 210:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 214:	01778763          	beq	a5,s7,222 <gets+0x5e>
 218:	0905                	addi	s2,s2,1
 21a:	fd879ce3          	bne	a5,s8,1f2 <gets+0x2e>
    buf[i++] = c;
 21e:	8d4e                	mv	s10,s3
 220:	a011                	j	224 <gets+0x60>
 222:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 224:	9d66                	add	s10,s10,s9
 226:	000d0023          	sb	zero,0(s10)
  return buf;
}
 22a:	8566                	mv	a0,s9
 22c:	70a6                	ld	ra,104(sp)
 22e:	7406                	ld	s0,96(sp)
 230:	64e6                	ld	s1,88(sp)
 232:	6946                	ld	s2,80(sp)
 234:	69a6                	ld	s3,72(sp)
 236:	6a06                	ld	s4,64(sp)
 238:	7ae2                	ld	s5,56(sp)
 23a:	7b42                	ld	s6,48(sp)
 23c:	7ba2                	ld	s7,40(sp)
 23e:	7c02                	ld	s8,32(sp)
 240:	6ce2                	ld	s9,24(sp)
 242:	6d42                	ld	s10,16(sp)
 244:	6165                	addi	sp,sp,112
 246:	8082                	ret

0000000000000248 <stat>:

int
stat(const char *n, struct stat *st)
{
 248:	1101                	addi	sp,sp,-32
 24a:	ec06                	sd	ra,24(sp)
 24c:	e822                	sd	s0,16(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	1000                	addi	s0,sp,32
 252:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 254:	4581                	li	a1,0
 256:	19a000ef          	jal	3f0 <open>
  if (fd < 0)
 25a:	02054263          	bltz	a0,27e <stat+0x36>
 25e:	e426                	sd	s1,8(sp)
 260:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 262:	85ca                	mv	a1,s2
 264:	1a4000ef          	jal	408 <fstat>
 268:	892a                	mv	s2,a0
  close(fd);
 26a:	8526                	mv	a0,s1
 26c:	16c000ef          	jal	3d8 <close>
  return r;
 270:	64a2                	ld	s1,8(sp)
}
 272:	854a                	mv	a0,s2
 274:	60e2                	ld	ra,24(sp)
 276:	6442                	ld	s0,16(sp)
 278:	6902                	ld	s2,0(sp)
 27a:	6105                	addi	sp,sp,32
 27c:	8082                	ret
    return -1;
 27e:	597d                	li	s2,-1
 280:	bfcd                	j	272 <stat+0x2a>

0000000000000282 <atoi>:

int
atoi(const char *s)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 28a:	00054683          	lbu	a3,0(a0)
 28e:	fd06879b          	addiw	a5,a3,-48
 292:	0ff7f793          	zext.b	a5,a5
 296:	4625                	li	a2,9
 298:	02f66963          	bltu	a2,a5,2ca <atoi+0x48>
 29c:	872a                	mv	a4,a0
  n = 0;
 29e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2a0:	0705                	addi	a4,a4,1
 2a2:	0025179b          	slliw	a5,a0,0x2
 2a6:	9fa9                	addw	a5,a5,a0
 2a8:	0017979b          	slliw	a5,a5,0x1
 2ac:	9fb5                	addw	a5,a5,a3
 2ae:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2b2:	00074683          	lbu	a3,0(a4)
 2b6:	fd06879b          	addiw	a5,a3,-48
 2ba:	0ff7f793          	zext.b	a5,a5
 2be:	fef671e3          	bgeu	a2,a5,2a0 <atoi+0x1e>
  return n;
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  n = 0;
 2ca:	4501                	li	a0,0
 2cc:	bfdd                	j	2c2 <atoi+0x40>

00000000000002ce <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2d6:	02b57563          	bgeu	a0,a1,300 <memmove+0x32>
    while (n-- > 0)
 2da:	00c05f63          	blez	a2,2f8 <memmove+0x2a>
 2de:	1602                	slli	a2,a2,0x20
 2e0:	9201                	srli	a2,a2,0x20
 2e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2e8:	0585                	addi	a1,a1,1
 2ea:	0705                	addi	a4,a4,1
 2ec:	fff5c683          	lbu	a3,-1(a1)
 2f0:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
    dst += n;
 300:	00c50733          	add	a4,a0,a2
    src += n;
 304:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 306:	fec059e3          	blez	a2,2f8 <memmove+0x2a>
 30a:	fff6079b          	addiw	a5,a2,-1
 30e:	1782                	slli	a5,a5,0x20
 310:	9381                	srli	a5,a5,0x20
 312:	fff7c793          	not	a5,a5
 316:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 318:	15fd                	addi	a1,a1,-1
 31a:	177d                	addi	a4,a4,-1
 31c:	0005c683          	lbu	a3,0(a1)
 320:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 324:	fef71ae3          	bne	a4,a5,318 <memmove+0x4a>
 328:	bfc1                	j	2f8 <memmove+0x2a>

000000000000032a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 332:	ca0d                	beqz	a2,364 <memcmp+0x3a>
 334:	fff6069b          	addiw	a3,a2,-1
 338:	1682                	slli	a3,a3,0x20
 33a:	9281                	srli	a3,a3,0x20
 33c:	0685                	addi	a3,a3,1
 33e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 340:	00054783          	lbu	a5,0(a0)
 344:	0005c703          	lbu	a4,0(a1)
 348:	00e79863          	bne	a5,a4,358 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 34c:	0505                	addi	a0,a0,1
    p2++;
 34e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 350:	fed518e3          	bne	a0,a3,340 <memcmp+0x16>
  }
  return 0;
 354:	4501                	li	a0,0
 356:	a019                	j	35c <memcmp+0x32>
      return *p1 - *p2;
 358:	40e7853b          	subw	a0,a5,a4
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfdd                	j	35c <memcmp+0x32>

0000000000000368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 370:	f5fff0ef          	jal	2ce <memmove>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <sbrk>:

char *
sbrk(int n)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 384:	4585                	li	a1,1
 386:	0b2000ef          	jal	438 <sys_sbrk>
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret

0000000000000392 <sbrklazy>:

char *
sbrklazy(int n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e406                	sd	ra,8(sp)
 396:	e022                	sd	s0,0(sp)
 398:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 39a:	4589                	li	a1,2
 39c:	09c000ef          	jal	438 <sys_sbrk>
}
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a8:	4885                	li	a7,1
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b0:	4889                	li	a7,2
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b8:	488d                	li	a7,3
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c0:	4891                	li	a7,4
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <read>:
.global read
read:
 li a7, SYS_read
 3c8:	4895                	li	a7,5
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <write>:
.global write
write:
 li a7, SYS_write
 3d0:	48c1                	li	a7,16
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <close>:
.global close
close:
 li a7, SYS_close
 3d8:	48d5                	li	a7,21
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e0:	4899                	li	a7,6
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e8:	489d                	li	a7,7
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <open>:
.global open
open:
 li a7, SYS_open
 3f0:	48bd                	li	a7,15
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f8:	48c5                	li	a7,17
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 400:	48c9                	li	a7,18
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 408:	48a1                	li	a7,8
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <link>:
.global link
link:
 li a7, SYS_link
 410:	48cd                	li	a7,19
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 418:	48d1                	li	a7,20
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 420:	48a5                	li	a7,9
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <dup>:
.global dup
dup:
 li a7, SYS_dup
 428:	48a9                	li	a7,10
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 430:	48ad                	li	a7,11
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 438:	48b1                	li	a7,12
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <pause>:
.global pause
pause:
 li a7, SYS_pause
 440:	48b5                	li	a7,13
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 448:	48b9                	li	a7,14
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <sync>:
.global sync
sync:
 li a7, SYS_sync
 450:	48d9                	li	a7,22
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <ps>:
.global ps
ps:
 li a7, SYS_ps
 458:	48dd                	li	a7,23
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 460:	48e1                	li	a7,24
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 468:	48e5                	li	a7,25
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 470:	48e9                	li	a7,26
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <trace>:
.global trace
trace:
 li a7, SYS_trace
 478:	48ed                	li	a7,27
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 480:	48f1                	li	a7,28
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 488:	48f5                	li	a7,29
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 490:	48f9                	li	a7,30
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 498:	48fd                	li	a7,31
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 4a0:	02000893          	li	a7,32
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <halt>:
.global halt
halt:
 li a7, SYS_halt
 4aa:	02100893          	li	a7,33
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 4b4:	02200893          	li	a7,34
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 4be:	02300893          	li	a7,35
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 4c8:	02400893          	li	a7,36
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 4d2:	02500893          	li	a7,37
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4dc:	1101                	addi	sp,sp,-32
 4de:	ec06                	sd	ra,24(sp)
 4e0:	e822                	sd	s0,16(sp)
 4e2:	1000                	addi	s0,sp,32
 4e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e8:	4605                	li	a2,1
 4ea:	fef40593          	addi	a1,s0,-17
 4ee:	ee3ff0ef          	jal	3d0 <write>
}
 4f2:	60e2                	ld	ra,24(sp)
 4f4:	6442                	ld	s0,16(sp)
 4f6:	6105                	addi	sp,sp,32
 4f8:	8082                	ret

00000000000004fa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4fa:	715d                	addi	sp,sp,-80
 4fc:	e486                	sd	ra,72(sp)
 4fe:	e0a2                	sd	s0,64(sp)
 500:	fc26                	sd	s1,56(sp)
 502:	f84a                	sd	s2,48(sp)
 504:	f44e                	sd	s3,40(sp)
 506:	0880                	addi	s0,sp,80
 508:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 50a:	c299                	beqz	a3,510 <printint+0x16>
 50c:	0605cc63          	bltz	a1,584 <printint+0x8a>
  neg = 0;
 510:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 512:	fb840313          	addi	t1,s0,-72
  neg = 0;
 516:	869a                	mv	a3,t1
  i = 0;
 518:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 51a:	00000817          	auipc	a6,0x0
 51e:	52e80813          	addi	a6,a6,1326 # a48 <digits>
 522:	88be                	mv	a7,a5
 524:	0017851b          	addiw	a0,a5,1
 528:	87aa                	mv	a5,a0
 52a:	02c5f733          	remu	a4,a1,a2
 52e:	9742                	add	a4,a4,a6
 530:	00074703          	lbu	a4,0(a4)
 534:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 538:	872e                	mv	a4,a1
 53a:	02c5d5b3          	divu	a1,a1,a2
 53e:	0685                	addi	a3,a3,1
 540:	fec771e3          	bgeu	a4,a2,522 <printint+0x28>
  if (neg)
 544:	000e0c63          	beqz	t3,55c <printint+0x62>
    buf[i++] = '-';
 548:	fd050793          	addi	a5,a0,-48
 54c:	00878533          	add	a0,a5,s0
 550:	02d00793          	li	a5,45
 554:	fef50423          	sb	a5,-24(a0)
 558:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 55c:	fff7899b          	addiw	s3,a5,-1
 560:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 564:	fff4c583          	lbu	a1,-1(s1)
 568:	854a                	mv	a0,s2
 56a:	f73ff0ef          	jal	4dc <putc>
  while (--i >= 0)
 56e:	39fd                	addiw	s3,s3,-1
 570:	14fd                	addi	s1,s1,-1
 572:	fe09d9e3          	bgez	s3,564 <printint+0x6a>
}
 576:	60a6                	ld	ra,72(sp)
 578:	6406                	ld	s0,64(sp)
 57a:	74e2                	ld	s1,56(sp)
 57c:	7942                	ld	s2,48(sp)
 57e:	79a2                	ld	s3,40(sp)
 580:	6161                	addi	sp,sp,80
 582:	8082                	ret
    x = -xx;
 584:	40b005b3          	neg	a1,a1
    neg = 1;
 588:	4e05                	li	t3,1
    x = -xx;
 58a:	b761                	j	512 <printint+0x18>

000000000000058c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 58c:	711d                	addi	sp,sp,-96
 58e:	ec86                	sd	ra,88(sp)
 590:	e8a2                	sd	s0,80(sp)
 592:	e4a6                	sd	s1,72(sp)
 594:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 596:	0005c483          	lbu	s1,0(a1)
 59a:	28048463          	beqz	s1,822 <vprintf+0x296>
 59e:	e0ca                	sd	s2,64(sp)
 5a0:	fc4e                	sd	s3,56(sp)
 5a2:	f852                	sd	s4,48(sp)
 5a4:	f456                	sd	s5,40(sp)
 5a6:	f05a                	sd	s6,32(sp)
 5a8:	ec5e                	sd	s7,24(sp)
 5aa:	e862                	sd	s8,16(sp)
 5ac:	e466                	sd	s9,8(sp)
 5ae:	8b2a                	mv	s6,a0
 5b0:	8a2e                	mv	s4,a1
 5b2:	8bb2                	mv	s7,a2
  state = 0;
 5b4:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5b6:	4901                	li	s2,0
 5b8:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5ba:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5c2:	06c00c93          	li	s9,108
 5c6:	a00d                	j	5e8 <vprintf+0x5c>
        putc(fd, c0);
 5c8:	85a6                	mv	a1,s1
 5ca:	855a                	mv	a0,s6
 5cc:	f11ff0ef          	jal	4dc <putc>
 5d0:	a019                	j	5d6 <vprintf+0x4a>
    } else if (state == '%') {
 5d2:	03598363          	beq	s3,s5,5f8 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 5d6:	0019079b          	addiw	a5,s2,1
 5da:	893e                	mv	s2,a5
 5dc:	873e                	mv	a4,a5
 5de:	97d2                	add	a5,a5,s4
 5e0:	0007c483          	lbu	s1,0(a5)
 5e4:	22048763          	beqz	s1,812 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 5e8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5ec:	fe0993e3          	bnez	s3,5d2 <vprintf+0x46>
      if (c0 == '%') {
 5f0:	fd579ce3          	bne	a5,s5,5c8 <vprintf+0x3c>
        state = '%';
 5f4:	89be                	mv	s3,a5
 5f6:	b7c5                	j	5d6 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5f8:	00ea06b3          	add	a3,s4,a4
 5fc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 600:	8636                	mv	a2,a3
      if (c1)
 602:	c681                	beqz	a3,60a <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 604:	9752                	add	a4,a4,s4
 606:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 60a:	05878263          	beq	a5,s8,64e <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 60e:	05978c63          	beq	a5,s9,666 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 612:	07500713          	li	a4,117
 616:	0ee78663          	beq	a5,a4,702 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 61a:	07800713          	li	a4,120
 61e:	12e78863          	beq	a5,a4,74e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 622:	07000713          	li	a4,112
 626:	14e78d63          	beq	a5,a4,780 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 62a:	06300713          	li	a4,99
 62e:	18e78c63          	beq	a5,a4,7c6 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 632:	07300713          	li	a4,115
 636:	1ae78263          	beq	a5,a4,7da <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 63a:	02500713          	li	a4,37
 63e:	04e79463          	bne	a5,a4,686 <vprintf+0xfa>
        putc(fd, '%');
 642:	85ba                	mv	a1,a4
 644:	855a                	mv	a0,s6
 646:	e97ff0ef          	jal	4dc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 64a:	4981                	li	s3,0
 64c:	b769                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 64e:	008b8493          	addi	s1,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e9fff0ef          	jal	4fa <printint>
 660:	8ba6                	mv	s7,s1
      state = 0;
 662:	4981                	li	s3,0
 664:	bf8d                	j	5d6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 666:	06400793          	li	a5,100
 66a:	02f68963          	beq	a3,a5,69c <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 66e:	06c00793          	li	a5,108
 672:	04f68263          	beq	a3,a5,6b6 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 676:	07500793          	li	a5,117
 67a:	0af68063          	beq	a3,a5,71a <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 67e:	07800793          	li	a5,120
 682:	0ef68263          	beq	a3,a5,766 <vprintf+0x1da>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	855a                	mv	a0,s6
 68c:	e51ff0ef          	jal	4dc <putc>
        putc(fd, c0);
 690:	85a6                	mv	a1,s1
 692:	855a                	mv	a0,s6
 694:	e49ff0ef          	jal	4dc <putc>
      state = 0;
 698:	4981                	li	s3,0
 69a:	bf35                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e51ff0ef          	jal	4fa <printint>
        i += 1;
 6ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b0:	8ba6                	mv	s7,s1
      state = 0;
 6b2:	4981                	li	s3,0
        i += 1;
 6b4:	b70d                	j	5d6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6b6:	06400793          	li	a5,100
 6ba:	02f60763          	beq	a2,a5,6e8 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6be:	07500793          	li	a5,117
 6c2:	06f60963          	beq	a2,a5,734 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6c6:	07800793          	li	a5,120
 6ca:	faf61ee3          	bne	a2,a5,686 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8493          	addi	s1,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e1fff0ef          	jal	4fa <printint>
        i += 2;
 6e0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8ba6                	mv	s7,s1
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	bdc5                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e05ff0ef          	jal	4fa <printint>
        i += 2;
 6fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bdd9                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 702:	008b8493          	addi	s1,s7,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000be583          	lwu	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	debff0ef          	jal	4fa <printint>
 714:	8ba6                	mv	s7,s1
      state = 0;
 716:	4981                	li	s3,0
 718:	bd7d                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b8493          	addi	s1,s7,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000bb583          	ld	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	dd3ff0ef          	jal	4fa <printint>
        i += 1;
 72c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	8ba6                	mv	s7,s1
      state = 0;
 730:	4981                	li	s3,0
        i += 1;
 732:	b555                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8493          	addi	s1,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000bb583          	ld	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	db9ff0ef          	jal	4fa <printint>
        i += 2;
 746:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
        i += 2;
 74c:	b569                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 74e:	008b8493          	addi	s1,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000be583          	lwu	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	d9fff0ef          	jal	4fa <printint>
 760:	8ba6                	mv	s7,s1
      state = 0;
 762:	4981                	li	s3,0
 764:	bd8d                	j	5d6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8493          	addi	s1,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000bb583          	ld	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	d87ff0ef          	jal	4fa <printint>
        i += 1;
 778:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
        i += 1;
 77e:	bda1                	j	5d6 <vprintf+0x4a>
 780:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 782:	008b8d13          	addi	s10,s7,8
 786:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 78a:	03000593          	li	a1,48
 78e:	855a                	mv	a0,s6
 790:	d4dff0ef          	jal	4dc <putc>
  putc(fd, 'x');
 794:	07800593          	li	a1,120
 798:	855a                	mv	a0,s6
 79a:	d43ff0ef          	jal	4dc <putc>
 79e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7a0:	00000b97          	auipc	s7,0x0
 7a4:	2a8b8b93          	addi	s7,s7,680 # a48 <digits>
 7a8:	03c9d793          	srli	a5,s3,0x3c
 7ac:	97de                	add	a5,a5,s7
 7ae:	0007c583          	lbu	a1,0(a5)
 7b2:	855a                	mv	a0,s6
 7b4:	d29ff0ef          	jal	4dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7b8:	0992                	slli	s3,s3,0x4
 7ba:	34fd                	addiw	s1,s1,-1
 7bc:	f4f5                	bnez	s1,7a8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7be:	8bea                	mv	s7,s10
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	6d02                	ld	s10,0(sp)
 7c4:	bd09                	j	5d6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7c6:	008b8493          	addi	s1,s7,8
 7ca:	000bc583          	lbu	a1,0(s7)
 7ce:	855a                	mv	a0,s6
 7d0:	d0dff0ef          	jal	4dc <putc>
 7d4:	8ba6                	mv	s7,s1
      state = 0;
 7d6:	4981                	li	s3,0
 7d8:	bbfd                	j	5d6 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7da:	008b8993          	addi	s3,s7,8
 7de:	000bb483          	ld	s1,0(s7)
 7e2:	cc91                	beqz	s1,7fe <vprintf+0x272>
        for (; *s; s++)
 7e4:	0004c583          	lbu	a1,0(s1)
 7e8:	c195                	beqz	a1,80c <vprintf+0x280>
          putc(fd, *s);
 7ea:	855a                	mv	a0,s6
 7ec:	cf1ff0ef          	jal	4dc <putc>
        for (; *s; s++)
 7f0:	0485                	addi	s1,s1,1
 7f2:	0004c583          	lbu	a1,0(s1)
 7f6:	f9f5                	bnez	a1,7ea <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 7f8:	8bce                	mv	s7,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bbe9                	j	5d6 <vprintf+0x4a>
          s = "(null)";
 7fe:	00000497          	auipc	s1,0x0
 802:	24248493          	addi	s1,s1,578 # a40 <malloc+0x132>
        for (; *s; s++)
 806:	02800593          	li	a1,40
 80a:	b7c5                	j	7ea <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 80c:	8bce                	mv	s7,s3
      state = 0;
 80e:	4981                	li	s3,0
 810:	b3d9                	j	5d6 <vprintf+0x4a>
 812:	6906                	ld	s2,64(sp)
 814:	79e2                	ld	s3,56(sp)
 816:	7a42                	ld	s4,48(sp)
 818:	7aa2                	ld	s5,40(sp)
 81a:	7b02                	ld	s6,32(sp)
 81c:	6be2                	ld	s7,24(sp)
 81e:	6c42                	ld	s8,16(sp)
 820:	6ca2                	ld	s9,8(sp)
    }
  }
}
 822:	60e6                	ld	ra,88(sp)
 824:	6446                	ld	s0,80(sp)
 826:	64a6                	ld	s1,72(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82c:	715d                	addi	sp,sp,-80
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e010                	sd	a2,0(s0)
 836:	e414                	sd	a3,8(s0)
 838:	e818                	sd	a4,16(s0)
 83a:	ec1c                	sd	a5,24(s0)
 83c:	03043023          	sd	a6,32(s0)
 840:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	8622                	mv	a2,s0
 846:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 84a:	d43ff0ef          	jal	58c <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6161                	addi	sp,sp,80
 854:	8082                	ret

0000000000000856 <printf>:

void
printf(const char *fmt, ...)
{
 856:	711d                	addi	sp,sp,-96
 858:	ec06                	sd	ra,24(sp)
 85a:	e822                	sd	s0,16(sp)
 85c:	1000                	addi	s0,sp,32
 85e:	e40c                	sd	a1,8(s0)
 860:	e810                	sd	a2,16(s0)
 862:	ec14                	sd	a3,24(s0)
 864:	f018                	sd	a4,32(s0)
 866:	f41c                	sd	a5,40(s0)
 868:	03043823          	sd	a6,48(s0)
 86c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	00840613          	addi	a2,s0,8
 874:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 878:	85aa                	mv	a1,a0
 87a:	4505                	li	a0,1
 87c:	d11ff0ef          	jal	58c <vprintf>
}
 880:	60e2                	ld	ra,24(sp)
 882:	6442                	ld	s0,16(sp)
 884:	6125                	addi	sp,sp,96
 886:	8082                	ret

0000000000000888 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e406                	sd	ra,8(sp)
 88c:	e022                	sd	s0,0(sp)
 88e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 890:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 894:	00000797          	auipc	a5,0x0
 898:	76c7b783          	ld	a5,1900(a5) # 1000 <freep>
 89c:	a02d                	j	8c6 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 89e:	4618                	lw	a4,8(a2)
 8a0:	9f2d                	addw	a4,a4,a1
 8a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	6310                	ld	a2,0(a4)
 8aa:	a83d                	j	8e8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8ac:	ff852703          	lw	a4,-8(a0)
 8b0:	9f31                	addw	a4,a4,a2
 8b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b4:	ff053683          	ld	a3,-16(a0)
 8b8:	a091                	j	8fc <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	6398                	ld	a4,0(a5)
 8bc:	00e7e463          	bltu	a5,a4,8c4 <free+0x3c>
 8c0:	00e6ea63          	bltu	a3,a4,8d4 <free+0x4c>
{
 8c4:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	fed7fae3          	bgeu	a5,a3,8ba <free+0x32>
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e6e463          	bltu	a3,a4,8d4 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d0:	fee7eae3          	bltu	a5,a4,8c4 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 8d4:	ff852583          	lw	a1,-8(a0)
 8d8:	6390                	ld	a2,0(a5)
 8da:	02059813          	slli	a6,a1,0x20
 8de:	01c85713          	srli	a4,a6,0x1c
 8e2:	9736                	add	a4,a4,a3
 8e4:	fae60de3          	beq	a2,a4,89e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8ec:	4790                	lw	a2,8(a5)
 8ee:	02061593          	slli	a1,a2,0x20
 8f2:	01c5d713          	srli	a4,a1,0x1c
 8f6:	973e                	add	a4,a4,a5
 8f8:	fae68ae3          	beq	a3,a4,8ac <free+0x24>
    p->s.ptr = bp->s.ptr;
 8fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8fe:	00000717          	auipc	a4,0x0
 902:	70f73123          	sd	a5,1794(a4) # 1000 <freep>
}
 906:	60a2                	ld	ra,8(sp)
 908:	6402                	ld	s0,0(sp)
 90a:	0141                	addi	sp,sp,16
 90c:	8082                	ret

000000000000090e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 90e:	7139                	addi	sp,sp,-64
 910:	fc06                	sd	ra,56(sp)
 912:	f822                	sd	s0,48(sp)
 914:	f04a                	sd	s2,32(sp)
 916:	ec4e                	sd	s3,24(sp)
 918:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 91a:	02051993          	slli	s3,a0,0x20
 91e:	0209d993          	srli	s3,s3,0x20
 922:	09bd                	addi	s3,s3,15
 924:	0049d993          	srli	s3,s3,0x4
 928:	2985                	addiw	s3,s3,1
 92a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 92c:	00000517          	auipc	a0,0x0
 930:	6d453503          	ld	a0,1748(a0) # 1000 <freep>
 934:	c905                	beqz	a0,964 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 936:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 938:	4798                	lw	a4,8(a5)
 93a:	09377663          	bgeu	a4,s3,9c6 <malloc+0xb8>
 93e:	f426                	sd	s1,40(sp)
 940:	e852                	sd	s4,16(sp)
 942:	e456                	sd	s5,8(sp)
 944:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 946:	8a4e                	mv	s4,s3
 948:	6705                	lui	a4,0x1
 94a:	00e9f363          	bgeu	s3,a4,950 <malloc+0x42>
 94e:	6a05                	lui	s4,0x1
 950:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 954:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 958:	00000497          	auipc	s1,0x0
 95c:	6a848493          	addi	s1,s1,1704 # 1000 <freep>
  if (p == SBRK_ERROR)
 960:	5afd                	li	s5,-1
 962:	a83d                	j	9a0 <malloc+0x92>
 964:	f426                	sd	s1,40(sp)
 966:	e852                	sd	s4,16(sp)
 968:	e456                	sd	s5,8(sp)
 96a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 96c:	00000797          	auipc	a5,0x0
 970:	6a478793          	addi	a5,a5,1700 # 1010 <base>
 974:	00000717          	auipc	a4,0x0
 978:	68f73623          	sd	a5,1676(a4) # 1000 <freep>
 97c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 982:	b7d1                	j	946 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 984:	6398                	ld	a4,0(a5)
 986:	e118                	sd	a4,0(a0)
 988:	a899                	j	9de <malloc+0xd0>
  hp->s.size = nu;
 98a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 98e:	0541                	addi	a0,a0,16
 990:	ef9ff0ef          	jal	888 <free>
  return freep;
 994:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 996:	c125                	beqz	a0,9f6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 998:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 99a:	4798                	lw	a4,8(a5)
 99c:	03277163          	bgeu	a4,s2,9be <malloc+0xb0>
    if (p == freep)
 9a0:	6098                	ld	a4,0(s1)
 9a2:	853e                	mv	a0,a5
 9a4:	fef71ae3          	bne	a4,a5,998 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9a8:	8552                	mv	a0,s4
 9aa:	9d3ff0ef          	jal	37c <sbrk>
  if (p == SBRK_ERROR)
 9ae:	fd551ee3          	bne	a0,s5,98a <malloc+0x7c>
        return 0;
 9b2:	4501                	li	a0,0
 9b4:	74a2                	ld	s1,40(sp)
 9b6:	6a42                	ld	s4,16(sp)
 9b8:	6aa2                	ld	s5,8(sp)
 9ba:	6b02                	ld	s6,0(sp)
 9bc:	a03d                	j	9ea <malloc+0xdc>
 9be:	74a2                	ld	s1,40(sp)
 9c0:	6a42                	ld	s4,16(sp)
 9c2:	6aa2                	ld	s5,8(sp)
 9c4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9c6:	fae90fe3          	beq	s2,a4,984 <malloc+0x76>
        p->s.size -= nunits;
 9ca:	4137073b          	subw	a4,a4,s3
 9ce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9d0:	02071693          	slli	a3,a4,0x20
 9d4:	01c6d713          	srli	a4,a3,0x1c
 9d8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9da:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9de:	00000717          	auipc	a4,0x0
 9e2:	62a73123          	sd	a0,1570(a4) # 1000 <freep>
      return (void *)(p + 1);
 9e6:	01078513          	addi	a0,a5,16
  }
}
 9ea:	70e2                	ld	ra,56(sp)
 9ec:	7442                	ld	s0,48(sp)
 9ee:	7902                	ld	s2,32(sp)
 9f0:	69e2                	ld	s3,24(sp)
 9f2:	6121                	addi	sp,sp,64
 9f4:	8082                	ret
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
 9fe:	b7f5                	j	9ea <malloc+0xdc>
