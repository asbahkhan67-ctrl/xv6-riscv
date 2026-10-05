
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/param.h"
#include "user/user.h"

int
main(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  int fd;
  int fd2;
  char *p;
  char buf[8];

  printf("mmaptest: starting\n");
   8:	00001517          	auipc	a0,0x1
   c:	ad850513          	addi	a0,a0,-1320 # ae0 <malloc+0xf6>
  10:	123000ef          	jal	932 <printf>

  fd = open("mmapfile", O_CREATE | O_RDWR);
  14:	20200593          	li	a1,514
  18:	00001517          	auipc	a0,0x1
  1c:	ae050513          	addi	a0,a0,-1312 # af8 <malloc+0x10e>
  20:	510000ef          	jal	530 <open>

  if(fd < 0){
  24:	02054b63          	bltz	a0,5a <main+0x5a>
  28:	ec26                	sd	s1,24(sp)
  2a:	84aa                	mv	s1,a0
    printf("mmaptest: open failed\n");
    exit(1);
  }

  if(write(fd, "hello", 5) != 5){
  2c:	4615                	li	a2,5
  2e:	00001597          	auipc	a1,0x1
  32:	af258593          	addi	a1,a1,-1294 # b20 <malloc+0x136>
  36:	4da000ef          	jal	510 <write>
  3a:	4795                	li	a5,5
  3c:	02f50a63          	beq	a0,a5,70 <main+0x70>
  40:	e84a                	sd	s2,16(sp)
    printf("mmaptest: write failed\n");
  42:	00001517          	auipc	a0,0x1
  46:	ae650513          	addi	a0,a0,-1306 # b28 <malloc+0x13e>
  4a:	0e9000ef          	jal	932 <printf>
    close(fd);
  4e:	8526                	mv	a0,s1
  50:	4c8000ef          	jal	518 <close>
    exit(1);
  54:	4505                	li	a0,1
  56:	49a000ef          	jal	4f0 <exit>
  5a:	ec26                	sd	s1,24(sp)
  5c:	e84a                	sd	s2,16(sp)
    printf("mmaptest: open failed\n");
  5e:	00001517          	auipc	a0,0x1
  62:	aaa50513          	addi	a0,a0,-1366 # b08 <malloc+0x11e>
  66:	0cd000ef          	jal	932 <printf>
    exit(1);
  6a:	4505                	li	a0,1
  6c:	484000ef          	jal	4f0 <exit>
  70:	e84a                	sd	s2,16(sp)
  }

  p = mmap(0, 4096, PROT_READ | PROT_WRITE,
  72:	4781                	li	a5,0
  74:	8726                	mv	a4,s1
  76:	4685                	li	a3,1
  78:	460d                	li	a2,3
  7a:	6585                	lui	a1,0x1
  7c:	4501                	li	a0,0
  7e:	52a000ef          	jal	5a8 <mmap>
  82:	892a                	mv	s2,a0
           MAP_SHARED, fd, 0);

  if(p == (char *)-1){
  84:	57fd                	li	a5,-1
  86:	02f50863          	beq	a0,a5,b6 <main+0xb6>
    printf("mmaptest: shared mmap failed\n");
    close(fd);
    exit(1);
  }

  printf("mmaptest: mapped address %p\n", p);
  8a:	85aa                	mv	a1,a0
  8c:	00001517          	auipc	a0,0x1
  90:	ad450513          	addi	a0,a0,-1324 # b60 <malloc+0x176>
  94:	09f000ef          	jal	932 <printf>

  if(p[0] != 'h'){
  98:	00094583          	lbu	a1,0(s2)
  9c:	06800793          	li	a5,104
  a0:	02f58763          	beq	a1,a5,ce <main+0xce>
    printf("mmaptest: file data incorrect: %c\n", p[0]);
  a4:	00001517          	auipc	a0,0x1
  a8:	adc50513          	addi	a0,a0,-1316 # b80 <malloc+0x196>
  ac:	087000ef          	jal	932 <printf>
    exit(1);
  b0:	4505                	li	a0,1
  b2:	43e000ef          	jal	4f0 <exit>
    printf("mmaptest: shared mmap failed\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	a8a50513          	addi	a0,a0,-1398 # b40 <malloc+0x156>
  be:	075000ef          	jal	932 <printf>
    close(fd);
  c2:	8526                	mv	a0,s1
  c4:	454000ef          	jal	518 <close>
    exit(1);
  c8:	4505                	li	a0,1
  ca:	426000ef          	jal	4f0 <exit>
  }

  p[0] = 'H';
  ce:	04800793          	li	a5,72
  d2:	00f90023          	sb	a5,0(s2)

  if(munmap(p, 4096) < 0){
  d6:	6585                	lui	a1,0x1
  d8:	854a                	mv	a0,s2
  da:	4d6000ef          	jal	5b0 <munmap>
  de:	04054d63          	bltz	a0,138 <main+0x138>
    printf("mmaptest: shared munmap failed\n");
    exit(1);
  }

  close(fd);
  e2:	8526                	mv	a0,s1
  e4:	434000ef          	jal	518 <close>

  fd2 = open("mmapfile", O_RDONLY);
  e8:	4581                	li	a1,0
  ea:	00001517          	auipc	a0,0x1
  ee:	a0e50513          	addi	a0,a0,-1522 # af8 <malloc+0x10e>
  f2:	43e000ef          	jal	530 <open>
  f6:	84aa                	mv	s1,a0

  if(fd2 < 0){
  f8:	04054963          	bltz	a0,14a <main+0x14a>
    printf("mmaptest: reopen failed\n");
    exit(1);
  }

  memset(buf, 0, sizeof(buf));
  fc:	fd840913          	addi	s2,s0,-40
 100:	4621                	li	a2,8
 102:	4581                	li	a1,0
 104:	854a                	mv	a0,s2
 106:	1b0000ef          	jal	2b6 <memset>

  if(read(fd2, buf, 5) != 5){
 10a:	4615                	li	a2,5
 10c:	85ca                	mv	a1,s2
 10e:	8526                	mv	a0,s1
 110:	3f8000ef          	jal	508 <read>
 114:	4795                	li	a5,5
 116:	04f51363          	bne	a0,a5,15c <main+0x15c>
    printf("mmaptest: readback failed\n");
    exit(1);
  }

  if(buf[0] != 'H'){
 11a:	fd844583          	lbu	a1,-40(s0)
 11e:	04800793          	li	a5,72
 122:	04f58663          	beq	a1,a5,16e <main+0x16e>
    printf("mmaptest: shared writeback failed: %c\n", buf[0]);
 126:	00001517          	auipc	a0,0x1
 12a:	ae250513          	addi	a0,a0,-1310 # c08 <malloc+0x21e>
 12e:	005000ef          	jal	932 <printf>
    exit(1);
 132:	4505                	li	a0,1
 134:	3bc000ef          	jal	4f0 <exit>
    printf("mmaptest: shared munmap failed\n");
 138:	00001517          	auipc	a0,0x1
 13c:	a7050513          	addi	a0,a0,-1424 # ba8 <malloc+0x1be>
 140:	7f2000ef          	jal	932 <printf>
    exit(1);
 144:	4505                	li	a0,1
 146:	3aa000ef          	jal	4f0 <exit>
    printf("mmaptest: reopen failed\n");
 14a:	00001517          	auipc	a0,0x1
 14e:	a7e50513          	addi	a0,a0,-1410 # bc8 <malloc+0x1de>
 152:	7e0000ef          	jal	932 <printf>
    exit(1);
 156:	4505                	li	a0,1
 158:	398000ef          	jal	4f0 <exit>
    printf("mmaptest: readback failed\n");
 15c:	00001517          	auipc	a0,0x1
 160:	a8c50513          	addi	a0,a0,-1396 # be8 <malloc+0x1fe>
 164:	7ce000ef          	jal	932 <printf>
    exit(1);
 168:	4505                	li	a0,1
 16a:	386000ef          	jal	4f0 <exit>
  }

  close(fd2);
 16e:	8526                	mv	a0,s1
 170:	3a8000ef          	jal	518 <close>

  fd = open("mmapfile", O_RDWR);
 174:	4589                	li	a1,2
 176:	00001517          	auipc	a0,0x1
 17a:	98250513          	addi	a0,a0,-1662 # af8 <malloc+0x10e>
 17e:	3b2000ef          	jal	530 <open>
 182:	84aa                	mv	s1,a0

  if(fd < 0){
 184:	02054c63          	bltz	a0,1bc <main+0x1bc>
    printf("mmaptest: second open failed\n");
    exit(1);
  }

  p = mmap(0, 4096, PROT_READ | PROT_WRITE,
 188:	4781                	li	a5,0
 18a:	872a                	mv	a4,a0
 18c:	4689                	li	a3,2
 18e:	460d                	li	a2,3
 190:	6585                	lui	a1,0x1
 192:	4501                	li	a0,0
 194:	414000ef          	jal	5a8 <mmap>
           MAP_PRIVATE, fd, 0);

  if(p == (char *)-1){
 198:	57fd                	li	a5,-1
 19a:	02f50a63          	beq	a0,a5,1ce <main+0x1ce>
    printf("mmaptest: private mmap failed\n");
    exit(1);
  }

  if(p[0] != 'H'){
 19e:	00054703          	lbu	a4,0(a0)
 1a2:	04800793          	li	a5,72
 1a6:	02f70d63          	beq	a4,a5,1e0 <main+0x1e0>
    printf("mmaptest: private read failed\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	ac650513          	addi	a0,a0,-1338 # c70 <malloc+0x286>
 1b2:	780000ef          	jal	932 <printf>
    exit(1);
 1b6:	4505                	li	a0,1
 1b8:	338000ef          	jal	4f0 <exit>
    printf("mmaptest: second open failed\n");
 1bc:	00001517          	auipc	a0,0x1
 1c0:	a7450513          	addi	a0,a0,-1420 # c30 <malloc+0x246>
 1c4:	76e000ef          	jal	932 <printf>
    exit(1);
 1c8:	4505                	li	a0,1
 1ca:	326000ef          	jal	4f0 <exit>
    printf("mmaptest: private mmap failed\n");
 1ce:	00001517          	auipc	a0,0x1
 1d2:	a8250513          	addi	a0,a0,-1406 # c50 <malloc+0x266>
 1d6:	75c000ef          	jal	932 <printf>
    exit(1);
 1da:	4505                	li	a0,1
 1dc:	314000ef          	jal	4f0 <exit>
  }

  p[0] = 'X';
 1e0:	05800793          	li	a5,88
 1e4:	00f50023          	sb	a5,0(a0)

  if(munmap(p, 4096) < 0){
 1e8:	6585                	lui	a1,0x1
 1ea:	3c6000ef          	jal	5b0 <munmap>
 1ee:	02054463          	bltz	a0,216 <main+0x216>
    printf("mmaptest: private munmap failed\n");
    exit(1);
  }

  close(fd);
 1f2:	8526                	mv	a0,s1
 1f4:	324000ef          	jal	518 <close>

  printf("mmaptest: ALL TESTS PASSED\n");
 1f8:	00001517          	auipc	a0,0x1
 1fc:	ac050513          	addi	a0,a0,-1344 # cb8 <malloc+0x2ce>
 200:	732000ef          	jal	932 <printf>

  unlink("mmapfile");
 204:	00001517          	auipc	a0,0x1
 208:	8f450513          	addi	a0,a0,-1804 # af8 <malloc+0x10e>
 20c:	334000ef          	jal	540 <unlink>
  exit(0);
 210:	4501                	li	a0,0
 212:	2de000ef          	jal	4f0 <exit>
    printf("mmaptest: private munmap failed\n");
 216:	00001517          	auipc	a0,0x1
 21a:	a7a50513          	addi	a0,a0,-1414 # c90 <malloc+0x2a6>
 21e:	714000ef          	jal	932 <printf>
    exit(1);
 222:	4505                	li	a0,1
 224:	2cc000ef          	jal	4f0 <exit>

0000000000000228 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 230:	dd1ff0ef          	jal	0 <main>
  exit(r);
 234:	2bc000ef          	jal	4f0 <exit>

0000000000000238 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e406                	sd	ra,8(sp)
 23c:	e022                	sd	s0,0(sp)
 23e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 240:	87aa                	mv	a5,a0
 242:	0585                	addi	a1,a1,1 # 1001 <freep+0x1>
 244:	0785                	addi	a5,a5,1
 246:	fff5c703          	lbu	a4,-1(a1)
 24a:	fee78fa3          	sb	a4,-1(a5)
 24e:	fb75                	bnez	a4,242 <strcpy+0xa>
    ;
  return os;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret

0000000000000258 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 260:	00054783          	lbu	a5,0(a0)
 264:	cb91                	beqz	a5,278 <strcmp+0x20>
 266:	0005c703          	lbu	a4,0(a1)
 26a:	00f71763          	bne	a4,a5,278 <strcmp+0x20>
    p++, q++;
 26e:	0505                	addi	a0,a0,1
 270:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 272:	00054783          	lbu	a5,0(a0)
 276:	fbe5                	bnez	a5,266 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 278:	0005c503          	lbu	a0,0(a1)
}
 27c:	40a7853b          	subw	a0,a5,a0
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strlen>:

uint
strlen(const char *s)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 290:	00054783          	lbu	a5,0(a0)
 294:	cf99                	beqz	a5,2b2 <strlen+0x2a>
 296:	0505                	addi	a0,a0,1
 298:	87aa                	mv	a5,a0
 29a:	86be                	mv	a3,a5
 29c:	0785                	addi	a5,a5,1
 29e:	fff7c703          	lbu	a4,-1(a5)
 2a2:	ff65                	bnez	a4,29a <strlen+0x12>
 2a4:	40a6853b          	subw	a0,a3,a0
 2a8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2aa:	60a2                	ld	ra,8(sp)
 2ac:	6402                	ld	s0,0(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
  for (n = 0; s[n]; n++)
 2b2:	4501                	li	a0,0
 2b4:	bfdd                	j	2aa <strlen+0x22>

00000000000002b6 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2be:	ca19                	beqz	a2,2d4 <memset+0x1e>
 2c0:	87aa                	mv	a5,a0
 2c2:	1602                	slli	a2,a2,0x20
 2c4:	9201                	srli	a2,a2,0x20
 2c6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2ca:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2ce:	0785                	addi	a5,a5,1
 2d0:	fee79de3          	bne	a5,a4,2ca <memset+0x14>
  }
  return dst;
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <strchr>:

char *
strchr(const char *s, char c)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  for (; *s; s++)
 2e4:	00054783          	lbu	a5,0(a0)
 2e8:	cf81                	beqz	a5,300 <strchr+0x24>
    if (*s == c)
 2ea:	00f58763          	beq	a1,a5,2f8 <strchr+0x1c>
  for (; *s; s++)
 2ee:	0505                	addi	a0,a0,1
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	fbfd                	bnez	a5,2ea <strchr+0xe>
      return (char *)s;
  return 0;
 2f6:	4501                	li	a0,0
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret
  return 0;
 300:	4501                	li	a0,0
 302:	bfdd                	j	2f8 <strchr+0x1c>

0000000000000304 <gets>:

char *
gets(char *buf, int max)
{
 304:	7159                	addi	sp,sp,-112
 306:	f486                	sd	ra,104(sp)
 308:	f0a2                	sd	s0,96(sp)
 30a:	eca6                	sd	s1,88(sp)
 30c:	e8ca                	sd	s2,80(sp)
 30e:	e4ce                	sd	s3,72(sp)
 310:	e0d2                	sd	s4,64(sp)
 312:	fc56                	sd	s5,56(sp)
 314:	f85a                	sd	s6,48(sp)
 316:	f45e                	sd	s7,40(sp)
 318:	f062                	sd	s8,32(sp)
 31a:	ec66                	sd	s9,24(sp)
 31c:	e86a                	sd	s10,16(sp)
 31e:	1880                	addi	s0,sp,112
 320:	8caa                	mv	s9,a0
 322:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 324:	892a                	mv	s2,a0
 326:	4481                	li	s1,0
    cc = read(0, &c, 1);
 328:	f9f40b13          	addi	s6,s0,-97
 32c:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 32e:	4ba9                	li	s7,10
 330:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 332:	8d26                	mv	s10,s1
 334:	0014899b          	addiw	s3,s1,1
 338:	84ce                	mv	s1,s3
 33a:	0349d563          	bge	s3,s4,364 <gets+0x60>
    cc = read(0, &c, 1);
 33e:	8656                	mv	a2,s5
 340:	85da                	mv	a1,s6
 342:	4501                	li	a0,0
 344:	1c4000ef          	jal	508 <read>
    if (cc < 1)
 348:	00a05e63          	blez	a0,364 <gets+0x60>
    buf[i++] = c;
 34c:	f9f44783          	lbu	a5,-97(s0)
 350:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 354:	01778763          	beq	a5,s7,362 <gets+0x5e>
 358:	0905                	addi	s2,s2,1
 35a:	fd879ce3          	bne	a5,s8,332 <gets+0x2e>
    buf[i++] = c;
 35e:	8d4e                	mv	s10,s3
 360:	a011                	j	364 <gets+0x60>
 362:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 364:	9d66                	add	s10,s10,s9
 366:	000d0023          	sb	zero,0(s10)
  return buf;
}
 36a:	8566                	mv	a0,s9
 36c:	70a6                	ld	ra,104(sp)
 36e:	7406                	ld	s0,96(sp)
 370:	64e6                	ld	s1,88(sp)
 372:	6946                	ld	s2,80(sp)
 374:	69a6                	ld	s3,72(sp)
 376:	6a06                	ld	s4,64(sp)
 378:	7ae2                	ld	s5,56(sp)
 37a:	7b42                	ld	s6,48(sp)
 37c:	7ba2                	ld	s7,40(sp)
 37e:	7c02                	ld	s8,32(sp)
 380:	6ce2                	ld	s9,24(sp)
 382:	6d42                	ld	s10,16(sp)
 384:	6165                	addi	sp,sp,112
 386:	8082                	ret

0000000000000388 <stat>:

int
stat(const char *n, struct stat *st)
{
 388:	1101                	addi	sp,sp,-32
 38a:	ec06                	sd	ra,24(sp)
 38c:	e822                	sd	s0,16(sp)
 38e:	e04a                	sd	s2,0(sp)
 390:	1000                	addi	s0,sp,32
 392:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 394:	4581                	li	a1,0
 396:	19a000ef          	jal	530 <open>
  if (fd < 0)
 39a:	02054263          	bltz	a0,3be <stat+0x36>
 39e:	e426                	sd	s1,8(sp)
 3a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a2:	85ca                	mv	a1,s2
 3a4:	1a4000ef          	jal	548 <fstat>
 3a8:	892a                	mv	s2,a0
  close(fd);
 3aa:	8526                	mv	a0,s1
 3ac:	16c000ef          	jal	518 <close>
  return r;
 3b0:	64a2                	ld	s1,8(sp)
}
 3b2:	854a                	mv	a0,s2
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6902                	ld	s2,0(sp)
 3ba:	6105                	addi	sp,sp,32
 3bc:	8082                	ret
    return -1;
 3be:	597d                	li	s2,-1
 3c0:	bfcd                	j	3b2 <stat+0x2a>

00000000000003c2 <atoi>:

int
atoi(const char *s)
{
 3c2:	1141                	addi	sp,sp,-16
 3c4:	e406                	sd	ra,8(sp)
 3c6:	e022                	sd	s0,0(sp)
 3c8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3ca:	00054683          	lbu	a3,0(a0)
 3ce:	fd06879b          	addiw	a5,a3,-48
 3d2:	0ff7f793          	zext.b	a5,a5
 3d6:	4625                	li	a2,9
 3d8:	02f66963          	bltu	a2,a5,40a <atoi+0x48>
 3dc:	872a                	mv	a4,a0
  n = 0;
 3de:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 3e0:	0705                	addi	a4,a4,1
 3e2:	0025179b          	slliw	a5,a0,0x2
 3e6:	9fa9                	addw	a5,a5,a0
 3e8:	0017979b          	slliw	a5,a5,0x1
 3ec:	9fb5                	addw	a5,a5,a3
 3ee:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 3f2:	00074683          	lbu	a3,0(a4)
 3f6:	fd06879b          	addiw	a5,a3,-48
 3fa:	0ff7f793          	zext.b	a5,a5
 3fe:	fef671e3          	bgeu	a2,a5,3e0 <atoi+0x1e>
  return n;
}
 402:	60a2                	ld	ra,8(sp)
 404:	6402                	ld	s0,0(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret
  n = 0;
 40a:	4501                	li	a0,0
 40c:	bfdd                	j	402 <atoi+0x40>

000000000000040e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e406                	sd	ra,8(sp)
 412:	e022                	sd	s0,0(sp)
 414:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 416:	02b57563          	bgeu	a0,a1,440 <memmove+0x32>
    while (n-- > 0)
 41a:	00c05f63          	blez	a2,438 <memmove+0x2a>
 41e:	1602                	slli	a2,a2,0x20
 420:	9201                	srli	a2,a2,0x20
 422:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 426:	872a                	mv	a4,a0
      *dst++ = *src++;
 428:	0585                	addi	a1,a1,1
 42a:	0705                	addi	a4,a4,1
 42c:	fff5c683          	lbu	a3,-1(a1)
 430:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 434:	fee79ae3          	bne	a5,a4,428 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret
    dst += n;
 440:	00c50733          	add	a4,a0,a2
    src += n;
 444:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 446:	fec059e3          	blez	a2,438 <memmove+0x2a>
 44a:	fff6079b          	addiw	a5,a2,-1
 44e:	1782                	slli	a5,a5,0x20
 450:	9381                	srli	a5,a5,0x20
 452:	fff7c793          	not	a5,a5
 456:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 458:	15fd                	addi	a1,a1,-1
 45a:	177d                	addi	a4,a4,-1
 45c:	0005c683          	lbu	a3,0(a1)
 460:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 464:	fef71ae3          	bne	a4,a5,458 <memmove+0x4a>
 468:	bfc1                	j	438 <memmove+0x2a>

000000000000046a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 472:	ca0d                	beqz	a2,4a4 <memcmp+0x3a>
 474:	fff6069b          	addiw	a3,a2,-1
 478:	1682                	slli	a3,a3,0x20
 47a:	9281                	srli	a3,a3,0x20
 47c:	0685                	addi	a3,a3,1
 47e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 480:	00054783          	lbu	a5,0(a0)
 484:	0005c703          	lbu	a4,0(a1)
 488:	00e79863          	bne	a5,a4,498 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 48c:	0505                	addi	a0,a0,1
    p2++;
 48e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 490:	fed518e3          	bne	a0,a3,480 <memcmp+0x16>
  }
  return 0;
 494:	4501                	li	a0,0
 496:	a019                	j	49c <memcmp+0x32>
      return *p1 - *p2;
 498:	40e7853b          	subw	a0,a5,a4
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	bfdd                	j	49c <memcmp+0x32>

00000000000004a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a8:	1141                	addi	sp,sp,-16
 4aa:	e406                	sd	ra,8(sp)
 4ac:	e022                	sd	s0,0(sp)
 4ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4b0:	f5fff0ef          	jal	40e <memmove>
}
 4b4:	60a2                	ld	ra,8(sp)
 4b6:	6402                	ld	s0,0(sp)
 4b8:	0141                	addi	sp,sp,16
 4ba:	8082                	ret

00000000000004bc <sbrk>:

char *
sbrk(int n)
{
 4bc:	1141                	addi	sp,sp,-16
 4be:	e406                	sd	ra,8(sp)
 4c0:	e022                	sd	s0,0(sp)
 4c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4c4:	4585                	li	a1,1
 4c6:	0b2000ef          	jal	578 <sys_sbrk>
}
 4ca:	60a2                	ld	ra,8(sp)
 4cc:	6402                	ld	s0,0(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret

00000000000004d2 <sbrklazy>:

char *
sbrklazy(int n)
{
 4d2:	1141                	addi	sp,sp,-16
 4d4:	e406                	sd	ra,8(sp)
 4d6:	e022                	sd	s0,0(sp)
 4d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4da:	4589                	li	a1,2
 4dc:	09c000ef          	jal	578 <sys_sbrk>
}
 4e0:	60a2                	ld	ra,8(sp)
 4e2:	6402                	ld	s0,0(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret

00000000000004e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4e8:	4885                	li	a7,1
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4f0:	4889                	li	a7,2
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 4f8:	488d                	li	a7,3
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 500:	4891                	li	a7,4
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <read>:
.global read
read:
 li a7, SYS_read
 508:	4895                	li	a7,5
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <write>:
.global write
write:
 li a7, SYS_write
 510:	48c1                	li	a7,16
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <close>:
.global close
close:
 li a7, SYS_close
 518:	48d5                	li	a7,21
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <kill>:
.global kill
kill:
 li a7, SYS_kill
 520:	4899                	li	a7,6
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <exec>:
.global exec
exec:
 li a7, SYS_exec
 528:	489d                	li	a7,7
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <open>:
.global open
open:
 li a7, SYS_open
 530:	48bd                	li	a7,15
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 538:	48c5                	li	a7,17
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 540:	48c9                	li	a7,18
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 548:	48a1                	li	a7,8
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <link>:
.global link
link:
 li a7, SYS_link
 550:	48cd                	li	a7,19
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 558:	48d1                	li	a7,20
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 560:	48a5                	li	a7,9
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <dup>:
.global dup
dup:
 li a7, SYS_dup
 568:	48a9                	li	a7,10
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 570:	48ad                	li	a7,11
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 578:	48b1                	li	a7,12
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <pause>:
.global pause
pause:
 li a7, SYS_pause
 580:	48b5                	li	a7,13
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 588:	48b9                	li	a7,14
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <sync>:
.global sync
sync:
 li a7, SYS_sync
 590:	48d9                	li	a7,22
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <ps>:
.global ps
ps:
 li a7, SYS_ps
 598:	48dd                	li	a7,23
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 5a0:	48e1                	li	a7,24
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5a8:	48e5                	li	a7,25
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 5b0:	48e9                	li	a7,26
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5b8:	1101                	addi	sp,sp,-32
 5ba:	ec06                	sd	ra,24(sp)
 5bc:	e822                	sd	s0,16(sp)
 5be:	1000                	addi	s0,sp,32
 5c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c4:	4605                	li	a2,1
 5c6:	fef40593          	addi	a1,s0,-17
 5ca:	f47ff0ef          	jal	510 <write>
}
 5ce:	60e2                	ld	ra,24(sp)
 5d0:	6442                	ld	s0,16(sp)
 5d2:	6105                	addi	sp,sp,32
 5d4:	8082                	ret

00000000000005d6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5d6:	715d                	addi	sp,sp,-80
 5d8:	e486                	sd	ra,72(sp)
 5da:	e0a2                	sd	s0,64(sp)
 5dc:	fc26                	sd	s1,56(sp)
 5de:	f84a                	sd	s2,48(sp)
 5e0:	f44e                	sd	s3,40(sp)
 5e2:	0880                	addi	s0,sp,80
 5e4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 5e6:	c299                	beqz	a3,5ec <printint+0x16>
 5e8:	0605cc63          	bltz	a1,660 <printint+0x8a>
  neg = 0;
 5ec:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 5ee:	fb840313          	addi	t1,s0,-72
  neg = 0;
 5f2:	869a                	mv	a3,t1
  i = 0;
 5f4:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 5f6:	00000817          	auipc	a6,0x0
 5fa:	6ea80813          	addi	a6,a6,1770 # ce0 <digits>
 5fe:	88be                	mv	a7,a5
 600:	0017851b          	addiw	a0,a5,1
 604:	87aa                	mv	a5,a0
 606:	02c5f733          	remu	a4,a1,a2
 60a:	9742                	add	a4,a4,a6
 60c:	00074703          	lbu	a4,0(a4)
 610:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 614:	872e                	mv	a4,a1
 616:	02c5d5b3          	divu	a1,a1,a2
 61a:	0685                	addi	a3,a3,1
 61c:	fec771e3          	bgeu	a4,a2,5fe <printint+0x28>
  if (neg)
 620:	000e0c63          	beqz	t3,638 <printint+0x62>
    buf[i++] = '-';
 624:	fd050793          	addi	a5,a0,-48
 628:	00878533          	add	a0,a5,s0
 62c:	02d00793          	li	a5,45
 630:	fef50423          	sb	a5,-24(a0)
 634:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 638:	fff7899b          	addiw	s3,a5,-1
 63c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 640:	fff4c583          	lbu	a1,-1(s1)
 644:	854a                	mv	a0,s2
 646:	f73ff0ef          	jal	5b8 <putc>
  while (--i >= 0)
 64a:	39fd                	addiw	s3,s3,-1
 64c:	14fd                	addi	s1,s1,-1
 64e:	fe09d9e3          	bgez	s3,640 <printint+0x6a>
}
 652:	60a6                	ld	ra,72(sp)
 654:	6406                	ld	s0,64(sp)
 656:	74e2                	ld	s1,56(sp)
 658:	7942                	ld	s2,48(sp)
 65a:	79a2                	ld	s3,40(sp)
 65c:	6161                	addi	sp,sp,80
 65e:	8082                	ret
    x = -xx;
 660:	40b005b3          	neg	a1,a1
    neg = 1;
 664:	4e05                	li	t3,1
    x = -xx;
 666:	b761                	j	5ee <printint+0x18>

0000000000000668 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 668:	711d                	addi	sp,sp,-96
 66a:	ec86                	sd	ra,88(sp)
 66c:	e8a2                	sd	s0,80(sp)
 66e:	e4a6                	sd	s1,72(sp)
 670:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 672:	0005c483          	lbu	s1,0(a1)
 676:	28048463          	beqz	s1,8fe <vprintf+0x296>
 67a:	e0ca                	sd	s2,64(sp)
 67c:	fc4e                	sd	s3,56(sp)
 67e:	f852                	sd	s4,48(sp)
 680:	f456                	sd	s5,40(sp)
 682:	f05a                	sd	s6,32(sp)
 684:	ec5e                	sd	s7,24(sp)
 686:	e862                	sd	s8,16(sp)
 688:	e466                	sd	s9,8(sp)
 68a:	8b2a                	mv	s6,a0
 68c:	8a2e                	mv	s4,a1
 68e:	8bb2                	mv	s7,a2
  state = 0;
 690:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 692:	4901                	li	s2,0
 694:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 696:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 69a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 69e:	06c00c93          	li	s9,108
 6a2:	a00d                	j	6c4 <vprintf+0x5c>
        putc(fd, c0);
 6a4:	85a6                	mv	a1,s1
 6a6:	855a                	mv	a0,s6
 6a8:	f11ff0ef          	jal	5b8 <putc>
 6ac:	a019                	j	6b2 <vprintf+0x4a>
    } else if (state == '%') {
 6ae:	03598363          	beq	s3,s5,6d4 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 6b2:	0019079b          	addiw	a5,s2,1
 6b6:	893e                	mv	s2,a5
 6b8:	873e                	mv	a4,a5
 6ba:	97d2                	add	a5,a5,s4
 6bc:	0007c483          	lbu	s1,0(a5)
 6c0:	22048763          	beqz	s1,8ee <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 6c4:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 6c8:	fe0993e3          	bnez	s3,6ae <vprintf+0x46>
      if (c0 == '%') {
 6cc:	fd579ce3          	bne	a5,s5,6a4 <vprintf+0x3c>
        state = '%';
 6d0:	89be                	mv	s3,a5
 6d2:	b7c5                	j	6b2 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 6d4:	00ea06b3          	add	a3,s4,a4
 6d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6dc:	8636                	mv	a2,a3
      if (c1)
 6de:	c681                	beqz	a3,6e6 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 6e0:	9752                	add	a4,a4,s4
 6e2:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 6e6:	05878263          	beq	a5,s8,72a <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 6ea:	05978c63          	beq	a5,s9,742 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 6ee:	07500713          	li	a4,117
 6f2:	0ee78663          	beq	a5,a4,7de <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 6f6:	07800713          	li	a4,120
 6fa:	12e78863          	beq	a5,a4,82a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 6fe:	07000713          	li	a4,112
 702:	14e78d63          	beq	a5,a4,85c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 706:	06300713          	li	a4,99
 70a:	18e78c63          	beq	a5,a4,8a2 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 70e:	07300713          	li	a4,115
 712:	1ae78263          	beq	a5,a4,8b6 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 716:	02500713          	li	a4,37
 71a:	04e79463          	bne	a5,a4,762 <vprintf+0xfa>
        putc(fd, '%');
 71e:	85ba                	mv	a1,a4
 720:	855a                	mv	a0,s6
 722:	e97ff0ef          	jal	5b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 726:	4981                	li	s3,0
 728:	b769                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4685                	li	a3,1
 730:	4629                	li	a2,10
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e9fff0ef          	jal	5d6 <printint>
 73c:	8ba6                	mv	s7,s1
      state = 0;
 73e:	4981                	li	s3,0
 740:	bf8d                	j	6b2 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 742:	06400793          	li	a5,100
 746:	02f68963          	beq	a3,a5,778 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 74a:	06c00793          	li	a5,108
 74e:	04f68263          	beq	a3,a5,792 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 752:	07500793          	li	a5,117
 756:	0af68063          	beq	a3,a5,7f6 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 75a:	07800793          	li	a5,120
 75e:	0ef68263          	beq	a3,a5,842 <vprintf+0x1da>
        putc(fd, '%');
 762:	02500593          	li	a1,37
 766:	855a                	mv	a0,s6
 768:	e51ff0ef          	jal	5b8 <putc>
        putc(fd, c0);
 76c:	85a6                	mv	a1,s1
 76e:	855a                	mv	a0,s6
 770:	e49ff0ef          	jal	5b8 <putc>
      state = 0;
 774:	4981                	li	s3,0
 776:	bf35                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 778:	008b8493          	addi	s1,s7,8
 77c:	4685                	li	a3,1
 77e:	4629                	li	a2,10
 780:	000bb583          	ld	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e51ff0ef          	jal	5d6 <printint>
        i += 1;
 78a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 78c:	8ba6                	mv	s7,s1
      state = 0;
 78e:	4981                	li	s3,0
        i += 1;
 790:	b70d                	j	6b2 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 792:	06400793          	li	a5,100
 796:	02f60763          	beq	a2,a5,7c4 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 79a:	07500793          	li	a5,117
 79e:	06f60963          	beq	a2,a5,810 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 7a2:	07800793          	li	a5,120
 7a6:	faf61ee3          	bne	a2,a5,762 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	008b8493          	addi	s1,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4641                	li	a2,16
 7b2:	000bb583          	ld	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	e1fff0ef          	jal	5d6 <printint>
        i += 2;
 7bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7be:	8ba6                	mv	s7,s1
      state = 0;
 7c0:	4981                	li	s3,0
        i += 2;
 7c2:	bdc5                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	008b8493          	addi	s1,s7,8
 7c8:	4685                	li	a3,1
 7ca:	4629                	li	a2,10
 7cc:	000bb583          	ld	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	e05ff0ef          	jal	5d6 <printint>
        i += 2;
 7d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d8:	8ba6                	mv	s7,s1
      state = 0;
 7da:	4981                	li	s3,0
        i += 2;
 7dc:	bdd9                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7de:	008b8493          	addi	s1,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000be583          	lwu	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	debff0ef          	jal	5d6 <printint>
 7f0:	8ba6                	mv	s7,s1
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	bd7d                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	008b8493          	addi	s1,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4629                	li	a2,10
 7fe:	000bb583          	ld	a1,0(s7)
 802:	855a                	mv	a0,s6
 804:	dd3ff0ef          	jal	5d6 <printint>
        i += 1;
 808:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	8ba6                	mv	s7,s1
      state = 0;
 80c:	4981                	li	s3,0
        i += 1;
 80e:	b555                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	008b8493          	addi	s1,s7,8
 814:	4681                	li	a3,0
 816:	4629                	li	a2,10
 818:	000bb583          	ld	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	db9ff0ef          	jal	5d6 <printint>
        i += 2;
 822:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	8ba6                	mv	s7,s1
      state = 0;
 826:	4981                	li	s3,0
        i += 2;
 828:	b569                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 82a:	008b8493          	addi	s1,s7,8
 82e:	4681                	li	a3,0
 830:	4641                	li	a2,16
 832:	000be583          	lwu	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	d9fff0ef          	jal	5d6 <printint>
 83c:	8ba6                	mv	s7,s1
      state = 0;
 83e:	4981                	li	s3,0
 840:	bd8d                	j	6b2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	008b8493          	addi	s1,s7,8
 846:	4681                	li	a3,0
 848:	4641                	li	a2,16
 84a:	000bb583          	ld	a1,0(s7)
 84e:	855a                	mv	a0,s6
 850:	d87ff0ef          	jal	5d6 <printint>
        i += 1;
 854:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 856:	8ba6                	mv	s7,s1
      state = 0;
 858:	4981                	li	s3,0
        i += 1;
 85a:	bda1                	j	6b2 <vprintf+0x4a>
 85c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 85e:	008b8d13          	addi	s10,s7,8
 862:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 866:	03000593          	li	a1,48
 86a:	855a                	mv	a0,s6
 86c:	d4dff0ef          	jal	5b8 <putc>
  putc(fd, 'x');
 870:	07800593          	li	a1,120
 874:	855a                	mv	a0,s6
 876:	d43ff0ef          	jal	5b8 <putc>
 87a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87c:	00000b97          	auipc	s7,0x0
 880:	464b8b93          	addi	s7,s7,1124 # ce0 <digits>
 884:	03c9d793          	srli	a5,s3,0x3c
 888:	97de                	add	a5,a5,s7
 88a:	0007c583          	lbu	a1,0(a5)
 88e:	855a                	mv	a0,s6
 890:	d29ff0ef          	jal	5b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 894:	0992                	slli	s3,s3,0x4
 896:	34fd                	addiw	s1,s1,-1
 898:	f4f5                	bnez	s1,884 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 89a:	8bea                	mv	s7,s10
      state = 0;
 89c:	4981                	li	s3,0
 89e:	6d02                	ld	s10,0(sp)
 8a0:	bd09                	j	6b2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 8a2:	008b8493          	addi	s1,s7,8
 8a6:	000bc583          	lbu	a1,0(s7)
 8aa:	855a                	mv	a0,s6
 8ac:	d0dff0ef          	jal	5b8 <putc>
 8b0:	8ba6                	mv	s7,s1
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	bbfd                	j	6b2 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 8b6:	008b8993          	addi	s3,s7,8
 8ba:	000bb483          	ld	s1,0(s7)
 8be:	cc91                	beqz	s1,8da <vprintf+0x272>
        for (; *s; s++)
 8c0:	0004c583          	lbu	a1,0(s1)
 8c4:	c195                	beqz	a1,8e8 <vprintf+0x280>
          putc(fd, *s);
 8c6:	855a                	mv	a0,s6
 8c8:	cf1ff0ef          	jal	5b8 <putc>
        for (; *s; s++)
 8cc:	0485                	addi	s1,s1,1
 8ce:	0004c583          	lbu	a1,0(s1)
 8d2:	f9f5                	bnez	a1,8c6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 8d4:	8bce                	mv	s7,s3
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	bbe9                	j	6b2 <vprintf+0x4a>
          s = "(null)";
 8da:	00000497          	auipc	s1,0x0
 8de:	3fe48493          	addi	s1,s1,1022 # cd8 <malloc+0x2ee>
        for (; *s; s++)
 8e2:	02800593          	li	a1,40
 8e6:	b7c5                	j	8c6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 8e8:	8bce                	mv	s7,s3
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	b3d9                	j	6b2 <vprintf+0x4a>
 8ee:	6906                	ld	s2,64(sp)
 8f0:	79e2                	ld	s3,56(sp)
 8f2:	7a42                	ld	s4,48(sp)
 8f4:	7aa2                	ld	s5,40(sp)
 8f6:	7b02                	ld	s6,32(sp)
 8f8:	6be2                	ld	s7,24(sp)
 8fa:	6c42                	ld	s8,16(sp)
 8fc:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8fe:	60e6                	ld	ra,88(sp)
 900:	6446                	ld	s0,80(sp)
 902:	64a6                	ld	s1,72(sp)
 904:	6125                	addi	sp,sp,96
 906:	8082                	ret

0000000000000908 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 908:	715d                	addi	sp,sp,-80
 90a:	ec06                	sd	ra,24(sp)
 90c:	e822                	sd	s0,16(sp)
 90e:	1000                	addi	s0,sp,32
 910:	e010                	sd	a2,0(s0)
 912:	e414                	sd	a3,8(s0)
 914:	e818                	sd	a4,16(s0)
 916:	ec1c                	sd	a5,24(s0)
 918:	03043023          	sd	a6,32(s0)
 91c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 920:	8622                	mv	a2,s0
 922:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 926:	d43ff0ef          	jal	668 <vprintf>
}
 92a:	60e2                	ld	ra,24(sp)
 92c:	6442                	ld	s0,16(sp)
 92e:	6161                	addi	sp,sp,80
 930:	8082                	ret

0000000000000932 <printf>:

void
printf(const char *fmt, ...)
{
 932:	711d                	addi	sp,sp,-96
 934:	ec06                	sd	ra,24(sp)
 936:	e822                	sd	s0,16(sp)
 938:	1000                	addi	s0,sp,32
 93a:	e40c                	sd	a1,8(s0)
 93c:	e810                	sd	a2,16(s0)
 93e:	ec14                	sd	a3,24(s0)
 940:	f018                	sd	a4,32(s0)
 942:	f41c                	sd	a5,40(s0)
 944:	03043823          	sd	a6,48(s0)
 948:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 94c:	00840613          	addi	a2,s0,8
 950:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 954:	85aa                	mv	a1,a0
 956:	4505                	li	a0,1
 958:	d11ff0ef          	jal	668 <vprintf>
}
 95c:	60e2                	ld	ra,24(sp)
 95e:	6442                	ld	s0,16(sp)
 960:	6125                	addi	sp,sp,96
 962:	8082                	ret

0000000000000964 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 964:	1141                	addi	sp,sp,-16
 966:	e406                	sd	ra,8(sp)
 968:	e022                	sd	s0,0(sp)
 96a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 96c:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 970:	00000797          	auipc	a5,0x0
 974:	6907b783          	ld	a5,1680(a5) # 1000 <freep>
 978:	a02d                	j	9a2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 97a:	4618                	lw	a4,8(a2)
 97c:	9f2d                	addw	a4,a4,a1
 97e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	6310                	ld	a2,0(a4)
 986:	a83d                	j	9c4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 988:	ff852703          	lw	a4,-8(a0)
 98c:	9f31                	addw	a4,a4,a2
 98e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 990:	ff053683          	ld	a3,-16(a0)
 994:	a091                	j	9d8 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	6398                	ld	a4,0(a5)
 998:	00e7e463          	bltu	a5,a4,9a0 <free+0x3c>
 99c:	00e6ea63          	bltu	a3,a4,9b0 <free+0x4c>
{
 9a0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a2:	fed7fae3          	bgeu	a5,a3,996 <free+0x32>
 9a6:	6398                	ld	a4,0(a5)
 9a8:	00e6e463          	bltu	a3,a4,9b0 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ac:	fee7eae3          	bltu	a5,a4,9a0 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 9b0:	ff852583          	lw	a1,-8(a0)
 9b4:	6390                	ld	a2,0(a5)
 9b6:	02059813          	slli	a6,a1,0x20
 9ba:	01c85713          	srli	a4,a6,0x1c
 9be:	9736                	add	a4,a4,a3
 9c0:	fae60de3          	beq	a2,a4,97a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 9c4:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 9c8:	4790                	lw	a2,8(a5)
 9ca:	02061593          	slli	a1,a2,0x20
 9ce:	01c5d713          	srli	a4,a1,0x1c
 9d2:	973e                	add	a4,a4,a5
 9d4:	fae68ae3          	beq	a3,a4,988 <free+0x24>
    p->s.ptr = bp->s.ptr;
 9d8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9da:	00000717          	auipc	a4,0x0
 9de:	62f73323          	sd	a5,1574(a4) # 1000 <freep>
}
 9e2:	60a2                	ld	ra,8(sp)
 9e4:	6402                	ld	s0,0(sp)
 9e6:	0141                	addi	sp,sp,16
 9e8:	8082                	ret

00000000000009ea <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 9ea:	7139                	addi	sp,sp,-64
 9ec:	fc06                	sd	ra,56(sp)
 9ee:	f822                	sd	s0,48(sp)
 9f0:	f04a                	sd	s2,32(sp)
 9f2:	ec4e                	sd	s3,24(sp)
 9f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 9f6:	02051993          	slli	s3,a0,0x20
 9fa:	0209d993          	srli	s3,s3,0x20
 9fe:	09bd                	addi	s3,s3,15
 a00:	0049d993          	srli	s3,s3,0x4
 a04:	2985                	addiw	s3,s3,1
 a06:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a08:	00000517          	auipc	a0,0x0
 a0c:	5f853503          	ld	a0,1528(a0) # 1000 <freep>
 a10:	c905                	beqz	a0,a40 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a12:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a14:	4798                	lw	a4,8(a5)
 a16:	09377663          	bgeu	a4,s3,aa2 <malloc+0xb8>
 a1a:	f426                	sd	s1,40(sp)
 a1c:	e852                	sd	s4,16(sp)
 a1e:	e456                	sd	s5,8(sp)
 a20:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a22:	8a4e                	mv	s4,s3
 a24:	6705                	lui	a4,0x1
 a26:	00e9f363          	bgeu	s3,a4,a2c <malloc+0x42>
 a2a:	6a05                	lui	s4,0x1
 a2c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a30:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a34:	00000497          	auipc	s1,0x0
 a38:	5cc48493          	addi	s1,s1,1484 # 1000 <freep>
  if (p == SBRK_ERROR)
 a3c:	5afd                	li	s5,-1
 a3e:	a83d                	j	a7c <malloc+0x92>
 a40:	f426                	sd	s1,40(sp)
 a42:	e852                	sd	s4,16(sp)
 a44:	e456                	sd	s5,8(sp)
 a46:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a48:	00000797          	auipc	a5,0x0
 a4c:	5c878793          	addi	a5,a5,1480 # 1010 <base>
 a50:	00000717          	auipc	a4,0x0
 a54:	5af73823          	sd	a5,1456(a4) # 1000 <freep>
 a58:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a5a:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 a5e:	b7d1                	j	a22 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a60:	6398                	ld	a4,0(a5)
 a62:	e118                	sd	a4,0(a0)
 a64:	a899                	j	aba <malloc+0xd0>
  hp->s.size = nu;
 a66:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 a6a:	0541                	addi	a0,a0,16
 a6c:	ef9ff0ef          	jal	964 <free>
  return freep;
 a70:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 a72:	c125                	beqz	a0,ad2 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a74:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a76:	4798                	lw	a4,8(a5)
 a78:	03277163          	bgeu	a4,s2,a9a <malloc+0xb0>
    if (p == freep)
 a7c:	6098                	ld	a4,0(s1)
 a7e:	853e                	mv	a0,a5
 a80:	fef71ae3          	bne	a4,a5,a74 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a84:	8552                	mv	a0,s4
 a86:	a37ff0ef          	jal	4bc <sbrk>
  if (p == SBRK_ERROR)
 a8a:	fd551ee3          	bne	a0,s5,a66 <malloc+0x7c>
        return 0;
 a8e:	4501                	li	a0,0
 a90:	74a2                	ld	s1,40(sp)
 a92:	6a42                	ld	s4,16(sp)
 a94:	6aa2                	ld	s5,8(sp)
 a96:	6b02                	ld	s6,0(sp)
 a98:	a03d                	j	ac6 <malloc+0xdc>
 a9a:	74a2                	ld	s1,40(sp)
 a9c:	6a42                	ld	s4,16(sp)
 a9e:	6aa2                	ld	s5,8(sp)
 aa0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 aa2:	fae90fe3          	beq	s2,a4,a60 <malloc+0x76>
        p->s.size -= nunits;
 aa6:	4137073b          	subw	a4,a4,s3
 aaa:	c798                	sw	a4,8(a5)
        p += p->s.size;
 aac:	02071693          	slli	a3,a4,0x20
 ab0:	01c6d713          	srli	a4,a3,0x1c
 ab4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ab6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aba:	00000717          	auipc	a4,0x0
 abe:	54a73323          	sd	a0,1350(a4) # 1000 <freep>
      return (void *)(p + 1);
 ac2:	01078513          	addi	a0,a5,16
  }
}
 ac6:	70e2                	ld	ra,56(sp)
 ac8:	7442                	ld	s0,48(sp)
 aca:	7902                	ld	s2,32(sp)
 acc:	69e2                	ld	s3,24(sp)
 ace:	6121                	addi	sp,sp,64
 ad0:	8082                	ret
 ad2:	74a2                	ld	s1,40(sp)
 ad4:	6a42                	ld	s4,16(sp)
 ad6:	6aa2                	ld	s5,8(sp)
 ad8:	6b02                	ld	s6,0(sp)
 ada:	b7f5                	j	ac6 <malloc+0xdc>
