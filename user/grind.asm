
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
   * October 1988, p. 1195.
   */
  long hi, lo, x;

  /* Transform to [1, 0x7ffffffe] range. */
  x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <base+0xffffffffbfffdbf9>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
  hi = x / 127773;
  lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <base+0x1fe3d771>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <base+0x41a6e1a7>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
  x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <base+0x1d9f>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
  if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
    x += 0x7fffffff;
  /* Transform to [0, 0x7ffffffd] range. */
  x--;
      72:	17fd                	addi	a5,a5,-1
  *ctx = x;
      74:	e11c                	sd	a5,0(a0)
  return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
  return (do_rand(&rand_next));
      96:	00002517          	auipc	a0,0x2
      9a:	f6a50513          	addi	a0,a0,-150 # 2000 <rand_next>
      9e:	f63ff0ef          	jal	0 <do_rand>
}
      a2:	60a2                	ld	ra,8(sp)
      a4:	6402                	ld	s0,0(sp)
      a6:	0141                	addi	sp,sp,16
      a8:	8082                	ret

00000000000000aa <go>:

void
go(int which_child)
{
      aa:	7171                	addi	sp,sp,-176
      ac:	f506                	sd	ra,168(sp)
      ae:	f122                	sd	s0,160(sp)
      b0:	ed26                	sd	s1,152(sp)
      b2:	1900                	addi	s0,sp,176
      b4:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      b6:	4501                	li	a0,0
      b8:	355000ef          	jal	c0c <sbrk>
      bc:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c0:	00001517          	auipc	a0,0x1
      c4:	17050513          	addi	a0,a0,368 # 1230 <malloc+0xf6>
      c8:	3e1000ef          	jal	ca8 <mkdir>
  if (chdir("grindir") != 0) {
      cc:	00001517          	auipc	a0,0x1
      d0:	16450513          	addi	a0,a0,356 # 1230 <malloc+0xf6>
      d4:	3dd000ef          	jal	cb0 <chdir>
      d8:	c505                	beqz	a0,100 <go+0x56>
      da:	e94a                	sd	s2,144(sp)
      dc:	e54e                	sd	s3,136(sp)
      de:	e152                	sd	s4,128(sp)
      e0:	fcd6                	sd	s5,120(sp)
      e2:	f8da                	sd	s6,112(sp)
      e4:	f4de                	sd	s7,104(sp)
      e6:	f0e2                	sd	s8,96(sp)
      e8:	ece6                	sd	s9,88(sp)
      ea:	e8ea                	sd	s10,80(sp)
      ec:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	14a50513          	addi	a0,a0,330 # 1238 <malloc+0xfe>
      f6:	78d000ef          	jal	1082 <printf>
    exit(1);
      fa:	4505                	li	a0,1
      fc:	345000ef          	jal	c40 <exit>
     100:	e94a                	sd	s2,144(sp)
     102:	e54e                	sd	s3,136(sp)
     104:	e152                	sd	s4,128(sp)
     106:	fcd6                	sd	s5,120(sp)
     108:	f8da                	sd	s6,112(sp)
     10a:	f4de                	sd	s7,104(sp)
     10c:	f0e2                	sd	s8,96(sp)
     10e:	ece6                	sd	s9,88(sp)
     110:	e8ea                	sd	s10,80(sp)
     112:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     114:	00001517          	auipc	a0,0x1
     118:	14c50513          	addi	a0,a0,332 # 1260 <malloc+0x126>
     11c:	395000ef          	jal	cb0 <chdir>
     120:	00001c17          	auipc	s8,0x1
     124:	150c0c13          	addi	s8,s8,336 # 1270 <malloc+0x136>
     128:	c489                	beqz	s1,132 <go+0x88>
     12a:	00001c17          	auipc	s8,0x1
     12e:	13ec0c13          	addi	s8,s8,318 # 1268 <malloc+0x12e>
  uint64 iters = 0;
     132:	4481                	li	s1,0
  int fd = -1;
     134:	5cfd                	li	s9,-1

  while (1) {
    iters++;
    if ((iters % 500) == 0)
     136:	e353f7b7          	lui	a5,0xe353f
     13a:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <base+0xffffffffe353d3c7>
     13e:	20c4a9b7          	lui	s3,0x20c4a
     142:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <base+0x20c4779e>
     146:	1982                	slli	s3,s3,0x20
     148:	99be                	add	s3,s3,a5
     14a:	1f400b13          	li	s6,500
      write(1, which_child ? "B" : "A", 1);
     14e:	4b85                	li	s7,1
    int what = rand() % 23;
     150:	b2164a37          	lui	s4,0xb2164
     154:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <base+0xffffffffb2161ec1>
     158:	4ad9                	li	s5,22
     15a:	00001917          	auipc	s2,0x1
     15e:	3e690913          	addi	s2,s2,998 # 1540 <malloc+0x406>
      close(fd1);
      unlink("c");
    } else if (what == 22) {
      // echo hi | cat
      int aa[2], bb[2];
      if (pipe(aa) < 0) {
     162:	f6840d93          	addi	s11,s0,-152
     166:	a819                	j	17c <go+0xd2>
      close(open("grindir/../a", O_CREATE | O_RDWR));
     168:	20200593          	li	a1,514
     16c:	00001517          	auipc	a0,0x1
     170:	10c50513          	addi	a0,a0,268 # 1278 <malloc+0x13e>
     174:	30d000ef          	jal	c80 <open>
     178:	2f1000ef          	jal	c68 <close>
    iters++;
     17c:	0485                	addi	s1,s1,1
    if ((iters % 500) == 0)
     17e:	0024d793          	srli	a5,s1,0x2
     182:	0337b7b3          	mulhu	a5,a5,s3
     186:	8391                	srli	a5,a5,0x4
     188:	036787b3          	mul	a5,a5,s6
     18c:	00f49763          	bne	s1,a5,19a <go+0xf0>
      write(1, which_child ? "B" : "A", 1);
     190:	865e                	mv	a2,s7
     192:	85e2                	mv	a1,s8
     194:	855e                	mv	a0,s7
     196:	2cb000ef          	jal	c60 <write>
    int what = rand() % 23;
     19a:	ef5ff0ef          	jal	8e <rand>
     19e:	034507b3          	mul	a5,a0,s4
     1a2:	9381                	srli	a5,a5,0x20
     1a4:	9fa9                	addw	a5,a5,a0
     1a6:	4047d79b          	sraiw	a5,a5,0x4
     1aa:	41f5571b          	sraiw	a4,a0,0x1f
     1ae:	9f99                	subw	a5,a5,a4
     1b0:	0017971b          	slliw	a4,a5,0x1
     1b4:	9f3d                	addw	a4,a4,a5
     1b6:	0037171b          	slliw	a4,a4,0x3
     1ba:	40f707bb          	subw	a5,a4,a5
     1be:	9d1d                	subw	a0,a0,a5
     1c0:	faaaeee3          	bltu	s5,a0,17c <go+0xd2>
     1c4:	02051793          	slli	a5,a0,0x20
     1c8:	01e7d513          	srli	a0,a5,0x1e
     1cc:	954a                	add	a0,a0,s2
     1ce:	411c                	lw	a5,0(a0)
     1d0:	97ca                	add	a5,a5,s2
     1d2:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE | O_RDWR));
     1d4:	20200593          	li	a1,514
     1d8:	00001517          	auipc	a0,0x1
     1dc:	0b050513          	addi	a0,a0,176 # 1288 <malloc+0x14e>
     1e0:	2a1000ef          	jal	c80 <open>
     1e4:	285000ef          	jal	c68 <close>
     1e8:	bf51                	j	17c <go+0xd2>
      unlink("grindir/../a");
     1ea:	00001517          	auipc	a0,0x1
     1ee:	08e50513          	addi	a0,a0,142 # 1278 <malloc+0x13e>
     1f2:	29f000ef          	jal	c90 <unlink>
     1f6:	b759                	j	17c <go+0xd2>
      if (chdir("grindir") != 0) {
     1f8:	00001517          	auipc	a0,0x1
     1fc:	03850513          	addi	a0,a0,56 # 1230 <malloc+0xf6>
     200:	2b1000ef          	jal	cb0 <chdir>
     204:	ed11                	bnez	a0,220 <go+0x176>
      unlink("../b");
     206:	00001517          	auipc	a0,0x1
     20a:	09a50513          	addi	a0,a0,154 # 12a0 <malloc+0x166>
     20e:	283000ef          	jal	c90 <unlink>
      chdir("/");
     212:	00001517          	auipc	a0,0x1
     216:	04e50513          	addi	a0,a0,78 # 1260 <malloc+0x126>
     21a:	297000ef          	jal	cb0 <chdir>
     21e:	bfb9                	j	17c <go+0xd2>
        printf("grind: chdir grindir failed\n");
     220:	00001517          	auipc	a0,0x1
     224:	01850513          	addi	a0,a0,24 # 1238 <malloc+0xfe>
     228:	65b000ef          	jal	1082 <printf>
        exit(1);
     22c:	4505                	li	a0,1
     22e:	213000ef          	jal	c40 <exit>
      close(fd);
     232:	8566                	mv	a0,s9
     234:	235000ef          	jal	c68 <close>
      fd = open("/grindir/../a", O_CREATE | O_RDWR);
     238:	20200593          	li	a1,514
     23c:	00001517          	auipc	a0,0x1
     240:	06c50513          	addi	a0,a0,108 # 12a8 <malloc+0x16e>
     244:	23d000ef          	jal	c80 <open>
     248:	8caa                	mv	s9,a0
     24a:	bf0d                	j	17c <go+0xd2>
      close(fd);
     24c:	8566                	mv	a0,s9
     24e:	21b000ef          	jal	c68 <close>
      fd = open("/./grindir/./../b", O_CREATE | O_RDWR);
     252:	20200593          	li	a1,514
     256:	00001517          	auipc	a0,0x1
     25a:	06250513          	addi	a0,a0,98 # 12b8 <malloc+0x17e>
     25e:	223000ef          	jal	c80 <open>
     262:	8caa                	mv	s9,a0
     264:	bf21                	j	17c <go+0xd2>
      write(fd, buf, sizeof(buf));
     266:	3e700613          	li	a2,999
     26a:	00002597          	auipc	a1,0x2
     26e:	db658593          	addi	a1,a1,-586 # 2020 <buf.0>
     272:	8566                	mv	a0,s9
     274:	1ed000ef          	jal	c60 <write>
     278:	b711                	j	17c <go+0xd2>
      read(fd, buf, sizeof(buf));
     27a:	3e700613          	li	a2,999
     27e:	00002597          	auipc	a1,0x2
     282:	da258593          	addi	a1,a1,-606 # 2020 <buf.0>
     286:	8566                	mv	a0,s9
     288:	1d1000ef          	jal	c58 <read>
     28c:	bdc5                	j	17c <go+0xd2>
      mkdir("grindir/../a");
     28e:	00001517          	auipc	a0,0x1
     292:	fea50513          	addi	a0,a0,-22 # 1278 <malloc+0x13e>
     296:	213000ef          	jal	ca8 <mkdir>
      close(open("a/../a/./a", O_CREATE | O_RDWR));
     29a:	20200593          	li	a1,514
     29e:	00001517          	auipc	a0,0x1
     2a2:	03250513          	addi	a0,a0,50 # 12d0 <malloc+0x196>
     2a6:	1db000ef          	jal	c80 <open>
     2aa:	1bf000ef          	jal	c68 <close>
      unlink("a/a");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	03250513          	addi	a0,a0,50 # 12e0 <malloc+0x1a6>
     2b6:	1db000ef          	jal	c90 <unlink>
     2ba:	b5c9                	j	17c <go+0xd2>
      mkdir("/../b");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	02c50513          	addi	a0,a0,44 # 12e8 <malloc+0x1ae>
     2c4:	1e5000ef          	jal	ca8 <mkdir>
      close(open("grindir/../b/b", O_CREATE | O_RDWR));
     2c8:	20200593          	li	a1,514
     2cc:	00001517          	auipc	a0,0x1
     2d0:	02450513          	addi	a0,a0,36 # 12f0 <malloc+0x1b6>
     2d4:	1ad000ef          	jal	c80 <open>
     2d8:	191000ef          	jal	c68 <close>
      unlink("b/b");
     2dc:	00001517          	auipc	a0,0x1
     2e0:	02450513          	addi	a0,a0,36 # 1300 <malloc+0x1c6>
     2e4:	1ad000ef          	jal	c90 <unlink>
     2e8:	bd51                	j	17c <go+0xd2>
      unlink("b");
     2ea:	00001517          	auipc	a0,0x1
     2ee:	01e50513          	addi	a0,a0,30 # 1308 <malloc+0x1ce>
     2f2:	19f000ef          	jal	c90 <unlink>
      link("../grindir/./../a", "../b");
     2f6:	00001597          	auipc	a1,0x1
     2fa:	faa58593          	addi	a1,a1,-86 # 12a0 <malloc+0x166>
     2fe:	00001517          	auipc	a0,0x1
     302:	01250513          	addi	a0,a0,18 # 1310 <malloc+0x1d6>
     306:	19b000ef          	jal	ca0 <link>
     30a:	bd8d                	j	17c <go+0xd2>
      unlink("../grindir/../a");
     30c:	00001517          	auipc	a0,0x1
     310:	01c50513          	addi	a0,a0,28 # 1328 <malloc+0x1ee>
     314:	17d000ef          	jal	c90 <unlink>
      link(".././b", "/grindir/../a");
     318:	00001597          	auipc	a1,0x1
     31c:	f9058593          	addi	a1,a1,-112 # 12a8 <malloc+0x16e>
     320:	00001517          	auipc	a0,0x1
     324:	01850513          	addi	a0,a0,24 # 1338 <malloc+0x1fe>
     328:	179000ef          	jal	ca0 <link>
     32c:	bd81                	j	17c <go+0xd2>
      int pid = fork();
     32e:	10b000ef          	jal	c38 <fork>
      if (pid == 0) {
     332:	c519                	beqz	a0,340 <go+0x296>
      } else if (pid < 0) {
     334:	00054863          	bltz	a0,344 <go+0x29a>
      wait(0);
     338:	4501                	li	a0,0
     33a:	10f000ef          	jal	c48 <wait>
     33e:	bd3d                	j	17c <go+0xd2>
        exit(0);
     340:	101000ef          	jal	c40 <exit>
        printf("grind: fork failed\n");
     344:	00001517          	auipc	a0,0x1
     348:	ffc50513          	addi	a0,a0,-4 # 1340 <malloc+0x206>
     34c:	537000ef          	jal	1082 <printf>
        exit(1);
     350:	4505                	li	a0,1
     352:	0ef000ef          	jal	c40 <exit>
      int pid = fork();
     356:	0e3000ef          	jal	c38 <fork>
      if (pid == 0) {
     35a:	c519                	beqz	a0,368 <go+0x2be>
      } else if (pid < 0) {
     35c:	00054d63          	bltz	a0,376 <go+0x2cc>
      wait(0);
     360:	4501                	li	a0,0
     362:	0e7000ef          	jal	c48 <wait>
     366:	bd19                	j	17c <go+0xd2>
        fork();
     368:	0d1000ef          	jal	c38 <fork>
        fork();
     36c:	0cd000ef          	jal	c38 <fork>
        exit(0);
     370:	4501                	li	a0,0
     372:	0cf000ef          	jal	c40 <exit>
        printf("grind: fork failed\n");
     376:	00001517          	auipc	a0,0x1
     37a:	fca50513          	addi	a0,a0,-54 # 1340 <malloc+0x206>
     37e:	505000ef          	jal	1082 <printf>
        exit(1);
     382:	4505                	li	a0,1
     384:	0bd000ef          	jal	c40 <exit>
      sbrk(6011);
     388:	6505                	lui	a0,0x1
     38a:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x1db>
     38e:	07f000ef          	jal	c0c <sbrk>
     392:	b3ed                	j	17c <go+0xd2>
      if (sbrk(0) > break0)
     394:	4501                	li	a0,0
     396:	077000ef          	jal	c0c <sbrk>
     39a:	f5843783          	ld	a5,-168(s0)
     39e:	dca7ffe3          	bgeu	a5,a0,17c <go+0xd2>
        sbrk(-(sbrk(0) - break0));
     3a2:	4501                	li	a0,0
     3a4:	069000ef          	jal	c0c <sbrk>
     3a8:	f5843783          	ld	a5,-168(s0)
     3ac:	40a7853b          	subw	a0,a5,a0
     3b0:	05d000ef          	jal	c0c <sbrk>
     3b4:	b3e1                	j	17c <go+0xd2>
      int pid = fork();
     3b6:	083000ef          	jal	c38 <fork>
     3ba:	8d2a                	mv	s10,a0
      if (pid == 0) {
     3bc:	c10d                	beqz	a0,3de <go+0x334>
      } else if (pid < 0) {
     3be:	02054d63          	bltz	a0,3f8 <go+0x34e>
      if (chdir("../grindir/..") != 0) {
     3c2:	00001517          	auipc	a0,0x1
     3c6:	f9e50513          	addi	a0,a0,-98 # 1360 <malloc+0x226>
     3ca:	0e7000ef          	jal	cb0 <chdir>
     3ce:	ed15                	bnez	a0,40a <go+0x360>
      kill(pid);
     3d0:	856a                	mv	a0,s10
     3d2:	09f000ef          	jal	c70 <kill>
      wait(0);
     3d6:	4501                	li	a0,0
     3d8:	071000ef          	jal	c48 <wait>
     3dc:	b345                	j	17c <go+0xd2>
        close(open("a", O_CREATE | O_RDWR));
     3de:	20200593          	li	a1,514
     3e2:	00001517          	auipc	a0,0x1
     3e6:	f7650513          	addi	a0,a0,-138 # 1358 <malloc+0x21e>
     3ea:	097000ef          	jal	c80 <open>
     3ee:	07b000ef          	jal	c68 <close>
        exit(0);
     3f2:	4501                	li	a0,0
     3f4:	04d000ef          	jal	c40 <exit>
        printf("grind: fork failed\n");
     3f8:	00001517          	auipc	a0,0x1
     3fc:	f4850513          	addi	a0,a0,-184 # 1340 <malloc+0x206>
     400:	483000ef          	jal	1082 <printf>
        exit(1);
     404:	4505                	li	a0,1
     406:	03b000ef          	jal	c40 <exit>
        printf("grind: chdir failed\n");
     40a:	00001517          	auipc	a0,0x1
     40e:	f6650513          	addi	a0,a0,-154 # 1370 <malloc+0x236>
     412:	471000ef          	jal	1082 <printf>
        exit(1);
     416:	4505                	li	a0,1
     418:	029000ef          	jal	c40 <exit>
      int pid = fork();
     41c:	01d000ef          	jal	c38 <fork>
      if (pid == 0) {
     420:	c519                	beqz	a0,42e <go+0x384>
      } else if (pid < 0) {
     422:	00054d63          	bltz	a0,43c <go+0x392>
      wait(0);
     426:	4501                	li	a0,0
     428:	021000ef          	jal	c48 <wait>
     42c:	bb81                	j	17c <go+0xd2>
        kill(getpid());
     42e:	093000ef          	jal	cc0 <getpid>
     432:	03f000ef          	jal	c70 <kill>
        exit(0);
     436:	4501                	li	a0,0
     438:	009000ef          	jal	c40 <exit>
        printf("grind: fork failed\n");
     43c:	00001517          	auipc	a0,0x1
     440:	f0450513          	addi	a0,a0,-252 # 1340 <malloc+0x206>
     444:	43f000ef          	jal	1082 <printf>
        exit(1);
     448:	4505                	li	a0,1
     44a:	7f6000ef          	jal	c40 <exit>
      if (pipe(fds) < 0) {
     44e:	f7840513          	addi	a0,s0,-136
     452:	7fe000ef          	jal	c50 <pipe>
     456:	02054363          	bltz	a0,47c <go+0x3d2>
      int pid = fork();
     45a:	7de000ef          	jal	c38 <fork>
      if (pid == 0) {
     45e:	c905                	beqz	a0,48e <go+0x3e4>
      } else if (pid < 0) {
     460:	08054263          	bltz	a0,4e4 <go+0x43a>
      close(fds[0]);
     464:	f7842503          	lw	a0,-136(s0)
     468:	001000ef          	jal	c68 <close>
      close(fds[1]);
     46c:	f7c42503          	lw	a0,-132(s0)
     470:	7f8000ef          	jal	c68 <close>
      wait(0);
     474:	4501                	li	a0,0
     476:	7d2000ef          	jal	c48 <wait>
     47a:	b309                	j	17c <go+0xd2>
        printf("grind: pipe failed\n");
     47c:	00001517          	auipc	a0,0x1
     480:	f0c50513          	addi	a0,a0,-244 # 1388 <malloc+0x24e>
     484:	3ff000ef          	jal	1082 <printf>
        exit(1);
     488:	4505                	li	a0,1
     48a:	7b6000ef          	jal	c40 <exit>
        fork();
     48e:	7aa000ef          	jal	c38 <fork>
        fork();
     492:	7a6000ef          	jal	c38 <fork>
        if (write(fds[1], "x", 1) != 1)
     496:	4605                	li	a2,1
     498:	00001597          	auipc	a1,0x1
     49c:	f0858593          	addi	a1,a1,-248 # 13a0 <malloc+0x266>
     4a0:	f7c42503          	lw	a0,-132(s0)
     4a4:	7bc000ef          	jal	c60 <write>
     4a8:	4785                	li	a5,1
     4aa:	00f51f63          	bne	a0,a5,4c8 <go+0x41e>
        if (read(fds[0], &c, 1) != 1)
     4ae:	4605                	li	a2,1
     4b0:	f7040593          	addi	a1,s0,-144
     4b4:	f7842503          	lw	a0,-136(s0)
     4b8:	7a0000ef          	jal	c58 <read>
     4bc:	4785                	li	a5,1
     4be:	00f51c63          	bne	a0,a5,4d6 <go+0x42c>
        exit(0);
     4c2:	4501                	li	a0,0
     4c4:	77c000ef          	jal	c40 <exit>
          printf("grind: pipe write failed\n");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	ee050513          	addi	a0,a0,-288 # 13a8 <malloc+0x26e>
     4d0:	3b3000ef          	jal	1082 <printf>
     4d4:	bfe9                	j	4ae <go+0x404>
          printf("grind: pipe read failed\n");
     4d6:	00001517          	auipc	a0,0x1
     4da:	ef250513          	addi	a0,a0,-270 # 13c8 <malloc+0x28e>
     4de:	3a5000ef          	jal	1082 <printf>
     4e2:	b7c5                	j	4c2 <go+0x418>
        printf("grind: fork failed\n");
     4e4:	00001517          	auipc	a0,0x1
     4e8:	e5c50513          	addi	a0,a0,-420 # 1340 <malloc+0x206>
     4ec:	397000ef          	jal	1082 <printf>
        exit(1);
     4f0:	4505                	li	a0,1
     4f2:	74e000ef          	jal	c40 <exit>
      int pid = fork();
     4f6:	742000ef          	jal	c38 <fork>
      if (pid == 0) {
     4fa:	c519                	beqz	a0,508 <go+0x45e>
      } else if (pid < 0) {
     4fc:	04054f63          	bltz	a0,55a <go+0x4b0>
      wait(0);
     500:	4501                	li	a0,0
     502:	746000ef          	jal	c48 <wait>
     506:	b99d                	j	17c <go+0xd2>
        unlink("a");
     508:	00001517          	auipc	a0,0x1
     50c:	e5050513          	addi	a0,a0,-432 # 1358 <malloc+0x21e>
     510:	780000ef          	jal	c90 <unlink>
        mkdir("a");
     514:	00001517          	auipc	a0,0x1
     518:	e4450513          	addi	a0,a0,-444 # 1358 <malloc+0x21e>
     51c:	78c000ef          	jal	ca8 <mkdir>
        chdir("a");
     520:	00001517          	auipc	a0,0x1
     524:	e3850513          	addi	a0,a0,-456 # 1358 <malloc+0x21e>
     528:	788000ef          	jal	cb0 <chdir>
        unlink("../a");
     52c:	00001517          	auipc	a0,0x1
     530:	ebc50513          	addi	a0,a0,-324 # 13e8 <malloc+0x2ae>
     534:	75c000ef          	jal	c90 <unlink>
        fd = open("x", O_CREATE | O_RDWR);
     538:	20200593          	li	a1,514
     53c:	00001517          	auipc	a0,0x1
     540:	e6450513          	addi	a0,a0,-412 # 13a0 <malloc+0x266>
     544:	73c000ef          	jal	c80 <open>
        unlink("x");
     548:	00001517          	auipc	a0,0x1
     54c:	e5850513          	addi	a0,a0,-424 # 13a0 <malloc+0x266>
     550:	740000ef          	jal	c90 <unlink>
        exit(0);
     554:	4501                	li	a0,0
     556:	6ea000ef          	jal	c40 <exit>
        printf("grind: fork failed\n");
     55a:	00001517          	auipc	a0,0x1
     55e:	de650513          	addi	a0,a0,-538 # 1340 <malloc+0x206>
     562:	321000ef          	jal	1082 <printf>
        exit(1);
     566:	4505                	li	a0,1
     568:	6d8000ef          	jal	c40 <exit>
      unlink("c");
     56c:	00001517          	auipc	a0,0x1
     570:	e8450513          	addi	a0,a0,-380 # 13f0 <malloc+0x2b6>
     574:	71c000ef          	jal	c90 <unlink>
      int fd1 = open("c", O_CREATE | O_RDWR);
     578:	20200593          	li	a1,514
     57c:	00001517          	auipc	a0,0x1
     580:	e7450513          	addi	a0,a0,-396 # 13f0 <malloc+0x2b6>
     584:	6fc000ef          	jal	c80 <open>
     588:	8d2a                	mv	s10,a0
      if (fd1 < 0) {
     58a:	04054563          	bltz	a0,5d4 <go+0x52a>
      if (write(fd1, "x", 1) != 1) {
     58e:	865e                	mv	a2,s7
     590:	00001597          	auipc	a1,0x1
     594:	e1058593          	addi	a1,a1,-496 # 13a0 <malloc+0x266>
     598:	6c8000ef          	jal	c60 <write>
     59c:	05751563          	bne	a0,s7,5e6 <go+0x53c>
      if (fstat(fd1, &st) != 0) {
     5a0:	f7840593          	addi	a1,s0,-136
     5a4:	856a                	mv	a0,s10
     5a6:	6f2000ef          	jal	c98 <fstat>
     5aa:	e539                	bnez	a0,5f8 <go+0x54e>
      if (st.size != 1) {
     5ac:	f8843583          	ld	a1,-120(s0)
     5b0:	05759d63          	bne	a1,s7,60a <go+0x560>
      if (st.ino > 200) {
     5b4:	f7c42583          	lw	a1,-132(s0)
     5b8:	0c800793          	li	a5,200
     5bc:	06b7e163          	bltu	a5,a1,61e <go+0x574>
      close(fd1);
     5c0:	856a                	mv	a0,s10
     5c2:	6a6000ef          	jal	c68 <close>
      unlink("c");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	e2a50513          	addi	a0,a0,-470 # 13f0 <malloc+0x2b6>
     5ce:	6c2000ef          	jal	c90 <unlink>
     5d2:	b66d                	j	17c <go+0xd2>
        printf("grind: create c failed\n");
     5d4:	00001517          	auipc	a0,0x1
     5d8:	e2450513          	addi	a0,a0,-476 # 13f8 <malloc+0x2be>
     5dc:	2a7000ef          	jal	1082 <printf>
        exit(1);
     5e0:	4505                	li	a0,1
     5e2:	65e000ef          	jal	c40 <exit>
        printf("grind: write c failed\n");
     5e6:	00001517          	auipc	a0,0x1
     5ea:	e2a50513          	addi	a0,a0,-470 # 1410 <malloc+0x2d6>
     5ee:	295000ef          	jal	1082 <printf>
        exit(1);
     5f2:	4505                	li	a0,1
     5f4:	64c000ef          	jal	c40 <exit>
        printf("grind: fstat failed\n");
     5f8:	00001517          	auipc	a0,0x1
     5fc:	e3050513          	addi	a0,a0,-464 # 1428 <malloc+0x2ee>
     600:	283000ef          	jal	1082 <printf>
        exit(1);
     604:	4505                	li	a0,1
     606:	63a000ef          	jal	c40 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     60a:	2581                	sext.w	a1,a1
     60c:	00001517          	auipc	a0,0x1
     610:	e3450513          	addi	a0,a0,-460 # 1440 <malloc+0x306>
     614:	26f000ef          	jal	1082 <printf>
        exit(1);
     618:	4505                	li	a0,1
     61a:	626000ef          	jal	c40 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     61e:	00001517          	auipc	a0,0x1
     622:	e4a50513          	addi	a0,a0,-438 # 1468 <malloc+0x32e>
     626:	25d000ef          	jal	1082 <printf>
        exit(1);
     62a:	4505                	li	a0,1
     62c:	614000ef          	jal	c40 <exit>
      if (pipe(aa) < 0) {
     630:	856e                	mv	a0,s11
     632:	61e000ef          	jal	c50 <pipe>
     636:	0c054263          	bltz	a0,6fa <go+0x650>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if (pipe(bb) < 0) {
     63a:	f7040513          	addi	a0,s0,-144
     63e:	612000ef          	jal	c50 <pipe>
     642:	0c054663          	bltz	a0,70e <go+0x664>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     646:	5f2000ef          	jal	c38 <fork>
      if (pid1 == 0) {
     64a:	0c050c63          	beqz	a0,722 <go+0x678>
        close(aa[1]);
        char *args[3] = {"echo", "hi", 0};
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if (pid1 < 0) {
     64e:	14054e63          	bltz	a0,7aa <go+0x700>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     652:	5e6000ef          	jal	c38 <fork>
      if (pid2 == 0) {
     656:	16050463          	beqz	a0,7be <go+0x714>
        close(bb[1]);
        char *args[2] = {"cat", 0};
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if (pid2 < 0) {
     65a:	20054263          	bltz	a0,85e <go+0x7b4>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     65e:	f6842503          	lw	a0,-152(s0)
     662:	606000ef          	jal	c68 <close>
      close(aa[1]);
     666:	f6c42503          	lw	a0,-148(s0)
     66a:	5fe000ef          	jal	c68 <close>
      close(bb[1]);
     66e:	f7442503          	lw	a0,-140(s0)
     672:	5f6000ef          	jal	c68 <close>
      char buf[4] = {0, 0, 0, 0};
     676:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf + 0, 1);
     67a:	865e                	mv	a2,s7
     67c:	f6040593          	addi	a1,s0,-160
     680:	f7042503          	lw	a0,-144(s0)
     684:	5d4000ef          	jal	c58 <read>
      read(bb[0], buf + 1, 1);
     688:	865e                	mv	a2,s7
     68a:	f6140593          	addi	a1,s0,-159
     68e:	f7042503          	lw	a0,-144(s0)
     692:	5c6000ef          	jal	c58 <read>
      read(bb[0], buf + 2, 1);
     696:	865e                	mv	a2,s7
     698:	f6240593          	addi	a1,s0,-158
     69c:	f7042503          	lw	a0,-144(s0)
     6a0:	5b8000ef          	jal	c58 <read>
      close(bb[0]);
     6a4:	f7042503          	lw	a0,-144(s0)
     6a8:	5c0000ef          	jal	c68 <close>
      int st1, st2;
      wait(&st1);
     6ac:	f6440513          	addi	a0,s0,-156
     6b0:	598000ef          	jal	c48 <wait>
      wait(&st2);
     6b4:	f7840513          	addi	a0,s0,-136
     6b8:	590000ef          	jal	c48 <wait>
      if (st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0) {
     6bc:	f6442783          	lw	a5,-156(s0)
     6c0:	f7842703          	lw	a4,-136(s0)
     6c4:	8fd9                	or	a5,a5,a4
     6c6:	eb99                	bnez	a5,6dc <go+0x632>
     6c8:	00001597          	auipc	a1,0x1
     6cc:	e4058593          	addi	a1,a1,-448 # 1508 <malloc+0x3ce>
     6d0:	f6040513          	addi	a0,s0,-160
     6d4:	2d4000ef          	jal	9a8 <strcmp>
     6d8:	aa0502e3          	beqz	a0,17c <go+0xd2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     6dc:	f6040693          	addi	a3,s0,-160
     6e0:	f7842603          	lw	a2,-136(s0)
     6e4:	f6442583          	lw	a1,-156(s0)
     6e8:	00001517          	auipc	a0,0x1
     6ec:	e2850513          	addi	a0,a0,-472 # 1510 <malloc+0x3d6>
     6f0:	193000ef          	jal	1082 <printf>
        exit(1);
     6f4:	4505                	li	a0,1
     6f6:	54a000ef          	jal	c40 <exit>
        fprintf(2, "grind: pipe failed\n");
     6fa:	00001597          	auipc	a1,0x1
     6fe:	c8e58593          	addi	a1,a1,-882 # 1388 <malloc+0x24e>
     702:	4509                	li	a0,2
     704:	155000ef          	jal	1058 <fprintf>
        exit(1);
     708:	4505                	li	a0,1
     70a:	536000ef          	jal	c40 <exit>
        fprintf(2, "grind: pipe failed\n");
     70e:	00001597          	auipc	a1,0x1
     712:	c7a58593          	addi	a1,a1,-902 # 1388 <malloc+0x24e>
     716:	4509                	li	a0,2
     718:	141000ef          	jal	1058 <fprintf>
        exit(1);
     71c:	4505                	li	a0,1
     71e:	522000ef          	jal	c40 <exit>
        close(bb[0]);
     722:	f7042503          	lw	a0,-144(s0)
     726:	542000ef          	jal	c68 <close>
        close(bb[1]);
     72a:	f7442503          	lw	a0,-140(s0)
     72e:	53a000ef          	jal	c68 <close>
        close(aa[0]);
     732:	f6842503          	lw	a0,-152(s0)
     736:	532000ef          	jal	c68 <close>
        close(1);
     73a:	4505                	li	a0,1
     73c:	52c000ef          	jal	c68 <close>
        if (dup(aa[1]) != 1) {
     740:	f6c42503          	lw	a0,-148(s0)
     744:	574000ef          	jal	cb8 <dup>
     748:	4785                	li	a5,1
     74a:	00f50c63          	beq	a0,a5,762 <go+0x6b8>
          fprintf(2, "grind: dup failed\n");
     74e:	00001597          	auipc	a1,0x1
     752:	d4258593          	addi	a1,a1,-702 # 1490 <malloc+0x356>
     756:	4509                	li	a0,2
     758:	101000ef          	jal	1058 <fprintf>
          exit(1);
     75c:	4505                	li	a0,1
     75e:	4e2000ef          	jal	c40 <exit>
        close(aa[1]);
     762:	f6c42503          	lw	a0,-148(s0)
     766:	502000ef          	jal	c68 <close>
        char *args[3] = {"echo", "hi", 0};
     76a:	00001797          	auipc	a5,0x1
     76e:	d3e78793          	addi	a5,a5,-706 # 14a8 <malloc+0x36e>
     772:	f6f43c23          	sd	a5,-136(s0)
     776:	00001797          	auipc	a5,0x1
     77a:	d3a78793          	addi	a5,a5,-710 # 14b0 <malloc+0x376>
     77e:	f8f43023          	sd	a5,-128(s0)
     782:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     786:	f7840593          	addi	a1,s0,-136
     78a:	00001517          	auipc	a0,0x1
     78e:	d2e50513          	addi	a0,a0,-722 # 14b8 <malloc+0x37e>
     792:	4e6000ef          	jal	c78 <exec>
        fprintf(2, "grind: echo: not found\n");
     796:	00001597          	auipc	a1,0x1
     79a:	d3258593          	addi	a1,a1,-718 # 14c8 <malloc+0x38e>
     79e:	4509                	li	a0,2
     7a0:	0b9000ef          	jal	1058 <fprintf>
        exit(2);
     7a4:	4509                	li	a0,2
     7a6:	49a000ef          	jal	c40 <exit>
        fprintf(2, "grind: fork failed\n");
     7aa:	00001597          	auipc	a1,0x1
     7ae:	b9658593          	addi	a1,a1,-1130 # 1340 <malloc+0x206>
     7b2:	4509                	li	a0,2
     7b4:	0a5000ef          	jal	1058 <fprintf>
        exit(3);
     7b8:	450d                	li	a0,3
     7ba:	486000ef          	jal	c40 <exit>
        close(aa[1]);
     7be:	f6c42503          	lw	a0,-148(s0)
     7c2:	4a6000ef          	jal	c68 <close>
        close(bb[0]);
     7c6:	f7042503          	lw	a0,-144(s0)
     7ca:	49e000ef          	jal	c68 <close>
        close(0);
     7ce:	4501                	li	a0,0
     7d0:	498000ef          	jal	c68 <close>
        if (dup(aa[0]) != 0) {
     7d4:	f6842503          	lw	a0,-152(s0)
     7d8:	4e0000ef          	jal	cb8 <dup>
     7dc:	c919                	beqz	a0,7f2 <go+0x748>
          fprintf(2, "grind: dup failed\n");
     7de:	00001597          	auipc	a1,0x1
     7e2:	cb258593          	addi	a1,a1,-846 # 1490 <malloc+0x356>
     7e6:	4509                	li	a0,2
     7e8:	071000ef          	jal	1058 <fprintf>
          exit(4);
     7ec:	4511                	li	a0,4
     7ee:	452000ef          	jal	c40 <exit>
        close(aa[0]);
     7f2:	f6842503          	lw	a0,-152(s0)
     7f6:	472000ef          	jal	c68 <close>
        close(1);
     7fa:	4505                	li	a0,1
     7fc:	46c000ef          	jal	c68 <close>
        if (dup(bb[1]) != 1) {
     800:	f7442503          	lw	a0,-140(s0)
     804:	4b4000ef          	jal	cb8 <dup>
     808:	4785                	li	a5,1
     80a:	00f50c63          	beq	a0,a5,822 <go+0x778>
          fprintf(2, "grind: dup failed\n");
     80e:	00001597          	auipc	a1,0x1
     812:	c8258593          	addi	a1,a1,-894 # 1490 <malloc+0x356>
     816:	4509                	li	a0,2
     818:	041000ef          	jal	1058 <fprintf>
          exit(5);
     81c:	4515                	li	a0,5
     81e:	422000ef          	jal	c40 <exit>
        close(bb[1]);
     822:	f7442503          	lw	a0,-140(s0)
     826:	442000ef          	jal	c68 <close>
        char *args[2] = {"cat", 0};
     82a:	00001797          	auipc	a5,0x1
     82e:	cb678793          	addi	a5,a5,-842 # 14e0 <malloc+0x3a6>
     832:	f6f43c23          	sd	a5,-136(s0)
     836:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     83a:	f7840593          	addi	a1,s0,-136
     83e:	00001517          	auipc	a0,0x1
     842:	caa50513          	addi	a0,a0,-854 # 14e8 <malloc+0x3ae>
     846:	432000ef          	jal	c78 <exec>
        fprintf(2, "grind: cat: not found\n");
     84a:	00001597          	auipc	a1,0x1
     84e:	ca658593          	addi	a1,a1,-858 # 14f0 <malloc+0x3b6>
     852:	4509                	li	a0,2
     854:	005000ef          	jal	1058 <fprintf>
        exit(6);
     858:	4519                	li	a0,6
     85a:	3e6000ef          	jal	c40 <exit>
        fprintf(2, "grind: fork failed\n");
     85e:	00001597          	auipc	a1,0x1
     862:	ae258593          	addi	a1,a1,-1310 # 1340 <malloc+0x206>
     866:	4509                	li	a0,2
     868:	7f0000ef          	jal	1058 <fprintf>
        exit(7);
     86c:	451d                	li	a0,7
     86e:	3d2000ef          	jal	c40 <exit>

0000000000000872 <iter>:
  }
}

void
iter()
{
     872:	7179                	addi	sp,sp,-48
     874:	f406                	sd	ra,40(sp)
     876:	f022                	sd	s0,32(sp)
     878:	1800                	addi	s0,sp,48
  unlink("a");
     87a:	00001517          	auipc	a0,0x1
     87e:	ade50513          	addi	a0,a0,-1314 # 1358 <malloc+0x21e>
     882:	40e000ef          	jal	c90 <unlink>
  unlink("b");
     886:	00001517          	auipc	a0,0x1
     88a:	a8250513          	addi	a0,a0,-1406 # 1308 <malloc+0x1ce>
     88e:	402000ef          	jal	c90 <unlink>

  int pid1 = fork();
     892:	3a6000ef          	jal	c38 <fork>
  if (pid1 < 0) {
     896:	02054163          	bltz	a0,8b8 <iter+0x46>
     89a:	ec26                	sd	s1,24(sp)
     89c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid1 == 0) {
     89e:	e905                	bnez	a0,8ce <iter+0x5c>
     8a0:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     8a2:	00001717          	auipc	a4,0x1
     8a6:	75e70713          	addi	a4,a4,1886 # 2000 <rand_next>
     8aa:	631c                	ld	a5,0(a4)
     8ac:	01f7c793          	xori	a5,a5,31
     8b0:	e31c                	sd	a5,0(a4)
    go(0);
     8b2:	4501                	li	a0,0
     8b4:	ff6ff0ef          	jal	aa <go>
     8b8:	ec26                	sd	s1,24(sp)
     8ba:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	a8450513          	addi	a0,a0,-1404 # 1340 <malloc+0x206>
     8c4:	7be000ef          	jal	1082 <printf>
    exit(1);
     8c8:	4505                	li	a0,1
     8ca:	376000ef          	jal	c40 <exit>
     8ce:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     8d0:	368000ef          	jal	c38 <fork>
     8d4:	892a                	mv	s2,a0
  if (pid2 < 0) {
     8d6:	02054063          	bltz	a0,8f6 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if (pid2 == 0) {
     8da:	e51d                	bnez	a0,908 <iter+0x96>
    rand_next ^= 7177;
     8dc:	00001697          	auipc	a3,0x1
     8e0:	72468693          	addi	a3,a3,1828 # 2000 <rand_next>
     8e4:	629c                	ld	a5,0(a3)
     8e6:	6709                	lui	a4,0x2
     8e8:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x669>
     8ec:	8fb9                	xor	a5,a5,a4
     8ee:	e29c                	sd	a5,0(a3)
    go(1);
     8f0:	4505                	li	a0,1
     8f2:	fb8ff0ef          	jal	aa <go>
    printf("grind: fork failed\n");
     8f6:	00001517          	auipc	a0,0x1
     8fa:	a4a50513          	addi	a0,a0,-1462 # 1340 <malloc+0x206>
     8fe:	784000ef          	jal	1082 <printf>
    exit(1);
     902:	4505                	li	a0,1
     904:	33c000ef          	jal	c40 <exit>
    exit(0);
  }

  int st1 = -1;
     908:	57fd                	li	a5,-1
     90a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     90e:	fdc40513          	addi	a0,s0,-36
     912:	336000ef          	jal	c48 <wait>
  if (st1 != 0) {
     916:	fdc42783          	lw	a5,-36(s0)
     91a:	eb99                	bnez	a5,930 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     91c:	57fd                	li	a5,-1
     91e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     922:	fd840513          	addi	a0,s0,-40
     926:	322000ef          	jal	c48 <wait>

  exit(0);
     92a:	4501                	li	a0,0
     92c:	314000ef          	jal	c40 <exit>
    kill(pid1);
     930:	8526                	mv	a0,s1
     932:	33e000ef          	jal	c70 <kill>
    kill(pid2);
     936:	854a                	mv	a0,s2
     938:	338000ef          	jal	c70 <kill>
     93c:	b7c5                	j	91c <iter+0xaa>

000000000000093e <main>:
}

int
main()
{
     93e:	1101                	addi	sp,sp,-32
     940:	ec06                	sd	ra,24(sp)
     942:	e822                	sd	s0,16(sp)
     944:	e426                	sd	s1,8(sp)
     946:	e04a                	sd	s2,0(sp)
     948:	1000                	addi	s0,sp,32
      exit(0);
    }
    if (pid > 0) {
      wait(0);
    }
    pause(20);
     94a:	4951                	li	s2,20
    rand_next += 1;
     94c:	00001497          	auipc	s1,0x1
     950:	6b448493          	addi	s1,s1,1716 # 2000 <rand_next>
     954:	a809                	j	966 <main+0x28>
      iter();
     956:	f1dff0ef          	jal	872 <iter>
    pause(20);
     95a:	854a                	mv	a0,s2
     95c:	374000ef          	jal	cd0 <pause>
    rand_next += 1;
     960:	609c                	ld	a5,0(s1)
     962:	0785                	addi	a5,a5,1
     964:	e09c                	sd	a5,0(s1)
    int pid = fork();
     966:	2d2000ef          	jal	c38 <fork>
    if (pid == 0) {
     96a:	d575                	beqz	a0,956 <main+0x18>
    if (pid > 0) {
     96c:	fea057e3          	blez	a0,95a <main+0x1c>
      wait(0);
     970:	4501                	li	a0,0
     972:	2d6000ef          	jal	c48 <wait>
     976:	b7d5                	j	95a <main+0x1c>

0000000000000978 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     978:	1141                	addi	sp,sp,-16
     97a:	e406                	sd	ra,8(sp)
     97c:	e022                	sd	s0,0(sp)
     97e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     980:	fbfff0ef          	jal	93e <main>
  exit(r);
     984:	2bc000ef          	jal	c40 <exit>

0000000000000988 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     988:	1141                	addi	sp,sp,-16
     98a:	e406                	sd	ra,8(sp)
     98c:	e022                	sd	s0,0(sp)
     98e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
     990:	87aa                	mv	a5,a0
     992:	0585                	addi	a1,a1,1
     994:	0785                	addi	a5,a5,1
     996:	fff5c703          	lbu	a4,-1(a1)
     99a:	fee78fa3          	sb	a4,-1(a5)
     99e:	fb75                	bnez	a4,992 <strcpy+0xa>
    ;
  return os;
}
     9a0:	60a2                	ld	ra,8(sp)
     9a2:	6402                	ld	s0,0(sp)
     9a4:	0141                	addi	sp,sp,16
     9a6:	8082                	ret

00000000000009a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9a8:	1141                	addi	sp,sp,-16
     9aa:	e406                	sd	ra,8(sp)
     9ac:	e022                	sd	s0,0(sp)
     9ae:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
     9b0:	00054783          	lbu	a5,0(a0)
     9b4:	cb91                	beqz	a5,9c8 <strcmp+0x20>
     9b6:	0005c703          	lbu	a4,0(a1)
     9ba:	00f71763          	bne	a4,a5,9c8 <strcmp+0x20>
    p++, q++;
     9be:	0505                	addi	a0,a0,1
     9c0:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
     9c2:	00054783          	lbu	a5,0(a0)
     9c6:	fbe5                	bnez	a5,9b6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9c8:	0005c503          	lbu	a0,0(a1)
}
     9cc:	40a7853b          	subw	a0,a5,a0
     9d0:	60a2                	ld	ra,8(sp)
     9d2:	6402                	ld	s0,0(sp)
     9d4:	0141                	addi	sp,sp,16
     9d6:	8082                	ret

00000000000009d8 <strlen>:

uint
strlen(const char *s)
{
     9d8:	1141                	addi	sp,sp,-16
     9da:	e406                	sd	ra,8(sp)
     9dc:	e022                	sd	s0,0(sp)
     9de:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
     9e0:	00054783          	lbu	a5,0(a0)
     9e4:	cf99                	beqz	a5,a02 <strlen+0x2a>
     9e6:	0505                	addi	a0,a0,1
     9e8:	87aa                	mv	a5,a0
     9ea:	86be                	mv	a3,a5
     9ec:	0785                	addi	a5,a5,1
     9ee:	fff7c703          	lbu	a4,-1(a5)
     9f2:	ff65                	bnez	a4,9ea <strlen+0x12>
     9f4:	40a6853b          	subw	a0,a3,a0
     9f8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     9fa:	60a2                	ld	ra,8(sp)
     9fc:	6402                	ld	s0,0(sp)
     9fe:	0141                	addi	sp,sp,16
     a00:	8082                	ret
  for (n = 0; s[n]; n++)
     a02:	4501                	li	a0,0
     a04:	bfdd                	j	9fa <strlen+0x22>

0000000000000a06 <memset>:

void *
memset(void *dst, int c, uint n)
{
     a06:	1141                	addi	sp,sp,-16
     a08:	e406                	sd	ra,8(sp)
     a0a:	e022                	sd	s0,0(sp)
     a0c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     a0e:	ca19                	beqz	a2,a24 <memset+0x1e>
     a10:	87aa                	mv	a5,a0
     a12:	1602                	slli	a2,a2,0x20
     a14:	9201                	srli	a2,a2,0x20
     a16:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a1a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     a1e:	0785                	addi	a5,a5,1
     a20:	fee79de3          	bne	a5,a4,a1a <memset+0x14>
  }
  return dst;
}
     a24:	60a2                	ld	ra,8(sp)
     a26:	6402                	ld	s0,0(sp)
     a28:	0141                	addi	sp,sp,16
     a2a:	8082                	ret

0000000000000a2c <strchr>:

char *
strchr(const char *s, char c)
{
     a2c:	1141                	addi	sp,sp,-16
     a2e:	e406                	sd	ra,8(sp)
     a30:	e022                	sd	s0,0(sp)
     a32:	0800                	addi	s0,sp,16
  for (; *s; s++)
     a34:	00054783          	lbu	a5,0(a0)
     a38:	cf81                	beqz	a5,a50 <strchr+0x24>
    if (*s == c)
     a3a:	00f58763          	beq	a1,a5,a48 <strchr+0x1c>
  for (; *s; s++)
     a3e:	0505                	addi	a0,a0,1
     a40:	00054783          	lbu	a5,0(a0)
     a44:	fbfd                	bnez	a5,a3a <strchr+0xe>
      return (char *)s;
  return 0;
     a46:	4501                	li	a0,0
}
     a48:	60a2                	ld	ra,8(sp)
     a4a:	6402                	ld	s0,0(sp)
     a4c:	0141                	addi	sp,sp,16
     a4e:	8082                	ret
  return 0;
     a50:	4501                	li	a0,0
     a52:	bfdd                	j	a48 <strchr+0x1c>

0000000000000a54 <gets>:

char *
gets(char *buf, int max)
{
     a54:	7159                	addi	sp,sp,-112
     a56:	f486                	sd	ra,104(sp)
     a58:	f0a2                	sd	s0,96(sp)
     a5a:	eca6                	sd	s1,88(sp)
     a5c:	e8ca                	sd	s2,80(sp)
     a5e:	e4ce                	sd	s3,72(sp)
     a60:	e0d2                	sd	s4,64(sp)
     a62:	fc56                	sd	s5,56(sp)
     a64:	f85a                	sd	s6,48(sp)
     a66:	f45e                	sd	s7,40(sp)
     a68:	f062                	sd	s8,32(sp)
     a6a:	ec66                	sd	s9,24(sp)
     a6c:	e86a                	sd	s10,16(sp)
     a6e:	1880                	addi	s0,sp,112
     a70:	8caa                	mv	s9,a0
     a72:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     a74:	892a                	mv	s2,a0
     a76:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a78:	f9f40b13          	addi	s6,s0,-97
     a7c:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
     a7e:	4ba9                	li	s7,10
     a80:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
     a82:	8d26                	mv	s10,s1
     a84:	0014899b          	addiw	s3,s1,1
     a88:	84ce                	mv	s1,s3
     a8a:	0349d563          	bge	s3,s4,ab4 <gets+0x60>
    cc = read(0, &c, 1);
     a8e:	8656                	mv	a2,s5
     a90:	85da                	mv	a1,s6
     a92:	4501                	li	a0,0
     a94:	1c4000ef          	jal	c58 <read>
    if (cc < 1)
     a98:	00a05e63          	blez	a0,ab4 <gets+0x60>
    buf[i++] = c;
     a9c:	f9f44783          	lbu	a5,-97(s0)
     aa0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
     aa4:	01778763          	beq	a5,s7,ab2 <gets+0x5e>
     aa8:	0905                	addi	s2,s2,1
     aaa:	fd879ce3          	bne	a5,s8,a82 <gets+0x2e>
    buf[i++] = c;
     aae:	8d4e                	mv	s10,s3
     ab0:	a011                	j	ab4 <gets+0x60>
     ab2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     ab4:	9d66                	add	s10,s10,s9
     ab6:	000d0023          	sb	zero,0(s10)
  return buf;
}
     aba:	8566                	mv	a0,s9
     abc:	70a6                	ld	ra,104(sp)
     abe:	7406                	ld	s0,96(sp)
     ac0:	64e6                	ld	s1,88(sp)
     ac2:	6946                	ld	s2,80(sp)
     ac4:	69a6                	ld	s3,72(sp)
     ac6:	6a06                	ld	s4,64(sp)
     ac8:	7ae2                	ld	s5,56(sp)
     aca:	7b42                	ld	s6,48(sp)
     acc:	7ba2                	ld	s7,40(sp)
     ace:	7c02                	ld	s8,32(sp)
     ad0:	6ce2                	ld	s9,24(sp)
     ad2:	6d42                	ld	s10,16(sp)
     ad4:	6165                	addi	sp,sp,112
     ad6:	8082                	ret

0000000000000ad8 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad8:	1101                	addi	sp,sp,-32
     ada:	ec06                	sd	ra,24(sp)
     adc:	e822                	sd	s0,16(sp)
     ade:	e04a                	sd	s2,0(sp)
     ae0:	1000                	addi	s0,sp,32
     ae2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae4:	4581                	li	a1,0
     ae6:	19a000ef          	jal	c80 <open>
  if (fd < 0)
     aea:	02054263          	bltz	a0,b0e <stat+0x36>
     aee:	e426                	sd	s1,8(sp)
     af0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af2:	85ca                	mv	a1,s2
     af4:	1a4000ef          	jal	c98 <fstat>
     af8:	892a                	mv	s2,a0
  close(fd);
     afa:	8526                	mv	a0,s1
     afc:	16c000ef          	jal	c68 <close>
  return r;
     b00:	64a2                	ld	s1,8(sp)
}
     b02:	854a                	mv	a0,s2
     b04:	60e2                	ld	ra,24(sp)
     b06:	6442                	ld	s0,16(sp)
     b08:	6902                	ld	s2,0(sp)
     b0a:	6105                	addi	sp,sp,32
     b0c:	8082                	ret
    return -1;
     b0e:	597d                	li	s2,-1
     b10:	bfcd                	j	b02 <stat+0x2a>

0000000000000b12 <atoi>:

int
atoi(const char *s)
{
     b12:	1141                	addi	sp,sp,-16
     b14:	e406                	sd	ra,8(sp)
     b16:	e022                	sd	s0,0(sp)
     b18:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
     b1a:	00054683          	lbu	a3,0(a0)
     b1e:	fd06879b          	addiw	a5,a3,-48
     b22:	0ff7f793          	zext.b	a5,a5
     b26:	4625                	li	a2,9
     b28:	02f66963          	bltu	a2,a5,b5a <atoi+0x48>
     b2c:	872a                	mv	a4,a0
  n = 0;
     b2e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
     b30:	0705                	addi	a4,a4,1
     b32:	0025179b          	slliw	a5,a0,0x2
     b36:	9fa9                	addw	a5,a5,a0
     b38:	0017979b          	slliw	a5,a5,0x1
     b3c:	9fb5                	addw	a5,a5,a3
     b3e:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
     b42:	00074683          	lbu	a3,0(a4)
     b46:	fd06879b          	addiw	a5,a3,-48
     b4a:	0ff7f793          	zext.b	a5,a5
     b4e:	fef671e3          	bgeu	a2,a5,b30 <atoi+0x1e>
  return n;
}
     b52:	60a2                	ld	ra,8(sp)
     b54:	6402                	ld	s0,0(sp)
     b56:	0141                	addi	sp,sp,16
     b58:	8082                	ret
  n = 0;
     b5a:	4501                	li	a0,0
     b5c:	bfdd                	j	b52 <atoi+0x40>

0000000000000b5e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     b5e:	1141                	addi	sp,sp,-16
     b60:	e406                	sd	ra,8(sp)
     b62:	e022                	sd	s0,0(sp)
     b64:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b66:	02b57563          	bgeu	a0,a1,b90 <memmove+0x32>
    while (n-- > 0)
     b6a:	00c05f63          	blez	a2,b88 <memmove+0x2a>
     b6e:	1602                	slli	a2,a2,0x20
     b70:	9201                	srli	a2,a2,0x20
     b72:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b76:	872a                	mv	a4,a0
      *dst++ = *src++;
     b78:	0585                	addi	a1,a1,1
     b7a:	0705                	addi	a4,a4,1
     b7c:	fff5c683          	lbu	a3,-1(a1)
     b80:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
     b84:	fee79ae3          	bne	a5,a4,b78 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b88:	60a2                	ld	ra,8(sp)
     b8a:	6402                	ld	s0,0(sp)
     b8c:	0141                	addi	sp,sp,16
     b8e:	8082                	ret
    dst += n;
     b90:	00c50733          	add	a4,a0,a2
    src += n;
     b94:	95b2                	add	a1,a1,a2
    while (n-- > 0)
     b96:	fec059e3          	blez	a2,b88 <memmove+0x2a>
     b9a:	fff6079b          	addiw	a5,a2,-1
     b9e:	1782                	slli	a5,a5,0x20
     ba0:	9381                	srli	a5,a5,0x20
     ba2:	fff7c793          	not	a5,a5
     ba6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ba8:	15fd                	addi	a1,a1,-1
     baa:	177d                	addi	a4,a4,-1
     bac:	0005c683          	lbu	a3,0(a1)
     bb0:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
     bb4:	fef71ae3          	bne	a4,a5,ba8 <memmove+0x4a>
     bb8:	bfc1                	j	b88 <memmove+0x2a>

0000000000000bba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bba:	1141                	addi	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bc2:	ca0d                	beqz	a2,bf4 <memcmp+0x3a>
     bc4:	fff6069b          	addiw	a3,a2,-1
     bc8:	1682                	slli	a3,a3,0x20
     bca:	9281                	srli	a3,a3,0x20
     bcc:	0685                	addi	a3,a3,1
     bce:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bd0:	00054783          	lbu	a5,0(a0)
     bd4:	0005c703          	lbu	a4,0(a1)
     bd8:	00e79863          	bne	a5,a4,be8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     bdc:	0505                	addi	a0,a0,1
    p2++;
     bde:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     be0:	fed518e3          	bne	a0,a3,bd0 <memcmp+0x16>
  }
  return 0;
     be4:	4501                	li	a0,0
     be6:	a019                	j	bec <memcmp+0x32>
      return *p1 - *p2;
     be8:	40e7853b          	subw	a0,a5,a4
}
     bec:	60a2                	ld	ra,8(sp)
     bee:	6402                	ld	s0,0(sp)
     bf0:	0141                	addi	sp,sp,16
     bf2:	8082                	ret
  return 0;
     bf4:	4501                	li	a0,0
     bf6:	bfdd                	j	bec <memcmp+0x32>

0000000000000bf8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bf8:	1141                	addi	sp,sp,-16
     bfa:	e406                	sd	ra,8(sp)
     bfc:	e022                	sd	s0,0(sp)
     bfe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c00:	f5fff0ef          	jal	b5e <memmove>
}
     c04:	60a2                	ld	ra,8(sp)
     c06:	6402                	ld	s0,0(sp)
     c08:	0141                	addi	sp,sp,16
     c0a:	8082                	ret

0000000000000c0c <sbrk>:

char *
sbrk(int n)
{
     c0c:	1141                	addi	sp,sp,-16
     c0e:	e406                	sd	ra,8(sp)
     c10:	e022                	sd	s0,0(sp)
     c12:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c14:	4585                	li	a1,1
     c16:	0b2000ef          	jal	cc8 <sys_sbrk>
}
     c1a:	60a2                	ld	ra,8(sp)
     c1c:	6402                	ld	s0,0(sp)
     c1e:	0141                	addi	sp,sp,16
     c20:	8082                	ret

0000000000000c22 <sbrklazy>:

char *
sbrklazy(int n)
{
     c22:	1141                	addi	sp,sp,-16
     c24:	e406                	sd	ra,8(sp)
     c26:	e022                	sd	s0,0(sp)
     c28:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c2a:	4589                	li	a1,2
     c2c:	09c000ef          	jal	cc8 <sys_sbrk>
}
     c30:	60a2                	ld	ra,8(sp)
     c32:	6402                	ld	s0,0(sp)
     c34:	0141                	addi	sp,sp,16
     c36:	8082                	ret

0000000000000c38 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c38:	4885                	li	a7,1
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c40:	4889                	li	a7,2
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c48:	488d                	li	a7,3
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c50:	4891                	li	a7,4
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <read>:
.global read
read:
 li a7, SYS_read
     c58:	4895                	li	a7,5
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <write>:
.global write
write:
 li a7, SYS_write
     c60:	48c1                	li	a7,16
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <close>:
.global close
close:
 li a7, SYS_close
     c68:	48d5                	li	a7,21
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c70:	4899                	li	a7,6
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c78:	489d                	li	a7,7
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <open>:
.global open
open:
 li a7, SYS_open
     c80:	48bd                	li	a7,15
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c88:	48c5                	li	a7,17
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c90:	48c9                	li	a7,18
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c98:	48a1                	li	a7,8
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <link>:
.global link
link:
 li a7, SYS_link
     ca0:	48cd                	li	a7,19
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ca8:	48d1                	li	a7,20
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cb0:	48a5                	li	a7,9
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cb8:	48a9                	li	a7,10
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     cc0:	48ad                	li	a7,11
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     cc8:	48b1                	li	a7,12
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <pause>:
.global pause
pause:
 li a7, SYS_pause
     cd0:	48b5                	li	a7,13
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cd8:	48b9                	li	a7,14
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <sync>:
.global sync
sync:
 li a7, SYS_sync
     ce0:	48d9                	li	a7,22
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <ps>:
.global ps
ps:
 li a7, SYS_ps
     ce8:	48dd                	li	a7,23
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
     cf0:	48e1                	li	a7,24
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     cf8:	48e5                	li	a7,25
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     d00:	48e9                	li	a7,26
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d08:	1101                	addi	sp,sp,-32
     d0a:	ec06                	sd	ra,24(sp)
     d0c:	e822                	sd	s0,16(sp)
     d0e:	1000                	addi	s0,sp,32
     d10:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d14:	4605                	li	a2,1
     d16:	fef40593          	addi	a1,s0,-17
     d1a:	f47ff0ef          	jal	c60 <write>
}
     d1e:	60e2                	ld	ra,24(sp)
     d20:	6442                	ld	s0,16(sp)
     d22:	6105                	addi	sp,sp,32
     d24:	8082                	ret

0000000000000d26 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d26:	715d                	addi	sp,sp,-80
     d28:	e486                	sd	ra,72(sp)
     d2a:	e0a2                	sd	s0,64(sp)
     d2c:	fc26                	sd	s1,56(sp)
     d2e:	f84a                	sd	s2,48(sp)
     d30:	f44e                	sd	s3,40(sp)
     d32:	0880                	addi	s0,sp,80
     d34:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
     d36:	c299                	beqz	a3,d3c <printint+0x16>
     d38:	0605cc63          	bltz	a1,db0 <printint+0x8a>
  neg = 0;
     d3c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d3e:	fb840313          	addi	t1,s0,-72
  neg = 0;
     d42:	869a                	mv	a3,t1
  i = 0;
     d44:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
     d46:	00001817          	auipc	a6,0x1
     d4a:	85a80813          	addi	a6,a6,-1958 # 15a0 <digits>
     d4e:	88be                	mv	a7,a5
     d50:	0017851b          	addiw	a0,a5,1
     d54:	87aa                	mv	a5,a0
     d56:	02c5f733          	remu	a4,a1,a2
     d5a:	9742                	add	a4,a4,a6
     d5c:	00074703          	lbu	a4,0(a4)
     d60:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
     d64:	872e                	mv	a4,a1
     d66:	02c5d5b3          	divu	a1,a1,a2
     d6a:	0685                	addi	a3,a3,1
     d6c:	fec771e3          	bgeu	a4,a2,d4e <printint+0x28>
  if (neg)
     d70:	000e0c63          	beqz	t3,d88 <printint+0x62>
    buf[i++] = '-';
     d74:	fd050793          	addi	a5,a0,-48
     d78:	00878533          	add	a0,a5,s0
     d7c:	02d00793          	li	a5,45
     d80:	fef50423          	sb	a5,-24(a0)
     d84:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
     d88:	fff7899b          	addiw	s3,a5,-1
     d8c:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     d90:	fff4c583          	lbu	a1,-1(s1)
     d94:	854a                	mv	a0,s2
     d96:	f73ff0ef          	jal	d08 <putc>
  while (--i >= 0)
     d9a:	39fd                	addiw	s3,s3,-1
     d9c:	14fd                	addi	s1,s1,-1
     d9e:	fe09d9e3          	bgez	s3,d90 <printint+0x6a>
}
     da2:	60a6                	ld	ra,72(sp)
     da4:	6406                	ld	s0,64(sp)
     da6:	74e2                	ld	s1,56(sp)
     da8:	7942                	ld	s2,48(sp)
     daa:	79a2                	ld	s3,40(sp)
     dac:	6161                	addi	sp,sp,80
     dae:	8082                	ret
    x = -xx;
     db0:	40b005b3          	neg	a1,a1
    neg = 1;
     db4:	4e05                	li	t3,1
    x = -xx;
     db6:	b761                	j	d3e <printint+0x18>

0000000000000db8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     db8:	711d                	addi	sp,sp,-96
     dba:	ec86                	sd	ra,88(sp)
     dbc:	e8a2                	sd	s0,80(sp)
     dbe:	e4a6                	sd	s1,72(sp)
     dc0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     dc2:	0005c483          	lbu	s1,0(a1)
     dc6:	28048463          	beqz	s1,104e <vprintf+0x296>
     dca:	e0ca                	sd	s2,64(sp)
     dcc:	fc4e                	sd	s3,56(sp)
     dce:	f852                	sd	s4,48(sp)
     dd0:	f456                	sd	s5,40(sp)
     dd2:	f05a                	sd	s6,32(sp)
     dd4:	ec5e                	sd	s7,24(sp)
     dd6:	e862                	sd	s8,16(sp)
     dd8:	e466                	sd	s9,8(sp)
     dda:	8b2a                	mv	s6,a0
     ddc:	8a2e                	mv	s4,a1
     dde:	8bb2                	mv	s7,a2
  state = 0;
     de0:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
     de2:	4901                	li	s2,0
     de4:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
     de6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
     dea:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
     dee:	06c00c93          	li	s9,108
     df2:	a00d                	j	e14 <vprintf+0x5c>
        putc(fd, c0);
     df4:	85a6                	mv	a1,s1
     df6:	855a                	mv	a0,s6
     df8:	f11ff0ef          	jal	d08 <putc>
     dfc:	a019                	j	e02 <vprintf+0x4a>
    } else if (state == '%') {
     dfe:	03598363          	beq	s3,s5,e24 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
     e02:	0019079b          	addiw	a5,s2,1
     e06:	893e                	mv	s2,a5
     e08:	873e                	mv	a4,a5
     e0a:	97d2                	add	a5,a5,s4
     e0c:	0007c483          	lbu	s1,0(a5)
     e10:	22048763          	beqz	s1,103e <vprintf+0x286>
    c0 = fmt[i] & 0xff;
     e14:	0004879b          	sext.w	a5,s1
    if (state == 0) {
     e18:	fe0993e3          	bnez	s3,dfe <vprintf+0x46>
      if (c0 == '%') {
     e1c:	fd579ce3          	bne	a5,s5,df4 <vprintf+0x3c>
        state = '%';
     e20:	89be                	mv	s3,a5
     e22:	b7c5                	j	e02 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
     e24:	00ea06b3          	add	a3,s4,a4
     e28:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e2c:	8636                	mv	a2,a3
      if (c1)
     e2e:	c681                	beqz	a3,e36 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
     e30:	9752                	add	a4,a4,s4
     e32:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
     e36:	05878263          	beq	a5,s8,e7a <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
     e3a:	05978c63          	beq	a5,s9,e92 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
     e3e:	07500713          	li	a4,117
     e42:	0ee78663          	beq	a5,a4,f2e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
     e46:	07800713          	li	a4,120
     e4a:	12e78863          	beq	a5,a4,f7a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
     e4e:	07000713          	li	a4,112
     e52:	14e78d63          	beq	a5,a4,fac <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
     e56:	06300713          	li	a4,99
     e5a:	18e78c63          	beq	a5,a4,ff2 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
     e5e:	07300713          	li	a4,115
     e62:	1ae78263          	beq	a5,a4,1006 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
     e66:	02500713          	li	a4,37
     e6a:	04e79463          	bne	a5,a4,eb2 <vprintf+0xfa>
        putc(fd, '%');
     e6e:	85ba                	mv	a1,a4
     e70:	855a                	mv	a0,s6
     e72:	e97ff0ef          	jal	d08 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e76:	4981                	li	s3,0
     e78:	b769                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     e7a:	008b8493          	addi	s1,s7,8
     e7e:	4685                	li	a3,1
     e80:	4629                	li	a2,10
     e82:	000ba583          	lw	a1,0(s7)
     e86:	855a                	mv	a0,s6
     e88:	e9fff0ef          	jal	d26 <printint>
     e8c:	8ba6                	mv	s7,s1
      state = 0;
     e8e:	4981                	li	s3,0
     e90:	bf8d                	j	e02 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
     e92:	06400793          	li	a5,100
     e96:	02f68963          	beq	a3,a5,ec8 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     e9a:	06c00793          	li	a5,108
     e9e:	04f68263          	beq	a3,a5,ee2 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
     ea2:	07500793          	li	a5,117
     ea6:	0af68063          	beq	a3,a5,f46 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
     eaa:	07800793          	li	a5,120
     eae:	0ef68263          	beq	a3,a5,f92 <vprintf+0x1da>
        putc(fd, '%');
     eb2:	02500593          	li	a1,37
     eb6:	855a                	mv	a0,s6
     eb8:	e51ff0ef          	jal	d08 <putc>
        putc(fd, c0);
     ebc:	85a6                	mv	a1,s1
     ebe:	855a                	mv	a0,s6
     ec0:	e49ff0ef          	jal	d08 <putc>
      state = 0;
     ec4:	4981                	li	s3,0
     ec6:	bf35                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ec8:	008b8493          	addi	s1,s7,8
     ecc:	4685                	li	a3,1
     ece:	4629                	li	a2,10
     ed0:	000bb583          	ld	a1,0(s7)
     ed4:	855a                	mv	a0,s6
     ed6:	e51ff0ef          	jal	d26 <printint>
        i += 1;
     eda:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     edc:	8ba6                	mv	s7,s1
      state = 0;
     ede:	4981                	li	s3,0
        i += 1;
     ee0:	b70d                	j	e02 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     ee2:	06400793          	li	a5,100
     ee6:	02f60763          	beq	a2,a5,f14 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
     eea:	07500793          	li	a5,117
     eee:	06f60963          	beq	a2,a5,f60 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
     ef2:	07800793          	li	a5,120
     ef6:	faf61ee3          	bne	a2,a5,eb2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     efa:	008b8493          	addi	s1,s7,8
     efe:	4681                	li	a3,0
     f00:	4641                	li	a2,16
     f02:	000bb583          	ld	a1,0(s7)
     f06:	855a                	mv	a0,s6
     f08:	e1fff0ef          	jal	d26 <printint>
        i += 2;
     f0c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f0e:	8ba6                	mv	s7,s1
      state = 0;
     f10:	4981                	li	s3,0
        i += 2;
     f12:	bdc5                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f14:	008b8493          	addi	s1,s7,8
     f18:	4685                	li	a3,1
     f1a:	4629                	li	a2,10
     f1c:	000bb583          	ld	a1,0(s7)
     f20:	855a                	mv	a0,s6
     f22:	e05ff0ef          	jal	d26 <printint>
        i += 2;
     f26:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f28:	8ba6                	mv	s7,s1
      state = 0;
     f2a:	4981                	li	s3,0
        i += 2;
     f2c:	bdd9                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f2e:	008b8493          	addi	s1,s7,8
     f32:	4681                	li	a3,0
     f34:	4629                	li	a2,10
     f36:	000be583          	lwu	a1,0(s7)
     f3a:	855a                	mv	a0,s6
     f3c:	debff0ef          	jal	d26 <printint>
     f40:	8ba6                	mv	s7,s1
      state = 0;
     f42:	4981                	li	s3,0
     f44:	bd7d                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f46:	008b8493          	addi	s1,s7,8
     f4a:	4681                	li	a3,0
     f4c:	4629                	li	a2,10
     f4e:	000bb583          	ld	a1,0(s7)
     f52:	855a                	mv	a0,s6
     f54:	dd3ff0ef          	jal	d26 <printint>
        i += 1;
     f58:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f5a:	8ba6                	mv	s7,s1
      state = 0;
     f5c:	4981                	li	s3,0
        i += 1;
     f5e:	b555                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f60:	008b8493          	addi	s1,s7,8
     f64:	4681                	li	a3,0
     f66:	4629                	li	a2,10
     f68:	000bb583          	ld	a1,0(s7)
     f6c:	855a                	mv	a0,s6
     f6e:	db9ff0ef          	jal	d26 <printint>
        i += 2;
     f72:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f74:	8ba6                	mv	s7,s1
      state = 0;
     f76:	4981                	li	s3,0
        i += 2;
     f78:	b569                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f7a:	008b8493          	addi	s1,s7,8
     f7e:	4681                	li	a3,0
     f80:	4641                	li	a2,16
     f82:	000be583          	lwu	a1,0(s7)
     f86:	855a                	mv	a0,s6
     f88:	d9fff0ef          	jal	d26 <printint>
     f8c:	8ba6                	mv	s7,s1
      state = 0;
     f8e:	4981                	li	s3,0
     f90:	bd8d                	j	e02 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f92:	008b8493          	addi	s1,s7,8
     f96:	4681                	li	a3,0
     f98:	4641                	li	a2,16
     f9a:	000bb583          	ld	a1,0(s7)
     f9e:	855a                	mv	a0,s6
     fa0:	d87ff0ef          	jal	d26 <printint>
        i += 1;
     fa4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fa6:	8ba6                	mv	s7,s1
      state = 0;
     fa8:	4981                	li	s3,0
        i += 1;
     faa:	bda1                	j	e02 <vprintf+0x4a>
     fac:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fae:	008b8d13          	addi	s10,s7,8
     fb2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fb6:	03000593          	li	a1,48
     fba:	855a                	mv	a0,s6
     fbc:	d4dff0ef          	jal	d08 <putc>
  putc(fd, 'x');
     fc0:	07800593          	li	a1,120
     fc4:	855a                	mv	a0,s6
     fc6:	d43ff0ef          	jal	d08 <putc>
     fca:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fcc:	00000b97          	auipc	s7,0x0
     fd0:	5d4b8b93          	addi	s7,s7,1492 # 15a0 <digits>
     fd4:	03c9d793          	srli	a5,s3,0x3c
     fd8:	97de                	add	a5,a5,s7
     fda:	0007c583          	lbu	a1,0(a5)
     fde:	855a                	mv	a0,s6
     fe0:	d29ff0ef          	jal	d08 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fe4:	0992                	slli	s3,s3,0x4
     fe6:	34fd                	addiw	s1,s1,-1
     fe8:	f4f5                	bnez	s1,fd4 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     fea:	8bea                	mv	s7,s10
      state = 0;
     fec:	4981                	li	s3,0
     fee:	6d02                	ld	s10,0(sp)
     ff0:	bd09                	j	e02 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
     ff2:	008b8493          	addi	s1,s7,8
     ff6:	000bc583          	lbu	a1,0(s7)
     ffa:	855a                	mv	a0,s6
     ffc:	d0dff0ef          	jal	d08 <putc>
    1000:	8ba6                	mv	s7,s1
      state = 0;
    1002:	4981                	li	s3,0
    1004:	bbfd                	j	e02 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
    1006:	008b8993          	addi	s3,s7,8
    100a:	000bb483          	ld	s1,0(s7)
    100e:	cc91                	beqz	s1,102a <vprintf+0x272>
        for (; *s; s++)
    1010:	0004c583          	lbu	a1,0(s1)
    1014:	c195                	beqz	a1,1038 <vprintf+0x280>
          putc(fd, *s);
    1016:	855a                	mv	a0,s6
    1018:	cf1ff0ef          	jal	d08 <putc>
        for (; *s; s++)
    101c:	0485                	addi	s1,s1,1
    101e:	0004c583          	lbu	a1,0(s1)
    1022:	f9f5                	bnez	a1,1016 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    1024:	8bce                	mv	s7,s3
      state = 0;
    1026:	4981                	li	s3,0
    1028:	bbe9                	j	e02 <vprintf+0x4a>
          s = "(null)";
    102a:	00000497          	auipc	s1,0x0
    102e:	50e48493          	addi	s1,s1,1294 # 1538 <malloc+0x3fe>
        for (; *s; s++)
    1032:	02800593          	li	a1,40
    1036:	b7c5                	j	1016 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    1038:	8bce                	mv	s7,s3
      state = 0;
    103a:	4981                	li	s3,0
    103c:	b3d9                	j	e02 <vprintf+0x4a>
    103e:	6906                	ld	s2,64(sp)
    1040:	79e2                	ld	s3,56(sp)
    1042:	7a42                	ld	s4,48(sp)
    1044:	7aa2                	ld	s5,40(sp)
    1046:	7b02                	ld	s6,32(sp)
    1048:	6be2                	ld	s7,24(sp)
    104a:	6c42                	ld	s8,16(sp)
    104c:	6ca2                	ld	s9,8(sp)
    }
  }
}
    104e:	60e6                	ld	ra,88(sp)
    1050:	6446                	ld	s0,80(sp)
    1052:	64a6                	ld	s1,72(sp)
    1054:	6125                	addi	sp,sp,96
    1056:	8082                	ret

0000000000001058 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1058:	715d                	addi	sp,sp,-80
    105a:	ec06                	sd	ra,24(sp)
    105c:	e822                	sd	s0,16(sp)
    105e:	1000                	addi	s0,sp,32
    1060:	e010                	sd	a2,0(s0)
    1062:	e414                	sd	a3,8(s0)
    1064:	e818                	sd	a4,16(s0)
    1066:	ec1c                	sd	a5,24(s0)
    1068:	03043023          	sd	a6,32(s0)
    106c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1070:	8622                	mv	a2,s0
    1072:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1076:	d43ff0ef          	jal	db8 <vprintf>
}
    107a:	60e2                	ld	ra,24(sp)
    107c:	6442                	ld	s0,16(sp)
    107e:	6161                	addi	sp,sp,80
    1080:	8082                	ret

0000000000001082 <printf>:

void
printf(const char *fmt, ...)
{
    1082:	711d                	addi	sp,sp,-96
    1084:	ec06                	sd	ra,24(sp)
    1086:	e822                	sd	s0,16(sp)
    1088:	1000                	addi	s0,sp,32
    108a:	e40c                	sd	a1,8(s0)
    108c:	e810                	sd	a2,16(s0)
    108e:	ec14                	sd	a3,24(s0)
    1090:	f018                	sd	a4,32(s0)
    1092:	f41c                	sd	a5,40(s0)
    1094:	03043823          	sd	a6,48(s0)
    1098:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    109c:	00840613          	addi	a2,s0,8
    10a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10a4:	85aa                	mv	a1,a0
    10a6:	4505                	li	a0,1
    10a8:	d11ff0ef          	jal	db8 <vprintf>
}
    10ac:	60e2                	ld	ra,24(sp)
    10ae:	6442                	ld	s0,16(sp)
    10b0:	6125                	addi	sp,sp,96
    10b2:	8082                	ret

00000000000010b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10b4:	1141                	addi	sp,sp,-16
    10b6:	e406                	sd	ra,8(sp)
    10b8:	e022                	sd	s0,0(sp)
    10ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    10bc:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10c0:	00001797          	auipc	a5,0x1
    10c4:	f507b783          	ld	a5,-176(a5) # 2010 <freep>
    10c8:	a02d                	j	10f2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    10ca:	4618                	lw	a4,8(a2)
    10cc:	9f2d                	addw	a4,a4,a1
    10ce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10d2:	6398                	ld	a4,0(a5)
    10d4:	6310                	ld	a2,0(a4)
    10d6:	a83d                	j	1114 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    10d8:	ff852703          	lw	a4,-8(a0)
    10dc:	9f31                	addw	a4,a4,a2
    10de:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10e0:	ff053683          	ld	a3,-16(a0)
    10e4:	a091                	j	1128 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10e6:	6398                	ld	a4,0(a5)
    10e8:	00e7e463          	bltu	a5,a4,10f0 <free+0x3c>
    10ec:	00e6ea63          	bltu	a3,a4,1100 <free+0x4c>
{
    10f0:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10f2:	fed7fae3          	bgeu	a5,a3,10e6 <free+0x32>
    10f6:	6398                	ld	a4,0(a5)
    10f8:	00e6e463          	bltu	a3,a4,1100 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10fc:	fee7eae3          	bltu	a5,a4,10f0 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
    1100:	ff852583          	lw	a1,-8(a0)
    1104:	6390                	ld	a2,0(a5)
    1106:	02059813          	slli	a6,a1,0x20
    110a:	01c85713          	srli	a4,a6,0x1c
    110e:	9736                	add	a4,a4,a3
    1110:	fae60de3          	beq	a2,a4,10ca <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1114:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    1118:	4790                	lw	a2,8(a5)
    111a:	02061593          	slli	a1,a2,0x20
    111e:	01c5d713          	srli	a4,a1,0x1c
    1122:	973e                	add	a4,a4,a5
    1124:	fae68ae3          	beq	a3,a4,10d8 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1128:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    112a:	00001717          	auipc	a4,0x1
    112e:	eef73323          	sd	a5,-282(a4) # 2010 <freep>
}
    1132:	60a2                	ld	ra,8(sp)
    1134:	6402                	ld	s0,0(sp)
    1136:	0141                	addi	sp,sp,16
    1138:	8082                	ret

000000000000113a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    113a:	7139                	addi	sp,sp,-64
    113c:	fc06                	sd	ra,56(sp)
    113e:	f822                	sd	s0,48(sp)
    1140:	f04a                	sd	s2,32(sp)
    1142:	ec4e                	sd	s3,24(sp)
    1144:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1146:	02051993          	slli	s3,a0,0x20
    114a:	0209d993          	srli	s3,s3,0x20
    114e:	09bd                	addi	s3,s3,15
    1150:	0049d993          	srli	s3,s3,0x4
    1154:	2985                	addiw	s3,s3,1
    1156:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    1158:	00001517          	auipc	a0,0x1
    115c:	eb853503          	ld	a0,-328(a0) # 2010 <freep>
    1160:	c905                	beqz	a0,1190 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1162:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    1164:	4798                	lw	a4,8(a5)
    1166:	09377663          	bgeu	a4,s3,11f2 <malloc+0xb8>
    116a:	f426                	sd	s1,40(sp)
    116c:	e852                	sd	s4,16(sp)
    116e:	e456                	sd	s5,8(sp)
    1170:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    1172:	8a4e                	mv	s4,s3
    1174:	6705                	lui	a4,0x1
    1176:	00e9f363          	bgeu	s3,a4,117c <malloc+0x42>
    117a:	6a05                	lui	s4,0x1
    117c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1180:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    1184:	00001497          	auipc	s1,0x1
    1188:	e8c48493          	addi	s1,s1,-372 # 2010 <freep>
  if (p == SBRK_ERROR)
    118c:	5afd                	li	s5,-1
    118e:	a83d                	j	11cc <malloc+0x92>
    1190:	f426                	sd	s1,40(sp)
    1192:	e852                	sd	s4,16(sp)
    1194:	e456                	sd	s5,8(sp)
    1196:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1198:	00001797          	auipc	a5,0x1
    119c:	27078793          	addi	a5,a5,624 # 2408 <base>
    11a0:	00001717          	auipc	a4,0x1
    11a4:	e6f73823          	sd	a5,-400(a4) # 2010 <freep>
    11a8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11aa:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    11ae:	b7d1                	j	1172 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11b0:	6398                	ld	a4,0(a5)
    11b2:	e118                	sd	a4,0(a0)
    11b4:	a899                	j	120a <malloc+0xd0>
  hp->s.size = nu;
    11b6:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    11ba:	0541                	addi	a0,a0,16
    11bc:	ef9ff0ef          	jal	10b4 <free>
  return freep;
    11c0:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    11c2:	c125                	beqz	a0,1222 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    11c4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    11c6:	4798                	lw	a4,8(a5)
    11c8:	03277163          	bgeu	a4,s2,11ea <malloc+0xb0>
    if (p == freep)
    11cc:	6098                	ld	a4,0(s1)
    11ce:	853e                	mv	a0,a5
    11d0:	fef71ae3          	bne	a4,a5,11c4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    11d4:	8552                	mv	a0,s4
    11d6:	a37ff0ef          	jal	c0c <sbrk>
  if (p == SBRK_ERROR)
    11da:	fd551ee3          	bne	a0,s5,11b6 <malloc+0x7c>
        return 0;
    11de:	4501                	li	a0,0
    11e0:	74a2                	ld	s1,40(sp)
    11e2:	6a42                	ld	s4,16(sp)
    11e4:	6aa2                	ld	s5,8(sp)
    11e6:	6b02                	ld	s6,0(sp)
    11e8:	a03d                	j	1216 <malloc+0xdc>
    11ea:	74a2                	ld	s1,40(sp)
    11ec:	6a42                	ld	s4,16(sp)
    11ee:	6aa2                	ld	s5,8(sp)
    11f0:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    11f2:	fae90fe3          	beq	s2,a4,11b0 <malloc+0x76>
        p->s.size -= nunits;
    11f6:	4137073b          	subw	a4,a4,s3
    11fa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11fc:	02071693          	slli	a3,a4,0x20
    1200:	01c6d713          	srli	a4,a3,0x1c
    1204:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1206:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    120a:	00001717          	auipc	a4,0x1
    120e:	e0a73323          	sd	a0,-506(a4) # 2010 <freep>
      return (void *)(p + 1);
    1212:	01078513          	addi	a0,a5,16
  }
}
    1216:	70e2                	ld	ra,56(sp)
    1218:	7442                	ld	s0,48(sp)
    121a:	7902                	ld	s2,32(sp)
    121c:	69e2                	ld	s3,24(sp)
    121e:	6121                	addi	sp,sp,64
    1220:	8082                	ret
    1222:	74a2                	ld	s1,40(sp)
    1224:	6a42                	ld	s4,16(sp)
    1226:	6aa2                	ld	s5,8(sp)
    1228:	6b02                	ld	s6,0(sp)
    122a:	b7f5                	j	1216 <malloc+0xdc>
