
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00009117          	auipc	sp,0x9
    80000004:	c3010113          	addi	sp,sp,-976 # 80008c30 <stack0>
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
    80000016:	042000ef          	jal	80000058 <start>

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
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdade97>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	f2078793          	addi	a5,a5,-224 # 80000f98 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	3d7020ef          	jal	80002cf2 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	77c000ef          	jal	800008a4 <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f456                	sd	s5,40(sp)
    80000188:	f05a                	sd	s6,32(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8aaa                	mv	s5,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80000194:	00011517          	auipc	a0,0x11
    80000198:	a9c50513          	addi	a0,a0,-1380 # 80010c30 <cons>
    8000019c:	387000ef          	jal	80000d22 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00011497          	auipc	s1,0x11
    800001a4:	a9048493          	addi	s1,s1,-1392 # 80010c30 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00011917          	auipc	s2,0x11
    800001ac:	b2090913          	addi	s2,s2,-1248 # 80010cc8 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	637010ef          	jal	80001ff6 <myproc>
    800001c4:	011020ef          	jal	800029d4 <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	586020ef          	jal	80002752 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	3d9000ef          	jal	80000daa <release>
      sleep();
    800001d6:	5b8020ef          	jal	8000278e <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	347000ef          	jal	80000d22 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00011717          	auipc	a4,0x11
    800001f2:	a4270713          	addi	a4,a4,-1470 # 80010c30 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070b9b          	sext.w	s7,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04db8663          	beq	s7,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	8556                	mv	a0,s5
    80000220:	287020ef          	jal	80002ca6 <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fb8b63          	beq	s7,a5,80000286 <consoleread+0x10e>
    80000234:	6be2                	ld	s7,24(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00011517          	auipc	a0,0x11
    8000023c:	9f850513          	addi	a0,a0,-1544 # 80010c30 <cons>
    80000240:	36b000ef          	jal	80000daa <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7aa2                	ld	s5,40(sp)
    80000254:	7b02                	ld	s6,32(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0169fa63          	bgeu	s3,s6,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	a6f72523          	sw	a5,-1430(a4) # 80010cc8 <cons+0x98>
    80000266:	6be2                	ld	s7,24(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	ec5e                	sd	s7,24(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	6be2                	ld	s7,24(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000274:	00011517          	auipc	a0,0x11
    80000278:	9bc50513          	addi	a0,a0,-1604 # 80010c30 <cons>
    8000027c:	32f000ef          	jal	80000daa <release>
  return target - n;
    80000280:	413b053b          	subw	a0,s6,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	6be2                	ld	s7,24(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	690000ef          	jal	8000092a <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	682000ef          	jal	8000092a <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	67a000ef          	jal	8000092a <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	674000ef          	jal	8000092a <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	7179                	addi	sp,sp,-48
    800002be:	f406                	sd	ra,40(sp)
    800002c0:	f022                	sd	s0,32(sp)
    800002c2:	ec26                	sd	s1,24(sp)
    800002c4:	1800                	addi	s0,sp,48
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00011517          	auipc	a0,0x11
    800002cc:	96850513          	addi	a0,a0,-1688 # 80010c30 <cons>
    800002d0:	253000ef          	jal	80000d22 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	08f48e63          	beq	s1,a5,80000372 <consoleintr+0xb6>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48863          	beq	s1,a5,800003d0 <consoleintr+0x114>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49963          	bne	s1,a5,800003f8 <consoleintr+0x13c>
  case C('P'): // Print process list.
    procdump();
    800002ea:	255020ef          	jal	80002d3e <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00011517          	auipc	a0,0x11
    800002f2:	94250513          	addi	a0,a0,-1726 # 80010c30 <cons>
    800002f6:	2b5000ef          	jal	80000daa <release>
}
    800002fa:	70a2                	ld	ra,40(sp)
    800002fc:	7402                	ld	s0,32(sp)
    800002fe:	64e2                	ld	s1,24(sp)
    80000300:	6145                	addi	sp,sp,48
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48463          	beq	s1,a5,800003d0 <consoleintr+0x114>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00011717          	auipc	a4,0x11
    80000310:	92470713          	addi	a4,a4,-1756 # 80010c30 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48b63          	beq	s1,a5,800003fe <consoleintr+0x142>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00011797          	auipc	a5,0x11
    80000336:	8fe78793          	addi	a5,a5,-1794 # 80010c30 <cons>
    8000033a:	0a07a683          	lw	a3,160(a5)
    8000033e:	0016871b          	addiw	a4,a3,1
    80000342:	863a                	mv	a2,a4
    80000344:	0ae7a023          	sw	a4,160(a5)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	97b6                	add	a5,a5,a3
    8000034e:	00978c23          	sb	s1,24(a5)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	47a9                	li	a5,10
    80000354:	0cf48963          	beq	s1,a5,80000426 <consoleintr+0x16a>
    80000358:	4791                	li	a5,4
    8000035a:	0cf48663          	beq	s1,a5,80000426 <consoleintr+0x16a>
    8000035e:	00011797          	auipc	a5,0x11
    80000362:	96a7a783          	lw	a5,-1686(a5) # 80010cc8 <cons+0x98>
    80000366:	9f1d                	subw	a4,a4,a5
    80000368:	08000793          	li	a5,128
    8000036c:	f8f711e3          	bne	a4,a5,800002ee <consoleintr+0x32>
    80000370:	a85d                	j	80000426 <consoleintr+0x16a>
    80000372:	e84a                	sd	s2,16(sp)
    80000374:	e44e                	sd	s3,8(sp)
    while (cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	8ba70713          	addi	a4,a4,-1862 # 80010c30 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	8aa48493          	addi	s1,s1,-1878 # 80010c30 <cons>
    while (cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
      consputc(BACKSPACE);
    80000390:	10000993          	li	s3,256
    while (cons.e != cons.w &&
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270363          	beq	a4,s2,800003ca <consoleintr+0x10e>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	854e                	mv	a0,s3
    800003ae:	eddff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b2:	0a04a783          	lw	a5,160(s1)
    800003b6:	09c4a703          	lw	a4,156(s1)
    800003ba:	fcf71fe3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003be:	6942                	ld	s2,16(sp)
    800003c0:	69a2                	ld	s3,8(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6942                	ld	s2,16(sp)
    800003c6:	69a2                	ld	s3,8(sp)
    800003c8:	b71d                	j	800002ee <consoleintr+0x32>
    800003ca:	6942                	ld	s2,16(sp)
    800003cc:	69a2                	ld	s3,8(sp)
    800003ce:	b705                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003d0:	00011717          	auipc	a4,0x11
    800003d4:	86070713          	addi	a4,a4,-1952 # 80010c30 <cons>
    800003d8:	0a072783          	lw	a5,160(a4)
    800003dc:	09c72703          	lw	a4,156(a4)
    800003e0:	f0f707e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	00011717          	auipc	a4,0x11
    800003ea:	8ef72523          	sw	a5,-1814(a4) # 80010cd0 <cons+0xa0>
      consputc(BACKSPACE);
    800003ee:	10000513          	li	a0,256
    800003f2:	e99ff0ef          	jal	8000028a <consputc>
    800003f6:	bde5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f8:	ee048be3          	beqz	s1,800002ee <consoleintr+0x32>
    800003fc:	bf01                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fe:	4529                	li	a0,10
    80000400:	e8bff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000404:	00011797          	auipc	a5,0x11
    80000408:	82c78793          	addi	a5,a5,-2004 # 80010c30 <cons>
    8000040c:	0a07a703          	lw	a4,160(a5)
    80000410:	0017069b          	addiw	a3,a4,1
    80000414:	8636                	mv	a2,a3
    80000416:	0ad7a023          	sw	a3,160(a5)
    8000041a:	07f77713          	andi	a4,a4,127
    8000041e:	97ba                	add	a5,a5,a4
    80000420:	4729                	li	a4,10
    80000422:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000426:	00011797          	auipc	a5,0x11
    8000042a:	8ac7a323          	sw	a2,-1882(a5) # 80010ccc <cons+0x9c>
        wakeup(&cons.r);
    8000042e:	00011517          	auipc	a0,0x11
    80000432:	89a50513          	addi	a0,a0,-1894 # 80010cc8 <cons+0x98>
    80000436:	388020ef          	jal	800027be <wakeup>
    8000043a:	bd55                	j	800002ee <consoleintr+0x32>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bbc58593          	addi	a1,a1,-1092 # 80008000 <etext>
    8000044c:	00010517          	auipc	a0,0x10
    80000450:	7e450513          	addi	a0,a0,2020 # 80010c30 <cons>
    80000454:	055000ef          	jal	80000ca8 <initlock>

  uartinit();
    80000458:	3f6000ef          	jal	8000084e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000045c:	0024f797          	auipc	a5,0x24f
    80000460:	37478793          	addi	a5,a5,884 # 8024f7d0 <devsw>
    80000464:	00000717          	auipc	a4,0x0
    80000468:	d1470713          	addi	a4,a4,-748 # 80000178 <consoleread>
    8000046c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046e:	00000717          	auipc	a4,0x0
    80000472:	c6870713          	addi	a4,a4,-920 # 800000d6 <consolewrite>
    80000476:	ef98                	sd	a4,24(a5)
}
    80000478:	60a2                	ld	ra,8(sp)
    8000047a:	6402                	ld	s0,0(sp)
    8000047c:	0141                	addi	sp,sp,16
    8000047e:	8082                	ret

0000000080000480 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000480:	7139                	addi	sp,sp,-64
    80000482:	fc06                	sd	ra,56(sp)
    80000484:	f822                	sd	s0,48(sp)
    80000486:	f426                	sd	s1,40(sp)
    80000488:	f04a                	sd	s2,32(sp)
    8000048a:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    8000048c:	c219                	beqz	a2,80000492 <printint+0x12>
    8000048e:	06054a63          	bltz	a0,80000502 <printint+0x82>
    x = -xx;
  else
    x = xx;
    80000492:	4e01                	li	t3,0

  i = 0;
    80000494:	fc840313          	addi	t1,s0,-56
    x = xx;
    80000498:	869a                	mv	a3,t1
  i = 0;
    8000049a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000049c:	00008817          	auipc	a6,0x8
    800004a0:	46480813          	addi	a6,a6,1124 # 80008900 <digits>
    800004a4:	88be                	mv	a7,a5
    800004a6:	0017861b          	addiw	a2,a5,1
    800004aa:	87b2                	mv	a5,a2
    800004ac:	02b57733          	remu	a4,a0,a1
    800004b0:	9742                	add	a4,a4,a6
    800004b2:	00074703          	lbu	a4,0(a4)
    800004b6:	00e68023          	sb	a4,0(a3)
  } while ((x /= base) != 0);
    800004ba:	872a                	mv	a4,a0
    800004bc:	02b55533          	divu	a0,a0,a1
    800004c0:	0685                	addi	a3,a3,1
    800004c2:	feb771e3          	bgeu	a4,a1,800004a4 <printint+0x24>

  if (sign)
    800004c6:	000e0c63          	beqz	t3,800004de <printint+0x5e>
    buf[i++] = '-';
    800004ca:	fe060793          	addi	a5,a2,-32
    800004ce:	00878633          	add	a2,a5,s0
    800004d2:	02d00793          	li	a5,45
    800004d6:	fef60423          	sb	a5,-24(a2)
    800004da:	0028879b          	addiw	a5,a7,2

  while (--i >= 0)
    800004de:	fff7891b          	addiw	s2,a5,-1
    800004e2:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800004e6:	fff4c503          	lbu	a0,-1(s1)
    800004ea:	da1ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004ee:	397d                	addiw	s2,s2,-1
    800004f0:	14fd                	addi	s1,s1,-1
    800004f2:	fe095ae3          	bgez	s2,800004e6 <printint+0x66>
}
    800004f6:	70e2                	ld	ra,56(sp)
    800004f8:	7442                	ld	s0,48(sp)
    800004fa:	74a2                	ld	s1,40(sp)
    800004fc:	7902                	ld	s2,32(sp)
    800004fe:	6121                	addi	sp,sp,64
    80000500:	8082                	ret
    x = -xx;
    80000502:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    80000506:	4e05                	li	t3,1
    x = -xx;
    80000508:	b771                	j	80000494 <printint+0x14>

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
    80000528:	00008797          	auipc	a5,0x8
    8000052c:	6dc7a783          	lw	a5,1756(a5) # 80008c04 <panicking>
    80000530:	c3a1                	beqz	a5,80000570 <printk+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000532:	00840793          	addi	a5,s0,8
    80000536:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    8000053a:	000a4503          	lbu	a0,0(s4)
    8000053e:	28050663          	beqz	a0,800007ca <printk+0x2c0>
    80000542:	f4a6                	sd	s1,104(sp)
    80000544:	f0ca                	sd	s2,96(sp)
    80000546:	ecce                	sd	s3,88(sp)
    80000548:	e4d6                	sd	s5,72(sp)
    8000054a:	e0da                	sd	s6,64(sp)
    8000054c:	f862                	sd	s8,48(sp)
    8000054e:	f466                	sd	s9,40(sp)
    80000550:	f06a                	sd	s10,32(sp)
    80000552:	ec6e                	sd	s11,24(sp)
    80000554:	4901                	li	s2,0
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
    8000056e:	a015                	j	80000592 <printk+0x88>
    acquire(&pr.lock);
    80000570:	00010517          	auipc	a0,0x10
    80000574:	76850513          	addi	a0,a0,1896 # 80010cd8 <pr>
    80000578:	7aa000ef          	jal	80000d22 <acquire>
    8000057c:	bf5d                	j	80000532 <printk+0x28>
      consputc(cx);
    8000057e:	d0dff0ef          	jal	8000028a <consputc>
      continue;
    80000582:	84ca                	mv	s1,s2
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000584:	2485                	addiw	s1,s1,1
    80000586:	8926                	mv	s2,s1
    80000588:	94d2                	add	s1,s1,s4
    8000058a:	0004c503          	lbu	a0,0(s1)
    8000058e:	20050b63          	beqz	a0,800007a4 <printk+0x29a>
    if (cx != '%') {
    80000592:	ff5516e3          	bne	a0,s5,8000057e <printk+0x74>
    i++;
    80000596:	0019079b          	addiw	a5,s2,1
    8000059a:	84be                	mv	s1,a5
    c0 = fmt[i + 0] & 0xff;
    8000059c:	00fa0733          	add	a4,s4,a5
    800005a0:	00074983          	lbu	s3,0(a4)
    if (c0)
    800005a4:	20098a63          	beqz	s3,800007b8 <printk+0x2ae>
      c1 = fmt[i + 1] & 0xff;
    800005a8:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    800005ac:	86ba                	mv	a3,a4
    if (c1)
    800005ae:	c701                	beqz	a4,800005b6 <printk+0xac>
      c2 = fmt[i + 2] & 0xff;
    800005b0:	97d2                	add	a5,a5,s4
    800005b2:	0027c683          	lbu	a3,2(a5)
    if (c0 == 'd') {
    800005b6:	03698963          	beq	s3,s6,800005e8 <printk+0xde>
    } else if (c0 == 'l' && c1 == 'd') {
    800005ba:	05898363          	beq	s3,s8,80000600 <printk+0xf6>
    } else if (c0 == 'u') {
    800005be:	0d998663          	beq	s3,s9,8000068a <printk+0x180>
    } else if (c0 == 'x') {
    800005c2:	11a98d63          	beq	s3,s10,800006dc <printk+0x1d2>
    } else if (c0 == 'p') {
    800005c6:	15b98663          	beq	s3,s11,80000712 <printk+0x208>
      printptr(va_arg(ap, uint64));
    } else if (c0 == 'c') {
    800005ca:	06300793          	li	a5,99
    800005ce:	18f98563          	beq	s3,a5,80000758 <printk+0x24e>
      consputc(va_arg(ap, uint));
    } else if (c0 == 's') {
    800005d2:	07300793          	li	a5,115
    800005d6:	18f98b63          	beq	s3,a5,8000076c <printk+0x262>
      if ((s = va_arg(ap, char *)) == 0)
        s = "(null)";
      for (; *s; s++)
        consputc(*s);
    } else if (c0 == '%') {
    800005da:	03599b63          	bne	s3,s5,80000610 <printk+0x106>
      consputc('%');
    800005de:	02500513          	li	a0,37
    800005e2:	ca9ff0ef          	jal	8000028a <consputc>
    800005e6:	bf79                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005e8:	f8843783          	ld	a5,-120(s0)
    800005ec:	00878713          	addi	a4,a5,8
    800005f0:	f8e43423          	sd	a4,-120(s0)
    800005f4:	4605                	li	a2,1
    800005f6:	45a9                	li	a1,10
    800005f8:	4388                	lw	a0,0(a5)
    800005fa:	e87ff0ef          	jal	80000480 <printint>
    800005fe:	b759                	j	80000584 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'd') {
    80000600:	01670f63          	beq	a4,s6,8000061e <printk+0x114>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    80000604:	03870b63          	beq	a4,s8,8000063a <printk+0x130>
    } else if (c0 == 'l' && c1 == 'u') {
    80000608:	09970e63          	beq	a4,s9,800006a4 <printk+0x19a>
    } else if (c0 == 'l' && c1 == 'x') {
    8000060c:	0fa70563          	beq	a4,s10,800006f6 <printk+0x1ec>
    } else if (c0 == 0) {
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000610:	8556                	mv	a0,s5
    80000612:	c79ff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000616:	854e                	mv	a0,s3
    80000618:	c73ff0ef          	jal	8000028a <consputc>
    8000061c:	b7a5                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000061e:	f8843783          	ld	a5,-120(s0)
    80000622:	00878713          	addi	a4,a5,8
    80000626:	f8e43423          	sd	a4,-120(s0)
    8000062a:	4605                	li	a2,1
    8000062c:	45a9                	li	a1,10
    8000062e:	6388                	ld	a0,0(a5)
    80000630:	e51ff0ef          	jal	80000480 <printint>
      i += 1;
    80000634:	0029049b          	addiw	s1,s2,2
    80000638:	b7b1                	j	80000584 <printk+0x7a>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    8000063a:	06400793          	li	a5,100
    8000063e:	02f68863          	beq	a3,a5,8000066e <printk+0x164>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    80000642:	07500793          	li	a5,117
    80000646:	06f68d63          	beq	a3,a5,800006c0 <printk+0x1b6>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000064a:	07800793          	li	a5,120
    8000064e:	fcf691e3          	bne	a3,a5,80000610 <printk+0x106>
      printint(va_arg(ap, uint64), 16, 0);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4601                	li	a2,0
    80000660:	45c1                	li	a1,16
    80000662:	6388                	ld	a0,0(a5)
    80000664:	e1dff0ef          	jal	80000480 <printint>
      i += 2;
    80000668:	0039049b          	addiw	s1,s2,3
    8000066c:	bf21                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4605                	li	a2,1
    8000067c:	45a9                	li	a1,10
    8000067e:	6388                	ld	a0,0(a5)
    80000680:	e01ff0ef          	jal	80000480 <printint>
      i += 2;
    80000684:	0039049b          	addiw	s1,s2,3
    80000688:	bdf5                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000068a:	f8843783          	ld	a5,-120(s0)
    8000068e:	00878713          	addi	a4,a5,8
    80000692:	f8e43423          	sd	a4,-120(s0)
    80000696:	4601                	li	a2,0
    80000698:	45a9                	li	a1,10
    8000069a:	0007e503          	lwu	a0,0(a5)
    8000069e:	de3ff0ef          	jal	80000480 <printint>
    800006a2:	b5cd                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006a4:	f8843783          	ld	a5,-120(s0)
    800006a8:	00878713          	addi	a4,a5,8
    800006ac:	f8e43423          	sd	a4,-120(s0)
    800006b0:	4601                	li	a2,0
    800006b2:	45a9                	li	a1,10
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dcbff0ef          	jal	80000480 <printint>
      i += 1;
    800006ba:	0029049b          	addiw	s1,s2,2
    800006be:	b5d9                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	4601                	li	a2,0
    800006ce:	45a9                	li	a1,10
    800006d0:	6388                	ld	a0,0(a5)
    800006d2:	dafff0ef          	jal	80000480 <printint>
      i += 2;
    800006d6:	0039049b          	addiw	s1,s2,3
    800006da:	b56d                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	4601                	li	a2,0
    800006ea:	45c1                	li	a1,16
    800006ec:	0007e503          	lwu	a0,0(a5)
    800006f0:	d91ff0ef          	jal	80000480 <printint>
    800006f4:	bd41                	j	80000584 <printk+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	4601                	li	a2,0
    80000704:	45c1                	li	a1,16
    80000706:	6388                	ld	a0,0(a5)
    80000708:	d79ff0ef          	jal	80000480 <printint>
      i += 1;
    8000070c:	0029049b          	addiw	s1,s2,2
    80000710:	bd95                	j	80000584 <printk+0x7a>
    80000712:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000724:	03000513          	li	a0,48
    80000728:	b63ff0ef          	jal	8000028a <consputc>
  consputc('x');
    8000072c:	07800513          	li	a0,120
    80000730:	b5bff0ef          	jal	8000028a <consputc>
    80000734:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000736:	00008b97          	auipc	s7,0x8
    8000073a:	1cab8b93          	addi	s7,s7,458 # 80008900 <digits>
    8000073e:	03c9d793          	srli	a5,s3,0x3c
    80000742:	97de                	add	a5,a5,s7
    80000744:	0007c503          	lbu	a0,0(a5)
    80000748:	b43ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000074c:	0992                	slli	s3,s3,0x4
    8000074e:	397d                	addiw	s2,s2,-1
    80000750:	fe0917e3          	bnez	s2,8000073e <printk+0x234>
    80000754:	7be2                	ld	s7,56(sp)
    80000756:	b53d                	j	80000584 <printk+0x7a>
      consputc(va_arg(ap, uint));
    80000758:	f8843783          	ld	a5,-120(s0)
    8000075c:	00878713          	addi	a4,a5,8
    80000760:	f8e43423          	sd	a4,-120(s0)
    80000764:	4388                	lw	a0,0(a5)
    80000766:	b25ff0ef          	jal	8000028a <consputc>
    8000076a:	bd29                	j	80000584 <printk+0x7a>
      if ((s = va_arg(ap, char *)) == 0)
    8000076c:	f8843783          	ld	a5,-120(s0)
    80000770:	00878713          	addi	a4,a5,8
    80000774:	f8e43423          	sd	a4,-120(s0)
    80000778:	0007b903          	ld	s2,0(a5)
    8000077c:	00090d63          	beqz	s2,80000796 <printk+0x28c>
      for (; *s; s++)
    80000780:	00094503          	lbu	a0,0(s2)
    80000784:	e00500e3          	beqz	a0,80000584 <printk+0x7a>
        consputc(*s);
    80000788:	b03ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    8000078c:	0905                	addi	s2,s2,1
    8000078e:	00094503          	lbu	a0,0(s2)
    80000792:	f97d                	bnez	a0,80000788 <printk+0x27e>
    80000794:	bbc5                	j	80000584 <printk+0x7a>
        s = "(null)";
    80000796:	00008917          	auipc	s2,0x8
    8000079a:	87290913          	addi	s2,s2,-1934 # 80008008 <etext+0x8>
      for (; *s; s++)
    8000079e:	02800513          	li	a0,40
    800007a2:	b7dd                	j	80000788 <printk+0x27e>
    800007a4:	74a6                	ld	s1,104(sp)
    800007a6:	7906                	ld	s2,96(sp)
    800007a8:	69e6                	ld	s3,88(sp)
    800007aa:	6aa6                	ld	s5,72(sp)
    800007ac:	6b06                	ld	s6,64(sp)
    800007ae:	7c42                	ld	s8,48(sp)
    800007b0:	7ca2                	ld	s9,40(sp)
    800007b2:	7d02                	ld	s10,32(sp)
    800007b4:	6de2                	ld	s11,24(sp)
    800007b6:	a811                	j	800007ca <printk+0x2c0>
    800007b8:	74a6                	ld	s1,104(sp)
    800007ba:	7906                	ld	s2,96(sp)
    800007bc:	69e6                	ld	s3,88(sp)
    800007be:	6aa6                	ld	s5,72(sp)
    800007c0:	6b06                	ld	s6,64(sp)
    800007c2:	7c42                	ld	s8,48(sp)
    800007c4:	7ca2                	ld	s9,40(sp)
    800007c6:	7d02                	ld	s10,32(sp)
    800007c8:	6de2                	ld	s11,24(sp)
    }
  }
  va_end(ap);

  if (panicking == 0)
    800007ca:	00008797          	auipc	a5,0x8
    800007ce:	43a7a783          	lw	a5,1082(a5) # 80008c04 <panicking>
    800007d2:	c799                	beqz	a5,800007e0 <printk+0x2d6>
    release(&pr.lock);

  return 0;
}
    800007d4:	4501                	li	a0,0
    800007d6:	70e6                	ld	ra,120(sp)
    800007d8:	7446                	ld	s0,112(sp)
    800007da:	6a46                	ld	s4,80(sp)
    800007dc:	6129                	addi	sp,sp,192
    800007de:	8082                	ret
    release(&pr.lock);
    800007e0:	00010517          	auipc	a0,0x10
    800007e4:	4f850513          	addi	a0,a0,1272 # 80010cd8 <pr>
    800007e8:	5c2000ef          	jal	80000daa <release>
  return 0;
    800007ec:	b7e5                	j	800007d4 <printk+0x2ca>

00000000800007ee <panic>:

void
panic(char *s)
{
    800007ee:	1101                	addi	sp,sp,-32
    800007f0:	ec06                	sd	ra,24(sp)
    800007f2:	e822                	sd	s0,16(sp)
    800007f4:	e426                	sd	s1,8(sp)
    800007f6:	e04a                	sd	s2,0(sp)
    800007f8:	1000                	addi	s0,sp,32
    800007fa:	84aa                	mv	s1,a0
  panicking = 1;
    800007fc:	4905                	li	s2,1
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	4127a323          	sw	s2,1030(a5) # 80008c04 <panicking>
  printk("panic: ");
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	81250513          	addi	a0,a0,-2030 # 80008018 <etext+0x18>
    8000080e:	cfdff0ef          	jal	8000050a <printk>
  printk("%s\n", s);
    80000812:	85a6                	mv	a1,s1
    80000814:	00008517          	auipc	a0,0x8
    80000818:	80c50513          	addi	a0,a0,-2036 # 80008020 <etext+0x20>
    8000081c:	cefff0ef          	jal	8000050a <printk>
  panicked = 1; // freeze uart output from other CPUs
    80000820:	00008797          	auipc	a5,0x8
    80000824:	3f27a023          	sw	s2,992(a5) # 80008c00 <panicked>
  for (;;)
    80000828:	a001                	j	80000828 <panic+0x3a>

000000008000082a <printkinit>:
    ;
}

void
printkinit(void)
{
    8000082a:	1141                	addi	sp,sp,-16
    8000082c:	e406                	sd	ra,8(sp)
    8000082e:	e022                	sd	s0,0(sp)
    80000830:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000832:	00007597          	auipc	a1,0x7
    80000836:	7f658593          	addi	a1,a1,2038 # 80008028 <etext+0x28>
    8000083a:	00010517          	auipc	a0,0x10
    8000083e:	49e50513          	addi	a0,a0,1182 # 80010cd8 <pr>
    80000842:	466000ef          	jal	80000ca8 <initlock>
}
    80000846:	60a2                	ld	ra,8(sp)
    80000848:	6402                	ld	s0,0(sp)
    8000084a:	0141                	addi	sp,sp,16
    8000084c:	8082                	ret

000000008000084e <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    8000084e:	1141                	addi	sp,sp,-16
    80000850:	e406                	sd	ra,8(sp)
    80000852:	e022                	sd	s0,0(sp)
    80000854:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000856:	100007b7          	lui	a5,0x10000
    8000085a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000085e:	10000737          	lui	a4,0x10000
    80000862:	f8000693          	li	a3,-128
    80000866:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000086a:	468d                	li	a3,3
    8000086c:	10000637          	lui	a2,0x10000
    80000870:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000874:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000878:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000087c:	8732                	mv	a4,a2
    8000087e:	461d                	li	a2,7
    80000880:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000884:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    80000888:	00007597          	auipc	a1,0x7
    8000088c:	7a858593          	addi	a1,a1,1960 # 80008030 <etext+0x30>
    80000890:	00010517          	auipc	a0,0x10
    80000894:	46050513          	addi	a0,a0,1120 # 80010cf0 <tx_lock>
    80000898:	7e8040ef          	jal	80005080 <initsleeplock>
}
    8000089c:	60a2                	ld	ra,8(sp)
    8000089e:	6402                	ld	s0,0(sp)
    800008a0:	0141                	addi	sp,sp,16
    800008a2:	8082                	ret

00000000800008a4 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008a4:	7139                	addi	sp,sp,-64
    800008a6:	fc06                	sd	ra,56(sp)
    800008a8:	f822                	sd	s0,48(sp)
    800008aa:	f04a                	sd	s2,32(sp)
    800008ac:	e456                	sd	s5,8(sp)
    800008ae:	0080                	addi	s0,sp,64
    800008b0:	8aaa                	mv	s5,a0
    800008b2:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    800008b4:	00010517          	auipc	a0,0x10
    800008b8:	43c50513          	addi	a0,a0,1084 # 80010cf0 <tx_lock>
    800008bc:	7fa040ef          	jal	800050b6 <acquiresleep>

  int i = 0;
  while (i < n) {
    800008c0:	05205963          	blez	s2,80000912 <uartwrite+0x6e>
    800008c4:	f426                	sd	s1,40(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e05a                	sd	s6,0(sp)
  int i = 0;
    800008cc:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    800008ce:	00008a17          	auipc	s4,0x8
    800008d2:	33aa0a13          	addi	s4,s4,826 # 80008c08 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    800008d6:	100009b7          	lui	s3,0x10000
    800008da:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    800008dc:	10000b37          	lui	s6,0x10000
    800008e0:	a029                	j	800008ea <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    800008e2:	6ad010ef          	jal	8000278e <sleep>
  while (i < n) {
    800008e6:	0324d263          	bge	s1,s2,8000090a <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    800008ea:	8552                	mv	a0,s4
    800008ec:	667010ef          	jal	80002752 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    800008f0:	0009c783          	lbu	a5,0(s3)
    800008f4:	0207f793          	andi	a5,a5,32
    800008f8:	d7ed                	beqz	a5,800008e2 <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    800008fa:	009a87b3          	add	a5,s5,s1
    800008fe:	0007c783          	lbu	a5,0(a5)
    80000902:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    80000906:	2485                	addiw	s1,s1,1
    80000908:	bff9                	j	800008e6 <uartwrite+0x42>
    8000090a:	74a2                	ld	s1,40(sp)
    8000090c:	69e2                	ld	s3,24(sp)
    8000090e:	6a42                	ld	s4,16(sp)
    80000910:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    80000912:	00010517          	auipc	a0,0x10
    80000916:	3de50513          	addi	a0,a0,990 # 80010cf0 <tx_lock>
    8000091a:	7f0040ef          	jal	8000510a <releasesleep>
}
    8000091e:	70e2                	ld	ra,56(sp)
    80000920:	7442                	ld	s0,48(sp)
    80000922:	7902                	ld	s2,32(sp)
    80000924:	6aa2                	ld	s5,8(sp)
    80000926:	6121                	addi	sp,sp,64
    80000928:	8082                	ret

000000008000092a <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000092a:	1101                	addi	sp,sp,-32
    8000092c:	ec06                	sd	ra,24(sp)
    8000092e:	e822                	sd	s0,16(sp)
    80000930:	e426                	sd	s1,8(sp)
    80000932:	1000                	addi	s0,sp,32
    80000934:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000936:	00008797          	auipc	a5,0x8
    8000093a:	2ce7a783          	lw	a5,718(a5) # 80008c04 <panicking>
    8000093e:	cf95                	beqz	a5,8000097a <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000940:	00008797          	auipc	a5,0x8
    80000944:	2c07a783          	lw	a5,704(a5) # 80008c00 <panicked>
    80000948:	ef85                	bnez	a5,80000980 <uartputc_sync+0x56>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000094a:	10000737          	lui	a4,0x10000
    8000094e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000950:	00074783          	lbu	a5,0(a4)
    80000954:	0207f793          	andi	a5,a5,32
    80000958:	dfe5                	beqz	a5,80000950 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000095a:	0ff4f513          	zext.b	a0,s1
    8000095e:	100007b7          	lui	a5,0x10000
    80000962:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    80000966:	00008797          	auipc	a5,0x8
    8000096a:	29e7a783          	lw	a5,670(a5) # 80008c04 <panicking>
    8000096e:	cb91                	beqz	a5,80000982 <uartputc_sync+0x58>
    pop_off();
}
    80000970:	60e2                	ld	ra,24(sp)
    80000972:	6442                	ld	s0,16(sp)
    80000974:	64a2                	ld	s1,8(sp)
    80000976:	6105                	addi	sp,sp,32
    80000978:	8082                	ret
    push_off();
    8000097a:	372000ef          	jal	80000cec <push_off>
    8000097e:	b7c9                	j	80000940 <uartputc_sync+0x16>
    for (;;)
    80000980:	a001                	j	80000980 <uartputc_sync+0x56>
    pop_off();
    80000982:	3e0000ef          	jal	80000d62 <pop_off>
}
    80000986:	b7ed                	j	80000970 <uartputc_sync+0x46>

0000000080000988 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000988:	1101                	addi	sp,sp,-32
    8000098a:	ec06                	sd	ra,24(sp)
    8000098c:	e822                	sd	s0,16(sp)
    8000098e:	e426                	sd	s1,8(sp)
    80000990:	e04a                	sd	s2,0(sp)
    80000992:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80000994:	100007b7          	lui	a5,0x10000
    80000998:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000099c:	100007b7          	lui	a5,0x10000
    800009a0:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009a4:	0207f793          	andi	a5,a5,32
    800009a8:	ef99                	bnez	a5,800009c6 <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009aa:	100004b7          	lui	s1,0x10000
    800009ae:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    800009b0:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    800009b4:	0004c783          	lbu	a5,0(s1)
    800009b8:	8b85                	andi	a5,a5,1
    800009ba:	cf89                	beqz	a5,800009d4 <uartintr+0x4c>
    return ReadReg(RHR);
    800009bc:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    800009c0:	8fdff0ef          	jal	800002bc <consoleintr>
  while (1) {
    800009c4:	bfc5                	j	800009b4 <uartintr+0x2c>
    wakeup(&tx_chan);
    800009c6:	00008517          	auipc	a0,0x8
    800009ca:	24250513          	addi	a0,a0,578 # 80008c08 <tx_chan>
    800009ce:	5f1010ef          	jal	800027be <wakeup>
    800009d2:	bfe1                	j	800009aa <uartintr+0x22>
  }
}
    800009d4:	60e2                	ld	ra,24(sp)
    800009d6:	6442                	ld	s0,16(sp)
    800009d8:	64a2                	ld	s1,8(sp)
    800009da:	6902                	ld	s2,0(sp)
    800009dc:	6105                	addi	sp,sp,32
    800009de:	8082                	ret

00000000800009e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009e0:	1101                	addi	sp,sp,-32
    800009e2:	ec06                	sd	ra,24(sp)
    800009e4:	e822                	sd	s0,16(sp)
    800009e6:	e426                	sd	s1,8(sp)
    800009e8:	e04a                	sd	s2,0(sp)
    800009ea:	1000                	addi	s0,sp,32
  struct run *r;
  int index;
  int count;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end ||
    800009ec:	03451793          	slli	a5,a0,0x34
    800009f0:	e3c9                	bnez	a5,80000a72 <kfree+0x92>
    800009f2:	892a                	mv	s2,a0
    800009f4:	00250797          	auipc	a5,0x250
    800009f8:	f7478793          	addi	a5,a5,-140 # 80250968 <end>
    800009fc:	06f56b63          	bltu	a0,a5,80000a72 <kfree+0x92>
    80000a00:	47c5                	li	a5,17
    80000a02:	07ee                	slli	a5,a5,0x1b
    80000a04:	06f57763          	bgeu	a0,a5,80000a72 <kfree+0x92>
     (uint64)pa >= PHYSTOP)
    panic("kfree");

  index = (uint64)pa / PGSIZE;
    80000a08:	00c55493          	srli	s1,a0,0xc
    80000a0c:	2481                	sext.w	s1,s1

  acquire(&ref.lock);
    80000a0e:	00010517          	auipc	a0,0x10
    80000a12:	33250513          	addi	a0,a0,818 # 80010d40 <ref>
    80000a16:	30c000ef          	jal	80000d22 <acquire>
  ref.refcnt[index]--;
    80000a1a:	00010517          	auipc	a0,0x10
    80000a1e:	32650513          	addi	a0,a0,806 # 80010d40 <ref>
    80000a22:	00448793          	addi	a5,s1,4
    80000a26:	078a                	slli	a5,a5,0x2
    80000a28:	97aa                	add	a5,a5,a0
    80000a2a:	4798                	lw	a4,8(a5)
    80000a2c:	377d                	addiw	a4,a4,-1
    80000a2e:	84ba                	mv	s1,a4
    80000a30:	c798                	sw	a4,8(a5)
  count = ref.refcnt[index];
  release(&ref.lock);
    80000a32:	378000ef          	jal	80000daa <release>

  if(count > 0)
    80000a36:	02904863          	bgtz	s1,80000a66 <kfree+0x86>
    return;

  if(count < 0)
    80000a3a:	0404c263          	bltz	s1,80000a7e <kfree+0x9e>
    panic("kfree refcnt");

  memset(pa, 1, PGSIZE);
    80000a3e:	6605                	lui	a2,0x1
    80000a40:	4585                	li	a1,1
    80000a42:	854a                	mv	a0,s2
    80000a44:	39e000ef          	jal	80000de2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a48:	00010497          	auipc	s1,0x10
    80000a4c:	2d848493          	addi	s1,s1,728 # 80010d20 <kmem>
    80000a50:	8526                	mv	a0,s1
    80000a52:	2d0000ef          	jal	80000d22 <acquire>
  r->next = kmem.freelist;
    80000a56:	6c9c                	ld	a5,24(s1)
    80000a58:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    80000a5c:	0124bc23          	sd	s2,24(s1)
  release(&kmem.lock);
    80000a60:	8526                	mv	a0,s1
    80000a62:	348000ef          	jal	80000daa <release>
}
    80000a66:	60e2                	ld	ra,24(sp)
    80000a68:	6442                	ld	s0,16(sp)
    80000a6a:	64a2                	ld	s1,8(sp)
    80000a6c:	6902                	ld	s2,0(sp)
    80000a6e:	6105                	addi	sp,sp,32
    80000a70:	8082                	ret
    panic("kfree");
    80000a72:	00007517          	auipc	a0,0x7
    80000a76:	5c650513          	addi	a0,a0,1478 # 80008038 <etext+0x38>
    80000a7a:	d75ff0ef          	jal	800007ee <panic>
    panic("kfree refcnt");
    80000a7e:	00007517          	auipc	a0,0x7
    80000a82:	5c250513          	addi	a0,a0,1474 # 80008040 <etext+0x40>
    80000a86:	d69ff0ef          	jal	800007ee <panic>

0000000080000a8a <freerange>:
{
    80000a8a:	7179                	addi	sp,sp,-48
    80000a8c:	f406                	sd	ra,40(sp)
    80000a8e:	f022                	sd	s0,32(sp)
    80000a90:	ec26                	sd	s1,24(sp)
    80000a92:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000a94:	6785                	lui	a5,0x1
    80000a96:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a9a:	00e504b3          	add	s1,a0,a4
    80000a9e:	777d                	lui	a4,0xfffff
    80000aa0:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aa2:	94be                	add	s1,s1,a5
    80000aa4:	0295e263          	bltu	a1,s1,80000ac8 <freerange+0x3e>
    80000aa8:	e84a                	sd	s2,16(sp)
    80000aaa:	e44e                	sd	s3,8(sp)
    80000aac:	e052                	sd	s4,0(sp)
    80000aae:	892e                	mv	s2,a1
    kfree(p);
    80000ab0:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ab2:	89be                	mv	s3,a5
    kfree(p);
    80000ab4:	01448533          	add	a0,s1,s4
    80000ab8:	f29ff0ef          	jal	800009e0 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000abc:	94ce                	add	s1,s1,s3
    80000abe:	fe997be3          	bgeu	s2,s1,80000ab4 <freerange+0x2a>
    80000ac2:	6942                	ld	s2,16(sp)
    80000ac4:	69a2                	ld	s3,8(sp)
    80000ac6:	6a02                	ld	s4,0(sp)
}
    80000ac8:	70a2                	ld	ra,40(sp)
    80000aca:	7402                	ld	s0,32(sp)
    80000acc:	64e2                	ld	s1,24(sp)
    80000ace:	6145                	addi	sp,sp,48
    80000ad0:	8082                	ret

0000000080000ad2 <kinit>:
{
    80000ad2:	1141                	addi	sp,sp,-16
    80000ad4:	e406                	sd	ra,8(sp)
    80000ad6:	e022                	sd	s0,0(sp)
    80000ad8:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ada:	00007597          	auipc	a1,0x7
    80000ade:	57658593          	addi	a1,a1,1398 # 80008050 <etext+0x50>
    80000ae2:	00010517          	auipc	a0,0x10
    80000ae6:	23e50513          	addi	a0,a0,574 # 80010d20 <kmem>
    80000aea:	1be000ef          	jal	80000ca8 <initlock>
  initlock(&ref.lock, "ref");
    80000aee:	00007597          	auipc	a1,0x7
    80000af2:	56a58593          	addi	a1,a1,1386 # 80008058 <etext+0x58>
    80000af6:	00010517          	auipc	a0,0x10
    80000afa:	24a50513          	addi	a0,a0,586 # 80010d40 <ref>
    80000afe:	1aa000ef          	jal	80000ca8 <initlock>
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b02:	00010797          	auipc	a5,0x10
    80000b06:	25678793          	addi	a5,a5,598 # 80010d58 <ref+0x18>
    80000b0a:	00230697          	auipc	a3,0x230
    80000b0e:	24e68693          	addi	a3,a3,590 # 80230d58 <pid_lock>
    ref.refcnt[i] = 1;
    80000b12:	4705                	li	a4,1
    80000b14:	c398                	sw	a4,0(a5)
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b16:	0791                	addi	a5,a5,4
    80000b18:	fed79ee3          	bne	a5,a3,80000b14 <kinit+0x42>
  freerange(end, (void*)PHYSTOP);
    80000b1c:	45c5                	li	a1,17
    80000b1e:	05ee                	slli	a1,a1,0x1b
    80000b20:	00250517          	auipc	a0,0x250
    80000b24:	e4850513          	addi	a0,a0,-440 # 80250968 <end>
    80000b28:	f63ff0ef          	jal	80000a8a <freerange>
}
    80000b2c:	60a2                	ld	ra,8(sp)
    80000b2e:	6402                	ld	s0,0(sp)
    80000b30:	0141                	addi	sp,sp,16
    80000b32:	8082                	ret

0000000080000b34 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b34:	1101                	addi	sp,sp,-32
    80000b36:	ec06                	sd	ra,24(sp)
    80000b38:	e822                	sd	s0,16(sp)
    80000b3a:	e426                	sd	s1,8(sp)
    80000b3c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b3e:	00010497          	auipc	s1,0x10
    80000b42:	1e248493          	addi	s1,s1,482 # 80010d20 <kmem>
    80000b46:	8526                	mv	a0,s1
    80000b48:	1da000ef          	jal	80000d22 <acquire>
  r = kmem.freelist;
    80000b4c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4e:	c4b9                	beqz	s1,80000b9c <kalloc+0x68>
    kmem.freelist = r->next;
    80000b50:	609c                	ld	a5,0(s1)
    80000b52:	00010517          	auipc	a0,0x10
    80000b56:	1ce50513          	addi	a0,a0,462 # 80010d20 <kmem>
    80000b5a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5c:	24e000ef          	jal	80000daa <release>

  if(r){
    memset((char*)r, 5, PGSIZE);
    80000b60:	6605                	lui	a2,0x1
    80000b62:	4595                	li	a1,5
    80000b64:	8526                	mv	a0,s1
    80000b66:	27c000ef          	jal	80000de2 <memset>

    acquire(&ref.lock);
    80000b6a:	00010517          	auipc	a0,0x10
    80000b6e:	1d650513          	addi	a0,a0,470 # 80010d40 <ref>
    80000b72:	1b0000ef          	jal	80000d22 <acquire>
    ref.refcnt[(uint64)r / PGSIZE] = 1;
    80000b76:	00010517          	auipc	a0,0x10
    80000b7a:	1ca50513          	addi	a0,a0,458 # 80010d40 <ref>
    80000b7e:	00c4d793          	srli	a5,s1,0xc
    80000b82:	0791                	addi	a5,a5,4
    80000b84:	078a                	slli	a5,a5,0x2
    80000b86:	97aa                	add	a5,a5,a0
    80000b88:	4705                	li	a4,1
    80000b8a:	c798                	sw	a4,8(a5)
    release(&ref.lock);
    80000b8c:	21e000ef          	jal	80000daa <release>
  }

  return (void*)r;
}
    80000b90:	8526                	mv	a0,s1
    80000b92:	60e2                	ld	ra,24(sp)
    80000b94:	6442                	ld	s0,16(sp)
    80000b96:	64a2                	ld	s1,8(sp)
    80000b98:	6105                	addi	sp,sp,32
    80000b9a:	8082                	ret
  release(&kmem.lock);
    80000b9c:	00010517          	auipc	a0,0x10
    80000ba0:	18450513          	addi	a0,a0,388 # 80010d20 <kmem>
    80000ba4:	206000ef          	jal	80000daa <release>
  if(r){
    80000ba8:	b7e5                	j	80000b90 <kalloc+0x5c>

0000000080000baa <incref>:

void
incref(void *pa)
{
    80000baa:	1101                	addi	sp,sp,-32
    80000bac:	ec06                	sd	ra,24(sp)
    80000bae:	e822                	sd	s0,16(sp)
    80000bb0:	e426                	sd	s1,8(sp)
    80000bb2:	1000                	addi	s0,sp,32
  int index = (uint64)pa / PGSIZE;
    80000bb4:	00c55493          	srli	s1,a0,0xc
    80000bb8:	2481                	sext.w	s1,s1

  acquire(&ref.lock);
    80000bba:	00010517          	auipc	a0,0x10
    80000bbe:	18650513          	addi	a0,a0,390 # 80010d40 <ref>
    80000bc2:	160000ef          	jal	80000d22 <acquire>
  ref.refcnt[index]++;
    80000bc6:	00010517          	auipc	a0,0x10
    80000bca:	17a50513          	addi	a0,a0,378 # 80010d40 <ref>
    80000bce:	00448793          	addi	a5,s1,4
    80000bd2:	078a                	slli	a5,a5,0x2
    80000bd4:	97aa                	add	a5,a5,a0
    80000bd6:	4798                	lw	a4,8(a5)
    80000bd8:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdae699>
    80000bda:	c798                	sw	a4,8(a5)
  release(&ref.lock);
    80000bdc:	1ce000ef          	jal	80000daa <release>
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret

0000000080000bea <getref>:

int
getref(void *pa)
{
    80000bea:	1101                	addi	sp,sp,-32
    80000bec:	ec06                	sd	ra,24(sp)
    80000bee:	e822                	sd	s0,16(sp)
    80000bf0:	e426                	sd	s1,8(sp)
    80000bf2:	1000                	addi	s0,sp,32
    80000bf4:	84aa                	mv	s1,a0
  int index = (uint64)pa / PGSIZE;
  int count;

  acquire(&ref.lock);
    80000bf6:	00010517          	auipc	a0,0x10
    80000bfa:	14a50513          	addi	a0,a0,330 # 80010d40 <ref>
    80000bfe:	124000ef          	jal	80000d22 <acquire>
  count = ref.refcnt[index];
    80000c02:	00010517          	auipc	a0,0x10
    80000c06:	13e50513          	addi	a0,a0,318 # 80010d40 <ref>
  int index = (uint64)pa / PGSIZE;
    80000c0a:	00c4d793          	srli	a5,s1,0xc
  count = ref.refcnt[index];
    80000c0e:	2781                	sext.w	a5,a5
    80000c10:	0791                	addi	a5,a5,4
    80000c12:	078a                	slli	a5,a5,0x2
    80000c14:	97aa                	add	a5,a5,a0
    80000c16:	4784                	lw	s1,8(a5)
  release(&ref.lock);
    80000c18:	192000ef          	jal	80000daa <release>

  return count;
}
    80000c1c:	8526                	mv	a0,s1
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret

0000000080000c28 <decref>:

void
decref(void *pa)
{
    80000c28:	1141                	addi	sp,sp,-16
    80000c2a:	e406                	sd	ra,8(sp)
    80000c2c:	e022                	sd	s0,0(sp)
    80000c2e:	0800                	addi	s0,sp,16
  kfree(pa);
    80000c30:	db1ff0ef          	jal	800009e0 <kfree>
}
    80000c34:	60a2                	ld	ra,8(sp)
    80000c36:	6402                	ld	s0,0(sp)
    80000c38:	0141                	addi	sp,sp,16
    80000c3a:	8082                	ret

0000000080000c3c <kfreemem>:

uint64
kfreemem(void)
{
    80000c3c:	1101                	addi	sp,sp,-32
    80000c3e:	ec06                	sd	ra,24(sp)
    80000c40:	e822                	sd	s0,16(sp)
    80000c42:	e426                	sd	s1,8(sp)
    80000c44:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 free_bytes = 0;

  acquire(&kmem.lock);
    80000c46:	00010497          	auipc	s1,0x10
    80000c4a:	0da48493          	addi	s1,s1,218 # 80010d20 <kmem>
    80000c4e:	8526                	mv	a0,s1
    80000c50:	0d2000ef          	jal	80000d22 <acquire>
  for(r = kmem.freelist; r != 0; r = r->next)
    80000c54:	6c9c                	ld	a5,24(s1)
    80000c56:	c395                	beqz	a5,80000c7a <kfreemem+0x3e>
  uint64 free_bytes = 0;
    80000c58:	4481                	li	s1,0
    free_bytes += PGSIZE;
    80000c5a:	6705                	lui	a4,0x1
    80000c5c:	94ba                	add	s1,s1,a4
  for(r = kmem.freelist; r != 0; r = r->next)
    80000c5e:	639c                	ld	a5,0(a5)
    80000c60:	fff5                	bnez	a5,80000c5c <kfreemem+0x20>
  release(&kmem.lock);
    80000c62:	00010517          	auipc	a0,0x10
    80000c66:	0be50513          	addi	a0,a0,190 # 80010d20 <kmem>
    80000c6a:	140000ef          	jal	80000daa <release>

  return free_bytes;
}
    80000c6e:	8526                	mv	a0,s1
    80000c70:	60e2                	ld	ra,24(sp)
    80000c72:	6442                	ld	s0,16(sp)
    80000c74:	64a2                	ld	s1,8(sp)
    80000c76:	6105                	addi	sp,sp,32
    80000c78:	8082                	ret
  uint64 free_bytes = 0;
    80000c7a:	4481                	li	s1,0
    80000c7c:	b7dd                	j	80000c62 <kfreemem+0x26>

0000000080000c7e <ktotalmem>:

uint64
ktotalmem(void)
{
    80000c7e:	1141                	addi	sp,sp,-16
    80000c80:	e406                	sd	ra,8(sp)
    80000c82:	e022                	sd	s0,0(sp)
    80000c84:	0800                	addi	s0,sp,16
  uint64 start = PGROUNDUP((uint64)end);
    80000c86:	00251797          	auipc	a5,0x251
    80000c8a:	ce178793          	addi	a5,a5,-799 # 80251967 <end+0xfff>
    80000c8e:	777d                	lui	a4,0xfffff
    80000c90:	8ff9                	and	a5,a5,a4
  if(PHYSTOP <= start)
    80000c92:	4745                	li	a4,17
    80000c94:	076e                	slli	a4,a4,0x1b
    return 0;
    80000c96:	4501                	li	a0,0
  if(PHYSTOP <= start)
    80000c98:	00e7f463          	bgeu	a5,a4,80000ca0 <ktotalmem+0x22>
  return PHYSTOP - start;
    80000c9c:	40f70533          	sub	a0,a4,a5
}
    80000ca0:	60a2                	ld	ra,8(sp)
    80000ca2:	6402                	ld	s0,0(sp)
    80000ca4:	0141                	addi	sp,sp,16
    80000ca6:	8082                	ret

0000000080000ca8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000ca8:	1141                	addi	sp,sp,-16
    80000caa:	e406                	sd	ra,8(sp)
    80000cac:	e022                	sd	s0,0(sp)
    80000cae:	0800                	addi	s0,sp,16
  lk->name = name;
    80000cb0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000cb2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000cb6:	00053823          	sd	zero,16(a0)
}
    80000cba:	60a2                	ld	ra,8(sp)
    80000cbc:	6402                	ld	s0,0(sp)
    80000cbe:	0141                	addi	sp,sp,16
    80000cc0:	8082                	ret

0000000080000cc2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cc2:	411c                	lw	a5,0(a0)
    80000cc4:	e399                	bnez	a5,80000cca <holding+0x8>
    80000cc6:	4501                	li	a0,0
  return r;
}
    80000cc8:	8082                	ret
{
    80000cca:	1101                	addi	sp,sp,-32
    80000ccc:	ec06                	sd	ra,24(sp)
    80000cce:	e822                	sd	s0,16(sp)
    80000cd0:	e426                	sd	s1,8(sp)
    80000cd2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000cd4:	6904                	ld	s1,16(a0)
    80000cd6:	300010ef          	jal	80001fd6 <mycpu>
    80000cda:	40a48533          	sub	a0,s1,a0
    80000cde:	00153513          	seqz	a0,a0
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret

0000000080000cec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cec:	1101                	addi	sp,sp,-32
    80000cee:	ec06                	sd	ra,24(sp)
    80000cf0:	e822                	sd	s0,16(sp)
    80000cf2:	e426                	sd	s1,8(sp)
    80000cf4:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000cf6:	100174f3          	csrrci	s1,sstatus,2
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000cfa:	2dc010ef          	jal	80001fd6 <mycpu>
    80000cfe:	5d3c                	lw	a5,120(a0)
    80000d00:	cb99                	beqz	a5,80000d16 <push_off+0x2a>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d02:	2d4010ef          	jal	80001fd6 <mycpu>
    80000d06:	5d3c                	lw	a5,120(a0)
    80000d08:	2785                	addiw	a5,a5,1
    80000d0a:	dd3c                	sw	a5,120(a0)
}
    80000d0c:	60e2                	ld	ra,24(sp)
    80000d0e:	6442                	ld	s0,16(sp)
    80000d10:	64a2                	ld	s1,8(sp)
    80000d12:	6105                	addi	sp,sp,32
    80000d14:	8082                	ret
    mycpu()->intena = old;
    80000d16:	2c0010ef          	jal	80001fd6 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000d1a:	8085                	srli	s1,s1,0x1
    80000d1c:	8885                	andi	s1,s1,1
    mycpu()->intena = old;
    80000d1e:	dd64                	sw	s1,124(a0)
    80000d20:	b7cd                	j	80000d02 <push_off+0x16>

0000000080000d22 <acquire>:
{
    80000d22:	1101                	addi	sp,sp,-32
    80000d24:	ec06                	sd	ra,24(sp)
    80000d26:	e822                	sd	s0,16(sp)
    80000d28:	e426                	sd	s1,8(sp)
    80000d2a:	1000                	addi	s0,sp,32
    80000d2c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d2e:	fbfff0ef          	jal	80000cec <push_off>
  if (holding(lk))
    80000d32:	8526                	mv	a0,s1
    80000d34:	f8fff0ef          	jal	80000cc2 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000d38:	4705                	li	a4,1
  if (holding(lk))
    80000d3a:	ed11                	bnez	a0,80000d56 <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000d3c:	87ba                	mv	a5,a4
    80000d3e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d42:	2781                	sext.w	a5,a5
    80000d44:	ffe5                	bnez	a5,80000d3c <acquire+0x1a>
  lk->cpu = mycpu();
    80000d46:	290010ef          	jal	80001fd6 <mycpu>
    80000d4a:	e888                	sd	a0,16(s1)
}
    80000d4c:	60e2                	ld	ra,24(sp)
    80000d4e:	6442                	ld	s0,16(sp)
    80000d50:	64a2                	ld	s1,8(sp)
    80000d52:	6105                	addi	sp,sp,32
    80000d54:	8082                	ret
    panic("acquire");
    80000d56:	00007517          	auipc	a0,0x7
    80000d5a:	30a50513          	addi	a0,a0,778 # 80008060 <etext+0x60>
    80000d5e:	a91ff0ef          	jal	800007ee <panic>

0000000080000d62 <pop_off>:

void
pop_off(void)
{
    80000d62:	1141                	addi	sp,sp,-16
    80000d64:	e406                	sd	ra,8(sp)
    80000d66:	e022                	sd	s0,0(sp)
    80000d68:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d6a:	26c010ef          	jal	80001fd6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d6e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d72:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000d74:	ef99                	bnez	a5,80000d92 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000d76:	5d3c                	lw	a5,120(a0)
    80000d78:	02f05363          	blez	a5,80000d9e <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000d7c:	37fd                	addiw	a5,a5,-1
    80000d7e:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000d80:	e789                	bnez	a5,80000d8a <pop_off+0x28>
    80000d82:	5d7c                	lw	a5,124(a0)
    80000d84:	c399                	beqz	a5,80000d8a <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000d86:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000d8a:	60a2                	ld	ra,8(sp)
    80000d8c:	6402                	ld	s0,0(sp)
    80000d8e:	0141                	addi	sp,sp,16
    80000d90:	8082                	ret
    panic("pop_off - interruptible");
    80000d92:	00007517          	auipc	a0,0x7
    80000d96:	2d650513          	addi	a0,a0,726 # 80008068 <etext+0x68>
    80000d9a:	a55ff0ef          	jal	800007ee <panic>
    panic("pop_off");
    80000d9e:	00007517          	auipc	a0,0x7
    80000da2:	2e250513          	addi	a0,a0,738 # 80008080 <etext+0x80>
    80000da6:	a49ff0ef          	jal	800007ee <panic>

0000000080000daa <release>:
{
    80000daa:	1101                	addi	sp,sp,-32
    80000dac:	ec06                	sd	ra,24(sp)
    80000dae:	e822                	sd	s0,16(sp)
    80000db0:	e426                	sd	s1,8(sp)
    80000db2:	1000                	addi	s0,sp,32
    80000db4:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000db6:	f0dff0ef          	jal	80000cc2 <holding>
    80000dba:	cd11                	beqz	a0,80000dd6 <release+0x2c>
  lk->cpu = 0;
    80000dbc:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000dc0:	0310000f          	fence	rw,w
    80000dc4:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000dc8:	f9bff0ef          	jal	80000d62 <pop_off>
}
    80000dcc:	60e2                	ld	ra,24(sp)
    80000dce:	6442                	ld	s0,16(sp)
    80000dd0:	64a2                	ld	s1,8(sp)
    80000dd2:	6105                	addi	sp,sp,32
    80000dd4:	8082                	ret
    panic("release");
    80000dd6:	00007517          	auipc	a0,0x7
    80000dda:	2b250513          	addi	a0,a0,690 # 80008088 <etext+0x88>
    80000dde:	a11ff0ef          	jal	800007ee <panic>

0000000080000de2 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000de2:	1141                	addi	sp,sp,-16
    80000de4:	e406                	sd	ra,8(sp)
    80000de6:	e022                	sd	s0,0(sp)
    80000de8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000dea:	ca19                	beqz	a2,80000e00 <memset+0x1e>
    80000dec:	87aa                	mv	a5,a0
    80000dee:	1602                	slli	a2,a2,0x20
    80000df0:	9201                	srli	a2,a2,0x20
    80000df2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000df6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000dfa:	0785                	addi	a5,a5,1
    80000dfc:	fee79de3          	bne	a5,a4,80000df6 <memset+0x14>
  }
  return dst;
}
    80000e00:	60a2                	ld	ra,8(sp)
    80000e02:	6402                	ld	s0,0(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret

0000000080000e08 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e08:	1141                	addi	sp,sp,-16
    80000e0a:	e406                	sd	ra,8(sp)
    80000e0c:	e022                	sd	s0,0(sp)
    80000e0e:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000e10:	ca0d                	beqz	a2,80000e42 <memcmp+0x3a>
    80000e12:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e16:	1682                	slli	a3,a3,0x20
    80000e18:	9281                	srli	a3,a3,0x20
    80000e1a:	0685                	addi	a3,a3,1
    80000e1c:	96aa                	add	a3,a3,a0
    if (*s1 != *s2)
    80000e1e:	00054783          	lbu	a5,0(a0)
    80000e22:	0005c703          	lbu	a4,0(a1)
    80000e26:	00e79863          	bne	a5,a4,80000e36 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000e2a:	0505                	addi	a0,a0,1
    80000e2c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000e2e:	fed518e3          	bne	a0,a3,80000e1e <memcmp+0x16>
  }

  return 0;
    80000e32:	4501                	li	a0,0
    80000e34:	a019                	j	80000e3a <memcmp+0x32>
      return *s1 - *s2;
    80000e36:	40e7853b          	subw	a0,a5,a4
}
    80000e3a:	60a2                	ld	ra,8(sp)
    80000e3c:	6402                	ld	s0,0(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret
  return 0;
    80000e42:	4501                	li	a0,0
    80000e44:	bfdd                	j	80000e3a <memcmp+0x32>

0000000080000e46 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e406                	sd	ra,8(sp)
    80000e4a:	e022                	sd	s0,0(sp)
    80000e4c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000e4e:	c205                	beqz	a2,80000e6e <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000e50:	02a5e363          	bltu	a1,a0,80000e76 <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000e54:	1602                	slli	a2,a2,0x20
    80000e56:	9201                	srli	a2,a2,0x20
    80000e58:	00c587b3          	add	a5,a1,a2
{
    80000e5c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e5e:	0585                	addi	a1,a1,1
    80000e60:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdae699>
    80000e62:	fff5c683          	lbu	a3,-1(a1)
    80000e66:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000e6a:	feb79ae3          	bne	a5,a1,80000e5e <memmove+0x18>

  return dst;
}
    80000e6e:	60a2                	ld	ra,8(sp)
    80000e70:	6402                	ld	s0,0(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret
  if (s < d && s + n > d) {
    80000e76:	02061693          	slli	a3,a2,0x20
    80000e7a:	9281                	srli	a3,a3,0x20
    80000e7c:	00d58733          	add	a4,a1,a3
    80000e80:	fce57ae3          	bgeu	a0,a4,80000e54 <memmove+0xe>
    d += n;
    80000e84:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000e86:	fff6079b          	addiw	a5,a2,-1
    80000e8a:	1782                	slli	a5,a5,0x20
    80000e8c:	9381                	srli	a5,a5,0x20
    80000e8e:	fff7c793          	not	a5,a5
    80000e92:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e94:	177d                	addi	a4,a4,-1
    80000e96:	16fd                	addi	a3,a3,-1
    80000e98:	00074603          	lbu	a2,0(a4)
    80000e9c:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000ea0:	fee79ae3          	bne	a5,a4,80000e94 <memmove+0x4e>
    80000ea4:	b7e9                	j	80000e6e <memmove+0x28>

0000000080000ea6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000ea6:	1141                	addi	sp,sp,-16
    80000ea8:	e406                	sd	ra,8(sp)
    80000eaa:	e022                	sd	s0,0(sp)
    80000eac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000eae:	f99ff0ef          	jal	80000e46 <memmove>
}
    80000eb2:	60a2                	ld	ra,8(sp)
    80000eb4:	6402                	ld	s0,0(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret

0000000080000eba <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000eba:	1141                	addi	sp,sp,-16
    80000ebc:	e406                	sd	ra,8(sp)
    80000ebe:	e022                	sd	s0,0(sp)
    80000ec0:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000ec2:	ce11                	beqz	a2,80000ede <strncmp+0x24>
    80000ec4:	00054783          	lbu	a5,0(a0)
    80000ec8:	cf89                	beqz	a5,80000ee2 <strncmp+0x28>
    80000eca:	0005c703          	lbu	a4,0(a1)
    80000ece:	00f71a63          	bne	a4,a5,80000ee2 <strncmp+0x28>
    n--, p++, q++;
    80000ed2:	367d                	addiw	a2,a2,-1
    80000ed4:	0505                	addi	a0,a0,1
    80000ed6:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000ed8:	f675                	bnez	a2,80000ec4 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000eda:	4501                	li	a0,0
    80000edc:	a801                	j	80000eec <strncmp+0x32>
    80000ede:	4501                	li	a0,0
    80000ee0:	a031                	j	80000eec <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000ee2:	00054503          	lbu	a0,0(a0)
    80000ee6:	0005c783          	lbu	a5,0(a1)
    80000eea:	9d1d                	subw	a0,a0,a5
}
    80000eec:	60a2                	ld	ra,8(sp)
    80000eee:	6402                	ld	s0,0(sp)
    80000ef0:	0141                	addi	sp,sp,16
    80000ef2:	8082                	ret

0000000080000ef4 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000ef4:	1141                	addi	sp,sp,-16
    80000ef6:	e406                	sd	ra,8(sp)
    80000ef8:	e022                	sd	s0,0(sp)
    80000efa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000efc:	87aa                	mv	a5,a0
    80000efe:	86b2                	mv	a3,a2
    80000f00:	367d                	addiw	a2,a2,-1
    80000f02:	02d05563          	blez	a3,80000f2c <strncpy+0x38>
    80000f06:	0785                	addi	a5,a5,1
    80000f08:	0005c703          	lbu	a4,0(a1)
    80000f0c:	fee78fa3          	sb	a4,-1(a5)
    80000f10:	0585                	addi	a1,a1,1
    80000f12:	f775                	bnez	a4,80000efe <strncpy+0xa>
    ;
  while (n-- > 0)
    80000f14:	873e                	mv	a4,a5
    80000f16:	00c05b63          	blez	a2,80000f2c <strncpy+0x38>
    80000f1a:	9fb5                	addw	a5,a5,a3
    80000f1c:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000f1e:	0705                	addi	a4,a4,1
    80000f20:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000f24:	40e786bb          	subw	a3,a5,a4
    80000f28:	fed04be3          	bgtz	a3,80000f1e <strncpy+0x2a>
  return os;
}
    80000f2c:	60a2                	ld	ra,8(sp)
    80000f2e:	6402                	ld	s0,0(sp)
    80000f30:	0141                	addi	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e406                	sd	ra,8(sp)
    80000f38:	e022                	sd	s0,0(sp)
    80000f3a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000f3c:	02c05363          	blez	a2,80000f62 <safestrcpy+0x2e>
    80000f40:	fff6069b          	addiw	a3,a2,-1
    80000f44:	1682                	slli	a3,a3,0x20
    80000f46:	9281                	srli	a3,a3,0x20
    80000f48:	96ae                	add	a3,a3,a1
    80000f4a:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000f4c:	00d58963          	beq	a1,a3,80000f5e <safestrcpy+0x2a>
    80000f50:	0585                	addi	a1,a1,1
    80000f52:	0785                	addi	a5,a5,1
    80000f54:	fff5c703          	lbu	a4,-1(a1)
    80000f58:	fee78fa3          	sb	a4,-1(a5)
    80000f5c:	fb65                	bnez	a4,80000f4c <safestrcpy+0x18>
    ;
  *s = 0;
    80000f5e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f62:	60a2                	ld	ra,8(sp)
    80000f64:	6402                	ld	s0,0(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <strlen>:

int
strlen(const char *s)
{
    80000f6a:	1141                	addi	sp,sp,-16
    80000f6c:	e406                	sd	ra,8(sp)
    80000f6e:	e022                	sd	s0,0(sp)
    80000f70:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000f72:	00054783          	lbu	a5,0(a0)
    80000f76:	cf99                	beqz	a5,80000f94 <strlen+0x2a>
    80000f78:	0505                	addi	a0,a0,1
    80000f7a:	87aa                	mv	a5,a0
    80000f7c:	86be                	mv	a3,a5
    80000f7e:	0785                	addi	a5,a5,1
    80000f80:	fff7c703          	lbu	a4,-1(a5)
    80000f84:	ff65                	bnez	a4,80000f7c <strlen+0x12>
    80000f86:	40a6853b          	subw	a0,a3,a0
    80000f8a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000f8c:	60a2                	ld	ra,8(sp)
    80000f8e:	6402                	ld	s0,0(sp)
    80000f90:	0141                	addi	sp,sp,16
    80000f92:	8082                	ret
  for (n = 0; s[n]; n++)
    80000f94:	4501                	li	a0,0
    80000f96:	bfdd                	j	80000f8c <strlen+0x22>

0000000080000f98 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f98:	1141                	addi	sp,sp,-16
    80000f9a:	e406                	sd	ra,8(sp)
    80000f9c:	e022                	sd	s0,0(sp)
    80000f9e:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000fa0:	022010ef          	jal	80001fc2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000fa4:	00008717          	auipc	a4,0x8
    80000fa8:	c6870713          	addi	a4,a4,-920 # 80008c0c <started>
  if (cpuid() == 0) {
    80000fac:	c51d                	beqz	a0,80000fda <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000fae:	431c                	lw	a5,0(a4)
    80000fb0:	0230000f          	fence	r,rw
    80000fb4:	2781                	sext.w	a5,a5
    80000fb6:	dfe5                	beqz	a5,80000fae <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000fb8:	00a010ef          	jal	80001fc2 <cpuid>
    80000fbc:	85aa                	mv	a1,a0
    80000fbe:	00007517          	auipc	a0,0x7
    80000fc2:	0f250513          	addi	a0,a0,242 # 800080b0 <etext+0xb0>
    80000fc6:	d44ff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80000fca:	082000ef          	jal	8000104c <kvminithart>
    trapinithart(); // install kernel trap vector
    80000fce:	0de020ef          	jal	800030ac <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000fd2:	786050ef          	jal	80006758 <plicinithart>
  }

  scheduler();
    80000fd6:	560010ef          	jal	80002536 <scheduler>
    consoleinit();
    80000fda:	c62ff0ef          	jal	8000043c <consoleinit>
    printkinit();
    80000fde:	84dff0ef          	jal	8000082a <printkinit>
    printk("\n");
    80000fe2:	00007517          	auipc	a0,0x7
    80000fe6:	0ae50513          	addi	a0,a0,174 # 80008090 <etext+0x90>
    80000fea:	d20ff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80000fee:	00007517          	auipc	a0,0x7
    80000ff2:	0aa50513          	addi	a0,a0,170 # 80008098 <etext+0x98>
    80000ff6:	d14ff0ef          	jal	8000050a <printk>
    printk("\n");
    80000ffa:	00007517          	auipc	a0,0x7
    80000ffe:	09650513          	addi	a0,a0,150 # 80008090 <etext+0x90>
    80001002:	d08ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    80001006:	acdff0ef          	jal	80000ad2 <kinit>
    kvminit();          // create kernel page table
    8000100a:	2e0000ef          	jal	800012ea <kvminit>
    kvminithart();      // turn on paging
    8000100e:	03e000ef          	jal	8000104c <kvminithart>
    procinit();         // process table
    80001012:	701000ef          	jal	80001f12 <procinit>
    trapinit();         // trap vectors
    80001016:	072020ef          	jal	80003088 <trapinit>
    trapinithart();     // install kernel trap vector
    8000101a:	092020ef          	jal	800030ac <trapinithart>
    plicinit();         // set up interrupt controller
    8000101e:	720050ef          	jal	8000673e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80001022:	736050ef          	jal	80006758 <plicinithart>
    binit();            // buffer cache
    80001026:	3ef020ef          	jal	80003c14 <binit>
    iinit();            // inode table
    8000102a:	14e030ef          	jal	80004178 <iinit>
    fileinit();         // file table
    8000102e:	15e040ef          	jal	8000518c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001032:	017050ef          	jal	80006848 <virtio_disk_init>
    userinit();         // first user process
    80001036:	2e0010ef          	jal	80002316 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    8000103a:	00008797          	auipc	a5,0x8
    8000103e:	bd278793          	addi	a5,a5,-1070 # 80008c0c <started>
    80001042:	4705                	li	a4,1
    80001044:	0310000f          	fence	rw,w
    80001048:	c398                	sw	a4,0(a5)
    8000104a:	b771                	j	80000fd6 <main+0x3e>

000000008000104c <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000104c:	1141                	addi	sp,sp,-16
    8000104e:	e406                	sd	ra,8(sp)
    80001050:	e022                	sd	s0,0(sp)
    80001052:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80001054:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001058:	00008797          	auipc	a5,0x8
    8000105c:	bb87b783          	ld	a5,-1096(a5) # 80008c10 <kernel_pagetable>
    80001060:	83b1                	srli	a5,a5,0xc
    80001062:	577d                	li	a4,-1
    80001064:	177e                	slli	a4,a4,0x3f
    80001066:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80001068:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    8000106c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001070:	60a2                	ld	ra,8(sp)
    80001072:	6402                	ld	s0,0(sp)
    80001074:	0141                	addi	sp,sp,16
    80001076:	8082                	ret

0000000080001078 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001078:	7139                	addi	sp,sp,-64
    8000107a:	fc06                	sd	ra,56(sp)
    8000107c:	f822                	sd	s0,48(sp)
    8000107e:	f426                	sd	s1,40(sp)
    80001080:	f04a                	sd	s2,32(sp)
    80001082:	ec4e                	sd	s3,24(sp)
    80001084:	e852                	sd	s4,16(sp)
    80001086:	e456                	sd	s5,8(sp)
    80001088:	e05a                	sd	s6,0(sp)
    8000108a:	0080                	addi	s0,sp,64
    8000108c:	84aa                	mv	s1,a0
    8000108e:	89ae                	mv	s3,a1
    80001090:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80001092:	57fd                	li	a5,-1
    80001094:	83e9                	srli	a5,a5,0x1a
    80001096:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80001098:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000109a:	04b7e263          	bltu	a5,a1,800010de <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000109e:	0149d933          	srl	s2,s3,s4
    800010a2:	1ff97913          	andi	s2,s2,511
    800010a6:	090e                	slli	s2,s2,0x3
    800010a8:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800010aa:	00093483          	ld	s1,0(s2)
    800010ae:	0014f793          	andi	a5,s1,1
    800010b2:	cf85                	beqz	a5,800010ea <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010b4:	80a9                	srli	s1,s1,0xa
    800010b6:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    800010b8:	3a5d                	addiw	s4,s4,-9
    800010ba:	ff6a12e3          	bne	s4,s6,8000109e <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800010be:	00c9d513          	srli	a0,s3,0xc
    800010c2:	1ff57513          	andi	a0,a0,511
    800010c6:	050e                	slli	a0,a0,0x3
    800010c8:	9526                	add	a0,a0,s1
}
    800010ca:	70e2                	ld	ra,56(sp)
    800010cc:	7442                	ld	s0,48(sp)
    800010ce:	74a2                	ld	s1,40(sp)
    800010d0:	7902                	ld	s2,32(sp)
    800010d2:	69e2                	ld	s3,24(sp)
    800010d4:	6a42                	ld	s4,16(sp)
    800010d6:	6aa2                	ld	s5,8(sp)
    800010d8:	6b02                	ld	s6,0(sp)
    800010da:	6121                	addi	sp,sp,64
    800010dc:	8082                	ret
    panic("walk");
    800010de:	00007517          	auipc	a0,0x7
    800010e2:	fea50513          	addi	a0,a0,-22 # 800080c8 <etext+0xc8>
    800010e6:	f08ff0ef          	jal	800007ee <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800010ea:	020a8263          	beqz	s5,8000110e <walk+0x96>
    800010ee:	a47ff0ef          	jal	80000b34 <kalloc>
    800010f2:	84aa                	mv	s1,a0
    800010f4:	d979                	beqz	a0,800010ca <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010f6:	6605                	lui	a2,0x1
    800010f8:	4581                	li	a1,0
    800010fa:	ce9ff0ef          	jal	80000de2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010fe:	00c4d793          	srli	a5,s1,0xc
    80001102:	07aa                	slli	a5,a5,0xa
    80001104:	0017e793          	ori	a5,a5,1
    80001108:	00f93023          	sd	a5,0(s2)
    8000110c:	b775                	j	800010b8 <walk+0x40>
        return 0;
    8000110e:	4501                	li	a0,0
    80001110:	bf6d                	j	800010ca <walk+0x52>

0000000080001112 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80001112:	57fd                	li	a5,-1
    80001114:	83e9                	srli	a5,a5,0x1a
    80001116:	00b7f463          	bgeu	a5,a1,8000111e <walkaddr+0xc>
    return 0;
    8000111a:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000111c:	8082                	ret
{
    8000111e:	1141                	addi	sp,sp,-16
    80001120:	e406                	sd	ra,8(sp)
    80001122:	e022                	sd	s0,0(sp)
    80001124:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001126:	4601                	li	a2,0
    80001128:	f51ff0ef          	jal	80001078 <walk>
  if (pte == 0)
    8000112c:	c105                	beqz	a0,8000114c <walkaddr+0x3a>
  if ((*pte & PTE_V) == 0)
    8000112e:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80001130:	0117f693          	andi	a3,a5,17
    80001134:	4745                	li	a4,17
    return 0;
    80001136:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001138:	00e68663          	beq	a3,a4,80001144 <walkaddr+0x32>
}
    8000113c:	60a2                	ld	ra,8(sp)
    8000113e:	6402                	ld	s0,0(sp)
    80001140:	0141                	addi	sp,sp,16
    80001142:	8082                	ret
  pa = PTE2PA(*pte);
    80001144:	83a9                	srli	a5,a5,0xa
    80001146:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000114a:	bfcd                	j	8000113c <walkaddr+0x2a>
    return 0;
    8000114c:	4501                	li	a0,0
    8000114e:	b7fd                	j	8000113c <walkaddr+0x2a>

0000000080001150 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001150:	715d                	addi	sp,sp,-80
    80001152:	e486                	sd	ra,72(sp)
    80001154:	e0a2                	sd	s0,64(sp)
    80001156:	fc26                	sd	s1,56(sp)
    80001158:	f84a                	sd	s2,48(sp)
    8000115a:	f44e                	sd	s3,40(sp)
    8000115c:	f052                	sd	s4,32(sp)
    8000115e:	ec56                	sd	s5,24(sp)
    80001160:	e85a                	sd	s6,16(sp)
    80001162:	e45e                	sd	s7,8(sp)
    80001164:	e062                	sd	s8,0(sp)
    80001166:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001168:	03459793          	slli	a5,a1,0x34
    8000116c:	e7b1                	bnez	a5,800011b8 <mappages+0x68>
    8000116e:	8aaa                	mv	s5,a0
    80001170:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001172:	03461793          	slli	a5,a2,0x34
    80001176:	e7b9                	bnez	a5,800011c4 <mappages+0x74>
    panic("mappages: size not aligned");

  if (size == 0)
    80001178:	ce21                	beqz	a2,800011d0 <mappages+0x80>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000117a:	77fd                	lui	a5,0xfffff
    8000117c:	963e                	add	a2,a2,a5
    8000117e:	00b609b3          	add	s3,a2,a1
  a = va;
    80001182:	892e                	mv	s2,a1
    80001184:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001188:	4b85                	li	s7,1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000118a:	6c05                	lui	s8,0x1
    8000118c:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001190:	865e                	mv	a2,s7
    80001192:	85ca                	mv	a1,s2
    80001194:	8556                	mv	a0,s5
    80001196:	ee3ff0ef          	jal	80001078 <walk>
    8000119a:	c539                	beqz	a0,800011e8 <mappages+0x98>
    if (*pte & PTE_V)
    8000119c:	611c                	ld	a5,0(a0)
    8000119e:	8b85                	andi	a5,a5,1
    800011a0:	ef95                	bnez	a5,800011dc <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011a2:	80b1                	srli	s1,s1,0xc
    800011a4:	04aa                	slli	s1,s1,0xa
    800011a6:	0164e4b3          	or	s1,s1,s6
    800011aa:	0014e493          	ori	s1,s1,1
    800011ae:	e104                	sd	s1,0(a0)
    if (a == last)
    800011b0:	05390963          	beq	s2,s3,80001202 <mappages+0xb2>
    a += PGSIZE;
    800011b4:	9962                	add	s2,s2,s8
    if ((pte = walk(pagetable, a, 1)) == 0)
    800011b6:	bfd9                	j	8000118c <mappages+0x3c>
    panic("mappages: va not aligned");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	f1850513          	addi	a0,a0,-232 # 800080d0 <etext+0xd0>
    800011c0:	e2eff0ef          	jal	800007ee <panic>
    panic("mappages: size not aligned");
    800011c4:	00007517          	auipc	a0,0x7
    800011c8:	f2c50513          	addi	a0,a0,-212 # 800080f0 <etext+0xf0>
    800011cc:	e22ff0ef          	jal	800007ee <panic>
    panic("mappages: size");
    800011d0:	00007517          	auipc	a0,0x7
    800011d4:	f4050513          	addi	a0,a0,-192 # 80008110 <etext+0x110>
    800011d8:	e16ff0ef          	jal	800007ee <panic>
      panic("mappages: remap");
    800011dc:	00007517          	auipc	a0,0x7
    800011e0:	f4450513          	addi	a0,a0,-188 # 80008120 <etext+0x120>
    800011e4:	e0aff0ef          	jal	800007ee <panic>
      return -1;
    800011e8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011ea:	60a6                	ld	ra,72(sp)
    800011ec:	6406                	ld	s0,64(sp)
    800011ee:	74e2                	ld	s1,56(sp)
    800011f0:	7942                	ld	s2,48(sp)
    800011f2:	79a2                	ld	s3,40(sp)
    800011f4:	7a02                	ld	s4,32(sp)
    800011f6:	6ae2                	ld	s5,24(sp)
    800011f8:	6b42                	ld	s6,16(sp)
    800011fa:	6ba2                	ld	s7,8(sp)
    800011fc:	6c02                	ld	s8,0(sp)
    800011fe:	6161                	addi	sp,sp,80
    80001200:	8082                	ret
  return 0;
    80001202:	4501                	li	a0,0
    80001204:	b7dd                	j	800011ea <mappages+0x9a>

0000000080001206 <kvmmap>:
{
    80001206:	1141                	addi	sp,sp,-16
    80001208:	e406                	sd	ra,8(sp)
    8000120a:	e022                	sd	s0,0(sp)
    8000120c:	0800                	addi	s0,sp,16
    8000120e:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001210:	86b2                	mv	a3,a2
    80001212:	863e                	mv	a2,a5
    80001214:	f3dff0ef          	jal	80001150 <mappages>
    80001218:	e509                	bnez	a0,80001222 <kvmmap+0x1c>
}
    8000121a:	60a2                	ld	ra,8(sp)
    8000121c:	6402                	ld	s0,0(sp)
    8000121e:	0141                	addi	sp,sp,16
    80001220:	8082                	ret
    panic("kvmmap");
    80001222:	00007517          	auipc	a0,0x7
    80001226:	f0e50513          	addi	a0,a0,-242 # 80008130 <etext+0x130>
    8000122a:	dc4ff0ef          	jal	800007ee <panic>

000000008000122e <kvmmake>:
{
    8000122e:	1101                	addi	sp,sp,-32
    80001230:	ec06                	sd	ra,24(sp)
    80001232:	e822                	sd	s0,16(sp)
    80001234:	e426                	sd	s1,8(sp)
    80001236:	e04a                	sd	s2,0(sp)
    80001238:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000123a:	8fbff0ef          	jal	80000b34 <kalloc>
    8000123e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001240:	6605                	lui	a2,0x1
    80001242:	4581                	li	a1,0
    80001244:	b9fff0ef          	jal	80000de2 <memset>
  kvmmap(kpgtbl, VIRT_TEST, VIRT_TEST, PGSIZE, PTE_R | PTE_W);
    80001248:	4719                	li	a4,6
    8000124a:	6685                	lui	a3,0x1
    8000124c:	00100637          	lui	a2,0x100
    80001250:	85b2                	mv	a1,a2
    80001252:	8526                	mv	a0,s1
    80001254:	fb3ff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001258:	4719                	li	a4,6
    8000125a:	6685                	lui	a3,0x1
    8000125c:	10000637          	lui	a2,0x10000
    80001260:	85b2                	mv	a1,a2
    80001262:	8526                	mv	a0,s1
    80001264:	fa3ff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001268:	4719                	li	a4,6
    8000126a:	6685                	lui	a3,0x1
    8000126c:	10001637          	lui	a2,0x10001
    80001270:	85b2                	mv	a1,a2
    80001272:	8526                	mv	a0,s1
    80001274:	f93ff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001278:	4719                	li	a4,6
    8000127a:	040006b7          	lui	a3,0x4000
    8000127e:	0c000637          	lui	a2,0xc000
    80001282:	85b2                	mv	a1,a2
    80001284:	8526                	mv	a0,s1
    80001286:	f81ff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000128a:	00007917          	auipc	s2,0x7
    8000128e:	d7690913          	addi	s2,s2,-650 # 80008000 <etext>
    80001292:	4729                	li	a4,10
    80001294:	80007697          	auipc	a3,0x80007
    80001298:	d6c68693          	addi	a3,a3,-660 # 8000 <_entry-0x7fff8000>
    8000129c:	4605                	li	a2,1
    8000129e:	067e                	slli	a2,a2,0x1f
    800012a0:	85b2                	mv	a1,a2
    800012a2:	8526                	mv	a0,s1
    800012a4:	f63ff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    800012a8:	4719                	li	a4,6
    800012aa:	46c5                	li	a3,17
    800012ac:	06ee                	slli	a3,a3,0x1b
    800012ae:	412686b3          	sub	a3,a3,s2
    800012b2:	864a                	mv	a2,s2
    800012b4:	85ca                	mv	a1,s2
    800012b6:	8526                	mv	a0,s1
    800012b8:	f4fff0ef          	jal	80001206 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012bc:	4729                	li	a4,10
    800012be:	6685                	lui	a3,0x1
    800012c0:	00006617          	auipc	a2,0x6
    800012c4:	d4060613          	addi	a2,a2,-704 # 80007000 <_trampoline>
    800012c8:	040005b7          	lui	a1,0x4000
    800012cc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012ce:	05b2                	slli	a1,a1,0xc
    800012d0:	8526                	mv	a0,s1
    800012d2:	f35ff0ef          	jal	80001206 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012d6:	8526                	mv	a0,s1
    800012d8:	39d000ef          	jal	80001e74 <proc_mapstacks>
}
    800012dc:	8526                	mv	a0,s1
    800012de:	60e2                	ld	ra,24(sp)
    800012e0:	6442                	ld	s0,16(sp)
    800012e2:	64a2                	ld	s1,8(sp)
    800012e4:	6902                	ld	s2,0(sp)
    800012e6:	6105                	addi	sp,sp,32
    800012e8:	8082                	ret

00000000800012ea <kvminit>:
{
    800012ea:	1141                	addi	sp,sp,-16
    800012ec:	e406                	sd	ra,8(sp)
    800012ee:	e022                	sd	s0,0(sp)
    800012f0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012f2:	f3dff0ef          	jal	8000122e <kvmmake>
    800012f6:	00008797          	auipc	a5,0x8
    800012fa:	90a7bd23          	sd	a0,-1766(a5) # 80008c10 <kernel_pagetable>
}
    800012fe:	60a2                	ld	ra,8(sp)
    80001300:	6402                	ld	s0,0(sp)
    80001302:	0141                	addi	sp,sp,16
    80001304:	8082                	ret

0000000080001306 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001310:	825ff0ef          	jal	80000b34 <kalloc>
    80001314:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001316:	c509                	beqz	a0,80001320 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001318:	6605                	lui	a2,0x1
    8000131a:	4581                	li	a1,0
    8000131c:	ac7ff0ef          	jal	80000de2 <memset>
  return pagetable;
}
    80001320:	8526                	mv	a0,s1
    80001322:	60e2                	ld	ra,24(sp)
    80001324:	6442                	ld	s0,16(sp)
    80001326:	64a2                	ld	s1,8(sp)
    80001328:	6105                	addi	sp,sp,32
    8000132a:	8082                	ret

000000008000132c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000132c:	7139                	addi	sp,sp,-64
    8000132e:	fc06                	sd	ra,56(sp)
    80001330:	f822                	sd	s0,48(sp)
    80001332:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001334:	03459793          	slli	a5,a1,0x34
    80001338:	e38d                	bnez	a5,8000135a <uvmunmap+0x2e>
    8000133a:	f04a                	sd	s2,32(sp)
    8000133c:	ec4e                	sd	s3,24(sp)
    8000133e:	e852                	sd	s4,16(sp)
    80001340:	e456                	sd	s5,8(sp)
    80001342:	e05a                	sd	s6,0(sp)
    80001344:	8a2a                	mv	s4,a0
    80001346:	892e                	mv	s2,a1
    80001348:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000134a:	0632                	slli	a2,a2,0xc
    8000134c:	00b609b3          	add	s3,a2,a1
    80001350:	6b05                	lui	s6,0x1
    80001352:	0535f963          	bgeu	a1,s3,800013a4 <uvmunmap+0x78>
    80001356:	f426                	sd	s1,40(sp)
    80001358:	a015                	j	8000137c <uvmunmap+0x50>
    8000135a:	f426                	sd	s1,40(sp)
    8000135c:	f04a                	sd	s2,32(sp)
    8000135e:	ec4e                	sd	s3,24(sp)
    80001360:	e852                	sd	s4,16(sp)
    80001362:	e456                	sd	s5,8(sp)
    80001364:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001366:	00007517          	auipc	a0,0x7
    8000136a:	dd250513          	addi	a0,a0,-558 # 80008138 <etext+0x138>
    8000136e:	c80ff0ef          	jal	800007ee <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001372:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001376:	995a                	add	s2,s2,s6
    80001378:	03397563          	bgeu	s2,s3,800013a2 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000137c:	4601                	li	a2,0
    8000137e:	85ca                	mv	a1,s2
    80001380:	8552                	mv	a0,s4
    80001382:	cf7ff0ef          	jal	80001078 <walk>
    80001386:	84aa                	mv	s1,a0
    80001388:	d57d                	beqz	a0,80001376 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    8000138a:	611c                	ld	a5,0(a0)
    8000138c:	0017f713          	andi	a4,a5,1
    80001390:	d37d                	beqz	a4,80001376 <uvmunmap+0x4a>
    if (do_free) {
    80001392:	fe0a80e3          	beqz	s5,80001372 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001396:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001398:	00c79513          	slli	a0,a5,0xc
    8000139c:	e44ff0ef          	jal	800009e0 <kfree>
    800013a0:	bfc9                	j	80001372 <uvmunmap+0x46>
    800013a2:	74a2                	ld	s1,40(sp)
    800013a4:	7902                	ld	s2,32(sp)
    800013a6:	69e2                	ld	s3,24(sp)
    800013a8:	6a42                	ld	s4,16(sp)
    800013aa:	6aa2                	ld	s5,8(sp)
    800013ac:	6b02                	ld	s6,0(sp)
  }
}
    800013ae:	70e2                	ld	ra,56(sp)
    800013b0:	7442                	ld	s0,48(sp)
    800013b2:	6121                	addi	sp,sp,64
    800013b4:	8082                	ret

00000000800013b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013b6:	1101                	addi	sp,sp,-32
    800013b8:	ec06                	sd	ra,24(sp)
    800013ba:	e822                	sd	s0,16(sp)
    800013bc:	e426                	sd	s1,8(sp)
    800013be:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800013c0:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800013c2:	00b67d63          	bgeu	a2,a1,800013dc <uvmdealloc+0x26>
    800013c6:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    800013c8:	6785                	lui	a5,0x1
    800013ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013cc:	00f60733          	add	a4,a2,a5
    800013d0:	76fd                	lui	a3,0xfffff
    800013d2:	8f75                	and	a4,a4,a3
    800013d4:	97ae                	add	a5,a5,a1
    800013d6:	8ff5                	and	a5,a5,a3
    800013d8:	00f76863          	bltu	a4,a5,800013e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013dc:	8526                	mv	a0,s1
    800013de:	60e2                	ld	ra,24(sp)
    800013e0:	6442                	ld	s0,16(sp)
    800013e2:	64a2                	ld	s1,8(sp)
    800013e4:	6105                	addi	sp,sp,32
    800013e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013e8:	8f99                	sub	a5,a5,a4
    800013ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013ec:	4685                	li	a3,1
    800013ee:	0007861b          	sext.w	a2,a5
    800013f2:	85ba                	mv	a1,a4
    800013f4:	f39ff0ef          	jal	8000132c <uvmunmap>
    800013f8:	b7d5                	j	800013dc <uvmdealloc+0x26>

00000000800013fa <uvmalloc>:
  if (newsz < oldsz)
    800013fa:	0ab66363          	bltu	a2,a1,800014a0 <uvmalloc+0xa6>
{
    800013fe:	715d                	addi	sp,sp,-80
    80001400:	e486                	sd	ra,72(sp)
    80001402:	e0a2                	sd	s0,64(sp)
    80001404:	f052                	sd	s4,32(sp)
    80001406:	ec56                	sd	s5,24(sp)
    80001408:	e85a                	sd	s6,16(sp)
    8000140a:	0880                	addi	s0,sp,80
    8000140c:	8b2a                	mv	s6,a0
    8000140e:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80001410:	6785                	lui	a5,0x1
    80001412:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001414:	95be                	add	a1,a1,a5
    80001416:	77fd                	lui	a5,0xfffff
    80001418:	00f5fa33          	and	s4,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000141c:	08ca7463          	bgeu	s4,a2,800014a4 <uvmalloc+0xaa>
    80001420:	fc26                	sd	s1,56(sp)
    80001422:	f84a                	sd	s2,48(sp)
    80001424:	f44e                	sd	s3,40(sp)
    80001426:	e45e                	sd	s7,8(sp)
    80001428:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    8000142a:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000142c:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    80001430:	f04ff0ef          	jal	80000b34 <kalloc>
    80001434:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001436:	c515                	beqz	a0,80001462 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80001438:	864e                	mv	a2,s3
    8000143a:	4581                	li	a1,0
    8000143c:	9a7ff0ef          	jal	80000de2 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001440:	875e                	mv	a4,s7
    80001442:	86a6                	mv	a3,s1
    80001444:	864e                	mv	a2,s3
    80001446:	85ca                	mv	a1,s2
    80001448:	855a                	mv	a0,s6
    8000144a:	d07ff0ef          	jal	80001150 <mappages>
    8000144e:	e91d                	bnez	a0,80001484 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001450:	994e                	add	s2,s2,s3
    80001452:	fd596fe3          	bltu	s2,s5,80001430 <uvmalloc+0x36>
  return newsz;
    80001456:	8556                	mv	a0,s5
    80001458:	74e2                	ld	s1,56(sp)
    8000145a:	7942                	ld	s2,48(sp)
    8000145c:	79a2                	ld	s3,40(sp)
    8000145e:	6ba2                	ld	s7,8(sp)
    80001460:	a819                	j	80001476 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    80001462:	8652                	mv	a2,s4
    80001464:	85ca                	mv	a1,s2
    80001466:	855a                	mv	a0,s6
    80001468:	f4fff0ef          	jal	800013b6 <uvmdealloc>
      return 0;
    8000146c:	4501                	li	a0,0
    8000146e:	74e2                	ld	s1,56(sp)
    80001470:	7942                	ld	s2,48(sp)
    80001472:	79a2                	ld	s3,40(sp)
    80001474:	6ba2                	ld	s7,8(sp)
}
    80001476:	60a6                	ld	ra,72(sp)
    80001478:	6406                	ld	s0,64(sp)
    8000147a:	7a02                	ld	s4,32(sp)
    8000147c:	6ae2                	ld	s5,24(sp)
    8000147e:	6b42                	ld	s6,16(sp)
    80001480:	6161                	addi	sp,sp,80
    80001482:	8082                	ret
      kfree(mem);
    80001484:	8526                	mv	a0,s1
    80001486:	d5aff0ef          	jal	800009e0 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000148a:	8652                	mv	a2,s4
    8000148c:	85ca                	mv	a1,s2
    8000148e:	855a                	mv	a0,s6
    80001490:	f27ff0ef          	jal	800013b6 <uvmdealloc>
      return 0;
    80001494:	4501                	li	a0,0
    80001496:	74e2                	ld	s1,56(sp)
    80001498:	7942                	ld	s2,48(sp)
    8000149a:	79a2                	ld	s3,40(sp)
    8000149c:	6ba2                	ld	s7,8(sp)
    8000149e:	bfe1                	j	80001476 <uvmalloc+0x7c>
    return oldsz;
    800014a0:	852e                	mv	a0,a1
}
    800014a2:	8082                	ret
  return newsz;
    800014a4:	8532                	mv	a0,a2
    800014a6:	bfc1                	j	80001476 <uvmalloc+0x7c>

00000000800014a8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800014a8:	7179                	addi	sp,sp,-48
    800014aa:	f406                	sd	ra,40(sp)
    800014ac:	f022                	sd	s0,32(sp)
    800014ae:	ec26                	sd	s1,24(sp)
    800014b0:	e84a                	sd	s2,16(sp)
    800014b2:	e44e                	sd	s3,8(sp)
    800014b4:	e052                	sd	s4,0(sp)
    800014b6:	1800                	addi	s0,sp,48
    800014b8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    800014ba:	84aa                	mv	s1,a0
    800014bc:	6905                	lui	s2,0x1
    800014be:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800014c0:	4985                	li	s3,1
    800014c2:	a819                	j	800014d8 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014c4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800014c6:	00c79513          	slli	a0,a5,0xc
    800014ca:	fdfff0ef          	jal	800014a8 <freewalk>
      pagetable[i] = 0;
    800014ce:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    800014d2:	04a1                	addi	s1,s1,8
    800014d4:	01248f63          	beq	s1,s2,800014f2 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800014d8:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800014da:	00f7f713          	andi	a4,a5,15
    800014de:	ff3703e3          	beq	a4,s3,800014c4 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    800014e2:	8b85                	andi	a5,a5,1
    800014e4:	d7fd                	beqz	a5,800014d2 <freewalk+0x2a>
      panic("freewalk: leaf");
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	c6a50513          	addi	a0,a0,-918 # 80008150 <etext+0x150>
    800014ee:	b00ff0ef          	jal	800007ee <panic>
    }
  }
  kfree((void *)pagetable);
    800014f2:	8552                	mv	a0,s4
    800014f4:	cecff0ef          	jal	800009e0 <kfree>
}
    800014f8:	70a2                	ld	ra,40(sp)
    800014fa:	7402                	ld	s0,32(sp)
    800014fc:	64e2                	ld	s1,24(sp)
    800014fe:	6942                	ld	s2,16(sp)
    80001500:	69a2                	ld	s3,8(sp)
    80001502:	6a02                	ld	s4,0(sp)
    80001504:	6145                	addi	sp,sp,48
    80001506:	8082                	ret

0000000080001508 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001508:	1101                	addi	sp,sp,-32
    8000150a:	ec06                	sd	ra,24(sp)
    8000150c:	e822                	sd	s0,16(sp)
    8000150e:	e426                	sd	s1,8(sp)
    80001510:	1000                	addi	s0,sp,32
    80001512:	84aa                	mv	s1,a0
  if (sz > 0)
    80001514:	e989                	bnez	a1,80001526 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80001516:	8526                	mv	a0,s1
    80001518:	f91ff0ef          	jal	800014a8 <freewalk>
}
    8000151c:	60e2                	ld	ra,24(sp)
    8000151e:	6442                	ld	s0,16(sp)
    80001520:	64a2                	ld	s1,8(sp)
    80001522:	6105                	addi	sp,sp,32
    80001524:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80001526:	6785                	lui	a5,0x1
    80001528:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000152a:	95be                	add	a1,a1,a5
    8000152c:	4685                	li	a3,1
    8000152e:	00c5d613          	srli	a2,a1,0xc
    80001532:	4581                	li	a1,0
    80001534:	df9ff0ef          	jal	8000132c <uvmunmap>
    80001538:	bff9                	j	80001516 <uvmfree+0xe>

000000008000153a <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    8000153a:	c655                	beqz	a2,800015e6 <uvmcopy+0xac>
{
    8000153c:	715d                	addi	sp,sp,-80
    8000153e:	e486                	sd	ra,72(sp)
    80001540:	e0a2                	sd	s0,64(sp)
    80001542:	fc26                	sd	s1,56(sp)
    80001544:	f84a                	sd	s2,48(sp)
    80001546:	f44e                	sd	s3,40(sp)
    80001548:	f052                	sd	s4,32(sp)
    8000154a:	ec56                	sd	s5,24(sp)
    8000154c:	e85a                	sd	s6,16(sp)
    8000154e:	e45e                	sd	s7,8(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8aaa                	mv	s5,a0
    80001554:	8b2e                	mv	s6,a1
    80001556:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001558:	4481                	li	s1,0
    }

    // Parent and child now share the same physical page.
    incref((void*)pa);

    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    8000155a:	6985                	lui	s3,0x1
    8000155c:	a805                	j	8000158c <uvmcopy+0x52>
      flags = (flags & ~PTE_W) | PTE_COW;
    8000155e:	2fbbfb93          	andi	s7,s7,763
    80001562:	100beb93          	ori	s7,s7,256
      *pte = (*pte & ~PTE_W) | PTE_COW;
    80001566:	efb7f793          	andi	a5,a5,-261
    8000156a:	1007e793          	ori	a5,a5,256
    8000156e:	e11c                	sd	a5,0(a0)
    incref((void*)pa);
    80001570:	854a                	mv	a0,s2
    80001572:	e38ff0ef          	jal	80000baa <incref>
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    80001576:	875e                	mv	a4,s7
    80001578:	86ca                	mv	a3,s2
    8000157a:	864e                	mv	a2,s3
    8000157c:	85a6                	mv	a1,s1
    8000157e:	855a                	mv	a0,s6
    80001580:	bd1ff0ef          	jal	80001150 <mappages>
    80001584:	e90d                	bnez	a0,800015b6 <uvmcopy+0x7c>
  for(i = 0; i < sz; i += PGSIZE){
    80001586:	94ce                	add	s1,s1,s3
    80001588:	0544f363          	bgeu	s1,s4,800015ce <uvmcopy+0x94>
    if((pte = walk(old, i, 0)) == 0)
    8000158c:	4601                	li	a2,0
    8000158e:	85a6                	mv	a1,s1
    80001590:	8556                	mv	a0,s5
    80001592:	ae7ff0ef          	jal	80001078 <walk>
    80001596:	d965                	beqz	a0,80001586 <uvmcopy+0x4c>
    if((*pte & PTE_V) == 0)
    80001598:	611c                	ld	a5,0(a0)
    8000159a:	0017f713          	andi	a4,a5,1
    8000159e:	d765                	beqz	a4,80001586 <uvmcopy+0x4c>
    pa = PTE2PA(*pte);
    800015a0:	00a7d913          	srli	s2,a5,0xa
    800015a4:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    800015a6:	00078b9b          	sext.w	s7,a5
    if(flags & PTE_W){
    800015aa:	0047f713          	andi	a4,a5,4
    800015ae:	fb45                	bnez	a4,8000155e <uvmcopy+0x24>
    flags = PTE_FLAGS(*pte);
    800015b0:	3ffbfb93          	andi	s7,s7,1023
    800015b4:	bf75                	j	80001570 <uvmcopy+0x36>
      decref((void*)pa);
    800015b6:	854a                	mv	a0,s2
    800015b8:	e70ff0ef          	jal	80000c28 <decref>
  }

  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015bc:	4685                	li	a3,1
    800015be:	00c4d613          	srli	a2,s1,0xc
    800015c2:	4581                	li	a1,0
    800015c4:	855a                	mv	a0,s6
    800015c6:	d67ff0ef          	jal	8000132c <uvmunmap>
  return -1;
    800015ca:	557d                	li	a0,-1
    800015cc:	a011                	j	800015d0 <uvmcopy+0x96>
  return 0;
    800015ce:	4501                	li	a0,0
}
    800015d0:	60a6                	ld	ra,72(sp)
    800015d2:	6406                	ld	s0,64(sp)
    800015d4:	74e2                	ld	s1,56(sp)
    800015d6:	7942                	ld	s2,48(sp)
    800015d8:	79a2                	ld	s3,40(sp)
    800015da:	7a02                	ld	s4,32(sp)
    800015dc:	6ae2                	ld	s5,24(sp)
    800015de:	6b42                	ld	s6,16(sp)
    800015e0:	6ba2                	ld	s7,8(sp)
    800015e2:	6161                	addi	sp,sp,80
    800015e4:	8082                	ret
  return 0;
    800015e6:	4501                	li	a0,0
}
    800015e8:	8082                	ret

00000000800015ea <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800015ea:	1141                	addi	sp,sp,-16
    800015ec:	e406                	sd	ra,8(sp)
    800015ee:	e022                	sd	s0,0(sp)
    800015f0:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    800015f2:	4601                	li	a2,0
    800015f4:	a85ff0ef          	jal	80001078 <walk>
  if (pte == 0)
    800015f8:	c901                	beqz	a0,80001608 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800015fa:	611c                	ld	a5,0(a0)
    800015fc:	9bbd                	andi	a5,a5,-17
    800015fe:	e11c                	sd	a5,0(a0)
}
    80001600:	60a2                	ld	ra,8(sp)
    80001602:	6402                	ld	s0,0(sp)
    80001604:	0141                	addi	sp,sp,16
    80001606:	8082                	ret
    panic("uvmclear");
    80001608:	00007517          	auipc	a0,0x7
    8000160c:	b5850513          	addi	a0,a0,-1192 # 80008160 <etext+0x160>
    80001610:	9deff0ef          	jal	800007ee <panic>

0000000080001614 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001614:	1141                	addi	sp,sp,-16
    80001616:	e406                	sd	ra,8(sp)
    80001618:	e022                	sd	s0,0(sp)
    8000161a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000161c:	4601                	li	a2,0
    8000161e:	a5bff0ef          	jal	80001078 <walk>
  if (pte == 0) {
    80001622:	c519                	beqz	a0,80001630 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V) {
    80001624:	6108                	ld	a0,0(a0)
    80001626:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001628:	60a2                	ld	ra,8(sp)
    8000162a:	6402                	ld	s0,0(sp)
    8000162c:	0141                	addi	sp,sp,16
    8000162e:	8082                	ret
    return 0;
    80001630:	4501                	li	a0,0
    80001632:	bfdd                	j	80001628 <ismapped+0x14>

0000000080001634 <vmfault>:
{
    80001634:	7179                	addi	sp,sp,-48
    80001636:	f406                	sd	ra,40(sp)
    80001638:	f022                	sd	s0,32(sp)
    8000163a:	e44e                	sd	s3,8(sp)
    8000163c:	1800                	addi	s0,sp,48
    return 0;
    8000163e:	4981                	li	s3,0
  if (va >= psz)
    80001640:	00b66863          	bltu	a2,a1,80001650 <vmfault+0x1c>
}
    80001644:	854e                	mv	a0,s3
    80001646:	70a2                	ld	ra,40(sp)
    80001648:	7402                	ld	s0,32(sp)
    8000164a:	69a2                	ld	s3,8(sp)
    8000164c:	6145                	addi	sp,sp,48
    8000164e:	8082                	ret
    80001650:	ec26                	sd	s1,24(sp)
    80001652:	e84a                	sd	s2,16(sp)
    80001654:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80001656:	77fd                	lui	a5,0xfffff
    80001658:	00f674b3          	and	s1,a2,a5
  if (ismapped(pagetable, va)) {
    8000165c:	85a6                	mv	a1,s1
    8000165e:	fb7ff0ef          	jal	80001614 <ismapped>
    return 0;
    80001662:	4981                	li	s3,0
  if (ismapped(pagetable, va)) {
    80001664:	c501                	beqz	a0,8000166c <vmfault+0x38>
    80001666:	64e2                	ld	s1,24(sp)
    80001668:	6942                	ld	s2,16(sp)
    8000166a:	bfe9                	j	80001644 <vmfault+0x10>
    8000166c:	e052                	sd	s4,0(sp)
  mem = (uint64)kalloc();
    8000166e:	cc6ff0ef          	jal	80000b34 <kalloc>
    80001672:	8a2a                	mv	s4,a0
  if (mem == 0)
    80001674:	c915                	beqz	a0,800016a8 <vmfault+0x74>
  mem = (uint64)kalloc();
    80001676:	89aa                	mv	s3,a0
  memset((void *)mem, 0, PGSIZE);
    80001678:	6605                	lui	a2,0x1
    8000167a:	4581                	li	a1,0
    8000167c:	f66ff0ef          	jal	80000de2 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001680:	4759                	li	a4,22
    80001682:	86d2                	mv	a3,s4
    80001684:	6605                	lui	a2,0x1
    80001686:	85a6                	mv	a1,s1
    80001688:	854a                	mv	a0,s2
    8000168a:	ac7ff0ef          	jal	80001150 <mappages>
    8000168e:	e509                	bnez	a0,80001698 <vmfault+0x64>
    80001690:	64e2                	ld	s1,24(sp)
    80001692:	6942                	ld	s2,16(sp)
    80001694:	6a02                	ld	s4,0(sp)
    80001696:	b77d                	j	80001644 <vmfault+0x10>
    kfree((void *)mem);
    80001698:	8552                	mv	a0,s4
    8000169a:	b46ff0ef          	jal	800009e0 <kfree>
    return 0;
    8000169e:	4981                	li	s3,0
    800016a0:	64e2                	ld	s1,24(sp)
    800016a2:	6942                	ld	s2,16(sp)
    800016a4:	6a02                	ld	s4,0(sp)
    800016a6:	bf79                	j	80001644 <vmfault+0x10>
    800016a8:	64e2                	ld	s1,24(sp)
    800016aa:	6942                	ld	s2,16(sp)
    800016ac:	6a02                	ld	s4,0(sp)
    800016ae:	bf59                	j	80001644 <vmfault+0x10>

00000000800016b0 <copyinstr>:
{
    800016b0:	711d                	addi	sp,sp,-96
    800016b2:	ec86                	sd	ra,88(sp)
    800016b4:	e8a2                	sd	s0,80(sp)
    800016b6:	e4a6                	sd	s1,72(sp)
    800016b8:	e0ca                	sd	s2,64(sp)
    800016ba:	fc4e                	sd	s3,56(sp)
    800016bc:	f852                	sd	s4,48(sp)
    800016be:	f456                	sd	s5,40(sp)
    800016c0:	f05a                	sd	s6,32(sp)
    800016c2:	ec5e                	sd	s7,24(sp)
    800016c4:	e862                	sd	s8,16(sp)
    800016c6:	e466                	sd	s9,8(sp)
    800016c8:	1080                	addi	s0,sp,96
    800016ca:	8aaa                	mv	s5,a0
    800016cc:	8bae                	mv	s7,a1
    800016ce:	89b2                	mv	s3,a2
    800016d0:	8cb6                	mv	s9,a3
    800016d2:	84ba                	mv	s1,a4
    va0 = PGROUNDDOWN(srcva);
    800016d4:	7b7d                	lui	s6,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016d6:	4c05                	li	s8,1
    n = PGSIZE - (srcva - va0);
    800016d8:	6a05                	lui	s4,0x1
    800016da:	a081                	j	8000171a <copyinstr+0x6a>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016dc:	86e2                	mv	a3,s8
    800016de:	864a                	mv	a2,s2
    800016e0:	85de                	mv	a1,s7
    800016e2:	8556                	mv	a0,s5
    800016e4:	f51ff0ef          	jal	80001634 <vmfault>
    800016e8:	e129                	bnez	a0,8000172a <copyinstr+0x7a>
        return -1;
    800016ea:	557d                	li	a0,-1
    800016ec:	a801                	j	800016fc <copyinstr+0x4c>
        *dst = '\0';
    800016ee:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdae698>
    800016f2:	4785                	li	a5,1
  if (got_null) {
    800016f4:	0017c793          	xori	a5,a5,1
    800016f8:	40f0053b          	negw	a0,a5
}
    800016fc:	60e6                	ld	ra,88(sp)
    800016fe:	6446                	ld	s0,80(sp)
    80001700:	64a6                	ld	s1,72(sp)
    80001702:	6906                	ld	s2,64(sp)
    80001704:	79e2                	ld	s3,56(sp)
    80001706:	7a42                	ld	s4,48(sp)
    80001708:	7aa2                	ld	s5,40(sp)
    8000170a:	7b02                	ld	s6,32(sp)
    8000170c:	6be2                	ld	s7,24(sp)
    8000170e:	6c42                	ld	s8,16(sp)
    80001710:	6ca2                	ld	s9,8(sp)
    80001712:	6125                	addi	sp,sp,96
    80001714:	8082                	ret
    srcva = va0 + PGSIZE;
    80001716:	01490cb3          	add	s9,s2,s4
  while (got_null == 0 && max > 0) {
    8000171a:	c4b1                	beqz	s1,80001766 <copyinstr+0xb6>
    va0 = PGROUNDDOWN(srcva);
    8000171c:	016cf933          	and	s2,s9,s6
    pa0 = walkaddr(pagetable, va0);
    80001720:	85ca                	mv	a1,s2
    80001722:	8556                	mv	a0,s5
    80001724:	9efff0ef          	jal	80001112 <walkaddr>
    if (pa0 == 0) {
    80001728:	d955                	beqz	a0,800016dc <copyinstr+0x2c>
    n = PGSIZE - (srcva - va0);
    8000172a:	41990733          	sub	a4,s2,s9
    8000172e:	9752                	add	a4,a4,s4
    if (n > max)
    80001730:	00e4f363          	bgeu	s1,a4,80001736 <copyinstr+0x86>
    80001734:	8726                	mv	a4,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80001736:	412c8cb3          	sub	s9,s9,s2
    8000173a:	9caa                	add	s9,s9,a0
    while (n > 0) {
    8000173c:	df69                	beqz	a4,80001716 <copyinstr+0x66>
    8000173e:	87ce                	mv	a5,s3
      if (*p == '\0') {
    80001740:	413c8633          	sub	a2,s9,s3
    while (n > 0) {
    80001744:	974e                	add	a4,a4,s3
    80001746:	85be                	mv	a1,a5
      if (*p == '\0') {
    80001748:	00f606b3          	add	a3,a2,a5
    8000174c:	0006c683          	lbu	a3,0(a3) # fffffffffffff000 <end+0xffffffff7fdae698>
    80001750:	ded9                	beqz	a3,800016ee <copyinstr+0x3e>
        *dst = *p;
    80001752:	00d78023          	sb	a3,0(a5)
      dst++;
    80001756:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001758:	fee797e3          	bne	a5,a4,80001746 <copyinstr+0x96>
    8000175c:	14fd                	addi	s1,s1,-1
    8000175e:	94ce                	add	s1,s1,s3
      --max;
    80001760:	8c8d                	sub	s1,s1,a1
    80001762:	89be                	mv	s3,a5
    80001764:	bf4d                	j	80001716 <copyinstr+0x66>
    80001766:	4781                	li	a5,0
    80001768:	b771                	j	800016f4 <copyinstr+0x44>

000000008000176a <cowalloc>:


uint64
cowalloc(pagetable_t pagetable, uint64 va)
{
    8000176a:	7139                	addi	sp,sp,-64
    8000176c:	fc06                	sd	ra,56(sp)
    8000176e:	f822                	sd	s0,48(sp)
    80001770:	f426                	sd	s1,40(sp)
    80001772:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;

  if(va >= MAXVA)
    80001774:	57fd                	li	a5,-1
    80001776:	83e9                	srli	a5,a5,0x1a
    return 0;
    80001778:	4481                	li	s1,0
  if(va >= MAXVA)
    8000177a:	00b7f863          	bgeu	a5,a1,8000178a <cowalloc+0x20>
  *pte = PA2PTE((uint64)mem) | flags;

  decref((void*)pa);

  return (uint64)mem;
}
    8000177e:	8526                	mv	a0,s1
    80001780:	70e2                	ld	ra,56(sp)
    80001782:	7442                	ld	s0,48(sp)
    80001784:	74a2                	ld	s1,40(sp)
    80001786:	6121                	addi	sp,sp,64
    80001788:	8082                	ret
    8000178a:	f04a                	sd	s2,32(sp)
  if((pte = walk(pagetable, va, 0)) == 0)
    8000178c:	4601                	li	a2,0
    8000178e:	77fd                	lui	a5,0xfffff
    80001790:	8dfd                	and	a1,a1,a5
    80001792:	8e7ff0ef          	jal	80001078 <walk>
    80001796:	892a                	mv	s2,a0
    80001798:	c949                	beqz	a0,8000182a <cowalloc+0xc0>
    8000179a:	ec4e                	sd	s3,24(sp)
  if((*pte & PTE_V) == 0)
    8000179c:	00053983          	ld	s3,0(a0)
  if((*pte & PTE_COW) == 0)
    800017a0:	1019f713          	andi	a4,s3,257
    800017a4:	10100793          	li	a5,257
    return 0;
    800017a8:	4481                	li	s1,0
  if((*pte & PTE_COW) == 0)
    800017aa:	00f70563          	beq	a4,a5,800017b4 <cowalloc+0x4a>
    800017ae:	7902                	ld	s2,32(sp)
    800017b0:	69e2                	ld	s3,24(sp)
    800017b2:	b7f1                	j	8000177e <cowalloc+0x14>
    800017b4:	e852                	sd	s4,16(sp)
    800017b6:	e456                	sd	s5,8(sp)
  pa = PTE2PA(*pte);
    800017b8:	00a9d493          	srli	s1,s3,0xa
    800017bc:	04b2                	slli	s1,s1,0xc
  flags = PTE_FLAGS(*pte);
    800017be:	00098a1b          	sext.w	s4,s3
  if(getref((void*)pa) == 1){
    800017c2:	8aa6                	mv	s5,s1
    800017c4:	8526                	mv	a0,s1
    800017c6:	c24ff0ef          	jal	80000bea <getref>
    800017ca:	4785                	li	a5,1
    800017cc:	02f50e63          	beq	a0,a5,80001808 <cowalloc+0x9e>
  mem = kalloc();
    800017d0:	b64ff0ef          	jal	80000b34 <kalloc>
    800017d4:	89aa                	mv	s3,a0
  if(mem == 0)
    800017d6:	cd29                	beqz	a0,80001830 <cowalloc+0xc6>
  memmove(mem, (char*)pa, PGSIZE);
    800017d8:	6605                	lui	a2,0x1
    800017da:	85a6                	mv	a1,s1
    800017dc:	e6aff0ef          	jal	80000e46 <memmove>
  *pte = PA2PTE((uint64)mem) | flags;
    800017e0:	84ce                	mv	s1,s3
    800017e2:	00c9d793          	srli	a5,s3,0xc
    800017e6:	07aa                	slli	a5,a5,0xa
  flags = (flags | PTE_W) & ~PTE_COW;
    800017e8:	2ffa7a13          	andi	s4,s4,767
  *pte = PA2PTE((uint64)mem) | flags;
    800017ec:	004a6a13          	ori	s4,s4,4
    800017f0:	0147e7b3          	or	a5,a5,s4
    800017f4:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  decref((void*)pa);
    800017f8:	8556                	mv	a0,s5
    800017fa:	c2eff0ef          	jal	80000c28 <decref>
  return (uint64)mem;
    800017fe:	7902                	ld	s2,32(sp)
    80001800:	69e2                	ld	s3,24(sp)
    80001802:	6a42                	ld	s4,16(sp)
    80001804:	6aa2                	ld	s5,8(sp)
    80001806:	bfa5                	j	8000177e <cowalloc+0x14>
    *pte = PA2PTE(pa) | ((flags | PTE_W) & ~PTE_COW);
    80001808:	2ffa7793          	andi	a5,s4,767
    8000180c:	0047e793          	ori	a5,a5,4
    80001810:	777d                	lui	a4,0xfffff
    80001812:	8309                	srli	a4,a4,0x2
    80001814:	00e9f9b3          	and	s3,s3,a4
    80001818:	0137e7b3          	or	a5,a5,s3
    8000181c:	00f93023          	sd	a5,0(s2)
    return pa;
    80001820:	7902                	ld	s2,32(sp)
    80001822:	69e2                	ld	s3,24(sp)
    80001824:	6a42                	ld	s4,16(sp)
    80001826:	6aa2                	ld	s5,8(sp)
    80001828:	bf99                	j	8000177e <cowalloc+0x14>
    return 0;
    8000182a:	4481                	li	s1,0
    8000182c:	7902                	ld	s2,32(sp)
    8000182e:	bf81                	j	8000177e <cowalloc+0x14>
    return 0;
    80001830:	4481                	li	s1,0
    80001832:	7902                	ld	s2,32(sp)
    80001834:	69e2                	ld	s3,24(sp)
    80001836:	6a42                	ld	s4,16(sp)
    80001838:	6aa2                	ld	s5,8(sp)
    8000183a:	b791                	j	8000177e <cowalloc+0x14>

000000008000183c <mmapfault>:


uint64
mmapfault(pagetable_t pagetable, uint64 va, int read)
{
    8000183c:	715d                	addi	sp,sp,-80
    8000183e:	e486                	sd	ra,72(sp)
    80001840:	e0a2                	sd	s0,64(sp)
    80001842:	fc26                	sd	s1,56(sp)
    80001844:	f84a                	sd	s2,48(sp)
    80001846:	f44e                	sd	s3,40(sp)
    80001848:	f052                	sd	s4,32(sp)
    8000184a:	ec56                	sd	s5,24(sp)
    8000184c:	0880                	addi	s0,sp,80
    8000184e:	8a2a                	mv	s4,a0
    80001850:	892e                	mv	s2,a1
    80001852:	8ab2                	mv	s5,a2
  struct proc *p = myproc();
    80001854:	7a2000ef          	jal	80001ff6 <myproc>
    80001858:	89aa                	mv	s3,a0
  uint64 mem;
  uint64 offset;
  int perm;
  int n;

  va = PGROUNDDOWN(va);
    8000185a:	77fd                	lui	a5,0xfffff
    8000185c:	00f97933          	and	s2,s2,a5

  for(int i = 0; i < NVMA; i++){
    80001860:	18050793          	addi	a5,a0,384
    80001864:	4481                	li	s1,0
    80001866:	46c1                	li	a3,16
    80001868:	a0b9                	j	800018b6 <mmapfault+0x7a>

    if(va >= vma->addr && va < vma->addr + vma->maplen){
      if(read && !(vma->prot & PROT_READ))
        return 0;

      if(!read && !(vma->prot & PROT_WRITE))
    8000186a:	00349793          	slli	a5,s1,0x3
    8000186e:	8f85                	sub	a5,a5,s1
    80001870:	078e                	slli	a5,a5,0x3
    80001872:	97ce                	add	a5,a5,s3
    80001874:	1a07a783          	lw	a5,416(a5) # fffffffffffff1a0 <end+0xffffffff7fdae838>
    80001878:	8b89                	andi	a5,a5,2
        return 0;
    8000187a:	4a81                	li	s5,0
      if(!read && !(vma->prot & PROT_WRITE))
    8000187c:	e3b5                	bnez	a5,800018e0 <mmapfault+0xa4>
    8000187e:	a219                	j	80001984 <mmapfault+0x148>

      if(ismapped(pagetable, va))
        return walkaddr(pagetable, va);
    80001880:	85ca                	mv	a1,s2
    80001882:	8552                	mv	a0,s4
    80001884:	88fff0ef          	jal	80001112 <walkaddr>
    80001888:	8aaa                	mv	s5,a0
    8000188a:	a8ed                	j	80001984 <mmapfault+0x148>
      ilock(vma->file->ip);
      n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
      iunlock(vma->file->ip);

      if(n < 0){
        kfree((void *)mem);
    8000188c:	855e                	mv	a0,s7
    8000188e:	952ff0ef          	jal	800009e0 <kfree>
        return 0;
    80001892:	4a81                	li	s5,0
    80001894:	6b42                	ld	s6,16(sp)
    80001896:	6ba2                	ld	s7,8(sp)
    80001898:	6c02                	ld	s8,0(sp)
    8000189a:	a0ed                	j	80001984 <mmapfault+0x148>

      if(vma->prot & PROT_WRITE)
        perm |= PTE_W;

      if(mappages(pagetable, va, PGSIZE, mem, perm) != 0){
        kfree((void *)mem);
    8000189c:	855e                	mv	a0,s7
    8000189e:	942ff0ef          	jal	800009e0 <kfree>
        return 0;
    800018a2:	4a81                	li	s5,0
    800018a4:	6b42                	ld	s6,16(sp)
    800018a6:	6ba2                	ld	s7,8(sp)
    800018a8:	6c02                	ld	s8,0(sp)
    800018aa:	a8e9                	j	80001984 <mmapfault+0x148>
  for(int i = 0; i < NVMA; i++){
    800018ac:	2485                	addiw	s1,s1,1
    800018ae:	03878793          	addi	a5,a5,56
    800018b2:	0cd48863          	beq	s1,a3,80001982 <mmapfault+0x146>
    if(vma->used == 0)
    800018b6:	4398                	lw	a4,0(a5)
    800018b8:	db75                	beqz	a4,800018ac <mmapfault+0x70>
    if(va >= vma->addr && va < vma->addr + vma->maplen){
    800018ba:	6798                	ld	a4,8(a5)
    800018bc:	fee968e3          	bltu	s2,a4,800018ac <mmapfault+0x70>
    800018c0:	6f8c                	ld	a1,24(a5)
    800018c2:	972e                	add	a4,a4,a1
    800018c4:	fee974e3          	bgeu	s2,a4,800018ac <mmapfault+0x70>
      if(read && !(vma->prot & PROT_READ))
    800018c8:	fa0a81e3          	beqz	s5,8000186a <mmapfault+0x2e>
    800018cc:	00349793          	slli	a5,s1,0x3
    800018d0:	8f85                	sub	a5,a5,s1
    800018d2:	078e                	slli	a5,a5,0x3
    800018d4:	97ce                	add	a5,a5,s3
    800018d6:	1a07a783          	lw	a5,416(a5)
    800018da:	8b85                	andi	a5,a5,1
        return 0;
    800018dc:	4a81                	li	s5,0
      if(read && !(vma->prot & PROT_READ))
    800018de:	c3dd                	beqz	a5,80001984 <mmapfault+0x148>
      if(ismapped(pagetable, va))
    800018e0:	85ca                	mv	a1,s2
    800018e2:	8552                	mv	a0,s4
    800018e4:	d31ff0ef          	jal	80001614 <ismapped>
    800018e8:	fd41                	bnez	a0,80001880 <mmapfault+0x44>
    800018ea:	e45e                	sd	s7,8(sp)
      mem = (uint64)kalloc();
    800018ec:	a48ff0ef          	jal	80000b34 <kalloc>
    800018f0:	8baa                	mv	s7,a0
        return 0;
    800018f2:	4a81                	li	s5,0
      if(mem == 0)
    800018f4:	c155                	beqz	a0,80001998 <mmapfault+0x15c>
    800018f6:	e85a                	sd	s6,16(sp)
    800018f8:	e062                	sd	s8,0(sp)
      mem = (uint64)kalloc();
    800018fa:	8aaa                	mv	s5,a0
      memset((void *)mem, 0, PGSIZE);
    800018fc:	6605                	lui	a2,0x1
    800018fe:	4581                	li	a1,0
    80001900:	ce2ff0ef          	jal	80000de2 <memset>
      offset = vma->offset + (va - vma->addr);
    80001904:	00349b13          	slli	s6,s1,0x3
    80001908:	409b0b33          	sub	s6,s6,s1
    8000190c:	0b0e                	slli	s6,s6,0x3
    8000190e:	9b4e                	add	s6,s6,s3
    80001910:	1b0b3c03          	ld	s8,432(s6) # fffffffffffff1b0 <end+0xffffffff7fdae848>
    80001914:	9c4a                	add	s8,s8,s2
    80001916:	188b3783          	ld	a5,392(s6)
    8000191a:	40fc0c33          	sub	s8,s8,a5
      ilock(vma->file->ip);
    8000191e:	1a8b3783          	ld	a5,424(s6)
    80001922:	6f88                	ld	a0,24(a5)
    80001924:	21d020ef          	jal	80004340 <ilock>
      n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
    80001928:	1a8b3783          	ld	a5,424(s6)
    8000192c:	6705                	lui	a4,0x1
    8000192e:	000c069b          	sext.w	a3,s8
    80001932:	865e                	mv	a2,s7
    80001934:	4581                	li	a1,0
    80001936:	6f88                	ld	a0,24(a5)
    80001938:	5e3020ef          	jal	8000471a <readi>
    8000193c:	8c2a                	mv	s8,a0
      iunlock(vma->file->ip);
    8000193e:	1a8b3783          	ld	a5,424(s6)
    80001942:	6f88                	ld	a0,24(a5)
    80001944:	2ab020ef          	jal	800043ee <iunlock>
      if(n < 0){
    80001948:	f40c42e3          	bltz	s8,8000188c <mmapfault+0x50>
      if(vma->prot & PROT_READ)
    8000194c:	00349793          	slli	a5,s1,0x3
    80001950:	8f85                	sub	a5,a5,s1
    80001952:	078e                	slli	a5,a5,0x3
    80001954:	99be                	add	s3,s3,a5
    80001956:	1a09a783          	lw	a5,416(s3) # 11a0 <_entry-0x7fffee60>
    8000195a:	0017f693          	andi	a3,a5,1
        perm |= PTE_R;
    8000195e:	4749                	li	a4,18
      if(vma->prot & PROT_READ)
    80001960:	e291                	bnez	a3,80001964 <mmapfault+0x128>
      perm = PTE_U;
    80001962:	4741                	li	a4,16
      if(vma->prot & PROT_WRITE)
    80001964:	8b89                	andi	a5,a5,2
    80001966:	c399                	beqz	a5,8000196c <mmapfault+0x130>
        perm |= PTE_W;
    80001968:	00476713          	ori	a4,a4,4
      if(mappages(pagetable, va, PGSIZE, mem, perm) != 0){
    8000196c:	86de                	mv	a3,s7
    8000196e:	6605                	lui	a2,0x1
    80001970:	85ca                	mv	a1,s2
    80001972:	8552                	mv	a0,s4
    80001974:	fdcff0ef          	jal	80001150 <mappages>
    80001978:	f115                	bnez	a0,8000189c <mmapfault+0x60>
    8000197a:	6b42                	ld	s6,16(sp)
    8000197c:	6ba2                	ld	s7,8(sp)
    8000197e:	6c02                	ld	s8,0(sp)
    80001980:	a011                	j	80001984 <mmapfault+0x148>

      return mem;
    }
  }

  return 0;
    80001982:	4a81                	li	s5,0
}
    80001984:	8556                	mv	a0,s5
    80001986:	60a6                	ld	ra,72(sp)
    80001988:	6406                	ld	s0,64(sp)
    8000198a:	74e2                	ld	s1,56(sp)
    8000198c:	7942                	ld	s2,48(sp)
    8000198e:	79a2                	ld	s3,40(sp)
    80001990:	7a02                	ld	s4,32(sp)
    80001992:	6ae2                	ld	s5,24(sp)
    80001994:	6161                	addi	sp,sp,80
    80001996:	8082                	ret
    80001998:	6ba2                	ld	s7,8(sp)
    8000199a:	b7ed                	j	80001984 <mmapfault+0x148>

000000008000199c <copyout>:
  while (len > 0) {
    8000199c:	cb69                	beqz	a4,80001a6e <copyout+0xd2>
{
    8000199e:	7159                	addi	sp,sp,-112
    800019a0:	f486                	sd	ra,104(sp)
    800019a2:	f0a2                	sd	s0,96(sp)
    800019a4:	eca6                	sd	s1,88(sp)
    800019a6:	e8ca                	sd	s2,80(sp)
    800019a8:	e4ce                	sd	s3,72(sp)
    800019aa:	e0d2                	sd	s4,64(sp)
    800019ac:	fc56                	sd	s5,56(sp)
    800019ae:	f85a                	sd	s6,48(sp)
    800019b0:	f45e                	sd	s7,40(sp)
    800019b2:	f062                	sd	s8,32(sp)
    800019b4:	ec66                	sd	s9,24(sp)
    800019b6:	e86a                	sd	s10,16(sp)
    800019b8:	e46e                	sd	s11,8(sp)
    800019ba:	1880                	addi	s0,sp,112
    800019bc:	8b2a                	mv	s6,a0
    800019be:	8dae                	mv	s11,a1
    800019c0:	8a32                	mv	s4,a2
    800019c2:	8bb6                	mv	s7,a3
    800019c4:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    800019c6:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    800019c8:	5cfd                	li	s9,-1
    800019ca:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    800019ce:	6c05                	lui	s8,0x1
    800019d0:	a0b1                	j	80001a1c <copyout+0x80>
    pte = walk(pagetable, va0, 0);
    800019d2:	4601                	li	a2,0
    800019d4:	85ca                	mv	a1,s2
    800019d6:	855a                	mv	a0,s6
    800019d8:	ea0ff0ef          	jal	80001078 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0)
    800019dc:	c95d                	beqz	a0,80001a92 <copyout+0xf6>
    800019de:	611c                	ld	a5,0(a0)
    800019e0:	0017f713          	andi	a4,a5,1
    800019e4:	cb4d                	beqz	a4,80001a96 <copyout+0xfa>
    if (*pte & PTE_COW) {
    800019e6:	1007f793          	andi	a5,a5,256
    800019ea:	e7a5                	bnez	a5,80001a52 <copyout+0xb6>
    if ((*pte & PTE_W) == 0)
    800019ec:	611c                	ld	a5,0(a0)
    800019ee:	8b91                	andi	a5,a5,4
    800019f0:	c7dd                	beqz	a5,80001a9e <copyout+0x102>
    n = PGSIZE - (dstva - va0);
    800019f2:	414909b3          	sub	s3,s2,s4
    800019f6:	99e2                	add	s3,s3,s8
    if (n > len)
    800019f8:	013af363          	bgeu	s5,s3,800019fe <copyout+0x62>
    800019fc:	89d6                	mv	s3,s5
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800019fe:	412a0533          	sub	a0,s4,s2
    80001a02:	0009861b          	sext.w	a2,s3
    80001a06:	85de                	mv	a1,s7
    80001a08:	9526                	add	a0,a0,s1
    80001a0a:	c3cff0ef          	jal	80000e46 <memmove>
    len -= n;
    80001a0e:	413a8ab3          	sub	s5,s5,s3
    src += n;
    80001a12:	9bce                	add	s7,s7,s3
    dstva = va0 + PGSIZE;
    80001a14:	01890a33          	add	s4,s2,s8
  while (len > 0) {
    80001a18:	040a8963          	beqz	s5,80001a6a <copyout+0xce>
    va0 = PGROUNDDOWN(dstva);
    80001a1c:	01aa7933          	and	s2,s4,s10
    if (va0 >= MAXVA)
    80001a20:	052ce963          	bltu	s9,s2,80001a72 <copyout+0xd6>
    pa0 = walkaddr(pagetable, va0);
    80001a24:	85ca                	mv	a1,s2
    80001a26:	855a                	mv	a0,s6
    80001a28:	eeaff0ef          	jal	80001112 <walkaddr>
    80001a2c:	84aa                	mv	s1,a0
    if (pa0 == 0) {
    80001a2e:	f155                	bnez	a0,800019d2 <copyout+0x36>
    pa0 = vmfault(pagetable, psz, va0, 0);
    80001a30:	4681                	li	a3,0
    80001a32:	864a                	mv	a2,s2
    80001a34:	85ee                	mv	a1,s11
    80001a36:	855a                	mv	a0,s6
    80001a38:	bfdff0ef          	jal	80001634 <vmfault>
    80001a3c:	84aa                	mv	s1,a0
    if(pa0 == 0)
    80001a3e:	f951                	bnez	a0,800019d2 <copyout+0x36>
    pa0 = mmapfault(pagetable, va0, 0);
    80001a40:	4601                	li	a2,0
    80001a42:	85ca                	mv	a1,s2
    80001a44:	855a                	mv	a0,s6
    80001a46:	df7ff0ef          	jal	8000183c <mmapfault>
    80001a4a:	84aa                	mv	s1,a0
    if(pa0 == 0)
    80001a4c:	f159                	bnez	a0,800019d2 <copyout+0x36>
    return -1;
    80001a4e:	557d                	li	a0,-1
    80001a50:	a015                	j	80001a74 <copyout+0xd8>
      pa0 = cowalloc(pagetable, va0);
    80001a52:	85ca                	mv	a1,s2
    80001a54:	855a                	mv	a0,s6
    80001a56:	d15ff0ef          	jal	8000176a <cowalloc>
    80001a5a:	84aa                	mv	s1,a0
      if (pa0 == 0)
    80001a5c:	cd1d                	beqz	a0,80001a9a <copyout+0xfe>
      pte = walk(pagetable, va0, 0);
    80001a5e:	4601                	li	a2,0
    80001a60:	85ca                	mv	a1,s2
    80001a62:	855a                	mv	a0,s6
    80001a64:	e14ff0ef          	jal	80001078 <walk>
    80001a68:	b751                	j	800019ec <copyout+0x50>
  return 0;
    80001a6a:	4501                	li	a0,0
    80001a6c:	a021                	j	80001a74 <copyout+0xd8>
    80001a6e:	4501                	li	a0,0
}
    80001a70:	8082                	ret
      return -1;
    80001a72:	557d                	li	a0,-1
}
    80001a74:	70a6                	ld	ra,104(sp)
    80001a76:	7406                	ld	s0,96(sp)
    80001a78:	64e6                	ld	s1,88(sp)
    80001a7a:	6946                	ld	s2,80(sp)
    80001a7c:	69a6                	ld	s3,72(sp)
    80001a7e:	6a06                	ld	s4,64(sp)
    80001a80:	7ae2                	ld	s5,56(sp)
    80001a82:	7b42                	ld	s6,48(sp)
    80001a84:	7ba2                	ld	s7,40(sp)
    80001a86:	7c02                	ld	s8,32(sp)
    80001a88:	6ce2                	ld	s9,24(sp)
    80001a8a:	6d42                	ld	s10,16(sp)
    80001a8c:	6da2                	ld	s11,8(sp)
    80001a8e:	6165                	addi	sp,sp,112
    80001a90:	8082                	ret
      return -1;
    80001a92:	557d                	li	a0,-1
    80001a94:	b7c5                	j	80001a74 <copyout+0xd8>
    80001a96:	557d                	li	a0,-1
    80001a98:	bff1                	j	80001a74 <copyout+0xd8>
        return -1;
    80001a9a:	557d                	li	a0,-1
    80001a9c:	bfe1                	j	80001a74 <copyout+0xd8>
      return -1;
    80001a9e:	557d                	li	a0,-1
    80001aa0:	bfd1                	j	80001a74 <copyout+0xd8>

0000000080001aa2 <copyin>:
  while (len > 0) {
    80001aa2:	c355                	beqz	a4,80001b46 <copyin+0xa4>
{
    80001aa4:	711d                	addi	sp,sp,-96
    80001aa6:	ec86                	sd	ra,88(sp)
    80001aa8:	e8a2                	sd	s0,80(sp)
    80001aaa:	e4a6                	sd	s1,72(sp)
    80001aac:	e0ca                	sd	s2,64(sp)
    80001aae:	fc4e                	sd	s3,56(sp)
    80001ab0:	f852                	sd	s4,48(sp)
    80001ab2:	f456                	sd	s5,40(sp)
    80001ab4:	f05a                	sd	s6,32(sp)
    80001ab6:	ec5e                	sd	s7,24(sp)
    80001ab8:	e862                	sd	s8,16(sp)
    80001aba:	e466                	sd	s9,8(sp)
    80001abc:	e06a                	sd	s10,0(sp)
    80001abe:	1080                	addi	s0,sp,96
    80001ac0:	8b2a                	mv	s6,a0
    80001ac2:	8cae                	mv	s9,a1
    80001ac4:	8a32                	mv	s4,a2
    80001ac6:	84b6                	mv	s1,a3
    80001ac8:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001aca:	7bfd                	lui	s7,0xfffff
  pa0 = vmfault(pagetable, psz, va0, 1);
    80001acc:	4c05                	li	s8,1
    n = PGSIZE - (srcva - va0);
    80001ace:	6a85                	lui	s5,0x1
    80001ad0:	a035                	j	80001afc <copyin+0x5a>
    80001ad2:	40990d33          	sub	s10,s2,s1
    80001ad6:	9d56                	add	s10,s10,s5
    if (n > len)
    80001ad8:	01a9f363          	bgeu	s3,s10,80001ade <copyin+0x3c>
    80001adc:	8d4e                	mv	s10,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001ade:	412485b3          	sub	a1,s1,s2
    80001ae2:	000d061b          	sext.w	a2,s10
    80001ae6:	95aa                	add	a1,a1,a0
    80001ae8:	8552                	mv	a0,s4
    80001aea:	b5cff0ef          	jal	80000e46 <memmove>
    len -= n;
    80001aee:	41a989b3          	sub	s3,s3,s10
    dst += n;
    80001af2:	9a6a                	add	s4,s4,s10
    srcva = va0 + PGSIZE;
    80001af4:	015904b3          	add	s1,s2,s5
  while (len > 0) {
    80001af8:	02098863          	beqz	s3,80001b28 <copyin+0x86>
    va0 = PGROUNDDOWN(srcva);
    80001afc:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001b00:	85ca                	mv	a1,s2
    80001b02:	855a                	mv	a0,s6
    80001b04:	e0eff0ef          	jal	80001112 <walkaddr>
    if (pa0 == 0) {
    80001b08:	f569                	bnez	a0,80001ad2 <copyin+0x30>
  pa0 = vmfault(pagetable, psz, va0, 1);
    80001b0a:	86e2                	mv	a3,s8
    80001b0c:	864a                	mv	a2,s2
    80001b0e:	85e6                	mv	a1,s9
    80001b10:	855a                	mv	a0,s6
    80001b12:	b23ff0ef          	jal	80001634 <vmfault>
  if(pa0 == 0)
    80001b16:	fd55                	bnez	a0,80001ad2 <copyin+0x30>
    pa0 = mmapfault(pagetable, va0, 1);
    80001b18:	8662                	mv	a2,s8
    80001b1a:	85ca                	mv	a1,s2
    80001b1c:	855a                	mv	a0,s6
    80001b1e:	d1fff0ef          	jal	8000183c <mmapfault>
  if(pa0 == 0)
    80001b22:	f945                	bnez	a0,80001ad2 <copyin+0x30>
    return -1;
    80001b24:	557d                	li	a0,-1
    80001b26:	a011                	j	80001b2a <copyin+0x88>
  return 0;
    80001b28:	4501                	li	a0,0
}
    80001b2a:	60e6                	ld	ra,88(sp)
    80001b2c:	6446                	ld	s0,80(sp)
    80001b2e:	64a6                	ld	s1,72(sp)
    80001b30:	6906                	ld	s2,64(sp)
    80001b32:	79e2                	ld	s3,56(sp)
    80001b34:	7a42                	ld	s4,48(sp)
    80001b36:	7aa2                	ld	s5,40(sp)
    80001b38:	7b02                	ld	s6,32(sp)
    80001b3a:	6be2                	ld	s7,24(sp)
    80001b3c:	6c42                	ld	s8,16(sp)
    80001b3e:	6ca2                	ld	s9,8(sp)
    80001b40:	6d02                	ld	s10,0(sp)
    80001b42:	6125                	addi	sp,sp,96
    80001b44:	8082                	ret
  return 0;
    80001b46:	4501                	li	a0,0
}
    80001b48:	8082                	ret

0000000080001b4a <mmap_unmap>:



int
mmap_unmap(struct proc *p, uint64 addr, uint64 length)
{
    80001b4a:	7175                	addi	sp,sp,-144
    80001b4c:	e506                	sd	ra,136(sp)
    80001b4e:	e122                	sd	s0,128(sp)
    80001b50:	ecd6                	sd	s5,88(sp)
    80001b52:	e8da                	sd	s6,80(sp)
    80001b54:	fc66                	sd	s9,56(sp)
    80001b56:	0900                	addi	s0,sp,144
    80001b58:	8b2a                	mv	s6,a0
    80001b5a:	8aae                	mv	s5,a1
  uint64 end;
  uint64 a;
  uint64 pa;
  pte_t *pte;

  length = PGROUNDUP(length);
    80001b5c:	6785                	lui	a5,0x1
    80001b5e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001b60:	963e                	add	a2,a2,a5
    80001b62:	77fd                	lui	a5,0xfffff
    80001b64:	00f67cb3          	and	s9,a2,a5

  for(int i = 0; i < NVMA; i++){
    80001b68:	18050793          	addi	a5,a0,384
    80001b6c:	4701                	li	a4,0
    80001b6e:	4641                	li	a2,16
    80001b70:	a031                	j	80001b7c <mmap_unmap+0x32>
    80001b72:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80001b74:	03878793          	addi	a5,a5,56 # fffffffffffff038 <end+0xffffffff7fdae6d0>
    80001b78:	04c70e63          	beq	a4,a2,80001bd4 <mmap_unmap+0x8a>
    if(p->vmas[i].used &&
    80001b7c:	4394                	lw	a3,0(a5)
    80001b7e:	daf5                	beqz	a3,80001b72 <mmap_unmap+0x28>
       addr >= p->vmas[i].addr &&
    80001b80:	6794                	ld	a3,8(a5)
    if(p->vmas[i].used &&
    80001b82:	fedae8e3          	bltu	s5,a3,80001b72 <mmap_unmap+0x28>
       addr < p->vmas[i].addr + p->vmas[i].maplen){
    80001b86:	6f8c                	ld	a1,24(a5)
    80001b88:	96ae                	add	a3,a3,a1
       addr >= p->vmas[i].addr &&
    80001b8a:	fedaf4e3          	bgeu	s5,a3,80001b72 <mmap_unmap+0x28>
    80001b8e:	f0d2                	sd	s4,96(sp)
      vma = &p->vmas[i];
    80001b90:	00371a13          	slli	s4,a4,0x3
    80001b94:	40ea0a33          	sub	s4,s4,a4
    80001b98:	0a0e                	slli	s4,s4,0x3
    80001b9a:	180a0a13          	addi	s4,s4,384 # 1180 <_entry-0x7fffee80>
    80001b9e:	9a5a                	add	s4,s4,s6
      break;
    }
  }

  if(vma == 0)
    80001ba0:	160a0f63          	beqz	s4,80001d1e <mmap_unmap+0x1d4>
    80001ba4:	f4ce                	sd	s3,104(sp)
    80001ba6:	e4de                	sd	s7,72(sp)
    return -1;

  end = addr + length;
    80001ba8:	015c8bb3          	add	s7,s9,s5

  if(addr != vma->addr &&
    80001bac:	008a3783          	ld	a5,8(s4)
    80001bb0:	19578463          	beq	a5,s5,80001d38 <mmap_unmap+0x1ee>
     end != vma->addr + vma->maplen)
    80001bb4:	018a3703          	ld	a4,24(s4)
    80001bb8:	97ba                	add	a5,a5,a4
  if(addr != vma->addr &&
    80001bba:	17779563          	bne	a5,s7,80001d24 <mmap_unmap+0x1da>
    return -1;

  for(a = addr; a < end; a += PGSIZE){
    80001bbe:	197af663          	bgeu	s5,s7,80001d4a <mmap_unmap+0x200>
    80001bc2:	fca6                	sd	s1,120(sp)
    80001bc4:	f8ca                	sd	s2,112(sp)
    80001bc6:	e0e2                	sd	s8,64(sp)
    80001bc8:	f86a                	sd	s10,48(sp)
    80001bca:	f46e                	sd	s11,40(sp)
    80001bcc:	89d6                	mv	s3,s5
    if(pte == 0 || (*pte & PTE_V) == 0)
      continue;

    pa = PTE2PA(*pte);

    if(vma->flags == MAP_SHARED){
    80001bce:	4d05                	li	s10,1
  for(a = addr; a < end; a += PGSIZE){
    80001bd0:	6c05                	lui	s8,0x1
    80001bd2:	a0a9                	j	80001c1c <mmap_unmap+0xd2>
    return -1;
    80001bd4:	557d                	li	a0,-1
    vma->maplen -= length;
    return 0;
  }

  return -1;
}
    80001bd6:	60aa                	ld	ra,136(sp)
    80001bd8:	640a                	ld	s0,128(sp)
    80001bda:	6ae6                	ld	s5,88(sp)
    80001bdc:	6b46                	ld	s6,80(sp)
    80001bde:	7ce2                	ld	s9,56(sp)
    80001be0:	6149                	addi	sp,sp,144
    80001be2:	8082                	ret
        writei(vma->file->ip, 0, pa, fileoff, remaining);
    80001be4:	028a3783          	ld	a5,40(s4)
    80001be8:	2701                	sext.w	a4,a4
    80001bea:	f7843683          	ld	a3,-136(s0)
    80001bee:	f8043603          	ld	a2,-128(s0)
    80001bf2:	9eb1                	addw	a3,a3,a2
    80001bf4:	864a                	mv	a2,s2
    80001bf6:	4581                	li	a1,0
    80001bf8:	6f88                	ld	a0,24(a5)
    80001bfa:	413020ef          	jal	8000480c <writei>
        iunlock(vma->file->ip);
    80001bfe:	028a3783          	ld	a5,40(s4)
    80001c02:	6f88                	ld	a0,24(a5)
    80001c04:	7ea020ef          	jal	800043ee <iunlock>
        end_op();
    80001c08:	220030ef          	jal	80004e28 <end_op>
    kfree((void *)pa);
    80001c0c:	854a                	mv	a0,s2
    80001c0e:	dd3fe0ef          	jal	800009e0 <kfree>
    *pte = 0;
    80001c12:	0004b023          	sd	zero,0(s1)
  for(a = addr; a < end; a += PGSIZE){
    80001c16:	99e2                	add	s3,s3,s8
    80001c18:	0779f863          	bgeu	s3,s7,80001c88 <mmap_unmap+0x13e>
    pte = walk(p->pagetable, a, 0);
    80001c1c:	4601                	li	a2,0
    80001c1e:	85ce                	mv	a1,s3
    80001c20:	078b3503          	ld	a0,120(s6)
    80001c24:	c54ff0ef          	jal	80001078 <walk>
    80001c28:	84aa                	mv	s1,a0
    if(pte == 0 || (*pte & PTE_V) == 0)
    80001c2a:	d575                	beqz	a0,80001c16 <mmap_unmap+0xcc>
    80001c2c:	00053903          	ld	s2,0(a0)
    80001c30:	00197793          	andi	a5,s2,1
    80001c34:	d3ed                	beqz	a5,80001c16 <mmap_unmap+0xcc>
    pa = PTE2PA(*pte);
    80001c36:	00a95913          	srli	s2,s2,0xa
    80001c3a:	0932                	slli	s2,s2,0xc
    if(vma->flags == MAP_SHARED){
    80001c3c:	024a2783          	lw	a5,36(s4)
    80001c40:	fda796e3          	bne	a5,s10,80001c0c <mmap_unmap+0xc2>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001c44:	008a3783          	ld	a5,8(s4)
    80001c48:	f8f43423          	sd	a5,-120(s0)
    80001c4c:	40f987b3          	sub	a5,s3,a5
    80001c50:	f8f43023          	sd	a5,-128(s0)
      if(a - vma->addr < vma->length){
    80001c54:	010a3d83          	ld	s11,16(s4)
    80001c58:	fbb7fae3          	bgeu	a5,s11,80001c0c <mmap_unmap+0xc2>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001c5c:	030a3783          	ld	a5,48(s4)
    80001c60:	f6f43c23          	sd	a5,-136(s0)
        begin_op();
    80001c64:	13e030ef          	jal	80004da2 <begin_op>
        ilock(vma->file->ip);
    80001c68:	028a3783          	ld	a5,40(s4)
    80001c6c:	6f88                	ld	a0,24(a5)
    80001c6e:	6d2020ef          	jal	80004340 <ilock>
        remaining = vma->length - (a - vma->addr);
    80001c72:	f8843783          	ld	a5,-120(s0)
    80001c76:	01b78733          	add	a4,a5,s11
    80001c7a:	41370733          	sub	a4,a4,s3
        if(remaining > PGSIZE)
    80001c7e:	6785                	lui	a5,0x1
    80001c80:	f6e7f2e3          	bgeu	a5,a4,80001be4 <mmap_unmap+0x9a>
    80001c84:	873e                	mv	a4,a5
    80001c86:	bfb9                	j	80001be4 <mmap_unmap+0x9a>
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001c88:	008a3783          	ld	a5,8(s4)
    80001c8c:	03578b63          	beq	a5,s5,80001cc2 <mmap_unmap+0x178>
    80001c90:	74e6                	ld	s1,120(sp)
    80001c92:	7946                	ld	s2,112(sp)
    80001c94:	6c06                	ld	s8,64(sp)
    80001c96:	7d42                	ld	s10,48(sp)
    80001c98:	7da2                	ld	s11,40(sp)
  if(end == vma->addr + vma->maplen){
    80001c9a:	018a3703          	ld	a4,24(s4)
    80001c9e:	97ba                	add	a5,a5,a4
    80001ca0:	09779763          	bne	a5,s7,80001d2e <mmap_unmap+0x1e4>
    vma->length -= length;
    80001ca4:	010a3783          	ld	a5,16(s4)
    80001ca8:	419787b3          	sub	a5,a5,s9
    80001cac:	00fa3823          	sd	a5,16(s4)
    vma->maplen -= length;
    80001cb0:	41970733          	sub	a4,a4,s9
    80001cb4:	00ea3c23          	sd	a4,24(s4)
    return 0;
    80001cb8:	4501                	li	a0,0
    80001cba:	79a6                	ld	s3,104(sp)
    80001cbc:	7a06                	ld	s4,96(sp)
    80001cbe:	6ba6                	ld	s7,72(sp)
    80001cc0:	bf19                	j	80001bd6 <mmap_unmap+0x8c>
    80001cc2:	74e6                	ld	s1,120(sp)
    80001cc4:	7946                	ld	s2,112(sp)
    80001cc6:	6c06                	ld	s8,64(sp)
    80001cc8:	7d42                	ld	s10,48(sp)
    80001cca:	7da2                	ld	s11,40(sp)
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001ccc:	018a3783          	ld	a5,24(s4)
    80001cd0:	03978863          	beq	a5,s9,80001d00 <mmap_unmap+0x1b6>
    vma->addr = end;
    80001cd4:	017a3423          	sd	s7,8(s4)
    vma->offset += length;
    80001cd8:	030a3703          	ld	a4,48(s4)
    80001cdc:	9766                	add	a4,a4,s9
    80001cde:	02ea3823          	sd	a4,48(s4)
    vma->length -= length;
    80001ce2:	010a3703          	ld	a4,16(s4)
    80001ce6:	41970733          	sub	a4,a4,s9
    80001cea:	00ea3823          	sd	a4,16(s4)
    vma->maplen -= length;
    80001cee:	419787b3          	sub	a5,a5,s9
    80001cf2:	00fa3c23          	sd	a5,24(s4)
    return 0;
    80001cf6:	4501                	li	a0,0
    80001cf8:	79a6                	ld	s3,104(sp)
    80001cfa:	7a06                	ld	s4,96(sp)
    80001cfc:	6ba6                	ld	s7,72(sp)
    80001cfe:	bde1                	j	80001bd6 <mmap_unmap+0x8c>
    fileclose(vma->file);
    80001d00:	028a3503          	ld	a0,40(s4)
    80001d04:	550030ef          	jal	80005254 <fileclose>
    memset(vma, 0, sizeof(*vma));
    80001d08:	03800613          	li	a2,56
    80001d0c:	4581                	li	a1,0
    80001d0e:	8552                	mv	a0,s4
    80001d10:	8d2ff0ef          	jal	80000de2 <memset>
    return 0;
    80001d14:	4501                	li	a0,0
    80001d16:	79a6                	ld	s3,104(sp)
    80001d18:	7a06                	ld	s4,96(sp)
    80001d1a:	6ba6                	ld	s7,72(sp)
    80001d1c:	bd6d                	j	80001bd6 <mmap_unmap+0x8c>
    return -1;
    80001d1e:	557d                	li	a0,-1
    80001d20:	7a06                	ld	s4,96(sp)
    80001d22:	bd55                	j	80001bd6 <mmap_unmap+0x8c>
    return -1;
    80001d24:	557d                	li	a0,-1
    80001d26:	79a6                	ld	s3,104(sp)
    80001d28:	7a06                	ld	s4,96(sp)
    80001d2a:	6ba6                	ld	s7,72(sp)
    80001d2c:	b56d                	j	80001bd6 <mmap_unmap+0x8c>
  return -1;
    80001d2e:	557d                	li	a0,-1
    80001d30:	79a6                	ld	s3,104(sp)
    80001d32:	7a06                	ld	s4,96(sp)
    80001d34:	6ba6                	ld	s7,72(sp)
    80001d36:	b545                	j	80001bd6 <mmap_unmap+0x8c>
  for(a = addr; a < end; a += PGSIZE){
    80001d38:	89d6                	mv	s3,s5
    80001d3a:	f97af9e3          	bgeu	s5,s7,80001ccc <mmap_unmap+0x182>
    80001d3e:	fca6                	sd	s1,120(sp)
    80001d40:	f8ca                	sd	s2,112(sp)
    80001d42:	e0e2                	sd	s8,64(sp)
    80001d44:	f86a                	sd	s10,48(sp)
    80001d46:	f46e                	sd	s11,40(sp)
    80001d48:	b559                	j	80001bce <mmap_unmap+0x84>
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001d4a:	008a3783          	ld	a5,8(s4)
    80001d4e:	b7b1                	j	80001c9a <mmap_unmap+0x150>

0000000080001d50 <mmap_cleanup>:

void
mmap_cleanup(struct proc *p)
{
    80001d50:	7179                	addi	sp,sp,-48
    80001d52:	f406                	sd	ra,40(sp)
    80001d54:	f022                	sd	s0,32(sp)
    80001d56:	ec26                	sd	s1,24(sp)
    80001d58:	e84a                	sd	s2,16(sp)
    80001d5a:	e44e                	sd	s3,8(sp)
    80001d5c:	1800                	addi	s0,sp,48
    80001d5e:	89aa                	mv	s3,a0
  for(int i = 0; i < NVMA; i++){
    80001d60:	18050493          	addi	s1,a0,384
    80001d64:	50050913          	addi	s2,a0,1280
    80001d68:	a029                	j	80001d72 <mmap_cleanup+0x22>
    80001d6a:	03848493          	addi	s1,s1,56
    80001d6e:	01248a63          	beq	s1,s2,80001d82 <mmap_cleanup+0x32>
    if(p->vmas[i].used)
    80001d72:	409c                	lw	a5,0(s1)
    80001d74:	dbfd                	beqz	a5,80001d6a <mmap_cleanup+0x1a>
      mmap_unmap(p, p->vmas[i].addr, p->vmas[i].maplen);
    80001d76:	6c90                	ld	a2,24(s1)
    80001d78:	648c                	ld	a1,8(s1)
    80001d7a:	854e                	mv	a0,s3
    80001d7c:	dcfff0ef          	jal	80001b4a <mmap_unmap>
    80001d80:	b7ed                	j	80001d6a <mmap_cleanup+0x1a>
  }
    80001d82:	70a2                	ld	ra,40(sp)
    80001d84:	7402                	ld	s0,32(sp)
    80001d86:	64e2                	ld	s1,24(sp)
    80001d88:	6942                	ld	s2,16(sp)
    80001d8a:	69a2                	ld	s3,8(sp)
    80001d8c:	6145                	addi	sp,sp,48
    80001d8e:	8082                	ret

0000000080001d90 <print_ptree_nodes>:
    // clang-format on
  };
  int i, d;
  char *st;

  if(depth > 16)
    80001d90:	47c1                	li	a5,16
    80001d92:	0ed7c063          	blt	a5,a3,80001e72 <print_ptree_nodes+0xe2>
{
    80001d96:	711d                	addi	sp,sp,-96
    80001d98:	ec86                	sd	ra,88(sp)
    80001d9a:	e8a2                	sd	s0,80(sp)
    80001d9c:	fc4e                	sd	s3,56(sp)
    80001d9e:	f852                	sd	s4,48(sp)
    80001da0:	f456                	sd	s5,40(sp)
    80001da2:	e862                	sd	s8,16(sp)
    80001da4:	1080                	addi	s0,sp,96
    80001da6:	8c2a                	mv	s8,a0
    80001da8:	8aae                	mv	s5,a1
    80001daa:	8a32                	mv	s4,a2
    80001dac:	89b6                	mv	s3,a3
    return;

  for(i = 0; i < count; i++){
    80001dae:	02b05663          	blez	a1,80001dda <print_ptree_nodes+0x4a>
    80001db2:	e4a6                	sd	s1,72(sp)
    80001db4:	f05a                	sd	s6,32(sp)
    80001db6:	ec5e                	sd	s7,24(sp)
    80001db8:	00f504b3          	add	s1,a0,a5
    80001dbc:	00559b93          	slli	s7,a1,0x5
    80001dc0:	9ba6                	add	s7,s7,s1
    if(nodes[i].ppid == ppid){
    80001dc2:	8b26                	mv	s6,s1
    80001dc4:	ff44a783          	lw	a5,-12(s1)
    80001dc8:	03478163          	beq	a5,s4,80001dea <print_ptree_nodes+0x5a>
  for(i = 0; i < count; i++){
    80001dcc:	02048493          	addi	s1,s1,32
    80001dd0:	ff7499e3          	bne	s1,s7,80001dc2 <print_ptree_nodes+0x32>
    80001dd4:	64a6                	ld	s1,72(sp)
    80001dd6:	7b02                	ld	s6,32(sp)
    80001dd8:	6be2                	ld	s7,24(sp)
      printk("[%d] %s (prio=%d, state=%s)\n",
             nodes[i].pid, nodes[i].name, nodes[i].priority, st);
      print_ptree_nodes(nodes, count, nodes[i].pid, depth + 1);
    }
  }
}
    80001dda:	60e6                	ld	ra,88(sp)
    80001ddc:	6446                	ld	s0,80(sp)
    80001dde:	79e2                	ld	s3,56(sp)
    80001de0:	7a42                	ld	s4,48(sp)
    80001de2:	7aa2                	ld	s5,40(sp)
    80001de4:	6c42                	ld	s8,16(sp)
    80001de6:	6125                	addi	sp,sp,96
    80001de8:	8082                	ret
      for(d = 0; d < depth; d++)
    80001dea:	03305763          	blez	s3,80001e18 <print_ptree_nodes+0x88>
    80001dee:	e0ca                	sd	s2,64(sp)
    80001df0:	e466                	sd	s9,8(sp)
    80001df2:	4901                	li	s2,0
        printk("  ");
    80001df4:	00006c97          	auipc	s9,0x6
    80001df8:	384c8c93          	addi	s9,s9,900 # 80008178 <etext+0x178>
    80001dfc:	8566                	mv	a0,s9
    80001dfe:	f0cfe0ef          	jal	8000050a <printk>
      for(d = 0; d < depth; d++)
    80001e02:	2905                	addiw	s2,s2,1
    80001e04:	ff299ce3          	bne	s3,s2,80001dfc <print_ptree_nodes+0x6c>
        printk("|-- ");
    80001e08:	00006517          	auipc	a0,0x6
    80001e0c:	37850513          	addi	a0,a0,888 # 80008180 <etext+0x180>
    80001e10:	efafe0ef          	jal	8000050a <printk>
    80001e14:	6906                	ld	s2,64(sp)
    80001e16:	6ca2                	ld	s9,8(sp)
      if(nodes[i].state >= 0 && nodes[i].state < NELEM(states) && states[nodes[i].state])
    80001e18:	ffcb2783          	lw	a5,-4(s6)
    80001e1c:	4695                	li	a3,5
        st = "???";
    80001e1e:	00006717          	auipc	a4,0x6
    80001e22:	35270713          	addi	a4,a4,850 # 80008170 <etext+0x170>
      if(nodes[i].state >= 0 && nodes[i].state < NELEM(states) && states[nodes[i].state])
    80001e26:	00f6ed63          	bltu	a3,a5,80001e40 <print_ptree_nodes+0xb0>
    80001e2a:	02079713          	slli	a4,a5,0x20
    80001e2e:	01d75793          	srli	a5,a4,0x1d
    80001e32:	00007717          	auipc	a4,0x7
    80001e36:	ae670713          	addi	a4,a4,-1306 # 80008918 <states.0>
    80001e3a:	97ba                	add	a5,a5,a4
    80001e3c:	6398                	ld	a4,0(a5)
    80001e3e:	c70d                	beqz	a4,80001e68 <print_ptree_nodes+0xd8>
      printk("[%d] %s (prio=%d, state=%s)\n",
    80001e40:	ff8b2683          	lw	a3,-8(s6)
    80001e44:	865a                	mv	a2,s6
    80001e46:	ff0b2583          	lw	a1,-16(s6)
    80001e4a:	00006517          	auipc	a0,0x6
    80001e4e:	33e50513          	addi	a0,a0,830 # 80008188 <etext+0x188>
    80001e52:	eb8fe0ef          	jal	8000050a <printk>
      print_ptree_nodes(nodes, count, nodes[i].pid, depth + 1);
    80001e56:	0019869b          	addiw	a3,s3,1
    80001e5a:	ff0b2603          	lw	a2,-16(s6)
    80001e5e:	85d6                	mv	a1,s5
    80001e60:	8562                	mv	a0,s8
    80001e62:	f2fff0ef          	jal	80001d90 <print_ptree_nodes>
    80001e66:	b79d                	j	80001dcc <print_ptree_nodes+0x3c>
        st = "???";
    80001e68:	00006717          	auipc	a4,0x6
    80001e6c:	30870713          	addi	a4,a4,776 # 80008170 <etext+0x170>
    80001e70:	bfc1                	j	80001e40 <print_ptree_nodes+0xb0>
    80001e72:	8082                	ret

0000000080001e74 <proc_mapstacks>:
{
    80001e74:	715d                	addi	sp,sp,-80
    80001e76:	e486                	sd	ra,72(sp)
    80001e78:	e0a2                	sd	s0,64(sp)
    80001e7a:	fc26                	sd	s1,56(sp)
    80001e7c:	f84a                	sd	s2,48(sp)
    80001e7e:	f44e                	sd	s3,40(sp)
    80001e80:	f052                	sd	s4,32(sp)
    80001e82:	ec56                	sd	s5,24(sp)
    80001e84:	e85a                	sd	s6,16(sp)
    80001e86:	e45e                	sd	s7,8(sp)
    80001e88:	e062                	sd	s8,0(sp)
    80001e8a:	0880                	addi	s0,sp,80
    80001e8c:	8a2a                	mv	s4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e8e:	0022f497          	auipc	s1,0x22f
    80001e92:	2fa48493          	addi	s1,s1,762 # 80231188 <proc>
    uint64 va = KSTACK((int)(p - proc));
    80001e96:	8c26                	mv	s8,s1
    80001e98:	781957b7          	lui	a5,0x78195
    80001e9c:	8b178793          	addi	a5,a5,-1871 # 781948b1 <_entry-0x7e6b74f>
    80001ea0:	2c3f3937          	lui	s2,0x2c3f3
    80001ea4:	5ba90913          	addi	s2,s2,1466 # 2c3f35ba <_entry-0x53c0ca46>
    80001ea8:	1902                	slli	s2,s2,0x20
    80001eaa:	993e                	add	s2,s2,a5
    80001eac:	040009b7          	lui	s3,0x4000
    80001eb0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001eb2:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001eb4:	4b99                	li	s7,6
    80001eb6:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    80001eb8:	00243a97          	auipc	s5,0x243
    80001ebc:	6d0a8a93          	addi	s5,s5,1744 # 80245588 <tickslock>
    char *pa = kalloc();
    80001ec0:	c75fe0ef          	jal	80000b34 <kalloc>
    80001ec4:	862a                	mv	a2,a0
    if (pa == 0)
    80001ec6:	c121                	beqz	a0,80001f06 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    80001ec8:	418485b3          	sub	a1,s1,s8
    80001ecc:	8591                	srai	a1,a1,0x4
    80001ece:	032585b3          	mul	a1,a1,s2
    80001ed2:	2585                	addiw	a1,a1,1
    80001ed4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ed8:	875e                	mv	a4,s7
    80001eda:	86da                	mv	a3,s6
    80001edc:	40b985b3          	sub	a1,s3,a1
    80001ee0:	8552                	mv	a0,s4
    80001ee2:	b24ff0ef          	jal	80001206 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001ee6:	51048493          	addi	s1,s1,1296
    80001eea:	fd549be3          	bne	s1,s5,80001ec0 <proc_mapstacks+0x4c>
}
    80001eee:	60a6                	ld	ra,72(sp)
    80001ef0:	6406                	ld	s0,64(sp)
    80001ef2:	74e2                	ld	s1,56(sp)
    80001ef4:	7942                	ld	s2,48(sp)
    80001ef6:	79a2                	ld	s3,40(sp)
    80001ef8:	7a02                	ld	s4,32(sp)
    80001efa:	6ae2                	ld	s5,24(sp)
    80001efc:	6b42                	ld	s6,16(sp)
    80001efe:	6ba2                	ld	s7,8(sp)
    80001f00:	6c02                	ld	s8,0(sp)
    80001f02:	6161                	addi	sp,sp,80
    80001f04:	8082                	ret
      panic("kalloc");
    80001f06:	00006517          	auipc	a0,0x6
    80001f0a:	2a250513          	addi	a0,a0,674 # 800081a8 <etext+0x1a8>
    80001f0e:	8e1fe0ef          	jal	800007ee <panic>

0000000080001f12 <procinit>:
{
    80001f12:	7139                	addi	sp,sp,-64
    80001f14:	fc06                	sd	ra,56(sp)
    80001f16:	f822                	sd	s0,48(sp)
    80001f18:	f426                	sd	s1,40(sp)
    80001f1a:	f04a                	sd	s2,32(sp)
    80001f1c:	ec4e                	sd	s3,24(sp)
    80001f1e:	e852                	sd	s4,16(sp)
    80001f20:	e456                	sd	s5,8(sp)
    80001f22:	e05a                	sd	s6,0(sp)
    80001f24:	0080                	addi	s0,sp,64
  initlock(&pid_lock, "nextpid");
    80001f26:	00006597          	auipc	a1,0x6
    80001f2a:	28a58593          	addi	a1,a1,650 # 800081b0 <etext+0x1b0>
    80001f2e:	0022f517          	auipc	a0,0x22f
    80001f32:	e2a50513          	addi	a0,a0,-470 # 80230d58 <pid_lock>
    80001f36:	d73fe0ef          	jal	80000ca8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001f3a:	00006597          	auipc	a1,0x6
    80001f3e:	27e58593          	addi	a1,a1,638 # 800081b8 <etext+0x1b8>
    80001f42:	0022f517          	auipc	a0,0x22f
    80001f46:	e2e50513          	addi	a0,a0,-466 # 80230d70 <wait_lock>
    80001f4a:	d5ffe0ef          	jal	80000ca8 <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f4e:	0022f497          	auipc	s1,0x22f
    80001f52:	23a48493          	addi	s1,s1,570 # 80231188 <proc>
    initlock(&p->lock, "proc");
    80001f56:	00006b17          	auipc	s6,0x6
    80001f5a:	272b0b13          	addi	s6,s6,626 # 800081c8 <etext+0x1c8>
    p->kstack = KSTACK((int)(p - proc));
    80001f5e:	8aa6                	mv	s5,s1
    80001f60:	781957b7          	lui	a5,0x78195
    80001f64:	8b178793          	addi	a5,a5,-1871 # 781948b1 <_entry-0x7e6b74f>
    80001f68:	2c3f3937          	lui	s2,0x2c3f3
    80001f6c:	5ba90913          	addi	s2,s2,1466 # 2c3f35ba <_entry-0x53c0ca46>
    80001f70:	1902                	slli	s2,s2,0x20
    80001f72:	993e                	add	s2,s2,a5
    80001f74:	040009b7          	lui	s3,0x4000
    80001f78:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001f7a:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f7c:	00243a17          	auipc	s4,0x243
    80001f80:	60ca0a13          	addi	s4,s4,1548 # 80245588 <tickslock>
    initlock(&p->lock, "proc");
    80001f84:	85da                	mv	a1,s6
    80001f86:	8526                	mv	a0,s1
    80001f88:	d21fe0ef          	jal	80000ca8 <initlock>
    p->state = UNUSED;
    80001f8c:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001f90:	415487b3          	sub	a5,s1,s5
    80001f94:	8791                	srai	a5,a5,0x4
    80001f96:	032787b3          	mul	a5,a5,s2
    80001f9a:	2785                	addiw	a5,a5,1
    80001f9c:	00d7979b          	slliw	a5,a5,0xd
    80001fa0:	40f987b3          	sub	a5,s3,a5
    80001fa4:	f4bc                	sd	a5,104(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001fa6:	51048493          	addi	s1,s1,1296
    80001faa:	fd449de3          	bne	s1,s4,80001f84 <procinit+0x72>
}
    80001fae:	70e2                	ld	ra,56(sp)
    80001fb0:	7442                	ld	s0,48(sp)
    80001fb2:	74a2                	ld	s1,40(sp)
    80001fb4:	7902                	ld	s2,32(sp)
    80001fb6:	69e2                	ld	s3,24(sp)
    80001fb8:	6a42                	ld	s4,16(sp)
    80001fba:	6aa2                	ld	s5,8(sp)
    80001fbc:	6b02                	ld	s6,0(sp)
    80001fbe:	6121                	addi	sp,sp,64
    80001fc0:	8082                	ret

0000000080001fc2 <cpuid>:
{
    80001fc2:	1141                	addi	sp,sp,-16
    80001fc4:	e406                	sd	ra,8(sp)
    80001fc6:	e022                	sd	s0,0(sp)
    80001fc8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001fca:	8512                	mv	a0,tp
}
    80001fcc:	2501                	sext.w	a0,a0
    80001fce:	60a2                	ld	ra,8(sp)
    80001fd0:	6402                	ld	s0,0(sp)
    80001fd2:	0141                	addi	sp,sp,16
    80001fd4:	8082                	ret

0000000080001fd6 <mycpu>:
{
    80001fd6:	1141                	addi	sp,sp,-16
    80001fd8:	e406                	sd	ra,8(sp)
    80001fda:	e022                	sd	s0,0(sp)
    80001fdc:	0800                	addi	s0,sp,16
    80001fde:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001fe0:	2781                	sext.w	a5,a5
    80001fe2:	079e                	slli	a5,a5,0x7
}
    80001fe4:	0022f517          	auipc	a0,0x22f
    80001fe8:	da450513          	addi	a0,a0,-604 # 80230d88 <cpus>
    80001fec:	953e                	add	a0,a0,a5
    80001fee:	60a2                	ld	ra,8(sp)
    80001ff0:	6402                	ld	s0,0(sp)
    80001ff2:	0141                	addi	sp,sp,16
    80001ff4:	8082                	ret

0000000080001ff6 <myproc>:
{
    80001ff6:	1101                	addi	sp,sp,-32
    80001ff8:	ec06                	sd	ra,24(sp)
    80001ffa:	e822                	sd	s0,16(sp)
    80001ffc:	e426                	sd	s1,8(sp)
    80001ffe:	1000                	addi	s0,sp,32
  push_off();
    80002000:	cedfe0ef          	jal	80000cec <push_off>
    80002004:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80002006:	2781                	sext.w	a5,a5
    80002008:	079e                	slli	a5,a5,0x7
    8000200a:	0022f717          	auipc	a4,0x22f
    8000200e:	d4e70713          	addi	a4,a4,-690 # 80230d58 <pid_lock>
    80002012:	97ba                	add	a5,a5,a4
    80002014:	7b84                	ld	s1,48(a5)
  pop_off();
    80002016:	d4dfe0ef          	jal	80000d62 <pop_off>
}
    8000201a:	8526                	mv	a0,s1
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6105                	addi	sp,sp,32
    80002024:	8082                	ret

0000000080002026 <forkret>:
{
    80002026:	7179                	addi	sp,sp,-48
    80002028:	f406                	sd	ra,40(sp)
    8000202a:	f022                	sd	s0,32(sp)
    8000202c:	ec26                	sd	s1,24(sp)
    8000202e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002030:	fc7ff0ef          	jal	80001ff6 <myproc>
    80002034:	84aa                	mv	s1,a0
  release(&p->lock);
    80002036:	d75fe0ef          	jal	80000daa <release>
  if (first) {
    8000203a:	00007797          	auipc	a5,0x7
    8000203e:	bb67a783          	lw	a5,-1098(a5) # 80008bf0 <first.2>
    80002042:	cb9d                	beqz	a5,80002078 <forkret+0x52>
    first = 0;
    80002044:	00007797          	auipc	a5,0x7
    80002048:	ba07a623          	sw	zero,-1108(a5) # 80008bf0 <first.2>
    fsinit(ROOTDEV);
    8000204c:	4505                	li	a0,1
    8000204e:	62c020ef          	jal	8000467a <fsinit>
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80002052:	00006517          	auipc	a0,0x6
    80002056:	17e50513          	addi	a0,a0,382 # 800081d0 <etext+0x1d0>
    8000205a:	fca43823          	sd	a0,-48(s0)
    8000205e:	fc043c23          	sd	zero,-40(s0)
    80002062:	fd040593          	addi	a1,s0,-48
    80002066:	077030ef          	jal	800058dc <kexec>
    8000206a:	60dc                	ld	a5,128(s1)
    8000206c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000206e:	60dc                	ld	a5,128(s1)
    80002070:	7bb8                	ld	a4,112(a5)
    80002072:	57fd                	li	a5,-1
    80002074:	02f70d63          	beq	a4,a5,800020ae <forkret+0x88>
  prepare_return();
    80002078:	050010ef          	jal	800030c8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000207c:	7ca8                	ld	a0,120(s1)
    8000207e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002080:	04000737          	lui	a4,0x4000
    80002084:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002086:	0732                	slli	a4,a4,0xc
    80002088:	00005797          	auipc	a5,0x5
    8000208c:	01478793          	addi	a5,a5,20 # 8000709c <userret>
    80002090:	00005697          	auipc	a3,0x5
    80002094:	f7068693          	addi	a3,a3,-144 # 80007000 <_trampoline>
    80002098:	8f95                	sub	a5,a5,a3
    8000209a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000209c:	577d                	li	a4,-1
    8000209e:	177e                	slli	a4,a4,0x3f
    800020a0:	8d59                	or	a0,a0,a4
    800020a2:	9782                	jalr	a5
}
    800020a4:	70a2                	ld	ra,40(sp)
    800020a6:	7402                	ld	s0,32(sp)
    800020a8:	64e2                	ld	s1,24(sp)
    800020aa:	6145                	addi	sp,sp,48
    800020ac:	8082                	ret
      panic("exec");
    800020ae:	00006517          	auipc	a0,0x6
    800020b2:	12a50513          	addi	a0,a0,298 # 800081d8 <etext+0x1d8>
    800020b6:	f38fe0ef          	jal	800007ee <panic>

00000000800020ba <allocpid>:
{
    800020ba:	1101                	addi	sp,sp,-32
    800020bc:	ec06                	sd	ra,24(sp)
    800020be:	e822                	sd	s0,16(sp)
    800020c0:	e426                	sd	s1,8(sp)
    800020c2:	e04a                	sd	s2,0(sp)
    800020c4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800020c6:	0022f917          	auipc	s2,0x22f
    800020ca:	c9290913          	addi	s2,s2,-878 # 80230d58 <pid_lock>
    800020ce:	854a                	mv	a0,s2
    800020d0:	c53fe0ef          	jal	80000d22 <acquire>
  pid = nextpid;
    800020d4:	00007797          	auipc	a5,0x7
    800020d8:	b2078793          	addi	a5,a5,-1248 # 80008bf4 <nextpid>
    800020dc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800020de:	0014871b          	addiw	a4,s1,1
    800020e2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800020e4:	854a                	mv	a0,s2
    800020e6:	cc5fe0ef          	jal	80000daa <release>
}
    800020ea:	8526                	mv	a0,s1
    800020ec:	60e2                	ld	ra,24(sp)
    800020ee:	6442                	ld	s0,16(sp)
    800020f0:	64a2                	ld	s1,8(sp)
    800020f2:	6902                	ld	s2,0(sp)
    800020f4:	6105                	addi	sp,sp,32
    800020f6:	8082                	ret

00000000800020f8 <proc_pagetable>:
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	e04a                	sd	s2,0(sp)
    80002102:	1000                	addi	s0,sp,32
    80002104:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80002106:	a00ff0ef          	jal	80001306 <uvmcreate>
    8000210a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000210c:	cd05                	beqz	a0,80002144 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    8000210e:	4729                	li	a4,10
    80002110:	00005697          	auipc	a3,0x5
    80002114:	ef068693          	addi	a3,a3,-272 # 80007000 <_trampoline>
    80002118:	6605                	lui	a2,0x1
    8000211a:	040005b7          	lui	a1,0x4000
    8000211e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002120:	05b2                	slli	a1,a1,0xc
    80002122:	82eff0ef          	jal	80001150 <mappages>
    80002126:	02054663          	bltz	a0,80002152 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    8000212a:	4719                	li	a4,6
    8000212c:	08093683          	ld	a3,128(s2)
    80002130:	6605                	lui	a2,0x1
    80002132:	020005b7          	lui	a1,0x2000
    80002136:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002138:	05b6                	slli	a1,a1,0xd
    8000213a:	8526                	mv	a0,s1
    8000213c:	814ff0ef          	jal	80001150 <mappages>
    80002140:	00054f63          	bltz	a0,8000215e <proc_pagetable+0x66>
}
    80002144:	8526                	mv	a0,s1
    80002146:	60e2                	ld	ra,24(sp)
    80002148:	6442                	ld	s0,16(sp)
    8000214a:	64a2                	ld	s1,8(sp)
    8000214c:	6902                	ld	s2,0(sp)
    8000214e:	6105                	addi	sp,sp,32
    80002150:	8082                	ret
    uvmfree(pagetable, 0);
    80002152:	4581                	li	a1,0
    80002154:	8526                	mv	a0,s1
    80002156:	bb2ff0ef          	jal	80001508 <uvmfree>
    return 0;
    8000215a:	4481                	li	s1,0
    8000215c:	b7e5                	j	80002144 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000215e:	4681                	li	a3,0
    80002160:	4605                	li	a2,1
    80002162:	040005b7          	lui	a1,0x4000
    80002166:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002168:	05b2                	slli	a1,a1,0xc
    8000216a:	8526                	mv	a0,s1
    8000216c:	9c0ff0ef          	jal	8000132c <uvmunmap>
    uvmfree(pagetable, 0);
    80002170:	4581                	li	a1,0
    80002172:	8526                	mv	a0,s1
    80002174:	b94ff0ef          	jal	80001508 <uvmfree>
    return 0;
    80002178:	4481                	li	s1,0
    8000217a:	b7e9                	j	80002144 <proc_pagetable+0x4c>

000000008000217c <proc_freepagetable>:
{
    8000217c:	1101                	addi	sp,sp,-32
    8000217e:	ec06                	sd	ra,24(sp)
    80002180:	e822                	sd	s0,16(sp)
    80002182:	e426                	sd	s1,8(sp)
    80002184:	e04a                	sd	s2,0(sp)
    80002186:	1000                	addi	s0,sp,32
    80002188:	84aa                	mv	s1,a0
    8000218a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000218c:	4681                	li	a3,0
    8000218e:	4605                	li	a2,1
    80002190:	040005b7          	lui	a1,0x4000
    80002194:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002196:	05b2                	slli	a1,a1,0xc
    80002198:	994ff0ef          	jal	8000132c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000219c:	4681                	li	a3,0
    8000219e:	4605                	li	a2,1
    800021a0:	020005b7          	lui	a1,0x2000
    800021a4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800021a6:	05b6                	slli	a1,a1,0xd
    800021a8:	8526                	mv	a0,s1
    800021aa:	982ff0ef          	jal	8000132c <uvmunmap>
  uvmfree(pagetable, sz);
    800021ae:	85ca                	mv	a1,s2
    800021b0:	8526                	mv	a0,s1
    800021b2:	b56ff0ef          	jal	80001508 <uvmfree>
}
    800021b6:	60e2                	ld	ra,24(sp)
    800021b8:	6442                	ld	s0,16(sp)
    800021ba:	64a2                	ld	s1,8(sp)
    800021bc:	6902                	ld	s2,0(sp)
    800021be:	6105                	addi	sp,sp,32
    800021c0:	8082                	ret

00000000800021c2 <freeproc>:
{
    800021c2:	1101                	addi	sp,sp,-32
    800021c4:	ec06                	sd	ra,24(sp)
    800021c6:	e822                	sd	s0,16(sp)
    800021c8:	e426                	sd	s1,8(sp)
    800021ca:	1000                	addi	s0,sp,32
    800021cc:	84aa                	mv	s1,a0
  if (p->trapframe)
    800021ce:	6148                	ld	a0,128(a0)
    800021d0:	c119                	beqz	a0,800021d6 <freeproc+0x14>
    kfree((void *)p->trapframe);
    800021d2:	80ffe0ef          	jal	800009e0 <kfree>
  p->trapframe = 0;
    800021d6:	0804b023          	sd	zero,128(s1)
  if (p->pagetable)
    800021da:	7ca8                	ld	a0,120(s1)
    800021dc:	c501                	beqz	a0,800021e4 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800021de:	78ac                	ld	a1,112(s1)
    800021e0:	f9dff0ef          	jal	8000217c <proc_freepagetable>
  p->pagetable = 0;
    800021e4:	0604bc23          	sd	zero,120(s1)
  p->sz = 0;
    800021e8:	0604b823          	sd	zero,112(s1)
  p->pid = 0;
    800021ec:	0204a823          	sw	zero,48(s1)
  p->priority = 0;
    800021f0:	0204aa23          	sw	zero,52(s1)
  p->cpu_time = 0;
    800021f4:	0204bc23          	sd	zero,56(s1)
  p->trace_mask = 0;
    800021f8:	0404b023          	sd	zero,64(s1)
  p->syscall_count = 0;
    800021fc:	0404b423          	sd	zero,72(s1)
  p->ctime = 0;
    80002200:	0404b823          	sd	zero,80(s1)
  p->last_run_tick = 0;
    80002204:	0404bc23          	sd	zero,88(s1)
  p->name[0] = 0;
    80002208:	50048023          	sb	zero,1280(s1)
  p->chan = 0;
    8000220c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002210:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002214:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002218:	0004ac23          	sw	zero,24(s1)
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <allocproc>:
{
    80002226:	7179                	addi	sp,sp,-48
    80002228:	f406                	sd	ra,40(sp)
    8000222a:	f022                	sd	s0,32(sp)
    8000222c:	ec26                	sd	s1,24(sp)
    8000222e:	e84a                	sd	s2,16(sp)
    80002230:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80002232:	0022f497          	auipc	s1,0x22f
    80002236:	f5648493          	addi	s1,s1,-170 # 80231188 <proc>
    8000223a:	00243917          	auipc	s2,0x243
    8000223e:	34e90913          	addi	s2,s2,846 # 80245588 <tickslock>
    acquire(&p->lock);
    80002242:	8526                	mv	a0,s1
    80002244:	adffe0ef          	jal	80000d22 <acquire>
    if (p->state == UNUSED) {
    80002248:	4c9c                	lw	a5,24(s1)
    8000224a:	cb91                	beqz	a5,8000225e <allocproc+0x38>
      release(&p->lock);
    8000224c:	8526                	mv	a0,s1
    8000224e:	b5dfe0ef          	jal	80000daa <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002252:	51048493          	addi	s1,s1,1296
    80002256:	ff2496e3          	bne	s1,s2,80002242 <allocproc+0x1c>
  return 0;
    8000225a:	4481                	li	s1,0
    8000225c:	a051                	j	800022e0 <allocproc+0xba>
    8000225e:	e44e                	sd	s3,8(sp)
    80002260:	e052                	sd	s4,0(sp)
  p->pid = allocpid();
    80002262:	e59ff0ef          	jal	800020ba <allocpid>
    80002266:	d888                	sw	a0,48(s1)
  p->priority = 10;
    80002268:	47a9                	li	a5,10
    8000226a:	d8dc                	sw	a5,52(s1)
  p->cpu_time = 0;
    8000226c:	0204bc23          	sd	zero,56(s1)
  p->trace_mask = 0;
    80002270:	0404b023          	sd	zero,64(s1)
  p->syscall_count = 0;
    80002274:	0404b423          	sd	zero,72(s1)
  p->ctime = ticks;
    80002278:	00007797          	auipc	a5,0x7
    8000227c:	9a87e783          	lwu	a5,-1624(a5) # 80008c20 <ticks>
    80002280:	e8bc                	sd	a5,80(s1)
  p->last_run_tick = ticks;
    80002282:	ecbc                	sd	a5,88(s1)
  for(int i = 0; i < NVMA; i++)
    80002284:	18048913          	addi	s2,s1,384
    80002288:	50048a13          	addi	s4,s1,1280
    memset(&p->vmas[i], 0, sizeof(p->vmas[i]));
    8000228c:	03800993          	li	s3,56
    80002290:	864e                	mv	a2,s3
    80002292:	4581                	li	a1,0
    80002294:	854a                	mv	a0,s2
    80002296:	b4dfe0ef          	jal	80000de2 <memset>
  for(int i = 0; i < NVMA; i++)
    8000229a:	03890913          	addi	s2,s2,56
    8000229e:	ff4919e3          	bne	s2,s4,80002290 <allocproc+0x6a>
  p->state = USED;
    800022a2:	4785                	li	a5,1
    800022a4:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    800022a6:	88ffe0ef          	jal	80000b34 <kalloc>
    800022aa:	892a                	mv	s2,a0
    800022ac:	e0c8                	sd	a0,128(s1)
    800022ae:	c121                	beqz	a0,800022ee <allocproc+0xc8>
  p->pagetable = proc_pagetable(p);
    800022b0:	8526                	mv	a0,s1
    800022b2:	e47ff0ef          	jal	800020f8 <proc_pagetable>
    800022b6:	892a                	mv	s2,a0
    800022b8:	fca8                	sd	a0,120(s1)
  if (p->pagetable == 0) {
    800022ba:	c521                	beqz	a0,80002302 <allocproc+0xdc>
  memset(&p->context, 0, sizeof(p->context));
    800022bc:	07000613          	li	a2,112
    800022c0:	4581                	li	a1,0
    800022c2:	08848513          	addi	a0,s1,136
    800022c6:	b1dfe0ef          	jal	80000de2 <memset>
  p->context.ra = (uint64)forkret;
    800022ca:	00000797          	auipc	a5,0x0
    800022ce:	d5c78793          	addi	a5,a5,-676 # 80002026 <forkret>
    800022d2:	e4dc                	sd	a5,136(s1)
  p->context.sp = p->kstack + PGSIZE;
    800022d4:	74bc                	ld	a5,104(s1)
    800022d6:	6705                	lui	a4,0x1
    800022d8:	97ba                	add	a5,a5,a4
    800022da:	e8dc                	sd	a5,144(s1)
    800022dc:	69a2                	ld	s3,8(sp)
    800022de:	6a02                	ld	s4,0(sp)
}
    800022e0:	8526                	mv	a0,s1
    800022e2:	70a2                	ld	ra,40(sp)
    800022e4:	7402                	ld	s0,32(sp)
    800022e6:	64e2                	ld	s1,24(sp)
    800022e8:	6942                	ld	s2,16(sp)
    800022ea:	6145                	addi	sp,sp,48
    800022ec:	8082                	ret
    freeproc(p);
    800022ee:	8526                	mv	a0,s1
    800022f0:	ed3ff0ef          	jal	800021c2 <freeproc>
    release(&p->lock);
    800022f4:	8526                	mv	a0,s1
    800022f6:	ab5fe0ef          	jal	80000daa <release>
    return 0;
    800022fa:	84ca                	mv	s1,s2
    800022fc:	69a2                	ld	s3,8(sp)
    800022fe:	6a02                	ld	s4,0(sp)
    80002300:	b7c5                	j	800022e0 <allocproc+0xba>
    freeproc(p);
    80002302:	8526                	mv	a0,s1
    80002304:	ebfff0ef          	jal	800021c2 <freeproc>
    release(&p->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	aa1fe0ef          	jal	80000daa <release>
    return 0;
    8000230e:	84ca                	mv	s1,s2
    80002310:	69a2                	ld	s3,8(sp)
    80002312:	6a02                	ld	s4,0(sp)
    80002314:	b7f1                	j	800022e0 <allocproc+0xba>

0000000080002316 <userinit>:
{
    80002316:	1101                	addi	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	e426                	sd	s1,8(sp)
    8000231e:	1000                	addi	s0,sp,32
  p = allocproc();
    80002320:	f07ff0ef          	jal	80002226 <allocproc>
    80002324:	84aa                	mv	s1,a0
  initproc = p;
    80002326:	00007797          	auipc	a5,0x7
    8000232a:	8ea7b923          	sd	a0,-1806(a5) # 80008c18 <initproc>
  p->cwd = namei("/");
    8000232e:	00006517          	auipc	a0,0x6
    80002332:	eb250513          	addi	a0,a0,-334 # 800081e0 <etext+0x1e0>
    80002336:	093020ef          	jal	80004bc8 <namei>
    8000233a:	16a4bc23          	sd	a0,376(s1)
  p->last_run_tick = ticks;
    8000233e:	00007797          	auipc	a5,0x7
    80002342:	8e27e783          	lwu	a5,-1822(a5) # 80008c20 <ticks>
    80002346:	ecbc                	sd	a5,88(s1)
  p->state = RUNNABLE;
    80002348:	478d                	li	a5,3
    8000234a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000234c:	8526                	mv	a0,s1
    8000234e:	a5dfe0ef          	jal	80000daa <release>
}
    80002352:	60e2                	ld	ra,24(sp)
    80002354:	6442                	ld	s0,16(sp)
    80002356:	64a2                	ld	s1,8(sp)
    80002358:	6105                	addi	sp,sp,32
    8000235a:	8082                	ret

000000008000235c <growproc>:
{
    8000235c:	1101                	addi	sp,sp,-32
    8000235e:	ec06                	sd	ra,24(sp)
    80002360:	e822                	sd	s0,16(sp)
    80002362:	e426                	sd	s1,8(sp)
    80002364:	e04a                	sd	s2,0(sp)
    80002366:	1000                	addi	s0,sp,32
    80002368:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000236a:	c8dff0ef          	jal	80001ff6 <myproc>
    8000236e:	892a                	mv	s2,a0
  sz = p->sz;
    80002370:	792c                	ld	a1,112(a0)
  if (n > 0) {
    80002372:	02905963          	blez	s1,800023a4 <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    80002376:	00b48633          	add	a2,s1,a1
    8000237a:	020007b7          	lui	a5,0x2000
    8000237e:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002380:	07b6                	slli	a5,a5,0xd
    80002382:	02c7ea63          	bltu	a5,a2,800023b6 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002386:	4691                	li	a3,4
    80002388:	7d28                	ld	a0,120(a0)
    8000238a:	870ff0ef          	jal	800013fa <uvmalloc>
    8000238e:	85aa                	mv	a1,a0
    80002390:	c50d                	beqz	a0,800023ba <growproc+0x5e>
  p->sz = sz;
    80002392:	06b93823          	sd	a1,112(s2)
  return 0;
    80002396:	4501                	li	a0,0
}
    80002398:	60e2                	ld	ra,24(sp)
    8000239a:	6442                	ld	s0,16(sp)
    8000239c:	64a2                	ld	s1,8(sp)
    8000239e:	6902                	ld	s2,0(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret
  } else if (n < 0) {
    800023a4:	fe04d7e3          	bgez	s1,80002392 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800023a8:	00b48633          	add	a2,s1,a1
    800023ac:	7d28                	ld	a0,120(a0)
    800023ae:	808ff0ef          	jal	800013b6 <uvmdealloc>
    800023b2:	85aa                	mv	a1,a0
    800023b4:	bff9                	j	80002392 <growproc+0x36>
      return -1;
    800023b6:	557d                	li	a0,-1
    800023b8:	b7c5                	j	80002398 <growproc+0x3c>
      return -1;
    800023ba:	557d                	li	a0,-1
    800023bc:	bff1                	j	80002398 <growproc+0x3c>

00000000800023be <kfork>:
{
    800023be:	7139                	addi	sp,sp,-64
    800023c0:	fc06                	sd	ra,56(sp)
    800023c2:	f822                	sd	s0,48(sp)
    800023c4:	f04a                	sd	s2,32(sp)
    800023c6:	e456                	sd	s5,8(sp)
    800023c8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800023ca:	c2dff0ef          	jal	80001ff6 <myproc>
    800023ce:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    800023d0:	e57ff0ef          	jal	80002226 <allocproc>
    800023d4:	14050f63          	beqz	a0,80002532 <kfork+0x174>
    800023d8:	ec4e                	sd	s3,24(sp)
    800023da:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    800023dc:	070ab603          	ld	a2,112(s5)
    800023e0:	7d2c                	ld	a1,120(a0)
    800023e2:	078ab503          	ld	a0,120(s5)
    800023e6:	954ff0ef          	jal	8000153a <uvmcopy>
    800023ea:	02054363          	bltz	a0,80002410 <kfork+0x52>
    800023ee:	f426                	sd	s1,40(sp)
    800023f0:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800023f2:	070ab783          	ld	a5,112(s5)
    800023f6:	06f9b823          	sd	a5,112(s3)
  np->trace_mask = p->trace_mask;
    800023fa:	040ab783          	ld	a5,64(s5)
    800023fe:	04f9b023          	sd	a5,64(s3)
  for(i = 0; i < NVMA; i++){
    80002402:	180a8493          	addi	s1,s5,384
    80002406:	18098913          	addi	s2,s3,384
    8000240a:	500a8a13          	addi	s4,s5,1280
    8000240e:	a005                	j	8000242e <kfork+0x70>
    freeproc(np);
    80002410:	854e                	mv	a0,s3
    80002412:	db1ff0ef          	jal	800021c2 <freeproc>
    release(&np->lock);
    80002416:	854e                	mv	a0,s3
    80002418:	993fe0ef          	jal	80000daa <release>
    return -1;
    8000241c:	597d                	li	s2,-1
    8000241e:	69e2                	ld	s3,24(sp)
    80002420:	a211                	j	80002524 <kfork+0x166>
  for(i = 0; i < NVMA; i++){
    80002422:	03848493          	addi	s1,s1,56
    80002426:	03890913          	addi	s2,s2,56
    8000242a:	05448063          	beq	s1,s4,8000246a <kfork+0xac>
    if(p->vmas[i].used){
    8000242e:	409c                	lw	a5,0(s1)
    80002430:	dbed                	beqz	a5,80002422 <kfork+0x64>
      np->vmas[i] = p->vmas[i];
    80002432:	0004b803          	ld	a6,0(s1)
    80002436:	6488                	ld	a0,8(s1)
    80002438:	688c                	ld	a1,16(s1)
    8000243a:	6c90                	ld	a2,24(s1)
    8000243c:	7094                	ld	a3,32(s1)
    8000243e:	7498                	ld	a4,40(s1)
    80002440:	789c                	ld	a5,48(s1)
    80002442:	01093023          	sd	a6,0(s2)
    80002446:	00a93423          	sd	a0,8(s2)
    8000244a:	00b93823          	sd	a1,16(s2)
    8000244e:	00c93c23          	sd	a2,24(s2)
    80002452:	02d93023          	sd	a3,32(s2)
    80002456:	02e93423          	sd	a4,40(s2)
    8000245a:	02f93823          	sd	a5,48(s2)
      np->vmas[i].file = filedup(p->vmas[i].file);
    8000245e:	7488                	ld	a0,40(s1)
    80002460:	5af020ef          	jal	8000520e <filedup>
    80002464:	02a93423          	sd	a0,40(s2)
    80002468:	bf6d                	j	80002422 <kfork+0x64>
  *(np->trapframe) = *(p->trapframe);
    8000246a:	080ab683          	ld	a3,128(s5)
    8000246e:	87b6                	mv	a5,a3
    80002470:	0809b703          	ld	a4,128(s3)
    80002474:	12068693          	addi	a3,a3,288
    80002478:	0007b803          	ld	a6,0(a5)
    8000247c:	6788                	ld	a0,8(a5)
    8000247e:	6b8c                	ld	a1,16(a5)
    80002480:	6f90                	ld	a2,24(a5)
    80002482:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80002486:	e708                	sd	a0,8(a4)
    80002488:	eb0c                	sd	a1,16(a4)
    8000248a:	ef10                	sd	a2,24(a4)
    8000248c:	02078793          	addi	a5,a5,32
    80002490:	02070713          	addi	a4,a4,32
    80002494:	fed792e3          	bne	a5,a3,80002478 <kfork+0xba>
  np->trapframe->a0 = 0;
    80002498:	0809b783          	ld	a5,128(s3)
    8000249c:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800024a0:	0f8a8493          	addi	s1,s5,248
    800024a4:	0f898913          	addi	s2,s3,248
    800024a8:	178a8a13          	addi	s4,s5,376
    800024ac:	a029                	j	800024b6 <kfork+0xf8>
    800024ae:	04a1                	addi	s1,s1,8
    800024b0:	0921                	addi	s2,s2,8
    800024b2:	01448963          	beq	s1,s4,800024c4 <kfork+0x106>
    if (p->ofile[i])
    800024b6:	6088                	ld	a0,0(s1)
    800024b8:	d97d                	beqz	a0,800024ae <kfork+0xf0>
      np->ofile[i] = filedup(p->ofile[i]);
    800024ba:	555020ef          	jal	8000520e <filedup>
    800024be:	00a93023          	sd	a0,0(s2)
    800024c2:	b7f5                	j	800024ae <kfork+0xf0>
  np->cwd = idup(p->cwd);
    800024c4:	178ab503          	ld	a0,376(s5)
    800024c8:	643010ef          	jal	8000430a <idup>
    800024cc:	16a9bc23          	sd	a0,376(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800024d0:	4641                	li	a2,16
    800024d2:	500a8593          	addi	a1,s5,1280
    800024d6:	50098513          	addi	a0,s3,1280
    800024da:	a5bfe0ef          	jal	80000f34 <safestrcpy>
  pid = np->pid;
    800024de:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800024e2:	854e                	mv	a0,s3
    800024e4:	8c7fe0ef          	jal	80000daa <release>
  acquire(&wait_lock);
    800024e8:	0022f497          	auipc	s1,0x22f
    800024ec:	88848493          	addi	s1,s1,-1912 # 80230d70 <wait_lock>
    800024f0:	8526                	mv	a0,s1
    800024f2:	831fe0ef          	jal	80000d22 <acquire>
  np->parent = p;
    800024f6:	0759b023          	sd	s5,96(s3)
  release(&wait_lock);
    800024fa:	8526                	mv	a0,s1
    800024fc:	8affe0ef          	jal	80000daa <release>
  acquire(&np->lock);
    80002500:	854e                	mv	a0,s3
    80002502:	821fe0ef          	jal	80000d22 <acquire>
  np->last_run_tick = ticks;
    80002506:	00006797          	auipc	a5,0x6
    8000250a:	71a7e783          	lwu	a5,1818(a5) # 80008c20 <ticks>
    8000250e:	04f9bc23          	sd	a5,88(s3)
  np->state = RUNNABLE;
    80002512:	478d                	li	a5,3
    80002514:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002518:	854e                	mv	a0,s3
    8000251a:	891fe0ef          	jal	80000daa <release>
  return pid;
    8000251e:	74a2                	ld	s1,40(sp)
    80002520:	69e2                	ld	s3,24(sp)
    80002522:	6a42                	ld	s4,16(sp)
}
    80002524:	854a                	mv	a0,s2
    80002526:	70e2                	ld	ra,56(sp)
    80002528:	7442                	ld	s0,48(sp)
    8000252a:	7902                	ld	s2,32(sp)
    8000252c:	6aa2                	ld	s5,8(sp)
    8000252e:	6121                	addi	sp,sp,64
    80002530:	8082                	ret
    return -1;
    80002532:	597d                	li	s2,-1
    80002534:	bfc5                	j	80002524 <kfork+0x166>

0000000080002536 <scheduler>:
{
    80002536:	7119                	addi	sp,sp,-128
    80002538:	fc86                	sd	ra,120(sp)
    8000253a:	f8a2                	sd	s0,112(sp)
    8000253c:	f4a6                	sd	s1,104(sp)
    8000253e:	f0ca                	sd	s2,96(sp)
    80002540:	ecce                	sd	s3,88(sp)
    80002542:	e8d2                	sd	s4,80(sp)
    80002544:	e4d6                	sd	s5,72(sp)
    80002546:	e0da                	sd	s6,64(sp)
    80002548:	fc5e                	sd	s7,56(sp)
    8000254a:	f862                	sd	s8,48(sp)
    8000254c:	f466                	sd	s9,40(sp)
    8000254e:	f06a                	sd	s10,32(sp)
    80002550:	ec6e                	sd	s11,24(sp)
    80002552:	0100                	addi	s0,sp,128
    80002554:	8792                	mv	a5,tp
  int id = r_tp();
    80002556:	2781                	sext.w	a5,a5
    80002558:	f8f43023          	sd	a5,-128(s0)
  c->proc = 0;
    8000255c:	00779713          	slli	a4,a5,0x7
    80002560:	0022e797          	auipc	a5,0x22e
    80002564:	7f878793          	addi	a5,a5,2040 # 80230d58 <pid_lock>
    80002568:	97ba                	add	a5,a5,a4
    8000256a:	0207b823          	sd	zero,48(a5)
      swtch(&c->context, &best->context);
    8000256e:	0022f797          	auipc	a5,0x22f
    80002572:	82278793          	addi	a5,a5,-2014 # 80230d90 <cpus+0x8>
    80002576:	97ba                	add	a5,a5,a4
    80002578:	f8f43423          	sd	a5,-120(s0)
    for(p = proc; p < &proc[NPROC]; p++){
    8000257c:	00243b17          	auipc	s6,0x243
    80002580:	00cb0b13          	addi	s6,s6,12 # 80245588 <tickslock>
        uint64 boost = waited / AGING_THRESHOLD;
    80002584:	ccccd7b7          	lui	a5,0xccccd
    80002588:	ccd78793          	addi	a5,a5,-819 # ffffffffcccccccd <end+0xffffffff4ca7c365>
    8000258c:	02079c93          	slli	s9,a5,0x20
    80002590:	9cbe                	add	s9,s9,a5
        if(eff_prio < 1)
    80002592:	4d85                	li	s11,1
    80002594:	a07d                	j	80002642 <scheduler+0x10c>
    80002596:	896e                	mv	s2,s11
    80002598:	a83d                	j	800025d6 <scheduler+0xa0>
            release(&best->lock);
    8000259a:	8552                	mv	a0,s4
    8000259c:	80ffe0ef          	jal	80000daa <release>
          best_waited = waited;
    800025a0:	8d4e                	mv	s10,s3
          best_eff_prio = eff_prio;
    800025a2:	8bca                	mv	s7,s2
          best = p;
    800025a4:	8a26                	mv	s4,s1
    for(p = proc; p < &proc[NPROC]; p++){
    800025a6:	51048493          	addi	s1,s1,1296
    800025aa:	05648c63          	beq	s1,s6,80002602 <scheduler+0xcc>
      acquire(&p->lock);
    800025ae:	8526                	mv	a0,s1
    800025b0:	f72fe0ef          	jal	80000d22 <acquire>
      if(p->state == RUNNABLE){
    800025b4:	4c9c                	lw	a5,24(s1)
    800025b6:	03579d63          	bne	a5,s5,800025f0 <scheduler+0xba>
        uint64 waited = (now > p->last_run_tick) ? (now - p->last_run_tick) : 0;
    800025ba:	6cbc                	ld	a5,88(s1)
    800025bc:	4981                	li	s3,0
    800025be:	0187f463          	bgeu	a5,s8,800025c6 <scheduler+0x90>
    800025c2:	40fc09b3          	sub	s3,s8,a5
        uint64 boost = waited / AGING_THRESHOLD;
    800025c6:	0399b733          	mulhu	a4,s3,s9
    800025ca:	830d                	srli	a4,a4,0x3
        int eff_prio = p->priority - (int)boost;
    800025cc:	58dc                	lw	a5,52(s1)
    800025ce:	9f99                	subw	a5,a5,a4
    800025d0:	893e                	mv	s2,a5
        if(eff_prio < 1)
    800025d2:	fcf052e3          	blez	a5,80002596 <scheduler+0x60>
    800025d6:	2901                	sext.w	s2,s2
        if(best == 0 || eff_prio < best_eff_prio ||
    800025d8:	080a0663          	beqz	s4,80002664 <scheduler+0x12e>
    800025dc:	fb794fe3          	blt	s2,s7,8000259a <scheduler+0x64>
    800025e0:	01791463          	bne	s2,s7,800025e8 <scheduler+0xb2>
           (eff_prio == best_eff_prio && waited > best_waited)){
    800025e4:	fb3d6be3          	bltu	s10,s3,8000259a <scheduler+0x64>
          release(&p->lock);
    800025e8:	8526                	mv	a0,s1
    800025ea:	fc0fe0ef          	jal	80000daa <release>
    800025ee:	bf65                	j	800025a6 <scheduler+0x70>
        release(&p->lock);
    800025f0:	8526                	mv	a0,s1
    800025f2:	fb8fe0ef          	jal	80000daa <release>
    for(p = proc; p < &proc[NPROC]; p++){
    800025f6:	51048493          	addi	s1,s1,1296
    800025fa:	fb649ae3          	bne	s1,s6,800025ae <scheduler+0x78>
    if(best != 0){
    800025fe:	040a0263          	beqz	s4,80002642 <scheduler+0x10c>
      best->state = RUNNING;
    80002602:	4791                	li	a5,4
    80002604:	00fa2c23          	sw	a5,24(s4)
      c->proc = best;
    80002608:	f8043783          	ld	a5,-128(s0)
    8000260c:	079e                	slli	a5,a5,0x7
    8000260e:	0022e497          	auipc	s1,0x22e
    80002612:	74a48493          	addi	s1,s1,1866 # 80230d58 <pid_lock>
    80002616:	94be                	add	s1,s1,a5
    80002618:	0344b823          	sd	s4,48(s1)
      swtch(&c->context, &best->context);
    8000261c:	088a0593          	addi	a1,s4,136
    80002620:	f8843503          	ld	a0,-120(s0)
    80002624:	1fb000ef          	jal	8000301e <swtch>
      best->last_run_tick = ticks;
    80002628:	00006797          	auipc	a5,0x6
    8000262c:	5f878793          	addi	a5,a5,1528 # 80008c20 <ticks>
    80002630:	0007e783          	lwu	a5,0(a5)
    80002634:	04fa3c23          	sd	a5,88(s4)
      c->proc = 0;
    80002638:	0204b823          	sd	zero,48(s1)
      release(&best->lock);
    8000263c:	8552                	mv	a0,s4
    8000263e:	f6cfe0ef          	jal	80000daa <release>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80002642:	10016073          	csrsi	sstatus,2
    uint64 now = ticks;
    80002646:	00006797          	auipc	a5,0x6
    8000264a:	5da78793          	addi	a5,a5,1498 # 80008c20 <ticks>
    8000264e:	0007ec03          	lwu	s8,0(a5)
    best_waited = 0;
    80002652:	4d01                	li	s10,0
    best_eff_prio = 21;
    80002654:	4bd5                	li	s7,21
    best = 0;
    80002656:	4a01                	li	s4,0
    for(p = proc; p < &proc[NPROC]; p++){
    80002658:	0022f497          	auipc	s1,0x22f
    8000265c:	b3048493          	addi	s1,s1,-1232 # 80231188 <proc>
      if(p->state == RUNNABLE){
    80002660:	4a8d                	li	s5,3
    80002662:	b7b1                	j	800025ae <scheduler+0x78>
          best_waited = waited;
    80002664:	8d4e                	mv	s10,s3
          best_eff_prio = eff_prio;
    80002666:	8bca                	mv	s7,s2
          best = p;
    80002668:	8a26                	mv	s4,s1
    8000266a:	bf35                	j	800025a6 <scheduler+0x70>

000000008000266c <sched>:
{
    8000266c:	7179                	addi	sp,sp,-48
    8000266e:	f406                	sd	ra,40(sp)
    80002670:	f022                	sd	s0,32(sp)
    80002672:	ec26                	sd	s1,24(sp)
    80002674:	e84a                	sd	s2,16(sp)
    80002676:	e44e                	sd	s3,8(sp)
    80002678:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000267a:	97dff0ef          	jal	80001ff6 <myproc>
    8000267e:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002680:	e42fe0ef          	jal	80000cc2 <holding>
    80002684:	c92d                	beqz	a0,800026f6 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80002686:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002688:	2781                	sext.w	a5,a5
    8000268a:	079e                	slli	a5,a5,0x7
    8000268c:	0022e717          	auipc	a4,0x22e
    80002690:	6cc70713          	addi	a4,a4,1740 # 80230d58 <pid_lock>
    80002694:	97ba                	add	a5,a5,a4
    80002696:	0a87a703          	lw	a4,168(a5)
    8000269a:	4785                	li	a5,1
    8000269c:	06f71363          	bne	a4,a5,80002702 <sched+0x96>
  if (p->state == RUNNING)
    800026a0:	4c98                	lw	a4,24(s1)
    800026a2:	4791                	li	a5,4
    800026a4:	06f70563          	beq	a4,a5,8000270e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026a8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026ac:	8b89                	andi	a5,a5,2
  if (intr_get())
    800026ae:	e7b5                	bnez	a5,8000271a <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    800026b0:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800026b2:	0022e917          	auipc	s2,0x22e
    800026b6:	6a690913          	addi	s2,s2,1702 # 80230d58 <pid_lock>
    800026ba:	2781                	sext.w	a5,a5
    800026bc:	079e                	slli	a5,a5,0x7
    800026be:	97ca                	add	a5,a5,s2
    800026c0:	0ac7a983          	lw	s3,172(a5)
    800026c4:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800026c6:	2781                	sext.w	a5,a5
    800026c8:	079e                	slli	a5,a5,0x7
    800026ca:	0022e597          	auipc	a1,0x22e
    800026ce:	6c658593          	addi	a1,a1,1734 # 80230d90 <cpus+0x8>
    800026d2:	95be                	add	a1,a1,a5
    800026d4:	08848513          	addi	a0,s1,136
    800026d8:	147000ef          	jal	8000301e <swtch>
    800026dc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800026de:	2781                	sext.w	a5,a5
    800026e0:	079e                	slli	a5,a5,0x7
    800026e2:	993e                	add	s2,s2,a5
    800026e4:	0b392623          	sw	s3,172(s2)
}
    800026e8:	70a2                	ld	ra,40(sp)
    800026ea:	7402                	ld	s0,32(sp)
    800026ec:	64e2                	ld	s1,24(sp)
    800026ee:	6942                	ld	s2,16(sp)
    800026f0:	69a2                	ld	s3,8(sp)
    800026f2:	6145                	addi	sp,sp,48
    800026f4:	8082                	ret
    panic("sched p->lock");
    800026f6:	00006517          	auipc	a0,0x6
    800026fa:	af250513          	addi	a0,a0,-1294 # 800081e8 <etext+0x1e8>
    800026fe:	8f0fe0ef          	jal	800007ee <panic>
    panic("sched locks");
    80002702:	00006517          	auipc	a0,0x6
    80002706:	af650513          	addi	a0,a0,-1290 # 800081f8 <etext+0x1f8>
    8000270a:	8e4fe0ef          	jal	800007ee <panic>
    panic("sched RUNNING");
    8000270e:	00006517          	auipc	a0,0x6
    80002712:	afa50513          	addi	a0,a0,-1286 # 80008208 <etext+0x208>
    80002716:	8d8fe0ef          	jal	800007ee <panic>
    panic("sched interruptible");
    8000271a:	00006517          	auipc	a0,0x6
    8000271e:	afe50513          	addi	a0,a0,-1282 # 80008218 <etext+0x218>
    80002722:	8ccfe0ef          	jal	800007ee <panic>

0000000080002726 <yield>:
{
    80002726:	1101                	addi	sp,sp,-32
    80002728:	ec06                	sd	ra,24(sp)
    8000272a:	e822                	sd	s0,16(sp)
    8000272c:	e426                	sd	s1,8(sp)
    8000272e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002730:	8c7ff0ef          	jal	80001ff6 <myproc>
    80002734:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002736:	decfe0ef          	jal	80000d22 <acquire>
  p->state = RUNNABLE;
    8000273a:	478d                	li	a5,3
    8000273c:	cc9c                	sw	a5,24(s1)
  sched();
    8000273e:	f2fff0ef          	jal	8000266c <sched>
  release(&p->lock);
    80002742:	8526                	mv	a0,s1
    80002744:	e66fe0ef          	jal	80000daa <release>
}
    80002748:	60e2                	ld	ra,24(sp)
    8000274a:	6442                	ld	s0,16(sp)
    8000274c:	64a2                	ld	s1,8(sp)
    8000274e:	6105                	addi	sp,sp,32
    80002750:	8082                	ret

0000000080002752 <sleep_prepare>:
{
    80002752:	1101                	addi	sp,sp,-32
    80002754:	ec06                	sd	ra,24(sp)
    80002756:	e822                	sd	s0,16(sp)
    80002758:	e426                	sd	s1,8(sp)
    8000275a:	e04a                	sd	s2,0(sp)
    8000275c:	1000                	addi	s0,sp,32
    8000275e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002760:	897ff0ef          	jal	80001ff6 <myproc>
    80002764:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002766:	dbcfe0ef          	jal	80000d22 <acquire>
  if (chan == 0)
    8000276a:	cc81                	beqz	s1,80002782 <sleep_prepare+0x30>
  p->chan = chan;
    8000276c:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80002770:	854a                	mv	a0,s2
    80002772:	e38fe0ef          	jal	80000daa <release>
}
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6902                	ld	s2,0(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret
    panic("sleep_prepare: zero chan");
    80002782:	00006517          	auipc	a0,0x6
    80002786:	aae50513          	addi	a0,a0,-1362 # 80008230 <etext+0x230>
    8000278a:	864fe0ef          	jal	800007ee <panic>

000000008000278e <sleep>:
{
    8000278e:	1101                	addi	sp,sp,-32
    80002790:	ec06                	sd	ra,24(sp)
    80002792:	e822                	sd	s0,16(sp)
    80002794:	e426                	sd	s1,8(sp)
    80002796:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002798:	85fff0ef          	jal	80001ff6 <myproc>
    8000279c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000279e:	d84fe0ef          	jal	80000d22 <acquire>
  if (p->chan != 0) {
    800027a2:	709c                	ld	a5,32(s1)
    800027a4:	c789                	beqz	a5,800027ae <sleep+0x20>
    p->state = SLEEPING;
    800027a6:	4789                	li	a5,2
    800027a8:	cc9c                	sw	a5,24(s1)
    sched();
    800027aa:	ec3ff0ef          	jal	8000266c <sched>
  release(&p->lock);
    800027ae:	8526                	mv	a0,s1
    800027b0:	dfafe0ef          	jal	80000daa <release>
}
    800027b4:	60e2                	ld	ra,24(sp)
    800027b6:	6442                	ld	s0,16(sp)
    800027b8:	64a2                	ld	s1,8(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret

00000000800027be <wakeup>:
{
    800027be:	7139                	addi	sp,sp,-64
    800027c0:	fc06                	sd	ra,56(sp)
    800027c2:	f822                	sd	s0,48(sp)
    800027c4:	f426                	sd	s1,40(sp)
    800027c6:	f04a                	sd	s2,32(sp)
    800027c8:	ec4e                	sd	s3,24(sp)
    800027ca:	e852                	sd	s4,16(sp)
    800027cc:	e456                	sd	s5,8(sp)
    800027ce:	e05a                	sd	s6,0(sp)
    800027d0:	0080                	addi	s0,sp,64
    800027d2:	892a                	mv	s2,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    800027d4:	0022f497          	auipc	s1,0x22f
    800027d8:	9b448493          	addi	s1,s1,-1612 # 80231188 <proc>
      if (p->state == SLEEPING) {
    800027dc:	4a09                	li	s4,2
        p->last_run_tick = ticks;
    800027de:	00006b17          	auipc	s6,0x6
    800027e2:	442b0b13          	addi	s6,s6,1090 # 80008c20 <ticks>
        p->state = RUNNABLE;
    800027e6:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800027e8:	00243997          	auipc	s3,0x243
    800027ec:	da098993          	addi	s3,s3,-608 # 80245588 <tickslock>
    800027f0:	a801                	j	80002800 <wakeup+0x42>
    release(&p->lock);
    800027f2:	8526                	mv	a0,s1
    800027f4:	db6fe0ef          	jal	80000daa <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800027f8:	51048493          	addi	s1,s1,1296
    800027fc:	03348363          	beq	s1,s3,80002822 <wakeup+0x64>
    acquire(&p->lock);
    80002800:	8526                	mv	a0,s1
    80002802:	d20fe0ef          	jal	80000d22 <acquire>
    if (p->chan == chan) {
    80002806:	709c                	ld	a5,32(s1)
    80002808:	ff2795e3          	bne	a5,s2,800027f2 <wakeup+0x34>
      p->chan = 0;
    8000280c:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80002810:	4c9c                	lw	a5,24(s1)
    80002812:	ff4790e3          	bne	a5,s4,800027f2 <wakeup+0x34>
        p->last_run_tick = ticks;
    80002816:	000b6783          	lwu	a5,0(s6)
    8000281a:	ecbc                	sd	a5,88(s1)
        p->state = RUNNABLE;
    8000281c:	0154ac23          	sw	s5,24(s1)
    80002820:	bfc9                	j	800027f2 <wakeup+0x34>
}
    80002822:	70e2                	ld	ra,56(sp)
    80002824:	7442                	ld	s0,48(sp)
    80002826:	74a2                	ld	s1,40(sp)
    80002828:	7902                	ld	s2,32(sp)
    8000282a:	69e2                	ld	s3,24(sp)
    8000282c:	6a42                	ld	s4,16(sp)
    8000282e:	6aa2                	ld	s5,8(sp)
    80002830:	6b02                	ld	s6,0(sp)
    80002832:	6121                	addi	sp,sp,64
    80002834:	8082                	ret

0000000080002836 <reparent>:
{
    80002836:	7179                	addi	sp,sp,-48
    80002838:	f406                	sd	ra,40(sp)
    8000283a:	f022                	sd	s0,32(sp)
    8000283c:	ec26                	sd	s1,24(sp)
    8000283e:	e84a                	sd	s2,16(sp)
    80002840:	e44e                	sd	s3,8(sp)
    80002842:	e052                	sd	s4,0(sp)
    80002844:	1800                	addi	s0,sp,48
    80002846:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002848:	0022f497          	auipc	s1,0x22f
    8000284c:	94048493          	addi	s1,s1,-1728 # 80231188 <proc>
      pp->parent = initproc;
    80002850:	00006a17          	auipc	s4,0x6
    80002854:	3c8a0a13          	addi	s4,s4,968 # 80008c18 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002858:	00243997          	auipc	s3,0x243
    8000285c:	d3098993          	addi	s3,s3,-720 # 80245588 <tickslock>
    80002860:	a029                	j	8000286a <reparent+0x34>
    80002862:	51048493          	addi	s1,s1,1296
    80002866:	01348b63          	beq	s1,s3,8000287c <reparent+0x46>
    if (pp->parent == p) {
    8000286a:	70bc                	ld	a5,96(s1)
    8000286c:	ff279be3          	bne	a5,s2,80002862 <reparent+0x2c>
      pp->parent = initproc;
    80002870:	000a3503          	ld	a0,0(s4)
    80002874:	f0a8                	sd	a0,96(s1)
      wakeup(initproc);
    80002876:	f49ff0ef          	jal	800027be <wakeup>
    8000287a:	b7e5                	j	80002862 <reparent+0x2c>
}
    8000287c:	70a2                	ld	ra,40(sp)
    8000287e:	7402                	ld	s0,32(sp)
    80002880:	64e2                	ld	s1,24(sp)
    80002882:	6942                	ld	s2,16(sp)
    80002884:	69a2                	ld	s3,8(sp)
    80002886:	6a02                	ld	s4,0(sp)
    80002888:	6145                	addi	sp,sp,48
    8000288a:	8082                	ret

000000008000288c <kexit>:
{
    8000288c:	7179                	addi	sp,sp,-48
    8000288e:	f406                	sd	ra,40(sp)
    80002890:	f022                	sd	s0,32(sp)
    80002892:	e052                	sd	s4,0(sp)
    80002894:	1800                	addi	s0,sp,48
    80002896:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002898:	f5eff0ef          	jal	80001ff6 <myproc>
  if (p == initproc)
    8000289c:	00006797          	auipc	a5,0x6
    800028a0:	37c7b783          	ld	a5,892(a5) # 80008c18 <initproc>
    800028a4:	00a78d63          	beq	a5,a0,800028be <kexit+0x32>
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	89aa                	mv	s3,a0
  mmap_cleanup(p);
    800028b0:	ca0ff0ef          	jal	80001d50 <mmap_cleanup>
  for (int fd = 0; fd < NOFILE; fd++) {
    800028b4:	0f898493          	addi	s1,s3,248
    800028b8:	17898913          	addi	s2,s3,376
    800028bc:	a00d                	j	800028de <kexit+0x52>
    800028be:	ec26                	sd	s1,24(sp)
    800028c0:	e84a                	sd	s2,16(sp)
    800028c2:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    800028c4:	00006517          	auipc	a0,0x6
    800028c8:	98c50513          	addi	a0,a0,-1652 # 80008250 <etext+0x250>
    800028cc:	f23fd0ef          	jal	800007ee <panic>
      fileclose(f);
    800028d0:	185020ef          	jal	80005254 <fileclose>
      p->ofile[fd] = 0;
    800028d4:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800028d8:	04a1                	addi	s1,s1,8
    800028da:	01248563          	beq	s1,s2,800028e4 <kexit+0x58>
    if (p->ofile[fd]) {
    800028de:	6088                	ld	a0,0(s1)
    800028e0:	f965                	bnez	a0,800028d0 <kexit+0x44>
    800028e2:	bfdd                	j	800028d8 <kexit+0x4c>
  begin_op();
    800028e4:	4be020ef          	jal	80004da2 <begin_op>
  iput(p->cwd);
    800028e8:	1789b503          	ld	a0,376(s3)
    800028ec:	3d7010ef          	jal	800044c2 <iput>
  end_op();
    800028f0:	538020ef          	jal	80004e28 <end_op>
  p->cwd = 0;
    800028f4:	1609bc23          	sd	zero,376(s3)
  acquire(&wait_lock);
    800028f8:	0022e497          	auipc	s1,0x22e
    800028fc:	47848493          	addi	s1,s1,1144 # 80230d70 <wait_lock>
    80002900:	8526                	mv	a0,s1
    80002902:	c20fe0ef          	jal	80000d22 <acquire>
  reparent(p);
    80002906:	854e                	mv	a0,s3
    80002908:	f2fff0ef          	jal	80002836 <reparent>
  wakeup(p->parent);
    8000290c:	0609b503          	ld	a0,96(s3)
    80002910:	eafff0ef          	jal	800027be <wakeup>
  acquire(&p->lock);
    80002914:	854e                	mv	a0,s3
    80002916:	c0cfe0ef          	jal	80000d22 <acquire>
  p->xstate = status;
    8000291a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000291e:	4795                	li	a5,5
    80002920:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002924:	8526                	mv	a0,s1
    80002926:	c84fe0ef          	jal	80000daa <release>
  sched();
    8000292a:	d43ff0ef          	jal	8000266c <sched>
  panic("zombie exit");
    8000292e:	00006517          	auipc	a0,0x6
    80002932:	93250513          	addi	a0,a0,-1742 # 80008260 <etext+0x260>
    80002936:	eb9fd0ef          	jal	800007ee <panic>

000000008000293a <kkill>:
  if (pid == 0)
    8000293a:	c92d                	beqz	a0,800029ac <kkill+0x72>
{
    8000293c:	7179                	addi	sp,sp,-48
    8000293e:	f406                	sd	ra,40(sp)
    80002940:	f022                	sd	s0,32(sp)
    80002942:	ec26                	sd	s1,24(sp)
    80002944:	e84a                	sd	s2,16(sp)
    80002946:	e44e                	sd	s3,8(sp)
    80002948:	1800                	addi	s0,sp,48
    8000294a:	892a                	mv	s2,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000294c:	0022f497          	auipc	s1,0x22f
    80002950:	83c48493          	addi	s1,s1,-1988 # 80231188 <proc>
    80002954:	00243997          	auipc	s3,0x243
    80002958:	c3498993          	addi	s3,s3,-972 # 80245588 <tickslock>
    acquire(&p->lock);
    8000295c:	8526                	mv	a0,s1
    8000295e:	bc4fe0ef          	jal	80000d22 <acquire>
    if (p->pid == pid) {
    80002962:	589c                	lw	a5,48(s1)
    80002964:	01278b63          	beq	a5,s2,8000297a <kkill+0x40>
    release(&p->lock);
    80002968:	8526                	mv	a0,s1
    8000296a:	c40fe0ef          	jal	80000daa <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000296e:	51048493          	addi	s1,s1,1296
    80002972:	ff3495e3          	bne	s1,s3,8000295c <kkill+0x22>
  return -1;
    80002976:	557d                	li	a0,-1
    80002978:	a819                	j	8000298e <kkill+0x54>
      p->killed = 1;
    8000297a:	4785                	li	a5,1
    8000297c:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    8000297e:	4c98                	lw	a4,24(s1)
    80002980:	4789                	li	a5,2
    80002982:	00f70d63          	beq	a4,a5,8000299c <kkill+0x62>
      release(&p->lock);
    80002986:	8526                	mv	a0,s1
    80002988:	c22fe0ef          	jal	80000daa <release>
      return 0;
    8000298c:	4501                	li	a0,0
}
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	69a2                	ld	s3,8(sp)
    80002998:	6145                	addi	sp,sp,48
    8000299a:	8082                	ret
        p->last_run_tick = ticks;
    8000299c:	00006797          	auipc	a5,0x6
    800029a0:	2847e783          	lwu	a5,644(a5) # 80008c20 <ticks>
    800029a4:	ecbc                	sd	a5,88(s1)
        p->state = RUNNABLE;
    800029a6:	478d                	li	a5,3
    800029a8:	cc9c                	sw	a5,24(s1)
    800029aa:	bff1                	j	80002986 <kkill+0x4c>
    return -1;
    800029ac:	557d                	li	a0,-1
}
    800029ae:	8082                	ret

00000000800029b0 <setkilled>:
{
    800029b0:	1101                	addi	sp,sp,-32
    800029b2:	ec06                	sd	ra,24(sp)
    800029b4:	e822                	sd	s0,16(sp)
    800029b6:	e426                	sd	s1,8(sp)
    800029b8:	1000                	addi	s0,sp,32
    800029ba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800029bc:	b66fe0ef          	jal	80000d22 <acquire>
  p->killed = 1;
    800029c0:	4785                	li	a5,1
    800029c2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800029c4:	8526                	mv	a0,s1
    800029c6:	be4fe0ef          	jal	80000daa <release>
}
    800029ca:	60e2                	ld	ra,24(sp)
    800029cc:	6442                	ld	s0,16(sp)
    800029ce:	64a2                	ld	s1,8(sp)
    800029d0:	6105                	addi	sp,sp,32
    800029d2:	8082                	ret

00000000800029d4 <killed>:
{
    800029d4:	1101                	addi	sp,sp,-32
    800029d6:	ec06                	sd	ra,24(sp)
    800029d8:	e822                	sd	s0,16(sp)
    800029da:	e426                	sd	s1,8(sp)
    800029dc:	e04a                	sd	s2,0(sp)
    800029de:	1000                	addi	s0,sp,32
    800029e0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800029e2:	b40fe0ef          	jal	80000d22 <acquire>
  k = p->killed;
    800029e6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800029ea:	8526                	mv	a0,s1
    800029ec:	bbefe0ef          	jal	80000daa <release>
}
    800029f0:	854a                	mv	a0,s2
    800029f2:	60e2                	ld	ra,24(sp)
    800029f4:	6442                	ld	s0,16(sp)
    800029f6:	64a2                	ld	s1,8(sp)
    800029f8:	6902                	ld	s2,0(sp)
    800029fa:	6105                	addi	sp,sp,32
    800029fc:	8082                	ret

00000000800029fe <kwait>:
{
    800029fe:	715d                	addi	sp,sp,-80
    80002a00:	e486                	sd	ra,72(sp)
    80002a02:	e0a2                	sd	s0,64(sp)
    80002a04:	fc26                	sd	s1,56(sp)
    80002a06:	f84a                	sd	s2,48(sp)
    80002a08:	f44e                	sd	s3,40(sp)
    80002a0a:	f052                	sd	s4,32(sp)
    80002a0c:	ec56                	sd	s5,24(sp)
    80002a0e:	e85a                	sd	s6,16(sp)
    80002a10:	e45e                	sd	s7,8(sp)
    80002a12:	0880                	addi	s0,sp,80
    80002a14:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002a16:	de0ff0ef          	jal	80001ff6 <myproc>
    80002a1a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002a1c:	0022e517          	auipc	a0,0x22e
    80002a20:	35450513          	addi	a0,a0,852 # 80230d70 <wait_lock>
    80002a24:	afefe0ef          	jal	80000d22 <acquire>
        if (pp->state == ZOMBIE) {
    80002a28:	4a15                	li	s4,5
        havekids = 1;
    80002a2a:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002a2c:	00243997          	auipc	s3,0x243
    80002a30:	b5c98993          	addi	s3,s3,-1188 # 80245588 <tickslock>
    release(&wait_lock);
    80002a34:	0022eb97          	auipc	s7,0x22e
    80002a38:	33cb8b93          	addi	s7,s7,828 # 80230d70 <wait_lock>
    80002a3c:	a845                	j	80002aec <kwait+0xee>
          pid = pp->pid;
    80002a3e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    80002a42:	000b0e63          	beqz	s6,80002a5e <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002a46:	4711                	li	a4,4
    80002a48:	02c48693          	addi	a3,s1,44
    80002a4c:	865a                	mv	a2,s6
    80002a4e:	07093583          	ld	a1,112(s2)
    80002a52:	07893503          	ld	a0,120(s2)
    80002a56:	f47fe0ef          	jal	8000199c <copyout>
          if (addr != 0 &&
    80002a5a:	02054c63          	bltz	a0,80002a92 <kwait+0x94>
          pp->parent = 0;
    80002a5e:	0604b023          	sd	zero,96(s1)
          freeproc(pp);
    80002a62:	8526                	mv	a0,s1
    80002a64:	f5eff0ef          	jal	800021c2 <freeproc>
          release(&pp->lock);
    80002a68:	8526                	mv	a0,s1
    80002a6a:	b40fe0ef          	jal	80000daa <release>
          release(&wait_lock);
    80002a6e:	0022e517          	auipc	a0,0x22e
    80002a72:	30250513          	addi	a0,a0,770 # 80230d70 <wait_lock>
    80002a76:	b34fe0ef          	jal	80000daa <release>
}
    80002a7a:	854e                	mv	a0,s3
    80002a7c:	60a6                	ld	ra,72(sp)
    80002a7e:	6406                	ld	s0,64(sp)
    80002a80:	74e2                	ld	s1,56(sp)
    80002a82:	7942                	ld	s2,48(sp)
    80002a84:	79a2                	ld	s3,40(sp)
    80002a86:	7a02                	ld	s4,32(sp)
    80002a88:	6ae2                	ld	s5,24(sp)
    80002a8a:	6b42                	ld	s6,16(sp)
    80002a8c:	6ba2                	ld	s7,8(sp)
    80002a8e:	6161                	addi	sp,sp,80
    80002a90:	8082                	ret
            release(&pp->lock);
    80002a92:	8526                	mv	a0,s1
    80002a94:	b16fe0ef          	jal	80000daa <release>
            release(&wait_lock);
    80002a98:	0022e517          	auipc	a0,0x22e
    80002a9c:	2d850513          	addi	a0,a0,728 # 80230d70 <wait_lock>
    80002aa0:	b0afe0ef          	jal	80000daa <release>
            return -1;
    80002aa4:	59fd                	li	s3,-1
    80002aa6:	bfd1                	j	80002a7a <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002aa8:	51048493          	addi	s1,s1,1296
    80002aac:	03348063          	beq	s1,s3,80002acc <kwait+0xce>
      if (pp->parent == p) {
    80002ab0:	70bc                	ld	a5,96(s1)
    80002ab2:	ff279be3          	bne	a5,s2,80002aa8 <kwait+0xaa>
        acquire(&pp->lock);
    80002ab6:	8526                	mv	a0,s1
    80002ab8:	a6afe0ef          	jal	80000d22 <acquire>
        if (pp->state == ZOMBIE) {
    80002abc:	4c9c                	lw	a5,24(s1)
    80002abe:	f94780e3          	beq	a5,s4,80002a3e <kwait+0x40>
        release(&pp->lock);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	ae6fe0ef          	jal	80000daa <release>
        havekids = 1;
    80002ac8:	8756                	mv	a4,s5
    80002aca:	bff9                	j	80002aa8 <kwait+0xaa>
    if (!havekids || killed(p)) {
    80002acc:	c715                	beqz	a4,80002af8 <kwait+0xfa>
    80002ace:	854a                	mv	a0,s2
    80002ad0:	f05ff0ef          	jal	800029d4 <killed>
    80002ad4:	e115                	bnez	a0,80002af8 <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    80002ad6:	854a                	mv	a0,s2
    80002ad8:	c7bff0ef          	jal	80002752 <sleep_prepare>
    release(&wait_lock);
    80002adc:	855e                	mv	a0,s7
    80002ade:	accfe0ef          	jal	80000daa <release>
    sleep();
    80002ae2:	cadff0ef          	jal	8000278e <sleep>
    acquire(&wait_lock);
    80002ae6:	855e                	mv	a0,s7
    80002ae8:	a3afe0ef          	jal	80000d22 <acquire>
    havekids = 0;
    80002aec:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002aee:	0022e497          	auipc	s1,0x22e
    80002af2:	69a48493          	addi	s1,s1,1690 # 80231188 <proc>
    80002af6:	bf6d                	j	80002ab0 <kwait+0xb2>
      release(&wait_lock);
    80002af8:	0022e517          	auipc	a0,0x22e
    80002afc:	27850513          	addi	a0,a0,632 # 80230d70 <wait_lock>
    80002b00:	aaafe0ef          	jal	80000daa <release>
      return -1;
    80002b04:	59fd                	li	s3,-1
    80002b06:	bf95                	j	80002a7a <kwait+0x7c>

0000000080002b08 <kwaitx>:
{
    80002b08:	7159                	addi	sp,sp,-112
    80002b0a:	f486                	sd	ra,104(sp)
    80002b0c:	f0a2                	sd	s0,96(sp)
    80002b0e:	eca6                	sd	s1,88(sp)
    80002b10:	e8ca                	sd	s2,80(sp)
    80002b12:	e4ce                	sd	s3,72(sp)
    80002b14:	e0d2                	sd	s4,64(sp)
    80002b16:	fc56                	sd	s5,56(sp)
    80002b18:	f85a                	sd	s6,48(sp)
    80002b1a:	f45e                	sd	s7,40(sp)
    80002b1c:	f062                	sd	s8,32(sp)
    80002b1e:	ec66                	sd	s9,24(sp)
    80002b20:	1880                	addi	s0,sp,112
    80002b22:	8c2a                	mv	s8,a0
    80002b24:	8bae                	mv	s7,a1
    80002b26:	8b32                	mv	s6,a2
  struct proc *p = myproc();
    80002b28:	cceff0ef          	jal	80001ff6 <myproc>
    80002b2c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002b2e:	0022e517          	auipc	a0,0x22e
    80002b32:	24250513          	addi	a0,a0,578 # 80230d70 <wait_lock>
    80002b36:	9ecfe0ef          	jal	80000d22 <acquire>
        if (pp->state == ZOMBIE) {
    80002b3a:	4a15                	li	s4,5
        havekids = 1;
    80002b3c:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002b3e:	00243997          	auipc	s3,0x243
    80002b42:	a4a98993          	addi	s3,s3,-1462 # 80245588 <tickslock>
    release(&wait_lock);
    80002b46:	0022ec97          	auipc	s9,0x22e
    80002b4a:	22ac8c93          	addi	s9,s9,554 # 80230d70 <wait_lock>
    80002b4e:	aa35                	j	80002c8a <kwaitx+0x182>
          uint64 rtime = pp->cpu_time;
    80002b50:	7c94                	ld	a3,56(s1)
    80002b52:	f8d43823          	sd	a3,-112(s0)
          uint64 now = ticks;
    80002b56:	00006797          	auipc	a5,0x6
    80002b5a:	0ca7e783          	lwu	a5,202(a5) # 80008c20 <ticks>
          uint64 total = (now >= pp->ctime) ? (now - pp->ctime) : 0;
    80002b5e:	68b0                	ld	a2,80(s1)
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
    80002b60:	4701                	li	a4,0
          uint64 total = (now >= pp->ctime) ? (now - pp->ctime) : 0;
    80002b62:	00c7e763          	bltu	a5,a2,80002b70 <kwaitx+0x68>
    80002b66:	8f91                	sub	a5,a5,a2
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
    80002b68:	00f6f463          	bgeu	a3,a5,80002b70 <kwaitx+0x68>
    80002b6c:	40d78733          	sub	a4,a5,a3
    80002b70:	f8e43c23          	sd	a4,-104(s0)
          pid = pp->pid;
    80002b74:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    80002b78:	040c1e63          	bnez	s8,80002bd4 <kwaitx+0xcc>
          if (wtime_addr != 0 &&
    80002b7c:	080b9363          	bnez	s7,80002c02 <kwaitx+0xfa>
          if (rtime_addr != 0 &&
    80002b80:	000b0e63          	beqz	s6,80002b9c <kwaitx+0x94>
              copyout(p->pagetable, p->sz, rtime_addr, (char *)&rtime,
    80002b84:	4721                	li	a4,8
    80002b86:	f9040693          	addi	a3,s0,-112
    80002b8a:	865a                	mv	a2,s6
    80002b8c:	07093583          	ld	a1,112(s2)
    80002b90:	07893503          	ld	a0,120(s2)
    80002b94:	e09fe0ef          	jal	8000199c <copyout>
          if (rtime_addr != 0 &&
    80002b98:	08054c63          	bltz	a0,80002c30 <kwaitx+0x128>
          pp->parent = 0;
    80002b9c:	0604b023          	sd	zero,96(s1)
          freeproc(pp);
    80002ba0:	8526                	mv	a0,s1
    80002ba2:	e20ff0ef          	jal	800021c2 <freeproc>
          release(&pp->lock);
    80002ba6:	8526                	mv	a0,s1
    80002ba8:	a02fe0ef          	jal	80000daa <release>
          release(&wait_lock);
    80002bac:	0022e517          	auipc	a0,0x22e
    80002bb0:	1c450513          	addi	a0,a0,452 # 80230d70 <wait_lock>
    80002bb4:	9f6fe0ef          	jal	80000daa <release>
}
    80002bb8:	854e                	mv	a0,s3
    80002bba:	70a6                	ld	ra,104(sp)
    80002bbc:	7406                	ld	s0,96(sp)
    80002bbe:	64e6                	ld	s1,88(sp)
    80002bc0:	6946                	ld	s2,80(sp)
    80002bc2:	69a6                	ld	s3,72(sp)
    80002bc4:	6a06                	ld	s4,64(sp)
    80002bc6:	7ae2                	ld	s5,56(sp)
    80002bc8:	7b42                	ld	s6,48(sp)
    80002bca:	7ba2                	ld	s7,40(sp)
    80002bcc:	7c02                	ld	s8,32(sp)
    80002bce:	6ce2                	ld	s9,24(sp)
    80002bd0:	6165                	addi	sp,sp,112
    80002bd2:	8082                	ret
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    80002bd4:	4711                	li	a4,4
    80002bd6:	02c48693          	addi	a3,s1,44
    80002bda:	8662                	mv	a2,s8
    80002bdc:	07093583          	ld	a1,112(s2)
    80002be0:	07893503          	ld	a0,120(s2)
    80002be4:	db9fe0ef          	jal	8000199c <copyout>
          if (addr != 0 &&
    80002be8:	f8055ae3          	bgez	a0,80002b7c <kwaitx+0x74>
            release(&pp->lock);
    80002bec:	8526                	mv	a0,s1
    80002bee:	9bcfe0ef          	jal	80000daa <release>
            release(&wait_lock);
    80002bf2:	0022e517          	auipc	a0,0x22e
    80002bf6:	17e50513          	addi	a0,a0,382 # 80230d70 <wait_lock>
    80002bfa:	9b0fe0ef          	jal	80000daa <release>
            return -1;
    80002bfe:	59fd                	li	s3,-1
    80002c00:	bf65                	j	80002bb8 <kwaitx+0xb0>
              copyout(p->pagetable, p->sz, wtime_addr, (char *)&wtime,
    80002c02:	4721                	li	a4,8
    80002c04:	f9840693          	addi	a3,s0,-104
    80002c08:	865e                	mv	a2,s7
    80002c0a:	07093583          	ld	a1,112(s2)
    80002c0e:	07893503          	ld	a0,120(s2)
    80002c12:	d8bfe0ef          	jal	8000199c <copyout>
          if (wtime_addr != 0 &&
    80002c16:	f60555e3          	bgez	a0,80002b80 <kwaitx+0x78>
            release(&pp->lock);
    80002c1a:	8526                	mv	a0,s1
    80002c1c:	98efe0ef          	jal	80000daa <release>
            release(&wait_lock);
    80002c20:	0022e517          	auipc	a0,0x22e
    80002c24:	15050513          	addi	a0,a0,336 # 80230d70 <wait_lock>
    80002c28:	982fe0ef          	jal	80000daa <release>
            return -1;
    80002c2c:	59fd                	li	s3,-1
    80002c2e:	b769                	j	80002bb8 <kwaitx+0xb0>
            release(&pp->lock);
    80002c30:	8526                	mv	a0,s1
    80002c32:	978fe0ef          	jal	80000daa <release>
            release(&wait_lock);
    80002c36:	0022e517          	auipc	a0,0x22e
    80002c3a:	13a50513          	addi	a0,a0,314 # 80230d70 <wait_lock>
    80002c3e:	96cfe0ef          	jal	80000daa <release>
            return -1;
    80002c42:	59fd                	li	s3,-1
    80002c44:	bf95                	j	80002bb8 <kwaitx+0xb0>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002c46:	51048493          	addi	s1,s1,1296
    80002c4a:	03348063          	beq	s1,s3,80002c6a <kwaitx+0x162>
      if (pp->parent == p) {
    80002c4e:	70bc                	ld	a5,96(s1)
    80002c50:	ff279be3          	bne	a5,s2,80002c46 <kwaitx+0x13e>
        acquire(&pp->lock);
    80002c54:	8526                	mv	a0,s1
    80002c56:	8ccfe0ef          	jal	80000d22 <acquire>
        if (pp->state == ZOMBIE) {
    80002c5a:	4c9c                	lw	a5,24(s1)
    80002c5c:	ef478ae3          	beq	a5,s4,80002b50 <kwaitx+0x48>
        release(&pp->lock);
    80002c60:	8526                	mv	a0,s1
    80002c62:	948fe0ef          	jal	80000daa <release>
        havekids = 1;
    80002c66:	8756                	mv	a4,s5
    80002c68:	bff9                	j	80002c46 <kwaitx+0x13e>
    if (!havekids || killed(p)) {
    80002c6a:	c715                	beqz	a4,80002c96 <kwaitx+0x18e>
    80002c6c:	854a                	mv	a0,s2
    80002c6e:	d67ff0ef          	jal	800029d4 <killed>
    80002c72:	e115                	bnez	a0,80002c96 <kwaitx+0x18e>
    sleep_prepare(p);
    80002c74:	854a                	mv	a0,s2
    80002c76:	addff0ef          	jal	80002752 <sleep_prepare>
    release(&wait_lock);
    80002c7a:	8566                	mv	a0,s9
    80002c7c:	92efe0ef          	jal	80000daa <release>
    sleep();
    80002c80:	b0fff0ef          	jal	8000278e <sleep>
    acquire(&wait_lock);
    80002c84:	8566                	mv	a0,s9
    80002c86:	89cfe0ef          	jal	80000d22 <acquire>
    havekids = 0;
    80002c8a:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002c8c:	0022e497          	auipc	s1,0x22e
    80002c90:	4fc48493          	addi	s1,s1,1276 # 80231188 <proc>
    80002c94:	bf6d                	j	80002c4e <kwaitx+0x146>
      release(&wait_lock);
    80002c96:	0022e517          	auipc	a0,0x22e
    80002c9a:	0da50513          	addi	a0,a0,218 # 80230d70 <wait_lock>
    80002c9e:	90cfe0ef          	jal	80000daa <release>
      return -1;
    80002ca2:	59fd                	li	s3,-1
    80002ca4:	bf11                	j	80002bb8 <kwaitx+0xb0>

0000000080002ca6 <either_copyout>:
{
    80002ca6:	7179                	addi	sp,sp,-48
    80002ca8:	f406                	sd	ra,40(sp)
    80002caa:	f022                	sd	s0,32(sp)
    80002cac:	ec26                	sd	s1,24(sp)
    80002cae:	e84a                	sd	s2,16(sp)
    80002cb0:	e44e                	sd	s3,8(sp)
    80002cb2:	e052                	sd	s4,0(sp)
    80002cb4:	1800                	addi	s0,sp,48
    80002cb6:	84aa                	mv	s1,a0
    80002cb8:	892e                	mv	s2,a1
    80002cba:	89b2                	mv	s3,a2
    80002cbc:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002cbe:	b38ff0ef          	jal	80001ff6 <myproc>
  if (user_dst) {
    80002cc2:	c085                	beqz	s1,80002ce2 <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    80002cc4:	8752                	mv	a4,s4
    80002cc6:	86ce                	mv	a3,s3
    80002cc8:	864a                	mv	a2,s2
    80002cca:	792c                	ld	a1,112(a0)
    80002ccc:	7d28                	ld	a0,120(a0)
    80002cce:	ccffe0ef          	jal	8000199c <copyout>
}
    80002cd2:	70a2                	ld	ra,40(sp)
    80002cd4:	7402                	ld	s0,32(sp)
    80002cd6:	64e2                	ld	s1,24(sp)
    80002cd8:	6942                	ld	s2,16(sp)
    80002cda:	69a2                	ld	s3,8(sp)
    80002cdc:	6a02                	ld	s4,0(sp)
    80002cde:	6145                	addi	sp,sp,48
    80002ce0:	8082                	ret
    memmove((char *)dst, src, len);
    80002ce2:	000a061b          	sext.w	a2,s4
    80002ce6:	85ce                	mv	a1,s3
    80002ce8:	854a                	mv	a0,s2
    80002cea:	95cfe0ef          	jal	80000e46 <memmove>
    return 0;
    80002cee:	8526                	mv	a0,s1
    80002cf0:	b7cd                	j	80002cd2 <either_copyout+0x2c>

0000000080002cf2 <either_copyin>:
{
    80002cf2:	7179                	addi	sp,sp,-48
    80002cf4:	f406                	sd	ra,40(sp)
    80002cf6:	f022                	sd	s0,32(sp)
    80002cf8:	ec26                	sd	s1,24(sp)
    80002cfa:	e84a                	sd	s2,16(sp)
    80002cfc:	e44e                	sd	s3,8(sp)
    80002cfe:	e052                	sd	s4,0(sp)
    80002d00:	1800                	addi	s0,sp,48
    80002d02:	892a                	mv	s2,a0
    80002d04:	84ae                	mv	s1,a1
    80002d06:	89b2                	mv	s3,a2
    80002d08:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002d0a:	aecff0ef          	jal	80001ff6 <myproc>
  if (user_src) {
    80002d0e:	c085                	beqz	s1,80002d2e <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    80002d10:	8752                	mv	a4,s4
    80002d12:	86ce                	mv	a3,s3
    80002d14:	864a                	mv	a2,s2
    80002d16:	792c                	ld	a1,112(a0)
    80002d18:	7d28                	ld	a0,120(a0)
    80002d1a:	d89fe0ef          	jal	80001aa2 <copyin>
}
    80002d1e:	70a2                	ld	ra,40(sp)
    80002d20:	7402                	ld	s0,32(sp)
    80002d22:	64e2                	ld	s1,24(sp)
    80002d24:	6942                	ld	s2,16(sp)
    80002d26:	69a2                	ld	s3,8(sp)
    80002d28:	6a02                	ld	s4,0(sp)
    80002d2a:	6145                	addi	sp,sp,48
    80002d2c:	8082                	ret
    memmove(dst, (char *)src, len);
    80002d2e:	000a061b          	sext.w	a2,s4
    80002d32:	85ce                	mv	a1,s3
    80002d34:	854a                	mv	a0,s2
    80002d36:	910fe0ef          	jal	80000e46 <memmove>
    return 0;
    80002d3a:	8526                	mv	a0,s1
    80002d3c:	b7cd                	j	80002d1e <either_copyin+0x2c>

0000000080002d3e <procdump>:
{
    80002d3e:	715d                	addi	sp,sp,-80
    80002d40:	e486                	sd	ra,72(sp)
    80002d42:	e0a2                	sd	s0,64(sp)
    80002d44:	fc26                	sd	s1,56(sp)
    80002d46:	f84a                	sd	s2,48(sp)
    80002d48:	f44e                	sd	s3,40(sp)
    80002d4a:	f052                	sd	s4,32(sp)
    80002d4c:	ec56                	sd	s5,24(sp)
    80002d4e:	e85a                	sd	s6,16(sp)
    80002d50:	e45e                	sd	s7,8(sp)
    80002d52:	0880                	addi	s0,sp,80
  printk("\n");
    80002d54:	00005517          	auipc	a0,0x5
    80002d58:	33c50513          	addi	a0,a0,828 # 80008090 <etext+0x90>
    80002d5c:	faefd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002d60:	0022f497          	auipc	s1,0x22f
    80002d64:	92848493          	addi	s1,s1,-1752 # 80231688 <proc+0x500>
    80002d68:	00243917          	auipc	s2,0x243
    80002d6c:	d2090913          	addi	s2,s2,-736 # 80245a88 <bcache+0x4e8>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002d70:	4b15                	li	s6,5
      state = "???";
    80002d72:	00005997          	auipc	s3,0x5
    80002d76:	3fe98993          	addi	s3,s3,1022 # 80008170 <etext+0x170>
    printk("%d\t%d\t%lu\t%s\t%s",
    80002d7a:	00005a97          	auipc	s5,0x5
    80002d7e:	4f6a8a93          	addi	s5,s5,1270 # 80008270 <etext+0x270>
    printk("\n");
    80002d82:	00005a17          	auipc	s4,0x5
    80002d86:	30ea0a13          	addi	s4,s4,782 # 80008090 <etext+0x90>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002d8a:	00006b97          	auipc	s7,0x6
    80002d8e:	b8eb8b93          	addi	s7,s7,-1138 # 80008918 <states.0>
    80002d92:	a00d                	j	80002db4 <procdump+0x76>
    printk("%d\t%d\t%lu\t%s\t%s",
    80002d94:	b387b683          	ld	a3,-1224(a5)
    80002d98:	b347a603          	lw	a2,-1228(a5)
    80002d9c:	b307a583          	lw	a1,-1232(a5)
    80002da0:	8556                	mv	a0,s5
    80002da2:	f68fd0ef          	jal	8000050a <printk>
    printk("\n");
    80002da6:	8552                	mv	a0,s4
    80002da8:	f62fd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002dac:	51048493          	addi	s1,s1,1296
    80002db0:	03248263          	beq	s1,s2,80002dd4 <procdump+0x96>
    if (p->state == UNUSED)
    80002db4:	87a6                	mv	a5,s1
    80002db6:	b184a683          	lw	a3,-1256(s1)
    80002dba:	daed                	beqz	a3,80002dac <procdump+0x6e>
      state = "???";
    80002dbc:	874e                	mv	a4,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002dbe:	fcdb6be3          	bltu	s6,a3,80002d94 <procdump+0x56>
    80002dc2:	02069713          	slli	a4,a3,0x20
    80002dc6:	01d75693          	srli	a3,a4,0x1d
    80002dca:	96de                	add	a3,a3,s7
    80002dcc:	7a98                	ld	a4,48(a3)
    80002dce:	f379                	bnez	a4,80002d94 <procdump+0x56>
      state = "???";
    80002dd0:	874e                	mv	a4,s3
    80002dd2:	b7c9                	j	80002d94 <procdump+0x56>
}
    80002dd4:	60a6                	ld	ra,72(sp)
    80002dd6:	6406                	ld	s0,64(sp)
    80002dd8:	74e2                	ld	s1,56(sp)
    80002dda:	7942                	ld	s2,48(sp)
    80002ddc:	79a2                	ld	s3,40(sp)
    80002dde:	7a02                	ld	s4,32(sp)
    80002de0:	6ae2                	ld	s5,24(sp)
    80002de2:	6b42                	ld	s6,16(sp)
    80002de4:	6ba2                	ld	s7,8(sp)
    80002de6:	6161                	addi	sp,sp,80
    80002de8:	8082                	ret

0000000080002dea <setpriority>:
{
    80002dea:	7179                	addi	sp,sp,-48
    80002dec:	f406                	sd	ra,40(sp)
    80002dee:	f022                	sd	s0,32(sp)
    80002df0:	ec26                	sd	s1,24(sp)
    80002df2:	e84a                	sd	s2,16(sp)
    80002df4:	e44e                	sd	s3,8(sp)
    80002df6:	e052                	sd	s4,0(sp)
    80002df8:	1800                	addi	s0,sp,48
    80002dfa:	892a                	mv	s2,a0
    80002dfc:	8a2e                	mv	s4,a1
  for(p = proc; p < &proc[NPROC]; p++){
    80002dfe:	0022e497          	auipc	s1,0x22e
    80002e02:	38a48493          	addi	s1,s1,906 # 80231188 <proc>
    80002e06:	00242997          	auipc	s3,0x242
    80002e0a:	78298993          	addi	s3,s3,1922 # 80245588 <tickslock>
    acquire(&p->lock);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	f13fd0ef          	jal	80000d22 <acquire>
    if(p->pid == pid){
    80002e14:	589c                	lw	a5,48(s1)
    80002e16:	01278b63          	beq	a5,s2,80002e2c <setpriority+0x42>
    release(&p->lock);
    80002e1a:	8526                	mv	a0,s1
    80002e1c:	f8ffd0ef          	jal	80000daa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002e20:	51048493          	addi	s1,s1,1296
    80002e24:	ff3495e3          	bne	s1,s3,80002e0e <setpriority+0x24>
  return -1;
    80002e28:	557d                	li	a0,-1
    80002e2a:	a039                	j	80002e38 <setpriority+0x4e>
      p->priority = priority;
    80002e2c:	0344aa23          	sw	s4,52(s1)
      release(&p->lock);
    80002e30:	8526                	mv	a0,s1
    80002e32:	f79fd0ef          	jal	80000daa <release>
      return 0;
    80002e36:	4501                	li	a0,0
}
    80002e38:	70a2                	ld	ra,40(sp)
    80002e3a:	7402                	ld	s0,32(sp)
    80002e3c:	64e2                	ld	s1,24(sp)
    80002e3e:	6942                	ld	s2,16(sp)
    80002e40:	69a2                	ld	s3,8(sp)
    80002e42:	6a02                	ld	s4,0(sp)
    80002e44:	6145                	addi	sp,sp,48
    80002e46:	8082                	ret

0000000080002e48 <nproc_active>:
{
    80002e48:	7179                	addi	sp,sp,-48
    80002e4a:	f406                	sd	ra,40(sp)
    80002e4c:	f022                	sd	s0,32(sp)
    80002e4e:	ec26                	sd	s1,24(sp)
    80002e50:	e84a                	sd	s2,16(sp)
    80002e52:	e44e                	sd	s3,8(sp)
    80002e54:	1800                	addi	s0,sp,48
  uint64 count = 0;
    80002e56:	4901                	li	s2,0
  for(p = proc; p < &proc[NPROC]; p++){
    80002e58:	0022e497          	auipc	s1,0x22e
    80002e5c:	33048493          	addi	s1,s1,816 # 80231188 <proc>
    80002e60:	00242997          	auipc	s3,0x242
    80002e64:	72898993          	addi	s3,s3,1832 # 80245588 <tickslock>
    acquire(&p->lock);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	eb9fd0ef          	jal	80000d22 <acquire>
    if(p->state != UNUSED)
    80002e6e:	4c9c                	lw	a5,24(s1)
      count++;
    80002e70:	00f037b3          	snez	a5,a5
    80002e74:	993e                	add	s2,s2,a5
    release(&p->lock);
    80002e76:	8526                	mv	a0,s1
    80002e78:	f33fd0ef          	jal	80000daa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002e7c:	51048493          	addi	s1,s1,1296
    80002e80:	ff3494e3          	bne	s1,s3,80002e68 <nproc_active+0x20>
}
    80002e84:	854a                	mv	a0,s2
    80002e86:	70a2                	ld	ra,40(sp)
    80002e88:	7402                	ld	s0,32(sp)
    80002e8a:	64e2                	ld	s1,24(sp)
    80002e8c:	6942                	ld	s2,16(sp)
    80002e8e:	69a2                	ld	s3,8(sp)
    80002e90:	6145                	addi	sp,sp,48
    80002e92:	8082                	ret

0000000080002e94 <kgetppid>:
{
    80002e94:	1101                	addi	sp,sp,-32
    80002e96:	ec06                	sd	ra,24(sp)
    80002e98:	e822                	sd	s0,16(sp)
    80002e9a:	e426                	sd	s1,8(sp)
    80002e9c:	e04a                	sd	s2,0(sp)
    80002e9e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002ea0:	956ff0ef          	jal	80001ff6 <myproc>
    80002ea4:	84aa                	mv	s1,a0
  acquire(&wait_lock);
    80002ea6:	0022e517          	auipc	a0,0x22e
    80002eaa:	eca50513          	addi	a0,a0,-310 # 80230d70 <wait_lock>
    80002eae:	e75fd0ef          	jal	80000d22 <acquire>
  if(p->parent != 0){
    80002eb2:	70a8                	ld	a0,96(s1)
  int ppid = 0;
    80002eb4:	4901                	li	s2,0
  if(p->parent != 0){
    80002eb6:	c901                	beqz	a0,80002ec6 <kgetppid+0x32>
    acquire(&p->parent->lock);
    80002eb8:	e6bfd0ef          	jal	80000d22 <acquire>
    ppid = p->parent->pid;
    80002ebc:	70a8                	ld	a0,96(s1)
    80002ebe:	03052903          	lw	s2,48(a0)
    release(&p->parent->lock);
    80002ec2:	ee9fd0ef          	jal	80000daa <release>
  release(&wait_lock);
    80002ec6:	0022e517          	auipc	a0,0x22e
    80002eca:	eaa50513          	addi	a0,a0,-342 # 80230d70 <wait_lock>
    80002ece:	eddfd0ef          	jal	80000daa <release>
}
    80002ed2:	854a                	mv	a0,s2
    80002ed4:	60e2                	ld	ra,24(sp)
    80002ed6:	6442                	ld	s0,16(sp)
    80002ed8:	64a2                	ld	s1,8(sp)
    80002eda:	6902                	ld	s2,0(sp)
    80002edc:	6105                	addi	sp,sp,32
    80002ede:	8082                	ret

0000000080002ee0 <proctree>:

void
proctree(void)
{
    80002ee0:	7139                	addi	sp,sp,-64
    80002ee2:	fc06                	sd	ra,56(sp)
    80002ee4:	f822                	sd	s0,48(sp)
    80002ee6:	0080                	addi	s0,sp,64
  struct pnode *nodes;
  struct proc *p;
  int count = 0;

  nodes = (struct pnode *)kalloc();
    80002ee8:	c4dfd0ef          	jal	80000b34 <kalloc>
  if(nodes == 0)
    80002eec:	c161                	beqz	a0,80002fac <proctree+0xcc>
    80002eee:	f426                	sd	s1,40(sp)
    80002ef0:	f04a                	sd	s2,32(sp)
    80002ef2:	ec4e                	sd	s3,24(sp)
    80002ef4:	e852                	sd	s4,16(sp)
    80002ef6:	e456                	sd	s5,8(sp)
    80002ef8:	e05a                	sd	s6,0(sp)
    80002efa:	8aaa                	mv	s5,a0
    return;

  acquire(&wait_lock);
    80002efc:	0022e517          	auipc	a0,0x22e
    80002f00:	e7450513          	addi	a0,a0,-396 # 80230d70 <wait_lock>
    80002f04:	e1ffd0ef          	jal	80000d22 <acquire>
  int count = 0;
    80002f08:	4981                	li	s3,0
  for(p = proc; p < &proc[NPROC]; p++){
    80002f0a:	0022e497          	auipc	s1,0x22e
    80002f0e:	27e48493          	addi	s1,s1,638 # 80231188 <proc>
    acquire(&p->lock);
    if(p->state != UNUSED){
      nodes[count].pid = p->pid;
      nodes[count].priority = p->priority;
      nodes[count].state = p->state;
      safestrcpy(nodes[count].name, p->name, sizeof(nodes[count].name));
    80002f12:	4b41                	li	s6,16
  for(p = proc; p < &proc[NPROC]; p++){
    80002f14:	00242a17          	auipc	s4,0x242
    80002f18:	674a0a13          	addi	s4,s4,1652 # 80245588 <tickslock>
    80002f1c:	a801                	j	80002f2c <proctree+0x4c>
      if(p->parent != 0){
        acquire(&p->parent->lock);
        nodes[count].ppid = p->parent->pid;
        release(&p->parent->lock);
      } else {
        nodes[count].ppid = 0;
    80002f1e:	00092223          	sw	zero,4(s2)
      }
      count++;
    80002f22:	2985                	addiw	s3,s3,1
  for(p = proc; p < &proc[NPROC]; p++){
    80002f24:	51048493          	addi	s1,s1,1296
    80002f28:	05448d63          	beq	s1,s4,80002f82 <proctree+0xa2>
    acquire(&p->lock);
    80002f2c:	8526                	mv	a0,s1
    80002f2e:	df5fd0ef          	jal	80000d22 <acquire>
    if(p->state != UNUSED){
    80002f32:	4c9c                	lw	a5,24(s1)
    80002f34:	c3b9                	beqz	a5,80002f7a <proctree+0x9a>
      nodes[count].pid = p->pid;
    80002f36:	00599913          	slli	s2,s3,0x5
    80002f3a:	9956                	add	s2,s2,s5
    80002f3c:	589c                	lw	a5,48(s1)
    80002f3e:	00f92023          	sw	a5,0(s2)
      nodes[count].priority = p->priority;
    80002f42:	58dc                	lw	a5,52(s1)
    80002f44:	00f92423          	sw	a5,8(s2)
      nodes[count].state = p->state;
    80002f48:	4c9c                	lw	a5,24(s1)
    80002f4a:	00f92623          	sw	a5,12(s2)
      safestrcpy(nodes[count].name, p->name, sizeof(nodes[count].name));
    80002f4e:	865a                	mv	a2,s6
    80002f50:	50048593          	addi	a1,s1,1280
    80002f54:	01090513          	addi	a0,s2,16
    80002f58:	fddfd0ef          	jal	80000f34 <safestrcpy>
      release(&p->lock);
    80002f5c:	8526                	mv	a0,s1
    80002f5e:	e4dfd0ef          	jal	80000daa <release>
      if(p->parent != 0){
    80002f62:	70a8                	ld	a0,96(s1)
    80002f64:	dd4d                	beqz	a0,80002f1e <proctree+0x3e>
        acquire(&p->parent->lock);
    80002f66:	dbdfd0ef          	jal	80000d22 <acquire>
        nodes[count].ppid = p->parent->pid;
    80002f6a:	70bc                	ld	a5,96(s1)
    80002f6c:	5b9c                	lw	a5,48(a5)
    80002f6e:	00f92223          	sw	a5,4(s2)
        release(&p->parent->lock);
    80002f72:	70a8                	ld	a0,96(s1)
    80002f74:	e37fd0ef          	jal	80000daa <release>
    80002f78:	b76d                	j	80002f22 <proctree+0x42>
    } else {
      release(&p->lock);
    80002f7a:	8526                	mv	a0,s1
    80002f7c:	e2ffd0ef          	jal	80000daa <release>
    80002f80:	b755                	j	80002f24 <proctree+0x44>
    }
  }
  release(&wait_lock);
    80002f82:	0022e517          	auipc	a0,0x22e
    80002f86:	dee50513          	addi	a0,a0,-530 # 80230d70 <wait_lock>
    80002f8a:	e21fd0ef          	jal	80000daa <release>

  print_ptree_nodes(nodes, count, 0, 0);
    80002f8e:	4681                	li	a3,0
    80002f90:	4601                	li	a2,0
    80002f92:	85ce                	mv	a1,s3
    80002f94:	8556                	mv	a0,s5
    80002f96:	dfbfe0ef          	jal	80001d90 <print_ptree_nodes>
  kfree((void *)nodes);
    80002f9a:	8556                	mv	a0,s5
    80002f9c:	a45fd0ef          	jal	800009e0 <kfree>
    80002fa0:	74a2                	ld	s1,40(sp)
    80002fa2:	7902                	ld	s2,32(sp)
    80002fa4:	69e2                	ld	s3,24(sp)
    80002fa6:	6a42                	ld	s4,16(sp)
    80002fa8:	6aa2                	ld	s5,8(sp)
    80002faa:	6b02                	ld	s6,0(sp)
}
    80002fac:	70e2                	ld	ra,56(sp)
    80002fae:	7442                	ld	s0,48(sp)
    80002fb0:	6121                	addi	sp,sp,64
    80002fb2:	8082                	ret

0000000080002fb4 <getsyscallcount_proc>:

int
getsyscallcount_proc(int pid)
{
    80002fb4:	7179                	addi	sp,sp,-48
    80002fb6:	f406                	sd	ra,40(sp)
    80002fb8:	f022                	sd	s0,32(sp)
    80002fba:	ec26                	sd	s1,24(sp)
    80002fbc:	e84a                	sd	s2,16(sp)
    80002fbe:	e44e                	sd	s3,8(sp)
    80002fc0:	1800                	addi	s0,sp,48
    80002fc2:	89aa                	mv	s3,a0
  int count;

  if(pid <= 0)
    return (int)myproc()->syscall_count;

  for(p = proc; p < &proc[NPROC]; p++){
    80002fc4:	0022e497          	auipc	s1,0x22e
    80002fc8:	1c448493          	addi	s1,s1,452 # 80231188 <proc>
    80002fcc:	00242917          	auipc	s2,0x242
    80002fd0:	5bc90913          	addi	s2,s2,1468 # 80245588 <tickslock>
  if(pid <= 0)
    80002fd4:	00a04e63          	bgtz	a0,80002ff0 <getsyscallcount_proc+0x3c>
    return (int)myproc()->syscall_count;
    80002fd8:	81eff0ef          	jal	80001ff6 <myproc>
    80002fdc:	04852903          	lw	s2,72(a0)
    80002fe0:	a02d                	j	8000300a <getsyscallcount_proc+0x56>
    if(p->state != UNUSED && p->pid == pid){
      count = (int)p->syscall_count;
      release(&p->lock);
      return count;
    }
    release(&p->lock);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	dc7fd0ef          	jal	80000daa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002fe8:	51048493          	addi	s1,s1,1296
    80002fec:	03248763          	beq	s1,s2,8000301a <getsyscallcount_proc+0x66>
    acquire(&p->lock);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	d31fd0ef          	jal	80000d22 <acquire>
    if(p->state != UNUSED && p->pid == pid){
    80002ff6:	4c9c                	lw	a5,24(s1)
    80002ff8:	d7ed                	beqz	a5,80002fe2 <getsyscallcount_proc+0x2e>
    80002ffa:	589c                	lw	a5,48(s1)
    80002ffc:	ff3793e3          	bne	a5,s3,80002fe2 <getsyscallcount_proc+0x2e>
      count = (int)p->syscall_count;
    80003000:	0484a903          	lw	s2,72(s1)
      release(&p->lock);
    80003004:	8526                	mv	a0,s1
    80003006:	da5fd0ef          	jal	80000daa <release>
  }

  return -1;
}
    8000300a:	854a                	mv	a0,s2
    8000300c:	70a2                	ld	ra,40(sp)
    8000300e:	7402                	ld	s0,32(sp)
    80003010:	64e2                	ld	s1,24(sp)
    80003012:	6942                	ld	s2,16(sp)
    80003014:	69a2                	ld	s3,8(sp)
    80003016:	6145                	addi	sp,sp,48
    80003018:	8082                	ret
  return -1;
    8000301a:	597d                	li	s2,-1
    8000301c:	b7fd                	j	8000300a <getsyscallcount_proc+0x56>

000000008000301e <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000301e:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80003022:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80003026:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80003028:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000302a:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000302e:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80003032:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80003036:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000303a:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000303e:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80003042:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80003046:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000304a:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000304e:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80003052:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80003056:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000305a:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000305c:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000305e:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80003062:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80003066:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000306a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000306e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80003072:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80003076:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000307a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000307e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80003082:	0685bd83          	ld	s11,104(a1)
        
        ret
    80003086:	8082                	ret

0000000080003088 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003088:	1141                	addi	sp,sp,-16
    8000308a:	e406                	sd	ra,8(sp)
    8000308c:	e022                	sd	s0,0(sp)
    8000308e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80003090:	00005597          	auipc	a1,0x5
    80003094:	22858593          	addi	a1,a1,552 # 800082b8 <etext+0x2b8>
    80003098:	00242517          	auipc	a0,0x242
    8000309c:	4f050513          	addi	a0,a0,1264 # 80245588 <tickslock>
    800030a0:	c09fd0ef          	jal	80000ca8 <initlock>
}
    800030a4:	60a2                	ld	ra,8(sp)
    800030a6:	6402                	ld	s0,0(sp)
    800030a8:	0141                	addi	sp,sp,16
    800030aa:	8082                	ret

00000000800030ac <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800030ac:	1141                	addi	sp,sp,-16
    800030ae:	e406                	sd	ra,8(sp)
    800030b0:	e022                	sd	s0,0(sp)
    800030b2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800030b4:	00003797          	auipc	a5,0x3
    800030b8:	62c78793          	addi	a5,a5,1580 # 800066e0 <kernelvec>
    800030bc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800030c0:	60a2                	ld	ra,8(sp)
    800030c2:	6402                	ld	s0,0(sp)
    800030c4:	0141                	addi	sp,sp,16
    800030c6:	8082                	ret

00000000800030c8 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800030c8:	1141                	addi	sp,sp,-16
    800030ca:	e406                	sd	ra,8(sp)
    800030cc:	e022                	sd	s0,0(sp)
    800030ce:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800030d0:	f27fe0ef          	jal	80001ff6 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    800030d4:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800030d8:	04000737          	lui	a4,0x4000
    800030dc:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800030de:	0732                	slli	a4,a4,0xc
    800030e0:	00004797          	auipc	a5,0x4
    800030e4:	f2078793          	addi	a5,a5,-224 # 80007000 <_trampoline>
    800030e8:	00004697          	auipc	a3,0x4
    800030ec:	f1868693          	addi	a3,a3,-232 # 80007000 <_trampoline>
    800030f0:	8f95                	sub	a5,a5,a3
    800030f2:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    800030f4:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800030f8:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    800030fa:	18002773          	csrr	a4,satp
    800030fe:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003100:	6158                	ld	a4,128(a0)
    80003102:	753c                	ld	a5,104(a0)
    80003104:	6685                	lui	a3,0x1
    80003106:	97b6                	add	a5,a5,a3
    80003108:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000310a:	615c                	ld	a5,128(a0)
    8000310c:	00000717          	auipc	a4,0x0
    80003110:	0f870713          	addi	a4,a4,248 # 80003204 <usertrap>
    80003114:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80003116:	615c                	ld	a5,128(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80003118:	8712                	mv	a4,tp
    8000311a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000311c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003120:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003124:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80003128:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000312c:	615c                	ld	a5,128(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000312e:	6f9c                	ld	a5,24(a5)
    80003130:	14179073          	csrw	sepc,a5
}
    80003134:	60a2                	ld	ra,8(sp)
    80003136:	6402                	ld	s0,0(sp)
    80003138:	0141                	addi	sp,sp,16
    8000313a:	8082                	ret

000000008000313c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000313c:	1101                	addi	sp,sp,-32
    8000313e:	ec06                	sd	ra,24(sp)
    80003140:	e822                	sd	s0,16(sp)
    80003142:	1000                	addi	s0,sp,32
  if (cpuid() == 0) {
    80003144:	e7ffe0ef          	jal	80001fc2 <cpuid>
    80003148:	cd11                	beqz	a0,80003164 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    8000314a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000314e:	000f4737          	lui	a4,0xf4
    80003152:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80003156:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80003158:	14d79073          	csrw	stimecmp,a5
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	6105                	addi	sp,sp,32
    80003162:	8082                	ret
    80003164:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80003166:	00242497          	auipc	s1,0x242
    8000316a:	42248493          	addi	s1,s1,1058 # 80245588 <tickslock>
    8000316e:	8526                	mv	a0,s1
    80003170:	bb3fd0ef          	jal	80000d22 <acquire>
    ticks++;
    80003174:	00006517          	auipc	a0,0x6
    80003178:	aac50513          	addi	a0,a0,-1364 # 80008c20 <ticks>
    8000317c:	411c                	lw	a5,0(a0)
    8000317e:	2785                	addiw	a5,a5,1
    80003180:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80003182:	e3cff0ef          	jal	800027be <wakeup>
    release(&tickslock);
    80003186:	8526                	mv	a0,s1
    80003188:	c23fd0ef          	jal	80000daa <release>
    8000318c:	64a2                	ld	s1,8(sp)
    8000318e:	bf75                	j	8000314a <clockintr+0xe>

0000000080003190 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80003190:	1101                	addi	sp,sp,-32
    80003192:	ec06                	sd	ra,24(sp)
    80003194:	e822                	sd	s0,16(sp)
    80003196:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80003198:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    8000319c:	57fd                	li	a5,-1
    8000319e:	17fe                	slli	a5,a5,0x3f
    800031a0:	07a5                	addi	a5,a5,9
    800031a2:	00f70c63          	beq	a4,a5,800031ba <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    800031a6:	57fd                	li	a5,-1
    800031a8:	17fe                	slli	a5,a5,0x3f
    800031aa:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800031ac:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    800031ae:	04f70763          	beq	a4,a5,800031fc <devintr+0x6c>
  }
}
    800031b2:	60e2                	ld	ra,24(sp)
    800031b4:	6442                	ld	s0,16(sp)
    800031b6:	6105                	addi	sp,sp,32
    800031b8:	8082                	ret
    800031ba:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800031bc:	5d0030ef          	jal	8000678c <plic_claim>
    800031c0:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    800031c2:	47a9                	li	a5,10
    800031c4:	00f50963          	beq	a0,a5,800031d6 <devintr+0x46>
    } else if (irq == VIRTIO0_IRQ) {
    800031c8:	4785                	li	a5,1
    800031ca:	00f50963          	beq	a0,a5,800031dc <devintr+0x4c>
    return 1;
    800031ce:	4505                	li	a0,1
    } else if (irq) {
    800031d0:	e889                	bnez	s1,800031e2 <devintr+0x52>
    800031d2:	64a2                	ld	s1,8(sp)
    800031d4:	bff9                	j	800031b2 <devintr+0x22>
      uartintr();
    800031d6:	fb2fd0ef          	jal	80000988 <uartintr>
    if (irq)
    800031da:	a819                	j	800031f0 <devintr+0x60>
      virtio_disk_intr();
    800031dc:	25f030ef          	jal	80006c3a <virtio_disk_intr>
    if (irq)
    800031e0:	a801                	j	800031f0 <devintr+0x60>
      printk("unexpected interrupt irq=%d\n", irq);
    800031e2:	85a6                	mv	a1,s1
    800031e4:	00005517          	auipc	a0,0x5
    800031e8:	0dc50513          	addi	a0,a0,220 # 800082c0 <etext+0x2c0>
    800031ec:	b1efd0ef          	jal	8000050a <printk>
      plic_complete(irq);
    800031f0:	8526                	mv	a0,s1
    800031f2:	5ba030ef          	jal	800067ac <plic_complete>
    return 1;
    800031f6:	4505                	li	a0,1
    800031f8:	64a2                	ld	s1,8(sp)
    800031fa:	bf65                	j	800031b2 <devintr+0x22>
    clockintr();
    800031fc:	f41ff0ef          	jal	8000313c <clockintr>
    return 2;
    80003200:	4509                	li	a0,2
    80003202:	bf45                	j	800031b2 <devintr+0x22>

0000000080003204 <usertrap>:
{
    80003204:	1101                	addi	sp,sp,-32
    80003206:	ec06                	sd	ra,24(sp)
    80003208:	e822                	sd	s0,16(sp)
    8000320a:	e426                	sd	s1,8(sp)
    8000320c:	e04a                	sd	s2,0(sp)
    8000320e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003210:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003214:	1007f793          	andi	a5,a5,256
    80003218:	ebc1                	bnez	a5,800032a8 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000321a:	00003797          	auipc	a5,0x3
    8000321e:	4c678793          	addi	a5,a5,1222 # 800066e0 <kernelvec>
    80003222:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003226:	dd1fe0ef          	jal	80001ff6 <myproc>
    8000322a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000322c:	615c                	ld	a5,128(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000322e:	14102773          	csrr	a4,sepc
    80003232:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80003234:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80003238:	47a1                	li	a5,8
    8000323a:	06f70d63          	beq	a4,a5,800032b4 <usertrap+0xb0>
  } else if ((which_dev = devintr()) != 0) {
    8000323e:	f53ff0ef          	jal	80003190 <devintr>
    80003242:	892a                	mv	s2,a0
    80003244:	0e051863          	bnez	a0,80003334 <usertrap+0x130>
    80003248:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15 &&
    8000324c:	47bd                	li	a5,15
    8000324e:	0af70363          	beq	a4,a5,800032f4 <usertrap+0xf0>
    80003252:	14202773          	csrr	a4,scause
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80003256:	47bd                	li	a5,15
    80003258:	0af70563          	beq	a4,a5,80003302 <usertrap+0xfe>
    8000325c:	14202773          	csrr	a4,scause
    80003260:	47b5                	li	a5,13
    80003262:	0af70063          	beq	a4,a5,80003302 <usertrap+0xfe>
    80003266:	14202773          	csrr	a4,scause
} else if ((r_scause() == 15 || r_scause() == 13) &&
    8000326a:	47bd                	li	a5,15
    8000326c:	0af70763          	beq	a4,a5,8000331a <usertrap+0x116>
    80003270:	14202773          	csrr	a4,scause
    80003274:	47b5                	li	a5,13
    80003276:	0af70263          	beq	a4,a5,8000331a <usertrap+0x116>
    8000327a:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000327e:	5890                	lw	a2,48(s1)
    80003280:	00005517          	auipc	a0,0x5
    80003284:	08050513          	addi	a0,a0,128 # 80008300 <etext+0x300>
    80003288:	a82fd0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000328c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80003290:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80003294:	00005517          	auipc	a0,0x5
    80003298:	09c50513          	addi	a0,a0,156 # 80008330 <etext+0x330>
    8000329c:	a6efd0ef          	jal	8000050a <printk>
    setkilled(p);
    800032a0:	8526                	mv	a0,s1
    800032a2:	f0eff0ef          	jal	800029b0 <setkilled>
    800032a6:	a015                	j	800032ca <usertrap+0xc6>
    panic("usertrap: not from user mode");
    800032a8:	00005517          	auipc	a0,0x5
    800032ac:	03850513          	addi	a0,a0,56 # 800082e0 <etext+0x2e0>
    800032b0:	d3efd0ef          	jal	800007ee <panic>
    if (killed(p))
    800032b4:	f20ff0ef          	jal	800029d4 <killed>
    800032b8:	e915                	bnez	a0,800032ec <usertrap+0xe8>
    p->trapframe->epc += 4;
    800032ba:	60d8                	ld	a4,128(s1)
    800032bc:	6f1c                	ld	a5,24(a4)
    800032be:	0791                	addi	a5,a5,4
    800032c0:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800032c2:	10016073          	csrsi	sstatus,2
    syscall();
    800032c6:	278000ef          	jal	8000353e <syscall>
  if (killed(p))
    800032ca:	8526                	mv	a0,s1
    800032cc:	f08ff0ef          	jal	800029d4 <killed>
    800032d0:	e53d                	bnez	a0,8000333e <usertrap+0x13a>
  prepare_return();
    800032d2:	df7ff0ef          	jal	800030c8 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800032d6:	7ca8                	ld	a0,120(s1)
    800032d8:	8131                	srli	a0,a0,0xc
    800032da:	57fd                	li	a5,-1
    800032dc:	17fe                	slli	a5,a5,0x3f
    800032de:	8d5d                	or	a0,a0,a5
}
    800032e0:	60e2                	ld	ra,24(sp)
    800032e2:	6442                	ld	s0,16(sp)
    800032e4:	64a2                	ld	s1,8(sp)
    800032e6:	6902                	ld	s2,0(sp)
    800032e8:	6105                	addi	sp,sp,32
    800032ea:	8082                	ret
      kexit(-1);
    800032ec:	557d                	li	a0,-1
    800032ee:	d9eff0ef          	jal	8000288c <kexit>
    800032f2:	b7e1                	j	800032ba <usertrap+0xb6>
  asm volatile("csrr %0, stval" : "=r"(x));
    800032f4:	143025f3          	csrr	a1,stval
           cowalloc(p->pagetable, r_stval()) != 0) {
    800032f8:	7ca8                	ld	a0,120(s1)
    800032fa:	c70fe0ef          	jal	8000176a <cowalloc>
  } else if (r_scause() == 15 &&
    800032fe:	f571                	bnez	a0,800032ca <usertrap+0xc6>
    80003300:	bf89                	j	80003252 <usertrap+0x4e>
    80003302:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80003306:	14202673          	csrr	a2,scause
           mmapfault(p->pagetable, r_stval(),
    8000330a:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    8000330c:	00163613          	seqz	a2,a2
    80003310:	7ca8                	ld	a0,120(s1)
    80003312:	d2afe0ef          	jal	8000183c <mmapfault>
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80003316:	f955                	bnez	a0,800032ca <usertrap+0xc6>
    80003318:	b7b9                	j	80003266 <usertrap+0x62>
  asm volatile("csrr %0, stval" : "=r"(x));
    8000331a:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    8000331e:	142026f3          	csrr	a3,scause
           vmfault(p->pagetable, p->sz, r_stval(),
    80003322:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80003324:	0016b693          	seqz	a3,a3
    80003328:	78ac                	ld	a1,112(s1)
    8000332a:	7ca8                	ld	a0,120(s1)
    8000332c:	b08fe0ef          	jal	80001634 <vmfault>
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80003330:	fd49                	bnez	a0,800032ca <usertrap+0xc6>
    80003332:	b7a1                	j	8000327a <usertrap+0x76>
  if (killed(p))
    80003334:	8526                	mv	a0,s1
    80003336:	e9eff0ef          	jal	800029d4 <killed>
    8000333a:	c511                	beqz	a0,80003346 <usertrap+0x142>
    8000333c:	a011                	j	80003340 <usertrap+0x13c>
    8000333e:	4901                	li	s2,0
    kexit(-1);
    80003340:	557d                	li	a0,-1
    80003342:	d4aff0ef          	jal	8000288c <kexit>
if (which_dev == 2){
    80003346:	4789                	li	a5,2
    80003348:	f8f915e3          	bne	s2,a5,800032d2 <usertrap+0xce>
  p->cpu_time++;
    8000334c:	7c9c                	ld	a5,56(s1)
    8000334e:	0785                	addi	a5,a5,1
    80003350:	fc9c                	sd	a5,56(s1)
  yield();
    80003352:	bd4ff0ef          	jal	80002726 <yield>
    80003356:	bfb5                	j	800032d2 <usertrap+0xce>

0000000080003358 <kerneltrap>:
{
    80003358:	7179                	addi	sp,sp,-48
    8000335a:	f406                	sd	ra,40(sp)
    8000335c:	f022                	sd	s0,32(sp)
    8000335e:	ec26                	sd	s1,24(sp)
    80003360:	e84a                	sd	s2,16(sp)
    80003362:	e44e                	sd	s3,8(sp)
    80003364:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80003366:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000336a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    8000336e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80003372:	1004f793          	andi	a5,s1,256
    80003376:	c795                	beqz	a5,800033a2 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80003378:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000337c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    8000337e:	eb85                	bnez	a5,800033ae <kerneltrap+0x56>
  if ((which_dev = devintr()) == 0) {
    80003380:	e11ff0ef          	jal	80003190 <devintr>
    80003384:	c91d                	beqz	a0,800033ba <kerneltrap+0x62>
if (which_dev == 2 && myproc() != 0){
    80003386:	4789                	li	a5,2
    80003388:	04f50a63          	beq	a0,a5,800033dc <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000338c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80003390:	10049073          	csrw	sstatus,s1
}
    80003394:	70a2                	ld	ra,40(sp)
    80003396:	7402                	ld	s0,32(sp)
    80003398:	64e2                	ld	s1,24(sp)
    8000339a:	6942                	ld	s2,16(sp)
    8000339c:	69a2                	ld	s3,8(sp)
    8000339e:	6145                	addi	sp,sp,48
    800033a0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800033a2:	00005517          	auipc	a0,0x5
    800033a6:	fb650513          	addi	a0,a0,-74 # 80008358 <etext+0x358>
    800033aa:	c44fd0ef          	jal	800007ee <panic>
    panic("kerneltrap: interrupts enabled");
    800033ae:	00005517          	auipc	a0,0x5
    800033b2:	fd250513          	addi	a0,a0,-46 # 80008380 <etext+0x380>
    800033b6:	c38fd0ef          	jal	800007ee <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800033ba:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800033be:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800033c2:	85ce                	mv	a1,s3
    800033c4:	00005517          	auipc	a0,0x5
    800033c8:	fdc50513          	addi	a0,a0,-36 # 800083a0 <etext+0x3a0>
    800033cc:	93efd0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    800033d0:	00005517          	auipc	a0,0x5
    800033d4:	ff850513          	addi	a0,a0,-8 # 800083c8 <etext+0x3c8>
    800033d8:	c16fd0ef          	jal	800007ee <panic>
if (which_dev == 2 && myproc() != 0){
    800033dc:	c1bfe0ef          	jal	80001ff6 <myproc>
    800033e0:	d555                	beqz	a0,8000338c <kerneltrap+0x34>
  myproc()->cpu_time++;
    800033e2:	c15fe0ef          	jal	80001ff6 <myproc>
    800033e6:	7d1c                	ld	a5,56(a0)
    800033e8:	0785                	addi	a5,a5,1
    800033ea:	fd1c                	sd	a5,56(a0)
  yield();
    800033ec:	b3aff0ef          	jal	80002726 <yield>
    800033f0:	bf71                	j	8000338c <kerneltrap+0x34>

00000000800033f2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800033f2:	1101                	addi	sp,sp,-32
    800033f4:	ec06                	sd	ra,24(sp)
    800033f6:	e822                	sd	s0,16(sp)
    800033f8:	e426                	sd	s1,8(sp)
    800033fa:	1000                	addi	s0,sp,32
    800033fc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800033fe:	bf9fe0ef          	jal	80001ff6 <myproc>
  switch (n) {
    80003402:	4795                	li	a5,5
    80003404:	0497e163          	bltu	a5,s1,80003446 <argraw+0x54>
    80003408:	048a                	slli	s1,s1,0x2
    8000340a:	00005717          	auipc	a4,0x5
    8000340e:	56e70713          	addi	a4,a4,1390 # 80008978 <states.1+0x30>
    80003412:	94ba                	add	s1,s1,a4
    80003414:	409c                	lw	a5,0(s1)
    80003416:	97ba                	add	a5,a5,a4
    80003418:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000341a:	615c                	ld	a5,128(a0)
    8000341c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000341e:	60e2                	ld	ra,24(sp)
    80003420:	6442                	ld	s0,16(sp)
    80003422:	64a2                	ld	s1,8(sp)
    80003424:	6105                	addi	sp,sp,32
    80003426:	8082                	ret
    return p->trapframe->a1;
    80003428:	615c                	ld	a5,128(a0)
    8000342a:	7fa8                	ld	a0,120(a5)
    8000342c:	bfcd                	j	8000341e <argraw+0x2c>
    return p->trapframe->a2;
    8000342e:	615c                	ld	a5,128(a0)
    80003430:	63c8                	ld	a0,128(a5)
    80003432:	b7f5                	j	8000341e <argraw+0x2c>
    return p->trapframe->a3;
    80003434:	615c                	ld	a5,128(a0)
    80003436:	67c8                	ld	a0,136(a5)
    80003438:	b7dd                	j	8000341e <argraw+0x2c>
    return p->trapframe->a4;
    8000343a:	615c                	ld	a5,128(a0)
    8000343c:	6bc8                	ld	a0,144(a5)
    8000343e:	b7c5                	j	8000341e <argraw+0x2c>
    return p->trapframe->a5;
    80003440:	615c                	ld	a5,128(a0)
    80003442:	6fc8                	ld	a0,152(a5)
    80003444:	bfe9                	j	8000341e <argraw+0x2c>
  panic("argraw");
    80003446:	00005517          	auipc	a0,0x5
    8000344a:	f9250513          	addi	a0,a0,-110 # 800083d8 <etext+0x3d8>
    8000344e:	ba0fd0ef          	jal	800007ee <panic>

0000000080003452 <fetchaddr>:
{
    80003452:	1101                	addi	sp,sp,-32
    80003454:	ec06                	sd	ra,24(sp)
    80003456:	e822                	sd	s0,16(sp)
    80003458:	e426                	sd	s1,8(sp)
    8000345a:	e04a                	sd	s2,0(sp)
    8000345c:	1000                	addi	s0,sp,32
    8000345e:	84aa                	mv	s1,a0
    80003460:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003462:	b95fe0ef          	jal	80001ff6 <myproc>
  if (addr >= p->sz ||
    80003466:	792c                	ld	a1,112(a0)
    80003468:	02b4f663          	bgeu	s1,a1,80003494 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000346c:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80003470:	02f5e463          	bltu	a1,a5,80003498 <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80003474:	4721                	li	a4,8
    80003476:	86a6                	mv	a3,s1
    80003478:	864a                	mv	a2,s2
    8000347a:	7d28                	ld	a0,120(a0)
    8000347c:	e26fe0ef          	jal	80001aa2 <copyin>
    80003480:	00a03533          	snez	a0,a0
    80003484:	40a0053b          	negw	a0,a0
}
    80003488:	60e2                	ld	ra,24(sp)
    8000348a:	6442                	ld	s0,16(sp)
    8000348c:	64a2                	ld	s1,8(sp)
    8000348e:	6902                	ld	s2,0(sp)
    80003490:	6105                	addi	sp,sp,32
    80003492:	8082                	ret
    return -1;
    80003494:	557d                	li	a0,-1
    80003496:	bfcd                	j	80003488 <fetchaddr+0x36>
    80003498:	557d                	li	a0,-1
    8000349a:	b7fd                	j	80003488 <fetchaddr+0x36>

000000008000349c <fetchstr>:
{
    8000349c:	7179                	addi	sp,sp,-48
    8000349e:	f406                	sd	ra,40(sp)
    800034a0:	f022                	sd	s0,32(sp)
    800034a2:	ec26                	sd	s1,24(sp)
    800034a4:	e84a                	sd	s2,16(sp)
    800034a6:	e44e                	sd	s3,8(sp)
    800034a8:	1800                	addi	s0,sp,48
    800034aa:	892a                	mv	s2,a0
    800034ac:	84ae                	mv	s1,a1
    800034ae:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800034b0:	b47fe0ef          	jal	80001ff6 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    800034b4:	874e                	mv	a4,s3
    800034b6:	86ca                	mv	a3,s2
    800034b8:	8626                	mv	a2,s1
    800034ba:	792c                	ld	a1,112(a0)
    800034bc:	7d28                	ld	a0,120(a0)
    800034be:	9f2fe0ef          	jal	800016b0 <copyinstr>
    800034c2:	00054c63          	bltz	a0,800034da <fetchstr+0x3e>
  return strlen(buf);
    800034c6:	8526                	mv	a0,s1
    800034c8:	aa3fd0ef          	jal	80000f6a <strlen>
}
    800034cc:	70a2                	ld	ra,40(sp)
    800034ce:	7402                	ld	s0,32(sp)
    800034d0:	64e2                	ld	s1,24(sp)
    800034d2:	6942                	ld	s2,16(sp)
    800034d4:	69a2                	ld	s3,8(sp)
    800034d6:	6145                	addi	sp,sp,48
    800034d8:	8082                	ret
    return -1;
    800034da:	557d                	li	a0,-1
    800034dc:	bfc5                	j	800034cc <fetchstr+0x30>

00000000800034de <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800034de:	1101                	addi	sp,sp,-32
    800034e0:	ec06                	sd	ra,24(sp)
    800034e2:	e822                	sd	s0,16(sp)
    800034e4:	e426                	sd	s1,8(sp)
    800034e6:	1000                	addi	s0,sp,32
    800034e8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034ea:	f09ff0ef          	jal	800033f2 <argraw>
    800034ee:	c088                	sw	a0,0(s1)
}
    800034f0:	60e2                	ld	ra,24(sp)
    800034f2:	6442                	ld	s0,16(sp)
    800034f4:	64a2                	ld	s1,8(sp)
    800034f6:	6105                	addi	sp,sp,32
    800034f8:	8082                	ret

00000000800034fa <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800034fa:	1101                	addi	sp,sp,-32
    800034fc:	ec06                	sd	ra,24(sp)
    800034fe:	e822                	sd	s0,16(sp)
    80003500:	e426                	sd	s1,8(sp)
    80003502:	1000                	addi	s0,sp,32
    80003504:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003506:	eedff0ef          	jal	800033f2 <argraw>
    8000350a:	e088                	sd	a0,0(s1)
}
    8000350c:	60e2                	ld	ra,24(sp)
    8000350e:	6442                	ld	s0,16(sp)
    80003510:	64a2                	ld	s1,8(sp)
    80003512:	6105                	addi	sp,sp,32
    80003514:	8082                	ret

0000000080003516 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 for error.
int
argstr(int n, char *buf, int max)
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	e426                	sd	s1,8(sp)
    8000351e:	e04a                	sd	s2,0(sp)
    80003520:	1000                	addi	s0,sp,32
    80003522:	84ae                	mv	s1,a1
    80003524:	8932                	mv	s2,a2
  *ip = argraw(n);
    80003526:	ecdff0ef          	jal	800033f2 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000352a:	864a                	mv	a2,s2
    8000352c:	85a6                	mv	a1,s1
    8000352e:	f6fff0ef          	jal	8000349c <fetchstr>
}
    80003532:	60e2                	ld	ra,24(sp)
    80003534:	6442                	ld	s0,16(sp)
    80003536:	64a2                	ld	s1,8(sp)
    80003538:	6902                	ld	s2,0(sp)
    8000353a:	6105                	addi	sp,sp,32
    8000353c:	8082                	ret

000000008000353e <syscall>:
  // clang-format on
};

void
syscall(void)
{
    8000353e:	7179                	addi	sp,sp,-48
    80003540:	f406                	sd	ra,40(sp)
    80003542:	f022                	sd	s0,32(sp)
    80003544:	ec26                	sd	s1,24(sp)
    80003546:	e84a                	sd	s2,16(sp)
    80003548:	e44e                	sd	s3,8(sp)
    8000354a:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000354c:	aabfe0ef          	jal	80001ff6 <myproc>
    80003550:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003552:	08053903          	ld	s2,128(a0)
    80003556:	0a893783          	ld	a5,168(s2)
    8000355a:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000355e:	37fd                	addiw	a5,a5,-1
    80003560:	02400713          	li	a4,36
    80003564:	04f76863          	bltu	a4,a5,800035b4 <syscall+0x76>
    80003568:	00399713          	slli	a4,s3,0x3
    8000356c:	00005797          	auipc	a5,0x5
    80003570:	42478793          	addi	a5,a5,1060 # 80008990 <syscalls>
    80003574:	97ba                	add	a5,a5,a4
    80003576:	6398                	ld	a4,0(a5)
    80003578:	cf15                	beqz	a4,800035b4 <syscall+0x76>
    p->syscall_count++;
    8000357a:	653c                	ld	a5,72(a0)
    8000357c:	0785                	addi	a5,a5,1
    8000357e:	e53c                	sd	a5,72(a0)
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003580:	9702                	jalr	a4
    80003582:	06a93823          	sd	a0,112(s2)
    if ((p->trace_mask >> num) & 1ULL) {
    80003586:	60bc                	ld	a5,64(s1)
    80003588:	0137d7b3          	srl	a5,a5,s3
    8000358c:	8b85                	andi	a5,a5,1
    8000358e:	c3a1                	beqz	a5,800035ce <syscall+0x90>
      printk("%d: syscall %s -> %ld\n",
             p->pid, syscall_names[num], (long)p->trapframe->a0);
    80003590:	60d8                	ld	a4,128(s1)
      printk("%d: syscall %s -> %ld\n",
    80003592:	098e                	slli	s3,s3,0x3
    80003594:	00005797          	auipc	a5,0x5
    80003598:	3fc78793          	addi	a5,a5,1020 # 80008990 <syscalls>
    8000359c:	97ce                	add	a5,a5,s3
    8000359e:	7b34                	ld	a3,112(a4)
    800035a0:	1307b603          	ld	a2,304(a5)
    800035a4:	588c                	lw	a1,48(s1)
    800035a6:	00005517          	auipc	a0,0x5
    800035aa:	e3a50513          	addi	a0,a0,-454 # 800083e0 <etext+0x3e0>
    800035ae:	f5dfc0ef          	jal	8000050a <printk>
    800035b2:	a831                	j	800035ce <syscall+0x90>
    }
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800035b4:	86ce                	mv	a3,s3
    800035b6:	50048613          	addi	a2,s1,1280
    800035ba:	588c                	lw	a1,48(s1)
    800035bc:	00005517          	auipc	a0,0x5
    800035c0:	e3c50513          	addi	a0,a0,-452 # 800083f8 <etext+0x3f8>
    800035c4:	f47fc0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    800035c8:	60dc                	ld	a5,128(s1)
    800035ca:	577d                	li	a4,-1
    800035cc:	fbb8                	sd	a4,112(a5)
  }
}
    800035ce:	70a2                	ld	ra,40(sp)
    800035d0:	7402                	ld	s0,32(sp)
    800035d2:	64e2                	ld	s1,24(sp)
    800035d4:	6942                	ld	s2,16(sp)
    800035d6:	69a2                	ld	s3,8(sp)
    800035d8:	6145                	addi	sp,sp,48
    800035da:	8082                	ret

00000000800035dc <sys_exit>:
#include "sysinfo.h"
#include "vm.h"

uint64
sys_exit(void)
{
    800035dc:	1101                	addi	sp,sp,-32
    800035de:	ec06                	sd	ra,24(sp)
    800035e0:	e822                	sd	s0,16(sp)
    800035e2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800035e4:	fec40593          	addi	a1,s0,-20
    800035e8:	4501                	li	a0,0
    800035ea:	ef5ff0ef          	jal	800034de <argint>
  kexit(n);
    800035ee:	fec42503          	lw	a0,-20(s0)
    800035f2:	a9aff0ef          	jal	8000288c <kexit>
  return 0; // not reached
}
    800035f6:	4501                	li	a0,0
    800035f8:	60e2                	ld	ra,24(sp)
    800035fa:	6442                	ld	s0,16(sp)
    800035fc:	6105                	addi	sp,sp,32
    800035fe:	8082                	ret

0000000080003600 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003600:	1141                	addi	sp,sp,-16
    80003602:	e406                	sd	ra,8(sp)
    80003604:	e022                	sd	s0,0(sp)
    80003606:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003608:	9effe0ef          	jal	80001ff6 <myproc>
}
    8000360c:	5908                	lw	a0,48(a0)
    8000360e:	60a2                	ld	ra,8(sp)
    80003610:	6402                	ld	s0,0(sp)
    80003612:	0141                	addi	sp,sp,16
    80003614:	8082                	ret

0000000080003616 <sys_fork>:

uint64
sys_fork(void)
{
    80003616:	1141                	addi	sp,sp,-16
    80003618:	e406                	sd	ra,8(sp)
    8000361a:	e022                	sd	s0,0(sp)
    8000361c:	0800                	addi	s0,sp,16
  return kfork();
    8000361e:	da1fe0ef          	jal	800023be <kfork>
}
    80003622:	60a2                	ld	ra,8(sp)
    80003624:	6402                	ld	s0,0(sp)
    80003626:	0141                	addi	sp,sp,16
    80003628:	8082                	ret

000000008000362a <sys_wait>:

uint64
sys_wait(void)
{
    8000362a:	1101                	addi	sp,sp,-32
    8000362c:	ec06                	sd	ra,24(sp)
    8000362e:	e822                	sd	s0,16(sp)
    80003630:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003632:	fe840593          	addi	a1,s0,-24
    80003636:	4501                	li	a0,0
    80003638:	ec3ff0ef          	jal	800034fa <argaddr>
  return kwait(p);
    8000363c:	fe843503          	ld	a0,-24(s0)
    80003640:	bbeff0ef          	jal	800029fe <kwait>
}
    80003644:	60e2                	ld	ra,24(sp)
    80003646:	6442                	ld	s0,16(sp)
    80003648:	6105                	addi	sp,sp,32
    8000364a:	8082                	ret

000000008000364c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000364c:	7179                	addi	sp,sp,-48
    8000364e:	f406                	sd	ra,40(sp)
    80003650:	f022                	sd	s0,32(sp)
    80003652:	ec26                	sd	s1,24(sp)
    80003654:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80003656:	fd840593          	addi	a1,s0,-40
    8000365a:	4501                	li	a0,0
    8000365c:	e83ff0ef          	jal	800034de <argint>
  argint(1, &t);
    80003660:	fdc40593          	addi	a1,s0,-36
    80003664:	4505                	li	a0,1
    80003666:	e79ff0ef          	jal	800034de <argint>
  addr = myproc()->sz;
    8000366a:	98dfe0ef          	jal	80001ff6 <myproc>
    8000366e:	7924                	ld	s1,112(a0)

  if (t == SBRK_EAGER || n < 0) {
    80003670:	fdc42703          	lw	a4,-36(s0)
    80003674:	4785                	li	a5,1
    80003676:	02f70763          	beq	a4,a5,800036a4 <sys_sbrk+0x58>
    8000367a:	fd842783          	lw	a5,-40(s0)
    8000367e:	0207c363          	bltz	a5,800036a4 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80003682:	97a6                	add	a5,a5,s1
    80003684:	0297ee63          	bltu	a5,s1,800036c0 <sys_sbrk+0x74>
      return -1;
    if (addr + n > TRAPFRAME)
    80003688:	02000737          	lui	a4,0x2000
    8000368c:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000368e:	0736                	slli	a4,a4,0xd
    80003690:	02f76a63          	bltu	a4,a5,800036c4 <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    80003694:	963fe0ef          	jal	80001ff6 <myproc>
    80003698:	fd842703          	lw	a4,-40(s0)
    8000369c:	793c                	ld	a5,112(a0)
    8000369e:	97ba                	add	a5,a5,a4
    800036a0:	f93c                	sd	a5,112(a0)
    800036a2:	a039                	j	800036b0 <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    800036a4:	fd842503          	lw	a0,-40(s0)
    800036a8:	cb5fe0ef          	jal	8000235c <growproc>
    800036ac:	00054863          	bltz	a0,800036bc <sys_sbrk+0x70>
  }
  return addr;
}
    800036b0:	8526                	mv	a0,s1
    800036b2:	70a2                	ld	ra,40(sp)
    800036b4:	7402                	ld	s0,32(sp)
    800036b6:	64e2                	ld	s1,24(sp)
    800036b8:	6145                	addi	sp,sp,48
    800036ba:	8082                	ret
      return -1;
    800036bc:	54fd                	li	s1,-1
    800036be:	bfcd                	j	800036b0 <sys_sbrk+0x64>
      return -1;
    800036c0:	54fd                	li	s1,-1
    800036c2:	b7fd                	j	800036b0 <sys_sbrk+0x64>
      return -1;
    800036c4:	54fd                	li	s1,-1
    800036c6:	b7ed                	j	800036b0 <sys_sbrk+0x64>

00000000800036c8 <sys_pause>:

uint64
sys_pause(void)
{
    800036c8:	7139                	addi	sp,sp,-64
    800036ca:	fc06                	sd	ra,56(sp)
    800036cc:	f822                	sd	s0,48(sp)
    800036ce:	ec4e                	sd	s3,24(sp)
    800036d0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800036d2:	fcc40593          	addi	a1,s0,-52
    800036d6:	4501                	li	a0,0
    800036d8:	e07ff0ef          	jal	800034de <argint>
  if (n < 0)
    800036dc:	fcc42783          	lw	a5,-52(s0)
    800036e0:	0607cf63          	bltz	a5,8000375e <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    800036e4:	00242517          	auipc	a0,0x242
    800036e8:	ea450513          	addi	a0,a0,-348 # 80245588 <tickslock>
    800036ec:	e36fd0ef          	jal	80000d22 <acquire>
  ticks0 = ticks;
    800036f0:	00005997          	auipc	s3,0x5
    800036f4:	5309a983          	lw	s3,1328(s3) # 80008c20 <ticks>
  while (ticks - ticks0 < n) {
    800036f8:	fcc42783          	lw	a5,-52(s0)
    800036fc:	c7a9                	beqz	a5,80003746 <sys_pause+0x7e>
    800036fe:	f426                	sd	s1,40(sp)
    80003700:	f04a                	sd	s2,32(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80003702:	00005917          	auipc	s2,0x5
    80003706:	51e90913          	addi	s2,s2,1310 # 80008c20 <ticks>
    release(&tickslock);
    8000370a:	00242497          	auipc	s1,0x242
    8000370e:	e7e48493          	addi	s1,s1,-386 # 80245588 <tickslock>
    if (killed(myproc())) {
    80003712:	8e5fe0ef          	jal	80001ff6 <myproc>
    80003716:	abeff0ef          	jal	800029d4 <killed>
    8000371a:	e529                	bnez	a0,80003764 <sys_pause+0x9c>
    sleep_prepare(&ticks);
    8000371c:	854a                	mv	a0,s2
    8000371e:	834ff0ef          	jal	80002752 <sleep_prepare>
    release(&tickslock);
    80003722:	8526                	mv	a0,s1
    80003724:	e86fd0ef          	jal	80000daa <release>
    sleep();
    80003728:	866ff0ef          	jal	8000278e <sleep>
    acquire(&tickslock);
    8000372c:	8526                	mv	a0,s1
    8000372e:	df4fd0ef          	jal	80000d22 <acquire>
  while (ticks - ticks0 < n) {
    80003732:	00092783          	lw	a5,0(s2)
    80003736:	413787bb          	subw	a5,a5,s3
    8000373a:	fcc42703          	lw	a4,-52(s0)
    8000373e:	fce7eae3          	bltu	a5,a4,80003712 <sys_pause+0x4a>
    80003742:	74a2                	ld	s1,40(sp)
    80003744:	7902                	ld	s2,32(sp)
  }
  release(&tickslock);
    80003746:	00242517          	auipc	a0,0x242
    8000374a:	e4250513          	addi	a0,a0,-446 # 80245588 <tickslock>
    8000374e:	e5cfd0ef          	jal	80000daa <release>
  return 0;
    80003752:	4501                	li	a0,0
}
    80003754:	70e2                	ld	ra,56(sp)
    80003756:	7442                	ld	s0,48(sp)
    80003758:	69e2                	ld	s3,24(sp)
    8000375a:	6121                	addi	sp,sp,64
    8000375c:	8082                	ret
    n = 0;
    8000375e:	fc042623          	sw	zero,-52(s0)
    80003762:	b749                	j	800036e4 <sys_pause+0x1c>
      release(&tickslock);
    80003764:	00242517          	auipc	a0,0x242
    80003768:	e2450513          	addi	a0,a0,-476 # 80245588 <tickslock>
    8000376c:	e3efd0ef          	jal	80000daa <release>
      return -1;
    80003770:	557d                	li	a0,-1
    80003772:	74a2                	ld	s1,40(sp)
    80003774:	7902                	ld	s2,32(sp)
    80003776:	bff9                	j	80003754 <sys_pause+0x8c>

0000000080003778 <sys_kill>:

uint64
sys_kill(void)
{
    80003778:	1101                	addi	sp,sp,-32
    8000377a:	ec06                	sd	ra,24(sp)
    8000377c:	e822                	sd	s0,16(sp)
    8000377e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003780:	fec40593          	addi	a1,s0,-20
    80003784:	4501                	li	a0,0
    80003786:	d59ff0ef          	jal	800034de <argint>
  return kkill(pid);
    8000378a:	fec42503          	lw	a0,-20(s0)
    8000378e:	9acff0ef          	jal	8000293a <kkill>
}
    80003792:	60e2                	ld	ra,24(sp)
    80003794:	6442                	ld	s0,16(sp)
    80003796:	6105                	addi	sp,sp,32
    80003798:	8082                	ret

000000008000379a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000379a:	1101                	addi	sp,sp,-32
    8000379c:	ec06                	sd	ra,24(sp)
    8000379e:	e822                	sd	s0,16(sp)
    800037a0:	e426                	sd	s1,8(sp)
    800037a2:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800037a4:	00242517          	auipc	a0,0x242
    800037a8:	de450513          	addi	a0,a0,-540 # 80245588 <tickslock>
    800037ac:	d76fd0ef          	jal	80000d22 <acquire>
  xticks = ticks;
    800037b0:	00005497          	auipc	s1,0x5
    800037b4:	4704a483          	lw	s1,1136(s1) # 80008c20 <ticks>
  release(&tickslock);
    800037b8:	00242517          	auipc	a0,0x242
    800037bc:	dd050513          	addi	a0,a0,-560 # 80245588 <tickslock>
    800037c0:	deafd0ef          	jal	80000daa <release>
  return xticks;
}
    800037c4:	02049513          	slli	a0,s1,0x20
    800037c8:	9101                	srli	a0,a0,0x20
    800037ca:	60e2                	ld	ra,24(sp)
    800037cc:	6442                	ld	s0,16(sp)
    800037ce:	64a2                	ld	s1,8(sp)
    800037d0:	6105                	addi	sp,sp,32
    800037d2:	8082                	ret

00000000800037d4 <sys_ps>:

uint64
sys_ps(void)
{
    800037d4:	1141                	addi	sp,sp,-16
    800037d6:	e406                	sd	ra,8(sp)
    800037d8:	e022                	sd	s0,0(sp)
    800037da:	0800                	addi	s0,sp,16
  procdump();
    800037dc:	d62ff0ef          	jal	80002d3e <procdump>
  return 0;
}
    800037e0:	4501                	li	a0,0
    800037e2:	60a2                	ld	ra,8(sp)
    800037e4:	6402                	ld	s0,0(sp)
    800037e6:	0141                	addi	sp,sp,16
    800037e8:	8082                	ret

00000000800037ea <sys_setpriority>:

uint64
sys_setpriority(void)
{
    800037ea:	1101                	addi	sp,sp,-32
    800037ec:	ec06                	sd	ra,24(sp)
    800037ee:	e822                	sd	s0,16(sp)
    800037f0:	1000                	addi	s0,sp,32
  int pid;
  int priority;

  argint(0, &pid);
    800037f2:	fec40593          	addi	a1,s0,-20
    800037f6:	4501                	li	a0,0
    800037f8:	ce7ff0ef          	jal	800034de <argint>
  argint(1, &priority);
    800037fc:	fe840593          	addi	a1,s0,-24
    80003800:	4505                	li	a0,1
    80003802:	cddff0ef          	jal	800034de <argint>

  if(priority < 1 || priority > 20)
    80003806:	fe842583          	lw	a1,-24(s0)
    8000380a:	fff5871b          	addiw	a4,a1,-1
    8000380e:	47cd                	li	a5,19
    return -1;
    80003810:	557d                	li	a0,-1
  if(priority < 1 || priority > 20)
    80003812:	00e7e663          	bltu	a5,a4,8000381e <sys_setpriority+0x34>

  return setpriority(pid, priority);
    80003816:	fec42503          	lw	a0,-20(s0)
    8000381a:	dd0ff0ef          	jal	80002dea <setpriority>
}
    8000381e:	60e2                	ld	ra,24(sp)
    80003820:	6442                	ld	s0,16(sp)
    80003822:	6105                	addi	sp,sp,32
    80003824:	8082                	ret

0000000080003826 <mmap_find_addr>:

uint64
mmap_find_addr(struct proc *p, uint64 length)
{
    80003826:	1141                	addi	sp,sp,-16
    80003828:	e406                	sd	ra,8(sp)
    8000382a:	e022                	sd	s0,0(sp)
    8000382c:	0800                	addi	s0,sp,16
    8000382e:	882a                	mv	a6,a0
  uint64 end;
  int i;

  end = TRAPFRAME;

  for(i = 0; i < NVMA; i++){
    80003830:	18050793          	addi	a5,a0,384
    80003834:	50050613          	addi	a2,a0,1280
  end = TRAPFRAME;
    80003838:	020006b7          	lui	a3,0x2000
    8000383c:	16fd                	addi	a3,a3,-1 # 1ffffff <_entry-0x7e000001>
    8000383e:	06b6                	slli	a3,a3,0xd
    80003840:	a029                	j	8000384a <mmap_find_addr+0x24>
  for(i = 0; i < NVMA; i++){
    80003842:	03878793          	addi	a5,a5,56
    80003846:	00c78963          	beq	a5,a2,80003858 <mmap_find_addr+0x32>
    if(p->vmas[i].used){
    8000384a:	4398                	lw	a4,0(a5)
    8000384c:	db7d                	beqz	a4,80003842 <mmap_find_addr+0x1c>
      if(p->vmas[i].addr < end)
    8000384e:	6798                	ld	a4,8(a5)
    80003850:	fed779e3          	bgeu	a4,a3,80003842 <mmap_find_addr+0x1c>
    80003854:	86ba                	mv	a3,a4
    80003856:	b7f5                	j	80003842 <mmap_find_addr+0x1c>
        end = p->vmas[i].addr;
    }
  }

  length = PGROUNDUP(length);
    80003858:	6785                	lui	a5,0x1
    8000385a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000385c:	97ae                	add	a5,a5,a1
    8000385e:	777d                	lui	a4,0xfffff
    80003860:	8ff9                	and	a5,a5,a4

  if(length > end)
    return 0;
    80003862:	4501                	li	a0,0
  if(length > end)
    80003864:	00f6e963          	bltu	a3,a5,80003876 <mmap_find_addr+0x50>

  addr = PGROUNDDOWN(end - length);
    80003868:	8e9d                	sub	a3,a3,a5
    8000386a:	00e6f533          	and	a0,a3,a4

  if(addr < p->sz)
    8000386e:	07083783          	ld	a5,112(a6)
    80003872:	00f56663          	bltu	a0,a5,8000387e <mmap_find_addr+0x58>
    return 0;

  return addr;
}
    80003876:	60a2                	ld	ra,8(sp)
    80003878:	6402                	ld	s0,0(sp)
    8000387a:	0141                	addi	sp,sp,16
    8000387c:	8082                	ret
    return 0;
    8000387e:	4501                	li	a0,0
    80003880:	bfdd                	j	80003876 <mmap_find_addr+0x50>

0000000080003882 <sys_mmap>:

uint64
sys_mmap(void)
{
    80003882:	7119                	addi	sp,sp,-128
    80003884:	fc86                	sd	ra,120(sp)
    80003886:	f8a2                	sd	s0,112(sp)
    80003888:	f0ca                	sd	s2,96(sp)
    8000388a:	ecce                	sd	s3,88(sp)
    8000388c:	0100                	addi	s0,sp,128
  uint64 offset;
  int prot;
  int flags;
  int fd;
  struct file *f;
  struct proc *p = myproc();
    8000388e:	f68fe0ef          	jal	80001ff6 <myproc>
    80003892:	892a                	mv	s2,a0
  struct vma *vma;
  int i;

  argaddr(0, &addr);
    80003894:	fa840593          	addi	a1,s0,-88
    80003898:	4501                	li	a0,0
    8000389a:	c61ff0ef          	jal	800034fa <argaddr>
  argaddr(1, &length);
    8000389e:	fa040593          	addi	a1,s0,-96
    800038a2:	4505                	li	a0,1
    800038a4:	c57ff0ef          	jal	800034fa <argaddr>
  argint(2, &prot);
    800038a8:	f9440593          	addi	a1,s0,-108
    800038ac:	4509                	li	a0,2
    800038ae:	c31ff0ef          	jal	800034de <argint>
  argint(3, &flags);
    800038b2:	f9040593          	addi	a1,s0,-112
    800038b6:	450d                	li	a0,3
    800038b8:	c27ff0ef          	jal	800034de <argint>
  argint(4, &fd);
    800038bc:	f8c40593          	addi	a1,s0,-116
    800038c0:	4511                	li	a0,4
    800038c2:	c1dff0ef          	jal	800034de <argint>
  argaddr(5, &offset);
    800038c6:	f9840593          	addi	a1,s0,-104
    800038ca:	4515                	li	a0,5
    800038cc:	c2fff0ef          	jal	800034fa <argaddr>

  if(length == 0)
    800038d0:	fa043983          	ld	s3,-96(s0)
    return -1;
    800038d4:	557d                	li	a0,-1
  if(length == 0)
    800038d6:	0e098963          	beqz	s3,800039c8 <sys_mmap+0x146>

  if(offset % PGSIZE != 0)
    800038da:	f9843783          	ld	a5,-104(s0)
    800038de:	17d2                	slli	a5,a5,0x34
    800038e0:	e7e5                	bnez	a5,800039c8 <sys_mmap+0x146>
    800038e2:	e8d2                	sd	s4,80(sp)
    return -1;

  if(prot & ~(PROT_READ | PROT_WRITE))
    800038e4:	f9442a03          	lw	s4,-108(s0)
    800038e8:	478d                	li	a5,3
    800038ea:	0d47eb63          	bltu	a5,s4,800039c0 <sys_mmap+0x13e>
    800038ee:	e4d6                	sd	s5,72(sp)
    return -1;

  if(flags != MAP_SHARED && flags != MAP_PRIVATE)
    800038f0:	f9042a83          	lw	s5,-112(s0)
    800038f4:	fffa871b          	addiw	a4,s5,-1
    800038f8:	4785                	li	a5,1
    800038fa:	0ce7e563          	bltu	a5,a4,800039c4 <sys_mmap+0x142>
    return -1;

  if(fd < 0 || fd >= NOFILE)
    800038fe:	f8c42783          	lw	a5,-116(s0)
    80003902:	473d                	li	a4,15
    80003904:	0cf76863          	bltu	a4,a5,800039d4 <sys_mmap+0x152>
    80003908:	e0da                	sd	s6,64(sp)
    return -1;

  f = p->ofile[fd];
    8000390a:	07f9                	addi	a5,a5,30
    8000390c:	078e                	slli	a5,a5,0x3
    8000390e:	97ca                	add	a5,a5,s2
    80003910:	0087bb03          	ld	s6,8(a5)

  if(f == 0)
    80003914:	020b0463          	beqz	s6,8000393c <sys_mmap+0xba>
    80003918:	f4a6                	sd	s1,104(sp)
    8000391a:	18090793          	addi	a5,s2,384
    return -1;

  for(i = 0; i < NVMA; i++){
    8000391e:	4481                	li	s1,0
    80003920:	46c1                	li	a3,16
    if(p->vmas[i].used == 0)
    80003922:	4398                	lw	a4,0(a5)
    80003924:	c30d                	beqz	a4,80003946 <sys_mmap+0xc4>
  for(i = 0; i < NVMA; i++){
    80003926:	2485                	addiw	s1,s1,1
    80003928:	03878793          	addi	a5,a5,56
    8000392c:	fed49be3          	bne	s1,a3,80003922 <sys_mmap+0xa0>
      break;
  }

  if(i == NVMA)
    return -1;
    80003930:	557d                	li	a0,-1
    80003932:	74a6                	ld	s1,104(sp)
    80003934:	6a46                	ld	s4,80(sp)
    80003936:	6aa6                	ld	s5,72(sp)
    80003938:	6b06                	ld	s6,64(sp)
    8000393a:	a079                	j	800039c8 <sys_mmap+0x146>
    return -1;
    8000393c:	557d                	li	a0,-1
    8000393e:	6a46                	ld	s4,80(sp)
    80003940:	6aa6                	ld	s5,72(sp)
    80003942:	6b06                	ld	s6,64(sp)
    80003944:	a051                	j	800039c8 <sys_mmap+0x146>

  vma = &p->vmas[i];

  vma->addr = mmap_find_addr(p, length);
    80003946:	85ce                	mv	a1,s3
    80003948:	854a                	mv	a0,s2
    8000394a:	eddff0ef          	jal	80003826 <mmap_find_addr>
    8000394e:	872a                	mv	a4,a0
    80003950:	00349793          	slli	a5,s1,0x3
    80003954:	8f85                	sub	a5,a5,s1
    80003956:	078e                	slli	a5,a5,0x3
    80003958:	97ca                	add	a5,a5,s2
    8000395a:	18a7b423          	sd	a0,392(a5)

  if(vma->addr == 0)
    return -1;
    8000395e:	557d                	li	a0,-1
  if(vma->addr == 0)
    80003960:	cb39                	beqz	a4,800039b6 <sys_mmap+0x134>
    80003962:	fc5e                	sd	s7,56(sp)
    80003964:	f862                	sd	s8,48(sp)

  vma->used = 1;
    80003966:	00349c13          	slli	s8,s1,0x3
    8000396a:	409c0bb3          	sub	s7,s8,s1
    8000396e:	0b8e                	slli	s7,s7,0x3
    80003970:	9bca                	add	s7,s7,s2
    80003972:	4785                	li	a5,1
    80003974:	18fba023          	sw	a5,384(s7)
  vma->length = length;
    80003978:	193bb823          	sd	s3,400(s7)
  vma->maplen = PGROUNDUP(length);
    8000397c:	6785                	lui	a5,0x1
    8000397e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80003980:	97ce                	add	a5,a5,s3
    80003982:	777d                	lui	a4,0xfffff
    80003984:	8ff9                	and	a5,a5,a4
    80003986:	18fbbc23          	sd	a5,408(s7)
  vma->prot = prot;
    8000398a:	1b4ba023          	sw	s4,416(s7)
  vma->flags = flags;
    8000398e:	1b5ba223          	sw	s5,420(s7)
  vma->file = filedup(f);
    80003992:	855a                	mv	a0,s6
    80003994:	07b010ef          	jal	8000520e <filedup>
    80003998:	1aabb423          	sd	a0,424(s7)
  vma->offset = offset;
    8000399c:	f9843783          	ld	a5,-104(s0)
    800039a0:	1afbb823          	sd	a5,432(s7)

  return vma->addr;
    800039a4:	188bb503          	ld	a0,392(s7)
    800039a8:	74a6                	ld	s1,104(sp)
    800039aa:	6a46                	ld	s4,80(sp)
    800039ac:	6aa6                	ld	s5,72(sp)
    800039ae:	6b06                	ld	s6,64(sp)
    800039b0:	7be2                	ld	s7,56(sp)
    800039b2:	7c42                	ld	s8,48(sp)
    800039b4:	a811                	j	800039c8 <sys_mmap+0x146>
    800039b6:	74a6                	ld	s1,104(sp)
    800039b8:	6a46                	ld	s4,80(sp)
    800039ba:	6aa6                	ld	s5,72(sp)
    800039bc:	6b06                	ld	s6,64(sp)
    800039be:	a029                	j	800039c8 <sys_mmap+0x146>
    800039c0:	6a46                	ld	s4,80(sp)
    800039c2:	a019                	j	800039c8 <sys_mmap+0x146>
    800039c4:	6a46                	ld	s4,80(sp)
    800039c6:	6aa6                	ld	s5,72(sp)
}
    800039c8:	70e6                	ld	ra,120(sp)
    800039ca:	7446                	ld	s0,112(sp)
    800039cc:	7906                	ld	s2,96(sp)
    800039ce:	69e6                	ld	s3,88(sp)
    800039d0:	6109                	addi	sp,sp,128
    800039d2:	8082                	ret
    800039d4:	6a46                	ld	s4,80(sp)
    800039d6:	6aa6                	ld	s5,72(sp)
    800039d8:	bfc5                	j	800039c8 <sys_mmap+0x146>

00000000800039da <sys_munmap>:

uint64
sys_munmap(void)
{
    800039da:	1101                	addi	sp,sp,-32
    800039dc:	ec06                	sd	ra,24(sp)
    800039de:	e822                	sd	s0,16(sp)
    800039e0:	1000                	addi	s0,sp,32
  uint64 addr;
  uint64 length;

  argaddr(0, &addr);
    800039e2:	fe840593          	addi	a1,s0,-24
    800039e6:	4501                	li	a0,0
    800039e8:	b13ff0ef          	jal	800034fa <argaddr>
  argaddr(1, &length);
    800039ec:	fe040593          	addi	a1,s0,-32
    800039f0:	4505                	li	a0,1
    800039f2:	b09ff0ef          	jal	800034fa <argaddr>

  if(length == 0)
    800039f6:	fe043783          	ld	a5,-32(s0)
    return -1;
    800039fa:	557d                	li	a0,-1
  if(length == 0)
    800039fc:	cf89                	beqz	a5,80003a16 <sys_munmap+0x3c>

  if(addr % PGSIZE != 0)
    800039fe:	fe843783          	ld	a5,-24(s0)
    80003a02:	17d2                	slli	a5,a5,0x34
    80003a04:	eb89                	bnez	a5,80003a16 <sys_munmap+0x3c>
    return -1;

  return mmap_unmap(myproc(), addr, length);
    80003a06:	df0fe0ef          	jal	80001ff6 <myproc>
    80003a0a:	fe043603          	ld	a2,-32(s0)
    80003a0e:	fe843583          	ld	a1,-24(s0)
    80003a12:	938fe0ef          	jal	80001b4a <mmap_unmap>
}
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	6105                	addi	sp,sp,32
    80003a1c:	8082                	ret

0000000080003a1e <sys_trace>:

uint64
sys_trace(void)
{
    80003a1e:	1101                	addi	sp,sp,-32
    80003a20:	ec06                	sd	ra,24(sp)
    80003a22:	e822                	sd	s0,16(sp)
    80003a24:	1000                	addi	s0,sp,32
  uint64 mask;

  argaddr(0, &mask);
    80003a26:	fe840593          	addi	a1,s0,-24
    80003a2a:	4501                	li	a0,0
    80003a2c:	acfff0ef          	jal	800034fa <argaddr>
  myproc()->trace_mask = mask;
    80003a30:	dc6fe0ef          	jal	80001ff6 <myproc>
    80003a34:	fe843783          	ld	a5,-24(s0)
    80003a38:	e13c                	sd	a5,64(a0)
  return 0;
}
    80003a3a:	4501                	li	a0,0
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	6105                	addi	sp,sp,32
    80003a42:	8082                	ret

0000000080003a44 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80003a44:	715d                	addi	sp,sp,-80
    80003a46:	e486                	sd	ra,72(sp)
    80003a48:	e0a2                	sd	s0,64(sp)
    80003a4a:	fc26                	sd	s1,56(sp)
    80003a4c:	0880                	addi	s0,sp,80
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    80003a4e:	da8fe0ef          	jal	80001ff6 <myproc>
    80003a52:	84aa                	mv	s1,a0

  argaddr(0, &addr);
    80003a54:	fd840593          	addi	a1,s0,-40
    80003a58:	4501                	li	a0,0
    80003a5a:	aa1ff0ef          	jal	800034fa <argaddr>

  info.freemem = kfreemem();
    80003a5e:	9defd0ef          	jal	80000c3c <kfreemem>
    80003a62:	faa43c23          	sd	a0,-72(s0)
  info.totalmem = ktotalmem();
    80003a66:	a18fd0ef          	jal	80000c7e <ktotalmem>
    80003a6a:	fca43023          	sd	a0,-64(s0)
  info.nproc = nproc_active();
    80003a6e:	bdaff0ef          	jal	80002e48 <nproc_active>
    80003a72:	fca43423          	sd	a0,-56(s0)
  acquire(&tickslock);
    80003a76:	00242517          	auipc	a0,0x242
    80003a7a:	b1250513          	addi	a0,a0,-1262 # 80245588 <tickslock>
    80003a7e:	aa4fd0ef          	jal	80000d22 <acquire>
  info.uptime = ticks;
    80003a82:	00005797          	auipc	a5,0x5
    80003a86:	19e7e783          	lwu	a5,414(a5) # 80008c20 <ticks>
    80003a8a:	fcf43823          	sd	a5,-48(s0)
  release(&tickslock);
    80003a8e:	00242517          	auipc	a0,0x242
    80003a92:	afa50513          	addi	a0,a0,-1286 # 80245588 <tickslock>
    80003a96:	b14fd0ef          	jal	80000daa <release>

  if(copyout(p->pagetable, p->sz, addr, (char *)&info, sizeof(info)) < 0)
    80003a9a:	02000713          	li	a4,32
    80003a9e:	fb840693          	addi	a3,s0,-72
    80003aa2:	fd843603          	ld	a2,-40(s0)
    80003aa6:	78ac                	ld	a1,112(s1)
    80003aa8:	7ca8                	ld	a0,120(s1)
    80003aaa:	ef3fd0ef          	jal	8000199c <copyout>
    return -1;

  return 0;
}
    80003aae:	957d                	srai	a0,a0,0x3f
    80003ab0:	60a6                	ld	ra,72(sp)
    80003ab2:	6406                	ld	s0,64(sp)
    80003ab4:	74e2                	ld	s1,56(sp)
    80003ab6:	6161                	addi	sp,sp,80
    80003ab8:	8082                	ret

0000000080003aba <sys_getppid>:

uint64
sys_getppid(void)
{
    80003aba:	1141                	addi	sp,sp,-16
    80003abc:	e406                	sd	ra,8(sp)
    80003abe:	e022                	sd	s0,0(sp)
    80003ac0:	0800                	addi	s0,sp,16
  return kgetppid();
    80003ac2:	bd2ff0ef          	jal	80002e94 <kgetppid>
}
    80003ac6:	60a2                	ld	ra,8(sp)
    80003ac8:	6402                	ld	s0,0(sp)
    80003aca:	0141                	addi	sp,sp,16
    80003acc:	8082                	ret

0000000080003ace <sys_ptree>:

uint64
sys_ptree(void)
{
    80003ace:	1141                	addi	sp,sp,-16
    80003ad0:	e406                	sd	ra,8(sp)
    80003ad2:	e022                	sd	s0,0(sp)
    80003ad4:	0800                	addi	s0,sp,16
  proctree();
    80003ad6:	c0aff0ef          	jal	80002ee0 <proctree>
  return 0;
}
    80003ada:	4501                	li	a0,0
    80003adc:	60a2                	ld	ra,8(sp)
    80003ade:	6402                	ld	s0,0(sp)
    80003ae0:	0141                	addi	sp,sp,16
    80003ae2:	8082                	ret

0000000080003ae4 <sys_getsyscallcount>:

uint64
sys_getsyscallcount(void)
{
    80003ae4:	1101                	addi	sp,sp,-32
    80003ae6:	ec06                	sd	ra,24(sp)
    80003ae8:	e822                	sd	s0,16(sp)
    80003aea:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003aec:	fec40593          	addi	a1,s0,-20
    80003af0:	4501                	li	a0,0
    80003af2:	9edff0ef          	jal	800034de <argint>
  return getsyscallcount_proc(pid);
    80003af6:	fec42503          	lw	a0,-20(s0)
    80003afa:	cbaff0ef          	jal	80002fb4 <getsyscallcount_proc>
}
    80003afe:	60e2                	ld	ra,24(sp)
    80003b00:	6442                	ld	s0,16(sp)
    80003b02:	6105                	addi	sp,sp,32
    80003b04:	8082                	ret

0000000080003b06 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003b06:	7179                	addi	sp,sp,-48
    80003b08:	f406                	sd	ra,40(sp)
    80003b0a:	f022                	sd	s0,32(sp)
    80003b0c:	1800                	addi	s0,sp,48
  uint64 addr, waddr, raddr;

  argaddr(0, &addr);
    80003b0e:	fe840593          	addi	a1,s0,-24
    80003b12:	4501                	li	a0,0
    80003b14:	9e7ff0ef          	jal	800034fa <argaddr>
  argaddr(1, &waddr);
    80003b18:	fe040593          	addi	a1,s0,-32
    80003b1c:	4505                	li	a0,1
    80003b1e:	9ddff0ef          	jal	800034fa <argaddr>
  argaddr(2, &raddr);
    80003b22:	fd840593          	addi	a1,s0,-40
    80003b26:	4509                	li	a0,2
    80003b28:	9d3ff0ef          	jal	800034fa <argaddr>

  return kwaitx(addr, waddr, raddr);
    80003b2c:	fd843603          	ld	a2,-40(s0)
    80003b30:	fe043583          	ld	a1,-32(s0)
    80003b34:	fe843503          	ld	a0,-24(s0)
    80003b38:	fd1fe0ef          	jal	80002b08 <kwaitx>
}
    80003b3c:	70a2                	ld	ra,40(sp)
    80003b3e:	7402                	ld	s0,32(sp)
    80003b40:	6145                	addi	sp,sp,48
    80003b42:	8082                	ret

0000000080003b44 <sys_halt>:

uint64
sys_halt(void)
{
    80003b44:	1141                	addi	sp,sp,-16
    80003b46:	e406                	sd	ra,8(sp)
    80003b48:	e022                	sd	s0,0(sp)
    80003b4a:	0800                	addi	s0,sp,16
  printk("System halting...\n");
    80003b4c:	00005517          	auipc	a0,0x5
    80003b50:	a0c50513          	addi	a0,a0,-1524 # 80008558 <etext+0x558>
    80003b54:	9b7fc0ef          	jal	8000050a <printk>
  *(volatile uint32 *)VIRT_TEST = 0x5555;
    80003b58:	00100737          	lui	a4,0x100
    80003b5c:	6795                	lui	a5,0x5
    80003b5e:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80003b62:	c31c                	sw	a5,0(a4)
  for(;;)
    80003b64:	a001                	j	80003b64 <sys_halt+0x20>

0000000080003b66 <sys_reboot>:
  return 0;
}

uint64
sys_reboot(void)
{
    80003b66:	1141                	addi	sp,sp,-16
    80003b68:	e406                	sd	ra,8(sp)
    80003b6a:	e022                	sd	s0,0(sp)
    80003b6c:	0800                	addi	s0,sp,16
  printk("System rebooting...\n");
    80003b6e:	00005517          	auipc	a0,0x5
    80003b72:	a0250513          	addi	a0,a0,-1534 # 80008570 <etext+0x570>
    80003b76:	995fc0ef          	jal	8000050a <printk>
  *(volatile uint32 *)VIRT_TEST = 0x7777;
    80003b7a:	00100737          	lui	a4,0x100
    80003b7e:	679d                	lui	a5,0x7
    80003b80:	77778793          	addi	a5,a5,1911 # 7777 <_entry-0x7fff8889>
    80003b84:	c31c                	sw	a5,0(a4)
  for(;;)
    80003b86:	a001                	j	80003b86 <sys_reboot+0x20>

0000000080003b88 <sys_sched_yield>:
  return 0;
}

uint64
sys_sched_yield(void)
{
    80003b88:	1141                	addi	sp,sp,-16
    80003b8a:	e406                	sd	ra,8(sp)
    80003b8c:	e022                	sd	s0,0(sp)
    80003b8e:	0800                	addi	s0,sp,16
  yield();
    80003b90:	b97fe0ef          	jal	80002726 <yield>
  return 0;
}
    80003b94:	4501                	li	a0,0
    80003b96:	60a2                	ld	ra,8(sp)
    80003b98:	6402                	ld	s0,0(sp)
    80003b9a:	0141                	addi	sp,sp,16
    80003b9c:	8082                	ret

0000000080003b9e <sys_getcpuid>:

uint64
sys_getcpuid(void)
{
    80003b9e:	1101                	addi	sp,sp,-32
    80003ba0:	ec06                	sd	ra,24(sp)
    80003ba2:	e822                	sd	s0,16(sp)
    80003ba4:	e426                	sd	s1,8(sp)
    80003ba6:	1000                	addi	s0,sp,32
  int id;

  push_off();
    80003ba8:	944fd0ef          	jal	80000cec <push_off>
  id = cpuid();
    80003bac:	c16fe0ef          	jal	80001fc2 <cpuid>
    80003bb0:	84aa                	mv	s1,a0
  pop_off();
    80003bb2:	9b0fd0ef          	jal	80000d62 <pop_off>
  return id;
}
    80003bb6:	8526                	mv	a0,s1
    80003bb8:	60e2                	ld	ra,24(sp)
    80003bba:	6442                	ld	s0,16(sp)
    80003bbc:	64a2                	ld	s1,8(sp)
    80003bbe:	6105                	addi	sp,sp,32
    80003bc0:	8082                	ret

0000000080003bc2 <sys_setprocname>:

uint64
sys_setprocname(void)
{
    80003bc2:	7179                	addi	sp,sp,-48
    80003bc4:	f406                	sd	ra,40(sp)
    80003bc6:	f022                	sd	s0,32(sp)
    80003bc8:	ec26                	sd	s1,24(sp)
    80003bca:	1800                	addi	s0,sp,48
  char buf[16];
  struct proc *p = myproc();
    80003bcc:	c2afe0ef          	jal	80001ff6 <myproc>
    80003bd0:	84aa                	mv	s1,a0

  if(argstr(0, buf, sizeof(buf)) < 0)
    80003bd2:	4641                	li	a2,16
    80003bd4:	fd040593          	addi	a1,s0,-48
    80003bd8:	4501                	li	a0,0
    80003bda:	93dff0ef          	jal	80003516 <argstr>
    80003bde:	02054963          	bltz	a0,80003c10 <sys_setprocname+0x4e>
    return -1;

  if(buf[0] == '\0')
    80003be2:	fd044783          	lbu	a5,-48(s0)
    return -1;
    80003be6:	557d                	li	a0,-1
  if(buf[0] == '\0')
    80003be8:	cf99                	beqz	a5,80003c06 <sys_setprocname+0x44>

  acquire(&p->lock);
    80003bea:	8526                	mv	a0,s1
    80003bec:	936fd0ef          	jal	80000d22 <acquire>
  safestrcpy(p->name, buf, sizeof(p->name));
    80003bf0:	4641                	li	a2,16
    80003bf2:	fd040593          	addi	a1,s0,-48
    80003bf6:	50048513          	addi	a0,s1,1280
    80003bfa:	b3afd0ef          	jal	80000f34 <safestrcpy>
  release(&p->lock);
    80003bfe:	8526                	mv	a0,s1
    80003c00:	9aafd0ef          	jal	80000daa <release>

  return 0;
    80003c04:	4501                	li	a0,0
}
    80003c06:	70a2                	ld	ra,40(sp)
    80003c08:	7402                	ld	s0,32(sp)
    80003c0a:	64e2                	ld	s1,24(sp)
    80003c0c:	6145                	addi	sp,sp,48
    80003c0e:	8082                	ret
    return -1;
    80003c10:	557d                	li	a0,-1
    80003c12:	bfd5                	j	80003c06 <sys_setprocname+0x44>

0000000080003c14 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003c14:	7179                	addi	sp,sp,-48
    80003c16:	f406                	sd	ra,40(sp)
    80003c18:	f022                	sd	s0,32(sp)
    80003c1a:	ec26                	sd	s1,24(sp)
    80003c1c:	e84a                	sd	s2,16(sp)
    80003c1e:	e44e                	sd	s3,8(sp)
    80003c20:	e052                	sd	s4,0(sp)
    80003c22:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003c24:	00005597          	auipc	a1,0x5
    80003c28:	96458593          	addi	a1,a1,-1692 # 80008588 <etext+0x588>
    80003c2c:	00242517          	auipc	a0,0x242
    80003c30:	97450513          	addi	a0,a0,-1676 # 802455a0 <bcache>
    80003c34:	874fd0ef          	jal	80000ca8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003c38:	0024a797          	auipc	a5,0x24a
    80003c3c:	96878793          	addi	a5,a5,-1688 # 8024d5a0 <bcache+0x8000>
    80003c40:	0024a717          	auipc	a4,0x24a
    80003c44:	bc870713          	addi	a4,a4,-1080 # 8024d808 <bcache+0x8268>
    80003c48:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003c4c:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80003c50:	00242497          	auipc	s1,0x242
    80003c54:	96848493          	addi	s1,s1,-1688 # 802455b8 <bcache+0x18>
    b->next = bcache.head.next;
    80003c58:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003c5a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003c5c:	00005a17          	auipc	s4,0x5
    80003c60:	934a0a13          	addi	s4,s4,-1740 # 80008590 <etext+0x590>
    b->next = bcache.head.next;
    80003c64:	2b893783          	ld	a5,696(s2)
    80003c68:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003c6a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003c6e:	85d2                	mv	a1,s4
    80003c70:	01048513          	addi	a0,s1,16
    80003c74:	40c010ef          	jal	80005080 <initsleeplock>
    bcache.head.next->prev = b;
    80003c78:	2b893783          	ld	a5,696(s2)
    80003c7c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003c7e:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80003c82:	45848493          	addi	s1,s1,1112
    80003c86:	fd349fe3          	bne	s1,s3,80003c64 <binit+0x50>
  }
}
    80003c8a:	70a2                	ld	ra,40(sp)
    80003c8c:	7402                	ld	s0,32(sp)
    80003c8e:	64e2                	ld	s1,24(sp)
    80003c90:	6942                	ld	s2,16(sp)
    80003c92:	69a2                	ld	s3,8(sp)
    80003c94:	6a02                	ld	s4,0(sp)
    80003c96:	6145                	addi	sp,sp,48
    80003c98:	8082                	ret

0000000080003c9a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80003c9a:	7179                	addi	sp,sp,-48
    80003c9c:	f406                	sd	ra,40(sp)
    80003c9e:	f022                	sd	s0,32(sp)
    80003ca0:	ec26                	sd	s1,24(sp)
    80003ca2:	e84a                	sd	s2,16(sp)
    80003ca4:	e44e                	sd	s3,8(sp)
    80003ca6:	1800                	addi	s0,sp,48
    80003ca8:	892a                	mv	s2,a0
    80003caa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003cac:	00242517          	auipc	a0,0x242
    80003cb0:	8f450513          	addi	a0,a0,-1804 # 802455a0 <bcache>
    80003cb4:	86efd0ef          	jal	80000d22 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80003cb8:	0024a497          	auipc	s1,0x24a
    80003cbc:	ba04b483          	ld	s1,-1120(s1) # 8024d858 <bcache+0x82b8>
    80003cc0:	0024a797          	auipc	a5,0x24a
    80003cc4:	b4878793          	addi	a5,a5,-1208 # 8024d808 <bcache+0x8268>
    80003cc8:	02f48b63          	beq	s1,a5,80003cfe <bread+0x64>
    80003ccc:	873e                	mv	a4,a5
    80003cce:	a021                	j	80003cd6 <bread+0x3c>
    80003cd0:	68a4                	ld	s1,80(s1)
    80003cd2:	02e48663          	beq	s1,a4,80003cfe <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80003cd6:	449c                	lw	a5,8(s1)
    80003cd8:	ff279ce3          	bne	a5,s2,80003cd0 <bread+0x36>
    80003cdc:	44dc                	lw	a5,12(s1)
    80003cde:	ff3799e3          	bne	a5,s3,80003cd0 <bread+0x36>
      b->refcnt++;
    80003ce2:	40bc                	lw	a5,64(s1)
    80003ce4:	2785                	addiw	a5,a5,1
    80003ce6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003ce8:	00242517          	auipc	a0,0x242
    80003cec:	8b850513          	addi	a0,a0,-1864 # 802455a0 <bcache>
    80003cf0:	8bafd0ef          	jal	80000daa <release>
      acquiresleep(&b->lock);
    80003cf4:	01048513          	addi	a0,s1,16
    80003cf8:	3be010ef          	jal	800050b6 <acquiresleep>
      return b;
    80003cfc:	a889                	j	80003d4e <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80003cfe:	0024a497          	auipc	s1,0x24a
    80003d02:	b524b483          	ld	s1,-1198(s1) # 8024d850 <bcache+0x82b0>
    80003d06:	0024a797          	auipc	a5,0x24a
    80003d0a:	b0278793          	addi	a5,a5,-1278 # 8024d808 <bcache+0x8268>
    80003d0e:	00f48863          	beq	s1,a5,80003d1e <bread+0x84>
    80003d12:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80003d14:	40bc                	lw	a5,64(s1)
    80003d16:	cb91                	beqz	a5,80003d2a <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80003d18:	64a4                	ld	s1,72(s1)
    80003d1a:	fee49de3          	bne	s1,a4,80003d14 <bread+0x7a>
  panic("bget: no buffers");
    80003d1e:	00005517          	auipc	a0,0x5
    80003d22:	87a50513          	addi	a0,a0,-1926 # 80008598 <etext+0x598>
    80003d26:	ac9fc0ef          	jal	800007ee <panic>
      b->dev = dev;
    80003d2a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003d2e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003d32:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003d36:	4785                	li	a5,1
    80003d38:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003d3a:	00242517          	auipc	a0,0x242
    80003d3e:	86650513          	addi	a0,a0,-1946 # 802455a0 <bcache>
    80003d42:	868fd0ef          	jal	80000daa <release>
      acquiresleep(&b->lock);
    80003d46:	01048513          	addi	a0,s1,16
    80003d4a:	36c010ef          	jal	800050b6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80003d4e:	409c                	lw	a5,0(s1)
    80003d50:	cb89                	beqz	a5,80003d62 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003d52:	8526                	mv	a0,s1
    80003d54:	70a2                	ld	ra,40(sp)
    80003d56:	7402                	ld	s0,32(sp)
    80003d58:	64e2                	ld	s1,24(sp)
    80003d5a:	6942                	ld	s2,16(sp)
    80003d5c:	69a2                	ld	s3,8(sp)
    80003d5e:	6145                	addi	sp,sp,48
    80003d60:	8082                	ret
    virtio_disk_rw(b, 0);
    80003d62:	4581                	li	a1,0
    80003d64:	8526                	mv	a0,s1
    80003d66:	4ab020ef          	jal	80006a10 <virtio_disk_rw>
    b->valid = 1;
    80003d6a:	4785                	li	a5,1
    80003d6c:	c09c                	sw	a5,0(s1)
  return b;
    80003d6e:	b7d5                	j	80003d52 <bread+0xb8>

0000000080003d70 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80003d70:	1101                	addi	sp,sp,-32
    80003d72:	ec06                	sd	ra,24(sp)
    80003d74:	e822                	sd	s0,16(sp)
    80003d76:	e426                	sd	s1,8(sp)
    80003d78:	1000                	addi	s0,sp,32
    80003d7a:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80003d7c:	0541                	addi	a0,a0,16
    80003d7e:	3c4010ef          	jal	80005142 <holdingsleep>
    80003d82:	c911                	beqz	a0,80003d96 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003d84:	4585                	li	a1,1
    80003d86:	8526                	mv	a0,s1
    80003d88:	489020ef          	jal	80006a10 <virtio_disk_rw>
}
    80003d8c:	60e2                	ld	ra,24(sp)
    80003d8e:	6442                	ld	s0,16(sp)
    80003d90:	64a2                	ld	s1,8(sp)
    80003d92:	6105                	addi	sp,sp,32
    80003d94:	8082                	ret
    panic("bwrite");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	81a50513          	addi	a0,a0,-2022 # 800085b0 <etext+0x5b0>
    80003d9e:	a51fc0ef          	jal	800007ee <panic>

0000000080003da2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003da2:	1101                	addi	sp,sp,-32
    80003da4:	ec06                	sd	ra,24(sp)
    80003da6:	e822                	sd	s0,16(sp)
    80003da8:	e426                	sd	s1,8(sp)
    80003daa:	e04a                	sd	s2,0(sp)
    80003dac:	1000                	addi	s0,sp,32
    80003dae:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80003db0:	01050913          	addi	s2,a0,16
    80003db4:	854a                	mv	a0,s2
    80003db6:	38c010ef          	jal	80005142 <holdingsleep>
    80003dba:	c125                	beqz	a0,80003e1a <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	34c010ef          	jal	8000510a <releasesleep>

  acquire(&bcache.lock);
    80003dc2:	00241517          	auipc	a0,0x241
    80003dc6:	7de50513          	addi	a0,a0,2014 # 802455a0 <bcache>
    80003dca:	f59fc0ef          	jal	80000d22 <acquire>
  b->refcnt--;
    80003dce:	40bc                	lw	a5,64(s1)
    80003dd0:	37fd                	addiw	a5,a5,-1
    80003dd2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003dd4:	e79d                	bnez	a5,80003e02 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003dd6:	68b8                	ld	a4,80(s1)
    80003dd8:	64bc                	ld	a5,72(s1)
    80003dda:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003ddc:	68b8                	ld	a4,80(s1)
    80003dde:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003de0:	00249797          	auipc	a5,0x249
    80003de4:	7c078793          	addi	a5,a5,1984 # 8024d5a0 <bcache+0x8000>
    80003de8:	2b87b703          	ld	a4,696(a5)
    80003dec:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003dee:	0024a717          	auipc	a4,0x24a
    80003df2:	a1a70713          	addi	a4,a4,-1510 # 8024d808 <bcache+0x8268>
    80003df6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003df8:	2b87b703          	ld	a4,696(a5)
    80003dfc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003dfe:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003e02:	00241517          	auipc	a0,0x241
    80003e06:	79e50513          	addi	a0,a0,1950 # 802455a0 <bcache>
    80003e0a:	fa1fc0ef          	jal	80000daa <release>
}
    80003e0e:	60e2                	ld	ra,24(sp)
    80003e10:	6442                	ld	s0,16(sp)
    80003e12:	64a2                	ld	s1,8(sp)
    80003e14:	6902                	ld	s2,0(sp)
    80003e16:	6105                	addi	sp,sp,32
    80003e18:	8082                	ret
    panic("brelse");
    80003e1a:	00004517          	auipc	a0,0x4
    80003e1e:	79e50513          	addi	a0,a0,1950 # 800085b8 <etext+0x5b8>
    80003e22:	9cdfc0ef          	jal	800007ee <panic>

0000000080003e26 <bpin>:

void
bpin(struct buf *b)
{
    80003e26:	1101                	addi	sp,sp,-32
    80003e28:	ec06                	sd	ra,24(sp)
    80003e2a:	e822                	sd	s0,16(sp)
    80003e2c:	e426                	sd	s1,8(sp)
    80003e2e:	1000                	addi	s0,sp,32
    80003e30:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003e32:	00241517          	auipc	a0,0x241
    80003e36:	76e50513          	addi	a0,a0,1902 # 802455a0 <bcache>
    80003e3a:	ee9fc0ef          	jal	80000d22 <acquire>
  b->refcnt++;
    80003e3e:	40bc                	lw	a5,64(s1)
    80003e40:	2785                	addiw	a5,a5,1
    80003e42:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003e44:	00241517          	auipc	a0,0x241
    80003e48:	75c50513          	addi	a0,a0,1884 # 802455a0 <bcache>
    80003e4c:	f5ffc0ef          	jal	80000daa <release>
}
    80003e50:	60e2                	ld	ra,24(sp)
    80003e52:	6442                	ld	s0,16(sp)
    80003e54:	64a2                	ld	s1,8(sp)
    80003e56:	6105                	addi	sp,sp,32
    80003e58:	8082                	ret

0000000080003e5a <bunpin>:

void
bunpin(struct buf *b)
{
    80003e5a:	1101                	addi	sp,sp,-32
    80003e5c:	ec06                	sd	ra,24(sp)
    80003e5e:	e822                	sd	s0,16(sp)
    80003e60:	e426                	sd	s1,8(sp)
    80003e62:	1000                	addi	s0,sp,32
    80003e64:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003e66:	00241517          	auipc	a0,0x241
    80003e6a:	73a50513          	addi	a0,a0,1850 # 802455a0 <bcache>
    80003e6e:	eb5fc0ef          	jal	80000d22 <acquire>
  b->refcnt--;
    80003e72:	40bc                	lw	a5,64(s1)
    80003e74:	37fd                	addiw	a5,a5,-1
    80003e76:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003e78:	00241517          	auipc	a0,0x241
    80003e7c:	72850513          	addi	a0,a0,1832 # 802455a0 <bcache>
    80003e80:	f2bfc0ef          	jal	80000daa <release>
}
    80003e84:	60e2                	ld	ra,24(sp)
    80003e86:	6442                	ld	s0,16(sp)
    80003e88:	64a2                	ld	s1,8(sp)
    80003e8a:	6105                	addi	sp,sp,32
    80003e8c:	8082                	ret

0000000080003e8e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003e8e:	1101                	addi	sp,sp,-32
    80003e90:	ec06                	sd	ra,24(sp)
    80003e92:	e822                	sd	s0,16(sp)
    80003e94:	e426                	sd	s1,8(sp)
    80003e96:	e04a                	sd	s2,0(sp)
    80003e98:	1000                	addi	s0,sp,32
    80003e9a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003e9c:	00d5d79b          	srliw	a5,a1,0xd
    80003ea0:	0024a597          	auipc	a1,0x24a
    80003ea4:	ddc5a583          	lw	a1,-548(a1) # 8024dc7c <sb+0x1c>
    80003ea8:	9dbd                	addw	a1,a1,a5
    80003eaa:	df1ff0ef          	jal	80003c9a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003eae:	0074f713          	andi	a4,s1,7
    80003eb2:	4785                	li	a5,1
    80003eb4:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003eb8:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80003eba:	90d9                	srli	s1,s1,0x36
    80003ebc:	00950733          	add	a4,a0,s1
    80003ec0:	05874703          	lbu	a4,88(a4)
    80003ec4:	00e7f6b3          	and	a3,a5,a4
    80003ec8:	c29d                	beqz	a3,80003eee <bfree+0x60>
    80003eca:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80003ecc:	94aa                	add	s1,s1,a0
    80003ece:	fff7c793          	not	a5,a5
    80003ed2:	8f7d                	and	a4,a4,a5
    80003ed4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003ed8:	076010ef          	jal	80004f4e <log_write>
  brelse(bp);
    80003edc:	854a                	mv	a0,s2
    80003ede:	ec5ff0ef          	jal	80003da2 <brelse>
}
    80003ee2:	60e2                	ld	ra,24(sp)
    80003ee4:	6442                	ld	s0,16(sp)
    80003ee6:	64a2                	ld	s1,8(sp)
    80003ee8:	6902                	ld	s2,0(sp)
    80003eea:	6105                	addi	sp,sp,32
    80003eec:	8082                	ret
    panic("freeing free block");
    80003eee:	00004517          	auipc	a0,0x4
    80003ef2:	6d250513          	addi	a0,a0,1746 # 800085c0 <etext+0x5c0>
    80003ef6:	8f9fc0ef          	jal	800007ee <panic>

0000000080003efa <balloc>:
{
    80003efa:	715d                	addi	sp,sp,-80
    80003efc:	e486                	sd	ra,72(sp)
    80003efe:	e0a2                	sd	s0,64(sp)
    80003f00:	fc26                	sd	s1,56(sp)
    80003f02:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80003f04:	0024a797          	auipc	a5,0x24a
    80003f08:	d607a783          	lw	a5,-672(a5) # 8024dc64 <sb+0x4>
    80003f0c:	0e078863          	beqz	a5,80003ffc <balloc+0x102>
    80003f10:	f84a                	sd	s2,48(sp)
    80003f12:	f44e                	sd	s3,40(sp)
    80003f14:	f052                	sd	s4,32(sp)
    80003f16:	ec56                	sd	s5,24(sp)
    80003f18:	e85a                	sd	s6,16(sp)
    80003f1a:	e45e                	sd	s7,8(sp)
    80003f1c:	e062                	sd	s8,0(sp)
    80003f1e:	8baa                	mv	s7,a0
    80003f20:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003f22:	0024ab17          	auipc	s6,0x24a
    80003f26:	d3eb0b13          	addi	s6,s6,-706 # 8024dc60 <sb>
      m = 1 << (bi % 8);
    80003f2a:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003f2c:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003f2e:	6c09                	lui	s8,0x2
    80003f30:	a09d                	j	80003f96 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003f32:	97ca                	add	a5,a5,s2
    80003f34:	8e55                	or	a2,a2,a3
    80003f36:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003f3a:	854a                	mv	a0,s2
    80003f3c:	012010ef          	jal	80004f4e <log_write>
        brelse(bp);
    80003f40:	854a                	mv	a0,s2
    80003f42:	e61ff0ef          	jal	80003da2 <brelse>
  bp = bread(dev, bno);
    80003f46:	85a6                	mv	a1,s1
    80003f48:	855e                	mv	a0,s7
    80003f4a:	d51ff0ef          	jal	80003c9a <bread>
    80003f4e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003f50:	40000613          	li	a2,1024
    80003f54:	4581                	li	a1,0
    80003f56:	05850513          	addi	a0,a0,88
    80003f5a:	e89fc0ef          	jal	80000de2 <memset>
  log_write(bp);
    80003f5e:	854a                	mv	a0,s2
    80003f60:	7ef000ef          	jal	80004f4e <log_write>
  brelse(bp);
    80003f64:	854a                	mv	a0,s2
    80003f66:	e3dff0ef          	jal	80003da2 <brelse>
}
    80003f6a:	7942                	ld	s2,48(sp)
    80003f6c:	79a2                	ld	s3,40(sp)
    80003f6e:	7a02                	ld	s4,32(sp)
    80003f70:	6ae2                	ld	s5,24(sp)
    80003f72:	6b42                	ld	s6,16(sp)
    80003f74:	6ba2                	ld	s7,8(sp)
    80003f76:	6c02                	ld	s8,0(sp)
}
    80003f78:	8526                	mv	a0,s1
    80003f7a:	60a6                	ld	ra,72(sp)
    80003f7c:	6406                	ld	s0,64(sp)
    80003f7e:	74e2                	ld	s1,56(sp)
    80003f80:	6161                	addi	sp,sp,80
    80003f82:	8082                	ret
    brelse(bp);
    80003f84:	854a                	mv	a0,s2
    80003f86:	e1dff0ef          	jal	80003da2 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80003f8a:	015c0abb          	addw	s5,s8,s5
    80003f8e:	004b2783          	lw	a5,4(s6)
    80003f92:	04fafe63          	bgeu	s5,a5,80003fee <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    80003f96:	41fad79b          	sraiw	a5,s5,0x1f
    80003f9a:	0137d79b          	srliw	a5,a5,0x13
    80003f9e:	015787bb          	addw	a5,a5,s5
    80003fa2:	40d7d79b          	sraiw	a5,a5,0xd
    80003fa6:	01cb2583          	lw	a1,28(s6)
    80003faa:	9dbd                	addw	a1,a1,a5
    80003fac:	855e                	mv	a0,s7
    80003fae:	cedff0ef          	jal	80003c9a <bread>
    80003fb2:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003fb4:	004b2503          	lw	a0,4(s6)
    80003fb8:	84d6                	mv	s1,s5
    80003fba:	4701                	li	a4,0
    80003fbc:	fca4f4e3          	bgeu	s1,a0,80003f84 <balloc+0x8a>
      m = 1 << (bi % 8);
    80003fc0:	00777693          	andi	a3,a4,7
    80003fc4:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003fc8:	41f7579b          	sraiw	a5,a4,0x1f
    80003fcc:	01d7d79b          	srliw	a5,a5,0x1d
    80003fd0:	9fb9                	addw	a5,a5,a4
    80003fd2:	4037d79b          	sraiw	a5,a5,0x3
    80003fd6:	00f90633          	add	a2,s2,a5
    80003fda:	05864603          	lbu	a2,88(a2)
    80003fde:	00c6f5b3          	and	a1,a3,a2
    80003fe2:	d9a1                	beqz	a1,80003f32 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003fe4:	2705                	addiw	a4,a4,1
    80003fe6:	2485                	addiw	s1,s1,1
    80003fe8:	fd471ae3          	bne	a4,s4,80003fbc <balloc+0xc2>
    80003fec:	bf61                	j	80003f84 <balloc+0x8a>
    80003fee:	7942                	ld	s2,48(sp)
    80003ff0:	79a2                	ld	s3,40(sp)
    80003ff2:	7a02                	ld	s4,32(sp)
    80003ff4:	6ae2                	ld	s5,24(sp)
    80003ff6:	6b42                	ld	s6,16(sp)
    80003ff8:	6ba2                	ld	s7,8(sp)
    80003ffa:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80003ffc:	00004517          	auipc	a0,0x4
    80004000:	5dc50513          	addi	a0,a0,1500 # 800085d8 <etext+0x5d8>
    80004004:	d06fc0ef          	jal	8000050a <printk>
  return 0;
    80004008:	4481                	li	s1,0
    8000400a:	b7bd                	j	80003f78 <balloc+0x7e>

000000008000400c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000400c:	7179                	addi	sp,sp,-48
    8000400e:	f406                	sd	ra,40(sp)
    80004010:	f022                	sd	s0,32(sp)
    80004012:	ec26                	sd	s1,24(sp)
    80004014:	e84a                	sd	s2,16(sp)
    80004016:	e44e                	sd	s3,8(sp)
    80004018:	1800                	addi	s0,sp,48
    8000401a:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    8000401c:	47ad                	li	a5,11
    8000401e:	02b7e363          	bltu	a5,a1,80004044 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80004022:	02059793          	slli	a5,a1,0x20
    80004026:	01e7d593          	srli	a1,a5,0x1e
    8000402a:	00b504b3          	add	s1,a0,a1
    8000402e:	0504a903          	lw	s2,80(s1)
    80004032:	06091363          	bnez	s2,80004098 <bmap+0x8c>
      addr = balloc(ip->dev);
    80004036:	4108                	lw	a0,0(a0)
    80004038:	ec3ff0ef          	jal	80003efa <balloc>
    8000403c:	892a                	mv	s2,a0
      if (addr == 0)
    8000403e:	cd29                	beqz	a0,80004098 <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80004040:	c8a8                	sw	a0,80(s1)
    80004042:	a899                	j	80004098 <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80004044:	ff45849b          	addiw	s1,a1,-12

  if (bn < NINDIRECT) {
    80004048:	0ff00793          	li	a5,255
    8000404c:	0697e963          	bltu	a5,s1,800040be <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80004050:	08052903          	lw	s2,128(a0)
    80004054:	00091b63          	bnez	s2,8000406a <bmap+0x5e>
      addr = balloc(ip->dev);
    80004058:	4108                	lw	a0,0(a0)
    8000405a:	ea1ff0ef          	jal	80003efa <balloc>
    8000405e:	892a                	mv	s2,a0
      if (addr == 0)
    80004060:	cd05                	beqz	a0,80004098 <bmap+0x8c>
    80004062:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80004064:	08a9a023          	sw	a0,128(s3)
    80004068:	a011                	j	8000406c <bmap+0x60>
    8000406a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000406c:	85ca                	mv	a1,s2
    8000406e:	0009a503          	lw	a0,0(s3)
    80004072:	c29ff0ef          	jal	80003c9a <bread>
    80004076:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80004078:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    8000407c:	02049713          	slli	a4,s1,0x20
    80004080:	01e75593          	srli	a1,a4,0x1e
    80004084:	00b784b3          	add	s1,a5,a1
    80004088:	0004a903          	lw	s2,0(s1)
    8000408c:	00090e63          	beqz	s2,800040a8 <bmap+0x9c>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80004090:	8552                	mv	a0,s4
    80004092:	d11ff0ef          	jal	80003da2 <brelse>
    return addr;
    80004096:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80004098:	854a                	mv	a0,s2
    8000409a:	70a2                	ld	ra,40(sp)
    8000409c:	7402                	ld	s0,32(sp)
    8000409e:	64e2                	ld	s1,24(sp)
    800040a0:	6942                	ld	s2,16(sp)
    800040a2:	69a2                	ld	s3,8(sp)
    800040a4:	6145                	addi	sp,sp,48
    800040a6:	8082                	ret
      addr = balloc(ip->dev);
    800040a8:	0009a503          	lw	a0,0(s3)
    800040ac:	e4fff0ef          	jal	80003efa <balloc>
    800040b0:	892a                	mv	s2,a0
      if (addr) {
    800040b2:	dd79                	beqz	a0,80004090 <bmap+0x84>
        a[bn] = addr;
    800040b4:	c088                	sw	a0,0(s1)
        log_write(bp);
    800040b6:	8552                	mv	a0,s4
    800040b8:	697000ef          	jal	80004f4e <log_write>
    800040bc:	bfd1                	j	80004090 <bmap+0x84>
    800040be:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800040c0:	00004517          	auipc	a0,0x4
    800040c4:	53050513          	addi	a0,a0,1328 # 800085f0 <etext+0x5f0>
    800040c8:	f26fc0ef          	jal	800007ee <panic>

00000000800040cc <iget>:
{
    800040cc:	7179                	addi	sp,sp,-48
    800040ce:	f406                	sd	ra,40(sp)
    800040d0:	f022                	sd	s0,32(sp)
    800040d2:	ec26                	sd	s1,24(sp)
    800040d4:	e84a                	sd	s2,16(sp)
    800040d6:	e44e                	sd	s3,8(sp)
    800040d8:	e052                	sd	s4,0(sp)
    800040da:	1800                	addi	s0,sp,48
    800040dc:	89aa                	mv	s3,a0
    800040de:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800040e0:	0024a517          	auipc	a0,0x24a
    800040e4:	ba050513          	addi	a0,a0,-1120 # 8024dc80 <itable>
    800040e8:	c3bfc0ef          	jal	80000d22 <acquire>
  empty = 0;
    800040ec:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    800040ee:	0024a497          	auipc	s1,0x24a
    800040f2:	baa48493          	addi	s1,s1,-1110 # 8024dc98 <itable+0x18>
    800040f6:	0024b697          	auipc	a3,0x24b
    800040fa:	63268693          	addi	a3,a3,1586 # 8024f728 <log>
    800040fe:	a039                	j	8000410c <iget+0x40>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80004100:	02090963          	beqz	s2,80004132 <iget+0x66>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80004104:	08848493          	addi	s1,s1,136
    80004108:	02d48863          	beq	s1,a3,80004138 <iget+0x6c>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    8000410c:	449c                	lw	a5,8(s1)
    8000410e:	fef059e3          	blez	a5,80004100 <iget+0x34>
    80004112:	4098                	lw	a4,0(s1)
    80004114:	ff3716e3          	bne	a4,s3,80004100 <iget+0x34>
    80004118:	40d8                	lw	a4,4(s1)
    8000411a:	ff4713e3          	bne	a4,s4,80004100 <iget+0x34>
      ip->ref++;
    8000411e:	2785                	addiw	a5,a5,1
    80004120:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004122:	0024a517          	auipc	a0,0x24a
    80004126:	b5e50513          	addi	a0,a0,-1186 # 8024dc80 <itable>
    8000412a:	c81fc0ef          	jal	80000daa <release>
      return ip;
    8000412e:	8926                	mv	s2,s1
    80004130:	a02d                	j	8000415a <iget+0x8e>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80004132:	fbe9                	bnez	a5,80004104 <iget+0x38>
      empty = ip;
    80004134:	8926                	mv	s2,s1
    80004136:	b7f9                	j	80004104 <iget+0x38>
  if (empty == 0)
    80004138:	02090a63          	beqz	s2,8000416c <iget+0xa0>
  ip->dev = dev;
    8000413c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004140:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004144:	4785                	li	a5,1
    80004146:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000414a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000414e:	0024a517          	auipc	a0,0x24a
    80004152:	b3250513          	addi	a0,a0,-1230 # 8024dc80 <itable>
    80004156:	c55fc0ef          	jal	80000daa <release>
}
    8000415a:	854a                	mv	a0,s2
    8000415c:	70a2                	ld	ra,40(sp)
    8000415e:	7402                	ld	s0,32(sp)
    80004160:	64e2                	ld	s1,24(sp)
    80004162:	6942                	ld	s2,16(sp)
    80004164:	69a2                	ld	s3,8(sp)
    80004166:	6a02                	ld	s4,0(sp)
    80004168:	6145                	addi	sp,sp,48
    8000416a:	8082                	ret
    panic("iget: no inodes");
    8000416c:	00004517          	auipc	a0,0x4
    80004170:	49c50513          	addi	a0,a0,1180 # 80008608 <etext+0x608>
    80004174:	e7afc0ef          	jal	800007ee <panic>

0000000080004178 <iinit>:
{
    80004178:	7179                	addi	sp,sp,-48
    8000417a:	f406                	sd	ra,40(sp)
    8000417c:	f022                	sd	s0,32(sp)
    8000417e:	ec26                	sd	s1,24(sp)
    80004180:	e84a                	sd	s2,16(sp)
    80004182:	e44e                	sd	s3,8(sp)
    80004184:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004186:	00004597          	auipc	a1,0x4
    8000418a:	49258593          	addi	a1,a1,1170 # 80008618 <etext+0x618>
    8000418e:	0024a517          	auipc	a0,0x24a
    80004192:	af250513          	addi	a0,a0,-1294 # 8024dc80 <itable>
    80004196:	b13fc0ef          	jal	80000ca8 <initlock>
  for (i = 0; i < NINODE; i++) {
    8000419a:	0024a497          	auipc	s1,0x24a
    8000419e:	b0e48493          	addi	s1,s1,-1266 # 8024dca8 <itable+0x28>
    800041a2:	0024b997          	auipc	s3,0x24b
    800041a6:	59698993          	addi	s3,s3,1430 # 8024f738 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800041aa:	00004917          	auipc	s2,0x4
    800041ae:	47690913          	addi	s2,s2,1142 # 80008620 <etext+0x620>
    800041b2:	85ca                	mv	a1,s2
    800041b4:	8526                	mv	a0,s1
    800041b6:	6cb000ef          	jal	80005080 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800041ba:	08848493          	addi	s1,s1,136
    800041be:	ff349ae3          	bne	s1,s3,800041b2 <iinit+0x3a>
}
    800041c2:	70a2                	ld	ra,40(sp)
    800041c4:	7402                	ld	s0,32(sp)
    800041c6:	64e2                	ld	s1,24(sp)
    800041c8:	6942                	ld	s2,16(sp)
    800041ca:	69a2                	ld	s3,8(sp)
    800041cc:	6145                	addi	sp,sp,48
    800041ce:	8082                	ret

00000000800041d0 <ialloc>:
{
    800041d0:	7139                	addi	sp,sp,-64
    800041d2:	fc06                	sd	ra,56(sp)
    800041d4:	f822                	sd	s0,48(sp)
    800041d6:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800041d8:	0024a717          	auipc	a4,0x24a
    800041dc:	a9472703          	lw	a4,-1388(a4) # 8024dc6c <sb+0xc>
    800041e0:	4785                	li	a5,1
    800041e2:	06e7f063          	bgeu	a5,a4,80004242 <ialloc+0x72>
    800041e6:	f426                	sd	s1,40(sp)
    800041e8:	f04a                	sd	s2,32(sp)
    800041ea:	ec4e                	sd	s3,24(sp)
    800041ec:	e852                	sd	s4,16(sp)
    800041ee:	e456                	sd	s5,8(sp)
    800041f0:	e05a                	sd	s6,0(sp)
    800041f2:	8aaa                	mv	s5,a0
    800041f4:	8b2e                	mv	s6,a1
    800041f6:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800041f8:	0024aa17          	auipc	s4,0x24a
    800041fc:	a68a0a13          	addi	s4,s4,-1432 # 8024dc60 <sb>
    80004200:	00495593          	srli	a1,s2,0x4
    80004204:	018a2783          	lw	a5,24(s4)
    80004208:	9dbd                	addw	a1,a1,a5
    8000420a:	8556                	mv	a0,s5
    8000420c:	a8fff0ef          	jal	80003c9a <bread>
    80004210:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80004212:	05850993          	addi	s3,a0,88
    80004216:	00f97793          	andi	a5,s2,15
    8000421a:	079a                	slli	a5,a5,0x6
    8000421c:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000421e:	00099783          	lh	a5,0(s3)
    80004222:	cb9d                	beqz	a5,80004258 <ialloc+0x88>
    brelse(bp);
    80004224:	b7fff0ef          	jal	80003da2 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80004228:	0905                	addi	s2,s2,1
    8000422a:	00ca2703          	lw	a4,12(s4)
    8000422e:	0009079b          	sext.w	a5,s2
    80004232:	fce7e7e3          	bltu	a5,a4,80004200 <ialloc+0x30>
    80004236:	74a2                	ld	s1,40(sp)
    80004238:	7902                	ld	s2,32(sp)
    8000423a:	69e2                	ld	s3,24(sp)
    8000423c:	6a42                	ld	s4,16(sp)
    8000423e:	6aa2                	ld	s5,8(sp)
    80004240:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80004242:	00004517          	auipc	a0,0x4
    80004246:	3e650513          	addi	a0,a0,998 # 80008628 <etext+0x628>
    8000424a:	ac0fc0ef          	jal	8000050a <printk>
  return 0;
    8000424e:	4501                	li	a0,0
}
    80004250:	70e2                	ld	ra,56(sp)
    80004252:	7442                	ld	s0,48(sp)
    80004254:	6121                	addi	sp,sp,64
    80004256:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004258:	04000613          	li	a2,64
    8000425c:	4581                	li	a1,0
    8000425e:	854e                	mv	a0,s3
    80004260:	b83fc0ef          	jal	80000de2 <memset>
      dip->type = type;
    80004264:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80004268:	8526                	mv	a0,s1
    8000426a:	4e5000ef          	jal	80004f4e <log_write>
      brelse(bp);
    8000426e:	8526                	mv	a0,s1
    80004270:	b33ff0ef          	jal	80003da2 <brelse>
      return iget(dev, inum);
    80004274:	0009059b          	sext.w	a1,s2
    80004278:	8556                	mv	a0,s5
    8000427a:	e53ff0ef          	jal	800040cc <iget>
    8000427e:	74a2                	ld	s1,40(sp)
    80004280:	7902                	ld	s2,32(sp)
    80004282:	69e2                	ld	s3,24(sp)
    80004284:	6a42                	ld	s4,16(sp)
    80004286:	6aa2                	ld	s5,8(sp)
    80004288:	6b02                	ld	s6,0(sp)
    8000428a:	b7d9                	j	80004250 <ialloc+0x80>

000000008000428c <iupdate>:
{
    8000428c:	1101                	addi	sp,sp,-32
    8000428e:	ec06                	sd	ra,24(sp)
    80004290:	e822                	sd	s0,16(sp)
    80004292:	e426                	sd	s1,8(sp)
    80004294:	e04a                	sd	s2,0(sp)
    80004296:	1000                	addi	s0,sp,32
    80004298:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000429a:	415c                	lw	a5,4(a0)
    8000429c:	0047d79b          	srliw	a5,a5,0x4
    800042a0:	0024a597          	auipc	a1,0x24a
    800042a4:	9d85a583          	lw	a1,-1576(a1) # 8024dc78 <sb+0x18>
    800042a8:	9dbd                	addw	a1,a1,a5
    800042aa:	4108                	lw	a0,0(a0)
    800042ac:	9efff0ef          	jal	80003c9a <bread>
    800042b0:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800042b2:	05850793          	addi	a5,a0,88
    800042b6:	40d8                	lw	a4,4(s1)
    800042b8:	8b3d                	andi	a4,a4,15
    800042ba:	071a                	slli	a4,a4,0x6
    800042bc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800042be:	04449703          	lh	a4,68(s1)
    800042c2:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800042c6:	04649703          	lh	a4,70(s1)
    800042ca:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800042ce:	04849703          	lh	a4,72(s1)
    800042d2:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800042d6:	04a49703          	lh	a4,74(s1)
    800042da:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800042de:	44f8                	lw	a4,76(s1)
    800042e0:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800042e2:	03400613          	li	a2,52
    800042e6:	05048593          	addi	a1,s1,80
    800042ea:	00c78513          	addi	a0,a5,12
    800042ee:	b59fc0ef          	jal	80000e46 <memmove>
  log_write(bp);
    800042f2:	854a                	mv	a0,s2
    800042f4:	45b000ef          	jal	80004f4e <log_write>
  brelse(bp);
    800042f8:	854a                	mv	a0,s2
    800042fa:	aa9ff0ef          	jal	80003da2 <brelse>
}
    800042fe:	60e2                	ld	ra,24(sp)
    80004300:	6442                	ld	s0,16(sp)
    80004302:	64a2                	ld	s1,8(sp)
    80004304:	6902                	ld	s2,0(sp)
    80004306:	6105                	addi	sp,sp,32
    80004308:	8082                	ret

000000008000430a <idup>:
{
    8000430a:	1101                	addi	sp,sp,-32
    8000430c:	ec06                	sd	ra,24(sp)
    8000430e:	e822                	sd	s0,16(sp)
    80004310:	e426                	sd	s1,8(sp)
    80004312:	1000                	addi	s0,sp,32
    80004314:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004316:	0024a517          	auipc	a0,0x24a
    8000431a:	96a50513          	addi	a0,a0,-1686 # 8024dc80 <itable>
    8000431e:	a05fc0ef          	jal	80000d22 <acquire>
  ip->ref++;
    80004322:	449c                	lw	a5,8(s1)
    80004324:	2785                	addiw	a5,a5,1
    80004326:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004328:	0024a517          	auipc	a0,0x24a
    8000432c:	95850513          	addi	a0,a0,-1704 # 8024dc80 <itable>
    80004330:	a7bfc0ef          	jal	80000daa <release>
}
    80004334:	8526                	mv	a0,s1
    80004336:	60e2                	ld	ra,24(sp)
    80004338:	6442                	ld	s0,16(sp)
    8000433a:	64a2                	ld	s1,8(sp)
    8000433c:	6105                	addi	sp,sp,32
    8000433e:	8082                	ret

0000000080004340 <ilock>:
{
    80004340:	1101                	addi	sp,sp,-32
    80004342:	ec06                	sd	ra,24(sp)
    80004344:	e822                	sd	s0,16(sp)
    80004346:	e426                	sd	s1,8(sp)
    80004348:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000434a:	cd19                	beqz	a0,80004368 <ilock+0x28>
    8000434c:	84aa                	mv	s1,a0
    8000434e:	451c                	lw	a5,8(a0)
    80004350:	00f05c63          	blez	a5,80004368 <ilock+0x28>
  acquiresleep(&ip->lock);
    80004354:	0541                	addi	a0,a0,16
    80004356:	561000ef          	jal	800050b6 <acquiresleep>
  if (ip->valid == 0) {
    8000435a:	40bc                	lw	a5,64(s1)
    8000435c:	cf89                	beqz	a5,80004376 <ilock+0x36>
}
    8000435e:	60e2                	ld	ra,24(sp)
    80004360:	6442                	ld	s0,16(sp)
    80004362:	64a2                	ld	s1,8(sp)
    80004364:	6105                	addi	sp,sp,32
    80004366:	8082                	ret
    80004368:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000436a:	00004517          	auipc	a0,0x4
    8000436e:	2d650513          	addi	a0,a0,726 # 80008640 <etext+0x640>
    80004372:	c7cfc0ef          	jal	800007ee <panic>
    80004376:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004378:	40dc                	lw	a5,4(s1)
    8000437a:	0047d79b          	srliw	a5,a5,0x4
    8000437e:	0024a597          	auipc	a1,0x24a
    80004382:	8fa5a583          	lw	a1,-1798(a1) # 8024dc78 <sb+0x18>
    80004386:	9dbd                	addw	a1,a1,a5
    80004388:	4088                	lw	a0,0(s1)
    8000438a:	911ff0ef          	jal	80003c9a <bread>
    8000438e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80004390:	05850593          	addi	a1,a0,88
    80004394:	40dc                	lw	a5,4(s1)
    80004396:	8bbd                	andi	a5,a5,15
    80004398:	079a                	slli	a5,a5,0x6
    8000439a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000439c:	00059783          	lh	a5,0(a1)
    800043a0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800043a4:	00259783          	lh	a5,2(a1)
    800043a8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800043ac:	00459783          	lh	a5,4(a1)
    800043b0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800043b4:	00659783          	lh	a5,6(a1)
    800043b8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800043bc:	459c                	lw	a5,8(a1)
    800043be:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800043c0:	03400613          	li	a2,52
    800043c4:	05b1                	addi	a1,a1,12
    800043c6:	05048513          	addi	a0,s1,80
    800043ca:	a7dfc0ef          	jal	80000e46 <memmove>
    brelse(bp);
    800043ce:	854a                	mv	a0,s2
    800043d0:	9d3ff0ef          	jal	80003da2 <brelse>
    ip->valid = 1;
    800043d4:	4785                	li	a5,1
    800043d6:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800043d8:	04449783          	lh	a5,68(s1)
    800043dc:	c399                	beqz	a5,800043e2 <ilock+0xa2>
    800043de:	6902                	ld	s2,0(sp)
    800043e0:	bfbd                	j	8000435e <ilock+0x1e>
      panic("ilock: no type");
    800043e2:	00004517          	auipc	a0,0x4
    800043e6:	26650513          	addi	a0,a0,614 # 80008648 <etext+0x648>
    800043ea:	c04fc0ef          	jal	800007ee <panic>

00000000800043ee <iunlock>:
{
    800043ee:	1101                	addi	sp,sp,-32
    800043f0:	ec06                	sd	ra,24(sp)
    800043f2:	e822                	sd	s0,16(sp)
    800043f4:	e426                	sd	s1,8(sp)
    800043f6:	e04a                	sd	s2,0(sp)
    800043f8:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800043fa:	c505                	beqz	a0,80004422 <iunlock+0x34>
    800043fc:	84aa                	mv	s1,a0
    800043fe:	01050913          	addi	s2,a0,16
    80004402:	854a                	mv	a0,s2
    80004404:	53f000ef          	jal	80005142 <holdingsleep>
    80004408:	cd09                	beqz	a0,80004422 <iunlock+0x34>
    8000440a:	449c                	lw	a5,8(s1)
    8000440c:	00f05b63          	blez	a5,80004422 <iunlock+0x34>
  releasesleep(&ip->lock);
    80004410:	854a                	mv	a0,s2
    80004412:	4f9000ef          	jal	8000510a <releasesleep>
}
    80004416:	60e2                	ld	ra,24(sp)
    80004418:	6442                	ld	s0,16(sp)
    8000441a:	64a2                	ld	s1,8(sp)
    8000441c:	6902                	ld	s2,0(sp)
    8000441e:	6105                	addi	sp,sp,32
    80004420:	8082                	ret
    panic("iunlock");
    80004422:	00004517          	auipc	a0,0x4
    80004426:	23650513          	addi	a0,a0,566 # 80008658 <etext+0x658>
    8000442a:	bc4fc0ef          	jal	800007ee <panic>

000000008000442e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000442e:	7179                	addi	sp,sp,-48
    80004430:	f406                	sd	ra,40(sp)
    80004432:	f022                	sd	s0,32(sp)
    80004434:	ec26                	sd	s1,24(sp)
    80004436:	e84a                	sd	s2,16(sp)
    80004438:	e44e                	sd	s3,8(sp)
    8000443a:	1800                	addi	s0,sp,48
    8000443c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000443e:	05050493          	addi	s1,a0,80
    80004442:	08050913          	addi	s2,a0,128
    80004446:	a021                	j	8000444e <itrunc+0x20>
    80004448:	0491                	addi	s1,s1,4
    8000444a:	01248b63          	beq	s1,s2,80004460 <itrunc+0x32>
    if (ip->addrs[i]) {
    8000444e:	408c                	lw	a1,0(s1)
    80004450:	dde5                	beqz	a1,80004448 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004452:	0009a503          	lw	a0,0(s3)
    80004456:	a39ff0ef          	jal	80003e8e <bfree>
      ip->addrs[i] = 0;
    8000445a:	0004a023          	sw	zero,0(s1)
    8000445e:	b7ed                	j	80004448 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80004460:	0809a583          	lw	a1,128(s3)
    80004464:	ed89                	bnez	a1,8000447e <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004466:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000446a:	854e                	mv	a0,s3
    8000446c:	e21ff0ef          	jal	8000428c <iupdate>
}
    80004470:	70a2                	ld	ra,40(sp)
    80004472:	7402                	ld	s0,32(sp)
    80004474:	64e2                	ld	s1,24(sp)
    80004476:	6942                	ld	s2,16(sp)
    80004478:	69a2                	ld	s3,8(sp)
    8000447a:	6145                	addi	sp,sp,48
    8000447c:	8082                	ret
    8000447e:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004480:	0009a503          	lw	a0,0(s3)
    80004484:	817ff0ef          	jal	80003c9a <bread>
    80004488:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    8000448a:	05850493          	addi	s1,a0,88
    8000448e:	45850913          	addi	s2,a0,1112
    80004492:	a021                	j	8000449a <itrunc+0x6c>
    80004494:	0491                	addi	s1,s1,4
    80004496:	01248963          	beq	s1,s2,800044a8 <itrunc+0x7a>
      if (a[j])
    8000449a:	408c                	lw	a1,0(s1)
    8000449c:	dde5                	beqz	a1,80004494 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000449e:	0009a503          	lw	a0,0(s3)
    800044a2:	9edff0ef          	jal	80003e8e <bfree>
    800044a6:	b7fd                	j	80004494 <itrunc+0x66>
    brelse(bp);
    800044a8:	8552                	mv	a0,s4
    800044aa:	8f9ff0ef          	jal	80003da2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800044ae:	0809a583          	lw	a1,128(s3)
    800044b2:	0009a503          	lw	a0,0(s3)
    800044b6:	9d9ff0ef          	jal	80003e8e <bfree>
    ip->addrs[NDIRECT] = 0;
    800044ba:	0809a023          	sw	zero,128(s3)
    800044be:	6a02                	ld	s4,0(sp)
    800044c0:	b75d                	j	80004466 <itrunc+0x38>

00000000800044c2 <iput>:
{
    800044c2:	7179                	addi	sp,sp,-48
    800044c4:	f406                	sd	ra,40(sp)
    800044c6:	f022                	sd	s0,32(sp)
    800044c8:	ec26                	sd	s1,24(sp)
    800044ca:	1800                	addi	s0,sp,48
    800044cc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800044ce:	00249517          	auipc	a0,0x249
    800044d2:	7b250513          	addi	a0,a0,1970 # 8024dc80 <itable>
    800044d6:	84dfc0ef          	jal	80000d22 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800044da:	449c                	lw	a5,8(s1)
    800044dc:	4705                	li	a4,1
    800044de:	00e78f63          	beq	a5,a4,800044fc <iput+0x3a>
  ip->ref--;
    800044e2:	37fd                	addiw	a5,a5,-1
    800044e4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800044e6:	00249517          	auipc	a0,0x249
    800044ea:	79a50513          	addi	a0,a0,1946 # 8024dc80 <itable>
    800044ee:	8bdfc0ef          	jal	80000daa <release>
}
    800044f2:	70a2                	ld	ra,40(sp)
    800044f4:	7402                	ld	s0,32(sp)
    800044f6:	64e2                	ld	s1,24(sp)
    800044f8:	6145                	addi	sp,sp,48
    800044fa:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    800044fc:	40b8                	lw	a4,64(s1)
    800044fe:	d375                	beqz	a4,800044e2 <iput+0x20>
    80004500:	e84a                	sd	s2,16(sp)
    80004502:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80004504:	0004aa03          	lw	s4,0(s1)
    80004508:	0044a903          	lw	s2,4(s1)
  if (last) {
    8000450c:	04a49703          	lh	a4,74(s1)
    80004510:	ef35                	bnez	a4,8000458c <iput+0xca>
    80004512:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80004514:	01048993          	addi	s3,s1,16
    80004518:	854e                	mv	a0,s3
    8000451a:	39d000ef          	jal	800050b6 <acquiresleep>
    release(&itable.lock);
    8000451e:	00249517          	auipc	a0,0x249
    80004522:	76250513          	addi	a0,a0,1890 # 8024dc80 <itable>
    80004526:	885fc0ef          	jal	80000daa <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    8000452a:	8526                	mv	a0,s1
    8000452c:	f03ff0ef          	jal	8000442e <itrunc>
    ip->valid = 0;
    80004530:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004534:	854e                	mv	a0,s3
    80004536:	3d5000ef          	jal	8000510a <releasesleep>
    acquire(&itable.lock);
    8000453a:	00249517          	auipc	a0,0x249
    8000453e:	74650513          	addi	a0,a0,1862 # 8024dc80 <itable>
    80004542:	fe0fc0ef          	jal	80000d22 <acquire>
  ip->ref--;
    80004546:	449c                	lw	a5,8(s1)
    80004548:	37fd                	addiw	a5,a5,-1
    8000454a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000454c:	00249517          	auipc	a0,0x249
    80004550:	73450513          	addi	a0,a0,1844 # 8024dc80 <itable>
    80004554:	857fc0ef          	jal	80000daa <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80004558:	0049579b          	srliw	a5,s2,0x4
    8000455c:	00249597          	auipc	a1,0x249
    80004560:	71c5a583          	lw	a1,1820(a1) # 8024dc78 <sb+0x18>
    80004564:	9dbd                	addw	a1,a1,a5
    80004566:	8552                	mv	a0,s4
    80004568:	f32ff0ef          	jal	80003c9a <bread>
    8000456c:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000456e:	00f97913          	andi	s2,s2,15
  dip->type = 0;
    80004572:	091a                	slli	s2,s2,0x6
    80004574:	992a                	add	s2,s2,a0
    80004576:	04091c23          	sh	zero,88(s2)
  log_write(bp);
    8000457a:	1d5000ef          	jal	80004f4e <log_write>
  brelse(bp);
    8000457e:	8526                	mv	a0,s1
    80004580:	823ff0ef          	jal	80003da2 <brelse>
}
    80004584:	6942                	ld	s2,16(sp)
    80004586:	69a2                	ld	s3,8(sp)
    80004588:	6a02                	ld	s4,0(sp)
    8000458a:	b7a5                	j	800044f2 <iput+0x30>
    8000458c:	6942                	ld	s2,16(sp)
    8000458e:	6a02                	ld	s4,0(sp)
    80004590:	bf89                	j	800044e2 <iput+0x20>

0000000080004592 <iunlockput>:
{
    80004592:	1101                	addi	sp,sp,-32
    80004594:	ec06                	sd	ra,24(sp)
    80004596:	e822                	sd	s0,16(sp)
    80004598:	e426                	sd	s1,8(sp)
    8000459a:	1000                	addi	s0,sp,32
    8000459c:	84aa                	mv	s1,a0
  iunlock(ip);
    8000459e:	e51ff0ef          	jal	800043ee <iunlock>
  iput(ip);
    800045a2:	8526                	mv	a0,s1
    800045a4:	f1fff0ef          	jal	800044c2 <iput>
}
    800045a8:	60e2                	ld	ra,24(sp)
    800045aa:	6442                	ld	s0,16(sp)
    800045ac:	64a2                	ld	s1,8(sp)
    800045ae:	6105                	addi	sp,sp,32
    800045b0:	8082                	ret

00000000800045b2 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800045b2:	00249717          	auipc	a4,0x249
    800045b6:	6ba72703          	lw	a4,1722(a4) # 8024dc6c <sb+0xc>
    800045ba:	4785                	li	a5,1
    800045bc:	0ae7fe63          	bgeu	a5,a4,80004678 <ireclaim+0xc6>
{
    800045c0:	7139                	addi	sp,sp,-64
    800045c2:	fc06                	sd	ra,56(sp)
    800045c4:	f822                	sd	s0,48(sp)
    800045c6:	f426                	sd	s1,40(sp)
    800045c8:	f04a                	sd	s2,32(sp)
    800045ca:	ec4e                	sd	s3,24(sp)
    800045cc:	e852                	sd	s4,16(sp)
    800045ce:	e456                	sd	s5,8(sp)
    800045d0:	e05a                	sd	s6,0(sp)
    800045d2:	0080                	addi	s0,sp,64
    800045d4:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800045d6:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800045d8:	00249a17          	auipc	s4,0x249
    800045dc:	688a0a13          	addi	s4,s4,1672 # 8024dc60 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800045e0:	00004b17          	auipc	s6,0x4
    800045e4:	080b0b13          	addi	s6,s6,128 # 80008660 <etext+0x660>
    800045e8:	a099                	j	8000462e <ireclaim+0x7c>
    800045ea:	85ce                	mv	a1,s3
    800045ec:	855a                	mv	a0,s6
    800045ee:	f1dfb0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    800045f2:	85ce                	mv	a1,s3
    800045f4:	8556                	mv	a0,s5
    800045f6:	ad7ff0ef          	jal	800040cc <iget>
    800045fa:	89aa                	mv	s3,a0
    brelse(bp);
    800045fc:	854a                	mv	a0,s2
    800045fe:	fa4ff0ef          	jal	80003da2 <brelse>
    if (ip) {
    80004602:	00098f63          	beqz	s3,80004620 <ireclaim+0x6e>
      begin_op();
    80004606:	79c000ef          	jal	80004da2 <begin_op>
      ilock(ip);
    8000460a:	854e                	mv	a0,s3
    8000460c:	d35ff0ef          	jal	80004340 <ilock>
      iunlock(ip);
    80004610:	854e                	mv	a0,s3
    80004612:	dddff0ef          	jal	800043ee <iunlock>
      iput(ip);
    80004616:	854e                	mv	a0,s3
    80004618:	eabff0ef          	jal	800044c2 <iput>
      end_op();
    8000461c:	00d000ef          	jal	80004e28 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80004620:	0485                	addi	s1,s1,1
    80004622:	00ca2703          	lw	a4,12(s4)
    80004626:	0004879b          	sext.w	a5,s1
    8000462a:	02e7fd63          	bgeu	a5,a4,80004664 <ireclaim+0xb2>
    8000462e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80004632:	0044d593          	srli	a1,s1,0x4
    80004636:	018a2783          	lw	a5,24(s4)
    8000463a:	9dbd                	addw	a1,a1,a5
    8000463c:	8556                	mv	a0,s5
    8000463e:	e5cff0ef          	jal	80003c9a <bread>
    80004642:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80004644:	05850793          	addi	a5,a0,88
    80004648:	00f9f713          	andi	a4,s3,15
    8000464c:	071a                	slli	a4,a4,0x6
    8000464e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80004650:	00079703          	lh	a4,0(a5)
    80004654:	c701                	beqz	a4,8000465c <ireclaim+0xaa>
    80004656:	00679783          	lh	a5,6(a5)
    8000465a:	dbc1                	beqz	a5,800045ea <ireclaim+0x38>
    brelse(bp);
    8000465c:	854a                	mv	a0,s2
    8000465e:	f44ff0ef          	jal	80003da2 <brelse>
    if (ip) {
    80004662:	bf7d                	j	80004620 <ireclaim+0x6e>
}
    80004664:	70e2                	ld	ra,56(sp)
    80004666:	7442                	ld	s0,48(sp)
    80004668:	74a2                	ld	s1,40(sp)
    8000466a:	7902                	ld	s2,32(sp)
    8000466c:	69e2                	ld	s3,24(sp)
    8000466e:	6a42                	ld	s4,16(sp)
    80004670:	6aa2                	ld	s5,8(sp)
    80004672:	6b02                	ld	s6,0(sp)
    80004674:	6121                	addi	sp,sp,64
    80004676:	8082                	ret
    80004678:	8082                	ret

000000008000467a <fsinit>:
{
    8000467a:	7179                	addi	sp,sp,-48
    8000467c:	f406                	sd	ra,40(sp)
    8000467e:	f022                	sd	s0,32(sp)
    80004680:	ec26                	sd	s1,24(sp)
    80004682:	e84a                	sd	s2,16(sp)
    80004684:	e44e                	sd	s3,8(sp)
    80004686:	1800                	addi	s0,sp,48
    80004688:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000468a:	4585                	li	a1,1
    8000468c:	e0eff0ef          	jal	80003c9a <bread>
    80004690:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004692:	00249997          	auipc	s3,0x249
    80004696:	5ce98993          	addi	s3,s3,1486 # 8024dc60 <sb>
    8000469a:	02000613          	li	a2,32
    8000469e:	05850593          	addi	a1,a0,88
    800046a2:	854e                	mv	a0,s3
    800046a4:	fa2fc0ef          	jal	80000e46 <memmove>
  brelse(bp);
    800046a8:	8526                	mv	a0,s1
    800046aa:	ef8ff0ef          	jal	80003da2 <brelse>
  if (sb.magic != FSMAGIC)
    800046ae:	0009a703          	lw	a4,0(s3)
    800046b2:	102037b7          	lui	a5,0x10203
    800046b6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800046ba:	02f71363          	bne	a4,a5,800046e0 <fsinit+0x66>
  initlog(dev, &sb);
    800046be:	00249597          	auipc	a1,0x249
    800046c2:	5a258593          	addi	a1,a1,1442 # 8024dc60 <sb>
    800046c6:	854a                	mv	a0,s2
    800046c8:	65c000ef          	jal	80004d24 <initlog>
  ireclaim(dev);
    800046cc:	854a                	mv	a0,s2
    800046ce:	ee5ff0ef          	jal	800045b2 <ireclaim>
}
    800046d2:	70a2                	ld	ra,40(sp)
    800046d4:	7402                	ld	s0,32(sp)
    800046d6:	64e2                	ld	s1,24(sp)
    800046d8:	6942                	ld	s2,16(sp)
    800046da:	69a2                	ld	s3,8(sp)
    800046dc:	6145                	addi	sp,sp,48
    800046de:	8082                	ret
    panic("invalid file system");
    800046e0:	00004517          	auipc	a0,0x4
    800046e4:	fa050513          	addi	a0,a0,-96 # 80008680 <etext+0x680>
    800046e8:	906fc0ef          	jal	800007ee <panic>

00000000800046ec <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800046ec:	1141                	addi	sp,sp,-16
    800046ee:	e406                	sd	ra,8(sp)
    800046f0:	e022                	sd	s0,0(sp)
    800046f2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800046f4:	411c                	lw	a5,0(a0)
    800046f6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800046f8:	415c                	lw	a5,4(a0)
    800046fa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800046fc:	04451783          	lh	a5,68(a0)
    80004700:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004704:	04a51783          	lh	a5,74(a0)
    80004708:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000470c:	04c56783          	lwu	a5,76(a0)
    80004710:	e99c                	sd	a5,16(a1)
}
    80004712:	60a2                	ld	ra,8(sp)
    80004714:	6402                	ld	s0,0(sp)
    80004716:	0141                	addi	sp,sp,16
    80004718:	8082                	ret

000000008000471a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000471a:	457c                	lw	a5,76(a0)
    8000471c:	0ed7e663          	bltu	a5,a3,80004808 <readi+0xee>
{
    80004720:	7159                	addi	sp,sp,-112
    80004722:	f486                	sd	ra,104(sp)
    80004724:	f0a2                	sd	s0,96(sp)
    80004726:	eca6                	sd	s1,88(sp)
    80004728:	e0d2                	sd	s4,64(sp)
    8000472a:	fc56                	sd	s5,56(sp)
    8000472c:	f85a                	sd	s6,48(sp)
    8000472e:	f45e                	sd	s7,40(sp)
    80004730:	1880                	addi	s0,sp,112
    80004732:	8b2a                	mv	s6,a0
    80004734:	8bae                	mv	s7,a1
    80004736:	8a32                	mv	s4,a2
    80004738:	84b6                	mv	s1,a3
    8000473a:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000473c:	9f35                	addw	a4,a4,a3
    return 0;
    8000473e:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80004740:	0ad76b63          	bltu	a4,a3,800047f6 <readi+0xdc>
    80004744:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80004746:	00e7f463          	bgeu	a5,a4,8000474e <readi+0x34>
    n = ip->size - off;
    8000474a:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000474e:	080a8b63          	beqz	s5,800047e4 <readi+0xca>
    80004752:	e8ca                	sd	s2,80(sp)
    80004754:	f062                	sd	s8,32(sp)
    80004756:	ec66                	sd	s9,24(sp)
    80004758:	e86a                	sd	s10,16(sp)
    8000475a:	e46e                	sd	s11,8(sp)
    8000475c:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    8000475e:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004762:	5c7d                	li	s8,-1
    80004764:	a80d                	j	80004796 <readi+0x7c>
    80004766:	020d1d93          	slli	s11,s10,0x20
    8000476a:	020ddd93          	srli	s11,s11,0x20
    8000476e:	05890613          	addi	a2,s2,88
    80004772:	86ee                	mv	a3,s11
    80004774:	963e                	add	a2,a2,a5
    80004776:	85d2                	mv	a1,s4
    80004778:	855e                	mv	a0,s7
    8000477a:	d2cfe0ef          	jal	80002ca6 <either_copyout>
    8000477e:	05850363          	beq	a0,s8,800047c4 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004782:	854a                	mv	a0,s2
    80004784:	e1eff0ef          	jal	80003da2 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004788:	013d09bb          	addw	s3,s10,s3
    8000478c:	009d04bb          	addw	s1,s10,s1
    80004790:	9a6e                	add	s4,s4,s11
    80004792:	0559f363          	bgeu	s3,s5,800047d8 <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80004796:	00a4d59b          	srliw	a1,s1,0xa
    8000479a:	855a                	mv	a0,s6
    8000479c:	871ff0ef          	jal	8000400c <bmap>
    800047a0:	85aa                	mv	a1,a0
    if (addr == 0)
    800047a2:	c139                	beqz	a0,800047e8 <readi+0xce>
    bp = bread(ip->dev, addr);
    800047a4:	000b2503          	lw	a0,0(s6)
    800047a8:	cf2ff0ef          	jal	80003c9a <bread>
    800047ac:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800047ae:	3ff4f793          	andi	a5,s1,1023
    800047b2:	40fc873b          	subw	a4,s9,a5
    800047b6:	413a86bb          	subw	a3,s5,s3
    800047ba:	8d3a                	mv	s10,a4
    800047bc:	fae6f5e3          	bgeu	a3,a4,80004766 <readi+0x4c>
    800047c0:	8d36                	mv	s10,a3
    800047c2:	b755                	j	80004766 <readi+0x4c>
      brelse(bp);
    800047c4:	854a                	mv	a0,s2
    800047c6:	ddcff0ef          	jal	80003da2 <brelse>
      tot = -1;
    800047ca:	59fd                	li	s3,-1
      break;
    800047cc:	6946                	ld	s2,80(sp)
    800047ce:	7c02                	ld	s8,32(sp)
    800047d0:	6ce2                	ld	s9,24(sp)
    800047d2:	6d42                	ld	s10,16(sp)
    800047d4:	6da2                	ld	s11,8(sp)
    800047d6:	a831                	j	800047f2 <readi+0xd8>
    800047d8:	6946                	ld	s2,80(sp)
    800047da:	7c02                	ld	s8,32(sp)
    800047dc:	6ce2                	ld	s9,24(sp)
    800047de:	6d42                	ld	s10,16(sp)
    800047e0:	6da2                	ld	s11,8(sp)
    800047e2:	a801                	j	800047f2 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800047e4:	89d6                	mv	s3,s5
    800047e6:	a031                	j	800047f2 <readi+0xd8>
    800047e8:	6946                	ld	s2,80(sp)
    800047ea:	7c02                	ld	s8,32(sp)
    800047ec:	6ce2                	ld	s9,24(sp)
    800047ee:	6d42                	ld	s10,16(sp)
    800047f0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800047f2:	854e                	mv	a0,s3
    800047f4:	69a6                	ld	s3,72(sp)
}
    800047f6:	70a6                	ld	ra,104(sp)
    800047f8:	7406                	ld	s0,96(sp)
    800047fa:	64e6                	ld	s1,88(sp)
    800047fc:	6a06                	ld	s4,64(sp)
    800047fe:	7ae2                	ld	s5,56(sp)
    80004800:	7b42                	ld	s6,48(sp)
    80004802:	7ba2                	ld	s7,40(sp)
    80004804:	6165                	addi	sp,sp,112
    80004806:	8082                	ret
    return 0;
    80004808:	4501                	li	a0,0
}
    8000480a:	8082                	ret

000000008000480c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000480c:	457c                	lw	a5,76(a0)
    8000480e:	0ed7ee63          	bltu	a5,a3,8000490a <writei+0xfe>
{
    80004812:	7159                	addi	sp,sp,-112
    80004814:	f486                	sd	ra,104(sp)
    80004816:	f0a2                	sd	s0,96(sp)
    80004818:	e8ca                	sd	s2,80(sp)
    8000481a:	e0d2                	sd	s4,64(sp)
    8000481c:	fc56                	sd	s5,56(sp)
    8000481e:	f85a                	sd	s6,48(sp)
    80004820:	f45e                	sd	s7,40(sp)
    80004822:	1880                	addi	s0,sp,112
    80004824:	8aaa                	mv	s5,a0
    80004826:	8bae                	mv	s7,a1
    80004828:	8a32                	mv	s4,a2
    8000482a:	8936                	mv	s2,a3
    8000482c:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    8000482e:	00e687bb          	addw	a5,a3,a4
    80004832:	0cd7ee63          	bltu	a5,a3,8000490e <writei+0x102>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80004836:	00043737          	lui	a4,0x43
    8000483a:	0cf76c63          	bltu	a4,a5,80004912 <writei+0x106>
    8000483e:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004840:	0a0b0d63          	beqz	s6,800048fa <writei+0xee>
    80004844:	eca6                	sd	s1,88(sp)
    80004846:	f062                	sd	s8,32(sp)
    80004848:	ec66                	sd	s9,24(sp)
    8000484a:	e86a                	sd	s10,16(sp)
    8000484c:	e46e                	sd	s11,8(sp)
    8000484e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80004850:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004854:	5c7d                	li	s8,-1
    80004856:	a825                	j	8000488e <writei+0x82>
    80004858:	020d1d93          	slli	s11,s10,0x20
    8000485c:	020ddd93          	srli	s11,s11,0x20
    80004860:	05848513          	addi	a0,s1,88
    80004864:	86ee                	mv	a3,s11
    80004866:	8652                	mv	a2,s4
    80004868:	85de                	mv	a1,s7
    8000486a:	953e                	add	a0,a0,a5
    8000486c:	c86fe0ef          	jal	80002cf2 <either_copyin>
    80004870:	05850663          	beq	a0,s8,800048bc <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80004874:	8526                	mv	a0,s1
    80004876:	6d8000ef          	jal	80004f4e <log_write>
    brelse(bp);
    8000487a:	8526                	mv	a0,s1
    8000487c:	d26ff0ef          	jal	80003da2 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004880:	013d09bb          	addw	s3,s10,s3
    80004884:	012d093b          	addw	s2,s10,s2
    80004888:	9a6e                	add	s4,s4,s11
    8000488a:	0369ff63          	bgeu	s3,s6,800048c8 <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    8000488e:	00a9559b          	srliw	a1,s2,0xa
    80004892:	8556                	mv	a0,s5
    80004894:	f78ff0ef          	jal	8000400c <bmap>
    80004898:	85aa                	mv	a1,a0
    if (addr == 0)
    8000489a:	c51d                	beqz	a0,800048c8 <writei+0xbc>
    bp = bread(ip->dev, addr);
    8000489c:	000aa503          	lw	a0,0(s5)
    800048a0:	bfaff0ef          	jal	80003c9a <bread>
    800048a4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800048a6:	3ff97793          	andi	a5,s2,1023
    800048aa:	40fc873b          	subw	a4,s9,a5
    800048ae:	413b06bb          	subw	a3,s6,s3
    800048b2:	8d3a                	mv	s10,a4
    800048b4:	fae6f2e3          	bgeu	a3,a4,80004858 <writei+0x4c>
    800048b8:	8d36                	mv	s10,a3
    800048ba:	bf79                	j	80004858 <writei+0x4c>
      log_write(bp);
    800048bc:	8526                	mv	a0,s1
    800048be:	690000ef          	jal	80004f4e <log_write>
      brelse(bp);
    800048c2:	8526                	mv	a0,s1
    800048c4:	cdeff0ef          	jal	80003da2 <brelse>
  }

  if (off > ip->size)
    800048c8:	04caa783          	lw	a5,76(s5)
    800048cc:	0327f963          	bgeu	a5,s2,800048fe <writei+0xf2>
    ip->size = off;
    800048d0:	052aa623          	sw	s2,76(s5)
    800048d4:	64e6                	ld	s1,88(sp)
    800048d6:	7c02                	ld	s8,32(sp)
    800048d8:	6ce2                	ld	s9,24(sp)
    800048da:	6d42                	ld	s10,16(sp)
    800048dc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800048de:	8556                	mv	a0,s5
    800048e0:	9adff0ef          	jal	8000428c <iupdate>

  return tot;
    800048e4:	854e                	mv	a0,s3
    800048e6:	69a6                	ld	s3,72(sp)
}
    800048e8:	70a6                	ld	ra,104(sp)
    800048ea:	7406                	ld	s0,96(sp)
    800048ec:	6946                	ld	s2,80(sp)
    800048ee:	6a06                	ld	s4,64(sp)
    800048f0:	7ae2                	ld	s5,56(sp)
    800048f2:	7b42                	ld	s6,48(sp)
    800048f4:	7ba2                	ld	s7,40(sp)
    800048f6:	6165                	addi	sp,sp,112
    800048f8:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800048fa:	89da                	mv	s3,s6
    800048fc:	b7cd                	j	800048de <writei+0xd2>
    800048fe:	64e6                	ld	s1,88(sp)
    80004900:	7c02                	ld	s8,32(sp)
    80004902:	6ce2                	ld	s9,24(sp)
    80004904:	6d42                	ld	s10,16(sp)
    80004906:	6da2                	ld	s11,8(sp)
    80004908:	bfd9                	j	800048de <writei+0xd2>
    return -1;
    8000490a:	557d                	li	a0,-1
}
    8000490c:	8082                	ret
    return -1;
    8000490e:	557d                	li	a0,-1
    80004910:	bfe1                	j	800048e8 <writei+0xdc>
    return -1;
    80004912:	557d                	li	a0,-1
    80004914:	bfd1                	j	800048e8 <writei+0xdc>

0000000080004916 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004916:	1141                	addi	sp,sp,-16
    80004918:	e406                	sd	ra,8(sp)
    8000491a:	e022                	sd	s0,0(sp)
    8000491c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000491e:	4639                	li	a2,14
    80004920:	d9afc0ef          	jal	80000eba <strncmp>
}
    80004924:	60a2                	ld	ra,8(sp)
    80004926:	6402                	ld	s0,0(sp)
    80004928:	0141                	addi	sp,sp,16
    8000492a:	8082                	ret

000000008000492c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000492c:	711d                	addi	sp,sp,-96
    8000492e:	ec86                	sd	ra,88(sp)
    80004930:	e8a2                	sd	s0,80(sp)
    80004932:	e4a6                	sd	s1,72(sp)
    80004934:	e0ca                	sd	s2,64(sp)
    80004936:	fc4e                	sd	s3,56(sp)
    80004938:	f852                	sd	s4,48(sp)
    8000493a:	f456                	sd	s5,40(sp)
    8000493c:	f05a                	sd	s6,32(sp)
    8000493e:	ec5e                	sd	s7,24(sp)
    80004940:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80004942:	04451703          	lh	a4,68(a0)
    80004946:	4785                	li	a5,1
    80004948:	00f71f63          	bne	a4,a5,80004966 <dirlookup+0x3a>
    8000494c:	892a                	mv	s2,a0
    8000494e:	8aae                	mv	s5,a1
    80004950:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004952:	457c                	lw	a5,76(a0)
    80004954:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004956:	fa040a13          	addi	s4,s0,-96
    8000495a:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    8000495c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004960:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004962:	e39d                	bnez	a5,80004988 <dirlookup+0x5c>
    80004964:	a8b9                	j	800049c2 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80004966:	00004517          	auipc	a0,0x4
    8000496a:	d3250513          	addi	a0,a0,-718 # 80008698 <etext+0x698>
    8000496e:	e81fb0ef          	jal	800007ee <panic>
      panic("dirlookup read");
    80004972:	00004517          	auipc	a0,0x4
    80004976:	d3e50513          	addi	a0,a0,-706 # 800086b0 <etext+0x6b0>
    8000497a:	e75fb0ef          	jal	800007ee <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000497e:	24c1                	addiw	s1,s1,16
    80004980:	04c92783          	lw	a5,76(s2)
    80004984:	02f4fe63          	bgeu	s1,a5,800049c0 <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004988:	874e                	mv	a4,s3
    8000498a:	86a6                	mv	a3,s1
    8000498c:	8652                	mv	a2,s4
    8000498e:	4581                	li	a1,0
    80004990:	854a                	mv	a0,s2
    80004992:	d89ff0ef          	jal	8000471a <readi>
    80004996:	fd351ee3          	bne	a0,s3,80004972 <dirlookup+0x46>
    if (de.inum == 0)
    8000499a:	fa045783          	lhu	a5,-96(s0)
    8000499e:	d3e5                	beqz	a5,8000497e <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    800049a0:	85da                	mv	a1,s6
    800049a2:	8556                	mv	a0,s5
    800049a4:	f73ff0ef          	jal	80004916 <namecmp>
    800049a8:	f979                	bnez	a0,8000497e <dirlookup+0x52>
      if (poff)
    800049aa:	000b8463          	beqz	s7,800049b2 <dirlookup+0x86>
        *poff = off;
    800049ae:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800049b2:	fa045583          	lhu	a1,-96(s0)
    800049b6:	00092503          	lw	a0,0(s2)
    800049ba:	f12ff0ef          	jal	800040cc <iget>
    800049be:	a011                	j	800049c2 <dirlookup+0x96>
  return 0;
    800049c0:	4501                	li	a0,0
}
    800049c2:	60e6                	ld	ra,88(sp)
    800049c4:	6446                	ld	s0,80(sp)
    800049c6:	64a6                	ld	s1,72(sp)
    800049c8:	6906                	ld	s2,64(sp)
    800049ca:	79e2                	ld	s3,56(sp)
    800049cc:	7a42                	ld	s4,48(sp)
    800049ce:	7aa2                	ld	s5,40(sp)
    800049d0:	7b02                	ld	s6,32(sp)
    800049d2:	6be2                	ld	s7,24(sp)
    800049d4:	6125                	addi	sp,sp,96
    800049d6:	8082                	ret

00000000800049d8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800049d8:	711d                	addi	sp,sp,-96
    800049da:	ec86                	sd	ra,88(sp)
    800049dc:	e8a2                	sd	s0,80(sp)
    800049de:	e4a6                	sd	s1,72(sp)
    800049e0:	e0ca                	sd	s2,64(sp)
    800049e2:	fc4e                	sd	s3,56(sp)
    800049e4:	f852                	sd	s4,48(sp)
    800049e6:	f456                	sd	s5,40(sp)
    800049e8:	f05a                	sd	s6,32(sp)
    800049ea:	ec5e                	sd	s7,24(sp)
    800049ec:	e862                	sd	s8,16(sp)
    800049ee:	e466                	sd	s9,8(sp)
    800049f0:	e06a                	sd	s10,0(sp)
    800049f2:	1080                	addi	s0,sp,96
    800049f4:	84aa                	mv	s1,a0
    800049f6:	8b2e                	mv	s6,a1
    800049f8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800049fa:	00054703          	lbu	a4,0(a0)
    800049fe:	02f00793          	li	a5,47
    80004a02:	00f70f63          	beq	a4,a5,80004a20 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004a06:	df0fd0ef          	jal	80001ff6 <myproc>
    80004a0a:	17853503          	ld	a0,376(a0)
    80004a0e:	8fdff0ef          	jal	8000430a <idup>
    80004a12:	8a2a                	mv	s4,a0
  while (*path == '/')
    80004a14:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    80004a18:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004a1a:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80004a1c:	4b85                	li	s7,1
    80004a1e:	a07d                	j	80004acc <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    80004a20:	4585                	li	a1,1
    80004a22:	852e                	mv	a0,a1
    80004a24:	ea8ff0ef          	jal	800040cc <iget>
    80004a28:	8a2a                	mv	s4,a0
    80004a2a:	b7ed                	j	80004a14 <namex+0x3c>
      iunlockput(ip);
    80004a2c:	8552                	mv	a0,s4
    80004a2e:	b65ff0ef          	jal	80004592 <iunlockput>
      return 0;
    80004a32:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80004a34:	8552                	mv	a0,s4
    80004a36:	60e6                	ld	ra,88(sp)
    80004a38:	6446                	ld	s0,80(sp)
    80004a3a:	64a6                	ld	s1,72(sp)
    80004a3c:	6906                	ld	s2,64(sp)
    80004a3e:	79e2                	ld	s3,56(sp)
    80004a40:	7a42                	ld	s4,48(sp)
    80004a42:	7aa2                	ld	s5,40(sp)
    80004a44:	7b02                	ld	s6,32(sp)
    80004a46:	6be2                	ld	s7,24(sp)
    80004a48:	6c42                	ld	s8,16(sp)
    80004a4a:	6ca2                	ld	s9,8(sp)
    80004a4c:	6d02                	ld	s10,0(sp)
    80004a4e:	6125                	addi	sp,sp,96
    80004a50:	8082                	ret
      iunlockput(ip);
    80004a52:	8552                	mv	a0,s4
    80004a54:	b3fff0ef          	jal	80004592 <iunlockput>
      return 0;
    80004a58:	4a01                	li	s4,0
    80004a5a:	bfe9                	j	80004a34 <namex+0x5c>
      iunlock(ip);
    80004a5c:	8552                	mv	a0,s4
    80004a5e:	991ff0ef          	jal	800043ee <iunlock>
      return ip;
    80004a62:	bfc9                	j	80004a34 <namex+0x5c>
      iunlockput(ip);
    80004a64:	8552                	mv	a0,s4
    80004a66:	b2dff0ef          	jal	80004592 <iunlockput>
      return 0;
    80004a6a:	8a4e                	mv	s4,s3
    80004a6c:	b7e1                	j	80004a34 <namex+0x5c>
  len = path - s;
    80004a6e:	40998633          	sub	a2,s3,s1
    80004a72:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80004a76:	09ac5363          	bge	s8,s10,80004afc <namex+0x124>
    memmove(name, s, DIRSIZ);
    80004a7a:	8666                	mv	a2,s9
    80004a7c:	85a6                	mv	a1,s1
    80004a7e:	8556                	mv	a0,s5
    80004a80:	bc6fc0ef          	jal	80000e46 <memmove>
    80004a84:	84ce                	mv	s1,s3
  while (*path == '/')
    80004a86:	0004c783          	lbu	a5,0(s1)
    80004a8a:	01279763          	bne	a5,s2,80004a98 <namex+0xc0>
    path++;
    80004a8e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004a90:	0004c783          	lbu	a5,0(s1)
    80004a94:	ff278de3          	beq	a5,s2,80004a8e <namex+0xb6>
    ilock(ip);
    80004a98:	8552                	mv	a0,s4
    80004a9a:	8a7ff0ef          	jal	80004340 <ilock>
    if (ip->type != T_DIR) {
    80004a9e:	044a1783          	lh	a5,68(s4)
    80004aa2:	f97795e3          	bne	a5,s7,80004a2c <namex+0x54>
    if (ip->nlink == 0) {
    80004aa6:	04aa1783          	lh	a5,74(s4)
    80004aaa:	d7c5                	beqz	a5,80004a52 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80004aac:	000b0563          	beqz	s6,80004ab6 <namex+0xde>
    80004ab0:	0004c783          	lbu	a5,0(s1)
    80004ab4:	d7c5                	beqz	a5,80004a5c <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80004ab6:	4601                	li	a2,0
    80004ab8:	85d6                	mv	a1,s5
    80004aba:	8552                	mv	a0,s4
    80004abc:	e71ff0ef          	jal	8000492c <dirlookup>
    80004ac0:	89aa                	mv	s3,a0
    80004ac2:	d14d                	beqz	a0,80004a64 <namex+0x8c>
    iunlockput(ip);
    80004ac4:	8552                	mv	a0,s4
    80004ac6:	acdff0ef          	jal	80004592 <iunlockput>
    ip = next;
    80004aca:	8a4e                	mv	s4,s3
  while (*path == '/')
    80004acc:	0004c783          	lbu	a5,0(s1)
    80004ad0:	01279763          	bne	a5,s2,80004ade <namex+0x106>
    path++;
    80004ad4:	0485                	addi	s1,s1,1
  while (*path == '/')
    80004ad6:	0004c783          	lbu	a5,0(s1)
    80004ada:	ff278de3          	beq	a5,s2,80004ad4 <namex+0xfc>
  if (*path == 0)
    80004ade:	cb8d                	beqz	a5,80004b10 <namex+0x138>
  while (*path != '/' && *path != 0)
    80004ae0:	0004c783          	lbu	a5,0(s1)
    80004ae4:	89a6                	mv	s3,s1
  len = path - s;
    80004ae6:	4d01                	li	s10,0
    80004ae8:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    80004aea:	01278963          	beq	a5,s2,80004afc <namex+0x124>
    80004aee:	d3c1                	beqz	a5,80004a6e <namex+0x96>
    path++;
    80004af0:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    80004af2:	0009c783          	lbu	a5,0(s3)
    80004af6:	ff279ce3          	bne	a5,s2,80004aee <namex+0x116>
    80004afa:	bf95                	j	80004a6e <namex+0x96>
    memmove(name, s, len);
    80004afc:	2601                	sext.w	a2,a2
    80004afe:	85a6                	mv	a1,s1
    80004b00:	8556                	mv	a0,s5
    80004b02:	b44fc0ef          	jal	80000e46 <memmove>
    name[len] = 0;
    80004b06:	9d56                	add	s10,s10,s5
    80004b08:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdae698>
    80004b0c:	84ce                	mv	s1,s3
    80004b0e:	bfa5                	j	80004a86 <namex+0xae>
  if (nameiparent) {
    80004b10:	f20b02e3          	beqz	s6,80004a34 <namex+0x5c>
    iput(ip);
    80004b14:	8552                	mv	a0,s4
    80004b16:	9adff0ef          	jal	800044c2 <iput>
    return 0;
    80004b1a:	4a01                	li	s4,0
    80004b1c:	bf21                	j	80004a34 <namex+0x5c>

0000000080004b1e <dirlink>:
{
    80004b1e:	715d                	addi	sp,sp,-80
    80004b20:	e486                	sd	ra,72(sp)
    80004b22:	e0a2                	sd	s0,64(sp)
    80004b24:	f84a                	sd	s2,48(sp)
    80004b26:	ec56                	sd	s5,24(sp)
    80004b28:	e85a                	sd	s6,16(sp)
    80004b2a:	0880                	addi	s0,sp,80
    80004b2c:	892a                	mv	s2,a0
    80004b2e:	8aae                	mv	s5,a1
    80004b30:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004b32:	4601                	li	a2,0
    80004b34:	df9ff0ef          	jal	8000492c <dirlookup>
    80004b38:	ed1d                	bnez	a0,80004b76 <dirlink+0x58>
    80004b3a:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004b3c:	04c92483          	lw	s1,76(s2)
    80004b40:	c4b9                	beqz	s1,80004b8e <dirlink+0x70>
    80004b42:	f44e                	sd	s3,40(sp)
    80004b44:	f052                	sd	s4,32(sp)
    80004b46:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b48:	fb040a13          	addi	s4,s0,-80
    80004b4c:	49c1                	li	s3,16
    80004b4e:	874e                	mv	a4,s3
    80004b50:	86a6                	mv	a3,s1
    80004b52:	8652                	mv	a2,s4
    80004b54:	4581                	li	a1,0
    80004b56:	854a                	mv	a0,s2
    80004b58:	bc3ff0ef          	jal	8000471a <readi>
    80004b5c:	03351163          	bne	a0,s3,80004b7e <dirlink+0x60>
    if (de.inum == 0)
    80004b60:	fb045783          	lhu	a5,-80(s0)
    80004b64:	c39d                	beqz	a5,80004b8a <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004b66:	24c1                	addiw	s1,s1,16
    80004b68:	04c92783          	lw	a5,76(s2)
    80004b6c:	fef4e1e3          	bltu	s1,a5,80004b4e <dirlink+0x30>
    80004b70:	79a2                	ld	s3,40(sp)
    80004b72:	7a02                	ld	s4,32(sp)
    80004b74:	a829                	j	80004b8e <dirlink+0x70>
    iput(ip);
    80004b76:	94dff0ef          	jal	800044c2 <iput>
    return -1;
    80004b7a:	557d                	li	a0,-1
    80004b7c:	a83d                	j	80004bba <dirlink+0x9c>
      panic("dirlink read");
    80004b7e:	00004517          	auipc	a0,0x4
    80004b82:	b4250513          	addi	a0,a0,-1214 # 800086c0 <etext+0x6c0>
    80004b86:	c69fb0ef          	jal	800007ee <panic>
    80004b8a:	79a2                	ld	s3,40(sp)
    80004b8c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004b8e:	4639                	li	a2,14
    80004b90:	85d6                	mv	a1,s5
    80004b92:	fb240513          	addi	a0,s0,-78
    80004b96:	b5efc0ef          	jal	80000ef4 <strncpy>
  de.inum = inum;
    80004b9a:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b9e:	4741                	li	a4,16
    80004ba0:	86a6                	mv	a3,s1
    80004ba2:	fb040613          	addi	a2,s0,-80
    80004ba6:	4581                	li	a1,0
    80004ba8:	854a                	mv	a0,s2
    80004baa:	c63ff0ef          	jal	8000480c <writei>
    80004bae:	1541                	addi	a0,a0,-16
    80004bb0:	00a03533          	snez	a0,a0
    80004bb4:	40a0053b          	negw	a0,a0
    80004bb8:	74e2                	ld	s1,56(sp)
}
    80004bba:	60a6                	ld	ra,72(sp)
    80004bbc:	6406                	ld	s0,64(sp)
    80004bbe:	7942                	ld	s2,48(sp)
    80004bc0:	6ae2                	ld	s5,24(sp)
    80004bc2:	6b42                	ld	s6,16(sp)
    80004bc4:	6161                	addi	sp,sp,80
    80004bc6:	8082                	ret

0000000080004bc8 <namei>:

struct inode *
namei(char *path)
{
    80004bc8:	1101                	addi	sp,sp,-32
    80004bca:	ec06                	sd	ra,24(sp)
    80004bcc:	e822                	sd	s0,16(sp)
    80004bce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004bd0:	fe040613          	addi	a2,s0,-32
    80004bd4:	4581                	li	a1,0
    80004bd6:	e03ff0ef          	jal	800049d8 <namex>
}
    80004bda:	60e2                	ld	ra,24(sp)
    80004bdc:	6442                	ld	s0,16(sp)
    80004bde:	6105                	addi	sp,sp,32
    80004be0:	8082                	ret

0000000080004be2 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80004be2:	1141                	addi	sp,sp,-16
    80004be4:	e406                	sd	ra,8(sp)
    80004be6:	e022                	sd	s0,0(sp)
    80004be8:	0800                	addi	s0,sp,16
    80004bea:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004bec:	4585                	li	a1,1
    80004bee:	debff0ef          	jal	800049d8 <namex>
}
    80004bf2:	60a2                	ld	ra,8(sp)
    80004bf4:	6402                	ld	s0,0(sp)
    80004bf6:	0141                	addi	sp,sp,16
    80004bf8:	8082                	ret

0000000080004bfa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004bfa:	1101                	addi	sp,sp,-32
    80004bfc:	ec06                	sd	ra,24(sp)
    80004bfe:	e822                	sd	s0,16(sp)
    80004c00:	e426                	sd	s1,8(sp)
    80004c02:	e04a                	sd	s2,0(sp)
    80004c04:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004c06:	0024b917          	auipc	s2,0x24b
    80004c0a:	b2290913          	addi	s2,s2,-1246 # 8024f728 <log>
    80004c0e:	01892583          	lw	a1,24(s2)
    80004c12:	02492503          	lw	a0,36(s2)
    80004c16:	884ff0ef          	jal	80003c9a <bread>
    80004c1a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80004c1c:	02c92603          	lw	a2,44(s2)
    80004c20:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004c22:	00c05f63          	blez	a2,80004c40 <write_head+0x46>
    80004c26:	0024b717          	auipc	a4,0x24b
    80004c2a:	b3270713          	addi	a4,a4,-1230 # 8024f758 <log+0x30>
    80004c2e:	87aa                	mv	a5,a0
    80004c30:	060a                	slli	a2,a2,0x2
    80004c32:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004c34:	4314                	lw	a3,0(a4)
    80004c36:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004c38:	0711                	addi	a4,a4,4
    80004c3a:	0791                	addi	a5,a5,4
    80004c3c:	fec79ce3          	bne	a5,a2,80004c34 <write_head+0x3a>
  }
  bwrite(buf);
    80004c40:	8526                	mv	a0,s1
    80004c42:	92eff0ef          	jal	80003d70 <bwrite>
  brelse(buf);
    80004c46:	8526                	mv	a0,s1
    80004c48:	95aff0ef          	jal	80003da2 <brelse>
}
    80004c4c:	60e2                	ld	ra,24(sp)
    80004c4e:	6442                	ld	s0,16(sp)
    80004c50:	64a2                	ld	s1,8(sp)
    80004c52:	6902                	ld	s2,0(sp)
    80004c54:	6105                	addi	sp,sp,32
    80004c56:	8082                	ret

0000000080004c58 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004c58:	0024b797          	auipc	a5,0x24b
    80004c5c:	afc7a783          	lw	a5,-1284(a5) # 8024f754 <log+0x2c>
    80004c60:	0cf05163          	blez	a5,80004d22 <install_trans+0xca>
{
    80004c64:	715d                	addi	sp,sp,-80
    80004c66:	e486                	sd	ra,72(sp)
    80004c68:	e0a2                	sd	s0,64(sp)
    80004c6a:	fc26                	sd	s1,56(sp)
    80004c6c:	f84a                	sd	s2,48(sp)
    80004c6e:	f44e                	sd	s3,40(sp)
    80004c70:	f052                	sd	s4,32(sp)
    80004c72:	ec56                	sd	s5,24(sp)
    80004c74:	e85a                	sd	s6,16(sp)
    80004c76:	e45e                	sd	s7,8(sp)
    80004c78:	e062                	sd	s8,0(sp)
    80004c7a:	0880                	addi	s0,sp,80
    80004c7c:	8b2a                	mv	s6,a0
    80004c7e:	0024ba97          	auipc	s5,0x24b
    80004c82:	adaa8a93          	addi	s5,s5,-1318 # 8024f758 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004c86:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004c88:	00004c17          	auipc	s8,0x4
    80004c8c:	a48c0c13          	addi	s8,s8,-1464 # 800086d0 <etext+0x6d0>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80004c90:	0024ba17          	auipc	s4,0x24b
    80004c94:	a98a0a13          	addi	s4,s4,-1384 # 8024f728 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80004c98:	40000b93          	li	s7,1024
    80004c9c:	a025                	j	80004cc4 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004c9e:	000aa603          	lw	a2,0(s5)
    80004ca2:	85ce                	mv	a1,s3
    80004ca4:	8562                	mv	a0,s8
    80004ca6:	865fb0ef          	jal	8000050a <printk>
    80004caa:	a839                	j	80004cc8 <install_trans+0x70>
    brelse(lbuf);
    80004cac:	854a                	mv	a0,s2
    80004cae:	8f4ff0ef          	jal	80003da2 <brelse>
    brelse(dbuf);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	8eeff0ef          	jal	80003da2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004cb8:	2985                	addiw	s3,s3,1
    80004cba:	0a91                	addi	s5,s5,4
    80004cbc:	02ca2783          	lw	a5,44(s4)
    80004cc0:	04f9d563          	bge	s3,a5,80004d0a <install_trans+0xb2>
    if (recovering) {
    80004cc4:	fc0b1de3          	bnez	s6,80004c9e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80004cc8:	018a2583          	lw	a1,24(s4)
    80004ccc:	013585bb          	addw	a1,a1,s3
    80004cd0:	2585                	addiw	a1,a1,1
    80004cd2:	024a2503          	lw	a0,36(s4)
    80004cd6:	fc5fe0ef          	jal	80003c9a <bread>
    80004cda:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80004cdc:	000aa583          	lw	a1,0(s5)
    80004ce0:	024a2503          	lw	a0,36(s4)
    80004ce4:	fb7fe0ef          	jal	80003c9a <bread>
    80004ce8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80004cea:	865e                	mv	a2,s7
    80004cec:	05890593          	addi	a1,s2,88
    80004cf0:	05850513          	addi	a0,a0,88
    80004cf4:	952fc0ef          	jal	80000e46 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80004cf8:	8526                	mv	a0,s1
    80004cfa:	876ff0ef          	jal	80003d70 <bwrite>
    if (recovering == 0)
    80004cfe:	fa0b17e3          	bnez	s6,80004cac <install_trans+0x54>
      bunpin(dbuf);
    80004d02:	8526                	mv	a0,s1
    80004d04:	956ff0ef          	jal	80003e5a <bunpin>
    80004d08:	b755                	j	80004cac <install_trans+0x54>
}
    80004d0a:	60a6                	ld	ra,72(sp)
    80004d0c:	6406                	ld	s0,64(sp)
    80004d0e:	74e2                	ld	s1,56(sp)
    80004d10:	7942                	ld	s2,48(sp)
    80004d12:	79a2                	ld	s3,40(sp)
    80004d14:	7a02                	ld	s4,32(sp)
    80004d16:	6ae2                	ld	s5,24(sp)
    80004d18:	6b42                	ld	s6,16(sp)
    80004d1a:	6ba2                	ld	s7,8(sp)
    80004d1c:	6c02                	ld	s8,0(sp)
    80004d1e:	6161                	addi	sp,sp,80
    80004d20:	8082                	ret
    80004d22:	8082                	ret

0000000080004d24 <initlog>:
{
    80004d24:	7179                	addi	sp,sp,-48
    80004d26:	f406                	sd	ra,40(sp)
    80004d28:	f022                	sd	s0,32(sp)
    80004d2a:	ec26                	sd	s1,24(sp)
    80004d2c:	e84a                	sd	s2,16(sp)
    80004d2e:	e44e                	sd	s3,8(sp)
    80004d30:	1800                	addi	s0,sp,48
    80004d32:	892a                	mv	s2,a0
    80004d34:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004d36:	0024b497          	auipc	s1,0x24b
    80004d3a:	9f248493          	addi	s1,s1,-1550 # 8024f728 <log>
    80004d3e:	00004597          	auipc	a1,0x4
    80004d42:	9b258593          	addi	a1,a1,-1614 # 800086f0 <etext+0x6f0>
    80004d46:	8526                	mv	a0,s1
    80004d48:	f61fb0ef          	jal	80000ca8 <initlock>
  log.start = sb->logstart;
    80004d4c:	0149a583          	lw	a1,20(s3)
    80004d50:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80004d52:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004d56:	854a                	mv	a0,s2
    80004d58:	f43fe0ef          	jal	80003c9a <bread>
  log.lh.n = lh->n;
    80004d5c:	4d30                	lw	a2,88(a0)
    80004d5e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004d60:	00c05f63          	blez	a2,80004d7e <initlog+0x5a>
    80004d64:	87aa                	mv	a5,a0
    80004d66:	0024b717          	auipc	a4,0x24b
    80004d6a:	9f270713          	addi	a4,a4,-1550 # 8024f758 <log+0x30>
    80004d6e:	060a                	slli	a2,a2,0x2
    80004d70:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004d72:	4ff4                	lw	a3,92(a5)
    80004d74:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004d76:	0791                	addi	a5,a5,4
    80004d78:	0711                	addi	a4,a4,4
    80004d7a:	fec79ce3          	bne	a5,a2,80004d72 <initlog+0x4e>
  brelse(buf);
    80004d7e:	824ff0ef          	jal	80003da2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004d82:	4505                	li	a0,1
    80004d84:	ed5ff0ef          	jal	80004c58 <install_trans>
  log.lh.n = 0;
    80004d88:	0024b797          	auipc	a5,0x24b
    80004d8c:	9c07a623          	sw	zero,-1588(a5) # 8024f754 <log+0x2c>
  write_head(); // clear the log
    80004d90:	e6bff0ef          	jal	80004bfa <write_head>
}
    80004d94:	70a2                	ld	ra,40(sp)
    80004d96:	7402                	ld	s0,32(sp)
    80004d98:	64e2                	ld	s1,24(sp)
    80004d9a:	6942                	ld	s2,16(sp)
    80004d9c:	69a2                	ld	s3,8(sp)
    80004d9e:	6145                	addi	sp,sp,48
    80004da0:	8082                	ret

0000000080004da2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004da2:	1101                	addi	sp,sp,-32
    80004da4:	ec06                	sd	ra,24(sp)
    80004da6:	e822                	sd	s0,16(sp)
    80004da8:	e426                	sd	s1,8(sp)
    80004daa:	e04a                	sd	s2,0(sp)
    80004dac:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004dae:	0024b517          	auipc	a0,0x24b
    80004db2:	97a50513          	addi	a0,a0,-1670 # 8024f728 <log>
    80004db6:	f6dfb0ef          	jal	80000d22 <acquire>
  while (1) {
    if (log.committing) {
    80004dba:	0024b497          	auipc	s1,0x24b
    80004dbe:	96e48493          	addi	s1,s1,-1682 # 8024f728 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80004dc2:	4979                	li	s2,30
    80004dc4:	a821                	j	80004ddc <begin_op+0x3a>
      sleep_prepare(&log);
    80004dc6:	8526                	mv	a0,s1
    80004dc8:	98bfd0ef          	jal	80002752 <sleep_prepare>
      release(&log.lock);
    80004dcc:	8526                	mv	a0,s1
    80004dce:	fddfb0ef          	jal	80000daa <release>
      sleep();
    80004dd2:	9bdfd0ef          	jal	8000278e <sleep>
      acquire(&log.lock);
    80004dd6:	8526                	mv	a0,s1
    80004dd8:	f4bfb0ef          	jal	80000d22 <acquire>
    if (log.committing) {
    80004ddc:	509c                	lw	a5,32(s1)
    80004dde:	f7e5                	bnez	a5,80004dc6 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80004de0:	4cd8                	lw	a4,28(s1)
    80004de2:	2705                	addiw	a4,a4,1
    80004de4:	0027179b          	slliw	a5,a4,0x2
    80004de8:	9fb9                	addw	a5,a5,a4
    80004dea:	0017979b          	slliw	a5,a5,0x1
    80004dee:	54d4                	lw	a3,44(s1)
    80004df0:	9fb5                	addw	a5,a5,a3
    80004df2:	00f95e63          	bge	s2,a5,80004e0e <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80004df6:	8526                	mv	a0,s1
    80004df8:	95bfd0ef          	jal	80002752 <sleep_prepare>
      release(&log.lock);
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	fadfb0ef          	jal	80000daa <release>
      sleep();
    80004e02:	98dfd0ef          	jal	8000278e <sleep>
      acquire(&log.lock);
    80004e06:	8526                	mv	a0,s1
    80004e08:	f1bfb0ef          	jal	80000d22 <acquire>
    80004e0c:	bfc1                	j	80004ddc <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80004e0e:	0024b517          	auipc	a0,0x24b
    80004e12:	91a50513          	addi	a0,a0,-1766 # 8024f728 <log>
    80004e16:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80004e18:	f93fb0ef          	jal	80000daa <release>
      break;
    }
  }
}
    80004e1c:	60e2                	ld	ra,24(sp)
    80004e1e:	6442                	ld	s0,16(sp)
    80004e20:	64a2                	ld	s1,8(sp)
    80004e22:	6902                	ld	s2,0(sp)
    80004e24:	6105                	addi	sp,sp,32
    80004e26:	8082                	ret

0000000080004e28 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004e28:	7139                	addi	sp,sp,-64
    80004e2a:	fc06                	sd	ra,56(sp)
    80004e2c:	f822                	sd	s0,48(sp)
    80004e2e:	f426                	sd	s1,40(sp)
    80004e30:	f04a                	sd	s2,32(sp)
    80004e32:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004e34:	0024b497          	auipc	s1,0x24b
    80004e38:	8f448493          	addi	s1,s1,-1804 # 8024f728 <log>
    80004e3c:	8526                	mv	a0,s1
    80004e3e:	ee5fb0ef          	jal	80000d22 <acquire>
  log.outstanding -= 1;
    80004e42:	4cdc                	lw	a5,28(s1)
    80004e44:	37fd                	addiw	a5,a5,-1
    80004e46:	893e                	mv	s2,a5
    80004e48:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80004e4a:	509c                	lw	a5,32(s1)
    80004e4c:	e3b1                	bnez	a5,80004e90 <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    80004e4e:	04091b63          	bnez	s2,80004ea4 <end_op+0x7c>
    do_commit = 1;
    log.committing = 1;
    80004e52:	0024b497          	auipc	s1,0x24b
    80004e56:	8d648493          	addi	s1,s1,-1834 # 8024f728 <log>
    80004e5a:	4785                	li	a5,1
    80004e5c:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004e5e:	8526                	mv	a0,s1
    80004e60:	f4bfb0ef          	jal	80000daa <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004e64:	54dc                	lw	a5,44(s1)
    80004e66:	04f04f63          	bgtz	a5,80004ec4 <end_op+0x9c>
    acquire(&log.lock);
    80004e6a:	0024b497          	auipc	s1,0x24b
    80004e6e:	8be48493          	addi	s1,s1,-1858 # 8024f728 <log>
    80004e72:	8526                	mv	a0,s1
    80004e74:	eaffb0ef          	jal	80000d22 <acquire>
    log.committing = 0;
    80004e78:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80004e7c:	549c                	lw	a5,40(s1)
    80004e7e:	2785                	addiw	a5,a5,1
    80004e80:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80004e82:	8526                	mv	a0,s1
    80004e84:	93bfd0ef          	jal	800027be <wakeup>
    release(&log.lock);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	f21fb0ef          	jal	80000daa <release>
}
    80004e8e:	a02d                	j	80004eb8 <end_op+0x90>
    80004e90:	ec4e                	sd	s3,24(sp)
    80004e92:	e852                	sd	s4,16(sp)
    80004e94:	e456                	sd	s5,8(sp)
    80004e96:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80004e98:	00004517          	auipc	a0,0x4
    80004e9c:	86050513          	addi	a0,a0,-1952 # 800086f8 <etext+0x6f8>
    80004ea0:	94ffb0ef          	jal	800007ee <panic>
    wakeup(&log);
    80004ea4:	0024b497          	auipc	s1,0x24b
    80004ea8:	88448493          	addi	s1,s1,-1916 # 8024f728 <log>
    80004eac:	8526                	mv	a0,s1
    80004eae:	911fd0ef          	jal	800027be <wakeup>
  release(&log.lock);
    80004eb2:	8526                	mv	a0,s1
    80004eb4:	ef7fb0ef          	jal	80000daa <release>
}
    80004eb8:	70e2                	ld	ra,56(sp)
    80004eba:	7442                	ld	s0,48(sp)
    80004ebc:	74a2                	ld	s1,40(sp)
    80004ebe:	7902                	ld	s2,32(sp)
    80004ec0:	6121                	addi	sp,sp,64
    80004ec2:	8082                	ret
    80004ec4:	ec4e                	sd	s3,24(sp)
    80004ec6:	e852                	sd	s4,16(sp)
    80004ec8:	e456                	sd	s5,8(sp)
    80004eca:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ecc:	0024ba97          	auipc	s5,0x24b
    80004ed0:	88ca8a93          	addi	s5,s5,-1908 # 8024f758 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004ed4:	0024ba17          	auipc	s4,0x24b
    80004ed8:	854a0a13          	addi	s4,s4,-1964 # 8024f728 <log>
    memmove(to->data, from->data, BSIZE);
    80004edc:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004ee0:	018a2583          	lw	a1,24(s4)
    80004ee4:	012585bb          	addw	a1,a1,s2
    80004ee8:	2585                	addiw	a1,a1,1
    80004eea:	024a2503          	lw	a0,36(s4)
    80004eee:	dadfe0ef          	jal	80003c9a <bread>
    80004ef2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004ef4:	000aa583          	lw	a1,0(s5)
    80004ef8:	024a2503          	lw	a0,36(s4)
    80004efc:	d9ffe0ef          	jal	80003c9a <bread>
    80004f00:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004f02:	865a                	mv	a2,s6
    80004f04:	05850593          	addi	a1,a0,88
    80004f08:	05848513          	addi	a0,s1,88
    80004f0c:	f3bfb0ef          	jal	80000e46 <memmove>
    bwrite(to); // write the log
    80004f10:	8526                	mv	a0,s1
    80004f12:	e5ffe0ef          	jal	80003d70 <bwrite>
    brelse(from);
    80004f16:	854e                	mv	a0,s3
    80004f18:	e8bfe0ef          	jal	80003da2 <brelse>
    brelse(to);
    80004f1c:	8526                	mv	a0,s1
    80004f1e:	e85fe0ef          	jal	80003da2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004f22:	2905                	addiw	s2,s2,1
    80004f24:	0a91                	addi	s5,s5,4
    80004f26:	02ca2783          	lw	a5,44(s4)
    80004f2a:	faf94be3          	blt	s2,a5,80004ee0 <end_op+0xb8>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80004f2e:	ccdff0ef          	jal	80004bfa <write_head>
    install_trans(0); // Now install writes to home locations
    80004f32:	4501                	li	a0,0
    80004f34:	d25ff0ef          	jal	80004c58 <install_trans>
    log.lh.n = 0;
    80004f38:	0024b797          	auipc	a5,0x24b
    80004f3c:	8007ae23          	sw	zero,-2020(a5) # 8024f754 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004f40:	cbbff0ef          	jal	80004bfa <write_head>
    80004f44:	69e2                	ld	s3,24(sp)
    80004f46:	6a42                	ld	s4,16(sp)
    80004f48:	6aa2                	ld	s5,8(sp)
    80004f4a:	6b02                	ld	s6,0(sp)
    80004f4c:	bf39                	j	80004e6a <end_op+0x42>

0000000080004f4e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004f4e:	1101                	addi	sp,sp,-32
    80004f50:	ec06                	sd	ra,24(sp)
    80004f52:	e822                	sd	s0,16(sp)
    80004f54:	e426                	sd	s1,8(sp)
    80004f56:	e04a                	sd	s2,0(sp)
    80004f58:	1000                	addi	s0,sp,32
    80004f5a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004f5c:	0024a917          	auipc	s2,0x24a
    80004f60:	7cc90913          	addi	s2,s2,1996 # 8024f728 <log>
    80004f64:	854a                	mv	a0,s2
    80004f66:	dbdfb0ef          	jal	80000d22 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004f6a:	02c92603          	lw	a2,44(s2)
    80004f6e:	47f5                	li	a5,29
    80004f70:	04c7cc63          	blt	a5,a2,80004fc8 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004f74:	0024a797          	auipc	a5,0x24a
    80004f78:	7d07a783          	lw	a5,2000(a5) # 8024f744 <log+0x1c>
    80004f7c:	04f05c63          	blez	a5,80004fd4 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004f80:	4781                	li	a5,0
    80004f82:	04c05f63          	blez	a2,80004fe0 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80004f86:	44cc                	lw	a1,12(s1)
    80004f88:	0024a717          	auipc	a4,0x24a
    80004f8c:	7d070713          	addi	a4,a4,2000 # 8024f758 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004f90:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80004f92:	4314                	lw	a3,0(a4)
    80004f94:	04b68663          	beq	a3,a1,80004fe0 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80004f98:	2785                	addiw	a5,a5,1
    80004f9a:	0711                	addi	a4,a4,4
    80004f9c:	fef61be3          	bne	a2,a5,80004f92 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004fa0:	0621                	addi	a2,a2,8
    80004fa2:	060a                	slli	a2,a2,0x2
    80004fa4:	0024a797          	auipc	a5,0x24a
    80004fa8:	78478793          	addi	a5,a5,1924 # 8024f728 <log>
    80004fac:	97b2                	add	a5,a5,a2
    80004fae:	44d8                	lw	a4,12(s1)
    80004fb0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004fb2:	8526                	mv	a0,s1
    80004fb4:	e73fe0ef          	jal	80003e26 <bpin>
    log.lh.n++;
    80004fb8:	0024a717          	auipc	a4,0x24a
    80004fbc:	77070713          	addi	a4,a4,1904 # 8024f728 <log>
    80004fc0:	575c                	lw	a5,44(a4)
    80004fc2:	2785                	addiw	a5,a5,1
    80004fc4:	d75c                	sw	a5,44(a4)
    80004fc6:	a80d                	j	80004ff8 <log_write+0xaa>
    panic("too big a transaction");
    80004fc8:	00003517          	auipc	a0,0x3
    80004fcc:	74050513          	addi	a0,a0,1856 # 80008708 <etext+0x708>
    80004fd0:	81ffb0ef          	jal	800007ee <panic>
    panic("log_write outside of trans");
    80004fd4:	00003517          	auipc	a0,0x3
    80004fd8:	74c50513          	addi	a0,a0,1868 # 80008720 <etext+0x720>
    80004fdc:	813fb0ef          	jal	800007ee <panic>
  log.lh.block[i] = b->blockno;
    80004fe0:	00878693          	addi	a3,a5,8
    80004fe4:	068a                	slli	a3,a3,0x2
    80004fe6:	0024a717          	auipc	a4,0x24a
    80004fea:	74270713          	addi	a4,a4,1858 # 8024f728 <log>
    80004fee:	9736                	add	a4,a4,a3
    80004ff0:	44d4                	lw	a3,12(s1)
    80004ff2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004ff4:	faf60fe3          	beq	a2,a5,80004fb2 <log_write+0x64>
  }
  release(&log.lock);
    80004ff8:	0024a517          	auipc	a0,0x24a
    80004ffc:	73050513          	addi	a0,a0,1840 # 8024f728 <log>
    80005000:	dabfb0ef          	jal	80000daa <release>
}
    80005004:	60e2                	ld	ra,24(sp)
    80005006:	6442                	ld	s0,16(sp)
    80005008:	64a2                	ld	s1,8(sp)
    8000500a:	6902                	ld	s2,0(sp)
    8000500c:	6105                	addi	sp,sp,32
    8000500e:	8082                	ret

0000000080005010 <sys_sync>:

uint64
sys_sync(void)
{
    80005010:	1101                	addi	sp,sp,-32
    80005012:	ec06                	sd	ra,24(sp)
    80005014:	e822                	sd	s0,16(sp)
    80005016:	e426                	sd	s1,8(sp)
    80005018:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000501a:	0024a497          	auipc	s1,0x24a
    8000501e:	70e48493          	addi	s1,s1,1806 # 8024f728 <log>
    80005022:	8526                	mv	a0,s1
    80005024:	cfffb0ef          	jal	80000d22 <acquire>
  if (log.committing || log.outstanding > 0) {
    80005028:	509c                	lw	a5,32(s1)
    8000502a:	e799                	bnez	a5,80005038 <sys_sync+0x28>
    8000502c:	0024a797          	auipc	a5,0x24a
    80005030:	7187a783          	lw	a5,1816(a5) # 8024f744 <log+0x1c>
    80005034:	02f05a63          	blez	a5,80005068 <sys_sync+0x58>
    80005038:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    8000503a:	0024a917          	auipc	s2,0x24a
    8000503e:	71692903          	lw	s2,1814(s2) # 8024f750 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80005042:	0024a497          	auipc	s1,0x24a
    80005046:	6e648493          	addi	s1,s1,1766 # 8024f728 <log>
    8000504a:	8526                	mv	a0,s1
    8000504c:	f06fd0ef          	jal	80002752 <sleep_prepare>
      release(&log.lock);
    80005050:	8526                	mv	a0,s1
    80005052:	d59fb0ef          	jal	80000daa <release>
      sleep();
    80005056:	f38fd0ef          	jal	8000278e <sleep>
      acquire(&log.lock);
    8000505a:	8526                	mv	a0,s1
    8000505c:	cc7fb0ef          	jal	80000d22 <acquire>
    while (log.ncommit < n) {
    80005060:	549c                	lw	a5,40(s1)
    80005062:	fef954e3          	bge	s2,a5,8000504a <sys_sync+0x3a>
    80005066:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80005068:	0024a517          	auipc	a0,0x24a
    8000506c:	6c050513          	addi	a0,a0,1728 # 8024f728 <log>
    80005070:	d3bfb0ef          	jal	80000daa <release>
  return 0;
}
    80005074:	4501                	li	a0,0
    80005076:	60e2                	ld	ra,24(sp)
    80005078:	6442                	ld	s0,16(sp)
    8000507a:	64a2                	ld	s1,8(sp)
    8000507c:	6105                	addi	sp,sp,32
    8000507e:	8082                	ret

0000000080005080 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005080:	1101                	addi	sp,sp,-32
    80005082:	ec06                	sd	ra,24(sp)
    80005084:	e822                	sd	s0,16(sp)
    80005086:	e426                	sd	s1,8(sp)
    80005088:	e04a                	sd	s2,0(sp)
    8000508a:	1000                	addi	s0,sp,32
    8000508c:	84aa                	mv	s1,a0
    8000508e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005090:	00003597          	auipc	a1,0x3
    80005094:	6b058593          	addi	a1,a1,1712 # 80008740 <etext+0x740>
    80005098:	0521                	addi	a0,a0,8
    8000509a:	c0ffb0ef          	jal	80000ca8 <initlock>
  lk->name = name;
    8000509e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800050a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800050a6:	0204a423          	sw	zero,40(s1)
}
    800050aa:	60e2                	ld	ra,24(sp)
    800050ac:	6442                	ld	s0,16(sp)
    800050ae:	64a2                	ld	s1,8(sp)
    800050b0:	6902                	ld	s2,0(sp)
    800050b2:	6105                	addi	sp,sp,32
    800050b4:	8082                	ret

00000000800050b6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800050b6:	1101                	addi	sp,sp,-32
    800050b8:	ec06                	sd	ra,24(sp)
    800050ba:	e822                	sd	s0,16(sp)
    800050bc:	e426                	sd	s1,8(sp)
    800050be:	e04a                	sd	s2,0(sp)
    800050c0:	1000                	addi	s0,sp,32
    800050c2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800050c4:	00850913          	addi	s2,a0,8
    800050c8:	854a                	mv	a0,s2
    800050ca:	c59fb0ef          	jal	80000d22 <acquire>
  while (lk->locked) {
    800050ce:	409c                	lw	a5,0(s1)
    800050d0:	cf91                	beqz	a5,800050ec <acquiresleep+0x36>
    sleep_prepare(lk);
    800050d2:	8526                	mv	a0,s1
    800050d4:	e7efd0ef          	jal	80002752 <sleep_prepare>
    release(&lk->lk);
    800050d8:	854a                	mv	a0,s2
    800050da:	cd1fb0ef          	jal	80000daa <release>
    sleep();
    800050de:	eb0fd0ef          	jal	8000278e <sleep>
    acquire(&lk->lk);
    800050e2:	854a                	mv	a0,s2
    800050e4:	c3ffb0ef          	jal	80000d22 <acquire>
  while (lk->locked) {
    800050e8:	409c                	lw	a5,0(s1)
    800050ea:	f7e5                	bnez	a5,800050d2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800050ec:	4785                	li	a5,1
    800050ee:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800050f0:	f07fc0ef          	jal	80001ff6 <myproc>
    800050f4:	591c                	lw	a5,48(a0)
    800050f6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800050f8:	854a                	mv	a0,s2
    800050fa:	cb1fb0ef          	jal	80000daa <release>
}
    800050fe:	60e2                	ld	ra,24(sp)
    80005100:	6442                	ld	s0,16(sp)
    80005102:	64a2                	ld	s1,8(sp)
    80005104:	6902                	ld	s2,0(sp)
    80005106:	6105                	addi	sp,sp,32
    80005108:	8082                	ret

000000008000510a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000510a:	1101                	addi	sp,sp,-32
    8000510c:	ec06                	sd	ra,24(sp)
    8000510e:	e822                	sd	s0,16(sp)
    80005110:	e426                	sd	s1,8(sp)
    80005112:	e04a                	sd	s2,0(sp)
    80005114:	1000                	addi	s0,sp,32
    80005116:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005118:	00850913          	addi	s2,a0,8
    8000511c:	854a                	mv	a0,s2
    8000511e:	c05fb0ef          	jal	80000d22 <acquire>
  lk->locked = 0;
    80005122:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005126:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000512a:	8526                	mv	a0,s1
    8000512c:	e92fd0ef          	jal	800027be <wakeup>
  release(&lk->lk);
    80005130:	854a                	mv	a0,s2
    80005132:	c79fb0ef          	jal	80000daa <release>
}
    80005136:	60e2                	ld	ra,24(sp)
    80005138:	6442                	ld	s0,16(sp)
    8000513a:	64a2                	ld	s1,8(sp)
    8000513c:	6902                	ld	s2,0(sp)
    8000513e:	6105                	addi	sp,sp,32
    80005140:	8082                	ret

0000000080005142 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005142:	7179                	addi	sp,sp,-48
    80005144:	f406                	sd	ra,40(sp)
    80005146:	f022                	sd	s0,32(sp)
    80005148:	ec26                	sd	s1,24(sp)
    8000514a:	e84a                	sd	s2,16(sp)
    8000514c:	1800                	addi	s0,sp,48
    8000514e:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80005150:	00850913          	addi	s2,a0,8
    80005154:	854a                	mv	a0,s2
    80005156:	bcdfb0ef          	jal	80000d22 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000515a:	409c                	lw	a5,0(s1)
    8000515c:	ef81                	bnez	a5,80005174 <holdingsleep+0x32>
    8000515e:	4481                	li	s1,0
  release(&lk->lk);
    80005160:	854a                	mv	a0,s2
    80005162:	c49fb0ef          	jal	80000daa <release>
  return r;
}
    80005166:	8526                	mv	a0,s1
    80005168:	70a2                	ld	ra,40(sp)
    8000516a:	7402                	ld	s0,32(sp)
    8000516c:	64e2                	ld	s1,24(sp)
    8000516e:	6942                	ld	s2,16(sp)
    80005170:	6145                	addi	sp,sp,48
    80005172:	8082                	ret
    80005174:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80005176:	0284a983          	lw	s3,40(s1)
    8000517a:	e7dfc0ef          	jal	80001ff6 <myproc>
    8000517e:	5904                	lw	s1,48(a0)
    80005180:	413484b3          	sub	s1,s1,s3
    80005184:	0014b493          	seqz	s1,s1
    80005188:	69a2                	ld	s3,8(sp)
    8000518a:	bfd9                	j	80005160 <holdingsleep+0x1e>

000000008000518c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000518c:	1141                	addi	sp,sp,-16
    8000518e:	e406                	sd	ra,8(sp)
    80005190:	e022                	sd	s0,0(sp)
    80005192:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005194:	00003597          	auipc	a1,0x3
    80005198:	5bc58593          	addi	a1,a1,1468 # 80008750 <etext+0x750>
    8000519c:	0024a517          	auipc	a0,0x24a
    800051a0:	6d450513          	addi	a0,a0,1748 # 8024f870 <ftable>
    800051a4:	b05fb0ef          	jal	80000ca8 <initlock>
}
    800051a8:	60a2                	ld	ra,8(sp)
    800051aa:	6402                	ld	s0,0(sp)
    800051ac:	0141                	addi	sp,sp,16
    800051ae:	8082                	ret

00000000800051b0 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800051b0:	1101                	addi	sp,sp,-32
    800051b2:	ec06                	sd	ra,24(sp)
    800051b4:	e822                	sd	s0,16(sp)
    800051b6:	e426                	sd	s1,8(sp)
    800051b8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800051ba:	0024a517          	auipc	a0,0x24a
    800051be:	6b650513          	addi	a0,a0,1718 # 8024f870 <ftable>
    800051c2:	b61fb0ef          	jal	80000d22 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800051c6:	0024a497          	auipc	s1,0x24a
    800051ca:	6c248493          	addi	s1,s1,1730 # 8024f888 <ftable+0x18>
    800051ce:	0024b717          	auipc	a4,0x24b
    800051d2:	65a70713          	addi	a4,a4,1626 # 80250828 <disk>
    if (f->ref == 0) {
    800051d6:	40dc                	lw	a5,4(s1)
    800051d8:	cf89                	beqz	a5,800051f2 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800051da:	02848493          	addi	s1,s1,40
    800051de:	fee49ce3          	bne	s1,a4,800051d6 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800051e2:	0024a517          	auipc	a0,0x24a
    800051e6:	68e50513          	addi	a0,a0,1678 # 8024f870 <ftable>
    800051ea:	bc1fb0ef          	jal	80000daa <release>
  return 0;
    800051ee:	4481                	li	s1,0
    800051f0:	a809                	j	80005202 <filealloc+0x52>
      f->ref = 1;
    800051f2:	4785                	li	a5,1
    800051f4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800051f6:	0024a517          	auipc	a0,0x24a
    800051fa:	67a50513          	addi	a0,a0,1658 # 8024f870 <ftable>
    800051fe:	badfb0ef          	jal	80000daa <release>
}
    80005202:	8526                	mv	a0,s1
    80005204:	60e2                	ld	ra,24(sp)
    80005206:	6442                	ld	s0,16(sp)
    80005208:	64a2                	ld	s1,8(sp)
    8000520a:	6105                	addi	sp,sp,32
    8000520c:	8082                	ret

000000008000520e <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000520e:	1101                	addi	sp,sp,-32
    80005210:	ec06                	sd	ra,24(sp)
    80005212:	e822                	sd	s0,16(sp)
    80005214:	e426                	sd	s1,8(sp)
    80005216:	1000                	addi	s0,sp,32
    80005218:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000521a:	0024a517          	auipc	a0,0x24a
    8000521e:	65650513          	addi	a0,a0,1622 # 8024f870 <ftable>
    80005222:	b01fb0ef          	jal	80000d22 <acquire>
  if (f->ref < 1)
    80005226:	40dc                	lw	a5,4(s1)
    80005228:	02f05063          	blez	a5,80005248 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000522c:	2785                	addiw	a5,a5,1
    8000522e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005230:	0024a517          	auipc	a0,0x24a
    80005234:	64050513          	addi	a0,a0,1600 # 8024f870 <ftable>
    80005238:	b73fb0ef          	jal	80000daa <release>
  return f;
}
    8000523c:	8526                	mv	a0,s1
    8000523e:	60e2                	ld	ra,24(sp)
    80005240:	6442                	ld	s0,16(sp)
    80005242:	64a2                	ld	s1,8(sp)
    80005244:	6105                	addi	sp,sp,32
    80005246:	8082                	ret
    panic("filedup");
    80005248:	00003517          	auipc	a0,0x3
    8000524c:	51050513          	addi	a0,a0,1296 # 80008758 <etext+0x758>
    80005250:	d9efb0ef          	jal	800007ee <panic>

0000000080005254 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005254:	7139                	addi	sp,sp,-64
    80005256:	fc06                	sd	ra,56(sp)
    80005258:	f822                	sd	s0,48(sp)
    8000525a:	f426                	sd	s1,40(sp)
    8000525c:	0080                	addi	s0,sp,64
    8000525e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005260:	0024a517          	auipc	a0,0x24a
    80005264:	61050513          	addi	a0,a0,1552 # 8024f870 <ftable>
    80005268:	abbfb0ef          	jal	80000d22 <acquire>
  if (f->ref < 1)
    8000526c:	40dc                	lw	a5,4(s1)
    8000526e:	04f05863          	blez	a5,800052be <fileclose+0x6a>
    panic("fileclose");
  if (--f->ref > 0) {
    80005272:	37fd                	addiw	a5,a5,-1
    80005274:	c0dc                	sw	a5,4(s1)
    80005276:	04f04e63          	bgtz	a5,800052d2 <fileclose+0x7e>
    8000527a:	f04a                	sd	s2,32(sp)
    8000527c:	ec4e                	sd	s3,24(sp)
    8000527e:	e852                	sd	s4,16(sp)
    80005280:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005282:	0004a903          	lw	s2,0(s1)
    80005286:	0094ca83          	lbu	s5,9(s1)
    8000528a:	0104ba03          	ld	s4,16(s1)
    8000528e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005292:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005296:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000529a:	0024a517          	auipc	a0,0x24a
    8000529e:	5d650513          	addi	a0,a0,1494 # 8024f870 <ftable>
    800052a2:	b09fb0ef          	jal	80000daa <release>

  if (ff.type == FD_PIPE) {
    800052a6:	4785                	li	a5,1
    800052a8:	04f90063          	beq	s2,a5,800052e8 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    800052ac:	3979                	addiw	s2,s2,-2
    800052ae:	4785                	li	a5,1
    800052b0:	0527f563          	bgeu	a5,s2,800052fa <fileclose+0xa6>
    800052b4:	7902                	ld	s2,32(sp)
    800052b6:	69e2                	ld	s3,24(sp)
    800052b8:	6a42                	ld	s4,16(sp)
    800052ba:	6aa2                	ld	s5,8(sp)
    800052bc:	a00d                	j	800052de <fileclose+0x8a>
    800052be:	f04a                	sd	s2,32(sp)
    800052c0:	ec4e                	sd	s3,24(sp)
    800052c2:	e852                	sd	s4,16(sp)
    800052c4:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800052c6:	00003517          	auipc	a0,0x3
    800052ca:	49a50513          	addi	a0,a0,1178 # 80008760 <etext+0x760>
    800052ce:	d20fb0ef          	jal	800007ee <panic>
    release(&ftable.lock);
    800052d2:	0024a517          	auipc	a0,0x24a
    800052d6:	59e50513          	addi	a0,a0,1438 # 8024f870 <ftable>
    800052da:	ad1fb0ef          	jal	80000daa <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800052de:	70e2                	ld	ra,56(sp)
    800052e0:	7442                	ld	s0,48(sp)
    800052e2:	74a2                	ld	s1,40(sp)
    800052e4:	6121                	addi	sp,sp,64
    800052e6:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800052e8:	85d6                	mv	a1,s5
    800052ea:	8552                	mv	a0,s4
    800052ec:	356000ef          	jal	80005642 <pipeclose>
    800052f0:	7902                	ld	s2,32(sp)
    800052f2:	69e2                	ld	s3,24(sp)
    800052f4:	6a42                	ld	s4,16(sp)
    800052f6:	6aa2                	ld	s5,8(sp)
    800052f8:	b7dd                	j	800052de <fileclose+0x8a>
    begin_op();
    800052fa:	aa9ff0ef          	jal	80004da2 <begin_op>
    iput(ff.ip);
    800052fe:	854e                	mv	a0,s3
    80005300:	9c2ff0ef          	jal	800044c2 <iput>
    end_op();
    80005304:	b25ff0ef          	jal	80004e28 <end_op>
    80005308:	7902                	ld	s2,32(sp)
    8000530a:	69e2                	ld	s3,24(sp)
    8000530c:	6a42                	ld	s4,16(sp)
    8000530e:	6aa2                	ld	s5,8(sp)
    80005310:	b7f9                	j	800052de <fileclose+0x8a>

0000000080005312 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005312:	715d                	addi	sp,sp,-80
    80005314:	e486                	sd	ra,72(sp)
    80005316:	e0a2                	sd	s0,64(sp)
    80005318:	fc26                	sd	s1,56(sp)
    8000531a:	f44e                	sd	s3,40(sp)
    8000531c:	0880                	addi	s0,sp,80
    8000531e:	84aa                	mv	s1,a0
    80005320:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005322:	cd5fc0ef          	jal	80001ff6 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80005326:	409c                	lw	a5,0(s1)
    80005328:	37f9                	addiw	a5,a5,-2
    8000532a:	4705                	li	a4,1
    8000532c:	04f76463          	bltu	a4,a5,80005374 <filestat+0x62>
    80005330:	f84a                	sd	s2,48(sp)
    80005332:	f052                	sd	s4,32(sp)
    80005334:	892a                	mv	s2,a0
    ilock(f->ip);
    80005336:	6c88                	ld	a0,24(s1)
    80005338:	808ff0ef          	jal	80004340 <ilock>
    stati(f->ip, &st);
    8000533c:	fb840a13          	addi	s4,s0,-72
    80005340:	85d2                	mv	a1,s4
    80005342:	6c88                	ld	a0,24(s1)
    80005344:	ba8ff0ef          	jal	800046ec <stati>
    iunlock(f->ip);
    80005348:	6c88                	ld	a0,24(s1)
    8000534a:	8a4ff0ef          	jal	800043ee <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    8000534e:	4761                	li	a4,24
    80005350:	86d2                	mv	a3,s4
    80005352:	864e                	mv	a2,s3
    80005354:	07093583          	ld	a1,112(s2)
    80005358:	07893503          	ld	a0,120(s2)
    8000535c:	e40fc0ef          	jal	8000199c <copyout>
    80005360:	41f5551b          	sraiw	a0,a0,0x1f
    80005364:	7942                	ld	s2,48(sp)
    80005366:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005368:	60a6                	ld	ra,72(sp)
    8000536a:	6406                	ld	s0,64(sp)
    8000536c:	74e2                	ld	s1,56(sp)
    8000536e:	79a2                	ld	s3,40(sp)
    80005370:	6161                	addi	sp,sp,80
    80005372:	8082                	ret
  return -1;
    80005374:	557d                	li	a0,-1
    80005376:	bfcd                	j	80005368 <filestat+0x56>

0000000080005378 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005378:	7179                	addi	sp,sp,-48
    8000537a:	f406                	sd	ra,40(sp)
    8000537c:	f022                	sd	s0,32(sp)
    8000537e:	e84a                	sd	s2,16(sp)
    80005380:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80005382:	00854783          	lbu	a5,8(a0)
    80005386:	c3c5                	beqz	a5,80005426 <fileread+0xae>
    80005388:	ec26                	sd	s1,24(sp)
    8000538a:	e44e                	sd	s3,8(sp)
    8000538c:	84aa                	mv	s1,a0
    8000538e:	89ae                	mv	s3,a1
    80005390:	8932                	mv	s2,a2
    80005392:	08064c63          	bltz	a2,8000542a <fileread+0xb2>
    return -1;

  if (f->type == FD_PIPE) {
    80005396:	411c                	lw	a5,0(a0)
    80005398:	4705                	li	a4,1
    8000539a:	04e78363          	beq	a5,a4,800053e0 <fileread+0x68>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000539e:	470d                	li	a4,3
    800053a0:	04e78763          	beq	a5,a4,800053ee <fileread+0x76>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    800053a4:	4709                	li	a4,2
    800053a6:	06e79a63          	bne	a5,a4,8000541a <fileread+0xa2>
    ilock(f->ip);
    800053aa:	6d08                	ld	a0,24(a0)
    800053ac:	f95fe0ef          	jal	80004340 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800053b0:	874a                	mv	a4,s2
    800053b2:	5094                	lw	a3,32(s1)
    800053b4:	864e                	mv	a2,s3
    800053b6:	4585                	li	a1,1
    800053b8:	6c88                	ld	a0,24(s1)
    800053ba:	b60ff0ef          	jal	8000471a <readi>
    800053be:	892a                	mv	s2,a0
    800053c0:	00a05563          	blez	a0,800053ca <fileread+0x52>
      f->off += r;
    800053c4:	509c                	lw	a5,32(s1)
    800053c6:	9fa9                	addw	a5,a5,a0
    800053c8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800053ca:	6c88                	ld	a0,24(s1)
    800053cc:	822ff0ef          	jal	800043ee <iunlock>
    800053d0:	64e2                	ld	s1,24(sp)
    800053d2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800053d4:	854a                	mv	a0,s2
    800053d6:	70a2                	ld	ra,40(sp)
    800053d8:	7402                	ld	s0,32(sp)
    800053da:	6942                	ld	s2,16(sp)
    800053dc:	6145                	addi	sp,sp,48
    800053de:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800053e0:	6908                	ld	a0,16(a0)
    800053e2:	3d4000ef          	jal	800057b6 <piperead>
    800053e6:	892a                	mv	s2,a0
    800053e8:	64e2                	ld	s1,24(sp)
    800053ea:	69a2                	ld	s3,8(sp)
    800053ec:	b7e5                	j	800053d4 <fileread+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800053ee:	02451783          	lh	a5,36(a0)
    800053f2:	03079693          	slli	a3,a5,0x30
    800053f6:	92c1                	srli	a3,a3,0x30
    800053f8:	4725                	li	a4,9
    800053fa:	02d76c63          	bltu	a4,a3,80005432 <fileread+0xba>
    800053fe:	0792                	slli	a5,a5,0x4
    80005400:	0024a717          	auipc	a4,0x24a
    80005404:	3d070713          	addi	a4,a4,976 # 8024f7d0 <devsw>
    80005408:	97ba                	add	a5,a5,a4
    8000540a:	639c                	ld	a5,0(a5)
    8000540c:	c79d                	beqz	a5,8000543a <fileread+0xc2>
    r = devsw[f->major].read(1, addr, n);
    8000540e:	4505                	li	a0,1
    80005410:	9782                	jalr	a5
    80005412:	892a                	mv	s2,a0
    80005414:	64e2                	ld	s1,24(sp)
    80005416:	69a2                	ld	s3,8(sp)
    80005418:	bf75                	j	800053d4 <fileread+0x5c>
    panic("fileread");
    8000541a:	00003517          	auipc	a0,0x3
    8000541e:	35650513          	addi	a0,a0,854 # 80008770 <etext+0x770>
    80005422:	bccfb0ef          	jal	800007ee <panic>
    return -1;
    80005426:	597d                	li	s2,-1
    80005428:	b775                	j	800053d4 <fileread+0x5c>
    8000542a:	597d                	li	s2,-1
    8000542c:	64e2                	ld	s1,24(sp)
    8000542e:	69a2                	ld	s3,8(sp)
    80005430:	b755                	j	800053d4 <fileread+0x5c>
      return -1;
    80005432:	597d                	li	s2,-1
    80005434:	64e2                	ld	s1,24(sp)
    80005436:	69a2                	ld	s3,8(sp)
    80005438:	bf71                	j	800053d4 <fileread+0x5c>
    8000543a:	597d                	li	s2,-1
    8000543c:	64e2                	ld	s1,24(sp)
    8000543e:	69a2                	ld	s3,8(sp)
    80005440:	bf51                	j	800053d4 <fileread+0x5c>

0000000080005442 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    80005442:	00954783          	lbu	a5,9(a0)
    80005446:	10078863          	beqz	a5,80005556 <filewrite+0x114>
{
    8000544a:	711d                	addi	sp,sp,-96
    8000544c:	ec86                	sd	ra,88(sp)
    8000544e:	e8a2                	sd	s0,80(sp)
    80005450:	e0ca                	sd	s2,64(sp)
    80005452:	f456                	sd	s5,40(sp)
    80005454:	f05a                	sd	s6,32(sp)
    80005456:	1080                	addi	s0,sp,96
    80005458:	892a                	mv	s2,a0
    8000545a:	8b2e                	mv	s6,a1
    8000545c:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    8000545e:	0e064e63          	bltz	a2,8000555a <filewrite+0x118>
    return -1;

  if (f->type == FD_PIPE) {
    80005462:	411c                	lw	a5,0(a0)
    80005464:	4705                	li	a4,1
    80005466:	02e78963          	beq	a5,a4,80005498 <filewrite+0x56>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000546a:	470d                	li	a4,3
    8000546c:	02e78a63          	beq	a5,a4,800054a0 <filewrite+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80005470:	4709                	li	a4,2
    80005472:	0ce79663          	bne	a5,a4,8000553e <filewrite+0xfc>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80005476:	0ec05863          	blez	a2,80005566 <filewrite+0x124>
    8000547a:	e4a6                	sd	s1,72(sp)
    8000547c:	fc4e                	sd	s3,56(sp)
    8000547e:	f852                	sd	s4,48(sp)
    80005480:	ec5e                	sd	s7,24(sp)
    80005482:	e862                	sd	s8,16(sp)
    80005484:	e466                	sd	s9,8(sp)
    int i = 0;
    80005486:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80005488:	6b85                	lui	s7,0x1
    8000548a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000548e:	6c85                	lui	s9,0x1
    80005490:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005494:	4c05                	li	s8,1
    80005496:	a8ad                	j	80005510 <filewrite+0xce>
    ret = pipewrite(f->pipe, addr, n);
    80005498:	6908                	ld	a0,16(a0)
    8000549a:	200000ef          	jal	8000569a <pipewrite>
    8000549e:	a849                	j	80005530 <filewrite+0xee>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800054a0:	02451783          	lh	a5,36(a0)
    800054a4:	03079693          	slli	a3,a5,0x30
    800054a8:	92c1                	srli	a3,a3,0x30
    800054aa:	4725                	li	a4,9
    800054ac:	0ad76963          	bltu	a4,a3,8000555e <filewrite+0x11c>
    800054b0:	0792                	slli	a5,a5,0x4
    800054b2:	0024a717          	auipc	a4,0x24a
    800054b6:	31e70713          	addi	a4,a4,798 # 8024f7d0 <devsw>
    800054ba:	97ba                	add	a5,a5,a4
    800054bc:	679c                	ld	a5,8(a5)
    800054be:	c3d5                	beqz	a5,80005562 <filewrite+0x120>
    ret = devsw[f->major].write(1, addr, n);
    800054c0:	4505                	li	a0,1
    800054c2:	9782                	jalr	a5
    800054c4:	a0b5                	j	80005530 <filewrite+0xee>
      if (n1 > max)
    800054c6:	2981                	sext.w	s3,s3
      begin_op();
    800054c8:	8dbff0ef          	jal	80004da2 <begin_op>
      ilock(f->ip);
    800054cc:	01893503          	ld	a0,24(s2)
    800054d0:	e71fe0ef          	jal	80004340 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800054d4:	874e                	mv	a4,s3
    800054d6:	02092683          	lw	a3,32(s2)
    800054da:	016a0633          	add	a2,s4,s6
    800054de:	85e2                	mv	a1,s8
    800054e0:	01893503          	ld	a0,24(s2)
    800054e4:	b28ff0ef          	jal	8000480c <writei>
    800054e8:	84aa                	mv	s1,a0
    800054ea:	00a05763          	blez	a0,800054f8 <filewrite+0xb6>
        f->off += r;
    800054ee:	02092783          	lw	a5,32(s2)
    800054f2:	9fa9                	addw	a5,a5,a0
    800054f4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800054f8:	01893503          	ld	a0,24(s2)
    800054fc:	ef3fe0ef          	jal	800043ee <iunlock>
      end_op();
    80005500:	929ff0ef          	jal	80004e28 <end_op>

      if (r != n1) {
    80005504:	00999d63          	bne	s3,s1,8000551e <filewrite+0xdc>
        // error from writei
        break;
      }
      i += r;
    80005508:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    8000550c:	015a5963          	bge	s4,s5,8000551e <filewrite+0xdc>
      int n1 = n - i;
    80005510:	414a87bb          	subw	a5,s5,s4
    80005514:	89be                	mv	s3,a5
      if (n1 > max)
    80005516:	fafbd8e3          	bge	s7,a5,800054c6 <filewrite+0x84>
    8000551a:	89e6                	mv	s3,s9
    8000551c:	b76d                	j	800054c6 <filewrite+0x84>
    }
    ret = (i == n ? n : -1);
    8000551e:	054a9663          	bne	s5,s4,8000556a <filewrite+0x128>
    80005522:	8556                	mv	a0,s5
    80005524:	64a6                	ld	s1,72(sp)
    80005526:	79e2                	ld	s3,56(sp)
    80005528:	7a42                	ld	s4,48(sp)
    8000552a:	6be2                	ld	s7,24(sp)
    8000552c:	6c42                	ld	s8,16(sp)
    8000552e:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005530:	60e6                	ld	ra,88(sp)
    80005532:	6446                	ld	s0,80(sp)
    80005534:	6906                	ld	s2,64(sp)
    80005536:	7aa2                	ld	s5,40(sp)
    80005538:	7b02                	ld	s6,32(sp)
    8000553a:	6125                	addi	sp,sp,96
    8000553c:	8082                	ret
    8000553e:	e4a6                	sd	s1,72(sp)
    80005540:	fc4e                	sd	s3,56(sp)
    80005542:	f852                	sd	s4,48(sp)
    80005544:	ec5e                	sd	s7,24(sp)
    80005546:	e862                	sd	s8,16(sp)
    80005548:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000554a:	00003517          	auipc	a0,0x3
    8000554e:	23650513          	addi	a0,a0,566 # 80008780 <etext+0x780>
    80005552:	a9cfb0ef          	jal	800007ee <panic>
    return -1;
    80005556:	557d                	li	a0,-1
}
    80005558:	8082                	ret
    return -1;
    8000555a:	557d                	li	a0,-1
    8000555c:	bfd1                	j	80005530 <filewrite+0xee>
      return -1;
    8000555e:	557d                	li	a0,-1
    80005560:	bfc1                	j	80005530 <filewrite+0xee>
    80005562:	557d                	li	a0,-1
    80005564:	b7f1                	j	80005530 <filewrite+0xee>
    ret = (i == n ? n : -1);
    80005566:	8532                	mv	a0,a2
    80005568:	b7e1                	j	80005530 <filewrite+0xee>
    8000556a:	557d                	li	a0,-1
    8000556c:	64a6                	ld	s1,72(sp)
    8000556e:	79e2                	ld	s3,56(sp)
    80005570:	7a42                	ld	s4,48(sp)
    80005572:	6be2                	ld	s7,24(sp)
    80005574:	6c42                	ld	s8,16(sp)
    80005576:	6ca2                	ld	s9,8(sp)
    80005578:	bf65                	j	80005530 <filewrite+0xee>

000000008000557a <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000557a:	7179                	addi	sp,sp,-48
    8000557c:	f406                	sd	ra,40(sp)
    8000557e:	f022                	sd	s0,32(sp)
    80005580:	ec26                	sd	s1,24(sp)
    80005582:	e052                	sd	s4,0(sp)
    80005584:	1800                	addi	s0,sp,48
    80005586:	84aa                	mv	s1,a0
    80005588:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000558a:	0005b023          	sd	zero,0(a1)
    8000558e:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005592:	c1fff0ef          	jal	800051b0 <filealloc>
    80005596:	e088                	sd	a0,0(s1)
    80005598:	c549                	beqz	a0,80005622 <pipealloc+0xa8>
    8000559a:	c17ff0ef          	jal	800051b0 <filealloc>
    8000559e:	00aa3023          	sd	a0,0(s4)
    800055a2:	cd25                	beqz	a0,8000561a <pipealloc+0xa0>
    800055a4:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800055a6:	d8efb0ef          	jal	80000b34 <kalloc>
    800055aa:	892a                	mv	s2,a0
    800055ac:	c12d                	beqz	a0,8000560e <pipealloc+0x94>
    800055ae:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800055b0:	4985                	li	s3,1
    800055b2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800055b6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800055ba:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800055be:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800055c2:	00003597          	auipc	a1,0x3
    800055c6:	e6e58593          	addi	a1,a1,-402 # 80008430 <etext+0x430>
    800055ca:	edefb0ef          	jal	80000ca8 <initlock>
  (*f0)->type = FD_PIPE;
    800055ce:	609c                	ld	a5,0(s1)
    800055d0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800055d4:	609c                	ld	a5,0(s1)
    800055d6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800055da:	609c                	ld	a5,0(s1)
    800055dc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800055e0:	609c                	ld	a5,0(s1)
    800055e2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800055e6:	000a3783          	ld	a5,0(s4)
    800055ea:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800055ee:	000a3783          	ld	a5,0(s4)
    800055f2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800055f6:	000a3783          	ld	a5,0(s4)
    800055fa:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800055fe:	000a3783          	ld	a5,0(s4)
    80005602:	0127b823          	sd	s2,16(a5)
  return 0;
    80005606:	4501                	li	a0,0
    80005608:	6942                	ld	s2,16(sp)
    8000560a:	69a2                	ld	s3,8(sp)
    8000560c:	a01d                	j	80005632 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    8000560e:	6088                	ld	a0,0(s1)
    80005610:	c119                	beqz	a0,80005616 <pipealloc+0x9c>
    80005612:	6942                	ld	s2,16(sp)
    80005614:	a029                	j	8000561e <pipealloc+0xa4>
    80005616:	6942                	ld	s2,16(sp)
    80005618:	a029                	j	80005622 <pipealloc+0xa8>
    8000561a:	6088                	ld	a0,0(s1)
    8000561c:	c10d                	beqz	a0,8000563e <pipealloc+0xc4>
    fileclose(*f0);
    8000561e:	c37ff0ef          	jal	80005254 <fileclose>
  if (*f1)
    80005622:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005626:	557d                	li	a0,-1
  if (*f1)
    80005628:	c789                	beqz	a5,80005632 <pipealloc+0xb8>
    fileclose(*f1);
    8000562a:	853e                	mv	a0,a5
    8000562c:	c29ff0ef          	jal	80005254 <fileclose>
  return -1;
    80005630:	557d                	li	a0,-1
}
    80005632:	70a2                	ld	ra,40(sp)
    80005634:	7402                	ld	s0,32(sp)
    80005636:	64e2                	ld	s1,24(sp)
    80005638:	6a02                	ld	s4,0(sp)
    8000563a:	6145                	addi	sp,sp,48
    8000563c:	8082                	ret
  return -1;
    8000563e:	557d                	li	a0,-1
    80005640:	bfcd                	j	80005632 <pipealloc+0xb8>

0000000080005642 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005642:	1101                	addi	sp,sp,-32
    80005644:	ec06                	sd	ra,24(sp)
    80005646:	e822                	sd	s0,16(sp)
    80005648:	e426                	sd	s1,8(sp)
    8000564a:	e04a                	sd	s2,0(sp)
    8000564c:	1000                	addi	s0,sp,32
    8000564e:	84aa                	mv	s1,a0
    80005650:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005652:	ed0fb0ef          	jal	80000d22 <acquire>
  if (writable) {
    80005656:	02090763          	beqz	s2,80005684 <pipeclose+0x42>
    pi->writeopen = 0;
    8000565a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000565e:	21848513          	addi	a0,s1,536
    80005662:	95cfd0ef          	jal	800027be <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80005666:	2204b783          	ld	a5,544(s1)
    8000566a:	e785                	bnez	a5,80005692 <pipeclose+0x50>
    release(&pi->lock);
    8000566c:	8526                	mv	a0,s1
    8000566e:	f3cfb0ef          	jal	80000daa <release>
    kfree((char *)pi);
    80005672:	8526                	mv	a0,s1
    80005674:	b6cfb0ef          	jal	800009e0 <kfree>
  } else
    release(&pi->lock);
}
    80005678:	60e2                	ld	ra,24(sp)
    8000567a:	6442                	ld	s0,16(sp)
    8000567c:	64a2                	ld	s1,8(sp)
    8000567e:	6902                	ld	s2,0(sp)
    80005680:	6105                	addi	sp,sp,32
    80005682:	8082                	ret
    pi->readopen = 0;
    80005684:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005688:	21c48513          	addi	a0,s1,540
    8000568c:	932fd0ef          	jal	800027be <wakeup>
    80005690:	bfd9                	j	80005666 <pipeclose+0x24>
    release(&pi->lock);
    80005692:	8526                	mv	a0,s1
    80005694:	f16fb0ef          	jal	80000daa <release>
}
    80005698:	b7c5                	j	80005678 <pipeclose+0x36>

000000008000569a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000569a:	7159                	addi	sp,sp,-112
    8000569c:	f486                	sd	ra,104(sp)
    8000569e:	f0a2                	sd	s0,96(sp)
    800056a0:	eca6                	sd	s1,88(sp)
    800056a2:	e8ca                	sd	s2,80(sp)
    800056a4:	e4ce                	sd	s3,72(sp)
    800056a6:	e0d2                	sd	s4,64(sp)
    800056a8:	fc56                	sd	s5,56(sp)
    800056aa:	1880                	addi	s0,sp,112
    800056ac:	84aa                	mv	s1,a0
    800056ae:	8aae                	mv	s5,a1
    800056b0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800056b2:	945fc0ef          	jal	80001ff6 <myproc>
    800056b6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800056b8:	8526                	mv	a0,s1
    800056ba:	e68fb0ef          	jal	80000d22 <acquire>
  while (i < n) {
    800056be:	0f405a63          	blez	s4,800057b2 <pipewrite+0x118>
    800056c2:	f85a                	sd	s6,48(sp)
    800056c4:	f45e                	sd	s7,40(sp)
    800056c6:	f062                	sd	s8,32(sp)
    800056c8:	ec66                	sd	s9,24(sp)
    800056ca:	e86a                	sd	s10,16(sp)
  int i = 0;
    800056cc:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800056ce:	f9f40c13          	addi	s8,s0,-97
    800056d2:	4b85                	li	s7,1
    800056d4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800056d6:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    800056da:	21c48c93          	addi	s9,s1,540
    800056de:	a0a1                	j	80005726 <pipewrite+0x8c>
      release(&pi->lock);
    800056e0:	8526                	mv	a0,s1
    800056e2:	ec8fb0ef          	jal	80000daa <release>
      return -1;
    800056e6:	597d                	li	s2,-1
    800056e8:	7b42                	ld	s6,48(sp)
    800056ea:	7ba2                	ld	s7,40(sp)
    800056ec:	7c02                	ld	s8,32(sp)
    800056ee:	6ce2                	ld	s9,24(sp)
    800056f0:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800056f2:	854a                	mv	a0,s2
    800056f4:	70a6                	ld	ra,104(sp)
    800056f6:	7406                	ld	s0,96(sp)
    800056f8:	64e6                	ld	s1,88(sp)
    800056fa:	6946                	ld	s2,80(sp)
    800056fc:	69a6                	ld	s3,72(sp)
    800056fe:	6a06                	ld	s4,64(sp)
    80005700:	7ae2                	ld	s5,56(sp)
    80005702:	6165                	addi	sp,sp,112
    80005704:	8082                	ret
      wakeup(&pi->nread);
    80005706:	856a                	mv	a0,s10
    80005708:	8b6fd0ef          	jal	800027be <wakeup>
      sleep_prepare(&pi->nwrite);
    8000570c:	8566                	mv	a0,s9
    8000570e:	844fd0ef          	jal	80002752 <sleep_prepare>
      release(&pi->lock);
    80005712:	8526                	mv	a0,s1
    80005714:	e96fb0ef          	jal	80000daa <release>
      sleep();
    80005718:	876fd0ef          	jal	8000278e <sleep>
      acquire(&pi->lock);
    8000571c:	8526                	mv	a0,s1
    8000571e:	e04fb0ef          	jal	80000d22 <acquire>
  while (i < n) {
    80005722:	07495b63          	bge	s2,s4,80005798 <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80005726:	2204a783          	lw	a5,544(s1)
    8000572a:	dbdd                	beqz	a5,800056e0 <pipewrite+0x46>
    8000572c:	854e                	mv	a0,s3
    8000572e:	aa6fd0ef          	jal	800029d4 <killed>
    80005732:	f55d                	bnez	a0,800056e0 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80005734:	2184a783          	lw	a5,536(s1)
    80005738:	21c4a703          	lw	a4,540(s1)
    8000573c:	2007879b          	addiw	a5,a5,512
    80005740:	fcf703e3          	beq	a4,a5,80005706 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80005744:	875e                	mv	a4,s7
    80005746:	015906b3          	add	a3,s2,s5
    8000574a:	8662                	mv	a2,s8
    8000574c:	0709b583          	ld	a1,112(s3)
    80005750:	0789b503          	ld	a0,120(s3)
    80005754:	b4efc0ef          	jal	80001aa2 <copyin>
    80005758:	03650163          	beq	a0,s6,8000577a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000575c:	21c4a783          	lw	a5,540(s1)
    80005760:	0017871b          	addiw	a4,a5,1
    80005764:	20e4ae23          	sw	a4,540(s1)
    80005768:	1ff7f793          	andi	a5,a5,511
    8000576c:	97a6                	add	a5,a5,s1
    8000576e:	f9f44703          	lbu	a4,-97(s0)
    80005772:	00e78c23          	sb	a4,24(a5)
      i++;
    80005776:	2905                	addiw	s2,s2,1
    80005778:	b76d                	j	80005722 <pipewrite+0x88>
        if (i == 0)
    8000577a:	00090863          	beqz	s2,8000578a <pipewrite+0xf0>
    8000577e:	7b42                	ld	s6,48(sp)
    80005780:	7ba2                	ld	s7,40(sp)
    80005782:	7c02                	ld	s8,32(sp)
    80005784:	6ce2                	ld	s9,24(sp)
    80005786:	6d42                	ld	s10,16(sp)
    80005788:	a829                	j	800057a2 <pipewrite+0x108>
          i = -1;
    8000578a:	892a                	mv	s2,a0
        break;
    8000578c:	7b42                	ld	s6,48(sp)
    8000578e:	7ba2                	ld	s7,40(sp)
    80005790:	7c02                	ld	s8,32(sp)
    80005792:	6ce2                	ld	s9,24(sp)
    80005794:	6d42                	ld	s10,16(sp)
    80005796:	a031                	j	800057a2 <pipewrite+0x108>
    80005798:	7b42                	ld	s6,48(sp)
    8000579a:	7ba2                	ld	s7,40(sp)
    8000579c:	7c02                	ld	s8,32(sp)
    8000579e:	6ce2                	ld	s9,24(sp)
    800057a0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800057a2:	21848513          	addi	a0,s1,536
    800057a6:	818fd0ef          	jal	800027be <wakeup>
  release(&pi->lock);
    800057aa:	8526                	mv	a0,s1
    800057ac:	dfefb0ef          	jal	80000daa <release>
  return i;
    800057b0:	b789                	j	800056f2 <pipewrite+0x58>
  int i = 0;
    800057b2:	4901                	li	s2,0
    800057b4:	b7fd                	j	800057a2 <pipewrite+0x108>

00000000800057b6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800057b6:	711d                	addi	sp,sp,-96
    800057b8:	ec86                	sd	ra,88(sp)
    800057ba:	e8a2                	sd	s0,80(sp)
    800057bc:	e4a6                	sd	s1,72(sp)
    800057be:	e0ca                	sd	s2,64(sp)
    800057c0:	fc4e                	sd	s3,56(sp)
    800057c2:	f852                	sd	s4,48(sp)
    800057c4:	f456                	sd	s5,40(sp)
    800057c6:	1080                	addi	s0,sp,96
    800057c8:	84aa                	mv	s1,a0
    800057ca:	89ae                	mv	s3,a1
    800057cc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800057ce:	829fc0ef          	jal	80001ff6 <myproc>
    800057d2:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    800057d4:	8526                	mv	a0,s1
    800057d6:	d4cfb0ef          	jal	80000d22 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800057da:	2184a703          	lw	a4,536(s1)
    800057de:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800057e2:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    800057e6:	02f71e63          	bne	a4,a5,80005822 <piperead+0x6c>
    800057ea:	2244a783          	lw	a5,548(s1)
    800057ee:	c3b9                	beqz	a5,80005834 <piperead+0x7e>
    if (killed(pr)) {
    800057f0:	854a                	mv	a0,s2
    800057f2:	9e2fd0ef          	jal	800029d4 <killed>
    800057f6:	e915                	bnez	a0,8000582a <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    800057f8:	8552                	mv	a0,s4
    800057fa:	f59fc0ef          	jal	80002752 <sleep_prepare>
    release(&pi->lock);
    800057fe:	8526                	mv	a0,s1
    80005800:	daafb0ef          	jal	80000daa <release>
    sleep();
    80005804:	f8bfc0ef          	jal	8000278e <sleep>
    acquire(&pi->lock);
    80005808:	8526                	mv	a0,s1
    8000580a:	d18fb0ef          	jal	80000d22 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000580e:	2184a703          	lw	a4,536(s1)
    80005812:	21c4a783          	lw	a5,540(s1)
    80005816:	fcf70ae3          	beq	a4,a5,800057ea <piperead+0x34>
    8000581a:	f05a                	sd	s6,32(sp)
    8000581c:	ec5e                	sd	s7,24(sp)
    8000581e:	e862                	sd	s8,16(sp)
    80005820:	a829                	j	8000583a <piperead+0x84>
    80005822:	f05a                	sd	s6,32(sp)
    80005824:	ec5e                	sd	s7,24(sp)
    80005826:	e862                	sd	s8,16(sp)
    80005828:	a809                	j	8000583a <piperead+0x84>
      release(&pi->lock);
    8000582a:	8526                	mv	a0,s1
    8000582c:	d7efb0ef          	jal	80000daa <release>
      return -1;
    80005830:	5a7d                	li	s4,-1
    80005832:	a0bd                	j	800058a0 <piperead+0xea>
    80005834:	f05a                	sd	s6,32(sp)
    80005836:	ec5e                	sd	s7,24(sp)
    80005838:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000583a:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    8000583c:	faf40c13          	addi	s8,s0,-81
    80005840:	4b85                	li	s7,1
    80005842:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005844:	05505463          	blez	s5,8000588c <piperead+0xd6>
    if (pi->nread == pi->nwrite)
    80005848:	2184a783          	lw	a5,536(s1)
    8000584c:	21c4a703          	lw	a4,540(s1)
    80005850:	02f70e63          	beq	a4,a5,8000588c <piperead+0xd6>
    ch = pi->data[pi->nread % PIPESIZE];
    80005854:	1ff7f793          	andi	a5,a5,511
    80005858:	97a6                	add	a5,a5,s1
    8000585a:	0187c783          	lbu	a5,24(a5)
    8000585e:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80005862:	875e                	mv	a4,s7
    80005864:	86e2                	mv	a3,s8
    80005866:	864e                	mv	a2,s3
    80005868:	07093583          	ld	a1,112(s2)
    8000586c:	07893503          	ld	a0,120(s2)
    80005870:	92cfc0ef          	jal	8000199c <copyout>
    80005874:	05650063          	beq	a0,s6,800058b4 <piperead+0xfe>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80005878:	2184a783          	lw	a5,536(s1)
    8000587c:	2785                	addiw	a5,a5,1
    8000587e:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005882:	2a05                	addiw	s4,s4,1
    80005884:	0985                	addi	s3,s3,1
    80005886:	fd4a91e3          	bne	s5,s4,80005848 <piperead+0x92>
    8000588a:	8a56                	mv	s4,s5
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    8000588c:	21c48513          	addi	a0,s1,540
    80005890:	f2ffc0ef          	jal	800027be <wakeup>
  release(&pi->lock);
    80005894:	8526                	mv	a0,s1
    80005896:	d14fb0ef          	jal	80000daa <release>
    8000589a:	7b02                	ld	s6,32(sp)
    8000589c:	6be2                	ld	s7,24(sp)
    8000589e:	6c42                	ld	s8,16(sp)
  return i;
}
    800058a0:	8552                	mv	a0,s4
    800058a2:	60e6                	ld	ra,88(sp)
    800058a4:	6446                	ld	s0,80(sp)
    800058a6:	64a6                	ld	s1,72(sp)
    800058a8:	6906                	ld	s2,64(sp)
    800058aa:	79e2                	ld	s3,56(sp)
    800058ac:	7a42                	ld	s4,48(sp)
    800058ae:	7aa2                	ld	s5,40(sp)
    800058b0:	6125                	addi	sp,sp,96
    800058b2:	8082                	ret
      if (i == 0)
    800058b4:	fc0a1ce3          	bnez	s4,8000588c <piperead+0xd6>
        i = -1;
    800058b8:	8a2a                	mv	s4,a0
    800058ba:	bfc9                	j	8000588c <piperead+0xd6>

00000000800058bc <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800058bc:	1141                	addi	sp,sp,-16
    800058be:	e406                	sd	ra,8(sp)
    800058c0:	e022                	sd	s0,0(sp)
    800058c2:	0800                	addi	s0,sp,16
    800058c4:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    800058c6:	0035151b          	slliw	a0,a0,0x3
    800058ca:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    800058cc:	8b89                	andi	a5,a5,2
    800058ce:	c399                	beqz	a5,800058d4 <flags2perm+0x18>
    perm |= PTE_W;
    800058d0:	00456513          	ori	a0,a0,4
  return perm;
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret

00000000800058dc <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800058dc:	de010113          	addi	sp,sp,-544
    800058e0:	20113c23          	sd	ra,536(sp)
    800058e4:	20813823          	sd	s0,528(sp)
    800058e8:	20913423          	sd	s1,520(sp)
    800058ec:	21213023          	sd	s2,512(sp)
    800058f0:	1400                	addi	s0,sp,544
    800058f2:	892a                	mv	s2,a0
    800058f4:	dea43823          	sd	a0,-528(s0)
    800058f8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800058fc:	efafc0ef          	jal	80001ff6 <myproc>
    80005900:	84aa                	mv	s1,a0

  begin_op();
    80005902:	ca0ff0ef          	jal	80004da2 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80005906:	854a                	mv	a0,s2
    80005908:	ac0ff0ef          	jal	80004bc8 <namei>
    8000590c:	cd21                	beqz	a0,80005964 <kexec+0x88>
    8000590e:	fbd2                	sd	s4,496(sp)
    80005910:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005912:	a2ffe0ef          	jal	80004340 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005916:	04000713          	li	a4,64
    8000591a:	4681                	li	a3,0
    8000591c:	e5040613          	addi	a2,s0,-432
    80005920:	4581                	li	a1,0
    80005922:	8552                	mv	a0,s4
    80005924:	df7fe0ef          	jal	8000471a <readi>
    80005928:	04000793          	li	a5,64
    8000592c:	00f51a63          	bne	a0,a5,80005940 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80005930:	e5042703          	lw	a4,-432(s0)
    80005934:	464c47b7          	lui	a5,0x464c4
    80005938:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000593c:	02f70863          	beq	a4,a5,8000596c <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80005940:	8552                	mv	a0,s4
    80005942:	c51fe0ef          	jal	80004592 <iunlockput>
    end_op();
    80005946:	ce2ff0ef          	jal	80004e28 <end_op>
  }
  return -1;
    8000594a:	557d                	li	a0,-1
    8000594c:	7a5e                	ld	s4,496(sp)
}
    8000594e:	21813083          	ld	ra,536(sp)
    80005952:	21013403          	ld	s0,528(sp)
    80005956:	20813483          	ld	s1,520(sp)
    8000595a:	20013903          	ld	s2,512(sp)
    8000595e:	22010113          	addi	sp,sp,544
    80005962:	8082                	ret
    end_op();
    80005964:	cc4ff0ef          	jal	80004e28 <end_op>
    return -1;
    80005968:	557d                	li	a0,-1
    8000596a:	b7d5                	j	8000594e <kexec+0x72>
    8000596c:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    8000596e:	8526                	mv	a0,s1
    80005970:	f88fc0ef          	jal	800020f8 <proc_pagetable>
    80005974:	8b2a                	mv	s6,a0
    80005976:	26050c63          	beqz	a0,80005bee <kexec+0x312>
    8000597a:	ffce                	sd	s3,504(sp)
    8000597c:	f7d6                	sd	s5,488(sp)
    8000597e:	efde                	sd	s7,472(sp)
    80005980:	ebe2                	sd	s8,464(sp)
    80005982:	e7e6                	sd	s9,456(sp)
    80005984:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005986:	e7042683          	lw	a3,-400(s0)
    8000598a:	e8845783          	lhu	a5,-376(s0)
    8000598e:	14078063          	beqz	a5,80005ace <kexec+0x1f2>
    80005992:	ff6e                	sd	s11,440(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005994:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005996:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005998:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    8000599c:	6c85                	lui	s9,0x1
    8000599e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800059a2:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800059a6:	6a85                	lui	s5,0x1
    800059a8:	a085                	j	80005a08 <kexec+0x12c>
      panic("loadseg: address should exist");
    800059aa:	00003517          	auipc	a0,0x3
    800059ae:	de650513          	addi	a0,a0,-538 # 80008790 <etext+0x790>
    800059b2:	e3dfa0ef          	jal	800007ee <panic>
    if (sz - i < PGSIZE)
    800059b6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800059b8:	874a                	mv	a4,s2
    800059ba:	009c06bb          	addw	a3,s8,s1
    800059be:	4581                	li	a1,0
    800059c0:	8552                	mv	a0,s4
    800059c2:	d59fe0ef          	jal	8000471a <readi>
    800059c6:	22a91c63          	bne	s2,a0,80005bfe <kexec+0x322>
  for (i = 0; i < sz; i += PGSIZE) {
    800059ca:	009a84bb          	addw	s1,s5,s1
    800059ce:	0334f263          	bgeu	s1,s3,800059f2 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800059d2:	02049593          	slli	a1,s1,0x20
    800059d6:	9181                	srli	a1,a1,0x20
    800059d8:	95de                	add	a1,a1,s7
    800059da:	855a                	mv	a0,s6
    800059dc:	f36fb0ef          	jal	80001112 <walkaddr>
    800059e0:	862a                	mv	a2,a0
    if (pa == 0)
    800059e2:	d561                	beqz	a0,800059aa <kexec+0xce>
    if (sz - i < PGSIZE)
    800059e4:	409987bb          	subw	a5,s3,s1
    800059e8:	893e                	mv	s2,a5
    800059ea:	fcfcf6e3          	bgeu	s9,a5,800059b6 <kexec+0xda>
    800059ee:	8956                	mv	s2,s5
    800059f0:	b7d9                	j	800059b6 <kexec+0xda>
    sz = sz1;
    800059f2:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800059f6:	2d05                	addiw	s10,s10,1
    800059f8:	e0843783          	ld	a5,-504(s0)
    800059fc:	0387869b          	addiw	a3,a5,56
    80005a00:	e8845783          	lhu	a5,-376(s0)
    80005a04:	06fd5d63          	bge	s10,a5,80005a7e <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005a08:	e0d43423          	sd	a3,-504(s0)
    80005a0c:	876e                	mv	a4,s11
    80005a0e:	e1840613          	addi	a2,s0,-488
    80005a12:	4581                	li	a1,0
    80005a14:	8552                	mv	a0,s4
    80005a16:	d05fe0ef          	jal	8000471a <readi>
    80005a1a:	1fb51063          	bne	a0,s11,80005bfa <kexec+0x31e>
    if (ph.type != ELF_PROG_LOAD)
    80005a1e:	e1842783          	lw	a5,-488(s0)
    80005a22:	4705                	li	a4,1
    80005a24:	fce799e3          	bne	a5,a4,800059f6 <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    80005a28:	e4043483          	ld	s1,-448(s0)
    80005a2c:	e3843783          	ld	a5,-456(s0)
    80005a30:	1ef4e563          	bltu	s1,a5,80005c1a <kexec+0x33e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005a34:	e2843783          	ld	a5,-472(s0)
    80005a38:	94be                	add	s1,s1,a5
    80005a3a:	1ef4e363          	bltu	s1,a5,80005c20 <kexec+0x344>
    if (ph.vaddr % PGSIZE != 0)
    80005a3e:	de843703          	ld	a4,-536(s0)
    80005a42:	8ff9                	and	a5,a5,a4
    80005a44:	1e079163          	bnez	a5,80005c26 <kexec+0x34a>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80005a48:	e1c42503          	lw	a0,-484(s0)
    80005a4c:	e71ff0ef          	jal	800058bc <flags2perm>
    80005a50:	86aa                	mv	a3,a0
    80005a52:	8626                	mv	a2,s1
    80005a54:	85ca                	mv	a1,s2
    80005a56:	855a                	mv	a0,s6
    80005a58:	9a3fb0ef          	jal	800013fa <uvmalloc>
    80005a5c:	dea43c23          	sd	a0,-520(s0)
    80005a60:	1c050663          	beqz	a0,80005c2c <kexec+0x350>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005a64:	e2843b83          	ld	s7,-472(s0)
    80005a68:	e2042c03          	lw	s8,-480(s0)
    80005a6c:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005a70:	00098463          	beqz	s3,80005a78 <kexec+0x19c>
    80005a74:	4481                	li	s1,0
    80005a76:	bfb1                	j	800059d2 <kexec+0xf6>
    sz = sz1;
    80005a78:	df843903          	ld	s2,-520(s0)
    80005a7c:	bfad                	j	800059f6 <kexec+0x11a>
    80005a7e:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    80005a80:	8552                	mv	a0,s4
    80005a82:	b11fe0ef          	jal	80004592 <iunlockput>
  end_op();
    80005a86:	ba2ff0ef          	jal	80004e28 <end_op>
  p = myproc();
    80005a8a:	d6cfc0ef          	jal	80001ff6 <myproc>
    80005a8e:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80005a90:	07053a83          	ld	s5,112(a0)
  sz = PGROUNDUP(sz);
    80005a94:	6c05                	lui	s8,0x1
    80005a96:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    80005a98:	9c4a                	add	s8,s8,s2
    80005a9a:	77fd                	lui	a5,0xfffff
    80005a9c:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80005aa0:	4691                	li	a3,4
    80005aa2:	6609                	lui	a2,0x2
    80005aa4:	9662                	add	a2,a2,s8
    80005aa6:	85e2                	mv	a1,s8
    80005aa8:	855a                	mv	a0,s6
    80005aaa:	951fb0ef          	jal	800013fa <uvmalloc>
    80005aae:	892a                	mv	s2,a0
    80005ab0:	e10d                	bnez	a0,80005ad2 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    80005ab2:	85e2                	mv	a1,s8
    80005ab4:	855a                	mv	a0,s6
    80005ab6:	ec6fc0ef          	jal	8000217c <proc_freepagetable>
  return -1;
    80005aba:	557d                	li	a0,-1
    80005abc:	79fe                	ld	s3,504(sp)
    80005abe:	7a5e                	ld	s4,496(sp)
    80005ac0:	7abe                	ld	s5,488(sp)
    80005ac2:	7b1e                	ld	s6,480(sp)
    80005ac4:	6bfe                	ld	s7,472(sp)
    80005ac6:	6c5e                	ld	s8,464(sp)
    80005ac8:	6cbe                	ld	s9,456(sp)
    80005aca:	6d1e                	ld	s10,448(sp)
    80005acc:	b549                	j	8000594e <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005ace:	4901                	li	s2,0
    80005ad0:	bf45                	j	80005a80 <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80005ad2:	75f9                	lui	a1,0xffffe
    80005ad4:	95aa                	add	a1,a1,a0
    80005ad6:	855a                	mv	a0,s6
    80005ad8:	b13fb0ef          	jal	800015ea <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80005adc:	7a7d                	lui	s4,0xfffff
    80005ade:	9a4a                	add	s4,s4,s2
  for (argc = 0; argv[argc]; argc++) {
    80005ae0:	e0043783          	ld	a5,-512(s0)
    80005ae4:	6388                	ld	a0,0(a5)
    80005ae6:	c545                	beqz	a0,80005b8e <kexec+0x2b2>
  sp = sz;
    80005ae8:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80005aea:	4481                	li	s1,0
    ustack[argc] = sp;
    80005aec:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80005af0:	c7afb0ef          	jal	80000f6a <strlen>
    80005af4:	0015079b          	addiw	a5,a0,1
    80005af8:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005afc:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80005b00:	0f4c6963          	bltu	s8,s4,80005bf2 <kexec+0x316>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005b04:	e0043d03          	ld	s10,-512(s0)
    80005b08:	000d3c83          	ld	s9,0(s10)
    80005b0c:	8566                	mv	a0,s9
    80005b0e:	c5cfb0ef          	jal	80000f6a <strlen>
    80005b12:	0015071b          	addiw	a4,a0,1
    80005b16:	86e6                	mv	a3,s9
    80005b18:	8662                	mv	a2,s8
    80005b1a:	85ca                	mv	a1,s2
    80005b1c:	855a                	mv	a0,s6
    80005b1e:	e7ffb0ef          	jal	8000199c <copyout>
    80005b22:	0c054a63          	bltz	a0,80005bf6 <kexec+0x31a>
    ustack[argc] = sp;
    80005b26:	00349793          	slli	a5,s1,0x3
    80005b2a:	97de                	add	a5,a5,s7
    80005b2c:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7fdae698>
  for (argc = 0; argv[argc]; argc++) {
    80005b30:	0485                	addi	s1,s1,1
    80005b32:	008d0793          	addi	a5,s10,8
    80005b36:	e0f43023          	sd	a5,-512(s0)
    80005b3a:	008d3503          	ld	a0,8(s10)
    80005b3e:	f94d                	bnez	a0,80005af0 <kexec+0x214>
  ustack[argc] = 0;
    80005b40:	00349793          	slli	a5,s1,0x3
    80005b44:	f9078793          	addi	a5,a5,-112
    80005b48:	97a2                	add	a5,a5,s0
    80005b4a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80005b4e:	00148713          	addi	a4,s1,1
    80005b52:	070e                	slli	a4,a4,0x3
    80005b54:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    80005b58:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80005b5c:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80005b5e:	f54beae3          	bltu	s7,s4,80005ab2 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80005b62:	e9040693          	addi	a3,s0,-368
    80005b66:	865e                	mv	a2,s7
    80005b68:	85ca                	mv	a1,s2
    80005b6a:	855a                	mv	a0,s6
    80005b6c:	e31fb0ef          	jal	8000199c <copyout>
    80005b70:	f40541e3          	bltz	a0,80005ab2 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80005b74:	0809b783          	ld	a5,128(s3)
    80005b78:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    80005b7c:	df043783          	ld	a5,-528(s0)
    80005b80:	0007c703          	lbu	a4,0(a5)
    80005b84:	c30d                	beqz	a4,80005ba6 <kexec+0x2ca>
    80005b86:	0785                	addi	a5,a5,1
    if (*s == '/')
    80005b88:	02f00693          	li	a3,47
    80005b8c:	a801                	j	80005b9c <kexec+0x2c0>
  sp = sz;
    80005b8e:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    80005b90:	4481                	li	s1,0
    80005b92:	b77d                	j	80005b40 <kexec+0x264>
  for (last = s = path; *s; s++)
    80005b94:	0785                	addi	a5,a5,1
    80005b96:	fff7c703          	lbu	a4,-1(a5)
    80005b9a:	c711                	beqz	a4,80005ba6 <kexec+0x2ca>
    if (*s == '/')
    80005b9c:	fed71ce3          	bne	a4,a3,80005b94 <kexec+0x2b8>
      last = s + 1;
    80005ba0:	def43823          	sd	a5,-528(s0)
    80005ba4:	bfc5                	j	80005b94 <kexec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80005ba6:	4641                	li	a2,16
    80005ba8:	df043583          	ld	a1,-528(s0)
    80005bac:	50098513          	addi	a0,s3,1280
    80005bb0:	b84fb0ef          	jal	80000f34 <safestrcpy>
  oldpagetable = p->pagetable;
    80005bb4:	0789b503          	ld	a0,120(s3)
  p->pagetable = pagetable;
    80005bb8:	0769bc23          	sd	s6,120(s3)
  p->sz = sz;
    80005bbc:	0729b823          	sd	s2,112(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80005bc0:	0809b783          	ld	a5,128(s3)
    80005bc4:	e6843703          	ld	a4,-408(s0)
    80005bc8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80005bca:	0809b783          	ld	a5,128(s3)
    80005bce:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005bd2:	85d6                	mv	a1,s5
    80005bd4:	da8fc0ef          	jal	8000217c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005bd8:	0004851b          	sext.w	a0,s1
    80005bdc:	79fe                	ld	s3,504(sp)
    80005bde:	7a5e                	ld	s4,496(sp)
    80005be0:	7abe                	ld	s5,488(sp)
    80005be2:	7b1e                	ld	s6,480(sp)
    80005be4:	6bfe                	ld	s7,472(sp)
    80005be6:	6c5e                	ld	s8,464(sp)
    80005be8:	6cbe                	ld	s9,456(sp)
    80005bea:	6d1e                	ld	s10,448(sp)
    80005bec:	b38d                	j	8000594e <kexec+0x72>
    80005bee:	7b1e                	ld	s6,480(sp)
    80005bf0:	bb81                	j	80005940 <kexec+0x64>
  sz = sz1;
    80005bf2:	8c4a                	mv	s8,s2
    80005bf4:	bd7d                	j	80005ab2 <kexec+0x1d6>
    80005bf6:	8c4a                	mv	s8,s2
    80005bf8:	bd6d                	j	80005ab2 <kexec+0x1d6>
    80005bfa:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005bfe:	df843583          	ld	a1,-520(s0)
    80005c02:	855a                	mv	a0,s6
    80005c04:	d78fc0ef          	jal	8000217c <proc_freepagetable>
  if (ip) {
    80005c08:	79fe                	ld	s3,504(sp)
    80005c0a:	7abe                	ld	s5,488(sp)
    80005c0c:	7b1e                	ld	s6,480(sp)
    80005c0e:	6bfe                	ld	s7,472(sp)
    80005c10:	6c5e                	ld	s8,464(sp)
    80005c12:	6cbe                	ld	s9,456(sp)
    80005c14:	6d1e                	ld	s10,448(sp)
    80005c16:	7dfa                	ld	s11,440(sp)
    80005c18:	b325                	j	80005940 <kexec+0x64>
    80005c1a:	df243c23          	sd	s2,-520(s0)
    80005c1e:	b7c5                	j	80005bfe <kexec+0x322>
    80005c20:	df243c23          	sd	s2,-520(s0)
    80005c24:	bfe9                	j	80005bfe <kexec+0x322>
    80005c26:	df243c23          	sd	s2,-520(s0)
    80005c2a:	bfd1                	j	80005bfe <kexec+0x322>
    80005c2c:	df243c23          	sd	s2,-520(s0)
    80005c30:	b7f9                	j	80005bfe <kexec+0x322>

0000000080005c32 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005c32:	7179                	addi	sp,sp,-48
    80005c34:	f406                	sd	ra,40(sp)
    80005c36:	f022                	sd	s0,32(sp)
    80005c38:	ec26                	sd	s1,24(sp)
    80005c3a:	e84a                	sd	s2,16(sp)
    80005c3c:	1800                	addi	s0,sp,48
    80005c3e:	892e                	mv	s2,a1
    80005c40:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005c42:	fdc40593          	addi	a1,s0,-36
    80005c46:	899fd0ef          	jal	800034de <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80005c4a:	fdc42703          	lw	a4,-36(s0)
    80005c4e:	47bd                	li	a5,15
    80005c50:	02e7e963          	bltu	a5,a4,80005c82 <argfd+0x50>
    80005c54:	ba2fc0ef          	jal	80001ff6 <myproc>
    80005c58:	fdc42703          	lw	a4,-36(s0)
    80005c5c:	01e70793          	addi	a5,a4,30
    80005c60:	078e                	slli	a5,a5,0x3
    80005c62:	953e                	add	a0,a0,a5
    80005c64:	651c                	ld	a5,8(a0)
    80005c66:	c385                	beqz	a5,80005c86 <argfd+0x54>
    return -1;
  if (pfd)
    80005c68:	00090463          	beqz	s2,80005c70 <argfd+0x3e>
    *pfd = fd;
    80005c6c:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80005c70:	4501                	li	a0,0
  if (pf)
    80005c72:	c091                	beqz	s1,80005c76 <argfd+0x44>
    *pf = f;
    80005c74:	e09c                	sd	a5,0(s1)
}
    80005c76:	70a2                	ld	ra,40(sp)
    80005c78:	7402                	ld	s0,32(sp)
    80005c7a:	64e2                	ld	s1,24(sp)
    80005c7c:	6942                	ld	s2,16(sp)
    80005c7e:	6145                	addi	sp,sp,48
    80005c80:	8082                	ret
    return -1;
    80005c82:	557d                	li	a0,-1
    80005c84:	bfcd                	j	80005c76 <argfd+0x44>
    80005c86:	557d                	li	a0,-1
    80005c88:	b7fd                	j	80005c76 <argfd+0x44>

0000000080005c8a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005c8a:	1101                	addi	sp,sp,-32
    80005c8c:	ec06                	sd	ra,24(sp)
    80005c8e:	e822                	sd	s0,16(sp)
    80005c90:	e426                	sd	s1,8(sp)
    80005c92:	1000                	addi	s0,sp,32
    80005c94:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005c96:	b60fc0ef          	jal	80001ff6 <myproc>
    80005c9a:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80005c9c:	0f850793          	addi	a5,a0,248
    80005ca0:	4501                	li	a0,0
    80005ca2:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80005ca4:	6398                	ld	a4,0(a5)
    80005ca6:	cb19                	beqz	a4,80005cbc <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80005ca8:	2505                	addiw	a0,a0,1
    80005caa:	07a1                	addi	a5,a5,8
    80005cac:	fed51ce3          	bne	a0,a3,80005ca4 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005cb0:	557d                	li	a0,-1
}
    80005cb2:	60e2                	ld	ra,24(sp)
    80005cb4:	6442                	ld	s0,16(sp)
    80005cb6:	64a2                	ld	s1,8(sp)
    80005cb8:	6105                	addi	sp,sp,32
    80005cba:	8082                	ret
      p->ofile[fd] = f;
    80005cbc:	01e50793          	addi	a5,a0,30
    80005cc0:	078e                	slli	a5,a5,0x3
    80005cc2:	963e                	add	a2,a2,a5
    80005cc4:	e604                	sd	s1,8(a2)
      return fd;
    80005cc6:	b7f5                	j	80005cb2 <fdalloc+0x28>

0000000080005cc8 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80005cc8:	715d                	addi	sp,sp,-80
    80005cca:	e486                	sd	ra,72(sp)
    80005ccc:	e0a2                	sd	s0,64(sp)
    80005cce:	fc26                	sd	s1,56(sp)
    80005cd0:	f84a                	sd	s2,48(sp)
    80005cd2:	f44e                	sd	s3,40(sp)
    80005cd4:	f052                	sd	s4,32(sp)
    80005cd6:	ec56                	sd	s5,24(sp)
    80005cd8:	0880                	addi	s0,sp,80
    80005cda:	892e                	mv	s2,a1
    80005cdc:	89b2                	mv	s3,a2
    80005cde:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80005ce0:	fb040593          	addi	a1,s0,-80
    80005ce4:	efffe0ef          	jal	80004be2 <nameiparent>
    80005ce8:	8aaa                	mv	s5,a0
    80005cea:	cd45                	beqz	a0,80005da2 <create+0xda>
    return 0;

  ilock(dp);
    80005cec:	e54fe0ef          	jal	80004340 <ilock>

  if (dp->nlink == 0) {
    80005cf0:	04aa9783          	lh	a5,74(s5) # 104a <_entry-0x7fffefb6>
    80005cf4:	cf8d                	beqz	a5,80005d2e <create+0x66>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80005cf6:	4705                	li	a4,1
    80005cf8:	04e91563          	bne	s2,a4,80005d42 <create+0x7a>
    80005cfc:	6721                	lui	a4,0x8
    80005cfe:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80005d00:	02e78c63          	beq	a5,a4,80005d38 <create+0x70>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005d04:	4601                	li	a2,0
    80005d06:	fb040593          	addi	a1,s0,-80
    80005d0a:	8556                	mv	a0,s5
    80005d0c:	c21fe0ef          	jal	8000492c <dirlookup>
    80005d10:	84aa                	mv	s1,a0
    80005d12:	e951                	bnez	a0,80005da6 <create+0xde>
      return ip;
    iunlockput(ip);
    return 0;
  }

  if ((ip = ialloc(dp->dev, type)) == 0) {
    80005d14:	85ca                	mv	a1,s2
    80005d16:	000aa503          	lw	a0,0(s5)
    80005d1a:	cb6fe0ef          	jal	800041d0 <ialloc>
    80005d1e:	84aa                	mv	s1,a0
    80005d20:	0c051e63          	bnez	a0,80005dfc <create+0x134>
    iunlockput(dp);
    80005d24:	8556                	mv	a0,s5
    80005d26:	86dfe0ef          	jal	80004592 <iunlockput>
    return 0;
    80005d2a:	4481                	li	s1,0
    80005d2c:	a0a1                	j	80005d74 <create+0xac>
    iunlockput(dp);
    80005d2e:	8556                	mv	a0,s5
    80005d30:	863fe0ef          	jal	80004592 <iunlockput>
    return 0;
    80005d34:	4481                	li	s1,0
    80005d36:	a83d                	j	80005d74 <create+0xac>
    iunlockput(dp);
    80005d38:	8556                	mv	a0,s5
    80005d3a:	859fe0ef          	jal	80004592 <iunlockput>
    return 0;
    80005d3e:	4481                	li	s1,0
    80005d40:	a815                	j	80005d74 <create+0xac>
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005d42:	4601                	li	a2,0
    80005d44:	fb040593          	addi	a1,s0,-80
    80005d48:	8556                	mv	a0,s5
    80005d4a:	be3fe0ef          	jal	8000492c <dirlookup>
    80005d4e:	84aa                	mv	s1,a0
    80005d50:	c535                	beqz	a0,80005dbc <create+0xf4>
    iunlockput(dp);
    80005d52:	8556                	mv	a0,s5
    80005d54:	83ffe0ef          	jal	80004592 <iunlockput>
    ilock(ip);
    80005d58:	8526                	mv	a0,s1
    80005d5a:	de6fe0ef          	jal	80004340 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005d5e:	4789                	li	a5,2
    80005d60:	04f91963          	bne	s2,a5,80005db2 <create+0xea>
    80005d64:	0444d783          	lhu	a5,68(s1)
    80005d68:	37f9                	addiw	a5,a5,-2
    80005d6a:	17c2                	slli	a5,a5,0x30
    80005d6c:	93c1                	srli	a5,a5,0x30
    80005d6e:	4705                	li	a4,1
    80005d70:	04f76163          	bltu	a4,a5,80005db2 <create+0xea>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005d74:	8526                	mv	a0,s1
    80005d76:	60a6                	ld	ra,72(sp)
    80005d78:	6406                	ld	s0,64(sp)
    80005d7a:	74e2                	ld	s1,56(sp)
    80005d7c:	7942                	ld	s2,48(sp)
    80005d7e:	79a2                	ld	s3,40(sp)
    80005d80:	7a02                	ld	s4,32(sp)
    80005d82:	6ae2                	ld	s5,24(sp)
    80005d84:	6161                	addi	sp,sp,80
    80005d86:	8082                	ret
  ip->nlink = 0;
    80005d88:	04049523          	sh	zero,74(s1)
  iupdate(ip);
    80005d8c:	8526                	mv	a0,s1
    80005d8e:	cfefe0ef          	jal	8000428c <iupdate>
  iunlockput(ip);
    80005d92:	8526                	mv	a0,s1
    80005d94:	ffefe0ef          	jal	80004592 <iunlockput>
  iunlockput(dp);
    80005d98:	8556                	mv	a0,s5
    80005d9a:	ff8fe0ef          	jal	80004592 <iunlockput>
  return 0;
    80005d9e:	4481                	li	s1,0
    80005da0:	bfd1                	j	80005d74 <create+0xac>
    return 0;
    80005da2:	84aa                	mv	s1,a0
    80005da4:	bfc1                	j	80005d74 <create+0xac>
    iunlockput(dp);
    80005da6:	8556                	mv	a0,s5
    80005da8:	feafe0ef          	jal	80004592 <iunlockput>
    ilock(ip);
    80005dac:	8526                	mv	a0,s1
    80005dae:	d92fe0ef          	jal	80004340 <ilock>
    iunlockput(ip);
    80005db2:	8526                	mv	a0,s1
    80005db4:	fdefe0ef          	jal	80004592 <iunlockput>
    return 0;
    80005db8:	4481                	li	s1,0
    80005dba:	bf6d                	j	80005d74 <create+0xac>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80005dbc:	85ca                	mv	a1,s2
    80005dbe:	000aa503          	lw	a0,0(s5)
    80005dc2:	c0efe0ef          	jal	800041d0 <ialloc>
    80005dc6:	84aa                	mv	s1,a0
    80005dc8:	dd31                	beqz	a0,80005d24 <create+0x5c>
  ilock(ip);
    80005dca:	8526                	mv	a0,s1
    80005dcc:	d74fe0ef          	jal	80004340 <ilock>
  ip->major = major;
    80005dd0:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    80005dd4:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005dd8:	4785                	li	a5,1
    80005dda:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005dde:	8526                	mv	a0,s1
    80005de0:	cacfe0ef          	jal	8000428c <iupdate>
  if (dirlink(dp, name, ip->inum) < 0)
    80005de4:	40d0                	lw	a2,4(s1)
    80005de6:	fb040593          	addi	a1,s0,-80
    80005dea:	8556                	mv	a0,s5
    80005dec:	d33fe0ef          	jal	80004b1e <dirlink>
    80005df0:	f8054ce3          	bltz	a0,80005d88 <create+0xc0>
  iunlockput(dp);
    80005df4:	8556                	mv	a0,s5
    80005df6:	f9cfe0ef          	jal	80004592 <iunlockput>
  return ip;
    80005dfa:	bfad                	j	80005d74 <create+0xac>
  ilock(ip);
    80005dfc:	8526                	mv	a0,s1
    80005dfe:	d42fe0ef          	jal	80004340 <ilock>
  ip->major = major;
    80005e02:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    80005e06:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005e0a:	4785                	li	a5,1
    80005e0c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e10:	8526                	mv	a0,s1
    80005e12:	c7afe0ef          	jal	8000428c <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005e16:	40d0                	lw	a2,4(s1)
    80005e18:	00003597          	auipc	a1,0x3
    80005e1c:	9a058593          	addi	a1,a1,-1632 # 800087b8 <etext+0x7b8>
    80005e20:	8526                	mv	a0,s1
    80005e22:	cfdfe0ef          	jal	80004b1e <dirlink>
    80005e26:	f60541e3          	bltz	a0,80005d88 <create+0xc0>
    80005e2a:	004aa603          	lw	a2,4(s5)
    80005e2e:	00003597          	auipc	a1,0x3
    80005e32:	98258593          	addi	a1,a1,-1662 # 800087b0 <etext+0x7b0>
    80005e36:	8526                	mv	a0,s1
    80005e38:	ce7fe0ef          	jal	80004b1e <dirlink>
    80005e3c:	f40546e3          	bltz	a0,80005d88 <create+0xc0>
  if (dirlink(dp, name, ip->inum) < 0)
    80005e40:	40d0                	lw	a2,4(s1)
    80005e42:	fb040593          	addi	a1,s0,-80
    80005e46:	8556                	mv	a0,s5
    80005e48:	cd7fe0ef          	jal	80004b1e <dirlink>
    80005e4c:	f2054ee3          	bltz	a0,80005d88 <create+0xc0>
    dp->nlink++; // for ".."
    80005e50:	04aad783          	lhu	a5,74(s5)
    80005e54:	2785                	addiw	a5,a5,1
    80005e56:	04fa9523          	sh	a5,74(s5)
    iupdate(dp);
    80005e5a:	8556                	mv	a0,s5
    80005e5c:	c30fe0ef          	jal	8000428c <iupdate>
    80005e60:	bf51                	j	80005df4 <create+0x12c>

0000000080005e62 <sys_dup>:
{
    80005e62:	7179                	addi	sp,sp,-48
    80005e64:	f406                	sd	ra,40(sp)
    80005e66:	f022                	sd	s0,32(sp)
    80005e68:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80005e6a:	fd840613          	addi	a2,s0,-40
    80005e6e:	4581                	li	a1,0
    80005e70:	4501                	li	a0,0
    80005e72:	dc1ff0ef          	jal	80005c32 <argfd>
    return -1;
    80005e76:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005e78:	02054363          	bltz	a0,80005e9e <sys_dup+0x3c>
    80005e7c:	ec26                	sd	s1,24(sp)
    80005e7e:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80005e80:	fd843903          	ld	s2,-40(s0)
    80005e84:	854a                	mv	a0,s2
    80005e86:	e05ff0ef          	jal	80005c8a <fdalloc>
    80005e8a:	84aa                	mv	s1,a0
    return -1;
    80005e8c:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80005e8e:	00054d63          	bltz	a0,80005ea8 <sys_dup+0x46>
  filedup(f);
    80005e92:	854a                	mv	a0,s2
    80005e94:	b7aff0ef          	jal	8000520e <filedup>
  return fd;
    80005e98:	87a6                	mv	a5,s1
    80005e9a:	64e2                	ld	s1,24(sp)
    80005e9c:	6942                	ld	s2,16(sp)
}
    80005e9e:	853e                	mv	a0,a5
    80005ea0:	70a2                	ld	ra,40(sp)
    80005ea2:	7402                	ld	s0,32(sp)
    80005ea4:	6145                	addi	sp,sp,48
    80005ea6:	8082                	ret
    80005ea8:	64e2                	ld	s1,24(sp)
    80005eaa:	6942                	ld	s2,16(sp)
    80005eac:	bfcd                	j	80005e9e <sys_dup+0x3c>

0000000080005eae <sys_read>:
{
    80005eae:	7179                	addi	sp,sp,-48
    80005eb0:	f406                	sd	ra,40(sp)
    80005eb2:	f022                	sd	s0,32(sp)
    80005eb4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005eb6:	fd840593          	addi	a1,s0,-40
    80005eba:	4505                	li	a0,1
    80005ebc:	e3efd0ef          	jal	800034fa <argaddr>
  argint(2, &n);
    80005ec0:	fe440593          	addi	a1,s0,-28
    80005ec4:	4509                	li	a0,2
    80005ec6:	e18fd0ef          	jal	800034de <argint>
  if (argfd(0, 0, &f) < 0)
    80005eca:	fe840613          	addi	a2,s0,-24
    80005ece:	4581                	li	a1,0
    80005ed0:	4501                	li	a0,0
    80005ed2:	d61ff0ef          	jal	80005c32 <argfd>
    80005ed6:	87aa                	mv	a5,a0
    return -1;
    80005ed8:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005eda:	0007ca63          	bltz	a5,80005eee <sys_read+0x40>
  return fileread(f, p, n);
    80005ede:	fe442603          	lw	a2,-28(s0)
    80005ee2:	fd843583          	ld	a1,-40(s0)
    80005ee6:	fe843503          	ld	a0,-24(s0)
    80005eea:	c8eff0ef          	jal	80005378 <fileread>
}
    80005eee:	70a2                	ld	ra,40(sp)
    80005ef0:	7402                	ld	s0,32(sp)
    80005ef2:	6145                	addi	sp,sp,48
    80005ef4:	8082                	ret

0000000080005ef6 <sys_write>:
{
    80005ef6:	7179                	addi	sp,sp,-48
    80005ef8:	f406                	sd	ra,40(sp)
    80005efa:	f022                	sd	s0,32(sp)
    80005efc:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005efe:	fd840593          	addi	a1,s0,-40
    80005f02:	4505                	li	a0,1
    80005f04:	df6fd0ef          	jal	800034fa <argaddr>
  argint(2, &n);
    80005f08:	fe440593          	addi	a1,s0,-28
    80005f0c:	4509                	li	a0,2
    80005f0e:	dd0fd0ef          	jal	800034de <argint>
  if (argfd(0, 0, &f) < 0)
    80005f12:	fe840613          	addi	a2,s0,-24
    80005f16:	4581                	li	a1,0
    80005f18:	4501                	li	a0,0
    80005f1a:	d19ff0ef          	jal	80005c32 <argfd>
    80005f1e:	87aa                	mv	a5,a0
    return -1;
    80005f20:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005f22:	0007ca63          	bltz	a5,80005f36 <sys_write+0x40>
  return filewrite(f, p, n);
    80005f26:	fe442603          	lw	a2,-28(s0)
    80005f2a:	fd843583          	ld	a1,-40(s0)
    80005f2e:	fe843503          	ld	a0,-24(s0)
    80005f32:	d10ff0ef          	jal	80005442 <filewrite>
}
    80005f36:	70a2                	ld	ra,40(sp)
    80005f38:	7402                	ld	s0,32(sp)
    80005f3a:	6145                	addi	sp,sp,48
    80005f3c:	8082                	ret

0000000080005f3e <sys_close>:
{
    80005f3e:	1101                	addi	sp,sp,-32
    80005f40:	ec06                	sd	ra,24(sp)
    80005f42:	e822                	sd	s0,16(sp)
    80005f44:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005f46:	fe040613          	addi	a2,s0,-32
    80005f4a:	fec40593          	addi	a1,s0,-20
    80005f4e:	4501                	li	a0,0
    80005f50:	ce3ff0ef          	jal	80005c32 <argfd>
    return -1;
    80005f54:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80005f56:	02054063          	bltz	a0,80005f76 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80005f5a:	89cfc0ef          	jal	80001ff6 <myproc>
    80005f5e:	fec42783          	lw	a5,-20(s0)
    80005f62:	07f9                	addi	a5,a5,30
    80005f64:	078e                	slli	a5,a5,0x3
    80005f66:	953e                	add	a0,a0,a5
    80005f68:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005f6c:	fe043503          	ld	a0,-32(s0)
    80005f70:	ae4ff0ef          	jal	80005254 <fileclose>
  return 0;
    80005f74:	4781                	li	a5,0
}
    80005f76:	853e                	mv	a0,a5
    80005f78:	60e2                	ld	ra,24(sp)
    80005f7a:	6442                	ld	s0,16(sp)
    80005f7c:	6105                	addi	sp,sp,32
    80005f7e:	8082                	ret

0000000080005f80 <sys_fstat>:
{
    80005f80:	1101                	addi	sp,sp,-32
    80005f82:	ec06                	sd	ra,24(sp)
    80005f84:	e822                	sd	s0,16(sp)
    80005f86:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005f88:	fe040593          	addi	a1,s0,-32
    80005f8c:	4505                	li	a0,1
    80005f8e:	d6cfd0ef          	jal	800034fa <argaddr>
  if (argfd(0, 0, &f) < 0)
    80005f92:	fe840613          	addi	a2,s0,-24
    80005f96:	4581                	li	a1,0
    80005f98:	4501                	li	a0,0
    80005f9a:	c99ff0ef          	jal	80005c32 <argfd>
    80005f9e:	87aa                	mv	a5,a0
    return -1;
    80005fa0:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005fa2:	0007c863          	bltz	a5,80005fb2 <sys_fstat+0x32>
  return filestat(f, st);
    80005fa6:	fe043583          	ld	a1,-32(s0)
    80005faa:	fe843503          	ld	a0,-24(s0)
    80005fae:	b64ff0ef          	jal	80005312 <filestat>
}
    80005fb2:	60e2                	ld	ra,24(sp)
    80005fb4:	6442                	ld	s0,16(sp)
    80005fb6:	6105                	addi	sp,sp,32
    80005fb8:	8082                	ret

0000000080005fba <sys_link>:
{
    80005fba:	7169                	addi	sp,sp,-304
    80005fbc:	f606                	sd	ra,296(sp)
    80005fbe:	f222                	sd	s0,288(sp)
    80005fc0:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fc2:	08000613          	li	a2,128
    80005fc6:	ed040593          	addi	a1,s0,-304
    80005fca:	4501                	li	a0,0
    80005fcc:	d4afd0ef          	jal	80003516 <argstr>
    return -1;
    80005fd0:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fd2:	10054163          	bltz	a0,800060d4 <sys_link+0x11a>
    80005fd6:	08000613          	li	a2,128
    80005fda:	f5040593          	addi	a1,s0,-176
    80005fde:	4505                	li	a0,1
    80005fe0:	d36fd0ef          	jal	80003516 <argstr>
    return -1;
    80005fe4:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005fe6:	0e054763          	bltz	a0,800060d4 <sys_link+0x11a>
    80005fea:	ee26                	sd	s1,280(sp)
  begin_op();
    80005fec:	db7fe0ef          	jal	80004da2 <begin_op>
  if ((ip = namei(old)) == 0) {
    80005ff0:	ed040513          	addi	a0,s0,-304
    80005ff4:	bd5fe0ef          	jal	80004bc8 <namei>
    80005ff8:	84aa                	mv	s1,a0
    80005ffa:	cd35                	beqz	a0,80006076 <sys_link+0xbc>
  ilock(ip);
    80005ffc:	b44fe0ef          	jal	80004340 <ilock>
  if (ip->type == T_DIR) {
    80006000:	04449703          	lh	a4,68(s1)
    80006004:	4785                	li	a5,1
    80006006:	06f70d63          	beq	a4,a5,80006080 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    8000600a:	04a49783          	lh	a5,74(s1)
    8000600e:	6721                	lui	a4,0x8
    80006010:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80006012:	06e78f63          	beq	a5,a4,80006090 <sys_link+0xd6>
    80006016:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80006018:	2785                	addiw	a5,a5,1
    8000601a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000601e:	8526                	mv	a0,s1
    80006020:	a6cfe0ef          	jal	8000428c <iupdate>
  iunlock(ip);
    80006024:	8526                	mv	a0,s1
    80006026:	bc8fe0ef          	jal	800043ee <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000602a:	fd040593          	addi	a1,s0,-48
    8000602e:	f5040513          	addi	a0,s0,-176
    80006032:	bb1fe0ef          	jal	80004be2 <nameiparent>
    80006036:	892a                	mv	s2,a0
    80006038:	c93d                	beqz	a0,800060ae <sys_link+0xf4>
  ilock(dp);
    8000603a:	b06fe0ef          	jal	80004340 <ilock>
  if (dp->nlink == 0) {
    8000603e:	04a91783          	lh	a5,74(s2)
    80006042:	cfb9                	beqz	a5,800060a0 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80006044:	00092703          	lw	a4,0(s2)
    80006048:	409c                	lw	a5,0(s1)
    8000604a:	04f71f63          	bne	a4,a5,800060a8 <sys_link+0xee>
    8000604e:	40d0                	lw	a2,4(s1)
    80006050:	fd040593          	addi	a1,s0,-48
    80006054:	854a                	mv	a0,s2
    80006056:	ac9fe0ef          	jal	80004b1e <dirlink>
    8000605a:	04054763          	bltz	a0,800060a8 <sys_link+0xee>
  iunlockput(dp);
    8000605e:	854a                	mv	a0,s2
    80006060:	d32fe0ef          	jal	80004592 <iunlockput>
  iput(ip);
    80006064:	8526                	mv	a0,s1
    80006066:	c5cfe0ef          	jal	800044c2 <iput>
  end_op();
    8000606a:	dbffe0ef          	jal	80004e28 <end_op>
  return 0;
    8000606e:	4781                	li	a5,0
    80006070:	64f2                	ld	s1,280(sp)
    80006072:	6952                	ld	s2,272(sp)
    80006074:	a085                	j	800060d4 <sys_link+0x11a>
    end_op();
    80006076:	db3fe0ef          	jal	80004e28 <end_op>
    return -1;
    8000607a:	57fd                	li	a5,-1
    8000607c:	64f2                	ld	s1,280(sp)
    8000607e:	a899                	j	800060d4 <sys_link+0x11a>
    iunlockput(ip);
    80006080:	8526                	mv	a0,s1
    80006082:	d10fe0ef          	jal	80004592 <iunlockput>
    end_op();
    80006086:	da3fe0ef          	jal	80004e28 <end_op>
    return -1;
    8000608a:	57fd                	li	a5,-1
    8000608c:	64f2                	ld	s1,280(sp)
    8000608e:	a099                	j	800060d4 <sys_link+0x11a>
    iunlockput(ip);
    80006090:	8526                	mv	a0,s1
    80006092:	d00fe0ef          	jal	80004592 <iunlockput>
    end_op();
    80006096:	d93fe0ef          	jal	80004e28 <end_op>
    return -1;
    8000609a:	57fd                	li	a5,-1
    8000609c:	64f2                	ld	s1,280(sp)
    8000609e:	a81d                	j	800060d4 <sys_link+0x11a>
    iunlockput(dp);
    800060a0:	854a                	mv	a0,s2
    800060a2:	cf0fe0ef          	jal	80004592 <iunlockput>
    goto bad;
    800060a6:	a021                	j	800060ae <sys_link+0xf4>
    iunlockput(dp);
    800060a8:	854a                	mv	a0,s2
    800060aa:	ce8fe0ef          	jal	80004592 <iunlockput>
  ilock(ip);
    800060ae:	8526                	mv	a0,s1
    800060b0:	a90fe0ef          	jal	80004340 <ilock>
  ip->nlink--;
    800060b4:	04a4d783          	lhu	a5,74(s1)
    800060b8:	37fd                	addiw	a5,a5,-1
    800060ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800060be:	8526                	mv	a0,s1
    800060c0:	9ccfe0ef          	jal	8000428c <iupdate>
  iunlockput(ip);
    800060c4:	8526                	mv	a0,s1
    800060c6:	cccfe0ef          	jal	80004592 <iunlockput>
  end_op();
    800060ca:	d5ffe0ef          	jal	80004e28 <end_op>
  return -1;
    800060ce:	57fd                	li	a5,-1
    800060d0:	64f2                	ld	s1,280(sp)
    800060d2:	6952                	ld	s2,272(sp)
}
    800060d4:	853e                	mv	a0,a5
    800060d6:	70b2                	ld	ra,296(sp)
    800060d8:	7412                	ld	s0,288(sp)
    800060da:	6155                	addi	sp,sp,304
    800060dc:	8082                	ret

00000000800060de <sys_unlink>:
{
    800060de:	7111                	addi	sp,sp,-256
    800060e0:	fd86                	sd	ra,248(sp)
    800060e2:	f9a2                	sd	s0,240(sp)
    800060e4:	0200                	addi	s0,sp,256
  if (argstr(0, path, MAXPATH) < 0)
    800060e6:	08000613          	li	a2,128
    800060ea:	f2040593          	addi	a1,s0,-224
    800060ee:	4501                	li	a0,0
    800060f0:	c26fd0ef          	jal	80003516 <argstr>
    800060f4:	16054663          	bltz	a0,80006260 <sys_unlink+0x182>
    800060f8:	f5a6                	sd	s1,232(sp)
  begin_op();
    800060fa:	ca9fe0ef          	jal	80004da2 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800060fe:	fa040593          	addi	a1,s0,-96
    80006102:	f2040513          	addi	a0,s0,-224
    80006106:	addfe0ef          	jal	80004be2 <nameiparent>
    8000610a:	84aa                	mv	s1,a0
    8000610c:	c955                	beqz	a0,800061c0 <sys_unlink+0xe2>
  ilock(dp);
    8000610e:	a32fe0ef          	jal	80004340 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006112:	00002597          	auipc	a1,0x2
    80006116:	6a658593          	addi	a1,a1,1702 # 800087b8 <etext+0x7b8>
    8000611a:	fa040513          	addi	a0,s0,-96
    8000611e:	ff8fe0ef          	jal	80004916 <namecmp>
    80006122:	12050463          	beqz	a0,8000624a <sys_unlink+0x16c>
    80006126:	00002597          	auipc	a1,0x2
    8000612a:	68a58593          	addi	a1,a1,1674 # 800087b0 <etext+0x7b0>
    8000612e:	fa040513          	addi	a0,s0,-96
    80006132:	fe4fe0ef          	jal	80004916 <namecmp>
    80006136:	10050a63          	beqz	a0,8000624a <sys_unlink+0x16c>
    8000613a:	f1ca                	sd	s2,224(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    8000613c:	f1c40613          	addi	a2,s0,-228
    80006140:	fa040593          	addi	a1,s0,-96
    80006144:	8526                	mv	a0,s1
    80006146:	fe6fe0ef          	jal	8000492c <dirlookup>
    8000614a:	892a                	mv	s2,a0
    8000614c:	0e050e63          	beqz	a0,80006248 <sys_unlink+0x16a>
    80006150:	edce                	sd	s3,216(sp)
  ilock(ip);
    80006152:	9eefe0ef          	jal	80004340 <ilock>
  if (ip->nlink < 1)
    80006156:	04a91783          	lh	a5,74(s2)
    8000615a:	06f05863          	blez	a5,800061ca <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    8000615e:	04491703          	lh	a4,68(s2)
    80006162:	4785                	li	a5,1
    80006164:	06f70b63          	beq	a4,a5,800061da <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80006168:	fb040993          	addi	s3,s0,-80
    8000616c:	4641                	li	a2,16
    8000616e:	4581                	li	a1,0
    80006170:	854e                	mv	a0,s3
    80006172:	c71fa0ef          	jal	80000de2 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006176:	4741                	li	a4,16
    80006178:	f1c42683          	lw	a3,-228(s0)
    8000617c:	864e                	mv	a2,s3
    8000617e:	4581                	li	a1,0
    80006180:	8526                	mv	a0,s1
    80006182:	e8afe0ef          	jal	8000480c <writei>
    80006186:	47c1                	li	a5,16
    80006188:	08f51f63          	bne	a0,a5,80006226 <sys_unlink+0x148>
  if (ip->type == T_DIR) {
    8000618c:	04491703          	lh	a4,68(s2)
    80006190:	4785                	li	a5,1
    80006192:	0af70263          	beq	a4,a5,80006236 <sys_unlink+0x158>
  iunlockput(dp);
    80006196:	8526                	mv	a0,s1
    80006198:	bfafe0ef          	jal	80004592 <iunlockput>
  ip->nlink--;
    8000619c:	04a95783          	lhu	a5,74(s2)
    800061a0:	37fd                	addiw	a5,a5,-1
    800061a2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800061a6:	854a                	mv	a0,s2
    800061a8:	8e4fe0ef          	jal	8000428c <iupdate>
  iunlockput(ip);
    800061ac:	854a                	mv	a0,s2
    800061ae:	be4fe0ef          	jal	80004592 <iunlockput>
  end_op();
    800061b2:	c77fe0ef          	jal	80004e28 <end_op>
  return 0;
    800061b6:	4501                	li	a0,0
    800061b8:	74ae                	ld	s1,232(sp)
    800061ba:	790e                	ld	s2,224(sp)
    800061bc:	69ee                	ld	s3,216(sp)
    800061be:	a869                	j	80006258 <sys_unlink+0x17a>
    end_op();
    800061c0:	c69fe0ef          	jal	80004e28 <end_op>
    return -1;
    800061c4:	557d                	li	a0,-1
    800061c6:	74ae                	ld	s1,232(sp)
    800061c8:	a841                	j	80006258 <sys_unlink+0x17a>
    800061ca:	e9d2                	sd	s4,208(sp)
    800061cc:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800061ce:	00002517          	auipc	a0,0x2
    800061d2:	5f250513          	addi	a0,a0,1522 # 800087c0 <etext+0x7c0>
    800061d6:	e18fa0ef          	jal	800007ee <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800061da:	04c92703          	lw	a4,76(s2)
    800061de:	02000793          	li	a5,32
    800061e2:	f8e7f3e3          	bgeu	a5,a4,80006168 <sys_unlink+0x8a>
    800061e6:	e9d2                	sd	s4,208(sp)
    800061e8:	e5d6                	sd	s5,200(sp)
    800061ea:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800061ec:	f0840a93          	addi	s5,s0,-248
    800061f0:	4a41                	li	s4,16
    800061f2:	8752                	mv	a4,s4
    800061f4:	86ce                	mv	a3,s3
    800061f6:	8656                	mv	a2,s5
    800061f8:	4581                	li	a1,0
    800061fa:	854a                	mv	a0,s2
    800061fc:	d1efe0ef          	jal	8000471a <readi>
    80006200:	01451d63          	bne	a0,s4,8000621a <sys_unlink+0x13c>
    if (de.inum != 0)
    80006204:	f0845783          	lhu	a5,-248(s0)
    80006208:	efb1                	bnez	a5,80006264 <sys_unlink+0x186>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    8000620a:	29c1                	addiw	s3,s3,16
    8000620c:	04c92783          	lw	a5,76(s2)
    80006210:	fef9e1e3          	bltu	s3,a5,800061f2 <sys_unlink+0x114>
    80006214:	6a4e                	ld	s4,208(sp)
    80006216:	6aae                	ld	s5,200(sp)
    80006218:	bf81                	j	80006168 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000621a:	00002517          	auipc	a0,0x2
    8000621e:	5be50513          	addi	a0,a0,1470 # 800087d8 <etext+0x7d8>
    80006222:	dccfa0ef          	jal	800007ee <panic>
    80006226:	e9d2                	sd	s4,208(sp)
    80006228:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    8000622a:	00002517          	auipc	a0,0x2
    8000622e:	5c650513          	addi	a0,a0,1478 # 800087f0 <etext+0x7f0>
    80006232:	dbcfa0ef          	jal	800007ee <panic>
    dp->nlink--;
    80006236:	04a4d783          	lhu	a5,74(s1)
    8000623a:	37fd                	addiw	a5,a5,-1
    8000623c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006240:	8526                	mv	a0,s1
    80006242:	84afe0ef          	jal	8000428c <iupdate>
    80006246:	bf81                	j	80006196 <sys_unlink+0xb8>
    80006248:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    8000624a:	8526                	mv	a0,s1
    8000624c:	b46fe0ef          	jal	80004592 <iunlockput>
  end_op();
    80006250:	bd9fe0ef          	jal	80004e28 <end_op>
  return -1;
    80006254:	557d                	li	a0,-1
    80006256:	74ae                	ld	s1,232(sp)
}
    80006258:	70ee                	ld	ra,248(sp)
    8000625a:	744e                	ld	s0,240(sp)
    8000625c:	6111                	addi	sp,sp,256
    8000625e:	8082                	ret
    return -1;
    80006260:	557d                	li	a0,-1
    80006262:	bfdd                	j	80006258 <sys_unlink+0x17a>
    iunlockput(ip);
    80006264:	854a                	mv	a0,s2
    80006266:	b2cfe0ef          	jal	80004592 <iunlockput>
    goto bad;
    8000626a:	790e                	ld	s2,224(sp)
    8000626c:	69ee                	ld	s3,216(sp)
    8000626e:	6a4e                	ld	s4,208(sp)
    80006270:	6aae                	ld	s5,200(sp)
    80006272:	bfe1                	j	8000624a <sys_unlink+0x16c>

0000000080006274 <sys_open>:

uint64
sys_open(void)
{
    80006274:	7131                	addi	sp,sp,-192
    80006276:	fd06                	sd	ra,184(sp)
    80006278:	f922                	sd	s0,176(sp)
    8000627a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000627c:	f4c40593          	addi	a1,s0,-180
    80006280:	4505                	li	a0,1
    80006282:	a5cfd0ef          	jal	800034de <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80006286:	08000613          	li	a2,128
    8000628a:	f5040593          	addi	a1,s0,-176
    8000628e:	4501                	li	a0,0
    80006290:	a86fd0ef          	jal	80003516 <argstr>
    80006294:	87aa                	mv	a5,a0
    return -1;
    80006296:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80006298:	0a07c363          	bltz	a5,8000633e <sys_open+0xca>
    8000629c:	f526                	sd	s1,168(sp)

  begin_op();
    8000629e:	b05fe0ef          	jal	80004da2 <begin_op>

  if (omode & O_CREATE) {
    800062a2:	f4c42783          	lw	a5,-180(s0)
    800062a6:	2007f793          	andi	a5,a5,512
    800062aa:	c3dd                	beqz	a5,80006350 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800062ac:	4681                	li	a3,0
    800062ae:	4601                	li	a2,0
    800062b0:	4589                	li	a1,2
    800062b2:	f5040513          	addi	a0,s0,-176
    800062b6:	a13ff0ef          	jal	80005cc8 <create>
    800062ba:	84aa                	mv	s1,a0
    if (ip == 0) {
    800062bc:	c549                	beqz	a0,80006346 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    800062be:	04449703          	lh	a4,68(s1)
    800062c2:	478d                	li	a5,3
    800062c4:	00f71763          	bne	a4,a5,800062d2 <sys_open+0x5e>
    800062c8:	0464d703          	lhu	a4,70(s1)
    800062cc:	47a5                	li	a5,9
    800062ce:	0ae7ee63          	bltu	a5,a4,8000638a <sys_open+0x116>
    800062d2:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    800062d4:	eddfe0ef          	jal	800051b0 <filealloc>
    800062d8:	892a                	mv	s2,a0
    800062da:	c561                	beqz	a0,800063a2 <sys_open+0x12e>
    800062dc:	ed4e                	sd	s3,152(sp)
    800062de:	9adff0ef          	jal	80005c8a <fdalloc>
    800062e2:	89aa                	mv	s3,a0
    800062e4:	0a054b63          	bltz	a0,8000639a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    800062e8:	04449703          	lh	a4,68(s1)
    800062ec:	478d                	li	a5,3
    800062ee:	0cf70363          	beq	a4,a5,800063b4 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800062f2:	4789                	li	a5,2
    800062f4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800062f8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800062fc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006300:	f4c42783          	lw	a5,-180(s0)
    80006304:	0017f713          	andi	a4,a5,1
    80006308:	00174713          	xori	a4,a4,1
    8000630c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006310:	0037f713          	andi	a4,a5,3
    80006314:	00e03733          	snez	a4,a4
    80006318:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    8000631c:	4007f793          	andi	a5,a5,1024
    80006320:	c791                	beqz	a5,8000632c <sys_open+0xb8>
    80006322:	04449703          	lh	a4,68(s1)
    80006326:	4789                	li	a5,2
    80006328:	08f70d63          	beq	a4,a5,800063c2 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    8000632c:	8526                	mv	a0,s1
    8000632e:	8c0fe0ef          	jal	800043ee <iunlock>
  end_op();
    80006332:	af7fe0ef          	jal	80004e28 <end_op>

  return fd;
    80006336:	854e                	mv	a0,s3
    80006338:	74aa                	ld	s1,168(sp)
    8000633a:	790a                	ld	s2,160(sp)
    8000633c:	69ea                	ld	s3,152(sp)
}
    8000633e:	70ea                	ld	ra,184(sp)
    80006340:	744a                	ld	s0,176(sp)
    80006342:	6129                	addi	sp,sp,192
    80006344:	8082                	ret
      end_op();
    80006346:	ae3fe0ef          	jal	80004e28 <end_op>
      return -1;
    8000634a:	557d                	li	a0,-1
    8000634c:	74aa                	ld	s1,168(sp)
    8000634e:	bfc5                	j	8000633e <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    80006350:	f5040513          	addi	a0,s0,-176
    80006354:	875fe0ef          	jal	80004bc8 <namei>
    80006358:	84aa                	mv	s1,a0
    8000635a:	c11d                	beqz	a0,80006380 <sys_open+0x10c>
    ilock(ip);
    8000635c:	fe5fd0ef          	jal	80004340 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80006360:	04449703          	lh	a4,68(s1)
    80006364:	4785                	li	a5,1
    80006366:	f4f71ce3          	bne	a4,a5,800062be <sys_open+0x4a>
    8000636a:	f4c42783          	lw	a5,-180(s0)
    8000636e:	d3b5                	beqz	a5,800062d2 <sys_open+0x5e>
      iunlockput(ip);
    80006370:	8526                	mv	a0,s1
    80006372:	a20fe0ef          	jal	80004592 <iunlockput>
      end_op();
    80006376:	ab3fe0ef          	jal	80004e28 <end_op>
      return -1;
    8000637a:	557d                	li	a0,-1
    8000637c:	74aa                	ld	s1,168(sp)
    8000637e:	b7c1                	j	8000633e <sys_open+0xca>
      end_op();
    80006380:	aa9fe0ef          	jal	80004e28 <end_op>
      return -1;
    80006384:	557d                	li	a0,-1
    80006386:	74aa                	ld	s1,168(sp)
    80006388:	bf5d                	j	8000633e <sys_open+0xca>
    iunlockput(ip);
    8000638a:	8526                	mv	a0,s1
    8000638c:	a06fe0ef          	jal	80004592 <iunlockput>
    end_op();
    80006390:	a99fe0ef          	jal	80004e28 <end_op>
    return -1;
    80006394:	557d                	li	a0,-1
    80006396:	74aa                	ld	s1,168(sp)
    80006398:	b75d                	j	8000633e <sys_open+0xca>
      fileclose(f);
    8000639a:	854a                	mv	a0,s2
    8000639c:	eb9fe0ef          	jal	80005254 <fileclose>
    800063a0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800063a2:	8526                	mv	a0,s1
    800063a4:	9eefe0ef          	jal	80004592 <iunlockput>
    end_op();
    800063a8:	a81fe0ef          	jal	80004e28 <end_op>
    return -1;
    800063ac:	557d                	li	a0,-1
    800063ae:	74aa                	ld	s1,168(sp)
    800063b0:	790a                	ld	s2,160(sp)
    800063b2:	b771                	j	8000633e <sys_open+0xca>
    f->type = FD_DEVICE;
    800063b4:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800063b8:	04649783          	lh	a5,70(s1)
    800063bc:	02f91223          	sh	a5,36(s2)
    800063c0:	bf35                	j	800062fc <sys_open+0x88>
    itrunc(ip);
    800063c2:	8526                	mv	a0,s1
    800063c4:	86afe0ef          	jal	8000442e <itrunc>
    800063c8:	b795                	j	8000632c <sys_open+0xb8>

00000000800063ca <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800063ca:	7175                	addi	sp,sp,-144
    800063cc:	e506                	sd	ra,136(sp)
    800063ce:	e122                	sd	s0,128(sp)
    800063d0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800063d2:	9d1fe0ef          	jal	80004da2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    800063d6:	08000613          	li	a2,128
    800063da:	f7040593          	addi	a1,s0,-144
    800063de:	4501                	li	a0,0
    800063e0:	936fd0ef          	jal	80003516 <argstr>
    800063e4:	02054363          	bltz	a0,8000640a <sys_mkdir+0x40>
    800063e8:	4681                	li	a3,0
    800063ea:	4601                	li	a2,0
    800063ec:	4585                	li	a1,1
    800063ee:	f7040513          	addi	a0,s0,-144
    800063f2:	8d7ff0ef          	jal	80005cc8 <create>
    800063f6:	c911                	beqz	a0,8000640a <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800063f8:	99afe0ef          	jal	80004592 <iunlockput>
  end_op();
    800063fc:	a2dfe0ef          	jal	80004e28 <end_op>
  return 0;
    80006400:	4501                	li	a0,0
}
    80006402:	60aa                	ld	ra,136(sp)
    80006404:	640a                	ld	s0,128(sp)
    80006406:	6149                	addi	sp,sp,144
    80006408:	8082                	ret
    end_op();
    8000640a:	a1ffe0ef          	jal	80004e28 <end_op>
    return -1;
    8000640e:	557d                	li	a0,-1
    80006410:	bfcd                	j	80006402 <sys_mkdir+0x38>

0000000080006412 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006412:	7135                	addi	sp,sp,-160
    80006414:	ed06                	sd	ra,152(sp)
    80006416:	e922                	sd	s0,144(sp)
    80006418:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000641a:	989fe0ef          	jal	80004da2 <begin_op>
  argint(1, &major);
    8000641e:	f6c40593          	addi	a1,s0,-148
    80006422:	4505                	li	a0,1
    80006424:	8bafd0ef          	jal	800034de <argint>
  argint(2, &minor);
    80006428:	f6840593          	addi	a1,s0,-152
    8000642c:	4509                	li	a0,2
    8000642e:	8b0fd0ef          	jal	800034de <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006432:	08000613          	li	a2,128
    80006436:	f7040593          	addi	a1,s0,-144
    8000643a:	4501                	li	a0,0
    8000643c:	8dafd0ef          	jal	80003516 <argstr>
    80006440:	02054563          	bltz	a0,8000646a <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80006444:	f6841683          	lh	a3,-152(s0)
    80006448:	f6c41603          	lh	a2,-148(s0)
    8000644c:	458d                	li	a1,3
    8000644e:	f7040513          	addi	a0,s0,-144
    80006452:	877ff0ef          	jal	80005cc8 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006456:	c911                	beqz	a0,8000646a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006458:	93afe0ef          	jal	80004592 <iunlockput>
  end_op();
    8000645c:	9cdfe0ef          	jal	80004e28 <end_op>
  return 0;
    80006460:	4501                	li	a0,0
}
    80006462:	60ea                	ld	ra,152(sp)
    80006464:	644a                	ld	s0,144(sp)
    80006466:	610d                	addi	sp,sp,160
    80006468:	8082                	ret
    end_op();
    8000646a:	9bffe0ef          	jal	80004e28 <end_op>
    return -1;
    8000646e:	557d                	li	a0,-1
    80006470:	bfcd                	j	80006462 <sys_mknod+0x50>

0000000080006472 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006472:	7135                	addi	sp,sp,-160
    80006474:	ed06                	sd	ra,152(sp)
    80006476:	e922                	sd	s0,144(sp)
    80006478:	e14a                	sd	s2,128(sp)
    8000647a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000647c:	b7bfb0ef          	jal	80001ff6 <myproc>
    80006480:	892a                	mv	s2,a0

  begin_op();
    80006482:	921fe0ef          	jal	80004da2 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80006486:	08000613          	li	a2,128
    8000648a:	f6040593          	addi	a1,s0,-160
    8000648e:	4501                	li	a0,0
    80006490:	886fd0ef          	jal	80003516 <argstr>
    80006494:	04054363          	bltz	a0,800064da <sys_chdir+0x68>
    80006498:	e526                	sd	s1,136(sp)
    8000649a:	f6040513          	addi	a0,s0,-160
    8000649e:	f2afe0ef          	jal	80004bc8 <namei>
    800064a2:	84aa                	mv	s1,a0
    800064a4:	c915                	beqz	a0,800064d8 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800064a6:	e9bfd0ef          	jal	80004340 <ilock>
  if (ip->type != T_DIR) {
    800064aa:	04449703          	lh	a4,68(s1)
    800064ae:	4785                	li	a5,1
    800064b0:	02f71963          	bne	a4,a5,800064e2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800064b4:	8526                	mv	a0,s1
    800064b6:	f39fd0ef          	jal	800043ee <iunlock>
  iput(p->cwd);
    800064ba:	17893503          	ld	a0,376(s2)
    800064be:	804fe0ef          	jal	800044c2 <iput>
  end_op();
    800064c2:	967fe0ef          	jal	80004e28 <end_op>
  p->cwd = ip;
    800064c6:	16993c23          	sd	s1,376(s2)
  return 0;
    800064ca:	4501                	li	a0,0
    800064cc:	64aa                	ld	s1,136(sp)
}
    800064ce:	60ea                	ld	ra,152(sp)
    800064d0:	644a                	ld	s0,144(sp)
    800064d2:	690a                	ld	s2,128(sp)
    800064d4:	610d                	addi	sp,sp,160
    800064d6:	8082                	ret
    800064d8:	64aa                	ld	s1,136(sp)
    end_op();
    800064da:	94ffe0ef          	jal	80004e28 <end_op>
    return -1;
    800064de:	557d                	li	a0,-1
    800064e0:	b7fd                	j	800064ce <sys_chdir+0x5c>
    iunlockput(ip);
    800064e2:	8526                	mv	a0,s1
    800064e4:	8aefe0ef          	jal	80004592 <iunlockput>
    end_op();
    800064e8:	941fe0ef          	jal	80004e28 <end_op>
    return -1;
    800064ec:	557d                	li	a0,-1
    800064ee:	64aa                	ld	s1,136(sp)
    800064f0:	bff9                	j	800064ce <sys_chdir+0x5c>

00000000800064f2 <sys_exec>:

uint64
sys_exec(void)
{
    800064f2:	7105                	addi	sp,sp,-480
    800064f4:	ef86                	sd	ra,472(sp)
    800064f6:	eba2                	sd	s0,464(sp)
    800064f8:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800064fa:	e2840593          	addi	a1,s0,-472
    800064fe:	4505                	li	a0,1
    80006500:	ffbfc0ef          	jal	800034fa <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80006504:	08000613          	li	a2,128
    80006508:	f3040593          	addi	a1,s0,-208
    8000650c:	4501                	li	a0,0
    8000650e:	808fd0ef          	jal	80003516 <argstr>
    80006512:	87aa                	mv	a5,a0
    return -1;
    80006514:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80006516:	0e07c063          	bltz	a5,800065f6 <sys_exec+0x104>
    8000651a:	e7a6                	sd	s1,456(sp)
    8000651c:	e3ca                	sd	s2,448(sp)
    8000651e:	ff4e                	sd	s3,440(sp)
    80006520:	fb52                	sd	s4,432(sp)
    80006522:	f756                	sd	s5,424(sp)
    80006524:	f35a                	sd	s6,416(sp)
    80006526:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006528:	e3040a13          	addi	s4,s0,-464
    8000652c:	10000613          	li	a2,256
    80006530:	4581                	li	a1,0
    80006532:	8552                	mv	a0,s4
    80006534:	8affa0ef          	jal	80000de2 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80006538:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    8000653a:	89d2                	mv	s3,s4
    8000653c:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    8000653e:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006542:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80006544:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80006548:	00391513          	slli	a0,s2,0x3
    8000654c:	85d6                	mv	a1,s5
    8000654e:	e2843783          	ld	a5,-472(s0)
    80006552:	953e                	add	a0,a0,a5
    80006554:	efffc0ef          	jal	80003452 <fetchaddr>
    80006558:	02054663          	bltz	a0,80006584 <sys_exec+0x92>
    if (uarg == 0) {
    8000655c:	e2043783          	ld	a5,-480(s0)
    80006560:	c7a1                	beqz	a5,800065a8 <sys_exec+0xb6>
    argv[i] = kalloc();
    80006562:	dd2fa0ef          	jal	80000b34 <kalloc>
    80006566:	85aa                	mv	a1,a0
    80006568:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    8000656c:	cd01                	beqz	a0,80006584 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000656e:	865a                	mv	a2,s6
    80006570:	e2043503          	ld	a0,-480(s0)
    80006574:	f29fc0ef          	jal	8000349c <fetchstr>
    80006578:	00054663          	bltz	a0,80006584 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    8000657c:	0905                	addi	s2,s2,1
    8000657e:	09a1                	addi	s3,s3,8
    80006580:	fd7914e3          	bne	s2,s7,80006548 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006584:	100a0a13          	addi	s4,s4,256 # fffffffffffff100 <end+0xffffffff7fdae798>
    80006588:	6088                	ld	a0,0(s1)
    8000658a:	cd31                	beqz	a0,800065e6 <sys_exec+0xf4>
    kfree(argv[i]);
    8000658c:	c54fa0ef          	jal	800009e0 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006590:	04a1                	addi	s1,s1,8
    80006592:	ff449be3          	bne	s1,s4,80006588 <sys_exec+0x96>
  return -1;
    80006596:	557d                	li	a0,-1
    80006598:	64be                	ld	s1,456(sp)
    8000659a:	691e                	ld	s2,448(sp)
    8000659c:	79fa                	ld	s3,440(sp)
    8000659e:	7a5a                	ld	s4,432(sp)
    800065a0:	7aba                	ld	s5,424(sp)
    800065a2:	7b1a                	ld	s6,416(sp)
    800065a4:	6bfa                	ld	s7,408(sp)
    800065a6:	a881                	j	800065f6 <sys_exec+0x104>
      argv[i] = 0;
    800065a8:	0009079b          	sext.w	a5,s2
    800065ac:	e3040593          	addi	a1,s0,-464
    800065b0:	078e                	slli	a5,a5,0x3
    800065b2:	97ae                	add	a5,a5,a1
    800065b4:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800065b8:	f3040513          	addi	a0,s0,-208
    800065bc:	b20ff0ef          	jal	800058dc <kexec>
    800065c0:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800065c2:	100a0a13          	addi	s4,s4,256
    800065c6:	6088                	ld	a0,0(s1)
    800065c8:	c511                	beqz	a0,800065d4 <sys_exec+0xe2>
    kfree(argv[i]);
    800065ca:	c16fa0ef          	jal	800009e0 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800065ce:	04a1                	addi	s1,s1,8
    800065d0:	ff449be3          	bne	s1,s4,800065c6 <sys_exec+0xd4>
  return ret;
    800065d4:	854a                	mv	a0,s2
    800065d6:	64be                	ld	s1,456(sp)
    800065d8:	691e                	ld	s2,448(sp)
    800065da:	79fa                	ld	s3,440(sp)
    800065dc:	7a5a                	ld	s4,432(sp)
    800065de:	7aba                	ld	s5,424(sp)
    800065e0:	7b1a                	ld	s6,416(sp)
    800065e2:	6bfa                	ld	s7,408(sp)
    800065e4:	a809                	j	800065f6 <sys_exec+0x104>
  return -1;
    800065e6:	557d                	li	a0,-1
    800065e8:	64be                	ld	s1,456(sp)
    800065ea:	691e                	ld	s2,448(sp)
    800065ec:	79fa                	ld	s3,440(sp)
    800065ee:	7a5a                	ld	s4,432(sp)
    800065f0:	7aba                	ld	s5,424(sp)
    800065f2:	7b1a                	ld	s6,416(sp)
    800065f4:	6bfa                	ld	s7,408(sp)
}
    800065f6:	60fe                	ld	ra,472(sp)
    800065f8:	645e                	ld	s0,464(sp)
    800065fa:	613d                	addi	sp,sp,480
    800065fc:	8082                	ret

00000000800065fe <sys_pipe>:

uint64
sys_pipe(void)
{
    800065fe:	7139                	addi	sp,sp,-64
    80006600:	fc06                	sd	ra,56(sp)
    80006602:	f822                	sd	s0,48(sp)
    80006604:	f426                	sd	s1,40(sp)
    80006606:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006608:	9effb0ef          	jal	80001ff6 <myproc>
    8000660c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000660e:	fd840593          	addi	a1,s0,-40
    80006612:	4501                	li	a0,0
    80006614:	ee7fc0ef          	jal	800034fa <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80006618:	fc840593          	addi	a1,s0,-56
    8000661c:	fd040513          	addi	a0,s0,-48
    80006620:	f5bfe0ef          	jal	8000557a <pipealloc>
    return -1;
    80006624:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80006626:	0a054663          	bltz	a0,800066d2 <sys_pipe+0xd4>
  fd0 = -1;
    8000662a:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    8000662e:	fd043503          	ld	a0,-48(s0)
    80006632:	e58ff0ef          	jal	80005c8a <fdalloc>
    80006636:	fca42223          	sw	a0,-60(s0)
    8000663a:	08054363          	bltz	a0,800066c0 <sys_pipe+0xc2>
    8000663e:	fc843503          	ld	a0,-56(s0)
    80006642:	e48ff0ef          	jal	80005c8a <fdalloc>
    80006646:	fca42023          	sw	a0,-64(s0)
    8000664a:	06054263          	bltz	a0,800066ae <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000664e:	4711                	li	a4,4
    80006650:	fc440693          	addi	a3,s0,-60
    80006654:	fd843603          	ld	a2,-40(s0)
    80006658:	78ac                	ld	a1,112(s1)
    8000665a:	7ca8                	ld	a0,120(s1)
    8000665c:	b40fb0ef          	jal	8000199c <copyout>
    80006660:	00054f63          	bltz	a0,8000667e <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80006664:	4711                	li	a4,4
    80006666:	fc040693          	addi	a3,s0,-64
    8000666a:	fd843603          	ld	a2,-40(s0)
    8000666e:	963a                	add	a2,a2,a4
    80006670:	78ac                	ld	a1,112(s1)
    80006672:	7ca8                	ld	a0,120(s1)
    80006674:	b28fb0ef          	jal	8000199c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006678:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000667a:	04055c63          	bgez	a0,800066d2 <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    8000667e:	fc442783          	lw	a5,-60(s0)
    80006682:	07f9                	addi	a5,a5,30
    80006684:	078e                	slli	a5,a5,0x3
    80006686:	97a6                	add	a5,a5,s1
    80006688:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    8000668c:	fc042783          	lw	a5,-64(s0)
    80006690:	07f9                	addi	a5,a5,30
    80006692:	078e                	slli	a5,a5,0x3
    80006694:	94be                	add	s1,s1,a5
    80006696:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000669a:	fd043503          	ld	a0,-48(s0)
    8000669e:	bb7fe0ef          	jal	80005254 <fileclose>
    fileclose(wf);
    800066a2:	fc843503          	ld	a0,-56(s0)
    800066a6:	baffe0ef          	jal	80005254 <fileclose>
    return -1;
    800066aa:	57fd                	li	a5,-1
    800066ac:	a01d                	j	800066d2 <sys_pipe+0xd4>
    if (fd0 >= 0)
    800066ae:	fc442783          	lw	a5,-60(s0)
    800066b2:	0007c763          	bltz	a5,800066c0 <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    800066b6:	07f9                	addi	a5,a5,30
    800066b8:	078e                	slli	a5,a5,0x3
    800066ba:	97a6                	add	a5,a5,s1
    800066bc:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800066c0:	fd043503          	ld	a0,-48(s0)
    800066c4:	b91fe0ef          	jal	80005254 <fileclose>
    fileclose(wf);
    800066c8:	fc843503          	ld	a0,-56(s0)
    800066cc:	b89fe0ef          	jal	80005254 <fileclose>
    return -1;
    800066d0:	57fd                	li	a5,-1
}
    800066d2:	853e                	mv	a0,a5
    800066d4:	70e2                	ld	ra,56(sp)
    800066d6:	7442                	ld	s0,48(sp)
    800066d8:	74a2                	ld	s1,40(sp)
    800066da:	6121                	addi	sp,sp,64
    800066dc:	8082                	ret
	...

00000000800066e0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800066e0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800066e2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800066e4:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    800066e6:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800066e8:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800066ea:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800066ec:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800066ee:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800066f0:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800066f2:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800066f4:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800066f6:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800066f8:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800066fa:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800066fc:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800066fe:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80006700:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80006702:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80006704:	c55fc0ef          	jal	80003358 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80006708:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000670a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000670c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000670e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80006710:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80006712:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80006714:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80006716:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80006718:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000671a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000671c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000671e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80006720:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80006722:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80006724:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80006726:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80006728:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000672a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000672c:	10200073          	sret
    80006730:	0001                	nop
    80006732:	00000013          	nop
    80006736:	00000013          	nop
    8000673a:	00000013          	nop

000000008000673e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000673e:	1141                	addi	sp,sp,-16
    80006740:	e406                	sd	ra,8(sp)
    80006742:	e022                	sd	s0,0(sp)
    80006744:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80006746:	0c000737          	lui	a4,0xc000
    8000674a:	4785                	li	a5,1
    8000674c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000674e:	c35c                	sw	a5,4(a4)
}
    80006750:	60a2                	ld	ra,8(sp)
    80006752:	6402                	ld	s0,0(sp)
    80006754:	0141                	addi	sp,sp,16
    80006756:	8082                	ret

0000000080006758 <plicinithart>:

void
plicinithart(void)
{
    80006758:	1141                	addi	sp,sp,-16
    8000675a:	e406                	sd	ra,8(sp)
    8000675c:	e022                	sd	s0,0(sp)
    8000675e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006760:	863fb0ef          	jal	80001fc2 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006764:	0085171b          	slliw	a4,a0,0x8
    80006768:	0c0027b7          	lui	a5,0xc002
    8000676c:	97ba                	add	a5,a5,a4
    8000676e:	40200713          	li	a4,1026
    80006772:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80006776:	00d5151b          	slliw	a0,a0,0xd
    8000677a:	0c2017b7          	lui	a5,0xc201
    8000677e:	97aa                	add	a5,a5,a0
    80006780:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006784:	60a2                	ld	ra,8(sp)
    80006786:	6402                	ld	s0,0(sp)
    80006788:	0141                	addi	sp,sp,16
    8000678a:	8082                	ret

000000008000678c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000678c:	1141                	addi	sp,sp,-16
    8000678e:	e406                	sd	ra,8(sp)
    80006790:	e022                	sd	s0,0(sp)
    80006792:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006794:	82ffb0ef          	jal	80001fc2 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80006798:	00d5151b          	slliw	a0,a0,0xd
    8000679c:	0c2017b7          	lui	a5,0xc201
    800067a0:	97aa                	add	a5,a5,a0
  return irq;
}
    800067a2:	43c8                	lw	a0,4(a5)
    800067a4:	60a2                	ld	ra,8(sp)
    800067a6:	6402                	ld	s0,0(sp)
    800067a8:	0141                	addi	sp,sp,16
    800067aa:	8082                	ret

00000000800067ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800067ac:	1101                	addi	sp,sp,-32
    800067ae:	ec06                	sd	ra,24(sp)
    800067b0:	e822                	sd	s0,16(sp)
    800067b2:	e426                	sd	s1,8(sp)
    800067b4:	1000                	addi	s0,sp,32
    800067b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800067b8:	80bfb0ef          	jal	80001fc2 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800067bc:	00d5179b          	slliw	a5,a0,0xd
    800067c0:	0c201737          	lui	a4,0xc201
    800067c4:	97ba                	add	a5,a5,a4
    800067c6:	c3c4                	sw	s1,4(a5)
}
    800067c8:	60e2                	ld	ra,24(sp)
    800067ca:	6442                	ld	s0,16(sp)
    800067cc:	64a2                	ld	s1,8(sp)
    800067ce:	6105                	addi	sp,sp,32
    800067d0:	8082                	ret

00000000800067d2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800067d2:	1141                	addi	sp,sp,-16
    800067d4:	e406                	sd	ra,8(sp)
    800067d6:	e022                	sd	s0,0(sp)
    800067d8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800067da:	479d                	li	a5,7
    800067dc:	04a7ca63          	blt	a5,a0,80006830 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    800067e0:	0024a797          	auipc	a5,0x24a
    800067e4:	04878793          	addi	a5,a5,72 # 80250828 <disk>
    800067e8:	97aa                	add	a5,a5,a0
    800067ea:	0187c783          	lbu	a5,24(a5)
    800067ee:	e7b9                	bnez	a5,8000683c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800067f0:	00451693          	slli	a3,a0,0x4
    800067f4:	0024a797          	auipc	a5,0x24a
    800067f8:	03478793          	addi	a5,a5,52 # 80250828 <disk>
    800067fc:	6398                	ld	a4,0(a5)
    800067fe:	9736                	add	a4,a4,a3
    80006800:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006804:	6398                	ld	a4,0(a5)
    80006806:	9736                	add	a4,a4,a3
    80006808:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000680c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006810:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006814:	97aa                	add	a5,a5,a0
    80006816:	4705                	li	a4,1
    80006818:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000681c:	0024a517          	auipc	a0,0x24a
    80006820:	02450513          	addi	a0,a0,36 # 80250840 <disk+0x18>
    80006824:	f9bfb0ef          	jal	800027be <wakeup>
}
    80006828:	60a2                	ld	ra,8(sp)
    8000682a:	6402                	ld	s0,0(sp)
    8000682c:	0141                	addi	sp,sp,16
    8000682e:	8082                	ret
    panic("free_desc 1");
    80006830:	00002517          	auipc	a0,0x2
    80006834:	fd050513          	addi	a0,a0,-48 # 80008800 <etext+0x800>
    80006838:	fb7f90ef          	jal	800007ee <panic>
    panic("free_desc 2");
    8000683c:	00002517          	auipc	a0,0x2
    80006840:	fd450513          	addi	a0,a0,-44 # 80008810 <etext+0x810>
    80006844:	fabf90ef          	jal	800007ee <panic>

0000000080006848 <virtio_disk_init>:
{
    80006848:	1101                	addi	sp,sp,-32
    8000684a:	ec06                	sd	ra,24(sp)
    8000684c:	e822                	sd	s0,16(sp)
    8000684e:	e426                	sd	s1,8(sp)
    80006850:	e04a                	sd	s2,0(sp)
    80006852:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006854:	00002597          	auipc	a1,0x2
    80006858:	fcc58593          	addi	a1,a1,-52 # 80008820 <etext+0x820>
    8000685c:	0024a517          	auipc	a0,0x24a
    80006860:	0f450513          	addi	a0,a0,244 # 80250950 <disk+0x128>
    80006864:	c44fa0ef          	jal	80000ca8 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006868:	100017b7          	lui	a5,0x10001
    8000686c:	4398                	lw	a4,0(a5)
    8000686e:	2701                	sext.w	a4,a4
    80006870:	747277b7          	lui	a5,0x74727
    80006874:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006878:	14f71863          	bne	a4,a5,800069c8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000687c:	100017b7          	lui	a5,0x10001
    80006880:	43dc                	lw	a5,4(a5)
    80006882:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006884:	4709                	li	a4,2
    80006886:	14e79163          	bne	a5,a4,800069c8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000688a:	100017b7          	lui	a5,0x10001
    8000688e:	479c                	lw	a5,8(a5)
    80006890:	2781                	sext.w	a5,a5
    80006892:	12e79b63          	bne	a5,a4,800069c8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80006896:	100017b7          	lui	a5,0x10001
    8000689a:	47d8                	lw	a4,12(a5)
    8000689c:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000689e:	554d47b7          	lui	a5,0x554d4
    800068a2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800068a6:	12f71163          	bne	a4,a5,800069c8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800068aa:	100017b7          	lui	a5,0x10001
    800068ae:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800068b2:	4705                	li	a4,1
    800068b4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800068b6:	470d                	li	a4,3
    800068b8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800068ba:	10001737          	lui	a4,0x10001
    800068be:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800068c0:	c7ffe6b7          	lui	a3,0xc7ffe
    800068c4:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47dadbf7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800068c8:	8f75                	and	a4,a4,a3
    800068ca:	100016b7          	lui	a3,0x10001
    800068ce:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800068d0:	472d                	li	a4,11
    800068d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800068d4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800068d8:	439c                	lw	a5,0(a5)
    800068da:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800068de:	8ba1                	andi	a5,a5,8
    800068e0:	0e078a63          	beqz	a5,800069d4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800068e4:	100017b7          	lui	a5,0x10001
    800068e8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800068ec:	43fc                	lw	a5,68(a5)
    800068ee:	2781                	sext.w	a5,a5
    800068f0:	0e079863          	bnez	a5,800069e0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800068f4:	100017b7          	lui	a5,0x10001
    800068f8:	5bdc                	lw	a5,52(a5)
    800068fa:	2781                	sext.w	a5,a5
  if (max == 0)
    800068fc:	0e078863          	beqz	a5,800069ec <virtio_disk_init+0x1a4>
  if (max < NUM)
    80006900:	471d                	li	a4,7
    80006902:	0ef77b63          	bgeu	a4,a5,800069f8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80006906:	a2efa0ef          	jal	80000b34 <kalloc>
    8000690a:	0024a497          	auipc	s1,0x24a
    8000690e:	f1e48493          	addi	s1,s1,-226 # 80250828 <disk>
    80006912:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006914:	a20fa0ef          	jal	80000b34 <kalloc>
    80006918:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000691a:	a1afa0ef          	jal	80000b34 <kalloc>
    8000691e:	87aa                	mv	a5,a0
    80006920:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80006922:	6088                	ld	a0,0(s1)
    80006924:	0e050063          	beqz	a0,80006a04 <virtio_disk_init+0x1bc>
    80006928:	0024a717          	auipc	a4,0x24a
    8000692c:	f0873703          	ld	a4,-248(a4) # 80250830 <disk+0x8>
    80006930:	cb71                	beqz	a4,80006a04 <virtio_disk_init+0x1bc>
    80006932:	cbe9                	beqz	a5,80006a04 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006934:	6605                	lui	a2,0x1
    80006936:	4581                	li	a1,0
    80006938:	caafa0ef          	jal	80000de2 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000693c:	0024a497          	auipc	s1,0x24a
    80006940:	eec48493          	addi	s1,s1,-276 # 80250828 <disk>
    80006944:	6605                	lui	a2,0x1
    80006946:	4581                	li	a1,0
    80006948:	6488                	ld	a0,8(s1)
    8000694a:	c98fa0ef          	jal	80000de2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000694e:	6605                	lui	a2,0x1
    80006950:	4581                	li	a1,0
    80006952:	6888                	ld	a0,16(s1)
    80006954:	c8efa0ef          	jal	80000de2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006958:	100017b7          	lui	a5,0x10001
    8000695c:	4721                	li	a4,8
    8000695e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006960:	4098                	lw	a4,0(s1)
    80006962:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006966:	40d8                	lw	a4,4(s1)
    80006968:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000696c:	649c                	ld	a5,8(s1)
    8000696e:	0007869b          	sext.w	a3,a5
    80006972:	10001737          	lui	a4,0x10001
    80006976:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000697a:	9781                	srai	a5,a5,0x20
    8000697c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006980:	689c                	ld	a5,16(s1)
    80006982:	0007869b          	sext.w	a3,a5
    80006986:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000698a:	9781                	srai	a5,a5,0x20
    8000698c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006990:	4785                	li	a5,1
    80006992:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006994:	00f48c23          	sb	a5,24(s1)
    80006998:	00f48ca3          	sb	a5,25(s1)
    8000699c:	00f48d23          	sb	a5,26(s1)
    800069a0:	00f48da3          	sb	a5,27(s1)
    800069a4:	00f48e23          	sb	a5,28(s1)
    800069a8:	00f48ea3          	sb	a5,29(s1)
    800069ac:	00f48f23          	sb	a5,30(s1)
    800069b0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800069b4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800069b8:	07272823          	sw	s2,112(a4)
}
    800069bc:	60e2                	ld	ra,24(sp)
    800069be:	6442                	ld	s0,16(sp)
    800069c0:	64a2                	ld	s1,8(sp)
    800069c2:	6902                	ld	s2,0(sp)
    800069c4:	6105                	addi	sp,sp,32
    800069c6:	8082                	ret
    panic("could not find virtio disk");
    800069c8:	00002517          	auipc	a0,0x2
    800069cc:	e6850513          	addi	a0,a0,-408 # 80008830 <etext+0x830>
    800069d0:	e1ff90ef          	jal	800007ee <panic>
    panic("virtio disk FEATURES_OK unset");
    800069d4:	00002517          	auipc	a0,0x2
    800069d8:	e7c50513          	addi	a0,a0,-388 # 80008850 <etext+0x850>
    800069dc:	e13f90ef          	jal	800007ee <panic>
    panic("virtio disk should not be ready");
    800069e0:	00002517          	auipc	a0,0x2
    800069e4:	e9050513          	addi	a0,a0,-368 # 80008870 <etext+0x870>
    800069e8:	e07f90ef          	jal	800007ee <panic>
    panic("virtio disk has no queue 0");
    800069ec:	00002517          	auipc	a0,0x2
    800069f0:	ea450513          	addi	a0,a0,-348 # 80008890 <etext+0x890>
    800069f4:	dfbf90ef          	jal	800007ee <panic>
    panic("virtio disk max queue too short");
    800069f8:	00002517          	auipc	a0,0x2
    800069fc:	eb850513          	addi	a0,a0,-328 # 800088b0 <etext+0x8b0>
    80006a00:	deff90ef          	jal	800007ee <panic>
    panic("virtio disk kalloc");
    80006a04:	00002517          	auipc	a0,0x2
    80006a08:	ecc50513          	addi	a0,a0,-308 # 800088d0 <etext+0x8d0>
    80006a0c:	de3f90ef          	jal	800007ee <panic>

0000000080006a10 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006a10:	711d                	addi	sp,sp,-96
    80006a12:	ec86                	sd	ra,88(sp)
    80006a14:	e8a2                	sd	s0,80(sp)
    80006a16:	e4a6                	sd	s1,72(sp)
    80006a18:	e0ca                	sd	s2,64(sp)
    80006a1a:	fc4e                	sd	s3,56(sp)
    80006a1c:	f852                	sd	s4,48(sp)
    80006a1e:	f456                	sd	s5,40(sp)
    80006a20:	f05a                	sd	s6,32(sp)
    80006a22:	ec5e                	sd	s7,24(sp)
    80006a24:	e862                	sd	s8,16(sp)
    80006a26:	1080                	addi	s0,sp,96
    80006a28:	89aa                	mv	s3,a0
    80006a2a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006a2c:	00c52b83          	lw	s7,12(a0)
    80006a30:	001b9b9b          	slliw	s7,s7,0x1
    80006a34:	1b82                	slli	s7,s7,0x20
    80006a36:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006a3a:	0024a517          	auipc	a0,0x24a
    80006a3e:	f1650513          	addi	a0,a0,-234 # 80250950 <disk+0x128>
    80006a42:	ae0fa0ef          	jal	80000d22 <acquire>
  for (int i = 0; i < NUM; i++) {
    80006a46:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006a48:	0024aa97          	auipc	s5,0x24a
    80006a4c:	de0a8a93          	addi	s5,s5,-544 # 80250828 <disk>
  for (int i = 0; i < 3; i++) {
    80006a50:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006a52:	5c7d                	li	s8,-1
    80006a54:	a895                	j	80006ac8 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006a56:	00fa8733          	add	a4,s5,a5
    80006a5a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80006a5e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80006a60:	0207c563          	bltz	a5,80006a8a <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80006a64:	2905                	addiw	s2,s2,1
    80006a66:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006a68:	07490463          	beq	s2,s4,80006ad0 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006a6c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80006a6e:	0024a717          	auipc	a4,0x24a
    80006a72:	dba70713          	addi	a4,a4,-582 # 80250828 <disk>
    80006a76:	4781                	li	a5,0
    if (disk.free[i]) {
    80006a78:	01874683          	lbu	a3,24(a4)
    80006a7c:	fee9                	bnez	a3,80006a56 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80006a7e:	2785                	addiw	a5,a5,1
    80006a80:	0705                	addi	a4,a4,1
    80006a82:	fe979be3          	bne	a5,s1,80006a78 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80006a86:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80006a8a:	01205d63          	blez	s2,80006aa4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80006a8e:	fa042503          	lw	a0,-96(s0)
    80006a92:	d41ff0ef          	jal	800067d2 <free_desc>
      for (int j = 0; j < i; j++)
    80006a96:	4785                	li	a5,1
    80006a98:	0127d663          	bge	a5,s2,80006aa4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80006a9c:	fa442503          	lw	a0,-92(s0)
    80006aa0:	d33ff0ef          	jal	800067d2 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80006aa4:	0024a517          	auipc	a0,0x24a
    80006aa8:	d9c50513          	addi	a0,a0,-612 # 80250840 <disk+0x18>
    80006aac:	ca7fb0ef          	jal	80002752 <sleep_prepare>
    release(&disk.vdisk_lock);
    80006ab0:	0024a917          	auipc	s2,0x24a
    80006ab4:	ea090913          	addi	s2,s2,-352 # 80250950 <disk+0x128>
    80006ab8:	854a                	mv	a0,s2
    80006aba:	af0fa0ef          	jal	80000daa <release>
    sleep();
    80006abe:	cd1fb0ef          	jal	8000278e <sleep>
    acquire(&disk.vdisk_lock);
    80006ac2:	854a                	mv	a0,s2
    80006ac4:	a5efa0ef          	jal	80000d22 <acquire>
  for (int i = 0; i < 3; i++) {
    80006ac8:	fa040613          	addi	a2,s0,-96
    80006acc:	4901                	li	s2,0
    80006ace:	bf79                	j	80006a6c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006ad0:	fa042503          	lw	a0,-96(s0)
    80006ad4:	00451693          	slli	a3,a0,0x4

  if (write)
    80006ad8:	0024a797          	auipc	a5,0x24a
    80006adc:	d5078793          	addi	a5,a5,-688 # 80250828 <disk>
    80006ae0:	00a50713          	addi	a4,a0,10
    80006ae4:	0712                	slli	a4,a4,0x4
    80006ae6:	973e                	add	a4,a4,a5
    80006ae8:	01603633          	snez	a2,s6
    80006aec:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006aee:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006af2:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80006af6:	6398                	ld	a4,0(a5)
    80006af8:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006afa:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006afe:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80006b00:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006b02:	6390                	ld	a2,0(a5)
    80006b04:	00d605b3          	add	a1,a2,a3
    80006b08:	4741                	li	a4,16
    80006b0a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006b0c:	4805                	li	a6,1
    80006b0e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006b12:	fa442703          	lw	a4,-92(s0)
    80006b16:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80006b1a:	0712                	slli	a4,a4,0x4
    80006b1c:	963a                	add	a2,a2,a4
    80006b1e:	05898593          	addi	a1,s3,88
    80006b22:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006b24:	0007b883          	ld	a7,0(a5)
    80006b28:	9746                	add	a4,a4,a7
    80006b2a:	40000613          	li	a2,1024
    80006b2e:	c710                	sw	a2,8(a4)
  if (write)
    80006b30:	001b3613          	seqz	a2,s6
    80006b34:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006b38:	01066633          	or	a2,a2,a6
    80006b3c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006b40:	fa842583          	lw	a1,-88(s0)
    80006b44:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006b48:	00250613          	addi	a2,a0,2
    80006b4c:	0612                	slli	a2,a2,0x4
    80006b4e:	963e                	add	a2,a2,a5
    80006b50:	577d                	li	a4,-1
    80006b52:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80006b56:	0592                	slli	a1,a1,0x4
    80006b58:	98ae                	add	a7,a7,a1
    80006b5a:	03068713          	addi	a4,a3,48
    80006b5e:	973e                	add	a4,a4,a5
    80006b60:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006b64:	6398                	ld	a4,0(a5)
    80006b66:	972e                	add	a4,a4,a1
    80006b68:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006b6c:	4689                	li	a3,2
    80006b6e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006b72:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006b76:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80006b7a:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006b7e:	6794                	ld	a3,8(a5)
    80006b80:	0026d703          	lhu	a4,2(a3)
    80006b84:	8b1d                	andi	a4,a4,7
    80006b86:	0706                	slli	a4,a4,0x1
    80006b88:	96ba                	add	a3,a3,a4
    80006b8a:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80006b8e:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006b92:	6798                	ld	a4,8(a5)
    80006b94:	00275783          	lhu	a5,2(a4)
    80006b98:	2785                	addiw	a5,a5,1
    80006b9a:	00f71123          	sh	a5,2(a4)
    80006b9e:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006ba2:	100017b7          	lui	a5,0x10001
    80006ba6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80006baa:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80006bae:	0024a497          	auipc	s1,0x24a
    80006bb2:	da248493          	addi	s1,s1,-606 # 80250950 <disk+0x128>
  while (b->disk == 1) {
    80006bb6:	8942                	mv	s2,a6
    80006bb8:	03079163          	bne	a5,a6,80006bda <virtio_disk_rw+0x1ca>
    sleep_prepare(b);
    80006bbc:	854e                	mv	a0,s3
    80006bbe:	b95fb0ef          	jal	80002752 <sleep_prepare>
    release(&disk.vdisk_lock);
    80006bc2:	8526                	mv	a0,s1
    80006bc4:	9e6fa0ef          	jal	80000daa <release>
    sleep();
    80006bc8:	bc7fb0ef          	jal	8000278e <sleep>
    acquire(&disk.vdisk_lock);
    80006bcc:	8526                	mv	a0,s1
    80006bce:	954fa0ef          	jal	80000d22 <acquire>
  while (b->disk == 1) {
    80006bd2:	0049a783          	lw	a5,4(s3)
    80006bd6:	ff2783e3          	beq	a5,s2,80006bbc <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    80006bda:	fa042903          	lw	s2,-96(s0)
    80006bde:	00290713          	addi	a4,s2,2
    80006be2:	0712                	slli	a4,a4,0x4
    80006be4:	0024a797          	auipc	a5,0x24a
    80006be8:	c4478793          	addi	a5,a5,-956 # 80250828 <disk>
    80006bec:	97ba                	add	a5,a5,a4
    80006bee:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006bf2:	0024a997          	auipc	s3,0x24a
    80006bf6:	c3698993          	addi	s3,s3,-970 # 80250828 <disk>
    80006bfa:	00491713          	slli	a4,s2,0x4
    80006bfe:	0009b783          	ld	a5,0(s3)
    80006c02:	97ba                	add	a5,a5,a4
    80006c04:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006c08:	854a                	mv	a0,s2
    80006c0a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006c0e:	bc5ff0ef          	jal	800067d2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80006c12:	8885                	andi	s1,s1,1
    80006c14:	f0fd                	bnez	s1,80006bfa <virtio_disk_rw+0x1ea>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006c16:	0024a517          	auipc	a0,0x24a
    80006c1a:	d3a50513          	addi	a0,a0,-710 # 80250950 <disk+0x128>
    80006c1e:	98cfa0ef          	jal	80000daa <release>
}
    80006c22:	60e6                	ld	ra,88(sp)
    80006c24:	6446                	ld	s0,80(sp)
    80006c26:	64a6                	ld	s1,72(sp)
    80006c28:	6906                	ld	s2,64(sp)
    80006c2a:	79e2                	ld	s3,56(sp)
    80006c2c:	7a42                	ld	s4,48(sp)
    80006c2e:	7aa2                	ld	s5,40(sp)
    80006c30:	7b02                	ld	s6,32(sp)
    80006c32:	6be2                	ld	s7,24(sp)
    80006c34:	6c42                	ld	s8,16(sp)
    80006c36:	6125                	addi	sp,sp,96
    80006c38:	8082                	ret

0000000080006c3a <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006c3a:	1101                	addi	sp,sp,-32
    80006c3c:	ec06                	sd	ra,24(sp)
    80006c3e:	e822                	sd	s0,16(sp)
    80006c40:	e426                	sd	s1,8(sp)
    80006c42:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006c44:	0024a497          	auipc	s1,0x24a
    80006c48:	be448493          	addi	s1,s1,-1052 # 80250828 <disk>
    80006c4c:	0024a517          	auipc	a0,0x24a
    80006c50:	d0450513          	addi	a0,a0,-764 # 80250950 <disk+0x128>
    80006c54:	8cefa0ef          	jal	80000d22 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006c58:	100017b7          	lui	a5,0x10001
    80006c5c:	53bc                	lw	a5,96(a5)
    80006c5e:	8b8d                	andi	a5,a5,3
    80006c60:	10001737          	lui	a4,0x10001
    80006c64:	d37c                	sw	a5,100(a4)
    80006c66:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80006c6a:	689c                	ld	a5,16(s1)
    80006c6c:	0204d703          	lhu	a4,32(s1)
    80006c70:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006c74:	04f70663          	beq	a4,a5,80006cc0 <virtio_disk_intr+0x86>
    80006c78:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006c7c:	6898                	ld	a4,16(s1)
    80006c7e:	0204d783          	lhu	a5,32(s1)
    80006c82:	8b9d                	andi	a5,a5,7
    80006c84:	078e                	slli	a5,a5,0x3
    80006c86:	97ba                	add	a5,a5,a4
    80006c88:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80006c8a:	00278713          	addi	a4,a5,2
    80006c8e:	0712                	slli	a4,a4,0x4
    80006c90:	9726                	add	a4,a4,s1
    80006c92:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006c96:	e321                	bnez	a4,80006cd6 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006c98:	0789                	addi	a5,a5,2
    80006c9a:	0792                	slli	a5,a5,0x4
    80006c9c:	97a6                	add	a5,a5,s1
    80006c9e:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80006ca0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006ca4:	b1bfb0ef          	jal	800027be <wakeup>

    disk.used_idx += 1;
    80006ca8:	0204d783          	lhu	a5,32(s1)
    80006cac:	2785                	addiw	a5,a5,1
    80006cae:	17c2                	slli	a5,a5,0x30
    80006cb0:	93c1                	srli	a5,a5,0x30
    80006cb2:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80006cb6:	6898                	ld	a4,16(s1)
    80006cb8:	00275703          	lhu	a4,2(a4)
    80006cbc:	faf71ee3          	bne	a4,a5,80006c78 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006cc0:	0024a517          	auipc	a0,0x24a
    80006cc4:	c9050513          	addi	a0,a0,-880 # 80250950 <disk+0x128>
    80006cc8:	8e2fa0ef          	jal	80000daa <release>
}
    80006ccc:	60e2                	ld	ra,24(sp)
    80006cce:	6442                	ld	s0,16(sp)
    80006cd0:	64a2                	ld	s1,8(sp)
    80006cd2:	6105                	addi	sp,sp,32
    80006cd4:	8082                	ret
      panic("virtio_disk_intr status");
    80006cd6:	00002517          	auipc	a0,0x2
    80006cda:	c1250513          	addi	a0,a0,-1006 # 800088e8 <etext+0x8e8>
    80006cde:	b11f90ef          	jal	800007ee <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	0000100f          	fence.i
    800070a0:	12000073          	sfence.vma
    800070a4:	18051073          	csrw	satp,a0
    800070a8:	12000073          	sfence.vma
    800070ac:	02000537          	lui	a0,0x2000
    800070b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070b2:	0536                	slli	a0,a0,0xd
    800070b4:	02853083          	ld	ra,40(a0)
    800070b8:	03053103          	ld	sp,48(a0)
    800070bc:	03853183          	ld	gp,56(a0)
    800070c0:	04053203          	ld	tp,64(a0)
    800070c4:	04853283          	ld	t0,72(a0)
    800070c8:	05053303          	ld	t1,80(a0)
    800070cc:	05853383          	ld	t2,88(a0)
    800070d0:	7120                	ld	s0,96(a0)
    800070d2:	7524                	ld	s1,104(a0)
    800070d4:	7d2c                	ld	a1,120(a0)
    800070d6:	6150                	ld	a2,128(a0)
    800070d8:	6554                	ld	a3,136(a0)
    800070da:	6958                	ld	a4,144(a0)
    800070dc:	6d5c                	ld	a5,152(a0)
    800070de:	0a053803          	ld	a6,160(a0)
    800070e2:	0a853883          	ld	a7,168(a0)
    800070e6:	0b053903          	ld	s2,176(a0)
    800070ea:	0b853983          	ld	s3,184(a0)
    800070ee:	0c053a03          	ld	s4,192(a0)
    800070f2:	0c853a83          	ld	s5,200(a0)
    800070f6:	0d053b03          	ld	s6,208(a0)
    800070fa:	0d853b83          	ld	s7,216(a0)
    800070fe:	0e053c03          	ld	s8,224(a0)
    80007102:	0e853c83          	ld	s9,232(a0)
    80007106:	0f053d03          	ld	s10,240(a0)
    8000710a:	0f853d83          	ld	s11,248(a0)
    8000710e:	10053e03          	ld	t3,256(a0)
    80007112:	10853e83          	ld	t4,264(a0)
    80007116:	11053f03          	ld	t5,272(a0)
    8000711a:	11853f83          	ld	t6,280(a0)
    8000711e:	7928                	ld	a0,112(a0)
    80007120:	10200073          	sret
	...
