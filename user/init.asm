
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = {"sh", 0};

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if (open("console", O_RDWR) < 0) {
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	96250513          	addi	a0,a0,-1694 # 970 <malloc+0xf2>
  16:	3ae000ef          	jal	3c4 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0); // stdout
  1e:	4501                	li	a0,0
  20:	3dc000ef          	jal	3fc <dup>
  dup(0); // stderr
  24:	4501                	li	a0,0
  26:	3d6000ef          	jal	3fc <dup>

  for (;;) {
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	94e90913          	addi	s2,s2,-1714 # 978 <malloc+0xfa>
  32:	854a                	mv	a0,s2
  34:	792000ef          	jal	7c6 <printf>
    pid = fork();
  38:	344000ef          	jal	37c <fork>
  3c:	84aa                	mv	s1,a0
    if (pid < 0) {
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if (pid == 0) {
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for (;;) {
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *)0);
  44:	4501                	li	a0,0
  46:	346000ef          	jal	38c <wait>
      if (wpid == pid) {
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if (wpid < 0) {
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	97650513          	addi	a0,a0,-1674 # 9c8 <malloc+0x14a>
  5a:	76c000ef          	jal	7c6 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	324000ef          	jal	384 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	90850513          	addi	a0,a0,-1784 # 970 <malloc+0xf2>
  70:	35c000ef          	jal	3cc <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	8fa50513          	addi	a0,a0,-1798 # 970 <malloc+0xf2>
  7e:	346000ef          	jal	3c4 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	90c50513          	addi	a0,a0,-1780 # 990 <malloc+0x112>
  8c:	73a000ef          	jal	7c6 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2f2000ef          	jal	384 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	90a50513          	addi	a0,a0,-1782 # 9a8 <malloc+0x12a>
  a6:	316000ef          	jal	3bc <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	90650513          	addi	a0,a0,-1786 # 9b0 <malloc+0x132>
  b2:	714000ef          	jal	7c6 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2cc000ef          	jal	384 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	2bc000ef          	jal	384 <exit>

00000000000000cc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf99                	beqz	a5,146 <strlen+0x2a>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
 13c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for (n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strlen+0x22>

000000000000014a <memset>:

void *
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 152:	ca19                	beqz	a2,168 <memset+0x1e>
 154:	87aa                	mv	a5,a0
 156:	1602                	slli	a2,a2,0x20
 158:	9201                	srli	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x14>
  }
  return dst;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strchr>:

char *
strchr(const char *s, char c)
{
 170:	1141                	addi	sp,sp,-16
 172:	e406                	sd	ra,8(sp)
 174:	e022                	sd	s0,0(sp)
 176:	0800                	addi	s0,sp,16
  for (; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cf81                	beqz	a5,194 <strchr+0x24>
    if (*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1c>
  for (; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xe>
      return (char *)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret
  return 0;
 194:	4501                	li	a0,0
 196:	bfdd                	j	18c <strchr+0x1c>

0000000000000198 <gets>:

char *
gets(char *buf, int max)
{
 198:	7159                	addi	sp,sp,-112
 19a:	f486                	sd	ra,104(sp)
 19c:	f0a2                	sd	s0,96(sp)
 19e:	eca6                	sd	s1,88(sp)
 1a0:	e8ca                	sd	s2,80(sp)
 1a2:	e4ce                	sd	s3,72(sp)
 1a4:	e0d2                	sd	s4,64(sp)
 1a6:	fc56                	sd	s5,56(sp)
 1a8:	f85a                	sd	s6,48(sp)
 1aa:	f45e                	sd	s7,40(sp)
 1ac:	f062                	sd	s8,32(sp)
 1ae:	ec66                	sd	s9,24(sp)
 1b0:	e86a                	sd	s10,16(sp)
 1b2:	1880                	addi	s0,sp,112
 1b4:	8caa                	mv	s9,a0
 1b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1b8:	892a                	mv	s2,a0
 1ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1bc:	f9f40b13          	addi	s6,s0,-97
 1c0:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1c2:	4ba9                	li	s7,10
 1c4:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 1c6:	8d26                	mv	s10,s1
 1c8:	0014899b          	addiw	s3,s1,1
 1cc:	84ce                	mv	s1,s3
 1ce:	0349d563          	bge	s3,s4,1f8 <gets+0x60>
    cc = read(0, &c, 1);
 1d2:	8656                	mv	a2,s5
 1d4:	85da                	mv	a1,s6
 1d6:	4501                	li	a0,0
 1d8:	1c4000ef          	jal	39c <read>
    if (cc < 1)
 1dc:	00a05e63          	blez	a0,1f8 <gets+0x60>
    buf[i++] = c;
 1e0:	f9f44783          	lbu	a5,-97(s0)
 1e4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1e8:	01778763          	beq	a5,s7,1f6 <gets+0x5e>
 1ec:	0905                	addi	s2,s2,1
 1ee:	fd879ce3          	bne	a5,s8,1c6 <gets+0x2e>
    buf[i++] = c;
 1f2:	8d4e                	mv	s10,s3
 1f4:	a011                	j	1f8 <gets+0x60>
 1f6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1f8:	9d66                	add	s10,s10,s9
 1fa:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1fe:	8566                	mv	a0,s9
 200:	70a6                	ld	ra,104(sp)
 202:	7406                	ld	s0,96(sp)
 204:	64e6                	ld	s1,88(sp)
 206:	6946                	ld	s2,80(sp)
 208:	69a6                	ld	s3,72(sp)
 20a:	6a06                	ld	s4,64(sp)
 20c:	7ae2                	ld	s5,56(sp)
 20e:	7b42                	ld	s6,48(sp)
 210:	7ba2                	ld	s7,40(sp)
 212:	7c02                	ld	s8,32(sp)
 214:	6ce2                	ld	s9,24(sp)
 216:	6d42                	ld	s10,16(sp)
 218:	6165                	addi	sp,sp,112
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
 226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	4581                	li	a1,0
 22a:	19a000ef          	jal	3c4 <open>
  if (fd < 0)
 22e:	02054263          	bltz	a0,252 <stat+0x36>
 232:	e426                	sd	s1,8(sp)
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	1a4000ef          	jal	3dc <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	16c000ef          	jal	3ac <close>
  return r;
 244:	64a2                	ld	s1,8(sp)
}
 246:	854a                	mv	a0,s2
 248:	60e2                	ld	ra,24(sp)
 24a:	6442                	ld	s0,16(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	597d                	li	s2,-1
 254:	bfcd                	j	246 <stat+0x2a>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66963          	bltu	a2,a5,29e <atoi+0x48>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1e>
  return n;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <atoi+0x40>

00000000000002a2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57563          	bgeu	a0,a1,2d4 <memmove+0x32>
    while (n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x2a>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    dst += n;
 2d4:	00c50733          	add	a4,a0,a2
    src += n;
 2d8:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2da:	fec059e3          	blez	a2,2cc <memmove+0x2a>
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2f8:	fef71ae3          	bne	a4,a5,2ec <memmove+0x4a>
 2fc:	bfc1                	j	2cc <memmove+0x2a>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 306:	ca0d                	beqz	a2,338 <memcmp+0x3a>
 308:	fff6069b          	addiw	a3,a2,-1
 30c:	1682                	slli	a3,a3,0x20
 30e:	9281                	srli	a3,a3,0x20
 310:	0685                	addi	a3,a3,1
 312:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 314:	00054783          	lbu	a5,0(a0)
 318:	0005c703          	lbu	a4,0(a1)
 31c:	00e79863          	bne	a5,a4,32c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 320:	0505                	addi	a0,a0,1
    p2++;
 322:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 324:	fed518e3          	bne	a0,a3,314 <memcmp+0x16>
  }
  return 0;
 328:	4501                	li	a0,0
 32a:	a019                	j	330 <memcmp+0x32>
      return *p1 - *p2;
 32c:	40e7853b          	subw	a0,a5,a4
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret
  return 0;
 338:	4501                	li	a0,0
 33a:	bfdd                	j	330 <memcmp+0x32>

000000000000033c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 344:	f5fff0ef          	jal	2a2 <memmove>
}
 348:	60a2                	ld	ra,8(sp)
 34a:	6402                	ld	s0,0(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret

0000000000000350 <sbrk>:

char *
sbrk(int n)
{
 350:	1141                	addi	sp,sp,-16
 352:	e406                	sd	ra,8(sp)
 354:	e022                	sd	s0,0(sp)
 356:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 358:	4585                	li	a1,1
 35a:	0b2000ef          	jal	40c <sys_sbrk>
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret

0000000000000366 <sbrklazy>:

char *
sbrklazy(int n)
{
 366:	1141                	addi	sp,sp,-16
 368:	e406                	sd	ra,8(sp)
 36a:	e022                	sd	s0,0(sp)
 36c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36e:	4589                	li	a1,2
 370:	09c000ef          	jal	40c <sys_sbrk>
}
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37c:	4885                	li	a7,1
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <exit>:
.global exit
exit:
 li a7, SYS_exit
 384:	4889                	li	a7,2
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <wait>:
.global wait
wait:
 li a7, SYS_wait
 38c:	488d                	li	a7,3
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 394:	4891                	li	a7,4
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <read>:
.global read
read:
 li a7, SYS_read
 39c:	4895                	li	a7,5
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <write>:
.global write
write:
 li a7, SYS_write
 3a4:	48c1                	li	a7,16
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <close>:
.global close
close:
 li a7, SYS_close
 3ac:	48d5                	li	a7,21
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b4:	4899                	li	a7,6
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3bc:	489d                	li	a7,7
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <open>:
.global open
open:
 li a7, SYS_open
 3c4:	48bd                	li	a7,15
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3cc:	48c5                	li	a7,17
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d4:	48c9                	li	a7,18
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3dc:	48a1                	li	a7,8
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <link>:
.global link
link:
 li a7, SYS_link
 3e4:	48cd                	li	a7,19
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ec:	48d1                	li	a7,20
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f4:	48a5                	li	a7,9
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fc:	48a9                	li	a7,10
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 404:	48ad                	li	a7,11
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 40c:	48b1                	li	a7,12
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <pause>:
.global pause
pause:
 li a7, SYS_pause
 414:	48b5                	li	a7,13
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41c:	48b9                	li	a7,14
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sync>:
.global sync
sync:
 li a7, SYS_sync
 424:	48d9                	li	a7,22
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <ps>:
.global ps
ps:
 li a7, SYS_ps
 42c:	48dd                	li	a7,23
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 434:	48e1                	li	a7,24
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 43c:	48e5                	li	a7,25
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 444:	48e9                	li	a7,26
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 44c:	1101                	addi	sp,sp,-32
 44e:	ec06                	sd	ra,24(sp)
 450:	e822                	sd	s0,16(sp)
 452:	1000                	addi	s0,sp,32
 454:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 458:	4605                	li	a2,1
 45a:	fef40593          	addi	a1,s0,-17
 45e:	f47ff0ef          	jal	3a4 <write>
}
 462:	60e2                	ld	ra,24(sp)
 464:	6442                	ld	s0,16(sp)
 466:	6105                	addi	sp,sp,32
 468:	8082                	ret

000000000000046a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46a:	715d                	addi	sp,sp,-80
 46c:	e486                	sd	ra,72(sp)
 46e:	e0a2                	sd	s0,64(sp)
 470:	fc26                	sd	s1,56(sp)
 472:	f84a                	sd	s2,48(sp)
 474:	f44e                	sd	s3,40(sp)
 476:	0880                	addi	s0,sp,80
 478:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 47a:	c299                	beqz	a3,480 <printint+0x16>
 47c:	0605cc63          	bltz	a1,4f4 <printint+0x8a>
  neg = 0;
 480:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 482:	fb840313          	addi	t1,s0,-72
  neg = 0;
 486:	869a                	mv	a3,t1
  i = 0;
 488:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 48a:	00000817          	auipc	a6,0x0
 48e:	56680813          	addi	a6,a6,1382 # 9f0 <digits>
 492:	88be                	mv	a7,a5
 494:	0017851b          	addiw	a0,a5,1
 498:	87aa                	mv	a5,a0
 49a:	02c5f733          	remu	a4,a1,a2
 49e:	9742                	add	a4,a4,a6
 4a0:	00074703          	lbu	a4,0(a4)
 4a4:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4a8:	872e                	mv	a4,a1
 4aa:	02c5d5b3          	divu	a1,a1,a2
 4ae:	0685                	addi	a3,a3,1
 4b0:	fec771e3          	bgeu	a4,a2,492 <printint+0x28>
  if (neg)
 4b4:	000e0c63          	beqz	t3,4cc <printint+0x62>
    buf[i++] = '-';
 4b8:	fd050793          	addi	a5,a0,-48
 4bc:	00878533          	add	a0,a5,s0
 4c0:	02d00793          	li	a5,45
 4c4:	fef50423          	sb	a5,-24(a0)
 4c8:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 4cc:	fff7899b          	addiw	s3,a5,-1
 4d0:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4d4:	fff4c583          	lbu	a1,-1(s1)
 4d8:	854a                	mv	a0,s2
 4da:	f73ff0ef          	jal	44c <putc>
  while (--i >= 0)
 4de:	39fd                	addiw	s3,s3,-1
 4e0:	14fd                	addi	s1,s1,-1
 4e2:	fe09d9e3          	bgez	s3,4d4 <printint+0x6a>
}
 4e6:	60a6                	ld	ra,72(sp)
 4e8:	6406                	ld	s0,64(sp)
 4ea:	74e2                	ld	s1,56(sp)
 4ec:	7942                	ld	s2,48(sp)
 4ee:	79a2                	ld	s3,40(sp)
 4f0:	6161                	addi	sp,sp,80
 4f2:	8082                	ret
    x = -xx;
 4f4:	40b005b3          	neg	a1,a1
    neg = 1;
 4f8:	4e05                	li	t3,1
    x = -xx;
 4fa:	b761                	j	482 <printint+0x18>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	711d                	addi	sp,sp,-96
 4fe:	ec86                	sd	ra,88(sp)
 500:	e8a2                	sd	s0,80(sp)
 502:	e4a6                	sd	s1,72(sp)
 504:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 506:	0005c483          	lbu	s1,0(a1)
 50a:	28048463          	beqz	s1,792 <vprintf+0x296>
 50e:	e0ca                	sd	s2,64(sp)
 510:	fc4e                	sd	s3,56(sp)
 512:	f852                	sd	s4,48(sp)
 514:	f456                	sd	s5,40(sp)
 516:	f05a                	sd	s6,32(sp)
 518:	ec5e                	sd	s7,24(sp)
 51a:	e862                	sd	s8,16(sp)
 51c:	e466                	sd	s9,8(sp)
 51e:	8b2a                	mv	s6,a0
 520:	8a2e                	mv	s4,a1
 522:	8bb2                	mv	s7,a2
  state = 0;
 524:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 526:	4901                	li	s2,0
 528:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 52a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 52e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 532:	06c00c93          	li	s9,108
 536:	a00d                	j	558 <vprintf+0x5c>
        putc(fd, c0);
 538:	85a6                	mv	a1,s1
 53a:	855a                	mv	a0,s6
 53c:	f11ff0ef          	jal	44c <putc>
 540:	a019                	j	546 <vprintf+0x4a>
    } else if (state == '%') {
 542:	03598363          	beq	s3,s5,568 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 546:	0019079b          	addiw	a5,s2,1
 54a:	893e                	mv	s2,a5
 54c:	873e                	mv	a4,a5
 54e:	97d2                	add	a5,a5,s4
 550:	0007c483          	lbu	s1,0(a5)
 554:	22048763          	beqz	s1,782 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 558:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 55c:	fe0993e3          	bnez	s3,542 <vprintf+0x46>
      if (c0 == '%') {
 560:	fd579ce3          	bne	a5,s5,538 <vprintf+0x3c>
        state = '%';
 564:	89be                	mv	s3,a5
 566:	b7c5                	j	546 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 568:	00ea06b3          	add	a3,s4,a4
 56c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 570:	8636                	mv	a2,a3
      if (c1)
 572:	c681                	beqz	a3,57a <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 574:	9752                	add	a4,a4,s4
 576:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 57a:	05878263          	beq	a5,s8,5be <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 57e:	05978c63          	beq	a5,s9,5d6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 582:	07500713          	li	a4,117
 586:	0ee78663          	beq	a5,a4,672 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 58a:	07800713          	li	a4,120
 58e:	12e78863          	beq	a5,a4,6be <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 592:	07000713          	li	a4,112
 596:	14e78d63          	beq	a5,a4,6f0 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 59a:	06300713          	li	a4,99
 59e:	18e78c63          	beq	a5,a4,736 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5a2:	07300713          	li	a4,115
 5a6:	1ae78263          	beq	a5,a4,74a <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5aa:	02500713          	li	a4,37
 5ae:	04e79463          	bne	a5,a4,5f6 <vprintf+0xfa>
        putc(fd, '%');
 5b2:	85ba                	mv	a1,a4
 5b4:	855a                	mv	a0,s6
 5b6:	e97ff0ef          	jal	44c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b769                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	e9fff0ef          	jal	46a <printint>
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	bf8d                	j	546 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 5d6:	06400793          	li	a5,100
 5da:	02f68963          	beq	a3,a5,60c <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5de:	06c00793          	li	a5,108
 5e2:	04f68263          	beq	a3,a5,626 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 5e6:	07500793          	li	a5,117
 5ea:	0af68063          	beq	a3,a5,68a <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 5ee:	07800793          	li	a5,120
 5f2:	0ef68263          	beq	a3,a5,6d6 <vprintf+0x1da>
        putc(fd, '%');
 5f6:	02500593          	li	a1,37
 5fa:	855a                	mv	a0,s6
 5fc:	e51ff0ef          	jal	44c <putc>
        putc(fd, c0);
 600:	85a6                	mv	a1,s1
 602:	855a                	mv	a0,s6
 604:	e49ff0ef          	jal	44c <putc>
      state = 0;
 608:	4981                	li	s3,0
 60a:	bf35                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	008b8493          	addi	s1,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000bb583          	ld	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e51ff0ef          	jal	46a <printint>
        i += 1;
 61e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
        i += 1;
 624:	b70d                	j	546 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 626:	06400793          	li	a5,100
 62a:	02f60763          	beq	a2,a5,658 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 62e:	07500793          	li	a5,117
 632:	06f60963          	beq	a2,a5,6a4 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 636:	07800793          	li	a5,120
 63a:	faf61ee3          	bne	a2,a5,5f6 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4641                	li	a2,16
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e1fff0ef          	jal	46a <printint>
        i += 2;
 650:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	bdc5                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	008b8493          	addi	s1,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000bb583          	ld	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	e05ff0ef          	jal	46a <printint>
        i += 2;
 66a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
        i += 2;
 670:	bdd9                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 672:	008b8493          	addi	s1,s7,8
 676:	4681                	li	a3,0
 678:	4629                	li	a2,10
 67a:	000be583          	lwu	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	debff0ef          	jal	46a <printint>
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
 688:	bd7d                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4681                	li	a3,0
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	dd3ff0ef          	jal	46a <printint>
        i += 1;
 69c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 1;
 6a2:	b555                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	008b8493          	addi	s1,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000bb583          	ld	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	db9ff0ef          	jal	46a <printint>
        i += 2;
 6b6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b8:	8ba6                	mv	s7,s1
      state = 0;
 6ba:	4981                	li	s3,0
        i += 2;
 6bc:	b569                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6be:	008b8493          	addi	s1,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4641                	li	a2,16
 6c6:	000be583          	lwu	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	d9fff0ef          	jal	46a <printint>
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd8d                	j	546 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	008b8493          	addi	s1,s7,8
 6da:	4681                	li	a3,0
 6dc:	4641                	li	a2,16
 6de:	000bb583          	ld	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	d87ff0ef          	jal	46a <printint>
        i += 1;
 6e8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ea:	8ba6                	mv	s7,s1
      state = 0;
 6ec:	4981                	li	s3,0
        i += 1;
 6ee:	bda1                	j	546 <vprintf+0x4a>
 6f0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f2:	008b8d13          	addi	s10,s7,8
 6f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fa:	03000593          	li	a1,48
 6fe:	855a                	mv	a0,s6
 700:	d4dff0ef          	jal	44c <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	855a                	mv	a0,s6
 70a:	d43ff0ef          	jal	44c <putc>
 70e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 710:	00000b97          	auipc	s7,0x0
 714:	2e0b8b93          	addi	s7,s7,736 # 9f0 <digits>
 718:	03c9d793          	srli	a5,s3,0x3c
 71c:	97de                	add	a5,a5,s7
 71e:	0007c583          	lbu	a1,0(a5)
 722:	855a                	mv	a0,s6
 724:	d29ff0ef          	jal	44c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 728:	0992                	slli	s3,s3,0x4
 72a:	34fd                	addiw	s1,s1,-1
 72c:	f4f5                	bnez	s1,718 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 72e:	8bea                	mv	s7,s10
      state = 0;
 730:	4981                	li	s3,0
 732:	6d02                	ld	s10,0(sp)
 734:	bd09                	j	546 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 736:	008b8493          	addi	s1,s7,8
 73a:	000bc583          	lbu	a1,0(s7)
 73e:	855a                	mv	a0,s6
 740:	d0dff0ef          	jal	44c <putc>
 744:	8ba6                	mv	s7,s1
      state = 0;
 746:	4981                	li	s3,0
 748:	bbfd                	j	546 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 74a:	008b8993          	addi	s3,s7,8
 74e:	000bb483          	ld	s1,0(s7)
 752:	cc91                	beqz	s1,76e <vprintf+0x272>
        for (; *s; s++)
 754:	0004c583          	lbu	a1,0(s1)
 758:	c195                	beqz	a1,77c <vprintf+0x280>
          putc(fd, *s);
 75a:	855a                	mv	a0,s6
 75c:	cf1ff0ef          	jal	44c <putc>
        for (; *s; s++)
 760:	0485                	addi	s1,s1,1
 762:	0004c583          	lbu	a1,0(s1)
 766:	f9f5                	bnez	a1,75a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 768:	8bce                	mv	s7,s3
      state = 0;
 76a:	4981                	li	s3,0
 76c:	bbe9                	j	546 <vprintf+0x4a>
          s = "(null)";
 76e:	00000497          	auipc	s1,0x0
 772:	27a48493          	addi	s1,s1,634 # 9e8 <malloc+0x16a>
        for (; *s; s++)
 776:	02800593          	li	a1,40
 77a:	b7c5                	j	75a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	b3d9                	j	546 <vprintf+0x4a>
 782:	6906                	ld	s2,64(sp)
 784:	79e2                	ld	s3,56(sp)
 786:	7a42                	ld	s4,48(sp)
 788:	7aa2                	ld	s5,40(sp)
 78a:	7b02                	ld	s6,32(sp)
 78c:	6be2                	ld	s7,24(sp)
 78e:	6c42                	ld	s8,16(sp)
 790:	6ca2                	ld	s9,8(sp)
    }
  }
}
 792:	60e6                	ld	ra,88(sp)
 794:	6446                	ld	s0,80(sp)
 796:	64a6                	ld	s1,72(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret

000000000000079c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79c:	715d                	addi	sp,sp,-80
 79e:	ec06                	sd	ra,24(sp)
 7a0:	e822                	sd	s0,16(sp)
 7a2:	1000                	addi	s0,sp,32
 7a4:	e010                	sd	a2,0(s0)
 7a6:	e414                	sd	a3,8(s0)
 7a8:	e818                	sd	a4,16(s0)
 7aa:	ec1c                	sd	a5,24(s0)
 7ac:	03043023          	sd	a6,32(s0)
 7b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	8622                	mv	a2,s0
 7b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ba:	d43ff0ef          	jal	4fc <vprintf>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6161                	addi	sp,sp,80
 7c4:	8082                	ret

00000000000007c6 <printf>:

void
printf(const char *fmt, ...)
{
 7c6:	711d                	addi	sp,sp,-96
 7c8:	ec06                	sd	ra,24(sp)
 7ca:	e822                	sd	s0,16(sp)
 7cc:	1000                	addi	s0,sp,32
 7ce:	e40c                	sd	a1,8(s0)
 7d0:	e810                	sd	a2,16(s0)
 7d2:	ec14                	sd	a3,24(s0)
 7d4:	f018                	sd	a4,32(s0)
 7d6:	f41c                	sd	a5,40(s0)
 7d8:	03043823          	sd	a6,48(s0)
 7dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e0:	00840613          	addi	a2,s0,8
 7e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7e8:	85aa                	mv	a1,a0
 7ea:	4505                	li	a0,1
 7ec:	d11ff0ef          	jal	4fc <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6125                	addi	sp,sp,96
 7f6:	8082                	ret

00000000000007f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f8:	1141                	addi	sp,sp,-16
 7fa:	e406                	sd	ra,8(sp)
 7fc:	e022                	sd	s0,0(sp)
 7fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 800:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	00001797          	auipc	a5,0x1
 808:	80c7b783          	ld	a5,-2036(a5) # 1010 <freep>
 80c:	a02d                	j	836 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 80e:	4618                	lw	a4,8(a2)
 810:	9f2d                	addw	a4,a4,a1
 812:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	6398                	ld	a4,0(a5)
 818:	6310                	ld	a2,0(a4)
 81a:	a83d                	j	858 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 81c:	ff852703          	lw	a4,-8(a0)
 820:	9f31                	addw	a4,a4,a2
 822:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 824:	ff053683          	ld	a3,-16(a0)
 828:	a091                	j	86c <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 82a:	6398                	ld	a4,0(a5)
 82c:	00e7e463          	bltu	a5,a4,834 <free+0x3c>
 830:	00e6ea63          	bltu	a3,a4,844 <free+0x4c>
{
 834:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	fed7fae3          	bgeu	a5,a3,82a <free+0x32>
 83a:	6398                	ld	a4,0(a5)
 83c:	00e6e463          	bltu	a3,a4,844 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	fee7eae3          	bltu	a5,a4,834 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 844:	ff852583          	lw	a1,-8(a0)
 848:	6390                	ld	a2,0(a5)
 84a:	02059813          	slli	a6,a1,0x20
 84e:	01c85713          	srli	a4,a6,0x1c
 852:	9736                	add	a4,a4,a3
 854:	fae60de3          	beq	a2,a4,80e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 858:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 85c:	4790                	lw	a2,8(a5)
 85e:	02061593          	slli	a1,a2,0x20
 862:	01c5d713          	srli	a4,a1,0x1c
 866:	973e                	add	a4,a4,a5
 868:	fae68ae3          	beq	a3,a4,81c <free+0x24>
    p->s.ptr = bp->s.ptr;
 86c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86e:	00000717          	auipc	a4,0x0
 872:	7af73123          	sd	a5,1954(a4) # 1010 <freep>
}
 876:	60a2                	ld	ra,8(sp)
 878:	6402                	ld	s0,0(sp)
 87a:	0141                	addi	sp,sp,16
 87c:	8082                	ret

000000000000087e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 87e:	7139                	addi	sp,sp,-64
 880:	fc06                	sd	ra,56(sp)
 882:	f822                	sd	s0,48(sp)
 884:	f04a                	sd	s2,32(sp)
 886:	ec4e                	sd	s3,24(sp)
 888:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 88a:	02051993          	slli	s3,a0,0x20
 88e:	0209d993          	srli	s3,s3,0x20
 892:	09bd                	addi	s3,s3,15
 894:	0049d993          	srli	s3,s3,0x4
 898:	2985                	addiw	s3,s3,1
 89a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 89c:	00000517          	auipc	a0,0x0
 8a0:	77453503          	ld	a0,1908(a0) # 1010 <freep>
 8a4:	c905                	beqz	a0,8d4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8a6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8a8:	4798                	lw	a4,8(a5)
 8aa:	09377663          	bgeu	a4,s3,936 <malloc+0xb8>
 8ae:	f426                	sd	s1,40(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8b6:	8a4e                	mv	s4,s3
 8b8:	6705                	lui	a4,0x1
 8ba:	00e9f363          	bgeu	s3,a4,8c0 <malloc+0x42>
 8be:	6a05                	lui	s4,0x1
 8c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8c8:	00000497          	auipc	s1,0x0
 8cc:	74848493          	addi	s1,s1,1864 # 1010 <freep>
  if (p == SBRK_ERROR)
 8d0:	5afd                	li	s5,-1
 8d2:	a83d                	j	910 <malloc+0x92>
 8d4:	f426                	sd	s1,40(sp)
 8d6:	e852                	sd	s4,16(sp)
 8d8:	e456                	sd	s5,8(sp)
 8da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8dc:	00000797          	auipc	a5,0x0
 8e0:	74478793          	addi	a5,a5,1860 # 1020 <base>
 8e4:	00000717          	auipc	a4,0x0
 8e8:	72f73623          	sd	a5,1836(a4) # 1010 <freep>
 8ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ee:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8f2:	b7d1                	j	8b6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	e118                	sd	a4,0(a0)
 8f8:	a899                	j	94e <malloc+0xd0>
  hp->s.size = nu;
 8fa:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8fe:	0541                	addi	a0,a0,16
 900:	ef9ff0ef          	jal	7f8 <free>
  return freep;
 904:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 906:	c125                	beqz	a0,966 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 908:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 90a:	4798                	lw	a4,8(a5)
 90c:	03277163          	bgeu	a4,s2,92e <malloc+0xb0>
    if (p == freep)
 910:	6098                	ld	a4,0(s1)
 912:	853e                	mv	a0,a5
 914:	fef71ae3          	bne	a4,a5,908 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 918:	8552                	mv	a0,s4
 91a:	a37ff0ef          	jal	350 <sbrk>
  if (p == SBRK_ERROR)
 91e:	fd551ee3          	bne	a0,s5,8fa <malloc+0x7c>
        return 0;
 922:	4501                	li	a0,0
 924:	74a2                	ld	s1,40(sp)
 926:	6a42                	ld	s4,16(sp)
 928:	6aa2                	ld	s5,8(sp)
 92a:	6b02                	ld	s6,0(sp)
 92c:	a03d                	j	95a <malloc+0xdc>
 92e:	74a2                	ld	s1,40(sp)
 930:	6a42                	ld	s4,16(sp)
 932:	6aa2                	ld	s5,8(sp)
 934:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 936:	fae90fe3          	beq	s2,a4,8f4 <malloc+0x76>
        p->s.size -= nunits;
 93a:	4137073b          	subw	a4,a4,s3
 93e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 940:	02071693          	slli	a3,a4,0x20
 944:	01c6d713          	srli	a4,a3,0x1c
 948:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94e:	00000717          	auipc	a4,0x0
 952:	6ca73123          	sd	a0,1730(a4) # 1010 <freep>
      return (void *)(p + 1);
 956:	01078513          	addi	a0,a5,16
  }
}
 95a:	70e2                	ld	ra,56(sp)
 95c:	7442                	ld	s0,48(sp)
 95e:	7902                	ld	s2,32(sp)
 960:	69e2                	ld	s3,24(sp)
 962:	6121                	addi	sp,sp,64
 964:	8082                	ret
 966:	74a2                	ld	s1,40(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
 96e:	b7f5                	j	95a <malloc+0xdc>
