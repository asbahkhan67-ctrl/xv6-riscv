
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	ffc90913          	addi	s2,s2,-4 # 1010 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	3ae000ef          	jal	3d6 <read>
  2c:	84aa                	mv	s1,a0
  2e:	02a05363          	blez	a0,54 <cat+0x54>
    if (write(1, buf, n) != n) {
  32:	8626                	mv	a2,s1
  34:	85ca                	mv	a1,s2
  36:	8556                	mv	a0,s5
  38:	3a6000ef          	jal	3de <write>
  3c:	fe9503e3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	9d058593          	addi	a1,a1,-1584 # a10 <malloc+0xf4>
  48:	4509                	li	a0,2
  4a:	7f0000ef          	jal	83a <fprintf>
      exit(1);
  4e:	4505                	li	a0,1
  50:	36e000ef          	jal	3be <exit>
    }
  }
  if (n < 0) {
  54:	00054b63          	bltz	a0,6a <cat+0x6a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  58:	70e2                	ld	ra,56(sp)
  5a:	7442                	ld	s0,48(sp)
  5c:	74a2                	ld	s1,40(sp)
  5e:	7902                	ld	s2,32(sp)
  60:	69e2                	ld	s3,24(sp)
  62:	6a42                	ld	s4,16(sp)
  64:	6aa2                	ld	s5,8(sp)
  66:	6121                	addi	sp,sp,64
  68:	8082                	ret
    fprintf(2, "cat: read error\n");
  6a:	00001597          	auipc	a1,0x1
  6e:	9be58593          	addi	a1,a1,-1602 # a28 <malloc+0x10c>
  72:	4509                	li	a0,2
  74:	7c6000ef          	jal	83a <fprintf>
    exit(1);
  78:	4505                	li	a0,1
  7a:	344000ef          	jal	3be <exit>

000000000000007e <main>:

int
main(int argc, char *argv[])
{
  7e:	7179                	addi	sp,sp,-48
  80:	f406                	sd	ra,40(sp)
  82:	f022                	sd	s0,32(sp)
  84:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  86:	4785                	li	a5,1
  88:	04a7d263          	bge	a5,a0,cc <main+0x4e>
  8c:	ec26                	sd	s1,24(sp)
  8e:	e84a                	sd	s2,16(sp)
  90:	e44e                	sd	s3,8(sp)
  92:	00858913          	addi	s2,a1,8
  96:	ffe5099b          	addiw	s3,a0,-2
  9a:	02099793          	slli	a5,s3,0x20
  9e:	01d7d993          	srli	s3,a5,0x1d
  a2:	05c1                	addi	a1,a1,16
  a4:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
  a6:	4581                	li	a1,0
  a8:	00093503          	ld	a0,0(s2)
  ac:	352000ef          	jal	3fe <open>
  b0:	84aa                	mv	s1,a0
  b2:	02054663          	bltz	a0,de <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  b6:	f4bff0ef          	jal	0 <cat>
    close(fd);
  ba:	8526                	mv	a0,s1
  bc:	32a000ef          	jal	3e6 <close>
  for (i = 1; i < argc; i++) {
  c0:	0921                	addi	s2,s2,8
  c2:	ff3912e3          	bne	s2,s3,a6 <main+0x28>
  }
  exit(0);
  c6:	4501                	li	a0,0
  c8:	2f6000ef          	jal	3be <exit>
  cc:	ec26                	sd	s1,24(sp)
  ce:	e84a                	sd	s2,16(sp)
  d0:	e44e                	sd	s3,8(sp)
    cat(0);
  d2:	4501                	li	a0,0
  d4:	f2dff0ef          	jal	0 <cat>
    exit(0);
  d8:	4501                	li	a0,0
  da:	2e4000ef          	jal	3be <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
  de:	00093603          	ld	a2,0(s2)
  e2:	00001597          	auipc	a1,0x1
  e6:	95e58593          	addi	a1,a1,-1698 # a40 <malloc+0x124>
  ea:	4509                	li	a0,2
  ec:	74e000ef          	jal	83a <fprintf>
      exit(1);
  f0:	4505                	li	a0,1
  f2:	2cc000ef          	jal	3be <exit>

00000000000000f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  fe:	f81ff0ef          	jal	7e <main>
  exit(r);
 102:	2bc000ef          	jal	3be <exit>

0000000000000106 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 106:	1141                	addi	sp,sp,-16
 108:	e406                	sd	ra,8(sp)
 10a:	e022                	sd	s0,0(sp)
 10c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 10e:	87aa                	mv	a5,a0
 110:	0585                	addi	a1,a1,1
 112:	0785                	addi	a5,a5,1
 114:	fff5c703          	lbu	a4,-1(a1)
 118:	fee78fa3          	sb	a4,-1(a5)
 11c:	fb75                	bnez	a4,110 <strcpy+0xa>
    ;
  return os;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cb91                	beqz	a5,146 <strcmp+0x20>
 134:	0005c703          	lbu	a4,0(a1)
 138:	00f71763          	bne	a4,a5,146 <strcmp+0x20>
    p++, q++;
 13c:	0505                	addi	a0,a0,1
 13e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	fbe5                	bnez	a5,134 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 146:	0005c503          	lbu	a0,0(a1)
}
 14a:	40a7853b          	subw	a0,a5,a0
 14e:	60a2                	ld	ra,8(sp)
 150:	6402                	ld	s0,0(sp)
 152:	0141                	addi	sp,sp,16
 154:	8082                	ret

0000000000000156 <strlen>:

uint
strlen(const char *s)
{
 156:	1141                	addi	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 15e:	00054783          	lbu	a5,0(a0)
 162:	cf99                	beqz	a5,180 <strlen+0x2a>
 164:	0505                	addi	a0,a0,1
 166:	87aa                	mv	a5,a0
 168:	86be                	mv	a3,a5
 16a:	0785                	addi	a5,a5,1
 16c:	fff7c703          	lbu	a4,-1(a5)
 170:	ff65                	bnez	a4,168 <strlen+0x12>
 172:	40a6853b          	subw	a0,a3,a0
 176:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 178:	60a2                	ld	ra,8(sp)
 17a:	6402                	ld	s0,0(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  for (n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfdd                	j	178 <strlen+0x22>

0000000000000184 <memset>:

void *
memset(void *dst, int c, uint n)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 18c:	ca19                	beqz	a2,1a2 <memset+0x1e>
 18e:	87aa                	mv	a5,a0
 190:	1602                	slli	a2,a2,0x20
 192:	9201                	srli	a2,a2,0x20
 194:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 198:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 19c:	0785                	addi	a5,a5,1
 19e:	fee79de3          	bne	a5,a4,198 <memset+0x14>
  }
  return dst;
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <strchr>:

char *
strchr(const char *s, char c)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1b2:	00054783          	lbu	a5,0(a0)
 1b6:	cf81                	beqz	a5,1ce <strchr+0x24>
    if (*s == c)
 1b8:	00f58763          	beq	a1,a5,1c6 <strchr+0x1c>
  for (; *s; s++)
 1bc:	0505                	addi	a0,a0,1
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	fbfd                	bnez	a5,1b8 <strchr+0xe>
      return (char *)s;
  return 0;
 1c4:	4501                	li	a0,0
}
 1c6:	60a2                	ld	ra,8(sp)
 1c8:	6402                	ld	s0,0(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret
  return 0;
 1ce:	4501                	li	a0,0
 1d0:	bfdd                	j	1c6 <strchr+0x1c>

00000000000001d2 <gets>:

char *
gets(char *buf, int max)
{
 1d2:	7159                	addi	sp,sp,-112
 1d4:	f486                	sd	ra,104(sp)
 1d6:	f0a2                	sd	s0,96(sp)
 1d8:	eca6                	sd	s1,88(sp)
 1da:	e8ca                	sd	s2,80(sp)
 1dc:	e4ce                	sd	s3,72(sp)
 1de:	e0d2                	sd	s4,64(sp)
 1e0:	fc56                	sd	s5,56(sp)
 1e2:	f85a                	sd	s6,48(sp)
 1e4:	f45e                	sd	s7,40(sp)
 1e6:	f062                	sd	s8,32(sp)
 1e8:	ec66                	sd	s9,24(sp)
 1ea:	e86a                	sd	s10,16(sp)
 1ec:	1880                	addi	s0,sp,112
 1ee:	8caa                	mv	s9,a0
 1f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1f2:	892a                	mv	s2,a0
 1f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f6:	f9f40b13          	addi	s6,s0,-97
 1fa:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1fc:	4ba9                	li	s7,10
 1fe:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 200:	8d26                	mv	s10,s1
 202:	0014899b          	addiw	s3,s1,1
 206:	84ce                	mv	s1,s3
 208:	0349d563          	bge	s3,s4,232 <gets+0x60>
    cc = read(0, &c, 1);
 20c:	8656                	mv	a2,s5
 20e:	85da                	mv	a1,s6
 210:	4501                	li	a0,0
 212:	1c4000ef          	jal	3d6 <read>
    if (cc < 1)
 216:	00a05e63          	blez	a0,232 <gets+0x60>
    buf[i++] = c;
 21a:	f9f44783          	lbu	a5,-97(s0)
 21e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 222:	01778763          	beq	a5,s7,230 <gets+0x5e>
 226:	0905                	addi	s2,s2,1
 228:	fd879ce3          	bne	a5,s8,200 <gets+0x2e>
    buf[i++] = c;
 22c:	8d4e                	mv	s10,s3
 22e:	a011                	j	232 <gets+0x60>
 230:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 232:	9d66                	add	s10,s10,s9
 234:	000d0023          	sb	zero,0(s10)
  return buf;
}
 238:	8566                	mv	a0,s9
 23a:	70a6                	ld	ra,104(sp)
 23c:	7406                	ld	s0,96(sp)
 23e:	64e6                	ld	s1,88(sp)
 240:	6946                	ld	s2,80(sp)
 242:	69a6                	ld	s3,72(sp)
 244:	6a06                	ld	s4,64(sp)
 246:	7ae2                	ld	s5,56(sp)
 248:	7b42                	ld	s6,48(sp)
 24a:	7ba2                	ld	s7,40(sp)
 24c:	7c02                	ld	s8,32(sp)
 24e:	6ce2                	ld	s9,24(sp)
 250:	6d42                	ld	s10,16(sp)
 252:	6165                	addi	sp,sp,112
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	19a000ef          	jal	3fe <open>
  if (fd < 0)
 268:	02054263          	bltz	a0,28c <stat+0x36>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	1a4000ef          	jal	416 <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	16c000ef          	jal	3e6 <close>
  return r;
 27e:	64a2                	ld	s1,8(sp)
}
 280:	854a                	mv	a0,s2
 282:	60e2                	ld	ra,24(sp)
 284:	6442                	ld	s0,16(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfcd                	j	280 <stat+0x2a>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 298:	00054683          	lbu	a3,0(a0)
 29c:	fd06879b          	addiw	a5,a3,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	4625                	li	a2,9
 2a6:	02f66963          	bltu	a2,a5,2d8 <atoi+0x48>
 2aa:	872a                	mv	a4,a0
  n = 0;
 2ac:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2ae:	0705                	addi	a4,a4,1
 2b0:	0025179b          	slliw	a5,a0,0x2
 2b4:	9fa9                	addw	a5,a5,a0
 2b6:	0017979b          	slliw	a5,a5,0x1
 2ba:	9fb5                	addw	a5,a5,a3
 2bc:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2c0:	00074683          	lbu	a3,0(a4)
 2c4:	fd06879b          	addiw	a5,a3,-48
 2c8:	0ff7f793          	zext.b	a5,a5
 2cc:	fef671e3          	bgeu	a2,a5,2ae <atoi+0x1e>
  return n;
}
 2d0:	60a2                	ld	ra,8(sp)
 2d2:	6402                	ld	s0,0(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  n = 0;
 2d8:	4501                	li	a0,0
 2da:	bfdd                	j	2d0 <atoi+0x40>

00000000000002dc <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e4:	02b57563          	bgeu	a0,a1,30e <memmove+0x32>
    while (n-- > 0)
 2e8:	00c05f63          	blez	a2,306 <memmove+0x2a>
 2ec:	1602                	slli	a2,a2,0x20
 2ee:	9201                	srli	a2,a2,0x20
 2f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f6:	0585                	addi	a1,a1,1
 2f8:	0705                	addi	a4,a4,1
 2fa:	fff5c683          	lbu	a3,-1(a1)
 2fe:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 302:	fee79ae3          	bne	a5,a4,2f6 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
    dst += n;
 30e:	00c50733          	add	a4,a0,a2
    src += n;
 312:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 314:	fec059e3          	blez	a2,306 <memmove+0x2a>
 318:	fff6079b          	addiw	a5,a2,-1
 31c:	1782                	slli	a5,a5,0x20
 31e:	9381                	srli	a5,a5,0x20
 320:	fff7c793          	not	a5,a5
 324:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 326:	15fd                	addi	a1,a1,-1
 328:	177d                	addi	a4,a4,-1
 32a:	0005c683          	lbu	a3,0(a1)
 32e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 332:	fef71ae3          	bne	a4,a5,326 <memmove+0x4a>
 336:	bfc1                	j	306 <memmove+0x2a>

0000000000000338 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	ca0d                	beqz	a2,372 <memcmp+0x3a>
 342:	fff6069b          	addiw	a3,a2,-1
 346:	1682                	slli	a3,a3,0x20
 348:	9281                	srli	a3,a3,0x20
 34a:	0685                	addi	a3,a3,1
 34c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34e:	00054783          	lbu	a5,0(a0)
 352:	0005c703          	lbu	a4,0(a1)
 356:	00e79863          	bne	a5,a4,366 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 35a:	0505                	addi	a0,a0,1
    p2++;
 35c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35e:	fed518e3          	bne	a0,a3,34e <memcmp+0x16>
  }
  return 0;
 362:	4501                	li	a0,0
 364:	a019                	j	36a <memcmp+0x32>
      return *p1 - *p2;
 366:	40e7853b          	subw	a0,a5,a4
}
 36a:	60a2                	ld	ra,8(sp)
 36c:	6402                	ld	s0,0(sp)
 36e:	0141                	addi	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfdd                	j	36a <memcmp+0x32>

0000000000000376 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37e:	f5fff0ef          	jal	2dc <memmove>
}
 382:	60a2                	ld	ra,8(sp)
 384:	6402                	ld	s0,0(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret

000000000000038a <sbrk>:

char *
sbrk(int n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 392:	4585                	li	a1,1
 394:	0b2000ef          	jal	446 <sys_sbrk>
}
 398:	60a2                	ld	ra,8(sp)
 39a:	6402                	ld	s0,0(sp)
 39c:	0141                	addi	sp,sp,16
 39e:	8082                	ret

00000000000003a0 <sbrklazy>:

char *
sbrklazy(int n)
{
 3a0:	1141                	addi	sp,sp,-16
 3a2:	e406                	sd	ra,8(sp)
 3a4:	e022                	sd	s0,0(sp)
 3a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a8:	4589                	li	a1,2
 3aa:	09c000ef          	jal	446 <sys_sbrk>
}
 3ae:	60a2                	ld	ra,8(sp)
 3b0:	6402                	ld	s0,0(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret

00000000000003b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b6:	4885                	li	a7,1
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <exit>:
.global exit
exit:
 li a7, SYS_exit
 3be:	4889                	li	a7,2
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c6:	488d                	li	a7,3
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ce:	4891                	li	a7,4
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <read>:
.global read
read:
 li a7, SYS_read
 3d6:	4895                	li	a7,5
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <write>:
.global write
write:
 li a7, SYS_write
 3de:	48c1                	li	a7,16
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <close>:
.global close
close:
 li a7, SYS_close
 3e6:	48d5                	li	a7,21
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ee:	4899                	li	a7,6
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f6:	489d                	li	a7,7
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <open>:
.global open
open:
 li a7, SYS_open
 3fe:	48bd                	li	a7,15
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 406:	48c5                	li	a7,17
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40e:	48c9                	li	a7,18
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 416:	48a1                	li	a7,8
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <link>:
.global link
link:
 li a7, SYS_link
 41e:	48cd                	li	a7,19
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 426:	48d1                	li	a7,20
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42e:	48a5                	li	a7,9
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <dup>:
.global dup
dup:
 li a7, SYS_dup
 436:	48a9                	li	a7,10
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43e:	48ad                	li	a7,11
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 446:	48b1                	li	a7,12
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <pause>:
.global pause
pause:
 li a7, SYS_pause
 44e:	48b5                	li	a7,13
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 456:	48b9                	li	a7,14
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sync>:
.global sync
sync:
 li a7, SYS_sync
 45e:	48d9                	li	a7,22
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <ps>:
.global ps
ps:
 li a7, SYS_ps
 466:	48dd                	li	a7,23
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 46e:	48e1                	li	a7,24
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 476:	48e5                	li	a7,25
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 47e:	48e9                	li	a7,26
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <trace>:
.global trace
trace:
 li a7, SYS_trace
 486:	48ed                	li	a7,27
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 48e:	48f1                	li	a7,28
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 496:	48f5                	li	a7,29
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 49e:	48f9                	li	a7,30
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 4a6:	48fd                	li	a7,31
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 4ae:	02000893          	li	a7,32
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <halt>:
.global halt
halt:
 li a7, SYS_halt
 4b8:	02100893          	li	a7,33
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 4c2:	02200893          	li	a7,34
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 4cc:	02300893          	li	a7,35
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 4d6:	02400893          	li	a7,36
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 4e0:	02500893          	li	a7,37
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ea:	1101                	addi	sp,sp,-32
 4ec:	ec06                	sd	ra,24(sp)
 4ee:	e822                	sd	s0,16(sp)
 4f0:	1000                	addi	s0,sp,32
 4f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f6:	4605                	li	a2,1
 4f8:	fef40593          	addi	a1,s0,-17
 4fc:	ee3ff0ef          	jal	3de <write>
}
 500:	60e2                	ld	ra,24(sp)
 502:	6442                	ld	s0,16(sp)
 504:	6105                	addi	sp,sp,32
 506:	8082                	ret

0000000000000508 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 508:	715d                	addi	sp,sp,-80
 50a:	e486                	sd	ra,72(sp)
 50c:	e0a2                	sd	s0,64(sp)
 50e:	fc26                	sd	s1,56(sp)
 510:	f84a                	sd	s2,48(sp)
 512:	f44e                	sd	s3,40(sp)
 514:	0880                	addi	s0,sp,80
 516:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 518:	c299                	beqz	a3,51e <printint+0x16>
 51a:	0605cc63          	bltz	a1,592 <printint+0x8a>
  neg = 0;
 51e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 520:	fb840313          	addi	t1,s0,-72
  neg = 0;
 524:	869a                	mv	a3,t1
  i = 0;
 526:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 528:	00000817          	auipc	a6,0x0
 52c:	53880813          	addi	a6,a6,1336 # a60 <digits>
 530:	88be                	mv	a7,a5
 532:	0017851b          	addiw	a0,a5,1
 536:	87aa                	mv	a5,a0
 538:	02c5f733          	remu	a4,a1,a2
 53c:	9742                	add	a4,a4,a6
 53e:	00074703          	lbu	a4,0(a4)
 542:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 546:	872e                	mv	a4,a1
 548:	02c5d5b3          	divu	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec771e3          	bgeu	a4,a2,530 <printint+0x28>
  if (neg)
 552:	000e0c63          	beqz	t3,56a <printint+0x62>
    buf[i++] = '-';
 556:	fd050793          	addi	a5,a0,-48
 55a:	00878533          	add	a0,a5,s0
 55e:	02d00793          	li	a5,45
 562:	fef50423          	sb	a5,-24(a0)
 566:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 56a:	fff7899b          	addiw	s3,a5,-1
 56e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 572:	fff4c583          	lbu	a1,-1(s1)
 576:	854a                	mv	a0,s2
 578:	f73ff0ef          	jal	4ea <putc>
  while (--i >= 0)
 57c:	39fd                	addiw	s3,s3,-1
 57e:	14fd                	addi	s1,s1,-1
 580:	fe09d9e3          	bgez	s3,572 <printint+0x6a>
}
 584:	60a6                	ld	ra,72(sp)
 586:	6406                	ld	s0,64(sp)
 588:	74e2                	ld	s1,56(sp)
 58a:	7942                	ld	s2,48(sp)
 58c:	79a2                	ld	s3,40(sp)
 58e:	6161                	addi	sp,sp,80
 590:	8082                	ret
    x = -xx;
 592:	40b005b3          	neg	a1,a1
    neg = 1;
 596:	4e05                	li	t3,1
    x = -xx;
 598:	b761                	j	520 <printint+0x18>

000000000000059a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59a:	711d                	addi	sp,sp,-96
 59c:	ec86                	sd	ra,88(sp)
 59e:	e8a2                	sd	s0,80(sp)
 5a0:	e4a6                	sd	s1,72(sp)
 5a2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5a4:	0005c483          	lbu	s1,0(a1)
 5a8:	28048463          	beqz	s1,830 <vprintf+0x296>
 5ac:	e0ca                	sd	s2,64(sp)
 5ae:	fc4e                	sd	s3,56(sp)
 5b0:	f852                	sd	s4,48(sp)
 5b2:	f456                	sd	s5,40(sp)
 5b4:	f05a                	sd	s6,32(sp)
 5b6:	ec5e                	sd	s7,24(sp)
 5b8:	e862                	sd	s8,16(sp)
 5ba:	e466                	sd	s9,8(sp)
 5bc:	8b2a                	mv	s6,a0
 5be:	8a2e                	mv	s4,a1
 5c0:	8bb2                	mv	s7,a2
  state = 0;
 5c2:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5c4:	4901                	li	s2,0
 5c6:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5cc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5d0:	06c00c93          	li	s9,108
 5d4:	a00d                	j	5f6 <vprintf+0x5c>
        putc(fd, c0);
 5d6:	85a6                	mv	a1,s1
 5d8:	855a                	mv	a0,s6
 5da:	f11ff0ef          	jal	4ea <putc>
 5de:	a019                	j	5e4 <vprintf+0x4a>
    } else if (state == '%') {
 5e0:	03598363          	beq	s3,s5,606 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 5e4:	0019079b          	addiw	a5,s2,1
 5e8:	893e                	mv	s2,a5
 5ea:	873e                	mv	a4,a5
 5ec:	97d2                	add	a5,a5,s4
 5ee:	0007c483          	lbu	s1,0(a5)
 5f2:	22048763          	beqz	s1,820 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 5f6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5fa:	fe0993e3          	bnez	s3,5e0 <vprintf+0x46>
      if (c0 == '%') {
 5fe:	fd579ce3          	bne	a5,s5,5d6 <vprintf+0x3c>
        state = '%';
 602:	89be                	mv	s3,a5
 604:	b7c5                	j	5e4 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 606:	00ea06b3          	add	a3,s4,a4
 60a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 60e:	8636                	mv	a2,a3
      if (c1)
 610:	c681                	beqz	a3,618 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 612:	9752                	add	a4,a4,s4
 614:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 618:	05878263          	beq	a5,s8,65c <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 61c:	05978c63          	beq	a5,s9,674 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 620:	07500713          	li	a4,117
 624:	0ee78663          	beq	a5,a4,710 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 628:	07800713          	li	a4,120
 62c:	12e78863          	beq	a5,a4,75c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 630:	07000713          	li	a4,112
 634:	14e78d63          	beq	a5,a4,78e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 638:	06300713          	li	a4,99
 63c:	18e78c63          	beq	a5,a4,7d4 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 640:	07300713          	li	a4,115
 644:	1ae78263          	beq	a5,a4,7e8 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 648:	02500713          	li	a4,37
 64c:	04e79463          	bne	a5,a4,694 <vprintf+0xfa>
        putc(fd, '%');
 650:	85ba                	mv	a1,a4
 652:	855a                	mv	a0,s6
 654:	e97ff0ef          	jal	4ea <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 658:	4981                	li	s3,0
 65a:	b769                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	008b8493          	addi	s1,s7,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	e9fff0ef          	jal	508 <printint>
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
 672:	bf8d                	j	5e4 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 674:	06400793          	li	a5,100
 678:	02f68963          	beq	a3,a5,6aa <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 67c:	06c00793          	li	a5,108
 680:	04f68263          	beq	a3,a5,6c4 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 684:	07500793          	li	a5,117
 688:	0af68063          	beq	a3,a5,728 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 68c:	07800793          	li	a5,120
 690:	0ef68263          	beq	a3,a5,774 <vprintf+0x1da>
        putc(fd, '%');
 694:	02500593          	li	a1,37
 698:	855a                	mv	a0,s6
 69a:	e51ff0ef          	jal	4ea <putc>
        putc(fd, c0);
 69e:	85a6                	mv	a1,s1
 6a0:	855a                	mv	a0,s6
 6a2:	e49ff0ef          	jal	4ea <putc>
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	bf35                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4685                	li	a3,1
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e51ff0ef          	jal	508 <printint>
        i += 1;
 6bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
        i += 1;
 6c2:	b70d                	j	5e4 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6c4:	06400793          	li	a5,100
 6c8:	02f60763          	beq	a2,a5,6f6 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6cc:	07500793          	li	a5,117
 6d0:	06f60963          	beq	a2,a5,742 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6d4:	07800793          	li	a5,120
 6d8:	faf61ee3          	bne	a2,a5,694 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	e1fff0ef          	jal	508 <printint>
        i += 2;
 6ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
        i += 2;
 6f4:	bdc5                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4685                	li	a3,1
 6fc:	4629                	li	a2,10
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	e05ff0ef          	jal	508 <printint>
        i += 2;
 708:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	bdd9                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 710:	008b8493          	addi	s1,s7,8
 714:	4681                	li	a3,0
 716:	4629                	li	a2,10
 718:	000be583          	lwu	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	debff0ef          	jal	508 <printint>
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
 726:	bd7d                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 728:	008b8493          	addi	s1,s7,8
 72c:	4681                	li	a3,0
 72e:	4629                	li	a2,10
 730:	000bb583          	ld	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	dd3ff0ef          	jal	508 <printint>
        i += 1;
 73a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 73c:	8ba6                	mv	s7,s1
      state = 0;
 73e:	4981                	li	s3,0
        i += 1;
 740:	b555                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 742:	008b8493          	addi	s1,s7,8
 746:	4681                	li	a3,0
 748:	4629                	li	a2,10
 74a:	000bb583          	ld	a1,0(s7)
 74e:	855a                	mv	a0,s6
 750:	db9ff0ef          	jal	508 <printint>
        i += 2;
 754:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	8ba6                	mv	s7,s1
      state = 0;
 758:	4981                	li	s3,0
        i += 2;
 75a:	b569                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 75c:	008b8493          	addi	s1,s7,8
 760:	4681                	li	a3,0
 762:	4641                	li	a2,16
 764:	000be583          	lwu	a1,0(s7)
 768:	855a                	mv	a0,s6
 76a:	d9fff0ef          	jal	508 <printint>
 76e:	8ba6                	mv	s7,s1
      state = 0;
 770:	4981                	li	s3,0
 772:	bd8d                	j	5e4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 774:	008b8493          	addi	s1,s7,8
 778:	4681                	li	a3,0
 77a:	4641                	li	a2,16
 77c:	000bb583          	ld	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	d87ff0ef          	jal	508 <printint>
        i += 1;
 786:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 788:	8ba6                	mv	s7,s1
      state = 0;
 78a:	4981                	li	s3,0
        i += 1;
 78c:	bda1                	j	5e4 <vprintf+0x4a>
 78e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 790:	008b8d13          	addi	s10,s7,8
 794:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 798:	03000593          	li	a1,48
 79c:	855a                	mv	a0,s6
 79e:	d4dff0ef          	jal	4ea <putc>
  putc(fd, 'x');
 7a2:	07800593          	li	a1,120
 7a6:	855a                	mv	a0,s6
 7a8:	d43ff0ef          	jal	4ea <putc>
 7ac:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ae:	00000b97          	auipc	s7,0x0
 7b2:	2b2b8b93          	addi	s7,s7,690 # a60 <digits>
 7b6:	03c9d793          	srli	a5,s3,0x3c
 7ba:	97de                	add	a5,a5,s7
 7bc:	0007c583          	lbu	a1,0(a5)
 7c0:	855a                	mv	a0,s6
 7c2:	d29ff0ef          	jal	4ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c6:	0992                	slli	s3,s3,0x4
 7c8:	34fd                	addiw	s1,s1,-1
 7ca:	f4f5                	bnez	s1,7b6 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7cc:	8bea                	mv	s7,s10
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	6d02                	ld	s10,0(sp)
 7d2:	bd09                	j	5e4 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7d4:	008b8493          	addi	s1,s7,8
 7d8:	000bc583          	lbu	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	d0dff0ef          	jal	4ea <putc>
 7e2:	8ba6                	mv	s7,s1
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bbfd                	j	5e4 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7e8:	008b8993          	addi	s3,s7,8
 7ec:	000bb483          	ld	s1,0(s7)
 7f0:	cc91                	beqz	s1,80c <vprintf+0x272>
        for (; *s; s++)
 7f2:	0004c583          	lbu	a1,0(s1)
 7f6:	c195                	beqz	a1,81a <vprintf+0x280>
          putc(fd, *s);
 7f8:	855a                	mv	a0,s6
 7fa:	cf1ff0ef          	jal	4ea <putc>
        for (; *s; s++)
 7fe:	0485                	addi	s1,s1,1
 800:	0004c583          	lbu	a1,0(s1)
 804:	f9f5                	bnez	a1,7f8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 806:	8bce                	mv	s7,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	bbe9                	j	5e4 <vprintf+0x4a>
          s = "(null)";
 80c:	00000497          	auipc	s1,0x0
 810:	24c48493          	addi	s1,s1,588 # a58 <malloc+0x13c>
        for (; *s; s++)
 814:	02800593          	li	a1,40
 818:	b7c5                	j	7f8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 81a:	8bce                	mv	s7,s3
      state = 0;
 81c:	4981                	li	s3,0
 81e:	b3d9                	j	5e4 <vprintf+0x4a>
 820:	6906                	ld	s2,64(sp)
 822:	79e2                	ld	s3,56(sp)
 824:	7a42                	ld	s4,48(sp)
 826:	7aa2                	ld	s5,40(sp)
 828:	7b02                	ld	s6,32(sp)
 82a:	6be2                	ld	s7,24(sp)
 82c:	6c42                	ld	s8,16(sp)
 82e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 830:	60e6                	ld	ra,88(sp)
 832:	6446                	ld	s0,80(sp)
 834:	64a6                	ld	s1,72(sp)
 836:	6125                	addi	sp,sp,96
 838:	8082                	ret

000000000000083a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83a:	715d                	addi	sp,sp,-80
 83c:	ec06                	sd	ra,24(sp)
 83e:	e822                	sd	s0,16(sp)
 840:	1000                	addi	s0,sp,32
 842:	e010                	sd	a2,0(s0)
 844:	e414                	sd	a3,8(s0)
 846:	e818                	sd	a4,16(s0)
 848:	ec1c                	sd	a5,24(s0)
 84a:	03043023          	sd	a6,32(s0)
 84e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 852:	8622                	mv	a2,s0
 854:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 858:	d43ff0ef          	jal	59a <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6161                	addi	sp,sp,80
 862:	8082                	ret

0000000000000864 <printf>:

void
printf(const char *fmt, ...)
{
 864:	711d                	addi	sp,sp,-96
 866:	ec06                	sd	ra,24(sp)
 868:	e822                	sd	s0,16(sp)
 86a:	1000                	addi	s0,sp,32
 86c:	e40c                	sd	a1,8(s0)
 86e:	e810                	sd	a2,16(s0)
 870:	ec14                	sd	a3,24(s0)
 872:	f018                	sd	a4,32(s0)
 874:	f41c                	sd	a5,40(s0)
 876:	03043823          	sd	a6,48(s0)
 87a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	00840613          	addi	a2,s0,8
 882:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 886:	85aa                	mv	a1,a0
 888:	4505                	li	a0,1
 88a:	d11ff0ef          	jal	59a <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6125                	addi	sp,sp,96
 894:	8082                	ret

0000000000000896 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 896:	1141                	addi	sp,sp,-16
 898:	e406                	sd	ra,8(sp)
 89a:	e022                	sd	s0,0(sp)
 89c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 89e:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a2:	00000797          	auipc	a5,0x0
 8a6:	75e7b783          	ld	a5,1886(a5) # 1000 <freep>
 8aa:	a02d                	j	8d4 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 8ac:	4618                	lw	a4,8(a2)
 8ae:	9f2d                	addw	a4,a4,a1
 8b0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	6310                	ld	a2,0(a4)
 8b8:	a83d                	j	8f6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8ba:	ff852703          	lw	a4,-8(a0)
 8be:	9f31                	addw	a4,a4,a2
 8c0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c2:	ff053683          	ld	a3,-16(a0)
 8c6:	a091                	j	90a <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c8:	6398                	ld	a4,0(a5)
 8ca:	00e7e463          	bltu	a5,a4,8d2 <free+0x3c>
 8ce:	00e6ea63          	bltu	a3,a4,8e2 <free+0x4c>
{
 8d2:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	fed7fae3          	bgeu	a5,a3,8c8 <free+0x32>
 8d8:	6398                	ld	a4,0(a5)
 8da:	00e6e463          	bltu	a3,a4,8e2 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	fee7eae3          	bltu	a5,a4,8d2 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 8e2:	ff852583          	lw	a1,-8(a0)
 8e6:	6390                	ld	a2,0(a5)
 8e8:	02059813          	slli	a6,a1,0x20
 8ec:	01c85713          	srli	a4,a6,0x1c
 8f0:	9736                	add	a4,a4,a3
 8f2:	fae60de3          	beq	a2,a4,8ac <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8fa:	4790                	lw	a2,8(a5)
 8fc:	02061593          	slli	a1,a2,0x20
 900:	01c5d713          	srli	a4,a1,0x1c
 904:	973e                	add	a4,a4,a5
 906:	fae68ae3          	beq	a3,a4,8ba <free+0x24>
    p->s.ptr = bp->s.ptr;
 90a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90c:	00000717          	auipc	a4,0x0
 910:	6ef73a23          	sd	a5,1780(a4) # 1000 <freep>
}
 914:	60a2                	ld	ra,8(sp)
 916:	6402                	ld	s0,0(sp)
 918:	0141                	addi	sp,sp,16
 91a:	8082                	ret

000000000000091c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 91c:	7139                	addi	sp,sp,-64
 91e:	fc06                	sd	ra,56(sp)
 920:	f822                	sd	s0,48(sp)
 922:	f04a                	sd	s2,32(sp)
 924:	ec4e                	sd	s3,24(sp)
 926:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 928:	02051993          	slli	s3,a0,0x20
 92c:	0209d993          	srli	s3,s3,0x20
 930:	09bd                	addi	s3,s3,15
 932:	0049d993          	srli	s3,s3,0x4
 936:	2985                	addiw	s3,s3,1
 938:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 93a:	00000517          	auipc	a0,0x0
 93e:	6c653503          	ld	a0,1734(a0) # 1000 <freep>
 942:	c905                	beqz	a0,972 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 944:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 946:	4798                	lw	a4,8(a5)
 948:	09377663          	bgeu	a4,s3,9d4 <malloc+0xb8>
 94c:	f426                	sd	s1,40(sp)
 94e:	e852                	sd	s4,16(sp)
 950:	e456                	sd	s5,8(sp)
 952:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 954:	8a4e                	mv	s4,s3
 956:	6705                	lui	a4,0x1
 958:	00e9f363          	bgeu	s3,a4,95e <malloc+0x42>
 95c:	6a05                	lui	s4,0x1
 95e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 962:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 966:	00000497          	auipc	s1,0x0
 96a:	69a48493          	addi	s1,s1,1690 # 1000 <freep>
  if (p == SBRK_ERROR)
 96e:	5afd                	li	s5,-1
 970:	a83d                	j	9ae <malloc+0x92>
 972:	f426                	sd	s1,40(sp)
 974:	e852                	sd	s4,16(sp)
 976:	e456                	sd	s5,8(sp)
 978:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97a:	00001797          	auipc	a5,0x1
 97e:	89678793          	addi	a5,a5,-1898 # 1210 <base>
 982:	00000717          	auipc	a4,0x0
 986:	66f73f23          	sd	a5,1662(a4) # 1000 <freep>
 98a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 990:	b7d1                	j	954 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 992:	6398                	ld	a4,0(a5)
 994:	e118                	sd	a4,0(a0)
 996:	a899                	j	9ec <malloc+0xd0>
  hp->s.size = nu;
 998:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 99c:	0541                	addi	a0,a0,16
 99e:	ef9ff0ef          	jal	896 <free>
  return freep;
 9a2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 9a4:	c125                	beqz	a0,a04 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9a6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9a8:	4798                	lw	a4,8(a5)
 9aa:	03277163          	bgeu	a4,s2,9cc <malloc+0xb0>
    if (p == freep)
 9ae:	6098                	ld	a4,0(s1)
 9b0:	853e                	mv	a0,a5
 9b2:	fef71ae3          	bne	a4,a5,9a6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9b6:	8552                	mv	a0,s4
 9b8:	9d3ff0ef          	jal	38a <sbrk>
  if (p == SBRK_ERROR)
 9bc:	fd551ee3          	bne	a0,s5,998 <malloc+0x7c>
        return 0;
 9c0:	4501                	li	a0,0
 9c2:	74a2                	ld	s1,40(sp)
 9c4:	6a42                	ld	s4,16(sp)
 9c6:	6aa2                	ld	s5,8(sp)
 9c8:	6b02                	ld	s6,0(sp)
 9ca:	a03d                	j	9f8 <malloc+0xdc>
 9cc:	74a2                	ld	s1,40(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9d4:	fae90fe3          	beq	s2,a4,992 <malloc+0x76>
        p->s.size -= nunits;
 9d8:	4137073b          	subw	a4,a4,s3
 9dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9de:	02071693          	slli	a3,a4,0x20
 9e2:	01c6d713          	srli	a4,a3,0x1c
 9e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ec:	00000717          	auipc	a4,0x0
 9f0:	60a73a23          	sd	a0,1556(a4) # 1000 <freep>
      return (void *)(p + 1);
 9f4:	01078513          	addi	a0,a5,16
  }
}
 9f8:	70e2                	ld	ra,56(sp)
 9fa:	7442                	ld	s0,48(sp)
 9fc:	7902                	ld	s2,32(sp)
 9fe:	69e2                	ld	s3,24(sp)
 a00:	6121                	addi	sp,sp,64
 a02:	8082                	ret
 a04:	74a2                	ld	s1,40(sp)
 a06:	6a42                	ld	s4,16(sp)
 a08:	6aa2                	ld	s5,8(sp)
 a0a:	6b02                	ld	s6,0(sp)
 a0c:	b7f5                	j	9f8 <malloc+0xdc>
