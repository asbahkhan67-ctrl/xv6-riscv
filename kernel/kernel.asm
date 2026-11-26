
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	d8010113          	addi	sp,sp,-640 # 80009d80 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	03e000ef          	jal	80000054 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000022:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000026:	577d                	li	a4,-1
    80000028:	177e                	slli	a4,a4,0x3f
    8000002a:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002c:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000030:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000034:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    80000038:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003c:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000040:	000f4737          	lui	a4,0xf4
    80000044:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000048:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004a:	14d79073          	csrw	stimecmp,a5
}
    8000004e:	6422                	ld	s0,8(sp)
    80000050:	0141                	addi	sp,sp,16
    80000052:	8082                	ret

0000000080000054 <start>:
{
    80000054:	1141                	addi	sp,sp,-16
    80000056:	e406                	sd	ra,8(sp)
    80000058:	e022                	sd	s0,0(sp)
    8000005a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    8000005c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000060:	7779                	lui	a4,0xffffe
    80000062:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdac747>
    80000066:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000068:	6705                	lui	a4,0x1
    8000006a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000006e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000074:	00001797          	auipc	a5,0x1
    80000078:	f5a78793          	addi	a5,a5,-166 # 80000fce <main>
    8000007c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000080:	4781                	li	a5,0
    80000082:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    80000086:	67c1                	lui	a5,0x10
    80000088:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    8000008e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000092:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80000096:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009a:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    8000009e:	57fd                	li	a5,-1
    800000a0:	83a9                	srli	a5,a5,0xa
    800000a2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000a6:	47bd                	li	a5,15
    800000a8:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000ac:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b0:	4705                	li	a4,1
    800000b2:	1776                	slli	a4,a4,0x3d
    800000b4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000b6:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000ba:	f63ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000be:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c2:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c6:	30200073          	mret
}
    800000ca:	60a2                	ld	ra,8(sp)
    800000cc:	6402                	ld	s0,0(sp)
    800000ce:	0141                	addi	sp,sp,16
    800000d0:	8082                	ret

00000000800000d2 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d2:	7119                	addi	sp,sp,-128
    800000d4:	fc86                	sd	ra,120(sp)
    800000d6:	f8a2                	sd	s0,112(sp)
    800000d8:	f4a6                	sd	s1,104(sp)
    800000da:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000dc:	06c05a63          	blez	a2,80000150 <consolewrite+0x7e>
    800000e0:	f0ca                	sd	s2,96(sp)
    800000e2:	ecce                	sd	s3,88(sp)
    800000e4:	e8d2                	sd	s4,80(sp)
    800000e6:	e4d6                	sd	s5,72(sp)
    800000e8:	e0da                	sd	s6,64(sp)
    800000ea:	fc5e                	sd	s7,56(sp)
    800000ec:	f862                	sd	s8,48(sp)
    800000ee:	f466                	sd	s9,40(sp)
    800000f0:	8aaa                	mv	s5,a0
    800000f2:	8b2e                	mv	s6,a1
    800000f4:	8a32                	mv	s4,a2
  int i = 0;
    800000f6:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000f8:	02000c13          	li	s8,32
    800000fc:	02000c93          	li	s9,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000100:	5bfd                	li	s7,-1
    80000102:	a035                	j	8000012e <consolewrite+0x5c>
    if (nn > n - i)
    80000104:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000108:	86ce                	mv	a3,s3
    8000010a:	01648633          	add	a2,s1,s6
    8000010e:	85d6                	mv	a1,s5
    80000110:	f8040513          	addi	a0,s0,-128
    80000114:	5cb020ef          	jal	80002ede <either_copyin>
    80000118:	03750e63          	beq	a0,s7,80000154 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    8000011c:	85ce                	mv	a1,s3
    8000011e:	f8040513          	addi	a0,s0,-128
    80000122:	786000ef          	jal	800008a8 <uartwrite>
    i += nn;
    80000126:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    8000012a:	0144da63          	bge	s1,s4,8000013e <consolewrite+0x6c>
    if (nn > n - i)
    8000012e:	409a093b          	subw	s2,s4,s1
    80000132:	0009079b          	sext.w	a5,s2
    80000136:	fcfc57e3          	bge	s8,a5,80000104 <consolewrite+0x32>
    8000013a:	8966                	mv	s2,s9
    8000013c:	b7e1                	j	80000104 <consolewrite+0x32>
    8000013e:	7906                	ld	s2,96(sp)
    80000140:	69e6                	ld	s3,88(sp)
    80000142:	6a46                	ld	s4,80(sp)
    80000144:	6aa6                	ld	s5,72(sp)
    80000146:	6b06                	ld	s6,64(sp)
    80000148:	7be2                	ld	s7,56(sp)
    8000014a:	7c42                	ld	s8,48(sp)
    8000014c:	7ca2                	ld	s9,40(sp)
    8000014e:	a819                	j	80000164 <consolewrite+0x92>
  int i = 0;
    80000150:	4481                	li	s1,0
    80000152:	a809                	j	80000164 <consolewrite+0x92>
    80000154:	7906                	ld	s2,96(sp)
    80000156:	69e6                	ld	s3,88(sp)
    80000158:	6a46                	ld	s4,80(sp)
    8000015a:	6aa6                	ld	s5,72(sp)
    8000015c:	6b06                	ld	s6,64(sp)
    8000015e:	7be2                	ld	s7,56(sp)
    80000160:	7c42                	ld	s8,48(sp)
    80000162:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80000164:	8526                	mv	a0,s1
    80000166:	70e6                	ld	ra,120(sp)
    80000168:	7446                	ld	s0,112(sp)
    8000016a:	74a6                	ld	s1,104(sp)
    8000016c:	6109                	addi	sp,sp,128
    8000016e:	8082                	ret

0000000080000170 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000170:	711d                	addi	sp,sp,-96
    80000172:	ec86                	sd	ra,88(sp)
    80000174:	e8a2                	sd	s0,80(sp)
    80000176:	e4a6                	sd	s1,72(sp)
    80000178:	e0ca                	sd	s2,64(sp)
    8000017a:	fc4e                	sd	s3,56(sp)
    8000017c:	f852                	sd	s4,48(sp)
    8000017e:	f456                	sd	s5,40(sp)
    80000180:	f05a                	sd	s6,32(sp)
    80000182:	1080                	addi	s0,sp,96
    80000184:	8aaa                	mv	s5,a0
    80000186:	8a2e                	mv	s4,a1
    80000188:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000018a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018e:	00012517          	auipc	a0,0x12
    80000192:	bf250513          	addi	a0,a0,-1038 # 80011d80 <cons>
    80000196:	3db000ef          	jal	80000d70 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    8000019a:	00012497          	auipc	s1,0x12
    8000019e:	be648493          	addi	s1,s1,-1050 # 80011d80 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a2:	00012917          	auipc	s2,0x12
    800001a6:	c7690913          	addi	s2,s2,-906 # 80011e18 <cons+0x98>
  while (n > 0) {
    800001aa:	0d305463          	blez	s3,80000272 <consoleread+0x102>
    while (cons.r == cons.w) {
    800001ae:	0984a783          	lw	a5,152(s1)
    800001b2:	09c4a703          	lw	a4,156(s1)
    800001b6:	0af71963          	bne	a4,a5,80000268 <consoleread+0xf8>
      if (killed(myproc())) {
    800001ba:	010020ef          	jal	800021ca <myproc>
    800001be:	1f3020ef          	jal	80002bb0 <killed>
    800001c2:	e925                	bnez	a0,80000232 <consoleread+0xc2>
      sleep_prepare(&cons.r);
    800001c4:	854a                	mv	a0,s2
    800001c6:	768020ef          	jal	8000292e <sleep_prepare>
      release(&cons.lock);
    800001ca:	8526                	mv	a0,s1
    800001cc:	431000ef          	jal	80000dfc <release>
      sleep();
    800001d0:	79a020ef          	jal	8000296a <sleep>
      acquire(&cons.lock);
    800001d4:	8526                	mv	a0,s1
    800001d6:	39b000ef          	jal	80000d70 <acquire>
    while (cons.r == cons.w) {
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70ce3          	beq	a4,a5,800001ba <consoleread+0x4a>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00012717          	auipc	a4,0x12
    800001ec:	b9870713          	addi	a4,a4,-1128 # 80011d80 <cons>
    800001f0:	0017869b          	addiw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	andi	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) { // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8663          	beq	s7,a3,80000254 <consoleread+0xe4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	addi	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	479020ef          	jal	80002e92 <either_copyout>
    8000021e:	57fd                	li	a5,-1
    80000220:	04f50863          	beq	a0,a5,80000270 <consoleread+0x100>
      break;

    dst++;
    80000224:	0a05                	addi	s4,s4,1
    --n;
    80000226:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80000228:	47a9                	li	a5,10
    8000022a:	04fb8d63          	beq	s7,a5,80000284 <consoleread+0x114>
    8000022e:	6be2                	ld	s7,24(sp)
    80000230:	bfad                	j	800001aa <consoleread+0x3a>
        release(&cons.lock);
    80000232:	00012517          	auipc	a0,0x12
    80000236:	b4e50513          	addi	a0,a0,-1202 # 80011d80 <cons>
    8000023a:	3c3000ef          	jal	80000dfc <release>
        return -1;
    8000023e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000240:	60e6                	ld	ra,88(sp)
    80000242:	6446                	ld	s0,80(sp)
    80000244:	64a6                	ld	s1,72(sp)
    80000246:	6906                	ld	s2,64(sp)
    80000248:	79e2                	ld	s3,56(sp)
    8000024a:	7a42                	ld	s4,48(sp)
    8000024c:	7aa2                	ld	s5,40(sp)
    8000024e:	7b02                	ld	s6,32(sp)
    80000250:	6125                	addi	sp,sp,96
    80000252:	8082                	ret
      if (n < target) {
    80000254:	0009871b          	sext.w	a4,s3
    80000258:	01677a63          	bgeu	a4,s6,8000026c <consoleread+0xfc>
        cons.r--;
    8000025c:	00012717          	auipc	a4,0x12
    80000260:	baf72e23          	sw	a5,-1092(a4) # 80011e18 <cons+0x98>
    80000264:	6be2                	ld	s7,24(sp)
    80000266:	a031                	j	80000272 <consoleread+0x102>
    80000268:	ec5e                	sd	s7,24(sp)
    8000026a:	bfbd                	j	800001e8 <consoleread+0x78>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a011                	j	80000272 <consoleread+0x102>
    80000270:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000272:	00012517          	auipc	a0,0x12
    80000276:	b0e50513          	addi	a0,a0,-1266 # 80011d80 <cons>
    8000027a:	383000ef          	jal	80000dfc <release>
  return target - n;
    8000027e:	413b053b          	subw	a0,s6,s3
    80000282:	bf7d                	j	80000240 <consoleread+0xd0>
    80000284:	6be2                	ld	s7,24(sp)
    80000286:	b7f5                	j	80000272 <consoleread+0x102>

0000000080000288 <consputc>:
{
    80000288:	1141                	addi	sp,sp,-16
    8000028a:	e406                	sd	ra,8(sp)
    8000028c:	e022                	sd	s0,0(sp)
    8000028e:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000290:	10000793          	li	a5,256
    80000294:	00f50863          	beq	a0,a5,800002a4 <consputc+0x1c>
    uartputc_sync(c);
    80000298:	696000ef          	jal	8000092e <uartputc_sync>
}
    8000029c:	60a2                	ld	ra,8(sp)
    8000029e:	6402                	ld	s0,0(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret
    uartputc_sync('\b');
    800002a4:	4521                	li	a0,8
    800002a6:	688000ef          	jal	8000092e <uartputc_sync>
    uartputc_sync(' ');
    800002aa:	02000513          	li	a0,32
    800002ae:	680000ef          	jal	8000092e <uartputc_sync>
    uartputc_sync('\b');
    800002b2:	4521                	li	a0,8
    800002b4:	67a000ef          	jal	8000092e <uartputc_sync>
    800002b8:	b7d5                	j	8000029c <consputc+0x14>

00000000800002ba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ba:	1101                	addi	sp,sp,-32
    800002bc:	ec06                	sd	ra,24(sp)
    800002be:	e822                	sd	s0,16(sp)
    800002c0:	e426                	sd	s1,8(sp)
    800002c2:	1000                	addi	s0,sp,32
    800002c4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c6:	00012517          	auipc	a0,0x12
    800002ca:	aba50513          	addi	a0,a0,-1350 # 80011d80 <cons>
    800002ce:	2a3000ef          	jal	80000d70 <acquire>

  switch (c) {
    800002d2:	47d5                	li	a5,21
    800002d4:	08f48f63          	beq	s1,a5,80000372 <consoleintr+0xb8>
    800002d8:	0297c563          	blt	a5,s1,80000302 <consoleintr+0x48>
    800002dc:	47a1                	li	a5,8
    800002de:	0ef48463          	beq	s1,a5,800003c6 <consoleintr+0x10c>
    800002e2:	47c1                	li	a5,16
    800002e4:	10f49563          	bne	s1,a5,800003ee <consoleintr+0x134>
  case C('P'): // Print process list.
    procdump();
    800002e8:	443020ef          	jal	80002f2a <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ec:	00012517          	auipc	a0,0x12
    800002f0:	a9450513          	addi	a0,a0,-1388 # 80011d80 <cons>
    800002f4:	309000ef          	jal	80000dfc <release>
}
    800002f8:	60e2                	ld	ra,24(sp)
    800002fa:	6442                	ld	s0,16(sp)
    800002fc:	64a2                	ld	s1,8(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch (c) {
    80000302:	07f00793          	li	a5,127
    80000306:	0cf48063          	beq	s1,a5,800003c6 <consoleintr+0x10c>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030a:	00012717          	auipc	a4,0x12
    8000030e:	a7670713          	addi	a4,a4,-1418 # 80011d80 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf766e3          	bltu	a4,a5,800002ec <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x13a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	f5dff0ef          	jal	80000288 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000330:	00012797          	auipc	a5,0x12
    80000334:	a5078793          	addi	a5,a5,-1456 # 80011d80 <cons>
    80000338:	0a07a683          	lw	a3,160(a5)
    8000033c:	0016871b          	addiw	a4,a3,1
    80000340:	0007061b          	sext.w	a2,a4
    80000344:	0ae7a023          	sw	a4,160(a5)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	97b6                	add	a5,a5,a3
    8000034e:	00978c23          	sb	s1,24(a5)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	47a9                	li	a5,10
    80000354:	0cf48563          	beq	s1,a5,8000041e <consoleintr+0x164>
    80000358:	4791                	li	a5,4
    8000035a:	0cf48263          	beq	s1,a5,8000041e <consoleintr+0x164>
    8000035e:	00012797          	auipc	a5,0x12
    80000362:	aba7a783          	lw	a5,-1350(a5) # 80011e18 <cons+0x98>
    80000366:	9f1d                	subw	a4,a4,a5
    80000368:	08000793          	li	a5,128
    8000036c:	f8f710e3          	bne	a4,a5,800002ec <consoleintr+0x32>
    80000370:	a07d                	j	8000041e <consoleintr+0x164>
    80000372:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    80000374:	00012717          	auipc	a4,0x12
    80000378:	a0c70713          	addi	a4,a4,-1524 # 80011d80 <cons>
    8000037c:	0a072783          	lw	a5,160(a4)
    80000380:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000384:	00012497          	auipc	s1,0x12
    80000388:	9fc48493          	addi	s1,s1,-1540 # 80011d80 <cons>
    while (cons.e != cons.w &&
    8000038c:	4929                	li	s2,10
    8000038e:	02f70863          	beq	a4,a5,800003be <consoleintr+0x104>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	07f7f713          	andi	a4,a5,127
    80000398:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    8000039a:	01874703          	lbu	a4,24(a4)
    8000039e:	03270263          	beq	a4,s2,800003c2 <consoleintr+0x108>
      cons.e--;
    800003a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a6:	10000513          	li	a0,256
    800003aa:	edfff0ef          	jal	80000288 <consputc>
    while (cons.e != cons.w &&
    800003ae:	0a04a783          	lw	a5,160(s1)
    800003b2:	09c4a703          	lw	a4,156(s1)
    800003b6:	fcf71ee3          	bne	a4,a5,80000392 <consoleintr+0xd8>
    800003ba:	6902                	ld	s2,0(sp)
    800003bc:	bf05                	j	800002ec <consoleintr+0x32>
    800003be:	6902                	ld	s2,0(sp)
    800003c0:	b735                	j	800002ec <consoleintr+0x32>
    800003c2:	6902                	ld	s2,0(sp)
    800003c4:	b725                	j	800002ec <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003c6:	00012717          	auipc	a4,0x12
    800003ca:	9ba70713          	addi	a4,a4,-1606 # 80011d80 <cons>
    800003ce:	0a072783          	lw	a5,160(a4)
    800003d2:	09c72703          	lw	a4,156(a4)
    800003d6:	f0f70be3          	beq	a4,a5,800002ec <consoleintr+0x32>
      cons.e--;
    800003da:	37fd                	addiw	a5,a5,-1
    800003dc:	00012717          	auipc	a4,0x12
    800003e0:	a4f72223          	sw	a5,-1468(a4) # 80011e20 <cons+0xa0>
      consputc(BACKSPACE);
    800003e4:	10000513          	li	a0,256
    800003e8:	ea1ff0ef          	jal	80000288 <consputc>
    800003ec:	b701                	j	800002ec <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003ee:	ee048fe3          	beqz	s1,800002ec <consoleintr+0x32>
    800003f2:	bf21                	j	8000030a <consoleintr+0x50>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	e93ff0ef          	jal	80000288 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003fa:	00012797          	auipc	a5,0x12
    800003fe:	98678793          	addi	a5,a5,-1658 # 80011d80 <cons>
    80000402:	0a07a703          	lw	a4,160(a5)
    80000406:	0017069b          	addiw	a3,a4,1
    8000040a:	0006861b          	sext.w	a2,a3
    8000040e:	0ad7a023          	sw	a3,160(a5)
    80000412:	07f77713          	andi	a4,a4,127
    80000416:	97ba                	add	a5,a5,a4
    80000418:	4729                	li	a4,10
    8000041a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000041e:	00012797          	auipc	a5,0x12
    80000422:	9ec7af23          	sw	a2,-1538(a5) # 80011e1c <cons+0x9c>
        wakeup(&cons.r);
    80000426:	00012517          	auipc	a0,0x12
    8000042a:	9f250513          	addi	a0,a0,-1550 # 80011e18 <cons+0x98>
    8000042e:	56c020ef          	jal	8000299a <wakeup>
    80000432:	bd6d                	j	800002ec <consoleintr+0x32>

0000000080000434 <consoleinit>:

void
consoleinit(void)
{
    80000434:	1141                	addi	sp,sp,-16
    80000436:	e406                	sd	ra,8(sp)
    80000438:	e022                	sd	s0,0(sp)
    8000043a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000043c:	00009597          	auipc	a1,0x9
    80000440:	bc458593          	addi	a1,a1,-1084 # 80009000 <etext>
    80000444:	00012517          	auipc	a0,0x12
    80000448:	93c50513          	addi	a0,a0,-1732 # 80011d80 <cons>
    8000044c:	0af000ef          	jal	80000cfa <initlock>

  uartinit();
    80000450:	400000ef          	jal	80000850 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000454:	00251797          	auipc	a5,0x251
    80000458:	acc78793          	addi	a5,a5,-1332 # 80250f20 <devsw>
    8000045c:	00000717          	auipc	a4,0x0
    80000460:	d1470713          	addi	a4,a4,-748 # 80000170 <consoleread>
    80000464:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000466:	00000717          	auipc	a4,0x0
    8000046a:	c6c70713          	addi	a4,a4,-916 # 800000d2 <consolewrite>
    8000046e:	ef98                	sd	a4,24(a5)
}
    80000470:	60a2                	ld	ra,8(sp)
    80000472:	6402                	ld	s0,0(sp)
    80000474:	0141                	addi	sp,sp,16
    80000476:	8082                	ret

0000000080000478 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000478:	7139                	addi	sp,sp,-64
    8000047a:	fc06                	sd	ra,56(sp)
    8000047c:	f822                	sd	s0,48(sp)
    8000047e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000480:	c219                	beqz	a2,80000486 <printint+0xe>
    80000482:	08054063          	bltz	a0,80000502 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000486:	4881                	li	a7,0
    80000488:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000048c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000048e:	00009617          	auipc	a2,0x9
    80000492:	5a260613          	addi	a2,a2,1442 # 80009a30 <digits>
    80000496:	883e                	mv	a6,a5
    80000498:	2785                	addiw	a5,a5,1
    8000049a:	02b57733          	remu	a4,a0,a1
    8000049e:	9732                	add	a4,a4,a2
    800004a0:	00074703          	lbu	a4,0(a4)
    800004a4:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
    800004a8:	872a                	mv	a4,a0
    800004aa:	02b55533          	divu	a0,a0,a1
    800004ae:	0685                	addi	a3,a3,1
    800004b0:	feb773e3          	bgeu	a4,a1,80000496 <printint+0x1e>

  if (sign)
    800004b4:	00088a63          	beqz	a7,800004c8 <printint+0x50>
    buf[i++] = '-';
    800004b8:	1781                	addi	a5,a5,-32
    800004ba:	97a2                	add	a5,a5,s0
    800004bc:	02d00713          	li	a4,45
    800004c0:	fee78423          	sb	a4,-24(a5)
    800004c4:	0028079b          	addiw	a5,a6,2

  while (--i >= 0)
    800004c8:	02f05963          	blez	a5,800004fa <printint+0x82>
    800004cc:	f426                	sd	s1,40(sp)
    800004ce:	f04a                	sd	s2,32(sp)
    800004d0:	fc840713          	addi	a4,s0,-56
    800004d4:	00f704b3          	add	s1,a4,a5
    800004d8:	fff70913          	addi	s2,a4,-1
    800004dc:	993e                	add	s2,s2,a5
    800004de:	37fd                	addiw	a5,a5,-1
    800004e0:	1782                	slli	a5,a5,0x20
    800004e2:	9381                	srli	a5,a5,0x20
    800004e4:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004e8:	fff4c503          	lbu	a0,-1(s1)
    800004ec:	d9dff0ef          	jal	80000288 <consputc>
  while (--i >= 0)
    800004f0:	14fd                	addi	s1,s1,-1
    800004f2:	ff249be3          	bne	s1,s2,800004e8 <printint+0x70>
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
}
    800004fa:	70e2                	ld	ra,56(sp)
    800004fc:	7442                	ld	s0,48(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
    x = -xx;
    80000502:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80000506:	4885                	li	a7,1
    x = -xx;
    80000508:	b741                	j	80000488 <printint+0x10>

000000008000050a <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    8000050a:	7131                	addi	sp,sp,-192
    8000050c:	fc86                	sd	ra,120(sp)
    8000050e:	f8a2                	sd	s0,112(sp)
    80000510:	e8d2                	sd	s4,80(sp)
    80000512:	0100                	addi	s0,sp,128
    80000514:	8a2a                	mv	s4,a0
    80000516:	e40c                	sd	a1,8(s0)
    80000518:	e810                	sd	a2,16(s0)
    8000051a:	ec14                	sd	a3,24(s0)
    8000051c:	f018                	sd	a4,32(s0)
    8000051e:	f41c                	sd	a5,40(s0)
    80000520:	03043823          	sd	a6,48(s0)
    80000524:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80000528:	0000a797          	auipc	a5,0xa
    8000052c:	82c7a783          	lw	a5,-2004(a5) # 80009d54 <panicking>
    80000530:	c3a1                	beqz	a5,80000570 <printk+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000532:	00840793          	addi	a5,s0,8
    80000536:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000053a:	000a4503          	lbu	a0,0(s4)
    8000053e:	28050763          	beqz	a0,800007cc <printk+0x2c2>
    80000542:	f4a6                	sd	s1,104(sp)
    80000544:	f0ca                	sd	s2,96(sp)
    80000546:	ecce                	sd	s3,88(sp)
    80000548:	e4d6                	sd	s5,72(sp)
    8000054a:	e0da                	sd	s6,64(sp)
    8000054c:	f862                	sd	s8,48(sp)
    8000054e:	f466                	sd	s9,40(sp)
    80000550:	f06a                	sd	s10,32(sp)
    80000552:	ec6e                	sd	s11,24(sp)
    80000554:	4981                	li	s3,0
    if (cx != '%') {
    80000556:	02500a93          	li	s5,37
    c1 = c2 = 0;
    if (c0)
      c1 = fmt[i + 1] & 0xff;
    if (c1)
      c2 = fmt[i + 2] & 0xff;
    if (c0 == 'd') {
    8000055a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if (c0 == 'l' && c1 == 'd') {
    8000055e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000562:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000566:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    8000056a:	07000d93          	li	s11,112
    8000056e:	a01d                	j	80000594 <printk+0x8a>
    acquire(&pr.lock);
    80000570:	00012517          	auipc	a0,0x12
    80000574:	8b850513          	addi	a0,a0,-1864 # 80011e28 <pr>
    80000578:	7f8000ef          	jal	80000d70 <acquire>
    8000057c:	bf5d                	j	80000532 <printk+0x28>
      consputc(cx);
    8000057e:	d0bff0ef          	jal	80000288 <consputc>
      continue;
    80000582:	84ce                	mv	s1,s3
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000584:	0014899b          	addiw	s3,s1,1
    80000588:	013a07b3          	add	a5,s4,s3
    8000058c:	0007c503          	lbu	a0,0(a5)
    80000590:	20050b63          	beqz	a0,800007a6 <printk+0x29c>
    if (cx != '%') {
    80000594:	ff5515e3          	bne	a0,s5,8000057e <printk+0x74>
    i++;
    80000598:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i + 0] & 0xff;
    8000059c:	009a07b3          	add	a5,s4,s1
    800005a0:	0007c903          	lbu	s2,0(a5)
    if (c0)
    800005a4:	20090b63          	beqz	s2,800007ba <printk+0x2b0>
      c1 = fmt[i + 1] & 0xff;
    800005a8:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800005ac:	86be                	mv	a3,a5
    if (c1)
    800005ae:	c789                	beqz	a5,800005b8 <printk+0xae>
      c2 = fmt[i + 2] & 0xff;
    800005b0:	009a0733          	add	a4,s4,s1
    800005b4:	00274683          	lbu	a3,2(a4)
    if (c0 == 'd') {
    800005b8:	03690963          	beq	s2,s6,800005ea <printk+0xe0>
    } else if (c0 == 'l' && c1 == 'd') {
    800005bc:	05890363          	beq	s2,s8,80000602 <printk+0xf8>
    } else if (c0 == 'u') {
    800005c0:	0d990663          	beq	s2,s9,8000068c <printk+0x182>
    } else if (c0 == 'x') {
    800005c4:	11a90d63          	beq	s2,s10,800006de <printk+0x1d4>
    } else if (c0 == 'p') {
    800005c8:	15b90663          	beq	s2,s11,80000714 <printk+0x20a>
      printptr(va_arg(ap, uint64));
    } else if (c0 == 'c') {
    800005cc:	06300793          	li	a5,99
    800005d0:	18f90563          	beq	s2,a5,8000075a <printk+0x250>
      consputc(va_arg(ap, uint));
    } else if (c0 == 's') {
    800005d4:	07300793          	li	a5,115
    800005d8:	18f90b63          	beq	s2,a5,8000076e <printk+0x264>
      if ((s = va_arg(ap, char *)) == 0)
        s = "(null)";
      for (; *s; s++)
        consputc(*s);
    } else if (c0 == '%') {
    800005dc:	03591b63          	bne	s2,s5,80000612 <printk+0x108>
      consputc('%');
    800005e0:	02500513          	li	a0,37
    800005e4:	ca5ff0ef          	jal	80000288 <consputc>
    800005e8:	bf71                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005ea:	f8843783          	ld	a5,-120(s0)
    800005ee:	00878713          	addi	a4,a5,8
    800005f2:	f8e43423          	sd	a4,-120(s0)
    800005f6:	4605                	li	a2,1
    800005f8:	45a9                	li	a1,10
    800005fa:	4388                	lw	a0,0(a5)
    800005fc:	e7dff0ef          	jal	80000478 <printint>
    80000600:	b751                	j	80000584 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'd') {
    80000602:	01678f63          	beq	a5,s6,80000620 <printk+0x116>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80000606:	03878b63          	beq	a5,s8,8000063c <printk+0x132>
    } else if (c0 == 'l' && c1 == 'u') {
    8000060a:	09978e63          	beq	a5,s9,800006a6 <printk+0x19c>
    } else if (c0 == 'l' && c1 == 'x') {
    8000060e:	0fa78563          	beq	a5,s10,800006f8 <printk+0x1ee>
    } else if (c0 == 0) {
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000612:	8556                	mv	a0,s5
    80000614:	c75ff0ef          	jal	80000288 <consputc>
      consputc(c0);
    80000618:	854a                	mv	a0,s2
    8000061a:	c6fff0ef          	jal	80000288 <consputc>
    8000061e:	b79d                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000620:	f8843783          	ld	a5,-120(s0)
    80000624:	00878713          	addi	a4,a5,8
    80000628:	f8e43423          	sd	a4,-120(s0)
    8000062c:	4605                	li	a2,1
    8000062e:	45a9                	li	a1,10
    80000630:	6388                	ld	a0,0(a5)
    80000632:	e47ff0ef          	jal	80000478 <printint>
      i += 1;
    80000636:	0029849b          	addiw	s1,s3,2
    8000063a:	b7a9                	j	80000584 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    8000063c:	06400793          	li	a5,100
    80000640:	02f68863          	beq	a3,a5,80000670 <printk+0x166>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    80000644:	07500793          	li	a5,117
    80000648:	06f68d63          	beq	a3,a5,800006c2 <printk+0x1b8>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000064c:	07800793          	li	a5,120
    80000650:	fcf691e3          	bne	a3,a5,80000612 <printk+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80000654:	f8843783          	ld	a5,-120(s0)
    80000658:	00878713          	addi	a4,a5,8
    8000065c:	f8e43423          	sd	a4,-120(s0)
    80000660:	4601                	li	a2,0
    80000662:	45c1                	li	a1,16
    80000664:	6388                	ld	a0,0(a5)
    80000666:	e13ff0ef          	jal	80000478 <printint>
      i += 2;
    8000066a:	0039849b          	addiw	s1,s3,3
    8000066e:	bf19                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000670:	f8843783          	ld	a5,-120(s0)
    80000674:	00878713          	addi	a4,a5,8
    80000678:	f8e43423          	sd	a4,-120(s0)
    8000067c:	4605                	li	a2,1
    8000067e:	45a9                	li	a1,10
    80000680:	6388                	ld	a0,0(a5)
    80000682:	df7ff0ef          	jal	80000478 <printint>
      i += 2;
    80000686:	0039849b          	addiw	s1,s3,3
    8000068a:	bded                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45a9                	li	a1,10
    8000069c:	0007e503          	lwu	a0,0(a5)
    800006a0:	dd9ff0ef          	jal	80000478 <printint>
    800006a4:	b5c5                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	4601                	li	a2,0
    800006b4:	45a9                	li	a1,10
    800006b6:	6388                	ld	a0,0(a5)
    800006b8:	dc1ff0ef          	jal	80000478 <printint>
      i += 1;
    800006bc:	0029849b          	addiw	s1,s3,2
    800006c0:	b5d1                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006c2:	f8843783          	ld	a5,-120(s0)
    800006c6:	00878713          	addi	a4,a5,8
    800006ca:	f8e43423          	sd	a4,-120(s0)
    800006ce:	4601                	li	a2,0
    800006d0:	45a9                	li	a1,10
    800006d2:	6388                	ld	a0,0(a5)
    800006d4:	da5ff0ef          	jal	80000478 <printint>
      i += 2;
    800006d8:	0039849b          	addiw	s1,s3,3
    800006dc:	b565                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006de:	f8843783          	ld	a5,-120(s0)
    800006e2:	00878713          	addi	a4,a5,8
    800006e6:	f8e43423          	sd	a4,-120(s0)
    800006ea:	4601                	li	a2,0
    800006ec:	45c1                	li	a1,16
    800006ee:	0007e503          	lwu	a0,0(a5)
    800006f2:	d87ff0ef          	jal	80000478 <printint>
    800006f6:	b579                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006f8:	f8843783          	ld	a5,-120(s0)
    800006fc:	00878713          	addi	a4,a5,8
    80000700:	f8e43423          	sd	a4,-120(s0)
    80000704:	4601                	li	a2,0
    80000706:	45c1                	li	a1,16
    80000708:	6388                	ld	a0,0(a5)
    8000070a:	d6fff0ef          	jal	80000478 <printint>
      i += 1;
    8000070e:	0029849b          	addiw	s1,s3,2
    80000712:	bd8d                	j	80000584 <printk+0x7a>
    80000714:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000716:	f8843783          	ld	a5,-120(s0)
    8000071a:	00878713          	addi	a4,a5,8
    8000071e:	f8e43423          	sd	a4,-120(s0)
    80000722:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000726:	03000513          	li	a0,48
    8000072a:	b5fff0ef          	jal	80000288 <consputc>
  consputc('x');
    8000072e:	07800513          	li	a0,120
    80000732:	b57ff0ef          	jal	80000288 <consputc>
    80000736:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000738:	00009b97          	auipc	s7,0x9
    8000073c:	2f8b8b93          	addi	s7,s7,760 # 80009a30 <digits>
    80000740:	03c9d793          	srli	a5,s3,0x3c
    80000744:	97de                	add	a5,a5,s7
    80000746:	0007c503          	lbu	a0,0(a5)
    8000074a:	b3fff0ef          	jal	80000288 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000074e:	0992                	slli	s3,s3,0x4
    80000750:	397d                	addiw	s2,s2,-1
    80000752:	fe0917e3          	bnez	s2,80000740 <printk+0x236>
    80000756:	7be2                	ld	s7,56(sp)
    80000758:	b535                	j	80000584 <printk+0x7a>
      consputc(va_arg(ap, uint));
    8000075a:	f8843783          	ld	a5,-120(s0)
    8000075e:	00878713          	addi	a4,a5,8
    80000762:	f8e43423          	sd	a4,-120(s0)
    80000766:	4388                	lw	a0,0(a5)
    80000768:	b21ff0ef          	jal	80000288 <consputc>
    8000076c:	bd21                	j	80000584 <printk+0x7a>
      if ((s = va_arg(ap, char *)) == 0)
    8000076e:	f8843783          	ld	a5,-120(s0)
    80000772:	00878713          	addi	a4,a5,8
    80000776:	f8e43423          	sd	a4,-120(s0)
    8000077a:	0007b903          	ld	s2,0(a5)
    8000077e:	00090d63          	beqz	s2,80000798 <printk+0x28e>
      for (; *s; s++)
    80000782:	00094503          	lbu	a0,0(s2)
    80000786:	de050fe3          	beqz	a0,80000584 <printk+0x7a>
        consputc(*s);
    8000078a:	affff0ef          	jal	80000288 <consputc>
      for (; *s; s++)
    8000078e:	0905                	addi	s2,s2,1
    80000790:	00094503          	lbu	a0,0(s2)
    80000794:	f97d                	bnez	a0,8000078a <printk+0x280>
    80000796:	b3fd                	j	80000584 <printk+0x7a>
        s = "(null)";
    80000798:	00009917          	auipc	s2,0x9
    8000079c:	87090913          	addi	s2,s2,-1936 # 80009008 <etext+0x8>
      for (; *s; s++)
    800007a0:	02800513          	li	a0,40
    800007a4:	b7dd                	j	8000078a <printk+0x280>
    800007a6:	74a6                	ld	s1,104(sp)
    800007a8:	7906                	ld	s2,96(sp)
    800007aa:	69e6                	ld	s3,88(sp)
    800007ac:	6aa6                	ld	s5,72(sp)
    800007ae:	6b06                	ld	s6,64(sp)
    800007b0:	7c42                	ld	s8,48(sp)
    800007b2:	7ca2                	ld	s9,40(sp)
    800007b4:	7d02                	ld	s10,32(sp)
    800007b6:	6de2                	ld	s11,24(sp)
    800007b8:	a811                	j	800007cc <printk+0x2c2>
    800007ba:	74a6                	ld	s1,104(sp)
    800007bc:	7906                	ld	s2,96(sp)
    800007be:	69e6                	ld	s3,88(sp)
    800007c0:	6aa6                	ld	s5,72(sp)
    800007c2:	6b06                	ld	s6,64(sp)
    800007c4:	7c42                	ld	s8,48(sp)
    800007c6:	7ca2                	ld	s9,40(sp)
    800007c8:	7d02                	ld	s10,32(sp)
    800007ca:	6de2                	ld	s11,24(sp)
    }
  }
  va_end(ap);

  if (panicking == 0)
    800007cc:	00009797          	auipc	a5,0x9
    800007d0:	5887a783          	lw	a5,1416(a5) # 80009d54 <panicking>
    800007d4:	c799                	beqz	a5,800007e2 <printk+0x2d8>
    release(&pr.lock);

  return 0;
}
    800007d6:	4501                	li	a0,0
    800007d8:	70e6                	ld	ra,120(sp)
    800007da:	7446                	ld	s0,112(sp)
    800007dc:	6a46                	ld	s4,80(sp)
    800007de:	6129                	addi	sp,sp,192
    800007e0:	8082                	ret
    release(&pr.lock);
    800007e2:	00011517          	auipc	a0,0x11
    800007e6:	64650513          	addi	a0,a0,1606 # 80011e28 <pr>
    800007ea:	612000ef          	jal	80000dfc <release>
  return 0;
    800007ee:	b7e5                	j	800007d6 <printk+0x2cc>

00000000800007f0 <panic>:

void
panic(char *s)
{
    800007f0:	1101                	addi	sp,sp,-32
    800007f2:	ec06                	sd	ra,24(sp)
    800007f4:	e822                	sd	s0,16(sp)
    800007f6:	e426                	sd	s1,8(sp)
    800007f8:	e04a                	sd	s2,0(sp)
    800007fa:	1000                	addi	s0,sp,32
    800007fc:	84aa                	mv	s1,a0
  panicking = 1;
    800007fe:	4905                	li	s2,1
    80000800:	00009797          	auipc	a5,0x9
    80000804:	5527aa23          	sw	s2,1364(a5) # 80009d54 <panicking>
  printk("panic: ");
    80000808:	00009517          	auipc	a0,0x9
    8000080c:	81050513          	addi	a0,a0,-2032 # 80009018 <etext+0x18>
    80000810:	cfbff0ef          	jal	8000050a <printk>
  printk("%s\n", s);
    80000814:	85a6                	mv	a1,s1
    80000816:	00009517          	auipc	a0,0x9
    8000081a:	80a50513          	addi	a0,a0,-2038 # 80009020 <etext+0x20>
    8000081e:	cedff0ef          	jal	8000050a <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000822:	00009797          	auipc	a5,0x9
    80000826:	5327a723          	sw	s2,1326(a5) # 80009d50 <panicked>
  for (;;)
    8000082a:	a001                	j	8000082a <panic+0x3a>

000000008000082c <printkinit>:
    ;
}

void
printkinit(void)
{
    8000082c:	1141                	addi	sp,sp,-16
    8000082e:	e406                	sd	ra,8(sp)
    80000830:	e022                	sd	s0,0(sp)
    80000832:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000834:	00008597          	auipc	a1,0x8
    80000838:	7f458593          	addi	a1,a1,2036 # 80009028 <etext+0x28>
    8000083c:	00011517          	auipc	a0,0x11
    80000840:	5ec50513          	addi	a0,a0,1516 # 80011e28 <pr>
    80000844:	4b6000ef          	jal	80000cfa <initlock>
}
    80000848:	60a2                	ld	ra,8(sp)
    8000084a:	6402                	ld	s0,0(sp)
    8000084c:	0141                	addi	sp,sp,16
    8000084e:	8082                	ret

0000000080000850 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    80000850:	1141                	addi	sp,sp,-16
    80000852:	e406                	sd	ra,8(sp)
    80000854:	e022                	sd	s0,0(sp)
    80000856:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000858:	100007b7          	lui	a5,0x10000
    8000085c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000860:	10000737          	lui	a4,0x10000
    80000864:	f8000693          	li	a3,-128
    80000868:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000086c:	468d                	li	a3,3
    8000086e:	10000637          	lui	a2,0x10000
    80000872:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000876:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000087a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000087e:	10000737          	lui	a4,0x10000
    80000882:	461d                	li	a2,7
    80000884:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000888:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    8000088c:	00008597          	auipc	a1,0x8
    80000890:	7a458593          	addi	a1,a1,1956 # 80009030 <etext+0x30>
    80000894:	00011517          	auipc	a0,0x11
    80000898:	5ac50513          	addi	a0,a0,1452 # 80011e40 <tx_lock>
    8000089c:	4ef040ef          	jal	8000558a <initsleeplock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008a8:	7139                	addi	sp,sp,-64
    800008aa:	fc06                	sd	ra,56(sp)
    800008ac:	f822                	sd	s0,48(sp)
    800008ae:	f04a                	sd	s2,32(sp)
    800008b0:	e456                	sd	s5,8(sp)
    800008b2:	0080                	addi	s0,sp,64
    800008b4:	8aaa                	mv	s5,a0
    800008b6:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    800008b8:	00011517          	auipc	a0,0x11
    800008bc:	58850513          	addi	a0,a0,1416 # 80011e40 <tx_lock>
    800008c0:	501040ef          	jal	800055c0 <acquiresleep>

  int i = 0;
  while (i < n) {
    800008c4:	05205963          	blez	s2,80000916 <uartwrite+0x6e>
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	ec4e                	sd	s3,24(sp)
    800008cc:	e852                	sd	s4,16(sp)
    800008ce:	e05a                	sd	s6,0(sp)
  int i = 0;
    800008d0:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    800008d2:	00009a17          	auipc	s4,0x9
    800008d6:	486a0a13          	addi	s4,s4,1158 # 80009d58 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    800008da:	100009b7          	lui	s3,0x10000
    800008de:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    800008e0:	10000b37          	lui	s6,0x10000
    800008e4:	a811                	j	800008f8 <uartwrite+0x50>
    800008e6:	009a87b3          	add	a5,s5,s1
    800008ea:	0007c783          	lbu	a5,0(a5)
    800008ee:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    800008f2:	2485                	addiw	s1,s1,1
  while (i < n) {
    800008f4:	0124dd63          	bge	s1,s2,8000090e <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    800008f8:	8552                	mv	a0,s4
    800008fa:	034020ef          	jal	8000292e <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    800008fe:	0009c783          	lbu	a5,0(s3)
    80000902:	0207f793          	andi	a5,a5,32
    80000906:	f3e5                	bnez	a5,800008e6 <uartwrite+0x3e>
    } else {
      sleep();
    80000908:	062020ef          	jal	8000296a <sleep>
    8000090c:	b7e5                	j	800008f4 <uartwrite+0x4c>
    8000090e:	74a2                	ld	s1,40(sp)
    80000910:	69e2                	ld	s3,24(sp)
    80000912:	6a42                	ld	s4,16(sp)
    80000914:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80000916:	00011517          	auipc	a0,0x11
    8000091a:	52a50513          	addi	a0,a0,1322 # 80011e40 <tx_lock>
    8000091e:	4f7040ef          	jal	80005614 <releasesleep>
}
    80000922:	70e2                	ld	ra,56(sp)
    80000924:	7442                	ld	s0,48(sp)
    80000926:	7902                	ld	s2,32(sp)
    80000928:	6aa2                	ld	s5,8(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret

000000008000092e <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000092e:	1101                	addi	sp,sp,-32
    80000930:	ec06                	sd	ra,24(sp)
    80000932:	e822                	sd	s0,16(sp)
    80000934:	e426                	sd	s1,8(sp)
    80000936:	1000                	addi	s0,sp,32
    80000938:	84aa                	mv	s1,a0
  if (panicking == 0)
    8000093a:	00009797          	auipc	a5,0x9
    8000093e:	41a7a783          	lw	a5,1050(a5) # 80009d54 <panicking>
    80000942:	cf95                	beqz	a5,8000097e <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000944:	00009797          	auipc	a5,0x9
    80000948:	40c7a783          	lw	a5,1036(a5) # 80009d50 <panicked>
    8000094c:	ef85                	bnez	a5,80000984 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000094e:	10000737          	lui	a4,0x10000
    80000952:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000954:	00074783          	lbu	a5,0(a4)
    80000958:	0207f793          	andi	a5,a5,32
    8000095c:	dfe5                	beqz	a5,80000954 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000095e:	0ff4f513          	zext.b	a0,s1
    80000962:	100007b7          	lui	a5,0x10000
    80000966:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    8000096a:	00009797          	auipc	a5,0x9
    8000096e:	3ea7a783          	lw	a5,1002(a5) # 80009d54 <panicking>
    80000972:	cb91                	beqz	a5,80000986 <uartputc_sync+0x58>
    pop_off();
}
    80000974:	60e2                	ld	ra,24(sp)
    80000976:	6442                	ld	s0,16(sp)
    80000978:	64a2                	ld	s1,8(sp)
    8000097a:	6105                	addi	sp,sp,32
    8000097c:	8082                	ret
    push_off();
    8000097e:	3bc000ef          	jal	80000d3a <push_off>
    80000982:	b7c9                	j	80000944 <uartputc_sync+0x16>
    for (;;)
    80000984:	a001                	j	80000984 <uartputc_sync+0x56>
    pop_off();
    80000986:	42a000ef          	jal	80000db0 <pop_off>
}
    8000098a:	b7ed                	j	80000974 <uartputc_sync+0x46>

000000008000098c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000098c:	1101                	addi	sp,sp,-32
    8000098e:	ec06                	sd	ra,24(sp)
    80000990:	e822                	sd	s0,16(sp)
    80000992:	e426                	sd	s1,8(sp)
    80000994:	e04a                	sd	s2,0(sp)
    80000996:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80000998:	100007b7          	lui	a5,0x10000
    8000099c:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    8000099e:	0007c783          	lbu	a5,0(a5)

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009a8:	0007c783          	lbu	a5,0(a5)
    800009ac:	0207f793          	andi	a5,a5,32
    800009b0:	ef99                	bnez	a5,800009ce <uartintr+0x42>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009b2:	100004b7          	lui	s1,0x10000
    800009b6:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009b8:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009bc:	0004c783          	lbu	a5,0(s1)
    800009c0:	8b85                	andi	a5,a5,1
    800009c2:	cf89                	beqz	a5,800009dc <uartintr+0x50>
    return ReadReg(RHR);
    800009c4:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    800009c8:	8f3ff0ef          	jal	800002ba <consoleintr>
  while (1) {
    800009cc:	bfc5                	j	800009bc <uartintr+0x30>
    wakeup(&tx_chan);
    800009ce:	00009517          	auipc	a0,0x9
    800009d2:	38a50513          	addi	a0,a0,906 # 80009d58 <tx_chan>
    800009d6:	7c5010ef          	jal	8000299a <wakeup>
    800009da:	bfe1                	j	800009b2 <uartintr+0x26>
  }
}
    800009dc:	60e2                	ld	ra,24(sp)
    800009de:	6442                	ld	s0,16(sp)
    800009e0:	64a2                	ld	s1,8(sp)
    800009e2:	6902                	ld	s2,0(sp)
    800009e4:	6105                	addi	sp,sp,32
    800009e6:	8082                	ret

00000000800009e8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e8:	1101                	addi	sp,sp,-32
    800009ea:	ec06                	sd	ra,24(sp)
    800009ec:	e822                	sd	s0,16(sp)
    800009ee:	e426                	sd	s1,8(sp)
    800009f0:	e04a                	sd	s2,0(sp)
    800009f2:	1000                	addi	s0,sp,32
  struct run *r;
  int index;
  int count;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end ||
    800009f4:	03451793          	slli	a5,a0,0x34
    800009f8:	e3d1                	bnez	a5,80000a7c <kfree+0x94>
    800009fa:	892a                	mv	s2,a0
    800009fc:	00251797          	auipc	a5,0x251
    80000a00:	6bc78793          	addi	a5,a5,1724 # 802520b8 <end>
    80000a04:	06f56c63          	bltu	a0,a5,80000a7c <kfree+0x94>
    80000a08:	47c5                	li	a5,17
    80000a0a:	07ee                	slli	a5,a5,0x1b
    80000a0c:	06f57863          	bgeu	a0,a5,80000a7c <kfree+0x94>
     (uint64)pa >= PHYSTOP)
    panic("kfree");

  index = (uint64)pa / PGSIZE;
    80000a10:	00c55493          	srli	s1,a0,0xc
    80000a14:	2481                	sext.w	s1,s1

  acquire(&ref.lock);
    80000a16:	00011517          	auipc	a0,0x11
    80000a1a:	47a50513          	addi	a0,a0,1146 # 80011e90 <ref>
    80000a1e:	352000ef          	jal	80000d70 <acquire>
  ref.refcnt[index]--;
    80000a22:	00011517          	auipc	a0,0x11
    80000a26:	46e50513          	addi	a0,a0,1134 # 80011e90 <ref>
    80000a2a:	00448793          	addi	a5,s1,4
    80000a2e:	078a                	slli	a5,a5,0x2
    80000a30:	97aa                	add	a5,a5,a0
    80000a32:	4798                	lw	a4,8(a5)
    80000a34:	377d                	addiw	a4,a4,-1
    80000a36:	0007049b          	sext.w	s1,a4
    80000a3a:	c798                	sw	a4,8(a5)
  count = ref.refcnt[index];
  release(&ref.lock);
    80000a3c:	3c0000ef          	jal	80000dfc <release>

  if(count > 0)
    80000a40:	02904863          	bgtz	s1,80000a70 <kfree+0x88>
    return;

  if(count < 0)
    80000a44:	0404c263          	bltz	s1,80000a88 <kfree+0xa0>
    panic("kfree refcnt");

  memset(pa, 1, PGSIZE);
    80000a48:	6605                	lui	a2,0x1
    80000a4a:	4585                	li	a1,1
    80000a4c:	854a                	mv	a0,s2
    80000a4e:	3e6000ef          	jal	80000e34 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a52:	00011497          	auipc	s1,0x11
    80000a56:	41e48493          	addi	s1,s1,1054 # 80011e70 <kmem>
    80000a5a:	8526                	mv	a0,s1
    80000a5c:	314000ef          	jal	80000d70 <acquire>
  r->next = kmem.freelist;
    80000a60:	6c9c                	ld	a5,24(s1)
    80000a62:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    80000a66:	0124bc23          	sd	s2,24(s1)
  release(&kmem.lock);
    80000a6a:	8526                	mv	a0,s1
    80000a6c:	390000ef          	jal	80000dfc <release>
}
    80000a70:	60e2                	ld	ra,24(sp)
    80000a72:	6442                	ld	s0,16(sp)
    80000a74:	64a2                	ld	s1,8(sp)
    80000a76:	6902                	ld	s2,0(sp)
    80000a78:	6105                	addi	sp,sp,32
    80000a7a:	8082                	ret
    panic("kfree");
    80000a7c:	00008517          	auipc	a0,0x8
    80000a80:	5bc50513          	addi	a0,a0,1468 # 80009038 <etext+0x38>
    80000a84:	d6dff0ef          	jal	800007f0 <panic>
    panic("kfree refcnt");
    80000a88:	00008517          	auipc	a0,0x8
    80000a8c:	5b850513          	addi	a0,a0,1464 # 80009040 <etext+0x40>
    80000a90:	d61ff0ef          	jal	800007f0 <panic>

0000000080000a94 <freerange>:
{
    80000a94:	7179                	addi	sp,sp,-48
    80000a96:	f406                	sd	ra,40(sp)
    80000a98:	f022                	sd	s0,32(sp)
    80000a9a:	ec26                	sd	s1,24(sp)
    80000a9c:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a9e:	6785                	lui	a5,0x1
    80000aa0:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aa4:	00e504b3          	add	s1,a0,a4
    80000aa8:	777d                	lui	a4,0xfffff
    80000aaa:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aac:	94be                	add	s1,s1,a5
    80000aae:	0295e263          	bltu	a1,s1,80000ad2 <freerange+0x3e>
    80000ab2:	e84a                	sd	s2,16(sp)
    80000ab4:	e44e                	sd	s3,8(sp)
    80000ab6:	e052                	sd	s4,0(sp)
    80000ab8:	892e                	mv	s2,a1
    kfree(p);
    80000aba:	7a7d                	lui	s4,0xfffff
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000abc:	6985                	lui	s3,0x1
    kfree(p);
    80000abe:	01448533          	add	a0,s1,s4
    80000ac2:	f27ff0ef          	jal	800009e8 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ac6:	94ce                	add	s1,s1,s3
    80000ac8:	fe997be3          	bgeu	s2,s1,80000abe <freerange+0x2a>
    80000acc:	6942                	ld	s2,16(sp)
    80000ace:	69a2                	ld	s3,8(sp)
    80000ad0:	6a02                	ld	s4,0(sp)
}
    80000ad2:	70a2                	ld	ra,40(sp)
    80000ad4:	7402                	ld	s0,32(sp)
    80000ad6:	64e2                	ld	s1,24(sp)
    80000ad8:	6145                	addi	sp,sp,48
    80000ada:	8082                	ret

0000000080000adc <kinit>:
{
    80000adc:	1141                	addi	sp,sp,-16
    80000ade:	e406                	sd	ra,8(sp)
    80000ae0:	e022                	sd	s0,0(sp)
    80000ae2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ae4:	00008597          	auipc	a1,0x8
    80000ae8:	56c58593          	addi	a1,a1,1388 # 80009050 <etext+0x50>
    80000aec:	00011517          	auipc	a0,0x11
    80000af0:	38450513          	addi	a0,a0,900 # 80011e70 <kmem>
    80000af4:	206000ef          	jal	80000cfa <initlock>
  initlock(&ref.lock, "ref");
    80000af8:	00008597          	auipc	a1,0x8
    80000afc:	56058593          	addi	a1,a1,1376 # 80009058 <etext+0x58>
    80000b00:	00011517          	auipc	a0,0x11
    80000b04:	39050513          	addi	a0,a0,912 # 80011e90 <ref>
    80000b08:	1f2000ef          	jal	80000cfa <initlock>
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b0c:	00011797          	auipc	a5,0x11
    80000b10:	39c78793          	addi	a5,a5,924 # 80011ea8 <ref+0x18>
    80000b14:	00231697          	auipc	a3,0x231
    80000b18:	39468693          	addi	a3,a3,916 # 80231ea8 <pid_lock>
    ref.refcnt[i] = 1;
    80000b1c:	4705                	li	a4,1
    80000b1e:	c398                	sw	a4,0(a5)
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b20:	0791                	addi	a5,a5,4
    80000b22:	fed79ee3          	bne	a5,a3,80000b1e <kinit+0x42>
  freerange(end, (void*)PHYSTOP);
    80000b26:	45c5                	li	a1,17
    80000b28:	05ee                	slli	a1,a1,0x1b
    80000b2a:	00251517          	auipc	a0,0x251
    80000b2e:	58e50513          	addi	a0,a0,1422 # 802520b8 <end>
    80000b32:	f63ff0ef          	jal	80000a94 <freerange>
}
    80000b36:	60a2                	ld	ra,8(sp)
    80000b38:	6402                	ld	s0,0(sp)
    80000b3a:	0141                	addi	sp,sp,16
    80000b3c:	8082                	ret

0000000080000b3e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b3e:	1101                	addi	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b48:	00011497          	auipc	s1,0x11
    80000b4c:	32848493          	addi	s1,s1,808 # 80011e70 <kmem>
    80000b50:	8526                	mv	a0,s1
    80000b52:	21e000ef          	jal	80000d70 <acquire>
  r = kmem.freelist;
    80000b56:	6c84                	ld	s1,24(s1)
  if(r)
    80000b58:	c4b9                	beqz	s1,80000ba6 <kalloc+0x68>
    kmem.freelist = r->next;
    80000b5a:	609c                	ld	a5,0(s1)
    80000b5c:	00011517          	auipc	a0,0x11
    80000b60:	31450513          	addi	a0,a0,788 # 80011e70 <kmem>
    80000b64:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b66:	296000ef          	jal	80000dfc <release>

  if(r){
    memset((char*)r, 5, PGSIZE);
    80000b6a:	6605                	lui	a2,0x1
    80000b6c:	4595                	li	a1,5
    80000b6e:	8526                	mv	a0,s1
    80000b70:	2c4000ef          	jal	80000e34 <memset>

    acquire(&ref.lock);
    80000b74:	00011517          	auipc	a0,0x11
    80000b78:	31c50513          	addi	a0,a0,796 # 80011e90 <ref>
    80000b7c:	1f4000ef          	jal	80000d70 <acquire>
    ref.refcnt[(uint64)r / PGSIZE] = 1;
    80000b80:	00011517          	auipc	a0,0x11
    80000b84:	31050513          	addi	a0,a0,784 # 80011e90 <ref>
    80000b88:	00c4d793          	srli	a5,s1,0xc
    80000b8c:	0791                	addi	a5,a5,4
    80000b8e:	078a                	slli	a5,a5,0x2
    80000b90:	97aa                	add	a5,a5,a0
    80000b92:	4705                	li	a4,1
    80000b94:	c798                	sw	a4,8(a5)
    release(&ref.lock);
    80000b96:	266000ef          	jal	80000dfc <release>
  }

  return (void*)r;
}
    80000b9a:	8526                	mv	a0,s1
    80000b9c:	60e2                	ld	ra,24(sp)
    80000b9e:	6442                	ld	s0,16(sp)
    80000ba0:	64a2                	ld	s1,8(sp)
    80000ba2:	6105                	addi	sp,sp,32
    80000ba4:	8082                	ret
  release(&kmem.lock);
    80000ba6:	00011517          	auipc	a0,0x11
    80000baa:	2ca50513          	addi	a0,a0,714 # 80011e70 <kmem>
    80000bae:	24e000ef          	jal	80000dfc <release>
  if(r){
    80000bb2:	b7e5                	j	80000b9a <kalloc+0x5c>

0000000080000bb4 <incref>:

// Increment the reference count of a shared physical page (used by COW fork).
void
incref(void *pa)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000bbe:	03451793          	slli	a5,a0,0x34
    80000bc2:	e7b1                	bnez	a5,80000c0e <incref+0x5a>
    80000bc4:	00251797          	auipc	a5,0x251
    80000bc8:	4f478793          	addi	a5,a5,1268 # 802520b8 <end>
    80000bcc:	04f56163          	bltu	a0,a5,80000c0e <incref+0x5a>
    80000bd0:	47c5                	li	a5,17
    80000bd2:	07ee                	slli	a5,a5,0x1b
    80000bd4:	02f57d63          	bgeu	a0,a5,80000c0e <incref+0x5a>
    panic("incref");

  int index = (uint64)pa / PGSIZE;
    80000bd8:	8131                	srli	a0,a0,0xc
    80000bda:	0005049b          	sext.w	s1,a0

  acquire(&ref.lock);
    80000bde:	00011517          	auipc	a0,0x11
    80000be2:	2b250513          	addi	a0,a0,690 # 80011e90 <ref>
    80000be6:	18a000ef          	jal	80000d70 <acquire>
  ref.refcnt[index]++;
    80000bea:	00011517          	auipc	a0,0x11
    80000bee:	2a650513          	addi	a0,a0,678 # 80011e90 <ref>
    80000bf2:	00448793          	addi	a5,s1,4
    80000bf6:	078a                	slli	a5,a5,0x2
    80000bf8:	97aa                	add	a5,a5,a0
    80000bfa:	4798                	lw	a4,8(a5)
    80000bfc:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdacf49>
    80000bfe:	c798                	sw	a4,8(a5)
  release(&ref.lock);
    80000c00:	1fc000ef          	jal	80000dfc <release>
}
    80000c04:	60e2                	ld	ra,24(sp)
    80000c06:	6442                	ld	s0,16(sp)
    80000c08:	64a2                	ld	s1,8(sp)
    80000c0a:	6105                	addi	sp,sp,32
    80000c0c:	8082                	ret
    panic("incref");
    80000c0e:	00008517          	auipc	a0,0x8
    80000c12:	45250513          	addi	a0,a0,1106 # 80009060 <etext+0x60>
    80000c16:	bdbff0ef          	jal	800007f0 <panic>

0000000080000c1a <getref>:

// Read the current reference count of a physical page.
int
getref(void *pa)
{
    80000c1a:	1101                	addi	sp,sp,-32
    80000c1c:	ec06                	sd	ra,24(sp)
    80000c1e:	e822                	sd	s0,16(sp)
    80000c20:	e426                	sd	s1,8(sp)
    80000c22:	1000                	addi	s0,sp,32
  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000c24:	03451793          	slli	a5,a0,0x34
    80000c28:	e7a9                	bnez	a5,80000c72 <getref+0x58>
    80000c2a:	84aa                	mv	s1,a0
    80000c2c:	00251797          	auipc	a5,0x251
    80000c30:	48c78793          	addi	a5,a5,1164 # 802520b8 <end>
    80000c34:	02f56f63          	bltu	a0,a5,80000c72 <getref+0x58>
    80000c38:	47c5                	li	a5,17
    80000c3a:	07ee                	slli	a5,a5,0x1b
    80000c3c:	02f57b63          	bgeu	a0,a5,80000c72 <getref+0x58>
    panic("getref");

  int index = (uint64)pa / PGSIZE;
  int count;

  acquire(&ref.lock);
    80000c40:	00011517          	auipc	a0,0x11
    80000c44:	25050513          	addi	a0,a0,592 # 80011e90 <ref>
    80000c48:	128000ef          	jal	80000d70 <acquire>
  count = ref.refcnt[index];
    80000c4c:	00011517          	auipc	a0,0x11
    80000c50:	24450513          	addi	a0,a0,580 # 80011e90 <ref>
  int index = (uint64)pa / PGSIZE;
    80000c54:	00c4d793          	srli	a5,s1,0xc
  count = ref.refcnt[index];
    80000c58:	2781                	sext.w	a5,a5
    80000c5a:	0791                	addi	a5,a5,4
    80000c5c:	078a                	slli	a5,a5,0x2
    80000c5e:	97aa                	add	a5,a5,a0
    80000c60:	4784                	lw	s1,8(a5)
  release(&ref.lock);
    80000c62:	19a000ef          	jal	80000dfc <release>

  return count;
}
    80000c66:	8526                	mv	a0,s1
    80000c68:	60e2                	ld	ra,24(sp)
    80000c6a:	6442                	ld	s0,16(sp)
    80000c6c:	64a2                	ld	s1,8(sp)
    80000c6e:	6105                	addi	sp,sp,32
    80000c70:	8082                	ret
    panic("getref");
    80000c72:	00008517          	auipc	a0,0x8
    80000c76:	3f650513          	addi	a0,a0,1014 # 80009068 <etext+0x68>
    80000c7a:	b77ff0ef          	jal	800007f0 <panic>

0000000080000c7e <decref>:

// Drop one reference to a physical page (frees it automatically if count hits 0).
void
decref(void *pa)
{
    80000c7e:	1141                	addi	sp,sp,-16
    80000c80:	e406                	sd	ra,8(sp)
    80000c82:	e022                	sd	s0,0(sp)
    80000c84:	0800                	addi	s0,sp,16
  kfree(pa);
    80000c86:	d63ff0ef          	jal	800009e8 <kfree>
}
    80000c8a:	60a2                	ld	ra,8(sp)
    80000c8c:	6402                	ld	s0,0(sp)
    80000c8e:	0141                	addi	sp,sp,16
    80000c90:	8082                	ret

0000000080000c92 <kfreemem>:

uint64
kfreemem(void)
{
    80000c92:	1101                	addi	sp,sp,-32
    80000c94:	ec06                	sd	ra,24(sp)
    80000c96:	e822                	sd	s0,16(sp)
    80000c98:	e426                	sd	s1,8(sp)
    80000c9a:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 free_bytes = 0;

  acquire(&kmem.lock);
    80000c9c:	00011497          	auipc	s1,0x11
    80000ca0:	1d448493          	addi	s1,s1,468 # 80011e70 <kmem>
    80000ca4:	8526                	mv	a0,s1
    80000ca6:	0ca000ef          	jal	80000d70 <acquire>
  for(r = kmem.freelist; r != 0; r = r->next)
    80000caa:	6c9c                	ld	a5,24(s1)
    80000cac:	c395                	beqz	a5,80000cd0 <kfreemem+0x3e>
  uint64 free_bytes = 0;
    80000cae:	4481                	li	s1,0
    free_bytes += PGSIZE;
    80000cb0:	6705                	lui	a4,0x1
    80000cb2:	94ba                	add	s1,s1,a4
  for(r = kmem.freelist; r != 0; r = r->next)
    80000cb4:	639c                	ld	a5,0(a5)
    80000cb6:	fff5                	bnez	a5,80000cb2 <kfreemem+0x20>
  release(&kmem.lock);
    80000cb8:	00011517          	auipc	a0,0x11
    80000cbc:	1b850513          	addi	a0,a0,440 # 80011e70 <kmem>
    80000cc0:	13c000ef          	jal	80000dfc <release>

  return free_bytes;
}
    80000cc4:	8526                	mv	a0,s1
    80000cc6:	60e2                	ld	ra,24(sp)
    80000cc8:	6442                	ld	s0,16(sp)
    80000cca:	64a2                	ld	s1,8(sp)
    80000ccc:	6105                	addi	sp,sp,32
    80000cce:	8082                	ret
  uint64 free_bytes = 0;
    80000cd0:	4481                	li	s1,0
    80000cd2:	b7dd                	j	80000cb8 <kfreemem+0x26>

0000000080000cd4 <ktotalmem>:

uint64
ktotalmem(void)
{
    80000cd4:	1141                	addi	sp,sp,-16
    80000cd6:	e422                	sd	s0,8(sp)
    80000cd8:	0800                	addi	s0,sp,16
  uint64 start = PGROUNDUP((uint64)end);
    80000cda:	00252797          	auipc	a5,0x252
    80000cde:	3dd78793          	addi	a5,a5,989 # 802530b7 <end+0xfff>
    80000ce2:	777d                	lui	a4,0xfffff
    80000ce4:	8ff9                	and	a5,a5,a4
  if(PHYSTOP <= start)
    80000ce6:	4745                	li	a4,17
    80000ce8:	076e                	slli	a4,a4,0x1b
    return 0;
    80000cea:	4501                	li	a0,0
  if(PHYSTOP <= start)
    80000cec:	00e7f463          	bgeu	a5,a4,80000cf4 <ktotalmem+0x20>
  return PHYSTOP - start;
    80000cf0:	40f70533          	sub	a0,a4,a5
}
    80000cf4:	6422                	ld	s0,8(sp)
    80000cf6:	0141                	addi	sp,sp,16
    80000cf8:	8082                	ret

0000000080000cfa <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e422                	sd	s0,8(sp)
    80000cfe:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d00:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d02:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d06:	00053823          	sd	zero,16(a0)
}
    80000d0a:	6422                	ld	s0,8(sp)
    80000d0c:	0141                	addi	sp,sp,16
    80000d0e:	8082                	ret

0000000080000d10 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d10:	411c                	lw	a5,0(a0)
    80000d12:	e399                	bnez	a5,80000d18 <holding+0x8>
    80000d14:	4501                	li	a0,0
  return r;
}
    80000d16:	8082                	ret
{
    80000d18:	1101                	addi	sp,sp,-32
    80000d1a:	ec06                	sd	ra,24(sp)
    80000d1c:	e822                	sd	s0,16(sp)
    80000d1e:	e426                	sd	s1,8(sp)
    80000d20:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d22:	6904                	ld	s1,16(a0)
    80000d24:	48a010ef          	jal	800021ae <mycpu>
    80000d28:	40a48533          	sub	a0,s1,a0
    80000d2c:	00153513          	seqz	a0,a0
}
    80000d30:	60e2                	ld	ra,24(sp)
    80000d32:	6442                	ld	s0,16(sp)
    80000d34:	64a2                	ld	s1,8(sp)
    80000d36:	6105                	addi	sp,sp,32
    80000d38:	8082                	ret

0000000080000d3a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d3a:	1101                	addi	sp,sp,-32
    80000d3c:	ec06                	sd	ra,24(sp)
    80000d3e:	e822                	sd	s0,16(sp)
    80000d40:	e426                	sd	s1,8(sp)
    80000d42:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000d44:	100174f3          	csrrci	s1,sstatus,2
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000d48:	466010ef          	jal	800021ae <mycpu>
    80000d4c:	5d3c                	lw	a5,120(a0)
    80000d4e:	cb99                	beqz	a5,80000d64 <push_off+0x2a>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d50:	45e010ef          	jal	800021ae <mycpu>
    80000d54:	5d3c                	lw	a5,120(a0)
    80000d56:	2785                	addiw	a5,a5,1
    80000d58:	dd3c                	sw	a5,120(a0)
}
    80000d5a:	60e2                	ld	ra,24(sp)
    80000d5c:	6442                	ld	s0,16(sp)
    80000d5e:	64a2                	ld	s1,8(sp)
    80000d60:	6105                	addi	sp,sp,32
    80000d62:	8082                	ret
    mycpu()->intena = old;
    80000d64:	44a010ef          	jal	800021ae <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000d68:	8085                	srli	s1,s1,0x1
    80000d6a:	8885                	andi	s1,s1,1
    mycpu()->intena = old;
    80000d6c:	dd64                	sw	s1,124(a0)
    80000d6e:	b7cd                	j	80000d50 <push_off+0x16>

0000000080000d70 <acquire>:
{
    80000d70:	1101                	addi	sp,sp,-32
    80000d72:	ec06                	sd	ra,24(sp)
    80000d74:	e822                	sd	s0,16(sp)
    80000d76:	e426                	sd	s1,8(sp)
    80000d78:	1000                	addi	s0,sp,32
    80000d7a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d7c:	fbfff0ef          	jal	80000d3a <push_off>
  if (holding(lk))
    80000d80:	8526                	mv	a0,s1
    80000d82:	f8fff0ef          	jal	80000d10 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000d86:	4705                	li	a4,1
  if (holding(lk))
    80000d88:	ed11                	bnez	a0,80000da4 <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000d8a:	87ba                	mv	a5,a4
    80000d8c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d90:	2781                	sext.w	a5,a5
    80000d92:	ffe5                	bnez	a5,80000d8a <acquire+0x1a>
  lk->cpu = mycpu();
    80000d94:	41a010ef          	jal	800021ae <mycpu>
    80000d98:	e888                	sd	a0,16(s1)
}
    80000d9a:	60e2                	ld	ra,24(sp)
    80000d9c:	6442                	ld	s0,16(sp)
    80000d9e:	64a2                	ld	s1,8(sp)
    80000da0:	6105                	addi	sp,sp,32
    80000da2:	8082                	ret
    panic("acquire");
    80000da4:	00008517          	auipc	a0,0x8
    80000da8:	2cc50513          	addi	a0,a0,716 # 80009070 <etext+0x70>
    80000dac:	a45ff0ef          	jal	800007f0 <panic>

0000000080000db0 <pop_off>:

void
pop_off(void)
{
    80000db0:	1141                	addi	sp,sp,-16
    80000db2:	e406                	sd	ra,8(sp)
    80000db4:	e022                	sd	s0,0(sp)
    80000db6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000db8:	3f6010ef          	jal	800021ae <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000dbc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000dc0:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000dc2:	e38d                	bnez	a5,80000de4 <pop_off+0x34>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000dc4:	5d3c                	lw	a5,120(a0)
    80000dc6:	02f05563          	blez	a5,80000df0 <pop_off+0x40>
    panic("pop_off");
  c->noff -= 1;
    80000dca:	37fd                	addiw	a5,a5,-1
    80000dcc:	0007871b          	sext.w	a4,a5
    80000dd0:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000dd2:	e709                	bnez	a4,80000ddc <pop_off+0x2c>
    80000dd4:	5d7c                	lw	a5,124(a0)
    80000dd6:	c399                	beqz	a5,80000ddc <pop_off+0x2c>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000dd8:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000ddc:	60a2                	ld	ra,8(sp)
    80000dde:	6402                	ld	s0,0(sp)
    80000de0:	0141                	addi	sp,sp,16
    80000de2:	8082                	ret
    panic("pop_off - interruptible");
    80000de4:	00008517          	auipc	a0,0x8
    80000de8:	29450513          	addi	a0,a0,660 # 80009078 <etext+0x78>
    80000dec:	a05ff0ef          	jal	800007f0 <panic>
    panic("pop_off");
    80000df0:	00008517          	auipc	a0,0x8
    80000df4:	2a050513          	addi	a0,a0,672 # 80009090 <etext+0x90>
    80000df8:	9f9ff0ef          	jal	800007f0 <panic>

0000000080000dfc <release>:
{
    80000dfc:	1101                	addi	sp,sp,-32
    80000dfe:	ec06                	sd	ra,24(sp)
    80000e00:	e822                	sd	s0,16(sp)
    80000e02:	e426                	sd	s1,8(sp)
    80000e04:	1000                	addi	s0,sp,32
    80000e06:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000e08:	f09ff0ef          	jal	80000d10 <holding>
    80000e0c:	cd11                	beqz	a0,80000e28 <release+0x2c>
  lk->cpu = 0;
    80000e0e:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000e12:	0f50000f          	fence	iorw,ow
    80000e16:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e1a:	f97ff0ef          	jal	80000db0 <pop_off>
}
    80000e1e:	60e2                	ld	ra,24(sp)
    80000e20:	6442                	ld	s0,16(sp)
    80000e22:	64a2                	ld	s1,8(sp)
    80000e24:	6105                	addi	sp,sp,32
    80000e26:	8082                	ret
    panic("release");
    80000e28:	00008517          	auipc	a0,0x8
    80000e2c:	27050513          	addi	a0,a0,624 # 80009098 <etext+0x98>
    80000e30:	9c1ff0ef          	jal	800007f0 <panic>

0000000080000e34 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000e34:	1141                	addi	sp,sp,-16
    80000e36:	e422                	sd	s0,8(sp)
    80000e38:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000e3a:	ca19                	beqz	a2,80000e50 <memset+0x1c>
    80000e3c:	87aa                	mv	a5,a0
    80000e3e:	1602                	slli	a2,a2,0x20
    80000e40:	9201                	srli	a2,a2,0x20
    80000e42:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e46:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fee79de3          	bne	a5,a4,80000e46 <memset+0x12>
  }
  return dst;
}
    80000e50:	6422                	ld	s0,8(sp)
    80000e52:	0141                	addi	sp,sp,16
    80000e54:	8082                	ret

0000000080000e56 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e56:	1141                	addi	sp,sp,-16
    80000e58:	e422                	sd	s0,8(sp)
    80000e5a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000e5c:	ca05                	beqz	a2,80000e8c <memcmp+0x36>
    80000e5e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e62:	1682                	slli	a3,a3,0x20
    80000e64:	9281                	srli	a3,a3,0x20
    80000e66:	0685                	addi	a3,a3,1
    80000e68:	96aa                	add	a3,a3,a0
    if (*s1 != *s2)
    80000e6a:	00054783          	lbu	a5,0(a0)
    80000e6e:	0005c703          	lbu	a4,0(a1)
    80000e72:	00e79863          	bne	a5,a4,80000e82 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e76:	0505                	addi	a0,a0,1
    80000e78:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000e7a:	fed518e3          	bne	a0,a3,80000e6a <memcmp+0x14>
  }

  return 0;
    80000e7e:	4501                	li	a0,0
    80000e80:	a019                	j	80000e86 <memcmp+0x30>
      return *s1 - *s2;
    80000e82:	40e7853b          	subw	a0,a5,a4
}
    80000e86:	6422                	ld	s0,8(sp)
    80000e88:	0141                	addi	sp,sp,16
    80000e8a:	8082                	ret
  return 0;
    80000e8c:	4501                	li	a0,0
    80000e8e:	bfe5                	j	80000e86 <memcmp+0x30>

0000000080000e90 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e422                	sd	s0,8(sp)
    80000e94:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000e96:	c205                	beqz	a2,80000eb6 <memmove+0x26>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000e98:	02a5e263          	bltu	a1,a0,80000ebc <memmove+0x2c>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000e9c:	1602                	slli	a2,a2,0x20
    80000e9e:	9201                	srli	a2,a2,0x20
    80000ea0:	00c587b3          	add	a5,a1,a2
{
    80000ea4:	872a                	mv	a4,a0
      *d++ = *s++;
    80000ea6:	0585                	addi	a1,a1,1
    80000ea8:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdacf49>
    80000eaa:	fff5c683          	lbu	a3,-1(a1)
    80000eae:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000eb2:	feb79ae3          	bne	a5,a1,80000ea6 <memmove+0x16>

  return dst;
}
    80000eb6:	6422                	ld	s0,8(sp)
    80000eb8:	0141                	addi	sp,sp,16
    80000eba:	8082                	ret
  if (s < d && s + n > d) {
    80000ebc:	02061693          	slli	a3,a2,0x20
    80000ec0:	9281                	srli	a3,a3,0x20
    80000ec2:	00d58733          	add	a4,a1,a3
    80000ec6:	fce57be3          	bgeu	a0,a4,80000e9c <memmove+0xc>
    d += n;
    80000eca:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000ecc:	fff6079b          	addiw	a5,a2,-1
    80000ed0:	1782                	slli	a5,a5,0x20
    80000ed2:	9381                	srli	a5,a5,0x20
    80000ed4:	fff7c793          	not	a5,a5
    80000ed8:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eda:	177d                	addi	a4,a4,-1
    80000edc:	16fd                	addi	a3,a3,-1
    80000ede:	00074603          	lbu	a2,0(a4)
    80000ee2:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000ee6:	fef71ae3          	bne	a4,a5,80000eda <memmove+0x4a>
    80000eea:	b7f1                	j	80000eb6 <memmove+0x26>

0000000080000eec <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000eec:	1141                	addi	sp,sp,-16
    80000eee:	e406                	sd	ra,8(sp)
    80000ef0:	e022                	sd	s0,0(sp)
    80000ef2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ef4:	f9dff0ef          	jal	80000e90 <memmove>
}
    80000ef8:	60a2                	ld	ra,8(sp)
    80000efa:	6402                	ld	s0,0(sp)
    80000efc:	0141                	addi	sp,sp,16
    80000efe:	8082                	ret

0000000080000f00 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f00:	1141                	addi	sp,sp,-16
    80000f02:	e422                	sd	s0,8(sp)
    80000f04:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000f06:	ce11                	beqz	a2,80000f22 <strncmp+0x22>
    80000f08:	00054783          	lbu	a5,0(a0)
    80000f0c:	cf89                	beqz	a5,80000f26 <strncmp+0x26>
    80000f0e:	0005c703          	lbu	a4,0(a1)
    80000f12:	00f71a63          	bne	a4,a5,80000f26 <strncmp+0x26>
    n--, p++, q++;
    80000f16:	367d                	addiw	a2,a2,-1
    80000f18:	0505                	addi	a0,a0,1
    80000f1a:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000f1c:	f675                	bnez	a2,80000f08 <strncmp+0x8>
  if (n == 0)
    return 0;
    80000f1e:	4501                	li	a0,0
    80000f20:	a801                	j	80000f30 <strncmp+0x30>
    80000f22:	4501                	li	a0,0
    80000f24:	a031                	j	80000f30 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000f26:	00054503          	lbu	a0,0(a0)
    80000f2a:	0005c783          	lbu	a5,0(a1)
    80000f2e:	9d1d                	subw	a0,a0,a5
}
    80000f30:	6422                	ld	s0,8(sp)
    80000f32:	0141                	addi	sp,sp,16
    80000f34:	8082                	ret

0000000080000f36 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000f36:	1141                	addi	sp,sp,-16
    80000f38:	e422                	sd	s0,8(sp)
    80000f3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000f3c:	87aa                	mv	a5,a0
    80000f3e:	86b2                	mv	a3,a2
    80000f40:	367d                	addiw	a2,a2,-1
    80000f42:	02d05563          	blez	a3,80000f6c <strncpy+0x36>
    80000f46:	0785                	addi	a5,a5,1
    80000f48:	0005c703          	lbu	a4,0(a1)
    80000f4c:	fee78fa3          	sb	a4,-1(a5)
    80000f50:	0585                	addi	a1,a1,1
    80000f52:	f775                	bnez	a4,80000f3e <strncpy+0x8>
    ;
  while (n-- > 0)
    80000f54:	873e                	mv	a4,a5
    80000f56:	9fb5                	addw	a5,a5,a3
    80000f58:	37fd                	addiw	a5,a5,-1
    80000f5a:	00c05963          	blez	a2,80000f6c <strncpy+0x36>
    *s++ = 0;
    80000f5e:	0705                	addi	a4,a4,1
    80000f60:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000f64:	40e786bb          	subw	a3,a5,a4
    80000f68:	fed04be3          	bgtz	a3,80000f5e <strncpy+0x28>
  return os;
}
    80000f6c:	6422                	ld	s0,8(sp)
    80000f6e:	0141                	addi	sp,sp,16
    80000f70:	8082                	ret

0000000080000f72 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000f72:	1141                	addi	sp,sp,-16
    80000f74:	e422                	sd	s0,8(sp)
    80000f76:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000f78:	02c05363          	blez	a2,80000f9e <safestrcpy+0x2c>
    80000f7c:	fff6069b          	addiw	a3,a2,-1
    80000f80:	1682                	slli	a3,a3,0x20
    80000f82:	9281                	srli	a3,a3,0x20
    80000f84:	96ae                	add	a3,a3,a1
    80000f86:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000f88:	00d58963          	beq	a1,a3,80000f9a <safestrcpy+0x28>
    80000f8c:	0585                	addi	a1,a1,1
    80000f8e:	0785                	addi	a5,a5,1
    80000f90:	fff5c703          	lbu	a4,-1(a1)
    80000f94:	fee78fa3          	sb	a4,-1(a5)
    80000f98:	fb65                	bnez	a4,80000f88 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f9a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f9e:	6422                	ld	s0,8(sp)
    80000fa0:	0141                	addi	sp,sp,16
    80000fa2:	8082                	ret

0000000080000fa4 <strlen>:

int
strlen(const char *s)
{
    80000fa4:	1141                	addi	sp,sp,-16
    80000fa6:	e422                	sd	s0,8(sp)
    80000fa8:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000faa:	00054783          	lbu	a5,0(a0)
    80000fae:	cf91                	beqz	a5,80000fca <strlen+0x26>
    80000fb0:	0505                	addi	a0,a0,1
    80000fb2:	87aa                	mv	a5,a0
    80000fb4:	86be                	mv	a3,a5
    80000fb6:	0785                	addi	a5,a5,1
    80000fb8:	fff7c703          	lbu	a4,-1(a5)
    80000fbc:	ff65                	bnez	a4,80000fb4 <strlen+0x10>
    80000fbe:	40a6853b          	subw	a0,a3,a0
    80000fc2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000fc4:	6422                	ld	s0,8(sp)
    80000fc6:	0141                	addi	sp,sp,16
    80000fc8:	8082                	ret
  for (n = 0; s[n]; n++)
    80000fca:	4501                	li	a0,0
    80000fcc:	bfe5                	j	80000fc4 <strlen+0x20>

0000000080000fce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fce:	1141                	addi	sp,sp,-16
    80000fd0:	e406                	sd	ra,8(sp)
    80000fd2:	e022                	sd	s0,0(sp)
    80000fd4:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000fd6:	1c8010ef          	jal	8000219e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000fda:	00009717          	auipc	a4,0x9
    80000fde:	d8270713          	addi	a4,a4,-638 # 80009d5c <started>
  if (cpuid() == 0) {
    80000fe2:	c51d                	beqz	a0,80001010 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000fe4:	431c                	lw	a5,0(a4)
    80000fe6:	0ff0000f          	fence
    80000fea:	2781                	sext.w	a5,a5
    80000fec:	dfe5                	beqz	a5,80000fe4 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000fee:	1b0010ef          	jal	8000219e <cpuid>
    80000ff2:	85aa                	mv	a1,a0
    80000ff4:	00008517          	auipc	a0,0x8
    80000ff8:	0cc50513          	addi	a0,a0,204 # 800090c0 <etext+0xc0>
    80000ffc:	d0eff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80001000:	084000ef          	jal	80001084 <kvminithart>
    trapinithart(); // install kernel trap vector
    80001004:	4a0020ef          	jal	800034a4 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80001008:	421050ef          	jal	80006c28 <plicinithart>
  }

  scheduler();
    8000100c:	70e010ef          	jal	8000271a <scheduler>
    consoleinit();
    80001010:	c24ff0ef          	jal	80000434 <consoleinit>
    printkinit();
    80001014:	819ff0ef          	jal	8000082c <printkinit>
    printk("\n");
    80001018:	00008517          	auipc	a0,0x8
    8000101c:	08850513          	addi	a0,a0,136 # 800090a0 <etext+0xa0>
    80001020:	ceaff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80001024:	00008517          	auipc	a0,0x8
    80001028:	08450513          	addi	a0,a0,132 # 800090a8 <etext+0xa8>
    8000102c:	cdeff0ef          	jal	8000050a <printk>
    printk("\n");
    80001030:	00008517          	auipc	a0,0x8
    80001034:	07050513          	addi	a0,a0,112 # 800090a0 <etext+0xa0>
    80001038:	cd2ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    8000103c:	aa1ff0ef          	jal	80000adc <kinit>
    kvminit();          // create kernel page table
    80001040:	2e0000ef          	jal	80001320 <kvminit>
    kvminithart();      // turn on paging
    80001044:	040000ef          	jal	80001084 <kvminithart>
    procinit();         // process table
    80001048:	0a0010ef          	jal	800020e8 <procinit>
    trapinit();         // trap vectors
    8000104c:	434020ef          	jal	80003480 <trapinit>
    trapinithart();     // install kernel trap vector
    80001050:	454020ef          	jal	800034a4 <trapinithart>
    plicinit();         // set up interrupt controller
    80001054:	3bb050ef          	jal	80006c0e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80001058:	3d1050ef          	jal	80006c28 <plicinithart>
    binit();            // buffer cache
    8000105c:	0bc030ef          	jal	80004118 <binit>
    iinit();            // inode table
    80001060:	642030ef          	jal	800046a2 <iinit>
    fileinit();         // file table
    80001064:	632040ef          	jal	80005696 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001068:	4b1050ef          	jal	80006d18 <virtio_disk_init>
    userinit();         // first user process
    8000106c:	48c010ef          	jal	800024f8 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80001070:	00009797          	auipc	a5,0x9
    80001074:	cec78793          	addi	a5,a5,-788 # 80009d5c <started>
    80001078:	4705                	li	a4,1
    8000107a:	0f50000f          	fence	iorw,ow
    8000107e:	08e7a02f          	amoswap.w	zero,a4,(a5)
    80001082:	b769                	j	8000100c <main+0x3e>

0000000080001084 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80001084:	1141                	addi	sp,sp,-16
    80001086:	e422                	sd	s0,8(sp)
    80001088:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    8000108a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000108e:	00009797          	auipc	a5,0x9
    80001092:	cd27b783          	ld	a5,-814(a5) # 80009d60 <kernel_pagetable>
    80001096:	83b1                	srli	a5,a5,0xc
    80001098:	577d                	li	a4,-1
    8000109a:	177e                	slli	a4,a4,0x3f
    8000109c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    8000109e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    800010a2:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800010a6:	6422                	ld	s0,8(sp)
    800010a8:	0141                	addi	sp,sp,16
    800010aa:	8082                	ret

00000000800010ac <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800010ac:	7139                	addi	sp,sp,-64
    800010ae:	fc06                	sd	ra,56(sp)
    800010b0:	f822                	sd	s0,48(sp)
    800010b2:	f426                	sd	s1,40(sp)
    800010b4:	f04a                	sd	s2,32(sp)
    800010b6:	ec4e                	sd	s3,24(sp)
    800010b8:	e852                	sd	s4,16(sp)
    800010ba:	e456                	sd	s5,8(sp)
    800010bc:	e05a                	sd	s6,0(sp)
    800010be:	0080                	addi	s0,sp,64
    800010c0:	84aa                	mv	s1,a0
    800010c2:	89ae                	mv	s3,a1
    800010c4:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800010c6:	57fd                	li	a5,-1
    800010c8:	83e9                	srli	a5,a5,0x1a
    800010ca:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    800010cc:	4b31                	li	s6,12
  if (va >= MAXVA)
    800010ce:	02b7fc63          	bgeu	a5,a1,80001106 <walk+0x5a>
    panic("walk");
    800010d2:	00008517          	auipc	a0,0x8
    800010d6:	00650513          	addi	a0,a0,6 # 800090d8 <etext+0xd8>
    800010da:	f16ff0ef          	jal	800007f0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800010de:	060a8263          	beqz	s5,80001142 <walk+0x96>
    800010e2:	a5dff0ef          	jal	80000b3e <kalloc>
    800010e6:	84aa                	mv	s1,a0
    800010e8:	c139                	beqz	a0,8000112e <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010ea:	6605                	lui	a2,0x1
    800010ec:	4581                	li	a1,0
    800010ee:	d47ff0ef          	jal	80000e34 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010f2:	00c4d793          	srli	a5,s1,0xc
    800010f6:	07aa                	slli	a5,a5,0xa
    800010f8:	0017e793          	ori	a5,a5,1
    800010fc:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80001100:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fdacf3f>
    80001102:	036a0063          	beq	s4,s6,80001122 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80001106:	0149d933          	srl	s2,s3,s4
    8000110a:	1ff97913          	andi	s2,s2,511
    8000110e:	090e                	slli	s2,s2,0x3
    80001110:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80001112:	00093483          	ld	s1,0(s2)
    80001116:	0014f793          	andi	a5,s1,1
    8000111a:	d3f1                	beqz	a5,800010de <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000111c:	80a9                	srli	s1,s1,0xa
    8000111e:	04b2                	slli	s1,s1,0xc
    80001120:	b7c5                	j	80001100 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80001122:	00c9d513          	srli	a0,s3,0xc
    80001126:	1ff57513          	andi	a0,a0,511
    8000112a:	050e                	slli	a0,a0,0x3
    8000112c:	9526                	add	a0,a0,s1
}
    8000112e:	70e2                	ld	ra,56(sp)
    80001130:	7442                	ld	s0,48(sp)
    80001132:	74a2                	ld	s1,40(sp)
    80001134:	7902                	ld	s2,32(sp)
    80001136:	69e2                	ld	s3,24(sp)
    80001138:	6a42                	ld	s4,16(sp)
    8000113a:	6aa2                	ld	s5,8(sp)
    8000113c:	6b02                	ld	s6,0(sp)
    8000113e:	6121                	addi	sp,sp,64
    80001140:	8082                	ret
        return 0;
    80001142:	4501                	li	a0,0
    80001144:	b7ed                	j	8000112e <walk+0x82>

0000000080001146 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001146:	57fd                	li	a5,-1
    80001148:	83e9                	srli	a5,a5,0x1a
    8000114a:	00b7f463          	bgeu	a5,a1,80001152 <walkaddr+0xc>
    return 0;
    8000114e:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001150:	8082                	ret
{
    80001152:	1141                	addi	sp,sp,-16
    80001154:	e406                	sd	ra,8(sp)
    80001156:	e022                	sd	s0,0(sp)
    80001158:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000115a:	4601                	li	a2,0
    8000115c:	f51ff0ef          	jal	800010ac <walk>
  if (pte == 0)
    80001160:	c105                	beqz	a0,80001180 <walkaddr+0x3a>
  if ((*pte & PTE_V) == 0)
    80001162:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80001164:	0117f693          	andi	a3,a5,17
    80001168:	4745                	li	a4,17
    return 0;
    8000116a:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    8000116c:	00e68663          	beq	a3,a4,80001178 <walkaddr+0x32>
}
    80001170:	60a2                	ld	ra,8(sp)
    80001172:	6402                	ld	s0,0(sp)
    80001174:	0141                	addi	sp,sp,16
    80001176:	8082                	ret
  pa = PTE2PA(*pte);
    80001178:	83a9                	srli	a5,a5,0xa
    8000117a:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000117e:	bfcd                	j	80001170 <walkaddr+0x2a>
    return 0;
    80001180:	4501                	li	a0,0
    80001182:	b7fd                	j	80001170 <walkaddr+0x2a>

0000000080001184 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001184:	715d                	addi	sp,sp,-80
    80001186:	e486                	sd	ra,72(sp)
    80001188:	e0a2                	sd	s0,64(sp)
    8000118a:	fc26                	sd	s1,56(sp)
    8000118c:	f84a                	sd	s2,48(sp)
    8000118e:	f44e                	sd	s3,40(sp)
    80001190:	f052                	sd	s4,32(sp)
    80001192:	ec56                	sd	s5,24(sp)
    80001194:	e85a                	sd	s6,16(sp)
    80001196:	e45e                	sd	s7,8(sp)
    80001198:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000119a:	03459793          	slli	a5,a1,0x34
    8000119e:	e7a9                	bnez	a5,800011e8 <mappages+0x64>
    800011a0:	8aaa                	mv	s5,a0
    800011a2:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    800011a4:	03461793          	slli	a5,a2,0x34
    800011a8:	e7b1                	bnez	a5,800011f4 <mappages+0x70>
    panic("mappages: size not aligned");

  if (size == 0)
    800011aa:	ca39                	beqz	a2,80001200 <mappages+0x7c>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    800011ac:	77fd                	lui	a5,0xfffff
    800011ae:	963e                	add	a2,a2,a5
    800011b0:	00b609b3          	add	s3,a2,a1
  a = va;
    800011b4:	892e                	mv	s2,a1
    800011b6:	40b68a33          	sub	s4,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800011ba:	6b85                	lui	s7,0x1
    800011bc:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    800011c0:	4605                	li	a2,1
    800011c2:	85ca                	mv	a1,s2
    800011c4:	8556                	mv	a0,s5
    800011c6:	ee7ff0ef          	jal	800010ac <walk>
    800011ca:	c539                	beqz	a0,80001218 <mappages+0x94>
    if (*pte & PTE_V)
    800011cc:	611c                	ld	a5,0(a0)
    800011ce:	8b85                	andi	a5,a5,1
    800011d0:	ef95                	bnez	a5,8000120c <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011d2:	80b1                	srli	s1,s1,0xc
    800011d4:	04aa                	slli	s1,s1,0xa
    800011d6:	0164e4b3          	or	s1,s1,s6
    800011da:	0014e493          	ori	s1,s1,1
    800011de:	e104                	sd	s1,0(a0)
    if (a == last)
    800011e0:	05390863          	beq	s2,s3,80001230 <mappages+0xac>
    a += PGSIZE;
    800011e4:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800011e6:	bfd9                	j	800011bc <mappages+0x38>
    panic("mappages: va not aligned");
    800011e8:	00008517          	auipc	a0,0x8
    800011ec:	ef850513          	addi	a0,a0,-264 # 800090e0 <etext+0xe0>
    800011f0:	e00ff0ef          	jal	800007f0 <panic>
    panic("mappages: size not aligned");
    800011f4:	00008517          	auipc	a0,0x8
    800011f8:	f0c50513          	addi	a0,a0,-244 # 80009100 <etext+0x100>
    800011fc:	df4ff0ef          	jal	800007f0 <panic>
    panic("mappages: size");
    80001200:	00008517          	auipc	a0,0x8
    80001204:	f2050513          	addi	a0,a0,-224 # 80009120 <etext+0x120>
    80001208:	de8ff0ef          	jal	800007f0 <panic>
      panic("mappages: remap");
    8000120c:	00008517          	auipc	a0,0x8
    80001210:	f2450513          	addi	a0,a0,-220 # 80009130 <etext+0x130>
    80001214:	ddcff0ef          	jal	800007f0 <panic>
      return -1;
    80001218:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000121a:	60a6                	ld	ra,72(sp)
    8000121c:	6406                	ld	s0,64(sp)
    8000121e:	74e2                	ld	s1,56(sp)
    80001220:	7942                	ld	s2,48(sp)
    80001222:	79a2                	ld	s3,40(sp)
    80001224:	7a02                	ld	s4,32(sp)
    80001226:	6ae2                	ld	s5,24(sp)
    80001228:	6b42                	ld	s6,16(sp)
    8000122a:	6ba2                	ld	s7,8(sp)
    8000122c:	6161                	addi	sp,sp,80
    8000122e:	8082                	ret
  return 0;
    80001230:	4501                	li	a0,0
    80001232:	b7e5                	j	8000121a <mappages+0x96>

0000000080001234 <kvmmap>:
{
    80001234:	1141                	addi	sp,sp,-16
    80001236:	e406                	sd	ra,8(sp)
    80001238:	e022                	sd	s0,0(sp)
    8000123a:	0800                	addi	s0,sp,16
    8000123c:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000123e:	86b2                	mv	a3,a2
    80001240:	863e                	mv	a2,a5
    80001242:	f43ff0ef          	jal	80001184 <mappages>
    80001246:	e509                	bnez	a0,80001250 <kvmmap+0x1c>
}
    80001248:	60a2                	ld	ra,8(sp)
    8000124a:	6402                	ld	s0,0(sp)
    8000124c:	0141                	addi	sp,sp,16
    8000124e:	8082                	ret
    panic("kvmmap");
    80001250:	00008517          	auipc	a0,0x8
    80001254:	ef050513          	addi	a0,a0,-272 # 80009140 <etext+0x140>
    80001258:	d98ff0ef          	jal	800007f0 <panic>

000000008000125c <kvmmake>:
{
    8000125c:	1101                	addi	sp,sp,-32
    8000125e:	ec06                	sd	ra,24(sp)
    80001260:	e822                	sd	s0,16(sp)
    80001262:	e426                	sd	s1,8(sp)
    80001264:	e04a                	sd	s2,0(sp)
    80001266:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001268:	8d7ff0ef          	jal	80000b3e <kalloc>
    8000126c:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000126e:	6605                	lui	a2,0x1
    80001270:	4581                	li	a1,0
    80001272:	bc3ff0ef          	jal	80000e34 <memset>
  kvmmap(kpgtbl, VIRT_TEST, VIRT_TEST, PGSIZE, PTE_R | PTE_W);
    80001276:	4719                	li	a4,6
    80001278:	6685                	lui	a3,0x1
    8000127a:	00100637          	lui	a2,0x100
    8000127e:	001005b7          	lui	a1,0x100
    80001282:	8526                	mv	a0,s1
    80001284:	fb1ff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001288:	4719                	li	a4,6
    8000128a:	6685                	lui	a3,0x1
    8000128c:	10000637          	lui	a2,0x10000
    80001290:	100005b7          	lui	a1,0x10000
    80001294:	8526                	mv	a0,s1
    80001296:	f9fff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000129a:	4719                	li	a4,6
    8000129c:	6685                	lui	a3,0x1
    8000129e:	10001637          	lui	a2,0x10001
    800012a2:	100015b7          	lui	a1,0x10001
    800012a6:	8526                	mv	a0,s1
    800012a8:	f8dff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800012ac:	4719                	li	a4,6
    800012ae:	040006b7          	lui	a3,0x4000
    800012b2:	0c000637          	lui	a2,0xc000
    800012b6:	0c0005b7          	lui	a1,0xc000
    800012ba:	8526                	mv	a0,s1
    800012bc:	f79ff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800012c0:	00008917          	auipc	s2,0x8
    800012c4:	d4090913          	addi	s2,s2,-704 # 80009000 <etext>
    800012c8:	4729                	li	a4,10
    800012ca:	80008697          	auipc	a3,0x80008
    800012ce:	d3668693          	addi	a3,a3,-714 # 9000 <_entry-0x7fff7000>
    800012d2:	4605                	li	a2,1
    800012d4:	067e                	slli	a2,a2,0x1f
    800012d6:	85b2                	mv	a1,a2
    800012d8:	8526                	mv	a0,s1
    800012da:	f5bff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800012de:	46c5                	li	a3,17
    800012e0:	06ee                	slli	a3,a3,0x1b
    800012e2:	4719                	li	a4,6
    800012e4:	412686b3          	sub	a3,a3,s2
    800012e8:	864a                	mv	a2,s2
    800012ea:	85ca                	mv	a1,s2
    800012ec:	8526                	mv	a0,s1
    800012ee:	f47ff0ef          	jal	80001234 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012f2:	4729                	li	a4,10
    800012f4:	6685                	lui	a3,0x1
    800012f6:	00007617          	auipc	a2,0x7
    800012fa:	d0a60613          	addi	a2,a2,-758 # 80008000 <_trampoline>
    800012fe:	040005b7          	lui	a1,0x4000
    80001302:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001304:	05b2                	slli	a1,a1,0xc
    80001306:	8526                	mv	a0,s1
    80001308:	f2dff0ef          	jal	80001234 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000130c:	8526                	mv	a0,s1
    8000130e:	543000ef          	jal	80002050 <proc_mapstacks>
}
    80001312:	8526                	mv	a0,s1
    80001314:	60e2                	ld	ra,24(sp)
    80001316:	6442                	ld	s0,16(sp)
    80001318:	64a2                	ld	s1,8(sp)
    8000131a:	6902                	ld	s2,0(sp)
    8000131c:	6105                	addi	sp,sp,32
    8000131e:	8082                	ret

0000000080001320 <kvminit>:
{
    80001320:	1141                	addi	sp,sp,-16
    80001322:	e406                	sd	ra,8(sp)
    80001324:	e022                	sd	s0,0(sp)
    80001326:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001328:	f35ff0ef          	jal	8000125c <kvmmake>
    8000132c:	00009797          	auipc	a5,0x9
    80001330:	a2a7ba23          	sd	a0,-1484(a5) # 80009d60 <kernel_pagetable>
}
    80001334:	60a2                	ld	ra,8(sp)
    80001336:	6402                	ld	s0,0(sp)
    80001338:	0141                	addi	sp,sp,16
    8000133a:	8082                	ret

000000008000133c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000133c:	1101                	addi	sp,sp,-32
    8000133e:	ec06                	sd	ra,24(sp)
    80001340:	e822                	sd	s0,16(sp)
    80001342:	e426                	sd	s1,8(sp)
    80001344:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001346:	ff8ff0ef          	jal	80000b3e <kalloc>
    8000134a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000134c:	c509                	beqz	a0,80001356 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000134e:	6605                	lui	a2,0x1
    80001350:	4581                	li	a1,0
    80001352:	ae3ff0ef          	jal	80000e34 <memset>
  return pagetable;
}
    80001356:	8526                	mv	a0,s1
    80001358:	60e2                	ld	ra,24(sp)
    8000135a:	6442                	ld	s0,16(sp)
    8000135c:	64a2                	ld	s1,8(sp)
    8000135e:	6105                	addi	sp,sp,32
    80001360:	8082                	ret

0000000080001362 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000136a:	03459793          	slli	a5,a1,0x34
    8000136e:	e38d                	bnez	a5,80001390 <uvmunmap+0x2e>
    80001370:	f04a                	sd	s2,32(sp)
    80001372:	ec4e                	sd	s3,24(sp)
    80001374:	e852                	sd	s4,16(sp)
    80001376:	e456                	sd	s5,8(sp)
    80001378:	e05a                	sd	s6,0(sp)
    8000137a:	8a2a                	mv	s4,a0
    8000137c:	892e                	mv	s2,a1
    8000137e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001380:	0632                	slli	a2,a2,0xc
    80001382:	00b609b3          	add	s3,a2,a1
    80001386:	6b05                	lui	s6,0x1
    80001388:	0535f963          	bgeu	a1,s3,800013da <uvmunmap+0x78>
    8000138c:	f426                	sd	s1,40(sp)
    8000138e:	a015                	j	800013b2 <uvmunmap+0x50>
    80001390:	f426                	sd	s1,40(sp)
    80001392:	f04a                	sd	s2,32(sp)
    80001394:	ec4e                	sd	s3,24(sp)
    80001396:	e852                	sd	s4,16(sp)
    80001398:	e456                	sd	s5,8(sp)
    8000139a:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000139c:	00008517          	auipc	a0,0x8
    800013a0:	dac50513          	addi	a0,a0,-596 # 80009148 <etext+0x148>
    800013a4:	c4cff0ef          	jal	800007f0 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800013a8:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800013ac:	995a                	add	s2,s2,s6
    800013ae:	03397563          	bgeu	s2,s3,800013d8 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800013b2:	4601                	li	a2,0
    800013b4:	85ca                	mv	a1,s2
    800013b6:	8552                	mv	a0,s4
    800013b8:	cf5ff0ef          	jal	800010ac <walk>
    800013bc:	84aa                	mv	s1,a0
    800013be:	d57d                	beqz	a0,800013ac <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    800013c0:	611c                	ld	a5,0(a0)
    800013c2:	0017f713          	andi	a4,a5,1
    800013c6:	d37d                	beqz	a4,800013ac <uvmunmap+0x4a>
    if (do_free) {
    800013c8:	fe0a80e3          	beqz	s5,800013a8 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800013cc:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    800013ce:	00c79513          	slli	a0,a5,0xc
    800013d2:	e16ff0ef          	jal	800009e8 <kfree>
    800013d6:	bfc9                	j	800013a8 <uvmunmap+0x46>
    800013d8:	74a2                	ld	s1,40(sp)
    800013da:	7902                	ld	s2,32(sp)
    800013dc:	69e2                	ld	s3,24(sp)
    800013de:	6a42                	ld	s4,16(sp)
    800013e0:	6aa2                	ld	s5,8(sp)
    800013e2:	6b02                	ld	s6,0(sp)
  }
}
    800013e4:	70e2                	ld	ra,56(sp)
    800013e6:	7442                	ld	s0,48(sp)
    800013e8:	6121                	addi	sp,sp,64
    800013ea:	8082                	ret

00000000800013ec <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013ec:	1101                	addi	sp,sp,-32
    800013ee:	ec06                	sd	ra,24(sp)
    800013f0:	e822                	sd	s0,16(sp)
    800013f2:	e426                	sd	s1,8(sp)
    800013f4:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800013f6:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800013f8:	00b67d63          	bgeu	a2,a1,80001412 <uvmdealloc+0x26>
    800013fc:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800013fe:	6785                	lui	a5,0x1
    80001400:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001402:	00f60733          	add	a4,a2,a5
    80001406:	76fd                	lui	a3,0xfffff
    80001408:	8f75                	and	a4,a4,a3
    8000140a:	97ae                	add	a5,a5,a1
    8000140c:	8ff5                	and	a5,a5,a3
    8000140e:	00f76863          	bltu	a4,a5,8000141e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001412:	8526                	mv	a0,s1
    80001414:	60e2                	ld	ra,24(sp)
    80001416:	6442                	ld	s0,16(sp)
    80001418:	64a2                	ld	s1,8(sp)
    8000141a:	6105                	addi	sp,sp,32
    8000141c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000141e:	8f99                	sub	a5,a5,a4
    80001420:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001422:	4685                	li	a3,1
    80001424:	0007861b          	sext.w	a2,a5
    80001428:	85ba                	mv	a1,a4
    8000142a:	f39ff0ef          	jal	80001362 <uvmunmap>
    8000142e:	b7d5                	j	80001412 <uvmdealloc+0x26>

0000000080001430 <uvmalloc>:
  if (newsz < oldsz)
    80001430:	08b66f63          	bltu	a2,a1,800014ce <uvmalloc+0x9e>
{
    80001434:	7139                	addi	sp,sp,-64
    80001436:	fc06                	sd	ra,56(sp)
    80001438:	f822                	sd	s0,48(sp)
    8000143a:	ec4e                	sd	s3,24(sp)
    8000143c:	e852                	sd	s4,16(sp)
    8000143e:	e456                	sd	s5,8(sp)
    80001440:	0080                	addi	s0,sp,64
    80001442:	8aaa                	mv	s5,a0
    80001444:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001446:	6785                	lui	a5,0x1
    80001448:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000144a:	95be                	add	a1,a1,a5
    8000144c:	77fd                	lui	a5,0xfffff
    8000144e:	00f5f9b3          	and	s3,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001452:	08c9f063          	bgeu	s3,a2,800014d2 <uvmalloc+0xa2>
    80001456:	f426                	sd	s1,40(sp)
    80001458:	f04a                	sd	s2,32(sp)
    8000145a:	e05a                	sd	s6,0(sp)
    8000145c:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000145e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001462:	edcff0ef          	jal	80000b3e <kalloc>
    80001466:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001468:	c515                	beqz	a0,80001494 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000146a:	6605                	lui	a2,0x1
    8000146c:	4581                	li	a1,0
    8000146e:	9c7ff0ef          	jal	80000e34 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001472:	875a                	mv	a4,s6
    80001474:	86a6                	mv	a3,s1
    80001476:	6605                	lui	a2,0x1
    80001478:	85ca                	mv	a1,s2
    8000147a:	8556                	mv	a0,s5
    8000147c:	d09ff0ef          	jal	80001184 <mappages>
    80001480:	e915                	bnez	a0,800014b4 <uvmalloc+0x84>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001482:	6785                	lui	a5,0x1
    80001484:	993e                	add	s2,s2,a5
    80001486:	fd496ee3          	bltu	s2,s4,80001462 <uvmalloc+0x32>
  return newsz;
    8000148a:	8552                	mv	a0,s4
    8000148c:	74a2                	ld	s1,40(sp)
    8000148e:	7902                	ld	s2,32(sp)
    80001490:	6b02                	ld	s6,0(sp)
    80001492:	a811                	j	800014a6 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80001494:	864e                	mv	a2,s3
    80001496:	85ca                	mv	a1,s2
    80001498:	8556                	mv	a0,s5
    8000149a:	f53ff0ef          	jal	800013ec <uvmdealloc>
      return 0;
    8000149e:	4501                	li	a0,0
    800014a0:	74a2                	ld	s1,40(sp)
    800014a2:	7902                	ld	s2,32(sp)
    800014a4:	6b02                	ld	s6,0(sp)
}
    800014a6:	70e2                	ld	ra,56(sp)
    800014a8:	7442                	ld	s0,48(sp)
    800014aa:	69e2                	ld	s3,24(sp)
    800014ac:	6a42                	ld	s4,16(sp)
    800014ae:	6aa2                	ld	s5,8(sp)
    800014b0:	6121                	addi	sp,sp,64
    800014b2:	8082                	ret
      kfree(mem);
    800014b4:	8526                	mv	a0,s1
    800014b6:	d32ff0ef          	jal	800009e8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800014ba:	864e                	mv	a2,s3
    800014bc:	85ca                	mv	a1,s2
    800014be:	8556                	mv	a0,s5
    800014c0:	f2dff0ef          	jal	800013ec <uvmdealloc>
      return 0;
    800014c4:	4501                	li	a0,0
    800014c6:	74a2                	ld	s1,40(sp)
    800014c8:	7902                	ld	s2,32(sp)
    800014ca:	6b02                	ld	s6,0(sp)
    800014cc:	bfe9                	j	800014a6 <uvmalloc+0x76>
    return oldsz;
    800014ce:	852e                	mv	a0,a1
}
    800014d0:	8082                	ret
  return newsz;
    800014d2:	8532                	mv	a0,a2
    800014d4:	bfc9                	j	800014a6 <uvmalloc+0x76>

00000000800014d6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014d6:	7179                	addi	sp,sp,-48
    800014d8:	f406                	sd	ra,40(sp)
    800014da:	f022                	sd	s0,32(sp)
    800014dc:	ec26                	sd	s1,24(sp)
    800014de:	e84a                	sd	s2,16(sp)
    800014e0:	e44e                	sd	s3,8(sp)
    800014e2:	e052                	sd	s4,0(sp)
    800014e4:	1800                	addi	s0,sp,48
    800014e6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800014e8:	84aa                	mv	s1,a0
    800014ea:	6905                	lui	s2,0x1
    800014ec:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800014ee:	4985                	li	s3,1
    800014f0:	a819                	j	80001506 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014f2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014f4:	00c79513          	slli	a0,a5,0xc
    800014f8:	fdfff0ef          	jal	800014d6 <freewalk>
      pagetable[i] = 0;
    800014fc:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80001500:	04a1                	addi	s1,s1,8
    80001502:	01248f63          	beq	s1,s2,80001520 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001506:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001508:	00f7f713          	andi	a4,a5,15
    8000150c:	ff3703e3          	beq	a4,s3,800014f2 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80001510:	8b85                	andi	a5,a5,1
    80001512:	d7fd                	beqz	a5,80001500 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001514:	00008517          	auipc	a0,0x8
    80001518:	c4c50513          	addi	a0,a0,-948 # 80009160 <etext+0x160>
    8000151c:	ad4ff0ef          	jal	800007f0 <panic>
    }
  }
  kfree((void *)pagetable);
    80001520:	8552                	mv	a0,s4
    80001522:	cc6ff0ef          	jal	800009e8 <kfree>
}
    80001526:	70a2                	ld	ra,40(sp)
    80001528:	7402                	ld	s0,32(sp)
    8000152a:	64e2                	ld	s1,24(sp)
    8000152c:	6942                	ld	s2,16(sp)
    8000152e:	69a2                	ld	s3,8(sp)
    80001530:	6a02                	ld	s4,0(sp)
    80001532:	6145                	addi	sp,sp,48
    80001534:	8082                	ret

0000000080001536 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001536:	1101                	addi	sp,sp,-32
    80001538:	ec06                	sd	ra,24(sp)
    8000153a:	e822                	sd	s0,16(sp)
    8000153c:	e426                	sd	s1,8(sp)
    8000153e:	1000                	addi	s0,sp,32
    80001540:	84aa                	mv	s1,a0
  if (sz > 0)
    80001542:	e989                	bnez	a1,80001554 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80001544:	8526                	mv	a0,s1
    80001546:	f91ff0ef          	jal	800014d6 <freewalk>
}
    8000154a:	60e2                	ld	ra,24(sp)
    8000154c:	6442                	ld	s0,16(sp)
    8000154e:	64a2                	ld	s1,8(sp)
    80001550:	6105                	addi	sp,sp,32
    80001552:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001554:	6785                	lui	a5,0x1
    80001556:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001558:	95be                	add	a1,a1,a5
    8000155a:	4685                	li	a3,1
    8000155c:	00c5d613          	srli	a2,a1,0xc
    80001560:	4581                	li	a1,0
    80001562:	e01ff0ef          	jal	80001362 <uvmunmap>
    80001566:	bff9                	j	80001544 <uvmfree+0xe>

0000000080001568 <uvmcopy>:
// Copy-on-Write (COW). Writable pages are marked read-only + PTE_COW in both
// page tables and only copied when either process writes to them.
// Returns 0 on success, -1 on failure (freeing any child mappings on error).
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001568:	715d                	addi	sp,sp,-80
    8000156a:	e486                	sd	ra,72(sp)
    8000156c:	e0a2                	sd	s0,64(sp)
    8000156e:	e062                	sd	s8,0(sp)
    80001570:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  int downgraded = 0;

  for (i = 0; i < sz; i += PGSIZE) {
    80001572:	c271                	beqz	a2,80001636 <uvmcopy+0xce>
    80001574:	fc26                	sd	s1,56(sp)
    80001576:	f84a                	sd	s2,48(sp)
    80001578:	f44e                	sd	s3,40(sp)
    8000157a:	f052                	sd	s4,32(sp)
    8000157c:	ec56                	sd	s5,24(sp)
    8000157e:	e85a                	sd	s6,16(sp)
    80001580:	e45e                	sd	s7,8(sp)
    80001582:	8a2a                	mv	s4,a0
    80001584:	8aae                	mv	s5,a1
    80001586:	89b2                	mv	s3,a2
  int downgraded = 0;
    80001588:	4c01                	li	s8,0
  for (i = 0; i < sz; i += PGSIZE) {
    8000158a:	4481                	li	s1,0

    // Downgrade writable pages to read-only + COW so writes trigger a fault.
    if (flags & PTE_W) {
      flags = (flags & ~PTE_W) | PTE_COW;
      *pte = (*pte & ~PTE_W) | PTE_COW;
      downgraded = 1;
    8000158c:	4b05                	li	s6,1
    8000158e:	a815                	j	800015c2 <uvmcopy+0x5a>
      flags = (flags & ~PTE_W) | PTE_COW;
    80001590:	2fbbfb93          	andi	s7,s7,763
    80001594:	100beb93          	ori	s7,s7,256
      *pte = (*pte & ~PTE_W) | PTE_COW;
    80001598:	efb7f793          	andi	a5,a5,-261
    8000159c:	1007e793          	ori	a5,a5,256
    800015a0:	e11c                	sd	a5,0(a0)
      downgraded = 1;
    800015a2:	8c5a                	mv	s8,s6
    }

    // Both parent and child now share this physical frame.
    incref((void *)pa);
    800015a4:	854a                	mv	a0,s2
    800015a6:	e0eff0ef          	jal	80000bb4 <incref>

    if (mappages(new, i, PGSIZE, pa, flags) != 0) {
    800015aa:	875e                	mv	a4,s7
    800015ac:	86ca                	mv	a3,s2
    800015ae:	6605                	lui	a2,0x1
    800015b0:	85a6                	mv	a1,s1
    800015b2:	8556                	mv	a0,s5
    800015b4:	bd1ff0ef          	jal	80001184 <mappages>
    800015b8:	e915                	bnez	a0,800015ec <uvmcopy+0x84>
  for (i = 0; i < sz; i += PGSIZE) {
    800015ba:	6785                	lui	a5,0x1
    800015bc:	94be                	add	s1,s1,a5
    800015be:	0534ff63          	bgeu	s1,s3,8000161c <uvmcopy+0xb4>
    if ((pte = walk(old, i, 0)) == 0)
    800015c2:	4601                	li	a2,0
    800015c4:	85a6                	mv	a1,s1
    800015c6:	8552                	mv	a0,s4
    800015c8:	ae5ff0ef          	jal	800010ac <walk>
    800015cc:	d57d                	beqz	a0,800015ba <uvmcopy+0x52>
    if ((*pte & PTE_V) == 0)
    800015ce:	611c                	ld	a5,0(a0)
    800015d0:	0017f713          	andi	a4,a5,1
    800015d4:	d37d                	beqz	a4,800015ba <uvmcopy+0x52>
    pa = PTE2PA(*pte);
    800015d6:	00a7d913          	srli	s2,a5,0xa
    800015da:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    800015dc:	00078b9b          	sext.w	s7,a5
    if (flags & PTE_W) {
    800015e0:	0047f713          	andi	a4,a5,4
    800015e4:	f755                	bnez	a4,80001590 <uvmcopy+0x28>
    flags = PTE_FLAGS(*pte);
    800015e6:	3ffbfb93          	andi	s7,s7,1023
    800015ea:	bf6d                	j	800015a4 <uvmcopy+0x3c>
      decref((void *)pa);
    800015ec:	854a                	mv	a0,s2
    800015ee:	e90ff0ef          	jal	80000c7e <decref>
    sfence_vma();

  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015f2:	4685                	li	a3,1
    800015f4:	00c4d613          	srli	a2,s1,0xc
    800015f8:	4581                	li	a1,0
    800015fa:	8556                	mv	a0,s5
    800015fc:	d67ff0ef          	jal	80001362 <uvmunmap>
  return -1;
    80001600:	5c7d                	li	s8,-1
    80001602:	74e2                	ld	s1,56(sp)
    80001604:	7942                	ld	s2,48(sp)
    80001606:	79a2                	ld	s3,40(sp)
    80001608:	7a02                	ld	s4,32(sp)
    8000160a:	6ae2                	ld	s5,24(sp)
    8000160c:	6b42                	ld	s6,16(sp)
    8000160e:	6ba2                	ld	s7,8(sp)
}
    80001610:	8562                	mv	a0,s8
    80001612:	60a6                	ld	ra,72(sp)
    80001614:	6406                	ld	s0,64(sp)
    80001616:	6c02                	ld	s8,0(sp)
    80001618:	6161                	addi	sp,sp,80
    8000161a:	8082                	ret
  if (downgraded)
    8000161c:	000c0f63          	beqz	s8,8000163a <uvmcopy+0xd2>
    80001620:	12000073          	sfence.vma
  return 0;
    80001624:	4c01                	li	s8,0
}
    80001626:	74e2                	ld	s1,56(sp)
    80001628:	7942                	ld	s2,48(sp)
    8000162a:	79a2                	ld	s3,40(sp)
    8000162c:	7a02                	ld	s4,32(sp)
    8000162e:	6ae2                	ld	s5,24(sp)
    80001630:	6b42                	ld	s6,16(sp)
    80001632:	6ba2                	ld	s7,8(sp)
    80001634:	bff1                	j	80001610 <uvmcopy+0xa8>
    80001636:	4c01                	li	s8,0
    80001638:	bfe1                	j	80001610 <uvmcopy+0xa8>
    8000163a:	74e2                	ld	s1,56(sp)
    8000163c:	7942                	ld	s2,48(sp)
    8000163e:	79a2                	ld	s3,40(sp)
    80001640:	7a02                	ld	s4,32(sp)
    80001642:	6ae2                	ld	s5,24(sp)
    80001644:	6b42                	ld	s6,16(sp)
    80001646:	6ba2                	ld	s7,8(sp)
    80001648:	b7e1                	j	80001610 <uvmcopy+0xa8>

000000008000164a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000164a:	1141                	addi	sp,sp,-16
    8000164c:	e406                	sd	ra,8(sp)
    8000164e:	e022                	sd	s0,0(sp)
    80001650:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001652:	4601                	li	a2,0
    80001654:	a59ff0ef          	jal	800010ac <walk>
  if (pte == 0)
    80001658:	c901                	beqz	a0,80001668 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000165a:	611c                	ld	a5,0(a0)
    8000165c:	9bbd                	andi	a5,a5,-17
    8000165e:	e11c                	sd	a5,0(a0)
}
    80001660:	60a2                	ld	ra,8(sp)
    80001662:	6402                	ld	s0,0(sp)
    80001664:	0141                	addi	sp,sp,16
    80001666:	8082                	ret
    panic("uvmclear");
    80001668:	00008517          	auipc	a0,0x8
    8000166c:	b0850513          	addi	a0,a0,-1272 # 80009170 <etext+0x170>
    80001670:	980ff0ef          	jal	800007f0 <panic>

0000000080001674 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001674:	1141                	addi	sp,sp,-16
    80001676:	e406                	sd	ra,8(sp)
    80001678:	e022                	sd	s0,0(sp)
    8000167a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000167c:	4601                	li	a2,0
    8000167e:	a2fff0ef          	jal	800010ac <walk>
  if (pte == 0) {
    80001682:	c519                	beqz	a0,80001690 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V) {
    80001684:	6108                	ld	a0,0(a0)
    80001686:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001688:	60a2                	ld	ra,8(sp)
    8000168a:	6402                	ld	s0,0(sp)
    8000168c:	0141                	addi	sp,sp,16
    8000168e:	8082                	ret
    return 0;
    80001690:	4501                	li	a0,0
    80001692:	bfdd                	j	80001688 <ismapped+0x14>

0000000080001694 <vmfault>:
{
    80001694:	7179                	addi	sp,sp,-48
    80001696:	f406                	sd	ra,40(sp)
    80001698:	f022                	sd	s0,32(sp)
    8000169a:	e44e                	sd	s3,8(sp)
    8000169c:	1800                	addi	s0,sp,48
    return 0;
    8000169e:	4981                	li	s3,0
  if (va >= psz)
    800016a0:	00b66863          	bltu	a2,a1,800016b0 <vmfault+0x1c>
}
    800016a4:	854e                	mv	a0,s3
    800016a6:	70a2                	ld	ra,40(sp)
    800016a8:	7402                	ld	s0,32(sp)
    800016aa:	69a2                	ld	s3,8(sp)
    800016ac:	6145                	addi	sp,sp,48
    800016ae:	8082                	ret
    800016b0:	ec26                	sd	s1,24(sp)
    800016b2:	e84a                	sd	s2,16(sp)
    800016b4:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    800016b6:	77fd                	lui	a5,0xfffff
    800016b8:	00f674b3          	and	s1,a2,a5
  if (ismapped(pagetable, va)) {
    800016bc:	85a6                	mv	a1,s1
    800016be:	fb7ff0ef          	jal	80001674 <ismapped>
    return 0;
    800016c2:	4981                	li	s3,0
  if (ismapped(pagetable, va)) {
    800016c4:	c501                	beqz	a0,800016cc <vmfault+0x38>
    800016c6:	64e2                	ld	s1,24(sp)
    800016c8:	6942                	ld	s2,16(sp)
    800016ca:	bfe9                	j	800016a4 <vmfault+0x10>
    800016cc:	e052                	sd	s4,0(sp)
  mem = (uint64)kalloc();
    800016ce:	c70ff0ef          	jal	80000b3e <kalloc>
    800016d2:	8a2a                	mv	s4,a0
  if (mem == 0)
    800016d4:	c915                	beqz	a0,80001708 <vmfault+0x74>
  mem = (uint64)kalloc();
    800016d6:	89aa                	mv	s3,a0
  memset((void *)mem, 0, PGSIZE);
    800016d8:	6605                	lui	a2,0x1
    800016da:	4581                	li	a1,0
    800016dc:	f58ff0ef          	jal	80000e34 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    800016e0:	4759                	li	a4,22
    800016e2:	86d2                	mv	a3,s4
    800016e4:	6605                	lui	a2,0x1
    800016e6:	85a6                	mv	a1,s1
    800016e8:	854a                	mv	a0,s2
    800016ea:	a9bff0ef          	jal	80001184 <mappages>
    800016ee:	e509                	bnez	a0,800016f8 <vmfault+0x64>
    800016f0:	64e2                	ld	s1,24(sp)
    800016f2:	6942                	ld	s2,16(sp)
    800016f4:	6a02                	ld	s4,0(sp)
    800016f6:	b77d                	j	800016a4 <vmfault+0x10>
    kfree((void *)mem);
    800016f8:	8552                	mv	a0,s4
    800016fa:	aeeff0ef          	jal	800009e8 <kfree>
    return 0;
    800016fe:	4981                	li	s3,0
    80001700:	64e2                	ld	s1,24(sp)
    80001702:	6942                	ld	s2,16(sp)
    80001704:	6a02                	ld	s4,0(sp)
    80001706:	bf79                	j	800016a4 <vmfault+0x10>
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	6a02                	ld	s4,0(sp)
    8000170e:	bf59                	j	800016a4 <vmfault+0x10>

0000000080001710 <cowalloc>:
// If this process is the sole owner of the frame, re-enable write access
// in place; otherwise allocate a private 4 KB copy and drop the old ref.
// Returns the writable physical address on success, or 0 if not a COW fault.
uint64
cowalloc(pagetable_t pagetable, uint64 va)
{
    80001710:	7139                	addi	sp,sp,-64
    80001712:	fc06                	sd	ra,56(sp)
    80001714:	f822                	sd	s0,48(sp)
    80001716:	f426                	sd	s1,40(sp)
    80001718:	0080                	addi	s0,sp,64
  uint64 pa;
  uint flags;
  char *mem;
  struct proc *p;

  if (va >= MAXVA)
    8000171a:	57fd                	li	a5,-1
    8000171c:	83e9                	srli	a5,a5,0x1a
    return 0;
    8000171e:	4481                	li	s1,0
  if (va >= MAXVA)
    80001720:	00b7f863          	bgeu	a5,a1,80001730 <cowalloc+0x20>

  if (p)
    p->cow_faults++;

  return (uint64)mem;
}
    80001724:	8526                	mv	a0,s1
    80001726:	70e2                	ld	ra,56(sp)
    80001728:	7442                	ld	s0,48(sp)
    8000172a:	74a2                	ld	s1,40(sp)
    8000172c:	6121                	addi	sp,sp,64
    8000172e:	8082                	ret
    80001730:	f04a                	sd	s2,32(sp)
  if ((pte = walk(pagetable, va, 0)) == 0)
    80001732:	4601                	li	a2,0
    80001734:	77fd                	lui	a5,0xfffff
    80001736:	8dfd                	and	a1,a1,a5
    80001738:	975ff0ef          	jal	800010ac <walk>
    8000173c:	892a                	mv	s2,a0
    8000173e:	c561                	beqz	a0,80001806 <cowalloc+0xf6>
    80001740:	ec4e                	sd	s3,24(sp)
  if ((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    80001742:	00053983          	ld	s3,0(a0)
    80001746:	0119f713          	andi	a4,s3,17
    8000174a:	47c5                	li	a5,17
    return 0;
    8000174c:	4481                	li	s1,0
  if ((*pte & PTE_V) == 0 || (*pte & PTE_U) == 0)
    8000174e:	0af71f63          	bne	a4,a5,8000180c <cowalloc+0xfc>
  if ((*pte & PTE_COW) == 0)
    80001752:	1009f493          	andi	s1,s3,256
    80001756:	e481                	bnez	s1,8000175e <cowalloc+0x4e>
    80001758:	7902                	ld	s2,32(sp)
    8000175a:	69e2                	ld	s3,24(sp)
    8000175c:	b7e1                	j	80001724 <cowalloc+0x14>
    8000175e:	e852                	sd	s4,16(sp)
    80001760:	e456                	sd	s5,8(sp)
    80001762:	e05a                	sd	s6,0(sp)
  pa = PTE2PA(*pte);
    80001764:	00a9d493          	srli	s1,s3,0xa
    80001768:	04b2                	slli	s1,s1,0xc
  flags = PTE_FLAGS(*pte);
    8000176a:	00098a1b          	sext.w	s4,s3
  p = myproc();
    8000176e:	25d000ef          	jal	800021ca <myproc>
    80001772:	8aaa                	mv	s5,a0
  if (getref((void *)pa) == 1) {
    80001774:	8b26                	mv	s6,s1
    80001776:	8526                	mv	a0,s1
    80001778:	ca2ff0ef          	jal	80000c1a <getref>
    8000177c:	4785                	li	a5,1
    8000177e:	04f50963          	beq	a0,a5,800017d0 <cowalloc+0xc0>
  mem = kalloc();
    80001782:	bbcff0ef          	jal	80000b3e <kalloc>
    80001786:	89aa                	mv	s3,a0
    return 0;
    80001788:	4481                	li	s1,0
  if (mem == 0)
    8000178a:	c951                	beqz	a0,8000181e <cowalloc+0x10e>
  memmove(mem, (char *)pa, PGSIZE);
    8000178c:	6605                	lui	a2,0x1
    8000178e:	85da                	mv	a1,s6
    80001790:	f00ff0ef          	jal	80000e90 <memmove>
  *pte = PA2PTE((uint64)mem) | flags;
    80001794:	84ce                	mv	s1,s3
    80001796:	00c9d793          	srli	a5,s3,0xc
    8000179a:	07aa                	slli	a5,a5,0xa
  flags = (flags | PTE_W) & ~PTE_COW;
    8000179c:	2ffa7a13          	andi	s4,s4,767
  *pte = PA2PTE((uint64)mem) | flags;
    800017a0:	004a6a13          	ori	s4,s4,4
    800017a4:	0147e7b3          	or	a5,a5,s4
    800017a8:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  asm volatile("sfence.vma zero, zero" ::: "memory");
    800017ac:	12000073          	sfence.vma
  decref((void *)pa);
    800017b0:	855a                	mv	a0,s6
    800017b2:	cccff0ef          	jal	80000c7e <decref>
  if (p)
    800017b6:	060a8a63          	beqz	s5,8000182a <cowalloc+0x11a>
    p->cow_faults++;
    800017ba:	050ab783          	ld	a5,80(s5)
    800017be:	0785                	addi	a5,a5,1 # fffffffffffff001 <end+0xffffffff7fdacf49>
    800017c0:	04fab823          	sd	a5,80(s5)
    800017c4:	7902                	ld	s2,32(sp)
    800017c6:	69e2                	ld	s3,24(sp)
    800017c8:	6a42                	ld	s4,16(sp)
    800017ca:	6aa2                	ld	s5,8(sp)
    800017cc:	6b02                	ld	s6,0(sp)
    800017ce:	bf99                	j	80001724 <cowalloc+0x14>
    *pte = PA2PTE(pa) | ((flags | PTE_W) & ~PTE_COW);
    800017d0:	2ffa7793          	andi	a5,s4,767
    800017d4:	0047e793          	ori	a5,a5,4
    800017d8:	777d                	lui	a4,0xfffff
    800017da:	8309                	srli	a4,a4,0x2
    800017dc:	00e9f9b3          	and	s3,s3,a4
    800017e0:	0137e7b3          	or	a5,a5,s3
    800017e4:	00f93023          	sd	a5,0(s2)
    800017e8:	12000073          	sfence.vma
    if (p)
    800017ec:	020a8363          	beqz	s5,80001812 <cowalloc+0x102>
      p->cow_faults++;
    800017f0:	050ab783          	ld	a5,80(s5)
    800017f4:	0785                	addi	a5,a5,1
    800017f6:	04fab823          	sd	a5,80(s5)
    800017fa:	7902                	ld	s2,32(sp)
    800017fc:	69e2                	ld	s3,24(sp)
    800017fe:	6a42                	ld	s4,16(sp)
    80001800:	6aa2                	ld	s5,8(sp)
    80001802:	6b02                	ld	s6,0(sp)
    80001804:	b705                	j	80001724 <cowalloc+0x14>
    return 0;
    80001806:	4481                	li	s1,0
    80001808:	7902                	ld	s2,32(sp)
    8000180a:	bf29                	j	80001724 <cowalloc+0x14>
    8000180c:	7902                	ld	s2,32(sp)
    8000180e:	69e2                	ld	s3,24(sp)
    80001810:	bf11                	j	80001724 <cowalloc+0x14>
    80001812:	7902                	ld	s2,32(sp)
    80001814:	69e2                	ld	s3,24(sp)
    80001816:	6a42                	ld	s4,16(sp)
    80001818:	6aa2                	ld	s5,8(sp)
    8000181a:	6b02                	ld	s6,0(sp)
    8000181c:	b721                	j	80001724 <cowalloc+0x14>
    8000181e:	7902                	ld	s2,32(sp)
    80001820:	69e2                	ld	s3,24(sp)
    80001822:	6a42                	ld	s4,16(sp)
    80001824:	6aa2                	ld	s5,8(sp)
    80001826:	6b02                	ld	s6,0(sp)
    80001828:	bdf5                	j	80001724 <cowalloc+0x14>
    8000182a:	7902                	ld	s2,32(sp)
    8000182c:	69e2                	ld	s3,24(sp)
    8000182e:	6a42                	ld	s4,16(sp)
    80001830:	6aa2                	ld	s5,8(sp)
    80001832:	6b02                	ld	s6,0(sp)
    80001834:	bdc5                	j	80001724 <cowalloc+0x14>

0000000080001836 <mmapfault>:
// Allocates a single 4 KB page on first access, fills it from the backing file
// (or leaves it zero-filled for anonymous mappings), and maps it into the PTE.
// Returns the physical address on success, or 0 if va is not in a valid VMA.
uint64
mmapfault(pagetable_t pagetable, uint64 va, int read)
{
    80001836:	715d                	addi	sp,sp,-80
    80001838:	e486                	sd	ra,72(sp)
    8000183a:	e0a2                	sd	s0,64(sp)
    8000183c:	fc26                	sd	s1,56(sp)
    8000183e:	f84a                	sd	s2,48(sp)
    80001840:	f44e                	sd	s3,40(sp)
    80001842:	f052                	sd	s4,32(sp)
    80001844:	ec56                	sd	s5,24(sp)
    80001846:	0880                	addi	s0,sp,80
    80001848:	8a2a                	mv	s4,a0
    8000184a:	892e                	mv	s2,a1
    8000184c:	8ab2                	mv	s5,a2
  struct proc *p = myproc();
    8000184e:	17d000ef          	jal	800021ca <myproc>
    80001852:	89aa                	mv	s3,a0
  struct vma *vma;
  uint64 mem;
  uint64 offset;
  int perm;

  va = PGROUNDDOWN(va);
    80001854:	77fd                	lui	a5,0xfffff
    80001856:	00f97933          	and	s2,s2,a5

  for (int i = 0; i < NVMA; i++) {
    8000185a:	19850793          	addi	a5,a0,408
    8000185e:	4481                	li	s1,0
    80001860:	45c1                	li	a1,16
    80001862:	a0a9                	j	800018ac <mmapfault+0x76>
      continue;

    if (va >= vma->addr && va < vma->addr + vma->maplen) {
      if (read && !(vma->prot & PROT_READ))
        return 0;
      if (!read && !(vma->prot & PROT_WRITE))
    80001864:	00349793          	slli	a5,s1,0x3
    80001868:	8f85                	sub	a5,a5,s1
    8000186a:	078e                	slli	a5,a5,0x3
    8000186c:	97ce                	add	a5,a5,s3
    8000186e:	1b87a783          	lw	a5,440(a5) # fffffffffffff1b8 <end+0xffffffff7fdad100>
    80001872:	8b89                	andi	a5,a5,2
        return 0;
    80001874:	4a81                	li	s5,0
      if (!read && !(vma->prot & PROT_WRITE))
    80001876:	e3a5                	bnez	a5,800018d6 <mmapfault+0xa0>
    80001878:	aa21                	j	80001990 <mmapfault+0x15a>

      if (ismapped(pagetable, va))
        return walkaddr(pagetable, va);
    8000187a:	85ca                	mv	a1,s2
    8000187c:	8552                	mv	a0,s4
    8000187e:	8c9ff0ef          	jal	80001146 <walkaddr>
    80001882:	8aaa                	mv	s5,a0
    80001884:	a231                	j	80001990 <mmapfault+0x15a>
        ilock(vma->file->ip);
        n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
        iunlock(vma->file->ip);

        if (n < 0) {
          kfree((void *)mem);
    80001886:	855a                	mv	a0,s6
    80001888:	960ff0ef          	jal	800009e8 <kfree>
          return 0;
    8000188c:	4a81                	li	s5,0
    8000188e:	6b42                	ld	s6,16(sp)
    80001890:	6ba2                	ld	s7,8(sp)
    80001892:	6c02                	ld	s8,0(sp)
    80001894:	a8f5                	j	80001990 <mmapfault+0x15a>
        perm |= PTE_R;
      if (vma->prot & PROT_WRITE)
        perm |= PTE_W;

      if (mappages(pagetable, va, PGSIZE, mem, perm) != 0) {
        kfree((void *)mem);
    80001896:	855a                	mv	a0,s6
    80001898:	950ff0ef          	jal	800009e8 <kfree>
        return 0;
    8000189c:	4a81                	li	s5,0
    8000189e:	6b42                	ld	s6,16(sp)
    800018a0:	a8c5                	j	80001990 <mmapfault+0x15a>
  for (int i = 0; i < NVMA; i++) {
    800018a2:	2485                	addiw	s1,s1,1
    800018a4:	03878793          	addi	a5,a5,56
    800018a8:	0eb48363          	beq	s1,a1,8000198e <mmapfault+0x158>
    if (vma->used == 0)
    800018ac:	4398                	lw	a4,0(a5)
    800018ae:	db75                	beqz	a4,800018a2 <mmapfault+0x6c>
    if (va >= vma->addr && va < vma->addr + vma->maplen) {
    800018b0:	6798                	ld	a4,8(a5)
    800018b2:	fee968e3          	bltu	s2,a4,800018a2 <mmapfault+0x6c>
    800018b6:	6f94                	ld	a3,24(a5)
    800018b8:	9736                	add	a4,a4,a3
    800018ba:	fee974e3          	bgeu	s2,a4,800018a2 <mmapfault+0x6c>
      if (read && !(vma->prot & PROT_READ))
    800018be:	fa0a83e3          	beqz	s5,80001864 <mmapfault+0x2e>
    800018c2:	00349793          	slli	a5,s1,0x3
    800018c6:	8f85                	sub	a5,a5,s1
    800018c8:	078e                	slli	a5,a5,0x3
    800018ca:	97ce                	add	a5,a5,s3
    800018cc:	1b87a783          	lw	a5,440(a5)
    800018d0:	8b85                	andi	a5,a5,1
        return 0;
    800018d2:	4a81                	li	s5,0
      if (read && !(vma->prot & PROT_READ))
    800018d4:	cfd5                	beqz	a5,80001990 <mmapfault+0x15a>
      if (ismapped(pagetable, va))
    800018d6:	85ca                	mv	a1,s2
    800018d8:	8552                	mv	a0,s4
    800018da:	d9bff0ef          	jal	80001674 <ismapped>
    800018de:	fd51                	bnez	a0,8000187a <mmapfault+0x44>
    800018e0:	e85a                	sd	s6,16(sp)
      mem = (uint64)kalloc();
    800018e2:	a5cff0ef          	jal	80000b3e <kalloc>
    800018e6:	8b2a                	mv	s6,a0
        return 0;
    800018e8:	4a81                	li	s5,0
      if (mem == 0)
    800018ea:	cd4d                	beqz	a0,800019a4 <mmapfault+0x16e>
      mem = (uint64)kalloc();
    800018ec:	8aaa                	mv	s5,a0
      memset((void *)mem, 0, PGSIZE);
    800018ee:	6605                	lui	a2,0x1
    800018f0:	4581                	li	a1,0
    800018f2:	d42ff0ef          	jal	80000e34 <memset>
      if (!(vma->flags & MAP_ANONYMOUS) && vma->file != 0) {
    800018f6:	00349793          	slli	a5,s1,0x3
    800018fa:	8f85                	sub	a5,a5,s1
    800018fc:	078e                	slli	a5,a5,0x3
    800018fe:	97ce                	add	a5,a5,s3
    80001900:	1bc7a783          	lw	a5,444(a5)
    80001904:	8b91                	andi	a5,a5,4
    80001906:	ebb1                	bnez	a5,8000195a <mmapfault+0x124>
    80001908:	00349793          	slli	a5,s1,0x3
    8000190c:	8f85                	sub	a5,a5,s1
    8000190e:	078e                	slli	a5,a5,0x3
    80001910:	97ce                	add	a5,a5,s3
    80001912:	1c07b703          	ld	a4,448(a5)
    80001916:	c331                	beqz	a4,8000195a <mmapfault+0x124>
    80001918:	e45e                	sd	s7,8(sp)
    8000191a:	e062                	sd	s8,0(sp)
        offset = vma->offset + (va - vma->addr);
    8000191c:	8bbe                	mv	s7,a5
    8000191e:	1c87b783          	ld	a5,456(a5)
    80001922:	97ca                	add	a5,a5,s2
    80001924:	1a0bb683          	ld	a3,416(s7) # 11a0 <_entry-0x7fffee60>
    80001928:	40d78c33          	sub	s8,a5,a3
        ilock(vma->file->ip);
    8000192c:	6f08                	ld	a0,24(a4)
    8000192e:	73d020ef          	jal	8000486a <ilock>
        n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
    80001932:	1c0bb783          	ld	a5,448(s7)
    80001936:	6705                	lui	a4,0x1
    80001938:	000c069b          	sext.w	a3,s8
    8000193c:	865a                	mv	a2,s6
    8000193e:	4581                	li	a1,0
    80001940:	6f88                	ld	a0,24(a5)
    80001942:	300030ef          	jal	80004c42 <readi>
    80001946:	8c2a                	mv	s8,a0
        iunlock(vma->file->ip);
    80001948:	1c0bb783          	ld	a5,448(s7)
    8000194c:	6f88                	ld	a0,24(a5)
    8000194e:	7cb020ef          	jal	80004918 <iunlock>
        if (n < 0) {
    80001952:	f20c4ae3          	bltz	s8,80001886 <mmapfault+0x50>
    80001956:	6ba2                	ld	s7,8(sp)
    80001958:	6c02                	ld	s8,0(sp)
      if (vma->prot & PROT_READ)
    8000195a:	00349793          	slli	a5,s1,0x3
    8000195e:	8f85                	sub	a5,a5,s1
    80001960:	078e                	slli	a5,a5,0x3
    80001962:	99be                	add	s3,s3,a5
    80001964:	1b89a783          	lw	a5,440(s3) # 11b8 <_entry-0x7fffee48>
    80001968:	0017f693          	andi	a3,a5,1
        perm |= PTE_R;
    8000196c:	4749                	li	a4,18
      if (vma->prot & PROT_READ)
    8000196e:	e291                	bnez	a3,80001972 <mmapfault+0x13c>
      perm = PTE_U;
    80001970:	4741                	li	a4,16
      if (vma->prot & PROT_WRITE)
    80001972:	8b89                	andi	a5,a5,2
    80001974:	c399                	beqz	a5,8000197a <mmapfault+0x144>
        perm |= PTE_W;
    80001976:	00476713          	ori	a4,a4,4
      if (mappages(pagetable, va, PGSIZE, mem, perm) != 0) {
    8000197a:	86da                	mv	a3,s6
    8000197c:	6605                	lui	a2,0x1
    8000197e:	85ca                	mv	a1,s2
    80001980:	8552                	mv	a0,s4
    80001982:	803ff0ef          	jal	80001184 <mappages>
    80001986:	f00518e3          	bnez	a0,80001896 <mmapfault+0x60>
    8000198a:	6b42                	ld	s6,16(sp)
    8000198c:	a011                	j	80001990 <mmapfault+0x15a>

      return mem;
    }
  }

  return 0;
    8000198e:	4a81                	li	s5,0
}
    80001990:	8556                	mv	a0,s5
    80001992:	60a6                	ld	ra,72(sp)
    80001994:	6406                	ld	s0,64(sp)
    80001996:	74e2                	ld	s1,56(sp)
    80001998:	7942                	ld	s2,48(sp)
    8000199a:	79a2                	ld	s3,40(sp)
    8000199c:	7a02                	ld	s4,32(sp)
    8000199e:	6ae2                	ld	s5,24(sp)
    800019a0:	6161                	addi	sp,sp,80
    800019a2:	8082                	ret
    800019a4:	6b42                	ld	s6,16(sp)
    800019a6:	b7ed                	j	80001990 <mmapfault+0x15a>

00000000800019a8 <copyout>:
  while (len > 0) {
    800019a8:	0e070763          	beqz	a4,80001a96 <copyout+0xee>
{
    800019ac:	7159                	addi	sp,sp,-112
    800019ae:	f486                	sd	ra,104(sp)
    800019b0:	f0a2                	sd	s0,96(sp)
    800019b2:	e8ca                	sd	s2,80(sp)
    800019b4:	e4ce                	sd	s3,72(sp)
    800019b6:	e0d2                	sd	s4,64(sp)
    800019b8:	fc56                	sd	s5,56(sp)
    800019ba:	f85a                	sd	s6,48(sp)
    800019bc:	ec66                	sd	s9,24(sp)
    800019be:	1880                	addi	s0,sp,112
    800019c0:	8a2a                	mv	s4,a0
    800019c2:	8cae                	mv	s9,a1
    800019c4:	8ab2                	mv	s5,a2
    800019c6:	8b36                	mv	s6,a3
    800019c8:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(dstva);
    800019ca:	797d                	lui	s2,0xfffff
    800019cc:	01267933          	and	s2,a2,s2
    if (va0 >= MAXVA)
    800019d0:	57fd                	li	a5,-1
    800019d2:	83e9                	srli	a5,a5,0x1a
    800019d4:	0d27e363          	bltu	a5,s2,80001a9a <copyout+0xf2>
    800019d8:	eca6                	sd	s1,88(sp)
    800019da:	f45e                	sd	s7,40(sp)
    800019dc:	f062                	sd	s8,32(sp)
    800019de:	e86a                	sd	s10,16(sp)
    800019e0:	e46e                	sd	s11,8(sp)
    800019e2:	6c05                	lui	s8,0x1
    800019e4:	8bbe                	mv	s7,a5
    800019e6:	a889                	j	80001a38 <copyout+0x90>
    pte = walk(pagetable, va0, 0);
    800019e8:	4601                	li	a2,0
    800019ea:	85ca                	mv	a1,s2
    800019ec:	8552                	mv	a0,s4
    800019ee:	ebeff0ef          	jal	800010ac <walk>
    if (pte == 0 || (*pte & PTE_V) == 0)
    800019f2:	cd4d                	beqz	a0,80001aac <copyout+0x104>
    800019f4:	611c                	ld	a5,0(a0)
    800019f6:	0017f713          	andi	a4,a5,1
    800019fa:	cb69                	beqz	a4,80001acc <copyout+0x124>
    if (*pte & PTE_COW) {
    800019fc:	1007f793          	andi	a5,a5,256
    80001a00:	eba5                	bnez	a5,80001a70 <copyout+0xc8>
    if ((*pte & PTE_W) == 0)
    80001a02:	611c                	ld	a5,0(a0)
    80001a04:	8b91                	andi	a5,a5,4
    80001a06:	c3ed                	beqz	a5,80001ae8 <copyout+0x140>
    n = PGSIZE - (dstva - va0);
    80001a08:	01890db3          	add	s11,s2,s8
    80001a0c:	415d8d33          	sub	s10,s11,s5
    if (n > len)
    80001a10:	01a9f363          	bgeu	s3,s10,80001a16 <copyout+0x6e>
    80001a14:	8d4e                	mv	s10,s3
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001a16:	412a8533          	sub	a0,s5,s2
    80001a1a:	000d061b          	sext.w	a2,s10
    80001a1e:	85da                	mv	a1,s6
    80001a20:	9526                	add	a0,a0,s1
    80001a22:	c6eff0ef          	jal	80000e90 <memmove>
    len -= n;
    80001a26:	41a989b3          	sub	s3,s3,s10
    src += n;
    80001a2a:	9b6a                	add	s6,s6,s10
  while (len > 0) {
    80001a2c:	04098e63          	beqz	s3,80001a88 <copyout+0xe0>
    if (va0 >= MAXVA)
    80001a30:	07bbe763          	bltu	s7,s11,80001a9e <copyout+0xf6>
    80001a34:	896e                	mv	s2,s11
    80001a36:	8aee                	mv	s5,s11
    pa0 = walkaddr(pagetable, va0);
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	8552                	mv	a0,s4
    80001a3c:	f0aff0ef          	jal	80001146 <walkaddr>
    80001a40:	84aa                	mv	s1,a0
    if (pa0 == 0) {
    80001a42:	f15d                	bnez	a0,800019e8 <copyout+0x40>
      pa0 = vmfault(pagetable, psz, va0, 0);
    80001a44:	4681                	li	a3,0
    80001a46:	864a                	mv	a2,s2
    80001a48:	85e6                	mv	a1,s9
    80001a4a:	8552                	mv	a0,s4
    80001a4c:	c49ff0ef          	jal	80001694 <vmfault>
    80001a50:	84aa                	mv	s1,a0
      if (pa0 == 0)
    80001a52:	f959                	bnez	a0,800019e8 <copyout+0x40>
        pa0 = mmapfault(pagetable, va0, 0);
    80001a54:	4601                	li	a2,0
    80001a56:	85ca                	mv	a1,s2
    80001a58:	8552                	mv	a0,s4
    80001a5a:	dddff0ef          	jal	80001836 <mmapfault>
    80001a5e:	84aa                	mv	s1,a0
      if (pa0 == 0)
    80001a60:	f541                	bnez	a0,800019e8 <copyout+0x40>
        return -1;
    80001a62:	557d                	li	a0,-1
    80001a64:	64e6                	ld	s1,88(sp)
    80001a66:	7ba2                	ld	s7,40(sp)
    80001a68:	7c02                	ld	s8,32(sp)
    80001a6a:	6d42                	ld	s10,16(sp)
    80001a6c:	6da2                	ld	s11,8(sp)
    80001a6e:	a0a9                	j	80001ab8 <copyout+0x110>
      pa0 = cowalloc(pagetable, va0);
    80001a70:	85ca                	mv	a1,s2
    80001a72:	8552                	mv	a0,s4
    80001a74:	c9dff0ef          	jal	80001710 <cowalloc>
    80001a78:	84aa                	mv	s1,a0
      if (pa0 == 0)
    80001a7a:	c125                	beqz	a0,80001ada <copyout+0x132>
      pte = walk(pagetable, va0, 0);
    80001a7c:	4601                	li	a2,0
    80001a7e:	85ca                	mv	a1,s2
    80001a80:	8552                	mv	a0,s4
    80001a82:	e2aff0ef          	jal	800010ac <walk>
    80001a86:	bfb5                	j	80001a02 <copyout+0x5a>
  return 0;
    80001a88:	4501                	li	a0,0
    80001a8a:	64e6                	ld	s1,88(sp)
    80001a8c:	7ba2                	ld	s7,40(sp)
    80001a8e:	7c02                	ld	s8,32(sp)
    80001a90:	6d42                	ld	s10,16(sp)
    80001a92:	6da2                	ld	s11,8(sp)
    80001a94:	a015                	j	80001ab8 <copyout+0x110>
    80001a96:	4501                	li	a0,0
}
    80001a98:	8082                	ret
      return -1;
    80001a9a:	557d                	li	a0,-1
    80001a9c:	a831                	j	80001ab8 <copyout+0x110>
    80001a9e:	557d                	li	a0,-1
    80001aa0:	64e6                	ld	s1,88(sp)
    80001aa2:	7ba2                	ld	s7,40(sp)
    80001aa4:	7c02                	ld	s8,32(sp)
    80001aa6:	6d42                	ld	s10,16(sp)
    80001aa8:	6da2                	ld	s11,8(sp)
    80001aaa:	a039                	j	80001ab8 <copyout+0x110>
      return -1;
    80001aac:	557d                	li	a0,-1
    80001aae:	64e6                	ld	s1,88(sp)
    80001ab0:	7ba2                	ld	s7,40(sp)
    80001ab2:	7c02                	ld	s8,32(sp)
    80001ab4:	6d42                	ld	s10,16(sp)
    80001ab6:	6da2                	ld	s11,8(sp)
}
    80001ab8:	70a6                	ld	ra,104(sp)
    80001aba:	7406                	ld	s0,96(sp)
    80001abc:	6946                	ld	s2,80(sp)
    80001abe:	69a6                	ld	s3,72(sp)
    80001ac0:	6a06                	ld	s4,64(sp)
    80001ac2:	7ae2                	ld	s5,56(sp)
    80001ac4:	7b42                	ld	s6,48(sp)
    80001ac6:	6ce2                	ld	s9,24(sp)
    80001ac8:	6165                	addi	sp,sp,112
    80001aca:	8082                	ret
      return -1;
    80001acc:	557d                	li	a0,-1
    80001ace:	64e6                	ld	s1,88(sp)
    80001ad0:	7ba2                	ld	s7,40(sp)
    80001ad2:	7c02                	ld	s8,32(sp)
    80001ad4:	6d42                	ld	s10,16(sp)
    80001ad6:	6da2                	ld	s11,8(sp)
    80001ad8:	b7c5                	j	80001ab8 <copyout+0x110>
        return -1;
    80001ada:	557d                	li	a0,-1
    80001adc:	64e6                	ld	s1,88(sp)
    80001ade:	7ba2                	ld	s7,40(sp)
    80001ae0:	7c02                	ld	s8,32(sp)
    80001ae2:	6d42                	ld	s10,16(sp)
    80001ae4:	6da2                	ld	s11,8(sp)
    80001ae6:	bfc9                	j	80001ab8 <copyout+0x110>
      return -1;
    80001ae8:	557d                	li	a0,-1
    80001aea:	64e6                	ld	s1,88(sp)
    80001aec:	7ba2                	ld	s7,40(sp)
    80001aee:	7c02                	ld	s8,32(sp)
    80001af0:	6d42                	ld	s10,16(sp)
    80001af2:	6da2                	ld	s11,8(sp)
    80001af4:	b7d1                	j	80001ab8 <copyout+0x110>

0000000080001af6 <copyin>:
  while (len > 0) {
    80001af6:	cf59                	beqz	a4,80001b94 <copyin+0x9e>
{
    80001af8:	711d                	addi	sp,sp,-96
    80001afa:	ec86                	sd	ra,88(sp)
    80001afc:	e8a2                	sd	s0,80(sp)
    80001afe:	e4a6                	sd	s1,72(sp)
    80001b00:	e0ca                	sd	s2,64(sp)
    80001b02:	fc4e                	sd	s3,56(sp)
    80001b04:	f852                	sd	s4,48(sp)
    80001b06:	f456                	sd	s5,40(sp)
    80001b08:	f05a                	sd	s6,32(sp)
    80001b0a:	ec5e                	sd	s7,24(sp)
    80001b0c:	e862                	sd	s8,16(sp)
    80001b0e:	e466                	sd	s9,8(sp)
    80001b10:	1080                	addi	s0,sp,96
    80001b12:	8b2a                	mv	s6,a0
    80001b14:	8c2e                	mv	s8,a1
    80001b16:	8a32                	mv	s4,a2
    80001b18:	84b6                	mv	s1,a3
    80001b1a:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001b1c:	7bfd                	lui	s7,0xfffff
    n = PGSIZE - (srcva - va0);
    80001b1e:	6a85                	lui	s5,0x1
    80001b20:	a035                	j	80001b4c <copyin+0x56>
    80001b22:	40990cb3          	sub	s9,s2,s1
    80001b26:	9cd6                	add	s9,s9,s5
    if (n > len)
    80001b28:	0199f363          	bgeu	s3,s9,80001b2e <copyin+0x38>
    80001b2c:	8cce                	mv	s9,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001b2e:	412485b3          	sub	a1,s1,s2
    80001b32:	000c861b          	sext.w	a2,s9
    80001b36:	95aa                	add	a1,a1,a0
    80001b38:	8552                	mv	a0,s4
    80001b3a:	b56ff0ef          	jal	80000e90 <memmove>
    len -= n;
    80001b3e:	419989b3          	sub	s3,s3,s9
    dst += n;
    80001b42:	9a66                	add	s4,s4,s9
    srcva = va0 + PGSIZE;
    80001b44:	015904b3          	add	s1,s2,s5
  while (len > 0) {
    80001b48:	02098863          	beqz	s3,80001b78 <copyin+0x82>
    va0 = PGROUNDDOWN(srcva);
    80001b4c:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001b50:	85ca                	mv	a1,s2
    80001b52:	855a                	mv	a0,s6
    80001b54:	df2ff0ef          	jal	80001146 <walkaddr>
    if (pa0 == 0) {
    80001b58:	f569                	bnez	a0,80001b22 <copyin+0x2c>
      pa0 = vmfault(pagetable, psz, va0, 1);
    80001b5a:	4685                	li	a3,1
    80001b5c:	864a                	mv	a2,s2
    80001b5e:	85e2                	mv	a1,s8
    80001b60:	855a                	mv	a0,s6
    80001b62:	b33ff0ef          	jal	80001694 <vmfault>
      if (pa0 == 0)
    80001b66:	fd55                	bnez	a0,80001b22 <copyin+0x2c>
        pa0 = mmapfault(pagetable, va0, 1);
    80001b68:	4605                	li	a2,1
    80001b6a:	85ca                	mv	a1,s2
    80001b6c:	855a                	mv	a0,s6
    80001b6e:	cc9ff0ef          	jal	80001836 <mmapfault>
      if (pa0 == 0)
    80001b72:	f945                	bnez	a0,80001b22 <copyin+0x2c>
        return -1;
    80001b74:	557d                	li	a0,-1
    80001b76:	a011                	j	80001b7a <copyin+0x84>
  return 0;
    80001b78:	4501                	li	a0,0
}
    80001b7a:	60e6                	ld	ra,88(sp)
    80001b7c:	6446                	ld	s0,80(sp)
    80001b7e:	64a6                	ld	s1,72(sp)
    80001b80:	6906                	ld	s2,64(sp)
    80001b82:	79e2                	ld	s3,56(sp)
    80001b84:	7a42                	ld	s4,48(sp)
    80001b86:	7aa2                	ld	s5,40(sp)
    80001b88:	7b02                	ld	s6,32(sp)
    80001b8a:	6be2                	ld	s7,24(sp)
    80001b8c:	6c42                	ld	s8,16(sp)
    80001b8e:	6ca2                	ld	s9,8(sp)
    80001b90:	6125                	addi	sp,sp,96
    80001b92:	8082                	ret
  return 0;
    80001b94:	4501                	li	a0,0
}
    80001b96:	8082                	ret

0000000080001b98 <copyinstr>:
  while (got_null == 0 && max > 0) {
    80001b98:	cb61                	beqz	a4,80001c68 <copyinstr+0xd0>
{
    80001b9a:	715d                	addi	sp,sp,-80
    80001b9c:	e486                	sd	ra,72(sp)
    80001b9e:	e0a2                	sd	s0,64(sp)
    80001ba0:	fc26                	sd	s1,56(sp)
    80001ba2:	f84a                	sd	s2,48(sp)
    80001ba4:	f44e                	sd	s3,40(sp)
    80001ba6:	f052                	sd	s4,32(sp)
    80001ba8:	ec56                	sd	s5,24(sp)
    80001baa:	e85a                	sd	s6,16(sp)
    80001bac:	e45e                	sd	s7,8(sp)
    80001bae:	e062                	sd	s8,0(sp)
    80001bb0:	0880                	addi	s0,sp,80
    80001bb2:	8a2a                	mv	s4,a0
    80001bb4:	8b2e                	mv	s6,a1
    80001bb6:	8bb2                	mv	s7,a2
    80001bb8:	8c36                	mv	s8,a3
    80001bba:	893a                	mv	s2,a4
    va0 = PGROUNDDOWN(srcva);
    80001bbc:	7afd                	lui	s5,0xfffff
    n = PGSIZE - (srcva - va0);
    80001bbe:	6985                	lui	s3,0x1
    80001bc0:	a8a1                	j	80001c18 <copyinstr+0x80>
      pa0 = vmfault(pagetable, psz, va0, 1);
    80001bc2:	4685                	li	a3,1
    80001bc4:	8626                	mv	a2,s1
    80001bc6:	85da                	mv	a1,s6
    80001bc8:	8552                	mv	a0,s4
    80001bca:	acbff0ef          	jal	80001694 <vmfault>
      if (pa0 == 0)
    80001bce:	ed21                	bnez	a0,80001c26 <copyinstr+0x8e>
        pa0 = mmapfault(pagetable, va0, 1);
    80001bd0:	4605                	li	a2,1
    80001bd2:	85a6                	mv	a1,s1
    80001bd4:	8552                	mv	a0,s4
    80001bd6:	c61ff0ef          	jal	80001836 <mmapfault>
      if (pa0 == 0)
    80001bda:	e531                	bnez	a0,80001c26 <copyinstr+0x8e>
        return -1;
    80001bdc:	557d                	li	a0,-1
    80001bde:	a039                	j	80001bec <copyinstr+0x54>
        *dst = '\0';
    80001be0:	00078023          	sb	zero,0(a5)
    80001be4:	4785                	li	a5,1
  if (got_null) {
    80001be6:	37fd                	addiw	a5,a5,-1
    80001be8:	0007851b          	sext.w	a0,a5
}
    80001bec:	60a6                	ld	ra,72(sp)
    80001bee:	6406                	ld	s0,64(sp)
    80001bf0:	74e2                	ld	s1,56(sp)
    80001bf2:	7942                	ld	s2,48(sp)
    80001bf4:	79a2                	ld	s3,40(sp)
    80001bf6:	7a02                	ld	s4,32(sp)
    80001bf8:	6ae2                	ld	s5,24(sp)
    80001bfa:	6b42                	ld	s6,16(sp)
    80001bfc:	6ba2                	ld	s7,8(sp)
    80001bfe:	6c02                	ld	s8,0(sp)
    80001c00:	6161                	addi	sp,sp,80
    80001c02:	8082                	ret
    80001c04:	fff90713          	addi	a4,s2,-1 # ffffffffffffefff <end+0xffffffff7fdacf47>
    80001c08:	972a                	add	a4,a4,a0
      --max;
    80001c0a:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001c0e:	01348c33          	add	s8,s1,s3
  while (got_null == 0 && max > 0) {
    80001c12:	04e58563          	beq	a1,a4,80001c5c <copyinstr+0xc4>
{
    80001c16:	8bbe                	mv	s7,a5
    va0 = PGROUNDDOWN(srcva);
    80001c18:	015c74b3          	and	s1,s8,s5
    pa0 = walkaddr(pagetable, va0);
    80001c1c:	85a6                	mv	a1,s1
    80001c1e:	8552                	mv	a0,s4
    80001c20:	d26ff0ef          	jal	80001146 <walkaddr>
    if (pa0 == 0) {
    80001c24:	dd59                	beqz	a0,80001bc2 <copyinstr+0x2a>
    n = PGSIZE - (srcva - va0);
    80001c26:	41848633          	sub	a2,s1,s8
    80001c2a:	964e                	add	a2,a2,s3
    if (n > max)
    80001c2c:	00c97363          	bgeu	s2,a2,80001c32 <copyinstr+0x9a>
    80001c30:	864a                	mv	a2,s2
    char *p = (char *)(pa0 + (srcva - va0));
    80001c32:	409c0c33          	sub	s8,s8,s1
    80001c36:	9c2a                	add	s8,s8,a0
    while (n > 0) {
    80001c38:	c605                	beqz	a2,80001c60 <copyinstr+0xc8>
    80001c3a:	87de                	mv	a5,s7
    80001c3c:	855e                	mv	a0,s7
      if (*p == '\0') {
    80001c3e:	417c0733          	sub	a4,s8,s7
    while (n > 0) {
    80001c42:	965e                	add	a2,a2,s7
    80001c44:	85be                	mv	a1,a5
      if (*p == '\0') {
    80001c46:	00f706b3          	add	a3,a4,a5
    80001c4a:	0006c683          	lbu	a3,0(a3) # fffffffffffff000 <end+0xffffffff7fdacf48>
    80001c4e:	dac9                	beqz	a3,80001be0 <copyinstr+0x48>
        *dst = *p;
    80001c50:	00d78023          	sb	a3,0(a5)
      dst++;
    80001c54:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001c56:	fec797e3          	bne	a5,a2,80001c44 <copyinstr+0xac>
    80001c5a:	b76d                	j	80001c04 <copyinstr+0x6c>
    80001c5c:	4781                	li	a5,0
    80001c5e:	b761                	j	80001be6 <copyinstr+0x4e>
    srcva = va0 + PGSIZE;
    80001c60:	6c05                	lui	s8,0x1
    80001c62:	9c26                	add	s8,s8,s1
    80001c64:	87de                	mv	a5,s7
    80001c66:	bf45                	j	80001c16 <copyinstr+0x7e>
  int got_null = 0;
    80001c68:	4781                	li	a5,0
  if (got_null) {
    80001c6a:	37fd                	addiw	a5,a5,-1
    80001c6c:	0007851b          	sext.w	a0,a5
}
    80001c70:	8082                	ret

0000000080001c72 <mmap_unmap>:
// Unmap [addr, addr + length) from one of process p's VMA slots.
// For MAP_SHARED file mappings, modified pages are written back to disk first.
// Supports full unmap or trimming from either the start or end of a VMA.
int
mmap_unmap(struct proc *p, uint64 addr, uint64 length)
{
    80001c72:	7175                	addi	sp,sp,-144
    80001c74:	e506                	sd	ra,136(sp)
    80001c76:	e122                	sd	s0,128(sp)
    80001c78:	fca6                	sd	s1,120(sp)
    80001c7a:	f8ca                	sd	s2,112(sp)
    80001c7c:	f4ce                	sd	s3,104(sp)
    80001c7e:	f0d2                	sd	s4,96(sp)
    80001c80:	ecd6                	sd	s5,88(sp)
    80001c82:	e8da                	sd	s6,80(sp)
    80001c84:	e4de                	sd	s7,72(sp)
    80001c86:	e0e2                	sd	s8,64(sp)
    80001c88:	fc66                	sd	s9,56(sp)
    80001c8a:	f86a                	sd	s10,48(sp)
    80001c8c:	f46e                	sd	s11,40(sp)
    80001c8e:	0900                	addi	s0,sp,144
    80001c90:	8b2a                	mv	s6,a0
    80001c92:	8aae                	mv	s5,a1
  uint64 end;
  uint64 a;
  uint64 pa;
  pte_t *pte;

  length = PGROUNDUP(length);
    80001c94:	6785                	lui	a5,0x1
    80001c96:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001c98:	963e                	add	a2,a2,a5
    80001c9a:	77fd                	lui	a5,0xfffff
    80001c9c:	00f67d33          	and	s10,a2,a5

  for (int i = 0; i < NVMA; i++) {
    80001ca0:	19850793          	addi	a5,a0,408
    80001ca4:	4701                	li	a4,0
    80001ca6:	45c1                	li	a1,16
    80001ca8:	a031                	j	80001cb4 <mmap_unmap+0x42>
    80001caa:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80001cac:	03878793          	addi	a5,a5,56 # fffffffffffff038 <end+0xffffffff7fdacf80>
    80001cb0:	04b70b63          	beq	a4,a1,80001d06 <mmap_unmap+0x94>
    if (p->vmas[i].used &&
    80001cb4:	4394                	lw	a3,0(a5)
    80001cb6:	daf5                	beqz	a3,80001caa <mmap_unmap+0x38>
        addr >= p->vmas[i].addr &&
    80001cb8:	6794                	ld	a3,8(a5)
    if (p->vmas[i].used &&
    80001cba:	fedae8e3          	bltu	s5,a3,80001caa <mmap_unmap+0x38>
        addr < p->vmas[i].addr + p->vmas[i].maplen) {
    80001cbe:	6f90                	ld	a2,24(a5)
    80001cc0:	96b2                	add	a3,a3,a2
        addr >= p->vmas[i].addr &&
    80001cc2:	fedaf4e3          	bgeu	s5,a3,80001caa <mmap_unmap+0x38>
      vma = &p->vmas[i];
    80001cc6:	00371a13          	slli	s4,a4,0x3
    80001cca:	40ea0a33          	sub	s4,s4,a4
    80001cce:	0a0e                	slli	s4,s4,0x3
    80001cd0:	198a0a13          	addi	s4,s4,408
    80001cd4:	9a5a                	add	s4,s4,s6
      break;
    }
  }

  if (vma == 0)
    80001cd6:	180a0563          	beqz	s4,80001e60 <mmap_unmap+0x1ee>
    return -1;

  end = addr + length;
    80001cda:	015d0bb3          	add	s7,s10,s5
  if (end <= addr || end > vma->addr + vma->maplen)
    80001cde:	197af363          	bgeu	s5,s7,80001e64 <mmap_unmap+0x1f2>
    80001ce2:	008a3703          	ld	a4,8(s4)
    80001ce6:	018a3783          	ld	a5,24(s4)
    80001cea:	97ba                	add	a5,a5,a4
    80001cec:	1777ee63          	bltu	a5,s7,80001e68 <mmap_unmap+0x1f6>
    return -1;

  // Only whole-VMA unmaps or edge trims (no splitting into two VMAs).
  if (addr != vma->addr && end != vma->addr + vma->maplen)
    80001cf0:	03570b63          	beq	a4,s5,80001d26 <mmap_unmap+0xb4>
    80001cf4:	17779c63          	bne	a5,s7,80001e6c <mmap_unmap+0x1fa>
    80001cf8:	89d6                	mv	s3,s5
      continue;

    pa = PTE2PA(*pte);

    // Persist dirty data for shared file-backed mappings only.
    if ((vma->flags & MAP_SHARED) && !(vma->flags & MAP_ANONYMOUS) &&
    80001cfa:	4c95                	li	s9,5
    80001cfc:	1c82                	slli	s9,s9,0x20
    80001cfe:	4d85                	li	s11,1
    80001d00:	1d82                	slli	s11,s11,0x20
  for (a = addr; a < end; a += PGSIZE) {
    80001d02:	6c05                	lui	s8,0x1
    80001d04:	a8b9                	j	80001d62 <mmap_unmap+0xf0>
    return -1;
    80001d06:	557d                	li	a0,-1
    vma->maplen -= length;
    return 0;
  }

  return -1;
}
    80001d08:	60aa                	ld	ra,136(sp)
    80001d0a:	640a                	ld	s0,128(sp)
    80001d0c:	74e6                	ld	s1,120(sp)
    80001d0e:	7946                	ld	s2,112(sp)
    80001d10:	79a6                	ld	s3,104(sp)
    80001d12:	7a06                	ld	s4,96(sp)
    80001d14:	6ae6                	ld	s5,88(sp)
    80001d16:	6b46                	ld	s6,80(sp)
    80001d18:	6ba6                	ld	s7,72(sp)
    80001d1a:	6c06                	ld	s8,64(sp)
    80001d1c:	7ce2                	ld	s9,56(sp)
    80001d1e:	7d42                	ld	s10,48(sp)
    80001d20:	7da2                	ld	s11,40(sp)
    80001d22:	6149                	addi	sp,sp,144
    80001d24:	8082                	ret
    80001d26:	89d6                	mv	s3,s5
    80001d28:	bfc9                	j	80001cfa <mmap_unmap+0x88>
        writei(vma->file->ip, 0, pa, fileoff, remaining);
    80001d2a:	028a3783          	ld	a5,40(s4)
    80001d2e:	2701                	sext.w	a4,a4
    80001d30:	f7043683          	ld	a3,-144(s0)
    80001d34:	f8043603          	ld	a2,-128(s0)
    80001d38:	9eb1                	addw	a3,a3,a2
    80001d3a:	864a                	mv	a2,s2
    80001d3c:	4581                	li	a1,0
    80001d3e:	6f88                	ld	a0,24(a5)
    80001d40:	7ff020ef          	jal	80004d3e <writei>
        iunlock(vma->file->ip);
    80001d44:	028a3783          	ld	a5,40(s4)
    80001d48:	6f88                	ld	a0,24(a5)
    80001d4a:	3cf020ef          	jal	80004918 <iunlock>
        end_op();
    80001d4e:	5ea030ef          	jal	80005338 <end_op>
    kfree((void *)pa);
    80001d52:	854a                	mv	a0,s2
    80001d54:	c95fe0ef          	jal	800009e8 <kfree>
    *pte = 0;
    80001d58:	0004b023          	sd	zero,0(s1)
  for (a = addr; a < end; a += PGSIZE) {
    80001d5c:	99e2                	add	s3,s3,s8
    80001d5e:	0979f063          	bgeu	s3,s7,80001dde <mmap_unmap+0x16c>
    pte = walk(p->pagetable, a, 0);
    80001d62:	4601                	li	a2,0
    80001d64:	85ce                	mv	a1,s3
    80001d66:	090b3503          	ld	a0,144(s6) # 1090 <_entry-0x7fffef70>
    80001d6a:	b42ff0ef          	jal	800010ac <walk>
    80001d6e:	84aa                	mv	s1,a0
    if (pte == 0 || (*pte & PTE_V) == 0)
    80001d70:	d575                	beqz	a0,80001d5c <mmap_unmap+0xea>
    80001d72:	00053903          	ld	s2,0(a0)
    80001d76:	00197793          	andi	a5,s2,1
    80001d7a:	d3ed                	beqz	a5,80001d5c <mmap_unmap+0xea>
    pa = PTE2PA(*pte);
    80001d7c:	00a95913          	srli	s2,s2,0xa
    80001d80:	0932                	slli	s2,s2,0xc
    if ((vma->flags & MAP_SHARED) && !(vma->flags & MAP_ANONYMOUS) &&
    80001d82:	020a3783          	ld	a5,32(s4)
    80001d86:	0197f7b3          	and	a5,a5,s9
    80001d8a:	fdb794e3          	bne	a5,s11,80001d52 <mmap_unmap+0xe0>
    80001d8e:	028a3783          	ld	a5,40(s4)
    80001d92:	d3e1                	beqz	a5,80001d52 <mmap_unmap+0xe0>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001d94:	008a3783          	ld	a5,8(s4)
    80001d98:	f8f43423          	sd	a5,-120(s0)
    80001d9c:	40f987b3          	sub	a5,s3,a5
    80001da0:	f8f43023          	sd	a5,-128(s0)
      if (a - vma->addr < vma->length) {
    80001da4:	010a3703          	ld	a4,16(s4)
    80001da8:	f6e43c23          	sd	a4,-136(s0)
    80001dac:	fae7f3e3          	bgeu	a5,a4,80001d52 <mmap_unmap+0xe0>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001db0:	030a3783          	ld	a5,48(s4)
    80001db4:	f6f43823          	sd	a5,-144(s0)
        begin_op();
    80001db8:	4fa030ef          	jal	800052b2 <begin_op>
        ilock(vma->file->ip);
    80001dbc:	028a3783          	ld	a5,40(s4)
    80001dc0:	6f88                	ld	a0,24(a5)
    80001dc2:	2a9020ef          	jal	8000486a <ilock>
        uint64 remaining = vma->length - (a - vma->addr);
    80001dc6:	f8843783          	ld	a5,-120(s0)
    80001dca:	f7843703          	ld	a4,-136(s0)
    80001dce:	973e                	add	a4,a4,a5
    80001dd0:	41370733          	sub	a4,a4,s3
        if (remaining > PGSIZE)
    80001dd4:	6785                	lui	a5,0x1
    80001dd6:	f4e7fae3          	bgeu	a5,a4,80001d2a <mmap_unmap+0xb8>
    80001dda:	6705                	lui	a4,0x1
    80001ddc:	b7b9                	j	80001d2a <mmap_unmap+0xb8>
    80001dde:	12000073          	sfence.vma
  if (addr == vma->addr && end == vma->addr + vma->maplen) {
    80001de2:	008a3783          	ld	a5,8(s4)
    80001de6:	03578663          	beq	a5,s5,80001e12 <mmap_unmap+0x1a0>
  if (end == vma->addr + vma->maplen) {
    80001dea:	018a3703          	ld	a4,24(s4)
    80001dee:	97ba                	add	a5,a5,a4
    80001df0:	09779063          	bne	a5,s7,80001e70 <mmap_unmap+0x1fe>
    vma->length = (length >= vma->length) ? 0 : (vma->length - length);
    80001df4:	010a3683          	ld	a3,16(s4)
    80001df8:	4781                	li	a5,0
    80001dfa:	00dd7463          	bgeu	s10,a3,80001e02 <mmap_unmap+0x190>
    80001dfe:	41a687b3          	sub	a5,a3,s10
    80001e02:	00fa3823          	sd	a5,16(s4)
    vma->maplen -= length;
    80001e06:	41a70733          	sub	a4,a4,s10
    80001e0a:	00ea3c23          	sd	a4,24(s4)
    return 0;
    80001e0e:	4501                	li	a0,0
    80001e10:	bde5                	j	80001d08 <mmap_unmap+0x96>
  if (addr == vma->addr && end == vma->addr + vma->maplen) {
    80001e12:	018a3783          	ld	a5,24(s4)
    80001e16:	03a78863          	beq	a5,s10,80001e46 <mmap_unmap+0x1d4>
    vma->addr = end;
    80001e1a:	017a3423          	sd	s7,8(s4)
    vma->offset += length;
    80001e1e:	030a3703          	ld	a4,48(s4)
    80001e22:	976a                	add	a4,a4,s10
    80001e24:	02ea3823          	sd	a4,48(s4)
    vma->length = (length >= vma->length) ? 0 : (vma->length - length);
    80001e28:	010a3683          	ld	a3,16(s4)
    80001e2c:	4701                	li	a4,0
    80001e2e:	00dd7463          	bgeu	s10,a3,80001e36 <mmap_unmap+0x1c4>
    80001e32:	41a68733          	sub	a4,a3,s10
    80001e36:	00ea3823          	sd	a4,16(s4)
    vma->maplen -= length;
    80001e3a:	41a787b3          	sub	a5,a5,s10
    80001e3e:	00fa3c23          	sd	a5,24(s4)
    return 0;
    80001e42:	4501                	li	a0,0
    80001e44:	b5d1                	j	80001d08 <mmap_unmap+0x96>
    if (vma->file)
    80001e46:	028a3503          	ld	a0,40(s4)
    80001e4a:	c119                	beqz	a0,80001e50 <mmap_unmap+0x1de>
      fileclose(vma->file);
    80001e4c:	113030ef          	jal	8000575e <fileclose>
    memset(vma, 0, sizeof(*vma));
    80001e50:	03800613          	li	a2,56
    80001e54:	4581                	li	a1,0
    80001e56:	8552                	mv	a0,s4
    80001e58:	fddfe0ef          	jal	80000e34 <memset>
    return 0;
    80001e5c:	4501                	li	a0,0
    80001e5e:	b56d                	j	80001d08 <mmap_unmap+0x96>
    return -1;
    80001e60:	557d                	li	a0,-1
    80001e62:	b55d                	j	80001d08 <mmap_unmap+0x96>
    return -1;
    80001e64:	557d                	li	a0,-1
    80001e66:	b54d                	j	80001d08 <mmap_unmap+0x96>
    80001e68:	557d                	li	a0,-1
    80001e6a:	bd79                	j	80001d08 <mmap_unmap+0x96>
    return -1;
    80001e6c:	557d                	li	a0,-1
    80001e6e:	bd69                	j	80001d08 <mmap_unmap+0x96>
  return -1;
    80001e70:	557d                	li	a0,-1
    80001e72:	bd59                	j	80001d08 <mmap_unmap+0x96>

0000000080001e74 <mmap_cleanup>:

// Release all active memory mappings belonging to process p (on exit or exec).
void
mmap_cleanup(struct proc *p)
{
    80001e74:	7179                	addi	sp,sp,-48
    80001e76:	f406                	sd	ra,40(sp)
    80001e78:	f022                	sd	s0,32(sp)
    80001e7a:	ec26                	sd	s1,24(sp)
    80001e7c:	e84a                	sd	s2,16(sp)
    80001e7e:	e44e                	sd	s3,8(sp)
    80001e80:	1800                	addi	s0,sp,48
    80001e82:	89aa                	mv	s3,a0
  for (int i = 0; i < NVMA; i++) {
    80001e84:	19850493          	addi	s1,a0,408
    80001e88:	51850913          	addi	s2,a0,1304
    80001e8c:	a029                	j	80001e96 <mmap_cleanup+0x22>
    80001e8e:	03848493          	addi	s1,s1,56
    80001e92:	01248a63          	beq	s1,s2,80001ea6 <mmap_cleanup+0x32>
    if (p->vmas[i].used)
    80001e96:	409c                	lw	a5,0(s1)
    80001e98:	dbfd                	beqz	a5,80001e8e <mmap_cleanup+0x1a>
      mmap_unmap(p, p->vmas[i].addr, p->vmas[i].maplen);
    80001e9a:	6c90                	ld	a2,24(s1)
    80001e9c:	648c                	ld	a1,8(s1)
    80001e9e:	854e                	mv	a0,s3
    80001ea0:	dd3ff0ef          	jal	80001c72 <mmap_unmap>
    80001ea4:	b7ed                	j	80001e8e <mmap_cleanup+0x1a>
  }
    80001ea6:	70a2                	ld	ra,40(sp)
    80001ea8:	7402                	ld	s0,32(sp)
    80001eaa:	64e2                	ld	s1,24(sp)
    80001eac:	6942                	ld	s2,16(sp)
    80001eae:	69a2                	ld	s3,8(sp)
    80001eb0:	6145                	addi	sp,sp,48
    80001eb2:	8082                	ret

0000000080001eb4 <uint_to_str>:
}

// Convert an unsigned 64-bit integer to decimal in buf and return its length.
static int
uint_to_str(uint64 val, char *buf)
{
    80001eb4:	7179                	addi	sp,sp,-48
    80001eb6:	f422                	sd	s0,40(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	87aa                	mv	a5,a0
  char tmp[24];
  int len = 0;
    80001ebc:	fd840693          	addi	a3,s0,-40
    80001ec0:	4501                	li	a0,0

  do {
    tmp[len++] = '0' + (val % 10);
    80001ec2:	4629                	li	a2,10
    val /= 10;
  } while (val > 0);
    80001ec4:	48a5                	li	a7,9
    tmp[len++] = '0' + (val % 10);
    80001ec6:	882a                	mv	a6,a0
    80001ec8:	2505                	addiw	a0,a0,1
    80001eca:	02c7f733          	remu	a4,a5,a2
    80001ece:	0307071b          	addiw	a4,a4,48 # 1030 <_entry-0x7fffefd0>
    80001ed2:	00e68023          	sb	a4,0(a3)
    val /= 10;
    80001ed6:	873e                	mv	a4,a5
    80001ed8:	02c7d7b3          	divu	a5,a5,a2
  } while (val > 0);
    80001edc:	0685                	addi	a3,a3,1
    80001ede:	fee8e4e3          	bltu	a7,a4,80001ec6 <uint_to_str+0x12>

  for (int i = 0; i < len; i++)
    80001ee2:	02a05263          	blez	a0,80001f06 <uint_to_str+0x52>
    80001ee6:	fd840793          	addi	a5,s0,-40
    80001eea:	010786b3          	add	a3,a5,a6
    80001eee:	87ae                	mv	a5,a1
    buf[i] = tmp[len - 1 - i];
    80001ef0:	0006c703          	lbu	a4,0(a3)
    80001ef4:	00e78023          	sb	a4,0(a5) # 1000 <_entry-0x7ffff000>
  for (int i = 0; i < len; i++)
    80001ef8:	16fd                	addi	a3,a3,-1
    80001efa:	0785                	addi	a5,a5,1
    80001efc:	40b7873b          	subw	a4,a5,a1
    80001f00:	377d                	addiw	a4,a4,-1
    80001f02:	ff0747e3          	blt	a4,a6,80001ef0 <uint_to_str+0x3c>
  buf[len] = '\0';
    80001f06:	95aa                	add	a1,a1,a0
    80001f08:	00058023          	sb	zero,0(a1)
  return len;
}
    80001f0c:	7422                	ld	s0,40(sp)
    80001f0e:	6145                	addi	sp,sp,48
    80001f10:	8082                	ret

0000000080001f12 <print_ptree_nodes>:
    // clang-format on
  };
  int i, d;
  char *st;

  if(depth > 16)
    80001f12:	47c1                	li	a5,16
    80001f14:	0ed7c063          	blt	a5,a3,80001ff4 <print_ptree_nodes+0xe2>
{
    80001f18:	711d                	addi	sp,sp,-96
    80001f1a:	ec86                	sd	ra,88(sp)
    80001f1c:	e8a2                	sd	s0,80(sp)
    80001f1e:	fc4e                	sd	s3,56(sp)
    80001f20:	f852                	sd	s4,48(sp)
    80001f22:	f456                	sd	s5,40(sp)
    80001f24:	e862                	sd	s8,16(sp)
    80001f26:	1080                	addi	s0,sp,96
    80001f28:	8c2a                	mv	s8,a0
    80001f2a:	8aae                	mv	s5,a1
    80001f2c:	8a32                	mv	s4,a2
    80001f2e:	89b6                	mv	s3,a3
    return;

  for(i = 0; i < count; i++){
    80001f30:	02b05663          	blez	a1,80001f5c <print_ptree_nodes+0x4a>
    80001f34:	e4a6                	sd	s1,72(sp)
    80001f36:	f05a                	sd	s6,32(sp)
    80001f38:	ec5e                	sd	s7,24(sp)
    80001f3a:	01050493          	addi	s1,a0,16
    80001f3e:	00559b93          	slli	s7,a1,0x5
    80001f42:	9ba6                	add	s7,s7,s1
    if(nodes[i].ppid == ppid){
    80001f44:	8b26                	mv	s6,s1
    80001f46:	ff44a783          	lw	a5,-12(s1)
    80001f4a:	03478163          	beq	a5,s4,80001f6c <print_ptree_nodes+0x5a>
  for(i = 0; i < count; i++){
    80001f4e:	02048493          	addi	s1,s1,32
    80001f52:	ff7499e3          	bne	s1,s7,80001f44 <print_ptree_nodes+0x32>
    80001f56:	64a6                	ld	s1,72(sp)
    80001f58:	7b02                	ld	s6,32(sp)
    80001f5a:	6be2                	ld	s7,24(sp)
      printk("[%d] %s (prio=%d, state=%s)\n",
             nodes[i].pid, nodes[i].name, nodes[i].priority, st);
      print_ptree_nodes(nodes, count, nodes[i].pid, depth + 1);
    }
  }
}
    80001f5c:	60e6                	ld	ra,88(sp)
    80001f5e:	6446                	ld	s0,80(sp)
    80001f60:	79e2                	ld	s3,56(sp)
    80001f62:	7a42                	ld	s4,48(sp)
    80001f64:	7aa2                	ld	s5,40(sp)
    80001f66:	6c42                	ld	s8,16(sp)
    80001f68:	6125                	addi	sp,sp,96
    80001f6a:	8082                	ret
      for(d = 0; d < depth; d++)
    80001f6c:	03305763          	blez	s3,80001f9a <print_ptree_nodes+0x88>
    80001f70:	e0ca                	sd	s2,64(sp)
    80001f72:	e466                	sd	s9,8(sp)
    80001f74:	4901                	li	s2,0
        printk("  ");
    80001f76:	00007c97          	auipc	s9,0x7
    80001f7a:	212c8c93          	addi	s9,s9,530 # 80009188 <etext+0x188>
    80001f7e:	8566                	mv	a0,s9
    80001f80:	d8afe0ef          	jal	8000050a <printk>
      for(d = 0; d < depth; d++)
    80001f84:	2905                	addiw	s2,s2,1
    80001f86:	ff299ce3          	bne	s3,s2,80001f7e <print_ptree_nodes+0x6c>
        printk("|-- ");
    80001f8a:	00007517          	auipc	a0,0x7
    80001f8e:	20650513          	addi	a0,a0,518 # 80009190 <etext+0x190>
    80001f92:	d78fe0ef          	jal	8000050a <printk>
    80001f96:	6906                	ld	s2,64(sp)
    80001f98:	6ca2                	ld	s9,8(sp)
      if(nodes[i].state >= 0 && nodes[i].state < NELEM(states) && states[nodes[i].state])
    80001f9a:	ffcb2783          	lw	a5,-4(s6)
    80001f9e:	4695                	li	a3,5
        st = "???";
    80001fa0:	00007717          	auipc	a4,0x7
    80001fa4:	1e070713          	addi	a4,a4,480 # 80009180 <etext+0x180>
      if(nodes[i].state >= 0 && nodes[i].state < NELEM(states) && states[nodes[i].state])
    80001fa8:	00f6ed63          	bltu	a3,a5,80001fc2 <print_ptree_nodes+0xb0>
    80001fac:	02079713          	slli	a4,a5,0x20
    80001fb0:	01d75793          	srli	a5,a4,0x1d
    80001fb4:	00008717          	auipc	a4,0x8
    80001fb8:	a9470713          	addi	a4,a4,-1388 # 80009a48 <states.0>
    80001fbc:	97ba                	add	a5,a5,a4
    80001fbe:	6398                	ld	a4,0(a5)
    80001fc0:	c70d                	beqz	a4,80001fea <print_ptree_nodes+0xd8>
      printk("[%d] %s (prio=%d, state=%s)\n",
    80001fc2:	ff8b2683          	lw	a3,-8(s6)
    80001fc6:	865a                	mv	a2,s6
    80001fc8:	ff0b2583          	lw	a1,-16(s6)
    80001fcc:	00007517          	auipc	a0,0x7
    80001fd0:	1cc50513          	addi	a0,a0,460 # 80009198 <etext+0x198>
    80001fd4:	d36fe0ef          	jal	8000050a <printk>
      print_ptree_nodes(nodes, count, nodes[i].pid, depth + 1);
    80001fd8:	0019869b          	addiw	a3,s3,1 # 1001 <_entry-0x7fffefff>
    80001fdc:	ff0b2603          	lw	a2,-16(s6)
    80001fe0:	85d6                	mv	a1,s5
    80001fe2:	8562                	mv	a0,s8
    80001fe4:	f2fff0ef          	jal	80001f12 <print_ptree_nodes>
    80001fe8:	b79d                	j	80001f4e <print_ptree_nodes+0x3c>
        st = "???";
    80001fea:	00007717          	auipc	a4,0x7
    80001fee:	19670713          	addi	a4,a4,406 # 80009180 <etext+0x180>
    80001ff2:	bfc1                	j	80001fc2 <print_ptree_nodes+0xb0>
    80001ff4:	8082                	ret

0000000080001ff6 <print_col>:
{
    80001ff6:	7179                	addi	sp,sp,-48
    80001ff8:	f406                	sd	ra,40(sp)
    80001ffa:	f022                	sd	s0,32(sp)
    80001ffc:	ec26                	sd	s1,24(sp)
    80001ffe:	e84a                	sd	s2,16(sp)
    80002000:	e44e                	sd	s3,8(sp)
    80002002:	1800                	addi	s0,sp,48
    80002004:	89aa                	mv	s3,a0
    80002006:	892e                	mv	s2,a1
  int len = strlen(s);
    80002008:	f9dfe0ef          	jal	80000fa4 <strlen>
    8000200c:	84aa                	mv	s1,a0
  printk("%s", (char *)s);
    8000200e:	85ce                	mv	a1,s3
    80002010:	00007517          	auipc	a0,0x7
    80002014:	1a850513          	addi	a0,a0,424 # 800091b8 <etext+0x1b8>
    80002018:	cf2fe0ef          	jal	8000050a <printk>
  if (len < width) {
    8000201c:	0324d363          	bge	s1,s2,80002042 <print_col+0x4c>
      printk(" ");
    80002020:	00007997          	auipc	s3,0x7
    80002024:	1a098993          	addi	s3,s3,416 # 800091c0 <etext+0x1c0>
    80002028:	854e                	mv	a0,s3
    8000202a:	ce0fe0ef          	jal	8000050a <printk>
    for (int i = len; i < width; i++)
    8000202e:	2485                	addiw	s1,s1,1
    80002030:	fe991ce3          	bne	s2,s1,80002028 <print_col+0x32>
}
    80002034:	70a2                	ld	ra,40(sp)
    80002036:	7402                	ld	s0,32(sp)
    80002038:	64e2                	ld	s1,24(sp)
    8000203a:	6942                	ld	s2,16(sp)
    8000203c:	69a2                	ld	s3,8(sp)
    8000203e:	6145                	addi	sp,sp,48
    80002040:	8082                	ret
    printk(" ");
    80002042:	00007517          	auipc	a0,0x7
    80002046:	17e50513          	addi	a0,a0,382 # 800091c0 <etext+0x1c0>
    8000204a:	cc0fe0ef          	jal	8000050a <printk>
}
    8000204e:	b7dd                	j	80002034 <print_col+0x3e>

0000000080002050 <proc_mapstacks>:
{
    80002050:	7139                	addi	sp,sp,-64
    80002052:	fc06                	sd	ra,56(sp)
    80002054:	f822                	sd	s0,48(sp)
    80002056:	f426                	sd	s1,40(sp)
    80002058:	f04a                	sd	s2,32(sp)
    8000205a:	ec4e                	sd	s3,24(sp)
    8000205c:	e852                	sd	s4,16(sp)
    8000205e:	e456                	sd	s5,8(sp)
    80002060:	e05a                	sd	s6,0(sp)
    80002062:	0080                	addi	s0,sp,64
    80002064:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002066:	00230497          	auipc	s1,0x230
    8000206a:	27248493          	addi	s1,s1,626 # 802322d8 <proc>
    uint64 va = KSTACK((int)(p - proc));
    8000206e:	8b26                	mv	s6,s1
    80002070:	ffcfe937          	lui	s2,0xffcfe
    80002074:	72d90913          	addi	s2,s2,1837 # ffffffffffcfe72d <end+0xffffffff7faac675>
    80002078:	093e                	slli	s2,s2,0xf
    8000207a:	f3990913          	addi	s2,s2,-199
    8000207e:	0932                	slli	s2,s2,0xc
    80002080:	67f90913          	addi	s2,s2,1663
    80002084:	0936                	slli	s2,s2,0xd
    80002086:	72d90913          	addi	s2,s2,1837
    8000208a:	040009b7          	lui	s3,0x4000
    8000208e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80002090:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80002092:	00245a97          	auipc	s5,0x245
    80002096:	c46a8a93          	addi	s5,s5,-954 # 80246cd8 <tickslock>
    char *pa = kalloc();
    8000209a:	aa5fe0ef          	jal	80000b3e <kalloc>
    8000209e:	862a                	mv	a2,a0
    if (pa == 0)
    800020a0:	cd15                	beqz	a0,800020dc <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int)(p - proc));
    800020a2:	416485b3          	sub	a1,s1,s6
    800020a6:	858d                	srai	a1,a1,0x3
    800020a8:	032585b3          	mul	a1,a1,s2
    800020ac:	2585                	addiw	a1,a1,1
    800020ae:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800020b2:	4719                	li	a4,6
    800020b4:	6685                	lui	a3,0x1
    800020b6:	40b985b3          	sub	a1,s3,a1
    800020ba:	8552                	mv	a0,s4
    800020bc:	978ff0ef          	jal	80001234 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020c0:	52848493          	addi	s1,s1,1320
    800020c4:	fd549be3          	bne	s1,s5,8000209a <proc_mapstacks+0x4a>
}
    800020c8:	70e2                	ld	ra,56(sp)
    800020ca:	7442                	ld	s0,48(sp)
    800020cc:	74a2                	ld	s1,40(sp)
    800020ce:	7902                	ld	s2,32(sp)
    800020d0:	69e2                	ld	s3,24(sp)
    800020d2:	6a42                	ld	s4,16(sp)
    800020d4:	6aa2                	ld	s5,8(sp)
    800020d6:	6b02                	ld	s6,0(sp)
    800020d8:	6121                	addi	sp,sp,64
    800020da:	8082                	ret
      panic("kalloc");
    800020dc:	00007517          	auipc	a0,0x7
    800020e0:	0ec50513          	addi	a0,a0,236 # 800091c8 <etext+0x1c8>
    800020e4:	f0cfe0ef          	jal	800007f0 <panic>

00000000800020e8 <procinit>:
{
    800020e8:	7139                	addi	sp,sp,-64
    800020ea:	fc06                	sd	ra,56(sp)
    800020ec:	f822                	sd	s0,48(sp)
    800020ee:	f426                	sd	s1,40(sp)
    800020f0:	f04a                	sd	s2,32(sp)
    800020f2:	ec4e                	sd	s3,24(sp)
    800020f4:	e852                	sd	s4,16(sp)
    800020f6:	e456                	sd	s5,8(sp)
    800020f8:	e05a                	sd	s6,0(sp)
    800020fa:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    800020fc:	00007597          	auipc	a1,0x7
    80002100:	0d458593          	addi	a1,a1,212 # 800091d0 <etext+0x1d0>
    80002104:	00230517          	auipc	a0,0x230
    80002108:	da450513          	addi	a0,a0,-604 # 80231ea8 <pid_lock>
    8000210c:	beffe0ef          	jal	80000cfa <initlock>
  initlock(&wait_lock, "wait_lock");
    80002110:	00007597          	auipc	a1,0x7
    80002114:	0c858593          	addi	a1,a1,200 # 800091d8 <etext+0x1d8>
    80002118:	00230517          	auipc	a0,0x230
    8000211c:	da850513          	addi	a0,a0,-600 # 80231ec0 <wait_lock>
    80002120:	bdbfe0ef          	jal	80000cfa <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002124:	00230497          	auipc	s1,0x230
    80002128:	1b448493          	addi	s1,s1,436 # 802322d8 <proc>
    initlock(&p->lock, "proc");
    8000212c:	00007b17          	auipc	s6,0x7
    80002130:	0bcb0b13          	addi	s6,s6,188 # 800091e8 <etext+0x1e8>
    p->kstack = KSTACK((int)(p - proc));
    80002134:	8aa6                	mv	s5,s1
    80002136:	ffcfe937          	lui	s2,0xffcfe
    8000213a:	72d90913          	addi	s2,s2,1837 # ffffffffffcfe72d <end+0xffffffff7faac675>
    8000213e:	093e                	slli	s2,s2,0xf
    80002140:	f3990913          	addi	s2,s2,-199
    80002144:	0932                	slli	s2,s2,0xc
    80002146:	67f90913          	addi	s2,s2,1663
    8000214a:	0936                	slli	s2,s2,0xd
    8000214c:	72d90913          	addi	s2,s2,1837
    80002150:	040009b7          	lui	s3,0x4000
    80002154:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80002156:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80002158:	00245a17          	auipc	s4,0x245
    8000215c:	b80a0a13          	addi	s4,s4,-1152 # 80246cd8 <tickslock>
    initlock(&p->lock, "proc");
    80002160:	85da                	mv	a1,s6
    80002162:	8526                	mv	a0,s1
    80002164:	b97fe0ef          	jal	80000cfa <initlock>
    p->state = UNUSED;
    80002168:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000216c:	415487b3          	sub	a5,s1,s5
    80002170:	878d                	srai	a5,a5,0x3
    80002172:	032787b3          	mul	a5,a5,s2
    80002176:	2785                	addiw	a5,a5,1
    80002178:	00d7979b          	slliw	a5,a5,0xd
    8000217c:	40f987b3          	sub	a5,s3,a5
    80002180:	e0dc                	sd	a5,128(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80002182:	52848493          	addi	s1,s1,1320
    80002186:	fd449de3          	bne	s1,s4,80002160 <procinit+0x78>
}
    8000218a:	70e2                	ld	ra,56(sp)
    8000218c:	7442                	ld	s0,48(sp)
    8000218e:	74a2                	ld	s1,40(sp)
    80002190:	7902                	ld	s2,32(sp)
    80002192:	69e2                	ld	s3,24(sp)
    80002194:	6a42                	ld	s4,16(sp)
    80002196:	6aa2                	ld	s5,8(sp)
    80002198:	6b02                	ld	s6,0(sp)
    8000219a:	6121                	addi	sp,sp,64
    8000219c:	8082                	ret

000000008000219e <cpuid>:
{
    8000219e:	1141                	addi	sp,sp,-16
    800021a0:	e422                	sd	s0,8(sp)
    800021a2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800021a4:	8512                	mv	a0,tp
}
    800021a6:	2501                	sext.w	a0,a0
    800021a8:	6422                	ld	s0,8(sp)
    800021aa:	0141                	addi	sp,sp,16
    800021ac:	8082                	ret

00000000800021ae <mycpu>:
{
    800021ae:	1141                	addi	sp,sp,-16
    800021b0:	e422                	sd	s0,8(sp)
    800021b2:	0800                	addi	s0,sp,16
    800021b4:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800021b6:	2781                	sext.w	a5,a5
    800021b8:	079e                	slli	a5,a5,0x7
}
    800021ba:	00230517          	auipc	a0,0x230
    800021be:	d1e50513          	addi	a0,a0,-738 # 80231ed8 <cpus>
    800021c2:	953e                	add	a0,a0,a5
    800021c4:	6422                	ld	s0,8(sp)
    800021c6:	0141                	addi	sp,sp,16
    800021c8:	8082                	ret

00000000800021ca <myproc>:
{
    800021ca:	1101                	addi	sp,sp,-32
    800021cc:	ec06                	sd	ra,24(sp)
    800021ce:	e822                	sd	s0,16(sp)
    800021d0:	e426                	sd	s1,8(sp)
    800021d2:	1000                	addi	s0,sp,32
  push_off();
    800021d4:	b67fe0ef          	jal	80000d3a <push_off>
    800021d8:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800021da:	2781                	sext.w	a5,a5
    800021dc:	079e                	slli	a5,a5,0x7
    800021de:	00230717          	auipc	a4,0x230
    800021e2:	cca70713          	addi	a4,a4,-822 # 80231ea8 <pid_lock>
    800021e6:	97ba                	add	a5,a5,a4
    800021e8:	7b84                	ld	s1,48(a5)
  pop_off();
    800021ea:	bc7fe0ef          	jal	80000db0 <pop_off>
}
    800021ee:	8526                	mv	a0,s1
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6105                	addi	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <forkret>:
{
    800021fa:	7179                	addi	sp,sp,-48
    800021fc:	f406                	sd	ra,40(sp)
    800021fe:	f022                	sd	s0,32(sp)
    80002200:	ec26                	sd	s1,24(sp)
    80002202:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002204:	fc7ff0ef          	jal	800021ca <myproc>
    80002208:	84aa                	mv	s1,a0
  release(&p->lock);
    8000220a:	bf3fe0ef          	jal	80000dfc <release>
  if (first) {
    8000220e:	00008797          	auipc	a5,0x8
    80002212:	b327a783          	lw	a5,-1230(a5) # 80009d40 <first.2>
    80002216:	cb9d                	beqz	a5,8000224c <forkret+0x52>
    first = 0;
    80002218:	00008797          	auipc	a5,0x8
    8000221c:	b207a423          	sw	zero,-1240(a5) # 80009d40 <first.2>
    fsinit(ROOTDEV);
    80002220:	4505                	li	a0,1
    80002222:	185020ef          	jal	80004ba6 <fsinit>
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80002226:	00007517          	auipc	a0,0x7
    8000222a:	fca50513          	addi	a0,a0,-54 # 800091f0 <etext+0x1f0>
    8000222e:	fca43823          	sd	a0,-48(s0)
    80002232:	fc043c23          	sd	zero,-40(s0)
    80002236:	fd040593          	addi	a1,s0,-48
    8000223a:	375030ef          	jal	80005dae <kexec>
    8000223e:	6cdc                	ld	a5,152(s1)
    80002240:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80002242:	6cdc                	ld	a5,152(s1)
    80002244:	7bb8                	ld	a4,112(a5)
    80002246:	57fd                	li	a5,-1
    80002248:	02f70d63          	beq	a4,a5,80002282 <forkret+0x88>
  prepare_return();
    8000224c:	270010ef          	jal	800034bc <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002250:	68c8                	ld	a0,144(s1)
    80002252:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002254:	04000737          	lui	a4,0x4000
    80002258:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000225a:	0732                	slli	a4,a4,0xc
    8000225c:	00006797          	auipc	a5,0x6
    80002260:	e4078793          	addi	a5,a5,-448 # 8000809c <userret>
    80002264:	00006697          	auipc	a3,0x6
    80002268:	d9c68693          	addi	a3,a3,-612 # 80008000 <_trampoline>
    8000226c:	8f95                	sub	a5,a5,a3
    8000226e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002270:	577d                	li	a4,-1
    80002272:	177e                	slli	a4,a4,0x3f
    80002274:	8d59                	or	a0,a0,a4
    80002276:	9782                	jalr	a5
}
    80002278:	70a2                	ld	ra,40(sp)
    8000227a:	7402                	ld	s0,32(sp)
    8000227c:	64e2                	ld	s1,24(sp)
    8000227e:	6145                	addi	sp,sp,48
    80002280:	8082                	ret
      panic("exec");
    80002282:	00007517          	auipc	a0,0x7
    80002286:	f7650513          	addi	a0,a0,-138 # 800091f8 <etext+0x1f8>
    8000228a:	d66fe0ef          	jal	800007f0 <panic>

000000008000228e <allocpid>:
{
    8000228e:	1101                	addi	sp,sp,-32
    80002290:	ec06                	sd	ra,24(sp)
    80002292:	e822                	sd	s0,16(sp)
    80002294:	e426                	sd	s1,8(sp)
    80002296:	e04a                	sd	s2,0(sp)
    80002298:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000229a:	00230917          	auipc	s2,0x230
    8000229e:	c0e90913          	addi	s2,s2,-1010 # 80231ea8 <pid_lock>
    800022a2:	854a                	mv	a0,s2
    800022a4:	acdfe0ef          	jal	80000d70 <acquire>
  pid = nextpid;
    800022a8:	00008797          	auipc	a5,0x8
    800022ac:	a9c78793          	addi	a5,a5,-1380 # 80009d44 <nextpid>
    800022b0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800022b2:	0014871b          	addiw	a4,s1,1
    800022b6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800022b8:	854a                	mv	a0,s2
    800022ba:	b43fe0ef          	jal	80000dfc <release>
}
    800022be:	8526                	mv	a0,s1
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	64a2                	ld	s1,8(sp)
    800022c6:	6902                	ld	s2,0(sp)
    800022c8:	6105                	addi	sp,sp,32
    800022ca:	8082                	ret

00000000800022cc <proc_pagetable>:
{
    800022cc:	1101                	addi	sp,sp,-32
    800022ce:	ec06                	sd	ra,24(sp)
    800022d0:	e822                	sd	s0,16(sp)
    800022d2:	e426                	sd	s1,8(sp)
    800022d4:	e04a                	sd	s2,0(sp)
    800022d6:	1000                	addi	s0,sp,32
    800022d8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800022da:	862ff0ef          	jal	8000133c <uvmcreate>
    800022de:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800022e0:	cd05                	beqz	a0,80002318 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800022e2:	4729                	li	a4,10
    800022e4:	00006697          	auipc	a3,0x6
    800022e8:	d1c68693          	addi	a3,a3,-740 # 80008000 <_trampoline>
    800022ec:	6605                	lui	a2,0x1
    800022ee:	040005b7          	lui	a1,0x4000
    800022f2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800022f4:	05b2                	slli	a1,a1,0xc
    800022f6:	e8ffe0ef          	jal	80001184 <mappages>
    800022fa:	02054663          	bltz	a0,80002326 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    800022fe:	4719                	li	a4,6
    80002300:	09893683          	ld	a3,152(s2)
    80002304:	6605                	lui	a2,0x1
    80002306:	020005b7          	lui	a1,0x2000
    8000230a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000230c:	05b6                	slli	a1,a1,0xd
    8000230e:	8526                	mv	a0,s1
    80002310:	e75fe0ef          	jal	80001184 <mappages>
    80002314:	00054f63          	bltz	a0,80002332 <proc_pagetable+0x66>
}
    80002318:	8526                	mv	a0,s1
    8000231a:	60e2                	ld	ra,24(sp)
    8000231c:	6442                	ld	s0,16(sp)
    8000231e:	64a2                	ld	s1,8(sp)
    80002320:	6902                	ld	s2,0(sp)
    80002322:	6105                	addi	sp,sp,32
    80002324:	8082                	ret
    uvmfree(pagetable, 0);
    80002326:	4581                	li	a1,0
    80002328:	8526                	mv	a0,s1
    8000232a:	a0cff0ef          	jal	80001536 <uvmfree>
    return 0;
    8000232e:	4481                	li	s1,0
    80002330:	b7e5                	j	80002318 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002332:	4681                	li	a3,0
    80002334:	4605                	li	a2,1
    80002336:	040005b7          	lui	a1,0x4000
    8000233a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000233c:	05b2                	slli	a1,a1,0xc
    8000233e:	8526                	mv	a0,s1
    80002340:	822ff0ef          	jal	80001362 <uvmunmap>
    uvmfree(pagetable, 0);
    80002344:	4581                	li	a1,0
    80002346:	8526                	mv	a0,s1
    80002348:	9eeff0ef          	jal	80001536 <uvmfree>
    return 0;
    8000234c:	4481                	li	s1,0
    8000234e:	b7e9                	j	80002318 <proc_pagetable+0x4c>

0000000080002350 <proc_freepagetable>:
{
    80002350:	1101                	addi	sp,sp,-32
    80002352:	ec06                	sd	ra,24(sp)
    80002354:	e822                	sd	s0,16(sp)
    80002356:	e426                	sd	s1,8(sp)
    80002358:	e04a                	sd	s2,0(sp)
    8000235a:	1000                	addi	s0,sp,32
    8000235c:	84aa                	mv	s1,a0
    8000235e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002360:	4681                	li	a3,0
    80002362:	4605                	li	a2,1
    80002364:	040005b7          	lui	a1,0x4000
    80002368:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000236a:	05b2                	slli	a1,a1,0xc
    8000236c:	ff7fe0ef          	jal	80001362 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002370:	4681                	li	a3,0
    80002372:	4605                	li	a2,1
    80002374:	020005b7          	lui	a1,0x2000
    80002378:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000237a:	05b6                	slli	a1,a1,0xd
    8000237c:	8526                	mv	a0,s1
    8000237e:	fe5fe0ef          	jal	80001362 <uvmunmap>
  uvmfree(pagetable, sz);
    80002382:	85ca                	mv	a1,s2
    80002384:	8526                	mv	a0,s1
    80002386:	9b0ff0ef          	jal	80001536 <uvmfree>
}
    8000238a:	60e2                	ld	ra,24(sp)
    8000238c:	6442                	ld	s0,16(sp)
    8000238e:	64a2                	ld	s1,8(sp)
    80002390:	6902                	ld	s2,0(sp)
    80002392:	6105                	addi	sp,sp,32
    80002394:	8082                	ret

0000000080002396 <freeproc>:
{
    80002396:	1101                	addi	sp,sp,-32
    80002398:	ec06                	sd	ra,24(sp)
    8000239a:	e822                	sd	s0,16(sp)
    8000239c:	e426                	sd	s1,8(sp)
    8000239e:	1000                	addi	s0,sp,32
    800023a0:	84aa                	mv	s1,a0
  if (p->trapframe)
    800023a2:	6d48                	ld	a0,152(a0)
    800023a4:	c119                	beqz	a0,800023aa <freeproc+0x14>
    kfree((void *)p->trapframe);
    800023a6:	e42fe0ef          	jal	800009e8 <kfree>
  p->trapframe = 0;
    800023aa:	0804bc23          	sd	zero,152(s1)
  if (p->pagetable)
    800023ae:	68c8                	ld	a0,144(s1)
    800023b0:	c501                	beqz	a0,800023b8 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800023b2:	64cc                	ld	a1,136(s1)
    800023b4:	f9dff0ef          	jal	80002350 <proc_freepagetable>
  p->pagetable = 0;
    800023b8:	0804b823          	sd	zero,144(s1)
  p->sz = 0;
    800023bc:	0804b423          	sd	zero,136(s1)
  p->pid = 0;
    800023c0:	0204a823          	sw	zero,48(s1)
  p->priority = 0;
    800023c4:	0204aa23          	sw	zero,52(s1)
  p->cpu_time = 0;
    800023c8:	0204bc23          	sd	zero,56(s1)
  p->user_ticks = 0;
    800023cc:	0404b023          	sd	zero,64(s1)
  p->kernel_ticks = 0;
    800023d0:	0404b423          	sd	zero,72(s1)
  p->cow_faults = 0;
    800023d4:	0404b823          	sd	zero,80(s1)
  p->trace_mask = 0;
    800023d8:	0404bc23          	sd	zero,88(s1)
  p->syscall_count = 0;
    800023dc:	0604b023          	sd	zero,96(s1)
  p->ctime = 0;
    800023e0:	0604b423          	sd	zero,104(s1)
  p->last_run_tick = 0;
    800023e4:	0604b823          	sd	zero,112(s1)
  p->name[0] = 0;
    800023e8:	50048c23          	sb	zero,1304(s1)
  p->chan = 0;
    800023ec:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800023f0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800023f4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800023f8:	0004ac23          	sw	zero,24(s1)
}
    800023fc:	60e2                	ld	ra,24(sp)
    800023fe:	6442                	ld	s0,16(sp)
    80002400:	64a2                	ld	s1,8(sp)
    80002402:	6105                	addi	sp,sp,32
    80002404:	8082                	ret

0000000080002406 <allocproc>:
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80002412:	00230497          	auipc	s1,0x230
    80002416:	ec648493          	addi	s1,s1,-314 # 802322d8 <proc>
    8000241a:	00245917          	auipc	s2,0x245
    8000241e:	8be90913          	addi	s2,s2,-1858 # 80246cd8 <tickslock>
    acquire(&p->lock);
    80002422:	8526                	mv	a0,s1
    80002424:	94dfe0ef          	jal	80000d70 <acquire>
    if (p->state == UNUSED) {
    80002428:	4c9c                	lw	a5,24(s1)
    8000242a:	cb91                	beqz	a5,8000243e <allocproc+0x38>
      release(&p->lock);
    8000242c:	8526                	mv	a0,s1
    8000242e:	9cffe0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002432:	52848493          	addi	s1,s1,1320
    80002436:	ff2496e3          	bne	s1,s2,80002422 <allocproc+0x1c>
  return 0;
    8000243a:	4481                	li	s1,0
    8000243c:	a069                	j	800024c6 <allocproc+0xc0>
    8000243e:	e44e                	sd	s3,8(sp)
  p->pid = allocpid();
    80002440:	e4fff0ef          	jal	8000228e <allocpid>
    80002444:	d888                	sw	a0,48(s1)
  p->priority = PRIO_DEFAULT;
    80002446:	47a9                	li	a5,10
    80002448:	d8dc                	sw	a5,52(s1)
  p->cpu_time = 0;
    8000244a:	0204bc23          	sd	zero,56(s1)
  p->user_ticks = 0;
    8000244e:	0404b023          	sd	zero,64(s1)
  p->kernel_ticks = 0;
    80002452:	0404b423          	sd	zero,72(s1)
  p->cow_faults = 0;
    80002456:	0404b823          	sd	zero,80(s1)
  p->trace_mask = 0;
    8000245a:	0404bc23          	sd	zero,88(s1)
  p->syscall_count = 0;
    8000245e:	0604b023          	sd	zero,96(s1)
  p->ctime = ticks;
    80002462:	00008797          	auipc	a5,0x8
    80002466:	90e7e783          	lwu	a5,-1778(a5) # 80009d70 <ticks>
    8000246a:	f4bc                	sd	a5,104(s1)
  p->last_run_tick = ticks;
    8000246c:	f8bc                	sd	a5,112(s1)
  for (int i = 0; i < NVMA; i++)
    8000246e:	19848913          	addi	s2,s1,408
    80002472:	51848993          	addi	s3,s1,1304
    memset(&p->vmas[i], 0, sizeof(p->vmas[i]));
    80002476:	03800613          	li	a2,56
    8000247a:	4581                	li	a1,0
    8000247c:	854a                	mv	a0,s2
    8000247e:	9b7fe0ef          	jal	80000e34 <memset>
  for (int i = 0; i < NVMA; i++)
    80002482:	03890913          	addi	s2,s2,56
    80002486:	ff3918e3          	bne	s2,s3,80002476 <allocproc+0x70>
  p->state = USED;
    8000248a:	4785                	li	a5,1
    8000248c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    8000248e:	eb0fe0ef          	jal	80000b3e <kalloc>
    80002492:	892a                	mv	s2,a0
    80002494:	ecc8                	sd	a0,152(s1)
    80002496:	cd1d                	beqz	a0,800024d4 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    80002498:	8526                	mv	a0,s1
    8000249a:	e33ff0ef          	jal	800022cc <proc_pagetable>
    8000249e:	892a                	mv	s2,a0
    800024a0:	e8c8                	sd	a0,144(s1)
  if (p->pagetable == 0) {
    800024a2:	c131                	beqz	a0,800024e6 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    800024a4:	07000613          	li	a2,112
    800024a8:	4581                	li	a1,0
    800024aa:	0a048513          	addi	a0,s1,160
    800024ae:	987fe0ef          	jal	80000e34 <memset>
  p->context.ra = (uint64)forkret;
    800024b2:	00000797          	auipc	a5,0x0
    800024b6:	d4878793          	addi	a5,a5,-696 # 800021fa <forkret>
    800024ba:	f0dc                	sd	a5,160(s1)
  p->context.sp = p->kstack + PGSIZE;
    800024bc:	60dc                	ld	a5,128(s1)
    800024be:	6705                	lui	a4,0x1
    800024c0:	97ba                	add	a5,a5,a4
    800024c2:	f4dc                	sd	a5,168(s1)
    800024c4:	69a2                	ld	s3,8(sp)
}
    800024c6:	8526                	mv	a0,s1
    800024c8:	70a2                	ld	ra,40(sp)
    800024ca:	7402                	ld	s0,32(sp)
    800024cc:	64e2                	ld	s1,24(sp)
    800024ce:	6942                	ld	s2,16(sp)
    800024d0:	6145                	addi	sp,sp,48
    800024d2:	8082                	ret
    freeproc(p);
    800024d4:	8526                	mv	a0,s1
    800024d6:	ec1ff0ef          	jal	80002396 <freeproc>
    release(&p->lock);
    800024da:	8526                	mv	a0,s1
    800024dc:	921fe0ef          	jal	80000dfc <release>
    return 0;
    800024e0:	84ca                	mv	s1,s2
    800024e2:	69a2                	ld	s3,8(sp)
    800024e4:	b7cd                	j	800024c6 <allocproc+0xc0>
    freeproc(p);
    800024e6:	8526                	mv	a0,s1
    800024e8:	eafff0ef          	jal	80002396 <freeproc>
    release(&p->lock);
    800024ec:	8526                	mv	a0,s1
    800024ee:	90ffe0ef          	jal	80000dfc <release>
    return 0;
    800024f2:	84ca                	mv	s1,s2
    800024f4:	69a2                	ld	s3,8(sp)
    800024f6:	bfc1                	j	800024c6 <allocproc+0xc0>

00000000800024f8 <userinit>:
{
    800024f8:	1101                	addi	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	e426                	sd	s1,8(sp)
    80002500:	1000                	addi	s0,sp,32
  p = allocproc();
    80002502:	f05ff0ef          	jal	80002406 <allocproc>
    80002506:	84aa                	mv	s1,a0
  initproc = p;
    80002508:	00008797          	auipc	a5,0x8
    8000250c:	86a7b023          	sd	a0,-1952(a5) # 80009d68 <initproc>
  p->cwd = namei("/");
    80002510:	00007517          	auipc	a0,0x7
    80002514:	cf050513          	addi	a0,a0,-784 # 80009200 <etext+0x200>
    80002518:	3c7020ef          	jal	800050de <namei>
    8000251c:	18a4b823          	sd	a0,400(s1)
  p->last_run_tick = ticks;
    80002520:	00008797          	auipc	a5,0x8
    80002524:	8507e783          	lwu	a5,-1968(a5) # 80009d70 <ticks>
    80002528:	f8bc                	sd	a5,112(s1)
  p->state = RUNNABLE;
    8000252a:	478d                	li	a5,3
    8000252c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000252e:	8526                	mv	a0,s1
    80002530:	8cdfe0ef          	jal	80000dfc <release>
}
    80002534:	60e2                	ld	ra,24(sp)
    80002536:	6442                	ld	s0,16(sp)
    80002538:	64a2                	ld	s1,8(sp)
    8000253a:	6105                	addi	sp,sp,32
    8000253c:	8082                	ret

000000008000253e <growproc>:
{
    8000253e:	1101                	addi	sp,sp,-32
    80002540:	ec06                	sd	ra,24(sp)
    80002542:	e822                	sd	s0,16(sp)
    80002544:	e426                	sd	s1,8(sp)
    80002546:	e04a                	sd	s2,0(sp)
    80002548:	1000                	addi	s0,sp,32
    8000254a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000254c:	c7fff0ef          	jal	800021ca <myproc>
    80002550:	892a                	mv	s2,a0
  sz = p->sz;
    80002552:	654c                	ld	a1,136(a0)
  if (n > 0) {
    80002554:	02905963          	blez	s1,80002586 <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80002558:	00b48633          	add	a2,s1,a1
    8000255c:	020007b7          	lui	a5,0x2000
    80002560:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002562:	07b6                	slli	a5,a5,0xd
    80002564:	02c7ea63          	bltu	a5,a2,80002598 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002568:	4691                	li	a3,4
    8000256a:	6948                	ld	a0,144(a0)
    8000256c:	ec5fe0ef          	jal	80001430 <uvmalloc>
    80002570:	85aa                	mv	a1,a0
    80002572:	c50d                	beqz	a0,8000259c <growproc+0x5e>
  p->sz = sz;
    80002574:	08b93423          	sd	a1,136(s2)
  return 0;
    80002578:	4501                	li	a0,0
}
    8000257a:	60e2                	ld	ra,24(sp)
    8000257c:	6442                	ld	s0,16(sp)
    8000257e:	64a2                	ld	s1,8(sp)
    80002580:	6902                	ld	s2,0(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret
  } else if (n < 0) {
    80002586:	fe04d7e3          	bgez	s1,80002574 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000258a:	00b48633          	add	a2,s1,a1
    8000258e:	6948                	ld	a0,144(a0)
    80002590:	e5dfe0ef          	jal	800013ec <uvmdealloc>
    80002594:	85aa                	mv	a1,a0
    80002596:	bff9                	j	80002574 <growproc+0x36>
      return -1;
    80002598:	557d                	li	a0,-1
    8000259a:	b7c5                	j	8000257a <growproc+0x3c>
      return -1;
    8000259c:	557d                	li	a0,-1
    8000259e:	bff1                	j	8000257a <growproc+0x3c>

00000000800025a0 <kfork>:
{
    800025a0:	7139                	addi	sp,sp,-64
    800025a2:	fc06                	sd	ra,56(sp)
    800025a4:	f822                	sd	s0,48(sp)
    800025a6:	f04a                	sd	s2,32(sp)
    800025a8:	e852                	sd	s4,16(sp)
    800025aa:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800025ac:	c1fff0ef          	jal	800021ca <myproc>
    800025b0:	8a2a                	mv	s4,a0
  if ((np = allocproc()) == 0) {
    800025b2:	e55ff0ef          	jal	80002406 <allocproc>
    800025b6:	16050063          	beqz	a0,80002716 <kfork+0x176>
    800025ba:	ec4e                	sd	s3,24(sp)
    800025bc:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800025be:	088a3603          	ld	a2,136(s4)
    800025c2:	694c                	ld	a1,144(a0)
    800025c4:	090a3503          	ld	a0,144(s4)
    800025c8:	fa1fe0ef          	jal	80001568 <uvmcopy>
    800025cc:	02054363          	bltz	a0,800025f2 <kfork+0x52>
    800025d0:	f426                	sd	s1,40(sp)
    800025d2:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    800025d4:	088a3783          	ld	a5,136(s4)
    800025d8:	08f9b423          	sd	a5,136(s3)
  np->trace_mask = p->trace_mask;
    800025dc:	058a3783          	ld	a5,88(s4)
    800025e0:	04f9bc23          	sd	a5,88(s3)
  for (i = 0; i < NVMA; i++) {
    800025e4:	198a0493          	addi	s1,s4,408
    800025e8:	19898913          	addi	s2,s3,408
    800025ec:	518a0a93          	addi	s5,s4,1304
    800025f0:	a005                	j	80002610 <kfork+0x70>
    freeproc(np);
    800025f2:	854e                	mv	a0,s3
    800025f4:	da3ff0ef          	jal	80002396 <freeproc>
    release(&np->lock);
    800025f8:	854e                	mv	a0,s3
    800025fa:	803fe0ef          	jal	80000dfc <release>
    return -1;
    800025fe:	597d                	li	s2,-1
    80002600:	69e2                	ld	s3,24(sp)
    80002602:	a219                	j	80002708 <kfork+0x168>
  for (i = 0; i < NVMA; i++) {
    80002604:	03848493          	addi	s1,s1,56
    80002608:	03890913          	addi	s2,s2,56
    8000260c:	05548163          	beq	s1,s5,8000264e <kfork+0xae>
    if (p->vmas[i].used) {
    80002610:	409c                	lw	a5,0(s1)
    80002612:	dbed                	beqz	a5,80002604 <kfork+0x64>
      np->vmas[i] = p->vmas[i];
    80002614:	0004b803          	ld	a6,0(s1)
    80002618:	6488                	ld	a0,8(s1)
    8000261a:	688c                	ld	a1,16(s1)
    8000261c:	6c90                	ld	a2,24(s1)
    8000261e:	7094                	ld	a3,32(s1)
    80002620:	7498                	ld	a4,40(s1)
    80002622:	789c                	ld	a5,48(s1)
    80002624:	01093023          	sd	a6,0(s2)
    80002628:	00a93423          	sd	a0,8(s2)
    8000262c:	00b93823          	sd	a1,16(s2)
    80002630:	00c93c23          	sd	a2,24(s2)
    80002634:	02d93023          	sd	a3,32(s2)
    80002638:	02e93423          	sd	a4,40(s2)
    8000263c:	02f93823          	sd	a5,48(s2)
      if (p->vmas[i].file)
    80002640:	7488                	ld	a0,40(s1)
    80002642:	d169                	beqz	a0,80002604 <kfork+0x64>
        np->vmas[i].file = filedup(p->vmas[i].file);
    80002644:	0d4030ef          	jal	80005718 <filedup>
    80002648:	02a93423          	sd	a0,40(s2)
    8000264c:	bf65                	j	80002604 <kfork+0x64>
  *(np->trapframe) = *(p->trapframe);
    8000264e:	098a3683          	ld	a3,152(s4)
    80002652:	87b6                	mv	a5,a3
    80002654:	0989b703          	ld	a4,152(s3)
    80002658:	12068693          	addi	a3,a3,288
    8000265c:	0007b803          	ld	a6,0(a5)
    80002660:	6788                	ld	a0,8(a5)
    80002662:	6b8c                	ld	a1,16(a5)
    80002664:	6f90                	ld	a2,24(a5)
    80002666:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    8000266a:	e708                	sd	a0,8(a4)
    8000266c:	eb0c                	sd	a1,16(a4)
    8000266e:	ef10                	sd	a2,24(a4)
    80002670:	02078793          	addi	a5,a5,32
    80002674:	02070713          	addi	a4,a4,32
    80002678:	fed792e3          	bne	a5,a3,8000265c <kfork+0xbc>
  np->trapframe->a0 = 0;
    8000267c:	0989b783          	ld	a5,152(s3)
    80002680:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002684:	110a0493          	addi	s1,s4,272
    80002688:	11098913          	addi	s2,s3,272
    8000268c:	190a0a93          	addi	s5,s4,400
    80002690:	a029                	j	8000269a <kfork+0xfa>
    80002692:	04a1                	addi	s1,s1,8
    80002694:	0921                	addi	s2,s2,8
    80002696:	01548963          	beq	s1,s5,800026a8 <kfork+0x108>
    if (p->ofile[i])
    8000269a:	6088                	ld	a0,0(s1)
    8000269c:	d97d                	beqz	a0,80002692 <kfork+0xf2>
      np->ofile[i] = filedup(p->ofile[i]);
    8000269e:	07a030ef          	jal	80005718 <filedup>
    800026a2:	00a93023          	sd	a0,0(s2)
    800026a6:	b7f5                	j	80002692 <kfork+0xf2>
  np->cwd = idup(p->cwd);
    800026a8:	190a3503          	ld	a0,400(s4)
    800026ac:	188020ef          	jal	80004834 <idup>
    800026b0:	18a9b823          	sd	a0,400(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800026b4:	4641                	li	a2,16
    800026b6:	518a0593          	addi	a1,s4,1304
    800026ba:	51898513          	addi	a0,s3,1304
    800026be:	8b5fe0ef          	jal	80000f72 <safestrcpy>
  pid = np->pid;
    800026c2:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800026c6:	854e                	mv	a0,s3
    800026c8:	f34fe0ef          	jal	80000dfc <release>
  acquire(&wait_lock);
    800026cc:	0022f497          	auipc	s1,0x22f
    800026d0:	7f448493          	addi	s1,s1,2036 # 80231ec0 <wait_lock>
    800026d4:	8526                	mv	a0,s1
    800026d6:	e9afe0ef          	jal	80000d70 <acquire>
  np->parent = p;
    800026da:	0749bc23          	sd	s4,120(s3)
  release(&wait_lock);
    800026de:	8526                	mv	a0,s1
    800026e0:	f1cfe0ef          	jal	80000dfc <release>
  acquire(&np->lock);
    800026e4:	854e                	mv	a0,s3
    800026e6:	e8afe0ef          	jal	80000d70 <acquire>
  np->last_run_tick = ticks;
    800026ea:	00007797          	auipc	a5,0x7
    800026ee:	6867e783          	lwu	a5,1670(a5) # 80009d70 <ticks>
    800026f2:	06f9b823          	sd	a5,112(s3)
  np->state = RUNNABLE;
    800026f6:	478d                	li	a5,3
    800026f8:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800026fc:	854e                	mv	a0,s3
    800026fe:	efefe0ef          	jal	80000dfc <release>
  return pid;
    80002702:	74a2                	ld	s1,40(sp)
    80002704:	69e2                	ld	s3,24(sp)
    80002706:	6aa2                	ld	s5,8(sp)
}
    80002708:	854a                	mv	a0,s2
    8000270a:	70e2                	ld	ra,56(sp)
    8000270c:	7442                	ld	s0,48(sp)
    8000270e:	7902                	ld	s2,32(sp)
    80002710:	6a42                	ld	s4,16(sp)
    80002712:	6121                	addi	sp,sp,64
    80002714:	8082                	ret
    return -1;
    80002716:	597d                	li	s2,-1
    80002718:	bfc5                	j	80002708 <kfork+0x168>

000000008000271a <scheduler>:
{
    8000271a:	7119                	addi	sp,sp,-128
    8000271c:	fc86                	sd	ra,120(sp)
    8000271e:	f8a2                	sd	s0,112(sp)
    80002720:	f4a6                	sd	s1,104(sp)
    80002722:	f0ca                	sd	s2,96(sp)
    80002724:	ecce                	sd	s3,88(sp)
    80002726:	e8d2                	sd	s4,80(sp)
    80002728:	e4d6                	sd	s5,72(sp)
    8000272a:	e0da                	sd	s6,64(sp)
    8000272c:	fc5e                	sd	s7,56(sp)
    8000272e:	f862                	sd	s8,48(sp)
    80002730:	f466                	sd	s9,40(sp)
    80002732:	f06a                	sd	s10,32(sp)
    80002734:	ec6e                	sd	s11,24(sp)
    80002736:	0100                	addi	s0,sp,128
    80002738:	8792                	mv	a5,tp
  int id = r_tp();
    8000273a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000273c:	00779693          	slli	a3,a5,0x7
    80002740:	0022f717          	auipc	a4,0x22f
    80002744:	76870713          	addi	a4,a4,1896 # 80231ea8 <pid_lock>
    80002748:	9736                	add	a4,a4,a3
    8000274a:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &best->context);
    8000274e:	0022f717          	auipc	a4,0x22f
    80002752:	79270713          	addi	a4,a4,1938 # 80231ee0 <cpus+0x8>
    80002756:	9736                	add	a4,a4,a3
    80002758:	f8e43423          	sd	a4,-120(s0)
    best_waited = 0;
    8000275c:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    8000275e:	00244b17          	auipc	s6,0x244
    80002762:	57ab0b13          	addi	s6,s6,1402 # 80246cd8 <tickslock>
      c->proc = best;
    80002766:	0022f717          	auipc	a4,0x22f
    8000276a:	74270713          	addi	a4,a4,1858 # 80231ea8 <pid_lock>
    8000276e:	00d707b3          	add	a5,a4,a3
    80002772:	f8f43023          	sd	a5,-128(s0)
    80002776:	a05d                	j	8000281c <scheduler+0x102>
        if (eff_prio < PRIO_MIN)
    80002778:	4905                	li	s2,1
    8000277a:	a089                	j	800027bc <scheduler+0xa2>
            release(&best->lock);
    8000277c:	8552                	mv	a0,s4
    8000277e:	e7efe0ef          	jal	80000dfc <release>
          best_waited = waited;
    80002782:	8dce                	mv	s11,s3
          best_eff_prio = eff_prio;
    80002784:	8bca                	mv	s7,s2
          best = p;
    80002786:	8a26                	mv	s4,s1
    for (p = proc; p < &proc[NPROC]; p++) {
    80002788:	52848493          	addi	s1,s1,1320
    8000278c:	05648e63          	beq	s1,s6,800027e8 <scheduler+0xce>
      acquire(&p->lock);
    80002790:	8526                	mv	a0,s1
    80002792:	ddefe0ef          	jal	80000d70 <acquire>
      if (p->state == RUNNABLE) {
    80002796:	4c9c                	lw	a5,24(s1)
    80002798:	03579f63          	bne	a5,s5,800027d6 <scheduler+0xbc>
        uint64 waited = (now > p->last_run_tick) ? (now - p->last_run_tick) : 0;
    8000279c:	78bc                	ld	a5,112(s1)
    8000279e:	89e6                	mv	s3,s9
    800027a0:	0187f463          	bgeu	a5,s8,800027a8 <scheduler+0x8e>
    800027a4:	40fc09b3          	sub	s3,s8,a5
        uint64 boost = waited / AGING_THRESHOLD;
    800027a8:	03a9d7b3          	divu	a5,s3,s10
        int eff_prio = p->priority - (int)boost;
    800027ac:	0344a903          	lw	s2,52(s1)
    800027b0:	40f9093b          	subw	s2,s2,a5
        if (eff_prio < PRIO_MIN)
    800027b4:	0009079b          	sext.w	a5,s2
    800027b8:	fcf050e3          	blez	a5,80002778 <scheduler+0x5e>
    800027bc:	2901                	sext.w	s2,s2
        if (best == 0 || eff_prio < best_eff_prio ||
    800027be:	080a0163          	beqz	s4,80002840 <scheduler+0x126>
    800027c2:	fb794de3          	blt	s2,s7,8000277c <scheduler+0x62>
    800027c6:	01791463          	bne	s2,s7,800027ce <scheduler+0xb4>
            (eff_prio == best_eff_prio && waited > best_waited)) {
    800027ca:	fb3de9e3          	bltu	s11,s3,8000277c <scheduler+0x62>
          release(&p->lock);
    800027ce:	8526                	mv	a0,s1
    800027d0:	e2cfe0ef          	jal	80000dfc <release>
    800027d4:	bf55                	j	80002788 <scheduler+0x6e>
        release(&p->lock);
    800027d6:	8526                	mv	a0,s1
    800027d8:	e24fe0ef          	jal	80000dfc <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    800027dc:	52848493          	addi	s1,s1,1320
    800027e0:	fb6498e3          	bne	s1,s6,80002790 <scheduler+0x76>
    if (best != 0) {
    800027e4:	020a0d63          	beqz	s4,8000281e <scheduler+0x104>
      best->state = RUNNING;
    800027e8:	4791                	li	a5,4
    800027ea:	00fa2c23          	sw	a5,24(s4)
      c->proc = best;
    800027ee:	f8043483          	ld	s1,-128(s0)
    800027f2:	0344b823          	sd	s4,48(s1)
      swtch(&c->context, &best->context);
    800027f6:	0a0a0593          	addi	a1,s4,160
    800027fa:	f8843503          	ld	a0,-120(s0)
    800027fe:	419000ef          	jal	80003416 <swtch>
      best->last_run_tick = ticks;
    80002802:	00007797          	auipc	a5,0x7
    80002806:	56e78793          	addi	a5,a5,1390 # 80009d70 <ticks>
    8000280a:	0007e783          	lwu	a5,0(a5)
    8000280e:	06fa3823          	sd	a5,112(s4)
      c->proc = 0;
    80002812:	0204b823          	sd	zero,48(s1)
      release(&best->lock);
    80002816:	8552                	mv	a0,s4
    80002818:	de4fe0ef          	jal	80000dfc <release>
        uint64 boost = waited / AGING_THRESHOLD;
    8000281c:	4d29                	li	s10,10
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000281e:	10016073          	csrsi	sstatus,2
    uint64 now = ticks;
    80002822:	00007797          	auipc	a5,0x7
    80002826:	54e78793          	addi	a5,a5,1358 # 80009d70 <ticks>
    8000282a:	0007ec03          	lwu	s8,0(a5)
    best_waited = 0;
    8000282e:	8de6                	mv	s11,s9
    best_eff_prio = PRIO_MAX + 1;
    80002830:	4bd5                	li	s7,21
    best = 0;
    80002832:	8a66                	mv	s4,s9
    for (p = proc; p < &proc[NPROC]; p++) {
    80002834:	00230497          	auipc	s1,0x230
    80002838:	aa448493          	addi	s1,s1,-1372 # 802322d8 <proc>
      if (p->state == RUNNABLE) {
    8000283c:	4a8d                	li	s5,3
    8000283e:	bf89                	j	80002790 <scheduler+0x76>
          best_waited = waited;
    80002840:	8dce                	mv	s11,s3
          best_eff_prio = eff_prio;
    80002842:	8bca                	mv	s7,s2
          best = p;
    80002844:	8a26                	mv	s4,s1
    80002846:	b789                	j	80002788 <scheduler+0x6e>

0000000080002848 <sched>:
{
    80002848:	7179                	addi	sp,sp,-48
    8000284a:	f406                	sd	ra,40(sp)
    8000284c:	f022                	sd	s0,32(sp)
    8000284e:	ec26                	sd	s1,24(sp)
    80002850:	e84a                	sd	s2,16(sp)
    80002852:	e44e                	sd	s3,8(sp)
    80002854:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002856:	975ff0ef          	jal	800021ca <myproc>
    8000285a:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000285c:	cb4fe0ef          	jal	80000d10 <holding>
    80002860:	c92d                	beqz	a0,800028d2 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80002862:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002864:	2781                	sext.w	a5,a5
    80002866:	079e                	slli	a5,a5,0x7
    80002868:	0022f717          	auipc	a4,0x22f
    8000286c:	64070713          	addi	a4,a4,1600 # 80231ea8 <pid_lock>
    80002870:	97ba                	add	a5,a5,a4
    80002872:	0a87a703          	lw	a4,168(a5)
    80002876:	4785                	li	a5,1
    80002878:	06f71363          	bne	a4,a5,800028de <sched+0x96>
  if (p->state == RUNNING)
    8000287c:	4c98                	lw	a4,24(s1)
    8000287e:	4791                	li	a5,4
    80002880:	06f70563          	beq	a4,a5,800028ea <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002884:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002888:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000288a:	e7b5                	bnez	a5,800028f6 <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    8000288c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000288e:	0022f917          	auipc	s2,0x22f
    80002892:	61a90913          	addi	s2,s2,1562 # 80231ea8 <pid_lock>
    80002896:	2781                	sext.w	a5,a5
    80002898:	079e                	slli	a5,a5,0x7
    8000289a:	97ca                	add	a5,a5,s2
    8000289c:	0ac7a983          	lw	s3,172(a5)
    800028a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800028a2:	2781                	sext.w	a5,a5
    800028a4:	079e                	slli	a5,a5,0x7
    800028a6:	0022f597          	auipc	a1,0x22f
    800028aa:	63a58593          	addi	a1,a1,1594 # 80231ee0 <cpus+0x8>
    800028ae:	95be                	add	a1,a1,a5
    800028b0:	0a048513          	addi	a0,s1,160
    800028b4:	363000ef          	jal	80003416 <swtch>
    800028b8:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800028ba:	2781                	sext.w	a5,a5
    800028bc:	079e                	slli	a5,a5,0x7
    800028be:	993e                	add	s2,s2,a5
    800028c0:	0b392623          	sw	s3,172(s2)
}
    800028c4:	70a2                	ld	ra,40(sp)
    800028c6:	7402                	ld	s0,32(sp)
    800028c8:	64e2                	ld	s1,24(sp)
    800028ca:	6942                	ld	s2,16(sp)
    800028cc:	69a2                	ld	s3,8(sp)
    800028ce:	6145                	addi	sp,sp,48
    800028d0:	8082                	ret
    panic("sched p->lock");
    800028d2:	00007517          	auipc	a0,0x7
    800028d6:	93650513          	addi	a0,a0,-1738 # 80009208 <etext+0x208>
    800028da:	f17fd0ef          	jal	800007f0 <panic>
    panic("sched locks");
    800028de:	00007517          	auipc	a0,0x7
    800028e2:	93a50513          	addi	a0,a0,-1734 # 80009218 <etext+0x218>
    800028e6:	f0bfd0ef          	jal	800007f0 <panic>
    panic("sched RUNNING");
    800028ea:	00007517          	auipc	a0,0x7
    800028ee:	93e50513          	addi	a0,a0,-1730 # 80009228 <etext+0x228>
    800028f2:	efffd0ef          	jal	800007f0 <panic>
    panic("sched interruptible");
    800028f6:	00007517          	auipc	a0,0x7
    800028fa:	94250513          	addi	a0,a0,-1726 # 80009238 <etext+0x238>
    800028fe:	ef3fd0ef          	jal	800007f0 <panic>

0000000080002902 <yield>:
{
    80002902:	1101                	addi	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000290c:	8bfff0ef          	jal	800021ca <myproc>
    80002910:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002912:	c5efe0ef          	jal	80000d70 <acquire>
  p->state = RUNNABLE;
    80002916:	478d                	li	a5,3
    80002918:	cc9c                	sw	a5,24(s1)
  sched();
    8000291a:	f2fff0ef          	jal	80002848 <sched>
  release(&p->lock);
    8000291e:	8526                	mv	a0,s1
    80002920:	cdcfe0ef          	jal	80000dfc <release>
}
    80002924:	60e2                	ld	ra,24(sp)
    80002926:	6442                	ld	s0,16(sp)
    80002928:	64a2                	ld	s1,8(sp)
    8000292a:	6105                	addi	sp,sp,32
    8000292c:	8082                	ret

000000008000292e <sleep_prepare>:
{
    8000292e:	1101                	addi	sp,sp,-32
    80002930:	ec06                	sd	ra,24(sp)
    80002932:	e822                	sd	s0,16(sp)
    80002934:	e426                	sd	s1,8(sp)
    80002936:	e04a                	sd	s2,0(sp)
    80002938:	1000                	addi	s0,sp,32
    8000293a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000293c:	88fff0ef          	jal	800021ca <myproc>
    80002940:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002942:	c2efe0ef          	jal	80000d70 <acquire>
  if (chan == 0)
    80002946:	cc81                	beqz	s1,8000295e <sleep_prepare+0x30>
  p->chan = chan;
    80002948:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    8000294c:	854a                	mv	a0,s2
    8000294e:	caefe0ef          	jal	80000dfc <release>
}
    80002952:	60e2                	ld	ra,24(sp)
    80002954:	6442                	ld	s0,16(sp)
    80002956:	64a2                	ld	s1,8(sp)
    80002958:	6902                	ld	s2,0(sp)
    8000295a:	6105                	addi	sp,sp,32
    8000295c:	8082                	ret
    panic("sleep_prepare: zero chan");
    8000295e:	00007517          	auipc	a0,0x7
    80002962:	8f250513          	addi	a0,a0,-1806 # 80009250 <etext+0x250>
    80002966:	e8bfd0ef          	jal	800007f0 <panic>

000000008000296a <sleep>:
{
    8000296a:	1101                	addi	sp,sp,-32
    8000296c:	ec06                	sd	ra,24(sp)
    8000296e:	e822                	sd	s0,16(sp)
    80002970:	e426                	sd	s1,8(sp)
    80002972:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002974:	857ff0ef          	jal	800021ca <myproc>
    80002978:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000297a:	bf6fe0ef          	jal	80000d70 <acquire>
  if (p->chan != 0) {
    8000297e:	709c                	ld	a5,32(s1)
    80002980:	c789                	beqz	a5,8000298a <sleep+0x20>
    p->state = SLEEPING;
    80002982:	4789                	li	a5,2
    80002984:	cc9c                	sw	a5,24(s1)
    sched();
    80002986:	ec3ff0ef          	jal	80002848 <sched>
  release(&p->lock);
    8000298a:	8526                	mv	a0,s1
    8000298c:	c70fe0ef          	jal	80000dfc <release>
}
    80002990:	60e2                	ld	ra,24(sp)
    80002992:	6442                	ld	s0,16(sp)
    80002994:	64a2                	ld	s1,8(sp)
    80002996:	6105                	addi	sp,sp,32
    80002998:	8082                	ret

000000008000299a <wakeup>:
{
    8000299a:	7139                	addi	sp,sp,-64
    8000299c:	fc06                	sd	ra,56(sp)
    8000299e:	f822                	sd	s0,48(sp)
    800029a0:	f426                	sd	s1,40(sp)
    800029a2:	f04a                	sd	s2,32(sp)
    800029a4:	ec4e                	sd	s3,24(sp)
    800029a6:	e852                	sd	s4,16(sp)
    800029a8:	e456                	sd	s5,8(sp)
    800029aa:	e05a                	sd	s6,0(sp)
    800029ac:	0080                	addi	s0,sp,64
    800029ae:	892a                	mv	s2,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    800029b0:	00230497          	auipc	s1,0x230
    800029b4:	92848493          	addi	s1,s1,-1752 # 802322d8 <proc>
      if (p->state == SLEEPING) {
    800029b8:	4a09                	li	s4,2
        p->last_run_tick = ticks;
    800029ba:	00007b17          	auipc	s6,0x7
    800029be:	3b6b0b13          	addi	s6,s6,950 # 80009d70 <ticks>
        p->state = RUNNABLE;
    800029c2:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800029c4:	00244997          	auipc	s3,0x244
    800029c8:	31498993          	addi	s3,s3,788 # 80246cd8 <tickslock>
    800029cc:	a801                	j	800029dc <wakeup+0x42>
    release(&p->lock);
    800029ce:	8526                	mv	a0,s1
    800029d0:	c2cfe0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029d4:	52848493          	addi	s1,s1,1320
    800029d8:	03348363          	beq	s1,s3,800029fe <wakeup+0x64>
    acquire(&p->lock);
    800029dc:	8526                	mv	a0,s1
    800029de:	b92fe0ef          	jal	80000d70 <acquire>
    if (p->chan == chan) {
    800029e2:	709c                	ld	a5,32(s1)
    800029e4:	ff2795e3          	bne	a5,s2,800029ce <wakeup+0x34>
      p->chan = 0;
    800029e8:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    800029ec:	4c9c                	lw	a5,24(s1)
    800029ee:	ff4790e3          	bne	a5,s4,800029ce <wakeup+0x34>
        p->last_run_tick = ticks;
    800029f2:	000b6783          	lwu	a5,0(s6)
    800029f6:	f8bc                	sd	a5,112(s1)
        p->state = RUNNABLE;
    800029f8:	0154ac23          	sw	s5,24(s1)
    800029fc:	bfc9                	j	800029ce <wakeup+0x34>
}
    800029fe:	70e2                	ld	ra,56(sp)
    80002a00:	7442                	ld	s0,48(sp)
    80002a02:	74a2                	ld	s1,40(sp)
    80002a04:	7902                	ld	s2,32(sp)
    80002a06:	69e2                	ld	s3,24(sp)
    80002a08:	6a42                	ld	s4,16(sp)
    80002a0a:	6aa2                	ld	s5,8(sp)
    80002a0c:	6b02                	ld	s6,0(sp)
    80002a0e:	6121                	addi	sp,sp,64
    80002a10:	8082                	ret

0000000080002a12 <reparent>:
{
    80002a12:	7179                	addi	sp,sp,-48
    80002a14:	f406                	sd	ra,40(sp)
    80002a16:	f022                	sd	s0,32(sp)
    80002a18:	ec26                	sd	s1,24(sp)
    80002a1a:	e84a                	sd	s2,16(sp)
    80002a1c:	e44e                	sd	s3,8(sp)
    80002a1e:	e052                	sd	s4,0(sp)
    80002a20:	1800                	addi	s0,sp,48
    80002a22:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002a24:	00230497          	auipc	s1,0x230
    80002a28:	8b448493          	addi	s1,s1,-1868 # 802322d8 <proc>
      pp->parent = initproc;
    80002a2c:	00007a17          	auipc	s4,0x7
    80002a30:	33ca0a13          	addi	s4,s4,828 # 80009d68 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002a34:	00244997          	auipc	s3,0x244
    80002a38:	2a498993          	addi	s3,s3,676 # 80246cd8 <tickslock>
    80002a3c:	a029                	j	80002a46 <reparent+0x34>
    80002a3e:	52848493          	addi	s1,s1,1320
    80002a42:	01348b63          	beq	s1,s3,80002a58 <reparent+0x46>
    if (pp->parent == p) {
    80002a46:	7cbc                	ld	a5,120(s1)
    80002a48:	ff279be3          	bne	a5,s2,80002a3e <reparent+0x2c>
      pp->parent = initproc;
    80002a4c:	000a3503          	ld	a0,0(s4)
    80002a50:	fca8                	sd	a0,120(s1)
      wakeup(initproc);
    80002a52:	f49ff0ef          	jal	8000299a <wakeup>
    80002a56:	b7e5                	j	80002a3e <reparent+0x2c>
}
    80002a58:	70a2                	ld	ra,40(sp)
    80002a5a:	7402                	ld	s0,32(sp)
    80002a5c:	64e2                	ld	s1,24(sp)
    80002a5e:	6942                	ld	s2,16(sp)
    80002a60:	69a2                	ld	s3,8(sp)
    80002a62:	6a02                	ld	s4,0(sp)
    80002a64:	6145                	addi	sp,sp,48
    80002a66:	8082                	ret

0000000080002a68 <kexit>:
{
    80002a68:	7179                	addi	sp,sp,-48
    80002a6a:	f406                	sd	ra,40(sp)
    80002a6c:	f022                	sd	s0,32(sp)
    80002a6e:	e052                	sd	s4,0(sp)
    80002a70:	1800                	addi	s0,sp,48
    80002a72:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002a74:	f56ff0ef          	jal	800021ca <myproc>
  if (p == initproc)
    80002a78:	00007797          	auipc	a5,0x7
    80002a7c:	2f07b783          	ld	a5,752(a5) # 80009d68 <initproc>
    80002a80:	00a78d63          	beq	a5,a0,80002a9a <kexit+0x32>
    80002a84:	ec26                	sd	s1,24(sp)
    80002a86:	e84a                	sd	s2,16(sp)
    80002a88:	e44e                	sd	s3,8(sp)
    80002a8a:	89aa                	mv	s3,a0
  mmap_cleanup(p);
    80002a8c:	be8ff0ef          	jal	80001e74 <mmap_cleanup>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002a90:	11098493          	addi	s1,s3,272
    80002a94:	19098913          	addi	s2,s3,400
    80002a98:	a00d                	j	80002aba <kexit+0x52>
    80002a9a:	ec26                	sd	s1,24(sp)
    80002a9c:	e84a                	sd	s2,16(sp)
    80002a9e:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    80002aa0:	00006517          	auipc	a0,0x6
    80002aa4:	7d050513          	addi	a0,a0,2000 # 80009270 <etext+0x270>
    80002aa8:	d49fd0ef          	jal	800007f0 <panic>
      fileclose(f);
    80002aac:	4b3020ef          	jal	8000575e <fileclose>
      p->ofile[fd] = 0;
    80002ab0:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80002ab4:	04a1                	addi	s1,s1,8
    80002ab6:	01248563          	beq	s1,s2,80002ac0 <kexit+0x58>
    if (p->ofile[fd]) {
    80002aba:	6088                	ld	a0,0(s1)
    80002abc:	f965                	bnez	a0,80002aac <kexit+0x44>
    80002abe:	bfdd                	j	80002ab4 <kexit+0x4c>
  begin_op();
    80002ac0:	7f2020ef          	jal	800052b2 <begin_op>
  iput(p->cwd);
    80002ac4:	1909b503          	ld	a0,400(s3)
    80002ac8:	725010ef          	jal	800049ec <iput>
  end_op();
    80002acc:	06d020ef          	jal	80005338 <end_op>
  p->cwd = 0;
    80002ad0:	1809b823          	sd	zero,400(s3)
  acquire(&wait_lock);
    80002ad4:	0022f497          	auipc	s1,0x22f
    80002ad8:	3ec48493          	addi	s1,s1,1004 # 80231ec0 <wait_lock>
    80002adc:	8526                	mv	a0,s1
    80002ade:	a92fe0ef          	jal	80000d70 <acquire>
  reparent(p);
    80002ae2:	854e                	mv	a0,s3
    80002ae4:	f2fff0ef          	jal	80002a12 <reparent>
  wakeup(p->parent);
    80002ae8:	0789b503          	ld	a0,120(s3)
    80002aec:	eafff0ef          	jal	8000299a <wakeup>
  acquire(&p->lock);
    80002af0:	854e                	mv	a0,s3
    80002af2:	a7efe0ef          	jal	80000d70 <acquire>
  p->xstate = status;
    80002af6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002afa:	4795                	li	a5,5
    80002afc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002b00:	8526                	mv	a0,s1
    80002b02:	afafe0ef          	jal	80000dfc <release>
  sched();
    80002b06:	d43ff0ef          	jal	80002848 <sched>
  panic("zombie exit");
    80002b0a:	00006517          	auipc	a0,0x6
    80002b0e:	77650513          	addi	a0,a0,1910 # 80009280 <etext+0x280>
    80002b12:	cdffd0ef          	jal	800007f0 <panic>

0000000080002b16 <kkill>:
  if (pid == 0)
    80002b16:	c92d                	beqz	a0,80002b88 <kkill+0x72>
{
    80002b18:	7179                	addi	sp,sp,-48
    80002b1a:	f406                	sd	ra,40(sp)
    80002b1c:	f022                	sd	s0,32(sp)
    80002b1e:	ec26                	sd	s1,24(sp)
    80002b20:	e84a                	sd	s2,16(sp)
    80002b22:	e44e                	sd	s3,8(sp)
    80002b24:	1800                	addi	s0,sp,48
    80002b26:	892a                	mv	s2,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b28:	0022f497          	auipc	s1,0x22f
    80002b2c:	7b048493          	addi	s1,s1,1968 # 802322d8 <proc>
    80002b30:	00244997          	auipc	s3,0x244
    80002b34:	1a898993          	addi	s3,s3,424 # 80246cd8 <tickslock>
    acquire(&p->lock);
    80002b38:	8526                	mv	a0,s1
    80002b3a:	a36fe0ef          	jal	80000d70 <acquire>
    if (p->pid == pid) {
    80002b3e:	589c                	lw	a5,48(s1)
    80002b40:	01278b63          	beq	a5,s2,80002b56 <kkill+0x40>
    release(&p->lock);
    80002b44:	8526                	mv	a0,s1
    80002b46:	ab6fe0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002b4a:	52848493          	addi	s1,s1,1320
    80002b4e:	ff3495e3          	bne	s1,s3,80002b38 <kkill+0x22>
  return -1;
    80002b52:	557d                	li	a0,-1
    80002b54:	a819                	j	80002b6a <kkill+0x54>
      p->killed = 1;
    80002b56:	4785                	li	a5,1
    80002b58:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002b5a:	4c98                	lw	a4,24(s1)
    80002b5c:	4789                	li	a5,2
    80002b5e:	00f70d63          	beq	a4,a5,80002b78 <kkill+0x62>
      release(&p->lock);
    80002b62:	8526                	mv	a0,s1
    80002b64:	a98fe0ef          	jal	80000dfc <release>
      return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	70a2                	ld	ra,40(sp)
    80002b6c:	7402                	ld	s0,32(sp)
    80002b6e:	64e2                	ld	s1,24(sp)
    80002b70:	6942                	ld	s2,16(sp)
    80002b72:	69a2                	ld	s3,8(sp)
    80002b74:	6145                	addi	sp,sp,48
    80002b76:	8082                	ret
        p->last_run_tick = ticks;
    80002b78:	00007797          	auipc	a5,0x7
    80002b7c:	1f87e783          	lwu	a5,504(a5) # 80009d70 <ticks>
    80002b80:	f8bc                	sd	a5,112(s1)
        p->state = RUNNABLE;
    80002b82:	478d                	li	a5,3
    80002b84:	cc9c                	sw	a5,24(s1)
    80002b86:	bff1                	j	80002b62 <kkill+0x4c>
    return -1;
    80002b88:	557d                	li	a0,-1
}
    80002b8a:	8082                	ret

0000000080002b8c <setkilled>:
{
    80002b8c:	1101                	addi	sp,sp,-32
    80002b8e:	ec06                	sd	ra,24(sp)
    80002b90:	e822                	sd	s0,16(sp)
    80002b92:	e426                	sd	s1,8(sp)
    80002b94:	1000                	addi	s0,sp,32
    80002b96:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002b98:	9d8fe0ef          	jal	80000d70 <acquire>
  p->killed = 1;
    80002b9c:	4785                	li	a5,1
    80002b9e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002ba0:	8526                	mv	a0,s1
    80002ba2:	a5afe0ef          	jal	80000dfc <release>
}
    80002ba6:	60e2                	ld	ra,24(sp)
    80002ba8:	6442                	ld	s0,16(sp)
    80002baa:	64a2                	ld	s1,8(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <killed>:
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	e04a                	sd	s2,0(sp)
    80002bba:	1000                	addi	s0,sp,32
    80002bbc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002bbe:	9b2fe0ef          	jal	80000d70 <acquire>
  k = p->killed;
    80002bc2:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002bc6:	8526                	mv	a0,s1
    80002bc8:	a34fe0ef          	jal	80000dfc <release>
}
    80002bcc:	854a                	mv	a0,s2
    80002bce:	60e2                	ld	ra,24(sp)
    80002bd0:	6442                	ld	s0,16(sp)
    80002bd2:	64a2                	ld	s1,8(sp)
    80002bd4:	6902                	ld	s2,0(sp)
    80002bd6:	6105                	addi	sp,sp,32
    80002bd8:	8082                	ret

0000000080002bda <kwait>:
{
    80002bda:	715d                	addi	sp,sp,-80
    80002bdc:	e486                	sd	ra,72(sp)
    80002bde:	e0a2                	sd	s0,64(sp)
    80002be0:	fc26                	sd	s1,56(sp)
    80002be2:	f84a                	sd	s2,48(sp)
    80002be4:	f44e                	sd	s3,40(sp)
    80002be6:	f052                	sd	s4,32(sp)
    80002be8:	ec56                	sd	s5,24(sp)
    80002bea:	e85a                	sd	s6,16(sp)
    80002bec:	e45e                	sd	s7,8(sp)
    80002bee:	e062                	sd	s8,0(sp)
    80002bf0:	0880                	addi	s0,sp,80
    80002bf2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002bf4:	dd6ff0ef          	jal	800021ca <myproc>
    80002bf8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002bfa:	0022f517          	auipc	a0,0x22f
    80002bfe:	2c650513          	addi	a0,a0,710 # 80231ec0 <wait_lock>
    80002c02:	96efe0ef          	jal	80000d70 <acquire>
    havekids = 0;
    80002c06:	4c01                	li	s8,0
        if (pp->state == ZOMBIE) {
    80002c08:	4a15                	li	s4,5
        havekids = 1;
    80002c0a:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002c0c:	00244997          	auipc	s3,0x244
    80002c10:	0cc98993          	addi	s3,s3,204 # 80246cd8 <tickslock>
    release(&wait_lock);
    80002c14:	0022fb97          	auipc	s7,0x22f
    80002c18:	2acb8b93          	addi	s7,s7,684 # 80231ec0 <wait_lock>
    80002c1c:	a84d                	j	80002cce <kwait+0xf4>
          pid = pp->pid;
    80002c1e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    80002c22:	000b0e63          	beqz	s6,80002c3e <kwait+0x64>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002c26:	4711                	li	a4,4
    80002c28:	02c48693          	addi	a3,s1,44
    80002c2c:	865a                	mv	a2,s6
    80002c2e:	08893583          	ld	a1,136(s2)
    80002c32:	09093503          	ld	a0,144(s2)
    80002c36:	d73fe0ef          	jal	800019a8 <copyout>
          if (addr != 0 &&
    80002c3a:	02054d63          	bltz	a0,80002c74 <kwait+0x9a>
          pp->parent = 0;
    80002c3e:	0604bc23          	sd	zero,120(s1)
          freeproc(pp);
    80002c42:	8526                	mv	a0,s1
    80002c44:	f52ff0ef          	jal	80002396 <freeproc>
          release(&pp->lock);
    80002c48:	8526                	mv	a0,s1
    80002c4a:	9b2fe0ef          	jal	80000dfc <release>
          release(&wait_lock);
    80002c4e:	0022f517          	auipc	a0,0x22f
    80002c52:	27250513          	addi	a0,a0,626 # 80231ec0 <wait_lock>
    80002c56:	9a6fe0ef          	jal	80000dfc <release>
}
    80002c5a:	854e                	mv	a0,s3
    80002c5c:	60a6                	ld	ra,72(sp)
    80002c5e:	6406                	ld	s0,64(sp)
    80002c60:	74e2                	ld	s1,56(sp)
    80002c62:	7942                	ld	s2,48(sp)
    80002c64:	79a2                	ld	s3,40(sp)
    80002c66:	7a02                	ld	s4,32(sp)
    80002c68:	6ae2                	ld	s5,24(sp)
    80002c6a:	6b42                	ld	s6,16(sp)
    80002c6c:	6ba2                	ld	s7,8(sp)
    80002c6e:	6c02                	ld	s8,0(sp)
    80002c70:	6161                	addi	sp,sp,80
    80002c72:	8082                	ret
            release(&pp->lock);
    80002c74:	8526                	mv	a0,s1
    80002c76:	986fe0ef          	jal	80000dfc <release>
            release(&wait_lock);
    80002c7a:	0022f517          	auipc	a0,0x22f
    80002c7e:	24650513          	addi	a0,a0,582 # 80231ec0 <wait_lock>
    80002c82:	97afe0ef          	jal	80000dfc <release>
            return -1;
    80002c86:	59fd                	li	s3,-1
    80002c88:	bfc9                	j	80002c5a <kwait+0x80>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002c8a:	52848493          	addi	s1,s1,1320
    80002c8e:	03348063          	beq	s1,s3,80002cae <kwait+0xd4>
      if (pp->parent == p) {
    80002c92:	7cbc                	ld	a5,120(s1)
    80002c94:	ff279be3          	bne	a5,s2,80002c8a <kwait+0xb0>
        acquire(&pp->lock);
    80002c98:	8526                	mv	a0,s1
    80002c9a:	8d6fe0ef          	jal	80000d70 <acquire>
        if (pp->state == ZOMBIE) {
    80002c9e:	4c9c                	lw	a5,24(s1)
    80002ca0:	f7478fe3          	beq	a5,s4,80002c1e <kwait+0x44>
        release(&pp->lock);
    80002ca4:	8526                	mv	a0,s1
    80002ca6:	956fe0ef          	jal	80000dfc <release>
        havekids = 1;
    80002caa:	8756                	mv	a4,s5
    80002cac:	bff9                	j	80002c8a <kwait+0xb0>
    if (!havekids || killed(p)) {
    80002cae:	c715                	beqz	a4,80002cda <kwait+0x100>
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	effff0ef          	jal	80002bb0 <killed>
    80002cb6:	e115                	bnez	a0,80002cda <kwait+0x100>
    sleep_prepare(p); //DOC: wait-sleep
    80002cb8:	854a                	mv	a0,s2
    80002cba:	c75ff0ef          	jal	8000292e <sleep_prepare>
    release(&wait_lock);
    80002cbe:	855e                	mv	a0,s7
    80002cc0:	93cfe0ef          	jal	80000dfc <release>
    sleep();
    80002cc4:	ca7ff0ef          	jal	8000296a <sleep>
    acquire(&wait_lock);
    80002cc8:	855e                	mv	a0,s7
    80002cca:	8a6fe0ef          	jal	80000d70 <acquire>
    havekids = 0;
    80002cce:	8762                	mv	a4,s8
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002cd0:	0022f497          	auipc	s1,0x22f
    80002cd4:	60848493          	addi	s1,s1,1544 # 802322d8 <proc>
    80002cd8:	bf6d                	j	80002c92 <kwait+0xb8>
      release(&wait_lock);
    80002cda:	0022f517          	auipc	a0,0x22f
    80002cde:	1e650513          	addi	a0,a0,486 # 80231ec0 <wait_lock>
    80002ce2:	91afe0ef          	jal	80000dfc <release>
      return -1;
    80002ce6:	59fd                	li	s3,-1
    80002ce8:	bf8d                	j	80002c5a <kwait+0x80>

0000000080002cea <kwaitx>:
{
    80002cea:	7159                	addi	sp,sp,-112
    80002cec:	f486                	sd	ra,104(sp)
    80002cee:	f0a2                	sd	s0,96(sp)
    80002cf0:	eca6                	sd	s1,88(sp)
    80002cf2:	e8ca                	sd	s2,80(sp)
    80002cf4:	e4ce                	sd	s3,72(sp)
    80002cf6:	e0d2                	sd	s4,64(sp)
    80002cf8:	fc56                	sd	s5,56(sp)
    80002cfa:	f85a                	sd	s6,48(sp)
    80002cfc:	f45e                	sd	s7,40(sp)
    80002cfe:	f062                	sd	s8,32(sp)
    80002d00:	ec66                	sd	s9,24(sp)
    80002d02:	e86a                	sd	s10,16(sp)
    80002d04:	1880                	addi	s0,sp,112
    80002d06:	8c2a                	mv	s8,a0
    80002d08:	8bae                	mv	s7,a1
    80002d0a:	8b32                	mv	s6,a2
  struct proc *p = myproc();
    80002d0c:	cbeff0ef          	jal	800021ca <myproc>
    80002d10:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002d12:	0022f517          	auipc	a0,0x22f
    80002d16:	1ae50513          	addi	a0,a0,430 # 80231ec0 <wait_lock>
    80002d1a:	856fe0ef          	jal	80000d70 <acquire>
    havekids = 0;
    80002d1e:	4d01                	li	s10,0
        if (pp->state == ZOMBIE) {
    80002d20:	4a15                	li	s4,5
        havekids = 1;
    80002d22:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002d24:	00244997          	auipc	s3,0x244
    80002d28:	fb498993          	addi	s3,s3,-76 # 80246cd8 <tickslock>
    release(&wait_lock);
    80002d2c:	0022fc97          	auipc	s9,0x22f
    80002d30:	194c8c93          	addi	s9,s9,404 # 80231ec0 <wait_lock>
    80002d34:	a289                	j	80002e76 <kwaitx+0x18c>
          uint64 rtime = pp->cpu_time;
    80002d36:	7c98                	ld	a4,56(s1)
    80002d38:	f8e43823          	sd	a4,-112(s0)
          uint64 now = ticks;
    80002d3c:	00007617          	auipc	a2,0x7
    80002d40:	03466603          	lwu	a2,52(a2) # 80009d70 <ticks>
          uint64 total = (now >= pp->ctime) ? (now - pp->ctime) : 0;
    80002d44:	74b4                	ld	a3,104(s1)
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
    80002d46:	4781                	li	a5,0
          uint64 total = (now >= pp->ctime) ? (now - pp->ctime) : 0;
    80002d48:	00d66763          	bltu	a2,a3,80002d56 <kwaitx+0x6c>
    80002d4c:	40d607b3          	sub	a5,a2,a3
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
    80002d50:	06f77663          	bgeu	a4,a5,80002dbc <kwaitx+0xd2>
    80002d54:	8f99                	sub	a5,a5,a4
    80002d56:	f8f43c23          	sd	a5,-104(s0)
          pid = pp->pid;
    80002d5a:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    80002d5e:	060c1163          	bnez	s8,80002dc0 <kwaitx+0xd6>
          if (wtime_addr != 0 &&
    80002d62:	080b9663          	bnez	s7,80002dee <kwaitx+0x104>
          if (rtime_addr != 0 &&
    80002d66:	000b0e63          	beqz	s6,80002d82 <kwaitx+0x98>
              copyout(p->pagetable, p->sz, rtime_addr, (char *)&rtime,
    80002d6a:	4721                	li	a4,8
    80002d6c:	f9040693          	addi	a3,s0,-112
    80002d70:	865a                	mv	a2,s6
    80002d72:	08893583          	ld	a1,136(s2)
    80002d76:	09093503          	ld	a0,144(s2)
    80002d7a:	c2ffe0ef          	jal	800019a8 <copyout>
          if (rtime_addr != 0 &&
    80002d7e:	08054f63          	bltz	a0,80002e1c <kwaitx+0x132>
          pp->parent = 0;
    80002d82:	0604bc23          	sd	zero,120(s1)
          freeproc(pp);
    80002d86:	8526                	mv	a0,s1
    80002d88:	e0eff0ef          	jal	80002396 <freeproc>
          release(&pp->lock);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	86efe0ef          	jal	80000dfc <release>
          release(&wait_lock);
    80002d92:	0022f517          	auipc	a0,0x22f
    80002d96:	12e50513          	addi	a0,a0,302 # 80231ec0 <wait_lock>
    80002d9a:	862fe0ef          	jal	80000dfc <release>
}
    80002d9e:	854e                	mv	a0,s3
    80002da0:	70a6                	ld	ra,104(sp)
    80002da2:	7406                	ld	s0,96(sp)
    80002da4:	64e6                	ld	s1,88(sp)
    80002da6:	6946                	ld	s2,80(sp)
    80002da8:	69a6                	ld	s3,72(sp)
    80002daa:	6a06                	ld	s4,64(sp)
    80002dac:	7ae2                	ld	s5,56(sp)
    80002dae:	7b42                	ld	s6,48(sp)
    80002db0:	7ba2                	ld	s7,40(sp)
    80002db2:	7c02                	ld	s8,32(sp)
    80002db4:	6ce2                	ld	s9,24(sp)
    80002db6:	6d42                	ld	s10,16(sp)
    80002db8:	6165                	addi	sp,sp,112
    80002dba:	8082                	ret
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
    80002dbc:	4781                	li	a5,0
    80002dbe:	bf61                	j	80002d56 <kwaitx+0x6c>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002dc0:	4711                	li	a4,4
    80002dc2:	02c48693          	addi	a3,s1,44
    80002dc6:	8662                	mv	a2,s8
    80002dc8:	08893583          	ld	a1,136(s2)
    80002dcc:	09093503          	ld	a0,144(s2)
    80002dd0:	bd9fe0ef          	jal	800019a8 <copyout>
          if (addr != 0 &&
    80002dd4:	f80557e3          	bgez	a0,80002d62 <kwaitx+0x78>
            release(&pp->lock);
    80002dd8:	8526                	mv	a0,s1
    80002dda:	822fe0ef          	jal	80000dfc <release>
            release(&wait_lock);
    80002dde:	0022f517          	auipc	a0,0x22f
    80002de2:	0e250513          	addi	a0,a0,226 # 80231ec0 <wait_lock>
    80002de6:	816fe0ef          	jal	80000dfc <release>
            return -1;
    80002dea:	59fd                	li	s3,-1
    80002dec:	bf4d                	j	80002d9e <kwaitx+0xb4>
              copyout(p->pagetable, p->sz, wtime_addr, (char *)&wtime,
    80002dee:	4721                	li	a4,8
    80002df0:	f9840693          	addi	a3,s0,-104
    80002df4:	865e                	mv	a2,s7
    80002df6:	08893583          	ld	a1,136(s2)
    80002dfa:	09093503          	ld	a0,144(s2)
    80002dfe:	babfe0ef          	jal	800019a8 <copyout>
          if (wtime_addr != 0 &&
    80002e02:	f60552e3          	bgez	a0,80002d66 <kwaitx+0x7c>
            release(&pp->lock);
    80002e06:	8526                	mv	a0,s1
    80002e08:	ff5fd0ef          	jal	80000dfc <release>
            release(&wait_lock);
    80002e0c:	0022f517          	auipc	a0,0x22f
    80002e10:	0b450513          	addi	a0,a0,180 # 80231ec0 <wait_lock>
    80002e14:	fe9fd0ef          	jal	80000dfc <release>
            return -1;
    80002e18:	59fd                	li	s3,-1
    80002e1a:	b751                	j	80002d9e <kwaitx+0xb4>
            release(&pp->lock);
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	fdffd0ef          	jal	80000dfc <release>
            release(&wait_lock);
    80002e22:	0022f517          	auipc	a0,0x22f
    80002e26:	09e50513          	addi	a0,a0,158 # 80231ec0 <wait_lock>
    80002e2a:	fd3fd0ef          	jal	80000dfc <release>
            return -1;
    80002e2e:	59fd                	li	s3,-1
    80002e30:	b7bd                	j	80002d9e <kwaitx+0xb4>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002e32:	52848493          	addi	s1,s1,1320
    80002e36:	03348063          	beq	s1,s3,80002e56 <kwaitx+0x16c>
      if (pp->parent == p) {
    80002e3a:	7cbc                	ld	a5,120(s1)
    80002e3c:	ff279be3          	bne	a5,s2,80002e32 <kwaitx+0x148>
        acquire(&pp->lock);
    80002e40:	8526                	mv	a0,s1
    80002e42:	f2ffd0ef          	jal	80000d70 <acquire>
        if (pp->state == ZOMBIE) {
    80002e46:	4c9c                	lw	a5,24(s1)
    80002e48:	ef4787e3          	beq	a5,s4,80002d36 <kwaitx+0x4c>
        release(&pp->lock);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	faffd0ef          	jal	80000dfc <release>
        havekids = 1;
    80002e52:	8756                	mv	a4,s5
    80002e54:	bff9                	j	80002e32 <kwaitx+0x148>
    if (!havekids || killed(p)) {
    80002e56:	c715                	beqz	a4,80002e82 <kwaitx+0x198>
    80002e58:	854a                	mv	a0,s2
    80002e5a:	d57ff0ef          	jal	80002bb0 <killed>
    80002e5e:	e115                	bnez	a0,80002e82 <kwaitx+0x198>
    sleep_prepare(p);
    80002e60:	854a                	mv	a0,s2
    80002e62:	acdff0ef          	jal	8000292e <sleep_prepare>
    release(&wait_lock);
    80002e66:	8566                	mv	a0,s9
    80002e68:	f95fd0ef          	jal	80000dfc <release>
    sleep();
    80002e6c:	affff0ef          	jal	8000296a <sleep>
    acquire(&wait_lock);
    80002e70:	8566                	mv	a0,s9
    80002e72:	efffd0ef          	jal	80000d70 <acquire>
    havekids = 0;
    80002e76:	876a                	mv	a4,s10
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002e78:	0022f497          	auipc	s1,0x22f
    80002e7c:	46048493          	addi	s1,s1,1120 # 802322d8 <proc>
    80002e80:	bf6d                	j	80002e3a <kwaitx+0x150>
      release(&wait_lock);
    80002e82:	0022f517          	auipc	a0,0x22f
    80002e86:	03e50513          	addi	a0,a0,62 # 80231ec0 <wait_lock>
    80002e8a:	f73fd0ef          	jal	80000dfc <release>
      return -1;
    80002e8e:	59fd                	li	s3,-1
    80002e90:	b739                	j	80002d9e <kwaitx+0xb4>

0000000080002e92 <either_copyout>:
{
    80002e92:	7179                	addi	sp,sp,-48
    80002e94:	f406                	sd	ra,40(sp)
    80002e96:	f022                	sd	s0,32(sp)
    80002e98:	ec26                	sd	s1,24(sp)
    80002e9a:	e84a                	sd	s2,16(sp)
    80002e9c:	e44e                	sd	s3,8(sp)
    80002e9e:	e052                	sd	s4,0(sp)
    80002ea0:	1800                	addi	s0,sp,48
    80002ea2:	84aa                	mv	s1,a0
    80002ea4:	892e                	mv	s2,a1
    80002ea6:	89b2                	mv	s3,a2
    80002ea8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002eaa:	b20ff0ef          	jal	800021ca <myproc>
  if (user_dst) {
    80002eae:	c085                	beqz	s1,80002ece <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    80002eb0:	8752                	mv	a4,s4
    80002eb2:	86ce                	mv	a3,s3
    80002eb4:	864a                	mv	a2,s2
    80002eb6:	654c                	ld	a1,136(a0)
    80002eb8:	6948                	ld	a0,144(a0)
    80002eba:	aeffe0ef          	jal	800019a8 <copyout>
}
    80002ebe:	70a2                	ld	ra,40(sp)
    80002ec0:	7402                	ld	s0,32(sp)
    80002ec2:	64e2                	ld	s1,24(sp)
    80002ec4:	6942                	ld	s2,16(sp)
    80002ec6:	69a2                	ld	s3,8(sp)
    80002ec8:	6a02                	ld	s4,0(sp)
    80002eca:	6145                	addi	sp,sp,48
    80002ecc:	8082                	ret
    memmove((char *)dst, src, len);
    80002ece:	000a061b          	sext.w	a2,s4
    80002ed2:	85ce                	mv	a1,s3
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	fbbfd0ef          	jal	80000e90 <memmove>
    return 0;
    80002eda:	8526                	mv	a0,s1
    80002edc:	b7cd                	j	80002ebe <either_copyout+0x2c>

0000000080002ede <either_copyin>:
{
    80002ede:	7179                	addi	sp,sp,-48
    80002ee0:	f406                	sd	ra,40(sp)
    80002ee2:	f022                	sd	s0,32(sp)
    80002ee4:	ec26                	sd	s1,24(sp)
    80002ee6:	e84a                	sd	s2,16(sp)
    80002ee8:	e44e                	sd	s3,8(sp)
    80002eea:	e052                	sd	s4,0(sp)
    80002eec:	1800                	addi	s0,sp,48
    80002eee:	892a                	mv	s2,a0
    80002ef0:	84ae                	mv	s1,a1
    80002ef2:	89b2                	mv	s3,a2
    80002ef4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002ef6:	ad4ff0ef          	jal	800021ca <myproc>
  if (user_src) {
    80002efa:	c085                	beqz	s1,80002f1a <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80002efc:	8752                	mv	a4,s4
    80002efe:	86ce                	mv	a3,s3
    80002f00:	864a                	mv	a2,s2
    80002f02:	654c                	ld	a1,136(a0)
    80002f04:	6948                	ld	a0,144(a0)
    80002f06:	bf1fe0ef          	jal	80001af6 <copyin>
}
    80002f0a:	70a2                	ld	ra,40(sp)
    80002f0c:	7402                	ld	s0,32(sp)
    80002f0e:	64e2                	ld	s1,24(sp)
    80002f10:	6942                	ld	s2,16(sp)
    80002f12:	69a2                	ld	s3,8(sp)
    80002f14:	6a02                	ld	s4,0(sp)
    80002f16:	6145                	addi	sp,sp,48
    80002f18:	8082                	ret
    memmove(dst, (char *)src, len);
    80002f1a:	000a061b          	sext.w	a2,s4
    80002f1e:	85ce                	mv	a1,s3
    80002f20:	854a                	mv	a0,s2
    80002f22:	f6ffd0ef          	jal	80000e90 <memmove>
    return 0;
    80002f26:	8526                	mv	a0,s1
    80002f28:	b7cd                	j	80002f0a <either_copyin+0x2c>

0000000080002f2a <procdump>:
{
    80002f2a:	7155                	addi	sp,sp,-208
    80002f2c:	e586                	sd	ra,200(sp)
    80002f2e:	e1a2                	sd	s0,192(sp)
    80002f30:	fd26                	sd	s1,184(sp)
    80002f32:	f94a                	sd	s2,176(sp)
    80002f34:	f54e                	sd	s3,168(sp)
    80002f36:	f152                	sd	s4,160(sp)
    80002f38:	ed56                	sd	s5,152(sp)
    80002f3a:	e95a                	sd	s6,144(sp)
    80002f3c:	e55e                	sd	s7,136(sp)
    80002f3e:	e162                	sd	s8,128(sp)
    80002f40:	fce6                	sd	s9,120(sp)
    80002f42:	f8ea                	sd	s10,112(sp)
    80002f44:	f4ee                	sd	s11,104(sp)
    80002f46:	0980                	addi	s0,sp,208
  printk("PID   PRIO  CPU (U/K)       MEM-KB  STATE   NAME\n");
    80002f48:	00006517          	auipc	a0,0x6
    80002f4c:	34850513          	addi	a0,a0,840 # 80009290 <etext+0x290>
    80002f50:	dbafd0ef          	jal	8000050a <printk>
  printk("----  ----  --------------  ------  ------  ----------------\n");
    80002f54:	00006517          	auipc	a0,0x6
    80002f58:	37450513          	addi	a0,a0,884 # 800092c8 <etext+0x2c8>
    80002f5c:	daefd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002f60:	00230997          	auipc	s3,0x230
    80002f64:	89098993          	addi	s3,s3,-1904 # 802327f0 <proc+0x518>
    80002f68:	00244b97          	auipc	s7,0x244
    80002f6c:	288b8b93          	addi	s7,s7,648 # 802471f0 <bcache+0x500>
  uint64 total_mem_kb = 0;
    80002f70:	4b01                	li	s6,0
  int active_count = 0;
    80002f72:	4a81                	li	s5,0
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002f74:	4d95                	li	s11,5
    cpubuf[pos++] = ' ';
    80002f76:	02000d13          	li	s10,32
    cpubuf[pos++] = '(';
    80002f7a:	02800c93          	li	s9,40
    cpubuf[pos++] = '/';
    80002f7e:	02f00c13          	li	s8,47
    80002f82:	a8e5                	j	8000307a <procdump+0x150>
    pos += uint_to_str(p->cpu_time, cpubuf + pos);
    80002f84:	f4840593          	addi	a1,s0,-184
    80002f88:	b2093503          	ld	a0,-1248(s2)
    80002f8c:	f29fe0ef          	jal	80001eb4 <uint_to_str>
    cpubuf[pos++] = ' ';
    80002f90:	f9050793          	addi	a5,a0,-112
    80002f94:	97a2                	add	a5,a5,s0
    80002f96:	fba78c23          	sb	s10,-72(a5)
    cpubuf[pos++] = '(';
    80002f9a:	0025049b          	addiw	s1,a0,2
    80002f9e:	0004859b          	sext.w	a1,s1
    80002fa2:	2505                	addiw	a0,a0,1
    80002fa4:	f9050793          	addi	a5,a0,-112
    80002fa8:	00878533          	add	a0,a5,s0
    80002fac:	fb950c23          	sb	s9,-72(a0)
    pos += uint_to_str(p->user_ticks, cpubuf + pos);
    80002fb0:	f4840793          	addi	a5,s0,-184
    80002fb4:	95be                	add	a1,a1,a5
    80002fb6:	b2893503          	ld	a0,-1240(s2)
    80002fba:	efbfe0ef          	jal	80001eb4 <uint_to_str>
    80002fbe:	9ca9                	addw	s1,s1,a0
    80002fc0:	0004879b          	sext.w	a5,s1
    cpubuf[pos++] = '/';
    80002fc4:	2485                	addiw	s1,s1,1
    80002fc6:	0004859b          	sext.w	a1,s1
    80002fca:	f9078793          	addi	a5,a5,-112
    80002fce:	97a2                	add	a5,a5,s0
    80002fd0:	fb878c23          	sb	s8,-72(a5)
    pos += uint_to_str(p->kernel_ticks, cpubuf + pos);
    80002fd4:	f4840793          	addi	a5,s0,-184
    80002fd8:	95be                	add	a1,a1,a5
    80002fda:	b3093503          	ld	a0,-1232(s2)
    80002fde:	ed7fe0ef          	jal	80001eb4 <uint_to_str>
    80002fe2:	9ca9                	addw	s1,s1,a0
    80002fe4:	0004879b          	sext.w	a5,s1
    cpubuf[pos++] = ')';
    80002fe8:	f9078793          	addi	a5,a5,-112
    80002fec:	97a2                	add	a5,a5,s0
    80002fee:	02900713          	li	a4,41
    80002ff2:	fae78c23          	sb	a4,-72(a5)
    cpubuf[pos] = '\0';
    80002ff6:	2485                	addiw	s1,s1,1
    80002ff8:	f9048793          	addi	a5,s1,-112
    80002ffc:	008784b3          	add	s1,a5,s0
    80003000:	fa048c23          	sb	zero,-72(s1)
    uint64 mem_kb = (p->sz + 1023) / 1024;
    80003004:	b7093483          	ld	s1,-1168(s2)
    80003008:	3ff48493          	addi	s1,s1,1023
    8000300c:	80a9                	srli	s1,s1,0xa
    total_mem_kb += mem_kb;
    8000300e:	9b26                	add	s6,s6,s1
    active_count++;
    80003010:	2a85                	addiw	s5,s5,1
  uint_to_str(val, buf);
    80003012:	f3040593          	addi	a1,s0,-208
    80003016:	b1892503          	lw	a0,-1256(s2)
    8000301a:	e9bfe0ef          	jal	80001eb4 <uint_to_str>
  print_col(buf, width);
    8000301e:	4599                	li	a1,6
    80003020:	f3040513          	addi	a0,s0,-208
    80003024:	fd3fe0ef          	jal	80001ff6 <print_col>
  uint_to_str(val, buf);
    80003028:	f3040593          	addi	a1,s0,-208
    8000302c:	b1c92503          	lw	a0,-1252(s2)
    80003030:	e85fe0ef          	jal	80001eb4 <uint_to_str>
  print_col(buf, width);
    80003034:	4599                	li	a1,6
    80003036:	f3040513          	addi	a0,s0,-208
    8000303a:	fbdfe0ef          	jal	80001ff6 <print_col>
    print_col(cpubuf, 16);
    8000303e:	45c1                	li	a1,16
    80003040:	f4840513          	addi	a0,s0,-184
    80003044:	fb3fe0ef          	jal	80001ff6 <print_col>
  uint_to_str(val, buf);
    80003048:	f3040593          	addi	a1,s0,-208
    8000304c:	8526                	mv	a0,s1
    8000304e:	e67fe0ef          	jal	80001eb4 <uint_to_str>
  print_col(buf, width);
    80003052:	45a1                	li	a1,8
    80003054:	f3040513          	addi	a0,s0,-208
    80003058:	f9ffe0ef          	jal	80001ff6 <print_col>
    print_col(state, 8);
    8000305c:	45a1                	li	a1,8
    8000305e:	8552                	mv	a0,s4
    80003060:	f97fe0ef          	jal	80001ff6 <print_col>
    printk("%s\n", p->name);
    80003064:	85ca                	mv	a1,s2
    80003066:	00006517          	auipc	a0,0x6
    8000306a:	fba50513          	addi	a0,a0,-70 # 80009020 <etext+0x20>
    8000306e:	c9cfd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80003072:	52898993          	addi	s3,s3,1320
    80003076:	03798e63          	beq	s3,s7,800030b2 <procdump+0x188>
    if (p->state == UNUSED)
    8000307a:	894e                	mv	s2,s3
    8000307c:	b009a783          	lw	a5,-1280(s3)
    80003080:	dbed                	beqz	a5,80003072 <procdump+0x148>
      state = "???";
    80003082:	00006a17          	auipc	s4,0x6
    80003086:	0fea0a13          	addi	s4,s4,254 # 80009180 <etext+0x180>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000308a:	eefdede3          	bltu	s11,a5,80002f84 <procdump+0x5a>
    8000308e:	02079713          	slli	a4,a5,0x20
    80003092:	01d75793          	srli	a5,a4,0x1d
    80003096:	00007717          	auipc	a4,0x7
    8000309a:	9b270713          	addi	a4,a4,-1614 # 80009a48 <states.0>
    8000309e:	97ba                	add	a5,a5,a4
    800030a0:	0307ba03          	ld	s4,48(a5)
    800030a4:	ee0a10e3          	bnez	s4,80002f84 <procdump+0x5a>
      state = "???";
    800030a8:	00006a17          	auipc	s4,0x6
    800030ac:	0d8a0a13          	addi	s4,s4,216 # 80009180 <etext+0x180>
    800030b0:	bdd1                	j	80002f84 <procdump+0x5a>
  printk("------------------------------------------------------------\n");
    800030b2:	00006517          	auipc	a0,0x6
    800030b6:	25650513          	addi	a0,a0,598 # 80009308 <etext+0x308>
    800030ba:	c50fd0ef          	jal	8000050a <printk>
  printk("Active processes: %d | Total process memory: %lu KB\n",
    800030be:	865a                	mv	a2,s6
    800030c0:	85d6                	mv	a1,s5
    800030c2:	00006517          	auipc	a0,0x6
    800030c6:	28650513          	addi	a0,a0,646 # 80009348 <etext+0x348>
    800030ca:	c40fd0ef          	jal	8000050a <printk>
}
    800030ce:	60ae                	ld	ra,200(sp)
    800030d0:	640e                	ld	s0,192(sp)
    800030d2:	74ea                	ld	s1,184(sp)
    800030d4:	794a                	ld	s2,176(sp)
    800030d6:	79aa                	ld	s3,168(sp)
    800030d8:	7a0a                	ld	s4,160(sp)
    800030da:	6aea                	ld	s5,152(sp)
    800030dc:	6b4a                	ld	s6,144(sp)
    800030de:	6baa                	ld	s7,136(sp)
    800030e0:	6c0a                	ld	s8,128(sp)
    800030e2:	7ce6                	ld	s9,120(sp)
    800030e4:	7d46                	ld	s10,112(sp)
    800030e6:	7da6                	ld	s11,104(sp)
    800030e8:	6169                	addi	sp,sp,208
    800030ea:	8082                	ret

00000000800030ec <setpriority>:
{
    800030ec:	7179                	addi	sp,sp,-48
    800030ee:	f406                	sd	ra,40(sp)
    800030f0:	f022                	sd	s0,32(sp)
    800030f2:	ec26                	sd	s1,24(sp)
    800030f4:	e84a                	sd	s2,16(sp)
    800030f6:	e44e                	sd	s3,8(sp)
    800030f8:	e052                	sd	s4,0(sp)
    800030fa:	1800                	addi	s0,sp,48
    800030fc:	892a                	mv	s2,a0
    800030fe:	8a2e                	mv	s4,a1
  for (p = proc; p < &proc[NPROC]; p++) {
    80003100:	0022f497          	auipc	s1,0x22f
    80003104:	1d848493          	addi	s1,s1,472 # 802322d8 <proc>
    80003108:	00244997          	auipc	s3,0x244
    8000310c:	bd098993          	addi	s3,s3,-1072 # 80246cd8 <tickslock>
  if (pid == 0) {
    80003110:	e505                	bnez	a0,80003138 <setpriority+0x4c>
    p = myproc();
    80003112:	8b8ff0ef          	jal	800021ca <myproc>
    80003116:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80003118:	c59fd0ef          	jal	80000d70 <acquire>
    p->priority = priority;
    8000311c:	0344aa23          	sw	s4,52(s1)
    release(&p->lock);
    80003120:	8526                	mv	a0,s1
    80003122:	cdbfd0ef          	jal	80000dfc <release>
    return 0;
    80003126:	854a                	mv	a0,s2
    80003128:	a035                	j	80003154 <setpriority+0x68>
    release(&p->lock);
    8000312a:	8526                	mv	a0,s1
    8000312c:	cd1fd0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80003130:	52848493          	addi	s1,s1,1320
    80003134:	03348863          	beq	s1,s3,80003164 <setpriority+0x78>
    acquire(&p->lock);
    80003138:	8526                	mv	a0,s1
    8000313a:	c37fd0ef          	jal	80000d70 <acquire>
    if (p->state != UNUSED && p->pid == pid) {
    8000313e:	4c9c                	lw	a5,24(s1)
    80003140:	d7ed                	beqz	a5,8000312a <setpriority+0x3e>
    80003142:	589c                	lw	a5,48(s1)
    80003144:	ff2793e3          	bne	a5,s2,8000312a <setpriority+0x3e>
      p->priority = priority;
    80003148:	0344aa23          	sw	s4,52(s1)
      release(&p->lock);
    8000314c:	8526                	mv	a0,s1
    8000314e:	caffd0ef          	jal	80000dfc <release>
      return 0;
    80003152:	4501                	li	a0,0
}
    80003154:	70a2                	ld	ra,40(sp)
    80003156:	7402                	ld	s0,32(sp)
    80003158:	64e2                	ld	s1,24(sp)
    8000315a:	6942                	ld	s2,16(sp)
    8000315c:	69a2                	ld	s3,8(sp)
    8000315e:	6a02                	ld	s4,0(sp)
    80003160:	6145                	addi	sp,sp,48
    80003162:	8082                	ret
  return -1;
    80003164:	557d                	li	a0,-1
    80003166:	b7fd                	j	80003154 <setpriority+0x68>

0000000080003168 <getpriority>:
{
    80003168:	7179                	addi	sp,sp,-48
    8000316a:	f406                	sd	ra,40(sp)
    8000316c:	f022                	sd	s0,32(sp)
    8000316e:	ec26                	sd	s1,24(sp)
    80003170:	e84a                	sd	s2,16(sp)
    80003172:	e44e                	sd	s3,8(sp)
    80003174:	1800                	addi	s0,sp,48
    80003176:	89aa                	mv	s3,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80003178:	0022f497          	auipc	s1,0x22f
    8000317c:	16048493          	addi	s1,s1,352 # 802322d8 <proc>
    80003180:	00244917          	auipc	s2,0x244
    80003184:	b5890913          	addi	s2,s2,-1192 # 80246cd8 <tickslock>
  if (pid == 0) {
    80003188:	e11d                	bnez	a0,800031ae <getpriority+0x46>
    p = myproc();
    8000318a:	840ff0ef          	jal	800021ca <myproc>
    8000318e:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80003190:	be1fd0ef          	jal	80000d70 <acquire>
    prio = p->priority;
    80003194:	0344a903          	lw	s2,52(s1)
    release(&p->lock);
    80003198:	8526                	mv	a0,s1
    8000319a:	c63fd0ef          	jal	80000dfc <release>
    return prio;
    8000319e:	a02d                	j	800031c8 <getpriority+0x60>
    release(&p->lock);
    800031a0:	8526                	mv	a0,s1
    800031a2:	c5bfd0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800031a6:	52848493          	addi	s1,s1,1320
    800031aa:	03248763          	beq	s1,s2,800031d8 <getpriority+0x70>
    acquire(&p->lock);
    800031ae:	8526                	mv	a0,s1
    800031b0:	bc1fd0ef          	jal	80000d70 <acquire>
    if (p->state != UNUSED && p->pid == pid) {
    800031b4:	4c9c                	lw	a5,24(s1)
    800031b6:	d7ed                	beqz	a5,800031a0 <getpriority+0x38>
    800031b8:	589c                	lw	a5,48(s1)
    800031ba:	ff3793e3          	bne	a5,s3,800031a0 <getpriority+0x38>
      prio = p->priority;
    800031be:	0344a903          	lw	s2,52(s1)
      release(&p->lock);
    800031c2:	8526                	mv	a0,s1
    800031c4:	c39fd0ef          	jal	80000dfc <release>
}
    800031c8:	854a                	mv	a0,s2
    800031ca:	70a2                	ld	ra,40(sp)
    800031cc:	7402                	ld	s0,32(sp)
    800031ce:	64e2                	ld	s1,24(sp)
    800031d0:	6942                	ld	s2,16(sp)
    800031d2:	69a2                	ld	s3,8(sp)
    800031d4:	6145                	addi	sp,sp,48
    800031d6:	8082                	ret
  return -1;
    800031d8:	597d                	li	s2,-1
    800031da:	b7fd                	j	800031c8 <getpriority+0x60>

00000000800031dc <getcowfaults_proc>:
{
    800031dc:	7179                	addi	sp,sp,-48
    800031de:	f406                	sd	ra,40(sp)
    800031e0:	f022                	sd	s0,32(sp)
    800031e2:	ec26                	sd	s1,24(sp)
    800031e4:	e84a                	sd	s2,16(sp)
    800031e6:	e44e                	sd	s3,8(sp)
    800031e8:	1800                	addi	s0,sp,48
    800031ea:	89aa                	mv	s3,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    800031ec:	0022f497          	auipc	s1,0x22f
    800031f0:	0ec48493          	addi	s1,s1,236 # 802322d8 <proc>
    800031f4:	00244917          	auipc	s2,0x244
    800031f8:	ae490913          	addi	s2,s2,-1308 # 80246cd8 <tickslock>
  if (pid <= 0)
    800031fc:	00a04e63          	bgtz	a0,80003218 <getcowfaults_proc+0x3c>
    return (int)myproc()->cow_faults;
    80003200:	fcbfe0ef          	jal	800021ca <myproc>
    80003204:	05052903          	lw	s2,80(a0)
    80003208:	a02d                	j	80003232 <getcowfaults_proc+0x56>
    release(&p->lock);
    8000320a:	8526                	mv	a0,s1
    8000320c:	bf1fd0ef          	jal	80000dfc <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80003210:	52848493          	addi	s1,s1,1320
    80003214:	03248763          	beq	s1,s2,80003242 <getcowfaults_proc+0x66>
    acquire(&p->lock);
    80003218:	8526                	mv	a0,s1
    8000321a:	b57fd0ef          	jal	80000d70 <acquire>
    if (p->state != UNUSED && p->pid == pid) {
    8000321e:	4c9c                	lw	a5,24(s1)
    80003220:	d7ed                	beqz	a5,8000320a <getcowfaults_proc+0x2e>
    80003222:	589c                	lw	a5,48(s1)
    80003224:	ff3793e3          	bne	a5,s3,8000320a <getcowfaults_proc+0x2e>
      count = (int)p->cow_faults;
    80003228:	0504a903          	lw	s2,80(s1)
      release(&p->lock);
    8000322c:	8526                	mv	a0,s1
    8000322e:	bcffd0ef          	jal	80000dfc <release>
}
    80003232:	854a                	mv	a0,s2
    80003234:	70a2                	ld	ra,40(sp)
    80003236:	7402                	ld	s0,32(sp)
    80003238:	64e2                	ld	s1,24(sp)
    8000323a:	6942                	ld	s2,16(sp)
    8000323c:	69a2                	ld	s3,8(sp)
    8000323e:	6145                	addi	sp,sp,48
    80003240:	8082                	ret
  return -1;
    80003242:	597d                	li	s2,-1
    80003244:	b7fd                	j	80003232 <getcowfaults_proc+0x56>

0000000080003246 <nproc_active>:
{
    80003246:	7179                	addi	sp,sp,-48
    80003248:	f406                	sd	ra,40(sp)
    8000324a:	f022                	sd	s0,32(sp)
    8000324c:	ec26                	sd	s1,24(sp)
    8000324e:	e84a                	sd	s2,16(sp)
    80003250:	e44e                	sd	s3,8(sp)
    80003252:	1800                	addi	s0,sp,48
  uint64 count = 0;
    80003254:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++){
    80003256:	0022f497          	auipc	s1,0x22f
    8000325a:	08248493          	addi	s1,s1,130 # 802322d8 <proc>
    8000325e:	00244997          	auipc	s3,0x244
    80003262:	a7a98993          	addi	s3,s3,-1414 # 80246cd8 <tickslock>
    acquire(&p->lock);
    80003266:	8526                	mv	a0,s1
    80003268:	b09fd0ef          	jal	80000d70 <acquire>
    if(p->state != UNUSED)
    8000326c:	4c9c                	lw	a5,24(s1)
      count++;
    8000326e:	00f037b3          	snez	a5,a5
    80003272:	993e                	add	s2,s2,a5
    release(&p->lock);
    80003274:	8526                	mv	a0,s1
    80003276:	b87fd0ef          	jal	80000dfc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000327a:	52848493          	addi	s1,s1,1320
    8000327e:	ff3494e3          	bne	s1,s3,80003266 <nproc_active+0x20>
}
    80003282:	854a                	mv	a0,s2
    80003284:	70a2                	ld	ra,40(sp)
    80003286:	7402                	ld	s0,32(sp)
    80003288:	64e2                	ld	s1,24(sp)
    8000328a:	6942                	ld	s2,16(sp)
    8000328c:	69a2                	ld	s3,8(sp)
    8000328e:	6145                	addi	sp,sp,48
    80003290:	8082                	ret

0000000080003292 <kgetppid>:
{
    80003292:	1101                	addi	sp,sp,-32
    80003294:	ec06                	sd	ra,24(sp)
    80003296:	e822                	sd	s0,16(sp)
    80003298:	e426                	sd	s1,8(sp)
    8000329a:	e04a                	sd	s2,0(sp)
    8000329c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000329e:	f2dfe0ef          	jal	800021ca <myproc>
    800032a2:	84aa                	mv	s1,a0
  acquire(&wait_lock);
    800032a4:	0022f517          	auipc	a0,0x22f
    800032a8:	c1c50513          	addi	a0,a0,-996 # 80231ec0 <wait_lock>
    800032ac:	ac5fd0ef          	jal	80000d70 <acquire>
  if(p->parent != 0){
    800032b0:	7ca8                	ld	a0,120(s1)
  int ppid = 0;
    800032b2:	4901                	li	s2,0
  if(p->parent != 0){
    800032b4:	c901                	beqz	a0,800032c4 <kgetppid+0x32>
    acquire(&p->parent->lock);
    800032b6:	abbfd0ef          	jal	80000d70 <acquire>
    ppid = p->parent->pid;
    800032ba:	7ca8                	ld	a0,120(s1)
    800032bc:	03052903          	lw	s2,48(a0)
    release(&p->parent->lock);
    800032c0:	b3dfd0ef          	jal	80000dfc <release>
  release(&wait_lock);
    800032c4:	0022f517          	auipc	a0,0x22f
    800032c8:	bfc50513          	addi	a0,a0,-1028 # 80231ec0 <wait_lock>
    800032cc:	b31fd0ef          	jal	80000dfc <release>
}
    800032d0:	854a                	mv	a0,s2
    800032d2:	60e2                	ld	ra,24(sp)
    800032d4:	6442                	ld	s0,16(sp)
    800032d6:	64a2                	ld	s1,8(sp)
    800032d8:	6902                	ld	s2,0(sp)
    800032da:	6105                	addi	sp,sp,32
    800032dc:	8082                	ret

00000000800032de <proctree>:

void
proctree(void)
{
    800032de:	7139                	addi	sp,sp,-64
    800032e0:	fc06                	sd	ra,56(sp)
    800032e2:	f822                	sd	s0,48(sp)
    800032e4:	0080                	addi	s0,sp,64
  struct pnode *nodes;
  struct proc *p;
  int count = 0;

  nodes = (struct pnode *)kalloc();
    800032e6:	859fd0ef          	jal	80000b3e <kalloc>
  if(nodes == 0)
    800032ea:	cd4d                	beqz	a0,800033a4 <proctree+0xc6>
    800032ec:	f426                	sd	s1,40(sp)
    800032ee:	f04a                	sd	s2,32(sp)
    800032f0:	ec4e                	sd	s3,24(sp)
    800032f2:	e852                	sd	s4,16(sp)
    800032f4:	e456                	sd	s5,8(sp)
    800032f6:	8aaa                	mv	s5,a0
    return;

  acquire(&wait_lock);
    800032f8:	0022f517          	auipc	a0,0x22f
    800032fc:	bc850513          	addi	a0,a0,-1080 # 80231ec0 <wait_lock>
    80003300:	a71fd0ef          	jal	80000d70 <acquire>
  int count = 0;
    80003304:	4981                	li	s3,0
  for(p = proc; p < &proc[NPROC]; p++){
    80003306:	0022f497          	auipc	s1,0x22f
    8000330a:	fd248493          	addi	s1,s1,-46 # 802322d8 <proc>
    8000330e:	00244a17          	auipc	s4,0x244
    80003312:	9caa0a13          	addi	s4,s4,-1590 # 80246cd8 <tickslock>
    80003316:	a801                	j	80003326 <proctree+0x48>
      if(p->parent != 0){
        acquire(&p->parent->lock);
        nodes[count].ppid = p->parent->pid;
        release(&p->parent->lock);
      } else {
        nodes[count].ppid = 0;
    80003318:	00092223          	sw	zero,4(s2)
      }
      count++;
    8000331c:	2985                	addiw	s3,s3,1
  for(p = proc; p < &proc[NPROC]; p++){
    8000331e:	52848493          	addi	s1,s1,1320
    80003322:	05448d63          	beq	s1,s4,8000337c <proctree+0x9e>
    acquire(&p->lock);
    80003326:	8526                	mv	a0,s1
    80003328:	a49fd0ef          	jal	80000d70 <acquire>
    if(p->state != UNUSED){
    8000332c:	4c9c                	lw	a5,24(s1)
    8000332e:	c3b9                	beqz	a5,80003374 <proctree+0x96>
      nodes[count].pid = p->pid;
    80003330:	00599913          	slli	s2,s3,0x5
    80003334:	9956                	add	s2,s2,s5
    80003336:	589c                	lw	a5,48(s1)
    80003338:	00f92023          	sw	a5,0(s2)
      nodes[count].priority = p->priority;
    8000333c:	58dc                	lw	a5,52(s1)
    8000333e:	00f92423          	sw	a5,8(s2)
      nodes[count].state = p->state;
    80003342:	4c9c                	lw	a5,24(s1)
    80003344:	00f92623          	sw	a5,12(s2)
      safestrcpy(nodes[count].name, p->name, sizeof(nodes[count].name));
    80003348:	4641                	li	a2,16
    8000334a:	51848593          	addi	a1,s1,1304
    8000334e:	01090513          	addi	a0,s2,16
    80003352:	c21fd0ef          	jal	80000f72 <safestrcpy>
      release(&p->lock);
    80003356:	8526                	mv	a0,s1
    80003358:	aa5fd0ef          	jal	80000dfc <release>
      if(p->parent != 0){
    8000335c:	7ca8                	ld	a0,120(s1)
    8000335e:	dd4d                	beqz	a0,80003318 <proctree+0x3a>
        acquire(&p->parent->lock);
    80003360:	a11fd0ef          	jal	80000d70 <acquire>
        nodes[count].ppid = p->parent->pid;
    80003364:	7cbc                	ld	a5,120(s1)
    80003366:	5b9c                	lw	a5,48(a5)
    80003368:	00f92223          	sw	a5,4(s2)
        release(&p->parent->lock);
    8000336c:	7ca8                	ld	a0,120(s1)
    8000336e:	a8ffd0ef          	jal	80000dfc <release>
    80003372:	b76d                	j	8000331c <proctree+0x3e>
    } else {
      release(&p->lock);
    80003374:	8526                	mv	a0,s1
    80003376:	a87fd0ef          	jal	80000dfc <release>
    8000337a:	b755                	j	8000331e <proctree+0x40>
    }
  }
  release(&wait_lock);
    8000337c:	0022f517          	auipc	a0,0x22f
    80003380:	b4450513          	addi	a0,a0,-1212 # 80231ec0 <wait_lock>
    80003384:	a79fd0ef          	jal	80000dfc <release>

  print_ptree_nodes(nodes, count, 0, 0);
    80003388:	4681                	li	a3,0
    8000338a:	4601                	li	a2,0
    8000338c:	85ce                	mv	a1,s3
    8000338e:	8556                	mv	a0,s5
    80003390:	b83fe0ef          	jal	80001f12 <print_ptree_nodes>
  kfree((void *)nodes);
    80003394:	8556                	mv	a0,s5
    80003396:	e52fd0ef          	jal	800009e8 <kfree>
    8000339a:	74a2                	ld	s1,40(sp)
    8000339c:	7902                	ld	s2,32(sp)
    8000339e:	69e2                	ld	s3,24(sp)
    800033a0:	6a42                	ld	s4,16(sp)
    800033a2:	6aa2                	ld	s5,8(sp)
}
    800033a4:	70e2                	ld	ra,56(sp)
    800033a6:	7442                	ld	s0,48(sp)
    800033a8:	6121                	addi	sp,sp,64
    800033aa:	8082                	ret

00000000800033ac <getsyscallcount_proc>:

int
getsyscallcount_proc(int pid)
{
    800033ac:	7179                	addi	sp,sp,-48
    800033ae:	f406                	sd	ra,40(sp)
    800033b0:	f022                	sd	s0,32(sp)
    800033b2:	ec26                	sd	s1,24(sp)
    800033b4:	e84a                	sd	s2,16(sp)
    800033b6:	e44e                	sd	s3,8(sp)
    800033b8:	1800                	addi	s0,sp,48
    800033ba:	89aa                	mv	s3,a0
  int count;

  if(pid <= 0)
    return (int)myproc()->syscall_count;

  for(p = proc; p < &proc[NPROC]; p++){
    800033bc:	0022f497          	auipc	s1,0x22f
    800033c0:	f1c48493          	addi	s1,s1,-228 # 802322d8 <proc>
    800033c4:	00244917          	auipc	s2,0x244
    800033c8:	91490913          	addi	s2,s2,-1772 # 80246cd8 <tickslock>
  if(pid <= 0)
    800033cc:	00a04e63          	bgtz	a0,800033e8 <getsyscallcount_proc+0x3c>
    return (int)myproc()->syscall_count;
    800033d0:	dfbfe0ef          	jal	800021ca <myproc>
    800033d4:	06052903          	lw	s2,96(a0)
    800033d8:	a02d                	j	80003402 <getsyscallcount_proc+0x56>
    if(p->state != UNUSED && p->pid == pid){
      count = (int)p->syscall_count;
      release(&p->lock);
      return count;
    }
    release(&p->lock);
    800033da:	8526                	mv	a0,s1
    800033dc:	a21fd0ef          	jal	80000dfc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800033e0:	52848493          	addi	s1,s1,1320
    800033e4:	03248763          	beq	s1,s2,80003412 <getsyscallcount_proc+0x66>
    acquire(&p->lock);
    800033e8:	8526                	mv	a0,s1
    800033ea:	987fd0ef          	jal	80000d70 <acquire>
    if(p->state != UNUSED && p->pid == pid){
    800033ee:	4c9c                	lw	a5,24(s1)
    800033f0:	d7ed                	beqz	a5,800033da <getsyscallcount_proc+0x2e>
    800033f2:	589c                	lw	a5,48(s1)
    800033f4:	ff3793e3          	bne	a5,s3,800033da <getsyscallcount_proc+0x2e>
      count = (int)p->syscall_count;
    800033f8:	0604a903          	lw	s2,96(s1)
      release(&p->lock);
    800033fc:	8526                	mv	a0,s1
    800033fe:	9fffd0ef          	jal	80000dfc <release>
  }

  return -1;
}
    80003402:	854a                	mv	a0,s2
    80003404:	70a2                	ld	ra,40(sp)
    80003406:	7402                	ld	s0,32(sp)
    80003408:	64e2                	ld	s1,24(sp)
    8000340a:	6942                	ld	s2,16(sp)
    8000340c:	69a2                	ld	s3,8(sp)
    8000340e:	6145                	addi	sp,sp,48
    80003410:	8082                	ret
  return -1;
    80003412:	597d                	li	s2,-1
    80003414:	b7fd                	j	80003402 <getsyscallcount_proc+0x56>

0000000080003416 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80003416:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000341a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000341e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80003420:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80003422:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80003426:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000342a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000342e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80003432:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80003436:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000343a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000343e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80003442:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80003446:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000344a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000344e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80003452:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80003454:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80003456:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000345a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000345e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80003462:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80003466:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000346a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000346e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80003472:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80003476:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000347a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000347e:	8082                	ret

0000000080003480 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003480:	1141                	addi	sp,sp,-16
    80003482:	e406                	sd	ra,8(sp)
    80003484:	e022                	sd	s0,0(sp)
    80003486:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003488:	00006597          	auipc	a1,0x6
    8000348c:	f4058593          	addi	a1,a1,-192 # 800093c8 <etext+0x3c8>
    80003490:	00244517          	auipc	a0,0x244
    80003494:	84850513          	addi	a0,a0,-1976 # 80246cd8 <tickslock>
    80003498:	863fd0ef          	jal	80000cfa <initlock>
}
    8000349c:	60a2                	ld	ra,8(sp)
    8000349e:	6402                	ld	s0,0(sp)
    800034a0:	0141                	addi	sp,sp,16
    800034a2:	8082                	ret

00000000800034a4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800034a4:	1141                	addi	sp,sp,-16
    800034a6:	e422                	sd	s0,8(sp)
    800034a8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800034aa:	00003797          	auipc	a5,0x3
    800034ae:	70678793          	addi	a5,a5,1798 # 80006bb0 <kernelvec>
    800034b2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800034b6:	6422                	ld	s0,8(sp)
    800034b8:	0141                	addi	sp,sp,16
    800034ba:	8082                	ret

00000000800034bc <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800034bc:	1141                	addi	sp,sp,-16
    800034be:	e406                	sd	ra,8(sp)
    800034c0:	e022                	sd	s0,0(sp)
    800034c2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800034c4:	d07fe0ef          	jal	800021ca <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    800034c8:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800034cc:	04000737          	lui	a4,0x4000
    800034d0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800034d2:	0732                	slli	a4,a4,0xc
    800034d4:	00005797          	auipc	a5,0x5
    800034d8:	b2c78793          	addi	a5,a5,-1236 # 80008000 <_trampoline>
    800034dc:	00005697          	auipc	a3,0x5
    800034e0:	b2468693          	addi	a3,a3,-1244 # 80008000 <_trampoline>
    800034e4:	8f95                	sub	a5,a5,a3
    800034e6:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    800034e8:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800034ec:	6d5c                	ld	a5,152(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800034ee:	18002773          	csrr	a4,satp
    800034f2:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800034f4:	6d58                	ld	a4,152(a0)
    800034f6:	615c                	ld	a5,128(a0)
    800034f8:	6685                	lui	a3,0x1
    800034fa:	97b6                	add	a5,a5,a3
    800034fc:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800034fe:	6d5c                	ld	a5,152(a0)
    80003500:	00000717          	auipc	a4,0x0
    80003504:	0f870713          	addi	a4,a4,248 # 800035f8 <usertrap>
    80003508:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    8000350a:	6d5c                	ld	a5,152(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    8000350c:	8712                	mv	a4,tp
    8000350e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003510:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003514:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003518:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000351c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003520:	6d5c                	ld	a5,152(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80003522:	6f9c                	ld	a5,24(a5)
    80003524:	14179073          	csrw	sepc,a5
}
    80003528:	60a2                	ld	ra,8(sp)
    8000352a:	6402                	ld	s0,0(sp)
    8000352c:	0141                	addi	sp,sp,16
    8000352e:	8082                	ret

0000000080003530 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003530:	1101                	addi	sp,sp,-32
    80003532:	ec06                	sd	ra,24(sp)
    80003534:	e822                	sd	s0,16(sp)
    80003536:	1000                	addi	s0,sp,32
  if (cpuid() == 0) {
    80003538:	c67fe0ef          	jal	8000219e <cpuid>
    8000353c:	cd11                	beqz	a0,80003558 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    8000353e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80003542:	000f4737          	lui	a4,0xf4
    80003546:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000354a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000354c:	14d79073          	csrw	stimecmp,a5
}
    80003550:	60e2                	ld	ra,24(sp)
    80003552:	6442                	ld	s0,16(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret
    80003558:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000355a:	00243497          	auipc	s1,0x243
    8000355e:	77e48493          	addi	s1,s1,1918 # 80246cd8 <tickslock>
    80003562:	8526                	mv	a0,s1
    80003564:	80dfd0ef          	jal	80000d70 <acquire>
    ticks++;
    80003568:	00007517          	auipc	a0,0x7
    8000356c:	80850513          	addi	a0,a0,-2040 # 80009d70 <ticks>
    80003570:	411c                	lw	a5,0(a0)
    80003572:	2785                	addiw	a5,a5,1
    80003574:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80003576:	c24ff0ef          	jal	8000299a <wakeup>
    release(&tickslock);
    8000357a:	8526                	mv	a0,s1
    8000357c:	881fd0ef          	jal	80000dfc <release>
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	bf75                	j	8000353e <clockintr+0xe>

0000000080003584 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003584:	1101                	addi	sp,sp,-32
    80003586:	ec06                	sd	ra,24(sp)
    80003588:	e822                	sd	s0,16(sp)
    8000358a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    8000358c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80003590:	57fd                	li	a5,-1
    80003592:	17fe                	slli	a5,a5,0x3f
    80003594:	07a5                	addi	a5,a5,9
    80003596:	00f70c63          	beq	a4,a5,800035ae <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    8000359a:	57fd                	li	a5,-1
    8000359c:	17fe                	slli	a5,a5,0x3f
    8000359e:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800035a0:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    800035a2:	04f70763          	beq	a4,a5,800035f0 <devintr+0x6c>
  }
}
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	6105                	addi	sp,sp,32
    800035ac:	8082                	ret
    800035ae:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800035b0:	6ac030ef          	jal	80006c5c <plic_claim>
    800035b4:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    800035b6:	47a9                	li	a5,10
    800035b8:	00f50963          	beq	a0,a5,800035ca <devintr+0x46>
    } else if (irq == VIRTIO0_IRQ) {
    800035bc:	4785                	li	a5,1
    800035be:	00f50963          	beq	a0,a5,800035d0 <devintr+0x4c>
    return 1;
    800035c2:	4505                	li	a0,1
    } else if (irq) {
    800035c4:	e889                	bnez	s1,800035d6 <devintr+0x52>
    800035c6:	64a2                	ld	s1,8(sp)
    800035c8:	bff9                	j	800035a6 <devintr+0x22>
      uartintr();
    800035ca:	bc2fd0ef          	jal	8000098c <uartintr>
    if (irq)
    800035ce:	a819                	j	800035e4 <devintr+0x60>
      virtio_disk_intr();
    800035d0:	371030ef          	jal	80007140 <virtio_disk_intr>
    if (irq)
    800035d4:	a801                	j	800035e4 <devintr+0x60>
      printk("unexpected interrupt irq=%d\n", irq);
    800035d6:	85a6                	mv	a1,s1
    800035d8:	00006517          	auipc	a0,0x6
    800035dc:	df850513          	addi	a0,a0,-520 # 800093d0 <etext+0x3d0>
    800035e0:	f2bfc0ef          	jal	8000050a <printk>
      plic_complete(irq);
    800035e4:	8526                	mv	a0,s1
    800035e6:	696030ef          	jal	80006c7c <plic_complete>
    return 1;
    800035ea:	4505                	li	a0,1
    800035ec:	64a2                	ld	s1,8(sp)
    800035ee:	bf65                	j	800035a6 <devintr+0x22>
    clockintr();
    800035f0:	f41ff0ef          	jal	80003530 <clockintr>
    return 2;
    800035f4:	4509                	li	a0,2
    800035f6:	bf45                	j	800035a6 <devintr+0x22>

00000000800035f8 <usertrap>:
{
    800035f8:	1101                	addi	sp,sp,-32
    800035fa:	ec06                	sd	ra,24(sp)
    800035fc:	e822                	sd	s0,16(sp)
    800035fe:	e426                	sd	s1,8(sp)
    80003600:	e04a                	sd	s2,0(sp)
    80003602:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003604:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003608:	1007f793          	andi	a5,a5,256
    8000360c:	ebc1                	bnez	a5,8000369c <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000360e:	00003797          	auipc	a5,0x3
    80003612:	5a278793          	addi	a5,a5,1442 # 80006bb0 <kernelvec>
    80003616:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000361a:	bb1fe0ef          	jal	800021ca <myproc>
    8000361e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003620:	6d5c                	ld	a5,152(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003622:	14102773          	csrr	a4,sepc
    80003626:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80003628:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    8000362c:	47a1                	li	a5,8
    8000362e:	06f70d63          	beq	a4,a5,800036a8 <usertrap+0xb0>
  } else if ((which_dev = devintr()) != 0) {
    80003632:	f53ff0ef          	jal	80003584 <devintr>
    80003636:	892a                	mv	s2,a0
    80003638:	0e051863          	bnez	a0,80003728 <usertrap+0x130>
    8000363c:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15 &&
    80003640:	47bd                	li	a5,15
    80003642:	0af70363          	beq	a4,a5,800036e8 <usertrap+0xf0>
    80003646:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000364a:	47bd                	li	a5,15
    8000364c:	0af70563          	beq	a4,a5,800036f6 <usertrap+0xfe>
    80003650:	14202773          	csrr	a4,scause
    80003654:	47b5                	li	a5,13
    80003656:	0af70063          	beq	a4,a5,800036f6 <usertrap+0xfe>
    8000365a:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000365e:	47bd                	li	a5,15
    80003660:	0af70763          	beq	a4,a5,8000370e <usertrap+0x116>
    80003664:	14202773          	csrr	a4,scause
    80003668:	47b5                	li	a5,13
    8000366a:	0af70263          	beq	a4,a5,8000370e <usertrap+0x116>
    8000366e:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80003672:	5890                	lw	a2,48(s1)
    80003674:	00006517          	auipc	a0,0x6
    80003678:	d9c50513          	addi	a0,a0,-612 # 80009410 <etext+0x410>
    8000367c:	e8ffc0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003680:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80003684:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80003688:	00006517          	auipc	a0,0x6
    8000368c:	db850513          	addi	a0,a0,-584 # 80009440 <etext+0x440>
    80003690:	e7bfc0ef          	jal	8000050a <printk>
    setkilled(p);
    80003694:	8526                	mv	a0,s1
    80003696:	cf6ff0ef          	jal	80002b8c <setkilled>
    8000369a:	a015                	j	800036be <usertrap+0xc6>
    panic("usertrap: not from user mode");
    8000369c:	00006517          	auipc	a0,0x6
    800036a0:	d5450513          	addi	a0,a0,-684 # 800093f0 <etext+0x3f0>
    800036a4:	94cfd0ef          	jal	800007f0 <panic>
    if (killed(p))
    800036a8:	d08ff0ef          	jal	80002bb0 <killed>
    800036ac:	e915                	bnez	a0,800036e0 <usertrap+0xe8>
    p->trapframe->epc += 4;
    800036ae:	6cd8                	ld	a4,152(s1)
    800036b0:	6f1c                	ld	a5,24(a4)
    800036b2:	0791                	addi	a5,a5,4
    800036b4:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800036b6:	10016073          	csrsi	sstatus,2
    syscall();
    800036ba:	290000ef          	jal	8000394a <syscall>
  if (killed(p))
    800036be:	8526                	mv	a0,s1
    800036c0:	cf0ff0ef          	jal	80002bb0 <killed>
    800036c4:	e53d                	bnez	a0,80003732 <usertrap+0x13a>
  prepare_return();
    800036c6:	df7ff0ef          	jal	800034bc <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800036ca:	68c8                	ld	a0,144(s1)
    800036cc:	8131                	srli	a0,a0,0xc
    800036ce:	57fd                	li	a5,-1
    800036d0:	17fe                	slli	a5,a5,0x3f
    800036d2:	8d5d                	or	a0,a0,a5
}
    800036d4:	60e2                	ld	ra,24(sp)
    800036d6:	6442                	ld	s0,16(sp)
    800036d8:	64a2                	ld	s1,8(sp)
    800036da:	6902                	ld	s2,0(sp)
    800036dc:	6105                	addi	sp,sp,32
    800036de:	8082                	ret
      kexit(-1);
    800036e0:	557d                	li	a0,-1
    800036e2:	b86ff0ef          	jal	80002a68 <kexit>
    800036e6:	b7e1                	j	800036ae <usertrap+0xb6>
  asm volatile("csrr %0, stval" : "=r"(x));
    800036e8:	143025f3          	csrr	a1,stval
             cowalloc(p->pagetable, r_stval()) != 0) {
    800036ec:	68c8                	ld	a0,144(s1)
    800036ee:	822fe0ef          	jal	80001710 <cowalloc>
  } else if (r_scause() == 15 &&
    800036f2:	f571                	bnez	a0,800036be <usertrap+0xc6>
    800036f4:	bf89                	j	80003646 <usertrap+0x4e>
    800036f6:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    800036fa:	14202673          	csrr	a2,scause
             mmapfault(p->pagetable, r_stval(),
    800036fe:	164d                	addi	a2,a2,-13
    80003700:	00163613          	seqz	a2,a2
    80003704:	68c8                	ld	a0,144(s1)
    80003706:	930fe0ef          	jal	80001836 <mmapfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000370a:	f955                	bnez	a0,800036be <usertrap+0xc6>
    8000370c:	b7b9                	j	8000365a <usertrap+0x62>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000370e:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80003712:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80003716:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80003718:	0016b693          	seqz	a3,a3
    8000371c:	64cc                	ld	a1,136(s1)
    8000371e:	68c8                	ld	a0,144(s1)
    80003720:	f75fd0ef          	jal	80001694 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80003724:	fd49                	bnez	a0,800036be <usertrap+0xc6>
    80003726:	b7a1                	j	8000366e <usertrap+0x76>
  if (killed(p))
    80003728:	8526                	mv	a0,s1
    8000372a:	c86ff0ef          	jal	80002bb0 <killed>
    8000372e:	c511                	beqz	a0,8000373a <usertrap+0x142>
    80003730:	a011                	j	80003734 <usertrap+0x13c>
    80003732:	4901                	li	s2,0
    kexit(-1);
    80003734:	557d                	li	a0,-1
    80003736:	b32ff0ef          	jal	80002a68 <kexit>
  if (which_dev == 2) {
    8000373a:	4789                	li	a5,2
    8000373c:	f8f915e3          	bne	s2,a5,800036c6 <usertrap+0xce>
    p->user_ticks++;
    80003740:	60bc                	ld	a5,64(s1)
    80003742:	0785                	addi	a5,a5,1
    80003744:	e0bc                	sd	a5,64(s1)
    p->cpu_time++;
    80003746:	7c9c                	ld	a5,56(s1)
    80003748:	0785                	addi	a5,a5,1
    8000374a:	fc9c                	sd	a5,56(s1)
    yield();
    8000374c:	9b6ff0ef          	jal	80002902 <yield>
    80003750:	bf9d                	j	800036c6 <usertrap+0xce>

0000000080003752 <kerneltrap>:
{
    80003752:	7179                	addi	sp,sp,-48
    80003754:	f406                	sd	ra,40(sp)
    80003756:	f022                	sd	s0,32(sp)
    80003758:	ec26                	sd	s1,24(sp)
    8000375a:	e84a                	sd	s2,16(sp)
    8000375c:	e44e                	sd	s3,8(sp)
    8000375e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003760:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003764:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80003768:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    8000376c:	1004f793          	andi	a5,s1,256
    80003770:	c795                	beqz	a5,8000379c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003772:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003776:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80003778:	eb85                	bnez	a5,800037a8 <kerneltrap+0x56>
  if ((which_dev = devintr()) == 0) {
    8000377a:	e0bff0ef          	jal	80003584 <devintr>
    8000377e:	c91d                	beqz	a0,800037b4 <kerneltrap+0x62>
  if (which_dev == 2 && myproc() != 0) {
    80003780:	4789                	li	a5,2
    80003782:	04f50a63          	beq	a0,a5,800037d6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80003786:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000378a:	10049073          	csrw	sstatus,s1
}
    8000378e:	70a2                	ld	ra,40(sp)
    80003790:	7402                	ld	s0,32(sp)
    80003792:	64e2                	ld	s1,24(sp)
    80003794:	6942                	ld	s2,16(sp)
    80003796:	69a2                	ld	s3,8(sp)
    80003798:	6145                	addi	sp,sp,48
    8000379a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000379c:	00006517          	auipc	a0,0x6
    800037a0:	ccc50513          	addi	a0,a0,-820 # 80009468 <etext+0x468>
    800037a4:	84cfd0ef          	jal	800007f0 <panic>
    panic("kerneltrap: interrupts enabled");
    800037a8:	00006517          	auipc	a0,0x6
    800037ac:	ce850513          	addi	a0,a0,-792 # 80009490 <etext+0x490>
    800037b0:	840fd0ef          	jal	800007f0 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800037b4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800037b8:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800037bc:	85ce                	mv	a1,s3
    800037be:	00006517          	auipc	a0,0x6
    800037c2:	cf250513          	addi	a0,a0,-782 # 800094b0 <etext+0x4b0>
    800037c6:	d45fc0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    800037ca:	00006517          	auipc	a0,0x6
    800037ce:	d0e50513          	addi	a0,a0,-754 # 800094d8 <etext+0x4d8>
    800037d2:	81efd0ef          	jal	800007f0 <panic>
  if (which_dev == 2 && myproc() != 0) {
    800037d6:	9f5fe0ef          	jal	800021ca <myproc>
    800037da:	d555                	beqz	a0,80003786 <kerneltrap+0x34>
    myproc()->kernel_ticks++;
    800037dc:	9effe0ef          	jal	800021ca <myproc>
    800037e0:	653c                	ld	a5,72(a0)
    800037e2:	0785                	addi	a5,a5,1
    800037e4:	e53c                	sd	a5,72(a0)
    myproc()->cpu_time++;
    800037e6:	9e5fe0ef          	jal	800021ca <myproc>
    800037ea:	7d1c                	ld	a5,56(a0)
    800037ec:	0785                	addi	a5,a5,1
    800037ee:	fd1c                	sd	a5,56(a0)
    yield();
    800037f0:	912ff0ef          	jal	80002902 <yield>
    800037f4:	bf49                	j	80003786 <kerneltrap+0x34>

00000000800037f6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800037f6:	1101                	addi	sp,sp,-32
    800037f8:	ec06                	sd	ra,24(sp)
    800037fa:	e822                	sd	s0,16(sp)
    800037fc:	e426                	sd	s1,8(sp)
    800037fe:	1000                	addi	s0,sp,32
    80003800:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003802:	9c9fe0ef          	jal	800021ca <myproc>
  switch (n) {
    80003806:	4795                	li	a5,5
    80003808:	0497e163          	bltu	a5,s1,8000384a <argraw+0x54>
    8000380c:	048a                	slli	s1,s1,0x2
    8000380e:	00006717          	auipc	a4,0x6
    80003812:	29a70713          	addi	a4,a4,666 # 80009aa8 <states.1+0x30>
    80003816:	94ba                	add	s1,s1,a4
    80003818:	409c                	lw	a5,0(s1)
    8000381a:	97ba                	add	a5,a5,a4
    8000381c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000381e:	6d5c                	ld	a5,152(a0)
    80003820:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003822:	60e2                	ld	ra,24(sp)
    80003824:	6442                	ld	s0,16(sp)
    80003826:	64a2                	ld	s1,8(sp)
    80003828:	6105                	addi	sp,sp,32
    8000382a:	8082                	ret
    return p->trapframe->a1;
    8000382c:	6d5c                	ld	a5,152(a0)
    8000382e:	7fa8                	ld	a0,120(a5)
    80003830:	bfcd                	j	80003822 <argraw+0x2c>
    return p->trapframe->a2;
    80003832:	6d5c                	ld	a5,152(a0)
    80003834:	63c8                	ld	a0,128(a5)
    80003836:	b7f5                	j	80003822 <argraw+0x2c>
    return p->trapframe->a3;
    80003838:	6d5c                	ld	a5,152(a0)
    8000383a:	67c8                	ld	a0,136(a5)
    8000383c:	b7dd                	j	80003822 <argraw+0x2c>
    return p->trapframe->a4;
    8000383e:	6d5c                	ld	a5,152(a0)
    80003840:	6bc8                	ld	a0,144(a5)
    80003842:	b7c5                	j	80003822 <argraw+0x2c>
    return p->trapframe->a5;
    80003844:	6d5c                	ld	a5,152(a0)
    80003846:	6fc8                	ld	a0,152(a5)
    80003848:	bfe9                	j	80003822 <argraw+0x2c>
  panic("argraw");
    8000384a:	00006517          	auipc	a0,0x6
    8000384e:	c9e50513          	addi	a0,a0,-866 # 800094e8 <etext+0x4e8>
    80003852:	f9ffc0ef          	jal	800007f0 <panic>

0000000080003856 <fetchaddr>:
{
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	e04a                	sd	s2,0(sp)
    80003860:	1000                	addi	s0,sp,32
    80003862:	84aa                	mv	s1,a0
    80003864:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003866:	965fe0ef          	jal	800021ca <myproc>
  if (addr >= p->sz ||
    8000386a:	654c                	ld	a1,136(a0)
    8000386c:	02b4f663          	bgeu	s1,a1,80003898 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003870:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80003874:	02f5e463          	bltu	a1,a5,8000389c <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80003878:	4721                	li	a4,8
    8000387a:	86a6                	mv	a3,s1
    8000387c:	864a                	mv	a2,s2
    8000387e:	6948                	ld	a0,144(a0)
    80003880:	a76fe0ef          	jal	80001af6 <copyin>
    80003884:	00a03533          	snez	a0,a0
    80003888:	40a00533          	neg	a0,a0
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6902                	ld	s2,0(sp)
    80003894:	6105                	addi	sp,sp,32
    80003896:	8082                	ret
    return -1;
    80003898:	557d                	li	a0,-1
    8000389a:	bfcd                	j	8000388c <fetchaddr+0x36>
    8000389c:	557d                	li	a0,-1
    8000389e:	b7fd                	j	8000388c <fetchaddr+0x36>

00000000800038a0 <fetchstr>:
{
    800038a0:	7179                	addi	sp,sp,-48
    800038a2:	f406                	sd	ra,40(sp)
    800038a4:	f022                	sd	s0,32(sp)
    800038a6:	ec26                	sd	s1,24(sp)
    800038a8:	e84a                	sd	s2,16(sp)
    800038aa:	e44e                	sd	s3,8(sp)
    800038ac:	1800                	addi	s0,sp,48
    800038ae:	892a                	mv	s2,a0
    800038b0:	84ae                	mv	s1,a1
    800038b2:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800038b4:	917fe0ef          	jal	800021ca <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    800038b8:	874e                	mv	a4,s3
    800038ba:	86ca                	mv	a3,s2
    800038bc:	8626                	mv	a2,s1
    800038be:	654c                	ld	a1,136(a0)
    800038c0:	6948                	ld	a0,144(a0)
    800038c2:	ad6fe0ef          	jal	80001b98 <copyinstr>
    800038c6:	00054c63          	bltz	a0,800038de <fetchstr+0x3e>
  return strlen(buf);
    800038ca:	8526                	mv	a0,s1
    800038cc:	ed8fd0ef          	jal	80000fa4 <strlen>
}
    800038d0:	70a2                	ld	ra,40(sp)
    800038d2:	7402                	ld	s0,32(sp)
    800038d4:	64e2                	ld	s1,24(sp)
    800038d6:	6942                	ld	s2,16(sp)
    800038d8:	69a2                	ld	s3,8(sp)
    800038da:	6145                	addi	sp,sp,48
    800038dc:	8082                	ret
    return -1;
    800038de:	557d                	li	a0,-1
    800038e0:	bfc5                	j	800038d0 <fetchstr+0x30>

00000000800038e2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800038e2:	1101                	addi	sp,sp,-32
    800038e4:	ec06                	sd	ra,24(sp)
    800038e6:	e822                	sd	s0,16(sp)
    800038e8:	e426                	sd	s1,8(sp)
    800038ea:	1000                	addi	s0,sp,32
    800038ec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800038ee:	f09ff0ef          	jal	800037f6 <argraw>
    800038f2:	c088                	sw	a0,0(s1)
}
    800038f4:	60e2                	ld	ra,24(sp)
    800038f6:	6442                	ld	s0,16(sp)
    800038f8:	64a2                	ld	s1,8(sp)
    800038fa:	6105                	addi	sp,sp,32
    800038fc:	8082                	ret

00000000800038fe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800038fe:	1101                	addi	sp,sp,-32
    80003900:	ec06                	sd	ra,24(sp)
    80003902:	e822                	sd	s0,16(sp)
    80003904:	e426                	sd	s1,8(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000390a:	eedff0ef          	jal	800037f6 <argraw>
    8000390e:	e088                	sd	a0,0(s1)
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6105                	addi	sp,sp,32
    80003918:	8082                	ret

000000008000391a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 for error.
int
argstr(int n, char *buf, int max)
{
    8000391a:	7179                	addi	sp,sp,-48
    8000391c:	f406                	sd	ra,40(sp)
    8000391e:	f022                	sd	s0,32(sp)
    80003920:	ec26                	sd	s1,24(sp)
    80003922:	e84a                	sd	s2,16(sp)
    80003924:	1800                	addi	s0,sp,48
    80003926:	84ae                	mv	s1,a1
    80003928:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000392a:	fd840593          	addi	a1,s0,-40
    8000392e:	fd1ff0ef          	jal	800038fe <argaddr>
  return fetchstr(addr, buf, max);
    80003932:	864a                	mv	a2,s2
    80003934:	85a6                	mv	a1,s1
    80003936:	fd843503          	ld	a0,-40(s0)
    8000393a:	f67ff0ef          	jal	800038a0 <fetchstr>
}
    8000393e:	70a2                	ld	ra,40(sp)
    80003940:	7402                	ld	s0,32(sp)
    80003942:	64e2                	ld	s1,24(sp)
    80003944:	6942                	ld	s2,16(sp)
    80003946:	6145                	addi	sp,sp,48
    80003948:	8082                	ret

000000008000394a <syscall>:
  // clang-format on
};

void
syscall(void)
{
    8000394a:	7179                	addi	sp,sp,-48
    8000394c:	f406                	sd	ra,40(sp)
    8000394e:	f022                	sd	s0,32(sp)
    80003950:	ec26                	sd	s1,24(sp)
    80003952:	e84a                	sd	s2,16(sp)
    80003954:	e44e                	sd	s3,8(sp)
    80003956:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80003958:	873fe0ef          	jal	800021ca <myproc>
    8000395c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000395e:	09853903          	ld	s2,152(a0)
    80003962:	0a893783          	ld	a5,168(s2)
    80003966:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000396a:	37fd                	addiw	a5,a5,-1
    8000396c:	02600713          	li	a4,38
    80003970:	04f76863          	bltu	a4,a5,800039c0 <syscall+0x76>
    80003974:	00399713          	slli	a4,s3,0x3
    80003978:	00006797          	auipc	a5,0x6
    8000397c:	14878793          	addi	a5,a5,328 # 80009ac0 <syscalls>
    80003980:	97ba                	add	a5,a5,a4
    80003982:	6398                	ld	a4,0(a5)
    80003984:	cf15                	beqz	a4,800039c0 <syscall+0x76>
    p->syscall_count++;
    80003986:	713c                	ld	a5,96(a0)
    80003988:	0785                	addi	a5,a5,1
    8000398a:	f13c                	sd	a5,96(a0)
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000398c:	9702                	jalr	a4
    8000398e:	06a93823          	sd	a0,112(s2)
    if ((p->trace_mask >> num) & 1ULL) {
    80003992:	6cbc                	ld	a5,88(s1)
    80003994:	0137d7b3          	srl	a5,a5,s3
    80003998:	8b85                	andi	a5,a5,1
    8000399a:	c3a1                	beqz	a5,800039da <syscall+0x90>
      printk("%d: syscall %s -> %ld\n",
             p->pid, syscall_names[num], (long)p->trapframe->a0);
    8000399c:	6cd8                	ld	a4,152(s1)
      printk("%d: syscall %s -> %ld\n",
    8000399e:	098e                	slli	s3,s3,0x3
    800039a0:	00006797          	auipc	a5,0x6
    800039a4:	12078793          	addi	a5,a5,288 # 80009ac0 <syscalls>
    800039a8:	97ce                	add	a5,a5,s3
    800039aa:	7b34                	ld	a3,112(a4)
    800039ac:	1407b603          	ld	a2,320(a5)
    800039b0:	588c                	lw	a1,48(s1)
    800039b2:	00006517          	auipc	a0,0x6
    800039b6:	b3e50513          	addi	a0,a0,-1218 # 800094f0 <etext+0x4f0>
    800039ba:	b51fc0ef          	jal	8000050a <printk>
    800039be:	a831                	j	800039da <syscall+0x90>
    }
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800039c0:	86ce                	mv	a3,s3
    800039c2:	51848613          	addi	a2,s1,1304
    800039c6:	588c                	lw	a1,48(s1)
    800039c8:	00006517          	auipc	a0,0x6
    800039cc:	b4050513          	addi	a0,a0,-1216 # 80009508 <etext+0x508>
    800039d0:	b3bfc0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    800039d4:	6cdc                	ld	a5,152(s1)
    800039d6:	577d                	li	a4,-1
    800039d8:	fbb8                	sd	a4,112(a5)
  }
}
    800039da:	70a2                	ld	ra,40(sp)
    800039dc:	7402                	ld	s0,32(sp)
    800039de:	64e2                	ld	s1,24(sp)
    800039e0:	6942                	ld	s2,16(sp)
    800039e2:	69a2                	ld	s3,8(sp)
    800039e4:	6145                	addi	sp,sp,48
    800039e6:	8082                	ret

00000000800039e8 <sys_exit>:
#include "sysinfo.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800039e8:	1101                	addi	sp,sp,-32
    800039ea:	ec06                	sd	ra,24(sp)
    800039ec:	e822                	sd	s0,16(sp)
    800039ee:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800039f0:	fec40593          	addi	a1,s0,-20
    800039f4:	4501                	li	a0,0
    800039f6:	eedff0ef          	jal	800038e2 <argint>
  kexit(n);
    800039fa:	fec42503          	lw	a0,-20(s0)
    800039fe:	86aff0ef          	jal	80002a68 <kexit>
  return 0; // not reached
}
    80003a02:	4501                	li	a0,0
    80003a04:	60e2                	ld	ra,24(sp)
    80003a06:	6442                	ld	s0,16(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret

0000000080003a0c <sys_getpid>:

uint64
sys_getpid(void)
{
    80003a0c:	1141                	addi	sp,sp,-16
    80003a0e:	e406                	sd	ra,8(sp)
    80003a10:	e022                	sd	s0,0(sp)
    80003a12:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003a14:	fb6fe0ef          	jal	800021ca <myproc>
}
    80003a18:	5908                	lw	a0,48(a0)
    80003a1a:	60a2                	ld	ra,8(sp)
    80003a1c:	6402                	ld	s0,0(sp)
    80003a1e:	0141                	addi	sp,sp,16
    80003a20:	8082                	ret

0000000080003a22 <sys_fork>:

uint64
sys_fork(void)
{
    80003a22:	1141                	addi	sp,sp,-16
    80003a24:	e406                	sd	ra,8(sp)
    80003a26:	e022                	sd	s0,0(sp)
    80003a28:	0800                	addi	s0,sp,16
  return kfork();
    80003a2a:	b77fe0ef          	jal	800025a0 <kfork>
}
    80003a2e:	60a2                	ld	ra,8(sp)
    80003a30:	6402                	ld	s0,0(sp)
    80003a32:	0141                	addi	sp,sp,16
    80003a34:	8082                	ret

0000000080003a36 <sys_wait>:

uint64
sys_wait(void)
{
    80003a36:	1101                	addi	sp,sp,-32
    80003a38:	ec06                	sd	ra,24(sp)
    80003a3a:	e822                	sd	s0,16(sp)
    80003a3c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003a3e:	fe840593          	addi	a1,s0,-24
    80003a42:	4501                	li	a0,0
    80003a44:	ebbff0ef          	jal	800038fe <argaddr>
  return kwait(p);
    80003a48:	fe843503          	ld	a0,-24(s0)
    80003a4c:	98eff0ef          	jal	80002bda <kwait>
}
    80003a50:	60e2                	ld	ra,24(sp)
    80003a52:	6442                	ld	s0,16(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret

0000000080003a58 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003a58:	7179                	addi	sp,sp,-48
    80003a5a:	f406                	sd	ra,40(sp)
    80003a5c:	f022                	sd	s0,32(sp)
    80003a5e:	ec26                	sd	s1,24(sp)
    80003a60:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80003a62:	fd840593          	addi	a1,s0,-40
    80003a66:	4501                	li	a0,0
    80003a68:	e7bff0ef          	jal	800038e2 <argint>
  argint(1, &t);
    80003a6c:	fdc40593          	addi	a1,s0,-36
    80003a70:	4505                	li	a0,1
    80003a72:	e71ff0ef          	jal	800038e2 <argint>
  addr = myproc()->sz;
    80003a76:	f54fe0ef          	jal	800021ca <myproc>
    80003a7a:	6544                	ld	s1,136(a0)

  if (t == SBRK_EAGER || n < 0) {
    80003a7c:	fdc42703          	lw	a4,-36(s0)
    80003a80:	4785                	li	a5,1
    80003a82:	02f70763          	beq	a4,a5,80003ab0 <sys_sbrk+0x58>
    80003a86:	fd842783          	lw	a5,-40(s0)
    80003a8a:	0207c363          	bltz	a5,80003ab0 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80003a8e:	97a6                	add	a5,a5,s1
    80003a90:	0297ee63          	bltu	a5,s1,80003acc <sys_sbrk+0x74>
      return -1;
    if (addr + n > TRAPFRAME)
    80003a94:	02000737          	lui	a4,0x2000
    80003a98:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    80003a9a:	0736                	slli	a4,a4,0xd
    80003a9c:	02f76a63          	bltu	a4,a5,80003ad0 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80003aa0:	f2afe0ef          	jal	800021ca <myproc>
    80003aa4:	fd842703          	lw	a4,-40(s0)
    80003aa8:	655c                	ld	a5,136(a0)
    80003aaa:	97ba                	add	a5,a5,a4
    80003aac:	e55c                	sd	a5,136(a0)
    80003aae:	a039                	j	80003abc <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    80003ab0:	fd842503          	lw	a0,-40(s0)
    80003ab4:	a8bfe0ef          	jal	8000253e <growproc>
    80003ab8:	00054863          	bltz	a0,80003ac8 <sys_sbrk+0x70>
  }
  return addr;
}
    80003abc:	8526                	mv	a0,s1
    80003abe:	70a2                	ld	ra,40(sp)
    80003ac0:	7402                	ld	s0,32(sp)
    80003ac2:	64e2                	ld	s1,24(sp)
    80003ac4:	6145                	addi	sp,sp,48
    80003ac6:	8082                	ret
      return -1;
    80003ac8:	54fd                	li	s1,-1
    80003aca:	bfcd                	j	80003abc <sys_sbrk+0x64>
      return -1;
    80003acc:	54fd                	li	s1,-1
    80003ace:	b7fd                	j	80003abc <sys_sbrk+0x64>
      return -1;
    80003ad0:	54fd                	li	s1,-1
    80003ad2:	b7ed                	j	80003abc <sys_sbrk+0x64>

0000000080003ad4 <sys_pause>:

uint64
sys_pause(void)
{
    80003ad4:	7139                	addi	sp,sp,-64
    80003ad6:	fc06                	sd	ra,56(sp)
    80003ad8:	f822                	sd	s0,48(sp)
    80003ada:	ec4e                	sd	s3,24(sp)
    80003adc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003ade:	fcc40593          	addi	a1,s0,-52
    80003ae2:	4501                	li	a0,0
    80003ae4:	dffff0ef          	jal	800038e2 <argint>
  if (n < 0)
    80003ae8:	fcc42783          	lw	a5,-52(s0)
    80003aec:	0607cf63          	bltz	a5,80003b6a <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80003af0:	00243517          	auipc	a0,0x243
    80003af4:	1e850513          	addi	a0,a0,488 # 80246cd8 <tickslock>
    80003af8:	a78fd0ef          	jal	80000d70 <acquire>
  ticks0 = ticks;
    80003afc:	00006997          	auipc	s3,0x6
    80003b00:	2749a983          	lw	s3,628(s3) # 80009d70 <ticks>
  while (ticks - ticks0 < n) {
    80003b04:	fcc42783          	lw	a5,-52(s0)
    80003b08:	c7a9                	beqz	a5,80003b52 <sys_pause+0x7e>
    80003b0a:	f426                	sd	s1,40(sp)
    80003b0c:	f04a                	sd	s2,32(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80003b0e:	00006917          	auipc	s2,0x6
    80003b12:	26290913          	addi	s2,s2,610 # 80009d70 <ticks>
    release(&tickslock);
    80003b16:	00243497          	auipc	s1,0x243
    80003b1a:	1c248493          	addi	s1,s1,450 # 80246cd8 <tickslock>
    if (killed(myproc())) {
    80003b1e:	eacfe0ef          	jal	800021ca <myproc>
    80003b22:	88eff0ef          	jal	80002bb0 <killed>
    80003b26:	e529                	bnez	a0,80003b70 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80003b28:	854a                	mv	a0,s2
    80003b2a:	e05fe0ef          	jal	8000292e <sleep_prepare>
    release(&tickslock);
    80003b2e:	8526                	mv	a0,s1
    80003b30:	accfd0ef          	jal	80000dfc <release>
    sleep();
    80003b34:	e37fe0ef          	jal	8000296a <sleep>
    acquire(&tickslock);
    80003b38:	8526                	mv	a0,s1
    80003b3a:	a36fd0ef          	jal	80000d70 <acquire>
  while (ticks - ticks0 < n) {
    80003b3e:	00092783          	lw	a5,0(s2)
    80003b42:	413787bb          	subw	a5,a5,s3
    80003b46:	fcc42703          	lw	a4,-52(s0)
    80003b4a:	fce7eae3          	bltu	a5,a4,80003b1e <sys_pause+0x4a>
    80003b4e:	74a2                	ld	s1,40(sp)
    80003b50:	7902                	ld	s2,32(sp)
  }
  release(&tickslock);
    80003b52:	00243517          	auipc	a0,0x243
    80003b56:	18650513          	addi	a0,a0,390 # 80246cd8 <tickslock>
    80003b5a:	aa2fd0ef          	jal	80000dfc <release>
  return 0;
    80003b5e:	4501                	li	a0,0
}
    80003b60:	70e2                	ld	ra,56(sp)
    80003b62:	7442                	ld	s0,48(sp)
    80003b64:	69e2                	ld	s3,24(sp)
    80003b66:	6121                	addi	sp,sp,64
    80003b68:	8082                	ret
    n = 0;
    80003b6a:	fc042623          	sw	zero,-52(s0)
    80003b6e:	b749                	j	80003af0 <sys_pause+0x1c>
      release(&tickslock);
    80003b70:	00243517          	auipc	a0,0x243
    80003b74:	16850513          	addi	a0,a0,360 # 80246cd8 <tickslock>
    80003b78:	a84fd0ef          	jal	80000dfc <release>
      return -1;
    80003b7c:	557d                	li	a0,-1
    80003b7e:	74a2                	ld	s1,40(sp)
    80003b80:	7902                	ld	s2,32(sp)
    80003b82:	bff9                	j	80003b60 <sys_pause+0x8c>

0000000080003b84 <sys_kill>:

uint64
sys_kill(void)
{
    80003b84:	1101                	addi	sp,sp,-32
    80003b86:	ec06                	sd	ra,24(sp)
    80003b88:	e822                	sd	s0,16(sp)
    80003b8a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003b8c:	fec40593          	addi	a1,s0,-20
    80003b90:	4501                	li	a0,0
    80003b92:	d51ff0ef          	jal	800038e2 <argint>
  return kkill(pid);
    80003b96:	fec42503          	lw	a0,-20(s0)
    80003b9a:	f7dfe0ef          	jal	80002b16 <kkill>
}
    80003b9e:	60e2                	ld	ra,24(sp)
    80003ba0:	6442                	ld	s0,16(sp)
    80003ba2:	6105                	addi	sp,sp,32
    80003ba4:	8082                	ret

0000000080003ba6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003ba6:	1101                	addi	sp,sp,-32
    80003ba8:	ec06                	sd	ra,24(sp)
    80003baa:	e822                	sd	s0,16(sp)
    80003bac:	e426                	sd	s1,8(sp)
    80003bae:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80003bb0:	00243517          	auipc	a0,0x243
    80003bb4:	12850513          	addi	a0,a0,296 # 80246cd8 <tickslock>
    80003bb8:	9b8fd0ef          	jal	80000d70 <acquire>
  xticks = ticks;
    80003bbc:	00006497          	auipc	s1,0x6
    80003bc0:	1b44a483          	lw	s1,436(s1) # 80009d70 <ticks>
  release(&tickslock);
    80003bc4:	00243517          	auipc	a0,0x243
    80003bc8:	11450513          	addi	a0,a0,276 # 80246cd8 <tickslock>
    80003bcc:	a30fd0ef          	jal	80000dfc <release>
  return xticks;
}
    80003bd0:	02049513          	slli	a0,s1,0x20
    80003bd4:	9101                	srli	a0,a0,0x20
    80003bd6:	60e2                	ld	ra,24(sp)
    80003bd8:	6442                	ld	s0,16(sp)
    80003bda:	64a2                	ld	s1,8(sp)
    80003bdc:	6105                	addi	sp,sp,32
    80003bde:	8082                	ret

0000000080003be0 <sys_ps>:

uint64
sys_ps(void)
{
    80003be0:	1141                	addi	sp,sp,-16
    80003be2:	e406                	sd	ra,8(sp)
    80003be4:	e022                	sd	s0,0(sp)
    80003be6:	0800                	addi	s0,sp,16
  procdump();
    80003be8:	b42ff0ef          	jal	80002f2a <procdump>
  return 0;
}
    80003bec:	4501                	li	a0,0
    80003bee:	60a2                	ld	ra,8(sp)
    80003bf0:	6402                	ld	s0,0(sp)
    80003bf2:	0141                	addi	sp,sp,16
    80003bf4:	8082                	ret

0000000080003bf6 <sys_setpriority>:

uint64
sys_setpriority(void)
{
    80003bf6:	1101                	addi	sp,sp,-32
    80003bf8:	ec06                	sd	ra,24(sp)
    80003bfa:	e822                	sd	s0,16(sp)
    80003bfc:	1000                	addi	s0,sp,32
  int pid;
  int priority;

  argint(0, &pid);
    80003bfe:	fec40593          	addi	a1,s0,-20
    80003c02:	4501                	li	a0,0
    80003c04:	cdfff0ef          	jal	800038e2 <argint>
  argint(1, &priority);
    80003c08:	fe840593          	addi	a1,s0,-24
    80003c0c:	4505                	li	a0,1
    80003c0e:	cd5ff0ef          	jal	800038e2 <argint>

  if (pid < 0 || priority < PRIO_MIN || priority > PRIO_MAX)
    80003c12:	fec42503          	lw	a0,-20(s0)
    80003c16:	00054f63          	bltz	a0,80003c34 <sys_setpriority+0x3e>
    80003c1a:	fe842583          	lw	a1,-24(s0)
    80003c1e:	fff5871b          	addiw	a4,a1,-1
    80003c22:	47cd                	li	a5,19
    80003c24:	00e7ea63          	bltu	a5,a4,80003c38 <sys_setpriority+0x42>
    return -1;

  return setpriority(pid, priority);
    80003c28:	cc4ff0ef          	jal	800030ec <setpriority>
}
    80003c2c:	60e2                	ld	ra,24(sp)
    80003c2e:	6442                	ld	s0,16(sp)
    80003c30:	6105                	addi	sp,sp,32
    80003c32:	8082                	ret
    return -1;
    80003c34:	557d                	li	a0,-1
    80003c36:	bfdd                	j	80003c2c <sys_setpriority+0x36>
    80003c38:	557d                	li	a0,-1
    80003c3a:	bfcd                	j	80003c2c <sys_setpriority+0x36>

0000000080003c3c <sys_getpriority>:

uint64
sys_getpriority(void)
{
    80003c3c:	1101                	addi	sp,sp,-32
    80003c3e:	ec06                	sd	ra,24(sp)
    80003c40:	e822                	sd	s0,16(sp)
    80003c42:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003c44:	fec40593          	addi	a1,s0,-20
    80003c48:	4501                	li	a0,0
    80003c4a:	c99ff0ef          	jal	800038e2 <argint>

  if (pid < 0)
    80003c4e:	fec42783          	lw	a5,-20(s0)
    return -1;
    80003c52:	557d                	li	a0,-1
  if (pid < 0)
    80003c54:	0007c563          	bltz	a5,80003c5e <sys_getpriority+0x22>

  return getpriority(pid);
    80003c58:	853e                	mv	a0,a5
    80003c5a:	d0eff0ef          	jal	80003168 <getpriority>
}
    80003c5e:	60e2                	ld	ra,24(sp)
    80003c60:	6442                	ld	s0,16(sp)
    80003c62:	6105                	addi	sp,sp,32
    80003c64:	8082                	ret

0000000080003c66 <sys_getcowfaults>:

uint64
sys_getcowfaults(void)
{
    80003c66:	1101                	addi	sp,sp,-32
    80003c68:	ec06                	sd	ra,24(sp)
    80003c6a:	e822                	sd	s0,16(sp)
    80003c6c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003c6e:	fec40593          	addi	a1,s0,-20
    80003c72:	4501                	li	a0,0
    80003c74:	c6fff0ef          	jal	800038e2 <argint>
  return getcowfaults_proc(pid);
    80003c78:	fec42503          	lw	a0,-20(s0)
    80003c7c:	d60ff0ef          	jal	800031dc <getcowfaults_proc>
}
    80003c80:	60e2                	ld	ra,24(sp)
    80003c82:	6442                	ld	s0,16(sp)
    80003c84:	6105                	addi	sp,sp,32
    80003c86:	8082                	ret

0000000080003c88 <mmap_find_addr>:

// Find an unused virtual address range below TRAPFRAME for a new mmap VMA.
uint64
mmap_find_addr(struct proc *p, uint64 length)
{
    80003c88:	1141                	addi	sp,sp,-16
    80003c8a:	e422                	sd	s0,8(sp)
    80003c8c:	0800                	addi	s0,sp,16
    80003c8e:	882a                	mv	a6,a0
  uint64 end;
  int i;

  end = TRAPFRAME;

  for (i = 0; i < NVMA; i++) {
    80003c90:	19850793          	addi	a5,a0,408
    80003c94:	51850613          	addi	a2,a0,1304
  end = TRAPFRAME;
    80003c98:	020006b7          	lui	a3,0x2000
    80003c9c:	16fd                	addi	a3,a3,-1 # 1ffffff <_entry-0x7e000001>
    80003c9e:	06b6                	slli	a3,a3,0xd
    80003ca0:	a029                	j	80003caa <mmap_find_addr+0x22>
  for (i = 0; i < NVMA; i++) {
    80003ca2:	03878793          	addi	a5,a5,56
    80003ca6:	00c78963          	beq	a5,a2,80003cb8 <mmap_find_addr+0x30>
    if (p->vmas[i].used && p->vmas[i].addr < end)
    80003caa:	4398                	lw	a4,0(a5)
    80003cac:	db7d                	beqz	a4,80003ca2 <mmap_find_addr+0x1a>
    80003cae:	6798                	ld	a4,8(a5)
    80003cb0:	fed779e3          	bgeu	a4,a3,80003ca2 <mmap_find_addr+0x1a>
    80003cb4:	86ba                	mv	a3,a4
    80003cb6:	b7f5                	j	80003ca2 <mmap_find_addr+0x1a>
      end = p->vmas[i].addr;
  }

  length = PGROUNDUP(length);
    80003cb8:	6785                	lui	a5,0x1
    80003cba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80003cbc:	97ae                	add	a5,a5,a1
    80003cbe:	777d                	lui	a4,0xfffff
    80003cc0:	8ff9                	and	a5,a5,a4
  if (length > end)
    return 0;
    80003cc2:	4501                	li	a0,0
  if (length > end)
    80003cc4:	00f6e963          	bltu	a3,a5,80003cd6 <mmap_find_addr+0x4e>

  addr = PGROUNDDOWN(end - length);
    80003cc8:	8e9d                	sub	a3,a3,a5
    80003cca:	757d                	lui	a0,0xfffff
    80003ccc:	8d75                	and	a0,a0,a3
  if (addr < p->sz)
    80003cce:	08883783          	ld	a5,136(a6)
    80003cd2:	00f56563          	bltu	a0,a5,80003cdc <mmap_find_addr+0x54>
    return 0;

  return addr;
}
    80003cd6:	6422                	ld	s0,8(sp)
    80003cd8:	0141                	addi	sp,sp,16
    80003cda:	8082                	ret
    return 0;
    80003cdc:	4501                	li	a0,0
    80003cde:	bfe5                	j	80003cd6 <mmap_find_addr+0x4e>

0000000080003ce0 <sys_mmap>:

// Reserve a lazy virtual memory mapping (file-backed or MAP_ANONYMOUS).
// Physical pages are allocated on demand by mmapfault() on first access.
uint64
sys_mmap(void)
{
    80003ce0:	7159                	addi	sp,sp,-112
    80003ce2:	f486                	sd	ra,104(sp)
    80003ce4:	f0a2                	sd	s0,96(sp)
    80003ce6:	e4ce                	sd	s3,72(sp)
    80003ce8:	e0d2                	sd	s4,64(sp)
    80003cea:	1880                	addi	s0,sp,112
  int fd;
  int is_anon;
  int is_shared;
  int is_private;
  struct file *f = 0;
  struct proc *p = myproc();
    80003cec:	cdefe0ef          	jal	800021ca <myproc>
    80003cf0:	89aa                	mv	s3,a0
  struct vma *vma;
  int i;

  argaddr(0, &addr);
    80003cf2:	fb840593          	addi	a1,s0,-72
    80003cf6:	4501                	li	a0,0
    80003cf8:	c07ff0ef          	jal	800038fe <argaddr>
  argaddr(1, &length);
    80003cfc:	fb040593          	addi	a1,s0,-80
    80003d00:	4505                	li	a0,1
    80003d02:	bfdff0ef          	jal	800038fe <argaddr>
  argint(2, &prot);
    80003d06:	fa440593          	addi	a1,s0,-92
    80003d0a:	4509                	li	a0,2
    80003d0c:	bd7ff0ef          	jal	800038e2 <argint>
  argint(3, &flags);
    80003d10:	fa040593          	addi	a1,s0,-96
    80003d14:	450d                	li	a0,3
    80003d16:	bcdff0ef          	jal	800038e2 <argint>
  argint(4, &fd);
    80003d1a:	f9c40593          	addi	a1,s0,-100
    80003d1e:	4511                	li	a0,4
    80003d20:	bc3ff0ef          	jal	800038e2 <argint>
  argaddr(5, &offset);
    80003d24:	fa840593          	addi	a1,s0,-88
    80003d28:	4515                	li	a0,5
    80003d2a:	bd5ff0ef          	jal	800038fe <argaddr>

  if (length == 0)
    80003d2e:	fb043a03          	ld	s4,-80(s0)
    return -1;
    80003d32:	557d                	li	a0,-1
  if (length == 0)
    80003d34:	160a0163          	beqz	s4,80003e96 <sys_mmap+0x1b6>

  if (offset % PGSIZE != 0)
    80003d38:	fa843783          	ld	a5,-88(s0)
    80003d3c:	03479713          	slli	a4,a5,0x34
    80003d40:	14071b63          	bnez	a4,80003e96 <sys_mmap+0x1b6>
    80003d44:	fc56                	sd	s5,56(sp)
    return -1;

  if (prot & ~(PROT_READ | PROT_WRITE))
    80003d46:	fa442a83          	lw	s5,-92(s0)
    80003d4a:	000a869b          	sext.w	a3,s5
    80003d4e:	470d                	li	a4,3
    80003d50:	14d76263          	bltu	a4,a3,80003e94 <sys_mmap+0x1b4>
    80003d54:	e8ca                	sd	s2,80(sp)
    return -1;

  if (flags & ~(MAP_SHARED | MAP_PRIVATE | MAP_ANONYMOUS))
    80003d56:	fa042903          	lw	s2,-96(s0)
    80003d5a:	0009069b          	sext.w	a3,s2
    80003d5e:	471d                	li	a4,7
    80003d60:	14d76163          	bltu	a4,a3,80003ea2 <sys_mmap+0x1c2>

  is_anon = (flags & MAP_ANONYMOUS) != 0;
  is_shared = (flags & MAP_SHARED) != 0;
  is_private = (flags & MAP_PRIVATE) != 0;

  if (is_shared && is_private)
    80003d64:	00397713          	andi	a4,s2,3
    80003d68:	468d                	li	a3,3
    80003d6a:	08d70b63          	beq	a4,a3,80003e00 <sys_mmap+0x120>
    return -1;

  if (!is_anon && !is_shared && !is_private)
    80003d6e:	00797713          	andi	a4,s2,7
    80003d72:	12070b63          	beqz	a4,80003ea8 <sys_mmap+0x1c8>
    80003d76:	f85a                	sd	s6,48(sp)
    return -1;

  if (is_anon) {
    80003d78:	00497713          	andi	a4,s2,4
    80003d7c:	cb1d                	beqz	a4,80003db2 <sys_mmap+0xd2>
    // Anonymous mappings have no backing file and must use fd == -1, offset 0.
    if (fd != -1 || offset != 0)
    80003d7e:	f9c42683          	lw	a3,-100(s0)
    80003d82:	577d                	li	a4,-1
    80003d84:	12e69563          	bne	a3,a4,80003eae <sys_mmap+0x1ce>
    80003d88:	12079763          	bnez	a5,80003eb6 <sys_mmap+0x1d6>
    80003d8c:	eca6                	sd	s1,88(sp)
  struct file *f = 0;
    80003d8e:	4b01                	li	s6,0

    if (is_shared && (prot & PROT_WRITE) && !f->writable)
      return -1;
  }

  for (i = 0; i < NVMA; i++) {
    80003d90:	19898793          	addi	a5,s3,408
    80003d94:	4481                	li	s1,0
    80003d96:	46c1                	li	a3,16
    if (p->vmas[i].used == 0)
    80003d98:	4398                	lw	a4,0(a5)
    80003d9a:	cf25                	beqz	a4,80003e12 <sys_mmap+0x132>
  for (i = 0; i < NVMA; i++) {
    80003d9c:	2485                	addiw	s1,s1,1
    80003d9e:	03878793          	addi	a5,a5,56
    80003da2:	fed49be3          	bne	s1,a3,80003d98 <sys_mmap+0xb8>
      break;
  }

  if (i == NVMA)
    return -1;
    80003da6:	557d                	li	a0,-1
    80003da8:	64e6                	ld	s1,88(sp)
    80003daa:	6946                	ld	s2,80(sp)
    80003dac:	7ae2                	ld	s5,56(sp)
    80003dae:	7b42                	ld	s6,48(sp)
    80003db0:	a0dd                	j	80003e96 <sys_mmap+0x1b6>
    if (fd < 0 || fd >= NOFILE)
    80003db2:	f9c42783          	lw	a5,-100(s0)
    80003db6:	0007869b          	sext.w	a3,a5
    80003dba:	473d                	li	a4,15
      return -1;
    80003dbc:	557d                	li	a0,-1
    if (fd < 0 || fd >= NOFILE)
    80003dbe:	10d76063          	bltu	a4,a3,80003ebe <sys_mmap+0x1de>
    f = p->ofile[fd];
    80003dc2:	02278793          	addi	a5,a5,34
    80003dc6:	078e                	slli	a5,a5,0x3
    80003dc8:	97ce                	add	a5,a5,s3
    80003dca:	0007bb03          	ld	s6,0(a5)
    if (f == 0 || f->type != FD_INODE)
    80003dce:	020b0d63          	beqz	s6,80003e08 <sys_mmap+0x128>
    80003dd2:	000b2703          	lw	a4,0(s6)
    80003dd6:	4789                	li	a5,2
    80003dd8:	0ef71763          	bne	a4,a5,80003ec6 <sys_mmap+0x1e6>
    if (!f->readable)
    80003ddc:	008b4783          	lbu	a5,8(s6)
    80003de0:	c7fd                	beqz	a5,80003ece <sys_mmap+0x1ee>
    if (is_shared && (prot & PROT_WRITE) && !f->writable)
    80003de2:	00197793          	andi	a5,s2,1
    80003de6:	cb89                	beqz	a5,80003df8 <sys_mmap+0x118>
    80003de8:	002af793          	andi	a5,s5,2
    80003dec:	cb81                	beqz	a5,80003dfc <sys_mmap+0x11c>
    80003dee:	009b4783          	lbu	a5,9(s6)
    80003df2:	c3f5                	beqz	a5,80003ed6 <sys_mmap+0x1f6>
    80003df4:	eca6                	sd	s1,88(sp)
    80003df6:	bf69                	j	80003d90 <sys_mmap+0xb0>
    80003df8:	eca6                	sd	s1,88(sp)
    80003dfa:	bf59                	j	80003d90 <sys_mmap+0xb0>
    80003dfc:	eca6                	sd	s1,88(sp)
    80003dfe:	bf49                	j	80003d90 <sys_mmap+0xb0>
    return -1;
    80003e00:	557d                	li	a0,-1
    80003e02:	6946                	ld	s2,80(sp)
    80003e04:	7ae2                	ld	s5,56(sp)
    80003e06:	a841                	j	80003e96 <sys_mmap+0x1b6>
      return -1;
    80003e08:	557d                	li	a0,-1
    80003e0a:	6946                	ld	s2,80(sp)
    80003e0c:	7ae2                	ld	s5,56(sp)
    80003e0e:	7b42                	ld	s6,48(sp)
    80003e10:	a059                	j	80003e96 <sys_mmap+0x1b6>

  vma = &p->vmas[i];
  vma->addr = mmap_find_addr(p, length);
    80003e12:	85d2                	mv	a1,s4
    80003e14:	854e                	mv	a0,s3
    80003e16:	e73ff0ef          	jal	80003c88 <mmap_find_addr>
    80003e1a:	872a                	mv	a4,a0
    80003e1c:	00349793          	slli	a5,s1,0x3
    80003e20:	8f85                	sub	a5,a5,s1
    80003e22:	078e                	slli	a5,a5,0x3
    80003e24:	97ce                	add	a5,a5,s3
    80003e26:	1aa7b023          	sd	a0,416(a5)
  if (vma->addr == 0)
    return -1;
    80003e2a:	557d                	li	a0,-1
  if (vma->addr == 0)
    80003e2c:	cf39                	beqz	a4,80003e8a <sys_mmap+0x1aa>

  vma->used = 1;
    80003e2e:	00349793          	slli	a5,s1,0x3
    80003e32:	8f85                	sub	a5,a5,s1
    80003e34:	078e                	slli	a5,a5,0x3
    80003e36:	97ce                	add	a5,a5,s3
    80003e38:	4705                	li	a4,1
    80003e3a:	18e7ac23          	sw	a4,408(a5)
  vma->length = length;
    80003e3e:	1b47b423          	sd	s4,424(a5)
  vma->maplen = PGROUNDUP(length);
    80003e42:	6705                	lui	a4,0x1
    80003e44:	177d                	addi	a4,a4,-1 # fff <_entry-0x7ffff001>
    80003e46:	9752                	add	a4,a4,s4
    80003e48:	76fd                	lui	a3,0xfffff
    80003e4a:	8f75                	and	a4,a4,a3
    80003e4c:	1ae7b823          	sd	a4,432(a5)
  vma->prot = prot;
    80003e50:	1b57ac23          	sw	s5,440(a5)
  vma->flags = flags;
    80003e54:	1b27ae23          	sw	s2,444(a5)
  vma->file = f ? filedup(f) : 0;
    80003e58:	000b0663          	beqz	s6,80003e64 <sys_mmap+0x184>
    80003e5c:	855a                	mv	a0,s6
    80003e5e:	0bb010ef          	jal	80005718 <filedup>
    80003e62:	8b2a                	mv	s6,a0
    80003e64:	00349793          	slli	a5,s1,0x3
    80003e68:	40978733          	sub	a4,a5,s1
    80003e6c:	070e                	slli	a4,a4,0x3
    80003e6e:	974e                	add	a4,a4,s3
    80003e70:	1d673023          	sd	s6,448(a4)
  vma->offset = offset;
    80003e74:	fa843683          	ld	a3,-88(s0)
    80003e78:	1cd73423          	sd	a3,456(a4)

  return vma->addr;
    80003e7c:	1a073503          	ld	a0,416(a4)
    80003e80:	64e6                	ld	s1,88(sp)
    80003e82:	6946                	ld	s2,80(sp)
    80003e84:	7ae2                	ld	s5,56(sp)
    80003e86:	7b42                	ld	s6,48(sp)
    80003e88:	a039                	j	80003e96 <sys_mmap+0x1b6>
    80003e8a:	64e6                	ld	s1,88(sp)
    80003e8c:	6946                	ld	s2,80(sp)
    80003e8e:	7ae2                	ld	s5,56(sp)
    80003e90:	7b42                	ld	s6,48(sp)
    80003e92:	a011                	j	80003e96 <sys_mmap+0x1b6>
    80003e94:	7ae2                	ld	s5,56(sp)
}
    80003e96:	70a6                	ld	ra,104(sp)
    80003e98:	7406                	ld	s0,96(sp)
    80003e9a:	69a6                	ld	s3,72(sp)
    80003e9c:	6a06                	ld	s4,64(sp)
    80003e9e:	6165                	addi	sp,sp,112
    80003ea0:	8082                	ret
    80003ea2:	6946                	ld	s2,80(sp)
    80003ea4:	7ae2                	ld	s5,56(sp)
    80003ea6:	bfc5                	j	80003e96 <sys_mmap+0x1b6>
    80003ea8:	6946                	ld	s2,80(sp)
    80003eaa:	7ae2                	ld	s5,56(sp)
    80003eac:	b7ed                	j	80003e96 <sys_mmap+0x1b6>
    80003eae:	6946                	ld	s2,80(sp)
    80003eb0:	7ae2                	ld	s5,56(sp)
    80003eb2:	7b42                	ld	s6,48(sp)
    80003eb4:	b7cd                	j	80003e96 <sys_mmap+0x1b6>
    80003eb6:	6946                	ld	s2,80(sp)
    80003eb8:	7ae2                	ld	s5,56(sp)
    80003eba:	7b42                	ld	s6,48(sp)
    80003ebc:	bfe9                	j	80003e96 <sys_mmap+0x1b6>
    80003ebe:	6946                	ld	s2,80(sp)
    80003ec0:	7ae2                	ld	s5,56(sp)
    80003ec2:	7b42                	ld	s6,48(sp)
    80003ec4:	bfc9                	j	80003e96 <sys_mmap+0x1b6>
    80003ec6:	6946                	ld	s2,80(sp)
    80003ec8:	7ae2                	ld	s5,56(sp)
    80003eca:	7b42                	ld	s6,48(sp)
    80003ecc:	b7e9                	j	80003e96 <sys_mmap+0x1b6>
    80003ece:	6946                	ld	s2,80(sp)
    80003ed0:	7ae2                	ld	s5,56(sp)
    80003ed2:	7b42                	ld	s6,48(sp)
    80003ed4:	b7c9                	j	80003e96 <sys_mmap+0x1b6>
    80003ed6:	6946                	ld	s2,80(sp)
    80003ed8:	7ae2                	ld	s5,56(sp)
    80003eda:	7b42                	ld	s6,48(sp)
    80003edc:	bf6d                	j	80003e96 <sys_mmap+0x1b6>

0000000080003ede <sys_munmap>:

uint64
sys_munmap(void)
{
    80003ede:	1101                	addi	sp,sp,-32
    80003ee0:	ec06                	sd	ra,24(sp)
    80003ee2:	e822                	sd	s0,16(sp)
    80003ee4:	1000                	addi	s0,sp,32
  uint64 addr;
  uint64 length;

  argaddr(0, &addr);
    80003ee6:	fe840593          	addi	a1,s0,-24
    80003eea:	4501                	li	a0,0
    80003eec:	a13ff0ef          	jal	800038fe <argaddr>
  argaddr(1, &length);
    80003ef0:	fe040593          	addi	a1,s0,-32
    80003ef4:	4505                	li	a0,1
    80003ef6:	a09ff0ef          	jal	800038fe <argaddr>

  if (length == 0)
    80003efa:	fe043783          	ld	a5,-32(s0)
    return -1;
    80003efe:	557d                	li	a0,-1
  if (length == 0)
    80003f00:	cf89                	beqz	a5,80003f1a <sys_munmap+0x3c>

  if (addr % PGSIZE != 0)
    80003f02:	fe843783          	ld	a5,-24(s0)
    80003f06:	17d2                	slli	a5,a5,0x34
    80003f08:	eb89                	bnez	a5,80003f1a <sys_munmap+0x3c>
    return -1;

  return mmap_unmap(myproc(), addr, length);
    80003f0a:	ac0fe0ef          	jal	800021ca <myproc>
    80003f0e:	fe043603          	ld	a2,-32(s0)
    80003f12:	fe843583          	ld	a1,-24(s0)
    80003f16:	d5dfd0ef          	jal	80001c72 <mmap_unmap>
}
    80003f1a:	60e2                	ld	ra,24(sp)
    80003f1c:	6442                	ld	s0,16(sp)
    80003f1e:	6105                	addi	sp,sp,32
    80003f20:	8082                	ret

0000000080003f22 <sys_trace>:

uint64
sys_trace(void)
{
    80003f22:	1101                	addi	sp,sp,-32
    80003f24:	ec06                	sd	ra,24(sp)
    80003f26:	e822                	sd	s0,16(sp)
    80003f28:	1000                	addi	s0,sp,32
  uint64 mask;

  argaddr(0, &mask);
    80003f2a:	fe840593          	addi	a1,s0,-24
    80003f2e:	4501                	li	a0,0
    80003f30:	9cfff0ef          	jal	800038fe <argaddr>
  myproc()->trace_mask = mask;
    80003f34:	a96fe0ef          	jal	800021ca <myproc>
    80003f38:	fe843783          	ld	a5,-24(s0)
    80003f3c:	ed3c                	sd	a5,88(a0)
  return 0;
}
    80003f3e:	4501                	li	a0,0
    80003f40:	60e2                	ld	ra,24(sp)
    80003f42:	6442                	ld	s0,16(sp)
    80003f44:	6105                	addi	sp,sp,32
    80003f46:	8082                	ret

0000000080003f48 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80003f48:	715d                	addi	sp,sp,-80
    80003f4a:	e486                	sd	ra,72(sp)
    80003f4c:	e0a2                	sd	s0,64(sp)
    80003f4e:	fc26                	sd	s1,56(sp)
    80003f50:	0880                	addi	s0,sp,80
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    80003f52:	a78fe0ef          	jal	800021ca <myproc>
    80003f56:	84aa                	mv	s1,a0

  argaddr(0, &addr);
    80003f58:	fd840593          	addi	a1,s0,-40
    80003f5c:	4501                	li	a0,0
    80003f5e:	9a1ff0ef          	jal	800038fe <argaddr>

  info.freemem = kfreemem();
    80003f62:	d31fc0ef          	jal	80000c92 <kfreemem>
    80003f66:	faa43c23          	sd	a0,-72(s0)
  info.totalmem = ktotalmem();
    80003f6a:	d6bfc0ef          	jal	80000cd4 <ktotalmem>
    80003f6e:	fca43023          	sd	a0,-64(s0)
  info.nproc = nproc_active();
    80003f72:	ad4ff0ef          	jal	80003246 <nproc_active>
    80003f76:	fca43423          	sd	a0,-56(s0)
  acquire(&tickslock);
    80003f7a:	00243517          	auipc	a0,0x243
    80003f7e:	d5e50513          	addi	a0,a0,-674 # 80246cd8 <tickslock>
    80003f82:	deffc0ef          	jal	80000d70 <acquire>
  info.uptime = ticks;
    80003f86:	00006797          	auipc	a5,0x6
    80003f8a:	dea7e783          	lwu	a5,-534(a5) # 80009d70 <ticks>
    80003f8e:	fcf43823          	sd	a5,-48(s0)
  release(&tickslock);
    80003f92:	00243517          	auipc	a0,0x243
    80003f96:	d4650513          	addi	a0,a0,-698 # 80246cd8 <tickslock>
    80003f9a:	e63fc0ef          	jal	80000dfc <release>

  if(copyout(p->pagetable, p->sz, addr, (char *)&info, sizeof(info)) < 0)
    80003f9e:	02000713          	li	a4,32
    80003fa2:	fb840693          	addi	a3,s0,-72
    80003fa6:	fd843603          	ld	a2,-40(s0)
    80003faa:	64cc                	ld	a1,136(s1)
    80003fac:	68c8                	ld	a0,144(s1)
    80003fae:	9fbfd0ef          	jal	800019a8 <copyout>
    return -1;

  return 0;
}
    80003fb2:	957d                	srai	a0,a0,0x3f
    80003fb4:	60a6                	ld	ra,72(sp)
    80003fb6:	6406                	ld	s0,64(sp)
    80003fb8:	74e2                	ld	s1,56(sp)
    80003fba:	6161                	addi	sp,sp,80
    80003fbc:	8082                	ret

0000000080003fbe <sys_getppid>:

uint64
sys_getppid(void)
{
    80003fbe:	1141                	addi	sp,sp,-16
    80003fc0:	e406                	sd	ra,8(sp)
    80003fc2:	e022                	sd	s0,0(sp)
    80003fc4:	0800                	addi	s0,sp,16
  return kgetppid();
    80003fc6:	accff0ef          	jal	80003292 <kgetppid>
}
    80003fca:	60a2                	ld	ra,8(sp)
    80003fcc:	6402                	ld	s0,0(sp)
    80003fce:	0141                	addi	sp,sp,16
    80003fd0:	8082                	ret

0000000080003fd2 <sys_ptree>:

uint64
sys_ptree(void)
{
    80003fd2:	1141                	addi	sp,sp,-16
    80003fd4:	e406                	sd	ra,8(sp)
    80003fd6:	e022                	sd	s0,0(sp)
    80003fd8:	0800                	addi	s0,sp,16
  proctree();
    80003fda:	b04ff0ef          	jal	800032de <proctree>
  return 0;
}
    80003fde:	4501                	li	a0,0
    80003fe0:	60a2                	ld	ra,8(sp)
    80003fe2:	6402                	ld	s0,0(sp)
    80003fe4:	0141                	addi	sp,sp,16
    80003fe6:	8082                	ret

0000000080003fe8 <sys_getsyscallcount>:

uint64
sys_getsyscallcount(void)
{
    80003fe8:	1101                	addi	sp,sp,-32
    80003fea:	ec06                	sd	ra,24(sp)
    80003fec:	e822                	sd	s0,16(sp)
    80003fee:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003ff0:	fec40593          	addi	a1,s0,-20
    80003ff4:	4501                	li	a0,0
    80003ff6:	8edff0ef          	jal	800038e2 <argint>
  return getsyscallcount_proc(pid);
    80003ffa:	fec42503          	lw	a0,-20(s0)
    80003ffe:	baeff0ef          	jal	800033ac <getsyscallcount_proc>
}
    80004002:	60e2                	ld	ra,24(sp)
    80004004:	6442                	ld	s0,16(sp)
    80004006:	6105                	addi	sp,sp,32
    80004008:	8082                	ret

000000008000400a <sys_waitx>:

uint64
sys_waitx(void)
{
    8000400a:	7179                	addi	sp,sp,-48
    8000400c:	f406                	sd	ra,40(sp)
    8000400e:	f022                	sd	s0,32(sp)
    80004010:	1800                	addi	s0,sp,48
  uint64 addr, waddr, raddr;

  argaddr(0, &addr);
    80004012:	fe840593          	addi	a1,s0,-24
    80004016:	4501                	li	a0,0
    80004018:	8e7ff0ef          	jal	800038fe <argaddr>
  argaddr(1, &waddr);
    8000401c:	fe040593          	addi	a1,s0,-32
    80004020:	4505                	li	a0,1
    80004022:	8ddff0ef          	jal	800038fe <argaddr>
  argaddr(2, &raddr);
    80004026:	fd840593          	addi	a1,s0,-40
    8000402a:	4509                	li	a0,2
    8000402c:	8d3ff0ef          	jal	800038fe <argaddr>

  return kwaitx(addr, waddr, raddr);
    80004030:	fd843603          	ld	a2,-40(s0)
    80004034:	fe043583          	ld	a1,-32(s0)
    80004038:	fe843503          	ld	a0,-24(s0)
    8000403c:	caffe0ef          	jal	80002cea <kwaitx>
}
    80004040:	70a2                	ld	ra,40(sp)
    80004042:	7402                	ld	s0,32(sp)
    80004044:	6145                	addi	sp,sp,48
    80004046:	8082                	ret

0000000080004048 <sys_halt>:

uint64
sys_halt(void)
{
    80004048:	1141                	addi	sp,sp,-16
    8000404a:	e406                	sd	ra,8(sp)
    8000404c:	e022                	sd	s0,0(sp)
    8000404e:	0800                	addi	s0,sp,16
  printk("System halting...\n");
    80004050:	00005517          	auipc	a0,0x5
    80004054:	63850513          	addi	a0,a0,1592 # 80009688 <etext+0x688>
    80004058:	cb2fc0ef          	jal	8000050a <printk>
  *(volatile uint32 *)VIRT_TEST = 0x5555;
    8000405c:	6795                	lui	a5,0x5
    8000405e:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80004062:	00100737          	lui	a4,0x100
    80004066:	c31c                	sw	a5,0(a4)
  for(;;)
    80004068:	a001                	j	80004068 <sys_halt+0x20>

000000008000406a <sys_reboot>:
  return 0;
}

uint64
sys_reboot(void)
{
    8000406a:	1141                	addi	sp,sp,-16
    8000406c:	e406                	sd	ra,8(sp)
    8000406e:	e022                	sd	s0,0(sp)
    80004070:	0800                	addi	s0,sp,16
  printk("System rebooting...\n");
    80004072:	00005517          	auipc	a0,0x5
    80004076:	62e50513          	addi	a0,a0,1582 # 800096a0 <etext+0x6a0>
    8000407a:	c90fc0ef          	jal	8000050a <printk>
  *(volatile uint32 *)VIRT_TEST = 0x7777;
    8000407e:	679d                	lui	a5,0x7
    80004080:	77778793          	addi	a5,a5,1911 # 7777 <_entry-0x7fff8889>
    80004084:	00100737          	lui	a4,0x100
    80004088:	c31c                	sw	a5,0(a4)
  for(;;)
    8000408a:	a001                	j	8000408a <sys_reboot+0x20>

000000008000408c <sys_sched_yield>:
  return 0;
}

uint64
sys_sched_yield(void)
{
    8000408c:	1141                	addi	sp,sp,-16
    8000408e:	e406                	sd	ra,8(sp)
    80004090:	e022                	sd	s0,0(sp)
    80004092:	0800                	addi	s0,sp,16
  yield();
    80004094:	86ffe0ef          	jal	80002902 <yield>
  return 0;
}
    80004098:	4501                	li	a0,0
    8000409a:	60a2                	ld	ra,8(sp)
    8000409c:	6402                	ld	s0,0(sp)
    8000409e:	0141                	addi	sp,sp,16
    800040a0:	8082                	ret

00000000800040a2 <sys_getcpuid>:

uint64
sys_getcpuid(void)
{
    800040a2:	1101                	addi	sp,sp,-32
    800040a4:	ec06                	sd	ra,24(sp)
    800040a6:	e822                	sd	s0,16(sp)
    800040a8:	e426                	sd	s1,8(sp)
    800040aa:	1000                	addi	s0,sp,32
  int id;

  push_off();
    800040ac:	c8ffc0ef          	jal	80000d3a <push_off>
  id = cpuid();
    800040b0:	8eefe0ef          	jal	8000219e <cpuid>
    800040b4:	84aa                	mv	s1,a0
  pop_off();
    800040b6:	cfbfc0ef          	jal	80000db0 <pop_off>
  return id;
}
    800040ba:	8526                	mv	a0,s1
    800040bc:	60e2                	ld	ra,24(sp)
    800040be:	6442                	ld	s0,16(sp)
    800040c0:	64a2                	ld	s1,8(sp)
    800040c2:	6105                	addi	sp,sp,32
    800040c4:	8082                	ret

00000000800040c6 <sys_setprocname>:

uint64
sys_setprocname(void)
{
    800040c6:	7179                	addi	sp,sp,-48
    800040c8:	f406                	sd	ra,40(sp)
    800040ca:	f022                	sd	s0,32(sp)
    800040cc:	ec26                	sd	s1,24(sp)
    800040ce:	1800                	addi	s0,sp,48
  char buf[16];
  struct proc *p = myproc();
    800040d0:	8fafe0ef          	jal	800021ca <myproc>
    800040d4:	84aa                	mv	s1,a0

  if(argstr(0, buf, sizeof(buf)) < 0)
    800040d6:	4641                	li	a2,16
    800040d8:	fd040593          	addi	a1,s0,-48
    800040dc:	4501                	li	a0,0
    800040de:	83dff0ef          	jal	8000391a <argstr>
    800040e2:	02054963          	bltz	a0,80004114 <sys_setprocname+0x4e>
    return -1;

  if(buf[0] == '\0')
    800040e6:	fd044783          	lbu	a5,-48(s0)
    return -1;
    800040ea:	557d                	li	a0,-1
  if(buf[0] == '\0')
    800040ec:	cf99                	beqz	a5,8000410a <sys_setprocname+0x44>

  acquire(&p->lock);
    800040ee:	8526                	mv	a0,s1
    800040f0:	c81fc0ef          	jal	80000d70 <acquire>
  safestrcpy(p->name, buf, sizeof(p->name));
    800040f4:	4641                	li	a2,16
    800040f6:	fd040593          	addi	a1,s0,-48
    800040fa:	51848513          	addi	a0,s1,1304
    800040fe:	e75fc0ef          	jal	80000f72 <safestrcpy>
  release(&p->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	cf9fc0ef          	jal	80000dfc <release>

  return 0;
    80004108:	4501                	li	a0,0
}
    8000410a:	70a2                	ld	ra,40(sp)
    8000410c:	7402                	ld	s0,32(sp)
    8000410e:	64e2                	ld	s1,24(sp)
    80004110:	6145                	addi	sp,sp,48
    80004112:	8082                	ret
    return -1;
    80004114:	557d                	li	a0,-1
    80004116:	bfd5                	j	8000410a <sys_setprocname+0x44>

0000000080004118 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80004118:	7179                	addi	sp,sp,-48
    8000411a:	f406                	sd	ra,40(sp)
    8000411c:	f022                	sd	s0,32(sp)
    8000411e:	ec26                	sd	s1,24(sp)
    80004120:	e84a                	sd	s2,16(sp)
    80004122:	e44e                	sd	s3,8(sp)
    80004124:	e052                	sd	s4,0(sp)
    80004126:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004128:	00005597          	auipc	a1,0x5
    8000412c:	59058593          	addi	a1,a1,1424 # 800096b8 <etext+0x6b8>
    80004130:	00243517          	auipc	a0,0x243
    80004134:	bc050513          	addi	a0,a0,-1088 # 80246cf0 <bcache>
    80004138:	bc3fc0ef          	jal	80000cfa <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000413c:	0024b797          	auipc	a5,0x24b
    80004140:	bb478793          	addi	a5,a5,-1100 # 8024ecf0 <bcache+0x8000>
    80004144:	0024b717          	auipc	a4,0x24b
    80004148:	e1470713          	addi	a4,a4,-492 # 8024ef58 <bcache+0x8268>
    8000414c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80004150:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80004154:	00243497          	auipc	s1,0x243
    80004158:	bb448493          	addi	s1,s1,-1100 # 80246d08 <bcache+0x18>
    b->next = bcache.head.next;
    8000415c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000415e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80004160:	00005a17          	auipc	s4,0x5
    80004164:	560a0a13          	addi	s4,s4,1376 # 800096c0 <etext+0x6c0>
    b->next = bcache.head.next;
    80004168:	2b893783          	ld	a5,696(s2)
    8000416c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000416e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80004172:	85d2                	mv	a1,s4
    80004174:	01048513          	addi	a0,s1,16
    80004178:	412010ef          	jal	8000558a <initsleeplock>
    bcache.head.next->prev = b;
    8000417c:	2b893783          	ld	a5,696(s2)
    80004180:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80004182:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80004186:	45848493          	addi	s1,s1,1112
    8000418a:	fd349fe3          	bne	s1,s3,80004168 <binit+0x50>
  }
}
    8000418e:	70a2                	ld	ra,40(sp)
    80004190:	7402                	ld	s0,32(sp)
    80004192:	64e2                	ld	s1,24(sp)
    80004194:	6942                	ld	s2,16(sp)
    80004196:	69a2                	ld	s3,8(sp)
    80004198:	6a02                	ld	s4,0(sp)
    8000419a:	6145                	addi	sp,sp,48
    8000419c:	8082                	ret

000000008000419e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    8000419e:	7179                	addi	sp,sp,-48
    800041a0:	f406                	sd	ra,40(sp)
    800041a2:	f022                	sd	s0,32(sp)
    800041a4:	ec26                	sd	s1,24(sp)
    800041a6:	e84a                	sd	s2,16(sp)
    800041a8:	e44e                	sd	s3,8(sp)
    800041aa:	1800                	addi	s0,sp,48
    800041ac:	892a                	mv	s2,a0
    800041ae:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800041b0:	00243517          	auipc	a0,0x243
    800041b4:	b4050513          	addi	a0,a0,-1216 # 80246cf0 <bcache>
    800041b8:	bb9fc0ef          	jal	80000d70 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    800041bc:	0024b497          	auipc	s1,0x24b
    800041c0:	dec4b483          	ld	s1,-532(s1) # 8024efa8 <bcache+0x82b8>
    800041c4:	0024b797          	auipc	a5,0x24b
    800041c8:	d9478793          	addi	a5,a5,-620 # 8024ef58 <bcache+0x8268>
    800041cc:	02f48b63          	beq	s1,a5,80004202 <bread+0x64>
    800041d0:	873e                	mv	a4,a5
    800041d2:	a021                	j	800041da <bread+0x3c>
    800041d4:	68a4                	ld	s1,80(s1)
    800041d6:	02e48663          	beq	s1,a4,80004202 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    800041da:	449c                	lw	a5,8(s1)
    800041dc:	ff279ce3          	bne	a5,s2,800041d4 <bread+0x36>
    800041e0:	44dc                	lw	a5,12(s1)
    800041e2:	ff3799e3          	bne	a5,s3,800041d4 <bread+0x36>
      b->refcnt++;
    800041e6:	40bc                	lw	a5,64(s1)
    800041e8:	2785                	addiw	a5,a5,1
    800041ea:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800041ec:	00243517          	auipc	a0,0x243
    800041f0:	b0450513          	addi	a0,a0,-1276 # 80246cf0 <bcache>
    800041f4:	c09fc0ef          	jal	80000dfc <release>
      acquiresleep(&b->lock);
    800041f8:	01048513          	addi	a0,s1,16
    800041fc:	3c4010ef          	jal	800055c0 <acquiresleep>
      return b;
    80004200:	a889                	j	80004252 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80004202:	0024b497          	auipc	s1,0x24b
    80004206:	d9e4b483          	ld	s1,-610(s1) # 8024efa0 <bcache+0x82b0>
    8000420a:	0024b797          	auipc	a5,0x24b
    8000420e:	d4e78793          	addi	a5,a5,-690 # 8024ef58 <bcache+0x8268>
    80004212:	00f48863          	beq	s1,a5,80004222 <bread+0x84>
    80004216:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80004218:	40bc                	lw	a5,64(s1)
    8000421a:	cb91                	beqz	a5,8000422e <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000421c:	64a4                	ld	s1,72(s1)
    8000421e:	fee49de3          	bne	s1,a4,80004218 <bread+0x7a>
  panic("bget: no buffers");
    80004222:	00005517          	auipc	a0,0x5
    80004226:	4a650513          	addi	a0,a0,1190 # 800096c8 <etext+0x6c8>
    8000422a:	dc6fc0ef          	jal	800007f0 <panic>
      b->dev = dev;
    8000422e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80004232:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80004236:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000423a:	4785                	li	a5,1
    8000423c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000423e:	00243517          	auipc	a0,0x243
    80004242:	ab250513          	addi	a0,a0,-1358 # 80246cf0 <bcache>
    80004246:	bb7fc0ef          	jal	80000dfc <release>
      acquiresleep(&b->lock);
    8000424a:	01048513          	addi	a0,s1,16
    8000424e:	372010ef          	jal	800055c0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80004252:	409c                	lw	a5,0(s1)
    80004254:	cb89                	beqz	a5,80004266 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80004256:	8526                	mv	a0,s1
    80004258:	70a2                	ld	ra,40(sp)
    8000425a:	7402                	ld	s0,32(sp)
    8000425c:	64e2                	ld	s1,24(sp)
    8000425e:	6942                	ld	s2,16(sp)
    80004260:	69a2                	ld	s3,8(sp)
    80004262:	6145                	addi	sp,sp,48
    80004264:	8082                	ret
    virtio_disk_rw(b, 0);
    80004266:	4581                	li	a1,0
    80004268:	8526                	mv	a0,s1
    8000426a:	4a7020ef          	jal	80006f10 <virtio_disk_rw>
    b->valid = 1;
    8000426e:	4785                	li	a5,1
    80004270:	c09c                	sw	a5,0(s1)
  return b;
    80004272:	b7d5                	j	80004256 <bread+0xb8>

0000000080004274 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80004274:	1101                	addi	sp,sp,-32
    80004276:	ec06                	sd	ra,24(sp)
    80004278:	e822                	sd	s0,16(sp)
    8000427a:	e426                	sd	s1,8(sp)
    8000427c:	1000                	addi	s0,sp,32
    8000427e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80004280:	0541                	addi	a0,a0,16
    80004282:	3ca010ef          	jal	8000564c <holdingsleep>
    80004286:	c911                	beqz	a0,8000429a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80004288:	4585                	li	a1,1
    8000428a:	8526                	mv	a0,s1
    8000428c:	485020ef          	jal	80006f10 <virtio_disk_rw>
}
    80004290:	60e2                	ld	ra,24(sp)
    80004292:	6442                	ld	s0,16(sp)
    80004294:	64a2                	ld	s1,8(sp)
    80004296:	6105                	addi	sp,sp,32
    80004298:	8082                	ret
    panic("bwrite");
    8000429a:	00005517          	auipc	a0,0x5
    8000429e:	44650513          	addi	a0,a0,1094 # 800096e0 <etext+0x6e0>
    800042a2:	d4efc0ef          	jal	800007f0 <panic>

00000000800042a6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800042a6:	1101                	addi	sp,sp,-32
    800042a8:	ec06                	sd	ra,24(sp)
    800042aa:	e822                	sd	s0,16(sp)
    800042ac:	e426                	sd	s1,8(sp)
    800042ae:	e04a                	sd	s2,0(sp)
    800042b0:	1000                	addi	s0,sp,32
    800042b2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    800042b4:	01050913          	addi	s2,a0,16
    800042b8:	854a                	mv	a0,s2
    800042ba:	392010ef          	jal	8000564c <holdingsleep>
    800042be:	c135                	beqz	a0,80004322 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    800042c0:	854a                	mv	a0,s2
    800042c2:	352010ef          	jal	80005614 <releasesleep>

  acquire(&bcache.lock);
    800042c6:	00243517          	auipc	a0,0x243
    800042ca:	a2a50513          	addi	a0,a0,-1494 # 80246cf0 <bcache>
    800042ce:	aa3fc0ef          	jal	80000d70 <acquire>
  b->refcnt--;
    800042d2:	40bc                	lw	a5,64(s1)
    800042d4:	37fd                	addiw	a5,a5,-1
    800042d6:	0007871b          	sext.w	a4,a5
    800042da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800042dc:	e71d                	bnez	a4,8000430a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800042de:	68b8                	ld	a4,80(s1)
    800042e0:	64bc                	ld	a5,72(s1)
    800042e2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800042e4:	68b8                	ld	a4,80(s1)
    800042e6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800042e8:	0024b797          	auipc	a5,0x24b
    800042ec:	a0878793          	addi	a5,a5,-1528 # 8024ecf0 <bcache+0x8000>
    800042f0:	2b87b703          	ld	a4,696(a5)
    800042f4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800042f6:	0024b717          	auipc	a4,0x24b
    800042fa:	c6270713          	addi	a4,a4,-926 # 8024ef58 <bcache+0x8268>
    800042fe:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80004300:	2b87b703          	ld	a4,696(a5)
    80004304:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80004306:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    8000430a:	00243517          	auipc	a0,0x243
    8000430e:	9e650513          	addi	a0,a0,-1562 # 80246cf0 <bcache>
    80004312:	aebfc0ef          	jal	80000dfc <release>
}
    80004316:	60e2                	ld	ra,24(sp)
    80004318:	6442                	ld	s0,16(sp)
    8000431a:	64a2                	ld	s1,8(sp)
    8000431c:	6902                	ld	s2,0(sp)
    8000431e:	6105                	addi	sp,sp,32
    80004320:	8082                	ret
    panic("brelse");
    80004322:	00005517          	auipc	a0,0x5
    80004326:	3c650513          	addi	a0,a0,966 # 800096e8 <etext+0x6e8>
    8000432a:	cc6fc0ef          	jal	800007f0 <panic>

000000008000432e <bpin>:

void
bpin(struct buf *b)
{
    8000432e:	1101                	addi	sp,sp,-32
    80004330:	ec06                	sd	ra,24(sp)
    80004332:	e822                	sd	s0,16(sp)
    80004334:	e426                	sd	s1,8(sp)
    80004336:	1000                	addi	s0,sp,32
    80004338:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000433a:	00243517          	auipc	a0,0x243
    8000433e:	9b650513          	addi	a0,a0,-1610 # 80246cf0 <bcache>
    80004342:	a2ffc0ef          	jal	80000d70 <acquire>
  b->refcnt++;
    80004346:	40bc                	lw	a5,64(s1)
    80004348:	2785                	addiw	a5,a5,1
    8000434a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000434c:	00243517          	auipc	a0,0x243
    80004350:	9a450513          	addi	a0,a0,-1628 # 80246cf0 <bcache>
    80004354:	aa9fc0ef          	jal	80000dfc <release>
}
    80004358:	60e2                	ld	ra,24(sp)
    8000435a:	6442                	ld	s0,16(sp)
    8000435c:	64a2                	ld	s1,8(sp)
    8000435e:	6105                	addi	sp,sp,32
    80004360:	8082                	ret

0000000080004362 <bunpin>:

void
bunpin(struct buf *b)
{
    80004362:	1101                	addi	sp,sp,-32
    80004364:	ec06                	sd	ra,24(sp)
    80004366:	e822                	sd	s0,16(sp)
    80004368:	e426                	sd	s1,8(sp)
    8000436a:	1000                	addi	s0,sp,32
    8000436c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000436e:	00243517          	auipc	a0,0x243
    80004372:	98250513          	addi	a0,a0,-1662 # 80246cf0 <bcache>
    80004376:	9fbfc0ef          	jal	80000d70 <acquire>
  b->refcnt--;
    8000437a:	40bc                	lw	a5,64(s1)
    8000437c:	37fd                	addiw	a5,a5,-1
    8000437e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80004380:	00243517          	auipc	a0,0x243
    80004384:	97050513          	addi	a0,a0,-1680 # 80246cf0 <bcache>
    80004388:	a75fc0ef          	jal	80000dfc <release>
}
    8000438c:	60e2                	ld	ra,24(sp)
    8000438e:	6442                	ld	s0,16(sp)
    80004390:	64a2                	ld	s1,8(sp)
    80004392:	6105                	addi	sp,sp,32
    80004394:	8082                	ret

0000000080004396 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80004396:	1101                	addi	sp,sp,-32
    80004398:	ec06                	sd	ra,24(sp)
    8000439a:	e822                	sd	s0,16(sp)
    8000439c:	e426                	sd	s1,8(sp)
    8000439e:	e04a                	sd	s2,0(sp)
    800043a0:	1000                	addi	s0,sp,32
    800043a2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800043a4:	00d5d59b          	srliw	a1,a1,0xd
    800043a8:	0024b797          	auipc	a5,0x24b
    800043ac:	0247a783          	lw	a5,36(a5) # 8024f3cc <sb+0x1c>
    800043b0:	9dbd                	addw	a1,a1,a5
    800043b2:	dedff0ef          	jal	8000419e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800043b6:	0074f713          	andi	a4,s1,7
    800043ba:	4785                	li	a5,1
    800043bc:	00e797bb          	sllw	a5,a5,a4
  if ((bp->data[bi / 8] & m) == 0)
    800043c0:	14ce                	slli	s1,s1,0x33
    800043c2:	90d9                	srli	s1,s1,0x36
    800043c4:	00950733          	add	a4,a0,s1
    800043c8:	05874703          	lbu	a4,88(a4)
    800043cc:	00e7f6b3          	and	a3,a5,a4
    800043d0:	c29d                	beqz	a3,800043f6 <bfree+0x60>
    800043d2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800043d4:	94aa                	add	s1,s1,a0
    800043d6:	fff7c793          	not	a5,a5
    800043da:	8f7d                	and	a4,a4,a5
    800043dc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800043e0:	078010ef          	jal	80005458 <log_write>
  brelse(bp);
    800043e4:	854a                	mv	a0,s2
    800043e6:	ec1ff0ef          	jal	800042a6 <brelse>
}
    800043ea:	60e2                	ld	ra,24(sp)
    800043ec:	6442                	ld	s0,16(sp)
    800043ee:	64a2                	ld	s1,8(sp)
    800043f0:	6902                	ld	s2,0(sp)
    800043f2:	6105                	addi	sp,sp,32
    800043f4:	8082                	ret
    panic("freeing free block");
    800043f6:	00005517          	auipc	a0,0x5
    800043fa:	2fa50513          	addi	a0,a0,762 # 800096f0 <etext+0x6f0>
    800043fe:	bf2fc0ef          	jal	800007f0 <panic>

0000000080004402 <balloc>:
{
    80004402:	711d                	addi	sp,sp,-96
    80004404:	ec86                	sd	ra,88(sp)
    80004406:	e8a2                	sd	s0,80(sp)
    80004408:	e4a6                	sd	s1,72(sp)
    8000440a:	1080                	addi	s0,sp,96
  for (b = 0; b < sb.size; b += BPB) {
    8000440c:	0024b797          	auipc	a5,0x24b
    80004410:	fa87a783          	lw	a5,-88(a5) # 8024f3b4 <sb+0x4>
    80004414:	0e078f63          	beqz	a5,80004512 <balloc+0x110>
    80004418:	e0ca                	sd	s2,64(sp)
    8000441a:	fc4e                	sd	s3,56(sp)
    8000441c:	f852                	sd	s4,48(sp)
    8000441e:	f456                	sd	s5,40(sp)
    80004420:	f05a                	sd	s6,32(sp)
    80004422:	ec5e                	sd	s7,24(sp)
    80004424:	e862                	sd	s8,16(sp)
    80004426:	e466                	sd	s9,8(sp)
    80004428:	8baa                	mv	s7,a0
    8000442a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000442c:	0024bb17          	auipc	s6,0x24b
    80004430:	f84b0b13          	addi	s6,s6,-124 # 8024f3b0 <sb>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80004434:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80004436:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80004438:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    8000443a:	6c89                	lui	s9,0x2
    8000443c:	a0b5                	j	800044a8 <balloc+0xa6>
        bp->data[bi / 8] |= m;           // Mark block in use.
    8000443e:	97ca                	add	a5,a5,s2
    80004440:	8e55                	or	a2,a2,a3
    80004442:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80004446:	854a                	mv	a0,s2
    80004448:	010010ef          	jal	80005458 <log_write>
        brelse(bp);
    8000444c:	854a                	mv	a0,s2
    8000444e:	e59ff0ef          	jal	800042a6 <brelse>
  bp = bread(dev, bno);
    80004452:	85a6                	mv	a1,s1
    80004454:	855e                	mv	a0,s7
    80004456:	d49ff0ef          	jal	8000419e <bread>
    8000445a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000445c:	40000613          	li	a2,1024
    80004460:	4581                	li	a1,0
    80004462:	05850513          	addi	a0,a0,88
    80004466:	9cffc0ef          	jal	80000e34 <memset>
  log_write(bp);
    8000446a:	854a                	mv	a0,s2
    8000446c:	7ed000ef          	jal	80005458 <log_write>
  brelse(bp);
    80004470:	854a                	mv	a0,s2
    80004472:	e35ff0ef          	jal	800042a6 <brelse>
}
    80004476:	6906                	ld	s2,64(sp)
    80004478:	79e2                	ld	s3,56(sp)
    8000447a:	7a42                	ld	s4,48(sp)
    8000447c:	7aa2                	ld	s5,40(sp)
    8000447e:	7b02                	ld	s6,32(sp)
    80004480:	6be2                	ld	s7,24(sp)
    80004482:	6c42                	ld	s8,16(sp)
    80004484:	6ca2                	ld	s9,8(sp)
}
    80004486:	8526                	mv	a0,s1
    80004488:	60e6                	ld	ra,88(sp)
    8000448a:	6446                	ld	s0,80(sp)
    8000448c:	64a6                	ld	s1,72(sp)
    8000448e:	6125                	addi	sp,sp,96
    80004490:	8082                	ret
    brelse(bp);
    80004492:	854a                	mv	a0,s2
    80004494:	e13ff0ef          	jal	800042a6 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80004498:	015c87bb          	addw	a5,s9,s5
    8000449c:	00078a9b          	sext.w	s5,a5
    800044a0:	004b2703          	lw	a4,4(s6)
    800044a4:	04eaff63          	bgeu	s5,a4,80004502 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800044a8:	41fad79b          	sraiw	a5,s5,0x1f
    800044ac:	0137d79b          	srliw	a5,a5,0x13
    800044b0:	015787bb          	addw	a5,a5,s5
    800044b4:	40d7d79b          	sraiw	a5,a5,0xd
    800044b8:	01cb2583          	lw	a1,28(s6)
    800044bc:	9dbd                	addw	a1,a1,a5
    800044be:	855e                	mv	a0,s7
    800044c0:	cdfff0ef          	jal	8000419e <bread>
    800044c4:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800044c6:	004b2503          	lw	a0,4(s6)
    800044ca:	000a849b          	sext.w	s1,s5
    800044ce:	8762                	mv	a4,s8
    800044d0:	fca4f1e3          	bgeu	s1,a0,80004492 <balloc+0x90>
      m = 1 << (bi % 8);
    800044d4:	00777693          	andi	a3,a4,7
    800044d8:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    800044dc:	41f7579b          	sraiw	a5,a4,0x1f
    800044e0:	01d7d79b          	srliw	a5,a5,0x1d
    800044e4:	9fb9                	addw	a5,a5,a4
    800044e6:	4037d79b          	sraiw	a5,a5,0x3
    800044ea:	00f90633          	add	a2,s2,a5
    800044ee:	05864603          	lbu	a2,88(a2)
    800044f2:	00c6f5b3          	and	a1,a3,a2
    800044f6:	d5a1                	beqz	a1,8000443e <balloc+0x3c>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800044f8:	2705                	addiw	a4,a4,1
    800044fa:	2485                	addiw	s1,s1,1
    800044fc:	fd471ae3          	bne	a4,s4,800044d0 <balloc+0xce>
    80004500:	bf49                	j	80004492 <balloc+0x90>
    80004502:	6906                	ld	s2,64(sp)
    80004504:	79e2                	ld	s3,56(sp)
    80004506:	7a42                	ld	s4,48(sp)
    80004508:	7aa2                	ld	s5,40(sp)
    8000450a:	7b02                	ld	s6,32(sp)
    8000450c:	6be2                	ld	s7,24(sp)
    8000450e:	6c42                	ld	s8,16(sp)
    80004510:	6ca2                	ld	s9,8(sp)
  printk("balloc: out of blocks\n");
    80004512:	00005517          	auipc	a0,0x5
    80004516:	1f650513          	addi	a0,a0,502 # 80009708 <etext+0x708>
    8000451a:	ff1fb0ef          	jal	8000050a <printk>
  return 0;
    8000451e:	4481                	li	s1,0
    80004520:	b79d                	j	80004486 <balloc+0x84>

0000000080004522 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80004522:	7179                	addi	sp,sp,-48
    80004524:	f406                	sd	ra,40(sp)
    80004526:	f022                	sd	s0,32(sp)
    80004528:	ec26                	sd	s1,24(sp)
    8000452a:	e84a                	sd	s2,16(sp)
    8000452c:	e44e                	sd	s3,8(sp)
    8000452e:	1800                	addi	s0,sp,48
    80004530:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80004532:	47ad                	li	a5,11
    80004534:	02b7e663          	bltu	a5,a1,80004560 <bmap+0x3e>
    if ((addr = ip->addrs[bn]) == 0) {
    80004538:	02059793          	slli	a5,a1,0x20
    8000453c:	01e7d593          	srli	a1,a5,0x1e
    80004540:	00b504b3          	add	s1,a0,a1
    80004544:	0504a903          	lw	s2,80(s1)
    80004548:	06091a63          	bnez	s2,800045bc <bmap+0x9a>
      addr = balloc(ip->dev);
    8000454c:	4108                	lw	a0,0(a0)
    8000454e:	eb5ff0ef          	jal	80004402 <balloc>
    80004552:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    80004556:	06090363          	beqz	s2,800045bc <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000455a:	0524a823          	sw	s2,80(s1)
    8000455e:	a8b9                	j	800045bc <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80004560:	ff45849b          	addiw	s1,a1,-12
    80004564:	0004871b          	sext.w	a4,s1

  if (bn < NINDIRECT) {
    80004568:	0ff00793          	li	a5,255
    8000456c:	06e7ee63          	bltu	a5,a4,800045e8 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80004570:	08052903          	lw	s2,128(a0)
    80004574:	00091d63          	bnez	s2,8000458e <bmap+0x6c>
      addr = balloc(ip->dev);
    80004578:	4108                	lw	a0,0(a0)
    8000457a:	e89ff0ef          	jal	80004402 <balloc>
    8000457e:	0005091b          	sext.w	s2,a0
      if (addr == 0)
    80004582:	02090d63          	beqz	s2,800045bc <bmap+0x9a>
    80004586:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80004588:	0929a023          	sw	s2,128(s3)
    8000458c:	a011                	j	80004590 <bmap+0x6e>
    8000458e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80004590:	85ca                	mv	a1,s2
    80004592:	0009a503          	lw	a0,0(s3)
    80004596:	c09ff0ef          	jal	8000419e <bread>
    8000459a:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000459c:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800045a0:	02049713          	slli	a4,s1,0x20
    800045a4:	01e75593          	srli	a1,a4,0x1e
    800045a8:	00b784b3          	add	s1,a5,a1
    800045ac:	0004a903          	lw	s2,0(s1)
    800045b0:	00090e63          	beqz	s2,800045cc <bmap+0xaa>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800045b4:	8552                	mv	a0,s4
    800045b6:	cf1ff0ef          	jal	800042a6 <brelse>
    return addr;
    800045ba:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800045bc:	854a                	mv	a0,s2
    800045be:	70a2                	ld	ra,40(sp)
    800045c0:	7402                	ld	s0,32(sp)
    800045c2:	64e2                	ld	s1,24(sp)
    800045c4:	6942                	ld	s2,16(sp)
    800045c6:	69a2                	ld	s3,8(sp)
    800045c8:	6145                	addi	sp,sp,48
    800045ca:	8082                	ret
      addr = balloc(ip->dev);
    800045cc:	0009a503          	lw	a0,0(s3)
    800045d0:	e33ff0ef          	jal	80004402 <balloc>
    800045d4:	0005091b          	sext.w	s2,a0
      if (addr) {
    800045d8:	fc090ee3          	beqz	s2,800045b4 <bmap+0x92>
        a[bn] = addr;
    800045dc:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800045e0:	8552                	mv	a0,s4
    800045e2:	677000ef          	jal	80005458 <log_write>
    800045e6:	b7f9                	j	800045b4 <bmap+0x92>
    800045e8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800045ea:	00005517          	auipc	a0,0x5
    800045ee:	13650513          	addi	a0,a0,310 # 80009720 <etext+0x720>
    800045f2:	9fefc0ef          	jal	800007f0 <panic>

00000000800045f6 <iget>:
{
    800045f6:	7179                	addi	sp,sp,-48
    800045f8:	f406                	sd	ra,40(sp)
    800045fa:	f022                	sd	s0,32(sp)
    800045fc:	ec26                	sd	s1,24(sp)
    800045fe:	e84a                	sd	s2,16(sp)
    80004600:	e44e                	sd	s3,8(sp)
    80004602:	e052                	sd	s4,0(sp)
    80004604:	1800                	addi	s0,sp,48
    80004606:	89aa                	mv	s3,a0
    80004608:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000460a:	0024b517          	auipc	a0,0x24b
    8000460e:	dc650513          	addi	a0,a0,-570 # 8024f3d0 <itable>
    80004612:	f5efc0ef          	jal	80000d70 <acquire>
  empty = 0;
    80004616:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80004618:	0024b497          	auipc	s1,0x24b
    8000461c:	dd048493          	addi	s1,s1,-560 # 8024f3e8 <itable+0x18>
    80004620:	0024d697          	auipc	a3,0x24d
    80004624:	85868693          	addi	a3,a3,-1960 # 80250e78 <log>
    80004628:	a039                	j	80004636 <iget+0x40>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000462a:	02090963          	beqz	s2,8000465c <iget+0x66>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000462e:	08848493          	addi	s1,s1,136
    80004632:	02d48863          	beq	s1,a3,80004662 <iget+0x6c>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80004636:	449c                	lw	a5,8(s1)
    80004638:	fef059e3          	blez	a5,8000462a <iget+0x34>
    8000463c:	4098                	lw	a4,0(s1)
    8000463e:	ff3716e3          	bne	a4,s3,8000462a <iget+0x34>
    80004642:	40d8                	lw	a4,4(s1)
    80004644:	ff4713e3          	bne	a4,s4,8000462a <iget+0x34>
      ip->ref++;
    80004648:	2785                	addiw	a5,a5,1
    8000464a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000464c:	0024b517          	auipc	a0,0x24b
    80004650:	d8450513          	addi	a0,a0,-636 # 8024f3d0 <itable>
    80004654:	fa8fc0ef          	jal	80000dfc <release>
      return ip;
    80004658:	8926                	mv	s2,s1
    8000465a:	a02d                	j	80004684 <iget+0x8e>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000465c:	fbe9                	bnez	a5,8000462e <iget+0x38>
      empty = ip;
    8000465e:	8926                	mv	s2,s1
    80004660:	b7f9                	j	8000462e <iget+0x38>
  if (empty == 0)
    80004662:	02090a63          	beqz	s2,80004696 <iget+0xa0>
  ip->dev = dev;
    80004666:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000466a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000466e:	4785                	li	a5,1
    80004670:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004674:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004678:	0024b517          	auipc	a0,0x24b
    8000467c:	d5850513          	addi	a0,a0,-680 # 8024f3d0 <itable>
    80004680:	f7cfc0ef          	jal	80000dfc <release>
}
    80004684:	854a                	mv	a0,s2
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	64e2                	ld	s1,24(sp)
    8000468c:	6942                	ld	s2,16(sp)
    8000468e:	69a2                	ld	s3,8(sp)
    80004690:	6a02                	ld	s4,0(sp)
    80004692:	6145                	addi	sp,sp,48
    80004694:	8082                	ret
    panic("iget: no inodes");
    80004696:	00005517          	auipc	a0,0x5
    8000469a:	0a250513          	addi	a0,a0,162 # 80009738 <etext+0x738>
    8000469e:	952fc0ef          	jal	800007f0 <panic>

00000000800046a2 <iinit>:
{
    800046a2:	7179                	addi	sp,sp,-48
    800046a4:	f406                	sd	ra,40(sp)
    800046a6:	f022                	sd	s0,32(sp)
    800046a8:	ec26                	sd	s1,24(sp)
    800046aa:	e84a                	sd	s2,16(sp)
    800046ac:	e44e                	sd	s3,8(sp)
    800046ae:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800046b0:	00005597          	auipc	a1,0x5
    800046b4:	09858593          	addi	a1,a1,152 # 80009748 <etext+0x748>
    800046b8:	0024b517          	auipc	a0,0x24b
    800046bc:	d1850513          	addi	a0,a0,-744 # 8024f3d0 <itable>
    800046c0:	e3afc0ef          	jal	80000cfa <initlock>
  for (i = 0; i < NINODE; i++) {
    800046c4:	0024b497          	auipc	s1,0x24b
    800046c8:	d3448493          	addi	s1,s1,-716 # 8024f3f8 <itable+0x28>
    800046cc:	0024c997          	auipc	s3,0x24c
    800046d0:	7bc98993          	addi	s3,s3,1980 # 80250e88 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800046d4:	00005917          	auipc	s2,0x5
    800046d8:	07c90913          	addi	s2,s2,124 # 80009750 <etext+0x750>
    800046dc:	85ca                	mv	a1,s2
    800046de:	8526                	mv	a0,s1
    800046e0:	6ab000ef          	jal	8000558a <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800046e4:	08848493          	addi	s1,s1,136
    800046e8:	ff349ae3          	bne	s1,s3,800046dc <iinit+0x3a>
}
    800046ec:	70a2                	ld	ra,40(sp)
    800046ee:	7402                	ld	s0,32(sp)
    800046f0:	64e2                	ld	s1,24(sp)
    800046f2:	6942                	ld	s2,16(sp)
    800046f4:	69a2                	ld	s3,8(sp)
    800046f6:	6145                	addi	sp,sp,48
    800046f8:	8082                	ret

00000000800046fa <ialloc>:
{
    800046fa:	7139                	addi	sp,sp,-64
    800046fc:	fc06                	sd	ra,56(sp)
    800046fe:	f822                	sd	s0,48(sp)
    80004700:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80004702:	0024b717          	auipc	a4,0x24b
    80004706:	cba72703          	lw	a4,-838(a4) # 8024f3bc <sb+0xc>
    8000470a:	4785                	li	a5,1
    8000470c:	06e7f063          	bgeu	a5,a4,8000476c <ialloc+0x72>
    80004710:	f426                	sd	s1,40(sp)
    80004712:	f04a                	sd	s2,32(sp)
    80004714:	ec4e                	sd	s3,24(sp)
    80004716:	e852                	sd	s4,16(sp)
    80004718:	e456                	sd	s5,8(sp)
    8000471a:	e05a                	sd	s6,0(sp)
    8000471c:	8aaa                	mv	s5,a0
    8000471e:	8b2e                	mv	s6,a1
    80004720:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004722:	0024ba17          	auipc	s4,0x24b
    80004726:	c8ea0a13          	addi	s4,s4,-882 # 8024f3b0 <sb>
    8000472a:	00495593          	srli	a1,s2,0x4
    8000472e:	018a2783          	lw	a5,24(s4)
    80004732:	9dbd                	addw	a1,a1,a5
    80004734:	8556                	mv	a0,s5
    80004736:	a69ff0ef          	jal	8000419e <bread>
    8000473a:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000473c:	05850993          	addi	s3,a0,88
    80004740:	00f97793          	andi	a5,s2,15
    80004744:	079a                	slli	a5,a5,0x6
    80004746:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80004748:	00099783          	lh	a5,0(s3)
    8000474c:	cb9d                	beqz	a5,80004782 <ialloc+0x88>
    brelse(bp);
    8000474e:	b59ff0ef          	jal	800042a6 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80004752:	0905                	addi	s2,s2,1
    80004754:	00ca2703          	lw	a4,12(s4)
    80004758:	0009079b          	sext.w	a5,s2
    8000475c:	fce7e7e3          	bltu	a5,a4,8000472a <ialloc+0x30>
    80004760:	74a2                	ld	s1,40(sp)
    80004762:	7902                	ld	s2,32(sp)
    80004764:	69e2                	ld	s3,24(sp)
    80004766:	6a42                	ld	s4,16(sp)
    80004768:	6aa2                	ld	s5,8(sp)
    8000476a:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    8000476c:	00005517          	auipc	a0,0x5
    80004770:	fec50513          	addi	a0,a0,-20 # 80009758 <etext+0x758>
    80004774:	d97fb0ef          	jal	8000050a <printk>
  return 0;
    80004778:	4501                	li	a0,0
}
    8000477a:	70e2                	ld	ra,56(sp)
    8000477c:	7442                	ld	s0,48(sp)
    8000477e:	6121                	addi	sp,sp,64
    80004780:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004782:	04000613          	li	a2,64
    80004786:	4581                	li	a1,0
    80004788:	854e                	mv	a0,s3
    8000478a:	eaafc0ef          	jal	80000e34 <memset>
      dip->type = type;
    8000478e:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80004792:	8526                	mv	a0,s1
    80004794:	4c5000ef          	jal	80005458 <log_write>
      brelse(bp);
    80004798:	8526                	mv	a0,s1
    8000479a:	b0dff0ef          	jal	800042a6 <brelse>
      return iget(dev, inum);
    8000479e:	0009059b          	sext.w	a1,s2
    800047a2:	8556                	mv	a0,s5
    800047a4:	e53ff0ef          	jal	800045f6 <iget>
    800047a8:	74a2                	ld	s1,40(sp)
    800047aa:	7902                	ld	s2,32(sp)
    800047ac:	69e2                	ld	s3,24(sp)
    800047ae:	6a42                	ld	s4,16(sp)
    800047b0:	6aa2                	ld	s5,8(sp)
    800047b2:	6b02                	ld	s6,0(sp)
    800047b4:	b7d9                	j	8000477a <ialloc+0x80>

00000000800047b6 <iupdate>:
{
    800047b6:	1101                	addi	sp,sp,-32
    800047b8:	ec06                	sd	ra,24(sp)
    800047ba:	e822                	sd	s0,16(sp)
    800047bc:	e426                	sd	s1,8(sp)
    800047be:	e04a                	sd	s2,0(sp)
    800047c0:	1000                	addi	s0,sp,32
    800047c2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800047c4:	415c                	lw	a5,4(a0)
    800047c6:	0047d79b          	srliw	a5,a5,0x4
    800047ca:	0024b597          	auipc	a1,0x24b
    800047ce:	bfe5a583          	lw	a1,-1026(a1) # 8024f3c8 <sb+0x18>
    800047d2:	9dbd                	addw	a1,a1,a5
    800047d4:	4108                	lw	a0,0(a0)
    800047d6:	9c9ff0ef          	jal	8000419e <bread>
    800047da:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800047dc:	05850793          	addi	a5,a0,88
    800047e0:	40d8                	lw	a4,4(s1)
    800047e2:	8b3d                	andi	a4,a4,15
    800047e4:	071a                	slli	a4,a4,0x6
    800047e6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800047e8:	04449703          	lh	a4,68(s1)
    800047ec:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800047f0:	04649703          	lh	a4,70(s1)
    800047f4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800047f8:	04849703          	lh	a4,72(s1)
    800047fc:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004800:	04a49703          	lh	a4,74(s1)
    80004804:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004808:	44f8                	lw	a4,76(s1)
    8000480a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000480c:	03400613          	li	a2,52
    80004810:	05048593          	addi	a1,s1,80
    80004814:	00c78513          	addi	a0,a5,12
    80004818:	e78fc0ef          	jal	80000e90 <memmove>
  log_write(bp);
    8000481c:	854a                	mv	a0,s2
    8000481e:	43b000ef          	jal	80005458 <log_write>
  brelse(bp);
    80004822:	854a                	mv	a0,s2
    80004824:	a83ff0ef          	jal	800042a6 <brelse>
}
    80004828:	60e2                	ld	ra,24(sp)
    8000482a:	6442                	ld	s0,16(sp)
    8000482c:	64a2                	ld	s1,8(sp)
    8000482e:	6902                	ld	s2,0(sp)
    80004830:	6105                	addi	sp,sp,32
    80004832:	8082                	ret

0000000080004834 <idup>:
{
    80004834:	1101                	addi	sp,sp,-32
    80004836:	ec06                	sd	ra,24(sp)
    80004838:	e822                	sd	s0,16(sp)
    8000483a:	e426                	sd	s1,8(sp)
    8000483c:	1000                	addi	s0,sp,32
    8000483e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004840:	0024b517          	auipc	a0,0x24b
    80004844:	b9050513          	addi	a0,a0,-1136 # 8024f3d0 <itable>
    80004848:	d28fc0ef          	jal	80000d70 <acquire>
  ip->ref++;
    8000484c:	449c                	lw	a5,8(s1)
    8000484e:	2785                	addiw	a5,a5,1
    80004850:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004852:	0024b517          	auipc	a0,0x24b
    80004856:	b7e50513          	addi	a0,a0,-1154 # 8024f3d0 <itable>
    8000485a:	da2fc0ef          	jal	80000dfc <release>
}
    8000485e:	8526                	mv	a0,s1
    80004860:	60e2                	ld	ra,24(sp)
    80004862:	6442                	ld	s0,16(sp)
    80004864:	64a2                	ld	s1,8(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <ilock>:
{
    8000486a:	1101                	addi	sp,sp,-32
    8000486c:	ec06                	sd	ra,24(sp)
    8000486e:	e822                	sd	s0,16(sp)
    80004870:	e426                	sd	s1,8(sp)
    80004872:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80004874:	cd19                	beqz	a0,80004892 <ilock+0x28>
    80004876:	84aa                	mv	s1,a0
    80004878:	451c                	lw	a5,8(a0)
    8000487a:	00f05c63          	blez	a5,80004892 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000487e:	0541                	addi	a0,a0,16
    80004880:	541000ef          	jal	800055c0 <acquiresleep>
  if (ip->valid == 0) {
    80004884:	40bc                	lw	a5,64(s1)
    80004886:	cf89                	beqz	a5,800048a0 <ilock+0x36>
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	64a2                	ld	s1,8(sp)
    8000488e:	6105                	addi	sp,sp,32
    80004890:	8082                	ret
    80004892:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004894:	00005517          	auipc	a0,0x5
    80004898:	edc50513          	addi	a0,a0,-292 # 80009770 <etext+0x770>
    8000489c:	f55fb0ef          	jal	800007f0 <panic>
    800048a0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800048a2:	40dc                	lw	a5,4(s1)
    800048a4:	0047d79b          	srliw	a5,a5,0x4
    800048a8:	0024b597          	auipc	a1,0x24b
    800048ac:	b205a583          	lw	a1,-1248(a1) # 8024f3c8 <sb+0x18>
    800048b0:	9dbd                	addw	a1,a1,a5
    800048b2:	4088                	lw	a0,0(s1)
    800048b4:	8ebff0ef          	jal	8000419e <bread>
    800048b8:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800048ba:	05850593          	addi	a1,a0,88
    800048be:	40dc                	lw	a5,4(s1)
    800048c0:	8bbd                	andi	a5,a5,15
    800048c2:	079a                	slli	a5,a5,0x6
    800048c4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800048c6:	00059783          	lh	a5,0(a1)
    800048ca:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800048ce:	00259783          	lh	a5,2(a1)
    800048d2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800048d6:	00459783          	lh	a5,4(a1)
    800048da:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800048de:	00659783          	lh	a5,6(a1)
    800048e2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800048e6:	459c                	lw	a5,8(a1)
    800048e8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800048ea:	03400613          	li	a2,52
    800048ee:	05b1                	addi	a1,a1,12
    800048f0:	05048513          	addi	a0,s1,80
    800048f4:	d9cfc0ef          	jal	80000e90 <memmove>
    brelse(bp);
    800048f8:	854a                	mv	a0,s2
    800048fa:	9adff0ef          	jal	800042a6 <brelse>
    ip->valid = 1;
    800048fe:	4785                	li	a5,1
    80004900:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80004902:	04449783          	lh	a5,68(s1)
    80004906:	c399                	beqz	a5,8000490c <ilock+0xa2>
    80004908:	6902                	ld	s2,0(sp)
    8000490a:	bfbd                	j	80004888 <ilock+0x1e>
      panic("ilock: no type");
    8000490c:	00005517          	auipc	a0,0x5
    80004910:	e6c50513          	addi	a0,a0,-404 # 80009778 <etext+0x778>
    80004914:	eddfb0ef          	jal	800007f0 <panic>

0000000080004918 <iunlock>:
{
    80004918:	1101                	addi	sp,sp,-32
    8000491a:	ec06                	sd	ra,24(sp)
    8000491c:	e822                	sd	s0,16(sp)
    8000491e:	e426                	sd	s1,8(sp)
    80004920:	e04a                	sd	s2,0(sp)
    80004922:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004924:	c505                	beqz	a0,8000494c <iunlock+0x34>
    80004926:	84aa                	mv	s1,a0
    80004928:	01050913          	addi	s2,a0,16
    8000492c:	854a                	mv	a0,s2
    8000492e:	51f000ef          	jal	8000564c <holdingsleep>
    80004932:	cd09                	beqz	a0,8000494c <iunlock+0x34>
    80004934:	449c                	lw	a5,8(s1)
    80004936:	00f05b63          	blez	a5,8000494c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000493a:	854a                	mv	a0,s2
    8000493c:	4d9000ef          	jal	80005614 <releasesleep>
}
    80004940:	60e2                	ld	ra,24(sp)
    80004942:	6442                	ld	s0,16(sp)
    80004944:	64a2                	ld	s1,8(sp)
    80004946:	6902                	ld	s2,0(sp)
    80004948:	6105                	addi	sp,sp,32
    8000494a:	8082                	ret
    panic("iunlock");
    8000494c:	00005517          	auipc	a0,0x5
    80004950:	e3c50513          	addi	a0,a0,-452 # 80009788 <etext+0x788>
    80004954:	e9dfb0ef          	jal	800007f0 <panic>

0000000080004958 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004958:	7179                	addi	sp,sp,-48
    8000495a:	f406                	sd	ra,40(sp)
    8000495c:	f022                	sd	s0,32(sp)
    8000495e:	ec26                	sd	s1,24(sp)
    80004960:	e84a                	sd	s2,16(sp)
    80004962:	e44e                	sd	s3,8(sp)
    80004964:	1800                	addi	s0,sp,48
    80004966:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80004968:	05050493          	addi	s1,a0,80
    8000496c:	08050913          	addi	s2,a0,128
    80004970:	a021                	j	80004978 <itrunc+0x20>
    80004972:	0491                	addi	s1,s1,4
    80004974:	01248b63          	beq	s1,s2,8000498a <itrunc+0x32>
    if (ip->addrs[i]) {
    80004978:	408c                	lw	a1,0(s1)
    8000497a:	dde5                	beqz	a1,80004972 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000497c:	0009a503          	lw	a0,0(s3)
    80004980:	a17ff0ef          	jal	80004396 <bfree>
      ip->addrs[i] = 0;
    80004984:	0004a023          	sw	zero,0(s1)
    80004988:	b7ed                	j	80004972 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    8000498a:	0809a583          	lw	a1,128(s3)
    8000498e:	ed89                	bnez	a1,800049a8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004990:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004994:	854e                	mv	a0,s3
    80004996:	e21ff0ef          	jal	800047b6 <iupdate>
}
    8000499a:	70a2                	ld	ra,40(sp)
    8000499c:	7402                	ld	s0,32(sp)
    8000499e:	64e2                	ld	s1,24(sp)
    800049a0:	6942                	ld	s2,16(sp)
    800049a2:	69a2                	ld	s3,8(sp)
    800049a4:	6145                	addi	sp,sp,48
    800049a6:	8082                	ret
    800049a8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800049aa:	0009a503          	lw	a0,0(s3)
    800049ae:	ff0ff0ef          	jal	8000419e <bread>
    800049b2:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800049b4:	05850493          	addi	s1,a0,88
    800049b8:	45850913          	addi	s2,a0,1112
    800049bc:	a021                	j	800049c4 <itrunc+0x6c>
    800049be:	0491                	addi	s1,s1,4
    800049c0:	01248963          	beq	s1,s2,800049d2 <itrunc+0x7a>
      if (a[j])
    800049c4:	408c                	lw	a1,0(s1)
    800049c6:	dde5                	beqz	a1,800049be <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800049c8:	0009a503          	lw	a0,0(s3)
    800049cc:	9cbff0ef          	jal	80004396 <bfree>
    800049d0:	b7fd                	j	800049be <itrunc+0x66>
    brelse(bp);
    800049d2:	8552                	mv	a0,s4
    800049d4:	8d3ff0ef          	jal	800042a6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800049d8:	0809a583          	lw	a1,128(s3)
    800049dc:	0009a503          	lw	a0,0(s3)
    800049e0:	9b7ff0ef          	jal	80004396 <bfree>
    ip->addrs[NDIRECT] = 0;
    800049e4:	0809a023          	sw	zero,128(s3)
    800049e8:	6a02                	ld	s4,0(sp)
    800049ea:	b75d                	j	80004990 <itrunc+0x38>

00000000800049ec <iput>:
{
    800049ec:	7179                	addi	sp,sp,-48
    800049ee:	f406                	sd	ra,40(sp)
    800049f0:	f022                	sd	s0,32(sp)
    800049f2:	ec26                	sd	s1,24(sp)
    800049f4:	1800                	addi	s0,sp,48
    800049f6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800049f8:	0024b517          	auipc	a0,0x24b
    800049fc:	9d850513          	addi	a0,a0,-1576 # 8024f3d0 <itable>
    80004a00:	b70fc0ef          	jal	80000d70 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80004a04:	449c                	lw	a5,8(s1)
    80004a06:	4705                	li	a4,1
    80004a08:	00e78f63          	beq	a5,a4,80004a26 <iput+0x3a>
  ip->ref--;
    80004a0c:	37fd                	addiw	a5,a5,-1
    80004a0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004a10:	0024b517          	auipc	a0,0x24b
    80004a14:	9c050513          	addi	a0,a0,-1600 # 8024f3d0 <itable>
    80004a18:	be4fc0ef          	jal	80000dfc <release>
}
    80004a1c:	70a2                	ld	ra,40(sp)
    80004a1e:	7402                	ld	s0,32(sp)
    80004a20:	64e2                	ld	s1,24(sp)
    80004a22:	6145                	addi	sp,sp,48
    80004a24:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80004a26:	40b8                	lw	a4,64(s1)
    80004a28:	d375                	beqz	a4,80004a0c <iput+0x20>
    80004a2a:	e84a                	sd	s2,16(sp)
    80004a2c:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80004a2e:	0004aa03          	lw	s4,0(s1)
    80004a32:	0044a903          	lw	s2,4(s1)
  if (last) {
    80004a36:	04a49703          	lh	a4,74(s1)
    80004a3a:	ef35                	bnez	a4,80004ab6 <iput+0xca>
    80004a3c:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80004a3e:	01048993          	addi	s3,s1,16
    80004a42:	854e                	mv	a0,s3
    80004a44:	37d000ef          	jal	800055c0 <acquiresleep>
    release(&itable.lock);
    80004a48:	0024b517          	auipc	a0,0x24b
    80004a4c:	98850513          	addi	a0,a0,-1656 # 8024f3d0 <itable>
    80004a50:	bacfc0ef          	jal	80000dfc <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    80004a54:	8526                	mv	a0,s1
    80004a56:	f03ff0ef          	jal	80004958 <itrunc>
    ip->valid = 0;
    80004a5a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004a5e:	854e                	mv	a0,s3
    80004a60:	3b5000ef          	jal	80005614 <releasesleep>
    acquire(&itable.lock);
    80004a64:	0024b517          	auipc	a0,0x24b
    80004a68:	96c50513          	addi	a0,a0,-1684 # 8024f3d0 <itable>
    80004a6c:	b04fc0ef          	jal	80000d70 <acquire>
  ip->ref--;
    80004a70:	449c                	lw	a5,8(s1)
    80004a72:	37fd                	addiw	a5,a5,-1
    80004a74:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004a76:	0024b517          	auipc	a0,0x24b
    80004a7a:	95a50513          	addi	a0,a0,-1702 # 8024f3d0 <itable>
    80004a7e:	b7efc0ef          	jal	80000dfc <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80004a82:	0049559b          	srliw	a1,s2,0x4
    80004a86:	0024b797          	auipc	a5,0x24b
    80004a8a:	9427a783          	lw	a5,-1726(a5) # 8024f3c8 <sb+0x18>
    80004a8e:	9dbd                	addw	a1,a1,a5
    80004a90:	8552                	mv	a0,s4
    80004a92:	f0cff0ef          	jal	8000419e <bread>
    80004a96:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80004a98:	00f97913          	andi	s2,s2,15
  dip->type = 0;
    80004a9c:	091a                	slli	s2,s2,0x6
    80004a9e:	992a                	add	s2,s2,a0
    80004aa0:	04091c23          	sh	zero,88(s2)
  log_write(bp);
    80004aa4:	1b5000ef          	jal	80005458 <log_write>
  brelse(bp);
    80004aa8:	8526                	mv	a0,s1
    80004aaa:	ffcff0ef          	jal	800042a6 <brelse>
}
    80004aae:	6942                	ld	s2,16(sp)
    80004ab0:	69a2                	ld	s3,8(sp)
    80004ab2:	6a02                	ld	s4,0(sp)
    80004ab4:	b7a5                	j	80004a1c <iput+0x30>
    80004ab6:	6942                	ld	s2,16(sp)
    80004ab8:	6a02                	ld	s4,0(sp)
    80004aba:	bf89                	j	80004a0c <iput+0x20>

0000000080004abc <iunlockput>:
{
    80004abc:	1101                	addi	sp,sp,-32
    80004abe:	ec06                	sd	ra,24(sp)
    80004ac0:	e822                	sd	s0,16(sp)
    80004ac2:	e426                	sd	s1,8(sp)
    80004ac4:	1000                	addi	s0,sp,32
    80004ac6:	84aa                	mv	s1,a0
  iunlock(ip);
    80004ac8:	e51ff0ef          	jal	80004918 <iunlock>
  iput(ip);
    80004acc:	8526                	mv	a0,s1
    80004ace:	f1fff0ef          	jal	800049ec <iput>
}
    80004ad2:	60e2                	ld	ra,24(sp)
    80004ad4:	6442                	ld	s0,16(sp)
    80004ad6:	64a2                	ld	s1,8(sp)
    80004ad8:	6105                	addi	sp,sp,32
    80004ada:	8082                	ret

0000000080004adc <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80004adc:	0024b717          	auipc	a4,0x24b
    80004ae0:	8e072703          	lw	a4,-1824(a4) # 8024f3bc <sb+0xc>
    80004ae4:	4785                	li	a5,1
    80004ae6:	0ae7ff63          	bgeu	a5,a4,80004ba4 <ireclaim+0xc8>
{
    80004aea:	7139                	addi	sp,sp,-64
    80004aec:	fc06                	sd	ra,56(sp)
    80004aee:	f822                	sd	s0,48(sp)
    80004af0:	f426                	sd	s1,40(sp)
    80004af2:	f04a                	sd	s2,32(sp)
    80004af4:	ec4e                	sd	s3,24(sp)
    80004af6:	e852                	sd	s4,16(sp)
    80004af8:	e456                	sd	s5,8(sp)
    80004afa:	e05a                	sd	s6,0(sp)
    80004afc:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80004afe:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80004b00:	00050a1b          	sext.w	s4,a0
    80004b04:	0024ba97          	auipc	s5,0x24b
    80004b08:	8aca8a93          	addi	s5,s5,-1876 # 8024f3b0 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80004b0c:	00005b17          	auipc	s6,0x5
    80004b10:	c84b0b13          	addi	s6,s6,-892 # 80009790 <etext+0x790>
    80004b14:	a099                	j	80004b5a <ireclaim+0x7e>
    80004b16:	85ce                	mv	a1,s3
    80004b18:	855a                	mv	a0,s6
    80004b1a:	9f1fb0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    80004b1e:	85ce                	mv	a1,s3
    80004b20:	8552                	mv	a0,s4
    80004b22:	ad5ff0ef          	jal	800045f6 <iget>
    80004b26:	89aa                	mv	s3,a0
    brelse(bp);
    80004b28:	854a                	mv	a0,s2
    80004b2a:	f7cff0ef          	jal	800042a6 <brelse>
    if (ip) {
    80004b2e:	00098f63          	beqz	s3,80004b4c <ireclaim+0x70>
      begin_op();
    80004b32:	780000ef          	jal	800052b2 <begin_op>
      ilock(ip);
    80004b36:	854e                	mv	a0,s3
    80004b38:	d33ff0ef          	jal	8000486a <ilock>
      iunlock(ip);
    80004b3c:	854e                	mv	a0,s3
    80004b3e:	ddbff0ef          	jal	80004918 <iunlock>
      iput(ip);
    80004b42:	854e                	mv	a0,s3
    80004b44:	ea9ff0ef          	jal	800049ec <iput>
      end_op();
    80004b48:	7f0000ef          	jal	80005338 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80004b4c:	0485                	addi	s1,s1,1
    80004b4e:	00caa703          	lw	a4,12(s5)
    80004b52:	0004879b          	sext.w	a5,s1
    80004b56:	02e7fd63          	bgeu	a5,a4,80004b90 <ireclaim+0xb4>
    80004b5a:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80004b5e:	0044d593          	srli	a1,s1,0x4
    80004b62:	018aa783          	lw	a5,24(s5)
    80004b66:	9dbd                	addw	a1,a1,a5
    80004b68:	8552                	mv	a0,s4
    80004b6a:	e34ff0ef          	jal	8000419e <bread>
    80004b6e:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80004b70:	05850793          	addi	a5,a0,88
    80004b74:	00f9f713          	andi	a4,s3,15
    80004b78:	071a                	slli	a4,a4,0x6
    80004b7a:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80004b7c:	00079703          	lh	a4,0(a5)
    80004b80:	c701                	beqz	a4,80004b88 <ireclaim+0xac>
    80004b82:	00679783          	lh	a5,6(a5)
    80004b86:	dbc1                	beqz	a5,80004b16 <ireclaim+0x3a>
    brelse(bp);
    80004b88:	854a                	mv	a0,s2
    80004b8a:	f1cff0ef          	jal	800042a6 <brelse>
    if (ip) {
    80004b8e:	bf7d                	j	80004b4c <ireclaim+0x70>
}
    80004b90:	70e2                	ld	ra,56(sp)
    80004b92:	7442                	ld	s0,48(sp)
    80004b94:	74a2                	ld	s1,40(sp)
    80004b96:	7902                	ld	s2,32(sp)
    80004b98:	69e2                	ld	s3,24(sp)
    80004b9a:	6a42                	ld	s4,16(sp)
    80004b9c:	6aa2                	ld	s5,8(sp)
    80004b9e:	6b02                	ld	s6,0(sp)
    80004ba0:	6121                	addi	sp,sp,64
    80004ba2:	8082                	ret
    80004ba4:	8082                	ret

0000000080004ba6 <fsinit>:
{
    80004ba6:	7179                	addi	sp,sp,-48
    80004ba8:	f406                	sd	ra,40(sp)
    80004baa:	f022                	sd	s0,32(sp)
    80004bac:	ec26                	sd	s1,24(sp)
    80004bae:	e84a                	sd	s2,16(sp)
    80004bb0:	e44e                	sd	s3,8(sp)
    80004bb2:	1800                	addi	s0,sp,48
    80004bb4:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    80004bb6:	4585                	li	a1,1
    80004bb8:	de6ff0ef          	jal	8000419e <bread>
    80004bbc:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004bbe:	0024a997          	auipc	s3,0x24a
    80004bc2:	7f298993          	addi	s3,s3,2034 # 8024f3b0 <sb>
    80004bc6:	02000613          	li	a2,32
    80004bca:	05850593          	addi	a1,a0,88
    80004bce:	854e                	mv	a0,s3
    80004bd0:	ac0fc0ef          	jal	80000e90 <memmove>
  brelse(bp);
    80004bd4:	854a                	mv	a0,s2
    80004bd6:	ed0ff0ef          	jal	800042a6 <brelse>
  if (sb.magic != FSMAGIC)
    80004bda:	0009a703          	lw	a4,0(s3)
    80004bde:	102037b7          	lui	a5,0x10203
    80004be2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004be6:	02f71363          	bne	a4,a5,80004c0c <fsinit+0x66>
  initlog(dev, &sb);
    80004bea:	0024a597          	auipc	a1,0x24a
    80004bee:	7c658593          	addi	a1,a1,1990 # 8024f3b0 <sb>
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	640000ef          	jal	80005234 <initlog>
  ireclaim(dev);
    80004bf8:	8526                	mv	a0,s1
    80004bfa:	ee3ff0ef          	jal	80004adc <ireclaim>
}
    80004bfe:	70a2                	ld	ra,40(sp)
    80004c00:	7402                	ld	s0,32(sp)
    80004c02:	64e2                	ld	s1,24(sp)
    80004c04:	6942                	ld	s2,16(sp)
    80004c06:	69a2                	ld	s3,8(sp)
    80004c08:	6145                	addi	sp,sp,48
    80004c0a:	8082                	ret
    panic("invalid file system");
    80004c0c:	00005517          	auipc	a0,0x5
    80004c10:	ba450513          	addi	a0,a0,-1116 # 800097b0 <etext+0x7b0>
    80004c14:	bddfb0ef          	jal	800007f0 <panic>

0000000080004c18 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004c18:	1141                	addi	sp,sp,-16
    80004c1a:	e422                	sd	s0,8(sp)
    80004c1c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004c1e:	411c                	lw	a5,0(a0)
    80004c20:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004c22:	415c                	lw	a5,4(a0)
    80004c24:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004c26:	04451783          	lh	a5,68(a0)
    80004c2a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004c2e:	04a51783          	lh	a5,74(a0)
    80004c32:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004c36:	04c56783          	lwu	a5,76(a0)
    80004c3a:	e99c                	sd	a5,16(a1)
}
    80004c3c:	6422                	ld	s0,8(sp)
    80004c3e:	0141                	addi	sp,sp,16
    80004c40:	8082                	ret

0000000080004c42 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004c42:	457c                	lw	a5,76(a0)
    80004c44:	0ed7eb63          	bltu	a5,a3,80004d3a <readi+0xf8>
{
    80004c48:	7159                	addi	sp,sp,-112
    80004c4a:	f486                	sd	ra,104(sp)
    80004c4c:	f0a2                	sd	s0,96(sp)
    80004c4e:	eca6                	sd	s1,88(sp)
    80004c50:	e0d2                	sd	s4,64(sp)
    80004c52:	fc56                	sd	s5,56(sp)
    80004c54:	f85a                	sd	s6,48(sp)
    80004c56:	f45e                	sd	s7,40(sp)
    80004c58:	1880                	addi	s0,sp,112
    80004c5a:	8b2a                	mv	s6,a0
    80004c5c:	8bae                	mv	s7,a1
    80004c5e:	8a32                	mv	s4,a2
    80004c60:	84b6                	mv	s1,a3
    80004c62:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80004c64:	9f35                	addw	a4,a4,a3
    return 0;
    80004c66:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80004c68:	0cd76063          	bltu	a4,a3,80004d28 <readi+0xe6>
    80004c6c:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80004c6e:	00e7f463          	bgeu	a5,a4,80004c76 <readi+0x34>
    n = ip->size - off;
    80004c72:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004c76:	080a8f63          	beqz	s5,80004d14 <readi+0xd2>
    80004c7a:	e8ca                	sd	s2,80(sp)
    80004c7c:	f062                	sd	s8,32(sp)
    80004c7e:	ec66                	sd	s9,24(sp)
    80004c80:	e86a                	sd	s10,16(sp)
    80004c82:	e46e                	sd	s11,8(sp)
    80004c84:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80004c86:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004c8a:	5c7d                	li	s8,-1
    80004c8c:	a80d                	j	80004cbe <readi+0x7c>
    80004c8e:	020d1d93          	slli	s11,s10,0x20
    80004c92:	020ddd93          	srli	s11,s11,0x20
    80004c96:	05890613          	addi	a2,s2,88
    80004c9a:	86ee                	mv	a3,s11
    80004c9c:	963a                	add	a2,a2,a4
    80004c9e:	85d2                	mv	a1,s4
    80004ca0:	855e                	mv	a0,s7
    80004ca2:	9f0fe0ef          	jal	80002e92 <either_copyout>
    80004ca6:	05850763          	beq	a0,s8,80004cf4 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004caa:	854a                	mv	a0,s2
    80004cac:	dfaff0ef          	jal	800042a6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004cb0:	013d09bb          	addw	s3,s10,s3
    80004cb4:	009d04bb          	addw	s1,s10,s1
    80004cb8:	9a6e                	add	s4,s4,s11
    80004cba:	0559f763          	bgeu	s3,s5,80004d08 <readi+0xc6>
    uint addr = bmap(ip, off / BSIZE);
    80004cbe:	00a4d59b          	srliw	a1,s1,0xa
    80004cc2:	855a                	mv	a0,s6
    80004cc4:	85fff0ef          	jal	80004522 <bmap>
    80004cc8:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80004ccc:	c5b1                	beqz	a1,80004d18 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80004cce:	000b2503          	lw	a0,0(s6)
    80004cd2:	cccff0ef          	jal	8000419e <bread>
    80004cd6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80004cd8:	3ff4f713          	andi	a4,s1,1023
    80004cdc:	40ec87bb          	subw	a5,s9,a4
    80004ce0:	413a86bb          	subw	a3,s5,s3
    80004ce4:	8d3e                	mv	s10,a5
    80004ce6:	2781                	sext.w	a5,a5
    80004ce8:	0006861b          	sext.w	a2,a3
    80004cec:	faf671e3          	bgeu	a2,a5,80004c8e <readi+0x4c>
    80004cf0:	8d36                	mv	s10,a3
    80004cf2:	bf71                	j	80004c8e <readi+0x4c>
      brelse(bp);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	db0ff0ef          	jal	800042a6 <brelse>
      tot = -1;
    80004cfa:	59fd                	li	s3,-1
      break;
    80004cfc:	6946                	ld	s2,80(sp)
    80004cfe:	7c02                	ld	s8,32(sp)
    80004d00:	6ce2                	ld	s9,24(sp)
    80004d02:	6d42                	ld	s10,16(sp)
    80004d04:	6da2                	ld	s11,8(sp)
    80004d06:	a831                	j	80004d22 <readi+0xe0>
    80004d08:	6946                	ld	s2,80(sp)
    80004d0a:	7c02                	ld	s8,32(sp)
    80004d0c:	6ce2                	ld	s9,24(sp)
    80004d0e:	6d42                	ld	s10,16(sp)
    80004d10:	6da2                	ld	s11,8(sp)
    80004d12:	a801                	j	80004d22 <readi+0xe0>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004d14:	89d6                	mv	s3,s5
    80004d16:	a031                	j	80004d22 <readi+0xe0>
    80004d18:	6946                	ld	s2,80(sp)
    80004d1a:	7c02                	ld	s8,32(sp)
    80004d1c:	6ce2                	ld	s9,24(sp)
    80004d1e:	6d42                	ld	s10,16(sp)
    80004d20:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004d22:	0009851b          	sext.w	a0,s3
    80004d26:	69a6                	ld	s3,72(sp)
}
    80004d28:	70a6                	ld	ra,104(sp)
    80004d2a:	7406                	ld	s0,96(sp)
    80004d2c:	64e6                	ld	s1,88(sp)
    80004d2e:	6a06                	ld	s4,64(sp)
    80004d30:	7ae2                	ld	s5,56(sp)
    80004d32:	7b42                	ld	s6,48(sp)
    80004d34:	7ba2                	ld	s7,40(sp)
    80004d36:	6165                	addi	sp,sp,112
    80004d38:	8082                	ret
    return 0;
    80004d3a:	4501                	li	a0,0
}
    80004d3c:	8082                	ret

0000000080004d3e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004d3e:	457c                	lw	a5,76(a0)
    80004d40:	10d7e363          	bltu	a5,a3,80004e46 <writei+0x108>
{
    80004d44:	7159                	addi	sp,sp,-112
    80004d46:	f486                	sd	ra,104(sp)
    80004d48:	f0a2                	sd	s0,96(sp)
    80004d4a:	e8ca                	sd	s2,80(sp)
    80004d4c:	e0d2                	sd	s4,64(sp)
    80004d4e:	fc56                	sd	s5,56(sp)
    80004d50:	f85a                	sd	s6,48(sp)
    80004d52:	f45e                	sd	s7,40(sp)
    80004d54:	1880                	addi	s0,sp,112
    80004d56:	8aaa                	mv	s5,a0
    80004d58:	8bae                	mv	s7,a1
    80004d5a:	8a32                	mv	s4,a2
    80004d5c:	8936                	mv	s2,a3
    80004d5e:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80004d60:	00e687bb          	addw	a5,a3,a4
    80004d64:	0ed7e363          	bltu	a5,a3,80004e4a <writei+0x10c>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80004d68:	00043737          	lui	a4,0x43
    80004d6c:	0ef76163          	bltu	a4,a5,80004e4e <writei+0x110>
    80004d70:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004d72:	0c0b0263          	beqz	s6,80004e36 <writei+0xf8>
    80004d76:	eca6                	sd	s1,88(sp)
    80004d78:	f062                	sd	s8,32(sp)
    80004d7a:	ec66                	sd	s9,24(sp)
    80004d7c:	e86a                	sd	s10,16(sp)
    80004d7e:	e46e                	sd	s11,8(sp)
    80004d80:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80004d82:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004d86:	5c7d                	li	s8,-1
    80004d88:	a825                	j	80004dc0 <writei+0x82>
    80004d8a:	020d1d93          	slli	s11,s10,0x20
    80004d8e:	020ddd93          	srli	s11,s11,0x20
    80004d92:	05848513          	addi	a0,s1,88
    80004d96:	86ee                	mv	a3,s11
    80004d98:	8652                	mv	a2,s4
    80004d9a:	85de                	mv	a1,s7
    80004d9c:	953a                	add	a0,a0,a4
    80004d9e:	940fe0ef          	jal	80002ede <either_copyin>
    80004da2:	05850a63          	beq	a0,s8,80004df6 <writei+0xb8>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80004da6:	8526                	mv	a0,s1
    80004da8:	6b0000ef          	jal	80005458 <log_write>
    brelse(bp);
    80004dac:	8526                	mv	a0,s1
    80004dae:	cf8ff0ef          	jal	800042a6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004db2:	013d09bb          	addw	s3,s10,s3
    80004db6:	012d093b          	addw	s2,s10,s2
    80004dba:	9a6e                	add	s4,s4,s11
    80004dbc:	0569f363          	bgeu	s3,s6,80004e02 <writei+0xc4>
    uint addr = bmap(ip, off / BSIZE);
    80004dc0:	00a9559b          	srliw	a1,s2,0xa
    80004dc4:	8556                	mv	a0,s5
    80004dc6:	f5cff0ef          	jal	80004522 <bmap>
    80004dca:	0005059b          	sext.w	a1,a0
    if (addr == 0)
    80004dce:	c995                	beqz	a1,80004e02 <writei+0xc4>
    bp = bread(ip->dev, addr);
    80004dd0:	000aa503          	lw	a0,0(s5)
    80004dd4:	bcaff0ef          	jal	8000419e <bread>
    80004dd8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80004dda:	3ff97713          	andi	a4,s2,1023
    80004dde:	40ec87bb          	subw	a5,s9,a4
    80004de2:	413b06bb          	subw	a3,s6,s3
    80004de6:	8d3e                	mv	s10,a5
    80004de8:	2781                	sext.w	a5,a5
    80004dea:	0006861b          	sext.w	a2,a3
    80004dee:	f8f67ee3          	bgeu	a2,a5,80004d8a <writei+0x4c>
    80004df2:	8d36                	mv	s10,a3
    80004df4:	bf59                	j	80004d8a <writei+0x4c>
      log_write(bp);
    80004df6:	8526                	mv	a0,s1
    80004df8:	660000ef          	jal	80005458 <log_write>
      brelse(bp);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	ca8ff0ef          	jal	800042a6 <brelse>
  }

  if (off > ip->size)
    80004e02:	04caa783          	lw	a5,76(s5)
    80004e06:	0327fa63          	bgeu	a5,s2,80004e3a <writei+0xfc>
    ip->size = off;
    80004e0a:	052aa623          	sw	s2,76(s5)
    80004e0e:	64e6                	ld	s1,88(sp)
    80004e10:	7c02                	ld	s8,32(sp)
    80004e12:	6ce2                	ld	s9,24(sp)
    80004e14:	6d42                	ld	s10,16(sp)
    80004e16:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004e18:	8556                	mv	a0,s5
    80004e1a:	99dff0ef          	jal	800047b6 <iupdate>

  return tot;
    80004e1e:	0009851b          	sext.w	a0,s3
    80004e22:	69a6                	ld	s3,72(sp)
}
    80004e24:	70a6                	ld	ra,104(sp)
    80004e26:	7406                	ld	s0,96(sp)
    80004e28:	6946                	ld	s2,80(sp)
    80004e2a:	6a06                	ld	s4,64(sp)
    80004e2c:	7ae2                	ld	s5,56(sp)
    80004e2e:	7b42                	ld	s6,48(sp)
    80004e30:	7ba2                	ld	s7,40(sp)
    80004e32:	6165                	addi	sp,sp,112
    80004e34:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004e36:	89da                	mv	s3,s6
    80004e38:	b7c5                	j	80004e18 <writei+0xda>
    80004e3a:	64e6                	ld	s1,88(sp)
    80004e3c:	7c02                	ld	s8,32(sp)
    80004e3e:	6ce2                	ld	s9,24(sp)
    80004e40:	6d42                	ld	s10,16(sp)
    80004e42:	6da2                	ld	s11,8(sp)
    80004e44:	bfd1                	j	80004e18 <writei+0xda>
    return -1;
    80004e46:	557d                	li	a0,-1
}
    80004e48:	8082                	ret
    return -1;
    80004e4a:	557d                	li	a0,-1
    80004e4c:	bfe1                	j	80004e24 <writei+0xe6>
    return -1;
    80004e4e:	557d                	li	a0,-1
    80004e50:	bfd1                	j	80004e24 <writei+0xe6>

0000000080004e52 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004e52:	1141                	addi	sp,sp,-16
    80004e54:	e406                	sd	ra,8(sp)
    80004e56:	e022                	sd	s0,0(sp)
    80004e58:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004e5a:	4639                	li	a2,14
    80004e5c:	8a4fc0ef          	jal	80000f00 <strncmp>
}
    80004e60:	60a2                	ld	ra,8(sp)
    80004e62:	6402                	ld	s0,0(sp)
    80004e64:	0141                	addi	sp,sp,16
    80004e66:	8082                	ret

0000000080004e68 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004e68:	7139                	addi	sp,sp,-64
    80004e6a:	fc06                	sd	ra,56(sp)
    80004e6c:	f822                	sd	s0,48(sp)
    80004e6e:	f426                	sd	s1,40(sp)
    80004e70:	f04a                	sd	s2,32(sp)
    80004e72:	ec4e                	sd	s3,24(sp)
    80004e74:	e852                	sd	s4,16(sp)
    80004e76:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80004e78:	04451703          	lh	a4,68(a0)
    80004e7c:	4785                	li	a5,1
    80004e7e:	00f71a63          	bne	a4,a5,80004e92 <dirlookup+0x2a>
    80004e82:	892a                	mv	s2,a0
    80004e84:	89ae                	mv	s3,a1
    80004e86:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004e88:	457c                	lw	a5,76(a0)
    80004e8a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004e8c:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004e8e:	e39d                	bnez	a5,80004eb4 <dirlookup+0x4c>
    80004e90:	a095                	j	80004ef4 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80004e92:	00005517          	auipc	a0,0x5
    80004e96:	93650513          	addi	a0,a0,-1738 # 800097c8 <etext+0x7c8>
    80004e9a:	957fb0ef          	jal	800007f0 <panic>
      panic("dirlookup read");
    80004e9e:	00005517          	auipc	a0,0x5
    80004ea2:	94250513          	addi	a0,a0,-1726 # 800097e0 <etext+0x7e0>
    80004ea6:	94bfb0ef          	jal	800007f0 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004eaa:	24c1                	addiw	s1,s1,16
    80004eac:	04c92783          	lw	a5,76(s2)
    80004eb0:	04f4f163          	bgeu	s1,a5,80004ef2 <dirlookup+0x8a>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004eb4:	4741                	li	a4,16
    80004eb6:	86a6                	mv	a3,s1
    80004eb8:	fc040613          	addi	a2,s0,-64
    80004ebc:	4581                	li	a1,0
    80004ebe:	854a                	mv	a0,s2
    80004ec0:	d83ff0ef          	jal	80004c42 <readi>
    80004ec4:	47c1                	li	a5,16
    80004ec6:	fcf51ce3          	bne	a0,a5,80004e9e <dirlookup+0x36>
    if (de.inum == 0)
    80004eca:	fc045783          	lhu	a5,-64(s0)
    80004ece:	dff1                	beqz	a5,80004eaa <dirlookup+0x42>
    if (namecmp(name, de.name) == 0) {
    80004ed0:	fc240593          	addi	a1,s0,-62
    80004ed4:	854e                	mv	a0,s3
    80004ed6:	f7dff0ef          	jal	80004e52 <namecmp>
    80004eda:	f961                	bnez	a0,80004eaa <dirlookup+0x42>
      if (poff)
    80004edc:	000a0463          	beqz	s4,80004ee4 <dirlookup+0x7c>
        *poff = off;
    80004ee0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004ee4:	fc045583          	lhu	a1,-64(s0)
    80004ee8:	00092503          	lw	a0,0(s2)
    80004eec:	f0aff0ef          	jal	800045f6 <iget>
    80004ef0:	a011                	j	80004ef4 <dirlookup+0x8c>
  return 0;
    80004ef2:	4501                	li	a0,0
}
    80004ef4:	70e2                	ld	ra,56(sp)
    80004ef6:	7442                	ld	s0,48(sp)
    80004ef8:	74a2                	ld	s1,40(sp)
    80004efa:	7902                	ld	s2,32(sp)
    80004efc:	69e2                	ld	s3,24(sp)
    80004efe:	6a42                	ld	s4,16(sp)
    80004f00:	6121                	addi	sp,sp,64
    80004f02:	8082                	ret

0000000080004f04 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80004f04:	711d                	addi	sp,sp,-96
    80004f06:	ec86                	sd	ra,88(sp)
    80004f08:	e8a2                	sd	s0,80(sp)
    80004f0a:	e4a6                	sd	s1,72(sp)
    80004f0c:	e0ca                	sd	s2,64(sp)
    80004f0e:	fc4e                	sd	s3,56(sp)
    80004f10:	f852                	sd	s4,48(sp)
    80004f12:	f456                	sd	s5,40(sp)
    80004f14:	f05a                	sd	s6,32(sp)
    80004f16:	ec5e                	sd	s7,24(sp)
    80004f18:	e862                	sd	s8,16(sp)
    80004f1a:	e466                	sd	s9,8(sp)
    80004f1c:	1080                	addi	s0,sp,96
    80004f1e:	84aa                	mv	s1,a0
    80004f20:	8b2e                	mv	s6,a1
    80004f22:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80004f24:	00054703          	lbu	a4,0(a0)
    80004f28:	02f00793          	li	a5,47
    80004f2c:	00f70e63          	beq	a4,a5,80004f48 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004f30:	a9afd0ef          	jal	800021ca <myproc>
    80004f34:	19053503          	ld	a0,400(a0)
    80004f38:	8fdff0ef          	jal	80004834 <idup>
    80004f3c:	8a2a                	mv	s4,a0
  while (*path == '/')
    80004f3e:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    80004f42:	4c35                	li	s8,13

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80004f44:	4b85                	li	s7,1
    80004f46:	a075                	j	80004ff2 <namex+0xee>
    ip = iget(ROOTDEV, ROOTINO);
    80004f48:	4585                	li	a1,1
    80004f4a:	4505                	li	a0,1
    80004f4c:	eaaff0ef          	jal	800045f6 <iget>
    80004f50:	8a2a                	mv	s4,a0
    80004f52:	b7f5                	j	80004f3e <namex+0x3a>
      iunlockput(ip);
    80004f54:	8552                	mv	a0,s4
    80004f56:	b67ff0ef          	jal	80004abc <iunlockput>
      return 0;
    80004f5a:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80004f5c:	8552                	mv	a0,s4
    80004f5e:	60e6                	ld	ra,88(sp)
    80004f60:	6446                	ld	s0,80(sp)
    80004f62:	64a6                	ld	s1,72(sp)
    80004f64:	6906                	ld	s2,64(sp)
    80004f66:	79e2                	ld	s3,56(sp)
    80004f68:	7a42                	ld	s4,48(sp)
    80004f6a:	7aa2                	ld	s5,40(sp)
    80004f6c:	7b02                	ld	s6,32(sp)
    80004f6e:	6be2                	ld	s7,24(sp)
    80004f70:	6c42                	ld	s8,16(sp)
    80004f72:	6ca2                	ld	s9,8(sp)
    80004f74:	6125                	addi	sp,sp,96
    80004f76:	8082                	ret
      iunlockput(ip);
    80004f78:	8552                	mv	a0,s4
    80004f7a:	b43ff0ef          	jal	80004abc <iunlockput>
      return 0;
    80004f7e:	4a01                	li	s4,0
    80004f80:	bff1                	j	80004f5c <namex+0x58>
      iunlock(ip);
    80004f82:	8552                	mv	a0,s4
    80004f84:	995ff0ef          	jal	80004918 <iunlock>
      return ip;
    80004f88:	bfd1                	j	80004f5c <namex+0x58>
      iunlockput(ip);
    80004f8a:	8552                	mv	a0,s4
    80004f8c:	b31ff0ef          	jal	80004abc <iunlockput>
      return 0;
    80004f90:	8a4e                	mv	s4,s3
    80004f92:	b7e9                	j	80004f5c <namex+0x58>
  len = path - s;
    80004f94:	40998633          	sub	a2,s3,s1
    80004f98:	00060c9b          	sext.w	s9,a2
  if (len >= DIRSIZ)
    80004f9c:	099c5363          	bge	s8,s9,80005022 <namex+0x11e>
    memmove(name, s, DIRSIZ);
    80004fa0:	4639                	li	a2,14
    80004fa2:	85a6                	mv	a1,s1
    80004fa4:	8556                	mv	a0,s5
    80004fa6:	eebfb0ef          	jal	80000e90 <memmove>
    80004faa:	84ce                	mv	s1,s3
  while (*path == '/')
    80004fac:	0004c783          	lbu	a5,0(s1)
    80004fb0:	01279763          	bne	a5,s2,80004fbe <namex+0xba>
    path++;
    80004fb4:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004fb6:	0004c783          	lbu	a5,0(s1)
    80004fba:	ff278de3          	beq	a5,s2,80004fb4 <namex+0xb0>
    ilock(ip);
    80004fbe:	8552                	mv	a0,s4
    80004fc0:	8abff0ef          	jal	8000486a <ilock>
    if (ip->type != T_DIR) {
    80004fc4:	044a1783          	lh	a5,68(s4)
    80004fc8:	f97796e3          	bne	a5,s7,80004f54 <namex+0x50>
    if (ip->nlink == 0) {
    80004fcc:	04aa1783          	lh	a5,74(s4)
    80004fd0:	d7c5                	beqz	a5,80004f78 <namex+0x74>
    if (nameiparent && *path == '\0') {
    80004fd2:	000b0563          	beqz	s6,80004fdc <namex+0xd8>
    80004fd6:	0004c783          	lbu	a5,0(s1)
    80004fda:	d7c5                	beqz	a5,80004f82 <namex+0x7e>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80004fdc:	4601                	li	a2,0
    80004fde:	85d6                	mv	a1,s5
    80004fe0:	8552                	mv	a0,s4
    80004fe2:	e87ff0ef          	jal	80004e68 <dirlookup>
    80004fe6:	89aa                	mv	s3,a0
    80004fe8:	d14d                	beqz	a0,80004f8a <namex+0x86>
    iunlockput(ip);
    80004fea:	8552                	mv	a0,s4
    80004fec:	ad1ff0ef          	jal	80004abc <iunlockput>
    ip = next;
    80004ff0:	8a4e                	mv	s4,s3
  while (*path == '/')
    80004ff2:	0004c783          	lbu	a5,0(s1)
    80004ff6:	01279763          	bne	a5,s2,80005004 <namex+0x100>
    path++;
    80004ffa:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004ffc:	0004c783          	lbu	a5,0(s1)
    80005000:	ff278de3          	beq	a5,s2,80004ffa <namex+0xf6>
  if (*path == 0)
    80005004:	cb8d                	beqz	a5,80005036 <namex+0x132>
  while (*path != '/' && *path != 0)
    80005006:	0004c783          	lbu	a5,0(s1)
    8000500a:	89a6                	mv	s3,s1
  len = path - s;
    8000500c:	4c81                	li	s9,0
    8000500e:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    80005010:	01278963          	beq	a5,s2,80005022 <namex+0x11e>
    80005014:	d3c1                	beqz	a5,80004f94 <namex+0x90>
    path++;
    80005016:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    80005018:	0009c783          	lbu	a5,0(s3)
    8000501c:	ff279ce3          	bne	a5,s2,80005014 <namex+0x110>
    80005020:	bf95                	j	80004f94 <namex+0x90>
    memmove(name, s, len);
    80005022:	2601                	sext.w	a2,a2
    80005024:	85a6                	mv	a1,s1
    80005026:	8556                	mv	a0,s5
    80005028:	e69fb0ef          	jal	80000e90 <memmove>
    name[len] = 0;
    8000502c:	9cd6                	add	s9,s9,s5
    8000502e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80005032:	84ce                	mv	s1,s3
    80005034:	bfa5                	j	80004fac <namex+0xa8>
  if (nameiparent) {
    80005036:	f20b03e3          	beqz	s6,80004f5c <namex+0x58>
    iput(ip);
    8000503a:	8552                	mv	a0,s4
    8000503c:	9b1ff0ef          	jal	800049ec <iput>
    return 0;
    80005040:	4a01                	li	s4,0
    80005042:	bf29                	j	80004f5c <namex+0x58>

0000000080005044 <dirlink>:
{
    80005044:	7139                	addi	sp,sp,-64
    80005046:	fc06                	sd	ra,56(sp)
    80005048:	f822                	sd	s0,48(sp)
    8000504a:	f04a                	sd	s2,32(sp)
    8000504c:	ec4e                	sd	s3,24(sp)
    8000504e:	e852                	sd	s4,16(sp)
    80005050:	0080                	addi	s0,sp,64
    80005052:	892a                	mv	s2,a0
    80005054:	8a2e                	mv	s4,a1
    80005056:	89b2                	mv	s3,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005058:	4601                	li	a2,0
    8000505a:	e0fff0ef          	jal	80004e68 <dirlookup>
    8000505e:	e535                	bnez	a0,800050ca <dirlink+0x86>
    80005060:	f426                	sd	s1,40(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80005062:	04c92483          	lw	s1,76(s2)
    80005066:	c48d                	beqz	s1,80005090 <dirlink+0x4c>
    80005068:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000506a:	4741                	li	a4,16
    8000506c:	86a6                	mv	a3,s1
    8000506e:	fc040613          	addi	a2,s0,-64
    80005072:	4581                	li	a1,0
    80005074:	854a                	mv	a0,s2
    80005076:	bcdff0ef          	jal	80004c42 <readi>
    8000507a:	47c1                	li	a5,16
    8000507c:	04f51b63          	bne	a0,a5,800050d2 <dirlink+0x8e>
    if (de.inum == 0)
    80005080:	fc045783          	lhu	a5,-64(s0)
    80005084:	c791                	beqz	a5,80005090 <dirlink+0x4c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80005086:	24c1                	addiw	s1,s1,16
    80005088:	04c92783          	lw	a5,76(s2)
    8000508c:	fcf4efe3          	bltu	s1,a5,8000506a <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80005090:	4639                	li	a2,14
    80005092:	85d2                	mv	a1,s4
    80005094:	fc240513          	addi	a0,s0,-62
    80005098:	e9ffb0ef          	jal	80000f36 <strncpy>
  de.inum = inum;
    8000509c:	fd341023          	sh	s3,-64(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050a0:	4741                	li	a4,16
    800050a2:	86a6                	mv	a3,s1
    800050a4:	fc040613          	addi	a2,s0,-64
    800050a8:	4581                	li	a1,0
    800050aa:	854a                	mv	a0,s2
    800050ac:	c93ff0ef          	jal	80004d3e <writei>
    800050b0:	1541                	addi	a0,a0,-16
    800050b2:	00a03533          	snez	a0,a0
    800050b6:	40a00533          	neg	a0,a0
    800050ba:	74a2                	ld	s1,40(sp)
}
    800050bc:	70e2                	ld	ra,56(sp)
    800050be:	7442                	ld	s0,48(sp)
    800050c0:	7902                	ld	s2,32(sp)
    800050c2:	69e2                	ld	s3,24(sp)
    800050c4:	6a42                	ld	s4,16(sp)
    800050c6:	6121                	addi	sp,sp,64
    800050c8:	8082                	ret
    iput(ip);
    800050ca:	923ff0ef          	jal	800049ec <iput>
    return -1;
    800050ce:	557d                	li	a0,-1
    800050d0:	b7f5                	j	800050bc <dirlink+0x78>
      panic("dirlink read");
    800050d2:	00004517          	auipc	a0,0x4
    800050d6:	71e50513          	addi	a0,a0,1822 # 800097f0 <etext+0x7f0>
    800050da:	f16fb0ef          	jal	800007f0 <panic>

00000000800050de <namei>:

struct inode *
namei(char *path)
{
    800050de:	1101                	addi	sp,sp,-32
    800050e0:	ec06                	sd	ra,24(sp)
    800050e2:	e822                	sd	s0,16(sp)
    800050e4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800050e6:	fe040613          	addi	a2,s0,-32
    800050ea:	4581                	li	a1,0
    800050ec:	e19ff0ef          	jal	80004f04 <namex>
}
    800050f0:	60e2                	ld	ra,24(sp)
    800050f2:	6442                	ld	s0,16(sp)
    800050f4:	6105                	addi	sp,sp,32
    800050f6:	8082                	ret

00000000800050f8 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800050f8:	1141                	addi	sp,sp,-16
    800050fa:	e406                	sd	ra,8(sp)
    800050fc:	e022                	sd	s0,0(sp)
    800050fe:	0800                	addi	s0,sp,16
    80005100:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80005102:	4585                	li	a1,1
    80005104:	e01ff0ef          	jal	80004f04 <namex>
}
    80005108:	60a2                	ld	ra,8(sp)
    8000510a:	6402                	ld	s0,0(sp)
    8000510c:	0141                	addi	sp,sp,16
    8000510e:	8082                	ret

0000000080005110 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005110:	1101                	addi	sp,sp,-32
    80005112:	ec06                	sd	ra,24(sp)
    80005114:	e822                	sd	s0,16(sp)
    80005116:	e426                	sd	s1,8(sp)
    80005118:	e04a                	sd	s2,0(sp)
    8000511a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000511c:	0024c917          	auipc	s2,0x24c
    80005120:	d5c90913          	addi	s2,s2,-676 # 80250e78 <log>
    80005124:	01892583          	lw	a1,24(s2)
    80005128:	02492503          	lw	a0,36(s2)
    8000512c:	872ff0ef          	jal	8000419e <bread>
    80005130:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80005132:	02c92603          	lw	a2,44(s2)
    80005136:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80005138:	00c05f63          	blez	a2,80005156 <write_head+0x46>
    8000513c:	0024c717          	auipc	a4,0x24c
    80005140:	d6c70713          	addi	a4,a4,-660 # 80250ea8 <log+0x30>
    80005144:	87aa                	mv	a5,a0
    80005146:	060a                	slli	a2,a2,0x2
    80005148:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000514a:	4314                	lw	a3,0(a4)
    8000514c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000514e:	0711                	addi	a4,a4,4
    80005150:	0791                	addi	a5,a5,4
    80005152:	fec79ce3          	bne	a5,a2,8000514a <write_head+0x3a>
  }
  bwrite(buf);
    80005156:	8526                	mv	a0,s1
    80005158:	91cff0ef          	jal	80004274 <bwrite>
  brelse(buf);
    8000515c:	8526                	mv	a0,s1
    8000515e:	948ff0ef          	jal	800042a6 <brelse>
}
    80005162:	60e2                	ld	ra,24(sp)
    80005164:	6442                	ld	s0,16(sp)
    80005166:	64a2                	ld	s1,8(sp)
    80005168:	6902                	ld	s2,0(sp)
    8000516a:	6105                	addi	sp,sp,32
    8000516c:	8082                	ret

000000008000516e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000516e:	0024c797          	auipc	a5,0x24c
    80005172:	d367a783          	lw	a5,-714(a5) # 80250ea4 <log+0x2c>
    80005176:	0af05e63          	blez	a5,80005232 <install_trans+0xc4>
{
    8000517a:	715d                	addi	sp,sp,-80
    8000517c:	e486                	sd	ra,72(sp)
    8000517e:	e0a2                	sd	s0,64(sp)
    80005180:	fc26                	sd	s1,56(sp)
    80005182:	f84a                	sd	s2,48(sp)
    80005184:	f44e                	sd	s3,40(sp)
    80005186:	f052                	sd	s4,32(sp)
    80005188:	ec56                	sd	s5,24(sp)
    8000518a:	e85a                	sd	s6,16(sp)
    8000518c:	e45e                	sd	s7,8(sp)
    8000518e:	0880                	addi	s0,sp,80
    80005190:	8b2a                	mv	s6,a0
    80005192:	0024ca97          	auipc	s5,0x24c
    80005196:	d16a8a93          	addi	s5,s5,-746 # 80250ea8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000519a:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000519c:	00004b97          	auipc	s7,0x4
    800051a0:	664b8b93          	addi	s7,s7,1636 # 80009800 <etext+0x800>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800051a4:	0024ca17          	auipc	s4,0x24c
    800051a8:	cd4a0a13          	addi	s4,s4,-812 # 80250e78 <log>
    800051ac:	a025                	j	800051d4 <install_trans+0x66>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800051ae:	000aa603          	lw	a2,0(s5)
    800051b2:	85ce                	mv	a1,s3
    800051b4:	855e                	mv	a0,s7
    800051b6:	b54fb0ef          	jal	8000050a <printk>
    800051ba:	a839                	j	800051d8 <install_trans+0x6a>
    brelse(lbuf);
    800051bc:	854a                	mv	a0,s2
    800051be:	8e8ff0ef          	jal	800042a6 <brelse>
    brelse(dbuf);
    800051c2:	8526                	mv	a0,s1
    800051c4:	8e2ff0ef          	jal	800042a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800051c8:	2985                	addiw	s3,s3,1
    800051ca:	0a91                	addi	s5,s5,4
    800051cc:	02ca2783          	lw	a5,44(s4)
    800051d0:	04f9d663          	bge	s3,a5,8000521c <install_trans+0xae>
    if (recovering) {
    800051d4:	fc0b1de3          	bnez	s6,800051ae <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800051d8:	018a2583          	lw	a1,24(s4)
    800051dc:	013585bb          	addw	a1,a1,s3
    800051e0:	2585                	addiw	a1,a1,1
    800051e2:	024a2503          	lw	a0,36(s4)
    800051e6:	fb9fe0ef          	jal	8000419e <bread>
    800051ea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    800051ec:	000aa583          	lw	a1,0(s5)
    800051f0:	024a2503          	lw	a0,36(s4)
    800051f4:	fabfe0ef          	jal	8000419e <bread>
    800051f8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    800051fa:	40000613          	li	a2,1024
    800051fe:	05890593          	addi	a1,s2,88
    80005202:	05850513          	addi	a0,a0,88
    80005206:	c8bfb0ef          	jal	80000e90 <memmove>
    bwrite(dbuf);                           // write dst to disk
    8000520a:	8526                	mv	a0,s1
    8000520c:	868ff0ef          	jal	80004274 <bwrite>
    if (recovering == 0)
    80005210:	fa0b16e3          	bnez	s6,800051bc <install_trans+0x4e>
      bunpin(dbuf);
    80005214:	8526                	mv	a0,s1
    80005216:	94cff0ef          	jal	80004362 <bunpin>
    8000521a:	b74d                	j	800051bc <install_trans+0x4e>
}
    8000521c:	60a6                	ld	ra,72(sp)
    8000521e:	6406                	ld	s0,64(sp)
    80005220:	74e2                	ld	s1,56(sp)
    80005222:	7942                	ld	s2,48(sp)
    80005224:	79a2                	ld	s3,40(sp)
    80005226:	7a02                	ld	s4,32(sp)
    80005228:	6ae2                	ld	s5,24(sp)
    8000522a:	6b42                	ld	s6,16(sp)
    8000522c:	6ba2                	ld	s7,8(sp)
    8000522e:	6161                	addi	sp,sp,80
    80005230:	8082                	ret
    80005232:	8082                	ret

0000000080005234 <initlog>:
{
    80005234:	7179                	addi	sp,sp,-48
    80005236:	f406                	sd	ra,40(sp)
    80005238:	f022                	sd	s0,32(sp)
    8000523a:	ec26                	sd	s1,24(sp)
    8000523c:	e84a                	sd	s2,16(sp)
    8000523e:	e44e                	sd	s3,8(sp)
    80005240:	1800                	addi	s0,sp,48
    80005242:	892a                	mv	s2,a0
    80005244:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80005246:	0024c497          	auipc	s1,0x24c
    8000524a:	c3248493          	addi	s1,s1,-974 # 80250e78 <log>
    8000524e:	00004597          	auipc	a1,0x4
    80005252:	5d258593          	addi	a1,a1,1490 # 80009820 <etext+0x820>
    80005256:	8526                	mv	a0,s1
    80005258:	aa3fb0ef          	jal	80000cfa <initlock>
  log.start = sb->logstart;
    8000525c:	0149a583          	lw	a1,20(s3)
    80005260:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80005262:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80005266:	854a                	mv	a0,s2
    80005268:	f37fe0ef          	jal	8000419e <bread>
  log.lh.n = lh->n;
    8000526c:	4d30                	lw	a2,88(a0)
    8000526e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80005270:	00c05f63          	blez	a2,8000528e <initlog+0x5a>
    80005274:	87aa                	mv	a5,a0
    80005276:	0024c717          	auipc	a4,0x24c
    8000527a:	c3270713          	addi	a4,a4,-974 # 80250ea8 <log+0x30>
    8000527e:	060a                	slli	a2,a2,0x2
    80005280:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80005282:	4ff4                	lw	a3,92(a5)
    80005284:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80005286:	0791                	addi	a5,a5,4
    80005288:	0711                	addi	a4,a4,4
    8000528a:	fec79ce3          	bne	a5,a2,80005282 <initlog+0x4e>
  brelse(buf);
    8000528e:	818ff0ef          	jal	800042a6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80005292:	4505                	li	a0,1
    80005294:	edbff0ef          	jal	8000516e <install_trans>
  log.lh.n = 0;
    80005298:	0024c797          	auipc	a5,0x24c
    8000529c:	c007a623          	sw	zero,-1012(a5) # 80250ea4 <log+0x2c>
  write_head(); // clear the log
    800052a0:	e71ff0ef          	jal	80005110 <write_head>
}
    800052a4:	70a2                	ld	ra,40(sp)
    800052a6:	7402                	ld	s0,32(sp)
    800052a8:	64e2                	ld	s1,24(sp)
    800052aa:	6942                	ld	s2,16(sp)
    800052ac:	69a2                	ld	s3,8(sp)
    800052ae:	6145                	addi	sp,sp,48
    800052b0:	8082                	ret

00000000800052b2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800052b2:	1101                	addi	sp,sp,-32
    800052b4:	ec06                	sd	ra,24(sp)
    800052b6:	e822                	sd	s0,16(sp)
    800052b8:	e426                	sd	s1,8(sp)
    800052ba:	e04a                	sd	s2,0(sp)
    800052bc:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800052be:	0024c517          	auipc	a0,0x24c
    800052c2:	bba50513          	addi	a0,a0,-1094 # 80250e78 <log>
    800052c6:	aabfb0ef          	jal	80000d70 <acquire>
  while (1) {
    if (log.committing) {
    800052ca:	0024c497          	auipc	s1,0x24c
    800052ce:	bae48493          	addi	s1,s1,-1106 # 80250e78 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    800052d2:	4979                	li	s2,30
    800052d4:	a821                	j	800052ec <begin_op+0x3a>
      sleep_prepare(&log);
    800052d6:	8526                	mv	a0,s1
    800052d8:	e56fd0ef          	jal	8000292e <sleep_prepare>
      release(&log.lock);
    800052dc:	8526                	mv	a0,s1
    800052de:	b1ffb0ef          	jal	80000dfc <release>
      sleep();
    800052e2:	e88fd0ef          	jal	8000296a <sleep>
      acquire(&log.lock);
    800052e6:	8526                	mv	a0,s1
    800052e8:	a89fb0ef          	jal	80000d70 <acquire>
    if (log.committing) {
    800052ec:	509c                	lw	a5,32(s1)
    800052ee:	f7e5                	bnez	a5,800052d6 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    800052f0:	4cd8                	lw	a4,28(s1)
    800052f2:	2705                	addiw	a4,a4,1
    800052f4:	0027179b          	slliw	a5,a4,0x2
    800052f8:	9fb9                	addw	a5,a5,a4
    800052fa:	0017979b          	slliw	a5,a5,0x1
    800052fe:	54d4                	lw	a3,44(s1)
    80005300:	9fb5                	addw	a5,a5,a3
    80005302:	00f95e63          	bge	s2,a5,8000531e <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80005306:	8526                	mv	a0,s1
    80005308:	e26fd0ef          	jal	8000292e <sleep_prepare>
      release(&log.lock);
    8000530c:	8526                	mv	a0,s1
    8000530e:	aeffb0ef          	jal	80000dfc <release>
      sleep();
    80005312:	e58fd0ef          	jal	8000296a <sleep>
      acquire(&log.lock);
    80005316:	8526                	mv	a0,s1
    80005318:	a59fb0ef          	jal	80000d70 <acquire>
    8000531c:	bfc1                	j	800052ec <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    8000531e:	0024c517          	auipc	a0,0x24c
    80005322:	b5a50513          	addi	a0,a0,-1190 # 80250e78 <log>
    80005326:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80005328:	ad5fb0ef          	jal	80000dfc <release>
      break;
    }
  }
}
    8000532c:	60e2                	ld	ra,24(sp)
    8000532e:	6442                	ld	s0,16(sp)
    80005330:	64a2                	ld	s1,8(sp)
    80005332:	6902                	ld	s2,0(sp)
    80005334:	6105                	addi	sp,sp,32
    80005336:	8082                	ret

0000000080005338 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005338:	7139                	addi	sp,sp,-64
    8000533a:	fc06                	sd	ra,56(sp)
    8000533c:	f822                	sd	s0,48(sp)
    8000533e:	f426                	sd	s1,40(sp)
    80005340:	f04a                	sd	s2,32(sp)
    80005342:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80005344:	0024c497          	auipc	s1,0x24c
    80005348:	b3448493          	addi	s1,s1,-1228 # 80250e78 <log>
    8000534c:	8526                	mv	a0,s1
    8000534e:	a23fb0ef          	jal	80000d70 <acquire>
  log.outstanding -= 1;
    80005352:	4cdc                	lw	a5,28(s1)
    80005354:	37fd                	addiw	a5,a5,-1
    80005356:	0007891b          	sext.w	s2,a5
    8000535a:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    8000535c:	509c                	lw	a5,32(s1)
    8000535e:	e3b1                	bnez	a5,800053a2 <end_op+0x6a>
    panic("log.committing");
  if (log.outstanding == 0) {
    80005360:	04091a63          	bnez	s2,800053b4 <end_op+0x7c>
    do_commit = 1;
    log.committing = 1;
    80005364:	0024c497          	auipc	s1,0x24c
    80005368:	b1448493          	addi	s1,s1,-1260 # 80250e78 <log>
    8000536c:	4785                	li	a5,1
    8000536e:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80005370:	8526                	mv	a0,s1
    80005372:	a8bfb0ef          	jal	80000dfc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80005376:	54dc                	lw	a5,44(s1)
    80005378:	04f04e63          	bgtz	a5,800053d4 <end_op+0x9c>
    acquire(&log.lock);
    8000537c:	0024c497          	auipc	s1,0x24c
    80005380:	afc48493          	addi	s1,s1,-1284 # 80250e78 <log>
    80005384:	8526                	mv	a0,s1
    80005386:	9ebfb0ef          	jal	80000d70 <acquire>
    log.committing = 0;
    8000538a:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    8000538e:	549c                	lw	a5,40(s1)
    80005390:	2785                	addiw	a5,a5,1
    80005392:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80005394:	8526                	mv	a0,s1
    80005396:	e04fd0ef          	jal	8000299a <wakeup>
    release(&log.lock);
    8000539a:	8526                	mv	a0,s1
    8000539c:	a61fb0ef          	jal	80000dfc <release>
}
    800053a0:	a025                	j	800053c8 <end_op+0x90>
    800053a2:	ec4e                	sd	s3,24(sp)
    800053a4:	e852                	sd	s4,16(sp)
    800053a6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800053a8:	00004517          	auipc	a0,0x4
    800053ac:	48050513          	addi	a0,a0,1152 # 80009828 <etext+0x828>
    800053b0:	c40fb0ef          	jal	800007f0 <panic>
    wakeup(&log);
    800053b4:	0024c497          	auipc	s1,0x24c
    800053b8:	ac448493          	addi	s1,s1,-1340 # 80250e78 <log>
    800053bc:	8526                	mv	a0,s1
    800053be:	ddcfd0ef          	jal	8000299a <wakeup>
  release(&log.lock);
    800053c2:	8526                	mv	a0,s1
    800053c4:	a39fb0ef          	jal	80000dfc <release>
}
    800053c8:	70e2                	ld	ra,56(sp)
    800053ca:	7442                	ld	s0,48(sp)
    800053cc:	74a2                	ld	s1,40(sp)
    800053ce:	7902                	ld	s2,32(sp)
    800053d0:	6121                	addi	sp,sp,64
    800053d2:	8082                	ret
    800053d4:	ec4e                	sd	s3,24(sp)
    800053d6:	e852                	sd	s4,16(sp)
    800053d8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800053da:	0024ca97          	auipc	s5,0x24c
    800053de:	acea8a93          	addi	s5,s5,-1330 # 80250ea8 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    800053e2:	0024ca17          	auipc	s4,0x24c
    800053e6:	a96a0a13          	addi	s4,s4,-1386 # 80250e78 <log>
    800053ea:	018a2583          	lw	a1,24(s4)
    800053ee:	012585bb          	addw	a1,a1,s2
    800053f2:	2585                	addiw	a1,a1,1
    800053f4:	024a2503          	lw	a0,36(s4)
    800053f8:	da7fe0ef          	jal	8000419e <bread>
    800053fc:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800053fe:	000aa583          	lw	a1,0(s5)
    80005402:	024a2503          	lw	a0,36(s4)
    80005406:	d99fe0ef          	jal	8000419e <bread>
    8000540a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000540c:	40000613          	li	a2,1024
    80005410:	05850593          	addi	a1,a0,88
    80005414:	05848513          	addi	a0,s1,88
    80005418:	a79fb0ef          	jal	80000e90 <memmove>
    bwrite(to); // write the log
    8000541c:	8526                	mv	a0,s1
    8000541e:	e57fe0ef          	jal	80004274 <bwrite>
    brelse(from);
    80005422:	854e                	mv	a0,s3
    80005424:	e83fe0ef          	jal	800042a6 <brelse>
    brelse(to);
    80005428:	8526                	mv	a0,s1
    8000542a:	e7dfe0ef          	jal	800042a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000542e:	2905                	addiw	s2,s2,1
    80005430:	0a91                	addi	s5,s5,4
    80005432:	02ca2783          	lw	a5,44(s4)
    80005436:	faf94ae3          	blt	s2,a5,800053ea <end_op+0xb2>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    8000543a:	cd7ff0ef          	jal	80005110 <write_head>
    install_trans(0); // Now install writes to home locations
    8000543e:	4501                	li	a0,0
    80005440:	d2fff0ef          	jal	8000516e <install_trans>
    log.lh.n = 0;
    80005444:	0024c797          	auipc	a5,0x24c
    80005448:	a607a023          	sw	zero,-1440(a5) # 80250ea4 <log+0x2c>
    write_head(); // Erase the transaction from the log
    8000544c:	cc5ff0ef          	jal	80005110 <write_head>
    80005450:	69e2                	ld	s3,24(sp)
    80005452:	6a42                	ld	s4,16(sp)
    80005454:	6aa2                	ld	s5,8(sp)
    80005456:	b71d                	j	8000537c <end_op+0x44>

0000000080005458 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80005458:	1101                	addi	sp,sp,-32
    8000545a:	ec06                	sd	ra,24(sp)
    8000545c:	e822                	sd	s0,16(sp)
    8000545e:	e426                	sd	s1,8(sp)
    80005460:	e04a                	sd	s2,0(sp)
    80005462:	1000                	addi	s0,sp,32
    80005464:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80005466:	0024c917          	auipc	s2,0x24c
    8000546a:	a1290913          	addi	s2,s2,-1518 # 80250e78 <log>
    8000546e:	854a                	mv	a0,s2
    80005470:	901fb0ef          	jal	80000d70 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80005474:	02c92603          	lw	a2,44(s2)
    80005478:	47f5                	li	a5,29
    8000547a:	04c7cc63          	blt	a5,a2,800054d2 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000547e:	0024c797          	auipc	a5,0x24c
    80005482:	a167a783          	lw	a5,-1514(a5) # 80250e94 <log+0x1c>
    80005486:	04f05c63          	blez	a5,800054de <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000548a:	4781                	li	a5,0
    8000548c:	04c05f63          	blez	a2,800054ea <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80005490:	44cc                	lw	a1,12(s1)
    80005492:	0024c717          	auipc	a4,0x24c
    80005496:	a1670713          	addi	a4,a4,-1514 # 80250ea8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000549a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    8000549c:	4314                	lw	a3,0(a4)
    8000549e:	04b68663          	beq	a3,a1,800054ea <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800054a2:	2785                	addiw	a5,a5,1
    800054a4:	0711                	addi	a4,a4,4
    800054a6:	fef61be3          	bne	a2,a5,8000549c <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800054aa:	0621                	addi	a2,a2,8
    800054ac:	060a                	slli	a2,a2,0x2
    800054ae:	0024c797          	auipc	a5,0x24c
    800054b2:	9ca78793          	addi	a5,a5,-1590 # 80250e78 <log>
    800054b6:	97b2                	add	a5,a5,a2
    800054b8:	44d8                	lw	a4,12(s1)
    800054ba:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    800054bc:	8526                	mv	a0,s1
    800054be:	e71fe0ef          	jal	8000432e <bpin>
    log.lh.n++;
    800054c2:	0024c717          	auipc	a4,0x24c
    800054c6:	9b670713          	addi	a4,a4,-1610 # 80250e78 <log>
    800054ca:	575c                	lw	a5,44(a4)
    800054cc:	2785                	addiw	a5,a5,1
    800054ce:	d75c                	sw	a5,44(a4)
    800054d0:	a80d                	j	80005502 <log_write+0xaa>
    panic("too big a transaction");
    800054d2:	00004517          	auipc	a0,0x4
    800054d6:	36650513          	addi	a0,a0,870 # 80009838 <etext+0x838>
    800054da:	b16fb0ef          	jal	800007f0 <panic>
    panic("log_write outside of trans");
    800054de:	00004517          	auipc	a0,0x4
    800054e2:	37250513          	addi	a0,a0,882 # 80009850 <etext+0x850>
    800054e6:	b0afb0ef          	jal	800007f0 <panic>
  log.lh.block[i] = b->blockno;
    800054ea:	00878693          	addi	a3,a5,8
    800054ee:	068a                	slli	a3,a3,0x2
    800054f0:	0024c717          	auipc	a4,0x24c
    800054f4:	98870713          	addi	a4,a4,-1656 # 80250e78 <log>
    800054f8:	9736                	add	a4,a4,a3
    800054fa:	44d4                	lw	a3,12(s1)
    800054fc:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    800054fe:	faf60fe3          	beq	a2,a5,800054bc <log_write+0x64>
  }
  release(&log.lock);
    80005502:	0024c517          	auipc	a0,0x24c
    80005506:	97650513          	addi	a0,a0,-1674 # 80250e78 <log>
    8000550a:	8f3fb0ef          	jal	80000dfc <release>
}
    8000550e:	60e2                	ld	ra,24(sp)
    80005510:	6442                	ld	s0,16(sp)
    80005512:	64a2                	ld	s1,8(sp)
    80005514:	6902                	ld	s2,0(sp)
    80005516:	6105                	addi	sp,sp,32
    80005518:	8082                	ret

000000008000551a <sys_sync>:

uint64
sys_sync(void)
{
    8000551a:	1101                	addi	sp,sp,-32
    8000551c:	ec06                	sd	ra,24(sp)
    8000551e:	e822                	sd	s0,16(sp)
    80005520:	e426                	sd	s1,8(sp)
    80005522:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80005524:	0024c497          	auipc	s1,0x24c
    80005528:	95448493          	addi	s1,s1,-1708 # 80250e78 <log>
    8000552c:	8526                	mv	a0,s1
    8000552e:	843fb0ef          	jal	80000d70 <acquire>
  if (log.committing || log.outstanding > 0) {
    80005532:	509c                	lw	a5,32(s1)
    80005534:	e799                	bnez	a5,80005542 <sys_sync+0x28>
    80005536:	0024c797          	auipc	a5,0x24c
    8000553a:	95e7a783          	lw	a5,-1698(a5) # 80250e94 <log+0x1c>
    8000553e:	02f05a63          	blez	a5,80005572 <sys_sync+0x58>
    80005542:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80005544:	0024c917          	auipc	s2,0x24c
    80005548:	95c92903          	lw	s2,-1700(s2) # 80250ea0 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    8000554c:	0024c497          	auipc	s1,0x24c
    80005550:	92c48493          	addi	s1,s1,-1748 # 80250e78 <log>
    80005554:	8526                	mv	a0,s1
    80005556:	bd8fd0ef          	jal	8000292e <sleep_prepare>
      release(&log.lock);
    8000555a:	8526                	mv	a0,s1
    8000555c:	8a1fb0ef          	jal	80000dfc <release>
      sleep();
    80005560:	c0afd0ef          	jal	8000296a <sleep>
      acquire(&log.lock);
    80005564:	8526                	mv	a0,s1
    80005566:	80bfb0ef          	jal	80000d70 <acquire>
    while (log.ncommit < n) {
    8000556a:	549c                	lw	a5,40(s1)
    8000556c:	fef954e3          	bge	s2,a5,80005554 <sys_sync+0x3a>
    80005570:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80005572:	0024c517          	auipc	a0,0x24c
    80005576:	90650513          	addi	a0,a0,-1786 # 80250e78 <log>
    8000557a:	883fb0ef          	jal	80000dfc <release>
  return 0;
}
    8000557e:	4501                	li	a0,0
    80005580:	60e2                	ld	ra,24(sp)
    80005582:	6442                	ld	s0,16(sp)
    80005584:	64a2                	ld	s1,8(sp)
    80005586:	6105                	addi	sp,sp,32
    80005588:	8082                	ret

000000008000558a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000558a:	1101                	addi	sp,sp,-32
    8000558c:	ec06                	sd	ra,24(sp)
    8000558e:	e822                	sd	s0,16(sp)
    80005590:	e426                	sd	s1,8(sp)
    80005592:	e04a                	sd	s2,0(sp)
    80005594:	1000                	addi	s0,sp,32
    80005596:	84aa                	mv	s1,a0
    80005598:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000559a:	00004597          	auipc	a1,0x4
    8000559e:	2d658593          	addi	a1,a1,726 # 80009870 <etext+0x870>
    800055a2:	0521                	addi	a0,a0,8
    800055a4:	f56fb0ef          	jal	80000cfa <initlock>
  lk->name = name;
    800055a8:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800055ac:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800055b0:	0204a423          	sw	zero,40(s1)
}
    800055b4:	60e2                	ld	ra,24(sp)
    800055b6:	6442                	ld	s0,16(sp)
    800055b8:	64a2                	ld	s1,8(sp)
    800055ba:	6902                	ld	s2,0(sp)
    800055bc:	6105                	addi	sp,sp,32
    800055be:	8082                	ret

00000000800055c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800055c0:	1101                	addi	sp,sp,-32
    800055c2:	ec06                	sd	ra,24(sp)
    800055c4:	e822                	sd	s0,16(sp)
    800055c6:	e426                	sd	s1,8(sp)
    800055c8:	e04a                	sd	s2,0(sp)
    800055ca:	1000                	addi	s0,sp,32
    800055cc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800055ce:	00850913          	addi	s2,a0,8
    800055d2:	854a                	mv	a0,s2
    800055d4:	f9cfb0ef          	jal	80000d70 <acquire>
  while (lk->locked) {
    800055d8:	409c                	lw	a5,0(s1)
    800055da:	cf91                	beqz	a5,800055f6 <acquiresleep+0x36>
    sleep_prepare(lk);
    800055dc:	8526                	mv	a0,s1
    800055de:	b50fd0ef          	jal	8000292e <sleep_prepare>
    release(&lk->lk);
    800055e2:	854a                	mv	a0,s2
    800055e4:	819fb0ef          	jal	80000dfc <release>
    sleep();
    800055e8:	b82fd0ef          	jal	8000296a <sleep>
    acquire(&lk->lk);
    800055ec:	854a                	mv	a0,s2
    800055ee:	f82fb0ef          	jal	80000d70 <acquire>
  while (lk->locked) {
    800055f2:	409c                	lw	a5,0(s1)
    800055f4:	f7e5                	bnez	a5,800055dc <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800055f6:	4785                	li	a5,1
    800055f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800055fa:	bd1fc0ef          	jal	800021ca <myproc>
    800055fe:	591c                	lw	a5,48(a0)
    80005600:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80005602:	854a                	mv	a0,s2
    80005604:	ff8fb0ef          	jal	80000dfc <release>
}
    80005608:	60e2                	ld	ra,24(sp)
    8000560a:	6442                	ld	s0,16(sp)
    8000560c:	64a2                	ld	s1,8(sp)
    8000560e:	6902                	ld	s2,0(sp)
    80005610:	6105                	addi	sp,sp,32
    80005612:	8082                	ret

0000000080005614 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005614:	1101                	addi	sp,sp,-32
    80005616:	ec06                	sd	ra,24(sp)
    80005618:	e822                	sd	s0,16(sp)
    8000561a:	e426                	sd	s1,8(sp)
    8000561c:	e04a                	sd	s2,0(sp)
    8000561e:	1000                	addi	s0,sp,32
    80005620:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005622:	00850913          	addi	s2,a0,8
    80005626:	854a                	mv	a0,s2
    80005628:	f48fb0ef          	jal	80000d70 <acquire>
  lk->locked = 0;
    8000562c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005630:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005634:	8526                	mv	a0,s1
    80005636:	b64fd0ef          	jal	8000299a <wakeup>
  release(&lk->lk);
    8000563a:	854a                	mv	a0,s2
    8000563c:	fc0fb0ef          	jal	80000dfc <release>
}
    80005640:	60e2                	ld	ra,24(sp)
    80005642:	6442                	ld	s0,16(sp)
    80005644:	64a2                	ld	s1,8(sp)
    80005646:	6902                	ld	s2,0(sp)
    80005648:	6105                	addi	sp,sp,32
    8000564a:	8082                	ret

000000008000564c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000564c:	7179                	addi	sp,sp,-48
    8000564e:	f406                	sd	ra,40(sp)
    80005650:	f022                	sd	s0,32(sp)
    80005652:	ec26                	sd	s1,24(sp)
    80005654:	e84a                	sd	s2,16(sp)
    80005656:	1800                	addi	s0,sp,48
    80005658:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000565a:	00850913          	addi	s2,a0,8
    8000565e:	854a                	mv	a0,s2
    80005660:	f10fb0ef          	jal	80000d70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005664:	409c                	lw	a5,0(s1)
    80005666:	ef81                	bnez	a5,8000567e <holdingsleep+0x32>
    80005668:	4481                	li	s1,0
  release(&lk->lk);
    8000566a:	854a                	mv	a0,s2
    8000566c:	f90fb0ef          	jal	80000dfc <release>
  return r;
}
    80005670:	8526                	mv	a0,s1
    80005672:	70a2                	ld	ra,40(sp)
    80005674:	7402                	ld	s0,32(sp)
    80005676:	64e2                	ld	s1,24(sp)
    80005678:	6942                	ld	s2,16(sp)
    8000567a:	6145                	addi	sp,sp,48
    8000567c:	8082                	ret
    8000567e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80005680:	0284a983          	lw	s3,40(s1)
    80005684:	b47fc0ef          	jal	800021ca <myproc>
    80005688:	5904                	lw	s1,48(a0)
    8000568a:	413484b3          	sub	s1,s1,s3
    8000568e:	0014b493          	seqz	s1,s1
    80005692:	69a2                	ld	s3,8(sp)
    80005694:	bfd9                	j	8000566a <holdingsleep+0x1e>

0000000080005696 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005696:	1141                	addi	sp,sp,-16
    80005698:	e406                	sd	ra,8(sp)
    8000569a:	e022                	sd	s0,0(sp)
    8000569c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000569e:	00004597          	auipc	a1,0x4
    800056a2:	1e258593          	addi	a1,a1,482 # 80009880 <etext+0x880>
    800056a6:	0024c517          	auipc	a0,0x24c
    800056aa:	91a50513          	addi	a0,a0,-1766 # 80250fc0 <ftable>
    800056ae:	e4cfb0ef          	jal	80000cfa <initlock>
}
    800056b2:	60a2                	ld	ra,8(sp)
    800056b4:	6402                	ld	s0,0(sp)
    800056b6:	0141                	addi	sp,sp,16
    800056b8:	8082                	ret

00000000800056ba <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800056ba:	1101                	addi	sp,sp,-32
    800056bc:	ec06                	sd	ra,24(sp)
    800056be:	e822                	sd	s0,16(sp)
    800056c0:	e426                	sd	s1,8(sp)
    800056c2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800056c4:	0024c517          	auipc	a0,0x24c
    800056c8:	8fc50513          	addi	a0,a0,-1796 # 80250fc0 <ftable>
    800056cc:	ea4fb0ef          	jal	80000d70 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800056d0:	0024c497          	auipc	s1,0x24c
    800056d4:	90848493          	addi	s1,s1,-1784 # 80250fd8 <ftable+0x18>
    800056d8:	0024d717          	auipc	a4,0x24d
    800056dc:	8a070713          	addi	a4,a4,-1888 # 80251f78 <disk>
    if (f->ref == 0) {
    800056e0:	40dc                	lw	a5,4(s1)
    800056e2:	cf89                	beqz	a5,800056fc <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800056e4:	02848493          	addi	s1,s1,40
    800056e8:	fee49ce3          	bne	s1,a4,800056e0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800056ec:	0024c517          	auipc	a0,0x24c
    800056f0:	8d450513          	addi	a0,a0,-1836 # 80250fc0 <ftable>
    800056f4:	f08fb0ef          	jal	80000dfc <release>
  return 0;
    800056f8:	4481                	li	s1,0
    800056fa:	a809                	j	8000570c <filealloc+0x52>
      f->ref = 1;
    800056fc:	4785                	li	a5,1
    800056fe:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005700:	0024c517          	auipc	a0,0x24c
    80005704:	8c050513          	addi	a0,a0,-1856 # 80250fc0 <ftable>
    80005708:	ef4fb0ef          	jal	80000dfc <release>
}
    8000570c:	8526                	mv	a0,s1
    8000570e:	60e2                	ld	ra,24(sp)
    80005710:	6442                	ld	s0,16(sp)
    80005712:	64a2                	ld	s1,8(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret

0000000080005718 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80005718:	1101                	addi	sp,sp,-32
    8000571a:	ec06                	sd	ra,24(sp)
    8000571c:	e822                	sd	s0,16(sp)
    8000571e:	e426                	sd	s1,8(sp)
    80005720:	1000                	addi	s0,sp,32
    80005722:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80005724:	0024c517          	auipc	a0,0x24c
    80005728:	89c50513          	addi	a0,a0,-1892 # 80250fc0 <ftable>
    8000572c:	e44fb0ef          	jal	80000d70 <acquire>
  if (f->ref < 1)
    80005730:	40dc                	lw	a5,4(s1)
    80005732:	02f05063          	blez	a5,80005752 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80005736:	2785                	addiw	a5,a5,1
    80005738:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000573a:	0024c517          	auipc	a0,0x24c
    8000573e:	88650513          	addi	a0,a0,-1914 # 80250fc0 <ftable>
    80005742:	ebafb0ef          	jal	80000dfc <release>
  return f;
}
    80005746:	8526                	mv	a0,s1
    80005748:	60e2                	ld	ra,24(sp)
    8000574a:	6442                	ld	s0,16(sp)
    8000574c:	64a2                	ld	s1,8(sp)
    8000574e:	6105                	addi	sp,sp,32
    80005750:	8082                	ret
    panic("filedup");
    80005752:	00004517          	auipc	a0,0x4
    80005756:	13650513          	addi	a0,a0,310 # 80009888 <etext+0x888>
    8000575a:	896fb0ef          	jal	800007f0 <panic>

000000008000575e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000575e:	7139                	addi	sp,sp,-64
    80005760:	fc06                	sd	ra,56(sp)
    80005762:	f822                	sd	s0,48(sp)
    80005764:	f426                	sd	s1,40(sp)
    80005766:	0080                	addi	s0,sp,64
    80005768:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000576a:	0024c517          	auipc	a0,0x24c
    8000576e:	85650513          	addi	a0,a0,-1962 # 80250fc0 <ftable>
    80005772:	dfefb0ef          	jal	80000d70 <acquire>
  if (f->ref < 1)
    80005776:	40dc                	lw	a5,4(s1)
    80005778:	04f05a63          	blez	a5,800057cc <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    8000577c:	37fd                	addiw	a5,a5,-1
    8000577e:	0007871b          	sext.w	a4,a5
    80005782:	c0dc                	sw	a5,4(s1)
    80005784:	04e04e63          	bgtz	a4,800057e0 <fileclose+0x82>
    80005788:	f04a                	sd	s2,32(sp)
    8000578a:	ec4e                	sd	s3,24(sp)
    8000578c:	e852                	sd	s4,16(sp)
    8000578e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005790:	0004a903          	lw	s2,0(s1)
    80005794:	0094ca83          	lbu	s5,9(s1)
    80005798:	0104ba03          	ld	s4,16(s1)
    8000579c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800057a0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800057a4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800057a8:	0024c517          	auipc	a0,0x24c
    800057ac:	81850513          	addi	a0,a0,-2024 # 80250fc0 <ftable>
    800057b0:	e4cfb0ef          	jal	80000dfc <release>

  if (ff.type == FD_PIPE) {
    800057b4:	4785                	li	a5,1
    800057b6:	04f90063          	beq	s2,a5,800057f6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    800057ba:	3979                	addiw	s2,s2,-2
    800057bc:	4785                	li	a5,1
    800057be:	0527f563          	bgeu	a5,s2,80005808 <fileclose+0xaa>
    800057c2:	7902                	ld	s2,32(sp)
    800057c4:	69e2                	ld	s3,24(sp)
    800057c6:	6a42                	ld	s4,16(sp)
    800057c8:	6aa2                	ld	s5,8(sp)
    800057ca:	a00d                	j	800057ec <fileclose+0x8e>
    800057cc:	f04a                	sd	s2,32(sp)
    800057ce:	ec4e                	sd	s3,24(sp)
    800057d0:	e852                	sd	s4,16(sp)
    800057d2:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800057d4:	00004517          	auipc	a0,0x4
    800057d8:	0bc50513          	addi	a0,a0,188 # 80009890 <etext+0x890>
    800057dc:	814fb0ef          	jal	800007f0 <panic>
    release(&ftable.lock);
    800057e0:	0024b517          	auipc	a0,0x24b
    800057e4:	7e050513          	addi	a0,a0,2016 # 80250fc0 <ftable>
    800057e8:	e14fb0ef          	jal	80000dfc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800057ec:	70e2                	ld	ra,56(sp)
    800057ee:	7442                	ld	s0,48(sp)
    800057f0:	74a2                	ld	s1,40(sp)
    800057f2:	6121                	addi	sp,sp,64
    800057f4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800057f6:	85d6                	mv	a1,s5
    800057f8:	8552                	mv	a0,s4
    800057fa:	34c000ef          	jal	80005b46 <pipeclose>
    800057fe:	7902                	ld	s2,32(sp)
    80005800:	69e2                	ld	s3,24(sp)
    80005802:	6a42                	ld	s4,16(sp)
    80005804:	6aa2                	ld	s5,8(sp)
    80005806:	b7dd                	j	800057ec <fileclose+0x8e>
    begin_op();
    80005808:	aabff0ef          	jal	800052b2 <begin_op>
    iput(ff.ip);
    8000580c:	854e                	mv	a0,s3
    8000580e:	9deff0ef          	jal	800049ec <iput>
    end_op();
    80005812:	b27ff0ef          	jal	80005338 <end_op>
    80005816:	7902                	ld	s2,32(sp)
    80005818:	69e2                	ld	s3,24(sp)
    8000581a:	6a42                	ld	s4,16(sp)
    8000581c:	6aa2                	ld	s5,8(sp)
    8000581e:	b7f9                	j	800057ec <fileclose+0x8e>

0000000080005820 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005820:	715d                	addi	sp,sp,-80
    80005822:	e486                	sd	ra,72(sp)
    80005824:	e0a2                	sd	s0,64(sp)
    80005826:	fc26                	sd	s1,56(sp)
    80005828:	f44e                	sd	s3,40(sp)
    8000582a:	0880                	addi	s0,sp,80
    8000582c:	84aa                	mv	s1,a0
    8000582e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005830:	99bfc0ef          	jal	800021ca <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80005834:	409c                	lw	a5,0(s1)
    80005836:	37f9                	addiw	a5,a5,-2
    80005838:	4705                	li	a4,1
    8000583a:	04f76263          	bltu	a4,a5,8000587e <filestat+0x5e>
    8000583e:	f84a                	sd	s2,48(sp)
    80005840:	892a                	mv	s2,a0
    ilock(f->ip);
    80005842:	6c88                	ld	a0,24(s1)
    80005844:	826ff0ef          	jal	8000486a <ilock>
    stati(f->ip, &st);
    80005848:	fb840593          	addi	a1,s0,-72
    8000584c:	6c88                	ld	a0,24(s1)
    8000584e:	bcaff0ef          	jal	80004c18 <stati>
    iunlock(f->ip);
    80005852:	6c88                	ld	a0,24(s1)
    80005854:	8c4ff0ef          	jal	80004918 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    80005858:	4761                	li	a4,24
    8000585a:	fb840693          	addi	a3,s0,-72
    8000585e:	864e                	mv	a2,s3
    80005860:	08893583          	ld	a1,136(s2)
    80005864:	09093503          	ld	a0,144(s2)
    80005868:	940fc0ef          	jal	800019a8 <copyout>
    8000586c:	41f5551b          	sraiw	a0,a0,0x1f
    80005870:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005872:	60a6                	ld	ra,72(sp)
    80005874:	6406                	ld	s0,64(sp)
    80005876:	74e2                	ld	s1,56(sp)
    80005878:	79a2                	ld	s3,40(sp)
    8000587a:	6161                	addi	sp,sp,80
    8000587c:	8082                	ret
  return -1;
    8000587e:	557d                	li	a0,-1
    80005880:	bfcd                	j	80005872 <filestat+0x52>

0000000080005882 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005882:	7179                	addi	sp,sp,-48
    80005884:	f406                	sd	ra,40(sp)
    80005886:	f022                	sd	s0,32(sp)
    80005888:	e84a                	sd	s2,16(sp)
    8000588a:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    8000588c:	00854783          	lbu	a5,8(a0)
    80005890:	c3c5                	beqz	a5,80005930 <fileread+0xae>
    80005892:	ec26                	sd	s1,24(sp)
    80005894:	e44e                	sd	s3,8(sp)
    80005896:	84aa                	mv	s1,a0
    80005898:	89ae                	mv	s3,a1
    8000589a:	8932                	mv	s2,a2
    8000589c:	08064c63          	bltz	a2,80005934 <fileread+0xb2>
    return -1;

  if (f->type == FD_PIPE) {
    800058a0:	411c                	lw	a5,0(a0)
    800058a2:	4705                	li	a4,1
    800058a4:	04e78363          	beq	a5,a4,800058ea <fileread+0x68>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800058a8:	470d                	li	a4,3
    800058aa:	04e78763          	beq	a5,a4,800058f8 <fileread+0x76>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    800058ae:	4709                	li	a4,2
    800058b0:	06e79a63          	bne	a5,a4,80005924 <fileread+0xa2>
    ilock(f->ip);
    800058b4:	6d08                	ld	a0,24(a0)
    800058b6:	fb5fe0ef          	jal	8000486a <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800058ba:	874a                	mv	a4,s2
    800058bc:	5094                	lw	a3,32(s1)
    800058be:	864e                	mv	a2,s3
    800058c0:	4585                	li	a1,1
    800058c2:	6c88                	ld	a0,24(s1)
    800058c4:	b7eff0ef          	jal	80004c42 <readi>
    800058c8:	892a                	mv	s2,a0
    800058ca:	00a05563          	blez	a0,800058d4 <fileread+0x52>
      f->off += r;
    800058ce:	509c                	lw	a5,32(s1)
    800058d0:	9fa9                	addw	a5,a5,a0
    800058d2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800058d4:	6c88                	ld	a0,24(s1)
    800058d6:	842ff0ef          	jal	80004918 <iunlock>
    800058da:	64e2                	ld	s1,24(sp)
    800058dc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800058de:	854a                	mv	a0,s2
    800058e0:	70a2                	ld	ra,40(sp)
    800058e2:	7402                	ld	s0,32(sp)
    800058e4:	6942                	ld	s2,16(sp)
    800058e6:	6145                	addi	sp,sp,48
    800058e8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800058ea:	6908                	ld	a0,16(a0)
    800058ec:	3b6000ef          	jal	80005ca2 <piperead>
    800058f0:	892a                	mv	s2,a0
    800058f2:	64e2                	ld	s1,24(sp)
    800058f4:	69a2                	ld	s3,8(sp)
    800058f6:	b7e5                	j	800058de <fileread+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800058f8:	02451783          	lh	a5,36(a0)
    800058fc:	03079693          	slli	a3,a5,0x30
    80005900:	92c1                	srli	a3,a3,0x30
    80005902:	4725                	li	a4,9
    80005904:	02d76c63          	bltu	a4,a3,8000593c <fileread+0xba>
    80005908:	0792                	slli	a5,a5,0x4
    8000590a:	0024b717          	auipc	a4,0x24b
    8000590e:	61670713          	addi	a4,a4,1558 # 80250f20 <devsw>
    80005912:	97ba                	add	a5,a5,a4
    80005914:	639c                	ld	a5,0(a5)
    80005916:	c79d                	beqz	a5,80005944 <fileread+0xc2>
    r = devsw[f->major].read(1, addr, n);
    80005918:	4505                	li	a0,1
    8000591a:	9782                	jalr	a5
    8000591c:	892a                	mv	s2,a0
    8000591e:	64e2                	ld	s1,24(sp)
    80005920:	69a2                	ld	s3,8(sp)
    80005922:	bf75                	j	800058de <fileread+0x5c>
    panic("fileread");
    80005924:	00004517          	auipc	a0,0x4
    80005928:	f7c50513          	addi	a0,a0,-132 # 800098a0 <etext+0x8a0>
    8000592c:	ec5fa0ef          	jal	800007f0 <panic>
    return -1;
    80005930:	597d                	li	s2,-1
    80005932:	b775                	j	800058de <fileread+0x5c>
    80005934:	597d                	li	s2,-1
    80005936:	64e2                	ld	s1,24(sp)
    80005938:	69a2                	ld	s3,8(sp)
    8000593a:	b755                	j	800058de <fileread+0x5c>
      return -1;
    8000593c:	597d                	li	s2,-1
    8000593e:	64e2                	ld	s1,24(sp)
    80005940:	69a2                	ld	s3,8(sp)
    80005942:	bf71                	j	800058de <fileread+0x5c>
    80005944:	597d                	li	s2,-1
    80005946:	64e2                	ld	s1,24(sp)
    80005948:	69a2                	ld	s3,8(sp)
    8000594a:	bf51                	j	800058de <fileread+0x5c>

000000008000594c <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    8000594c:	00954783          	lbu	a5,9(a0)
    80005950:	10078663          	beqz	a5,80005a5c <filewrite+0x110>
{
    80005954:	715d                	addi	sp,sp,-80
    80005956:	e486                	sd	ra,72(sp)
    80005958:	e0a2                	sd	s0,64(sp)
    8000595a:	f84a                	sd	s2,48(sp)
    8000595c:	f052                	sd	s4,32(sp)
    8000595e:	e85a                	sd	s6,16(sp)
    80005960:	0880                	addi	s0,sp,80
    80005962:	892a                	mv	s2,a0
    80005964:	8b2e                	mv	s6,a1
    80005966:	8a32                	mv	s4,a2
  if (f->writable == 0 || n < 0)
    80005968:	0e064c63          	bltz	a2,80005a60 <filewrite+0x114>
    return -1;

  if (f->type == FD_PIPE) {
    8000596c:	411c                	lw	a5,0(a0)
    8000596e:	4705                	li	a4,1
    80005970:	02e78763          	beq	a5,a4,8000599e <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80005974:	470d                	li	a4,3
    80005976:	02e78863          	beq	a5,a4,800059a6 <filewrite+0x5a>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000597a:	4709                	li	a4,2
    8000597c:	0ce79563          	bne	a5,a4,80005a46 <filewrite+0xfa>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80005980:	0ec05663          	blez	a2,80005a6c <filewrite+0x120>
    80005984:	fc26                	sd	s1,56(sp)
    80005986:	f44e                	sd	s3,40(sp)
    80005988:	ec56                	sd	s5,24(sp)
    8000598a:	e45e                	sd	s7,8(sp)
    8000598c:	e062                	sd	s8,0(sp)
    int i = 0;
    8000598e:	4981                	li	s3,0
      int n1 = n - i;
      if (n1 > max)
    80005990:	6b85                	lui	s7,0x1
    80005992:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005996:	6c05                	lui	s8,0x1
    80005998:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    8000599c:	a8b5                	j	80005a18 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000599e:	6908                	ld	a0,16(a0)
    800059a0:	1fe000ef          	jal	80005b9e <pipewrite>
    800059a4:	a851                	j	80005a38 <filewrite+0xec>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800059a6:	02451783          	lh	a5,36(a0)
    800059aa:	03079693          	slli	a3,a5,0x30
    800059ae:	92c1                	srli	a3,a3,0x30
    800059b0:	4725                	li	a4,9
    800059b2:	0ad76963          	bltu	a4,a3,80005a64 <filewrite+0x118>
    800059b6:	0792                	slli	a5,a5,0x4
    800059b8:	0024b717          	auipc	a4,0x24b
    800059bc:	56870713          	addi	a4,a4,1384 # 80250f20 <devsw>
    800059c0:	97ba                	add	a5,a5,a4
    800059c2:	679c                	ld	a5,8(a5)
    800059c4:	c3d5                	beqz	a5,80005a68 <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    800059c6:	4505                	li	a0,1
    800059c8:	9782                	jalr	a5
    800059ca:	a0bd                	j	80005a38 <filewrite+0xec>
      if (n1 > max)
    800059cc:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800059d0:	8e3ff0ef          	jal	800052b2 <begin_op>
      ilock(f->ip);
    800059d4:	01893503          	ld	a0,24(s2)
    800059d8:	e93fe0ef          	jal	8000486a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800059dc:	8756                	mv	a4,s5
    800059de:	02092683          	lw	a3,32(s2)
    800059e2:	01698633          	add	a2,s3,s6
    800059e6:	4585                	li	a1,1
    800059e8:	01893503          	ld	a0,24(s2)
    800059ec:	b52ff0ef          	jal	80004d3e <writei>
    800059f0:	84aa                	mv	s1,a0
    800059f2:	00a05763          	blez	a0,80005a00 <filewrite+0xb4>
        f->off += r;
    800059f6:	02092783          	lw	a5,32(s2)
    800059fa:	9fa9                	addw	a5,a5,a0
    800059fc:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005a00:	01893503          	ld	a0,24(s2)
    80005a04:	f15fe0ef          	jal	80004918 <iunlock>
      end_op();
    80005a08:	931ff0ef          	jal	80005338 <end_op>

      if (r != n1) {
    80005a0c:	009a9e63          	bne	s5,s1,80005a28 <filewrite+0xdc>
        // error from writei
        break;
      }
      i += r;
    80005a10:	013489bb          	addw	s3,s1,s3
    while (i < n) {
    80005a14:	0149da63          	bge	s3,s4,80005a28 <filewrite+0xdc>
      int n1 = n - i;
    80005a18:	413a04bb          	subw	s1,s4,s3
      if (n1 > max)
    80005a1c:	0004879b          	sext.w	a5,s1
    80005a20:	fafbd6e3          	bge	s7,a5,800059cc <filewrite+0x80>
    80005a24:	84e2                	mv	s1,s8
    80005a26:	b75d                	j	800059cc <filewrite+0x80>
    }
    ret = (i == n ? n : -1);
    80005a28:	053a1463          	bne	s4,s3,80005a70 <filewrite+0x124>
    80005a2c:	8552                	mv	a0,s4
    80005a2e:	74e2                	ld	s1,56(sp)
    80005a30:	79a2                	ld	s3,40(sp)
    80005a32:	6ae2                	ld	s5,24(sp)
    80005a34:	6ba2                	ld	s7,8(sp)
    80005a36:	6c02                	ld	s8,0(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005a38:	60a6                	ld	ra,72(sp)
    80005a3a:	6406                	ld	s0,64(sp)
    80005a3c:	7942                	ld	s2,48(sp)
    80005a3e:	7a02                	ld	s4,32(sp)
    80005a40:	6b42                	ld	s6,16(sp)
    80005a42:	6161                	addi	sp,sp,80
    80005a44:	8082                	ret
    80005a46:	fc26                	sd	s1,56(sp)
    80005a48:	f44e                	sd	s3,40(sp)
    80005a4a:	ec56                	sd	s5,24(sp)
    80005a4c:	e45e                	sd	s7,8(sp)
    80005a4e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80005a50:	00004517          	auipc	a0,0x4
    80005a54:	e6050513          	addi	a0,a0,-416 # 800098b0 <etext+0x8b0>
    80005a58:	d99fa0ef          	jal	800007f0 <panic>
    return -1;
    80005a5c:	557d                	li	a0,-1
}
    80005a5e:	8082                	ret
    return -1;
    80005a60:	557d                	li	a0,-1
    80005a62:	bfd9                	j	80005a38 <filewrite+0xec>
      return -1;
    80005a64:	557d                	li	a0,-1
    80005a66:	bfc9                	j	80005a38 <filewrite+0xec>
    80005a68:	557d                	li	a0,-1
    80005a6a:	b7f9                	j	80005a38 <filewrite+0xec>
    ret = (i == n ? n : -1);
    80005a6c:	8532                	mv	a0,a2
    80005a6e:	b7e9                	j	80005a38 <filewrite+0xec>
    80005a70:	557d                	li	a0,-1
    80005a72:	74e2                	ld	s1,56(sp)
    80005a74:	79a2                	ld	s3,40(sp)
    80005a76:	6ae2                	ld	s5,24(sp)
    80005a78:	6ba2                	ld	s7,8(sp)
    80005a7a:	6c02                	ld	s8,0(sp)
    80005a7c:	bf75                	j	80005a38 <filewrite+0xec>

0000000080005a7e <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005a7e:	7179                	addi	sp,sp,-48
    80005a80:	f406                	sd	ra,40(sp)
    80005a82:	f022                	sd	s0,32(sp)
    80005a84:	ec26                	sd	s1,24(sp)
    80005a86:	e052                	sd	s4,0(sp)
    80005a88:	1800                	addi	s0,sp,48
    80005a8a:	84aa                	mv	s1,a0
    80005a8c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005a8e:	0005b023          	sd	zero,0(a1)
    80005a92:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005a96:	c25ff0ef          	jal	800056ba <filealloc>
    80005a9a:	e088                	sd	a0,0(s1)
    80005a9c:	c549                	beqz	a0,80005b26 <pipealloc+0xa8>
    80005a9e:	c1dff0ef          	jal	800056ba <filealloc>
    80005aa2:	00aa3023          	sd	a0,0(s4)
    80005aa6:	cd25                	beqz	a0,80005b1e <pipealloc+0xa0>
    80005aa8:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80005aaa:	894fb0ef          	jal	80000b3e <kalloc>
    80005aae:	892a                	mv	s2,a0
    80005ab0:	c12d                	beqz	a0,80005b12 <pipealloc+0x94>
    80005ab2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005ab4:	4985                	li	s3,1
    80005ab6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80005aba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80005abe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005ac2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005ac6:	00004597          	auipc	a1,0x4
    80005aca:	a7a58593          	addi	a1,a1,-1414 # 80009540 <etext+0x540>
    80005ace:	a2cfb0ef          	jal	80000cfa <initlock>
  (*f0)->type = FD_PIPE;
    80005ad2:	609c                	ld	a5,0(s1)
    80005ad4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80005ad8:	609c                	ld	a5,0(s1)
    80005ada:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005ade:	609c                	ld	a5,0(s1)
    80005ae0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005ae4:	609c                	ld	a5,0(s1)
    80005ae6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005aea:	000a3783          	ld	a5,0(s4)
    80005aee:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005af2:	000a3783          	ld	a5,0(s4)
    80005af6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005afa:	000a3783          	ld	a5,0(s4)
    80005afe:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005b02:	000a3783          	ld	a5,0(s4)
    80005b06:	0127b823          	sd	s2,16(a5)
  return 0;
    80005b0a:	4501                	li	a0,0
    80005b0c:	6942                	ld	s2,16(sp)
    80005b0e:	69a2                	ld	s3,8(sp)
    80005b10:	a01d                	j	80005b36 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80005b12:	6088                	ld	a0,0(s1)
    80005b14:	c119                	beqz	a0,80005b1a <pipealloc+0x9c>
    80005b16:	6942                	ld	s2,16(sp)
    80005b18:	a029                	j	80005b22 <pipealloc+0xa4>
    80005b1a:	6942                	ld	s2,16(sp)
    80005b1c:	a029                	j	80005b26 <pipealloc+0xa8>
    80005b1e:	6088                	ld	a0,0(s1)
    80005b20:	c10d                	beqz	a0,80005b42 <pipealloc+0xc4>
    fileclose(*f0);
    80005b22:	c3dff0ef          	jal	8000575e <fileclose>
  if (*f1)
    80005b26:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005b2a:	557d                	li	a0,-1
  if (*f1)
    80005b2c:	c789                	beqz	a5,80005b36 <pipealloc+0xb8>
    fileclose(*f1);
    80005b2e:	853e                	mv	a0,a5
    80005b30:	c2fff0ef          	jal	8000575e <fileclose>
  return -1;
    80005b34:	557d                	li	a0,-1
}
    80005b36:	70a2                	ld	ra,40(sp)
    80005b38:	7402                	ld	s0,32(sp)
    80005b3a:	64e2                	ld	s1,24(sp)
    80005b3c:	6a02                	ld	s4,0(sp)
    80005b3e:	6145                	addi	sp,sp,48
    80005b40:	8082                	ret
  return -1;
    80005b42:	557d                	li	a0,-1
    80005b44:	bfcd                	j	80005b36 <pipealloc+0xb8>

0000000080005b46 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005b46:	1101                	addi	sp,sp,-32
    80005b48:	ec06                	sd	ra,24(sp)
    80005b4a:	e822                	sd	s0,16(sp)
    80005b4c:	e426                	sd	s1,8(sp)
    80005b4e:	e04a                	sd	s2,0(sp)
    80005b50:	1000                	addi	s0,sp,32
    80005b52:	84aa                	mv	s1,a0
    80005b54:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005b56:	a1afb0ef          	jal	80000d70 <acquire>
  if (writable) {
    80005b5a:	02090763          	beqz	s2,80005b88 <pipeclose+0x42>
    pi->writeopen = 0;
    80005b5e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005b62:	21848513          	addi	a0,s1,536
    80005b66:	e35fc0ef          	jal	8000299a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80005b6a:	2204b783          	ld	a5,544(s1)
    80005b6e:	e785                	bnez	a5,80005b96 <pipeclose+0x50>
    release(&pi->lock);
    80005b70:	8526                	mv	a0,s1
    80005b72:	a8afb0ef          	jal	80000dfc <release>
    kfree((char *)pi);
    80005b76:	8526                	mv	a0,s1
    80005b78:	e71fa0ef          	jal	800009e8 <kfree>
  } else
    release(&pi->lock);
}
    80005b7c:	60e2                	ld	ra,24(sp)
    80005b7e:	6442                	ld	s0,16(sp)
    80005b80:	64a2                	ld	s1,8(sp)
    80005b82:	6902                	ld	s2,0(sp)
    80005b84:	6105                	addi	sp,sp,32
    80005b86:	8082                	ret
    pi->readopen = 0;
    80005b88:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005b8c:	21c48513          	addi	a0,s1,540
    80005b90:	e0bfc0ef          	jal	8000299a <wakeup>
    80005b94:	bfd9                	j	80005b6a <pipeclose+0x24>
    release(&pi->lock);
    80005b96:	8526                	mv	a0,s1
    80005b98:	a64fb0ef          	jal	80000dfc <release>
}
    80005b9c:	b7c5                	j	80005b7c <pipeclose+0x36>

0000000080005b9e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005b9e:	711d                	addi	sp,sp,-96
    80005ba0:	ec86                	sd	ra,88(sp)
    80005ba2:	e8a2                	sd	s0,80(sp)
    80005ba4:	e4a6                	sd	s1,72(sp)
    80005ba6:	e0ca                	sd	s2,64(sp)
    80005ba8:	fc4e                	sd	s3,56(sp)
    80005baa:	f852                	sd	s4,48(sp)
    80005bac:	f456                	sd	s5,40(sp)
    80005bae:	1080                	addi	s0,sp,96
    80005bb0:	84aa                	mv	s1,a0
    80005bb2:	8aae                	mv	s5,a1
    80005bb4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005bb6:	e14fc0ef          	jal	800021ca <myproc>
    80005bba:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005bbc:	8526                	mv	a0,s1
    80005bbe:	9b2fb0ef          	jal	80000d70 <acquire>
  while (i < n) {
    80005bc2:	0d405e63          	blez	s4,80005c9e <pipewrite+0x100>
    80005bc6:	f05a                	sd	s6,32(sp)
    80005bc8:	ec5e                	sd	s7,24(sp)
    80005bca:	e862                	sd	s8,16(sp)
  int i = 0;
    80005bcc:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80005bce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80005bd0:	21848c13          	addi	s8,s1,536
      sleep_prepare(&pi->nwrite);
    80005bd4:	21c48b93          	addi	s7,s1,540
    80005bd8:	a091                	j	80005c1c <pipewrite+0x7e>
      release(&pi->lock);
    80005bda:	8526                	mv	a0,s1
    80005bdc:	a20fb0ef          	jal	80000dfc <release>
      return -1;
    80005be0:	597d                	li	s2,-1
    80005be2:	7b02                	ld	s6,32(sp)
    80005be4:	6be2                	ld	s7,24(sp)
    80005be6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005be8:	854a                	mv	a0,s2
    80005bea:	60e6                	ld	ra,88(sp)
    80005bec:	6446                	ld	s0,80(sp)
    80005bee:	64a6                	ld	s1,72(sp)
    80005bf0:	6906                	ld	s2,64(sp)
    80005bf2:	79e2                	ld	s3,56(sp)
    80005bf4:	7a42                	ld	s4,48(sp)
    80005bf6:	7aa2                	ld	s5,40(sp)
    80005bf8:	6125                	addi	sp,sp,96
    80005bfa:	8082                	ret
      wakeup(&pi->nread);
    80005bfc:	8562                	mv	a0,s8
    80005bfe:	d9dfc0ef          	jal	8000299a <wakeup>
      sleep_prepare(&pi->nwrite);
    80005c02:	855e                	mv	a0,s7
    80005c04:	d2bfc0ef          	jal	8000292e <sleep_prepare>
      release(&pi->lock);
    80005c08:	8526                	mv	a0,s1
    80005c0a:	9f2fb0ef          	jal	80000dfc <release>
      sleep();
    80005c0e:	d5dfc0ef          	jal	8000296a <sleep>
      acquire(&pi->lock);
    80005c12:	8526                	mv	a0,s1
    80005c14:	95cfb0ef          	jal	80000d70 <acquire>
  while (i < n) {
    80005c18:	07495863          	bge	s2,s4,80005c88 <pipewrite+0xea>
    if (pi->readopen == 0 || killed(pr)) {
    80005c1c:	2204a783          	lw	a5,544(s1)
    80005c20:	dfcd                	beqz	a5,80005bda <pipewrite+0x3c>
    80005c22:	854e                	mv	a0,s3
    80005c24:	f8dfc0ef          	jal	80002bb0 <killed>
    80005c28:	f94d                	bnez	a0,80005bda <pipewrite+0x3c>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80005c2a:	2184a783          	lw	a5,536(s1)
    80005c2e:	21c4a703          	lw	a4,540(s1)
    80005c32:	2007879b          	addiw	a5,a5,512
    80005c36:	fcf703e3          	beq	a4,a5,80005bfc <pipewrite+0x5e>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80005c3a:	4705                	li	a4,1
    80005c3c:	015906b3          	add	a3,s2,s5
    80005c40:	faf40613          	addi	a2,s0,-81
    80005c44:	0889b583          	ld	a1,136(s3)
    80005c48:	0909b503          	ld	a0,144(s3)
    80005c4c:	eabfb0ef          	jal	80001af6 <copyin>
    80005c50:	03650163          	beq	a0,s6,80005c72 <pipewrite+0xd4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005c54:	21c4a783          	lw	a5,540(s1)
    80005c58:	0017871b          	addiw	a4,a5,1
    80005c5c:	20e4ae23          	sw	a4,540(s1)
    80005c60:	1ff7f793          	andi	a5,a5,511
    80005c64:	97a6                	add	a5,a5,s1
    80005c66:	faf44703          	lbu	a4,-81(s0)
    80005c6a:	00e78c23          	sb	a4,24(a5)
      i++;
    80005c6e:	2905                	addiw	s2,s2,1
    80005c70:	b765                	j	80005c18 <pipewrite+0x7a>
        if (i == 0)
    80005c72:	00090663          	beqz	s2,80005c7e <pipewrite+0xe0>
    80005c76:	7b02                	ld	s6,32(sp)
    80005c78:	6be2                	ld	s7,24(sp)
    80005c7a:	6c42                	ld	s8,16(sp)
    80005c7c:	a809                	j	80005c8e <pipewrite+0xf0>
          i = -1;
    80005c7e:	892a                	mv	s2,a0
        break;
    80005c80:	7b02                	ld	s6,32(sp)
    80005c82:	6be2                	ld	s7,24(sp)
    80005c84:	6c42                	ld	s8,16(sp)
    80005c86:	a021                	j	80005c8e <pipewrite+0xf0>
    80005c88:	7b02                	ld	s6,32(sp)
    80005c8a:	6be2                	ld	s7,24(sp)
    80005c8c:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005c8e:	21848513          	addi	a0,s1,536
    80005c92:	d09fc0ef          	jal	8000299a <wakeup>
  release(&pi->lock);
    80005c96:	8526                	mv	a0,s1
    80005c98:	964fb0ef          	jal	80000dfc <release>
  return i;
    80005c9c:	b7b1                	j	80005be8 <pipewrite+0x4a>
  int i = 0;
    80005c9e:	4901                	li	s2,0
    80005ca0:	b7fd                	j	80005c8e <pipewrite+0xf0>

0000000080005ca2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005ca2:	715d                	addi	sp,sp,-80
    80005ca4:	e486                	sd	ra,72(sp)
    80005ca6:	e0a2                	sd	s0,64(sp)
    80005ca8:	fc26                	sd	s1,56(sp)
    80005caa:	f84a                	sd	s2,48(sp)
    80005cac:	f44e                	sd	s3,40(sp)
    80005cae:	f052                	sd	s4,32(sp)
    80005cb0:	ec56                	sd	s5,24(sp)
    80005cb2:	0880                	addi	s0,sp,80
    80005cb4:	84aa                	mv	s1,a0
    80005cb6:	89ae                	mv	s3,a1
    80005cb8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80005cba:	d10fc0ef          	jal	800021ca <myproc>
    80005cbe:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80005cc0:	8526                	mv	a0,s1
    80005cc2:	8aefb0ef          	jal	80000d70 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80005cc6:	2184a703          	lw	a4,536(s1)
    80005cca:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80005cce:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80005cd2:	02f71c63          	bne	a4,a5,80005d0a <piperead+0x68>
    80005cd6:	2244a783          	lw	a5,548(s1)
    80005cda:	cf9d                	beqz	a5,80005d18 <piperead+0x76>
    if (killed(pr)) {
    80005cdc:	854a                	mv	a0,s2
    80005cde:	ed3fc0ef          	jal	80002bb0 <killed>
    80005ce2:	e515                	bnez	a0,80005d0e <piperead+0x6c>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80005ce4:	8552                	mv	a0,s4
    80005ce6:	c49fc0ef          	jal	8000292e <sleep_prepare>
    release(&pi->lock);
    80005cea:	8526                	mv	a0,s1
    80005cec:	910fb0ef          	jal	80000dfc <release>
    sleep();
    80005cf0:	c7bfc0ef          	jal	8000296a <sleep>
    acquire(&pi->lock);
    80005cf4:	8526                	mv	a0,s1
    80005cf6:	87afb0ef          	jal	80000d70 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80005cfa:	2184a703          	lw	a4,536(s1)
    80005cfe:	21c4a783          	lw	a5,540(s1)
    80005d02:	fcf70ae3          	beq	a4,a5,80005cd6 <piperead+0x34>
    80005d06:	e85a                	sd	s6,16(sp)
    80005d08:	a809                	j	80005d1a <piperead+0x78>
    80005d0a:	e85a                	sd	s6,16(sp)
    80005d0c:	a039                	j	80005d1a <piperead+0x78>
      release(&pi->lock);
    80005d0e:	8526                	mv	a0,s1
    80005d10:	8ecfb0ef          	jal	80000dfc <release>
      return -1;
    80005d14:	5a7d                	li	s4,-1
    80005d16:	a08d                	j	80005d78 <piperead+0xd6>
    80005d18:	e85a                	sd	s6,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005d1a:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80005d1c:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005d1e:	05505563          	blez	s5,80005d68 <piperead+0xc6>
    if (pi->nread == pi->nwrite)
    80005d22:	2184a783          	lw	a5,536(s1)
    80005d26:	21c4a703          	lw	a4,540(s1)
    80005d2a:	02f70f63          	beq	a4,a5,80005d68 <piperead+0xc6>
    ch = pi->data[pi->nread % PIPESIZE];
    80005d2e:	1ff7f793          	andi	a5,a5,511
    80005d32:	97a6                	add	a5,a5,s1
    80005d34:	0187c783          	lbu	a5,24(a5)
    80005d38:	faf40fa3          	sb	a5,-65(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80005d3c:	4705                	li	a4,1
    80005d3e:	fbf40693          	addi	a3,s0,-65
    80005d42:	864e                	mv	a2,s3
    80005d44:	08893583          	ld	a1,136(s2)
    80005d48:	09093503          	ld	a0,144(s2)
    80005d4c:	c5dfb0ef          	jal	800019a8 <copyout>
    80005d50:	03650e63          	beq	a0,s6,80005d8c <piperead+0xea>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80005d54:	2184a783          	lw	a5,536(s1)
    80005d58:	2785                	addiw	a5,a5,1
    80005d5a:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005d5e:	2a05                	addiw	s4,s4,1
    80005d60:	0985                	addi	s3,s3,1
    80005d62:	fd4a90e3          	bne	s5,s4,80005d22 <piperead+0x80>
    80005d66:	8a56                	mv	s4,s5
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80005d68:	21c48513          	addi	a0,s1,540
    80005d6c:	c2ffc0ef          	jal	8000299a <wakeup>
  release(&pi->lock);
    80005d70:	8526                	mv	a0,s1
    80005d72:	88afb0ef          	jal	80000dfc <release>
    80005d76:	6b42                	ld	s6,16(sp)
  return i;
}
    80005d78:	8552                	mv	a0,s4
    80005d7a:	60a6                	ld	ra,72(sp)
    80005d7c:	6406                	ld	s0,64(sp)
    80005d7e:	74e2                	ld	s1,56(sp)
    80005d80:	7942                	ld	s2,48(sp)
    80005d82:	79a2                	ld	s3,40(sp)
    80005d84:	7a02                	ld	s4,32(sp)
    80005d86:	6ae2                	ld	s5,24(sp)
    80005d88:	6161                	addi	sp,sp,80
    80005d8a:	8082                	ret
      if (i == 0)
    80005d8c:	fc0a1ee3          	bnez	s4,80005d68 <piperead+0xc6>
        i = -1;
    80005d90:	8a2a                	mv	s4,a0
    80005d92:	bfd9                	j	80005d68 <piperead+0xc6>

0000000080005d94 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80005d94:	1141                	addi	sp,sp,-16
    80005d96:	e422                	sd	s0,8(sp)
    80005d98:	0800                	addi	s0,sp,16
    80005d9a:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80005d9c:	8905                	andi	a0,a0,1
    80005d9e:	050e                	slli	a0,a0,0x3
    perm = PTE_X;
  if (flags & 0x2)
    80005da0:	8b89                	andi	a5,a5,2
    80005da2:	c399                	beqz	a5,80005da8 <flags2perm+0x14>
    perm |= PTE_W;
    80005da4:	00456513          	ori	a0,a0,4
  return perm;
}
    80005da8:	6422                	ld	s0,8(sp)
    80005daa:	0141                	addi	sp,sp,16
    80005dac:	8082                	ret

0000000080005dae <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80005dae:	df010113          	addi	sp,sp,-528
    80005db2:	20113423          	sd	ra,520(sp)
    80005db6:	20813023          	sd	s0,512(sp)
    80005dba:	ffa6                	sd	s1,504(sp)
    80005dbc:	fbca                	sd	s2,496(sp)
    80005dbe:	0c00                	addi	s0,sp,528
    80005dc0:	892a                	mv	s2,a0
    80005dc2:	dea43c23          	sd	a0,-520(s0)
    80005dc6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005dca:	c00fc0ef          	jal	800021ca <myproc>
    80005dce:	84aa                	mv	s1,a0

  begin_op();
    80005dd0:	ce2ff0ef          	jal	800052b2 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80005dd4:	854a                	mv	a0,s2
    80005dd6:	b08ff0ef          	jal	800050de <namei>
    80005dda:	c931                	beqz	a0,80005e2e <kexec+0x80>
    80005ddc:	f3d2                	sd	s4,480(sp)
    80005dde:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005de0:	a8bfe0ef          	jal	8000486a <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005de4:	04000713          	li	a4,64
    80005de8:	4681                	li	a3,0
    80005dea:	e5040613          	addi	a2,s0,-432
    80005dee:	4581                	li	a1,0
    80005df0:	8552                	mv	a0,s4
    80005df2:	e51fe0ef          	jal	80004c42 <readi>
    80005df6:	04000793          	li	a5,64
    80005dfa:	00f51a63          	bne	a0,a5,80005e0e <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80005dfe:	e5042703          	lw	a4,-432(s0)
    80005e02:	464c47b7          	lui	a5,0x464c4
    80005e06:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005e0a:	02f70663          	beq	a4,a5,80005e36 <kexec+0x88>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80005e0e:	8552                	mv	a0,s4
    80005e10:	cadfe0ef          	jal	80004abc <iunlockput>
    end_op();
    80005e14:	d24ff0ef          	jal	80005338 <end_op>
  }
  return -1;
    80005e18:	557d                	li	a0,-1
    80005e1a:	7a1e                	ld	s4,480(sp)
}
    80005e1c:	20813083          	ld	ra,520(sp)
    80005e20:	20013403          	ld	s0,512(sp)
    80005e24:	74fe                	ld	s1,504(sp)
    80005e26:	795e                	ld	s2,496(sp)
    80005e28:	21010113          	addi	sp,sp,528
    80005e2c:	8082                	ret
    end_op();
    80005e2e:	d0aff0ef          	jal	80005338 <end_op>
    return -1;
    80005e32:	557d                	li	a0,-1
    80005e34:	b7e5                	j	80005e1c <kexec+0x6e>
    80005e36:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80005e38:	8526                	mv	a0,s1
    80005e3a:	c92fc0ef          	jal	800022cc <proc_pagetable>
    80005e3e:	8b2a                	mv	s6,a0
    80005e40:	2c050c63          	beqz	a0,80006118 <kexec+0x36a>
    80005e44:	f7ce                	sd	s3,488(sp)
    80005e46:	efd6                	sd	s5,472(sp)
    80005e48:	e7de                	sd	s7,456(sp)
    80005e4a:	e3e2                	sd	s8,448(sp)
    80005e4c:	ff66                	sd	s9,440(sp)
    80005e4e:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005e50:	e7042d03          	lw	s10,-400(s0)
    80005e54:	e8845783          	lhu	a5,-376(s0)
    80005e58:	12078863          	beqz	a5,80005f88 <kexec+0x1da>
    80005e5c:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005e5e:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005e60:	4d81                	li	s11,0
    if (ph.vaddr % PGSIZE != 0)
    80005e62:	6c85                	lui	s9,0x1
    80005e64:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005e68:	def43823          	sd	a5,-528(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80005e6c:	6a85                	lui	s5,0x1
    80005e6e:	a085                	j	80005ece <kexec+0x120>
      panic("loadseg: address should exist");
    80005e70:	00004517          	auipc	a0,0x4
    80005e74:	a5050513          	addi	a0,a0,-1456 # 800098c0 <etext+0x8c0>
    80005e78:	979fa0ef          	jal	800007f0 <panic>
    if (sz - i < PGSIZE)
    80005e7c:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80005e7e:	8726                	mv	a4,s1
    80005e80:	012c06bb          	addw	a3,s8,s2
    80005e84:	4581                	li	a1,0
    80005e86:	8552                	mv	a0,s4
    80005e88:	dbbfe0ef          	jal	80004c42 <readi>
    80005e8c:	2501                	sext.w	a0,a0
    80005e8e:	24a49b63          	bne	s1,a0,800060e4 <kexec+0x336>
  for (i = 0; i < sz; i += PGSIZE) {
    80005e92:	012a893b          	addw	s2,s5,s2
    80005e96:	03397363          	bgeu	s2,s3,80005ebc <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80005e9a:	02091593          	slli	a1,s2,0x20
    80005e9e:	9181                	srli	a1,a1,0x20
    80005ea0:	95de                	add	a1,a1,s7
    80005ea2:	855a                	mv	a0,s6
    80005ea4:	aa2fb0ef          	jal	80001146 <walkaddr>
    80005ea8:	862a                	mv	a2,a0
    if (pa == 0)
    80005eaa:	d179                	beqz	a0,80005e70 <kexec+0xc2>
    if (sz - i < PGSIZE)
    80005eac:	412984bb          	subw	s1,s3,s2
    80005eb0:	0004879b          	sext.w	a5,s1
    80005eb4:	fcfcf4e3          	bgeu	s9,a5,80005e7c <kexec+0xce>
    80005eb8:	84d6                	mv	s1,s5
    80005eba:	b7c9                	j	80005e7c <kexec+0xce>
    sz = sz1;
    80005ebc:	e0843903          	ld	s2,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005ec0:	2d85                	addiw	s11,s11,1
    80005ec2:	038d0d1b          	addiw	s10,s10,56
    80005ec6:	e8845783          	lhu	a5,-376(s0)
    80005eca:	08fdd063          	bge	s11,a5,80005f4a <kexec+0x19c>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005ece:	2d01                	sext.w	s10,s10
    80005ed0:	03800713          	li	a4,56
    80005ed4:	86ea                	mv	a3,s10
    80005ed6:	e1840613          	addi	a2,s0,-488
    80005eda:	4581                	li	a1,0
    80005edc:	8552                	mv	a0,s4
    80005ede:	d65fe0ef          	jal	80004c42 <readi>
    80005ee2:	03800793          	li	a5,56
    80005ee6:	1cf51763          	bne	a0,a5,800060b4 <kexec+0x306>
    if (ph.type != ELF_PROG_LOAD)
    80005eea:	e1842783          	lw	a5,-488(s0)
    80005eee:	4705                	li	a4,1
    80005ef0:	fce798e3          	bne	a5,a4,80005ec0 <kexec+0x112>
    if (ph.memsz < ph.filesz)
    80005ef4:	e4043483          	ld	s1,-448(s0)
    80005ef8:	e3843783          	ld	a5,-456(s0)
    80005efc:	1cf4e063          	bltu	s1,a5,800060bc <kexec+0x30e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005f00:	e2843783          	ld	a5,-472(s0)
    80005f04:	94be                	add	s1,s1,a5
    80005f06:	1af4ef63          	bltu	s1,a5,800060c4 <kexec+0x316>
    if (ph.vaddr % PGSIZE != 0)
    80005f0a:	df043703          	ld	a4,-528(s0)
    80005f0e:	8ff9                	and	a5,a5,a4
    80005f10:	1a079e63          	bnez	a5,800060cc <kexec+0x31e>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80005f14:	e1c42503          	lw	a0,-484(s0)
    80005f18:	e7dff0ef          	jal	80005d94 <flags2perm>
    80005f1c:	86aa                	mv	a3,a0
    80005f1e:	8626                	mv	a2,s1
    80005f20:	85ca                	mv	a1,s2
    80005f22:	855a                	mv	a0,s6
    80005f24:	d0cfb0ef          	jal	80001430 <uvmalloc>
    80005f28:	e0a43423          	sd	a0,-504(s0)
    80005f2c:	1a050463          	beqz	a0,800060d4 <kexec+0x326>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005f30:	e2843b83          	ld	s7,-472(s0)
    80005f34:	e2042c03          	lw	s8,-480(s0)
    80005f38:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005f3c:	00098463          	beqz	s3,80005f44 <kexec+0x196>
    80005f40:	4901                	li	s2,0
    80005f42:	bfa1                	j	80005e9a <kexec+0xec>
    sz = sz1;
    80005f44:	e0843903          	ld	s2,-504(s0)
    80005f48:	bfa5                	j	80005ec0 <kexec+0x112>
    80005f4a:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80005f4c:	8552                	mv	a0,s4
    80005f4e:	b6ffe0ef          	jal	80004abc <iunlockput>
  end_op();
    80005f52:	be6ff0ef          	jal	80005338 <end_op>
  p = myproc();
    80005f56:	a74fc0ef          	jal	800021ca <myproc>
    80005f5a:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80005f5c:	08853a03          	ld	s4,136(a0)
  sz = PGROUNDUP(sz);
    80005f60:	6b85                	lui	s7,0x1
    80005f62:	1bfd                	addi	s7,s7,-1 # fff <_entry-0x7ffff001>
    80005f64:	9bca                	add	s7,s7,s2
    80005f66:	77fd                	lui	a5,0xfffff
    80005f68:	00fbfbb3          	and	s7,s7,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80005f6c:	4691                	li	a3,4
    80005f6e:	6609                	lui	a2,0x2
    80005f70:	965e                	add	a2,a2,s7
    80005f72:	85de                	mv	a1,s7
    80005f74:	855a                	mv	a0,s6
    80005f76:	cbafb0ef          	jal	80001430 <uvmalloc>
    80005f7a:	e0a43423          	sd	a0,-504(s0)
    80005f7e:	e519                	bnez	a0,80005f8c <kexec+0x1de>
  if (pagetable)
    80005f80:	e1743423          	sd	s7,-504(s0)
    80005f84:	4a01                	li	s4,0
    80005f86:	a285                	j	800060e6 <kexec+0x338>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005f88:	4901                	li	s2,0
    80005f8a:	b7c9                	j	80005f4c <kexec+0x19e>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80005f8c:	75f9                	lui	a1,0xffffe
    80005f8e:	8baa                	mv	s7,a0
    80005f90:	95aa                	add	a1,a1,a0
    80005f92:	855a                	mv	a0,s6
    80005f94:	eb6fb0ef          	jal	8000164a <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80005f98:	7afd                	lui	s5,0xfffff
    80005f9a:	9ade                	add	s5,s5,s7
  for (argc = 0; argv[argc]; argc++) {
    80005f9c:	e0043783          	ld	a5,-512(s0)
    80005fa0:	6388                	ld	a0,0(a5)
    80005fa2:	c15d                	beqz	a0,80006048 <kexec+0x29a>
    80005fa4:	e9040913          	addi	s2,s0,-368
    80005fa8:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005faa:	ffbfa0ef          	jal	80000fa4 <strlen>
    80005fae:	0015079b          	addiw	a5,a0,1
    80005fb2:	40fb87b3          	sub	a5,s7,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005fb6:	ff07fb93          	andi	s7,a5,-16
    if (sp < stackbase)
    80005fba:	135be163          	bltu	s7,s5,800060dc <kexec+0x32e>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005fbe:	e0043c83          	ld	s9,-512(s0)
    80005fc2:	000cbc03          	ld	s8,0(s9)
    80005fc6:	8562                	mv	a0,s8
    80005fc8:	fddfa0ef          	jal	80000fa4 <strlen>
    80005fcc:	0015071b          	addiw	a4,a0,1
    80005fd0:	86e2                	mv	a3,s8
    80005fd2:	865e                	mv	a2,s7
    80005fd4:	e0843583          	ld	a1,-504(s0)
    80005fd8:	855a                	mv	a0,s6
    80005fda:	9cffb0ef          	jal	800019a8 <copyout>
    80005fde:	10054163          	bltz	a0,800060e0 <kexec+0x332>
    ustack[argc] = sp;
    80005fe2:	01793023          	sd	s7,0(s2)
  for (argc = 0; argv[argc]; argc++) {
    80005fe6:	0485                	addi	s1,s1,1
    80005fe8:	008c8793          	addi	a5,s9,8
    80005fec:	e0f43023          	sd	a5,-512(s0)
    80005ff0:	008cb503          	ld	a0,8(s9)
    80005ff4:	0921                	addi	s2,s2,8
    80005ff6:	f955                	bnez	a0,80005faa <kexec+0x1fc>
  ustack[argc] = 0;
    80005ff8:	00349793          	slli	a5,s1,0x3
    80005ffc:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdaced8>
    80006000:	97a2                	add	a5,a5,s0
    80006002:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80006006:	00148713          	addi	a4,s1,1
    8000600a:	070e                	slli	a4,a4,0x3
    8000600c:	40eb8933          	sub	s2,s7,a4
  sp -= sp % 16;
    80006010:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80006014:	e0843583          	ld	a1,-504(s0)
    80006018:	8bae                	mv	s7,a1
  if (sp < stackbase)
    8000601a:	f75963e3          	bltu	s2,s5,80005f80 <kexec+0x1d2>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    8000601e:	e9040693          	addi	a3,s0,-368
    80006022:	864a                	mv	a2,s2
    80006024:	855a                	mv	a0,s6
    80006026:	983fb0ef          	jal	800019a8 <copyout>
    8000602a:	0e054963          	bltz	a0,8000611c <kexec+0x36e>
  p->trapframe->a1 = sp;
    8000602e:	0989b783          	ld	a5,152(s3)
    80006032:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80006036:	df843783          	ld	a5,-520(s0)
    8000603a:	0007c703          	lbu	a4,0(a5)
    8000603e:	c315                	beqz	a4,80006062 <kexec+0x2b4>
    80006040:	0785                	addi	a5,a5,1
    if (*s == '/')
    80006042:	02f00693          	li	a3,47
    80006046:	a809                	j	80006058 <kexec+0x2aa>
  sp = sz;
    80006048:	e0843b83          	ld	s7,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    8000604c:	4481                	li	s1,0
    8000604e:	b76d                	j	80005ff8 <kexec+0x24a>
  for (last = s = path; *s; s++)
    80006050:	0785                	addi	a5,a5,1
    80006052:	fff7c703          	lbu	a4,-1(a5)
    80006056:	c711                	beqz	a4,80006062 <kexec+0x2b4>
    if (*s == '/')
    80006058:	fed71ce3          	bne	a4,a3,80006050 <kexec+0x2a2>
      last = s + 1;
    8000605c:	def43c23          	sd	a5,-520(s0)
    80006060:	bfc5                	j	80006050 <kexec+0x2a2>
  safestrcpy(p->name, last, sizeof(p->name));
    80006062:	4641                	li	a2,16
    80006064:	df843583          	ld	a1,-520(s0)
    80006068:	51898513          	addi	a0,s3,1304
    8000606c:	f07fa0ef          	jal	80000f72 <safestrcpy>
  mmap_cleanup(p);
    80006070:	854e                	mv	a0,s3
    80006072:	e03fb0ef          	jal	80001e74 <mmap_cleanup>
  oldpagetable = p->pagetable;
    80006076:	0909b503          	ld	a0,144(s3)
  p->pagetable = pagetable;
    8000607a:	0969b823          	sd	s6,144(s3)
  p->sz = sz;
    8000607e:	e0843783          	ld	a5,-504(s0)
    80006082:	08f9b423          	sd	a5,136(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80006086:	0989b783          	ld	a5,152(s3)
    8000608a:	e6843703          	ld	a4,-408(s0)
    8000608e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80006090:	0989b783          	ld	a5,152(s3)
    80006094:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80006098:	85d2                	mv	a1,s4
    8000609a:	ab6fc0ef          	jal	80002350 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000609e:	0004851b          	sext.w	a0,s1
    800060a2:	79be                	ld	s3,488(sp)
    800060a4:	7a1e                	ld	s4,480(sp)
    800060a6:	6afe                	ld	s5,472(sp)
    800060a8:	6b5e                	ld	s6,464(sp)
    800060aa:	6bbe                	ld	s7,456(sp)
    800060ac:	6c1e                	ld	s8,448(sp)
    800060ae:	7cfa                	ld	s9,440(sp)
    800060b0:	7d5a                	ld	s10,432(sp)
    800060b2:	b3ad                	j	80005e1c <kexec+0x6e>
    800060b4:	e1243423          	sd	s2,-504(s0)
    800060b8:	7dba                	ld	s11,424(sp)
    800060ba:	a035                	j	800060e6 <kexec+0x338>
    800060bc:	e1243423          	sd	s2,-504(s0)
    800060c0:	7dba                	ld	s11,424(sp)
    800060c2:	a015                	j	800060e6 <kexec+0x338>
    800060c4:	e1243423          	sd	s2,-504(s0)
    800060c8:	7dba                	ld	s11,424(sp)
    800060ca:	a831                	j	800060e6 <kexec+0x338>
    800060cc:	e1243423          	sd	s2,-504(s0)
    800060d0:	7dba                	ld	s11,424(sp)
    800060d2:	a811                	j	800060e6 <kexec+0x338>
    800060d4:	e1243423          	sd	s2,-504(s0)
    800060d8:	7dba                	ld	s11,424(sp)
    800060da:	a031                	j	800060e6 <kexec+0x338>
  ip = 0;
    800060dc:	4a01                	li	s4,0
    800060de:	a021                	j	800060e6 <kexec+0x338>
    800060e0:	4a01                	li	s4,0
  if (pagetable)
    800060e2:	a011                	j	800060e6 <kexec+0x338>
    800060e4:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800060e6:	e0843583          	ld	a1,-504(s0)
    800060ea:	855a                	mv	a0,s6
    800060ec:	a64fc0ef          	jal	80002350 <proc_freepagetable>
  return -1;
    800060f0:	557d                	li	a0,-1
  if (ip) {
    800060f2:	000a1b63          	bnez	s4,80006108 <kexec+0x35a>
    800060f6:	79be                	ld	s3,488(sp)
    800060f8:	7a1e                	ld	s4,480(sp)
    800060fa:	6afe                	ld	s5,472(sp)
    800060fc:	6b5e                	ld	s6,464(sp)
    800060fe:	6bbe                	ld	s7,456(sp)
    80006100:	6c1e                	ld	s8,448(sp)
    80006102:	7cfa                	ld	s9,440(sp)
    80006104:	7d5a                	ld	s10,432(sp)
    80006106:	bb19                	j	80005e1c <kexec+0x6e>
    80006108:	79be                	ld	s3,488(sp)
    8000610a:	6afe                	ld	s5,472(sp)
    8000610c:	6b5e                	ld	s6,464(sp)
    8000610e:	6bbe                	ld	s7,456(sp)
    80006110:	6c1e                	ld	s8,448(sp)
    80006112:	7cfa                	ld	s9,440(sp)
    80006114:	7d5a                	ld	s10,432(sp)
    80006116:	b9e5                	j	80005e0e <kexec+0x60>
    80006118:	6b5e                	ld	s6,464(sp)
    8000611a:	b9d5                	j	80005e0e <kexec+0x60>
  sz = sz1;
    8000611c:	e0843b83          	ld	s7,-504(s0)
    80006120:	b585                	j	80005f80 <kexec+0x1d2>

0000000080006122 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006122:	7179                	addi	sp,sp,-48
    80006124:	f406                	sd	ra,40(sp)
    80006126:	f022                	sd	s0,32(sp)
    80006128:	ec26                	sd	s1,24(sp)
    8000612a:	e84a                	sd	s2,16(sp)
    8000612c:	1800                	addi	s0,sp,48
    8000612e:	892e                	mv	s2,a1
    80006130:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80006132:	fdc40593          	addi	a1,s0,-36
    80006136:	facfd0ef          	jal	800038e2 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000613a:	fdc42703          	lw	a4,-36(s0)
    8000613e:	47bd                	li	a5,15
    80006140:	02e7e963          	bltu	a5,a4,80006172 <argfd+0x50>
    80006144:	886fc0ef          	jal	800021ca <myproc>
    80006148:	fdc42703          	lw	a4,-36(s0)
    8000614c:	02270793          	addi	a5,a4,34
    80006150:	078e                	slli	a5,a5,0x3
    80006152:	953e                	add	a0,a0,a5
    80006154:	611c                	ld	a5,0(a0)
    80006156:	c385                	beqz	a5,80006176 <argfd+0x54>
    return -1;
  if (pfd)
    80006158:	00090463          	beqz	s2,80006160 <argfd+0x3e>
    *pfd = fd;
    8000615c:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80006160:	4501                	li	a0,0
  if (pf)
    80006162:	c091                	beqz	s1,80006166 <argfd+0x44>
    *pf = f;
    80006164:	e09c                	sd	a5,0(s1)
}
    80006166:	70a2                	ld	ra,40(sp)
    80006168:	7402                	ld	s0,32(sp)
    8000616a:	64e2                	ld	s1,24(sp)
    8000616c:	6942                	ld	s2,16(sp)
    8000616e:	6145                	addi	sp,sp,48
    80006170:	8082                	ret
    return -1;
    80006172:	557d                	li	a0,-1
    80006174:	bfcd                	j	80006166 <argfd+0x44>
    80006176:	557d                	li	a0,-1
    80006178:	b7fd                	j	80006166 <argfd+0x44>

000000008000617a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000617a:	1101                	addi	sp,sp,-32
    8000617c:	ec06                	sd	ra,24(sp)
    8000617e:	e822                	sd	s0,16(sp)
    80006180:	e426                	sd	s1,8(sp)
    80006182:	1000                	addi	s0,sp,32
    80006184:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80006186:	844fc0ef          	jal	800021ca <myproc>
    8000618a:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    8000618c:	11050793          	addi	a5,a0,272
    80006190:	4501                	li	a0,0
    80006192:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80006194:	6398                	ld	a4,0(a5)
    80006196:	cb19                	beqz	a4,800061ac <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80006198:	2505                	addiw	a0,a0,1
    8000619a:	07a1                	addi	a5,a5,8
    8000619c:	fed51ce3          	bne	a0,a3,80006194 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800061a0:	557d                	li	a0,-1
}
    800061a2:	60e2                	ld	ra,24(sp)
    800061a4:	6442                	ld	s0,16(sp)
    800061a6:	64a2                	ld	s1,8(sp)
    800061a8:	6105                	addi	sp,sp,32
    800061aa:	8082                	ret
      p->ofile[fd] = f;
    800061ac:	02250793          	addi	a5,a0,34
    800061b0:	078e                	slli	a5,a5,0x3
    800061b2:	963e                	add	a2,a2,a5
    800061b4:	e204                	sd	s1,0(a2)
      return fd;
    800061b6:	b7f5                	j	800061a2 <fdalloc+0x28>

00000000800061b8 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800061b8:	715d                	addi	sp,sp,-80
    800061ba:	e486                	sd	ra,72(sp)
    800061bc:	e0a2                	sd	s0,64(sp)
    800061be:	fc26                	sd	s1,56(sp)
    800061c0:	f84a                	sd	s2,48(sp)
    800061c2:	f44e                	sd	s3,40(sp)
    800061c4:	f052                	sd	s4,32(sp)
    800061c6:	ec56                	sd	s5,24(sp)
    800061c8:	0880                	addi	s0,sp,80
    800061ca:	892e                	mv	s2,a1
    800061cc:	89b2                	mv	s3,a2
    800061ce:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800061d0:	fb040593          	addi	a1,s0,-80
    800061d4:	f25fe0ef          	jal	800050f8 <nameiparent>
    800061d8:	8aaa                	mv	s5,a0
    800061da:	cd45                	beqz	a0,80006292 <create+0xda>
    return 0;

  ilock(dp);
    800061dc:	e8efe0ef          	jal	8000486a <ilock>

  if (dp->nlink == 0) {
    800061e0:	04aa9783          	lh	a5,74(s5) # fffffffffffff04a <end+0xffffffff7fdacf92>
    800061e4:	cf8d                	beqz	a5,8000621e <create+0x66>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    800061e6:	4705                	li	a4,1
    800061e8:	04e91563          	bne	s2,a4,80006232 <create+0x7a>
    800061ec:	6721                	lui	a4,0x8
    800061ee:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    800061f0:	02e78c63          	beq	a5,a4,80006228 <create+0x70>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800061f4:	4601                	li	a2,0
    800061f6:	fb040593          	addi	a1,s0,-80
    800061fa:	8556                	mv	a0,s5
    800061fc:	c6dfe0ef          	jal	80004e68 <dirlookup>
    80006200:	84aa                	mv	s1,a0
    80006202:	e951                	bnez	a0,80006296 <create+0xde>
      return ip;
    iunlockput(ip);
    return 0;
  }

  if ((ip = ialloc(dp->dev, type)) == 0) {
    80006204:	85ca                	mv	a1,s2
    80006206:	000aa503          	lw	a0,0(s5)
    8000620a:	cf0fe0ef          	jal	800046fa <ialloc>
    8000620e:	84aa                	mv	s1,a0
    80006210:	0c051e63          	bnez	a0,800062ec <create+0x134>
    iunlockput(dp);
    80006214:	8556                	mv	a0,s5
    80006216:	8a7fe0ef          	jal	80004abc <iunlockput>
    return 0;
    8000621a:	4481                	li	s1,0
    8000621c:	a0a1                	j	80006264 <create+0xac>
    iunlockput(dp);
    8000621e:	8556                	mv	a0,s5
    80006220:	89dfe0ef          	jal	80004abc <iunlockput>
    return 0;
    80006224:	4481                	li	s1,0
    80006226:	a83d                	j	80006264 <create+0xac>
    iunlockput(dp);
    80006228:	8556                	mv	a0,s5
    8000622a:	893fe0ef          	jal	80004abc <iunlockput>
    return 0;
    8000622e:	4481                	li	s1,0
    80006230:	a815                	j	80006264 <create+0xac>
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80006232:	4601                	li	a2,0
    80006234:	fb040593          	addi	a1,s0,-80
    80006238:	8556                	mv	a0,s5
    8000623a:	c2ffe0ef          	jal	80004e68 <dirlookup>
    8000623e:	84aa                	mv	s1,a0
    80006240:	c535                	beqz	a0,800062ac <create+0xf4>
    iunlockput(dp);
    80006242:	8556                	mv	a0,s5
    80006244:	879fe0ef          	jal	80004abc <iunlockput>
    ilock(ip);
    80006248:	8526                	mv	a0,s1
    8000624a:	e20fe0ef          	jal	8000486a <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000624e:	4789                	li	a5,2
    80006250:	04f91963          	bne	s2,a5,800062a2 <create+0xea>
    80006254:	0444d783          	lhu	a5,68(s1)
    80006258:	37f9                	addiw	a5,a5,-2
    8000625a:	17c2                	slli	a5,a5,0x30
    8000625c:	93c1                	srli	a5,a5,0x30
    8000625e:	4705                	li	a4,1
    80006260:	04f76163          	bltu	a4,a5,800062a2 <create+0xea>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80006264:	8526                	mv	a0,s1
    80006266:	60a6                	ld	ra,72(sp)
    80006268:	6406                	ld	s0,64(sp)
    8000626a:	74e2                	ld	s1,56(sp)
    8000626c:	7942                	ld	s2,48(sp)
    8000626e:	79a2                	ld	s3,40(sp)
    80006270:	7a02                	ld	s4,32(sp)
    80006272:	6ae2                	ld	s5,24(sp)
    80006274:	6161                	addi	sp,sp,80
    80006276:	8082                	ret
  ip->nlink = 0;
    80006278:	04049523          	sh	zero,74(s1)
  iupdate(ip);
    8000627c:	8526                	mv	a0,s1
    8000627e:	d38fe0ef          	jal	800047b6 <iupdate>
  iunlockput(ip);
    80006282:	8526                	mv	a0,s1
    80006284:	839fe0ef          	jal	80004abc <iunlockput>
  iunlockput(dp);
    80006288:	8556                	mv	a0,s5
    8000628a:	833fe0ef          	jal	80004abc <iunlockput>
  return 0;
    8000628e:	4481                	li	s1,0
    80006290:	bfd1                	j	80006264 <create+0xac>
    return 0;
    80006292:	84aa                	mv	s1,a0
    80006294:	bfc1                	j	80006264 <create+0xac>
    iunlockput(dp);
    80006296:	8556                	mv	a0,s5
    80006298:	825fe0ef          	jal	80004abc <iunlockput>
    ilock(ip);
    8000629c:	8526                	mv	a0,s1
    8000629e:	dccfe0ef          	jal	8000486a <ilock>
    iunlockput(ip);
    800062a2:	8526                	mv	a0,s1
    800062a4:	819fe0ef          	jal	80004abc <iunlockput>
    return 0;
    800062a8:	4481                	li	s1,0
    800062aa:	bf6d                	j	80006264 <create+0xac>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    800062ac:	85ca                	mv	a1,s2
    800062ae:	000aa503          	lw	a0,0(s5)
    800062b2:	c48fe0ef          	jal	800046fa <ialloc>
    800062b6:	84aa                	mv	s1,a0
    800062b8:	dd31                	beqz	a0,80006214 <create+0x5c>
  ilock(ip);
    800062ba:	8526                	mv	a0,s1
    800062bc:	daefe0ef          	jal	8000486a <ilock>
  ip->major = major;
    800062c0:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    800062c4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800062c8:	4785                	li	a5,1
    800062ca:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800062ce:	8526                	mv	a0,s1
    800062d0:	ce6fe0ef          	jal	800047b6 <iupdate>
  if (dirlink(dp, name, ip->inum) < 0)
    800062d4:	40d0                	lw	a2,4(s1)
    800062d6:	fb040593          	addi	a1,s0,-80
    800062da:	8556                	mv	a0,s5
    800062dc:	d69fe0ef          	jal	80005044 <dirlink>
    800062e0:	f8054ce3          	bltz	a0,80006278 <create+0xc0>
  iunlockput(dp);
    800062e4:	8556                	mv	a0,s5
    800062e6:	fd6fe0ef          	jal	80004abc <iunlockput>
  return ip;
    800062ea:	bfad                	j	80006264 <create+0xac>
  ilock(ip);
    800062ec:	8526                	mv	a0,s1
    800062ee:	d7cfe0ef          	jal	8000486a <ilock>
  ip->major = major;
    800062f2:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    800062f6:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800062fa:	4785                	li	a5,1
    800062fc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006300:	8526                	mv	a0,s1
    80006302:	cb4fe0ef          	jal	800047b6 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006306:	40d0                	lw	a2,4(s1)
    80006308:	00003597          	auipc	a1,0x3
    8000630c:	5e058593          	addi	a1,a1,1504 # 800098e8 <etext+0x8e8>
    80006310:	8526                	mv	a0,s1
    80006312:	d33fe0ef          	jal	80005044 <dirlink>
    80006316:	f60541e3          	bltz	a0,80006278 <create+0xc0>
    8000631a:	004aa603          	lw	a2,4(s5)
    8000631e:	00003597          	auipc	a1,0x3
    80006322:	5c258593          	addi	a1,a1,1474 # 800098e0 <etext+0x8e0>
    80006326:	8526                	mv	a0,s1
    80006328:	d1dfe0ef          	jal	80005044 <dirlink>
    8000632c:	f40546e3          	bltz	a0,80006278 <create+0xc0>
  if (dirlink(dp, name, ip->inum) < 0)
    80006330:	40d0                	lw	a2,4(s1)
    80006332:	fb040593          	addi	a1,s0,-80
    80006336:	8556                	mv	a0,s5
    80006338:	d0dfe0ef          	jal	80005044 <dirlink>
    8000633c:	f2054ee3          	bltz	a0,80006278 <create+0xc0>
    dp->nlink++; // for ".."
    80006340:	04aad783          	lhu	a5,74(s5)
    80006344:	2785                	addiw	a5,a5,1
    80006346:	04fa9523          	sh	a5,74(s5)
    iupdate(dp);
    8000634a:	8556                	mv	a0,s5
    8000634c:	c6afe0ef          	jal	800047b6 <iupdate>
    80006350:	bf51                	j	800062e4 <create+0x12c>

0000000080006352 <sys_dup>:
{
    80006352:	7179                	addi	sp,sp,-48
    80006354:	f406                	sd	ra,40(sp)
    80006356:	f022                	sd	s0,32(sp)
    80006358:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000635a:	fd840613          	addi	a2,s0,-40
    8000635e:	4581                	li	a1,0
    80006360:	4501                	li	a0,0
    80006362:	dc1ff0ef          	jal	80006122 <argfd>
    return -1;
    80006366:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80006368:	02054363          	bltz	a0,8000638e <sys_dup+0x3c>
    8000636c:	ec26                	sd	s1,24(sp)
    8000636e:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80006370:	fd843903          	ld	s2,-40(s0)
    80006374:	854a                	mv	a0,s2
    80006376:	e05ff0ef          	jal	8000617a <fdalloc>
    8000637a:	84aa                	mv	s1,a0
    return -1;
    8000637c:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    8000637e:	00054d63          	bltz	a0,80006398 <sys_dup+0x46>
  filedup(f);
    80006382:	854a                	mv	a0,s2
    80006384:	b94ff0ef          	jal	80005718 <filedup>
  return fd;
    80006388:	87a6                	mv	a5,s1
    8000638a:	64e2                	ld	s1,24(sp)
    8000638c:	6942                	ld	s2,16(sp)
}
    8000638e:	853e                	mv	a0,a5
    80006390:	70a2                	ld	ra,40(sp)
    80006392:	7402                	ld	s0,32(sp)
    80006394:	6145                	addi	sp,sp,48
    80006396:	8082                	ret
    80006398:	64e2                	ld	s1,24(sp)
    8000639a:	6942                	ld	s2,16(sp)
    8000639c:	bfcd                	j	8000638e <sys_dup+0x3c>

000000008000639e <sys_read>:
{
    8000639e:	7179                	addi	sp,sp,-48
    800063a0:	f406                	sd	ra,40(sp)
    800063a2:	f022                	sd	s0,32(sp)
    800063a4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800063a6:	fd840593          	addi	a1,s0,-40
    800063aa:	4505                	li	a0,1
    800063ac:	d52fd0ef          	jal	800038fe <argaddr>
  argint(2, &n);
    800063b0:	fe440593          	addi	a1,s0,-28
    800063b4:	4509                	li	a0,2
    800063b6:	d2cfd0ef          	jal	800038e2 <argint>
  if (argfd(0, 0, &f) < 0)
    800063ba:	fe840613          	addi	a2,s0,-24
    800063be:	4581                	li	a1,0
    800063c0:	4501                	li	a0,0
    800063c2:	d61ff0ef          	jal	80006122 <argfd>
    800063c6:	87aa                	mv	a5,a0
    return -1;
    800063c8:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800063ca:	0007ca63          	bltz	a5,800063de <sys_read+0x40>
  return fileread(f, p, n);
    800063ce:	fe442603          	lw	a2,-28(s0)
    800063d2:	fd843583          	ld	a1,-40(s0)
    800063d6:	fe843503          	ld	a0,-24(s0)
    800063da:	ca8ff0ef          	jal	80005882 <fileread>
}
    800063de:	70a2                	ld	ra,40(sp)
    800063e0:	7402                	ld	s0,32(sp)
    800063e2:	6145                	addi	sp,sp,48
    800063e4:	8082                	ret

00000000800063e6 <sys_write>:
{
    800063e6:	7179                	addi	sp,sp,-48
    800063e8:	f406                	sd	ra,40(sp)
    800063ea:	f022                	sd	s0,32(sp)
    800063ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800063ee:	fd840593          	addi	a1,s0,-40
    800063f2:	4505                	li	a0,1
    800063f4:	d0afd0ef          	jal	800038fe <argaddr>
  argint(2, &n);
    800063f8:	fe440593          	addi	a1,s0,-28
    800063fc:	4509                	li	a0,2
    800063fe:	ce4fd0ef          	jal	800038e2 <argint>
  if (argfd(0, 0, &f) < 0)
    80006402:	fe840613          	addi	a2,s0,-24
    80006406:	4581                	li	a1,0
    80006408:	4501                	li	a0,0
    8000640a:	d19ff0ef          	jal	80006122 <argfd>
    8000640e:	87aa                	mv	a5,a0
    return -1;
    80006410:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80006412:	0007ca63          	bltz	a5,80006426 <sys_write+0x40>
  return filewrite(f, p, n);
    80006416:	fe442603          	lw	a2,-28(s0)
    8000641a:	fd843583          	ld	a1,-40(s0)
    8000641e:	fe843503          	ld	a0,-24(s0)
    80006422:	d2aff0ef          	jal	8000594c <filewrite>
}
    80006426:	70a2                	ld	ra,40(sp)
    80006428:	7402                	ld	s0,32(sp)
    8000642a:	6145                	addi	sp,sp,48
    8000642c:	8082                	ret

000000008000642e <sys_close>:
{
    8000642e:	1101                	addi	sp,sp,-32
    80006430:	ec06                	sd	ra,24(sp)
    80006432:	e822                	sd	s0,16(sp)
    80006434:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80006436:	fe040613          	addi	a2,s0,-32
    8000643a:	fec40593          	addi	a1,s0,-20
    8000643e:	4501                	li	a0,0
    80006440:	ce3ff0ef          	jal	80006122 <argfd>
    return -1;
    80006444:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80006446:	02054163          	bltz	a0,80006468 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000644a:	d81fb0ef          	jal	800021ca <myproc>
    8000644e:	fec42783          	lw	a5,-20(s0)
    80006452:	02278793          	addi	a5,a5,34
    80006456:	078e                	slli	a5,a5,0x3
    80006458:	953e                	add	a0,a0,a5
    8000645a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000645e:	fe043503          	ld	a0,-32(s0)
    80006462:	afcff0ef          	jal	8000575e <fileclose>
  return 0;
    80006466:	4781                	li	a5,0
}
    80006468:	853e                	mv	a0,a5
    8000646a:	60e2                	ld	ra,24(sp)
    8000646c:	6442                	ld	s0,16(sp)
    8000646e:	6105                	addi	sp,sp,32
    80006470:	8082                	ret

0000000080006472 <sys_fstat>:
{
    80006472:	1101                	addi	sp,sp,-32
    80006474:	ec06                	sd	ra,24(sp)
    80006476:	e822                	sd	s0,16(sp)
    80006478:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000647a:	fe040593          	addi	a1,s0,-32
    8000647e:	4505                	li	a0,1
    80006480:	c7efd0ef          	jal	800038fe <argaddr>
  if (argfd(0, 0, &f) < 0)
    80006484:	fe840613          	addi	a2,s0,-24
    80006488:	4581                	li	a1,0
    8000648a:	4501                	li	a0,0
    8000648c:	c97ff0ef          	jal	80006122 <argfd>
    80006490:	87aa                	mv	a5,a0
    return -1;
    80006492:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80006494:	0007c863          	bltz	a5,800064a4 <sys_fstat+0x32>
  return filestat(f, st);
    80006498:	fe043583          	ld	a1,-32(s0)
    8000649c:	fe843503          	ld	a0,-24(s0)
    800064a0:	b80ff0ef          	jal	80005820 <filestat>
}
    800064a4:	60e2                	ld	ra,24(sp)
    800064a6:	6442                	ld	s0,16(sp)
    800064a8:	6105                	addi	sp,sp,32
    800064aa:	8082                	ret

00000000800064ac <sys_link>:
{
    800064ac:	7169                	addi	sp,sp,-304
    800064ae:	f606                	sd	ra,296(sp)
    800064b0:	f222                	sd	s0,288(sp)
    800064b2:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800064b4:	08000613          	li	a2,128
    800064b8:	ed040593          	addi	a1,s0,-304
    800064bc:	4501                	li	a0,0
    800064be:	c5cfd0ef          	jal	8000391a <argstr>
    return -1;
    800064c2:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800064c4:	10054163          	bltz	a0,800065c6 <sys_link+0x11a>
    800064c8:	08000613          	li	a2,128
    800064cc:	f5040593          	addi	a1,s0,-176
    800064d0:	4505                	li	a0,1
    800064d2:	c48fd0ef          	jal	8000391a <argstr>
    return -1;
    800064d6:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800064d8:	0e054763          	bltz	a0,800065c6 <sys_link+0x11a>
    800064dc:	ee26                	sd	s1,280(sp)
  begin_op();
    800064de:	dd5fe0ef          	jal	800052b2 <begin_op>
  if ((ip = namei(old)) == 0) {
    800064e2:	ed040513          	addi	a0,s0,-304
    800064e6:	bf9fe0ef          	jal	800050de <namei>
    800064ea:	84aa                	mv	s1,a0
    800064ec:	cd35                	beqz	a0,80006568 <sys_link+0xbc>
  ilock(ip);
    800064ee:	b7cfe0ef          	jal	8000486a <ilock>
  if (ip->type == T_DIR) {
    800064f2:	04449703          	lh	a4,68(s1)
    800064f6:	4785                	li	a5,1
    800064f8:	06f70d63          	beq	a4,a5,80006572 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    800064fc:	04a49783          	lh	a5,74(s1)
    80006500:	6721                	lui	a4,0x8
    80006502:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80006504:	06e78f63          	beq	a5,a4,80006582 <sys_link+0xd6>
    80006508:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000650a:	2785                	addiw	a5,a5,1
    8000650c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006510:	8526                	mv	a0,s1
    80006512:	aa4fe0ef          	jal	800047b6 <iupdate>
  iunlock(ip);
    80006516:	8526                	mv	a0,s1
    80006518:	c00fe0ef          	jal	80004918 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000651c:	fd040593          	addi	a1,s0,-48
    80006520:	f5040513          	addi	a0,s0,-176
    80006524:	bd5fe0ef          	jal	800050f8 <nameiparent>
    80006528:	892a                	mv	s2,a0
    8000652a:	c93d                	beqz	a0,800065a0 <sys_link+0xf4>
  ilock(dp);
    8000652c:	b3efe0ef          	jal	8000486a <ilock>
  if (dp->nlink == 0) {
    80006530:	04a91783          	lh	a5,74(s2)
    80006534:	cfb9                	beqz	a5,80006592 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80006536:	00092703          	lw	a4,0(s2)
    8000653a:	409c                	lw	a5,0(s1)
    8000653c:	04f71f63          	bne	a4,a5,8000659a <sys_link+0xee>
    80006540:	40d0                	lw	a2,4(s1)
    80006542:	fd040593          	addi	a1,s0,-48
    80006546:	854a                	mv	a0,s2
    80006548:	afdfe0ef          	jal	80005044 <dirlink>
    8000654c:	04054763          	bltz	a0,8000659a <sys_link+0xee>
  iunlockput(dp);
    80006550:	854a                	mv	a0,s2
    80006552:	d6afe0ef          	jal	80004abc <iunlockput>
  iput(ip);
    80006556:	8526                	mv	a0,s1
    80006558:	c94fe0ef          	jal	800049ec <iput>
  end_op();
    8000655c:	dddfe0ef          	jal	80005338 <end_op>
  return 0;
    80006560:	4781                	li	a5,0
    80006562:	64f2                	ld	s1,280(sp)
    80006564:	6952                	ld	s2,272(sp)
    80006566:	a085                	j	800065c6 <sys_link+0x11a>
    end_op();
    80006568:	dd1fe0ef          	jal	80005338 <end_op>
    return -1;
    8000656c:	57fd                	li	a5,-1
    8000656e:	64f2                	ld	s1,280(sp)
    80006570:	a899                	j	800065c6 <sys_link+0x11a>
    iunlockput(ip);
    80006572:	8526                	mv	a0,s1
    80006574:	d48fe0ef          	jal	80004abc <iunlockput>
    end_op();
    80006578:	dc1fe0ef          	jal	80005338 <end_op>
    return -1;
    8000657c:	57fd                	li	a5,-1
    8000657e:	64f2                	ld	s1,280(sp)
    80006580:	a099                	j	800065c6 <sys_link+0x11a>
    iunlockput(ip);
    80006582:	8526                	mv	a0,s1
    80006584:	d38fe0ef          	jal	80004abc <iunlockput>
    end_op();
    80006588:	db1fe0ef          	jal	80005338 <end_op>
    return -1;
    8000658c:	57fd                	li	a5,-1
    8000658e:	64f2                	ld	s1,280(sp)
    80006590:	a81d                	j	800065c6 <sys_link+0x11a>
    iunlockput(dp);
    80006592:	854a                	mv	a0,s2
    80006594:	d28fe0ef          	jal	80004abc <iunlockput>
    goto bad;
    80006598:	a021                	j	800065a0 <sys_link+0xf4>
    iunlockput(dp);
    8000659a:	854a                	mv	a0,s2
    8000659c:	d20fe0ef          	jal	80004abc <iunlockput>
  ilock(ip);
    800065a0:	8526                	mv	a0,s1
    800065a2:	ac8fe0ef          	jal	8000486a <ilock>
  ip->nlink--;
    800065a6:	04a4d783          	lhu	a5,74(s1)
    800065aa:	37fd                	addiw	a5,a5,-1
    800065ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800065b0:	8526                	mv	a0,s1
    800065b2:	a04fe0ef          	jal	800047b6 <iupdate>
  iunlockput(ip);
    800065b6:	8526                	mv	a0,s1
    800065b8:	d04fe0ef          	jal	80004abc <iunlockput>
  end_op();
    800065bc:	d7dfe0ef          	jal	80005338 <end_op>
  return -1;
    800065c0:	57fd                	li	a5,-1
    800065c2:	64f2                	ld	s1,280(sp)
    800065c4:	6952                	ld	s2,272(sp)
}
    800065c6:	853e                	mv	a0,a5
    800065c8:	70b2                	ld	ra,296(sp)
    800065ca:	7412                	ld	s0,288(sp)
    800065cc:	6155                	addi	sp,sp,304
    800065ce:	8082                	ret

00000000800065d0 <sys_unlink>:
{
    800065d0:	7151                	addi	sp,sp,-240
    800065d2:	f586                	sd	ra,232(sp)
    800065d4:	f1a2                	sd	s0,224(sp)
    800065d6:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800065d8:	08000613          	li	a2,128
    800065dc:	f3040593          	addi	a1,s0,-208
    800065e0:	4501                	li	a0,0
    800065e2:	b38fd0ef          	jal	8000391a <argstr>
    800065e6:	16054063          	bltz	a0,80006746 <sys_unlink+0x176>
    800065ea:	eda6                	sd	s1,216(sp)
  begin_op();
    800065ec:	cc7fe0ef          	jal	800052b2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800065f0:	fb040593          	addi	a1,s0,-80
    800065f4:	f3040513          	addi	a0,s0,-208
    800065f8:	b01fe0ef          	jal	800050f8 <nameiparent>
    800065fc:	84aa                	mv	s1,a0
    800065fe:	c945                	beqz	a0,800066ae <sys_unlink+0xde>
  ilock(dp);
    80006600:	a6afe0ef          	jal	8000486a <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006604:	00003597          	auipc	a1,0x3
    80006608:	2e458593          	addi	a1,a1,740 # 800098e8 <etext+0x8e8>
    8000660c:	fb040513          	addi	a0,s0,-80
    80006610:	843fe0ef          	jal	80004e52 <namecmp>
    80006614:	10050e63          	beqz	a0,80006730 <sys_unlink+0x160>
    80006618:	00003597          	auipc	a1,0x3
    8000661c:	2c858593          	addi	a1,a1,712 # 800098e0 <etext+0x8e0>
    80006620:	fb040513          	addi	a0,s0,-80
    80006624:	82ffe0ef          	jal	80004e52 <namecmp>
    80006628:	10050463          	beqz	a0,80006730 <sys_unlink+0x160>
    8000662c:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    8000662e:	f2c40613          	addi	a2,s0,-212
    80006632:	fb040593          	addi	a1,s0,-80
    80006636:	8526                	mv	a0,s1
    80006638:	831fe0ef          	jal	80004e68 <dirlookup>
    8000663c:	892a                	mv	s2,a0
    8000663e:	0e050863          	beqz	a0,8000672e <sys_unlink+0x15e>
  ilock(ip);
    80006642:	a28fe0ef          	jal	8000486a <ilock>
  if (ip->nlink < 1)
    80006646:	04a91783          	lh	a5,74(s2)
    8000664a:	06f05763          	blez	a5,800066b8 <sys_unlink+0xe8>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    8000664e:	04491703          	lh	a4,68(s2)
    80006652:	4785                	li	a5,1
    80006654:	06f70963          	beq	a4,a5,800066c6 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80006658:	4641                	li	a2,16
    8000665a:	4581                	li	a1,0
    8000665c:	fc040513          	addi	a0,s0,-64
    80006660:	fd4fa0ef          	jal	80000e34 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006664:	4741                	li	a4,16
    80006666:	f2c42683          	lw	a3,-212(s0)
    8000666a:	fc040613          	addi	a2,s0,-64
    8000666e:	4581                	li	a1,0
    80006670:	8526                	mv	a0,s1
    80006672:	eccfe0ef          	jal	80004d3e <writei>
    80006676:	47c1                	li	a5,16
    80006678:	08f51b63          	bne	a0,a5,8000670e <sys_unlink+0x13e>
  if (ip->type == T_DIR) {
    8000667c:	04491703          	lh	a4,68(s2)
    80006680:	4785                	li	a5,1
    80006682:	08f70d63          	beq	a4,a5,8000671c <sys_unlink+0x14c>
  iunlockput(dp);
    80006686:	8526                	mv	a0,s1
    80006688:	c34fe0ef          	jal	80004abc <iunlockput>
  ip->nlink--;
    8000668c:	04a95783          	lhu	a5,74(s2)
    80006690:	37fd                	addiw	a5,a5,-1
    80006692:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006696:	854a                	mv	a0,s2
    80006698:	91efe0ef          	jal	800047b6 <iupdate>
  iunlockput(ip);
    8000669c:	854a                	mv	a0,s2
    8000669e:	c1efe0ef          	jal	80004abc <iunlockput>
  end_op();
    800066a2:	c97fe0ef          	jal	80005338 <end_op>
  return 0;
    800066a6:	4501                	li	a0,0
    800066a8:	64ee                	ld	s1,216(sp)
    800066aa:	694e                	ld	s2,208(sp)
    800066ac:	a849                	j	8000673e <sys_unlink+0x16e>
    end_op();
    800066ae:	c8bfe0ef          	jal	80005338 <end_op>
    return -1;
    800066b2:	557d                	li	a0,-1
    800066b4:	64ee                	ld	s1,216(sp)
    800066b6:	a061                	j	8000673e <sys_unlink+0x16e>
    800066b8:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800066ba:	00003517          	auipc	a0,0x3
    800066be:	23650513          	addi	a0,a0,566 # 800098f0 <etext+0x8f0>
    800066c2:	92efa0ef          	jal	800007f0 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800066c6:	04c92703          	lw	a4,76(s2)
    800066ca:	02000793          	li	a5,32
    800066ce:	f8e7f5e3          	bgeu	a5,a4,80006658 <sys_unlink+0x88>
    800066d2:	e5ce                	sd	s3,200(sp)
    800066d4:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800066d8:	4741                	li	a4,16
    800066da:	86ce                	mv	a3,s3
    800066dc:	f1840613          	addi	a2,s0,-232
    800066e0:	4581                	li	a1,0
    800066e2:	854a                	mv	a0,s2
    800066e4:	d5efe0ef          	jal	80004c42 <readi>
    800066e8:	47c1                	li	a5,16
    800066ea:	00f51c63          	bne	a0,a5,80006702 <sys_unlink+0x132>
    if (de.inum != 0)
    800066ee:	f1845783          	lhu	a5,-232(s0)
    800066f2:	efa1                	bnez	a5,8000674a <sys_unlink+0x17a>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800066f4:	29c1                	addiw	s3,s3,16
    800066f6:	04c92783          	lw	a5,76(s2)
    800066fa:	fcf9efe3          	bltu	s3,a5,800066d8 <sys_unlink+0x108>
    800066fe:	69ae                	ld	s3,200(sp)
    80006700:	bfa1                	j	80006658 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80006702:	00003517          	auipc	a0,0x3
    80006706:	20650513          	addi	a0,a0,518 # 80009908 <etext+0x908>
    8000670a:	8e6fa0ef          	jal	800007f0 <panic>
    8000670e:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80006710:	00003517          	auipc	a0,0x3
    80006714:	21050513          	addi	a0,a0,528 # 80009920 <etext+0x920>
    80006718:	8d8fa0ef          	jal	800007f0 <panic>
    dp->nlink--;
    8000671c:	04a4d783          	lhu	a5,74(s1)
    80006720:	37fd                	addiw	a5,a5,-1
    80006722:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006726:	8526                	mv	a0,s1
    80006728:	88efe0ef          	jal	800047b6 <iupdate>
    8000672c:	bfa9                	j	80006686 <sys_unlink+0xb6>
    8000672e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80006730:	8526                	mv	a0,s1
    80006732:	b8afe0ef          	jal	80004abc <iunlockput>
  end_op();
    80006736:	c03fe0ef          	jal	80005338 <end_op>
  return -1;
    8000673a:	557d                	li	a0,-1
    8000673c:	64ee                	ld	s1,216(sp)
}
    8000673e:	70ae                	ld	ra,232(sp)
    80006740:	740e                	ld	s0,224(sp)
    80006742:	616d                	addi	sp,sp,240
    80006744:	8082                	ret
    return -1;
    80006746:	557d                	li	a0,-1
    80006748:	bfdd                	j	8000673e <sys_unlink+0x16e>
    iunlockput(ip);
    8000674a:	854a                	mv	a0,s2
    8000674c:	b70fe0ef          	jal	80004abc <iunlockput>
    goto bad;
    80006750:	694e                	ld	s2,208(sp)
    80006752:	69ae                	ld	s3,200(sp)
    80006754:	bff1                	j	80006730 <sys_unlink+0x160>

0000000080006756 <sys_open>:

uint64
sys_open(void)
{
    80006756:	7131                	addi	sp,sp,-192
    80006758:	fd06                	sd	ra,184(sp)
    8000675a:	f922                	sd	s0,176(sp)
    8000675c:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000675e:	f4c40593          	addi	a1,s0,-180
    80006762:	4505                	li	a0,1
    80006764:	97efd0ef          	jal	800038e2 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80006768:	08000613          	li	a2,128
    8000676c:	f5040593          	addi	a1,s0,-176
    80006770:	4501                	li	a0,0
    80006772:	9a8fd0ef          	jal	8000391a <argstr>
    80006776:	87aa                	mv	a5,a0
    return -1;
    80006778:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000677a:	0a07c263          	bltz	a5,8000681e <sys_open+0xc8>
    8000677e:	f526                	sd	s1,168(sp)

  begin_op();
    80006780:	b33fe0ef          	jal	800052b2 <begin_op>

  if (omode & O_CREATE) {
    80006784:	f4c42783          	lw	a5,-180(s0)
    80006788:	2007f793          	andi	a5,a5,512
    8000678c:	c3d5                	beqz	a5,80006830 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000678e:	4681                	li	a3,0
    80006790:	4601                	li	a2,0
    80006792:	4589                	li	a1,2
    80006794:	f5040513          	addi	a0,s0,-176
    80006798:	a21ff0ef          	jal	800061b8 <create>
    8000679c:	84aa                	mv	s1,a0
    if (ip == 0) {
    8000679e:	c541                	beqz	a0,80006826 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800067a0:	04449703          	lh	a4,68(s1)
    800067a4:	478d                	li	a5,3
    800067a6:	00f71763          	bne	a4,a5,800067b4 <sys_open+0x5e>
    800067aa:	0464d703          	lhu	a4,70(s1)
    800067ae:	47a5                	li	a5,9
    800067b0:	0ae7ed63          	bltu	a5,a4,8000686a <sys_open+0x114>
    800067b4:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    800067b6:	f05fe0ef          	jal	800056ba <filealloc>
    800067ba:	892a                	mv	s2,a0
    800067bc:	c179                	beqz	a0,80006882 <sys_open+0x12c>
    800067be:	ed4e                	sd	s3,152(sp)
    800067c0:	9bbff0ef          	jal	8000617a <fdalloc>
    800067c4:	89aa                	mv	s3,a0
    800067c6:	0a054a63          	bltz	a0,8000687a <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    800067ca:	04449703          	lh	a4,68(s1)
    800067ce:	478d                	li	a5,3
    800067d0:	0cf70263          	beq	a4,a5,80006894 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800067d4:	4789                	li	a5,2
    800067d6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800067da:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800067de:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800067e2:	f4c42783          	lw	a5,-180(s0)
    800067e6:	0017c713          	xori	a4,a5,1
    800067ea:	8b05                	andi	a4,a4,1
    800067ec:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800067f0:	0037f713          	andi	a4,a5,3
    800067f4:	00e03733          	snez	a4,a4
    800067f8:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800067fc:	4007f793          	andi	a5,a5,1024
    80006800:	c791                	beqz	a5,8000680c <sys_open+0xb6>
    80006802:	04449703          	lh	a4,68(s1)
    80006806:	4789                	li	a5,2
    80006808:	08f70d63          	beq	a4,a5,800068a2 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000680c:	8526                	mv	a0,s1
    8000680e:	90afe0ef          	jal	80004918 <iunlock>
  end_op();
    80006812:	b27fe0ef          	jal	80005338 <end_op>

  return fd;
    80006816:	854e                	mv	a0,s3
    80006818:	74aa                	ld	s1,168(sp)
    8000681a:	790a                	ld	s2,160(sp)
    8000681c:	69ea                	ld	s3,152(sp)
}
    8000681e:	70ea                	ld	ra,184(sp)
    80006820:	744a                	ld	s0,176(sp)
    80006822:	6129                	addi	sp,sp,192
    80006824:	8082                	ret
      end_op();
    80006826:	b13fe0ef          	jal	80005338 <end_op>
      return -1;
    8000682a:	557d                	li	a0,-1
    8000682c:	74aa                	ld	s1,168(sp)
    8000682e:	bfc5                	j	8000681e <sys_open+0xc8>
    if ((ip = namei(path)) == 0) {
    80006830:	f5040513          	addi	a0,s0,-176
    80006834:	8abfe0ef          	jal	800050de <namei>
    80006838:	84aa                	mv	s1,a0
    8000683a:	c11d                	beqz	a0,80006860 <sys_open+0x10a>
    ilock(ip);
    8000683c:	82efe0ef          	jal	8000486a <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80006840:	04449703          	lh	a4,68(s1)
    80006844:	4785                	li	a5,1
    80006846:	f4f71de3          	bne	a4,a5,800067a0 <sys_open+0x4a>
    8000684a:	f4c42783          	lw	a5,-180(s0)
    8000684e:	d3bd                	beqz	a5,800067b4 <sys_open+0x5e>
      iunlockput(ip);
    80006850:	8526                	mv	a0,s1
    80006852:	a6afe0ef          	jal	80004abc <iunlockput>
      end_op();
    80006856:	ae3fe0ef          	jal	80005338 <end_op>
      return -1;
    8000685a:	557d                	li	a0,-1
    8000685c:	74aa                	ld	s1,168(sp)
    8000685e:	b7c1                	j	8000681e <sys_open+0xc8>
      end_op();
    80006860:	ad9fe0ef          	jal	80005338 <end_op>
      return -1;
    80006864:	557d                	li	a0,-1
    80006866:	74aa                	ld	s1,168(sp)
    80006868:	bf5d                	j	8000681e <sys_open+0xc8>
    iunlockput(ip);
    8000686a:	8526                	mv	a0,s1
    8000686c:	a50fe0ef          	jal	80004abc <iunlockput>
    end_op();
    80006870:	ac9fe0ef          	jal	80005338 <end_op>
    return -1;
    80006874:	557d                	li	a0,-1
    80006876:	74aa                	ld	s1,168(sp)
    80006878:	b75d                	j	8000681e <sys_open+0xc8>
      fileclose(f);
    8000687a:	854a                	mv	a0,s2
    8000687c:	ee3fe0ef          	jal	8000575e <fileclose>
    80006880:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006882:	8526                	mv	a0,s1
    80006884:	a38fe0ef          	jal	80004abc <iunlockput>
    end_op();
    80006888:	ab1fe0ef          	jal	80005338 <end_op>
    return -1;
    8000688c:	557d                	li	a0,-1
    8000688e:	74aa                	ld	s1,168(sp)
    80006890:	790a                	ld	s2,160(sp)
    80006892:	b771                	j	8000681e <sys_open+0xc8>
    f->type = FD_DEVICE;
    80006894:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80006898:	04649783          	lh	a5,70(s1)
    8000689c:	02f91223          	sh	a5,36(s2)
    800068a0:	bf3d                	j	800067de <sys_open+0x88>
    itrunc(ip);
    800068a2:	8526                	mv	a0,s1
    800068a4:	8b4fe0ef          	jal	80004958 <itrunc>
    800068a8:	b795                	j	8000680c <sys_open+0xb6>

00000000800068aa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800068aa:	7175                	addi	sp,sp,-144
    800068ac:	e506                	sd	ra,136(sp)
    800068ae:	e122                	sd	s0,128(sp)
    800068b0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800068b2:	a01fe0ef          	jal	800052b2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    800068b6:	08000613          	li	a2,128
    800068ba:	f7040593          	addi	a1,s0,-144
    800068be:	4501                	li	a0,0
    800068c0:	85afd0ef          	jal	8000391a <argstr>
    800068c4:	02054363          	bltz	a0,800068ea <sys_mkdir+0x40>
    800068c8:	4681                	li	a3,0
    800068ca:	4601                	li	a2,0
    800068cc:	4585                	li	a1,1
    800068ce:	f7040513          	addi	a0,s0,-144
    800068d2:	8e7ff0ef          	jal	800061b8 <create>
    800068d6:	c911                	beqz	a0,800068ea <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800068d8:	9e4fe0ef          	jal	80004abc <iunlockput>
  end_op();
    800068dc:	a5dfe0ef          	jal	80005338 <end_op>
  return 0;
    800068e0:	4501                	li	a0,0
}
    800068e2:	60aa                	ld	ra,136(sp)
    800068e4:	640a                	ld	s0,128(sp)
    800068e6:	6149                	addi	sp,sp,144
    800068e8:	8082                	ret
    end_op();
    800068ea:	a4ffe0ef          	jal	80005338 <end_op>
    return -1;
    800068ee:	557d                	li	a0,-1
    800068f0:	bfcd                	j	800068e2 <sys_mkdir+0x38>

00000000800068f2 <sys_mknod>:

uint64
sys_mknod(void)
{
    800068f2:	7135                	addi	sp,sp,-160
    800068f4:	ed06                	sd	ra,152(sp)
    800068f6:	e922                	sd	s0,144(sp)
    800068f8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800068fa:	9b9fe0ef          	jal	800052b2 <begin_op>
  argint(1, &major);
    800068fe:	f6c40593          	addi	a1,s0,-148
    80006902:	4505                	li	a0,1
    80006904:	fdffc0ef          	jal	800038e2 <argint>
  argint(2, &minor);
    80006908:	f6840593          	addi	a1,s0,-152
    8000690c:	4509                	li	a0,2
    8000690e:	fd5fc0ef          	jal	800038e2 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006912:	08000613          	li	a2,128
    80006916:	f7040593          	addi	a1,s0,-144
    8000691a:	4501                	li	a0,0
    8000691c:	ffffc0ef          	jal	8000391a <argstr>
    80006920:	02054563          	bltz	a0,8000694a <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80006924:	f6841683          	lh	a3,-152(s0)
    80006928:	f6c41603          	lh	a2,-148(s0)
    8000692c:	458d                	li	a1,3
    8000692e:	f7040513          	addi	a0,s0,-144
    80006932:	887ff0ef          	jal	800061b8 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006936:	c911                	beqz	a0,8000694a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006938:	984fe0ef          	jal	80004abc <iunlockput>
  end_op();
    8000693c:	9fdfe0ef          	jal	80005338 <end_op>
  return 0;
    80006940:	4501                	li	a0,0
}
    80006942:	60ea                	ld	ra,152(sp)
    80006944:	644a                	ld	s0,144(sp)
    80006946:	610d                	addi	sp,sp,160
    80006948:	8082                	ret
    end_op();
    8000694a:	9effe0ef          	jal	80005338 <end_op>
    return -1;
    8000694e:	557d                	li	a0,-1
    80006950:	bfcd                	j	80006942 <sys_mknod+0x50>

0000000080006952 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006952:	7135                	addi	sp,sp,-160
    80006954:	ed06                	sd	ra,152(sp)
    80006956:	e922                	sd	s0,144(sp)
    80006958:	e14a                	sd	s2,128(sp)
    8000695a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000695c:	86ffb0ef          	jal	800021ca <myproc>
    80006960:	892a                	mv	s2,a0

  begin_op();
    80006962:	951fe0ef          	jal	800052b2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80006966:	08000613          	li	a2,128
    8000696a:	f6040593          	addi	a1,s0,-160
    8000696e:	4501                	li	a0,0
    80006970:	fabfc0ef          	jal	8000391a <argstr>
    80006974:	04054363          	bltz	a0,800069ba <sys_chdir+0x68>
    80006978:	e526                	sd	s1,136(sp)
    8000697a:	f6040513          	addi	a0,s0,-160
    8000697e:	f60fe0ef          	jal	800050de <namei>
    80006982:	84aa                	mv	s1,a0
    80006984:	c915                	beqz	a0,800069b8 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80006986:	ee5fd0ef          	jal	8000486a <ilock>
  if (ip->type != T_DIR) {
    8000698a:	04449703          	lh	a4,68(s1)
    8000698e:	4785                	li	a5,1
    80006990:	02f71963          	bne	a4,a5,800069c2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006994:	8526                	mv	a0,s1
    80006996:	f83fd0ef          	jal	80004918 <iunlock>
  iput(p->cwd);
    8000699a:	19093503          	ld	a0,400(s2)
    8000699e:	84efe0ef          	jal	800049ec <iput>
  end_op();
    800069a2:	997fe0ef          	jal	80005338 <end_op>
  p->cwd = ip;
    800069a6:	18993823          	sd	s1,400(s2)
  return 0;
    800069aa:	4501                	li	a0,0
    800069ac:	64aa                	ld	s1,136(sp)
}
    800069ae:	60ea                	ld	ra,152(sp)
    800069b0:	644a                	ld	s0,144(sp)
    800069b2:	690a                	ld	s2,128(sp)
    800069b4:	610d                	addi	sp,sp,160
    800069b6:	8082                	ret
    800069b8:	64aa                	ld	s1,136(sp)
    end_op();
    800069ba:	97ffe0ef          	jal	80005338 <end_op>
    return -1;
    800069be:	557d                	li	a0,-1
    800069c0:	b7fd                	j	800069ae <sys_chdir+0x5c>
    iunlockput(ip);
    800069c2:	8526                	mv	a0,s1
    800069c4:	8f8fe0ef          	jal	80004abc <iunlockput>
    end_op();
    800069c8:	971fe0ef          	jal	80005338 <end_op>
    return -1;
    800069cc:	557d                	li	a0,-1
    800069ce:	64aa                	ld	s1,136(sp)
    800069d0:	bff9                	j	800069ae <sys_chdir+0x5c>

00000000800069d2 <sys_exec>:

uint64
sys_exec(void)
{
    800069d2:	7121                	addi	sp,sp,-448
    800069d4:	ff06                	sd	ra,440(sp)
    800069d6:	fb22                	sd	s0,432(sp)
    800069d8:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800069da:	e4840593          	addi	a1,s0,-440
    800069de:	4505                	li	a0,1
    800069e0:	f1ffc0ef          	jal	800038fe <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800069e4:	08000613          	li	a2,128
    800069e8:	f5040593          	addi	a1,s0,-176
    800069ec:	4501                	li	a0,0
    800069ee:	f2dfc0ef          	jal	8000391a <argstr>
    800069f2:	87aa                	mv	a5,a0
    return -1;
    800069f4:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    800069f6:	0c07c463          	bltz	a5,80006abe <sys_exec+0xec>
    800069fa:	f726                	sd	s1,424(sp)
    800069fc:	f34a                	sd	s2,416(sp)
    800069fe:	ef4e                	sd	s3,408(sp)
    80006a00:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006a02:	10000613          	li	a2,256
    80006a06:	4581                	li	a1,0
    80006a08:	e5040513          	addi	a0,s0,-432
    80006a0c:	c28fa0ef          	jal	80000e34 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80006a10:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80006a14:	89a6                	mv	s3,s1
    80006a16:	4901                	li	s2,0
    if (i >= NELEM(argv)) {
    80006a18:	02000a13          	li	s4,32
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80006a1c:	00391513          	slli	a0,s2,0x3
    80006a20:	e4040593          	addi	a1,s0,-448
    80006a24:	e4843783          	ld	a5,-440(s0)
    80006a28:	953e                	add	a0,a0,a5
    80006a2a:	e2dfc0ef          	jal	80003856 <fetchaddr>
    80006a2e:	02054663          	bltz	a0,80006a5a <sys_exec+0x88>
      goto bad;
    }
    if (uarg == 0) {
    80006a32:	e4043783          	ld	a5,-448(s0)
    80006a36:	c3a9                	beqz	a5,80006a78 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80006a38:	906fa0ef          	jal	80000b3e <kalloc>
    80006a3c:	85aa                	mv	a1,a0
    80006a3e:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80006a42:	cd01                	beqz	a0,80006a5a <sys_exec+0x88>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006a44:	6605                	lui	a2,0x1
    80006a46:	e4043503          	ld	a0,-448(s0)
    80006a4a:	e57fc0ef          	jal	800038a0 <fetchstr>
    80006a4e:	00054663          	bltz	a0,80006a5a <sys_exec+0x88>
    if (i >= NELEM(argv)) {
    80006a52:	0905                	addi	s2,s2,1
    80006a54:	09a1                	addi	s3,s3,8
    80006a56:	fd4913e3          	bne	s2,s4,80006a1c <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a5a:	f5040913          	addi	s2,s0,-176
    80006a5e:	6088                	ld	a0,0(s1)
    80006a60:	c931                	beqz	a0,80006ab4 <sys_exec+0xe2>
    kfree(argv[i]);
    80006a62:	f87f90ef          	jal	800009e8 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a66:	04a1                	addi	s1,s1,8
    80006a68:	ff249be3          	bne	s1,s2,80006a5e <sys_exec+0x8c>
  return -1;
    80006a6c:	557d                	li	a0,-1
    80006a6e:	74ba                	ld	s1,424(sp)
    80006a70:	791a                	ld	s2,416(sp)
    80006a72:	69fa                	ld	s3,408(sp)
    80006a74:	6a5a                	ld	s4,400(sp)
    80006a76:	a0a1                	j	80006abe <sys_exec+0xec>
      argv[i] = 0;
    80006a78:	0009079b          	sext.w	a5,s2
    80006a7c:	078e                	slli	a5,a5,0x3
    80006a7e:	fd078793          	addi	a5,a5,-48
    80006a82:	97a2                	add	a5,a5,s0
    80006a84:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    80006a88:	e5040593          	addi	a1,s0,-432
    80006a8c:	f5040513          	addi	a0,s0,-176
    80006a90:	b1eff0ef          	jal	80005dae <kexec>
    80006a94:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006a96:	f5040993          	addi	s3,s0,-176
    80006a9a:	6088                	ld	a0,0(s1)
    80006a9c:	c511                	beqz	a0,80006aa8 <sys_exec+0xd6>
    kfree(argv[i]);
    80006a9e:	f4bf90ef          	jal	800009e8 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006aa2:	04a1                	addi	s1,s1,8
    80006aa4:	ff349be3          	bne	s1,s3,80006a9a <sys_exec+0xc8>
  return ret;
    80006aa8:	854a                	mv	a0,s2
    80006aaa:	74ba                	ld	s1,424(sp)
    80006aac:	791a                	ld	s2,416(sp)
    80006aae:	69fa                	ld	s3,408(sp)
    80006ab0:	6a5a                	ld	s4,400(sp)
    80006ab2:	a031                	j	80006abe <sys_exec+0xec>
  return -1;
    80006ab4:	557d                	li	a0,-1
    80006ab6:	74ba                	ld	s1,424(sp)
    80006ab8:	791a                	ld	s2,416(sp)
    80006aba:	69fa                	ld	s3,408(sp)
    80006abc:	6a5a                	ld	s4,400(sp)
}
    80006abe:	70fa                	ld	ra,440(sp)
    80006ac0:	745a                	ld	s0,432(sp)
    80006ac2:	6139                	addi	sp,sp,448
    80006ac4:	8082                	ret

0000000080006ac6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006ac6:	7139                	addi	sp,sp,-64
    80006ac8:	fc06                	sd	ra,56(sp)
    80006aca:	f822                	sd	s0,48(sp)
    80006acc:	f426                	sd	s1,40(sp)
    80006ace:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006ad0:	efafb0ef          	jal	800021ca <myproc>
    80006ad4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006ad6:	fd840593          	addi	a1,s0,-40
    80006ada:	4501                	li	a0,0
    80006adc:	e23fc0ef          	jal	800038fe <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80006ae0:	fc840593          	addi	a1,s0,-56
    80006ae4:	fd040513          	addi	a0,s0,-48
    80006ae8:	f97fe0ef          	jal	80005a7e <pipealloc>
    return -1;
    80006aec:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80006aee:	0a054963          	bltz	a0,80006ba0 <sys_pipe+0xda>
  fd0 = -1;
    80006af2:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80006af6:	fd043503          	ld	a0,-48(s0)
    80006afa:	e80ff0ef          	jal	8000617a <fdalloc>
    80006afe:	fca42223          	sw	a0,-60(s0)
    80006b02:	08054663          	bltz	a0,80006b8e <sys_pipe+0xc8>
    80006b06:	fc843503          	ld	a0,-56(s0)
    80006b0a:	e70ff0ef          	jal	8000617a <fdalloc>
    80006b0e:	fca42023          	sw	a0,-64(s0)
    80006b12:	06054463          	bltz	a0,80006b7a <sys_pipe+0xb4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006b16:	4711                	li	a4,4
    80006b18:	fc440693          	addi	a3,s0,-60
    80006b1c:	fd843603          	ld	a2,-40(s0)
    80006b20:	64cc                	ld	a1,136(s1)
    80006b22:	68c8                	ld	a0,144(s1)
    80006b24:	e85fa0ef          	jal	800019a8 <copyout>
    80006b28:	00054f63          	bltz	a0,80006b46 <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80006b2c:	4711                	li	a4,4
    80006b2e:	fc040693          	addi	a3,s0,-64
    80006b32:	fd843603          	ld	a2,-40(s0)
    80006b36:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006b38:	64cc                	ld	a1,136(s1)
    80006b3a:	68c8                	ld	a0,144(s1)
    80006b3c:	e6dfa0ef          	jal	800019a8 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006b40:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80006b42:	04055f63          	bgez	a0,80006ba0 <sys_pipe+0xda>
    p->ofile[fd0] = 0;
    80006b46:	fc442783          	lw	a5,-60(s0)
    80006b4a:	02278793          	addi	a5,a5,34
    80006b4e:	078e                	slli	a5,a5,0x3
    80006b50:	97a6                	add	a5,a5,s1
    80006b52:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006b56:	fc042783          	lw	a5,-64(s0)
    80006b5a:	02278793          	addi	a5,a5,34
    80006b5e:	078e                	slli	a5,a5,0x3
    80006b60:	94be                	add	s1,s1,a5
    80006b62:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006b66:	fd043503          	ld	a0,-48(s0)
    80006b6a:	bf5fe0ef          	jal	8000575e <fileclose>
    fileclose(wf);
    80006b6e:	fc843503          	ld	a0,-56(s0)
    80006b72:	bedfe0ef          	jal	8000575e <fileclose>
    return -1;
    80006b76:	57fd                	li	a5,-1
    80006b78:	a025                	j	80006ba0 <sys_pipe+0xda>
    if (fd0 >= 0)
    80006b7a:	fc442783          	lw	a5,-60(s0)
    80006b7e:	0007c863          	bltz	a5,80006b8e <sys_pipe+0xc8>
      p->ofile[fd0] = 0;
    80006b82:	02278793          	addi	a5,a5,34
    80006b86:	078e                	slli	a5,a5,0x3
    80006b88:	97a6                	add	a5,a5,s1
    80006b8a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006b8e:	fd043503          	ld	a0,-48(s0)
    80006b92:	bcdfe0ef          	jal	8000575e <fileclose>
    fileclose(wf);
    80006b96:	fc843503          	ld	a0,-56(s0)
    80006b9a:	bc5fe0ef          	jal	8000575e <fileclose>
    return -1;
    80006b9e:	57fd                	li	a5,-1
}
    80006ba0:	853e                	mv	a0,a5
    80006ba2:	70e2                	ld	ra,56(sp)
    80006ba4:	7442                	ld	s0,48(sp)
    80006ba6:	74a2                	ld	s1,40(sp)
    80006ba8:	6121                	addi	sp,sp,64
    80006baa:	8082                	ret
    80006bac:	0000                	unimp
	...

0000000080006bb0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80006bb0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80006bb2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80006bb4:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80006bb6:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80006bb8:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80006bba:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80006bbc:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80006bbe:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80006bc0:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80006bc2:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80006bc4:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80006bc6:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80006bc8:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80006bca:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80006bcc:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80006bce:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80006bd0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80006bd2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80006bd4:	b7ffc0ef          	jal	80003752 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80006bd8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80006bda:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80006bdc:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80006bde:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80006be0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80006be2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80006be4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80006be6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80006be8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80006bea:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80006bec:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80006bee:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80006bf0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80006bf2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80006bf4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80006bf6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80006bf8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80006bfa:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80006bfc:	10200073          	sret
	...

0000000080006c0e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80006c0e:	1141                	addi	sp,sp,-16
    80006c10:	e422                	sd	s0,8(sp)
    80006c12:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80006c14:	0c0007b7          	lui	a5,0xc000
    80006c18:	4705                	li	a4,1
    80006c1a:	d798                	sw	a4,40(a5)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80006c1c:	0c0007b7          	lui	a5,0xc000
    80006c20:	c3d8                	sw	a4,4(a5)
}
    80006c22:	6422                	ld	s0,8(sp)
    80006c24:	0141                	addi	sp,sp,16
    80006c26:	8082                	ret

0000000080006c28 <plicinithart>:

void
plicinithart(void)
{
    80006c28:	1141                	addi	sp,sp,-16
    80006c2a:	e406                	sd	ra,8(sp)
    80006c2c:	e022                	sd	s0,0(sp)
    80006c2e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006c30:	d6efb0ef          	jal	8000219e <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006c34:	0085171b          	slliw	a4,a0,0x8
    80006c38:	0c0027b7          	lui	a5,0xc002
    80006c3c:	97ba                	add	a5,a5,a4
    80006c3e:	40200713          	li	a4,1026
    80006c42:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80006c46:	00d5151b          	slliw	a0,a0,0xd
    80006c4a:	0c2017b7          	lui	a5,0xc201
    80006c4e:	97aa                	add	a5,a5,a0
    80006c50:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006c54:	60a2                	ld	ra,8(sp)
    80006c56:	6402                	ld	s0,0(sp)
    80006c58:	0141                	addi	sp,sp,16
    80006c5a:	8082                	ret

0000000080006c5c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006c5c:	1141                	addi	sp,sp,-16
    80006c5e:	e406                	sd	ra,8(sp)
    80006c60:	e022                	sd	s0,0(sp)
    80006c62:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006c64:	d3afb0ef          	jal	8000219e <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80006c68:	00d5151b          	slliw	a0,a0,0xd
    80006c6c:	0c2017b7          	lui	a5,0xc201
    80006c70:	97aa                	add	a5,a5,a0
  return irq;
}
    80006c72:	43c8                	lw	a0,4(a5)
    80006c74:	60a2                	ld	ra,8(sp)
    80006c76:	6402                	ld	s0,0(sp)
    80006c78:	0141                	addi	sp,sp,16
    80006c7a:	8082                	ret

0000000080006c7c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006c7c:	1101                	addi	sp,sp,-32
    80006c7e:	ec06                	sd	ra,24(sp)
    80006c80:	e822                	sd	s0,16(sp)
    80006c82:	e426                	sd	s1,8(sp)
    80006c84:	1000                	addi	s0,sp,32
    80006c86:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006c88:	d16fb0ef          	jal	8000219e <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    80006c8c:	00d5151b          	slliw	a0,a0,0xd
    80006c90:	0c2017b7          	lui	a5,0xc201
    80006c94:	97aa                	add	a5,a5,a0
    80006c96:	c3c4                	sw	s1,4(a5)
}
    80006c98:	60e2                	ld	ra,24(sp)
    80006c9a:	6442                	ld	s0,16(sp)
    80006c9c:	64a2                	ld	s1,8(sp)
    80006c9e:	6105                	addi	sp,sp,32
    80006ca0:	8082                	ret

0000000080006ca2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006ca2:	1141                	addi	sp,sp,-16
    80006ca4:	e406                	sd	ra,8(sp)
    80006ca6:	e022                	sd	s0,0(sp)
    80006ca8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    80006caa:	479d                	li	a5,7
    80006cac:	04a7ca63          	blt	a5,a0,80006d00 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80006cb0:	0024b797          	auipc	a5,0x24b
    80006cb4:	2c878793          	addi	a5,a5,712 # 80251f78 <disk>
    80006cb8:	97aa                	add	a5,a5,a0
    80006cba:	0187c783          	lbu	a5,24(a5)
    80006cbe:	e7b9                	bnez	a5,80006d0c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006cc0:	00451693          	slli	a3,a0,0x4
    80006cc4:	0024b797          	auipc	a5,0x24b
    80006cc8:	2b478793          	addi	a5,a5,692 # 80251f78 <disk>
    80006ccc:	6398                	ld	a4,0(a5)
    80006cce:	9736                	add	a4,a4,a3
    80006cd0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80006cd4:	6398                	ld	a4,0(a5)
    80006cd6:	9736                	add	a4,a4,a3
    80006cd8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006cdc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006ce0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006ce4:	97aa                	add	a5,a5,a0
    80006ce6:	4705                	li	a4,1
    80006ce8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006cec:	0024b517          	auipc	a0,0x24b
    80006cf0:	2a450513          	addi	a0,a0,676 # 80251f90 <disk+0x18>
    80006cf4:	ca7fb0ef          	jal	8000299a <wakeup>
}
    80006cf8:	60a2                	ld	ra,8(sp)
    80006cfa:	6402                	ld	s0,0(sp)
    80006cfc:	0141                	addi	sp,sp,16
    80006cfe:	8082                	ret
    panic("free_desc 1");
    80006d00:	00003517          	auipc	a0,0x3
    80006d04:	c3050513          	addi	a0,a0,-976 # 80009930 <etext+0x930>
    80006d08:	ae9f90ef          	jal	800007f0 <panic>
    panic("free_desc 2");
    80006d0c:	00003517          	auipc	a0,0x3
    80006d10:	c3450513          	addi	a0,a0,-972 # 80009940 <etext+0x940>
    80006d14:	addf90ef          	jal	800007f0 <panic>

0000000080006d18 <virtio_disk_init>:
{
    80006d18:	1101                	addi	sp,sp,-32
    80006d1a:	ec06                	sd	ra,24(sp)
    80006d1c:	e822                	sd	s0,16(sp)
    80006d1e:	e426                	sd	s1,8(sp)
    80006d20:	e04a                	sd	s2,0(sp)
    80006d22:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006d24:	00003597          	auipc	a1,0x3
    80006d28:	c2c58593          	addi	a1,a1,-980 # 80009950 <etext+0x950>
    80006d2c:	0024b517          	auipc	a0,0x24b
    80006d30:	37450513          	addi	a0,a0,884 # 802520a0 <disk+0x128>
    80006d34:	fc7f90ef          	jal	80000cfa <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006d38:	100017b7          	lui	a5,0x10001
    80006d3c:	4398                	lw	a4,0(a5)
    80006d3e:	2701                	sext.w	a4,a4
    80006d40:	747277b7          	lui	a5,0x74727
    80006d44:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006d48:	18f71063          	bne	a4,a5,80006ec8 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d4c:	100017b7          	lui	a5,0x10001
    80006d50:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80006d52:	439c                	lw	a5,0(a5)
    80006d54:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006d56:	4709                	li	a4,2
    80006d58:	16e79863          	bne	a5,a4,80006ec8 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d5c:	100017b7          	lui	a5,0x10001
    80006d60:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80006d62:	439c                	lw	a5,0(a5)
    80006d64:	2781                	sext.w	a5,a5
    80006d66:	16e79163          	bne	a5,a4,80006ec8 <virtio_disk_init+0x1b0>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80006d6a:	100017b7          	lui	a5,0x10001
    80006d6e:	47d8                	lw	a4,12(a5)
    80006d70:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006d72:	554d47b7          	lui	a5,0x554d4
    80006d76:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006d7a:	14f71763          	bne	a4,a5,80006ec8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d7e:	100017b7          	lui	a5,0x10001
    80006d82:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d86:	4705                	li	a4,1
    80006d88:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006d8a:	470d                	li	a4,3
    80006d8c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006d8e:	10001737          	lui	a4,0x10001
    80006d92:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006d94:	c7ffe737          	lui	a4,0xc7ffe
    80006d98:	55f70713          	addi	a4,a4,1375 # ffffffffc7ffe55f <end+0xffffffff47dac4a7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006d9c:	8ef9                	and	a3,a3,a4
    80006d9e:	10001737          	lui	a4,0x10001
    80006da2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006da4:	472d                	li	a4,11
    80006da6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006da8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006dac:	439c                	lw	a5,0(a5)
    80006dae:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006db2:	8ba1                	andi	a5,a5,8
    80006db4:	12078063          	beqz	a5,80006ed4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006db8:	100017b7          	lui	a5,0x10001
    80006dbc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80006dc0:	100017b7          	lui	a5,0x10001
    80006dc4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80006dc8:	439c                	lw	a5,0(a5)
    80006dca:	2781                	sext.w	a5,a5
    80006dcc:	10079a63          	bnez	a5,80006ee0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006dd0:	100017b7          	lui	a5,0x10001
    80006dd4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80006dd8:	439c                	lw	a5,0(a5)
    80006dda:	2781                	sext.w	a5,a5
  if (max == 0)
    80006ddc:	10078863          	beqz	a5,80006eec <virtio_disk_init+0x1d4>
  if (max < NUM)
    80006de0:	471d                	li	a4,7
    80006de2:	10f77b63          	bgeu	a4,a5,80006ef8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80006de6:	d59f90ef          	jal	80000b3e <kalloc>
    80006dea:	0024b497          	auipc	s1,0x24b
    80006dee:	18e48493          	addi	s1,s1,398 # 80251f78 <disk>
    80006df2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006df4:	d4bf90ef          	jal	80000b3e <kalloc>
    80006df8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80006dfa:	d45f90ef          	jal	80000b3e <kalloc>
    80006dfe:	87aa                	mv	a5,a0
    80006e00:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80006e02:	6088                	ld	a0,0(s1)
    80006e04:	10050063          	beqz	a0,80006f04 <virtio_disk_init+0x1ec>
    80006e08:	0024b717          	auipc	a4,0x24b
    80006e0c:	17873703          	ld	a4,376(a4) # 80251f80 <disk+0x8>
    80006e10:	0e070a63          	beqz	a4,80006f04 <virtio_disk_init+0x1ec>
    80006e14:	0e078863          	beqz	a5,80006f04 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006e18:	6605                	lui	a2,0x1
    80006e1a:	4581                	li	a1,0
    80006e1c:	818fa0ef          	jal	80000e34 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006e20:	0024b497          	auipc	s1,0x24b
    80006e24:	15848493          	addi	s1,s1,344 # 80251f78 <disk>
    80006e28:	6605                	lui	a2,0x1
    80006e2a:	4581                	li	a1,0
    80006e2c:	6488                	ld	a0,8(s1)
    80006e2e:	806fa0ef          	jal	80000e34 <memset>
  memset(disk.used, 0, PGSIZE);
    80006e32:	6605                	lui	a2,0x1
    80006e34:	4581                	li	a1,0
    80006e36:	6888                	ld	a0,16(s1)
    80006e38:	ffdf90ef          	jal	80000e34 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006e3c:	100017b7          	lui	a5,0x10001
    80006e40:	4721                	li	a4,8
    80006e42:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006e44:	4098                	lw	a4,0(s1)
    80006e46:	100017b7          	lui	a5,0x10001
    80006e4a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006e4e:	40d8                	lw	a4,4(s1)
    80006e50:	100017b7          	lui	a5,0x10001
    80006e54:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006e58:	649c                	ld	a5,8(s1)
    80006e5a:	0007869b          	sext.w	a3,a5
    80006e5e:	10001737          	lui	a4,0x10001
    80006e62:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006e66:	9781                	srai	a5,a5,0x20
    80006e68:	10001737          	lui	a4,0x10001
    80006e6c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006e70:	689c                	ld	a5,16(s1)
    80006e72:	0007869b          	sext.w	a3,a5
    80006e76:	10001737          	lui	a4,0x10001
    80006e7a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80006e7e:	9781                	srai	a5,a5,0x20
    80006e80:	10001737          	lui	a4,0x10001
    80006e84:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006e88:	10001737          	lui	a4,0x10001
    80006e8c:	4785                	li	a5,1
    80006e8e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006e90:	00f48c23          	sb	a5,24(s1)
    80006e94:	00f48ca3          	sb	a5,25(s1)
    80006e98:	00f48d23          	sb	a5,26(s1)
    80006e9c:	00f48da3          	sb	a5,27(s1)
    80006ea0:	00f48e23          	sb	a5,28(s1)
    80006ea4:	00f48ea3          	sb	a5,29(s1)
    80006ea8:	00f48f23          	sb	a5,30(s1)
    80006eac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006eb0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006eb4:	100017b7          	lui	a5,0x10001
    80006eb8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80006ebc:	60e2                	ld	ra,24(sp)
    80006ebe:	6442                	ld	s0,16(sp)
    80006ec0:	64a2                	ld	s1,8(sp)
    80006ec2:	6902                	ld	s2,0(sp)
    80006ec4:	6105                	addi	sp,sp,32
    80006ec6:	8082                	ret
    panic("could not find virtio disk");
    80006ec8:	00003517          	auipc	a0,0x3
    80006ecc:	a9850513          	addi	a0,a0,-1384 # 80009960 <etext+0x960>
    80006ed0:	921f90ef          	jal	800007f0 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006ed4:	00003517          	auipc	a0,0x3
    80006ed8:	aac50513          	addi	a0,a0,-1364 # 80009980 <etext+0x980>
    80006edc:	915f90ef          	jal	800007f0 <panic>
    panic("virtio disk should not be ready");
    80006ee0:	00003517          	auipc	a0,0x3
    80006ee4:	ac050513          	addi	a0,a0,-1344 # 800099a0 <etext+0x9a0>
    80006ee8:	909f90ef          	jal	800007f0 <panic>
    panic("virtio disk has no queue 0");
    80006eec:	00003517          	auipc	a0,0x3
    80006ef0:	ad450513          	addi	a0,a0,-1324 # 800099c0 <etext+0x9c0>
    80006ef4:	8fdf90ef          	jal	800007f0 <panic>
    panic("virtio disk max queue too short");
    80006ef8:	00003517          	auipc	a0,0x3
    80006efc:	ae850513          	addi	a0,a0,-1304 # 800099e0 <etext+0x9e0>
    80006f00:	8f1f90ef          	jal	800007f0 <panic>
    panic("virtio disk kalloc");
    80006f04:	00003517          	auipc	a0,0x3
    80006f08:	afc50513          	addi	a0,a0,-1284 # 80009a00 <etext+0xa00>
    80006f0c:	8e5f90ef          	jal	800007f0 <panic>

0000000080006f10 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006f10:	7159                	addi	sp,sp,-112
    80006f12:	f486                	sd	ra,104(sp)
    80006f14:	f0a2                	sd	s0,96(sp)
    80006f16:	eca6                	sd	s1,88(sp)
    80006f18:	e8ca                	sd	s2,80(sp)
    80006f1a:	e4ce                	sd	s3,72(sp)
    80006f1c:	e0d2                	sd	s4,64(sp)
    80006f1e:	fc56                	sd	s5,56(sp)
    80006f20:	f85a                	sd	s6,48(sp)
    80006f22:	f45e                	sd	s7,40(sp)
    80006f24:	f062                	sd	s8,32(sp)
    80006f26:	ec66                	sd	s9,24(sp)
    80006f28:	1880                	addi	s0,sp,112
    80006f2a:	8a2a                	mv	s4,a0
    80006f2c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006f2e:	00c52c83          	lw	s9,12(a0)
    80006f32:	001c9c9b          	slliw	s9,s9,0x1
    80006f36:	1c82                	slli	s9,s9,0x20
    80006f38:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80006f3c:	0024b517          	auipc	a0,0x24b
    80006f40:	16450513          	addi	a0,a0,356 # 802520a0 <disk+0x128>
    80006f44:	e2df90ef          	jal	80000d70 <acquire>
  for (int i = 0; i < 3; i++) {
    80006f48:	4981                	li	s3,0
  for (int i = 0; i < NUM; i++) {
    80006f4a:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006f4c:	0024bb17          	auipc	s6,0x24b
    80006f50:	02cb0b13          	addi	s6,s6,44 # 80251f78 <disk>
  for (int i = 0; i < 3; i++) {
    80006f54:	4a8d                	li	s5,3
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80006f56:	0024bc17          	auipc	s8,0x24b
    80006f5a:	03ac0c13          	addi	s8,s8,58 # 80251f90 <disk+0x18>
    80006f5e:	a0bd                	j	80006fcc <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    80006f60:	00fb0733          	add	a4,s6,a5
    80006f64:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006f68:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80006f6a:	0207c563          	bltz	a5,80006f94 <virtio_disk_rw+0x84>
  for (int i = 0; i < 3; i++) {
    80006f6e:	2905                	addiw	s2,s2,1
    80006f70:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006f72:	07590163          	beq	s2,s5,80006fd4 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80006f76:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80006f78:	0024b717          	auipc	a4,0x24b
    80006f7c:	00070713          	mv	a4,a4
    80006f80:	87ce                	mv	a5,s3
    if (disk.free[i]) {
    80006f82:	01874683          	lbu	a3,24(a4) # 80251f90 <disk+0x18>
    80006f86:	fee9                	bnez	a3,80006f60 <virtio_disk_rw+0x50>
  for (int i = 0; i < NUM; i++) {
    80006f88:	2785                	addiw	a5,a5,1
    80006f8a:	0705                	addi	a4,a4,1
    80006f8c:	fe979be3          	bne	a5,s1,80006f82 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80006f90:	57fd                	li	a5,-1
    80006f92:	c19c                	sw	a5,0(a1)
      for (int j = 0; j < i; j++)
    80006f94:	01205d63          	blez	s2,80006fae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006f98:	f9042503          	lw	a0,-112(s0)
    80006f9c:	d07ff0ef          	jal	80006ca2 <free_desc>
      for (int j = 0; j < i; j++)
    80006fa0:	4785                	li	a5,1
    80006fa2:	0127d663          	bge	a5,s2,80006fae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006fa6:	f9442503          	lw	a0,-108(s0)
    80006faa:	cf9ff0ef          	jal	80006ca2 <free_desc>
    sleep_prepare(&disk.free[0]);
    80006fae:	8562                	mv	a0,s8
    80006fb0:	97ffb0ef          	jal	8000292e <sleep_prepare>
    release(&disk.vdisk_lock);
    80006fb4:	0024b917          	auipc	s2,0x24b
    80006fb8:	0ec90913          	addi	s2,s2,236 # 802520a0 <disk+0x128>
    80006fbc:	854a                	mv	a0,s2
    80006fbe:	e3ff90ef          	jal	80000dfc <release>
    sleep();
    80006fc2:	9a9fb0ef          	jal	8000296a <sleep>
    acquire(&disk.vdisk_lock);
    80006fc6:	854a                	mv	a0,s2
    80006fc8:	da9f90ef          	jal	80000d70 <acquire>
  for (int i = 0; i < 3; i++) {
    80006fcc:	f9040613          	addi	a2,s0,-112
    80006fd0:	894e                	mv	s2,s3
    80006fd2:	b755                	j	80006f76 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006fd4:	f9042503          	lw	a0,-112(s0)
    80006fd8:	00451693          	slli	a3,a0,0x4

  if (write)
    80006fdc:	0024b797          	auipc	a5,0x24b
    80006fe0:	f9c78793          	addi	a5,a5,-100 # 80251f78 <disk>
    80006fe4:	00a50713          	addi	a4,a0,10
    80006fe8:	0712                	slli	a4,a4,0x4
    80006fea:	973e                	add	a4,a4,a5
    80006fec:	01703633          	snez	a2,s7
    80006ff0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006ff2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006ff6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80006ffa:	6398                	ld	a4,0(a5)
    80006ffc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ffe:	0a868613          	addi	a2,a3,168
    80007002:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80007004:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80007006:	6390                	ld	a2,0(a5)
    80007008:	00d605b3          	add	a1,a2,a3
    8000700c:	4741                	li	a4,16
    8000700e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80007010:	4805                	li	a6,1
    80007012:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80007016:	f9442703          	lw	a4,-108(s0)
    8000701a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000701e:	0712                	slli	a4,a4,0x4
    80007020:	963a                	add	a2,a2,a4
    80007022:	058a0593          	addi	a1,s4,88
    80007026:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007028:	0007b883          	ld	a7,0(a5)
    8000702c:	9746                	add	a4,a4,a7
    8000702e:	40000613          	li	a2,1024
    80007032:	c710                	sw	a2,8(a4)
  if (write)
    80007034:	001bb613          	seqz	a2,s7
    80007038:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000703c:	00166613          	ori	a2,a2,1
    80007040:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80007044:	f9842583          	lw	a1,-104(s0)
    80007048:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000704c:	00250613          	addi	a2,a0,2
    80007050:	0612                	slli	a2,a2,0x4
    80007052:	963e                	add	a2,a2,a5
    80007054:	577d                	li	a4,-1
    80007056:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000705a:	0592                	slli	a1,a1,0x4
    8000705c:	98ae                	add	a7,a7,a1
    8000705e:	03068713          	addi	a4,a3,48
    80007062:	973e                	add	a4,a4,a5
    80007064:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80007068:	6398                	ld	a4,0(a5)
    8000706a:	972e                	add	a4,a4,a1
    8000706c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007070:	4689                	li	a3,2
    80007072:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80007076:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000707a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000707e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80007082:	6794                	ld	a3,8(a5)
    80007084:	0026d703          	lhu	a4,2(a3)
    80007088:	8b1d                	andi	a4,a4,7
    8000708a:	0706                	slli	a4,a4,0x1
    8000708c:	96ba                	add	a3,a3,a4
    8000708e:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80007092:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80007096:	6798                	ld	a4,8(a5)
    80007098:	00275783          	lhu	a5,2(a4)
    8000709c:	2785                	addiw	a5,a5,1
    8000709e:	00f71123          	sh	a5,2(a4)
    800070a2:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800070a6:	100017b7          	lui	a5,0x10001
    800070aa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800070ae:	004a2783          	lw	a5,4(s4)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    800070b2:	0024b497          	auipc	s1,0x24b
    800070b6:	fee48493          	addi	s1,s1,-18 # 802520a0 <disk+0x128>
  while (b->disk == 1) {
    800070ba:	4905                	li	s2,1
    800070bc:	03079163          	bne	a5,a6,800070de <virtio_disk_rw+0x1ce>
    sleep_prepare(b);
    800070c0:	8552                	mv	a0,s4
    800070c2:	86dfb0ef          	jal	8000292e <sleep_prepare>
    release(&disk.vdisk_lock);
    800070c6:	8526                	mv	a0,s1
    800070c8:	d35f90ef          	jal	80000dfc <release>
    sleep();
    800070cc:	89ffb0ef          	jal	8000296a <sleep>
    acquire(&disk.vdisk_lock);
    800070d0:	8526                	mv	a0,s1
    800070d2:	c9ff90ef          	jal	80000d70 <acquire>
  while (b->disk == 1) {
    800070d6:	004a2783          	lw	a5,4(s4)
    800070da:	ff2783e3          	beq	a5,s2,800070c0 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800070de:	f9042903          	lw	s2,-112(s0)
    800070e2:	00290713          	addi	a4,s2,2
    800070e6:	0712                	slli	a4,a4,0x4
    800070e8:	0024b797          	auipc	a5,0x24b
    800070ec:	e9078793          	addi	a5,a5,-368 # 80251f78 <disk>
    800070f0:	97ba                	add	a5,a5,a4
    800070f2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800070f6:	0024b997          	auipc	s3,0x24b
    800070fa:	e8298993          	addi	s3,s3,-382 # 80251f78 <disk>
    800070fe:	00491713          	slli	a4,s2,0x4
    80007102:	0009b783          	ld	a5,0(s3)
    80007106:	97ba                	add	a5,a5,a4
    80007108:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000710c:	854a                	mv	a0,s2
    8000710e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80007112:	b91ff0ef          	jal	80006ca2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80007116:	8885                	andi	s1,s1,1
    80007118:	f0fd                	bnez	s1,800070fe <virtio_disk_rw+0x1ee>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000711a:	0024b517          	auipc	a0,0x24b
    8000711e:	f8650513          	addi	a0,a0,-122 # 802520a0 <disk+0x128>
    80007122:	cdbf90ef          	jal	80000dfc <release>
}
    80007126:	70a6                	ld	ra,104(sp)
    80007128:	7406                	ld	s0,96(sp)
    8000712a:	64e6                	ld	s1,88(sp)
    8000712c:	6946                	ld	s2,80(sp)
    8000712e:	69a6                	ld	s3,72(sp)
    80007130:	6a06                	ld	s4,64(sp)
    80007132:	7ae2                	ld	s5,56(sp)
    80007134:	7b42                	ld	s6,48(sp)
    80007136:	7ba2                	ld	s7,40(sp)
    80007138:	7c02                	ld	s8,32(sp)
    8000713a:	6ce2                	ld	s9,24(sp)
    8000713c:	6165                	addi	sp,sp,112
    8000713e:	8082                	ret

0000000080007140 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007140:	1101                	addi	sp,sp,-32
    80007142:	ec06                	sd	ra,24(sp)
    80007144:	e822                	sd	s0,16(sp)
    80007146:	e426                	sd	s1,8(sp)
    80007148:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000714a:	0024b497          	auipc	s1,0x24b
    8000714e:	e2e48493          	addi	s1,s1,-466 # 80251f78 <disk>
    80007152:	0024b517          	auipc	a0,0x24b
    80007156:	f4e50513          	addi	a0,a0,-178 # 802520a0 <disk+0x128>
    8000715a:	c17f90ef          	jal	80000d70 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000715e:	100017b7          	lui	a5,0x10001
    80007162:	53b8                	lw	a4,96(a5)
    80007164:	8b0d                	andi	a4,a4,3
    80007166:	100017b7          	lui	a5,0x10001
    8000716a:	d3f8                	sw	a4,100(a5)
    8000716c:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80007170:	689c                	ld	a5,16(s1)
    80007172:	0204d703          	lhu	a4,32(s1)
    80007176:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000717a:	04f70663          	beq	a4,a5,800071c6 <virtio_disk_intr+0x86>
    8000717e:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007182:	6898                	ld	a4,16(s1)
    80007184:	0204d783          	lhu	a5,32(s1)
    80007188:	8b9d                	andi	a5,a5,7
    8000718a:	078e                	slli	a5,a5,0x3
    8000718c:	97ba                	add	a5,a5,a4
    8000718e:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80007190:	00278713          	addi	a4,a5,2
    80007194:	0712                	slli	a4,a4,0x4
    80007196:	9726                	add	a4,a4,s1
    80007198:	01074703          	lbu	a4,16(a4)
    8000719c:	e321                	bnez	a4,800071dc <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000719e:	0789                	addi	a5,a5,2
    800071a0:	0792                	slli	a5,a5,0x4
    800071a2:	97a6                	add	a5,a5,s1
    800071a4:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    800071a6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800071aa:	ff0fb0ef          	jal	8000299a <wakeup>

    disk.used_idx += 1;
    800071ae:	0204d783          	lhu	a5,32(s1)
    800071b2:	2785                	addiw	a5,a5,1
    800071b4:	17c2                	slli	a5,a5,0x30
    800071b6:	93c1                	srli	a5,a5,0x30
    800071b8:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800071bc:	6898                	ld	a4,16(s1)
    800071be:	00275703          	lhu	a4,2(a4)
    800071c2:	faf71ee3          	bne	a4,a5,8000717e <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800071c6:	0024b517          	auipc	a0,0x24b
    800071ca:	eda50513          	addi	a0,a0,-294 # 802520a0 <disk+0x128>
    800071ce:	c2ff90ef          	jal	80000dfc <release>
}
    800071d2:	60e2                	ld	ra,24(sp)
    800071d4:	6442                	ld	s0,16(sp)
    800071d6:	64a2                	ld	s1,8(sp)
    800071d8:	6105                	addi	sp,sp,32
    800071da:	8082                	ret
      panic("virtio_disk_intr status");
    800071dc:	00003517          	auipc	a0,0x3
    800071e0:	83c50513          	addi	a0,a0,-1988 # 80009a18 <etext+0xa18>
    800071e4:	e0cf90ef          	jal	800007f0 <panic>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	9282                	jalr	t0

000000008000809c <userret>:
    8000809c:	0000100f          	fence.i
    800080a0:	12000073          	sfence.vma
    800080a4:	18051073          	csrw	satp,a0
    800080a8:	12000073          	sfence.vma
    800080ac:	02000537          	lui	a0,0x2000
    800080b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080b2:	0536                	slli	a0,a0,0xd
    800080b4:	02853083          	ld	ra,40(a0)
    800080b8:	03053103          	ld	sp,48(a0)
    800080bc:	03853183          	ld	gp,56(a0)
    800080c0:	04053203          	ld	tp,64(a0)
    800080c4:	04853283          	ld	t0,72(a0)
    800080c8:	05053303          	ld	t1,80(a0)
    800080cc:	05853383          	ld	t2,88(a0)
    800080d0:	7120                	ld	s0,96(a0)
    800080d2:	7524                	ld	s1,104(a0)
    800080d4:	7d2c                	ld	a1,120(a0)
    800080d6:	6150                	ld	a2,128(a0)
    800080d8:	6554                	ld	a3,136(a0)
    800080da:	6958                	ld	a4,144(a0)
    800080dc:	6d5c                	ld	a5,152(a0)
    800080de:	0a053803          	ld	a6,160(a0)
    800080e2:	0a853883          	ld	a7,168(a0)
    800080e6:	0b053903          	ld	s2,176(a0)
    800080ea:	0b853983          	ld	s3,184(a0)
    800080ee:	0c053a03          	ld	s4,192(a0)
    800080f2:	0c853a83          	ld	s5,200(a0)
    800080f6:	0d053b03          	ld	s6,208(a0)
    800080fa:	0d853b83          	ld	s7,216(a0)
    800080fe:	0e053c03          	ld	s8,224(a0)
    80008102:	0e853c83          	ld	s9,232(a0)
    80008106:	0f053d03          	ld	s10,240(a0)
    8000810a:	0f853d83          	ld	s11,248(a0)
    8000810e:	10053e03          	ld	t3,256(a0)
    80008112:	10853e83          	ld	t4,264(a0)
    80008116:	11053f03          	ld	t5,272(a0)
    8000811a:	11853f83          	ld	t6,280(a0)
    8000811e:	7928                	ld	a0,112(a0)
    80008120:	10200073          	sret
	...
