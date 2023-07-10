
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <new_proc>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void new_proc(int p[2]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int prime;
    int n;
    // close the write side of p
    close(p[1]);
   c:	4148                	lw	a0,4(a0)
   e:	00000097          	auipc	ra,0x0
  12:	480080e7          	jalr	1152(ra) # 48e <close>
    if (read(p[0], &prime, 4) != 4) {
  16:	4611                	li	a2,4
  18:	fdc40593          	addi	a1,s0,-36
  1c:	4088                	lw	a0,0(s1)
  1e:	00000097          	auipc	ra,0x0
  22:	460080e7          	jalr	1120(ra) # 47e <read>
  26:	4791                	li	a5,4
  28:	02f51c63          	bne	a0,a5,60 <new_proc+0x60>
        fprintf(2, "Error in read.\n");
        exit(1);
    }
    printf("prime %d\n", prime);
  2c:	fdc42583          	lw	a1,-36(s0)
  30:	00001517          	auipc	a0,0x1
  34:	96050513          	addi	a0,a0,-1696 # 990 <malloc+0xf8>
  38:	00000097          	auipc	ra,0x0
  3c:	7a8080e7          	jalr	1960(ra) # 7e0 <printf>
    // if read return not zero
    // if it still need next process
    if (read(p[0], &n, 4) == 4){
  40:	4611                	li	a2,4
  42:	fd840593          	addi	a1,s0,-40
  46:	4088                	lw	a0,0(s1)
  48:	00000097          	auipc	ra,0x0
  4c:	436080e7          	jalr	1078(ra) # 47e <read>
  50:	4791                	li	a5,4
  52:	02f50563          	beq	a0,a5,7c <new_proc+0x7c>
        // child
        else {
            new_proc(newfd);
        }
    }
}
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6145                	addi	sp,sp,48
  5e:	8082                	ret
        fprintf(2, "Error in read.\n");
  60:	00001597          	auipc	a1,0x1
  64:	92058593          	addi	a1,a1,-1760 # 980 <malloc+0xe8>
  68:	4509                	li	a0,2
  6a:	00000097          	auipc	ra,0x0
  6e:	748080e7          	jalr	1864(ra) # 7b2 <fprintf>
        exit(1);
  72:	4505                	li	a0,1
  74:	00000097          	auipc	ra,0x0
  78:	3f2080e7          	jalr	1010(ra) # 466 <exit>
        pipe(newfd);
  7c:	fd040513          	addi	a0,s0,-48
  80:	00000097          	auipc	ra,0x0
  84:	3f6080e7          	jalr	1014(ra) # 476 <pipe>
        if (fork() != 0) {
  88:	00000097          	auipc	ra,0x0
  8c:	3d6080e7          	jalr	982(ra) # 45e <fork>
  90:	c549                	beqz	a0,11a <new_proc+0x11a>
            close(newfd[0]);
  92:	fd042503          	lw	a0,-48(s0)
  96:	00000097          	auipc	ra,0x0
  9a:	3f8080e7          	jalr	1016(ra) # 48e <close>
            if (n % prime) write(newfd[1], &n, 4);
  9e:	fd842783          	lw	a5,-40(s0)
  a2:	fdc42703          	lw	a4,-36(s0)
  a6:	02e7e7bb          	remw	a5,a5,a4
  aa:	ef8d                	bnez	a5,e4 <new_proc+0xe4>
            while (read(p[0], &n, 4) == 4) {
  ac:	4611                	li	a2,4
  ae:	fd840593          	addi	a1,s0,-40
  b2:	4088                	lw	a0,0(s1)
  b4:	00000097          	auipc	ra,0x0
  b8:	3ca080e7          	jalr	970(ra) # 47e <read>
  bc:	4791                	li	a5,4
  be:	02f51d63          	bne	a0,a5,f8 <new_proc+0xf8>
                if (n % prime) write(newfd[1], &n, 4);
  c2:	fd842783          	lw	a5,-40(s0)
  c6:	fdc42703          	lw	a4,-36(s0)
  ca:	02e7e7bb          	remw	a5,a5,a4
  ce:	dff9                	beqz	a5,ac <new_proc+0xac>
  d0:	4611                	li	a2,4
  d2:	fd840593          	addi	a1,s0,-40
  d6:	fd442503          	lw	a0,-44(s0)
  da:	00000097          	auipc	ra,0x0
  de:	3ac080e7          	jalr	940(ra) # 486 <write>
  e2:	b7e9                	j	ac <new_proc+0xac>
            if (n % prime) write(newfd[1], &n, 4);
  e4:	4611                	li	a2,4
  e6:	fd840593          	addi	a1,s0,-40
  ea:	fd442503          	lw	a0,-44(s0)
  ee:	00000097          	auipc	ra,0x0
  f2:	398080e7          	jalr	920(ra) # 486 <write>
  f6:	bf5d                	j	ac <new_proc+0xac>
            close(p[0]);
  f8:	4088                	lw	a0,0(s1)
  fa:	00000097          	auipc	ra,0x0
  fe:	394080e7          	jalr	916(ra) # 48e <close>
            close(newfd[1]);
 102:	fd442503          	lw	a0,-44(s0)
 106:	00000097          	auipc	ra,0x0
 10a:	388080e7          	jalr	904(ra) # 48e <close>
            wait(0);
 10e:	4501                	li	a0,0
 110:	00000097          	auipc	ra,0x0
 114:	35e080e7          	jalr	862(ra) # 46e <wait>
 118:	bf3d                	j	56 <new_proc+0x56>
            new_proc(newfd);
 11a:	fd040513          	addi	a0,s0,-48
 11e:	00000097          	auipc	ra,0x0
 122:	ee2080e7          	jalr	-286(ra) # 0 <new_proc>
}
 126:	bf05                	j	56 <new_proc+0x56>

0000000000000128 <main>:

int
main(int argc, char* argv[])
{
 128:	7179                	addi	sp,sp,-48
 12a:	f406                	sd	ra,40(sp)
 12c:	f022                	sd	s0,32(sp)
 12e:	ec26                	sd	s1,24(sp)
 130:	1800                	addi	s0,sp,48
    int p[2];
    pipe(p);
 132:	fd840513          	addi	a0,s0,-40
 136:	00000097          	auipc	ra,0x0
 13a:	340080e7          	jalr	832(ra) # 476 <pipe>
    // child process
    if (fork() == 0) {
 13e:	00000097          	auipc	ra,0x0
 142:	320080e7          	jalr	800(ra) # 45e <fork>
 146:	c149                	beqz	a0,1c8 <main+0xa0>
        new_proc(p);
    }
    // father process
    else {
        // close read port of pipe
        close(p[0]);
 148:	fd842503          	lw	a0,-40(s0)
 14c:	00000097          	auipc	ra,0x0
 150:	342080e7          	jalr	834(ra) # 48e <close>
        for (int i = 2; i <= 35; ++i) {
 154:	4789                	li	a5,2
 156:	fcf42a23          	sw	a5,-44(s0)
 15a:	02300493          	li	s1,35
            if (write(p[1], &i, 4) != 4) {
 15e:	4611                	li	a2,4
 160:	fd440593          	addi	a1,s0,-44
 164:	fdc42503          	lw	a0,-36(s0)
 168:	00000097          	auipc	ra,0x0
 16c:	31e080e7          	jalr	798(ra) # 486 <write>
 170:	4791                	li	a5,4
 172:	02f51b63          	bne	a0,a5,1a8 <main+0x80>
        for (int i = 2; i <= 35; ++i) {
 176:	fd442783          	lw	a5,-44(s0)
 17a:	2785                	addiw	a5,a5,1
 17c:	0007871b          	sext.w	a4,a5
 180:	fcf42a23          	sw	a5,-44(s0)
 184:	fce4dde3          	bge	s1,a4,15e <main+0x36>
                fprintf(2, "failed write %d into the pipe\n", i);
                exit(1);
            }
        }
        close(p[1]);
 188:	fdc42503          	lw	a0,-36(s0)
 18c:	00000097          	auipc	ra,0x0
 190:	302080e7          	jalr	770(ra) # 48e <close>
        wait(0);
 194:	4501                	li	a0,0
 196:	00000097          	auipc	ra,0x0
 19a:	2d8080e7          	jalr	728(ra) # 46e <wait>
        exit(0);
 19e:	4501                	li	a0,0
 1a0:	00000097          	auipc	ra,0x0
 1a4:	2c6080e7          	jalr	710(ra) # 466 <exit>
                fprintf(2, "failed write %d into the pipe\n", i);
 1a8:	fd442603          	lw	a2,-44(s0)
 1ac:	00000597          	auipc	a1,0x0
 1b0:	7f458593          	addi	a1,a1,2036 # 9a0 <malloc+0x108>
 1b4:	4509                	li	a0,2
 1b6:	00000097          	auipc	ra,0x0
 1ba:	5fc080e7          	jalr	1532(ra) # 7b2 <fprintf>
                exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	2a6080e7          	jalr	678(ra) # 466 <exit>
        new_proc(p);
 1c8:	fd840513          	addi	a0,s0,-40
 1cc:	00000097          	auipc	ra,0x0
 1d0:	e34080e7          	jalr	-460(ra) # 0 <new_proc>
    }
    return 0;
 1d4:	4501                	li	a0,0
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6145                	addi	sp,sp,48
 1de:	8082                	ret

00000000000001e0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e406                	sd	ra,8(sp)
 1e4:	e022                	sd	s0,0(sp)
 1e6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1e8:	00000097          	auipc	ra,0x0
 1ec:	f40080e7          	jalr	-192(ra) # 128 <main>
  exit(0);
 1f0:	4501                	li	a0,0
 1f2:	00000097          	auipc	ra,0x0
 1f6:	274080e7          	jalr	628(ra) # 466 <exit>

00000000000001fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 200:	87aa                	mv	a5,a0
 202:	0585                	addi	a1,a1,1
 204:	0785                	addi	a5,a5,1
 206:	fff5c703          	lbu	a4,-1(a1)
 20a:	fee78fa3          	sb	a4,-1(a5)
 20e:	fb75                	bnez	a4,202 <strcpy+0x8>
    ;
  return os;
}
 210:	6422                	ld	s0,8(sp)
 212:	0141                	addi	sp,sp,16
 214:	8082                	ret

0000000000000216 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	cb91                	beqz	a5,234 <strcmp+0x1e>
 222:	0005c703          	lbu	a4,0(a1)
 226:	00f71763          	bne	a4,a5,234 <strcmp+0x1e>
    p++, q++;
 22a:	0505                	addi	a0,a0,1
 22c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 22e:	00054783          	lbu	a5,0(a0)
 232:	fbe5                	bnez	a5,222 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 234:	0005c503          	lbu	a0,0(a1)
}
 238:	40a7853b          	subw	a0,a5,a0
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strlen>:

uint
strlen(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cf91                	beqz	a5,268 <strlen+0x26>
 24e:	0505                	addi	a0,a0,1
 250:	87aa                	mv	a5,a0
 252:	4685                	li	a3,1
 254:	9e89                	subw	a3,a3,a0
 256:	00f6853b          	addw	a0,a3,a5
 25a:	0785                	addi	a5,a5,1
 25c:	fff7c703          	lbu	a4,-1(a5)
 260:	fb7d                	bnez	a4,256 <strlen+0x14>
    ;
  return n;
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  for(n = 0; s[n]; n++)
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <strlen+0x20>

000000000000026c <memset>:

void*
memset(void *dst, int c, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 272:	ca19                	beqz	a2,288 <memset+0x1c>
 274:	87aa                	mv	a5,a0
 276:	1602                	slli	a2,a2,0x20
 278:	9201                	srli	a2,a2,0x20
 27a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 27e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 282:	0785                	addi	a5,a5,1
 284:	fee79de3          	bne	a5,a4,27e <memset+0x12>
  }
  return dst;
}
 288:	6422                	ld	s0,8(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <strchr>:

char*
strchr(const char *s, char c)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  for(; *s; s++)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb99                	beqz	a5,2ae <strchr+0x20>
    if(*s == c)
 29a:	00f58763          	beq	a1,a5,2a8 <strchr+0x1a>
  for(; *s; s++)
 29e:	0505                	addi	a0,a0,1
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	fbfd                	bnez	a5,29a <strchr+0xc>
      return (char*)s;
  return 0;
 2a6:	4501                	li	a0,0
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
  return 0;
 2ae:	4501                	li	a0,0
 2b0:	bfe5                	j	2a8 <strchr+0x1a>

00000000000002b2 <gets>:

char*
gets(char *buf, int max)
{
 2b2:	711d                	addi	sp,sp,-96
 2b4:	ec86                	sd	ra,88(sp)
 2b6:	e8a2                	sd	s0,80(sp)
 2b8:	e4a6                	sd	s1,72(sp)
 2ba:	e0ca                	sd	s2,64(sp)
 2bc:	fc4e                	sd	s3,56(sp)
 2be:	f852                	sd	s4,48(sp)
 2c0:	f456                	sd	s5,40(sp)
 2c2:	f05a                	sd	s6,32(sp)
 2c4:	ec5e                	sd	s7,24(sp)
 2c6:	1080                	addi	s0,sp,96
 2c8:	8baa                	mv	s7,a0
 2ca:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	892a                	mv	s2,a0
 2ce:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d0:	4aa9                	li	s5,10
 2d2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2d4:	89a6                	mv	s3,s1
 2d6:	2485                	addiw	s1,s1,1
 2d8:	0344d863          	bge	s1,s4,308 <gets+0x56>
    cc = read(0, &c, 1);
 2dc:	4605                	li	a2,1
 2de:	faf40593          	addi	a1,s0,-81
 2e2:	4501                	li	a0,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	19a080e7          	jalr	410(ra) # 47e <read>
    if(cc < 1)
 2ec:	00a05e63          	blez	a0,308 <gets+0x56>
    buf[i++] = c;
 2f0:	faf44783          	lbu	a5,-81(s0)
 2f4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f8:	01578763          	beq	a5,s5,306 <gets+0x54>
 2fc:	0905                	addi	s2,s2,1
 2fe:	fd679be3          	bne	a5,s6,2d4 <gets+0x22>
  for(i=0; i+1 < max; ){
 302:	89a6                	mv	s3,s1
 304:	a011                	j	308 <gets+0x56>
 306:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 308:	99de                	add	s3,s3,s7
 30a:	00098023          	sb	zero,0(s3)
  return buf;
}
 30e:	855e                	mv	a0,s7
 310:	60e6                	ld	ra,88(sp)
 312:	6446                	ld	s0,80(sp)
 314:	64a6                	ld	s1,72(sp)
 316:	6906                	ld	s2,64(sp)
 318:	79e2                	ld	s3,56(sp)
 31a:	7a42                	ld	s4,48(sp)
 31c:	7aa2                	ld	s5,40(sp)
 31e:	7b02                	ld	s6,32(sp)
 320:	6be2                	ld	s7,24(sp)
 322:	6125                	addi	sp,sp,96
 324:	8082                	ret

0000000000000326 <stat>:

int
stat(const char *n, struct stat *st)
{
 326:	1101                	addi	sp,sp,-32
 328:	ec06                	sd	ra,24(sp)
 32a:	e822                	sd	s0,16(sp)
 32c:	e426                	sd	s1,8(sp)
 32e:	e04a                	sd	s2,0(sp)
 330:	1000                	addi	s0,sp,32
 332:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 334:	4581                	li	a1,0
 336:	00000097          	auipc	ra,0x0
 33a:	170080e7          	jalr	368(ra) # 4a6 <open>
  if(fd < 0)
 33e:	02054563          	bltz	a0,368 <stat+0x42>
 342:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 344:	85ca                	mv	a1,s2
 346:	00000097          	auipc	ra,0x0
 34a:	178080e7          	jalr	376(ra) # 4be <fstat>
 34e:	892a                	mv	s2,a0
  close(fd);
 350:	8526                	mv	a0,s1
 352:	00000097          	auipc	ra,0x0
 356:	13c080e7          	jalr	316(ra) # 48e <close>
  return r;
}
 35a:	854a                	mv	a0,s2
 35c:	60e2                	ld	ra,24(sp)
 35e:	6442                	ld	s0,16(sp)
 360:	64a2                	ld	s1,8(sp)
 362:	6902                	ld	s2,0(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret
    return -1;
 368:	597d                	li	s2,-1
 36a:	bfc5                	j	35a <stat+0x34>

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 372:	00054683          	lbu	a3,0(a0)
 376:	fd06879b          	addiw	a5,a3,-48
 37a:	0ff7f793          	zext.b	a5,a5
 37e:	4625                	li	a2,9
 380:	02f66863          	bltu	a2,a5,3b0 <atoi+0x44>
 384:	872a                	mv	a4,a0
  n = 0;
 386:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 388:	0705                	addi	a4,a4,1
 38a:	0025179b          	slliw	a5,a0,0x2
 38e:	9fa9                	addw	a5,a5,a0
 390:	0017979b          	slliw	a5,a5,0x1
 394:	9fb5                	addw	a5,a5,a3
 396:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39a:	00074683          	lbu	a3,0(a4)
 39e:	fd06879b          	addiw	a5,a3,-48
 3a2:	0ff7f793          	zext.b	a5,a5
 3a6:	fef671e3          	bgeu	a2,a5,388 <atoi+0x1c>
  return n;
}
 3aa:	6422                	ld	s0,8(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret
  n = 0;
 3b0:	4501                	li	a0,0
 3b2:	bfe5                	j	3aa <atoi+0x3e>

00000000000003b4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ba:	02b57463          	bgeu	a0,a1,3e2 <memmove+0x2e>
    while(n-- > 0)
 3be:	00c05f63          	blez	a2,3dc <memmove+0x28>
 3c2:	1602                	slli	a2,a2,0x20
 3c4:	9201                	srli	a2,a2,0x20
 3c6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ca:	872a                	mv	a4,a0
      *dst++ = *src++;
 3cc:	0585                	addi	a1,a1,1
 3ce:	0705                	addi	a4,a4,1
 3d0:	fff5c683          	lbu	a3,-1(a1)
 3d4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3d8:	fee79ae3          	bne	a5,a4,3cc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3dc:	6422                	ld	s0,8(sp)
 3de:	0141                	addi	sp,sp,16
 3e0:	8082                	ret
    dst += n;
 3e2:	00c50733          	add	a4,a0,a2
    src += n;
 3e6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3e8:	fec05ae3          	blez	a2,3dc <memmove+0x28>
 3ec:	fff6079b          	addiw	a5,a2,-1
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	fff7c793          	not	a5,a5
 3f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3fa:	15fd                	addi	a1,a1,-1
 3fc:	177d                	addi	a4,a4,-1
 3fe:	0005c683          	lbu	a3,0(a1)
 402:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 406:	fee79ae3          	bne	a5,a4,3fa <memmove+0x46>
 40a:	bfc9                	j	3dc <memmove+0x28>

000000000000040c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 40c:	1141                	addi	sp,sp,-16
 40e:	e422                	sd	s0,8(sp)
 410:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 412:	ca05                	beqz	a2,442 <memcmp+0x36>
 414:	fff6069b          	addiw	a3,a2,-1
 418:	1682                	slli	a3,a3,0x20
 41a:	9281                	srli	a3,a3,0x20
 41c:	0685                	addi	a3,a3,1
 41e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 420:	00054783          	lbu	a5,0(a0)
 424:	0005c703          	lbu	a4,0(a1)
 428:	00e79863          	bne	a5,a4,438 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 42c:	0505                	addi	a0,a0,1
    p2++;
 42e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 430:	fed518e3          	bne	a0,a3,420 <memcmp+0x14>
  }
  return 0;
 434:	4501                	li	a0,0
 436:	a019                	j	43c <memcmp+0x30>
      return *p1 - *p2;
 438:	40e7853b          	subw	a0,a5,a4
}
 43c:	6422                	ld	s0,8(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret
  return 0;
 442:	4501                	li	a0,0
 444:	bfe5                	j	43c <memcmp+0x30>

0000000000000446 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 446:	1141                	addi	sp,sp,-16
 448:	e406                	sd	ra,8(sp)
 44a:	e022                	sd	s0,0(sp)
 44c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 44e:	00000097          	auipc	ra,0x0
 452:	f66080e7          	jalr	-154(ra) # 3b4 <memmove>
}
 456:	60a2                	ld	ra,8(sp)
 458:	6402                	ld	s0,0(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret

000000000000045e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 45e:	4885                	li	a7,1
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <exit>:
.global exit
exit:
 li a7, SYS_exit
 466:	4889                	li	a7,2
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <wait>:
.global wait
wait:
 li a7, SYS_wait
 46e:	488d                	li	a7,3
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 476:	4891                	li	a7,4
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <read>:
.global read
read:
 li a7, SYS_read
 47e:	4895                	li	a7,5
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <write>:
.global write
write:
 li a7, SYS_write
 486:	48c1                	li	a7,16
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <close>:
.global close
close:
 li a7, SYS_close
 48e:	48d5                	li	a7,21
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <kill>:
.global kill
kill:
 li a7, SYS_kill
 496:	4899                	li	a7,6
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <exec>:
.global exec
exec:
 li a7, SYS_exec
 49e:	489d                	li	a7,7
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <open>:
.global open
open:
 li a7, SYS_open
 4a6:	48bd                	li	a7,15
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ae:	48c5                	li	a7,17
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b6:	48c9                	li	a7,18
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4be:	48a1                	li	a7,8
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <link>:
.global link
link:
 li a7, SYS_link
 4c6:	48cd                	li	a7,19
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ce:	48d1                	li	a7,20
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d6:	48a5                	li	a7,9
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <dup>:
.global dup
dup:
 li a7, SYS_dup
 4de:	48a9                	li	a7,10
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e6:	48ad                	li	a7,11
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ee:	48b1                	li	a7,12
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4f6:	48b5                	li	a7,13
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4fe:	48b9                	li	a7,14
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 506:	1101                	addi	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	1000                	addi	s0,sp,32
 50e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 512:	4605                	li	a2,1
 514:	fef40593          	addi	a1,s0,-17
 518:	00000097          	auipc	ra,0x0
 51c:	f6e080e7          	jalr	-146(ra) # 486 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	addi	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	f04a                	sd	s2,32(sp)
 532:	ec4e                	sd	s3,24(sp)
 534:	0080                	addi	s0,sp,64
 536:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 538:	c299                	beqz	a3,53e <printint+0x16>
 53a:	0805c963          	bltz	a1,5cc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53e:	2581                	sext.w	a1,a1
  neg = 0;
 540:	4881                	li	a7,0
 542:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 546:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 548:	2601                	sext.w	a2,a2
 54a:	00000517          	auipc	a0,0x0
 54e:	4d650513          	addi	a0,a0,1238 # a20 <digits>
 552:	883a                	mv	a6,a4
 554:	2705                	addiw	a4,a4,1
 556:	02c5f7bb          	remuw	a5,a1,a2
 55a:	1782                	slli	a5,a5,0x20
 55c:	9381                	srli	a5,a5,0x20
 55e:	97aa                	add	a5,a5,a0
 560:	0007c783          	lbu	a5,0(a5)
 564:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 568:	0005879b          	sext.w	a5,a1
 56c:	02c5d5bb          	divuw	a1,a1,a2
 570:	0685                	addi	a3,a3,1
 572:	fec7f0e3          	bgeu	a5,a2,552 <printint+0x2a>
  if(neg)
 576:	00088c63          	beqz	a7,58e <printint+0x66>
    buf[i++] = '-';
 57a:	fd070793          	addi	a5,a4,-48
 57e:	00878733          	add	a4,a5,s0
 582:	02d00793          	li	a5,45
 586:	fef70823          	sb	a5,-16(a4)
 58a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 58e:	02e05863          	blez	a4,5be <printint+0x96>
 592:	fc040793          	addi	a5,s0,-64
 596:	00e78933          	add	s2,a5,a4
 59a:	fff78993          	addi	s3,a5,-1
 59e:	99ba                	add	s3,s3,a4
 5a0:	377d                	addiw	a4,a4,-1
 5a2:	1702                	slli	a4,a4,0x20
 5a4:	9301                	srli	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	fff94583          	lbu	a1,-1(s2)
 5ae:	8526                	mv	a0,s1
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f56080e7          	jalr	-170(ra) # 506 <putc>
  while(--i >= 0)
 5b8:	197d                	addi	s2,s2,-1
 5ba:	ff3918e3          	bne	s2,s3,5aa <printint+0x82>
}
 5be:	70e2                	ld	ra,56(sp)
 5c0:	7442                	ld	s0,48(sp)
 5c2:	74a2                	ld	s1,40(sp)
 5c4:	7902                	ld	s2,32(sp)
 5c6:	69e2                	ld	s3,24(sp)
 5c8:	6121                	addi	sp,sp,64
 5ca:	8082                	ret
    x = -xx;
 5cc:	40b005bb          	negw	a1,a1
    neg = 1;
 5d0:	4885                	li	a7,1
    x = -xx;
 5d2:	bf85                	j	542 <printint+0x1a>

00000000000005d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d4:	7119                	addi	sp,sp,-128
 5d6:	fc86                	sd	ra,120(sp)
 5d8:	f8a2                	sd	s0,112(sp)
 5da:	f4a6                	sd	s1,104(sp)
 5dc:	f0ca                	sd	s2,96(sp)
 5de:	ecce                	sd	s3,88(sp)
 5e0:	e8d2                	sd	s4,80(sp)
 5e2:	e4d6                	sd	s5,72(sp)
 5e4:	e0da                	sd	s6,64(sp)
 5e6:	fc5e                	sd	s7,56(sp)
 5e8:	f862                	sd	s8,48(sp)
 5ea:	f466                	sd	s9,40(sp)
 5ec:	f06a                	sd	s10,32(sp)
 5ee:	ec6e                	sd	s11,24(sp)
 5f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f2:	0005c903          	lbu	s2,0(a1)
 5f6:	18090f63          	beqz	s2,794 <vprintf+0x1c0>
 5fa:	8aaa                	mv	s5,a0
 5fc:	8b32                	mv	s6,a2
 5fe:	00158493          	addi	s1,a1,1
  state = 0;
 602:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 604:	02500a13          	li	s4,37
 608:	4c55                	li	s8,21
 60a:	00000c97          	auipc	s9,0x0
 60e:	3bec8c93          	addi	s9,s9,958 # 9c8 <malloc+0x130>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 612:	02800d93          	li	s11,40
  putc(fd, 'x');
 616:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 618:	00000b97          	auipc	s7,0x0
 61c:	408b8b93          	addi	s7,s7,1032 # a20 <digits>
 620:	a839                	j	63e <vprintf+0x6a>
        putc(fd, c);
 622:	85ca                	mv	a1,s2
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	ee0080e7          	jalr	-288(ra) # 506 <putc>
 62e:	a019                	j	634 <vprintf+0x60>
    } else if(state == '%'){
 630:	01498d63          	beq	s3,s4,64a <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 634:	0485                	addi	s1,s1,1
 636:	fff4c903          	lbu	s2,-1(s1)
 63a:	14090d63          	beqz	s2,794 <vprintf+0x1c0>
    if(state == 0){
 63e:	fe0999e3          	bnez	s3,630 <vprintf+0x5c>
      if(c == '%'){
 642:	ff4910e3          	bne	s2,s4,622 <vprintf+0x4e>
        state = '%';
 646:	89d2                	mv	s3,s4
 648:	b7f5                	j	634 <vprintf+0x60>
      if(c == 'd'){
 64a:	11490c63          	beq	s2,s4,762 <vprintf+0x18e>
 64e:	f9d9079b          	addiw	a5,s2,-99
 652:	0ff7f793          	zext.b	a5,a5
 656:	10fc6e63          	bltu	s8,a5,772 <vprintf+0x19e>
 65a:	f9d9079b          	addiw	a5,s2,-99
 65e:	0ff7f713          	zext.b	a4,a5
 662:	10ec6863          	bltu	s8,a4,772 <vprintf+0x19e>
 666:	00271793          	slli	a5,a4,0x2
 66a:	97e6                	add	a5,a5,s9
 66c:	439c                	lw	a5,0(a5)
 66e:	97e6                	add	a5,a5,s9
 670:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 672:	008b0913          	addi	s2,s6,8
 676:	4685                	li	a3,1
 678:	4629                	li	a2,10
 67a:	000b2583          	lw	a1,0(s6)
 67e:	8556                	mv	a0,s5
 680:	00000097          	auipc	ra,0x0
 684:	ea8080e7          	jalr	-344(ra) # 528 <printint>
 688:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b765                	j	634 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68e:	008b0913          	addi	s2,s6,8
 692:	4681                	li	a3,0
 694:	4629                	li	a2,10
 696:	000b2583          	lw	a1,0(s6)
 69a:	8556                	mv	a0,s5
 69c:	00000097          	auipc	ra,0x0
 6a0:	e8c080e7          	jalr	-372(ra) # 528 <printint>
 6a4:	8b4a                	mv	s6,s2
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b771                	j	634 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6aa:	008b0913          	addi	s2,s6,8
 6ae:	4681                	li	a3,0
 6b0:	866a                	mv	a2,s10
 6b2:	000b2583          	lw	a1,0(s6)
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	e70080e7          	jalr	-400(ra) # 528 <printint>
 6c0:	8b4a                	mv	s6,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf85                	j	634 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6c6:	008b0793          	addi	a5,s6,8
 6ca:	f8f43423          	sd	a5,-120(s0)
 6ce:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6d2:	03000593          	li	a1,48
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	e2e080e7          	jalr	-466(ra) # 506 <putc>
  putc(fd, 'x');
 6e0:	07800593          	li	a1,120
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e20080e7          	jalr	-480(ra) # 506 <putc>
 6ee:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f0:	03c9d793          	srli	a5,s3,0x3c
 6f4:	97de                	add	a5,a5,s7
 6f6:	0007c583          	lbu	a1,0(a5)
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e0a080e7          	jalr	-502(ra) # 506 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 704:	0992                	slli	s3,s3,0x4
 706:	397d                	addiw	s2,s2,-1
 708:	fe0914e3          	bnez	s2,6f0 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 70c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 710:	4981                	li	s3,0
 712:	b70d                	j	634 <vprintf+0x60>
        s = va_arg(ap, char*);
 714:	008b0913          	addi	s2,s6,8
 718:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 71c:	02098163          	beqz	s3,73e <vprintf+0x16a>
        while(*s != 0){
 720:	0009c583          	lbu	a1,0(s3)
 724:	c5ad                	beqz	a1,78e <vprintf+0x1ba>
          putc(fd, *s);
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	dde080e7          	jalr	-546(ra) # 506 <putc>
          s++;
 730:	0985                	addi	s3,s3,1
        while(*s != 0){
 732:	0009c583          	lbu	a1,0(s3)
 736:	f9e5                	bnez	a1,726 <vprintf+0x152>
        s = va_arg(ap, char*);
 738:	8b4a                	mv	s6,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bde5                	j	634 <vprintf+0x60>
          s = "(null)";
 73e:	00000997          	auipc	s3,0x0
 742:	28298993          	addi	s3,s3,642 # 9c0 <malloc+0x128>
        while(*s != 0){
 746:	85ee                	mv	a1,s11
 748:	bff9                	j	726 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 74a:	008b0913          	addi	s2,s6,8
 74e:	000b4583          	lbu	a1,0(s6)
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	db2080e7          	jalr	-590(ra) # 506 <putc>
 75c:	8b4a                	mv	s6,s2
      state = 0;
 75e:	4981                	li	s3,0
 760:	bdd1                	j	634 <vprintf+0x60>
        putc(fd, c);
 762:	85d2                	mv	a1,s4
 764:	8556                	mv	a0,s5
 766:	00000097          	auipc	ra,0x0
 76a:	da0080e7          	jalr	-608(ra) # 506 <putc>
      state = 0;
 76e:	4981                	li	s3,0
 770:	b5d1                	j	634 <vprintf+0x60>
        putc(fd, '%');
 772:	85d2                	mv	a1,s4
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	d90080e7          	jalr	-624(ra) # 506 <putc>
        putc(fd, c);
 77e:	85ca                	mv	a1,s2
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	d84080e7          	jalr	-636(ra) # 506 <putc>
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b565                	j	634 <vprintf+0x60>
        s = va_arg(ap, char*);
 78e:	8b4a                	mv	s6,s2
      state = 0;
 790:	4981                	li	s3,0
 792:	b54d                	j	634 <vprintf+0x60>
    }
  }
}
 794:	70e6                	ld	ra,120(sp)
 796:	7446                	ld	s0,112(sp)
 798:	74a6                	ld	s1,104(sp)
 79a:	7906                	ld	s2,96(sp)
 79c:	69e6                	ld	s3,88(sp)
 79e:	6a46                	ld	s4,80(sp)
 7a0:	6aa6                	ld	s5,72(sp)
 7a2:	6b06                	ld	s6,64(sp)
 7a4:	7be2                	ld	s7,56(sp)
 7a6:	7c42                	ld	s8,48(sp)
 7a8:	7ca2                	ld	s9,40(sp)
 7aa:	7d02                	ld	s10,32(sp)
 7ac:	6de2                	ld	s11,24(sp)
 7ae:	6109                	addi	sp,sp,128
 7b0:	8082                	ret

00000000000007b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b2:	715d                	addi	sp,sp,-80
 7b4:	ec06                	sd	ra,24(sp)
 7b6:	e822                	sd	s0,16(sp)
 7b8:	1000                	addi	s0,sp,32
 7ba:	e010                	sd	a2,0(s0)
 7bc:	e414                	sd	a3,8(s0)
 7be:	e818                	sd	a4,16(s0)
 7c0:	ec1c                	sd	a5,24(s0)
 7c2:	03043023          	sd	a6,32(s0)
 7c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ce:	8622                	mv	a2,s0
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e04080e7          	jalr	-508(ra) # 5d4 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6161                	addi	sp,sp,80
 7de:	8082                	ret

00000000000007e0 <printf>:

void
printf(const char *fmt, ...)
{
 7e0:	711d                	addi	sp,sp,-96
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	e40c                	sd	a1,8(s0)
 7ea:	e810                	sd	a2,16(s0)
 7ec:	ec14                	sd	a3,24(s0)
 7ee:	f018                	sd	a4,32(s0)
 7f0:	f41c                	sd	a5,40(s0)
 7f2:	03043823          	sd	a6,48(s0)
 7f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fa:	00840613          	addi	a2,s0,8
 7fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 802:	85aa                	mv	a1,a0
 804:	4505                	li	a0,1
 806:	00000097          	auipc	ra,0x0
 80a:	dce080e7          	jalr	-562(ra) # 5d4 <vprintf>
}
 80e:	60e2                	ld	ra,24(sp)
 810:	6442                	ld	s0,16(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret

0000000000000816 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 816:	1141                	addi	sp,sp,-16
 818:	e422                	sd	s0,8(sp)
 81a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 820:	00000797          	auipc	a5,0x0
 824:	7e07b783          	ld	a5,2016(a5) # 1000 <freep>
 828:	a02d                	j	852 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82a:	4618                	lw	a4,8(a2)
 82c:	9f2d                	addw	a4,a4,a1
 82e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	6398                	ld	a4,0(a5)
 834:	6310                	ld	a2,0(a4)
 836:	a83d                	j	874 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 838:	ff852703          	lw	a4,-8(a0)
 83c:	9f31                	addw	a4,a4,a2
 83e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 840:	ff053683          	ld	a3,-16(a0)
 844:	a091                	j	888 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 846:	6398                	ld	a4,0(a5)
 848:	00e7e463          	bltu	a5,a4,850 <free+0x3a>
 84c:	00e6ea63          	bltu	a3,a4,860 <free+0x4a>
{
 850:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 852:	fed7fae3          	bgeu	a5,a3,846 <free+0x30>
 856:	6398                	ld	a4,0(a5)
 858:	00e6e463          	bltu	a3,a4,860 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85c:	fee7eae3          	bltu	a5,a4,850 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 860:	ff852583          	lw	a1,-8(a0)
 864:	6390                	ld	a2,0(a5)
 866:	02059813          	slli	a6,a1,0x20
 86a:	01c85713          	srli	a4,a6,0x1c
 86e:	9736                	add	a4,a4,a3
 870:	fae60de3          	beq	a2,a4,82a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 878:	4790                	lw	a2,8(a5)
 87a:	02061593          	slli	a1,a2,0x20
 87e:	01c5d713          	srli	a4,a1,0x1c
 882:	973e                	add	a4,a4,a5
 884:	fae68ae3          	beq	a3,a4,838 <free+0x22>
    p->s.ptr = bp->s.ptr;
 888:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88a:	00000717          	auipc	a4,0x0
 88e:	76f73b23          	sd	a5,1910(a4) # 1000 <freep>
}
 892:	6422                	ld	s0,8(sp)
 894:	0141                	addi	sp,sp,16
 896:	8082                	ret

0000000000000898 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 898:	7139                	addi	sp,sp,-64
 89a:	fc06                	sd	ra,56(sp)
 89c:	f822                	sd	s0,48(sp)
 89e:	f426                	sd	s1,40(sp)
 8a0:	f04a                	sd	s2,32(sp)
 8a2:	ec4e                	sd	s3,24(sp)
 8a4:	e852                	sd	s4,16(sp)
 8a6:	e456                	sd	s5,8(sp)
 8a8:	e05a                	sd	s6,0(sp)
 8aa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ac:	02051493          	slli	s1,a0,0x20
 8b0:	9081                	srli	s1,s1,0x20
 8b2:	04bd                	addi	s1,s1,15
 8b4:	8091                	srli	s1,s1,0x4
 8b6:	0014899b          	addiw	s3,s1,1
 8ba:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8bc:	00000517          	auipc	a0,0x0
 8c0:	74453503          	ld	a0,1860(a0) # 1000 <freep>
 8c4:	c515                	beqz	a0,8f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	02977f63          	bgeu	a4,s1,908 <malloc+0x70>
 8ce:	8a4e                	mv	s4,s3
 8d0:	0009871b          	sext.w	a4,s3
 8d4:	6685                	lui	a3,0x1
 8d6:	00d77363          	bgeu	a4,a3,8dc <malloc+0x44>
 8da:	6a05                	lui	s4,0x1
 8dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e4:	00000917          	auipc	s2,0x0
 8e8:	71c90913          	addi	s2,s2,1820 # 1000 <freep>
  if(p == (char*)-1)
 8ec:	5afd                	li	s5,-1
 8ee:	a895                	j	962 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 8f0:	00000797          	auipc	a5,0x0
 8f4:	72078793          	addi	a5,a5,1824 # 1010 <base>
 8f8:	00000717          	auipc	a4,0x0
 8fc:	70f73423          	sd	a5,1800(a4) # 1000 <freep>
 900:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 902:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 906:	b7e1                	j	8ce <malloc+0x36>
      if(p->s.size == nunits)
 908:	02e48c63          	beq	s1,a4,940 <malloc+0xa8>
        p->s.size -= nunits;
 90c:	4137073b          	subw	a4,a4,s3
 910:	c798                	sw	a4,8(a5)
        p += p->s.size;
 912:	02071693          	slli	a3,a4,0x20
 916:	01c6d713          	srli	a4,a3,0x1c
 91a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 920:	00000717          	auipc	a4,0x0
 924:	6ea73023          	sd	a0,1760(a4) # 1000 <freep>
      return (void*)(p + 1);
 928:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 92c:	70e2                	ld	ra,56(sp)
 92e:	7442                	ld	s0,48(sp)
 930:	74a2                	ld	s1,40(sp)
 932:	7902                	ld	s2,32(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 940:	6398                	ld	a4,0(a5)
 942:	e118                	sd	a4,0(a0)
 944:	bff1                	j	920 <malloc+0x88>
  hp->s.size = nu;
 946:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94a:	0541                	addi	a0,a0,16
 94c:	00000097          	auipc	ra,0x0
 950:	eca080e7          	jalr	-310(ra) # 816 <free>
  return freep;
 954:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 958:	d971                	beqz	a0,92c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95c:	4798                	lw	a4,8(a5)
 95e:	fa9775e3          	bgeu	a4,s1,908 <malloc+0x70>
    if(p == freep)
 962:	00093703          	ld	a4,0(s2)
 966:	853e                	mv	a0,a5
 968:	fef719e3          	bne	a4,a5,95a <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 96c:	8552                	mv	a0,s4
 96e:	00000097          	auipc	ra,0x0
 972:	b80080e7          	jalr	-1152(ra) # 4ee <sbrk>
  if(p == (char*)-1)
 976:	fd5518e3          	bne	a0,s5,946 <malloc+0xae>
        return 0;
 97a:	4501                	li	a0,0
 97c:	bf45                	j	92c <malloc+0x94>
