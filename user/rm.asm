
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  int i;

  if(argc < 2){
   e:	4785                	li	a5,1
  10:	02a7d763          	bge	a5,a0,3e <main+0x3e>
  14:	00858493          	addi	s1,a1,8
  18:	ffe5091b          	addiw	s2,a0,-2
  1c:	02091793          	slli	a5,s2,0x20
  20:	01d7d913          	srli	s2,a5,0x1d
  24:	05c1                	addi	a1,a1,16
  26:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  28:	6088                	ld	a0,0(s1)
  2a:	00000097          	auipc	ra,0x0
  2e:	324080e7          	jalr	804(ra) # 34e <unlink>
  32:	02054463          	bltz	a0,5a <main+0x5a>
  for(i = 1; i < argc; i++){
  36:	04a1                	addi	s1,s1,8
  38:	ff2498e3          	bne	s1,s2,28 <main+0x28>
  3c:	a80d                	j	6e <main+0x6e>
    fprintf(2, "Usage: rm files...\n");
  3e:	00000597          	auipc	a1,0x0
  42:	7f258593          	addi	a1,a1,2034 # 830 <malloc+0xf0>
  46:	4509                	li	a0,2
  48:	00000097          	auipc	ra,0x0
  4c:	612080e7          	jalr	1554(ra) # 65a <fprintf>
    exit(1);
  50:	4505                	li	a0,1
  52:	00000097          	auipc	ra,0x0
  56:	2ac080e7          	jalr	684(ra) # 2fe <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	6090                	ld	a2,0(s1)
  5c:	00000597          	auipc	a1,0x0
  60:	7ec58593          	addi	a1,a1,2028 # 848 <malloc+0x108>
  64:	4509                	li	a0,2
  66:	00000097          	auipc	ra,0x0
  6a:	5f4080e7          	jalr	1524(ra) # 65a <fprintf>
      break;
    }
  }

  exit(0);
  6e:	4501                	li	a0,0
  70:	00000097          	auipc	ra,0x0
  74:	28e080e7          	jalr	654(ra) # 2fe <exit>

0000000000000078 <_main>:
  78:	1141                	addi	sp,sp,-16
  7a:	e406                	sd	ra,8(sp)
  7c:	e022                	sd	s0,0(sp)
  7e:	0800                	addi	s0,sp,16
  80:	00000097          	auipc	ra,0x0
  84:	f80080e7          	jalr	-128(ra) # 0 <main>
  88:	4501                	li	a0,0
  8a:	00000097          	auipc	ra,0x0
  8e:	274080e7          	jalr	628(ra) # 2fe <exit>

0000000000000092 <strcpy>:
  92:	1141                	addi	sp,sp,-16
  94:	e422                	sd	s0,8(sp)
  96:	0800                	addi	s0,sp,16
  98:	87aa                	mv	a5,a0
  9a:	0585                	addi	a1,a1,1
  9c:	0785                	addi	a5,a5,1
  9e:	fff5c703          	lbu	a4,-1(a1)
  a2:	fee78fa3          	sb	a4,-1(a5)
  a6:	fb75                	bnez	a4,9a <strcpy+0x8>
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x1e>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x1e>
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xc>
  cc:	0005c503          	lbu	a0,0(a1)
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret

00000000000000da <strlen>:
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  e0:	00054783          	lbu	a5,0(a0)
  e4:	cf91                	beqz	a5,100 <strlen+0x26>
  e6:	0505                	addi	a0,a0,1
  e8:	87aa                	mv	a5,a0
  ea:	4685                	li	a3,1
  ec:	9e89                	subw	a3,a3,a0
  ee:	00f6853b          	addw	a0,a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	fb7d                	bnez	a4,ee <strlen+0x14>
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret
 100:	4501                	li	a0,0
 102:	bfe5                	j	fa <strlen+0x20>

0000000000000104 <memset>:
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
 10a:	ca19                	beqz	a2,120 <memset+0x1c>
 10c:	87aa                	mv	a5,a0
 10e:	1602                	slli	a2,a2,0x20
 110:	9201                	srli	a2,a2,0x20
 112:	00a60733          	add	a4,a2,a0
 116:	00b78023          	sb	a1,0(a5)
 11a:	0785                	addi	a5,a5,1
 11c:	fee79de3          	bne	a5,a4,116 <memset+0x12>
 120:	6422                	ld	s0,8(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:
 126:	1141                	addi	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	addi	s0,sp,16
 12c:	00054783          	lbu	a5,0(a0)
 130:	cb99                	beqz	a5,146 <strchr+0x20>
 132:	00f58763          	beq	a1,a5,140 <strchr+0x1a>
 136:	0505                	addi	a0,a0,1
 138:	00054783          	lbu	a5,0(a0)
 13c:	fbfd                	bnez	a5,132 <strchr+0xc>
 13e:	4501                	li	a0,0
 140:	6422                	ld	s0,8(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
 146:	4501                	li	a0,0
 148:	bfe5                	j	140 <strchr+0x1a>

000000000000014a <gets>:
 14a:	711d                	addi	sp,sp,-96
 14c:	ec86                	sd	ra,88(sp)
 14e:	e8a2                	sd	s0,80(sp)
 150:	e4a6                	sd	s1,72(sp)
 152:	e0ca                	sd	s2,64(sp)
 154:	fc4e                	sd	s3,56(sp)
 156:	f852                	sd	s4,48(sp)
 158:	f456                	sd	s5,40(sp)
 15a:	f05a                	sd	s6,32(sp)
 15c:	ec5e                	sd	s7,24(sp)
 15e:	1080                	addi	s0,sp,96
 160:	8baa                	mv	s7,a0
 162:	8a2e                	mv	s4,a1
 164:	892a                	mv	s2,a0
 166:	4481                	li	s1,0
 168:	4aa9                	li	s5,10
 16a:	4b35                	li	s6,13
 16c:	89a6                	mv	s3,s1
 16e:	2485                	addiw	s1,s1,1
 170:	0344d863          	bge	s1,s4,1a0 <gets+0x56>
 174:	4605                	li	a2,1
 176:	faf40593          	addi	a1,s0,-81
 17a:	4501                	li	a0,0
 17c:	00000097          	auipc	ra,0x0
 180:	19a080e7          	jalr	410(ra) # 316 <read>
 184:	00a05e63          	blez	a0,1a0 <gets+0x56>
 188:	faf44783          	lbu	a5,-81(s0)
 18c:	00f90023          	sb	a5,0(s2)
 190:	01578763          	beq	a5,s5,19e <gets+0x54>
 194:	0905                	addi	s2,s2,1
 196:	fd679be3          	bne	a5,s6,16c <gets+0x22>
 19a:	89a6                	mv	s3,s1
 19c:	a011                	j	1a0 <gets+0x56>
 19e:	89a6                	mv	s3,s1
 1a0:	99de                	add	s3,s3,s7
 1a2:	00098023          	sb	zero,0(s3)
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e426                	sd	s1,8(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
 1cc:	4581                	li	a1,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	170080e7          	jalr	368(ra) # 33e <open>
 1d6:	02054563          	bltz	a0,200 <stat+0x42>
 1da:	84aa                	mv	s1,a0
 1dc:	85ca                	mv	a1,s2
 1de:	00000097          	auipc	ra,0x0
 1e2:	178080e7          	jalr	376(ra) # 356 <fstat>
 1e6:	892a                	mv	s2,a0
 1e8:	8526                	mv	a0,s1
 1ea:	00000097          	auipc	ra,0x0
 1ee:	13c080e7          	jalr	316(ra) # 326 <close>
 1f2:	854a                	mv	a0,s2
 1f4:	60e2                	ld	ra,24(sp)
 1f6:	6442                	ld	s0,16(sp)
 1f8:	64a2                	ld	s1,8(sp)
 1fa:	6902                	ld	s2,0(sp)
 1fc:	6105                	addi	sp,sp,32
 1fe:	8082                	ret
 200:	597d                	li	s2,-1
 202:	bfc5                	j	1f2 <stat+0x34>

0000000000000204 <atoi>:
 204:	1141                	addi	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	addi	s0,sp,16
 20a:	00054683          	lbu	a3,0(a0)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	4625                	li	a2,9
 218:	02f66863          	bltu	a2,a5,248 <atoi+0x44>
 21c:	872a                	mv	a4,a0
 21e:	4501                	li	a0,0
 220:	0705                	addi	a4,a4,1
 222:	0025179b          	slliw	a5,a0,0x2
 226:	9fa9                	addw	a5,a5,a0
 228:	0017979b          	slliw	a5,a5,0x1
 22c:	9fb5                	addw	a5,a5,a3
 22e:	fd07851b          	addiw	a0,a5,-48
 232:	00074683          	lbu	a3,0(a4)
 236:	fd06879b          	addiw	a5,a3,-48
 23a:	0ff7f793          	zext.b	a5,a5
 23e:	fef671e3          	bgeu	a2,a5,220 <atoi+0x1c>
 242:	6422                	ld	s0,8(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
 248:	4501                	li	a0,0
 24a:	bfe5                	j	242 <atoi+0x3e>

000000000000024c <memmove>:
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
 252:	02b57463          	bgeu	a0,a1,27a <memmove+0x2e>
 256:	00c05f63          	blez	a2,274 <memmove+0x28>
 25a:	1602                	slli	a2,a2,0x20
 25c:	9201                	srli	a2,a2,0x20
 25e:	00c507b3          	add	a5,a0,a2
 262:	872a                	mv	a4,a0
 264:	0585                	addi	a1,a1,1
 266:	0705                	addi	a4,a4,1
 268:	fff5c683          	lbu	a3,-1(a1)
 26c:	fed70fa3          	sb	a3,-1(a4)
 270:	fee79ae3          	bne	a5,a4,264 <memmove+0x18>
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
 27a:	00c50733          	add	a4,a0,a2
 27e:	95b2                	add	a1,a1,a2
 280:	fec05ae3          	blez	a2,274 <memmove+0x28>
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
 29e:	fee79ae3          	bne	a5,a4,292 <memmove+0x46>
 2a2:	bfc9                	j	274 <memmove+0x28>

00000000000002a4 <memcmp>:
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e422                	sd	s0,8(sp)
 2a8:	0800                	addi	s0,sp,16
 2aa:	ca05                	beqz	a2,2da <memcmp+0x36>
 2ac:	fff6069b          	addiw	a3,a2,-1
 2b0:	1682                	slli	a3,a3,0x20
 2b2:	9281                	srli	a3,a3,0x20
 2b4:	0685                	addi	a3,a3,1
 2b6:	96aa                	add	a3,a3,a0
 2b8:	00054783          	lbu	a5,0(a0)
 2bc:	0005c703          	lbu	a4,0(a1)
 2c0:	00e79863          	bne	a5,a4,2d0 <memcmp+0x2c>
 2c4:	0505                	addi	a0,a0,1
 2c6:	0585                	addi	a1,a1,1
 2c8:	fed518e3          	bne	a0,a3,2b8 <memcmp+0x14>
 2cc:	4501                	li	a0,0
 2ce:	a019                	j	2d4 <memcmp+0x30>
 2d0:	40e7853b          	subw	a0,a5,a4
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <memcmp+0x30>

00000000000002de <memcpy>:
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
 2e6:	00000097          	auipc	ra,0x0
 2ea:	f66080e7          	jalr	-154(ra) # 24c <memmove>
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <fork>:
 2f6:	4885                	li	a7,1
 2f8:	00000073          	ecall
 2fc:	8082                	ret

00000000000002fe <exit>:
 2fe:	4889                	li	a7,2
 300:	00000073          	ecall
 304:	8082                	ret

0000000000000306 <wait>:
 306:	488d                	li	a7,3
 308:	00000073          	ecall
 30c:	8082                	ret

000000000000030e <pipe>:
 30e:	4891                	li	a7,4
 310:	00000073          	ecall
 314:	8082                	ret

0000000000000316 <read>:
 316:	4895                	li	a7,5
 318:	00000073          	ecall
 31c:	8082                	ret

000000000000031e <write>:
 31e:	48c1                	li	a7,16
 320:	00000073          	ecall
 324:	8082                	ret

0000000000000326 <close>:
 326:	48d5                	li	a7,21
 328:	00000073          	ecall
 32c:	8082                	ret

000000000000032e <kill>:
 32e:	4899                	li	a7,6
 330:	00000073          	ecall
 334:	8082                	ret

0000000000000336 <exec>:
 336:	489d                	li	a7,7
 338:	00000073          	ecall
 33c:	8082                	ret

000000000000033e <open>:
 33e:	48bd                	li	a7,15
 340:	00000073          	ecall
 344:	8082                	ret

0000000000000346 <mknod>:
 346:	48c5                	li	a7,17
 348:	00000073          	ecall
 34c:	8082                	ret

000000000000034e <unlink>:
 34e:	48c9                	li	a7,18
 350:	00000073          	ecall
 354:	8082                	ret

0000000000000356 <fstat>:
 356:	48a1                	li	a7,8
 358:	00000073          	ecall
 35c:	8082                	ret

000000000000035e <link>:
 35e:	48cd                	li	a7,19
 360:	00000073          	ecall
 364:	8082                	ret

0000000000000366 <mkdir>:
 366:	48d1                	li	a7,20
 368:	00000073          	ecall
 36c:	8082                	ret

000000000000036e <chdir>:
 36e:	48a5                	li	a7,9
 370:	00000073          	ecall
 374:	8082                	ret

0000000000000376 <dup>:
 376:	48a9                	li	a7,10
 378:	00000073          	ecall
 37c:	8082                	ret

000000000000037e <getpid>:
 37e:	48ad                	li	a7,11
 380:	00000073          	ecall
 384:	8082                	ret

0000000000000386 <sbrk>:
 386:	48b1                	li	a7,12
 388:	00000073          	ecall
 38c:	8082                	ret

000000000000038e <sleep>:
 38e:	48b5                	li	a7,13
 390:	00000073          	ecall
 394:	8082                	ret

0000000000000396 <uptime>:
 396:	48b9                	li	a7,14
 398:	00000073          	ecall
 39c:	8082                	ret

000000000000039e <trace>:
 39e:	48d9                	li	a7,22
 3a0:	00000073          	ecall
 3a4:	8082                	ret

00000000000003a6 <sysinfo>:
 3a6:	48dd                	li	a7,23
 3a8:	00000073          	ecall
 3ac:	8082                	ret

00000000000003ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ae:	1101                	addi	sp,sp,-32
 3b0:	ec06                	sd	ra,24(sp)
 3b2:	e822                	sd	s0,16(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	fef40593          	addi	a1,s0,-17
 3c0:	00000097          	auipc	ra,0x0
 3c4:	f5e080e7          	jalr	-162(ra) # 31e <write>
}
 3c8:	60e2                	ld	ra,24(sp)
 3ca:	6442                	ld	s0,16(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret

00000000000003d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	7139                	addi	sp,sp,-64
 3d2:	fc06                	sd	ra,56(sp)
 3d4:	f822                	sd	s0,48(sp)
 3d6:	f426                	sd	s1,40(sp)
 3d8:	f04a                	sd	s2,32(sp)
 3da:	ec4e                	sd	s3,24(sp)
 3dc:	0080                	addi	s0,sp,64
 3de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e0:	c299                	beqz	a3,3e6 <printint+0x16>
 3e2:	0805c963          	bltz	a1,474 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e6:	2581                	sext.w	a1,a1
  neg = 0;
 3e8:	4881                	li	a7,0
 3ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f0:	2601                	sext.w	a2,a2
 3f2:	00000517          	auipc	a0,0x0
 3f6:	4d650513          	addi	a0,a0,1238 # 8c8 <digits>
 3fa:	883a                	mv	a6,a4
 3fc:	2705                	addiw	a4,a4,1
 3fe:	02c5f7bb          	remuw	a5,a1,a2
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	97aa                	add	a5,a5,a0
 408:	0007c783          	lbu	a5,0(a5)
 40c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 410:	0005879b          	sext.w	a5,a1
 414:	02c5d5bb          	divuw	a1,a1,a2
 418:	0685                	addi	a3,a3,1
 41a:	fec7f0e3          	bgeu	a5,a2,3fa <printint+0x2a>
  if(neg)
 41e:	00088c63          	beqz	a7,436 <printint+0x66>
    buf[i++] = '-';
 422:	fd070793          	addi	a5,a4,-48
 426:	00878733          	add	a4,a5,s0
 42a:	02d00793          	li	a5,45
 42e:	fef70823          	sb	a5,-16(a4)
 432:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 436:	02e05863          	blez	a4,466 <printint+0x96>
 43a:	fc040793          	addi	a5,s0,-64
 43e:	00e78933          	add	s2,a5,a4
 442:	fff78993          	addi	s3,a5,-1
 446:	99ba                	add	s3,s3,a4
 448:	377d                	addiw	a4,a4,-1
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	fff94583          	lbu	a1,-1(s2)
 456:	8526                	mv	a0,s1
 458:	00000097          	auipc	ra,0x0
 45c:	f56080e7          	jalr	-170(ra) # 3ae <putc>
  while(--i >= 0)
 460:	197d                	addi	s2,s2,-1
 462:	ff3918e3          	bne	s2,s3,452 <printint+0x82>
}
 466:	70e2                	ld	ra,56(sp)
 468:	7442                	ld	s0,48(sp)
 46a:	74a2                	ld	s1,40(sp)
 46c:	7902                	ld	s2,32(sp)
 46e:	69e2                	ld	s3,24(sp)
 470:	6121                	addi	sp,sp,64
 472:	8082                	ret
    x = -xx;
 474:	40b005bb          	negw	a1,a1
    neg = 1;
 478:	4885                	li	a7,1
    x = -xx;
 47a:	bf85                	j	3ea <printint+0x1a>

000000000000047c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47c:	7119                	addi	sp,sp,-128
 47e:	fc86                	sd	ra,120(sp)
 480:	f8a2                	sd	s0,112(sp)
 482:	f4a6                	sd	s1,104(sp)
 484:	f0ca                	sd	s2,96(sp)
 486:	ecce                	sd	s3,88(sp)
 488:	e8d2                	sd	s4,80(sp)
 48a:	e4d6                	sd	s5,72(sp)
 48c:	e0da                	sd	s6,64(sp)
 48e:	fc5e                	sd	s7,56(sp)
 490:	f862                	sd	s8,48(sp)
 492:	f466                	sd	s9,40(sp)
 494:	f06a                	sd	s10,32(sp)
 496:	ec6e                	sd	s11,24(sp)
 498:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49a:	0005c903          	lbu	s2,0(a1)
 49e:	18090f63          	beqz	s2,63c <vprintf+0x1c0>
 4a2:	8aaa                	mv	s5,a0
 4a4:	8b32                	mv	s6,a2
 4a6:	00158493          	addi	s1,a1,1
  state = 0;
 4aa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4ac:	02500a13          	li	s4,37
 4b0:	4c55                	li	s8,21
 4b2:	00000c97          	auipc	s9,0x0
 4b6:	3bec8c93          	addi	s9,s9,958 # 870 <malloc+0x130>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4ba:	02800d93          	li	s11,40
  putc(fd, 'x');
 4be:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 4c0:	00000b97          	auipc	s7,0x0
 4c4:	408b8b93          	addi	s7,s7,1032 # 8c8 <digits>
 4c8:	a839                	j	4e6 <vprintf+0x6a>
        putc(fd, c);
 4ca:	85ca                	mv	a1,s2
 4cc:	8556                	mv	a0,s5
 4ce:	00000097          	auipc	ra,0x0
 4d2:	ee0080e7          	jalr	-288(ra) # 3ae <putc>
 4d6:	a019                	j	4dc <vprintf+0x60>
    } else if(state == '%'){
 4d8:	01498d63          	beq	s3,s4,4f2 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 4dc:	0485                	addi	s1,s1,1
 4de:	fff4c903          	lbu	s2,-1(s1)
 4e2:	14090d63          	beqz	s2,63c <vprintf+0x1c0>
    if(state == 0){
 4e6:	fe0999e3          	bnez	s3,4d8 <vprintf+0x5c>
      if(c == '%'){
 4ea:	ff4910e3          	bne	s2,s4,4ca <vprintf+0x4e>
        state = '%';
 4ee:	89d2                	mv	s3,s4
 4f0:	b7f5                	j	4dc <vprintf+0x60>
      if(c == 'd'){
 4f2:	11490c63          	beq	s2,s4,60a <vprintf+0x18e>
 4f6:	f9d9079b          	addiw	a5,s2,-99
 4fa:	0ff7f793          	zext.b	a5,a5
 4fe:	10fc6e63          	bltu	s8,a5,61a <vprintf+0x19e>
 502:	f9d9079b          	addiw	a5,s2,-99
 506:	0ff7f713          	zext.b	a4,a5
 50a:	10ec6863          	bltu	s8,a4,61a <vprintf+0x19e>
 50e:	00271793          	slli	a5,a4,0x2
 512:	97e6                	add	a5,a5,s9
 514:	439c                	lw	a5,0(a5)
 516:	97e6                	add	a5,a5,s9
 518:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51a:	008b0913          	addi	s2,s6,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000b2583          	lw	a1,0(s6)
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	ea8080e7          	jalr	-344(ra) # 3d0 <printint>
 530:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 532:	4981                	li	s3,0
 534:	b765                	j	4dc <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 536:	008b0913          	addi	s2,s6,8
 53a:	4681                	li	a3,0
 53c:	4629                	li	a2,10
 53e:	000b2583          	lw	a1,0(s6)
 542:	8556                	mv	a0,s5
 544:	00000097          	auipc	ra,0x0
 548:	e8c080e7          	jalr	-372(ra) # 3d0 <printint>
 54c:	8b4a                	mv	s6,s2
      state = 0;
 54e:	4981                	li	s3,0
 550:	b771                	j	4dc <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 552:	008b0913          	addi	s2,s6,8
 556:	4681                	li	a3,0
 558:	866a                	mv	a2,s10
 55a:	000b2583          	lw	a1,0(s6)
 55e:	8556                	mv	a0,s5
 560:	00000097          	auipc	ra,0x0
 564:	e70080e7          	jalr	-400(ra) # 3d0 <printint>
 568:	8b4a                	mv	s6,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bf85                	j	4dc <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 56e:	008b0793          	addi	a5,s6,8
 572:	f8f43423          	sd	a5,-120(s0)
 576:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 57a:	03000593          	li	a1,48
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e2e080e7          	jalr	-466(ra) # 3ae <putc>
  putc(fd, 'x');
 588:	07800593          	li	a1,120
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e20080e7          	jalr	-480(ra) # 3ae <putc>
 596:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	03c9d793          	srli	a5,s3,0x3c
 59c:	97de                	add	a5,a5,s7
 59e:	0007c583          	lbu	a1,0(a5)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e0a080e7          	jalr	-502(ra) # 3ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ac:	0992                	slli	s3,s3,0x4
 5ae:	397d                	addiw	s2,s2,-1
 5b0:	fe0914e3          	bnez	s2,598 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 5b4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b70d                	j	4dc <vprintf+0x60>
        s = va_arg(ap, char*);
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 5c4:	02098163          	beqz	s3,5e6 <vprintf+0x16a>
        while(*s != 0){
 5c8:	0009c583          	lbu	a1,0(s3)
 5cc:	c5ad                	beqz	a1,636 <vprintf+0x1ba>
          putc(fd, *s);
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	dde080e7          	jalr	-546(ra) # 3ae <putc>
          s++;
 5d8:	0985                	addi	s3,s3,1
        while(*s != 0){
 5da:	0009c583          	lbu	a1,0(s3)
 5de:	f9e5                	bnez	a1,5ce <vprintf+0x152>
        s = va_arg(ap, char*);
 5e0:	8b4a                	mv	s6,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bde5                	j	4dc <vprintf+0x60>
          s = "(null)";
 5e6:	00000997          	auipc	s3,0x0
 5ea:	28298993          	addi	s3,s3,642 # 868 <malloc+0x128>
        while(*s != 0){
 5ee:	85ee                	mv	a1,s11
 5f0:	bff9                	j	5ce <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 5f2:	008b0913          	addi	s2,s6,8
 5f6:	000b4583          	lbu	a1,0(s6)
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	db2080e7          	jalr	-590(ra) # 3ae <putc>
 604:	8b4a                	mv	s6,s2
      state = 0;
 606:	4981                	li	s3,0
 608:	bdd1                	j	4dc <vprintf+0x60>
        putc(fd, c);
 60a:	85d2                	mv	a1,s4
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	da0080e7          	jalr	-608(ra) # 3ae <putc>
      state = 0;
 616:	4981                	li	s3,0
 618:	b5d1                	j	4dc <vprintf+0x60>
        putc(fd, '%');
 61a:	85d2                	mv	a1,s4
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	d90080e7          	jalr	-624(ra) # 3ae <putc>
        putc(fd, c);
 626:	85ca                	mv	a1,s2
 628:	8556                	mv	a0,s5
 62a:	00000097          	auipc	ra,0x0
 62e:	d84080e7          	jalr	-636(ra) # 3ae <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	b565                	j	4dc <vprintf+0x60>
        s = va_arg(ap, char*);
 636:	8b4a                	mv	s6,s2
      state = 0;
 638:	4981                	li	s3,0
 63a:	b54d                	j	4dc <vprintf+0x60>
    }
  }
}
 63c:	70e6                	ld	ra,120(sp)
 63e:	7446                	ld	s0,112(sp)
 640:	74a6                	ld	s1,104(sp)
 642:	7906                	ld	s2,96(sp)
 644:	69e6                	ld	s3,88(sp)
 646:	6a46                	ld	s4,80(sp)
 648:	6aa6                	ld	s5,72(sp)
 64a:	6b06                	ld	s6,64(sp)
 64c:	7be2                	ld	s7,56(sp)
 64e:	7c42                	ld	s8,48(sp)
 650:	7ca2                	ld	s9,40(sp)
 652:	7d02                	ld	s10,32(sp)
 654:	6de2                	ld	s11,24(sp)
 656:	6109                	addi	sp,sp,128
 658:	8082                	ret

000000000000065a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65a:	715d                	addi	sp,sp,-80
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	addi	s0,sp,32
 662:	e010                	sd	a2,0(s0)
 664:	e414                	sd	a3,8(s0)
 666:	e818                	sd	a4,16(s0)
 668:	ec1c                	sd	a5,24(s0)
 66a:	03043023          	sd	a6,32(s0)
 66e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 676:	8622                	mv	a2,s0
 678:	00000097          	auipc	ra,0x0
 67c:	e04080e7          	jalr	-508(ra) # 47c <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6161                	addi	sp,sp,80
 686:	8082                	ret

0000000000000688 <printf>:

void
printf(const char *fmt, ...)
{
 688:	711d                	addi	sp,sp,-96
 68a:	ec06                	sd	ra,24(sp)
 68c:	e822                	sd	s0,16(sp)
 68e:	1000                	addi	s0,sp,32
 690:	e40c                	sd	a1,8(s0)
 692:	e810                	sd	a2,16(s0)
 694:	ec14                	sd	a3,24(s0)
 696:	f018                	sd	a4,32(s0)
 698:	f41c                	sd	a5,40(s0)
 69a:	03043823          	sd	a6,48(s0)
 69e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	00840613          	addi	a2,s0,8
 6a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6aa:	85aa                	mv	a1,a0
 6ac:	4505                	li	a0,1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dce080e7          	jalr	-562(ra) # 47c <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret

00000000000006be <free>:
 6be:	1141                	addi	sp,sp,-16
 6c0:	e422                	sd	s0,8(sp)
 6c2:	0800                	addi	s0,sp,16
 6c4:	ff050693          	addi	a3,a0,-16
 6c8:	00001797          	auipc	a5,0x1
 6cc:	9387b783          	ld	a5,-1736(a5) # 1000 <freep>
 6d0:	a02d                	j	6fa <free+0x3c>
 6d2:	4618                	lw	a4,8(a2)
 6d4:	9f2d                	addw	a4,a4,a1
 6d6:	fee52c23          	sw	a4,-8(a0)
 6da:	6398                	ld	a4,0(a5)
 6dc:	6310                	ld	a2,0(a4)
 6de:	a83d                	j	71c <free+0x5e>
 6e0:	ff852703          	lw	a4,-8(a0)
 6e4:	9f31                	addw	a4,a4,a2
 6e6:	c798                	sw	a4,8(a5)
 6e8:	ff053683          	ld	a3,-16(a0)
 6ec:	a091                	j	730 <free+0x72>
 6ee:	6398                	ld	a4,0(a5)
 6f0:	00e7e463          	bltu	a5,a4,6f8 <free+0x3a>
 6f4:	00e6ea63          	bltu	a3,a4,708 <free+0x4a>
 6f8:	87ba                	mv	a5,a4
 6fa:	fed7fae3          	bgeu	a5,a3,6ee <free+0x30>
 6fe:	6398                	ld	a4,0(a5)
 700:	00e6e463          	bltu	a3,a4,708 <free+0x4a>
 704:	fee7eae3          	bltu	a5,a4,6f8 <free+0x3a>
 708:	ff852583          	lw	a1,-8(a0)
 70c:	6390                	ld	a2,0(a5)
 70e:	02059813          	slli	a6,a1,0x20
 712:	01c85713          	srli	a4,a6,0x1c
 716:	9736                	add	a4,a4,a3
 718:	fae60de3          	beq	a2,a4,6d2 <free+0x14>
 71c:	fec53823          	sd	a2,-16(a0)
 720:	4790                	lw	a2,8(a5)
 722:	02061593          	slli	a1,a2,0x20
 726:	01c5d713          	srli	a4,a1,0x1c
 72a:	973e                	add	a4,a4,a5
 72c:	fae68ae3          	beq	a3,a4,6e0 <free+0x22>
 730:	e394                	sd	a3,0(a5)
 732:	00001717          	auipc	a4,0x1
 736:	8cf73723          	sd	a5,-1842(a4) # 1000 <freep>
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	addi	sp,sp,16
 73e:	8082                	ret

0000000000000740 <malloc>:
 740:	7139                	addi	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f426                	sd	s1,40(sp)
 748:	f04a                	sd	s2,32(sp)
 74a:	ec4e                	sd	s3,24(sp)
 74c:	e852                	sd	s4,16(sp)
 74e:	e456                	sd	s5,8(sp)
 750:	e05a                	sd	s6,0(sp)
 752:	0080                	addi	s0,sp,64
 754:	02051493          	slli	s1,a0,0x20
 758:	9081                	srli	s1,s1,0x20
 75a:	04bd                	addi	s1,s1,15
 75c:	8091                	srli	s1,s1,0x4
 75e:	0014899b          	addiw	s3,s1,1
 762:	0485                	addi	s1,s1,1
 764:	00001517          	auipc	a0,0x1
 768:	89c53503          	ld	a0,-1892(a0) # 1000 <freep>
 76c:	c515                	beqz	a0,798 <malloc+0x58>
 76e:	611c                	ld	a5,0(a0)
 770:	4798                	lw	a4,8(a5)
 772:	02977f63          	bgeu	a4,s1,7b0 <malloc+0x70>
 776:	8a4e                	mv	s4,s3
 778:	0009871b          	sext.w	a4,s3
 77c:	6685                	lui	a3,0x1
 77e:	00d77363          	bgeu	a4,a3,784 <malloc+0x44>
 782:	6a05                	lui	s4,0x1
 784:	000a0b1b          	sext.w	s6,s4
 788:	004a1a1b          	slliw	s4,s4,0x4
 78c:	00001917          	auipc	s2,0x1
 790:	87490913          	addi	s2,s2,-1932 # 1000 <freep>
 794:	5afd                	li	s5,-1
 796:	a895                	j	80a <malloc+0xca>
 798:	00001797          	auipc	a5,0x1
 79c:	87878793          	addi	a5,a5,-1928 # 1010 <base>
 7a0:	00001717          	auipc	a4,0x1
 7a4:	86f73023          	sd	a5,-1952(a4) # 1000 <freep>
 7a8:	e39c                	sd	a5,0(a5)
 7aa:	0007a423          	sw	zero,8(a5)
 7ae:	b7e1                	j	776 <malloc+0x36>
 7b0:	02e48c63          	beq	s1,a4,7e8 <malloc+0xa8>
 7b4:	4137073b          	subw	a4,a4,s3
 7b8:	c798                	sw	a4,8(a5)
 7ba:	02071693          	slli	a3,a4,0x20
 7be:	01c6d713          	srli	a4,a3,0x1c
 7c2:	97ba                	add	a5,a5,a4
 7c4:	0137a423          	sw	s3,8(a5)
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82a73c23          	sd	a0,-1992(a4) # 1000 <freep>
 7d0:	01078513          	addi	a0,a5,16
 7d4:	70e2                	ld	ra,56(sp)
 7d6:	7442                	ld	s0,48(sp)
 7d8:	74a2                	ld	s1,40(sp)
 7da:	7902                	ld	s2,32(sp)
 7dc:	69e2                	ld	s3,24(sp)
 7de:	6a42                	ld	s4,16(sp)
 7e0:	6aa2                	ld	s5,8(sp)
 7e2:	6b02                	ld	s6,0(sp)
 7e4:	6121                	addi	sp,sp,64
 7e6:	8082                	ret
 7e8:	6398                	ld	a4,0(a5)
 7ea:	e118                	sd	a4,0(a0)
 7ec:	bff1                	j	7c8 <malloc+0x88>
 7ee:	01652423          	sw	s6,8(a0)
 7f2:	0541                	addi	a0,a0,16
 7f4:	00000097          	auipc	ra,0x0
 7f8:	eca080e7          	jalr	-310(ra) # 6be <free>
 7fc:	00093503          	ld	a0,0(s2)
 800:	d971                	beqz	a0,7d4 <malloc+0x94>
 802:	611c                	ld	a5,0(a0)
 804:	4798                	lw	a4,8(a5)
 806:	fa9775e3          	bgeu	a4,s1,7b0 <malloc+0x70>
 80a:	00093703          	ld	a4,0(s2)
 80e:	853e                	mv	a0,a5
 810:	fef719e3          	bne	a4,a5,802 <malloc+0xc2>
 814:	8552                	mv	a0,s4
 816:	00000097          	auipc	ra,0x0
 81a:	b70080e7          	jalr	-1168(ra) # 386 <sbrk>
 81e:	fd5518e3          	bne	a0,s5,7ee <malloc+0xae>
 822:	4501                	li	a0,0
 824:	bf45                	j	7d4 <malloc+0x94>
