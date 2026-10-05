
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
    80000004:	8c010113          	addi	sp,sp,-1856 # 800088c0 <stack0>
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
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdaea07>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	eb478793          	addi	a5,a5,-332 # 80000f2c <main>
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
    8000011c:	001020ef          	jal	8000291c <either_copyin>
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
    80000194:	00010517          	auipc	a0,0x10
    80000198:	72c50513          	addi	a0,a0,1836 # 800108c0 <cons>
    8000019c:	31b000ef          	jal	80000cb6 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00010497          	auipc	s1,0x10
    800001a4:	72048493          	addi	s1,s1,1824 # 800108c0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00010917          	auipc	s2,0x10
    800001ac:	7b090913          	addi	s2,s2,1968 # 80010958 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	4d7010ef          	jal	80001e96 <myproc>
    800001c4:	5d8020ef          	jal	8000279c <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	36a020ef          	jal	80002536 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	36d000ef          	jal	80000d3e <release>
      sleep();
    800001d6:	39c020ef          	jal	80002572 <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	2db000ef          	jal	80000cb6 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00010717          	auipc	a4,0x10
    800001f2:	6d270713          	addi	a4,a4,1746 # 800108c0 <cons>
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
    80000220:	6b0020ef          	jal	800028d0 <either_copyout>
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
    80000238:	00010517          	auipc	a0,0x10
    8000023c:	68850513          	addi	a0,a0,1672 # 800108c0 <cons>
    80000240:	2ff000ef          	jal	80000d3e <release>
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
    8000025e:	00010717          	auipc	a4,0x10
    80000262:	6ef72d23          	sw	a5,1786(a4) # 80010958 <cons+0x98>
    80000266:	6be2                	ld	s7,24(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	ec5e                	sd	s7,24(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	6be2                	ld	s7,24(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000274:	00010517          	auipc	a0,0x10
    80000278:	64c50513          	addi	a0,a0,1612 # 800108c0 <cons>
    8000027c:	2c3000ef          	jal	80000d3e <release>
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
    800002c8:	00010517          	auipc	a0,0x10
    800002cc:	5f850513          	addi	a0,a0,1528 # 800108c0 <cons>
    800002d0:	1e7000ef          	jal	80000cb6 <acquire>

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
    800002ea:	67e020ef          	jal	80002968 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00010517          	auipc	a0,0x10
    800002f2:	5d250513          	addi	a0,a0,1490 # 800108c0 <cons>
    800002f6:	249000ef          	jal	80000d3e <release>
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
    8000030c:	00010717          	auipc	a4,0x10
    80000310:	5b470713          	addi	a4,a4,1460 # 800108c0 <cons>
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
    80000332:	00010797          	auipc	a5,0x10
    80000336:	58e78793          	addi	a5,a5,1422 # 800108c0 <cons>
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
    8000035e:	00010797          	auipc	a5,0x10
    80000362:	5fa7a783          	lw	a5,1530(a5) # 80010958 <cons+0x98>
    80000366:	9f1d                	subw	a4,a4,a5
    80000368:	08000793          	li	a5,128
    8000036c:	f8f711e3          	bne	a4,a5,800002ee <consoleintr+0x32>
    80000370:	a85d                	j	80000426 <consoleintr+0x16a>
    80000372:	e84a                	sd	s2,16(sp)
    80000374:	e44e                	sd	s3,8(sp)
    while (cons.e != cons.w &&
    80000376:	00010717          	auipc	a4,0x10
    8000037a:	54a70713          	addi	a4,a4,1354 # 800108c0 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000386:	00010497          	auipc	s1,0x10
    8000038a:	53a48493          	addi	s1,s1,1338 # 800108c0 <cons>
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
    800003d0:	00010717          	auipc	a4,0x10
    800003d4:	4f070713          	addi	a4,a4,1264 # 800108c0 <cons>
    800003d8:	0a072783          	lw	a5,160(a4)
    800003dc:	09c72703          	lw	a4,156(a4)
    800003e0:	f0f707e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e4:	37fd                	addiw	a5,a5,-1
    800003e6:	00010717          	auipc	a4,0x10
    800003ea:	56f72d23          	sw	a5,1402(a4) # 80010960 <cons+0xa0>
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
    80000404:	00010797          	auipc	a5,0x10
    80000408:	4bc78793          	addi	a5,a5,1212 # 800108c0 <cons>
    8000040c:	0a07a703          	lw	a4,160(a5)
    80000410:	0017069b          	addiw	a3,a4,1
    80000414:	8636                	mv	a2,a3
    80000416:	0ad7a023          	sw	a3,160(a5)
    8000041a:	07f77713          	andi	a4,a4,127
    8000041e:	97ba                	add	a5,a5,a4
    80000420:	4729                	li	a4,10
    80000422:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000426:	00010797          	auipc	a5,0x10
    8000042a:	52c7ab23          	sw	a2,1334(a5) # 8001095c <cons+0x9c>
        wakeup(&cons.r);
    8000042e:	00010517          	auipc	a0,0x10
    80000432:	52a50513          	addi	a0,a0,1322 # 80010958 <cons+0x98>
    80000436:	16c020ef          	jal	800025a2 <wakeup>
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
    80000450:	47450513          	addi	a0,a0,1140 # 800108c0 <cons>
    80000454:	7e8000ef          	jal	80000c3c <initlock>

  uartinit();
    80000458:	3f6000ef          	jal	8000084e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000045c:	0024f797          	auipc	a5,0x24f
    80000460:	80478793          	addi	a5,a5,-2044 # 8024ec60 <devsw>
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
    800004a0:	2ac80813          	addi	a6,a6,684 # 80008748 <digits>
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
    8000052c:	36c7a783          	lw	a5,876(a5) # 80008894 <panicking>
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
    80000574:	3f850513          	addi	a0,a0,1016 # 80010968 <pr>
    80000578:	73e000ef          	jal	80000cb6 <acquire>
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
    8000073a:	012b8b93          	addi	s7,s7,18 # 80008748 <digits>
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
    800007ce:	0ca7a783          	lw	a5,202(a5) # 80008894 <panicking>
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
    800007e4:	18850513          	addi	a0,a0,392 # 80010968 <pr>
    800007e8:	556000ef          	jal	80000d3e <release>
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
    80000802:	0927ab23          	sw	s2,150(a5) # 80008894 <panicking>
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
    80000824:	0727a823          	sw	s2,112(a5) # 80008890 <panicked>
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
    8000083e:	12e50513          	addi	a0,a0,302 # 80010968 <pr>
    80000842:	3fa000ef          	jal	80000c3c <initlock>
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
    80000894:	0f050513          	addi	a0,a0,240 # 80010980 <tx_lock>
    80000898:	00c040ef          	jal	800048a4 <initsleeplock>
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
    800008b8:	0cc50513          	addi	a0,a0,204 # 80010980 <tx_lock>
    800008bc:	01e040ef          	jal	800048da <acquiresleep>

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
    800008d2:	fcaa0a13          	addi	s4,s4,-54 # 80008898 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    800008d6:	100009b7          	lui	s3,0x10000
    800008da:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    800008dc:	10000b37          	lui	s6,0x10000
    800008e0:	a029                	j	800008ea <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    800008e2:	491010ef          	jal	80002572 <sleep>
  while (i < n) {
    800008e6:	0324d263          	bge	s1,s2,8000090a <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    800008ea:	8552                	mv	a0,s4
    800008ec:	44b010ef          	jal	80002536 <sleep_prepare>
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
    80000916:	06e50513          	addi	a0,a0,110 # 80010980 <tx_lock>
    8000091a:	014040ef          	jal	8000492e <releasesleep>
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
    8000093a:	f5e7a783          	lw	a5,-162(a5) # 80008894 <panicking>
    8000093e:	cf95                	beqz	a5,8000097a <uartputc_sync+0x50>
    push_off();

  if (panicked) {
    80000940:	00008797          	auipc	a5,0x8
    80000944:	f507a783          	lw	a5,-176(a5) # 80008890 <panicked>
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
    8000096a:	f2e7a783          	lw	a5,-210(a5) # 80008894 <panicking>
    8000096e:	cb91                	beqz	a5,80000982 <uartputc_sync+0x58>
    pop_off();
}
    80000970:	60e2                	ld	ra,24(sp)
    80000972:	6442                	ld	s0,16(sp)
    80000974:	64a2                	ld	s1,8(sp)
    80000976:	6105                	addi	sp,sp,32
    80000978:	8082                	ret
    push_off();
    8000097a:	306000ef          	jal	80000c80 <push_off>
    8000097e:	b7c9                	j	80000940 <uartputc_sync+0x16>
    for (;;)
    80000980:	a001                	j	80000980 <uartputc_sync+0x56>
    pop_off();
    80000982:	374000ef          	jal	80000cf6 <pop_off>
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
    800009ca:	ed250513          	addi	a0,a0,-302 # 80008898 <tx_chan>
    800009ce:	3d5010ef          	jal	800025a2 <wakeup>
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
    800009f4:	0024f797          	auipc	a5,0x24f
    800009f8:	40478793          	addi	a5,a5,1028 # 8024fdf8 <end>
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
    80000a12:	fc250513          	addi	a0,a0,-62 # 800109d0 <ref>
    80000a16:	2a0000ef          	jal	80000cb6 <acquire>
  ref.refcnt[index]--;
    80000a1a:	00010517          	auipc	a0,0x10
    80000a1e:	fb650513          	addi	a0,a0,-74 # 800109d0 <ref>
    80000a22:	00448793          	addi	a5,s1,4
    80000a26:	078a                	slli	a5,a5,0x2
    80000a28:	97aa                	add	a5,a5,a0
    80000a2a:	4798                	lw	a4,8(a5)
    80000a2c:	377d                	addiw	a4,a4,-1
    80000a2e:	84ba                	mv	s1,a4
    80000a30:	c798                	sw	a4,8(a5)
  count = ref.refcnt[index];
  release(&ref.lock);
    80000a32:	30c000ef          	jal	80000d3e <release>

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
    80000a44:	332000ef          	jal	80000d76 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a48:	00010497          	auipc	s1,0x10
    80000a4c:	f6848493          	addi	s1,s1,-152 # 800109b0 <kmem>
    80000a50:	8526                	mv	a0,s1
    80000a52:	264000ef          	jal	80000cb6 <acquire>
  r->next = kmem.freelist;
    80000a56:	6c9c                	ld	a5,24(s1)
    80000a58:	00f93023          	sd	a5,0(s2)
  kmem.freelist = r;
    80000a5c:	0124bc23          	sd	s2,24(s1)
  release(&kmem.lock);
    80000a60:	8526                	mv	a0,s1
    80000a62:	2dc000ef          	jal	80000d3e <release>
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
    80000ae6:	ece50513          	addi	a0,a0,-306 # 800109b0 <kmem>
    80000aea:	152000ef          	jal	80000c3c <initlock>
  initlock(&ref.lock, "ref");
    80000aee:	00007597          	auipc	a1,0x7
    80000af2:	56a58593          	addi	a1,a1,1386 # 80008058 <etext+0x58>
    80000af6:	00010517          	auipc	a0,0x10
    80000afa:	eda50513          	addi	a0,a0,-294 # 800109d0 <ref>
    80000afe:	13e000ef          	jal	80000c3c <initlock>
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b02:	00010797          	auipc	a5,0x10
    80000b06:	ee678793          	addi	a5,a5,-282 # 800109e8 <ref+0x18>
    80000b0a:	00230697          	auipc	a3,0x230
    80000b0e:	ede68693          	addi	a3,a3,-290 # 802309e8 <pid_lock>
    ref.refcnt[i] = 1;
    80000b12:	4705                	li	a4,1
    80000b14:	c398                	sw	a4,0(a5)
  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    80000b16:	0791                	addi	a5,a5,4
    80000b18:	fed79ee3          	bne	a5,a3,80000b14 <kinit+0x42>
  freerange(end, (void*)PHYSTOP);
    80000b1c:	45c5                	li	a1,17
    80000b1e:	05ee                	slli	a1,a1,0x1b
    80000b20:	0024f517          	auipc	a0,0x24f
    80000b24:	2d850513          	addi	a0,a0,728 # 8024fdf8 <end>
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
    80000b42:	e7248493          	addi	s1,s1,-398 # 800109b0 <kmem>
    80000b46:	8526                	mv	a0,s1
    80000b48:	16e000ef          	jal	80000cb6 <acquire>
  r = kmem.freelist;
    80000b4c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4e:	c4b9                	beqz	s1,80000b9c <kalloc+0x68>
    kmem.freelist = r->next;
    80000b50:	609c                	ld	a5,0(s1)
    80000b52:	00010517          	auipc	a0,0x10
    80000b56:	e5e50513          	addi	a0,a0,-418 # 800109b0 <kmem>
    80000b5a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5c:	1e2000ef          	jal	80000d3e <release>

  if(r){
    memset((char*)r, 5, PGSIZE);
    80000b60:	6605                	lui	a2,0x1
    80000b62:	4595                	li	a1,5
    80000b64:	8526                	mv	a0,s1
    80000b66:	210000ef          	jal	80000d76 <memset>

    acquire(&ref.lock);
    80000b6a:	00010517          	auipc	a0,0x10
    80000b6e:	e6650513          	addi	a0,a0,-410 # 800109d0 <ref>
    80000b72:	144000ef          	jal	80000cb6 <acquire>
    ref.refcnt[(uint64)r / PGSIZE] = 1;
    80000b76:	00010517          	auipc	a0,0x10
    80000b7a:	e5a50513          	addi	a0,a0,-422 # 800109d0 <ref>
    80000b7e:	00c4d793          	srli	a5,s1,0xc
    80000b82:	0791                	addi	a5,a5,4
    80000b84:	078a                	slli	a5,a5,0x2
    80000b86:	97aa                	add	a5,a5,a0
    80000b88:	4705                	li	a4,1
    80000b8a:	c798                	sw	a4,8(a5)
    release(&ref.lock);
    80000b8c:	1b2000ef          	jal	80000d3e <release>
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
    80000ba0:	e1450513          	addi	a0,a0,-492 # 800109b0 <kmem>
    80000ba4:	19a000ef          	jal	80000d3e <release>
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
    80000bbe:	e1650513          	addi	a0,a0,-490 # 800109d0 <ref>
    80000bc2:	0f4000ef          	jal	80000cb6 <acquire>
  ref.refcnt[index]++;
    80000bc6:	00010517          	auipc	a0,0x10
    80000bca:	e0a50513          	addi	a0,a0,-502 # 800109d0 <ref>
    80000bce:	00448793          	addi	a5,s1,4
    80000bd2:	078a                	slli	a5,a5,0x2
    80000bd4:	97aa                	add	a5,a5,a0
    80000bd6:	4798                	lw	a4,8(a5)
    80000bd8:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdaf209>
    80000bda:	c798                	sw	a4,8(a5)
  release(&ref.lock);
    80000bdc:	162000ef          	jal	80000d3e <release>
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
    80000bfa:	dda50513          	addi	a0,a0,-550 # 800109d0 <ref>
    80000bfe:	0b8000ef          	jal	80000cb6 <acquire>
  count = ref.refcnt[index];
    80000c02:	00010517          	auipc	a0,0x10
    80000c06:	dce50513          	addi	a0,a0,-562 # 800109d0 <ref>
  int index = (uint64)pa / PGSIZE;
    80000c0a:	00c4d793          	srli	a5,s1,0xc
  count = ref.refcnt[index];
    80000c0e:	2781                	sext.w	a5,a5
    80000c10:	0791                	addi	a5,a5,4
    80000c12:	078a                	slli	a5,a5,0x2
    80000c14:	97aa                	add	a5,a5,a0
    80000c16:	4784                	lw	s1,8(a5)
  release(&ref.lock);
    80000c18:	126000ef          	jal	80000d3e <release>

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
    80000c34:	60a2                	ld	ra,8(sp)
    80000c36:	6402                	ld	s0,0(sp)
    80000c38:	0141                	addi	sp,sp,16
    80000c3a:	8082                	ret

0000000080000c3c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c3c:	1141                	addi	sp,sp,-16
    80000c3e:	e406                	sd	ra,8(sp)
    80000c40:	e022                	sd	s0,0(sp)
    80000c42:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c44:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c46:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c4a:	00053823          	sd	zero,16(a0)
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret

0000000080000c56 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c56:	411c                	lw	a5,0(a0)
    80000c58:	e399                	bnez	a5,80000c5e <holding+0x8>
    80000c5a:	4501                	li	a0,0
  return r;
}
    80000c5c:	8082                	ret
{
    80000c5e:	1101                	addi	sp,sp,-32
    80000c60:	ec06                	sd	ra,24(sp)
    80000c62:	e822                	sd	s0,16(sp)
    80000c64:	e426                	sd	s1,8(sp)
    80000c66:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c68:	6904                	ld	s1,16(a0)
    80000c6a:	20c010ef          	jal	80001e76 <mycpu>
    80000c6e:	40a48533          	sub	a0,s1,a0
    80000c72:	00153513          	seqz	a0,a0
}
    80000c76:	60e2                	ld	ra,24(sp)
    80000c78:	6442                	ld	s0,16(sp)
    80000c7a:	64a2                	ld	s1,8(sp)
    80000c7c:	6105                	addi	sp,sp,32
    80000c7e:	8082                	ret

0000000080000c80 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c80:	1101                	addi	sp,sp,-32
    80000c82:	ec06                	sd	ra,24(sp)
    80000c84:	e822                	sd	s0,16(sp)
    80000c86:	e426                	sd	s1,8(sp)
    80000c88:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000c8a:	100174f3          	csrrci	s1,sstatus,2
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000c8e:	1e8010ef          	jal	80001e76 <mycpu>
    80000c92:	5d3c                	lw	a5,120(a0)
    80000c94:	cb99                	beqz	a5,80000caa <push_off+0x2a>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c96:	1e0010ef          	jal	80001e76 <mycpu>
    80000c9a:	5d3c                	lw	a5,120(a0)
    80000c9c:	2785                	addiw	a5,a5,1
    80000c9e:	dd3c                	sw	a5,120(a0)
}
    80000ca0:	60e2                	ld	ra,24(sp)
    80000ca2:	6442                	ld	s0,16(sp)
    80000ca4:	64a2                	ld	s1,8(sp)
    80000ca6:	6105                	addi	sp,sp,32
    80000ca8:	8082                	ret
    mycpu()->intena = old;
    80000caa:	1cc010ef          	jal	80001e76 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000cae:	8085                	srli	s1,s1,0x1
    80000cb0:	8885                	andi	s1,s1,1
    mycpu()->intena = old;
    80000cb2:	dd64                	sw	s1,124(a0)
    80000cb4:	b7cd                	j	80000c96 <push_off+0x16>

0000000080000cb6 <acquire>:
{
    80000cb6:	1101                	addi	sp,sp,-32
    80000cb8:	ec06                	sd	ra,24(sp)
    80000cba:	e822                	sd	s0,16(sp)
    80000cbc:	e426                	sd	s1,8(sp)
    80000cbe:	1000                	addi	s0,sp,32
    80000cc0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000cc2:	fbfff0ef          	jal	80000c80 <push_off>
  if (holding(lk))
    80000cc6:	8526                	mv	a0,s1
    80000cc8:	f8fff0ef          	jal	80000c56 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000ccc:	4705                	li	a4,1
  if (holding(lk))
    80000cce:	ed11                	bnez	a0,80000cea <acquire+0x34>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000cd0:	87ba                	mv	a5,a4
    80000cd2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cd6:	2781                	sext.w	a5,a5
    80000cd8:	ffe5                	bnez	a5,80000cd0 <acquire+0x1a>
  lk->cpu = mycpu();
    80000cda:	19c010ef          	jal	80001e76 <mycpu>
    80000cde:	e888                	sd	a0,16(s1)
}
    80000ce0:	60e2                	ld	ra,24(sp)
    80000ce2:	6442                	ld	s0,16(sp)
    80000ce4:	64a2                	ld	s1,8(sp)
    80000ce6:	6105                	addi	sp,sp,32
    80000ce8:	8082                	ret
    panic("acquire");
    80000cea:	00007517          	auipc	a0,0x7
    80000cee:	37650513          	addi	a0,a0,886 # 80008060 <etext+0x60>
    80000cf2:	afdff0ef          	jal	800007ee <panic>

0000000080000cf6 <pop_off>:

void
pop_off(void)
{
    80000cf6:	1141                	addi	sp,sp,-16
    80000cf8:	e406                	sd	ra,8(sp)
    80000cfa:	e022                	sd	s0,0(sp)
    80000cfc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cfe:	178010ef          	jal	80001e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000d02:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d06:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000d08:	ef99                	bnez	a5,80000d26 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000d0a:	5d3c                	lw	a5,120(a0)
    80000d0c:	02f05363          	blez	a5,80000d32 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000d10:	37fd                	addiw	a5,a5,-1
    80000d12:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000d14:	e789                	bnez	a5,80000d1e <pop_off+0x28>
    80000d16:	5d7c                	lw	a5,124(a0)
    80000d18:	c399                	beqz	a5,80000d1e <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000d1a:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000d1e:	60a2                	ld	ra,8(sp)
    80000d20:	6402                	ld	s0,0(sp)
    80000d22:	0141                	addi	sp,sp,16
    80000d24:	8082                	ret
    panic("pop_off - interruptible");
    80000d26:	00007517          	auipc	a0,0x7
    80000d2a:	34250513          	addi	a0,a0,834 # 80008068 <etext+0x68>
    80000d2e:	ac1ff0ef          	jal	800007ee <panic>
    panic("pop_off");
    80000d32:	00007517          	auipc	a0,0x7
    80000d36:	34e50513          	addi	a0,a0,846 # 80008080 <etext+0x80>
    80000d3a:	ab5ff0ef          	jal	800007ee <panic>

0000000080000d3e <release>:
{
    80000d3e:	1101                	addi	sp,sp,-32
    80000d40:	ec06                	sd	ra,24(sp)
    80000d42:	e822                	sd	s0,16(sp)
    80000d44:	e426                	sd	s1,8(sp)
    80000d46:	1000                	addi	s0,sp,32
    80000d48:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000d4a:	f0dff0ef          	jal	80000c56 <holding>
    80000d4e:	cd11                	beqz	a0,80000d6a <release+0x2c>
  lk->cpu = 0;
    80000d50:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000d54:	0310000f          	fence	rw,w
    80000d58:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d5c:	f9bff0ef          	jal	80000cf6 <pop_off>
}
    80000d60:	60e2                	ld	ra,24(sp)
    80000d62:	6442                	ld	s0,16(sp)
    80000d64:	64a2                	ld	s1,8(sp)
    80000d66:	6105                	addi	sp,sp,32
    80000d68:	8082                	ret
    panic("release");
    80000d6a:	00007517          	auipc	a0,0x7
    80000d6e:	31e50513          	addi	a0,a0,798 # 80008088 <etext+0x88>
    80000d72:	a7dff0ef          	jal	800007ee <panic>

0000000080000d76 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000d76:	1141                	addi	sp,sp,-16
    80000d78:	e406                	sd	ra,8(sp)
    80000d7a:	e022                	sd	s0,0(sp)
    80000d7c:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000d7e:	ca19                	beqz	a2,80000d94 <memset+0x1e>
    80000d80:	87aa                	mv	a5,a0
    80000d82:	1602                	slli	a2,a2,0x20
    80000d84:	9201                	srli	a2,a2,0x20
    80000d86:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d8a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000d8e:	0785                	addi	a5,a5,1
    80000d90:	fee79de3          	bne	a5,a4,80000d8a <memset+0x14>
  }
  return dst;
}
    80000d94:	60a2                	ld	ra,8(sp)
    80000d96:	6402                	ld	s0,0(sp)
    80000d98:	0141                	addi	sp,sp,16
    80000d9a:	8082                	ret

0000000080000d9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d9c:	1141                	addi	sp,sp,-16
    80000d9e:	e406                	sd	ra,8(sp)
    80000da0:	e022                	sd	s0,0(sp)
    80000da2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000da4:	ca0d                	beqz	a2,80000dd6 <memcmp+0x3a>
    80000da6:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000daa:	1682                	slli	a3,a3,0x20
    80000dac:	9281                	srli	a3,a3,0x20
    80000dae:	0685                	addi	a3,a3,1
    80000db0:	96aa                	add	a3,a3,a0
    if (*s1 != *s2)
    80000db2:	00054783          	lbu	a5,0(a0)
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	00e79863          	bne	a5,a4,80000dca <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000dbe:	0505                	addi	a0,a0,1
    80000dc0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000dc2:	fed518e3          	bne	a0,a3,80000db2 <memcmp+0x16>
  }

  return 0;
    80000dc6:	4501                	li	a0,0
    80000dc8:	a019                	j	80000dce <memcmp+0x32>
      return *s1 - *s2;
    80000dca:	40e7853b          	subw	a0,a5,a4
}
    80000dce:	60a2                	ld	ra,8(sp)
    80000dd0:	6402                	ld	s0,0(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret
  return 0;
    80000dd6:	4501                	li	a0,0
    80000dd8:	bfdd                	j	80000dce <memcmp+0x32>

0000000080000dda <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e406                	sd	ra,8(sp)
    80000dde:	e022                	sd	s0,0(sp)
    80000de0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000de2:	c205                	beqz	a2,80000e02 <memmove+0x28>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000de4:	02a5e363          	bltu	a1,a0,80000e0a <memmove+0x30>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000de8:	1602                	slli	a2,a2,0x20
    80000dea:	9201                	srli	a2,a2,0x20
    80000dec:	00c587b3          	add	a5,a1,a2
{
    80000df0:	872a                	mv	a4,a0
      *d++ = *s++;
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	0705                	addi	a4,a4,1
    80000df6:	fff5c683          	lbu	a3,-1(a1)
    80000dfa:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000dfe:	feb79ae3          	bne	a5,a1,80000df2 <memmove+0x18>

  return dst;
}
    80000e02:	60a2                	ld	ra,8(sp)
    80000e04:	6402                	ld	s0,0(sp)
    80000e06:	0141                	addi	sp,sp,16
    80000e08:	8082                	ret
  if (s < d && s + n > d) {
    80000e0a:	02061693          	slli	a3,a2,0x20
    80000e0e:	9281                	srli	a3,a3,0x20
    80000e10:	00d58733          	add	a4,a1,a3
    80000e14:	fce57ae3          	bgeu	a0,a4,80000de8 <memmove+0xe>
    d += n;
    80000e18:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000e1a:	fff6079b          	addiw	a5,a2,-1
    80000e1e:	1782                	slli	a5,a5,0x20
    80000e20:	9381                	srli	a5,a5,0x20
    80000e22:	fff7c793          	not	a5,a5
    80000e26:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e28:	177d                	addi	a4,a4,-1
    80000e2a:	16fd                	addi	a3,a3,-1
    80000e2c:	00074603          	lbu	a2,0(a4)
    80000e30:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000e34:	fee79ae3          	bne	a5,a4,80000e28 <memmove+0x4e>
    80000e38:	b7e9                	j	80000e02 <memmove+0x28>

0000000080000e3a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000e3a:	1141                	addi	sp,sp,-16
    80000e3c:	e406                	sd	ra,8(sp)
    80000e3e:	e022                	sd	s0,0(sp)
    80000e40:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e42:	f99ff0ef          	jal	80000dda <memmove>
}
    80000e46:	60a2                	ld	ra,8(sp)
    80000e48:	6402                	ld	s0,0(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e406                	sd	ra,8(sp)
    80000e52:	e022                	sd	s0,0(sp)
    80000e54:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000e56:	ce11                	beqz	a2,80000e72 <strncmp+0x24>
    80000e58:	00054783          	lbu	a5,0(a0)
    80000e5c:	cf89                	beqz	a5,80000e76 <strncmp+0x28>
    80000e5e:	0005c703          	lbu	a4,0(a1)
    80000e62:	00f71a63          	bne	a4,a5,80000e76 <strncmp+0x28>
    n--, p++, q++;
    80000e66:	367d                	addiw	a2,a2,-1
    80000e68:	0505                	addi	a0,a0,1
    80000e6a:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000e6c:	f675                	bnez	a2,80000e58 <strncmp+0xa>
  if (n == 0)
    return 0;
    80000e6e:	4501                	li	a0,0
    80000e70:	a801                	j	80000e80 <strncmp+0x32>
    80000e72:	4501                	li	a0,0
    80000e74:	a031                	j	80000e80 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e76:	00054503          	lbu	a0,0(a0)
    80000e7a:	0005c783          	lbu	a5,0(a1)
    80000e7e:	9d1d                	subw	a0,a0,a5
}
    80000e80:	60a2                	ld	ra,8(sp)
    80000e82:	6402                	ld	s0,0(sp)
    80000e84:	0141                	addi	sp,sp,16
    80000e86:	8082                	ret

0000000080000e88 <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000e88:	1141                	addi	sp,sp,-16
    80000e8a:	e406                	sd	ra,8(sp)
    80000e8c:	e022                	sd	s0,0(sp)
    80000e8e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000e90:	87aa                	mv	a5,a0
    80000e92:	86b2                	mv	a3,a2
    80000e94:	367d                	addiw	a2,a2,-1
    80000e96:	02d05563          	blez	a3,80000ec0 <strncpy+0x38>
    80000e9a:	0785                	addi	a5,a5,1
    80000e9c:	0005c703          	lbu	a4,0(a1)
    80000ea0:	fee78fa3          	sb	a4,-1(a5)
    80000ea4:	0585                	addi	a1,a1,1
    80000ea6:	f775                	bnez	a4,80000e92 <strncpy+0xa>
    ;
  while (n-- > 0)
    80000ea8:	873e                	mv	a4,a5
    80000eaa:	00c05b63          	blez	a2,80000ec0 <strncpy+0x38>
    80000eae:	9fb5                	addw	a5,a5,a3
    80000eb0:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000eb2:	0705                	addi	a4,a4,1
    80000eb4:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000eb8:	40e786bb          	subw	a3,a5,a4
    80000ebc:	fed04be3          	bgtz	a3,80000eb2 <strncpy+0x2a>
  return os;
}
    80000ec0:	60a2                	ld	ra,8(sp)
    80000ec2:	6402                	ld	s0,0(sp)
    80000ec4:	0141                	addi	sp,sp,16
    80000ec6:	8082                	ret

0000000080000ec8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000ec8:	1141                	addi	sp,sp,-16
    80000eca:	e406                	sd	ra,8(sp)
    80000ecc:	e022                	sd	s0,0(sp)
    80000ece:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000ed0:	02c05363          	blez	a2,80000ef6 <safestrcpy+0x2e>
    80000ed4:	fff6069b          	addiw	a3,a2,-1
    80000ed8:	1682                	slli	a3,a3,0x20
    80000eda:	9281                	srli	a3,a3,0x20
    80000edc:	96ae                	add	a3,a3,a1
    80000ede:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000ee0:	00d58963          	beq	a1,a3,80000ef2 <safestrcpy+0x2a>
    80000ee4:	0585                	addi	a1,a1,1
    80000ee6:	0785                	addi	a5,a5,1
    80000ee8:	fff5c703          	lbu	a4,-1(a1)
    80000eec:	fee78fa3          	sb	a4,-1(a5)
    80000ef0:	fb65                	bnez	a4,80000ee0 <safestrcpy+0x18>
    ;
  *s = 0;
    80000ef2:	00078023          	sb	zero,0(a5)
  return os;
}
    80000ef6:	60a2                	ld	ra,8(sp)
    80000ef8:	6402                	ld	s0,0(sp)
    80000efa:	0141                	addi	sp,sp,16
    80000efc:	8082                	ret

0000000080000efe <strlen>:

int
strlen(const char *s)
{
    80000efe:	1141                	addi	sp,sp,-16
    80000f00:	e406                	sd	ra,8(sp)
    80000f02:	e022                	sd	s0,0(sp)
    80000f04:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000f06:	00054783          	lbu	a5,0(a0)
    80000f0a:	cf99                	beqz	a5,80000f28 <strlen+0x2a>
    80000f0c:	0505                	addi	a0,a0,1
    80000f0e:	87aa                	mv	a5,a0
    80000f10:	86be                	mv	a3,a5
    80000f12:	0785                	addi	a5,a5,1
    80000f14:	fff7c703          	lbu	a4,-1(a5)
    80000f18:	ff65                	bnez	a4,80000f10 <strlen+0x12>
    80000f1a:	40a6853b          	subw	a0,a3,a0
    80000f1e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000f20:	60a2                	ld	ra,8(sp)
    80000f22:	6402                	ld	s0,0(sp)
    80000f24:	0141                	addi	sp,sp,16
    80000f26:	8082                	ret
  for (n = 0; s[n]; n++)
    80000f28:	4501                	li	a0,0
    80000f2a:	bfdd                	j	80000f20 <strlen+0x22>

0000000080000f2c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e406                	sd	ra,8(sp)
    80000f30:	e022                	sd	s0,0(sp)
    80000f32:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000f34:	72f000ef          	jal	80001e62 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000f38:	00008717          	auipc	a4,0x8
    80000f3c:	96470713          	addi	a4,a4,-1692 # 8000889c <started>
  if (cpuid() == 0) {
    80000f40:	c51d                	beqz	a0,80000f6e <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000f42:	431c                	lw	a5,0(a4)
    80000f44:	0230000f          	fence	r,rw
    80000f48:	2781                	sext.w	a5,a5
    80000f4a:	dfe5                	beqz	a5,80000f42 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000f4c:	717000ef          	jal	80001e62 <cpuid>
    80000f50:	85aa                	mv	a1,a0
    80000f52:	00007517          	auipc	a0,0x7
    80000f56:	15e50513          	addi	a0,a0,350 # 800080b0 <etext+0xb0>
    80000f5a:	db0ff0ef          	jal	8000050a <printk>
    kvminithart();  // turn on paging
    80000f5e:	082000ef          	jal	80000fe0 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000f62:	39f010ef          	jal	80002b00 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000f66:	022050ef          	jal	80005f88 <plicinithart>
  }

  scheduler();
    80000f6a:	422010ef          	jal	8000238c <scheduler>
    consoleinit();
    80000f6e:	cceff0ef          	jal	8000043c <consoleinit>
    printkinit();
    80000f72:	8b9ff0ef          	jal	8000082a <printkinit>
    printk("\n");
    80000f76:	00007517          	auipc	a0,0x7
    80000f7a:	11a50513          	addi	a0,a0,282 # 80008090 <etext+0x90>
    80000f7e:	d8cff0ef          	jal	8000050a <printk>
    printk("xv6 kernel is booting\n");
    80000f82:	00007517          	auipc	a0,0x7
    80000f86:	11650513          	addi	a0,a0,278 # 80008098 <etext+0x98>
    80000f8a:	d80ff0ef          	jal	8000050a <printk>
    printk("\n");
    80000f8e:	00007517          	auipc	a0,0x7
    80000f92:	10250513          	addi	a0,a0,258 # 80008090 <etext+0x90>
    80000f96:	d74ff0ef          	jal	8000050a <printk>
    kinit();            // physical page allocator
    80000f9a:	b39ff0ef          	jal	80000ad2 <kinit>
    kvminit();          // create kernel page table
    80000f9e:	2d0000ef          	jal	8000126e <kvminit>
    kvminithart();      // turn on paging
    80000fa2:	03e000ef          	jal	80000fe0 <kvminithart>
    procinit();         // process table
    80000fa6:	60d000ef          	jal	80001db2 <procinit>
    trapinit();         // trap vectors
    80000faa:	333010ef          	jal	80002adc <trapinit>
    trapinithart();     // install kernel trap vector
    80000fae:	353010ef          	jal	80002b00 <trapinithart>
    plicinit();         // set up interrupt controller
    80000fb2:	7bd040ef          	jal	80005f6e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000fb6:	7d3040ef          	jal	80005f88 <plicinithart>
    binit();            // buffer cache
    80000fba:	47e020ef          	jal	80003438 <binit>
    iinit();            // inode table
    80000fbe:	1df020ef          	jal	8000399c <iinit>
    fileinit();         // file table
    80000fc2:	1ef030ef          	jal	800049b0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fc6:	0b2050ef          	jal	80006078 <virtio_disk_init>
    userinit();         // first user process
    80000fca:	1c0010ef          	jal	8000218a <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000fce:	00008797          	auipc	a5,0x8
    80000fd2:	8ce78793          	addi	a5,a5,-1842 # 8000889c <started>
    80000fd6:	4705                	li	a4,1
    80000fd8:	0310000f          	fence	rw,w
    80000fdc:	c398                	sw	a4,0(a5)
    80000fde:	b771                	j	80000f6a <main+0x3e>

0000000080000fe0 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000fe0:	1141                	addi	sp,sp,-16
    80000fe2:	e406                	sd	ra,8(sp)
    80000fe4:	e022                	sd	s0,0(sp)
    80000fe6:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000fe8:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000fec:	00008797          	auipc	a5,0x8
    80000ff0:	8b47b783          	ld	a5,-1868(a5) # 800088a0 <kernel_pagetable>
    80000ff4:	83b1                	srli	a5,a5,0xc
    80000ff6:	577d                	li	a4,-1
    80000ff8:	177e                	slli	a4,a4,0x3f
    80000ffa:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000ffc:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80001000:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001004:	60a2                	ld	ra,8(sp)
    80001006:	6402                	ld	s0,0(sp)
    80001008:	0141                	addi	sp,sp,16
    8000100a:	8082                	ret

000000008000100c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000100c:	7139                	addi	sp,sp,-64
    8000100e:	fc06                	sd	ra,56(sp)
    80001010:	f822                	sd	s0,48(sp)
    80001012:	f426                	sd	s1,40(sp)
    80001014:	f04a                	sd	s2,32(sp)
    80001016:	ec4e                	sd	s3,24(sp)
    80001018:	e852                	sd	s4,16(sp)
    8000101a:	e456                	sd	s5,8(sp)
    8000101c:	e05a                	sd	s6,0(sp)
    8000101e:	0080                	addi	s0,sp,64
    80001020:	84aa                	mv	s1,a0
    80001022:	89ae                	mv	s3,a1
    80001024:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    8000102c:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000102e:	04b7e263          	bltu	a5,a1,80001072 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001032:	0149d933          	srl	s2,s3,s4
    80001036:	1ff97913          	andi	s2,s2,511
    8000103a:	090e                	slli	s2,s2,0x3
    8000103c:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    8000103e:	00093483          	ld	s1,0(s2)
    80001042:	0014f793          	andi	a5,s1,1
    80001046:	cf85                	beqz	a5,8000107e <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001048:	80a9                	srli	s1,s1,0xa
    8000104a:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--) {
    8000104c:	3a5d                	addiw	s4,s4,-9
    8000104e:	ff6a12e3          	bne	s4,s6,80001032 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001052:	00c9d513          	srli	a0,s3,0xc
    80001056:	1ff57513          	andi	a0,a0,511
    8000105a:	050e                	slli	a0,a0,0x3
    8000105c:	9526                	add	a0,a0,s1
}
    8000105e:	70e2                	ld	ra,56(sp)
    80001060:	7442                	ld	s0,48(sp)
    80001062:	74a2                	ld	s1,40(sp)
    80001064:	7902                	ld	s2,32(sp)
    80001066:	69e2                	ld	s3,24(sp)
    80001068:	6a42                	ld	s4,16(sp)
    8000106a:	6aa2                	ld	s5,8(sp)
    8000106c:	6b02                	ld	s6,0(sp)
    8000106e:	6121                	addi	sp,sp,64
    80001070:	8082                	ret
    panic("walk");
    80001072:	00007517          	auipc	a0,0x7
    80001076:	05650513          	addi	a0,a0,86 # 800080c8 <etext+0xc8>
    8000107a:	f74ff0ef          	jal	800007ee <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    8000107e:	020a8263          	beqz	s5,800010a2 <walk+0x96>
    80001082:	ab3ff0ef          	jal	80000b34 <kalloc>
    80001086:	84aa                	mv	s1,a0
    80001088:	d979                	beqz	a0,8000105e <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000108a:	6605                	lui	a2,0x1
    8000108c:	4581                	li	a1,0
    8000108e:	ce9ff0ef          	jal	80000d76 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80001092:	00c4d793          	srli	a5,s1,0xc
    80001096:	07aa                	slli	a5,a5,0xa
    80001098:	0017e793          	ori	a5,a5,1
    8000109c:	00f93023          	sd	a5,0(s2)
    800010a0:	b775                	j	8000104c <walk+0x40>
        return 0;
    800010a2:	4501                	li	a0,0
    800010a4:	bf6d                	j	8000105e <walk+0x52>

00000000800010a6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    800010a6:	57fd                	li	a5,-1
    800010a8:	83e9                	srli	a5,a5,0x1a
    800010aa:	00b7f463          	bgeu	a5,a1,800010b2 <walkaddr+0xc>
    return 0;
    800010ae:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010b0:	8082                	ret
{
    800010b2:	1141                	addi	sp,sp,-16
    800010b4:	e406                	sd	ra,8(sp)
    800010b6:	e022                	sd	s0,0(sp)
    800010b8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010ba:	4601                	li	a2,0
    800010bc:	f51ff0ef          	jal	8000100c <walk>
  if (pte == 0)
    800010c0:	c105                	beqz	a0,800010e0 <walkaddr+0x3a>
  if ((*pte & PTE_V) == 0)
    800010c2:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    800010c4:	0117f693          	andi	a3,a5,17
    800010c8:	4745                	li	a4,17
    return 0;
    800010ca:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800010cc:	00e68663          	beq	a3,a4,800010d8 <walkaddr+0x32>
}
    800010d0:	60a2                	ld	ra,8(sp)
    800010d2:	6402                	ld	s0,0(sp)
    800010d4:	0141                	addi	sp,sp,16
    800010d6:	8082                	ret
  pa = PTE2PA(*pte);
    800010d8:	83a9                	srli	a5,a5,0xa
    800010da:	00c79513          	slli	a0,a5,0xc
  return pa;
    800010de:	bfcd                	j	800010d0 <walkaddr+0x2a>
    return 0;
    800010e0:	4501                	li	a0,0
    800010e2:	b7fd                	j	800010d0 <walkaddr+0x2a>

00000000800010e4 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800010e4:	715d                	addi	sp,sp,-80
    800010e6:	e486                	sd	ra,72(sp)
    800010e8:	e0a2                	sd	s0,64(sp)
    800010ea:	fc26                	sd	s1,56(sp)
    800010ec:	f84a                	sd	s2,48(sp)
    800010ee:	f44e                	sd	s3,40(sp)
    800010f0:	f052                	sd	s4,32(sp)
    800010f2:	ec56                	sd	s5,24(sp)
    800010f4:	e85a                	sd	s6,16(sp)
    800010f6:	e45e                	sd	s7,8(sp)
    800010f8:	e062                	sd	s8,0(sp)
    800010fa:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800010fc:	03459793          	slli	a5,a1,0x34
    80001100:	e7b1                	bnez	a5,8000114c <mappages+0x68>
    80001102:	8aaa                	mv	s5,a0
    80001104:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001106:	03461793          	slli	a5,a2,0x34
    8000110a:	e7b9                	bnez	a5,80001158 <mappages+0x74>
    panic("mappages: size not aligned");

  if (size == 0)
    8000110c:	ce21                	beqz	a2,80001164 <mappages+0x80>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000110e:	77fd                	lui	a5,0xfffff
    80001110:	963e                	add	a2,a2,a5
    80001112:	00b609b3          	add	s3,a2,a1
  a = va;
    80001116:	892e                	mv	s2,a1
    80001118:	40b68a33          	sub	s4,a3,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000111c:	4b85                	li	s7,1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    8000111e:	6c05                	lui	s8,0x1
    80001120:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001124:	865e                	mv	a2,s7
    80001126:	85ca                	mv	a1,s2
    80001128:	8556                	mv	a0,s5
    8000112a:	ee3ff0ef          	jal	8000100c <walk>
    8000112e:	c539                	beqz	a0,8000117c <mappages+0x98>
    if (*pte & PTE_V)
    80001130:	611c                	ld	a5,0(a0)
    80001132:	8b85                	andi	a5,a5,1
    80001134:	ef95                	bnez	a5,80001170 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001136:	80b1                	srli	s1,s1,0xc
    80001138:	04aa                	slli	s1,s1,0xa
    8000113a:	0164e4b3          	or	s1,s1,s6
    8000113e:	0014e493          	ori	s1,s1,1
    80001142:	e104                	sd	s1,0(a0)
    if (a == last)
    80001144:	05390963          	beq	s2,s3,80001196 <mappages+0xb2>
    a += PGSIZE;
    80001148:	9962                	add	s2,s2,s8
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000114a:	bfd9                	j	80001120 <mappages+0x3c>
    panic("mappages: va not aligned");
    8000114c:	00007517          	auipc	a0,0x7
    80001150:	f8450513          	addi	a0,a0,-124 # 800080d0 <etext+0xd0>
    80001154:	e9aff0ef          	jal	800007ee <panic>
    panic("mappages: size not aligned");
    80001158:	00007517          	auipc	a0,0x7
    8000115c:	f9850513          	addi	a0,a0,-104 # 800080f0 <etext+0xf0>
    80001160:	e8eff0ef          	jal	800007ee <panic>
    panic("mappages: size");
    80001164:	00007517          	auipc	a0,0x7
    80001168:	fac50513          	addi	a0,a0,-84 # 80008110 <etext+0x110>
    8000116c:	e82ff0ef          	jal	800007ee <panic>
      panic("mappages: remap");
    80001170:	00007517          	auipc	a0,0x7
    80001174:	fb050513          	addi	a0,a0,-80 # 80008120 <etext+0x120>
    80001178:	e76ff0ef          	jal	800007ee <panic>
      return -1;
    8000117c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000117e:	60a6                	ld	ra,72(sp)
    80001180:	6406                	ld	s0,64(sp)
    80001182:	74e2                	ld	s1,56(sp)
    80001184:	7942                	ld	s2,48(sp)
    80001186:	79a2                	ld	s3,40(sp)
    80001188:	7a02                	ld	s4,32(sp)
    8000118a:	6ae2                	ld	s5,24(sp)
    8000118c:	6b42                	ld	s6,16(sp)
    8000118e:	6ba2                	ld	s7,8(sp)
    80001190:	6c02                	ld	s8,0(sp)
    80001192:	6161                	addi	sp,sp,80
    80001194:	8082                	ret
  return 0;
    80001196:	4501                	li	a0,0
    80001198:	b7dd                	j	8000117e <mappages+0x9a>

000000008000119a <kvmmap>:
{
    8000119a:	1141                	addi	sp,sp,-16
    8000119c:	e406                	sd	ra,8(sp)
    8000119e:	e022                	sd	s0,0(sp)
    800011a0:	0800                	addi	s0,sp,16
    800011a2:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011a4:	86b2                	mv	a3,a2
    800011a6:	863e                	mv	a2,a5
    800011a8:	f3dff0ef          	jal	800010e4 <mappages>
    800011ac:	e509                	bnez	a0,800011b6 <kvmmap+0x1c>
}
    800011ae:	60a2                	ld	ra,8(sp)
    800011b0:	6402                	ld	s0,0(sp)
    800011b2:	0141                	addi	sp,sp,16
    800011b4:	8082                	ret
    panic("kvmmap");
    800011b6:	00007517          	auipc	a0,0x7
    800011ba:	f7a50513          	addi	a0,a0,-134 # 80008130 <etext+0x130>
    800011be:	e30ff0ef          	jal	800007ee <panic>

00000000800011c2 <kvmmake>:
{
    800011c2:	1101                	addi	sp,sp,-32
    800011c4:	ec06                	sd	ra,24(sp)
    800011c6:	e822                	sd	s0,16(sp)
    800011c8:	e426                	sd	s1,8(sp)
    800011ca:	e04a                	sd	s2,0(sp)
    800011cc:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800011ce:	967ff0ef          	jal	80000b34 <kalloc>
    800011d2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800011d4:	6605                	lui	a2,0x1
    800011d6:	4581                	li	a1,0
    800011d8:	b9fff0ef          	jal	80000d76 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800011dc:	4719                	li	a4,6
    800011de:	6685                	lui	a3,0x1
    800011e0:	10000637          	lui	a2,0x10000
    800011e4:	85b2                	mv	a1,a2
    800011e6:	8526                	mv	a0,s1
    800011e8:	fb3ff0ef          	jal	8000119a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800011ec:	4719                	li	a4,6
    800011ee:	6685                	lui	a3,0x1
    800011f0:	10001637          	lui	a2,0x10001
    800011f4:	85b2                	mv	a1,a2
    800011f6:	8526                	mv	a0,s1
    800011f8:	fa3ff0ef          	jal	8000119a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800011fc:	4719                	li	a4,6
    800011fe:	040006b7          	lui	a3,0x4000
    80001202:	0c000637          	lui	a2,0xc000
    80001206:	85b2                	mv	a1,a2
    80001208:	8526                	mv	a0,s1
    8000120a:	f91ff0ef          	jal	8000119a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000120e:	00007917          	auipc	s2,0x7
    80001212:	df290913          	addi	s2,s2,-526 # 80008000 <etext>
    80001216:	4729                	li	a4,10
    80001218:	80007697          	auipc	a3,0x80007
    8000121c:	de868693          	addi	a3,a3,-536 # 8000 <_entry-0x7fff8000>
    80001220:	4605                	li	a2,1
    80001222:	067e                	slli	a2,a2,0x1f
    80001224:	85b2                	mv	a1,a2
    80001226:	8526                	mv	a0,s1
    80001228:	f73ff0ef          	jal	8000119a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000122c:	4719                	li	a4,6
    8000122e:	46c5                	li	a3,17
    80001230:	06ee                	slli	a3,a3,0x1b
    80001232:	412686b3          	sub	a3,a3,s2
    80001236:	864a                	mv	a2,s2
    80001238:	85ca                	mv	a1,s2
    8000123a:	8526                	mv	a0,s1
    8000123c:	f5fff0ef          	jal	8000119a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001240:	4729                	li	a4,10
    80001242:	6685                	lui	a3,0x1
    80001244:	00006617          	auipc	a2,0x6
    80001248:	dbc60613          	addi	a2,a2,-580 # 80007000 <_trampoline>
    8000124c:	040005b7          	lui	a1,0x4000
    80001250:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001252:	05b2                	slli	a1,a1,0xc
    80001254:	8526                	mv	a0,s1
    80001256:	f45ff0ef          	jal	8000119a <kvmmap>
  proc_mapstacks(kpgtbl);
    8000125a:	8526                	mv	a0,s1
    8000125c:	2b9000ef          	jal	80001d14 <proc_mapstacks>
}
    80001260:	8526                	mv	a0,s1
    80001262:	60e2                	ld	ra,24(sp)
    80001264:	6442                	ld	s0,16(sp)
    80001266:	64a2                	ld	s1,8(sp)
    80001268:	6902                	ld	s2,0(sp)
    8000126a:	6105                	addi	sp,sp,32
    8000126c:	8082                	ret

000000008000126e <kvminit>:
{
    8000126e:	1141                	addi	sp,sp,-16
    80001270:	e406                	sd	ra,8(sp)
    80001272:	e022                	sd	s0,0(sp)
    80001274:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001276:	f4dff0ef          	jal	800011c2 <kvmmake>
    8000127a:	00007797          	auipc	a5,0x7
    8000127e:	62a7b323          	sd	a0,1574(a5) # 800088a0 <kernel_pagetable>
}
    80001282:	60a2                	ld	ra,8(sp)
    80001284:	6402                	ld	s0,0(sp)
    80001286:	0141                	addi	sp,sp,16
    80001288:	8082                	ret

000000008000128a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000128a:	1101                	addi	sp,sp,-32
    8000128c:	ec06                	sd	ra,24(sp)
    8000128e:	e822                	sd	s0,16(sp)
    80001290:	e426                	sd	s1,8(sp)
    80001292:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001294:	8a1ff0ef          	jal	80000b34 <kalloc>
    80001298:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000129a:	c509                	beqz	a0,800012a4 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000129c:	6605                	lui	a2,0x1
    8000129e:	4581                	li	a1,0
    800012a0:	ad7ff0ef          	jal	80000d76 <memset>
  return pagetable;
}
    800012a4:	8526                	mv	a0,s1
    800012a6:	60e2                	ld	ra,24(sp)
    800012a8:	6442                	ld	s0,16(sp)
    800012aa:	64a2                	ld	s1,8(sp)
    800012ac:	6105                	addi	sp,sp,32
    800012ae:	8082                	ret

00000000800012b0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012b0:	7139                	addi	sp,sp,-64
    800012b2:	fc06                	sd	ra,56(sp)
    800012b4:	f822                	sd	s0,48(sp)
    800012b6:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800012b8:	03459793          	slli	a5,a1,0x34
    800012bc:	e38d                	bnez	a5,800012de <uvmunmap+0x2e>
    800012be:	f04a                	sd	s2,32(sp)
    800012c0:	ec4e                	sd	s3,24(sp)
    800012c2:	e852                	sd	s4,16(sp)
    800012c4:	e456                	sd	s5,8(sp)
    800012c6:	e05a                	sd	s6,0(sp)
    800012c8:	8a2a                	mv	s4,a0
    800012ca:	892e                	mv	s2,a1
    800012cc:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800012ce:	0632                	slli	a2,a2,0xc
    800012d0:	00b609b3          	add	s3,a2,a1
    800012d4:	6b05                	lui	s6,0x1
    800012d6:	0535f963          	bgeu	a1,s3,80001328 <uvmunmap+0x78>
    800012da:	f426                	sd	s1,40(sp)
    800012dc:	a015                	j	80001300 <uvmunmap+0x50>
    800012de:	f426                	sd	s1,40(sp)
    800012e0:	f04a                	sd	s2,32(sp)
    800012e2:	ec4e                	sd	s3,24(sp)
    800012e4:	e852                	sd	s4,16(sp)
    800012e6:	e456                	sd	s5,8(sp)
    800012e8:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800012ea:	00007517          	auipc	a0,0x7
    800012ee:	e4e50513          	addi	a0,a0,-434 # 80008138 <etext+0x138>
    800012f2:	cfcff0ef          	jal	800007ee <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800012f6:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800012fa:	995a                	add	s2,s2,s6
    800012fc:	03397563          	bgeu	s2,s3,80001326 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001300:	4601                	li	a2,0
    80001302:	85ca                	mv	a1,s2
    80001304:	8552                	mv	a0,s4
    80001306:	d07ff0ef          	jal	8000100c <walk>
    8000130a:	84aa                	mv	s1,a0
    8000130c:	d57d                	beqz	a0,800012fa <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    8000130e:	611c                	ld	a5,0(a0)
    80001310:	0017f713          	andi	a4,a5,1
    80001314:	d37d                	beqz	a4,800012fa <uvmunmap+0x4a>
    if (do_free) {
    80001316:	fe0a80e3          	beqz	s5,800012f6 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000131a:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000131c:	00c79513          	slli	a0,a5,0xc
    80001320:	ec0ff0ef          	jal	800009e0 <kfree>
    80001324:	bfc9                	j	800012f6 <uvmunmap+0x46>
    80001326:	74a2                	ld	s1,40(sp)
    80001328:	7902                	ld	s2,32(sp)
    8000132a:	69e2                	ld	s3,24(sp)
    8000132c:	6a42                	ld	s4,16(sp)
    8000132e:	6aa2                	ld	s5,8(sp)
    80001330:	6b02                	ld	s6,0(sp)
  }
}
    80001332:	70e2                	ld	ra,56(sp)
    80001334:	7442                	ld	s0,48(sp)
    80001336:	6121                	addi	sp,sp,64
    80001338:	8082                	ret

000000008000133a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000133a:	1101                	addi	sp,sp,-32
    8000133c:	ec06                	sd	ra,24(sp)
    8000133e:	e822                	sd	s0,16(sp)
    80001340:	e426                	sd	s1,8(sp)
    80001342:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    80001344:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    80001346:	00b67d63          	bgeu	a2,a1,80001360 <uvmdealloc+0x26>
    8000134a:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000134c:	6785                	lui	a5,0x1
    8000134e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001350:	00f60733          	add	a4,a2,a5
    80001354:	76fd                	lui	a3,0xfffff
    80001356:	8f75                	and	a4,a4,a3
    80001358:	97ae                	add	a5,a5,a1
    8000135a:	8ff5                	and	a5,a5,a3
    8000135c:	00f76863          	bltu	a4,a5,8000136c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001360:	8526                	mv	a0,s1
    80001362:	60e2                	ld	ra,24(sp)
    80001364:	6442                	ld	s0,16(sp)
    80001366:	64a2                	ld	s1,8(sp)
    80001368:	6105                	addi	sp,sp,32
    8000136a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000136c:	8f99                	sub	a5,a5,a4
    8000136e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001370:	4685                	li	a3,1
    80001372:	0007861b          	sext.w	a2,a5
    80001376:	85ba                	mv	a1,a4
    80001378:	f39ff0ef          	jal	800012b0 <uvmunmap>
    8000137c:	b7d5                	j	80001360 <uvmdealloc+0x26>

000000008000137e <uvmalloc>:
  if (newsz < oldsz)
    8000137e:	0ab66363          	bltu	a2,a1,80001424 <uvmalloc+0xa6>
{
    80001382:	715d                	addi	sp,sp,-80
    80001384:	e486                	sd	ra,72(sp)
    80001386:	e0a2                	sd	s0,64(sp)
    80001388:	f052                	sd	s4,32(sp)
    8000138a:	ec56                	sd	s5,24(sp)
    8000138c:	e85a                	sd	s6,16(sp)
    8000138e:	0880                	addi	s0,sp,80
    80001390:	8b2a                	mv	s6,a0
    80001392:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80001394:	6785                	lui	a5,0x1
    80001396:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001398:	95be                	add	a1,a1,a5
    8000139a:	77fd                	lui	a5,0xfffff
    8000139c:	00f5fa33          	and	s4,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800013a0:	08ca7463          	bgeu	s4,a2,80001428 <uvmalloc+0xaa>
    800013a4:	fc26                	sd	s1,56(sp)
    800013a6:	f84a                	sd	s2,48(sp)
    800013a8:	f44e                	sd	s3,40(sp)
    800013aa:	e45e                	sd	s7,8(sp)
    800013ac:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    800013ae:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800013b0:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    800013b4:	f80ff0ef          	jal	80000b34 <kalloc>
    800013b8:	84aa                	mv	s1,a0
    if (mem == 0) {
    800013ba:	c515                	beqz	a0,800013e6 <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800013bc:	864e                	mv	a2,s3
    800013be:	4581                	li	a1,0
    800013c0:	9b7ff0ef          	jal	80000d76 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800013c4:	875e                	mv	a4,s7
    800013c6:	86a6                	mv	a3,s1
    800013c8:	864e                	mv	a2,s3
    800013ca:	85ca                	mv	a1,s2
    800013cc:	855a                	mv	a0,s6
    800013ce:	d17ff0ef          	jal	800010e4 <mappages>
    800013d2:	e91d                	bnez	a0,80001408 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800013d4:	994e                	add	s2,s2,s3
    800013d6:	fd596fe3          	bltu	s2,s5,800013b4 <uvmalloc+0x36>
  return newsz;
    800013da:	8556                	mv	a0,s5
    800013dc:	74e2                	ld	s1,56(sp)
    800013de:	7942                	ld	s2,48(sp)
    800013e0:	79a2                	ld	s3,40(sp)
    800013e2:	6ba2                	ld	s7,8(sp)
    800013e4:	a819                	j	800013fa <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800013e6:	8652                	mv	a2,s4
    800013e8:	85ca                	mv	a1,s2
    800013ea:	855a                	mv	a0,s6
    800013ec:	f4fff0ef          	jal	8000133a <uvmdealloc>
      return 0;
    800013f0:	4501                	li	a0,0
    800013f2:	74e2                	ld	s1,56(sp)
    800013f4:	7942                	ld	s2,48(sp)
    800013f6:	79a2                	ld	s3,40(sp)
    800013f8:	6ba2                	ld	s7,8(sp)
}
    800013fa:	60a6                	ld	ra,72(sp)
    800013fc:	6406                	ld	s0,64(sp)
    800013fe:	7a02                	ld	s4,32(sp)
    80001400:	6ae2                	ld	s5,24(sp)
    80001402:	6b42                	ld	s6,16(sp)
    80001404:	6161                	addi	sp,sp,80
    80001406:	8082                	ret
      kfree(mem);
    80001408:	8526                	mv	a0,s1
    8000140a:	dd6ff0ef          	jal	800009e0 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000140e:	8652                	mv	a2,s4
    80001410:	85ca                	mv	a1,s2
    80001412:	855a                	mv	a0,s6
    80001414:	f27ff0ef          	jal	8000133a <uvmdealloc>
      return 0;
    80001418:	4501                	li	a0,0
    8000141a:	74e2                	ld	s1,56(sp)
    8000141c:	7942                	ld	s2,48(sp)
    8000141e:	79a2                	ld	s3,40(sp)
    80001420:	6ba2                	ld	s7,8(sp)
    80001422:	bfe1                	j	800013fa <uvmalloc+0x7c>
    return oldsz;
    80001424:	852e                	mv	a0,a1
}
    80001426:	8082                	ret
  return newsz;
    80001428:	8532                	mv	a0,a2
    8000142a:	bfc1                	j	800013fa <uvmalloc+0x7c>

000000008000142c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
    8000143c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    8000143e:	84aa                	mv	s1,a0
    80001440:	6905                	lui	s2,0x1
    80001442:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001444:	4985                	li	s3,1
    80001446:	a819                	j	8000145c <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001448:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000144a:	00c79513          	slli	a0,a5,0xc
    8000144e:	fdfff0ef          	jal	8000142c <freewalk>
      pagetable[i] = 0;
    80001452:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    80001456:	04a1                	addi	s1,s1,8
    80001458:	01248f63          	beq	s1,s2,80001476 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000145c:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000145e:	00f7f713          	andi	a4,a5,15
    80001462:	ff3703e3          	beq	a4,s3,80001448 <freewalk+0x1c>
    } else if (pte & PTE_V) {
    80001466:	8b85                	andi	a5,a5,1
    80001468:	d7fd                	beqz	a5,80001456 <freewalk+0x2a>
      panic("freewalk: leaf");
    8000146a:	00007517          	auipc	a0,0x7
    8000146e:	ce650513          	addi	a0,a0,-794 # 80008150 <etext+0x150>
    80001472:	b7cff0ef          	jal	800007ee <panic>
    }
  }
  kfree((void *)pagetable);
    80001476:	8552                	mv	a0,s4
    80001478:	d68ff0ef          	jal	800009e0 <kfree>
}
    8000147c:	70a2                	ld	ra,40(sp)
    8000147e:	7402                	ld	s0,32(sp)
    80001480:	64e2                	ld	s1,24(sp)
    80001482:	6942                	ld	s2,16(sp)
    80001484:	69a2                	ld	s3,8(sp)
    80001486:	6a02                	ld	s4,0(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret

000000008000148c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000148c:	1101                	addi	sp,sp,-32
    8000148e:	ec06                	sd	ra,24(sp)
    80001490:	e822                	sd	s0,16(sp)
    80001492:	e426                	sd	s1,8(sp)
    80001494:	1000                	addi	s0,sp,32
    80001496:	84aa                	mv	s1,a0
  if (sz > 0)
    80001498:	e989                	bnez	a1,800014aa <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    8000149a:	8526                	mv	a0,s1
    8000149c:	f91ff0ef          	jal	8000142c <freewalk>
}
    800014a0:	60e2                	ld	ra,24(sp)
    800014a2:	6442                	ld	s0,16(sp)
    800014a4:	64a2                	ld	s1,8(sp)
    800014a6:	6105                	addi	sp,sp,32
    800014a8:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800014aa:	6785                	lui	a5,0x1
    800014ac:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014ae:	95be                	add	a1,a1,a5
    800014b0:	4685                	li	a3,1
    800014b2:	00c5d613          	srli	a2,a1,0xc
    800014b6:	4581                	li	a1,0
    800014b8:	df9ff0ef          	jal	800012b0 <uvmunmap>
    800014bc:	bff9                	j	8000149a <uvmfree+0xe>

00000000800014be <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    800014be:	c655                	beqz	a2,8000156a <uvmcopy+0xac>
{
    800014c0:	715d                	addi	sp,sp,-80
    800014c2:	e486                	sd	ra,72(sp)
    800014c4:	e0a2                	sd	s0,64(sp)
    800014c6:	fc26                	sd	s1,56(sp)
    800014c8:	f84a                	sd	s2,48(sp)
    800014ca:	f44e                	sd	s3,40(sp)
    800014cc:	f052                	sd	s4,32(sp)
    800014ce:	ec56                	sd	s5,24(sp)
    800014d0:	e85a                	sd	s6,16(sp)
    800014d2:	e45e                	sd	s7,8(sp)
    800014d4:	0880                	addi	s0,sp,80
    800014d6:	8aaa                	mv	s5,a0
    800014d8:	8b2e                	mv	s6,a1
    800014da:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014dc:	4481                	li	s1,0
    }

    // Parent and child now share the same physical page.
    incref((void*)pa);

    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800014de:	6985                	lui	s3,0x1
    800014e0:	a805                	j	80001510 <uvmcopy+0x52>
      flags = (flags & ~PTE_W) | PTE_COW;
    800014e2:	2fbbfb93          	andi	s7,s7,763
    800014e6:	100beb93          	ori	s7,s7,256
      *pte = (*pte & ~PTE_W) | PTE_COW;
    800014ea:	efb7f793          	andi	a5,a5,-261
    800014ee:	1007e793          	ori	a5,a5,256
    800014f2:	e11c                	sd	a5,0(a0)
    incref((void*)pa);
    800014f4:	854a                	mv	a0,s2
    800014f6:	eb4ff0ef          	jal	80000baa <incref>
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800014fa:	875e                	mv	a4,s7
    800014fc:	86ca                	mv	a3,s2
    800014fe:	864e                	mv	a2,s3
    80001500:	85a6                	mv	a1,s1
    80001502:	855a                	mv	a0,s6
    80001504:	be1ff0ef          	jal	800010e4 <mappages>
    80001508:	e90d                	bnez	a0,8000153a <uvmcopy+0x7c>
  for(i = 0; i < sz; i += PGSIZE){
    8000150a:	94ce                	add	s1,s1,s3
    8000150c:	0544f363          	bgeu	s1,s4,80001552 <uvmcopy+0x94>
    if((pte = walk(old, i, 0)) == 0)
    80001510:	4601                	li	a2,0
    80001512:	85a6                	mv	a1,s1
    80001514:	8556                	mv	a0,s5
    80001516:	af7ff0ef          	jal	8000100c <walk>
    8000151a:	d965                	beqz	a0,8000150a <uvmcopy+0x4c>
    if((*pte & PTE_V) == 0)
    8000151c:	611c                	ld	a5,0(a0)
    8000151e:	0017f713          	andi	a4,a5,1
    80001522:	d765                	beqz	a4,8000150a <uvmcopy+0x4c>
    pa = PTE2PA(*pte);
    80001524:	00a7d913          	srli	s2,a5,0xa
    80001528:	0932                	slli	s2,s2,0xc
    flags = PTE_FLAGS(*pte);
    8000152a:	00078b9b          	sext.w	s7,a5
    if(flags & PTE_W){
    8000152e:	0047f713          	andi	a4,a5,4
    80001532:	fb45                	bnez	a4,800014e2 <uvmcopy+0x24>
    flags = PTE_FLAGS(*pte);
    80001534:	3ffbfb93          	andi	s7,s7,1023
    80001538:	bf75                	j	800014f4 <uvmcopy+0x36>
      decref((void*)pa);
    8000153a:	854a                	mv	a0,s2
    8000153c:	eecff0ef          	jal	80000c28 <decref>
  }

  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001540:	4685                	li	a3,1
    80001542:	00c4d613          	srli	a2,s1,0xc
    80001546:	4581                	li	a1,0
    80001548:	855a                	mv	a0,s6
    8000154a:	d67ff0ef          	jal	800012b0 <uvmunmap>
  return -1;
    8000154e:	557d                	li	a0,-1
    80001550:	a011                	j	80001554 <uvmcopy+0x96>
  return 0;
    80001552:	4501                	li	a0,0
}
    80001554:	60a6                	ld	ra,72(sp)
    80001556:	6406                	ld	s0,64(sp)
    80001558:	74e2                	ld	s1,56(sp)
    8000155a:	7942                	ld	s2,48(sp)
    8000155c:	79a2                	ld	s3,40(sp)
    8000155e:	7a02                	ld	s4,32(sp)
    80001560:	6ae2                	ld	s5,24(sp)
    80001562:	6b42                	ld	s6,16(sp)
    80001564:	6ba2                	ld	s7,8(sp)
    80001566:	6161                	addi	sp,sp,80
    80001568:	8082                	ret
  return 0;
    8000156a:	4501                	li	a0,0
}
    8000156c:	8082                	ret

000000008000156e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000156e:	1141                	addi	sp,sp,-16
    80001570:	e406                	sd	ra,8(sp)
    80001572:	e022                	sd	s0,0(sp)
    80001574:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001576:	4601                	li	a2,0
    80001578:	a95ff0ef          	jal	8000100c <walk>
  if (pte == 0)
    8000157c:	c901                	beqz	a0,8000158c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000157e:	611c                	ld	a5,0(a0)
    80001580:	9bbd                	andi	a5,a5,-17
    80001582:	e11c                	sd	a5,0(a0)
}
    80001584:	60a2                	ld	ra,8(sp)
    80001586:	6402                	ld	s0,0(sp)
    80001588:	0141                	addi	sp,sp,16
    8000158a:	8082                	ret
    panic("uvmclear");
    8000158c:	00007517          	auipc	a0,0x7
    80001590:	bd450513          	addi	a0,a0,-1068 # 80008160 <etext+0x160>
    80001594:	a5aff0ef          	jal	800007ee <panic>

0000000080001598 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001598:	1141                	addi	sp,sp,-16
    8000159a:	e406                	sd	ra,8(sp)
    8000159c:	e022                	sd	s0,0(sp)
    8000159e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800015a0:	4601                	li	a2,0
    800015a2:	a6bff0ef          	jal	8000100c <walk>
  if (pte == 0) {
    800015a6:	c519                	beqz	a0,800015b4 <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V) {
    800015a8:	6108                	ld	a0,0(a0)
    800015aa:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800015ac:	60a2                	ld	ra,8(sp)
    800015ae:	6402                	ld	s0,0(sp)
    800015b0:	0141                	addi	sp,sp,16
    800015b2:	8082                	ret
    return 0;
    800015b4:	4501                	li	a0,0
    800015b6:	bfdd                	j	800015ac <ismapped+0x14>

00000000800015b8 <vmfault>:
{
    800015b8:	7179                	addi	sp,sp,-48
    800015ba:	f406                	sd	ra,40(sp)
    800015bc:	f022                	sd	s0,32(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	1800                	addi	s0,sp,48
    return 0;
    800015c2:	4981                	li	s3,0
  if (va >= psz)
    800015c4:	00b66863          	bltu	a2,a1,800015d4 <vmfault+0x1c>
}
    800015c8:	854e                	mv	a0,s3
    800015ca:	70a2                	ld	ra,40(sp)
    800015cc:	7402                	ld	s0,32(sp)
    800015ce:	69a2                	ld	s3,8(sp)
    800015d0:	6145                	addi	sp,sp,48
    800015d2:	8082                	ret
    800015d4:	ec26                	sd	s1,24(sp)
    800015d6:	e84a                	sd	s2,16(sp)
    800015d8:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    800015da:	77fd                	lui	a5,0xfffff
    800015dc:	00f674b3          	and	s1,a2,a5
  if (ismapped(pagetable, va)) {
    800015e0:	85a6                	mv	a1,s1
    800015e2:	fb7ff0ef          	jal	80001598 <ismapped>
    return 0;
    800015e6:	4981                	li	s3,0
  if (ismapped(pagetable, va)) {
    800015e8:	c501                	beqz	a0,800015f0 <vmfault+0x38>
    800015ea:	64e2                	ld	s1,24(sp)
    800015ec:	6942                	ld	s2,16(sp)
    800015ee:	bfe9                	j	800015c8 <vmfault+0x10>
    800015f0:	e052                	sd	s4,0(sp)
  mem = (uint64)kalloc();
    800015f2:	d42ff0ef          	jal	80000b34 <kalloc>
    800015f6:	8a2a                	mv	s4,a0
  if (mem == 0)
    800015f8:	c915                	beqz	a0,8000162c <vmfault+0x74>
  mem = (uint64)kalloc();
    800015fa:	89aa                	mv	s3,a0
  memset((void *)mem, 0, PGSIZE);
    800015fc:	6605                	lui	a2,0x1
    800015fe:	4581                	li	a1,0
    80001600:	f76ff0ef          	jal	80000d76 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001604:	4759                	li	a4,22
    80001606:	86d2                	mv	a3,s4
    80001608:	6605                	lui	a2,0x1
    8000160a:	85a6                	mv	a1,s1
    8000160c:	854a                	mv	a0,s2
    8000160e:	ad7ff0ef          	jal	800010e4 <mappages>
    80001612:	e509                	bnez	a0,8000161c <vmfault+0x64>
    80001614:	64e2                	ld	s1,24(sp)
    80001616:	6942                	ld	s2,16(sp)
    80001618:	6a02                	ld	s4,0(sp)
    8000161a:	b77d                	j	800015c8 <vmfault+0x10>
    kfree((void *)mem);
    8000161c:	8552                	mv	a0,s4
    8000161e:	bc2ff0ef          	jal	800009e0 <kfree>
    return 0;
    80001622:	4981                	li	s3,0
    80001624:	64e2                	ld	s1,24(sp)
    80001626:	6942                	ld	s2,16(sp)
    80001628:	6a02                	ld	s4,0(sp)
    8000162a:	bf79                	j	800015c8 <vmfault+0x10>
    8000162c:	64e2                	ld	s1,24(sp)
    8000162e:	6942                	ld	s2,16(sp)
    80001630:	6a02                	ld	s4,0(sp)
    80001632:	bf59                	j	800015c8 <vmfault+0x10>

0000000080001634 <copyinstr>:
{
    80001634:	711d                	addi	sp,sp,-96
    80001636:	ec86                	sd	ra,88(sp)
    80001638:	e8a2                	sd	s0,80(sp)
    8000163a:	e4a6                	sd	s1,72(sp)
    8000163c:	e0ca                	sd	s2,64(sp)
    8000163e:	fc4e                	sd	s3,56(sp)
    80001640:	f852                	sd	s4,48(sp)
    80001642:	f456                	sd	s5,40(sp)
    80001644:	f05a                	sd	s6,32(sp)
    80001646:	ec5e                	sd	s7,24(sp)
    80001648:	e862                	sd	s8,16(sp)
    8000164a:	e466                	sd	s9,8(sp)
    8000164c:	1080                	addi	s0,sp,96
    8000164e:	8aaa                	mv	s5,a0
    80001650:	8bae                	mv	s7,a1
    80001652:	89b2                	mv	s3,a2
    80001654:	8cb6                	mv	s9,a3
    80001656:	84ba                	mv	s1,a4
    va0 = PGROUNDDOWN(srcva);
    80001658:	7b7d                	lui	s6,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    8000165a:	4c05                	li	s8,1
    n = PGSIZE - (srcva - va0);
    8000165c:	6a05                	lui	s4,0x1
    8000165e:	a081                	j	8000169e <copyinstr+0x6a>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001660:	86e2                	mv	a3,s8
    80001662:	864a                	mv	a2,s2
    80001664:	85de                	mv	a1,s7
    80001666:	8556                	mv	a0,s5
    80001668:	f51ff0ef          	jal	800015b8 <vmfault>
    8000166c:	e129                	bnez	a0,800016ae <copyinstr+0x7a>
        return -1;
    8000166e:	557d                	li	a0,-1
    80001670:	a801                	j	80001680 <copyinstr+0x4c>
        *dst = '\0';
    80001672:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdaf208>
    80001676:	4785                	li	a5,1
  if (got_null) {
    80001678:	0017c793          	xori	a5,a5,1
    8000167c:	40f0053b          	negw	a0,a5
}
    80001680:	60e6                	ld	ra,88(sp)
    80001682:	6446                	ld	s0,80(sp)
    80001684:	64a6                	ld	s1,72(sp)
    80001686:	6906                	ld	s2,64(sp)
    80001688:	79e2                	ld	s3,56(sp)
    8000168a:	7a42                	ld	s4,48(sp)
    8000168c:	7aa2                	ld	s5,40(sp)
    8000168e:	7b02                	ld	s6,32(sp)
    80001690:	6be2                	ld	s7,24(sp)
    80001692:	6c42                	ld	s8,16(sp)
    80001694:	6ca2                	ld	s9,8(sp)
    80001696:	6125                	addi	sp,sp,96
    80001698:	8082                	ret
    srcva = va0 + PGSIZE;
    8000169a:	01490cb3          	add	s9,s2,s4
  while (got_null == 0 && max > 0) {
    8000169e:	c4b1                	beqz	s1,800016ea <copyinstr+0xb6>
    va0 = PGROUNDDOWN(srcva);
    800016a0:	016cf933          	and	s2,s9,s6
    pa0 = walkaddr(pagetable, va0);
    800016a4:	85ca                	mv	a1,s2
    800016a6:	8556                	mv	a0,s5
    800016a8:	9ffff0ef          	jal	800010a6 <walkaddr>
    if (pa0 == 0) {
    800016ac:	d955                	beqz	a0,80001660 <copyinstr+0x2c>
    n = PGSIZE - (srcva - va0);
    800016ae:	41990733          	sub	a4,s2,s9
    800016b2:	9752                	add	a4,a4,s4
    if (n > max)
    800016b4:	00e4f363          	bgeu	s1,a4,800016ba <copyinstr+0x86>
    800016b8:	8726                	mv	a4,s1
    char *p = (char *)(pa0 + (srcva - va0));
    800016ba:	412c8cb3          	sub	s9,s9,s2
    800016be:	9caa                	add	s9,s9,a0
    while (n > 0) {
    800016c0:	df69                	beqz	a4,8000169a <copyinstr+0x66>
    800016c2:	87ce                	mv	a5,s3
      if (*p == '\0') {
    800016c4:	413c8633          	sub	a2,s9,s3
    while (n > 0) {
    800016c8:	974e                	add	a4,a4,s3
    800016ca:	85be                	mv	a1,a5
      if (*p == '\0') {
    800016cc:	00f606b3          	add	a3,a2,a5
    800016d0:	0006c683          	lbu	a3,0(a3) # fffffffffffff000 <end+0xffffffff7fdaf208>
    800016d4:	ded9                	beqz	a3,80001672 <copyinstr+0x3e>
        *dst = *p;
    800016d6:	00d78023          	sb	a3,0(a5)
      dst++;
    800016da:	0785                	addi	a5,a5,1
    while (n > 0) {
    800016dc:	fee797e3          	bne	a5,a4,800016ca <copyinstr+0x96>
    800016e0:	14fd                	addi	s1,s1,-1
    800016e2:	94ce                	add	s1,s1,s3
      --max;
    800016e4:	8c8d                	sub	s1,s1,a1
    800016e6:	89be                	mv	s3,a5
    800016e8:	bf4d                	j	8000169a <copyinstr+0x66>
    800016ea:	4781                	li	a5,0
    800016ec:	b771                	j	80001678 <copyinstr+0x44>

00000000800016ee <cowalloc>:


uint64
cowalloc(pagetable_t pagetable, uint64 va)
{
    800016ee:	7139                	addi	sp,sp,-64
    800016f0:	fc06                	sd	ra,56(sp)
    800016f2:	f822                	sd	s0,48(sp)
    800016f4:	f426                	sd	s1,40(sp)
    800016f6:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa;
  uint flags;
  char *mem;

  if(va >= MAXVA)
    800016f8:	57fd                	li	a5,-1
    800016fa:	83e9                	srli	a5,a5,0x1a
    return 0;
    800016fc:	4481                	li	s1,0
  if(va >= MAXVA)
    800016fe:	00b7f863          	bgeu	a5,a1,8000170e <cowalloc+0x20>
  *pte = PA2PTE((uint64)mem) | flags;

  decref((void*)pa);

  return (uint64)mem;
}
    80001702:	8526                	mv	a0,s1
    80001704:	70e2                	ld	ra,56(sp)
    80001706:	7442                	ld	s0,48(sp)
    80001708:	74a2                	ld	s1,40(sp)
    8000170a:	6121                	addi	sp,sp,64
    8000170c:	8082                	ret
    8000170e:	f04a                	sd	s2,32(sp)
  if((pte = walk(pagetable, va, 0)) == 0)
    80001710:	4601                	li	a2,0
    80001712:	77fd                	lui	a5,0xfffff
    80001714:	8dfd                	and	a1,a1,a5
    80001716:	8f7ff0ef          	jal	8000100c <walk>
    8000171a:	892a                	mv	s2,a0
    8000171c:	c949                	beqz	a0,800017ae <cowalloc+0xc0>
    8000171e:	ec4e                	sd	s3,24(sp)
  if((*pte & PTE_V) == 0)
    80001720:	00053983          	ld	s3,0(a0)
  if((*pte & PTE_COW) == 0)
    80001724:	1019f713          	andi	a4,s3,257
    80001728:	10100793          	li	a5,257
    return 0;
    8000172c:	4481                	li	s1,0
  if((*pte & PTE_COW) == 0)
    8000172e:	00f70563          	beq	a4,a5,80001738 <cowalloc+0x4a>
    80001732:	7902                	ld	s2,32(sp)
    80001734:	69e2                	ld	s3,24(sp)
    80001736:	b7f1                	j	80001702 <cowalloc+0x14>
    80001738:	e852                	sd	s4,16(sp)
    8000173a:	e456                	sd	s5,8(sp)
  pa = PTE2PA(*pte);
    8000173c:	00a9d493          	srli	s1,s3,0xa
    80001740:	04b2                	slli	s1,s1,0xc
  flags = PTE_FLAGS(*pte);
    80001742:	00098a1b          	sext.w	s4,s3
  if(getref((void*)pa) == 1){
    80001746:	8aa6                	mv	s5,s1
    80001748:	8526                	mv	a0,s1
    8000174a:	ca0ff0ef          	jal	80000bea <getref>
    8000174e:	4785                	li	a5,1
    80001750:	02f50e63          	beq	a0,a5,8000178c <cowalloc+0x9e>
  mem = kalloc();
    80001754:	be0ff0ef          	jal	80000b34 <kalloc>
    80001758:	89aa                	mv	s3,a0
  if(mem == 0)
    8000175a:	cd29                	beqz	a0,800017b4 <cowalloc+0xc6>
  memmove(mem, (char*)pa, PGSIZE);
    8000175c:	6605                	lui	a2,0x1
    8000175e:	85a6                	mv	a1,s1
    80001760:	e7aff0ef          	jal	80000dda <memmove>
  *pte = PA2PTE((uint64)mem) | flags;
    80001764:	84ce                	mv	s1,s3
    80001766:	00c9d793          	srli	a5,s3,0xc
    8000176a:	07aa                	slli	a5,a5,0xa
  flags = (flags | PTE_W) & ~PTE_COW;
    8000176c:	2ffa7a13          	andi	s4,s4,767
  *pte = PA2PTE((uint64)mem) | flags;
    80001770:	004a6a13          	ori	s4,s4,4
    80001774:	0147e7b3          	or	a5,a5,s4
    80001778:	00f93023          	sd	a5,0(s2) # 1000 <_entry-0x7ffff000>
  decref((void*)pa);
    8000177c:	8556                	mv	a0,s5
    8000177e:	caaff0ef          	jal	80000c28 <decref>
  return (uint64)mem;
    80001782:	7902                	ld	s2,32(sp)
    80001784:	69e2                	ld	s3,24(sp)
    80001786:	6a42                	ld	s4,16(sp)
    80001788:	6aa2                	ld	s5,8(sp)
    8000178a:	bfa5                	j	80001702 <cowalloc+0x14>
    *pte = PA2PTE(pa) | ((flags | PTE_W) & ~PTE_COW);
    8000178c:	2ffa7793          	andi	a5,s4,767
    80001790:	0047e793          	ori	a5,a5,4
    80001794:	777d                	lui	a4,0xfffff
    80001796:	8309                	srli	a4,a4,0x2
    80001798:	00e9f9b3          	and	s3,s3,a4
    8000179c:	0137e7b3          	or	a5,a5,s3
    800017a0:	00f93023          	sd	a5,0(s2)
    return pa;
    800017a4:	7902                	ld	s2,32(sp)
    800017a6:	69e2                	ld	s3,24(sp)
    800017a8:	6a42                	ld	s4,16(sp)
    800017aa:	6aa2                	ld	s5,8(sp)
    800017ac:	bf99                	j	80001702 <cowalloc+0x14>
    return 0;
    800017ae:	4481                	li	s1,0
    800017b0:	7902                	ld	s2,32(sp)
    800017b2:	bf81                	j	80001702 <cowalloc+0x14>
    return 0;
    800017b4:	4481                	li	s1,0
    800017b6:	7902                	ld	s2,32(sp)
    800017b8:	69e2                	ld	s3,24(sp)
    800017ba:	6a42                	ld	s4,16(sp)
    800017bc:	6aa2                	ld	s5,8(sp)
    800017be:	b791                	j	80001702 <cowalloc+0x14>

00000000800017c0 <mmapfault>:


uint64
mmapfault(pagetable_t pagetable, uint64 va, int read)
{
    800017c0:	715d                	addi	sp,sp,-80
    800017c2:	e486                	sd	ra,72(sp)
    800017c4:	e0a2                	sd	s0,64(sp)
    800017c6:	fc26                	sd	s1,56(sp)
    800017c8:	f84a                	sd	s2,48(sp)
    800017ca:	f44e                	sd	s3,40(sp)
    800017cc:	f052                	sd	s4,32(sp)
    800017ce:	ec56                	sd	s5,24(sp)
    800017d0:	0880                	addi	s0,sp,80
    800017d2:	8a2a                	mv	s4,a0
    800017d4:	892e                	mv	s2,a1
    800017d6:	8ab2                	mv	s5,a2
  struct proc *p = myproc();
    800017d8:	6be000ef          	jal	80001e96 <myproc>
    800017dc:	89aa                	mv	s3,a0
  uint64 mem;
  uint64 offset;
  int perm;
  int n;

  va = PGROUNDDOWN(va);
    800017de:	77fd                	lui	a5,0xfffff
    800017e0:	00f97933          	and	s2,s2,a5

  for(int i = 0; i < NVMA; i++){
    800017e4:	16050793          	addi	a5,a0,352
    800017e8:	4481                	li	s1,0
    800017ea:	46c1                	li	a3,16
    800017ec:	a0b9                	j	8000183a <mmapfault+0x7a>

    if(va >= vma->addr && va < vma->addr + vma->maplen){
      if(read && !(vma->prot & PROT_READ))
        return 0;

      if(!read && !(vma->prot & PROT_WRITE))
    800017ee:	00349793          	slli	a5,s1,0x3
    800017f2:	8f85                	sub	a5,a5,s1
    800017f4:	078e                	slli	a5,a5,0x3
    800017f6:	97ce                	add	a5,a5,s3
    800017f8:	1807a783          	lw	a5,384(a5) # fffffffffffff180 <end+0xffffffff7fdaf388>
    800017fc:	8b89                	andi	a5,a5,2
        return 0;
    800017fe:	4a81                	li	s5,0
      if(!read && !(vma->prot & PROT_WRITE))
    80001800:	e3b5                	bnez	a5,80001864 <mmapfault+0xa4>
    80001802:	a219                	j	80001908 <mmapfault+0x148>

      if(ismapped(pagetable, va))
        return walkaddr(pagetable, va);
    80001804:	85ca                	mv	a1,s2
    80001806:	8552                	mv	a0,s4
    80001808:	89fff0ef          	jal	800010a6 <walkaddr>
    8000180c:	8aaa                	mv	s5,a0
    8000180e:	a8ed                	j	80001908 <mmapfault+0x148>
      ilock(vma->file->ip);
      n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
      iunlock(vma->file->ip);

      if(n < 0){
        kfree((void *)mem);
    80001810:	855e                	mv	a0,s7
    80001812:	9ceff0ef          	jal	800009e0 <kfree>
        return 0;
    80001816:	4a81                	li	s5,0
    80001818:	6b42                	ld	s6,16(sp)
    8000181a:	6ba2                	ld	s7,8(sp)
    8000181c:	6c02                	ld	s8,0(sp)
    8000181e:	a0ed                	j	80001908 <mmapfault+0x148>

      if(vma->prot & PROT_WRITE)
        perm |= PTE_W;

      if(mappages(pagetable, va, PGSIZE, mem, perm) != 0){
        kfree((void *)mem);
    80001820:	855e                	mv	a0,s7
    80001822:	9beff0ef          	jal	800009e0 <kfree>
        return 0;
    80001826:	4a81                	li	s5,0
    80001828:	6b42                	ld	s6,16(sp)
    8000182a:	6ba2                	ld	s7,8(sp)
    8000182c:	6c02                	ld	s8,0(sp)
    8000182e:	a8e9                	j	80001908 <mmapfault+0x148>
  for(int i = 0; i < NVMA; i++){
    80001830:	2485                	addiw	s1,s1,1
    80001832:	03878793          	addi	a5,a5,56
    80001836:	0cd48863          	beq	s1,a3,80001906 <mmapfault+0x146>
    if(vma->used == 0)
    8000183a:	4398                	lw	a4,0(a5)
    8000183c:	db75                	beqz	a4,80001830 <mmapfault+0x70>
    if(va >= vma->addr && va < vma->addr + vma->maplen){
    8000183e:	6798                	ld	a4,8(a5)
    80001840:	fee968e3          	bltu	s2,a4,80001830 <mmapfault+0x70>
    80001844:	6f8c                	ld	a1,24(a5)
    80001846:	972e                	add	a4,a4,a1
    80001848:	fee974e3          	bgeu	s2,a4,80001830 <mmapfault+0x70>
      if(read && !(vma->prot & PROT_READ))
    8000184c:	fa0a81e3          	beqz	s5,800017ee <mmapfault+0x2e>
    80001850:	00349793          	slli	a5,s1,0x3
    80001854:	8f85                	sub	a5,a5,s1
    80001856:	078e                	slli	a5,a5,0x3
    80001858:	97ce                	add	a5,a5,s3
    8000185a:	1807a783          	lw	a5,384(a5)
    8000185e:	8b85                	andi	a5,a5,1
        return 0;
    80001860:	4a81                	li	s5,0
      if(read && !(vma->prot & PROT_READ))
    80001862:	c3dd                	beqz	a5,80001908 <mmapfault+0x148>
      if(ismapped(pagetable, va))
    80001864:	85ca                	mv	a1,s2
    80001866:	8552                	mv	a0,s4
    80001868:	d31ff0ef          	jal	80001598 <ismapped>
    8000186c:	fd41                	bnez	a0,80001804 <mmapfault+0x44>
    8000186e:	e45e                	sd	s7,8(sp)
      mem = (uint64)kalloc();
    80001870:	ac4ff0ef          	jal	80000b34 <kalloc>
    80001874:	8baa                	mv	s7,a0
        return 0;
    80001876:	4a81                	li	s5,0
      if(mem == 0)
    80001878:	c155                	beqz	a0,8000191c <mmapfault+0x15c>
    8000187a:	e85a                	sd	s6,16(sp)
    8000187c:	e062                	sd	s8,0(sp)
      mem = (uint64)kalloc();
    8000187e:	8aaa                	mv	s5,a0
      memset((void *)mem, 0, PGSIZE);
    80001880:	6605                	lui	a2,0x1
    80001882:	4581                	li	a1,0
    80001884:	cf2ff0ef          	jal	80000d76 <memset>
      offset = vma->offset + (va - vma->addr);
    80001888:	00349b13          	slli	s6,s1,0x3
    8000188c:	409b0b33          	sub	s6,s6,s1
    80001890:	0b0e                	slli	s6,s6,0x3
    80001892:	9b4e                	add	s6,s6,s3
    80001894:	190b3c03          	ld	s8,400(s6) # fffffffffffff190 <end+0xffffffff7fdaf398>
    80001898:	9c4a                	add	s8,s8,s2
    8000189a:	168b3783          	ld	a5,360(s6)
    8000189e:	40fc0c33          	sub	s8,s8,a5
      ilock(vma->file->ip);
    800018a2:	188b3783          	ld	a5,392(s6)
    800018a6:	6f88                	ld	a0,24(a5)
    800018a8:	2bc020ef          	jal	80003b64 <ilock>
      n = readi(vma->file->ip, 0, mem, offset, PGSIZE);
    800018ac:	188b3783          	ld	a5,392(s6)
    800018b0:	6705                	lui	a4,0x1
    800018b2:	000c069b          	sext.w	a3,s8
    800018b6:	865e                	mv	a2,s7
    800018b8:	4581                	li	a1,0
    800018ba:	6f88                	ld	a0,24(a5)
    800018bc:	682020ef          	jal	80003f3e <readi>
    800018c0:	8c2a                	mv	s8,a0
      iunlock(vma->file->ip);
    800018c2:	188b3783          	ld	a5,392(s6)
    800018c6:	6f88                	ld	a0,24(a5)
    800018c8:	34a020ef          	jal	80003c12 <iunlock>
      if(n < 0){
    800018cc:	f40c42e3          	bltz	s8,80001810 <mmapfault+0x50>
      if(vma->prot & PROT_READ)
    800018d0:	00349793          	slli	a5,s1,0x3
    800018d4:	8f85                	sub	a5,a5,s1
    800018d6:	078e                	slli	a5,a5,0x3
    800018d8:	99be                	add	s3,s3,a5
    800018da:	1809a783          	lw	a5,384(s3) # 1180 <_entry-0x7fffee80>
    800018de:	0017f693          	andi	a3,a5,1
        perm |= PTE_R;
    800018e2:	4749                	li	a4,18
      if(vma->prot & PROT_READ)
    800018e4:	e291                	bnez	a3,800018e8 <mmapfault+0x128>
      perm = PTE_U;
    800018e6:	4741                	li	a4,16
      if(vma->prot & PROT_WRITE)
    800018e8:	8b89                	andi	a5,a5,2
    800018ea:	c399                	beqz	a5,800018f0 <mmapfault+0x130>
        perm |= PTE_W;
    800018ec:	00476713          	ori	a4,a4,4
      if(mappages(pagetable, va, PGSIZE, mem, perm) != 0){
    800018f0:	86de                	mv	a3,s7
    800018f2:	6605                	lui	a2,0x1
    800018f4:	85ca                	mv	a1,s2
    800018f6:	8552                	mv	a0,s4
    800018f8:	fecff0ef          	jal	800010e4 <mappages>
    800018fc:	f115                	bnez	a0,80001820 <mmapfault+0x60>
    800018fe:	6b42                	ld	s6,16(sp)
    80001900:	6ba2                	ld	s7,8(sp)
    80001902:	6c02                	ld	s8,0(sp)
    80001904:	a011                	j	80001908 <mmapfault+0x148>

      return mem;
    }
  }

  return 0;
    80001906:	4a81                	li	s5,0
}
    80001908:	8556                	mv	a0,s5
    8000190a:	60a6                	ld	ra,72(sp)
    8000190c:	6406                	ld	s0,64(sp)
    8000190e:	74e2                	ld	s1,56(sp)
    80001910:	7942                	ld	s2,48(sp)
    80001912:	79a2                	ld	s3,40(sp)
    80001914:	7a02                	ld	s4,32(sp)
    80001916:	6ae2                	ld	s5,24(sp)
    80001918:	6161                	addi	sp,sp,80
    8000191a:	8082                	ret
    8000191c:	6ba2                	ld	s7,8(sp)
    8000191e:	b7ed                	j	80001908 <mmapfault+0x148>

0000000080001920 <copyout>:
  while (len > 0) {
    80001920:	cb69                	beqz	a4,800019f2 <copyout+0xd2>
{
    80001922:	7159                	addi	sp,sp,-112
    80001924:	f486                	sd	ra,104(sp)
    80001926:	f0a2                	sd	s0,96(sp)
    80001928:	eca6                	sd	s1,88(sp)
    8000192a:	e8ca                	sd	s2,80(sp)
    8000192c:	e4ce                	sd	s3,72(sp)
    8000192e:	e0d2                	sd	s4,64(sp)
    80001930:	fc56                	sd	s5,56(sp)
    80001932:	f85a                	sd	s6,48(sp)
    80001934:	f45e                	sd	s7,40(sp)
    80001936:	f062                	sd	s8,32(sp)
    80001938:	ec66                	sd	s9,24(sp)
    8000193a:	e86a                	sd	s10,16(sp)
    8000193c:	e46e                	sd	s11,8(sp)
    8000193e:	1880                	addi	s0,sp,112
    80001940:	8b2a                	mv	s6,a0
    80001942:	8dae                	mv	s11,a1
    80001944:	8a32                	mv	s4,a2
    80001946:	8bb6                	mv	s7,a3
    80001948:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    8000194a:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    8000194c:	5cfd                	li	s9,-1
    8000194e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001952:	6c05                	lui	s8,0x1
    80001954:	a0b1                	j	800019a0 <copyout+0x80>
    pte = walk(pagetable, va0, 0);
    80001956:	4601                	li	a2,0
    80001958:	85ca                	mv	a1,s2
    8000195a:	855a                	mv	a0,s6
    8000195c:	eb0ff0ef          	jal	8000100c <walk>
    if (pte == 0 || (*pte & PTE_V) == 0)
    80001960:	c95d                	beqz	a0,80001a16 <copyout+0xf6>
    80001962:	611c                	ld	a5,0(a0)
    80001964:	0017f713          	andi	a4,a5,1
    80001968:	cb4d                	beqz	a4,80001a1a <copyout+0xfa>
    if (*pte & PTE_COW) {
    8000196a:	1007f793          	andi	a5,a5,256
    8000196e:	e7a5                	bnez	a5,800019d6 <copyout+0xb6>
    if ((*pte & PTE_W) == 0)
    80001970:	611c                	ld	a5,0(a0)
    80001972:	8b91                	andi	a5,a5,4
    80001974:	c7dd                	beqz	a5,80001a22 <copyout+0x102>
    n = PGSIZE - (dstva - va0);
    80001976:	414909b3          	sub	s3,s2,s4
    8000197a:	99e2                	add	s3,s3,s8
    if (n > len)
    8000197c:	013af363          	bgeu	s5,s3,80001982 <copyout+0x62>
    80001980:	89d6                	mv	s3,s5
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001982:	412a0533          	sub	a0,s4,s2
    80001986:	0009861b          	sext.w	a2,s3
    8000198a:	85de                	mv	a1,s7
    8000198c:	9526                	add	a0,a0,s1
    8000198e:	c4cff0ef          	jal	80000dda <memmove>
    len -= n;
    80001992:	413a8ab3          	sub	s5,s5,s3
    src += n;
    80001996:	9bce                	add	s7,s7,s3
    dstva = va0 + PGSIZE;
    80001998:	01890a33          	add	s4,s2,s8
  while (len > 0) {
    8000199c:	040a8963          	beqz	s5,800019ee <copyout+0xce>
    va0 = PGROUNDDOWN(dstva);
    800019a0:	01aa7933          	and	s2,s4,s10
    if (va0 >= MAXVA)
    800019a4:	052ce963          	bltu	s9,s2,800019f6 <copyout+0xd6>
    pa0 = walkaddr(pagetable, va0);
    800019a8:	85ca                	mv	a1,s2
    800019aa:	855a                	mv	a0,s6
    800019ac:	efaff0ef          	jal	800010a6 <walkaddr>
    800019b0:	84aa                	mv	s1,a0
    if (pa0 == 0) {
    800019b2:	f155                	bnez	a0,80001956 <copyout+0x36>
    pa0 = vmfault(pagetable, psz, va0, 0);
    800019b4:	4681                	li	a3,0
    800019b6:	864a                	mv	a2,s2
    800019b8:	85ee                	mv	a1,s11
    800019ba:	855a                	mv	a0,s6
    800019bc:	bfdff0ef          	jal	800015b8 <vmfault>
    800019c0:	84aa                	mv	s1,a0
    if(pa0 == 0)
    800019c2:	f951                	bnez	a0,80001956 <copyout+0x36>
    pa0 = mmapfault(pagetable, va0, 0);
    800019c4:	4601                	li	a2,0
    800019c6:	85ca                	mv	a1,s2
    800019c8:	855a                	mv	a0,s6
    800019ca:	df7ff0ef          	jal	800017c0 <mmapfault>
    800019ce:	84aa                	mv	s1,a0
    if(pa0 == 0)
    800019d0:	f159                	bnez	a0,80001956 <copyout+0x36>
    return -1;
    800019d2:	557d                	li	a0,-1
    800019d4:	a015                	j	800019f8 <copyout+0xd8>
      pa0 = cowalloc(pagetable, va0);
    800019d6:	85ca                	mv	a1,s2
    800019d8:	855a                	mv	a0,s6
    800019da:	d15ff0ef          	jal	800016ee <cowalloc>
    800019de:	84aa                	mv	s1,a0
      if (pa0 == 0)
    800019e0:	cd1d                	beqz	a0,80001a1e <copyout+0xfe>
      pte = walk(pagetable, va0, 0);
    800019e2:	4601                	li	a2,0
    800019e4:	85ca                	mv	a1,s2
    800019e6:	855a                	mv	a0,s6
    800019e8:	e24ff0ef          	jal	8000100c <walk>
    800019ec:	b751                	j	80001970 <copyout+0x50>
  return 0;
    800019ee:	4501                	li	a0,0
    800019f0:	a021                	j	800019f8 <copyout+0xd8>
    800019f2:	4501                	li	a0,0
}
    800019f4:	8082                	ret
      return -1;
    800019f6:	557d                	li	a0,-1
}
    800019f8:	70a6                	ld	ra,104(sp)
    800019fa:	7406                	ld	s0,96(sp)
    800019fc:	64e6                	ld	s1,88(sp)
    800019fe:	6946                	ld	s2,80(sp)
    80001a00:	69a6                	ld	s3,72(sp)
    80001a02:	6a06                	ld	s4,64(sp)
    80001a04:	7ae2                	ld	s5,56(sp)
    80001a06:	7b42                	ld	s6,48(sp)
    80001a08:	7ba2                	ld	s7,40(sp)
    80001a0a:	7c02                	ld	s8,32(sp)
    80001a0c:	6ce2                	ld	s9,24(sp)
    80001a0e:	6d42                	ld	s10,16(sp)
    80001a10:	6da2                	ld	s11,8(sp)
    80001a12:	6165                	addi	sp,sp,112
    80001a14:	8082                	ret
      return -1;
    80001a16:	557d                	li	a0,-1
    80001a18:	b7c5                	j	800019f8 <copyout+0xd8>
    80001a1a:	557d                	li	a0,-1
    80001a1c:	bff1                	j	800019f8 <copyout+0xd8>
        return -1;
    80001a1e:	557d                	li	a0,-1
    80001a20:	bfe1                	j	800019f8 <copyout+0xd8>
      return -1;
    80001a22:	557d                	li	a0,-1
    80001a24:	bfd1                	j	800019f8 <copyout+0xd8>

0000000080001a26 <copyin>:
  while (len > 0) {
    80001a26:	c355                	beqz	a4,80001aca <copyin+0xa4>
{
    80001a28:	711d                	addi	sp,sp,-96
    80001a2a:	ec86                	sd	ra,88(sp)
    80001a2c:	e8a2                	sd	s0,80(sp)
    80001a2e:	e4a6                	sd	s1,72(sp)
    80001a30:	e0ca                	sd	s2,64(sp)
    80001a32:	fc4e                	sd	s3,56(sp)
    80001a34:	f852                	sd	s4,48(sp)
    80001a36:	f456                	sd	s5,40(sp)
    80001a38:	f05a                	sd	s6,32(sp)
    80001a3a:	ec5e                	sd	s7,24(sp)
    80001a3c:	e862                	sd	s8,16(sp)
    80001a3e:	e466                	sd	s9,8(sp)
    80001a40:	e06a                	sd	s10,0(sp)
    80001a42:	1080                	addi	s0,sp,96
    80001a44:	8b2a                	mv	s6,a0
    80001a46:	8cae                	mv	s9,a1
    80001a48:	8a32                	mv	s4,a2
    80001a4a:	84b6                	mv	s1,a3
    80001a4c:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001a4e:	7bfd                	lui	s7,0xfffff
  pa0 = vmfault(pagetable, psz, va0, 1);
    80001a50:	4c05                	li	s8,1
    n = PGSIZE - (srcva - va0);
    80001a52:	6a85                	lui	s5,0x1
    80001a54:	a035                	j	80001a80 <copyin+0x5a>
    80001a56:	40990d33          	sub	s10,s2,s1
    80001a5a:	9d56                	add	s10,s10,s5
    if (n > len)
    80001a5c:	01a9f363          	bgeu	s3,s10,80001a62 <copyin+0x3c>
    80001a60:	8d4e                	mv	s10,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001a62:	412485b3          	sub	a1,s1,s2
    80001a66:	000d061b          	sext.w	a2,s10
    80001a6a:	95aa                	add	a1,a1,a0
    80001a6c:	8552                	mv	a0,s4
    80001a6e:	b6cff0ef          	jal	80000dda <memmove>
    len -= n;
    80001a72:	41a989b3          	sub	s3,s3,s10
    dst += n;
    80001a76:	9a6a                	add	s4,s4,s10
    srcva = va0 + PGSIZE;
    80001a78:	015904b3          	add	s1,s2,s5
  while (len > 0) {
    80001a7c:	02098863          	beqz	s3,80001aac <copyin+0x86>
    va0 = PGROUNDDOWN(srcva);
    80001a80:	0174f933          	and	s2,s1,s7
    pa0 = walkaddr(pagetable, va0);
    80001a84:	85ca                	mv	a1,s2
    80001a86:	855a                	mv	a0,s6
    80001a88:	e1eff0ef          	jal	800010a6 <walkaddr>
    if (pa0 == 0) {
    80001a8c:	f569                	bnez	a0,80001a56 <copyin+0x30>
  pa0 = vmfault(pagetable, psz, va0, 1);
    80001a8e:	86e2                	mv	a3,s8
    80001a90:	864a                	mv	a2,s2
    80001a92:	85e6                	mv	a1,s9
    80001a94:	855a                	mv	a0,s6
    80001a96:	b23ff0ef          	jal	800015b8 <vmfault>
  if(pa0 == 0)
    80001a9a:	fd55                	bnez	a0,80001a56 <copyin+0x30>
    pa0 = mmapfault(pagetable, va0, 1);
    80001a9c:	8662                	mv	a2,s8
    80001a9e:	85ca                	mv	a1,s2
    80001aa0:	855a                	mv	a0,s6
    80001aa2:	d1fff0ef          	jal	800017c0 <mmapfault>
  if(pa0 == 0)
    80001aa6:	f945                	bnez	a0,80001a56 <copyin+0x30>
    return -1;
    80001aa8:	557d                	li	a0,-1
    80001aaa:	a011                	j	80001aae <copyin+0x88>
  return 0;
    80001aac:	4501                	li	a0,0
}
    80001aae:	60e6                	ld	ra,88(sp)
    80001ab0:	6446                	ld	s0,80(sp)
    80001ab2:	64a6                	ld	s1,72(sp)
    80001ab4:	6906                	ld	s2,64(sp)
    80001ab6:	79e2                	ld	s3,56(sp)
    80001ab8:	7a42                	ld	s4,48(sp)
    80001aba:	7aa2                	ld	s5,40(sp)
    80001abc:	7b02                	ld	s6,32(sp)
    80001abe:	6be2                	ld	s7,24(sp)
    80001ac0:	6c42                	ld	s8,16(sp)
    80001ac2:	6ca2                	ld	s9,8(sp)
    80001ac4:	6d02                	ld	s10,0(sp)
    80001ac6:	6125                	addi	sp,sp,96
    80001ac8:	8082                	ret
  return 0;
    80001aca:	4501                	li	a0,0
}
    80001acc:	8082                	ret

0000000080001ace <mmap_unmap>:



int
mmap_unmap(struct proc *p, uint64 addr, uint64 length)
{
    80001ace:	7175                	addi	sp,sp,-144
    80001ad0:	e506                	sd	ra,136(sp)
    80001ad2:	e122                	sd	s0,128(sp)
    80001ad4:	ecd6                	sd	s5,88(sp)
    80001ad6:	e8da                	sd	s6,80(sp)
    80001ad8:	fc66                	sd	s9,56(sp)
    80001ada:	0900                	addi	s0,sp,144
    80001adc:	8b2a                	mv	s6,a0
    80001ade:	8aae                	mv	s5,a1
  uint64 end;
  uint64 a;
  uint64 pa;
  pte_t *pte;

  length = PGROUNDUP(length);
    80001ae0:	6785                	lui	a5,0x1
    80001ae2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001ae4:	963e                	add	a2,a2,a5
    80001ae6:	77fd                	lui	a5,0xfffff
    80001ae8:	00f67cb3          	and	s9,a2,a5

  for(int i = 0; i < NVMA; i++){
    80001aec:	16050793          	addi	a5,a0,352
    80001af0:	4701                	li	a4,0
    80001af2:	4641                	li	a2,16
    80001af4:	a031                	j	80001b00 <mmap_unmap+0x32>
    80001af6:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80001af8:	03878793          	addi	a5,a5,56 # fffffffffffff038 <end+0xffffffff7fdaf240>
    80001afc:	04c70e63          	beq	a4,a2,80001b58 <mmap_unmap+0x8a>
    if(p->vmas[i].used &&
    80001b00:	4394                	lw	a3,0(a5)
    80001b02:	daf5                	beqz	a3,80001af6 <mmap_unmap+0x28>
       addr >= p->vmas[i].addr &&
    80001b04:	6794                	ld	a3,8(a5)
    if(p->vmas[i].used &&
    80001b06:	fedae8e3          	bltu	s5,a3,80001af6 <mmap_unmap+0x28>
       addr < p->vmas[i].addr + p->vmas[i].maplen){
    80001b0a:	6f8c                	ld	a1,24(a5)
    80001b0c:	96ae                	add	a3,a3,a1
       addr >= p->vmas[i].addr &&
    80001b0e:	fedaf4e3          	bgeu	s5,a3,80001af6 <mmap_unmap+0x28>
    80001b12:	f0d2                	sd	s4,96(sp)
      vma = &p->vmas[i];
    80001b14:	00371a13          	slli	s4,a4,0x3
    80001b18:	40ea0a33          	sub	s4,s4,a4
    80001b1c:	0a0e                	slli	s4,s4,0x3
    80001b1e:	160a0a13          	addi	s4,s4,352 # 1160 <_entry-0x7fffeea0>
    80001b22:	9a5a                	add	s4,s4,s6
      break;
    }
  }

  if(vma == 0)
    80001b24:	160a0f63          	beqz	s4,80001ca2 <mmap_unmap+0x1d4>
    80001b28:	f4ce                	sd	s3,104(sp)
    80001b2a:	e4de                	sd	s7,72(sp)
    return -1;

  end = addr + length;
    80001b2c:	015c8bb3          	add	s7,s9,s5

  if(addr != vma->addr &&
    80001b30:	008a3783          	ld	a5,8(s4)
    80001b34:	19578463          	beq	a5,s5,80001cbc <mmap_unmap+0x1ee>
     end != vma->addr + vma->maplen)
    80001b38:	018a3703          	ld	a4,24(s4)
    80001b3c:	97ba                	add	a5,a5,a4
  if(addr != vma->addr &&
    80001b3e:	17779563          	bne	a5,s7,80001ca8 <mmap_unmap+0x1da>
    return -1;

  for(a = addr; a < end; a += PGSIZE){
    80001b42:	197af663          	bgeu	s5,s7,80001cce <mmap_unmap+0x200>
    80001b46:	fca6                	sd	s1,120(sp)
    80001b48:	f8ca                	sd	s2,112(sp)
    80001b4a:	e0e2                	sd	s8,64(sp)
    80001b4c:	f86a                	sd	s10,48(sp)
    80001b4e:	f46e                	sd	s11,40(sp)
    80001b50:	89d6                	mv	s3,s5
    if(pte == 0 || (*pte & PTE_V) == 0)
      continue;

    pa = PTE2PA(*pte);

    if(vma->flags == MAP_SHARED){
    80001b52:	4d05                	li	s10,1
  for(a = addr; a < end; a += PGSIZE){
    80001b54:	6c05                	lui	s8,0x1
    80001b56:	a0a9                	j	80001ba0 <mmap_unmap+0xd2>
    return -1;
    80001b58:	557d                	li	a0,-1
    vma->maplen -= length;
    return 0;
  }

  return -1;
}
    80001b5a:	60aa                	ld	ra,136(sp)
    80001b5c:	640a                	ld	s0,128(sp)
    80001b5e:	6ae6                	ld	s5,88(sp)
    80001b60:	6b46                	ld	s6,80(sp)
    80001b62:	7ce2                	ld	s9,56(sp)
    80001b64:	6149                	addi	sp,sp,144
    80001b66:	8082                	ret
        writei(vma->file->ip, 0, pa, fileoff, remaining);
    80001b68:	028a3783          	ld	a5,40(s4)
    80001b6c:	2701                	sext.w	a4,a4
    80001b6e:	f7843683          	ld	a3,-136(s0)
    80001b72:	f8043603          	ld	a2,-128(s0)
    80001b76:	9eb1                	addw	a3,a3,a2
    80001b78:	864a                	mv	a2,s2
    80001b7a:	4581                	li	a1,0
    80001b7c:	6f88                	ld	a0,24(a5)
    80001b7e:	4b2020ef          	jal	80004030 <writei>
        iunlock(vma->file->ip);
    80001b82:	028a3783          	ld	a5,40(s4)
    80001b86:	6f88                	ld	a0,24(a5)
    80001b88:	08a020ef          	jal	80003c12 <iunlock>
        end_op();
    80001b8c:	2c1020ef          	jal	8000464c <end_op>
    kfree((void *)pa);
    80001b90:	854a                	mv	a0,s2
    80001b92:	e4ffe0ef          	jal	800009e0 <kfree>
    *pte = 0;
    80001b96:	0004b023          	sd	zero,0(s1)
  for(a = addr; a < end; a += PGSIZE){
    80001b9a:	99e2                	add	s3,s3,s8
    80001b9c:	0779f863          	bgeu	s3,s7,80001c0c <mmap_unmap+0x13e>
    pte = walk(p->pagetable, a, 0);
    80001ba0:	4601                	li	a2,0
    80001ba2:	85ce                	mv	a1,s3
    80001ba4:	058b3503          	ld	a0,88(s6)
    80001ba8:	c64ff0ef          	jal	8000100c <walk>
    80001bac:	84aa                	mv	s1,a0
    if(pte == 0 || (*pte & PTE_V) == 0)
    80001bae:	d575                	beqz	a0,80001b9a <mmap_unmap+0xcc>
    80001bb0:	00053903          	ld	s2,0(a0)
    80001bb4:	00197793          	andi	a5,s2,1
    80001bb8:	d3ed                	beqz	a5,80001b9a <mmap_unmap+0xcc>
    pa = PTE2PA(*pte);
    80001bba:	00a95913          	srli	s2,s2,0xa
    80001bbe:	0932                	slli	s2,s2,0xc
    if(vma->flags == MAP_SHARED){
    80001bc0:	024a2783          	lw	a5,36(s4)
    80001bc4:	fda796e3          	bne	a5,s10,80001b90 <mmap_unmap+0xc2>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001bc8:	008a3783          	ld	a5,8(s4)
    80001bcc:	f8f43423          	sd	a5,-120(s0)
    80001bd0:	40f987b3          	sub	a5,s3,a5
    80001bd4:	f8f43023          	sd	a5,-128(s0)
      if(a - vma->addr < vma->length){
    80001bd8:	010a3d83          	ld	s11,16(s4)
    80001bdc:	fbb7fae3          	bgeu	a5,s11,80001b90 <mmap_unmap+0xc2>
      uint64 fileoff = vma->offset + (a - vma->addr);
    80001be0:	030a3783          	ld	a5,48(s4)
    80001be4:	f6f43c23          	sd	a5,-136(s0)
        begin_op();
    80001be8:	1df020ef          	jal	800045c6 <begin_op>
        ilock(vma->file->ip);
    80001bec:	028a3783          	ld	a5,40(s4)
    80001bf0:	6f88                	ld	a0,24(a5)
    80001bf2:	773010ef          	jal	80003b64 <ilock>
        remaining = vma->length - (a - vma->addr);
    80001bf6:	f8843783          	ld	a5,-120(s0)
    80001bfa:	01b78733          	add	a4,a5,s11
    80001bfe:	41370733          	sub	a4,a4,s3
        if(remaining > PGSIZE)
    80001c02:	6785                	lui	a5,0x1
    80001c04:	f6e7f2e3          	bgeu	a5,a4,80001b68 <mmap_unmap+0x9a>
    80001c08:	873e                	mv	a4,a5
    80001c0a:	bfb9                	j	80001b68 <mmap_unmap+0x9a>
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001c0c:	008a3783          	ld	a5,8(s4)
    80001c10:	03578b63          	beq	a5,s5,80001c46 <mmap_unmap+0x178>
    80001c14:	74e6                	ld	s1,120(sp)
    80001c16:	7946                	ld	s2,112(sp)
    80001c18:	6c06                	ld	s8,64(sp)
    80001c1a:	7d42                	ld	s10,48(sp)
    80001c1c:	7da2                	ld	s11,40(sp)
  if(end == vma->addr + vma->maplen){
    80001c1e:	018a3703          	ld	a4,24(s4)
    80001c22:	97ba                	add	a5,a5,a4
    80001c24:	09779763          	bne	a5,s7,80001cb2 <mmap_unmap+0x1e4>
    vma->length -= length;
    80001c28:	010a3783          	ld	a5,16(s4)
    80001c2c:	419787b3          	sub	a5,a5,s9
    80001c30:	00fa3823          	sd	a5,16(s4)
    vma->maplen -= length;
    80001c34:	41970733          	sub	a4,a4,s9
    80001c38:	00ea3c23          	sd	a4,24(s4)
    return 0;
    80001c3c:	4501                	li	a0,0
    80001c3e:	79a6                	ld	s3,104(sp)
    80001c40:	7a06                	ld	s4,96(sp)
    80001c42:	6ba6                	ld	s7,72(sp)
    80001c44:	bf19                	j	80001b5a <mmap_unmap+0x8c>
    80001c46:	74e6                	ld	s1,120(sp)
    80001c48:	7946                	ld	s2,112(sp)
    80001c4a:	6c06                	ld	s8,64(sp)
    80001c4c:	7d42                	ld	s10,48(sp)
    80001c4e:	7da2                	ld	s11,40(sp)
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001c50:	018a3783          	ld	a5,24(s4)
    80001c54:	03978863          	beq	a5,s9,80001c84 <mmap_unmap+0x1b6>
    vma->addr = end;
    80001c58:	017a3423          	sd	s7,8(s4)
    vma->offset += length;
    80001c5c:	030a3703          	ld	a4,48(s4)
    80001c60:	9766                	add	a4,a4,s9
    80001c62:	02ea3823          	sd	a4,48(s4)
    vma->length -= length;
    80001c66:	010a3703          	ld	a4,16(s4)
    80001c6a:	41970733          	sub	a4,a4,s9
    80001c6e:	00ea3823          	sd	a4,16(s4)
    vma->maplen -= length;
    80001c72:	419787b3          	sub	a5,a5,s9
    80001c76:	00fa3c23          	sd	a5,24(s4)
    return 0;
    80001c7a:	4501                	li	a0,0
    80001c7c:	79a6                	ld	s3,104(sp)
    80001c7e:	7a06                	ld	s4,96(sp)
    80001c80:	6ba6                	ld	s7,72(sp)
    80001c82:	bde1                	j	80001b5a <mmap_unmap+0x8c>
    fileclose(vma->file);
    80001c84:	028a3503          	ld	a0,40(s4)
    80001c88:	5f1020ef          	jal	80004a78 <fileclose>
    memset(vma, 0, sizeof(*vma));
    80001c8c:	03800613          	li	a2,56
    80001c90:	4581                	li	a1,0
    80001c92:	8552                	mv	a0,s4
    80001c94:	8e2ff0ef          	jal	80000d76 <memset>
    return 0;
    80001c98:	4501                	li	a0,0
    80001c9a:	79a6                	ld	s3,104(sp)
    80001c9c:	7a06                	ld	s4,96(sp)
    80001c9e:	6ba6                	ld	s7,72(sp)
    80001ca0:	bd6d                	j	80001b5a <mmap_unmap+0x8c>
    return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	7a06                	ld	s4,96(sp)
    80001ca6:	bd55                	j	80001b5a <mmap_unmap+0x8c>
    return -1;
    80001ca8:	557d                	li	a0,-1
    80001caa:	79a6                	ld	s3,104(sp)
    80001cac:	7a06                	ld	s4,96(sp)
    80001cae:	6ba6                	ld	s7,72(sp)
    80001cb0:	b56d                	j	80001b5a <mmap_unmap+0x8c>
  return -1;
    80001cb2:	557d                	li	a0,-1
    80001cb4:	79a6                	ld	s3,104(sp)
    80001cb6:	7a06                	ld	s4,96(sp)
    80001cb8:	6ba6                	ld	s7,72(sp)
    80001cba:	b545                	j	80001b5a <mmap_unmap+0x8c>
  for(a = addr; a < end; a += PGSIZE){
    80001cbc:	89d6                	mv	s3,s5
    80001cbe:	f97af9e3          	bgeu	s5,s7,80001c50 <mmap_unmap+0x182>
    80001cc2:	fca6                	sd	s1,120(sp)
    80001cc4:	f8ca                	sd	s2,112(sp)
    80001cc6:	e0e2                	sd	s8,64(sp)
    80001cc8:	f86a                	sd	s10,48(sp)
    80001cca:	f46e                	sd	s11,40(sp)
    80001ccc:	b559                	j	80001b52 <mmap_unmap+0x84>
  if(addr == vma->addr && end == vma->addr + vma->maplen){
    80001cce:	008a3783          	ld	a5,8(s4)
    80001cd2:	b7b1                	j	80001c1e <mmap_unmap+0x150>

0000000080001cd4 <mmap_cleanup>:

void
mmap_cleanup(struct proc *p)
{
    80001cd4:	7179                	addi	sp,sp,-48
    80001cd6:	f406                	sd	ra,40(sp)
    80001cd8:	f022                	sd	s0,32(sp)
    80001cda:	ec26                	sd	s1,24(sp)
    80001cdc:	e84a                	sd	s2,16(sp)
    80001cde:	e44e                	sd	s3,8(sp)
    80001ce0:	1800                	addi	s0,sp,48
    80001ce2:	89aa                	mv	s3,a0
  for(int i = 0; i < NVMA; i++){
    80001ce4:	16050493          	addi	s1,a0,352
    80001ce8:	4e050913          	addi	s2,a0,1248
    80001cec:	a029                	j	80001cf6 <mmap_cleanup+0x22>
    80001cee:	03848493          	addi	s1,s1,56
    80001cf2:	01248a63          	beq	s1,s2,80001d06 <mmap_cleanup+0x32>
    if(p->vmas[i].used)
    80001cf6:	409c                	lw	a5,0(s1)
    80001cf8:	dbfd                	beqz	a5,80001cee <mmap_cleanup+0x1a>
      mmap_unmap(p, p->vmas[i].addr, p->vmas[i].maplen);
    80001cfa:	6c90                	ld	a2,24(s1)
    80001cfc:	648c                	ld	a1,8(s1)
    80001cfe:	854e                	mv	a0,s3
    80001d00:	dcfff0ef          	jal	80001ace <mmap_unmap>
    80001d04:	b7ed                	j	80001cee <mmap_cleanup+0x1a>
  }
    80001d06:	70a2                	ld	ra,40(sp)
    80001d08:	7402                	ld	s0,32(sp)
    80001d0a:	64e2                	ld	s1,24(sp)
    80001d0c:	6942                	ld	s2,16(sp)
    80001d0e:	69a2                	ld	s3,8(sp)
    80001d10:	6145                	addi	sp,sp,48
    80001d12:	8082                	ret

0000000080001d14 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001d14:	715d                	addi	sp,sp,-80
    80001d16:	e486                	sd	ra,72(sp)
    80001d18:	e0a2                	sd	s0,64(sp)
    80001d1a:	fc26                	sd	s1,56(sp)
    80001d1c:	f84a                	sd	s2,48(sp)
    80001d1e:	f44e                	sd	s3,40(sp)
    80001d20:	f052                	sd	s4,32(sp)
    80001d22:	ec56                	sd	s5,24(sp)
    80001d24:	e85a                	sd	s6,16(sp)
    80001d26:	e45e                	sd	s7,8(sp)
    80001d28:	e062                	sd	s8,0(sp)
    80001d2a:	0880                	addi	s0,sp,80
    80001d2c:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001d2e:	0022f497          	auipc	s1,0x22f
    80001d32:	0ea48493          	addi	s1,s1,234 # 80230e18 <proc>
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001d36:	8c26                	mv	s8,s1
    80001d38:	613717b7          	lui	a5,0x61371
    80001d3c:	6af78793          	addi	a5,a5,1711 # 613716af <_entry-0x1ec8e951>
    80001d40:	9b8b5937          	lui	s2,0x9b8b5
    80001d44:	77e90913          	addi	s2,s2,1918 # ffffffff9b8b577e <end+0xffffffff1b665986>
    80001d48:	1902                	slli	s2,s2,0x20
    80001d4a:	993e                	add	s2,s2,a5
    80001d4c:	040009b7          	lui	s3,0x4000
    80001d50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001d52:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d54:	4b99                	li	s7,6
    80001d56:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d58:	00243a97          	auipc	s5,0x243
    80001d5c:	cc0a8a93          	addi	s5,s5,-832 # 80244a18 <tickslock>
    char *pa = kalloc();
    80001d60:	dd5fe0ef          	jal	80000b34 <kalloc>
    80001d64:	862a                	mv	a2,a0
    if (pa == 0)
    80001d66:	c121                	beqz	a0,80001da6 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    80001d68:	418485b3          	sub	a1,s1,s8
    80001d6c:	8591                	srai	a1,a1,0x4
    80001d6e:	032585b3          	mul	a1,a1,s2
    80001d72:	2585                	addiw	a1,a1,1
    80001d74:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d78:	875e                	mv	a4,s7
    80001d7a:	86da                	mv	a3,s6
    80001d7c:	40b985b3          	sub	a1,s3,a1
    80001d80:	8552                	mv	a0,s4
    80001d82:	c18ff0ef          	jal	8000119a <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d86:	4f048493          	addi	s1,s1,1264
    80001d8a:	fd549be3          	bne	s1,s5,80001d60 <proc_mapstacks+0x4c>
  }
}
    80001d8e:	60a6                	ld	ra,72(sp)
    80001d90:	6406                	ld	s0,64(sp)
    80001d92:	74e2                	ld	s1,56(sp)
    80001d94:	7942                	ld	s2,48(sp)
    80001d96:	79a2                	ld	s3,40(sp)
    80001d98:	7a02                	ld	s4,32(sp)
    80001d9a:	6ae2                	ld	s5,24(sp)
    80001d9c:	6b42                	ld	s6,16(sp)
    80001d9e:	6ba2                	ld	s7,8(sp)
    80001da0:	6c02                	ld	s8,0(sp)
    80001da2:	6161                	addi	sp,sp,80
    80001da4:	8082                	ret
      panic("kalloc");
    80001da6:	00006517          	auipc	a0,0x6
    80001daa:	3ca50513          	addi	a0,a0,970 # 80008170 <etext+0x170>
    80001dae:	a41fe0ef          	jal	800007ee <panic>

0000000080001db2 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001db2:	7139                	addi	sp,sp,-64
    80001db4:	fc06                	sd	ra,56(sp)
    80001db6:	f822                	sd	s0,48(sp)
    80001db8:	f426                	sd	s1,40(sp)
    80001dba:	f04a                	sd	s2,32(sp)
    80001dbc:	ec4e                	sd	s3,24(sp)
    80001dbe:	e852                	sd	s4,16(sp)
    80001dc0:	e456                	sd	s5,8(sp)
    80001dc2:	e05a                	sd	s6,0(sp)
    80001dc4:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001dc6:	00006597          	auipc	a1,0x6
    80001dca:	3b258593          	addi	a1,a1,946 # 80008178 <etext+0x178>
    80001dce:	0022f517          	auipc	a0,0x22f
    80001dd2:	c1a50513          	addi	a0,a0,-998 # 802309e8 <pid_lock>
    80001dd6:	e67fe0ef          	jal	80000c3c <initlock>
  initlock(&wait_lock, "wait_lock");
    80001dda:	00006597          	auipc	a1,0x6
    80001dde:	3a658593          	addi	a1,a1,934 # 80008180 <etext+0x180>
    80001de2:	0022f517          	auipc	a0,0x22f
    80001de6:	c1e50513          	addi	a0,a0,-994 # 80230a00 <wait_lock>
    80001dea:	e53fe0ef          	jal	80000c3c <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001dee:	0022f497          	auipc	s1,0x22f
    80001df2:	02a48493          	addi	s1,s1,42 # 80230e18 <proc>
    initlock(&p->lock, "proc");
    80001df6:	00006b17          	auipc	s6,0x6
    80001dfa:	39ab0b13          	addi	s6,s6,922 # 80008190 <etext+0x190>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001dfe:	8aa6                	mv	s5,s1
    80001e00:	613717b7          	lui	a5,0x61371
    80001e04:	6af78793          	addi	a5,a5,1711 # 613716af <_entry-0x1ec8e951>
    80001e08:	9b8b5937          	lui	s2,0x9b8b5
    80001e0c:	77e90913          	addi	s2,s2,1918 # ffffffff9b8b577e <end+0xffffffff1b665986>
    80001e10:	1902                	slli	s2,s2,0x20
    80001e12:	993e                	add	s2,s2,a5
    80001e14:	040009b7          	lui	s3,0x4000
    80001e18:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001e1a:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e1c:	00243a17          	auipc	s4,0x243
    80001e20:	bfca0a13          	addi	s4,s4,-1028 # 80244a18 <tickslock>
    initlock(&p->lock, "proc");
    80001e24:	85da                	mv	a1,s6
    80001e26:	8526                	mv	a0,s1
    80001e28:	e15fe0ef          	jal	80000c3c <initlock>
    p->state = UNUSED;
    80001e2c:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001e30:	415487b3          	sub	a5,s1,s5
    80001e34:	8791                	srai	a5,a5,0x4
    80001e36:	032787b3          	mul	a5,a5,s2
    80001e3a:	2785                	addiw	a5,a5,1
    80001e3c:	00d7979b          	slliw	a5,a5,0xd
    80001e40:	40f987b3          	sub	a5,s3,a5
    80001e44:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001e46:	4f048493          	addi	s1,s1,1264
    80001e4a:	fd449de3          	bne	s1,s4,80001e24 <procinit+0x72>
  }
}
    80001e4e:	70e2                	ld	ra,56(sp)
    80001e50:	7442                	ld	s0,48(sp)
    80001e52:	74a2                	ld	s1,40(sp)
    80001e54:	7902                	ld	s2,32(sp)
    80001e56:	69e2                	ld	s3,24(sp)
    80001e58:	6a42                	ld	s4,16(sp)
    80001e5a:	6aa2                	ld	s5,8(sp)
    80001e5c:	6b02                	ld	s6,0(sp)
    80001e5e:	6121                	addi	sp,sp,64
    80001e60:	8082                	ret

0000000080001e62 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001e62:	1141                	addi	sp,sp,-16
    80001e64:	e406                	sd	ra,8(sp)
    80001e66:	e022                	sd	s0,0(sp)
    80001e68:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    80001e6a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001e6c:	2501                	sext.w	a0,a0
    80001e6e:	60a2                	ld	ra,8(sp)
    80001e70:	6402                	ld	s0,0(sp)
    80001e72:	0141                	addi	sp,sp,16
    80001e74:	8082                	ret

0000000080001e76 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001e76:	1141                	addi	sp,sp,-16
    80001e78:	e406                	sd	ra,8(sp)
    80001e7a:	e022                	sd	s0,0(sp)
    80001e7c:	0800                	addi	s0,sp,16
    80001e7e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001e80:	2781                	sext.w	a5,a5
    80001e82:	079e                	slli	a5,a5,0x7
  return c;
}
    80001e84:	0022f517          	auipc	a0,0x22f
    80001e88:	b9450513          	addi	a0,a0,-1132 # 80230a18 <cpus>
    80001e8c:	953e                	add	a0,a0,a5
    80001e8e:	60a2                	ld	ra,8(sp)
    80001e90:	6402                	ld	s0,0(sp)
    80001e92:	0141                	addi	sp,sp,16
    80001e94:	8082                	ret

0000000080001e96 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001e96:	1101                	addi	sp,sp,-32
    80001e98:	ec06                	sd	ra,24(sp)
    80001e9a:	e822                	sd	s0,16(sp)
    80001e9c:	e426                	sd	s1,8(sp)
    80001e9e:	1000                	addi	s0,sp,32
  push_off();
    80001ea0:	de1fe0ef          	jal	80000c80 <push_off>
    80001ea4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001ea6:	2781                	sext.w	a5,a5
    80001ea8:	079e                	slli	a5,a5,0x7
    80001eaa:	0022f717          	auipc	a4,0x22f
    80001eae:	b3e70713          	addi	a4,a4,-1218 # 802309e8 <pid_lock>
    80001eb2:	97ba                	add	a5,a5,a4
    80001eb4:	7b84                	ld	s1,48(a5)
  pop_off();
    80001eb6:	e41fe0ef          	jal	80000cf6 <pop_off>
  return p;
}
    80001eba:	8526                	mv	a0,s1
    80001ebc:	60e2                	ld	ra,24(sp)
    80001ebe:	6442                	ld	s0,16(sp)
    80001ec0:	64a2                	ld	s1,8(sp)
    80001ec2:	6105                	addi	sp,sp,32
    80001ec4:	8082                	ret

0000000080001ec6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001ec6:	7179                	addi	sp,sp,-48
    80001ec8:	f406                	sd	ra,40(sp)
    80001eca:	f022                	sd	s0,32(sp)
    80001ecc:	ec26                	sd	s1,24(sp)
    80001ece:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001ed0:	fc7ff0ef          	jal	80001e96 <myproc>
    80001ed4:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001ed6:	e69fe0ef          	jal	80000d3e <release>

  if (first) {
    80001eda:	00007797          	auipc	a5,0x7
    80001ede:	9a67a783          	lw	a5,-1626(a5) # 80008880 <first.1>
    80001ee2:	cb9d                	beqz	a5,80001f18 <forkret+0x52>
    first = 0;
    80001ee4:	00007797          	auipc	a5,0x7
    80001ee8:	9807ae23          	sw	zero,-1636(a5) # 80008880 <first.1>

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001eec:	4505                	li	a0,1
    80001eee:	7b1010ef          	jal	80003e9e <fsinit>

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001ef2:	00006517          	auipc	a0,0x6
    80001ef6:	2a650513          	addi	a0,a0,678 # 80008198 <etext+0x198>
    80001efa:	fca43823          	sd	a0,-48(s0)
    80001efe:	fc043c23          	sd	zero,-40(s0)
    80001f02:	fd040593          	addi	a1,s0,-48
    80001f06:	1fa030ef          	jal	80005100 <kexec>
    80001f0a:	70bc                	ld	a5,96(s1)
    80001f0c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001f0e:	70bc                	ld	a5,96(s1)
    80001f10:	7bb8                	ld	a4,112(a5)
    80001f12:	57fd                	li	a5,-1
    80001f14:	02f70d63          	beq	a4,a5,80001f4e <forkret+0x88>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001f18:	405000ef          	jal	80002b1c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001f1c:	6ca8                	ld	a0,88(s1)
    80001f1e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001f20:	04000737          	lui	a4,0x4000
    80001f24:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001f26:	0732                	slli	a4,a4,0xc
    80001f28:	00005797          	auipc	a5,0x5
    80001f2c:	17478793          	addi	a5,a5,372 # 8000709c <userret>
    80001f30:	00005697          	auipc	a3,0x5
    80001f34:	0d068693          	addi	a3,a3,208 # 80007000 <_trampoline>
    80001f38:	8f95                	sub	a5,a5,a3
    80001f3a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001f3c:	577d                	li	a4,-1
    80001f3e:	177e                	slli	a4,a4,0x3f
    80001f40:	8d59                	or	a0,a0,a4
    80001f42:	9782                	jalr	a5
}
    80001f44:	70a2                	ld	ra,40(sp)
    80001f46:	7402                	ld	s0,32(sp)
    80001f48:	64e2                	ld	s1,24(sp)
    80001f4a:	6145                	addi	sp,sp,48
    80001f4c:	8082                	ret
      panic("exec");
    80001f4e:	00006517          	auipc	a0,0x6
    80001f52:	25250513          	addi	a0,a0,594 # 800081a0 <etext+0x1a0>
    80001f56:	899fe0ef          	jal	800007ee <panic>

0000000080001f5a <allocpid>:
{
    80001f5a:	1101                	addi	sp,sp,-32
    80001f5c:	ec06                	sd	ra,24(sp)
    80001f5e:	e822                	sd	s0,16(sp)
    80001f60:	e426                	sd	s1,8(sp)
    80001f62:	e04a                	sd	s2,0(sp)
    80001f64:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001f66:	0022f917          	auipc	s2,0x22f
    80001f6a:	a8290913          	addi	s2,s2,-1406 # 802309e8 <pid_lock>
    80001f6e:	854a                	mv	a0,s2
    80001f70:	d47fe0ef          	jal	80000cb6 <acquire>
  pid = nextpid;
    80001f74:	00007797          	auipc	a5,0x7
    80001f78:	91078793          	addi	a5,a5,-1776 # 80008884 <nextpid>
    80001f7c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001f7e:	0014871b          	addiw	a4,s1,1
    80001f82:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001f84:	854a                	mv	a0,s2
    80001f86:	db9fe0ef          	jal	80000d3e <release>
}
    80001f8a:	8526                	mv	a0,s1
    80001f8c:	60e2                	ld	ra,24(sp)
    80001f8e:	6442                	ld	s0,16(sp)
    80001f90:	64a2                	ld	s1,8(sp)
    80001f92:	6902                	ld	s2,0(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret

0000000080001f98 <proc_pagetable>:
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	e04a                	sd	s2,0(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001fa6:	ae4ff0ef          	jal	8000128a <uvmcreate>
    80001faa:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001fac:	cd05                	beqz	a0,80001fe4 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001fae:	4729                	li	a4,10
    80001fb0:	00005697          	auipc	a3,0x5
    80001fb4:	05068693          	addi	a3,a3,80 # 80007000 <_trampoline>
    80001fb8:	6605                	lui	a2,0x1
    80001fba:	040005b7          	lui	a1,0x4000
    80001fbe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001fc0:	05b2                	slli	a1,a1,0xc
    80001fc2:	922ff0ef          	jal	800010e4 <mappages>
    80001fc6:	02054663          	bltz	a0,80001ff2 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001fca:	4719                	li	a4,6
    80001fcc:	06093683          	ld	a3,96(s2)
    80001fd0:	6605                	lui	a2,0x1
    80001fd2:	020005b7          	lui	a1,0x2000
    80001fd6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001fd8:	05b6                	slli	a1,a1,0xd
    80001fda:	8526                	mv	a0,s1
    80001fdc:	908ff0ef          	jal	800010e4 <mappages>
    80001fe0:	00054f63          	bltz	a0,80001ffe <proc_pagetable+0x66>
}
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	60e2                	ld	ra,24(sp)
    80001fe8:	6442                	ld	s0,16(sp)
    80001fea:	64a2                	ld	s1,8(sp)
    80001fec:	6902                	ld	s2,0(sp)
    80001fee:	6105                	addi	sp,sp,32
    80001ff0:	8082                	ret
    uvmfree(pagetable, 0);
    80001ff2:	4581                	li	a1,0
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	c96ff0ef          	jal	8000148c <uvmfree>
    return 0;
    80001ffa:	4481                	li	s1,0
    80001ffc:	b7e5                	j	80001fe4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ffe:	4681                	li	a3,0
    80002000:	4605                	li	a2,1
    80002002:	040005b7          	lui	a1,0x4000
    80002006:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002008:	05b2                	slli	a1,a1,0xc
    8000200a:	8526                	mv	a0,s1
    8000200c:	aa4ff0ef          	jal	800012b0 <uvmunmap>
    uvmfree(pagetable, 0);
    80002010:	4581                	li	a1,0
    80002012:	8526                	mv	a0,s1
    80002014:	c78ff0ef          	jal	8000148c <uvmfree>
    return 0;
    80002018:	4481                	li	s1,0
    8000201a:	b7e9                	j	80001fe4 <proc_pagetable+0x4c>

000000008000201c <proc_freepagetable>:
{
    8000201c:	1101                	addi	sp,sp,-32
    8000201e:	ec06                	sd	ra,24(sp)
    80002020:	e822                	sd	s0,16(sp)
    80002022:	e426                	sd	s1,8(sp)
    80002024:	e04a                	sd	s2,0(sp)
    80002026:	1000                	addi	s0,sp,32
    80002028:	84aa                	mv	s1,a0
    8000202a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000202c:	4681                	li	a3,0
    8000202e:	4605                	li	a2,1
    80002030:	040005b7          	lui	a1,0x4000
    80002034:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002036:	05b2                	slli	a1,a1,0xc
    80002038:	a78ff0ef          	jal	800012b0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000203c:	4681                	li	a3,0
    8000203e:	4605                	li	a2,1
    80002040:	020005b7          	lui	a1,0x2000
    80002044:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002046:	05b6                	slli	a1,a1,0xd
    80002048:	8526                	mv	a0,s1
    8000204a:	a66ff0ef          	jal	800012b0 <uvmunmap>
  uvmfree(pagetable, sz);
    8000204e:	85ca                	mv	a1,s2
    80002050:	8526                	mv	a0,s1
    80002052:	c3aff0ef          	jal	8000148c <uvmfree>
}
    80002056:	60e2                	ld	ra,24(sp)
    80002058:	6442                	ld	s0,16(sp)
    8000205a:	64a2                	ld	s1,8(sp)
    8000205c:	6902                	ld	s2,0(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret

0000000080002062 <freeproc>:
{
    80002062:	1101                	addi	sp,sp,-32
    80002064:	ec06                	sd	ra,24(sp)
    80002066:	e822                	sd	s0,16(sp)
    80002068:	e426                	sd	s1,8(sp)
    8000206a:	1000                	addi	s0,sp,32
    8000206c:	84aa                	mv	s1,a0
  if (p->trapframe)
    8000206e:	7128                	ld	a0,96(a0)
    80002070:	c119                	beqz	a0,80002076 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80002072:	96ffe0ef          	jal	800009e0 <kfree>
  p->trapframe = 0;
    80002076:	0604b023          	sd	zero,96(s1)
  if (p->pagetable)
    8000207a:	6ca8                	ld	a0,88(s1)
    8000207c:	c501                	beqz	a0,80002084 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    8000207e:	68ac                	ld	a1,80(s1)
    80002080:	f9dff0ef          	jal	8000201c <proc_freepagetable>
  p->pagetable = 0;
    80002084:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80002088:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000208c:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80002090:	4e048023          	sb	zero,1248(s1)
  p->chan = 0;
    80002094:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002098:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000209c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800020a0:	0004ac23          	sw	zero,24(s1)
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <allocproc>:
{
    800020ae:	7179                	addi	sp,sp,-48
    800020b0:	f406                	sd	ra,40(sp)
    800020b2:	f022                	sd	s0,32(sp)
    800020b4:	ec26                	sd	s1,24(sp)
    800020b6:	e84a                	sd	s2,16(sp)
    800020b8:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    800020ba:	0022f497          	auipc	s1,0x22f
    800020be:	d5e48493          	addi	s1,s1,-674 # 80230e18 <proc>
    800020c2:	00243917          	auipc	s2,0x243
    800020c6:	95690913          	addi	s2,s2,-1706 # 80244a18 <tickslock>
    acquire(&p->lock);
    800020ca:	8526                	mv	a0,s1
    800020cc:	bebfe0ef          	jal	80000cb6 <acquire>
    if (p->state == UNUSED) {
    800020d0:	4c9c                	lw	a5,24(s1)
    800020d2:	cb91                	beqz	a5,800020e6 <allocproc+0x38>
      release(&p->lock);
    800020d4:	8526                	mv	a0,s1
    800020d6:	c69fe0ef          	jal	80000d3e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020da:	4f048493          	addi	s1,s1,1264
    800020de:	ff2496e3          	bne	s1,s2,800020ca <allocproc+0x1c>
  return 0;
    800020e2:	4481                	li	s1,0
    800020e4:	a885                	j	80002154 <allocproc+0xa6>
    800020e6:	e44e                	sd	s3,8(sp)
    800020e8:	e052                	sd	s4,0(sp)
  p->pid = allocpid();
    800020ea:	e71ff0ef          	jal	80001f5a <allocpid>
    800020ee:	d888                	sw	a0,48(s1)
  p->priority = 10;
    800020f0:	47a9                	li	a5,10
    800020f2:	d8dc                	sw	a5,52(s1)
  p->cpu_time = 0;
    800020f4:	0204bc23          	sd	zero,56(s1)
  for(int i = 0; i < NVMA; i++)
    800020f8:	16048913          	addi	s2,s1,352
    800020fc:	4e048a13          	addi	s4,s1,1248
  memset(&p->vmas[i], 0, sizeof(p->vmas[i]));
    80002100:	03800993          	li	s3,56
    80002104:	864e                	mv	a2,s3
    80002106:	4581                	li	a1,0
    80002108:	854a                	mv	a0,s2
    8000210a:	c6dfe0ef          	jal	80000d76 <memset>
  for(int i = 0; i < NVMA; i++)
    8000210e:	03890913          	addi	s2,s2,56
    80002112:	ff4919e3          	bne	s2,s4,80002104 <allocproc+0x56>
  p->state = USED;
    80002116:	4785                	li	a5,1
    80002118:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    8000211a:	a1bfe0ef          	jal	80000b34 <kalloc>
    8000211e:	892a                	mv	s2,a0
    80002120:	f0a8                	sd	a0,96(s1)
    80002122:	c121                	beqz	a0,80002162 <allocproc+0xb4>
  p->pagetable = proc_pagetable(p);
    80002124:	8526                	mv	a0,s1
    80002126:	e73ff0ef          	jal	80001f98 <proc_pagetable>
    8000212a:	892a                	mv	s2,a0
    8000212c:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    8000212e:	c521                	beqz	a0,80002176 <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    80002130:	07000613          	li	a2,112
    80002134:	4581                	li	a1,0
    80002136:	06848513          	addi	a0,s1,104
    8000213a:	c3dfe0ef          	jal	80000d76 <memset>
  p->context.ra = (uint64)forkret;
    8000213e:	00000797          	auipc	a5,0x0
    80002142:	d8878793          	addi	a5,a5,-632 # 80001ec6 <forkret>
    80002146:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80002148:	64bc                	ld	a5,72(s1)
    8000214a:	6705                	lui	a4,0x1
    8000214c:	97ba                	add	a5,a5,a4
    8000214e:	f8bc                	sd	a5,112(s1)
    80002150:	69a2                	ld	s3,8(sp)
    80002152:	6a02                	ld	s4,0(sp)
}
    80002154:	8526                	mv	a0,s1
    80002156:	70a2                	ld	ra,40(sp)
    80002158:	7402                	ld	s0,32(sp)
    8000215a:	64e2                	ld	s1,24(sp)
    8000215c:	6942                	ld	s2,16(sp)
    8000215e:	6145                	addi	sp,sp,48
    80002160:	8082                	ret
    freeproc(p);
    80002162:	8526                	mv	a0,s1
    80002164:	effff0ef          	jal	80002062 <freeproc>
    release(&p->lock);
    80002168:	8526                	mv	a0,s1
    8000216a:	bd5fe0ef          	jal	80000d3e <release>
    return 0;
    8000216e:	84ca                	mv	s1,s2
    80002170:	69a2                	ld	s3,8(sp)
    80002172:	6a02                	ld	s4,0(sp)
    80002174:	b7c5                	j	80002154 <allocproc+0xa6>
    freeproc(p);
    80002176:	8526                	mv	a0,s1
    80002178:	eebff0ef          	jal	80002062 <freeproc>
    release(&p->lock);
    8000217c:	8526                	mv	a0,s1
    8000217e:	bc1fe0ef          	jal	80000d3e <release>
    return 0;
    80002182:	84ca                	mv	s1,s2
    80002184:	69a2                	ld	s3,8(sp)
    80002186:	6a02                	ld	s4,0(sp)
    80002188:	b7f1                	j	80002154 <allocproc+0xa6>

000000008000218a <userinit>:
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	e426                	sd	s1,8(sp)
    80002192:	1000                	addi	s0,sp,32
  p = allocproc();
    80002194:	f1bff0ef          	jal	800020ae <allocproc>
    80002198:	84aa                	mv	s1,a0
  initproc = p;
    8000219a:	00006797          	auipc	a5,0x6
    8000219e:	70a7b723          	sd	a0,1806(a5) # 800088a8 <initproc>
  p->cwd = namei("/");
    800021a2:	00006517          	auipc	a0,0x6
    800021a6:	00650513          	addi	a0,a0,6 # 800081a8 <etext+0x1a8>
    800021aa:	242020ef          	jal	800043ec <namei>
    800021ae:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800021b2:	478d                	li	a5,3
    800021b4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800021b6:	8526                	mv	a0,s1
    800021b8:	b87fe0ef          	jal	80000d3e <release>
}
    800021bc:	60e2                	ld	ra,24(sp)
    800021be:	6442                	ld	s0,16(sp)
    800021c0:	64a2                	ld	s1,8(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <growproc>:
{
    800021c6:	1101                	addi	sp,sp,-32
    800021c8:	ec06                	sd	ra,24(sp)
    800021ca:	e822                	sd	s0,16(sp)
    800021cc:	e426                	sd	s1,8(sp)
    800021ce:	e04a                	sd	s2,0(sp)
    800021d0:	1000                	addi	s0,sp,32
    800021d2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021d4:	cc3ff0ef          	jal	80001e96 <myproc>
    800021d8:	892a                	mv	s2,a0
  sz = p->sz;
    800021da:	692c                	ld	a1,80(a0)
  if (n > 0) {
    800021dc:	02905963          	blez	s1,8000220e <growproc+0x48>
    if (sz + n > TRAPFRAME) {
    800021e0:	00b48633          	add	a2,s1,a1
    800021e4:	020007b7          	lui	a5,0x2000
    800021e8:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    800021ea:	07b6                	slli	a5,a5,0xd
    800021ec:	02c7ea63          	bltu	a5,a2,80002220 <growproc+0x5a>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800021f0:	4691                	li	a3,4
    800021f2:	6d28                	ld	a0,88(a0)
    800021f4:	98aff0ef          	jal	8000137e <uvmalloc>
    800021f8:	85aa                	mv	a1,a0
    800021fa:	c50d                	beqz	a0,80002224 <growproc+0x5e>
  p->sz = sz;
    800021fc:	04b93823          	sd	a1,80(s2)
  return 0;
    80002200:	4501                	li	a0,0
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6902                	ld	s2,0(sp)
    8000220a:	6105                	addi	sp,sp,32
    8000220c:	8082                	ret
  } else if (n < 0) {
    8000220e:	fe04d7e3          	bgez	s1,800021fc <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002212:	00b48633          	add	a2,s1,a1
    80002216:	6d28                	ld	a0,88(a0)
    80002218:	922ff0ef          	jal	8000133a <uvmdealloc>
    8000221c:	85aa                	mv	a1,a0
    8000221e:	bff9                	j	800021fc <growproc+0x36>
      return -1;
    80002220:	557d                	li	a0,-1
    80002222:	b7c5                	j	80002202 <growproc+0x3c>
      return -1;
    80002224:	557d                	li	a0,-1
    80002226:	bff1                	j	80002202 <growproc+0x3c>

0000000080002228 <kfork>:
{
    80002228:	7139                	addi	sp,sp,-64
    8000222a:	fc06                	sd	ra,56(sp)
    8000222c:	f822                	sd	s0,48(sp)
    8000222e:	f04a                	sd	s2,32(sp)
    80002230:	e456                	sd	s5,8(sp)
    80002232:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002234:	c63ff0ef          	jal	80001e96 <myproc>
    80002238:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    8000223a:	e75ff0ef          	jal	800020ae <allocproc>
    8000223e:	14050563          	beqz	a0,80002388 <kfork+0x160>
    80002242:	e852                	sd	s4,16(sp)
    80002244:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80002246:	050ab603          	ld	a2,80(s5)
    8000224a:	6d2c                	ld	a1,88(a0)
    8000224c:	058ab503          	ld	a0,88(s5)
    80002250:	a6eff0ef          	jal	800014be <uvmcopy>
    80002254:	00054f63          	bltz	a0,80002272 <kfork+0x4a>
    80002258:	f426                	sd	s1,40(sp)
    8000225a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000225c:	050ab783          	ld	a5,80(s5)
    80002260:	04fa3823          	sd	a5,80(s4)
  for(i = 0; i < NVMA; i++){
    80002264:	160a8493          	addi	s1,s5,352
    80002268:	160a0913          	addi	s2,s4,352
    8000226c:	4e0a8993          	addi	s3,s5,1248
    80002270:	a005                	j	80002290 <kfork+0x68>
    freeproc(np);
    80002272:	8552                	mv	a0,s4
    80002274:	defff0ef          	jal	80002062 <freeproc>
    release(&np->lock);
    80002278:	8552                	mv	a0,s4
    8000227a:	ac5fe0ef          	jal	80000d3e <release>
    return -1;
    8000227e:	597d                	li	s2,-1
    80002280:	6a42                	ld	s4,16(sp)
    80002282:	a8e5                	j	8000237a <kfork+0x152>
  for(i = 0; i < NVMA; i++){
    80002284:	03848493          	addi	s1,s1,56
    80002288:	03890913          	addi	s2,s2,56
    8000228c:	05348063          	beq	s1,s3,800022cc <kfork+0xa4>
  if(p->vmas[i].used){
    80002290:	409c                	lw	a5,0(s1)
    80002292:	dbed                	beqz	a5,80002284 <kfork+0x5c>
    np->vmas[i] = p->vmas[i];
    80002294:	0004b803          	ld	a6,0(s1)
    80002298:	6488                	ld	a0,8(s1)
    8000229a:	688c                	ld	a1,16(s1)
    8000229c:	6c90                	ld	a2,24(s1)
    8000229e:	7094                	ld	a3,32(s1)
    800022a0:	7498                	ld	a4,40(s1)
    800022a2:	789c                	ld	a5,48(s1)
    800022a4:	01093023          	sd	a6,0(s2)
    800022a8:	00a93423          	sd	a0,8(s2)
    800022ac:	00b93823          	sd	a1,16(s2)
    800022b0:	00c93c23          	sd	a2,24(s2)
    800022b4:	02d93023          	sd	a3,32(s2)
    800022b8:	02e93423          	sd	a4,40(s2)
    800022bc:	02f93823          	sd	a5,48(s2)
    np->vmas[i].file = filedup(p->vmas[i].file);
    800022c0:	7488                	ld	a0,40(s1)
    800022c2:	770020ef          	jal	80004a32 <filedup>
    800022c6:	02a93423          	sd	a0,40(s2)
    800022ca:	bf6d                	j	80002284 <kfork+0x5c>
  *(np->trapframe) = *(p->trapframe);
    800022cc:	060ab683          	ld	a3,96(s5)
    800022d0:	87b6                	mv	a5,a3
    800022d2:	060a3703          	ld	a4,96(s4)
    800022d6:	12068693          	addi	a3,a3,288
    800022da:	0007b803          	ld	a6,0(a5)
    800022de:	6788                	ld	a0,8(a5)
    800022e0:	6b8c                	ld	a1,16(a5)
    800022e2:	6f90                	ld	a2,24(a5)
    800022e4:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    800022e8:	e708                	sd	a0,8(a4)
    800022ea:	eb0c                	sd	a1,16(a4)
    800022ec:	ef10                	sd	a2,24(a4)
    800022ee:	02078793          	addi	a5,a5,32
    800022f2:	02070713          	addi	a4,a4,32
    800022f6:	fed792e3          	bne	a5,a3,800022da <kfork+0xb2>
  np->trapframe->a0 = 0;
    800022fa:	060a3783          	ld	a5,96(s4)
    800022fe:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80002302:	0d8a8493          	addi	s1,s5,216
    80002306:	0d8a0913          	addi	s2,s4,216
    8000230a:	158a8993          	addi	s3,s5,344
    8000230e:	a029                	j	80002318 <kfork+0xf0>
    80002310:	04a1                	addi	s1,s1,8
    80002312:	0921                	addi	s2,s2,8
    80002314:	01348963          	beq	s1,s3,80002326 <kfork+0xfe>
    if (p->ofile[i])
    80002318:	6088                	ld	a0,0(s1)
    8000231a:	d97d                	beqz	a0,80002310 <kfork+0xe8>
      np->ofile[i] = filedup(p->ofile[i]);
    8000231c:	716020ef          	jal	80004a32 <filedup>
    80002320:	00a93023          	sd	a0,0(s2)
    80002324:	b7f5                	j	80002310 <kfork+0xe8>
  np->cwd = idup(p->cwd);
    80002326:	158ab503          	ld	a0,344(s5)
    8000232a:	005010ef          	jal	80003b2e <idup>
    8000232e:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002332:	4641                	li	a2,16
    80002334:	4e0a8593          	addi	a1,s5,1248
    80002338:	4e0a0513          	addi	a0,s4,1248
    8000233c:	b8dfe0ef          	jal	80000ec8 <safestrcpy>
  pid = np->pid;
    80002340:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002344:	8552                	mv	a0,s4
    80002346:	9f9fe0ef          	jal	80000d3e <release>
  acquire(&wait_lock);
    8000234a:	0022e497          	auipc	s1,0x22e
    8000234e:	6b648493          	addi	s1,s1,1718 # 80230a00 <wait_lock>
    80002352:	8526                	mv	a0,s1
    80002354:	963fe0ef          	jal	80000cb6 <acquire>
  np->parent = p;
    80002358:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    8000235c:	8526                	mv	a0,s1
    8000235e:	9e1fe0ef          	jal	80000d3e <release>
  acquire(&np->lock);
    80002362:	8552                	mv	a0,s4
    80002364:	953fe0ef          	jal	80000cb6 <acquire>
  np->state = RUNNABLE;
    80002368:	478d                	li	a5,3
    8000236a:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000236e:	8552                	mv	a0,s4
    80002370:	9cffe0ef          	jal	80000d3e <release>
  return pid;
    80002374:	74a2                	ld	s1,40(sp)
    80002376:	69e2                	ld	s3,24(sp)
    80002378:	6a42                	ld	s4,16(sp)
}
    8000237a:	854a                	mv	a0,s2
    8000237c:	70e2                	ld	ra,56(sp)
    8000237e:	7442                	ld	s0,48(sp)
    80002380:	7902                	ld	s2,32(sp)
    80002382:	6aa2                	ld	s5,8(sp)
    80002384:	6121                	addi	sp,sp,64
    80002386:	8082                	ret
    return -1;
    80002388:	597d                	li	s2,-1
    8000238a:	bfc5                	j	8000237a <kfork+0x152>

000000008000238c <scheduler>:
{
    8000238c:	715d                	addi	sp,sp,-80
    8000238e:	e486                	sd	ra,72(sp)
    80002390:	e0a2                	sd	s0,64(sp)
    80002392:	fc26                	sd	s1,56(sp)
    80002394:	f84a                	sd	s2,48(sp)
    80002396:	f44e                	sd	s3,40(sp)
    80002398:	f052                	sd	s4,32(sp)
    8000239a:	ec56                	sd	s5,24(sp)
    8000239c:	e85a                	sd	s6,16(sp)
    8000239e:	e45e                	sd	s7,8(sp)
    800023a0:	0880                	addi	s0,sp,80
    800023a2:	8792                	mv	a5,tp
  int id = r_tp();
    800023a4:	2781                	sext.w	a5,a5
  c->proc = 0;
    800023a6:	00779b13          	slli	s6,a5,0x7
    800023aa:	0022e717          	auipc	a4,0x22e
    800023ae:	63e70713          	addi	a4,a4,1598 # 802309e8 <pid_lock>
    800023b2:	975a                	add	a4,a4,s6
    800023b4:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &best->context);
    800023b8:	0022e717          	auipc	a4,0x22e
    800023bc:	66870713          	addi	a4,a4,1640 # 80230a20 <cpus+0x8>
    800023c0:	9b3a                	add	s6,s6,a4
      if(p->state == RUNNABLE){
    800023c2:	4a0d                	li	s4,3
    for(p = proc; p < &proc[NPROC]; p++){
    800023c4:	00242997          	auipc	s3,0x242
    800023c8:	65498993          	addi	s3,s3,1620 # 80244a18 <tickslock>
      best->state = RUNNING;
    800023cc:	4b91                	li	s7,4
      c->proc = best;
    800023ce:	079e                	slli	a5,a5,0x7
    800023d0:	0022ea97          	auipc	s5,0x22e
    800023d4:	618a8a93          	addi	s5,s5,1560 # 802309e8 <pid_lock>
    800023d8:	9abe                	add	s5,s5,a5
    800023da:	a08d                	j	8000243c <scheduler+0xb0>
          release(&p->lock);
    800023dc:	8526                	mv	a0,s1
    800023de:	961fe0ef          	jal	80000d3e <release>
    for(p = proc; p < &proc[NPROC]; p++){
    800023e2:	4f048493          	addi	s1,s1,1264
    800023e6:	03348d63          	beq	s1,s3,80002420 <scheduler+0x94>
      acquire(&p->lock);
    800023ea:	8526                	mv	a0,s1
    800023ec:	8cbfe0ef          	jal	80000cb6 <acquire>
      if(p->state == RUNNABLE){
    800023f0:	4c9c                	lw	a5,24(s1)
    800023f2:	01479e63          	bne	a5,s4,8000240e <scheduler+0x82>
        if(best == 0 || p->priority < best->priority){
    800023f6:	04090b63          	beqz	s2,8000244c <scheduler+0xc0>
    800023fa:	58d8                	lw	a4,52(s1)
    800023fc:	03492783          	lw	a5,52(s2)
    80002400:	fcf75ee3          	bge	a4,a5,800023dc <scheduler+0x50>
            release(&best->lock);
    80002404:	854a                	mv	a0,s2
    80002406:	939fe0ef          	jal	80000d3e <release>
          best = p;
    8000240a:	8926                	mv	s2,s1
    8000240c:	bfd9                	j	800023e2 <scheduler+0x56>
        release(&p->lock);
    8000240e:	8526                	mv	a0,s1
    80002410:	92ffe0ef          	jal	80000d3e <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80002414:	4f048493          	addi	s1,s1,1264
    80002418:	fd3499e3          	bne	s1,s3,800023ea <scheduler+0x5e>
    if(best != 0){
    8000241c:	02090063          	beqz	s2,8000243c <scheduler+0xb0>
      best->state = RUNNING;
    80002420:	01792c23          	sw	s7,24(s2)
      c->proc = best;
    80002424:	032ab823          	sd	s2,48(s5)
      swtch(&c->context, &best->context);
    80002428:	06890593          	addi	a1,s2,104
    8000242c:	855a                	mv	a0,s6
    8000242e:	644000ef          	jal	80002a72 <swtch>
      c->proc = 0;
    80002432:	020ab823          	sd	zero,48(s5)
      release(&best->lock);
    80002436:	854a                	mv	a0,s2
    80002438:	907fe0ef          	jal	80000d3e <release>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    8000243c:	10016073          	csrsi	sstatus,2
    best = 0;
    80002440:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC]; p++){
    80002442:	0022f497          	auipc	s1,0x22f
    80002446:	9d648493          	addi	s1,s1,-1578 # 80230e18 <proc>
    8000244a:	b745                	j	800023ea <scheduler+0x5e>
          best = p;
    8000244c:	8926                	mv	s2,s1
    8000244e:	bf51                	j	800023e2 <scheduler+0x56>

0000000080002450 <sched>:
{
    80002450:	7179                	addi	sp,sp,-48
    80002452:	f406                	sd	ra,40(sp)
    80002454:	f022                	sd	s0,32(sp)
    80002456:	ec26                	sd	s1,24(sp)
    80002458:	e84a                	sd	s2,16(sp)
    8000245a:	e44e                	sd	s3,8(sp)
    8000245c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000245e:	a39ff0ef          	jal	80001e96 <myproc>
    80002462:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002464:	ff2fe0ef          	jal	80000c56 <holding>
    80002468:	c92d                	beqz	a0,800024da <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    8000246a:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    8000246c:	2781                	sext.w	a5,a5
    8000246e:	079e                	slli	a5,a5,0x7
    80002470:	0022e717          	auipc	a4,0x22e
    80002474:	57870713          	addi	a4,a4,1400 # 802309e8 <pid_lock>
    80002478:	97ba                	add	a5,a5,a4
    8000247a:	0a87a703          	lw	a4,168(a5)
    8000247e:	4785                	li	a5,1
    80002480:	06f71363          	bne	a4,a5,800024e6 <sched+0x96>
  if (p->state == RUNNING)
    80002484:	4c98                	lw	a4,24(s1)
    80002486:	4791                	li	a5,4
    80002488:	06f70563          	beq	a4,a5,800024f2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000248c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002490:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002492:	e7b5                	bnez	a5,800024fe <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80002494:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002496:	0022e917          	auipc	s2,0x22e
    8000249a:	55290913          	addi	s2,s2,1362 # 802309e8 <pid_lock>
    8000249e:	2781                	sext.w	a5,a5
    800024a0:	079e                	slli	a5,a5,0x7
    800024a2:	97ca                	add	a5,a5,s2
    800024a4:	0ac7a983          	lw	s3,172(a5)
    800024a8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800024aa:	2781                	sext.w	a5,a5
    800024ac:	079e                	slli	a5,a5,0x7
    800024ae:	0022e597          	auipc	a1,0x22e
    800024b2:	57258593          	addi	a1,a1,1394 # 80230a20 <cpus+0x8>
    800024b6:	95be                	add	a1,a1,a5
    800024b8:	06848513          	addi	a0,s1,104
    800024bc:	5b6000ef          	jal	80002a72 <swtch>
    800024c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800024c2:	2781                	sext.w	a5,a5
    800024c4:	079e                	slli	a5,a5,0x7
    800024c6:	993e                	add	s2,s2,a5
    800024c8:	0b392623          	sw	s3,172(s2)
}
    800024cc:	70a2                	ld	ra,40(sp)
    800024ce:	7402                	ld	s0,32(sp)
    800024d0:	64e2                	ld	s1,24(sp)
    800024d2:	6942                	ld	s2,16(sp)
    800024d4:	69a2                	ld	s3,8(sp)
    800024d6:	6145                	addi	sp,sp,48
    800024d8:	8082                	ret
    panic("sched p->lock");
    800024da:	00006517          	auipc	a0,0x6
    800024de:	cd650513          	addi	a0,a0,-810 # 800081b0 <etext+0x1b0>
    800024e2:	b0cfe0ef          	jal	800007ee <panic>
    panic("sched locks");
    800024e6:	00006517          	auipc	a0,0x6
    800024ea:	cda50513          	addi	a0,a0,-806 # 800081c0 <etext+0x1c0>
    800024ee:	b00fe0ef          	jal	800007ee <panic>
    panic("sched RUNNING");
    800024f2:	00006517          	auipc	a0,0x6
    800024f6:	cde50513          	addi	a0,a0,-802 # 800081d0 <etext+0x1d0>
    800024fa:	af4fe0ef          	jal	800007ee <panic>
    panic("sched interruptible");
    800024fe:	00006517          	auipc	a0,0x6
    80002502:	ce250513          	addi	a0,a0,-798 # 800081e0 <etext+0x1e0>
    80002506:	ae8fe0ef          	jal	800007ee <panic>

000000008000250a <yield>:
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002514:	983ff0ef          	jal	80001e96 <myproc>
    80002518:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000251a:	f9cfe0ef          	jal	80000cb6 <acquire>
  p->state = RUNNABLE;
    8000251e:	478d                	li	a5,3
    80002520:	cc9c                	sw	a5,24(s1)
  sched();
    80002522:	f2fff0ef          	jal	80002450 <sched>
  release(&p->lock);
    80002526:	8526                	mv	a0,s1
    80002528:	817fe0ef          	jal	80000d3e <release>
}
    8000252c:	60e2                	ld	ra,24(sp)
    8000252e:	6442                	ld	s0,16(sp)
    80002530:	64a2                	ld	s1,8(sp)
    80002532:	6105                	addi	sp,sp,32
    80002534:	8082                	ret

0000000080002536 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80002536:	1101                	addi	sp,sp,-32
    80002538:	ec06                	sd	ra,24(sp)
    8000253a:	e822                	sd	s0,16(sp)
    8000253c:	e426                	sd	s1,8(sp)
    8000253e:	e04a                	sd	s2,0(sp)
    80002540:	1000                	addi	s0,sp,32
    80002542:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002544:	953ff0ef          	jal	80001e96 <myproc>
    80002548:	892a                	mv	s2,a0

  acquire(&p->lock);
    8000254a:	f6cfe0ef          	jal	80000cb6 <acquire>
  if (chan == 0)
    8000254e:	cc81                	beqz	s1,80002566 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80002550:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80002554:	854a                	mv	a0,s2
    80002556:	fe8fe0ef          	jal	80000d3e <release>
}
    8000255a:	60e2                	ld	ra,24(sp)
    8000255c:	6442                	ld	s0,16(sp)
    8000255e:	64a2                	ld	s1,8(sp)
    80002560:	6902                	ld	s2,0(sp)
    80002562:	6105                	addi	sp,sp,32
    80002564:	8082                	ret
    panic("sleep_prepare: zero chan");
    80002566:	00006517          	auipc	a0,0x6
    8000256a:	c9250513          	addi	a0,a0,-878 # 800081f8 <etext+0x1f8>
    8000256e:	a80fe0ef          	jal	800007ee <panic>

0000000080002572 <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80002572:	1101                	addi	sp,sp,-32
    80002574:	ec06                	sd	ra,24(sp)
    80002576:	e822                	sd	s0,16(sp)
    80002578:	e426                	sd	s1,8(sp)
    8000257a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000257c:	91bff0ef          	jal	80001e96 <myproc>
    80002580:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80002582:	f34fe0ef          	jal	80000cb6 <acquire>
  if (p->chan != 0) {
    80002586:	709c                	ld	a5,32(s1)
    80002588:	c789                	beqz	a5,80002592 <sleep+0x20>
    p->state = SLEEPING;
    8000258a:	4789                	li	a5,2
    8000258c:	cc9c                	sw	a5,24(s1)
    sched();
    8000258e:	ec3ff0ef          	jal	80002450 <sched>
  }
  release(&p->lock);
    80002592:	8526                	mv	a0,s1
    80002594:	faafe0ef          	jal	80000d3e <release>
}
    80002598:	60e2                	ld	ra,24(sp)
    8000259a:	6442                	ld	s0,16(sp)
    8000259c:	64a2                	ld	s1,8(sp)
    8000259e:	6105                	addi	sp,sp,32
    800025a0:	8082                	ret

00000000800025a2 <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    800025a2:	7139                	addi	sp,sp,-64
    800025a4:	fc06                	sd	ra,56(sp)
    800025a6:	f822                	sd	s0,48(sp)
    800025a8:	f426                	sd	s1,40(sp)
    800025aa:	f04a                	sd	s2,32(sp)
    800025ac:	ec4e                	sd	s3,24(sp)
    800025ae:	e852                	sd	s4,16(sp)
    800025b0:	e456                	sd	s5,8(sp)
    800025b2:	0080                	addi	s0,sp,64
    800025b4:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    800025b6:	0022f497          	auipc	s1,0x22f
    800025ba:	86248493          	addi	s1,s1,-1950 # 80230e18 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    800025be:	4a09                	li	s4,2
        p->state = RUNNABLE;
    800025c0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    800025c2:	00242997          	auipc	s3,0x242
    800025c6:	45698993          	addi	s3,s3,1110 # 80244a18 <tickslock>
    800025ca:	a801                	j	800025da <wakeup+0x38>
      }
    }
    release(&p->lock);
    800025cc:	8526                	mv	a0,s1
    800025ce:	f70fe0ef          	jal	80000d3e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800025d2:	4f048493          	addi	s1,s1,1264
    800025d6:	03348063          	beq	s1,s3,800025f6 <wakeup+0x54>
    acquire(&p->lock);
    800025da:	8526                	mv	a0,s1
    800025dc:	edafe0ef          	jal	80000cb6 <acquire>
    if (p->chan == chan) {
    800025e0:	709c                	ld	a5,32(s1)
    800025e2:	ff2795e3          	bne	a5,s2,800025cc <wakeup+0x2a>
      p->chan = 0;
    800025e6:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    800025ea:	4c9c                	lw	a5,24(s1)
    800025ec:	ff4790e3          	bne	a5,s4,800025cc <wakeup+0x2a>
        p->state = RUNNABLE;
    800025f0:	0154ac23          	sw	s5,24(s1)
    800025f4:	bfe1                	j	800025cc <wakeup+0x2a>
  }
}
    800025f6:	70e2                	ld	ra,56(sp)
    800025f8:	7442                	ld	s0,48(sp)
    800025fa:	74a2                	ld	s1,40(sp)
    800025fc:	7902                	ld	s2,32(sp)
    800025fe:	69e2                	ld	s3,24(sp)
    80002600:	6a42                	ld	s4,16(sp)
    80002602:	6aa2                	ld	s5,8(sp)
    80002604:	6121                	addi	sp,sp,64
    80002606:	8082                	ret

0000000080002608 <reparent>:
{
    80002608:	7179                	addi	sp,sp,-48
    8000260a:	f406                	sd	ra,40(sp)
    8000260c:	f022                	sd	s0,32(sp)
    8000260e:	ec26                	sd	s1,24(sp)
    80002610:	e84a                	sd	s2,16(sp)
    80002612:	e44e                	sd	s3,8(sp)
    80002614:	e052                	sd	s4,0(sp)
    80002616:	1800                	addi	s0,sp,48
    80002618:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000261a:	0022e497          	auipc	s1,0x22e
    8000261e:	7fe48493          	addi	s1,s1,2046 # 80230e18 <proc>
      pp->parent = initproc;
    80002622:	00006a17          	auipc	s4,0x6
    80002626:	286a0a13          	addi	s4,s4,646 # 800088a8 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000262a:	00242997          	auipc	s3,0x242
    8000262e:	3ee98993          	addi	s3,s3,1006 # 80244a18 <tickslock>
    80002632:	a029                	j	8000263c <reparent+0x34>
    80002634:	4f048493          	addi	s1,s1,1264
    80002638:	01348b63          	beq	s1,s3,8000264e <reparent+0x46>
    if (pp->parent == p) {
    8000263c:	60bc                	ld	a5,64(s1)
    8000263e:	ff279be3          	bne	a5,s2,80002634 <reparent+0x2c>
      pp->parent = initproc;
    80002642:	000a3503          	ld	a0,0(s4)
    80002646:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80002648:	f5bff0ef          	jal	800025a2 <wakeup>
    8000264c:	b7e5                	j	80002634 <reparent+0x2c>
}
    8000264e:	70a2                	ld	ra,40(sp)
    80002650:	7402                	ld	s0,32(sp)
    80002652:	64e2                	ld	s1,24(sp)
    80002654:	6942                	ld	s2,16(sp)
    80002656:	69a2                	ld	s3,8(sp)
    80002658:	6a02                	ld	s4,0(sp)
    8000265a:	6145                	addi	sp,sp,48
    8000265c:	8082                	ret

000000008000265e <kexit>:
{
    8000265e:	7179                	addi	sp,sp,-48
    80002660:	f406                	sd	ra,40(sp)
    80002662:	f022                	sd	s0,32(sp)
    80002664:	e052                	sd	s4,0(sp)
    80002666:	1800                	addi	s0,sp,48
    80002668:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000266a:	82dff0ef          	jal	80001e96 <myproc>
  if (p == initproc)
    8000266e:	00006797          	auipc	a5,0x6
    80002672:	23a7b783          	ld	a5,570(a5) # 800088a8 <initproc>
    80002676:	00a78d63          	beq	a5,a0,80002690 <kexit+0x32>
    8000267a:	ec26                	sd	s1,24(sp)
    8000267c:	e84a                	sd	s2,16(sp)
    8000267e:	e44e                	sd	s3,8(sp)
    80002680:	89aa                	mv	s3,a0
  mmap_cleanup(p);
    80002682:	e52ff0ef          	jal	80001cd4 <mmap_cleanup>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002686:	0d898493          	addi	s1,s3,216
    8000268a:	15898913          	addi	s2,s3,344
    8000268e:	a00d                	j	800026b0 <kexit+0x52>
    80002690:	ec26                	sd	s1,24(sp)
    80002692:	e84a                	sd	s2,16(sp)
    80002694:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    80002696:	00006517          	auipc	a0,0x6
    8000269a:	b8250513          	addi	a0,a0,-1150 # 80008218 <etext+0x218>
    8000269e:	950fe0ef          	jal	800007ee <panic>
      fileclose(f);
    800026a2:	3d6020ef          	jal	80004a78 <fileclose>
      p->ofile[fd] = 0;
    800026a6:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    800026aa:	04a1                	addi	s1,s1,8
    800026ac:	01248563          	beq	s1,s2,800026b6 <kexit+0x58>
    if (p->ofile[fd]) {
    800026b0:	6088                	ld	a0,0(s1)
    800026b2:	f965                	bnez	a0,800026a2 <kexit+0x44>
    800026b4:	bfdd                	j	800026aa <kexit+0x4c>
  begin_op();
    800026b6:	711010ef          	jal	800045c6 <begin_op>
  iput(p->cwd);
    800026ba:	1589b503          	ld	a0,344(s3)
    800026be:	628010ef          	jal	80003ce6 <iput>
  end_op();
    800026c2:	78b010ef          	jal	8000464c <end_op>
  p->cwd = 0;
    800026c6:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800026ca:	0022e497          	auipc	s1,0x22e
    800026ce:	33648493          	addi	s1,s1,822 # 80230a00 <wait_lock>
    800026d2:	8526                	mv	a0,s1
    800026d4:	de2fe0ef          	jal	80000cb6 <acquire>
  reparent(p);
    800026d8:	854e                	mv	a0,s3
    800026da:	f2fff0ef          	jal	80002608 <reparent>
  wakeup(p->parent);
    800026de:	0409b503          	ld	a0,64(s3)
    800026e2:	ec1ff0ef          	jal	800025a2 <wakeup>
  acquire(&p->lock);
    800026e6:	854e                	mv	a0,s3
    800026e8:	dcefe0ef          	jal	80000cb6 <acquire>
  p->xstate = status;
    800026ec:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800026f0:	4795                	li	a5,5
    800026f2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800026f6:	8526                	mv	a0,s1
    800026f8:	e46fe0ef          	jal	80000d3e <release>
  sched();
    800026fc:	d55ff0ef          	jal	80002450 <sched>
  panic("zombie exit");
    80002700:	00006517          	auipc	a0,0x6
    80002704:	b2850513          	addi	a0,a0,-1240 # 80008228 <etext+0x228>
    80002708:	8e6fe0ef          	jal	800007ee <panic>

000000008000270c <kkill>:
int
kkill(int pid)
{
  struct proc *p;

  if (pid == 0)
    8000270c:	c525                	beqz	a0,80002774 <kkill+0x68>
{
    8000270e:	7179                	addi	sp,sp,-48
    80002710:	f406                	sd	ra,40(sp)
    80002712:	f022                	sd	s0,32(sp)
    80002714:	ec26                	sd	s1,24(sp)
    80002716:	e84a                	sd	s2,16(sp)
    80002718:	e44e                	sd	s3,8(sp)
    8000271a:	1800                	addi	s0,sp,48
    8000271c:	892a                	mv	s2,a0
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000271e:	0022e497          	auipc	s1,0x22e
    80002722:	6fa48493          	addi	s1,s1,1786 # 80230e18 <proc>
    80002726:	00242997          	auipc	s3,0x242
    8000272a:	2f298993          	addi	s3,s3,754 # 80244a18 <tickslock>
    acquire(&p->lock);
    8000272e:	8526                	mv	a0,s1
    80002730:	d86fe0ef          	jal	80000cb6 <acquire>
    if (p->pid == pid) {
    80002734:	589c                	lw	a5,48(s1)
    80002736:	01278b63          	beq	a5,s2,8000274c <kkill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000273a:	8526                	mv	a0,s1
    8000273c:	e02fe0ef          	jal	80000d3e <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002740:	4f048493          	addi	s1,s1,1264
    80002744:	ff3495e3          	bne	s1,s3,8000272e <kkill+0x22>
  }
  return -1;
    80002748:	557d                	li	a0,-1
    8000274a:	a819                	j	80002760 <kkill+0x54>
      p->killed = 1;
    8000274c:	4785                	li	a5,1
    8000274e:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    80002750:	4c98                	lw	a4,24(s1)
    80002752:	4789                	li	a5,2
    80002754:	00f70d63          	beq	a4,a5,8000276e <kkill+0x62>
      release(&p->lock);
    80002758:	8526                	mv	a0,s1
    8000275a:	de4fe0ef          	jal	80000d3e <release>
      return 0;
    8000275e:	4501                	li	a0,0
}
    80002760:	70a2                	ld	ra,40(sp)
    80002762:	7402                	ld	s0,32(sp)
    80002764:	64e2                	ld	s1,24(sp)
    80002766:	6942                	ld	s2,16(sp)
    80002768:	69a2                	ld	s3,8(sp)
    8000276a:	6145                	addi	sp,sp,48
    8000276c:	8082                	ret
        p->state = RUNNABLE;
    8000276e:	478d                	li	a5,3
    80002770:	cc9c                	sw	a5,24(s1)
    80002772:	b7dd                	j	80002758 <kkill+0x4c>
    return -1;
    80002774:	557d                	li	a0,-1
}
    80002776:	8082                	ret

0000000080002778 <setkilled>:

void
setkilled(struct proc *p)
{
    80002778:	1101                	addi	sp,sp,-32
    8000277a:	ec06                	sd	ra,24(sp)
    8000277c:	e822                	sd	s0,16(sp)
    8000277e:	e426                	sd	s1,8(sp)
    80002780:	1000                	addi	s0,sp,32
    80002782:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002784:	d32fe0ef          	jal	80000cb6 <acquire>
  p->killed = 1;
    80002788:	4785                	li	a5,1
    8000278a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000278c:	8526                	mv	a0,s1
    8000278e:	db0fe0ef          	jal	80000d3e <release>
}
    80002792:	60e2                	ld	ra,24(sp)
    80002794:	6442                	ld	s0,16(sp)
    80002796:	64a2                	ld	s1,8(sp)
    80002798:	6105                	addi	sp,sp,32
    8000279a:	8082                	ret

000000008000279c <killed>:

int
killed(struct proc *p)
{
    8000279c:	1101                	addi	sp,sp,-32
    8000279e:	ec06                	sd	ra,24(sp)
    800027a0:	e822                	sd	s0,16(sp)
    800027a2:	e426                	sd	s1,8(sp)
    800027a4:	e04a                	sd	s2,0(sp)
    800027a6:	1000                	addi	s0,sp,32
    800027a8:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800027aa:	d0cfe0ef          	jal	80000cb6 <acquire>
  k = p->killed;
    800027ae:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800027b2:	8526                	mv	a0,s1
    800027b4:	d8afe0ef          	jal	80000d3e <release>
  return k;
}
    800027b8:	854a                	mv	a0,s2
    800027ba:	60e2                	ld	ra,24(sp)
    800027bc:	6442                	ld	s0,16(sp)
    800027be:	64a2                	ld	s1,8(sp)
    800027c0:	6902                	ld	s2,0(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret

00000000800027c6 <kwait>:
{
    800027c6:	715d                	addi	sp,sp,-80
    800027c8:	e486                	sd	ra,72(sp)
    800027ca:	e0a2                	sd	s0,64(sp)
    800027cc:	fc26                	sd	s1,56(sp)
    800027ce:	f84a                	sd	s2,48(sp)
    800027d0:	f44e                	sd	s3,40(sp)
    800027d2:	f052                	sd	s4,32(sp)
    800027d4:	ec56                	sd	s5,24(sp)
    800027d6:	e85a                	sd	s6,16(sp)
    800027d8:	e45e                	sd	s7,8(sp)
    800027da:	0880                	addi	s0,sp,80
    800027dc:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800027de:	eb8ff0ef          	jal	80001e96 <myproc>
    800027e2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800027e4:	0022e517          	auipc	a0,0x22e
    800027e8:	21c50513          	addi	a0,a0,540 # 80230a00 <wait_lock>
    800027ec:	ccafe0ef          	jal	80000cb6 <acquire>
        if (pp->state == ZOMBIE) {
    800027f0:	4a15                	li	s4,5
        havekids = 1;
    800027f2:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800027f4:	00242997          	auipc	s3,0x242
    800027f8:	22498993          	addi	s3,s3,548 # 80244a18 <tickslock>
    release(&wait_lock);
    800027fc:	0022eb97          	auipc	s7,0x22e
    80002800:	204b8b93          	addi	s7,s7,516 # 80230a00 <wait_lock>
    80002804:	a845                	j	800028b4 <kwait+0xee>
          pid = pp->pid;
    80002806:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    8000280a:	000b0e63          	beqz	s6,80002826 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    8000280e:	4711                	li	a4,4
    80002810:	02c48693          	addi	a3,s1,44
    80002814:	865a                	mv	a2,s6
    80002816:	05093583          	ld	a1,80(s2)
    8000281a:	05893503          	ld	a0,88(s2)
    8000281e:	902ff0ef          	jal	80001920 <copyout>
          if (addr != 0 &&
    80002822:	02054c63          	bltz	a0,8000285a <kwait+0x94>
          pp->parent = 0;
    80002826:	0404b023          	sd	zero,64(s1)
          freeproc(pp);
    8000282a:	8526                	mv	a0,s1
    8000282c:	837ff0ef          	jal	80002062 <freeproc>
          release(&pp->lock);
    80002830:	8526                	mv	a0,s1
    80002832:	d0cfe0ef          	jal	80000d3e <release>
          release(&wait_lock);
    80002836:	0022e517          	auipc	a0,0x22e
    8000283a:	1ca50513          	addi	a0,a0,458 # 80230a00 <wait_lock>
    8000283e:	d00fe0ef          	jal	80000d3e <release>
}
    80002842:	854e                	mv	a0,s3
    80002844:	60a6                	ld	ra,72(sp)
    80002846:	6406                	ld	s0,64(sp)
    80002848:	74e2                	ld	s1,56(sp)
    8000284a:	7942                	ld	s2,48(sp)
    8000284c:	79a2                	ld	s3,40(sp)
    8000284e:	7a02                	ld	s4,32(sp)
    80002850:	6ae2                	ld	s5,24(sp)
    80002852:	6b42                	ld	s6,16(sp)
    80002854:	6ba2                	ld	s7,8(sp)
    80002856:	6161                	addi	sp,sp,80
    80002858:	8082                	ret
            release(&pp->lock);
    8000285a:	8526                	mv	a0,s1
    8000285c:	ce2fe0ef          	jal	80000d3e <release>
            release(&wait_lock);
    80002860:	0022e517          	auipc	a0,0x22e
    80002864:	1a050513          	addi	a0,a0,416 # 80230a00 <wait_lock>
    80002868:	cd6fe0ef          	jal	80000d3e <release>
            return -1;
    8000286c:	59fd                	li	s3,-1
    8000286e:	bfd1                	j	80002842 <kwait+0x7c>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002870:	4f048493          	addi	s1,s1,1264
    80002874:	03348063          	beq	s1,s3,80002894 <kwait+0xce>
      if (pp->parent == p) {
    80002878:	60bc                	ld	a5,64(s1)
    8000287a:	ff279be3          	bne	a5,s2,80002870 <kwait+0xaa>
        acquire(&pp->lock);
    8000287e:	8526                	mv	a0,s1
    80002880:	c36fe0ef          	jal	80000cb6 <acquire>
        if (pp->state == ZOMBIE) {
    80002884:	4c9c                	lw	a5,24(s1)
    80002886:	f94780e3          	beq	a5,s4,80002806 <kwait+0x40>
        release(&pp->lock);
    8000288a:	8526                	mv	a0,s1
    8000288c:	cb2fe0ef          	jal	80000d3e <release>
        havekids = 1;
    80002890:	8756                	mv	a4,s5
    80002892:	bff9                	j	80002870 <kwait+0xaa>
    if (!havekids || killed(p)) {
    80002894:	c715                	beqz	a4,800028c0 <kwait+0xfa>
    80002896:	854a                	mv	a0,s2
    80002898:	f05ff0ef          	jal	8000279c <killed>
    8000289c:	e115                	bnez	a0,800028c0 <kwait+0xfa>
    sleep_prepare(p); //DOC: wait-sleep
    8000289e:	854a                	mv	a0,s2
    800028a0:	c97ff0ef          	jal	80002536 <sleep_prepare>
    release(&wait_lock);
    800028a4:	855e                	mv	a0,s7
    800028a6:	c98fe0ef          	jal	80000d3e <release>
    sleep();
    800028aa:	cc9ff0ef          	jal	80002572 <sleep>
    acquire(&wait_lock);
    800028ae:	855e                	mv	a0,s7
    800028b0:	c06fe0ef          	jal	80000cb6 <acquire>
    havekids = 0;
    800028b4:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800028b6:	0022e497          	auipc	s1,0x22e
    800028ba:	56248493          	addi	s1,s1,1378 # 80230e18 <proc>
    800028be:	bf6d                	j	80002878 <kwait+0xb2>
      release(&wait_lock);
    800028c0:	0022e517          	auipc	a0,0x22e
    800028c4:	14050513          	addi	a0,a0,320 # 80230a00 <wait_lock>
    800028c8:	c76fe0ef          	jal	80000d3e <release>
      return -1;
    800028cc:	59fd                	li	s3,-1
    800028ce:	bf95                	j	80002842 <kwait+0x7c>

00000000800028d0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800028d0:	7179                	addi	sp,sp,-48
    800028d2:	f406                	sd	ra,40(sp)
    800028d4:	f022                	sd	s0,32(sp)
    800028d6:	ec26                	sd	s1,24(sp)
    800028d8:	e84a                	sd	s2,16(sp)
    800028da:	e44e                	sd	s3,8(sp)
    800028dc:	e052                	sd	s4,0(sp)
    800028de:	1800                	addi	s0,sp,48
    800028e0:	84aa                	mv	s1,a0
    800028e2:	892e                	mv	s2,a1
    800028e4:	89b2                	mv	s3,a2
    800028e6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028e8:	daeff0ef          	jal	80001e96 <myproc>
  if (user_dst) {
    800028ec:	c085                	beqz	s1,8000290c <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    800028ee:	8752                	mv	a4,s4
    800028f0:	86ce                	mv	a3,s3
    800028f2:	864a                	mv	a2,s2
    800028f4:	692c                	ld	a1,80(a0)
    800028f6:	6d28                	ld	a0,88(a0)
    800028f8:	828ff0ef          	jal	80001920 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800028fc:	70a2                	ld	ra,40(sp)
    800028fe:	7402                	ld	s0,32(sp)
    80002900:	64e2                	ld	s1,24(sp)
    80002902:	6942                	ld	s2,16(sp)
    80002904:	69a2                	ld	s3,8(sp)
    80002906:	6a02                	ld	s4,0(sp)
    80002908:	6145                	addi	sp,sp,48
    8000290a:	8082                	ret
    memmove((char *)dst, src, len);
    8000290c:	000a061b          	sext.w	a2,s4
    80002910:	85ce                	mv	a1,s3
    80002912:	854a                	mv	a0,s2
    80002914:	cc6fe0ef          	jal	80000dda <memmove>
    return 0;
    80002918:	8526                	mv	a0,s1
    8000291a:	b7cd                	j	800028fc <either_copyout+0x2c>

000000008000291c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000291c:	7179                	addi	sp,sp,-48
    8000291e:	f406                	sd	ra,40(sp)
    80002920:	f022                	sd	s0,32(sp)
    80002922:	ec26                	sd	s1,24(sp)
    80002924:	e84a                	sd	s2,16(sp)
    80002926:	e44e                	sd	s3,8(sp)
    80002928:	e052                	sd	s4,0(sp)
    8000292a:	1800                	addi	s0,sp,48
    8000292c:	892a                	mv	s2,a0
    8000292e:	84ae                	mv	s1,a1
    80002930:	89b2                	mv	s3,a2
    80002932:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002934:	d62ff0ef          	jal	80001e96 <myproc>
  if (user_src) {
    80002938:	c085                	beqz	s1,80002958 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    8000293a:	8752                	mv	a4,s4
    8000293c:	86ce                	mv	a3,s3
    8000293e:	864a                	mv	a2,s2
    80002940:	692c                	ld	a1,80(a0)
    80002942:	6d28                	ld	a0,88(a0)
    80002944:	8e2ff0ef          	jal	80001a26 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002948:	70a2                	ld	ra,40(sp)
    8000294a:	7402                	ld	s0,32(sp)
    8000294c:	64e2                	ld	s1,24(sp)
    8000294e:	6942                	ld	s2,16(sp)
    80002950:	69a2                	ld	s3,8(sp)
    80002952:	6a02                	ld	s4,0(sp)
    80002954:	6145                	addi	sp,sp,48
    80002956:	8082                	ret
    memmove(dst, (char *)src, len);
    80002958:	000a061b          	sext.w	a2,s4
    8000295c:	85ce                	mv	a1,s3
    8000295e:	854a                	mv	a0,s2
    80002960:	c7afe0ef          	jal	80000dda <memmove>
    return 0;
    80002964:	8526                	mv	a0,s1
    80002966:	b7cd                	j	80002948 <either_copyin+0x2c>

0000000080002968 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002968:	715d                	addi	sp,sp,-80
    8000296a:	e486                	sd	ra,72(sp)
    8000296c:	e0a2                	sd	s0,64(sp)
    8000296e:	fc26                	sd	s1,56(sp)
    80002970:	f84a                	sd	s2,48(sp)
    80002972:	f44e                	sd	s3,40(sp)
    80002974:	f052                	sd	s4,32(sp)
    80002976:	ec56                	sd	s5,24(sp)
    80002978:	e85a                	sd	s6,16(sp)
    8000297a:	e45e                	sd	s7,8(sp)
    8000297c:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000297e:	00005517          	auipc	a0,0x5
    80002982:	71250513          	addi	a0,a0,1810 # 80008090 <etext+0x90>
    80002986:	b85fd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000298a:	0022f497          	auipc	s1,0x22f
    8000298e:	96e48493          	addi	s1,s1,-1682 # 802312f8 <proc+0x4e0>
    80002992:	00242917          	auipc	s2,0x242
    80002996:	56690913          	addi	s2,s2,1382 # 80244ef8 <bcache+0x4c8>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000299a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000299c:	00006997          	auipc	s3,0x6
    800029a0:	89c98993          	addi	s3,s3,-1892 # 80008238 <etext+0x238>
    printk("%d\t%d\t%lu\t%s\t%s",
    800029a4:	00006a97          	auipc	s5,0x6
    800029a8:	89ca8a93          	addi	s5,s5,-1892 # 80008240 <etext+0x240>
       p->pid,
       p->priority,
       p->cpu_time,
       state,
       p->name);
    printk("\n");
    800029ac:	00005a17          	auipc	s4,0x5
    800029b0:	6e4a0a13          	addi	s4,s4,1764 # 80008090 <etext+0x90>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029b4:	00006b97          	auipc	s7,0x6
    800029b8:	dacb8b93          	addi	s7,s7,-596 # 80008760 <states.0>
    800029bc:	a00d                	j	800029de <procdump+0x76>
    printk("%d\t%d\t%lu\t%s\t%s",
    800029be:	b587b683          	ld	a3,-1192(a5)
    800029c2:	b547a603          	lw	a2,-1196(a5)
    800029c6:	b507a583          	lw	a1,-1200(a5)
    800029ca:	8556                	mv	a0,s5
    800029cc:	b3ffd0ef          	jal	8000050a <printk>
    printk("\n");
    800029d0:	8552                	mv	a0,s4
    800029d2:	b39fd0ef          	jal	8000050a <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800029d6:	4f048493          	addi	s1,s1,1264
    800029da:	03248263          	beq	s1,s2,800029fe <procdump+0x96>
    if (p->state == UNUSED)
    800029de:	87a6                	mv	a5,s1
    800029e0:	b384a683          	lw	a3,-1224(s1)
    800029e4:	daed                	beqz	a3,800029d6 <procdump+0x6e>
      state = "???";
    800029e6:	874e                	mv	a4,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800029e8:	fcdb6be3          	bltu	s6,a3,800029be <procdump+0x56>
    800029ec:	02069713          	slli	a4,a3,0x20
    800029f0:	01d75693          	srli	a3,a4,0x1d
    800029f4:	96de                	add	a3,a3,s7
    800029f6:	6298                	ld	a4,0(a3)
    800029f8:	f379                	bnez	a4,800029be <procdump+0x56>
      state = "???";
    800029fa:	874e                	mv	a4,s3
    800029fc:	b7c9                	j	800029be <procdump+0x56>
  }
}
    800029fe:	60a6                	ld	ra,72(sp)
    80002a00:	6406                	ld	s0,64(sp)
    80002a02:	74e2                	ld	s1,56(sp)
    80002a04:	7942                	ld	s2,48(sp)
    80002a06:	79a2                	ld	s3,40(sp)
    80002a08:	7a02                	ld	s4,32(sp)
    80002a0a:	6ae2                	ld	s5,24(sp)
    80002a0c:	6b42                	ld	s6,16(sp)
    80002a0e:	6ba2                	ld	s7,8(sp)
    80002a10:	6161                	addi	sp,sp,80
    80002a12:	8082                	ret

0000000080002a14 <setpriority>:

int
setpriority(int pid, int priority)
{
    80002a14:	7179                	addi	sp,sp,-48
    80002a16:	f406                	sd	ra,40(sp)
    80002a18:	f022                	sd	s0,32(sp)
    80002a1a:	ec26                	sd	s1,24(sp)
    80002a1c:	e84a                	sd	s2,16(sp)
    80002a1e:	e44e                	sd	s3,8(sp)
    80002a20:	e052                	sd	s4,0(sp)
    80002a22:	1800                	addi	s0,sp,48
    80002a24:	892a                	mv	s2,a0
    80002a26:	8a2e                	mv	s4,a1
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002a28:	0022e497          	auipc	s1,0x22e
    80002a2c:	3f048493          	addi	s1,s1,1008 # 80230e18 <proc>
    80002a30:	00242997          	auipc	s3,0x242
    80002a34:	fe898993          	addi	s3,s3,-24 # 80244a18 <tickslock>
    acquire(&p->lock);
    80002a38:	8526                	mv	a0,s1
    80002a3a:	a7cfe0ef          	jal	80000cb6 <acquire>

    if(p->pid == pid){
    80002a3e:	589c                	lw	a5,48(s1)
    80002a40:	01278b63          	beq	a5,s2,80002a56 <setpriority+0x42>
      p->priority = priority;
      release(&p->lock);
      return 0;
    }

    release(&p->lock);
    80002a44:	8526                	mv	a0,s1
    80002a46:	af8fe0ef          	jal	80000d3e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a4a:	4f048493          	addi	s1,s1,1264
    80002a4e:	ff3495e3          	bne	s1,s3,80002a38 <setpriority+0x24>
  }

  return -1;
    80002a52:	557d                	li	a0,-1
    80002a54:	a039                	j	80002a62 <setpriority+0x4e>
      p->priority = priority;
    80002a56:	0344aa23          	sw	s4,52(s1)
      release(&p->lock);
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	ae2fe0ef          	jal	80000d3e <release>
      return 0;
    80002a60:	4501                	li	a0,0
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6a02                	ld	s4,0(sp)
    80002a6e:	6145                	addi	sp,sp,48
    80002a70:	8082                	ret

0000000080002a72 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002a72:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002a76:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002a7a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002a7c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002a7e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002a82:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002a86:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002a8a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002a8e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002a92:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002a96:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002a9a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002a9e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002aa2:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002aa6:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002aaa:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002aae:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002ab0:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002ab2:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002ab6:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002aba:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002abe:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002ac2:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002ac6:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002aca:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002ace:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002ad2:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002ad6:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002ada:	8082                	ret

0000000080002adc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002adc:	1141                	addi	sp,sp,-16
    80002ade:	e406                	sd	ra,8(sp)
    80002ae0:	e022                	sd	s0,0(sp)
    80002ae2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002ae4:	00005597          	auipc	a1,0x5
    80002ae8:	79c58593          	addi	a1,a1,1948 # 80008280 <etext+0x280>
    80002aec:	00242517          	auipc	a0,0x242
    80002af0:	f2c50513          	addi	a0,a0,-212 # 80244a18 <tickslock>
    80002af4:	948fe0ef          	jal	80000c3c <initlock>
}
    80002af8:	60a2                	ld	ra,8(sp)
    80002afa:	6402                	ld	s0,0(sp)
    80002afc:	0141                	addi	sp,sp,16
    80002afe:	8082                	ret

0000000080002b00 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002b00:	1141                	addi	sp,sp,-16
    80002b02:	e406                	sd	ra,8(sp)
    80002b04:	e022                	sd	s0,0(sp)
    80002b06:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b08:	00003797          	auipc	a5,0x3
    80002b0c:	40878793          	addi	a5,a5,1032 # 80005f10 <kernelvec>
    80002b10:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002b14:	60a2                	ld	ra,8(sp)
    80002b16:	6402                	ld	s0,0(sp)
    80002b18:	0141                	addi	sp,sp,16
    80002b1a:	8082                	ret

0000000080002b1c <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002b1c:	1141                	addi	sp,sp,-16
    80002b1e:	e406                	sd	ra,8(sp)
    80002b20:	e022                	sd	s0,0(sp)
    80002b22:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002b24:	b72ff0ef          	jal	80001e96 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002b28:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002b2c:	04000737          	lui	a4,0x4000
    80002b30:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002b32:	0732                	slli	a4,a4,0xc
    80002b34:	00004797          	auipc	a5,0x4
    80002b38:	4cc78793          	addi	a5,a5,1228 # 80007000 <_trampoline>
    80002b3c:	00004697          	auipc	a3,0x4
    80002b40:	4c468693          	addi	a3,a3,1220 # 80007000 <_trampoline>
    80002b44:	8f95                	sub	a5,a5,a3
    80002b46:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002b48:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002b4c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002b4e:	18002773          	csrr	a4,satp
    80002b52:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002b54:	7138                	ld	a4,96(a0)
    80002b56:	653c                	ld	a5,72(a0)
    80002b58:	6685                	lui	a3,0x1
    80002b5a:	97b6                	add	a5,a5,a3
    80002b5c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002b5e:	713c                	ld	a5,96(a0)
    80002b60:	00000717          	auipc	a4,0x0
    80002b64:	0f870713          	addi	a4,a4,248 # 80002c58 <usertrap>
    80002b68:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002b6a:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    80002b6c:	8712                	mv	a4,tp
    80002b6e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002b70:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002b74:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002b78:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002b7c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002b80:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002b82:	6f9c                	ld	a5,24(a5)
    80002b84:	14179073          	csrw	sepc,a5
}
    80002b88:	60a2                	ld	ra,8(sp)
    80002b8a:	6402                	ld	s0,0(sp)
    80002b8c:	0141                	addi	sp,sp,16
    80002b8e:	8082                	ret

0000000080002b90 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002b90:	1101                	addi	sp,sp,-32
    80002b92:	ec06                	sd	ra,24(sp)
    80002b94:	e822                	sd	s0,16(sp)
    80002b96:	1000                	addi	s0,sp,32
  if (cpuid() == 0) {
    80002b98:	acaff0ef          	jal	80001e62 <cpuid>
    80002b9c:	cd11                	beqz	a0,80002bb8 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80002b9e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002ba2:	000f4737          	lui	a4,0xf4
    80002ba6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002baa:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    80002bac:	14d79073          	csrw	stimecmp,a5
}
    80002bb0:	60e2                	ld	ra,24(sp)
    80002bb2:	6442                	ld	s0,16(sp)
    80002bb4:	6105                	addi	sp,sp,32
    80002bb6:	8082                	ret
    80002bb8:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002bba:	00242497          	auipc	s1,0x242
    80002bbe:	e5e48493          	addi	s1,s1,-418 # 80244a18 <tickslock>
    80002bc2:	8526                	mv	a0,s1
    80002bc4:	8f2fe0ef          	jal	80000cb6 <acquire>
    ticks++;
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	ce850513          	addi	a0,a0,-792 # 800088b0 <ticks>
    80002bd0:	411c                	lw	a5,0(a0)
    80002bd2:	2785                	addiw	a5,a5,1
    80002bd4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002bd6:	9cdff0ef          	jal	800025a2 <wakeup>
    release(&tickslock);
    80002bda:	8526                	mv	a0,s1
    80002bdc:	962fe0ef          	jal	80000d3e <release>
    80002be0:	64a2                	ld	s1,8(sp)
    80002be2:	bf75                	j	80002b9e <clockintr+0xe>

0000000080002be4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002be4:	1101                	addi	sp,sp,-32
    80002be6:	ec06                	sd	ra,24(sp)
    80002be8:	e822                	sd	s0,16(sp)
    80002bea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002bec:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002bf0:	57fd                	li	a5,-1
    80002bf2:	17fe                	slli	a5,a5,0x3f
    80002bf4:	07a5                	addi	a5,a5,9
    80002bf6:	00f70c63          	beq	a4,a5,80002c0e <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002bfa:	57fd                	li	a5,-1
    80002bfc:	17fe                	slli	a5,a5,0x3f
    80002bfe:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002c00:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80002c02:	04f70763          	beq	a4,a5,80002c50 <devintr+0x6c>
  }
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	6105                	addi	sp,sp,32
    80002c0c:	8082                	ret
    80002c0e:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002c10:	3ac030ef          	jal	80005fbc <plic_claim>
    80002c14:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002c16:	47a9                	li	a5,10
    80002c18:	00f50963          	beq	a0,a5,80002c2a <devintr+0x46>
    } else if (irq == VIRTIO0_IRQ) {
    80002c1c:	4785                	li	a5,1
    80002c1e:	00f50963          	beq	a0,a5,80002c30 <devintr+0x4c>
    return 1;
    80002c22:	4505                	li	a0,1
    } else if (irq) {
    80002c24:	e889                	bnez	s1,80002c36 <devintr+0x52>
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	bff9                	j	80002c06 <devintr+0x22>
      uartintr();
    80002c2a:	d5ffd0ef          	jal	80000988 <uartintr>
    if (irq)
    80002c2e:	a819                	j	80002c44 <devintr+0x60>
      virtio_disk_intr();
    80002c30:	03b030ef          	jal	8000646a <virtio_disk_intr>
    if (irq)
    80002c34:	a801                	j	80002c44 <devintr+0x60>
      printk("unexpected interrupt irq=%d\n", irq);
    80002c36:	85a6                	mv	a1,s1
    80002c38:	00005517          	auipc	a0,0x5
    80002c3c:	65050513          	addi	a0,a0,1616 # 80008288 <etext+0x288>
    80002c40:	8cbfd0ef          	jal	8000050a <printk>
      plic_complete(irq);
    80002c44:	8526                	mv	a0,s1
    80002c46:	396030ef          	jal	80005fdc <plic_complete>
    return 1;
    80002c4a:	4505                	li	a0,1
    80002c4c:	64a2                	ld	s1,8(sp)
    80002c4e:	bf65                	j	80002c06 <devintr+0x22>
    clockintr();
    80002c50:	f41ff0ef          	jal	80002b90 <clockintr>
    return 2;
    80002c54:	4509                	li	a0,2
    80002c56:	bf45                	j	80002c06 <devintr+0x22>

0000000080002c58 <usertrap>:
{
    80002c58:	1101                	addi	sp,sp,-32
    80002c5a:	ec06                	sd	ra,24(sp)
    80002c5c:	e822                	sd	s0,16(sp)
    80002c5e:	e426                	sd	s1,8(sp)
    80002c60:	e04a                	sd	s2,0(sp)
    80002c62:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002c64:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002c68:	1007f793          	andi	a5,a5,256
    80002c6c:	ebc1                	bnez	a5,80002cfc <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002c6e:	00003797          	auipc	a5,0x3
    80002c72:	2a278793          	addi	a5,a5,674 # 80005f10 <kernelvec>
    80002c76:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002c7a:	a1cff0ef          	jal	80001e96 <myproc>
    80002c7e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002c80:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002c82:	14102773          	csrr	a4,sepc
    80002c86:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002c88:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002c8c:	47a1                	li	a5,8
    80002c8e:	06f70d63          	beq	a4,a5,80002d08 <usertrap+0xb0>
  } else if ((which_dev = devintr()) != 0) {
    80002c92:	f53ff0ef          	jal	80002be4 <devintr>
    80002c96:	892a                	mv	s2,a0
    80002c98:	0e051863          	bnez	a0,80002d88 <usertrap+0x130>
    80002c9c:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15 &&
    80002ca0:	47bd                	li	a5,15
    80002ca2:	0af70363          	beq	a4,a5,80002d48 <usertrap+0xf0>
    80002ca6:	14202773          	csrr	a4,scause
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80002caa:	47bd                	li	a5,15
    80002cac:	0af70563          	beq	a4,a5,80002d56 <usertrap+0xfe>
    80002cb0:	14202773          	csrr	a4,scause
    80002cb4:	47b5                	li	a5,13
    80002cb6:	0af70063          	beq	a4,a5,80002d56 <usertrap+0xfe>
    80002cba:	14202773          	csrr	a4,scause
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80002cbe:	47bd                	li	a5,15
    80002cc0:	0af70763          	beq	a4,a5,80002d6e <usertrap+0x116>
    80002cc4:	14202773          	csrr	a4,scause
    80002cc8:	47b5                	li	a5,13
    80002cca:	0af70263          	beq	a4,a5,80002d6e <usertrap+0x116>
    80002cce:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002cd2:	5890                	lw	a2,48(s1)
    80002cd4:	00005517          	auipc	a0,0x5
    80002cd8:	5f450513          	addi	a0,a0,1524 # 800082c8 <etext+0x2c8>
    80002cdc:	82ffd0ef          	jal	8000050a <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002ce0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002ce4:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	61050513          	addi	a0,a0,1552 # 800082f8 <etext+0x2f8>
    80002cf0:	81bfd0ef          	jal	8000050a <printk>
    setkilled(p);
    80002cf4:	8526                	mv	a0,s1
    80002cf6:	a83ff0ef          	jal	80002778 <setkilled>
    80002cfa:	a015                	j	80002d1e <usertrap+0xc6>
    panic("usertrap: not from user mode");
    80002cfc:	00005517          	auipc	a0,0x5
    80002d00:	5ac50513          	addi	a0,a0,1452 # 800082a8 <etext+0x2a8>
    80002d04:	aebfd0ef          	jal	800007ee <panic>
    if (killed(p))
    80002d08:	a95ff0ef          	jal	8000279c <killed>
    80002d0c:	e915                	bnez	a0,80002d40 <usertrap+0xe8>
    p->trapframe->epc += 4;
    80002d0e:	70b8                	ld	a4,96(s1)
    80002d10:	6f1c                	ld	a5,24(a4)
    80002d12:	0791                	addi	a5,a5,4
    80002d14:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80002d16:	10016073          	csrsi	sstatus,2
    syscall();
    80002d1a:	278000ef          	jal	80002f92 <syscall>
  if (killed(p))
    80002d1e:	8526                	mv	a0,s1
    80002d20:	a7dff0ef          	jal	8000279c <killed>
    80002d24:	e53d                	bnez	a0,80002d92 <usertrap+0x13a>
  prepare_return();
    80002d26:	df7ff0ef          	jal	80002b1c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002d2a:	6ca8                	ld	a0,88(s1)
    80002d2c:	8131                	srli	a0,a0,0xc
    80002d2e:	57fd                	li	a5,-1
    80002d30:	17fe                	slli	a5,a5,0x3f
    80002d32:	8d5d                	or	a0,a0,a5
}
    80002d34:	60e2                	ld	ra,24(sp)
    80002d36:	6442                	ld	s0,16(sp)
    80002d38:	64a2                	ld	s1,8(sp)
    80002d3a:	6902                	ld	s2,0(sp)
    80002d3c:	6105                	addi	sp,sp,32
    80002d3e:	8082                	ret
      kexit(-1);
    80002d40:	557d                	li	a0,-1
    80002d42:	91dff0ef          	jal	8000265e <kexit>
    80002d46:	b7e1                	j	80002d0e <usertrap+0xb6>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d48:	143025f3          	csrr	a1,stval
           cowalloc(p->pagetable, r_stval()) != 0) {
    80002d4c:	6ca8                	ld	a0,88(s1)
    80002d4e:	9a1fe0ef          	jal	800016ee <cowalloc>
  } else if (r_scause() == 15 &&
    80002d52:	f571                	bnez	a0,80002d1e <usertrap+0xc6>
    80002d54:	bf89                	j	80002ca6 <usertrap+0x4e>
    80002d56:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d5a:	14202673          	csrr	a2,scause
           mmapfault(p->pagetable, r_stval(),
    80002d5e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002d60:	00163613          	seqz	a2,a2
    80002d64:	6ca8                	ld	a0,88(s1)
    80002d66:	a5bfe0ef          	jal	800017c0 <mmapfault>
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80002d6a:	f955                	bnez	a0,80002d1e <usertrap+0xc6>
    80002d6c:	b7b9                	j	80002cba <usertrap+0x62>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002d6e:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002d72:	142026f3          	csrr	a3,scause
           vmfault(p->pagetable, p->sz, r_stval(),
    80002d76:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002d78:	0016b693          	seqz	a3,a3
    80002d7c:	68ac                	ld	a1,80(s1)
    80002d7e:	6ca8                	ld	a0,88(s1)
    80002d80:	839fe0ef          	jal	800015b8 <vmfault>
} else if ((r_scause() == 15 || r_scause() == 13) &&
    80002d84:	fd49                	bnez	a0,80002d1e <usertrap+0xc6>
    80002d86:	b7a1                	j	80002cce <usertrap+0x76>
  if (killed(p))
    80002d88:	8526                	mv	a0,s1
    80002d8a:	a13ff0ef          	jal	8000279c <killed>
    80002d8e:	c511                	beqz	a0,80002d9a <usertrap+0x142>
    80002d90:	a011                	j	80002d94 <usertrap+0x13c>
    80002d92:	4901                	li	s2,0
    kexit(-1);
    80002d94:	557d                	li	a0,-1
    80002d96:	8c9ff0ef          	jal	8000265e <kexit>
if (which_dev == 2){
    80002d9a:	4789                	li	a5,2
    80002d9c:	f8f915e3          	bne	s2,a5,80002d26 <usertrap+0xce>
  p->cpu_time++;
    80002da0:	7c9c                	ld	a5,56(s1)
    80002da2:	0785                	addi	a5,a5,1
    80002da4:	fc9c                	sd	a5,56(s1)
  yield();
    80002da6:	f64ff0ef          	jal	8000250a <yield>
    80002daa:	bfb5                	j	80002d26 <usertrap+0xce>

0000000080002dac <kerneltrap>:
{
    80002dac:	7179                	addi	sp,sp,-48
    80002dae:	f406                	sd	ra,40(sp)
    80002db0:	f022                	sd	s0,32(sp)
    80002db2:	ec26                	sd	s1,24(sp)
    80002db4:	e84a                	sd	s2,16(sp)
    80002db6:	e44e                	sd	s3,8(sp)
    80002db8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002dba:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002dbe:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002dc2:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002dc6:	1004f793          	andi	a5,s1,256
    80002dca:	c795                	beqz	a5,80002df6 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002dcc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002dd0:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002dd2:	eb85                	bnez	a5,80002e02 <kerneltrap+0x56>
  if ((which_dev = devintr()) == 0) {
    80002dd4:	e11ff0ef          	jal	80002be4 <devintr>
    80002dd8:	c91d                	beqz	a0,80002e0e <kerneltrap+0x62>
if (which_dev == 2 && myproc() != 0){
    80002dda:	4789                	li	a5,2
    80002ddc:	04f50a63          	beq	a0,a5,80002e30 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002de0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002de4:	10049073          	csrw	sstatus,s1
}
    80002de8:	70a2                	ld	ra,40(sp)
    80002dea:	7402                	ld	s0,32(sp)
    80002dec:	64e2                	ld	s1,24(sp)
    80002dee:	6942                	ld	s2,16(sp)
    80002df0:	69a2                	ld	s3,8(sp)
    80002df2:	6145                	addi	sp,sp,48
    80002df4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002df6:	00005517          	auipc	a0,0x5
    80002dfa:	52a50513          	addi	a0,a0,1322 # 80008320 <etext+0x320>
    80002dfe:	9f1fd0ef          	jal	800007ee <panic>
    panic("kerneltrap: interrupts enabled");
    80002e02:	00005517          	auipc	a0,0x5
    80002e06:	54650513          	addi	a0,a0,1350 # 80008348 <etext+0x348>
    80002e0a:	9e5fd0ef          	jal	800007ee <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002e0e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    80002e12:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    80002e16:	85ce                	mv	a1,s3
    80002e18:	00005517          	auipc	a0,0x5
    80002e1c:	55050513          	addi	a0,a0,1360 # 80008368 <etext+0x368>
    80002e20:	eeafd0ef          	jal	8000050a <printk>
    panic("kerneltrap");
    80002e24:	00005517          	auipc	a0,0x5
    80002e28:	56c50513          	addi	a0,a0,1388 # 80008390 <etext+0x390>
    80002e2c:	9c3fd0ef          	jal	800007ee <panic>
if (which_dev == 2 && myproc() != 0){
    80002e30:	866ff0ef          	jal	80001e96 <myproc>
    80002e34:	d555                	beqz	a0,80002de0 <kerneltrap+0x34>
  myproc()->cpu_time++;
    80002e36:	860ff0ef          	jal	80001e96 <myproc>
    80002e3a:	7d1c                	ld	a5,56(a0)
    80002e3c:	0785                	addi	a5,a5,1
    80002e3e:	fd1c                	sd	a5,56(a0)
  yield();
    80002e40:	ecaff0ef          	jal	8000250a <yield>
    80002e44:	bf71                	j	80002de0 <kerneltrap+0x34>

0000000080002e46 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002e46:	1101                	addi	sp,sp,-32
    80002e48:	ec06                	sd	ra,24(sp)
    80002e4a:	e822                	sd	s0,16(sp)
    80002e4c:	e426                	sd	s1,8(sp)
    80002e4e:	1000                	addi	s0,sp,32
    80002e50:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002e52:	844ff0ef          	jal	80001e96 <myproc>
  switch (n) {
    80002e56:	4795                	li	a5,5
    80002e58:	0497e163          	bltu	a5,s1,80002e9a <argraw+0x54>
    80002e5c:	048a                	slli	s1,s1,0x2
    80002e5e:	00006717          	auipc	a4,0x6
    80002e62:	93270713          	addi	a4,a4,-1742 # 80008790 <states.0+0x30>
    80002e66:	94ba                	add	s1,s1,a4
    80002e68:	409c                	lw	a5,0(s1)
    80002e6a:	97ba                	add	a5,a5,a4
    80002e6c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002e6e:	713c                	ld	a5,96(a0)
    80002e70:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6105                	addi	sp,sp,32
    80002e7a:	8082                	ret
    return p->trapframe->a1;
    80002e7c:	713c                	ld	a5,96(a0)
    80002e7e:	7fa8                	ld	a0,120(a5)
    80002e80:	bfcd                	j	80002e72 <argraw+0x2c>
    return p->trapframe->a2;
    80002e82:	713c                	ld	a5,96(a0)
    80002e84:	63c8                	ld	a0,128(a5)
    80002e86:	b7f5                	j	80002e72 <argraw+0x2c>
    return p->trapframe->a3;
    80002e88:	713c                	ld	a5,96(a0)
    80002e8a:	67c8                	ld	a0,136(a5)
    80002e8c:	b7dd                	j	80002e72 <argraw+0x2c>
    return p->trapframe->a4;
    80002e8e:	713c                	ld	a5,96(a0)
    80002e90:	6bc8                	ld	a0,144(a5)
    80002e92:	b7c5                	j	80002e72 <argraw+0x2c>
    return p->trapframe->a5;
    80002e94:	713c                	ld	a5,96(a0)
    80002e96:	6fc8                	ld	a0,152(a5)
    80002e98:	bfe9                	j	80002e72 <argraw+0x2c>
  panic("argraw");
    80002e9a:	00005517          	auipc	a0,0x5
    80002e9e:	50650513          	addi	a0,a0,1286 # 800083a0 <etext+0x3a0>
    80002ea2:	94dfd0ef          	jal	800007ee <panic>

0000000080002ea6 <fetchaddr>:
{
    80002ea6:	1101                	addi	sp,sp,-32
    80002ea8:	ec06                	sd	ra,24(sp)
    80002eaa:	e822                	sd	s0,16(sp)
    80002eac:	e426                	sd	s1,8(sp)
    80002eae:	e04a                	sd	s2,0(sp)
    80002eb0:	1000                	addi	s0,sp,32
    80002eb2:	84aa                	mv	s1,a0
    80002eb4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002eb6:	fe1fe0ef          	jal	80001e96 <myproc>
  if (addr >= p->sz ||
    80002eba:	692c                	ld	a1,80(a0)
    80002ebc:	02b4f663          	bgeu	s1,a1,80002ee8 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002ec0:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    80002ec4:	02f5e463          	bltu	a1,a5,80002eec <fetchaddr+0x46>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    80002ec8:	4721                	li	a4,8
    80002eca:	86a6                	mv	a3,s1
    80002ecc:	864a                	mv	a2,s2
    80002ece:	6d28                	ld	a0,88(a0)
    80002ed0:	b57fe0ef          	jal	80001a26 <copyin>
    80002ed4:	00a03533          	snez	a0,a0
    80002ed8:	40a0053b          	negw	a0,a0
}
    80002edc:	60e2                	ld	ra,24(sp)
    80002ede:	6442                	ld	s0,16(sp)
    80002ee0:	64a2                	ld	s1,8(sp)
    80002ee2:	6902                	ld	s2,0(sp)
    80002ee4:	6105                	addi	sp,sp,32
    80002ee6:	8082                	ret
    return -1;
    80002ee8:	557d                	li	a0,-1
    80002eea:	bfcd                	j	80002edc <fetchaddr+0x36>
    80002eec:	557d                	li	a0,-1
    80002eee:	b7fd                	j	80002edc <fetchaddr+0x36>

0000000080002ef0 <fetchstr>:
{
    80002ef0:	7179                	addi	sp,sp,-48
    80002ef2:	f406                	sd	ra,40(sp)
    80002ef4:	f022                	sd	s0,32(sp)
    80002ef6:	ec26                	sd	s1,24(sp)
    80002ef8:	e84a                	sd	s2,16(sp)
    80002efa:	e44e                	sd	s3,8(sp)
    80002efc:	1800                	addi	s0,sp,48
    80002efe:	892a                	mv	s2,a0
    80002f00:	84ae                	mv	s1,a1
    80002f02:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002f04:	f93fe0ef          	jal	80001e96 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    80002f08:	874e                	mv	a4,s3
    80002f0a:	86ca                	mv	a3,s2
    80002f0c:	8626                	mv	a2,s1
    80002f0e:	692c                	ld	a1,80(a0)
    80002f10:	6d28                	ld	a0,88(a0)
    80002f12:	f22fe0ef          	jal	80001634 <copyinstr>
    80002f16:	00054c63          	bltz	a0,80002f2e <fetchstr+0x3e>
  return strlen(buf);
    80002f1a:	8526                	mv	a0,s1
    80002f1c:	fe3fd0ef          	jal	80000efe <strlen>
}
    80002f20:	70a2                	ld	ra,40(sp)
    80002f22:	7402                	ld	s0,32(sp)
    80002f24:	64e2                	ld	s1,24(sp)
    80002f26:	6942                	ld	s2,16(sp)
    80002f28:	69a2                	ld	s3,8(sp)
    80002f2a:	6145                	addi	sp,sp,48
    80002f2c:	8082                	ret
    return -1;
    80002f2e:	557d                	li	a0,-1
    80002f30:	bfc5                	j	80002f20 <fetchstr+0x30>

0000000080002f32 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	1000                	addi	s0,sp,32
    80002f3c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f3e:	f09ff0ef          	jal	80002e46 <argraw>
    80002f42:	c088                	sw	a0,0(s1)
}
    80002f44:	60e2                	ld	ra,24(sp)
    80002f46:	6442                	ld	s0,16(sp)
    80002f48:	64a2                	ld	s1,8(sp)
    80002f4a:	6105                	addi	sp,sp,32
    80002f4c:	8082                	ret

0000000080002f4e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	e426                	sd	s1,8(sp)
    80002f56:	1000                	addi	s0,sp,32
    80002f58:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002f5a:	eedff0ef          	jal	80002e46 <argraw>
    80002f5e:	e088                	sd	a0,0(s1)
}
    80002f60:	60e2                	ld	ra,24(sp)
    80002f62:	6442                	ld	s0,16(sp)
    80002f64:	64a2                	ld	s1,8(sp)
    80002f66:	6105                	addi	sp,sp,32
    80002f68:	8082                	ret

0000000080002f6a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002f6a:	1101                	addi	sp,sp,-32
    80002f6c:	ec06                	sd	ra,24(sp)
    80002f6e:	e822                	sd	s0,16(sp)
    80002f70:	e426                	sd	s1,8(sp)
    80002f72:	e04a                	sd	s2,0(sp)
    80002f74:	1000                	addi	s0,sp,32
    80002f76:	84ae                	mv	s1,a1
    80002f78:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002f7a:	ecdff0ef          	jal	80002e46 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002f7e:	864a                	mv	a2,s2
    80002f80:	85a6                	mv	a1,s1
    80002f82:	f6fff0ef          	jal	80002ef0 <fetchstr>
}
    80002f86:	60e2                	ld	ra,24(sp)
    80002f88:	6442                	ld	s0,16(sp)
    80002f8a:	64a2                	ld	s1,8(sp)
    80002f8c:	6902                	ld	s2,0(sp)
    80002f8e:	6105                	addi	sp,sp,32
    80002f90:	8082                	ret

0000000080002f92 <syscall>:
  // clang-format on
};

void
syscall(void)
{
    80002f92:	1101                	addi	sp,sp,-32
    80002f94:	ec06                	sd	ra,24(sp)
    80002f96:	e822                	sd	s0,16(sp)
    80002f98:	e426                	sd	s1,8(sp)
    80002f9a:	e04a                	sd	s2,0(sp)
    80002f9c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002f9e:	ef9fe0ef          	jal	80001e96 <myproc>
    80002fa2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002fa4:	06053903          	ld	s2,96(a0)
    80002fa8:	0a893783          	ld	a5,168(s2)
    80002fac:	0007869b          	sext.w	a3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002fb0:	37fd                	addiw	a5,a5,-1
    80002fb2:	4765                	li	a4,25
    80002fb4:	00f76f63          	bltu	a4,a5,80002fd2 <syscall+0x40>
    80002fb8:	00369713          	slli	a4,a3,0x3
    80002fbc:	00005797          	auipc	a5,0x5
    80002fc0:	7ec78793          	addi	a5,a5,2028 # 800087a8 <syscalls>
    80002fc4:	97ba                	add	a5,a5,a4
    80002fc6:	639c                	ld	a5,0(a5)
    80002fc8:	c789                	beqz	a5,80002fd2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002fca:	9782                	jalr	a5
    80002fcc:	06a93823          	sd	a0,112(s2)
    80002fd0:	a829                	j	80002fea <syscall+0x58>
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002fd2:	4e048613          	addi	a2,s1,1248
    80002fd6:	588c                	lw	a1,48(s1)
    80002fd8:	00005517          	auipc	a0,0x5
    80002fdc:	3d050513          	addi	a0,a0,976 # 800083a8 <etext+0x3a8>
    80002fe0:	d2afd0ef          	jal	8000050a <printk>
    p->trapframe->a0 = -1;
    80002fe4:	70bc                	ld	a5,96(s1)
    80002fe6:	577d                	li	a4,-1
    80002fe8:	fbb8                	sd	a4,112(a5)
  }
}
    80002fea:	60e2                	ld	ra,24(sp)
    80002fec:	6442                	ld	s0,16(sp)
    80002fee:	64a2                	ld	s1,8(sp)
    80002ff0:	6902                	ld	s2,0(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <sys_exit>:
#include "vm.h"


uint64
sys_exit(void)
{
    80002ff6:	1101                	addi	sp,sp,-32
    80002ff8:	ec06                	sd	ra,24(sp)
    80002ffa:	e822                	sd	s0,16(sp)
    80002ffc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002ffe:	fec40593          	addi	a1,s0,-20
    80003002:	4501                	li	a0,0
    80003004:	f2fff0ef          	jal	80002f32 <argint>
  kexit(n);
    80003008:	fec42503          	lw	a0,-20(s0)
    8000300c:	e52ff0ef          	jal	8000265e <kexit>
  return 0; // not reached
}
    80003010:	4501                	li	a0,0
    80003012:	60e2                	ld	ra,24(sp)
    80003014:	6442                	ld	s0,16(sp)
    80003016:	6105                	addi	sp,sp,32
    80003018:	8082                	ret

000000008000301a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000301a:	1141                	addi	sp,sp,-16
    8000301c:	e406                	sd	ra,8(sp)
    8000301e:	e022                	sd	s0,0(sp)
    80003020:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003022:	e75fe0ef          	jal	80001e96 <myproc>
}
    80003026:	5908                	lw	a0,48(a0)
    80003028:	60a2                	ld	ra,8(sp)
    8000302a:	6402                	ld	s0,0(sp)
    8000302c:	0141                	addi	sp,sp,16
    8000302e:	8082                	ret

0000000080003030 <sys_fork>:

uint64
sys_fork(void)
{
    80003030:	1141                	addi	sp,sp,-16
    80003032:	e406                	sd	ra,8(sp)
    80003034:	e022                	sd	s0,0(sp)
    80003036:	0800                	addi	s0,sp,16
  return kfork();
    80003038:	9f0ff0ef          	jal	80002228 <kfork>
}
    8000303c:	60a2                	ld	ra,8(sp)
    8000303e:	6402                	ld	s0,0(sp)
    80003040:	0141                	addi	sp,sp,16
    80003042:	8082                	ret

0000000080003044 <sys_wait>:

uint64
sys_wait(void)
{
    80003044:	1101                	addi	sp,sp,-32
    80003046:	ec06                	sd	ra,24(sp)
    80003048:	e822                	sd	s0,16(sp)
    8000304a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000304c:	fe840593          	addi	a1,s0,-24
    80003050:	4501                	li	a0,0
    80003052:	efdff0ef          	jal	80002f4e <argaddr>
  return kwait(p);
    80003056:	fe843503          	ld	a0,-24(s0)
    8000305a:	f6cff0ef          	jal	800027c6 <kwait>
}
    8000305e:	60e2                	ld	ra,24(sp)
    80003060:	6442                	ld	s0,16(sp)
    80003062:	6105                	addi	sp,sp,32
    80003064:	8082                	ret

0000000080003066 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003066:	7179                	addi	sp,sp,-48
    80003068:	f406                	sd	ra,40(sp)
    8000306a:	f022                	sd	s0,32(sp)
    8000306c:	ec26                	sd	s1,24(sp)
    8000306e:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80003070:	fd840593          	addi	a1,s0,-40
    80003074:	4501                	li	a0,0
    80003076:	ebdff0ef          	jal	80002f32 <argint>
  argint(1, &t);
    8000307a:	fdc40593          	addi	a1,s0,-36
    8000307e:	4505                	li	a0,1
    80003080:	eb3ff0ef          	jal	80002f32 <argint>
  addr = myproc()->sz;
    80003084:	e13fe0ef          	jal	80001e96 <myproc>
    80003088:	6924                	ld	s1,80(a0)

  if (t == SBRK_EAGER || n < 0) {
    8000308a:	fdc42703          	lw	a4,-36(s0)
    8000308e:	4785                	li	a5,1
    80003090:	02f70763          	beq	a4,a5,800030be <sys_sbrk+0x58>
    80003094:	fd842783          	lw	a5,-40(s0)
    80003098:	0207c363          	bltz	a5,800030be <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    8000309c:	97a6                	add	a5,a5,s1
    8000309e:	0297ee63          	bltu	a5,s1,800030da <sys_sbrk+0x74>
      return -1;
    if (addr + n > TRAPFRAME)
    800030a2:	02000737          	lui	a4,0x2000
    800030a6:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    800030a8:	0736                	slli	a4,a4,0xd
    800030aa:	02f76a63          	bltu	a4,a5,800030de <sys_sbrk+0x78>
      return -1;
    myproc()->sz += n;
    800030ae:	de9fe0ef          	jal	80001e96 <myproc>
    800030b2:	fd842703          	lw	a4,-40(s0)
    800030b6:	693c                	ld	a5,80(a0)
    800030b8:	97ba                	add	a5,a5,a4
    800030ba:	e93c                	sd	a5,80(a0)
    800030bc:	a039                	j	800030ca <sys_sbrk+0x64>
    if (growproc(n) < 0) {
    800030be:	fd842503          	lw	a0,-40(s0)
    800030c2:	904ff0ef          	jal	800021c6 <growproc>
    800030c6:	00054863          	bltz	a0,800030d6 <sys_sbrk+0x70>
  }
  return addr;
}
    800030ca:	8526                	mv	a0,s1
    800030cc:	70a2                	ld	ra,40(sp)
    800030ce:	7402                	ld	s0,32(sp)
    800030d0:	64e2                	ld	s1,24(sp)
    800030d2:	6145                	addi	sp,sp,48
    800030d4:	8082                	ret
      return -1;
    800030d6:	54fd                	li	s1,-1
    800030d8:	bfcd                	j	800030ca <sys_sbrk+0x64>
      return -1;
    800030da:	54fd                	li	s1,-1
    800030dc:	b7fd                	j	800030ca <sys_sbrk+0x64>
      return -1;
    800030de:	54fd                	li	s1,-1
    800030e0:	b7ed                	j	800030ca <sys_sbrk+0x64>

00000000800030e2 <sys_pause>:

uint64
sys_pause(void)
{
    800030e2:	7139                	addi	sp,sp,-64
    800030e4:	fc06                	sd	ra,56(sp)
    800030e6:	f822                	sd	s0,48(sp)
    800030e8:	ec4e                	sd	s3,24(sp)
    800030ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800030ec:	fcc40593          	addi	a1,s0,-52
    800030f0:	4501                	li	a0,0
    800030f2:	e41ff0ef          	jal	80002f32 <argint>
  if (n < 0)
    800030f6:	fcc42783          	lw	a5,-52(s0)
    800030fa:	0607cf63          	bltz	a5,80003178 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    800030fe:	00242517          	auipc	a0,0x242
    80003102:	91a50513          	addi	a0,a0,-1766 # 80244a18 <tickslock>
    80003106:	bb1fd0ef          	jal	80000cb6 <acquire>
  ticks0 = ticks;
    8000310a:	00005997          	auipc	s3,0x5
    8000310e:	7a69a983          	lw	s3,1958(s3) # 800088b0 <ticks>
  while (ticks - ticks0 < n) {
    80003112:	fcc42783          	lw	a5,-52(s0)
    80003116:	c7a9                	beqz	a5,80003160 <sys_pause+0x7e>
    80003118:	f426                	sd	s1,40(sp)
    8000311a:	f04a                	sd	s2,32(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    8000311c:	00005917          	auipc	s2,0x5
    80003120:	79490913          	addi	s2,s2,1940 # 800088b0 <ticks>
    release(&tickslock);
    80003124:	00242497          	auipc	s1,0x242
    80003128:	8f448493          	addi	s1,s1,-1804 # 80244a18 <tickslock>
    if (killed(myproc())) {
    8000312c:	d6bfe0ef          	jal	80001e96 <myproc>
    80003130:	e6cff0ef          	jal	8000279c <killed>
    80003134:	e529                	bnez	a0,8000317e <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80003136:	854a                	mv	a0,s2
    80003138:	bfeff0ef          	jal	80002536 <sleep_prepare>
    release(&tickslock);
    8000313c:	8526                	mv	a0,s1
    8000313e:	c01fd0ef          	jal	80000d3e <release>
    sleep();
    80003142:	c30ff0ef          	jal	80002572 <sleep>
    acquire(&tickslock);
    80003146:	8526                	mv	a0,s1
    80003148:	b6ffd0ef          	jal	80000cb6 <acquire>
  while (ticks - ticks0 < n) {
    8000314c:	00092783          	lw	a5,0(s2)
    80003150:	413787bb          	subw	a5,a5,s3
    80003154:	fcc42703          	lw	a4,-52(s0)
    80003158:	fce7eae3          	bltu	a5,a4,8000312c <sys_pause+0x4a>
    8000315c:	74a2                	ld	s1,40(sp)
    8000315e:	7902                	ld	s2,32(sp)
  }
  release(&tickslock);
    80003160:	00242517          	auipc	a0,0x242
    80003164:	8b850513          	addi	a0,a0,-1864 # 80244a18 <tickslock>
    80003168:	bd7fd0ef          	jal	80000d3e <release>
  return 0;
    8000316c:	4501                	li	a0,0
}
    8000316e:	70e2                	ld	ra,56(sp)
    80003170:	7442                	ld	s0,48(sp)
    80003172:	69e2                	ld	s3,24(sp)
    80003174:	6121                	addi	sp,sp,64
    80003176:	8082                	ret
    n = 0;
    80003178:	fc042623          	sw	zero,-52(s0)
    8000317c:	b749                	j	800030fe <sys_pause+0x1c>
      release(&tickslock);
    8000317e:	00242517          	auipc	a0,0x242
    80003182:	89a50513          	addi	a0,a0,-1894 # 80244a18 <tickslock>
    80003186:	bb9fd0ef          	jal	80000d3e <release>
      return -1;
    8000318a:	557d                	li	a0,-1
    8000318c:	74a2                	ld	s1,40(sp)
    8000318e:	7902                	ld	s2,32(sp)
    80003190:	bff9                	j	8000316e <sys_pause+0x8c>

0000000080003192 <sys_kill>:

uint64
sys_kill(void)
{
    80003192:	1101                	addi	sp,sp,-32
    80003194:	ec06                	sd	ra,24(sp)
    80003196:	e822                	sd	s0,16(sp)
    80003198:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000319a:	fec40593          	addi	a1,s0,-20
    8000319e:	4501                	li	a0,0
    800031a0:	d93ff0ef          	jal	80002f32 <argint>
  return kkill(pid);
    800031a4:	fec42503          	lw	a0,-20(s0)
    800031a8:	d64ff0ef          	jal	8000270c <kkill>
}
    800031ac:	60e2                	ld	ra,24(sp)
    800031ae:	6442                	ld	s0,16(sp)
    800031b0:	6105                	addi	sp,sp,32
    800031b2:	8082                	ret

00000000800031b4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800031b4:	1101                	addi	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	e426                	sd	s1,8(sp)
    800031bc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800031be:	00242517          	auipc	a0,0x242
    800031c2:	85a50513          	addi	a0,a0,-1958 # 80244a18 <tickslock>
    800031c6:	af1fd0ef          	jal	80000cb6 <acquire>
  xticks = ticks;
    800031ca:	00005497          	auipc	s1,0x5
    800031ce:	6e64a483          	lw	s1,1766(s1) # 800088b0 <ticks>
  release(&tickslock);
    800031d2:	00242517          	auipc	a0,0x242
    800031d6:	84650513          	addi	a0,a0,-1978 # 80244a18 <tickslock>
    800031da:	b65fd0ef          	jal	80000d3e <release>
  return xticks;
}
    800031de:	02049513          	slli	a0,s1,0x20
    800031e2:	9101                	srli	a0,a0,0x20
    800031e4:	60e2                	ld	ra,24(sp)
    800031e6:	6442                	ld	s0,16(sp)
    800031e8:	64a2                	ld	s1,8(sp)
    800031ea:	6105                	addi	sp,sp,32
    800031ec:	8082                	ret

00000000800031ee <sys_ps>:


uint64
sys_ps(void)
{
    800031ee:	1141                	addi	sp,sp,-16
    800031f0:	e406                	sd	ra,8(sp)
    800031f2:	e022                	sd	s0,0(sp)
    800031f4:	0800                	addi	s0,sp,16
  procdump();
    800031f6:	f72ff0ef          	jal	80002968 <procdump>
  return 0;
}
    800031fa:	4501                	li	a0,0
    800031fc:	60a2                	ld	ra,8(sp)
    800031fe:	6402                	ld	s0,0(sp)
    80003200:	0141                	addi	sp,sp,16
    80003202:	8082                	ret

0000000080003204 <sys_setpriority>:


uint64
sys_setpriority(void)
{
    80003204:	1101                	addi	sp,sp,-32
    80003206:	ec06                	sd	ra,24(sp)
    80003208:	e822                	sd	s0,16(sp)
    8000320a:	1000                	addi	s0,sp,32
  int pid;
  int priority;

  argint(0, &pid);
    8000320c:	fec40593          	addi	a1,s0,-20
    80003210:	4501                	li	a0,0
    80003212:	d21ff0ef          	jal	80002f32 <argint>
  argint(1, &priority);
    80003216:	fe840593          	addi	a1,s0,-24
    8000321a:	4505                	li	a0,1
    8000321c:	d17ff0ef          	jal	80002f32 <argint>

  if(priority < 1 || priority > 20)
    80003220:	fe842583          	lw	a1,-24(s0)
    80003224:	fff5871b          	addiw	a4,a1,-1
    80003228:	47cd                	li	a5,19
    return -1;
    8000322a:	557d                	li	a0,-1
  if(priority < 1 || priority > 20)
    8000322c:	00e7e663          	bltu	a5,a4,80003238 <sys_setpriority+0x34>

  return setpriority(pid, priority);
    80003230:	fec42503          	lw	a0,-20(s0)
    80003234:	fe0ff0ef          	jal	80002a14 <setpriority>
}
    80003238:	60e2                	ld	ra,24(sp)
    8000323a:	6442                	ld	s0,16(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret

0000000080003240 <mmap_find_addr>:

uint64
mmap_find_addr(struct proc *p, uint64 length)
{
    80003240:	1141                	addi	sp,sp,-16
    80003242:	e406                	sd	ra,8(sp)
    80003244:	e022                	sd	s0,0(sp)
    80003246:	0800                	addi	s0,sp,16
    80003248:	882a                	mv	a6,a0
  uint64 end;
  int i;

  end = TRAPFRAME;

  for(i = 0; i < NVMA; i++){
    8000324a:	16050793          	addi	a5,a0,352
    8000324e:	4e050613          	addi	a2,a0,1248
  end = TRAPFRAME;
    80003252:	020006b7          	lui	a3,0x2000
    80003256:	16fd                	addi	a3,a3,-1 # 1ffffff <_entry-0x7e000001>
    80003258:	06b6                	slli	a3,a3,0xd
    8000325a:	a029                	j	80003264 <mmap_find_addr+0x24>
  for(i = 0; i < NVMA; i++){
    8000325c:	03878793          	addi	a5,a5,56
    80003260:	00c78963          	beq	a5,a2,80003272 <mmap_find_addr+0x32>
    if(p->vmas[i].used){
    80003264:	4398                	lw	a4,0(a5)
    80003266:	db7d                	beqz	a4,8000325c <mmap_find_addr+0x1c>
      if(p->vmas[i].addr < end)
    80003268:	6798                	ld	a4,8(a5)
    8000326a:	fed779e3          	bgeu	a4,a3,8000325c <mmap_find_addr+0x1c>
    8000326e:	86ba                	mv	a3,a4
    80003270:	b7f5                	j	8000325c <mmap_find_addr+0x1c>
        end = p->vmas[i].addr;
    }
  }

  length = PGROUNDUP(length);
    80003272:	6785                	lui	a5,0x1
    80003274:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80003276:	97ae                	add	a5,a5,a1
    80003278:	777d                	lui	a4,0xfffff
    8000327a:	8ff9                	and	a5,a5,a4

  if(length > end)
    return 0;
    8000327c:	4501                	li	a0,0
  if(length > end)
    8000327e:	00f6e963          	bltu	a3,a5,80003290 <mmap_find_addr+0x50>

  addr = PGROUNDDOWN(end - length);
    80003282:	8e9d                	sub	a3,a3,a5
    80003284:	00e6f533          	and	a0,a3,a4

  if(addr < p->sz)
    80003288:	05083783          	ld	a5,80(a6)
    8000328c:	00f56663          	bltu	a0,a5,80003298 <mmap_find_addr+0x58>
    return 0;

  return addr;
}
    80003290:	60a2                	ld	ra,8(sp)
    80003292:	6402                	ld	s0,0(sp)
    80003294:	0141                	addi	sp,sp,16
    80003296:	8082                	ret
    return 0;
    80003298:	4501                	li	a0,0
    8000329a:	bfdd                	j	80003290 <mmap_find_addr+0x50>

000000008000329c <sys_mmap>:


uint64
sys_mmap(void)
{
    8000329c:	7119                	addi	sp,sp,-128
    8000329e:	fc86                	sd	ra,120(sp)
    800032a0:	f8a2                	sd	s0,112(sp)
    800032a2:	f0ca                	sd	s2,96(sp)
    800032a4:	ecce                	sd	s3,88(sp)
    800032a6:	0100                	addi	s0,sp,128
  uint64 offset;
  int prot;
  int flags;
  int fd;
  struct file *f;
  struct proc *p = myproc();
    800032a8:	beffe0ef          	jal	80001e96 <myproc>
    800032ac:	892a                	mv	s2,a0
  struct vma *vma;
  int i;

  argaddr(0, &addr);
    800032ae:	fa840593          	addi	a1,s0,-88
    800032b2:	4501                	li	a0,0
    800032b4:	c9bff0ef          	jal	80002f4e <argaddr>
  argaddr(1, &length);
    800032b8:	fa040593          	addi	a1,s0,-96
    800032bc:	4505                	li	a0,1
    800032be:	c91ff0ef          	jal	80002f4e <argaddr>
  argint(2, &prot);
    800032c2:	f9440593          	addi	a1,s0,-108
    800032c6:	4509                	li	a0,2
    800032c8:	c6bff0ef          	jal	80002f32 <argint>
  argint(3, &flags);
    800032cc:	f9040593          	addi	a1,s0,-112
    800032d0:	450d                	li	a0,3
    800032d2:	c61ff0ef          	jal	80002f32 <argint>
  argint(4, &fd);
    800032d6:	f8c40593          	addi	a1,s0,-116
    800032da:	4511                	li	a0,4
    800032dc:	c57ff0ef          	jal	80002f32 <argint>
  argaddr(5, &offset);
    800032e0:	f9840593          	addi	a1,s0,-104
    800032e4:	4515                	li	a0,5
    800032e6:	c69ff0ef          	jal	80002f4e <argaddr>

  if(length == 0)
    800032ea:	fa043983          	ld	s3,-96(s0)
    return -1;
    800032ee:	557d                	li	a0,-1
  if(length == 0)
    800032f0:	0e098963          	beqz	s3,800033e2 <sys_mmap+0x146>

  if(offset % PGSIZE != 0)
    800032f4:	f9843783          	ld	a5,-104(s0)
    800032f8:	17d2                	slli	a5,a5,0x34
    800032fa:	e7e5                	bnez	a5,800033e2 <sys_mmap+0x146>
    800032fc:	e8d2                	sd	s4,80(sp)
    return -1;

  if(prot & ~(PROT_READ | PROT_WRITE))
    800032fe:	f9442a03          	lw	s4,-108(s0)
    80003302:	478d                	li	a5,3
    80003304:	0d47eb63          	bltu	a5,s4,800033da <sys_mmap+0x13e>
    80003308:	e4d6                	sd	s5,72(sp)
    return -1;

  if(flags != MAP_SHARED && flags != MAP_PRIVATE)
    8000330a:	f9042a83          	lw	s5,-112(s0)
    8000330e:	fffa871b          	addiw	a4,s5,-1
    80003312:	4785                	li	a5,1
    80003314:	0ce7e563          	bltu	a5,a4,800033de <sys_mmap+0x142>
    return -1;

  if(fd < 0 || fd >= NOFILE)
    80003318:	f8c42783          	lw	a5,-116(s0)
    8000331c:	473d                	li	a4,15
    8000331e:	0cf76863          	bltu	a4,a5,800033ee <sys_mmap+0x152>
    80003322:	e0da                	sd	s6,64(sp)
    return -1;

  f = p->ofile[fd];
    80003324:	07e9                	addi	a5,a5,26
    80003326:	078e                	slli	a5,a5,0x3
    80003328:	97ca                	add	a5,a5,s2
    8000332a:	0087bb03          	ld	s6,8(a5)

  if(f == 0)
    8000332e:	020b0463          	beqz	s6,80003356 <sys_mmap+0xba>
    80003332:	f4a6                	sd	s1,104(sp)
    80003334:	16090793          	addi	a5,s2,352
    return -1;


  for(i = 0; i < NVMA; i++){
    80003338:	4481                	li	s1,0
    8000333a:	46c1                	li	a3,16
    if(p->vmas[i].used == 0)
    8000333c:	4398                	lw	a4,0(a5)
    8000333e:	c30d                	beqz	a4,80003360 <sys_mmap+0xc4>
  for(i = 0; i < NVMA; i++){
    80003340:	2485                	addiw	s1,s1,1
    80003342:	03878793          	addi	a5,a5,56
    80003346:	fed49be3          	bne	s1,a3,8000333c <sys_mmap+0xa0>
      break;
  }

  if(i == NVMA)
    return -1;
    8000334a:	557d                	li	a0,-1
    8000334c:	74a6                	ld	s1,104(sp)
    8000334e:	6a46                	ld	s4,80(sp)
    80003350:	6aa6                	ld	s5,72(sp)
    80003352:	6b06                	ld	s6,64(sp)
    80003354:	a079                	j	800033e2 <sys_mmap+0x146>
    return -1;
    80003356:	557d                	li	a0,-1
    80003358:	6a46                	ld	s4,80(sp)
    8000335a:	6aa6                	ld	s5,72(sp)
    8000335c:	6b06                	ld	s6,64(sp)
    8000335e:	a051                	j	800033e2 <sys_mmap+0x146>

  vma = &p->vmas[i];

  vma->addr = mmap_find_addr(p, length);
    80003360:	85ce                	mv	a1,s3
    80003362:	854a                	mv	a0,s2
    80003364:	eddff0ef          	jal	80003240 <mmap_find_addr>
    80003368:	872a                	mv	a4,a0
    8000336a:	00349793          	slli	a5,s1,0x3
    8000336e:	8f85                	sub	a5,a5,s1
    80003370:	078e                	slli	a5,a5,0x3
    80003372:	97ca                	add	a5,a5,s2
    80003374:	16a7b423          	sd	a0,360(a5)

  if(vma->addr == 0)
    return -1;
    80003378:	557d                	li	a0,-1
  if(vma->addr == 0)
    8000337a:	cb39                	beqz	a4,800033d0 <sys_mmap+0x134>
    8000337c:	fc5e                	sd	s7,56(sp)
    8000337e:	f862                	sd	s8,48(sp)

  vma->used = 1;
    80003380:	00349c13          	slli	s8,s1,0x3
    80003384:	409c0bb3          	sub	s7,s8,s1
    80003388:	0b8e                	slli	s7,s7,0x3
    8000338a:	9bca                	add	s7,s7,s2
    8000338c:	4785                	li	a5,1
    8000338e:	16fba023          	sw	a5,352(s7)
  vma->length = length;
    80003392:	173bb823          	sd	s3,368(s7)
  vma->maplen = PGROUNDUP(length);
    80003396:	6785                	lui	a5,0x1
    80003398:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000339a:	97ce                	add	a5,a5,s3
    8000339c:	777d                	lui	a4,0xfffff
    8000339e:	8ff9                	and	a5,a5,a4
    800033a0:	16fbbc23          	sd	a5,376(s7)
  vma->prot = prot;
    800033a4:	194ba023          	sw	s4,384(s7)
  vma->flags = flags;
    800033a8:	195ba223          	sw	s5,388(s7)
  vma->file = filedup(f);
    800033ac:	855a                	mv	a0,s6
    800033ae:	684010ef          	jal	80004a32 <filedup>
    800033b2:	18abb423          	sd	a0,392(s7)
  vma->offset = offset;
    800033b6:	f9843783          	ld	a5,-104(s0)
    800033ba:	18fbb823          	sd	a5,400(s7)

  return vma->addr;
    800033be:	168bb503          	ld	a0,360(s7)
    800033c2:	74a6                	ld	s1,104(sp)
    800033c4:	6a46                	ld	s4,80(sp)
    800033c6:	6aa6                	ld	s5,72(sp)
    800033c8:	6b06                	ld	s6,64(sp)
    800033ca:	7be2                	ld	s7,56(sp)
    800033cc:	7c42                	ld	s8,48(sp)
    800033ce:	a811                	j	800033e2 <sys_mmap+0x146>
    800033d0:	74a6                	ld	s1,104(sp)
    800033d2:	6a46                	ld	s4,80(sp)
    800033d4:	6aa6                	ld	s5,72(sp)
    800033d6:	6b06                	ld	s6,64(sp)
    800033d8:	a029                	j	800033e2 <sys_mmap+0x146>
    800033da:	6a46                	ld	s4,80(sp)
    800033dc:	a019                	j	800033e2 <sys_mmap+0x146>
    800033de:	6a46                	ld	s4,80(sp)
    800033e0:	6aa6                	ld	s5,72(sp)
}
    800033e2:	70e6                	ld	ra,120(sp)
    800033e4:	7446                	ld	s0,112(sp)
    800033e6:	7906                	ld	s2,96(sp)
    800033e8:	69e6                	ld	s3,88(sp)
    800033ea:	6109                	addi	sp,sp,128
    800033ec:	8082                	ret
    800033ee:	6a46                	ld	s4,80(sp)
    800033f0:	6aa6                	ld	s5,72(sp)
    800033f2:	bfc5                	j	800033e2 <sys_mmap+0x146>

00000000800033f4 <sys_munmap>:


uint64
sys_munmap(void)
{
    800033f4:	1101                	addi	sp,sp,-32
    800033f6:	ec06                	sd	ra,24(sp)
    800033f8:	e822                	sd	s0,16(sp)
    800033fa:	1000                	addi	s0,sp,32
  uint64 addr;
  uint64 length;

  argaddr(0, &addr);
    800033fc:	fe840593          	addi	a1,s0,-24
    80003400:	4501                	li	a0,0
    80003402:	b4dff0ef          	jal	80002f4e <argaddr>
  argaddr(1, &length);
    80003406:	fe040593          	addi	a1,s0,-32
    8000340a:	4505                	li	a0,1
    8000340c:	b43ff0ef          	jal	80002f4e <argaddr>

  if(length == 0)
    80003410:	fe043783          	ld	a5,-32(s0)
    return -1;
    80003414:	557d                	li	a0,-1
  if(length == 0)
    80003416:	cf89                	beqz	a5,80003430 <sys_munmap+0x3c>

  if(addr % PGSIZE != 0)
    80003418:	fe843783          	ld	a5,-24(s0)
    8000341c:	17d2                	slli	a5,a5,0x34
    8000341e:	eb89                	bnez	a5,80003430 <sys_munmap+0x3c>
    return -1;

  return mmap_unmap(myproc(), addr, length);
    80003420:	a77fe0ef          	jal	80001e96 <myproc>
    80003424:	fe043603          	ld	a2,-32(s0)
    80003428:	fe843583          	ld	a1,-24(s0)
    8000342c:	ea2fe0ef          	jal	80001ace <mmap_unmap>
    80003430:	60e2                	ld	ra,24(sp)
    80003432:	6442                	ld	s0,16(sp)
    80003434:	6105                	addi	sp,sp,32
    80003436:	8082                	ret

0000000080003438 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003438:	7179                	addi	sp,sp,-48
    8000343a:	f406                	sd	ra,40(sp)
    8000343c:	f022                	sd	s0,32(sp)
    8000343e:	ec26                	sd	s1,24(sp)
    80003440:	e84a                	sd	s2,16(sp)
    80003442:	e44e                	sd	s3,8(sp)
    80003444:	e052                	sd	s4,0(sp)
    80003446:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003448:	00005597          	auipc	a1,0x5
    8000344c:	f8058593          	addi	a1,a1,-128 # 800083c8 <etext+0x3c8>
    80003450:	00241517          	auipc	a0,0x241
    80003454:	5e050513          	addi	a0,a0,1504 # 80244a30 <bcache>
    80003458:	fe4fd0ef          	jal	80000c3c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000345c:	00249797          	auipc	a5,0x249
    80003460:	5d478793          	addi	a5,a5,1492 # 8024ca30 <bcache+0x8000>
    80003464:	0024a717          	auipc	a4,0x24a
    80003468:	83470713          	addi	a4,a4,-1996 # 8024cc98 <bcache+0x8268>
    8000346c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003470:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80003474:	00241497          	auipc	s1,0x241
    80003478:	5d448493          	addi	s1,s1,1492 # 80244a48 <bcache+0x18>
    b->next = bcache.head.next;
    8000347c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000347e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003480:	00005a17          	auipc	s4,0x5
    80003484:	f50a0a13          	addi	s4,s4,-176 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    80003488:	2b893783          	ld	a5,696(s2)
    8000348c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000348e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003492:	85d2                	mv	a1,s4
    80003494:	01048513          	addi	a0,s1,16
    80003498:	40c010ef          	jal	800048a4 <initsleeplock>
    bcache.head.next->prev = b;
    8000349c:	2b893783          	ld	a5,696(s2)
    800034a0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800034a2:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    800034a6:	45848493          	addi	s1,s1,1112
    800034aa:	fd349fe3          	bne	s1,s3,80003488 <binit+0x50>
  }
}
    800034ae:	70a2                	ld	ra,40(sp)
    800034b0:	7402                	ld	s0,32(sp)
    800034b2:	64e2                	ld	s1,24(sp)
    800034b4:	6942                	ld	s2,16(sp)
    800034b6:	69a2                	ld	s3,8(sp)
    800034b8:	6a02                	ld	s4,0(sp)
    800034ba:	6145                	addi	sp,sp,48
    800034bc:	8082                	ret

00000000800034be <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    800034be:	7179                	addi	sp,sp,-48
    800034c0:	f406                	sd	ra,40(sp)
    800034c2:	f022                	sd	s0,32(sp)
    800034c4:	ec26                	sd	s1,24(sp)
    800034c6:	e84a                	sd	s2,16(sp)
    800034c8:	e44e                	sd	s3,8(sp)
    800034ca:	1800                	addi	s0,sp,48
    800034cc:	892a                	mv	s2,a0
    800034ce:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034d0:	00241517          	auipc	a0,0x241
    800034d4:	56050513          	addi	a0,a0,1376 # 80244a30 <bcache>
    800034d8:	fdefd0ef          	jal	80000cb6 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    800034dc:	0024a497          	auipc	s1,0x24a
    800034e0:	80c4b483          	ld	s1,-2036(s1) # 8024cce8 <bcache+0x82b8>
    800034e4:	00249797          	auipc	a5,0x249
    800034e8:	7b478793          	addi	a5,a5,1972 # 8024cc98 <bcache+0x8268>
    800034ec:	02f48b63          	beq	s1,a5,80003522 <bread+0x64>
    800034f0:	873e                	mv	a4,a5
    800034f2:	a021                	j	800034fa <bread+0x3c>
    800034f4:	68a4                	ld	s1,80(s1)
    800034f6:	02e48663          	beq	s1,a4,80003522 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    800034fa:	449c                	lw	a5,8(s1)
    800034fc:	ff279ce3          	bne	a5,s2,800034f4 <bread+0x36>
    80003500:	44dc                	lw	a5,12(s1)
    80003502:	ff3799e3          	bne	a5,s3,800034f4 <bread+0x36>
      b->refcnt++;
    80003506:	40bc                	lw	a5,64(s1)
    80003508:	2785                	addiw	a5,a5,1
    8000350a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000350c:	00241517          	auipc	a0,0x241
    80003510:	52450513          	addi	a0,a0,1316 # 80244a30 <bcache>
    80003514:	82bfd0ef          	jal	80000d3e <release>
      acquiresleep(&b->lock);
    80003518:	01048513          	addi	a0,s1,16
    8000351c:	3be010ef          	jal	800048da <acquiresleep>
      return b;
    80003520:	a889                	j	80003572 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80003522:	00249497          	auipc	s1,0x249
    80003526:	7be4b483          	ld	s1,1982(s1) # 8024cce0 <bcache+0x82b0>
    8000352a:	00249797          	auipc	a5,0x249
    8000352e:	76e78793          	addi	a5,a5,1902 # 8024cc98 <bcache+0x8268>
    80003532:	00f48863          	beq	s1,a5,80003542 <bread+0x84>
    80003536:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80003538:	40bc                	lw	a5,64(s1)
    8000353a:	cb91                	beqz	a5,8000354e <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    8000353c:	64a4                	ld	s1,72(s1)
    8000353e:	fee49de3          	bne	s1,a4,80003538 <bread+0x7a>
  panic("bget: no buffers");
    80003542:	00005517          	auipc	a0,0x5
    80003546:	e9650513          	addi	a0,a0,-362 # 800083d8 <etext+0x3d8>
    8000354a:	aa4fd0ef          	jal	800007ee <panic>
      b->dev = dev;
    8000354e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003552:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003556:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000355a:	4785                	li	a5,1
    8000355c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000355e:	00241517          	auipc	a0,0x241
    80003562:	4d250513          	addi	a0,a0,1234 # 80244a30 <bcache>
    80003566:	fd8fd0ef          	jal	80000d3e <release>
      acquiresleep(&b->lock);
    8000356a:	01048513          	addi	a0,s1,16
    8000356e:	36c010ef          	jal	800048da <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80003572:	409c                	lw	a5,0(s1)
    80003574:	cb89                	beqz	a5,80003586 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003576:	8526                	mv	a0,s1
    80003578:	70a2                	ld	ra,40(sp)
    8000357a:	7402                	ld	s0,32(sp)
    8000357c:	64e2                	ld	s1,24(sp)
    8000357e:	6942                	ld	s2,16(sp)
    80003580:	69a2                	ld	s3,8(sp)
    80003582:	6145                	addi	sp,sp,48
    80003584:	8082                	ret
    virtio_disk_rw(b, 0);
    80003586:	4581                	li	a1,0
    80003588:	8526                	mv	a0,s1
    8000358a:	4b7020ef          	jal	80006240 <virtio_disk_rw>
    b->valid = 1;
    8000358e:	4785                	li	a5,1
    80003590:	c09c                	sw	a5,0(s1)
  return b;
    80003592:	b7d5                	j	80003576 <bread+0xb8>

0000000080003594 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80003594:	1101                	addi	sp,sp,-32
    80003596:	ec06                	sd	ra,24(sp)
    80003598:	e822                	sd	s0,16(sp)
    8000359a:	e426                	sd	s1,8(sp)
    8000359c:	1000                	addi	s0,sp,32
    8000359e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    800035a0:	0541                	addi	a0,a0,16
    800035a2:	3c4010ef          	jal	80004966 <holdingsleep>
    800035a6:	c911                	beqz	a0,800035ba <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035a8:	4585                	li	a1,1
    800035aa:	8526                	mv	a0,s1
    800035ac:	495020ef          	jal	80006240 <virtio_disk_rw>
}
    800035b0:	60e2                	ld	ra,24(sp)
    800035b2:	6442                	ld	s0,16(sp)
    800035b4:	64a2                	ld	s1,8(sp)
    800035b6:	6105                	addi	sp,sp,32
    800035b8:	8082                	ret
    panic("bwrite");
    800035ba:	00005517          	auipc	a0,0x5
    800035be:	e3650513          	addi	a0,a0,-458 # 800083f0 <etext+0x3f0>
    800035c2:	a2cfd0ef          	jal	800007ee <panic>

00000000800035c6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035c6:	1101                	addi	sp,sp,-32
    800035c8:	ec06                	sd	ra,24(sp)
    800035ca:	e822                	sd	s0,16(sp)
    800035cc:	e426                	sd	s1,8(sp)
    800035ce:	e04a                	sd	s2,0(sp)
    800035d0:	1000                	addi	s0,sp,32
    800035d2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    800035d4:	01050913          	addi	s2,a0,16
    800035d8:	854a                	mv	a0,s2
    800035da:	38c010ef          	jal	80004966 <holdingsleep>
    800035de:	c125                	beqz	a0,8000363e <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800035e0:	854a                	mv	a0,s2
    800035e2:	34c010ef          	jal	8000492e <releasesleep>

  acquire(&bcache.lock);
    800035e6:	00241517          	auipc	a0,0x241
    800035ea:	44a50513          	addi	a0,a0,1098 # 80244a30 <bcache>
    800035ee:	ec8fd0ef          	jal	80000cb6 <acquire>
  b->refcnt--;
    800035f2:	40bc                	lw	a5,64(s1)
    800035f4:	37fd                	addiw	a5,a5,-1
    800035f6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800035f8:	e79d                	bnez	a5,80003626 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800035fa:	68b8                	ld	a4,80(s1)
    800035fc:	64bc                	ld	a5,72(s1)
    800035fe:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003600:	68b8                	ld	a4,80(s1)
    80003602:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003604:	00249797          	auipc	a5,0x249
    80003608:	42c78793          	addi	a5,a5,1068 # 8024ca30 <bcache+0x8000>
    8000360c:	2b87b703          	ld	a4,696(a5)
    80003610:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003612:	00249717          	auipc	a4,0x249
    80003616:	68670713          	addi	a4,a4,1670 # 8024cc98 <bcache+0x8268>
    8000361a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000361c:	2b87b703          	ld	a4,696(a5)
    80003620:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003622:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003626:	00241517          	auipc	a0,0x241
    8000362a:	40a50513          	addi	a0,a0,1034 # 80244a30 <bcache>
    8000362e:	f10fd0ef          	jal	80000d3e <release>
}
    80003632:	60e2                	ld	ra,24(sp)
    80003634:	6442                	ld	s0,16(sp)
    80003636:	64a2                	ld	s1,8(sp)
    80003638:	6902                	ld	s2,0(sp)
    8000363a:	6105                	addi	sp,sp,32
    8000363c:	8082                	ret
    panic("brelse");
    8000363e:	00005517          	auipc	a0,0x5
    80003642:	dba50513          	addi	a0,a0,-582 # 800083f8 <etext+0x3f8>
    80003646:	9a8fd0ef          	jal	800007ee <panic>

000000008000364a <bpin>:

void
bpin(struct buf *b)
{
    8000364a:	1101                	addi	sp,sp,-32
    8000364c:	ec06                	sd	ra,24(sp)
    8000364e:	e822                	sd	s0,16(sp)
    80003650:	e426                	sd	s1,8(sp)
    80003652:	1000                	addi	s0,sp,32
    80003654:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003656:	00241517          	auipc	a0,0x241
    8000365a:	3da50513          	addi	a0,a0,986 # 80244a30 <bcache>
    8000365e:	e58fd0ef          	jal	80000cb6 <acquire>
  b->refcnt++;
    80003662:	40bc                	lw	a5,64(s1)
    80003664:	2785                	addiw	a5,a5,1
    80003666:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003668:	00241517          	auipc	a0,0x241
    8000366c:	3c850513          	addi	a0,a0,968 # 80244a30 <bcache>
    80003670:	ecefd0ef          	jal	80000d3e <release>
}
    80003674:	60e2                	ld	ra,24(sp)
    80003676:	6442                	ld	s0,16(sp)
    80003678:	64a2                	ld	s1,8(sp)
    8000367a:	6105                	addi	sp,sp,32
    8000367c:	8082                	ret

000000008000367e <bunpin>:

void
bunpin(struct buf *b)
{
    8000367e:	1101                	addi	sp,sp,-32
    80003680:	ec06                	sd	ra,24(sp)
    80003682:	e822                	sd	s0,16(sp)
    80003684:	e426                	sd	s1,8(sp)
    80003686:	1000                	addi	s0,sp,32
    80003688:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000368a:	00241517          	auipc	a0,0x241
    8000368e:	3a650513          	addi	a0,a0,934 # 80244a30 <bcache>
    80003692:	e24fd0ef          	jal	80000cb6 <acquire>
  b->refcnt--;
    80003696:	40bc                	lw	a5,64(s1)
    80003698:	37fd                	addiw	a5,a5,-1
    8000369a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000369c:	00241517          	auipc	a0,0x241
    800036a0:	39450513          	addi	a0,a0,916 # 80244a30 <bcache>
    800036a4:	e9afd0ef          	jal	80000d3e <release>
}
    800036a8:	60e2                	ld	ra,24(sp)
    800036aa:	6442                	ld	s0,16(sp)
    800036ac:	64a2                	ld	s1,8(sp)
    800036ae:	6105                	addi	sp,sp,32
    800036b0:	8082                	ret

00000000800036b2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800036b2:	1101                	addi	sp,sp,-32
    800036b4:	ec06                	sd	ra,24(sp)
    800036b6:	e822                	sd	s0,16(sp)
    800036b8:	e426                	sd	s1,8(sp)
    800036ba:	e04a                	sd	s2,0(sp)
    800036bc:	1000                	addi	s0,sp,32
    800036be:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800036c0:	00d5d79b          	srliw	a5,a1,0xd
    800036c4:	0024a597          	auipc	a1,0x24a
    800036c8:	a485a583          	lw	a1,-1464(a1) # 8024d10c <sb+0x1c>
    800036cc:	9dbd                	addw	a1,a1,a5
    800036ce:	df1ff0ef          	jal	800034be <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800036d2:	0074f713          	andi	a4,s1,7
    800036d6:	4785                	li	a5,1
    800036d8:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800036dc:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    800036de:	90d9                	srli	s1,s1,0x36
    800036e0:	00950733          	add	a4,a0,s1
    800036e4:	05874703          	lbu	a4,88(a4)
    800036e8:	00e7f6b3          	and	a3,a5,a4
    800036ec:	c29d                	beqz	a3,80003712 <bfree+0x60>
    800036ee:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    800036f0:	94aa                	add	s1,s1,a0
    800036f2:	fff7c793          	not	a5,a5
    800036f6:	8f7d                	and	a4,a4,a5
    800036f8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800036fc:	076010ef          	jal	80004772 <log_write>
  brelse(bp);
    80003700:	854a                	mv	a0,s2
    80003702:	ec5ff0ef          	jal	800035c6 <brelse>
}
    80003706:	60e2                	ld	ra,24(sp)
    80003708:	6442                	ld	s0,16(sp)
    8000370a:	64a2                	ld	s1,8(sp)
    8000370c:	6902                	ld	s2,0(sp)
    8000370e:	6105                	addi	sp,sp,32
    80003710:	8082                	ret
    panic("freeing free block");
    80003712:	00005517          	auipc	a0,0x5
    80003716:	cee50513          	addi	a0,a0,-786 # 80008400 <etext+0x400>
    8000371a:	8d4fd0ef          	jal	800007ee <panic>

000000008000371e <balloc>:
{
    8000371e:	715d                	addi	sp,sp,-80
    80003720:	e486                	sd	ra,72(sp)
    80003722:	e0a2                	sd	s0,64(sp)
    80003724:	fc26                	sd	s1,56(sp)
    80003726:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80003728:	0024a797          	auipc	a5,0x24a
    8000372c:	9cc7a783          	lw	a5,-1588(a5) # 8024d0f4 <sb+0x4>
    80003730:	0e078863          	beqz	a5,80003820 <balloc+0x102>
    80003734:	f84a                	sd	s2,48(sp)
    80003736:	f44e                	sd	s3,40(sp)
    80003738:	f052                	sd	s4,32(sp)
    8000373a:	ec56                	sd	s5,24(sp)
    8000373c:	e85a                	sd	s6,16(sp)
    8000373e:	e45e                	sd	s7,8(sp)
    80003740:	e062                	sd	s8,0(sp)
    80003742:	8baa                	mv	s7,a0
    80003744:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003746:	0024ab17          	auipc	s6,0x24a
    8000374a:	9aab0b13          	addi	s6,s6,-1622 # 8024d0f0 <sb>
      m = 1 << (bi % 8);
    8000374e:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003750:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80003752:	6c09                	lui	s8,0x2
    80003754:	a09d                	j	800037ba <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80003756:	97ca                	add	a5,a5,s2
    80003758:	8e55                	or	a2,a2,a3
    8000375a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000375e:	854a                	mv	a0,s2
    80003760:	012010ef          	jal	80004772 <log_write>
        brelse(bp);
    80003764:	854a                	mv	a0,s2
    80003766:	e61ff0ef          	jal	800035c6 <brelse>
  bp = bread(dev, bno);
    8000376a:	85a6                	mv	a1,s1
    8000376c:	855e                	mv	a0,s7
    8000376e:	d51ff0ef          	jal	800034be <bread>
    80003772:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003774:	40000613          	li	a2,1024
    80003778:	4581                	li	a1,0
    8000377a:	05850513          	addi	a0,a0,88
    8000377e:	df8fd0ef          	jal	80000d76 <memset>
  log_write(bp);
    80003782:	854a                	mv	a0,s2
    80003784:	7ef000ef          	jal	80004772 <log_write>
  brelse(bp);
    80003788:	854a                	mv	a0,s2
    8000378a:	e3dff0ef          	jal	800035c6 <brelse>
}
    8000378e:	7942                	ld	s2,48(sp)
    80003790:	79a2                	ld	s3,40(sp)
    80003792:	7a02                	ld	s4,32(sp)
    80003794:	6ae2                	ld	s5,24(sp)
    80003796:	6b42                	ld	s6,16(sp)
    80003798:	6ba2                	ld	s7,8(sp)
    8000379a:	6c02                	ld	s8,0(sp)
}
    8000379c:	8526                	mv	a0,s1
    8000379e:	60a6                	ld	ra,72(sp)
    800037a0:	6406                	ld	s0,64(sp)
    800037a2:	74e2                	ld	s1,56(sp)
    800037a4:	6161                	addi	sp,sp,80
    800037a6:	8082                	ret
    brelse(bp);
    800037a8:	854a                	mv	a0,s2
    800037aa:	e1dff0ef          	jal	800035c6 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    800037ae:	015c0abb          	addw	s5,s8,s5
    800037b2:	004b2783          	lw	a5,4(s6)
    800037b6:	04fafe63          	bgeu	s5,a5,80003812 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800037ba:	41fad79b          	sraiw	a5,s5,0x1f
    800037be:	0137d79b          	srliw	a5,a5,0x13
    800037c2:	015787bb          	addw	a5,a5,s5
    800037c6:	40d7d79b          	sraiw	a5,a5,0xd
    800037ca:	01cb2583          	lw	a1,28(s6)
    800037ce:	9dbd                	addw	a1,a1,a5
    800037d0:	855e                	mv	a0,s7
    800037d2:	cedff0ef          	jal	800034be <bread>
    800037d6:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    800037d8:	004b2503          	lw	a0,4(s6)
    800037dc:	84d6                	mv	s1,s5
    800037de:	4701                	li	a4,0
    800037e0:	fca4f4e3          	bgeu	s1,a0,800037a8 <balloc+0x8a>
      m = 1 << (bi % 8);
    800037e4:	00777693          	andi	a3,a4,7
    800037e8:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    800037ec:	41f7579b          	sraiw	a5,a4,0x1f
    800037f0:	01d7d79b          	srliw	a5,a5,0x1d
    800037f4:	9fb9                	addw	a5,a5,a4
    800037f6:	4037d79b          	sraiw	a5,a5,0x3
    800037fa:	00f90633          	add	a2,s2,a5
    800037fe:	05864603          	lbu	a2,88(a2)
    80003802:	00c6f5b3          	and	a1,a3,a2
    80003806:	d9a1                	beqz	a1,80003756 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003808:	2705                	addiw	a4,a4,1
    8000380a:	2485                	addiw	s1,s1,1
    8000380c:	fd471ae3          	bne	a4,s4,800037e0 <balloc+0xc2>
    80003810:	bf61                	j	800037a8 <balloc+0x8a>
    80003812:	7942                	ld	s2,48(sp)
    80003814:	79a2                	ld	s3,40(sp)
    80003816:	7a02                	ld	s4,32(sp)
    80003818:	6ae2                	ld	s5,24(sp)
    8000381a:	6b42                	ld	s6,16(sp)
    8000381c:	6ba2                	ld	s7,8(sp)
    8000381e:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80003820:	00005517          	auipc	a0,0x5
    80003824:	bf850513          	addi	a0,a0,-1032 # 80008418 <etext+0x418>
    80003828:	ce3fc0ef          	jal	8000050a <printk>
  return 0;
    8000382c:	4481                	li	s1,0
    8000382e:	b7bd                	j	8000379c <balloc+0x7e>

0000000080003830 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003830:	7179                	addi	sp,sp,-48
    80003832:	f406                	sd	ra,40(sp)
    80003834:	f022                	sd	s0,32(sp)
    80003836:	ec26                	sd	s1,24(sp)
    80003838:	e84a                	sd	s2,16(sp)
    8000383a:	e44e                	sd	s3,8(sp)
    8000383c:	1800                	addi	s0,sp,48
    8000383e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003840:	47ad                	li	a5,11
    80003842:	02b7e363          	bltu	a5,a1,80003868 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80003846:	02059793          	slli	a5,a1,0x20
    8000384a:	01e7d593          	srli	a1,a5,0x1e
    8000384e:	00b504b3          	add	s1,a0,a1
    80003852:	0504a903          	lw	s2,80(s1)
    80003856:	06091363          	bnez	s2,800038bc <bmap+0x8c>
      addr = balloc(ip->dev);
    8000385a:	4108                	lw	a0,0(a0)
    8000385c:	ec3ff0ef          	jal	8000371e <balloc>
    80003860:	892a                	mv	s2,a0
      if (addr == 0)
    80003862:	cd29                	beqz	a0,800038bc <bmap+0x8c>
        return 0;
      ip->addrs[bn] = addr;
    80003864:	c8a8                	sw	a0,80(s1)
    80003866:	a899                	j	800038bc <bmap+0x8c>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003868:	ff45849b          	addiw	s1,a1,-12

  if (bn < NINDIRECT) {
    8000386c:	0ff00793          	li	a5,255
    80003870:	0697e963          	bltu	a5,s1,800038e2 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80003874:	08052903          	lw	s2,128(a0)
    80003878:	00091b63          	bnez	s2,8000388e <bmap+0x5e>
      addr = balloc(ip->dev);
    8000387c:	4108                	lw	a0,0(a0)
    8000387e:	ea1ff0ef          	jal	8000371e <balloc>
    80003882:	892a                	mv	s2,a0
      if (addr == 0)
    80003884:	cd05                	beqz	a0,800038bc <bmap+0x8c>
    80003886:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003888:	08a9a023          	sw	a0,128(s3)
    8000388c:	a011                	j	80003890 <bmap+0x60>
    8000388e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003890:	85ca                	mv	a1,s2
    80003892:	0009a503          	lw	a0,0(s3)
    80003896:	c29ff0ef          	jal	800034be <bread>
    8000389a:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    8000389c:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800038a0:	02049713          	slli	a4,s1,0x20
    800038a4:	01e75593          	srli	a1,a4,0x1e
    800038a8:	00b784b3          	add	s1,a5,a1
    800038ac:	0004a903          	lw	s2,0(s1)
    800038b0:	00090e63          	beqz	s2,800038cc <bmap+0x9c>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800038b4:	8552                	mv	a0,s4
    800038b6:	d11ff0ef          	jal	800035c6 <brelse>
    return addr;
    800038ba:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800038bc:	854a                	mv	a0,s2
    800038be:	70a2                	ld	ra,40(sp)
    800038c0:	7402                	ld	s0,32(sp)
    800038c2:	64e2                	ld	s1,24(sp)
    800038c4:	6942                	ld	s2,16(sp)
    800038c6:	69a2                	ld	s3,8(sp)
    800038c8:	6145                	addi	sp,sp,48
    800038ca:	8082                	ret
      addr = balloc(ip->dev);
    800038cc:	0009a503          	lw	a0,0(s3)
    800038d0:	e4fff0ef          	jal	8000371e <balloc>
    800038d4:	892a                	mv	s2,a0
      if (addr) {
    800038d6:	dd79                	beqz	a0,800038b4 <bmap+0x84>
        a[bn] = addr;
    800038d8:	c088                	sw	a0,0(s1)
        log_write(bp);
    800038da:	8552                	mv	a0,s4
    800038dc:	697000ef          	jal	80004772 <log_write>
    800038e0:	bfd1                	j	800038b4 <bmap+0x84>
    800038e2:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800038e4:	00005517          	auipc	a0,0x5
    800038e8:	b4c50513          	addi	a0,a0,-1204 # 80008430 <etext+0x430>
    800038ec:	f03fc0ef          	jal	800007ee <panic>

00000000800038f0 <iget>:
{
    800038f0:	7179                	addi	sp,sp,-48
    800038f2:	f406                	sd	ra,40(sp)
    800038f4:	f022                	sd	s0,32(sp)
    800038f6:	ec26                	sd	s1,24(sp)
    800038f8:	e84a                	sd	s2,16(sp)
    800038fa:	e44e                	sd	s3,8(sp)
    800038fc:	e052                	sd	s4,0(sp)
    800038fe:	1800                	addi	s0,sp,48
    80003900:	89aa                	mv	s3,a0
    80003902:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003904:	0024a517          	auipc	a0,0x24a
    80003908:	80c50513          	addi	a0,a0,-2036 # 8024d110 <itable>
    8000390c:	baafd0ef          	jal	80000cb6 <acquire>
  empty = 0;
    80003910:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003912:	0024a497          	auipc	s1,0x24a
    80003916:	81648493          	addi	s1,s1,-2026 # 8024d128 <itable+0x18>
    8000391a:	0024b697          	auipc	a3,0x24b
    8000391e:	29e68693          	addi	a3,a3,670 # 8024ebb8 <log>
    80003922:	a039                	j	80003930 <iget+0x40>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003924:	02090963          	beqz	s2,80003956 <iget+0x66>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003928:	08848493          	addi	s1,s1,136
    8000392c:	02d48863          	beq	s1,a3,8000395c <iget+0x6c>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003930:	449c                	lw	a5,8(s1)
    80003932:	fef059e3          	blez	a5,80003924 <iget+0x34>
    80003936:	4098                	lw	a4,0(s1)
    80003938:	ff3716e3          	bne	a4,s3,80003924 <iget+0x34>
    8000393c:	40d8                	lw	a4,4(s1)
    8000393e:	ff4713e3          	bne	a4,s4,80003924 <iget+0x34>
      ip->ref++;
    80003942:	2785                	addiw	a5,a5,1
    80003944:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003946:	00249517          	auipc	a0,0x249
    8000394a:	7ca50513          	addi	a0,a0,1994 # 8024d110 <itable>
    8000394e:	bf0fd0ef          	jal	80000d3e <release>
      return ip;
    80003952:	8926                	mv	s2,s1
    80003954:	a02d                	j	8000397e <iget+0x8e>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003956:	fbe9                	bnez	a5,80003928 <iget+0x38>
      empty = ip;
    80003958:	8926                	mv	s2,s1
    8000395a:	b7f9                	j	80003928 <iget+0x38>
  if (empty == 0)
    8000395c:	02090a63          	beqz	s2,80003990 <iget+0xa0>
  ip->dev = dev;
    80003960:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003964:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003968:	4785                	li	a5,1
    8000396a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000396e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003972:	00249517          	auipc	a0,0x249
    80003976:	79e50513          	addi	a0,a0,1950 # 8024d110 <itable>
    8000397a:	bc4fd0ef          	jal	80000d3e <release>
}
    8000397e:	854a                	mv	a0,s2
    80003980:	70a2                	ld	ra,40(sp)
    80003982:	7402                	ld	s0,32(sp)
    80003984:	64e2                	ld	s1,24(sp)
    80003986:	6942                	ld	s2,16(sp)
    80003988:	69a2                	ld	s3,8(sp)
    8000398a:	6a02                	ld	s4,0(sp)
    8000398c:	6145                	addi	sp,sp,48
    8000398e:	8082                	ret
    panic("iget: no inodes");
    80003990:	00005517          	auipc	a0,0x5
    80003994:	ab850513          	addi	a0,a0,-1352 # 80008448 <etext+0x448>
    80003998:	e57fc0ef          	jal	800007ee <panic>

000000008000399c <iinit>:
{
    8000399c:	7179                	addi	sp,sp,-48
    8000399e:	f406                	sd	ra,40(sp)
    800039a0:	f022                	sd	s0,32(sp)
    800039a2:	ec26                	sd	s1,24(sp)
    800039a4:	e84a                	sd	s2,16(sp)
    800039a6:	e44e                	sd	s3,8(sp)
    800039a8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800039aa:	00005597          	auipc	a1,0x5
    800039ae:	aae58593          	addi	a1,a1,-1362 # 80008458 <etext+0x458>
    800039b2:	00249517          	auipc	a0,0x249
    800039b6:	75e50513          	addi	a0,a0,1886 # 8024d110 <itable>
    800039ba:	a82fd0ef          	jal	80000c3c <initlock>
  for (i = 0; i < NINODE; i++) {
    800039be:	00249497          	auipc	s1,0x249
    800039c2:	77a48493          	addi	s1,s1,1914 # 8024d138 <itable+0x28>
    800039c6:	0024b997          	auipc	s3,0x24b
    800039ca:	20298993          	addi	s3,s3,514 # 8024ebc8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800039ce:	00005917          	auipc	s2,0x5
    800039d2:	a9290913          	addi	s2,s2,-1390 # 80008460 <etext+0x460>
    800039d6:	85ca                	mv	a1,s2
    800039d8:	8526                	mv	a0,s1
    800039da:	6cb000ef          	jal	800048a4 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800039de:	08848493          	addi	s1,s1,136
    800039e2:	ff349ae3          	bne	s1,s3,800039d6 <iinit+0x3a>
}
    800039e6:	70a2                	ld	ra,40(sp)
    800039e8:	7402                	ld	s0,32(sp)
    800039ea:	64e2                	ld	s1,24(sp)
    800039ec:	6942                	ld	s2,16(sp)
    800039ee:	69a2                	ld	s3,8(sp)
    800039f0:	6145                	addi	sp,sp,48
    800039f2:	8082                	ret

00000000800039f4 <ialloc>:
{
    800039f4:	7139                	addi	sp,sp,-64
    800039f6:	fc06                	sd	ra,56(sp)
    800039f8:	f822                	sd	s0,48(sp)
    800039fa:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800039fc:	00249717          	auipc	a4,0x249
    80003a00:	70072703          	lw	a4,1792(a4) # 8024d0fc <sb+0xc>
    80003a04:	4785                	li	a5,1
    80003a06:	06e7f063          	bgeu	a5,a4,80003a66 <ialloc+0x72>
    80003a0a:	f426                	sd	s1,40(sp)
    80003a0c:	f04a                	sd	s2,32(sp)
    80003a0e:	ec4e                	sd	s3,24(sp)
    80003a10:	e852                	sd	s4,16(sp)
    80003a12:	e456                	sd	s5,8(sp)
    80003a14:	e05a                	sd	s6,0(sp)
    80003a16:	8aaa                	mv	s5,a0
    80003a18:	8b2e                	mv	s6,a1
    80003a1a:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003a1c:	00249a17          	auipc	s4,0x249
    80003a20:	6d4a0a13          	addi	s4,s4,1748 # 8024d0f0 <sb>
    80003a24:	00495593          	srli	a1,s2,0x4
    80003a28:	018a2783          	lw	a5,24(s4)
    80003a2c:	9dbd                	addw	a1,a1,a5
    80003a2e:	8556                	mv	a0,s5
    80003a30:	a8fff0ef          	jal	800034be <bread>
    80003a34:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003a36:	05850993          	addi	s3,a0,88
    80003a3a:	00f97793          	andi	a5,s2,15
    80003a3e:	079a                	slli	a5,a5,0x6
    80003a40:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003a42:	00099783          	lh	a5,0(s3)
    80003a46:	cb9d                	beqz	a5,80003a7c <ialloc+0x88>
    brelse(bp);
    80003a48:	b7fff0ef          	jal	800035c6 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003a4c:	0905                	addi	s2,s2,1
    80003a4e:	00ca2703          	lw	a4,12(s4)
    80003a52:	0009079b          	sext.w	a5,s2
    80003a56:	fce7e7e3          	bltu	a5,a4,80003a24 <ialloc+0x30>
    80003a5a:	74a2                	ld	s1,40(sp)
    80003a5c:	7902                	ld	s2,32(sp)
    80003a5e:	69e2                	ld	s3,24(sp)
    80003a60:	6a42                	ld	s4,16(sp)
    80003a62:	6aa2                	ld	s5,8(sp)
    80003a64:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003a66:	00005517          	auipc	a0,0x5
    80003a6a:	a0250513          	addi	a0,a0,-1534 # 80008468 <etext+0x468>
    80003a6e:	a9dfc0ef          	jal	8000050a <printk>
  return 0;
    80003a72:	4501                	li	a0,0
}
    80003a74:	70e2                	ld	ra,56(sp)
    80003a76:	7442                	ld	s0,48(sp)
    80003a78:	6121                	addi	sp,sp,64
    80003a7a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003a7c:	04000613          	li	a2,64
    80003a80:	4581                	li	a1,0
    80003a82:	854e                	mv	a0,s3
    80003a84:	af2fd0ef          	jal	80000d76 <memset>
      dip->type = type;
    80003a88:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	4e5000ef          	jal	80004772 <log_write>
      brelse(bp);
    80003a92:	8526                	mv	a0,s1
    80003a94:	b33ff0ef          	jal	800035c6 <brelse>
      return iget(dev, inum);
    80003a98:	0009059b          	sext.w	a1,s2
    80003a9c:	8556                	mv	a0,s5
    80003a9e:	e53ff0ef          	jal	800038f0 <iget>
    80003aa2:	74a2                	ld	s1,40(sp)
    80003aa4:	7902                	ld	s2,32(sp)
    80003aa6:	69e2                	ld	s3,24(sp)
    80003aa8:	6a42                	ld	s4,16(sp)
    80003aaa:	6aa2                	ld	s5,8(sp)
    80003aac:	6b02                	ld	s6,0(sp)
    80003aae:	b7d9                	j	80003a74 <ialloc+0x80>

0000000080003ab0 <iupdate>:
{
    80003ab0:	1101                	addi	sp,sp,-32
    80003ab2:	ec06                	sd	ra,24(sp)
    80003ab4:	e822                	sd	s0,16(sp)
    80003ab6:	e426                	sd	s1,8(sp)
    80003ab8:	e04a                	sd	s2,0(sp)
    80003aba:	1000                	addi	s0,sp,32
    80003abc:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003abe:	415c                	lw	a5,4(a0)
    80003ac0:	0047d79b          	srliw	a5,a5,0x4
    80003ac4:	00249597          	auipc	a1,0x249
    80003ac8:	6445a583          	lw	a1,1604(a1) # 8024d108 <sb+0x18>
    80003acc:	9dbd                	addw	a1,a1,a5
    80003ace:	4108                	lw	a0,0(a0)
    80003ad0:	9efff0ef          	jal	800034be <bread>
    80003ad4:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003ad6:	05850793          	addi	a5,a0,88
    80003ada:	40d8                	lw	a4,4(s1)
    80003adc:	8b3d                	andi	a4,a4,15
    80003ade:	071a                	slli	a4,a4,0x6
    80003ae0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003ae2:	04449703          	lh	a4,68(s1)
    80003ae6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003aea:	04649703          	lh	a4,70(s1)
    80003aee:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003af2:	04849703          	lh	a4,72(s1)
    80003af6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003afa:	04a49703          	lh	a4,74(s1)
    80003afe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003b02:	44f8                	lw	a4,76(s1)
    80003b04:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003b06:	03400613          	li	a2,52
    80003b0a:	05048593          	addi	a1,s1,80
    80003b0e:	00c78513          	addi	a0,a5,12
    80003b12:	ac8fd0ef          	jal	80000dda <memmove>
  log_write(bp);
    80003b16:	854a                	mv	a0,s2
    80003b18:	45b000ef          	jal	80004772 <log_write>
  brelse(bp);
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	aa9ff0ef          	jal	800035c6 <brelse>
}
    80003b22:	60e2                	ld	ra,24(sp)
    80003b24:	6442                	ld	s0,16(sp)
    80003b26:	64a2                	ld	s1,8(sp)
    80003b28:	6902                	ld	s2,0(sp)
    80003b2a:	6105                	addi	sp,sp,32
    80003b2c:	8082                	ret

0000000080003b2e <idup>:
{
    80003b2e:	1101                	addi	sp,sp,-32
    80003b30:	ec06                	sd	ra,24(sp)
    80003b32:	e822                	sd	s0,16(sp)
    80003b34:	e426                	sd	s1,8(sp)
    80003b36:	1000                	addi	s0,sp,32
    80003b38:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003b3a:	00249517          	auipc	a0,0x249
    80003b3e:	5d650513          	addi	a0,a0,1494 # 8024d110 <itable>
    80003b42:	974fd0ef          	jal	80000cb6 <acquire>
  ip->ref++;
    80003b46:	449c                	lw	a5,8(s1)
    80003b48:	2785                	addiw	a5,a5,1
    80003b4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003b4c:	00249517          	auipc	a0,0x249
    80003b50:	5c450513          	addi	a0,a0,1476 # 8024d110 <itable>
    80003b54:	9eafd0ef          	jal	80000d3e <release>
}
    80003b58:	8526                	mv	a0,s1
    80003b5a:	60e2                	ld	ra,24(sp)
    80003b5c:	6442                	ld	s0,16(sp)
    80003b5e:	64a2                	ld	s1,8(sp)
    80003b60:	6105                	addi	sp,sp,32
    80003b62:	8082                	ret

0000000080003b64 <ilock>:
{
    80003b64:	1101                	addi	sp,sp,-32
    80003b66:	ec06                	sd	ra,24(sp)
    80003b68:	e822                	sd	s0,16(sp)
    80003b6a:	e426                	sd	s1,8(sp)
    80003b6c:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003b6e:	cd19                	beqz	a0,80003b8c <ilock+0x28>
    80003b70:	84aa                	mv	s1,a0
    80003b72:	451c                	lw	a5,8(a0)
    80003b74:	00f05c63          	blez	a5,80003b8c <ilock+0x28>
  acquiresleep(&ip->lock);
    80003b78:	0541                	addi	a0,a0,16
    80003b7a:	561000ef          	jal	800048da <acquiresleep>
  if (ip->valid == 0) {
    80003b7e:	40bc                	lw	a5,64(s1)
    80003b80:	cf89                	beqz	a5,80003b9a <ilock+0x36>
}
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	64a2                	ld	s1,8(sp)
    80003b88:	6105                	addi	sp,sp,32
    80003b8a:	8082                	ret
    80003b8c:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003b8e:	00005517          	auipc	a0,0x5
    80003b92:	8f250513          	addi	a0,a0,-1806 # 80008480 <etext+0x480>
    80003b96:	c59fc0ef          	jal	800007ee <panic>
    80003b9a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003b9c:	40dc                	lw	a5,4(s1)
    80003b9e:	0047d79b          	srliw	a5,a5,0x4
    80003ba2:	00249597          	auipc	a1,0x249
    80003ba6:	5665a583          	lw	a1,1382(a1) # 8024d108 <sb+0x18>
    80003baa:	9dbd                	addw	a1,a1,a5
    80003bac:	4088                	lw	a0,0(s1)
    80003bae:	911ff0ef          	jal	800034be <bread>
    80003bb2:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003bb4:	05850593          	addi	a1,a0,88
    80003bb8:	40dc                	lw	a5,4(s1)
    80003bba:	8bbd                	andi	a5,a5,15
    80003bbc:	079a                	slli	a5,a5,0x6
    80003bbe:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003bc0:	00059783          	lh	a5,0(a1)
    80003bc4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003bc8:	00259783          	lh	a5,2(a1)
    80003bcc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003bd0:	00459783          	lh	a5,4(a1)
    80003bd4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003bd8:	00659783          	lh	a5,6(a1)
    80003bdc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003be0:	459c                	lw	a5,8(a1)
    80003be2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003be4:	03400613          	li	a2,52
    80003be8:	05b1                	addi	a1,a1,12
    80003bea:	05048513          	addi	a0,s1,80
    80003bee:	9ecfd0ef          	jal	80000dda <memmove>
    brelse(bp);
    80003bf2:	854a                	mv	a0,s2
    80003bf4:	9d3ff0ef          	jal	800035c6 <brelse>
    ip->valid = 1;
    80003bf8:	4785                	li	a5,1
    80003bfa:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003bfc:	04449783          	lh	a5,68(s1)
    80003c00:	c399                	beqz	a5,80003c06 <ilock+0xa2>
    80003c02:	6902                	ld	s2,0(sp)
    80003c04:	bfbd                	j	80003b82 <ilock+0x1e>
      panic("ilock: no type");
    80003c06:	00005517          	auipc	a0,0x5
    80003c0a:	88250513          	addi	a0,a0,-1918 # 80008488 <etext+0x488>
    80003c0e:	be1fc0ef          	jal	800007ee <panic>

0000000080003c12 <iunlock>:
{
    80003c12:	1101                	addi	sp,sp,-32
    80003c14:	ec06                	sd	ra,24(sp)
    80003c16:	e822                	sd	s0,16(sp)
    80003c18:	e426                	sd	s1,8(sp)
    80003c1a:	e04a                	sd	s2,0(sp)
    80003c1c:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003c1e:	c505                	beqz	a0,80003c46 <iunlock+0x34>
    80003c20:	84aa                	mv	s1,a0
    80003c22:	01050913          	addi	s2,a0,16
    80003c26:	854a                	mv	a0,s2
    80003c28:	53f000ef          	jal	80004966 <holdingsleep>
    80003c2c:	cd09                	beqz	a0,80003c46 <iunlock+0x34>
    80003c2e:	449c                	lw	a5,8(s1)
    80003c30:	00f05b63          	blez	a5,80003c46 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003c34:	854a                	mv	a0,s2
    80003c36:	4f9000ef          	jal	8000492e <releasesleep>
}
    80003c3a:	60e2                	ld	ra,24(sp)
    80003c3c:	6442                	ld	s0,16(sp)
    80003c3e:	64a2                	ld	s1,8(sp)
    80003c40:	6902                	ld	s2,0(sp)
    80003c42:	6105                	addi	sp,sp,32
    80003c44:	8082                	ret
    panic("iunlock");
    80003c46:	00005517          	auipc	a0,0x5
    80003c4a:	85250513          	addi	a0,a0,-1966 # 80008498 <etext+0x498>
    80003c4e:	ba1fc0ef          	jal	800007ee <panic>

0000000080003c52 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003c52:	7179                	addi	sp,sp,-48
    80003c54:	f406                	sd	ra,40(sp)
    80003c56:	f022                	sd	s0,32(sp)
    80003c58:	ec26                	sd	s1,24(sp)
    80003c5a:	e84a                	sd	s2,16(sp)
    80003c5c:	e44e                	sd	s3,8(sp)
    80003c5e:	1800                	addi	s0,sp,48
    80003c60:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003c62:	05050493          	addi	s1,a0,80
    80003c66:	08050913          	addi	s2,a0,128
    80003c6a:	a021                	j	80003c72 <itrunc+0x20>
    80003c6c:	0491                	addi	s1,s1,4
    80003c6e:	01248b63          	beq	s1,s2,80003c84 <itrunc+0x32>
    if (ip->addrs[i]) {
    80003c72:	408c                	lw	a1,0(s1)
    80003c74:	dde5                	beqz	a1,80003c6c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003c76:	0009a503          	lw	a0,0(s3)
    80003c7a:	a39ff0ef          	jal	800036b2 <bfree>
      ip->addrs[i] = 0;
    80003c7e:	0004a023          	sw	zero,0(s1)
    80003c82:	b7ed                	j	80003c6c <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    80003c84:	0809a583          	lw	a1,128(s3)
    80003c88:	ed89                	bnez	a1,80003ca2 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003c8a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003c8e:	854e                	mv	a0,s3
    80003c90:	e21ff0ef          	jal	80003ab0 <iupdate>
}
    80003c94:	70a2                	ld	ra,40(sp)
    80003c96:	7402                	ld	s0,32(sp)
    80003c98:	64e2                	ld	s1,24(sp)
    80003c9a:	6942                	ld	s2,16(sp)
    80003c9c:	69a2                	ld	s3,8(sp)
    80003c9e:	6145                	addi	sp,sp,48
    80003ca0:	8082                	ret
    80003ca2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ca4:	0009a503          	lw	a0,0(s3)
    80003ca8:	817ff0ef          	jal	800034be <bread>
    80003cac:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003cae:	05850493          	addi	s1,a0,88
    80003cb2:	45850913          	addi	s2,a0,1112
    80003cb6:	a021                	j	80003cbe <itrunc+0x6c>
    80003cb8:	0491                	addi	s1,s1,4
    80003cba:	01248963          	beq	s1,s2,80003ccc <itrunc+0x7a>
      if (a[j])
    80003cbe:	408c                	lw	a1,0(s1)
    80003cc0:	dde5                	beqz	a1,80003cb8 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003cc2:	0009a503          	lw	a0,0(s3)
    80003cc6:	9edff0ef          	jal	800036b2 <bfree>
    80003cca:	b7fd                	j	80003cb8 <itrunc+0x66>
    brelse(bp);
    80003ccc:	8552                	mv	a0,s4
    80003cce:	8f9ff0ef          	jal	800035c6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003cd2:	0809a583          	lw	a1,128(s3)
    80003cd6:	0009a503          	lw	a0,0(s3)
    80003cda:	9d9ff0ef          	jal	800036b2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003cde:	0809a023          	sw	zero,128(s3)
    80003ce2:	6a02                	ld	s4,0(sp)
    80003ce4:	b75d                	j	80003c8a <itrunc+0x38>

0000000080003ce6 <iput>:
{
    80003ce6:	7179                	addi	sp,sp,-48
    80003ce8:	f406                	sd	ra,40(sp)
    80003cea:	f022                	sd	s0,32(sp)
    80003cec:	ec26                	sd	s1,24(sp)
    80003cee:	1800                	addi	s0,sp,48
    80003cf0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cf2:	00249517          	auipc	a0,0x249
    80003cf6:	41e50513          	addi	a0,a0,1054 # 8024d110 <itable>
    80003cfa:	fbdfc0ef          	jal	80000cb6 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003cfe:	449c                	lw	a5,8(s1)
    80003d00:	4705                	li	a4,1
    80003d02:	00e78f63          	beq	a5,a4,80003d20 <iput+0x3a>
  ip->ref--;
    80003d06:	37fd                	addiw	a5,a5,-1
    80003d08:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d0a:	00249517          	auipc	a0,0x249
    80003d0e:	40650513          	addi	a0,a0,1030 # 8024d110 <itable>
    80003d12:	82cfd0ef          	jal	80000d3e <release>
}
    80003d16:	70a2                	ld	ra,40(sp)
    80003d18:	7402                	ld	s0,32(sp)
    80003d1a:	64e2                	ld	s1,24(sp)
    80003d1c:	6145                	addi	sp,sp,48
    80003d1e:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    80003d20:	40b8                	lw	a4,64(s1)
    80003d22:	d375                	beqz	a4,80003d06 <iput+0x20>
    80003d24:	e84a                	sd	s2,16(sp)
    80003d26:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003d28:	0004aa03          	lw	s4,0(s1)
    80003d2c:	0044a903          	lw	s2,4(s1)
  if (last) {
    80003d30:	04a49703          	lh	a4,74(s1)
    80003d34:	ef35                	bnez	a4,80003db0 <iput+0xca>
    80003d36:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003d38:	01048993          	addi	s3,s1,16
    80003d3c:	854e                	mv	a0,s3
    80003d3e:	39d000ef          	jal	800048da <acquiresleep>
    release(&itable.lock);
    80003d42:	00249517          	auipc	a0,0x249
    80003d46:	3ce50513          	addi	a0,a0,974 # 8024d110 <itable>
    80003d4a:	ff5fc0ef          	jal	80000d3e <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    80003d4e:	8526                	mv	a0,s1
    80003d50:	f03ff0ef          	jal	80003c52 <itrunc>
    ip->valid = 0;
    80003d54:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003d58:	854e                	mv	a0,s3
    80003d5a:	3d5000ef          	jal	8000492e <releasesleep>
    acquire(&itable.lock);
    80003d5e:	00249517          	auipc	a0,0x249
    80003d62:	3b250513          	addi	a0,a0,946 # 8024d110 <itable>
    80003d66:	f51fc0ef          	jal	80000cb6 <acquire>
  ip->ref--;
    80003d6a:	449c                	lw	a5,8(s1)
    80003d6c:	37fd                	addiw	a5,a5,-1
    80003d6e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d70:	00249517          	auipc	a0,0x249
    80003d74:	3a050513          	addi	a0,a0,928 # 8024d110 <itable>
    80003d78:	fc7fc0ef          	jal	80000d3e <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003d7c:	0049579b          	srliw	a5,s2,0x4
    80003d80:	00249597          	auipc	a1,0x249
    80003d84:	3885a583          	lw	a1,904(a1) # 8024d108 <sb+0x18>
    80003d88:	9dbd                	addw	a1,a1,a5
    80003d8a:	8552                	mv	a0,s4
    80003d8c:	f32ff0ef          	jal	800034be <bread>
    80003d90:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003d92:	00f97913          	andi	s2,s2,15
  dip->type = 0;
    80003d96:	091a                	slli	s2,s2,0x6
    80003d98:	992a                	add	s2,s2,a0
    80003d9a:	04091c23          	sh	zero,88(s2)
  log_write(bp);
    80003d9e:	1d5000ef          	jal	80004772 <log_write>
  brelse(bp);
    80003da2:	8526                	mv	a0,s1
    80003da4:	823ff0ef          	jal	800035c6 <brelse>
}
    80003da8:	6942                	ld	s2,16(sp)
    80003daa:	69a2                	ld	s3,8(sp)
    80003dac:	6a02                	ld	s4,0(sp)
    80003dae:	b7a5                	j	80003d16 <iput+0x30>
    80003db0:	6942                	ld	s2,16(sp)
    80003db2:	6a02                	ld	s4,0(sp)
    80003db4:	bf89                	j	80003d06 <iput+0x20>

0000000080003db6 <iunlockput>:
{
    80003db6:	1101                	addi	sp,sp,-32
    80003db8:	ec06                	sd	ra,24(sp)
    80003dba:	e822                	sd	s0,16(sp)
    80003dbc:	e426                	sd	s1,8(sp)
    80003dbe:	1000                	addi	s0,sp,32
    80003dc0:	84aa                	mv	s1,a0
  iunlock(ip);
    80003dc2:	e51ff0ef          	jal	80003c12 <iunlock>
  iput(ip);
    80003dc6:	8526                	mv	a0,s1
    80003dc8:	f1fff0ef          	jal	80003ce6 <iput>
}
    80003dcc:	60e2                	ld	ra,24(sp)
    80003dce:	6442                	ld	s0,16(sp)
    80003dd0:	64a2                	ld	s1,8(sp)
    80003dd2:	6105                	addi	sp,sp,32
    80003dd4:	8082                	ret

0000000080003dd6 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003dd6:	00249717          	auipc	a4,0x249
    80003dda:	32672703          	lw	a4,806(a4) # 8024d0fc <sb+0xc>
    80003dde:	4785                	li	a5,1
    80003de0:	0ae7fe63          	bgeu	a5,a4,80003e9c <ireclaim+0xc6>
{
    80003de4:	7139                	addi	sp,sp,-64
    80003de6:	fc06                	sd	ra,56(sp)
    80003de8:	f822                	sd	s0,48(sp)
    80003dea:	f426                	sd	s1,40(sp)
    80003dec:	f04a                	sd	s2,32(sp)
    80003dee:	ec4e                	sd	s3,24(sp)
    80003df0:	e852                	sd	s4,16(sp)
    80003df2:	e456                	sd	s5,8(sp)
    80003df4:	e05a                	sd	s6,0(sp)
    80003df6:	0080                	addi	s0,sp,64
    80003df8:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003dfa:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003dfc:	00249a17          	auipc	s4,0x249
    80003e00:	2f4a0a13          	addi	s4,s4,756 # 8024d0f0 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80003e04:	00004b17          	auipc	s6,0x4
    80003e08:	69cb0b13          	addi	s6,s6,1692 # 800084a0 <etext+0x4a0>
    80003e0c:	a099                	j	80003e52 <ireclaim+0x7c>
    80003e0e:	85ce                	mv	a1,s3
    80003e10:	855a                	mv	a0,s6
    80003e12:	ef8fc0ef          	jal	8000050a <printk>
      ip = iget(dev, inum);
    80003e16:	85ce                	mv	a1,s3
    80003e18:	8556                	mv	a0,s5
    80003e1a:	ad7ff0ef          	jal	800038f0 <iget>
    80003e1e:	89aa                	mv	s3,a0
    brelse(bp);
    80003e20:	854a                	mv	a0,s2
    80003e22:	fa4ff0ef          	jal	800035c6 <brelse>
    if (ip) {
    80003e26:	00098f63          	beqz	s3,80003e44 <ireclaim+0x6e>
      begin_op();
    80003e2a:	79c000ef          	jal	800045c6 <begin_op>
      ilock(ip);
    80003e2e:	854e                	mv	a0,s3
    80003e30:	d35ff0ef          	jal	80003b64 <ilock>
      iunlock(ip);
    80003e34:	854e                	mv	a0,s3
    80003e36:	dddff0ef          	jal	80003c12 <iunlock>
      iput(ip);
    80003e3a:	854e                	mv	a0,s3
    80003e3c:	eabff0ef          	jal	80003ce6 <iput>
      end_op();
    80003e40:	00d000ef          	jal	8000464c <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003e44:	0485                	addi	s1,s1,1
    80003e46:	00ca2703          	lw	a4,12(s4)
    80003e4a:	0004879b          	sext.w	a5,s1
    80003e4e:	02e7fd63          	bgeu	a5,a4,80003e88 <ireclaim+0xb2>
    80003e52:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003e56:	0044d593          	srli	a1,s1,0x4
    80003e5a:	018a2783          	lw	a5,24(s4)
    80003e5e:	9dbd                	addw	a1,a1,a5
    80003e60:	8556                	mv	a0,s5
    80003e62:	e5cff0ef          	jal	800034be <bread>
    80003e66:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003e68:	05850793          	addi	a5,a0,88
    80003e6c:	00f9f713          	andi	a4,s3,15
    80003e70:	071a                	slli	a4,a4,0x6
    80003e72:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80003e74:	00079703          	lh	a4,0(a5)
    80003e78:	c701                	beqz	a4,80003e80 <ireclaim+0xaa>
    80003e7a:	00679783          	lh	a5,6(a5)
    80003e7e:	dbc1                	beqz	a5,80003e0e <ireclaim+0x38>
    brelse(bp);
    80003e80:	854a                	mv	a0,s2
    80003e82:	f44ff0ef          	jal	800035c6 <brelse>
    if (ip) {
    80003e86:	bf7d                	j	80003e44 <ireclaim+0x6e>
}
    80003e88:	70e2                	ld	ra,56(sp)
    80003e8a:	7442                	ld	s0,48(sp)
    80003e8c:	74a2                	ld	s1,40(sp)
    80003e8e:	7902                	ld	s2,32(sp)
    80003e90:	69e2                	ld	s3,24(sp)
    80003e92:	6a42                	ld	s4,16(sp)
    80003e94:	6aa2                	ld	s5,8(sp)
    80003e96:	6b02                	ld	s6,0(sp)
    80003e98:	6121                	addi	sp,sp,64
    80003e9a:	8082                	ret
    80003e9c:	8082                	ret

0000000080003e9e <fsinit>:
{
    80003e9e:	7179                	addi	sp,sp,-48
    80003ea0:	f406                	sd	ra,40(sp)
    80003ea2:	f022                	sd	s0,32(sp)
    80003ea4:	ec26                	sd	s1,24(sp)
    80003ea6:	e84a                	sd	s2,16(sp)
    80003ea8:	e44e                	sd	s3,8(sp)
    80003eaa:	1800                	addi	s0,sp,48
    80003eac:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003eae:	4585                	li	a1,1
    80003eb0:	e0eff0ef          	jal	800034be <bread>
    80003eb4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003eb6:	00249997          	auipc	s3,0x249
    80003eba:	23a98993          	addi	s3,s3,570 # 8024d0f0 <sb>
    80003ebe:	02000613          	li	a2,32
    80003ec2:	05850593          	addi	a1,a0,88
    80003ec6:	854e                	mv	a0,s3
    80003ec8:	f13fc0ef          	jal	80000dda <memmove>
  brelse(bp);
    80003ecc:	8526                	mv	a0,s1
    80003ece:	ef8ff0ef          	jal	800035c6 <brelse>
  if (sb.magic != FSMAGIC)
    80003ed2:	0009a703          	lw	a4,0(s3)
    80003ed6:	102037b7          	lui	a5,0x10203
    80003eda:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003ede:	02f71363          	bne	a4,a5,80003f04 <fsinit+0x66>
  initlog(dev, &sb);
    80003ee2:	00249597          	auipc	a1,0x249
    80003ee6:	20e58593          	addi	a1,a1,526 # 8024d0f0 <sb>
    80003eea:	854a                	mv	a0,s2
    80003eec:	65c000ef          	jal	80004548 <initlog>
  ireclaim(dev);
    80003ef0:	854a                	mv	a0,s2
    80003ef2:	ee5ff0ef          	jal	80003dd6 <ireclaim>
}
    80003ef6:	70a2                	ld	ra,40(sp)
    80003ef8:	7402                	ld	s0,32(sp)
    80003efa:	64e2                	ld	s1,24(sp)
    80003efc:	6942                	ld	s2,16(sp)
    80003efe:	69a2                	ld	s3,8(sp)
    80003f00:	6145                	addi	sp,sp,48
    80003f02:	8082                	ret
    panic("invalid file system");
    80003f04:	00004517          	auipc	a0,0x4
    80003f08:	5bc50513          	addi	a0,a0,1468 # 800084c0 <etext+0x4c0>
    80003f0c:	8e3fc0ef          	jal	800007ee <panic>

0000000080003f10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f10:	1141                	addi	sp,sp,-16
    80003f12:	e406                	sd	ra,8(sp)
    80003f14:	e022                	sd	s0,0(sp)
    80003f16:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f18:	411c                	lw	a5,0(a0)
    80003f1a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f1c:	415c                	lw	a5,4(a0)
    80003f1e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f20:	04451783          	lh	a5,68(a0)
    80003f24:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f28:	04a51783          	lh	a5,74(a0)
    80003f2c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f30:	04c56783          	lwu	a5,76(a0)
    80003f34:	e99c                	sd	a5,16(a1)
}
    80003f36:	60a2                	ld	ra,8(sp)
    80003f38:	6402                	ld	s0,0(sp)
    80003f3a:	0141                	addi	sp,sp,16
    80003f3c:	8082                	ret

0000000080003f3e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80003f3e:	457c                	lw	a5,76(a0)
    80003f40:	0ed7e663          	bltu	a5,a3,8000402c <readi+0xee>
{
    80003f44:	7159                	addi	sp,sp,-112
    80003f46:	f486                	sd	ra,104(sp)
    80003f48:	f0a2                	sd	s0,96(sp)
    80003f4a:	eca6                	sd	s1,88(sp)
    80003f4c:	e0d2                	sd	s4,64(sp)
    80003f4e:	fc56                	sd	s5,56(sp)
    80003f50:	f85a                	sd	s6,48(sp)
    80003f52:	f45e                	sd	s7,40(sp)
    80003f54:	1880                	addi	s0,sp,112
    80003f56:	8b2a                	mv	s6,a0
    80003f58:	8bae                	mv	s7,a1
    80003f5a:	8a32                	mv	s4,a2
    80003f5c:	84b6                	mv	s1,a3
    80003f5e:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    80003f60:	9f35                	addw	a4,a4,a3
    return 0;
    80003f62:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003f64:	0ad76b63          	bltu	a4,a3,8000401a <readi+0xdc>
    80003f68:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003f6a:	00e7f463          	bgeu	a5,a4,80003f72 <readi+0x34>
    n = ip->size - off;
    80003f6e:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003f72:	080a8b63          	beqz	s5,80004008 <readi+0xca>
    80003f76:	e8ca                	sd	s2,80(sp)
    80003f78:	f062                	sd	s8,32(sp)
    80003f7a:	ec66                	sd	s9,24(sp)
    80003f7c:	e86a                	sd	s10,16(sp)
    80003f7e:	e46e                	sd	s11,8(sp)
    80003f80:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003f82:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003f86:	5c7d                	li	s8,-1
    80003f88:	a80d                	j	80003fba <readi+0x7c>
    80003f8a:	020d1d93          	slli	s11,s10,0x20
    80003f8e:	020ddd93          	srli	s11,s11,0x20
    80003f92:	05890613          	addi	a2,s2,88
    80003f96:	86ee                	mv	a3,s11
    80003f98:	963e                	add	a2,a2,a5
    80003f9a:	85d2                	mv	a1,s4
    80003f9c:	855e                	mv	a0,s7
    80003f9e:	933fe0ef          	jal	800028d0 <either_copyout>
    80003fa2:	05850363          	beq	a0,s8,80003fe8 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fa6:	854a                	mv	a0,s2
    80003fa8:	e1eff0ef          	jal	800035c6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003fac:	013d09bb          	addw	s3,s10,s3
    80003fb0:	009d04bb          	addw	s1,s10,s1
    80003fb4:	9a6e                	add	s4,s4,s11
    80003fb6:	0559f363          	bgeu	s3,s5,80003ffc <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003fba:	00a4d59b          	srliw	a1,s1,0xa
    80003fbe:	855a                	mv	a0,s6
    80003fc0:	871ff0ef          	jal	80003830 <bmap>
    80003fc4:	85aa                	mv	a1,a0
    if (addr == 0)
    80003fc6:	c139                	beqz	a0,8000400c <readi+0xce>
    bp = bread(ip->dev, addr);
    80003fc8:	000b2503          	lw	a0,0(s6)
    80003fcc:	cf2ff0ef          	jal	800034be <bread>
    80003fd0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003fd2:	3ff4f793          	andi	a5,s1,1023
    80003fd6:	40fc873b          	subw	a4,s9,a5
    80003fda:	413a86bb          	subw	a3,s5,s3
    80003fde:	8d3a                	mv	s10,a4
    80003fe0:	fae6f5e3          	bgeu	a3,a4,80003f8a <readi+0x4c>
    80003fe4:	8d36                	mv	s10,a3
    80003fe6:	b755                	j	80003f8a <readi+0x4c>
      brelse(bp);
    80003fe8:	854a                	mv	a0,s2
    80003fea:	ddcff0ef          	jal	800035c6 <brelse>
      tot = -1;
    80003fee:	59fd                	li	s3,-1
      break;
    80003ff0:	6946                	ld	s2,80(sp)
    80003ff2:	7c02                	ld	s8,32(sp)
    80003ff4:	6ce2                	ld	s9,24(sp)
    80003ff6:	6d42                	ld	s10,16(sp)
    80003ff8:	6da2                	ld	s11,8(sp)
    80003ffa:	a831                	j	80004016 <readi+0xd8>
    80003ffc:	6946                	ld	s2,80(sp)
    80003ffe:	7c02                	ld	s8,32(sp)
    80004000:	6ce2                	ld	s9,24(sp)
    80004002:	6d42                	ld	s10,16(sp)
    80004004:	6da2                	ld	s11,8(sp)
    80004006:	a801                	j	80004016 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80004008:	89d6                	mv	s3,s5
    8000400a:	a031                	j	80004016 <readi+0xd8>
    8000400c:	6946                	ld	s2,80(sp)
    8000400e:	7c02                	ld	s8,32(sp)
    80004010:	6ce2                	ld	s9,24(sp)
    80004012:	6d42                	ld	s10,16(sp)
    80004014:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004016:	854e                	mv	a0,s3
    80004018:	69a6                	ld	s3,72(sp)
}
    8000401a:	70a6                	ld	ra,104(sp)
    8000401c:	7406                	ld	s0,96(sp)
    8000401e:	64e6                	ld	s1,88(sp)
    80004020:	6a06                	ld	s4,64(sp)
    80004022:	7ae2                	ld	s5,56(sp)
    80004024:	7b42                	ld	s6,48(sp)
    80004026:	7ba2                	ld	s7,40(sp)
    80004028:	6165                	addi	sp,sp,112
    8000402a:	8082                	ret
    return 0;
    8000402c:	4501                	li	a0,0
}
    8000402e:	8082                	ret

0000000080004030 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    80004030:	457c                	lw	a5,76(a0)
    80004032:	0ed7ee63          	bltu	a5,a3,8000412e <writei+0xfe>
{
    80004036:	7159                	addi	sp,sp,-112
    80004038:	f486                	sd	ra,104(sp)
    8000403a:	f0a2                	sd	s0,96(sp)
    8000403c:	e8ca                	sd	s2,80(sp)
    8000403e:	e0d2                	sd	s4,64(sp)
    80004040:	fc56                	sd	s5,56(sp)
    80004042:	f85a                	sd	s6,48(sp)
    80004044:	f45e                	sd	s7,40(sp)
    80004046:	1880                	addi	s0,sp,112
    80004048:	8aaa                	mv	s5,a0
    8000404a:	8bae                	mv	s7,a1
    8000404c:	8a32                	mv	s4,a2
    8000404e:	8936                	mv	s2,a3
    80004050:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80004052:	00e687bb          	addw	a5,a3,a4
    80004056:	0cd7ee63          	bltu	a5,a3,80004132 <writei+0x102>
    return -1;
  if (off + n > MAXFILE * BSIZE)
    8000405a:	00043737          	lui	a4,0x43
    8000405e:	0cf76c63          	bltu	a4,a5,80004136 <writei+0x106>
    80004062:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80004064:	0a0b0d63          	beqz	s6,8000411e <writei+0xee>
    80004068:	eca6                	sd	s1,88(sp)
    8000406a:	f062                	sd	s8,32(sp)
    8000406c:	ec66                	sd	s9,24(sp)
    8000406e:	e86a                	sd	s10,16(sp)
    80004070:	e46e                	sd	s11,8(sp)
    80004072:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80004074:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004078:	5c7d                	li	s8,-1
    8000407a:	a825                	j	800040b2 <writei+0x82>
    8000407c:	020d1d93          	slli	s11,s10,0x20
    80004080:	020ddd93          	srli	s11,s11,0x20
    80004084:	05848513          	addi	a0,s1,88
    80004088:	86ee                	mv	a3,s11
    8000408a:	8652                	mv	a2,s4
    8000408c:	85de                	mv	a1,s7
    8000408e:	953e                	add	a0,a0,a5
    80004090:	88dfe0ef          	jal	8000291c <either_copyin>
    80004094:	05850663          	beq	a0,s8,800040e0 <writei+0xb0>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    80004098:	8526                	mv	a0,s1
    8000409a:	6d8000ef          	jal	80004772 <log_write>
    brelse(bp);
    8000409e:	8526                	mv	a0,s1
    800040a0:	d26ff0ef          	jal	800035c6 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800040a4:	013d09bb          	addw	s3,s10,s3
    800040a8:	012d093b          	addw	s2,s10,s2
    800040ac:	9a6e                	add	s4,s4,s11
    800040ae:	0369ff63          	bgeu	s3,s6,800040ec <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    800040b2:	00a9559b          	srliw	a1,s2,0xa
    800040b6:	8556                	mv	a0,s5
    800040b8:	f78ff0ef          	jal	80003830 <bmap>
    800040bc:	85aa                	mv	a1,a0
    if (addr == 0)
    800040be:	c51d                	beqz	a0,800040ec <writei+0xbc>
    bp = bread(ip->dev, addr);
    800040c0:	000aa503          	lw	a0,0(s5)
    800040c4:	bfaff0ef          	jal	800034be <bread>
    800040c8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800040ca:	3ff97793          	andi	a5,s2,1023
    800040ce:	40fc873b          	subw	a4,s9,a5
    800040d2:	413b06bb          	subw	a3,s6,s3
    800040d6:	8d3a                	mv	s10,a4
    800040d8:	fae6f2e3          	bgeu	a3,a4,8000407c <writei+0x4c>
    800040dc:	8d36                	mv	s10,a3
    800040de:	bf79                	j	8000407c <writei+0x4c>
      log_write(bp);
    800040e0:	8526                	mv	a0,s1
    800040e2:	690000ef          	jal	80004772 <log_write>
      brelse(bp);
    800040e6:	8526                	mv	a0,s1
    800040e8:	cdeff0ef          	jal	800035c6 <brelse>
  }

  if (off > ip->size)
    800040ec:	04caa783          	lw	a5,76(s5)
    800040f0:	0327f963          	bgeu	a5,s2,80004122 <writei+0xf2>
    ip->size = off;
    800040f4:	052aa623          	sw	s2,76(s5)
    800040f8:	64e6                	ld	s1,88(sp)
    800040fa:	7c02                	ld	s8,32(sp)
    800040fc:	6ce2                	ld	s9,24(sp)
    800040fe:	6d42                	ld	s10,16(sp)
    80004100:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004102:	8556                	mv	a0,s5
    80004104:	9adff0ef          	jal	80003ab0 <iupdate>

  return tot;
    80004108:	854e                	mv	a0,s3
    8000410a:	69a6                	ld	s3,72(sp)
}
    8000410c:	70a6                	ld	ra,104(sp)
    8000410e:	7406                	ld	s0,96(sp)
    80004110:	6946                	ld	s2,80(sp)
    80004112:	6a06                	ld	s4,64(sp)
    80004114:	7ae2                	ld	s5,56(sp)
    80004116:	7b42                	ld	s6,48(sp)
    80004118:	7ba2                	ld	s7,40(sp)
    8000411a:	6165                	addi	sp,sp,112
    8000411c:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000411e:	89da                	mv	s3,s6
    80004120:	b7cd                	j	80004102 <writei+0xd2>
    80004122:	64e6                	ld	s1,88(sp)
    80004124:	7c02                	ld	s8,32(sp)
    80004126:	6ce2                	ld	s9,24(sp)
    80004128:	6d42                	ld	s10,16(sp)
    8000412a:	6da2                	ld	s11,8(sp)
    8000412c:	bfd9                	j	80004102 <writei+0xd2>
    return -1;
    8000412e:	557d                	li	a0,-1
}
    80004130:	8082                	ret
    return -1;
    80004132:	557d                	li	a0,-1
    80004134:	bfe1                	j	8000410c <writei+0xdc>
    return -1;
    80004136:	557d                	li	a0,-1
    80004138:	bfd1                	j	8000410c <writei+0xdc>

000000008000413a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000413a:	1141                	addi	sp,sp,-16
    8000413c:	e406                	sd	ra,8(sp)
    8000413e:	e022                	sd	s0,0(sp)
    80004140:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004142:	4639                	li	a2,14
    80004144:	d0bfc0ef          	jal	80000e4e <strncmp>
}
    80004148:	60a2                	ld	ra,8(sp)
    8000414a:	6402                	ld	s0,0(sp)
    8000414c:	0141                	addi	sp,sp,16
    8000414e:	8082                	ret

0000000080004150 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004150:	711d                	addi	sp,sp,-96
    80004152:	ec86                	sd	ra,88(sp)
    80004154:	e8a2                	sd	s0,80(sp)
    80004156:	e4a6                	sd	s1,72(sp)
    80004158:	e0ca                	sd	s2,64(sp)
    8000415a:	fc4e                	sd	s3,56(sp)
    8000415c:	f852                	sd	s4,48(sp)
    8000415e:	f456                	sd	s5,40(sp)
    80004160:	f05a                	sd	s6,32(sp)
    80004162:	ec5e                	sd	s7,24(sp)
    80004164:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80004166:	04451703          	lh	a4,68(a0)
    8000416a:	4785                	li	a5,1
    8000416c:	00f71f63          	bne	a4,a5,8000418a <dirlookup+0x3a>
    80004170:	892a                	mv	s2,a0
    80004172:	8aae                	mv	s5,a1
    80004174:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004176:	457c                	lw	a5,76(a0)
    80004178:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000417a:	fa040a13          	addi	s4,s0,-96
    8000417e:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80004180:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004184:	4501                	li	a0,0
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004186:	e39d                	bnez	a5,800041ac <dirlookup+0x5c>
    80004188:	a8b9                	j	800041e6 <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000418a:	00004517          	auipc	a0,0x4
    8000418e:	34e50513          	addi	a0,a0,846 # 800084d8 <etext+0x4d8>
    80004192:	e5cfc0ef          	jal	800007ee <panic>
      panic("dirlookup read");
    80004196:	00004517          	auipc	a0,0x4
    8000419a:	35a50513          	addi	a0,a0,858 # 800084f0 <etext+0x4f0>
    8000419e:	e50fc0ef          	jal	800007ee <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800041a2:	24c1                	addiw	s1,s1,16
    800041a4:	04c92783          	lw	a5,76(s2)
    800041a8:	02f4fe63          	bgeu	s1,a5,800041e4 <dirlookup+0x94>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041ac:	874e                	mv	a4,s3
    800041ae:	86a6                	mv	a3,s1
    800041b0:	8652                	mv	a2,s4
    800041b2:	4581                	li	a1,0
    800041b4:	854a                	mv	a0,s2
    800041b6:	d89ff0ef          	jal	80003f3e <readi>
    800041ba:	fd351ee3          	bne	a0,s3,80004196 <dirlookup+0x46>
    if (de.inum == 0)
    800041be:	fa045783          	lhu	a5,-96(s0)
    800041c2:	d3e5                	beqz	a5,800041a2 <dirlookup+0x52>
    if (namecmp(name, de.name) == 0) {
    800041c4:	85da                	mv	a1,s6
    800041c6:	8556                	mv	a0,s5
    800041c8:	f73ff0ef          	jal	8000413a <namecmp>
    800041cc:	f979                	bnez	a0,800041a2 <dirlookup+0x52>
      if (poff)
    800041ce:	000b8463          	beqz	s7,800041d6 <dirlookup+0x86>
        *poff = off;
    800041d2:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800041d6:	fa045583          	lhu	a1,-96(s0)
    800041da:	00092503          	lw	a0,0(s2)
    800041de:	f12ff0ef          	jal	800038f0 <iget>
    800041e2:	a011                	j	800041e6 <dirlookup+0x96>
  return 0;
    800041e4:	4501                	li	a0,0
}
    800041e6:	60e6                	ld	ra,88(sp)
    800041e8:	6446                	ld	s0,80(sp)
    800041ea:	64a6                	ld	s1,72(sp)
    800041ec:	6906                	ld	s2,64(sp)
    800041ee:	79e2                	ld	s3,56(sp)
    800041f0:	7a42                	ld	s4,48(sp)
    800041f2:	7aa2                	ld	s5,40(sp)
    800041f4:	7b02                	ld	s6,32(sp)
    800041f6:	6be2                	ld	s7,24(sp)
    800041f8:	6125                	addi	sp,sp,96
    800041fa:	8082                	ret

00000000800041fc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800041fc:	711d                	addi	sp,sp,-96
    800041fe:	ec86                	sd	ra,88(sp)
    80004200:	e8a2                	sd	s0,80(sp)
    80004202:	e4a6                	sd	s1,72(sp)
    80004204:	e0ca                	sd	s2,64(sp)
    80004206:	fc4e                	sd	s3,56(sp)
    80004208:	f852                	sd	s4,48(sp)
    8000420a:	f456                	sd	s5,40(sp)
    8000420c:	f05a                	sd	s6,32(sp)
    8000420e:	ec5e                	sd	s7,24(sp)
    80004210:	e862                	sd	s8,16(sp)
    80004212:	e466                	sd	s9,8(sp)
    80004214:	e06a                	sd	s10,0(sp)
    80004216:	1080                	addi	s0,sp,96
    80004218:	84aa                	mv	s1,a0
    8000421a:	8b2e                	mv	s6,a1
    8000421c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    8000421e:	00054703          	lbu	a4,0(a0)
    80004222:	02f00793          	li	a5,47
    80004226:	00f70f63          	beq	a4,a5,80004244 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000422a:	c6dfd0ef          	jal	80001e96 <myproc>
    8000422e:	15853503          	ld	a0,344(a0)
    80004232:	8fdff0ef          	jal	80003b2e <idup>
    80004236:	8a2a                	mv	s4,a0
  while (*path == '/')
    80004238:	02f00913          	li	s2,47
  if (len >= DIRSIZ)
    8000423c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000423e:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80004240:	4b85                	li	s7,1
    80004242:	a07d                	j	800042f0 <namex+0xf4>
    ip = iget(ROOTDEV, ROOTINO);
    80004244:	4585                	li	a1,1
    80004246:	852e                	mv	a0,a1
    80004248:	ea8ff0ef          	jal	800038f0 <iget>
    8000424c:	8a2a                	mv	s4,a0
    8000424e:	b7ed                	j	80004238 <namex+0x3c>
      iunlockput(ip);
    80004250:	8552                	mv	a0,s4
    80004252:	b65ff0ef          	jal	80003db6 <iunlockput>
      return 0;
    80004256:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80004258:	8552                	mv	a0,s4
    8000425a:	60e6                	ld	ra,88(sp)
    8000425c:	6446                	ld	s0,80(sp)
    8000425e:	64a6                	ld	s1,72(sp)
    80004260:	6906                	ld	s2,64(sp)
    80004262:	79e2                	ld	s3,56(sp)
    80004264:	7a42                	ld	s4,48(sp)
    80004266:	7aa2                	ld	s5,40(sp)
    80004268:	7b02                	ld	s6,32(sp)
    8000426a:	6be2                	ld	s7,24(sp)
    8000426c:	6c42                	ld	s8,16(sp)
    8000426e:	6ca2                	ld	s9,8(sp)
    80004270:	6d02                	ld	s10,0(sp)
    80004272:	6125                	addi	sp,sp,96
    80004274:	8082                	ret
      iunlockput(ip);
    80004276:	8552                	mv	a0,s4
    80004278:	b3fff0ef          	jal	80003db6 <iunlockput>
      return 0;
    8000427c:	4a01                	li	s4,0
    8000427e:	bfe9                	j	80004258 <namex+0x5c>
      iunlock(ip);
    80004280:	8552                	mv	a0,s4
    80004282:	991ff0ef          	jal	80003c12 <iunlock>
      return ip;
    80004286:	bfc9                	j	80004258 <namex+0x5c>
      iunlockput(ip);
    80004288:	8552                	mv	a0,s4
    8000428a:	b2dff0ef          	jal	80003db6 <iunlockput>
      return 0;
    8000428e:	8a4e                	mv	s4,s3
    80004290:	b7e1                	j	80004258 <namex+0x5c>
  len = path - s;
    80004292:	40998633          	sub	a2,s3,s1
    80004296:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    8000429a:	09ac5363          	bge	s8,s10,80004320 <namex+0x124>
    memmove(name, s, DIRSIZ);
    8000429e:	8666                	mv	a2,s9
    800042a0:	85a6                	mv	a1,s1
    800042a2:	8556                	mv	a0,s5
    800042a4:	b37fc0ef          	jal	80000dda <memmove>
    800042a8:	84ce                	mv	s1,s3
  while (*path == '/')
    800042aa:	0004c783          	lbu	a5,0(s1)
    800042ae:	01279763          	bne	a5,s2,800042bc <namex+0xc0>
    path++;
    800042b2:	0485                	addi	s1,s1,1
  while (*path == '/')
    800042b4:	0004c783          	lbu	a5,0(s1)
    800042b8:	ff278de3          	beq	a5,s2,800042b2 <namex+0xb6>
    ilock(ip);
    800042bc:	8552                	mv	a0,s4
    800042be:	8a7ff0ef          	jal	80003b64 <ilock>
    if (ip->type != T_DIR) {
    800042c2:	044a1783          	lh	a5,68(s4)
    800042c6:	f97795e3          	bne	a5,s7,80004250 <namex+0x54>
    if (ip->nlink == 0) {
    800042ca:	04aa1783          	lh	a5,74(s4)
    800042ce:	d7c5                	beqz	a5,80004276 <namex+0x7a>
    if (nameiparent && *path == '\0') {
    800042d0:	000b0563          	beqz	s6,800042da <namex+0xde>
    800042d4:	0004c783          	lbu	a5,0(s1)
    800042d8:	d7c5                	beqz	a5,80004280 <namex+0x84>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    800042da:	4601                	li	a2,0
    800042dc:	85d6                	mv	a1,s5
    800042de:	8552                	mv	a0,s4
    800042e0:	e71ff0ef          	jal	80004150 <dirlookup>
    800042e4:	89aa                	mv	s3,a0
    800042e6:	d14d                	beqz	a0,80004288 <namex+0x8c>
    iunlockput(ip);
    800042e8:	8552                	mv	a0,s4
    800042ea:	acdff0ef          	jal	80003db6 <iunlockput>
    ip = next;
    800042ee:	8a4e                	mv	s4,s3
  while (*path == '/')
    800042f0:	0004c783          	lbu	a5,0(s1)
    800042f4:	01279763          	bne	a5,s2,80004302 <namex+0x106>
    path++;
    800042f8:	0485                	addi	s1,s1,1
  while (*path == '/')
    800042fa:	0004c783          	lbu	a5,0(s1)
    800042fe:	ff278de3          	beq	a5,s2,800042f8 <namex+0xfc>
  if (*path == 0)
    80004302:	cb8d                	beqz	a5,80004334 <namex+0x138>
  while (*path != '/' && *path != 0)
    80004304:	0004c783          	lbu	a5,0(s1)
    80004308:	89a6                	mv	s3,s1
  len = path - s;
    8000430a:	4d01                	li	s10,0
    8000430c:	4601                	li	a2,0
  while (*path != '/' && *path != 0)
    8000430e:	01278963          	beq	a5,s2,80004320 <namex+0x124>
    80004312:	d3c1                	beqz	a5,80004292 <namex+0x96>
    path++;
    80004314:	0985                	addi	s3,s3,1
  while (*path != '/' && *path != 0)
    80004316:	0009c783          	lbu	a5,0(s3)
    8000431a:	ff279ce3          	bne	a5,s2,80004312 <namex+0x116>
    8000431e:	bf95                	j	80004292 <namex+0x96>
    memmove(name, s, len);
    80004320:	2601                	sext.w	a2,a2
    80004322:	85a6                	mv	a1,s1
    80004324:	8556                	mv	a0,s5
    80004326:	ab5fc0ef          	jal	80000dda <memmove>
    name[len] = 0;
    8000432a:	9d56                	add	s10,s10,s5
    8000432c:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdaf208>
    80004330:	84ce                	mv	s1,s3
    80004332:	bfa5                	j	800042aa <namex+0xae>
  if (nameiparent) {
    80004334:	f20b02e3          	beqz	s6,80004258 <namex+0x5c>
    iput(ip);
    80004338:	8552                	mv	a0,s4
    8000433a:	9adff0ef          	jal	80003ce6 <iput>
    return 0;
    8000433e:	4a01                	li	s4,0
    80004340:	bf21                	j	80004258 <namex+0x5c>

0000000080004342 <dirlink>:
{
    80004342:	715d                	addi	sp,sp,-80
    80004344:	e486                	sd	ra,72(sp)
    80004346:	e0a2                	sd	s0,64(sp)
    80004348:	f84a                	sd	s2,48(sp)
    8000434a:	ec56                	sd	s5,24(sp)
    8000434c:	e85a                	sd	s6,16(sp)
    8000434e:	0880                	addi	s0,sp,80
    80004350:	892a                	mv	s2,a0
    80004352:	8aae                	mv	s5,a1
    80004354:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004356:	4601                	li	a2,0
    80004358:	df9ff0ef          	jal	80004150 <dirlookup>
    8000435c:	ed1d                	bnez	a0,8000439a <dirlink+0x58>
    8000435e:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80004360:	04c92483          	lw	s1,76(s2)
    80004364:	c4b9                	beqz	s1,800043b2 <dirlink+0x70>
    80004366:	f44e                	sd	s3,40(sp)
    80004368:	f052                	sd	s4,32(sp)
    8000436a:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000436c:	fb040a13          	addi	s4,s0,-80
    80004370:	49c1                	li	s3,16
    80004372:	874e                	mv	a4,s3
    80004374:	86a6                	mv	a3,s1
    80004376:	8652                	mv	a2,s4
    80004378:	4581                	li	a1,0
    8000437a:	854a                	mv	a0,s2
    8000437c:	bc3ff0ef          	jal	80003f3e <readi>
    80004380:	03351163          	bne	a0,s3,800043a2 <dirlink+0x60>
    if (de.inum == 0)
    80004384:	fb045783          	lhu	a5,-80(s0)
    80004388:	c39d                	beqz	a5,800043ae <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000438a:	24c1                	addiw	s1,s1,16
    8000438c:	04c92783          	lw	a5,76(s2)
    80004390:	fef4e1e3          	bltu	s1,a5,80004372 <dirlink+0x30>
    80004394:	79a2                	ld	s3,40(sp)
    80004396:	7a02                	ld	s4,32(sp)
    80004398:	a829                	j	800043b2 <dirlink+0x70>
    iput(ip);
    8000439a:	94dff0ef          	jal	80003ce6 <iput>
    return -1;
    8000439e:	557d                	li	a0,-1
    800043a0:	a83d                	j	800043de <dirlink+0x9c>
      panic("dirlink read");
    800043a2:	00004517          	auipc	a0,0x4
    800043a6:	15e50513          	addi	a0,a0,350 # 80008500 <etext+0x500>
    800043aa:	c44fc0ef          	jal	800007ee <panic>
    800043ae:	79a2                	ld	s3,40(sp)
    800043b0:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800043b2:	4639                	li	a2,14
    800043b4:	85d6                	mv	a1,s5
    800043b6:	fb240513          	addi	a0,s0,-78
    800043ba:	acffc0ef          	jal	80000e88 <strncpy>
  de.inum = inum;
    800043be:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043c2:	4741                	li	a4,16
    800043c4:	86a6                	mv	a3,s1
    800043c6:	fb040613          	addi	a2,s0,-80
    800043ca:	4581                	li	a1,0
    800043cc:	854a                	mv	a0,s2
    800043ce:	c63ff0ef          	jal	80004030 <writei>
    800043d2:	1541                	addi	a0,a0,-16
    800043d4:	00a03533          	snez	a0,a0
    800043d8:	40a0053b          	negw	a0,a0
    800043dc:	74e2                	ld	s1,56(sp)
}
    800043de:	60a6                	ld	ra,72(sp)
    800043e0:	6406                	ld	s0,64(sp)
    800043e2:	7942                	ld	s2,48(sp)
    800043e4:	6ae2                	ld	s5,24(sp)
    800043e6:	6b42                	ld	s6,16(sp)
    800043e8:	6161                	addi	sp,sp,80
    800043ea:	8082                	ret

00000000800043ec <namei>:

struct inode *
namei(char *path)
{
    800043ec:	1101                	addi	sp,sp,-32
    800043ee:	ec06                	sd	ra,24(sp)
    800043f0:	e822                	sd	s0,16(sp)
    800043f2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800043f4:	fe040613          	addi	a2,s0,-32
    800043f8:	4581                	li	a1,0
    800043fa:	e03ff0ef          	jal	800041fc <namex>
}
    800043fe:	60e2                	ld	ra,24(sp)
    80004400:	6442                	ld	s0,16(sp)
    80004402:	6105                	addi	sp,sp,32
    80004404:	8082                	ret

0000000080004406 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80004406:	1141                	addi	sp,sp,-16
    80004408:	e406                	sd	ra,8(sp)
    8000440a:	e022                	sd	s0,0(sp)
    8000440c:	0800                	addi	s0,sp,16
    8000440e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004410:	4585                	li	a1,1
    80004412:	debff0ef          	jal	800041fc <namex>
}
    80004416:	60a2                	ld	ra,8(sp)
    80004418:	6402                	ld	s0,0(sp)
    8000441a:	0141                	addi	sp,sp,16
    8000441c:	8082                	ret

000000008000441e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000441e:	1101                	addi	sp,sp,-32
    80004420:	ec06                	sd	ra,24(sp)
    80004422:	e822                	sd	s0,16(sp)
    80004424:	e426                	sd	s1,8(sp)
    80004426:	e04a                	sd	s2,0(sp)
    80004428:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000442a:	0024a917          	auipc	s2,0x24a
    8000442e:	78e90913          	addi	s2,s2,1934 # 8024ebb8 <log>
    80004432:	01892583          	lw	a1,24(s2)
    80004436:	02492503          	lw	a0,36(s2)
    8000443a:	884ff0ef          	jal	800034be <bread>
    8000443e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80004440:	02c92603          	lw	a2,44(s2)
    80004444:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004446:	00c05f63          	blez	a2,80004464 <write_head+0x46>
    8000444a:	0024a717          	auipc	a4,0x24a
    8000444e:	79e70713          	addi	a4,a4,1950 # 8024ebe8 <log+0x30>
    80004452:	87aa                	mv	a5,a0
    80004454:	060a                	slli	a2,a2,0x2
    80004456:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004458:	4314                	lw	a3,0(a4)
    8000445a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000445c:	0711                	addi	a4,a4,4
    8000445e:	0791                	addi	a5,a5,4
    80004460:	fec79ce3          	bne	a5,a2,80004458 <write_head+0x3a>
  }
  bwrite(buf);
    80004464:	8526                	mv	a0,s1
    80004466:	92eff0ef          	jal	80003594 <bwrite>
  brelse(buf);
    8000446a:	8526                	mv	a0,s1
    8000446c:	95aff0ef          	jal	800035c6 <brelse>
}
    80004470:	60e2                	ld	ra,24(sp)
    80004472:	6442                	ld	s0,16(sp)
    80004474:	64a2                	ld	s1,8(sp)
    80004476:	6902                	ld	s2,0(sp)
    80004478:	6105                	addi	sp,sp,32
    8000447a:	8082                	ret

000000008000447c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000447c:	0024a797          	auipc	a5,0x24a
    80004480:	7687a783          	lw	a5,1896(a5) # 8024ebe4 <log+0x2c>
    80004484:	0cf05163          	blez	a5,80004546 <install_trans+0xca>
{
    80004488:	715d                	addi	sp,sp,-80
    8000448a:	e486                	sd	ra,72(sp)
    8000448c:	e0a2                	sd	s0,64(sp)
    8000448e:	fc26                	sd	s1,56(sp)
    80004490:	f84a                	sd	s2,48(sp)
    80004492:	f44e                	sd	s3,40(sp)
    80004494:	f052                	sd	s4,32(sp)
    80004496:	ec56                	sd	s5,24(sp)
    80004498:	e85a                	sd	s6,16(sp)
    8000449a:	e45e                	sd	s7,8(sp)
    8000449c:	e062                	sd	s8,0(sp)
    8000449e:	0880                	addi	s0,sp,80
    800044a0:	8b2a                	mv	s6,a0
    800044a2:	0024aa97          	auipc	s5,0x24a
    800044a6:	746a8a93          	addi	s5,s5,1862 # 8024ebe8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044aa:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800044ac:	00004c17          	auipc	s8,0x4
    800044b0:	064c0c13          	addi	s8,s8,100 # 80008510 <etext+0x510>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800044b4:	0024aa17          	auipc	s4,0x24a
    800044b8:	704a0a13          	addi	s4,s4,1796 # 8024ebb8 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    800044bc:	40000b93          	li	s7,1024
    800044c0:	a025                	j	800044e8 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800044c2:	000aa603          	lw	a2,0(s5)
    800044c6:	85ce                	mv	a1,s3
    800044c8:	8562                	mv	a0,s8
    800044ca:	840fc0ef          	jal	8000050a <printk>
    800044ce:	a839                	j	800044ec <install_trans+0x70>
    brelse(lbuf);
    800044d0:	854a                	mv	a0,s2
    800044d2:	8f4ff0ef          	jal	800035c6 <brelse>
    brelse(dbuf);
    800044d6:	8526                	mv	a0,s1
    800044d8:	8eeff0ef          	jal	800035c6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800044dc:	2985                	addiw	s3,s3,1
    800044de:	0a91                	addi	s5,s5,4
    800044e0:	02ca2783          	lw	a5,44(s4)
    800044e4:	04f9d563          	bge	s3,a5,8000452e <install_trans+0xb2>
    if (recovering) {
    800044e8:	fc0b1de3          	bnez	s6,800044c2 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    800044ec:	018a2583          	lw	a1,24(s4)
    800044f0:	013585bb          	addw	a1,a1,s3
    800044f4:	2585                	addiw	a1,a1,1
    800044f6:	024a2503          	lw	a0,36(s4)
    800044fa:	fc5fe0ef          	jal	800034be <bread>
    800044fe:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80004500:	000aa583          	lw	a1,0(s5)
    80004504:	024a2503          	lw	a0,36(s4)
    80004508:	fb7fe0ef          	jal	800034be <bread>
    8000450c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    8000450e:	865e                	mv	a2,s7
    80004510:	05890593          	addi	a1,s2,88
    80004514:	05850513          	addi	a0,a0,88
    80004518:	8c3fc0ef          	jal	80000dda <memmove>
    bwrite(dbuf);                           // write dst to disk
    8000451c:	8526                	mv	a0,s1
    8000451e:	876ff0ef          	jal	80003594 <bwrite>
    if (recovering == 0)
    80004522:	fa0b17e3          	bnez	s6,800044d0 <install_trans+0x54>
      bunpin(dbuf);
    80004526:	8526                	mv	a0,s1
    80004528:	956ff0ef          	jal	8000367e <bunpin>
    8000452c:	b755                	j	800044d0 <install_trans+0x54>
}
    8000452e:	60a6                	ld	ra,72(sp)
    80004530:	6406                	ld	s0,64(sp)
    80004532:	74e2                	ld	s1,56(sp)
    80004534:	7942                	ld	s2,48(sp)
    80004536:	79a2                	ld	s3,40(sp)
    80004538:	7a02                	ld	s4,32(sp)
    8000453a:	6ae2                	ld	s5,24(sp)
    8000453c:	6b42                	ld	s6,16(sp)
    8000453e:	6ba2                	ld	s7,8(sp)
    80004540:	6c02                	ld	s8,0(sp)
    80004542:	6161                	addi	sp,sp,80
    80004544:	8082                	ret
    80004546:	8082                	ret

0000000080004548 <initlog>:
{
    80004548:	7179                	addi	sp,sp,-48
    8000454a:	f406                	sd	ra,40(sp)
    8000454c:	f022                	sd	s0,32(sp)
    8000454e:	ec26                	sd	s1,24(sp)
    80004550:	e84a                	sd	s2,16(sp)
    80004552:	e44e                	sd	s3,8(sp)
    80004554:	1800                	addi	s0,sp,48
    80004556:	892a                	mv	s2,a0
    80004558:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000455a:	0024a497          	auipc	s1,0x24a
    8000455e:	65e48493          	addi	s1,s1,1630 # 8024ebb8 <log>
    80004562:	00004597          	auipc	a1,0x4
    80004566:	fce58593          	addi	a1,a1,-50 # 80008530 <etext+0x530>
    8000456a:	8526                	mv	a0,s1
    8000456c:	ed0fc0ef          	jal	80000c3c <initlock>
  log.start = sb->logstart;
    80004570:	0149a583          	lw	a1,20(s3)
    80004574:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80004576:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000457a:	854a                	mv	a0,s2
    8000457c:	f43fe0ef          	jal	800034be <bread>
  log.lh.n = lh->n;
    80004580:	4d30                	lw	a2,88(a0)
    80004582:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004584:	00c05f63          	blez	a2,800045a2 <initlog+0x5a>
    80004588:	87aa                	mv	a5,a0
    8000458a:	0024a717          	auipc	a4,0x24a
    8000458e:	65e70713          	addi	a4,a4,1630 # 8024ebe8 <log+0x30>
    80004592:	060a                	slli	a2,a2,0x2
    80004594:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004596:	4ff4                	lw	a3,92(a5)
    80004598:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000459a:	0791                	addi	a5,a5,4
    8000459c:	0711                	addi	a4,a4,4
    8000459e:	fec79ce3          	bne	a5,a2,80004596 <initlog+0x4e>
  brelse(buf);
    800045a2:	824ff0ef          	jal	800035c6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045a6:	4505                	li	a0,1
    800045a8:	ed5ff0ef          	jal	8000447c <install_trans>
  log.lh.n = 0;
    800045ac:	0024a797          	auipc	a5,0x24a
    800045b0:	6207ac23          	sw	zero,1592(a5) # 8024ebe4 <log+0x2c>
  write_head(); // clear the log
    800045b4:	e6bff0ef          	jal	8000441e <write_head>
}
    800045b8:	70a2                	ld	ra,40(sp)
    800045ba:	7402                	ld	s0,32(sp)
    800045bc:	64e2                	ld	s1,24(sp)
    800045be:	6942                	ld	s2,16(sp)
    800045c0:	69a2                	ld	s3,8(sp)
    800045c2:	6145                	addi	sp,sp,48
    800045c4:	8082                	ret

00000000800045c6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800045c6:	1101                	addi	sp,sp,-32
    800045c8:	ec06                	sd	ra,24(sp)
    800045ca:	e822                	sd	s0,16(sp)
    800045cc:	e426                	sd	s1,8(sp)
    800045ce:	e04a                	sd	s2,0(sp)
    800045d0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800045d2:	0024a517          	auipc	a0,0x24a
    800045d6:	5e650513          	addi	a0,a0,1510 # 8024ebb8 <log>
    800045da:	edcfc0ef          	jal	80000cb6 <acquire>
  while (1) {
    if (log.committing) {
    800045de:	0024a497          	auipc	s1,0x24a
    800045e2:	5da48493          	addi	s1,s1,1498 # 8024ebb8 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    800045e6:	4979                	li	s2,30
    800045e8:	a821                	j	80004600 <begin_op+0x3a>
      sleep_prepare(&log);
    800045ea:	8526                	mv	a0,s1
    800045ec:	f4bfd0ef          	jal	80002536 <sleep_prepare>
      release(&log.lock);
    800045f0:	8526                	mv	a0,s1
    800045f2:	f4cfc0ef          	jal	80000d3e <release>
      sleep();
    800045f6:	f7dfd0ef          	jal	80002572 <sleep>
      acquire(&log.lock);
    800045fa:	8526                	mv	a0,s1
    800045fc:	ebafc0ef          	jal	80000cb6 <acquire>
    if (log.committing) {
    80004600:	509c                	lw	a5,32(s1)
    80004602:	f7e5                	bnez	a5,800045ea <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80004604:	4cd8                	lw	a4,28(s1)
    80004606:	2705                	addiw	a4,a4,1
    80004608:	0027179b          	slliw	a5,a4,0x2
    8000460c:	9fb9                	addw	a5,a5,a4
    8000460e:	0017979b          	slliw	a5,a5,0x1
    80004612:	54d4                	lw	a3,44(s1)
    80004614:	9fb5                	addw	a5,a5,a3
    80004616:	00f95e63          	bge	s2,a5,80004632 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    8000461a:	8526                	mv	a0,s1
    8000461c:	f1bfd0ef          	jal	80002536 <sleep_prepare>
      release(&log.lock);
    80004620:	8526                	mv	a0,s1
    80004622:	f1cfc0ef          	jal	80000d3e <release>
      sleep();
    80004626:	f4dfd0ef          	jal	80002572 <sleep>
      acquire(&log.lock);
    8000462a:	8526                	mv	a0,s1
    8000462c:	e8afc0ef          	jal	80000cb6 <acquire>
    80004630:	bfc1                	j	80004600 <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80004632:	0024a517          	auipc	a0,0x24a
    80004636:	58650513          	addi	a0,a0,1414 # 8024ebb8 <log>
    8000463a:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    8000463c:	f02fc0ef          	jal	80000d3e <release>
      break;
    }
  }
}
    80004640:	60e2                	ld	ra,24(sp)
    80004642:	6442                	ld	s0,16(sp)
    80004644:	64a2                	ld	s1,8(sp)
    80004646:	6902                	ld	s2,0(sp)
    80004648:	6105                	addi	sp,sp,32
    8000464a:	8082                	ret

000000008000464c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000464c:	7139                	addi	sp,sp,-64
    8000464e:	fc06                	sd	ra,56(sp)
    80004650:	f822                	sd	s0,48(sp)
    80004652:	f426                	sd	s1,40(sp)
    80004654:	f04a                	sd	s2,32(sp)
    80004656:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004658:	0024a497          	auipc	s1,0x24a
    8000465c:	56048493          	addi	s1,s1,1376 # 8024ebb8 <log>
    80004660:	8526                	mv	a0,s1
    80004662:	e54fc0ef          	jal	80000cb6 <acquire>
  log.outstanding -= 1;
    80004666:	4cdc                	lw	a5,28(s1)
    80004668:	37fd                	addiw	a5,a5,-1
    8000466a:	893e                	mv	s2,a5
    8000466c:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    8000466e:	509c                	lw	a5,32(s1)
    80004670:	e3b1                	bnez	a5,800046b4 <end_op+0x68>
    panic("log.committing");
  if (log.outstanding == 0) {
    80004672:	04091b63          	bnez	s2,800046c8 <end_op+0x7c>
    do_commit = 1;
    log.committing = 1;
    80004676:	0024a497          	auipc	s1,0x24a
    8000467a:	54248493          	addi	s1,s1,1346 # 8024ebb8 <log>
    8000467e:	4785                	li	a5,1
    80004680:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004682:	8526                	mv	a0,s1
    80004684:	ebafc0ef          	jal	80000d3e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004688:	54dc                	lw	a5,44(s1)
    8000468a:	04f04f63          	bgtz	a5,800046e8 <end_op+0x9c>
    acquire(&log.lock);
    8000468e:	0024a497          	auipc	s1,0x24a
    80004692:	52a48493          	addi	s1,s1,1322 # 8024ebb8 <log>
    80004696:	8526                	mv	a0,s1
    80004698:	e1efc0ef          	jal	80000cb6 <acquire>
    log.committing = 0;
    8000469c:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    800046a0:	549c                	lw	a5,40(s1)
    800046a2:	2785                	addiw	a5,a5,1
    800046a4:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    800046a6:	8526                	mv	a0,s1
    800046a8:	efbfd0ef          	jal	800025a2 <wakeup>
    release(&log.lock);
    800046ac:	8526                	mv	a0,s1
    800046ae:	e90fc0ef          	jal	80000d3e <release>
}
    800046b2:	a02d                	j	800046dc <end_op+0x90>
    800046b4:	ec4e                	sd	s3,24(sp)
    800046b6:	e852                	sd	s4,16(sp)
    800046b8:	e456                	sd	s5,8(sp)
    800046ba:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800046bc:	00004517          	auipc	a0,0x4
    800046c0:	e7c50513          	addi	a0,a0,-388 # 80008538 <etext+0x538>
    800046c4:	92afc0ef          	jal	800007ee <panic>
    wakeup(&log);
    800046c8:	0024a497          	auipc	s1,0x24a
    800046cc:	4f048493          	addi	s1,s1,1264 # 8024ebb8 <log>
    800046d0:	8526                	mv	a0,s1
    800046d2:	ed1fd0ef          	jal	800025a2 <wakeup>
  release(&log.lock);
    800046d6:	8526                	mv	a0,s1
    800046d8:	e66fc0ef          	jal	80000d3e <release>
}
    800046dc:	70e2                	ld	ra,56(sp)
    800046de:	7442                	ld	s0,48(sp)
    800046e0:	74a2                	ld	s1,40(sp)
    800046e2:	7902                	ld	s2,32(sp)
    800046e4:	6121                	addi	sp,sp,64
    800046e6:	8082                	ret
    800046e8:	ec4e                	sd	s3,24(sp)
    800046ea:	e852                	sd	s4,16(sp)
    800046ec:	e456                	sd	s5,8(sp)
    800046ee:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800046f0:	0024aa97          	auipc	s5,0x24a
    800046f4:	4f8a8a93          	addi	s5,s5,1272 # 8024ebe8 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    800046f8:	0024aa17          	auipc	s4,0x24a
    800046fc:	4c0a0a13          	addi	s4,s4,1216 # 8024ebb8 <log>
    memmove(to->data, from->data, BSIZE);
    80004700:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80004704:	018a2583          	lw	a1,24(s4)
    80004708:	012585bb          	addw	a1,a1,s2
    8000470c:	2585                	addiw	a1,a1,1
    8000470e:	024a2503          	lw	a0,36(s4)
    80004712:	dadfe0ef          	jal	800034be <bread>
    80004716:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004718:	000aa583          	lw	a1,0(s5)
    8000471c:	024a2503          	lw	a0,36(s4)
    80004720:	d9ffe0ef          	jal	800034be <bread>
    80004724:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004726:	865a                	mv	a2,s6
    80004728:	05850593          	addi	a1,a0,88
    8000472c:	05848513          	addi	a0,s1,88
    80004730:	eaafc0ef          	jal	80000dda <memmove>
    bwrite(to); // write the log
    80004734:	8526                	mv	a0,s1
    80004736:	e5ffe0ef          	jal	80003594 <bwrite>
    brelse(from);
    8000473a:	854e                	mv	a0,s3
    8000473c:	e8bfe0ef          	jal	800035c6 <brelse>
    brelse(to);
    80004740:	8526                	mv	a0,s1
    80004742:	e85fe0ef          	jal	800035c6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004746:	2905                	addiw	s2,s2,1
    80004748:	0a91                	addi	s5,s5,4
    8000474a:	02ca2783          	lw	a5,44(s4)
    8000474e:	faf94be3          	blt	s2,a5,80004704 <end_op+0xb8>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80004752:	ccdff0ef          	jal	8000441e <write_head>
    install_trans(0); // Now install writes to home locations
    80004756:	4501                	li	a0,0
    80004758:	d25ff0ef          	jal	8000447c <install_trans>
    log.lh.n = 0;
    8000475c:	0024a797          	auipc	a5,0x24a
    80004760:	4807a423          	sw	zero,1160(a5) # 8024ebe4 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80004764:	cbbff0ef          	jal	8000441e <write_head>
    80004768:	69e2                	ld	s3,24(sp)
    8000476a:	6a42                	ld	s4,16(sp)
    8000476c:	6aa2                	ld	s5,8(sp)
    8000476e:	6b02                	ld	s6,0(sp)
    80004770:	bf39                	j	8000468e <end_op+0x42>

0000000080004772 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004772:	1101                	addi	sp,sp,-32
    80004774:	ec06                	sd	ra,24(sp)
    80004776:	e822                	sd	s0,16(sp)
    80004778:	e426                	sd	s1,8(sp)
    8000477a:	e04a                	sd	s2,0(sp)
    8000477c:	1000                	addi	s0,sp,32
    8000477e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004780:	0024a917          	auipc	s2,0x24a
    80004784:	43890913          	addi	s2,s2,1080 # 8024ebb8 <log>
    80004788:	854a                	mv	a0,s2
    8000478a:	d2cfc0ef          	jal	80000cb6 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000478e:	02c92603          	lw	a2,44(s2)
    80004792:	47f5                	li	a5,29
    80004794:	04c7cc63          	blt	a5,a2,800047ec <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004798:	0024a797          	auipc	a5,0x24a
    8000479c:	43c7a783          	lw	a5,1084(a5) # 8024ebd4 <log+0x1c>
    800047a0:	04f05c63          	blez	a5,800047f8 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047a4:	4781                	li	a5,0
    800047a6:	04c05f63          	blez	a2,80004804 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    800047aa:	44cc                	lw	a1,12(s1)
    800047ac:	0024a717          	auipc	a4,0x24a
    800047b0:	43c70713          	addi	a4,a4,1084 # 8024ebe8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047b4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    800047b6:	4314                	lw	a3,0(a4)
    800047b8:	04b68663          	beq	a3,a1,80004804 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    800047bc:	2785                	addiw	a5,a5,1
    800047be:	0711                	addi	a4,a4,4
    800047c0:	fef61be3          	bne	a2,a5,800047b6 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047c4:	0621                	addi	a2,a2,8
    800047c6:	060a                	slli	a2,a2,0x2
    800047c8:	0024a797          	auipc	a5,0x24a
    800047cc:	3f078793          	addi	a5,a5,1008 # 8024ebb8 <log>
    800047d0:	97b2                	add	a5,a5,a2
    800047d2:	44d8                	lw	a4,12(s1)
    800047d4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    800047d6:	8526                	mv	a0,s1
    800047d8:	e73fe0ef          	jal	8000364a <bpin>
    log.lh.n++;
    800047dc:	0024a717          	auipc	a4,0x24a
    800047e0:	3dc70713          	addi	a4,a4,988 # 8024ebb8 <log>
    800047e4:	575c                	lw	a5,44(a4)
    800047e6:	2785                	addiw	a5,a5,1
    800047e8:	d75c                	sw	a5,44(a4)
    800047ea:	a80d                	j	8000481c <log_write+0xaa>
    panic("too big a transaction");
    800047ec:	00004517          	auipc	a0,0x4
    800047f0:	d5c50513          	addi	a0,a0,-676 # 80008548 <etext+0x548>
    800047f4:	ffbfb0ef          	jal	800007ee <panic>
    panic("log_write outside of trans");
    800047f8:	00004517          	auipc	a0,0x4
    800047fc:	d6850513          	addi	a0,a0,-664 # 80008560 <etext+0x560>
    80004800:	feffb0ef          	jal	800007ee <panic>
  log.lh.block[i] = b->blockno;
    80004804:	00878693          	addi	a3,a5,8
    80004808:	068a                	slli	a3,a3,0x2
    8000480a:	0024a717          	auipc	a4,0x24a
    8000480e:	3ae70713          	addi	a4,a4,942 # 8024ebb8 <log>
    80004812:	9736                	add	a4,a4,a3
    80004814:	44d4                	lw	a3,12(s1)
    80004816:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004818:	faf60fe3          	beq	a2,a5,800047d6 <log_write+0x64>
  }
  release(&log.lock);
    8000481c:	0024a517          	auipc	a0,0x24a
    80004820:	39c50513          	addi	a0,a0,924 # 8024ebb8 <log>
    80004824:	d1afc0ef          	jal	80000d3e <release>
}
    80004828:	60e2                	ld	ra,24(sp)
    8000482a:	6442                	ld	s0,16(sp)
    8000482c:	64a2                	ld	s1,8(sp)
    8000482e:	6902                	ld	s2,0(sp)
    80004830:	6105                	addi	sp,sp,32
    80004832:	8082                	ret

0000000080004834 <sys_sync>:

uint64
sys_sync(void)
{
    80004834:	1101                	addi	sp,sp,-32
    80004836:	ec06                	sd	ra,24(sp)
    80004838:	e822                	sd	s0,16(sp)
    8000483a:	e426                	sd	s1,8(sp)
    8000483c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000483e:	0024a497          	auipc	s1,0x24a
    80004842:	37a48493          	addi	s1,s1,890 # 8024ebb8 <log>
    80004846:	8526                	mv	a0,s1
    80004848:	c6efc0ef          	jal	80000cb6 <acquire>
  if (log.committing || log.outstanding > 0) {
    8000484c:	509c                	lw	a5,32(s1)
    8000484e:	e799                	bnez	a5,8000485c <sys_sync+0x28>
    80004850:	0024a797          	auipc	a5,0x24a
    80004854:	3847a783          	lw	a5,900(a5) # 8024ebd4 <log+0x1c>
    80004858:	02f05a63          	blez	a5,8000488c <sys_sync+0x58>
    8000485c:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    8000485e:	0024a917          	auipc	s2,0x24a
    80004862:	38292903          	lw	s2,898(s2) # 8024ebe0 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    80004866:	0024a497          	auipc	s1,0x24a
    8000486a:	35248493          	addi	s1,s1,850 # 8024ebb8 <log>
    8000486e:	8526                	mv	a0,s1
    80004870:	cc7fd0ef          	jal	80002536 <sleep_prepare>
      release(&log.lock);
    80004874:	8526                	mv	a0,s1
    80004876:	cc8fc0ef          	jal	80000d3e <release>
      sleep();
    8000487a:	cf9fd0ef          	jal	80002572 <sleep>
      acquire(&log.lock);
    8000487e:	8526                	mv	a0,s1
    80004880:	c36fc0ef          	jal	80000cb6 <acquire>
    while (log.ncommit < n) {
    80004884:	549c                	lw	a5,40(s1)
    80004886:	fef954e3          	bge	s2,a5,8000486e <sys_sync+0x3a>
    8000488a:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    8000488c:	0024a517          	auipc	a0,0x24a
    80004890:	32c50513          	addi	a0,a0,812 # 8024ebb8 <log>
    80004894:	caafc0ef          	jal	80000d3e <release>
  return 0;
}
    80004898:	4501                	li	a0,0
    8000489a:	60e2                	ld	ra,24(sp)
    8000489c:	6442                	ld	s0,16(sp)
    8000489e:	64a2                	ld	s1,8(sp)
    800048a0:	6105                	addi	sp,sp,32
    800048a2:	8082                	ret

00000000800048a4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800048a4:	1101                	addi	sp,sp,-32
    800048a6:	ec06                	sd	ra,24(sp)
    800048a8:	e822                	sd	s0,16(sp)
    800048aa:	e426                	sd	s1,8(sp)
    800048ac:	e04a                	sd	s2,0(sp)
    800048ae:	1000                	addi	s0,sp,32
    800048b0:	84aa                	mv	s1,a0
    800048b2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800048b4:	00004597          	auipc	a1,0x4
    800048b8:	ccc58593          	addi	a1,a1,-820 # 80008580 <etext+0x580>
    800048bc:	0521                	addi	a0,a0,8
    800048be:	b7efc0ef          	jal	80000c3c <initlock>
  lk->name = name;
    800048c2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800048c6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048ca:	0204a423          	sw	zero,40(s1)
}
    800048ce:	60e2                	ld	ra,24(sp)
    800048d0:	6442                	ld	s0,16(sp)
    800048d2:	64a2                	ld	s1,8(sp)
    800048d4:	6902                	ld	s2,0(sp)
    800048d6:	6105                	addi	sp,sp,32
    800048d8:	8082                	ret

00000000800048da <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800048da:	1101                	addi	sp,sp,-32
    800048dc:	ec06                	sd	ra,24(sp)
    800048de:	e822                	sd	s0,16(sp)
    800048e0:	e426                	sd	s1,8(sp)
    800048e2:	e04a                	sd	s2,0(sp)
    800048e4:	1000                	addi	s0,sp,32
    800048e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048e8:	00850913          	addi	s2,a0,8
    800048ec:	854a                	mv	a0,s2
    800048ee:	bc8fc0ef          	jal	80000cb6 <acquire>
  while (lk->locked) {
    800048f2:	409c                	lw	a5,0(s1)
    800048f4:	cf91                	beqz	a5,80004910 <acquiresleep+0x36>
    sleep_prepare(lk);
    800048f6:	8526                	mv	a0,s1
    800048f8:	c3ffd0ef          	jal	80002536 <sleep_prepare>
    release(&lk->lk);
    800048fc:	854a                	mv	a0,s2
    800048fe:	c40fc0ef          	jal	80000d3e <release>
    sleep();
    80004902:	c71fd0ef          	jal	80002572 <sleep>
    acquire(&lk->lk);
    80004906:	854a                	mv	a0,s2
    80004908:	baefc0ef          	jal	80000cb6 <acquire>
  while (lk->locked) {
    8000490c:	409c                	lw	a5,0(s1)
    8000490e:	f7e5                	bnez	a5,800048f6 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004910:	4785                	li	a5,1
    80004912:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004914:	d82fd0ef          	jal	80001e96 <myproc>
    80004918:	591c                	lw	a5,48(a0)
    8000491a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000491c:	854a                	mv	a0,s2
    8000491e:	c20fc0ef          	jal	80000d3e <release>
}
    80004922:	60e2                	ld	ra,24(sp)
    80004924:	6442                	ld	s0,16(sp)
    80004926:	64a2                	ld	s1,8(sp)
    80004928:	6902                	ld	s2,0(sp)
    8000492a:	6105                	addi	sp,sp,32
    8000492c:	8082                	ret

000000008000492e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000492e:	1101                	addi	sp,sp,-32
    80004930:	ec06                	sd	ra,24(sp)
    80004932:	e822                	sd	s0,16(sp)
    80004934:	e426                	sd	s1,8(sp)
    80004936:	e04a                	sd	s2,0(sp)
    80004938:	1000                	addi	s0,sp,32
    8000493a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000493c:	00850913          	addi	s2,a0,8
    80004940:	854a                	mv	a0,s2
    80004942:	b74fc0ef          	jal	80000cb6 <acquire>
  lk->locked = 0;
    80004946:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000494a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000494e:	8526                	mv	a0,s1
    80004950:	c53fd0ef          	jal	800025a2 <wakeup>
  release(&lk->lk);
    80004954:	854a                	mv	a0,s2
    80004956:	be8fc0ef          	jal	80000d3e <release>
}
    8000495a:	60e2                	ld	ra,24(sp)
    8000495c:	6442                	ld	s0,16(sp)
    8000495e:	64a2                	ld	s1,8(sp)
    80004960:	6902                	ld	s2,0(sp)
    80004962:	6105                	addi	sp,sp,32
    80004964:	8082                	ret

0000000080004966 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004966:	7179                	addi	sp,sp,-48
    80004968:	f406                	sd	ra,40(sp)
    8000496a:	f022                	sd	s0,32(sp)
    8000496c:	ec26                	sd	s1,24(sp)
    8000496e:	e84a                	sd	s2,16(sp)
    80004970:	1800                	addi	s0,sp,48
    80004972:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80004974:	00850913          	addi	s2,a0,8
    80004978:	854a                	mv	a0,s2
    8000497a:	b3cfc0ef          	jal	80000cb6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000497e:	409c                	lw	a5,0(s1)
    80004980:	ef81                	bnez	a5,80004998 <holdingsleep+0x32>
    80004982:	4481                	li	s1,0
  release(&lk->lk);
    80004984:	854a                	mv	a0,s2
    80004986:	bb8fc0ef          	jal	80000d3e <release>
  return r;
}
    8000498a:	8526                	mv	a0,s1
    8000498c:	70a2                	ld	ra,40(sp)
    8000498e:	7402                	ld	s0,32(sp)
    80004990:	64e2                	ld	s1,24(sp)
    80004992:	6942                	ld	s2,16(sp)
    80004994:	6145                	addi	sp,sp,48
    80004996:	8082                	ret
    80004998:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000499a:	0284a983          	lw	s3,40(s1)
    8000499e:	cf8fd0ef          	jal	80001e96 <myproc>
    800049a2:	5904                	lw	s1,48(a0)
    800049a4:	413484b3          	sub	s1,s1,s3
    800049a8:	0014b493          	seqz	s1,s1
    800049ac:	69a2                	ld	s3,8(sp)
    800049ae:	bfd9                	j	80004984 <holdingsleep+0x1e>

00000000800049b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800049b0:	1141                	addi	sp,sp,-16
    800049b2:	e406                	sd	ra,8(sp)
    800049b4:	e022                	sd	s0,0(sp)
    800049b6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800049b8:	00004597          	auipc	a1,0x4
    800049bc:	bd858593          	addi	a1,a1,-1064 # 80008590 <etext+0x590>
    800049c0:	0024a517          	auipc	a0,0x24a
    800049c4:	34050513          	addi	a0,a0,832 # 8024ed00 <ftable>
    800049c8:	a74fc0ef          	jal	80000c3c <initlock>
}
    800049cc:	60a2                	ld	ra,8(sp)
    800049ce:	6402                	ld	s0,0(sp)
    800049d0:	0141                	addi	sp,sp,16
    800049d2:	8082                	ret

00000000800049d4 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800049d4:	1101                	addi	sp,sp,-32
    800049d6:	ec06                	sd	ra,24(sp)
    800049d8:	e822                	sd	s0,16(sp)
    800049da:	e426                	sd	s1,8(sp)
    800049dc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800049de:	0024a517          	auipc	a0,0x24a
    800049e2:	32250513          	addi	a0,a0,802 # 8024ed00 <ftable>
    800049e6:	ad0fc0ef          	jal	80000cb6 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800049ea:	0024a497          	auipc	s1,0x24a
    800049ee:	32e48493          	addi	s1,s1,814 # 8024ed18 <ftable+0x18>
    800049f2:	0024b717          	auipc	a4,0x24b
    800049f6:	2c670713          	addi	a4,a4,710 # 8024fcb8 <disk>
    if (f->ref == 0) {
    800049fa:	40dc                	lw	a5,4(s1)
    800049fc:	cf89                	beqz	a5,80004a16 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800049fe:	02848493          	addi	s1,s1,40
    80004a02:	fee49ce3          	bne	s1,a4,800049fa <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a06:	0024a517          	auipc	a0,0x24a
    80004a0a:	2fa50513          	addi	a0,a0,762 # 8024ed00 <ftable>
    80004a0e:	b30fc0ef          	jal	80000d3e <release>
  return 0;
    80004a12:	4481                	li	s1,0
    80004a14:	a809                	j	80004a26 <filealloc+0x52>
      f->ref = 1;
    80004a16:	4785                	li	a5,1
    80004a18:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004a1a:	0024a517          	auipc	a0,0x24a
    80004a1e:	2e650513          	addi	a0,a0,742 # 8024ed00 <ftable>
    80004a22:	b1cfc0ef          	jal	80000d3e <release>
}
    80004a26:	8526                	mv	a0,s1
    80004a28:	60e2                	ld	ra,24(sp)
    80004a2a:	6442                	ld	s0,16(sp)
    80004a2c:	64a2                	ld	s1,8(sp)
    80004a2e:	6105                	addi	sp,sp,32
    80004a30:	8082                	ret

0000000080004a32 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004a32:	1101                	addi	sp,sp,-32
    80004a34:	ec06                	sd	ra,24(sp)
    80004a36:	e822                	sd	s0,16(sp)
    80004a38:	e426                	sd	s1,8(sp)
    80004a3a:	1000                	addi	s0,sp,32
    80004a3c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004a3e:	0024a517          	auipc	a0,0x24a
    80004a42:	2c250513          	addi	a0,a0,706 # 8024ed00 <ftable>
    80004a46:	a70fc0ef          	jal	80000cb6 <acquire>
  if (f->ref < 1)
    80004a4a:	40dc                	lw	a5,4(s1)
    80004a4c:	02f05063          	blez	a5,80004a6c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004a50:	2785                	addiw	a5,a5,1
    80004a52:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004a54:	0024a517          	auipc	a0,0x24a
    80004a58:	2ac50513          	addi	a0,a0,684 # 8024ed00 <ftable>
    80004a5c:	ae2fc0ef          	jal	80000d3e <release>
  return f;
}
    80004a60:	8526                	mv	a0,s1
    80004a62:	60e2                	ld	ra,24(sp)
    80004a64:	6442                	ld	s0,16(sp)
    80004a66:	64a2                	ld	s1,8(sp)
    80004a68:	6105                	addi	sp,sp,32
    80004a6a:	8082                	ret
    panic("filedup");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	b2c50513          	addi	a0,a0,-1236 # 80008598 <etext+0x598>
    80004a74:	d7bfb0ef          	jal	800007ee <panic>

0000000080004a78 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a78:	7139                	addi	sp,sp,-64
    80004a7a:	fc06                	sd	ra,56(sp)
    80004a7c:	f822                	sd	s0,48(sp)
    80004a7e:	f426                	sd	s1,40(sp)
    80004a80:	0080                	addi	s0,sp,64
    80004a82:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a84:	0024a517          	auipc	a0,0x24a
    80004a88:	27c50513          	addi	a0,a0,636 # 8024ed00 <ftable>
    80004a8c:	a2afc0ef          	jal	80000cb6 <acquire>
  if (f->ref < 1)
    80004a90:	40dc                	lw	a5,4(s1)
    80004a92:	04f05863          	blez	a5,80004ae2 <fileclose+0x6a>
    panic("fileclose");
  if (--f->ref > 0) {
    80004a96:	37fd                	addiw	a5,a5,-1
    80004a98:	c0dc                	sw	a5,4(s1)
    80004a9a:	04f04e63          	bgtz	a5,80004af6 <fileclose+0x7e>
    80004a9e:	f04a                	sd	s2,32(sp)
    80004aa0:	ec4e                	sd	s3,24(sp)
    80004aa2:	e852                	sd	s4,16(sp)
    80004aa4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004aa6:	0004a903          	lw	s2,0(s1)
    80004aaa:	0094ca83          	lbu	s5,9(s1)
    80004aae:	0104ba03          	ld	s4,16(s1)
    80004ab2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004ab6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004aba:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004abe:	0024a517          	auipc	a0,0x24a
    80004ac2:	24250513          	addi	a0,a0,578 # 8024ed00 <ftable>
    80004ac6:	a78fc0ef          	jal	80000d3e <release>

  if (ff.type == FD_PIPE) {
    80004aca:	4785                	li	a5,1
    80004acc:	04f90063          	beq	s2,a5,80004b0c <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80004ad0:	3979                	addiw	s2,s2,-2
    80004ad2:	4785                	li	a5,1
    80004ad4:	0527f563          	bgeu	a5,s2,80004b1e <fileclose+0xa6>
    80004ad8:	7902                	ld	s2,32(sp)
    80004ada:	69e2                	ld	s3,24(sp)
    80004adc:	6a42                	ld	s4,16(sp)
    80004ade:	6aa2                	ld	s5,8(sp)
    80004ae0:	a00d                	j	80004b02 <fileclose+0x8a>
    80004ae2:	f04a                	sd	s2,32(sp)
    80004ae4:	ec4e                	sd	s3,24(sp)
    80004ae6:	e852                	sd	s4,16(sp)
    80004ae8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004aea:	00004517          	auipc	a0,0x4
    80004aee:	ab650513          	addi	a0,a0,-1354 # 800085a0 <etext+0x5a0>
    80004af2:	cfdfb0ef          	jal	800007ee <panic>
    release(&ftable.lock);
    80004af6:	0024a517          	auipc	a0,0x24a
    80004afa:	20a50513          	addi	a0,a0,522 # 8024ed00 <ftable>
    80004afe:	a40fc0ef          	jal	80000d3e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b02:	70e2                	ld	ra,56(sp)
    80004b04:	7442                	ld	s0,48(sp)
    80004b06:	74a2                	ld	s1,40(sp)
    80004b08:	6121                	addi	sp,sp,64
    80004b0a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004b0c:	85d6                	mv	a1,s5
    80004b0e:	8552                	mv	a0,s4
    80004b10:	356000ef          	jal	80004e66 <pipeclose>
    80004b14:	7902                	ld	s2,32(sp)
    80004b16:	69e2                	ld	s3,24(sp)
    80004b18:	6a42                	ld	s4,16(sp)
    80004b1a:	6aa2                	ld	s5,8(sp)
    80004b1c:	b7dd                	j	80004b02 <fileclose+0x8a>
    begin_op();
    80004b1e:	aa9ff0ef          	jal	800045c6 <begin_op>
    iput(ff.ip);
    80004b22:	854e                	mv	a0,s3
    80004b24:	9c2ff0ef          	jal	80003ce6 <iput>
    end_op();
    80004b28:	b25ff0ef          	jal	8000464c <end_op>
    80004b2c:	7902                	ld	s2,32(sp)
    80004b2e:	69e2                	ld	s3,24(sp)
    80004b30:	6a42                	ld	s4,16(sp)
    80004b32:	6aa2                	ld	s5,8(sp)
    80004b34:	b7f9                	j	80004b02 <fileclose+0x8a>

0000000080004b36 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004b36:	715d                	addi	sp,sp,-80
    80004b38:	e486                	sd	ra,72(sp)
    80004b3a:	e0a2                	sd	s0,64(sp)
    80004b3c:	fc26                	sd	s1,56(sp)
    80004b3e:	f44e                	sd	s3,40(sp)
    80004b40:	0880                	addi	s0,sp,80
    80004b42:	84aa                	mv	s1,a0
    80004b44:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004b46:	b50fd0ef          	jal	80001e96 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004b4a:	409c                	lw	a5,0(s1)
    80004b4c:	37f9                	addiw	a5,a5,-2
    80004b4e:	4705                	li	a4,1
    80004b50:	04f76463          	bltu	a4,a5,80004b98 <filestat+0x62>
    80004b54:	f84a                	sd	s2,48(sp)
    80004b56:	f052                	sd	s4,32(sp)
    80004b58:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b5a:	6c88                	ld	a0,24(s1)
    80004b5c:	808ff0ef          	jal	80003b64 <ilock>
    stati(f->ip, &st);
    80004b60:	fb840a13          	addi	s4,s0,-72
    80004b64:	85d2                	mv	a1,s4
    80004b66:	6c88                	ld	a0,24(s1)
    80004b68:	ba8ff0ef          	jal	80003f10 <stati>
    iunlock(f->ip);
    80004b6c:	6c88                	ld	a0,24(s1)
    80004b6e:	8a4ff0ef          	jal	80003c12 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    80004b72:	4761                	li	a4,24
    80004b74:	86d2                	mv	a3,s4
    80004b76:	864e                	mv	a2,s3
    80004b78:	05093583          	ld	a1,80(s2)
    80004b7c:	05893503          	ld	a0,88(s2)
    80004b80:	da1fc0ef          	jal	80001920 <copyout>
    80004b84:	41f5551b          	sraiw	a0,a0,0x1f
    80004b88:	7942                	ld	s2,48(sp)
    80004b8a:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004b8c:	60a6                	ld	ra,72(sp)
    80004b8e:	6406                	ld	s0,64(sp)
    80004b90:	74e2                	ld	s1,56(sp)
    80004b92:	79a2                	ld	s3,40(sp)
    80004b94:	6161                	addi	sp,sp,80
    80004b96:	8082                	ret
  return -1;
    80004b98:	557d                	li	a0,-1
    80004b9a:	bfcd                	j	80004b8c <filestat+0x56>

0000000080004b9c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b9c:	7179                	addi	sp,sp,-48
    80004b9e:	f406                	sd	ra,40(sp)
    80004ba0:	f022                	sd	s0,32(sp)
    80004ba2:	e84a                	sd	s2,16(sp)
    80004ba4:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    80004ba6:	00854783          	lbu	a5,8(a0)
    80004baa:	c3c5                	beqz	a5,80004c4a <fileread+0xae>
    80004bac:	ec26                	sd	s1,24(sp)
    80004bae:	e44e                	sd	s3,8(sp)
    80004bb0:	84aa                	mv	s1,a0
    80004bb2:	89ae                	mv	s3,a1
    80004bb4:	8932                	mv	s2,a2
    80004bb6:	08064c63          	bltz	a2,80004c4e <fileread+0xb2>
    return -1;

  if (f->type == FD_PIPE) {
    80004bba:	411c                	lw	a5,0(a0)
    80004bbc:	4705                	li	a4,1
    80004bbe:	04e78363          	beq	a5,a4,80004c04 <fileread+0x68>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004bc2:	470d                	li	a4,3
    80004bc4:	04e78763          	beq	a5,a4,80004c12 <fileread+0x76>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004bc8:	4709                	li	a4,2
    80004bca:	06e79a63          	bne	a5,a4,80004c3e <fileread+0xa2>
    ilock(f->ip);
    80004bce:	6d08                	ld	a0,24(a0)
    80004bd0:	f95fe0ef          	jal	80003b64 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004bd4:	874a                	mv	a4,s2
    80004bd6:	5094                	lw	a3,32(s1)
    80004bd8:	864e                	mv	a2,s3
    80004bda:	4585                	li	a1,1
    80004bdc:	6c88                	ld	a0,24(s1)
    80004bde:	b60ff0ef          	jal	80003f3e <readi>
    80004be2:	892a                	mv	s2,a0
    80004be4:	00a05563          	blez	a0,80004bee <fileread+0x52>
      f->off += r;
    80004be8:	509c                	lw	a5,32(s1)
    80004bea:	9fa9                	addw	a5,a5,a0
    80004bec:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004bee:	6c88                	ld	a0,24(s1)
    80004bf0:	822ff0ef          	jal	80003c12 <iunlock>
    80004bf4:	64e2                	ld	s1,24(sp)
    80004bf6:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	70a2                	ld	ra,40(sp)
    80004bfc:	7402                	ld	s0,32(sp)
    80004bfe:	6942                	ld	s2,16(sp)
    80004c00:	6145                	addi	sp,sp,48
    80004c02:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c04:	6908                	ld	a0,16(a0)
    80004c06:	3d4000ef          	jal	80004fda <piperead>
    80004c0a:	892a                	mv	s2,a0
    80004c0c:	64e2                	ld	s1,24(sp)
    80004c0e:	69a2                	ld	s3,8(sp)
    80004c10:	b7e5                	j	80004bf8 <fileread+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004c12:	02451783          	lh	a5,36(a0)
    80004c16:	03079693          	slli	a3,a5,0x30
    80004c1a:	92c1                	srli	a3,a3,0x30
    80004c1c:	4725                	li	a4,9
    80004c1e:	02d76c63          	bltu	a4,a3,80004c56 <fileread+0xba>
    80004c22:	0792                	slli	a5,a5,0x4
    80004c24:	0024a717          	auipc	a4,0x24a
    80004c28:	03c70713          	addi	a4,a4,60 # 8024ec60 <devsw>
    80004c2c:	97ba                	add	a5,a5,a4
    80004c2e:	639c                	ld	a5,0(a5)
    80004c30:	c79d                	beqz	a5,80004c5e <fileread+0xc2>
    r = devsw[f->major].read(1, addr, n);
    80004c32:	4505                	li	a0,1
    80004c34:	9782                	jalr	a5
    80004c36:	892a                	mv	s2,a0
    80004c38:	64e2                	ld	s1,24(sp)
    80004c3a:	69a2                	ld	s3,8(sp)
    80004c3c:	bf75                	j	80004bf8 <fileread+0x5c>
    panic("fileread");
    80004c3e:	00004517          	auipc	a0,0x4
    80004c42:	97250513          	addi	a0,a0,-1678 # 800085b0 <etext+0x5b0>
    80004c46:	ba9fb0ef          	jal	800007ee <panic>
    return -1;
    80004c4a:	597d                	li	s2,-1
    80004c4c:	b775                	j	80004bf8 <fileread+0x5c>
    80004c4e:	597d                	li	s2,-1
    80004c50:	64e2                	ld	s1,24(sp)
    80004c52:	69a2                	ld	s3,8(sp)
    80004c54:	b755                	j	80004bf8 <fileread+0x5c>
      return -1;
    80004c56:	597d                	li	s2,-1
    80004c58:	64e2                	ld	s1,24(sp)
    80004c5a:	69a2                	ld	s3,8(sp)
    80004c5c:	bf71                	j	80004bf8 <fileread+0x5c>
    80004c5e:	597d                	li	s2,-1
    80004c60:	64e2                	ld	s1,24(sp)
    80004c62:	69a2                	ld	s3,8(sp)
    80004c64:	bf51                	j	80004bf8 <fileread+0x5c>

0000000080004c66 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    80004c66:	00954783          	lbu	a5,9(a0)
    80004c6a:	10078863          	beqz	a5,80004d7a <filewrite+0x114>
{
    80004c6e:	711d                	addi	sp,sp,-96
    80004c70:	ec86                	sd	ra,88(sp)
    80004c72:	e8a2                	sd	s0,80(sp)
    80004c74:	e0ca                	sd	s2,64(sp)
    80004c76:	f456                	sd	s5,40(sp)
    80004c78:	f05a                	sd	s6,32(sp)
    80004c7a:	1080                	addi	s0,sp,96
    80004c7c:	892a                	mv	s2,a0
    80004c7e:	8b2e                	mv	s6,a1
    80004c80:	8ab2                	mv	s5,a2
  if (f->writable == 0 || n < 0)
    80004c82:	0e064e63          	bltz	a2,80004d7e <filewrite+0x118>
    return -1;

  if (f->type == FD_PIPE) {
    80004c86:	411c                	lw	a5,0(a0)
    80004c88:	4705                	li	a4,1
    80004c8a:	02e78963          	beq	a5,a4,80004cbc <filewrite+0x56>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004c8e:	470d                	li	a4,3
    80004c90:	02e78a63          	beq	a5,a4,80004cc4 <filewrite+0x5e>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004c94:	4709                	li	a4,2
    80004c96:	0ce79663          	bne	a5,a4,80004d62 <filewrite+0xfc>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    80004c9a:	0ec05863          	blez	a2,80004d8a <filewrite+0x124>
    80004c9e:	e4a6                	sd	s1,72(sp)
    80004ca0:	fc4e                	sd	s3,56(sp)
    80004ca2:	f852                	sd	s4,48(sp)
    80004ca4:	ec5e                	sd	s7,24(sp)
    80004ca6:	e862                	sd	s8,16(sp)
    80004ca8:	e466                	sd	s9,8(sp)
    int i = 0;
    80004caa:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    80004cac:	6b85                	lui	s7,0x1
    80004cae:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004cb2:	6c85                	lui	s9,0x1
    80004cb4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cb8:	4c05                	li	s8,1
    80004cba:	a8ad                	j	80004d34 <filewrite+0xce>
    ret = pipewrite(f->pipe, addr, n);
    80004cbc:	6908                	ld	a0,16(a0)
    80004cbe:	200000ef          	jal	80004ebe <pipewrite>
    80004cc2:	a849                	j	80004d54 <filewrite+0xee>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004cc4:	02451783          	lh	a5,36(a0)
    80004cc8:	03079693          	slli	a3,a5,0x30
    80004ccc:	92c1                	srli	a3,a3,0x30
    80004cce:	4725                	li	a4,9
    80004cd0:	0ad76963          	bltu	a4,a3,80004d82 <filewrite+0x11c>
    80004cd4:	0792                	slli	a5,a5,0x4
    80004cd6:	0024a717          	auipc	a4,0x24a
    80004cda:	f8a70713          	addi	a4,a4,-118 # 8024ec60 <devsw>
    80004cde:	97ba                	add	a5,a5,a4
    80004ce0:	679c                	ld	a5,8(a5)
    80004ce2:	c3d5                	beqz	a5,80004d86 <filewrite+0x120>
    ret = devsw[f->major].write(1, addr, n);
    80004ce4:	4505                	li	a0,1
    80004ce6:	9782                	jalr	a5
    80004ce8:	a0b5                	j	80004d54 <filewrite+0xee>
      if (n1 > max)
    80004cea:	2981                	sext.w	s3,s3
      begin_op();
    80004cec:	8dbff0ef          	jal	800045c6 <begin_op>
      ilock(f->ip);
    80004cf0:	01893503          	ld	a0,24(s2)
    80004cf4:	e71fe0ef          	jal	80003b64 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004cf8:	874e                	mv	a4,s3
    80004cfa:	02092683          	lw	a3,32(s2)
    80004cfe:	016a0633          	add	a2,s4,s6
    80004d02:	85e2                	mv	a1,s8
    80004d04:	01893503          	ld	a0,24(s2)
    80004d08:	b28ff0ef          	jal	80004030 <writei>
    80004d0c:	84aa                	mv	s1,a0
    80004d0e:	00a05763          	blez	a0,80004d1c <filewrite+0xb6>
        f->off += r;
    80004d12:	02092783          	lw	a5,32(s2)
    80004d16:	9fa9                	addw	a5,a5,a0
    80004d18:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004d1c:	01893503          	ld	a0,24(s2)
    80004d20:	ef3fe0ef          	jal	80003c12 <iunlock>
      end_op();
    80004d24:	929ff0ef          	jal	8000464c <end_op>

      if (r != n1) {
    80004d28:	00999d63          	bne	s3,s1,80004d42 <filewrite+0xdc>
        // error from writei
        break;
      }
      i += r;
    80004d2c:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004d30:	015a5963          	bge	s4,s5,80004d42 <filewrite+0xdc>
      int n1 = n - i;
    80004d34:	414a87bb          	subw	a5,s5,s4
    80004d38:	89be                	mv	s3,a5
      if (n1 > max)
    80004d3a:	fafbd8e3          	bge	s7,a5,80004cea <filewrite+0x84>
    80004d3e:	89e6                	mv	s3,s9
    80004d40:	b76d                	j	80004cea <filewrite+0x84>
    }
    ret = (i == n ? n : -1);
    80004d42:	054a9663          	bne	s5,s4,80004d8e <filewrite+0x128>
    80004d46:	8556                	mv	a0,s5
    80004d48:	64a6                	ld	s1,72(sp)
    80004d4a:	79e2                	ld	s3,56(sp)
    80004d4c:	7a42                	ld	s4,48(sp)
    80004d4e:	6be2                	ld	s7,24(sp)
    80004d50:	6c42                	ld	s8,16(sp)
    80004d52:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004d54:	60e6                	ld	ra,88(sp)
    80004d56:	6446                	ld	s0,80(sp)
    80004d58:	6906                	ld	s2,64(sp)
    80004d5a:	7aa2                	ld	s5,40(sp)
    80004d5c:	7b02                	ld	s6,32(sp)
    80004d5e:	6125                	addi	sp,sp,96
    80004d60:	8082                	ret
    80004d62:	e4a6                	sd	s1,72(sp)
    80004d64:	fc4e                	sd	s3,56(sp)
    80004d66:	f852                	sd	s4,48(sp)
    80004d68:	ec5e                	sd	s7,24(sp)
    80004d6a:	e862                	sd	s8,16(sp)
    80004d6c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004d6e:	00004517          	auipc	a0,0x4
    80004d72:	85250513          	addi	a0,a0,-1966 # 800085c0 <etext+0x5c0>
    80004d76:	a79fb0ef          	jal	800007ee <panic>
    return -1;
    80004d7a:	557d                	li	a0,-1
}
    80004d7c:	8082                	ret
    return -1;
    80004d7e:	557d                	li	a0,-1
    80004d80:	bfd1                	j	80004d54 <filewrite+0xee>
      return -1;
    80004d82:	557d                	li	a0,-1
    80004d84:	bfc1                	j	80004d54 <filewrite+0xee>
    80004d86:	557d                	li	a0,-1
    80004d88:	b7f1                	j	80004d54 <filewrite+0xee>
    ret = (i == n ? n : -1);
    80004d8a:	8532                	mv	a0,a2
    80004d8c:	b7e1                	j	80004d54 <filewrite+0xee>
    80004d8e:	557d                	li	a0,-1
    80004d90:	64a6                	ld	s1,72(sp)
    80004d92:	79e2                	ld	s3,56(sp)
    80004d94:	7a42                	ld	s4,48(sp)
    80004d96:	6be2                	ld	s7,24(sp)
    80004d98:	6c42                	ld	s8,16(sp)
    80004d9a:	6ca2                	ld	s9,8(sp)
    80004d9c:	bf65                	j	80004d54 <filewrite+0xee>

0000000080004d9e <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d9e:	7179                	addi	sp,sp,-48
    80004da0:	f406                	sd	ra,40(sp)
    80004da2:	f022                	sd	s0,32(sp)
    80004da4:	ec26                	sd	s1,24(sp)
    80004da6:	e052                	sd	s4,0(sp)
    80004da8:	1800                	addi	s0,sp,48
    80004daa:	84aa                	mv	s1,a0
    80004dac:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004dae:	0005b023          	sd	zero,0(a1)
    80004db2:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004db6:	c1fff0ef          	jal	800049d4 <filealloc>
    80004dba:	e088                	sd	a0,0(s1)
    80004dbc:	c549                	beqz	a0,80004e46 <pipealloc+0xa8>
    80004dbe:	c17ff0ef          	jal	800049d4 <filealloc>
    80004dc2:	00aa3023          	sd	a0,0(s4)
    80004dc6:	cd25                	beqz	a0,80004e3e <pipealloc+0xa0>
    80004dc8:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004dca:	d6bfb0ef          	jal	80000b34 <kalloc>
    80004dce:	892a                	mv	s2,a0
    80004dd0:	c12d                	beqz	a0,80004e32 <pipealloc+0x94>
    80004dd2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004dd4:	4985                	li	s3,1
    80004dd6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004dda:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004dde:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004de2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004de6:	00003597          	auipc	a1,0x3
    80004dea:	7ea58593          	addi	a1,a1,2026 # 800085d0 <etext+0x5d0>
    80004dee:	e4ffb0ef          	jal	80000c3c <initlock>
  (*f0)->type = FD_PIPE;
    80004df2:	609c                	ld	a5,0(s1)
    80004df4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004df8:	609c                	ld	a5,0(s1)
    80004dfa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004dfe:	609c                	ld	a5,0(s1)
    80004e00:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e04:	609c                	ld	a5,0(s1)
    80004e06:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e0a:	000a3783          	ld	a5,0(s4)
    80004e0e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e12:	000a3783          	ld	a5,0(s4)
    80004e16:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004e1a:	000a3783          	ld	a5,0(s4)
    80004e1e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004e22:	000a3783          	ld	a5,0(s4)
    80004e26:	0127b823          	sd	s2,16(a5)
  return 0;
    80004e2a:	4501                	li	a0,0
    80004e2c:	6942                	ld	s2,16(sp)
    80004e2e:	69a2                	ld	s3,8(sp)
    80004e30:	a01d                	j	80004e56 <pipealloc+0xb8>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004e32:	6088                	ld	a0,0(s1)
    80004e34:	c119                	beqz	a0,80004e3a <pipealloc+0x9c>
    80004e36:	6942                	ld	s2,16(sp)
    80004e38:	a029                	j	80004e42 <pipealloc+0xa4>
    80004e3a:	6942                	ld	s2,16(sp)
    80004e3c:	a029                	j	80004e46 <pipealloc+0xa8>
    80004e3e:	6088                	ld	a0,0(s1)
    80004e40:	c10d                	beqz	a0,80004e62 <pipealloc+0xc4>
    fileclose(*f0);
    80004e42:	c37ff0ef          	jal	80004a78 <fileclose>
  if (*f1)
    80004e46:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004e4a:	557d                	li	a0,-1
  if (*f1)
    80004e4c:	c789                	beqz	a5,80004e56 <pipealloc+0xb8>
    fileclose(*f1);
    80004e4e:	853e                	mv	a0,a5
    80004e50:	c29ff0ef          	jal	80004a78 <fileclose>
  return -1;
    80004e54:	557d                	li	a0,-1
}
    80004e56:	70a2                	ld	ra,40(sp)
    80004e58:	7402                	ld	s0,32(sp)
    80004e5a:	64e2                	ld	s1,24(sp)
    80004e5c:	6a02                	ld	s4,0(sp)
    80004e5e:	6145                	addi	sp,sp,48
    80004e60:	8082                	ret
  return -1;
    80004e62:	557d                	li	a0,-1
    80004e64:	bfcd                	j	80004e56 <pipealloc+0xb8>

0000000080004e66 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004e66:	1101                	addi	sp,sp,-32
    80004e68:	ec06                	sd	ra,24(sp)
    80004e6a:	e822                	sd	s0,16(sp)
    80004e6c:	e426                	sd	s1,8(sp)
    80004e6e:	e04a                	sd	s2,0(sp)
    80004e70:	1000                	addi	s0,sp,32
    80004e72:	84aa                	mv	s1,a0
    80004e74:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e76:	e41fb0ef          	jal	80000cb6 <acquire>
  if (writable) {
    80004e7a:	02090763          	beqz	s2,80004ea8 <pipeclose+0x42>
    pi->writeopen = 0;
    80004e7e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e82:	21848513          	addi	a0,s1,536
    80004e86:	f1cfd0ef          	jal	800025a2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004e8a:	2204b783          	ld	a5,544(s1)
    80004e8e:	e785                	bnez	a5,80004eb6 <pipeclose+0x50>
    release(&pi->lock);
    80004e90:	8526                	mv	a0,s1
    80004e92:	eadfb0ef          	jal	80000d3e <release>
    kfree((char *)pi);
    80004e96:	8526                	mv	a0,s1
    80004e98:	b49fb0ef          	jal	800009e0 <kfree>
  } else
    release(&pi->lock);
}
    80004e9c:	60e2                	ld	ra,24(sp)
    80004e9e:	6442                	ld	s0,16(sp)
    80004ea0:	64a2                	ld	s1,8(sp)
    80004ea2:	6902                	ld	s2,0(sp)
    80004ea4:	6105                	addi	sp,sp,32
    80004ea6:	8082                	ret
    pi->readopen = 0;
    80004ea8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004eac:	21c48513          	addi	a0,s1,540
    80004eb0:	ef2fd0ef          	jal	800025a2 <wakeup>
    80004eb4:	bfd9                	j	80004e8a <pipeclose+0x24>
    release(&pi->lock);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	e87fb0ef          	jal	80000d3e <release>
}
    80004ebc:	b7c5                	j	80004e9c <pipeclose+0x36>

0000000080004ebe <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004ebe:	7159                	addi	sp,sp,-112
    80004ec0:	f486                	sd	ra,104(sp)
    80004ec2:	f0a2                	sd	s0,96(sp)
    80004ec4:	eca6                	sd	s1,88(sp)
    80004ec6:	e8ca                	sd	s2,80(sp)
    80004ec8:	e4ce                	sd	s3,72(sp)
    80004eca:	e0d2                	sd	s4,64(sp)
    80004ecc:	fc56                	sd	s5,56(sp)
    80004ece:	1880                	addi	s0,sp,112
    80004ed0:	84aa                	mv	s1,a0
    80004ed2:	8aae                	mv	s5,a1
    80004ed4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004ed6:	fc1fc0ef          	jal	80001e96 <myproc>
    80004eda:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004edc:	8526                	mv	a0,s1
    80004ede:	dd9fb0ef          	jal	80000cb6 <acquire>
  while (i < n) {
    80004ee2:	0f405a63          	blez	s4,80004fd6 <pipewrite+0x118>
    80004ee6:	f85a                	sd	s6,48(sp)
    80004ee8:	f45e                	sd	s7,40(sp)
    80004eea:	f062                	sd	s8,32(sp)
    80004eec:	ec66                	sd	s9,24(sp)
    80004eee:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004ef0:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004ef2:	f9f40c13          	addi	s8,s0,-97
    80004ef6:	4b85                	li	s7,1
    80004ef8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004efa:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    80004efe:	21c48c93          	addi	s9,s1,540
    80004f02:	a0a1                	j	80004f4a <pipewrite+0x8c>
      release(&pi->lock);
    80004f04:	8526                	mv	a0,s1
    80004f06:	e39fb0ef          	jal	80000d3e <release>
      return -1;
    80004f0a:	597d                	li	s2,-1
    80004f0c:	7b42                	ld	s6,48(sp)
    80004f0e:	7ba2                	ld	s7,40(sp)
    80004f10:	7c02                	ld	s8,32(sp)
    80004f12:	6ce2                	ld	s9,24(sp)
    80004f14:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004f16:	854a                	mv	a0,s2
    80004f18:	70a6                	ld	ra,104(sp)
    80004f1a:	7406                	ld	s0,96(sp)
    80004f1c:	64e6                	ld	s1,88(sp)
    80004f1e:	6946                	ld	s2,80(sp)
    80004f20:	69a6                	ld	s3,72(sp)
    80004f22:	6a06                	ld	s4,64(sp)
    80004f24:	7ae2                	ld	s5,56(sp)
    80004f26:	6165                	addi	sp,sp,112
    80004f28:	8082                	ret
      wakeup(&pi->nread);
    80004f2a:	856a                	mv	a0,s10
    80004f2c:	e76fd0ef          	jal	800025a2 <wakeup>
      sleep_prepare(&pi->nwrite);
    80004f30:	8566                	mv	a0,s9
    80004f32:	e04fd0ef          	jal	80002536 <sleep_prepare>
      release(&pi->lock);
    80004f36:	8526                	mv	a0,s1
    80004f38:	e07fb0ef          	jal	80000d3e <release>
      sleep();
    80004f3c:	e36fd0ef          	jal	80002572 <sleep>
      acquire(&pi->lock);
    80004f40:	8526                	mv	a0,s1
    80004f42:	d75fb0ef          	jal	80000cb6 <acquire>
  while (i < n) {
    80004f46:	07495b63          	bge	s2,s4,80004fbc <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004f4a:	2204a783          	lw	a5,544(s1)
    80004f4e:	dbdd                	beqz	a5,80004f04 <pipewrite+0x46>
    80004f50:	854e                	mv	a0,s3
    80004f52:	84bfd0ef          	jal	8000279c <killed>
    80004f56:	f55d                	bnez	a0,80004f04 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80004f58:	2184a783          	lw	a5,536(s1)
    80004f5c:	21c4a703          	lw	a4,540(s1)
    80004f60:	2007879b          	addiw	a5,a5,512
    80004f64:	fcf703e3          	beq	a4,a5,80004f2a <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004f68:	875e                	mv	a4,s7
    80004f6a:	015906b3          	add	a3,s2,s5
    80004f6e:	8662                	mv	a2,s8
    80004f70:	0509b583          	ld	a1,80(s3)
    80004f74:	0589b503          	ld	a0,88(s3)
    80004f78:	aaffc0ef          	jal	80001a26 <copyin>
    80004f7c:	03650163          	beq	a0,s6,80004f9e <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004f80:	21c4a783          	lw	a5,540(s1)
    80004f84:	0017871b          	addiw	a4,a5,1
    80004f88:	20e4ae23          	sw	a4,540(s1)
    80004f8c:	1ff7f793          	andi	a5,a5,511
    80004f90:	97a6                	add	a5,a5,s1
    80004f92:	f9f44703          	lbu	a4,-97(s0)
    80004f96:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f9a:	2905                	addiw	s2,s2,1
    80004f9c:	b76d                	j	80004f46 <pipewrite+0x88>
        if (i == 0)
    80004f9e:	00090863          	beqz	s2,80004fae <pipewrite+0xf0>
    80004fa2:	7b42                	ld	s6,48(sp)
    80004fa4:	7ba2                	ld	s7,40(sp)
    80004fa6:	7c02                	ld	s8,32(sp)
    80004fa8:	6ce2                	ld	s9,24(sp)
    80004faa:	6d42                	ld	s10,16(sp)
    80004fac:	a829                	j	80004fc6 <pipewrite+0x108>
          i = -1;
    80004fae:	892a                	mv	s2,a0
        break;
    80004fb0:	7b42                	ld	s6,48(sp)
    80004fb2:	7ba2                	ld	s7,40(sp)
    80004fb4:	7c02                	ld	s8,32(sp)
    80004fb6:	6ce2                	ld	s9,24(sp)
    80004fb8:	6d42                	ld	s10,16(sp)
    80004fba:	a031                	j	80004fc6 <pipewrite+0x108>
    80004fbc:	7b42                	ld	s6,48(sp)
    80004fbe:	7ba2                	ld	s7,40(sp)
    80004fc0:	7c02                	ld	s8,32(sp)
    80004fc2:	6ce2                	ld	s9,24(sp)
    80004fc4:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004fc6:	21848513          	addi	a0,s1,536
    80004fca:	dd8fd0ef          	jal	800025a2 <wakeup>
  release(&pi->lock);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	d6ffb0ef          	jal	80000d3e <release>
  return i;
    80004fd4:	b789                	j	80004f16 <pipewrite+0x58>
  int i = 0;
    80004fd6:	4901                	li	s2,0
    80004fd8:	b7fd                	j	80004fc6 <pipewrite+0x108>

0000000080004fda <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004fda:	711d                	addi	sp,sp,-96
    80004fdc:	ec86                	sd	ra,88(sp)
    80004fde:	e8a2                	sd	s0,80(sp)
    80004fe0:	e4a6                	sd	s1,72(sp)
    80004fe2:	e0ca                	sd	s2,64(sp)
    80004fe4:	fc4e                	sd	s3,56(sp)
    80004fe6:	f852                	sd	s4,48(sp)
    80004fe8:	f456                	sd	s5,40(sp)
    80004fea:	1080                	addi	s0,sp,96
    80004fec:	84aa                	mv	s1,a0
    80004fee:	89ae                	mv	s3,a1
    80004ff0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004ff2:	ea5fc0ef          	jal	80001e96 <myproc>
    80004ff6:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	cbdfb0ef          	jal	80000cb6 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004ffe:	2184a703          	lw	a4,536(s1)
    80005002:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80005006:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000500a:	02f71e63          	bne	a4,a5,80005046 <piperead+0x6c>
    8000500e:	2244a783          	lw	a5,548(s1)
    80005012:	c3b9                	beqz	a5,80005058 <piperead+0x7e>
    if (killed(pr)) {
    80005014:	854a                	mv	a0,s2
    80005016:	f86fd0ef          	jal	8000279c <killed>
    8000501a:	e915                	bnez	a0,8000504e <piperead+0x74>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    8000501c:	8552                	mv	a0,s4
    8000501e:	d18fd0ef          	jal	80002536 <sleep_prepare>
    release(&pi->lock);
    80005022:	8526                	mv	a0,s1
    80005024:	d1bfb0ef          	jal	80000d3e <release>
    sleep();
    80005028:	d4afd0ef          	jal	80002572 <sleep>
    acquire(&pi->lock);
    8000502c:	8526                	mv	a0,s1
    8000502e:	c89fb0ef          	jal	80000cb6 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80005032:	2184a703          	lw	a4,536(s1)
    80005036:	21c4a783          	lw	a5,540(s1)
    8000503a:	fcf70ae3          	beq	a4,a5,8000500e <piperead+0x34>
    8000503e:	f05a                	sd	s6,32(sp)
    80005040:	ec5e                	sd	s7,24(sp)
    80005042:	e862                	sd	s8,16(sp)
    80005044:	a829                	j	8000505e <piperead+0x84>
    80005046:	f05a                	sd	s6,32(sp)
    80005048:	ec5e                	sd	s7,24(sp)
    8000504a:	e862                	sd	s8,16(sp)
    8000504c:	a809                	j	8000505e <piperead+0x84>
      release(&pi->lock);
    8000504e:	8526                	mv	a0,s1
    80005050:	ceffb0ef          	jal	80000d3e <release>
      return -1;
    80005054:	5a7d                	li	s4,-1
    80005056:	a0bd                	j	800050c4 <piperead+0xea>
    80005058:	f05a                	sd	s6,32(sp)
    8000505a:	ec5e                	sd	s7,24(sp)
    8000505c:	e862                	sd	s8,16(sp)
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000505e:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80005060:	faf40c13          	addi	s8,s0,-81
    80005064:	4b85                	li	s7,1
    80005066:	5b7d                	li	s6,-1
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80005068:	05505463          	blez	s5,800050b0 <piperead+0xd6>
    if (pi->nread == pi->nwrite)
    8000506c:	2184a783          	lw	a5,536(s1)
    80005070:	21c4a703          	lw	a4,540(s1)
    80005074:	02f70e63          	beq	a4,a5,800050b0 <piperead+0xd6>
    ch = pi->data[pi->nread % PIPESIZE];
    80005078:	1ff7f793          	andi	a5,a5,511
    8000507c:	97a6                	add	a5,a5,s1
    8000507e:	0187c783          	lbu	a5,24(a5)
    80005082:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80005086:	875e                	mv	a4,s7
    80005088:	86e2                	mv	a3,s8
    8000508a:	864e                	mv	a2,s3
    8000508c:	05093583          	ld	a1,80(s2)
    80005090:	05893503          	ld	a0,88(s2)
    80005094:	88dfc0ef          	jal	80001920 <copyout>
    80005098:	05650063          	beq	a0,s6,800050d8 <piperead+0xfe>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000509c:	2184a783          	lw	a5,536(s1)
    800050a0:	2785                	addiw	a5,a5,1
    800050a2:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800050a6:	2a05                	addiw	s4,s4,1
    800050a8:	0985                	addi	s3,s3,1
    800050aa:	fd4a91e3          	bne	s5,s4,8000506c <piperead+0x92>
    800050ae:	8a56                	mv	s4,s5
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800050b0:	21c48513          	addi	a0,s1,540
    800050b4:	ceefd0ef          	jal	800025a2 <wakeup>
  release(&pi->lock);
    800050b8:	8526                	mv	a0,s1
    800050ba:	c85fb0ef          	jal	80000d3e <release>
    800050be:	7b02                	ld	s6,32(sp)
    800050c0:	6be2                	ld	s7,24(sp)
    800050c2:	6c42                	ld	s8,16(sp)
  return i;
}
    800050c4:	8552                	mv	a0,s4
    800050c6:	60e6                	ld	ra,88(sp)
    800050c8:	6446                	ld	s0,80(sp)
    800050ca:	64a6                	ld	s1,72(sp)
    800050cc:	6906                	ld	s2,64(sp)
    800050ce:	79e2                	ld	s3,56(sp)
    800050d0:	7a42                	ld	s4,48(sp)
    800050d2:	7aa2                	ld	s5,40(sp)
    800050d4:	6125                	addi	sp,sp,96
    800050d6:	8082                	ret
      if (i == 0)
    800050d8:	fc0a1ce3          	bnez	s4,800050b0 <piperead+0xd6>
        i = -1;
    800050dc:	8a2a                	mv	s4,a0
    800050de:	bfc9                	j	800050b0 <piperead+0xd6>

00000000800050e0 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800050e0:	1141                	addi	sp,sp,-16
    800050e2:	e406                	sd	ra,8(sp)
    800050e4:	e022                	sd	s0,0(sp)
    800050e6:	0800                	addi	s0,sp,16
    800050e8:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    800050ea:	0035151b          	slliw	a0,a0,0x3
    800050ee:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    800050f0:	8b89                	andi	a5,a5,2
    800050f2:	c399                	beqz	a5,800050f8 <flags2perm+0x18>
    perm |= PTE_W;
    800050f4:	00456513          	ori	a0,a0,4
  return perm;
}
    800050f8:	60a2                	ld	ra,8(sp)
    800050fa:	6402                	ld	s0,0(sp)
    800050fc:	0141                	addi	sp,sp,16
    800050fe:	8082                	ret

0000000080005100 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80005100:	de010113          	addi	sp,sp,-544
    80005104:	20113c23          	sd	ra,536(sp)
    80005108:	20813823          	sd	s0,528(sp)
    8000510c:	20913423          	sd	s1,520(sp)
    80005110:	21213023          	sd	s2,512(sp)
    80005114:	1400                	addi	s0,sp,544
    80005116:	892a                	mv	s2,a0
    80005118:	dea43823          	sd	a0,-528(s0)
    8000511c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005120:	d77fc0ef          	jal	80001e96 <myproc>
    80005124:	84aa                	mv	s1,a0

  begin_op();
    80005126:	ca0ff0ef          	jal	800045c6 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    8000512a:	854a                	mv	a0,s2
    8000512c:	ac0ff0ef          	jal	800043ec <namei>
    80005130:	cd21                	beqz	a0,80005188 <kexec+0x88>
    80005132:	fbd2                	sd	s4,496(sp)
    80005134:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005136:	a2ffe0ef          	jal	80003b64 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000513a:	04000713          	li	a4,64
    8000513e:	4681                	li	a3,0
    80005140:	e5040613          	addi	a2,s0,-432
    80005144:	4581                	li	a1,0
    80005146:	8552                	mv	a0,s4
    80005148:	df7fe0ef          	jal	80003f3e <readi>
    8000514c:	04000793          	li	a5,64
    80005150:	00f51a63          	bne	a0,a5,80005164 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80005154:	e5042703          	lw	a4,-432(s0)
    80005158:	464c47b7          	lui	a5,0x464c4
    8000515c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005160:	02f70863          	beq	a4,a5,80005190 <kexec+0x90>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80005164:	8552                	mv	a0,s4
    80005166:	c51fe0ef          	jal	80003db6 <iunlockput>
    end_op();
    8000516a:	ce2ff0ef          	jal	8000464c <end_op>
  }
  return -1;
    8000516e:	557d                	li	a0,-1
    80005170:	7a5e                	ld	s4,496(sp)
}
    80005172:	21813083          	ld	ra,536(sp)
    80005176:	21013403          	ld	s0,528(sp)
    8000517a:	20813483          	ld	s1,520(sp)
    8000517e:	20013903          	ld	s2,512(sp)
    80005182:	22010113          	addi	sp,sp,544
    80005186:	8082                	ret
    end_op();
    80005188:	cc4ff0ef          	jal	8000464c <end_op>
    return -1;
    8000518c:	557d                	li	a0,-1
    8000518e:	b7d5                	j	80005172 <kexec+0x72>
    80005190:	f3da                	sd	s6,480(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    80005192:	8526                	mv	a0,s1
    80005194:	e05fc0ef          	jal	80001f98 <proc_pagetable>
    80005198:	8b2a                	mv	s6,a0
    8000519a:	26050c63          	beqz	a0,80005412 <kexec+0x312>
    8000519e:	ffce                	sd	s3,504(sp)
    800051a0:	f7d6                	sd	s5,488(sp)
    800051a2:	efde                	sd	s7,472(sp)
    800051a4:	ebe2                	sd	s8,464(sp)
    800051a6:	e7e6                	sd	s9,456(sp)
    800051a8:	e3ea                	sd	s10,448(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051aa:	e7042683          	lw	a3,-400(s0)
    800051ae:	e8845783          	lhu	a5,-376(s0)
    800051b2:	14078063          	beqz	a5,800052f2 <kexec+0x1f2>
    800051b6:	ff6e                	sd	s11,440(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051b8:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800051ba:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800051bc:	03800d93          	li	s11,56
    if (ph.vaddr % PGSIZE != 0)
    800051c0:	6c85                	lui	s9,0x1
    800051c2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800051c6:	def43423          	sd	a5,-536(s0)

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800051ca:	6a85                	lui	s5,0x1
    800051cc:	a085                	j	8000522c <kexec+0x12c>
      panic("loadseg: address should exist");
    800051ce:	00003517          	auipc	a0,0x3
    800051d2:	40a50513          	addi	a0,a0,1034 # 800085d8 <etext+0x5d8>
    800051d6:	e18fb0ef          	jal	800007ee <panic>
    if (sz - i < PGSIZE)
    800051da:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800051dc:	874a                	mv	a4,s2
    800051de:	009c06bb          	addw	a3,s8,s1
    800051e2:	4581                	li	a1,0
    800051e4:	8552                	mv	a0,s4
    800051e6:	d59fe0ef          	jal	80003f3e <readi>
    800051ea:	22a91c63          	bne	s2,a0,80005422 <kexec+0x322>
  for (i = 0; i < sz; i += PGSIZE) {
    800051ee:	009a84bb          	addw	s1,s5,s1
    800051f2:	0334f263          	bgeu	s1,s3,80005216 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800051f6:	02049593          	slli	a1,s1,0x20
    800051fa:	9181                	srli	a1,a1,0x20
    800051fc:	95de                	add	a1,a1,s7
    800051fe:	855a                	mv	a0,s6
    80005200:	ea7fb0ef          	jal	800010a6 <walkaddr>
    80005204:	862a                	mv	a2,a0
    if (pa == 0)
    80005206:	d561                	beqz	a0,800051ce <kexec+0xce>
    if (sz - i < PGSIZE)
    80005208:	409987bb          	subw	a5,s3,s1
    8000520c:	893e                	mv	s2,a5
    8000520e:	fcfcf6e3          	bgeu	s9,a5,800051da <kexec+0xda>
    80005212:	8956                	mv	s2,s5
    80005214:	b7d9                	j	800051da <kexec+0xda>
    sz = sz1;
    80005216:	df843903          	ld	s2,-520(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000521a:	2d05                	addiw	s10,s10,1
    8000521c:	e0843783          	ld	a5,-504(s0)
    80005220:	0387869b          	addiw	a3,a5,56
    80005224:	e8845783          	lhu	a5,-376(s0)
    80005228:	06fd5d63          	bge	s10,a5,800052a2 <kexec+0x1a2>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000522c:	e0d43423          	sd	a3,-504(s0)
    80005230:	876e                	mv	a4,s11
    80005232:	e1840613          	addi	a2,s0,-488
    80005236:	4581                	li	a1,0
    80005238:	8552                	mv	a0,s4
    8000523a:	d05fe0ef          	jal	80003f3e <readi>
    8000523e:	1fb51063          	bne	a0,s11,8000541e <kexec+0x31e>
    if (ph.type != ELF_PROG_LOAD)
    80005242:	e1842783          	lw	a5,-488(s0)
    80005246:	4705                	li	a4,1
    80005248:	fce799e3          	bne	a5,a4,8000521a <kexec+0x11a>
    if (ph.memsz < ph.filesz)
    8000524c:	e4043483          	ld	s1,-448(s0)
    80005250:	e3843783          	ld	a5,-456(s0)
    80005254:	1ef4e563          	bltu	s1,a5,8000543e <kexec+0x33e>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005258:	e2843783          	ld	a5,-472(s0)
    8000525c:	94be                	add	s1,s1,a5
    8000525e:	1ef4e363          	bltu	s1,a5,80005444 <kexec+0x344>
    if (ph.vaddr % PGSIZE != 0)
    80005262:	de843703          	ld	a4,-536(s0)
    80005266:	8ff9                	and	a5,a5,a4
    80005268:	1e079163          	bnez	a5,8000544a <kexec+0x34a>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    8000526c:	e1c42503          	lw	a0,-484(s0)
    80005270:	e71ff0ef          	jal	800050e0 <flags2perm>
    80005274:	86aa                	mv	a3,a0
    80005276:	8626                	mv	a2,s1
    80005278:	85ca                	mv	a1,s2
    8000527a:	855a                	mv	a0,s6
    8000527c:	902fc0ef          	jal	8000137e <uvmalloc>
    80005280:	dea43c23          	sd	a0,-520(s0)
    80005284:	1c050663          	beqz	a0,80005450 <kexec+0x350>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005288:	e2843b83          	ld	s7,-472(s0)
    8000528c:	e2042c03          	lw	s8,-480(s0)
    80005290:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005294:	00098463          	beqz	s3,8000529c <kexec+0x19c>
    80005298:	4481                	li	s1,0
    8000529a:	bfb1                	j	800051f6 <kexec+0xf6>
    sz = sz1;
    8000529c:	df843903          	ld	s2,-520(s0)
    800052a0:	bfad                	j	8000521a <kexec+0x11a>
    800052a2:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    800052a4:	8552                	mv	a0,s4
    800052a6:	b11fe0ef          	jal	80003db6 <iunlockput>
  end_op();
    800052aa:	ba2ff0ef          	jal	8000464c <end_op>
  p = myproc();
    800052ae:	be9fc0ef          	jal	80001e96 <myproc>
    800052b2:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    800052b4:	05053a83          	ld	s5,80(a0)
  sz = PGROUNDUP(sz);
    800052b8:	6c05                	lui	s8,0x1
    800052ba:	1c7d                	addi	s8,s8,-1 # fff <_entry-0x7ffff001>
    800052bc:	9c4a                	add	s8,s8,s2
    800052be:	77fd                	lui	a5,0xfffff
    800052c0:	00fc7c33          	and	s8,s8,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    800052c4:	4691                	li	a3,4
    800052c6:	6609                	lui	a2,0x2
    800052c8:	9662                	add	a2,a2,s8
    800052ca:	85e2                	mv	a1,s8
    800052cc:	855a                	mv	a0,s6
    800052ce:	8b0fc0ef          	jal	8000137e <uvmalloc>
    800052d2:	892a                	mv	s2,a0
    800052d4:	e10d                	bnez	a0,800052f6 <kexec+0x1f6>
    proc_freepagetable(pagetable, sz);
    800052d6:	85e2                	mv	a1,s8
    800052d8:	855a                	mv	a0,s6
    800052da:	d43fc0ef          	jal	8000201c <proc_freepagetable>
  return -1;
    800052de:	557d                	li	a0,-1
    800052e0:	79fe                	ld	s3,504(sp)
    800052e2:	7a5e                	ld	s4,496(sp)
    800052e4:	7abe                	ld	s5,488(sp)
    800052e6:	7b1e                	ld	s6,480(sp)
    800052e8:	6bfe                	ld	s7,472(sp)
    800052ea:	6c5e                	ld	s8,464(sp)
    800052ec:	6cbe                	ld	s9,456(sp)
    800052ee:	6d1e                	ld	s10,448(sp)
    800052f0:	b549                	j	80005172 <kexec+0x72>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052f2:	4901                	li	s2,0
    800052f4:	bf45                	j	800052a4 <kexec+0x1a4>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    800052f6:	75f9                	lui	a1,0xffffe
    800052f8:	95aa                	add	a1,a1,a0
    800052fa:	855a                	mv	a0,s6
    800052fc:	a72fc0ef          	jal	8000156e <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80005300:	7a7d                	lui	s4,0xfffff
    80005302:	9a4a                	add	s4,s4,s2
  for (argc = 0; argv[argc]; argc++) {
    80005304:	e0043783          	ld	a5,-512(s0)
    80005308:	6388                	ld	a0,0(a5)
    8000530a:	c545                	beqz	a0,800053b2 <kexec+0x2b2>
  sp = sz;
    8000530c:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    8000530e:	4481                	li	s1,0
    ustack[argc] = sp;
    80005310:	e9040b93          	addi	s7,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80005314:	bebfb0ef          	jal	80000efe <strlen>
    80005318:	0015079b          	addiw	a5,a0,1
    8000531c:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005320:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80005324:	0f4c6963          	bltu	s8,s4,80005416 <kexec+0x316>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005328:	e0043d03          	ld	s10,-512(s0)
    8000532c:	000d3c83          	ld	s9,0(s10)
    80005330:	8566                	mv	a0,s9
    80005332:	bcdfb0ef          	jal	80000efe <strlen>
    80005336:	0015071b          	addiw	a4,a0,1
    8000533a:	86e6                	mv	a3,s9
    8000533c:	8662                	mv	a2,s8
    8000533e:	85ca                	mv	a1,s2
    80005340:	855a                	mv	a0,s6
    80005342:	ddefc0ef          	jal	80001920 <copyout>
    80005346:	0c054a63          	bltz	a0,8000541a <kexec+0x31a>
    ustack[argc] = sp;
    8000534a:	00349793          	slli	a5,s1,0x3
    8000534e:	97de                	add	a5,a5,s7
    80005350:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7fdaf208>
  for (argc = 0; argv[argc]; argc++) {
    80005354:	0485                	addi	s1,s1,1
    80005356:	008d0793          	addi	a5,s10,8
    8000535a:	e0f43023          	sd	a5,-512(s0)
    8000535e:	008d3503          	ld	a0,8(s10)
    80005362:	f94d                	bnez	a0,80005314 <kexec+0x214>
  ustack[argc] = 0;
    80005364:	00349793          	slli	a5,s1,0x3
    80005368:	f9078793          	addi	a5,a5,-112
    8000536c:	97a2                	add	a5,a5,s0
    8000536e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80005372:	00148713          	addi	a4,s1,1
    80005376:	070e                	slli	a4,a4,0x3
    80005378:	40ec0bb3          	sub	s7,s8,a4
  sp -= sp % 16;
    8000537c:	ff0bfb93          	andi	s7,s7,-16
  sz = sz1;
    80005380:	8c4a                	mv	s8,s2
  if (sp < stackbase)
    80005382:	f54beae3          	bltu	s7,s4,800052d6 <kexec+0x1d6>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80005386:	e9040693          	addi	a3,s0,-368
    8000538a:	865e                	mv	a2,s7
    8000538c:	85ca                	mv	a1,s2
    8000538e:	855a                	mv	a0,s6
    80005390:	d90fc0ef          	jal	80001920 <copyout>
    80005394:	f40541e3          	bltz	a0,800052d6 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80005398:	0609b783          	ld	a5,96(s3)
    8000539c:	0777bc23          	sd	s7,120(a5)
  for (last = s = path; *s; s++)
    800053a0:	df043783          	ld	a5,-528(s0)
    800053a4:	0007c703          	lbu	a4,0(a5)
    800053a8:	c30d                	beqz	a4,800053ca <kexec+0x2ca>
    800053aa:	0785                	addi	a5,a5,1
    if (*s == '/')
    800053ac:	02f00693          	li	a3,47
    800053b0:	a801                	j	800053c0 <kexec+0x2c0>
  sp = sz;
    800053b2:	8c4a                	mv	s8,s2
  for (argc = 0; argv[argc]; argc++) {
    800053b4:	4481                	li	s1,0
    800053b6:	b77d                	j	80005364 <kexec+0x264>
  for (last = s = path; *s; s++)
    800053b8:	0785                	addi	a5,a5,1
    800053ba:	fff7c703          	lbu	a4,-1(a5)
    800053be:	c711                	beqz	a4,800053ca <kexec+0x2ca>
    if (*s == '/')
    800053c0:	fed71ce3          	bne	a4,a3,800053b8 <kexec+0x2b8>
      last = s + 1;
    800053c4:	def43823          	sd	a5,-528(s0)
    800053c8:	bfc5                	j	800053b8 <kexec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    800053ca:	4641                	li	a2,16
    800053cc:	df043583          	ld	a1,-528(s0)
    800053d0:	4e098513          	addi	a0,s3,1248
    800053d4:	af5fb0ef          	jal	80000ec8 <safestrcpy>
  oldpagetable = p->pagetable;
    800053d8:	0589b503          	ld	a0,88(s3)
  p->pagetable = pagetable;
    800053dc:	0569bc23          	sd	s6,88(s3)
  p->sz = sz;
    800053e0:	0529b823          	sd	s2,80(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    800053e4:	0609b783          	ld	a5,96(s3)
    800053e8:	e6843703          	ld	a4,-408(s0)
    800053ec:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    800053ee:	0609b783          	ld	a5,96(s3)
    800053f2:	0377b823          	sd	s7,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800053f6:	85d6                	mv	a1,s5
    800053f8:	c25fc0ef          	jal	8000201c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800053fc:	0004851b          	sext.w	a0,s1
    80005400:	79fe                	ld	s3,504(sp)
    80005402:	7a5e                	ld	s4,496(sp)
    80005404:	7abe                	ld	s5,488(sp)
    80005406:	7b1e                	ld	s6,480(sp)
    80005408:	6bfe                	ld	s7,472(sp)
    8000540a:	6c5e                	ld	s8,464(sp)
    8000540c:	6cbe                	ld	s9,456(sp)
    8000540e:	6d1e                	ld	s10,448(sp)
    80005410:	b38d                	j	80005172 <kexec+0x72>
    80005412:	7b1e                	ld	s6,480(sp)
    80005414:	bb81                	j	80005164 <kexec+0x64>
  sz = sz1;
    80005416:	8c4a                	mv	s8,s2
    80005418:	bd7d                	j	800052d6 <kexec+0x1d6>
    8000541a:	8c4a                	mv	s8,s2
    8000541c:	bd6d                	j	800052d6 <kexec+0x1d6>
    8000541e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005422:	df843583          	ld	a1,-520(s0)
    80005426:	855a                	mv	a0,s6
    80005428:	bf5fc0ef          	jal	8000201c <proc_freepagetable>
  if (ip) {
    8000542c:	79fe                	ld	s3,504(sp)
    8000542e:	7abe                	ld	s5,488(sp)
    80005430:	7b1e                	ld	s6,480(sp)
    80005432:	6bfe                	ld	s7,472(sp)
    80005434:	6c5e                	ld	s8,464(sp)
    80005436:	6cbe                	ld	s9,456(sp)
    80005438:	6d1e                	ld	s10,448(sp)
    8000543a:	7dfa                	ld	s11,440(sp)
    8000543c:	b325                	j	80005164 <kexec+0x64>
    8000543e:	df243c23          	sd	s2,-520(s0)
    80005442:	b7c5                	j	80005422 <kexec+0x322>
    80005444:	df243c23          	sd	s2,-520(s0)
    80005448:	bfe9                	j	80005422 <kexec+0x322>
    8000544a:	df243c23          	sd	s2,-520(s0)
    8000544e:	bfd1                	j	80005422 <kexec+0x322>
    80005450:	df243c23          	sd	s2,-520(s0)
    80005454:	b7f9                	j	80005422 <kexec+0x322>

0000000080005456 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005456:	7179                	addi	sp,sp,-48
    80005458:	f406                	sd	ra,40(sp)
    8000545a:	f022                	sd	s0,32(sp)
    8000545c:	ec26                	sd	s1,24(sp)
    8000545e:	e84a                	sd	s2,16(sp)
    80005460:	1800                	addi	s0,sp,48
    80005462:	892e                	mv	s2,a1
    80005464:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005466:	fdc40593          	addi	a1,s0,-36
    8000546a:	ac9fd0ef          	jal	80002f32 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000546e:	fdc42703          	lw	a4,-36(s0)
    80005472:	47bd                	li	a5,15
    80005474:	02e7e963          	bltu	a5,a4,800054a6 <argfd+0x50>
    80005478:	a1ffc0ef          	jal	80001e96 <myproc>
    8000547c:	fdc42703          	lw	a4,-36(s0)
    80005480:	01a70793          	addi	a5,a4,26
    80005484:	078e                	slli	a5,a5,0x3
    80005486:	953e                	add	a0,a0,a5
    80005488:	651c                	ld	a5,8(a0)
    8000548a:	c385                	beqz	a5,800054aa <argfd+0x54>
    return -1;
  if (pfd)
    8000548c:	00090463          	beqz	s2,80005494 <argfd+0x3e>
    *pfd = fd;
    80005490:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80005494:	4501                	li	a0,0
  if (pf)
    80005496:	c091                	beqz	s1,8000549a <argfd+0x44>
    *pf = f;
    80005498:	e09c                	sd	a5,0(s1)
}
    8000549a:	70a2                	ld	ra,40(sp)
    8000549c:	7402                	ld	s0,32(sp)
    8000549e:	64e2                	ld	s1,24(sp)
    800054a0:	6942                	ld	s2,16(sp)
    800054a2:	6145                	addi	sp,sp,48
    800054a4:	8082                	ret
    return -1;
    800054a6:	557d                	li	a0,-1
    800054a8:	bfcd                	j	8000549a <argfd+0x44>
    800054aa:	557d                	li	a0,-1
    800054ac:	b7fd                	j	8000549a <argfd+0x44>

00000000800054ae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800054ae:	1101                	addi	sp,sp,-32
    800054b0:	ec06                	sd	ra,24(sp)
    800054b2:	e822                	sd	s0,16(sp)
    800054b4:	e426                	sd	s1,8(sp)
    800054b6:	1000                	addi	s0,sp,32
    800054b8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800054ba:	9ddfc0ef          	jal	80001e96 <myproc>
    800054be:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    800054c0:	0d850793          	addi	a5,a0,216
    800054c4:	4501                	li	a0,0
    800054c6:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    800054c8:	6398                	ld	a4,0(a5)
    800054ca:	cb19                	beqz	a4,800054e0 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    800054cc:	2505                	addiw	a0,a0,1
    800054ce:	07a1                	addi	a5,a5,8
    800054d0:	fed51ce3          	bne	a0,a3,800054c8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800054d4:	557d                	li	a0,-1
}
    800054d6:	60e2                	ld	ra,24(sp)
    800054d8:	6442                	ld	s0,16(sp)
    800054da:	64a2                	ld	s1,8(sp)
    800054dc:	6105                	addi	sp,sp,32
    800054de:	8082                	ret
      p->ofile[fd] = f;
    800054e0:	01a50793          	addi	a5,a0,26
    800054e4:	078e                	slli	a5,a5,0x3
    800054e6:	963e                	add	a2,a2,a5
    800054e8:	e604                	sd	s1,8(a2)
      return fd;
    800054ea:	b7f5                	j	800054d6 <fdalloc+0x28>

00000000800054ec <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800054ec:	715d                	addi	sp,sp,-80
    800054ee:	e486                	sd	ra,72(sp)
    800054f0:	e0a2                	sd	s0,64(sp)
    800054f2:	fc26                	sd	s1,56(sp)
    800054f4:	f84a                	sd	s2,48(sp)
    800054f6:	f44e                	sd	s3,40(sp)
    800054f8:	f052                	sd	s4,32(sp)
    800054fa:	ec56                	sd	s5,24(sp)
    800054fc:	0880                	addi	s0,sp,80
    800054fe:	892e                	mv	s2,a1
    80005500:	89b2                	mv	s3,a2
    80005502:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80005504:	fb040593          	addi	a1,s0,-80
    80005508:	efffe0ef          	jal	80004406 <nameiparent>
    8000550c:	8aaa                	mv	s5,a0
    8000550e:	cd45                	beqz	a0,800055c6 <create+0xda>
    return 0;

  ilock(dp);
    80005510:	e54fe0ef          	jal	80003b64 <ilock>

  if (dp->nlink == 0) {
    80005514:	04aa9783          	lh	a5,74(s5) # 104a <_entry-0x7fffefb6>
    80005518:	cf8d                	beqz	a5,80005552 <create+0x66>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    8000551a:	4705                	li	a4,1
    8000551c:	04e91563          	bne	s2,a4,80005566 <create+0x7a>
    80005520:	6721                	lui	a4,0x8
    80005522:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80005524:	02e78c63          	beq	a5,a4,8000555c <create+0x70>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005528:	4601                	li	a2,0
    8000552a:	fb040593          	addi	a1,s0,-80
    8000552e:	8556                	mv	a0,s5
    80005530:	c21fe0ef          	jal	80004150 <dirlookup>
    80005534:	84aa                	mv	s1,a0
    80005536:	e951                	bnez	a0,800055ca <create+0xde>
      return ip;
    iunlockput(ip);
    return 0;
  }

  if ((ip = ialloc(dp->dev, type)) == 0) {
    80005538:	85ca                	mv	a1,s2
    8000553a:	000aa503          	lw	a0,0(s5)
    8000553e:	cb6fe0ef          	jal	800039f4 <ialloc>
    80005542:	84aa                	mv	s1,a0
    80005544:	0c051e63          	bnez	a0,80005620 <create+0x134>
    iunlockput(dp);
    80005548:	8556                	mv	a0,s5
    8000554a:	86dfe0ef          	jal	80003db6 <iunlockput>
    return 0;
    8000554e:	4481                	li	s1,0
    80005550:	a0a1                	j	80005598 <create+0xac>
    iunlockput(dp);
    80005552:	8556                	mv	a0,s5
    80005554:	863fe0ef          	jal	80003db6 <iunlockput>
    return 0;
    80005558:	4481                	li	s1,0
    8000555a:	a83d                	j	80005598 <create+0xac>
    iunlockput(dp);
    8000555c:	8556                	mv	a0,s5
    8000555e:	859fe0ef          	jal	80003db6 <iunlockput>
    return 0;
    80005562:	4481                	li	s1,0
    80005564:	a815                	j	80005598 <create+0xac>
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80005566:	4601                	li	a2,0
    80005568:	fb040593          	addi	a1,s0,-80
    8000556c:	8556                	mv	a0,s5
    8000556e:	be3fe0ef          	jal	80004150 <dirlookup>
    80005572:	84aa                	mv	s1,a0
    80005574:	c535                	beqz	a0,800055e0 <create+0xf4>
    iunlockput(dp);
    80005576:	8556                	mv	a0,s5
    80005578:	83ffe0ef          	jal	80003db6 <iunlockput>
    ilock(ip);
    8000557c:	8526                	mv	a0,s1
    8000557e:	de6fe0ef          	jal	80003b64 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005582:	4789                	li	a5,2
    80005584:	04f91963          	bne	s2,a5,800055d6 <create+0xea>
    80005588:	0444d783          	lhu	a5,68(s1)
    8000558c:	37f9                	addiw	a5,a5,-2
    8000558e:	17c2                	slli	a5,a5,0x30
    80005590:	93c1                	srli	a5,a5,0x30
    80005592:	4705                	li	a4,1
    80005594:	04f76163          	bltu	a4,a5,800055d6 <create+0xea>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005598:	8526                	mv	a0,s1
    8000559a:	60a6                	ld	ra,72(sp)
    8000559c:	6406                	ld	s0,64(sp)
    8000559e:	74e2                	ld	s1,56(sp)
    800055a0:	7942                	ld	s2,48(sp)
    800055a2:	79a2                	ld	s3,40(sp)
    800055a4:	7a02                	ld	s4,32(sp)
    800055a6:	6ae2                	ld	s5,24(sp)
    800055a8:	6161                	addi	sp,sp,80
    800055aa:	8082                	ret
  ip->nlink = 0;
    800055ac:	04049523          	sh	zero,74(s1)
  iupdate(ip);
    800055b0:	8526                	mv	a0,s1
    800055b2:	cfefe0ef          	jal	80003ab0 <iupdate>
  iunlockput(ip);
    800055b6:	8526                	mv	a0,s1
    800055b8:	ffefe0ef          	jal	80003db6 <iunlockput>
  iunlockput(dp);
    800055bc:	8556                	mv	a0,s5
    800055be:	ff8fe0ef          	jal	80003db6 <iunlockput>
  return 0;
    800055c2:	4481                	li	s1,0
    800055c4:	bfd1                	j	80005598 <create+0xac>
    return 0;
    800055c6:	84aa                	mv	s1,a0
    800055c8:	bfc1                	j	80005598 <create+0xac>
    iunlockput(dp);
    800055ca:	8556                	mv	a0,s5
    800055cc:	feafe0ef          	jal	80003db6 <iunlockput>
    ilock(ip);
    800055d0:	8526                	mv	a0,s1
    800055d2:	d92fe0ef          	jal	80003b64 <ilock>
    iunlockput(ip);
    800055d6:	8526                	mv	a0,s1
    800055d8:	fdefe0ef          	jal	80003db6 <iunlockput>
    return 0;
    800055dc:	4481                	li	s1,0
    800055de:	bf6d                	j	80005598 <create+0xac>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    800055e0:	85ca                	mv	a1,s2
    800055e2:	000aa503          	lw	a0,0(s5)
    800055e6:	c0efe0ef          	jal	800039f4 <ialloc>
    800055ea:	84aa                	mv	s1,a0
    800055ec:	dd31                	beqz	a0,80005548 <create+0x5c>
  ilock(ip);
    800055ee:	8526                	mv	a0,s1
    800055f0:	d74fe0ef          	jal	80003b64 <ilock>
  ip->major = major;
    800055f4:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    800055f8:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    800055fc:	4785                	li	a5,1
    800055fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005602:	8526                	mv	a0,s1
    80005604:	cacfe0ef          	jal	80003ab0 <iupdate>
  if (dirlink(dp, name, ip->inum) < 0)
    80005608:	40d0                	lw	a2,4(s1)
    8000560a:	fb040593          	addi	a1,s0,-80
    8000560e:	8556                	mv	a0,s5
    80005610:	d33fe0ef          	jal	80004342 <dirlink>
    80005614:	f8054ce3          	bltz	a0,800055ac <create+0xc0>
  iunlockput(dp);
    80005618:	8556                	mv	a0,s5
    8000561a:	f9cfe0ef          	jal	80003db6 <iunlockput>
  return ip;
    8000561e:	bfad                	j	80005598 <create+0xac>
  ilock(ip);
    80005620:	8526                	mv	a0,s1
    80005622:	d42fe0ef          	jal	80003b64 <ilock>
  ip->major = major;
    80005626:	05349323          	sh	s3,70(s1)
  ip->minor = minor;
    8000562a:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000562e:	4785                	li	a5,1
    80005630:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005634:	8526                	mv	a0,s1
    80005636:	c7afe0ef          	jal	80003ab0 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000563a:	40d0                	lw	a2,4(s1)
    8000563c:	00003597          	auipc	a1,0x3
    80005640:	fc458593          	addi	a1,a1,-60 # 80008600 <etext+0x600>
    80005644:	8526                	mv	a0,s1
    80005646:	cfdfe0ef          	jal	80004342 <dirlink>
    8000564a:	f60541e3          	bltz	a0,800055ac <create+0xc0>
    8000564e:	004aa603          	lw	a2,4(s5)
    80005652:	00003597          	auipc	a1,0x3
    80005656:	fa658593          	addi	a1,a1,-90 # 800085f8 <etext+0x5f8>
    8000565a:	8526                	mv	a0,s1
    8000565c:	ce7fe0ef          	jal	80004342 <dirlink>
    80005660:	f40546e3          	bltz	a0,800055ac <create+0xc0>
  if (dirlink(dp, name, ip->inum) < 0)
    80005664:	40d0                	lw	a2,4(s1)
    80005666:	fb040593          	addi	a1,s0,-80
    8000566a:	8556                	mv	a0,s5
    8000566c:	cd7fe0ef          	jal	80004342 <dirlink>
    80005670:	f2054ee3          	bltz	a0,800055ac <create+0xc0>
    dp->nlink++; // for ".."
    80005674:	04aad783          	lhu	a5,74(s5)
    80005678:	2785                	addiw	a5,a5,1
    8000567a:	04fa9523          	sh	a5,74(s5)
    iupdate(dp);
    8000567e:	8556                	mv	a0,s5
    80005680:	c30fe0ef          	jal	80003ab0 <iupdate>
    80005684:	bf51                	j	80005618 <create+0x12c>

0000000080005686 <sys_dup>:
{
    80005686:	7179                	addi	sp,sp,-48
    80005688:	f406                	sd	ra,40(sp)
    8000568a:	f022                	sd	s0,32(sp)
    8000568c:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    8000568e:	fd840613          	addi	a2,s0,-40
    80005692:	4581                	li	a1,0
    80005694:	4501                	li	a0,0
    80005696:	dc1ff0ef          	jal	80005456 <argfd>
    return -1;
    8000569a:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    8000569c:	02054363          	bltz	a0,800056c2 <sys_dup+0x3c>
    800056a0:	ec26                	sd	s1,24(sp)
    800056a2:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    800056a4:	fd843903          	ld	s2,-40(s0)
    800056a8:	854a                	mv	a0,s2
    800056aa:	e05ff0ef          	jal	800054ae <fdalloc>
    800056ae:	84aa                	mv	s1,a0
    return -1;
    800056b0:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    800056b2:	00054d63          	bltz	a0,800056cc <sys_dup+0x46>
  filedup(f);
    800056b6:	854a                	mv	a0,s2
    800056b8:	b7aff0ef          	jal	80004a32 <filedup>
  return fd;
    800056bc:	87a6                	mv	a5,s1
    800056be:	64e2                	ld	s1,24(sp)
    800056c0:	6942                	ld	s2,16(sp)
}
    800056c2:	853e                	mv	a0,a5
    800056c4:	70a2                	ld	ra,40(sp)
    800056c6:	7402                	ld	s0,32(sp)
    800056c8:	6145                	addi	sp,sp,48
    800056ca:	8082                	ret
    800056cc:	64e2                	ld	s1,24(sp)
    800056ce:	6942                	ld	s2,16(sp)
    800056d0:	bfcd                	j	800056c2 <sys_dup+0x3c>

00000000800056d2 <sys_read>:
{
    800056d2:	7179                	addi	sp,sp,-48
    800056d4:	f406                	sd	ra,40(sp)
    800056d6:	f022                	sd	s0,32(sp)
    800056d8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800056da:	fd840593          	addi	a1,s0,-40
    800056de:	4505                	li	a0,1
    800056e0:	86ffd0ef          	jal	80002f4e <argaddr>
  argint(2, &n);
    800056e4:	fe440593          	addi	a1,s0,-28
    800056e8:	4509                	li	a0,2
    800056ea:	849fd0ef          	jal	80002f32 <argint>
  if (argfd(0, 0, &f) < 0)
    800056ee:	fe840613          	addi	a2,s0,-24
    800056f2:	4581                	li	a1,0
    800056f4:	4501                	li	a0,0
    800056f6:	d61ff0ef          	jal	80005456 <argfd>
    800056fa:	87aa                	mv	a5,a0
    return -1;
    800056fc:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800056fe:	0007ca63          	bltz	a5,80005712 <sys_read+0x40>
  return fileread(f, p, n);
    80005702:	fe442603          	lw	a2,-28(s0)
    80005706:	fd843583          	ld	a1,-40(s0)
    8000570a:	fe843503          	ld	a0,-24(s0)
    8000570e:	c8eff0ef          	jal	80004b9c <fileread>
}
    80005712:	70a2                	ld	ra,40(sp)
    80005714:	7402                	ld	s0,32(sp)
    80005716:	6145                	addi	sp,sp,48
    80005718:	8082                	ret

000000008000571a <sys_write>:
{
    8000571a:	7179                	addi	sp,sp,-48
    8000571c:	f406                	sd	ra,40(sp)
    8000571e:	f022                	sd	s0,32(sp)
    80005720:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005722:	fd840593          	addi	a1,s0,-40
    80005726:	4505                	li	a0,1
    80005728:	827fd0ef          	jal	80002f4e <argaddr>
  argint(2, &n);
    8000572c:	fe440593          	addi	a1,s0,-28
    80005730:	4509                	li	a0,2
    80005732:	801fd0ef          	jal	80002f32 <argint>
  if (argfd(0, 0, &f) < 0)
    80005736:	fe840613          	addi	a2,s0,-24
    8000573a:	4581                	li	a1,0
    8000573c:	4501                	li	a0,0
    8000573e:	d19ff0ef          	jal	80005456 <argfd>
    80005742:	87aa                	mv	a5,a0
    return -1;
    80005744:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005746:	0007ca63          	bltz	a5,8000575a <sys_write+0x40>
  return filewrite(f, p, n);
    8000574a:	fe442603          	lw	a2,-28(s0)
    8000574e:	fd843583          	ld	a1,-40(s0)
    80005752:	fe843503          	ld	a0,-24(s0)
    80005756:	d10ff0ef          	jal	80004c66 <filewrite>
}
    8000575a:	70a2                	ld	ra,40(sp)
    8000575c:	7402                	ld	s0,32(sp)
    8000575e:	6145                	addi	sp,sp,48
    80005760:	8082                	ret

0000000080005762 <sys_close>:
{
    80005762:	1101                	addi	sp,sp,-32
    80005764:	ec06                	sd	ra,24(sp)
    80005766:	e822                	sd	s0,16(sp)
    80005768:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    8000576a:	fe040613          	addi	a2,s0,-32
    8000576e:	fec40593          	addi	a1,s0,-20
    80005772:	4501                	li	a0,0
    80005774:	ce3ff0ef          	jal	80005456 <argfd>
    return -1;
    80005778:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    8000577a:	02054063          	bltz	a0,8000579a <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000577e:	f18fc0ef          	jal	80001e96 <myproc>
    80005782:	fec42783          	lw	a5,-20(s0)
    80005786:	07e9                	addi	a5,a5,26
    80005788:	078e                	slli	a5,a5,0x3
    8000578a:	953e                	add	a0,a0,a5
    8000578c:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005790:	fe043503          	ld	a0,-32(s0)
    80005794:	ae4ff0ef          	jal	80004a78 <fileclose>
  return 0;
    80005798:	4781                	li	a5,0
}
    8000579a:	853e                	mv	a0,a5
    8000579c:	60e2                	ld	ra,24(sp)
    8000579e:	6442                	ld	s0,16(sp)
    800057a0:	6105                	addi	sp,sp,32
    800057a2:	8082                	ret

00000000800057a4 <sys_fstat>:
{
    800057a4:	1101                	addi	sp,sp,-32
    800057a6:	ec06                	sd	ra,24(sp)
    800057a8:	e822                	sd	s0,16(sp)
    800057aa:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800057ac:	fe040593          	addi	a1,s0,-32
    800057b0:	4505                	li	a0,1
    800057b2:	f9cfd0ef          	jal	80002f4e <argaddr>
  if (argfd(0, 0, &f) < 0)
    800057b6:	fe840613          	addi	a2,s0,-24
    800057ba:	4581                	li	a1,0
    800057bc:	4501                	li	a0,0
    800057be:	c99ff0ef          	jal	80005456 <argfd>
    800057c2:	87aa                	mv	a5,a0
    return -1;
    800057c4:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    800057c6:	0007c863          	bltz	a5,800057d6 <sys_fstat+0x32>
  return filestat(f, st);
    800057ca:	fe043583          	ld	a1,-32(s0)
    800057ce:	fe843503          	ld	a0,-24(s0)
    800057d2:	b64ff0ef          	jal	80004b36 <filestat>
}
    800057d6:	60e2                	ld	ra,24(sp)
    800057d8:	6442                	ld	s0,16(sp)
    800057da:	6105                	addi	sp,sp,32
    800057dc:	8082                	ret

00000000800057de <sys_link>:
{
    800057de:	7169                	addi	sp,sp,-304
    800057e0:	f606                	sd	ra,296(sp)
    800057e2:	f222                	sd	s0,288(sp)
    800057e4:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057e6:	08000613          	li	a2,128
    800057ea:	ed040593          	addi	a1,s0,-304
    800057ee:	4501                	li	a0,0
    800057f0:	f7afd0ef          	jal	80002f6a <argstr>
    return -1;
    800057f4:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800057f6:	10054163          	bltz	a0,800058f8 <sys_link+0x11a>
    800057fa:	08000613          	li	a2,128
    800057fe:	f5040593          	addi	a1,s0,-176
    80005802:	4505                	li	a0,1
    80005804:	f66fd0ef          	jal	80002f6a <argstr>
    return -1;
    80005808:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000580a:	0e054763          	bltz	a0,800058f8 <sys_link+0x11a>
    8000580e:	ee26                	sd	s1,280(sp)
  begin_op();
    80005810:	db7fe0ef          	jal	800045c6 <begin_op>
  if ((ip = namei(old)) == 0) {
    80005814:	ed040513          	addi	a0,s0,-304
    80005818:	bd5fe0ef          	jal	800043ec <namei>
    8000581c:	84aa                	mv	s1,a0
    8000581e:	cd35                	beqz	a0,8000589a <sys_link+0xbc>
  ilock(ip);
    80005820:	b44fe0ef          	jal	80003b64 <ilock>
  if (ip->type == T_DIR) {
    80005824:	04449703          	lh	a4,68(s1)
    80005828:	4785                	li	a5,1
    8000582a:	06f70d63          	beq	a4,a5,800058a4 <sys_link+0xc6>
  if (ip->nlink >= NLINK_MAX) {
    8000582e:	04a49783          	lh	a5,74(s1)
    80005832:	6721                	lui	a4,0x8
    80005834:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80005836:	06e78f63          	beq	a5,a4,800058b4 <sys_link+0xd6>
    8000583a:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000583c:	2785                	addiw	a5,a5,1
    8000583e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005842:	8526                	mv	a0,s1
    80005844:	a6cfe0ef          	jal	80003ab0 <iupdate>
  iunlock(ip);
    80005848:	8526                	mv	a0,s1
    8000584a:	bc8fe0ef          	jal	80003c12 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000584e:	fd040593          	addi	a1,s0,-48
    80005852:	f5040513          	addi	a0,s0,-176
    80005856:	bb1fe0ef          	jal	80004406 <nameiparent>
    8000585a:	892a                	mv	s2,a0
    8000585c:	c93d                	beqz	a0,800058d2 <sys_link+0xf4>
  ilock(dp);
    8000585e:	b06fe0ef          	jal	80003b64 <ilock>
  if (dp->nlink == 0) {
    80005862:	04a91783          	lh	a5,74(s2)
    80005866:	cfb9                	beqz	a5,800058c4 <sys_link+0xe6>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80005868:	00092703          	lw	a4,0(s2)
    8000586c:	409c                	lw	a5,0(s1)
    8000586e:	04f71f63          	bne	a4,a5,800058cc <sys_link+0xee>
    80005872:	40d0                	lw	a2,4(s1)
    80005874:	fd040593          	addi	a1,s0,-48
    80005878:	854a                	mv	a0,s2
    8000587a:	ac9fe0ef          	jal	80004342 <dirlink>
    8000587e:	04054763          	bltz	a0,800058cc <sys_link+0xee>
  iunlockput(dp);
    80005882:	854a                	mv	a0,s2
    80005884:	d32fe0ef          	jal	80003db6 <iunlockput>
  iput(ip);
    80005888:	8526                	mv	a0,s1
    8000588a:	c5cfe0ef          	jal	80003ce6 <iput>
  end_op();
    8000588e:	dbffe0ef          	jal	8000464c <end_op>
  return 0;
    80005892:	4781                	li	a5,0
    80005894:	64f2                	ld	s1,280(sp)
    80005896:	6952                	ld	s2,272(sp)
    80005898:	a085                	j	800058f8 <sys_link+0x11a>
    end_op();
    8000589a:	db3fe0ef          	jal	8000464c <end_op>
    return -1;
    8000589e:	57fd                	li	a5,-1
    800058a0:	64f2                	ld	s1,280(sp)
    800058a2:	a899                	j	800058f8 <sys_link+0x11a>
    iunlockput(ip);
    800058a4:	8526                	mv	a0,s1
    800058a6:	d10fe0ef          	jal	80003db6 <iunlockput>
    end_op();
    800058aa:	da3fe0ef          	jal	8000464c <end_op>
    return -1;
    800058ae:	57fd                	li	a5,-1
    800058b0:	64f2                	ld	s1,280(sp)
    800058b2:	a099                	j	800058f8 <sys_link+0x11a>
    iunlockput(ip);
    800058b4:	8526                	mv	a0,s1
    800058b6:	d00fe0ef          	jal	80003db6 <iunlockput>
    end_op();
    800058ba:	d93fe0ef          	jal	8000464c <end_op>
    return -1;
    800058be:	57fd                	li	a5,-1
    800058c0:	64f2                	ld	s1,280(sp)
    800058c2:	a81d                	j	800058f8 <sys_link+0x11a>
    iunlockput(dp);
    800058c4:	854a                	mv	a0,s2
    800058c6:	cf0fe0ef          	jal	80003db6 <iunlockput>
    goto bad;
    800058ca:	a021                	j	800058d2 <sys_link+0xf4>
    iunlockput(dp);
    800058cc:	854a                	mv	a0,s2
    800058ce:	ce8fe0ef          	jal	80003db6 <iunlockput>
  ilock(ip);
    800058d2:	8526                	mv	a0,s1
    800058d4:	a90fe0ef          	jal	80003b64 <ilock>
  ip->nlink--;
    800058d8:	04a4d783          	lhu	a5,74(s1)
    800058dc:	37fd                	addiw	a5,a5,-1
    800058de:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800058e2:	8526                	mv	a0,s1
    800058e4:	9ccfe0ef          	jal	80003ab0 <iupdate>
  iunlockput(ip);
    800058e8:	8526                	mv	a0,s1
    800058ea:	cccfe0ef          	jal	80003db6 <iunlockput>
  end_op();
    800058ee:	d5ffe0ef          	jal	8000464c <end_op>
  return -1;
    800058f2:	57fd                	li	a5,-1
    800058f4:	64f2                	ld	s1,280(sp)
    800058f6:	6952                	ld	s2,272(sp)
}
    800058f8:	853e                	mv	a0,a5
    800058fa:	70b2                	ld	ra,296(sp)
    800058fc:	7412                	ld	s0,288(sp)
    800058fe:	6155                	addi	sp,sp,304
    80005900:	8082                	ret

0000000080005902 <sys_unlink>:
{
    80005902:	7111                	addi	sp,sp,-256
    80005904:	fd86                	sd	ra,248(sp)
    80005906:	f9a2                	sd	s0,240(sp)
    80005908:	0200                	addi	s0,sp,256
  if (argstr(0, path, MAXPATH) < 0)
    8000590a:	08000613          	li	a2,128
    8000590e:	f2040593          	addi	a1,s0,-224
    80005912:	4501                	li	a0,0
    80005914:	e56fd0ef          	jal	80002f6a <argstr>
    80005918:	16054663          	bltz	a0,80005a84 <sys_unlink+0x182>
    8000591c:	f5a6                	sd	s1,232(sp)
  begin_op();
    8000591e:	ca9fe0ef          	jal	800045c6 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80005922:	fa040593          	addi	a1,s0,-96
    80005926:	f2040513          	addi	a0,s0,-224
    8000592a:	addfe0ef          	jal	80004406 <nameiparent>
    8000592e:	84aa                	mv	s1,a0
    80005930:	c955                	beqz	a0,800059e4 <sys_unlink+0xe2>
  ilock(dp);
    80005932:	a32fe0ef          	jal	80003b64 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005936:	00003597          	auipc	a1,0x3
    8000593a:	cca58593          	addi	a1,a1,-822 # 80008600 <etext+0x600>
    8000593e:	fa040513          	addi	a0,s0,-96
    80005942:	ff8fe0ef          	jal	8000413a <namecmp>
    80005946:	12050463          	beqz	a0,80005a6e <sys_unlink+0x16c>
    8000594a:	00003597          	auipc	a1,0x3
    8000594e:	cae58593          	addi	a1,a1,-850 # 800085f8 <etext+0x5f8>
    80005952:	fa040513          	addi	a0,s0,-96
    80005956:	fe4fe0ef          	jal	8000413a <namecmp>
    8000595a:	10050a63          	beqz	a0,80005a6e <sys_unlink+0x16c>
    8000595e:	f1ca                	sd	s2,224(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005960:	f1c40613          	addi	a2,s0,-228
    80005964:	fa040593          	addi	a1,s0,-96
    80005968:	8526                	mv	a0,s1
    8000596a:	fe6fe0ef          	jal	80004150 <dirlookup>
    8000596e:	892a                	mv	s2,a0
    80005970:	0e050e63          	beqz	a0,80005a6c <sys_unlink+0x16a>
    80005974:	edce                	sd	s3,216(sp)
  ilock(ip);
    80005976:	9eefe0ef          	jal	80003b64 <ilock>
  if (ip->nlink < 1)
    8000597a:	04a91783          	lh	a5,74(s2)
    8000597e:	06f05863          	blez	a5,800059ee <sys_unlink+0xec>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80005982:	04491703          	lh	a4,68(s2)
    80005986:	4785                	li	a5,1
    80005988:	06f70b63          	beq	a4,a5,800059fe <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    8000598c:	fb040993          	addi	s3,s0,-80
    80005990:	4641                	li	a2,16
    80005992:	4581                	li	a1,0
    80005994:	854e                	mv	a0,s3
    80005996:	be0fb0ef          	jal	80000d76 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000599a:	4741                	li	a4,16
    8000599c:	f1c42683          	lw	a3,-228(s0)
    800059a0:	864e                	mv	a2,s3
    800059a2:	4581                	li	a1,0
    800059a4:	8526                	mv	a0,s1
    800059a6:	e8afe0ef          	jal	80004030 <writei>
    800059aa:	47c1                	li	a5,16
    800059ac:	08f51f63          	bne	a0,a5,80005a4a <sys_unlink+0x148>
  if (ip->type == T_DIR) {
    800059b0:	04491703          	lh	a4,68(s2)
    800059b4:	4785                	li	a5,1
    800059b6:	0af70263          	beq	a4,a5,80005a5a <sys_unlink+0x158>
  iunlockput(dp);
    800059ba:	8526                	mv	a0,s1
    800059bc:	bfafe0ef          	jal	80003db6 <iunlockput>
  ip->nlink--;
    800059c0:	04a95783          	lhu	a5,74(s2)
    800059c4:	37fd                	addiw	a5,a5,-1
    800059c6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059ca:	854a                	mv	a0,s2
    800059cc:	8e4fe0ef          	jal	80003ab0 <iupdate>
  iunlockput(ip);
    800059d0:	854a                	mv	a0,s2
    800059d2:	be4fe0ef          	jal	80003db6 <iunlockput>
  end_op();
    800059d6:	c77fe0ef          	jal	8000464c <end_op>
  return 0;
    800059da:	4501                	li	a0,0
    800059dc:	74ae                	ld	s1,232(sp)
    800059de:	790e                	ld	s2,224(sp)
    800059e0:	69ee                	ld	s3,216(sp)
    800059e2:	a869                	j	80005a7c <sys_unlink+0x17a>
    end_op();
    800059e4:	c69fe0ef          	jal	8000464c <end_op>
    return -1;
    800059e8:	557d                	li	a0,-1
    800059ea:	74ae                	ld	s1,232(sp)
    800059ec:	a841                	j	80005a7c <sys_unlink+0x17a>
    800059ee:	e9d2                	sd	s4,208(sp)
    800059f0:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800059f2:	00003517          	auipc	a0,0x3
    800059f6:	c1650513          	addi	a0,a0,-1002 # 80008608 <etext+0x608>
    800059fa:	df5fa0ef          	jal	800007ee <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800059fe:	04c92703          	lw	a4,76(s2)
    80005a02:	02000793          	li	a5,32
    80005a06:	f8e7f3e3          	bgeu	a5,a4,8000598c <sys_unlink+0x8a>
    80005a0a:	e9d2                	sd	s4,208(sp)
    80005a0c:	e5d6                	sd	s5,200(sp)
    80005a0e:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a10:	f0840a93          	addi	s5,s0,-248
    80005a14:	4a41                	li	s4,16
    80005a16:	8752                	mv	a4,s4
    80005a18:	86ce                	mv	a3,s3
    80005a1a:	8656                	mv	a2,s5
    80005a1c:	4581                	li	a1,0
    80005a1e:	854a                	mv	a0,s2
    80005a20:	d1efe0ef          	jal	80003f3e <readi>
    80005a24:	01451d63          	bne	a0,s4,80005a3e <sys_unlink+0x13c>
    if (de.inum != 0)
    80005a28:	f0845783          	lhu	a5,-248(s0)
    80005a2c:	efb1                	bnez	a5,80005a88 <sys_unlink+0x186>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80005a2e:	29c1                	addiw	s3,s3,16
    80005a30:	04c92783          	lw	a5,76(s2)
    80005a34:	fef9e1e3          	bltu	s3,a5,80005a16 <sys_unlink+0x114>
    80005a38:	6a4e                	ld	s4,208(sp)
    80005a3a:	6aae                	ld	s5,200(sp)
    80005a3c:	bf81                	j	8000598c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005a3e:	00003517          	auipc	a0,0x3
    80005a42:	be250513          	addi	a0,a0,-1054 # 80008620 <etext+0x620>
    80005a46:	da9fa0ef          	jal	800007ee <panic>
    80005a4a:	e9d2                	sd	s4,208(sp)
    80005a4c:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80005a4e:	00003517          	auipc	a0,0x3
    80005a52:	bea50513          	addi	a0,a0,-1046 # 80008638 <etext+0x638>
    80005a56:	d99fa0ef          	jal	800007ee <panic>
    dp->nlink--;
    80005a5a:	04a4d783          	lhu	a5,74(s1)
    80005a5e:	37fd                	addiw	a5,a5,-1
    80005a60:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a64:	8526                	mv	a0,s1
    80005a66:	84afe0ef          	jal	80003ab0 <iupdate>
    80005a6a:	bf81                	j	800059ba <sys_unlink+0xb8>
    80005a6c:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80005a6e:	8526                	mv	a0,s1
    80005a70:	b46fe0ef          	jal	80003db6 <iunlockput>
  end_op();
    80005a74:	bd9fe0ef          	jal	8000464c <end_op>
  return -1;
    80005a78:	557d                	li	a0,-1
    80005a7a:	74ae                	ld	s1,232(sp)
}
    80005a7c:	70ee                	ld	ra,248(sp)
    80005a7e:	744e                	ld	s0,240(sp)
    80005a80:	6111                	addi	sp,sp,256
    80005a82:	8082                	ret
    return -1;
    80005a84:	557d                	li	a0,-1
    80005a86:	bfdd                	j	80005a7c <sys_unlink+0x17a>
    iunlockput(ip);
    80005a88:	854a                	mv	a0,s2
    80005a8a:	b2cfe0ef          	jal	80003db6 <iunlockput>
    goto bad;
    80005a8e:	790e                	ld	s2,224(sp)
    80005a90:	69ee                	ld	s3,216(sp)
    80005a92:	6a4e                	ld	s4,208(sp)
    80005a94:	6aae                	ld	s5,200(sp)
    80005a96:	bfe1                	j	80005a6e <sys_unlink+0x16c>

0000000080005a98 <sys_open>:

uint64
sys_open(void)
{
    80005a98:	7131                	addi	sp,sp,-192
    80005a9a:	fd06                	sd	ra,184(sp)
    80005a9c:	f922                	sd	s0,176(sp)
    80005a9e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005aa0:	f4c40593          	addi	a1,s0,-180
    80005aa4:	4505                	li	a0,1
    80005aa6:	c8cfd0ef          	jal	80002f32 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005aaa:	08000613          	li	a2,128
    80005aae:	f5040593          	addi	a1,s0,-176
    80005ab2:	4501                	li	a0,0
    80005ab4:	cb6fd0ef          	jal	80002f6a <argstr>
    80005ab8:	87aa                	mv	a5,a0
    return -1;
    80005aba:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005abc:	0a07c363          	bltz	a5,80005b62 <sys_open+0xca>
    80005ac0:	f526                	sd	s1,168(sp)

  begin_op();
    80005ac2:	b05fe0ef          	jal	800045c6 <begin_op>

  if (omode & O_CREATE) {
    80005ac6:	f4c42783          	lw	a5,-180(s0)
    80005aca:	2007f793          	andi	a5,a5,512
    80005ace:	c3dd                	beqz	a5,80005b74 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005ad0:	4681                	li	a3,0
    80005ad2:	4601                	li	a2,0
    80005ad4:	4589                	li	a1,2
    80005ad6:	f5040513          	addi	a0,s0,-176
    80005ada:	a13ff0ef          	jal	800054ec <create>
    80005ade:	84aa                	mv	s1,a0
    if (ip == 0) {
    80005ae0:	c549                	beqz	a0,80005b6a <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005ae2:	04449703          	lh	a4,68(s1)
    80005ae6:	478d                	li	a5,3
    80005ae8:	00f71763          	bne	a4,a5,80005af6 <sys_open+0x5e>
    80005aec:	0464d703          	lhu	a4,70(s1)
    80005af0:	47a5                	li	a5,9
    80005af2:	0ae7ee63          	bltu	a5,a4,80005bae <sys_open+0x116>
    80005af6:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005af8:	eddfe0ef          	jal	800049d4 <filealloc>
    80005afc:	892a                	mv	s2,a0
    80005afe:	c561                	beqz	a0,80005bc6 <sys_open+0x12e>
    80005b00:	ed4e                	sd	s3,152(sp)
    80005b02:	9adff0ef          	jal	800054ae <fdalloc>
    80005b06:	89aa                	mv	s3,a0
    80005b08:	0a054b63          	bltz	a0,80005bbe <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    80005b0c:	04449703          	lh	a4,68(s1)
    80005b10:	478d                	li	a5,3
    80005b12:	0cf70363          	beq	a4,a5,80005bd8 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b16:	4789                	li	a5,2
    80005b18:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005b1c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005b20:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005b24:	f4c42783          	lw	a5,-180(s0)
    80005b28:	0017f713          	andi	a4,a5,1
    80005b2c:	00174713          	xori	a4,a4,1
    80005b30:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b34:	0037f713          	andi	a4,a5,3
    80005b38:	00e03733          	snez	a4,a4
    80005b3c:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005b40:	4007f793          	andi	a5,a5,1024
    80005b44:	c791                	beqz	a5,80005b50 <sys_open+0xb8>
    80005b46:	04449703          	lh	a4,68(s1)
    80005b4a:	4789                	li	a5,2
    80005b4c:	08f70d63          	beq	a4,a5,80005be6 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005b50:	8526                	mv	a0,s1
    80005b52:	8c0fe0ef          	jal	80003c12 <iunlock>
  end_op();
    80005b56:	af7fe0ef          	jal	8000464c <end_op>

  return fd;
    80005b5a:	854e                	mv	a0,s3
    80005b5c:	74aa                	ld	s1,168(sp)
    80005b5e:	790a                	ld	s2,160(sp)
    80005b60:	69ea                	ld	s3,152(sp)
}
    80005b62:	70ea                	ld	ra,184(sp)
    80005b64:	744a                	ld	s0,176(sp)
    80005b66:	6129                	addi	sp,sp,192
    80005b68:	8082                	ret
      end_op();
    80005b6a:	ae3fe0ef          	jal	8000464c <end_op>
      return -1;
    80005b6e:	557d                	li	a0,-1
    80005b70:	74aa                	ld	s1,168(sp)
    80005b72:	bfc5                	j	80005b62 <sys_open+0xca>
    if ((ip = namei(path)) == 0) {
    80005b74:	f5040513          	addi	a0,s0,-176
    80005b78:	875fe0ef          	jal	800043ec <namei>
    80005b7c:	84aa                	mv	s1,a0
    80005b7e:	c11d                	beqz	a0,80005ba4 <sys_open+0x10c>
    ilock(ip);
    80005b80:	fe5fd0ef          	jal	80003b64 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005b84:	04449703          	lh	a4,68(s1)
    80005b88:	4785                	li	a5,1
    80005b8a:	f4f71ce3          	bne	a4,a5,80005ae2 <sys_open+0x4a>
    80005b8e:	f4c42783          	lw	a5,-180(s0)
    80005b92:	d3b5                	beqz	a5,80005af6 <sys_open+0x5e>
      iunlockput(ip);
    80005b94:	8526                	mv	a0,s1
    80005b96:	a20fe0ef          	jal	80003db6 <iunlockput>
      end_op();
    80005b9a:	ab3fe0ef          	jal	8000464c <end_op>
      return -1;
    80005b9e:	557d                	li	a0,-1
    80005ba0:	74aa                	ld	s1,168(sp)
    80005ba2:	b7c1                	j	80005b62 <sys_open+0xca>
      end_op();
    80005ba4:	aa9fe0ef          	jal	8000464c <end_op>
      return -1;
    80005ba8:	557d                	li	a0,-1
    80005baa:	74aa                	ld	s1,168(sp)
    80005bac:	bf5d                	j	80005b62 <sys_open+0xca>
    iunlockput(ip);
    80005bae:	8526                	mv	a0,s1
    80005bb0:	a06fe0ef          	jal	80003db6 <iunlockput>
    end_op();
    80005bb4:	a99fe0ef          	jal	8000464c <end_op>
    return -1;
    80005bb8:	557d                	li	a0,-1
    80005bba:	74aa                	ld	s1,168(sp)
    80005bbc:	b75d                	j	80005b62 <sys_open+0xca>
      fileclose(f);
    80005bbe:	854a                	mv	a0,s2
    80005bc0:	eb9fe0ef          	jal	80004a78 <fileclose>
    80005bc4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005bc6:	8526                	mv	a0,s1
    80005bc8:	9eefe0ef          	jal	80003db6 <iunlockput>
    end_op();
    80005bcc:	a81fe0ef          	jal	8000464c <end_op>
    return -1;
    80005bd0:	557d                	li	a0,-1
    80005bd2:	74aa                	ld	s1,168(sp)
    80005bd4:	790a                	ld	s2,160(sp)
    80005bd6:	b771                	j	80005b62 <sys_open+0xca>
    f->type = FD_DEVICE;
    80005bd8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005bdc:	04649783          	lh	a5,70(s1)
    80005be0:	02f91223          	sh	a5,36(s2)
    80005be4:	bf35                	j	80005b20 <sys_open+0x88>
    itrunc(ip);
    80005be6:	8526                	mv	a0,s1
    80005be8:	86afe0ef          	jal	80003c52 <itrunc>
    80005bec:	b795                	j	80005b50 <sys_open+0xb8>

0000000080005bee <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005bee:	7175                	addi	sp,sp,-144
    80005bf0:	e506                	sd	ra,136(sp)
    80005bf2:	e122                	sd	s0,128(sp)
    80005bf4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005bf6:	9d1fe0ef          	jal	800045c6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005bfa:	08000613          	li	a2,128
    80005bfe:	f7040593          	addi	a1,s0,-144
    80005c02:	4501                	li	a0,0
    80005c04:	b66fd0ef          	jal	80002f6a <argstr>
    80005c08:	02054363          	bltz	a0,80005c2e <sys_mkdir+0x40>
    80005c0c:	4681                	li	a3,0
    80005c0e:	4601                	li	a2,0
    80005c10:	4585                	li	a1,1
    80005c12:	f7040513          	addi	a0,s0,-144
    80005c16:	8d7ff0ef          	jal	800054ec <create>
    80005c1a:	c911                	beqz	a0,80005c2e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c1c:	99afe0ef          	jal	80003db6 <iunlockput>
  end_op();
    80005c20:	a2dfe0ef          	jal	8000464c <end_op>
  return 0;
    80005c24:	4501                	li	a0,0
}
    80005c26:	60aa                	ld	ra,136(sp)
    80005c28:	640a                	ld	s0,128(sp)
    80005c2a:	6149                	addi	sp,sp,144
    80005c2c:	8082                	ret
    end_op();
    80005c2e:	a1ffe0ef          	jal	8000464c <end_op>
    return -1;
    80005c32:	557d                	li	a0,-1
    80005c34:	bfcd                	j	80005c26 <sys_mkdir+0x38>

0000000080005c36 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c36:	7135                	addi	sp,sp,-160
    80005c38:	ed06                	sd	ra,152(sp)
    80005c3a:	e922                	sd	s0,144(sp)
    80005c3c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c3e:	989fe0ef          	jal	800045c6 <begin_op>
  argint(1, &major);
    80005c42:	f6c40593          	addi	a1,s0,-148
    80005c46:	4505                	li	a0,1
    80005c48:	aeafd0ef          	jal	80002f32 <argint>
  argint(2, &minor);
    80005c4c:	f6840593          	addi	a1,s0,-152
    80005c50:	4509                	li	a0,2
    80005c52:	ae0fd0ef          	jal	80002f32 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005c56:	08000613          	li	a2,128
    80005c5a:	f7040593          	addi	a1,s0,-144
    80005c5e:	4501                	li	a0,0
    80005c60:	b0afd0ef          	jal	80002f6a <argstr>
    80005c64:	02054563          	bltz	a0,80005c8e <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005c68:	f6841683          	lh	a3,-152(s0)
    80005c6c:	f6c41603          	lh	a2,-148(s0)
    80005c70:	458d                	li	a1,3
    80005c72:	f7040513          	addi	a0,s0,-144
    80005c76:	877ff0ef          	jal	800054ec <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005c7a:	c911                	beqz	a0,80005c8e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c7c:	93afe0ef          	jal	80003db6 <iunlockput>
  end_op();
    80005c80:	9cdfe0ef          	jal	8000464c <end_op>
  return 0;
    80005c84:	4501                	li	a0,0
}
    80005c86:	60ea                	ld	ra,152(sp)
    80005c88:	644a                	ld	s0,144(sp)
    80005c8a:	610d                	addi	sp,sp,160
    80005c8c:	8082                	ret
    end_op();
    80005c8e:	9bffe0ef          	jal	8000464c <end_op>
    return -1;
    80005c92:	557d                	li	a0,-1
    80005c94:	bfcd                	j	80005c86 <sys_mknod+0x50>

0000000080005c96 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c96:	7135                	addi	sp,sp,-160
    80005c98:	ed06                	sd	ra,152(sp)
    80005c9a:	e922                	sd	s0,144(sp)
    80005c9c:	e14a                	sd	s2,128(sp)
    80005c9e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ca0:	9f6fc0ef          	jal	80001e96 <myproc>
    80005ca4:	892a                	mv	s2,a0

  begin_op();
    80005ca6:	921fe0ef          	jal	800045c6 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005caa:	08000613          	li	a2,128
    80005cae:	f6040593          	addi	a1,s0,-160
    80005cb2:	4501                	li	a0,0
    80005cb4:	ab6fd0ef          	jal	80002f6a <argstr>
    80005cb8:	04054363          	bltz	a0,80005cfe <sys_chdir+0x68>
    80005cbc:	e526                	sd	s1,136(sp)
    80005cbe:	f6040513          	addi	a0,s0,-160
    80005cc2:	f2afe0ef          	jal	800043ec <namei>
    80005cc6:	84aa                	mv	s1,a0
    80005cc8:	c915                	beqz	a0,80005cfc <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cca:	e9bfd0ef          	jal	80003b64 <ilock>
  if (ip->type != T_DIR) {
    80005cce:	04449703          	lh	a4,68(s1)
    80005cd2:	4785                	li	a5,1
    80005cd4:	02f71963          	bne	a4,a5,80005d06 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005cd8:	8526                	mv	a0,s1
    80005cda:	f39fd0ef          	jal	80003c12 <iunlock>
  iput(p->cwd);
    80005cde:	15893503          	ld	a0,344(s2)
    80005ce2:	804fe0ef          	jal	80003ce6 <iput>
  end_op();
    80005ce6:	967fe0ef          	jal	8000464c <end_op>
  p->cwd = ip;
    80005cea:	14993c23          	sd	s1,344(s2)
  return 0;
    80005cee:	4501                	li	a0,0
    80005cf0:	64aa                	ld	s1,136(sp)
}
    80005cf2:	60ea                	ld	ra,152(sp)
    80005cf4:	644a                	ld	s0,144(sp)
    80005cf6:	690a                	ld	s2,128(sp)
    80005cf8:	610d                	addi	sp,sp,160
    80005cfa:	8082                	ret
    80005cfc:	64aa                	ld	s1,136(sp)
    end_op();
    80005cfe:	94ffe0ef          	jal	8000464c <end_op>
    return -1;
    80005d02:	557d                	li	a0,-1
    80005d04:	b7fd                	j	80005cf2 <sys_chdir+0x5c>
    iunlockput(ip);
    80005d06:	8526                	mv	a0,s1
    80005d08:	8aefe0ef          	jal	80003db6 <iunlockput>
    end_op();
    80005d0c:	941fe0ef          	jal	8000464c <end_op>
    return -1;
    80005d10:	557d                	li	a0,-1
    80005d12:	64aa                	ld	s1,136(sp)
    80005d14:	bff9                	j	80005cf2 <sys_chdir+0x5c>

0000000080005d16 <sys_exec>:

uint64
sys_exec(void)
{
    80005d16:	7105                	addi	sp,sp,-480
    80005d18:	ef86                	sd	ra,472(sp)
    80005d1a:	eba2                	sd	s0,464(sp)
    80005d1c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005d1e:	e2840593          	addi	a1,s0,-472
    80005d22:	4505                	li	a0,1
    80005d24:	a2afd0ef          	jal	80002f4e <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005d28:	08000613          	li	a2,128
    80005d2c:	f3040593          	addi	a1,s0,-208
    80005d30:	4501                	li	a0,0
    80005d32:	a38fd0ef          	jal	80002f6a <argstr>
    80005d36:	87aa                	mv	a5,a0
    return -1;
    80005d38:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0) {
    80005d3a:	0e07c063          	bltz	a5,80005e1a <sys_exec+0x104>
    80005d3e:	e7a6                	sd	s1,456(sp)
    80005d40:	e3ca                	sd	s2,448(sp)
    80005d42:	ff4e                	sd	s3,440(sp)
    80005d44:	fb52                	sd	s4,432(sp)
    80005d46:	f756                	sd	s5,424(sp)
    80005d48:	f35a                	sd	s6,416(sp)
    80005d4a:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005d4c:	e3040a13          	addi	s4,s0,-464
    80005d50:	10000613          	li	a2,256
    80005d54:	4581                	li	a1,0
    80005d56:	8552                	mv	a0,s4
    80005d58:	81efb0ef          	jal	80000d76 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005d5c:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005d5e:	89d2                	mv	s3,s4
    80005d60:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005d62:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d66:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    80005d68:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005d6c:	00391513          	slli	a0,s2,0x3
    80005d70:	85d6                	mv	a1,s5
    80005d72:	e2843783          	ld	a5,-472(s0)
    80005d76:	953e                	add	a0,a0,a5
    80005d78:	92efd0ef          	jal	80002ea6 <fetchaddr>
    80005d7c:	02054663          	bltz	a0,80005da8 <sys_exec+0x92>
    if (uarg == 0) {
    80005d80:	e2043783          	ld	a5,-480(s0)
    80005d84:	c7a1                	beqz	a5,80005dcc <sys_exec+0xb6>
    argv[i] = kalloc();
    80005d86:	daffa0ef          	jal	80000b34 <kalloc>
    80005d8a:	85aa                	mv	a1,a0
    80005d8c:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005d90:	cd01                	beqz	a0,80005da8 <sys_exec+0x92>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d92:	865a                	mv	a2,s6
    80005d94:	e2043503          	ld	a0,-480(s0)
    80005d98:	958fd0ef          	jal	80002ef0 <fetchstr>
    80005d9c:	00054663          	bltz	a0,80005da8 <sys_exec+0x92>
    if (i >= NELEM(argv)) {
    80005da0:	0905                	addi	s2,s2,1
    80005da2:	09a1                	addi	s3,s3,8
    80005da4:	fd7914e3          	bne	s2,s7,80005d6c <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005da8:	100a0a13          	addi	s4,s4,256 # fffffffffffff100 <end+0xffffffff7fdaf308>
    80005dac:	6088                	ld	a0,0(s1)
    80005dae:	cd31                	beqz	a0,80005e0a <sys_exec+0xf4>
    kfree(argv[i]);
    80005db0:	c31fa0ef          	jal	800009e0 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005db4:	04a1                	addi	s1,s1,8
    80005db6:	ff449be3          	bne	s1,s4,80005dac <sys_exec+0x96>
  return -1;
    80005dba:	557d                	li	a0,-1
    80005dbc:	64be                	ld	s1,456(sp)
    80005dbe:	691e                	ld	s2,448(sp)
    80005dc0:	79fa                	ld	s3,440(sp)
    80005dc2:	7a5a                	ld	s4,432(sp)
    80005dc4:	7aba                	ld	s5,424(sp)
    80005dc6:	7b1a                	ld	s6,416(sp)
    80005dc8:	6bfa                	ld	s7,408(sp)
    80005dca:	a881                	j	80005e1a <sys_exec+0x104>
      argv[i] = 0;
    80005dcc:	0009079b          	sext.w	a5,s2
    80005dd0:	e3040593          	addi	a1,s0,-464
    80005dd4:	078e                	slli	a5,a5,0x3
    80005dd6:	97ae                	add	a5,a5,a1
    80005dd8:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005ddc:	f3040513          	addi	a0,s0,-208
    80005de0:	b20ff0ef          	jal	80005100 <kexec>
    80005de4:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005de6:	100a0a13          	addi	s4,s4,256
    80005dea:	6088                	ld	a0,0(s1)
    80005dec:	c511                	beqz	a0,80005df8 <sys_exec+0xe2>
    kfree(argv[i]);
    80005dee:	bf3fa0ef          	jal	800009e0 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005df2:	04a1                	addi	s1,s1,8
    80005df4:	ff449be3          	bne	s1,s4,80005dea <sys_exec+0xd4>
  return ret;
    80005df8:	854a                	mv	a0,s2
    80005dfa:	64be                	ld	s1,456(sp)
    80005dfc:	691e                	ld	s2,448(sp)
    80005dfe:	79fa                	ld	s3,440(sp)
    80005e00:	7a5a                	ld	s4,432(sp)
    80005e02:	7aba                	ld	s5,424(sp)
    80005e04:	7b1a                	ld	s6,416(sp)
    80005e06:	6bfa                	ld	s7,408(sp)
    80005e08:	a809                	j	80005e1a <sys_exec+0x104>
  return -1;
    80005e0a:	557d                	li	a0,-1
    80005e0c:	64be                	ld	s1,456(sp)
    80005e0e:	691e                	ld	s2,448(sp)
    80005e10:	79fa                	ld	s3,440(sp)
    80005e12:	7a5a                	ld	s4,432(sp)
    80005e14:	7aba                	ld	s5,424(sp)
    80005e16:	7b1a                	ld	s6,416(sp)
    80005e18:	6bfa                	ld	s7,408(sp)
}
    80005e1a:	60fe                	ld	ra,472(sp)
    80005e1c:	645e                	ld	s0,464(sp)
    80005e1e:	613d                	addi	sp,sp,480
    80005e20:	8082                	ret

0000000080005e22 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e22:	7139                	addi	sp,sp,-64
    80005e24:	fc06                	sd	ra,56(sp)
    80005e26:	f822                	sd	s0,48(sp)
    80005e28:	f426                	sd	s1,40(sp)
    80005e2a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e2c:	86afc0ef          	jal	80001e96 <myproc>
    80005e30:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005e32:	fd840593          	addi	a1,s0,-40
    80005e36:	4501                	li	a0,0
    80005e38:	916fd0ef          	jal	80002f4e <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80005e3c:	fc840593          	addi	a1,s0,-56
    80005e40:	fd040513          	addi	a0,s0,-48
    80005e44:	f5bfe0ef          	jal	80004d9e <pipealloc>
    return -1;
    80005e48:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80005e4a:	0a054663          	bltz	a0,80005ef6 <sys_pipe+0xd4>
  fd0 = -1;
    80005e4e:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005e52:	fd043503          	ld	a0,-48(s0)
    80005e56:	e58ff0ef          	jal	800054ae <fdalloc>
    80005e5a:	fca42223          	sw	a0,-60(s0)
    80005e5e:	08054363          	bltz	a0,80005ee4 <sys_pipe+0xc2>
    80005e62:	fc843503          	ld	a0,-56(s0)
    80005e66:	e48ff0ef          	jal	800054ae <fdalloc>
    80005e6a:	fca42023          	sw	a0,-64(s0)
    80005e6e:	06054263          	bltz	a0,80005ed2 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005e72:	4711                	li	a4,4
    80005e74:	fc440693          	addi	a3,s0,-60
    80005e78:	fd843603          	ld	a2,-40(s0)
    80005e7c:	68ac                	ld	a1,80(s1)
    80005e7e:	6ca8                	ld	a0,88(s1)
    80005e80:	aa1fb0ef          	jal	80001920 <copyout>
    80005e84:	00054f63          	bltz	a0,80005ea2 <sys_pipe+0x80>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005e88:	4711                	li	a4,4
    80005e8a:	fc040693          	addi	a3,s0,-64
    80005e8e:	fd843603          	ld	a2,-40(s0)
    80005e92:	963a                	add	a2,a2,a4
    80005e94:	68ac                	ld	a1,80(s1)
    80005e96:	6ca8                	ld	a0,88(s1)
    80005e98:	a89fb0ef          	jal	80001920 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e9c:	4781                	li	a5,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005e9e:	04055c63          	bgez	a0,80005ef6 <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    80005ea2:	fc442783          	lw	a5,-60(s0)
    80005ea6:	07e9                	addi	a5,a5,26
    80005ea8:	078e                	slli	a5,a5,0x3
    80005eaa:	97a6                	add	a5,a5,s1
    80005eac:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005eb0:	fc042783          	lw	a5,-64(s0)
    80005eb4:	07e9                	addi	a5,a5,26
    80005eb6:	078e                	slli	a5,a5,0x3
    80005eb8:	94be                	add	s1,s1,a5
    80005eba:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005ebe:	fd043503          	ld	a0,-48(s0)
    80005ec2:	bb7fe0ef          	jal	80004a78 <fileclose>
    fileclose(wf);
    80005ec6:	fc843503          	ld	a0,-56(s0)
    80005eca:	baffe0ef          	jal	80004a78 <fileclose>
    return -1;
    80005ece:	57fd                	li	a5,-1
    80005ed0:	a01d                	j	80005ef6 <sys_pipe+0xd4>
    if (fd0 >= 0)
    80005ed2:	fc442783          	lw	a5,-60(s0)
    80005ed6:	0007c763          	bltz	a5,80005ee4 <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    80005eda:	07e9                	addi	a5,a5,26
    80005edc:	078e                	slli	a5,a5,0x3
    80005ede:	97a6                	add	a5,a5,s1
    80005ee0:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005ee4:	fd043503          	ld	a0,-48(s0)
    80005ee8:	b91fe0ef          	jal	80004a78 <fileclose>
    fileclose(wf);
    80005eec:	fc843503          	ld	a0,-56(s0)
    80005ef0:	b89fe0ef          	jal	80004a78 <fileclose>
    return -1;
    80005ef4:	57fd                	li	a5,-1
}
    80005ef6:	853e                	mv	a0,a5
    80005ef8:	70e2                	ld	ra,56(sp)
    80005efa:	7442                	ld	s0,48(sp)
    80005efc:	74a2                	ld	s1,40(sp)
    80005efe:	6121                	addi	sp,sp,64
    80005f00:	8082                	ret
	...

0000000080005f10 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005f10:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005f12:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005f14:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005f16:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005f18:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005f1a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005f1c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005f1e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005f20:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005f22:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005f24:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005f26:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005f28:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005f2a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005f2c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005f2e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005f30:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005f32:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005f34:	e79fc0ef          	jal	80002dac <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005f38:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005f3a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005f3c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005f3e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005f40:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005f42:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005f44:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005f46:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005f48:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005f4a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005f4c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005f4e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005f50:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005f52:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005f54:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005f56:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005f58:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005f5a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005f5c:	10200073          	sret
    80005f60:	0001                	nop
    80005f62:	00000013          	nop
    80005f66:	00000013          	nop
    80005f6a:	00000013          	nop

0000000080005f6e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f6e:	1141                	addi	sp,sp,-16
    80005f70:	e406                	sd	ra,8(sp)
    80005f72:	e022                	sd	s0,0(sp)
    80005f74:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005f76:	0c000737          	lui	a4,0xc000
    80005f7a:	4785                	li	a5,1
    80005f7c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    80005f7e:	c35c                	sw	a5,4(a4)
}
    80005f80:	60a2                	ld	ra,8(sp)
    80005f82:	6402                	ld	s0,0(sp)
    80005f84:	0141                	addi	sp,sp,16
    80005f86:	8082                	ret

0000000080005f88 <plicinithart>:

void
plicinithart(void)
{
    80005f88:	1141                	addi	sp,sp,-16
    80005f8a:	e406                	sd	ra,8(sp)
    80005f8c:	e022                	sd	s0,0(sp)
    80005f8e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f90:	ed3fb0ef          	jal	80001e62 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f94:	0085171b          	slliw	a4,a0,0x8
    80005f98:	0c0027b7          	lui	a5,0xc002
    80005f9c:	97ba                	add	a5,a5,a4
    80005f9e:	40200713          	li	a4,1026
    80005fa2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005fa6:	00d5151b          	slliw	a0,a0,0xd
    80005faa:	0c2017b7          	lui	a5,0xc201
    80005fae:	97aa                	add	a5,a5,a0
    80005fb0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005fb4:	60a2                	ld	ra,8(sp)
    80005fb6:	6402                	ld	s0,0(sp)
    80005fb8:	0141                	addi	sp,sp,16
    80005fba:	8082                	ret

0000000080005fbc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005fbc:	1141                	addi	sp,sp,-16
    80005fbe:	e406                	sd	ra,8(sp)
    80005fc0:	e022                	sd	s0,0(sp)
    80005fc2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005fc4:	e9ffb0ef          	jal	80001e62 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005fc8:	00d5151b          	slliw	a0,a0,0xd
    80005fcc:	0c2017b7          	lui	a5,0xc201
    80005fd0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005fd2:	43c8                	lw	a0,4(a5)
    80005fd4:	60a2                	ld	ra,8(sp)
    80005fd6:	6402                	ld	s0,0(sp)
    80005fd8:	0141                	addi	sp,sp,16
    80005fda:	8082                	ret

0000000080005fdc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fdc:	1101                	addi	sp,sp,-32
    80005fde:	ec06                	sd	ra,24(sp)
    80005fe0:	e822                	sd	s0,16(sp)
    80005fe2:	e426                	sd	s1,8(sp)
    80005fe4:	1000                	addi	s0,sp,32
    80005fe6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fe8:	e7bfb0ef          	jal	80001e62 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    80005fec:	00d5179b          	slliw	a5,a0,0xd
    80005ff0:	0c201737          	lui	a4,0xc201
    80005ff4:	97ba                	add	a5,a5,a4
    80005ff6:	c3c4                	sw	s1,4(a5)
}
    80005ff8:	60e2                	ld	ra,24(sp)
    80005ffa:	6442                	ld	s0,16(sp)
    80005ffc:	64a2                	ld	s1,8(sp)
    80005ffe:	6105                	addi	sp,sp,32
    80006000:	8082                	ret

0000000080006002 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006002:	1141                	addi	sp,sp,-16
    80006004:	e406                	sd	ra,8(sp)
    80006006:	e022                	sd	s0,0(sp)
    80006008:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000600a:	479d                	li	a5,7
    8000600c:	04a7ca63          	blt	a5,a0,80006060 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80006010:	0024a797          	auipc	a5,0x24a
    80006014:	ca878793          	addi	a5,a5,-856 # 8024fcb8 <disk>
    80006018:	97aa                	add	a5,a5,a0
    8000601a:	0187c783          	lbu	a5,24(a5)
    8000601e:	e7b9                	bnez	a5,8000606c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006020:	00451693          	slli	a3,a0,0x4
    80006024:	0024a797          	auipc	a5,0x24a
    80006028:	c9478793          	addi	a5,a5,-876 # 8024fcb8 <disk>
    8000602c:	6398                	ld	a4,0(a5)
    8000602e:	9736                	add	a4,a4,a3
    80006030:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006034:	6398                	ld	a4,0(a5)
    80006036:	9736                	add	a4,a4,a3
    80006038:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000603c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006040:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006044:	97aa                	add	a5,a5,a0
    80006046:	4705                	li	a4,1
    80006048:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000604c:	0024a517          	auipc	a0,0x24a
    80006050:	c8450513          	addi	a0,a0,-892 # 8024fcd0 <disk+0x18>
    80006054:	d4efc0ef          	jal	800025a2 <wakeup>
}
    80006058:	60a2                	ld	ra,8(sp)
    8000605a:	6402                	ld	s0,0(sp)
    8000605c:	0141                	addi	sp,sp,16
    8000605e:	8082                	ret
    panic("free_desc 1");
    80006060:	00002517          	auipc	a0,0x2
    80006064:	5e850513          	addi	a0,a0,1512 # 80008648 <etext+0x648>
    80006068:	f86fa0ef          	jal	800007ee <panic>
    panic("free_desc 2");
    8000606c:	00002517          	auipc	a0,0x2
    80006070:	5ec50513          	addi	a0,a0,1516 # 80008658 <etext+0x658>
    80006074:	f7afa0ef          	jal	800007ee <panic>

0000000080006078 <virtio_disk_init>:
{
    80006078:	1101                	addi	sp,sp,-32
    8000607a:	ec06                	sd	ra,24(sp)
    8000607c:	e822                	sd	s0,16(sp)
    8000607e:	e426                	sd	s1,8(sp)
    80006080:	e04a                	sd	s2,0(sp)
    80006082:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006084:	00002597          	auipc	a1,0x2
    80006088:	5e458593          	addi	a1,a1,1508 # 80008668 <etext+0x668>
    8000608c:	0024a517          	auipc	a0,0x24a
    80006090:	d5450513          	addi	a0,a0,-684 # 8024fde0 <disk+0x128>
    80006094:	ba9fa0ef          	jal	80000c3c <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006098:	100017b7          	lui	a5,0x10001
    8000609c:	4398                	lw	a4,0(a5)
    8000609e:	2701                	sext.w	a4,a4
    800060a0:	747277b7          	lui	a5,0x74727
    800060a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800060a8:	14f71863          	bne	a4,a5,800061f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060ac:	100017b7          	lui	a5,0x10001
    800060b0:	43dc                	lw	a5,4(a5)
    800060b2:	2781                	sext.w	a5,a5
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060b4:	4709                	li	a4,2
    800060b6:	14e79163          	bne	a5,a4,800061f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060ba:	100017b7          	lui	a5,0x10001
    800060be:	479c                	lw	a5,8(a5)
    800060c0:	2781                	sext.w	a5,a5
    800060c2:	12e79b63          	bne	a5,a4,800061f8 <virtio_disk_init+0x180>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800060c6:	100017b7          	lui	a5,0x10001
    800060ca:	47d8                	lw	a4,12(a5)
    800060cc:	2701                	sext.w	a4,a4
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060ce:	554d47b7          	lui	a5,0x554d4
    800060d2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060d6:	12f71163          	bne	a4,a5,800061f8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060da:	100017b7          	lui	a5,0x10001
    800060de:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060e2:	4705                	li	a4,1
    800060e4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060e6:	470d                	li	a4,3
    800060e8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060ea:	10001737          	lui	a4,0x10001
    800060ee:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800060f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800060f4:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47dae767>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060f8:	8f75                	and	a4,a4,a3
    800060fa:	100016b7          	lui	a3,0x10001
    800060fe:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006100:	472d                	li	a4,11
    80006102:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006104:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006108:	439c                	lw	a5,0(a5)
    8000610a:	0007891b          	sext.w	s2,a5
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000610e:	8ba1                	andi	a5,a5,8
    80006110:	0e078a63          	beqz	a5,80006204 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006114:	100017b7          	lui	a5,0x10001
    80006118:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    8000611c:	43fc                	lw	a5,68(a5)
    8000611e:	2781                	sext.w	a5,a5
    80006120:	0e079863          	bnez	a5,80006210 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006124:	100017b7          	lui	a5,0x10001
    80006128:	5bdc                	lw	a5,52(a5)
    8000612a:	2781                	sext.w	a5,a5
  if (max == 0)
    8000612c:	0e078863          	beqz	a5,8000621c <virtio_disk_init+0x1a4>
  if (max < NUM)
    80006130:	471d                	li	a4,7
    80006132:	0ef77b63          	bgeu	a4,a5,80006228 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80006136:	9fffa0ef          	jal	80000b34 <kalloc>
    8000613a:	0024a497          	auipc	s1,0x24a
    8000613e:	b7e48493          	addi	s1,s1,-1154 # 8024fcb8 <disk>
    80006142:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006144:	9f1fa0ef          	jal	80000b34 <kalloc>
    80006148:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000614a:	9ebfa0ef          	jal	80000b34 <kalloc>
    8000614e:	87aa                	mv	a5,a0
    80006150:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80006152:	6088                	ld	a0,0(s1)
    80006154:	0e050063          	beqz	a0,80006234 <virtio_disk_init+0x1bc>
    80006158:	0024a717          	auipc	a4,0x24a
    8000615c:	b6873703          	ld	a4,-1176(a4) # 8024fcc0 <disk+0x8>
    80006160:	cb71                	beqz	a4,80006234 <virtio_disk_init+0x1bc>
    80006162:	cbe9                	beqz	a5,80006234 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006164:	6605                	lui	a2,0x1
    80006166:	4581                	li	a1,0
    80006168:	c0ffa0ef          	jal	80000d76 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000616c:	0024a497          	auipc	s1,0x24a
    80006170:	b4c48493          	addi	s1,s1,-1204 # 8024fcb8 <disk>
    80006174:	6605                	lui	a2,0x1
    80006176:	4581                	li	a1,0
    80006178:	6488                	ld	a0,8(s1)
    8000617a:	bfdfa0ef          	jal	80000d76 <memset>
  memset(disk.used, 0, PGSIZE);
    8000617e:	6605                	lui	a2,0x1
    80006180:	4581                	li	a1,0
    80006182:	6888                	ld	a0,16(s1)
    80006184:	bf3fa0ef          	jal	80000d76 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006188:	100017b7          	lui	a5,0x10001
    8000618c:	4721                	li	a4,8
    8000618e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006190:	4098                	lw	a4,0(s1)
    80006192:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006196:	40d8                	lw	a4,4(s1)
    80006198:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000619c:	649c                	ld	a5,8(s1)
    8000619e:	0007869b          	sext.w	a3,a5
    800061a2:	10001737          	lui	a4,0x10001
    800061a6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800061aa:	9781                	srai	a5,a5,0x20
    800061ac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800061b0:	689c                	ld	a5,16(s1)
    800061b2:	0007869b          	sext.w	a3,a5
    800061b6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800061ba:	9781                	srai	a5,a5,0x20
    800061bc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800061c0:	4785                	li	a5,1
    800061c2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800061c4:	00f48c23          	sb	a5,24(s1)
    800061c8:	00f48ca3          	sb	a5,25(s1)
    800061cc:	00f48d23          	sb	a5,26(s1)
    800061d0:	00f48da3          	sb	a5,27(s1)
    800061d4:	00f48e23          	sb	a5,28(s1)
    800061d8:	00f48ea3          	sb	a5,29(s1)
    800061dc:	00f48f23          	sb	a5,30(s1)
    800061e0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800061e4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800061e8:	07272823          	sw	s2,112(a4)
}
    800061ec:	60e2                	ld	ra,24(sp)
    800061ee:	6442                	ld	s0,16(sp)
    800061f0:	64a2                	ld	s1,8(sp)
    800061f2:	6902                	ld	s2,0(sp)
    800061f4:	6105                	addi	sp,sp,32
    800061f6:	8082                	ret
    panic("could not find virtio disk");
    800061f8:	00002517          	auipc	a0,0x2
    800061fc:	48050513          	addi	a0,a0,1152 # 80008678 <etext+0x678>
    80006200:	deefa0ef          	jal	800007ee <panic>
    panic("virtio disk FEATURES_OK unset");
    80006204:	00002517          	auipc	a0,0x2
    80006208:	49450513          	addi	a0,a0,1172 # 80008698 <etext+0x698>
    8000620c:	de2fa0ef          	jal	800007ee <panic>
    panic("virtio disk should not be ready");
    80006210:	00002517          	auipc	a0,0x2
    80006214:	4a850513          	addi	a0,a0,1192 # 800086b8 <etext+0x6b8>
    80006218:	dd6fa0ef          	jal	800007ee <panic>
    panic("virtio disk has no queue 0");
    8000621c:	00002517          	auipc	a0,0x2
    80006220:	4bc50513          	addi	a0,a0,1212 # 800086d8 <etext+0x6d8>
    80006224:	dcafa0ef          	jal	800007ee <panic>
    panic("virtio disk max queue too short");
    80006228:	00002517          	auipc	a0,0x2
    8000622c:	4d050513          	addi	a0,a0,1232 # 800086f8 <etext+0x6f8>
    80006230:	dbefa0ef          	jal	800007ee <panic>
    panic("virtio disk kalloc");
    80006234:	00002517          	auipc	a0,0x2
    80006238:	4e450513          	addi	a0,a0,1252 # 80008718 <etext+0x718>
    8000623c:	db2fa0ef          	jal	800007ee <panic>

0000000080006240 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006240:	711d                	addi	sp,sp,-96
    80006242:	ec86                	sd	ra,88(sp)
    80006244:	e8a2                	sd	s0,80(sp)
    80006246:	e4a6                	sd	s1,72(sp)
    80006248:	e0ca                	sd	s2,64(sp)
    8000624a:	fc4e                	sd	s3,56(sp)
    8000624c:	f852                	sd	s4,48(sp)
    8000624e:	f456                	sd	s5,40(sp)
    80006250:	f05a                	sd	s6,32(sp)
    80006252:	ec5e                	sd	s7,24(sp)
    80006254:	e862                	sd	s8,16(sp)
    80006256:	1080                	addi	s0,sp,96
    80006258:	89aa                	mv	s3,a0
    8000625a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000625c:	00c52b83          	lw	s7,12(a0)
    80006260:	001b9b9b          	slliw	s7,s7,0x1
    80006264:	1b82                	slli	s7,s7,0x20
    80006266:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000626a:	0024a517          	auipc	a0,0x24a
    8000626e:	b7650513          	addi	a0,a0,-1162 # 8024fde0 <disk+0x128>
    80006272:	a45fa0ef          	jal	80000cb6 <acquire>
  for (int i = 0; i < NUM; i++) {
    80006276:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006278:	0024aa97          	auipc	s5,0x24a
    8000627c:	a40a8a93          	addi	s5,s5,-1472 # 8024fcb8 <disk>
  for (int i = 0; i < 3; i++) {
    80006280:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006282:	5c7d                	li	s8,-1
    80006284:	a895                	j	800062f8 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006286:	00fa8733          	add	a4,s5,a5
    8000628a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000628e:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80006290:	0207c563          	bltz	a5,800062ba <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80006294:	2905                	addiw	s2,s2,1
    80006296:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006298:	07490463          	beq	s2,s4,80006300 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    8000629c:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    8000629e:	0024a717          	auipc	a4,0x24a
    800062a2:	a1a70713          	addi	a4,a4,-1510 # 8024fcb8 <disk>
    800062a6:	4781                	li	a5,0
    if (disk.free[i]) {
    800062a8:	01874683          	lbu	a3,24(a4)
    800062ac:	fee9                	bnez	a3,80006286 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    800062ae:	2785                	addiw	a5,a5,1
    800062b0:	0705                	addi	a4,a4,1
    800062b2:	fe979be3          	bne	a5,s1,800062a8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800062b6:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    800062ba:	01205d63          	blez	s2,800062d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800062be:	fa042503          	lw	a0,-96(s0)
    800062c2:	d41ff0ef          	jal	80006002 <free_desc>
      for (int j = 0; j < i; j++)
    800062c6:	4785                	li	a5,1
    800062c8:	0127d663          	bge	a5,s2,800062d4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800062cc:	fa442503          	lw	a0,-92(s0)
    800062d0:	d33ff0ef          	jal	80006002 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    800062d4:	0024a517          	auipc	a0,0x24a
    800062d8:	9fc50513          	addi	a0,a0,-1540 # 8024fcd0 <disk+0x18>
    800062dc:	a5afc0ef          	jal	80002536 <sleep_prepare>
    release(&disk.vdisk_lock);
    800062e0:	0024a917          	auipc	s2,0x24a
    800062e4:	b0090913          	addi	s2,s2,-1280 # 8024fde0 <disk+0x128>
    800062e8:	854a                	mv	a0,s2
    800062ea:	a55fa0ef          	jal	80000d3e <release>
    sleep();
    800062ee:	a84fc0ef          	jal	80002572 <sleep>
    acquire(&disk.vdisk_lock);
    800062f2:	854a                	mv	a0,s2
    800062f4:	9c3fa0ef          	jal	80000cb6 <acquire>
  for (int i = 0; i < 3; i++) {
    800062f8:	fa040613          	addi	a2,s0,-96
    800062fc:	4901                	li	s2,0
    800062fe:	bf79                	j	8000629c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006300:	fa042503          	lw	a0,-96(s0)
    80006304:	00451693          	slli	a3,a0,0x4

  if (write)
    80006308:	0024a797          	auipc	a5,0x24a
    8000630c:	9b078793          	addi	a5,a5,-1616 # 8024fcb8 <disk>
    80006310:	00a50713          	addi	a4,a0,10
    80006314:	0712                	slli	a4,a4,0x4
    80006316:	973e                	add	a4,a4,a5
    80006318:	01603633          	snez	a2,s6
    8000631c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    8000631e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006322:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80006326:	6398                	ld	a4,0(a5)
    80006328:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000632a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    8000632e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80006330:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006332:	6390                	ld	a2,0(a5)
    80006334:	00d605b3          	add	a1,a2,a3
    80006338:	4741                	li	a4,16
    8000633a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000633c:	4805                	li	a6,1
    8000633e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006342:	fa442703          	lw	a4,-92(s0)
    80006346:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000634a:	0712                	slli	a4,a4,0x4
    8000634c:	963a                	add	a2,a2,a4
    8000634e:	05898593          	addi	a1,s3,88
    80006352:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006354:	0007b883          	ld	a7,0(a5)
    80006358:	9746                	add	a4,a4,a7
    8000635a:	40000613          	li	a2,1024
    8000635e:	c710                	sw	a2,8(a4)
  if (write)
    80006360:	001b3613          	seqz	a2,s6
    80006364:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006368:	01066633          	or	a2,a2,a6
    8000636c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006370:	fa842583          	lw	a1,-88(s0)
    80006374:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006378:	00250613          	addi	a2,a0,2
    8000637c:	0612                	slli	a2,a2,0x4
    8000637e:	963e                	add	a2,a2,a5
    80006380:	577d                	li	a4,-1
    80006382:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80006386:	0592                	slli	a1,a1,0x4
    80006388:	98ae                	add	a7,a7,a1
    8000638a:	03068713          	addi	a4,a3,48
    8000638e:	973e                	add	a4,a4,a5
    80006390:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006394:	6398                	ld	a4,0(a5)
    80006396:	972e                	add	a4,a4,a1
    80006398:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000639c:	4689                	li	a3,2
    8000639e:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800063a2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063a6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800063aa:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800063ae:	6794                	ld	a3,8(a5)
    800063b0:	0026d703          	lhu	a4,2(a3)
    800063b4:	8b1d                	andi	a4,a4,7
    800063b6:	0706                	slli	a4,a4,0x1
    800063b8:	96ba                	add	a3,a3,a4
    800063ba:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    800063be:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800063c2:	6798                	ld	a4,8(a5)
    800063c4:	00275783          	lhu	a5,2(a4)
    800063c8:	2785                	addiw	a5,a5,1
    800063ca:	00f71123          	sh	a5,2(a4)
    800063ce:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800063d2:	100017b7          	lui	a5,0x10001
    800063d6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800063da:	0049a783          	lw	a5,4(s3)
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    800063de:	0024a497          	auipc	s1,0x24a
    800063e2:	a0248493          	addi	s1,s1,-1534 # 8024fde0 <disk+0x128>
  while (b->disk == 1) {
    800063e6:	8942                	mv	s2,a6
    800063e8:	03079163          	bne	a5,a6,8000640a <virtio_disk_rw+0x1ca>
    sleep_prepare(b);
    800063ec:	854e                	mv	a0,s3
    800063ee:	948fc0ef          	jal	80002536 <sleep_prepare>
    release(&disk.vdisk_lock);
    800063f2:	8526                	mv	a0,s1
    800063f4:	94bfa0ef          	jal	80000d3e <release>
    sleep();
    800063f8:	97afc0ef          	jal	80002572 <sleep>
    acquire(&disk.vdisk_lock);
    800063fc:	8526                	mv	a0,s1
    800063fe:	8b9fa0ef          	jal	80000cb6 <acquire>
  while (b->disk == 1) {
    80006402:	0049a783          	lw	a5,4(s3)
    80006406:	ff2783e3          	beq	a5,s2,800063ec <virtio_disk_rw+0x1ac>
  }

  disk.info[idx[0]].b = 0;
    8000640a:	fa042903          	lw	s2,-96(s0)
    8000640e:	00290713          	addi	a4,s2,2
    80006412:	0712                	slli	a4,a4,0x4
    80006414:	0024a797          	auipc	a5,0x24a
    80006418:	8a478793          	addi	a5,a5,-1884 # 8024fcb8 <disk>
    8000641c:	97ba                	add	a5,a5,a4
    8000641e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006422:	0024a997          	auipc	s3,0x24a
    80006426:	89698993          	addi	s3,s3,-1898 # 8024fcb8 <disk>
    8000642a:	00491713          	slli	a4,s2,0x4
    8000642e:	0009b783          	ld	a5,0(s3)
    80006432:	97ba                	add	a5,a5,a4
    80006434:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006438:	854a                	mv	a0,s2
    8000643a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000643e:	bc5ff0ef          	jal	80006002 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80006442:	8885                	andi	s1,s1,1
    80006444:	f0fd                	bnez	s1,8000642a <virtio_disk_rw+0x1ea>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006446:	0024a517          	auipc	a0,0x24a
    8000644a:	99a50513          	addi	a0,a0,-1638 # 8024fde0 <disk+0x128>
    8000644e:	8f1fa0ef          	jal	80000d3e <release>
}
    80006452:	60e6                	ld	ra,88(sp)
    80006454:	6446                	ld	s0,80(sp)
    80006456:	64a6                	ld	s1,72(sp)
    80006458:	6906                	ld	s2,64(sp)
    8000645a:	79e2                	ld	s3,56(sp)
    8000645c:	7a42                	ld	s4,48(sp)
    8000645e:	7aa2                	ld	s5,40(sp)
    80006460:	7b02                	ld	s6,32(sp)
    80006462:	6be2                	ld	s7,24(sp)
    80006464:	6c42                	ld	s8,16(sp)
    80006466:	6125                	addi	sp,sp,96
    80006468:	8082                	ret

000000008000646a <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000646a:	1101                	addi	sp,sp,-32
    8000646c:	ec06                	sd	ra,24(sp)
    8000646e:	e822                	sd	s0,16(sp)
    80006470:	e426                	sd	s1,8(sp)
    80006472:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006474:	0024a497          	auipc	s1,0x24a
    80006478:	84448493          	addi	s1,s1,-1980 # 8024fcb8 <disk>
    8000647c:	0024a517          	auipc	a0,0x24a
    80006480:	96450513          	addi	a0,a0,-1692 # 8024fde0 <disk+0x128>
    80006484:	833fa0ef          	jal	80000cb6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006488:	100017b7          	lui	a5,0x10001
    8000648c:	53bc                	lw	a5,96(a5)
    8000648e:	8b8d                	andi	a5,a5,3
    80006490:	10001737          	lui	a4,0x10001
    80006494:	d37c                	sw	a5,100(a4)
    80006496:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    8000649a:	689c                	ld	a5,16(s1)
    8000649c:	0204d703          	lhu	a4,32(s1)
    800064a0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800064a4:	04f70663          	beq	a4,a5,800064f0 <virtio_disk_intr+0x86>
    800064a8:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800064ac:	6898                	ld	a4,16(s1)
    800064ae:	0204d783          	lhu	a5,32(s1)
    800064b2:	8b9d                	andi	a5,a5,7
    800064b4:	078e                	slli	a5,a5,0x3
    800064b6:	97ba                	add	a5,a5,a4
    800064b8:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    800064ba:	00278713          	addi	a4,a5,2
    800064be:	0712                	slli	a4,a4,0x4
    800064c0:	9726                	add	a4,a4,s1
    800064c2:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800064c6:	e321                	bnez	a4,80006506 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800064c8:	0789                	addi	a5,a5,2
    800064ca:	0792                	slli	a5,a5,0x4
    800064cc:	97a6                	add	a5,a5,s1
    800064ce:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    800064d0:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800064d4:	8cefc0ef          	jal	800025a2 <wakeup>

    disk.used_idx += 1;
    800064d8:	0204d783          	lhu	a5,32(s1)
    800064dc:	2785                	addiw	a5,a5,1
    800064de:	17c2                	slli	a5,a5,0x30
    800064e0:	93c1                	srli	a5,a5,0x30
    800064e2:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800064e6:	6898                	ld	a4,16(s1)
    800064e8:	00275703          	lhu	a4,2(a4)
    800064ec:	faf71ee3          	bne	a4,a5,800064a8 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800064f0:	0024a517          	auipc	a0,0x24a
    800064f4:	8f050513          	addi	a0,a0,-1808 # 8024fde0 <disk+0x128>
    800064f8:	847fa0ef          	jal	80000d3e <release>
}
    800064fc:	60e2                	ld	ra,24(sp)
    800064fe:	6442                	ld	s0,16(sp)
    80006500:	64a2                	ld	s1,8(sp)
    80006502:	6105                	addi	sp,sp,32
    80006504:	8082                	ret
      panic("virtio_disk_intr status");
    80006506:	00002517          	auipc	a0,0x2
    8000650a:	22a50513          	addi	a0,a0,554 # 80008730 <etext+0x730>
    8000650e:	ae0fa0ef          	jal	800007ee <panic>
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
