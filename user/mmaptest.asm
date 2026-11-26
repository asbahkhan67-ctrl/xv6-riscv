
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fail>:
#include "kernel/param.h"
#include "user/user.h"

static void
fail(const char *msg)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	85aa                	mv	a1,a0
  printf("mmaptest: FAIL - %s\n", msg);
   a:	00001517          	auipc	a0,0x1
   e:	c3650513          	addi	a0,a0,-970 # c40 <malloc+0xf8>
  12:	283000ef          	jal	a94 <printf>
  unlink("mmapfile");
  16:	00001517          	auipc	a0,0x1
  1a:	c4a50513          	addi	a0,a0,-950 # c60 <malloc+0x118>
  1e:	5fe000ef          	jal	61c <unlink>
  exit(1);
  22:	4505                	li	a0,1
  24:	5a8000ef          	jal	5cc <exit>

0000000000000028 <main>:
  printf("         Verified 8 KB zero-filled memory without a disk file\n");
}

int
main(void)
{
  28:	7179                	addi	sp,sp,-48
  2a:	f406                	sd	ra,40(sp)
  2c:	f022                	sd	s0,32(sp)
  2e:	1800                	addi	s0,sp,48
  printf("mmaptest: starting memory-mapping verification\n");
  30:	00001517          	auipc	a0,0x1
  34:	c4050513          	addi	a0,a0,-960 # c70 <malloc+0x128>
  38:	25d000ef          	jal	a94 <printf>
  fd = open("mmapfile", O_CREATE | O_RDWR);
  3c:	20200593          	li	a1,514
  40:	00001517          	auipc	a0,0x1
  44:	c2050513          	addi	a0,a0,-992 # c60 <malloc+0x118>
  48:	5c4000ef          	jal	60c <open>
  if (fd < 0)
  4c:	20054763          	bltz	a0,25a <main+0x232>
  50:	e84a                	sd	s2,16(sp)
  52:	892a                	mv	s2,a0
  if (write(fd, "hello", 5) != 5)
  54:	4615                	li	a2,5
  56:	00001597          	auipc	a1,0x1
  5a:	c6258593          	addi	a1,a1,-926 # cb8 <malloc+0x170>
  5e:	58e000ef          	jal	5ec <write>
  62:	4795                	li	a5,5
  64:	20f51363          	bne	a0,a5,26a <main+0x242>
  68:	ec26                	sd	s1,24(sp)
  p = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  6a:	4781                	li	a5,0
  6c:	874a                	mv	a4,s2
  6e:	4685                	li	a3,1
  70:	460d                	li	a2,3
  72:	6585                	lui	a1,0x1
  74:	4501                	li	a0,0
  76:	60e000ef          	jal	684 <mmap>
  7a:	84aa                	mv	s1,a0
  if (p == (char *)-1)
  7c:	57fd                	li	a5,-1
  7e:	1ef50d63          	beq	a0,a5,278 <main+0x250>
  printf("[Test 1] MAP_SHARED mapped at %p\n", p);
  82:	85aa                	mv	a1,a0
  84:	00001517          	auipc	a0,0x1
  88:	c7450513          	addi	a0,a0,-908 # cf8 <malloc+0x1b0>
  8c:	209000ef          	jal	a94 <printf>
  if (p[0] != 'h')
  90:	0004c703          	lbu	a4,0(s1)
  94:	06800793          	li	a5,104
  98:	1ef71663          	bne	a4,a5,284 <main+0x25c>
  p[0] = 'H';
  9c:	04800793          	li	a5,72
  a0:	00f48023          	sb	a5,0(s1)
  if (munmap(p, 4096) < 0)
  a4:	6585                	lui	a1,0x1
  a6:	8526                	mv	a0,s1
  a8:	5e4000ef          	jal	68c <munmap>
  ac:	1e054263          	bltz	a0,290 <main+0x268>
  close(fd);
  b0:	854a                	mv	a0,s2
  b2:	542000ef          	jal	5f4 <close>
  fd = open("mmapfile", O_RDONLY);
  b6:	4581                	li	a1,0
  b8:	00001517          	auipc	a0,0x1
  bc:	ba850513          	addi	a0,a0,-1112 # c60 <malloc+0x118>
  c0:	54c000ef          	jal	60c <open>
  c4:	84aa                	mv	s1,a0
  if (fd < 0)
  c6:	1c054b63          	bltz	a0,29c <main+0x274>
  memset(buf, 0, sizeof(buf));
  ca:	4621                	li	a2,8
  cc:	4581                	li	a1,0
  ce:	fd840513          	addi	a0,s0,-40
  d2:	2e8000ef          	jal	3ba <memset>
  if (read(fd, buf, 5) != 5)
  d6:	4615                	li	a2,5
  d8:	fd840593          	addi	a1,s0,-40
  dc:	8526                	mv	a0,s1
  de:	506000ef          	jal	5e4 <read>
  e2:	4795                	li	a5,5
  e4:	1cf51263          	bne	a0,a5,2a8 <main+0x280>
  close(fd);
  e8:	8526                	mv	a0,s1
  ea:	50a000ef          	jal	5f4 <close>
  if (buf[0] != 'H')
  ee:	fd844703          	lbu	a4,-40(s0)
  f2:	04800793          	li	a5,72
  f6:	1af71f63          	bne	a4,a5,2b4 <main+0x28c>
  printf("         Edited 'hello' -> '%s' (saved to disk on munmap)\n", buf);
  fa:	fd840593          	addi	a1,s0,-40
  fe:	00001517          	auipc	a0,0x1
 102:	ce250513          	addi	a0,a0,-798 # de0 <malloc+0x298>
 106:	18f000ef          	jal	a94 <printf>
  fd = open("mmapfile", O_RDWR);
 10a:	4589                	li	a1,2
 10c:	00001517          	auipc	a0,0x1
 110:	b5450513          	addi	a0,a0,-1196 # c60 <malloc+0x118>
 114:	4f8000ef          	jal	60c <open>
 118:	892a                	mv	s2,a0
  if (fd < 0)
 11a:	1a054363          	bltz	a0,2c0 <main+0x298>
  p = mmap(0, 4096, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
 11e:	4781                	li	a5,0
 120:	872a                	mv	a4,a0
 122:	4689                	li	a3,2
 124:	460d                	li	a2,3
 126:	6585                	lui	a1,0x1
 128:	4501                	li	a0,0
 12a:	55a000ef          	jal	684 <mmap>
 12e:	84aa                	mv	s1,a0
  if (p == (char *)-1)
 130:	57fd                	li	a5,-1
 132:	18f50d63          	beq	a0,a5,2cc <main+0x2a4>
  printf("[Test 2] MAP_PRIVATE mapped at %p\n", p);
 136:	85aa                	mv	a1,a0
 138:	00001517          	auipc	a0,0x1
 13c:	d2050513          	addi	a0,a0,-736 # e58 <malloc+0x310>
 140:	155000ef          	jal	a94 <printf>
  if (p[0] != 'H')
 144:	0004c703          	lbu	a4,0(s1)
 148:	04800793          	li	a5,72
 14c:	18f71663          	bne	a4,a5,2d8 <main+0x2b0>
  p[0] = 'X';
 150:	05800793          	li	a5,88
 154:	00f48023          	sb	a5,0(s1)
  if (munmap(p, 4096) < 0)
 158:	6585                	lui	a1,0x1
 15a:	8526                	mv	a0,s1
 15c:	530000ef          	jal	68c <munmap>
 160:	18054263          	bltz	a0,2e4 <main+0x2bc>
  close(fd);
 164:	854a                	mv	a0,s2
 166:	48e000ef          	jal	5f4 <close>
  fd = open("mmapfile", O_RDONLY);
 16a:	4581                	li	a1,0
 16c:	00001517          	auipc	a0,0x1
 170:	af450513          	addi	a0,a0,-1292 # c60 <malloc+0x118>
 174:	498000ef          	jal	60c <open>
 178:	84aa                	mv	s1,a0
  if (fd < 0)
 17a:	16054b63          	bltz	a0,2f0 <main+0x2c8>
  memset(buf, 0, sizeof(buf));
 17e:	4621                	li	a2,8
 180:	4581                	li	a1,0
 182:	fd840513          	addi	a0,s0,-40
 186:	234000ef          	jal	3ba <memset>
  if (read(fd, buf, 5) != 5)
 18a:	4615                	li	a2,5
 18c:	fd840593          	addi	a1,s0,-40
 190:	8526                	mv	a0,s1
 192:	452000ef          	jal	5e4 <read>
 196:	4795                	li	a5,5
 198:	16f51263          	bne	a0,a5,2fc <main+0x2d4>
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	456000ef          	jal	5f4 <close>
  if (buf[0] != 'H')
 1a2:	fd844703          	lbu	a4,-40(s0)
 1a6:	04800793          	li	a5,72
 1aa:	14f71f63          	bne	a4,a5,308 <main+0x2e0>
  printf("         Changed memory to 'Xello', disk still has '%s' (isolated)\n", buf);
 1ae:	fd840593          	addi	a1,s0,-40
 1b2:	00001517          	auipc	a0,0x1
 1b6:	d8650513          	addi	a0,a0,-634 # f38 <malloc+0x3f0>
 1ba:	0db000ef          	jal	a94 <printf>
  char *p = mmap(0, 8192, PROT_READ | PROT_WRITE,
 1be:	4781                	li	a5,0
 1c0:	577d                	li	a4,-1
 1c2:	4699                	li	a3,6
 1c4:	460d                	li	a2,3
 1c6:	6589                	lui	a1,0x2
 1c8:	4501                	li	a0,0
 1ca:	4ba000ef          	jal	684 <mmap>
 1ce:	84aa                	mv	s1,a0
  if (p == (char *)-1)
 1d0:	57fd                	li	a5,-1
 1d2:	14f50163          	beq	a0,a5,314 <main+0x2ec>
  printf("[Test 3] MAP_ANONYMOUS (2 pages) mapped at %p\n", p);
 1d6:	85aa                	mv	a1,a0
 1d8:	00001517          	auipc	a0,0x1
 1dc:	dc850513          	addi	a0,a0,-568 # fa0 <malloc+0x458>
 1e0:	0b5000ef          	jal	a94 <printf>
  if (p[0] != 0 || p[4095] != 0 || p[4096] != 0 || p[8191] != 0)
 1e4:	0004c783          	lbu	a5,0(s1)
 1e8:	12079c63          	bnez	a5,320 <main+0x2f8>
 1ec:	6785                	lui	a5,0x1
 1ee:	97a6                	add	a5,a5,s1
 1f0:	fff7c783          	lbu	a5,-1(a5) # fff <malloc+0x4b7>
 1f4:	12079663          	bnez	a5,320 <main+0x2f8>
 1f8:	6785                	lui	a5,0x1
 1fa:	97a6                	add	a5,a5,s1
 1fc:	0007c783          	lbu	a5,0(a5) # 1000 <malloc+0x4b8>
 200:	12079063          	bnez	a5,320 <main+0x2f8>
 204:	6789                	lui	a5,0x2
 206:	97a6                	add	a5,a5,s1
 208:	fff7c783          	lbu	a5,-1(a5) # 1fff <digits+0xf77>
 20c:	10079a63          	bnez	a5,320 <main+0x2f8>
  p[0] = 'N';
 210:	04e00793          	li	a5,78
 214:	00f48023          	sb	a5,0(s1)
  p[4096] = 'X';
 218:	6785                	lui	a5,0x1
 21a:	97a6                	add	a5,a5,s1
 21c:	05800713          	li	a4,88
 220:	00e78023          	sb	a4,0(a5) # 1000 <malloc+0x4b8>
  if (munmap(p, 8192) < 0)
 224:	6589                	lui	a1,0x2
 226:	8526                	mv	a0,s1
 228:	464000ef          	jal	68c <munmap>
 22c:	10054063          	bltz	a0,32c <main+0x304>
  printf("         Verified 8 KB zero-filled memory without a disk file\n");
 230:	00001517          	auipc	a0,0x1
 234:	df050513          	addi	a0,a0,-528 # 1020 <malloc+0x4d8>
 238:	05d000ef          	jal	a94 <printf>
  test_map_shared();
  test_map_private();
  test_map_anonymous();
  unlink("mmapfile");
 23c:	00001517          	auipc	a0,0x1
 240:	a2450513          	addi	a0,a0,-1500 # c60 <malloc+0x118>
 244:	3d8000ef          	jal	61c <unlink>
  printf("mmaptest: ALL TESTS PASSED\n");
 248:	00001517          	auipc	a0,0x1
 24c:	e1850513          	addi	a0,a0,-488 # 1060 <malloc+0x518>
 250:	045000ef          	jal	a94 <printf>
  exit(0);
 254:	4501                	li	a0,0
 256:	376000ef          	jal	5cc <exit>
 25a:	ec26                	sd	s1,24(sp)
 25c:	e84a                	sd	s2,16(sp)
    fail("open mmapfile failed");
 25e:	00001517          	auipc	a0,0x1
 262:	a4250513          	addi	a0,a0,-1470 # ca0 <malloc+0x158>
 266:	d9bff0ef          	jal	0 <fail>
 26a:	ec26                	sd	s1,24(sp)
    fail("write initial file data failed");
 26c:	00001517          	auipc	a0,0x1
 270:	a5450513          	addi	a0,a0,-1452 # cc0 <malloc+0x178>
 274:	d8dff0ef          	jal	0 <fail>
    fail("MAP_SHARED mmap failed");
 278:	00001517          	auipc	a0,0x1
 27c:	a6850513          	addi	a0,a0,-1432 # ce0 <malloc+0x198>
 280:	d81ff0ef          	jal	0 <fail>
    fail("MAP_SHARED initial read mismatch");
 284:	00001517          	auipc	a0,0x1
 288:	a9c50513          	addi	a0,a0,-1380 # d20 <malloc+0x1d8>
 28c:	d75ff0ef          	jal	0 <fail>
    fail("MAP_SHARED munmap failed");
 290:	00001517          	auipc	a0,0x1
 294:	ab850513          	addi	a0,a0,-1352 # d48 <malloc+0x200>
 298:	d69ff0ef          	jal	0 <fail>
    fail("reopen after MAP_SHARED failed");
 29c:	00001517          	auipc	a0,0x1
 2a0:	acc50513          	addi	a0,a0,-1332 # d68 <malloc+0x220>
 2a4:	d5dff0ef          	jal	0 <fail>
    fail("readback after MAP_SHARED failed");
 2a8:	00001517          	auipc	a0,0x1
 2ac:	ae050513          	addi	a0,a0,-1312 # d88 <malloc+0x240>
 2b0:	d51ff0ef          	jal	0 <fail>
    fail("MAP_SHARED writeback did not persist to disk");
 2b4:	00001517          	auipc	a0,0x1
 2b8:	afc50513          	addi	a0,a0,-1284 # db0 <malloc+0x268>
 2bc:	d45ff0ef          	jal	0 <fail>
    fail("open for MAP_PRIVATE failed");
 2c0:	00001517          	auipc	a0,0x1
 2c4:	b6050513          	addi	a0,a0,-1184 # e20 <malloc+0x2d8>
 2c8:	d39ff0ef          	jal	0 <fail>
    fail("MAP_PRIVATE mmap failed");
 2cc:	00001517          	auipc	a0,0x1
 2d0:	b7450513          	addi	a0,a0,-1164 # e40 <malloc+0x2f8>
 2d4:	d2dff0ef          	jal	0 <fail>
    fail("MAP_PRIVATE read mismatch");
 2d8:	00001517          	auipc	a0,0x1
 2dc:	ba850513          	addi	a0,a0,-1112 # e80 <malloc+0x338>
 2e0:	d21ff0ef          	jal	0 <fail>
    fail("MAP_PRIVATE munmap failed");
 2e4:	00001517          	auipc	a0,0x1
 2e8:	bbc50513          	addi	a0,a0,-1092 # ea0 <malloc+0x358>
 2ec:	d15ff0ef          	jal	0 <fail>
    fail("reopen after MAP_PRIVATE failed");
 2f0:	00001517          	auipc	a0,0x1
 2f4:	bd050513          	addi	a0,a0,-1072 # ec0 <malloc+0x378>
 2f8:	d09ff0ef          	jal	0 <fail>
    fail("readback after MAP_PRIVATE failed");
 2fc:	00001517          	auipc	a0,0x1
 300:	be450513          	addi	a0,a0,-1052 # ee0 <malloc+0x398>
 304:	cfdff0ef          	jal	0 <fail>
    fail("MAP_PRIVATE unexpectedly modified file on disk");
 308:	00001517          	auipc	a0,0x1
 30c:	c0050513          	addi	a0,a0,-1024 # f08 <malloc+0x3c0>
 310:	cf1ff0ef          	jal	0 <fail>
    fail("MAP_ANONYMOUS mmap failed");
 314:	00001517          	auipc	a0,0x1
 318:	c6c50513          	addi	a0,a0,-916 # f80 <malloc+0x438>
 31c:	ce5ff0ef          	jal	0 <fail>
    fail("MAP_ANONYMOUS pages were not zero-filled");
 320:	00001517          	auipc	a0,0x1
 324:	cb050513          	addi	a0,a0,-848 # fd0 <malloc+0x488>
 328:	cd9ff0ef          	jal	0 <fail>
    fail("MAP_ANONYMOUS munmap failed");
 32c:	00001517          	auipc	a0,0x1
 330:	cd450513          	addi	a0,a0,-812 # 1000 <malloc+0x4b8>
 334:	ccdff0ef          	jal	0 <fail>

0000000000000338 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 340:	ce9ff0ef          	jal	28 <main>
  exit(r);
 344:	288000ef          	jal	5cc <exit>

0000000000000348 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 34e:	87aa                	mv	a5,a0
 350:	0585                	addi	a1,a1,1 # 2001 <freep+0x1>
 352:	0785                	addi	a5,a5,1
 354:	fff5c703          	lbu	a4,-1(a1)
 358:	fee78fa3          	sb	a4,-1(a5)
 35c:	fb75                	bnez	a4,350 <strcpy+0x8>
    ;
  return os;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 364:	1141                	addi	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 36a:	00054783          	lbu	a5,0(a0)
 36e:	cb91                	beqz	a5,382 <strcmp+0x1e>
 370:	0005c703          	lbu	a4,0(a1)
 374:	00f71763          	bne	a4,a5,382 <strcmp+0x1e>
    p++, q++;
 378:	0505                	addi	a0,a0,1
 37a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 37c:	00054783          	lbu	a5,0(a0)
 380:	fbe5                	bnez	a5,370 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 382:	0005c503          	lbu	a0,0(a1)
}
 386:	40a7853b          	subw	a0,a5,a0
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <strlen>:

uint
strlen(const char *s)
{
 390:	1141                	addi	sp,sp,-16
 392:	e422                	sd	s0,8(sp)
 394:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 396:	00054783          	lbu	a5,0(a0)
 39a:	cf91                	beqz	a5,3b6 <strlen+0x26>
 39c:	0505                	addi	a0,a0,1
 39e:	87aa                	mv	a5,a0
 3a0:	86be                	mv	a3,a5
 3a2:	0785                	addi	a5,a5,1
 3a4:	fff7c703          	lbu	a4,-1(a5)
 3a8:	ff65                	bnez	a4,3a0 <strlen+0x10>
 3aa:	40a6853b          	subw	a0,a3,a0
 3ae:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 3b0:	6422                	ld	s0,8(sp)
 3b2:	0141                	addi	sp,sp,16
 3b4:	8082                	ret
  for (n = 0; s[n]; n++)
 3b6:	4501                	li	a0,0
 3b8:	bfe5                	j	3b0 <strlen+0x20>

00000000000003ba <memset>:

void *
memset(void *dst, int c, uint n)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 3c0:	ca19                	beqz	a2,3d6 <memset+0x1c>
 3c2:	87aa                	mv	a5,a0
 3c4:	1602                	slli	a2,a2,0x20
 3c6:	9201                	srli	a2,a2,0x20
 3c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3cc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3d0:	0785                	addi	a5,a5,1
 3d2:	fee79de3          	bne	a5,a4,3cc <memset+0x12>
  }
  return dst;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret

00000000000003dc <strchr>:

char *
strchr(const char *s, char c)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	cb99                	beqz	a5,3fc <strchr+0x20>
    if (*s == c)
 3e8:	00f58763          	beq	a1,a5,3f6 <strchr+0x1a>
  for (; *s; s++)
 3ec:	0505                	addi	a0,a0,1
 3ee:	00054783          	lbu	a5,0(a0)
 3f2:	fbfd                	bnez	a5,3e8 <strchr+0xc>
      return (char *)s;
  return 0;
 3f4:	4501                	li	a0,0
}
 3f6:	6422                	ld	s0,8(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  return 0;
 3fc:	4501                	li	a0,0
 3fe:	bfe5                	j	3f6 <strchr+0x1a>

0000000000000400 <gets>:

char *
gets(char *buf, int max)
{
 400:	711d                	addi	sp,sp,-96
 402:	ec86                	sd	ra,88(sp)
 404:	e8a2                	sd	s0,80(sp)
 406:	e4a6                	sd	s1,72(sp)
 408:	e0ca                	sd	s2,64(sp)
 40a:	fc4e                	sd	s3,56(sp)
 40c:	f852                	sd	s4,48(sp)
 40e:	f456                	sd	s5,40(sp)
 410:	f05a                	sd	s6,32(sp)
 412:	ec5e                	sd	s7,24(sp)
 414:	1080                	addi	s0,sp,96
 416:	8baa                	mv	s7,a0
 418:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 41a:	892a                	mv	s2,a0
 41c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 41e:	4aa9                	li	s5,10
 420:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 422:	89a6                	mv	s3,s1
 424:	2485                	addiw	s1,s1,1
 426:	0344d663          	bge	s1,s4,452 <gets+0x52>
    cc = read(0, &c, 1);
 42a:	4605                	li	a2,1
 42c:	faf40593          	addi	a1,s0,-81
 430:	4501                	li	a0,0
 432:	1b2000ef          	jal	5e4 <read>
    if (cc < 1)
 436:	00a05e63          	blez	a0,452 <gets+0x52>
    buf[i++] = c;
 43a:	faf44783          	lbu	a5,-81(s0)
 43e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 442:	01578763          	beq	a5,s5,450 <gets+0x50>
 446:	0905                	addi	s2,s2,1
 448:	fd679de3          	bne	a5,s6,422 <gets+0x22>
    buf[i++] = c;
 44c:	89a6                	mv	s3,s1
 44e:	a011                	j	452 <gets+0x52>
 450:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 452:	99de                	add	s3,s3,s7
 454:	00098023          	sb	zero,0(s3)
  return buf;
}
 458:	855e                	mv	a0,s7
 45a:	60e6                	ld	ra,88(sp)
 45c:	6446                	ld	s0,80(sp)
 45e:	64a6                	ld	s1,72(sp)
 460:	6906                	ld	s2,64(sp)
 462:	79e2                	ld	s3,56(sp)
 464:	7a42                	ld	s4,48(sp)
 466:	7aa2                	ld	s5,40(sp)
 468:	7b02                	ld	s6,32(sp)
 46a:	6be2                	ld	s7,24(sp)
 46c:	6125                	addi	sp,sp,96
 46e:	8082                	ret

0000000000000470 <stat>:

int
stat(const char *n, struct stat *st)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	e04a                	sd	s2,0(sp)
 478:	1000                	addi	s0,sp,32
 47a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47c:	4581                	li	a1,0
 47e:	18e000ef          	jal	60c <open>
  if (fd < 0)
 482:	02054263          	bltz	a0,4a6 <stat+0x36>
 486:	e426                	sd	s1,8(sp)
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	198000ef          	jal	624 <fstat>
 490:	892a                	mv	s2,a0
  close(fd);
 492:	8526                	mv	a0,s1
 494:	160000ef          	jal	5f4 <close>
  return r;
 498:	64a2                	ld	s1,8(sp)
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6902                	ld	s2,0(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret
    return -1;
 4a6:	597d                	li	s2,-1
 4a8:	bfcd                	j	49a <stat+0x2a>

00000000000004aa <atoi>:

int
atoi(const char *s)
{
 4aa:	1141                	addi	sp,sp,-16
 4ac:	e422                	sd	s0,8(sp)
 4ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 4b0:	00054683          	lbu	a3,0(a0)
 4b4:	fd06879b          	addiw	a5,a3,-48
 4b8:	0ff7f793          	zext.b	a5,a5
 4bc:	4625                	li	a2,9
 4be:	02f66863          	bltu	a2,a5,4ee <atoi+0x44>
 4c2:	872a                	mv	a4,a0
  n = 0;
 4c4:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 4c6:	0705                	addi	a4,a4,1
 4c8:	0025179b          	slliw	a5,a0,0x2
 4cc:	9fa9                	addw	a5,a5,a0
 4ce:	0017979b          	slliw	a5,a5,0x1
 4d2:	9fb5                	addw	a5,a5,a3
 4d4:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 4d8:	00074683          	lbu	a3,0(a4)
 4dc:	fd06879b          	addiw	a5,a3,-48
 4e0:	0ff7f793          	zext.b	a5,a5
 4e4:	fef671e3          	bgeu	a2,a5,4c6 <atoi+0x1c>
  return n;
}
 4e8:	6422                	ld	s0,8(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
  n = 0;
 4ee:	4501                	li	a0,0
 4f0:	bfe5                	j	4e8 <atoi+0x3e>

00000000000004f2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e422                	sd	s0,8(sp)
 4f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4f8:	02b57463          	bgeu	a0,a1,520 <memmove+0x2e>
    while (n-- > 0)
 4fc:	00c05f63          	blez	a2,51a <memmove+0x28>
 500:	1602                	slli	a2,a2,0x20
 502:	9201                	srli	a2,a2,0x20
 504:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 508:	872a                	mv	a4,a0
      *dst++ = *src++;
 50a:	0585                	addi	a1,a1,1
 50c:	0705                	addi	a4,a4,1
 50e:	fff5c683          	lbu	a3,-1(a1)
 512:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 516:	fef71ae3          	bne	a4,a5,50a <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
    dst += n;
 520:	00c50733          	add	a4,a0,a2
    src += n;
 524:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 526:	fec05ae3          	blez	a2,51a <memmove+0x28>
 52a:	fff6079b          	addiw	a5,a2,-1
 52e:	1782                	slli	a5,a5,0x20
 530:	9381                	srli	a5,a5,0x20
 532:	fff7c793          	not	a5,a5
 536:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 538:	15fd                	addi	a1,a1,-1
 53a:	177d                	addi	a4,a4,-1
 53c:	0005c683          	lbu	a3,0(a1)
 540:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 544:	fee79ae3          	bne	a5,a4,538 <memmove+0x46>
 548:	bfc9                	j	51a <memmove+0x28>

000000000000054a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 54a:	1141                	addi	sp,sp,-16
 54c:	e422                	sd	s0,8(sp)
 54e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 550:	ca05                	beqz	a2,580 <memcmp+0x36>
 552:	fff6069b          	addiw	a3,a2,-1
 556:	1682                	slli	a3,a3,0x20
 558:	9281                	srli	a3,a3,0x20
 55a:	0685                	addi	a3,a3,1
 55c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 55e:	00054783          	lbu	a5,0(a0)
 562:	0005c703          	lbu	a4,0(a1)
 566:	00e79863          	bne	a5,a4,576 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 56a:	0505                	addi	a0,a0,1
    p2++;
 56c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 56e:	fed518e3          	bne	a0,a3,55e <memcmp+0x14>
  }
  return 0;
 572:	4501                	li	a0,0
 574:	a019                	j	57a <memcmp+0x30>
      return *p1 - *p2;
 576:	40e7853b          	subw	a0,a5,a4
}
 57a:	6422                	ld	s0,8(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret
  return 0;
 580:	4501                	li	a0,0
 582:	bfe5                	j	57a <memcmp+0x30>

0000000000000584 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 584:	1141                	addi	sp,sp,-16
 586:	e406                	sd	ra,8(sp)
 588:	e022                	sd	s0,0(sp)
 58a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 58c:	f67ff0ef          	jal	4f2 <memmove>
}
 590:	60a2                	ld	ra,8(sp)
 592:	6402                	ld	s0,0(sp)
 594:	0141                	addi	sp,sp,16
 596:	8082                	ret

0000000000000598 <sbrk>:

char *
sbrk(int n)
{
 598:	1141                	addi	sp,sp,-16
 59a:	e406                	sd	ra,8(sp)
 59c:	e022                	sd	s0,0(sp)
 59e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 5a0:	4585                	li	a1,1
 5a2:	0b2000ef          	jal	654 <sys_sbrk>
}
 5a6:	60a2                	ld	ra,8(sp)
 5a8:	6402                	ld	s0,0(sp)
 5aa:	0141                	addi	sp,sp,16
 5ac:	8082                	ret

00000000000005ae <sbrklazy>:

char *
sbrklazy(int n)
{
 5ae:	1141                	addi	sp,sp,-16
 5b0:	e406                	sd	ra,8(sp)
 5b2:	e022                	sd	s0,0(sp)
 5b4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 5b6:	4589                	li	a1,2
 5b8:	09c000ef          	jal	654 <sys_sbrk>
}
 5bc:	60a2                	ld	ra,8(sp)
 5be:	6402                	ld	s0,0(sp)
 5c0:	0141                	addi	sp,sp,16
 5c2:	8082                	ret

00000000000005c4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5c4:	4885                	li	a7,1
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <exit>:
.global exit
exit:
 li a7, SYS_exit
 5cc:	4889                	li	a7,2
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5d4:	488d                	li	a7,3
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5dc:	4891                	li	a7,4
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <read>:
.global read
read:
 li a7, SYS_read
 5e4:	4895                	li	a7,5
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <write>:
.global write
write:
 li a7, SYS_write
 5ec:	48c1                	li	a7,16
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <close>:
.global close
close:
 li a7, SYS_close
 5f4:	48d5                	li	a7,21
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <kill>:
.global kill
kill:
 li a7, SYS_kill
 5fc:	4899                	li	a7,6
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <exec>:
.global exec
exec:
 li a7, SYS_exec
 604:	489d                	li	a7,7
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <open>:
.global open
open:
 li a7, SYS_open
 60c:	48bd                	li	a7,15
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 614:	48c5                	li	a7,17
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 61c:	48c9                	li	a7,18
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 624:	48a1                	li	a7,8
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <link>:
.global link
link:
 li a7, SYS_link
 62c:	48cd                	li	a7,19
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 634:	48d1                	li	a7,20
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 63c:	48a5                	li	a7,9
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <dup>:
.global dup
dup:
 li a7, SYS_dup
 644:	48a9                	li	a7,10
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 64c:	48ad                	li	a7,11
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 654:	48b1                	li	a7,12
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <pause>:
.global pause
pause:
 li a7, SYS_pause
 65c:	48b5                	li	a7,13
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 664:	48b9                	li	a7,14
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <sync>:
.global sync
sync:
 li a7, SYS_sync
 66c:	48d9                	li	a7,22
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <ps>:
.global ps
ps:
 li a7, SYS_ps
 674:	48dd                	li	a7,23
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 67c:	48e1                	li	a7,24
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 684:	48e5                	li	a7,25
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 68c:	48e9                	li	a7,26
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <trace>:
.global trace
trace:
 li a7, SYS_trace
 694:	48ed                	li	a7,27
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 69c:	48f1                	li	a7,28
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 6a4:	48f5                	li	a7,29
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 6ac:	48f9                	li	a7,30
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 6b4:	48fd                	li	a7,31
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 6bc:	02000893          	li	a7,32
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <halt>:
.global halt
halt:
 li a7, SYS_halt
 6c6:	02100893          	li	a7,33
 ecall
 6ca:	00000073          	ecall
 ret
 6ce:	8082                	ret

00000000000006d0 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 6d0:	02200893          	li	a7,34
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 6da:	02300893          	li	a7,35
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 6e4:	02400893          	li	a7,36
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 6ee:	02500893          	li	a7,37
 ecall
 6f2:	00000073          	ecall
 ret
 6f6:	8082                	ret

00000000000006f8 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 6f8:	02600893          	li	a7,38
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 702:	02700893          	li	a7,39
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 70c:	1101                	addi	sp,sp,-32
 70e:	ec06                	sd	ra,24(sp)
 710:	e822                	sd	s0,16(sp)
 712:	1000                	addi	s0,sp,32
 714:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 718:	4605                	li	a2,1
 71a:	fef40593          	addi	a1,s0,-17
 71e:	ecfff0ef          	jal	5ec <write>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6105                	addi	sp,sp,32
 728:	8082                	ret

000000000000072a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 72a:	715d                	addi	sp,sp,-80
 72c:	e486                	sd	ra,72(sp)
 72e:	e0a2                	sd	s0,64(sp)
 730:	f84a                	sd	s2,48(sp)
 732:	0880                	addi	s0,sp,80
 734:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 736:	c299                	beqz	a3,73c <printint+0x12>
 738:	0805c363          	bltz	a1,7be <printint+0x94>
  neg = 0;
 73c:	4881                	li	a7,0
 73e:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 742:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 744:	00001517          	auipc	a0,0x1
 748:	94450513          	addi	a0,a0,-1724 # 1088 <digits>
 74c:	883e                	mv	a6,a5
 74e:	2785                	addiw	a5,a5,1
 750:	02c5f733          	remu	a4,a1,a2
 754:	972a                	add	a4,a4,a0
 756:	00074703          	lbu	a4,0(a4)
 75a:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 75e:	872e                	mv	a4,a1
 760:	02c5d5b3          	divu	a1,a1,a2
 764:	0685                	addi	a3,a3,1
 766:	fec773e3          	bgeu	a4,a2,74c <printint+0x22>
  if (neg)
 76a:	00088b63          	beqz	a7,780 <printint+0x56>
    buf[i++] = '-';
 76e:	fd078793          	addi	a5,a5,-48
 772:	97a2                	add	a5,a5,s0
 774:	02d00713          	li	a4,45
 778:	fee78423          	sb	a4,-24(a5)
 77c:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 780:	02f05a63          	blez	a5,7b4 <printint+0x8a>
 784:	fc26                	sd	s1,56(sp)
 786:	f44e                	sd	s3,40(sp)
 788:	fb840713          	addi	a4,s0,-72
 78c:	00f704b3          	add	s1,a4,a5
 790:	fff70993          	addi	s3,a4,-1
 794:	99be                	add	s3,s3,a5
 796:	37fd                	addiw	a5,a5,-1
 798:	1782                	slli	a5,a5,0x20
 79a:	9381                	srli	a5,a5,0x20
 79c:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 7a0:	fff4c583          	lbu	a1,-1(s1)
 7a4:	854a                	mv	a0,s2
 7a6:	f67ff0ef          	jal	70c <putc>
  while (--i >= 0)
 7aa:	14fd                	addi	s1,s1,-1
 7ac:	ff349ae3          	bne	s1,s3,7a0 <printint+0x76>
 7b0:	74e2                	ld	s1,56(sp)
 7b2:	79a2                	ld	s3,40(sp)
}
 7b4:	60a6                	ld	ra,72(sp)
 7b6:	6406                	ld	s0,64(sp)
 7b8:	7942                	ld	s2,48(sp)
 7ba:	6161                	addi	sp,sp,80
 7bc:	8082                	ret
    x = -xx;
 7be:	40b005b3          	neg	a1,a1
    neg = 1;
 7c2:	4885                	li	a7,1
    x = -xx;
 7c4:	bfad                	j	73e <printint+0x14>

00000000000007c6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7c6:	711d                	addi	sp,sp,-96
 7c8:	ec86                	sd	ra,88(sp)
 7ca:	e8a2                	sd	s0,80(sp)
 7cc:	e0ca                	sd	s2,64(sp)
 7ce:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 7d0:	0005c903          	lbu	s2,0(a1)
 7d4:	28090663          	beqz	s2,a60 <vprintf+0x29a>
 7d8:	e4a6                	sd	s1,72(sp)
 7da:	fc4e                	sd	s3,56(sp)
 7dc:	f852                	sd	s4,48(sp)
 7de:	f456                	sd	s5,40(sp)
 7e0:	f05a                	sd	s6,32(sp)
 7e2:	ec5e                	sd	s7,24(sp)
 7e4:	e862                	sd	s8,16(sp)
 7e6:	e466                	sd	s9,8(sp)
 7e8:	8b2a                	mv	s6,a0
 7ea:	8a2e                	mv	s4,a1
 7ec:	8bb2                	mv	s7,a2
  state = 0;
 7ee:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 7f0:	4481                	li	s1,0
 7f2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 7f4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 7f8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 7fc:	06c00c93          	li	s9,108
 800:	a005                	j	820 <vprintf+0x5a>
        putc(fd, c0);
 802:	85ca                	mv	a1,s2
 804:	855a                	mv	a0,s6
 806:	f07ff0ef          	jal	70c <putc>
 80a:	a019                	j	810 <vprintf+0x4a>
    } else if (state == '%') {
 80c:	03598263          	beq	s3,s5,830 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 810:	2485                	addiw	s1,s1,1
 812:	8726                	mv	a4,s1
 814:	009a07b3          	add	a5,s4,s1
 818:	0007c903          	lbu	s2,0(a5)
 81c:	22090a63          	beqz	s2,a50 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 820:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 824:	fe0994e3          	bnez	s3,80c <vprintf+0x46>
      if (c0 == '%') {
 828:	fd579de3          	bne	a5,s5,802 <vprintf+0x3c>
        state = '%';
 82c:	89be                	mv	s3,a5
 82e:	b7cd                	j	810 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 830:	00ea06b3          	add	a3,s4,a4
 834:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 838:	8636                	mv	a2,a3
      if (c1)
 83a:	c681                	beqz	a3,842 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 83c:	9752                	add	a4,a4,s4
 83e:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 842:	05878363          	beq	a5,s8,888 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 846:	05978d63          	beq	a5,s9,8a0 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 84a:	07500713          	li	a4,117
 84e:	0ee78763          	beq	a5,a4,93c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 852:	07800713          	li	a4,120
 856:	12e78963          	beq	a5,a4,988 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 85a:	07000713          	li	a4,112
 85e:	14e78e63          	beq	a5,a4,9ba <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 862:	06300713          	li	a4,99
 866:	18e78e63          	beq	a5,a4,a02 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 86a:	07300713          	li	a4,115
 86e:	1ae78463          	beq	a5,a4,a16 <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 872:	02500713          	li	a4,37
 876:	04e79563          	bne	a5,a4,8c0 <vprintf+0xfa>
        putc(fd, '%');
 87a:	02500593          	li	a1,37
 87e:	855a                	mv	a0,s6
 880:	e8dff0ef          	jal	70c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 884:	4981                	li	s3,0
 886:	b769                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 888:	008b8913          	addi	s2,s7,8
 88c:	4685                	li	a3,1
 88e:	4629                	li	a2,10
 890:	000ba583          	lw	a1,0(s7)
 894:	855a                	mv	a0,s6
 896:	e95ff0ef          	jal	72a <printint>
 89a:	8bca                	mv	s7,s2
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bf8d                	j	810 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 8a0:	06400793          	li	a5,100
 8a4:	02f68963          	beq	a3,a5,8d6 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 8a8:	06c00793          	li	a5,108
 8ac:	04f68263          	beq	a3,a5,8f0 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 8b0:	07500793          	li	a5,117
 8b4:	0af68063          	beq	a3,a5,954 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 8b8:	07800793          	li	a5,120
 8bc:	0ef68263          	beq	a3,a5,9a0 <vprintf+0x1da>
        putc(fd, '%');
 8c0:	02500593          	li	a1,37
 8c4:	855a                	mv	a0,s6
 8c6:	e47ff0ef          	jal	70c <putc>
        putc(fd, c0);
 8ca:	85ca                	mv	a1,s2
 8cc:	855a                	mv	a0,s6
 8ce:	e3fff0ef          	jal	70c <putc>
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	bf35                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8d6:	008b8913          	addi	s2,s7,8
 8da:	4685                	li	a3,1
 8dc:	4629                	li	a2,10
 8de:	000bb583          	ld	a1,0(s7)
 8e2:	855a                	mv	a0,s6
 8e4:	e47ff0ef          	jal	72a <printint>
        i += 1;
 8e8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ea:	8bca                	mv	s7,s2
      state = 0;
 8ec:	4981                	li	s3,0
        i += 1;
 8ee:	b70d                	j	810 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 8f0:	06400793          	li	a5,100
 8f4:	02f60763          	beq	a2,a5,922 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 8f8:	07500793          	li	a5,117
 8fc:	06f60963          	beq	a2,a5,96e <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 900:	07800793          	li	a5,120
 904:	faf61ee3          	bne	a2,a5,8c0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 908:	008b8913          	addi	s2,s7,8
 90c:	4681                	li	a3,0
 90e:	4641                	li	a2,16
 910:	000bb583          	ld	a1,0(s7)
 914:	855a                	mv	a0,s6
 916:	e15ff0ef          	jal	72a <printint>
        i += 2;
 91a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 91c:	8bca                	mv	s7,s2
      state = 0;
 91e:	4981                	li	s3,0
        i += 2;
 920:	bdc5                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 922:	008b8913          	addi	s2,s7,8
 926:	4685                	li	a3,1
 928:	4629                	li	a2,10
 92a:	000bb583          	ld	a1,0(s7)
 92e:	855a                	mv	a0,s6
 930:	dfbff0ef          	jal	72a <printint>
        i += 2;
 934:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 936:	8bca                	mv	s7,s2
      state = 0;
 938:	4981                	li	s3,0
        i += 2;
 93a:	bdd9                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 93c:	008b8913          	addi	s2,s7,8
 940:	4681                	li	a3,0
 942:	4629                	li	a2,10
 944:	000be583          	lwu	a1,0(s7)
 948:	855a                	mv	a0,s6
 94a:	de1ff0ef          	jal	72a <printint>
 94e:	8bca                	mv	s7,s2
      state = 0;
 950:	4981                	li	s3,0
 952:	bd7d                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 954:	008b8913          	addi	s2,s7,8
 958:	4681                	li	a3,0
 95a:	4629                	li	a2,10
 95c:	000bb583          	ld	a1,0(s7)
 960:	855a                	mv	a0,s6
 962:	dc9ff0ef          	jal	72a <printint>
        i += 1;
 966:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 968:	8bca                	mv	s7,s2
      state = 0;
 96a:	4981                	li	s3,0
        i += 1;
 96c:	b555                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96e:	008b8913          	addi	s2,s7,8
 972:	4681                	li	a3,0
 974:	4629                	li	a2,10
 976:	000bb583          	ld	a1,0(s7)
 97a:	855a                	mv	a0,s6
 97c:	dafff0ef          	jal	72a <printint>
        i += 2;
 980:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 982:	8bca                	mv	s7,s2
      state = 0;
 984:	4981                	li	s3,0
        i += 2;
 986:	b569                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 988:	008b8913          	addi	s2,s7,8
 98c:	4681                	li	a3,0
 98e:	4641                	li	a2,16
 990:	000be583          	lwu	a1,0(s7)
 994:	855a                	mv	a0,s6
 996:	d95ff0ef          	jal	72a <printint>
 99a:	8bca                	mv	s7,s2
      state = 0;
 99c:	4981                	li	s3,0
 99e:	bd8d                	j	810 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a0:	008b8913          	addi	s2,s7,8
 9a4:	4681                	li	a3,0
 9a6:	4641                	li	a2,16
 9a8:	000bb583          	ld	a1,0(s7)
 9ac:	855a                	mv	a0,s6
 9ae:	d7dff0ef          	jal	72a <printint>
        i += 1;
 9b2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b4:	8bca                	mv	s7,s2
      state = 0;
 9b6:	4981                	li	s3,0
        i += 1;
 9b8:	bda1                	j	810 <vprintf+0x4a>
 9ba:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9bc:	008b8d13          	addi	s10,s7,8
 9c0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9c4:	03000593          	li	a1,48
 9c8:	855a                	mv	a0,s6
 9ca:	d43ff0ef          	jal	70c <putc>
  putc(fd, 'x');
 9ce:	07800593          	li	a1,120
 9d2:	855a                	mv	a0,s6
 9d4:	d39ff0ef          	jal	70c <putc>
 9d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9da:	00000b97          	auipc	s7,0x0
 9de:	6aeb8b93          	addi	s7,s7,1710 # 1088 <digits>
 9e2:	03c9d793          	srli	a5,s3,0x3c
 9e6:	97de                	add	a5,a5,s7
 9e8:	0007c583          	lbu	a1,0(a5)
 9ec:	855a                	mv	a0,s6
 9ee:	d1fff0ef          	jal	70c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9f2:	0992                	slli	s3,s3,0x4
 9f4:	397d                	addiw	s2,s2,-1
 9f6:	fe0916e3          	bnez	s2,9e2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 9fa:	8bea                	mv	s7,s10
      state = 0;
 9fc:	4981                	li	s3,0
 9fe:	6d02                	ld	s10,0(sp)
 a00:	bd01                	j	810 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 a02:	008b8913          	addi	s2,s7,8
 a06:	000bc583          	lbu	a1,0(s7)
 a0a:	855a                	mv	a0,s6
 a0c:	d01ff0ef          	jal	70c <putc>
 a10:	8bca                	mv	s7,s2
      state = 0;
 a12:	4981                	li	s3,0
 a14:	bbf5                	j	810 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 a16:	008b8993          	addi	s3,s7,8
 a1a:	000bb903          	ld	s2,0(s7)
 a1e:	00090f63          	beqz	s2,a3c <vprintf+0x276>
        for (; *s; s++)
 a22:	00094583          	lbu	a1,0(s2)
 a26:	c195                	beqz	a1,a4a <vprintf+0x284>
          putc(fd, *s);
 a28:	855a                	mv	a0,s6
 a2a:	ce3ff0ef          	jal	70c <putc>
        for (; *s; s++)
 a2e:	0905                	addi	s2,s2,1
 a30:	00094583          	lbu	a1,0(s2)
 a34:	f9f5                	bnez	a1,a28 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 a36:	8bce                	mv	s7,s3
      state = 0;
 a38:	4981                	li	s3,0
 a3a:	bbd9                	j	810 <vprintf+0x4a>
          s = "(null)";
 a3c:	00000917          	auipc	s2,0x0
 a40:	64490913          	addi	s2,s2,1604 # 1080 <malloc+0x538>
        for (; *s; s++)
 a44:	02800593          	li	a1,40
 a48:	b7c5                	j	a28 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 a4a:	8bce                	mv	s7,s3
      state = 0;
 a4c:	4981                	li	s3,0
 a4e:	b3c9                	j	810 <vprintf+0x4a>
 a50:	64a6                	ld	s1,72(sp)
 a52:	79e2                	ld	s3,56(sp)
 a54:	7a42                	ld	s4,48(sp)
 a56:	7aa2                	ld	s5,40(sp)
 a58:	7b02                	ld	s6,32(sp)
 a5a:	6be2                	ld	s7,24(sp)
 a5c:	6c42                	ld	s8,16(sp)
 a5e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a60:	60e6                	ld	ra,88(sp)
 a62:	6446                	ld	s0,80(sp)
 a64:	6906                	ld	s2,64(sp)
 a66:	6125                	addi	sp,sp,96
 a68:	8082                	ret

0000000000000a6a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a6a:	715d                	addi	sp,sp,-80
 a6c:	ec06                	sd	ra,24(sp)
 a6e:	e822                	sd	s0,16(sp)
 a70:	1000                	addi	s0,sp,32
 a72:	e010                	sd	a2,0(s0)
 a74:	e414                	sd	a3,8(s0)
 a76:	e818                	sd	a4,16(s0)
 a78:	ec1c                	sd	a5,24(s0)
 a7a:	03043023          	sd	a6,32(s0)
 a7e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a82:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a86:	8622                	mv	a2,s0
 a88:	d3fff0ef          	jal	7c6 <vprintf>
}
 a8c:	60e2                	ld	ra,24(sp)
 a8e:	6442                	ld	s0,16(sp)
 a90:	6161                	addi	sp,sp,80
 a92:	8082                	ret

0000000000000a94 <printf>:

void
printf(const char *fmt, ...)
{
 a94:	711d                	addi	sp,sp,-96
 a96:	ec06                	sd	ra,24(sp)
 a98:	e822                	sd	s0,16(sp)
 a9a:	1000                	addi	s0,sp,32
 a9c:	e40c                	sd	a1,8(s0)
 a9e:	e810                	sd	a2,16(s0)
 aa0:	ec14                	sd	a3,24(s0)
 aa2:	f018                	sd	a4,32(s0)
 aa4:	f41c                	sd	a5,40(s0)
 aa6:	03043823          	sd	a6,48(s0)
 aaa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aae:	00840613          	addi	a2,s0,8
 ab2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ab6:	85aa                	mv	a1,a0
 ab8:	4505                	li	a0,1
 aba:	d0dff0ef          	jal	7c6 <vprintf>
}
 abe:	60e2                	ld	ra,24(sp)
 ac0:	6442                	ld	s0,16(sp)
 ac2:	6125                	addi	sp,sp,96
 ac4:	8082                	ret

0000000000000ac6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac6:	1141                	addi	sp,sp,-16
 ac8:	e422                	sd	s0,8(sp)
 aca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 acc:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad0:	00001797          	auipc	a5,0x1
 ad4:	5307b783          	ld	a5,1328(a5) # 2000 <freep>
 ad8:	a02d                	j	b02 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 ada:	4618                	lw	a4,8(a2)
 adc:	9f2d                	addw	a4,a4,a1
 ade:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ae2:	6398                	ld	a4,0(a5)
 ae4:	6310                	ld	a2,0(a4)
 ae6:	a83d                	j	b24 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 ae8:	ff852703          	lw	a4,-8(a0)
 aec:	9f31                	addw	a4,a4,a2
 aee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 af0:	ff053683          	ld	a3,-16(a0)
 af4:	a091                	j	b38 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af6:	6398                	ld	a4,0(a5)
 af8:	00e7e463          	bltu	a5,a4,b00 <free+0x3a>
 afc:	00e6ea63          	bltu	a3,a4,b10 <free+0x4a>
{
 b00:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b02:	fed7fae3          	bgeu	a5,a3,af6 <free+0x30>
 b06:	6398                	ld	a4,0(a5)
 b08:	00e6e463          	bltu	a3,a4,b10 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b0c:	fee7eae3          	bltu	a5,a4,b00 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 b10:	ff852583          	lw	a1,-8(a0)
 b14:	6390                	ld	a2,0(a5)
 b16:	02059813          	slli	a6,a1,0x20
 b1a:	01c85713          	srli	a4,a6,0x1c
 b1e:	9736                	add	a4,a4,a3
 b20:	fae60de3          	beq	a2,a4,ada <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b24:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 b28:	4790                	lw	a2,8(a5)
 b2a:	02061593          	slli	a1,a2,0x20
 b2e:	01c5d713          	srli	a4,a1,0x1c
 b32:	973e                	add	a4,a4,a5
 b34:	fae68ae3          	beq	a3,a4,ae8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b38:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b3a:	00001717          	auipc	a4,0x1
 b3e:	4cf73323          	sd	a5,1222(a4) # 2000 <freep>
}
 b42:	6422                	ld	s0,8(sp)
 b44:	0141                	addi	sp,sp,16
 b46:	8082                	ret

0000000000000b48 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 b48:	7139                	addi	sp,sp,-64
 b4a:	fc06                	sd	ra,56(sp)
 b4c:	f822                	sd	s0,48(sp)
 b4e:	f426                	sd	s1,40(sp)
 b50:	ec4e                	sd	s3,24(sp)
 b52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b54:	02051493          	slli	s1,a0,0x20
 b58:	9081                	srli	s1,s1,0x20
 b5a:	04bd                	addi	s1,s1,15
 b5c:	8091                	srli	s1,s1,0x4
 b5e:	0014899b          	addiw	s3,s1,1
 b62:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 b64:	00001517          	auipc	a0,0x1
 b68:	49c53503          	ld	a0,1180(a0) # 2000 <freep>
 b6c:	c915                	beqz	a0,ba0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b6e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b70:	4798                	lw	a4,8(a5)
 b72:	08977a63          	bgeu	a4,s1,c06 <malloc+0xbe>
 b76:	f04a                	sd	s2,32(sp)
 b78:	e852                	sd	s4,16(sp)
 b7a:	e456                	sd	s5,8(sp)
 b7c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 b7e:	8a4e                	mv	s4,s3
 b80:	0009871b          	sext.w	a4,s3
 b84:	6685                	lui	a3,0x1
 b86:	00d77363          	bgeu	a4,a3,b8c <malloc+0x44>
 b8a:	6a05                	lui	s4,0x1
 b8c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b90:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 b94:	00001917          	auipc	s2,0x1
 b98:	46c90913          	addi	s2,s2,1132 # 2000 <freep>
  if (p == SBRK_ERROR)
 b9c:	5afd                	li	s5,-1
 b9e:	a081                	j	bde <malloc+0x96>
 ba0:	f04a                	sd	s2,32(sp)
 ba2:	e852                	sd	s4,16(sp)
 ba4:	e456                	sd	s5,8(sp)
 ba6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ba8:	00001797          	auipc	a5,0x1
 bac:	46878793          	addi	a5,a5,1128 # 2010 <base>
 bb0:	00001717          	auipc	a4,0x1
 bb4:	44f73823          	sd	a5,1104(a4) # 2000 <freep>
 bb8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bba:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 bbe:	b7c1                	j	b7e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 bc0:	6398                	ld	a4,0(a5)
 bc2:	e118                	sd	a4,0(a0)
 bc4:	a8a9                	j	c1e <malloc+0xd6>
  hp->s.size = nu;
 bc6:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 bca:	0541                	addi	a0,a0,16
 bcc:	efbff0ef          	jal	ac6 <free>
  return freep;
 bd0:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 bd4:	c12d                	beqz	a0,c36 <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 bd6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 bd8:	4798                	lw	a4,8(a5)
 bda:	02977263          	bgeu	a4,s1,bfe <malloc+0xb6>
    if (p == freep)
 bde:	00093703          	ld	a4,0(s2)
 be2:	853e                	mv	a0,a5
 be4:	fef719e3          	bne	a4,a5,bd6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 be8:	8552                	mv	a0,s4
 bea:	9afff0ef          	jal	598 <sbrk>
  if (p == SBRK_ERROR)
 bee:	fd551ce3          	bne	a0,s5,bc6 <malloc+0x7e>
        return 0;
 bf2:	4501                	li	a0,0
 bf4:	7902                	ld	s2,32(sp)
 bf6:	6a42                	ld	s4,16(sp)
 bf8:	6aa2                	ld	s5,8(sp)
 bfa:	6b02                	ld	s6,0(sp)
 bfc:	a03d                	j	c2a <malloc+0xe2>
 bfe:	7902                	ld	s2,32(sp)
 c00:	6a42                	ld	s4,16(sp)
 c02:	6aa2                	ld	s5,8(sp)
 c04:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 c06:	fae48de3          	beq	s1,a4,bc0 <malloc+0x78>
        p->s.size -= nunits;
 c0a:	4137073b          	subw	a4,a4,s3
 c0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c10:	02071693          	slli	a3,a4,0x20
 c14:	01c6d713          	srli	a4,a3,0x1c
 c18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c1e:	00001717          	auipc	a4,0x1
 c22:	3ea73123          	sd	a0,994(a4) # 2000 <freep>
      return (void *)(p + 1);
 c26:	01078513          	addi	a0,a5,16
  }
}
 c2a:	70e2                	ld	ra,56(sp)
 c2c:	7442                	ld	s0,48(sp)
 c2e:	74a2                	ld	s1,40(sp)
 c30:	69e2                	ld	s3,24(sp)
 c32:	6121                	addi	sp,sp,64
 c34:	8082                	ret
 c36:	7902                	ld	s2,32(sp)
 c38:	6a42                	ld	s4,16(sp)
 c3a:	6aa2                	ld	s5,8(sp)
 c3c:	6b02                	ld	s6,0(sp)
 c3e:	b7f5                	j	c2a <malloc+0xe2>
