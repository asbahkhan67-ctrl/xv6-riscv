
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	25e58593          	addi	a1,a1,606 # 1270 <malloc+0xf6>
      1a:	8532                	mv	a0,a2
      1c:	485000ef          	jal	ca0 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	221000ef          	jal	a46 <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	267000ef          	jal	a94 <gets>
  if (buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	22c58593          	addi	a1,a1,556 # 1280 <malloc+0x106>
      5c:	4509                	li	a0,2
      5e:	03a010ef          	jal	1098 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	41d000ef          	jal	c80 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	409000ef          	jal	c78 <fork>
  if (pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	20650513          	addi	a0,a0,518 # 1288 <malloc+0x10e>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if (cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch (cmd->type) {
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2de70713          	addi	a4,a4,734 # 1388 <malloc+0x20e>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	3c3000ef          	jal	c80 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	1ce50513          	addi	a0,a0,462 # 1290 <malloc+0x116>
      ca:	f81ff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3e3000ef          	jal	cb8 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	1bc58593          	addi	a1,a1,444 # 1298 <malloc+0x11e>
      e4:	4509                	li	a0,2
      e6:	7b3000ef          	jal	1098 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	395000ef          	jal	c80 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	38f000ef          	jal	c80 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	3b1000ef          	jal	ca8 <close>
    if (open(rcmd->file, rcmd->mode) < 0) {
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3c1000ef          	jal	cc0 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	19858593          	addi	a1,a1,408 # 12a8 <malloc+0x12e>
     118:	4509                	li	a0,2
     11a:	77f000ef          	jal	1098 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	361000ef          	jal	c80 <exit>
    if (fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	357000ef          	jal	c88 <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	351000ef          	jal	c90 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if (fork1() == 0) {
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	359000ef          	jal	ca8 <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	3a1000ef          	jal	cf8 <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	349000ef          	jal	ca8 <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	341000ef          	jal	ca8 <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	14650513          	addi	a0,a0,326 # 12b8 <malloc+0x13e>
     17a:	ed1ff0ef          	jal	4a <panic>
    if (fork1() == 0) {
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	325000ef          	jal	ca8 <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	36d000ef          	jal	cf8 <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	315000ef          	jal	ca8 <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	30d000ef          	jal	ca8 <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	2ff000ef          	jal	ca8 <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2f7000ef          	jal	ca8 <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	2d1000ef          	jal	c88 <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	2cb000ef          	jal	c88 <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if (fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd *
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	79b000ef          	jal	117a <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	05b000ef          	jal	a46 <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	8b2a                	mv	s6,a0
     216:	8aae                	mv	s5,a1
     218:	8a32                	mv	s4,a2
     21a:	89b6                	mv	s3,a3
     21c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	759000ef          	jal	117a <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	019000ef          	jal	a46 <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     23a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     246:	0324a223          	sw	s2,36(s1)
  return (struct cmd *)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	89aa                	mv	s3,a0
     270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	707000ef          	jal	117a <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7c8000ef          	jal	a46 <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     28a:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	89aa                	mv	s3,a0
     2ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	6c9000ef          	jal	117a <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	78a000ef          	jal	a46 <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     2c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd *)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	68f000ef          	jal	117a <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	750000ef          	jal	a46 <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	72c000ef          	jal	a6c <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if (q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch (*s) {
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76b63          	bltu	a4,a5,3f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6ca000ef          	jal	a6c <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch (*s) {
     3ca:	03e00713          	li	a4,62
     3ce:	02e79163          	bne	a5,a4,3f0 <gettoken+0xe0>
    s++;
     3d2:	00148693          	addi	a3,s1,1
    if (*s == '>') {
     3d6:	0014c703          	lbu	a4,1(s1)
     3da:	03e00793          	li	a5,62
      s++;
     3de:	0489                	addi	s1,s1,2
      ret = '+';
     3e0:	02b00a93          	li	s5,43
    if (*s == '>') {
     3e4:	faf702e3          	beq	a4,a5,388 <gettoken+0x78>
    s++;
     3e8:	84b6                	mv	s1,a3
  ret = *s;
     3ea:	03e00a93          	li	s5,62
     3ee:	bf69                	j	388 <gettoken+0x78>
  switch (*s) {
     3f0:	07c00713          	li	a4,124
     3f4:	f8e789e3          	beq	a5,a4,386 <gettoken+0x76>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3f8:	00002997          	auipc	s3,0x2
     3fc:	c1098993          	addi	s3,s3,-1008 # 2008 <whitespace>
     400:	00002a97          	auipc	s5,0x2
     404:	c00a8a93          	addi	s5,s5,-1024 # 2000 <symbols>
     408:	0324fd63          	bgeu	s1,s2,442 <gettoken+0x132>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	854e                	mv	a0,s3
     412:	65a000ef          	jal	a6c <strchr>
     416:	e11d                	bnez	a0,43c <gettoken+0x12c>
     418:	0004c583          	lbu	a1,0(s1)
     41c:	8556                	mv	a0,s5
     41e:	64e000ef          	jal	a6c <strchr>
     422:	e911                	bnez	a0,436 <gettoken+0x126>
      s++;
     424:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     426:	fe9913e3          	bne	s2,s1,40c <gettoken+0xfc>
  if (eq)
     42a:	84ca                	mv	s1,s2
    ret = 'a';
     42c:	06100a93          	li	s5,97
  if (eq)
     430:	f40b1ee3          	bnez	s6,38c <gettoken+0x7c>
     434:	bfb5                	j	3b0 <gettoken+0xa0>
    ret = 'a';
     436:	06100a93          	li	s5,97
     43a:	b7b9                	j	388 <gettoken+0x78>
     43c:	06100a93          	li	s5,97
     440:	b7a1                	j	388 <gettoken+0x78>
     442:	06100a93          	li	s5,97
  if (eq)
     446:	f40b13e3          	bnez	s6,38c <gettoken+0x7c>
     44a:	b79d                	j	3b0 <gettoken+0xa0>

000000000000044c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     44c:	7139                	addi	sp,sp,-64
     44e:	fc06                	sd	ra,56(sp)
     450:	f822                	sd	s0,48(sp)
     452:	f426                	sd	s1,40(sp)
     454:	f04a                	sd	s2,32(sp)
     456:	ec4e                	sd	s3,24(sp)
     458:	e852                	sd	s4,16(sp)
     45a:	e456                	sd	s5,8(sp)
     45c:	0080                	addi	s0,sp,64
     45e:	8a2a                	mv	s4,a0
     460:	892e                	mv	s2,a1
     462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     464:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     466:	00002997          	auipc	s3,0x2
     46a:	ba298993          	addi	s3,s3,-1118 # 2008 <whitespace>
     46e:	00b4fc63          	bgeu	s1,a1,486 <peek+0x3a>
     472:	0004c583          	lbu	a1,0(s1)
     476:	854e                	mv	a0,s3
     478:	5f4000ef          	jal	a6c <strchr>
     47c:	c509                	beqz	a0,486 <peek+0x3a>
    s++;
     47e:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     480:	fe9919e3          	bne	s2,s1,472 <peek+0x26>
     484:	84ca                	mv	s1,s2
  *ps = s;
     486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     48a:	0004c583          	lbu	a1,0(s1)
     48e:	4501                	li	a0,0
     490:	e991                	bnez	a1,4a4 <peek+0x58>
}
     492:	70e2                	ld	ra,56(sp)
     494:	7442                	ld	s0,48(sp)
     496:	74a2                	ld	s1,40(sp)
     498:	7902                	ld	s2,32(sp)
     49a:	69e2                	ld	s3,24(sp)
     49c:	6a42                	ld	s4,16(sp)
     49e:	6aa2                	ld	s5,8(sp)
     4a0:	6121                	addi	sp,sp,64
     4a2:	8082                	ret
  return *s && strchr(toks, *s);
     4a4:	8556                	mv	a0,s5
     4a6:	5c6000ef          	jal	a6c <strchr>
     4aa:	00a03533          	snez	a0,a0
     4ae:	b7d5                	j	492 <peek+0x46>

00000000000004b0 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4b0:	7159                	addi	sp,sp,-112
     4b2:	f486                	sd	ra,104(sp)
     4b4:	f0a2                	sd	s0,96(sp)
     4b6:	eca6                	sd	s1,88(sp)
     4b8:	e8ca                	sd	s2,80(sp)
     4ba:	e4ce                	sd	s3,72(sp)
     4bc:	e0d2                	sd	s4,64(sp)
     4be:	fc56                	sd	s5,56(sp)
     4c0:	f85a                	sd	s6,48(sp)
     4c2:	f45e                	sd	s7,40(sp)
     4c4:	f062                	sd	s8,32(sp)
     4c6:	ec66                	sd	s9,24(sp)
     4c8:	1880                	addi	s0,sp,112
     4ca:	8a2a                	mv	s4,a0
     4cc:	89ae                	mv	s3,a1
     4ce:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>")) {
     4d0:	00001b17          	auipc	s6,0x1
     4d4:	e10b0b13          	addi	s6,s6,-496 # 12e0 <malloc+0x166>
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     4d8:	f9040c93          	addi	s9,s0,-112
     4dc:	f9840c13          	addi	s8,s0,-104
     4e0:	06100b93          	li	s7,97
  while (peek(ps, es, "<>")) {
     4e4:	a00d                	j	506 <parseredirs+0x56>
      panic("missing file for redirection");
     4e6:	00001517          	auipc	a0,0x1
     4ea:	dda50513          	addi	a0,a0,-550 # 12c0 <malloc+0x146>
     4ee:	b5dff0ef          	jal	4a <panic>
    switch (tok) {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4f2:	4701                	li	a4,0
     4f4:	4681                	li	a3,0
     4f6:	f9043603          	ld	a2,-112(s0)
     4fa:	f9843583          	ld	a1,-104(s0)
     4fe:	8552                	mv	a0,s4
     500:	d01ff0ef          	jal	200 <redircmd>
     504:	8a2a                	mv	s4,a0
    switch (tok) {
     506:	03c00a93          	li	s5,60
  while (peek(ps, es, "<>")) {
     50a:	865a                	mv	a2,s6
     50c:	85ca                	mv	a1,s2
     50e:	854e                	mv	a0,s3
     510:	f3dff0ef          	jal	44c <peek>
     514:	c135                	beqz	a0,578 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     516:	4681                	li	a3,0
     518:	4601                	li	a2,0
     51a:	85ca                	mv	a1,s2
     51c:	854e                	mv	a0,s3
     51e:	df3ff0ef          	jal	310 <gettoken>
     522:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     524:	86e6                	mv	a3,s9
     526:	8662                	mv	a2,s8
     528:	85ca                	mv	a1,s2
     52a:	854e                	mv	a0,s3
     52c:	de5ff0ef          	jal	310 <gettoken>
     530:	fb751be3          	bne	a0,s7,4e6 <parseredirs+0x36>
    switch (tok) {
     534:	fb548fe3          	beq	s1,s5,4f2 <parseredirs+0x42>
     538:	03e00793          	li	a5,62
     53c:	02f48263          	beq	s1,a5,560 <parseredirs+0xb0>
     540:	02b00793          	li	a5,43
     544:	fcf493e3          	bne	s1,a5,50a <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     548:	4705                	li	a4,1
     54a:	20100693          	li	a3,513
     54e:	f9043603          	ld	a2,-112(s0)
     552:	f9843583          	ld	a1,-104(s0)
     556:	8552                	mv	a0,s4
     558:	ca9ff0ef          	jal	200 <redircmd>
     55c:	8a2a                	mv	s4,a0
      break;
     55e:	b765                	j	506 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     560:	4705                	li	a4,1
     562:	60100693          	li	a3,1537
     566:	f9043603          	ld	a2,-112(s0)
     56a:	f9843583          	ld	a1,-104(s0)
     56e:	8552                	mv	a0,s4
     570:	c91ff0ef          	jal	200 <redircmd>
     574:	8a2a                	mv	s4,a0
      break;
     576:	bf41                	j	506 <parseredirs+0x56>
    }
  }
  return cmd;
}
     578:	8552                	mv	a0,s4
     57a:	70a6                	ld	ra,104(sp)
     57c:	7406                	ld	s0,96(sp)
     57e:	64e6                	ld	s1,88(sp)
     580:	6946                	ld	s2,80(sp)
     582:	69a6                	ld	s3,72(sp)
     584:	6a06                	ld	s4,64(sp)
     586:	7ae2                	ld	s5,56(sp)
     588:	7b42                	ld	s6,48(sp)
     58a:	7ba2                	ld	s7,40(sp)
     58c:	7c02                	ld	s8,32(sp)
     58e:	6ce2                	ld	s9,24(sp)
     590:	6165                	addi	sp,sp,112
     592:	8082                	ret

0000000000000594 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     594:	7119                	addi	sp,sp,-128
     596:	fc86                	sd	ra,120(sp)
     598:	f8a2                	sd	s0,112(sp)
     59a:	f4a6                	sd	s1,104(sp)
     59c:	e8d2                	sd	s4,80(sp)
     59e:	e4d6                	sd	s5,72(sp)
     5a0:	0100                	addi	s0,sp,128
     5a2:	8a2a                	mv	s4,a0
     5a4:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     5a6:	00001617          	auipc	a2,0x1
     5aa:	d4260613          	addi	a2,a2,-702 # 12e8 <malloc+0x16e>
     5ae:	e9fff0ef          	jal	44c <peek>
     5b2:	e121                	bnez	a0,5f2 <parseexec+0x5e>
     5b4:	f0ca                	sd	s2,96(sp)
     5b6:	ecce                	sd	s3,88(sp)
     5b8:	e0da                	sd	s6,64(sp)
     5ba:	fc5e                	sd	s7,56(sp)
     5bc:	f862                	sd	s8,48(sp)
     5be:	f466                	sd	s9,40(sp)
     5c0:	f06a                	sd	s10,32(sp)
     5c2:	ec6e                	sd	s11,24(sp)
     5c4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c6:	c0dff0ef          	jal	1d2 <execcmd>
     5ca:	8daa                	mv	s11,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5cc:	8656                	mv	a2,s5
     5ce:	85d2                	mv	a1,s4
     5d0:	ee1ff0ef          	jal	4b0 <parseredirs>
     5d4:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;")) {
     5d6:	008d8913          	addi	s2,s11,8
     5da:	00001b17          	auipc	s6,0x1
     5de:	d2eb0b13          	addi	s6,s6,-722 # 1308 <malloc+0x18e>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     5e2:	f8040c13          	addi	s8,s0,-128
     5e6:	f8840b93          	addi	s7,s0,-120
      break;
    if (tok != 'a')
     5ea:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     5ee:	4ca9                	li	s9,10
  while (!peek(ps, es, "|)&;")) {
     5f0:	a815                	j	624 <parseexec+0x90>
    return parseblock(ps, es);
     5f2:	85d6                	mv	a1,s5
     5f4:	8552                	mv	a0,s4
     5f6:	170000ef          	jal	766 <parseblock>
     5fa:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5fc:	8526                	mv	a0,s1
     5fe:	70e6                	ld	ra,120(sp)
     600:	7446                	ld	s0,112(sp)
     602:	74a6                	ld	s1,104(sp)
     604:	6a46                	ld	s4,80(sp)
     606:	6aa6                	ld	s5,72(sp)
     608:	6109                	addi	sp,sp,128
     60a:	8082                	ret
      panic("syntax");
     60c:	00001517          	auipc	a0,0x1
     610:	ce450513          	addi	a0,a0,-796 # 12f0 <malloc+0x176>
     614:	a37ff0ef          	jal	4a <panic>
    ret = parseredirs(ret, ps, es);
     618:	8656                	mv	a2,s5
     61a:	85d2                	mv	a1,s4
     61c:	8526                	mv	a0,s1
     61e:	e93ff0ef          	jal	4b0 <parseredirs>
     622:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;")) {
     624:	865a                	mv	a2,s6
     626:	85d6                	mv	a1,s5
     628:	8552                	mv	a0,s4
     62a:	e23ff0ef          	jal	44c <peek>
     62e:	ed05                	bnez	a0,666 <parseexec+0xd2>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     630:	86e2                	mv	a3,s8
     632:	865e                	mv	a2,s7
     634:	85d6                	mv	a1,s5
     636:	8552                	mv	a0,s4
     638:	cd9ff0ef          	jal	310 <gettoken>
     63c:	c50d                	beqz	a0,666 <parseexec+0xd2>
    if (tok != 'a')
     63e:	fda517e3          	bne	a0,s10,60c <parseexec+0x78>
    cmd->argv[argc] = q;
     642:	f8843783          	ld	a5,-120(s0)
     646:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     64a:	f8043783          	ld	a5,-128(s0)
     64e:	04f93823          	sd	a5,80(s2)
    argc++;
     652:	2985                	addiw	s3,s3,1
    if (argc >= MAXARGS)
     654:	0921                	addi	s2,s2,8
     656:	fd9991e3          	bne	s3,s9,618 <parseexec+0x84>
      panic("too many args");
     65a:	00001517          	auipc	a0,0x1
     65e:	c9e50513          	addi	a0,a0,-866 # 12f8 <malloc+0x17e>
     662:	9e9ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     666:	098e                	slli	s3,s3,0x3
     668:	9dce                	add	s11,s11,s3
     66a:	000db423          	sd	zero,8(s11)
  cmd->eargv[argc] = 0;
     66e:	040dbc23          	sd	zero,88(s11)
     672:	7906                	ld	s2,96(sp)
     674:	69e6                	ld	s3,88(sp)
     676:	6b06                	ld	s6,64(sp)
     678:	7be2                	ld	s7,56(sp)
     67a:	7c42                	ld	s8,48(sp)
     67c:	7ca2                	ld	s9,40(sp)
     67e:	7d02                	ld	s10,32(sp)
     680:	6de2                	ld	s11,24(sp)
  return ret;
     682:	bfad                	j	5fc <parseexec+0x68>

0000000000000684 <parsepipe>:
{
     684:	7179                	addi	sp,sp,-48
     686:	f406                	sd	ra,40(sp)
     688:	f022                	sd	s0,32(sp)
     68a:	ec26                	sd	s1,24(sp)
     68c:	e84a                	sd	s2,16(sp)
     68e:	e44e                	sd	s3,8(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     696:	effff0ef          	jal	594 <parseexec>
     69a:	84aa                	mv	s1,a0
  if (peek(ps, es, "|")) {
     69c:	00001617          	auipc	a2,0x1
     6a0:	c7460613          	addi	a2,a2,-908 # 1310 <malloc+0x196>
     6a4:	85ce                	mv	a1,s3
     6a6:	854a                	mv	a0,s2
     6a8:	da5ff0ef          	jal	44c <peek>
     6ac:	e909                	bnez	a0,6be <parsepipe+0x3a>
}
     6ae:	8526                	mv	a0,s1
     6b0:	70a2                	ld	ra,40(sp)
     6b2:	7402                	ld	s0,32(sp)
     6b4:	64e2                	ld	s1,24(sp)
     6b6:	6942                	ld	s2,16(sp)
     6b8:	69a2                	ld	s3,8(sp)
     6ba:	6145                	addi	sp,sp,48
     6bc:	8082                	ret
    gettoken(ps, es, 0, 0);
     6be:	4681                	li	a3,0
     6c0:	4601                	li	a2,0
     6c2:	85ce                	mv	a1,s3
     6c4:	854a                	mv	a0,s2
     6c6:	c4bff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ca:	85ce                	mv	a1,s3
     6cc:	854a                	mv	a0,s2
     6ce:	fb7ff0ef          	jal	684 <parsepipe>
     6d2:	85aa                	mv	a1,a0
     6d4:	8526                	mv	a0,s1
     6d6:	b8bff0ef          	jal	260 <pipecmd>
     6da:	84aa                	mv	s1,a0
  return cmd;
     6dc:	bfc9                	j	6ae <parsepipe+0x2a>

00000000000006de <parseline>:
{
     6de:	7179                	addi	sp,sp,-48
     6e0:	f406                	sd	ra,40(sp)
     6e2:	f022                	sd	s0,32(sp)
     6e4:	ec26                	sd	s1,24(sp)
     6e6:	e84a                	sd	s2,16(sp)
     6e8:	e44e                	sd	s3,8(sp)
     6ea:	e052                	sd	s4,0(sp)
     6ec:	1800                	addi	s0,sp,48
     6ee:	892a                	mv	s2,a0
     6f0:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f2:	f93ff0ef          	jal	684 <parsepipe>
     6f6:	84aa                	mv	s1,a0
  while (peek(ps, es, "&")) {
     6f8:	00001a17          	auipc	s4,0x1
     6fc:	c20a0a13          	addi	s4,s4,-992 # 1318 <malloc+0x19e>
     700:	a819                	j	716 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     702:	4681                	li	a3,0
     704:	4601                	li	a2,0
     706:	85ce                	mv	a1,s3
     708:	854a                	mv	a0,s2
     70a:	c07ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     70e:	8526                	mv	a0,s1
     710:	bcdff0ef          	jal	2dc <backcmd>
     714:	84aa                	mv	s1,a0
  while (peek(ps, es, "&")) {
     716:	8652                	mv	a2,s4
     718:	85ce                	mv	a1,s3
     71a:	854a                	mv	a0,s2
     71c:	d31ff0ef          	jal	44c <peek>
     720:	f16d                	bnez	a0,702 <parseline+0x24>
  if (peek(ps, es, ";")) {
     722:	00001617          	auipc	a2,0x1
     726:	bfe60613          	addi	a2,a2,-1026 # 1320 <malloc+0x1a6>
     72a:	85ce                	mv	a1,s3
     72c:	854a                	mv	a0,s2
     72e:	d1fff0ef          	jal	44c <peek>
     732:	e911                	bnez	a0,746 <parseline+0x68>
}
     734:	8526                	mv	a0,s1
     736:	70a2                	ld	ra,40(sp)
     738:	7402                	ld	s0,32(sp)
     73a:	64e2                	ld	s1,24(sp)
     73c:	6942                	ld	s2,16(sp)
     73e:	69a2                	ld	s3,8(sp)
     740:	6a02                	ld	s4,0(sp)
     742:	6145                	addi	sp,sp,48
     744:	8082                	ret
    gettoken(ps, es, 0, 0);
     746:	4681                	li	a3,0
     748:	4601                	li	a2,0
     74a:	85ce                	mv	a1,s3
     74c:	854a                	mv	a0,s2
     74e:	bc3ff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     752:	85ce                	mv	a1,s3
     754:	854a                	mv	a0,s2
     756:	f89ff0ef          	jal	6de <parseline>
     75a:	85aa                	mv	a1,a0
     75c:	8526                	mv	a0,s1
     75e:	b41ff0ef          	jal	29e <listcmd>
     762:	84aa                	mv	s1,a0
  return cmd;
     764:	bfc1                	j	734 <parseline+0x56>

0000000000000766 <parseblock>:
{
     766:	7179                	addi	sp,sp,-48
     768:	f406                	sd	ra,40(sp)
     76a:	f022                	sd	s0,32(sp)
     76c:	ec26                	sd	s1,24(sp)
     76e:	e84a                	sd	s2,16(sp)
     770:	e44e                	sd	s3,8(sp)
     772:	1800                	addi	s0,sp,48
     774:	84aa                	mv	s1,a0
     776:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     778:	00001617          	auipc	a2,0x1
     77c:	b7060613          	addi	a2,a2,-1168 # 12e8 <malloc+0x16e>
     780:	ccdff0ef          	jal	44c <peek>
     784:	c539                	beqz	a0,7d2 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     786:	4681                	li	a3,0
     788:	4601                	li	a2,0
     78a:	85ca                	mv	a1,s2
     78c:	8526                	mv	a0,s1
     78e:	b83ff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     792:	85ca                	mv	a1,s2
     794:	8526                	mv	a0,s1
     796:	f49ff0ef          	jal	6de <parseline>
     79a:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     79c:	00001617          	auipc	a2,0x1
     7a0:	b9c60613          	addi	a2,a2,-1124 # 1338 <malloc+0x1be>
     7a4:	85ca                	mv	a1,s2
     7a6:	8526                	mv	a0,s1
     7a8:	ca5ff0ef          	jal	44c <peek>
     7ac:	c90d                	beqz	a0,7de <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7ae:	4681                	li	a3,0
     7b0:	4601                	li	a2,0
     7b2:	85ca                	mv	a1,s2
     7b4:	8526                	mv	a0,s1
     7b6:	b5bff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7ba:	864a                	mv	a2,s2
     7bc:	85a6                	mv	a1,s1
     7be:	854e                	mv	a0,s3
     7c0:	cf1ff0ef          	jal	4b0 <parseredirs>
}
     7c4:	70a2                	ld	ra,40(sp)
     7c6:	7402                	ld	s0,32(sp)
     7c8:	64e2                	ld	s1,24(sp)
     7ca:	6942                	ld	s2,16(sp)
     7cc:	69a2                	ld	s3,8(sp)
     7ce:	6145                	addi	sp,sp,48
     7d0:	8082                	ret
    panic("parseblock");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	b5650513          	addi	a0,a0,-1194 # 1328 <malloc+0x1ae>
     7da:	871ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7de:	00001517          	auipc	a0,0x1
     7e2:	b6250513          	addi	a0,a0,-1182 # 1340 <malloc+0x1c6>
     7e6:	865ff0ef          	jal	4a <panic>

00000000000007ea <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     7ea:	1101                	addi	sp,sp,-32
     7ec:	ec06                	sd	ra,24(sp)
     7ee:	e822                	sd	s0,16(sp)
     7f0:	e426                	sd	s1,8(sp)
     7f2:	1000                	addi	s0,sp,32
     7f4:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     7f6:	c131                	beqz	a0,83a <nulterminate+0x50>
    return 0;

  switch (cmd->type) {
     7f8:	4118                	lw	a4,0(a0)
     7fa:	4795                	li	a5,5
     7fc:	02e7ef63          	bltu	a5,a4,83a <nulterminate+0x50>
     800:	00056783          	lwu	a5,0(a0)
     804:	078a                	slli	a5,a5,0x2
     806:	00001717          	auipc	a4,0x1
     80a:	b9a70713          	addi	a4,a4,-1126 # 13a0 <malloc+0x226>
     80e:	97ba                	add	a5,a5,a4
     810:	439c                	lw	a5,0(a5)
     812:	97ba                	add	a5,a5,a4
     814:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     816:	651c                	ld	a5,8(a0)
     818:	c38d                	beqz	a5,83a <nulterminate+0x50>
     81a:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     81e:	67b8                	ld	a4,72(a5)
     820:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     824:	07a1                	addi	a5,a5,8
     826:	ff87b703          	ld	a4,-8(a5)
     82a:	fb75                	bnez	a4,81e <nulterminate+0x34>
     82c:	a039                	j	83a <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     82e:	6508                	ld	a0,8(a0)
     830:	fbbff0ef          	jal	7ea <nulterminate>
    *rcmd->efile = 0;
     834:	6c9c                	ld	a5,24(s1)
     836:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83a:	8526                	mv	a0,s1
     83c:	60e2                	ld	ra,24(sp)
     83e:	6442                	ld	s0,16(sp)
     840:	64a2                	ld	s1,8(sp)
     842:	6105                	addi	sp,sp,32
     844:	8082                	ret
    nulterminate(pcmd->left);
     846:	6508                	ld	a0,8(a0)
     848:	fa3ff0ef          	jal	7ea <nulterminate>
    nulterminate(pcmd->right);
     84c:	6888                	ld	a0,16(s1)
     84e:	f9dff0ef          	jal	7ea <nulterminate>
    break;
     852:	b7e5                	j	83a <nulterminate+0x50>
    nulterminate(lcmd->left);
     854:	6508                	ld	a0,8(a0)
     856:	f95ff0ef          	jal	7ea <nulterminate>
    nulterminate(lcmd->right);
     85a:	6888                	ld	a0,16(s1)
     85c:	f8fff0ef          	jal	7ea <nulterminate>
    break;
     860:	bfe9                	j	83a <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     862:	6508                	ld	a0,8(a0)
     864:	f87ff0ef          	jal	7ea <nulterminate>
    break;
     868:	bfc9                	j	83a <nulterminate+0x50>

000000000000086a <parsecmd>:
{
     86a:	7139                	addi	sp,sp,-64
     86c:	fc06                	sd	ra,56(sp)
     86e:	f822                	sd	s0,48(sp)
     870:	f426                	sd	s1,40(sp)
     872:	f04a                	sd	s2,32(sp)
     874:	ec4e                	sd	s3,24(sp)
     876:	0080                	addi	s0,sp,64
     878:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     87c:	84aa                	mv	s1,a0
     87e:	19a000ef          	jal	a18 <strlen>
     882:	1502                	slli	a0,a0,0x20
     884:	9101                	srli	a0,a0,0x20
     886:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     888:	fc840993          	addi	s3,s0,-56
     88c:	85a6                	mv	a1,s1
     88e:	854e                	mv	a0,s3
     890:	e4fff0ef          	jal	6de <parseline>
     894:	892a                	mv	s2,a0
  peek(&s, es, "");
     896:	00001617          	auipc	a2,0x1
     89a:	9e260613          	addi	a2,a2,-1566 # 1278 <malloc+0xfe>
     89e:	85a6                	mv	a1,s1
     8a0:	854e                	mv	a0,s3
     8a2:	babff0ef          	jal	44c <peek>
  if (s != es) {
     8a6:	fc843603          	ld	a2,-56(s0)
     8aa:	00961d63          	bne	a2,s1,8c4 <parsecmd+0x5a>
  nulterminate(cmd);
     8ae:	854a                	mv	a0,s2
     8b0:	f3bff0ef          	jal	7ea <nulterminate>
}
     8b4:	854a                	mv	a0,s2
     8b6:	70e2                	ld	ra,56(sp)
     8b8:	7442                	ld	s0,48(sp)
     8ba:	74a2                	ld	s1,40(sp)
     8bc:	7902                	ld	s2,32(sp)
     8be:	69e2                	ld	s3,24(sp)
     8c0:	6121                	addi	sp,sp,64
     8c2:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c4:	00001597          	auipc	a1,0x1
     8c8:	a9458593          	addi	a1,a1,-1388 # 1358 <malloc+0x1de>
     8cc:	4509                	li	a0,2
     8ce:	7ca000ef          	jal	1098 <fprintf>
    panic("syntax");
     8d2:	00001517          	auipc	a0,0x1
     8d6:	a1e50513          	addi	a0,a0,-1506 # 12f0 <malloc+0x176>
     8da:	f70ff0ef          	jal	4a <panic>

00000000000008de <main>:
{
     8de:	7139                	addi	sp,sp,-64
     8e0:	fc06                	sd	ra,56(sp)
     8e2:	f822                	sd	s0,48(sp)
     8e4:	f426                	sd	s1,40(sp)
     8e6:	f04a                	sd	s2,32(sp)
     8e8:	ec4e                	sd	s3,24(sp)
     8ea:	e852                	sd	s4,16(sp)
     8ec:	e456                	sd	s5,8(sp)
     8ee:	e05a                	sd	s6,0(sp)
     8f0:	0080                	addi	s0,sp,64
  while ((fd = open("console", O_RDWR)) >= 0) {
     8f2:	4489                	li	s1,2
     8f4:	00001917          	auipc	s2,0x1
     8f8:	a7490913          	addi	s2,s2,-1420 # 1368 <malloc+0x1ee>
     8fc:	85a6                	mv	a1,s1
     8fe:	854a                	mv	a0,s2
     900:	3c0000ef          	jal	cc0 <open>
     904:	00054663          	bltz	a0,910 <main+0x32>
    if (fd >= 3) {
     908:	fea4dae3          	bge	s1,a0,8fc <main+0x1e>
      close(fd);
     90c:	39c000ef          	jal	ca8 <close>
  while (getcmd(buf, sizeof(buf)) >= 0) {
     910:	00001a97          	auipc	s5,0x1
     914:	710a8a93          	addi	s5,s5,1808 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     918:	02000913          	li	s2,32
     91c:	49a5                	li	s3,9
    if (*cmd == '\n') // is a blank command
     91e:	4b29                	li	s6,10
     920:	a815                	j	954 <main+0x76>
      cmd++;
     922:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     924:	0004c783          	lbu	a5,0(s1)
     928:	ff278de3          	beq	a5,s2,922 <main+0x44>
     92c:	ff378be3          	beq	a5,s3,922 <main+0x44>
    if (*cmd == '\n') // is a blank command
     930:	03678463          	beq	a5,s6,958 <main+0x7a>
    if (cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' ') {
     934:	06300713          	li	a4,99
     938:	00e79863          	bne	a5,a4,948 <main+0x6a>
     93c:	0014c703          	lbu	a4,1(s1)
     940:	06400793          	li	a5,100
     944:	02f70563          	beq	a4,a5,96e <main+0x90>
      if (fork1() == 0)
     948:	f20ff0ef          	jal	68 <fork1>
     94c:	cd31                	beqz	a0,9a8 <main+0xca>
      wait(0);
     94e:	4501                	li	a0,0
     950:	338000ef          	jal	c88 <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
     954:	06400a13          	li	s4,100
     958:	85d2                	mv	a1,s4
     95a:	8556                	mv	a0,s5
     95c:	ea4ff0ef          	jal	0 <getcmd>
     960:	04054963          	bltz	a0,9b2 <main+0xd4>
    char *cmd = buf;
     964:	00001497          	auipc	s1,0x1
     968:	6bc48493          	addi	s1,s1,1724 # 2020 <buf.0>
     96c:	bf65                	j	924 <main+0x46>
    if (cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' ') {
     96e:	0024c783          	lbu	a5,2(s1)
     972:	fd279be3          	bne	a5,s2,948 <main+0x6a>
      cmd[strlen(cmd) - 1] = 0; // chop \n
     976:	8526                	mv	a0,s1
     978:	0a0000ef          	jal	a18 <strlen>
     97c:	fff5079b          	addiw	a5,a0,-1
     980:	1782                	slli	a5,a5,0x20
     982:	9381                	srli	a5,a5,0x20
     984:	97a6                	add	a5,a5,s1
     986:	00078023          	sb	zero,0(a5)
      if (chdir(cmd + 3) < 0)
     98a:	048d                	addi	s1,s1,3
     98c:	8526                	mv	a0,s1
     98e:	362000ef          	jal	cf0 <chdir>
     992:	fc0551e3          	bgez	a0,954 <main+0x76>
        fprintf(2, "cannot cd %s\n", cmd + 3);
     996:	8626                	mv	a2,s1
     998:	00001597          	auipc	a1,0x1
     99c:	9d858593          	addi	a1,a1,-1576 # 1370 <malloc+0x1f6>
     9a0:	4509                	li	a0,2
     9a2:	6f6000ef          	jal	1098 <fprintf>
     9a6:	b77d                	j	954 <main+0x76>
        runcmd(parsecmd(cmd));
     9a8:	8526                	mv	a0,s1
     9aa:	ec1ff0ef          	jal	86a <parsecmd>
     9ae:	ee0ff0ef          	jal	8e <runcmd>
  exit(0);
     9b2:	4501                	li	a0,0
     9b4:	2cc000ef          	jal	c80 <exit>

00000000000009b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9b8:	1141                	addi	sp,sp,-16
     9ba:	e406                	sd	ra,8(sp)
     9bc:	e022                	sd	s0,0(sp)
     9be:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9c0:	f1fff0ef          	jal	8de <main>
  exit(r);
     9c4:	2bc000ef          	jal	c80 <exit>

00000000000009c8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     9c8:	1141                	addi	sp,sp,-16
     9ca:	e406                	sd	ra,8(sp)
     9cc:	e022                	sd	s0,0(sp)
     9ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
     9d0:	87aa                	mv	a5,a0
     9d2:	0585                	addi	a1,a1,1
     9d4:	0785                	addi	a5,a5,1
     9d6:	fff5c703          	lbu	a4,-1(a1)
     9da:	fee78fa3          	sb	a4,-1(a5)
     9de:	fb75                	bnez	a4,9d2 <strcpy+0xa>
    ;
  return os;
}
     9e0:	60a2                	ld	ra,8(sp)
     9e2:	6402                	ld	s0,0(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret

00000000000009e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
     9f0:	00054783          	lbu	a5,0(a0)
     9f4:	cb91                	beqz	a5,a08 <strcmp+0x20>
     9f6:	0005c703          	lbu	a4,0(a1)
     9fa:	00f71763          	bne	a4,a5,a08 <strcmp+0x20>
    p++, q++;
     9fe:	0505                	addi	a0,a0,1
     a00:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
     a02:	00054783          	lbu	a5,0(a0)
     a06:	fbe5                	bnez	a5,9f6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a08:	0005c503          	lbu	a0,0(a1)
}
     a0c:	40a7853b          	subw	a0,a5,a0
     a10:	60a2                	ld	ra,8(sp)
     a12:	6402                	ld	s0,0(sp)
     a14:	0141                	addi	sp,sp,16
     a16:	8082                	ret

0000000000000a18 <strlen>:

uint
strlen(const char *s)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e406                	sd	ra,8(sp)
     a1c:	e022                	sd	s0,0(sp)
     a1e:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
     a20:	00054783          	lbu	a5,0(a0)
     a24:	cf99                	beqz	a5,a42 <strlen+0x2a>
     a26:	0505                	addi	a0,a0,1
     a28:	87aa                	mv	a5,a0
     a2a:	86be                	mv	a3,a5
     a2c:	0785                	addi	a5,a5,1
     a2e:	fff7c703          	lbu	a4,-1(a5)
     a32:	ff65                	bnez	a4,a2a <strlen+0x12>
     a34:	40a6853b          	subw	a0,a3,a0
     a38:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     a3a:	60a2                	ld	ra,8(sp)
     a3c:	6402                	ld	s0,0(sp)
     a3e:	0141                	addi	sp,sp,16
     a40:	8082                	ret
  for (n = 0; s[n]; n++)
     a42:	4501                	li	a0,0
     a44:	bfdd                	j	a3a <strlen+0x22>

0000000000000a46 <memset>:

void *
memset(void *dst, int c, uint n)
{
     a46:	1141                	addi	sp,sp,-16
     a48:	e406                	sd	ra,8(sp)
     a4a:	e022                	sd	s0,0(sp)
     a4c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     a4e:	ca19                	beqz	a2,a64 <memset+0x1e>
     a50:	87aa                	mv	a5,a0
     a52:	1602                	slli	a2,a2,0x20
     a54:	9201                	srli	a2,a2,0x20
     a56:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a5a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     a5e:	0785                	addi	a5,a5,1
     a60:	fee79de3          	bne	a5,a4,a5a <memset+0x14>
  }
  return dst;
}
     a64:	60a2                	ld	ra,8(sp)
     a66:	6402                	ld	s0,0(sp)
     a68:	0141                	addi	sp,sp,16
     a6a:	8082                	ret

0000000000000a6c <strchr>:

char *
strchr(const char *s, char c)
{
     a6c:	1141                	addi	sp,sp,-16
     a6e:	e406                	sd	ra,8(sp)
     a70:	e022                	sd	s0,0(sp)
     a72:	0800                	addi	s0,sp,16
  for (; *s; s++)
     a74:	00054783          	lbu	a5,0(a0)
     a78:	cf81                	beqz	a5,a90 <strchr+0x24>
    if (*s == c)
     a7a:	00f58763          	beq	a1,a5,a88 <strchr+0x1c>
  for (; *s; s++)
     a7e:	0505                	addi	a0,a0,1
     a80:	00054783          	lbu	a5,0(a0)
     a84:	fbfd                	bnez	a5,a7a <strchr+0xe>
      return (char *)s;
  return 0;
     a86:	4501                	li	a0,0
}
     a88:	60a2                	ld	ra,8(sp)
     a8a:	6402                	ld	s0,0(sp)
     a8c:	0141                	addi	sp,sp,16
     a8e:	8082                	ret
  return 0;
     a90:	4501                	li	a0,0
     a92:	bfdd                	j	a88 <strchr+0x1c>

0000000000000a94 <gets>:

char *
gets(char *buf, int max)
{
     a94:	7159                	addi	sp,sp,-112
     a96:	f486                	sd	ra,104(sp)
     a98:	f0a2                	sd	s0,96(sp)
     a9a:	eca6                	sd	s1,88(sp)
     a9c:	e8ca                	sd	s2,80(sp)
     a9e:	e4ce                	sd	s3,72(sp)
     aa0:	e0d2                	sd	s4,64(sp)
     aa2:	fc56                	sd	s5,56(sp)
     aa4:	f85a                	sd	s6,48(sp)
     aa6:	f45e                	sd	s7,40(sp)
     aa8:	f062                	sd	s8,32(sp)
     aaa:	ec66                	sd	s9,24(sp)
     aac:	e86a                	sd	s10,16(sp)
     aae:	1880                	addi	s0,sp,112
     ab0:	8caa                	mv	s9,a0
     ab2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     ab4:	892a                	mv	s2,a0
     ab6:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ab8:	f9f40b13          	addi	s6,s0,-97
     abc:	4a85                	li	s5,1
    if (cc < 1)
      break;
    buf[i++] = c;
    if (c == '\n' || c == '\r')
     abe:	4ba9                	li	s7,10
     ac0:	4c35                	li	s8,13
  for (i = 0; i + 1 < max;) {
     ac2:	8d26                	mv	s10,s1
     ac4:	0014899b          	addiw	s3,s1,1
     ac8:	84ce                	mv	s1,s3
     aca:	0349d563          	bge	s3,s4,af4 <gets+0x60>
    cc = read(0, &c, 1);
     ace:	8656                	mv	a2,s5
     ad0:	85da                	mv	a1,s6
     ad2:	4501                	li	a0,0
     ad4:	1c4000ef          	jal	c98 <read>
    if (cc < 1)
     ad8:	00a05e63          	blez	a0,af4 <gets+0x60>
    buf[i++] = c;
     adc:	f9f44783          	lbu	a5,-97(s0)
     ae0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
     ae4:	01778763          	beq	a5,s7,af2 <gets+0x5e>
     ae8:	0905                	addi	s2,s2,1
     aea:	fd879ce3          	bne	a5,s8,ac2 <gets+0x2e>
    buf[i++] = c;
     aee:	8d4e                	mv	s10,s3
     af0:	a011                	j	af4 <gets+0x60>
     af2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     af4:	9d66                	add	s10,s10,s9
     af6:	000d0023          	sb	zero,0(s10)
  return buf;
}
     afa:	8566                	mv	a0,s9
     afc:	70a6                	ld	ra,104(sp)
     afe:	7406                	ld	s0,96(sp)
     b00:	64e6                	ld	s1,88(sp)
     b02:	6946                	ld	s2,80(sp)
     b04:	69a6                	ld	s3,72(sp)
     b06:	6a06                	ld	s4,64(sp)
     b08:	7ae2                	ld	s5,56(sp)
     b0a:	7b42                	ld	s6,48(sp)
     b0c:	7ba2                	ld	s7,40(sp)
     b0e:	7c02                	ld	s8,32(sp)
     b10:	6ce2                	ld	s9,24(sp)
     b12:	6d42                	ld	s10,16(sp)
     b14:	6165                	addi	sp,sp,112
     b16:	8082                	ret

0000000000000b18 <stat>:

int
stat(const char *n, struct stat *st)
{
     b18:	1101                	addi	sp,sp,-32
     b1a:	ec06                	sd	ra,24(sp)
     b1c:	e822                	sd	s0,16(sp)
     b1e:	e04a                	sd	s2,0(sp)
     b20:	1000                	addi	s0,sp,32
     b22:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b24:	4581                	li	a1,0
     b26:	19a000ef          	jal	cc0 <open>
  if (fd < 0)
     b2a:	02054263          	bltz	a0,b4e <stat+0x36>
     b2e:	e426                	sd	s1,8(sp)
     b30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b32:	85ca                	mv	a1,s2
     b34:	1a4000ef          	jal	cd8 <fstat>
     b38:	892a                	mv	s2,a0
  close(fd);
     b3a:	8526                	mv	a0,s1
     b3c:	16c000ef          	jal	ca8 <close>
  return r;
     b40:	64a2                	ld	s1,8(sp)
}
     b42:	854a                	mv	a0,s2
     b44:	60e2                	ld	ra,24(sp)
     b46:	6442                	ld	s0,16(sp)
     b48:	6902                	ld	s2,0(sp)
     b4a:	6105                	addi	sp,sp,32
     b4c:	8082                	ret
    return -1;
     b4e:	597d                	li	s2,-1
     b50:	bfcd                	j	b42 <stat+0x2a>

0000000000000b52 <atoi>:

int
atoi(const char *s)
{
     b52:	1141                	addi	sp,sp,-16
     b54:	e406                	sd	ra,8(sp)
     b56:	e022                	sd	s0,0(sp)
     b58:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
     b5a:	00054683          	lbu	a3,0(a0)
     b5e:	fd06879b          	addiw	a5,a3,-48
     b62:	0ff7f793          	zext.b	a5,a5
     b66:	4625                	li	a2,9
     b68:	02f66963          	bltu	a2,a5,b9a <atoi+0x48>
     b6c:	872a                	mv	a4,a0
  n = 0;
     b6e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
     b70:	0705                	addi	a4,a4,1
     b72:	0025179b          	slliw	a5,a0,0x2
     b76:	9fa9                	addw	a5,a5,a0
     b78:	0017979b          	slliw	a5,a5,0x1
     b7c:	9fb5                	addw	a5,a5,a3
     b7e:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
     b82:	00074683          	lbu	a3,0(a4)
     b86:	fd06879b          	addiw	a5,a3,-48
     b8a:	0ff7f793          	zext.b	a5,a5
     b8e:	fef671e3          	bgeu	a2,a5,b70 <atoi+0x1e>
  return n;
}
     b92:	60a2                	ld	ra,8(sp)
     b94:	6402                	ld	s0,0(sp)
     b96:	0141                	addi	sp,sp,16
     b98:	8082                	ret
  n = 0;
     b9a:	4501                	li	a0,0
     b9c:	bfdd                	j	b92 <atoi+0x40>

0000000000000b9e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     b9e:	1141                	addi	sp,sp,-16
     ba0:	e406                	sd	ra,8(sp)
     ba2:	e022                	sd	s0,0(sp)
     ba4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ba6:	02b57563          	bgeu	a0,a1,bd0 <memmove+0x32>
    while (n-- > 0)
     baa:	00c05f63          	blez	a2,bc8 <memmove+0x2a>
     bae:	1602                	slli	a2,a2,0x20
     bb0:	9201                	srli	a2,a2,0x20
     bb2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bb6:	872a                	mv	a4,a0
      *dst++ = *src++;
     bb8:	0585                	addi	a1,a1,1
     bba:	0705                	addi	a4,a4,1
     bbc:	fff5c683          	lbu	a3,-1(a1)
     bc0:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
     bc4:	fee79ae3          	bne	a5,a4,bb8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bc8:	60a2                	ld	ra,8(sp)
     bca:	6402                	ld	s0,0(sp)
     bcc:	0141                	addi	sp,sp,16
     bce:	8082                	ret
    dst += n;
     bd0:	00c50733          	add	a4,a0,a2
    src += n;
     bd4:	95b2                	add	a1,a1,a2
    while (n-- > 0)
     bd6:	fec059e3          	blez	a2,bc8 <memmove+0x2a>
     bda:	fff6079b          	addiw	a5,a2,-1
     bde:	1782                	slli	a5,a5,0x20
     be0:	9381                	srli	a5,a5,0x20
     be2:	fff7c793          	not	a5,a5
     be6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     be8:	15fd                	addi	a1,a1,-1
     bea:	177d                	addi	a4,a4,-1
     bec:	0005c683          	lbu	a3,0(a1)
     bf0:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
     bf4:	fef71ae3          	bne	a4,a5,be8 <memmove+0x4a>
     bf8:	bfc1                	j	bc8 <memmove+0x2a>

0000000000000bfa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bfa:	1141                	addi	sp,sp,-16
     bfc:	e406                	sd	ra,8(sp)
     bfe:	e022                	sd	s0,0(sp)
     c00:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c02:	ca0d                	beqz	a2,c34 <memcmp+0x3a>
     c04:	fff6069b          	addiw	a3,a2,-1
     c08:	1682                	slli	a3,a3,0x20
     c0a:	9281                	srli	a3,a3,0x20
     c0c:	0685                	addi	a3,a3,1
     c0e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     c10:	00054783          	lbu	a5,0(a0)
     c14:	0005c703          	lbu	a4,0(a1)
     c18:	00e79863          	bne	a5,a4,c28 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     c1c:	0505                	addi	a0,a0,1
    p2++;
     c1e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c20:	fed518e3          	bne	a0,a3,c10 <memcmp+0x16>
  }
  return 0;
     c24:	4501                	li	a0,0
     c26:	a019                	j	c2c <memcmp+0x32>
      return *p1 - *p2;
     c28:	40e7853b          	subw	a0,a5,a4
}
     c2c:	60a2                	ld	ra,8(sp)
     c2e:	6402                	ld	s0,0(sp)
     c30:	0141                	addi	sp,sp,16
     c32:	8082                	ret
  return 0;
     c34:	4501                	li	a0,0
     c36:	bfdd                	j	c2c <memcmp+0x32>

0000000000000c38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c38:	1141                	addi	sp,sp,-16
     c3a:	e406                	sd	ra,8(sp)
     c3c:	e022                	sd	s0,0(sp)
     c3e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c40:	f5fff0ef          	jal	b9e <memmove>
}
     c44:	60a2                	ld	ra,8(sp)
     c46:	6402                	ld	s0,0(sp)
     c48:	0141                	addi	sp,sp,16
     c4a:	8082                	ret

0000000000000c4c <sbrk>:

char *
sbrk(int n)
{
     c4c:	1141                	addi	sp,sp,-16
     c4e:	e406                	sd	ra,8(sp)
     c50:	e022                	sd	s0,0(sp)
     c52:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c54:	4585                	li	a1,1
     c56:	0b2000ef          	jal	d08 <sys_sbrk>
}
     c5a:	60a2                	ld	ra,8(sp)
     c5c:	6402                	ld	s0,0(sp)
     c5e:	0141                	addi	sp,sp,16
     c60:	8082                	ret

0000000000000c62 <sbrklazy>:

char *
sbrklazy(int n)
{
     c62:	1141                	addi	sp,sp,-16
     c64:	e406                	sd	ra,8(sp)
     c66:	e022                	sd	s0,0(sp)
     c68:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c6a:	4589                	li	a1,2
     c6c:	09c000ef          	jal	d08 <sys_sbrk>
}
     c70:	60a2                	ld	ra,8(sp)
     c72:	6402                	ld	s0,0(sp)
     c74:	0141                	addi	sp,sp,16
     c76:	8082                	ret

0000000000000c78 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c78:	4885                	li	a7,1
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c80:	4889                	li	a7,2
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c88:	488d                	li	a7,3
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c90:	4891                	li	a7,4
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <read>:
.global read
read:
 li a7, SYS_read
     c98:	4895                	li	a7,5
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <write>:
.global write
write:
 li a7, SYS_write
     ca0:	48c1                	li	a7,16
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <close>:
.global close
close:
 li a7, SYS_close
     ca8:	48d5                	li	a7,21
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cb0:	4899                	li	a7,6
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <exec>:
.global exec
exec:
 li a7, SYS_exec
     cb8:	489d                	li	a7,7
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <open>:
.global open
open:
 li a7, SYS_open
     cc0:	48bd                	li	a7,15
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cc8:	48c5                	li	a7,17
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cd0:	48c9                	li	a7,18
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cd8:	48a1                	li	a7,8
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <link>:
.global link
link:
 li a7, SYS_link
     ce0:	48cd                	li	a7,19
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ce8:	48d1                	li	a7,20
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cf0:	48a5                	li	a7,9
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <dup>:
.global dup
dup:
 li a7, SYS_dup
     cf8:	48a9                	li	a7,10
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d00:	48ad                	li	a7,11
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     d08:	48b1                	li	a7,12
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d10:	48b5                	li	a7,13
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d18:	48b9                	li	a7,14
 ecall
     d1a:	00000073          	ecall
 ret
     d1e:	8082                	ret

0000000000000d20 <sync>:
.global sync
sync:
 li a7, SYS_sync
     d20:	48d9                	li	a7,22
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <ps>:
.global ps
ps:
 li a7, SYS_ps
     d28:	48dd                	li	a7,23
 ecall
     d2a:	00000073          	ecall
 ret
     d2e:	8082                	ret

0000000000000d30 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
     d30:	48e1                	li	a7,24
 ecall
     d32:	00000073          	ecall
 ret
     d36:	8082                	ret

0000000000000d38 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     d38:	48e5                	li	a7,25
 ecall
     d3a:	00000073          	ecall
 ret
     d3e:	8082                	ret

0000000000000d40 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     d40:	48e9                	li	a7,26
 ecall
     d42:	00000073          	ecall
 ret
     d46:	8082                	ret

0000000000000d48 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d48:	1101                	addi	sp,sp,-32
     d4a:	ec06                	sd	ra,24(sp)
     d4c:	e822                	sd	s0,16(sp)
     d4e:	1000                	addi	s0,sp,32
     d50:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d54:	4605                	li	a2,1
     d56:	fef40593          	addi	a1,s0,-17
     d5a:	f47ff0ef          	jal	ca0 <write>
}
     d5e:	60e2                	ld	ra,24(sp)
     d60:	6442                	ld	s0,16(sp)
     d62:	6105                	addi	sp,sp,32
     d64:	8082                	ret

0000000000000d66 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d66:	715d                	addi	sp,sp,-80
     d68:	e486                	sd	ra,72(sp)
     d6a:	e0a2                	sd	s0,64(sp)
     d6c:	fc26                	sd	s1,56(sp)
     d6e:	f84a                	sd	s2,48(sp)
     d70:	f44e                	sd	s3,40(sp)
     d72:	0880                	addi	s0,sp,80
     d74:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
     d76:	c299                	beqz	a3,d7c <printint+0x16>
     d78:	0605cc63          	bltz	a1,df0 <printint+0x8a>
  neg = 0;
     d7c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     d7e:	fb840313          	addi	t1,s0,-72
  neg = 0;
     d82:	869a                	mv	a3,t1
  i = 0;
     d84:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
     d86:	00000817          	auipc	a6,0x0
     d8a:	63280813          	addi	a6,a6,1586 # 13b8 <digits>
     d8e:	88be                	mv	a7,a5
     d90:	0017851b          	addiw	a0,a5,1
     d94:	87aa                	mv	a5,a0
     d96:	02c5f733          	remu	a4,a1,a2
     d9a:	9742                	add	a4,a4,a6
     d9c:	00074703          	lbu	a4,0(a4)
     da0:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
     da4:	872e                	mv	a4,a1
     da6:	02c5d5b3          	divu	a1,a1,a2
     daa:	0685                	addi	a3,a3,1
     dac:	fec771e3          	bgeu	a4,a2,d8e <printint+0x28>
  if (neg)
     db0:	000e0c63          	beqz	t3,dc8 <printint+0x62>
    buf[i++] = '-';
     db4:	fd050793          	addi	a5,a0,-48
     db8:	00878533          	add	a0,a5,s0
     dbc:	02d00793          	li	a5,45
     dc0:	fef50423          	sb	a5,-24(a0)
     dc4:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
     dc8:	fff7899b          	addiw	s3,a5,-1
     dcc:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     dd0:	fff4c583          	lbu	a1,-1(s1)
     dd4:	854a                	mv	a0,s2
     dd6:	f73ff0ef          	jal	d48 <putc>
  while (--i >= 0)
     dda:	39fd                	addiw	s3,s3,-1
     ddc:	14fd                	addi	s1,s1,-1
     dde:	fe09d9e3          	bgez	s3,dd0 <printint+0x6a>
}
     de2:	60a6                	ld	ra,72(sp)
     de4:	6406                	ld	s0,64(sp)
     de6:	74e2                	ld	s1,56(sp)
     de8:	7942                	ld	s2,48(sp)
     dea:	79a2                	ld	s3,40(sp)
     dec:	6161                	addi	sp,sp,80
     dee:	8082                	ret
    x = -xx;
     df0:	40b005b3          	neg	a1,a1
    neg = 1;
     df4:	4e05                	li	t3,1
    x = -xx;
     df6:	b761                	j	d7e <printint+0x18>

0000000000000df8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     df8:	711d                	addi	sp,sp,-96
     dfa:	ec86                	sd	ra,88(sp)
     dfc:	e8a2                	sd	s0,80(sp)
     dfe:	e4a6                	sd	s1,72(sp)
     e00:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     e02:	0005c483          	lbu	s1,0(a1)
     e06:	28048463          	beqz	s1,108e <vprintf+0x296>
     e0a:	e0ca                	sd	s2,64(sp)
     e0c:	fc4e                	sd	s3,56(sp)
     e0e:	f852                	sd	s4,48(sp)
     e10:	f456                	sd	s5,40(sp)
     e12:	f05a                	sd	s6,32(sp)
     e14:	ec5e                	sd	s7,24(sp)
     e16:	e862                	sd	s8,16(sp)
     e18:	e466                	sd	s9,8(sp)
     e1a:	8b2a                	mv	s6,a0
     e1c:	8a2e                	mv	s4,a1
     e1e:	8bb2                	mv	s7,a2
  state = 0;
     e20:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
     e22:	4901                	li	s2,0
     e24:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
     e26:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
     e2a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
     e2e:	06c00c93          	li	s9,108
     e32:	a00d                	j	e54 <vprintf+0x5c>
        putc(fd, c0);
     e34:	85a6                	mv	a1,s1
     e36:	855a                	mv	a0,s6
     e38:	f11ff0ef          	jal	d48 <putc>
     e3c:	a019                	j	e42 <vprintf+0x4a>
    } else if (state == '%') {
     e3e:	03598363          	beq	s3,s5,e64 <vprintf+0x6c>
  for (i = 0; fmt[i]; i++) {
     e42:	0019079b          	addiw	a5,s2,1
     e46:	893e                	mv	s2,a5
     e48:	873e                	mv	a4,a5
     e4a:	97d2                	add	a5,a5,s4
     e4c:	0007c483          	lbu	s1,0(a5)
     e50:	22048763          	beqz	s1,107e <vprintf+0x286>
    c0 = fmt[i] & 0xff;
     e54:	0004879b          	sext.w	a5,s1
    if (state == 0) {
     e58:	fe0993e3          	bnez	s3,e3e <vprintf+0x46>
      if (c0 == '%') {
     e5c:	fd579ce3          	bne	a5,s5,e34 <vprintf+0x3c>
        state = '%';
     e60:	89be                	mv	s3,a5
     e62:	b7c5                	j	e42 <vprintf+0x4a>
        c1 = fmt[i + 1] & 0xff;
     e64:	00ea06b3          	add	a3,s4,a4
     e68:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     e6c:	8636                	mv	a2,a3
      if (c1)
     e6e:	c681                	beqz	a3,e76 <vprintf+0x7e>
        c2 = fmt[i + 2] & 0xff;
     e70:	9752                	add	a4,a4,s4
     e72:	00274603          	lbu	a2,2(a4)
      if (c0 == 'd') {
     e76:	05878263          	beq	a5,s8,eba <vprintf+0xc2>
      } else if (c0 == 'l' && c1 == 'd') {
     e7a:	05978c63          	beq	a5,s9,ed2 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
     e7e:	07500713          	li	a4,117
     e82:	0ee78663          	beq	a5,a4,f6e <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
     e86:	07800713          	li	a4,120
     e8a:	12e78863          	beq	a5,a4,fba <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
     e8e:	07000713          	li	a4,112
     e92:	14e78d63          	beq	a5,a4,fec <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
     e96:	06300713          	li	a4,99
     e9a:	18e78c63          	beq	a5,a4,1032 <vprintf+0x23a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
     e9e:	07300713          	li	a4,115
     ea2:	1ae78263          	beq	a5,a4,1046 <vprintf+0x24e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
     ea6:	02500713          	li	a4,37
     eaa:	04e79463          	bne	a5,a4,ef2 <vprintf+0xfa>
        putc(fd, '%');
     eae:	85ba                	mv	a1,a4
     eb0:	855a                	mv	a0,s6
     eb2:	e97ff0ef          	jal	d48 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     eb6:	4981                	li	s3,0
     eb8:	b769                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     eba:	008b8493          	addi	s1,s7,8
     ebe:	4685                	li	a3,1
     ec0:	4629                	li	a2,10
     ec2:	000ba583          	lw	a1,0(s7)
     ec6:	855a                	mv	a0,s6
     ec8:	e9fff0ef          	jal	d66 <printint>
     ecc:	8ba6                	mv	s7,s1
      state = 0;
     ece:	4981                	li	s3,0
     ed0:	bf8d                	j	e42 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'd') {
     ed2:	06400793          	li	a5,100
     ed6:	02f68963          	beq	a3,a5,f08 <vprintf+0x110>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     eda:	06c00793          	li	a5,108
     ede:	04f68263          	beq	a3,a5,f22 <vprintf+0x12a>
      } else if (c0 == 'l' && c1 == 'u') {
     ee2:	07500793          	li	a5,117
     ee6:	0af68063          	beq	a3,a5,f86 <vprintf+0x18e>
      } else if (c0 == 'l' && c1 == 'x') {
     eea:	07800793          	li	a5,120
     eee:	0ef68263          	beq	a3,a5,fd2 <vprintf+0x1da>
        putc(fd, '%');
     ef2:	02500593          	li	a1,37
     ef6:	855a                	mv	a0,s6
     ef8:	e51ff0ef          	jal	d48 <putc>
        putc(fd, c0);
     efc:	85a6                	mv	a1,s1
     efe:	855a                	mv	a0,s6
     f00:	e49ff0ef          	jal	d48 <putc>
      state = 0;
     f04:	4981                	li	s3,0
     f06:	bf35                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f08:	008b8493          	addi	s1,s7,8
     f0c:	4685                	li	a3,1
     f0e:	4629                	li	a2,10
     f10:	000bb583          	ld	a1,0(s7)
     f14:	855a                	mv	a0,s6
     f16:	e51ff0ef          	jal	d66 <printint>
        i += 1;
     f1a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     f1c:	8ba6                	mv	s7,s1
      state = 0;
     f1e:	4981                	li	s3,0
        i += 1;
     f20:	b70d                	j	e42 <vprintf+0x4a>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     f22:	06400793          	li	a5,100
     f26:	02f60763          	beq	a2,a5,f54 <vprintf+0x15c>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
     f2a:	07500793          	li	a5,117
     f2e:	06f60963          	beq	a2,a5,fa0 <vprintf+0x1a8>
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
     f32:	07800793          	li	a5,120
     f36:	faf61ee3          	bne	a2,a5,ef2 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f3a:	008b8493          	addi	s1,s7,8
     f3e:	4681                	li	a3,0
     f40:	4641                	li	a2,16
     f42:	000bb583          	ld	a1,0(s7)
     f46:	855a                	mv	a0,s6
     f48:	e1fff0ef          	jal	d66 <printint>
        i += 2;
     f4c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f4e:	8ba6                	mv	s7,s1
      state = 0;
     f50:	4981                	li	s3,0
        i += 2;
     f52:	bdc5                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f54:	008b8493          	addi	s1,s7,8
     f58:	4685                	li	a3,1
     f5a:	4629                	li	a2,10
     f5c:	000bb583          	ld	a1,0(s7)
     f60:	855a                	mv	a0,s6
     f62:	e05ff0ef          	jal	d66 <printint>
        i += 2;
     f66:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f68:	8ba6                	mv	s7,s1
      state = 0;
     f6a:	4981                	li	s3,0
        i += 2;
     f6c:	bdd9                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f6e:	008b8493          	addi	s1,s7,8
     f72:	4681                	li	a3,0
     f74:	4629                	li	a2,10
     f76:	000be583          	lwu	a1,0(s7)
     f7a:	855a                	mv	a0,s6
     f7c:	debff0ef          	jal	d66 <printint>
     f80:	8ba6                	mv	s7,s1
      state = 0;
     f82:	4981                	li	s3,0
     f84:	bd7d                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f86:	008b8493          	addi	s1,s7,8
     f8a:	4681                	li	a3,0
     f8c:	4629                	li	a2,10
     f8e:	000bb583          	ld	a1,0(s7)
     f92:	855a                	mv	a0,s6
     f94:	dd3ff0ef          	jal	d66 <printint>
        i += 1;
     f98:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f9a:	8ba6                	mv	s7,s1
      state = 0;
     f9c:	4981                	li	s3,0
        i += 1;
     f9e:	b555                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fa0:	008b8493          	addi	s1,s7,8
     fa4:	4681                	li	a3,0
     fa6:	4629                	li	a2,10
     fa8:	000bb583          	ld	a1,0(s7)
     fac:	855a                	mv	a0,s6
     fae:	db9ff0ef          	jal	d66 <printint>
        i += 2;
     fb2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     fb4:	8ba6                	mv	s7,s1
      state = 0;
     fb6:	4981                	li	s3,0
        i += 2;
     fb8:	b569                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     fba:	008b8493          	addi	s1,s7,8
     fbe:	4681                	li	a3,0
     fc0:	4641                	li	a2,16
     fc2:	000be583          	lwu	a1,0(s7)
     fc6:	855a                	mv	a0,s6
     fc8:	d9fff0ef          	jal	d66 <printint>
     fcc:	8ba6                	mv	s7,s1
      state = 0;
     fce:	4981                	li	s3,0
     fd0:	bd8d                	j	e42 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fd2:	008b8493          	addi	s1,s7,8
     fd6:	4681                	li	a3,0
     fd8:	4641                	li	a2,16
     fda:	000bb583          	ld	a1,0(s7)
     fde:	855a                	mv	a0,s6
     fe0:	d87ff0ef          	jal	d66 <printint>
        i += 1;
     fe4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fe6:	8ba6                	mv	s7,s1
      state = 0;
     fe8:	4981                	li	s3,0
        i += 1;
     fea:	bda1                	j	e42 <vprintf+0x4a>
     fec:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     fee:	008b8d13          	addi	s10,s7,8
     ff2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ff6:	03000593          	li	a1,48
     ffa:	855a                	mv	a0,s6
     ffc:	d4dff0ef          	jal	d48 <putc>
  putc(fd, 'x');
    1000:	07800593          	li	a1,120
    1004:	855a                	mv	a0,s6
    1006:	d43ff0ef          	jal	d48 <putc>
    100a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    100c:	00000b97          	auipc	s7,0x0
    1010:	3acb8b93          	addi	s7,s7,940 # 13b8 <digits>
    1014:	03c9d793          	srli	a5,s3,0x3c
    1018:	97de                	add	a5,a5,s7
    101a:	0007c583          	lbu	a1,0(a5)
    101e:	855a                	mv	a0,s6
    1020:	d29ff0ef          	jal	d48 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1024:	0992                	slli	s3,s3,0x4
    1026:	34fd                	addiw	s1,s1,-1
    1028:	f4f5                	bnez	s1,1014 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    102a:	8bea                	mv	s7,s10
      state = 0;
    102c:	4981                	li	s3,0
    102e:	6d02                	ld	s10,0(sp)
    1030:	bd09                	j	e42 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    1032:	008b8493          	addi	s1,s7,8
    1036:	000bc583          	lbu	a1,0(s7)
    103a:	855a                	mv	a0,s6
    103c:	d0dff0ef          	jal	d48 <putc>
    1040:	8ba6                	mv	s7,s1
      state = 0;
    1042:	4981                	li	s3,0
    1044:	bbfd                	j	e42 <vprintf+0x4a>
        if ((s = va_arg(ap, char *)) == 0)
    1046:	008b8993          	addi	s3,s7,8
    104a:	000bb483          	ld	s1,0(s7)
    104e:	cc91                	beqz	s1,106a <vprintf+0x272>
        for (; *s; s++)
    1050:	0004c583          	lbu	a1,0(s1)
    1054:	c195                	beqz	a1,1078 <vprintf+0x280>
          putc(fd, *s);
    1056:	855a                	mv	a0,s6
    1058:	cf1ff0ef          	jal	d48 <putc>
        for (; *s; s++)
    105c:	0485                	addi	s1,s1,1
    105e:	0004c583          	lbu	a1,0(s1)
    1062:	f9f5                	bnez	a1,1056 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    1064:	8bce                	mv	s7,s3
      state = 0;
    1066:	4981                	li	s3,0
    1068:	bbe9                	j	e42 <vprintf+0x4a>
          s = "(null)";
    106a:	00000497          	auipc	s1,0x0
    106e:	31648493          	addi	s1,s1,790 # 1380 <malloc+0x206>
        for (; *s; s++)
    1072:	02800593          	li	a1,40
    1076:	b7c5                	j	1056 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
    1078:	8bce                	mv	s7,s3
      state = 0;
    107a:	4981                	li	s3,0
    107c:	b3d9                	j	e42 <vprintf+0x4a>
    107e:	6906                	ld	s2,64(sp)
    1080:	79e2                	ld	s3,56(sp)
    1082:	7a42                	ld	s4,48(sp)
    1084:	7aa2                	ld	s5,40(sp)
    1086:	7b02                	ld	s6,32(sp)
    1088:	6be2                	ld	s7,24(sp)
    108a:	6c42                	ld	s8,16(sp)
    108c:	6ca2                	ld	s9,8(sp)
    }
  }
}
    108e:	60e6                	ld	ra,88(sp)
    1090:	6446                	ld	s0,80(sp)
    1092:	64a6                	ld	s1,72(sp)
    1094:	6125                	addi	sp,sp,96
    1096:	8082                	ret

0000000000001098 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1098:	715d                	addi	sp,sp,-80
    109a:	ec06                	sd	ra,24(sp)
    109c:	e822                	sd	s0,16(sp)
    109e:	1000                	addi	s0,sp,32
    10a0:	e010                	sd	a2,0(s0)
    10a2:	e414                	sd	a3,8(s0)
    10a4:	e818                	sd	a4,16(s0)
    10a6:	ec1c                	sd	a5,24(s0)
    10a8:	03043023          	sd	a6,32(s0)
    10ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10b0:	8622                	mv	a2,s0
    10b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10b6:	d43ff0ef          	jal	df8 <vprintf>
}
    10ba:	60e2                	ld	ra,24(sp)
    10bc:	6442                	ld	s0,16(sp)
    10be:	6161                	addi	sp,sp,80
    10c0:	8082                	ret

00000000000010c2 <printf>:

void
printf(const char *fmt, ...)
{
    10c2:	711d                	addi	sp,sp,-96
    10c4:	ec06                	sd	ra,24(sp)
    10c6:	e822                	sd	s0,16(sp)
    10c8:	1000                	addi	s0,sp,32
    10ca:	e40c                	sd	a1,8(s0)
    10cc:	e810                	sd	a2,16(s0)
    10ce:	ec14                	sd	a3,24(s0)
    10d0:	f018                	sd	a4,32(s0)
    10d2:	f41c                	sd	a5,40(s0)
    10d4:	03043823          	sd	a6,48(s0)
    10d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10dc:	00840613          	addi	a2,s0,8
    10e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10e4:	85aa                	mv	a1,a0
    10e6:	4505                	li	a0,1
    10e8:	d11ff0ef          	jal	df8 <vprintf>
}
    10ec:	60e2                	ld	ra,24(sp)
    10ee:	6442                	ld	s0,16(sp)
    10f0:	6125                	addi	sp,sp,96
    10f2:	8082                	ret

00000000000010f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10f4:	1141                	addi	sp,sp,-16
    10f6:	e406                	sd	ra,8(sp)
    10f8:	e022                	sd	s0,0(sp)
    10fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    10fc:	ff050693          	addi	a3,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1100:	00001797          	auipc	a5,0x1
    1104:	f107b783          	ld	a5,-240(a5) # 2010 <freep>
    1108:	a02d                	j	1132 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    bp->s.size += p->s.ptr->s.size;
    110a:	4618                	lw	a4,8(a2)
    110c:	9f2d                	addw	a4,a4,a1
    110e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1112:	6398                	ld	a4,0(a5)
    1114:	6310                	ld	a2,0(a4)
    1116:	a83d                	j	1154 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    p->s.size += bp->s.size;
    1118:	ff852703          	lw	a4,-8(a0)
    111c:	9f31                	addw	a4,a4,a2
    111e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1120:	ff053683          	ld	a3,-16(a0)
    1124:	a091                	j	1168 <free+0x74>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1126:	6398                	ld	a4,0(a5)
    1128:	00e7e463          	bltu	a5,a4,1130 <free+0x3c>
    112c:	00e6ea63          	bltu	a3,a4,1140 <free+0x4c>
{
    1130:	87ba                	mv	a5,a4
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1132:	fed7fae3          	bgeu	a5,a3,1126 <free+0x32>
    1136:	6398                	ld	a4,0(a5)
    1138:	00e6e463          	bltu	a3,a4,1140 <free+0x4c>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    113c:	fee7eae3          	bltu	a5,a4,1130 <free+0x3c>
  if (bp + bp->s.size == p->s.ptr) {
    1140:	ff852583          	lw	a1,-8(a0)
    1144:	6390                	ld	a2,0(a5)
    1146:	02059813          	slli	a6,a1,0x20
    114a:	01c85713          	srli	a4,a6,0x1c
    114e:	9736                	add	a4,a4,a3
    1150:	fae60de3          	beq	a2,a4,110a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    1154:	fec53823          	sd	a2,-16(a0)
  if (p + p->s.size == bp) {
    1158:	4790                	lw	a2,8(a5)
    115a:	02061593          	slli	a1,a2,0x20
    115e:	01c5d713          	srli	a4,a1,0x1c
    1162:	973e                	add	a4,a4,a5
    1164:	fae68ae3          	beq	a3,a4,1118 <free+0x24>
    p->s.ptr = bp->s.ptr;
    1168:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    116a:	00001717          	auipc	a4,0x1
    116e:	eaf73323          	sd	a5,-346(a4) # 2010 <freep>
}
    1172:	60a2                	ld	ra,8(sp)
    1174:	6402                	ld	s0,0(sp)
    1176:	0141                	addi	sp,sp,16
    1178:	8082                	ret

000000000000117a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    117a:	7139                	addi	sp,sp,-64
    117c:	fc06                	sd	ra,56(sp)
    117e:	f822                	sd	s0,48(sp)
    1180:	f04a                	sd	s2,32(sp)
    1182:	ec4e                	sd	s3,24(sp)
    1184:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1186:	02051993          	slli	s3,a0,0x20
    118a:	0209d993          	srli	s3,s3,0x20
    118e:	09bd                	addi	s3,s3,15
    1190:	0049d993          	srli	s3,s3,0x4
    1194:	2985                	addiw	s3,s3,1
    1196:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    1198:	00001517          	auipc	a0,0x1
    119c:	e7853503          	ld	a0,-392(a0) # 2010 <freep>
    11a0:	c905                	beqz	a0,11d0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    11a2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    11a4:	4798                	lw	a4,8(a5)
    11a6:	09377663          	bgeu	a4,s3,1232 <malloc+0xb8>
    11aa:	f426                	sd	s1,40(sp)
    11ac:	e852                	sd	s4,16(sp)
    11ae:	e456                	sd	s5,8(sp)
    11b0:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    11b2:	8a4e                	mv	s4,s3
    11b4:	6705                	lui	a4,0x1
    11b6:	00e9f363          	bgeu	s3,a4,11bc <malloc+0x42>
    11ba:	6a05                	lui	s4,0x1
    11bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    11c4:	00001497          	auipc	s1,0x1
    11c8:	e4c48493          	addi	s1,s1,-436 # 2010 <freep>
  if (p == SBRK_ERROR)
    11cc:	5afd                	li	s5,-1
    11ce:	a83d                	j	120c <malloc+0x92>
    11d0:	f426                	sd	s1,40(sp)
    11d2:	e852                	sd	s4,16(sp)
    11d4:	e456                	sd	s5,8(sp)
    11d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11d8:	00001797          	auipc	a5,0x1
    11dc:	eb078793          	addi	a5,a5,-336 # 2088 <base>
    11e0:	00001717          	auipc	a4,0x1
    11e4:	e2f73823          	sd	a5,-464(a4) # 2010 <freep>
    11e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11ea:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    11ee:	b7d1                	j	11b2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11f0:	6398                	ld	a4,0(a5)
    11f2:	e118                	sd	a4,0(a0)
    11f4:	a899                	j	124a <malloc+0xd0>
  hp->s.size = nu;
    11f6:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    11fa:	0541                	addi	a0,a0,16
    11fc:	ef9ff0ef          	jal	10f4 <free>
  return freep;
    1200:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    1202:	c125                	beqz	a0,1262 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1204:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    1206:	4798                	lw	a4,8(a5)
    1208:	03277163          	bgeu	a4,s2,122a <malloc+0xb0>
    if (p == freep)
    120c:	6098                	ld	a4,0(s1)
    120e:	853e                	mv	a0,a5
    1210:	fef71ae3          	bne	a4,a5,1204 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1214:	8552                	mv	a0,s4
    1216:	a37ff0ef          	jal	c4c <sbrk>
  if (p == SBRK_ERROR)
    121a:	fd551ee3          	bne	a0,s5,11f6 <malloc+0x7c>
        return 0;
    121e:	4501                	li	a0,0
    1220:	74a2                	ld	s1,40(sp)
    1222:	6a42                	ld	s4,16(sp)
    1224:	6aa2                	ld	s5,8(sp)
    1226:	6b02                	ld	s6,0(sp)
    1228:	a03d                	j	1256 <malloc+0xdc>
    122a:	74a2                	ld	s1,40(sp)
    122c:	6a42                	ld	s4,16(sp)
    122e:	6aa2                	ld	s5,8(sp)
    1230:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    1232:	fae90fe3          	beq	s2,a4,11f0 <malloc+0x76>
        p->s.size -= nunits;
    1236:	4137073b          	subw	a4,a4,s3
    123a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    123c:	02071693          	slli	a3,a4,0x20
    1240:	01c6d713          	srli	a4,a3,0x1c
    1244:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1246:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    124a:	00001717          	auipc	a4,0x1
    124e:	dca73323          	sd	a0,-570(a4) # 2010 <freep>
      return (void *)(p + 1);
    1252:	01078513          	addi	a0,a5,16
  }
}
    1256:	70e2                	ld	ra,56(sp)
    1258:	7442                	ld	s0,48(sp)
    125a:	7902                	ld	s2,32(sp)
    125c:	69e2                	ld	s3,24(sp)
    125e:	6121                	addi	sp,sp,64
    1260:	8082                	ret
    1262:	74a2                	ld	s1,40(sp)
    1264:	6a42                	ld	s4,16(sp)
    1266:	6aa2                	ld	s5,8(sp)
    1268:	6b02                	ld	s6,0(sp)
    126a:	b7f5                	j	1256 <malloc+0xdc>
