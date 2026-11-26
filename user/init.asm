
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
  12:	9c250513          	addi	a0,a0,-1598 # 9d0 <malloc+0x104>
  16:	37a000ef          	jal	390 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0); // stdout
  1e:	4501                	li	a0,0
  20:	3a8000ef          	jal	3c8 <dup>
  dup(0); // stderr
  24:	4501                	li	a0,0
  26:	3a2000ef          	jal	3c8 <dup>

  for (;;) {
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	9ae90913          	addi	s2,s2,-1618 # 9d8 <malloc+0x10c>
  32:	854a                	mv	a0,s2
  34:	7e4000ef          	jal	818 <printf>
    pid = fork();
  38:	310000ef          	jal	348 <fork>
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
  46:	312000ef          	jal	358 <wait>
      if (wpid == pid) {
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if (wpid < 0) {
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	9d650513          	addi	a0,a0,-1578 # a28 <malloc+0x15c>
  5a:	7be000ef          	jal	818 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	2f0000ef          	jal	350 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	96850513          	addi	a0,a0,-1688 # 9d0 <malloc+0x104>
  70:	328000ef          	jal	398 <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	95a50513          	addi	a0,a0,-1702 # 9d0 <malloc+0x104>
  7e:	312000ef          	jal	390 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	96c50513          	addi	a0,a0,-1684 # 9f0 <malloc+0x124>
  8c:	78c000ef          	jal	818 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2be000ef          	jal	350 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	96a50513          	addi	a0,a0,-1686 # a08 <malloc+0x13c>
  a6:	2e2000ef          	jal	388 <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	96650513          	addi	a0,a0,-1690 # a10 <malloc+0x144>
  b2:	766000ef          	jal	818 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	298000ef          	jal	350 <exit>

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
  c8:	288000ef          	jal	350 <exit>

00000000000000cc <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e422                	sd	s0,8(sp)
  d0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  d2:	87aa                	mv	a5,a0
  d4:	0585                	addi	a1,a1,1
  d6:	0785                	addi	a5,a5,1
  d8:	fff5c703          	lbu	a4,-1(a1)
  dc:	fee78fa3          	sb	a4,-1(a5)
  e0:	fb75                	bnez	a4,d4 <strcpy+0x8>
    ;
  return os;
}
  e2:	6422                	ld	s0,8(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e422                	sd	s0,8(sp)
  ec:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb91                	beqz	a5,106 <strcmp+0x1e>
  f4:	0005c703          	lbu	a4,0(a1)
  f8:	00f71763          	bne	a4,a5,106 <strcmp+0x1e>
    p++, q++;
  fc:	0505                	addi	a0,a0,1
  fe:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	fbe5                	bnez	a5,f4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 106:	0005c503          	lbu	a0,0(a1)
}
 10a:	40a7853b          	subw	a0,a5,a0
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strlen>:

uint
strlen(const char *s)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cf91                	beqz	a5,13a <strlen+0x26>
 120:	0505                	addi	a0,a0,1
 122:	87aa                	mv	a5,a0
 124:	86be                	mv	a3,a5
 126:	0785                	addi	a5,a5,1
 128:	fff7c703          	lbu	a4,-1(a5)
 12c:	ff65                	bnez	a4,124 <strlen+0x10>
 12e:	40a6853b          	subw	a0,a3,a0
 132:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  for (n = 0; s[n]; n++)
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strlen+0x20>

000000000000013e <memset>:

void *
memset(void *dst, int c, uint n)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 144:	ca19                	beqz	a2,15a <memset+0x1c>
 146:	87aa                	mv	a5,a0
 148:	1602                	slli	a2,a2,0x20
 14a:	9201                	srli	a2,a2,0x20
 14c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 150:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 154:	0785                	addi	a5,a5,1
 156:	fee79de3          	bne	a5,a4,150 <memset+0x12>
  }
  return dst;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strchr>:

char *
strchr(const char *s, char c)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  for (; *s; s++)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb99                	beqz	a5,180 <strchr+0x20>
    if (*s == c)
 16c:	00f58763          	beq	a1,a5,17a <strchr+0x1a>
  for (; *s; s++)
 170:	0505                	addi	a0,a0,1
 172:	00054783          	lbu	a5,0(a0)
 176:	fbfd                	bnez	a5,16c <strchr+0xc>
      return (char *)s;
  return 0;
 178:	4501                	li	a0,0
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret
  return 0;
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strchr+0x1a>

0000000000000184 <gets>:

char *
gets(char *buf, int max)
{
 184:	711d                	addi	sp,sp,-96
 186:	ec86                	sd	ra,88(sp)
 188:	e8a2                	sd	s0,80(sp)
 18a:	e4a6                	sd	s1,72(sp)
 18c:	e0ca                	sd	s2,64(sp)
 18e:	fc4e                	sd	s3,56(sp)
 190:	f852                	sd	s4,48(sp)
 192:	f456                	sd	s5,40(sp)
 194:	f05a                	sd	s6,32(sp)
 196:	ec5e                	sd	s7,24(sp)
 198:	1080                	addi	s0,sp,96
 19a:	8baa                	mv	s7,a0
 19c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 19e:	892a                	mv	s2,a0
 1a0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1a2:	4aa9                	li	s5,10
 1a4:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1a6:	89a6                	mv	s3,s1
 1a8:	2485                	addiw	s1,s1,1
 1aa:	0344d663          	bge	s1,s4,1d6 <gets+0x52>
    cc = read(0, &c, 1);
 1ae:	4605                	li	a2,1
 1b0:	faf40593          	addi	a1,s0,-81
 1b4:	4501                	li	a0,0
 1b6:	1b2000ef          	jal	368 <read>
    if (cc < 1)
 1ba:	00a05e63          	blez	a0,1d6 <gets+0x52>
    buf[i++] = c;
 1be:	faf44783          	lbu	a5,-81(s0)
 1c2:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1c6:	01578763          	beq	a5,s5,1d4 <gets+0x50>
 1ca:	0905                	addi	s2,s2,1
 1cc:	fd679de3          	bne	a5,s6,1a6 <gets+0x22>
    buf[i++] = c;
 1d0:	89a6                	mv	s3,s1
 1d2:	a011                	j	1d6 <gets+0x52>
 1d4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1d6:	99de                	add	s3,s3,s7
 1d8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1dc:	855e                	mv	a0,s7
 1de:	60e6                	ld	ra,88(sp)
 1e0:	6446                	ld	s0,80(sp)
 1e2:	64a6                	ld	s1,72(sp)
 1e4:	6906                	ld	s2,64(sp)
 1e6:	79e2                	ld	s3,56(sp)
 1e8:	7a42                	ld	s4,48(sp)
 1ea:	7aa2                	ld	s5,40(sp)
 1ec:	7b02                	ld	s6,32(sp)
 1ee:	6be2                	ld	s7,24(sp)
 1f0:	6125                	addi	sp,sp,96
 1f2:	8082                	ret

00000000000001f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f4:	1101                	addi	sp,sp,-32
 1f6:	ec06                	sd	ra,24(sp)
 1f8:	e822                	sd	s0,16(sp)
 1fa:	e04a                	sd	s2,0(sp)
 1fc:	1000                	addi	s0,sp,32
 1fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 200:	4581                	li	a1,0
 202:	18e000ef          	jal	390 <open>
  if (fd < 0)
 206:	02054263          	bltz	a0,22a <stat+0x36>
 20a:	e426                	sd	s1,8(sp)
 20c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 20e:	85ca                	mv	a1,s2
 210:	198000ef          	jal	3a8 <fstat>
 214:	892a                	mv	s2,a0
  close(fd);
 216:	8526                	mv	a0,s1
 218:	160000ef          	jal	378 <close>
  return r;
 21c:	64a2                	ld	s1,8(sp)
}
 21e:	854a                	mv	a0,s2
 220:	60e2                	ld	ra,24(sp)
 222:	6442                	ld	s0,16(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	addi	sp,sp,32
 228:	8082                	ret
    return -1;
 22a:	597d                	li	s2,-1
 22c:	bfcd                	j	21e <stat+0x2a>

000000000000022e <atoi>:

int
atoi(const char *s)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 234:	00054683          	lbu	a3,0(a0)
 238:	fd06879b          	addiw	a5,a3,-48
 23c:	0ff7f793          	zext.b	a5,a5
 240:	4625                	li	a2,9
 242:	02f66863          	bltu	a2,a5,272 <atoi+0x44>
 246:	872a                	mv	a4,a0
  n = 0;
 248:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 24a:	0705                	addi	a4,a4,1
 24c:	0025179b          	slliw	a5,a0,0x2
 250:	9fa9                	addw	a5,a5,a0
 252:	0017979b          	slliw	a5,a5,0x1
 256:	9fb5                	addw	a5,a5,a3
 258:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 25c:	00074683          	lbu	a3,0(a4)
 260:	fd06879b          	addiw	a5,a3,-48
 264:	0ff7f793          	zext.b	a5,a5
 268:	fef671e3          	bgeu	a2,a5,24a <atoi+0x1c>
  return n;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  n = 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <atoi+0x3e>

0000000000000276 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 27c:	02b57463          	bgeu	a0,a1,2a4 <memmove+0x2e>
    while (n-- > 0)
 280:	00c05f63          	blez	a2,29e <memmove+0x28>
 284:	1602                	slli	a2,a2,0x20
 286:	9201                	srli	a2,a2,0x20
 288:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 28c:	872a                	mv	a4,a0
      *dst++ = *src++;
 28e:	0585                	addi	a1,a1,1
 290:	0705                	addi	a4,a4,1
 292:	fff5c683          	lbu	a3,-1(a1)
 296:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 29a:	fef71ae3          	bne	a4,a5,28e <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
    dst += n;
 2a4:	00c50733          	add	a4,a0,a2
    src += n;
 2a8:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2aa:	fec05ae3          	blez	a2,29e <memmove+0x28>
 2ae:	fff6079b          	addiw	a5,a2,-1
 2b2:	1782                	slli	a5,a5,0x20
 2b4:	9381                	srli	a5,a5,0x20
 2b6:	fff7c793          	not	a5,a5
 2ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2bc:	15fd                	addi	a1,a1,-1
 2be:	177d                	addi	a4,a4,-1
 2c0:	0005c683          	lbu	a3,0(a1)
 2c4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x46>
 2cc:	bfc9                	j	29e <memmove+0x28>

00000000000002ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e422                	sd	s0,8(sp)
 2d2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d4:	ca05                	beqz	a2,304 <memcmp+0x36>
 2d6:	fff6069b          	addiw	a3,a2,-1
 2da:	1682                	slli	a3,a3,0x20
 2dc:	9281                	srli	a3,a3,0x20
 2de:	0685                	addi	a3,a3,1
 2e0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	0005c703          	lbu	a4,0(a1)
 2ea:	00e79863          	bne	a5,a4,2fa <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ee:	0505                	addi	a0,a0,1
    p2++;
 2f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2f2:	fed518e3          	bne	a0,a3,2e2 <memcmp+0x14>
  }
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	a019                	j	2fe <memcmp+0x30>
      return *p1 - *p2;
 2fa:	40e7853b          	subw	a0,a5,a4
}
 2fe:	6422                	ld	s0,8(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
  return 0;
 304:	4501                	li	a0,0
 306:	bfe5                	j	2fe <memcmp+0x30>

0000000000000308 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 308:	1141                	addi	sp,sp,-16
 30a:	e406                	sd	ra,8(sp)
 30c:	e022                	sd	s0,0(sp)
 30e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 310:	f67ff0ef          	jal	276 <memmove>
}
 314:	60a2                	ld	ra,8(sp)
 316:	6402                	ld	s0,0(sp)
 318:	0141                	addi	sp,sp,16
 31a:	8082                	ret

000000000000031c <sbrk>:

char *
sbrk(int n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 324:	4585                	li	a1,1
 326:	0b2000ef          	jal	3d8 <sys_sbrk>
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <sbrklazy>:

char *
sbrklazy(int n)
{
 332:	1141                	addi	sp,sp,-16
 334:	e406                	sd	ra,8(sp)
 336:	e022                	sd	s0,0(sp)
 338:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 33a:	4589                	li	a1,2
 33c:	09c000ef          	jal	3d8 <sys_sbrk>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <ps>:
.global ps
ps:
 li a7, SYS_ps
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 400:	48e1                	li	a7,24
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 408:	48e5                	li	a7,25
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 410:	48e9                	li	a7,26
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <trace>:
.global trace
trace:
 li a7, SYS_trace
 418:	48ed                	li	a7,27
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 420:	48f1                	li	a7,28
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 428:	48f5                	li	a7,29
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 430:	48f9                	li	a7,30
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 438:	48fd                	li	a7,31
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 440:	02000893          	li	a7,32
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <halt>:
.global halt
halt:
 li a7, SYS_halt
 44a:	02100893          	li	a7,33
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 454:	02200893          	li	a7,34
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 45e:	02300893          	li	a7,35
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 468:	02400893          	li	a7,36
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 472:	02500893          	li	a7,37
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 47c:	02600893          	li	a7,38
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 486:	02700893          	li	a7,39
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 490:	1101                	addi	sp,sp,-32
 492:	ec06                	sd	ra,24(sp)
 494:	e822                	sd	s0,16(sp)
 496:	1000                	addi	s0,sp,32
 498:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 49c:	4605                	li	a2,1
 49e:	fef40593          	addi	a1,s0,-17
 4a2:	ecfff0ef          	jal	370 <write>
}
 4a6:	60e2                	ld	ra,24(sp)
 4a8:	6442                	ld	s0,16(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret

00000000000004ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ae:	715d                	addi	sp,sp,-80
 4b0:	e486                	sd	ra,72(sp)
 4b2:	e0a2                	sd	s0,64(sp)
 4b4:	f84a                	sd	s2,48(sp)
 4b6:	0880                	addi	s0,sp,80
 4b8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4ba:	c299                	beqz	a3,4c0 <printint+0x12>
 4bc:	0805c363          	bltz	a1,542 <printint+0x94>
  neg = 0;
 4c0:	4881                	li	a7,0
 4c2:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4c6:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4c8:	00000517          	auipc	a0,0x0
 4cc:	58850513          	addi	a0,a0,1416 # a50 <digits>
 4d0:	883e                	mv	a6,a5
 4d2:	2785                	addiw	a5,a5,1
 4d4:	02c5f733          	remu	a4,a1,a2
 4d8:	972a                	add	a4,a4,a0
 4da:	00074703          	lbu	a4,0(a4)
 4de:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4e2:	872e                	mv	a4,a1
 4e4:	02c5d5b3          	divu	a1,a1,a2
 4e8:	0685                	addi	a3,a3,1
 4ea:	fec773e3          	bgeu	a4,a2,4d0 <printint+0x22>
  if (neg)
 4ee:	00088b63          	beqz	a7,504 <printint+0x56>
    buf[i++] = '-';
 4f2:	fd078793          	addi	a5,a5,-48
 4f6:	97a2                	add	a5,a5,s0
 4f8:	02d00713          	li	a4,45
 4fc:	fee78423          	sb	a4,-24(a5)
 500:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 504:	02f05a63          	blez	a5,538 <printint+0x8a>
 508:	fc26                	sd	s1,56(sp)
 50a:	f44e                	sd	s3,40(sp)
 50c:	fb840713          	addi	a4,s0,-72
 510:	00f704b3          	add	s1,a4,a5
 514:	fff70993          	addi	s3,a4,-1
 518:	99be                	add	s3,s3,a5
 51a:	37fd                	addiw	a5,a5,-1
 51c:	1782                	slli	a5,a5,0x20
 51e:	9381                	srli	a5,a5,0x20
 520:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 524:	fff4c583          	lbu	a1,-1(s1)
 528:	854a                	mv	a0,s2
 52a:	f67ff0ef          	jal	490 <putc>
  while (--i >= 0)
 52e:	14fd                	addi	s1,s1,-1
 530:	ff349ae3          	bne	s1,s3,524 <printint+0x76>
 534:	74e2                	ld	s1,56(sp)
 536:	79a2                	ld	s3,40(sp)
}
 538:	60a6                	ld	ra,72(sp)
 53a:	6406                	ld	s0,64(sp)
 53c:	7942                	ld	s2,48(sp)
 53e:	6161                	addi	sp,sp,80
 540:	8082                	ret
    x = -xx;
 542:	40b005b3          	neg	a1,a1
    neg = 1;
 546:	4885                	li	a7,1
    x = -xx;
 548:	bfad                	j	4c2 <printint+0x14>

000000000000054a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 54a:	711d                	addi	sp,sp,-96
 54c:	ec86                	sd	ra,88(sp)
 54e:	e8a2                	sd	s0,80(sp)
 550:	e0ca                	sd	s2,64(sp)
 552:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 554:	0005c903          	lbu	s2,0(a1)
 558:	28090663          	beqz	s2,7e4 <vprintf+0x29a>
 55c:	e4a6                	sd	s1,72(sp)
 55e:	fc4e                	sd	s3,56(sp)
 560:	f852                	sd	s4,48(sp)
 562:	f456                	sd	s5,40(sp)
 564:	f05a                	sd	s6,32(sp)
 566:	ec5e                	sd	s7,24(sp)
 568:	e862                	sd	s8,16(sp)
 56a:	e466                	sd	s9,8(sp)
 56c:	8b2a                	mv	s6,a0
 56e:	8a2e                	mv	s4,a1
 570:	8bb2                	mv	s7,a2
  state = 0;
 572:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 574:	4481                	li	s1,0
 576:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 578:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 57c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 580:	06c00c93          	li	s9,108
 584:	a005                	j	5a4 <vprintf+0x5a>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	f07ff0ef          	jal	490 <putc>
 58e:	a019                	j	594 <vprintf+0x4a>
    } else if (state == '%') {
 590:	03598263          	beq	s3,s5,5b4 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 594:	2485                	addiw	s1,s1,1
 596:	8726                	mv	a4,s1
 598:	009a07b3          	add	a5,s4,s1
 59c:	0007c903          	lbu	s2,0(a5)
 5a0:	22090a63          	beqz	s2,7d4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5a4:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5a8:	fe0994e3          	bnez	s3,590 <vprintf+0x46>
      if (c0 == '%') {
 5ac:	fd579de3          	bne	a5,s5,586 <vprintf+0x3c>
        state = '%';
 5b0:	89be                	mv	s3,a5
 5b2:	b7cd                	j	594 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5b4:	00ea06b3          	add	a3,s4,a4
 5b8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5bc:	8636                	mv	a2,a3
      if (c1)
 5be:	c681                	beqz	a3,5c6 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5c0:	9752                	add	a4,a4,s4
 5c2:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5c6:	05878363          	beq	a5,s8,60c <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5ca:	05978d63          	beq	a5,s9,624 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5ce:	07500713          	li	a4,117
 5d2:	0ee78763          	beq	a5,a4,6c0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5d6:	07800713          	li	a4,120
 5da:	12e78963          	beq	a5,a4,70c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5de:	07000713          	li	a4,112
 5e2:	14e78e63          	beq	a5,a4,73e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5e6:	06300713          	li	a4,99
 5ea:	18e78e63          	beq	a5,a4,786 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5ee:	07300713          	li	a4,115
 5f2:	1ae78463          	beq	a5,a4,79a <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5f6:	02500713          	li	a4,37
 5fa:	04e79563          	bne	a5,a4,644 <vprintf+0xfa>
        putc(fd, '%');
 5fe:	02500593          	li	a1,37
 602:	855a                	mv	a0,s6
 604:	e8dff0ef          	jal	490 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 608:	4981                	li	s3,0
 60a:	b769                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 60c:	008b8913          	addi	s2,s7,8
 610:	4685                	li	a3,1
 612:	4629                	li	a2,10
 614:	000ba583          	lw	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e95ff0ef          	jal	4ae <printint>
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	bf8d                	j	594 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 624:	06400793          	li	a5,100
 628:	02f68963          	beq	a3,a5,65a <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 62c:	06c00793          	li	a5,108
 630:	04f68263          	beq	a3,a5,674 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 634:	07500793          	li	a5,117
 638:	0af68063          	beq	a3,a5,6d8 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 63c:	07800793          	li	a5,120
 640:	0ef68263          	beq	a3,a5,724 <vprintf+0x1da>
        putc(fd, '%');
 644:	02500593          	li	a1,37
 648:	855a                	mv	a0,s6
 64a:	e47ff0ef          	jal	490 <putc>
        putc(fd, c0);
 64e:	85ca                	mv	a1,s2
 650:	855a                	mv	a0,s6
 652:	e3fff0ef          	jal	490 <putc>
      state = 0;
 656:	4981                	li	s3,0
 658:	bf35                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4685                	li	a3,1
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e47ff0ef          	jal	4ae <printint>
        i += 1;
 66c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 1;
 672:	b70d                	j	594 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 674:	06400793          	li	a5,100
 678:	02f60763          	beq	a2,a5,6a6 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 67c:	07500793          	li	a5,117
 680:	06f60963          	beq	a2,a5,6f2 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 684:	07800793          	li	a5,120
 688:	faf61ee3          	bne	a2,a5,644 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4641                	li	a2,16
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	e15ff0ef          	jal	4ae <printint>
        i += 2;
 69e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	bdc5                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4685                	li	a3,1
 6ac:	4629                	li	a2,10
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dfbff0ef          	jal	4ae <printint>
        i += 2;
 6b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 2;
 6be:	bdd9                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4629                	li	a2,10
 6c8:	000be583          	lwu	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	de1ff0ef          	jal	4ae <printint>
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bd7d                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	dc9ff0ef          	jal	4ae <printint>
        i += 1;
 6ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 1;
 6f0:	b555                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4629                	li	a2,10
 6fa:	000bb583          	ld	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	dafff0ef          	jal	4ae <printint>
        i += 2;
 704:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	8bca                	mv	s7,s2
      state = 0;
 708:	4981                	li	s3,0
        i += 2;
 70a:	b569                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 70c:	008b8913          	addi	s2,s7,8
 710:	4681                	li	a3,0
 712:	4641                	li	a2,16
 714:	000be583          	lwu	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	d95ff0ef          	jal	4ae <printint>
 71e:	8bca                	mv	s7,s2
      state = 0;
 720:	4981                	li	s3,0
 722:	bd8d                	j	594 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	008b8913          	addi	s2,s7,8
 728:	4681                	li	a3,0
 72a:	4641                	li	a2,16
 72c:	000bb583          	ld	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	d7dff0ef          	jal	4ae <printint>
        i += 1;
 736:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
        i += 1;
 73c:	bda1                	j	594 <vprintf+0x4a>
 73e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 740:	008b8d13          	addi	s10,s7,8
 744:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 748:	03000593          	li	a1,48
 74c:	855a                	mv	a0,s6
 74e:	d43ff0ef          	jal	490 <putc>
  putc(fd, 'x');
 752:	07800593          	li	a1,120
 756:	855a                	mv	a0,s6
 758:	d39ff0ef          	jal	490 <putc>
 75c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	00000b97          	auipc	s7,0x0
 762:	2f2b8b93          	addi	s7,s7,754 # a50 <digits>
 766:	03c9d793          	srli	a5,s3,0x3c
 76a:	97de                	add	a5,a5,s7
 76c:	0007c583          	lbu	a1,0(a5)
 770:	855a                	mv	a0,s6
 772:	d1fff0ef          	jal	490 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	397d                	addiw	s2,s2,-1
 77a:	fe0916e3          	bnez	s2,766 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 77e:	8bea                	mv	s7,s10
      state = 0;
 780:	4981                	li	s3,0
 782:	6d02                	ld	s10,0(sp)
 784:	bd01                	j	594 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 786:	008b8913          	addi	s2,s7,8
 78a:	000bc583          	lbu	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d01ff0ef          	jal	490 <putc>
 794:	8bca                	mv	s7,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	bbf5                	j	594 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 79a:	008b8993          	addi	s3,s7,8
 79e:	000bb903          	ld	s2,0(s7)
 7a2:	00090f63          	beqz	s2,7c0 <vprintf+0x276>
        for (; *s; s++)
 7a6:	00094583          	lbu	a1,0(s2)
 7aa:	c195                	beqz	a1,7ce <vprintf+0x284>
          putc(fd, *s);
 7ac:	855a                	mv	a0,s6
 7ae:	ce3ff0ef          	jal	490 <putc>
        for (; *s; s++)
 7b2:	0905                	addi	s2,s2,1
 7b4:	00094583          	lbu	a1,0(s2)
 7b8:	f9f5                	bnez	a1,7ac <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	bbd9                	j	594 <vprintf+0x4a>
          s = "(null)";
 7c0:	00000917          	auipc	s2,0x0
 7c4:	28890913          	addi	s2,s2,648 # a48 <malloc+0x17c>
        for (; *s; s++)
 7c8:	02800593          	li	a1,40
 7cc:	b7c5                	j	7ac <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b3c9                	j	594 <vprintf+0x4a>
 7d4:	64a6                	ld	s1,72(sp)
 7d6:	79e2                	ld	s3,56(sp)
 7d8:	7a42                	ld	s4,48(sp)
 7da:	7aa2                	ld	s5,40(sp)
 7dc:	7b02                	ld	s6,32(sp)
 7de:	6be2                	ld	s7,24(sp)
 7e0:	6c42                	ld	s8,16(sp)
 7e2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7e4:	60e6                	ld	ra,88(sp)
 7e6:	6446                	ld	s0,80(sp)
 7e8:	6906                	ld	s2,64(sp)
 7ea:	6125                	addi	sp,sp,96
 7ec:	8082                	ret

00000000000007ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ee:	715d                	addi	sp,sp,-80
 7f0:	ec06                	sd	ra,24(sp)
 7f2:	e822                	sd	s0,16(sp)
 7f4:	1000                	addi	s0,sp,32
 7f6:	e010                	sd	a2,0(s0)
 7f8:	e414                	sd	a3,8(s0)
 7fa:	e818                	sd	a4,16(s0)
 7fc:	ec1c                	sd	a5,24(s0)
 7fe:	03043023          	sd	a6,32(s0)
 802:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 806:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80a:	8622                	mv	a2,s0
 80c:	d3fff0ef          	jal	54a <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6161                	addi	sp,sp,80
 816:	8082                	ret

0000000000000818 <printf>:

void
printf(const char *fmt, ...)
{
 818:	711d                	addi	sp,sp,-96
 81a:	ec06                	sd	ra,24(sp)
 81c:	e822                	sd	s0,16(sp)
 81e:	1000                	addi	s0,sp,32
 820:	e40c                	sd	a1,8(s0)
 822:	e810                	sd	a2,16(s0)
 824:	ec14                	sd	a3,24(s0)
 826:	f018                	sd	a4,32(s0)
 828:	f41c                	sd	a5,40(s0)
 82a:	03043823          	sd	a6,48(s0)
 82e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 832:	00840613          	addi	a2,s0,8
 836:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 83a:	85aa                	mv	a1,a0
 83c:	4505                	li	a0,1
 83e:	d0dff0ef          	jal	54a <vprintf>
}
 842:	60e2                	ld	ra,24(sp)
 844:	6442                	ld	s0,16(sp)
 846:	6125                	addi	sp,sp,96
 848:	8082                	ret

000000000000084a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e422                	sd	s0,8(sp)
 84e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 850:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	00000797          	auipc	a5,0x0
 858:	7bc7b783          	ld	a5,1980(a5) # 1010 <freep>
 85c:	a02d                	j	886 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 85e:	4618                	lw	a4,8(a2)
 860:	9f2d                	addw	a4,a4,a1
 862:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	6310                	ld	a2,0(a4)
 86a:	a83d                	j	8a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 86c:	ff852703          	lw	a4,-8(a0)
 870:	9f31                	addw	a4,a4,a2
 872:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 874:	ff053683          	ld	a3,-16(a0)
 878:	a091                	j	8bc <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	6398                	ld	a4,0(a5)
 87c:	00e7e463          	bltu	a5,a4,884 <free+0x3a>
 880:	00e6ea63          	bltu	a3,a4,894 <free+0x4a>
{
 884:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	fed7fae3          	bgeu	a5,a3,87a <free+0x30>
 88a:	6398                	ld	a4,0(a5)
 88c:	00e6e463          	bltu	a3,a4,894 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	fee7eae3          	bltu	a5,a4,884 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 894:	ff852583          	lw	a1,-8(a0)
 898:	6390                	ld	a2,0(a5)
 89a:	02059813          	slli	a6,a1,0x20
 89e:	01c85713          	srli	a4,a6,0x1c
 8a2:	9736                	add	a4,a4,a3
 8a4:	fae60de3          	beq	a2,a4,85e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8ac:	4790                	lw	a2,8(a5)
 8ae:	02061593          	slli	a1,a2,0x20
 8b2:	01c5d713          	srli	a4,a1,0x1c
 8b6:	973e                	add	a4,a4,a5
 8b8:	fae68ae3          	beq	a3,a4,86c <free+0x22>
    p->s.ptr = bp->s.ptr;
 8bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73923          	sd	a5,1874(a4) # 1010 <freep>
}
 8c6:	6422                	ld	s0,8(sp)
 8c8:	0141                	addi	sp,sp,16
 8ca:	8082                	ret

00000000000008cc <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8cc:	7139                	addi	sp,sp,-64
 8ce:	fc06                	sd	ra,56(sp)
 8d0:	f822                	sd	s0,48(sp)
 8d2:	f426                	sd	s1,40(sp)
 8d4:	ec4e                	sd	s3,24(sp)
 8d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8d8:	02051493          	slli	s1,a0,0x20
 8dc:	9081                	srli	s1,s1,0x20
 8de:	04bd                	addi	s1,s1,15
 8e0:	8091                	srli	s1,s1,0x4
 8e2:	0014899b          	addiw	s3,s1,1
 8e6:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8e8:	00000517          	auipc	a0,0x0
 8ec:	72853503          	ld	a0,1832(a0) # 1010 <freep>
 8f0:	c915                	beqz	a0,924 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f4:	4798                	lw	a4,8(a5)
 8f6:	08977a63          	bgeu	a4,s1,98a <malloc+0xbe>
 8fa:	f04a                	sd	s2,32(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 902:	8a4e                	mv	s4,s3
 904:	0009871b          	sext.w	a4,s3
 908:	6685                	lui	a3,0x1
 90a:	00d77363          	bgeu	a4,a3,910 <malloc+0x44>
 90e:	6a05                	lui	s4,0x1
 910:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 914:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 918:	00000917          	auipc	s2,0x0
 91c:	6f890913          	addi	s2,s2,1784 # 1010 <freep>
  if (p == SBRK_ERROR)
 920:	5afd                	li	s5,-1
 922:	a081                	j	962 <malloc+0x96>
 924:	f04a                	sd	s2,32(sp)
 926:	e852                	sd	s4,16(sp)
 928:	e456                	sd	s5,8(sp)
 92a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 92c:	00000797          	auipc	a5,0x0
 930:	6f478793          	addi	a5,a5,1780 # 1020 <base>
 934:	00000717          	auipc	a4,0x0
 938:	6cf73e23          	sd	a5,1756(a4) # 1010 <freep>
 93c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 942:	b7c1                	j	902 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	e118                	sd	a4,0(a0)
 948:	a8a9                	j	9a2 <malloc+0xd6>
  hp->s.size = nu;
 94a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 94e:	0541                	addi	a0,a0,16
 950:	efbff0ef          	jal	84a <free>
  return freep;
 954:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 958:	c12d                	beqz	a0,9ba <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 95a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 95c:	4798                	lw	a4,8(a5)
 95e:	02977263          	bgeu	a4,s1,982 <malloc+0xb6>
    if (p == freep)
 962:	00093703          	ld	a4,0(s2)
 966:	853e                	mv	a0,a5
 968:	fef719e3          	bne	a4,a5,95a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 96c:	8552                	mv	a0,s4
 96e:	9afff0ef          	jal	31c <sbrk>
  if (p == SBRK_ERROR)
 972:	fd551ce3          	bne	a0,s5,94a <malloc+0x7e>
        return 0;
 976:	4501                	li	a0,0
 978:	7902                	ld	s2,32(sp)
 97a:	6a42                	ld	s4,16(sp)
 97c:	6aa2                	ld	s5,8(sp)
 97e:	6b02                	ld	s6,0(sp)
 980:	a03d                	j	9ae <malloc+0xe2>
 982:	7902                	ld	s2,32(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 98a:	fae48de3          	beq	s1,a4,944 <malloc+0x78>
        p->s.size -= nunits;
 98e:	4137073b          	subw	a4,a4,s3
 992:	c798                	sw	a4,8(a5)
        p += p->s.size;
 994:	02071693          	slli	a3,a4,0x20
 998:	01c6d713          	srli	a4,a3,0x1c
 99c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 99e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9a2:	00000717          	auipc	a4,0x0
 9a6:	66a73723          	sd	a0,1646(a4) # 1010 <freep>
      return (void *)(p + 1);
 9aa:	01078513          	addi	a0,a5,16
  }
}
 9ae:	70e2                	ld	ra,56(sp)
 9b0:	7442                	ld	s0,48(sp)
 9b2:	74a2                	ld	s1,40(sp)
 9b4:	69e2                	ld	s3,24(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
 9ba:	7902                	ld	s2,32(sp)
 9bc:	6a42                	ld	s4,16(sp)
 9be:	6aa2                	ld	s5,8(sp)
 9c0:	6b02                	ld	s6,0(sp)
 9c2:	b7f5                	j	9ae <malloc+0xe2>
