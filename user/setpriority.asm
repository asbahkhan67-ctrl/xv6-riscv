
user/_setpriority:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <is_digits>:
#include "kernel/stat.h"
#include "user/user.h"

static int
is_digits(const char *s)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  if (s == 0 || *s == '\0')
   6:	c11d                	beqz	a0,2c <is_digits+0x2c>
   8:	872a                	mv	a4,a0
   a:	00054783          	lbu	a5,0(a0)
    return 0;
   e:	4501                	li	a0,0
  if (s == 0 || *s == '\0')
  10:	c38d                	beqz	a5,32 <is_digits+0x32>
  for (; *s; s++) {
    if (*s < '0' || *s > '9')
  12:	46a5                	li	a3,9
  14:	fd07879b          	addiw	a5,a5,-48
  18:	0ff7f793          	zext.b	a5,a5
  1c:	00f6ea63          	bltu	a3,a5,30 <is_digits+0x30>
  for (; *s; s++) {
  20:	0705                	addi	a4,a4,1
  22:	00074783          	lbu	a5,0(a4)
  26:	f7fd                	bnez	a5,14 <is_digits+0x14>
      return 0;
  }
  return 1;
  28:	4505                	li	a0,1
  2a:	a021                	j	32 <is_digits+0x32>
    return 0;
  2c:	4501                	li	a0,0
  2e:	a011                	j	32 <is_digits+0x32>
      return 0;
  30:	4501                	li	a0,0
}
  32:	6422                	ld	s0,8(sp)
  34:	0141                	addi	sp,sp,16
  36:	8082                	ret

0000000000000038 <main>:
  printf("  setpriority <pid> <1..20>     (set priority: 1=highest, 10=default, 20=lowest)\n");
}

int
main(int argc, char *argv[])
{
  38:	7179                	addi	sp,sp,-48
  3a:	f406                	sd	ra,40(sp)
  3c:	f022                	sd	s0,32(sp)
  3e:	1800                	addi	s0,sp,48
  int pid, target_pid, old_prio, new_prio;

  if (argc != 2 && argc != 3) {
  40:	ffe5071b          	addiw	a4,a0,-2
  44:	4785                	li	a5,1
  46:	02e7fb63          	bgeu	a5,a4,7c <main+0x44>
  4a:	ec26                	sd	s1,24(sp)
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  50:	e052                	sd	s4,0(sp)
  printf("Usage:\n");
  52:	00001517          	auipc	a0,0x1
  56:	a5e50513          	addi	a0,a0,-1442 # ab0 <malloc+0xfe>
  5a:	0a5000ef          	jal	8fe <printf>
  printf("  setpriority <pid>             (view current priority; 0 = self)\n");
  5e:	00001517          	auipc	a0,0x1
  62:	a5a50513          	addi	a0,a0,-1446 # ab8 <malloc+0x106>
  66:	099000ef          	jal	8fe <printf>
  printf("  setpriority <pid> <1..20>     (set priority: 1=highest, 10=default, 20=lowest)\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	a9650513          	addi	a0,a0,-1386 # b00 <malloc+0x14e>
  72:	08d000ef          	jal	8fe <printf>
    usage();
    exit(1);
  76:	4505                	li	a0,1
  78:	3be000ef          	jal	436 <exit>
  7c:	ec26                	sd	s1,24(sp)
  7e:	e84a                	sd	s2,16(sp)
  80:	e44e                	sd	s3,8(sp)
  82:	84aa                	mv	s1,a0
  84:	892e                	mv	s2,a1
  }

  if (!is_digits(argv[1])) {
  86:	0085b983          	ld	s3,8(a1)
  8a:	854e                	mv	a0,s3
  8c:	f75ff0ef          	jal	0 <is_digits>
  90:	ed01                	bnez	a0,a8 <main+0x70>
  92:	e052                	sd	s4,0(sp)
    printf("setpriority: invalid PID '%s'\n", argv[1]);
  94:	85ce                	mv	a1,s3
  96:	00001517          	auipc	a0,0x1
  9a:	ac250513          	addi	a0,a0,-1342 # b58 <malloc+0x1a6>
  9e:	061000ef          	jal	8fe <printf>
    exit(1);
  a2:	4505                	li	a0,1
  a4:	392000ef          	jal	436 <exit>
  a8:	e052                	sd	s4,0(sp)
  }

  pid = atoi(argv[1]);
  aa:	854e                	mv	a0,s3
  ac:	268000ef          	jal	314 <atoi>
  b0:	89aa                	mv	s3,a0
  target_pid = (pid == 0) ? getpid() : pid;
  b2:	8a2a                	mv	s4,a0
  b4:	c505                	beqz	a0,dc <main+0xa4>

  // Query mode: setpriority <pid>
  if (argc == 2) {
  b6:	4789                	li	a5,2
  b8:	02f48663          	beq	s1,a5,e4 <main+0xac>
      printf("Process %d current priority: %d\n", target_pid, old_prio);
    exit(0);
  }

  // Update mode: setpriority <pid> <priority>
  if (!is_digits(argv[2])) {
  bc:	01093483          	ld	s1,16(s2)
  c0:	8526                	mv	a0,s1
  c2:	f3fff0ef          	jal	0 <is_digits>
  c6:	e13d                	bnez	a0,12c <main+0xf4>
    printf("setpriority: invalid priority '%s' (must be 1..20)\n", argv[2]);
  c8:	85a6                	mv	a1,s1
  ca:	00001517          	auipc	a0,0x1
  ce:	b2650513          	addi	a0,a0,-1242 # bf0 <malloc+0x23e>
  d2:	02d000ef          	jal	8fe <printf>
    exit(1);
  d6:	4505                	li	a0,1
  d8:	35e000ef          	jal	436 <exit>
  target_pid = (pid == 0) ? getpid() : pid;
  dc:	3da000ef          	jal	4b6 <getpid>
  e0:	8a2a                	mv	s4,a0
  e2:	bfd1                	j	b6 <main+0x7e>
    old_prio = getpriority(pid);
  e4:	854e                	mv	a0,s3
  e6:	47c000ef          	jal	562 <getpriority>
  ea:	862a                	mv	a2,a0
    if (old_prio < 0) {
  ec:	00054e63          	bltz	a0,108 <main+0xd0>
    if (pid == 0)
  f0:	02099663          	bnez	s3,11c <main+0xe4>
      printf("Process %d (self) current priority: %d\n", target_pid, old_prio);
  f4:	85d2                	mv	a1,s4
  f6:	00001517          	auipc	a0,0x1
  fa:	aaa50513          	addi	a0,a0,-1366 # ba0 <malloc+0x1ee>
  fe:	001000ef          	jal	8fe <printf>
    exit(0);
 102:	4501                	li	a0,0
 104:	332000ef          	jal	436 <exit>
      printf("setpriority: process %d not found\n", target_pid);
 108:	85d2                	mv	a1,s4
 10a:	00001517          	auipc	a0,0x1
 10e:	a6e50513          	addi	a0,a0,-1426 # b78 <malloc+0x1c6>
 112:	7ec000ef          	jal	8fe <printf>
      exit(1);
 116:	4505                	li	a0,1
 118:	31e000ef          	jal	436 <exit>
      printf("Process %d current priority: %d\n", target_pid, old_prio);
 11c:	85d2                	mv	a1,s4
 11e:	00001517          	auipc	a0,0x1
 122:	aaa50513          	addi	a0,a0,-1366 # bc8 <malloc+0x216>
 126:	7d8000ef          	jal	8fe <printf>
 12a:	bfe1                	j	102 <main+0xca>
  }

  new_prio = atoi(argv[2]);
 12c:	8526                	mv	a0,s1
 12e:	1e6000ef          	jal	314 <atoi>
 132:	892a                	mv	s2,a0
  old_prio = getpriority(pid);
 134:	854e                	mv	a0,s3
 136:	42c000ef          	jal	562 <getpriority>
 13a:	84aa                	mv	s1,a0
  if (old_prio < 0) {
 13c:	02054663          	bltz	a0,168 <main+0x130>
    printf("setpriority: process %d not found\n", target_pid);
    exit(1);
  }

  if (setpriority(pid, new_prio) < 0) {
 140:	85ca                	mv	a1,s2
 142:	854e                	mv	a0,s3
 144:	3a2000ef          	jal	4e6 <setpriority>
 148:	02054a63          	bltz	a0,17c <main+0x144>
    printf("setpriority: failed (priority must be between 1 and 20)\n");
    exit(1);
  }

  if (pid == 0)
 14c:	04099163          	bnez	s3,18e <main+0x156>
    printf("Process %d (self) priority changed: %d -> %d\n",
 150:	86ca                	mv	a3,s2
 152:	8626                	mv	a2,s1
 154:	85d2                	mv	a1,s4
 156:	00001517          	auipc	a0,0x1
 15a:	b1250513          	addi	a0,a0,-1262 # c68 <malloc+0x2b6>
 15e:	7a0000ef          	jal	8fe <printf>
           target_pid, old_prio, new_prio);
  else
    printf("Process %d priority changed: %d -> %d\n",
           target_pid, old_prio, new_prio);

  exit(0);
 162:	4501                	li	a0,0
 164:	2d2000ef          	jal	436 <exit>
    printf("setpriority: process %d not found\n", target_pid);
 168:	85d2                	mv	a1,s4
 16a:	00001517          	auipc	a0,0x1
 16e:	a0e50513          	addi	a0,a0,-1522 # b78 <malloc+0x1c6>
 172:	78c000ef          	jal	8fe <printf>
    exit(1);
 176:	4505                	li	a0,1
 178:	2be000ef          	jal	436 <exit>
    printf("setpriority: failed (priority must be between 1 and 20)\n");
 17c:	00001517          	auipc	a0,0x1
 180:	aac50513          	addi	a0,a0,-1364 # c28 <malloc+0x276>
 184:	77a000ef          	jal	8fe <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	2ac000ef          	jal	436 <exit>
    printf("Process %d priority changed: %d -> %d\n",
 18e:	86ca                	mv	a3,s2
 190:	8626                	mv	a2,s1
 192:	85d2                	mv	a1,s4
 194:	00001517          	auipc	a0,0x1
 198:	b0450513          	addi	a0,a0,-1276 # c98 <malloc+0x2e6>
 19c:	762000ef          	jal	8fe <printf>
 1a0:	b7c9                	j	162 <main+0x12a>

00000000000001a2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1aa:	e8fff0ef          	jal	38 <main>
  exit(r);
 1ae:	288000ef          	jal	436 <exit>

00000000000001b2 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 1b8:	87aa                	mv	a5,a0
 1ba:	0585                	addi	a1,a1,1
 1bc:	0785                	addi	a5,a5,1
 1be:	fff5c703          	lbu	a4,-1(a1)
 1c2:	fee78fa3          	sb	a4,-1(a5)
 1c6:	fb75                	bnez	a4,1ba <strcpy+0x8>
    ;
  return os;
}
 1c8:	6422                	ld	s0,8(sp)
 1ca:	0141                	addi	sp,sp,16
 1cc:	8082                	ret

00000000000001ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cb91                	beqz	a5,1ec <strcmp+0x1e>
 1da:	0005c703          	lbu	a4,0(a1)
 1de:	00f71763          	bne	a4,a5,1ec <strcmp+0x1e>
    p++, q++;
 1e2:	0505                	addi	a0,a0,1
 1e4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	fbe5                	bnez	a5,1da <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1ec:	0005c503          	lbu	a0,0(a1)
}
 1f0:	40a7853b          	subw	a0,a5,a0
 1f4:	6422                	ld	s0,8(sp)
 1f6:	0141                	addi	sp,sp,16
 1f8:	8082                	ret

00000000000001fa <strlen>:

uint
strlen(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 200:	00054783          	lbu	a5,0(a0)
 204:	cf91                	beqz	a5,220 <strlen+0x26>
 206:	0505                	addi	a0,a0,1
 208:	87aa                	mv	a5,a0
 20a:	86be                	mv	a3,a5
 20c:	0785                	addi	a5,a5,1
 20e:	fff7c703          	lbu	a4,-1(a5)
 212:	ff65                	bnez	a4,20a <strlen+0x10>
 214:	40a6853b          	subw	a0,a3,a0
 218:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
  for (n = 0; s[n]; n++)
 220:	4501                	li	a0,0
 222:	bfe5                	j	21a <strlen+0x20>

0000000000000224 <memset>:

void *
memset(void *dst, int c, uint n)
{
 224:	1141                	addi	sp,sp,-16
 226:	e422                	sd	s0,8(sp)
 228:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 22a:	ca19                	beqz	a2,240 <memset+0x1c>
 22c:	87aa                	mv	a5,a0
 22e:	1602                	slli	a2,a2,0x20
 230:	9201                	srli	a2,a2,0x20
 232:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 236:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 23a:	0785                	addi	a5,a5,1
 23c:	fee79de3          	bne	a5,a4,236 <memset+0x12>
  }
  return dst;
}
 240:	6422                	ld	s0,8(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret

0000000000000246 <strchr>:

char *
strchr(const char *s, char c)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  for (; *s; s++)
 24c:	00054783          	lbu	a5,0(a0)
 250:	cb99                	beqz	a5,266 <strchr+0x20>
    if (*s == c)
 252:	00f58763          	beq	a1,a5,260 <strchr+0x1a>
  for (; *s; s++)
 256:	0505                	addi	a0,a0,1
 258:	00054783          	lbu	a5,0(a0)
 25c:	fbfd                	bnez	a5,252 <strchr+0xc>
      return (char *)s;
  return 0;
 25e:	4501                	li	a0,0
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
  return 0;
 266:	4501                	li	a0,0
 268:	bfe5                	j	260 <strchr+0x1a>

000000000000026a <gets>:

char *
gets(char *buf, int max)
{
 26a:	711d                	addi	sp,sp,-96
 26c:	ec86                	sd	ra,88(sp)
 26e:	e8a2                	sd	s0,80(sp)
 270:	e4a6                	sd	s1,72(sp)
 272:	e0ca                	sd	s2,64(sp)
 274:	fc4e                	sd	s3,56(sp)
 276:	f852                	sd	s4,48(sp)
 278:	f456                	sd	s5,40(sp)
 27a:	f05a                	sd	s6,32(sp)
 27c:	ec5e                	sd	s7,24(sp)
 27e:	1080                	addi	s0,sp,96
 280:	8baa                	mv	s7,a0
 282:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 284:	892a                	mv	s2,a0
 286:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 288:	4aa9                	li	s5,10
 28a:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 28c:	89a6                	mv	s3,s1
 28e:	2485                	addiw	s1,s1,1
 290:	0344d663          	bge	s1,s4,2bc <gets+0x52>
    cc = read(0, &c, 1);
 294:	4605                	li	a2,1
 296:	faf40593          	addi	a1,s0,-81
 29a:	4501                	li	a0,0
 29c:	1b2000ef          	jal	44e <read>
    if (cc < 1)
 2a0:	00a05e63          	blez	a0,2bc <gets+0x52>
    buf[i++] = c;
 2a4:	faf44783          	lbu	a5,-81(s0)
 2a8:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 2ac:	01578763          	beq	a5,s5,2ba <gets+0x50>
 2b0:	0905                	addi	s2,s2,1
 2b2:	fd679de3          	bne	a5,s6,28c <gets+0x22>
    buf[i++] = c;
 2b6:	89a6                	mv	s3,s1
 2b8:	a011                	j	2bc <gets+0x52>
 2ba:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2bc:	99de                	add	s3,s3,s7
 2be:	00098023          	sb	zero,0(s3)
  return buf;
}
 2c2:	855e                	mv	a0,s7
 2c4:	60e6                	ld	ra,88(sp)
 2c6:	6446                	ld	s0,80(sp)
 2c8:	64a6                	ld	s1,72(sp)
 2ca:	6906                	ld	s2,64(sp)
 2cc:	79e2                	ld	s3,56(sp)
 2ce:	7a42                	ld	s4,48(sp)
 2d0:	7aa2                	ld	s5,40(sp)
 2d2:	7b02                	ld	s6,32(sp)
 2d4:	6be2                	ld	s7,24(sp)
 2d6:	6125                	addi	sp,sp,96
 2d8:	8082                	ret

00000000000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	1101                	addi	sp,sp,-32
 2dc:	ec06                	sd	ra,24(sp)
 2de:	e822                	sd	s0,16(sp)
 2e0:	e04a                	sd	s2,0(sp)
 2e2:	1000                	addi	s0,sp,32
 2e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e6:	4581                	li	a1,0
 2e8:	18e000ef          	jal	476 <open>
  if (fd < 0)
 2ec:	02054263          	bltz	a0,310 <stat+0x36>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	198000ef          	jal	48e <fstat>
 2fa:	892a                	mv	s2,a0
  close(fd);
 2fc:	8526                	mv	a0,s1
 2fe:	160000ef          	jal	45e <close>
  return r;
 302:	64a2                	ld	s1,8(sp)
}
 304:	854a                	mv	a0,s2
 306:	60e2                	ld	ra,24(sp)
 308:	6442                	ld	s0,16(sp)
 30a:	6902                	ld	s2,0(sp)
 30c:	6105                	addi	sp,sp,32
 30e:	8082                	ret
    return -1;
 310:	597d                	li	s2,-1
 312:	bfcd                	j	304 <stat+0x2a>

0000000000000314 <atoi>:

int
atoi(const char *s)
{
 314:	1141                	addi	sp,sp,-16
 316:	e422                	sd	s0,8(sp)
 318:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 31a:	00054683          	lbu	a3,0(a0)
 31e:	fd06879b          	addiw	a5,a3,-48
 322:	0ff7f793          	zext.b	a5,a5
 326:	4625                	li	a2,9
 328:	02f66863          	bltu	a2,a5,358 <atoi+0x44>
 32c:	872a                	mv	a4,a0
  n = 0;
 32e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 330:	0705                	addi	a4,a4,1
 332:	0025179b          	slliw	a5,a0,0x2
 336:	9fa9                	addw	a5,a5,a0
 338:	0017979b          	slliw	a5,a5,0x1
 33c:	9fb5                	addw	a5,a5,a3
 33e:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 342:	00074683          	lbu	a3,0(a4)
 346:	fd06879b          	addiw	a5,a3,-48
 34a:	0ff7f793          	zext.b	a5,a5
 34e:	fef671e3          	bgeu	a2,a5,330 <atoi+0x1c>
  return n;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	addi	sp,sp,16
 356:	8082                	ret
  n = 0;
 358:	4501                	li	a0,0
 35a:	bfe5                	j	352 <atoi+0x3e>

000000000000035c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 362:	02b57463          	bgeu	a0,a1,38a <memmove+0x2e>
    while (n-- > 0)
 366:	00c05f63          	blez	a2,384 <memmove+0x28>
 36a:	1602                	slli	a2,a2,0x20
 36c:	9201                	srli	a2,a2,0x20
 36e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 372:	872a                	mv	a4,a0
      *dst++ = *src++;
 374:	0585                	addi	a1,a1,1
 376:	0705                	addi	a4,a4,1
 378:	fff5c683          	lbu	a3,-1(a1)
 37c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 380:	fef71ae3          	bne	a4,a5,374 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	addi	sp,sp,16
 388:	8082                	ret
    dst += n;
 38a:	00c50733          	add	a4,a0,a2
    src += n;
 38e:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 390:	fec05ae3          	blez	a2,384 <memmove+0x28>
 394:	fff6079b          	addiw	a5,a2,-1
 398:	1782                	slli	a5,a5,0x20
 39a:	9381                	srli	a5,a5,0x20
 39c:	fff7c793          	not	a5,a5
 3a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a2:	15fd                	addi	a1,a1,-1
 3a4:	177d                	addi	a4,a4,-1
 3a6:	0005c683          	lbu	a3,0(a1)
 3aa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 3ae:	fee79ae3          	bne	a5,a4,3a2 <memmove+0x46>
 3b2:	bfc9                	j	384 <memmove+0x28>

00000000000003b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ba:	ca05                	beqz	a2,3ea <memcmp+0x36>
 3bc:	fff6069b          	addiw	a3,a2,-1
 3c0:	1682                	slli	a3,a3,0x20
 3c2:	9281                	srli	a3,a3,0x20
 3c4:	0685                	addi	a3,a3,1
 3c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3c8:	00054783          	lbu	a5,0(a0)
 3cc:	0005c703          	lbu	a4,0(a1)
 3d0:	00e79863          	bne	a5,a4,3e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d4:	0505                	addi	a0,a0,1
    p2++;
 3d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3d8:	fed518e3          	bne	a0,a3,3c8 <memcmp+0x14>
  }
  return 0;
 3dc:	4501                	li	a0,0
 3de:	a019                	j	3e4 <memcmp+0x30>
      return *p1 - *p2;
 3e0:	40e7853b          	subw	a0,a5,a4
}
 3e4:	6422                	ld	s0,8(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
  return 0;
 3ea:	4501                	li	a0,0
 3ec:	bfe5                	j	3e4 <memcmp+0x30>

00000000000003ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e406                	sd	ra,8(sp)
 3f2:	e022                	sd	s0,0(sp)
 3f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f6:	f67ff0ef          	jal	35c <memmove>
}
 3fa:	60a2                	ld	ra,8(sp)
 3fc:	6402                	ld	s0,0(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <sbrk>:

char *
sbrk(int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 40a:	4585                	li	a1,1
 40c:	0b2000ef          	jal	4be <sys_sbrk>
}
 410:	60a2                	ld	ra,8(sp)
 412:	6402                	ld	s0,0(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <sbrklazy>:

char *
sbrklazy(int n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e406                	sd	ra,8(sp)
 41c:	e022                	sd	s0,0(sp)
 41e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 420:	4589                	li	a1,2
 422:	09c000ef          	jal	4be <sys_sbrk>
}
 426:	60a2                	ld	ra,8(sp)
 428:	6402                	ld	s0,0(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 42e:	4885                	li	a7,1
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exit>:
.global exit
exit:
 li a7, SYS_exit
 436:	4889                	li	a7,2
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <wait>:
.global wait
wait:
 li a7, SYS_wait
 43e:	488d                	li	a7,3
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 446:	4891                	li	a7,4
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <read>:
.global read
read:
 li a7, SYS_read
 44e:	4895                	li	a7,5
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <write>:
.global write
write:
 li a7, SYS_write
 456:	48c1                	li	a7,16
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <close>:
.global close
close:
 li a7, SYS_close
 45e:	48d5                	li	a7,21
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <kill>:
.global kill
kill:
 li a7, SYS_kill
 466:	4899                	li	a7,6
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exec>:
.global exec
exec:
 li a7, SYS_exec
 46e:	489d                	li	a7,7
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <open>:
.global open
open:
 li a7, SYS_open
 476:	48bd                	li	a7,15
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 47e:	48c5                	li	a7,17
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 486:	48c9                	li	a7,18
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 48e:	48a1                	li	a7,8
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <link>:
.global link
link:
 li a7, SYS_link
 496:	48cd                	li	a7,19
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 49e:	48d1                	li	a7,20
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4a6:	48a5                	li	a7,9
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ae:	48a9                	li	a7,10
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4b6:	48ad                	li	a7,11
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4be:	48b1                	li	a7,12
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4c6:	48b5                	li	a7,13
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ce:	48b9                	li	a7,14
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sync>:
.global sync
sync:
 li a7, SYS_sync
 4d6:	48d9                	li	a7,22
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <ps>:
.global ps
ps:
 li a7, SYS_ps
 4de:	48dd                	li	a7,23
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 4e6:	48e1                	li	a7,24
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4ee:	48e5                	li	a7,25
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4f6:	48e9                	li	a7,26
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <trace>:
.global trace
trace:
 li a7, SYS_trace
 4fe:	48ed                	li	a7,27
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 506:	48f1                	li	a7,28
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 50e:	48f5                	li	a7,29
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 516:	48f9                	li	a7,30
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 51e:	48fd                	li	a7,31
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 526:	02000893          	li	a7,32
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <halt>:
.global halt
halt:
 li a7, SYS_halt
 530:	02100893          	li	a7,33
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 53a:	02200893          	li	a7,34
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 544:	02300893          	li	a7,35
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 54e:	02400893          	li	a7,36
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 558:	02500893          	li	a7,37
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 562:	02600893          	li	a7,38
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 56c:	02700893          	li	a7,39
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 576:	1101                	addi	sp,sp,-32
 578:	ec06                	sd	ra,24(sp)
 57a:	e822                	sd	s0,16(sp)
 57c:	1000                	addi	s0,sp,32
 57e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 582:	4605                	li	a2,1
 584:	fef40593          	addi	a1,s0,-17
 588:	ecfff0ef          	jal	456 <write>
}
 58c:	60e2                	ld	ra,24(sp)
 58e:	6442                	ld	s0,16(sp)
 590:	6105                	addi	sp,sp,32
 592:	8082                	ret

0000000000000594 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 594:	715d                	addi	sp,sp,-80
 596:	e486                	sd	ra,72(sp)
 598:	e0a2                	sd	s0,64(sp)
 59a:	f84a                	sd	s2,48(sp)
 59c:	0880                	addi	s0,sp,80
 59e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 5a0:	c299                	beqz	a3,5a6 <printint+0x12>
 5a2:	0805c363          	bltz	a1,628 <printint+0x94>
  neg = 0;
 5a6:	4881                	li	a7,0
 5a8:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5ac:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 5ae:	00000517          	auipc	a0,0x0
 5b2:	71a50513          	addi	a0,a0,1818 # cc8 <digits>
 5b6:	883e                	mv	a6,a5
 5b8:	2785                	addiw	a5,a5,1
 5ba:	02c5f733          	remu	a4,a1,a2
 5be:	972a                	add	a4,a4,a0
 5c0:	00074703          	lbu	a4,0(a4)
 5c4:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 5c8:	872e                	mv	a4,a1
 5ca:	02c5d5b3          	divu	a1,a1,a2
 5ce:	0685                	addi	a3,a3,1
 5d0:	fec773e3          	bgeu	a4,a2,5b6 <printint+0x22>
  if (neg)
 5d4:	00088b63          	beqz	a7,5ea <printint+0x56>
    buf[i++] = '-';
 5d8:	fd078793          	addi	a5,a5,-48
 5dc:	97a2                	add	a5,a5,s0
 5de:	02d00713          	li	a4,45
 5e2:	fee78423          	sb	a4,-24(a5)
 5e6:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 5ea:	02f05a63          	blez	a5,61e <printint+0x8a>
 5ee:	fc26                	sd	s1,56(sp)
 5f0:	f44e                	sd	s3,40(sp)
 5f2:	fb840713          	addi	a4,s0,-72
 5f6:	00f704b3          	add	s1,a4,a5
 5fa:	fff70993          	addi	s3,a4,-1
 5fe:	99be                	add	s3,s3,a5
 600:	37fd                	addiw	a5,a5,-1
 602:	1782                	slli	a5,a5,0x20
 604:	9381                	srli	a5,a5,0x20
 606:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 60a:	fff4c583          	lbu	a1,-1(s1)
 60e:	854a                	mv	a0,s2
 610:	f67ff0ef          	jal	576 <putc>
  while (--i >= 0)
 614:	14fd                	addi	s1,s1,-1
 616:	ff349ae3          	bne	s1,s3,60a <printint+0x76>
 61a:	74e2                	ld	s1,56(sp)
 61c:	79a2                	ld	s3,40(sp)
}
 61e:	60a6                	ld	ra,72(sp)
 620:	6406                	ld	s0,64(sp)
 622:	7942                	ld	s2,48(sp)
 624:	6161                	addi	sp,sp,80
 626:	8082                	ret
    x = -xx;
 628:	40b005b3          	neg	a1,a1
    neg = 1;
 62c:	4885                	li	a7,1
    x = -xx;
 62e:	bfad                	j	5a8 <printint+0x14>

0000000000000630 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 630:	711d                	addi	sp,sp,-96
 632:	ec86                	sd	ra,88(sp)
 634:	e8a2                	sd	s0,80(sp)
 636:	e0ca                	sd	s2,64(sp)
 638:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 63a:	0005c903          	lbu	s2,0(a1)
 63e:	28090663          	beqz	s2,8ca <vprintf+0x29a>
 642:	e4a6                	sd	s1,72(sp)
 644:	fc4e                	sd	s3,56(sp)
 646:	f852                	sd	s4,48(sp)
 648:	f456                	sd	s5,40(sp)
 64a:	f05a                	sd	s6,32(sp)
 64c:	ec5e                	sd	s7,24(sp)
 64e:	e862                	sd	s8,16(sp)
 650:	e466                	sd	s9,8(sp)
 652:	8b2a                	mv	s6,a0
 654:	8a2e                	mv	s4,a1
 656:	8bb2                	mv	s7,a2
  state = 0;
 658:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 65a:	4481                	li	s1,0
 65c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 65e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 662:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 666:	06c00c93          	li	s9,108
 66a:	a005                	j	68a <vprintf+0x5a>
        putc(fd, c0);
 66c:	85ca                	mv	a1,s2
 66e:	855a                	mv	a0,s6
 670:	f07ff0ef          	jal	576 <putc>
 674:	a019                	j	67a <vprintf+0x4a>
    } else if (state == '%') {
 676:	03598263          	beq	s3,s5,69a <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 67a:	2485                	addiw	s1,s1,1
 67c:	8726                	mv	a4,s1
 67e:	009a07b3          	add	a5,s4,s1
 682:	0007c903          	lbu	s2,0(a5)
 686:	22090a63          	beqz	s2,8ba <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 68a:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 68e:	fe0994e3          	bnez	s3,676 <vprintf+0x46>
      if (c0 == '%') {
 692:	fd579de3          	bne	a5,s5,66c <vprintf+0x3c>
        state = '%';
 696:	89be                	mv	s3,a5
 698:	b7cd                	j	67a <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 69a:	00ea06b3          	add	a3,s4,a4
 69e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6a2:	8636                	mv	a2,a3
      if (c1)
 6a4:	c681                	beqz	a3,6ac <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 6a6:	9752                	add	a4,a4,s4
 6a8:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 6ac:	05878363          	beq	a5,s8,6f2 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 6b0:	05978d63          	beq	a5,s9,70a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 6b4:	07500713          	li	a4,117
 6b8:	0ee78763          	beq	a5,a4,7a6 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 6bc:	07800713          	li	a4,120
 6c0:	12e78963          	beq	a5,a4,7f2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 6c4:	07000713          	li	a4,112
 6c8:	14e78e63          	beq	a5,a4,824 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 6cc:	06300713          	li	a4,99
 6d0:	18e78e63          	beq	a5,a4,86c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 6d4:	07300713          	li	a4,115
 6d8:	1ae78463          	beq	a5,a4,880 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 6dc:	02500713          	li	a4,37
 6e0:	04e79563          	bne	a5,a4,72a <vprintf+0xfa>
        putc(fd, '%');
 6e4:	02500593          	li	a1,37
 6e8:	855a                	mv	a0,s6
 6ea:	e8dff0ef          	jal	576 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	b769                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6f2:	008b8913          	addi	s2,s7,8
 6f6:	4685                	li	a3,1
 6f8:	4629                	li	a2,10
 6fa:	000ba583          	lw	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e95ff0ef          	jal	594 <printint>
 704:	8bca                	mv	s7,s2
      state = 0;
 706:	4981                	li	s3,0
 708:	bf8d                	j	67a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 70a:	06400793          	li	a5,100
 70e:	02f68963          	beq	a3,a5,740 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 712:	06c00793          	li	a5,108
 716:	04f68263          	beq	a3,a5,75a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 71a:	07500793          	li	a5,117
 71e:	0af68063          	beq	a3,a5,7be <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 722:	07800793          	li	a5,120
 726:	0ef68263          	beq	a3,a5,80a <vprintf+0x1da>
        putc(fd, '%');
 72a:	02500593          	li	a1,37
 72e:	855a                	mv	a0,s6
 730:	e47ff0ef          	jal	576 <putc>
        putc(fd, c0);
 734:	85ca                	mv	a1,s2
 736:	855a                	mv	a0,s6
 738:	e3fff0ef          	jal	576 <putc>
      state = 0;
 73c:	4981                	li	s3,0
 73e:	bf35                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 740:	008b8913          	addi	s2,s7,8
 744:	4685                	li	a3,1
 746:	4629                	li	a2,10
 748:	000bb583          	ld	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	e47ff0ef          	jal	594 <printint>
        i += 1;
 752:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 754:	8bca                	mv	s7,s2
      state = 0;
 756:	4981                	li	s3,0
        i += 1;
 758:	b70d                	j	67a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 75a:	06400793          	li	a5,100
 75e:	02f60763          	beq	a2,a5,78c <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 762:	07500793          	li	a5,117
 766:	06f60963          	beq	a2,a5,7d8 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 76a:	07800793          	li	a5,120
 76e:	faf61ee3          	bne	a2,a5,72a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000bb583          	ld	a1,0(s7)
 77e:	855a                	mv	a0,s6
 780:	e15ff0ef          	jal	594 <printint>
        i += 2;
 784:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 786:	8bca                	mv	s7,s2
      state = 0;
 788:	4981                	li	s3,0
        i += 2;
 78a:	bdc5                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 78c:	008b8913          	addi	s2,s7,8
 790:	4685                	li	a3,1
 792:	4629                	li	a2,10
 794:	000bb583          	ld	a1,0(s7)
 798:	855a                	mv	a0,s6
 79a:	dfbff0ef          	jal	594 <printint>
        i += 2;
 79e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a0:	8bca                	mv	s7,s2
      state = 0;
 7a2:	4981                	li	s3,0
        i += 2;
 7a4:	bdd9                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4629                	li	a2,10
 7ae:	000be583          	lwu	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	de1ff0ef          	jal	594 <printint>
 7b8:	8bca                	mv	s7,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bd7d                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7be:	008b8913          	addi	s2,s7,8
 7c2:	4681                	li	a3,0
 7c4:	4629                	li	a2,10
 7c6:	000bb583          	ld	a1,0(s7)
 7ca:	855a                	mv	a0,s6
 7cc:	dc9ff0ef          	jal	594 <printint>
        i += 1;
 7d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d2:	8bca                	mv	s7,s2
      state = 0;
 7d4:	4981                	li	s3,0
        i += 1;
 7d6:	b555                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d8:	008b8913          	addi	s2,s7,8
 7dc:	4681                	li	a3,0
 7de:	4629                	li	a2,10
 7e0:	000bb583          	ld	a1,0(s7)
 7e4:	855a                	mv	a0,s6
 7e6:	dafff0ef          	jal	594 <printint>
        i += 2;
 7ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ec:	8bca                	mv	s7,s2
      state = 0;
 7ee:	4981                	li	s3,0
        i += 2;
 7f0:	b569                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7f2:	008b8913          	addi	s2,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4641                	li	a2,16
 7fa:	000be583          	lwu	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	d95ff0ef          	jal	594 <printint>
 804:	8bca                	mv	s7,s2
      state = 0;
 806:	4981                	li	s3,0
 808:	bd8d                	j	67a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 80a:	008b8913          	addi	s2,s7,8
 80e:	4681                	li	a3,0
 810:	4641                	li	a2,16
 812:	000bb583          	ld	a1,0(s7)
 816:	855a                	mv	a0,s6
 818:	d7dff0ef          	jal	594 <printint>
        i += 1;
 81c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 81e:	8bca                	mv	s7,s2
      state = 0;
 820:	4981                	li	s3,0
        i += 1;
 822:	bda1                	j	67a <vprintf+0x4a>
 824:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 826:	008b8d13          	addi	s10,s7,8
 82a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 82e:	03000593          	li	a1,48
 832:	855a                	mv	a0,s6
 834:	d43ff0ef          	jal	576 <putc>
  putc(fd, 'x');
 838:	07800593          	li	a1,120
 83c:	855a                	mv	a0,s6
 83e:	d39ff0ef          	jal	576 <putc>
 842:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 844:	00000b97          	auipc	s7,0x0
 848:	484b8b93          	addi	s7,s7,1156 # cc8 <digits>
 84c:	03c9d793          	srli	a5,s3,0x3c
 850:	97de                	add	a5,a5,s7
 852:	0007c583          	lbu	a1,0(a5)
 856:	855a                	mv	a0,s6
 858:	d1fff0ef          	jal	576 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 85c:	0992                	slli	s3,s3,0x4
 85e:	397d                	addiw	s2,s2,-1
 860:	fe0916e3          	bnez	s2,84c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 864:	8bea                	mv	s7,s10
      state = 0;
 866:	4981                	li	s3,0
 868:	6d02                	ld	s10,0(sp)
 86a:	bd01                	j	67a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 86c:	008b8913          	addi	s2,s7,8
 870:	000bc583          	lbu	a1,0(s7)
 874:	855a                	mv	a0,s6
 876:	d01ff0ef          	jal	576 <putc>
 87a:	8bca                	mv	s7,s2
      state = 0;
 87c:	4981                	li	s3,0
 87e:	bbf5                	j	67a <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 880:	008b8993          	addi	s3,s7,8
 884:	000bb903          	ld	s2,0(s7)
 888:	00090f63          	beqz	s2,8a6 <vprintf+0x276>
        for (; *s; s++)
 88c:	00094583          	lbu	a1,0(s2)
 890:	c195                	beqz	a1,8b4 <vprintf+0x284>
          putc(fd, *s);
 892:	855a                	mv	a0,s6
 894:	ce3ff0ef          	jal	576 <putc>
        for (; *s; s++)
 898:	0905                	addi	s2,s2,1
 89a:	00094583          	lbu	a1,0(s2)
 89e:	f9f5                	bnez	a1,892 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 8a0:	8bce                	mv	s7,s3
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	bbd9                	j	67a <vprintf+0x4a>
          s = "(null)";
 8a6:	00000917          	auipc	s2,0x0
 8aa:	41a90913          	addi	s2,s2,1050 # cc0 <malloc+0x30e>
        for (; *s; s++)
 8ae:	02800593          	li	a1,40
 8b2:	b7c5                	j	892 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 8b4:	8bce                	mv	s7,s3
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	b3c9                	j	67a <vprintf+0x4a>
 8ba:	64a6                	ld	s1,72(sp)
 8bc:	79e2                	ld	s3,56(sp)
 8be:	7a42                	ld	s4,48(sp)
 8c0:	7aa2                	ld	s5,40(sp)
 8c2:	7b02                	ld	s6,32(sp)
 8c4:	6be2                	ld	s7,24(sp)
 8c6:	6c42                	ld	s8,16(sp)
 8c8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ca:	60e6                	ld	ra,88(sp)
 8cc:	6446                	ld	s0,80(sp)
 8ce:	6906                	ld	s2,64(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d4:	715d                	addi	sp,sp,-80
 8d6:	ec06                	sd	ra,24(sp)
 8d8:	e822                	sd	s0,16(sp)
 8da:	1000                	addi	s0,sp,32
 8dc:	e010                	sd	a2,0(s0)
 8de:	e414                	sd	a3,8(s0)
 8e0:	e818                	sd	a4,16(s0)
 8e2:	ec1c                	sd	a5,24(s0)
 8e4:	03043023          	sd	a6,32(s0)
 8e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f0:	8622                	mv	a2,s0
 8f2:	d3fff0ef          	jal	630 <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6161                	addi	sp,sp,80
 8fc:	8082                	ret

00000000000008fe <printf>:

void
printf(const char *fmt, ...)
{
 8fe:	711d                	addi	sp,sp,-96
 900:	ec06                	sd	ra,24(sp)
 902:	e822                	sd	s0,16(sp)
 904:	1000                	addi	s0,sp,32
 906:	e40c                	sd	a1,8(s0)
 908:	e810                	sd	a2,16(s0)
 90a:	ec14                	sd	a3,24(s0)
 90c:	f018                	sd	a4,32(s0)
 90e:	f41c                	sd	a5,40(s0)
 910:	03043823          	sd	a6,48(s0)
 914:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	00840613          	addi	a2,s0,8
 91c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 920:	85aa                	mv	a1,a0
 922:	4505                	li	a0,1
 924:	d0dff0ef          	jal	630 <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6125                	addi	sp,sp,96
 92e:	8082                	ret

0000000000000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	1141                	addi	sp,sp,-16
 932:	e422                	sd	s0,8(sp)
 934:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 936:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93a:	00000797          	auipc	a5,0x0
 93e:	6c67b783          	ld	a5,1734(a5) # 1000 <freep>
 942:	a02d                	j	96c <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 944:	4618                	lw	a4,8(a2)
 946:	9f2d                	addw	a4,a4,a1
 948:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 94c:	6398                	ld	a4,0(a5)
 94e:	6310                	ld	a2,0(a4)
 950:	a83d                	j	98e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 952:	ff852703          	lw	a4,-8(a0)
 956:	9f31                	addw	a4,a4,a2
 958:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 95a:	ff053683          	ld	a3,-16(a0)
 95e:	a091                	j	9a2 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 960:	6398                	ld	a4,0(a5)
 962:	00e7e463          	bltu	a5,a4,96a <free+0x3a>
 966:	00e6ea63          	bltu	a3,a4,97a <free+0x4a>
{
 96a:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96c:	fed7fae3          	bgeu	a5,a3,960 <free+0x30>
 970:	6398                	ld	a4,0(a5)
 972:	00e6e463          	bltu	a3,a4,97a <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 976:	fee7eae3          	bltu	a5,a4,96a <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 97a:	ff852583          	lw	a1,-8(a0)
 97e:	6390                	ld	a2,0(a5)
 980:	02059813          	slli	a6,a1,0x20
 984:	01c85713          	srli	a4,a6,0x1c
 988:	9736                	add	a4,a4,a3
 98a:	fae60de3          	beq	a2,a4,944 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 98e:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 992:	4790                	lw	a2,8(a5)
 994:	02061593          	slli	a1,a2,0x20
 998:	01c5d713          	srli	a4,a1,0x1c
 99c:	973e                	add	a4,a4,a5
 99e:	fae68ae3          	beq	a3,a4,952 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9a2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9a4:	00000717          	auipc	a4,0x0
 9a8:	64f73e23          	sd	a5,1628(a4) # 1000 <freep>
}
 9ac:	6422                	ld	s0,8(sp)
 9ae:	0141                	addi	sp,sp,16
 9b0:	8082                	ret

00000000000009b2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 9b2:	7139                	addi	sp,sp,-64
 9b4:	fc06                	sd	ra,56(sp)
 9b6:	f822                	sd	s0,48(sp)
 9b8:	f426                	sd	s1,40(sp)
 9ba:	ec4e                	sd	s3,24(sp)
 9bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9be:	02051493          	slli	s1,a0,0x20
 9c2:	9081                	srli	s1,s1,0x20
 9c4:	04bd                	addi	s1,s1,15
 9c6:	8091                	srli	s1,s1,0x4
 9c8:	0014899b          	addiw	s3,s1,1
 9cc:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 9ce:	00000517          	auipc	a0,0x0
 9d2:	63253503          	ld	a0,1586(a0) # 1000 <freep>
 9d6:	c915                	beqz	a0,a0a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9d8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9da:	4798                	lw	a4,8(a5)
 9dc:	08977a63          	bgeu	a4,s1,a70 <malloc+0xbe>
 9e0:	f04a                	sd	s2,32(sp)
 9e2:	e852                	sd	s4,16(sp)
 9e4:	e456                	sd	s5,8(sp)
 9e6:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 9e8:	8a4e                	mv	s4,s3
 9ea:	0009871b          	sext.w	a4,s3
 9ee:	6685                	lui	a3,0x1
 9f0:	00d77363          	bgeu	a4,a3,9f6 <malloc+0x44>
 9f4:	6a05                	lui	s4,0x1
 9f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 9fe:	00000917          	auipc	s2,0x0
 a02:	60290913          	addi	s2,s2,1538 # 1000 <freep>
  if (p == SBRK_ERROR)
 a06:	5afd                	li	s5,-1
 a08:	a081                	j	a48 <malloc+0x96>
 a0a:	f04a                	sd	s2,32(sp)
 a0c:	e852                	sd	s4,16(sp)
 a0e:	e456                	sd	s5,8(sp)
 a10:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a12:	00000797          	auipc	a5,0x0
 a16:	5fe78793          	addi	a5,a5,1534 # 1010 <base>
 a1a:	00000717          	auipc	a4,0x0
 a1e:	5ef73323          	sd	a5,1510(a4) # 1000 <freep>
 a22:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a24:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a28:	b7c1                	j	9e8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a2a:	6398                	ld	a4,0(a5)
 a2c:	e118                	sd	a4,0(a0)
 a2e:	a8a9                	j	a88 <malloc+0xd6>
  hp->s.size = nu;
 a30:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a34:	0541                	addi	a0,a0,16
 a36:	efbff0ef          	jal	930 <free>
  return freep;
 a3a:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 a3e:	c12d                	beqz	a0,aa0 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a40:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a42:	4798                	lw	a4,8(a5)
 a44:	02977263          	bgeu	a4,s1,a68 <malloc+0xb6>
    if (p == freep)
 a48:	00093703          	ld	a4,0(s2)
 a4c:	853e                	mv	a0,a5
 a4e:	fef719e3          	bne	a4,a5,a40 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a52:	8552                	mv	a0,s4
 a54:	9afff0ef          	jal	402 <sbrk>
  if (p == SBRK_ERROR)
 a58:	fd551ce3          	bne	a0,s5,a30 <malloc+0x7e>
        return 0;
 a5c:	4501                	li	a0,0
 a5e:	7902                	ld	s2,32(sp)
 a60:	6a42                	ld	s4,16(sp)
 a62:	6aa2                	ld	s5,8(sp)
 a64:	6b02                	ld	s6,0(sp)
 a66:	a03d                	j	a94 <malloc+0xe2>
 a68:	7902                	ld	s2,32(sp)
 a6a:	6a42                	ld	s4,16(sp)
 a6c:	6aa2                	ld	s5,8(sp)
 a6e:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a70:	fae48de3          	beq	s1,a4,a2a <malloc+0x78>
        p->s.size -= nunits;
 a74:	4137073b          	subw	a4,a4,s3
 a78:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a7a:	02071693          	slli	a3,a4,0x20
 a7e:	01c6d713          	srli	a4,a3,0x1c
 a82:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a84:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a88:	00000717          	auipc	a4,0x0
 a8c:	56a73c23          	sd	a0,1400(a4) # 1000 <freep>
      return (void *)(p + 1);
 a90:	01078513          	addi	a0,a5,16
  }
}
 a94:	70e2                	ld	ra,56(sp)
 a96:	7442                	ld	s0,48(sp)
 a98:	74a2                	ld	s1,40(sp)
 a9a:	69e2                	ld	s3,24(sp)
 a9c:	6121                	addi	sp,sp,64
 a9e:	8082                	ret
 aa0:	7902                	ld	s2,32(sp)
 aa2:	6a42                	ld	s4,16(sp)
 aa4:	6aa2                	ld	s5,8(sp)
 aa6:	6b02                	ld	s6,0(sp)
 aa8:	b7f5                	j	a94 <malloc+0xe2>
