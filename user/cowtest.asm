
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fail>:
#include "kernel/stat.h"
#include "user/user.h"

static void
fail(const char *msg)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	85aa                	mv	a1,a0
  printf("cowtest: FAIL - %s\n", msg);
   a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
   e:	cc650513          	addi	a0,a0,-826 # cd0 <malloc+0x100>
  12:	30b000ef          	jal	b1c <printf>
=======
   e:	ce650513          	addi	a0,a0,-794 # cf0 <malloc+0x102>
  12:	329000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  exit(1);
  16:	4505                	li	a0,1
  18:	63c000ef          	jal	654 <exit>

000000000000001c <main>:
  printf("         Parent still sees '%c' (protected from kernel copyout)\n", *page);
}

int
main(void)
{
  1c:	7139                	addi	sp,sp,-64
  1e:	fc06                	sd	ra,56(sp)
  20:	f822                	sd	s0,48(sp)
  22:	0080                	addi	s0,sp,64
  printf("cowtest: starting Copy-on-Write verification\n");
  24:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  28:	cc450513          	addi	a0,a0,-828 # ce8 <malloc+0x118>
  2c:	2f1000ef          	jal	b1c <printf>
=======
  28:	ce450513          	addi	a0,a0,-796 # d08 <malloc+0x11a>
  2c:	30f000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  char *page = sbrk(4096);
  30:	6505                	lui	a0,0x1
  32:	5ee000ef          	jal	620 <sbrk>
  if (page == SBRK_ERROR)
  36:	57fd                	li	a5,-1
  38:	04f50a63          	beq	a0,a5,8c <main+0x70>
  3c:	f426                	sd	s1,40(sp)
  3e:	84aa                	mv	s1,a0
  *page = 'S';
  40:	05300793          	li	a5,83
<<<<<<< HEAD
  44:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x430>
=======
  44:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x412>
>>>>>>> e18456e (Updated xv6-riscv)
  int pid = fork();
  48:	604000ef          	jal	64c <fork>
  if (pid < 0)
  4c:	04054963          	bltz	a0,9e <main+0x82>
  if (pid == 0) {
  50:	e135                	bnez	a0,b4 <main+0x98>
  52:	f04a                	sd	s2,32(sp)
  54:	ec4e                	sd	s3,24(sp)
    int before = getcowfaults(0);
  56:	734000ef          	jal	78a <getcowfaults>
  5a:	892a                	mv	s2,a0
    char seen = *page;
  5c:	0004c983          	lbu	s3,0(s1)
    int after = getcowfaults(0);
  60:	4501                	li	a0,0
  62:	728000ef          	jal	78a <getcowfaults>
  66:	84aa                	mv	s1,a0
    printf("[Test 1] Child read '%c' -> new COW faults: %d (page stayed shared)\n",
  68:	4125063b          	subw	a2,a0,s2
  6c:	85ce                	mv	a1,s3
  6e:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  72:	cfa50513          	addi	a0,a0,-774 # d68 <malloc+0x198>
  76:	2a7000ef          	jal	b1c <printf>
=======
  72:	d1a50513          	addi	a0,a0,-742 # d88 <malloc+0x19a>
  76:	2c5000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    if (seen != 'S' || (after - before) != 0)
  7a:	05300793          	li	a5,83
  7e:	00f99463          	bne	s3,a5,86 <main+0x6a>
  82:	02990663          	beq	s2,s1,ae <main+0x92>
      exit(1);
  86:	4505                	li	a0,1
  88:	5cc000ef          	jal	654 <exit>
  8c:	f426                	sd	s1,40(sp)
  8e:	f04a                	sd	s2,32(sp)
  90:	ec4e                	sd	s3,24(sp)
    fail("sbrk failed in test_readonly_share");
  92:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  96:	c8650513          	addi	a0,a0,-890 # d18 <malloc+0x148>
=======
  96:	ca650513          	addi	a0,a0,-858 # d38 <malloc+0x14a>
>>>>>>> e18456e (Updated xv6-riscv)
  9a:	f67ff0ef          	jal	0 <fail>
  9e:	f04a                	sd	s2,32(sp)
  a0:	ec4e                	sd	s3,24(sp)
    fail("fork failed in test_readonly_share");
  a2:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
  a6:	c9e50513          	addi	a0,a0,-866 # d40 <malloc+0x170>
=======
  a6:	cbe50513          	addi	a0,a0,-834 # d60 <malloc+0x172>
>>>>>>> e18456e (Updated xv6-riscv)
  aa:	f57ff0ef          	jal	0 <fail>
    exit(0);
  ae:	4501                	li	a0,0
  b0:	5a4000ef          	jal	654 <exit>
  int status = 0;
  b4:	fc042423          	sw	zero,-56(s0)
  wait(&status);
  b8:	fc840513          	addi	a0,s0,-56
  bc:	5a0000ef          	jal	65c <wait>
  if (status != 0)
  c0:	fc842783          	lw	a5,-56(s0)
  c4:	ebad                	bnez	a5,136 <main+0x11a>
  char *page = sbrk(4096);
  c6:	6505                	lui	a0,0x1
  c8:	558000ef          	jal	620 <sbrk>
  cc:	84aa                	mv	s1,a0
  if (page == SBRK_ERROR)
  ce:	57fd                	li	a5,-1
  d0:	06f50b63          	beq	a0,a5,146 <main+0x12a>
  *page = 'A';
  d4:	04100793          	li	a5,65
<<<<<<< HEAD
  d8:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x430>
  printf("[Test 2] Original: %c\n", *page);
  dc:	04100593          	li	a1,65
  e0:	00001517          	auipc	a0,0x1
  e4:	d1850513          	addi	a0,a0,-744 # df8 <malloc+0x228>
  e8:	235000ef          	jal	b1c <printf>
=======
  d8:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x412>
  printf("[Test 2] Original: %c\n", *page);
  dc:	04100593          	li	a1,65
  e0:	00001517          	auipc	a0,0x1
  e4:	d3850513          	addi	a0,a0,-712 # e18 <malloc+0x22a>
  e8:	253000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  int pid1 = fork();
  ec:	560000ef          	jal	64c <fork>
  if (pid1 < 0)
  f0:	06054363          	bltz	a0,156 <main+0x13a>
  if (pid1 == 0) {
  f4:	ed25                	bnez	a0,16c <main+0x150>
  f6:	f04a                	sd	s2,32(sp)
  f8:	ec4e                	sd	s3,24(sp)
    int before = getcowfaults(0);
  fa:	690000ef          	jal	78a <getcowfaults>
  fe:	892a                	mv	s2,a0
    *page = 'B';
 100:	04200993          	li	s3,66
 104:	01348023          	sb	s3,0(s1)
    int after = getcowfaults(0);
 108:	4501                	li	a0,0
 10a:	680000ef          	jal	78a <getcowfaults>
    printf("         Child 1 wrote '%c' -> new COW faults: %d\n",
 10e:	4125093b          	subw	s2,a0,s2
 112:	864a                	mv	a2,s2
 114:	0004c583          	lbu	a1,0(s1)
 118:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 11c:	d1050513          	addi	a0,a0,-752 # e28 <malloc+0x258>
 120:	1fd000ef          	jal	b1c <printf>
=======
 11c:	d3050513          	addi	a0,a0,-720 # e48 <malloc+0x25a>
 120:	21b000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    if (*page != 'B' || (after - before) < 1)
 124:	0004c783          	lbu	a5,0(s1)
 128:	01379463          	bne	a5,s3,130 <main+0x114>
 12c:	03204d63          	bgtz	s2,166 <main+0x14a>
      exit(1);
 130:	4505                	li	a0,1
 132:	522000ef          	jal	654 <exit>
 136:	f04a                	sd	s2,32(sp)
 138:	ec4e                	sd	s3,24(sp)
    fail("read-only sharing check failed");
 13a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 13e:	c7650513          	addi	a0,a0,-906 # db0 <malloc+0x1e0>
=======
 13e:	c9650513          	addi	a0,a0,-874 # dd0 <malloc+0x1e2>
>>>>>>> e18456e (Updated xv6-riscv)
 142:	ebfff0ef          	jal	0 <fail>
 146:	f04a                	sd	s2,32(sp)
 148:	ec4e                	sd	s3,24(sp)
    fail("sbrk failed in test_write_isolation");
 14a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 14e:	c8650513          	addi	a0,a0,-890 # dd0 <malloc+0x200>
=======
 14e:	ca650513          	addi	a0,a0,-858 # df0 <malloc+0x202>
>>>>>>> e18456e (Updated xv6-riscv)
 152:	eafff0ef          	jal	0 <fail>
 156:	f04a                	sd	s2,32(sp)
 158:	ec4e                	sd	s3,24(sp)
    fail("first fork failed");
 15a:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 15e:	cb650513          	addi	a0,a0,-842 # e10 <malloc+0x240>
=======
 15e:	cd650513          	addi	a0,a0,-810 # e30 <malloc+0x242>
>>>>>>> e18456e (Updated xv6-riscv)
 162:	e9fff0ef          	jal	0 <fail>
    exit(0);
 166:	4501                	li	a0,0
 168:	4ec000ef          	jal	654 <exit>
  int status = 0;
 16c:	fc042423          	sw	zero,-56(s0)
  wait(&status);
 170:	fc840513          	addi	a0,s0,-56
 174:	4e8000ef          	jal	65c <wait>
  if (status != 0)
 178:	fc842783          	lw	a5,-56(s0)
 17c:	e7a5                	bnez	a5,1e4 <main+0x1c8>
  printf("         After child 1: %c (parent unchanged)\n", *page);
 17e:	0004c583          	lbu	a1,0(s1)
 182:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 186:	cfe50513          	addi	a0,a0,-770 # e80 <malloc+0x2b0>
 18a:	193000ef          	jal	b1c <printf>
=======
 186:	d1e50513          	addi	a0,a0,-738 # ea0 <malloc+0x2b2>
 18a:	1b1000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  if (*page != 'A')
 18e:	0004c703          	lbu	a4,0(s1)
 192:	04100793          	li	a5,65
 196:	04f71f63          	bne	a4,a5,1f4 <main+0x1d8>
  int pid2 = fork();
 19a:	4b2000ef          	jal	64c <fork>
  if (pid2 < 0)
 19e:	06054363          	bltz	a0,204 <main+0x1e8>
  if (pid2 == 0) {
 1a2:	ed25                	bnez	a0,21a <main+0x1fe>
 1a4:	f04a                	sd	s2,32(sp)
 1a6:	ec4e                	sd	s3,24(sp)
    int before = getcowfaults(0);
 1a8:	5e2000ef          	jal	78a <getcowfaults>
 1ac:	892a                	mv	s2,a0
    *page = 'C';
 1ae:	04300993          	li	s3,67
 1b2:	01348023          	sb	s3,0(s1)
    int after = getcowfaults(0);
 1b6:	4501                	li	a0,0
 1b8:	5d2000ef          	jal	78a <getcowfaults>
    printf("         Child 2 wrote '%c' -> new COW faults: %d\n",
 1bc:	4125093b          	subw	s2,a0,s2
 1c0:	864a                	mv	a2,s2
 1c2:	0004c583          	lbu	a1,0(s1)
 1c6:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 1ca:	d3250513          	addi	a0,a0,-718 # ef8 <malloc+0x328>
 1ce:	14f000ef          	jal	b1c <printf>
=======
 1ca:	d5250513          	addi	a0,a0,-686 # f18 <malloc+0x32a>
 1ce:	16d000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    if (*page != 'C' || (after - before) < 1)
 1d2:	0004c783          	lbu	a5,0(s1)
 1d6:	01379463          	bne	a5,s3,1de <main+0x1c2>
 1da:	03204d63          	bgtz	s2,214 <main+0x1f8>
      exit(1);
 1de:	4505                	li	a0,1
 1e0:	474000ef          	jal	654 <exit>
 1e4:	f04a                	sd	s2,32(sp)
 1e6:	ec4e                	sd	s3,24(sp)
    fail("child 1 write isolation failed");
 1e8:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 1ec:	c7850513          	addi	a0,a0,-904 # e60 <malloc+0x290>
=======
 1ec:	c9850513          	addi	a0,a0,-872 # e80 <malloc+0x292>
>>>>>>> e18456e (Updated xv6-riscv)
 1f0:	e11ff0ef          	jal	0 <fail>
 1f4:	f04a                	sd	s2,32(sp)
 1f6:	ec4e                	sd	s3,24(sp)
    fail("parent memory was overwritten by child 1");
 1f8:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 1fc:	cb850513          	addi	a0,a0,-840 # eb0 <malloc+0x2e0>
=======
 1fc:	cd850513          	addi	a0,a0,-808 # ed0 <malloc+0x2e2>
>>>>>>> e18456e (Updated xv6-riscv)
 200:	e01ff0ef          	jal	0 <fail>
 204:	f04a                	sd	s2,32(sp)
 206:	ec4e                	sd	s3,24(sp)
    fail("second fork failed");
 208:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 20c:	cd850513          	addi	a0,a0,-808 # ee0 <malloc+0x310>
=======
 20c:	cf850513          	addi	a0,a0,-776 # f00 <malloc+0x312>
>>>>>>> e18456e (Updated xv6-riscv)
 210:	df1ff0ef          	jal	0 <fail>
    exit(0);
 214:	4501                	li	a0,0
 216:	43e000ef          	jal	654 <exit>
  wait(&status);
 21a:	fc840513          	addi	a0,s0,-56
 21e:	43e000ef          	jal	65c <wait>
  if (status != 0)
 222:	fc842783          	lw	a5,-56(s0)
 226:	e7d5                	bnez	a5,2d2 <main+0x2b6>
  printf("         After child 2: %c (parent unchanged)\n", *page);
 228:	0004c583          	lbu	a1,0(s1)
 22c:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 230:	d2450513          	addi	a0,a0,-732 # f50 <malloc+0x380>
 234:	0e9000ef          	jal	b1c <printf>
=======
 230:	d4450513          	addi	a0,a0,-700 # f70 <malloc+0x382>
 234:	107000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  if (*page != 'A')
 238:	0004c703          	lbu	a4,0(s1)
 23c:	04100793          	li	a5,65
 240:	0af71163          	bne	a4,a5,2e2 <main+0x2c6>
  char *page = sbrk(4096);
 244:	6505                	lui	a0,0x1
 246:	3da000ef          	jal	620 <sbrk>
 24a:	84aa                	mv	s1,a0
  if (page == SBRK_ERROR)
 24c:	57fd                	li	a5,-1
 24e:	0af50263          	beq	a0,a5,2f2 <main+0x2d6>
  *page = 'P';
 252:	05000793          	li	a5,80
<<<<<<< HEAD
 256:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x430>
=======
 256:	00f50023          	sb	a5,0(a0) # 1000 <malloc+0x412>
>>>>>>> e18456e (Updated xv6-riscv)
  if (pipe(fds) < 0)
 25a:	fc840513          	addi	a0,s0,-56
 25e:	406000ef          	jal	664 <pipe>
 262:	0a054063          	bltz	a0,302 <main+0x2e6>
  int pid = fork();
 266:	3e6000ef          	jal	64c <fork>
  if (pid < 0)
 26a:	0a054463          	bltz	a0,312 <main+0x2f6>
  if (pid == 0) {
 26e:	e169                	bnez	a0,330 <main+0x314>
 270:	ec4e                	sd	s3,24(sp)
    close(fds[1]);
 272:	fcc42503          	lw	a0,-52(s0)
 276:	406000ef          	jal	67c <close>
    int before = getcowfaults(0);
 27a:	4501                	li	a0,0
 27c:	50e000ef          	jal	78a <getcowfaults>
 280:	89aa                	mv	s3,a0
    if (read(fds[0], page, 1) != 1)
 282:	4605                	li	a2,1
 284:	85a6                	mv	a1,s1
 286:	fc842503          	lw	a0,-56(s0)
 28a:	3e2000ef          	jal	66c <read>
 28e:	4785                	li	a5,1
 290:	08f51963          	bne	a0,a5,322 <main+0x306>
 294:	f04a                	sd	s2,32(sp)
    int after = getcowfaults(0);
 296:	4501                	li	a0,0
 298:	4f2000ef          	jal	78a <getcowfaults>
 29c:	892a                	mv	s2,a0
    close(fds[0]);
 29e:	fc842503          	lw	a0,-56(s0)
 2a2:	3da000ef          	jal	67c <close>
    printf("[Test 3] Kernel copyout wrote '%c' into child -> new COW faults: %d\n",
 2a6:	4139093b          	subw	s2,s2,s3
 2aa:	864a                	mv	a2,s2
 2ac:	0004c583          	lbu	a1,0(s1)
 2b0:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 2b4:	d5050513          	addi	a0,a0,-688 # 1000 <malloc+0x430>
 2b8:	065000ef          	jal	b1c <printf>
=======
 2b4:	d7050513          	addi	a0,a0,-656 # 1020 <malloc+0x432>
 2b8:	083000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
    if (*page != 'K' || (after - before) < 1)
 2bc:	0004c703          	lbu	a4,0(s1)
 2c0:	04b00793          	li	a5,75
 2c4:	00f71463          	bne	a4,a5,2cc <main+0x2b0>
 2c8:	07204163          	bgtz	s2,32a <main+0x30e>
      exit(1);
 2cc:	4505                	li	a0,1
 2ce:	386000ef          	jal	654 <exit>
 2d2:	f04a                	sd	s2,32(sp)
 2d4:	ec4e                	sd	s3,24(sp)
    fail("child 2 write isolation failed");
 2d6:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 2da:	c5a50513          	addi	a0,a0,-934 # f30 <malloc+0x360>
=======
 2da:	c7a50513          	addi	a0,a0,-902 # f50 <malloc+0x362>
>>>>>>> e18456e (Updated xv6-riscv)
 2de:	d23ff0ef          	jal	0 <fail>
 2e2:	f04a                	sd	s2,32(sp)
 2e4:	ec4e                	sd	s3,24(sp)
    fail("parent memory was overwritten by child 2");
 2e6:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 2ea:	c9a50513          	addi	a0,a0,-870 # f80 <malloc+0x3b0>
=======
 2ea:	cba50513          	addi	a0,a0,-838 # fa0 <malloc+0x3b2>
>>>>>>> e18456e (Updated xv6-riscv)
 2ee:	d13ff0ef          	jal	0 <fail>
 2f2:	f04a                	sd	s2,32(sp)
 2f4:	ec4e                	sd	s3,24(sp)
    fail("sbrk failed in test_copyout_cow");
 2f6:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 2fa:	cba50513          	addi	a0,a0,-838 # fb0 <malloc+0x3e0>
=======
 2fa:	cda50513          	addi	a0,a0,-806 # fd0 <malloc+0x3e2>
>>>>>>> e18456e (Updated xv6-riscv)
 2fe:	d03ff0ef          	jal	0 <fail>
 302:	f04a                	sd	s2,32(sp)
 304:	ec4e                	sd	s3,24(sp)
    fail("pipe failed");
 306:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 30a:	cca50513          	addi	a0,a0,-822 # fd0 <malloc+0x400>
=======
 30a:	cea50513          	addi	a0,a0,-790 # ff0 <malloc+0x402>
>>>>>>> e18456e (Updated xv6-riscv)
 30e:	cf3ff0ef          	jal	0 <fail>
 312:	f04a                	sd	s2,32(sp)
 314:	ec4e                	sd	s3,24(sp)
    fail("fork failed in test_copyout_cow");
 316:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 31a:	cca50513          	addi	a0,a0,-822 # fe0 <malloc+0x410>
=======
 31a:	cea50513          	addi	a0,a0,-790 # 1000 <malloc+0x412>
>>>>>>> e18456e (Updated xv6-riscv)
 31e:	ce3ff0ef          	jal	0 <fail>
 322:	f04a                	sd	s2,32(sp)
      exit(1);
 324:	4505                	li	a0,1
 326:	32e000ef          	jal	654 <exit>
    exit(0);
 32a:	4501                	li	a0,0
 32c:	328000ef          	jal	654 <exit>
  close(fds[0]);
 330:	fc842503          	lw	a0,-56(s0)
 334:	348000ef          	jal	67c <close>
  char msg = 'K';
 338:	04b00793          	li	a5,75
 33c:	fcf401a3          	sb	a5,-61(s0)
  if (write(fds[1], &msg, 1) != 1)
 340:	4605                	li	a2,1
 342:	fc340593          	addi	a1,s0,-61
 346:	fcc42503          	lw	a0,-52(s0)
 34a:	32a000ef          	jal	674 <write>
 34e:	4785                	li	a5,1
 350:	04f51863          	bne	a0,a5,3a0 <main+0x384>
  close(fds[1]);
 354:	fcc42503          	lw	a0,-52(s0)
 358:	324000ef          	jal	67c <close>
  int status = 0;
 35c:	fc042223          	sw	zero,-60(s0)
  wait(&status);
 360:	fc440513          	addi	a0,s0,-60
 364:	2f8000ef          	jal	65c <wait>
  if (status != 0 || *page != 'P')
 368:	fc442783          	lw	a5,-60(s0)
 36c:	e3b1                	bnez	a5,3b0 <main+0x394>
 36e:	0004c703          	lbu	a4,0(s1)
 372:	05000793          	li	a5,80
 376:	02f71d63          	bne	a4,a5,3b0 <main+0x394>
 37a:	f04a                	sd	s2,32(sp)
 37c:	ec4e                	sd	s3,24(sp)
  printf("         Parent still sees '%c' (protected from kernel copyout)\n", *page);
 37e:	05000593          	li	a1,80
 382:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 386:	cfe50513          	addi	a0,a0,-770 # 1080 <malloc+0x4b0>
 38a:	792000ef          	jal	b1c <printf>
=======
 386:	d1e50513          	addi	a0,a0,-738 # 10a0 <malloc+0x4b2>
 38a:	7b0000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  test_readonly_share();
  test_write_isolation();
  test_copyout_cow();
  printf("cowtest: ALL TESTS PASSED\n");
 38e:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 392:	d3a50513          	addi	a0,a0,-710 # 10c8 <malloc+0x4f8>
 396:	786000ef          	jal	b1c <printf>
=======
 392:	d5a50513          	addi	a0,a0,-678 # 10e8 <malloc+0x4fa>
 396:	7a4000ef          	jal	b3a <printf>
>>>>>>> e18456e (Updated xv6-riscv)
  exit(0);
 39a:	4501                	li	a0,0
 39c:	2b8000ef          	jal	654 <exit>
 3a0:	f04a                	sd	s2,32(sp)
 3a2:	ec4e                	sd	s3,24(sp)
    fail("pipe write failed");
 3a4:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 3a8:	ca450513          	addi	a0,a0,-860 # 1048 <malloc+0x478>
=======
 3a8:	cc450513          	addi	a0,a0,-828 # 1068 <malloc+0x47a>
>>>>>>> e18456e (Updated xv6-riscv)
 3ac:	c55ff0ef          	jal	0 <fail>
 3b0:	f04a                	sd	s2,32(sp)
 3b2:	ec4e                	sd	s3,24(sp)
    fail("copyout COW isolation failed");
 3b4:	00001517          	auipc	a0,0x1
<<<<<<< HEAD
 3b8:	cac50513          	addi	a0,a0,-852 # 1060 <malloc+0x490>
=======
 3b8:	ccc50513          	addi	a0,a0,-820 # 1080 <malloc+0x492>
>>>>>>> e18456e (Updated xv6-riscv)
 3bc:	c45ff0ef          	jal	0 <fail>

00000000000003c0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 3c8:	c55ff0ef          	jal	1c <main>
  exit(r);
 3cc:	288000ef          	jal	654 <exit>

00000000000003d0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e422                	sd	s0,8(sp)
 3d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 3d6:	87aa                	mv	a5,a0
 3d8:	0585                	addi	a1,a1,1
 3da:	0785                	addi	a5,a5,1
 3dc:	fff5c703          	lbu	a4,-1(a1)
 3e0:	fee78fa3          	sb	a4,-1(a5)
 3e4:	fb75                	bnez	a4,3d8 <strcpy+0x8>
    ;
  return os;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ec:	1141                	addi	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 3f2:	00054783          	lbu	a5,0(a0)
 3f6:	cb91                	beqz	a5,40a <strcmp+0x1e>
 3f8:	0005c703          	lbu	a4,0(a1)
 3fc:	00f71763          	bne	a4,a5,40a <strcmp+0x1e>
    p++, q++;
 400:	0505                	addi	a0,a0,1
 402:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 404:	00054783          	lbu	a5,0(a0)
 408:	fbe5                	bnez	a5,3f8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 40a:	0005c503          	lbu	a0,0(a1)
}
 40e:	40a7853b          	subw	a0,a5,a0
 412:	6422                	ld	s0,8(sp)
 414:	0141                	addi	sp,sp,16
 416:	8082                	ret

0000000000000418 <strlen>:

uint
strlen(const char *s)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 41e:	00054783          	lbu	a5,0(a0)
 422:	cf91                	beqz	a5,43e <strlen+0x26>
 424:	0505                	addi	a0,a0,1
 426:	87aa                	mv	a5,a0
 428:	86be                	mv	a3,a5
 42a:	0785                	addi	a5,a5,1
 42c:	fff7c703          	lbu	a4,-1(a5)
 430:	ff65                	bnez	a4,428 <strlen+0x10>
 432:	40a6853b          	subw	a0,a3,a0
 436:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
  for (n = 0; s[n]; n++)
 43e:	4501                	li	a0,0
 440:	bfe5                	j	438 <strlen+0x20>

0000000000000442 <memset>:

void *
memset(void *dst, int c, uint n)
{
 442:	1141                	addi	sp,sp,-16
 444:	e422                	sd	s0,8(sp)
 446:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 448:	ca19                	beqz	a2,45e <memset+0x1c>
 44a:	87aa                	mv	a5,a0
 44c:	1602                	slli	a2,a2,0x20
 44e:	9201                	srli	a2,a2,0x20
 450:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 454:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 458:	0785                	addi	a5,a5,1
 45a:	fee79de3          	bne	a5,a4,454 <memset+0x12>
  }
  return dst;
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret

0000000000000464 <strchr>:

char *
strchr(const char *s, char c)
{
 464:	1141                	addi	sp,sp,-16
 466:	e422                	sd	s0,8(sp)
 468:	0800                	addi	s0,sp,16
  for (; *s; s++)
 46a:	00054783          	lbu	a5,0(a0)
 46e:	cb99                	beqz	a5,484 <strchr+0x20>
    if (*s == c)
 470:	00f58763          	beq	a1,a5,47e <strchr+0x1a>
  for (; *s; s++)
 474:	0505                	addi	a0,a0,1
 476:	00054783          	lbu	a5,0(a0)
 47a:	fbfd                	bnez	a5,470 <strchr+0xc>
      return (char *)s;
  return 0;
 47c:	4501                	li	a0,0
}
 47e:	6422                	ld	s0,8(sp)
 480:	0141                	addi	sp,sp,16
 482:	8082                	ret
  return 0;
 484:	4501                	li	a0,0
 486:	bfe5                	j	47e <strchr+0x1a>

0000000000000488 <gets>:

char *
gets(char *buf, int max)
{
 488:	711d                	addi	sp,sp,-96
 48a:	ec86                	sd	ra,88(sp)
 48c:	e8a2                	sd	s0,80(sp)
 48e:	e4a6                	sd	s1,72(sp)
 490:	e0ca                	sd	s2,64(sp)
 492:	fc4e                	sd	s3,56(sp)
 494:	f852                	sd	s4,48(sp)
 496:	f456                	sd	s5,40(sp)
 498:	f05a                	sd	s6,32(sp)
 49a:	ec5e                	sd	s7,24(sp)
 49c:	1080                	addi	s0,sp,96
 49e:	8baa                	mv	s7,a0
 4a0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 4a2:	892a                	mv	s2,a0
 4a4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 4a6:	4aa9                	li	s5,10
 4a8:	4b35                	li	s6,13
  for (i = 0; i + 1 < max;) {
 4aa:	89a6                	mv	s3,s1
 4ac:	2485                	addiw	s1,s1,1
 4ae:	0344d663          	bge	s1,s4,4da <gets+0x52>
    cc = read(0, &c, 1);
 4b2:	4605                	li	a2,1
 4b4:	faf40593          	addi	a1,s0,-81
 4b8:	4501                	li	a0,0
 4ba:	1b2000ef          	jal	66c <read>
    if (cc < 1)
 4be:	00a05e63          	blez	a0,4da <gets+0x52>
    buf[i++] = c;
 4c2:	faf44783          	lbu	a5,-81(s0)
 4c6:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 4ca:	01578763          	beq	a5,s5,4d8 <gets+0x50>
 4ce:	0905                	addi	s2,s2,1
 4d0:	fd679de3          	bne	a5,s6,4aa <gets+0x22>
    buf[i++] = c;
 4d4:	89a6                	mv	s3,s1
 4d6:	a011                	j	4da <gets+0x52>
 4d8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4da:	99de                	add	s3,s3,s7
 4dc:	00098023          	sb	zero,0(s3)
  return buf;
}
 4e0:	855e                	mv	a0,s7
 4e2:	60e6                	ld	ra,88(sp)
 4e4:	6446                	ld	s0,80(sp)
 4e6:	64a6                	ld	s1,72(sp)
 4e8:	6906                	ld	s2,64(sp)
 4ea:	79e2                	ld	s3,56(sp)
 4ec:	7a42                	ld	s4,48(sp)
 4ee:	7aa2                	ld	s5,40(sp)
 4f0:	7b02                	ld	s6,32(sp)
 4f2:	6be2                	ld	s7,24(sp)
 4f4:	6125                	addi	sp,sp,96
 4f6:	8082                	ret

00000000000004f8 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f8:	1101                	addi	sp,sp,-32
 4fa:	ec06                	sd	ra,24(sp)
 4fc:	e822                	sd	s0,16(sp)
 4fe:	e04a                	sd	s2,0(sp)
 500:	1000                	addi	s0,sp,32
 502:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 504:	4581                	li	a1,0
 506:	18e000ef          	jal	694 <open>
  if (fd < 0)
 50a:	02054263          	bltz	a0,52e <stat+0x36>
 50e:	e426                	sd	s1,8(sp)
 510:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 512:	85ca                	mv	a1,s2
 514:	198000ef          	jal	6ac <fstat>
 518:	892a                	mv	s2,a0
  close(fd);
 51a:	8526                	mv	a0,s1
 51c:	160000ef          	jal	67c <close>
  return r;
 520:	64a2                	ld	s1,8(sp)
}
 522:	854a                	mv	a0,s2
 524:	60e2                	ld	ra,24(sp)
 526:	6442                	ld	s0,16(sp)
 528:	6902                	ld	s2,0(sp)
 52a:	6105                	addi	sp,sp,32
 52c:	8082                	ret
    return -1;
 52e:	597d                	li	s2,-1
 530:	bfcd                	j	522 <stat+0x2a>

0000000000000532 <atoi>:

int
atoi(const char *s)
{
 532:	1141                	addi	sp,sp,-16
 534:	e422                	sd	s0,8(sp)
 536:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 538:	00054683          	lbu	a3,0(a0)
 53c:	fd06879b          	addiw	a5,a3,-48
 540:	0ff7f793          	zext.b	a5,a5
 544:	4625                	li	a2,9
 546:	02f66863          	bltu	a2,a5,576 <atoi+0x44>
 54a:	872a                	mv	a4,a0
  n = 0;
 54c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 54e:	0705                	addi	a4,a4,1
 550:	0025179b          	slliw	a5,a0,0x2
 554:	9fa9                	addw	a5,a5,a0
 556:	0017979b          	slliw	a5,a5,0x1
 55a:	9fb5                	addw	a5,a5,a3
 55c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 560:	00074683          	lbu	a3,0(a4)
 564:	fd06879b          	addiw	a5,a3,-48
 568:	0ff7f793          	zext.b	a5,a5
 56c:	fef671e3          	bgeu	a2,a5,54e <atoi+0x1c>
  return n;
}
 570:	6422                	ld	s0,8(sp)
 572:	0141                	addi	sp,sp,16
 574:	8082                	ret
  n = 0;
 576:	4501                	li	a0,0
 578:	bfe5                	j	570 <atoi+0x3e>

000000000000057a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 57a:	1141                	addi	sp,sp,-16
 57c:	e422                	sd	s0,8(sp)
 57e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 580:	02b57463          	bgeu	a0,a1,5a8 <memmove+0x2e>
    while (n-- > 0)
 584:	00c05f63          	blez	a2,5a2 <memmove+0x28>
 588:	1602                	slli	a2,a2,0x20
 58a:	9201                	srli	a2,a2,0x20
 58c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 590:	872a                	mv	a4,a0
      *dst++ = *src++;
 592:	0585                	addi	a1,a1,1
 594:	0705                	addi	a4,a4,1
 596:	fff5c683          	lbu	a3,-1(a1)
 59a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 59e:	fef71ae3          	bne	a4,a5,592 <memmove+0x18>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5a2:	6422                	ld	s0,8(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret
    dst += n;
 5a8:	00c50733          	add	a4,a0,a2
    src += n;
 5ac:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 5ae:	fec05ae3          	blez	a2,5a2 <memmove+0x28>
 5b2:	fff6079b          	addiw	a5,a2,-1
 5b6:	1782                	slli	a5,a5,0x20
 5b8:	9381                	srli	a5,a5,0x20
 5ba:	fff7c793          	not	a5,a5
 5be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5c0:	15fd                	addi	a1,a1,-1
 5c2:	177d                	addi	a4,a4,-1
 5c4:	0005c683          	lbu	a3,0(a1)
 5c8:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 5cc:	fee79ae3          	bne	a5,a4,5c0 <memmove+0x46>
 5d0:	bfc9                	j	5a2 <memmove+0x28>

00000000000005d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5d2:	1141                	addi	sp,sp,-16
 5d4:	e422                	sd	s0,8(sp)
 5d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5d8:	ca05                	beqz	a2,608 <memcmp+0x36>
 5da:	fff6069b          	addiw	a3,a2,-1
 5de:	1682                	slli	a3,a3,0x20
 5e0:	9281                	srli	a3,a3,0x20
 5e2:	0685                	addi	a3,a3,1
 5e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5e6:	00054783          	lbu	a5,0(a0)
 5ea:	0005c703          	lbu	a4,0(a1)
 5ee:	00e79863          	bne	a5,a4,5fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5f2:	0505                	addi	a0,a0,1
    p2++;
 5f4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5f6:	fed518e3          	bne	a0,a3,5e6 <memcmp+0x14>
  }
  return 0;
 5fa:	4501                	li	a0,0
 5fc:	a019                	j	602 <memcmp+0x30>
      return *p1 - *p2;
 5fe:	40e7853b          	subw	a0,a5,a4
}
 602:	6422                	ld	s0,8(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret
  return 0;
 608:	4501                	li	a0,0
 60a:	bfe5                	j	602 <memcmp+0x30>

000000000000060c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 60c:	1141                	addi	sp,sp,-16
 60e:	e406                	sd	ra,8(sp)
 610:	e022                	sd	s0,0(sp)
 612:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 614:	f67ff0ef          	jal	57a <memmove>
}
 618:	60a2                	ld	ra,8(sp)
 61a:	6402                	ld	s0,0(sp)
 61c:	0141                	addi	sp,sp,16
 61e:	8082                	ret

0000000000000620 <sbrk>:

char *
sbrk(int n)
{
 620:	1141                	addi	sp,sp,-16
 622:	e406                	sd	ra,8(sp)
 624:	e022                	sd	s0,0(sp)
 626:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 628:	4585                	li	a1,1
 62a:	0b2000ef          	jal	6dc <sys_sbrk>
}
 62e:	60a2                	ld	ra,8(sp)
 630:	6402                	ld	s0,0(sp)
 632:	0141                	addi	sp,sp,16
 634:	8082                	ret

0000000000000636 <sbrklazy>:

char *
sbrklazy(int n)
{
 636:	1141                	addi	sp,sp,-16
 638:	e406                	sd	ra,8(sp)
 63a:	e022                	sd	s0,0(sp)
 63c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 63e:	4589                	li	a1,2
 640:	09c000ef          	jal	6dc <sys_sbrk>
}
 644:	60a2                	ld	ra,8(sp)
 646:	6402                	ld	s0,0(sp)
 648:	0141                	addi	sp,sp,16
 64a:	8082                	ret

000000000000064c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 64c:	4885                	li	a7,1
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <exit>:
.global exit
exit:
 li a7, SYS_exit
 654:	4889                	li	a7,2
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <wait>:
.global wait
wait:
 li a7, SYS_wait
 65c:	488d                	li	a7,3
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 664:	4891                	li	a7,4
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <read>:
.global read
read:
 li a7, SYS_read
 66c:	4895                	li	a7,5
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <write>:
.global write
write:
 li a7, SYS_write
 674:	48c1                	li	a7,16
 ecall
 676:	00000073          	ecall
 ret
 67a:	8082                	ret

000000000000067c <close>:
.global close
close:
 li a7, SYS_close
 67c:	48d5                	li	a7,21
 ecall
 67e:	00000073          	ecall
 ret
 682:	8082                	ret

0000000000000684 <kill>:
.global kill
kill:
 li a7, SYS_kill
 684:	4899                	li	a7,6
 ecall
 686:	00000073          	ecall
 ret
 68a:	8082                	ret

000000000000068c <exec>:
.global exec
exec:
 li a7, SYS_exec
 68c:	489d                	li	a7,7
 ecall
 68e:	00000073          	ecall
 ret
 692:	8082                	ret

0000000000000694 <open>:
.global open
open:
 li a7, SYS_open
 694:	48bd                	li	a7,15
 ecall
 696:	00000073          	ecall
 ret
 69a:	8082                	ret

000000000000069c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 69c:	48c5                	li	a7,17
 ecall
 69e:	00000073          	ecall
 ret
 6a2:	8082                	ret

00000000000006a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6a4:	48c9                	li	a7,18
 ecall
 6a6:	00000073          	ecall
 ret
 6aa:	8082                	ret

00000000000006ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6ac:	48a1                	li	a7,8
 ecall
 6ae:	00000073          	ecall
 ret
 6b2:	8082                	ret

00000000000006b4 <link>:
.global link
link:
 li a7, SYS_link
 6b4:	48cd                	li	a7,19
 ecall
 6b6:	00000073          	ecall
 ret
 6ba:	8082                	ret

00000000000006bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6bc:	48d1                	li	a7,20
 ecall
 6be:	00000073          	ecall
 ret
 6c2:	8082                	ret

00000000000006c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6c4:	48a5                	li	a7,9
 ecall
 6c6:	00000073          	ecall
 ret
 6ca:	8082                	ret

00000000000006cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 6cc:	48a9                	li	a7,10
 ecall
 6ce:	00000073          	ecall
 ret
 6d2:	8082                	ret

00000000000006d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6d4:	48ad                	li	a7,11
 ecall
 6d6:	00000073          	ecall
 ret
 6da:	8082                	ret

00000000000006dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 6dc:	48b1                	li	a7,12
 ecall
 6de:	00000073          	ecall
 ret
 6e2:	8082                	ret

00000000000006e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 6e4:	48b5                	li	a7,13
 ecall
 6e6:	00000073          	ecall
 ret
 6ea:	8082                	ret

00000000000006ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ec:	48b9                	li	a7,14
 ecall
 6ee:	00000073          	ecall
 ret
 6f2:	8082                	ret

00000000000006f4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 6f4:	48d9                	li	a7,22
 ecall
 6f6:	00000073          	ecall
 ret
 6fa:	8082                	ret

00000000000006fc <ps>:
.global ps
ps:
 li a7, SYS_ps
 6fc:	48dd                	li	a7,23
 ecall
 6fe:	00000073          	ecall
 ret
 702:	8082                	ret

0000000000000704 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 704:	48e1                	li	a7,24
 ecall
 706:	00000073          	ecall
 ret
 70a:	8082                	ret

000000000000070c <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 70c:	48e5                	li	a7,25
 ecall
 70e:	00000073          	ecall
 ret
 712:	8082                	ret

0000000000000714 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 714:	48e9                	li	a7,26
 ecall
 716:	00000073          	ecall
 ret
 71a:	8082                	ret

000000000000071c <trace>:
.global trace
trace:
 li a7, SYS_trace
 71c:	48ed                	li	a7,27
 ecall
 71e:	00000073          	ecall
 ret
 722:	8082                	ret

0000000000000724 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 724:	48f1                	li	a7,28
 ecall
 726:	00000073          	ecall
 ret
 72a:	8082                	ret

000000000000072c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 72c:	48f5                	li	a7,29
 ecall
 72e:	00000073          	ecall
 ret
 732:	8082                	ret

0000000000000734 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 734:	48f9                	li	a7,30
 ecall
 736:	00000073          	ecall
 ret
 73a:	8082                	ret

000000000000073c <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 73c:	48fd                	li	a7,31
 ecall
 73e:	00000073          	ecall
 ret
 742:	8082                	ret

0000000000000744 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 744:	02000893          	li	a7,32
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <halt>:
.global halt
halt:
 li a7, SYS_halt
 74e:	02100893          	li	a7,33
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 758:	02200893          	li	a7,34
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 762:	02300893          	li	a7,35
 ecall
 766:	00000073          	ecall
 ret
 76a:	8082                	ret

000000000000076c <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 76c:	02400893          	li	a7,36
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 776:	02500893          	li	a7,37
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <getpriority>:
.global getpriority
getpriority:
 li a7, SYS_getpriority
 780:	02600893          	li	a7,38
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <getcowfaults>:
.global getcowfaults
getcowfaults:
 li a7, SYS_getcowfaults
 78a:	02700893          	li	a7,39
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

<<<<<<< HEAD
0000000000000794 <putc>:
=======
0000000000000794 <tracemode>:
.global tracemode
tracemode:
 li a7, SYS_tracemode
 794:	02800893          	li	a7,40
 ecall
 798:	00000073          	ecall
 ret
 79c:	8082                	ret

000000000000079e <setaging>:
.global setaging
setaging:
 li a7, SYS_setaging
 79e:	02900893          	li	a7,41
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <syscallstats>:
.global syscallstats
syscallstats:
 li a7, SYS_syscallstats
 7a8:	02a00893          	li	a7,42
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <putc>:
>>>>>>> e18456e (Updated xv6-riscv)

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
<<<<<<< HEAD
 794:	1101                	addi	sp,sp,-32
 796:	ec06                	sd	ra,24(sp)
 798:	e822                	sd	s0,16(sp)
 79a:	1000                	addi	s0,sp,32
 79c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7a0:	4605                	li	a2,1
 7a2:	fef40593          	addi	a1,s0,-17
 7a6:	ecfff0ef          	jal	674 <write>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6105                	addi	sp,sp,32
 7b0:	8082                	ret

00000000000007b2 <printint>:
=======
 7b2:	1101                	addi	sp,sp,-32
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7be:	4605                	li	a2,1
 7c0:	fef40593          	addi	a1,s0,-17
 7c4:	eb1ff0ef          	jal	674 <write>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6105                	addi	sp,sp,32
 7ce:	8082                	ret

00000000000007d0 <printint>:
>>>>>>> e18456e (Updated xv6-riscv)

static void
printint(int fd, long long xx, int base, int sgn)
{
<<<<<<< HEAD
 7b2:	715d                	addi	sp,sp,-80
 7b4:	e486                	sd	ra,72(sp)
 7b6:	e0a2                	sd	s0,64(sp)
 7b8:	f84a                	sd	s2,48(sp)
 7ba:	0880                	addi	s0,sp,80
 7bc:	892a                	mv	s2,a0
=======
 7d0:	715d                	addi	sp,sp,-80
 7d2:	e486                	sd	ra,72(sp)
 7d4:	e0a2                	sd	s0,64(sp)
 7d6:	f84a                	sd	s2,48(sp)
 7d8:	0880                	addi	s0,sp,80
 7da:	892a                	mv	s2,a0
>>>>>>> e18456e (Updated xv6-riscv)
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
<<<<<<< HEAD
 7be:	c299                	beqz	a3,7c4 <printint+0x12>
 7c0:	0805c363          	bltz	a1,846 <printint+0x94>
  neg = 0;
 7c4:	4881                	li	a7,0
 7c6:	fb840693          	addi	a3,s0,-72
=======
 7dc:	c299                	beqz	a3,7e2 <printint+0x12>
 7de:	0805c363          	bltz	a1,864 <printint+0x94>
  neg = 0;
 7e2:	4881                	li	a7,0
 7e4:	fb840693          	addi	a3,s0,-72
>>>>>>> e18456e (Updated xv6-riscv)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
<<<<<<< HEAD
 7ca:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 7cc:	00001517          	auipc	a0,0x1
 7d0:	92450513          	addi	a0,a0,-1756 # 10f0 <digits>
 7d4:	883e                	mv	a6,a5
 7d6:	2785                	addiw	a5,a5,1
 7d8:	02c5f733          	remu	a4,a1,a2
 7dc:	972a                	add	a4,a4,a0
 7de:	00074703          	lbu	a4,0(a4)
 7e2:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 7e6:	872e                	mv	a4,a1
 7e8:	02c5d5b3          	divu	a1,a1,a2
 7ec:	0685                	addi	a3,a3,1
 7ee:	fec773e3          	bgeu	a4,a2,7d4 <printint+0x22>
  if (neg)
 7f2:	00088b63          	beqz	a7,808 <printint+0x56>
    buf[i++] = '-';
 7f6:	fd078793          	addi	a5,a5,-48
 7fa:	97a2                	add	a5,a5,s0
 7fc:	02d00713          	li	a4,45
 800:	fee78423          	sb	a4,-24(a5)
 804:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 808:	02f05a63          	blez	a5,83c <printint+0x8a>
 80c:	fc26                	sd	s1,56(sp)
 80e:	f44e                	sd	s3,40(sp)
 810:	fb840713          	addi	a4,s0,-72
 814:	00f704b3          	add	s1,a4,a5
 818:	fff70993          	addi	s3,a4,-1
 81c:	99be                	add	s3,s3,a5
 81e:	37fd                	addiw	a5,a5,-1
 820:	1782                	slli	a5,a5,0x20
 822:	9381                	srli	a5,a5,0x20
 824:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 828:	fff4c583          	lbu	a1,-1(s1)
 82c:	854a                	mv	a0,s2
 82e:	f67ff0ef          	jal	794 <putc>
  while (--i >= 0)
 832:	14fd                	addi	s1,s1,-1
 834:	ff349ae3          	bne	s1,s3,828 <printint+0x76>
 838:	74e2                	ld	s1,56(sp)
 83a:	79a2                	ld	s3,40(sp)
}
 83c:	60a6                	ld	ra,72(sp)
 83e:	6406                	ld	s0,64(sp)
 840:	7942                	ld	s2,48(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret
    x = -xx;
 846:	40b005b3          	neg	a1,a1
    neg = 1;
 84a:	4885                	li	a7,1
    x = -xx;
 84c:	bfad                	j	7c6 <printint+0x14>

000000000000084e <vprintf>:
=======
 7e8:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 7ea:	00001517          	auipc	a0,0x1
 7ee:	92650513          	addi	a0,a0,-1754 # 1110 <digits>
 7f2:	883e                	mv	a6,a5
 7f4:	2785                	addiw	a5,a5,1
 7f6:	02c5f733          	remu	a4,a1,a2
 7fa:	972a                	add	a4,a4,a0
 7fc:	00074703          	lbu	a4,0(a4)
 800:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 804:	872e                	mv	a4,a1
 806:	02c5d5b3          	divu	a1,a1,a2
 80a:	0685                	addi	a3,a3,1
 80c:	fec773e3          	bgeu	a4,a2,7f2 <printint+0x22>
  if (neg)
 810:	00088b63          	beqz	a7,826 <printint+0x56>
    buf[i++] = '-';
 814:	fd078793          	addi	a5,a5,-48
 818:	97a2                	add	a5,a5,s0
 81a:	02d00713          	li	a4,45
 81e:	fee78423          	sb	a4,-24(a5)
 822:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
 826:	02f05a63          	blez	a5,85a <printint+0x8a>
 82a:	fc26                	sd	s1,56(sp)
 82c:	f44e                	sd	s3,40(sp)
 82e:	fb840713          	addi	a4,s0,-72
 832:	00f704b3          	add	s1,a4,a5
 836:	fff70993          	addi	s3,a4,-1
 83a:	99be                	add	s3,s3,a5
 83c:	37fd                	addiw	a5,a5,-1
 83e:	1782                	slli	a5,a5,0x20
 840:	9381                	srli	a5,a5,0x20
 842:	40f989b3          	sub	s3,s3,a5
    putc(fd, buf[i]);
 846:	fff4c583          	lbu	a1,-1(s1)
 84a:	854a                	mv	a0,s2
 84c:	f67ff0ef          	jal	7b2 <putc>
  while (--i >= 0)
 850:	14fd                	addi	s1,s1,-1
 852:	ff349ae3          	bne	s1,s3,846 <printint+0x76>
 856:	74e2                	ld	s1,56(sp)
 858:	79a2                	ld	s3,40(sp)
}
 85a:	60a6                	ld	ra,72(sp)
 85c:	6406                	ld	s0,64(sp)
 85e:	7942                	ld	s2,48(sp)
 860:	6161                	addi	sp,sp,80
 862:	8082                	ret
    x = -xx;
 864:	40b005b3          	neg	a1,a1
    neg = 1;
 868:	4885                	li	a7,1
    x = -xx;
 86a:	bfad                	j	7e4 <printint+0x14>

000000000000086c <vprintf>:
>>>>>>> e18456e (Updated xv6-riscv)
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
<<<<<<< HEAD
 84e:	711d                	addi	sp,sp,-96
 850:	ec86                	sd	ra,88(sp)
 852:	e8a2                	sd	s0,80(sp)
 854:	e0ca                	sd	s2,64(sp)
 856:	1080                	addi	s0,sp,96
=======
 86c:	711d                	addi	sp,sp,-96
 86e:	ec86                	sd	ra,88(sp)
 870:	e8a2                	sd	s0,80(sp)
 872:	e0ca                	sd	s2,64(sp)
 874:	1080                	addi	s0,sp,96
>>>>>>> e18456e (Updated xv6-riscv)
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
<<<<<<< HEAD
 858:	0005c903          	lbu	s2,0(a1)
 85c:	28090663          	beqz	s2,ae8 <vprintf+0x29a>
 860:	e4a6                	sd	s1,72(sp)
 862:	fc4e                	sd	s3,56(sp)
 864:	f852                	sd	s4,48(sp)
 866:	f456                	sd	s5,40(sp)
 868:	f05a                	sd	s6,32(sp)
 86a:	ec5e                	sd	s7,24(sp)
 86c:	e862                	sd	s8,16(sp)
 86e:	e466                	sd	s9,8(sp)
 870:	8b2a                	mv	s6,a0
 872:	8a2e                	mv	s4,a1
 874:	8bb2                	mv	s7,a2
  state = 0;
 876:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 878:	4481                	li	s1,0
 87a:	4701                	li	a4,0
=======
 876:	0005c903          	lbu	s2,0(a1)
 87a:	28090663          	beqz	s2,b06 <vprintf+0x29a>
 87e:	e4a6                	sd	s1,72(sp)
 880:	fc4e                	sd	s3,56(sp)
 882:	f852                	sd	s4,48(sp)
 884:	f456                	sd	s5,40(sp)
 886:	f05a                	sd	s6,32(sp)
 888:	ec5e                	sd	s7,24(sp)
 88a:	e862                	sd	s8,16(sp)
 88c:	e466                	sd	s9,8(sp)
 88e:	8b2a                	mv	s6,a0
 890:	8a2e                	mv	s4,a1
 892:	8bb2                	mv	s7,a2
  state = 0;
 894:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 896:	4481                	li	s1,0
 898:	4701                	li	a4,0
>>>>>>> e18456e (Updated xv6-riscv)
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
<<<<<<< HEAD
 87c:	02500a93          	li	s5,37
=======
 89a:	02500a93          	li	s5,37
>>>>>>> e18456e (Updated xv6-riscv)
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
<<<<<<< HEAD
 880:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 884:	06c00c93          	li	s9,108
 888:	a005                	j	8a8 <vprintf+0x5a>
        putc(fd, c0);
 88a:	85ca                	mv	a1,s2
 88c:	855a                	mv	a0,s6
 88e:	f07ff0ef          	jal	794 <putc>
 892:	a019                	j	898 <vprintf+0x4a>
    } else if (state == '%') {
 894:	03598263          	beq	s3,s5,8b8 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 898:	2485                	addiw	s1,s1,1
 89a:	8726                	mv	a4,s1
 89c:	009a07b3          	add	a5,s4,s1
 8a0:	0007c903          	lbu	s2,0(a5)
 8a4:	22090a63          	beqz	s2,ad8 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 8a8:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 8ac:	fe0994e3          	bnez	s3,894 <vprintf+0x46>
      if (c0 == '%') {
 8b0:	fd579de3          	bne	a5,s5,88a <vprintf+0x3c>
        state = '%';
 8b4:	89be                	mv	s3,a5
 8b6:	b7cd                	j	898 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 8b8:	00ea06b3          	add	a3,s4,a4
 8bc:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8c0:	8636                	mv	a2,a3
      if (c1)
 8c2:	c681                	beqz	a3,8ca <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 8c4:	9752                	add	a4,a4,s4
 8c6:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 8ca:	05878363          	beq	a5,s8,910 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 8ce:	05978d63          	beq	a5,s9,928 <vprintf+0xda>
=======
 89e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 8a2:	06c00c93          	li	s9,108
 8a6:	a005                	j	8c6 <vprintf+0x5a>
        putc(fd, c0);
 8a8:	85ca                	mv	a1,s2
 8aa:	855a                	mv	a0,s6
 8ac:	f07ff0ef          	jal	7b2 <putc>
 8b0:	a019                	j	8b6 <vprintf+0x4a>
    } else if (state == '%') {
 8b2:	03598263          	beq	s3,s5,8d6 <vprintf+0x6a>
  for (i = 0; fmt[i]; i++) {
 8b6:	2485                	addiw	s1,s1,1
 8b8:	8726                	mv	a4,s1
 8ba:	009a07b3          	add	a5,s4,s1
 8be:	0007c903          	lbu	s2,0(a5)
 8c2:	22090a63          	beqz	s2,af6 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 8c6:	0009079b          	sext.w	a5,s2
    if (state == 0) {
 8ca:	fe0994e3          	bnez	s3,8b2 <vprintf+0x46>
      if (c0 == '%') {
 8ce:	fd579de3          	bne	a5,s5,8a8 <vprintf+0x3c>
        state = '%';
 8d2:	89be                	mv	s3,a5
 8d4:	b7cd                	j	8b6 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 8d6:	00ea06b3          	add	a3,s4,a4
 8da:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8de:	8636                	mv	a2,a3
      if (c1)
 8e0:	c681                	beqz	a3,8e8 <vprintf+0x7c>
        c2 = fmt[i + 2] & 0xff;
 8e2:	9752                	add	a4,a4,s4
 8e4:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 8e8:	05878363          	beq	a5,s8,92e <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 8ec:	05978d63          	beq	a5,s9,946 <vprintf+0xda>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
<<<<<<< HEAD
 8d2:	07500713          	li	a4,117
 8d6:	0ee78763          	beq	a5,a4,9c4 <vprintf+0x176>
=======
 8f0:	07500713          	li	a4,117
 8f4:	0ee78763          	beq	a5,a4,9e2 <vprintf+0x176>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
<<<<<<< HEAD
 8da:	07800713          	li	a4,120
 8de:	12e78963          	beq	a5,a4,a10 <vprintf+0x1c2>
=======
 8f8:	07800713          	li	a4,120
 8fc:	12e78963          	beq	a5,a4,a2e <vprintf+0x1c2>
>>>>>>> e18456e (Updated xv6-riscv)
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
<<<<<<< HEAD
 8e2:	07000713          	li	a4,112
 8e6:	14e78e63          	beq	a5,a4,a42 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 8ea:	06300713          	li	a4,99
 8ee:	18e78e63          	beq	a5,a4,a8a <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 8f2:	07300713          	li	a4,115
 8f6:	1ae78463          	beq	a5,a4,a9e <vprintf+0x250>
=======
 900:	07000713          	li	a4,112
 904:	14e78e63          	beq	a5,a4,a60 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 908:	06300713          	li	a4,99
 90c:	18e78e63          	beq	a5,a4,aa8 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 910:	07300713          	li	a4,115
 914:	1ae78463          	beq	a5,a4,abc <vprintf+0x250>
>>>>>>> e18456e (Updated xv6-riscv)
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
<<<<<<< HEAD
 8fa:	02500713          	li	a4,37
 8fe:	04e79563          	bne	a5,a4,948 <vprintf+0xfa>
        putc(fd, '%');
 902:	02500593          	li	a1,37
 906:	855a                	mv	a0,s6
 908:	e8dff0ef          	jal	794 <putc>
=======
 918:	02500713          	li	a4,37
 91c:	04e79563          	bne	a5,a4,966 <vprintf+0xfa>
        putc(fd, '%');
 920:	02500593          	li	a1,37
 924:	855a                	mv	a0,s6
 926:	e8dff0ef          	jal	7b2 <putc>
>>>>>>> e18456e (Updated xv6-riscv)
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
<<<<<<< HEAD
 90c:	4981                	li	s3,0
 90e:	b769                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 910:	008b8913          	addi	s2,s7,8
 914:	4685                	li	a3,1
 916:	4629                	li	a2,10
 918:	000ba583          	lw	a1,0(s7)
 91c:	855a                	mv	a0,s6
 91e:	e95ff0ef          	jal	7b2 <printint>
 922:	8bca                	mv	s7,s2
      state = 0;
 924:	4981                	li	s3,0
 926:	bf8d                	j	898 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 928:	06400793          	li	a5,100
 92c:	02f68963          	beq	a3,a5,95e <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 930:	06c00793          	li	a5,108
 934:	04f68263          	beq	a3,a5,978 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 938:	07500793          	li	a5,117
 93c:	0af68063          	beq	a3,a5,9dc <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 940:	07800793          	li	a5,120
 944:	0ef68263          	beq	a3,a5,a28 <vprintf+0x1da>
        putc(fd, '%');
 948:	02500593          	li	a1,37
 94c:	855a                	mv	a0,s6
 94e:	e47ff0ef          	jal	794 <putc>
        putc(fd, c0);
 952:	85ca                	mv	a1,s2
 954:	855a                	mv	a0,s6
 956:	e3fff0ef          	jal	794 <putc>
      state = 0;
 95a:	4981                	li	s3,0
 95c:	bf35                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 95e:	008b8913          	addi	s2,s7,8
 962:	4685                	li	a3,1
 964:	4629                	li	a2,10
 966:	000bb583          	ld	a1,0(s7)
 96a:	855a                	mv	a0,s6
 96c:	e47ff0ef          	jal	7b2 <printint>
        i += 1;
 970:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 972:	8bca                	mv	s7,s2
      state = 0;
 974:	4981                	li	s3,0
        i += 1;
 976:	b70d                	j	898 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 978:	06400793          	li	a5,100
 97c:	02f60763          	beq	a2,a5,9aa <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 980:	07500793          	li	a5,117
 984:	06f60963          	beq	a2,a5,9f6 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 988:	07800793          	li	a5,120
 98c:	faf61ee3          	bne	a2,a5,948 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 990:	008b8913          	addi	s2,s7,8
 994:	4681                	li	a3,0
 996:	4641                	li	a2,16
 998:	000bb583          	ld	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	e15ff0ef          	jal	7b2 <printint>
        i += 2;
 9a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9a4:	8bca                	mv	s7,s2
      state = 0;
 9a6:	4981                	li	s3,0
        i += 2;
 9a8:	bdc5                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9aa:	008b8913          	addi	s2,s7,8
 9ae:	4685                	li	a3,1
 9b0:	4629                	li	a2,10
 9b2:	000bb583          	ld	a1,0(s7)
 9b6:	855a                	mv	a0,s6
 9b8:	dfbff0ef          	jal	7b2 <printint>
        i += 2;
 9bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9be:	8bca                	mv	s7,s2
      state = 0;
 9c0:	4981                	li	s3,0
        i += 2;
 9c2:	bdd9                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 9c4:	008b8913          	addi	s2,s7,8
 9c8:	4681                	li	a3,0
 9ca:	4629                	li	a2,10
 9cc:	000be583          	lwu	a1,0(s7)
 9d0:	855a                	mv	a0,s6
 9d2:	de1ff0ef          	jal	7b2 <printint>
 9d6:	8bca                	mv	s7,s2
      state = 0;
 9d8:	4981                	li	s3,0
 9da:	bd7d                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9dc:	008b8913          	addi	s2,s7,8
 9e0:	4681                	li	a3,0
 9e2:	4629                	li	a2,10
 9e4:	000bb583          	ld	a1,0(s7)
 9e8:	855a                	mv	a0,s6
 9ea:	dc9ff0ef          	jal	7b2 <printint>
        i += 1;
 9ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f0:	8bca                	mv	s7,s2
      state = 0;
 9f2:	4981                	li	s3,0
        i += 1;
 9f4:	b555                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9f6:	008b8913          	addi	s2,s7,8
 9fa:	4681                	li	a3,0
 9fc:	4629                	li	a2,10
 9fe:	000bb583          	ld	a1,0(s7)
 a02:	855a                	mv	a0,s6
 a04:	dafff0ef          	jal	7b2 <printint>
        i += 2;
 a08:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0a:	8bca                	mv	s7,s2
      state = 0;
 a0c:	4981                	li	s3,0
        i += 2;
 a0e:	b569                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a10:	008b8913          	addi	s2,s7,8
 a14:	4681                	li	a3,0
 a16:	4641                	li	a2,16
 a18:	000be583          	lwu	a1,0(s7)
 a1c:	855a                	mv	a0,s6
 a1e:	d95ff0ef          	jal	7b2 <printint>
 a22:	8bca                	mv	s7,s2
      state = 0;
 a24:	4981                	li	s3,0
 a26:	bd8d                	j	898 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a28:	008b8913          	addi	s2,s7,8
 a2c:	4681                	li	a3,0
 a2e:	4641                	li	a2,16
 a30:	000bb583          	ld	a1,0(s7)
 a34:	855a                	mv	a0,s6
 a36:	d7dff0ef          	jal	7b2 <printint>
        i += 1;
 a3a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a3c:	8bca                	mv	s7,s2
      state = 0;
 a3e:	4981                	li	s3,0
        i += 1;
 a40:	bda1                	j	898 <vprintf+0x4a>
 a42:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a44:	008b8d13          	addi	s10,s7,8
 a48:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a4c:	03000593          	li	a1,48
 a50:	855a                	mv	a0,s6
 a52:	d43ff0ef          	jal	794 <putc>
  putc(fd, 'x');
 a56:	07800593          	li	a1,120
 a5a:	855a                	mv	a0,s6
 a5c:	d39ff0ef          	jal	794 <putc>
 a60:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a62:	00000b97          	auipc	s7,0x0
 a66:	68eb8b93          	addi	s7,s7,1678 # 10f0 <digits>
 a6a:	03c9d793          	srli	a5,s3,0x3c
 a6e:	97de                	add	a5,a5,s7
 a70:	0007c583          	lbu	a1,0(a5)
 a74:	855a                	mv	a0,s6
 a76:	d1fff0ef          	jal	794 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a7a:	0992                	slli	s3,s3,0x4
 a7c:	397d                	addiw	s2,s2,-1
 a7e:	fe0916e3          	bnez	s2,a6a <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 a82:	8bea                	mv	s7,s10
      state = 0;
 a84:	4981                	li	s3,0
 a86:	6d02                	ld	s10,0(sp)
 a88:	bd01                	j	898 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 a8a:	008b8913          	addi	s2,s7,8
 a8e:	000bc583          	lbu	a1,0(s7)
 a92:	855a                	mv	a0,s6
 a94:	d01ff0ef          	jal	794 <putc>
 a98:	8bca                	mv	s7,s2
      state = 0;
 a9a:	4981                	li	s3,0
 a9c:	bbf5                	j	898 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 a9e:	008b8993          	addi	s3,s7,8
 aa2:	000bb903          	ld	s2,0(s7)
 aa6:	00090f63          	beqz	s2,ac4 <vprintf+0x276>
        for (; *s; s++)
 aaa:	00094583          	lbu	a1,0(s2)
 aae:	c195                	beqz	a1,ad2 <vprintf+0x284>
          putc(fd, *s);
 ab0:	855a                	mv	a0,s6
 ab2:	ce3ff0ef          	jal	794 <putc>
        for (; *s; s++)
 ab6:	0905                	addi	s2,s2,1
 ab8:	00094583          	lbu	a1,0(s2)
 abc:	f9f5                	bnez	a1,ab0 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 abe:	8bce                	mv	s7,s3
      state = 0;
 ac0:	4981                	li	s3,0
 ac2:	bbd9                	j	898 <vprintf+0x4a>
          s = "(null)";
 ac4:	00000917          	auipc	s2,0x0
 ac8:	62490913          	addi	s2,s2,1572 # 10e8 <malloc+0x518>
        for (; *s; s++)
 acc:	02800593          	li	a1,40
 ad0:	b7c5                	j	ab0 <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 ad2:	8bce                	mv	s7,s3
      state = 0;
 ad4:	4981                	li	s3,0
 ad6:	b3c9                	j	898 <vprintf+0x4a>
 ad8:	64a6                	ld	s1,72(sp)
 ada:	79e2                	ld	s3,56(sp)
 adc:	7a42                	ld	s4,48(sp)
 ade:	7aa2                	ld	s5,40(sp)
 ae0:	7b02                	ld	s6,32(sp)
 ae2:	6be2                	ld	s7,24(sp)
 ae4:	6c42                	ld	s8,16(sp)
 ae6:	6ca2                	ld	s9,8(sp)
    }
  }
}
 ae8:	60e6                	ld	ra,88(sp)
 aea:	6446                	ld	s0,80(sp)
 aec:	6906                	ld	s2,64(sp)
 aee:	6125                	addi	sp,sp,96
 af0:	8082                	ret

0000000000000af2 <fprintf>:
=======
 92a:	4981                	li	s3,0
 92c:	b769                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 92e:	008b8913          	addi	s2,s7,8
 932:	4685                	li	a3,1
 934:	4629                	li	a2,10
 936:	000ba583          	lw	a1,0(s7)
 93a:	855a                	mv	a0,s6
 93c:	e95ff0ef          	jal	7d0 <printint>
 940:	8bca                	mv	s7,s2
      state = 0;
 942:	4981                	li	s3,0
 944:	bf8d                	j	8b6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 946:	06400793          	li	a5,100
 94a:	02f68963          	beq	a3,a5,97c <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 94e:	06c00793          	li	a5,108
 952:	04f68263          	beq	a3,a5,996 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 956:	07500793          	li	a5,117
 95a:	0af68063          	beq	a3,a5,9fa <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 95e:	07800793          	li	a5,120
 962:	0ef68263          	beq	a3,a5,a46 <vprintf+0x1da>
        putc(fd, '%');
 966:	02500593          	li	a1,37
 96a:	855a                	mv	a0,s6
 96c:	e47ff0ef          	jal	7b2 <putc>
        putc(fd, c0);
 970:	85ca                	mv	a1,s2
 972:	855a                	mv	a0,s6
 974:	e3fff0ef          	jal	7b2 <putc>
      state = 0;
 978:	4981                	li	s3,0
 97a:	bf35                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 97c:	008b8913          	addi	s2,s7,8
 980:	4685                	li	a3,1
 982:	4629                	li	a2,10
 984:	000bb583          	ld	a1,0(s7)
 988:	855a                	mv	a0,s6
 98a:	e47ff0ef          	jal	7d0 <printint>
        i += 1;
 98e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 990:	8bca                	mv	s7,s2
      state = 0;
 992:	4981                	li	s3,0
        i += 1;
 994:	b70d                	j	8b6 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 996:	06400793          	li	a5,100
 99a:	02f60763          	beq	a2,a5,9c8 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 99e:	07500793          	li	a5,117
 9a2:	06f60963          	beq	a2,a5,a14 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 9a6:	07800793          	li	a5,120
 9aa:	faf61ee3          	bne	a2,a5,966 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ae:	008b8913          	addi	s2,s7,8
 9b2:	4681                	li	a3,0
 9b4:	4641                	li	a2,16
 9b6:	000bb583          	ld	a1,0(s7)
 9ba:	855a                	mv	a0,s6
 9bc:	e15ff0ef          	jal	7d0 <printint>
        i += 2;
 9c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9c2:	8bca                	mv	s7,s2
      state = 0;
 9c4:	4981                	li	s3,0
        i += 2;
 9c6:	bdc5                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9c8:	008b8913          	addi	s2,s7,8
 9cc:	4685                	li	a3,1
 9ce:	4629                	li	a2,10
 9d0:	000bb583          	ld	a1,0(s7)
 9d4:	855a                	mv	a0,s6
 9d6:	dfbff0ef          	jal	7d0 <printint>
        i += 2;
 9da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9dc:	8bca                	mv	s7,s2
      state = 0;
 9de:	4981                	li	s3,0
        i += 2;
 9e0:	bdd9                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 9e2:	008b8913          	addi	s2,s7,8
 9e6:	4681                	li	a3,0
 9e8:	4629                	li	a2,10
 9ea:	000be583          	lwu	a1,0(s7)
 9ee:	855a                	mv	a0,s6
 9f0:	de1ff0ef          	jal	7d0 <printint>
 9f4:	8bca                	mv	s7,s2
      state = 0;
 9f6:	4981                	li	s3,0
 9f8:	bd7d                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9fa:	008b8913          	addi	s2,s7,8
 9fe:	4681                	li	a3,0
 a00:	4629                	li	a2,10
 a02:	000bb583          	ld	a1,0(s7)
 a06:	855a                	mv	a0,s6
 a08:	dc9ff0ef          	jal	7d0 <printint>
        i += 1;
 a0c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0e:	8bca                	mv	s7,s2
      state = 0;
 a10:	4981                	li	s3,0
        i += 1;
 a12:	b555                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a14:	008b8913          	addi	s2,s7,8
 a18:	4681                	li	a3,0
 a1a:	4629                	li	a2,10
 a1c:	000bb583          	ld	a1,0(s7)
 a20:	855a                	mv	a0,s6
 a22:	dafff0ef          	jal	7d0 <printint>
        i += 2;
 a26:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	8bca                	mv	s7,s2
      state = 0;
 a2a:	4981                	li	s3,0
        i += 2;
 a2c:	b569                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a2e:	008b8913          	addi	s2,s7,8
 a32:	4681                	li	a3,0
 a34:	4641                	li	a2,16
 a36:	000be583          	lwu	a1,0(s7)
 a3a:	855a                	mv	a0,s6
 a3c:	d95ff0ef          	jal	7d0 <printint>
 a40:	8bca                	mv	s7,s2
      state = 0;
 a42:	4981                	li	s3,0
 a44:	bd8d                	j	8b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a46:	008b8913          	addi	s2,s7,8
 a4a:	4681                	li	a3,0
 a4c:	4641                	li	a2,16
 a4e:	000bb583          	ld	a1,0(s7)
 a52:	855a                	mv	a0,s6
 a54:	d7dff0ef          	jal	7d0 <printint>
        i += 1;
 a58:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a5a:	8bca                	mv	s7,s2
      state = 0;
 a5c:	4981                	li	s3,0
        i += 1;
 a5e:	bda1                	j	8b6 <vprintf+0x4a>
 a60:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a62:	008b8d13          	addi	s10,s7,8
 a66:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a6a:	03000593          	li	a1,48
 a6e:	855a                	mv	a0,s6
 a70:	d43ff0ef          	jal	7b2 <putc>
  putc(fd, 'x');
 a74:	07800593          	li	a1,120
 a78:	855a                	mv	a0,s6
 a7a:	d39ff0ef          	jal	7b2 <putc>
 a7e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a80:	00000b97          	auipc	s7,0x0
 a84:	690b8b93          	addi	s7,s7,1680 # 1110 <digits>
 a88:	03c9d793          	srli	a5,s3,0x3c
 a8c:	97de                	add	a5,a5,s7
 a8e:	0007c583          	lbu	a1,0(a5)
 a92:	855a                	mv	a0,s6
 a94:	d1fff0ef          	jal	7b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a98:	0992                	slli	s3,s3,0x4
 a9a:	397d                	addiw	s2,s2,-1
 a9c:	fe0916e3          	bnez	s2,a88 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 aa0:	8bea                	mv	s7,s10
      state = 0;
 aa2:	4981                	li	s3,0
 aa4:	6d02                	ld	s10,0(sp)
 aa6:	bd01                	j	8b6 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 aa8:	008b8913          	addi	s2,s7,8
 aac:	000bc583          	lbu	a1,0(s7)
 ab0:	855a                	mv	a0,s6
 ab2:	d01ff0ef          	jal	7b2 <putc>
 ab6:	8bca                	mv	s7,s2
      state = 0;
 ab8:	4981                	li	s3,0
 aba:	bbf5                	j	8b6 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 abc:	008b8993          	addi	s3,s7,8
 ac0:	000bb903          	ld	s2,0(s7)
 ac4:	00090f63          	beqz	s2,ae2 <vprintf+0x276>
        for (; *s; s++)
 ac8:	00094583          	lbu	a1,0(s2)
 acc:	c195                	beqz	a1,af0 <vprintf+0x284>
          putc(fd, *s);
 ace:	855a                	mv	a0,s6
 ad0:	ce3ff0ef          	jal	7b2 <putc>
        for (; *s; s++)
 ad4:	0905                	addi	s2,s2,1
 ad6:	00094583          	lbu	a1,0(s2)
 ada:	f9f5                	bnez	a1,ace <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 adc:	8bce                	mv	s7,s3
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bbd9                	j	8b6 <vprintf+0x4a>
          s = "(null)";
 ae2:	00000917          	auipc	s2,0x0
 ae6:	62690913          	addi	s2,s2,1574 # 1108 <malloc+0x51a>
        for (; *s; s++)
 aea:	02800593          	li	a1,40
 aee:	b7c5                	j	ace <vprintf+0x262>
        if ((s = va_arg(ap, char *)) == 0)
 af0:	8bce                	mv	s7,s3
      state = 0;
 af2:	4981                	li	s3,0
 af4:	b3c9                	j	8b6 <vprintf+0x4a>
 af6:	64a6                	ld	s1,72(sp)
 af8:	79e2                	ld	s3,56(sp)
 afa:	7a42                	ld	s4,48(sp)
 afc:	7aa2                	ld	s5,40(sp)
 afe:	7b02                	ld	s6,32(sp)
 b00:	6be2                	ld	s7,24(sp)
 b02:	6c42                	ld	s8,16(sp)
 b04:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b06:	60e6                	ld	ra,88(sp)
 b08:	6446                	ld	s0,80(sp)
 b0a:	6906                	ld	s2,64(sp)
 b0c:	6125                	addi	sp,sp,96
 b0e:	8082                	ret

0000000000000b10 <fprintf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
fprintf(int fd, const char *fmt, ...)
{
<<<<<<< HEAD
 af2:	715d                	addi	sp,sp,-80
 af4:	ec06                	sd	ra,24(sp)
 af6:	e822                	sd	s0,16(sp)
 af8:	1000                	addi	s0,sp,32
 afa:	e010                	sd	a2,0(s0)
 afc:	e414                	sd	a3,8(s0)
 afe:	e818                	sd	a4,16(s0)
 b00:	ec1c                	sd	a5,24(s0)
 b02:	03043023          	sd	a6,32(s0)
 b06:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b0a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b0e:	8622                	mv	a2,s0
 b10:	d3fff0ef          	jal	84e <vprintf>
}
 b14:	60e2                	ld	ra,24(sp)
 b16:	6442                	ld	s0,16(sp)
 b18:	6161                	addi	sp,sp,80
 b1a:	8082                	ret

0000000000000b1c <printf>:
=======
 b10:	715d                	addi	sp,sp,-80
 b12:	ec06                	sd	ra,24(sp)
 b14:	e822                	sd	s0,16(sp)
 b16:	1000                	addi	s0,sp,32
 b18:	e010                	sd	a2,0(s0)
 b1a:	e414                	sd	a3,8(s0)
 b1c:	e818                	sd	a4,16(s0)
 b1e:	ec1c                	sd	a5,24(s0)
 b20:	03043023          	sd	a6,32(s0)
 b24:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b28:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b2c:	8622                	mv	a2,s0
 b2e:	d3fff0ef          	jal	86c <vprintf>
}
 b32:	60e2                	ld	ra,24(sp)
 b34:	6442                	ld	s0,16(sp)
 b36:	6161                	addi	sp,sp,80
 b38:	8082                	ret

0000000000000b3a <printf>:
>>>>>>> e18456e (Updated xv6-riscv)

void
printf(const char *fmt, ...)
{
<<<<<<< HEAD
 b1c:	711d                	addi	sp,sp,-96
 b1e:	ec06                	sd	ra,24(sp)
 b20:	e822                	sd	s0,16(sp)
 b22:	1000                	addi	s0,sp,32
 b24:	e40c                	sd	a1,8(s0)
 b26:	e810                	sd	a2,16(s0)
 b28:	ec14                	sd	a3,24(s0)
 b2a:	f018                	sd	a4,32(s0)
 b2c:	f41c                	sd	a5,40(s0)
 b2e:	03043823          	sd	a6,48(s0)
 b32:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b36:	00840613          	addi	a2,s0,8
 b3a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b3e:	85aa                	mv	a1,a0
 b40:	4505                	li	a0,1
 b42:	d0dff0ef          	jal	84e <vprintf>
}
 b46:	60e2                	ld	ra,24(sp)
 b48:	6442                	ld	s0,16(sp)
 b4a:	6125                	addi	sp,sp,96
 b4c:	8082                	ret

0000000000000b4e <free>:
=======
 b3a:	711d                	addi	sp,sp,-96
 b3c:	ec06                	sd	ra,24(sp)
 b3e:	e822                	sd	s0,16(sp)
 b40:	1000                	addi	s0,sp,32
 b42:	e40c                	sd	a1,8(s0)
 b44:	e810                	sd	a2,16(s0)
 b46:	ec14                	sd	a3,24(s0)
 b48:	f018                	sd	a4,32(s0)
 b4a:	f41c                	sd	a5,40(s0)
 b4c:	03043823          	sd	a6,48(s0)
 b50:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b54:	00840613          	addi	a2,s0,8
 b58:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b5c:	85aa                	mv	a1,a0
 b5e:	4505                	li	a0,1
 b60:	d0dff0ef          	jal	86c <vprintf>
}
 b64:	60e2                	ld	ra,24(sp)
 b66:	6442                	ld	s0,16(sp)
 b68:	6125                	addi	sp,sp,96
 b6a:	8082                	ret

0000000000000b6c <free>:
>>>>>>> e18456e (Updated xv6-riscv)
static Header base;
static Header *freep;

void
free(void *ap)
{
<<<<<<< HEAD
 b4e:	1141                	addi	sp,sp,-16
 b50:	e422                	sd	s0,8(sp)
 b52:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 b54:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b58:	00001797          	auipc	a5,0x1
 b5c:	4a87b783          	ld	a5,1192(a5) # 2000 <freep>
 b60:	a02d                	j	b8a <free+0x3c>
=======
 b6c:	1141                	addi	sp,sp,-16
 b6e:	e422                	sd	s0,8(sp)
 b70:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 b72:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b76:	00001797          	auipc	a5,0x1
 b7a:	48a7b783          	ld	a5,1162(a5) # 2000 <freep>
 b7e:	a02d                	j	ba8 <free+0x3c>
>>>>>>> e18456e (Updated xv6-riscv)
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
<<<<<<< HEAD
 b62:	4618                	lw	a4,8(a2)
 b64:	9f2d                	addw	a4,a4,a1
 b66:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b6a:	6398                	ld	a4,0(a5)
 b6c:	6310                	ld	a2,0(a4)
 b6e:	a83d                	j	bac <free+0x5e>
=======
 b80:	4618                	lw	a4,8(a2)
 b82:	9f2d                	addw	a4,a4,a1
 b84:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b88:	6398                	ld	a4,0(a5)
 b8a:	6310                	ld	a2,0(a4)
 b8c:	a83d                	j	bca <free+0x5e>
>>>>>>> e18456e (Updated xv6-riscv)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
<<<<<<< HEAD
 b70:	ff852703          	lw	a4,-8(a0)
 b74:	9f31                	addw	a4,a4,a2
 b76:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b78:	ff053683          	ld	a3,-16(a0)
 b7c:	a091                	j	bc0 <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b7e:	6398                	ld	a4,0(a5)
 b80:	00e7e463          	bltu	a5,a4,b88 <free+0x3a>
 b84:	00e6ea63          	bltu	a3,a4,b98 <free+0x4a>
{
 b88:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8a:	fed7fae3          	bgeu	a5,a3,b7e <free+0x30>
 b8e:	6398                	ld	a4,0(a5)
 b90:	00e6e463          	bltu	a3,a4,b98 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b94:	fee7eae3          	bltu	a5,a4,b88 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 b98:	ff852583          	lw	a1,-8(a0)
 b9c:	6390                	ld	a2,0(a5)
 b9e:	02059813          	slli	a6,a1,0x20
 ba2:	01c85713          	srli	a4,a6,0x1c
 ba6:	9736                	add	a4,a4,a3
 ba8:	fae60de3          	beq	a2,a4,b62 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bac:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 bb0:	4790                	lw	a2,8(a5)
 bb2:	02061593          	slli	a1,a2,0x20
 bb6:	01c5d713          	srli	a4,a1,0x1c
 bba:	973e                	add	a4,a4,a5
 bbc:	fae68ae3          	beq	a3,a4,b70 <free+0x22>
    p->s.ptr = bp->s.ptr;
 bc0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 bc2:	00001717          	auipc	a4,0x1
 bc6:	42f73f23          	sd	a5,1086(a4) # 2000 <freep>
}
 bca:	6422                	ld	s0,8(sp)
 bcc:	0141                	addi	sp,sp,16
 bce:	8082                	ret

0000000000000bd0 <malloc>:
=======
 b8e:	ff852703          	lw	a4,-8(a0)
 b92:	9f31                	addw	a4,a4,a2
 b94:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b96:	ff053683          	ld	a3,-16(a0)
 b9a:	a091                	j	bde <free+0x72>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b9c:	6398                	ld	a4,0(a5)
 b9e:	00e7e463          	bltu	a5,a4,ba6 <free+0x3a>
 ba2:	00e6ea63          	bltu	a3,a4,bb6 <free+0x4a>
{
 ba6:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba8:	fed7fae3          	bgeu	a5,a3,b9c <free+0x30>
 bac:	6398                	ld	a4,0(a5)
 bae:	00e6e463          	bltu	a3,a4,bb6 <free+0x4a>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb2:	fee7eae3          	bltu	a5,a4,ba6 <free+0x3a>
  if (bp + bp->s.size == p->s.ptr) {
 bb6:	ff852583          	lw	a1,-8(a0)
 bba:	6390                	ld	a2,0(a5)
 bbc:	02059813          	slli	a6,a1,0x20
 bc0:	01c85713          	srli	a4,a6,0x1c
 bc4:	9736                	add	a4,a4,a3
 bc6:	fae60de3          	beq	a2,a4,b80 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bca:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 bce:	4790                	lw	a2,8(a5)
 bd0:	02061593          	slli	a1,a2,0x20
 bd4:	01c5d713          	srli	a4,a1,0x1c
 bd8:	973e                	add	a4,a4,a5
 bda:	fae68ae3          	beq	a3,a4,b8e <free+0x22>
    p->s.ptr = bp->s.ptr;
 bde:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 be0:	00001717          	auipc	a4,0x1
 be4:	42f73023          	sd	a5,1056(a4) # 2000 <freep>
}
 be8:	6422                	ld	s0,8(sp)
 bea:	0141                	addi	sp,sp,16
 bec:	8082                	ret

0000000000000bee <malloc>:
>>>>>>> e18456e (Updated xv6-riscv)
  return freep;
}

void *
malloc(uint nbytes)
{
<<<<<<< HEAD
 bd0:	7139                	addi	sp,sp,-64
 bd2:	fc06                	sd	ra,56(sp)
 bd4:	f822                	sd	s0,48(sp)
 bd6:	f426                	sd	s1,40(sp)
 bd8:	ec4e                	sd	s3,24(sp)
 bda:	0080                	addi	s0,sp,64
=======
 bee:	7139                	addi	sp,sp,-64
 bf0:	fc06                	sd	ra,56(sp)
 bf2:	f822                	sd	s0,48(sp)
 bf4:	f426                	sd	s1,40(sp)
 bf6:	ec4e                	sd	s3,24(sp)
 bf8:	0080                	addi	s0,sp,64
>>>>>>> e18456e (Updated xv6-riscv)
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
<<<<<<< HEAD
 bdc:	02051493          	slli	s1,a0,0x20
 be0:	9081                	srli	s1,s1,0x20
 be2:	04bd                	addi	s1,s1,15
 be4:	8091                	srli	s1,s1,0x4
 be6:	0014899b          	addiw	s3,s1,1
 bea:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 bec:	00001517          	auipc	a0,0x1
 bf0:	41453503          	ld	a0,1044(a0) # 2000 <freep>
 bf4:	c915                	beqz	a0,c28 <malloc+0x58>
=======
 bfa:	02051493          	slli	s1,a0,0x20
 bfe:	9081                	srli	s1,s1,0x20
 c00:	04bd                	addi	s1,s1,15
 c02:	8091                	srli	s1,s1,0x4
 c04:	0014899b          	addiw	s3,s1,1
 c08:	0485                	addi	s1,s1,1
  if ((prevp = freep) == 0) {
 c0a:	00001517          	auipc	a0,0x1
 c0e:	3f653503          	ld	a0,1014(a0) # 2000 <freep>
 c12:	c915                	beqz	a0,c46 <malloc+0x58>
>>>>>>> e18456e (Updated xv6-riscv)
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
<<<<<<< HEAD
 bf6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 bf8:	4798                	lw	a4,8(a5)
 bfa:	08977a63          	bgeu	a4,s1,c8e <malloc+0xbe>
 bfe:	f04a                	sd	s2,32(sp)
 c00:	e852                	sd	s4,16(sp)
 c02:	e456                	sd	s5,8(sp)
 c04:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 c06:	8a4e                	mv	s4,s3
 c08:	0009871b          	sext.w	a4,s3
 c0c:	6685                	lui	a3,0x1
 c0e:	00d77363          	bgeu	a4,a3,c14 <malloc+0x44>
 c12:	6a05                	lui	s4,0x1
 c14:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c18:	004a1a1b          	slliw	s4,s4,0x4
=======
 c14:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c16:	4798                	lw	a4,8(a5)
 c18:	08977a63          	bgeu	a4,s1,cac <malloc+0xbe>
 c1c:	f04a                	sd	s2,32(sp)
 c1e:	e852                	sd	s4,16(sp)
 c20:	e456                	sd	s5,8(sp)
 c22:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 c24:	8a4e                	mv	s4,s3
 c26:	0009871b          	sext.w	a4,s3
 c2a:	6685                	lui	a3,0x1
 c2c:	00d77363          	bgeu	a4,a3,c32 <malloc+0x44>
 c30:	6a05                	lui	s4,0x1
 c32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c36:	004a1a1b          	slliw	s4,s4,0x4
>>>>>>> e18456e (Updated xv6-riscv)
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
<<<<<<< HEAD
 c1c:	00001917          	auipc	s2,0x1
 c20:	3e490913          	addi	s2,s2,996 # 2000 <freep>
  if (p == SBRK_ERROR)
 c24:	5afd                	li	s5,-1
 c26:	a081                	j	c66 <malloc+0x96>
 c28:	f04a                	sd	s2,32(sp)
 c2a:	e852                	sd	s4,16(sp)
 c2c:	e456                	sd	s5,8(sp)
 c2e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c30:	00001797          	auipc	a5,0x1
 c34:	3e078793          	addi	a5,a5,992 # 2010 <base>
 c38:	00001717          	auipc	a4,0x1
 c3c:	3cf73423          	sd	a5,968(a4) # 2000 <freep>
 c40:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c42:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 c46:	b7c1                	j	c06 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c48:	6398                	ld	a4,0(a5)
 c4a:	e118                	sd	a4,0(a0)
 c4c:	a8a9                	j	ca6 <malloc+0xd6>
  hp->s.size = nu;
 c4e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 c52:	0541                	addi	a0,a0,16
 c54:	efbff0ef          	jal	b4e <free>
  return freep;
 c58:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 c5c:	c12d                	beqz	a0,cbe <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 c5e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c60:	4798                	lw	a4,8(a5)
 c62:	02977263          	bgeu	a4,s1,c86 <malloc+0xb6>
    if (p == freep)
 c66:	00093703          	ld	a4,0(s2)
 c6a:	853e                	mv	a0,a5
 c6c:	fef719e3          	bne	a4,a5,c5e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c70:	8552                	mv	a0,s4
 c72:	9afff0ef          	jal	620 <sbrk>
  if (p == SBRK_ERROR)
 c76:	fd551ce3          	bne	a0,s5,c4e <malloc+0x7e>
        return 0;
 c7a:	4501                	li	a0,0
 c7c:	7902                	ld	s2,32(sp)
 c7e:	6a42                	ld	s4,16(sp)
 c80:	6aa2                	ld	s5,8(sp)
 c82:	6b02                	ld	s6,0(sp)
 c84:	a03d                	j	cb2 <malloc+0xe2>
 c86:	7902                	ld	s2,32(sp)
 c88:	6a42                	ld	s4,16(sp)
 c8a:	6aa2                	ld	s5,8(sp)
 c8c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 c8e:	fae48de3          	beq	s1,a4,c48 <malloc+0x78>
        p->s.size -= nunits;
 c92:	4137073b          	subw	a4,a4,s3
 c96:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c98:	02071693          	slli	a3,a4,0x20
 c9c:	01c6d713          	srli	a4,a3,0x1c
 ca0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ca2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ca6:	00001717          	auipc	a4,0x1
 caa:	34a73d23          	sd	a0,858(a4) # 2000 <freep>
      return (void *)(p + 1);
 cae:	01078513          	addi	a0,a5,16
  }
}
 cb2:	70e2                	ld	ra,56(sp)
 cb4:	7442                	ld	s0,48(sp)
 cb6:	74a2                	ld	s1,40(sp)
 cb8:	69e2                	ld	s3,24(sp)
 cba:	6121                	addi	sp,sp,64
 cbc:	8082                	ret
 cbe:	7902                	ld	s2,32(sp)
 cc0:	6a42                	ld	s4,16(sp)
 cc2:	6aa2                	ld	s5,8(sp)
 cc4:	6b02                	ld	s6,0(sp)
 cc6:	b7f5                	j	cb2 <malloc+0xe2>
=======
 c3a:	00001917          	auipc	s2,0x1
 c3e:	3c690913          	addi	s2,s2,966 # 2000 <freep>
  if (p == SBRK_ERROR)
 c42:	5afd                	li	s5,-1
 c44:	a081                	j	c84 <malloc+0x96>
 c46:	f04a                	sd	s2,32(sp)
 c48:	e852                	sd	s4,16(sp)
 c4a:	e456                	sd	s5,8(sp)
 c4c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c4e:	00001797          	auipc	a5,0x1
 c52:	3c278793          	addi	a5,a5,962 # 2010 <base>
 c56:	00001717          	auipc	a4,0x1
 c5a:	3af73523          	sd	a5,938(a4) # 2000 <freep>
 c5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c60:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 c64:	b7c1                	j	c24 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c66:	6398                	ld	a4,0(a5)
 c68:	e118                	sd	a4,0(a0)
 c6a:	a8a9                	j	cc4 <malloc+0xd6>
  hp->s.size = nu;
 c6c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 c70:	0541                	addi	a0,a0,16
 c72:	efbff0ef          	jal	b6c <free>
  return freep;
 c76:	00093503          	ld	a0,0(s2)
      if ((p = morecore(nunits)) == 0)
 c7a:	c12d                	beqz	a0,cdc <malloc+0xee>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 c7c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 c7e:	4798                	lw	a4,8(a5)
 c80:	02977263          	bgeu	a4,s1,ca4 <malloc+0xb6>
    if (p == freep)
 c84:	00093703          	ld	a4,0(s2)
 c88:	853e                	mv	a0,a5
 c8a:	fef719e3          	bne	a4,a5,c7c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c8e:	8552                	mv	a0,s4
 c90:	991ff0ef          	jal	620 <sbrk>
  if (p == SBRK_ERROR)
 c94:	fd551ce3          	bne	a0,s5,c6c <malloc+0x7e>
        return 0;
 c98:	4501                	li	a0,0
 c9a:	7902                	ld	s2,32(sp)
 c9c:	6a42                	ld	s4,16(sp)
 c9e:	6aa2                	ld	s5,8(sp)
 ca0:	6b02                	ld	s6,0(sp)
 ca2:	a03d                	j	cd0 <malloc+0xe2>
 ca4:	7902                	ld	s2,32(sp)
 ca6:	6a42                	ld	s4,16(sp)
 ca8:	6aa2                	ld	s5,8(sp)
 caa:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 cac:	fae48de3          	beq	s1,a4,c66 <malloc+0x78>
        p->s.size -= nunits;
 cb0:	4137073b          	subw	a4,a4,s3
 cb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cb6:	02071693          	slli	a3,a4,0x20
 cba:	01c6d713          	srli	a4,a3,0x1c
 cbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cc4:	00001717          	auipc	a4,0x1
 cc8:	32a73e23          	sd	a0,828(a4) # 2000 <freep>
      return (void *)(p + 1);
 ccc:	01078513          	addi	a0,a5,16
  }
}
 cd0:	70e2                	ld	ra,56(sp)
 cd2:	7442                	ld	s0,48(sp)
 cd4:	74a2                	ld	s1,40(sp)
 cd6:	69e2                	ld	s3,24(sp)
 cd8:	6121                	addi	sp,sp,64
 cda:	8082                	ret
 cdc:	7902                	ld	s2,32(sp)
 cde:	6a42                	ld	s4,16(sp)
 ce0:	6aa2                	ld	s5,8(sp)
 ce2:	6b02                	ld	s6,0(sp)
 ce4:	b7f5                	j	cd0 <malloc+0xe2>
>>>>>>> e18456e (Updated xv6-riscv)
