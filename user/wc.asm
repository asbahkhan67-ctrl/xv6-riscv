
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
  36:	20000d13          	li	s10,512
    for (i = 0; i < n; i++) {
      c++;
      if (buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if (strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	9d4a0a13          	addi	s4,s4,-1580 # a10 <malloc+0xf2>
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  44:	a035                	j	70 <wc+0x70>
      if (strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c8000ef          	jal	210 <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for (i = 0; i < n; i++) {
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if (buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if (!inword) {
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  70:	866a                	mv	a2,s10
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	3c4000ef          	jal	43c <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if (n < 0) {
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	99250513          	addi	a0,a0,-1646 # a30 <malloc+0x112>
  a6:	7c0000ef          	jal	866 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	95850513          	addi	a0,a0,-1704 # a20 <malloc+0x102>
  d0:	796000ef          	jal	866 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	34e000ef          	jal	424 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	35c000ef          	jal	464 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	330000ef          	jal	44c <close>
  for (i = 1; i < argc; i++) {
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2fc000ef          	jal	424 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8e658593          	addi	a1,a1,-1818 # a18 <malloc+0xfa>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2e2000ef          	jal	424 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8f650513          	addi	a0,a0,-1802 # a40 <malloc+0x122>
 152:	714000ef          	jal	866 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2cc000ef          	jal	424 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 164:	f77ff0ef          	jal	da <main>
  exit(r);
 168:	2bc000ef          	jal	424 <exit>

000000000000016c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0xa>
    ;
  return os;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e406                	sd	ra,8(sp)
 190:	e022                	sd	s0,0(sp)
 192:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x20>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x20>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf99                	beqz	a5,1e6 <strlen+0x2a>
 1ca:	0505                	addi	a0,a0,1
 1cc:	87aa                	mv	a5,a0
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x12>
 1d8:	40a6853b          	subw	a0,a3,a0
 1dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  for (n = 0; s[n]; n++)
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <strlen+0x22>

00000000000001ea <memset>:

void *
memset(void *dst, int c, uint n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1f2:	ca19                	beqz	a2,208 <memset+0x1e>
 1f4:	87aa                	mv	a5,a0
 1f6:	1602                	slli	a2,a2,0x20
 1f8:	9201                	srli	a2,a2,0x20
 1fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fe:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 202:	0785                	addi	a5,a5,1
 204:	fee79de3          	bne	a5,a4,1fe <memset+0x14>
  }
  return dst;
}
 208:	60a2                	ld	ra,8(sp)
 20a:	6402                	ld	s0,0(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret

0000000000000210 <strchr>:

char *
strchr(const char *s, char c)
{
 210:	1141                	addi	sp,sp,-16
 212:	e406                	sd	ra,8(sp)
 214:	e022                	sd	s0,0(sp)
 216:	0800                	addi	s0,sp,16
  for (; *s; s++)
 218:	00054783          	lbu	a5,0(a0)
 21c:	cf81                	beqz	a5,234 <strchr+0x24>
    if (*s == c)
 21e:	00f58763          	beq	a1,a5,22c <strchr+0x1c>
  for (; *s; s++)
 222:	0505                	addi	a0,a0,1
 224:	00054783          	lbu	a5,0(a0)
 228:	fbfd                	bnez	a5,21e <strchr+0xe>
      return (char *)s;
  return 0;
 22a:	4501                	li	a0,0
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  return 0;
 234:	4501                	li	a0,0
 236:	bfdd                	j	22c <strchr+0x1c>

0000000000000238 <gets>:

char *
gets(char *buf, int max)
{
 238:	7159                	addi	sp,sp,-112
 23a:	f486                	sd	ra,104(sp)
 23c:	f0a2                	sd	s0,96(sp)
 23e:	eca6                	sd	s1,88(sp)
 240:	e8ca                	sd	s2,80(sp)
 242:	e4ce                	sd	s3,72(sp)
 244:	e0d2                	sd	s4,64(sp)
 246:	fc56                	sd	s5,56(sp)
 248:	f85a                	sd	s6,48(sp)
 24a:	f45e                	sd	s7,40(sp)
 24c:	f062                	sd	s8,32(sp)
 24e:	ec66                	sd	s9,24(sp)
 250:	e86a                	sd	s10,16(sp)
 252:	1880                	addi	s0,sp,112
 254:	8caa                	mv	s9,a0
 256:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 258:	892a                	mv	s2,a0
 25a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 25c:	f9f40b13          	addi	s6,s0,-97
 260:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 262:	4ba9                	li	s7,10
 264:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 266:	8d26                	mv	s10,s1
 268:	0014899b          	addiw	s3,s1,1
 26c:	84ce                	mv	s1,s3
 26e:	0349d563          	bge	s3,s4,298 <gets+0x60>
    cc = read(0, &c, 1);
 272:	8656                	mv	a2,s5
 274:	85da                	mv	a1,s6
 276:	4501                	li	a0,0
 278:	1c4000ef          	jal	43c <read>
    if (cc < 1)
 27c:	00a05e63          	blez	a0,298 <gets+0x60>
    buf[i++] = c;
 280:	f9f44783          	lbu	a5,-97(s0)
 284:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 288:	01778763          	beq	a5,s7,296 <gets+0x5e>
 28c:	0905                	addi	s2,s2,1
 28e:	fd879ce3          	bne	a5,s8,266 <gets+0x2e>
    buf[i++] = c;
 292:	8d4e                	mv	s10,s3
 294:	a011                	j	298 <gets+0x60>
 296:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 298:	9d66                	add	s10,s10,s9
 29a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 29e:	8566                	mv	a0,s9
 2a0:	70a6                	ld	ra,104(sp)
 2a2:	7406                	ld	s0,96(sp)
 2a4:	64e6                	ld	s1,88(sp)
 2a6:	6946                	ld	s2,80(sp)
 2a8:	69a6                	ld	s3,72(sp)
 2aa:	6a06                	ld	s4,64(sp)
 2ac:	7ae2                	ld	s5,56(sp)
 2ae:	7b42                	ld	s6,48(sp)
 2b0:	7ba2                	ld	s7,40(sp)
 2b2:	7c02                	ld	s8,32(sp)
 2b4:	6ce2                	ld	s9,24(sp)
 2b6:	6d42                	ld	s10,16(sp)
 2b8:	6165                	addi	sp,sp,112
 2ba:	8082                	ret

00000000000002bc <stat>:

int
stat(const char *n, struct stat *st)
{
 2bc:	1101                	addi	sp,sp,-32
 2be:	ec06                	sd	ra,24(sp)
 2c0:	e822                	sd	s0,16(sp)
 2c2:	e04a                	sd	s2,0(sp)
 2c4:	1000                	addi	s0,sp,32
 2c6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	4581                	li	a1,0
 2ca:	19a000ef          	jal	464 <open>
  if (fd < 0)
 2ce:	02054263          	bltz	a0,2f2 <stat+0x36>
 2d2:	e426                	sd	s1,8(sp)
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	1a4000ef          	jal	47c <fstat>
 2dc:	892a                	mv	s2,a0
  close(fd);
 2de:	8526                	mv	a0,s1
 2e0:	16c000ef          	jal	44c <close>
  return r;
 2e4:	64a2                	ld	s1,8(sp)
}
 2e6:	854a                	mv	a0,s2
 2e8:	60e2                	ld	ra,24(sp)
 2ea:	6442                	ld	s0,16(sp)
 2ec:	6902                	ld	s2,0(sp)
 2ee:	6105                	addi	sp,sp,32
 2f0:	8082                	ret
    return -1;
 2f2:	597d                	li	s2,-1
 2f4:	bfcd                	j	2e6 <stat+0x2a>

00000000000002f6 <atoi>:

int
atoi(const char *s)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 2fe:	00054683          	lbu	a3,0(a0)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	4625                	li	a2,9
 30c:	02f66963          	bltu	a2,a5,33e <atoi+0x48>
 310:	872a                	mv	a4,a0
  n = 0;
 312:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 314:	0705                	addi	a4,a4,1
 316:	0025179b          	slliw	a5,a0,0x2
 31a:	9fa9                	addw	a5,a5,a0
 31c:	0017979b          	slliw	a5,a5,0x1
 320:	9fb5                	addw	a5,a5,a3
 322:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 326:	00074683          	lbu	a3,0(a4)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	fef671e3          	bgeu	a2,a5,314 <atoi+0x1e>
  return n;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  n = 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <atoi+0x40>

0000000000000342 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34a:	02b57563          	bgeu	a0,a1,374 <memmove+0x32>
    while (n-- > 0)
 34e:	00c05f63          	blez	a2,36c <memmove+0x2a>
 352:	1602                	slli	a2,a2,0x20
 354:	9201                	srli	a2,a2,0x20
 356:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 35a:	872a                	mv	a4,a0
      *dst++ = *src++;
 35c:	0585                	addi	a1,a1,1
 35e:	0705                	addi	a4,a4,1
 360:	fff5c683          	lbu	a3,-1(a1)
 364:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 368:	fee79ae3          	bne	a5,a4,35c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
    dst += n;
 374:	00c50733          	add	a4,a0,a2
    src += n;
 378:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 37a:	fec059e3          	blez	a2,36c <memmove+0x2a>
 37e:	fff6079b          	addiw	a5,a2,-1
 382:	1782                	slli	a5,a5,0x20
 384:	9381                	srli	a5,a5,0x20
 386:	fff7c793          	not	a5,a5
 38a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 38c:	15fd                	addi	a1,a1,-1
 38e:	177d                	addi	a4,a4,-1
 390:	0005c683          	lbu	a3,0(a1)
 394:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 398:	fef71ae3          	bne	a4,a5,38c <memmove+0x4a>
 39c:	bfc1                	j	36c <memmove+0x2a>

000000000000039e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39e:	1141                	addi	sp,sp,-16
 3a0:	e406                	sd	ra,8(sp)
 3a2:	e022                	sd	s0,0(sp)
 3a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a6:	ca0d                	beqz	a2,3d8 <memcmp+0x3a>
 3a8:	fff6069b          	addiw	a3,a2,-1
 3ac:	1682                	slli	a3,a3,0x20
 3ae:	9281                	srli	a3,a3,0x20
 3b0:	0685                	addi	a3,a3,1
 3b2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b4:	00054783          	lbu	a5,0(a0)
 3b8:	0005c703          	lbu	a4,0(a1)
 3bc:	00e79863          	bne	a5,a4,3cc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 3c0:	0505                	addi	a0,a0,1
    p2++;
 3c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c4:	fed518e3          	bne	a0,a3,3b4 <memcmp+0x16>
  }
  return 0;
 3c8:	4501                	li	a0,0
 3ca:	a019                	j	3d0 <memcmp+0x32>
      return *p1 - *p2;
 3cc:	40e7853b          	subw	a0,a5,a4
}
 3d0:	60a2                	ld	ra,8(sp)
 3d2:	6402                	ld	s0,0(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
  return 0;
 3d8:	4501                	li	a0,0
 3da:	bfdd                	j	3d0 <memcmp+0x32>

00000000000003dc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e406                	sd	ra,8(sp)
 3e0:	e022                	sd	s0,0(sp)
 3e2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e4:	f5fff0ef          	jal	342 <memmove>
}
 3e8:	60a2                	ld	ra,8(sp)
 3ea:	6402                	ld	s0,0(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <sbrk>:

char *
sbrk(int n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3f8:	4585                	li	a1,1
 3fa:	0b2000ef          	jal	4ac <sys_sbrk>
}
 3fe:	60a2                	ld	ra,8(sp)
 400:	6402                	ld	s0,0(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret

0000000000000406 <sbrklazy>:

char *
sbrklazy(int n)
{
 406:	1141                	addi	sp,sp,-16
 408:	e406                	sd	ra,8(sp)
 40a:	e022                	sd	s0,0(sp)
 40c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 40e:	4589                	li	a1,2
 410:	09c000ef          	jal	4ac <sys_sbrk>
}
 414:	60a2                	ld	ra,8(sp)
 416:	6402                	ld	s0,0(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret

000000000000041c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 41c:	4885                	li	a7,1
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <exit>:
.global exit
exit:
 li a7, SYS_exit
 424:	4889                	li	a7,2
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <wait>:
.global wait
wait:
 li a7, SYS_wait
 42c:	488d                	li	a7,3
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 434:	4891                	li	a7,4
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <read>:
.global read
read:
 li a7, SYS_read
 43c:	4895                	li	a7,5
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <write>:
.global write
write:
 li a7, SYS_write
 444:	48c1                	li	a7,16
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <close>:
.global close
close:
 li a7, SYS_close
 44c:	48d5                	li	a7,21
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <kill>:
.global kill
kill:
 li a7, SYS_kill
 454:	4899                	li	a7,6
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <exec>:
.global exec
exec:
 li a7, SYS_exec
 45c:	489d                	li	a7,7
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <open>:
.global open
open:
 li a7, SYS_open
 464:	48bd                	li	a7,15
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 46c:	48c5                	li	a7,17
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 474:	48c9                	li	a7,18
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 47c:	48a1                	li	a7,8
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <link>:
.global link
link:
 li a7, SYS_link
 484:	48cd                	li	a7,19
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 48c:	48d1                	li	a7,20
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 494:	48a5                	li	a7,9
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <dup>:
.global dup
dup:
 li a7, SYS_dup
 49c:	48a9                	li	a7,10
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4a4:	48ad                	li	a7,11
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4ac:	48b1                	li	a7,12
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4b4:	48b5                	li	a7,13
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4bc:	48b9                	li	a7,14
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 4c4:	48d9                	li	a7,22
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <ps>:
.global ps
ps:
 li a7, SYS_ps
 4cc:	48dd                	li	a7,23
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 4d4:	48e1                	li	a7,24
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4dc:	48e5                	li	a7,25
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4e4:	48e9                	li	a7,26
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ec:	1101                	addi	sp,sp,-32
 4ee:	ec06                	sd	ra,24(sp)
 4f0:	e822                	sd	s0,16(sp)
 4f2:	1000                	addi	s0,sp,32
 4f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f8:	4605                	li	a2,1
 4fa:	fef40593          	addi	a1,s0,-17
 4fe:	f47ff0ef          	jal	444 <write>
}
 502:	60e2                	ld	ra,24(sp)
 504:	6442                	ld	s0,16(sp)
 506:	6105                	addi	sp,sp,32
 508:	8082                	ret

000000000000050a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 50a:	715d                	addi	sp,sp,-80
 50c:	e486                	sd	ra,72(sp)
 50e:	e0a2                	sd	s0,64(sp)
 510:	fc26                	sd	s1,56(sp)
 512:	f84a                	sd	s2,48(sp)
 514:	f44e                	sd	s3,40(sp)
 516:	0880                	addi	s0,sp,80
 518:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 51a:	c299                	beqz	a3,520 <printint+0x16>
 51c:	0605cc63          	bltz	a1,594 <printint+0x8a>
  neg = 0;
 520:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 522:	fb840313          	addi	t1,s0,-72
  neg = 0;
 526:	869a                	mv	a3,t1
  i = 0;
 528:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 52a:	00000817          	auipc	a6,0x0
 52e:	53680813          	addi	a6,a6,1334 # a60 <digits>
 532:	88be                	mv	a7,a5
 534:	0017851b          	addiw	a0,a5,1
 538:	87aa                	mv	a5,a0
 53a:	02c5f733          	remu	a4,a1,a2
 53e:	9742                	add	a4,a4,a6
 540:	00074703          	lbu	a4,0(a4)
 544:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 548:	872e                	mv	a4,a1
 54a:	02c5d5b3          	divu	a1,a1,a2
 54e:	0685                	addi	a3,a3,1
 550:	fec771e3          	bgeu	a4,a2,532 <printint+0x28>
  if (neg)
 554:	000e0c63          	beqz	t3,56c <printint+0x62>
    buf[i++] = '-';
 558:	fd050793          	addi	a5,a0,-48
 55c:	00878533          	add	a0,a5,s0
 560:	02d00793          	li	a5,45
 564:	fef50423          	sb	a5,-24(a0)
 568:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 56c:	fff7899b          	addiw	s3,a5,-1
 570:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 574:	fff4c583          	lbu	a1,-1(s1)
 578:	854a                	mv	a0,s2
 57a:	f73ff0ef          	jal	4ec <putc>
  while (--i >= 0)
 57e:	39fd                	addiw	s3,s3,-1
 580:	14fd                	addi	s1,s1,-1
 582:	fe09d9e3          	bgez	s3,574 <printint+0x6a>
}
 586:	60a6                	ld	ra,72(sp)
 588:	6406                	ld	s0,64(sp)
 58a:	74e2                	ld	s1,56(sp)
 58c:	7942                	ld	s2,48(sp)
 58e:	79a2                	ld	s3,40(sp)
 590:	6161                	addi	sp,sp,80
 592:	8082                	ret
    x = -xx;
 594:	40b005b3          	neg	a1,a1
    neg = 1;
 598:	4e05                	li	t3,1
    x = -xx;
 59a:	b761                	j	522 <printint+0x18>

000000000000059c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 59c:	711d                	addi	sp,sp,-96
 59e:	ec86                	sd	ra,88(sp)
 5a0:	e8a2                	sd	s0,80(sp)
 5a2:	e4a6                	sd	s1,72(sp)
 5a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5a6:	0005c483          	lbu	s1,0(a1)
 5aa:	28048463          	beqz	s1,832 <vprintf+0x296>
 5ae:	e0ca                	sd	s2,64(sp)
 5b0:	fc4e                	sd	s3,56(sp)
 5b2:	f852                	sd	s4,48(sp)
 5b4:	f456                	sd	s5,40(sp)
 5b6:	f05a                	sd	s6,32(sp)
 5b8:	ec5e                	sd	s7,24(sp)
 5ba:	e862                	sd	s8,16(sp)
 5bc:	e466                	sd	s9,8(sp)
 5be:	8b2a                	mv	s6,a0
 5c0:	8a2e                	mv	s4,a1
 5c2:	8bb2                	mv	s7,a2
  state = 0;
 5c4:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5c6:	4901                	li	s2,0
 5c8:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5d2:	06c00c93          	li	s9,108
 5d6:	a00d                	j	5f8 <vprintf+0x5c>
        putc(fd, c0);
 5d8:	85a6                	mv	a1,s1
 5da:	855a                	mv	a0,s6
 5dc:	f11ff0ef          	jal	4ec <putc>
 5e0:	a019                	j	5e6 <vprintf+0x4a>
    } else if (state == '%') {
 5e2:	03598363          	beq	s3,s5,608 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 5e6:	0019079b          	addiw	a5,s2,1
 5ea:	893e                	mv	s2,a5
 5ec:	873e                	mv	a4,a5
 5ee:	97d2                	add	a5,a5,s4
 5f0:	0007c483          	lbu	s1,0(a5)
 5f4:	22048763          	beqz	s1,822 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 5f8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5fc:	fe0993e3          	bnez	s3,5e2 <vprintf+0x46>
      if (c0 == '%') {
 600:	fd579ce3          	bne	a5,s5,5d8 <vprintf+0x3c>
        state = '%';
 604:	89be                	mv	s3,a5
 606:	b7c5                	j	5e6 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 608:	00ea06b3          	add	a3,s4,a4
 60c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 610:	8636                	mv	a2,a3
      if (c1)
 612:	c681                	beqz	a3,61a <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 614:	9752                	add	a4,a4,s4
 616:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 61a:	05878263          	beq	a5,s8,65e <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 61e:	05978c63          	beq	a5,s9,676 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 622:	07500713          	li	a4,117
 626:	0ee78663          	beq	a5,a4,712 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 62a:	07800713          	li	a4,120
 62e:	12e78863          	beq	a5,a4,75e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 632:	07000713          	li	a4,112
 636:	14e78d63          	beq	a5,a4,790 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 63a:	06300713          	li	a4,99
 63e:	18e78c63          	beq	a5,a4,7d6 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 642:	07300713          	li	a4,115
 646:	1ae78263          	beq	a5,a4,7ea <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 64a:	02500713          	li	a4,37
 64e:	04e79463          	bne	a5,a4,696 <vprintf+0xfa>
        putc(fd, '%');
 652:	85ba                	mv	a1,a4
 654:	855a                	mv	a0,s6
 656:	e97ff0ef          	jal	4ec <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 65a:	4981                	li	s3,0
 65c:	b769                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e9fff0ef          	jal	50a <printint>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	bf8d                	j	5e6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 676:	06400793          	li	a5,100
 67a:	02f68963          	beq	a3,a5,6ac <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 67e:	06c00793          	li	a5,108
 682:	04f68263          	beq	a3,a5,6c6 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 686:	07500793          	li	a5,117
 68a:	0af68063          	beq	a3,a5,72a <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 68e:	07800793          	li	a5,120
 692:	0ef68263          	beq	a3,a5,776 <vprintf+0x1da>
        putc(fd, '%');
 696:	02500593          	li	a1,37
 69a:	855a                	mv	a0,s6
 69c:	e51ff0ef          	jal	4ec <putc>
        putc(fd, c0);
 6a0:	85a6                	mv	a1,s1
 6a2:	855a                	mv	a0,s6
 6a4:	e49ff0ef          	jal	4ec <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bf35                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	e51ff0ef          	jal	50a <printint>
        i += 1;
 6be:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	8ba6                	mv	s7,s1
      state = 0;
 6c2:	4981                	li	s3,0
        i += 1;
 6c4:	b70d                	j	5e6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 6c6:	06400793          	li	a5,100
 6ca:	02f60763          	beq	a2,a5,6f8 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 6ce:	07500793          	li	a5,117
 6d2:	06f60963          	beq	a2,a5,744 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 6d6:	07800793          	li	a5,120
 6da:	faf61ee3          	bne	a2,a5,696 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e1fff0ef          	jal	50a <printint>
        i += 2;
 6f0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
        i += 2;
 6f6:	bdc5                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4685                	li	a3,1
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e05ff0ef          	jal	50a <printint>
        i += 2;
 70a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	bdd9                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 712:	008b8493          	addi	s1,s7,8
 716:	4681                	li	a3,0
 718:	4629                	li	a2,10
 71a:	000be583          	lwu	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	debff0ef          	jal	50a <printint>
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
 728:	bd7d                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4681                	li	a3,0
 730:	4629                	li	a2,10
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	dd3ff0ef          	jal	50a <printint>
        i += 1;
 73c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
        i += 1;
 742:	b555                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4629                	li	a2,10
 74c:	000bb583          	ld	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	db9ff0ef          	jal	50a <printint>
        i += 2;
 756:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
        i += 2;
 75c:	b569                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 75e:	008b8493          	addi	s1,s7,8
 762:	4681                	li	a3,0
 764:	4641                	li	a2,16
 766:	000be583          	lwu	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	d9fff0ef          	jal	50a <printint>
 770:	8ba6                	mv	s7,s1
      state = 0;
 772:	4981                	li	s3,0
 774:	bd8d                	j	5e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 776:	008b8493          	addi	s1,s7,8
 77a:	4681                	li	a3,0
 77c:	4641                	li	a2,16
 77e:	000bb583          	ld	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	d87ff0ef          	jal	50a <printint>
        i += 1;
 788:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 78a:	8ba6                	mv	s7,s1
      state = 0;
 78c:	4981                	li	s3,0
        i += 1;
 78e:	bda1                	j	5e6 <vprintf+0x4a>
 790:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 792:	008b8d13          	addi	s10,s7,8
 796:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 79a:	03000593          	li	a1,48
 79e:	855a                	mv	a0,s6
 7a0:	d4dff0ef          	jal	4ec <putc>
  putc(fd, 'x');
 7a4:	07800593          	li	a1,120
 7a8:	855a                	mv	a0,s6
 7aa:	d43ff0ef          	jal	4ec <putc>
 7ae:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b0:	00000b97          	auipc	s7,0x0
 7b4:	2b0b8b93          	addi	s7,s7,688 # a60 <digits>
 7b8:	03c9d793          	srli	a5,s3,0x3c
 7bc:	97de                	add	a5,a5,s7
 7be:	0007c583          	lbu	a1,0(a5)
 7c2:	855a                	mv	a0,s6
 7c4:	d29ff0ef          	jal	4ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c8:	0992                	slli	s3,s3,0x4
 7ca:	34fd                	addiw	s1,s1,-1
 7cc:	f4f5                	bnez	s1,7b8 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7ce:	8bea                	mv	s7,s10
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	6d02                	ld	s10,0(sp)
 7d4:	bd09                	j	5e6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7d6:	008b8493          	addi	s1,s7,8
 7da:	000bc583          	lbu	a1,0(s7)
 7de:	855a                	mv	a0,s6
 7e0:	d0dff0ef          	jal	4ec <putc>
 7e4:	8ba6                	mv	s7,s1
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bbfd                	j	5e6 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 7ea:	008b8993          	addi	s3,s7,8
 7ee:	000bb483          	ld	s1,0(s7)
 7f2:	cc91                	beqz	s1,80e <vprintf+0x272>
        for (; *s; s++)
 7f4:	0004c583          	lbu	a1,0(s1)
 7f8:	c195                	beqz	a1,81c <vprintf+0x280>
          putc(fd, *s);
 7fa:	855a                	mv	a0,s6
 7fc:	cf1ff0ef          	jal	4ec <putc>
        for (; *s; s++)
 800:	0485                	addi	s1,s1,1
 802:	0004c583          	lbu	a1,0(s1)
 806:	f9f5                	bnez	a1,7fa <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 808:	8bce                	mv	s7,s3
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bbe9                	j	5e6 <vprintf+0x4a>
          s = "(null)";
 80e:	00000497          	auipc	s1,0x0
 812:	24a48493          	addi	s1,s1,586 # a58 <malloc+0x13a>
        for (; *s; s++)
 816:	02800593          	li	a1,40
 81a:	b7c5                	j	7fa <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 81c:	8bce                	mv	s7,s3
      state = 0;
 81e:	4981                	li	s3,0
 820:	b3d9                	j	5e6 <vprintf+0x4a>
 822:	6906                	ld	s2,64(sp)
 824:	79e2                	ld	s3,56(sp)
 826:	7a42                	ld	s4,48(sp)
 828:	7aa2                	ld	s5,40(sp)
 82a:	7b02                	ld	s6,32(sp)
 82c:	6be2                	ld	s7,24(sp)
 82e:	6c42                	ld	s8,16(sp)
 830:	6ca2                	ld	s9,8(sp)
    }
  }
}
 832:	60e6                	ld	ra,88(sp)
 834:	6446                	ld	s0,80(sp)
 836:	64a6                	ld	s1,72(sp)
 838:	6125                	addi	sp,sp,96
 83a:	8082                	ret

000000000000083c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83c:	715d                	addi	sp,sp,-80
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e010                	sd	a2,0(s0)
 846:	e414                	sd	a3,8(s0)
 848:	e818                	sd	a4,16(s0)
 84a:	ec1c                	sd	a5,24(s0)
 84c:	03043023          	sd	a6,32(s0)
 850:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	8622                	mv	a2,s0
 856:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85a:	d43ff0ef          	jal	59c <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6161                	addi	sp,sp,80
 864:	8082                	ret

0000000000000866 <printf>:

void
printf(const char *fmt, ...)
{
 866:	711d                	addi	sp,sp,-96
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e40c                	sd	a1,8(s0)
 870:	e810                	sd	a2,16(s0)
 872:	ec14                	sd	a3,24(s0)
 874:	f018                	sd	a4,32(s0)
 876:	f41c                	sd	a5,40(s0)
 878:	03043823          	sd	a6,48(s0)
 87c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 880:	00840613          	addi	a2,s0,8
 884:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 888:	85aa                	mv	a1,a0
 88a:	4505                	li	a0,1
 88c:	d11ff0ef          	jal	59c <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6125                	addi	sp,sp,96
 896:	8082                	ret

0000000000000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	1141                	addi	sp,sp,-16
 89a:	e406                	sd	ra,8(sp)
 89c:	e022                	sd	s0,0(sp)
 89e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8a0:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	00000797          	auipc	a5,0x0
 8a8:	75c7b783          	ld	a5,1884(a5) # 1000 <freep>
 8ac:	a02d                	j	8d6 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 8ae:	4618                	lw	a4,8(a2)
 8b0:	9f2d                	addw	a4,a4,a1
 8b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	6310                	ld	a2,0(a4)
 8ba:	a83d                	j	8f8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 8bc:	ff852703          	lw	a4,-8(a0)
 8c0:	9f31                	addw	a4,a4,a2
 8c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c4:	ff053683          	ld	a3,-16(a0)
 8c8:	a091                	j	90c <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ca:	6398                	ld	a4,0(a5)
 8cc:	00e7e463          	bltu	a5,a4,8d4 <free+0x3c>
 8d0:	00e6ea63          	bltu	a3,a4,8e4 <free+0x4c>
{
 8d4:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	fed7fae3          	bgeu	a5,a3,8ca <free+0x32>
 8da:	6398                	ld	a4,0(a5)
 8dc:	00e6e463          	bltu	a3,a4,8e4 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	fee7eae3          	bltu	a5,a4,8d4 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 8e4:	ff852583          	lw	a1,-8(a0)
 8e8:	6390                	ld	a2,0(a5)
 8ea:	02059813          	slli	a6,a1,0x20
 8ee:	01c85713          	srli	a4,a6,0x1c
 8f2:	9736                	add	a4,a4,a3
 8f4:	fae60de3          	beq	a2,a4,8ae <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 8f8:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 8fc:	4790                	lw	a2,8(a5)
 8fe:	02061593          	slli	a1,a2,0x20
 902:	01c5d713          	srli	a4,a1,0x1c
 906:	973e                	add	a4,a4,a5
 908:	fae68ae3          	beq	a3,a4,8bc <free+0x24>
    p->s.ptr = bp->s.ptr;
 90c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 90e:	00000717          	auipc	a4,0x0
 912:	6ef73923          	sd	a5,1778(a4) # 1000 <freep>
}
 916:	60a2                	ld	ra,8(sp)
 918:	6402                	ld	s0,0(sp)
 91a:	0141                	addi	sp,sp,16
 91c:	8082                	ret

000000000000091e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 91e:	7139                	addi	sp,sp,-64
 920:	fc06                	sd	ra,56(sp)
 922:	f822                	sd	s0,48(sp)
 924:	f04a                	sd	s2,32(sp)
 926:	ec4e                	sd	s3,24(sp)
 928:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 92a:	02051993          	slli	s3,a0,0x20
 92e:	0209d993          	srli	s3,s3,0x20
 932:	09bd                	addi	s3,s3,15
 934:	0049d993          	srli	s3,s3,0x4
 938:	2985                	addiw	s3,s3,1
 93a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 93c:	00000517          	auipc	a0,0x0
 940:	6c453503          	ld	a0,1732(a0) # 1000 <freep>
 944:	c905                	beqz	a0,974 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 946:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 948:	4798                	lw	a4,8(a5)
 94a:	09377663          	bgeu	a4,s3,9d6 <malloc+0xb8>
 94e:	f426                	sd	s1,40(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 956:	8a4e                	mv	s4,s3
 958:	6705                	lui	a4,0x1
 95a:	00e9f363          	bgeu	s3,a4,960 <malloc+0x42>
 95e:	6a05                	lui	s4,0x1
 960:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 964:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 968:	00000497          	auipc	s1,0x0
 96c:	69848493          	addi	s1,s1,1688 # 1000 <freep>
  if (p == SBRK_ERROR)
 970:	5afd                	li	s5,-1
 972:	a83d                	j	9b0 <malloc+0x92>
 974:	f426                	sd	s1,40(sp)
 976:	e852                	sd	s4,16(sp)
 978:	e456                	sd	s5,8(sp)
 97a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97c:	00001797          	auipc	a5,0x1
 980:	89478793          	addi	a5,a5,-1900 # 1210 <base>
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
 98c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 992:	b7d1                	j	956 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	e118                	sd	a4,0(a0)
 998:	a899                	j	9ee <malloc+0xd0>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	ef9ff0ef          	jal	898 <free>
  return freep;
 9a4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 9a6:	c125                	beqz	a0,a06 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9a8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9aa:	4798                	lw	a4,8(a5)
 9ac:	03277163          	bgeu	a4,s2,9ce <malloc+0xb0>
    if (p == freep)
 9b0:	6098                	ld	a4,0(s1)
 9b2:	853e                	mv	a0,a5
 9b4:	fef71ae3          	bne	a4,a5,9a8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9b8:	8552                	mv	a0,s4
 9ba:	a37ff0ef          	jal	3f0 <sbrk>
  if (p == SBRK_ERROR)
 9be:	fd551ee3          	bne	a0,s5,99a <malloc+0x7c>
        return 0;
 9c2:	4501                	li	a0,0
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
 9cc:	a03d                	j	9fa <malloc+0xdc>
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9d6:	fae90fe3          	beq	s2,a4,994 <malloc+0x76>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	02071693          	slli	a3,a4,0x20
 9e4:	01c6d713          	srli	a4,a3,0x1c
 9e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60a73923          	sd	a0,1554(a4) # 1000 <freep>
      return (void *)(p + 1);
 9f6:	01078513          	addi	a0,a5,16
  }
}
 9fa:	70e2                	ld	ra,56(sp)
 9fc:	7442                	ld	s0,48(sp)
 9fe:	7902                	ld	s2,32(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6121                	addi	sp,sp,64
 a04:	8082                	ret
 a06:	74a2                	ld	s1,40(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	b7f5                	j	9fa <malloc+0xdc>
