
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
   * October 1988, p. 1195.
   */
  long hi, lo, x;

  /* Transform to [1, 0x7ffffffe] range. */
  x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
  hi = x / 127773;
  lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
  x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
  hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
  x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
  if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
    x += 0x7fffffff;
  /* Transform to [0, 0x7ffffffd] range. */
  x--;
      3e:	17fd                	addi	a5,a5,-1
  *ctx = x;
      40:	e11c                	sd	a5,0(a0)
  return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
    x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
  return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7159                	addi	sp,sp,-112
      76:	f486                	sd	ra,104(sp)
      78:	f0a2                	sd	s0,96(sp)
      7a:	eca6                	sd	s1,88(sp)
      7c:	fc56                	sd	s5,56(sp)
      7e:	1880                	addi	s0,sp,112
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	2bb000ef          	jal	b3e <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	16650513          	addi	a0,a0,358 # 11f0 <malloc+0x102>
      92:	349000ef          	jal	bda <mkdir>
  if (chdir("grindir") != 0) {
      96:	00001517          	auipc	a0,0x1
      9a:	15a50513          	addi	a0,a0,346 # 11f0 <malloc+0x102>
      9e:	345000ef          	jal	be2 <chdir>
      a2:	cd11                	beqz	a0,be <go+0x4a>
      a4:	e8ca                	sd	s2,80(sp)
      a6:	e4ce                	sd	s3,72(sp)
      a8:	e0d2                	sd	s4,64(sp)
      aa:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	14c50513          	addi	a0,a0,332 # 11f8 <malloc+0x10a>
      b4:	787000ef          	jal	103a <printf>
    exit(1);
      b8:	4505                	li	a0,1
      ba:	2b9000ef          	jal	b72 <exit>
      be:	e8ca                	sd	s2,80(sp)
      c0:	e4ce                	sd	s3,72(sp)
      c2:	e0d2                	sd	s4,64(sp)
      c4:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      c6:	00001517          	auipc	a0,0x1
      ca:	15a50513          	addi	a0,a0,346 # 1220 <malloc+0x132>
      ce:	315000ef          	jal	be2 <chdir>
      d2:	00001997          	auipc	s3,0x1
      d6:	15e98993          	addi	s3,s3,350 # 1230 <malloc+0x142>
      da:	c489                	beqz	s1,e4 <go+0x70>
      dc:	00001997          	auipc	s3,0x1
      e0:	14c98993          	addi	s3,s3,332 # 1228 <malloc+0x13a>
  uint64 iters = 0;
      e4:	4481                	li	s1,0
  int fd = -1;
      e6:	5a7d                	li	s4,-1
      e8:	00001917          	auipc	s2,0x1
      ec:	41890913          	addi	s2,s2,1048 # 1500 <malloc+0x412>
      f0:	a819                	j	106 <go+0x92>
    iters++;
    if ((iters % 500) == 0)
      write(1, which_child ? "B" : "A", 1);
    int what = rand() % 23;
    if (what == 1) {
      close(open("grindir/../a", O_CREATE | O_RDWR));
      f2:	20200593          	li	a1,514
      f6:	00001517          	auipc	a0,0x1
      fa:	14250513          	addi	a0,a0,322 # 1238 <malloc+0x14a>
      fe:	2b5000ef          	jal	bb2 <open>
     102:	299000ef          	jal	b9a <close>
    iters++;
     106:	0485                	addi	s1,s1,1
    if ((iters % 500) == 0)
     108:	1f400793          	li	a5,500
     10c:	02f4f7b3          	remu	a5,s1,a5
     110:	e791                	bnez	a5,11c <go+0xa8>
      write(1, which_child ? "B" : "A", 1);
     112:	4605                	li	a2,1
     114:	85ce                	mv	a1,s3
     116:	4505                	li	a0,1
     118:	27b000ef          	jal	b92 <write>
    int what = rand() % 23;
     11c:	f3dff0ef          	jal	58 <rand>
     120:	47dd                	li	a5,23
     122:	02f5653b          	remw	a0,a0,a5
     126:	0005071b          	sext.w	a4,a0
     12a:	47d9                	li	a5,22
     12c:	fce7ede3          	bltu	a5,a4,106 <go+0x92>
     130:	02051793          	slli	a5,a0,0x20
     134:	01e7d513          	srli	a0,a5,0x1e
     138:	954a                	add	a0,a0,s2
     13a:	411c                	lw	a5,0(a0)
     13c:	97ca                	add	a5,a5,s2
     13e:	8782                	jr	a5
    } else if (what == 2) {
      close(open("grindir/../grindir/../b", O_CREATE | O_RDWR));
     140:	20200593          	li	a1,514
     144:	00001517          	auipc	a0,0x1
     148:	10450513          	addi	a0,a0,260 # 1248 <malloc+0x15a>
     14c:	267000ef          	jal	bb2 <open>
     150:	24b000ef          	jal	b9a <close>
     154:	bf4d                	j	106 <go+0x92>
    } else if (what == 3) {
      unlink("grindir/../a");
     156:	00001517          	auipc	a0,0x1
     15a:	0e250513          	addi	a0,a0,226 # 1238 <malloc+0x14a>
     15e:	265000ef          	jal	bc2 <unlink>
     162:	b755                	j	106 <go+0x92>
    } else if (what == 4) {
      if (chdir("grindir") != 0) {
     164:	00001517          	auipc	a0,0x1
     168:	08c50513          	addi	a0,a0,140 # 11f0 <malloc+0x102>
     16c:	277000ef          	jal	be2 <chdir>
     170:	ed11                	bnez	a0,18c <go+0x118>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     172:	00001517          	auipc	a0,0x1
     176:	0ee50513          	addi	a0,a0,238 # 1260 <malloc+0x172>
     17a:	249000ef          	jal	bc2 <unlink>
      chdir("/");
     17e:	00001517          	auipc	a0,0x1
     182:	0a250513          	addi	a0,a0,162 # 1220 <malloc+0x132>
     186:	25d000ef          	jal	be2 <chdir>
     18a:	bfb5                	j	106 <go+0x92>
        printf("grind: chdir grindir failed\n");
     18c:	00001517          	auipc	a0,0x1
     190:	06c50513          	addi	a0,a0,108 # 11f8 <malloc+0x10a>
     194:	6a7000ef          	jal	103a <printf>
        exit(1);
     198:	4505                	li	a0,1
     19a:	1d9000ef          	jal	b72 <exit>
    } else if (what == 5) {
      close(fd);
     19e:	8552                	mv	a0,s4
     1a0:	1fb000ef          	jal	b9a <close>
      fd = open("/grindir/../a", O_CREATE | O_RDWR);
     1a4:	20200593          	li	a1,514
     1a8:	00001517          	auipc	a0,0x1
     1ac:	0c050513          	addi	a0,a0,192 # 1268 <malloc+0x17a>
     1b0:	203000ef          	jal	bb2 <open>
     1b4:	8a2a                	mv	s4,a0
     1b6:	bf81                	j	106 <go+0x92>
    } else if (what == 6) {
      close(fd);
     1b8:	8552                	mv	a0,s4
     1ba:	1e1000ef          	jal	b9a <close>
      fd = open("/./grindir/./../b", O_CREATE | O_RDWR);
     1be:	20200593          	li	a1,514
     1c2:	00001517          	auipc	a0,0x1
     1c6:	0b650513          	addi	a0,a0,182 # 1278 <malloc+0x18a>
     1ca:	1e9000ef          	jal	bb2 <open>
     1ce:	8a2a                	mv	s4,a0
     1d0:	bf1d                	j	106 <go+0x92>
    } else if (what == 7) {
      write(fd, buf, sizeof(buf));
     1d2:	3e700613          	li	a2,999
     1d6:	00002597          	auipc	a1,0x2
     1da:	e4a58593          	addi	a1,a1,-438 # 2020 <buf.0>
     1de:	8552                	mv	a0,s4
     1e0:	1b3000ef          	jal	b92 <write>
     1e4:	b70d                	j	106 <go+0x92>
    } else if (what == 8) {
      read(fd, buf, sizeof(buf));
     1e6:	3e700613          	li	a2,999
     1ea:	00002597          	auipc	a1,0x2
     1ee:	e3658593          	addi	a1,a1,-458 # 2020 <buf.0>
     1f2:	8552                	mv	a0,s4
     1f4:	197000ef          	jal	b8a <read>
     1f8:	b739                	j	106 <go+0x92>
    } else if (what == 9) {
      mkdir("grindir/../a");
     1fa:	00001517          	auipc	a0,0x1
     1fe:	03e50513          	addi	a0,a0,62 # 1238 <malloc+0x14a>
     202:	1d9000ef          	jal	bda <mkdir>
      close(open("a/../a/./a", O_CREATE | O_RDWR));
     206:	20200593          	li	a1,514
     20a:	00001517          	auipc	a0,0x1
     20e:	08650513          	addi	a0,a0,134 # 1290 <malloc+0x1a2>
     212:	1a1000ef          	jal	bb2 <open>
     216:	185000ef          	jal	b9a <close>
      unlink("a/a");
     21a:	00001517          	auipc	a0,0x1
     21e:	08650513          	addi	a0,a0,134 # 12a0 <malloc+0x1b2>
     222:	1a1000ef          	jal	bc2 <unlink>
     226:	b5c5                	j	106 <go+0x92>
    } else if (what == 10) {
      mkdir("/../b");
     228:	00001517          	auipc	a0,0x1
     22c:	08050513          	addi	a0,a0,128 # 12a8 <malloc+0x1ba>
     230:	1ab000ef          	jal	bda <mkdir>
      close(open("grindir/../b/b", O_CREATE | O_RDWR));
     234:	20200593          	li	a1,514
     238:	00001517          	auipc	a0,0x1
     23c:	07850513          	addi	a0,a0,120 # 12b0 <malloc+0x1c2>
     240:	173000ef          	jal	bb2 <open>
     244:	157000ef          	jal	b9a <close>
      unlink("b/b");
     248:	00001517          	auipc	a0,0x1
     24c:	07850513          	addi	a0,a0,120 # 12c0 <malloc+0x1d2>
     250:	173000ef          	jal	bc2 <unlink>
     254:	bd4d                	j	106 <go+0x92>
    } else if (what == 11) {
      unlink("b");
     256:	00001517          	auipc	a0,0x1
     25a:	07250513          	addi	a0,a0,114 # 12c8 <malloc+0x1da>
     25e:	165000ef          	jal	bc2 <unlink>
      link("../grindir/./../a", "../b");
     262:	00001597          	auipc	a1,0x1
     266:	ffe58593          	addi	a1,a1,-2 # 1260 <malloc+0x172>
     26a:	00001517          	auipc	a0,0x1
     26e:	06650513          	addi	a0,a0,102 # 12d0 <malloc+0x1e2>
     272:	161000ef          	jal	bd2 <link>
     276:	bd41                	j	106 <go+0x92>
    } else if (what == 12) {
      unlink("../grindir/../a");
     278:	00001517          	auipc	a0,0x1
     27c:	07050513          	addi	a0,a0,112 # 12e8 <malloc+0x1fa>
     280:	143000ef          	jal	bc2 <unlink>
      link(".././b", "/grindir/../a");
     284:	00001597          	auipc	a1,0x1
     288:	fe458593          	addi	a1,a1,-28 # 1268 <malloc+0x17a>
     28c:	00001517          	auipc	a0,0x1
     290:	06c50513          	addi	a0,a0,108 # 12f8 <malloc+0x20a>
     294:	13f000ef          	jal	bd2 <link>
     298:	b5bd                	j	106 <go+0x92>
    } else if (what == 13) {
      int pid = fork();
     29a:	0d1000ef          	jal	b6a <fork>
      if (pid == 0) {
     29e:	c519                	beqz	a0,2ac <go+0x238>
        exit(0);
      } else if (pid < 0) {
     2a0:	00054863          	bltz	a0,2b0 <go+0x23c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a4:	4501                	li	a0,0
     2a6:	0d5000ef          	jal	b7a <wait>
     2aa:	bdb1                	j	106 <go+0x92>
        exit(0);
     2ac:	0c7000ef          	jal	b72 <exit>
        printf("grind: fork failed\n");
     2b0:	00001517          	auipc	a0,0x1
     2b4:	05050513          	addi	a0,a0,80 # 1300 <malloc+0x212>
     2b8:	583000ef          	jal	103a <printf>
        exit(1);
     2bc:	4505                	li	a0,1
     2be:	0b5000ef          	jal	b72 <exit>
    } else if (what == 14) {
      int pid = fork();
     2c2:	0a9000ef          	jal	b6a <fork>
      if (pid == 0) {
     2c6:	c519                	beqz	a0,2d4 <go+0x260>
        fork();
        fork();
        exit(0);
      } else if (pid < 0) {
     2c8:	00054d63          	bltz	a0,2e2 <go+0x26e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2cc:	4501                	li	a0,0
     2ce:	0ad000ef          	jal	b7a <wait>
     2d2:	bd15                	j	106 <go+0x92>
        fork();
     2d4:	097000ef          	jal	b6a <fork>
        fork();
     2d8:	093000ef          	jal	b6a <fork>
        exit(0);
     2dc:	4501                	li	a0,0
     2de:	095000ef          	jal	b72 <exit>
        printf("grind: fork failed\n");
     2e2:	00001517          	auipc	a0,0x1
     2e6:	01e50513          	addi	a0,a0,30 # 1300 <malloc+0x212>
     2ea:	551000ef          	jal	103a <printf>
        exit(1);
     2ee:	4505                	li	a0,1
     2f0:	083000ef          	jal	b72 <exit>
    } else if (what == 15) {
      sbrk(6011);
     2f4:	6505                	lui	a0,0x1
     2f6:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x21b>
     2fa:	045000ef          	jal	b3e <sbrk>
     2fe:	b521                	j	106 <go+0x92>
    } else if (what == 16) {
      if (sbrk(0) > break0)
     300:	4501                	li	a0,0
     302:	03d000ef          	jal	b3e <sbrk>
     306:	e0aaf0e3          	bgeu	s5,a0,106 <go+0x92>
        sbrk(-(sbrk(0) - break0));
     30a:	4501                	li	a0,0
     30c:	033000ef          	jal	b3e <sbrk>
     310:	40aa853b          	subw	a0,s5,a0
     314:	02b000ef          	jal	b3e <sbrk>
     318:	b3fd                	j	106 <go+0x92>
    } else if (what == 17) {
      int pid = fork();
     31a:	051000ef          	jal	b6a <fork>
     31e:	8b2a                	mv	s6,a0
      if (pid == 0) {
     320:	c10d                	beqz	a0,342 <go+0x2ce>
        close(open("a", O_CREATE | O_RDWR));
        exit(0);
      } else if (pid < 0) {
     322:	02054d63          	bltz	a0,35c <go+0x2e8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if (chdir("../grindir/..") != 0) {
     326:	00001517          	auipc	a0,0x1
     32a:	ffa50513          	addi	a0,a0,-6 # 1320 <malloc+0x232>
     32e:	0b5000ef          	jal	be2 <chdir>
     332:	ed15                	bnez	a0,36e <go+0x2fa>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     334:	855a                	mv	a0,s6
     336:	06d000ef          	jal	ba2 <kill>
      wait(0);
     33a:	4501                	li	a0,0
     33c:	03f000ef          	jal	b7a <wait>
     340:	b3d9                	j	106 <go+0x92>
        close(open("a", O_CREATE | O_RDWR));
     342:	20200593          	li	a1,514
     346:	00001517          	auipc	a0,0x1
     34a:	fd250513          	addi	a0,a0,-46 # 1318 <malloc+0x22a>
     34e:	065000ef          	jal	bb2 <open>
     352:	049000ef          	jal	b9a <close>
        exit(0);
     356:	4501                	li	a0,0
     358:	01b000ef          	jal	b72 <exit>
        printf("grind: fork failed\n");
     35c:	00001517          	auipc	a0,0x1
     360:	fa450513          	addi	a0,a0,-92 # 1300 <malloc+0x212>
     364:	4d7000ef          	jal	103a <printf>
        exit(1);
     368:	4505                	li	a0,1
     36a:	009000ef          	jal	b72 <exit>
        printf("grind: chdir failed\n");
     36e:	00001517          	auipc	a0,0x1
     372:	fc250513          	addi	a0,a0,-62 # 1330 <malloc+0x242>
     376:	4c5000ef          	jal	103a <printf>
        exit(1);
     37a:	4505                	li	a0,1
     37c:	7f6000ef          	jal	b72 <exit>
    } else if (what == 18) {
      int pid = fork();
     380:	7ea000ef          	jal	b6a <fork>
      if (pid == 0) {
     384:	c519                	beqz	a0,392 <go+0x31e>
        kill(getpid());
        exit(0);
      } else if (pid < 0) {
     386:	00054d63          	bltz	a0,3a0 <go+0x32c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38a:	4501                	li	a0,0
     38c:	7ee000ef          	jal	b7a <wait>
     390:	bb9d                	j	106 <go+0x92>
        kill(getpid());
     392:	061000ef          	jal	bf2 <getpid>
     396:	00d000ef          	jal	ba2 <kill>
        exit(0);
     39a:	4501                	li	a0,0
     39c:	7d6000ef          	jal	b72 <exit>
        printf("grind: fork failed\n");
     3a0:	00001517          	auipc	a0,0x1
     3a4:	f6050513          	addi	a0,a0,-160 # 1300 <malloc+0x212>
     3a8:	493000ef          	jal	103a <printf>
        exit(1);
     3ac:	4505                	li	a0,1
     3ae:	7c4000ef          	jal	b72 <exit>
    } else if (what == 19) {
      int fds[2];
      if (pipe(fds) < 0) {
     3b2:	fa840513          	addi	a0,s0,-88
     3b6:	7cc000ef          	jal	b82 <pipe>
     3ba:	02054363          	bltz	a0,3e0 <go+0x36c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3be:	7ac000ef          	jal	b6a <fork>
      if (pid == 0) {
     3c2:	c905                	beqz	a0,3f2 <go+0x37e>
          printf("grind: pipe write failed\n");
        char c;
        if (read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if (pid < 0) {
     3c4:	08054263          	bltz	a0,448 <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3c8:	fa842503          	lw	a0,-88(s0)
     3cc:	7ce000ef          	jal	b9a <close>
      close(fds[1]);
     3d0:	fac42503          	lw	a0,-84(s0)
     3d4:	7c6000ef          	jal	b9a <close>
      wait(0);
     3d8:	4501                	li	a0,0
     3da:	7a0000ef          	jal	b7a <wait>
     3de:	b325                	j	106 <go+0x92>
        printf("grind: pipe failed\n");
     3e0:	00001517          	auipc	a0,0x1
     3e4:	f6850513          	addi	a0,a0,-152 # 1348 <malloc+0x25a>
     3e8:	453000ef          	jal	103a <printf>
        exit(1);
     3ec:	4505                	li	a0,1
     3ee:	784000ef          	jal	b72 <exit>
        fork();
     3f2:	778000ef          	jal	b6a <fork>
        fork();
     3f6:	774000ef          	jal	b6a <fork>
        if (write(fds[1], "x", 1) != 1)
     3fa:	4605                	li	a2,1
     3fc:	00001597          	auipc	a1,0x1
     400:	f6458593          	addi	a1,a1,-156 # 1360 <malloc+0x272>
     404:	fac42503          	lw	a0,-84(s0)
     408:	78a000ef          	jal	b92 <write>
     40c:	4785                	li	a5,1
     40e:	00f51f63          	bne	a0,a5,42c <go+0x3b8>
        if (read(fds[0], &c, 1) != 1)
     412:	4605                	li	a2,1
     414:	fa040593          	addi	a1,s0,-96
     418:	fa842503          	lw	a0,-88(s0)
     41c:	76e000ef          	jal	b8a <read>
     420:	4785                	li	a5,1
     422:	00f51c63          	bne	a0,a5,43a <go+0x3c6>
        exit(0);
     426:	4501                	li	a0,0
     428:	74a000ef          	jal	b72 <exit>
          printf("grind: pipe write failed\n");
     42c:	00001517          	auipc	a0,0x1
     430:	f3c50513          	addi	a0,a0,-196 # 1368 <malloc+0x27a>
     434:	407000ef          	jal	103a <printf>
     438:	bfe9                	j	412 <go+0x39e>
          printf("grind: pipe read failed\n");
     43a:	00001517          	auipc	a0,0x1
     43e:	f4e50513          	addi	a0,a0,-178 # 1388 <malloc+0x29a>
     442:	3f9000ef          	jal	103a <printf>
     446:	b7c5                	j	426 <go+0x3b2>
        printf("grind: fork failed\n");
     448:	00001517          	auipc	a0,0x1
     44c:	eb850513          	addi	a0,a0,-328 # 1300 <malloc+0x212>
     450:	3eb000ef          	jal	103a <printf>
        exit(1);
     454:	4505                	li	a0,1
     456:	71c000ef          	jal	b72 <exit>
    } else if (what == 20) {
      int pid = fork();
     45a:	710000ef          	jal	b6a <fork>
      if (pid == 0) {
     45e:	c519                	beqz	a0,46c <go+0x3f8>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE | O_RDWR);
        unlink("x");
        exit(0);
      } else if (pid < 0) {
     460:	04054f63          	bltz	a0,4be <go+0x44a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     464:	4501                	li	a0,0
     466:	714000ef          	jal	b7a <wait>
     46a:	b971                	j	106 <go+0x92>
        unlink("a");
     46c:	00001517          	auipc	a0,0x1
     470:	eac50513          	addi	a0,a0,-340 # 1318 <malloc+0x22a>
     474:	74e000ef          	jal	bc2 <unlink>
        mkdir("a");
     478:	00001517          	auipc	a0,0x1
     47c:	ea050513          	addi	a0,a0,-352 # 1318 <malloc+0x22a>
     480:	75a000ef          	jal	bda <mkdir>
        chdir("a");
     484:	00001517          	auipc	a0,0x1
     488:	e9450513          	addi	a0,a0,-364 # 1318 <malloc+0x22a>
     48c:	756000ef          	jal	be2 <chdir>
        unlink("../a");
     490:	00001517          	auipc	a0,0x1
     494:	f1850513          	addi	a0,a0,-232 # 13a8 <malloc+0x2ba>
     498:	72a000ef          	jal	bc2 <unlink>
        fd = open("x", O_CREATE | O_RDWR);
     49c:	20200593          	li	a1,514
     4a0:	00001517          	auipc	a0,0x1
     4a4:	ec050513          	addi	a0,a0,-320 # 1360 <malloc+0x272>
     4a8:	70a000ef          	jal	bb2 <open>
        unlink("x");
     4ac:	00001517          	auipc	a0,0x1
     4b0:	eb450513          	addi	a0,a0,-332 # 1360 <malloc+0x272>
     4b4:	70e000ef          	jal	bc2 <unlink>
        exit(0);
     4b8:	4501                	li	a0,0
     4ba:	6b8000ef          	jal	b72 <exit>
        printf("grind: fork failed\n");
     4be:	00001517          	auipc	a0,0x1
     4c2:	e4250513          	addi	a0,a0,-446 # 1300 <malloc+0x212>
     4c6:	375000ef          	jal	103a <printf>
        exit(1);
     4ca:	4505                	li	a0,1
     4cc:	6a6000ef          	jal	b72 <exit>
    } else if (what == 21) {
      unlink("c");
     4d0:	00001517          	auipc	a0,0x1
     4d4:	ee050513          	addi	a0,a0,-288 # 13b0 <malloc+0x2c2>
     4d8:	6ea000ef          	jal	bc2 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE | O_RDWR);
     4dc:	20200593          	li	a1,514
     4e0:	00001517          	auipc	a0,0x1
     4e4:	ed050513          	addi	a0,a0,-304 # 13b0 <malloc+0x2c2>
     4e8:	6ca000ef          	jal	bb2 <open>
     4ec:	8b2a                	mv	s6,a0
      if (fd1 < 0) {
     4ee:	04054763          	bltz	a0,53c <go+0x4c8>
        printf("grind: create c failed\n");
        exit(1);
      }
      if (write(fd1, "x", 1) != 1) {
     4f2:	4605                	li	a2,1
     4f4:	00001597          	auipc	a1,0x1
     4f8:	e6c58593          	addi	a1,a1,-404 # 1360 <malloc+0x272>
     4fc:	696000ef          	jal	b92 <write>
     500:	4785                	li	a5,1
     502:	04f51663          	bne	a0,a5,54e <go+0x4da>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if (fstat(fd1, &st) != 0) {
     506:	fa840593          	addi	a1,s0,-88
     50a:	855a                	mv	a0,s6
     50c:	6be000ef          	jal	bca <fstat>
     510:	e921                	bnez	a0,560 <go+0x4ec>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if (st.size != 1) {
     512:	fb843583          	ld	a1,-72(s0)
     516:	4785                	li	a5,1
     518:	04f59d63          	bne	a1,a5,572 <go+0x4fe>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if (st.ino > 200) {
     51c:	fac42583          	lw	a1,-84(s0)
     520:	0c800793          	li	a5,200
     524:	06b7e163          	bltu	a5,a1,586 <go+0x512>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     528:	855a                	mv	a0,s6
     52a:	670000ef          	jal	b9a <close>
      unlink("c");
     52e:	00001517          	auipc	a0,0x1
     532:	e8250513          	addi	a0,a0,-382 # 13b0 <malloc+0x2c2>
     536:	68c000ef          	jal	bc2 <unlink>
     53a:	b6f1                	j	106 <go+0x92>
        printf("grind: create c failed\n");
     53c:	00001517          	auipc	a0,0x1
     540:	e7c50513          	addi	a0,a0,-388 # 13b8 <malloc+0x2ca>
     544:	2f7000ef          	jal	103a <printf>
        exit(1);
     548:	4505                	li	a0,1
     54a:	628000ef          	jal	b72 <exit>
        printf("grind: write c failed\n");
     54e:	00001517          	auipc	a0,0x1
     552:	e8250513          	addi	a0,a0,-382 # 13d0 <malloc+0x2e2>
     556:	2e5000ef          	jal	103a <printf>
        exit(1);
     55a:	4505                	li	a0,1
     55c:	616000ef          	jal	b72 <exit>
        printf("grind: fstat failed\n");
     560:	00001517          	auipc	a0,0x1
     564:	e8850513          	addi	a0,a0,-376 # 13e8 <malloc+0x2fa>
     568:	2d3000ef          	jal	103a <printf>
        exit(1);
     56c:	4505                	li	a0,1
     56e:	604000ef          	jal	b72 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     572:	2581                	sext.w	a1,a1
     574:	00001517          	auipc	a0,0x1
     578:	e8c50513          	addi	a0,a0,-372 # 1400 <malloc+0x312>
     57c:	2bf000ef          	jal	103a <printf>
        exit(1);
     580:	4505                	li	a0,1
     582:	5f0000ef          	jal	b72 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     586:	00001517          	auipc	a0,0x1
     58a:	ea250513          	addi	a0,a0,-350 # 1428 <malloc+0x33a>
     58e:	2ad000ef          	jal	103a <printf>
        exit(1);
     592:	4505                	li	a0,1
     594:	5de000ef          	jal	b72 <exit>
    } else if (what == 22) {
      // echo hi | cat
      int aa[2], bb[2];
      if (pipe(aa) < 0) {
     598:	f9840513          	addi	a0,s0,-104
     59c:	5e6000ef          	jal	b82 <pipe>
     5a0:	0c054263          	bltz	a0,664 <go+0x5f0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if (pipe(bb) < 0) {
     5a4:	fa040513          	addi	a0,s0,-96
     5a8:	5da000ef          	jal	b82 <pipe>
     5ac:	0c054663          	bltz	a0,678 <go+0x604>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b0:	5ba000ef          	jal	b6a <fork>
      if (pid1 == 0) {
     5b4:	0c050c63          	beqz	a0,68c <go+0x618>
        close(aa[1]);
        char *args[3] = {"echo", "hi", 0};
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if (pid1 < 0) {
     5b8:	14054e63          	bltz	a0,714 <go+0x6a0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5bc:	5ae000ef          	jal	b6a <fork>
      if (pid2 == 0) {
     5c0:	16050463          	beqz	a0,728 <go+0x6b4>
        close(bb[1]);
        char *args[2] = {"cat", 0};
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if (pid2 < 0) {
     5c4:	20054263          	bltz	a0,7c8 <go+0x754>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5c8:	f9842503          	lw	a0,-104(s0)
     5cc:	5ce000ef          	jal	b9a <close>
      close(aa[1]);
     5d0:	f9c42503          	lw	a0,-100(s0)
     5d4:	5c6000ef          	jal	b9a <close>
      close(bb[1]);
     5d8:	fa442503          	lw	a0,-92(s0)
     5dc:	5be000ef          	jal	b9a <close>
      char buf[4] = {0, 0, 0, 0};
     5e0:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf + 0, 1);
     5e4:	4605                	li	a2,1
     5e6:	f9040593          	addi	a1,s0,-112
     5ea:	fa042503          	lw	a0,-96(s0)
     5ee:	59c000ef          	jal	b8a <read>
      read(bb[0], buf + 1, 1);
     5f2:	4605                	li	a2,1
     5f4:	f9140593          	addi	a1,s0,-111
     5f8:	fa042503          	lw	a0,-96(s0)
     5fc:	58e000ef          	jal	b8a <read>
      read(bb[0], buf + 2, 1);
     600:	4605                	li	a2,1
     602:	f9240593          	addi	a1,s0,-110
     606:	fa042503          	lw	a0,-96(s0)
     60a:	580000ef          	jal	b8a <read>
      close(bb[0]);
     60e:	fa042503          	lw	a0,-96(s0)
     612:	588000ef          	jal	b9a <close>
      int st1, st2;
      wait(&st1);
     616:	f9440513          	addi	a0,s0,-108
     61a:	560000ef          	jal	b7a <wait>
      wait(&st2);
     61e:	fa840513          	addi	a0,s0,-88
     622:	558000ef          	jal	b7a <wait>
      if (st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0) {
     626:	f9442783          	lw	a5,-108(s0)
     62a:	fa842703          	lw	a4,-88(s0)
     62e:	8fd9                	or	a5,a5,a4
     630:	eb99                	bnez	a5,646 <go+0x5d2>
     632:	00001597          	auipc	a1,0x1
     636:	e9658593          	addi	a1,a1,-362 # 14c8 <malloc+0x3da>
     63a:	f9040513          	addi	a0,s0,-112
     63e:	2cc000ef          	jal	90a <strcmp>
     642:	ac0502e3          	beqz	a0,106 <go+0x92>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     646:	f9040693          	addi	a3,s0,-112
     64a:	fa842603          	lw	a2,-88(s0)
     64e:	f9442583          	lw	a1,-108(s0)
     652:	00001517          	auipc	a0,0x1
     656:	e7e50513          	addi	a0,a0,-386 # 14d0 <malloc+0x3e2>
     65a:	1e1000ef          	jal	103a <printf>
        exit(1);
     65e:	4505                	li	a0,1
     660:	512000ef          	jal	b72 <exit>
        fprintf(2, "grind: pipe failed\n");
     664:	00001597          	auipc	a1,0x1
     668:	ce458593          	addi	a1,a1,-796 # 1348 <malloc+0x25a>
     66c:	4509                	li	a0,2
     66e:	1a3000ef          	jal	1010 <fprintf>
        exit(1);
     672:	4505                	li	a0,1
     674:	4fe000ef          	jal	b72 <exit>
        fprintf(2, "grind: pipe failed\n");
     678:	00001597          	auipc	a1,0x1
     67c:	cd058593          	addi	a1,a1,-816 # 1348 <malloc+0x25a>
     680:	4509                	li	a0,2
     682:	18f000ef          	jal	1010 <fprintf>
        exit(1);
     686:	4505                	li	a0,1
     688:	4ea000ef          	jal	b72 <exit>
        close(bb[0]);
     68c:	fa042503          	lw	a0,-96(s0)
     690:	50a000ef          	jal	b9a <close>
        close(bb[1]);
     694:	fa442503          	lw	a0,-92(s0)
     698:	502000ef          	jal	b9a <close>
        close(aa[0]);
     69c:	f9842503          	lw	a0,-104(s0)
     6a0:	4fa000ef          	jal	b9a <close>
        close(1);
     6a4:	4505                	li	a0,1
     6a6:	4f4000ef          	jal	b9a <close>
        if (dup(aa[1]) != 1) {
     6aa:	f9c42503          	lw	a0,-100(s0)
     6ae:	53c000ef          	jal	bea <dup>
     6b2:	4785                	li	a5,1
     6b4:	00f50c63          	beq	a0,a5,6cc <go+0x658>
          fprintf(2, "grind: dup failed\n");
     6b8:	00001597          	auipc	a1,0x1
     6bc:	d9858593          	addi	a1,a1,-616 # 1450 <malloc+0x362>
     6c0:	4509                	li	a0,2
     6c2:	14f000ef          	jal	1010 <fprintf>
          exit(1);
     6c6:	4505                	li	a0,1
     6c8:	4aa000ef          	jal	b72 <exit>
        close(aa[1]);
     6cc:	f9c42503          	lw	a0,-100(s0)
     6d0:	4ca000ef          	jal	b9a <close>
        char *args[3] = {"echo", "hi", 0};
     6d4:	00001797          	auipc	a5,0x1
     6d8:	d9478793          	addi	a5,a5,-620 # 1468 <malloc+0x37a>
     6dc:	faf43423          	sd	a5,-88(s0)
     6e0:	00001797          	auipc	a5,0x1
     6e4:	d9078793          	addi	a5,a5,-624 # 1470 <malloc+0x382>
     6e8:	faf43823          	sd	a5,-80(s0)
     6ec:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     6f0:	fa840593          	addi	a1,s0,-88
     6f4:	00001517          	auipc	a0,0x1
     6f8:	d8450513          	addi	a0,a0,-636 # 1478 <malloc+0x38a>
     6fc:	4ae000ef          	jal	baa <exec>
        fprintf(2, "grind: echo: not found\n");
     700:	00001597          	auipc	a1,0x1
     704:	d8858593          	addi	a1,a1,-632 # 1488 <malloc+0x39a>
     708:	4509                	li	a0,2
     70a:	107000ef          	jal	1010 <fprintf>
        exit(2);
     70e:	4509                	li	a0,2
     710:	462000ef          	jal	b72 <exit>
        fprintf(2, "grind: fork failed\n");
     714:	00001597          	auipc	a1,0x1
     718:	bec58593          	addi	a1,a1,-1044 # 1300 <malloc+0x212>
     71c:	4509                	li	a0,2
     71e:	0f3000ef          	jal	1010 <fprintf>
        exit(3);
     722:	450d                	li	a0,3
     724:	44e000ef          	jal	b72 <exit>
        close(aa[1]);
     728:	f9c42503          	lw	a0,-100(s0)
     72c:	46e000ef          	jal	b9a <close>
        close(bb[0]);
     730:	fa042503          	lw	a0,-96(s0)
     734:	466000ef          	jal	b9a <close>
        close(0);
     738:	4501                	li	a0,0
     73a:	460000ef          	jal	b9a <close>
        if (dup(aa[0]) != 0) {
     73e:	f9842503          	lw	a0,-104(s0)
     742:	4a8000ef          	jal	bea <dup>
     746:	c919                	beqz	a0,75c <go+0x6e8>
          fprintf(2, "grind: dup failed\n");
     748:	00001597          	auipc	a1,0x1
     74c:	d0858593          	addi	a1,a1,-760 # 1450 <malloc+0x362>
     750:	4509                	li	a0,2
     752:	0bf000ef          	jal	1010 <fprintf>
          exit(4);
     756:	4511                	li	a0,4
     758:	41a000ef          	jal	b72 <exit>
        close(aa[0]);
     75c:	f9842503          	lw	a0,-104(s0)
     760:	43a000ef          	jal	b9a <close>
        close(1);
     764:	4505                	li	a0,1
     766:	434000ef          	jal	b9a <close>
        if (dup(bb[1]) != 1) {
     76a:	fa442503          	lw	a0,-92(s0)
     76e:	47c000ef          	jal	bea <dup>
     772:	4785                	li	a5,1
     774:	00f50c63          	beq	a0,a5,78c <go+0x718>
          fprintf(2, "grind: dup failed\n");
     778:	00001597          	auipc	a1,0x1
     77c:	cd858593          	addi	a1,a1,-808 # 1450 <malloc+0x362>
     780:	4509                	li	a0,2
     782:	08f000ef          	jal	1010 <fprintf>
          exit(5);
     786:	4515                	li	a0,5
     788:	3ea000ef          	jal	b72 <exit>
        close(bb[1]);
     78c:	fa442503          	lw	a0,-92(s0)
     790:	40a000ef          	jal	b9a <close>
        char *args[2] = {"cat", 0};
     794:	00001797          	auipc	a5,0x1
     798:	d0c78793          	addi	a5,a5,-756 # 14a0 <malloc+0x3b2>
     79c:	faf43423          	sd	a5,-88(s0)
     7a0:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     7a4:	fa840593          	addi	a1,s0,-88
     7a8:	00001517          	auipc	a0,0x1
     7ac:	d0050513          	addi	a0,a0,-768 # 14a8 <malloc+0x3ba>
     7b0:	3fa000ef          	jal	baa <exec>
        fprintf(2, "grind: cat: not found\n");
     7b4:	00001597          	auipc	a1,0x1
     7b8:	cfc58593          	addi	a1,a1,-772 # 14b0 <malloc+0x3c2>
     7bc:	4509                	li	a0,2
     7be:	053000ef          	jal	1010 <fprintf>
        exit(6);
     7c2:	4519                	li	a0,6
     7c4:	3ae000ef          	jal	b72 <exit>
        fprintf(2, "grind: fork failed\n");
     7c8:	00001597          	auipc	a1,0x1
     7cc:	b3858593          	addi	a1,a1,-1224 # 1300 <malloc+0x212>
     7d0:	4509                	li	a0,2
     7d2:	03f000ef          	jal	1010 <fprintf>
        exit(7);
     7d6:	451d                	li	a0,7
     7d8:	39a000ef          	jal	b72 <exit>

00000000000007dc <iter>:
  }
}

void
iter()
{
     7dc:	7179                	addi	sp,sp,-48
     7de:	f406                	sd	ra,40(sp)
     7e0:	f022                	sd	s0,32(sp)
     7e2:	1800                	addi	s0,sp,48
  unlink("a");
     7e4:	00001517          	auipc	a0,0x1
     7e8:	b3450513          	addi	a0,a0,-1228 # 1318 <malloc+0x22a>
     7ec:	3d6000ef          	jal	bc2 <unlink>
  unlink("b");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	ad850513          	addi	a0,a0,-1320 # 12c8 <malloc+0x1da>
     7f8:	3ca000ef          	jal	bc2 <unlink>

  int pid1 = fork();
     7fc:	36e000ef          	jal	b6a <fork>
  if (pid1 < 0) {
     800:	02054163          	bltz	a0,822 <iter+0x46>
     804:	ec26                	sd	s1,24(sp)
     806:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid1 == 0) {
     808:	e905                	bnez	a0,838 <iter+0x5c>
     80a:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     80c:	00001717          	auipc	a4,0x1
     810:	7f470713          	addi	a4,a4,2036 # 2000 <rand_next>
     814:	631c                	ld	a5,0(a4)
     816:	01f7c793          	xori	a5,a5,31
     81a:	e31c                	sd	a5,0(a4)
    go(0);
     81c:	4501                	li	a0,0
     81e:	857ff0ef          	jal	74 <go>
     822:	ec26                	sd	s1,24(sp)
     824:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     826:	00001517          	auipc	a0,0x1
     82a:	ada50513          	addi	a0,a0,-1318 # 1300 <malloc+0x212>
     82e:	00d000ef          	jal	103a <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	33e000ef          	jal	b72 <exit>
     838:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     83a:	330000ef          	jal	b6a <fork>
     83e:	892a                	mv	s2,a0
  if (pid2 < 0) {
     840:	02054063          	bltz	a0,860 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid2 == 0) {
     844:	e51d                	bnez	a0,872 <iter+0x96>
    rand_next ^= 7177;
     846:	00001697          	auipc	a3,0x1
     84a:	7ba68693          	addi	a3,a3,1978 # 2000 <rand_next>
     84e:	629c                	ld	a5,0(a3)
     850:	6709                	lui	a4,0x2
     852:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x6a9>
     856:	8fb9                	xor	a5,a5,a4
     858:	e29c                	sd	a5,0(a3)
    go(1);
     85a:	4505                	li	a0,1
     85c:	819ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     860:	00001517          	auipc	a0,0x1
     864:	aa050513          	addi	a0,a0,-1376 # 1300 <malloc+0x212>
     868:	7d2000ef          	jal	103a <printf>
    exit(1);
     86c:	4505                	li	a0,1
     86e:	304000ef          	jal	b72 <exit>
    exit(0);
  }

  int st1 = -1;
     872:	57fd                	li	a5,-1
     874:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     878:	fdc40513          	addi	a0,s0,-36
     87c:	2fe000ef          	jal	b7a <wait>
  if (st1 != 0) {
     880:	fdc42783          	lw	a5,-36(s0)
     884:	eb99                	bnez	a5,89a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     886:	57fd                	li	a5,-1
     888:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     88c:	fd840513          	addi	a0,s0,-40
     890:	2ea000ef          	jal	b7a <wait>

  exit(0);
     894:	4501                	li	a0,0
     896:	2dc000ef          	jal	b72 <exit>
    kill(pid1);
     89a:	8526                	mv	a0,s1
     89c:	306000ef          	jal	ba2 <kill>
    kill(pid2);
     8a0:	854a                	mv	a0,s2
     8a2:	300000ef          	jal	ba2 <kill>
     8a6:	b7c5                	j	886 <iter+0xaa>

00000000000008a8 <main>:
}

int
main()
{
     8a8:	1101                	addi	sp,sp,-32
     8aa:	ec06                	sd	ra,24(sp)
     8ac:	e822                	sd	s0,16(sp)
     8ae:	e426                	sd	s1,8(sp)
     8b0:	1000                	addi	s0,sp,32
    }
    if (pid > 0) {
      wait(0);
    }
    pause(20);
    rand_next += 1;
     8b2:	00001497          	auipc	s1,0x1
     8b6:	74e48493          	addi	s1,s1,1870 # 2000 <rand_next>
     8ba:	a809                	j	8cc <main+0x24>
      iter();
     8bc:	f21ff0ef          	jal	7dc <iter>
    pause(20);
     8c0:	4551                	li	a0,20
     8c2:	340000ef          	jal	c02 <pause>
    rand_next += 1;
     8c6:	609c                	ld	a5,0(s1)
     8c8:	0785                	addi	a5,a5,1
     8ca:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8cc:	29e000ef          	jal	b6a <fork>
    if (pid == 0) {
     8d0:	d575                	beqz	a0,8bc <main+0x14>
    if (pid > 0) {
     8d2:	fea057e3          	blez	a0,8c0 <main+0x18>
      wait(0);
     8d6:	4501                	li	a0,0
     8d8:	2a2000ef          	jal	b7a <wait>
     8dc:	b7d5                	j	8c0 <main+0x18>

00000000000008de <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     8de:	1141                	addi	sp,sp,-16
     8e0:	e406                	sd	ra,8(sp)
     8e2:	e022                	sd	s0,0(sp)
     8e4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     8e6:	fc3ff0ef          	jal	8a8 <main>
  exit(r);
     8ea:	288000ef          	jal	b72 <exit>

00000000000008ee <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     8ee:	1141                	addi	sp,sp,-16
     8f0:	e422                	sd	s0,8(sp)
     8f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
     8f4:	87aa                	mv	a5,a0
     8f6:	0585                	addi	a1,a1,1
     8f8:	0785                	addi	a5,a5,1
     8fa:	fff5c703          	lbu	a4,-1(a1)
     8fe:	fee78fa3          	sb	a4,-1(a5)
     902:	fb75                	bnez	a4,8f6 <strcpy+0x8>
    ;
  return os;
}
     904:	6422                	ld	s0,8(sp)
     906:	0141                	addi	sp,sp,16
     908:	8082                	ret

000000000000090a <strcmp>:

int
strcmp(const char *p, const char *q)
{
     90a:	1141                	addi	sp,sp,-16
     90c:	e422                	sd	s0,8(sp)
     90e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
     910:	00054783          	lbu	a5,0(a0)
     914:	cb91                	beqz	a5,928 <strcmp+0x1e>
     916:	0005c703          	lbu	a4,0(a1)
     91a:	00f71763          	bne	a4,a5,928 <strcmp+0x1e>
    p++, q++;
     91e:	0505                	addi	a0,a0,1
     920:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
     922:	00054783          	lbu	a5,0(a0)
     926:	fbe5                	bnez	a5,916 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     928:	0005c503          	lbu	a0,0(a1)
}
     92c:	40a7853b          	subw	a0,a5,a0
     930:	6422                	ld	s0,8(sp)
     932:	0141                	addi	sp,sp,16
     934:	8082                	ret

0000000000000936 <strlen>:

uint
strlen(const char *s)
{
     936:	1141                	addi	sp,sp,-16
     938:	e422                	sd	s0,8(sp)
     93a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
     93c:	00054783          	lbu	a5,0(a0)
     940:	cf91                	beqz	a5,95c <strlen+0x26>
     942:	0505                	addi	a0,a0,1
     944:	87aa                	mv	a5,a0
     946:	86be                	mv	a3,a5
     948:	0785                	addi	a5,a5,1
     94a:	fff7c703          	lbu	a4,-1(a5)
     94e:	ff65                	bnez	a4,946 <strlen+0x10>
     950:	40a6853b          	subw	a0,a3,a0
     954:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     956:	6422                	ld	s0,8(sp)
     958:	0141                	addi	sp,sp,16
     95a:	8082                	ret
  for (n = 0; s[n]; n++)
     95c:	4501                	li	a0,0
     95e:	bfe5                	j	956 <strlen+0x20>

0000000000000960 <memset>:

void *
memset(void *dst, int c, uint n)
{
     960:	1141                	addi	sp,sp,-16
     962:	e422                	sd	s0,8(sp)
     964:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     966:	ca19                	beqz	a2,97c <memset+0x1c>
     968:	87aa                	mv	a5,a0
     96a:	1602                	slli	a2,a2,0x20
     96c:	9201                	srli	a2,a2,0x20
     96e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     972:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     976:	0785                	addi	a5,a5,1
     978:	fee79de3          	bne	a5,a4,972 <memset+0x12>
  }
  return dst;
}
     97c:	6422                	ld	s0,8(sp)
     97e:	0141                	addi	sp,sp,16
     980:	8082                	ret

0000000000000982 <strchr>:

char *
strchr(const char *s, char c)
{
     982:	1141                	addi	sp,sp,-16
     984:	e422                	sd	s0,8(sp)
     986:	0800                	addi	s0,sp,16
  for (; *s; s++)
     988:	00054783          	lbu	a5,0(a0)
     98c:	cb99                	beqz	a5,9a2 <strchr+0x20>
    if (*s == c)
     98e:	00f58763          	beq	a1,a5,99c <strchr+0x1a>
  for (; *s; s++)
     992:	0505                	addi	a0,a0,1
     994:	00054783          	lbu	a5,0(a0)
     998:	fbfd                	bnez	a5,98e <strchr+0xc>
      return (char *)s;
  return 0;
     99a:	4501                	li	a0,0
}
     99c:	6422                	ld	s0,8(sp)
     99e:	0141                	addi	sp,sp,16
     9a0:	8082                	ret
  return 0;
     9a2:	4501                	li	a0,0
     9a4:	bfe5                	j	99c <strchr+0x1a>

00000000000009a6 <gets>:

char *
gets(char *buf, int max)
{
     9a6:	711d                	addi	sp,sp,-96
     9a8:	ec86                	sd	ra,88(sp)
     9aa:	e8a2                	sd	s0,80(sp)
     9ac:	e4a6                	sd	s1,72(sp)
     9ae:	e0ca                	sd	s2,64(sp)
     9b0:	fc4e                	sd	s3,56(sp)
     9b2:	f852                	sd	s4,48(sp)
     9b4:	f456                	sd	s5,40(sp)
     9b6:	f05a                	sd	s6,32(sp)
     9b8:	ec5e                	sd	s7,24(sp)
     9ba:	1080                	addi	s0,sp,96
     9bc:	8baa                	mv	s7,a0
     9be:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     9c0:	892a                	mv	s2,a0
     9c2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
     9c4:	4aa9                	li	s5,10
     9c6:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
     9c8:	89a6                	mv	s3,s1
     9ca:	2485                	addiw	s1,s1,1
     9cc:	0344d663          	bge	s1,s4,9f8 <gets+0x52>
    cc = read(0, &c, 1);
     9d0:	4605                	li	a2,1
     9d2:	faf40593          	addi	a1,s0,-81
     9d6:	4501                	li	a0,0
     9d8:	1b2000ef          	jal	b8a <read>
    if (cc < 1)
     9dc:	00a05e63          	blez	a0,9f8 <gets+0x52>
    buf[i++] = c;
     9e0:	faf44783          	lbu	a5,-81(s0)
     9e4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
     9e8:	01578763          	beq	a5,s5,9f6 <gets+0x50>
     9ec:	0905                	addi	s2,s2,1
     9ee:	fd679de3          	bne	a5,s6,9c8 <gets+0x22>
    buf[i++] = c;
     9f2:	89a6                	mv	s3,s1
     9f4:	a011                	j	9f8 <gets+0x52>
     9f6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9f8:	99de                	add	s3,s3,s7
     9fa:	00098023          	sb	zero,0(s3)
  return buf;
}
     9fe:	855e                	mv	a0,s7
     a00:	60e6                	ld	ra,88(sp)
     a02:	6446                	ld	s0,80(sp)
     a04:	64a6                	ld	s1,72(sp)
     a06:	6906                	ld	s2,64(sp)
     a08:	79e2                	ld	s3,56(sp)
     a0a:	7a42                	ld	s4,48(sp)
     a0c:	7aa2                	ld	s5,40(sp)
     a0e:	7b02                	ld	s6,32(sp)
     a10:	6be2                	ld	s7,24(sp)
     a12:	6125                	addi	sp,sp,96
     a14:	8082                	ret

0000000000000a16 <stat>:

int
stat(const char *n, struct stat *st)
{
     a16:	1101                	addi	sp,sp,-32
     a18:	ec06                	sd	ra,24(sp)
     a1a:	e822                	sd	s0,16(sp)
     a1c:	e04a                	sd	s2,0(sp)
     a1e:	1000                	addi	s0,sp,32
     a20:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	18e000ef          	jal	bb2 <open>
  if (fd < 0)
     a28:	02054263          	bltz	a0,a4c <stat+0x36>
     a2c:	e426                	sd	s1,8(sp)
     a2e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a30:	85ca                	mv	a1,s2
     a32:	198000ef          	jal	bca <fstat>
     a36:	892a                	mv	s2,a0
  close(fd);
     a38:	8526                	mv	a0,s1
     a3a:	160000ef          	jal	b9a <close>
  return r;
     a3e:	64a2                	ld	s1,8(sp)
}
     a40:	854a                	mv	a0,s2
     a42:	60e2                	ld	ra,24(sp)
     a44:	6442                	ld	s0,16(sp)
     a46:	6902                	ld	s2,0(sp)
     a48:	6105                	addi	sp,sp,32
     a4a:	8082                	ret
    return -1;
     a4c:	597d                	li	s2,-1
     a4e:	bfcd                	j	a40 <stat+0x2a>

0000000000000a50 <atoi>:

int
atoi(const char *s)
{
     a50:	1141                	addi	sp,sp,-16
     a52:	e422                	sd	s0,8(sp)
     a54:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
     a56:	00054683          	lbu	a3,0(a0)
     a5a:	fd06879b          	addiw	a5,a3,-48
     a5e:	0ff7f793          	zext.b	a5,a5
     a62:	4625                	li	a2,9
     a64:	02f66863          	bltu	a2,a5,a94 <atoi+0x44>
     a68:	872a                	mv	a4,a0
  n = 0;
     a6a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
     a6c:	0705                	addi	a4,a4,1
     a6e:	0025179b          	slliw	a5,a0,0x2
     a72:	9fa9                	addw	a5,a5,a0
     a74:	0017979b          	slliw	a5,a5,0x1
     a78:	9fb5                	addw	a5,a5,a3
     a7a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
     a7e:	00074683          	lbu	a3,0(a4)
     a82:	fd06879b          	addiw	a5,a3,-48
     a86:	0ff7f793          	zext.b	a5,a5
     a8a:	fef671e3          	bgeu	a2,a5,a6c <atoi+0x1c>
  return n;
}
     a8e:	6422                	ld	s0,8(sp)
     a90:	0141                	addi	sp,sp,16
     a92:	8082                	ret
  n = 0;
     a94:	4501                	li	a0,0
     a96:	bfe5                	j	a8e <atoi+0x3e>

0000000000000a98 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a98:	1141                	addi	sp,sp,-16
     a9a:	e422                	sd	s0,8(sp)
     a9c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a9e:	02b57463          	bgeu	a0,a1,ac6 <memmove+0x2e>
    while (n-- > 0)
     aa2:	00c05f63          	blez	a2,ac0 <memmove+0x28>
     aa6:	1602                	slli	a2,a2,0x20
     aa8:	9201                	srli	a2,a2,0x20
     aaa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     aae:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab0:	0585                	addi	a1,a1,1
     ab2:	0705                	addi	a4,a4,1
     ab4:	fff5c683          	lbu	a3,-1(a1)
     ab8:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
     abc:	fef71ae3          	bne	a4,a5,ab0 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac0:	6422                	ld	s0,8(sp)
     ac2:	0141                	addi	sp,sp,16
     ac4:	8082                	ret
    dst += n;
     ac6:	00c50733          	add	a4,a0,a2
    src += n;
     aca:	95b2                	add	a1,a1,a2
    while (n-- > 0)
     acc:	fec05ae3          	blez	a2,ac0 <memmove+0x28>
     ad0:	fff6079b          	addiw	a5,a2,-1
     ad4:	1782                	slli	a5,a5,0x20
     ad6:	9381                	srli	a5,a5,0x20
     ad8:	fff7c793          	not	a5,a5
     adc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ade:	15fd                	addi	a1,a1,-1
     ae0:	177d                	addi	a4,a4,-1
     ae2:	0005c683          	lbu	a3,0(a1)
     ae6:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
     aea:	fee79ae3          	bne	a5,a4,ade <memmove+0x46>
     aee:	bfc9                	j	ac0 <memmove+0x28>

0000000000000af0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af0:	1141                	addi	sp,sp,-16
     af2:	e422                	sd	s0,8(sp)
     af4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     af6:	ca05                	beqz	a2,b26 <memcmp+0x36>
     af8:	fff6069b          	addiw	a3,a2,-1
     afc:	1682                	slli	a3,a3,0x20
     afe:	9281                	srli	a3,a3,0x20
     b00:	0685                	addi	a3,a3,1
     b02:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b04:	00054783          	lbu	a5,0(a0)
     b08:	0005c703          	lbu	a4,0(a1)
     b0c:	00e79863          	bne	a5,a4,b1c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b10:	0505                	addi	a0,a0,1
    p2++;
     b12:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b14:	fed518e3          	bne	a0,a3,b04 <memcmp+0x14>
  }
  return 0;
     b18:	4501                	li	a0,0
     b1a:	a019                	j	b20 <memcmp+0x30>
      return *p1 - *p2;
     b1c:	40e7853b          	subw	a0,a5,a4
}
     b20:	6422                	ld	s0,8(sp)
     b22:	0141                	addi	sp,sp,16
     b24:	8082                	ret
  return 0;
     b26:	4501                	li	a0,0
     b28:	bfe5                	j	b20 <memcmp+0x30>

0000000000000b2a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b2a:	1141                	addi	sp,sp,-16
     b2c:	e406                	sd	ra,8(sp)
     b2e:	e022                	sd	s0,0(sp)
     b30:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b32:	f67ff0ef          	jal	a98 <memmove>
}
     b36:	60a2                	ld	ra,8(sp)
     b38:	6402                	ld	s0,0(sp)
     b3a:	0141                	addi	sp,sp,16
     b3c:	8082                	ret

0000000000000b3e <sbrk>:

char *
sbrk(int n)
{
     b3e:	1141                	addi	sp,sp,-16
     b40:	e406                	sd	ra,8(sp)
     b42:	e022                	sd	s0,0(sp)
     b44:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b46:	4585                	li	a1,1
     b48:	0b2000ef          	jal	bfa <sys_sbrk>
}
     b4c:	60a2                	ld	ra,8(sp)
     b4e:	6402                	ld	s0,0(sp)
     b50:	0141                	addi	sp,sp,16
     b52:	8082                	ret

0000000000000b54 <sbrklazy>:

char *
sbrklazy(int n)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e406                	sd	ra,8(sp)
     b58:	e022                	sd	s0,0(sp)
     b5a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b5c:	4589                	li	a1,2
     b5e:	09c000ef          	jal	bfa <sys_sbrk>
}
     b62:	60a2                	ld	ra,8(sp)
     b64:	6402                	ld	s0,0(sp)
     b66:	0141                	addi	sp,sp,16
     b68:	8082                	ret

0000000000000b6a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b6a:	4885                	li	a7,1
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b72:	4889                	li	a7,2
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <wait>:
.global wait
wait:
 li a7, SYS_wait
     b7a:	488d                	li	a7,3
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b82:	4891                	li	a7,4
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <read>:
.global read
read:
 li a7, SYS_read
     b8a:	4895                	li	a7,5
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <write>:
.global write
write:
 li a7, SYS_write
     b92:	48c1                	li	a7,16
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <close>:
.global close
close:
 li a7, SYS_close
     b9a:	48d5                	li	a7,21
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     ba2:	4899                	li	a7,6
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <exec>:
.global exec
exec:
 li a7, SYS_exec
     baa:	489d                	li	a7,7
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <open>:
.global open
open:
 li a7, SYS_open
     bb2:	48bd                	li	a7,15
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bba:	48c5                	li	a7,17
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bc2:	48c9                	li	a7,18
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bca:	48a1                	li	a7,8
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <link>:
.global link
link:
 li a7, SYS_link
     bd2:	48cd                	li	a7,19
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bda:	48d1                	li	a7,20
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     be2:	48a5                	li	a7,9
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <dup>:
.global dup
dup:
 li a7, SYS_dup
     bea:	48a9                	li	a7,10
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bf2:	48ad                	li	a7,11
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     bfa:	48b1                	li	a7,12
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <pause>:
.global pause
pause:
 li a7, SYS_pause
     c02:	48b5                	li	a7,13
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c0a:	48b9                	li	a7,14
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <sync>:
.global sync
sync:
 li a7, SYS_sync
     c12:	48d9                	li	a7,22
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <ps>:
.global ps
ps:
 li a7, SYS_ps
     c1a:	48dd                	li	a7,23
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
     c22:	48e1                	li	a7,24
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c2a:	48e5                	li	a7,25
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c32:	48e9                	li	a7,26
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <trace>:
.global trace
trace:
 li a7, SYS_trace
     c3a:	48ed                	li	a7,27
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
     c42:	48f1                	li	a7,28
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     c4a:	48f5                	li	a7,29
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
     c52:	48f9                	li	a7,30
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
     c5a:	48fd                	li	a7,31
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
     c62:	02000893          	li	a7,32
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <halt>:
.global halt
halt:
 li a7, SYS_halt
     c6c:	02100893          	li	a7,33
 ecall
     c70:	00000073          	ecall
 ret
     c74:	8082                	ret

0000000000000c76 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
     c76:	02200893          	li	a7,34
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
     c80:	02300893          	li	a7,35
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
     c8a:	02400893          	li	a7,36
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
     c94:	02500893          	li	a7,37
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
     c9e:	02600893          	li	a7,38
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
     ca8:	02700893          	li	a7,39
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cb2:	1101                	addi	sp,sp,-32
     cb4:	ec06                	sd	ra,24(sp)
     cb6:	e822                	sd	s0,16(sp)
     cb8:	1000                	addi	s0,sp,32
     cba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cbe:	4605                	li	a2,1
     cc0:	fef40593          	addi	a1,s0,-17
     cc4:	ecfff0ef          	jal	b92 <write>
}
     cc8:	60e2                	ld	ra,24(sp)
     cca:	6442                	ld	s0,16(sp)
     ccc:	6105                	addi	sp,sp,32
     cce:	8082                	ret

0000000000000cd0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     cd0:	715d                	addi	sp,sp,-80
     cd2:	e486                	sd	ra,72(sp)
     cd4:	e0a2                	sd	s0,64(sp)
     cd6:	f84a                	sd	s2,48(sp)
     cd8:	0880                	addi	s0,sp,80
     cda:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
     cdc:	c299                	beqz	a3,ce2 <printint+0x12>
     cde:	0805c363          	bltz	a1,d64 <printint+0x94>
  neg = 0;
     ce2:	4881                	li	a7,0
     ce4:	fb840693          	addi	a3,s0,-72
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     ce8:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
     cea:	00001517          	auipc	a0,0x1
     cee:	87650513          	addi	a0,a0,-1930 # 1560 <digits>
     cf2:	883e                	mv	a6,a5
     cf4:	2785                	addiw	a5,a5,1
     cf6:	02c5f733          	remu	a4,a1,a2
     cfa:	972a                	add	a4,a4,a0
     cfc:	00074703          	lbu	a4,0(a4)
     d00:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
     d04:	872e                	mv	a4,a1
     d06:	02c5d5b3          	divu	a1,a1,a2
     d0a:	0685                	addi	a3,a3,1
     d0c:	fec773e3          	bgeu	a4,a2,cf2 <printint+0x22>
  if (neg)
     d10:	00088b63          	beqz	a7,d26 <printint+0x56>
    buf[i++] = '-';
     d14:	fd078793          	addi	a5,a5,-48
     d18:	97a2                	add	a5,a5,s0
     d1a:	02d00713          	li	a4,45
     d1e:	fee78423          	sb	a4,-24(a5)
     d22:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
     d26:	02f05a63          	blez	a5,d5a <printint+0x8a>
     d2a:	fc26                	sd	s1,56(sp)
     d2c:	f44e                	sd	s3,40(sp)
     d2e:	fb840713          	addi	a4,s0,-72
     d32:	00f704b3          	add	s1,a4,a5
     d36:	fff70993          	addi	s3,a4,-1
     d3a:	99be                	add	s3,s3,a5
     d3c:	37fd                	addiw	a5,a5,-1
     d3e:	1782                	slli	a5,a5,0x20
     d40:	9381                	srli	a5,a5,0x20
     d42:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
     d46:	fff4c583          	lbu	a1,-1(s1)
     d4a:	854a                	mv	a0,s2
     d4c:	f67ff0ef          	jal	cb2 <putc>
  while (--i >= 0)
     d50:	14fd                	addi	s1,s1,-1
     d52:	ff349ae3          	bne	s1,s3,d46 <printint+0x76>
     d56:	74e2                	ld	s1,56(sp)
     d58:	79a2                	ld	s3,40(sp)
}
     d5a:	60a6                	ld	ra,72(sp)
     d5c:	6406                	ld	s0,64(sp)
     d5e:	7942                	ld	s2,48(sp)
     d60:	6161                	addi	sp,sp,80
     d62:	8082                	ret
    x = -xx;
     d64:	40b005b3          	neg	a1,a1
    neg = 1;
     d68:	4885                	li	a7,1
    x = -xx;
     d6a:	bfad                	j	ce4 <printint+0x14>

0000000000000d6c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d6c:	711d                	addi	sp,sp,-96
     d6e:	ec86                	sd	ra,88(sp)
     d70:	e8a2                	sd	s0,80(sp)
     d72:	e0ca                	sd	s2,64(sp)
     d74:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     d76:	0005c903          	lbu	s2,0(a1)
     d7a:	28090663          	beqz	s2,1006 <vprintf+0x29a>
     d7e:	e4a6                	sd	s1,72(sp)
     d80:	fc4e                	sd	s3,56(sp)
     d82:	f852                	sd	s4,48(sp)
     d84:	f456                	sd	s5,40(sp)
     d86:	f05a                	sd	s6,32(sp)
     d88:	ec5e                	sd	s7,24(sp)
     d8a:	e862                	sd	s8,16(sp)
     d8c:	e466                	sd	s9,8(sp)
     d8e:	8b2a                	mv	s6,a0
     d90:	8a2e                	mv	s4,a1
     d92:	8bb2                	mv	s7,a2
  state = 0;
     d94:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
     d96:	4481                	li	s1,0
     d98:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
     d9a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
     d9e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
     da2:	06c00c93          	li	s9,108
     da6:	a005                	j	dc6 <vprintf+0x5a>
        putc(fd, c0);
     da8:	85ca                	mv	a1,s2
     daa:	855a                	mv	a0,s6
     dac:	f07ff0ef          	jal	cb2 <putc>
     db0:	a019                	j	db6 <vprintf+0x4a>
    } else if (state == '%') {
     db2:	03598263          	beq	s3,s5,dd6 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
     db6:	2485                	addiw	s1,s1,1
     db8:	8726                	mv	a4,s1
     dba:	009a07b3          	add	a5,s4,s1
     dbe:	0007c903          	lbu	s2,0(a5)
     dc2:	22090a63          	beqz	s2,ff6 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     dc6:	0009079b          	sext.w	a5,s2
    if (state == 0) {
     dca:	fe0994e3          	bnez	s3,db2 <vprintf+0x46>
      if (c0 == '%') {
     dce:	fd579de3          	bne	a5,s5,da8 <vprintf+0x3c>
        state = '%';
     dd2:	89be                	mv	s3,a5
     dd4:	b7cd                	j	db6 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
     dd6:	00ea06b3          	add	a3,s4,a4
     dda:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     dde:	8636                	mv	a2,a3
      if (c1)
     de0:	c681                	beqz	a3,de8 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
     de2:	9752                	add	a4,a4,s4
     de4:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
     de8:	05878363          	beq	a5,s8,e2e <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
     dec:	05978d63          	beq	a5,s9,e46 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
     df0:	07500713          	li	a4,117
     df4:	0ee78763          	beq	a5,a4,ee2 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
     df8:	07800713          	li	a4,120
     dfc:	12e78963          	beq	a5,a4,f2e <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
     e00:	07000713          	li	a4,112
     e04:	14e78e63          	beq	a5,a4,f60 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
     e08:	06300713          	li	a4,99
     e0c:	18e78e63          	beq	a5,a4,fa8 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
     e10:	07300713          	li	a4,115
     e14:	1ae78463          	beq	a5,a4,fbc <vprintf+0x250>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
     e18:	02500713          	li	a4,37
     e1c:	04e79563          	bne	a5,a4,e66 <vprintf+0xfa>
        putc(fd, '%');
     e20:	02500593          	li	a1,37
     e24:	855a                	mv	a0,s6
     e26:	e8dff0ef          	jal	cb2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e2a:	4981                	li	s3,0
     e2c:	b769                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e2e:	008b8913          	addi	s2,s7,8
     e32:	4685                	li	a3,1
     e34:	4629                	li	a2,10
     e36:	000ba583          	lw	a1,0(s7)
     e3a:	855a                	mv	a0,s6
     e3c:	e95ff0ef          	jal	cd0 <printint>
     e40:	8bca                	mv	s7,s2
      state = 0;
     e42:	4981                	li	s3,0
     e44:	bf8d                	j	db6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
     e46:	06400793          	li	a5,100
     e4a:	02f68963          	beq	a3,a5,e7c <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     e4e:	06c00793          	li	a5,108
     e52:	04f68263          	beq	a3,a5,e96 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
     e56:	07500793          	li	a5,117
     e5a:	0af68063          	beq	a3,a5,efa <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
     e5e:	07800793          	li	a5,120
     e62:	0ef68263          	beq	a3,a5,f46 <vprintf+0x1da>
        putc(fd, '%');
     e66:	02500593          	li	a1,37
     e6a:	855a                	mv	a0,s6
     e6c:	e47ff0ef          	jal	cb2 <putc>
        putc(fd, c0);
     e70:	85ca                	mv	a1,s2
     e72:	855a                	mv	a0,s6
     e74:	e3fff0ef          	jal	cb2 <putc>
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	bf35                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e7c:	008b8913          	addi	s2,s7,8
     e80:	4685                	li	a3,1
     e82:	4629                	li	a2,10
     e84:	000bb583          	ld	a1,0(s7)
     e88:	855a                	mv	a0,s6
     e8a:	e47ff0ef          	jal	cd0 <printint>
        i += 1;
     e8e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e90:	8bca                	mv	s7,s2
      state = 0;
     e92:	4981                	li	s3,0
        i += 1;
     e94:	b70d                	j	db6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     e96:	06400793          	li	a5,100
     e9a:	02f60763          	beq	a2,a5,ec8 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
     e9e:	07500793          	li	a5,117
     ea2:	06f60963          	beq	a2,a5,f14 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
     ea6:	07800793          	li	a5,120
     eaa:	faf61ee3          	bne	a2,a5,e66 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eae:	008b8913          	addi	s2,s7,8
     eb2:	4681                	li	a3,0
     eb4:	4641                	li	a2,16
     eb6:	000bb583          	ld	a1,0(s7)
     eba:	855a                	mv	a0,s6
     ebc:	e15ff0ef          	jal	cd0 <printint>
        i += 2;
     ec0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec2:	8bca                	mv	s7,s2
      state = 0;
     ec4:	4981                	li	s3,0
        i += 2;
     ec6:	bdc5                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ec8:	008b8913          	addi	s2,s7,8
     ecc:	4685                	li	a3,1
     ece:	4629                	li	a2,10
     ed0:	000bb583          	ld	a1,0(s7)
     ed4:	855a                	mv	a0,s6
     ed6:	dfbff0ef          	jal	cd0 <printint>
        i += 2;
     eda:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     edc:	8bca                	mv	s7,s2
      state = 0;
     ede:	4981                	li	s3,0
        i += 2;
     ee0:	bdd9                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ee2:	008b8913          	addi	s2,s7,8
     ee6:	4681                	li	a3,0
     ee8:	4629                	li	a2,10
     eea:	000be583          	lwu	a1,0(s7)
     eee:	855a                	mv	a0,s6
     ef0:	de1ff0ef          	jal	cd0 <printint>
     ef4:	8bca                	mv	s7,s2
      state = 0;
     ef6:	4981                	li	s3,0
     ef8:	bd7d                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     efa:	008b8913          	addi	s2,s7,8
     efe:	4681                	li	a3,0
     f00:	4629                	li	a2,10
     f02:	000bb583          	ld	a1,0(s7)
     f06:	855a                	mv	a0,s6
     f08:	dc9ff0ef          	jal	cd0 <printint>
        i += 1;
     f0c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f0e:	8bca                	mv	s7,s2
      state = 0;
     f10:	4981                	li	s3,0
        i += 1;
     f12:	b555                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f14:	008b8913          	addi	s2,s7,8
     f18:	4681                	li	a3,0
     f1a:	4629                	li	a2,10
     f1c:	000bb583          	ld	a1,0(s7)
     f20:	855a                	mv	a0,s6
     f22:	dafff0ef          	jal	cd0 <printint>
        i += 2;
     f26:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f28:	8bca                	mv	s7,s2
      state = 0;
     f2a:	4981                	li	s3,0
        i += 2;
     f2c:	b569                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f2e:	008b8913          	addi	s2,s7,8
     f32:	4681                	li	a3,0
     f34:	4641                	li	a2,16
     f36:	000be583          	lwu	a1,0(s7)
     f3a:	855a                	mv	a0,s6
     f3c:	d95ff0ef          	jal	cd0 <printint>
     f40:	8bca                	mv	s7,s2
      state = 0;
     f42:	4981                	li	s3,0
     f44:	bd8d                	j	db6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f46:	008b8913          	addi	s2,s7,8
     f4a:	4681                	li	a3,0
     f4c:	4641                	li	a2,16
     f4e:	000bb583          	ld	a1,0(s7)
     f52:	855a                	mv	a0,s6
     f54:	d7dff0ef          	jal	cd0 <printint>
        i += 1;
     f58:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f5a:	8bca                	mv	s7,s2
      state = 0;
     f5c:	4981                	li	s3,0
        i += 1;
     f5e:	bda1                	j	db6 <vprintf+0x4a>
     f60:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     f62:	008b8d13          	addi	s10,s7,8
     f66:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f6a:	03000593          	li	a1,48
     f6e:	855a                	mv	a0,s6
     f70:	d43ff0ef          	jal	cb2 <putc>
  putc(fd, 'x');
     f74:	07800593          	li	a1,120
     f78:	855a                	mv	a0,s6
     f7a:	d39ff0ef          	jal	cb2 <putc>
     f7e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f80:	00000b97          	auipc	s7,0x0
     f84:	5e0b8b93          	addi	s7,s7,1504 # 1560 <digits>
     f88:	03c9d793          	srli	a5,s3,0x3c
     f8c:	97de                	add	a5,a5,s7
     f8e:	0007c583          	lbu	a1,0(a5)
     f92:	855a                	mv	a0,s6
     f94:	d1fff0ef          	jal	cb2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f98:	0992                	slli	s3,s3,0x4
     f9a:	397d                	addiw	s2,s2,-1
     f9c:	fe0916e3          	bnez	s2,f88 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     fa0:	8bea                	mv	s7,s10
      state = 0;
     fa2:	4981                	li	s3,0
     fa4:	6d02                	ld	s10,0(sp)
     fa6:	bd01                	j	db6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
     fa8:	008b8913          	addi	s2,s7,8
     fac:	000bc583          	lbu	a1,0(s7)
     fb0:	855a                	mv	a0,s6
     fb2:	d01ff0ef          	jal	cb2 <putc>
     fb6:	8bca                	mv	s7,s2
      state = 0;
     fb8:	4981                	li	s3,0
     fba:	bbf5                	j	db6 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
     fbc:	008b8993          	addi	s3,s7,8
     fc0:	000bb903          	ld	s2,0(s7)
     fc4:	00090f63          	beqz	s2,fe2 <vprintf+0x276>
        for (; *s; s++)
     fc8:	00094583          	lbu	a1,0(s2)
     fcc:	c195                	beqz	a1,ff0 <vprintf+0x284>
          putc(fd, *s);
     fce:	855a                	mv	a0,s6
     fd0:	ce3ff0ef          	jal	cb2 <putc>
        for (; *s; s++)
     fd4:	0905                	addi	s2,s2,1
     fd6:	00094583          	lbu	a1,0(s2)
     fda:	f9f5                	bnez	a1,fce <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
     fdc:	8bce                	mv	s7,s3
      state = 0;
     fde:	4981                	li	s3,0
     fe0:	bbd9                	j	db6 <vprintf+0x4a>
          s = "(null)";
     fe2:	00000917          	auipc	s2,0x0
     fe6:	51690913          	addi	s2,s2,1302 # 14f8 <malloc+0x40a>
        for (; *s; s++)
     fea:	02800593          	li	a1,40
     fee:	b7c5                	j	fce <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
     ff0:	8bce                	mv	s7,s3
      state = 0;
     ff2:	4981                	li	s3,0
     ff4:	b3c9                	j	db6 <vprintf+0x4a>
     ff6:	64a6                	ld	s1,72(sp)
     ff8:	79e2                	ld	s3,56(sp)
     ffa:	7a42                	ld	s4,48(sp)
     ffc:	7aa2                	ld	s5,40(sp)
     ffe:	7b02                	ld	s6,32(sp)
    1000:	6be2                	ld	s7,24(sp)
    1002:	6c42                	ld	s8,16(sp)
    1004:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1006:	60e6                	ld	ra,88(sp)
    1008:	6446                	ld	s0,80(sp)
    100a:	6906                	ld	s2,64(sp)
    100c:	6125                	addi	sp,sp,96
    100e:	8082                	ret

0000000000001010 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1010:	715d                	addi	sp,sp,-80
    1012:	ec06                	sd	ra,24(sp)
    1014:	e822                	sd	s0,16(sp)
    1016:	1000                	addi	s0,sp,32
    1018:	e010                	sd	a2,0(s0)
    101a:	e414                	sd	a3,8(s0)
    101c:	e818                	sd	a4,16(s0)
    101e:	ec1c                	sd	a5,24(s0)
    1020:	03043023          	sd	a6,32(s0)
    1024:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1028:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    102c:	8622                	mv	a2,s0
    102e:	d3fff0ef          	jal	d6c <vprintf>
}
    1032:	60e2                	ld	ra,24(sp)
    1034:	6442                	ld	s0,16(sp)
    1036:	6161                	addi	sp,sp,80
    1038:	8082                	ret

000000000000103a <printf>:

void
printf(const char *fmt, ...)
{
    103a:	711d                	addi	sp,sp,-96
    103c:	ec06                	sd	ra,24(sp)
    103e:	e822                	sd	s0,16(sp)
    1040:	1000                	addi	s0,sp,32
    1042:	e40c                	sd	a1,8(s0)
    1044:	e810                	sd	a2,16(s0)
    1046:	ec14                	sd	a3,24(s0)
    1048:	f018                	sd	a4,32(s0)
    104a:	f41c                	sd	a5,40(s0)
    104c:	03043823          	sd	a6,48(s0)
    1050:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1054:	00840613          	addi	a2,s0,8
    1058:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    105c:	85aa                	mv	a1,a0
    105e:	4505                	li	a0,1
    1060:	d0dff0ef          	jal	d6c <vprintf>
}
    1064:	60e2                	ld	ra,24(sp)
    1066:	6442                	ld	s0,16(sp)
    1068:	6125                	addi	sp,sp,96
    106a:	8082                	ret

000000000000106c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    106c:	1141                	addi	sp,sp,-16
    106e:	e422                	sd	s0,8(sp)
    1070:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    1072:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1076:	00001797          	auipc	a5,0x1
    107a:	f9a7b783          	ld	a5,-102(a5) # 2010 <freep>
    107e:	a02d                	j	10a8 <free+0x3c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    1080:	4618                	lw	a4,8(a2)
    1082:	9f2d                	addw	a4,a4,a1
    1084:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1088:	6398                	ld	a4,0(a5)
    108a:	6310                	ld	a2,0(a4)
    108c:	a83d                	j	10ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    108e:	ff852703          	lw	a4,-8(a0)
    1092:	9f31                	addw	a4,a4,a2
    1094:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1096:	ff053683          	ld	a3,-16(a0)
    109a:	a091                	j	10de <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    109c:	6398                	ld	a4,0(a5)
    109e:	00e7e463          	bltu	a5,a4,10a6 <free+0x3a>
    10a2:	00e6ea63          	bltu	a3,a4,10b6 <free+0x4a>
{
    10a6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a8:	fed7fae3          	bgeu	a5,a3,109c <free+0x30>
    10ac:	6398                	ld	a4,0(a5)
    10ae:	00e6e463          	bltu	a3,a4,10b6 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10b2:	fee7eae3          	bltu	a5,a4,10a6 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
    10b6:	ff852583          	lw	a1,-8(a0)
    10ba:	6390                	ld	a2,0(a5)
    10bc:	02059813          	slli	a6,a1,0x20
    10c0:	01c85713          	srli	a4,a6,0x1c
    10c4:	9736                	add	a4,a4,a3
    10c6:	fae60de3          	beq	a2,a4,1080 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    10ca:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    10ce:	4790                	lw	a2,8(a5)
    10d0:	02061593          	slli	a1,a2,0x20
    10d4:	01c5d713          	srli	a4,a1,0x1c
    10d8:	973e                	add	a4,a4,a5
    10da:	fae68ae3          	beq	a3,a4,108e <free+0x22>
    p->s.ptr = bp->s.ptr;
    10de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10e0:	00001717          	auipc	a4,0x1
    10e4:	f2f73823          	sd	a5,-208(a4) # 2010 <freep>
}
    10e8:	6422                	ld	s0,8(sp)
    10ea:	0141                	addi	sp,sp,16
    10ec:	8082                	ret

00000000000010ee <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    10ee:	7139                	addi	sp,sp,-64
    10f0:	fc06                	sd	ra,56(sp)
    10f2:	f822                	sd	s0,48(sp)
    10f4:	f426                	sd	s1,40(sp)
    10f6:	ec4e                	sd	s3,24(sp)
    10f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    10fa:	02051493          	slli	s1,a0,0x20
    10fe:	9081                	srli	s1,s1,0x20
    1100:	04bd                	addi	s1,s1,15
    1102:	8091                	srli	s1,s1,0x4
    1104:	0014899b          	addiw	s3,s1,1
    1108:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
    110a:	00001517          	auipc	a0,0x1
    110e:	f0653503          	ld	a0,-250(a0) # 2010 <freep>
    1112:	c915                	beqz	a0,1146 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1114:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    1116:	4798                	lw	a4,8(a5)
    1118:	08977a63          	bgeu	a4,s1,11ac <malloc+0xbe>
    111c:	f04a                	sd	s2,32(sp)
    111e:	e852                	sd	s4,16(sp)
    1120:	e456                	sd	s5,8(sp)
    1122:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    1124:	8a4e                	mv	s4,s3
    1126:	0009871b          	sext.w	a4,s3
    112a:	6685                	lui	a3,0x1
    112c:	00d77363          	bgeu	a4,a3,1132 <malloc+0x44>
    1130:	6a05                	lui	s4,0x1
    1132:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1136:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    113a:	00001917          	auipc	s2,0x1
    113e:	ed690913          	addi	s2,s2,-298 # 2010 <freep>
  if (p == SBRK_ERROR)
    1142:	5afd                	li	s5,-1
    1144:	a081                	j	1184 <malloc+0x96>
    1146:	f04a                	sd	s2,32(sp)
    1148:	e852                	sd	s4,16(sp)
    114a:	e456                	sd	s5,8(sp)
    114c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    114e:	00001797          	auipc	a5,0x1
    1152:	2ba78793          	addi	a5,a5,698 # 2408 <base>
    1156:	00001717          	auipc	a4,0x1
    115a:	eaf73d23          	sd	a5,-326(a4) # 2010 <freep>
    115e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1160:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    1164:	b7c1                	j	1124 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1166:	6398                	ld	a4,0(a5)
    1168:	e118                	sd	a4,0(a0)
    116a:	a8a9                	j	11c4 <malloc+0xd6>
  hp->s.size = nu;
    116c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    1170:	0541                	addi	a0,a0,16
    1172:	efbff0ef          	jal	106c <free>
  return freep;
    1176:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
    117a:	c12d                	beqz	a0,11dc <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    117c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    117e:	4798                	lw	a4,8(a5)
    1180:	02977263          	bgeu	a4,s1,11a4 <malloc+0xb6>
    if (p == freep)
    1184:	00093703          	ld	a4,0(s2)
    1188:	853e                	mv	a0,a5
    118a:	fef719e3          	bne	a4,a5,117c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    118e:	8552                	mv	a0,s4
    1190:	9afff0ef          	jal	b3e <sbrk>
  if (p == SBRK_ERROR)
    1194:	fd551ce3          	bne	a0,s5,116c <malloc+0x7e>
        return 0;
    1198:	4501                	li	a0,0
    119a:	7902                	ld	s2,32(sp)
    119c:	6a42                	ld	s4,16(sp)
    119e:	6aa2                	ld	s5,8(sp)
    11a0:	6b02                	ld	s6,0(sp)
    11a2:	a03d                	j	11d0 <malloc+0xe2>
    11a4:	7902                	ld	s2,32(sp)
    11a6:	6a42                	ld	s4,16(sp)
    11a8:	6aa2                	ld	s5,8(sp)
    11aa:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    11ac:	fae48de3          	beq	s1,a4,1166 <malloc+0x78>
        p->s.size -= nunits;
    11b0:	4137073b          	subw	a4,a4,s3
    11b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11b6:	02071693          	slli	a3,a4,0x20
    11ba:	01c6d713          	srli	a4,a3,0x1c
    11be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11c4:	00001717          	auipc	a4,0x1
    11c8:	e4a73623          	sd	a0,-436(a4) # 2010 <freep>
      return (void *)(p + 1);
    11cc:	01078513          	addi	a0,a5,16
  }
}
    11d0:	70e2                	ld	ra,56(sp)
    11d2:	7442                	ld	s0,48(sp)
    11d4:	74a2                	ld	s1,40(sp)
    11d6:	69e2                	ld	s3,24(sp)
    11d8:	6121                	addi	sp,sp,64
    11da:	8082                	ret
    11dc:	7902                	ld	s2,32(sp)
    11de:	6a42                	ld	s4,16(sp)
    11e0:	6aa2                	ld	s5,8(sp)
    11e2:	6b02                	ld	s6,0(sp)
    11e4:	b7f5                	j	11d0 <malloc+0xe2>
