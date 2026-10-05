
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	68078793          	addi	a5,a5,1664 # 8690 <malloc+0x2a24>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	739c                	ld	a5,32(a5)
      22:	fab43423          	sd	a1,-88(s0)
      26:	fac43823          	sd	a2,-80(s0)
      2a:	fad43c23          	sd	a3,-72(s0)
      2e:	fce43023          	sd	a4,-64(s0)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	768050ef          	jal	57b2 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	cf450513          	addi	a0,a0,-780 # 5d60 <malloc+0xf4>
      74:	341050ef          	jal	5bb4 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	6f8050ef          	jal	5772 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000a797          	auipc	a5,0xa
      82:	56a78793          	addi	a5,a5,1386 # a5e8 <uninit>
      86:	0000d697          	auipc	a3,0xd
      8a:	c7268693          	addi	a3,a3,-910 # ccf8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	cda50513          	addi	a0,a0,-806 # 5d80 <malloc+0x114>
      ae:	307050ef          	jal	5bb4 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	6be050ef          	jal	5772 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	cd250513          	addi	a0,a0,-814 # 5d98 <malloc+0x12c>
      ce:	6e4050ef          	jal	57b2 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	6c4050ef          	jal	579a <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	cdc50513          	addi	a0,a0,-804 # 5db8 <malloc+0x14c>
      e4:	6ce050ef          	jal	57b2 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	ca850513          	addi	a0,a0,-856 # 5da0 <malloc+0x134>
     100:	2b5050ef          	jal	5bb4 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	66c050ef          	jal	5772 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	cbc50513          	addi	a0,a0,-836 # 5dc8 <malloc+0x15c>
     114:	2a1050ef          	jal	5bb4 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	658050ef          	jal	5772 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	cc250513          	addi	a0,a0,-830 # 5df0 <malloc+0x184>
     136:	68c050ef          	jal	57c2 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	cb250513          	addi	a0,a0,-846 # 5df0 <malloc+0x184>
     146:	66c050ef          	jal	57b2 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	cb258593          	addi	a1,a1,-846 # 5e00 <malloc+0x194>
     156:	63c050ef          	jal	5792 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	c9250513          	addi	a0,a0,-878 # 5df0 <malloc+0x184>
     166:	64c050ef          	jal	57b2 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	c9a58593          	addi	a1,a1,-870 # 5e08 <malloc+0x19c>
     176:	8526                	mv	a0,s1
     178:	61a050ef          	jal	5792 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	c6e50513          	addi	a0,a0,-914 # 5df0 <malloc+0x184>
     18a:	638050ef          	jal	57c2 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	60a050ef          	jal	579a <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	604050ef          	jal	579a <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	c6450513          	addi	a0,a0,-924 # 5e10 <malloc+0x1a4>
     1b4:	201050ef          	jal	5bb4 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	5b8050ef          	jal	5772 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	5c0050ef          	jal	57b2 <open>
    close(fd);
     1f6:	5a4050ef          	jal	579a <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	5a0050ef          	jal	57c2 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	715d                	addi	sp,sp,-80
     242:	e486                	sd	ra,72(sp)
     244:	e0a2                	sd	s0,64(sp)
     246:	fc26                	sd	s1,56(sp)
     248:	f84a                	sd	s2,48(sp)
     24a:	f44e                	sd	s3,40(sp)
     24c:	f052                	sd	s4,32(sp)
     24e:	ec56                	sd	s5,24(sp)
     250:	e85a                	sd	s6,16(sp)
     252:	e45e                	sd	s7,8(sp)
     254:	e062                	sd	s8,0(sp)
     256:	0880                	addi	s0,sp,80
     258:	8c2a                	mv	s8,a0
  unlink("bigwrite");
     25a:	00006517          	auipc	a0,0x6
     25e:	bde50513          	addi	a0,a0,-1058 # 5e38 <malloc+0x1cc>
     262:	560050ef          	jal	57c2 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     266:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200b93          	li	s7,514
     26e:	00006a97          	auipc	s5,0x6
     272:	bcaa8a93          	addi	s5,s5,-1078 # 5e38 <malloc+0x1cc>
      int cc = write(fd, buf, sz);
     276:	0000da17          	auipc	s4,0xd
     27a:	a82a0a13          	addi	s4,s4,-1406 # ccf8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     27e:	6b0d                	lui	s6,0x3
     280:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x6f>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     284:	85de                	mv	a1,s7
     286:	8556                	mv	a0,s5
     288:	52a050ef          	jal	57b2 <open>
     28c:	892a                	mv	s2,a0
    if (fd < 0) {
     28e:	04054663          	bltz	a0,2da <bigwrite+0x9a>
      int cc = write(fd, buf, sz);
     292:	8626                	mv	a2,s1
     294:	85d2                	mv	a1,s4
     296:	4fc050ef          	jal	5792 <write>
     29a:	89aa                	mv	s3,a0
      if (cc != sz) {
     29c:	04a49963          	bne	s1,a0,2ee <bigwrite+0xae>
      int cc = write(fd, buf, sz);
     2a0:	8626                	mv	a2,s1
     2a2:	85d2                	mv	a1,s4
     2a4:	854a                	mv	a0,s2
     2a6:	4ec050ef          	jal	5792 <write>
      if (cc != sz) {
     2aa:	04951363          	bne	a0,s1,2f0 <bigwrite+0xb0>
    close(fd);
     2ae:	854a                	mv	a0,s2
     2b0:	4ea050ef          	jal	579a <close>
    unlink("bigwrite");
     2b4:	8556                	mv	a0,s5
     2b6:	50c050ef          	jal	57c2 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2ba:	1d74849b          	addiw	s1,s1,471
     2be:	fd6493e3          	bne	s1,s6,284 <bigwrite+0x44>
}
     2c2:	60a6                	ld	ra,72(sp)
     2c4:	6406                	ld	s0,64(sp)
     2c6:	74e2                	ld	s1,56(sp)
     2c8:	7942                	ld	s2,48(sp)
     2ca:	79a2                	ld	s3,40(sp)
     2cc:	7a02                	ld	s4,32(sp)
     2ce:	6ae2                	ld	s5,24(sp)
     2d0:	6b42                	ld	s6,16(sp)
     2d2:	6ba2                	ld	s7,8(sp)
     2d4:	6c02                	ld	s8,0(sp)
     2d6:	6161                	addi	sp,sp,80
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e2                	mv	a1,s8
     2dc:	00006517          	auipc	a0,0x6
     2e0:	b6c50513          	addi	a0,a0,-1172 # 5e48 <malloc+0x1dc>
     2e4:	0d1050ef          	jal	5bb4 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	488050ef          	jal	5772 <exit>
      if (cc != sz) {
     2ee:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2f0:	86aa                	mv	a3,a0
     2f2:	864e                	mv	a2,s3
     2f4:	85e2                	mv	a1,s8
     2f6:	00006517          	auipc	a0,0x6
     2fa:	b7250513          	addi	a0,a0,-1166 # 5e68 <malloc+0x1fc>
     2fe:	0b7050ef          	jal	5bb4 <printf>
        exit(1);
     302:	4505                	li	a0,1
     304:	46e050ef          	jal	5772 <exit>

0000000000000308 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     308:	7139                	addi	sp,sp,-64
     30a:	fc06                	sd	ra,56(sp)
     30c:	f822                	sd	s0,48(sp)
     30e:	f426                	sd	s1,40(sp)
     310:	f04a                	sd	s2,32(sp)
     312:	ec4e                	sd	s3,24(sp)
     314:	e852                	sd	s4,16(sp)
     316:	e456                	sd	s5,8(sp)
     318:	e05a                	sd	s6,0(sp)
     31a:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31c:	00006517          	auipc	a0,0x6
     320:	b6450513          	addi	a0,a0,-1180 # 5e80 <malloc+0x214>
     324:	49e050ef          	jal	57c2 <unlink>
     328:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32c:	20100a93          	li	s5,513
     330:	00006997          	auipc	s3,0x6
     334:	b5098993          	addi	s3,s3,-1200 # 5e80 <malloc+0x214>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     338:	4b05                	li	s6,1
     33a:	5a7d                	li	s4,-1
     33c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     340:	85d6                	mv	a1,s5
     342:	854e                	mv	a0,s3
     344:	46e050ef          	jal	57b2 <open>
     348:	84aa                	mv	s1,a0
    if (fd < 0) {
     34a:	04054d63          	bltz	a0,3a4 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34e:	865a                	mv	a2,s6
     350:	85d2                	mv	a1,s4
     352:	440050ef          	jal	5792 <write>
    close(fd);
     356:	8526                	mv	a0,s1
     358:	442050ef          	jal	579a <close>
    unlink("junk");
     35c:	854e                	mv	a0,s3
     35e:	464050ef          	jal	57c2 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     362:	397d                	addiw	s2,s2,-1
     364:	fc091ee3          	bnez	s2,340 <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     368:	20100593          	li	a1,513
     36c:	00006517          	auipc	a0,0x6
     370:	b1450513          	addi	a0,a0,-1260 # 5e80 <malloc+0x214>
     374:	43e050ef          	jal	57b2 <open>
     378:	84aa                	mv	s1,a0
  if (fd < 0) {
     37a:	02054e63          	bltz	a0,3b6 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37e:	4605                	li	a2,1
     380:	00006597          	auipc	a1,0x6
     384:	a8858593          	addi	a1,a1,-1400 # 5e08 <malloc+0x19c>
     388:	40a050ef          	jal	5792 <write>
     38c:	4785                	li	a5,1
     38e:	02f50d63          	beq	a0,a5,3c8 <badwrite+0xc0>
    printf("write failed\n");
     392:	00006517          	auipc	a0,0x6
     396:	b0e50513          	addi	a0,a0,-1266 # 5ea0 <malloc+0x234>
     39a:	01b050ef          	jal	5bb4 <printf>
    exit(1);
     39e:	4505                	li	a0,1
     3a0:	3d2050ef          	jal	5772 <exit>
      printf("open junk failed\n");
     3a4:	00006517          	auipc	a0,0x6
     3a8:	ae450513          	addi	a0,a0,-1308 # 5e88 <malloc+0x21c>
     3ac:	009050ef          	jal	5bb4 <printf>
      exit(1);
     3b0:	4505                	li	a0,1
     3b2:	3c0050ef          	jal	5772 <exit>
    printf("open junk failed\n");
     3b6:	00006517          	auipc	a0,0x6
     3ba:	ad250513          	addi	a0,a0,-1326 # 5e88 <malloc+0x21c>
     3be:	7f6050ef          	jal	5bb4 <printf>
    exit(1);
     3c2:	4505                	li	a0,1
     3c4:	3ae050ef          	jal	5772 <exit>
  }
  close(fd);
     3c8:	8526                	mv	a0,s1
     3ca:	3d0050ef          	jal	579a <close>
  unlink("junk");
     3ce:	00006517          	auipc	a0,0x6
     3d2:	ab250513          	addi	a0,a0,-1358 # 5e80 <malloc+0x214>
     3d6:	3ec050ef          	jal	57c2 <unlink>

  exit(0);
     3da:	4501                	li	a0,0
     3dc:	396050ef          	jal	5772 <exit>

00000000000003e0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3e0:	711d                	addi	sp,sp,-96
     3e2:	ec86                	sd	ra,88(sp)
     3e4:	e8a2                	sd	s0,80(sp)
     3e6:	e4a6                	sd	s1,72(sp)
     3e8:	e0ca                	sd	s2,64(sp)
     3ea:	fc4e                	sd	s3,56(sp)
     3ec:	f852                	sd	s4,48(sp)
     3ee:	f456                	sd	s5,40(sp)
     3f0:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f2:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f4:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f8:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fc:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     400:	40000a93          	li	s5,1024
    name[0] = 'z';
     404:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     408:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40c:	41f4d71b          	sraiw	a4,s1,0x1f
     410:	01b7571b          	srliw	a4,a4,0x1b
     414:	009707bb          	addw	a5,a4,s1
     418:	4057d69b          	sraiw	a3,a5,0x5
     41c:	0306869b          	addiw	a3,a3,48
     420:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     424:	8bfd                	andi	a5,a5,31
     426:	9f99                	subw	a5,a5,a4
     428:	0307879b          	addiw	a5,a5,48
     42c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     430:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     434:	854a                	mv	a0,s2
     436:	38c050ef          	jal	57c2 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     43a:	85d2                	mv	a1,s4
     43c:	854a                	mv	a0,s2
     43e:	374050ef          	jal	57b2 <open>
    if (fd < 0) {
     442:	00054763          	bltz	a0,450 <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     446:	354050ef          	jal	579a <close>
  for (int i = 0; i < nzz; i++) {
     44a:	2485                	addiw	s1,s1,1
     44c:	fb549ce3          	bne	s1,s5,404 <outofinodes+0x24>
     450:	4481                	li	s1,0
  }

  for (int i = 0; i < nzz; i++) {
    char name[32];
    name[0] = 'z';
     452:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     456:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     45a:	40000993          	li	s3,1024
    name[0] = 'z';
     45e:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     462:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     466:	41f4d71b          	sraiw	a4,s1,0x1f
     46a:	01b7571b          	srliw	a4,a4,0x1b
     46e:	009707bb          	addw	a5,a4,s1
     472:	4057d69b          	sraiw	a3,a5,0x5
     476:	0306869b          	addiw	a3,a3,48
     47a:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47e:	8bfd                	andi	a5,a5,31
     480:	9f99                	subw	a5,a5,a4
     482:	0307879b          	addiw	a5,a5,48
     486:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     48a:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48e:	8552                	mv	a0,s4
     490:	332050ef          	jal	57c2 <unlink>
  for (int i = 0; i < nzz; i++) {
     494:	2485                	addiw	s1,s1,1
     496:	fd3494e3          	bne	s1,s3,45e <outofinodes+0x7e>
  }
}
     49a:	60e6                	ld	ra,88(sp)
     49c:	6446                	ld	s0,80(sp)
     49e:	64a6                	ld	s1,72(sp)
     4a0:	6906                	ld	s2,64(sp)
     4a2:	79e2                	ld	s3,56(sp)
     4a4:	7a42                	ld	s4,48(sp)
     4a6:	7aa2                	ld	s5,40(sp)
     4a8:	6125                	addi	sp,sp,96
     4aa:	8082                	ret

00000000000004ac <copyin>:
{
     4ac:	7175                	addi	sp,sp,-144
     4ae:	e506                	sd	ra,136(sp)
     4b0:	e122                	sd	s0,128(sp)
     4b2:	fca6                	sd	s1,120(sp)
     4b4:	f8ca                	sd	s2,112(sp)
     4b6:	f4ce                	sd	s3,104(sp)
     4b8:	f0d2                	sd	s4,96(sp)
     4ba:	ecd6                	sd	s5,88(sp)
     4bc:	e8da                	sd	s6,80(sp)
     4be:	e4de                	sd	s7,72(sp)
     4c0:	e0e2                	sd	s8,64(sp)
     4c2:	fc66                	sd	s9,56(sp)
     4c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c6:	00008797          	auipc	a5,0x8
     4ca:	1ca78793          	addi	a5,a5,458 # 8690 <malloc+0x2a24>
     4ce:	638c                	ld	a1,0(a5)
     4d0:	6790                	ld	a2,8(a5)
     4d2:	6b94                	ld	a3,16(a5)
     4d4:	6f98                	ld	a4,24(a5)
     4d6:	739c                	ld	a5,32(a5)
     4d8:	f6b43c23          	sd	a1,-136(s0)
     4dc:	f8c43023          	sd	a2,-128(s0)
     4e0:	f8d43423          	sd	a3,-120(s0)
     4e4:	f8e43823          	sd	a4,-112(s0)
     4e8:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ec:	f7840913          	addi	s2,s0,-136
     4f0:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f4:	20100b13          	li	s6,513
     4f8:	00006a97          	auipc	s5,0x6
     4fc:	9b8a8a93          	addi	s5,s5,-1608 # 5eb0 <malloc+0x244>
    int n = write(fd, (void *)addr, 8192);
     500:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     502:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     504:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     508:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50c:	85da                	mv	a1,s6
     50e:	8556                	mv	a0,s5
     510:	2a2050ef          	jal	57b2 <open>
     514:	84aa                	mv	s1,a0
    if (fd < 0) {
     516:	06054a63          	bltz	a0,58a <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     51a:	8652                	mv	a2,s4
     51c:	85ce                	mv	a1,s3
     51e:	274050ef          	jal	5792 <write>
    if (n >= 0) {
     522:	06055d63          	bgez	a0,59c <copyin+0xf0>
    close(fd);
     526:	8526                	mv	a0,s1
     528:	272050ef          	jal	579a <close>
    unlink("copyin1");
     52c:	8556                	mv	a0,s5
     52e:	294050ef          	jal	57c2 <unlink>
    n = write(1, (char *)addr, 8192);
     532:	8652                	mv	a2,s4
     534:	85ce                	mv	a1,s3
     536:	8562                	mv	a0,s8
     538:	25a050ef          	jal	5792 <write>
    if (n > 0) {
     53c:	06a04b63          	bgtz	a0,5b2 <copyin+0x106>
    if (pipe(fds) < 0) {
     540:	855e                	mv	a0,s7
     542:	240050ef          	jal	5782 <pipe>
     546:	08054163          	bltz	a0,5c8 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     54a:	8652                	mv	a2,s4
     54c:	85ce                	mv	a1,s3
     54e:	f7442503          	lw	a0,-140(s0)
     552:	240050ef          	jal	5792 <write>
    if (n > 0) {
     556:	08a04263          	bgtz	a0,5da <copyin+0x12e>
    close(fds[0]);
     55a:	f7042503          	lw	a0,-144(s0)
     55e:	23c050ef          	jal	579a <close>
    close(fds[1]);
     562:	f7442503          	lw	a0,-140(s0)
     566:	234050ef          	jal	579a <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     56a:	0921                	addi	s2,s2,8
     56c:	f9991ee3          	bne	s2,s9,508 <copyin+0x5c>
}
     570:	60aa                	ld	ra,136(sp)
     572:	640a                	ld	s0,128(sp)
     574:	74e6                	ld	s1,120(sp)
     576:	7946                	ld	s2,112(sp)
     578:	79a6                	ld	s3,104(sp)
     57a:	7a06                	ld	s4,96(sp)
     57c:	6ae6                	ld	s5,88(sp)
     57e:	6b46                	ld	s6,80(sp)
     580:	6ba6                	ld	s7,72(sp)
     582:	6c06                	ld	s8,64(sp)
     584:	7ce2                	ld	s9,56(sp)
     586:	6149                	addi	sp,sp,144
     588:	8082                	ret
      printf("open(copyin1) failed\n");
     58a:	00006517          	auipc	a0,0x6
     58e:	92e50513          	addi	a0,a0,-1746 # 5eb8 <malloc+0x24c>
     592:	622050ef          	jal	5bb4 <printf>
      exit(1);
     596:	4505                	li	a0,1
     598:	1da050ef          	jal	5772 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59c:	862a                	mv	a2,a0
     59e:	85ce                	mv	a1,s3
     5a0:	00006517          	auipc	a0,0x6
     5a4:	93050513          	addi	a0,a0,-1744 # 5ed0 <malloc+0x264>
     5a8:	60c050ef          	jal	5bb4 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	1c4050ef          	jal	5772 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b2:	862a                	mv	a2,a0
     5b4:	85ce                	mv	a1,s3
     5b6:	00006517          	auipc	a0,0x6
     5ba:	94a50513          	addi	a0,a0,-1718 # 5f00 <malloc+0x294>
     5be:	5f6050ef          	jal	5bb4 <printf>
      exit(1);
     5c2:	4505                	li	a0,1
     5c4:	1ae050ef          	jal	5772 <exit>
      printf("pipe() failed\n");
     5c8:	00006517          	auipc	a0,0x6
     5cc:	96850513          	addi	a0,a0,-1688 # 5f30 <malloc+0x2c4>
     5d0:	5e4050ef          	jal	5bb4 <printf>
      exit(1);
     5d4:	4505                	li	a0,1
     5d6:	19c050ef          	jal	5772 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5da:	862a                	mv	a2,a0
     5dc:	85ce                	mv	a1,s3
     5de:	00006517          	auipc	a0,0x6
     5e2:	96250513          	addi	a0,a0,-1694 # 5f40 <malloc+0x2d4>
     5e6:	5ce050ef          	jal	5bb4 <printf>
      exit(1);
     5ea:	4505                	li	a0,1
     5ec:	186050ef          	jal	5772 <exit>

00000000000005f0 <copyout>:
{
     5f0:	7135                	addi	sp,sp,-160
     5f2:	ed06                	sd	ra,152(sp)
     5f4:	e922                	sd	s0,144(sp)
     5f6:	e526                	sd	s1,136(sp)
     5f8:	e14a                	sd	s2,128(sp)
     5fa:	fcce                	sd	s3,120(sp)
     5fc:	f8d2                	sd	s4,112(sp)
     5fe:	f4d6                	sd	s5,104(sp)
     600:	f0da                	sd	s6,96(sp)
     602:	ecde                	sd	s7,88(sp)
     604:	e8e2                	sd	s8,80(sp)
     606:	e4e6                	sd	s9,72(sp)
     608:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     60a:	00008797          	auipc	a5,0x8
     60e:	08678793          	addi	a5,a5,134 # 8690 <malloc+0x2a24>
     612:	7788                	ld	a0,40(a5)
     614:	7b8c                	ld	a1,48(a5)
     616:	7f90                	ld	a2,56(a5)
     618:	63b4                	ld	a3,64(a5)
     61a:	67b8                	ld	a4,72(a5)
     61c:	6bbc                	ld	a5,80(a5)
     61e:	f6a43823          	sd	a0,-144(s0)
     622:	f6b43c23          	sd	a1,-136(s0)
     626:	f8c43023          	sd	a2,-128(s0)
     62a:	f8d43423          	sd	a3,-120(s0)
     62e:	f8e43823          	sd	a4,-112(s0)
     632:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     636:	f7040913          	addi	s2,s0,-144
     63a:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63e:	00006b17          	auipc	s6,0x6
     642:	932b0b13          	addi	s6,s6,-1742 # 5f70 <malloc+0x304>
    int n = read(fd, (void *)addr, 8192);
     646:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     648:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64c:	4a05                	li	s4,1
     64e:	00005b97          	auipc	s7,0x5
     652:	7bab8b93          	addi	s7,s7,1978 # 5e08 <malloc+0x19c>
    uint64 addr = addrs[ai];
     656:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     65a:	4581                	li	a1,0
     65c:	855a                	mv	a0,s6
     65e:	154050ef          	jal	57b2 <open>
     662:	84aa                	mv	s1,a0
    if (fd < 0) {
     664:	06054863          	bltz	a0,6d4 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     668:	8656                	mv	a2,s5
     66a:	85ce                	mv	a1,s3
     66c:	11e050ef          	jal	578a <read>
    if (n > 0) {
     670:	06a04b63          	bgtz	a0,6e6 <copyout+0xf6>
    close(fd);
     674:	8526                	mv	a0,s1
     676:	124050ef          	jal	579a <close>
    if (pipe(fds) < 0) {
     67a:	8562                	mv	a0,s8
     67c:	106050ef          	jal	5782 <pipe>
     680:	06054e63          	bltz	a0,6fc <copyout+0x10c>
    n = write(fds[1], "x", 1);
     684:	8652                	mv	a2,s4
     686:	85de                	mv	a1,s7
     688:	f6c42503          	lw	a0,-148(s0)
     68c:	106050ef          	jal	5792 <write>
    if (n != 1) {
     690:	07451f63          	bne	a0,s4,70e <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     694:	8656                	mv	a2,s5
     696:	85ce                	mv	a1,s3
     698:	f6842503          	lw	a0,-152(s0)
     69c:	0ee050ef          	jal	578a <read>
    if (n > 0) {
     6a0:	08a04063          	bgtz	a0,720 <copyout+0x130>
    close(fds[0]);
     6a4:	f6842503          	lw	a0,-152(s0)
     6a8:	0f2050ef          	jal	579a <close>
    close(fds[1]);
     6ac:	f6c42503          	lw	a0,-148(s0)
     6b0:	0ea050ef          	jal	579a <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b4:	0921                	addi	s2,s2,8
     6b6:	fb9910e3          	bne	s2,s9,656 <copyout+0x66>
}
     6ba:	60ea                	ld	ra,152(sp)
     6bc:	644a                	ld	s0,144(sp)
     6be:	64aa                	ld	s1,136(sp)
     6c0:	690a                	ld	s2,128(sp)
     6c2:	79e6                	ld	s3,120(sp)
     6c4:	7a46                	ld	s4,112(sp)
     6c6:	7aa6                	ld	s5,104(sp)
     6c8:	7b06                	ld	s6,96(sp)
     6ca:	6be6                	ld	s7,88(sp)
     6cc:	6c46                	ld	s8,80(sp)
     6ce:	6ca6                	ld	s9,72(sp)
     6d0:	610d                	addi	sp,sp,160
     6d2:	8082                	ret
      printf("open(README) failed\n");
     6d4:	00006517          	auipc	a0,0x6
     6d8:	8a450513          	addi	a0,a0,-1884 # 5f78 <malloc+0x30c>
     6dc:	4d8050ef          	jal	5bb4 <printf>
      exit(1);
     6e0:	4505                	li	a0,1
     6e2:	090050ef          	jal	5772 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00006517          	auipc	a0,0x6
     6ee:	8a650513          	addi	a0,a0,-1882 # 5f90 <malloc+0x324>
     6f2:	4c2050ef          	jal	5bb4 <printf>
      exit(1);
     6f6:	4505                	li	a0,1
     6f8:	07a050ef          	jal	5772 <exit>
      printf("pipe() failed\n");
     6fc:	00006517          	auipc	a0,0x6
     700:	83450513          	addi	a0,a0,-1996 # 5f30 <malloc+0x2c4>
     704:	4b0050ef          	jal	5bb4 <printf>
      exit(1);
     708:	4505                	li	a0,1
     70a:	068050ef          	jal	5772 <exit>
      printf("pipe write failed\n");
     70e:	00006517          	auipc	a0,0x6
     712:	8b250513          	addi	a0,a0,-1870 # 5fc0 <malloc+0x354>
     716:	49e050ef          	jal	5bb4 <printf>
      exit(1);
     71a:	4505                	li	a0,1
     71c:	056050ef          	jal	5772 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     720:	862a                	mv	a2,a0
     722:	85ce                	mv	a1,s3
     724:	00006517          	auipc	a0,0x6
     728:	8b450513          	addi	a0,a0,-1868 # 5fd8 <malloc+0x36c>
     72c:	488050ef          	jal	5bb4 <printf>
      exit(1);
     730:	4505                	li	a0,1
     732:	040050ef          	jal	5772 <exit>

0000000000000736 <truncate1>:
{
     736:	711d                	addi	sp,sp,-96
     738:	ec86                	sd	ra,88(sp)
     73a:	e8a2                	sd	s0,80(sp)
     73c:	e4a6                	sd	s1,72(sp)
     73e:	e0ca                	sd	s2,64(sp)
     740:	fc4e                	sd	s3,56(sp)
     742:	f852                	sd	s4,48(sp)
     744:	f456                	sd	s5,40(sp)
     746:	1080                	addi	s0,sp,96
     748:	8aaa                	mv	s5,a0
  unlink("truncfile");
     74a:	00005517          	auipc	a0,0x5
     74e:	6a650513          	addi	a0,a0,1702 # 5df0 <malloc+0x184>
     752:	070050ef          	jal	57c2 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     756:	60100593          	li	a1,1537
     75a:	00005517          	auipc	a0,0x5
     75e:	69650513          	addi	a0,a0,1686 # 5df0 <malloc+0x184>
     762:	050050ef          	jal	57b2 <open>
     766:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     768:	4611                	li	a2,4
     76a:	00005597          	auipc	a1,0x5
     76e:	69658593          	addi	a1,a1,1686 # 5e00 <malloc+0x194>
     772:	020050ef          	jal	5792 <write>
  close(fd1);
     776:	8526                	mv	a0,s1
     778:	022050ef          	jal	579a <close>
  int fd2 = open("truncfile", O_RDONLY);
     77c:	4581                	li	a1,0
     77e:	00005517          	auipc	a0,0x5
     782:	67250513          	addi	a0,a0,1650 # 5df0 <malloc+0x184>
     786:	02c050ef          	jal	57b2 <open>
     78a:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78c:	02000613          	li	a2,32
     790:	fa040593          	addi	a1,s0,-96
     794:	7f7040ef          	jal	578a <read>
  if (n != 4) {
     798:	4791                	li	a5,4
     79a:	0af51863          	bne	a0,a5,84a <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79e:	40100593          	li	a1,1025
     7a2:	00005517          	auipc	a0,0x5
     7a6:	64e50513          	addi	a0,a0,1614 # 5df0 <malloc+0x184>
     7aa:	008050ef          	jal	57b2 <open>
     7ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7b0:	4581                	li	a1,0
     7b2:	00005517          	auipc	a0,0x5
     7b6:	63e50513          	addi	a0,a0,1598 # 5df0 <malloc+0x184>
     7ba:	7f9040ef          	jal	57b2 <open>
     7be:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7c0:	02000613          	li	a2,32
     7c4:	fa040593          	addi	a1,s0,-96
     7c8:	7c3040ef          	jal	578a <read>
     7cc:	8a2a                	mv	s4,a0
  if (n != 0) {
     7ce:	e949                	bnez	a0,860 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7d0:	02000613          	li	a2,32
     7d4:	fa040593          	addi	a1,s0,-96
     7d8:	8526                	mv	a0,s1
     7da:	7b1040ef          	jal	578a <read>
     7de:	8a2a                	mv	s4,a0
  if (n != 0) {
     7e0:	e155                	bnez	a0,884 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e2:	4619                	li	a2,6
     7e4:	00006597          	auipc	a1,0x6
     7e8:	88458593          	addi	a1,a1,-1916 # 6068 <malloc+0x3fc>
     7ec:	854e                	mv	a0,s3
     7ee:	7a5040ef          	jal	5792 <write>
  n = read(fd3, buf, sizeof(buf));
     7f2:	02000613          	li	a2,32
     7f6:	fa040593          	addi	a1,s0,-96
     7fa:	854a                	mv	a0,s2
     7fc:	78f040ef          	jal	578a <read>
  if (n != 6) {
     800:	4799                	li	a5,6
     802:	0af51363          	bne	a0,a5,8a8 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     806:	02000613          	li	a2,32
     80a:	fa040593          	addi	a1,s0,-96
     80e:	8526                	mv	a0,s1
     810:	77b040ef          	jal	578a <read>
  if (n != 2) {
     814:	4789                	li	a5,2
     816:	0af51463          	bne	a0,a5,8be <truncate1+0x188>
  unlink("truncfile");
     81a:	00005517          	auipc	a0,0x5
     81e:	5d650513          	addi	a0,a0,1494 # 5df0 <malloc+0x184>
     822:	7a1040ef          	jal	57c2 <unlink>
  close(fd1);
     826:	854e                	mv	a0,s3
     828:	773040ef          	jal	579a <close>
  close(fd2);
     82c:	8526                	mv	a0,s1
     82e:	76d040ef          	jal	579a <close>
  close(fd3);
     832:	854a                	mv	a0,s2
     834:	767040ef          	jal	579a <close>
}
     838:	60e6                	ld	ra,88(sp)
     83a:	6446                	ld	s0,80(sp)
     83c:	64a6                	ld	s1,72(sp)
     83e:	6906                	ld	s2,64(sp)
     840:	79e2                	ld	s3,56(sp)
     842:	7a42                	ld	s4,48(sp)
     844:	7aa2                	ld	s5,40(sp)
     846:	6125                	addi	sp,sp,96
     848:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     84a:	862a                	mv	a2,a0
     84c:	85d6                	mv	a1,s5
     84e:	00005517          	auipc	a0,0x5
     852:	7ba50513          	addi	a0,a0,1978 # 6008 <malloc+0x39c>
     856:	35e050ef          	jal	5bb4 <printf>
    exit(1);
     85a:	4505                	li	a0,1
     85c:	717040ef          	jal	5772 <exit>
    printf("aaa fd3=%d\n", fd3);
     860:	85ca                	mv	a1,s2
     862:	00005517          	auipc	a0,0x5
     866:	7c650513          	addi	a0,a0,1990 # 6028 <malloc+0x3bc>
     86a:	34a050ef          	jal	5bb4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86e:	8652                	mv	a2,s4
     870:	85d6                	mv	a1,s5
     872:	00005517          	auipc	a0,0x5
     876:	7c650513          	addi	a0,a0,1990 # 6038 <malloc+0x3cc>
     87a:	33a050ef          	jal	5bb4 <printf>
    exit(1);
     87e:	4505                	li	a0,1
     880:	6f3040ef          	jal	5772 <exit>
    printf("bbb fd2=%d\n", fd2);
     884:	85a6                	mv	a1,s1
     886:	00005517          	auipc	a0,0x5
     88a:	7d250513          	addi	a0,a0,2002 # 6058 <malloc+0x3ec>
     88e:	326050ef          	jal	5bb4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     892:	8652                	mv	a2,s4
     894:	85d6                	mv	a1,s5
     896:	00005517          	auipc	a0,0x5
     89a:	7a250513          	addi	a0,a0,1954 # 6038 <malloc+0x3cc>
     89e:	316050ef          	jal	5bb4 <printf>
    exit(1);
     8a2:	4505                	li	a0,1
     8a4:	6cf040ef          	jal	5772 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a8:	862a                	mv	a2,a0
     8aa:	85d6                	mv	a1,s5
     8ac:	00005517          	auipc	a0,0x5
     8b0:	7c450513          	addi	a0,a0,1988 # 6070 <malloc+0x404>
     8b4:	300050ef          	jal	5bb4 <printf>
    exit(1);
     8b8:	4505                	li	a0,1
     8ba:	6b9040ef          	jal	5772 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8be:	862a                	mv	a2,a0
     8c0:	85d6                	mv	a1,s5
     8c2:	00005517          	auipc	a0,0x5
     8c6:	7ce50513          	addi	a0,a0,1998 # 6090 <malloc+0x424>
     8ca:	2ea050ef          	jal	5bb4 <printf>
    exit(1);
     8ce:	4505                	li	a0,1
     8d0:	6a3040ef          	jal	5772 <exit>

00000000000008d4 <writetest>:
{
     8d4:	715d                	addi	sp,sp,-80
     8d6:	e486                	sd	ra,72(sp)
     8d8:	e0a2                	sd	s0,64(sp)
     8da:	fc26                	sd	s1,56(sp)
     8dc:	f84a                	sd	s2,48(sp)
     8de:	f44e                	sd	s3,40(sp)
     8e0:	f052                	sd	s4,32(sp)
     8e2:	ec56                	sd	s5,24(sp)
     8e4:	e85a                	sd	s6,16(sp)
     8e6:	e45e                	sd	s7,8(sp)
     8e8:	0880                	addi	s0,sp,80
     8ea:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ec:	20200593          	li	a1,514
     8f0:	00005517          	auipc	a0,0x5
     8f4:	7c050513          	addi	a0,a0,1984 # 60b0 <malloc+0x444>
     8f8:	6bb040ef          	jal	57b2 <open>
  if (fd < 0) {
     8fc:	08054f63          	bltz	a0,99a <writetest+0xc6>
     900:	89aa                	mv	s3,a0
     902:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     904:	44a9                	li	s1,10
     906:	00005a17          	auipc	s4,0x5
     90a:	7d2a0a13          	addi	s4,s4,2002 # 60d8 <malloc+0x46c>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90e:	00006b17          	auipc	s6,0x6
     912:	802b0b13          	addi	s6,s6,-2046 # 6110 <malloc+0x4a4>
  for (i = 0; i < N; i++) {
     916:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     91a:	8626                	mv	a2,s1
     91c:	85d2                	mv	a1,s4
     91e:	854e                	mv	a0,s3
     920:	673040ef          	jal	5792 <write>
     924:	08951563          	bne	a0,s1,9ae <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     928:	8626                	mv	a2,s1
     92a:	85da                	mv	a1,s6
     92c:	854e                	mv	a0,s3
     92e:	665040ef          	jal	5792 <write>
     932:	08951963          	bne	a0,s1,9c4 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     936:	2905                	addiw	s2,s2,1
     938:	ff5911e3          	bne	s2,s5,91a <writetest+0x46>
  close(fd);
     93c:	854e                	mv	a0,s3
     93e:	65d040ef          	jal	579a <close>
  fd = open("small", O_RDONLY);
     942:	4581                	li	a1,0
     944:	00005517          	auipc	a0,0x5
     948:	76c50513          	addi	a0,a0,1900 # 60b0 <malloc+0x444>
     94c:	667040ef          	jal	57b2 <open>
     950:	84aa                	mv	s1,a0
  if (fd < 0) {
     952:	08054463          	bltz	a0,9da <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     956:	7d000613          	li	a2,2000
     95a:	0000c597          	auipc	a1,0xc
     95e:	39e58593          	addi	a1,a1,926 # ccf8 <buf>
     962:	629040ef          	jal	578a <read>
  if (i != N * SZ * 2) {
     966:	7d000793          	li	a5,2000
     96a:	08f51263          	bne	a0,a5,9ee <writetest+0x11a>
  close(fd);
     96e:	8526                	mv	a0,s1
     970:	62b040ef          	jal	579a <close>
  if (unlink("small") < 0) {
     974:	00005517          	auipc	a0,0x5
     978:	73c50513          	addi	a0,a0,1852 # 60b0 <malloc+0x444>
     97c:	647040ef          	jal	57c2 <unlink>
     980:	08054163          	bltz	a0,a02 <writetest+0x12e>
}
     984:	60a6                	ld	ra,72(sp)
     986:	6406                	ld	s0,64(sp)
     988:	74e2                	ld	s1,56(sp)
     98a:	7942                	ld	s2,48(sp)
     98c:	79a2                	ld	s3,40(sp)
     98e:	7a02                	ld	s4,32(sp)
     990:	6ae2                	ld	s5,24(sp)
     992:	6b42                	ld	s6,16(sp)
     994:	6ba2                	ld	s7,8(sp)
     996:	6161                	addi	sp,sp,80
     998:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     99a:	85de                	mv	a1,s7
     99c:	00005517          	auipc	a0,0x5
     9a0:	71c50513          	addi	a0,a0,1820 # 60b8 <malloc+0x44c>
     9a4:	210050ef          	jal	5bb4 <printf>
    exit(1);
     9a8:	4505                	li	a0,1
     9aa:	5c9040ef          	jal	5772 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ae:	864a                	mv	a2,s2
     9b0:	85de                	mv	a1,s7
     9b2:	00005517          	auipc	a0,0x5
     9b6:	73650513          	addi	a0,a0,1846 # 60e8 <malloc+0x47c>
     9ba:	1fa050ef          	jal	5bb4 <printf>
      exit(1);
     9be:	4505                	li	a0,1
     9c0:	5b3040ef          	jal	5772 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c4:	864a                	mv	a2,s2
     9c6:	85de                	mv	a1,s7
     9c8:	00005517          	auipc	a0,0x5
     9cc:	75850513          	addi	a0,a0,1880 # 6120 <malloc+0x4b4>
     9d0:	1e4050ef          	jal	5bb4 <printf>
      exit(1);
     9d4:	4505                	li	a0,1
     9d6:	59d040ef          	jal	5772 <exit>
    printf("%s: error: open small failed!\n", s);
     9da:	85de                	mv	a1,s7
     9dc:	00005517          	auipc	a0,0x5
     9e0:	76c50513          	addi	a0,a0,1900 # 6148 <malloc+0x4dc>
     9e4:	1d0050ef          	jal	5bb4 <printf>
    exit(1);
     9e8:	4505                	li	a0,1
     9ea:	589040ef          	jal	5772 <exit>
    printf("%s: read failed\n", s);
     9ee:	85de                	mv	a1,s7
     9f0:	00005517          	auipc	a0,0x5
     9f4:	77850513          	addi	a0,a0,1912 # 6168 <malloc+0x4fc>
     9f8:	1bc050ef          	jal	5bb4 <printf>
    exit(1);
     9fc:	4505                	li	a0,1
     9fe:	575040ef          	jal	5772 <exit>
    printf("%s: unlink small failed\n", s);
     a02:	85de                	mv	a1,s7
     a04:	00005517          	auipc	a0,0x5
     a08:	77c50513          	addi	a0,a0,1916 # 6180 <malloc+0x514>
     a0c:	1a8050ef          	jal	5bb4 <printf>
    exit(1);
     a10:	4505                	li	a0,1
     a12:	561040ef          	jal	5772 <exit>

0000000000000a16 <writebig>:
{
     a16:	7139                	addi	sp,sp,-64
     a18:	fc06                	sd	ra,56(sp)
     a1a:	f822                	sd	s0,48(sp)
     a1c:	f426                	sd	s1,40(sp)
     a1e:	f04a                	sd	s2,32(sp)
     a20:	ec4e                	sd	s3,24(sp)
     a22:	e852                	sd	s4,16(sp)
     a24:	e456                	sd	s5,8(sp)
     a26:	e05a                	sd	s6,0(sp)
     a28:	0080                	addi	s0,sp,64
     a2a:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2c:	20200593          	li	a1,514
     a30:	00005517          	auipc	a0,0x5
     a34:	77050513          	addi	a0,a0,1904 # 61a0 <malloc+0x534>
     a38:	57b040ef          	jal	57b2 <open>
  if (fd < 0) {
     a3c:	06054a63          	bltz	a0,ab0 <writebig+0x9a>
     a40:	8a2a                	mv	s4,a0
     a42:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a44:	0000c997          	auipc	s3,0xc
     a48:	2b498993          	addi	s3,s3,692 # ccf8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4c:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a50:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a54:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a58:	864a                	mv	a2,s2
     a5a:	85ce                	mv	a1,s3
     a5c:	8552                	mv	a0,s4
     a5e:	535040ef          	jal	5792 <write>
     a62:	07251163          	bne	a0,s2,ac4 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a66:	2485                	addiw	s1,s1,1
     a68:	ff5496e3          	bne	s1,s5,a54 <writebig+0x3e>
  close(fd);
     a6c:	8552                	mv	a0,s4
     a6e:	52d040ef          	jal	579a <close>
  fd = open("big", O_RDONLY);
     a72:	4581                	li	a1,0
     a74:	00005517          	auipc	a0,0x5
     a78:	72c50513          	addi	a0,a0,1836 # 61a0 <malloc+0x534>
     a7c:	537040ef          	jal	57b2 <open>
     a80:	8a2a                	mv	s4,a0
  n = 0;
     a82:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a84:	40000993          	li	s3,1024
     a88:	0000c917          	auipc	s2,0xc
     a8c:	27090913          	addi	s2,s2,624 # ccf8 <buf>
  if (fd < 0) {
     a90:	04054563          	bltz	a0,ada <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a94:	864e                	mv	a2,s3
     a96:	85ca                	mv	a1,s2
     a98:	8552                	mv	a0,s4
     a9a:	4f1040ef          	jal	578a <read>
    if (i == 0) {
     a9e:	c921                	beqz	a0,aee <writebig+0xd8>
    } else if (i != BSIZE) {
     aa0:	09351b63          	bne	a0,s3,b36 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa4:	00092683          	lw	a3,0(s2)
     aa8:	0a969263          	bne	a3,s1,b4c <writebig+0x136>
    n++;
     aac:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aae:	b7dd                	j	a94 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     ab0:	85da                	mv	a1,s6
     ab2:	00005517          	auipc	a0,0x5
     ab6:	6f650513          	addi	a0,a0,1782 # 61a8 <malloc+0x53c>
     aba:	0fa050ef          	jal	5bb4 <printf>
    exit(1);
     abe:	4505                	li	a0,1
     ac0:	4b3040ef          	jal	5772 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac4:	8626                	mv	a2,s1
     ac6:	85da                	mv	a1,s6
     ac8:	00005517          	auipc	a0,0x5
     acc:	70050513          	addi	a0,a0,1792 # 61c8 <malloc+0x55c>
     ad0:	0e4050ef          	jal	5bb4 <printf>
      exit(1);
     ad4:	4505                	li	a0,1
     ad6:	49d040ef          	jal	5772 <exit>
    printf("%s: error: open big failed!\n", s);
     ada:	85da                	mv	a1,s6
     adc:	00005517          	auipc	a0,0x5
     ae0:	71450513          	addi	a0,a0,1812 # 61f0 <malloc+0x584>
     ae4:	0d0050ef          	jal	5bb4 <printf>
    exit(1);
     ae8:	4505                	li	a0,1
     aea:	489040ef          	jal	5772 <exit>
      if (n != MAXFILE) {
     aee:	10c00793          	li	a5,268
     af2:	02f49763          	bne	s1,a5,b20 <writebig+0x10a>
  close(fd);
     af6:	8552                	mv	a0,s4
     af8:	4a3040ef          	jal	579a <close>
  if (unlink("big") < 0) {
     afc:	00005517          	auipc	a0,0x5
     b00:	6a450513          	addi	a0,a0,1700 # 61a0 <malloc+0x534>
     b04:	4bf040ef          	jal	57c2 <unlink>
     b08:	04054d63          	bltz	a0,b62 <writebig+0x14c>
}
     b0c:	70e2                	ld	ra,56(sp)
     b0e:	7442                	ld	s0,48(sp)
     b10:	74a2                	ld	s1,40(sp)
     b12:	7902                	ld	s2,32(sp)
     b14:	69e2                	ld	s3,24(sp)
     b16:	6a42                	ld	s4,16(sp)
     b18:	6aa2                	ld	s5,8(sp)
     b1a:	6b02                	ld	s6,0(sp)
     b1c:	6121                	addi	sp,sp,64
     b1e:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b20:	8626                	mv	a2,s1
     b22:	85da                	mv	a1,s6
     b24:	00005517          	auipc	a0,0x5
     b28:	6ec50513          	addi	a0,a0,1772 # 6210 <malloc+0x5a4>
     b2c:	088050ef          	jal	5bb4 <printf>
        exit(1);
     b30:	4505                	li	a0,1
     b32:	441040ef          	jal	5772 <exit>
      printf("%s: read failed %d\n", s, i);
     b36:	862a                	mv	a2,a0
     b38:	85da                	mv	a1,s6
     b3a:	00005517          	auipc	a0,0x5
     b3e:	6fe50513          	addi	a0,a0,1790 # 6238 <malloc+0x5cc>
     b42:	072050ef          	jal	5bb4 <printf>
      exit(1);
     b46:	4505                	li	a0,1
     b48:	42b040ef          	jal	5772 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4c:	8626                	mv	a2,s1
     b4e:	85da                	mv	a1,s6
     b50:	00005517          	auipc	a0,0x5
     b54:	70050513          	addi	a0,a0,1792 # 6250 <malloc+0x5e4>
     b58:	05c050ef          	jal	5bb4 <printf>
      exit(1);
     b5c:	4505                	li	a0,1
     b5e:	415040ef          	jal	5772 <exit>
    printf("%s: unlink big failed\n", s);
     b62:	85da                	mv	a1,s6
     b64:	00005517          	auipc	a0,0x5
     b68:	71450513          	addi	a0,a0,1812 # 6278 <malloc+0x60c>
     b6c:	048050ef          	jal	5bb4 <printf>
    exit(1);
     b70:	4505                	li	a0,1
     b72:	401040ef          	jal	5772 <exit>

0000000000000b76 <unlinkread>:
{
     b76:	7179                	addi	sp,sp,-48
     b78:	f406                	sd	ra,40(sp)
     b7a:	f022                	sd	s0,32(sp)
     b7c:	ec26                	sd	s1,24(sp)
     b7e:	e84a                	sd	s2,16(sp)
     b80:	e44e                	sd	s3,8(sp)
     b82:	1800                	addi	s0,sp,48
     b84:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b86:	20200593          	li	a1,514
     b8a:	00005517          	auipc	a0,0x5
     b8e:	70650513          	addi	a0,a0,1798 # 6290 <malloc+0x624>
     b92:	421040ef          	jal	57b2 <open>
  if (fd < 0) {
     b96:	0a054f63          	bltz	a0,c54 <unlinkread+0xde>
     b9a:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9c:	4615                	li	a2,5
     b9e:	00005597          	auipc	a1,0x5
     ba2:	72258593          	addi	a1,a1,1826 # 62c0 <malloc+0x654>
     ba6:	3ed040ef          	jal	5792 <write>
  close(fd);
     baa:	8526                	mv	a0,s1
     bac:	3ef040ef          	jal	579a <close>
  fd = open("unlinkread", O_RDWR);
     bb0:	4589                	li	a1,2
     bb2:	00005517          	auipc	a0,0x5
     bb6:	6de50513          	addi	a0,a0,1758 # 6290 <malloc+0x624>
     bba:	3f9040ef          	jal	57b2 <open>
     bbe:	84aa                	mv	s1,a0
  if (fd < 0) {
     bc0:	0a054463          	bltz	a0,c68 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc4:	00005517          	auipc	a0,0x5
     bc8:	6cc50513          	addi	a0,a0,1740 # 6290 <malloc+0x624>
     bcc:	3f7040ef          	jal	57c2 <unlink>
     bd0:	e555                	bnez	a0,c7c <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd2:	20200593          	li	a1,514
     bd6:	00005517          	auipc	a0,0x5
     bda:	6ba50513          	addi	a0,a0,1722 # 6290 <malloc+0x624>
     bde:	3d5040ef          	jal	57b2 <open>
     be2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be4:	460d                	li	a2,3
     be6:	00005597          	auipc	a1,0x5
     bea:	72258593          	addi	a1,a1,1826 # 6308 <malloc+0x69c>
     bee:	3a5040ef          	jal	5792 <write>
  close(fd1);
     bf2:	854a                	mv	a0,s2
     bf4:	3a7040ef          	jal	579a <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf8:	660d                	lui	a2,0x3
     bfa:	0000c597          	auipc	a1,0xc
     bfe:	0fe58593          	addi	a1,a1,254 # ccf8 <buf>
     c02:	8526                	mv	a0,s1
     c04:	387040ef          	jal	578a <read>
     c08:	4795                	li	a5,5
     c0a:	08f51363          	bne	a0,a5,c90 <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0e:	0000c717          	auipc	a4,0xc
     c12:	0ea74703          	lbu	a4,234(a4) # ccf8 <buf>
     c16:	06800793          	li	a5,104
     c1a:	08f71563          	bne	a4,a5,ca4 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1e:	4629                	li	a2,10
     c20:	0000c597          	auipc	a1,0xc
     c24:	0d858593          	addi	a1,a1,216 # ccf8 <buf>
     c28:	8526                	mv	a0,s1
     c2a:	369040ef          	jal	5792 <write>
     c2e:	47a9                	li	a5,10
     c30:	08f51463          	bne	a0,a5,cb8 <unlinkread+0x142>
  close(fd);
     c34:	8526                	mv	a0,s1
     c36:	365040ef          	jal	579a <close>
  unlink("unlinkread");
     c3a:	00005517          	auipc	a0,0x5
     c3e:	65650513          	addi	a0,a0,1622 # 6290 <malloc+0x624>
     c42:	381040ef          	jal	57c2 <unlink>
}
     c46:	70a2                	ld	ra,40(sp)
     c48:	7402                	ld	s0,32(sp)
     c4a:	64e2                	ld	s1,24(sp)
     c4c:	6942                	ld	s2,16(sp)
     c4e:	69a2                	ld	s3,8(sp)
     c50:	6145                	addi	sp,sp,48
     c52:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c54:	85ce                	mv	a1,s3
     c56:	00005517          	auipc	a0,0x5
     c5a:	64a50513          	addi	a0,a0,1610 # 62a0 <malloc+0x634>
     c5e:	757040ef          	jal	5bb4 <printf>
    exit(1);
     c62:	4505                	li	a0,1
     c64:	30f040ef          	jal	5772 <exit>
    printf("%s: open unlinkread failed\n", s);
     c68:	85ce                	mv	a1,s3
     c6a:	00005517          	auipc	a0,0x5
     c6e:	65e50513          	addi	a0,a0,1630 # 62c8 <malloc+0x65c>
     c72:	743040ef          	jal	5bb4 <printf>
    exit(1);
     c76:	4505                	li	a0,1
     c78:	2fb040ef          	jal	5772 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7c:	85ce                	mv	a1,s3
     c7e:	00005517          	auipc	a0,0x5
     c82:	66a50513          	addi	a0,a0,1642 # 62e8 <malloc+0x67c>
     c86:	72f040ef          	jal	5bb4 <printf>
    exit(1);
     c8a:	4505                	li	a0,1
     c8c:	2e7040ef          	jal	5772 <exit>
    printf("%s: unlinkread read failed", s);
     c90:	85ce                	mv	a1,s3
     c92:	00005517          	auipc	a0,0x5
     c96:	67e50513          	addi	a0,a0,1662 # 6310 <malloc+0x6a4>
     c9a:	71b040ef          	jal	5bb4 <printf>
    exit(1);
     c9e:	4505                	li	a0,1
     ca0:	2d3040ef          	jal	5772 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca4:	85ce                	mv	a1,s3
     ca6:	00005517          	auipc	a0,0x5
     caa:	68a50513          	addi	a0,a0,1674 # 6330 <malloc+0x6c4>
     cae:	707040ef          	jal	5bb4 <printf>
    exit(1);
     cb2:	4505                	li	a0,1
     cb4:	2bf040ef          	jal	5772 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb8:	85ce                	mv	a1,s3
     cba:	00005517          	auipc	a0,0x5
     cbe:	69650513          	addi	a0,a0,1686 # 6350 <malloc+0x6e4>
     cc2:	6f3040ef          	jal	5bb4 <printf>
    exit(1);
     cc6:	4505                	li	a0,1
     cc8:	2ab040ef          	jal	5772 <exit>

0000000000000ccc <linktest>:
{
     ccc:	1101                	addi	sp,sp,-32
     cce:	ec06                	sd	ra,24(sp)
     cd0:	e822                	sd	s0,16(sp)
     cd2:	e426                	sd	s1,8(sp)
     cd4:	e04a                	sd	s2,0(sp)
     cd6:	1000                	addi	s0,sp,32
     cd8:	892a                	mv	s2,a0
  unlink("lf1");
     cda:	00005517          	auipc	a0,0x5
     cde:	69650513          	addi	a0,a0,1686 # 6370 <malloc+0x704>
     ce2:	2e1040ef          	jal	57c2 <unlink>
  unlink("lf2");
     ce6:	00005517          	auipc	a0,0x5
     cea:	69250513          	addi	a0,a0,1682 # 6378 <malloc+0x70c>
     cee:	2d5040ef          	jal	57c2 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf2:	20200593          	li	a1,514
     cf6:	00005517          	auipc	a0,0x5
     cfa:	67a50513          	addi	a0,a0,1658 # 6370 <malloc+0x704>
     cfe:	2b5040ef          	jal	57b2 <open>
  if (fd < 0) {
     d02:	0c054f63          	bltz	a0,de0 <linktest+0x114>
     d06:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d08:	4615                	li	a2,5
     d0a:	00005597          	auipc	a1,0x5
     d0e:	5b658593          	addi	a1,a1,1462 # 62c0 <malloc+0x654>
     d12:	281040ef          	jal	5792 <write>
     d16:	4795                	li	a5,5
     d18:	0cf51e63          	bne	a0,a5,df4 <linktest+0x128>
  close(fd);
     d1c:	8526                	mv	a0,s1
     d1e:	27d040ef          	jal	579a <close>
  if (link("lf1", "lf2") < 0) {
     d22:	00005597          	auipc	a1,0x5
     d26:	65658593          	addi	a1,a1,1622 # 6378 <malloc+0x70c>
     d2a:	00005517          	auipc	a0,0x5
     d2e:	64650513          	addi	a0,a0,1606 # 6370 <malloc+0x704>
     d32:	2a1040ef          	jal	57d2 <link>
     d36:	0c054963          	bltz	a0,e08 <linktest+0x13c>
  unlink("lf1");
     d3a:	00005517          	auipc	a0,0x5
     d3e:	63650513          	addi	a0,a0,1590 # 6370 <malloc+0x704>
     d42:	281040ef          	jal	57c2 <unlink>
  if (open("lf1", 0) >= 0) {
     d46:	4581                	li	a1,0
     d48:	00005517          	auipc	a0,0x5
     d4c:	62850513          	addi	a0,a0,1576 # 6370 <malloc+0x704>
     d50:	263040ef          	jal	57b2 <open>
     d54:	0c055463          	bgez	a0,e1c <linktest+0x150>
  fd = open("lf2", 0);
     d58:	4581                	li	a1,0
     d5a:	00005517          	auipc	a0,0x5
     d5e:	61e50513          	addi	a0,a0,1566 # 6378 <malloc+0x70c>
     d62:	251040ef          	jal	57b2 <open>
     d66:	84aa                	mv	s1,a0
  if (fd < 0) {
     d68:	0c054463          	bltz	a0,e30 <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6c:	660d                	lui	a2,0x3
     d6e:	0000c597          	auipc	a1,0xc
     d72:	f8a58593          	addi	a1,a1,-118 # ccf8 <buf>
     d76:	215040ef          	jal	578a <read>
     d7a:	4795                	li	a5,5
     d7c:	0cf51463          	bne	a0,a5,e44 <linktest+0x178>
  close(fd);
     d80:	8526                	mv	a0,s1
     d82:	219040ef          	jal	579a <close>
  if (link("lf2", "lf2") >= 0) {
     d86:	00005597          	auipc	a1,0x5
     d8a:	5f258593          	addi	a1,a1,1522 # 6378 <malloc+0x70c>
     d8e:	852e                	mv	a0,a1
     d90:	243040ef          	jal	57d2 <link>
     d94:	0c055263          	bgez	a0,e58 <linktest+0x18c>
  unlink("lf2");
     d98:	00005517          	auipc	a0,0x5
     d9c:	5e050513          	addi	a0,a0,1504 # 6378 <malloc+0x70c>
     da0:	223040ef          	jal	57c2 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da4:	00005597          	auipc	a1,0x5
     da8:	5cc58593          	addi	a1,a1,1484 # 6370 <malloc+0x704>
     dac:	00005517          	auipc	a0,0x5
     db0:	5cc50513          	addi	a0,a0,1484 # 6378 <malloc+0x70c>
     db4:	21f040ef          	jal	57d2 <link>
     db8:	0a055a63          	bgez	a0,e6c <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dbc:	00005597          	auipc	a1,0x5
     dc0:	5b458593          	addi	a1,a1,1460 # 6370 <malloc+0x704>
     dc4:	00005517          	auipc	a0,0x5
     dc8:	6bc50513          	addi	a0,a0,1724 # 6480 <malloc+0x814>
     dcc:	207040ef          	jal	57d2 <link>
     dd0:	0a055863          	bgez	a0,e80 <linktest+0x1b4>
}
     dd4:	60e2                	ld	ra,24(sp)
     dd6:	6442                	ld	s0,16(sp)
     dd8:	64a2                	ld	s1,8(sp)
     dda:	6902                	ld	s2,0(sp)
     ddc:	6105                	addi	sp,sp,32
     dde:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     de0:	85ca                	mv	a1,s2
     de2:	00005517          	auipc	a0,0x5
     de6:	59e50513          	addi	a0,a0,1438 # 6380 <malloc+0x714>
     dea:	5cb040ef          	jal	5bb4 <printf>
    exit(1);
     dee:	4505                	li	a0,1
     df0:	183040ef          	jal	5772 <exit>
    printf("%s: write lf1 failed\n", s);
     df4:	85ca                	mv	a1,s2
     df6:	00005517          	auipc	a0,0x5
     dfa:	5a250513          	addi	a0,a0,1442 # 6398 <malloc+0x72c>
     dfe:	5b7040ef          	jal	5bb4 <printf>
    exit(1);
     e02:	4505                	li	a0,1
     e04:	16f040ef          	jal	5772 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e08:	85ca                	mv	a1,s2
     e0a:	00005517          	auipc	a0,0x5
     e0e:	5a650513          	addi	a0,a0,1446 # 63b0 <malloc+0x744>
     e12:	5a3040ef          	jal	5bb4 <printf>
    exit(1);
     e16:	4505                	li	a0,1
     e18:	15b040ef          	jal	5772 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1c:	85ca                	mv	a1,s2
     e1e:	00005517          	auipc	a0,0x5
     e22:	5b250513          	addi	a0,a0,1458 # 63d0 <malloc+0x764>
     e26:	58f040ef          	jal	5bb4 <printf>
    exit(1);
     e2a:	4505                	li	a0,1
     e2c:	147040ef          	jal	5772 <exit>
    printf("%s: open lf2 failed\n", s);
     e30:	85ca                	mv	a1,s2
     e32:	00005517          	auipc	a0,0x5
     e36:	5ce50513          	addi	a0,a0,1486 # 6400 <malloc+0x794>
     e3a:	57b040ef          	jal	5bb4 <printf>
    exit(1);
     e3e:	4505                	li	a0,1
     e40:	133040ef          	jal	5772 <exit>
    printf("%s: read lf2 failed\n", s);
     e44:	85ca                	mv	a1,s2
     e46:	00005517          	auipc	a0,0x5
     e4a:	5d250513          	addi	a0,a0,1490 # 6418 <malloc+0x7ac>
     e4e:	567040ef          	jal	5bb4 <printf>
    exit(1);
     e52:	4505                	li	a0,1
     e54:	11f040ef          	jal	5772 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e58:	85ca                	mv	a1,s2
     e5a:	00005517          	auipc	a0,0x5
     e5e:	5d650513          	addi	a0,a0,1494 # 6430 <malloc+0x7c4>
     e62:	553040ef          	jal	5bb4 <printf>
    exit(1);
     e66:	4505                	li	a0,1
     e68:	10b040ef          	jal	5772 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6c:	85ca                	mv	a1,s2
     e6e:	00005517          	auipc	a0,0x5
     e72:	5ea50513          	addi	a0,a0,1514 # 6458 <malloc+0x7ec>
     e76:	53f040ef          	jal	5bb4 <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	0f7040ef          	jal	5772 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e80:	85ca                	mv	a1,s2
     e82:	00005517          	auipc	a0,0x5
     e86:	60650513          	addi	a0,a0,1542 # 6488 <malloc+0x81c>
     e8a:	52b040ef          	jal	5bb4 <printf>
    exit(1);
     e8e:	4505                	li	a0,1
     e90:	0e3040ef          	jal	5772 <exit>

0000000000000e94 <validatetest>:
{
     e94:	7139                	addi	sp,sp,-64
     e96:	fc06                	sd	ra,56(sp)
     e98:	f822                	sd	s0,48(sp)
     e9a:	f426                	sd	s1,40(sp)
     e9c:	f04a                	sd	s2,32(sp)
     e9e:	ec4e                	sd	s3,24(sp)
     ea0:	e852                	sd	s4,16(sp)
     ea2:	e456                	sd	s5,8(sp)
     ea4:	e05a                	sd	s6,0(sp)
     ea6:	0080                	addi	s0,sp,64
     ea8:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eaa:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eac:	00005997          	auipc	s3,0x5
     eb0:	5fc98993          	addi	s3,s3,1532 # 64a8 <malloc+0x83c>
     eb4:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb6:	6a85                	lui	s5,0x1
     eb8:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     ebc:	85a6                	mv	a1,s1
     ebe:	854e                	mv	a0,s3
     ec0:	113040ef          	jal	57d2 <link>
     ec4:	01251f63          	bne	a0,s2,ee2 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec8:	94d6                	add	s1,s1,s5
     eca:	ff4499e3          	bne	s1,s4,ebc <validatetest+0x28>
}
     ece:	70e2                	ld	ra,56(sp)
     ed0:	7442                	ld	s0,48(sp)
     ed2:	74a2                	ld	s1,40(sp)
     ed4:	7902                	ld	s2,32(sp)
     ed6:	69e2                	ld	s3,24(sp)
     ed8:	6a42                	ld	s4,16(sp)
     eda:	6aa2                	ld	s5,8(sp)
     edc:	6b02                	ld	s6,0(sp)
     ede:	6121                	addi	sp,sp,64
     ee0:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee2:	85da                	mv	a1,s6
     ee4:	00005517          	auipc	a0,0x5
     ee8:	5d450513          	addi	a0,a0,1492 # 64b8 <malloc+0x84c>
     eec:	4c9040ef          	jal	5bb4 <printf>
      exit(1);
     ef0:	4505                	li	a0,1
     ef2:	081040ef          	jal	5772 <exit>

0000000000000ef6 <bigdir>:
{
     ef6:	711d                	addi	sp,sp,-96
     ef8:	ec86                	sd	ra,88(sp)
     efa:	e8a2                	sd	s0,80(sp)
     efc:	e4a6                	sd	s1,72(sp)
     efe:	e0ca                	sd	s2,64(sp)
     f00:	fc4e                	sd	s3,56(sp)
     f02:	f852                	sd	s4,48(sp)
     f04:	f456                	sd	s5,40(sp)
     f06:	f05a                	sd	s6,32(sp)
     f08:	ec5e                	sd	s7,24(sp)
     f0a:	1080                	addi	s0,sp,96
     f0c:	89aa                	mv	s3,a0
  unlink("bd");
     f0e:	00005517          	auipc	a0,0x5
     f12:	5ca50513          	addi	a0,a0,1482 # 64d8 <malloc+0x86c>
     f16:	0ad040ef          	jal	57c2 <unlink>
  fd = open("bd", O_CREATE);
     f1a:	20000593          	li	a1,512
     f1e:	00005517          	auipc	a0,0x5
     f22:	5ba50513          	addi	a0,a0,1466 # 64d8 <malloc+0x86c>
     f26:	08d040ef          	jal	57b2 <open>
  if (fd < 0) {
     f2a:	0c054463          	bltz	a0,ff2 <bigdir+0xfc>
  close(fd);
     f2e:	06d040ef          	jal	579a <close>
  for (i = 0; i < N; i++) {
     f32:	4901                	li	s2,0
    name[0] = 'x';
     f34:	07800b13          	li	s6,120
    if (link("bd", name) != 0) {
     f38:	fa040a93          	addi	s5,s0,-96
     f3c:	00005a17          	auipc	s4,0x5
     f40:	59ca0a13          	addi	s4,s4,1436 # 64d8 <malloc+0x86c>
  for (i = 0; i < N; i++) {
     f44:	1f400b93          	li	s7,500
    name[0] = 'x';
     f48:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
     f4c:	41f9571b          	sraiw	a4,s2,0x1f
     f50:	01a7571b          	srliw	a4,a4,0x1a
     f54:	012707bb          	addw	a5,a4,s2
     f58:	4067d69b          	sraiw	a3,a5,0x6
     f5c:	0306869b          	addiw	a3,a3,48
     f60:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f64:	03f7f793          	andi	a5,a5,63
     f68:	9f99                	subw	a5,a5,a4
     f6a:	0307879b          	addiw	a5,a5,48
     f6e:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f72:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f76:	85d6                	mv	a1,s5
     f78:	8552                	mv	a0,s4
     f7a:	059040ef          	jal	57d2 <link>
     f7e:	84aa                	mv	s1,a0
     f80:	e159                	bnez	a0,1006 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f82:	2905                	addiw	s2,s2,1
     f84:	fd7912e3          	bne	s2,s7,f48 <bigdir+0x52>
  unlink("bd");
     f88:	00005517          	auipc	a0,0x5
     f8c:	55050513          	addi	a0,a0,1360 # 64d8 <malloc+0x86c>
     f90:	033040ef          	jal	57c2 <unlink>
    name[0] = 'x';
     f94:	07800a13          	li	s4,120
    if (unlink(name) != 0) {
     f98:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9c:	1f400a93          	li	s5,500
    name[0] = 'x';
     fa0:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
     fa4:	41f4d71b          	sraiw	a4,s1,0x1f
     fa8:	01a7571b          	srliw	a4,a4,0x1a
     fac:	009707bb          	addw	a5,a4,s1
     fb0:	4067d69b          	sraiw	a3,a5,0x6
     fb4:	0306869b          	addiw	a3,a3,48
     fb8:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fbc:	03f7f793          	andi	a5,a5,63
     fc0:	9f99                	subw	a5,a5,a4
     fc2:	0307879b          	addiw	a5,a5,48
     fc6:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fca:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fce:	854a                	mv	a0,s2
     fd0:	7f2040ef          	jal	57c2 <unlink>
     fd4:	e531                	bnez	a0,1020 <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd6:	2485                	addiw	s1,s1,1
     fd8:	fd5494e3          	bne	s1,s5,fa0 <bigdir+0xaa>
}
     fdc:	60e6                	ld	ra,88(sp)
     fde:	6446                	ld	s0,80(sp)
     fe0:	64a6                	ld	s1,72(sp)
     fe2:	6906                	ld	s2,64(sp)
     fe4:	79e2                	ld	s3,56(sp)
     fe6:	7a42                	ld	s4,48(sp)
     fe8:	7aa2                	ld	s5,40(sp)
     fea:	7b02                	ld	s6,32(sp)
     fec:	6be2                	ld	s7,24(sp)
     fee:	6125                	addi	sp,sp,96
     ff0:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff2:	85ce                	mv	a1,s3
     ff4:	00005517          	auipc	a0,0x5
     ff8:	4ec50513          	addi	a0,a0,1260 # 64e0 <malloc+0x874>
     ffc:	3b9040ef          	jal	5bb4 <printf>
    exit(1);
    1000:	4505                	li	a0,1
    1002:	770040ef          	jal	5772 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1006:	fa040693          	addi	a3,s0,-96
    100a:	864a                	mv	a2,s2
    100c:	85ce                	mv	a1,s3
    100e:	00005517          	auipc	a0,0x5
    1012:	4f250513          	addi	a0,a0,1266 # 6500 <malloc+0x894>
    1016:	39f040ef          	jal	5bb4 <printf>
      exit(1);
    101a:	4505                	li	a0,1
    101c:	756040ef          	jal	5772 <exit>
      printf("%s: bigdir unlink failed", s);
    1020:	85ce                	mv	a1,s3
    1022:	00005517          	auipc	a0,0x5
    1026:	50650513          	addi	a0,a0,1286 # 6528 <malloc+0x8bc>
    102a:	38b040ef          	jal	5bb4 <printf>
      exit(1);
    102e:	4505                	li	a0,1
    1030:	742040ef          	jal	5772 <exit>

0000000000001034 <pgbug>:
{
    1034:	7179                	addi	sp,sp,-48
    1036:	f406                	sd	ra,40(sp)
    1038:	f022                	sd	s0,32(sp)
    103a:	ec26                	sd	s1,24(sp)
    103c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1042:	00008497          	auipc	s1,0x8
    1046:	fbe48493          	addi	s1,s1,-66 # 9000 <big>
    104a:	fd840593          	addi	a1,s0,-40
    104e:	6088                	ld	a0,0(s1)
    1050:	75a040ef          	jal	57aa <exec>
  pipe(big);
    1054:	6088                	ld	a0,0(s1)
    1056:	72c040ef          	jal	5782 <pipe>
  exit(0);
    105a:	4501                	li	a0,0
    105c:	716040ef          	jal	5772 <exit>

0000000000001060 <badarg>:
{
    1060:	7139                	addi	sp,sp,-64
    1062:	fc06                	sd	ra,56(sp)
    1064:	f822                	sd	s0,48(sp)
    1066:	f426                	sd	s1,40(sp)
    1068:	f04a                	sd	s2,32(sp)
    106a:	ec4e                	sd	s3,24(sp)
    106c:	e852                	sd	s4,16(sp)
    106e:	0080                	addi	s0,sp,64
    1070:	64b1                	lui	s1,0xc
    1072:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1d68>
    argv[0] = (char *)0xffffffff;
    1076:	597d                	li	s2,-1
    1078:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107c:	fc040a13          	addi	s4,s0,-64
    1080:	00005997          	auipc	s3,0x5
    1084:	d1898993          	addi	s3,s3,-744 # 5d98 <malloc+0x12c>
    argv[0] = (char *)0xffffffff;
    1088:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108c:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1090:	85d2                	mv	a1,s4
    1092:	854e                	mv	a0,s3
    1094:	716040ef          	jal	57aa <exec>
  for (int i = 0; i < 50000; i++) {
    1098:	34fd                	addiw	s1,s1,-1
    109a:	f4fd                	bnez	s1,1088 <badarg+0x28>
  exit(0);
    109c:	4501                	li	a0,0
    109e:	6d4040ef          	jal	5772 <exit>

00000000000010a2 <copyinstr2>:
{
    10a2:	7155                	addi	sp,sp,-208
    10a4:	e586                	sd	ra,200(sp)
    10a6:	e1a2                	sd	s0,192(sp)
    10a8:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10aa:	f6840793          	addi	a5,s0,-152
    10ae:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b2:	07800713          	li	a4,120
    10b6:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10ba:	0785                	addi	a5,a5,1
    10bc:	fed79de3          	bne	a5,a3,10b6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10c0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c4:	f6840513          	addi	a0,s0,-152
    10c8:	6fa040ef          	jal	57c2 <unlink>
  if (ret != -1) {
    10cc:	57fd                	li	a5,-1
    10ce:	0cf51263          	bne	a0,a5,1192 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d2:	20100593          	li	a1,513
    10d6:	f6840513          	addi	a0,s0,-152
    10da:	6d8040ef          	jal	57b2 <open>
  if (fd != -1) {
    10de:	57fd                	li	a5,-1
    10e0:	0cf51563          	bne	a0,a5,11aa <copyinstr2+0x108>
  ret = link(b, b);
    10e4:	f6840513          	addi	a0,s0,-152
    10e8:	85aa                	mv	a1,a0
    10ea:	6e8040ef          	jal	57d2 <link>
  if (ret != -1) {
    10ee:	57fd                	li	a5,-1
    10f0:	0cf51963          	bne	a0,a5,11c2 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f4:	00006797          	auipc	a5,0x6
    10f8:	51c78793          	addi	a5,a5,1308 # 7610 <malloc+0x19a4>
    10fc:	f4f43c23          	sd	a5,-168(s0)
    1100:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1104:	f5840593          	addi	a1,s0,-168
    1108:	f6840513          	addi	a0,s0,-152
    110c:	69e040ef          	jal	57aa <exec>
  if (ret != -1) {
    1110:	57fd                	li	a5,-1
    1112:	0cf51563          	bne	a0,a5,11dc <copyinstr2+0x13a>
  int pid = fork();
    1116:	654040ef          	jal	576a <fork>
  if (pid < 0) {
    111a:	0c054d63          	bltz	a0,11f4 <copyinstr2+0x152>
  if (pid == 0) {
    111e:	0e051863          	bnez	a0,120e <copyinstr2+0x16c>
    1122:	00008797          	auipc	a5,0x8
    1126:	4be78793          	addi	a5,a5,1214 # 95e0 <big.0>
    112a:	00009697          	auipc	a3,0x9
    112e:	4b668693          	addi	a3,a3,1206 # a5e0 <big.0+0x1000>
      big[i] = 'x';
    1132:	07800713          	li	a4,120
    1136:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    113a:	0785                	addi	a5,a5,1
    113c:	fed79de3          	bne	a5,a3,1136 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    1140:	00009797          	auipc	a5,0x9
    1144:	4a078023          	sb	zero,1184(a5) # a5e0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1148:	00007797          	auipc	a5,0x7
    114c:	54878793          	addi	a5,a5,1352 # 8690 <malloc+0x2a24>
    1150:	6fb0                	ld	a2,88(a5)
    1152:	73b4                	ld	a3,96(a5)
    1154:	77b8                	ld	a4,104(a5)
    1156:	7bbc                	ld	a5,112(a5)
    1158:	f2c43823          	sd	a2,-208(s0)
    115c:	f2d43c23          	sd	a3,-200(s0)
    1160:	f4e43023          	sd	a4,-192(s0)
    1164:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1168:	f3040593          	addi	a1,s0,-208
    116c:	00005517          	auipc	a0,0x5
    1170:	c2c50513          	addi	a0,a0,-980 # 5d98 <malloc+0x12c>
    1174:	636040ef          	jal	57aa <exec>
    if (ret != -1) {
    1178:	57fd                	li	a5,-1
    117a:	08f50663          	beq	a0,a5,1206 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117e:	85be                	mv	a1,a5
    1180:	00005517          	auipc	a0,0x5
    1184:	45050513          	addi	a0,a0,1104 # 65d0 <malloc+0x964>
    1188:	22d040ef          	jal	5bb4 <printf>
      exit(1);
    118c:	4505                	li	a0,1
    118e:	5e4040ef          	jal	5772 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1192:	862a                	mv	a2,a0
    1194:	f6840593          	addi	a1,s0,-152
    1198:	00005517          	auipc	a0,0x5
    119c:	3b050513          	addi	a0,a0,944 # 6548 <malloc+0x8dc>
    11a0:	215040ef          	jal	5bb4 <printf>
    exit(1);
    11a4:	4505                	li	a0,1
    11a6:	5cc040ef          	jal	5772 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11aa:	862a                	mv	a2,a0
    11ac:	f6840593          	addi	a1,s0,-152
    11b0:	00005517          	auipc	a0,0x5
    11b4:	3b850513          	addi	a0,a0,952 # 6568 <malloc+0x8fc>
    11b8:	1fd040ef          	jal	5bb4 <printf>
    exit(1);
    11bc:	4505                	li	a0,1
    11be:	5b4040ef          	jal	5772 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c2:	f6840593          	addi	a1,s0,-152
    11c6:	86aa                	mv	a3,a0
    11c8:	862e                	mv	a2,a1
    11ca:	00005517          	auipc	a0,0x5
    11ce:	3be50513          	addi	a0,a0,958 # 6588 <malloc+0x91c>
    11d2:	1e3040ef          	jal	5bb4 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	59a040ef          	jal	5772 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11dc:	863e                	mv	a2,a5
    11de:	f6840593          	addi	a1,s0,-152
    11e2:	00005517          	auipc	a0,0x5
    11e6:	3ce50513          	addi	a0,a0,974 # 65b0 <malloc+0x944>
    11ea:	1cb040ef          	jal	5bb4 <printf>
    exit(1);
    11ee:	4505                	li	a0,1
    11f0:	582040ef          	jal	5772 <exit>
    printf("fork failed\n");
    11f4:	00007517          	auipc	a0,0x7
    11f8:	b2450513          	addi	a0,a0,-1244 # 7d18 <malloc+0x20ac>
    11fc:	1b9040ef          	jal	5bb4 <printf>
    exit(1);
    1200:	4505                	li	a0,1
    1202:	570040ef          	jal	5772 <exit>
    exit(747); // OK
    1206:	2eb00513          	li	a0,747
    120a:	568040ef          	jal	5772 <exit>
  int st = 0;
    120e:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1212:	f5440513          	addi	a0,s0,-172
    1216:	564040ef          	jal	577a <wait>
  if (st != 747) {
    121a:	f5442703          	lw	a4,-172(s0)
    121e:	2eb00793          	li	a5,747
    1222:	00f71663          	bne	a4,a5,122e <copyinstr2+0x18c>
}
    1226:	60ae                	ld	ra,200(sp)
    1228:	640e                	ld	s0,192(sp)
    122a:	6169                	addi	sp,sp,208
    122c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122e:	00005517          	auipc	a0,0x5
    1232:	3ca50513          	addi	a0,a0,970 # 65f8 <malloc+0x98c>
    1236:	17f040ef          	jal	5bb4 <printf>
    exit(1);
    123a:	4505                	li	a0,1
    123c:	536040ef          	jal	5772 <exit>

0000000000001240 <truncate3>:
{
    1240:	7175                	addi	sp,sp,-144
    1242:	e506                	sd	ra,136(sp)
    1244:	e122                	sd	s0,128(sp)
    1246:	ecd6                	sd	s5,88(sp)
    1248:	0900                	addi	s0,sp,144
    124a:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124c:	60100593          	li	a1,1537
    1250:	00005517          	auipc	a0,0x5
    1254:	ba050513          	addi	a0,a0,-1120 # 5df0 <malloc+0x184>
    1258:	55a040ef          	jal	57b2 <open>
    125c:	53e040ef          	jal	579a <close>
  pid = fork();
    1260:	50a040ef          	jal	576a <fork>
  if (pid < 0) {
    1264:	06054d63          	bltz	a0,12de <truncate3+0x9e>
  if (pid == 0) {
    1268:	e171                	bnez	a0,132c <truncate3+0xec>
    126a:	fca6                	sd	s1,120(sp)
    126c:	f8ca                	sd	s2,112(sp)
    126e:	f4ce                	sd	s3,104(sp)
    1270:	f0d2                	sd	s4,96(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	fc66                	sd	s9,56(sp)
    127a:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127e:	4b05                	li	s6,1
    1280:	00005997          	auipc	s3,0x5
    1284:	b7098993          	addi	s3,s3,-1168 # 5df0 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    1288:	4a29                	li	s4,10
    128a:	00005b97          	auipc	s7,0x5
    128e:	3ceb8b93          	addi	s7,s7,974 # 6658 <malloc+0x9ec>
      read(fd, buf, sizeof(buf));
    1292:	f7840c93          	addi	s9,s0,-136
    1296:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
    129a:	85da                	mv	a1,s6
    129c:	854e                	mv	a0,s3
    129e:	514040ef          	jal	57b2 <open>
    12a2:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a4:	04054f63          	bltz	a0,1302 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a8:	8652                	mv	a2,s4
    12aa:	85de                	mv	a1,s7
    12ac:	4e6040ef          	jal	5792 <write>
      if (n != 10) {
    12b0:	07451363          	bne	a0,s4,1316 <truncate3+0xd6>
      close(fd);
    12b4:	8526                	mv	a0,s1
    12b6:	4e4040ef          	jal	579a <close>
      fd = open("truncfile", O_RDONLY);
    12ba:	4581                	li	a1,0
    12bc:	854e                	mv	a0,s3
    12be:	4f4040ef          	jal	57b2 <open>
    12c2:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c4:	8662                	mv	a2,s8
    12c6:	85e6                	mv	a1,s9
    12c8:	4c2040ef          	jal	578a <read>
      close(fd);
    12cc:	8526                	mv	a0,s1
    12ce:	4cc040ef          	jal	579a <close>
    for (int i = 0; i < 100; i++) {
    12d2:	397d                	addiw	s2,s2,-1
    12d4:	fc0913e3          	bnez	s2,129a <truncate3+0x5a>
    exit(0);
    12d8:	4501                	li	a0,0
    12da:	498040ef          	jal	5772 <exit>
    12de:	fca6                	sd	s1,120(sp)
    12e0:	f8ca                	sd	s2,112(sp)
    12e2:	f4ce                	sd	s3,104(sp)
    12e4:	f0d2                	sd	s4,96(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    12ec:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
    12ee:	85d6                	mv	a1,s5
    12f0:	00005517          	auipc	a0,0x5
    12f4:	33850513          	addi	a0,a0,824 # 6628 <malloc+0x9bc>
    12f8:	0bd040ef          	jal	5bb4 <printf>
    exit(1);
    12fc:	4505                	li	a0,1
    12fe:	474040ef          	jal	5772 <exit>
        printf("%s: open failed\n", s);
    1302:	85d6                	mv	a1,s5
    1304:	00005517          	auipc	a0,0x5
    1308:	33c50513          	addi	a0,a0,828 # 6640 <malloc+0x9d4>
    130c:	0a9040ef          	jal	5bb4 <printf>
        exit(1);
    1310:	4505                	li	a0,1
    1312:	460040ef          	jal	5772 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1316:	862a                	mv	a2,a0
    1318:	85d6                	mv	a1,s5
    131a:	00005517          	auipc	a0,0x5
    131e:	34e50513          	addi	a0,a0,846 # 6668 <malloc+0x9fc>
    1322:	093040ef          	jal	5bb4 <printf>
        exit(1);
    1326:	4505                	li	a0,1
    1328:	44a040ef          	jal	5772 <exit>
    132c:	fca6                	sd	s1,120(sp)
    132e:	f8ca                	sd	s2,112(sp)
    1330:	f4ce                	sd	s3,104(sp)
    1332:	f0d2                	sd	s4,96(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	e4de                	sd	s7,72(sp)
    1338:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133c:	60100b13          	li	s6,1537
    1340:	00005a17          	auipc	s4,0x5
    1344:	ab0a0a13          	addi	s4,s4,-1360 # 5df0 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    1348:	498d                	li	s3,3
    134a:	00005b97          	auipc	s7,0x5
    134e:	33eb8b93          	addi	s7,s7,830 # 6688 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1352:	85da                	mv	a1,s6
    1354:	8552                	mv	a0,s4
    1356:	45c040ef          	jal	57b2 <open>
    135a:	84aa                	mv	s1,a0
    if (fd < 0) {
    135c:	02054e63          	bltz	a0,1398 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    1360:	864e                	mv	a2,s3
    1362:	85de                	mv	a1,s7
    1364:	42e040ef          	jal	5792 <write>
    if (n != 3) {
    1368:	05351463          	bne	a0,s3,13b0 <truncate3+0x170>
    close(fd);
    136c:	8526                	mv	a0,s1
    136e:	42c040ef          	jal	579a <close>
  for (int i = 0; i < 150; i++) {
    1372:	397d                	addiw	s2,s2,-1
    1374:	fc091fe3          	bnez	s2,1352 <truncate3+0x112>
    1378:	e0e2                	sd	s8,64(sp)
    137a:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
    137c:	f9c40513          	addi	a0,s0,-100
    1380:	3fa040ef          	jal	577a <wait>
  unlink("truncfile");
    1384:	00005517          	auipc	a0,0x5
    1388:	a6c50513          	addi	a0,a0,-1428 # 5df0 <malloc+0x184>
    138c:	436040ef          	jal	57c2 <unlink>
  exit(xstatus);
    1390:	f9c42503          	lw	a0,-100(s0)
    1394:	3de040ef          	jal	5772 <exit>
    1398:	e0e2                	sd	s8,64(sp)
    139a:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
    139c:	85d6                	mv	a1,s5
    139e:	00005517          	auipc	a0,0x5
    13a2:	2a250513          	addi	a0,a0,674 # 6640 <malloc+0x9d4>
    13a6:	00f040ef          	jal	5bb4 <printf>
      exit(1);
    13aa:	4505                	li	a0,1
    13ac:	3c6040ef          	jal	5772 <exit>
    13b0:	e0e2                	sd	s8,64(sp)
    13b2:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b4:	862a                	mv	a2,a0
    13b6:	85d6                	mv	a1,s5
    13b8:	00005517          	auipc	a0,0x5
    13bc:	2d850513          	addi	a0,a0,728 # 6690 <malloc+0xa24>
    13c0:	7f4040ef          	jal	5bb4 <printf>
      exit(1);
    13c4:	4505                	li	a0,1
    13c6:	3ac040ef          	jal	5772 <exit>

00000000000013ca <pipe1>:
{
    13ca:	711d                	addi	sp,sp,-96
    13cc:	ec86                	sd	ra,88(sp)
    13ce:	e8a2                	sd	s0,80(sp)
    13d0:	e0ca                	sd	s2,64(sp)
    13d2:	1080                	addi	s0,sp,96
    13d4:	892a                	mv	s2,a0
  if (pipe(fds) != 0) {
    13d6:	fa840513          	addi	a0,s0,-88
    13da:	3a8040ef          	jal	5782 <pipe>
    13de:	e53d                	bnez	a0,144c <pipe1+0x82>
    13e0:	e4a6                	sd	s1,72(sp)
    13e2:	f852                	sd	s4,48(sp)
    13e4:	84aa                	mv	s1,a0
  pid = fork();
    13e6:	384040ef          	jal	576a <fork>
    13ea:	8a2a                	mv	s4,a0
  if (pid == 0) {
    13ec:	c149                	beqz	a0,146e <pipe1+0xa4>
  } else if (pid > 0) {
    13ee:	14a05f63          	blez	a0,154c <pipe1+0x182>
    13f2:	fc4e                	sd	s3,56(sp)
    13f4:	f456                	sd	s5,40(sp)
    close(fds[1]);
    13f6:	fac42503          	lw	a0,-84(s0)
    13fa:	3a0040ef          	jal	579a <close>
    total = 0;
    13fe:	8a26                	mv	s4,s1
    cc = 1;
    1400:	4985                	li	s3,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1402:	0000ca97          	auipc	s5,0xc
    1406:	8f6a8a93          	addi	s5,s5,-1802 # ccf8 <buf>
    140a:	864e                	mv	a2,s3
    140c:	85d6                	mv	a1,s5
    140e:	fa842503          	lw	a0,-88(s0)
    1412:	378040ef          	jal	578a <read>
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x13e>
    141a:	0000c717          	auipc	a4,0xc
    141e:	8de70713          	addi	a4,a4,-1826 # ccf8 <buf>
    1422:	00a4863b          	addw	a2,s1,a0
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	00074683          	lbu	a3,0(a4)
    142a:	0ff4f793          	zext.b	a5,s1
    142e:	2485                	addiw	s1,s1,1
    1430:	0af69c63          	bne	a3,a5,14e8 <pipe1+0x11e>
      for (i = 0; i < n; i++) {
    1434:	0705                	addi	a4,a4,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5c>
      total += n;
    143a:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    143e:	0019999b          	slliw	s3,s3,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd37f3e3          	bgeu	a5,s3,140a <pipe1+0x40>
        cc = sizeof(buf);
    1448:	89be                	mv	s3,a5
    144a:	b7c1                	j	140a <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	fc4e                	sd	s3,56(sp)
    1450:	f852                	sd	s4,48(sp)
    1452:	f456                	sd	s5,40(sp)
    1454:	f05a                	sd	s6,32(sp)
    1456:	ec5e                	sd	s7,24(sp)
    1458:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85ca                	mv	a1,s2
    145c:	00005517          	auipc	a0,0x5
    1460:	25450513          	addi	a0,a0,596 # 66b0 <malloc+0xa44>
    1464:	750040ef          	jal	5bb4 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	308040ef          	jal	5772 <exit>
    146e:	fc4e                	sd	s3,56(sp)
    1470:	f456                	sd	s5,40(sp)
    1472:	f05a                	sd	s6,32(sp)
    1474:	ec5e                	sd	s7,24(sp)
    1476:	e862                	sd	s8,16(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	31e040ef          	jal	579a <close>
    for (n = 0; n < N; n++) {
    1480:	0000cb97          	auipc	s7,0xc
    1484:	878b8b93          	addi	s7,s7,-1928 # ccf8 <buf>
    1488:	417004bb          	negw	s1,s7
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b8993          	addi	s3,s7,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a93          	li	s5,1033
    1498:	8c5e                	mv	s8,s7
    for (n = 0; n < N; n++) {
    149a:	6b05                	lui	s6,0x1
    149c:	42db0b13          	addi	s6,s6,1069 # 142d <pipe1+0x63>
{
    14a0:	87de                	mv	a5,s7
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x494>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff379be3          	bne	a5,s3,14a2 <pipe1+0xd8>
    14b0:	409a0a1b          	addiw	s4,s4,1033
      if (write(fds[1], buf, SZ) != SZ) {
    14b4:	8656                	mv	a2,s5
    14b6:	85e2                	mv	a1,s8
    14b8:	fac42503          	lw	a0,-84(s0)
    14bc:	2d6040ef          	jal	5792 <write>
    14c0:	01551a63          	bne	a0,s5,14d4 <pipe1+0x10a>
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd6a1be3          	bne	s4,s6,14a0 <pipe1+0xd6>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	2a2040ef          	jal	5772 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85ca                	mv	a1,s2
    14d6:	00005517          	auipc	a0,0x5
    14da:	1f250513          	addi	a0,a0,498 # 66c8 <malloc+0xa5c>
    14de:	6d6040ef          	jal	5bb4 <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	28e040ef          	jal	5772 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85ca                	mv	a1,s2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	1f650513          	addi	a0,a0,502 # 66e0 <malloc+0xa74>
    14f2:	6c2040ef          	jal	5bb4 <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	79e2                	ld	s3,56(sp)
    14fa:	7a42                	ld	s4,48(sp)
    14fc:	7aa2                	ld	s5,40(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6906                	ld	s2,64(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x63>
    150e:	02fa0063          	beq	s4,a5,152e <pipe1+0x164>
    1512:	f05a                	sd	s6,32(sp)
    1514:	ec5e                	sd	s7,24(sp)
    1516:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	8652                	mv	a2,s4
    151a:	85ca                	mv	a1,s2
    151c:	00005517          	auipc	a0,0x5
    1520:	1dc50513          	addi	a0,a0,476 # 66f8 <malloc+0xa8c>
    1524:	690040ef          	jal	5bb4 <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	248040ef          	jal	5772 <exit>
    152e:	f05a                	sd	s6,32(sp)
    1530:	ec5e                	sd	s7,24(sp)
    1532:	e862                	sd	s8,16(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	262040ef          	jal	579a <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	23a040ef          	jal	577a <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	22a040ef          	jal	5772 <exit>
    154c:	fc4e                	sd	s3,56(sp)
    154e:	f456                	sd	s5,40(sp)
    1550:	f05a                	sd	s6,32(sp)
    1552:	ec5e                	sd	s7,24(sp)
    1554:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
    1556:	85ca                	mv	a1,s2
    1558:	00005517          	auipc	a0,0x5
    155c:	1c050513          	addi	a0,a0,448 # 6718 <malloc+0xaac>
    1560:	654040ef          	jal	5bb4 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	20c040ef          	jal	5772 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	1e2040ef          	jal	576a <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	1e4040ef          	jal	577a <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	06850513          	addi	a0,a0,104 # 6628 <malloc+0x9bc>
    15c8:	5ec040ef          	jal	5bb4 <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	1a4040ef          	jal	5772 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	15c50513          	addi	a0,a0,348 # 6730 <malloc+0xac4>
    15dc:	5d8040ef          	jal	5bb4 <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	190040ef          	jal	5772 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	16050513          	addi	a0,a0,352 # 6748 <malloc+0xadc>
    15f0:	5c4040ef          	jal	5bb4 <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	17c040ef          	jal	5772 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	176040ef          	jal	5772 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	158040ef          	jal	576a <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	14e040ef          	jal	576a <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	152040ef          	jal	577a <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	14c040ef          	jal	577a <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	fe450513          	addi	a0,a0,-28 # 6628 <malloc+0x9bc>
    164c:	568040ef          	jal	5bb4 <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	120040ef          	jal	5772 <exit>
      exit(0);
    1656:	11c040ef          	jal	5772 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	fcc50513          	addi	a0,a0,-52 # 6628 <malloc+0x9bc>
    1664:	550040ef          	jal	5bb4 <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	108040ef          	jal	5772 <exit>
        exit(0);
    166e:	104040ef          	jal	5772 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	0ec040ef          	jal	576a <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	0e2040ef          	jal	576a <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	0e4040ef          	jal	577a <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	0d6040ef          	jal	577a <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	0ae50513          	addi	a0,a0,174 # 6768 <malloc+0xafc>
    16c2:	4f2040ef          	jal	5bb4 <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	0aa040ef          	jal	5772 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	09a040ef          	jal	576a <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	09e040ef          	jal	577a <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	08c040ef          	jal	5772 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	086040ef          	jal	5772 <exit>
          exit(0);
    16f0:	082040ef          	jal	5772 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	08250513          	addi	a0,a0,130 # 6778 <malloc+0xb0c>
    16fe:	4b6040ef          	jal	5bb4 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	06e040ef          	jal	5772 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	054040ef          	jal	576a <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	058040ef          	jal	577a <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	046040ef          	jal	5772 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	5e850513          	addi	a0,a0,1512 # 7d18 <malloc+0x20ac>
    1738:	47c040ef          	jal	5bb4 <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	034040ef          	jal	5772 <exit>
      fork();
    1742:	028040ef          	jal	576a <fork>
      fork();
    1746:	024040ef          	jal	576a <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	026040ef          	jal	5772 <exit>

0000000000001750 <createdelete>:
{
    1750:	7175                	addi	sp,sp,-144
    1752:	e506                	sd	ra,136(sp)
    1754:	e122                	sd	s0,128(sp)
    1756:	fca6                	sd	s1,120(sp)
    1758:	f8ca                	sd	s2,112(sp)
    175a:	f4ce                	sd	s3,104(sp)
    175c:	f0d2                	sd	s4,96(sp)
    175e:	ecd6                	sd	s5,88(sp)
    1760:	e8da                	sd	s6,80(sp)
    1762:	e4de                	sd	s7,72(sp)
    1764:	e0e2                	sd	s8,64(sp)
    1766:	fc66                	sd	s9,56(sp)
    1768:	f86a                	sd	s10,48(sp)
    176a:	0900                	addi	s0,sp,144
    176c:	8d2a                	mv	s10,a0
  for (pi = 0; pi < NCHILD; pi++) {
    176e:	4901                	li	s2,0
    1770:	4991                	li	s3,4
    pid = fork();
    1772:	7f9030ef          	jal	576a <fork>
    1776:	84aa                	mv	s1,a0
    if (pid < 0) {
    1778:	02054e63          	bltz	a0,17b4 <createdelete+0x64>
    if (pid == 0) {
    177c:	c531                	beqz	a0,17c8 <createdelete+0x78>
  for (pi = 0; pi < NCHILD; pi++) {
    177e:	2905                	addiw	s2,s2,1
    1780:	ff3919e3          	bne	s2,s3,1772 <createdelete+0x22>
    1784:	4491                	li	s1,4
    wait(&xstatus);
    1786:	f7c40993          	addi	s3,s0,-132
    178a:	854e                	mv	a0,s3
    178c:	7ef030ef          	jal	577a <wait>
    if (xstatus != 0)
    1790:	f7c42903          	lw	s2,-132(s0)
    1794:	0c091063          	bnez	s2,1854 <createdelete+0x104>
  for (pi = 0; pi < NCHILD; pi++) {
    1798:	34fd                	addiw	s1,s1,-1
    179a:	f8e5                	bnez	s1,178a <createdelete+0x3a>
  name[0] = name[1] = name[2] = 0;
    179c:	f8040123          	sb	zero,-126(s0)
    17a0:	03000993          	li	s3,48
    17a4:	5afd                	li	s5,-1
    17a6:	07000c93          	li	s9,112
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17aa:	4ba5                	li	s7,9
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17ac:	4c21                	li	s8,8
    for (pi = 0; pi < NCHILD; pi++) {
    17ae:	07400b13          	li	s6,116
    17b2:	a205                	j	18d2 <createdelete+0x182>
      printf("%s: fork failed\n", s);
    17b4:	85ea                	mv	a1,s10
    17b6:	00005517          	auipc	a0,0x5
    17ba:	e7250513          	addi	a0,a0,-398 # 6628 <malloc+0x9bc>
    17be:	3f6040ef          	jal	5bb4 <printf>
      exit(1);
    17c2:	4505                	li	a0,1
    17c4:	7af030ef          	jal	5772 <exit>
      name[0] = 'p' + pi;
    17c8:	0709091b          	addiw	s2,s2,112
    17cc:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    17d0:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17d4:	f8040913          	addi	s2,s0,-128
    17d8:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17dc:	4a51                	li	s4,20
    17de:	a815                	j	1812 <createdelete+0xc2>
          printf("%s: create failed\n", s);
    17e0:	85ea                	mv	a1,s10
    17e2:	00005517          	auipc	a0,0x5
    17e6:	fb650513          	addi	a0,a0,-74 # 6798 <malloc+0xb2c>
    17ea:	3ca040ef          	jal	5bb4 <printf>
          exit(1);
    17ee:	4505                	li	a0,1
    17f0:	783030ef          	jal	5772 <exit>
          name[1] = '0' + (i / 2);
    17f4:	01f4d79b          	srliw	a5,s1,0x1f
    17f8:	9fa5                	addw	a5,a5,s1
    17fa:	4017d79b          	sraiw	a5,a5,0x1
    17fe:	0307879b          	addiw	a5,a5,48
    1802:	f8f400a3          	sb	a5,-127(s0)
          if (unlink(name) < 0) {
    1806:	854a                	mv	a0,s2
    1808:	7bb030ef          	jal	57c2 <unlink>
    180c:	02054a63          	bltz	a0,1840 <createdelete+0xf0>
      for (i = 0; i < N; i++) {
    1810:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1812:	0304879b          	addiw	a5,s1,48
    1816:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    181a:	85ce                	mv	a1,s3
    181c:	854a                	mv	a0,s2
    181e:	795030ef          	jal	57b2 <open>
        if (fd < 0) {
    1822:	fa054fe3          	bltz	a0,17e0 <createdelete+0x90>
        close(fd);
    1826:	775030ef          	jal	579a <close>
        if (i > 0 && (i % 2) == 0) {
    182a:	fe9053e3          	blez	s1,1810 <createdelete+0xc0>
    182e:	0014f793          	andi	a5,s1,1
    1832:	d3e9                	beqz	a5,17f4 <createdelete+0xa4>
      for (i = 0; i < N; i++) {
    1834:	2485                	addiw	s1,s1,1
    1836:	fd449ee3          	bne	s1,s4,1812 <createdelete+0xc2>
      exit(0);
    183a:	4501                	li	a0,0
    183c:	737030ef          	jal	5772 <exit>
            printf("%s: unlink failed\n", s);
    1840:	85ea                	mv	a1,s10
    1842:	00005517          	auipc	a0,0x5
    1846:	f6e50513          	addi	a0,a0,-146 # 67b0 <malloc+0xb44>
    184a:	36a040ef          	jal	5bb4 <printf>
            exit(1);
    184e:	4505                	li	a0,1
    1850:	723030ef          	jal	5772 <exit>
      exit(1);
    1854:	4505                	li	a0,1
    1856:	71d030ef          	jal	5772 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    185a:	f8040613          	addi	a2,s0,-128
    185e:	85ea                	mv	a1,s10
    1860:	00005517          	auipc	a0,0x5
    1864:	f6850513          	addi	a0,a0,-152 # 67c8 <malloc+0xb5c>
    1868:	34c040ef          	jal	5bb4 <printf>
        exit(1);
    186c:	4505                	li	a0,1
    186e:	705030ef          	jal	5772 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1872:	035c7a63          	bgeu	s8,s5,18a6 <createdelete+0x156>
      if (fd >= 0)
    1876:	02055563          	bgez	a0,18a0 <createdelete+0x150>
    for (pi = 0; pi < NCHILD; pi++) {
    187a:	2485                	addiw	s1,s1,1
    187c:	0ff4f493          	zext.b	s1,s1
    1880:	05648163          	beq	s1,s6,18c2 <createdelete+0x172>
      name[0] = 'p' + pi;
    1884:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1888:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    188c:	4581                	li	a1,0
    188e:	8552                	mv	a0,s4
    1890:	723030ef          	jal	57b2 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    1894:	00090463          	beqz	s2,189c <createdelete+0x14c>
    1898:	fd2bdde3          	bge	s7,s2,1872 <createdelete+0x122>
    189c:	fa054fe3          	bltz	a0,185a <createdelete+0x10a>
        close(fd);
    18a0:	6fb030ef          	jal	579a <close>
    18a4:	bfd9                	j	187a <createdelete+0x12a>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18a6:	fc054ae3          	bltz	a0,187a <createdelete+0x12a>
        printf("%s: oops createdelete %s did exist\n", s, name);
    18aa:	f8040613          	addi	a2,s0,-128
    18ae:	85ea                	mv	a1,s10
    18b0:	00005517          	auipc	a0,0x5
    18b4:	f4050513          	addi	a0,a0,-192 # 67f0 <malloc+0xb84>
    18b8:	2fc040ef          	jal	5bb4 <printf>
        exit(1);
    18bc:	4505                	li	a0,1
    18be:	6b5030ef          	jal	5772 <exit>
  for (i = 0; i < N; i++) {
    18c2:	2905                	addiw	s2,s2,1
    18c4:	2a85                	addiw	s5,s5,1
    18c6:	2985                	addiw	s3,s3,1
    18c8:	0ff9f993          	zext.b	s3,s3
    18cc:	47d1                	li	a5,20
    18ce:	00f90663          	beq	s2,a5,18da <createdelete+0x18a>
    for (pi = 0; pi < NCHILD; pi++) {
    18d2:	84e6                	mv	s1,s9
      fd = open(name, 0);
    18d4:	f8040a13          	addi	s4,s0,-128
    18d8:	b775                	j	1884 <createdelete+0x134>
    18da:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18de:	07000b13          	li	s6,112
      unlink(name);
    18e2:	f8040a13          	addi	s4,s0,-128
    for (pi = 0; pi < NCHILD; pi++) {
    18e6:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18ea:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18ee:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18f0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    18f4:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    18f8:	8552                	mv	a0,s4
    18fa:	6c9030ef          	jal	57c2 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    18fe:	2485                	addiw	s1,s1,1
    1900:	0ff4f493          	zext.b	s1,s1
    1904:	ff3496e3          	bne	s1,s3,18f0 <createdelete+0x1a0>
  for (i = 0; i < N; i++) {
    1908:	2905                	addiw	s2,s2,1
    190a:	0ff97913          	zext.b	s2,s2
    190e:	ff5910e3          	bne	s2,s5,18ee <createdelete+0x19e>
}
    1912:	60aa                	ld	ra,136(sp)
    1914:	640a                	ld	s0,128(sp)
    1916:	74e6                	ld	s1,120(sp)
    1918:	7946                	ld	s2,112(sp)
    191a:	79a6                	ld	s3,104(sp)
    191c:	7a06                	ld	s4,96(sp)
    191e:	6ae6                	ld	s5,88(sp)
    1920:	6b46                	ld	s6,80(sp)
    1922:	6ba6                	ld	s7,72(sp)
    1924:	6c06                	ld	s8,64(sp)
    1926:	7ce2                	ld	s9,56(sp)
    1928:	7d42                	ld	s10,48(sp)
    192a:	6149                	addi	sp,sp,144
    192c:	8082                	ret

000000000000192e <linkunlink>:
{
    192e:	711d                	addi	sp,sp,-96
    1930:	ec86                	sd	ra,88(sp)
    1932:	e8a2                	sd	s0,80(sp)
    1934:	e4a6                	sd	s1,72(sp)
    1936:	e0ca                	sd	s2,64(sp)
    1938:	fc4e                	sd	s3,56(sp)
    193a:	f852                	sd	s4,48(sp)
    193c:	f456                	sd	s5,40(sp)
    193e:	f05a                	sd	s6,32(sp)
    1940:	ec5e                	sd	s7,24(sp)
    1942:	e862                	sd	s8,16(sp)
    1944:	e466                	sd	s9,8(sp)
    1946:	e06a                	sd	s10,0(sp)
    1948:	1080                	addi	s0,sp,96
    194a:	84aa                	mv	s1,a0
  unlink("x");
    194c:	00004517          	auipc	a0,0x4
    1950:	4bc50513          	addi	a0,a0,1212 # 5e08 <malloc+0x19c>
    1954:	66f030ef          	jal	57c2 <unlink>
  pid = fork();
    1958:	613030ef          	jal	576a <fork>
  if (pid < 0) {
    195c:	04054363          	bltz	a0,19a2 <linkunlink+0x74>
    1960:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1962:	06100913          	li	s2,97
    1966:	c111                	beqz	a0,196a <linkunlink+0x3c>
    1968:	4905                	li	s2,1
    196a:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    196e:	41c65ab7          	lui	s5,0x41c65
    1972:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c55175>
    1976:	6a0d                	lui	s4,0x3
    1978:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4cd>
    if ((x % 3) == 0) {
    197c:	000ab9b7          	lui	s3,0xab
    1980:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9adb3>
    1984:	09b2                	slli	s3,s3,0xc
    1986:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    198a:	4b85                	li	s7,1
      unlink("x");
    198c:	00004b17          	auipc	s6,0x4
    1990:	47cb0b13          	addi	s6,s6,1148 # 5e08 <malloc+0x19c>
      link("cat", "x");
    1994:	00005c97          	auipc	s9,0x5
    1998:	e84c8c93          	addi	s9,s9,-380 # 6818 <malloc+0xbac>
      close(open("x", O_RDWR | O_CREATE));
    199c:	20200c13          	li	s8,514
    19a0:	a03d                	j	19ce <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    19a2:	85a6                	mv	a1,s1
    19a4:	00005517          	auipc	a0,0x5
    19a8:	c8450513          	addi	a0,a0,-892 # 6628 <malloc+0x9bc>
    19ac:	208040ef          	jal	5bb4 <printf>
    exit(1);
    19b0:	4505                	li	a0,1
    19b2:	5c1030ef          	jal	5772 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19b6:	85e2                	mv	a1,s8
    19b8:	855a                	mv	a0,s6
    19ba:	5f9030ef          	jal	57b2 <open>
    19be:	5dd030ef          	jal	579a <close>
    19c2:	a021                	j	19ca <linkunlink+0x9c>
      unlink("x");
    19c4:	855a                	mv	a0,s6
    19c6:	5fd030ef          	jal	57c2 <unlink>
  for (i = 0; i < 100; i++) {
    19ca:	34fd                	addiw	s1,s1,-1
    19cc:	c885                	beqz	s1,19fc <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    19ce:	035907bb          	mulw	a5,s2,s5
    19d2:	00fa07bb          	addw	a5,s4,a5
    19d6:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19d8:	02079713          	slli	a4,a5,0x20
    19dc:	9301                	srli	a4,a4,0x20
    19de:	03370733          	mul	a4,a4,s3
    19e2:	9305                	srli	a4,a4,0x21
    19e4:	0017169b          	slliw	a3,a4,0x1
    19e8:	9f35                	addw	a4,a4,a3
    19ea:	9f99                	subw	a5,a5,a4
    19ec:	d7e9                	beqz	a5,19b6 <linkunlink+0x88>
    } else if ((x % 3) == 1) {
    19ee:	fd779be3          	bne	a5,s7,19c4 <linkunlink+0x96>
      link("cat", "x");
    19f2:	85da                	mv	a1,s6
    19f4:	8566                	mv	a0,s9
    19f6:	5dd030ef          	jal	57d2 <link>
    19fa:	bfc1                	j	19ca <linkunlink+0x9c>
  if (pid)
    19fc:	020d0363          	beqz	s10,1a22 <linkunlink+0xf4>
    wait(0);
    1a00:	4501                	li	a0,0
    1a02:	579030ef          	jal	577a <wait>
}
    1a06:	60e6                	ld	ra,88(sp)
    1a08:	6446                	ld	s0,80(sp)
    1a0a:	64a6                	ld	s1,72(sp)
    1a0c:	6906                	ld	s2,64(sp)
    1a0e:	79e2                	ld	s3,56(sp)
    1a10:	7a42                	ld	s4,48(sp)
    1a12:	7aa2                	ld	s5,40(sp)
    1a14:	7b02                	ld	s6,32(sp)
    1a16:	6be2                	ld	s7,24(sp)
    1a18:	6c42                	ld	s8,16(sp)
    1a1a:	6ca2                	ld	s9,8(sp)
    1a1c:	6d02                	ld	s10,0(sp)
    1a1e:	6125                	addi	sp,sp,96
    1a20:	8082                	ret
    exit(0);
    1a22:	4501                	li	a0,0
    1a24:	54f030ef          	jal	5772 <exit>

0000000000001a28 <forktest>:
{
    1a28:	7179                	addi	sp,sp,-48
    1a2a:	f406                	sd	ra,40(sp)
    1a2c:	f022                	sd	s0,32(sp)
    1a2e:	ec26                	sd	s1,24(sp)
    1a30:	e84a                	sd	s2,16(sp)
    1a32:	e44e                	sd	s3,8(sp)
    1a34:	1800                	addi	s0,sp,48
    1a36:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a38:	4481                	li	s1,0
    1a3a:	3e800913          	li	s2,1000
    pid = fork();
    1a3e:	52d030ef          	jal	576a <fork>
    if (pid < 0)
    1a42:	06054063          	bltz	a0,1aa2 <forktest+0x7a>
    if (pid == 0)
    1a46:	cd11                	beqz	a0,1a62 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a48:	2485                	addiw	s1,s1,1
    1a4a:	ff249ae3          	bne	s1,s2,1a3e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a4e:	85ce                	mv	a1,s3
    1a50:	00005517          	auipc	a0,0x5
    1a54:	e1850513          	addi	a0,a0,-488 # 6868 <malloc+0xbfc>
    1a58:	15c040ef          	jal	5bb4 <printf>
    exit(1);
    1a5c:	4505                	li	a0,1
    1a5e:	515030ef          	jal	5772 <exit>
      exit(0);
    1a62:	511030ef          	jal	5772 <exit>
    printf("%s: no fork at all!\n", s);
    1a66:	85ce                	mv	a1,s3
    1a68:	00005517          	auipc	a0,0x5
    1a6c:	db850513          	addi	a0,a0,-584 # 6820 <malloc+0xbb4>
    1a70:	144040ef          	jal	5bb4 <printf>
    exit(1);
    1a74:	4505                	li	a0,1
    1a76:	4fd030ef          	jal	5772 <exit>
      printf("%s: wait stopped early\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	dbc50513          	addi	a0,a0,-580 # 6838 <malloc+0xbcc>
    1a84:	130040ef          	jal	5bb4 <printf>
      exit(1);
    1a88:	4505                	li	a0,1
    1a8a:	4e9030ef          	jal	5772 <exit>
    printf("%s: wait got too many\n", s);
    1a8e:	85ce                	mv	a1,s3
    1a90:	00005517          	auipc	a0,0x5
    1a94:	dc050513          	addi	a0,a0,-576 # 6850 <malloc+0xbe4>
    1a98:	11c040ef          	jal	5bb4 <printf>
    exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	4d5030ef          	jal	5772 <exit>
  if (n == 0) {
    1aa2:	d0f1                	beqz	s1,1a66 <forktest+0x3e>
    if (wait(0) < 0) {
    1aa4:	4501                	li	a0,0
    1aa6:	4d5030ef          	jal	577a <wait>
    1aaa:	fc0548e3          	bltz	a0,1a7a <forktest+0x52>
  for (; n > 0; n--) {
    1aae:	34fd                	addiw	s1,s1,-1
    1ab0:	fe904ae3          	bgtz	s1,1aa4 <forktest+0x7c>
  if (wait(0) != -1) {
    1ab4:	4501                	li	a0,0
    1ab6:	4c5030ef          	jal	577a <wait>
    1aba:	57fd                	li	a5,-1
    1abc:	fcf519e3          	bne	a0,a5,1a8e <forktest+0x66>
}
    1ac0:	70a2                	ld	ra,40(sp)
    1ac2:	7402                	ld	s0,32(sp)
    1ac4:	64e2                	ld	s1,24(sp)
    1ac6:	6942                	ld	s2,16(sp)
    1ac8:	69a2                	ld	s3,8(sp)
    1aca:	6145                	addi	sp,sp,48
    1acc:	8082                	ret

0000000000001ace <kernmem>:
{
    1ace:	715d                	addi	sp,sp,-80
    1ad0:	e486                	sd	ra,72(sp)
    1ad2:	e0a2                	sd	s0,64(sp)
    1ad4:	fc26                	sd	s1,56(sp)
    1ad6:	f84a                	sd	s2,48(sp)
    1ad8:	f44e                	sd	s3,40(sp)
    1ada:	f052                	sd	s4,32(sp)
    1adc:	ec56                	sd	s5,24(sp)
    1ade:	e85a                	sd	s6,16(sp)
    1ae0:	0880                	addi	s0,sp,80
    1ae2:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1ae4:	4485                	li	s1,1
    1ae6:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1ae8:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1aec:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1aee:	69b1                	lui	s3,0xc
    1af0:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1d68>
    1af4:	1003d937          	lui	s2,0x1003d
    1af8:	090e                	slli	s2,s2,0x3
    1afa:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d788>
    pid = fork();
    1afe:	46d030ef          	jal	576a <fork>
    if (pid < 0) {
    1b02:	02054763          	bltz	a0,1b30 <kernmem+0x62>
    if (pid == 0) {
    1b06:	cd1d                	beqz	a0,1b44 <kernmem+0x76>
    wait(&xstatus);
    1b08:	8556                	mv	a0,s5
    1b0a:	471030ef          	jal	577a <wait>
    if (xstatus != -1) // did kernel kill child?
    1b0e:	fbc42783          	lw	a5,-68(s0)
    1b12:	05479663          	bne	a5,s4,1b5e <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b16:	94ce                	add	s1,s1,s3
    1b18:	ff2493e3          	bne	s1,s2,1afe <kernmem+0x30>
}
    1b1c:	60a6                	ld	ra,72(sp)
    1b1e:	6406                	ld	s0,64(sp)
    1b20:	74e2                	ld	s1,56(sp)
    1b22:	7942                	ld	s2,48(sp)
    1b24:	79a2                	ld	s3,40(sp)
    1b26:	7a02                	ld	s4,32(sp)
    1b28:	6ae2                	ld	s5,24(sp)
    1b2a:	6b42                	ld	s6,16(sp)
    1b2c:	6161                	addi	sp,sp,80
    1b2e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b30:	85da                	mv	a1,s6
    1b32:	00005517          	auipc	a0,0x5
    1b36:	af650513          	addi	a0,a0,-1290 # 6628 <malloc+0x9bc>
    1b3a:	07a040ef          	jal	5bb4 <printf>
      exit(1);
    1b3e:	4505                	li	a0,1
    1b40:	433030ef          	jal	5772 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b44:	0004c683          	lbu	a3,0(s1)
    1b48:	8626                	mv	a2,s1
    1b4a:	85da                	mv	a1,s6
    1b4c:	00005517          	auipc	a0,0x5
    1b50:	d4450513          	addi	a0,a0,-700 # 6890 <malloc+0xc24>
    1b54:	060040ef          	jal	5bb4 <printf>
      exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	419030ef          	jal	5772 <exit>
      exit(1);
    1b5e:	4505                	li	a0,1
    1b60:	413030ef          	jal	5772 <exit>

0000000000001b64 <MAXVAplus>:
{
    1b64:	7139                	addi	sp,sp,-64
    1b66:	fc06                	sd	ra,56(sp)
    1b68:	f822                	sd	s0,48(sp)
    1b6a:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b6c:	4785                	li	a5,1
    1b6e:	179a                	slli	a5,a5,0x26
    1b70:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b74:	fc843783          	ld	a5,-56(s0)
    1b78:	cf9d                	beqz	a5,1bb6 <MAXVAplus+0x52>
    1b7a:	f426                	sd	s1,40(sp)
    1b7c:	f04a                	sd	s2,32(sp)
    1b7e:	ec4e                	sd	s3,24(sp)
    1b80:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b82:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b86:	54fd                	li	s1,-1
    pid = fork();
    1b88:	3e3030ef          	jal	576a <fork>
    if (pid < 0) {
    1b8c:	02054963          	bltz	a0,1bbe <MAXVAplus+0x5a>
    if (pid == 0) {
    1b90:	c129                	beqz	a0,1bd2 <MAXVAplus+0x6e>
    wait(&xstatus);
    1b92:	854a                	mv	a0,s2
    1b94:	3e7030ef          	jal	577a <wait>
    if (xstatus != -1) // did kernel kill child?
    1b98:	fc442783          	lw	a5,-60(s0)
    1b9c:	04979d63          	bne	a5,s1,1bf6 <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1ba0:	fc843783          	ld	a5,-56(s0)
    1ba4:	0786                	slli	a5,a5,0x1
    1ba6:	fcf43423          	sd	a5,-56(s0)
    1baa:	fc843783          	ld	a5,-56(s0)
    1bae:	ffe9                	bnez	a5,1b88 <MAXVAplus+0x24>
    1bb0:	74a2                	ld	s1,40(sp)
    1bb2:	7902                	ld	s2,32(sp)
    1bb4:	69e2                	ld	s3,24(sp)
}
    1bb6:	70e2                	ld	ra,56(sp)
    1bb8:	7442                	ld	s0,48(sp)
    1bba:	6121                	addi	sp,sp,64
    1bbc:	8082                	ret
      printf("%s: fork failed\n", s);
    1bbe:	85ce                	mv	a1,s3
    1bc0:	00005517          	auipc	a0,0x5
    1bc4:	a6850513          	addi	a0,a0,-1432 # 6628 <malloc+0x9bc>
    1bc8:	7ed030ef          	jal	5bb4 <printf>
      exit(1);
    1bcc:	4505                	li	a0,1
    1bce:	3a5030ef          	jal	5772 <exit>
      *(char *)a = 99;
    1bd2:	fc843783          	ld	a5,-56(s0)
    1bd6:	06300713          	li	a4,99
    1bda:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bde:	fc843603          	ld	a2,-56(s0)
    1be2:	85ce                	mv	a1,s3
    1be4:	00005517          	auipc	a0,0x5
    1be8:	ccc50513          	addi	a0,a0,-820 # 68b0 <malloc+0xc44>
    1bec:	7c9030ef          	jal	5bb4 <printf>
      exit(1);
    1bf0:	4505                	li	a0,1
    1bf2:	381030ef          	jal	5772 <exit>
      exit(1);
    1bf6:	4505                	li	a0,1
    1bf8:	37b030ef          	jal	5772 <exit>

0000000000001bfc <stacktest>:
{
    1bfc:	7179                	addi	sp,sp,-48
    1bfe:	f406                	sd	ra,40(sp)
    1c00:	f022                	sd	s0,32(sp)
    1c02:	ec26                	sd	s1,24(sp)
    1c04:	1800                	addi	s0,sp,48
    1c06:	84aa                	mv	s1,a0
  pid = fork();
    1c08:	363030ef          	jal	576a <fork>
  if (pid == 0) {
    1c0c:	cd11                	beqz	a0,1c28 <stacktest+0x2c>
  } else if (pid < 0) {
    1c0e:	02054c63          	bltz	a0,1c46 <stacktest+0x4a>
  wait(&xstatus);
    1c12:	fdc40513          	addi	a0,s0,-36
    1c16:	365030ef          	jal	577a <wait>
  if (xstatus == -1) // kernel killed child?
    1c1a:	fdc42503          	lw	a0,-36(s0)
    1c1e:	57fd                	li	a5,-1
    1c20:	02f50d63          	beq	a0,a5,1c5a <stacktest+0x5e>
    exit(xstatus);
    1c24:	34f030ef          	jal	5772 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c28:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c2a:	77fd                	lui	a5,0xfffff
    1c2c:	97ba                	add	a5,a5,a4
    1c2e:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef308>
    1c32:	85a6                	mv	a1,s1
    1c34:	00005517          	auipc	a0,0x5
    1c38:	c9450513          	addi	a0,a0,-876 # 68c8 <malloc+0xc5c>
    1c3c:	779030ef          	jal	5bb4 <printf>
    exit(1);
    1c40:	4505                	li	a0,1
    1c42:	331030ef          	jal	5772 <exit>
    printf("%s: fork failed\n", s);
    1c46:	85a6                	mv	a1,s1
    1c48:	00005517          	auipc	a0,0x5
    1c4c:	9e050513          	addi	a0,a0,-1568 # 6628 <malloc+0x9bc>
    1c50:	765030ef          	jal	5bb4 <printf>
    exit(1);
    1c54:	4505                	li	a0,1
    1c56:	31d030ef          	jal	5772 <exit>
    exit(0);
    1c5a:	4501                	li	a0,0
    1c5c:	317030ef          	jal	5772 <exit>

0000000000001c60 <nowrite>:
{
    1c60:	7159                	addi	sp,sp,-112
    1c62:	f486                	sd	ra,104(sp)
    1c64:	f0a2                	sd	s0,96(sp)
    1c66:	eca6                	sd	s1,88(sp)
    1c68:	e8ca                	sd	s2,80(sp)
    1c6a:	e4ce                	sd	s3,72(sp)
    1c6c:	e0d2                	sd	s4,64(sp)
    1c6e:	1880                	addi	s0,sp,112
    1c70:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c72:	00007797          	auipc	a5,0x7
    1c76:	a1e78793          	addi	a5,a5,-1506 # 8690 <malloc+0x2a24>
    1c7a:	7788                	ld	a0,40(a5)
    1c7c:	7b8c                	ld	a1,48(a5)
    1c7e:	7f90                	ld	a2,56(a5)
    1c80:	63b4                	ld	a3,64(a5)
    1c82:	67b8                	ld	a4,72(a5)
    1c84:	6bbc                	ld	a5,80(a5)
    1c86:	f8a43c23          	sd	a0,-104(s0)
    1c8a:	fab43023          	sd	a1,-96(s0)
    1c8e:	fac43423          	sd	a2,-88(s0)
    1c92:	fad43823          	sd	a3,-80(s0)
    1c96:	fae43c23          	sd	a4,-72(s0)
    1c9a:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1c9e:	4481                	li	s1,0
    wait(&xstatus);
    1ca0:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1ca4:	4999                	li	s3,6
    pid = fork();
    1ca6:	2c5030ef          	jal	576a <fork>
    if (pid == 0) {
    1caa:	cd19                	beqz	a0,1cc8 <nowrite+0x68>
    } else if (pid < 0) {
    1cac:	04054163          	bltz	a0,1cee <nowrite+0x8e>
    wait(&xstatus);
    1cb0:	854a                	mv	a0,s2
    1cb2:	2c9030ef          	jal	577a <wait>
    if (xstatus == 0) {
    1cb6:	fcc42783          	lw	a5,-52(s0)
    1cba:	c7a1                	beqz	a5,1d02 <nowrite+0xa2>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cbc:	2485                	addiw	s1,s1,1
    1cbe:	ff3494e3          	bne	s1,s3,1ca6 <nowrite+0x46>
  exit(0);
    1cc2:	4501                	li	a0,0
    1cc4:	2af030ef          	jal	5772 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cc8:	048e                	slli	s1,s1,0x3
    1cca:	fd048793          	addi	a5,s1,-48
    1cce:	008784b3          	add	s1,a5,s0
    1cd2:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1cd6:	47a9                	li	a5,10
    1cd8:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cda:	85d2                	mv	a1,s4
    1cdc:	00005517          	auipc	a0,0x5
    1ce0:	c1450513          	addi	a0,a0,-1004 # 68f0 <malloc+0xc84>
    1ce4:	6d1030ef          	jal	5bb4 <printf>
      exit(0);
    1ce8:	4501                	li	a0,0
    1cea:	289030ef          	jal	5772 <exit>
      printf("%s: fork failed\n", s);
    1cee:	85d2                	mv	a1,s4
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	93850513          	addi	a0,a0,-1736 # 6628 <malloc+0x9bc>
    1cf8:	6bd030ef          	jal	5bb4 <printf>
      exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	275030ef          	jal	5772 <exit>
      exit(1);
    1d02:	4505                	li	a0,1
    1d04:	26f030ef          	jal	5772 <exit>

0000000000001d08 <manywrites>:
{
    1d08:	7159                	addi	sp,sp,-112
    1d0a:	f486                	sd	ra,104(sp)
    1d0c:	f0a2                	sd	s0,96(sp)
    1d0e:	eca6                	sd	s1,88(sp)
    1d10:	e8ca                	sd	s2,80(sp)
    1d12:	e4ce                	sd	s3,72(sp)
    1d14:	fc56                	sd	s5,56(sp)
    1d16:	1880                	addi	s0,sp,112
    1d18:	8aaa                	mv	s5,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d1a:	4901                	li	s2,0
    1d1c:	4991                	li	s3,4
    int pid = fork();
    1d1e:	24d030ef          	jal	576a <fork>
    1d22:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d24:	02054d63          	bltz	a0,1d5e <manywrites+0x56>
    if (pid == 0) {
    1d28:	c931                	beqz	a0,1d7c <manywrites+0x74>
  for (int ci = 0; ci < nchildren; ci++) {
    1d2a:	2905                	addiw	s2,s2,1
    1d2c:	ff3919e3          	bne	s2,s3,1d1e <manywrites+0x16>
    1d30:	4491                	li	s1,4
    wait(&st);
    1d32:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d36:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d3a:	854a                	mv	a0,s2
    1d3c:	23f030ef          	jal	577a <wait>
    if (st != 0)
    1d40:	f9842503          	lw	a0,-104(s0)
    1d44:	0e051463          	bnez	a0,1e2c <manywrites+0x124>
  for (int ci = 0; ci < nchildren; ci++) {
    1d48:	34fd                	addiw	s1,s1,-1
    1d4a:	f4f5                	bnez	s1,1d36 <manywrites+0x2e>
    1d4c:	e0d2                	sd	s4,64(sp)
    1d4e:	f85a                	sd	s6,48(sp)
    1d50:	f45e                	sd	s7,40(sp)
    1d52:	f062                	sd	s8,32(sp)
    1d54:	ec66                	sd	s9,24(sp)
    1d56:	e86a                	sd	s10,16(sp)
  exit(0);
    1d58:	4501                	li	a0,0
    1d5a:	219030ef          	jal	5772 <exit>
    1d5e:	e0d2                	sd	s4,64(sp)
    1d60:	f85a                	sd	s6,48(sp)
    1d62:	f45e                	sd	s7,40(sp)
    1d64:	f062                	sd	s8,32(sp)
    1d66:	ec66                	sd	s9,24(sp)
    1d68:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d6a:	00006517          	auipc	a0,0x6
    1d6e:	fae50513          	addi	a0,a0,-82 # 7d18 <malloc+0x20ac>
    1d72:	643030ef          	jal	5bb4 <printf>
      exit(1);
    1d76:	4505                	li	a0,1
    1d78:	1fb030ef          	jal	5772 <exit>
    1d7c:	e0d2                	sd	s4,64(sp)
    1d7e:	f85a                	sd	s6,48(sp)
    1d80:	f45e                	sd	s7,40(sp)
    1d82:	f062                	sd	s8,32(sp)
    1d84:	ec66                	sd	s9,24(sp)
    1d86:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d88:	06200793          	li	a5,98
    1d8c:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1d90:	0619079b          	addiw	a5,s2,97
    1d94:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1d98:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1d9c:	f9840513          	addi	a0,s0,-104
    1da0:	223030ef          	jal	57c2 <unlink>
    1da4:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
    1da6:	f9840c13          	addi	s8,s0,-104
    1daa:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    1dae:	6b0d                	lui	s6,0x3
    1db0:	0000bc97          	auipc	s9,0xb
    1db4:	f48c8c93          	addi	s9,s9,-184 # ccf8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1db8:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
    1dba:	85de                	mv	a1,s7
    1dbc:	8562                	mv	a0,s8
    1dbe:	1f5030ef          	jal	57b2 <open>
    1dc2:	89aa                	mv	s3,a0
          if (fd < 0) {
    1dc4:	02054c63          	bltz	a0,1dfc <manywrites+0xf4>
          int cc = write(fd, buf, sz);
    1dc8:	865a                	mv	a2,s6
    1dca:	85e6                	mv	a1,s9
    1dcc:	1c7030ef          	jal	5792 <write>
          if (cc != sz) {
    1dd0:	05651263          	bne	a0,s6,1e14 <manywrites+0x10c>
          close(fd);
    1dd4:	854e                	mv	a0,s3
    1dd6:	1c5030ef          	jal	579a <close>
        for (int i = 0; i < ci + 1; i++) {
    1dda:	2a05                	addiw	s4,s4,1
    1ddc:	fd495fe3          	bge	s2,s4,1dba <manywrites+0xb2>
        unlink(name);
    1de0:	f9840513          	addi	a0,s0,-104
    1de4:	1df030ef          	jal	57c2 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1de8:	3d7d                	addiw	s10,s10,-1
    1dea:	fc0d17e3          	bnez	s10,1db8 <manywrites+0xb0>
      unlink(name);
    1dee:	f9840513          	addi	a0,s0,-104
    1df2:	1d1030ef          	jal	57c2 <unlink>
      exit(0);
    1df6:	4501                	li	a0,0
    1df8:	17b030ef          	jal	5772 <exit>
            printf("%s: cannot create %s\n", s, name);
    1dfc:	f9840613          	addi	a2,s0,-104
    1e00:	85d6                	mv	a1,s5
    1e02:	00005517          	auipc	a0,0x5
    1e06:	b0e50513          	addi	a0,a0,-1266 # 6910 <malloc+0xca4>
    1e0a:	5ab030ef          	jal	5bb4 <printf>
            exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	163030ef          	jal	5772 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e14:	86aa                	mv	a3,a0
    1e16:	660d                	lui	a2,0x3
    1e18:	85d6                	mv	a1,s5
    1e1a:	00004517          	auipc	a0,0x4
    1e1e:	04e50513          	addi	a0,a0,78 # 5e68 <malloc+0x1fc>
    1e22:	593030ef          	jal	5bb4 <printf>
            exit(1);
    1e26:	4505                	li	a0,1
    1e28:	14b030ef          	jal	5772 <exit>
    1e2c:	e0d2                	sd	s4,64(sp)
    1e2e:	f85a                	sd	s6,48(sp)
    1e30:	f45e                	sd	s7,40(sp)
    1e32:	f062                	sd	s8,32(sp)
    1e34:	ec66                	sd	s9,24(sp)
    1e36:	e86a                	sd	s10,16(sp)
      exit(st);
    1e38:	13b030ef          	jal	5772 <exit>

0000000000001e3c <copyinstr3>:
{
    1e3c:	7179                	addi	sp,sp,-48
    1e3e:	f406                	sd	ra,40(sp)
    1e40:	f022                	sd	s0,32(sp)
    1e42:	ec26                	sd	s1,24(sp)
    1e44:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e46:	6509                	lui	a0,0x2
    1e48:	0f7030ef          	jal	573e <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e4c:	4501                	li	a0,0
    1e4e:	0f1030ef          	jal	573e <sbrk>
  if ((top % PGSIZE) != 0) {
    1e52:	03451793          	slli	a5,a0,0x34
    1e56:	e7bd                	bnez	a5,1ec4 <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e58:	4501                	li	a0,0
    1e5a:	0e5030ef          	jal	573e <sbrk>
  if (top % PGSIZE) {
    1e5e:	03451793          	slli	a5,a0,0x34
    1e62:	ebb5                	bnez	a5,1ed6 <copyinstr3+0x9a>
  char *b = (char *)(top - 1);
    1e64:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xbd>
  *b = 'x';
    1e68:	07800793          	li	a5,120
    1e6c:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e70:	8526                	mv	a0,s1
    1e72:	151030ef          	jal	57c2 <unlink>
  if (ret != -1) {
    1e76:	57fd                	li	a5,-1
    1e78:	06f51863          	bne	a0,a5,1ee8 <copyinstr3+0xac>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e7c:	20100593          	li	a1,513
    1e80:	8526                	mv	a0,s1
    1e82:	131030ef          	jal	57b2 <open>
  if (fd != -1) {
    1e86:	57fd                	li	a5,-1
    1e88:	06f51b63          	bne	a0,a5,1efe <copyinstr3+0xc2>
  ret = link(b, b);
    1e8c:	85a6                	mv	a1,s1
    1e8e:	8526                	mv	a0,s1
    1e90:	143030ef          	jal	57d2 <link>
  if (ret != -1) {
    1e94:	57fd                	li	a5,-1
    1e96:	06f51f63          	bne	a0,a5,1f14 <copyinstr3+0xd8>
  char *args[] = {"xx", 0};
    1e9a:	00005797          	auipc	a5,0x5
    1e9e:	77678793          	addi	a5,a5,1910 # 7610 <malloc+0x19a4>
    1ea2:	fcf43823          	sd	a5,-48(s0)
    1ea6:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1eaa:	fd040593          	addi	a1,s0,-48
    1eae:	8526                	mv	a0,s1
    1eb0:	0fb030ef          	jal	57aa <exec>
  if (ret != -1) {
    1eb4:	57fd                	li	a5,-1
    1eb6:	06f51b63          	bne	a0,a5,1f2c <copyinstr3+0xf0>
}
    1eba:	70a2                	ld	ra,40(sp)
    1ebc:	7402                	ld	s0,32(sp)
    1ebe:	64e2                	ld	s1,24(sp)
    1ec0:	6145                	addi	sp,sp,48
    1ec2:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ec4:	6785                	lui	a5,0x1
    1ec6:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x109>
    1eca:	8d79                	and	a0,a0,a4
    1ecc:	40a7853b          	subw	a0,a5,a0
    1ed0:	06f030ef          	jal	573e <sbrk>
    1ed4:	b751                	j	1e58 <copyinstr3+0x1c>
    printf("oops\n");
    1ed6:	00005517          	auipc	a0,0x5
    1eda:	a5250513          	addi	a0,a0,-1454 # 6928 <malloc+0xcbc>
    1ede:	4d7030ef          	jal	5bb4 <printf>
    exit(1);
    1ee2:	4505                	li	a0,1
    1ee4:	08f030ef          	jal	5772 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1ee8:	862a                	mv	a2,a0
    1eea:	85a6                	mv	a1,s1
    1eec:	00004517          	auipc	a0,0x4
    1ef0:	65c50513          	addi	a0,a0,1628 # 6548 <malloc+0x8dc>
    1ef4:	4c1030ef          	jal	5bb4 <printf>
    exit(1);
    1ef8:	4505                	li	a0,1
    1efa:	079030ef          	jal	5772 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1efe:	862a                	mv	a2,a0
    1f00:	85a6                	mv	a1,s1
    1f02:	00004517          	auipc	a0,0x4
    1f06:	66650513          	addi	a0,a0,1638 # 6568 <malloc+0x8fc>
    1f0a:	4ab030ef          	jal	5bb4 <printf>
    exit(1);
    1f0e:	4505                	li	a0,1
    1f10:	063030ef          	jal	5772 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f14:	86aa                	mv	a3,a0
    1f16:	8626                	mv	a2,s1
    1f18:	85a6                	mv	a1,s1
    1f1a:	00004517          	auipc	a0,0x4
    1f1e:	66e50513          	addi	a0,a0,1646 # 6588 <malloc+0x91c>
    1f22:	493030ef          	jal	5bb4 <printf>
    exit(1);
    1f26:	4505                	li	a0,1
    1f28:	04b030ef          	jal	5772 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f2c:	863e                	mv	a2,a5
    1f2e:	85a6                	mv	a1,s1
    1f30:	00004517          	auipc	a0,0x4
    1f34:	68050513          	addi	a0,a0,1664 # 65b0 <malloc+0x944>
    1f38:	47d030ef          	jal	5bb4 <printf>
    exit(1);
    1f3c:	4505                	li	a0,1
    1f3e:	035030ef          	jal	5772 <exit>

0000000000001f42 <rwsbrk>:
{
    1f42:	1101                	addi	sp,sp,-32
    1f44:	ec06                	sd	ra,24(sp)
    1f46:	e822                	sd	s0,16(sp)
    1f48:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f4a:	6509                	lui	a0,0x2
    1f4c:	7f2030ef          	jal	573e <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f50:	57fd                	li	a5,-1
    1f52:	04f50a63          	beq	a0,a5,1fa6 <rwsbrk+0x64>
    1f56:	e426                	sd	s1,8(sp)
    1f58:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f5a:	7579                	lui	a0,0xffffe
    1f5c:	7e2030ef          	jal	573e <sbrk>
    1f60:	57fd                	li	a5,-1
    1f62:	04f50d63          	beq	a0,a5,1fbc <rwsbrk+0x7a>
    1f66:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f68:	20100593          	li	a1,513
    1f6c:	00005517          	auipc	a0,0x5
    1f70:	9fc50513          	addi	a0,a0,-1540 # 6968 <malloc+0xcfc>
    1f74:	03f030ef          	jal	57b2 <open>
    1f78:	892a                	mv	s2,a0
  if (fd < 0) {
    1f7a:	04054b63          	bltz	a0,1fd0 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f7e:	6785                	lui	a5,0x1
    1f80:	94be                	add	s1,s1,a5
    1f82:	40000613          	li	a2,1024
    1f86:	85a6                	mv	a1,s1
    1f88:	00b030ef          	jal	5792 <write>
    1f8c:	862a                	mv	a2,a0
  if (n >= 0) {
    1f8e:	04054a63          	bltz	a0,1fe2 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1f92:	85a6                	mv	a1,s1
    1f94:	00005517          	auipc	a0,0x5
    1f98:	9f450513          	addi	a0,a0,-1548 # 6988 <malloc+0xd1c>
    1f9c:	419030ef          	jal	5bb4 <printf>
    exit(1);
    1fa0:	4505                	li	a0,1
    1fa2:	7d0030ef          	jal	5772 <exit>
    1fa6:	e426                	sd	s1,8(sp)
    1fa8:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1faa:	00005517          	auipc	a0,0x5
    1fae:	98650513          	addi	a0,a0,-1658 # 6930 <malloc+0xcc4>
    1fb2:	403030ef          	jal	5bb4 <printf>
    exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	7ba030ef          	jal	5772 <exit>
    1fbc:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fbe:	00005517          	auipc	a0,0x5
    1fc2:	98a50513          	addi	a0,a0,-1654 # 6948 <malloc+0xcdc>
    1fc6:	3ef030ef          	jal	5bb4 <printf>
    exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	7a6030ef          	jal	5772 <exit>
    printf("open(rwsbrk) failed\n");
    1fd0:	00005517          	auipc	a0,0x5
    1fd4:	9a050513          	addi	a0,a0,-1632 # 6970 <malloc+0xd04>
    1fd8:	3dd030ef          	jal	5bb4 <printf>
    exit(1);
    1fdc:	4505                	li	a0,1
    1fde:	794030ef          	jal	5772 <exit>
  close(fd);
    1fe2:	854a                	mv	a0,s2
    1fe4:	7b6030ef          	jal	579a <close>
  unlink("rwsbrk");
    1fe8:	00005517          	auipc	a0,0x5
    1fec:	98050513          	addi	a0,a0,-1664 # 6968 <malloc+0xcfc>
    1ff0:	7d2030ef          	jal	57c2 <unlink>
  fd = open("README", O_RDONLY);
    1ff4:	4581                	li	a1,0
    1ff6:	00004517          	auipc	a0,0x4
    1ffa:	f7a50513          	addi	a0,a0,-134 # 5f70 <malloc+0x304>
    1ffe:	7b4030ef          	jal	57b2 <open>
    2002:	892a                	mv	s2,a0
  if (fd < 0) {
    2004:	02054363          	bltz	a0,202a <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    2008:	4629                	li	a2,10
    200a:	85a6                	mv	a1,s1
    200c:	77e030ef          	jal	578a <read>
    2010:	862a                	mv	a2,a0
  if (n >= 0) {
    2012:	02054563          	bltz	a0,203c <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    2016:	85a6                	mv	a1,s1
    2018:	00005517          	auipc	a0,0x5
    201c:	9a050513          	addi	a0,a0,-1632 # 69b8 <malloc+0xd4c>
    2020:	395030ef          	jal	5bb4 <printf>
    exit(1);
    2024:	4505                	li	a0,1
    2026:	74c030ef          	jal	5772 <exit>
    printf("open(README) failed\n");
    202a:	00004517          	auipc	a0,0x4
    202e:	f4e50513          	addi	a0,a0,-178 # 5f78 <malloc+0x30c>
    2032:	383030ef          	jal	5bb4 <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	73a030ef          	jal	5772 <exit>
  close(fd);
    203c:	854a                	mv	a0,s2
    203e:	75c030ef          	jal	579a <close>
  exit(0);
    2042:	4501                	li	a0,0
    2044:	72e030ef          	jal	5772 <exit>

0000000000002048 <sbrkbasic>:
{
    2048:	715d                	addi	sp,sp,-80
    204a:	e486                	sd	ra,72(sp)
    204c:	e0a2                	sd	s0,64(sp)
    204e:	ec56                	sd	s5,24(sp)
    2050:	0880                	addi	s0,sp,80
    2052:	8aaa                	mv	s5,a0
  pid = fork();
    2054:	716030ef          	jal	576a <fork>
  if (pid < 0) {
    2058:	02054c63          	bltz	a0,2090 <sbrkbasic+0x48>
  if (pid == 0) {
    205c:	ed31                	bnez	a0,20b8 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    205e:	40000537          	lui	a0,0x40000
    2062:	6dc030ef          	jal	573e <sbrk>
    if (a == (char *)SBRK_ERROR) {
    2066:	57fd                	li	a5,-1
    2068:	04f50163          	beq	a0,a5,20aa <sbrkbasic+0x62>
    206c:	fc26                	sd	s1,56(sp)
    206e:	f84a                	sd	s2,48(sp)
    2070:	f44e                	sd	s3,40(sp)
    2072:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2074:	400007b7          	lui	a5,0x40000
    2078:	97aa                	add	a5,a5,a0
      *b = 99;
    207a:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    207e:	6705                	lui	a4,0x1
      *b = 99;
    2080:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0308>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2084:	953a                	add	a0,a0,a4
    2086:	fef51de3          	bne	a0,a5,2080 <sbrkbasic+0x38>
    exit(1);
    208a:	4505                	li	a0,1
    208c:	6e6030ef          	jal	5772 <exit>
    2090:	fc26                	sd	s1,56(sp)
    2092:	f84a                	sd	s2,48(sp)
    2094:	f44e                	sd	s3,40(sp)
    2096:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2098:	00005517          	auipc	a0,0x5
    209c:	94850513          	addi	a0,a0,-1720 # 69e0 <malloc+0xd74>
    20a0:	315030ef          	jal	5bb4 <printf>
    exit(1);
    20a4:	4505                	li	a0,1
    20a6:	6cc030ef          	jal	5772 <exit>
    20aa:	fc26                	sd	s1,56(sp)
    20ac:	f84a                	sd	s2,48(sp)
    20ae:	f44e                	sd	s3,40(sp)
    20b0:	f052                	sd	s4,32(sp)
      exit(0);
    20b2:	4501                	li	a0,0
    20b4:	6be030ef          	jal	5772 <exit>
  wait(&xstatus);
    20b8:	fbc40513          	addi	a0,s0,-68
    20bc:	6be030ef          	jal	577a <wait>
  if (xstatus == 1) {
    20c0:	fbc42703          	lw	a4,-68(s0)
    20c4:	4785                	li	a5,1
    20c6:	02f70063          	beq	a4,a5,20e6 <sbrkbasic+0x9e>
    20ca:	fc26                	sd	s1,56(sp)
    20cc:	f84a                	sd	s2,48(sp)
    20ce:	f44e                	sd	s3,40(sp)
    20d0:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20d2:	4501                	li	a0,0
    20d4:	66a030ef          	jal	573e <sbrk>
    20d8:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20da:	4901                	li	s2,0
    b = sbrk(1);
    20dc:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20de:	6a05                	lui	s4,0x1
    20e0:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x148>
    20e4:	a005                	j	2104 <sbrkbasic+0xbc>
    20e6:	fc26                	sd	s1,56(sp)
    20e8:	f84a                	sd	s2,48(sp)
    20ea:	f44e                	sd	s3,40(sp)
    20ec:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    20ee:	85d6                	mv	a1,s5
    20f0:	00005517          	auipc	a0,0x5
    20f4:	91050513          	addi	a0,a0,-1776 # 6a00 <malloc+0xd94>
    20f8:	2bd030ef          	jal	5bb4 <printf>
    exit(1);
    20fc:	4505                	li	a0,1
    20fe:	674030ef          	jal	5772 <exit>
    2102:	84be                	mv	s1,a5
    b = sbrk(1);
    2104:	854e                	mv	a0,s3
    2106:	638030ef          	jal	573e <sbrk>
    if (b != a) {
    210a:	04951163          	bne	a0,s1,214c <sbrkbasic+0x104>
    *b = 1;
    210e:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2112:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    2116:	2905                	addiw	s2,s2,1
    2118:	ff4915e3          	bne	s2,s4,2102 <sbrkbasic+0xba>
  pid = fork();
    211c:	64e030ef          	jal	576a <fork>
    2120:	892a                	mv	s2,a0
  if (pid < 0) {
    2122:	04054263          	bltz	a0,2166 <sbrkbasic+0x11e>
  c = sbrk(1);
    2126:	4505                	li	a0,1
    2128:	616030ef          	jal	573e <sbrk>
  c = sbrk(1);
    212c:	4505                	li	a0,1
    212e:	610030ef          	jal	573e <sbrk>
  if (c != a + 1) {
    2132:	0489                	addi	s1,s1,2
    2134:	04a48363          	beq	s1,a0,217a <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    2138:	85d6                	mv	a1,s5
    213a:	00005517          	auipc	a0,0x5
    213e:	92650513          	addi	a0,a0,-1754 # 6a60 <malloc+0xdf4>
    2142:	273030ef          	jal	5bb4 <printf>
    exit(1);
    2146:	4505                	li	a0,1
    2148:	62a030ef          	jal	5772 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    214c:	872a                	mv	a4,a0
    214e:	86a6                	mv	a3,s1
    2150:	864a                	mv	a2,s2
    2152:	85d6                	mv	a1,s5
    2154:	00005517          	auipc	a0,0x5
    2158:	8cc50513          	addi	a0,a0,-1844 # 6a20 <malloc+0xdb4>
    215c:	259030ef          	jal	5bb4 <printf>
      exit(1);
    2160:	4505                	li	a0,1
    2162:	610030ef          	jal	5772 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2166:	85d6                	mv	a1,s5
    2168:	00005517          	auipc	a0,0x5
    216c:	8d850513          	addi	a0,a0,-1832 # 6a40 <malloc+0xdd4>
    2170:	245030ef          	jal	5bb4 <printf>
    exit(1);
    2174:	4505                	li	a0,1
    2176:	5fc030ef          	jal	5772 <exit>
  if (pid == 0)
    217a:	00091563          	bnez	s2,2184 <sbrkbasic+0x13c>
    exit(0);
    217e:	4501                	li	a0,0
    2180:	5f2030ef          	jal	5772 <exit>
  wait(&xstatus);
    2184:	fbc40513          	addi	a0,s0,-68
    2188:	5f2030ef          	jal	577a <wait>
  exit(xstatus);
    218c:	fbc42503          	lw	a0,-68(s0)
    2190:	5e2030ef          	jal	5772 <exit>

0000000000002194 <sbrkmuch>:
{
    2194:	7179                	addi	sp,sp,-48
    2196:	f406                	sd	ra,40(sp)
    2198:	f022                	sd	s0,32(sp)
    219a:	ec26                	sd	s1,24(sp)
    219c:	e84a                	sd	s2,16(sp)
    219e:	e44e                	sd	s3,8(sp)
    21a0:	e052                	sd	s4,0(sp)
    21a2:	1800                	addi	s0,sp,48
    21a4:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21a6:	4501                	li	a0,0
    21a8:	596030ef          	jal	573e <sbrk>
    21ac:	892a                	mv	s2,a0
  a = sbrk(0);
    21ae:	4501                	li	a0,0
    21b0:	58e030ef          	jal	573e <sbrk>
    21b4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21b6:	06400537          	lui	a0,0x6400
    21ba:	9d05                	subw	a0,a0,s1
    21bc:	582030ef          	jal	573e <sbrk>
  if (p != a) {
    21c0:	08a49763          	bne	s1,a0,224e <sbrkmuch+0xba>
  *lastaddr = 99;
    21c4:	064007b7          	lui	a5,0x6400
    21c8:	06300713          	li	a4,99
    21cc:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0307>
  a = sbrk(0);
    21d0:	4501                	li	a0,0
    21d2:	56c030ef          	jal	573e <sbrk>
    21d6:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21d8:	757d                	lui	a0,0xfffff
    21da:	564030ef          	jal	573e <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21de:	57fd                	li	a5,-1
    21e0:	08f50163          	beq	a0,a5,2262 <sbrkmuch+0xce>
  c = sbrk(0);
    21e4:	4501                	li	a0,0
    21e6:	558030ef          	jal	573e <sbrk>
  if (c != a - PGSIZE) {
    21ea:	77fd                	lui	a5,0xfffff
    21ec:	97a6                	add	a5,a5,s1
    21ee:	08f51463          	bne	a0,a5,2276 <sbrkmuch+0xe2>
  a = sbrk(0);
    21f2:	4501                	li	a0,0
    21f4:	54a030ef          	jal	573e <sbrk>
    21f8:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    21fa:	6505                	lui	a0,0x1
    21fc:	542030ef          	jal	573e <sbrk>
    2200:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    2202:	08a49663          	bne	s1,a0,228e <sbrkmuch+0xfa>
    2206:	4501                	li	a0,0
    2208:	536030ef          	jal	573e <sbrk>
    220c:	6785                	lui	a5,0x1
    220e:	97a6                	add	a5,a5,s1
    2210:	06f51f63          	bne	a0,a5,228e <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    2214:	064007b7          	lui	a5,0x6400
    2218:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0307>
    221c:	06300793          	li	a5,99
    2220:	08f70363          	beq	a4,a5,22a6 <sbrkmuch+0x112>
  a = sbrk(0);
    2224:	4501                	li	a0,0
    2226:	518030ef          	jal	573e <sbrk>
    222a:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    222c:	4501                	li	a0,0
    222e:	510030ef          	jal	573e <sbrk>
    2232:	40a9053b          	subw	a0,s2,a0
    2236:	508030ef          	jal	573e <sbrk>
  if (c != a) {
    223a:	08a49063          	bne	s1,a0,22ba <sbrkmuch+0x126>
}
    223e:	70a2                	ld	ra,40(sp)
    2240:	7402                	ld	s0,32(sp)
    2242:	64e2                	ld	s1,24(sp)
    2244:	6942                	ld	s2,16(sp)
    2246:	69a2                	ld	s3,8(sp)
    2248:	6a02                	ld	s4,0(sp)
    224a:	6145                	addi	sp,sp,48
    224c:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    224e:	85ce                	mv	a1,s3
    2250:	00005517          	auipc	a0,0x5
    2254:	83050513          	addi	a0,a0,-2000 # 6a80 <malloc+0xe14>
    2258:	15d030ef          	jal	5bb4 <printf>
    exit(1);
    225c:	4505                	li	a0,1
    225e:	514030ef          	jal	5772 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2262:	85ce                	mv	a1,s3
    2264:	00005517          	auipc	a0,0x5
    2268:	86450513          	addi	a0,a0,-1948 # 6ac8 <malloc+0xe5c>
    226c:	149030ef          	jal	5bb4 <printf>
    exit(1);
    2270:	4505                	li	a0,1
    2272:	500030ef          	jal	5772 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    2276:	86aa                	mv	a3,a0
    2278:	8626                	mv	a2,s1
    227a:	85ce                	mv	a1,s3
    227c:	00005517          	auipc	a0,0x5
    2280:	86c50513          	addi	a0,a0,-1940 # 6ae8 <malloc+0xe7c>
    2284:	131030ef          	jal	5bb4 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	4e8030ef          	jal	5772 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    228e:	86d2                	mv	a3,s4
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00005517          	auipc	a0,0x5
    2298:	89450513          	addi	a0,a0,-1900 # 6b28 <malloc+0xebc>
    229c:	119030ef          	jal	5bb4 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	4d0030ef          	jal	5772 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22a6:	85ce                	mv	a1,s3
    22a8:	00005517          	auipc	a0,0x5
    22ac:	8b050513          	addi	a0,a0,-1872 # 6b58 <malloc+0xeec>
    22b0:	105030ef          	jal	5bb4 <printf>
    exit(1);
    22b4:	4505                	li	a0,1
    22b6:	4bc030ef          	jal	5772 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22ba:	86aa                	mv	a3,a0
    22bc:	8626                	mv	a2,s1
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	8d050513          	addi	a0,a0,-1840 # 6b90 <malloc+0xf24>
    22c8:	0ed030ef          	jal	5bb4 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	4a4030ef          	jal	5772 <exit>

00000000000022d2 <sbrkarg>:
{
    22d2:	7179                	addi	sp,sp,-48
    22d4:	f406                	sd	ra,40(sp)
    22d6:	f022                	sd	s0,32(sp)
    22d8:	ec26                	sd	s1,24(sp)
    22da:	e84a                	sd	s2,16(sp)
    22dc:	e44e                	sd	s3,8(sp)
    22de:	1800                	addi	s0,sp,48
    22e0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22e2:	6505                	lui	a0,0x1
    22e4:	45a030ef          	jal	573e <sbrk>
    22e8:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    22ea:	20100593          	li	a1,513
    22ee:	00005517          	auipc	a0,0x5
    22f2:	8ca50513          	addi	a0,a0,-1846 # 6bb8 <malloc+0xf4c>
    22f6:	4bc030ef          	jal	57b2 <open>
    22fa:	84aa                	mv	s1,a0
  unlink("sbrk");
    22fc:	00005517          	auipc	a0,0x5
    2300:	8bc50513          	addi	a0,a0,-1860 # 6bb8 <malloc+0xf4c>
    2304:	4be030ef          	jal	57c2 <unlink>
  if (fd < 0) {
    2308:	0204c963          	bltz	s1,233a <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    230c:	6605                	lui	a2,0x1
    230e:	85ca                	mv	a1,s2
    2310:	8526                	mv	a0,s1
    2312:	480030ef          	jal	5792 <write>
    2316:	02054c63          	bltz	a0,234e <sbrkarg+0x7c>
  close(fd);
    231a:	8526                	mv	a0,s1
    231c:	47e030ef          	jal	579a <close>
  a = sbrk(PGSIZE);
    2320:	6505                	lui	a0,0x1
    2322:	41c030ef          	jal	573e <sbrk>
  if (pipe((int *)a) != 0) {
    2326:	45c030ef          	jal	5782 <pipe>
    232a:	ed05                	bnez	a0,2362 <sbrkarg+0x90>
}
    232c:	70a2                	ld	ra,40(sp)
    232e:	7402                	ld	s0,32(sp)
    2330:	64e2                	ld	s1,24(sp)
    2332:	6942                	ld	s2,16(sp)
    2334:	69a2                	ld	s3,8(sp)
    2336:	6145                	addi	sp,sp,48
    2338:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    233a:	85ce                	mv	a1,s3
    233c:	00005517          	auipc	a0,0x5
    2340:	88450513          	addi	a0,a0,-1916 # 6bc0 <malloc+0xf54>
    2344:	071030ef          	jal	5bb4 <printf>
    exit(1);
    2348:	4505                	li	a0,1
    234a:	428030ef          	jal	5772 <exit>
    printf("%s: write sbrk failed\n", s);
    234e:	85ce                	mv	a1,s3
    2350:	00005517          	auipc	a0,0x5
    2354:	88850513          	addi	a0,a0,-1912 # 6bd8 <malloc+0xf6c>
    2358:	05d030ef          	jal	5bb4 <printf>
    exit(1);
    235c:	4505                	li	a0,1
    235e:	414030ef          	jal	5772 <exit>
    printf("%s: pipe() failed\n", s);
    2362:	85ce                	mv	a1,s3
    2364:	00004517          	auipc	a0,0x4
    2368:	34c50513          	addi	a0,a0,844 # 66b0 <malloc+0xa44>
    236c:	049030ef          	jal	5bb4 <printf>
    exit(1);
    2370:	4505                	li	a0,1
    2372:	400030ef          	jal	5772 <exit>

0000000000002376 <argptest>:
{
    2376:	1101                	addi	sp,sp,-32
    2378:	ec06                	sd	ra,24(sp)
    237a:	e822                	sd	s0,16(sp)
    237c:	e426                	sd	s1,8(sp)
    237e:	e04a                	sd	s2,0(sp)
    2380:	1000                	addi	s0,sp,32
    2382:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2384:	4581                	li	a1,0
    2386:	00005517          	auipc	a0,0x5
    238a:	86a50513          	addi	a0,a0,-1942 # 6bf0 <malloc+0xf84>
    238e:	424030ef          	jal	57b2 <open>
  if (fd < 0) {
    2392:	02054563          	bltz	a0,23bc <argptest+0x46>
    2396:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2398:	4501                	li	a0,0
    239a:	3a4030ef          	jal	573e <sbrk>
    239e:	567d                	li	a2,-1
    23a0:	00c505b3          	add	a1,a0,a2
    23a4:	8526                	mv	a0,s1
    23a6:	3e4030ef          	jal	578a <read>
  close(fd);
    23aa:	8526                	mv	a0,s1
    23ac:	3ee030ef          	jal	579a <close>
}
    23b0:	60e2                	ld	ra,24(sp)
    23b2:	6442                	ld	s0,16(sp)
    23b4:	64a2                	ld	s1,8(sp)
    23b6:	6902                	ld	s2,0(sp)
    23b8:	6105                	addi	sp,sp,32
    23ba:	8082                	ret
    printf("%s: open failed\n", s);
    23bc:	85ca                	mv	a1,s2
    23be:	00004517          	auipc	a0,0x4
    23c2:	28250513          	addi	a0,a0,642 # 6640 <malloc+0x9d4>
    23c6:	7ee030ef          	jal	5bb4 <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	3a6030ef          	jal	5772 <exit>

00000000000023d0 <sbrkbugs>:
{
    23d0:	1141                	addi	sp,sp,-16
    23d2:	e406                	sd	ra,8(sp)
    23d4:	e022                	sd	s0,0(sp)
    23d6:	0800                	addi	s0,sp,16
  int pid = fork();
    23d8:	392030ef          	jal	576a <fork>
  if (pid < 0) {
    23dc:	00054c63          	bltz	a0,23f4 <sbrkbugs+0x24>
  if (pid == 0) {
    23e0:	e11d                	bnez	a0,2406 <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23e2:	35c030ef          	jal	573e <sbrk>
    sbrk(-sz);
    23e6:	40a0053b          	negw	a0,a0
    23ea:	354030ef          	jal	573e <sbrk>
    exit(0);
    23ee:	4501                	li	a0,0
    23f0:	382030ef          	jal	5772 <exit>
    printf("fork failed\n");
    23f4:	00006517          	auipc	a0,0x6
    23f8:	92450513          	addi	a0,a0,-1756 # 7d18 <malloc+0x20ac>
    23fc:	7b8030ef          	jal	5bb4 <printf>
    exit(1);
    2400:	4505                	li	a0,1
    2402:	370030ef          	jal	5772 <exit>
  wait(0);
    2406:	4501                	li	a0,0
    2408:	372030ef          	jal	577a <wait>
  pid = fork();
    240c:	35e030ef          	jal	576a <fork>
  if (pid < 0) {
    2410:	00054f63          	bltz	a0,242e <sbrkbugs+0x5e>
  if (pid == 0) {
    2414:	e515                	bnez	a0,2440 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    2416:	328030ef          	jal	573e <sbrk>
    sbrk(-(sz - 3500));
    241a:	6785                	lui	a5,0x1
    241c:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe0>
    2420:	40a7853b          	subw	a0,a5,a0
    2424:	31a030ef          	jal	573e <sbrk>
    exit(0);
    2428:	4501                	li	a0,0
    242a:	348030ef          	jal	5772 <exit>
    printf("fork failed\n");
    242e:	00006517          	auipc	a0,0x6
    2432:	8ea50513          	addi	a0,a0,-1814 # 7d18 <malloc+0x20ac>
    2436:	77e030ef          	jal	5bb4 <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	336030ef          	jal	5772 <exit>
  wait(0);
    2440:	4501                	li	a0,0
    2442:	338030ef          	jal	577a <wait>
  pid = fork();
    2446:	324030ef          	jal	576a <fork>
  if (pid < 0) {
    244a:	02054263          	bltz	a0,246e <sbrkbugs+0x9e>
  if (pid == 0) {
    244e:	e90d                	bnez	a0,2480 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2450:	2ee030ef          	jal	573e <sbrk>
    2454:	67ad                	lui	a5,0xb
    2456:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x218>
    245a:	40a7853b          	subw	a0,a5,a0
    245e:	2e0030ef          	jal	573e <sbrk>
    sbrk(-10);
    2462:	5559                	li	a0,-10
    2464:	2da030ef          	jal	573e <sbrk>
    exit(0);
    2468:	4501                	li	a0,0
    246a:	308030ef          	jal	5772 <exit>
    printf("fork failed\n");
    246e:	00006517          	auipc	a0,0x6
    2472:	8aa50513          	addi	a0,a0,-1878 # 7d18 <malloc+0x20ac>
    2476:	73e030ef          	jal	5bb4 <printf>
    exit(1);
    247a:	4505                	li	a0,1
    247c:	2f6030ef          	jal	5772 <exit>
  wait(0);
    2480:	4501                	li	a0,0
    2482:	2f8030ef          	jal	577a <wait>
  exit(0);
    2486:	4501                	li	a0,0
    2488:	2ea030ef          	jal	5772 <exit>

000000000000248c <sbrklast>:
{
    248c:	7179                	addi	sp,sp,-48
    248e:	f406                	sd	ra,40(sp)
    2490:	f022                	sd	s0,32(sp)
    2492:	ec26                	sd	s1,24(sp)
    2494:	e84a                	sd	s2,16(sp)
    2496:	e44e                	sd	s3,8(sp)
    2498:	e052                	sd	s4,0(sp)
    249a:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    249c:	4501                	li	a0,0
    249e:	2a0030ef          	jal	573e <sbrk>
  if ((top % PGSIZE) != 0)
    24a2:	03451793          	slli	a5,a0,0x34
    24a6:	ebad                	bnez	a5,2518 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24a8:	6505                	lui	a0,0x1
    24aa:	294030ef          	jal	573e <sbrk>
  sbrk(10);
    24ae:	4529                	li	a0,10
    24b0:	28e030ef          	jal	573e <sbrk>
  sbrk(-20);
    24b4:	5531                	li	a0,-20
    24b6:	288030ef          	jal	573e <sbrk>
  top = (uint64)sbrk(0);
    24ba:	4501                	li	a0,0
    24bc:	282030ef          	jal	573e <sbrk>
    24c0:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24c2:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xca>
  p[0] = 'x';
    24c6:	07800a13          	li	s4,120
    24ca:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    24ce:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24d2:	20200593          	li	a1,514
    24d6:	854a                	mv	a0,s2
    24d8:	2da030ef          	jal	57b2 <open>
    24dc:	89aa                	mv	s3,a0
  write(fd, p, 1);
    24de:	4605                	li	a2,1
    24e0:	85ca                	mv	a1,s2
    24e2:	2b0030ef          	jal	5792 <write>
  close(fd);
    24e6:	854e                	mv	a0,s3
    24e8:	2b2030ef          	jal	579a <close>
  fd = open(p, O_RDWR);
    24ec:	4589                	li	a1,2
    24ee:	854a                	mv	a0,s2
    24f0:	2c2030ef          	jal	57b2 <open>
  p[0] = '\0';
    24f4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    24f8:	4605                	li	a2,1
    24fa:	85ca                	mv	a1,s2
    24fc:	28e030ef          	jal	578a <read>
  if (p[0] != 'x')
    2500:	fc04c783          	lbu	a5,-64(s1)
    2504:	03479363          	bne	a5,s4,252a <sbrklast+0x9e>
}
    2508:	70a2                	ld	ra,40(sp)
    250a:	7402                	ld	s0,32(sp)
    250c:	64e2                	ld	s1,24(sp)
    250e:	6942                	ld	s2,16(sp)
    2510:	69a2                	ld	s3,8(sp)
    2512:	6a02                	ld	s4,0(sp)
    2514:	6145                	addi	sp,sp,48
    2516:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2518:	6785                	lui	a5,0x1
    251a:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x109>
    251e:	8d79                	and	a0,a0,a4
    2520:	40a7853b          	subw	a0,a5,a0
    2524:	21a030ef          	jal	573e <sbrk>
    2528:	b741                	j	24a8 <sbrklast+0x1c>
    exit(1);
    252a:	4505                	li	a0,1
    252c:	246030ef          	jal	5772 <exit>

0000000000002530 <sbrk8000>:
{
    2530:	1141                	addi	sp,sp,-16
    2532:	e406                	sd	ra,8(sp)
    2534:	e022                	sd	s0,0(sp)
    2536:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2538:	80000537          	lui	a0,0x80000
    253c:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff030c>
    253e:	200030ef          	jal	573e <sbrk>
  volatile char *top = sbrk(0);
    2542:	4501                	li	a0,0
    2544:	1fa030ef          	jal	573e <sbrk>
  *(top - 1) = *(top - 1) + 1;
    2548:	fff54783          	lbu	a5,-1(a0)
    254c:	0785                	addi	a5,a5,1
    254e:	0ff7f793          	zext.b	a5,a5
    2552:	fef50fa3          	sb	a5,-1(a0)
}
    2556:	60a2                	ld	ra,8(sp)
    2558:	6402                	ld	s0,0(sp)
    255a:	0141                	addi	sp,sp,16
    255c:	8082                	ret

000000000000255e <execout>:
{
    255e:	711d                	addi	sp,sp,-96
    2560:	ec86                	sd	ra,88(sp)
    2562:	e8a2                	sd	s0,80(sp)
    2564:	e4a6                	sd	s1,72(sp)
    2566:	e0ca                	sd	s2,64(sp)
    2568:	fc4e                	sd	s3,56(sp)
    256a:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    256c:	4901                	li	s2,0
    256e:	49bd                	li	s3,15
    int pid = fork();
    2570:	1fa030ef          	jal	576a <fork>
    2574:	84aa                	mv	s1,a0
    if (pid < 0) {
    2576:	00054e63          	bltz	a0,2592 <execout+0x34>
    } else if (pid == 0) {
    257a:	c51d                	beqz	a0,25a8 <execout+0x4a>
      wait((int *)0);
    257c:	4501                	li	a0,0
    257e:	1fc030ef          	jal	577a <wait>
  for (int avail = 0; avail < 15; avail++) {
    2582:	2905                	addiw	s2,s2,1
    2584:	ff3916e3          	bne	s2,s3,2570 <execout+0x12>
    2588:	f852                	sd	s4,48(sp)
    258a:	f456                	sd	s5,40(sp)
  exit(0);
    258c:	4501                	li	a0,0
    258e:	1e4030ef          	jal	5772 <exit>
    2592:	f852                	sd	s4,48(sp)
    2594:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2596:	00005517          	auipc	a0,0x5
    259a:	78250513          	addi	a0,a0,1922 # 7d18 <malloc+0x20ac>
    259e:	616030ef          	jal	5bb4 <printf>
      exit(1);
    25a2:	4505                	li	a0,1
    25a4:	1ce030ef          	jal	5772 <exit>
    25a8:	f852                	sd	s4,48(sp)
    25aa:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25ac:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25ae:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25b0:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25b2:	854e                	mv	a0,s3
    25b4:	18a030ef          	jal	573e <sbrk>
        if (a == SBRK_ERROR)
    25b8:	01450663          	beq	a0,s4,25c4 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25bc:	954e                	add	a0,a0,s3
    25be:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25c2:	bfc5                	j	25b2 <execout+0x54>
        sbrk(-PGSIZE);
    25c4:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25c6:	01205863          	blez	s2,25d6 <execout+0x78>
        sbrk(-PGSIZE);
    25ca:	854e                	mv	a0,s3
    25cc:	172030ef          	jal	573e <sbrk>
      for (int i = 0; i < avail; i++)
    25d0:	2485                	addiw	s1,s1,1
    25d2:	ff249ce3          	bne	s1,s2,25ca <execout+0x6c>
      close(1);
    25d6:	4505                	li	a0,1
    25d8:	1c2030ef          	jal	579a <close>
      char *args[] = {"echo", "x", 0};
    25dc:	00003517          	auipc	a0,0x3
    25e0:	7bc50513          	addi	a0,a0,1980 # 5d98 <malloc+0x12c>
    25e4:	faa43423          	sd	a0,-88(s0)
    25e8:	00004797          	auipc	a5,0x4
    25ec:	82078793          	addi	a5,a5,-2016 # 5e08 <malloc+0x19c>
    25f0:	faf43823          	sd	a5,-80(s0)
    25f4:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    25f8:	fa840593          	addi	a1,s0,-88
    25fc:	1ae030ef          	jal	57aa <exec>
      exit(0);
    2600:	4501                	li	a0,0
    2602:	170030ef          	jal	5772 <exit>

0000000000002606 <fourteen>:
{
    2606:	1101                	addi	sp,sp,-32
    2608:	ec06                	sd	ra,24(sp)
    260a:	e822                	sd	s0,16(sp)
    260c:	e426                	sd	s1,8(sp)
    260e:	1000                	addi	s0,sp,32
    2610:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    2612:	00004517          	auipc	a0,0x4
    2616:	7b650513          	addi	a0,a0,1974 # 6dc8 <malloc+0x115c>
    261a:	1c0030ef          	jal	57da <mkdir>
    261e:	e555                	bnez	a0,26ca <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    2620:	00004517          	auipc	a0,0x4
    2624:	60050513          	addi	a0,a0,1536 # 6c20 <malloc+0xfb4>
    2628:	1b2030ef          	jal	57da <mkdir>
    262c:	e94d                	bnez	a0,26de <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    262e:	20000593          	li	a1,512
    2632:	00004517          	auipc	a0,0x4
    2636:	64650513          	addi	a0,a0,1606 # 6c78 <malloc+0x100c>
    263a:	178030ef          	jal	57b2 <open>
  if (fd < 0) {
    263e:	0a054a63          	bltz	a0,26f2 <fourteen+0xec>
  close(fd);
    2642:	158030ef          	jal	579a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2646:	4581                	li	a1,0
    2648:	00004517          	auipc	a0,0x4
    264c:	6a850513          	addi	a0,a0,1704 # 6cf0 <malloc+0x1084>
    2650:	162030ef          	jal	57b2 <open>
  if (fd < 0) {
    2654:	0a054963          	bltz	a0,2706 <fourteen+0x100>
  close(fd);
    2658:	142030ef          	jal	579a <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    265c:	00004517          	auipc	a0,0x4
    2660:	70450513          	addi	a0,a0,1796 # 6d60 <malloc+0x10f4>
    2664:	176030ef          	jal	57da <mkdir>
    2668:	c94d                	beqz	a0,271a <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    266a:	00004517          	auipc	a0,0x4
    266e:	74e50513          	addi	a0,a0,1870 # 6db8 <malloc+0x114c>
    2672:	168030ef          	jal	57da <mkdir>
    2676:	cd45                	beqz	a0,272e <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2678:	00004517          	auipc	a0,0x4
    267c:	74050513          	addi	a0,a0,1856 # 6db8 <malloc+0x114c>
    2680:	142030ef          	jal	57c2 <unlink>
  unlink("12345678901234/12345678901234");
    2684:	00004517          	auipc	a0,0x4
    2688:	6dc50513          	addi	a0,a0,1756 # 6d60 <malloc+0x10f4>
    268c:	136030ef          	jal	57c2 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2690:	00004517          	auipc	a0,0x4
    2694:	66050513          	addi	a0,a0,1632 # 6cf0 <malloc+0x1084>
    2698:	12a030ef          	jal	57c2 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    269c:	00004517          	auipc	a0,0x4
    26a0:	5dc50513          	addi	a0,a0,1500 # 6c78 <malloc+0x100c>
    26a4:	11e030ef          	jal	57c2 <unlink>
  unlink("12345678901234/123456789012345");
    26a8:	00004517          	auipc	a0,0x4
    26ac:	57850513          	addi	a0,a0,1400 # 6c20 <malloc+0xfb4>
    26b0:	112030ef          	jal	57c2 <unlink>
  unlink("12345678901234");
    26b4:	00004517          	auipc	a0,0x4
    26b8:	71450513          	addi	a0,a0,1812 # 6dc8 <malloc+0x115c>
    26bc:	106030ef          	jal	57c2 <unlink>
}
    26c0:	60e2                	ld	ra,24(sp)
    26c2:	6442                	ld	s0,16(sp)
    26c4:	64a2                	ld	s1,8(sp)
    26c6:	6105                	addi	sp,sp,32
    26c8:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26ca:	85a6                	mv	a1,s1
    26cc:	00004517          	auipc	a0,0x4
    26d0:	52c50513          	addi	a0,a0,1324 # 6bf8 <malloc+0xf8c>
    26d4:	4e0030ef          	jal	5bb4 <printf>
    exit(1);
    26d8:	4505                	li	a0,1
    26da:	098030ef          	jal	5772 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26de:	85a6                	mv	a1,s1
    26e0:	00004517          	auipc	a0,0x4
    26e4:	56050513          	addi	a0,a0,1376 # 6c40 <malloc+0xfd4>
    26e8:	4cc030ef          	jal	5bb4 <printf>
    exit(1);
    26ec:	4505                	li	a0,1
    26ee:	084030ef          	jal	5772 <exit>
    printf(
    26f2:	85a6                	mv	a1,s1
    26f4:	00004517          	auipc	a0,0x4
    26f8:	5b450513          	addi	a0,a0,1460 # 6ca8 <malloc+0x103c>
    26fc:	4b8030ef          	jal	5bb4 <printf>
    exit(1);
    2700:	4505                	li	a0,1
    2702:	070030ef          	jal	5772 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2706:	85a6                	mv	a1,s1
    2708:	00004517          	auipc	a0,0x4
    270c:	61850513          	addi	a0,a0,1560 # 6d20 <malloc+0x10b4>
    2710:	4a4030ef          	jal	5bb4 <printf>
    exit(1);
    2714:	4505                	li	a0,1
    2716:	05c030ef          	jal	5772 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    271a:	85a6                	mv	a1,s1
    271c:	00004517          	auipc	a0,0x4
    2720:	66450513          	addi	a0,a0,1636 # 6d80 <malloc+0x1114>
    2724:	490030ef          	jal	5bb4 <printf>
    exit(1);
    2728:	4505                	li	a0,1
    272a:	048030ef          	jal	5772 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    272e:	85a6                	mv	a1,s1
    2730:	00004517          	auipc	a0,0x4
    2734:	6a850513          	addi	a0,a0,1704 # 6dd8 <malloc+0x116c>
    2738:	47c030ef          	jal	5bb4 <printf>
    exit(1);
    273c:	4505                	li	a0,1
    273e:	034030ef          	jal	5772 <exit>

0000000000002742 <diskfull>:
{
    2742:	b6010113          	addi	sp,sp,-1184
    2746:	48113c23          	sd	ra,1176(sp)
    274a:	48813823          	sd	s0,1168(sp)
    274e:	48913423          	sd	s1,1160(sp)
    2752:	49213023          	sd	s2,1152(sp)
    2756:	47313c23          	sd	s3,1144(sp)
    275a:	47413823          	sd	s4,1136(sp)
    275e:	47513423          	sd	s5,1128(sp)
    2762:	47613023          	sd	s6,1120(sp)
    2766:	45713c23          	sd	s7,1112(sp)
    276a:	45813823          	sd	s8,1104(sp)
    276e:	45913423          	sd	s9,1096(sp)
    2772:	45a13023          	sd	s10,1088(sp)
    2776:	43b13c23          	sd	s11,1080(sp)
    277a:	4a010413          	addi	s0,sp,1184
    277e:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2782:	00004517          	auipc	a0,0x4
    2786:	68e50513          	addi	a0,a0,1678 # 6e10 <malloc+0x11a4>
    278a:	038030ef          	jal	57c2 <unlink>
    278e:	03000a93          	li	s5,48
    name[0] = 'b';
    2792:	06200d13          	li	s10,98
    name[1] = 'i';
    2796:	06900c93          	li	s9,105
    name[2] = 'g';
    279a:	06700c13          	li	s8,103
    unlink(name);
    279e:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27a2:	60200b93          	li	s7,1538
    27a6:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27aa:	b9040a13          	addi	s4,s0,-1136
    27ae:	aa8d                	j	2920 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27b0:	b7040613          	addi	a2,s0,-1168
    27b4:	b6843583          	ld	a1,-1176(s0)
    27b8:	00004517          	auipc	a0,0x4
    27bc:	66850513          	addi	a0,a0,1640 # 6e20 <malloc+0x11b4>
    27c0:	3f4030ef          	jal	5bb4 <printf>
      break;
    27c4:	a039                	j	27d2 <diskfull+0x90>
        close(fd);
    27c6:	854e                	mv	a0,s3
    27c8:	7d3020ef          	jal	579a <close>
    close(fd);
    27cc:	854e                	mv	a0,s3
    27ce:	7cd020ef          	jal	579a <close>
  for (int i = 0; i < nzz; i++) {
    27d2:	4481                	li	s1,0
    name[0] = 'z';
    27d4:	07a00993          	li	s3,122
    unlink(name);
    27d8:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27dc:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27e0:	08000a93          	li	s5,128
    name[0] = 'z';
    27e4:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    27e8:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    27ec:	41f4d71b          	sraiw	a4,s1,0x1f
    27f0:	01b7571b          	srliw	a4,a4,0x1b
    27f4:	009707bb          	addw	a5,a4,s1
    27f8:	4057d69b          	sraiw	a3,a5,0x5
    27fc:	0306869b          	addiw	a3,a3,48
    2800:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2804:	8bfd                	andi	a5,a5,31
    2806:	9f99                	subw	a5,a5,a4
    2808:	0307879b          	addiw	a5,a5,48
    280c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2810:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2814:	854a                	mv	a0,s2
    2816:	7ad020ef          	jal	57c2 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    281a:	85d2                	mv	a1,s4
    281c:	854a                	mv	a0,s2
    281e:	795020ef          	jal	57b2 <open>
    if (fd < 0)
    2822:	00054763          	bltz	a0,2830 <diskfull+0xee>
    close(fd);
    2826:	775020ef          	jal	579a <close>
  for (int i = 0; i < nzz; i++) {
    282a:	2485                	addiw	s1,s1,1
    282c:	fb549ce3          	bne	s1,s5,27e4 <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    2830:	00004517          	auipc	a0,0x4
    2834:	5e050513          	addi	a0,a0,1504 # 6e10 <malloc+0x11a4>
    2838:	7a3020ef          	jal	57da <mkdir>
    283c:	12050363          	beqz	a0,2962 <diskfull+0x220>
  unlink("diskfulldir");
    2840:	00004517          	auipc	a0,0x4
    2844:	5d050513          	addi	a0,a0,1488 # 6e10 <malloc+0x11a4>
    2848:	77b020ef          	jal	57c2 <unlink>
  for (int i = 0; i < nzz; i++) {
    284c:	4481                	li	s1,0
    name[0] = 'z';
    284e:	07a00913          	li	s2,122
    unlink(name);
    2852:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2856:	08000993          	li	s3,128
    name[0] = 'z';
    285a:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    285e:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2862:	41f4d71b          	sraiw	a4,s1,0x1f
    2866:	01b7571b          	srliw	a4,a4,0x1b
    286a:	009707bb          	addw	a5,a4,s1
    286e:	4057d69b          	sraiw	a3,a5,0x5
    2872:	0306869b          	addiw	a3,a3,48
    2876:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    287a:	8bfd                	andi	a5,a5,31
    287c:	9f99                	subw	a5,a5,a4
    287e:	0307879b          	addiw	a5,a5,48
    2882:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2886:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    288a:	8552                	mv	a0,s4
    288c:	737020ef          	jal	57c2 <unlink>
  for (int i = 0; i < nzz; i++) {
    2890:	2485                	addiw	s1,s1,1
    2892:	fd3494e3          	bne	s1,s3,285a <diskfull+0x118>
    2896:	03000493          	li	s1,48
    name[0] = 'b';
    289a:	06200b13          	li	s6,98
    name[1] = 'i';
    289e:	06900a93          	li	s5,105
    name[2] = 'g';
    28a2:	06700a13          	li	s4,103
    unlink(name);
    28a6:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28aa:	07f00913          	li	s2,127
    name[0] = 'b';
    28ae:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28b2:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28b6:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28ba:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28be:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28c2:	854e                	mv	a0,s3
    28c4:	6ff020ef          	jal	57c2 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28c8:	2485                	addiw	s1,s1,1
    28ca:	0ff4f493          	zext.b	s1,s1
    28ce:	ff2490e3          	bne	s1,s2,28ae <diskfull+0x16c>
}
    28d2:	49813083          	ld	ra,1176(sp)
    28d6:	49013403          	ld	s0,1168(sp)
    28da:	48813483          	ld	s1,1160(sp)
    28de:	48013903          	ld	s2,1152(sp)
    28e2:	47813983          	ld	s3,1144(sp)
    28e6:	47013a03          	ld	s4,1136(sp)
    28ea:	46813a83          	ld	s5,1128(sp)
    28ee:	46013b03          	ld	s6,1120(sp)
    28f2:	45813b83          	ld	s7,1112(sp)
    28f6:	45013c03          	ld	s8,1104(sp)
    28fa:	44813c83          	ld	s9,1096(sp)
    28fe:	44013d03          	ld	s10,1088(sp)
    2902:	43813d83          	ld	s11,1080(sp)
    2906:	4a010113          	addi	sp,sp,1184
    290a:	8082                	ret
    close(fd);
    290c:	854e                	mv	a0,s3
    290e:	68d020ef          	jal	579a <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    2912:	2a85                	addiw	s5,s5,1
    2914:	0ffafa93          	zext.b	s5,s5
    2918:	07f00793          	li	a5,127
    291c:	eafa8be3          	beq	s5,a5,27d2 <diskfull+0x90>
    name[0] = 'b';
    2920:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2924:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2928:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    292c:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2930:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2934:	855a                	mv	a0,s6
    2936:	68d020ef          	jal	57c2 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    293a:	85de                	mv	a1,s7
    293c:	855a                	mv	a0,s6
    293e:	675020ef          	jal	57b2 <open>
    2942:	89aa                	mv	s3,a0
    if (fd < 0) {
    2944:	e60546e3          	bltz	a0,27b0 <diskfull+0x6e>
    2948:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    294a:	40000913          	li	s2,1024
    294e:	864a                	mv	a2,s2
    2950:	85d2                	mv	a1,s4
    2952:	854e                	mv	a0,s3
    2954:	63f020ef          	jal	5792 <write>
    2958:	e72517e3          	bne	a0,s2,27c6 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    295c:	34fd                	addiw	s1,s1,-1
    295e:	f8e5                	bnez	s1,294e <diskfull+0x20c>
    2960:	b775                	j	290c <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2962:	b6843583          	ld	a1,-1176(s0)
    2966:	00004517          	auipc	a0,0x4
    296a:	4da50513          	addi	a0,a0,1242 # 6e40 <malloc+0x11d4>
    296e:	246030ef          	jal	5bb4 <printf>
    2972:	b5f9                	j	2840 <diskfull+0xfe>

0000000000002974 <iputtest>:
{
    2974:	1101                	addi	sp,sp,-32
    2976:	ec06                	sd	ra,24(sp)
    2978:	e822                	sd	s0,16(sp)
    297a:	e426                	sd	s1,8(sp)
    297c:	1000                	addi	s0,sp,32
    297e:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    2980:	00004517          	auipc	a0,0x4
    2984:	4f050513          	addi	a0,a0,1264 # 6e70 <malloc+0x1204>
    2988:	653020ef          	jal	57da <mkdir>
    298c:	02054f63          	bltz	a0,29ca <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    2990:	00004517          	auipc	a0,0x4
    2994:	4e050513          	addi	a0,a0,1248 # 6e70 <malloc+0x1204>
    2998:	64b020ef          	jal	57e2 <chdir>
    299c:	04054163          	bltz	a0,29de <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29a0:	00004517          	auipc	a0,0x4
    29a4:	51050513          	addi	a0,a0,1296 # 6eb0 <malloc+0x1244>
    29a8:	61b020ef          	jal	57c2 <unlink>
    29ac:	04054363          	bltz	a0,29f2 <iputtest+0x7e>
  if (chdir("/") < 0) {
    29b0:	00004517          	auipc	a0,0x4
    29b4:	53050513          	addi	a0,a0,1328 # 6ee0 <malloc+0x1274>
    29b8:	62b020ef          	jal	57e2 <chdir>
    29bc:	04054563          	bltz	a0,2a06 <iputtest+0x92>
}
    29c0:	60e2                	ld	ra,24(sp)
    29c2:	6442                	ld	s0,16(sp)
    29c4:	64a2                	ld	s1,8(sp)
    29c6:	6105                	addi	sp,sp,32
    29c8:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29ca:	85a6                	mv	a1,s1
    29cc:	00004517          	auipc	a0,0x4
    29d0:	4ac50513          	addi	a0,a0,1196 # 6e78 <malloc+0x120c>
    29d4:	1e0030ef          	jal	5bb4 <printf>
    exit(1);
    29d8:	4505                	li	a0,1
    29da:	599020ef          	jal	5772 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29de:	85a6                	mv	a1,s1
    29e0:	00004517          	auipc	a0,0x4
    29e4:	4b050513          	addi	a0,a0,1200 # 6e90 <malloc+0x1224>
    29e8:	1cc030ef          	jal	5bb4 <printf>
    exit(1);
    29ec:	4505                	li	a0,1
    29ee:	585020ef          	jal	5772 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    29f2:	85a6                	mv	a1,s1
    29f4:	00004517          	auipc	a0,0x4
    29f8:	4cc50513          	addi	a0,a0,1228 # 6ec0 <malloc+0x1254>
    29fc:	1b8030ef          	jal	5bb4 <printf>
    exit(1);
    2a00:	4505                	li	a0,1
    2a02:	571020ef          	jal	5772 <exit>
    printf("%s: chdir / failed\n", s);
    2a06:	85a6                	mv	a1,s1
    2a08:	00004517          	auipc	a0,0x4
    2a0c:	4e050513          	addi	a0,a0,1248 # 6ee8 <malloc+0x127c>
    2a10:	1a4030ef          	jal	5bb4 <printf>
    exit(1);
    2a14:	4505                	li	a0,1
    2a16:	55d020ef          	jal	5772 <exit>

0000000000002a1a <exitiputtest>:
{
    2a1a:	7179                	addi	sp,sp,-48
    2a1c:	f406                	sd	ra,40(sp)
    2a1e:	f022                	sd	s0,32(sp)
    2a20:	ec26                	sd	s1,24(sp)
    2a22:	1800                	addi	s0,sp,48
    2a24:	84aa                	mv	s1,a0
  pid = fork();
    2a26:	545020ef          	jal	576a <fork>
  if (pid < 0) {
    2a2a:	02054e63          	bltz	a0,2a66 <exitiputtest+0x4c>
  if (pid == 0) {
    2a2e:	e541                	bnez	a0,2ab6 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a30:	00004517          	auipc	a0,0x4
    2a34:	44050513          	addi	a0,a0,1088 # 6e70 <malloc+0x1204>
    2a38:	5a3020ef          	jal	57da <mkdir>
    2a3c:	02054f63          	bltz	a0,2a7a <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a40:	00004517          	auipc	a0,0x4
    2a44:	43050513          	addi	a0,a0,1072 # 6e70 <malloc+0x1204>
    2a48:	59b020ef          	jal	57e2 <chdir>
    2a4c:	04054163          	bltz	a0,2a8e <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a50:	00004517          	auipc	a0,0x4
    2a54:	46050513          	addi	a0,a0,1120 # 6eb0 <malloc+0x1244>
    2a58:	56b020ef          	jal	57c2 <unlink>
    2a5c:	04054363          	bltz	a0,2aa2 <exitiputtest+0x88>
    exit(0);
    2a60:	4501                	li	a0,0
    2a62:	511020ef          	jal	5772 <exit>
    printf("%s: fork failed\n", s);
    2a66:	85a6                	mv	a1,s1
    2a68:	00004517          	auipc	a0,0x4
    2a6c:	bc050513          	addi	a0,a0,-1088 # 6628 <malloc+0x9bc>
    2a70:	144030ef          	jal	5bb4 <printf>
    exit(1);
    2a74:	4505                	li	a0,1
    2a76:	4fd020ef          	jal	5772 <exit>
      printf("%s: mkdir failed\n", s);
    2a7a:	85a6                	mv	a1,s1
    2a7c:	00004517          	auipc	a0,0x4
    2a80:	3fc50513          	addi	a0,a0,1020 # 6e78 <malloc+0x120c>
    2a84:	130030ef          	jal	5bb4 <printf>
      exit(1);
    2a88:	4505                	li	a0,1
    2a8a:	4e9020ef          	jal	5772 <exit>
      printf("%s: child chdir failed\n", s);
    2a8e:	85a6                	mv	a1,s1
    2a90:	00004517          	auipc	a0,0x4
    2a94:	47050513          	addi	a0,a0,1136 # 6f00 <malloc+0x1294>
    2a98:	11c030ef          	jal	5bb4 <printf>
      exit(1);
    2a9c:	4505                	li	a0,1
    2a9e:	4d5020ef          	jal	5772 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2aa2:	85a6                	mv	a1,s1
    2aa4:	00004517          	auipc	a0,0x4
    2aa8:	41c50513          	addi	a0,a0,1052 # 6ec0 <malloc+0x1254>
    2aac:	108030ef          	jal	5bb4 <printf>
      exit(1);
    2ab0:	4505                	li	a0,1
    2ab2:	4c1020ef          	jal	5772 <exit>
  wait(&xstatus);
    2ab6:	fdc40513          	addi	a0,s0,-36
    2aba:	4c1020ef          	jal	577a <wait>
  exit(xstatus);
    2abe:	fdc42503          	lw	a0,-36(s0)
    2ac2:	4b1020ef          	jal	5772 <exit>

0000000000002ac6 <dirtest>:
{
    2ac6:	1101                	addi	sp,sp,-32
    2ac8:	ec06                	sd	ra,24(sp)
    2aca:	e822                	sd	s0,16(sp)
    2acc:	e426                	sd	s1,8(sp)
    2ace:	1000                	addi	s0,sp,32
    2ad0:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	44650513          	addi	a0,a0,1094 # 6f18 <malloc+0x12ac>
    2ada:	501020ef          	jal	57da <mkdir>
    2ade:	02054f63          	bltz	a0,2b1c <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2ae2:	00004517          	auipc	a0,0x4
    2ae6:	43650513          	addi	a0,a0,1078 # 6f18 <malloc+0x12ac>
    2aea:	4f9020ef          	jal	57e2 <chdir>
    2aee:	04054163          	bltz	a0,2b30 <dirtest+0x6a>
  if (chdir("..") < 0) {
    2af2:	00004517          	auipc	a0,0x4
    2af6:	44650513          	addi	a0,a0,1094 # 6f38 <malloc+0x12cc>
    2afa:	4e9020ef          	jal	57e2 <chdir>
    2afe:	04054363          	bltz	a0,2b44 <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b02:	00004517          	auipc	a0,0x4
    2b06:	41650513          	addi	a0,a0,1046 # 6f18 <malloc+0x12ac>
    2b0a:	4b9020ef          	jal	57c2 <unlink>
    2b0e:	04054563          	bltz	a0,2b58 <dirtest+0x92>
}
    2b12:	60e2                	ld	ra,24(sp)
    2b14:	6442                	ld	s0,16(sp)
    2b16:	64a2                	ld	s1,8(sp)
    2b18:	6105                	addi	sp,sp,32
    2b1a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b1c:	85a6                	mv	a1,s1
    2b1e:	00004517          	auipc	a0,0x4
    2b22:	35a50513          	addi	a0,a0,858 # 6e78 <malloc+0x120c>
    2b26:	08e030ef          	jal	5bb4 <printf>
    exit(1);
    2b2a:	4505                	li	a0,1
    2b2c:	447020ef          	jal	5772 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b30:	85a6                	mv	a1,s1
    2b32:	00004517          	auipc	a0,0x4
    2b36:	3ee50513          	addi	a0,a0,1006 # 6f20 <malloc+0x12b4>
    2b3a:	07a030ef          	jal	5bb4 <printf>
    exit(1);
    2b3e:	4505                	li	a0,1
    2b40:	433020ef          	jal	5772 <exit>
    printf("%s: chdir .. failed\n", s);
    2b44:	85a6                	mv	a1,s1
    2b46:	00004517          	auipc	a0,0x4
    2b4a:	3fa50513          	addi	a0,a0,1018 # 6f40 <malloc+0x12d4>
    2b4e:	066030ef          	jal	5bb4 <printf>
    exit(1);
    2b52:	4505                	li	a0,1
    2b54:	41f020ef          	jal	5772 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b58:	85a6                	mv	a1,s1
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	3fe50513          	addi	a0,a0,1022 # 6f58 <malloc+0x12ec>
    2b62:	052030ef          	jal	5bb4 <printf>
    exit(1);
    2b66:	4505                	li	a0,1
    2b68:	40b020ef          	jal	5772 <exit>

0000000000002b6c <subdir>:
{
    2b6c:	1101                	addi	sp,sp,-32
    2b6e:	ec06                	sd	ra,24(sp)
    2b70:	e822                	sd	s0,16(sp)
    2b72:	e426                	sd	s1,8(sp)
    2b74:	e04a                	sd	s2,0(sp)
    2b76:	1000                	addi	s0,sp,32
    2b78:	892a                	mv	s2,a0
  unlink("ff");
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	52650513          	addi	a0,a0,1318 # 70a0 <malloc+0x1434>
    2b82:	441020ef          	jal	57c2 <unlink>
  if (mkdir("dd") != 0) {
    2b86:	00004517          	auipc	a0,0x4
    2b8a:	3ea50513          	addi	a0,a0,1002 # 6f70 <malloc+0x1304>
    2b8e:	44d020ef          	jal	57da <mkdir>
    2b92:	2e051263          	bnez	a0,2e76 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2b96:	20200593          	li	a1,514
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	3f650513          	addi	a0,a0,1014 # 6f90 <malloc+0x1324>
    2ba2:	411020ef          	jal	57b2 <open>
    2ba6:	84aa                	mv	s1,a0
  if (fd < 0) {
    2ba8:	2e054163          	bltz	a0,2e8a <subdir+0x31e>
  write(fd, "ff", 2);
    2bac:	4609                	li	a2,2
    2bae:	00004597          	auipc	a1,0x4
    2bb2:	4f258593          	addi	a1,a1,1266 # 70a0 <malloc+0x1434>
    2bb6:	3dd020ef          	jal	5792 <write>
  close(fd);
    2bba:	8526                	mv	a0,s1
    2bbc:	3df020ef          	jal	579a <close>
  if (unlink("dd") >= 0) {
    2bc0:	00004517          	auipc	a0,0x4
    2bc4:	3b050513          	addi	a0,a0,944 # 6f70 <malloc+0x1304>
    2bc8:	3fb020ef          	jal	57c2 <unlink>
    2bcc:	2c055963          	bgez	a0,2e9e <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	41850513          	addi	a0,a0,1048 # 6fe8 <malloc+0x137c>
    2bd8:	403020ef          	jal	57da <mkdir>
    2bdc:	2c051b63          	bnez	a0,2eb2 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2be0:	20200593          	li	a1,514
    2be4:	00004517          	auipc	a0,0x4
    2be8:	42c50513          	addi	a0,a0,1068 # 7010 <malloc+0x13a4>
    2bec:	3c7020ef          	jal	57b2 <open>
    2bf0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bf2:	2c054a63          	bltz	a0,2ec6 <subdir+0x35a>
  write(fd, "FF", 2);
    2bf6:	4609                	li	a2,2
    2bf8:	00004597          	auipc	a1,0x4
    2bfc:	44858593          	addi	a1,a1,1096 # 7040 <malloc+0x13d4>
    2c00:	393020ef          	jal	5792 <write>
  close(fd);
    2c04:	8526                	mv	a0,s1
    2c06:	395020ef          	jal	579a <close>
  fd = open("dd/dd/../ff", 0);
    2c0a:	4581                	li	a1,0
    2c0c:	00004517          	auipc	a0,0x4
    2c10:	43c50513          	addi	a0,a0,1084 # 7048 <malloc+0x13dc>
    2c14:	39f020ef          	jal	57b2 <open>
    2c18:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c1a:	2c054063          	bltz	a0,2eda <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c1e:	660d                	lui	a2,0x3
    2c20:	0000a597          	auipc	a1,0xa
    2c24:	0d858593          	addi	a1,a1,216 # ccf8 <buf>
    2c28:	363020ef          	jal	578a <read>
  if (cc != 2 || buf[0] != 'f') {
    2c2c:	4789                	li	a5,2
    2c2e:	2cf51063          	bne	a0,a5,2eee <subdir+0x382>
    2c32:	0000a717          	auipc	a4,0xa
    2c36:	0c674703          	lbu	a4,198(a4) # ccf8 <buf>
    2c3a:	06600793          	li	a5,102
    2c3e:	2af71863          	bne	a4,a5,2eee <subdir+0x382>
  close(fd);
    2c42:	8526                	mv	a0,s1
    2c44:	357020ef          	jal	579a <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c48:	00004597          	auipc	a1,0x4
    2c4c:	45058593          	addi	a1,a1,1104 # 7098 <malloc+0x142c>
    2c50:	00004517          	auipc	a0,0x4
    2c54:	3c050513          	addi	a0,a0,960 # 7010 <malloc+0x13a4>
    2c58:	37b020ef          	jal	57d2 <link>
    2c5c:	2a051363          	bnez	a0,2f02 <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c60:	00004517          	auipc	a0,0x4
    2c64:	3b050513          	addi	a0,a0,944 # 7010 <malloc+0x13a4>
    2c68:	35b020ef          	jal	57c2 <unlink>
    2c6c:	2a051563          	bnez	a0,2f16 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c70:	4581                	li	a1,0
    2c72:	00004517          	auipc	a0,0x4
    2c76:	39e50513          	addi	a0,a0,926 # 7010 <malloc+0x13a4>
    2c7a:	339020ef          	jal	57b2 <open>
    2c7e:	2a055663          	bgez	a0,2f2a <subdir+0x3be>
  if (chdir("dd") != 0) {
    2c82:	00004517          	auipc	a0,0x4
    2c86:	2ee50513          	addi	a0,a0,750 # 6f70 <malloc+0x1304>
    2c8a:	359020ef          	jal	57e2 <chdir>
    2c8e:	2a051863          	bnez	a0,2f3e <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2c92:	00004517          	auipc	a0,0x4
    2c96:	49e50513          	addi	a0,a0,1182 # 7130 <malloc+0x14c4>
    2c9a:	349020ef          	jal	57e2 <chdir>
    2c9e:	2a051a63          	bnez	a0,2f52 <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2ca2:	00004517          	auipc	a0,0x4
    2ca6:	4be50513          	addi	a0,a0,1214 # 7160 <malloc+0x14f4>
    2caa:	339020ef          	jal	57e2 <chdir>
    2cae:	2a051c63          	bnez	a0,2f66 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	4e650513          	addi	a0,a0,1254 # 7198 <malloc+0x152c>
    2cba:	329020ef          	jal	57e2 <chdir>
    2cbe:	2a051e63          	bnez	a0,2f7a <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cc2:	4581                	li	a1,0
    2cc4:	00004517          	auipc	a0,0x4
    2cc8:	3d450513          	addi	a0,a0,980 # 7098 <malloc+0x142c>
    2ccc:	2e7020ef          	jal	57b2 <open>
    2cd0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cd2:	2a054e63          	bltz	a0,2f8e <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cd6:	660d                	lui	a2,0x3
    2cd8:	0000a597          	auipc	a1,0xa
    2cdc:	02058593          	addi	a1,a1,32 # ccf8 <buf>
    2ce0:	2ab020ef          	jal	578a <read>
    2ce4:	4789                	li	a5,2
    2ce6:	2af51e63          	bne	a0,a5,2fa2 <subdir+0x436>
  close(fd);
    2cea:	8526                	mv	a0,s1
    2cec:	2af020ef          	jal	579a <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2cf0:	4581                	li	a1,0
    2cf2:	00004517          	auipc	a0,0x4
    2cf6:	31e50513          	addi	a0,a0,798 # 7010 <malloc+0x13a4>
    2cfa:	2b9020ef          	jal	57b2 <open>
    2cfe:	2a055c63          	bgez	a0,2fb6 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d02:	20200593          	li	a1,514
    2d06:	00004517          	auipc	a0,0x4
    2d0a:	52250513          	addi	a0,a0,1314 # 7228 <malloc+0x15bc>
    2d0e:	2a5020ef          	jal	57b2 <open>
    2d12:	2a055c63          	bgez	a0,2fca <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d16:	20200593          	li	a1,514
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	53e50513          	addi	a0,a0,1342 # 7258 <malloc+0x15ec>
    2d22:	291020ef          	jal	57b2 <open>
    2d26:	2a055c63          	bgez	a0,2fde <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d2a:	20000593          	li	a1,512
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	24250513          	addi	a0,a0,578 # 6f70 <malloc+0x1304>
    2d36:	27d020ef          	jal	57b2 <open>
    2d3a:	2a055c63          	bgez	a0,2ff2 <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d3e:	4589                	li	a1,2
    2d40:	00004517          	auipc	a0,0x4
    2d44:	23050513          	addi	a0,a0,560 # 6f70 <malloc+0x1304>
    2d48:	26b020ef          	jal	57b2 <open>
    2d4c:	2a055d63          	bgez	a0,3006 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d50:	4585                	li	a1,1
    2d52:	00004517          	auipc	a0,0x4
    2d56:	21e50513          	addi	a0,a0,542 # 6f70 <malloc+0x1304>
    2d5a:	259020ef          	jal	57b2 <open>
    2d5e:	2a055e63          	bgez	a0,301a <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d62:	00004597          	auipc	a1,0x4
    2d66:	58658593          	addi	a1,a1,1414 # 72e8 <malloc+0x167c>
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	4be50513          	addi	a0,a0,1214 # 7228 <malloc+0x15bc>
    2d72:	261020ef          	jal	57d2 <link>
    2d76:	2a050c63          	beqz	a0,302e <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d7a:	00004597          	auipc	a1,0x4
    2d7e:	56e58593          	addi	a1,a1,1390 # 72e8 <malloc+0x167c>
    2d82:	00004517          	auipc	a0,0x4
    2d86:	4d650513          	addi	a0,a0,1238 # 7258 <malloc+0x15ec>
    2d8a:	249020ef          	jal	57d2 <link>
    2d8e:	2a050a63          	beqz	a0,3042 <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2d92:	00004597          	auipc	a1,0x4
    2d96:	30658593          	addi	a1,a1,774 # 7098 <malloc+0x142c>
    2d9a:	00004517          	auipc	a0,0x4
    2d9e:	1f650513          	addi	a0,a0,502 # 6f90 <malloc+0x1324>
    2da2:	231020ef          	jal	57d2 <link>
    2da6:	2a050863          	beqz	a0,3056 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2daa:	00004517          	auipc	a0,0x4
    2dae:	47e50513          	addi	a0,a0,1150 # 7228 <malloc+0x15bc>
    2db2:	229020ef          	jal	57da <mkdir>
    2db6:	2a050a63          	beqz	a0,306a <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dba:	00004517          	auipc	a0,0x4
    2dbe:	49e50513          	addi	a0,a0,1182 # 7258 <malloc+0x15ec>
    2dc2:	219020ef          	jal	57da <mkdir>
    2dc6:	2a050c63          	beqz	a0,307e <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2dca:	00004517          	auipc	a0,0x4
    2dce:	2ce50513          	addi	a0,a0,718 # 7098 <malloc+0x142c>
    2dd2:	209020ef          	jal	57da <mkdir>
    2dd6:	2a050e63          	beqz	a0,3092 <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2dda:	00004517          	auipc	a0,0x4
    2dde:	47e50513          	addi	a0,a0,1150 # 7258 <malloc+0x15ec>
    2de2:	1e1020ef          	jal	57c2 <unlink>
    2de6:	2c050063          	beqz	a0,30a6 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2dea:	00004517          	auipc	a0,0x4
    2dee:	43e50513          	addi	a0,a0,1086 # 7228 <malloc+0x15bc>
    2df2:	1d1020ef          	jal	57c2 <unlink>
    2df6:	2c050263          	beqz	a0,30ba <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2dfa:	00004517          	auipc	a0,0x4
    2dfe:	19650513          	addi	a0,a0,406 # 6f90 <malloc+0x1324>
    2e02:	1e1020ef          	jal	57e2 <chdir>
    2e06:	2c050463          	beqz	a0,30ce <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	62e50513          	addi	a0,a0,1582 # 7438 <malloc+0x17cc>
    2e12:	1d1020ef          	jal	57e2 <chdir>
    2e16:	2c050663          	beqz	a0,30e2 <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e1a:	00004517          	auipc	a0,0x4
    2e1e:	27e50513          	addi	a0,a0,638 # 7098 <malloc+0x142c>
    2e22:	1a1020ef          	jal	57c2 <unlink>
    2e26:	2c051863          	bnez	a0,30f6 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	16650513          	addi	a0,a0,358 # 6f90 <malloc+0x1324>
    2e32:	191020ef          	jal	57c2 <unlink>
    2e36:	2c051a63          	bnez	a0,310a <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e3a:	00004517          	auipc	a0,0x4
    2e3e:	13650513          	addi	a0,a0,310 # 6f70 <malloc+0x1304>
    2e42:	181020ef          	jal	57c2 <unlink>
    2e46:	2c050c63          	beqz	a0,311e <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e4a:	00004517          	auipc	a0,0x4
    2e4e:	65e50513          	addi	a0,a0,1630 # 74a8 <malloc+0x183c>
    2e52:	171020ef          	jal	57c2 <unlink>
    2e56:	2c054e63          	bltz	a0,3132 <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	11650513          	addi	a0,a0,278 # 6f70 <malloc+0x1304>
    2e62:	161020ef          	jal	57c2 <unlink>
    2e66:	2e054063          	bltz	a0,3146 <subdir+0x5da>
}
    2e6a:	60e2                	ld	ra,24(sp)
    2e6c:	6442                	ld	s0,16(sp)
    2e6e:	64a2                	ld	s1,8(sp)
    2e70:	6902                	ld	s2,0(sp)
    2e72:	6105                	addi	sp,sp,32
    2e74:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e76:	85ca                	mv	a1,s2
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	10050513          	addi	a0,a0,256 # 6f78 <malloc+0x130c>
    2e80:	535020ef          	jal	5bb4 <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	0ed020ef          	jal	5772 <exit>
    printf("%s: create dd/ff failed\n", s);
    2e8a:	85ca                	mv	a1,s2
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	10c50513          	addi	a0,a0,268 # 6f98 <malloc+0x132c>
    2e94:	521020ef          	jal	5bb4 <printf>
    exit(1);
    2e98:	4505                	li	a0,1
    2e9a:	0d9020ef          	jal	5772 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2e9e:	85ca                	mv	a1,s2
    2ea0:	00004517          	auipc	a0,0x4
    2ea4:	11850513          	addi	a0,a0,280 # 6fb8 <malloc+0x134c>
    2ea8:	50d020ef          	jal	5bb4 <printf>
    exit(1);
    2eac:	4505                	li	a0,1
    2eae:	0c5020ef          	jal	5772 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2eb2:	85ca                	mv	a1,s2
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	13c50513          	addi	a0,a0,316 # 6ff0 <malloc+0x1384>
    2ebc:	4f9020ef          	jal	5bb4 <printf>
    exit(1);
    2ec0:	4505                	li	a0,1
    2ec2:	0b1020ef          	jal	5772 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	15850513          	addi	a0,a0,344 # 7020 <malloc+0x13b4>
    2ed0:	4e5020ef          	jal	5bb4 <printf>
    exit(1);
    2ed4:	4505                	li	a0,1
    2ed6:	09d020ef          	jal	5772 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2eda:	85ca                	mv	a1,s2
    2edc:	00004517          	auipc	a0,0x4
    2ee0:	17c50513          	addi	a0,a0,380 # 7058 <malloc+0x13ec>
    2ee4:	4d1020ef          	jal	5bb4 <printf>
    exit(1);
    2ee8:	4505                	li	a0,1
    2eea:	089020ef          	jal	5772 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2eee:	85ca                	mv	a1,s2
    2ef0:	00004517          	auipc	a0,0x4
    2ef4:	18850513          	addi	a0,a0,392 # 7078 <malloc+0x140c>
    2ef8:	4bd020ef          	jal	5bb4 <printf>
    exit(1);
    2efc:	4505                	li	a0,1
    2efe:	075020ef          	jal	5772 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f02:	85ca                	mv	a1,s2
    2f04:	00004517          	auipc	a0,0x4
    2f08:	1a450513          	addi	a0,a0,420 # 70a8 <malloc+0x143c>
    2f0c:	4a9020ef          	jal	5bb4 <printf>
    exit(1);
    2f10:	4505                	li	a0,1
    2f12:	061020ef          	jal	5772 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f16:	85ca                	mv	a1,s2
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	1b850513          	addi	a0,a0,440 # 70d0 <malloc+0x1464>
    2f20:	495020ef          	jal	5bb4 <printf>
    exit(1);
    2f24:	4505                	li	a0,1
    2f26:	04d020ef          	jal	5772 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f2a:	85ca                	mv	a1,s2
    2f2c:	00004517          	auipc	a0,0x4
    2f30:	1c450513          	addi	a0,a0,452 # 70f0 <malloc+0x1484>
    2f34:	481020ef          	jal	5bb4 <printf>
    exit(1);
    2f38:	4505                	li	a0,1
    2f3a:	039020ef          	jal	5772 <exit>
    printf("%s: chdir dd failed\n", s);
    2f3e:	85ca                	mv	a1,s2
    2f40:	00004517          	auipc	a0,0x4
    2f44:	1d850513          	addi	a0,a0,472 # 7118 <malloc+0x14ac>
    2f48:	46d020ef          	jal	5bb4 <printf>
    exit(1);
    2f4c:	4505                	li	a0,1
    2f4e:	025020ef          	jal	5772 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f52:	85ca                	mv	a1,s2
    2f54:	00004517          	auipc	a0,0x4
    2f58:	1ec50513          	addi	a0,a0,492 # 7140 <malloc+0x14d4>
    2f5c:	459020ef          	jal	5bb4 <printf>
    exit(1);
    2f60:	4505                	li	a0,1
    2f62:	011020ef          	jal	5772 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f66:	85ca                	mv	a1,s2
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	20850513          	addi	a0,a0,520 # 7170 <malloc+0x1504>
    2f70:	445020ef          	jal	5bb4 <printf>
    exit(1);
    2f74:	4505                	li	a0,1
    2f76:	7fc020ef          	jal	5772 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f7a:	85ca                	mv	a1,s2
    2f7c:	00004517          	auipc	a0,0x4
    2f80:	22450513          	addi	a0,a0,548 # 71a0 <malloc+0x1534>
    2f84:	431020ef          	jal	5bb4 <printf>
    exit(1);
    2f88:	4505                	li	a0,1
    2f8a:	7e8020ef          	jal	5772 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f8e:	85ca                	mv	a1,s2
    2f90:	00004517          	auipc	a0,0x4
    2f94:	22850513          	addi	a0,a0,552 # 71b8 <malloc+0x154c>
    2f98:	41d020ef          	jal	5bb4 <printf>
    exit(1);
    2f9c:	4505                	li	a0,1
    2f9e:	7d4020ef          	jal	5772 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fa2:	85ca                	mv	a1,s2
    2fa4:	00004517          	auipc	a0,0x4
    2fa8:	23450513          	addi	a0,a0,564 # 71d8 <malloc+0x156c>
    2fac:	409020ef          	jal	5bb4 <printf>
    exit(1);
    2fb0:	4505                	li	a0,1
    2fb2:	7c0020ef          	jal	5772 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fb6:	85ca                	mv	a1,s2
    2fb8:	00004517          	auipc	a0,0x4
    2fbc:	24050513          	addi	a0,a0,576 # 71f8 <malloc+0x158c>
    2fc0:	3f5020ef          	jal	5bb4 <printf>
    exit(1);
    2fc4:	4505                	li	a0,1
    2fc6:	7ac020ef          	jal	5772 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fca:	85ca                	mv	a1,s2
    2fcc:	00004517          	auipc	a0,0x4
    2fd0:	26c50513          	addi	a0,a0,620 # 7238 <malloc+0x15cc>
    2fd4:	3e1020ef          	jal	5bb4 <printf>
    exit(1);
    2fd8:	4505                	li	a0,1
    2fda:	798020ef          	jal	5772 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2fde:	85ca                	mv	a1,s2
    2fe0:	00004517          	auipc	a0,0x4
    2fe4:	28850513          	addi	a0,a0,648 # 7268 <malloc+0x15fc>
    2fe8:	3cd020ef          	jal	5bb4 <printf>
    exit(1);
    2fec:	4505                	li	a0,1
    2fee:	784020ef          	jal	5772 <exit>
    printf("%s: create dd succeeded!\n", s);
    2ff2:	85ca                	mv	a1,s2
    2ff4:	00004517          	auipc	a0,0x4
    2ff8:	29450513          	addi	a0,a0,660 # 7288 <malloc+0x161c>
    2ffc:	3b9020ef          	jal	5bb4 <printf>
    exit(1);
    3000:	4505                	li	a0,1
    3002:	770020ef          	jal	5772 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3006:	85ca                	mv	a1,s2
    3008:	00004517          	auipc	a0,0x4
    300c:	2a050513          	addi	a0,a0,672 # 72a8 <malloc+0x163c>
    3010:	3a5020ef          	jal	5bb4 <printf>
    exit(1);
    3014:	4505                	li	a0,1
    3016:	75c020ef          	jal	5772 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    301a:	85ca                	mv	a1,s2
    301c:	00004517          	auipc	a0,0x4
    3020:	2ac50513          	addi	a0,a0,684 # 72c8 <malloc+0x165c>
    3024:	391020ef          	jal	5bb4 <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	748020ef          	jal	5772 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    302e:	85ca                	mv	a1,s2
    3030:	00004517          	auipc	a0,0x4
    3034:	2c850513          	addi	a0,a0,712 # 72f8 <malloc+0x168c>
    3038:	37d020ef          	jal	5bb4 <printf>
    exit(1);
    303c:	4505                	li	a0,1
    303e:	734020ef          	jal	5772 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3042:	85ca                	mv	a1,s2
    3044:	00004517          	auipc	a0,0x4
    3048:	2dc50513          	addi	a0,a0,732 # 7320 <malloc+0x16b4>
    304c:	369020ef          	jal	5bb4 <printf>
    exit(1);
    3050:	4505                	li	a0,1
    3052:	720020ef          	jal	5772 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3056:	85ca                	mv	a1,s2
    3058:	00004517          	auipc	a0,0x4
    305c:	2f050513          	addi	a0,a0,752 # 7348 <malloc+0x16dc>
    3060:	355020ef          	jal	5bb4 <printf>
    exit(1);
    3064:	4505                	li	a0,1
    3066:	70c020ef          	jal	5772 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    306a:	85ca                	mv	a1,s2
    306c:	00004517          	auipc	a0,0x4
    3070:	30450513          	addi	a0,a0,772 # 7370 <malloc+0x1704>
    3074:	341020ef          	jal	5bb4 <printf>
    exit(1);
    3078:	4505                	li	a0,1
    307a:	6f8020ef          	jal	5772 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    307e:	85ca                	mv	a1,s2
    3080:	00004517          	auipc	a0,0x4
    3084:	31050513          	addi	a0,a0,784 # 7390 <malloc+0x1724>
    3088:	32d020ef          	jal	5bb4 <printf>
    exit(1);
    308c:	4505                	li	a0,1
    308e:	6e4020ef          	jal	5772 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3092:	85ca                	mv	a1,s2
    3094:	00004517          	auipc	a0,0x4
    3098:	31c50513          	addi	a0,a0,796 # 73b0 <malloc+0x1744>
    309c:	319020ef          	jal	5bb4 <printf>
    exit(1);
    30a0:	4505                	li	a0,1
    30a2:	6d0020ef          	jal	5772 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a6:	85ca                	mv	a1,s2
    30a8:	00004517          	auipc	a0,0x4
    30ac:	33050513          	addi	a0,a0,816 # 73d8 <malloc+0x176c>
    30b0:	305020ef          	jal	5bb4 <printf>
    exit(1);
    30b4:	4505                	li	a0,1
    30b6:	6bc020ef          	jal	5772 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30ba:	85ca                	mv	a1,s2
    30bc:	00004517          	auipc	a0,0x4
    30c0:	33c50513          	addi	a0,a0,828 # 73f8 <malloc+0x178c>
    30c4:	2f1020ef          	jal	5bb4 <printf>
    exit(1);
    30c8:	4505                	li	a0,1
    30ca:	6a8020ef          	jal	5772 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30ce:	85ca                	mv	a1,s2
    30d0:	00004517          	auipc	a0,0x4
    30d4:	34850513          	addi	a0,a0,840 # 7418 <malloc+0x17ac>
    30d8:	2dd020ef          	jal	5bb4 <printf>
    exit(1);
    30dc:	4505                	li	a0,1
    30de:	694020ef          	jal	5772 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30e2:	85ca                	mv	a1,s2
    30e4:	00004517          	auipc	a0,0x4
    30e8:	35c50513          	addi	a0,a0,860 # 7440 <malloc+0x17d4>
    30ec:	2c9020ef          	jal	5bb4 <printf>
    exit(1);
    30f0:	4505                	li	a0,1
    30f2:	680020ef          	jal	5772 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30f6:	85ca                	mv	a1,s2
    30f8:	00004517          	auipc	a0,0x4
    30fc:	fd850513          	addi	a0,a0,-40 # 70d0 <malloc+0x1464>
    3100:	2b5020ef          	jal	5bb4 <printf>
    exit(1);
    3104:	4505                	li	a0,1
    3106:	66c020ef          	jal	5772 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    310a:	85ca                	mv	a1,s2
    310c:	00004517          	auipc	a0,0x4
    3110:	35450513          	addi	a0,a0,852 # 7460 <malloc+0x17f4>
    3114:	2a1020ef          	jal	5bb4 <printf>
    exit(1);
    3118:	4505                	li	a0,1
    311a:	658020ef          	jal	5772 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    311e:	85ca                	mv	a1,s2
    3120:	00004517          	auipc	a0,0x4
    3124:	36050513          	addi	a0,a0,864 # 7480 <malloc+0x1814>
    3128:	28d020ef          	jal	5bb4 <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	644020ef          	jal	5772 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3132:	85ca                	mv	a1,s2
    3134:	00004517          	auipc	a0,0x4
    3138:	37c50513          	addi	a0,a0,892 # 74b0 <malloc+0x1844>
    313c:	279020ef          	jal	5bb4 <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	630020ef          	jal	5772 <exit>
    printf("%s: unlink dd failed\n", s);
    3146:	85ca                	mv	a1,s2
    3148:	00004517          	auipc	a0,0x4
    314c:	38850513          	addi	a0,a0,904 # 74d0 <malloc+0x1864>
    3150:	265020ef          	jal	5bb4 <printf>
    exit(1);
    3154:	4505                	li	a0,1
    3156:	61c020ef          	jal	5772 <exit>

000000000000315a <rmdot>:
{
    315a:	1101                	addi	sp,sp,-32
    315c:	ec06                	sd	ra,24(sp)
    315e:	e822                	sd	s0,16(sp)
    3160:	e426                	sd	s1,8(sp)
    3162:	1000                	addi	s0,sp,32
    3164:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3166:	00004517          	auipc	a0,0x4
    316a:	38250513          	addi	a0,a0,898 # 74e8 <malloc+0x187c>
    316e:	66c020ef          	jal	57da <mkdir>
    3172:	e53d                	bnez	a0,31e0 <rmdot+0x86>
  if (chdir("dots") != 0) {
    3174:	00004517          	auipc	a0,0x4
    3178:	37450513          	addi	a0,a0,884 # 74e8 <malloc+0x187c>
    317c:	666020ef          	jal	57e2 <chdir>
    3180:	e935                	bnez	a0,31f4 <rmdot+0x9a>
  if (unlink(".") == 0) {
    3182:	00003517          	auipc	a0,0x3
    3186:	2fe50513          	addi	a0,a0,766 # 6480 <malloc+0x814>
    318a:	638020ef          	jal	57c2 <unlink>
    318e:	cd2d                	beqz	a0,3208 <rmdot+0xae>
  if (unlink("..") == 0) {
    3190:	00004517          	auipc	a0,0x4
    3194:	da850513          	addi	a0,a0,-600 # 6f38 <malloc+0x12cc>
    3198:	62a020ef          	jal	57c2 <unlink>
    319c:	c141                	beqz	a0,321c <rmdot+0xc2>
  if (chdir("/") != 0) {
    319e:	00004517          	auipc	a0,0x4
    31a2:	d4250513          	addi	a0,a0,-702 # 6ee0 <malloc+0x1274>
    31a6:	63c020ef          	jal	57e2 <chdir>
    31aa:	e159                	bnez	a0,3230 <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31ac:	00004517          	auipc	a0,0x4
    31b0:	3a450513          	addi	a0,a0,932 # 7550 <malloc+0x18e4>
    31b4:	60e020ef          	jal	57c2 <unlink>
    31b8:	c551                	beqz	a0,3244 <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31ba:	00004517          	auipc	a0,0x4
    31be:	3be50513          	addi	a0,a0,958 # 7578 <malloc+0x190c>
    31c2:	600020ef          	jal	57c2 <unlink>
    31c6:	c949                	beqz	a0,3258 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31c8:	00004517          	auipc	a0,0x4
    31cc:	32050513          	addi	a0,a0,800 # 74e8 <malloc+0x187c>
    31d0:	5f2020ef          	jal	57c2 <unlink>
    31d4:	ed41                	bnez	a0,326c <rmdot+0x112>
}
    31d6:	60e2                	ld	ra,24(sp)
    31d8:	6442                	ld	s0,16(sp)
    31da:	64a2                	ld	s1,8(sp)
    31dc:	6105                	addi	sp,sp,32
    31de:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31e0:	85a6                	mv	a1,s1
    31e2:	00004517          	auipc	a0,0x4
    31e6:	30e50513          	addi	a0,a0,782 # 74f0 <malloc+0x1884>
    31ea:	1cb020ef          	jal	5bb4 <printf>
    exit(1);
    31ee:	4505                	li	a0,1
    31f0:	582020ef          	jal	5772 <exit>
    printf("%s: chdir dots failed\n", s);
    31f4:	85a6                	mv	a1,s1
    31f6:	00004517          	auipc	a0,0x4
    31fa:	31250513          	addi	a0,a0,786 # 7508 <malloc+0x189c>
    31fe:	1b7020ef          	jal	5bb4 <printf>
    exit(1);
    3202:	4505                	li	a0,1
    3204:	56e020ef          	jal	5772 <exit>
    printf("%s: rm . worked!\n", s);
    3208:	85a6                	mv	a1,s1
    320a:	00004517          	auipc	a0,0x4
    320e:	31650513          	addi	a0,a0,790 # 7520 <malloc+0x18b4>
    3212:	1a3020ef          	jal	5bb4 <printf>
    exit(1);
    3216:	4505                	li	a0,1
    3218:	55a020ef          	jal	5772 <exit>
    printf("%s: rm .. worked!\n", s);
    321c:	85a6                	mv	a1,s1
    321e:	00004517          	auipc	a0,0x4
    3222:	31a50513          	addi	a0,a0,794 # 7538 <malloc+0x18cc>
    3226:	18f020ef          	jal	5bb4 <printf>
    exit(1);
    322a:	4505                	li	a0,1
    322c:	546020ef          	jal	5772 <exit>
    printf("%s: chdir / failed\n", s);
    3230:	85a6                	mv	a1,s1
    3232:	00004517          	auipc	a0,0x4
    3236:	cb650513          	addi	a0,a0,-842 # 6ee8 <malloc+0x127c>
    323a:	17b020ef          	jal	5bb4 <printf>
    exit(1);
    323e:	4505                	li	a0,1
    3240:	532020ef          	jal	5772 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3244:	85a6                	mv	a1,s1
    3246:	00004517          	auipc	a0,0x4
    324a:	31250513          	addi	a0,a0,786 # 7558 <malloc+0x18ec>
    324e:	167020ef          	jal	5bb4 <printf>
    exit(1);
    3252:	4505                	li	a0,1
    3254:	51e020ef          	jal	5772 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3258:	85a6                	mv	a1,s1
    325a:	00004517          	auipc	a0,0x4
    325e:	32650513          	addi	a0,a0,806 # 7580 <malloc+0x1914>
    3262:	153020ef          	jal	5bb4 <printf>
    exit(1);
    3266:	4505                	li	a0,1
    3268:	50a020ef          	jal	5772 <exit>
    printf("%s: unlink dots failed!\n", s);
    326c:	85a6                	mv	a1,s1
    326e:	00004517          	auipc	a0,0x4
    3272:	33250513          	addi	a0,a0,818 # 75a0 <malloc+0x1934>
    3276:	13f020ef          	jal	5bb4 <printf>
    exit(1);
    327a:	4505                	li	a0,1
    327c:	4f6020ef          	jal	5772 <exit>

0000000000003280 <dirfile>:
{
    3280:	1101                	addi	sp,sp,-32
    3282:	ec06                	sd	ra,24(sp)
    3284:	e822                	sd	s0,16(sp)
    3286:	e426                	sd	s1,8(sp)
    3288:	e04a                	sd	s2,0(sp)
    328a:	1000                	addi	s0,sp,32
    328c:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    328e:	20000593          	li	a1,512
    3292:	00004517          	auipc	a0,0x4
    3296:	32e50513          	addi	a0,a0,814 # 75c0 <malloc+0x1954>
    329a:	518020ef          	jal	57b2 <open>
  if (fd < 0) {
    329e:	0c054563          	bltz	a0,3368 <dirfile+0xe8>
  close(fd);
    32a2:	4f8020ef          	jal	579a <close>
  if (chdir("dirfile") == 0) {
    32a6:	00004517          	auipc	a0,0x4
    32aa:	31a50513          	addi	a0,a0,794 # 75c0 <malloc+0x1954>
    32ae:	534020ef          	jal	57e2 <chdir>
    32b2:	c569                	beqz	a0,337c <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32b4:	4581                	li	a1,0
    32b6:	00004517          	auipc	a0,0x4
    32ba:	35250513          	addi	a0,a0,850 # 7608 <malloc+0x199c>
    32be:	4f4020ef          	jal	57b2 <open>
  if (fd >= 0) {
    32c2:	0c055763          	bgez	a0,3390 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32c6:	20000593          	li	a1,512
    32ca:	00004517          	auipc	a0,0x4
    32ce:	33e50513          	addi	a0,a0,830 # 7608 <malloc+0x199c>
    32d2:	4e0020ef          	jal	57b2 <open>
  if (fd >= 0) {
    32d6:	0c055763          	bgez	a0,33a4 <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32da:	00004517          	auipc	a0,0x4
    32de:	32e50513          	addi	a0,a0,814 # 7608 <malloc+0x199c>
    32e2:	4f8020ef          	jal	57da <mkdir>
    32e6:	0c050963          	beqz	a0,33b8 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    32ea:	00004517          	auipc	a0,0x4
    32ee:	31e50513          	addi	a0,a0,798 # 7608 <malloc+0x199c>
    32f2:	4d0020ef          	jal	57c2 <unlink>
    32f6:	0c050b63          	beqz	a0,33cc <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    32fa:	00004597          	auipc	a1,0x4
    32fe:	30e58593          	addi	a1,a1,782 # 7608 <malloc+0x199c>
    3302:	00003517          	auipc	a0,0x3
    3306:	c6e50513          	addi	a0,a0,-914 # 5f70 <malloc+0x304>
    330a:	4c8020ef          	jal	57d2 <link>
    330e:	0c050963          	beqz	a0,33e0 <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    3312:	00004517          	auipc	a0,0x4
    3316:	2ae50513          	addi	a0,a0,686 # 75c0 <malloc+0x1954>
    331a:	4a8020ef          	jal	57c2 <unlink>
    331e:	0c051b63          	bnez	a0,33f4 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3322:	4589                	li	a1,2
    3324:	00003517          	auipc	a0,0x3
    3328:	15c50513          	addi	a0,a0,348 # 6480 <malloc+0x814>
    332c:	486020ef          	jal	57b2 <open>
  if (fd >= 0) {
    3330:	0c055c63          	bgez	a0,3408 <dirfile+0x188>
  fd = open(".", 0);
    3334:	4581                	li	a1,0
    3336:	00003517          	auipc	a0,0x3
    333a:	14a50513          	addi	a0,a0,330 # 6480 <malloc+0x814>
    333e:	474020ef          	jal	57b2 <open>
    3342:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    3344:	4605                	li	a2,1
    3346:	00003597          	auipc	a1,0x3
    334a:	ac258593          	addi	a1,a1,-1342 # 5e08 <malloc+0x19c>
    334e:	444020ef          	jal	5792 <write>
    3352:	0ca04563          	bgtz	a0,341c <dirfile+0x19c>
  close(fd);
    3356:	8526                	mv	a0,s1
    3358:	442020ef          	jal	579a <close>
}
    335c:	60e2                	ld	ra,24(sp)
    335e:	6442                	ld	s0,16(sp)
    3360:	64a2                	ld	s1,8(sp)
    3362:	6902                	ld	s2,0(sp)
    3364:	6105                	addi	sp,sp,32
    3366:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3368:	85ca                	mv	a1,s2
    336a:	00004517          	auipc	a0,0x4
    336e:	25e50513          	addi	a0,a0,606 # 75c8 <malloc+0x195c>
    3372:	043020ef          	jal	5bb4 <printf>
    exit(1);
    3376:	4505                	li	a0,1
    3378:	3fa020ef          	jal	5772 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    337c:	85ca                	mv	a1,s2
    337e:	00004517          	auipc	a0,0x4
    3382:	26a50513          	addi	a0,a0,618 # 75e8 <malloc+0x197c>
    3386:	02f020ef          	jal	5bb4 <printf>
    exit(1);
    338a:	4505                	li	a0,1
    338c:	3e6020ef          	jal	5772 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3390:	85ca                	mv	a1,s2
    3392:	00004517          	auipc	a0,0x4
    3396:	28650513          	addi	a0,a0,646 # 7618 <malloc+0x19ac>
    339a:	01b020ef          	jal	5bb4 <printf>
    exit(1);
    339e:	4505                	li	a0,1
    33a0:	3d2020ef          	jal	5772 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33a4:	85ca                	mv	a1,s2
    33a6:	00004517          	auipc	a0,0x4
    33aa:	27250513          	addi	a0,a0,626 # 7618 <malloc+0x19ac>
    33ae:	007020ef          	jal	5bb4 <printf>
    exit(1);
    33b2:	4505                	li	a0,1
    33b4:	3be020ef          	jal	5772 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33b8:	85ca                	mv	a1,s2
    33ba:	00004517          	auipc	a0,0x4
    33be:	28650513          	addi	a0,a0,646 # 7640 <malloc+0x19d4>
    33c2:	7f2020ef          	jal	5bb4 <printf>
    exit(1);
    33c6:	4505                	li	a0,1
    33c8:	3aa020ef          	jal	5772 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33cc:	85ca                	mv	a1,s2
    33ce:	00004517          	auipc	a0,0x4
    33d2:	29a50513          	addi	a0,a0,666 # 7668 <malloc+0x19fc>
    33d6:	7de020ef          	jal	5bb4 <printf>
    exit(1);
    33da:	4505                	li	a0,1
    33dc:	396020ef          	jal	5772 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33e0:	85ca                	mv	a1,s2
    33e2:	00004517          	auipc	a0,0x4
    33e6:	2ae50513          	addi	a0,a0,686 # 7690 <malloc+0x1a24>
    33ea:	7ca020ef          	jal	5bb4 <printf>
    exit(1);
    33ee:	4505                	li	a0,1
    33f0:	382020ef          	jal	5772 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    33f4:	85ca                	mv	a1,s2
    33f6:	00004517          	auipc	a0,0x4
    33fa:	2c250513          	addi	a0,a0,706 # 76b8 <malloc+0x1a4c>
    33fe:	7b6020ef          	jal	5bb4 <printf>
    exit(1);
    3402:	4505                	li	a0,1
    3404:	36e020ef          	jal	5772 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3408:	85ca                	mv	a1,s2
    340a:	00004517          	auipc	a0,0x4
    340e:	2ce50513          	addi	a0,a0,718 # 76d8 <malloc+0x1a6c>
    3412:	7a2020ef          	jal	5bb4 <printf>
    exit(1);
    3416:	4505                	li	a0,1
    3418:	35a020ef          	jal	5772 <exit>
    printf("%s: write . succeeded!\n", s);
    341c:	85ca                	mv	a1,s2
    341e:	00004517          	auipc	a0,0x4
    3422:	2e250513          	addi	a0,a0,738 # 7700 <malloc+0x1a94>
    3426:	78e020ef          	jal	5bb4 <printf>
    exit(1);
    342a:	4505                	li	a0,1
    342c:	346020ef          	jal	5772 <exit>

0000000000003430 <iref>:
{
    3430:	715d                	addi	sp,sp,-80
    3432:	e486                	sd	ra,72(sp)
    3434:	e0a2                	sd	s0,64(sp)
    3436:	fc26                	sd	s1,56(sp)
    3438:	f84a                	sd	s2,48(sp)
    343a:	f44e                	sd	s3,40(sp)
    343c:	f052                	sd	s4,32(sp)
    343e:	ec56                	sd	s5,24(sp)
    3440:	e85a                	sd	s6,16(sp)
    3442:	e45e                	sd	s7,8(sp)
    3444:	0880                	addi	s0,sp,80
    3446:	8baa                	mv	s7,a0
    3448:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    344c:	00004a97          	auipc	s5,0x4
    3450:	2cca8a93          	addi	s5,s5,716 # 7718 <malloc+0x1aac>
    mkdir("");
    3454:	00004497          	auipc	s1,0x4
    3458:	dcc48493          	addi	s1,s1,-564 # 7220 <malloc+0x15b4>
    link("README", "");
    345c:	00003b17          	auipc	s6,0x3
    3460:	b14b0b13          	addi	s6,s6,-1260 # 5f70 <malloc+0x304>
    fd = open("", O_CREATE);
    3464:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3468:	00004997          	auipc	s3,0x4
    346c:	1a898993          	addi	s3,s3,424 # 7610 <malloc+0x19a4>
    3470:	a835                	j	34ac <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3472:	85de                	mv	a1,s7
    3474:	00004517          	auipc	a0,0x4
    3478:	2ac50513          	addi	a0,a0,684 # 7720 <malloc+0x1ab4>
    347c:	738020ef          	jal	5bb4 <printf>
      exit(1);
    3480:	4505                	li	a0,1
    3482:	2f0020ef          	jal	5772 <exit>
      printf("%s: chdir irefd failed\n", s);
    3486:	85de                	mv	a1,s7
    3488:	00004517          	auipc	a0,0x4
    348c:	2b050513          	addi	a0,a0,688 # 7738 <malloc+0x1acc>
    3490:	724020ef          	jal	5bb4 <printf>
      exit(1);
    3494:	4505                	li	a0,1
    3496:	2dc020ef          	jal	5772 <exit>
      close(fd);
    349a:	300020ef          	jal	579a <close>
    349e:	a825                	j	34d6 <iref+0xa6>
    unlink("xx");
    34a0:	854e                	mv	a0,s3
    34a2:	320020ef          	jal	57c2 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34a6:	397d                	addiw	s2,s2,-1
    34a8:	04090063          	beqz	s2,34e8 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34ac:	8556                	mv	a0,s5
    34ae:	32c020ef          	jal	57da <mkdir>
    34b2:	f161                	bnez	a0,3472 <iref+0x42>
    if (chdir("irefd") != 0) {
    34b4:	8556                	mv	a0,s5
    34b6:	32c020ef          	jal	57e2 <chdir>
    34ba:	f571                	bnez	a0,3486 <iref+0x56>
    mkdir("");
    34bc:	8526                	mv	a0,s1
    34be:	31c020ef          	jal	57da <mkdir>
    link("README", "");
    34c2:	85a6                	mv	a1,s1
    34c4:	855a                	mv	a0,s6
    34c6:	30c020ef          	jal	57d2 <link>
    fd = open("", O_CREATE);
    34ca:	85d2                	mv	a1,s4
    34cc:	8526                	mv	a0,s1
    34ce:	2e4020ef          	jal	57b2 <open>
    if (fd >= 0)
    34d2:	fc0554e3          	bgez	a0,349a <iref+0x6a>
    fd = open("xx", O_CREATE);
    34d6:	85d2                	mv	a1,s4
    34d8:	854e                	mv	a0,s3
    34da:	2d8020ef          	jal	57b2 <open>
    if (fd >= 0)
    34de:	fc0541e3          	bltz	a0,34a0 <iref+0x70>
      close(fd);
    34e2:	2b8020ef          	jal	579a <close>
    34e6:	bf6d                	j	34a0 <iref+0x70>
    34e8:	03300493          	li	s1,51
    chdir("..");
    34ec:	00004997          	auipc	s3,0x4
    34f0:	a4c98993          	addi	s3,s3,-1460 # 6f38 <malloc+0x12cc>
    unlink("irefd");
    34f4:	00004917          	auipc	s2,0x4
    34f8:	22490913          	addi	s2,s2,548 # 7718 <malloc+0x1aac>
    chdir("..");
    34fc:	854e                	mv	a0,s3
    34fe:	2e4020ef          	jal	57e2 <chdir>
    unlink("irefd");
    3502:	854a                	mv	a0,s2
    3504:	2be020ef          	jal	57c2 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3508:	34fd                	addiw	s1,s1,-1
    350a:	f8ed                	bnez	s1,34fc <iref+0xcc>
  chdir("/");
    350c:	00004517          	auipc	a0,0x4
    3510:	9d450513          	addi	a0,a0,-1580 # 6ee0 <malloc+0x1274>
    3514:	2ce020ef          	jal	57e2 <chdir>
}
    3518:	60a6                	ld	ra,72(sp)
    351a:	6406                	ld	s0,64(sp)
    351c:	74e2                	ld	s1,56(sp)
    351e:	7942                	ld	s2,48(sp)
    3520:	79a2                	ld	s3,40(sp)
    3522:	7a02                	ld	s4,32(sp)
    3524:	6ae2                	ld	s5,24(sp)
    3526:	6b42                	ld	s6,16(sp)
    3528:	6ba2                	ld	s7,8(sp)
    352a:	6161                	addi	sp,sp,80
    352c:	8082                	ret

000000000000352e <unlinkcwd>:
{
    352e:	1101                	addi	sp,sp,-32
    3530:	ec06                	sd	ra,24(sp)
    3532:	e822                	sd	s0,16(sp)
    3534:	e426                	sd	s1,8(sp)
    3536:	1000                	addi	s0,sp,32
    3538:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    353a:	00004517          	auipc	a0,0x4
    353e:	21650513          	addi	a0,a0,534 # 7750 <malloc+0x1ae4>
    3542:	298020ef          	jal	57da <mkdir>
    3546:	06054a63          	bltz	a0,35ba <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    354a:	00004517          	auipc	a0,0x4
    354e:	22650513          	addi	a0,a0,550 # 7770 <malloc+0x1b04>
    3552:	288020ef          	jal	57da <mkdir>
    3556:	06054c63          	bltz	a0,35ce <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    355a:	00004517          	auipc	a0,0x4
    355e:	21650513          	addi	a0,a0,534 # 7770 <malloc+0x1b04>
    3562:	280020ef          	jal	57e2 <chdir>
    3566:	06054e63          	bltz	a0,35e2 <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    356a:	00004517          	auipc	a0,0x4
    356e:	20650513          	addi	a0,a0,518 # 7770 <malloc+0x1b04>
    3572:	250020ef          	jal	57c2 <unlink>
    3576:	08054063          	bltz	a0,35f6 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    357a:	00004517          	auipc	a0,0x4
    357e:	1d650513          	addi	a0,a0,470 # 7750 <malloc+0x1ae4>
    3582:	240020ef          	jal	57c2 <unlink>
    3586:	08054263          	bltz	a0,360a <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    358a:	4581                	li	a1,0
    358c:	00004517          	auipc	a0,0x4
    3590:	24c50513          	addi	a0,a0,588 # 77d8 <malloc+0x1b6c>
    3594:	21e020ef          	jal	57b2 <open>
    3598:	08a04363          	bgtz	a0,361e <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    359c:	20000593          	li	a1,512
    35a0:	00004517          	auipc	a0,0x4
    35a4:	26850513          	addi	a0,a0,616 # 7808 <malloc+0x1b9c>
    35a8:	20a020ef          	jal	57b2 <open>
    35ac:	08a04163          	bgtz	a0,362e <unlinkcwd+0x100>
}
    35b0:	60e2                	ld	ra,24(sp)
    35b2:	6442                	ld	s0,16(sp)
    35b4:	64a2                	ld	s1,8(sp)
    35b6:	6105                	addi	sp,sp,32
    35b8:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35ba:	85a6                	mv	a1,s1
    35bc:	00004517          	auipc	a0,0x4
    35c0:	19c50513          	addi	a0,a0,412 # 7758 <malloc+0x1aec>
    35c4:	5f0020ef          	jal	5bb4 <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	1a8020ef          	jal	5772 <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35ce:	85a6                	mv	a1,s1
    35d0:	00004517          	auipc	a0,0x4
    35d4:	1a850513          	addi	a0,a0,424 # 7778 <malloc+0x1b0c>
    35d8:	5dc020ef          	jal	5bb4 <printf>
    exit(1);
    35dc:	4505                	li	a0,1
    35de:	194020ef          	jal	5772 <exit>
    printf("%s: chdir failed\n", s);
    35e2:	85a6                	mv	a1,s1
    35e4:	00004517          	auipc	a0,0x4
    35e8:	1ac50513          	addi	a0,a0,428 # 7790 <malloc+0x1b24>
    35ec:	5c8020ef          	jal	5bb4 <printf>
    exit(1);
    35f0:	4505                	li	a0,1
    35f2:	180020ef          	jal	5772 <exit>
    printf("%s: unlink /a/b failed\n", s);
    35f6:	85a6                	mv	a1,s1
    35f8:	00004517          	auipc	a0,0x4
    35fc:	1b050513          	addi	a0,a0,432 # 77a8 <malloc+0x1b3c>
    3600:	5b4020ef          	jal	5bb4 <printf>
    exit(1);
    3604:	4505                	li	a0,1
    3606:	16c020ef          	jal	5772 <exit>
    printf("%s: unlink /a failed\n", s);
    360a:	85a6                	mv	a1,s1
    360c:	00004517          	auipc	a0,0x4
    3610:	1b450513          	addi	a0,a0,436 # 77c0 <malloc+0x1b54>
    3614:	5a0020ef          	jal	5bb4 <printf>
    exit(1);
    3618:	4505                	li	a0,1
    361a:	158020ef          	jal	5772 <exit>
    printf("%s: open ../ non-existing directory\n", s);
    361e:	85a6                	mv	a1,s1
    3620:	00004517          	auipc	a0,0x4
    3624:	1c050513          	addi	a0,a0,448 # 77e0 <malloc+0x1b74>
    3628:	58c020ef          	jal	5bb4 <printf>
    362c:	bf85                	j	359c <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    362e:	85a6                	mv	a1,s1
    3630:	00004517          	auipc	a0,0x4
    3634:	1e050513          	addi	a0,a0,480 # 7810 <malloc+0x1ba4>
    3638:	57c020ef          	jal	5bb4 <printf>
}
    363c:	bf95                	j	35b0 <unlinkcwd+0x82>

000000000000363e <openiputtest>:
{
    363e:	7179                	addi	sp,sp,-48
    3640:	f406                	sd	ra,40(sp)
    3642:	f022                	sd	s0,32(sp)
    3644:	ec26                	sd	s1,24(sp)
    3646:	1800                	addi	s0,sp,48
    3648:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    364a:	00004517          	auipc	a0,0x4
    364e:	1ee50513          	addi	a0,a0,494 # 7838 <malloc+0x1bcc>
    3652:	188020ef          	jal	57da <mkdir>
    3656:	02054a63          	bltz	a0,368a <openiputtest+0x4c>
  pid = fork();
    365a:	110020ef          	jal	576a <fork>
  if (pid < 0) {
    365e:	04054063          	bltz	a0,369e <openiputtest+0x60>
  if (pid == 0) {
    3662:	e939                	bnez	a0,36b8 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3664:	4589                	li	a1,2
    3666:	00004517          	auipc	a0,0x4
    366a:	1d250513          	addi	a0,a0,466 # 7838 <malloc+0x1bcc>
    366e:	144020ef          	jal	57b2 <open>
    if (fd >= 0) {
    3672:	04054063          	bltz	a0,36b2 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3676:	85a6                	mv	a1,s1
    3678:	00004517          	auipc	a0,0x4
    367c:	1e050513          	addi	a0,a0,480 # 7858 <malloc+0x1bec>
    3680:	534020ef          	jal	5bb4 <printf>
      exit(1);
    3684:	4505                	li	a0,1
    3686:	0ec020ef          	jal	5772 <exit>
    printf("%s: mkdir oidir failed\n", s);
    368a:	85a6                	mv	a1,s1
    368c:	00004517          	auipc	a0,0x4
    3690:	1b450513          	addi	a0,a0,436 # 7840 <malloc+0x1bd4>
    3694:	520020ef          	jal	5bb4 <printf>
    exit(1);
    3698:	4505                	li	a0,1
    369a:	0d8020ef          	jal	5772 <exit>
    printf("%s: fork failed\n", s);
    369e:	85a6                	mv	a1,s1
    36a0:	00003517          	auipc	a0,0x3
    36a4:	f8850513          	addi	a0,a0,-120 # 6628 <malloc+0x9bc>
    36a8:	50c020ef          	jal	5bb4 <printf>
    exit(1);
    36ac:	4505                	li	a0,1
    36ae:	0c4020ef          	jal	5772 <exit>
    exit(0);
    36b2:	4501                	li	a0,0
    36b4:	0be020ef          	jal	5772 <exit>
  pause(1);
    36b8:	4505                	li	a0,1
    36ba:	148020ef          	jal	5802 <pause>
  if (unlink("oidir") != 0) {
    36be:	00004517          	auipc	a0,0x4
    36c2:	17a50513          	addi	a0,a0,378 # 7838 <malloc+0x1bcc>
    36c6:	0fc020ef          	jal	57c2 <unlink>
    36ca:	c919                	beqz	a0,36e0 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36cc:	85a6                	mv	a1,s1
    36ce:	00003517          	auipc	a0,0x3
    36d2:	0e250513          	addi	a0,a0,226 # 67b0 <malloc+0xb44>
    36d6:	4de020ef          	jal	5bb4 <printf>
    exit(1);
    36da:	4505                	li	a0,1
    36dc:	096020ef          	jal	5772 <exit>
  wait(&xstatus);
    36e0:	fdc40513          	addi	a0,s0,-36
    36e4:	096020ef          	jal	577a <wait>
  exit(xstatus);
    36e8:	fdc42503          	lw	a0,-36(s0)
    36ec:	086020ef          	jal	5772 <exit>

00000000000036f0 <forkforkfork>:
{
    36f0:	1101                	addi	sp,sp,-32
    36f2:	ec06                	sd	ra,24(sp)
    36f4:	e822                	sd	s0,16(sp)
    36f6:	e426                	sd	s1,8(sp)
    36f8:	1000                	addi	s0,sp,32
    36fa:	84aa                	mv	s1,a0
  unlink("stopforking");
    36fc:	00004517          	auipc	a0,0x4
    3700:	18450513          	addi	a0,a0,388 # 7880 <malloc+0x1c14>
    3704:	0be020ef          	jal	57c2 <unlink>
  int pid = fork();
    3708:	062020ef          	jal	576a <fork>
  if (pid < 0) {
    370c:	02054b63          	bltz	a0,3742 <forkforkfork+0x52>
  if (pid == 0) {
    3710:	c139                	beqz	a0,3756 <forkforkfork+0x66>
  pause(20); // two seconds
    3712:	4551                	li	a0,20
    3714:	0ee020ef          	jal	5802 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3718:	20200593          	li	a1,514
    371c:	00004517          	auipc	a0,0x4
    3720:	16450513          	addi	a0,a0,356 # 7880 <malloc+0x1c14>
    3724:	08e020ef          	jal	57b2 <open>
    3728:	072020ef          	jal	579a <close>
  wait(0);
    372c:	4501                	li	a0,0
    372e:	04c020ef          	jal	577a <wait>
  pause(10); // one second
    3732:	4529                	li	a0,10
    3734:	0ce020ef          	jal	5802 <pause>
}
    3738:	60e2                	ld	ra,24(sp)
    373a:	6442                	ld	s0,16(sp)
    373c:	64a2                	ld	s1,8(sp)
    373e:	6105                	addi	sp,sp,32
    3740:	8082                	ret
    printf("%s: fork failed", s);
    3742:	85a6                	mv	a1,s1
    3744:	00003517          	auipc	a0,0x3
    3748:	02450513          	addi	a0,a0,36 # 6768 <malloc+0xafc>
    374c:	468020ef          	jal	5bb4 <printf>
    exit(1);
    3750:	4505                	li	a0,1
    3752:	020020ef          	jal	5772 <exit>
      int fd = open("stopforking", 0);
    3756:	00004497          	auipc	s1,0x4
    375a:	12a48493          	addi	s1,s1,298 # 7880 <malloc+0x1c14>
    375e:	4581                	li	a1,0
    3760:	8526                	mv	a0,s1
    3762:	050020ef          	jal	57b2 <open>
      if (fd >= 0) {
    3766:	02055163          	bgez	a0,3788 <forkforkfork+0x98>
      if (fork() < 0) {
    376a:	000020ef          	jal	576a <fork>
    376e:	fe0558e3          	bgez	a0,375e <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE | O_RDWR));
    3772:	20200593          	li	a1,514
    3776:	00004517          	auipc	a0,0x4
    377a:	10a50513          	addi	a0,a0,266 # 7880 <malloc+0x1c14>
    377e:	034020ef          	jal	57b2 <open>
    3782:	018020ef          	jal	579a <close>
    3786:	bfe1                	j	375e <forkforkfork+0x6e>
        exit(0);
    3788:	4501                	li	a0,0
    378a:	7e9010ef          	jal	5772 <exit>

000000000000378e <exectest>:
{
    378e:	711d                	addi	sp,sp,-96
    3790:	ec86                	sd	ra,88(sp)
    3792:	e8a2                	sd	s0,80(sp)
    3794:	e0ca                	sd	s2,64(sp)
    3796:	1080                	addi	s0,sp,96
    3798:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    379a:	00002797          	auipc	a5,0x2
    379e:	5fe78793          	addi	a5,a5,1534 # 5d98 <malloc+0x12c>
    37a2:	faf43823          	sd	a5,-80(s0)
    37a6:	00004797          	auipc	a5,0x4
    37aa:	0ea78793          	addi	a5,a5,234 # 7890 <malloc+0x1c24>
    37ae:	faf43c23          	sd	a5,-72(s0)
    37b2:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37b6:	00004517          	auipc	a0,0x4
    37ba:	0e250513          	addi	a0,a0,226 # 7898 <malloc+0x1c2c>
    37be:	004020ef          	jal	57c2 <unlink>
  pid = fork();
    37c2:	7a9010ef          	jal	576a <fork>
  if (pid < 0) {
    37c6:	04054763          	bltz	a0,3814 <exectest+0x86>
    37ca:	e4a6                	sd	s1,72(sp)
    37cc:	fc4e                	sd	s3,56(sp)
    37ce:	84aa                	mv	s1,a0
  if (pid == 0) {
    37d0:	ed49                	bnez	a0,386a <exectest+0xdc>
    int errfd = dup(1);
    37d2:	4505                	li	a0,1
    37d4:	016020ef          	jal	57ea <dup>
    37d8:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37da:	04054963          	bltz	a0,382c <exectest+0x9e>
    close(1);
    37de:	4505                	li	a0,1
    37e0:	7bb010ef          	jal	579a <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    37e4:	20100593          	li	a1,513
    37e8:	00004517          	auipc	a0,0x4
    37ec:	0b050513          	addi	a0,a0,176 # 7898 <malloc+0x1c2c>
    37f0:	7c3010ef          	jal	57b2 <open>
    if (fd < 0) {
    37f4:	04054663          	bltz	a0,3840 <exectest+0xb2>
    if (fd != 1) {
    37f8:	4785                	li	a5,1
    37fa:	04f50e63          	beq	a0,a5,3856 <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    37fe:	864a                	mv	a2,s2
    3800:	00004597          	auipc	a1,0x4
    3804:	0b058593          	addi	a1,a1,176 # 78b0 <malloc+0x1c44>
    3808:	854e                	mv	a0,s3
    380a:	380020ef          	jal	5b8a <fprintf>
      exit(1);
    380e:	4505                	li	a0,1
    3810:	763010ef          	jal	5772 <exit>
    3814:	e4a6                	sd	s1,72(sp)
    3816:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3818:	85ca                	mv	a1,s2
    381a:	00003517          	auipc	a0,0x3
    381e:	e0e50513          	addi	a0,a0,-498 # 6628 <malloc+0x9bc>
    3822:	392020ef          	jal	5bb4 <printf>
    exit(1);
    3826:	4505                	li	a0,1
    3828:	74b010ef          	jal	5772 <exit>
      printf("%s: dup failed\n", s);
    382c:	85ca                	mv	a1,s2
    382e:	00004517          	auipc	a0,0x4
    3832:	07250513          	addi	a0,a0,114 # 78a0 <malloc+0x1c34>
    3836:	37e020ef          	jal	5bb4 <printf>
      exit(1);
    383a:	4505                	li	a0,1
    383c:	737010ef          	jal	5772 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    3840:	864a                	mv	a2,s2
    3842:	00003597          	auipc	a1,0x3
    3846:	f5658593          	addi	a1,a1,-170 # 6798 <malloc+0xb2c>
    384a:	854e                	mv	a0,s3
    384c:	33e020ef          	jal	5b8a <fprintf>
      exit(1);
    3850:	4505                	li	a0,1
    3852:	721010ef          	jal	5772 <exit>
    if (exec("echo", echoargv) < 0) {
    3856:	fb040593          	addi	a1,s0,-80
    385a:	00002517          	auipc	a0,0x2
    385e:	53e50513          	addi	a0,a0,1342 # 5d98 <malloc+0x12c>
    3862:	749010ef          	jal	57aa <exec>
    3866:	02054563          	bltz	a0,3890 <exectest+0x102>
  if (wait(&xstatus) != pid) {
    386a:	fcc40513          	addi	a0,s0,-52
    386e:	70d010ef          	jal	577a <wait>
    3872:	02951a63          	bne	a0,s1,38a6 <exectest+0x118>
  if (xstatus != 0) {
    3876:	fcc42603          	lw	a2,-52(s0)
    387a:	ce15                	beqz	a2,38b6 <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    387c:	85ca                	mv	a1,s2
    387e:	00004517          	auipc	a0,0x4
    3882:	07250513          	addi	a0,a0,114 # 78f0 <malloc+0x1c84>
    3886:	32e020ef          	jal	5bb4 <printf>
    exit(1);
    388a:	4505                	li	a0,1
    388c:	6e7010ef          	jal	5772 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    3890:	864a                	mv	a2,s2
    3892:	00004597          	auipc	a1,0x4
    3896:	02e58593          	addi	a1,a1,46 # 78c0 <malloc+0x1c54>
    389a:	854e                	mv	a0,s3
    389c:	2ee020ef          	jal	5b8a <fprintf>
      exit(1);
    38a0:	4505                	li	a0,1
    38a2:	6d1010ef          	jal	5772 <exit>
    printf("%s: wait failed!\n", s);
    38a6:	85ca                	mv	a1,s2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	03050513          	addi	a0,a0,48 # 78d8 <malloc+0x1c6c>
    38b0:	304020ef          	jal	5bb4 <printf>
    38b4:	b7c9                	j	3876 <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38b6:	4581                	li	a1,0
    38b8:	00004517          	auipc	a0,0x4
    38bc:	fe050513          	addi	a0,a0,-32 # 7898 <malloc+0x1c2c>
    38c0:	6f3010ef          	jal	57b2 <open>
  if (fd < 0) {
    38c4:	02054463          	bltz	a0,38ec <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38c8:	4609                	li	a2,2
    38ca:	fa840593          	addi	a1,s0,-88
    38ce:	6bd010ef          	jal	578a <read>
    38d2:	4789                	li	a5,2
    38d4:	02f50663          	beq	a0,a5,3900 <exectest+0x172>
    printf("%s: read failed\n", s);
    38d8:	85ca                	mv	a1,s2
    38da:	00003517          	auipc	a0,0x3
    38de:	88e50513          	addi	a0,a0,-1906 # 6168 <malloc+0x4fc>
    38e2:	2d2020ef          	jal	5bb4 <printf>
    exit(1);
    38e6:	4505                	li	a0,1
    38e8:	68b010ef          	jal	5772 <exit>
    printf("%s: open failed\n", s);
    38ec:	85ca                	mv	a1,s2
    38ee:	00003517          	auipc	a0,0x3
    38f2:	d5250513          	addi	a0,a0,-686 # 6640 <malloc+0x9d4>
    38f6:	2be020ef          	jal	5bb4 <printf>
    exit(1);
    38fa:	4505                	li	a0,1
    38fc:	677010ef          	jal	5772 <exit>
  unlink("echo-ok");
    3900:	00004517          	auipc	a0,0x4
    3904:	f9850513          	addi	a0,a0,-104 # 7898 <malloc+0x1c2c>
    3908:	6bb010ef          	jal	57c2 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    390c:	fa844703          	lbu	a4,-88(s0)
    3910:	04f00793          	li	a5,79
    3914:	00f71863          	bne	a4,a5,3924 <exectest+0x196>
    3918:	fa944703          	lbu	a4,-87(s0)
    391c:	04b00793          	li	a5,75
    3920:	00f70c63          	beq	a4,a5,3938 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    3924:	85ca                	mv	a1,s2
    3926:	00004517          	auipc	a0,0x4
    392a:	fea50513          	addi	a0,a0,-22 # 7910 <malloc+0x1ca4>
    392e:	286020ef          	jal	5bb4 <printf>
    exit(1);
    3932:	4505                	li	a0,1
    3934:	63f010ef          	jal	5772 <exit>
    exit(0);
    3938:	4501                	li	a0,0
    393a:	639010ef          	jal	5772 <exit>

000000000000393e <killstatus>:
{
    393e:	715d                	addi	sp,sp,-80
    3940:	e486                	sd	ra,72(sp)
    3942:	e0a2                	sd	s0,64(sp)
    3944:	fc26                	sd	s1,56(sp)
    3946:	f84a                	sd	s2,48(sp)
    3948:	f44e                	sd	s3,40(sp)
    394a:	f052                	sd	s4,32(sp)
    394c:	ec56                	sd	s5,24(sp)
    394e:	e85a                	sd	s6,16(sp)
    3950:	0880                	addi	s0,sp,80
    3952:	8b2a                	mv	s6,a0
    3954:	06400913          	li	s2,100
    pause(1);
    3958:	4a85                	li	s5,1
    wait(&xst);
    395a:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    395e:	59fd                	li	s3,-1
    int pid1 = fork();
    3960:	60b010ef          	jal	576a <fork>
    3964:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    3966:	02054663          	bltz	a0,3992 <killstatus+0x54>
    if (pid1 == 0) {
    396a:	cd15                	beqz	a0,39a6 <killstatus+0x68>
    pause(1);
    396c:	8556                	mv	a0,s5
    396e:	695010ef          	jal	5802 <pause>
    kill(pid1);
    3972:	8526                	mv	a0,s1
    3974:	62f010ef          	jal	57a2 <kill>
    wait(&xst);
    3978:	8552                	mv	a0,s4
    397a:	601010ef          	jal	577a <wait>
    if (xst != -1) {
    397e:	fbc42783          	lw	a5,-68(s0)
    3982:	03379563          	bne	a5,s3,39ac <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    3986:	397d                	addiw	s2,s2,-1
    3988:	fc091ce3          	bnez	s2,3960 <killstatus+0x22>
  exit(0);
    398c:	4501                	li	a0,0
    398e:	5e5010ef          	jal	5772 <exit>
      printf("%s: fork failed\n", s);
    3992:	85da                	mv	a1,s6
    3994:	00003517          	auipc	a0,0x3
    3998:	c9450513          	addi	a0,a0,-876 # 6628 <malloc+0x9bc>
    399c:	218020ef          	jal	5bb4 <printf>
      exit(1);
    39a0:	4505                	li	a0,1
    39a2:	5d1010ef          	jal	5772 <exit>
        getpid();
    39a6:	64d010ef          	jal	57f2 <getpid>
      while (1) {
    39aa:	bff5                	j	39a6 <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    39ac:	85da                	mv	a1,s6
    39ae:	00004517          	auipc	a0,0x4
    39b2:	f7a50513          	addi	a0,a0,-134 # 7928 <malloc+0x1cbc>
    39b6:	1fe020ef          	jal	5bb4 <printf>
      exit(1);
    39ba:	4505                	li	a0,1
    39bc:	5b7010ef          	jal	5772 <exit>

00000000000039c0 <killzero>:
{
    39c0:	7179                	addi	sp,sp,-48
    39c2:	f406                	sd	ra,40(sp)
    39c4:	f022                	sd	s0,32(sp)
    39c6:	e84a                	sd	s2,16(sp)
    39c8:	1800                	addi	s0,sp,48
    39ca:	892a                	mv	s2,a0
  kill(0);
    39cc:	4501                	li	a0,0
    39ce:	5d5010ef          	jal	57a2 <kill>
  pid = fork();
    39d2:	599010ef          	jal	576a <fork>
  if (pid < 0) {
    39d6:	00054863          	bltz	a0,39e6 <killzero+0x26>
    39da:	ec26                	sd	s1,24(sp)
    39dc:	84aa                	mv	s1,a0
  if (pid == 0) {
    39de:	ed19                	bnez	a0,39fc <killzero+0x3c>
    exit(7);
    39e0:	451d                	li	a0,7
    39e2:	591010ef          	jal	5772 <exit>
    39e6:	ec26                	sd	s1,24(sp)
    printf("%s: fork failed\n", s);
    39e8:	85ca                	mv	a1,s2
    39ea:	00003517          	auipc	a0,0x3
    39ee:	c3e50513          	addi	a0,a0,-962 # 6628 <malloc+0x9bc>
    39f2:	1c2020ef          	jal	5bb4 <printf>
    exit(1);
    39f6:	4505                	li	a0,1
    39f8:	57b010ef          	jal	5772 <exit>
  if (wait(&xst) != pid) {
    39fc:	fdc40513          	addi	a0,s0,-36
    3a00:	57b010ef          	jal	577a <wait>
    3a04:	02951163          	bne	a0,s1,3a26 <killzero+0x66>
  if (xst != 7) {
    3a08:	fdc42603          	lw	a2,-36(s0)
    3a0c:	479d                	li	a5,7
    3a0e:	02f60663          	beq	a2,a5,3a3a <killzero+0x7a>
    printf("%s: child exited with status %d, expected 7\n", s, xst);
    3a12:	85ca                	mv	a1,s2
    3a14:	00004517          	auipc	a0,0x4
    3a18:	f3450513          	addi	a0,a0,-204 # 7948 <malloc+0x1cdc>
    3a1c:	198020ef          	jal	5bb4 <printf>
    exit(1);
    3a20:	4505                	li	a0,1
    3a22:	551010ef          	jal	5772 <exit>
    printf("%s: wait wrong pid\n", s);
    3a26:	85ca                	mv	a1,s2
    3a28:	00003517          	auipc	a0,0x3
    3a2c:	d0850513          	addi	a0,a0,-760 # 6730 <malloc+0xac4>
    3a30:	184020ef          	jal	5bb4 <printf>
    exit(1);
    3a34:	4505                	li	a0,1
    3a36:	53d010ef          	jal	5772 <exit>
  exit(0);
    3a3a:	4501                	li	a0,0
    3a3c:	537010ef          	jal	5772 <exit>

0000000000003a40 <preempt>:
{
    3a40:	7139                	addi	sp,sp,-64
    3a42:	fc06                	sd	ra,56(sp)
    3a44:	f822                	sd	s0,48(sp)
    3a46:	f426                	sd	s1,40(sp)
    3a48:	f04a                	sd	s2,32(sp)
    3a4a:	ec4e                	sd	s3,24(sp)
    3a4c:	e852                	sd	s4,16(sp)
    3a4e:	0080                	addi	s0,sp,64
    3a50:	892a                	mv	s2,a0
  pid1 = fork();
    3a52:	519010ef          	jal	576a <fork>
  if (pid1 < 0) {
    3a56:	00054563          	bltz	a0,3a60 <preempt+0x20>
    3a5a:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3a5c:	ed01                	bnez	a0,3a74 <preempt+0x34>
    for (;;)
    3a5e:	a001                	j	3a5e <preempt+0x1e>
    printf("%s: fork failed", s);
    3a60:	85ca                	mv	a1,s2
    3a62:	00003517          	auipc	a0,0x3
    3a66:	d0650513          	addi	a0,a0,-762 # 6768 <malloc+0xafc>
    3a6a:	14a020ef          	jal	5bb4 <printf>
    exit(1);
    3a6e:	4505                	li	a0,1
    3a70:	503010ef          	jal	5772 <exit>
  pid2 = fork();
    3a74:	4f7010ef          	jal	576a <fork>
    3a78:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3a7a:	00054463          	bltz	a0,3a82 <preempt+0x42>
  if (pid2 == 0)
    3a7e:	ed01                	bnez	a0,3a96 <preempt+0x56>
    for (;;)
    3a80:	a001                	j	3a80 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3a82:	85ca                	mv	a1,s2
    3a84:	00003517          	auipc	a0,0x3
    3a88:	ba450513          	addi	a0,a0,-1116 # 6628 <malloc+0x9bc>
    3a8c:	128020ef          	jal	5bb4 <printf>
    exit(1);
    3a90:	4505                	li	a0,1
    3a92:	4e1010ef          	jal	5772 <exit>
  pipe(pfds);
    3a96:	fc840513          	addi	a0,s0,-56
    3a9a:	4e9010ef          	jal	5782 <pipe>
  pid3 = fork();
    3a9e:	4cd010ef          	jal	576a <fork>
    3aa2:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3aa4:	02054863          	bltz	a0,3ad4 <preempt+0x94>
  if (pid3 == 0) {
    3aa8:	e921                	bnez	a0,3af8 <preempt+0xb8>
    close(pfds[0]);
    3aaa:	fc842503          	lw	a0,-56(s0)
    3aae:	4ed010ef          	jal	579a <close>
    if (write(pfds[1], "x", 1) != 1)
    3ab2:	4605                	li	a2,1
    3ab4:	00002597          	auipc	a1,0x2
    3ab8:	35458593          	addi	a1,a1,852 # 5e08 <malloc+0x19c>
    3abc:	fcc42503          	lw	a0,-52(s0)
    3ac0:	4d3010ef          	jal	5792 <write>
    3ac4:	4785                	li	a5,1
    3ac6:	02f51163          	bne	a0,a5,3ae8 <preempt+0xa8>
    close(pfds[1]);
    3aca:	fcc42503          	lw	a0,-52(s0)
    3ace:	4cd010ef          	jal	579a <close>
    for (;;)
    3ad2:	a001                	j	3ad2 <preempt+0x92>
    printf("%s: fork failed\n", s);
    3ad4:	85ca                	mv	a1,s2
    3ad6:	00003517          	auipc	a0,0x3
    3ada:	b5250513          	addi	a0,a0,-1198 # 6628 <malloc+0x9bc>
    3ade:	0d6020ef          	jal	5bb4 <printf>
    exit(1);
    3ae2:	4505                	li	a0,1
    3ae4:	48f010ef          	jal	5772 <exit>
      printf("%s: preempt write error", s);
    3ae8:	85ca                	mv	a1,s2
    3aea:	00004517          	auipc	a0,0x4
    3aee:	e8e50513          	addi	a0,a0,-370 # 7978 <malloc+0x1d0c>
    3af2:	0c2020ef          	jal	5bb4 <printf>
    3af6:	bfd1                	j	3aca <preempt+0x8a>
  close(pfds[1]);
    3af8:	fcc42503          	lw	a0,-52(s0)
    3afc:	49f010ef          	jal	579a <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3b00:	660d                	lui	a2,0x3
    3b02:	00009597          	auipc	a1,0x9
    3b06:	1f658593          	addi	a1,a1,502 # ccf8 <buf>
    3b0a:	fc842503          	lw	a0,-56(s0)
    3b0e:	47d010ef          	jal	578a <read>
    3b12:	4785                	li	a5,1
    3b14:	02f50163          	beq	a0,a5,3b36 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3b18:	85ca                	mv	a1,s2
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	e7650513          	addi	a0,a0,-394 # 7990 <malloc+0x1d24>
    3b22:	092020ef          	jal	5bb4 <printf>
}
    3b26:	70e2                	ld	ra,56(sp)
    3b28:	7442                	ld	s0,48(sp)
    3b2a:	74a2                	ld	s1,40(sp)
    3b2c:	7902                	ld	s2,32(sp)
    3b2e:	69e2                	ld	s3,24(sp)
    3b30:	6a42                	ld	s4,16(sp)
    3b32:	6121                	addi	sp,sp,64
    3b34:	8082                	ret
  close(pfds[0]);
    3b36:	fc842503          	lw	a0,-56(s0)
    3b3a:	461010ef          	jal	579a <close>
  printf("kill... ");
    3b3e:	00004517          	auipc	a0,0x4
    3b42:	e6a50513          	addi	a0,a0,-406 # 79a8 <malloc+0x1d3c>
    3b46:	06e020ef          	jal	5bb4 <printf>
  kill(pid1);
    3b4a:	8526                	mv	a0,s1
    3b4c:	457010ef          	jal	57a2 <kill>
  kill(pid2);
    3b50:	854e                	mv	a0,s3
    3b52:	451010ef          	jal	57a2 <kill>
  kill(pid3);
    3b56:	8552                	mv	a0,s4
    3b58:	44b010ef          	jal	57a2 <kill>
  printf("wait... ");
    3b5c:	00004517          	auipc	a0,0x4
    3b60:	e5c50513          	addi	a0,a0,-420 # 79b8 <malloc+0x1d4c>
    3b64:	050020ef          	jal	5bb4 <printf>
  wait(0);
    3b68:	4501                	li	a0,0
    3b6a:	411010ef          	jal	577a <wait>
  wait(0);
    3b6e:	4501                	li	a0,0
    3b70:	40b010ef          	jal	577a <wait>
  wait(0);
    3b74:	4501                	li	a0,0
    3b76:	405010ef          	jal	577a <wait>
    3b7a:	b775                	j	3b26 <preempt+0xe6>

0000000000003b7c <reparent>:
{
    3b7c:	7179                	addi	sp,sp,-48
    3b7e:	f406                	sd	ra,40(sp)
    3b80:	f022                	sd	s0,32(sp)
    3b82:	ec26                	sd	s1,24(sp)
    3b84:	e84a                	sd	s2,16(sp)
    3b86:	e44e                	sd	s3,8(sp)
    3b88:	e052                	sd	s4,0(sp)
    3b8a:	1800                	addi	s0,sp,48
    3b8c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3b8e:	465010ef          	jal	57f2 <getpid>
    3b92:	8a2a                	mv	s4,a0
    3b94:	0c800913          	li	s2,200
    int pid = fork();
    3b98:	3d3010ef          	jal	576a <fork>
    3b9c:	84aa                	mv	s1,a0
    if (pid < 0) {
    3b9e:	00054e63          	bltz	a0,3bba <reparent+0x3e>
    if (pid) {
    3ba2:	c121                	beqz	a0,3be2 <reparent+0x66>
      if (wait(0) != pid) {
    3ba4:	4501                	li	a0,0
    3ba6:	3d5010ef          	jal	577a <wait>
    3baa:	02951263          	bne	a0,s1,3bce <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3bae:	397d                	addiw	s2,s2,-1
    3bb0:	fe0914e3          	bnez	s2,3b98 <reparent+0x1c>
  exit(0);
    3bb4:	4501                	li	a0,0
    3bb6:	3bd010ef          	jal	5772 <exit>
      printf("%s: fork failed\n", s);
    3bba:	85ce                	mv	a1,s3
    3bbc:	00003517          	auipc	a0,0x3
    3bc0:	a6c50513          	addi	a0,a0,-1428 # 6628 <malloc+0x9bc>
    3bc4:	7f1010ef          	jal	5bb4 <printf>
      exit(1);
    3bc8:	4505                	li	a0,1
    3bca:	3a9010ef          	jal	5772 <exit>
        printf("%s: wait wrong pid\n", s);
    3bce:	85ce                	mv	a1,s3
    3bd0:	00003517          	auipc	a0,0x3
    3bd4:	b6050513          	addi	a0,a0,-1184 # 6730 <malloc+0xac4>
    3bd8:	7dd010ef          	jal	5bb4 <printf>
        exit(1);
    3bdc:	4505                	li	a0,1
    3bde:	395010ef          	jal	5772 <exit>
      int pid2 = fork();
    3be2:	389010ef          	jal	576a <fork>
      if (pid2 < 0) {
    3be6:	00054563          	bltz	a0,3bf0 <reparent+0x74>
      exit(0);
    3bea:	4501                	li	a0,0
    3bec:	387010ef          	jal	5772 <exit>
        kill(master_pid);
    3bf0:	8552                	mv	a0,s4
    3bf2:	3b1010ef          	jal	57a2 <kill>
        exit(1);
    3bf6:	4505                	li	a0,1
    3bf8:	37b010ef          	jal	5772 <exit>

0000000000003bfc <sbrkfail>:
{
    3bfc:	7175                	addi	sp,sp,-144
    3bfe:	e506                	sd	ra,136(sp)
    3c00:	e122                	sd	s0,128(sp)
    3c02:	fca6                	sd	s1,120(sp)
    3c04:	f8ca                	sd	s2,112(sp)
    3c06:	f4ce                	sd	s3,104(sp)
    3c08:	f0d2                	sd	s4,96(sp)
    3c0a:	ecd6                	sd	s5,88(sp)
    3c0c:	e8da                	sd	s6,80(sp)
    3c0e:	e4de                	sd	s7,72(sp)
    3c10:	e0e2                	sd	s8,64(sp)
    3c12:	0900                	addi	s0,sp,144
    3c14:	8baa                	mv	s7,a0
  if (pipe(fds) != 0) {
    3c16:	fa040513          	addi	a0,s0,-96
    3c1a:	369010ef          	jal	5782 <pipe>
    3c1e:	ed01                	bnez	a0,3c36 <sbrkfail+0x3a>
    3c20:	8c2a                	mv	s8,a0
    3c22:	f7040493          	addi	s1,s0,-144
    3c26:	f9840993          	addi	s3,s0,-104
    3c2a:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3c2c:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3c2e:	f9f40b13          	addi	s6,s0,-97
    3c32:	4a85                	li	s5,1
    3c34:	a095                	j	3c98 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3c36:	85de                	mv	a1,s7
    3c38:	00003517          	auipc	a0,0x3
    3c3c:	a7850513          	addi	a0,a0,-1416 # 66b0 <malloc+0xa44>
    3c40:	775010ef          	jal	5bb4 <printf>
    exit(1);
    3c44:	4505                	li	a0,1
    3c46:	32d010ef          	jal	5772 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3c4a:	2f5010ef          	jal	573e <sbrk>
    3c4e:	064007b7          	lui	a5,0x6400
    3c52:	40a7853b          	subw	a0,a5,a0
    3c56:	2e9010ef          	jal	573e <sbrk>
    3c5a:	57fd                	li	a5,-1
    3c5c:	02f50163          	beq	a0,a5,3c7e <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3c60:	4605                	li	a2,1
    3c62:	00004597          	auipc	a1,0x4
    3c66:	70e58593          	addi	a1,a1,1806 # 8370 <malloc+0x2704>
    3c6a:	fa442503          	lw	a0,-92(s0)
    3c6e:	325010ef          	jal	5792 <write>
        pause(1000);
    3c72:	3e800493          	li	s1,1000
    3c76:	8526                	mv	a0,s1
    3c78:	38b010ef          	jal	5802 <pause>
      for (;;)
    3c7c:	bfed                	j	3c76 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3c7e:	4605                	li	a2,1
    3c80:	00004597          	auipc	a1,0x4
    3c84:	d4858593          	addi	a1,a1,-696 # 79c8 <malloc+0x1d5c>
    3c88:	fa442503          	lw	a0,-92(s0)
    3c8c:	307010ef          	jal	5792 <write>
    3c90:	b7cd                	j	3c72 <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3c92:	0911                	addi	s2,s2,4
    3c94:	03390a63          	beq	s2,s3,3cc8 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3c98:	2d3010ef          	jal	576a <fork>
    3c9c:	00a92023          	sw	a0,0(s2)
    3ca0:	d54d                	beqz	a0,3c4a <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3ca2:	ff4508e3          	beq	a0,s4,3c92 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3ca6:	8656                	mv	a2,s5
    3ca8:	85da                	mv	a1,s6
    3caa:	fa042503          	lw	a0,-96(s0)
    3cae:	2dd010ef          	jal	578a <read>
      if (scratch == '0')
    3cb2:	f9f44783          	lbu	a5,-97(s0)
    3cb6:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f02d8>
    3cba:	0017b793          	seqz	a5,a5
    3cbe:	00fc67b3          	or	a5,s8,a5
    3cc2:	00078c1b          	sext.w	s8,a5
    3cc6:	b7f1                	j	3c92 <sbrkfail+0x96>
  if (!failed) {
    3cc8:	000c0863          	beqz	s8,3cd8 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3ccc:	6505                	lui	a0,0x1
    3cce:	271010ef          	jal	573e <sbrk>
    3cd2:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3cd4:	597d                	li	s2,-1
    3cd6:	a821                	j	3cee <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3cd8:	85de                	mv	a1,s7
    3cda:	00004517          	auipc	a0,0x4
    3cde:	cf650513          	addi	a0,a0,-778 # 79d0 <malloc+0x1d64>
    3ce2:	6d3010ef          	jal	5bb4 <printf>
    3ce6:	b7dd                	j	3ccc <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3ce8:	0491                	addi	s1,s1,4
    3cea:	01348b63          	beq	s1,s3,3d00 <sbrkfail+0x104>
    if (pids[i] == -1)
    3cee:	4088                	lw	a0,0(s1)
    3cf0:	ff250ce3          	beq	a0,s2,3ce8 <sbrkfail+0xec>
    kill(pids[i]);
    3cf4:	2af010ef          	jal	57a2 <kill>
    wait(0);
    3cf8:	4501                	li	a0,0
    3cfa:	281010ef          	jal	577a <wait>
    3cfe:	b7ed                	j	3ce8 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3d00:	57fd                	li	a5,-1
    3d02:	02fa0a63          	beq	s4,a5,3d36 <sbrkfail+0x13a>
  pid = fork();
    3d06:	265010ef          	jal	576a <fork>
  if (pid < 0) {
    3d0a:	04054063          	bltz	a0,3d4a <sbrkfail+0x14e>
  if (pid == 0) {
    3d0e:	e939                	bnez	a0,3d64 <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3d10:	3e800537          	lui	a0,0x3e800
    3d14:	22b010ef          	jal	573e <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3d18:	57fd                	li	a5,-1
    3d1a:	04f50263          	beq	a0,a5,3d5e <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3d1e:	3e800637          	lui	a2,0x3e800
    3d22:	85de                	mv	a1,s7
    3d24:	00004517          	auipc	a0,0x4
    3d28:	cfc50513          	addi	a0,a0,-772 # 7a20 <malloc+0x1db4>
    3d2c:	689010ef          	jal	5bb4 <printf>
    exit(1);
    3d30:	4505                	li	a0,1
    3d32:	241010ef          	jal	5772 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3d36:	85de                	mv	a1,s7
    3d38:	00004517          	auipc	a0,0x4
    3d3c:	cc850513          	addi	a0,a0,-824 # 7a00 <malloc+0x1d94>
    3d40:	675010ef          	jal	5bb4 <printf>
    exit(1);
    3d44:	4505                	li	a0,1
    3d46:	22d010ef          	jal	5772 <exit>
    printf("%s: fork failed\n", s);
    3d4a:	85de                	mv	a1,s7
    3d4c:	00003517          	auipc	a0,0x3
    3d50:	8dc50513          	addi	a0,a0,-1828 # 6628 <malloc+0x9bc>
    3d54:	661010ef          	jal	5bb4 <printf>
    exit(1);
    3d58:	4505                	li	a0,1
    3d5a:	219010ef          	jal	5772 <exit>
      exit(0);
    3d5e:	4501                	li	a0,0
    3d60:	213010ef          	jal	5772 <exit>
  wait(&xstatus);
    3d64:	fac40513          	addi	a0,s0,-84
    3d68:	213010ef          	jal	577a <wait>
  if (xstatus != 0)
    3d6c:	fac42783          	lw	a5,-84(s0)
    3d70:	ef89                	bnez	a5,3d8a <sbrkfail+0x18e>
}
    3d72:	60aa                	ld	ra,136(sp)
    3d74:	640a                	ld	s0,128(sp)
    3d76:	74e6                	ld	s1,120(sp)
    3d78:	7946                	ld	s2,112(sp)
    3d7a:	79a6                	ld	s3,104(sp)
    3d7c:	7a06                	ld	s4,96(sp)
    3d7e:	6ae6                	ld	s5,88(sp)
    3d80:	6b46                	ld	s6,80(sp)
    3d82:	6ba6                	ld	s7,72(sp)
    3d84:	6c06                	ld	s8,64(sp)
    3d86:	6149                	addi	sp,sp,144
    3d88:	8082                	ret
    exit(1);
    3d8a:	4505                	li	a0,1
    3d8c:	1e7010ef          	jal	5772 <exit>

0000000000003d90 <mem>:
{
    3d90:	7139                	addi	sp,sp,-64
    3d92:	fc06                	sd	ra,56(sp)
    3d94:	f822                	sd	s0,48(sp)
    3d96:	f426                	sd	s1,40(sp)
    3d98:	f04a                	sd	s2,32(sp)
    3d9a:	ec4e                	sd	s3,24(sp)
    3d9c:	0080                	addi	s0,sp,64
    3d9e:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3da0:	1cb010ef          	jal	576a <fork>
    m1 = 0;
    3da4:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3da6:	6909                	lui	s2,0x2
    3da8:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x10b>
  if ((pid = fork()) == 0) {
    3dac:	cd11                	beqz	a0,3dc8 <mem+0x38>
    wait(&xstatus);
    3dae:	fcc40513          	addi	a0,s0,-52
    3db2:	1c9010ef          	jal	577a <wait>
    if (xstatus == -1) {
    3db6:	fcc42503          	lw	a0,-52(s0)
    3dba:	57fd                	li	a5,-1
    3dbc:	04f50363          	beq	a0,a5,3e02 <mem+0x72>
    exit(xstatus);
    3dc0:	1b3010ef          	jal	5772 <exit>
      *(char **)m2 = m1;
    3dc4:	e104                	sd	s1,0(a0)
      m1 = m2;
    3dc6:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3dc8:	854a                	mv	a0,s2
    3dca:	6a3010ef          	jal	5c6c <malloc>
    3dce:	f97d                	bnez	a0,3dc4 <mem+0x34>
    while (m1) {
    3dd0:	c491                	beqz	s1,3ddc <mem+0x4c>
      m2 = *(char **)m1;
    3dd2:	8526                	mv	a0,s1
    3dd4:	6084                	ld	s1,0(s1)
      free(m1);
    3dd6:	611010ef          	jal	5be6 <free>
    while (m1) {
    3dda:	fce5                	bnez	s1,3dd2 <mem+0x42>
    m1 = malloc(1024 * 20);
    3ddc:	6515                	lui	a0,0x5
    3dde:	68f010ef          	jal	5c6c <malloc>
    if (m1 == 0) {
    3de2:	c511                	beqz	a0,3dee <mem+0x5e>
    free(m1);
    3de4:	603010ef          	jal	5be6 <free>
    exit(0);
    3de8:	4501                	li	a0,0
    3dea:	189010ef          	jal	5772 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3dee:	85ce                	mv	a1,s3
    3df0:	00004517          	auipc	a0,0x4
    3df4:	c6050513          	addi	a0,a0,-928 # 7a50 <malloc+0x1de4>
    3df8:	5bd010ef          	jal	5bb4 <printf>
      exit(1);
    3dfc:	4505                	li	a0,1
    3dfe:	175010ef          	jal	5772 <exit>
      exit(0);
    3e02:	4501                	li	a0,0
    3e04:	16f010ef          	jal	5772 <exit>

0000000000003e08 <sharedfd>:
{
    3e08:	7119                	addi	sp,sp,-128
    3e0a:	fc86                	sd	ra,120(sp)
    3e0c:	f8a2                	sd	s0,112(sp)
    3e0e:	e0da                	sd	s6,64(sp)
    3e10:	0100                	addi	s0,sp,128
    3e12:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3e14:	00004517          	auipc	a0,0x4
    3e18:	c5c50513          	addi	a0,a0,-932 # 7a70 <malloc+0x1e04>
    3e1c:	1a7010ef          	jal	57c2 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3e20:	20200593          	li	a1,514
    3e24:	00004517          	auipc	a0,0x4
    3e28:	c4c50513          	addi	a0,a0,-948 # 7a70 <malloc+0x1e04>
    3e2c:	187010ef          	jal	57b2 <open>
  if (fd < 0) {
    3e30:	04054b63          	bltz	a0,3e86 <sharedfd+0x7e>
    3e34:	f4a6                	sd	s1,104(sp)
    3e36:	f0ca                	sd	s2,96(sp)
    3e38:	ecce                	sd	s3,88(sp)
    3e3a:	e8d2                	sd	s4,80(sp)
    3e3c:	e4d6                	sd	s5,72(sp)
    3e3e:	89aa                	mv	s3,a0
  pid = fork();
    3e40:	12b010ef          	jal	576a <fork>
    3e44:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3e46:	07000593          	li	a1,112
    3e4a:	e119                	bnez	a0,3e50 <sharedfd+0x48>
    3e4c:	06300593          	li	a1,99
    3e50:	4629                	li	a2,10
    3e52:	f9040513          	addi	a0,s0,-112
    3e56:	6e2010ef          	jal	5538 <memset>
    3e5a:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3e5e:	f9040a13          	addi	s4,s0,-112
    3e62:	4929                	li	s2,10
    3e64:	864a                	mv	a2,s2
    3e66:	85d2                	mv	a1,s4
    3e68:	854e                	mv	a0,s3
    3e6a:	129010ef          	jal	5792 <write>
    3e6e:	03251e63          	bne	a0,s2,3eaa <sharedfd+0xa2>
  for (i = 0; i < N; i++) {
    3e72:	34fd                	addiw	s1,s1,-1
    3e74:	f8e5                	bnez	s1,3e64 <sharedfd+0x5c>
  if (pid == 0) {
    3e76:	040a9763          	bnez	s5,3ec4 <sharedfd+0xbc>
    3e7a:	fc5e                	sd	s7,56(sp)
    3e7c:	f862                	sd	s8,48(sp)
    3e7e:	f466                	sd	s9,40(sp)
    exit(0);
    3e80:	4501                	li	a0,0
    3e82:	0f1010ef          	jal	5772 <exit>
    3e86:	f4a6                	sd	s1,104(sp)
    3e88:	f0ca                	sd	s2,96(sp)
    3e8a:	ecce                	sd	s3,88(sp)
    3e8c:	e8d2                	sd	s4,80(sp)
    3e8e:	e4d6                	sd	s5,72(sp)
    3e90:	fc5e                	sd	s7,56(sp)
    3e92:	f862                	sd	s8,48(sp)
    3e94:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3e96:	85da                	mv	a1,s6
    3e98:	00004517          	auipc	a0,0x4
    3e9c:	be850513          	addi	a0,a0,-1048 # 7a80 <malloc+0x1e14>
    3ea0:	515010ef          	jal	5bb4 <printf>
    exit(1);
    3ea4:	4505                	li	a0,1
    3ea6:	0cd010ef          	jal	5772 <exit>
    3eaa:	fc5e                	sd	s7,56(sp)
    3eac:	f862                	sd	s8,48(sp)
    3eae:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3eb0:	85da                	mv	a1,s6
    3eb2:	00004517          	auipc	a0,0x4
    3eb6:	bf650513          	addi	a0,a0,-1034 # 7aa8 <malloc+0x1e3c>
    3eba:	4fb010ef          	jal	5bb4 <printf>
      exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	0b3010ef          	jal	5772 <exit>
    wait(&xstatus);
    3ec4:	f8c40513          	addi	a0,s0,-116
    3ec8:	0b3010ef          	jal	577a <wait>
    if (xstatus != 0)
    3ecc:	f8c42a03          	lw	s4,-116(s0)
    3ed0:	000a0863          	beqz	s4,3ee0 <sharedfd+0xd8>
    3ed4:	fc5e                	sd	s7,56(sp)
    3ed6:	f862                	sd	s8,48(sp)
    3ed8:	f466                	sd	s9,40(sp)
      exit(xstatus);
    3eda:	8552                	mv	a0,s4
    3edc:	097010ef          	jal	5772 <exit>
    3ee0:	fc5e                	sd	s7,56(sp)
  close(fd);
    3ee2:	854e                	mv	a0,s3
    3ee4:	0b7010ef          	jal	579a <close>
  fd = open("sharedfd", 0);
    3ee8:	4581                	li	a1,0
    3eea:	00004517          	auipc	a0,0x4
    3eee:	b8650513          	addi	a0,a0,-1146 # 7a70 <malloc+0x1e04>
    3ef2:	0c1010ef          	jal	57b2 <open>
    3ef6:	8baa                	mv	s7,a0
  nc = np = 0;
    3ef8:	89d2                	mv	s3,s4
  if (fd < 0) {
    3efa:	02054763          	bltz	a0,3f28 <sharedfd+0x120>
    3efe:	f862                	sd	s8,48(sp)
    3f00:	f466                	sd	s9,40(sp)
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f02:	f9040c93          	addi	s9,s0,-112
    3f06:	4c29                	li	s8,10
    3f08:	f9a40913          	addi	s2,s0,-102
      if (buf[i] == 'c')
    3f0c:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3f10:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f14:	8662                	mv	a2,s8
    3f16:	85e6                	mv	a1,s9
    3f18:	855e                	mv	a0,s7
    3f1a:	071010ef          	jal	578a <read>
    3f1e:	02a05d63          	blez	a0,3f58 <sharedfd+0x150>
    3f22:	f9040793          	addi	a5,s0,-112
    3f26:	a00d                	j	3f48 <sharedfd+0x140>
    3f28:	f862                	sd	s8,48(sp)
    3f2a:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
    3f2c:	85da                	mv	a1,s6
    3f2e:	00004517          	auipc	a0,0x4
    3f32:	b9a50513          	addi	a0,a0,-1126 # 7ac8 <malloc+0x1e5c>
    3f36:	47f010ef          	jal	5bb4 <printf>
    exit(1);
    3f3a:	4505                	li	a0,1
    3f3c:	037010ef          	jal	5772 <exit>
        nc++;
    3f40:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3f42:	0785                	addi	a5,a5,1
    3f44:	fd2788e3          	beq	a5,s2,3f14 <sharedfd+0x10c>
      if (buf[i] == 'c')
    3f48:	0007c703          	lbu	a4,0(a5)
    3f4c:	fe970ae3          	beq	a4,s1,3f40 <sharedfd+0x138>
      if (buf[i] == 'p')
    3f50:	ff5719e3          	bne	a4,s5,3f42 <sharedfd+0x13a>
        np++;
    3f54:	2985                	addiw	s3,s3,1
    3f56:	b7f5                	j	3f42 <sharedfd+0x13a>
  close(fd);
    3f58:	855e                	mv	a0,s7
    3f5a:	041010ef          	jal	579a <close>
  unlink("sharedfd");
    3f5e:	00004517          	auipc	a0,0x4
    3f62:	b1250513          	addi	a0,a0,-1262 # 7a70 <malloc+0x1e04>
    3f66:	05d010ef          	jal	57c2 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3f6a:	6789                	lui	a5,0x2
    3f6c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x10a>
    3f70:	00fa1763          	bne	s4,a5,3f7e <sharedfd+0x176>
    3f74:	6789                	lui	a5,0x2
    3f76:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x10a>
    3f7a:	00f98c63          	beq	s3,a5,3f92 <sharedfd+0x18a>
    printf("%s: nc/np test fails\n", s);
    3f7e:	85da                	mv	a1,s6
    3f80:	00004517          	auipc	a0,0x4
    3f84:	b7050513          	addi	a0,a0,-1168 # 7af0 <malloc+0x1e84>
    3f88:	42d010ef          	jal	5bb4 <printf>
    exit(1);
    3f8c:	4505                	li	a0,1
    3f8e:	7e4010ef          	jal	5772 <exit>
    exit(0);
    3f92:	4501                	li	a0,0
    3f94:	7de010ef          	jal	5772 <exit>

0000000000003f98 <fourfiles>:
{
    3f98:	7135                	addi	sp,sp,-160
    3f9a:	ed06                	sd	ra,152(sp)
    3f9c:	e922                	sd	s0,144(sp)
    3f9e:	e526                	sd	s1,136(sp)
    3fa0:	e14a                	sd	s2,128(sp)
    3fa2:	fcce                	sd	s3,120(sp)
    3fa4:	f8d2                	sd	s4,112(sp)
    3fa6:	f4d6                	sd	s5,104(sp)
    3fa8:	f0da                	sd	s6,96(sp)
    3faa:	ecde                	sd	s7,88(sp)
    3fac:	e8e2                	sd	s8,80(sp)
    3fae:	e4e6                	sd	s9,72(sp)
    3fb0:	e0ea                	sd	s10,64(sp)
    3fb2:	fc6e                	sd	s11,56(sp)
    3fb4:	1100                	addi	s0,sp,160
    3fb6:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fb8:	00004797          	auipc	a5,0x4
    3fbc:	b5078793          	addi	a5,a5,-1200 # 7b08 <malloc+0x1e9c>
    3fc0:	f6f43823          	sd	a5,-144(s0)
    3fc4:	00004797          	auipc	a5,0x4
    3fc8:	b4c78793          	addi	a5,a5,-1204 # 7b10 <malloc+0x1ea4>
    3fcc:	f6f43c23          	sd	a5,-136(s0)
    3fd0:	00004797          	auipc	a5,0x4
    3fd4:	b4878793          	addi	a5,a5,-1208 # 7b18 <malloc+0x1eac>
    3fd8:	f8f43023          	sd	a5,-128(s0)
    3fdc:	00004797          	auipc	a5,0x4
    3fe0:	b4478793          	addi	a5,a5,-1212 # 7b20 <malloc+0x1eb4>
    3fe4:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3fe8:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fec:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3fee:	4481                	li	s1,0
    3ff0:	4a11                	li	s4,4
    fname = names[pi];
    3ff2:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3ff6:	854e                	mv	a0,s3
    3ff8:	7ca010ef          	jal	57c2 <unlink>
    pid = fork();
    3ffc:	76e010ef          	jal	576a <fork>
    if (pid < 0) {
    4000:	04054063          	bltz	a0,4040 <fourfiles+0xa8>
    if (pid == 0) {
    4004:	c921                	beqz	a0,4054 <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    4006:	2485                	addiw	s1,s1,1
    4008:	0921                	addi	s2,s2,8
    400a:	ff4494e3          	bne	s1,s4,3ff2 <fourfiles+0x5a>
    400e:	4491                	li	s1,4
    wait(&xstatus);
    4010:	f6c40913          	addi	s2,s0,-148
    4014:	854a                	mv	a0,s2
    4016:	764010ef          	jal	577a <wait>
    if (xstatus != 0)
    401a:	f6c42b03          	lw	s6,-148(s0)
    401e:	0a0b1463          	bnez	s6,40c6 <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    4022:	34fd                	addiw	s1,s1,-1
    4024:	f8e5                	bnez	s1,4014 <fourfiles+0x7c>
    4026:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    402a:	6a8d                	lui	s5,0x3
    402c:	00009a17          	auipc	s4,0x9
    4030:	ccca0a13          	addi	s4,s4,-820 # ccf8 <buf>
    if (total != N * SZ) {
    4034:	6d05                	lui	s10,0x1
    4036:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    403a:	03400d93          	li	s11,52
    403e:	a86d                	j	40f8 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    4040:	85e6                	mv	a1,s9
    4042:	00002517          	auipc	a0,0x2
    4046:	5e650513          	addi	a0,a0,1510 # 6628 <malloc+0x9bc>
    404a:	36b010ef          	jal	5bb4 <printf>
      exit(1);
    404e:	4505                	li	a0,1
    4050:	722010ef          	jal	5772 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4054:	20200593          	li	a1,514
    4058:	854e                	mv	a0,s3
    405a:	758010ef          	jal	57b2 <open>
    405e:	892a                	mv	s2,a0
      if (fd < 0) {
    4060:	04054063          	bltz	a0,40a0 <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    4064:	1f400613          	li	a2,500
    4068:	0304859b          	addiw	a1,s1,48
    406c:	00009517          	auipc	a0,0x9
    4070:	c8c50513          	addi	a0,a0,-884 # ccf8 <buf>
    4074:	4c4010ef          	jal	5538 <memset>
    4078:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    407a:	1f400993          	li	s3,500
    407e:	00009a17          	auipc	s4,0x9
    4082:	c7aa0a13          	addi	s4,s4,-902 # ccf8 <buf>
    4086:	864e                	mv	a2,s3
    4088:	85d2                	mv	a1,s4
    408a:	854a                	mv	a0,s2
    408c:	706010ef          	jal	5792 <write>
    4090:	85aa                	mv	a1,a0
    4092:	03351163          	bne	a0,s3,40b4 <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    4096:	34fd                	addiw	s1,s1,-1
    4098:	f4fd                	bnez	s1,4086 <fourfiles+0xee>
      exit(0);
    409a:	4501                	li	a0,0
    409c:	6d6010ef          	jal	5772 <exit>
        printf("%s: create failed\n", s);
    40a0:	85e6                	mv	a1,s9
    40a2:	00002517          	auipc	a0,0x2
    40a6:	6f650513          	addi	a0,a0,1782 # 6798 <malloc+0xb2c>
    40aa:	30b010ef          	jal	5bb4 <printf>
        exit(1);
    40ae:	4505                	li	a0,1
    40b0:	6c2010ef          	jal	5772 <exit>
          printf("write failed %d\n", n);
    40b4:	00004517          	auipc	a0,0x4
    40b8:	a7450513          	addi	a0,a0,-1420 # 7b28 <malloc+0x1ebc>
    40bc:	2f9010ef          	jal	5bb4 <printf>
          exit(1);
    40c0:	4505                	li	a0,1
    40c2:	6b0010ef          	jal	5772 <exit>
      exit(xstatus);
    40c6:	855a                	mv	a0,s6
    40c8:	6aa010ef          	jal	5772 <exit>
          printf("%s: wrong char\n", s);
    40cc:	85e6                	mv	a1,s9
    40ce:	00004517          	auipc	a0,0x4
    40d2:	a7250513          	addi	a0,a0,-1422 # 7b40 <malloc+0x1ed4>
    40d6:	2df010ef          	jal	5bb4 <printf>
          exit(1);
    40da:	4505                	li	a0,1
    40dc:	696010ef          	jal	5772 <exit>
    close(fd);
    40e0:	854e                	mv	a0,s3
    40e2:	6b8010ef          	jal	579a <close>
    if (total != N * SZ) {
    40e6:	05a91863          	bne	s2,s10,4136 <fourfiles+0x19e>
    unlink(fname);
    40ea:	8562                	mv	a0,s8
    40ec:	6d6010ef          	jal	57c2 <unlink>
  for (i = 0; i < NCHILD; i++) {
    40f0:	0ba1                	addi	s7,s7,8
    40f2:	2485                	addiw	s1,s1,1
    40f4:	05b48b63          	beq	s1,s11,414a <fourfiles+0x1b2>
    fname = names[i];
    40f8:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    40fc:	4581                	li	a1,0
    40fe:	8562                	mv	a0,s8
    4100:	6b2010ef          	jal	57b2 <open>
    4104:	89aa                	mv	s3,a0
    total = 0;
    4106:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4108:	8656                	mv	a2,s5
    410a:	85d2                	mv	a1,s4
    410c:	854e                	mv	a0,s3
    410e:	67c010ef          	jal	578a <read>
    4112:	fca057e3          	blez	a0,40e0 <fourfiles+0x148>
    4116:	00009797          	auipc	a5,0x9
    411a:	be278793          	addi	a5,a5,-1054 # ccf8 <buf>
    411e:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    4122:	0007c703          	lbu	a4,0(a5)
    4126:	fa9713e3          	bne	a4,s1,40cc <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    412a:	0785                	addi	a5,a5,1
    412c:	fed79be3          	bne	a5,a3,4122 <fourfiles+0x18a>
      total += n;
    4130:	00a9093b          	addw	s2,s2,a0
    4134:	bfd1                	j	4108 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    4136:	85ca                	mv	a1,s2
    4138:	00004517          	auipc	a0,0x4
    413c:	a1850513          	addi	a0,a0,-1512 # 7b50 <malloc+0x1ee4>
    4140:	275010ef          	jal	5bb4 <printf>
      exit(1);
    4144:	4505                	li	a0,1
    4146:	62c010ef          	jal	5772 <exit>
}
    414a:	60ea                	ld	ra,152(sp)
    414c:	644a                	ld	s0,144(sp)
    414e:	64aa                	ld	s1,136(sp)
    4150:	690a                	ld	s2,128(sp)
    4152:	79e6                	ld	s3,120(sp)
    4154:	7a46                	ld	s4,112(sp)
    4156:	7aa6                	ld	s5,104(sp)
    4158:	7b06                	ld	s6,96(sp)
    415a:	6be6                	ld	s7,88(sp)
    415c:	6c46                	ld	s8,80(sp)
    415e:	6ca6                	ld	s9,72(sp)
    4160:	6d06                	ld	s10,64(sp)
    4162:	7de2                	ld	s11,56(sp)
    4164:	610d                	addi	sp,sp,160
    4166:	8082                	ret

0000000000004168 <concreate>:
{
    4168:	7171                	addi	sp,sp,-176
    416a:	f506                	sd	ra,168(sp)
    416c:	f122                	sd	s0,160(sp)
    416e:	ed26                	sd	s1,152(sp)
    4170:	e94a                	sd	s2,144(sp)
    4172:	e54e                	sd	s3,136(sp)
    4174:	e152                	sd	s4,128(sp)
    4176:	fcd6                	sd	s5,120(sp)
    4178:	f8da                	sd	s6,112(sp)
    417a:	f4de                	sd	s7,104(sp)
    417c:	f0e2                	sd	s8,96(sp)
    417e:	ece6                	sd	s9,88(sp)
    4180:	e8ea                	sd	s10,80(sp)
    4182:	1900                	addi	s0,sp,176
    4184:	8baa                	mv	s7,a0
  file[0] = 'C';
    4186:	04300793          	li	a5,67
    418a:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    418e:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    4192:	4901                	li	s2,0
    unlink(file);
    4194:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    4198:	55555b37          	lui	s6,0x55555
    419c:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554585e>
    41a0:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
    41a2:	20200c93          	li	s9,514
      link("C0", file);
    41a6:	00004d17          	auipc	s10,0x4
    41aa:	9c2d0d13          	addi	s10,s10,-1598 # 7b68 <malloc+0x1efc>
      wait(&xstatus);
    41ae:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    41b2:	02800a13          	li	s4,40
    41b6:	ac2d                	j	43f0 <concreate+0x288>
      link("C0", file);
    41b8:	85ce                	mv	a1,s3
    41ba:	856a                	mv	a0,s10
    41bc:	616010ef          	jal	57d2 <link>
    if (pid == 0) {
    41c0:	ac31                	j	43dc <concreate+0x274>
    } else if (pid == 0 && (i % 5) == 1) {
    41c2:	666667b7          	lui	a5,0x66666
    41c6:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665696f>
    41ca:	02f907b3          	mul	a5,s2,a5
    41ce:	9785                	srai	a5,a5,0x21
    41d0:	41f9571b          	sraiw	a4,s2,0x1f
    41d4:	9f99                	subw	a5,a5,a4
    41d6:	0027971b          	slliw	a4,a5,0x2
    41da:	9fb9                	addw	a5,a5,a4
    41dc:	40f9093b          	subw	s2,s2,a5
    41e0:	4785                	li	a5,1
    41e2:	02f90563          	beq	s2,a5,420c <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    41e6:	20200593          	li	a1,514
    41ea:	f9840513          	addi	a0,s0,-104
    41ee:	5c4010ef          	jal	57b2 <open>
      if (fd < 0) {
    41f2:	1e055063          	bgez	a0,43d2 <concreate+0x26a>
        printf("concreate create %s failed\n", file);
    41f6:	f9840593          	addi	a1,s0,-104
    41fa:	00004517          	auipc	a0,0x4
    41fe:	97650513          	addi	a0,a0,-1674 # 7b70 <malloc+0x1f04>
    4202:	1b3010ef          	jal	5bb4 <printf>
        exit(1);
    4206:	4505                	li	a0,1
    4208:	56a010ef          	jal	5772 <exit>
      link("C0", file);
    420c:	f9840593          	addi	a1,s0,-104
    4210:	00004517          	auipc	a0,0x4
    4214:	95850513          	addi	a0,a0,-1704 # 7b68 <malloc+0x1efc>
    4218:	5ba010ef          	jal	57d2 <link>
      exit(0);
    421c:	4501                	li	a0,0
    421e:	554010ef          	jal	5772 <exit>
        exit(1);
    4222:	4505                	li	a0,1
    4224:	54e010ef          	jal	5772 <exit>
  memset(fa, 0, sizeof(fa));
    4228:	02800613          	li	a2,40
    422c:	4581                	li	a1,0
    422e:	f7040513          	addi	a0,s0,-144
    4232:	306010ef          	jal	5538 <memset>
  fd = open(".", 0);
    4236:	4581                	li	a1,0
    4238:	00002517          	auipc	a0,0x2
    423c:	24850513          	addi	a0,a0,584 # 6480 <malloc+0x814>
    4240:	572010ef          	jal	57b2 <open>
    4244:	892a                	mv	s2,a0
  n = 0;
    4246:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    4248:	f6040a13          	addi	s4,s0,-160
    424c:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    424e:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    4252:	02700c13          	li	s8,39
      fa[i] = 1;
    4256:	4c85                	li	s9,1
  while (read(fd, &de, sizeof(de)) > 0) {
    4258:	864e                	mv	a2,s3
    425a:	85d2                	mv	a1,s4
    425c:	854a                	mv	a0,s2
    425e:	52c010ef          	jal	578a <read>
    4262:	06a05763          	blez	a0,42d0 <concreate+0x168>
    if (de.inum == 0)
    4266:	f6045783          	lhu	a5,-160(s0)
    426a:	d7fd                	beqz	a5,4258 <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    426c:	f6244783          	lbu	a5,-158(s0)
    4270:	ff5794e3          	bne	a5,s5,4258 <concreate+0xf0>
    4274:	f6444783          	lbu	a5,-156(s0)
    4278:	f3e5                	bnez	a5,4258 <concreate+0xf0>
      i = de.name[1] - '0';
    427a:	f6344783          	lbu	a5,-157(s0)
    427e:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    4282:	00fc6f63          	bltu	s8,a5,42a0 <concreate+0x138>
      if (fa[i]) {
    4286:	fa078713          	addi	a4,a5,-96
    428a:	9722                	add	a4,a4,s0
    428c:	fd074703          	lbu	a4,-48(a4)
    4290:	e705                	bnez	a4,42b8 <concreate+0x150>
      fa[i] = 1;
    4292:	fa078793          	addi	a5,a5,-96
    4296:	97a2                	add	a5,a5,s0
    4298:	fd978823          	sb	s9,-48(a5)
      n++;
    429c:	2b05                	addiw	s6,s6,1
    429e:	bf6d                	j	4258 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    42a0:	f6240613          	addi	a2,s0,-158
    42a4:	85de                	mv	a1,s7
    42a6:	00004517          	auipc	a0,0x4
    42aa:	8ea50513          	addi	a0,a0,-1814 # 7b90 <malloc+0x1f24>
    42ae:	107010ef          	jal	5bb4 <printf>
        exit(1);
    42b2:	4505                	li	a0,1
    42b4:	4be010ef          	jal	5772 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    42b8:	f6240613          	addi	a2,s0,-158
    42bc:	85de                	mv	a1,s7
    42be:	00004517          	auipc	a0,0x4
    42c2:	8f250513          	addi	a0,a0,-1806 # 7bb0 <malloc+0x1f44>
    42c6:	0ef010ef          	jal	5bb4 <printf>
        exit(1);
    42ca:	4505                	li	a0,1
    42cc:	4a6010ef          	jal	5772 <exit>
  close(fd);
    42d0:	854a                	mv	a0,s2
    42d2:	4c8010ef          	jal	579a <close>
  if (n != N) {
    42d6:	02800793          	li	a5,40
    42da:	00fb1b63          	bne	s6,a5,42f0 <concreate+0x188>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42de:	55555a37          	lui	s4,0x55555
    42e2:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554585e>
      close(open(file, 0));
    42e6:	f9840993          	addi	s3,s0,-104
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42ea:	4b05                	li	s6,1
  for (i = 0; i < N; i++) {
    42ec:	8abe                	mv	s5,a5
    42ee:	a049                	j	4370 <concreate+0x208>
    printf("%s: concreate not enough files in directory listing\n", s);
    42f0:	85de                	mv	a1,s7
    42f2:	00004517          	auipc	a0,0x4
    42f6:	8e650513          	addi	a0,a0,-1818 # 7bd8 <malloc+0x1f6c>
    42fa:	0bb010ef          	jal	5bb4 <printf>
    exit(1);
    42fe:	4505                	li	a0,1
    4300:	472010ef          	jal	5772 <exit>
      printf("%s: fork failed\n", s);
    4304:	85de                	mv	a1,s7
    4306:	00002517          	auipc	a0,0x2
    430a:	32250513          	addi	a0,a0,802 # 6628 <malloc+0x9bc>
    430e:	0a7010ef          	jal	5bb4 <printf>
      exit(1);
    4312:	4505                	li	a0,1
    4314:	45e010ef          	jal	5772 <exit>
      close(open(file, 0));
    4318:	4581                	li	a1,0
    431a:	854e                	mv	a0,s3
    431c:	496010ef          	jal	57b2 <open>
    4320:	47a010ef          	jal	579a <close>
      close(open(file, 0));
    4324:	4581                	li	a1,0
    4326:	854e                	mv	a0,s3
    4328:	48a010ef          	jal	57b2 <open>
    432c:	46e010ef          	jal	579a <close>
      close(open(file, 0));
    4330:	4581                	li	a1,0
    4332:	854e                	mv	a0,s3
    4334:	47e010ef          	jal	57b2 <open>
    4338:	462010ef          	jal	579a <close>
      close(open(file, 0));
    433c:	4581                	li	a1,0
    433e:	854e                	mv	a0,s3
    4340:	472010ef          	jal	57b2 <open>
    4344:	456010ef          	jal	579a <close>
      close(open(file, 0));
    4348:	4581                	li	a1,0
    434a:	854e                	mv	a0,s3
    434c:	466010ef          	jal	57b2 <open>
    4350:	44a010ef          	jal	579a <close>
      close(open(file, 0));
    4354:	4581                	li	a1,0
    4356:	854e                	mv	a0,s3
    4358:	45a010ef          	jal	57b2 <open>
    435c:	43e010ef          	jal	579a <close>
    if (pid == 0)
    4360:	06090663          	beqz	s2,43cc <concreate+0x264>
      wait(0);
    4364:	4501                	li	a0,0
    4366:	414010ef          	jal	577a <wait>
  for (i = 0; i < N; i++) {
    436a:	2485                	addiw	s1,s1,1
    436c:	0d548163          	beq	s1,s5,442e <concreate+0x2c6>
    file[1] = '0' + i;
    4370:	0304879b          	addiw	a5,s1,48
    4374:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    4378:	3f2010ef          	jal	576a <fork>
    437c:	892a                	mv	s2,a0
    if (pid < 0) {
    437e:	f80543e3          	bltz	a0,4304 <concreate+0x19c>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4382:	03448733          	mul	a4,s1,s4
    4386:	9301                	srli	a4,a4,0x20
    4388:	41f4d79b          	sraiw	a5,s1,0x1f
    438c:	9f1d                	subw	a4,a4,a5
    438e:	0017179b          	slliw	a5,a4,0x1
    4392:	9fb9                	addw	a5,a5,a4
    4394:	40f487bb          	subw	a5,s1,a5
    4398:	873e                	mv	a4,a5
    439a:	8fc9                	or	a5,a5,a0
    439c:	2781                	sext.w	a5,a5
    439e:	dfad                	beqz	a5,4318 <concreate+0x1b0>
    43a0:	01671363          	bne	a4,s6,43a6 <concreate+0x23e>
    43a4:	f935                	bnez	a0,4318 <concreate+0x1b0>
      unlink(file);
    43a6:	854e                	mv	a0,s3
    43a8:	41a010ef          	jal	57c2 <unlink>
      unlink(file);
    43ac:	854e                	mv	a0,s3
    43ae:	414010ef          	jal	57c2 <unlink>
      unlink(file);
    43b2:	854e                	mv	a0,s3
    43b4:	40e010ef          	jal	57c2 <unlink>
      unlink(file);
    43b8:	854e                	mv	a0,s3
    43ba:	408010ef          	jal	57c2 <unlink>
      unlink(file);
    43be:	854e                	mv	a0,s3
    43c0:	402010ef          	jal	57c2 <unlink>
      unlink(file);
    43c4:	854e                	mv	a0,s3
    43c6:	3fc010ef          	jal	57c2 <unlink>
    43ca:	bf59                	j	4360 <concreate+0x1f8>
      exit(0);
    43cc:	4501                	li	a0,0
    43ce:	3a4010ef          	jal	5772 <exit>
      close(fd);
    43d2:	3c8010ef          	jal	579a <close>
    if (pid == 0) {
    43d6:	b599                	j	421c <concreate+0xb4>
      close(fd);
    43d8:	3c2010ef          	jal	579a <close>
      wait(&xstatus);
    43dc:	8556                	mv	a0,s5
    43de:	39c010ef          	jal	577a <wait>
      if (xstatus != 0)
    43e2:	f5c42483          	lw	s1,-164(s0)
    43e6:	e2049ee3          	bnez	s1,4222 <concreate+0xba>
  for (i = 0; i < N; i++) {
    43ea:	2905                	addiw	s2,s2,1
    43ec:	e3490ee3          	beq	s2,s4,4228 <concreate+0xc0>
    file[1] = '0' + i;
    43f0:	0309079b          	addiw	a5,s2,48
    43f4:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    43f8:	854e                	mv	a0,s3
    43fa:	3c8010ef          	jal	57c2 <unlink>
    pid = fork();
    43fe:	36c010ef          	jal	576a <fork>
    if (pid && (i % 3) == 1) {
    4402:	dc0500e3          	beqz	a0,41c2 <concreate+0x5a>
    4406:	036907b3          	mul	a5,s2,s6
    440a:	9381                	srli	a5,a5,0x20
    440c:	41f9571b          	sraiw	a4,s2,0x1f
    4410:	9f99                	subw	a5,a5,a4
    4412:	0017971b          	slliw	a4,a5,0x1
    4416:	9fb9                	addw	a5,a5,a4
    4418:	40f907bb          	subw	a5,s2,a5
    441c:	d9878ee3          	beq	a5,s8,41b8 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4420:	85e6                	mv	a1,s9
    4422:	854e                	mv	a0,s3
    4424:	38e010ef          	jal	57b2 <open>
      if (fd < 0) {
    4428:	fa0558e3          	bgez	a0,43d8 <concreate+0x270>
    442c:	b3e9                	j	41f6 <concreate+0x8e>
}
    442e:	70aa                	ld	ra,168(sp)
    4430:	740a                	ld	s0,160(sp)
    4432:	64ea                	ld	s1,152(sp)
    4434:	694a                	ld	s2,144(sp)
    4436:	69aa                	ld	s3,136(sp)
    4438:	6a0a                	ld	s4,128(sp)
    443a:	7ae6                	ld	s5,120(sp)
    443c:	7b46                	ld	s6,112(sp)
    443e:	7ba6                	ld	s7,104(sp)
    4440:	7c06                	ld	s8,96(sp)
    4442:	6ce6                	ld	s9,88(sp)
    4444:	6d46                	ld	s10,80(sp)
    4446:	614d                	addi	sp,sp,176
    4448:	8082                	ret

000000000000444a <bigfile>:
{
    444a:	7139                	addi	sp,sp,-64
    444c:	fc06                	sd	ra,56(sp)
    444e:	f822                	sd	s0,48(sp)
    4450:	f426                	sd	s1,40(sp)
    4452:	f04a                	sd	s2,32(sp)
    4454:	ec4e                	sd	s3,24(sp)
    4456:	e852                	sd	s4,16(sp)
    4458:	e456                	sd	s5,8(sp)
    445a:	e05a                	sd	s6,0(sp)
    445c:	0080                	addi	s0,sp,64
    445e:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    4460:	00003517          	auipc	a0,0x3
    4464:	7b050513          	addi	a0,a0,1968 # 7c10 <malloc+0x1fa4>
    4468:	35a010ef          	jal	57c2 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    446c:	20200593          	li	a1,514
    4470:	00003517          	auipc	a0,0x3
    4474:	7a050513          	addi	a0,a0,1952 # 7c10 <malloc+0x1fa4>
    4478:	33a010ef          	jal	57b2 <open>
  if (fd < 0) {
    447c:	08054a63          	bltz	a0,4510 <bigfile+0xc6>
    4480:	8a2a                	mv	s4,a0
    4482:	4481                	li	s1,0
    memset(buf, i, SZ);
    4484:	25800913          	li	s2,600
    4488:	00009997          	auipc	s3,0x9
    448c:	87098993          	addi	s3,s3,-1936 # ccf8 <buf>
  for (i = 0; i < N; i++) {
    4490:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    4492:	864a                	mv	a2,s2
    4494:	85a6                	mv	a1,s1
    4496:	854e                	mv	a0,s3
    4498:	0a0010ef          	jal	5538 <memset>
    if (write(fd, buf, SZ) != SZ) {
    449c:	864a                	mv	a2,s2
    449e:	85ce                	mv	a1,s3
    44a0:	8552                	mv	a0,s4
    44a2:	2f0010ef          	jal	5792 <write>
    44a6:	07251f63          	bne	a0,s2,4524 <bigfile+0xda>
  for (i = 0; i < N; i++) {
    44aa:	2485                	addiw	s1,s1,1
    44ac:	ff5493e3          	bne	s1,s5,4492 <bigfile+0x48>
  close(fd);
    44b0:	8552                	mv	a0,s4
    44b2:	2e8010ef          	jal	579a <close>
  fd = open("bigfile.dat", 0);
    44b6:	4581                	li	a1,0
    44b8:	00003517          	auipc	a0,0x3
    44bc:	75850513          	addi	a0,a0,1880 # 7c10 <malloc+0x1fa4>
    44c0:	2f2010ef          	jal	57b2 <open>
    44c4:	8aaa                	mv	s5,a0
  total = 0;
    44c6:	4a01                	li	s4,0
  for (i = 0;; i++) {
    44c8:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    44ca:	12c00993          	li	s3,300
    44ce:	00009917          	auipc	s2,0x9
    44d2:	82a90913          	addi	s2,s2,-2006 # ccf8 <buf>
  if (fd < 0) {
    44d6:	06054163          	bltz	a0,4538 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    44da:	864e                	mv	a2,s3
    44dc:	85ca                	mv	a1,s2
    44de:	8556                	mv	a0,s5
    44e0:	2aa010ef          	jal	578a <read>
    if (cc < 0) {
    44e4:	06054463          	bltz	a0,454c <bigfile+0x102>
    if (cc == 0)
    44e8:	c145                	beqz	a0,4588 <bigfile+0x13e>
    if (cc != SZ / 2) {
    44ea:	07351b63          	bne	a0,s3,4560 <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    44ee:	01f4d79b          	srliw	a5,s1,0x1f
    44f2:	9fa5                	addw	a5,a5,s1
    44f4:	4017d79b          	sraiw	a5,a5,0x1
    44f8:	00094703          	lbu	a4,0(s2)
    44fc:	06f71c63          	bne	a4,a5,4574 <bigfile+0x12a>
    4500:	12b94703          	lbu	a4,299(s2)
    4504:	06f71863          	bne	a4,a5,4574 <bigfile+0x12a>
    total += cc;
    4508:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    450c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    450e:	b7f1                	j	44da <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4510:	85da                	mv	a1,s6
    4512:	00003517          	auipc	a0,0x3
    4516:	70e50513          	addi	a0,a0,1806 # 7c20 <malloc+0x1fb4>
    451a:	69a010ef          	jal	5bb4 <printf>
    exit(1);
    451e:	4505                	li	a0,1
    4520:	252010ef          	jal	5772 <exit>
      printf("%s: write bigfile failed\n", s);
    4524:	85da                	mv	a1,s6
    4526:	00003517          	auipc	a0,0x3
    452a:	71a50513          	addi	a0,a0,1818 # 7c40 <malloc+0x1fd4>
    452e:	686010ef          	jal	5bb4 <printf>
      exit(1);
    4532:	4505                	li	a0,1
    4534:	23e010ef          	jal	5772 <exit>
    printf("%s: cannot open bigfile\n", s);
    4538:	85da                	mv	a1,s6
    453a:	00003517          	auipc	a0,0x3
    453e:	72650513          	addi	a0,a0,1830 # 7c60 <malloc+0x1ff4>
    4542:	672010ef          	jal	5bb4 <printf>
    exit(1);
    4546:	4505                	li	a0,1
    4548:	22a010ef          	jal	5772 <exit>
      printf("%s: read bigfile failed\n", s);
    454c:	85da                	mv	a1,s6
    454e:	00003517          	auipc	a0,0x3
    4552:	73250513          	addi	a0,a0,1842 # 7c80 <malloc+0x2014>
    4556:	65e010ef          	jal	5bb4 <printf>
      exit(1);
    455a:	4505                	li	a0,1
    455c:	216010ef          	jal	5772 <exit>
      printf("%s: short read bigfile\n", s);
    4560:	85da                	mv	a1,s6
    4562:	00003517          	auipc	a0,0x3
    4566:	73e50513          	addi	a0,a0,1854 # 7ca0 <malloc+0x2034>
    456a:	64a010ef          	jal	5bb4 <printf>
      exit(1);
    456e:	4505                	li	a0,1
    4570:	202010ef          	jal	5772 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4574:	85da                	mv	a1,s6
    4576:	00003517          	auipc	a0,0x3
    457a:	74250513          	addi	a0,a0,1858 # 7cb8 <malloc+0x204c>
    457e:	636010ef          	jal	5bb4 <printf>
      exit(1);
    4582:	4505                	li	a0,1
    4584:	1ee010ef          	jal	5772 <exit>
  close(fd);
    4588:	8556                	mv	a0,s5
    458a:	210010ef          	jal	579a <close>
  if (total != N * SZ) {
    458e:	678d                	lui	a5,0x3
    4590:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x374>
    4594:	02fa1263          	bne	s4,a5,45b8 <bigfile+0x16e>
  unlink("bigfile.dat");
    4598:	00003517          	auipc	a0,0x3
    459c:	67850513          	addi	a0,a0,1656 # 7c10 <malloc+0x1fa4>
    45a0:	222010ef          	jal	57c2 <unlink>
}
    45a4:	70e2                	ld	ra,56(sp)
    45a6:	7442                	ld	s0,48(sp)
    45a8:	74a2                	ld	s1,40(sp)
    45aa:	7902                	ld	s2,32(sp)
    45ac:	69e2                	ld	s3,24(sp)
    45ae:	6a42                	ld	s4,16(sp)
    45b0:	6aa2                	ld	s5,8(sp)
    45b2:	6b02                	ld	s6,0(sp)
    45b4:	6121                	addi	sp,sp,64
    45b6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    45b8:	85da                	mv	a1,s6
    45ba:	00003517          	auipc	a0,0x3
    45be:	71e50513          	addi	a0,a0,1822 # 7cd8 <malloc+0x206c>
    45c2:	5f2010ef          	jal	5bb4 <printf>
    exit(1);
    45c6:	4505                	li	a0,1
    45c8:	1aa010ef          	jal	5772 <exit>

00000000000045cc <bigargtest>:
{
    45cc:	7121                	addi	sp,sp,-448
    45ce:	ff06                	sd	ra,440(sp)
    45d0:	fb22                	sd	s0,432(sp)
    45d2:	f726                	sd	s1,424(sp)
    45d4:	0380                	addi	s0,sp,448
    45d6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    45d8:	00003517          	auipc	a0,0x3
    45dc:	72050513          	addi	a0,a0,1824 # 7cf8 <malloc+0x208c>
    45e0:	1e2010ef          	jal	57c2 <unlink>
  pid = fork();
    45e4:	186010ef          	jal	576a <fork>
  if (pid == 0) {
    45e8:	c915                	beqz	a0,461c <bigargtest+0x50>
  } else if (pid < 0) {
    45ea:	08054a63          	bltz	a0,467e <bigargtest+0xb2>
  wait(&xstatus);
    45ee:	fdc40513          	addi	a0,s0,-36
    45f2:	188010ef          	jal	577a <wait>
  if (xstatus != 0)
    45f6:	fdc42503          	lw	a0,-36(s0)
    45fa:	ed41                	bnez	a0,4692 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    45fc:	4581                	li	a1,0
    45fe:	00003517          	auipc	a0,0x3
    4602:	6fa50513          	addi	a0,a0,1786 # 7cf8 <malloc+0x208c>
    4606:	1ac010ef          	jal	57b2 <open>
  if (fd < 0) {
    460a:	08054663          	bltz	a0,4696 <bigargtest+0xca>
  close(fd);
    460e:	18c010ef          	jal	579a <close>
}
    4612:	70fa                	ld	ra,440(sp)
    4614:	745a                	ld	s0,432(sp)
    4616:	74ba                	ld	s1,424(sp)
    4618:	6139                	addi	sp,sp,448
    461a:	8082                	ret
    memset(big, ' ', sizeof(big));
    461c:	19000613          	li	a2,400
    4620:	02000593          	li	a1,32
    4624:	e4840513          	addi	a0,s0,-440
    4628:	711000ef          	jal	5538 <memset>
    big[sizeof(big) - 1] = '\0';
    462c:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    4630:	00005797          	auipc	a5,0x5
    4634:	eb078793          	addi	a5,a5,-336 # 94e0 <args.1>
    4638:	00005697          	auipc	a3,0x5
    463c:	fa068693          	addi	a3,a3,-96 # 95d8 <args.1+0xf8>
      args[i] = big;
    4640:	e4840713          	addi	a4,s0,-440
    4644:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    4646:	07a1                	addi	a5,a5,8
    4648:	fed79ee3          	bne	a5,a3,4644 <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    464c:	00005597          	auipc	a1,0x5
    4650:	e9458593          	addi	a1,a1,-364 # 94e0 <args.1>
    4654:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4658:	00001517          	auipc	a0,0x1
    465c:	74050513          	addi	a0,a0,1856 # 5d98 <malloc+0x12c>
    4660:	14a010ef          	jal	57aa <exec>
    fd = open("bigarg-ok", O_CREATE);
    4664:	20000593          	li	a1,512
    4668:	00003517          	auipc	a0,0x3
    466c:	69050513          	addi	a0,a0,1680 # 7cf8 <malloc+0x208c>
    4670:	142010ef          	jal	57b2 <open>
    close(fd);
    4674:	126010ef          	jal	579a <close>
    exit(0);
    4678:	4501                	li	a0,0
    467a:	0f8010ef          	jal	5772 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    467e:	85a6                	mv	a1,s1
    4680:	00003517          	auipc	a0,0x3
    4684:	68850513          	addi	a0,a0,1672 # 7d08 <malloc+0x209c>
    4688:	52c010ef          	jal	5bb4 <printf>
    exit(1);
    468c:	4505                	li	a0,1
    468e:	0e4010ef          	jal	5772 <exit>
    exit(xstatus);
    4692:	0e0010ef          	jal	5772 <exit>
    printf("%s: bigarg test failed!\n", s);
    4696:	85a6                	mv	a1,s1
    4698:	00003517          	auipc	a0,0x3
    469c:	69050513          	addi	a0,a0,1680 # 7d28 <malloc+0x20bc>
    46a0:	514010ef          	jal	5bb4 <printf>
    exit(1);
    46a4:	4505                	li	a0,1
    46a6:	0cc010ef          	jal	5772 <exit>

00000000000046aa <partial_write>:
{
    46aa:	bb010113          	addi	sp,sp,-1104
    46ae:	44113423          	sd	ra,1096(sp)
    46b2:	44813023          	sd	s0,1088(sp)
    46b6:	42913c23          	sd	s1,1080(sp)
    46ba:	43213823          	sd	s2,1072(sp)
    46be:	43313423          	sd	s3,1064(sp)
    46c2:	43413023          	sd	s4,1056(sp)
    46c6:	41513c23          	sd	s5,1048(sp)
    46ca:	45010413          	addi	s0,sp,1104
    46ce:	8aaa                	mv	s5,a0
  unlink("testfile");
    46d0:	00003517          	auipc	a0,0x3
    46d4:	67850513          	addi	a0,a0,1656 # 7d48 <malloc+0x20dc>
    46d8:	0ea010ef          	jal	57c2 <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    46dc:	20200593          	li	a1,514
    46e0:	00003517          	auipc	a0,0x3
    46e4:	66850513          	addi	a0,a0,1640 # 7d48 <malloc+0x20dc>
    46e8:	0ca010ef          	jal	57b2 <open>
  if (fd < 0) {
    46ec:	16054163          	bltz	a0,484e <partial_write+0x1a4>
    46f0:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    46f2:	4605                	li	a2,1
    46f4:	00003597          	auipc	a1,0x3
    46f8:	68458593          	addi	a1,a1,1668 # 7d78 <malloc+0x210c>
    46fc:	096010ef          	jal	5792 <write>
  if (cc != 1) {
    4700:	4785                	li	a5,1
    4702:	16f51063          	bne	a0,a5,4862 <partial_write+0x1b8>
  close(fd);
    4706:	8526                	mv	a0,s1
    4708:	092010ef          	jal	579a <close>
  fd = open("testfile", O_RDWR);
    470c:	4589                	li	a1,2
    470e:	00003517          	auipc	a0,0x3
    4712:	63a50513          	addi	a0,a0,1594 # 7d48 <malloc+0x20dc>
    4716:	09c010ef          	jal	57b2 <open>
    471a:	84aa                	mv	s1,a0
  if (fd < 0) {
    471c:	14054d63          	bltz	a0,4876 <partial_write+0x1cc>
  char *p = sbrk(0);
    4720:	4501                	li	a0,0
    4722:	01c010ef          	jal	573e <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4726:	6705                	lui	a4,0x1
    4728:	fff70913          	addi	s2,a4,-1 # fff <bigdir+0x109>
    472c:	01257533          	and	a0,a0,s2
    4730:	40a7053b          	subw	a0,a4,a0
    4734:	00a010ef          	jal	573e <sbrk>
  p = sbrk(0);
    4738:	4501                	li	a0,0
    473a:	004010ef          	jal	573e <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    473e:	01257933          	and	s2,a0,s2
    4742:	14091463          	bnez	s2,488a <partial_write+0x1e0>
  p[-1] = 'X';
    4746:	05800793          	li	a5,88
    474a:	fef50fa3          	sb	a5,-1(a0)
  cc = write(fd, p - 1, 2);
    474e:	4609                	li	a2,2
    4750:	fff50593          	addi	a1,a0,-1
    4754:	8526                	mv	a0,s1
    4756:	03c010ef          	jal	5792 <write>
  if (cc != -1) {
    475a:	57fd                	li	a5,-1
    475c:	14f51163          	bne	a0,a5,489e <partial_write+0x1f4>
  close(fd);
    4760:	8526                	mv	a0,s1
    4762:	038010ef          	jal	579a <close>
  fd = open("testfile", O_RDONLY);
    4766:	4581                	li	a1,0
    4768:	00003517          	auipc	a0,0x3
    476c:	5e050513          	addi	a0,a0,1504 # 7d48 <malloc+0x20dc>
    4770:	042010ef          	jal	57b2 <open>
    4774:	84aa                	mv	s1,a0
  if (fd < 0) {
    4776:	12054e63          	bltz	a0,48b2 <partial_write+0x208>
  cc = read(fd, &b, 1);
    477a:	4605                	li	a2,1
    477c:	fbf40593          	addi	a1,s0,-65
    4780:	00a010ef          	jal	578a <read>
  if (cc != 1) {
    4784:	4785                	li	a5,1
    4786:	14f51063          	bne	a0,a5,48c6 <partial_write+0x21c>
  close(fd);
    478a:	8526                	mv	a0,s1
    478c:	00e010ef          	jal	579a <close>
  if (b != 'X') {
    4790:	fbf44603          	lbu	a2,-65(s0)
    4794:	05800793          	li	a5,88
    4798:	14f61163          	bne	a2,a5,48da <partial_write+0x230>
  fd = open("bigfile", O_CREATE | O_RDWR);
    479c:	20200593          	li	a1,514
    47a0:	00003517          	auipc	a0,0x3
    47a4:	6a850513          	addi	a0,a0,1704 # 7e48 <malloc+0x21dc>
    47a8:	00a010ef          	jal	57b2 <open>
    47ac:	8a2a                	mv	s4,a0
    47ae:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    47b2:	bb840993          	addi	s3,s0,-1096
    47b6:	40000493          	li	s1,1024
    47ba:	8626                	mv	a2,s1
    47bc:	4581                	li	a1,0
    47be:	854e                	mv	a0,s3
    47c0:	579000ef          	jal	5538 <memset>
    cc = write(fd, buf, sizeof(buf));
    47c4:	8626                	mv	a2,s1
    47c6:	85ce                	mv	a1,s3
    47c8:	8552                	mv	a0,s4
    47ca:	7c9000ef          	jal	5792 <write>
    if (cc != sizeof(buf)) {
    47ce:	12951063          	bne	a0,s1,48ee <partial_write+0x244>
  for (int i = 0; i < 64; i++) {
    47d2:	397d                	addiw	s2,s2,-1
    47d4:	fe0913e3          	bnez	s2,47ba <partial_write+0x110>
  close(fd);
    47d8:	8552                	mv	a0,s4
    47da:	7c1000ef          	jal	579a <close>
  unlink("bigfile");
    47de:	00003517          	auipc	a0,0x3
    47e2:	66a50513          	addi	a0,a0,1642 # 7e48 <malloc+0x21dc>
    47e6:	7dd000ef          	jal	57c2 <unlink>
  fd = open("testfile", O_RDONLY);
    47ea:	4581                	li	a1,0
    47ec:	00003517          	auipc	a0,0x3
    47f0:	55c50513          	addi	a0,a0,1372 # 7d48 <malloc+0x20dc>
    47f4:	7bf000ef          	jal	57b2 <open>
    47f8:	84aa                	mv	s1,a0
  if (fd < 0) {
    47fa:	10054463          	bltz	a0,4902 <partial_write+0x258>
  cc = read(fd, &b, 1);
    47fe:	4605                	li	a2,1
    4800:	fbf40593          	addi	a1,s0,-65
    4804:	787000ef          	jal	578a <read>
  if (cc != 1) {
    4808:	4785                	li	a5,1
    480a:	10f51663          	bne	a0,a5,4916 <partial_write+0x26c>
  close(fd);
    480e:	8526                	mv	a0,s1
    4810:	78b000ef          	jal	579a <close>
  if (b != 'X') {
    4814:	fbf44603          	lbu	a2,-65(s0)
    4818:	05800793          	li	a5,88
    481c:	10f61763          	bne	a2,a5,492a <partial_write+0x280>
  unlink("testfile");
    4820:	00003517          	auipc	a0,0x3
    4824:	52850513          	addi	a0,a0,1320 # 7d48 <malloc+0x20dc>
    4828:	79b000ef          	jal	57c2 <unlink>
}
    482c:	44813083          	ld	ra,1096(sp)
    4830:	44013403          	ld	s0,1088(sp)
    4834:	43813483          	ld	s1,1080(sp)
    4838:	43013903          	ld	s2,1072(sp)
    483c:	42813983          	ld	s3,1064(sp)
    4840:	42013a03          	ld	s4,1056(sp)
    4844:	41813a83          	ld	s5,1048(sp)
    4848:	45010113          	addi	sp,sp,1104
    484c:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    484e:	85d6                	mv	a1,s5
    4850:	00003517          	auipc	a0,0x3
    4854:	50850513          	addi	a0,a0,1288 # 7d58 <malloc+0x20ec>
    4858:	35c010ef          	jal	5bb4 <printf>
    exit(1);
    485c:	4505                	li	a0,1
    485e:	715000ef          	jal	5772 <exit>
    printf("%s: could not write A\n", s);
    4862:	85d6                	mv	a1,s5
    4864:	00003517          	auipc	a0,0x3
    4868:	51c50513          	addi	a0,a0,1308 # 7d80 <malloc+0x2114>
    486c:	348010ef          	jal	5bb4 <printf>
    exit(1);
    4870:	4505                	li	a0,1
    4872:	701000ef          	jal	5772 <exit>
    printf("%s: cannot re-open testfile\n", s);
    4876:	85d6                	mv	a1,s5
    4878:	00003517          	auipc	a0,0x3
    487c:	52050513          	addi	a0,a0,1312 # 7d98 <malloc+0x212c>
    4880:	334010ef          	jal	5bb4 <printf>
    exit(1);
    4884:	4505                	li	a0,1
    4886:	6ed000ef          	jal	5772 <exit>
    printf("%s: sbrk did not align\n", s);
    488a:	85d6                	mv	a1,s5
    488c:	00003517          	auipc	a0,0x3
    4890:	52c50513          	addi	a0,a0,1324 # 7db8 <malloc+0x214c>
    4894:	320010ef          	jal	5bb4 <printf>
    exit(1);
    4898:	4505                	li	a0,1
    489a:	6d9000ef          	jal	5772 <exit>
    printf("%s: write succeeded, should have failed\n", s);
    489e:	85d6                	mv	a1,s5
    48a0:	00003517          	auipc	a0,0x3
    48a4:	53050513          	addi	a0,a0,1328 # 7dd0 <malloc+0x2164>
    48a8:	30c010ef          	jal	5bb4 <printf>
    exit(1);
    48ac:	4505                	li	a0,1
    48ae:	6c5000ef          	jal	5772 <exit>
    printf("%s: cannot re-open testfile\n", s);
    48b2:	85d6                	mv	a1,s5
    48b4:	00003517          	auipc	a0,0x3
    48b8:	4e450513          	addi	a0,a0,1252 # 7d98 <malloc+0x212c>
    48bc:	2f8010ef          	jal	5bb4 <printf>
    exit(1);
    48c0:	4505                	li	a0,1
    48c2:	6b1000ef          	jal	5772 <exit>
    printf("%s: cannot read testfile\n", s);
    48c6:	85d6                	mv	a1,s5
    48c8:	00003517          	auipc	a0,0x3
    48cc:	53850513          	addi	a0,a0,1336 # 7e00 <malloc+0x2194>
    48d0:	2e4010ef          	jal	5bb4 <printf>
    exit(1);
    48d4:	4505                	li	a0,1
    48d6:	69d000ef          	jal	5772 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    48da:	85d6                	mv	a1,s5
    48dc:	00003517          	auipc	a0,0x3
    48e0:	54450513          	addi	a0,a0,1348 # 7e20 <malloc+0x21b4>
    48e4:	2d0010ef          	jal	5bb4 <printf>
    exit(1);
    48e8:	4505                	li	a0,1
    48ea:	689000ef          	jal	5772 <exit>
      printf("%s: could not write to bigfile\n", s);
    48ee:	85d6                	mv	a1,s5
    48f0:	00003517          	auipc	a0,0x3
    48f4:	56050513          	addi	a0,a0,1376 # 7e50 <malloc+0x21e4>
    48f8:	2bc010ef          	jal	5bb4 <printf>
      exit(-1);
    48fc:	557d                	li	a0,-1
    48fe:	675000ef          	jal	5772 <exit>
    printf("%s: cannot re-open testfile\n", s);
    4902:	85d6                	mv	a1,s5
    4904:	00003517          	auipc	a0,0x3
    4908:	49450513          	addi	a0,a0,1172 # 7d98 <malloc+0x212c>
    490c:	2a8010ef          	jal	5bb4 <printf>
    exit(1);
    4910:	4505                	li	a0,1
    4912:	661000ef          	jal	5772 <exit>
    printf("%s: cannot read testfile\n", s);
    4916:	85d6                	mv	a1,s5
    4918:	00003517          	auipc	a0,0x3
    491c:	4e850513          	addi	a0,a0,1256 # 7e00 <malloc+0x2194>
    4920:	294010ef          	jal	5bb4 <printf>
    exit(1);
    4924:	4505                	li	a0,1
    4926:	64d000ef          	jal	5772 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    492a:	85d6                	mv	a1,s5
    492c:	00003517          	auipc	a0,0x3
    4930:	4f450513          	addi	a0,a0,1268 # 7e20 <malloc+0x21b4>
    4934:	280010ef          	jal	5bb4 <printf>
    exit(1);
    4938:	4505                	li	a0,1
    493a:	639000ef          	jal	5772 <exit>

000000000000493e <lazy_alloc>:
{
    493e:	1141                	addi	sp,sp,-16
    4940:	e406                	sd	ra,8(sp)
    4942:	e022                	sd	s0,0(sp)
    4944:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4946:	40000537          	lui	a0,0x40000
    494a:	60b000ef          	jal	5754 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    494e:	57fd                	li	a5,-1
    4950:	02f50a63          	beq	a0,a5,4984 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4954:	6605                	lui	a2,0x1
    4956:	962a                	add	a2,a2,a0
    4958:	400017b7          	lui	a5,0x40001
    495c:	00f50733          	add	a4,a0,a5
    4960:	87b2                	mv	a5,a2
    4962:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4966:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4968:	97b6                	add	a5,a5,a3
    496a:	fee79ee3          	bne	a5,a4,4966 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    496e:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4972:	621c                	ld	a5,0(a2)
    4974:	02c79163          	bne	a5,a2,4996 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4978:	9636                	add	a2,a2,a3
    497a:	fee61ce3          	bne	a2,a4,4972 <lazy_alloc+0x34>
  exit(0);
    497e:	4501                	li	a0,0
    4980:	5f3000ef          	jal	5772 <exit>
    printf("sbrklazy() failed\n");
    4984:	00003517          	auipc	a0,0x3
    4988:	4ec50513          	addi	a0,a0,1260 # 7e70 <malloc+0x2204>
    498c:	228010ef          	jal	5bb4 <printf>
    exit(1);
    4990:	4505                	li	a0,1
    4992:	5e1000ef          	jal	5772 <exit>
      printf("failed to read value from memory\n");
    4996:	00003517          	auipc	a0,0x3
    499a:	4f250513          	addi	a0,a0,1266 # 7e88 <malloc+0x221c>
    499e:	216010ef          	jal	5bb4 <printf>
      exit(1);
    49a2:	4505                	li	a0,1
    49a4:	5cf000ef          	jal	5772 <exit>

00000000000049a8 <lazy_unmap>:
{
    49a8:	7139                	addi	sp,sp,-64
    49aa:	fc06                	sd	ra,56(sp)
    49ac:	f822                	sd	s0,48(sp)
    49ae:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    49b0:	40000537          	lui	a0,0x40000
    49b4:	5a1000ef          	jal	5754 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    49b8:	57fd                	li	a5,-1
    49ba:	04f50863          	beq	a0,a5,4a0a <lazy_unmap+0x62>
    49be:	f426                	sd	s1,40(sp)
    49c0:	f04a                	sd	s2,32(sp)
    49c2:	ec4e                	sd	s3,24(sp)
    49c4:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49c6:	6905                	lui	s2,0x1
    49c8:	992a                	add	s2,s2,a0
    49ca:	400017b7          	lui	a5,0x40001
    49ce:	00f504b3          	add	s1,a0,a5
    49d2:	87ca                	mv	a5,s2
    49d4:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    49d8:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49da:	97ba                	add	a5,a5,a4
    49dc:	fe979ee3          	bne	a5,s1,49d8 <lazy_unmap+0x30>
      wait(&status);
    49e0:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49e4:	01000a37          	lui	s4,0x1000
    pid = fork();
    49e8:	583000ef          	jal	576a <fork>
    if (pid < 0) {
    49ec:	02054c63          	bltz	a0,4a24 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    49f0:	c139                	beqz	a0,4a36 <lazy_unmap+0x8e>
      wait(&status);
    49f2:	854e                	mv	a0,s3
    49f4:	587000ef          	jal	577a <wait>
      if (status == 0) {
    49f8:	fcc42783          	lw	a5,-52(s0)
    49fc:	c7b1                	beqz	a5,4a48 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49fe:	9952                	add	s2,s2,s4
    4a00:	fe9914e3          	bne	s2,s1,49e8 <lazy_unmap+0x40>
  exit(0);
    4a04:	4501                	li	a0,0
    4a06:	56d000ef          	jal	5772 <exit>
    4a0a:	f426                	sd	s1,40(sp)
    4a0c:	f04a                	sd	s2,32(sp)
    4a0e:	ec4e                	sd	s3,24(sp)
    4a10:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    4a12:	00003517          	auipc	a0,0x3
    4a16:	45e50513          	addi	a0,a0,1118 # 7e70 <malloc+0x2204>
    4a1a:	19a010ef          	jal	5bb4 <printf>
    exit(1);
    4a1e:	4505                	li	a0,1
    4a20:	553000ef          	jal	5772 <exit>
      printf("error forking\n");
    4a24:	00003517          	auipc	a0,0x3
    4a28:	48c50513          	addi	a0,a0,1164 # 7eb0 <malloc+0x2244>
    4a2c:	188010ef          	jal	5bb4 <printf>
      exit(1);
    4a30:	4505                	li	a0,1
    4a32:	541000ef          	jal	5772 <exit>
      sbrklazy(-1L * REGION_SZ);
    4a36:	c0000537          	lui	a0,0xc0000
    4a3a:	51b000ef          	jal	5754 <sbrklazy>
      *(char **)i = i;
    4a3e:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10a>
      exit(0);
    4a42:	4501                	li	a0,0
    4a44:	52f000ef          	jal	5772 <exit>
        printf("memory not unmapped\n");
    4a48:	00003517          	auipc	a0,0x3
    4a4c:	47850513          	addi	a0,a0,1144 # 7ec0 <malloc+0x2254>
    4a50:	164010ef          	jal	5bb4 <printf>
        exit(1);
    4a54:	4505                	li	a0,1
    4a56:	51d000ef          	jal	5772 <exit>

0000000000004a5a <lazy_copy>:
{
    4a5a:	7119                	addi	sp,sp,-128
    4a5c:	fc86                	sd	ra,120(sp)
    4a5e:	f8a2                	sd	s0,112(sp)
    4a60:	f4a6                	sd	s1,104(sp)
    4a62:	f0ca                	sd	s2,96(sp)
    4a64:	ecce                	sd	s3,88(sp)
    4a66:	e8d2                	sd	s4,80(sp)
    4a68:	e4d6                	sd	s5,72(sp)
    4a6a:	e0da                	sd	s6,64(sp)
    4a6c:	fc5e                	sd	s7,56(sp)
    4a6e:	f862                	sd	s8,48(sp)
    4a70:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4a72:	4501                	li	a0,0
    4a74:	4cb000ef          	jal	573e <sbrk>
    4a78:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4a7a:	6511                	lui	a0,0x4
    4a7c:	4d9000ef          	jal	5754 <sbrklazy>
    open(p + 8192, 0);
    4a80:	4581                	li	a1,0
    4a82:	6509                	lui	a0,0x2
    4a84:	9526                	add	a0,a0,s1
    4a86:	52d000ef          	jal	57b2 <open>
    void *xx = sbrk(0);
    4a8a:	4501                	li	a0,0
    4a8c:	4b3000ef          	jal	573e <sbrk>
    4a90:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4a92:	fff54513          	not	a0,a0
    4a96:	2501                	sext.w	a0,a0
    4a98:	4a7000ef          	jal	573e <sbrk>
    if (ret != xx) {
    4a9c:	00a48c63          	beq	s1,a0,4ab4 <lazy_copy+0x5a>
    4aa0:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4aa2:	00003517          	auipc	a0,0x3
    4aa6:	43650513          	addi	a0,a0,1078 # 7ed8 <malloc+0x226c>
    4aaa:	10a010ef          	jal	5bb4 <printf>
      exit(1);
    4aae:	4505                	li	a0,1
    4ab0:	4c3000ef          	jal	5772 <exit>
  unsigned long bad[] = {
    4ab4:	00004797          	auipc	a5,0x4
    4ab8:	bdc78793          	addi	a5,a5,-1060 # 8690 <malloc+0x2a24>
    4abc:	7fa8                	ld	a0,120(a5)
    4abe:	63cc                	ld	a1,128(a5)
    4ac0:	67d0                	ld	a2,136(a5)
    4ac2:	6bd4                	ld	a3,144(a5)
    4ac4:	6fd8                	ld	a4,152(a5)
    4ac6:	73dc                	ld	a5,160(a5)
    4ac8:	f8a43023          	sd	a0,-128(s0)
    4acc:	f8b43423          	sd	a1,-120(s0)
    4ad0:	f8c43823          	sd	a2,-112(s0)
    4ad4:	f8d43c23          	sd	a3,-104(s0)
    4ad8:	fae43023          	sd	a4,-96(s0)
    4adc:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4ae0:	f8040913          	addi	s2,s0,-128
    4ae4:	fb040c13          	addi	s8,s0,-80
    int fd = open("README", 0);
    4ae8:	00001a97          	auipc	s5,0x1
    4aec:	488a8a93          	addi	s5,s5,1160 # 5f70 <malloc+0x304>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4af0:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4af4:	60200b93          	li	s7,1538
    4af8:	00001b17          	auipc	s6,0x1
    4afc:	388b0b13          	addi	s6,s6,904 # 5e80 <malloc+0x214>
    int fd = open("README", 0);
    4b00:	4581                	li	a1,0
    4b02:	8556                	mv	a0,s5
    4b04:	4af000ef          	jal	57b2 <open>
    4b08:	84aa                	mv	s1,a0
    if (fd < 0) {
    4b0a:	04054363          	bltz	a0,4b50 <lazy_copy+0xf6>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4b0e:	00093983          	ld	s3,0(s2)
    4b12:	8652                	mv	a2,s4
    4b14:	85ce                	mv	a1,s3
    4b16:	475000ef          	jal	578a <read>
    4b1a:	04055463          	bgez	a0,4b62 <lazy_copy+0x108>
    close(fd);
    4b1e:	8526                	mv	a0,s1
    4b20:	47b000ef          	jal	579a <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4b24:	85de                	mv	a1,s7
    4b26:	855a                	mv	a0,s6
    4b28:	48b000ef          	jal	57b2 <open>
    4b2c:	84aa                	mv	s1,a0
    if (fd < 0) {
    4b2e:	04054363          	bltz	a0,4b74 <lazy_copy+0x11a>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4b32:	8652                	mv	a2,s4
    4b34:	85ce                	mv	a1,s3
    4b36:	45d000ef          	jal	5792 <write>
    4b3a:	04055663          	bgez	a0,4b86 <lazy_copy+0x12c>
    close(fd);
    4b3e:	8526                	mv	a0,s1
    4b40:	45b000ef          	jal	579a <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4b44:	0921                	addi	s2,s2,8
    4b46:	fb891de3          	bne	s2,s8,4b00 <lazy_copy+0xa6>
  exit(0);
    4b4a:	4501                	li	a0,0
    4b4c:	427000ef          	jal	5772 <exit>
      printf("cannot open README\n");
    4b50:	00003517          	auipc	a0,0x3
    4b54:	3b850513          	addi	a0,a0,952 # 7f08 <malloc+0x229c>
    4b58:	05c010ef          	jal	5bb4 <printf>
      exit(1);
    4b5c:	4505                	li	a0,1
    4b5e:	415000ef          	jal	5772 <exit>
      printf("read succeeded\n");
    4b62:	00003517          	auipc	a0,0x3
    4b66:	3be50513          	addi	a0,a0,958 # 7f20 <malloc+0x22b4>
    4b6a:	04a010ef          	jal	5bb4 <printf>
      exit(1);
    4b6e:	4505                	li	a0,1
    4b70:	403000ef          	jal	5772 <exit>
      printf("cannot open junk\n");
    4b74:	00003517          	auipc	a0,0x3
    4b78:	3bc50513          	addi	a0,a0,956 # 7f30 <malloc+0x22c4>
    4b7c:	038010ef          	jal	5bb4 <printf>
      exit(1);
    4b80:	4505                	li	a0,1
    4b82:	3f1000ef          	jal	5772 <exit>
      printf("write succeeded\n");
    4b86:	00003517          	auipc	a0,0x3
    4b8a:	3c250513          	addi	a0,a0,962 # 7f48 <malloc+0x22dc>
    4b8e:	026010ef          	jal	5bb4 <printf>
      exit(1);
    4b92:	4505                	li	a0,1
    4b94:	3df000ef          	jal	5772 <exit>

0000000000004b98 <lazy_sbrk>:
{
    4b98:	7179                	addi	sp,sp,-48
    4b9a:	f406                	sd	ra,40(sp)
    4b9c:	f022                	sd	s0,32(sp)
    4b9e:	ec26                	sd	s1,24(sp)
    4ba0:	e84a                	sd	s2,16(sp)
    4ba2:	e44e                	sd	s3,8(sp)
    4ba4:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4ba6:	4501                	li	a0,0
    4ba8:	397000ef          	jal	573e <sbrk>
    4bac:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bae:	0ff00793          	li	a5,255
    4bb2:	07fa                	slli	a5,a5,0x1e
    4bb4:	00f57e63          	bgeu	a0,a5,4bd0 <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4bb8:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bbc:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4bbe:	854e                	mv	a0,s3
    4bc0:	395000ef          	jal	5754 <sbrklazy>
    p = sbrklazy(0);
    4bc4:	4501                	li	a0,0
    4bc6:	38f000ef          	jal	5754 <sbrklazy>
    4bca:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bcc:	ff2569e3          	bltu	a0,s2,4bbe <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4bd0:	7975                	lui	s2,0xffffd
    4bd2:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4bd6:	854a                	mv	a0,s2
    4bd8:	37d000ef          	jal	5754 <sbrklazy>
    4bdc:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4bde:	00950d63          	beq	a0,s1,4bf8 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4be2:	86a6                	mv	a3,s1
    4be4:	85ca                	mv	a1,s2
    4be6:	00003517          	auipc	a0,0x3
    4bea:	37a50513          	addi	a0,a0,890 # 7f60 <malloc+0x22f4>
    4bee:	7c7000ef          	jal	5bb4 <printf>
    exit(1);
    4bf2:	4505                	li	a0,1
    4bf4:	37f000ef          	jal	5772 <exit>
  p = sbrk(PGSIZE);
    4bf8:	6505                	lui	a0,0x1
    4bfa:	345000ef          	jal	573e <sbrk>
    4bfe:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4c00:	040007b7          	lui	a5,0x4000
    4c04:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0305>
    4c06:	07b2                	slli	a5,a5,0xc
    4c08:	00f50c63          	beq	a0,a5,4c20 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4c0c:	6585                	lui	a1,0x1
    4c0e:	00003517          	auipc	a0,0x3
    4c12:	38250513          	addi	a0,a0,898 # 7f90 <malloc+0x2324>
    4c16:	79f000ef          	jal	5bb4 <printf>
    exit(1);
    4c1a:	4505                	li	a0,1
    4c1c:	357000ef          	jal	5772 <exit>
  p[0] = 1;
    4c20:	040007b7          	lui	a5,0x4000
    4c24:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0305>
    4c26:	07b2                	slli	a5,a5,0xc
    4c28:	4705                	li	a4,1
    4c2a:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4c2e:	0017c783          	lbu	a5,1(a5)
    4c32:	cb91                	beqz	a5,4c46 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    4c34:	00003517          	auipc	a0,0x3
    4c38:	39450513          	addi	a0,a0,916 # 7fc8 <malloc+0x235c>
    4c3c:	779000ef          	jal	5bb4 <printf>
    exit(1);
    4c40:	4505                	li	a0,1
    4c42:	331000ef          	jal	5772 <exit>
  p = sbrk(1);
    4c46:	4505                	li	a0,1
    4c48:	2f7000ef          	jal	573e <sbrk>
    4c4c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c4e:	57fd                	li	a5,-1
    4c50:	00f50b63          	beq	a0,a5,4c66 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4c54:	00003517          	auipc	a0,0x3
    4c58:	39c50513          	addi	a0,a0,924 # 7ff0 <malloc+0x2384>
    4c5c:	759000ef          	jal	5bb4 <printf>
    exit(1);
    4c60:	4505                	li	a0,1
    4c62:	311000ef          	jal	5772 <exit>
  p = sbrklazy(1);
    4c66:	4505                	li	a0,1
    4c68:	2ed000ef          	jal	5754 <sbrklazy>
    4c6c:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c6e:	57fd                	li	a5,-1
    4c70:	00f50b63          	beq	a0,a5,4c86 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4c74:	00003517          	auipc	a0,0x3
    4c78:	3a450513          	addi	a0,a0,932 # 8018 <malloc+0x23ac>
    4c7c:	739000ef          	jal	5bb4 <printf>
    exit(1);
    4c80:	4505                	li	a0,1
    4c82:	2f1000ef          	jal	5772 <exit>
  exit(0);
    4c86:	4501                	li	a0,0
    4c88:	2eb000ef          	jal	5772 <exit>

0000000000004c8c <lazy_copyinstr>:
{
    4c8c:	715d                	addi	sp,sp,-80
    4c8e:	e486                	sd	ra,72(sp)
    4c90:	e0a2                	sd	s0,64(sp)
    4c92:	fc26                	sd	s1,56(sp)
    4c94:	f84a                	sd	s2,48(sp)
    4c96:	f44e                	sd	s3,40(sp)
    4c98:	0880                	addi	s0,sp,80
    4c9a:	89aa                	mv	s3,a0
  char *p = sbrk(0);
    4c9c:	4501                	li	a0,0
    4c9e:	2a1000ef          	jal	573e <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4ca2:	6705                	lui	a4,0x1
    4ca4:	fff70913          	addi	s2,a4,-1 # fff <bigdir+0x109>
    4ca8:	01257533          	and	a0,a0,s2
    4cac:	40a7053b          	subw	a0,a4,a0
    4cb0:	28f000ef          	jal	573e <sbrk>
  p = sbrk(0);
    4cb4:	4501                	li	a0,0
    4cb6:	289000ef          	jal	573e <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4cba:	01257933          	and	s2,a0,s2
    4cbe:	04091a63          	bnez	s2,4d12 <lazy_copyinstr+0x86>
    4cc2:	84aa                	mv	s1,a0
  sbrklazy(2 * PGSIZE);
    4cc4:	6509                	lui	a0,0x2
    4cc6:	28f000ef          	jal	5754 <sbrklazy>
  p[4095] = '/';
    4cca:	6505                	lui	a0,0x1
    4ccc:	00a487b3          	add	a5,s1,a0
    4cd0:	02f00713          	li	a4,47
    4cd4:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4cd8:	157d                	addi	a0,a0,-1 # fff <bigdir+0x109>
    4cda:	4581                	li	a1,0
    4cdc:	9526                	add	a0,a0,s1
    4cde:	2d5000ef          	jal	57b2 <open>
    4ce2:	84aa                	mv	s1,a0
  if (fd < 0) {
    4ce4:	04054163          	bltz	a0,4d26 <lazy_copyinstr+0x9a>
  int r = fstat(fd, &st);
    4ce8:	fb840593          	addi	a1,s0,-72
    4cec:	2df000ef          	jal	57ca <fstat>
  if (r < 0) {
    4cf0:	04054463          	bltz	a0,4d38 <lazy_copyinstr+0xac>
  if (st.type != T_DIR) {
    4cf4:	fc041703          	lh	a4,-64(s0)
    4cf8:	4785                	li	a5,1
    4cfa:	04f71863          	bne	a4,a5,4d4a <lazy_copyinstr+0xbe>
  close(fd);
    4cfe:	8526                	mv	a0,s1
    4d00:	29b000ef          	jal	579a <close>
}
    4d04:	60a6                	ld	ra,72(sp)
    4d06:	6406                	ld	s0,64(sp)
    4d08:	74e2                	ld	s1,56(sp)
    4d0a:	7942                	ld	s2,48(sp)
    4d0c:	79a2                	ld	s3,40(sp)
    4d0e:	6161                	addi	sp,sp,80
    4d10:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4d12:	85ce                	mv	a1,s3
    4d14:	00003517          	auipc	a0,0x3
    4d18:	0a450513          	addi	a0,a0,164 # 7db8 <malloc+0x214c>
    4d1c:	699000ef          	jal	5bb4 <printf>
    exit(1);
    4d20:	4505                	li	a0,1
    4d22:	251000ef          	jal	5772 <exit>
    printf("could not open /");
    4d26:	00003517          	auipc	a0,0x3
    4d2a:	32250513          	addi	a0,a0,802 # 8048 <malloc+0x23dc>
    4d2e:	687000ef          	jal	5bb4 <printf>
    exit(1);
    4d32:	4505                	li	a0,1
    4d34:	23f000ef          	jal	5772 <exit>
    printf("could not stat /");
    4d38:	00003517          	auipc	a0,0x3
    4d3c:	32850513          	addi	a0,a0,808 # 8060 <malloc+0x23f4>
    4d40:	675000ef          	jal	5bb4 <printf>
    exit(1);
    4d44:	4505                	li	a0,1
    4d46:	22d000ef          	jal	5772 <exit>
    printf("/ is not T_DIR");
    4d4a:	00003517          	auipc	a0,0x3
    4d4e:	32e50513          	addi	a0,a0,814 # 8078 <malloc+0x240c>
    4d52:	663000ef          	jal	5bb4 <printf>
    exit(1);
    4d56:	4505                	li	a0,1
    4d58:	21b000ef          	jal	5772 <exit>

0000000000004d5c <fsfull>:
{
    4d5c:	7131                	addi	sp,sp,-192
    4d5e:	fd06                	sd	ra,184(sp)
    4d60:	f922                	sd	s0,176(sp)
    4d62:	f526                	sd	s1,168(sp)
    4d64:	f14a                	sd	s2,160(sp)
    4d66:	ed4e                	sd	s3,152(sp)
    4d68:	e952                	sd	s4,144(sp)
    4d6a:	e556                	sd	s5,136(sp)
    4d6c:	e15a                	sd	s6,128(sp)
    4d6e:	fcde                	sd	s7,120(sp)
    4d70:	f8e2                	sd	s8,112(sp)
    4d72:	f4e6                	sd	s9,104(sp)
    4d74:	f0ea                	sd	s10,96(sp)
    4d76:	ecee                	sd	s11,88(sp)
    4d78:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4d7a:	00003517          	auipc	a0,0x3
    4d7e:	30e50513          	addi	a0,a0,782 # 8088 <malloc+0x241c>
    4d82:	633000ef          	jal	5bb4 <printf>
  int fsblocks = 0;
    4d86:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4d88:	4481                	li	s1,0
    name[0] = 'f';
    4d8a:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4d8e:	106257b7          	lui	a5,0x10625
    4d92:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106150db>
    4d96:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d9a:	51eb8b37          	lui	s6,0x51eb8
    4d9e:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea8827>
    name[3] = '0' + (nfiles % 100) / 10;
    4da2:	66666ab7          	lui	s5,0x66666
    4da6:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665696f>
    printf("writing %s\n", name);
    4daa:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4dae:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4db2:	f4843783          	ld	a5,-184(s0)
    4db6:	02f487b3          	mul	a5,s1,a5
    4dba:	9799                	srai	a5,a5,0x26
    4dbc:	41f4d69b          	sraiw	a3,s1,0x1f
    4dc0:	9f95                	subw	a5,a5,a3
    4dc2:	0307871b          	addiw	a4,a5,48
    4dc6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4dca:	3e800713          	li	a4,1000
    4dce:	02f707bb          	mulw	a5,a4,a5
    4dd2:	40f487bb          	subw	a5,s1,a5
    4dd6:	03678733          	mul	a4,a5,s6
    4dda:	9715                	srai	a4,a4,0x25
    4ddc:	41f7d79b          	sraiw	a5,a5,0x1f
    4de0:	40f707bb          	subw	a5,a4,a5
    4de4:	0307879b          	addiw	a5,a5,48
    4de8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4dec:	036487b3          	mul	a5,s1,s6
    4df0:	9795                	srai	a5,a5,0x25
    4df2:	9f95                	subw	a5,a5,a3
    4df4:	06400713          	li	a4,100
    4df8:	02f707bb          	mulw	a5,a4,a5
    4dfc:	40f487bb          	subw	a5,s1,a5
    4e00:	03578733          	mul	a4,a5,s5
    4e04:	9709                	srai	a4,a4,0x22
    4e06:	41f7d79b          	sraiw	a5,a5,0x1f
    4e0a:	40f707bb          	subw	a5,a4,a5
    4e0e:	0307879b          	addiw	a5,a5,48
    4e12:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e16:	03548733          	mul	a4,s1,s5
    4e1a:	9709                	srai	a4,a4,0x22
    4e1c:	9f15                	subw	a4,a4,a3
    4e1e:	0027179b          	slliw	a5,a4,0x2
    4e22:	9fb9                	addw	a5,a5,a4
    4e24:	0017979b          	slliw	a5,a5,0x1
    4e28:	40f487bb          	subw	a5,s1,a5
    4e2c:	0307879b          	addiw	a5,a5,48
    4e30:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e34:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e38:	85ea                	mv	a1,s10
    4e3a:	00003517          	auipc	a0,0x3
    4e3e:	25e50513          	addi	a0,a0,606 # 8098 <malloc+0x242c>
    4e42:	573000ef          	jal	5bb4 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4e46:	20200593          	li	a1,514
    4e4a:	856a                	mv	a0,s10
    4e4c:	167000ef          	jal	57b2 <open>
    4e50:	892a                	mv	s2,a0
    if (fd < 0) {
    4e52:	0e055963          	bgez	a0,4f44 <fsfull+0x1e8>
      printf("open %s failed\n", name);
    4e56:	f5040593          	addi	a1,s0,-176
    4e5a:	00003517          	auipc	a0,0x3
    4e5e:	24e50513          	addi	a0,a0,590 # 80a8 <malloc+0x243c>
    4e62:	553000ef          	jal	5bb4 <printf>
    name[0] = 'f';
    4e66:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    4e6a:	10625ab7          	lui	s5,0x10625
    4e6e:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106150db>
    name[2] = '0' + (nfiles % 1000) / 100;
    4e72:	3e800c13          	li	s8,1000
    4e76:	51eb8a37          	lui	s4,0x51eb8
    4e7a:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea8827>
    name[3] = '0' + (nfiles % 100) / 10;
    4e7e:	06400b93          	li	s7,100
    4e82:	66666937          	lui	s2,0x66666
    4e86:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665696f>
    unlink(name);
    4e8a:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    4e8e:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e92:	035487b3          	mul	a5,s1,s5
    4e96:	9799                	srai	a5,a5,0x26
    4e98:	41f4d69b          	sraiw	a3,s1,0x1f
    4e9c:	9f95                	subw	a5,a5,a3
    4e9e:	0307871b          	addiw	a4,a5,48
    4ea2:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ea6:	02fc07bb          	mulw	a5,s8,a5
    4eaa:	40f487bb          	subw	a5,s1,a5
    4eae:	03478733          	mul	a4,a5,s4
    4eb2:	9715                	srai	a4,a4,0x25
    4eb4:	41f7d79b          	sraiw	a5,a5,0x1f
    4eb8:	40f707bb          	subw	a5,a4,a5
    4ebc:	0307879b          	addiw	a5,a5,48
    4ec0:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ec4:	034487b3          	mul	a5,s1,s4
    4ec8:	9795                	srai	a5,a5,0x25
    4eca:	9f95                	subw	a5,a5,a3
    4ecc:	02fb87bb          	mulw	a5,s7,a5
    4ed0:	40f487bb          	subw	a5,s1,a5
    4ed4:	03278733          	mul	a4,a5,s2
    4ed8:	9709                	srai	a4,a4,0x22
    4eda:	41f7d79b          	sraiw	a5,a5,0x1f
    4ede:	40f707bb          	subw	a5,a4,a5
    4ee2:	0307879b          	addiw	a5,a5,48
    4ee6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4eea:	03248733          	mul	a4,s1,s2
    4eee:	9709                	srai	a4,a4,0x22
    4ef0:	9f15                	subw	a4,a4,a3
    4ef2:	0027179b          	slliw	a5,a4,0x2
    4ef6:	9fb9                	addw	a5,a5,a4
    4ef8:	0017979b          	slliw	a5,a5,0x1
    4efc:	40f487bb          	subw	a5,s1,a5
    4f00:	0307879b          	addiw	a5,a5,48
    4f04:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f08:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f0c:	855a                	mv	a0,s6
    4f0e:	0b5000ef          	jal	57c2 <unlink>
    nfiles--;
    4f12:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4f14:	f604dde3          	bgez	s1,4e8e <fsfull+0x132>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    4f18:	85ce                	mv	a1,s3
    4f1a:	00003517          	auipc	a0,0x3
    4f1e:	1ae50513          	addi	a0,a0,430 # 80c8 <malloc+0x245c>
    4f22:	493000ef          	jal	5bb4 <printf>
}
    4f26:	70ea                	ld	ra,184(sp)
    4f28:	744a                	ld	s0,176(sp)
    4f2a:	74aa                	ld	s1,168(sp)
    4f2c:	790a                	ld	s2,160(sp)
    4f2e:	69ea                	ld	s3,152(sp)
    4f30:	6a4a                	ld	s4,144(sp)
    4f32:	6aaa                	ld	s5,136(sp)
    4f34:	6b0a                	ld	s6,128(sp)
    4f36:	7be6                	ld	s7,120(sp)
    4f38:	7c46                	ld	s8,112(sp)
    4f3a:	7ca6                	ld	s9,104(sp)
    4f3c:	7d06                	ld	s10,96(sp)
    4f3e:	6de6                	ld	s11,88(sp)
    4f40:	6129                	addi	sp,sp,192
    4f42:	8082                	ret
    int total = 0;
    4f44:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    4f46:	40000c93          	li	s9,1024
    4f4a:	00008c17          	auipc	s8,0x8
    4f4e:	daec0c13          	addi	s8,s8,-594 # ccf8 <buf>
      if (cc < BSIZE)
    4f52:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    4f56:	8666                	mv	a2,s9
    4f58:	85e2                	mv	a1,s8
    4f5a:	854a                	mv	a0,s2
    4f5c:	037000ef          	jal	5792 <write>
      if (cc < BSIZE)
    4f60:	00abd663          	bge	s7,a0,4f6c <fsfull+0x210>
      total += cc;
    4f64:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    4f68:	2985                	addiw	s3,s3,1 # 40000001 <base+0x3fff0309>
    while (1) {
    4f6a:	b7f5                	j	4f56 <fsfull+0x1fa>
    printf("wrote %d bytes\n", total);
    4f6c:	85d2                	mv	a1,s4
    4f6e:	00003517          	auipc	a0,0x3
    4f72:	14a50513          	addi	a0,a0,330 # 80b8 <malloc+0x244c>
    4f76:	43f000ef          	jal	5bb4 <printf>
    close(fd);
    4f7a:	854a                	mv	a0,s2
    4f7c:	01f000ef          	jal	579a <close>
    if (total == 0)
    4f80:	ee0a03e3          	beqz	s4,4e66 <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    4f84:	2485                	addiw	s1,s1,1
    4f86:	b525                	j	4dae <fsfull+0x52>

0000000000004f88 <linkoverflow>:

void
linkoverflow(char *s)
{
    4f88:	7175                	addi	sp,sp,-144
    4f8a:	e506                	sd	ra,136(sp)
    4f8c:	e122                	sd	s0,128(sp)
    4f8e:	fca6                	sd	s1,120(sp)
    4f90:	f8ca                	sd	s2,112(sp)
    4f92:	f4ce                	sd	s3,104(sp)
    4f94:	f0d2                	sd	s4,96(sp)
    4f96:	ecd6                	sd	s5,88(sp)
    4f98:	e8da                	sd	s6,80(sp)
    4f9a:	e4de                	sd	s7,72(sp)
    4f9c:	e0e2                	sd	s8,64(sp)
    4f9e:	fc66                	sd	s9,56(sp)
    4fa0:	f86a                	sd	s10,48(sp)
    4fa2:	0900                	addi	s0,sp,144
    4fa4:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    4fa6:	00003517          	auipc	a0,0x3
    4faa:	14a50513          	addi	a0,a0,330 # 80f0 <malloc+0x2484>
    4fae:	015000ef          	jal	57c2 <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    4fb2:	20200593          	li	a1,514
    4fb6:	00003517          	auipc	a0,0x3
    4fba:	13a50513          	addi	a0,a0,314 # 80f0 <malloc+0x2484>
    4fbe:	7f4000ef          	jal	57b2 <open>
  if (fd < 0) {
    4fc2:	02054863          	bltz	a0,4ff2 <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    4fc6:	7d4000ef          	jal	579a <close>

  for (i = 0; i < TARGET; i++) {
    4fca:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    4fcc:	02f00993          	li	s3,47
    pn[1] = 'd';
    4fd0:	06400b93          	li	s7,100
    pn[2] = '_';
    4fd4:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    4fd8:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    4fdc:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    4fe0:	00003c17          	auipc	s8,0x3
    4fe4:	110c0c13          	addi	s8,s8,272 # 80f0 <malloc+0x2484>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    4fe8:	51eb8ab7          	lui	s5,0x51eb8
    4fec:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea8827>
    4ff0:	a869                	j	508a <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    4ff2:	85ea                	mv	a1,s10
    4ff4:	00003517          	auipc	a0,0x3
    4ff8:	10450513          	addi	a0,a0,260 # 80f8 <malloc+0x248c>
    4ffc:	3b9000ef          	jal	5bb4 <printf>
    exit(1);
    5000:	4505                	li	a0,1
    5002:	770000ef          	jal	5772 <exit>
    pn[5] = '/';
    5006:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    500a:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    500e:	41f9579b          	sraiw	a5,s2,0x1f
    5012:	0127d79b          	srliw	a5,a5,0x12
    5016:	012787bb          	addw	a5,a5,s2
    501a:	40e7d79b          	sraiw	a5,a5,0xe
    501e:	0617879b          	addiw	a5,a5,97
    5022:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    5026:	41f4d71b          	sraiw	a4,s1,0x1f
    502a:	01c7571b          	srliw	a4,a4,0x1c
    502e:	9cb9                	addw	s1,s1,a4
    5030:	4044d79b          	sraiw	a5,s1,0x4
    5034:	41f7d69b          	sraiw	a3,a5,0x1f
    5038:	01c6d69b          	srliw	a3,a3,0x1c
    503c:	9fb5                	addw	a5,a5,a3
    503e:	8bbd                	andi	a5,a5,15
    5040:	9f95                	subw	a5,a5,a3
    5042:	0617879b          	addiw	a5,a5,97
    5046:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    504a:	88bd                	andi	s1,s1,15
    504c:	9c99                	subw	s1,s1,a4
    504e:	0614849b          	addiw	s1,s1,97
    5052:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    5056:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    505a:	85d2                	mv	a1,s4
    505c:	8562                	mv	a0,s8
    505e:	774000ef          	jal	57d2 <link>
    5062:	08054a63          	bltz	a0,50f6 <linkoverflow+0x16e>
    if (i % 100 == 0) {
    5066:	03590733          	mul	a4,s2,s5
    506a:	9715                	srai	a4,a4,0x25
    506c:	41f9579b          	sraiw	a5,s2,0x1f
    5070:	9f1d                	subw	a4,a4,a5
    5072:	06400793          	li	a5,100
    5076:	02e787bb          	mulw	a5,a5,a4
    507a:	40f907bb          	subw	a5,s2,a5
    507e:	10078363          	beqz	a5,5184 <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    5082:	2905                	addiw	s2,s2,1
    5084:	67a1                	lui	a5,0x8
    5086:	08f90863          	beq	s2,a5,5116 <linkoverflow+0x18e>
    int d = i % DIRS;
    508a:	41f9571b          	sraiw	a4,s2,0x1f
    508e:	01a7571b          	srliw	a4,a4,0x1a
    5092:	012704bb          	addw	s1,a4,s2
    5096:	03f4f793          	andi	a5,s1,63
    509a:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    509c:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    50a0:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    50a4:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    50a8:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    50ac:	41f7d71b          	sraiw	a4,a5,0x1f
    50b0:	01c7571b          	srliw	a4,a4,0x1c
    50b4:	9fb9                	addw	a5,a5,a4
    50b6:	4047d69b          	sraiw	a3,a5,0x4
    50ba:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x30369>
    50be:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    50c2:	8bbd                	andi	a5,a5,15
    50c4:	9f99                	subw	a5,a5,a4
    50c6:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x23f5>
    50ca:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    50ce:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    50d2:	f895                	bnez	s1,5006 <linkoverflow+0x7e>
    50d4:	8552                	mv	a0,s4
    50d6:	704000ef          	jal	57da <mkdir>
    50da:	f20556e3          	bgez	a0,5006 <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    50de:	f7840613          	addi	a2,s0,-136
    50e2:	85ea                	mv	a1,s10
    50e4:	00003517          	auipc	a0,0x3
    50e8:	02c50513          	addi	a0,a0,44 # 8110 <malloc+0x24a4>
    50ec:	2c9000ef          	jal	5bb4 <printf>
      exit(1);
    50f0:	4505                	li	a0,1
    50f2:	680000ef          	jal	5772 <exit>
      if (stat("/lof", &st) < 0) {
    50f6:	f8840593          	addi	a1,s0,-120
    50fa:	00003517          	auipc	a0,0x3
    50fe:	ff650513          	addi	a0,a0,-10 # 80f0 <malloc+0x2484>
    5102:	508000ef          	jal	560a <stat>
    5106:	04054a63          	bltz	a0,515a <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    510a:	f9241683          	lh	a3,-110(s0)
    510e:	67a1                	lui	a5,0x8
    5110:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x2393>
    5112:	04f69e63          	bne	a3,a5,516e <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    5116:	f8840593          	addi	a1,s0,-120
    511a:	00003517          	auipc	a0,0x3
    511e:	fd650513          	addi	a0,a0,-42 # 80f0 <malloc+0x2484>
    5122:	4e8000ef          	jal	560a <stat>
    5126:	06054963          	bltz	a0,5198 <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    512a:	00003517          	auipc	a0,0x3
    512e:	fc650513          	addi	a0,a0,-58 # 80f0 <malloc+0x2484>
    5132:	690000ef          	jal	57c2 <unlink>

  if (st.nlink < 0) {
    5136:	f9241603          	lh	a2,-110(s0)
    513a:	06064963          	bltz	a2,51ac <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    513e:	60aa                	ld	ra,136(sp)
    5140:	640a                	ld	s0,128(sp)
    5142:	74e6                	ld	s1,120(sp)
    5144:	7946                	ld	s2,112(sp)
    5146:	79a6                	ld	s3,104(sp)
    5148:	7a06                	ld	s4,96(sp)
    514a:	6ae6                	ld	s5,88(sp)
    514c:	6b46                	ld	s6,80(sp)
    514e:	6ba6                	ld	s7,72(sp)
    5150:	6c06                	ld	s8,64(sp)
    5152:	7ce2                	ld	s9,56(sp)
    5154:	7d42                	ld	s10,48(sp)
    5156:	6149                	addi	sp,sp,144
    5158:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    515a:	85ea                	mv	a1,s10
    515c:	00003517          	auipc	a0,0x3
    5160:	fcc50513          	addi	a0,a0,-52 # 8128 <malloc+0x24bc>
    5164:	251000ef          	jal	5bb4 <printf>
        exit(1);
    5168:	4505                	li	a0,1
    516a:	608000ef          	jal	5772 <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    516e:	864a                	mv	a2,s2
    5170:	85ea                	mv	a1,s10
    5172:	00003517          	auipc	a0,0x3
    5176:	fce50513          	addi	a0,a0,-50 # 8140 <malloc+0x24d4>
    517a:	23b000ef          	jal	5bb4 <printf>
      exit(1);
    517e:	4505                	li	a0,1
    5180:	5f2000ef          	jal	5772 <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    5184:	86d2                	mv	a3,s4
    5186:	864a                	mv	a2,s2
    5188:	85ea                	mv	a1,s10
    518a:	00003517          	auipc	a0,0x3
    518e:	fe650513          	addi	a0,a0,-26 # 8170 <malloc+0x2504>
    5192:	223000ef          	jal	5bb4 <printf>
    5196:	b5f5                	j	5082 <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    5198:	85ea                	mv	a1,s10
    519a:	00003517          	auipc	a0,0x3
    519e:	f8e50513          	addi	a0,a0,-114 # 8128 <malloc+0x24bc>
    51a2:	213000ef          	jal	5bb4 <printf>
    exit(1);
    51a6:	4505                	li	a0,1
    51a8:	5ca000ef          	jal	5772 <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    51ac:	85ea                	mv	a1,s10
    51ae:	00003517          	auipc	a0,0x3
    51b2:	fda50513          	addi	a0,a0,-38 # 8188 <malloc+0x251c>
    51b6:	1ff000ef          	jal	5bb4 <printf>
    exit(1);
    51ba:	4505                	li	a0,1
    51bc:	5b6000ef          	jal	5772 <exit>

00000000000051c0 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    51c0:	7179                	addi	sp,sp,-48
    51c2:	f406                	sd	ra,40(sp)
    51c4:	f022                	sd	s0,32(sp)
    51c6:	ec26                	sd	s1,24(sp)
    51c8:	e84a                	sd	s2,16(sp)
    51ca:	1800                	addi	s0,sp,48
    51cc:	84aa                	mv	s1,a0
    51ce:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    51d0:	00003517          	auipc	a0,0x3
    51d4:	fd850513          	addi	a0,a0,-40 # 81a8 <malloc+0x253c>
    51d8:	1dd000ef          	jal	5bb4 <printf>
  if ((pid = fork()) < 0) {
    51dc:	58e000ef          	jal	576a <fork>
    51e0:	02054a63          	bltz	a0,5214 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    51e4:	c129                	beqz	a0,5226 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    51e6:	fdc40513          	addi	a0,s0,-36
    51ea:	590000ef          	jal	577a <wait>
    if (xstatus != 0)
    51ee:	fdc42783          	lw	a5,-36(s0)
    51f2:	cf9d                	beqz	a5,5230 <run+0x70>
      printf("FAILED\n");
    51f4:	00003517          	auipc	a0,0x3
    51f8:	fdc50513          	addi	a0,a0,-36 # 81d0 <malloc+0x2564>
    51fc:	1b9000ef          	jal	5bb4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    5200:	fdc42503          	lw	a0,-36(s0)
  }
}
    5204:	00153513          	seqz	a0,a0
    5208:	70a2                	ld	ra,40(sp)
    520a:	7402                	ld	s0,32(sp)
    520c:	64e2                	ld	s1,24(sp)
    520e:	6942                	ld	s2,16(sp)
    5210:	6145                	addi	sp,sp,48
    5212:	8082                	ret
    printf("runtest: fork error\n");
    5214:	00003517          	auipc	a0,0x3
    5218:	fa450513          	addi	a0,a0,-92 # 81b8 <malloc+0x254c>
    521c:	199000ef          	jal	5bb4 <printf>
    exit(1);
    5220:	4505                	li	a0,1
    5222:	550000ef          	jal	5772 <exit>
    f(s);
    5226:	854a                	mv	a0,s2
    5228:	9482                	jalr	s1
    exit(0);
    522a:	4501                	li	a0,0
    522c:	546000ef          	jal	5772 <exit>
      printf("OK\n");
    5230:	00003517          	auipc	a0,0x3
    5234:	fa850513          	addi	a0,a0,-88 # 81d8 <malloc+0x256c>
    5238:	17d000ef          	jal	5bb4 <printf>
    523c:	b7d1                	j	5200 <run+0x40>

000000000000523e <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    523e:	7139                	addi	sp,sp,-64
    5240:	fc06                	sd	ra,56(sp)
    5242:	f822                	sd	s0,48(sp)
    5244:	f426                	sd	s1,40(sp)
    5246:	ec4e                	sd	s3,24(sp)
    5248:	0080                	addi	s0,sp,64
    524a:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    524c:	6508                	ld	a0,8(a0)
    524e:	cd39                	beqz	a0,52ac <runtests+0x6e>
    5250:	f04a                	sd	s2,32(sp)
    5252:	e852                	sd	s4,16(sp)
    5254:	e456                	sd	s5,8(sp)
    5256:	892e                	mv	s2,a1
    5258:	8a32                	mv	s4,a2
  int ntests = 0;
    525a:	4981                	li	s3,0
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    525c:	4a89                	li	s5,2
    525e:	a021                	j	5266 <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    5260:	04c1                	addi	s1,s1,16
    5262:	6488                	ld	a0,8(s1)
    5264:	c915                	beqz	a0,5298 <runtests+0x5a>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5266:	00090663          	beqz	s2,5272 <runtests+0x34>
    526a:	85ca                	mv	a1,s2
    526c:	26e000ef          	jal	54da <strcmp>
    5270:	f965                	bnez	a0,5260 <runtests+0x22>
      ntests++;
    5272:	2985                	addiw	s3,s3,1
      if (!run(t->f, t->s)) {
    5274:	648c                	ld	a1,8(s1)
    5276:	6088                	ld	a0,0(s1)
    5278:	f49ff0ef          	jal	51c0 <run>
    527c:	f175                	bnez	a0,5260 <runtests+0x22>
        if (continuous != 2) {
    527e:	ff5a01e3          	beq	s4,s5,5260 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    5282:	00003517          	auipc	a0,0x3
    5286:	f5e50513          	addi	a0,a0,-162 # 81e0 <malloc+0x2574>
    528a:	12b000ef          	jal	5bb4 <printf>
          return -1;
    528e:	59fd                	li	s3,-1
    5290:	7902                	ld	s2,32(sp)
    5292:	6a42                	ld	s4,16(sp)
    5294:	6aa2                	ld	s5,8(sp)
    5296:	a021                	j	529e <runtests+0x60>
    5298:	7902                	ld	s2,32(sp)
    529a:	6a42                	ld	s4,16(sp)
    529c:	6aa2                	ld	s5,8(sp)
        }
      }
    }
  }
  return ntests;
}
    529e:	854e                	mv	a0,s3
    52a0:	70e2                	ld	ra,56(sp)
    52a2:	7442                	ld	s0,48(sp)
    52a4:	74a2                	ld	s1,40(sp)
    52a6:	69e2                	ld	s3,24(sp)
    52a8:	6121                	addi	sp,sp,64
    52aa:	8082                	ret
  return ntests;
    52ac:	4981                	li	s3,0
    52ae:	bfc5                	j	529e <runtests+0x60>

00000000000052b0 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    52b0:	7179                	addi	sp,sp,-48
    52b2:	f406                	sd	ra,40(sp)
    52b4:	f022                	sd	s0,32(sp)
    52b6:	ec26                	sd	s1,24(sp)
    52b8:	e84a                	sd	s2,16(sp)
    52ba:	e44e                	sd	s3,8(sp)
    52bc:	e052                	sd	s4,0(sp)
    52be:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    52c0:	4501                	li	a0,0
    52c2:	47c000ef          	jal	573e <sbrk>
    52c6:	8a2a                	mv	s4,a0
  int n = 0;
    52c8:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    52ca:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    52cc:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    52ce:	854e                	mv	a0,s3
    52d0:	46e000ef          	jal	573e <sbrk>
    if (a == SBRK_ERROR) {
    52d4:	01250463          	beq	a0,s2,52dc <countfree+0x2c>
      break;
    }
    n += 1;
    52d8:	2485                	addiw	s1,s1,1
  while (1) {
    52da:	bfd5                	j	52ce <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    52dc:	4501                	li	a0,0
    52de:	460000ef          	jal	573e <sbrk>
    52e2:	40aa053b          	subw	a0,s4,a0
    52e6:	458000ef          	jal	573e <sbrk>
  return n;
}
    52ea:	8526                	mv	a0,s1
    52ec:	70a2                	ld	ra,40(sp)
    52ee:	7402                	ld	s0,32(sp)
    52f0:	64e2                	ld	s1,24(sp)
    52f2:	6942                	ld	s2,16(sp)
    52f4:	69a2                	ld	s3,8(sp)
    52f6:	6a02                	ld	s4,0(sp)
    52f8:	6145                	addi	sp,sp,48
    52fa:	8082                	ret

00000000000052fc <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    52fc:	7159                	addi	sp,sp,-112
    52fe:	f486                	sd	ra,104(sp)
    5300:	f0a2                	sd	s0,96(sp)
    5302:	eca6                	sd	s1,88(sp)
    5304:	e8ca                	sd	s2,80(sp)
    5306:	e4ce                	sd	s3,72(sp)
    5308:	e0d2                	sd	s4,64(sp)
    530a:	fc56                	sd	s5,56(sp)
    530c:	f85a                	sd	s6,48(sp)
    530e:	f45e                	sd	s7,40(sp)
    5310:	f062                	sd	s8,32(sp)
    5312:	ec66                	sd	s9,24(sp)
    5314:	e86a                	sd	s10,16(sp)
    5316:	e46e                	sd	s11,8(sp)
    5318:	1880                	addi	s0,sp,112
    531a:	8aaa                	mv	s5,a0
    531c:	89ae                	mv	s3,a1
    531e:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    5320:	00003c17          	auipc	s8,0x3
    5324:	ed8c0c13          	addi	s8,s8,-296 # 81f8 <malloc+0x258c>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    5328:	00004b97          	auipc	s7,0x4
    532c:	ce8b8b93          	addi	s7,s7,-792 # 9010 <quicktests>
    if (n < 0) {
      if (continuous != 2) {
    5330:	4b09                	li	s6,2
      ntests += n;
    }
    if (!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      n = runtests(slowtests, justone, continuous);
    5332:	00004c97          	auipc	s9,0x4
    5336:	12ec8c93          	addi	s9,s9,302 # 9460 <slowtests>
        printf("usertests slow tests starting\n");
    533a:	00003d97          	auipc	s11,0x3
    533e:	ed6d8d93          	addi	s11,s11,-298 # 8210 <malloc+0x25a4>
      } else {
        ntests += n;
      }
    }
    if ((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5342:	00003d17          	auipc	s10,0x3
    5346:	eeed0d13          	addi	s10,s10,-274 # 8230 <malloc+0x25c4>
    534a:	a025                	j	5372 <drivetests+0x76>
      if (continuous != 2) {
    534c:	09699063          	bne	s3,s6,53cc <drivetests+0xd0>
    int ntests = 0;
    5350:	4481                	li	s1,0
    5352:	a835                	j	538e <drivetests+0x92>
        printf("usertests slow tests starting\n");
    5354:	856e                	mv	a0,s11
    5356:	05f000ef          	jal	5bb4 <printf>
    535a:	a835                	j	5396 <drivetests+0x9a>
        if (continuous != 2) {
    535c:	07699a63          	bne	s3,s6,53d0 <drivetests+0xd4>
    if ((free1 = countfree()) < free0) {
    5360:	f51ff0ef          	jal	52b0 <countfree>
    5364:	05254263          	blt	a0,s2,53a8 <drivetests+0xac>
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    5368:	000a0363          	beqz	s4,536e <drivetests+0x72>
    536c:	c8a1                	beqz	s1,53bc <drivetests+0xc0>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    536e:	06098563          	beqz	s3,53d8 <drivetests+0xdc>
    printf("usertests starting\n");
    5372:	8562                	mv	a0,s8
    5374:	041000ef          	jal	5bb4 <printf>
    int free0 = countfree();
    5378:	f39ff0ef          	jal	52b0 <countfree>
    537c:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    537e:	864e                	mv	a2,s3
    5380:	85d2                	mv	a1,s4
    5382:	855e                	mv	a0,s7
    5384:	ebbff0ef          	jal	523e <runtests>
    5388:	84aa                	mv	s1,a0
    if (n < 0) {
    538a:	fc0541e3          	bltz	a0,534c <drivetests+0x50>
    if (!quick) {
    538e:	fc0a99e3          	bnez	s5,5360 <drivetests+0x64>
      if (justone == 0)
    5392:	fc0a01e3          	beqz	s4,5354 <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    5396:	864e                	mv	a2,s3
    5398:	85d2                	mv	a1,s4
    539a:	8566                	mv	a0,s9
    539c:	ea3ff0ef          	jal	523e <runtests>
      if (n < 0) {
    53a0:	fa054ee3          	bltz	a0,535c <drivetests+0x60>
        ntests += n;
    53a4:	9ca9                	addw	s1,s1,a0
    53a6:	bf6d                	j	5360 <drivetests+0x64>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    53a8:	864a                	mv	a2,s2
    53aa:	85aa                	mv	a1,a0
    53ac:	856a                	mv	a0,s10
    53ae:	007000ef          	jal	5bb4 <printf>
      if (continuous != 2) {
    53b2:	03699163          	bne	s3,s6,53d4 <drivetests+0xd8>
    if (justone != 0 && ntests == 0) {
    53b6:	fa0a1be3          	bnez	s4,536c <drivetests+0x70>
    53ba:	bf65                	j	5372 <drivetests+0x76>
      printf("NO TESTS EXECUTED\n");
    53bc:	00003517          	auipc	a0,0x3
    53c0:	ea450513          	addi	a0,a0,-348 # 8260 <malloc+0x25f4>
    53c4:	7f0000ef          	jal	5bb4 <printf>
      return 1;
    53c8:	4505                	li	a0,1
    53ca:	a801                	j	53da <drivetests+0xde>
        return 1;
    53cc:	4505                	li	a0,1
    53ce:	a031                	j	53da <drivetests+0xde>
          return 1;
    53d0:	4505                	li	a0,1
    53d2:	a021                	j	53da <drivetests+0xde>
        return 1;
    53d4:	4505                	li	a0,1
    53d6:	a011                	j	53da <drivetests+0xde>
  return 0;
    53d8:	854e                	mv	a0,s3
}
    53da:	70a6                	ld	ra,104(sp)
    53dc:	7406                	ld	s0,96(sp)
    53de:	64e6                	ld	s1,88(sp)
    53e0:	6946                	ld	s2,80(sp)
    53e2:	69a6                	ld	s3,72(sp)
    53e4:	6a06                	ld	s4,64(sp)
    53e6:	7ae2                	ld	s5,56(sp)
    53e8:	7b42                	ld	s6,48(sp)
    53ea:	7ba2                	ld	s7,40(sp)
    53ec:	7c02                	ld	s8,32(sp)
    53ee:	6ce2                	ld	s9,24(sp)
    53f0:	6d42                	ld	s10,16(sp)
    53f2:	6da2                	ld	s11,8(sp)
    53f4:	6165                	addi	sp,sp,112
    53f6:	8082                	ret

00000000000053f8 <main>:

int
main(int argc, char *argv[])
{
    53f8:	1101                	addi	sp,sp,-32
    53fa:	ec06                	sd	ra,24(sp)
    53fc:	e822                	sd	s0,16(sp)
    53fe:	e426                	sd	s1,8(sp)
    5400:	e04a                	sd	s2,0(sp)
    5402:	1000                	addi	s0,sp,32
    5404:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    5406:	4789                	li	a5,2
    5408:	00f50e63          	beq	a0,a5,5424 <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    540c:	4785                	li	a5,1
    540e:	06a7c663          	blt	a5,a0,547a <main+0x82>
  char *justone = 0;
    5412:	4601                	li	a2,0
  int quick = 0;
    5414:	4501                	li	a0,0
  int continuous = 0;
    5416:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    5418:	ee5ff0ef          	jal	52fc <drivetests>
    541c:	cd35                	beqz	a0,5498 <main+0xa0>
    exit(1);
    541e:	4505                	li	a0,1
    5420:	352000ef          	jal	5772 <exit>
    5424:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    5426:	00003597          	auipc	a1,0x3
    542a:	e5258593          	addi	a1,a1,-430 # 8278 <malloc+0x260c>
    542e:	00893503          	ld	a0,8(s2)
    5432:	0a8000ef          	jal	54da <strcmp>
    5436:	85aa                	mv	a1,a0
    5438:	e501                	bnez	a0,5440 <main+0x48>
  char *justone = 0;
    543a:	4601                	li	a2,0
    quick = 1;
    543c:	4505                	li	a0,1
    543e:	bfe9                	j	5418 <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    5440:	00003597          	auipc	a1,0x3
    5444:	e4058593          	addi	a1,a1,-448 # 8280 <malloc+0x2614>
    5448:	00893503          	ld	a0,8(s2)
    544c:	08e000ef          	jal	54da <strcmp>
    5450:	cd15                	beqz	a0,548c <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    5452:	00003597          	auipc	a1,0x3
    5456:	e7e58593          	addi	a1,a1,-386 # 82d0 <malloc+0x2664>
    545a:	00893503          	ld	a0,8(s2)
    545e:	07c000ef          	jal	54da <strcmp>
    5462:	c905                	beqz	a0,5492 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    5464:	00893603          	ld	a2,8(s2)
    5468:	00064703          	lbu	a4,0(a2) # 1000 <bigdir+0x10a>
    546c:	02d00793          	li	a5,45
    5470:	00f70563          	beq	a4,a5,547a <main+0x82>
  int quick = 0;
    5474:	4501                	li	a0,0
  int continuous = 0;
    5476:	4581                	li	a1,0
    5478:	b745                	j	5418 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    547a:	00003517          	auipc	a0,0x3
    547e:	e0e50513          	addi	a0,a0,-498 # 8288 <malloc+0x261c>
    5482:	732000ef          	jal	5bb4 <printf>
    exit(1);
    5486:	4505                	li	a0,1
    5488:	2ea000ef          	jal	5772 <exit>
  char *justone = 0;
    548c:	4601                	li	a2,0
    continuous = 1;
    548e:	4585                	li	a1,1
    5490:	b761                	j	5418 <main+0x20>
    continuous = 2;
    5492:	85a6                	mv	a1,s1
  char *justone = 0;
    5494:	4601                	li	a2,0
    5496:	b749                	j	5418 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5498:	00003517          	auipc	a0,0x3
    549c:	e2050513          	addi	a0,a0,-480 # 82b8 <malloc+0x264c>
    54a0:	714000ef          	jal	5bb4 <printf>
  exit(0);
    54a4:	4501                	li	a0,0
    54a6:	2cc000ef          	jal	5772 <exit>

00000000000054aa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    54aa:	1141                	addi	sp,sp,-16
    54ac:	e406                	sd	ra,8(sp)
    54ae:	e022                	sd	s0,0(sp)
    54b0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    54b2:	f47ff0ef          	jal	53f8 <main>
  exit(r);
    54b6:	2bc000ef          	jal	5772 <exit>

00000000000054ba <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    54ba:	1141                	addi	sp,sp,-16
    54bc:	e406                	sd	ra,8(sp)
    54be:	e022                	sd	s0,0(sp)
    54c0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    54c2:	87aa                	mv	a5,a0
    54c4:	0585                	addi	a1,a1,1
    54c6:	0785                	addi	a5,a5,1
    54c8:	fff5c703          	lbu	a4,-1(a1)
    54cc:	fee78fa3          	sb	a4,-1(a5)
    54d0:	fb75                	bnez	a4,54c4 <strcpy+0xa>
    ;
  return os;
}
    54d2:	60a2                	ld	ra,8(sp)
    54d4:	6402                	ld	s0,0(sp)
    54d6:	0141                	addi	sp,sp,16
    54d8:	8082                	ret

00000000000054da <strcmp>:

int
strcmp(const char *p, const char *q)
{
    54da:	1141                	addi	sp,sp,-16
    54dc:	e406                	sd	ra,8(sp)
    54de:	e022                	sd	s0,0(sp)
    54e0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    54e2:	00054783          	lbu	a5,0(a0)
    54e6:	cb91                	beqz	a5,54fa <strcmp+0x20>
    54e8:	0005c703          	lbu	a4,0(a1)
    54ec:	00f71763          	bne	a4,a5,54fa <strcmp+0x20>
    p++, q++;
    54f0:	0505                	addi	a0,a0,1
    54f2:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    54f4:	00054783          	lbu	a5,0(a0)
    54f8:	fbe5                	bnez	a5,54e8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    54fa:	0005c503          	lbu	a0,0(a1)
}
    54fe:	40a7853b          	subw	a0,a5,a0
    5502:	60a2                	ld	ra,8(sp)
    5504:	6402                	ld	s0,0(sp)
    5506:	0141                	addi	sp,sp,16
    5508:	8082                	ret

000000000000550a <strlen>:

uint
strlen(const char *s)
{
    550a:	1141                	addi	sp,sp,-16
    550c:	e406                	sd	ra,8(sp)
    550e:	e022                	sd	s0,0(sp)
    5510:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    5512:	00054783          	lbu	a5,0(a0)
    5516:	cf99                	beqz	a5,5534 <strlen+0x2a>
    5518:	0505                	addi	a0,a0,1
    551a:	87aa                	mv	a5,a0
    551c:	86be                	mv	a3,a5
    551e:	0785                	addi	a5,a5,1
    5520:	fff7c703          	lbu	a4,-1(a5)
    5524:	ff65                	bnez	a4,551c <strlen+0x12>
    5526:	40a6853b          	subw	a0,a3,a0
    552a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    552c:	60a2                	ld	ra,8(sp)
    552e:	6402                	ld	s0,0(sp)
    5530:	0141                	addi	sp,sp,16
    5532:	8082                	ret
  for (n = 0; s[n]; n++)
    5534:	4501                	li	a0,0
    5536:	bfdd                	j	552c <strlen+0x22>

0000000000005538 <memset>:

void *
memset(void *dst, int c, uint n)
{
    5538:	1141                	addi	sp,sp,-16
    553a:	e406                	sd	ra,8(sp)
    553c:	e022                	sd	s0,0(sp)
    553e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    5540:	ca19                	beqz	a2,5556 <memset+0x1e>
    5542:	87aa                	mv	a5,a0
    5544:	1602                	slli	a2,a2,0x20
    5546:	9201                	srli	a2,a2,0x20
    5548:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    554c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    5550:	0785                	addi	a5,a5,1
    5552:	fee79de3          	bne	a5,a4,554c <memset+0x14>
  }
  return dst;
}
    5556:	60a2                	ld	ra,8(sp)
    5558:	6402                	ld	s0,0(sp)
    555a:	0141                	addi	sp,sp,16
    555c:	8082                	ret

000000000000555e <strchr>:

char *
strchr(const char *s, char c)
{
    555e:	1141                	addi	sp,sp,-16
    5560:	e406                	sd	ra,8(sp)
    5562:	e022                	sd	s0,0(sp)
    5564:	0800                	addi	s0,sp,16
  for (; *s; s++)
    5566:	00054783          	lbu	a5,0(a0)
    556a:	cf81                	beqz	a5,5582 <strchr+0x24>
    if (*s == c)
    556c:	00f58763          	beq	a1,a5,557a <strchr+0x1c>
  for (; *s; s++)
    5570:	0505                	addi	a0,a0,1
    5572:	00054783          	lbu	a5,0(a0)
    5576:	fbfd                	bnez	a5,556c <strchr+0xe>
      return (char *)s;
  return 0;
    5578:	4501                	li	a0,0
}
    557a:	60a2                	ld	ra,8(sp)
    557c:	6402                	ld	s0,0(sp)
    557e:	0141                	addi	sp,sp,16
    5580:	8082                	ret
  return 0;
    5582:	4501                	li	a0,0
    5584:	bfdd                	j	557a <strchr+0x1c>

0000000000005586 <gets>:

char *
gets(char *buf, int max)
{
    5586:	7159                	addi	sp,sp,-112
    5588:	f486                	sd	ra,104(sp)
    558a:	f0a2                	sd	s0,96(sp)
    558c:	eca6                	sd	s1,88(sp)
    558e:	e8ca                	sd	s2,80(sp)
    5590:	e4ce                	sd	s3,72(sp)
    5592:	e0d2                	sd	s4,64(sp)
    5594:	fc56                	sd	s5,56(sp)
    5596:	f85a                	sd	s6,48(sp)
    5598:	f45e                	sd	s7,40(sp)
    559a:	f062                	sd	s8,32(sp)
    559c:	ec66                	sd	s9,24(sp)
    559e:	e86a                	sd	s10,16(sp)
    55a0:	1880                	addi	s0,sp,112
    55a2:	8caa                	mv	s9,a0
    55a4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    55a6:	892a                	mv	s2,a0
    55a8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    55aa:	f9f40b13          	addi	s6,s0,-97
    55ae:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
    55b0:	4ba9                	li	s7,10
    55b2:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
    55b4:	8d26                	mv	s10,s1
    55b6:	0014899b          	addiw	s3,s1,1
    55ba:	84ce                	mv	s1,s3
    55bc:	0349d563          	bge	s3,s4,55e6 <gets+0x60>
    cc = read(0, &c, 1);
    55c0:	8656                	mv	a2,s5
    55c2:	85da                	mv	a1,s6
    55c4:	4501                	li	a0,0
    55c6:	1c4000ef          	jal	578a <read>
    if (cc < 1)
    55ca:	00a05e63          	blez	a0,55e6 <gets+0x60>
    buf[i++] = c;
    55ce:	f9f44783          	lbu	a5,-97(s0)
    55d2:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    55d6:	01778763          	beq	a5,s7,55e4 <gets+0x5e>
    55da:	0905                	addi	s2,s2,1
    55dc:	fd879ce3          	bne	a5,s8,55b4 <gets+0x2e>
    buf[i++] = c;
    55e0:	8d4e                	mv	s10,s3
    55e2:	a011                	j	55e6 <gets+0x60>
    55e4:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    55e6:	9d66                	add	s10,s10,s9
    55e8:	000d0023          	sb	zero,0(s10)
  return buf;
}
    55ec:	8566                	mv	a0,s9
    55ee:	70a6                	ld	ra,104(sp)
    55f0:	7406                	ld	s0,96(sp)
    55f2:	64e6                	ld	s1,88(sp)
    55f4:	6946                	ld	s2,80(sp)
    55f6:	69a6                	ld	s3,72(sp)
    55f8:	6a06                	ld	s4,64(sp)
    55fa:	7ae2                	ld	s5,56(sp)
    55fc:	7b42                	ld	s6,48(sp)
    55fe:	7ba2                	ld	s7,40(sp)
    5600:	7c02                	ld	s8,32(sp)
    5602:	6ce2                	ld	s9,24(sp)
    5604:	6d42                	ld	s10,16(sp)
    5606:	6165                	addi	sp,sp,112
    5608:	8082                	ret

000000000000560a <stat>:

int
stat(const char *n, struct stat *st)
{
    560a:	1101                	addi	sp,sp,-32
    560c:	ec06                	sd	ra,24(sp)
    560e:	e822                	sd	s0,16(sp)
    5610:	e04a                	sd	s2,0(sp)
    5612:	1000                	addi	s0,sp,32
    5614:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5616:	4581                	li	a1,0
    5618:	19a000ef          	jal	57b2 <open>
  if (fd < 0)
    561c:	02054263          	bltz	a0,5640 <stat+0x36>
    5620:	e426                	sd	s1,8(sp)
    5622:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5624:	85ca                	mv	a1,s2
    5626:	1a4000ef          	jal	57ca <fstat>
    562a:	892a                	mv	s2,a0
  close(fd);
    562c:	8526                	mv	a0,s1
    562e:	16c000ef          	jal	579a <close>
  return r;
    5632:	64a2                	ld	s1,8(sp)
}
    5634:	854a                	mv	a0,s2
    5636:	60e2                	ld	ra,24(sp)
    5638:	6442                	ld	s0,16(sp)
    563a:	6902                	ld	s2,0(sp)
    563c:	6105                	addi	sp,sp,32
    563e:	8082                	ret
    return -1;
    5640:	597d                	li	s2,-1
    5642:	bfcd                	j	5634 <stat+0x2a>

0000000000005644 <atoi>:

int
atoi(const char *s)
{
    5644:	1141                	addi	sp,sp,-16
    5646:	e406                	sd	ra,8(sp)
    5648:	e022                	sd	s0,0(sp)
    564a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    564c:	00054683          	lbu	a3,0(a0)
    5650:	fd06879b          	addiw	a5,a3,-48
    5654:	0ff7f793          	zext.b	a5,a5
    5658:	4625                	li	a2,9
    565a:	02f66963          	bltu	a2,a5,568c <atoi+0x48>
    565e:	872a                	mv	a4,a0
  n = 0;
    5660:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    5662:	0705                	addi	a4,a4,1
    5664:	0025179b          	slliw	a5,a0,0x2
    5668:	9fa9                	addw	a5,a5,a0
    566a:	0017979b          	slliw	a5,a5,0x1
    566e:	9fb5                	addw	a5,a5,a3
    5670:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    5674:	00074683          	lbu	a3,0(a4)
    5678:	fd06879b          	addiw	a5,a3,-48
    567c:	0ff7f793          	zext.b	a5,a5
    5680:	fef671e3          	bgeu	a2,a5,5662 <atoi+0x1e>
  return n;
}
    5684:	60a2                	ld	ra,8(sp)
    5686:	6402                	ld	s0,0(sp)
    5688:	0141                	addi	sp,sp,16
    568a:	8082                	ret
  n = 0;
    568c:	4501                	li	a0,0
    568e:	bfdd                	j	5684 <atoi+0x40>

0000000000005690 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    5690:	1141                	addi	sp,sp,-16
    5692:	e406                	sd	ra,8(sp)
    5694:	e022                	sd	s0,0(sp)
    5696:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5698:	02b57563          	bgeu	a0,a1,56c2 <memmove+0x32>
    while (n-- > 0)
    569c:	00c05f63          	blez	a2,56ba <memmove+0x2a>
    56a0:	1602                	slli	a2,a2,0x20
    56a2:	9201                	srli	a2,a2,0x20
    56a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    56a8:	872a                	mv	a4,a0
      *dst++ = *src++;
    56aa:	0585                	addi	a1,a1,1
    56ac:	0705                	addi	a4,a4,1
    56ae:	fff5c683          	lbu	a3,-1(a1)
    56b2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    56b6:	fee79ae3          	bne	a5,a4,56aa <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    56ba:	60a2                	ld	ra,8(sp)
    56bc:	6402                	ld	s0,0(sp)
    56be:	0141                	addi	sp,sp,16
    56c0:	8082                	ret
    dst += n;
    56c2:	00c50733          	add	a4,a0,a2
    src += n;
    56c6:	95b2                	add	a1,a1,a2
    while (n-- > 0)
    56c8:	fec059e3          	blez	a2,56ba <memmove+0x2a>
    56cc:	fff6079b          	addiw	a5,a2,-1
    56d0:	1782                	slli	a5,a5,0x20
    56d2:	9381                	srli	a5,a5,0x20
    56d4:	fff7c793          	not	a5,a5
    56d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    56da:	15fd                	addi	a1,a1,-1
    56dc:	177d                	addi	a4,a4,-1
    56de:	0005c683          	lbu	a3,0(a1)
    56e2:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    56e6:	fef71ae3          	bne	a4,a5,56da <memmove+0x4a>
    56ea:	bfc1                	j	56ba <memmove+0x2a>

00000000000056ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    56ec:	1141                	addi	sp,sp,-16
    56ee:	e406                	sd	ra,8(sp)
    56f0:	e022                	sd	s0,0(sp)
    56f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    56f4:	ca0d                	beqz	a2,5726 <memcmp+0x3a>
    56f6:	fff6069b          	addiw	a3,a2,-1
    56fa:	1682                	slli	a3,a3,0x20
    56fc:	9281                	srli	a3,a3,0x20
    56fe:	0685                	addi	a3,a3,1
    5700:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5702:	00054783          	lbu	a5,0(a0)
    5706:	0005c703          	lbu	a4,0(a1)
    570a:	00e79863          	bne	a5,a4,571a <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    570e:	0505                	addi	a0,a0,1
    p2++;
    5710:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5712:	fed518e3          	bne	a0,a3,5702 <memcmp+0x16>
  }
  return 0;
    5716:	4501                	li	a0,0
    5718:	a019                	j	571e <memcmp+0x32>
      return *p1 - *p2;
    571a:	40e7853b          	subw	a0,a5,a4
}
    571e:	60a2                	ld	ra,8(sp)
    5720:	6402                	ld	s0,0(sp)
    5722:	0141                	addi	sp,sp,16
    5724:	8082                	ret
  return 0;
    5726:	4501                	li	a0,0
    5728:	bfdd                	j	571e <memcmp+0x32>

000000000000572a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    572a:	1141                	addi	sp,sp,-16
    572c:	e406                	sd	ra,8(sp)
    572e:	e022                	sd	s0,0(sp)
    5730:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5732:	f5fff0ef          	jal	5690 <memmove>
}
    5736:	60a2                	ld	ra,8(sp)
    5738:	6402                	ld	s0,0(sp)
    573a:	0141                	addi	sp,sp,16
    573c:	8082                	ret

000000000000573e <sbrk>:

char *
sbrk(int n)
{
    573e:	1141                	addi	sp,sp,-16
    5740:	e406                	sd	ra,8(sp)
    5742:	e022                	sd	s0,0(sp)
    5744:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    5746:	4585                	li	a1,1
    5748:	0b2000ef          	jal	57fa <sys_sbrk>
}
    574c:	60a2                	ld	ra,8(sp)
    574e:	6402                	ld	s0,0(sp)
    5750:	0141                	addi	sp,sp,16
    5752:	8082                	ret

0000000000005754 <sbrklazy>:

char *
sbrklazy(int n)
{
    5754:	1141                	addi	sp,sp,-16
    5756:	e406                	sd	ra,8(sp)
    5758:	e022                	sd	s0,0(sp)
    575a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    575c:	4589                	li	a1,2
    575e:	09c000ef          	jal	57fa <sys_sbrk>
}
    5762:	60a2                	ld	ra,8(sp)
    5764:	6402                	ld	s0,0(sp)
    5766:	0141                	addi	sp,sp,16
    5768:	8082                	ret

000000000000576a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    576a:	4885                	li	a7,1
 ecall
    576c:	00000073          	ecall
 ret
    5770:	8082                	ret

0000000000005772 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5772:	4889                	li	a7,2
 ecall
    5774:	00000073          	ecall
 ret
    5778:	8082                	ret

000000000000577a <wait>:
.global wait
wait:
 li a7, SYS_wait
    577a:	488d                	li	a7,3
 ecall
    577c:	00000073          	ecall
 ret
    5780:	8082                	ret

0000000000005782 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5782:	4891                	li	a7,4
 ecall
    5784:	00000073          	ecall
 ret
    5788:	8082                	ret

000000000000578a <read>:
.global read
read:
 li a7, SYS_read
    578a:	4895                	li	a7,5
 ecall
    578c:	00000073          	ecall
 ret
    5790:	8082                	ret

0000000000005792 <write>:
.global write
write:
 li a7, SYS_write
    5792:	48c1                	li	a7,16
 ecall
    5794:	00000073          	ecall
 ret
    5798:	8082                	ret

000000000000579a <close>:
.global close
close:
 li a7, SYS_close
    579a:	48d5                	li	a7,21
 ecall
    579c:	00000073          	ecall
 ret
    57a0:	8082                	ret

00000000000057a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    57a2:	4899                	li	a7,6
 ecall
    57a4:	00000073          	ecall
 ret
    57a8:	8082                	ret

00000000000057aa <exec>:
.global exec
exec:
 li a7, SYS_exec
    57aa:	489d                	li	a7,7
 ecall
    57ac:	00000073          	ecall
 ret
    57b0:	8082                	ret

00000000000057b2 <open>:
.global open
open:
 li a7, SYS_open
    57b2:	48bd                	li	a7,15
 ecall
    57b4:	00000073          	ecall
 ret
    57b8:	8082                	ret

00000000000057ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    57ba:	48c5                	li	a7,17
 ecall
    57bc:	00000073          	ecall
 ret
    57c0:	8082                	ret

00000000000057c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    57c2:	48c9                	li	a7,18
 ecall
    57c4:	00000073          	ecall
 ret
    57c8:	8082                	ret

00000000000057ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    57ca:	48a1                	li	a7,8
 ecall
    57cc:	00000073          	ecall
 ret
    57d0:	8082                	ret

00000000000057d2 <link>:
.global link
link:
 li a7, SYS_link
    57d2:	48cd                	li	a7,19
 ecall
    57d4:	00000073          	ecall
 ret
    57d8:	8082                	ret

00000000000057da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    57da:	48d1                	li	a7,20
 ecall
    57dc:	00000073          	ecall
 ret
    57e0:	8082                	ret

00000000000057e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    57e2:	48a5                	li	a7,9
 ecall
    57e4:	00000073          	ecall
 ret
    57e8:	8082                	ret

00000000000057ea <dup>:
.global dup
dup:
 li a7, SYS_dup
    57ea:	48a9                	li	a7,10
 ecall
    57ec:	00000073          	ecall
 ret
    57f0:	8082                	ret

00000000000057f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    57f2:	48ad                	li	a7,11
 ecall
    57f4:	00000073          	ecall
 ret
    57f8:	8082                	ret

00000000000057fa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    57fa:	48b1                	li	a7,12
 ecall
    57fc:	00000073          	ecall
 ret
    5800:	8082                	ret

0000000000005802 <pause>:
.global pause
pause:
 li a7, SYS_pause
    5802:	48b5                	li	a7,13
 ecall
    5804:	00000073          	ecall
 ret
    5808:	8082                	ret

000000000000580a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    580a:	48b9                	li	a7,14
 ecall
    580c:	00000073          	ecall
 ret
    5810:	8082                	ret

0000000000005812 <sync>:
.global sync
sync:
 li a7, SYS_sync
    5812:	48d9                	li	a7,22
 ecall
    5814:	00000073          	ecall
 ret
    5818:	8082                	ret

000000000000581a <ps>:
.global ps
ps:
 li a7, SYS_ps
    581a:	48dd                	li	a7,23
 ecall
    581c:	00000073          	ecall
 ret
    5820:	8082                	ret

0000000000005822 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
    5822:	48e1                	li	a7,24
 ecall
    5824:	00000073          	ecall
 ret
    5828:	8082                	ret

000000000000582a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    582a:	48e5                	li	a7,25
 ecall
    582c:	00000073          	ecall
 ret
    5830:	8082                	ret

0000000000005832 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    5832:	48e9                	li	a7,26
 ecall
    5834:	00000073          	ecall
 ret
    5838:	8082                	ret

000000000000583a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    583a:	1101                	addi	sp,sp,-32
    583c:	ec06                	sd	ra,24(sp)
    583e:	e822                	sd	s0,16(sp)
    5840:	1000                	addi	s0,sp,32
    5842:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5846:	4605                	li	a2,1
    5848:	fef40593          	addi	a1,s0,-17
    584c:	f47ff0ef          	jal	5792 <write>
}
    5850:	60e2                	ld	ra,24(sp)
    5852:	6442                	ld	s0,16(sp)
    5854:	6105                	addi	sp,sp,32
    5856:	8082                	ret

0000000000005858 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    5858:	715d                	addi	sp,sp,-80
    585a:	e486                	sd	ra,72(sp)
    585c:	e0a2                	sd	s0,64(sp)
    585e:	fc26                	sd	s1,56(sp)
    5860:	f84a                	sd	s2,48(sp)
    5862:	f44e                	sd	s3,40(sp)
    5864:	0880                	addi	s0,sp,80
    5866:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    5868:	c299                	beqz	a3,586e <printint+0x16>
    586a:	0605cc63          	bltz	a1,58e2 <printint+0x8a>
  neg = 0;
    586e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    5870:	fb840313          	addi	t1,s0,-72
  neg = 0;
    5874:	869a                	mv	a3,t1
  i = 0;
    5876:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    5878:	00003817          	auipc	a6,0x3
    587c:	ec080813          	addi	a6,a6,-320 # 8738 <digits>
    5880:	88be                	mv	a7,a5
    5882:	0017851b          	addiw	a0,a5,1
    5886:	87aa                	mv	a5,a0
    5888:	02c5f733          	remu	a4,a1,a2
    588c:	9742                	add	a4,a4,a6
    588e:	00074703          	lbu	a4,0(a4)
    5892:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
    5896:	872e                	mv	a4,a1
    5898:	02c5d5b3          	divu	a1,a1,a2
    589c:	0685                	addi	a3,a3,1
    589e:	fec771e3          	bgeu	a4,a2,5880 <printint+0x28>
  if (neg)
    58a2:	000e0c63          	beqz	t3,58ba <printint+0x62>
    buf[i++] = '-';
    58a6:	fd050793          	addi	a5,a0,-48
    58aa:	00878533          	add	a0,a5,s0
    58ae:	02d00793          	li	a5,45
    58b2:	fef50423          	sb	a5,-24(a0)
    58b6:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
    58ba:	fff7899b          	addiw	s3,a5,-1
    58be:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    58c2:	fff4c583          	lbu	a1,-1(s1)
    58c6:	854a                	mv	a0,s2
    58c8:	f73ff0ef          	jal	583a <putc>
  while (--i >= 0)
    58cc:	39fd                	addiw	s3,s3,-1 # fff <bigdir+0x109>
    58ce:	14fd                	addi	s1,s1,-1
    58d0:	fe09d9e3          	bgez	s3,58c2 <printint+0x6a>
}
    58d4:	60a6                	ld	ra,72(sp)
    58d6:	6406                	ld	s0,64(sp)
    58d8:	74e2                	ld	s1,56(sp)
    58da:	7942                	ld	s2,48(sp)
    58dc:	79a2                	ld	s3,40(sp)
    58de:	6161                	addi	sp,sp,80
    58e0:	8082                	ret
    x = -xx;
    58e2:	40b005b3          	neg	a1,a1
    neg = 1;
    58e6:	4e05                	li	t3,1
    x = -xx;
    58e8:	b761                	j	5870 <printint+0x18>

00000000000058ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    58ea:	711d                	addi	sp,sp,-96
    58ec:	ec86                	sd	ra,88(sp)
    58ee:	e8a2                	sd	s0,80(sp)
    58f0:	e4a6                	sd	s1,72(sp)
    58f2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    58f4:	0005c483          	lbu	s1,0(a1)
    58f8:	28048463          	beqz	s1,5b80 <vprintf+0x296>
    58fc:	e0ca                	sd	s2,64(sp)
    58fe:	fc4e                	sd	s3,56(sp)
    5900:	f852                	sd	s4,48(sp)
    5902:	f456                	sd	s5,40(sp)
    5904:	f05a                	sd	s6,32(sp)
    5906:	ec5e                	sd	s7,24(sp)
    5908:	e862                	sd	s8,16(sp)
    590a:	e466                	sd	s9,8(sp)
    590c:	8b2a                	mv	s6,a0
    590e:	8a2e                	mv	s4,a1
    5910:	8bb2                	mv	s7,a2
  state = 0;
    5912:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    5914:	4901                	li	s2,0
    5916:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    5918:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    591c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    5920:	06c00c93          	li	s9,108
    5924:	a00d                	j	5946 <vprintf+0x5c>
        putc(fd, c0);
    5926:	85a6                	mv	a1,s1
    5928:	855a                	mv	a0,s6
    592a:	f11ff0ef          	jal	583a <putc>
    592e:	a019                	j	5934 <vprintf+0x4a>
    } else if (state == '%') {
    5930:	03598363          	beq	s3,s5,5956 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
    5934:	0019079b          	addiw	a5,s2,1
    5938:	893e                	mv	s2,a5
    593a:	873e                	mv	a4,a5
    593c:	97d2                	add	a5,a5,s4
    593e:	0007c483          	lbu	s1,0(a5)
    5942:	22048763          	beqz	s1,5b70 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
    5946:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    594a:	fe0993e3          	bnez	s3,5930 <vprintf+0x46>
      if (c0 == '%') {
    594e:	fd579ce3          	bne	a5,s5,5926 <vprintf+0x3c>
        state = '%';
    5952:	89be                	mv	s3,a5
    5954:	b7c5                	j	5934 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
    5956:	00ea06b3          	add	a3,s4,a4
    595a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    595e:	8636                	mv	a2,a3
      if (c1)
    5960:	c681                	beqz	a3,5968 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
    5962:	9752                	add	a4,a4,s4
    5964:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
    5968:	05878263          	beq	a5,s8,59ac <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
    596c:	05978c63          	beq	a5,s9,59c4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    5970:	07500713          	li	a4,117
    5974:	0ee78663          	beq	a5,a4,5a60 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    5978:	07800713          	li	a4,120
    597c:	12e78863          	beq	a5,a4,5aac <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    5980:	07000713          	li	a4,112
    5984:	14e78d63          	beq	a5,a4,5ade <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    5988:	06300713          	li	a4,99
    598c:	18e78c63          	beq	a5,a4,5b24 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    5990:	07300713          	li	a4,115
    5994:	1ae78263          	beq	a5,a4,5b38 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    5998:	02500713          	li	a4,37
    599c:	04e79463          	bne	a5,a4,59e4 <vprintf+0xfa>
        putc(fd, '%');
    59a0:	85ba                	mv	a1,a4
    59a2:	855a                	mv	a0,s6
    59a4:	e97ff0ef          	jal	583a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    59a8:	4981                	li	s3,0
    59aa:	b769                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    59ac:	008b8493          	addi	s1,s7,8
    59b0:	4685                	li	a3,1
    59b2:	4629                	li	a2,10
    59b4:	000ba583          	lw	a1,0(s7)
    59b8:	855a                	mv	a0,s6
    59ba:	e9fff0ef          	jal	5858 <printint>
    59be:	8ba6                	mv	s7,s1
      state = 0;
    59c0:	4981                	li	s3,0
    59c2:	bf8d                	j	5934 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
    59c4:	06400793          	li	a5,100
    59c8:	02f68963          	beq	a3,a5,59fa <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    59cc:	06c00793          	li	a5,108
    59d0:	04f68263          	beq	a3,a5,5a14 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
    59d4:	07500793          	li	a5,117
    59d8:	0af68063          	beq	a3,a5,5a78 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
    59dc:	07800793          	li	a5,120
    59e0:	0ef68263          	beq	a3,a5,5ac4 <vprintf+0x1da>
        putc(fd, '%');
    59e4:	02500593          	li	a1,37
    59e8:	855a                	mv	a0,s6
    59ea:	e51ff0ef          	jal	583a <putc>
        putc(fd, c0);
    59ee:	85a6                	mv	a1,s1
    59f0:	855a                	mv	a0,s6
    59f2:	e49ff0ef          	jal	583a <putc>
      state = 0;
    59f6:	4981                	li	s3,0
    59f8:	bf35                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    59fa:	008b8493          	addi	s1,s7,8
    59fe:	4685                	li	a3,1
    5a00:	4629                	li	a2,10
    5a02:	000bb583          	ld	a1,0(s7)
    5a06:	855a                	mv	a0,s6
    5a08:	e51ff0ef          	jal	5858 <printint>
        i += 1;
    5a0c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a0e:	8ba6                	mv	s7,s1
      state = 0;
    5a10:	4981                	li	s3,0
        i += 1;
    5a12:	b70d                	j	5934 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5a14:	06400793          	li	a5,100
    5a18:	02f60763          	beq	a2,a5,5a46 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5a1c:	07500793          	li	a5,117
    5a20:	06f60963          	beq	a2,a5,5a92 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5a24:	07800793          	li	a5,120
    5a28:	faf61ee3          	bne	a2,a5,59e4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a2c:	008b8493          	addi	s1,s7,8
    5a30:	4681                	li	a3,0
    5a32:	4641                	li	a2,16
    5a34:	000bb583          	ld	a1,0(s7)
    5a38:	855a                	mv	a0,s6
    5a3a:	e1fff0ef          	jal	5858 <printint>
        i += 2;
    5a3e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5a40:	8ba6                	mv	s7,s1
      state = 0;
    5a42:	4981                	li	s3,0
        i += 2;
    5a44:	bdc5                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a46:	008b8493          	addi	s1,s7,8
    5a4a:	4685                	li	a3,1
    5a4c:	4629                	li	a2,10
    5a4e:	000bb583          	ld	a1,0(s7)
    5a52:	855a                	mv	a0,s6
    5a54:	e05ff0ef          	jal	5858 <printint>
        i += 2;
    5a58:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a5a:	8ba6                	mv	s7,s1
      state = 0;
    5a5c:	4981                	li	s3,0
        i += 2;
    5a5e:	bdd9                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5a60:	008b8493          	addi	s1,s7,8
    5a64:	4681                	li	a3,0
    5a66:	4629                	li	a2,10
    5a68:	000be583          	lwu	a1,0(s7)
    5a6c:	855a                	mv	a0,s6
    5a6e:	debff0ef          	jal	5858 <printint>
    5a72:	8ba6                	mv	s7,s1
      state = 0;
    5a74:	4981                	li	s3,0
    5a76:	bd7d                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a78:	008b8493          	addi	s1,s7,8
    5a7c:	4681                	li	a3,0
    5a7e:	4629                	li	a2,10
    5a80:	000bb583          	ld	a1,0(s7)
    5a84:	855a                	mv	a0,s6
    5a86:	dd3ff0ef          	jal	5858 <printint>
        i += 1;
    5a8a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a8c:	8ba6                	mv	s7,s1
      state = 0;
    5a8e:	4981                	li	s3,0
        i += 1;
    5a90:	b555                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a92:	008b8493          	addi	s1,s7,8
    5a96:	4681                	li	a3,0
    5a98:	4629                	li	a2,10
    5a9a:	000bb583          	ld	a1,0(s7)
    5a9e:	855a                	mv	a0,s6
    5aa0:	db9ff0ef          	jal	5858 <printint>
        i += 2;
    5aa4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5aa6:	8ba6                	mv	s7,s1
      state = 0;
    5aa8:	4981                	li	s3,0
        i += 2;
    5aaa:	b569                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5aac:	008b8493          	addi	s1,s7,8
    5ab0:	4681                	li	a3,0
    5ab2:	4641                	li	a2,16
    5ab4:	000be583          	lwu	a1,0(s7)
    5ab8:	855a                	mv	a0,s6
    5aba:	d9fff0ef          	jal	5858 <printint>
    5abe:	8ba6                	mv	s7,s1
      state = 0;
    5ac0:	4981                	li	s3,0
    5ac2:	bd8d                	j	5934 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5ac4:	008b8493          	addi	s1,s7,8
    5ac8:	4681                	li	a3,0
    5aca:	4641                	li	a2,16
    5acc:	000bb583          	ld	a1,0(s7)
    5ad0:	855a                	mv	a0,s6
    5ad2:	d87ff0ef          	jal	5858 <printint>
        i += 1;
    5ad6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5ad8:	8ba6                	mv	s7,s1
      state = 0;
    5ada:	4981                	li	s3,0
        i += 1;
    5adc:	bda1                	j	5934 <vprintf+0x4a>
    5ade:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5ae0:	008b8d13          	addi	s10,s7,8
    5ae4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5ae8:	03000593          	li	a1,48
    5aec:	855a                	mv	a0,s6
    5aee:	d4dff0ef          	jal	583a <putc>
  putc(fd, 'x');
    5af2:	07800593          	li	a1,120
    5af6:	855a                	mv	a0,s6
    5af8:	d43ff0ef          	jal	583a <putc>
    5afc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5afe:	00003b97          	auipc	s7,0x3
    5b02:	c3ab8b93          	addi	s7,s7,-966 # 8738 <digits>
    5b06:	03c9d793          	srli	a5,s3,0x3c
    5b0a:	97de                	add	a5,a5,s7
    5b0c:	0007c583          	lbu	a1,0(a5)
    5b10:	855a                	mv	a0,s6
    5b12:	d29ff0ef          	jal	583a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b16:	0992                	slli	s3,s3,0x4
    5b18:	34fd                	addiw	s1,s1,-1
    5b1a:	f4f5                	bnez	s1,5b06 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    5b1c:	8bea                	mv	s7,s10
      state = 0;
    5b1e:	4981                	li	s3,0
    5b20:	6d02                	ld	s10,0(sp)
    5b22:	bd09                	j	5934 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    5b24:	008b8493          	addi	s1,s7,8
    5b28:	000bc583          	lbu	a1,0(s7)
    5b2c:	855a                	mv	a0,s6
    5b2e:	d0dff0ef          	jal	583a <putc>
    5b32:	8ba6                	mv	s7,s1
      state = 0;
    5b34:	4981                	li	s3,0
    5b36:	bbfd                	j	5934 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
    5b38:	008b8993          	addi	s3,s7,8
    5b3c:	000bb483          	ld	s1,0(s7)
    5b40:	cc91                	beqz	s1,5b5c <vprintf+0x272>
        for (; *s; s++)
    5b42:	0004c583          	lbu	a1,0(s1)
    5b46:	c195                	beqz	a1,5b6a <vprintf+0x280>
          putc(fd, *s);
    5b48:	855a                	mv	a0,s6
    5b4a:	cf1ff0ef          	jal	583a <putc>
        for (; *s; s++)
    5b4e:	0485                	addi	s1,s1,1
    5b50:	0004c583          	lbu	a1,0(s1)
    5b54:	f9f5                	bnez	a1,5b48 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    5b56:	8bce                	mv	s7,s3
      state = 0;
    5b58:	4981                	li	s3,0
    5b5a:	bbe9                	j	5934 <vprintf+0x4a>
          s = "(null)";
    5b5c:	00003497          	auipc	s1,0x3
    5b60:	b2c48493          	addi	s1,s1,-1236 # 8688 <malloc+0x2a1c>
        for (; *s; s++)
    5b64:	02800593          	li	a1,40
    5b68:	b7c5                	j	5b48 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    5b6a:	8bce                	mv	s7,s3
      state = 0;
    5b6c:	4981                	li	s3,0
    5b6e:	b3d9                	j	5934 <vprintf+0x4a>
    5b70:	6906                	ld	s2,64(sp)
    5b72:	79e2                	ld	s3,56(sp)
    5b74:	7a42                	ld	s4,48(sp)
    5b76:	7aa2                	ld	s5,40(sp)
    5b78:	7b02                	ld	s6,32(sp)
    5b7a:	6be2                	ld	s7,24(sp)
    5b7c:	6c42                	ld	s8,16(sp)
    5b7e:	6ca2                	ld	s9,8(sp)
    }
  }
}
    5b80:	60e6                	ld	ra,88(sp)
    5b82:	6446                	ld	s0,80(sp)
    5b84:	64a6                	ld	s1,72(sp)
    5b86:	6125                	addi	sp,sp,96
    5b88:	8082                	ret

0000000000005b8a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5b8a:	715d                	addi	sp,sp,-80
    5b8c:	ec06                	sd	ra,24(sp)
    5b8e:	e822                	sd	s0,16(sp)
    5b90:	1000                	addi	s0,sp,32
    5b92:	e010                	sd	a2,0(s0)
    5b94:	e414                	sd	a3,8(s0)
    5b96:	e818                	sd	a4,16(s0)
    5b98:	ec1c                	sd	a5,24(s0)
    5b9a:	03043023          	sd	a6,32(s0)
    5b9e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ba2:	8622                	mv	a2,s0
    5ba4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5ba8:	d43ff0ef          	jal	58ea <vprintf>
}
    5bac:	60e2                	ld	ra,24(sp)
    5bae:	6442                	ld	s0,16(sp)
    5bb0:	6161                	addi	sp,sp,80
    5bb2:	8082                	ret

0000000000005bb4 <printf>:

void
printf(const char *fmt, ...)
{
    5bb4:	711d                	addi	sp,sp,-96
    5bb6:	ec06                	sd	ra,24(sp)
    5bb8:	e822                	sd	s0,16(sp)
    5bba:	1000                	addi	s0,sp,32
    5bbc:	e40c                	sd	a1,8(s0)
    5bbe:	e810                	sd	a2,16(s0)
    5bc0:	ec14                	sd	a3,24(s0)
    5bc2:	f018                	sd	a4,32(s0)
    5bc4:	f41c                	sd	a5,40(s0)
    5bc6:	03043823          	sd	a6,48(s0)
    5bca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bce:	00840613          	addi	a2,s0,8
    5bd2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bd6:	85aa                	mv	a1,a0
    5bd8:	4505                	li	a0,1
    5bda:	d11ff0ef          	jal	58ea <vprintf>
}
    5bde:	60e2                	ld	ra,24(sp)
    5be0:	6442                	ld	s0,16(sp)
    5be2:	6125                	addi	sp,sp,96
    5be4:	8082                	ret

0000000000005be6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5be6:	1141                	addi	sp,sp,-16
    5be8:	e406                	sd	ra,8(sp)
    5bea:	e022                	sd	s0,0(sp)
    5bec:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5bee:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5bf2:	00004797          	auipc	a5,0x4
    5bf6:	8de7b783          	ld	a5,-1826(a5) # 94d0 <freep>
    5bfa:	a02d                	j	5c24 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    5bfc:	4618                	lw	a4,8(a2)
    5bfe:	9f2d                	addw	a4,a4,a1
    5c00:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c04:	6398                	ld	a4,0(a5)
    5c06:	6310                	ld	a2,0(a4)
    5c08:	a83d                	j	5c46 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    5c0a:	ff852703          	lw	a4,-8(a0)
    5c0e:	9f31                	addw	a4,a4,a2
    5c10:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5c12:	ff053683          	ld	a3,-16(a0)
    5c16:	a091                	j	5c5a <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c18:	6398                	ld	a4,0(a5)
    5c1a:	00e7e463          	bltu	a5,a4,5c22 <free+0x3c>
    5c1e:	00e6ea63          	bltu	a3,a4,5c32 <free+0x4c>
{
    5c22:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c24:	fed7fae3          	bgeu	a5,a3,5c18 <free+0x32>
    5c28:	6398                	ld	a4,0(a5)
    5c2a:	00e6e463          	bltu	a3,a4,5c32 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c2e:	fee7eae3          	bltu	a5,a4,5c22 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
    5c32:	ff852583          	lw	a1,-8(a0)
    5c36:	6390                	ld	a2,0(a5)
    5c38:	02059813          	slli	a6,a1,0x20
    5c3c:	01c85713          	srli	a4,a6,0x1c
    5c40:	9736                	add	a4,a4,a3
    5c42:	fae60de3          	beq	a2,a4,5bfc <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    5c46:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    5c4a:	4790                	lw	a2,8(a5)
    5c4c:	02061593          	slli	a1,a2,0x20
    5c50:	01c5d713          	srli	a4,a1,0x1c
    5c54:	973e                	add	a4,a4,a5
    5c56:	fae68ae3          	beq	a3,a4,5c0a <free+0x24>
    p->s.ptr = bp->s.ptr;
    5c5a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5c5c:	00004717          	auipc	a4,0x4
    5c60:	86f73a23          	sd	a5,-1932(a4) # 94d0 <freep>
}
    5c64:	60a2                	ld	ra,8(sp)
    5c66:	6402                	ld	s0,0(sp)
    5c68:	0141                	addi	sp,sp,16
    5c6a:	8082                	ret

0000000000005c6c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5c6c:	7139                	addi	sp,sp,-64
    5c6e:	fc06                	sd	ra,56(sp)
    5c70:	f822                	sd	s0,48(sp)
    5c72:	f04a                	sd	s2,32(sp)
    5c74:	ec4e                	sd	s3,24(sp)
    5c76:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5c78:	02051993          	slli	s3,a0,0x20
    5c7c:	0209d993          	srli	s3,s3,0x20
    5c80:	09bd                	addi	s3,s3,15
    5c82:	0049d993          	srli	s3,s3,0x4
    5c86:	2985                	addiw	s3,s3,1
    5c88:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5c8a:	00004517          	auipc	a0,0x4
    5c8e:	84653503          	ld	a0,-1978(a0) # 94d0 <freep>
    5c92:	c905                	beqz	a0,5cc2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5c94:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5c96:	4798                	lw	a4,8(a5)
    5c98:	09377663          	bgeu	a4,s3,5d24 <malloc+0xb8>
    5c9c:	f426                	sd	s1,40(sp)
    5c9e:	e852                	sd	s4,16(sp)
    5ca0:	e456                	sd	s5,8(sp)
    5ca2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5ca4:	8a4e                	mv	s4,s3
    5ca6:	6705                	lui	a4,0x1
    5ca8:	00e9f363          	bgeu	s3,a4,5cae <malloc+0x42>
    5cac:	6a05                	lui	s4,0x1
    5cae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cb2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5cb6:	00004497          	auipc	s1,0x4
    5cba:	81a48493          	addi	s1,s1,-2022 # 94d0 <freep>
  if (p == SBRK_ERROR)
    5cbe:	5afd                	li	s5,-1
    5cc0:	a83d                	j	5cfe <malloc+0x92>
    5cc2:	f426                	sd	s1,40(sp)
    5cc4:	e852                	sd	s4,16(sp)
    5cc6:	e456                	sd	s5,8(sp)
    5cc8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5cca:	0000a797          	auipc	a5,0xa
    5cce:	02e78793          	addi	a5,a5,46 # fcf8 <base>
    5cd2:	00003717          	auipc	a4,0x3
    5cd6:	7ef73f23          	sd	a5,2046(a4) # 94d0 <freep>
    5cda:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5cdc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5ce0:	b7d1                	j	5ca4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5ce2:	6398                	ld	a4,0(a5)
    5ce4:	e118                	sd	a4,0(a0)
    5ce6:	a899                	j	5d3c <malloc+0xd0>
  hp->s.size = nu;
    5ce8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5cec:	0541                	addi	a0,a0,16
    5cee:	ef9ff0ef          	jal	5be6 <free>
  return freep;
    5cf2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5cf4:	c125                	beqz	a0,5d54 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5cf6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5cf8:	4798                	lw	a4,8(a5)
    5cfa:	03277163          	bgeu	a4,s2,5d1c <malloc+0xb0>
    if (p == freep)
    5cfe:	6098                	ld	a4,0(s1)
    5d00:	853e                	mv	a0,a5
    5d02:	fef71ae3          	bne	a4,a5,5cf6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5d06:	8552                	mv	a0,s4
    5d08:	a37ff0ef          	jal	573e <sbrk>
  if (p == SBRK_ERROR)
    5d0c:	fd551ee3          	bne	a0,s5,5ce8 <malloc+0x7c>
        return 0;
    5d10:	4501                	li	a0,0
    5d12:	74a2                	ld	s1,40(sp)
    5d14:	6a42                	ld	s4,16(sp)
    5d16:	6aa2                	ld	s5,8(sp)
    5d18:	6b02                	ld	s6,0(sp)
    5d1a:	a03d                	j	5d48 <malloc+0xdc>
    5d1c:	74a2                	ld	s1,40(sp)
    5d1e:	6a42                	ld	s4,16(sp)
    5d20:	6aa2                	ld	s5,8(sp)
    5d22:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5d24:	fae90fe3          	beq	s2,a4,5ce2 <malloc+0x76>
        p->s.size -= nunits;
    5d28:	4137073b          	subw	a4,a4,s3
    5d2c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d2e:	02071693          	slli	a3,a4,0x20
    5d32:	01c6d713          	srli	a4,a3,0x1c
    5d36:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d38:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d3c:	00003717          	auipc	a4,0x3
    5d40:	78a73a23          	sd	a0,1940(a4) # 94d0 <freep>
      return (void *)(p + 1);
    5d44:	01078513          	addi	a0,a5,16
  }
}
    5d48:	70e2                	ld	ra,56(sp)
    5d4a:	7442                	ld	s0,48(sp)
    5d4c:	7902                	ld	s2,32(sp)
    5d4e:	69e2                	ld	s3,24(sp)
    5d50:	6121                	addi	sp,sp,64
    5d52:	8082                	ret
    5d54:	74a2                	ld	s1,40(sp)
    5d56:	6a42                	ld	s4,16(sp)
    5d58:	6aa2                	ld	s5,8(sp)
    5d5a:	6b02                	ld	s6,0(sp)
    5d5c:	b7f5                	j	5d48 <malloc+0xdc>
