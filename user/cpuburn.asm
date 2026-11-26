
user/_cpuburn:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define ITERATIONS_PER_ROUND 50000000ULL

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	0080                	addi	s0,sp,64
   e:	84aa                	mv	s1,a0
  10:	89ae                	mv	s3,a1
  volatile uint64 i; // volatile prevents the compiler from optimizing the loop away
  int pid = getpid();
  12:	3ca000ef          	jal	3dc <getpid>
  16:	892a                	mv	s2,a0

  if (argc >= 2) {
  18:	4785                	li	a5,1
  1a:	0697db63          	bge	a5,s1,90 <main+0x90>
    int rounds = atoi(argv[1]);
  1e:	0089b503          	ld	a0,8(s3)
  22:	218000ef          	jal	23a <atoi>
  26:	84aa                	mv	s1,a0
    if (rounds <= 0) {
  28:	04a05b63          	blez	a0,7e <main+0x7e>
      printf("Usage: cpuburn [rounds]\n");
      exit(1);
    }

    printf("[cpuburn] PID %d running %d busy rounds...\n", pid, rounds);
  2c:	862a                	mv	a2,a0
  2e:	85ca                	mv	a1,s2
  30:	00001517          	auipc	a0,0x1
  34:	9c050513          	addi	a0,a0,-1600 # 9f0 <malloc+0x118>
  38:	7ec000ef          	jal	824 <printf>
    for (int r = 0; r < rounds; r++) {
  3c:	4601                	li	a2,0
      for (i = 0; i < ITERATIONS_PER_ROUND; i++)
  3e:	02faf737          	lui	a4,0x2faf
  42:	07f70713          	addi	a4,a4,127 # 2faf07f <base+0x2fae06f>
  46:	fc043423          	sd	zero,-56(s0)
  4a:	fc843783          	ld	a5,-56(s0)
  4e:	00f76b63          	bltu	a4,a5,64 <main+0x64>
  52:	fc843783          	ld	a5,-56(s0)
  56:	0785                	addi	a5,a5,1
  58:	fcf43423          	sd	a5,-56(s0)
  5c:	fc843783          	ld	a5,-56(s0)
  60:	fef779e3          	bgeu	a4,a5,52 <main+0x52>
    for (int r = 0; r < rounds; r++) {
  64:	2605                	addiw	a2,a2,1
  66:	fec490e3          	bne	s1,a2,46 <main+0x46>
        ;
    }
    printf("[cpuburn] PID %d finished %d rounds\n", pid, rounds);
  6a:	85ca                	mv	a1,s2
  6c:	00001517          	auipc	a0,0x1
  70:	9b450513          	addi	a0,a0,-1612 # a20 <malloc+0x148>
  74:	7b0000ef          	jal	824 <printf>
    exit(0);
  78:	4501                	li	a0,0
  7a:	2e2000ef          	jal	35c <exit>
      printf("Usage: cpuburn [rounds]\n");
  7e:	00001517          	auipc	a0,0x1
  82:	95250513          	addi	a0,a0,-1710 # 9d0 <malloc+0xf8>
  86:	79e000ef          	jal	824 <printf>
      exit(1);
  8a:	4505                	li	a0,1
  8c:	2d0000ef          	jal	35c <exit>
  }

  printf("[cpuburn] PID %d started (stop with 'kill %d')\n", pid, pid);
  90:	862a                	mv	a2,a0
  92:	85aa                	mv	a1,a0
  94:	00001517          	auipc	a0,0x1
  98:	9b450513          	addi	a0,a0,-1612 # a48 <malloc+0x170>
  9c:	788000ef          	jal	824 <printf>
  for (;;) {
    for (i = 0; i < ITERATIONS_PER_ROUND; i++)
  a0:	02faf737          	lui	a4,0x2faf
  a4:	07f70713          	addi	a4,a4,127 # 2faf07f <base+0x2fae06f>
  a8:	fc043423          	sd	zero,-56(s0)
  ac:	fc843783          	ld	a5,-56(s0)
  b0:	fef76ce3          	bltu	a4,a5,a8 <main+0xa8>
  b4:	fc843783          	ld	a5,-56(s0)
  b8:	0785                	addi	a5,a5,1
  ba:	fcf43423          	sd	a5,-56(s0)
  be:	fc843783          	ld	a5,-56(s0)
  c2:	fef779e3          	bgeu	a4,a5,b4 <main+0xb4>
  c6:	b7cd                	j	a8 <main+0xa8>

00000000000000c8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c8:	1141                	addi	sp,sp,-16
  ca:	e406                	sd	ra,8(sp)
  cc:	e022                	sd	s0,0(sp)
  ce:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  d0:	f31ff0ef          	jal	0 <main>
  exit(r);
  d4:	288000ef          	jal	35c <exit>

00000000000000d8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0x8>
    ;
  return os;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb91                	beqz	a5,112 <strcmp+0x1e>
 100:	0005c703          	lbu	a4,0(a1)
 104:	00f71763          	bne	a4,a5,112 <strcmp+0x1e>
    p++, q++;
 108:	0505                	addi	a0,a0,1
 10a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbe5                	bnez	a5,100 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 112:	0005c503          	lbu	a0,0(a1)
}
 116:	40a7853b          	subw	a0,a5,a0
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strlen>:

uint
strlen(const char *s)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf91                	beqz	a5,146 <strlen+0x26>
 12c:	0505                	addi	a0,a0,1
 12e:	87aa                	mv	a5,a0
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x10>
 13a:	40a6853b          	subw	a0,a3,a0
 13e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for (n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strlen+0x20>

000000000000014a <memset>:

void *
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e422                	sd	s0,8(sp)
 14e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 150:	ca19                	beqz	a2,166 <memset+0x1c>
 152:	87aa                	mv	a5,a0
 154:	1602                	slli	a2,a2,0x20
 156:	9201                	srli	a2,a2,0x20
 158:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x12>
  }
  return dst;
}
 166:	6422                	ld	s0,8(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strchr>:

char *
strchr(const char *s, char c)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e422                	sd	s0,8(sp)
 170:	0800                	addi	s0,sp,16
  for (; *s; s++)
 172:	00054783          	lbu	a5,0(a0)
 176:	cb99                	beqz	a5,18c <strchr+0x20>
    if (*s == c)
 178:	00f58763          	beq	a1,a5,186 <strchr+0x1a>
  for (; *s; s++)
 17c:	0505                	addi	a0,a0,1
 17e:	00054783          	lbu	a5,0(a0)
 182:	fbfd                	bnez	a5,178 <strchr+0xc>
      return (char *)s;
  return 0;
 184:	4501                	li	a0,0
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  return 0;
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strchr+0x1a>

0000000000000190 <gets>:

char *
gets(char *buf, int max)
{
 190:	711d                	addi	sp,sp,-96
 192:	ec86                	sd	ra,88(sp)
 194:	e8a2                	sd	s0,80(sp)
 196:	e4a6                	sd	s1,72(sp)
 198:	e0ca                	sd	s2,64(sp)
 19a:	fc4e                	sd	s3,56(sp)
 19c:	f852                	sd	s4,48(sp)
 19e:	f456                	sd	s5,40(sp)
 1a0:	f05a                	sd	s6,32(sp)
 1a2:	ec5e                	sd	s7,24(sp)
 1a4:	1080                	addi	s0,sp,96
 1a6:	8baa                	mv	s7,a0
 1a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1aa:	892a                	mv	s2,a0
 1ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 1ae:	4aa9                	li	s5,10
 1b0:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 1b2:	89a6                	mv	s3,s1
 1b4:	2485                	addiw	s1,s1,1
 1b6:	0344d663          	bge	s1,s4,1e2 <gets+0x52>
    cc = read(0, &c, 1);
 1ba:	4605                	li	a2,1
 1bc:	faf40593          	addi	a1,s0,-81
 1c0:	4501                	li	a0,0
 1c2:	1b2000ef          	jal	374 <read>
    if (cc < 1)
 1c6:	00a05e63          	blez	a0,1e2 <gets+0x52>
    buf[i++] = c;
 1ca:	faf44783          	lbu	a5,-81(s0)
 1ce:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1d2:	01578763          	beq	a5,s5,1e0 <gets+0x50>
 1d6:	0905                	addi	s2,s2,1
 1d8:	fd679de3          	bne	a5,s6,1b2 <gets+0x22>
    buf[i++] = c;
 1dc:	89a6                	mv	s3,s1
 1de:	a011                	j	1e2 <gets+0x52>
 1e0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e2:	99de                	add	s3,s3,s7
 1e4:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e8:	855e                	mv	a0,s7
 1ea:	60e6                	ld	ra,88(sp)
 1ec:	6446                	ld	s0,80(sp)
 1ee:	64a6                	ld	s1,72(sp)
 1f0:	6906                	ld	s2,64(sp)
 1f2:	79e2                	ld	s3,56(sp)
 1f4:	7a42                	ld	s4,48(sp)
 1f6:	7aa2                	ld	s5,40(sp)
 1f8:	7b02                	ld	s6,32(sp)
 1fa:	6be2                	ld	s7,24(sp)
 1fc:	6125                	addi	sp,sp,96
 1fe:	8082                	ret

0000000000000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	1101                	addi	sp,sp,-32
 202:	ec06                	sd	ra,24(sp)
 204:	e822                	sd	s0,16(sp)
 206:	e04a                	sd	s2,0(sp)
 208:	1000                	addi	s0,sp,32
 20a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	4581                	li	a1,0
 20e:	18e000ef          	jal	39c <open>
  if (fd < 0)
 212:	02054263          	bltz	a0,236 <stat+0x36>
 216:	e426                	sd	s1,8(sp)
 218:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 21a:	85ca                	mv	a1,s2
 21c:	198000ef          	jal	3b4 <fstat>
 220:	892a                	mv	s2,a0
  close(fd);
 222:	8526                	mv	a0,s1
 224:	160000ef          	jal	384 <close>
  return r;
 228:	64a2                	ld	s1,8(sp)
}
 22a:	854a                	mv	a0,s2
 22c:	60e2                	ld	ra,24(sp)
 22e:	6442                	ld	s0,16(sp)
 230:	6902                	ld	s2,0(sp)
 232:	6105                	addi	sp,sp,32
 234:	8082                	ret
    return -1;
 236:	597d                	li	s2,-1
 238:	bfcd                	j	22a <stat+0x2a>

000000000000023a <atoi>:

int
atoi(const char *s)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e422                	sd	s0,8(sp)
 23e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 240:	00054683          	lbu	a3,0(a0)
 244:	fd06879b          	addiw	a5,a3,-48
 248:	0ff7f793          	zext.b	a5,a5
 24c:	4625                	li	a2,9
 24e:	02f66863          	bltu	a2,a5,27e <atoi+0x44>
 252:	872a                	mv	a4,a0
  n = 0;
 254:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 256:	0705                	addi	a4,a4,1
 258:	0025179b          	slliw	a5,a0,0x2
 25c:	9fa9                	addw	a5,a5,a0
 25e:	0017979b          	slliw	a5,a5,0x1
 262:	9fb5                	addw	a5,a5,a3
 264:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 268:	00074683          	lbu	a3,0(a4)
 26c:	fd06879b          	addiw	a5,a3,-48
 270:	0ff7f793          	zext.b	a5,a5
 274:	fef671e3          	bgeu	a2,a5,256 <atoi+0x1c>
  return n;
}
 278:	6422                	ld	s0,8(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
  n = 0;
 27e:	4501                	li	a0,0
 280:	bfe5                	j	278 <atoi+0x3e>

0000000000000282 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 288:	02b57463          	bgeu	a0,a1,2b0 <memmove+0x2e>
    while (n-- > 0)
 28c:	00c05f63          	blez	a2,2aa <memmove+0x28>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 298:	872a                	mv	a4,a0
      *dst++ = *src++;
 29a:	0585                	addi	a1,a1,1
 29c:	0705                	addi	a4,a4,1
 29e:	fff5c683          	lbu	a3,-1(a1)
 2a2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2a6:	fef71ae3          	bne	a4,a5,29a <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
    dst += n;
 2b0:	00c50733          	add	a4,a0,a2
    src += n;
 2b4:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 2b6:	fec05ae3          	blez	a2,2aa <memmove+0x28>
 2ba:	fff6079b          	addiw	a5,a2,-1
 2be:	1782                	slli	a5,a5,0x20
 2c0:	9381                	srli	a5,a5,0x20
 2c2:	fff7c793          	not	a5,a5
 2c6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c8:	15fd                	addi	a1,a1,-1
 2ca:	177d                	addi	a4,a4,-1
 2cc:	0005c683          	lbu	a3,0(a1)
 2d0:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2d4:	fee79ae3          	bne	a5,a4,2c8 <memmove+0x46>
 2d8:	bfc9                	j	2aa <memmove+0x28>

00000000000002da <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e422                	sd	s0,8(sp)
 2de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2e0:	ca05                	beqz	a2,310 <memcmp+0x36>
 2e2:	fff6069b          	addiw	a3,a2,-1
 2e6:	1682                	slli	a3,a3,0x20
 2e8:	9281                	srli	a3,a3,0x20
 2ea:	0685                	addi	a3,a3,1
 2ec:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	0005c703          	lbu	a4,0(a1)
 2f6:	00e79863          	bne	a5,a4,306 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2fa:	0505                	addi	a0,a0,1
    p2++;
 2fc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fe:	fed518e3          	bne	a0,a3,2ee <memcmp+0x14>
  }
  return 0;
 302:	4501                	li	a0,0
 304:	a019                	j	30a <memcmp+0x30>
      return *p1 - *p2;
 306:	40e7853b          	subw	a0,a5,a4
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  return 0;
 310:	4501                	li	a0,0
 312:	bfe5                	j	30a <memcmp+0x30>

0000000000000314 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31c:	f67ff0ef          	jal	282 <memmove>
}
 320:	60a2                	ld	ra,8(sp)
 322:	6402                	ld	s0,0(sp)
 324:	0141                	addi	sp,sp,16
 326:	8082                	ret

0000000000000328 <sbrk>:

char *
sbrk(int n)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 330:	4585                	li	a1,1
 332:	0b2000ef          	jal	3e4 <sys_sbrk>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <sbrklazy>:

char *
sbrklazy(int n)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 346:	4589                	li	a1,2
 348:	09c000ef          	jal	3e4 <sys_sbrk>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 354:	4885                	li	a7,1
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <exit>:
.global exit
exit:
 li a7, SYS_exit
 35c:	4889                	li	a7,2
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <wait>:
.global wait
wait:
 li a7, SYS_wait
 364:	488d                	li	a7,3
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 36c:	4891                	li	a7,4
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <read>:
.global read
read:
 li a7, SYS_read
 374:	4895                	li	a7,5
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <write>:
.global write
write:
 li a7, SYS_write
 37c:	48c1                	li	a7,16
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <close>:
.global close
close:
 li a7, SYS_close
 384:	48d5                	li	a7,21
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <kill>:
.global kill
kill:
 li a7, SYS_kill
 38c:	4899                	li	a7,6
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <exec>:
.global exec
exec:
 li a7, SYS_exec
 394:	489d                	li	a7,7
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <open>:
.global open
open:
 li a7, SYS_open
 39c:	48bd                	li	a7,15
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3a4:	48c5                	li	a7,17
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ac:	48c9                	li	a7,18
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3b4:	48a1                	li	a7,8
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <link>:
.global link
link:
 li a7, SYS_link
 3bc:	48cd                	li	a7,19
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3c4:	48d1                	li	a7,20
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3cc:	48a5                	li	a7,9
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3d4:	48a9                	li	a7,10
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3dc:	48ad                	li	a7,11
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3e4:	48b1                	li	a7,12
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ec:	48b5                	li	a7,13
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3f4:	48b9                	li	a7,14
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sync>:
.global sync
sync:
 li a7, SYS_sync
 3fc:	48d9                	li	a7,22
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <ps>:
.global ps
ps:
 li a7, SYS_ps
 404:	48dd                	li	a7,23
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 40c:	48e1                	li	a7,24
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 414:	48e5                	li	a7,25
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 41c:	48e9                	li	a7,26
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <trace>:
.global trace
trace:
 li a7, SYS_trace
 424:	48ed                	li	a7,27
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 42c:	48f1                	li	a7,28
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 434:	48f5                	li	a7,29
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 43c:	48f9                	li	a7,30
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 444:	48fd                	li	a7,31
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 44c:	02000893          	li	a7,32
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <halt>:
.global halt
halt:
 li a7, SYS_halt
 456:	02100893          	li	a7,33
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 460:	02200893          	li	a7,34
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 46a:	02300893          	li	a7,35
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 474:	02400893          	li	a7,36
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 47e:	02500893          	li	a7,37
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 488:	02600893          	li	a7,38
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 492:	02700893          	li	a7,39
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49c:	1101                	addi	sp,sp,-32
 49e:	ec06                	sd	ra,24(sp)
 4a0:	e822                	sd	s0,16(sp)
 4a2:	1000                	addi	s0,sp,32
 4a4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a8:	4605                	li	a2,1
 4aa:	fef40593          	addi	a1,s0,-17
 4ae:	ecfff0ef          	jal	37c <write>
}
 4b2:	60e2                	ld	ra,24(sp)
 4b4:	6442                	ld	s0,16(sp)
 4b6:	6105                	addi	sp,sp,32
 4b8:	8082                	ret

00000000000004ba <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4ba:	715d                	addi	sp,sp,-80
 4bc:	e486                	sd	ra,72(sp)
 4be:	e0a2                	sd	s0,64(sp)
 4c0:	f84a                	sd	s2,48(sp)
 4c2:	0880                	addi	s0,sp,80
 4c4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4c6:	c299                	beqz	a3,4cc <printint+0x12>
 4c8:	0805c363          	bltz	a1,54e <printint+0x94>
  neg = 0;
 4cc:	4881                	li	a7,0
 4ce:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4d2:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 4d4:	00000517          	auipc	a0,0x0
 4d8:	5ac50513          	addi	a0,a0,1452 # a80 <digits>
 4dc:	883e                	mv	a6,a5
 4de:	2785                	addiw	a5,a5,1
 4e0:	02c5f733          	remu	a4,a1,a2
 4e4:	972a                	add	a4,a4,a0
 4e6:	00074703          	lbu	a4,0(a4)
 4ea:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 4ee:	872e                	mv	a4,a1
 4f0:	02c5d5b3          	divu	a1,a1,a2
 4f4:	0685                	addi	a3,a3,1
 4f6:	fec773e3          	bgeu	a4,a2,4dc <printint+0x22>
  if (neg)
 4fa:	00088b63          	beqz	a7,510 <printint+0x56>
    buf[i++] = '-';
 4fe:	fd078793          	addi	a5,a5,-48
 502:	97a2                	add	a5,a5,s0
 504:	02d00713          	li	a4,45
 508:	fee78423          	sb	a4,-24(a5)
 50c:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 510:	02f05a63          	blez	a5,544 <printint+0x8a>
 514:	fc26                	sd	s1,56(sp)
 516:	f44e                	sd	s3,40(sp)
 518:	fb840713          	addi	a4,s0,-72
 51c:	00f704b3          	add	s1,a4,a5
 520:	fff70993          	addi	s3,a4,-1
 524:	99be                	add	s3,s3,a5
 526:	37fd                	addiw	a5,a5,-1
 528:	1782                	slli	a5,a5,0x20
 52a:	9381                	srli	a5,a5,0x20
 52c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 530:	fff4c583          	lbu	a1,-1(s1)
 534:	854a                	mv	a0,s2
 536:	f67ff0ef          	jal	49c <putc>
  while (--i >= 0)
 53a:	14fd                	addi	s1,s1,-1
 53c:	ff349ae3          	bne	s1,s3,530 <printint+0x76>
 540:	74e2                	ld	s1,56(sp)
 542:	79a2                	ld	s3,40(sp)
}
 544:	60a6                	ld	ra,72(sp)
 546:	6406                	ld	s0,64(sp)
 548:	7942                	ld	s2,48(sp)
 54a:	6161                	addi	sp,sp,80
 54c:	8082                	ret
    x = -xx;
 54e:	40b005b3          	neg	a1,a1
    neg = 1;
 552:	4885                	li	a7,1
    x = -xx;
 554:	bfad                	j	4ce <printint+0x14>

0000000000000556 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 556:	711d                	addi	sp,sp,-96
 558:	ec86                	sd	ra,88(sp)
 55a:	e8a2                	sd	s0,80(sp)
 55c:	e0ca                	sd	s2,64(sp)
 55e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 560:	0005c903          	lbu	s2,0(a1)
 564:	28090663          	beqz	s2,7f0 <vprintf+0x29a>
 568:	e4a6                	sd	s1,72(sp)
 56a:	fc4e                	sd	s3,56(sp)
 56c:	f852                	sd	s4,48(sp)
 56e:	f456                	sd	s5,40(sp)
 570:	f05a                	sd	s6,32(sp)
 572:	ec5e                	sd	s7,24(sp)
 574:	e862                	sd	s8,16(sp)
 576:	e466                	sd	s9,8(sp)
 578:	8b2a                	mv	s6,a0
 57a:	8a2e                	mv	s4,a1
 57c:	8bb2                	mv	s7,a2
  state = 0;
 57e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 580:	4481                	li	s1,0
 582:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 584:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 588:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 58c:	06c00c93          	li	s9,108
 590:	a005                	j	5b0 <vprintf+0x5a>
        putc(fd, c0);
 592:	85ca                	mv	a1,s2
 594:	855a                	mv	a0,s6
 596:	f07ff0ef          	jal	49c <putc>
 59a:	a019                	j	5a0 <vprintf+0x4a>
    } else if (state == '%') {
 59c:	03598263          	beq	s3,s5,5c0 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 5a0:	2485                	addiw	s1,s1,1
 5a2:	8726                	mv	a4,s1
 5a4:	009a07b3          	add	a5,s4,s1
 5a8:	0007c903          	lbu	s2,0(a5)
 5ac:	22090a63          	beqz	s2,7e0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5b0:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 5b4:	fe0994e3          	bnez	s3,59c <vprintf+0x46>
      if (c0 == '%') {
 5b8:	fd579de3          	bne	a5,s5,592 <vprintf+0x3c>
        state = '%';
 5bc:	89be                	mv	s3,a5
 5be:	b7cd                	j	5a0 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 5c0:	00ea06b3          	add	a3,s4,a4
 5c4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5c8:	8636                	mv	a2,a3
      if (c1)
 5ca:	c681                	beqz	a3,5d2 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 5cc:	9752                	add	a4,a4,s4
 5ce:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 5d2:	05878363          	beq	a5,s8,618 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 5d6:	05978d63          	beq	a5,s9,630 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5da:	07500713          	li	a4,117
 5de:	0ee78763          	beq	a5,a4,6cc <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5e2:	07800713          	li	a4,120
 5e6:	12e78963          	beq	a5,a4,718 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5ea:	07000713          	li	a4,112
 5ee:	14e78e63          	beq	a5,a4,74a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5f2:	06300713          	li	a4,99
 5f6:	18e78e63          	beq	a5,a4,792 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5fa:	07300713          	li	a4,115
 5fe:	1ae78463          	beq	a5,a4,7a6 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 602:	02500713          	li	a4,37
 606:	04e79563          	bne	a5,a4,650 <vprintf+0xfa>
        putc(fd, '%');
 60a:	02500593          	li	a1,37
 60e:	855a                	mv	a0,s6
 610:	e8dff0ef          	jal	49c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 614:	4981                	li	s3,0
 616:	b769                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 618:	008b8913          	addi	s2,s7,8
 61c:	4685                	li	a3,1
 61e:	4629                	li	a2,10
 620:	000ba583          	lw	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	e95ff0ef          	jal	4ba <printint>
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bf8d                	j	5a0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 630:	06400793          	li	a5,100
 634:	02f68963          	beq	a3,a5,666 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 638:	06c00793          	li	a5,108
 63c:	04f68263          	beq	a3,a5,680 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 640:	07500793          	li	a5,117
 644:	0af68063          	beq	a3,a5,6e4 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 648:	07800793          	li	a5,120
 64c:	0ef68263          	beq	a3,a5,730 <vprintf+0x1da>
        putc(fd, '%');
 650:	02500593          	li	a1,37
 654:	855a                	mv	a0,s6
 656:	e47ff0ef          	jal	49c <putc>
        putc(fd, c0);
 65a:	85ca                	mv	a1,s2
 65c:	855a                	mv	a0,s6
 65e:	e3fff0ef          	jal	49c <putc>
      state = 0;
 662:	4981                	li	s3,0
 664:	bf35                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 666:	008b8913          	addi	s2,s7,8
 66a:	4685                	li	a3,1
 66c:	4629                	li	a2,10
 66e:	000bb583          	ld	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	e47ff0ef          	jal	4ba <printint>
        i += 1;
 678:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
        i += 1;
 67e:	b70d                	j	5a0 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 680:	06400793          	li	a5,100
 684:	02f60763          	beq	a2,a5,6b2 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 688:	07500793          	li	a5,117
 68c:	06f60963          	beq	a2,a5,6fe <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 690:	07800793          	li	a5,120
 694:	faf61ee3          	bne	a2,a5,650 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000bb583          	ld	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	e15ff0ef          	jal	4ba <printint>
        i += 2;
 6aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	bdc5                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4685                	li	a3,1
 6b8:	4629                	li	a2,10
 6ba:	000bb583          	ld	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	dfbff0ef          	jal	4ba <printint>
        i += 2;
 6c4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
        i += 2;
 6ca:	bdd9                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000be583          	lwu	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	de1ff0ef          	jal	4ba <printint>
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bd7d                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e4:	008b8913          	addi	s2,s7,8
 6e8:	4681                	li	a3,0
 6ea:	4629                	li	a2,10
 6ec:	000bb583          	ld	a1,0(s7)
 6f0:	855a                	mv	a0,s6
 6f2:	dc9ff0ef          	jal	4ba <printint>
        i += 1;
 6f6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	8bca                	mv	s7,s2
      state = 0;
 6fa:	4981                	li	s3,0
        i += 1;
 6fc:	b555                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fe:	008b8913          	addi	s2,s7,8
 702:	4681                	li	a3,0
 704:	4629                	li	a2,10
 706:	000bb583          	ld	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	dafff0ef          	jal	4ba <printint>
        i += 2;
 710:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
        i += 2;
 716:	b569                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 718:	008b8913          	addi	s2,s7,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000be583          	lwu	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	d95ff0ef          	jal	4ba <printint>
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bd8d                	j	5a0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 730:	008b8913          	addi	s2,s7,8
 734:	4681                	li	a3,0
 736:	4641                	li	a2,16
 738:	000bb583          	ld	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	d7dff0ef          	jal	4ba <printint>
        i += 1;
 742:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	8bca                	mv	s7,s2
      state = 0;
 746:	4981                	li	s3,0
        i += 1;
 748:	bda1                	j	5a0 <vprintf+0x4a>
 74a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 74c:	008b8d13          	addi	s10,s7,8
 750:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 754:	03000593          	li	a1,48
 758:	855a                	mv	a0,s6
 75a:	d43ff0ef          	jal	49c <putc>
  putc(fd, 'x');
 75e:	07800593          	li	a1,120
 762:	855a                	mv	a0,s6
 764:	d39ff0ef          	jal	49c <putc>
 768:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 76a:	00000b97          	auipc	s7,0x0
 76e:	316b8b93          	addi	s7,s7,790 # a80 <digits>
 772:	03c9d793          	srli	a5,s3,0x3c
 776:	97de                	add	a5,a5,s7
 778:	0007c583          	lbu	a1,0(a5)
 77c:	855a                	mv	a0,s6
 77e:	d1fff0ef          	jal	49c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 782:	0992                	slli	s3,s3,0x4
 784:	397d                	addiw	s2,s2,-1
 786:	fe0916e3          	bnez	s2,772 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 78a:	8bea                	mv	s7,s10
      state = 0;
 78c:	4981                	li	s3,0
 78e:	6d02                	ld	s10,0(sp)
 790:	bd01                	j	5a0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 792:	008b8913          	addi	s2,s7,8
 796:	000bc583          	lbu	a1,0(s7)
 79a:	855a                	mv	a0,s6
 79c:	d01ff0ef          	jal	49c <putc>
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
 7a4:	bbf5                	j	5a0 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7a6:	008b8993          	addi	s3,s7,8
 7aa:	000bb903          	ld	s2,0(s7)
 7ae:	00090f63          	beqz	s2,7cc <vprintf+0x276>
        for (; *s; s++)
 7b2:	00094583          	lbu	a1,0(s2)
 7b6:	c195                	beqz	a1,7da <vprintf+0x284>
          putc(fd, *s);
 7b8:	855a                	mv	a0,s6
 7ba:	ce3ff0ef          	jal	49c <putc>
        for (; *s; s++)
 7be:	0905                	addi	s2,s2,1
 7c0:	00094583          	lbu	a1,0(s2)
 7c4:	f9f5                	bnez	a1,7b8 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7c6:	8bce                	mv	s7,s3
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	bbd9                	j	5a0 <vprintf+0x4a>
          s = "(null)";
 7cc:	00000917          	auipc	s2,0x0
 7d0:	2ac90913          	addi	s2,s2,684 # a78 <malloc+0x1a0>
        for (; *s; s++)
 7d4:	02800593          	li	a1,40
 7d8:	b7c5                	j	7b8 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 7da:	8bce                	mv	s7,s3
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	b3c9                	j	5a0 <vprintf+0x4a>
 7e0:	64a6                	ld	s1,72(sp)
 7e2:	79e2                	ld	s3,56(sp)
 7e4:	7a42                	ld	s4,48(sp)
 7e6:	7aa2                	ld	s5,40(sp)
 7e8:	7b02                	ld	s6,32(sp)
 7ea:	6be2                	ld	s7,24(sp)
 7ec:	6c42                	ld	s8,16(sp)
 7ee:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7f0:	60e6                	ld	ra,88(sp)
 7f2:	6446                	ld	s0,80(sp)
 7f4:	6906                	ld	s2,64(sp)
 7f6:	6125                	addi	sp,sp,96
 7f8:	8082                	ret

00000000000007fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7fa:	715d                	addi	sp,sp,-80
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e010                	sd	a2,0(s0)
 804:	e414                	sd	a3,8(s0)
 806:	e818                	sd	a4,16(s0)
 808:	ec1c                	sd	a5,24(s0)
 80a:	03043023          	sd	a6,32(s0)
 80e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 816:	8622                	mv	a2,s0
 818:	d3fff0ef          	jal	556 <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6161                	addi	sp,sp,80
 822:	8082                	ret

0000000000000824 <printf>:

void
printf(const char *fmt, ...)
{
 824:	711d                	addi	sp,sp,-96
 826:	ec06                	sd	ra,24(sp)
 828:	e822                	sd	s0,16(sp)
 82a:	1000                	addi	s0,sp,32
 82c:	e40c                	sd	a1,8(s0)
 82e:	e810                	sd	a2,16(s0)
 830:	ec14                	sd	a3,24(s0)
 832:	f018                	sd	a4,32(s0)
 834:	f41c                	sd	a5,40(s0)
 836:	03043823          	sd	a6,48(s0)
 83a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 83e:	00840613          	addi	a2,s0,8
 842:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 846:	85aa                	mv	a1,a0
 848:	4505                	li	a0,1
 84a:	d0dff0ef          	jal	556 <vprintf>
}
 84e:	60e2                	ld	ra,24(sp)
 850:	6442                	ld	s0,16(sp)
 852:	6125                	addi	sp,sp,96
 854:	8082                	ret

0000000000000856 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 856:	1141                	addi	sp,sp,-16
 858:	e422                	sd	s0,8(sp)
 85a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 85c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 860:	00000797          	auipc	a5,0x0
 864:	7a07b783          	ld	a5,1952(a5) # 1000 <freep>
 868:	a02d                	j	892 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 86a:	4618                	lw	a4,8(a2)
 86c:	9f2d                	addw	a4,a4,a1
 86e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 872:	6398                	ld	a4,0(a5)
 874:	6310                	ld	a2,0(a4)
 876:	a83d                	j	8b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 878:	ff852703          	lw	a4,-8(a0)
 87c:	9f31                	addw	a4,a4,a2
 87e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 880:	ff053683          	ld	a3,-16(a0)
 884:	a091                	j	8c8 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	6398                	ld	a4,0(a5)
 888:	00e7e463          	bltu	a5,a4,890 <free+0x3a>
 88c:	00e6ea63          	bltu	a3,a4,8a0 <free+0x4a>
{
 890:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	fed7fae3          	bgeu	a5,a3,886 <free+0x30>
 896:	6398                	ld	a4,0(a5)
 898:	00e6e463          	bltu	a3,a4,8a0 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	fee7eae3          	bltu	a5,a4,890 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 8a0:	ff852583          	lw	a1,-8(a0)
 8a4:	6390                	ld	a2,0(a5)
 8a6:	02059813          	slli	a6,a1,0x20
 8aa:	01c85713          	srli	a4,a6,0x1c
 8ae:	9736                	add	a4,a4,a3
 8b0:	fae60de3          	beq	a2,a4,86a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8b8:	4790                	lw	a2,8(a5)
 8ba:	02061593          	slli	a1,a2,0x20
 8be:	01c5d713          	srli	a4,a1,0x1c
 8c2:	973e                	add	a4,a4,a5
 8c4:	fae68ae3          	beq	a3,a4,878 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
}
 8d2:	6422                	ld	s0,8(sp)
 8d4:	0141                	addi	sp,sp,16
 8d6:	8082                	ret

00000000000008d8 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8d8:	7139                	addi	sp,sp,-64
 8da:	fc06                	sd	ra,56(sp)
 8dc:	f822                	sd	s0,48(sp)
 8de:	f426                	sd	s1,40(sp)
 8e0:	ec4e                	sd	s3,24(sp)
 8e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8e4:	02051493          	slli	s1,a0,0x20
 8e8:	9081                	srli	s1,s1,0x20
 8ea:	04bd                	addi	s1,s1,15
 8ec:	8091                	srli	s1,s1,0x4
 8ee:	0014899b          	addiw	s3,s1,1
 8f2:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 8f4:	00000517          	auipc	a0,0x0
 8f8:	70c53503          	ld	a0,1804(a0) # 1000 <freep>
 8fc:	c915                	beqz	a0,930 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8fe:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 900:	4798                	lw	a4,8(a5)
 902:	08977a63          	bgeu	a4,s1,996 <malloc+0xbe>
 906:	f04a                	sd	s2,32(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 90e:	8a4e                	mv	s4,s3
 910:	0009871b          	sext.w	a4,s3
 914:	6685                	lui	a3,0x1
 916:	00d77363          	bgeu	a4,a3,91c <malloc+0x44>
 91a:	6a05                	lui	s4,0x1
 91c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 920:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 924:	00000917          	auipc	s2,0x0
 928:	6dc90913          	addi	s2,s2,1756 # 1000 <freep>
  if (p == SBRK_ERROR)
 92c:	5afd                	li	s5,-1
 92e:	a081                	j	96e <malloc+0x96>
 930:	f04a                	sd	s2,32(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 938:	00000797          	auipc	a5,0x0
 93c:	6d878793          	addi	a5,a5,1752 # 1010 <base>
 940:	00000717          	auipc	a4,0x0
 944:	6cf73023          	sd	a5,1728(a4) # 1000 <freep>
 948:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 94a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 94e:	b7c1                	j	90e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 950:	6398                	ld	a4,0(a5)
 952:	e118                	sd	a4,0(a0)
 954:	a8a9                	j	9ae <malloc+0xd6>
  hp->s.size = nu;
 956:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 95a:	0541                	addi	a0,a0,16
 95c:	efbff0ef          	jal	856 <free>
  return freep;
 960:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 964:	c12d                	beqz	a0,9c6 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 966:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 968:	4798                	lw	a4,8(a5)
 96a:	02977263          	bgeu	a4,s1,98e <malloc+0xb6>
    if (p == freep)
 96e:	00093703          	ld	a4,0(s2)
 972:	853e                	mv	a0,a5
 974:	fef719e3          	bne	a4,a5,966 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 978:	8552                	mv	a0,s4
 97a:	9afff0ef          	jal	328 <sbrk>
  if (p == SBRK_ERROR)
 97e:	fd551ce3          	bne	a0,s5,956 <malloc+0x7e>
        return 0;
 982:	4501                	li	a0,0
 984:	7902                	ld	s2,32(sp)
 986:	6a42                	ld	s4,16(sp)
 988:	6aa2                	ld	s5,8(sp)
 98a:	6b02                	ld	s6,0(sp)
 98c:	a03d                	j	9ba <malloc+0xe2>
 98e:	7902                	ld	s2,32(sp)
 990:	6a42                	ld	s4,16(sp)
 992:	6aa2                	ld	s5,8(sp)
 994:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 996:	fae48de3          	beq	s1,a4,950 <malloc+0x78>
        p->s.size -= nunits;
 99a:	4137073b          	subw	a4,a4,s3
 99e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a0:	02071693          	slli	a3,a4,0x20
 9a4:	01c6d713          	srli	a4,a3,0x1c
 9a8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9aa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ae:	00000717          	auipc	a4,0x0
 9b2:	64a73923          	sd	a0,1618(a4) # 1000 <freep>
      return (void *)(p + 1);
 9b6:	01078513          	addi	a0,a5,16
  }
}
 9ba:	70e2                	ld	ra,56(sp)
 9bc:	7442                	ld	s0,48(sp)
 9be:	74a2                	ld	s1,40(sp)
 9c0:	69e2                	ld	s3,24(sp)
 9c2:	6121                	addi	sp,sp,64
 9c4:	8082                	ret
 9c6:	7902                	ld	s2,32(sp)
 9c8:	6a42                	ld	s4,16(sp)
 9ca:	6aa2                	ld	s5,8(sp)
 9cc:	6b02                	ld	s6,0(sp)
 9ce:	b7f5                	j	9ba <malloc+0xe2>
