
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	2e0000ef          	jal	2ec <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	2b8000ef          	jal	2ec <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  buf[sizeof(buf) - 1] = '\0';
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	70a2                	ld	ra,40(sp)
  42:	7402                	ld	s0,32(sp)
  44:	64e2                	ld	s1,24(sp)
  46:	6145                	addi	sp,sp,48
  48:	8082                	ret
  4a:	e84a                	sd	s2,16(sp)
  4c:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  4e:	8526                	mv	a0,s1
  50:	29c000ef          	jal	2ec <strlen>
  54:	862a                	mv	a2,a0
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	85a6                	mv	a1,s1
  60:	854e                	mv	a0,s3
  62:	410000ef          	jal	472 <memmove>
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  66:	8526                	mv	a0,s1
  68:	284000ef          	jal	2ec <strlen>
  6c:	892a                	mv	s2,a0
  6e:	8526                	mv	a0,s1
  70:	27c000ef          	jal	2ec <strlen>
  74:	1902                	slli	s2,s2,0x20
  76:	02095913          	srli	s2,s2,0x20
  7a:	4639                	li	a2,14
  7c:	9e09                	subw	a2,a2,a0
  7e:	02000593          	li	a1,32
  82:	01298533          	add	a0,s3,s2
  86:	294000ef          	jal	31a <memset>
  buf[sizeof(buf) - 1] = '\0';
  8a:	00098723          	sb	zero,14(s3)
  return buf;
  8e:	84ce                	mv	s1,s3
  90:	6942                	ld	s2,16(sp)
  92:	69a2                	ld	s3,8(sp)
  94:	b76d                	j	3e <fmtname+0x3e>

0000000000000096 <ls>:

void
ls(char *path)
{
  96:	d7010113          	addi	sp,sp,-656
  9a:	28113423          	sd	ra,648(sp)
  9e:	28813023          	sd	s0,640(sp)
  a2:	27213823          	sd	s2,624(sp)
  a6:	0d00                	addi	s0,sp,656
  a8:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
  aa:	4581                	li	a1,0
  ac:	4e8000ef          	jal	594 <open>
  b0:	06054363          	bltz	a0,116 <ls+0x80>
  b4:	26913c23          	sd	s1,632(sp)
  b8:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
  ba:	d7840593          	addi	a1,s0,-648
  be:	4ee000ef          	jal	5ac <fstat>
  c2:	06054363          	bltz	a0,128 <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type) {
  c6:	d8041783          	lh	a5,-640(s0)
  ca:	4705                	li	a4,1
  cc:	06e78c63          	beq	a5,a4,144 <ls+0xae>
  d0:	37f9                	addiw	a5,a5,-2
  d2:	17c2                	slli	a5,a5,0x30
  d4:	93c1                	srli	a5,a5,0x30
  d6:	02f76263          	bltu	a4,a5,fa <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int)st.size);
  da:	854a                	mv	a0,s2
  dc:	f25ff0ef          	jal	0 <fmtname>
  e0:	85aa                	mv	a1,a0
  e2:	d8842703          	lw	a4,-632(s0)
  e6:	d7c42683          	lw	a3,-644(s0)
  ea:	d8041603          	lh	a2,-640(s0)
  ee:	00001517          	auipc	a0,0x1
  f2:	af250513          	addi	a0,a0,-1294 # be0 <malloc+0x12e>
  f6:	105000ef          	jal	9fa <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
    }
    break;
  }
  close(fd);
  fa:	8526                	mv	a0,s1
  fc:	480000ef          	jal	57c <close>
 100:	27813483          	ld	s1,632(sp)
}
 104:	28813083          	ld	ra,648(sp)
 108:	28013403          	ld	s0,640(sp)
 10c:	27013903          	ld	s2,624(sp)
 110:	29010113          	addi	sp,sp,656
 114:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 116:	864a                	mv	a2,s2
 118:	00001597          	auipc	a1,0x1
 11c:	a9858593          	addi	a1,a1,-1384 # bb0 <malloc+0xfe>
 120:	4509                	li	a0,2
 122:	0af000ef          	jal	9d0 <fprintf>
    return;
 126:	bff9                	j	104 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 128:	864a                	mv	a2,s2
 12a:	00001597          	auipc	a1,0x1
 12e:	a9e58593          	addi	a1,a1,-1378 # bc8 <malloc+0x116>
 132:	4509                	li	a0,2
 134:	09d000ef          	jal	9d0 <fprintf>
    close(fd);
 138:	8526                	mv	a0,s1
 13a:	442000ef          	jal	57c <close>
    return;
 13e:	27813483          	ld	s1,632(sp)
 142:	b7c9                	j	104 <ls+0x6e>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 144:	854a                	mv	a0,s2
 146:	1a6000ef          	jal	2ec <strlen>
 14a:	2541                	addiw	a0,a0,16
 14c:	20000793          	li	a5,512
 150:	00a7f963          	bgeu	a5,a0,162 <ls+0xcc>
      printf("ls: path too long\n");
 154:	00001517          	auipc	a0,0x1
 158:	a9c50513          	addi	a0,a0,-1380 # bf0 <malloc+0x13e>
 15c:	09f000ef          	jal	9fa <printf>
      break;
 160:	bf69                	j	fa <ls+0x64>
 162:	27313423          	sd	s3,616(sp)
 166:	27413023          	sd	s4,608(sp)
 16a:	25513c23          	sd	s5,600(sp)
 16e:	25613823          	sd	s6,592(sp)
 172:	25713423          	sd	s7,584(sp)
 176:	25813023          	sd	s8,576(sp)
 17a:	23913c23          	sd	s9,568(sp)
 17e:	23a13823          	sd	s10,560(sp)
    strcpy(buf, path);
 182:	da040993          	addi	s3,s0,-608
 186:	85ca                	mv	a1,s2
 188:	854e                	mv	a0,s3
 18a:	112000ef          	jal	29c <strcpy>
    p = buf + strlen(buf);
 18e:	854e                	mv	a0,s3
 190:	15c000ef          	jal	2ec <strlen>
 194:	1502                	slli	a0,a0,0x20
 196:	9101                	srli	a0,a0,0x20
 198:	99aa                	add	s3,s3,a0
    *p++ = '/';
 19a:	00198c93          	addi	s9,s3,1
 19e:	02f00793          	li	a5,47
 1a2:	00f98023          	sb	a5,0(s3)
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1a6:	d9040a13          	addi	s4,s0,-624
 1aa:	4941                	li	s2,16
      memmove(p, de.name, DIRSIZ);
 1ac:	d9240c13          	addi	s8,s0,-622
 1b0:	4bb9                	li	s7,14
      if (stat(buf, &st) < 0) {
 1b2:	d7840b13          	addi	s6,s0,-648
 1b6:	da040a93          	addi	s5,s0,-608
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
 1ba:	00001d17          	auipc	s10,0x1
 1be:	a26d0d13          	addi	s10,s10,-1498 # be0 <malloc+0x12e>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1c2:	a801                	j	1d2 <ls+0x13c>
        printf("ls: cannot stat %s\n", buf);
 1c4:	85d6                	mv	a1,s5
 1c6:	00001517          	auipc	a0,0x1
 1ca:	a0250513          	addi	a0,a0,-1534 # bc8 <malloc+0x116>
 1ce:	02d000ef          	jal	9fa <printf>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1d2:	864a                	mv	a2,s2
 1d4:	85d2                	mv	a1,s4
 1d6:	8526                	mv	a0,s1
 1d8:	394000ef          	jal	56c <read>
 1dc:	05251063          	bne	a0,s2,21c <ls+0x186>
      if (de.inum == 0)
 1e0:	d9045783          	lhu	a5,-624(s0)
 1e4:	d7fd                	beqz	a5,1d2 <ls+0x13c>
      memmove(p, de.name, DIRSIZ);
 1e6:	865e                	mv	a2,s7
 1e8:	85e2                	mv	a1,s8
 1ea:	8566                	mv	a0,s9
 1ec:	286000ef          	jal	472 <memmove>
      p[DIRSIZ] = 0;
 1f0:	000987a3          	sb	zero,15(s3)
      if (stat(buf, &st) < 0) {
 1f4:	85da                	mv	a1,s6
 1f6:	8556                	mv	a0,s5
 1f8:	1f4000ef          	jal	3ec <stat>
 1fc:	fc0544e3          	bltz	a0,1c4 <ls+0x12e>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
 200:	8556                	mv	a0,s5
 202:	dffff0ef          	jal	0 <fmtname>
 206:	85aa                	mv	a1,a0
 208:	d8842703          	lw	a4,-632(s0)
 20c:	d7c42683          	lw	a3,-644(s0)
 210:	d8041603          	lh	a2,-640(s0)
 214:	856a                	mv	a0,s10
 216:	7e4000ef          	jal	9fa <printf>
 21a:	bf65                	j	1d2 <ls+0x13c>
 21c:	26813983          	ld	s3,616(sp)
 220:	26013a03          	ld	s4,608(sp)
 224:	25813a83          	ld	s5,600(sp)
 228:	25013b03          	ld	s6,592(sp)
 22c:	24813b83          	ld	s7,584(sp)
 230:	24013c03          	ld	s8,576(sp)
 234:	23813c83          	ld	s9,568(sp)
 238:	23013d03          	ld	s10,560(sp)
 23c:	bd7d                	j	fa <ls+0x64>

000000000000023e <main>:

int
main(int argc, char *argv[])
{
 23e:	1101                	addi	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
 246:	4785                	li	a5,1
 248:	02a7d763          	bge	a5,a0,276 <main+0x38>
 24c:	e426                	sd	s1,8(sp)
 24e:	e04a                	sd	s2,0(sp)
 250:	00858493          	addi	s1,a1,8
 254:	ffe5091b          	addiw	s2,a0,-2
 258:	02091793          	slli	a5,s2,0x20
 25c:	01d7d913          	srli	s2,a5,0x1d
 260:	05c1                	addi	a1,a1,16
 262:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
 264:	6088                	ld	a0,0(s1)
 266:	e31ff0ef          	jal	96 <ls>
  for (i = 1; i < argc; i++)
 26a:	04a1                	addi	s1,s1,8
 26c:	ff249ce3          	bne	s1,s2,264 <main+0x26>
  exit(0);
 270:	4501                	li	a0,0
 272:	2e2000ef          	jal	554 <exit>
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
    ls(".");
 27a:	00001517          	auipc	a0,0x1
 27e:	98e50513          	addi	a0,a0,-1650 # c08 <malloc+0x156>
 282:	e15ff0ef          	jal	96 <ls>
    exit(0);
 286:	4501                	li	a0,0
 288:	2cc000ef          	jal	554 <exit>

000000000000028c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 294:	fabff0ef          	jal	23e <main>
  exit(r);
 298:	2bc000ef          	jal	554 <exit>

000000000000029c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 2a4:	87aa                	mv	a5,a0
 2a6:	0585                	addi	a1,a1,1
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff5c703          	lbu	a4,-1(a1)
 2ae:	fee78fa3          	sb	a4,-1(a5)
 2b2:	fb75                	bnez	a4,2a6 <strcpy+0xa>
    ;
  return os;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cb91                	beqz	a5,2dc <strcmp+0x20>
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00f71763          	bne	a4,a5,2dc <strcmp+0x20>
    p++, q++;
 2d2:	0505                	addi	a0,a0,1
 2d4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	fbe5                	bnez	a5,2ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2dc:	0005c503          	lbu	a0,0(a1)
}
 2e0:	40a7853b          	subw	a0,a5,a0
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <strlen>:

uint
strlen(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2f4:	00054783          	lbu	a5,0(a0)
 2f8:	cf99                	beqz	a5,316 <strlen+0x2a>
 2fa:	0505                	addi	a0,a0,1
 2fc:	87aa                	mv	a5,a0
 2fe:	86be                	mv	a3,a5
 300:	0785                	addi	a5,a5,1
 302:	fff7c703          	lbu	a4,-1(a5)
 306:	ff65                	bnez	a4,2fe <strlen+0x12>
 308:	40a6853b          	subw	a0,a3,a0
 30c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  for (n = 0; s[n]; n++)
 316:	4501                	li	a0,0
 318:	bfdd                	j	30e <strlen+0x22>

000000000000031a <memset>:

void *
memset(void *dst, int c, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 322:	ca19                	beqz	a2,338 <memset+0x1e>
 324:	87aa                	mv	a5,a0
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 32e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 332:	0785                	addi	a5,a5,1
 334:	fee79de3          	bne	a5,a4,32e <memset+0x14>
  }
  return dst;
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <strchr>:

char *
strchr(const char *s, char c)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  for (; *s; s++)
 348:	00054783          	lbu	a5,0(a0)
 34c:	cf81                	beqz	a5,364 <strchr+0x24>
    if (*s == c)
 34e:	00f58763          	beq	a1,a5,35c <strchr+0x1c>
  for (; *s; s++)
 352:	0505                	addi	a0,a0,1
 354:	00054783          	lbu	a5,0(a0)
 358:	fbfd                	bnez	a5,34e <strchr+0xe>
      return (char *)s;
  return 0;
 35a:	4501                	li	a0,0
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret
  return 0;
 364:	4501                	li	a0,0
 366:	bfdd                	j	35c <strchr+0x1c>

0000000000000368 <gets>:

char *
gets(char *buf, int max)
{
 368:	7159                	addi	sp,sp,-112
 36a:	f486                	sd	ra,104(sp)
 36c:	f0a2                	sd	s0,96(sp)
 36e:	eca6                	sd	s1,88(sp)
 370:	e8ca                	sd	s2,80(sp)
 372:	e4ce                	sd	s3,72(sp)
 374:	e0d2                	sd	s4,64(sp)
 376:	fc56                	sd	s5,56(sp)
 378:	f85a                	sd	s6,48(sp)
 37a:	f45e                	sd	s7,40(sp)
 37c:	f062                	sd	s8,32(sp)
 37e:	ec66                	sd	s9,24(sp)
 380:	e86a                	sd	s10,16(sp)
 382:	1880                	addi	s0,sp,112
 384:	8caa                	mv	s9,a0
 386:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 388:	892a                	mv	s2,a0
 38a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38c:	f9f40b13          	addi	s6,s0,-97
 390:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
 392:	4ba9                	li	s7,10
 394:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
 396:	8d26                	mv	s10,s1
 398:	0014899b          	addiw	s3,s1,1
 39c:	84ce                	mv	s1,s3
 39e:	0349d563          	bge	s3,s4,3c8 <gets+0x60>
    cc = read(0, &c, 1);
 3a2:	8656                	mv	a2,s5
 3a4:	85da                	mv	a1,s6
 3a6:	4501                	li	a0,0
 3a8:	1c4000ef          	jal	56c <read>
    if (cc < 1)
 3ac:	00a05e63          	blez	a0,3c8 <gets+0x60>
    buf[i++] = c;
 3b0:	f9f44783          	lbu	a5,-97(s0)
 3b4:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 3b8:	01778763          	beq	a5,s7,3c6 <gets+0x5e>
 3bc:	0905                	addi	s2,s2,1
 3be:	fd879ce3          	bne	a5,s8,396 <gets+0x2e>
    buf[i++] = c;
 3c2:	8d4e                	mv	s10,s3
 3c4:	a011                	j	3c8 <gets+0x60>
 3c6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 3c8:	9d66                	add	s10,s10,s9
 3ca:	000d0023          	sb	zero,0(s10)
  return buf;
}
 3ce:	8566                	mv	a0,s9
 3d0:	70a6                	ld	ra,104(sp)
 3d2:	7406                	ld	s0,96(sp)
 3d4:	64e6                	ld	s1,88(sp)
 3d6:	6946                	ld	s2,80(sp)
 3d8:	69a6                	ld	s3,72(sp)
 3da:	6a06                	ld	s4,64(sp)
 3dc:	7ae2                	ld	s5,56(sp)
 3de:	7b42                	ld	s6,48(sp)
 3e0:	7ba2                	ld	s7,40(sp)
 3e2:	7c02                	ld	s8,32(sp)
 3e4:	6ce2                	ld	s9,24(sp)
 3e6:	6d42                	ld	s10,16(sp)
 3e8:	6165                	addi	sp,sp,112
 3ea:	8082                	ret

00000000000003ec <stat>:

int
stat(const char *n, struct stat *st)
{
 3ec:	1101                	addi	sp,sp,-32
 3ee:	ec06                	sd	ra,24(sp)
 3f0:	e822                	sd	s0,16(sp)
 3f2:	e04a                	sd	s2,0(sp)
 3f4:	1000                	addi	s0,sp,32
 3f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f8:	4581                	li	a1,0
 3fa:	19a000ef          	jal	594 <open>
  if (fd < 0)
 3fe:	02054263          	bltz	a0,422 <stat+0x36>
 402:	e426                	sd	s1,8(sp)
 404:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 406:	85ca                	mv	a1,s2
 408:	1a4000ef          	jal	5ac <fstat>
 40c:	892a                	mv	s2,a0
  close(fd);
 40e:	8526                	mv	a0,s1
 410:	16c000ef          	jal	57c <close>
  return r;
 414:	64a2                	ld	s1,8(sp)
}
 416:	854a                	mv	a0,s2
 418:	60e2                	ld	ra,24(sp)
 41a:	6442                	ld	s0,16(sp)
 41c:	6902                	ld	s2,0(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret
    return -1;
 422:	597d                	li	s2,-1
 424:	bfcd                	j	416 <stat+0x2a>

0000000000000426 <atoi>:

int
atoi(const char *s)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 42e:	00054683          	lbu	a3,0(a0)
 432:	fd06879b          	addiw	a5,a3,-48
 436:	0ff7f793          	zext.b	a5,a5
 43a:	4625                	li	a2,9
 43c:	02f66963          	bltu	a2,a5,46e <atoi+0x48>
 440:	872a                	mv	a4,a0
  n = 0;
 442:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 444:	0705                	addi	a4,a4,1
 446:	0025179b          	slliw	a5,a0,0x2
 44a:	9fa9                	addw	a5,a5,a0
 44c:	0017979b          	slliw	a5,a5,0x1
 450:	9fb5                	addw	a5,a5,a3
 452:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 456:	00074683          	lbu	a3,0(a4)
 45a:	fd06879b          	addiw	a5,a3,-48
 45e:	0ff7f793          	zext.b	a5,a5
 462:	fef671e3          	bgeu	a2,a5,444 <atoi+0x1e>
  return n;
}
 466:	60a2                	ld	ra,8(sp)
 468:	6402                	ld	s0,0(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
  n = 0;
 46e:	4501                	li	a0,0
 470:	bfdd                	j	466 <atoi+0x40>

0000000000000472 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 47a:	02b57563          	bgeu	a0,a1,4a4 <memmove+0x32>
    while (n-- > 0)
 47e:	00c05f63          	blez	a2,49c <memmove+0x2a>
 482:	1602                	slli	a2,a2,0x20
 484:	9201                	srli	a2,a2,0x20
 486:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 48a:	872a                	mv	a4,a0
      *dst++ = *src++;
 48c:	0585                	addi	a1,a1,1
 48e:	0705                	addi	a4,a4,1
 490:	fff5c683          	lbu	a3,-1(a1)
 494:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 498:	fee79ae3          	bne	a5,a4,48c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 49c:	60a2                	ld	ra,8(sp)
 49e:	6402                	ld	s0,0(sp)
 4a0:	0141                	addi	sp,sp,16
 4a2:	8082                	ret
    dst += n;
 4a4:	00c50733          	add	a4,a0,a2
    src += n;
 4a8:	95b2                	add	a1,a1,a2
    while (n-- > 0)
 4aa:	fec059e3          	blez	a2,49c <memmove+0x2a>
 4ae:	fff6079b          	addiw	a5,a2,-1
 4b2:	1782                	slli	a5,a5,0x20
 4b4:	9381                	srli	a5,a5,0x20
 4b6:	fff7c793          	not	a5,a5
 4ba:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4bc:	15fd                	addi	a1,a1,-1
 4be:	177d                	addi	a4,a4,-1
 4c0:	0005c683          	lbu	a3,0(a1)
 4c4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 4c8:	fef71ae3          	bne	a4,a5,4bc <memmove+0x4a>
 4cc:	bfc1                	j	49c <memmove+0x2a>

00000000000004ce <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ce:	1141                	addi	sp,sp,-16
 4d0:	e406                	sd	ra,8(sp)
 4d2:	e022                	sd	s0,0(sp)
 4d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4d6:	ca0d                	beqz	a2,508 <memcmp+0x3a>
 4d8:	fff6069b          	addiw	a3,a2,-1
 4dc:	1682                	slli	a3,a3,0x20
 4de:	9281                	srli	a3,a3,0x20
 4e0:	0685                	addi	a3,a3,1
 4e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4e4:	00054783          	lbu	a5,0(a0)
 4e8:	0005c703          	lbu	a4,0(a1)
 4ec:	00e79863          	bne	a5,a4,4fc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 4f0:	0505                	addi	a0,a0,1
    p2++;
 4f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4f4:	fed518e3          	bne	a0,a3,4e4 <memcmp+0x16>
  }
  return 0;
 4f8:	4501                	li	a0,0
 4fa:	a019                	j	500 <memcmp+0x32>
      return *p1 - *p2;
 4fc:	40e7853b          	subw	a0,a5,a4
}
 500:	60a2                	ld	ra,8(sp)
 502:	6402                	ld	s0,0(sp)
 504:	0141                	addi	sp,sp,16
 506:	8082                	ret
  return 0;
 508:	4501                	li	a0,0
 50a:	bfdd                	j	500 <memcmp+0x32>

000000000000050c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 50c:	1141                	addi	sp,sp,-16
 50e:	e406                	sd	ra,8(sp)
 510:	e022                	sd	s0,0(sp)
 512:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 514:	f5fff0ef          	jal	472 <memmove>
}
 518:	60a2                	ld	ra,8(sp)
 51a:	6402                	ld	s0,0(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret

0000000000000520 <sbrk>:

char *
sbrk(int n)
{
 520:	1141                	addi	sp,sp,-16
 522:	e406                	sd	ra,8(sp)
 524:	e022                	sd	s0,0(sp)
 526:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 528:	4585                	li	a1,1
 52a:	0b2000ef          	jal	5dc <sys_sbrk>
}
 52e:	60a2                	ld	ra,8(sp)
 530:	6402                	ld	s0,0(sp)
 532:	0141                	addi	sp,sp,16
 534:	8082                	ret

0000000000000536 <sbrklazy>:

char *
sbrklazy(int n)
{
 536:	1141                	addi	sp,sp,-16
 538:	e406                	sd	ra,8(sp)
 53a:	e022                	sd	s0,0(sp)
 53c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 53e:	4589                	li	a1,2
 540:	09c000ef          	jal	5dc <sys_sbrk>
}
 544:	60a2                	ld	ra,8(sp)
 546:	6402                	ld	s0,0(sp)
 548:	0141                	addi	sp,sp,16
 54a:	8082                	ret

000000000000054c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 54c:	4885                	li	a7,1
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <exit>:
.global exit
exit:
 li a7, SYS_exit
 554:	4889                	li	a7,2
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <wait>:
.global wait
wait:
 li a7, SYS_wait
 55c:	488d                	li	a7,3
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 564:	4891                	li	a7,4
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <read>:
.global read
read:
 li a7, SYS_read
 56c:	4895                	li	a7,5
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <write>:
.global write
write:
 li a7, SYS_write
 574:	48c1                	li	a7,16
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <close>:
.global close
close:
 li a7, SYS_close
 57c:	48d5                	li	a7,21
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <kill>:
.global kill
kill:
 li a7, SYS_kill
 584:	4899                	li	a7,6
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <exec>:
.global exec
exec:
 li a7, SYS_exec
 58c:	489d                	li	a7,7
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <open>:
.global open
open:
 li a7, SYS_open
 594:	48bd                	li	a7,15
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 59c:	48c5                	li	a7,17
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5a4:	48c9                	li	a7,18
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5ac:	48a1                	li	a7,8
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <link>:
.global link
link:
 li a7, SYS_link
 5b4:	48cd                	li	a7,19
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5bc:	48d1                	li	a7,20
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5c4:	48a5                	li	a7,9
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5cc:	48a9                	li	a7,10
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5d4:	48ad                	li	a7,11
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5dc:	48b1                	li	a7,12
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5e4:	48b5                	li	a7,13
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5ec:	48b9                	li	a7,14
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 5f4:	48d9                	li	a7,22
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <ps>:
.global ps
ps:
 li a7, SYS_ps
 5fc:	48dd                	li	a7,23
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 604:	48e1                	li	a7,24
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 60c:	48e5                	li	a7,25
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 614:	48e9                	li	a7,26
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <trace>:
.global trace
trace:
 li a7, SYS_trace
 61c:	48ed                	li	a7,27
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 624:	48f1                	li	a7,28
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 62c:	48f5                	li	a7,29
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <ptree>:
.global ptree
ptree:
 li a7, SYS_ptree
 634:	48f9                	li	a7,30
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <getsyscallcount>:
.global getsyscallcount
getsyscallcount:
 li a7, SYS_getsyscallcount
 63c:	48fd                	li	a7,31
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <waitx>:
.global waitx
waitx:
 li a7, SYS_waitx
 644:	02000893          	li	a7,32
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <halt>:
.global halt
halt:
 li a7, SYS_halt
 64e:	02100893          	li	a7,33
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <reboot>:
.global reboot
reboot:
 li a7, SYS_reboot
 658:	02200893          	li	a7,34
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <sched_yield>:
.global sched_yield
sched_yield:
 li a7, SYS_sched_yield
 662:	02300893          	li	a7,35
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <getcpuid>:
.global getcpuid
getcpuid:
 li a7, SYS_getcpuid
 66c:	02400893          	li	a7,36
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <setprocname>:
.global setprocname
setprocname:
 li a7, SYS_setprocname
 676:	02500893          	li	a7,37
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 680:	1101                	addi	sp,sp,-32
 682:	ec06                	sd	ra,24(sp)
 684:	e822                	sd	s0,16(sp)
 686:	1000                	addi	s0,sp,32
 688:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 68c:	4605                	li	a2,1
 68e:	fef40593          	addi	a1,s0,-17
 692:	ee3ff0ef          	jal	574 <write>
}
 696:	60e2                	ld	ra,24(sp)
 698:	6442                	ld	s0,16(sp)
 69a:	6105                	addi	sp,sp,32
 69c:	8082                	ret

000000000000069e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 69e:	715d                	addi	sp,sp,-80
 6a0:	e486                	sd	ra,72(sp)
 6a2:	e0a2                	sd	s0,64(sp)
 6a4:	fc26                	sd	s1,56(sp)
 6a6:	f84a                	sd	s2,48(sp)
 6a8:	f44e                	sd	s3,40(sp)
 6aa:	0880                	addi	s0,sp,80
 6ac:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 6ae:	c299                	beqz	a3,6b4 <printint+0x16>
 6b0:	0605cc63          	bltz	a1,728 <printint+0x8a>
  neg = 0;
 6b4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 6b6:	fb840313          	addi	t1,s0,-72
  neg = 0;
 6ba:	869a                	mv	a3,t1
  i = 0;
 6bc:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
 6be:	00000817          	auipc	a6,0x0
 6c2:	55a80813          	addi	a6,a6,1370 # c18 <digits>
 6c6:	88be                	mv	a7,a5
 6c8:	0017851b          	addiw	a0,a5,1
 6cc:	87aa                	mv	a5,a0
 6ce:	02c5f733          	remu	a4,a1,a2
 6d2:	9742                	add	a4,a4,a6
 6d4:	00074703          	lbu	a4,0(a4)
 6d8:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
 6dc:	872e                	mv	a4,a1
 6de:	02c5d5b3          	divu	a1,a1,a2
 6e2:	0685                	addi	a3,a3,1
 6e4:	fec771e3          	bgeu	a4,a2,6c6 <printint+0x28>
  if (neg)
 6e8:	000e0c63          	beqz	t3,700 <printint+0x62>
    buf[i++] = '-';
 6ec:	fd050793          	addi	a5,a0,-48
 6f0:	00878533          	add	a0,a5,s0
 6f4:	02d00793          	li	a5,45
 6f8:	fef50423          	sb	a5,-24(a0)
 6fc:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
 700:	fff7899b          	addiw	s3,a5,-1
 704:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 708:	fff4c583          	lbu	a1,-1(s1)
 70c:	854a                	mv	a0,s2
 70e:	f73ff0ef          	jal	680 <putc>
  while (--i >= 0)
 712:	39fd                	addiw	s3,s3,-1
 714:	14fd                	addi	s1,s1,-1
 716:	fe09d9e3          	bgez	s3,708 <printint+0x6a>
}
 71a:	60a6                	ld	ra,72(sp)
 71c:	6406                	ld	s0,64(sp)
 71e:	74e2                	ld	s1,56(sp)
 720:	7942                	ld	s2,48(sp)
 722:	79a2                	ld	s3,40(sp)
 724:	6161                	addi	sp,sp,80
 726:	8082                	ret
    x = -xx;
 728:	40b005b3          	neg	a1,a1
    neg = 1;
 72c:	4e05                	li	t3,1
    x = -xx;
 72e:	b761                	j	6b6 <printint+0x18>

0000000000000730 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 730:	711d                	addi	sp,sp,-96
 732:	ec86                	sd	ra,88(sp)
 734:	e8a2                	sd	s0,80(sp)
 736:	e4a6                	sd	s1,72(sp)
 738:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 73a:	0005c483          	lbu	s1,0(a1)
 73e:	28048463          	beqz	s1,9c6 <vprintf+0x296>
 742:	e0ca                	sd	s2,64(sp)
 744:	fc4e                	sd	s3,56(sp)
 746:	f852                	sd	s4,48(sp)
 748:	f456                	sd	s5,40(sp)
 74a:	f05a                	sd	s6,32(sp)
 74c:	ec5e                	sd	s7,24(sp)
 74e:	e862                	sd	s8,16(sp)
 750:	e466                	sd	s9,8(sp)
 752:	8b2a                	mv	s6,a0
 754:	8a2e                	mv	s4,a1
 756:	8bb2                	mv	s7,a2
  state = 0;
 758:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 75a:	4901                	li	s2,0
 75c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 75e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 762:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 766:	06c00c93          	li	s9,108
 76a:	a00d                	j	78c <vprintf+0x5c>
        putc(fd, c0);
 76c:	85a6                	mv	a1,s1
 76e:	855a                	mv	a0,s6
 770:	f11ff0ef          	jal	680 <putc>
 774:	a019                	j	77a <vprintf+0x4a>
    } else if (state == '%') {
 776:	03598363          	beq	s3,s5,79c <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
 77a:	0019079b          	addiw	a5,s2,1
 77e:	893e                	mv	s2,a5
 780:	873e                	mv	a4,a5
 782:	97d2                	add	a5,a5,s4
 784:	0007c483          	lbu	s1,0(a5)
 788:	22048763          	beqz	s1,9b6 <vprintf+0x286>
    c0 = fmt[i] & 0xff;
 78c:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 790:	fe0993e3          	bnez	s3,776 <vprintf+0x46>
      if (c0 == '%') {
 794:	fd579ce3          	bne	a5,s5,76c <vprintf+0x3c>
        state = '%';
 798:	89be                	mv	s3,a5
 79a:	b7c5                	j	77a <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
 79c:	00ea06b3          	add	a3,s4,a4
 7a0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7a4:	8636                	mv	a2,a3
      if (c1)
 7a6:	c681                	beqz	a3,7ae <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
 7a8:	9752                	add	a4,a4,s4
 7aa:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
 7ae:	05878263          	beq	a5,s8,7f2 <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
 7b2:	05978c63          	beq	a5,s9,80a <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 7b6:	07500713          	li	a4,117
 7ba:	0ee78663          	beq	a5,a4,8a6 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 7be:	07800713          	li	a4,120
 7c2:	12e78863          	beq	a5,a4,8f2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 7c6:	07000713          	li	a4,112
 7ca:	14e78d63          	beq	a5,a4,924 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 7ce:	06300713          	li	a4,99
 7d2:	18e78c63          	beq	a5,a4,96a <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 7d6:	07300713          	li	a4,115
 7da:	1ae78263          	beq	a5,a4,97e <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 7de:	02500713          	li	a4,37
 7e2:	04e79463          	bne	a5,a4,82a <vprintf+0xfa>
        putc(fd, '%');
 7e6:	85ba                	mv	a1,a4
 7e8:	855a                	mv	a0,s6
 7ea:	e97ff0ef          	jal	680 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b769                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7f2:	008b8493          	addi	s1,s7,8
 7f6:	4685                	li	a3,1
 7f8:	4629                	li	a2,10
 7fa:	000ba583          	lw	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	e9fff0ef          	jal	69e <printint>
 804:	8ba6                	mv	s7,s1
      state = 0;
 806:	4981                	li	s3,0
 808:	bf8d                	j	77a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
 80a:	06400793          	li	a5,100
 80e:	02f68963          	beq	a3,a5,840 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 812:	06c00793          	li	a5,108
 816:	04f68263          	beq	a3,a5,85a <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
 81a:	07500793          	li	a5,117
 81e:	0af68063          	beq	a3,a5,8be <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
 822:	07800793          	li	a5,120
 826:	0ef68263          	beq	a3,a5,90a <vprintf+0x1da>
        putc(fd, '%');
 82a:	02500593          	li	a1,37
 82e:	855a                	mv	a0,s6
 830:	e51ff0ef          	jal	680 <putc>
        putc(fd, c0);
 834:	85a6                	mv	a1,s1
 836:	855a                	mv	a0,s6
 838:	e49ff0ef          	jal	680 <putc>
      state = 0;
 83c:	4981                	li	s3,0
 83e:	bf35                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 840:	008b8493          	addi	s1,s7,8
 844:	4685                	li	a3,1
 846:	4629                	li	a2,10
 848:	000bb583          	ld	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	e51ff0ef          	jal	69e <printint>
        i += 1;
 852:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 854:	8ba6                	mv	s7,s1
      state = 0;
 856:	4981                	li	s3,0
        i += 1;
 858:	b70d                	j	77a <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 85a:	06400793          	li	a5,100
 85e:	02f60763          	beq	a2,a5,88c <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 862:	07500793          	li	a5,117
 866:	06f60963          	beq	a2,a5,8d8 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 86a:	07800793          	li	a5,120
 86e:	faf61ee3          	bne	a2,a5,82a <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 872:	008b8493          	addi	s1,s7,8
 876:	4681                	li	a3,0
 878:	4641                	li	a2,16
 87a:	000bb583          	ld	a1,0(s7)
 87e:	855a                	mv	a0,s6
 880:	e1fff0ef          	jal	69e <printint>
        i += 2;
 884:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 886:	8ba6                	mv	s7,s1
      state = 0;
 888:	4981                	li	s3,0
        i += 2;
 88a:	bdc5                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 88c:	008b8493          	addi	s1,s7,8
 890:	4685                	li	a3,1
 892:	4629                	li	a2,10
 894:	000bb583          	ld	a1,0(s7)
 898:	855a                	mv	a0,s6
 89a:	e05ff0ef          	jal	69e <printint>
        i += 2;
 89e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a0:	8ba6                	mv	s7,s1
      state = 0;
 8a2:	4981                	li	s3,0
        i += 2;
 8a4:	bdd9                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8a6:	008b8493          	addi	s1,s7,8
 8aa:	4681                	li	a3,0
 8ac:	4629                	li	a2,10
 8ae:	000be583          	lwu	a1,0(s7)
 8b2:	855a                	mv	a0,s6
 8b4:	debff0ef          	jal	69e <printint>
 8b8:	8ba6                	mv	s7,s1
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	bd7d                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8be:	008b8493          	addi	s1,s7,8
 8c2:	4681                	li	a3,0
 8c4:	4629                	li	a2,10
 8c6:	000bb583          	ld	a1,0(s7)
 8ca:	855a                	mv	a0,s6
 8cc:	dd3ff0ef          	jal	69e <printint>
        i += 1;
 8d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d2:	8ba6                	mv	s7,s1
      state = 0;
 8d4:	4981                	li	s3,0
        i += 1;
 8d6:	b555                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d8:	008b8493          	addi	s1,s7,8
 8dc:	4681                	li	a3,0
 8de:	4629                	li	a2,10
 8e0:	000bb583          	ld	a1,0(s7)
 8e4:	855a                	mv	a0,s6
 8e6:	db9ff0ef          	jal	69e <printint>
        i += 2;
 8ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ec:	8ba6                	mv	s7,s1
      state = 0;
 8ee:	4981                	li	s3,0
        i += 2;
 8f0:	b569                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 8f2:	008b8493          	addi	s1,s7,8
 8f6:	4681                	li	a3,0
 8f8:	4641                	li	a2,16
 8fa:	000be583          	lwu	a1,0(s7)
 8fe:	855a                	mv	a0,s6
 900:	d9fff0ef          	jal	69e <printint>
 904:	8ba6                	mv	s7,s1
      state = 0;
 906:	4981                	li	s3,0
 908:	bd8d                	j	77a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 90a:	008b8493          	addi	s1,s7,8
 90e:	4681                	li	a3,0
 910:	4641                	li	a2,16
 912:	000bb583          	ld	a1,0(s7)
 916:	855a                	mv	a0,s6
 918:	d87ff0ef          	jal	69e <printint>
        i += 1;
 91c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 91e:	8ba6                	mv	s7,s1
      state = 0;
 920:	4981                	li	s3,0
        i += 1;
 922:	bda1                	j	77a <vprintf+0x4a>
 924:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 926:	008b8d13          	addi	s10,s7,8
 92a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 92e:	03000593          	li	a1,48
 932:	855a                	mv	a0,s6
 934:	d4dff0ef          	jal	680 <putc>
  putc(fd, 'x');
 938:	07800593          	li	a1,120
 93c:	855a                	mv	a0,s6
 93e:	d43ff0ef          	jal	680 <putc>
 942:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 944:	00000b97          	auipc	s7,0x0
 948:	2d4b8b93          	addi	s7,s7,724 # c18 <digits>
 94c:	03c9d793          	srli	a5,s3,0x3c
 950:	97de                	add	a5,a5,s7
 952:	0007c583          	lbu	a1,0(a5)
 956:	855a                	mv	a0,s6
 958:	d29ff0ef          	jal	680 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 95c:	0992                	slli	s3,s3,0x4
 95e:	34fd                	addiw	s1,s1,-1
 960:	f4f5                	bnez	s1,94c <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 962:	8bea                	mv	s7,s10
      state = 0;
 964:	4981                	li	s3,0
 966:	6d02                	ld	s10,0(sp)
 968:	bd09                	j	77a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 96a:	008b8493          	addi	s1,s7,8
 96e:	000bc583          	lbu	a1,0(s7)
 972:	855a                	mv	a0,s6
 974:	d0dff0ef          	jal	680 <putc>
 978:	8ba6                	mv	s7,s1
      state = 0;
 97a:	4981                	li	s3,0
 97c:	bbfd                	j	77a <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
 97e:	008b8993          	addi	s3,s7,8
 982:	000bb483          	ld	s1,0(s7)
 986:	cc91                	beqz	s1,9a2 <vprintf+0x272>
        for (; *s; s++)
 988:	0004c583          	lbu	a1,0(s1)
 98c:	c195                	beqz	a1,9b0 <vprintf+0x280>
          putc(fd, *s);
 98e:	855a                	mv	a0,s6
 990:	cf1ff0ef          	jal	680 <putc>
        for (; *s; s++)
 994:	0485                	addi	s1,s1,1
 996:	0004c583          	lbu	a1,0(s1)
 99a:	f9f5                	bnez	a1,98e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 99c:	8bce                	mv	s7,s3
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	bbe9                	j	77a <vprintf+0x4a>
          s = "(null)";
 9a2:	00000497          	auipc	s1,0x0
 9a6:	26e48493          	addi	s1,s1,622 # c10 <malloc+0x15e>
        for (; *s; s++)
 9aa:	02800593          	li	a1,40
 9ae:	b7c5                	j	98e <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
 9b0:	8bce                	mv	s7,s3
      state = 0;
 9b2:	4981                	li	s3,0
 9b4:	b3d9                	j	77a <vprintf+0x4a>
 9b6:	6906                	ld	s2,64(sp)
 9b8:	79e2                	ld	s3,56(sp)
 9ba:	7a42                	ld	s4,48(sp)
 9bc:	7aa2                	ld	s5,40(sp)
 9be:	7b02                	ld	s6,32(sp)
 9c0:	6be2                	ld	s7,24(sp)
 9c2:	6c42                	ld	s8,16(sp)
 9c4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9c6:	60e6                	ld	ra,88(sp)
 9c8:	6446                	ld	s0,80(sp)
 9ca:	64a6                	ld	s1,72(sp)
 9cc:	6125                	addi	sp,sp,96
 9ce:	8082                	ret

00000000000009d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9d0:	715d                	addi	sp,sp,-80
 9d2:	ec06                	sd	ra,24(sp)
 9d4:	e822                	sd	s0,16(sp)
 9d6:	1000                	addi	s0,sp,32
 9d8:	e010                	sd	a2,0(s0)
 9da:	e414                	sd	a3,8(s0)
 9dc:	e818                	sd	a4,16(s0)
 9de:	ec1c                	sd	a5,24(s0)
 9e0:	03043023          	sd	a6,32(s0)
 9e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9e8:	8622                	mv	a2,s0
 9ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ee:	d43ff0ef          	jal	730 <vprintf>
}
 9f2:	60e2                	ld	ra,24(sp)
 9f4:	6442                	ld	s0,16(sp)
 9f6:	6161                	addi	sp,sp,80
 9f8:	8082                	ret

00000000000009fa <printf>:

void
printf(const char *fmt, ...)
{
 9fa:	711d                	addi	sp,sp,-96
 9fc:	ec06                	sd	ra,24(sp)
 9fe:	e822                	sd	s0,16(sp)
 a00:	1000                	addi	s0,sp,32
 a02:	e40c                	sd	a1,8(s0)
 a04:	e810                	sd	a2,16(s0)
 a06:	ec14                	sd	a3,24(s0)
 a08:	f018                	sd	a4,32(s0)
 a0a:	f41c                	sd	a5,40(s0)
 a0c:	03043823          	sd	a6,48(s0)
 a10:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a14:	00840613          	addi	a2,s0,8
 a18:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a1c:	85aa                	mv	a1,a0
 a1e:	4505                	li	a0,1
 a20:	d11ff0ef          	jal	730 <vprintf>
}
 a24:	60e2                	ld	ra,24(sp)
 a26:	6442                	ld	s0,16(sp)
 a28:	6125                	addi	sp,sp,96
 a2a:	8082                	ret

0000000000000a2c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a2c:	1141                	addi	sp,sp,-16
 a2e:	e406                	sd	ra,8(sp)
 a30:	e022                	sd	s0,0(sp)
 a32:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a34:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a38:	00000797          	auipc	a5,0x0
 a3c:	5c87b783          	ld	a5,1480(a5) # 1000 <freep>
 a40:	a02d                	j	a6a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
 a42:	4618                	lw	a4,8(a2)
 a44:	9f2d                	addw	a4,a4,a1
 a46:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a4a:	6398                	ld	a4,0(a5)
 a4c:	6310                	ld	a2,0(a4)
 a4e:	a83d                	j	a8c <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
 a50:	ff852703          	lw	a4,-8(a0)
 a54:	9f31                	addw	a4,a4,a2
 a56:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a58:	ff053683          	ld	a3,-16(a0)
 a5c:	a091                	j	aa0 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a5e:	6398                	ld	a4,0(a5)
 a60:	00e7e463          	bltu	a5,a4,a68 <free+0x3c>
 a64:	00e6ea63          	bltu	a3,a4,a78 <free+0x4c>
{
 a68:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6a:	fed7fae3          	bgeu	a5,a3,a5e <free+0x32>
 a6e:	6398                	ld	a4,0(a5)
 a70:	00e6e463          	bltu	a3,a4,a78 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a74:	fee7eae3          	bltu	a5,a4,a68 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
 a78:	ff852583          	lw	a1,-8(a0)
 a7c:	6390                	ld	a2,0(a5)
 a7e:	02059813          	slli	a6,a1,0x20
 a82:	01c85713          	srli	a4,a6,0x1c
 a86:	9736                	add	a4,a4,a3
 a88:	fae60de3          	beq	a2,a4,a42 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a8c:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
 a90:	4790                	lw	a2,8(a5)
 a92:	02061593          	slli	a1,a2,0x20
 a96:	01c5d713          	srli	a4,a1,0x1c
 a9a:	973e                	add	a4,a4,a5
 a9c:	fae68ae3          	beq	a3,a4,a50 <free+0x24>
    p->s.ptr = bp->s.ptr;
 aa0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aa2:	00000717          	auipc	a4,0x0
 aa6:	54f73f23          	sd	a5,1374(a4) # 1000 <freep>
}
 aaa:	60a2                	ld	ra,8(sp)
 aac:	6402                	ld	s0,0(sp)
 aae:	0141                	addi	sp,sp,16
 ab0:	8082                	ret

0000000000000ab2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 ab2:	7139                	addi	sp,sp,-64
 ab4:	fc06                	sd	ra,56(sp)
 ab6:	f822                	sd	s0,48(sp)
 ab8:	f04a                	sd	s2,32(sp)
 aba:	ec4e                	sd	s3,24(sp)
 abc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 abe:	02051993          	slli	s3,a0,0x20
 ac2:	0209d993          	srli	s3,s3,0x20
 ac6:	09bd                	addi	s3,s3,15
 ac8:	0049d993          	srli	s3,s3,0x4
 acc:	2985                	addiw	s3,s3,1
 ace:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 ad0:	00000517          	auipc	a0,0x0
 ad4:	53053503          	ld	a0,1328(a0) # 1000 <freep>
 ad8:	c905                	beqz	a0,b08 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ada:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 adc:	4798                	lw	a4,8(a5)
 ade:	09377663          	bgeu	a4,s3,b6a <malloc+0xb8>
 ae2:	f426                	sd	s1,40(sp)
 ae4:	e852                	sd	s4,16(sp)
 ae6:	e456                	sd	s5,8(sp)
 ae8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 aea:	8a4e                	mv	s4,s3
 aec:	6705                	lui	a4,0x1
 aee:	00e9f363          	bgeu	s3,a4,af4 <malloc+0x42>
 af2:	6a05                	lui	s4,0x1
 af4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 af8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 afc:	00000497          	auipc	s1,0x0
 b00:	50448493          	addi	s1,s1,1284 # 1000 <freep>
  if (p == SBRK_ERROR)
 b04:	5afd                	li	s5,-1
 b06:	a83d                	j	b44 <malloc+0x92>
 b08:	f426                	sd	s1,40(sp)
 b0a:	e852                	sd	s4,16(sp)
 b0c:	e456                	sd	s5,8(sp)
 b0e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b10:	00000797          	auipc	a5,0x0
 b14:	51078793          	addi	a5,a5,1296 # 1020 <base>
 b18:	00000717          	auipc	a4,0x0
 b1c:	4ef73423          	sd	a5,1256(a4) # 1000 <freep>
 b20:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b22:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 b26:	b7d1                	j	aea <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b28:	6398                	ld	a4,0(a5)
 b2a:	e118                	sd	a4,0(a0)
 b2c:	a899                	j	b82 <malloc+0xd0>
  hp->s.size = nu;
 b2e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 b32:	0541                	addi	a0,a0,16
 b34:	ef9ff0ef          	jal	a2c <free>
  return freep;
 b38:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 b3a:	c125                	beqz	a0,b9a <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b3c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b3e:	4798                	lw	a4,8(a5)
 b40:	03277163          	bgeu	a4,s2,b62 <malloc+0xb0>
    if (p == freep)
 b44:	6098                	ld	a4,0(s1)
 b46:	853e                	mv	a0,a5
 b48:	fef71ae3          	bne	a4,a5,b3c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b4c:	8552                	mv	a0,s4
 b4e:	9d3ff0ef          	jal	520 <sbrk>
  if (p == SBRK_ERROR)
 b52:	fd551ee3          	bne	a0,s5,b2e <malloc+0x7c>
        return 0;
 b56:	4501                	li	a0,0
 b58:	74a2                	ld	s1,40(sp)
 b5a:	6a42                	ld	s4,16(sp)
 b5c:	6aa2                	ld	s5,8(sp)
 b5e:	6b02                	ld	s6,0(sp)
 b60:	a03d                	j	b8e <malloc+0xdc>
 b62:	74a2                	ld	s1,40(sp)
 b64:	6a42                	ld	s4,16(sp)
 b66:	6aa2                	ld	s5,8(sp)
 b68:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b6a:	fae90fe3          	beq	s2,a4,b28 <malloc+0x76>
        p->s.size -= nunits;
 b6e:	4137073b          	subw	a4,a4,s3
 b72:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b74:	02071693          	slli	a3,a4,0x20
 b78:	01c6d713          	srli	a4,a3,0x1c
 b7c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b7e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b82:	00000717          	auipc	a4,0x0
 b86:	46a73f23          	sd	a0,1150(a4) # 1000 <freep>
      return (void *)(p + 1);
 b8a:	01078513          	addi	a0,a5,16
  }
}
 b8e:	70e2                	ld	ra,56(sp)
 b90:	7442                	ld	s0,48(sp)
 b92:	7902                	ld	s2,32(sp)
 b94:	69e2                	ld	s3,24(sp)
 b96:	6121                	addi	sp,sp,64
 b98:	8082                	ret
 b9a:	74a2                	ld	s1,40(sp)
 b9c:	6a42                	ld	s4,16(sp)
 b9e:	6aa2                	ld	s5,8(sp)
 ba0:	6b02                	ld	s6,0(sp)
 ba2:	b7f5                	j	b8e <malloc+0xdc>
