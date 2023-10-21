
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	91013103          	ld	sp,-1776(sp) # 80008910 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	053050ef          	jal	ra,80005868 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	fb078793          	addi	a5,a5,-80 # 80021fe0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	132080e7          	jalr	306(ra) # 8000017a <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	92090913          	addi	s2,s2,-1760 # 80008970 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1fa080e7          	jalr	506(ra) # 80006254 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	29a080e7          	jalr	666(ra) # 80006308 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c92080e7          	jalr	-878(ra) # 80005d1c <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	88250513          	addi	a0,a0,-1918 # 80008970 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0ce080e7          	jalr	206(ra) # 800061c4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	ede50513          	addi	a0,a0,-290 # 80021fe0 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	84c48493          	addi	s1,s1,-1972 # 80008970 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	126080e7          	jalr	294(ra) # 80006254 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	83450513          	addi	a0,a0,-1996 # 80008970 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	1c2080e7          	jalr	450(ra) # 80006308 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	026080e7          	jalr	38(ra) # 8000017a <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	80850513          	addi	a0,a0,-2040 # 80008970 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	198080e7          	jalr	408(ra) # 80006308 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000017a:	1141                	addi	sp,sp,-16
    8000017c:	e422                	sd	s0,8(sp)
    8000017e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000180:	ca19                	beqz	a2,80000196 <memset+0x1c>
    80000182:	87aa                	mv	a5,a0
    80000184:	1602                	slli	a2,a2,0x20
    80000186:	9201                	srli	a2,a2,0x20
    80000188:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    8000018c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000190:	0785                	addi	a5,a5,1
    80000192:	fee79de3          	bne	a5,a4,8000018c <memset+0x12>
  }
  return dst;
}
    80000196:	6422                	ld	s0,8(sp)
    80000198:	0141                	addi	sp,sp,16
    8000019a:	8082                	ret

000000008000019c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a2:	ca05                	beqz	a2,800001d2 <memcmp+0x36>
    800001a4:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001a8:	1682                	slli	a3,a3,0x20
    800001aa:	9281                	srli	a3,a3,0x20
    800001ac:	0685                	addi	a3,a3,1
    800001ae:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b0:	00054783          	lbu	a5,0(a0)
    800001b4:	0005c703          	lbu	a4,0(a1)
    800001b8:	00e79863          	bne	a5,a4,800001c8 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001bc:	0505                	addi	a0,a0,1
    800001be:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c0:	fed518e3          	bne	a0,a3,800001b0 <memcmp+0x14>
  }

  return 0;
    800001c4:	4501                	li	a0,0
    800001c6:	a019                	j	800001cc <memcmp+0x30>
      return *s1 - *s2;
    800001c8:	40e7853b          	subw	a0,a5,a4
}
    800001cc:	6422                	ld	s0,8(sp)
    800001ce:	0141                	addi	sp,sp,16
    800001d0:	8082                	ret
  return 0;
    800001d2:	4501                	li	a0,0
    800001d4:	bfe5                	j	800001cc <memcmp+0x30>

00000000800001d6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d6:	1141                	addi	sp,sp,-16
    800001d8:	e422                	sd	s0,8(sp)
    800001da:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001dc:	c205                	beqz	a2,800001fc <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001de:	02a5e263          	bltu	a1,a0,80000202 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001e2:	1602                	slli	a2,a2,0x20
    800001e4:	9201                	srli	a2,a2,0x20
    800001e6:	00c587b3          	add	a5,a1,a2
{
    800001ea:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ec:	0585                	addi	a1,a1,1
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdd021>
    800001f0:	fff5c683          	lbu	a3,-1(a1)
    800001f4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001f8:	fef59ae3          	bne	a1,a5,800001ec <memmove+0x16>

  return dst;
}
    800001fc:	6422                	ld	s0,8(sp)
    800001fe:	0141                	addi	sp,sp,16
    80000200:	8082                	ret
  if(s < d && s + n > d){
    80000202:	02061693          	slli	a3,a2,0x20
    80000206:	9281                	srli	a3,a3,0x20
    80000208:	00d58733          	add	a4,a1,a3
    8000020c:	fce57be3          	bgeu	a0,a4,800001e2 <memmove+0xc>
    d += n;
    80000210:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000212:	fff6079b          	addiw	a5,a2,-1
    80000216:	1782                	slli	a5,a5,0x20
    80000218:	9381                	srli	a5,a5,0x20
    8000021a:	fff7c793          	not	a5,a5
    8000021e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000220:	177d                	addi	a4,a4,-1
    80000222:	16fd                	addi	a3,a3,-1
    80000224:	00074603          	lbu	a2,0(a4)
    80000228:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000022c:	fee79ae3          	bne	a5,a4,80000220 <memmove+0x4a>
    80000230:	b7f1                	j	800001fc <memmove+0x26>

0000000080000232 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000023a:	00000097          	auipc	ra,0x0
    8000023e:	f9c080e7          	jalr	-100(ra) # 800001d6 <memmove>
}
    80000242:	60a2                	ld	ra,8(sp)
    80000244:	6402                	ld	s0,0(sp)
    80000246:	0141                	addi	sp,sp,16
    80000248:	8082                	ret

000000008000024a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000024a:	1141                	addi	sp,sp,-16
    8000024c:	e422                	sd	s0,8(sp)
    8000024e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000250:	ce11                	beqz	a2,8000026c <strncmp+0x22>
    80000252:	00054783          	lbu	a5,0(a0)
    80000256:	cf89                	beqz	a5,80000270 <strncmp+0x26>
    80000258:	0005c703          	lbu	a4,0(a1)
    8000025c:	00f71a63          	bne	a4,a5,80000270 <strncmp+0x26>
    n--, p++, q++;
    80000260:	367d                	addiw	a2,a2,-1
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000266:	f675                	bnez	a2,80000252 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000268:	4501                	li	a0,0
    8000026a:	a809                	j	8000027c <strncmp+0x32>
    8000026c:	4501                	li	a0,0
    8000026e:	a039                	j	8000027c <strncmp+0x32>
  if(n == 0)
    80000270:	ca09                	beqz	a2,80000282 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000272:	00054503          	lbu	a0,0(a0)
    80000276:	0005c783          	lbu	a5,0(a1)
    8000027a:	9d1d                	subw	a0,a0,a5
}
    8000027c:	6422                	ld	s0,8(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret
    return 0;
    80000282:	4501                	li	a0,0
    80000284:	bfe5                	j	8000027c <strncmp+0x32>

0000000080000286 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e422                	sd	s0,8(sp)
    8000028a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000028c:	872a                	mv	a4,a0
    8000028e:	8832                	mv	a6,a2
    80000290:	367d                	addiw	a2,a2,-1
    80000292:	01005963          	blez	a6,800002a4 <strncpy+0x1e>
    80000296:	0705                	addi	a4,a4,1
    80000298:	0005c783          	lbu	a5,0(a1)
    8000029c:	fef70fa3          	sb	a5,-1(a4)
    800002a0:	0585                	addi	a1,a1,1
    800002a2:	f7f5                	bnez	a5,8000028e <strncpy+0x8>
    ;
  while(n-- > 0)
    800002a4:	86ba                	mv	a3,a4
    800002a6:	00c05c63          	blez	a2,800002be <strncpy+0x38>
    *s++ = 0;
    800002aa:	0685                	addi	a3,a3,1
    800002ac:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b0:	40d707bb          	subw	a5,a4,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	010787bb          	addw	a5,a5,a6
    800002ba:	fef048e3          	bgtz	a5,800002aa <strncpy+0x24>
  return os;
}
    800002be:	6422                	ld	s0,8(sp)
    800002c0:	0141                	addi	sp,sp,16
    800002c2:	8082                	ret

00000000800002c4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002c4:	1141                	addi	sp,sp,-16
    800002c6:	e422                	sd	s0,8(sp)
    800002c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ca:	02c05363          	blez	a2,800002f0 <safestrcpy+0x2c>
    800002ce:	fff6069b          	addiw	a3,a2,-1
    800002d2:	1682                	slli	a3,a3,0x20
    800002d4:	9281                	srli	a3,a3,0x20
    800002d6:	96ae                	add	a3,a3,a1
    800002d8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002da:	00d58963          	beq	a1,a3,800002ec <safestrcpy+0x28>
    800002de:	0585                	addi	a1,a1,1
    800002e0:	0785                	addi	a5,a5,1
    800002e2:	fff5c703          	lbu	a4,-1(a1)
    800002e6:	fee78fa3          	sb	a4,-1(a5)
    800002ea:	fb65                	bnez	a4,800002da <safestrcpy+0x16>
    ;
  *s = 0;
    800002ec:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f0:	6422                	ld	s0,8(sp)
    800002f2:	0141                	addi	sp,sp,16
    800002f4:	8082                	ret

00000000800002f6 <strlen>:

int
strlen(const char *s)
{
    800002f6:	1141                	addi	sp,sp,-16
    800002f8:	e422                	sd	s0,8(sp)
    800002fa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf91                	beqz	a5,8000031c <strlen+0x26>
    80000302:	0505                	addi	a0,a0,1
    80000304:	87aa                	mv	a5,a0
    80000306:	4685                	li	a3,1
    80000308:	9e89                	subw	a3,a3,a0
    8000030a:	00f6853b          	addw	a0,a3,a5
    8000030e:	0785                	addi	a5,a5,1
    80000310:	fff7c703          	lbu	a4,-1(a5)
    80000314:	fb7d                	bnez	a4,8000030a <strlen+0x14>
    ;
  return n;
}
    80000316:	6422                	ld	s0,8(sp)
    80000318:	0141                	addi	sp,sp,16
    8000031a:	8082                	ret
  for(n = 0; s[n]; n++)
    8000031c:	4501                	li	a0,0
    8000031e:	bfe5                	j	80000316 <strlen+0x20>

0000000080000320 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e406                	sd	ra,8(sp)
    80000324:	e022                	sd	s0,0(sp)
    80000326:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000328:	00001097          	auipc	ra,0x1
    8000032c:	bea080e7          	jalr	-1046(ra) # 80000f12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000330:	00008717          	auipc	a4,0x8
    80000334:	60070713          	addi	a4,a4,1536 # 80008930 <started>
  if(cpuid() == 0){
    80000338:	c139                	beqz	a0,8000037e <main+0x5e>
    while(started == 0)
    8000033a:	431c                	lw	a5,0(a4)
    8000033c:	2781                	sext.w	a5,a5
    8000033e:	dff5                	beqz	a5,8000033a <main+0x1a>
      ;
    __sync_synchronize();
    80000340:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000344:	00001097          	auipc	ra,0x1
    80000348:	bce080e7          	jalr	-1074(ra) # 80000f12 <cpuid>
    8000034c:	85aa                	mv	a1,a0
    8000034e:	00008517          	auipc	a0,0x8
    80000352:	cea50513          	addi	a0,a0,-790 # 80008038 <etext+0x38>
    80000356:	00006097          	auipc	ra,0x6
    8000035a:	a10080e7          	jalr	-1520(ra) # 80005d66 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8f4080e7          	jalr	-1804(ra) # 80001c5a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	eb2080e7          	jalr	-334(ra) # 80005220 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	13c080e7          	jalr	316(ra) # 800014b2 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	8ae080e7          	jalr	-1874(ra) # 80005c2c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	bc0080e7          	jalr	-1088(ra) # 80005f46 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	9d0080e7          	jalr	-1584(ra) # 80005d66 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	9c0080e7          	jalr	-1600(ra) # 80005d66 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	9b0080e7          	jalr	-1616(ra) # 80005d66 <printf>
    kinit();         // physical page allocator
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	d20080e7          	jalr	-736(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    800003c6:	00000097          	auipc	ra,0x0
    800003ca:	326080e7          	jalr	806(ra) # 800006ec <kvminit>
    kvminithart();   // turn on paging
    800003ce:	00000097          	auipc	ra,0x0
    800003d2:	068080e7          	jalr	104(ra) # 80000436 <kvminithart>
    procinit();      // process table
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	a8a080e7          	jalr	-1398(ra) # 80000e60 <procinit>
    trapinit();      // trap vectors
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	854080e7          	jalr	-1964(ra) # 80001c32 <trapinit>
    trapinithart();  // install kernel trap vector
    800003e6:	00002097          	auipc	ra,0x2
    800003ea:	874080e7          	jalr	-1932(ra) # 80001c5a <trapinithart>
    plicinit();      // set up interrupt controller
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	e1c080e7          	jalr	-484(ra) # 8000520a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	e2a080e7          	jalr	-470(ra) # 80005220 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	fa6080e7          	jalr	-90(ra) # 800023a4 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	646080e7          	jalr	1606(ra) # 80002a4c <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	5ec080e7          	jalr	1516(ra) # 800039fa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	f12080e7          	jalr	-238(ra) # 80005328 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	e76080e7          	jalr	-394(ra) # 80001294 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	50f72223          	sw	a5,1284(a4) # 80008930 <started>
    80000434:	b789                	j	80000376 <main+0x56>

0000000080000436 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000436:	1141                	addi	sp,sp,-16
    80000438:	e422                	sd	s0,8(sp)
    8000043a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000043c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000440:	00008797          	auipc	a5,0x8
    80000444:	5007b783          	ld	a5,1280(a5) # 80008940 <kernel_pagetable>
    80000448:	83b1                	srli	a5,a5,0xc
    8000044a:	577d                	li	a4,-1
    8000044c:	177e                	slli	a4,a4,0x3f
    8000044e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000450:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000454:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000458:	6422                	ld	s0,8(sp)
    8000045a:	0141                	addi	sp,sp,16
    8000045c:	8082                	ret

000000008000045e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000045e:	7139                	addi	sp,sp,-64
    80000460:	fc06                	sd	ra,56(sp)
    80000462:	f822                	sd	s0,48(sp)
    80000464:	f426                	sd	s1,40(sp)
    80000466:	f04a                	sd	s2,32(sp)
    80000468:	ec4e                	sd	s3,24(sp)
    8000046a:	e852                	sd	s4,16(sp)
    8000046c:	e456                	sd	s5,8(sp)
    8000046e:	e05a                	sd	s6,0(sp)
    80000470:	0080                	addi	s0,sp,64
    80000472:	84aa                	mv	s1,a0
    80000474:	89ae                	mv	s3,a1
    80000476:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000478:	57fd                	li	a5,-1
    8000047a:	83e9                	srli	a5,a5,0x1a
    8000047c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000047e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000480:	04b7f263          	bgeu	a5,a1,800004c4 <walk+0x66>
    panic("walk");
    80000484:	00008517          	auipc	a0,0x8
    80000488:	bcc50513          	addi	a0,a0,-1076 # 80008050 <etext+0x50>
    8000048c:	00006097          	auipc	ra,0x6
    80000490:	890080e7          	jalr	-1904(ra) # 80005d1c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000494:	060a8663          	beqz	s5,80000500 <walk+0xa2>
    80000498:	00000097          	auipc	ra,0x0
    8000049c:	c82080e7          	jalr	-894(ra) # 8000011a <kalloc>
    800004a0:	84aa                	mv	s1,a0
    800004a2:	c529                	beqz	a0,800004ec <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004a4:	6605                	lui	a2,0x1
    800004a6:	4581                	li	a1,0
    800004a8:	00000097          	auipc	ra,0x0
    800004ac:	cd2080e7          	jalr	-814(ra) # 8000017a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b0:	00c4d793          	srli	a5,s1,0xc
    800004b4:	07aa                	slli	a5,a5,0xa
    800004b6:	0017e793          	ori	a5,a5,1
    800004ba:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdd017>
    800004c0:	036a0063          	beq	s4,s6,800004e0 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004c4:	0149d933          	srl	s2,s3,s4
    800004c8:	1ff97913          	andi	s2,s2,511
    800004cc:	090e                	slli	s2,s2,0x3
    800004ce:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d0:	00093483          	ld	s1,0(s2)
    800004d4:	0014f793          	andi	a5,s1,1
    800004d8:	dfd5                	beqz	a5,80000494 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004da:	80a9                	srli	s1,s1,0xa
    800004dc:	04b2                	slli	s1,s1,0xc
    800004de:	b7c5                	j	800004be <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e0:	00c9d513          	srli	a0,s3,0xc
    800004e4:	1ff57513          	andi	a0,a0,511
    800004e8:	050e                	slli	a0,a0,0x3
    800004ea:	9526                	add	a0,a0,s1
}
    800004ec:	70e2                	ld	ra,56(sp)
    800004ee:	7442                	ld	s0,48(sp)
    800004f0:	74a2                	ld	s1,40(sp)
    800004f2:	7902                	ld	s2,32(sp)
    800004f4:	69e2                	ld	s3,24(sp)
    800004f6:	6a42                	ld	s4,16(sp)
    800004f8:	6aa2                	ld	s5,8(sp)
    800004fa:	6b02                	ld	s6,0(sp)
    800004fc:	6121                	addi	sp,sp,64
    800004fe:	8082                	ret
        return 0;
    80000500:	4501                	li	a0,0
    80000502:	b7ed                	j	800004ec <walk+0x8e>

0000000080000504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000504:	57fd                	li	a5,-1
    80000506:	83e9                	srli	a5,a5,0x1a
    80000508:	00b7f463          	bgeu	a5,a1,80000510 <walkaddr+0xc>
    return 0;
    8000050c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000050e:	8082                	ret
{
    80000510:	1141                	addi	sp,sp,-16
    80000512:	e406                	sd	ra,8(sp)
    80000514:	e022                	sd	s0,0(sp)
    80000516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000518:	4601                	li	a2,0
    8000051a:	00000097          	auipc	ra,0x0
    8000051e:	f44080e7          	jalr	-188(ra) # 8000045e <walk>
  if(pte == 0)
    80000522:	c105                	beqz	a0,80000542 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000524:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000526:	0117f693          	andi	a3,a5,17
    8000052a:	4745                	li	a4,17
    return 0;
    8000052c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000052e:	00e68663          	beq	a3,a4,8000053a <walkaddr+0x36>
}
    80000532:	60a2                	ld	ra,8(sp)
    80000534:	6402                	ld	s0,0(sp)
    80000536:	0141                	addi	sp,sp,16
    80000538:	8082                	ret
  pa = PTE2PA(*pte);
    8000053a:	83a9                	srli	a5,a5,0xa
    8000053c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000540:	bfcd                	j	80000532 <walkaddr+0x2e>
    return 0;
    80000542:	4501                	li	a0,0
    80000544:	b7fd                	j	80000532 <walkaddr+0x2e>

0000000080000546 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000546:	715d                	addi	sp,sp,-80
    80000548:	e486                	sd	ra,72(sp)
    8000054a:	e0a2                	sd	s0,64(sp)
    8000054c:	fc26                	sd	s1,56(sp)
    8000054e:	f84a                	sd	s2,48(sp)
    80000550:	f44e                	sd	s3,40(sp)
    80000552:	f052                	sd	s4,32(sp)
    80000554:	ec56                	sd	s5,24(sp)
    80000556:	e85a                	sd	s6,16(sp)
    80000558:	e45e                	sd	s7,8(sp)
    8000055a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000055c:	c639                	beqz	a2,800005aa <mappages+0x64>
    8000055e:	8aaa                	mv	s5,a0
    80000560:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000562:	777d                	lui	a4,0xfffff
    80000564:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000568:	fff58993          	addi	s3,a1,-1
    8000056c:	99b2                	add	s3,s3,a2
    8000056e:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80000572:	893e                	mv	s2,a5
    80000574:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000578:	6b85                	lui	s7,0x1
    8000057a:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    8000057e:	4605                	li	a2,1
    80000580:	85ca                	mv	a1,s2
    80000582:	8556                	mv	a0,s5
    80000584:	00000097          	auipc	ra,0x0
    80000588:	eda080e7          	jalr	-294(ra) # 8000045e <walk>
    8000058c:	cd1d                	beqz	a0,800005ca <mappages+0x84>
    if(*pte & PTE_V)
    8000058e:	611c                	ld	a5,0(a0)
    80000590:	8b85                	andi	a5,a5,1
    80000592:	e785                	bnez	a5,800005ba <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000594:	80b1                	srli	s1,s1,0xc
    80000596:	04aa                	slli	s1,s1,0xa
    80000598:	0164e4b3          	or	s1,s1,s6
    8000059c:	0014e493          	ori	s1,s1,1
    800005a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005a2:	05390063          	beq	s2,s3,800005e2 <mappages+0x9c>
    a += PGSIZE;
    800005a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	bfc9                	j	8000057a <mappages+0x34>
    panic("mappages: size");
    800005aa:	00008517          	auipc	a0,0x8
    800005ae:	aae50513          	addi	a0,a0,-1362 # 80008058 <etext+0x58>
    800005b2:	00005097          	auipc	ra,0x5
    800005b6:	76a080e7          	jalr	1898(ra) # 80005d1c <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00005097          	auipc	ra,0x5
    800005c6:	75a080e7          	jalr	1882(ra) # 80005d1c <panic>
      return -1;
    800005ca:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800005cc:	60a6                	ld	ra,72(sp)
    800005ce:	6406                	ld	s0,64(sp)
    800005d0:	74e2                	ld	s1,56(sp)
    800005d2:	7942                	ld	s2,48(sp)
    800005d4:	79a2                	ld	s3,40(sp)
    800005d6:	7a02                	ld	s4,32(sp)
    800005d8:	6ae2                	ld	s5,24(sp)
    800005da:	6b42                	ld	s6,16(sp)
    800005dc:	6ba2                	ld	s7,8(sp)
    800005de:	6161                	addi	sp,sp,80
    800005e0:	8082                	ret
  return 0;
    800005e2:	4501                	li	a0,0
    800005e4:	b7e5                	j	800005cc <mappages+0x86>

00000000800005e6 <kvmmap>:
{
    800005e6:	1141                	addi	sp,sp,-16
    800005e8:	e406                	sd	ra,8(sp)
    800005ea:	e022                	sd	s0,0(sp)
    800005ec:	0800                	addi	s0,sp,16
    800005ee:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f0:	86b2                	mv	a3,a2
    800005f2:	863e                	mv	a2,a5
    800005f4:	00000097          	auipc	ra,0x0
    800005f8:	f52080e7          	jalr	-174(ra) # 80000546 <mappages>
    800005fc:	e509                	bnez	a0,80000606 <kvmmap+0x20>
}
    800005fe:	60a2                	ld	ra,8(sp)
    80000600:	6402                	ld	s0,0(sp)
    80000602:	0141                	addi	sp,sp,16
    80000604:	8082                	ret
    panic("kvmmap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a7250513          	addi	a0,a0,-1422 # 80008078 <etext+0x78>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	70e080e7          	jalr	1806(ra) # 80005d1c <panic>

0000000080000616 <kvmmake>:
{
    80000616:	1101                	addi	sp,sp,-32
    80000618:	ec06                	sd	ra,24(sp)
    8000061a:	e822                	sd	s0,16(sp)
    8000061c:	e426                	sd	s1,8(sp)
    8000061e:	e04a                	sd	s2,0(sp)
    80000620:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000622:	00000097          	auipc	ra,0x0
    80000626:	af8080e7          	jalr	-1288(ra) # 8000011a <kalloc>
    8000062a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000062c:	6605                	lui	a2,0x1
    8000062e:	4581                	li	a1,0
    80000630:	00000097          	auipc	ra,0x0
    80000634:	b4a080e7          	jalr	-1206(ra) # 8000017a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000638:	4719                	li	a4,6
    8000063a:	6685                	lui	a3,0x1
    8000063c:	10000637          	lui	a2,0x10000
    80000640:	100005b7          	lui	a1,0x10000
    80000644:	8526                	mv	a0,s1
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	fa0080e7          	jalr	-96(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000064e:	4719                	li	a4,6
    80000650:	6685                	lui	a3,0x1
    80000652:	10001637          	lui	a2,0x10001
    80000656:	100015b7          	lui	a1,0x10001
    8000065a:	8526                	mv	a0,s1
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	f8a080e7          	jalr	-118(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	004006b7          	lui	a3,0x400
    8000066a:	0c000637          	lui	a2,0xc000
    8000066e:	0c0005b7          	lui	a1,0xc000
    80000672:	8526                	mv	a0,s1
    80000674:	00000097          	auipc	ra,0x0
    80000678:	f72080e7          	jalr	-142(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000067c:	00008917          	auipc	s2,0x8
    80000680:	98490913          	addi	s2,s2,-1660 # 80008000 <etext>
    80000684:	4729                	li	a4,10
    80000686:	80008697          	auipc	a3,0x80008
    8000068a:	97a68693          	addi	a3,a3,-1670 # 8000 <_entry-0x7fff8000>
    8000068e:	4605                	li	a2,1
    80000690:	067e                	slli	a2,a2,0x1f
    80000692:	85b2                	mv	a1,a2
    80000694:	8526                	mv	a0,s1
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	f50080e7          	jalr	-176(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000069e:	4719                	li	a4,6
    800006a0:	46c5                	li	a3,17
    800006a2:	06ee                	slli	a3,a3,0x1b
    800006a4:	412686b3          	sub	a3,a3,s2
    800006a8:	864a                	mv	a2,s2
    800006aa:	85ca                	mv	a1,s2
    800006ac:	8526                	mv	a0,s1
    800006ae:	00000097          	auipc	ra,0x0
    800006b2:	f38080e7          	jalr	-200(ra) # 800005e6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	6685                	lui	a3,0x1
    800006ba:	00007617          	auipc	a2,0x7
    800006be:	94660613          	addi	a2,a2,-1722 # 80007000 <_trampoline>
    800006c2:	040005b7          	lui	a1,0x4000
    800006c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006c8:	05b2                	slli	a1,a1,0xc
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f1a080e7          	jalr	-230(ra) # 800005e6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006d4:	8526                	mv	a0,s1
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	6f6080e7          	jalr	1782(ra) # 80000dcc <proc_mapstacks>
}
    800006de:	8526                	mv	a0,s1
    800006e0:	60e2                	ld	ra,24(sp)
    800006e2:	6442                	ld	s0,16(sp)
    800006e4:	64a2                	ld	s1,8(sp)
    800006e6:	6902                	ld	s2,0(sp)
    800006e8:	6105                	addi	sp,sp,32
    800006ea:	8082                	ret

00000000800006ec <kvminit>:
{
    800006ec:	1141                	addi	sp,sp,-16
    800006ee:	e406                	sd	ra,8(sp)
    800006f0:	e022                	sd	s0,0(sp)
    800006f2:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f22080e7          	jalr	-222(ra) # 80000616 <kvmmake>
    800006fc:	00008797          	auipc	a5,0x8
    80000700:	24a7b223          	sd	a0,580(a5) # 80008940 <kernel_pagetable>
}
    80000704:	60a2                	ld	ra,8(sp)
    80000706:	6402                	ld	s0,0(sp)
    80000708:	0141                	addi	sp,sp,16
    8000070a:	8082                	ret

000000008000070c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000070c:	715d                	addi	sp,sp,-80
    8000070e:	e486                	sd	ra,72(sp)
    80000710:	e0a2                	sd	s0,64(sp)
    80000712:	fc26                	sd	s1,56(sp)
    80000714:	f84a                	sd	s2,48(sp)
    80000716:	f44e                	sd	s3,40(sp)
    80000718:	f052                	sd	s4,32(sp)
    8000071a:	ec56                	sd	s5,24(sp)
    8000071c:	e85a                	sd	s6,16(sp)
    8000071e:	e45e                	sd	s7,8(sp)
    80000720:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000722:	03459793          	slli	a5,a1,0x34
    80000726:	e795                	bnez	a5,80000752 <uvmunmap+0x46>
    80000728:	8a2a                	mv	s4,a0
    8000072a:	892e                	mv	s2,a1
    8000072c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000072e:	0632                	slli	a2,a2,0xc
    80000730:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000734:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000736:	6b05                	lui	s6,0x1
    80000738:	0735e263          	bltu	a1,s3,8000079c <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    8000073c:	60a6                	ld	ra,72(sp)
    8000073e:	6406                	ld	s0,64(sp)
    80000740:	74e2                	ld	s1,56(sp)
    80000742:	7942                	ld	s2,48(sp)
    80000744:	79a2                	ld	s3,40(sp)
    80000746:	7a02                	ld	s4,32(sp)
    80000748:	6ae2                	ld	s5,24(sp)
    8000074a:	6b42                	ld	s6,16(sp)
    8000074c:	6ba2                	ld	s7,8(sp)
    8000074e:	6161                	addi	sp,sp,80
    80000750:	8082                	ret
    panic("uvmunmap: not aligned");
    80000752:	00008517          	auipc	a0,0x8
    80000756:	92e50513          	addi	a0,a0,-1746 # 80008080 <etext+0x80>
    8000075a:	00005097          	auipc	ra,0x5
    8000075e:	5c2080e7          	jalr	1474(ra) # 80005d1c <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	5b2080e7          	jalr	1458(ra) # 80005d1c <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	5a2080e7          	jalr	1442(ra) # 80005d1c <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	592080e7          	jalr	1426(ra) # 80005d1c <panic>
    *pte = 0;
    80000792:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000796:	995a                	add	s2,s2,s6
    80000798:	fb3972e3          	bgeu	s2,s3,8000073c <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000079c:	4601                	li	a2,0
    8000079e:	85ca                	mv	a1,s2
    800007a0:	8552                	mv	a0,s4
    800007a2:	00000097          	auipc	ra,0x0
    800007a6:	cbc080e7          	jalr	-836(ra) # 8000045e <walk>
    800007aa:	84aa                	mv	s1,a0
    800007ac:	d95d                	beqz	a0,80000762 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007ae:	6108                	ld	a0,0(a0)
    800007b0:	00157793          	andi	a5,a0,1
    800007b4:	dfdd                	beqz	a5,80000772 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007b6:	3ff57793          	andi	a5,a0,1023
    800007ba:	fd7784e3          	beq	a5,s7,80000782 <uvmunmap+0x76>
    if(do_free){
    800007be:	fc0a8ae3          	beqz	s5,80000792 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007c2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c4:	0532                	slli	a0,a0,0xc
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	856080e7          	jalr	-1962(ra) # 8000001c <kfree>
    800007ce:	b7d1                	j	80000792 <uvmunmap+0x86>

00000000800007d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d0:	1101                	addi	sp,sp,-32
    800007d2:	ec06                	sd	ra,24(sp)
    800007d4:	e822                	sd	s0,16(sp)
    800007d6:	e426                	sd	s1,8(sp)
    800007d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007da:	00000097          	auipc	ra,0x0
    800007de:	940080e7          	jalr	-1728(ra) # 8000011a <kalloc>
    800007e2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007e4:	c519                	beqz	a0,800007f2 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007e6:	6605                	lui	a2,0x1
    800007e8:	4581                	li	a1,0
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	990080e7          	jalr	-1648(ra) # 8000017a <memset>
  return pagetable;
}
    800007f2:	8526                	mv	a0,s1
    800007f4:	60e2                	ld	ra,24(sp)
    800007f6:	6442                	ld	s0,16(sp)
    800007f8:	64a2                	ld	s1,8(sp)
    800007fa:	6105                	addi	sp,sp,32
    800007fc:	8082                	ret

00000000800007fe <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007fe:	7179                	addi	sp,sp,-48
    80000800:	f406                	sd	ra,40(sp)
    80000802:	f022                	sd	s0,32(sp)
    80000804:	ec26                	sd	s1,24(sp)
    80000806:	e84a                	sd	s2,16(sp)
    80000808:	e44e                	sd	s3,8(sp)
    8000080a:	e052                	sd	s4,0(sp)
    8000080c:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000080e:	6785                	lui	a5,0x1
    80000810:	04f67863          	bgeu	a2,a5,80000860 <uvmfirst+0x62>
    80000814:	8a2a                	mv	s4,a0
    80000816:	89ae                	mv	s3,a1
    80000818:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000081a:	00000097          	auipc	ra,0x0
    8000081e:	900080e7          	jalr	-1792(ra) # 8000011a <kalloc>
    80000822:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000824:	6605                	lui	a2,0x1
    80000826:	4581                	li	a1,0
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	952080e7          	jalr	-1710(ra) # 8000017a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000830:	4779                	li	a4,30
    80000832:	86ca                	mv	a3,s2
    80000834:	6605                	lui	a2,0x1
    80000836:	4581                	li	a1,0
    80000838:	8552                	mv	a0,s4
    8000083a:	00000097          	auipc	ra,0x0
    8000083e:	d0c080e7          	jalr	-756(ra) # 80000546 <mappages>
  memmove(mem, src, sz);
    80000842:	8626                	mv	a2,s1
    80000844:	85ce                	mv	a1,s3
    80000846:	854a                	mv	a0,s2
    80000848:	00000097          	auipc	ra,0x0
    8000084c:	98e080e7          	jalr	-1650(ra) # 800001d6 <memmove>
}
    80000850:	70a2                	ld	ra,40(sp)
    80000852:	7402                	ld	s0,32(sp)
    80000854:	64e2                	ld	s1,24(sp)
    80000856:	6942                	ld	s2,16(sp)
    80000858:	69a2                	ld	s3,8(sp)
    8000085a:	6a02                	ld	s4,0(sp)
    8000085c:	6145                	addi	sp,sp,48
    8000085e:	8082                	ret
    panic("uvmfirst: more than a page");
    80000860:	00008517          	auipc	a0,0x8
    80000864:	87850513          	addi	a0,a0,-1928 # 800080d8 <etext+0xd8>
    80000868:	00005097          	auipc	ra,0x5
    8000086c:	4b4080e7          	jalr	1204(ra) # 80005d1c <panic>

0000000080000870 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000870:	1101                	addi	sp,sp,-32
    80000872:	ec06                	sd	ra,24(sp)
    80000874:	e822                	sd	s0,16(sp)
    80000876:	e426                	sd	s1,8(sp)
    80000878:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000087a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000087c:	00b67d63          	bgeu	a2,a1,80000896 <uvmdealloc+0x26>
    80000880:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000882:	6785                	lui	a5,0x1
    80000884:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000886:	00f60733          	add	a4,a2,a5
    8000088a:	76fd                	lui	a3,0xfffff
    8000088c:	8f75                	and	a4,a4,a3
    8000088e:	97ae                	add	a5,a5,a1
    80000890:	8ff5                	and	a5,a5,a3
    80000892:	00f76863          	bltu	a4,a5,800008a2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000896:	8526                	mv	a0,s1
    80000898:	60e2                	ld	ra,24(sp)
    8000089a:	6442                	ld	s0,16(sp)
    8000089c:	64a2                	ld	s1,8(sp)
    8000089e:	6105                	addi	sp,sp,32
    800008a0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a2:	8f99                	sub	a5,a5,a4
    800008a4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008a6:	4685                	li	a3,1
    800008a8:	0007861b          	sext.w	a2,a5
    800008ac:	85ba                	mv	a1,a4
    800008ae:	00000097          	auipc	ra,0x0
    800008b2:	e5e080e7          	jalr	-418(ra) # 8000070c <uvmunmap>
    800008b6:	b7c5                	j	80000896 <uvmdealloc+0x26>

00000000800008b8 <uvmalloc>:
  if(newsz < oldsz)
    800008b8:	0ab66563          	bltu	a2,a1,80000962 <uvmalloc+0xaa>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
    800008d0:	8aaa                	mv	s5,a0
    800008d2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008d4:	6785                	lui	a5,0x1
    800008d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d8:	95be                	add	a1,a1,a5
    800008da:	77fd                	lui	a5,0xfffff
    800008dc:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e0:	08c9f363          	bgeu	s3,a2,80000966 <uvmalloc+0xae>
    800008e4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008ea:	00000097          	auipc	ra,0x0
    800008ee:	830080e7          	jalr	-2000(ra) # 8000011a <kalloc>
    800008f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008f4:	c51d                	beqz	a0,80000922 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008f6:	6605                	lui	a2,0x1
    800008f8:	4581                	li	a1,0
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	880080e7          	jalr	-1920(ra) # 8000017a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000902:	875a                	mv	a4,s6
    80000904:	86a6                	mv	a3,s1
    80000906:	6605                	lui	a2,0x1
    80000908:	85ca                	mv	a1,s2
    8000090a:	8556                	mv	a0,s5
    8000090c:	00000097          	auipc	ra,0x0
    80000910:	c3a080e7          	jalr	-966(ra) # 80000546 <mappages>
    80000914:	e90d                	bnez	a0,80000946 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000916:	6785                	lui	a5,0x1
    80000918:	993e                	add	s2,s2,a5
    8000091a:	fd4968e3          	bltu	s2,s4,800008ea <uvmalloc+0x32>
  return newsz;
    8000091e:	8552                	mv	a0,s4
    80000920:	a809                	j	80000932 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000922:	864e                	mv	a2,s3
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	f48080e7          	jalr	-184(ra) # 80000870 <uvmdealloc>
      return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	70e2                	ld	ra,56(sp)
    80000934:	7442                	ld	s0,48(sp)
    80000936:	74a2                	ld	s1,40(sp)
    80000938:	7902                	ld	s2,32(sp)
    8000093a:	69e2                	ld	s3,24(sp)
    8000093c:	6a42                	ld	s4,16(sp)
    8000093e:	6aa2                	ld	s5,8(sp)
    80000940:	6b02                	ld	s6,0(sp)
    80000942:	6121                	addi	sp,sp,64
    80000944:	8082                	ret
      kfree(mem);
    80000946:	8526                	mv	a0,s1
    80000948:	fffff097          	auipc	ra,0xfffff
    8000094c:	6d4080e7          	jalr	1748(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000950:	864e                	mv	a2,s3
    80000952:	85ca                	mv	a1,s2
    80000954:	8556                	mv	a0,s5
    80000956:	00000097          	auipc	ra,0x0
    8000095a:	f1a080e7          	jalr	-230(ra) # 80000870 <uvmdealloc>
      return 0;
    8000095e:	4501                	li	a0,0
    80000960:	bfc9                	j	80000932 <uvmalloc+0x7a>
    return oldsz;
    80000962:	852e                	mv	a0,a1
}
    80000964:	8082                	ret
  return newsz;
    80000966:	8532                	mv	a0,a2
    80000968:	b7e9                	j	80000932 <uvmalloc+0x7a>

000000008000096a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000096a:	7179                	addi	sp,sp,-48
    8000096c:	f406                	sd	ra,40(sp)
    8000096e:	f022                	sd	s0,32(sp)
    80000970:	ec26                	sd	s1,24(sp)
    80000972:	e84a                	sd	s2,16(sp)
    80000974:	e44e                	sd	s3,8(sp)
    80000976:	e052                	sd	s4,0(sp)
    80000978:	1800                	addi	s0,sp,48
    8000097a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000097c:	84aa                	mv	s1,a0
    8000097e:	6905                	lui	s2,0x1
    80000980:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000982:	4985                	li	s3,1
    80000984:	a829                	j	8000099e <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000986:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000988:	00c79513          	slli	a0,a5,0xc
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	fde080e7          	jalr	-34(ra) # 8000096a <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000998:	04a1                	addi	s1,s1,8
    8000099a:	03248163          	beq	s1,s2,800009bc <freewalk+0x52>
    pte_t pte = pagetable[i];
    8000099e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a0:	00f7f713          	andi	a4,a5,15
    800009a4:	ff3701e3          	beq	a4,s3,80000986 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009a8:	8b85                	andi	a5,a5,1
    800009aa:	d7fd                	beqz	a5,80000998 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ac:	00007517          	auipc	a0,0x7
    800009b0:	74c50513          	addi	a0,a0,1868 # 800080f8 <etext+0xf8>
    800009b4:	00005097          	auipc	ra,0x5
    800009b8:	368080e7          	jalr	872(ra) # 80005d1c <panic>
    }
  }
  kfree((void*)pagetable);
    800009bc:	8552                	mv	a0,s4
    800009be:	fffff097          	auipc	ra,0xfffff
    800009c2:	65e080e7          	jalr	1630(ra) # 8000001c <kfree>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret

00000000800009d6 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	1000                	addi	s0,sp,32
    800009e0:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e2:	e999                	bnez	a1,800009f8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e4:	8526                	mv	a0,s1
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	f84080e7          	jalr	-124(ra) # 8000096a <freewalk>
}
    800009ee:	60e2                	ld	ra,24(sp)
    800009f0:	6442                	ld	s0,16(sp)
    800009f2:	64a2                	ld	s1,8(sp)
    800009f4:	6105                	addi	sp,sp,32
    800009f6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009f8:	6785                	lui	a5,0x1
    800009fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009fc:	95be                	add	a1,a1,a5
    800009fe:	4685                	li	a3,1
    80000a00:	00c5d613          	srli	a2,a1,0xc
    80000a04:	4581                	li	a1,0
    80000a06:	00000097          	auipc	ra,0x0
    80000a0a:	d06080e7          	jalr	-762(ra) # 8000070c <uvmunmap>
    80000a0e:	bfd9                	j	800009e4 <uvmfree+0xe>

0000000080000a10 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a10:	c679                	beqz	a2,80000ade <uvmcopy+0xce>
{
    80000a12:	715d                	addi	sp,sp,-80
    80000a14:	e486                	sd	ra,72(sp)
    80000a16:	e0a2                	sd	s0,64(sp)
    80000a18:	fc26                	sd	s1,56(sp)
    80000a1a:	f84a                	sd	s2,48(sp)
    80000a1c:	f44e                	sd	s3,40(sp)
    80000a1e:	f052                	sd	s4,32(sp)
    80000a20:	ec56                	sd	s5,24(sp)
    80000a22:	e85a                	sd	s6,16(sp)
    80000a24:	e45e                	sd	s7,8(sp)
    80000a26:	0880                	addi	s0,sp,80
    80000a28:	8b2a                	mv	s6,a0
    80000a2a:	8aae                	mv	s5,a1
    80000a2c:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a2e:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a30:	4601                	li	a2,0
    80000a32:	85ce                	mv	a1,s3
    80000a34:	855a                	mv	a0,s6
    80000a36:	00000097          	auipc	ra,0x0
    80000a3a:	a28080e7          	jalr	-1496(ra) # 8000045e <walk>
    80000a3e:	c531                	beqz	a0,80000a8a <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a40:	6118                	ld	a4,0(a0)
    80000a42:	00177793          	andi	a5,a4,1
    80000a46:	cbb1                	beqz	a5,80000a9a <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a48:	00a75593          	srli	a1,a4,0xa
    80000a4c:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a50:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a54:	fffff097          	auipc	ra,0xfffff
    80000a58:	6c6080e7          	jalr	1734(ra) # 8000011a <kalloc>
    80000a5c:	892a                	mv	s2,a0
    80000a5e:	c939                	beqz	a0,80000ab4 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a60:	6605                	lui	a2,0x1
    80000a62:	85de                	mv	a1,s7
    80000a64:	fffff097          	auipc	ra,0xfffff
    80000a68:	772080e7          	jalr	1906(ra) # 800001d6 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6c:	8726                	mv	a4,s1
    80000a6e:	86ca                	mv	a3,s2
    80000a70:	6605                	lui	a2,0x1
    80000a72:	85ce                	mv	a1,s3
    80000a74:	8556                	mv	a0,s5
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	ad0080e7          	jalr	-1328(ra) # 80000546 <mappages>
    80000a7e:	e515                	bnez	a0,80000aaa <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a80:	6785                	lui	a5,0x1
    80000a82:	99be                	add	s3,s3,a5
    80000a84:	fb49e6e3          	bltu	s3,s4,80000a30 <uvmcopy+0x20>
    80000a88:	a081                	j	80000ac8 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	67e50513          	addi	a0,a0,1662 # 80008108 <etext+0x108>
    80000a92:	00005097          	auipc	ra,0x5
    80000a96:	28a080e7          	jalr	650(ra) # 80005d1c <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	27a080e7          	jalr	634(ra) # 80005d1c <panic>
      kfree(mem);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	fffff097          	auipc	ra,0xfffff
    80000ab0:	570080e7          	jalr	1392(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab4:	4685                	li	a3,1
    80000ab6:	00c9d613          	srli	a2,s3,0xc
    80000aba:	4581                	li	a1,0
    80000abc:	8556                	mv	a0,s5
    80000abe:	00000097          	auipc	ra,0x0
    80000ac2:	c4e080e7          	jalr	-946(ra) # 8000070c <uvmunmap>
  return -1;
    80000ac6:	557d                	li	a0,-1
}
    80000ac8:	60a6                	ld	ra,72(sp)
    80000aca:	6406                	ld	s0,64(sp)
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	7a02                	ld	s4,32(sp)
    80000ad4:	6ae2                	ld	s5,24(sp)
    80000ad6:	6b42                	ld	s6,16(sp)
    80000ad8:	6ba2                	ld	s7,8(sp)
    80000ada:	6161                	addi	sp,sp,80
    80000adc:	8082                	ret
  return 0;
    80000ade:	4501                	li	a0,0
}
    80000ae0:	8082                	ret

0000000080000ae2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	00000097          	auipc	ra,0x0
    80000af0:	972080e7          	jalr	-1678(ra) # 8000045e <walk>
  if(pte == 0)
    80000af4:	c901                	beqz	a0,80000b04 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af6:	611c                	ld	a5,0(a0)
    80000af8:	9bbd                	andi	a5,a5,-17
    80000afa:	e11c                	sd	a5,0(a0)
}
    80000afc:	60a2                	ld	ra,8(sp)
    80000afe:	6402                	ld	s0,0(sp)
    80000b00:	0141                	addi	sp,sp,16
    80000b02:	8082                	ret
    panic("uvmclear");
    80000b04:	00007517          	auipc	a0,0x7
    80000b08:	64450513          	addi	a0,a0,1604 # 80008148 <etext+0x148>
    80000b0c:	00005097          	auipc	ra,0x5
    80000b10:	210080e7          	jalr	528(ra) # 80005d1c <panic>

0000000080000b14 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b14:	c6bd                	beqz	a3,80000b82 <copyout+0x6e>
{
    80000b16:	715d                	addi	sp,sp,-80
    80000b18:	e486                	sd	ra,72(sp)
    80000b1a:	e0a2                	sd	s0,64(sp)
    80000b1c:	fc26                	sd	s1,56(sp)
    80000b1e:	f84a                	sd	s2,48(sp)
    80000b20:	f44e                	sd	s3,40(sp)
    80000b22:	f052                	sd	s4,32(sp)
    80000b24:	ec56                	sd	s5,24(sp)
    80000b26:	e85a                	sd	s6,16(sp)
    80000b28:	e45e                	sd	s7,8(sp)
    80000b2a:	e062                	sd	s8,0(sp)
    80000b2c:	0880                	addi	s0,sp,80
    80000b2e:	8b2a                	mv	s6,a0
    80000b30:	8c2e                	mv	s8,a1
    80000b32:	8a32                	mv	s4,a2
    80000b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b36:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b38:	6a85                	lui	s5,0x1
    80000b3a:	a015                	j	80000b5e <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3c:	9562                	add	a0,a0,s8
    80000b3e:	0004861b          	sext.w	a2,s1
    80000b42:	85d2                	mv	a1,s4
    80000b44:	41250533          	sub	a0,a0,s2
    80000b48:	fffff097          	auipc	ra,0xfffff
    80000b4c:	68e080e7          	jalr	1678(ra) # 800001d6 <memmove>

    len -= n;
    80000b50:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b54:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b56:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5a:	02098263          	beqz	s3,80000b7e <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b62:	85ca                	mv	a1,s2
    80000b64:	855a                	mv	a0,s6
    80000b66:	00000097          	auipc	ra,0x0
    80000b6a:	99e080e7          	jalr	-1634(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000b6e:	cd01                	beqz	a0,80000b86 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b70:	418904b3          	sub	s1,s2,s8
    80000b74:	94d6                	add	s1,s1,s5
    80000b76:	fc99f3e3          	bgeu	s3,s1,80000b3c <copyout+0x28>
    80000b7a:	84ce                	mv	s1,s3
    80000b7c:	b7c1                	j	80000b3c <copyout+0x28>
  }
  return 0;
    80000b7e:	4501                	li	a0,0
    80000b80:	a021                	j	80000b88 <copyout+0x74>
    80000b82:	4501                	li	a0,0
}
    80000b84:	8082                	ret
      return -1;
    80000b86:	557d                	li	a0,-1
}
    80000b88:	60a6                	ld	ra,72(sp)
    80000b8a:	6406                	ld	s0,64(sp)
    80000b8c:	74e2                	ld	s1,56(sp)
    80000b8e:	7942                	ld	s2,48(sp)
    80000b90:	79a2                	ld	s3,40(sp)
    80000b92:	7a02                	ld	s4,32(sp)
    80000b94:	6ae2                	ld	s5,24(sp)
    80000b96:	6b42                	ld	s6,16(sp)
    80000b98:	6ba2                	ld	s7,8(sp)
    80000b9a:	6c02                	ld	s8,0(sp)
    80000b9c:	6161                	addi	sp,sp,80
    80000b9e:	8082                	ret

0000000080000ba0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba0:	caa5                	beqz	a3,80000c10 <copyin+0x70>
{
    80000ba2:	715d                	addi	sp,sp,-80
    80000ba4:	e486                	sd	ra,72(sp)
    80000ba6:	e0a2                	sd	s0,64(sp)
    80000ba8:	fc26                	sd	s1,56(sp)
    80000baa:	f84a                	sd	s2,48(sp)
    80000bac:	f44e                	sd	s3,40(sp)
    80000bae:	f052                	sd	s4,32(sp)
    80000bb0:	ec56                	sd	s5,24(sp)
    80000bb2:	e85a                	sd	s6,16(sp)
    80000bb4:	e45e                	sd	s7,8(sp)
    80000bb6:	e062                	sd	s8,0(sp)
    80000bb8:	0880                	addi	s0,sp,80
    80000bba:	8b2a                	mv	s6,a0
    80000bbc:	8a2e                	mv	s4,a1
    80000bbe:	8c32                	mv	s8,a2
    80000bc0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc4:	6a85                	lui	s5,0x1
    80000bc6:	a01d                	j	80000bec <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bc8:	018505b3          	add	a1,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412585b3          	sub	a1,a1,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	600080e7          	jalr	1536(ra) # 800001d6 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	910080e7          	jalr	-1776(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    80000c04:	fc99f2e3          	bgeu	s3,s1,80000bc8 <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	bf7d                	j	80000bc8 <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x76>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c2dd                	beqz	a3,80000cd4 <copyinstr+0xa6>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a02d                	j	80000c7c <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	37fd                	addiw	a5,a5,-1
    80000c5c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c60:	60a6                	ld	ra,72(sp)
    80000c62:	6406                	ld	s0,64(sp)
    80000c64:	74e2                	ld	s1,56(sp)
    80000c66:	7942                	ld	s2,48(sp)
    80000c68:	79a2                	ld	s3,40(sp)
    80000c6a:	7a02                	ld	s4,32(sp)
    80000c6c:	6ae2                	ld	s5,24(sp)
    80000c6e:	6b42                	ld	s6,16(sp)
    80000c70:	6ba2                	ld	s7,8(sp)
    80000c72:	6161                	addi	sp,sp,80
    80000c74:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c76:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7a:	c8a9                	beqz	s1,80000ccc <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000c7c:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c80:	85ca                	mv	a1,s2
    80000c82:	8552                	mv	a0,s4
    80000c84:	00000097          	auipc	ra,0x0
    80000c88:	880080e7          	jalr	-1920(ra) # 80000504 <walkaddr>
    if(pa0 == 0)
    80000c8c:	c131                	beqz	a0,80000cd0 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000c8e:	417906b3          	sub	a3,s2,s7
    80000c92:	96ce                	add	a3,a3,s3
    80000c94:	00d4f363          	bgeu	s1,a3,80000c9a <copyinstr+0x6c>
    80000c98:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9a:	955e                	add	a0,a0,s7
    80000c9c:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca0:	daf9                	beqz	a3,80000c76 <copyinstr+0x48>
    80000ca2:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ca4:	41650633          	sub	a2,a0,s6
    80000ca8:	fff48593          	addi	a1,s1,-1
    80000cac:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cae:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cb0:	00f60733          	add	a4,a2,a5
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdd020>
    80000cb8:	df51                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cba:	00e78023          	sb	a4,0(a5)
      --max;
    80000cbe:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000cc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc4:	fed796e3          	bne	a5,a3,80000cb0 <copyinstr+0x82>
      dst++;
    80000cc8:	8b3e                	mv	s6,a5
    80000cca:	b775                	j	80000c76 <copyinstr+0x48>
    80000ccc:	4781                	li	a5,0
    80000cce:	b771                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd0:	557d                	li	a0,-1
    80000cd2:	b779                	j	80000c60 <copyinstr+0x32>
  int got_null = 0;
    80000cd4:	4781                	li	a5,0
  if(got_null){
    80000cd6:	37fd                	addiw	a5,a5,-1
    80000cd8:	0007851b          	sext.w	a0,a5
}
    80000cdc:	8082                	ret

0000000080000cde <vmprint>:

int printInside = 0;

void
vmprint(pagetable_t pagetable)
{
    80000cde:	711d                	addi	sp,sp,-96
    80000ce0:	ec86                	sd	ra,88(sp)
    80000ce2:	e8a2                	sd	s0,80(sp)
    80000ce4:	e4a6                	sd	s1,72(sp)
    80000ce6:	e0ca                	sd	s2,64(sp)
    80000ce8:	fc4e                	sd	s3,56(sp)
    80000cea:	f852                	sd	s4,48(sp)
    80000cec:	f456                	sd	s5,40(sp)
    80000cee:	f05a                	sd	s6,32(sp)
    80000cf0:	ec5e                	sd	s7,24(sp)
    80000cf2:	e862                	sd	s8,16(sp)
    80000cf4:	e466                	sd	s9,8(sp)
    80000cf6:	e06a                	sd	s10,0(sp)
    80000cf8:	1080                	addi	s0,sp,96
    80000cfa:	8a2a                	mv	s4,a0
  if (printInside == 0)
    80000cfc:	00008797          	auipc	a5,0x8
    80000d00:	c3c7a783          	lw	a5,-964(a5) # 80008938 <printInside>
    80000d04:	c39d                	beqz	a5,80000d2a <vmprint+0x4c>
{
    80000d06:	4981                	li	s3,0
    printf("page table %p\n", (uint64)pagetable);
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      for (int j = 0; j <= printInside; j++) {
    80000d08:	00008a97          	auipc	s5,0x8
    80000d0c:	c30a8a93          	addi	s5,s5,-976 # 80008938 <printInside>
        printf(".. ");
      }
      printf("%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    80000d10:	00007c97          	auipc	s9,0x7
    80000d14:	460c8c93          	addi	s9,s9,1120 # 80008170 <etext+0x170>
      for (int j = 0; j <= printInside; j++) {
    80000d18:	4d01                	li	s10,0
        printf(".. ");
    80000d1a:	00007b17          	auipc	s6,0x7
    80000d1e:	44eb0b13          	addi	s6,s6,1102 # 80008168 <etext+0x168>
    }
    // pintes to lower-level page table
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d22:	4c05                	li	s8,1
  for (int i = 0; i < 512; i++) {
    80000d24:	20000b93          	li	s7,512
    80000d28:	a82d                	j	80000d62 <vmprint+0x84>
    printf("page table %p\n", (uint64)pagetable);
    80000d2a:	85aa                	mv	a1,a0
    80000d2c:	00007517          	auipc	a0,0x7
    80000d30:	42c50513          	addi	a0,a0,1068 # 80008158 <etext+0x158>
    80000d34:	00005097          	auipc	ra,0x5
    80000d38:	032080e7          	jalr	50(ra) # 80005d66 <printf>
    80000d3c:	b7e9                	j	80000d06 <vmprint+0x28>
      printf("%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    80000d3e:	00a95693          	srli	a3,s2,0xa
    80000d42:	06b2                	slli	a3,a3,0xc
    80000d44:	864a                	mv	a2,s2
    80000d46:	85ce                	mv	a1,s3
    80000d48:	8566                	mv	a0,s9
    80000d4a:	00005097          	auipc	ra,0x5
    80000d4e:	01c080e7          	jalr	28(ra) # 80005d66 <printf>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d52:	00f97793          	andi	a5,s2,15
    80000d56:	03878b63          	beq	a5,s8,80000d8c <vmprint+0xae>
  for (int i = 0; i < 512; i++) {
    80000d5a:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d5c:	0a21                	addi	s4,s4,8
    80000d5e:	05798963          	beq	s3,s7,80000db0 <vmprint+0xd2>
    pte_t pte = pagetable[i];
    80000d62:	000a3903          	ld	s2,0(s4)
    if (pte & PTE_V) {
    80000d66:	00197793          	andi	a5,s2,1
    80000d6a:	d7e5                	beqz	a5,80000d52 <vmprint+0x74>
      for (int j = 0; j <= printInside; j++) {
    80000d6c:	000aa783          	lw	a5,0(s5)
    80000d70:	fc07c7e3          	bltz	a5,80000d3e <vmprint+0x60>
    80000d74:	84ea                	mv	s1,s10
        printf(".. ");
    80000d76:	855a                	mv	a0,s6
    80000d78:	00005097          	auipc	ra,0x5
    80000d7c:	fee080e7          	jalr	-18(ra) # 80005d66 <printf>
      for (int j = 0; j <= printInside; j++) {
    80000d80:	2485                	addiw	s1,s1,1
    80000d82:	000aa783          	lw	a5,0(s5)
    80000d86:	fe97d8e3          	bge	a5,s1,80000d76 <vmprint+0x98>
    80000d8a:	bf55                	j	80000d3e <vmprint+0x60>
      printInside++;
    80000d8c:	000aa783          	lw	a5,0(s5)
    80000d90:	2785                	addiw	a5,a5,1
    80000d92:	00faa023          	sw	a5,0(s5)
      uint64 child_pa = PTE2PA(pte);
    80000d96:	00a95513          	srli	a0,s2,0xa
      vmprint((pagetable_t)child_pa);
    80000d9a:	0532                	slli	a0,a0,0xc
    80000d9c:	00000097          	auipc	ra,0x0
    80000da0:	f42080e7          	jalr	-190(ra) # 80000cde <vmprint>
      printInside--;
    80000da4:	000aa783          	lw	a5,0(s5)
    80000da8:	37fd                	addiw	a5,a5,-1
    80000daa:	00faa023          	sw	a5,0(s5)
    80000dae:	b775                	j	80000d5a <vmprint+0x7c>
    }
  }
}
    80000db0:	60e6                	ld	ra,88(sp)
    80000db2:	6446                	ld	s0,80(sp)
    80000db4:	64a6                	ld	s1,72(sp)
    80000db6:	6906                	ld	s2,64(sp)
    80000db8:	79e2                	ld	s3,56(sp)
    80000dba:	7a42                	ld	s4,48(sp)
    80000dbc:	7aa2                	ld	s5,40(sp)
    80000dbe:	7b02                	ld	s6,32(sp)
    80000dc0:	6be2                	ld	s7,24(sp)
    80000dc2:	6c42                	ld	s8,16(sp)
    80000dc4:	6ca2                	ld	s9,8(sp)
    80000dc6:	6d02                	ld	s10,0(sp)
    80000dc8:	6125                	addi	sp,sp,96
    80000dca:	8082                	ret

0000000080000dcc <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dcc:	7139                	addi	sp,sp,-64
    80000dce:	fc06                	sd	ra,56(sp)
    80000dd0:	f822                	sd	s0,48(sp)
    80000dd2:	f426                	sd	s1,40(sp)
    80000dd4:	f04a                	sd	s2,32(sp)
    80000dd6:	ec4e                	sd	s3,24(sp)
    80000dd8:	e852                	sd	s4,16(sp)
    80000dda:	e456                	sd	s5,8(sp)
    80000ddc:	e05a                	sd	s6,0(sp)
    80000dde:	0080                	addi	s0,sp,64
    80000de0:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de2:	00008497          	auipc	s1,0x8
    80000de6:	fde48493          	addi	s1,s1,-34 # 80008dc0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000dea:	8b26                	mv	s6,s1
    80000dec:	00007a97          	auipc	s5,0x7
    80000df0:	214a8a93          	addi	s5,s5,532 # 80008000 <etext>
    80000df4:	01000937          	lui	s2,0x1000
    80000df8:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000dfa:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfc:	0000ea17          	auipc	s4,0xe
    80000e00:	bc4a0a13          	addi	s4,s4,-1084 # 8000e9c0 <tickslock>
    char *pa = kalloc();
    80000e04:	fffff097          	auipc	ra,0xfffff
    80000e08:	316080e7          	jalr	790(ra) # 8000011a <kalloc>
    80000e0c:	862a                	mv	a2,a0
    if(pa == 0)
    80000e0e:	c129                	beqz	a0,80000e50 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e10:	416485b3          	sub	a1,s1,s6
    80000e14:	8591                	srai	a1,a1,0x4
    80000e16:	000ab783          	ld	a5,0(s5)
    80000e1a:	02f585b3          	mul	a1,a1,a5
    80000e1e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e22:	4719                	li	a4,6
    80000e24:	6685                	lui	a3,0x1
    80000e26:	40b905b3          	sub	a1,s2,a1
    80000e2a:	854e                	mv	a0,s3
    80000e2c:	fffff097          	auipc	ra,0xfffff
    80000e30:	7ba080e7          	jalr	1978(ra) # 800005e6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	17048493          	addi	s1,s1,368
    80000e38:	fd4496e3          	bne	s1,s4,80000e04 <proc_mapstacks+0x38>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret
      panic("kalloc");
    80000e50:	00007517          	auipc	a0,0x7
    80000e54:	33850513          	addi	a0,a0,824 # 80008188 <etext+0x188>
    80000e58:	00005097          	auipc	ra,0x5
    80000e5c:	ec4080e7          	jalr	-316(ra) # 80005d1c <panic>

0000000080000e60 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e60:	7139                	addi	sp,sp,-64
    80000e62:	fc06                	sd	ra,56(sp)
    80000e64:	f822                	sd	s0,48(sp)
    80000e66:	f426                	sd	s1,40(sp)
    80000e68:	f04a                	sd	s2,32(sp)
    80000e6a:	ec4e                	sd	s3,24(sp)
    80000e6c:	e852                	sd	s4,16(sp)
    80000e6e:	e456                	sd	s5,8(sp)
    80000e70:	e05a                	sd	s6,0(sp)
    80000e72:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e74:	00007597          	auipc	a1,0x7
    80000e78:	31c58593          	addi	a1,a1,796 # 80008190 <etext+0x190>
    80000e7c:	00008517          	auipc	a0,0x8
    80000e80:	b1450513          	addi	a0,a0,-1260 # 80008990 <pid_lock>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	340080e7          	jalr	832(ra) # 800061c4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	30c58593          	addi	a1,a1,780 # 80008198 <etext+0x198>
    80000e94:	00008517          	auipc	a0,0x8
    80000e98:	b1450513          	addi	a0,a0,-1260 # 800089a8 <wait_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	328080e7          	jalr	808(ra) # 800061c4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea4:	00008497          	auipc	s1,0x8
    80000ea8:	f1c48493          	addi	s1,s1,-228 # 80008dc0 <proc>
      initlock(&p->lock, "proc");
    80000eac:	00007b17          	auipc	s6,0x7
    80000eb0:	2fcb0b13          	addi	s6,s6,764 # 800081a8 <etext+0x1a8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eb4:	8aa6                	mv	s5,s1
    80000eb6:	00007a17          	auipc	s4,0x7
    80000eba:	14aa0a13          	addi	s4,s4,330 # 80008000 <etext>
    80000ebe:	01000937          	lui	s2,0x1000
    80000ec2:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000ec4:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ec6:	0000e997          	auipc	s3,0xe
    80000eca:	afa98993          	addi	s3,s3,-1286 # 8000e9c0 <tickslock>
      initlock(&p->lock, "proc");
    80000ece:	85da                	mv	a1,s6
    80000ed0:	8526                	mv	a0,s1
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	2f2080e7          	jalr	754(ra) # 800061c4 <initlock>
      p->state = UNUSED;
    80000eda:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ede:	415487b3          	sub	a5,s1,s5
    80000ee2:	8791                	srai	a5,a5,0x4
    80000ee4:	000a3703          	ld	a4,0(s4)
    80000ee8:	02e787b3          	mul	a5,a5,a4
    80000eec:	00d7979b          	slliw	a5,a5,0xd
    80000ef0:	40f907b3          	sub	a5,s2,a5
    80000ef4:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef6:	17048493          	addi	s1,s1,368
    80000efa:	fd349ae3          	bne	s1,s3,80000ece <procinit+0x6e>
  }
}
    80000efe:	70e2                	ld	ra,56(sp)
    80000f00:	7442                	ld	s0,48(sp)
    80000f02:	74a2                	ld	s1,40(sp)
    80000f04:	7902                	ld	s2,32(sp)
    80000f06:	69e2                	ld	s3,24(sp)
    80000f08:	6a42                	ld	s4,16(sp)
    80000f0a:	6aa2                	ld	s5,8(sp)
    80000f0c:	6b02                	ld	s6,0(sp)
    80000f0e:	6121                	addi	sp,sp,64
    80000f10:	8082                	ret

0000000080000f12 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f12:	1141                	addi	sp,sp,-16
    80000f14:	e422                	sd	s0,8(sp)
    80000f16:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f18:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f1a:	2501                	sext.w	a0,a0
    80000f1c:	6422                	ld	s0,8(sp)
    80000f1e:	0141                	addi	sp,sp,16
    80000f20:	8082                	ret

0000000080000f22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
    80000f28:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f2e:	00008517          	auipc	a0,0x8
    80000f32:	a9250513          	addi	a0,a0,-1390 # 800089c0 <cpus>
    80000f36:	953e                	add	a0,a0,a5
    80000f38:	6422                	ld	s0,8(sp)
    80000f3a:	0141                	addi	sp,sp,16
    80000f3c:	8082                	ret

0000000080000f3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f3e:	1101                	addi	sp,sp,-32
    80000f40:	ec06                	sd	ra,24(sp)
    80000f42:	e822                	sd	s0,16(sp)
    80000f44:	e426                	sd	s1,8(sp)
    80000f46:	1000                	addi	s0,sp,32
  push_off();
    80000f48:	00005097          	auipc	ra,0x5
    80000f4c:	2c0080e7          	jalr	704(ra) # 80006208 <push_off>
    80000f50:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	a3a70713          	addi	a4,a4,-1478 # 80008990 <pid_lock>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	346080e7          	jalr	838(ra) # 800062a8 <pop_off>
  return p;
}
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	60e2                	ld	ra,24(sp)
    80000f6e:	6442                	ld	s0,16(sp)
    80000f70:	64a2                	ld	s1,8(sp)
    80000f72:	6105                	addi	sp,sp,32
    80000f74:	8082                	ret

0000000080000f76 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f76:	1141                	addi	sp,sp,-16
    80000f78:	e406                	sd	ra,8(sp)
    80000f7a:	e022                	sd	s0,0(sp)
    80000f7c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f7e:	00000097          	auipc	ra,0x0
    80000f82:	fc0080e7          	jalr	-64(ra) # 80000f3e <myproc>
    80000f86:	00005097          	auipc	ra,0x5
    80000f8a:	382080e7          	jalr	898(ra) # 80006308 <release>

  if (first) {
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	9327a783          	lw	a5,-1742(a5) # 800088c0 <first.1>
    80000f96:	eb89                	bnez	a5,80000fa8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f98:	00001097          	auipc	ra,0x1
    80000f9c:	cda080e7          	jalr	-806(ra) # 80001c72 <usertrapret>
}
    80000fa0:	60a2                	ld	ra,8(sp)
    80000fa2:	6402                	ld	s0,0(sp)
    80000fa4:	0141                	addi	sp,sp,16
    80000fa6:	8082                	ret
    first = 0;
    80000fa8:	00008797          	auipc	a5,0x8
    80000fac:	9007ac23          	sw	zero,-1768(a5) # 800088c0 <first.1>
    fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	a1a080e7          	jalr	-1510(ra) # 800029cc <fsinit>
    80000fba:	bff9                	j	80000f98 <forkret+0x22>

0000000080000fbc <allocpid>:
{
    80000fbc:	1101                	addi	sp,sp,-32
    80000fbe:	ec06                	sd	ra,24(sp)
    80000fc0:	e822                	sd	s0,16(sp)
    80000fc2:	e426                	sd	s1,8(sp)
    80000fc4:	e04a                	sd	s2,0(sp)
    80000fc6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fc8:	00008917          	auipc	s2,0x8
    80000fcc:	9c890913          	addi	s2,s2,-1592 # 80008990 <pid_lock>
    80000fd0:	854a                	mv	a0,s2
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	282080e7          	jalr	642(ra) # 80006254 <acquire>
  pid = nextpid;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	8ea78793          	addi	a5,a5,-1814 # 800088c4 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe4:	0014871b          	addiw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	31c080e7          	jalr	796(ra) # 80006308 <release>
}
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	60e2                	ld	ra,24(sp)
    80000ff8:	6442                	ld	s0,16(sp)
    80000ffa:	64a2                	ld	s1,8(sp)
    80000ffc:	6902                	ld	s2,0(sp)
    80000ffe:	6105                	addi	sp,sp,32
    80001000:	8082                	ret

0000000080001002 <proc_pagetable>:
{
    80001002:	1101                	addi	sp,sp,-32
    80001004:	ec06                	sd	ra,24(sp)
    80001006:	e822                	sd	s0,16(sp)
    80001008:	e426                	sd	s1,8(sp)
    8000100a:	e04a                	sd	s2,0(sp)
    8000100c:	1000                	addi	s0,sp,32
    8000100e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	7c0080e7          	jalr	1984(ra) # 800007d0 <uvmcreate>
    80001018:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000101a:	cd39                	beqz	a0,80001078 <proc_pagetable+0x76>
  if (mappages(pagetable, USYSCALL, PGSIZE, 
    8000101c:	4759                	li	a4,22
    8000101e:	01893683          	ld	a3,24(s2)
    80001022:	6605                	lui	a2,0x1
    80001024:	040005b7          	lui	a1,0x4000
    80001028:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000102a:	05b2                	slli	a1,a1,0xc
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	51a080e7          	jalr	1306(ra) # 80000546 <mappages>
    80001034:	04054963          	bltz	a0,80001086 <proc_pagetable+0x84>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001038:	4729                	li	a4,10
    8000103a:	00006697          	auipc	a3,0x6
    8000103e:	fc668693          	addi	a3,a3,-58 # 80007000 <_trampoline>
    80001042:	6605                	lui	a2,0x1
    80001044:	040005b7          	lui	a1,0x4000
    80001048:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000104a:	05b2                	slli	a1,a1,0xc
    8000104c:	8526                	mv	a0,s1
    8000104e:	fffff097          	auipc	ra,0xfffff
    80001052:	4f8080e7          	jalr	1272(ra) # 80000546 <mappages>
    80001056:	04054063          	bltz	a0,80001096 <proc_pagetable+0x94>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000105a:	4719                	li	a4,6
    8000105c:	06093683          	ld	a3,96(s2)
    80001060:	6605                	lui	a2,0x1
    80001062:	020005b7          	lui	a1,0x2000
    80001066:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001068:	05b6                	slli	a1,a1,0xd
    8000106a:	8526                	mv	a0,s1
    8000106c:	fffff097          	auipc	ra,0xfffff
    80001070:	4da080e7          	jalr	1242(ra) # 80000546 <mappages>
    80001074:	02054963          	bltz	a0,800010a6 <proc_pagetable+0xa4>
}
    80001078:	8526                	mv	a0,s1
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6902                	ld	s2,0(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret
    uvmfree(pagetable, 0);
    80001086:	4581                	li	a1,0
    80001088:	8526                	mv	a0,s1
    8000108a:	00000097          	auipc	ra,0x0
    8000108e:	94c080e7          	jalr	-1716(ra) # 800009d6 <uvmfree>
    return 0;
    80001092:	4481                	li	s1,0
    80001094:	b7d5                	j	80001078 <proc_pagetable+0x76>
    uvmfree(pagetable, 0);
    80001096:	4581                	li	a1,0
    80001098:	8526                	mv	a0,s1
    8000109a:	00000097          	auipc	ra,0x0
    8000109e:	93c080e7          	jalr	-1732(ra) # 800009d6 <uvmfree>
    return 0;
    800010a2:	4481                	li	s1,0
    800010a4:	bfd1                	j	80001078 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010a6:	4681                	li	a3,0
    800010a8:	4605                	li	a2,1
    800010aa:	040005b7          	lui	a1,0x4000
    800010ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010b0:	05b2                	slli	a1,a1,0xc
    800010b2:	8526                	mv	a0,s1
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	658080e7          	jalr	1624(ra) # 8000070c <uvmunmap>
    uvmfree(pagetable, 0);
    800010bc:	4581                	li	a1,0
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	916080e7          	jalr	-1770(ra) # 800009d6 <uvmfree>
    return 0;
    800010c8:	4481                	li	s1,0
    800010ca:	b77d                	j	80001078 <proc_pagetable+0x76>

00000000800010cc <proc_freepagetable>:
{
    800010cc:	7179                	addi	sp,sp,-48
    800010ce:	f406                	sd	ra,40(sp)
    800010d0:	f022                	sd	s0,32(sp)
    800010d2:	ec26                	sd	s1,24(sp)
    800010d4:	e84a                	sd	s2,16(sp)
    800010d6:	e44e                	sd	s3,8(sp)
    800010d8:	1800                	addi	s0,sp,48
    800010da:	84aa                	mv	s1,a0
    800010dc:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	04000937          	lui	s2,0x4000
    800010e6:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    800010ea:	05b2                	slli	a1,a1,0xc
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	620080e7          	jalr	1568(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010f4:	4681                	li	a3,0
    800010f6:	4605                	li	a2,1
    800010f8:	020005b7          	lui	a1,0x2000
    800010fc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800010fe:	05b6                	slli	a1,a1,0xd
    80001100:	8526                	mv	a0,s1
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	60a080e7          	jalr	1546(ra) # 8000070c <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000110a:	4681                	li	a3,0
    8000110c:	4605                	li	a2,1
    8000110e:	1975                	addi	s2,s2,-3
    80001110:	00c91593          	slli	a1,s2,0xc
    80001114:	8526                	mv	a0,s1
    80001116:	fffff097          	auipc	ra,0xfffff
    8000111a:	5f6080e7          	jalr	1526(ra) # 8000070c <uvmunmap>
  uvmfree(pagetable, sz);
    8000111e:	85ce                	mv	a1,s3
    80001120:	8526                	mv	a0,s1
    80001122:	00000097          	auipc	ra,0x0
    80001126:	8b4080e7          	jalr	-1868(ra) # 800009d6 <uvmfree>
}
    8000112a:	70a2                	ld	ra,40(sp)
    8000112c:	7402                	ld	s0,32(sp)
    8000112e:	64e2                	ld	s1,24(sp)
    80001130:	6942                	ld	s2,16(sp)
    80001132:	69a2                	ld	s3,8(sp)
    80001134:	6145                	addi	sp,sp,48
    80001136:	8082                	ret

0000000080001138 <freeproc>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	1000                	addi	s0,sp,32
    80001142:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001144:	7128                	ld	a0,96(a0)
    80001146:	c509                	beqz	a0,80001150 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	ed4080e7          	jalr	-300(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001150:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001154:	6ca8                	ld	a0,88(s1)
    80001156:	c511                	beqz	a0,80001162 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001158:	68ac                	ld	a1,80(s1)
    8000115a:	00000097          	auipc	ra,0x0
    8000115e:	f72080e7          	jalr	-142(ra) # 800010cc <proc_freepagetable>
  if (p->usyscallPage)
    80001162:	6c88                	ld	a0,24(s1)
    80001164:	c509                	beqz	a0,8000116e <freeproc+0x36>
    kfree(p->usyscallPage);
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	eb6080e7          	jalr	-330(ra) # 8000001c <kfree>
  p->pagetable = 0;
    8000116e:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001172:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001176:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000117a:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    8000117e:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001182:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001186:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000118a:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    8000118e:	0204a023          	sw	zero,32(s1)
}
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6105                	addi	sp,sp,32
    8000119a:	8082                	ret

000000008000119c <allocproc>:
{
    8000119c:	1101                	addi	sp,sp,-32
    8000119e:	ec06                	sd	ra,24(sp)
    800011a0:	e822                	sd	s0,16(sp)
    800011a2:	e426                	sd	s1,8(sp)
    800011a4:	e04a                	sd	s2,0(sp)
    800011a6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011a8:	00008497          	auipc	s1,0x8
    800011ac:	c1848493          	addi	s1,s1,-1000 # 80008dc0 <proc>
    800011b0:	0000e917          	auipc	s2,0xe
    800011b4:	81090913          	addi	s2,s2,-2032 # 8000e9c0 <tickslock>
    acquire(&p->lock);
    800011b8:	8526                	mv	a0,s1
    800011ba:	00005097          	auipc	ra,0x5
    800011be:	09a080e7          	jalr	154(ra) # 80006254 <acquire>
    if(p->state == UNUSED) {
    800011c2:	509c                	lw	a5,32(s1)
    800011c4:	cf81                	beqz	a5,800011dc <allocproc+0x40>
      release(&p->lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	00005097          	auipc	ra,0x5
    800011cc:	140080e7          	jalr	320(ra) # 80006308 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d0:	17048493          	addi	s1,s1,368
    800011d4:	ff2492e3          	bne	s1,s2,800011b8 <allocproc+0x1c>
  return 0;
    800011d8:	4481                	li	s1,0
    800011da:	a095                	j	8000123e <allocproc+0xa2>
  p->pid = allocpid();
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	de0080e7          	jalr	-544(ra) # 80000fbc <allocpid>
    800011e4:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800011e6:	4785                	li	a5,1
    800011e8:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800011ea:	fffff097          	auipc	ra,0xfffff
    800011ee:	f30080e7          	jalr	-208(ra) # 8000011a <kalloc>
    800011f2:	892a                	mv	s2,a0
    800011f4:	f0a8                	sd	a0,96(s1)
    800011f6:	c939                	beqz	a0,8000124c <allocproc+0xb0>
  if((p->usyscallPage = (struct usyscall*)kalloc()) == 0){
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	f22080e7          	jalr	-222(ra) # 8000011a <kalloc>
    80001200:	892a                	mv	s2,a0
    80001202:	ec88                	sd	a0,24(s1)
    80001204:	c125                	beqz	a0,80001264 <allocproc+0xc8>
  p->usyscallPage->pid = p->pid;
    80001206:	5c9c                	lw	a5,56(s1)
    80001208:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	df6080e7          	jalr	-522(ra) # 80001002 <proc_pagetable>
    80001214:	892a                	mv	s2,a0
    80001216:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80001218:	c135                	beqz	a0,8000127c <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    8000121a:	07000613          	li	a2,112
    8000121e:	4581                	li	a1,0
    80001220:	06848513          	addi	a0,s1,104
    80001224:	fffff097          	auipc	ra,0xfffff
    80001228:	f56080e7          	jalr	-170(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000122c:	00000797          	auipc	a5,0x0
    80001230:	d4a78793          	addi	a5,a5,-694 # 80000f76 <forkret>
    80001234:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001236:	64bc                	ld	a5,72(s1)
    80001238:	6705                	lui	a4,0x1
    8000123a:	97ba                	add	a5,a5,a4
    8000123c:	f8bc                	sd	a5,112(s1)
}
    8000123e:	8526                	mv	a0,s1
    80001240:	60e2                	ld	ra,24(sp)
    80001242:	6442                	ld	s0,16(sp)
    80001244:	64a2                	ld	s1,8(sp)
    80001246:	6902                	ld	s2,0(sp)
    80001248:	6105                	addi	sp,sp,32
    8000124a:	8082                	ret
    freeproc(p);
    8000124c:	8526                	mv	a0,s1
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	eea080e7          	jalr	-278(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001256:	8526                	mv	a0,s1
    80001258:	00005097          	auipc	ra,0x5
    8000125c:	0b0080e7          	jalr	176(ra) # 80006308 <release>
    return 0;
    80001260:	84ca                	mv	s1,s2
    80001262:	bff1                	j	8000123e <allocproc+0xa2>
    freeproc(p);
    80001264:	8526                	mv	a0,s1
    80001266:	00000097          	auipc	ra,0x0
    8000126a:	ed2080e7          	jalr	-302(ra) # 80001138 <freeproc>
    release(&p->lock);
    8000126e:	8526                	mv	a0,s1
    80001270:	00005097          	auipc	ra,0x5
    80001274:	098080e7          	jalr	152(ra) # 80006308 <release>
    return 0;
    80001278:	84ca                	mv	s1,s2
    8000127a:	b7d1                	j	8000123e <allocproc+0xa2>
    freeproc(p);
    8000127c:	8526                	mv	a0,s1
    8000127e:	00000097          	auipc	ra,0x0
    80001282:	eba080e7          	jalr	-326(ra) # 80001138 <freeproc>
    release(&p->lock);
    80001286:	8526                	mv	a0,s1
    80001288:	00005097          	auipc	ra,0x5
    8000128c:	080080e7          	jalr	128(ra) # 80006308 <release>
    return 0;
    80001290:	84ca                	mv	s1,s2
    80001292:	b775                	j	8000123e <allocproc+0xa2>

0000000080001294 <userinit>:
{
    80001294:	1101                	addi	sp,sp,-32
    80001296:	ec06                	sd	ra,24(sp)
    80001298:	e822                	sd	s0,16(sp)
    8000129a:	e426                	sd	s1,8(sp)
    8000129c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000129e:	00000097          	auipc	ra,0x0
    800012a2:	efe080e7          	jalr	-258(ra) # 8000119c <allocproc>
    800012a6:	84aa                	mv	s1,a0
  initproc = p;
    800012a8:	00007797          	auipc	a5,0x7
    800012ac:	6aa7b023          	sd	a0,1696(a5) # 80008948 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012b0:	03400613          	li	a2,52
    800012b4:	00007597          	auipc	a1,0x7
    800012b8:	61c58593          	addi	a1,a1,1564 # 800088d0 <initcode>
    800012bc:	6d28                	ld	a0,88(a0)
    800012be:	fffff097          	auipc	ra,0xfffff
    800012c2:	540080e7          	jalr	1344(ra) # 800007fe <uvmfirst>
  p->sz = PGSIZE;
    800012c6:	6785                	lui	a5,0x1
    800012c8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800012ca:	70b8                	ld	a4,96(s1)
    800012cc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800012d0:	70b8                	ld	a4,96(s1)
    800012d2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800012d4:	4641                	li	a2,16
    800012d6:	00007597          	auipc	a1,0x7
    800012da:	eda58593          	addi	a1,a1,-294 # 800081b0 <etext+0x1b0>
    800012de:	16048513          	addi	a0,s1,352
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	fe2080e7          	jalr	-30(ra) # 800002c4 <safestrcpy>
  p->cwd = namei("/");
    800012ea:	00007517          	auipc	a0,0x7
    800012ee:	ed650513          	addi	a0,a0,-298 # 800081c0 <etext+0x1c0>
    800012f2:	00002097          	auipc	ra,0x2
    800012f6:	104080e7          	jalr	260(ra) # 800033f6 <namei>
    800012fa:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012fe:	478d                	li	a5,3
    80001300:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001302:	8526                	mv	a0,s1
    80001304:	00005097          	auipc	ra,0x5
    80001308:	004080e7          	jalr	4(ra) # 80006308 <release>
}
    8000130c:	60e2                	ld	ra,24(sp)
    8000130e:	6442                	ld	s0,16(sp)
    80001310:	64a2                	ld	s1,8(sp)
    80001312:	6105                	addi	sp,sp,32
    80001314:	8082                	ret

0000000080001316 <growproc>:
{
    80001316:	1101                	addi	sp,sp,-32
    80001318:	ec06                	sd	ra,24(sp)
    8000131a:	e822                	sd	s0,16(sp)
    8000131c:	e426                	sd	s1,8(sp)
    8000131e:	e04a                	sd	s2,0(sp)
    80001320:	1000                	addi	s0,sp,32
    80001322:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001324:	00000097          	auipc	ra,0x0
    80001328:	c1a080e7          	jalr	-998(ra) # 80000f3e <myproc>
    8000132c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000132e:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001330:	01204c63          	bgtz	s2,80001348 <growproc+0x32>
  } else if(n < 0){
    80001334:	02094663          	bltz	s2,80001360 <growproc+0x4a>
  p->sz = sz;
    80001338:	e8ac                	sd	a1,80(s1)
  return 0;
    8000133a:	4501                	li	a0,0
}
    8000133c:	60e2                	ld	ra,24(sp)
    8000133e:	6442                	ld	s0,16(sp)
    80001340:	64a2                	ld	s1,8(sp)
    80001342:	6902                	ld	s2,0(sp)
    80001344:	6105                	addi	sp,sp,32
    80001346:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001348:	4691                	li	a3,4
    8000134a:	00b90633          	add	a2,s2,a1
    8000134e:	6d28                	ld	a0,88(a0)
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	568080e7          	jalr	1384(ra) # 800008b8 <uvmalloc>
    80001358:	85aa                	mv	a1,a0
    8000135a:	fd79                	bnez	a0,80001338 <growproc+0x22>
      return -1;
    8000135c:	557d                	li	a0,-1
    8000135e:	bff9                	j	8000133c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001360:	00b90633          	add	a2,s2,a1
    80001364:	6d28                	ld	a0,88(a0)
    80001366:	fffff097          	auipc	ra,0xfffff
    8000136a:	50a080e7          	jalr	1290(ra) # 80000870 <uvmdealloc>
    8000136e:	85aa                	mv	a1,a0
    80001370:	b7e1                	j	80001338 <growproc+0x22>

0000000080001372 <fork>:
{
    80001372:	7139                	addi	sp,sp,-64
    80001374:	fc06                	sd	ra,56(sp)
    80001376:	f822                	sd	s0,48(sp)
    80001378:	f426                	sd	s1,40(sp)
    8000137a:	f04a                	sd	s2,32(sp)
    8000137c:	ec4e                	sd	s3,24(sp)
    8000137e:	e852                	sd	s4,16(sp)
    80001380:	e456                	sd	s5,8(sp)
    80001382:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001384:	00000097          	auipc	ra,0x0
    80001388:	bba080e7          	jalr	-1094(ra) # 80000f3e <myproc>
    8000138c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000138e:	00000097          	auipc	ra,0x0
    80001392:	e0e080e7          	jalr	-498(ra) # 8000119c <allocproc>
    80001396:	10050c63          	beqz	a0,800014ae <fork+0x13c>
    8000139a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000139c:	050ab603          	ld	a2,80(s5)
    800013a0:	6d2c                	ld	a1,88(a0)
    800013a2:	058ab503          	ld	a0,88(s5)
    800013a6:	fffff097          	auipc	ra,0xfffff
    800013aa:	66a080e7          	jalr	1642(ra) # 80000a10 <uvmcopy>
    800013ae:	04054863          	bltz	a0,800013fe <fork+0x8c>
  np->sz = p->sz;
    800013b2:	050ab783          	ld	a5,80(s5)
    800013b6:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800013ba:	060ab683          	ld	a3,96(s5)
    800013be:	87b6                	mv	a5,a3
    800013c0:	060a3703          	ld	a4,96(s4)
    800013c4:	12068693          	addi	a3,a3,288
    800013c8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013cc:	6788                	ld	a0,8(a5)
    800013ce:	6b8c                	ld	a1,16(a5)
    800013d0:	6f90                	ld	a2,24(a5)
    800013d2:	01073023          	sd	a6,0(a4)
    800013d6:	e708                	sd	a0,8(a4)
    800013d8:	eb0c                	sd	a1,16(a4)
    800013da:	ef10                	sd	a2,24(a4)
    800013dc:	02078793          	addi	a5,a5,32
    800013e0:	02070713          	addi	a4,a4,32
    800013e4:	fed792e3          	bne	a5,a3,800013c8 <fork+0x56>
  np->trapframe->a0 = 0;
    800013e8:	060a3783          	ld	a5,96(s4)
    800013ec:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013f0:	0d8a8493          	addi	s1,s5,216
    800013f4:	0d8a0913          	addi	s2,s4,216
    800013f8:	158a8993          	addi	s3,s5,344
    800013fc:	a00d                	j	8000141e <fork+0xac>
    freeproc(np);
    800013fe:	8552                	mv	a0,s4
    80001400:	00000097          	auipc	ra,0x0
    80001404:	d38080e7          	jalr	-712(ra) # 80001138 <freeproc>
    release(&np->lock);
    80001408:	8552                	mv	a0,s4
    8000140a:	00005097          	auipc	ra,0x5
    8000140e:	efe080e7          	jalr	-258(ra) # 80006308 <release>
    return -1;
    80001412:	597d                	li	s2,-1
    80001414:	a059                	j	8000149a <fork+0x128>
  for(i = 0; i < NOFILE; i++)
    80001416:	04a1                	addi	s1,s1,8
    80001418:	0921                	addi	s2,s2,8
    8000141a:	01348b63          	beq	s1,s3,80001430 <fork+0xbe>
    if(p->ofile[i])
    8000141e:	6088                	ld	a0,0(s1)
    80001420:	d97d                	beqz	a0,80001416 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001422:	00002097          	auipc	ra,0x2
    80001426:	66a080e7          	jalr	1642(ra) # 80003a8c <filedup>
    8000142a:	00a93023          	sd	a0,0(s2)
    8000142e:	b7e5                	j	80001416 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001430:	158ab503          	ld	a0,344(s5)
    80001434:	00001097          	auipc	ra,0x1
    80001438:	7d8080e7          	jalr	2008(ra) # 80002c0c <idup>
    8000143c:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001440:	4641                	li	a2,16
    80001442:	160a8593          	addi	a1,s5,352
    80001446:	160a0513          	addi	a0,s4,352
    8000144a:	fffff097          	auipc	ra,0xfffff
    8000144e:	e7a080e7          	jalr	-390(ra) # 800002c4 <safestrcpy>
  pid = np->pid;
    80001452:	038a2903          	lw	s2,56(s4)
  release(&np->lock);
    80001456:	8552                	mv	a0,s4
    80001458:	00005097          	auipc	ra,0x5
    8000145c:	eb0080e7          	jalr	-336(ra) # 80006308 <release>
  acquire(&wait_lock);
    80001460:	00007497          	auipc	s1,0x7
    80001464:	54848493          	addi	s1,s1,1352 # 800089a8 <wait_lock>
    80001468:	8526                	mv	a0,s1
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	dea080e7          	jalr	-534(ra) # 80006254 <acquire>
  np->parent = p;
    80001472:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	e90080e7          	jalr	-368(ra) # 80006308 <release>
  acquire(&np->lock);
    80001480:	8552                	mv	a0,s4
    80001482:	00005097          	auipc	ra,0x5
    80001486:	dd2080e7          	jalr	-558(ra) # 80006254 <acquire>
  np->state = RUNNABLE;
    8000148a:	478d                	li	a5,3
    8000148c:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001490:	8552                	mv	a0,s4
    80001492:	00005097          	auipc	ra,0x5
    80001496:	e76080e7          	jalr	-394(ra) # 80006308 <release>
}
    8000149a:	854a                	mv	a0,s2
    8000149c:	70e2                	ld	ra,56(sp)
    8000149e:	7442                	ld	s0,48(sp)
    800014a0:	74a2                	ld	s1,40(sp)
    800014a2:	7902                	ld	s2,32(sp)
    800014a4:	69e2                	ld	s3,24(sp)
    800014a6:	6a42                	ld	s4,16(sp)
    800014a8:	6aa2                	ld	s5,8(sp)
    800014aa:	6121                	addi	sp,sp,64
    800014ac:	8082                	ret
    return -1;
    800014ae:	597d                	li	s2,-1
    800014b0:	b7ed                	j	8000149a <fork+0x128>

00000000800014b2 <scheduler>:
{
    800014b2:	7139                	addi	sp,sp,-64
    800014b4:	fc06                	sd	ra,56(sp)
    800014b6:	f822                	sd	s0,48(sp)
    800014b8:	f426                	sd	s1,40(sp)
    800014ba:	f04a                	sd	s2,32(sp)
    800014bc:	ec4e                	sd	s3,24(sp)
    800014be:	e852                	sd	s4,16(sp)
    800014c0:	e456                	sd	s5,8(sp)
    800014c2:	e05a                	sd	s6,0(sp)
    800014c4:	0080                	addi	s0,sp,64
    800014c6:	8792                	mv	a5,tp
  int id = r_tp();
    800014c8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014ca:	00779a93          	slli	s5,a5,0x7
    800014ce:	00007717          	auipc	a4,0x7
    800014d2:	4c270713          	addi	a4,a4,1218 # 80008990 <pid_lock>
    800014d6:	9756                	add	a4,a4,s5
    800014d8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014dc:	00007717          	auipc	a4,0x7
    800014e0:	4ec70713          	addi	a4,a4,1260 # 800089c8 <cpus+0x8>
    800014e4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014e6:	498d                	li	s3,3
        p->state = RUNNING;
    800014e8:	4b11                	li	s6,4
        c->proc = p;
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	00007a17          	auipc	s4,0x7
    800014f0:	4a4a0a13          	addi	s4,s4,1188 # 80008990 <pid_lock>
    800014f4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f6:	0000d917          	auipc	s2,0xd
    800014fa:	4ca90913          	addi	s2,s2,1226 # 8000e9c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001502:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001506:	10079073          	csrw	sstatus,a5
    8000150a:	00008497          	auipc	s1,0x8
    8000150e:	8b648493          	addi	s1,s1,-1866 # 80008dc0 <proc>
    80001512:	a811                	j	80001526 <scheduler+0x74>
      release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	df2080e7          	jalr	-526(ra) # 80006308 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000151e:	17048493          	addi	s1,s1,368
    80001522:	fd248ee3          	beq	s1,s2,800014fe <scheduler+0x4c>
      acquire(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	d2c080e7          	jalr	-724(ra) # 80006254 <acquire>
      if(p->state == RUNNABLE) {
    80001530:	509c                	lw	a5,32(s1)
    80001532:	ff3791e3          	bne	a5,s3,80001514 <scheduler+0x62>
        p->state = RUNNING;
    80001536:	0364a023          	sw	s6,32(s1)
        c->proc = p;
    8000153a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000153e:	06848593          	addi	a1,s1,104
    80001542:	8556                	mv	a0,s5
    80001544:	00000097          	auipc	ra,0x0
    80001548:	684080e7          	jalr	1668(ra) # 80001bc8 <swtch>
        c->proc = 0;
    8000154c:	020a3823          	sd	zero,48(s4)
    80001550:	b7d1                	j	80001514 <scheduler+0x62>

0000000080001552 <sched>:
{
    80001552:	7179                	addi	sp,sp,-48
    80001554:	f406                	sd	ra,40(sp)
    80001556:	f022                	sd	s0,32(sp)
    80001558:	ec26                	sd	s1,24(sp)
    8000155a:	e84a                	sd	s2,16(sp)
    8000155c:	e44e                	sd	s3,8(sp)
    8000155e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001560:	00000097          	auipc	ra,0x0
    80001564:	9de080e7          	jalr	-1570(ra) # 80000f3e <myproc>
    80001568:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000156a:	00005097          	auipc	ra,0x5
    8000156e:	c70080e7          	jalr	-912(ra) # 800061da <holding>
    80001572:	c93d                	beqz	a0,800015e8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001574:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001576:	2781                	sext.w	a5,a5
    80001578:	079e                	slli	a5,a5,0x7
    8000157a:	00007717          	auipc	a4,0x7
    8000157e:	41670713          	addi	a4,a4,1046 # 80008990 <pid_lock>
    80001582:	97ba                	add	a5,a5,a4
    80001584:	0a87a703          	lw	a4,168(a5)
    80001588:	4785                	li	a5,1
    8000158a:	06f71763          	bne	a4,a5,800015f8 <sched+0xa6>
  if(p->state == RUNNING)
    8000158e:	5098                	lw	a4,32(s1)
    80001590:	4791                	li	a5,4
    80001592:	06f70b63          	beq	a4,a5,80001608 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001596:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000159a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000159c:	efb5                	bnez	a5,80001618 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000159e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015a0:	00007917          	auipc	s2,0x7
    800015a4:	3f090913          	addi	s2,s2,1008 # 80008990 <pid_lock>
    800015a8:	2781                	sext.w	a5,a5
    800015aa:	079e                	slli	a5,a5,0x7
    800015ac:	97ca                	add	a5,a5,s2
    800015ae:	0ac7a983          	lw	s3,172(a5)
    800015b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b4:	2781                	sext.w	a5,a5
    800015b6:	079e                	slli	a5,a5,0x7
    800015b8:	00007597          	auipc	a1,0x7
    800015bc:	41058593          	addi	a1,a1,1040 # 800089c8 <cpus+0x8>
    800015c0:	95be                	add	a1,a1,a5
    800015c2:	06848513          	addi	a0,s1,104
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	602080e7          	jalr	1538(ra) # 80001bc8 <swtch>
    800015ce:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015d0:	2781                	sext.w	a5,a5
    800015d2:	079e                	slli	a5,a5,0x7
    800015d4:	993e                	add	s2,s2,a5
    800015d6:	0b392623          	sw	s3,172(s2)
}
    800015da:	70a2                	ld	ra,40(sp)
    800015dc:	7402                	ld	s0,32(sp)
    800015de:	64e2                	ld	s1,24(sp)
    800015e0:	6942                	ld	s2,16(sp)
    800015e2:	69a2                	ld	s3,8(sp)
    800015e4:	6145                	addi	sp,sp,48
    800015e6:	8082                	ret
    panic("sched p->lock");
    800015e8:	00007517          	auipc	a0,0x7
    800015ec:	be050513          	addi	a0,a0,-1056 # 800081c8 <etext+0x1c8>
    800015f0:	00004097          	auipc	ra,0x4
    800015f4:	72c080e7          	jalr	1836(ra) # 80005d1c <panic>
    panic("sched locks");
    800015f8:	00007517          	auipc	a0,0x7
    800015fc:	be050513          	addi	a0,a0,-1056 # 800081d8 <etext+0x1d8>
    80001600:	00004097          	auipc	ra,0x4
    80001604:	71c080e7          	jalr	1820(ra) # 80005d1c <panic>
    panic("sched running");
    80001608:	00007517          	auipc	a0,0x7
    8000160c:	be050513          	addi	a0,a0,-1056 # 800081e8 <etext+0x1e8>
    80001610:	00004097          	auipc	ra,0x4
    80001614:	70c080e7          	jalr	1804(ra) # 80005d1c <panic>
    panic("sched interruptible");
    80001618:	00007517          	auipc	a0,0x7
    8000161c:	be050513          	addi	a0,a0,-1056 # 800081f8 <etext+0x1f8>
    80001620:	00004097          	auipc	ra,0x4
    80001624:	6fc080e7          	jalr	1788(ra) # 80005d1c <panic>

0000000080001628 <yield>:
{
    80001628:	1101                	addi	sp,sp,-32
    8000162a:	ec06                	sd	ra,24(sp)
    8000162c:	e822                	sd	s0,16(sp)
    8000162e:	e426                	sd	s1,8(sp)
    80001630:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001632:	00000097          	auipc	ra,0x0
    80001636:	90c080e7          	jalr	-1780(ra) # 80000f3e <myproc>
    8000163a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000163c:	00005097          	auipc	ra,0x5
    80001640:	c18080e7          	jalr	-1000(ra) # 80006254 <acquire>
  p->state = RUNNABLE;
    80001644:	478d                	li	a5,3
    80001646:	d09c                	sw	a5,32(s1)
  sched();
    80001648:	00000097          	auipc	ra,0x0
    8000164c:	f0a080e7          	jalr	-246(ra) # 80001552 <sched>
  release(&p->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	cb6080e7          	jalr	-842(ra) # 80006308 <release>
}
    8000165a:	60e2                	ld	ra,24(sp)
    8000165c:	6442                	ld	s0,16(sp)
    8000165e:	64a2                	ld	s1,8(sp)
    80001660:	6105                	addi	sp,sp,32
    80001662:	8082                	ret

0000000080001664 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001664:	7179                	addi	sp,sp,-48
    80001666:	f406                	sd	ra,40(sp)
    80001668:	f022                	sd	s0,32(sp)
    8000166a:	ec26                	sd	s1,24(sp)
    8000166c:	e84a                	sd	s2,16(sp)
    8000166e:	e44e                	sd	s3,8(sp)
    80001670:	1800                	addi	s0,sp,48
    80001672:	89aa                	mv	s3,a0
    80001674:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001676:	00000097          	auipc	ra,0x0
    8000167a:	8c8080e7          	jalr	-1848(ra) # 80000f3e <myproc>
    8000167e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001680:	00005097          	auipc	ra,0x5
    80001684:	bd4080e7          	jalr	-1068(ra) # 80006254 <acquire>
  release(lk);
    80001688:	854a                	mv	a0,s2
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	c7e080e7          	jalr	-898(ra) # 80006308 <release>

  // Go to sleep.
  p->chan = chan;
    80001692:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001696:	4789                	li	a5,2
    80001698:	d09c                	sw	a5,32(s1)

  sched();
    8000169a:	00000097          	auipc	ra,0x0
    8000169e:	eb8080e7          	jalr	-328(ra) # 80001552 <sched>

  // Tidy up.
  p->chan = 0;
    800016a2:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	00005097          	auipc	ra,0x5
    800016ac:	c60080e7          	jalr	-928(ra) # 80006308 <release>
  acquire(lk);
    800016b0:	854a                	mv	a0,s2
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	ba2080e7          	jalr	-1118(ra) # 80006254 <acquire>
}
    800016ba:	70a2                	ld	ra,40(sp)
    800016bc:	7402                	ld	s0,32(sp)
    800016be:	64e2                	ld	s1,24(sp)
    800016c0:	6942                	ld	s2,16(sp)
    800016c2:	69a2                	ld	s3,8(sp)
    800016c4:	6145                	addi	sp,sp,48
    800016c6:	8082                	ret

00000000800016c8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016c8:	7139                	addi	sp,sp,-64
    800016ca:	fc06                	sd	ra,56(sp)
    800016cc:	f822                	sd	s0,48(sp)
    800016ce:	f426                	sd	s1,40(sp)
    800016d0:	f04a                	sd	s2,32(sp)
    800016d2:	ec4e                	sd	s3,24(sp)
    800016d4:	e852                	sd	s4,16(sp)
    800016d6:	e456                	sd	s5,8(sp)
    800016d8:	0080                	addi	s0,sp,64
    800016da:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016dc:	00007497          	auipc	s1,0x7
    800016e0:	6e448493          	addi	s1,s1,1764 # 80008dc0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016e6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e8:	0000d917          	auipc	s2,0xd
    800016ec:	2d890913          	addi	s2,s2,728 # 8000e9c0 <tickslock>
    800016f0:	a811                	j	80001704 <wakeup+0x3c>
      }
      release(&p->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	c14080e7          	jalr	-1004(ra) # 80006308 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016fc:	17048493          	addi	s1,s1,368
    80001700:	03248663          	beq	s1,s2,8000172c <wakeup+0x64>
    if(p != myproc()){
    80001704:	00000097          	auipc	ra,0x0
    80001708:	83a080e7          	jalr	-1990(ra) # 80000f3e <myproc>
    8000170c:	fea488e3          	beq	s1,a0,800016fc <wakeup+0x34>
      acquire(&p->lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	b42080e7          	jalr	-1214(ra) # 80006254 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000171a:	509c                	lw	a5,32(s1)
    8000171c:	fd379be3          	bne	a5,s3,800016f2 <wakeup+0x2a>
    80001720:	749c                	ld	a5,40(s1)
    80001722:	fd4798e3          	bne	a5,s4,800016f2 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001726:	0354a023          	sw	s5,32(s1)
    8000172a:	b7e1                	j	800016f2 <wakeup+0x2a>
    }
  }
}
    8000172c:	70e2                	ld	ra,56(sp)
    8000172e:	7442                	ld	s0,48(sp)
    80001730:	74a2                	ld	s1,40(sp)
    80001732:	7902                	ld	s2,32(sp)
    80001734:	69e2                	ld	s3,24(sp)
    80001736:	6a42                	ld	s4,16(sp)
    80001738:	6aa2                	ld	s5,8(sp)
    8000173a:	6121                	addi	sp,sp,64
    8000173c:	8082                	ret

000000008000173e <reparent>:
{
    8000173e:	7179                	addi	sp,sp,-48
    80001740:	f406                	sd	ra,40(sp)
    80001742:	f022                	sd	s0,32(sp)
    80001744:	ec26                	sd	s1,24(sp)
    80001746:	e84a                	sd	s2,16(sp)
    80001748:	e44e                	sd	s3,8(sp)
    8000174a:	e052                	sd	s4,0(sp)
    8000174c:	1800                	addi	s0,sp,48
    8000174e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001750:	00007497          	auipc	s1,0x7
    80001754:	67048493          	addi	s1,s1,1648 # 80008dc0 <proc>
      pp->parent = initproc;
    80001758:	00007a17          	auipc	s4,0x7
    8000175c:	1f0a0a13          	addi	s4,s4,496 # 80008948 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	0000d997          	auipc	s3,0xd
    80001764:	26098993          	addi	s3,s3,608 # 8000e9c0 <tickslock>
    80001768:	a029                	j	80001772 <reparent+0x34>
    8000176a:	17048493          	addi	s1,s1,368
    8000176e:	01348d63          	beq	s1,s3,80001788 <reparent+0x4a>
    if(pp->parent == p){
    80001772:	60bc                	ld	a5,64(s1)
    80001774:	ff279be3          	bne	a5,s2,8000176a <reparent+0x2c>
      pp->parent = initproc;
    80001778:	000a3503          	ld	a0,0(s4)
    8000177c:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	f4a080e7          	jalr	-182(ra) # 800016c8 <wakeup>
    80001786:	b7d5                	j	8000176a <reparent+0x2c>
}
    80001788:	70a2                	ld	ra,40(sp)
    8000178a:	7402                	ld	s0,32(sp)
    8000178c:	64e2                	ld	s1,24(sp)
    8000178e:	6942                	ld	s2,16(sp)
    80001790:	69a2                	ld	s3,8(sp)
    80001792:	6a02                	ld	s4,0(sp)
    80001794:	6145                	addi	sp,sp,48
    80001796:	8082                	ret

0000000080001798 <exit>:
{
    80001798:	7179                	addi	sp,sp,-48
    8000179a:	f406                	sd	ra,40(sp)
    8000179c:	f022                	sd	s0,32(sp)
    8000179e:	ec26                	sd	s1,24(sp)
    800017a0:	e84a                	sd	s2,16(sp)
    800017a2:	e44e                	sd	s3,8(sp)
    800017a4:	e052                	sd	s4,0(sp)
    800017a6:	1800                	addi	s0,sp,48
    800017a8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017aa:	fffff097          	auipc	ra,0xfffff
    800017ae:	794080e7          	jalr	1940(ra) # 80000f3e <myproc>
    800017b2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017b4:	00007797          	auipc	a5,0x7
    800017b8:	1947b783          	ld	a5,404(a5) # 80008948 <initproc>
    800017bc:	0d850493          	addi	s1,a0,216
    800017c0:	15850913          	addi	s2,a0,344
    800017c4:	02a79363          	bne	a5,a0,800017ea <exit+0x52>
    panic("init exiting");
    800017c8:	00007517          	auipc	a0,0x7
    800017cc:	a4850513          	addi	a0,a0,-1464 # 80008210 <etext+0x210>
    800017d0:	00004097          	auipc	ra,0x4
    800017d4:	54c080e7          	jalr	1356(ra) # 80005d1c <panic>
      fileclose(f);
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	306080e7          	jalr	774(ra) # 80003ade <fileclose>
      p->ofile[fd] = 0;
    800017e0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017e4:	04a1                	addi	s1,s1,8
    800017e6:	01248563          	beq	s1,s2,800017f0 <exit+0x58>
    if(p->ofile[fd]){
    800017ea:	6088                	ld	a0,0(s1)
    800017ec:	f575                	bnez	a0,800017d8 <exit+0x40>
    800017ee:	bfdd                	j	800017e4 <exit+0x4c>
  begin_op();
    800017f0:	00002097          	auipc	ra,0x2
    800017f4:	e26080e7          	jalr	-474(ra) # 80003616 <begin_op>
  iput(p->cwd);
    800017f8:	1589b503          	ld	a0,344(s3)
    800017fc:	00001097          	auipc	ra,0x1
    80001800:	608080e7          	jalr	1544(ra) # 80002e04 <iput>
  end_op();
    80001804:	00002097          	auipc	ra,0x2
    80001808:	e90080e7          	jalr	-368(ra) # 80003694 <end_op>
  p->cwd = 0;
    8000180c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001810:	00007497          	auipc	s1,0x7
    80001814:	19848493          	addi	s1,s1,408 # 800089a8 <wait_lock>
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	a3a080e7          	jalr	-1478(ra) # 80006254 <acquire>
  reparent(p);
    80001822:	854e                	mv	a0,s3
    80001824:	00000097          	auipc	ra,0x0
    80001828:	f1a080e7          	jalr	-230(ra) # 8000173e <reparent>
  wakeup(p->parent);
    8000182c:	0409b503          	ld	a0,64(s3)
    80001830:	00000097          	auipc	ra,0x0
    80001834:	e98080e7          	jalr	-360(ra) # 800016c8 <wakeup>
  acquire(&p->lock);
    80001838:	854e                	mv	a0,s3
    8000183a:	00005097          	auipc	ra,0x5
    8000183e:	a1a080e7          	jalr	-1510(ra) # 80006254 <acquire>
  p->xstate = status;
    80001842:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001846:	4795                	li	a5,5
    80001848:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	aba080e7          	jalr	-1350(ra) # 80006308 <release>
  sched();
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	cfc080e7          	jalr	-772(ra) # 80001552 <sched>
  panic("zombie exit");
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	9c250513          	addi	a0,a0,-1598 # 80008220 <etext+0x220>
    80001866:	00004097          	auipc	ra,0x4
    8000186a:	4b6080e7          	jalr	1206(ra) # 80005d1c <panic>

000000008000186e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000186e:	7179                	addi	sp,sp,-48
    80001870:	f406                	sd	ra,40(sp)
    80001872:	f022                	sd	s0,32(sp)
    80001874:	ec26                	sd	s1,24(sp)
    80001876:	e84a                	sd	s2,16(sp)
    80001878:	e44e                	sd	s3,8(sp)
    8000187a:	1800                	addi	s0,sp,48
    8000187c:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000187e:	00007497          	auipc	s1,0x7
    80001882:	54248493          	addi	s1,s1,1346 # 80008dc0 <proc>
    80001886:	0000d997          	auipc	s3,0xd
    8000188a:	13a98993          	addi	s3,s3,314 # 8000e9c0 <tickslock>
    acquire(&p->lock);
    8000188e:	8526                	mv	a0,s1
    80001890:	00005097          	auipc	ra,0x5
    80001894:	9c4080e7          	jalr	-1596(ra) # 80006254 <acquire>
    if(p->pid == pid){
    80001898:	5c9c                	lw	a5,56(s1)
    8000189a:	01278d63          	beq	a5,s2,800018b4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	a68080e7          	jalr	-1432(ra) # 80006308 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018a8:	17048493          	addi	s1,s1,368
    800018ac:	ff3491e3          	bne	s1,s3,8000188e <kill+0x20>
  }
  return -1;
    800018b0:	557d                	li	a0,-1
    800018b2:	a829                	j	800018cc <kill+0x5e>
      p->killed = 1;
    800018b4:	4785                	li	a5,1
    800018b6:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800018b8:	5098                	lw	a4,32(s1)
    800018ba:	4789                	li	a5,2
    800018bc:	00f70f63          	beq	a4,a5,800018da <kill+0x6c>
      release(&p->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	a46080e7          	jalr	-1466(ra) # 80006308 <release>
      return 0;
    800018ca:	4501                	li	a0,0
}
    800018cc:	70a2                	ld	ra,40(sp)
    800018ce:	7402                	ld	s0,32(sp)
    800018d0:	64e2                	ld	s1,24(sp)
    800018d2:	6942                	ld	s2,16(sp)
    800018d4:	69a2                	ld	s3,8(sp)
    800018d6:	6145                	addi	sp,sp,48
    800018d8:	8082                	ret
        p->state = RUNNABLE;
    800018da:	478d                	li	a5,3
    800018dc:	d09c                	sw	a5,32(s1)
    800018de:	b7cd                	j	800018c0 <kill+0x52>

00000000800018e0 <setkilled>:

void
setkilled(struct proc *p)
{
    800018e0:	1101                	addi	sp,sp,-32
    800018e2:	ec06                	sd	ra,24(sp)
    800018e4:	e822                	sd	s0,16(sp)
    800018e6:	e426                	sd	s1,8(sp)
    800018e8:	1000                	addi	s0,sp,32
    800018ea:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	968080e7          	jalr	-1688(ra) # 80006254 <acquire>
  p->killed = 1;
    800018f4:	4785                	li	a5,1
    800018f6:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	a0e080e7          	jalr	-1522(ra) # 80006308 <release>
}
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	64a2                	ld	s1,8(sp)
    80001908:	6105                	addi	sp,sp,32
    8000190a:	8082                	ret

000000008000190c <killed>:

int
killed(struct proc *p)
{
    8000190c:	1101                	addi	sp,sp,-32
    8000190e:	ec06                	sd	ra,24(sp)
    80001910:	e822                	sd	s0,16(sp)
    80001912:	e426                	sd	s1,8(sp)
    80001914:	e04a                	sd	s2,0(sp)
    80001916:	1000                	addi	s0,sp,32
    80001918:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	93a080e7          	jalr	-1734(ra) # 80006254 <acquire>
  k = p->killed;
    80001922:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    80001926:	8526                	mv	a0,s1
    80001928:	00005097          	auipc	ra,0x5
    8000192c:	9e0080e7          	jalr	-1568(ra) # 80006308 <release>
  return k;
}
    80001930:	854a                	mv	a0,s2
    80001932:	60e2                	ld	ra,24(sp)
    80001934:	6442                	ld	s0,16(sp)
    80001936:	64a2                	ld	s1,8(sp)
    80001938:	6902                	ld	s2,0(sp)
    8000193a:	6105                	addi	sp,sp,32
    8000193c:	8082                	ret

000000008000193e <wait>:
{
    8000193e:	715d                	addi	sp,sp,-80
    80001940:	e486                	sd	ra,72(sp)
    80001942:	e0a2                	sd	s0,64(sp)
    80001944:	fc26                	sd	s1,56(sp)
    80001946:	f84a                	sd	s2,48(sp)
    80001948:	f44e                	sd	s3,40(sp)
    8000194a:	f052                	sd	s4,32(sp)
    8000194c:	ec56                	sd	s5,24(sp)
    8000194e:	e85a                	sd	s6,16(sp)
    80001950:	e45e                	sd	s7,8(sp)
    80001952:	e062                	sd	s8,0(sp)
    80001954:	0880                	addi	s0,sp,80
    80001956:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	5e6080e7          	jalr	1510(ra) # 80000f3e <myproc>
    80001960:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001962:	00007517          	auipc	a0,0x7
    80001966:	04650513          	addi	a0,a0,70 # 800089a8 <wait_lock>
    8000196a:	00005097          	auipc	ra,0x5
    8000196e:	8ea080e7          	jalr	-1814(ra) # 80006254 <acquire>
    havekids = 0;
    80001972:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001974:	4a15                	li	s4,5
        havekids = 1;
    80001976:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001978:	0000d997          	auipc	s3,0xd
    8000197c:	04898993          	addi	s3,s3,72 # 8000e9c0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001980:	00007c17          	auipc	s8,0x7
    80001984:	028c0c13          	addi	s8,s8,40 # 800089a8 <wait_lock>
    havekids = 0;
    80001988:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000198a:	00007497          	auipc	s1,0x7
    8000198e:	43648493          	addi	s1,s1,1078 # 80008dc0 <proc>
    80001992:	a0bd                	j	80001a00 <wait+0xc2>
          pid = pp->pid;
    80001994:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001998:	000b0e63          	beqz	s6,800019b4 <wait+0x76>
    8000199c:	4691                	li	a3,4
    8000199e:	03448613          	addi	a2,s1,52
    800019a2:	85da                	mv	a1,s6
    800019a4:	05893503          	ld	a0,88(s2)
    800019a8:	fffff097          	auipc	ra,0xfffff
    800019ac:	16c080e7          	jalr	364(ra) # 80000b14 <copyout>
    800019b0:	02054563          	bltz	a0,800019da <wait+0x9c>
          freeproc(pp);
    800019b4:	8526                	mv	a0,s1
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	782080e7          	jalr	1922(ra) # 80001138 <freeproc>
          release(&pp->lock);
    800019be:	8526                	mv	a0,s1
    800019c0:	00005097          	auipc	ra,0x5
    800019c4:	948080e7          	jalr	-1720(ra) # 80006308 <release>
          release(&wait_lock);
    800019c8:	00007517          	auipc	a0,0x7
    800019cc:	fe050513          	addi	a0,a0,-32 # 800089a8 <wait_lock>
    800019d0:	00005097          	auipc	ra,0x5
    800019d4:	938080e7          	jalr	-1736(ra) # 80006308 <release>
          return pid;
    800019d8:	a0b5                	j	80001a44 <wait+0x106>
            release(&pp->lock);
    800019da:	8526                	mv	a0,s1
    800019dc:	00005097          	auipc	ra,0x5
    800019e0:	92c080e7          	jalr	-1748(ra) # 80006308 <release>
            release(&wait_lock);
    800019e4:	00007517          	auipc	a0,0x7
    800019e8:	fc450513          	addi	a0,a0,-60 # 800089a8 <wait_lock>
    800019ec:	00005097          	auipc	ra,0x5
    800019f0:	91c080e7          	jalr	-1764(ra) # 80006308 <release>
            return -1;
    800019f4:	59fd                	li	s3,-1
    800019f6:	a0b9                	j	80001a44 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019f8:	17048493          	addi	s1,s1,368
    800019fc:	03348463          	beq	s1,s3,80001a24 <wait+0xe6>
      if(pp->parent == p){
    80001a00:	60bc                	ld	a5,64(s1)
    80001a02:	ff279be3          	bne	a5,s2,800019f8 <wait+0xba>
        acquire(&pp->lock);
    80001a06:	8526                	mv	a0,s1
    80001a08:	00005097          	auipc	ra,0x5
    80001a0c:	84c080e7          	jalr	-1972(ra) # 80006254 <acquire>
        if(pp->state == ZOMBIE){
    80001a10:	509c                	lw	a5,32(s1)
    80001a12:	f94781e3          	beq	a5,s4,80001994 <wait+0x56>
        release(&pp->lock);
    80001a16:	8526                	mv	a0,s1
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	8f0080e7          	jalr	-1808(ra) # 80006308 <release>
        havekids = 1;
    80001a20:	8756                	mv	a4,s5
    80001a22:	bfd9                	j	800019f8 <wait+0xba>
    if(!havekids || killed(p)){
    80001a24:	c719                	beqz	a4,80001a32 <wait+0xf4>
    80001a26:	854a                	mv	a0,s2
    80001a28:	00000097          	auipc	ra,0x0
    80001a2c:	ee4080e7          	jalr	-284(ra) # 8000190c <killed>
    80001a30:	c51d                	beqz	a0,80001a5e <wait+0x120>
      release(&wait_lock);
    80001a32:	00007517          	auipc	a0,0x7
    80001a36:	f7650513          	addi	a0,a0,-138 # 800089a8 <wait_lock>
    80001a3a:	00005097          	auipc	ra,0x5
    80001a3e:	8ce080e7          	jalr	-1842(ra) # 80006308 <release>
      return -1;
    80001a42:	59fd                	li	s3,-1
}
    80001a44:	854e                	mv	a0,s3
    80001a46:	60a6                	ld	ra,72(sp)
    80001a48:	6406                	ld	s0,64(sp)
    80001a4a:	74e2                	ld	s1,56(sp)
    80001a4c:	7942                	ld	s2,48(sp)
    80001a4e:	79a2                	ld	s3,40(sp)
    80001a50:	7a02                	ld	s4,32(sp)
    80001a52:	6ae2                	ld	s5,24(sp)
    80001a54:	6b42                	ld	s6,16(sp)
    80001a56:	6ba2                	ld	s7,8(sp)
    80001a58:	6c02                	ld	s8,0(sp)
    80001a5a:	6161                	addi	sp,sp,80
    80001a5c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a5e:	85e2                	mv	a1,s8
    80001a60:	854a                	mv	a0,s2
    80001a62:	00000097          	auipc	ra,0x0
    80001a66:	c02080e7          	jalr	-1022(ra) # 80001664 <sleep>
    havekids = 0;
    80001a6a:	bf39                	j	80001988 <wait+0x4a>

0000000080001a6c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a6c:	7179                	addi	sp,sp,-48
    80001a6e:	f406                	sd	ra,40(sp)
    80001a70:	f022                	sd	s0,32(sp)
    80001a72:	ec26                	sd	s1,24(sp)
    80001a74:	e84a                	sd	s2,16(sp)
    80001a76:	e44e                	sd	s3,8(sp)
    80001a78:	e052                	sd	s4,0(sp)
    80001a7a:	1800                	addi	s0,sp,48
    80001a7c:	84aa                	mv	s1,a0
    80001a7e:	892e                	mv	s2,a1
    80001a80:	89b2                	mv	s3,a2
    80001a82:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a84:	fffff097          	auipc	ra,0xfffff
    80001a88:	4ba080e7          	jalr	1210(ra) # 80000f3e <myproc>
  if(user_dst){
    80001a8c:	c08d                	beqz	s1,80001aae <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001a8e:	86d2                	mv	a3,s4
    80001a90:	864e                	mv	a2,s3
    80001a92:	85ca                	mv	a1,s2
    80001a94:	6d28                	ld	a0,88(a0)
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	07e080e7          	jalr	126(ra) # 80000b14 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001a9e:	70a2                	ld	ra,40(sp)
    80001aa0:	7402                	ld	s0,32(sp)
    80001aa2:	64e2                	ld	s1,24(sp)
    80001aa4:	6942                	ld	s2,16(sp)
    80001aa6:	69a2                	ld	s3,8(sp)
    80001aa8:	6a02                	ld	s4,0(sp)
    80001aaa:	6145                	addi	sp,sp,48
    80001aac:	8082                	ret
    memmove((char *)dst, src, len);
    80001aae:	000a061b          	sext.w	a2,s4
    80001ab2:	85ce                	mv	a1,s3
    80001ab4:	854a                	mv	a0,s2
    80001ab6:	ffffe097          	auipc	ra,0xffffe
    80001aba:	720080e7          	jalr	1824(ra) # 800001d6 <memmove>
    return 0;
    80001abe:	8526                	mv	a0,s1
    80001ac0:	bff9                	j	80001a9e <either_copyout+0x32>

0000000080001ac2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001ac2:	7179                	addi	sp,sp,-48
    80001ac4:	f406                	sd	ra,40(sp)
    80001ac6:	f022                	sd	s0,32(sp)
    80001ac8:	ec26                	sd	s1,24(sp)
    80001aca:	e84a                	sd	s2,16(sp)
    80001acc:	e44e                	sd	s3,8(sp)
    80001ace:	e052                	sd	s4,0(sp)
    80001ad0:	1800                	addi	s0,sp,48
    80001ad2:	892a                	mv	s2,a0
    80001ad4:	84ae                	mv	s1,a1
    80001ad6:	89b2                	mv	s3,a2
    80001ad8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ada:	fffff097          	auipc	ra,0xfffff
    80001ade:	464080e7          	jalr	1124(ra) # 80000f3e <myproc>
  if(user_src){
    80001ae2:	c08d                	beqz	s1,80001b04 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001ae4:	86d2                	mv	a3,s4
    80001ae6:	864e                	mv	a2,s3
    80001ae8:	85ca                	mv	a1,s2
    80001aea:	6d28                	ld	a0,88(a0)
    80001aec:	fffff097          	auipc	ra,0xfffff
    80001af0:	0b4080e7          	jalr	180(ra) # 80000ba0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001af4:	70a2                	ld	ra,40(sp)
    80001af6:	7402                	ld	s0,32(sp)
    80001af8:	64e2                	ld	s1,24(sp)
    80001afa:	6942                	ld	s2,16(sp)
    80001afc:	69a2                	ld	s3,8(sp)
    80001afe:	6a02                	ld	s4,0(sp)
    80001b00:	6145                	addi	sp,sp,48
    80001b02:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b04:	000a061b          	sext.w	a2,s4
    80001b08:	85ce                	mv	a1,s3
    80001b0a:	854a                	mv	a0,s2
    80001b0c:	ffffe097          	auipc	ra,0xffffe
    80001b10:	6ca080e7          	jalr	1738(ra) # 800001d6 <memmove>
    return 0;
    80001b14:	8526                	mv	a0,s1
    80001b16:	bff9                	j	80001af4 <either_copyin+0x32>

0000000080001b18 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b18:	715d                	addi	sp,sp,-80
    80001b1a:	e486                	sd	ra,72(sp)
    80001b1c:	e0a2                	sd	s0,64(sp)
    80001b1e:	fc26                	sd	s1,56(sp)
    80001b20:	f84a                	sd	s2,48(sp)
    80001b22:	f44e                	sd	s3,40(sp)
    80001b24:	f052                	sd	s4,32(sp)
    80001b26:	ec56                	sd	s5,24(sp)
    80001b28:	e85a                	sd	s6,16(sp)
    80001b2a:	e45e                	sd	s7,8(sp)
    80001b2c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b2e:	00006517          	auipc	a0,0x6
    80001b32:	51a50513          	addi	a0,a0,1306 # 80008048 <etext+0x48>
    80001b36:	00004097          	auipc	ra,0x4
    80001b3a:	230080e7          	jalr	560(ra) # 80005d66 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b3e:	00007497          	auipc	s1,0x7
    80001b42:	3e248493          	addi	s1,s1,994 # 80008f20 <proc+0x160>
    80001b46:	0000d917          	auipc	s2,0xd
    80001b4a:	fda90913          	addi	s2,s2,-38 # 8000eb20 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b4e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b50:	00006997          	auipc	s3,0x6
    80001b54:	6e098993          	addi	s3,s3,1760 # 80008230 <etext+0x230>
    printf("%d %s %s", p->pid, state, p->name);
    80001b58:	00006a97          	auipc	s5,0x6
    80001b5c:	6e0a8a93          	addi	s5,s5,1760 # 80008238 <etext+0x238>
    printf("\n");
    80001b60:	00006a17          	auipc	s4,0x6
    80001b64:	4e8a0a13          	addi	s4,s4,1256 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b68:	00006b97          	auipc	s7,0x6
    80001b6c:	710b8b93          	addi	s7,s7,1808 # 80008278 <states.0>
    80001b70:	a00d                	j	80001b92 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001b72:	ed86a583          	lw	a1,-296(a3)
    80001b76:	8556                	mv	a0,s5
    80001b78:	00004097          	auipc	ra,0x4
    80001b7c:	1ee080e7          	jalr	494(ra) # 80005d66 <printf>
    printf("\n");
    80001b80:	8552                	mv	a0,s4
    80001b82:	00004097          	auipc	ra,0x4
    80001b86:	1e4080e7          	jalr	484(ra) # 80005d66 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b8a:	17048493          	addi	s1,s1,368
    80001b8e:	03248263          	beq	s1,s2,80001bb2 <procdump+0x9a>
    if(p->state == UNUSED)
    80001b92:	86a6                	mv	a3,s1
    80001b94:	ec04a783          	lw	a5,-320(s1)
    80001b98:	dbed                	beqz	a5,80001b8a <procdump+0x72>
      state = "???";
    80001b9a:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b9c:	fcfb6be3          	bltu	s6,a5,80001b72 <procdump+0x5a>
    80001ba0:	02079713          	slli	a4,a5,0x20
    80001ba4:	01d75793          	srli	a5,a4,0x1d
    80001ba8:	97de                	add	a5,a5,s7
    80001baa:	6390                	ld	a2,0(a5)
    80001bac:	f279                	bnez	a2,80001b72 <procdump+0x5a>
      state = "???";
    80001bae:	864e                	mv	a2,s3
    80001bb0:	b7c9                	j	80001b72 <procdump+0x5a>
  }
}
    80001bb2:	60a6                	ld	ra,72(sp)
    80001bb4:	6406                	ld	s0,64(sp)
    80001bb6:	74e2                	ld	s1,56(sp)
    80001bb8:	7942                	ld	s2,48(sp)
    80001bba:	79a2                	ld	s3,40(sp)
    80001bbc:	7a02                	ld	s4,32(sp)
    80001bbe:	6ae2                	ld	s5,24(sp)
    80001bc0:	6b42                	ld	s6,16(sp)
    80001bc2:	6ba2                	ld	s7,8(sp)
    80001bc4:	6161                	addi	sp,sp,80
    80001bc6:	8082                	ret

0000000080001bc8 <swtch>:
    80001bc8:	00153023          	sd	ra,0(a0)
    80001bcc:	00253423          	sd	sp,8(a0)
    80001bd0:	e900                	sd	s0,16(a0)
    80001bd2:	ed04                	sd	s1,24(a0)
    80001bd4:	03253023          	sd	s2,32(a0)
    80001bd8:	03353423          	sd	s3,40(a0)
    80001bdc:	03453823          	sd	s4,48(a0)
    80001be0:	03553c23          	sd	s5,56(a0)
    80001be4:	05653023          	sd	s6,64(a0)
    80001be8:	05753423          	sd	s7,72(a0)
    80001bec:	05853823          	sd	s8,80(a0)
    80001bf0:	05953c23          	sd	s9,88(a0)
    80001bf4:	07a53023          	sd	s10,96(a0)
    80001bf8:	07b53423          	sd	s11,104(a0)
    80001bfc:	0005b083          	ld	ra,0(a1)
    80001c00:	0085b103          	ld	sp,8(a1)
    80001c04:	6980                	ld	s0,16(a1)
    80001c06:	6d84                	ld	s1,24(a1)
    80001c08:	0205b903          	ld	s2,32(a1)
    80001c0c:	0285b983          	ld	s3,40(a1)
    80001c10:	0305ba03          	ld	s4,48(a1)
    80001c14:	0385ba83          	ld	s5,56(a1)
    80001c18:	0405bb03          	ld	s6,64(a1)
    80001c1c:	0485bb83          	ld	s7,72(a1)
    80001c20:	0505bc03          	ld	s8,80(a1)
    80001c24:	0585bc83          	ld	s9,88(a1)
    80001c28:	0605bd03          	ld	s10,96(a1)
    80001c2c:	0685bd83          	ld	s11,104(a1)
    80001c30:	8082                	ret

0000000080001c32 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c32:	1141                	addi	sp,sp,-16
    80001c34:	e406                	sd	ra,8(sp)
    80001c36:	e022                	sd	s0,0(sp)
    80001c38:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c3a:	00006597          	auipc	a1,0x6
    80001c3e:	66e58593          	addi	a1,a1,1646 # 800082a8 <states.0+0x30>
    80001c42:	0000d517          	auipc	a0,0xd
    80001c46:	d7e50513          	addi	a0,a0,-642 # 8000e9c0 <tickslock>
    80001c4a:	00004097          	auipc	ra,0x4
    80001c4e:	57a080e7          	jalr	1402(ra) # 800061c4 <initlock>
}
    80001c52:	60a2                	ld	ra,8(sp)
    80001c54:	6402                	ld	s0,0(sp)
    80001c56:	0141                	addi	sp,sp,16
    80001c58:	8082                	ret

0000000080001c5a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c5a:	1141                	addi	sp,sp,-16
    80001c5c:	e422                	sd	s0,8(sp)
    80001c5e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c60:	00003797          	auipc	a5,0x3
    80001c64:	4f078793          	addi	a5,a5,1264 # 80005150 <kernelvec>
    80001c68:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c6c:	6422                	ld	s0,8(sp)
    80001c6e:	0141                	addi	sp,sp,16
    80001c70:	8082                	ret

0000000080001c72 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001c72:	1141                	addi	sp,sp,-16
    80001c74:	e406                	sd	ra,8(sp)
    80001c76:	e022                	sd	s0,0(sp)
    80001c78:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001c7a:	fffff097          	auipc	ra,0xfffff
    80001c7e:	2c4080e7          	jalr	708(ra) # 80000f3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001c86:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c88:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c8c:	00005697          	auipc	a3,0x5
    80001c90:	37468693          	addi	a3,a3,884 # 80007000 <_trampoline>
    80001c94:	00005717          	auipc	a4,0x5
    80001c98:	36c70713          	addi	a4,a4,876 # 80007000 <_trampoline>
    80001c9c:	8f15                	sub	a4,a4,a3
    80001c9e:	040007b7          	lui	a5,0x4000
    80001ca2:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001ca4:	07b2                	slli	a5,a5,0xc
    80001ca6:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca8:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cac:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cae:	18002673          	csrr	a2,satp
    80001cb2:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001cb4:	7130                	ld	a2,96(a0)
    80001cb6:	6538                	ld	a4,72(a0)
    80001cb8:	6585                	lui	a1,0x1
    80001cba:	972e                	add	a4,a4,a1
    80001cbc:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cbe:	7138                	ld	a4,96(a0)
    80001cc0:	00000617          	auipc	a2,0x0
    80001cc4:	13060613          	addi	a2,a2,304 # 80001df0 <usertrap>
    80001cc8:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cca:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ccc:	8612                	mv	a2,tp
    80001cce:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cd0:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001cd4:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001cd8:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cdc:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001ce0:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ce2:	6f18                	ld	a4,24(a4)
    80001ce4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ce8:	6d28                	ld	a0,88(a0)
    80001cea:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001cec:	00005717          	auipc	a4,0x5
    80001cf0:	3b070713          	addi	a4,a4,944 # 8000709c <userret>
    80001cf4:	8f15                	sub	a4,a4,a3
    80001cf6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001cf8:	577d                	li	a4,-1
    80001cfa:	177e                	slli	a4,a4,0x3f
    80001cfc:	8d59                	or	a0,a0,a4
    80001cfe:	9782                	jalr	a5
}
    80001d00:	60a2                	ld	ra,8(sp)
    80001d02:	6402                	ld	s0,0(sp)
    80001d04:	0141                	addi	sp,sp,16
    80001d06:	8082                	ret

0000000080001d08 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d12:	0000d497          	auipc	s1,0xd
    80001d16:	cae48493          	addi	s1,s1,-850 # 8000e9c0 <tickslock>
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	538080e7          	jalr	1336(ra) # 80006254 <acquire>
  ticks++;
    80001d24:	00007517          	auipc	a0,0x7
    80001d28:	c2c50513          	addi	a0,a0,-980 # 80008950 <ticks>
    80001d2c:	411c                	lw	a5,0(a0)
    80001d2e:	2785                	addiw	a5,a5,1
    80001d30:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	996080e7          	jalr	-1642(ra) # 800016c8 <wakeup>
  release(&tickslock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	5cc080e7          	jalr	1484(ra) # 80006308 <release>
}
    80001d44:	60e2                	ld	ra,24(sp)
    80001d46:	6442                	ld	s0,16(sp)
    80001d48:	64a2                	ld	s1,8(sp)
    80001d4a:	6105                	addi	sp,sp,32
    80001d4c:	8082                	ret

0000000080001d4e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d4e:	1101                	addi	sp,sp,-32
    80001d50:	ec06                	sd	ra,24(sp)
    80001d52:	e822                	sd	s0,16(sp)
    80001d54:	e426                	sd	s1,8(sp)
    80001d56:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d58:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d5c:	00074d63          	bltz	a4,80001d76 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d60:	57fd                	li	a5,-1
    80001d62:	17fe                	slli	a5,a5,0x3f
    80001d64:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d66:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d68:	06f70363          	beq	a4,a5,80001dce <devintr+0x80>
  }
}
    80001d6c:	60e2                	ld	ra,24(sp)
    80001d6e:	6442                	ld	s0,16(sp)
    80001d70:	64a2                	ld	s1,8(sp)
    80001d72:	6105                	addi	sp,sp,32
    80001d74:	8082                	ret
     (scause & 0xff) == 9){
    80001d76:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001d7a:	46a5                	li	a3,9
    80001d7c:	fed792e3          	bne	a5,a3,80001d60 <devintr+0x12>
    int irq = plic_claim();
    80001d80:	00003097          	auipc	ra,0x3
    80001d84:	4d8080e7          	jalr	1240(ra) # 80005258 <plic_claim>
    80001d88:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001d8a:	47a9                	li	a5,10
    80001d8c:	02f50763          	beq	a0,a5,80001dba <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d90:	4785                	li	a5,1
    80001d92:	02f50963          	beq	a0,a5,80001dc4 <devintr+0x76>
    return 1;
    80001d96:	4505                	li	a0,1
    } else if(irq){
    80001d98:	d8f1                	beqz	s1,80001d6c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d9a:	85a6                	mv	a1,s1
    80001d9c:	00006517          	auipc	a0,0x6
    80001da0:	51450513          	addi	a0,a0,1300 # 800082b0 <states.0+0x38>
    80001da4:	00004097          	auipc	ra,0x4
    80001da8:	fc2080e7          	jalr	-62(ra) # 80005d66 <printf>
      plic_complete(irq);
    80001dac:	8526                	mv	a0,s1
    80001dae:	00003097          	auipc	ra,0x3
    80001db2:	4ce080e7          	jalr	1230(ra) # 8000527c <plic_complete>
    return 1;
    80001db6:	4505                	li	a0,1
    80001db8:	bf55                	j	80001d6c <devintr+0x1e>
      uartintr();
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	3ba080e7          	jalr	954(ra) # 80006174 <uartintr>
    80001dc2:	b7ed                	j	80001dac <devintr+0x5e>
      virtio_disk_intr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	980080e7          	jalr	-1664(ra) # 80005744 <virtio_disk_intr>
    80001dcc:	b7c5                	j	80001dac <devintr+0x5e>
    if(cpuid() == 0){
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	144080e7          	jalr	324(ra) # 80000f12 <cpuid>
    80001dd6:	c901                	beqz	a0,80001de6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001dd8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ddc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001dde:	14479073          	csrw	sip,a5
    return 2;
    80001de2:	4509                	li	a0,2
    80001de4:	b761                	j	80001d6c <devintr+0x1e>
      clockintr();
    80001de6:	00000097          	auipc	ra,0x0
    80001dea:	f22080e7          	jalr	-222(ra) # 80001d08 <clockintr>
    80001dee:	b7ed                	j	80001dd8 <devintr+0x8a>

0000000080001df0 <usertrap>:
{
    80001df0:	1101                	addi	sp,sp,-32
    80001df2:	ec06                	sd	ra,24(sp)
    80001df4:	e822                	sd	s0,16(sp)
    80001df6:	e426                	sd	s1,8(sp)
    80001df8:	e04a                	sd	s2,0(sp)
    80001dfa:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dfc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e00:	1007f793          	andi	a5,a5,256
    80001e04:	e3b1                	bnez	a5,80001e48 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e06:	00003797          	auipc	a5,0x3
    80001e0a:	34a78793          	addi	a5,a5,842 # 80005150 <kernelvec>
    80001e0e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e12:	fffff097          	auipc	ra,0xfffff
    80001e16:	12c080e7          	jalr	300(ra) # 80000f3e <myproc>
    80001e1a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e1c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1e:	14102773          	csrr	a4,sepc
    80001e22:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e24:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e28:	47a1                	li	a5,8
    80001e2a:	02f70763          	beq	a4,a5,80001e58 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e2e:	00000097          	auipc	ra,0x0
    80001e32:	f20080e7          	jalr	-224(ra) # 80001d4e <devintr>
    80001e36:	892a                	mv	s2,a0
    80001e38:	c151                	beqz	a0,80001ebc <usertrap+0xcc>
  if(killed(p))
    80001e3a:	8526                	mv	a0,s1
    80001e3c:	00000097          	auipc	ra,0x0
    80001e40:	ad0080e7          	jalr	-1328(ra) # 8000190c <killed>
    80001e44:	c929                	beqz	a0,80001e96 <usertrap+0xa6>
    80001e46:	a099                	j	80001e8c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e48:	00006517          	auipc	a0,0x6
    80001e4c:	48850513          	addi	a0,a0,1160 # 800082d0 <states.0+0x58>
    80001e50:	00004097          	auipc	ra,0x4
    80001e54:	ecc080e7          	jalr	-308(ra) # 80005d1c <panic>
    if(killed(p))
    80001e58:	00000097          	auipc	ra,0x0
    80001e5c:	ab4080e7          	jalr	-1356(ra) # 8000190c <killed>
    80001e60:	e921                	bnez	a0,80001eb0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e62:	70b8                	ld	a4,96(s1)
    80001e64:	6f1c                	ld	a5,24(a4)
    80001e66:	0791                	addi	a5,a5,4
    80001e68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e72:	10079073          	csrw	sstatus,a5
    syscall();
    80001e76:	00000097          	auipc	ra,0x0
    80001e7a:	2d4080e7          	jalr	724(ra) # 8000214a <syscall>
  if(killed(p))
    80001e7e:	8526                	mv	a0,s1
    80001e80:	00000097          	auipc	ra,0x0
    80001e84:	a8c080e7          	jalr	-1396(ra) # 8000190c <killed>
    80001e88:	c911                	beqz	a0,80001e9c <usertrap+0xac>
    80001e8a:	4901                	li	s2,0
    exit(-1);
    80001e8c:	557d                	li	a0,-1
    80001e8e:	00000097          	auipc	ra,0x0
    80001e92:	90a080e7          	jalr	-1782(ra) # 80001798 <exit>
  if(which_dev == 2)
    80001e96:	4789                	li	a5,2
    80001e98:	04f90f63          	beq	s2,a5,80001ef6 <usertrap+0x106>
  usertrapret();
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	dd6080e7          	jalr	-554(ra) # 80001c72 <usertrapret>
}
    80001ea4:	60e2                	ld	ra,24(sp)
    80001ea6:	6442                	ld	s0,16(sp)
    80001ea8:	64a2                	ld	s1,8(sp)
    80001eaa:	6902                	ld	s2,0(sp)
    80001eac:	6105                	addi	sp,sp,32
    80001eae:	8082                	ret
      exit(-1);
    80001eb0:	557d                	li	a0,-1
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	8e6080e7          	jalr	-1818(ra) # 80001798 <exit>
    80001eba:	b765                	j	80001e62 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ebc:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001ec0:	5c90                	lw	a2,56(s1)
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	42e50513          	addi	a0,a0,1070 # 800082f0 <states.0+0x78>
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	e9c080e7          	jalr	-356(ra) # 80005d66 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	44650513          	addi	a0,a0,1094 # 80008320 <states.0+0xa8>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	e84080e7          	jalr	-380(ra) # 80005d66 <printf>
    setkilled(p);
    80001eea:	8526                	mv	a0,s1
    80001eec:	00000097          	auipc	ra,0x0
    80001ef0:	9f4080e7          	jalr	-1548(ra) # 800018e0 <setkilled>
    80001ef4:	b769                	j	80001e7e <usertrap+0x8e>
    yield();
    80001ef6:	fffff097          	auipc	ra,0xfffff
    80001efa:	732080e7          	jalr	1842(ra) # 80001628 <yield>
    80001efe:	bf79                	j	80001e9c <usertrap+0xac>

0000000080001f00 <kerneltrap>:
{
    80001f00:	7179                	addi	sp,sp,-48
    80001f02:	f406                	sd	ra,40(sp)
    80001f04:	f022                	sd	s0,32(sp)
    80001f06:	ec26                	sd	s1,24(sp)
    80001f08:	e84a                	sd	s2,16(sp)
    80001f0a:	e44e                	sd	s3,8(sp)
    80001f0c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f12:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f16:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f1a:	1004f793          	andi	a5,s1,256
    80001f1e:	cb85                	beqz	a5,80001f4e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f20:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f24:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f26:	ef85                	bnez	a5,80001f5e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	e26080e7          	jalr	-474(ra) # 80001d4e <devintr>
    80001f30:	cd1d                	beqz	a0,80001f6e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f32:	4789                	li	a5,2
    80001f34:	06f50a63          	beq	a0,a5,80001fa8 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f38:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f3c:	10049073          	csrw	sstatus,s1
}
    80001f40:	70a2                	ld	ra,40(sp)
    80001f42:	7402                	ld	s0,32(sp)
    80001f44:	64e2                	ld	s1,24(sp)
    80001f46:	6942                	ld	s2,16(sp)
    80001f48:	69a2                	ld	s3,8(sp)
    80001f4a:	6145                	addi	sp,sp,48
    80001f4c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f4e:	00006517          	auipc	a0,0x6
    80001f52:	3f250513          	addi	a0,a0,1010 # 80008340 <states.0+0xc8>
    80001f56:	00004097          	auipc	ra,0x4
    80001f5a:	dc6080e7          	jalr	-570(ra) # 80005d1c <panic>
    panic("kerneltrap: interrupts enabled");
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	40a50513          	addi	a0,a0,1034 # 80008368 <states.0+0xf0>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	db6080e7          	jalr	-586(ra) # 80005d1c <panic>
    printf("scause %p\n", scause);
    80001f6e:	85ce                	mv	a1,s3
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	41850513          	addi	a0,a0,1048 # 80008388 <states.0+0x110>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	dee080e7          	jalr	-530(ra) # 80005d66 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f84:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	41050513          	addi	a0,a0,1040 # 80008398 <states.0+0x120>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	dd6080e7          	jalr	-554(ra) # 80005d66 <printf>
    panic("kerneltrap");
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	41850513          	addi	a0,a0,1048 # 800083b0 <states.0+0x138>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	d7c080e7          	jalr	-644(ra) # 80005d1c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	f96080e7          	jalr	-106(ra) # 80000f3e <myproc>
    80001fb0:	d541                	beqz	a0,80001f38 <kerneltrap+0x38>
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	f8c080e7          	jalr	-116(ra) # 80000f3e <myproc>
    80001fba:	5118                	lw	a4,32(a0)
    80001fbc:	4791                	li	a5,4
    80001fbe:	f6f71de3          	bne	a4,a5,80001f38 <kerneltrap+0x38>
    yield();
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	666080e7          	jalr	1638(ra) # 80001628 <yield>
    80001fca:	b7bd                	j	80001f38 <kerneltrap+0x38>

0000000080001fcc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fcc:	1101                	addi	sp,sp,-32
    80001fce:	ec06                	sd	ra,24(sp)
    80001fd0:	e822                	sd	s0,16(sp)
    80001fd2:	e426                	sd	s1,8(sp)
    80001fd4:	1000                	addi	s0,sp,32
    80001fd6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	f66080e7          	jalr	-154(ra) # 80000f3e <myproc>
  switch (n) {
    80001fe0:	4795                	li	a5,5
    80001fe2:	0497e163          	bltu	a5,s1,80002024 <argraw+0x58>
    80001fe6:	048a                	slli	s1,s1,0x2
    80001fe8:	00006717          	auipc	a4,0x6
    80001fec:	40070713          	addi	a4,a4,1024 # 800083e8 <states.0+0x170>
    80001ff0:	94ba                	add	s1,s1,a4
    80001ff2:	409c                	lw	a5,0(s1)
    80001ff4:	97ba                	add	a5,a5,a4
    80001ff6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ff8:	713c                	ld	a5,96(a0)
    80001ffa:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ffc:	60e2                	ld	ra,24(sp)
    80001ffe:	6442                	ld	s0,16(sp)
    80002000:	64a2                	ld	s1,8(sp)
    80002002:	6105                	addi	sp,sp,32
    80002004:	8082                	ret
    return p->trapframe->a1;
    80002006:	713c                	ld	a5,96(a0)
    80002008:	7fa8                	ld	a0,120(a5)
    8000200a:	bfcd                	j	80001ffc <argraw+0x30>
    return p->trapframe->a2;
    8000200c:	713c                	ld	a5,96(a0)
    8000200e:	63c8                	ld	a0,128(a5)
    80002010:	b7f5                	j	80001ffc <argraw+0x30>
    return p->trapframe->a3;
    80002012:	713c                	ld	a5,96(a0)
    80002014:	67c8                	ld	a0,136(a5)
    80002016:	b7dd                	j	80001ffc <argraw+0x30>
    return p->trapframe->a4;
    80002018:	713c                	ld	a5,96(a0)
    8000201a:	6bc8                	ld	a0,144(a5)
    8000201c:	b7c5                	j	80001ffc <argraw+0x30>
    return p->trapframe->a5;
    8000201e:	713c                	ld	a5,96(a0)
    80002020:	6fc8                	ld	a0,152(a5)
    80002022:	bfe9                	j	80001ffc <argraw+0x30>
  panic("argraw");
    80002024:	00006517          	auipc	a0,0x6
    80002028:	39c50513          	addi	a0,a0,924 # 800083c0 <states.0+0x148>
    8000202c:	00004097          	auipc	ra,0x4
    80002030:	cf0080e7          	jalr	-784(ra) # 80005d1c <panic>

0000000080002034 <fetchaddr>:
{
    80002034:	1101                	addi	sp,sp,-32
    80002036:	ec06                	sd	ra,24(sp)
    80002038:	e822                	sd	s0,16(sp)
    8000203a:	e426                	sd	s1,8(sp)
    8000203c:	e04a                	sd	s2,0(sp)
    8000203e:	1000                	addi	s0,sp,32
    80002040:	84aa                	mv	s1,a0
    80002042:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002044:	fffff097          	auipc	ra,0xfffff
    80002048:	efa080e7          	jalr	-262(ra) # 80000f3e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000204c:	693c                	ld	a5,80(a0)
    8000204e:	02f4f863          	bgeu	s1,a5,8000207e <fetchaddr+0x4a>
    80002052:	00848713          	addi	a4,s1,8
    80002056:	02e7e663          	bltu	a5,a4,80002082 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000205a:	46a1                	li	a3,8
    8000205c:	8626                	mv	a2,s1
    8000205e:	85ca                	mv	a1,s2
    80002060:	6d28                	ld	a0,88(a0)
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	b3e080e7          	jalr	-1218(ra) # 80000ba0 <copyin>
    8000206a:	00a03533          	snez	a0,a0
    8000206e:	40a00533          	neg	a0,a0
}
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	64a2                	ld	s1,8(sp)
    80002078:	6902                	ld	s2,0(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret
    return -1;
    8000207e:	557d                	li	a0,-1
    80002080:	bfcd                	j	80002072 <fetchaddr+0x3e>
    80002082:	557d                	li	a0,-1
    80002084:	b7fd                	j	80002072 <fetchaddr+0x3e>

0000000080002086 <fetchstr>:
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	1800                	addi	s0,sp,48
    80002094:	892a                	mv	s2,a0
    80002096:	84ae                	mv	s1,a1
    80002098:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000209a:	fffff097          	auipc	ra,0xfffff
    8000209e:	ea4080e7          	jalr	-348(ra) # 80000f3e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020a2:	86ce                	mv	a3,s3
    800020a4:	864a                	mv	a2,s2
    800020a6:	85a6                	mv	a1,s1
    800020a8:	6d28                	ld	a0,88(a0)
    800020aa:	fffff097          	auipc	ra,0xfffff
    800020ae:	b84080e7          	jalr	-1148(ra) # 80000c2e <copyinstr>
    800020b2:	00054e63          	bltz	a0,800020ce <fetchstr+0x48>
  return strlen(buf);
    800020b6:	8526                	mv	a0,s1
    800020b8:	ffffe097          	auipc	ra,0xffffe
    800020bc:	23e080e7          	jalr	574(ra) # 800002f6 <strlen>
}
    800020c0:	70a2                	ld	ra,40(sp)
    800020c2:	7402                	ld	s0,32(sp)
    800020c4:	64e2                	ld	s1,24(sp)
    800020c6:	6942                	ld	s2,16(sp)
    800020c8:	69a2                	ld	s3,8(sp)
    800020ca:	6145                	addi	sp,sp,48
    800020cc:	8082                	ret
    return -1;
    800020ce:	557d                	li	a0,-1
    800020d0:	bfc5                	j	800020c0 <fetchstr+0x3a>

00000000800020d2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020d2:	1101                	addi	sp,sp,-32
    800020d4:	ec06                	sd	ra,24(sp)
    800020d6:	e822                	sd	s0,16(sp)
    800020d8:	e426                	sd	s1,8(sp)
    800020da:	1000                	addi	s0,sp,32
    800020dc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	eee080e7          	jalr	-274(ra) # 80001fcc <argraw>
    800020e6:	c088                	sw	a0,0(s1)
}
    800020e8:	60e2                	ld	ra,24(sp)
    800020ea:	6442                	ld	s0,16(sp)
    800020ec:	64a2                	ld	s1,8(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	1000                	addi	s0,sp,32
    800020fc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020fe:	00000097          	auipc	ra,0x0
    80002102:	ece080e7          	jalr	-306(ra) # 80001fcc <argraw>
    80002106:	e088                	sd	a0,0(s1)
}
    80002108:	60e2                	ld	ra,24(sp)
    8000210a:	6442                	ld	s0,16(sp)
    8000210c:	64a2                	ld	s1,8(sp)
    8000210e:	6105                	addi	sp,sp,32
    80002110:	8082                	ret

0000000080002112 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002112:	7179                	addi	sp,sp,-48
    80002114:	f406                	sd	ra,40(sp)
    80002116:	f022                	sd	s0,32(sp)
    80002118:	ec26                	sd	s1,24(sp)
    8000211a:	e84a                	sd	s2,16(sp)
    8000211c:	1800                	addi	s0,sp,48
    8000211e:	84ae                	mv	s1,a1
    80002120:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002122:	fd840593          	addi	a1,s0,-40
    80002126:	00000097          	auipc	ra,0x0
    8000212a:	fcc080e7          	jalr	-52(ra) # 800020f2 <argaddr>
  return fetchstr(addr, buf, max);
    8000212e:	864a                	mv	a2,s2
    80002130:	85a6                	mv	a1,s1
    80002132:	fd843503          	ld	a0,-40(s0)
    80002136:	00000097          	auipc	ra,0x0
    8000213a:	f50080e7          	jalr	-176(ra) # 80002086 <fetchstr>
}
    8000213e:	70a2                	ld	ra,40(sp)
    80002140:	7402                	ld	s0,32(sp)
    80002142:	64e2                	ld	s1,24(sp)
    80002144:	6942                	ld	s2,16(sp)
    80002146:	6145                	addi	sp,sp,48
    80002148:	8082                	ret

000000008000214a <syscall>:



void
syscall(void)
{
    8000214a:	1101                	addi	sp,sp,-32
    8000214c:	ec06                	sd	ra,24(sp)
    8000214e:	e822                	sd	s0,16(sp)
    80002150:	e426                	sd	s1,8(sp)
    80002152:	e04a                	sd	s2,0(sp)
    80002154:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002156:	fffff097          	auipc	ra,0xfffff
    8000215a:	de8080e7          	jalr	-536(ra) # 80000f3e <myproc>
    8000215e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002160:	06053903          	ld	s2,96(a0)
    80002164:	0a893783          	ld	a5,168(s2)
    80002168:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000216c:	37fd                	addiw	a5,a5,-1
    8000216e:	4775                	li	a4,29
    80002170:	00f76f63          	bltu	a4,a5,8000218e <syscall+0x44>
    80002174:	00369713          	slli	a4,a3,0x3
    80002178:	00006797          	auipc	a5,0x6
    8000217c:	28878793          	addi	a5,a5,648 # 80008400 <syscalls>
    80002180:	97ba                	add	a5,a5,a4
    80002182:	639c                	ld	a5,0(a5)
    80002184:	c789                	beqz	a5,8000218e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002186:	9782                	jalr	a5
    80002188:	06a93823          	sd	a0,112(s2)
    8000218c:	a839                	j	800021aa <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000218e:	16048613          	addi	a2,s1,352
    80002192:	5c8c                	lw	a1,56(s1)
    80002194:	00006517          	auipc	a0,0x6
    80002198:	23450513          	addi	a0,a0,564 # 800083c8 <states.0+0x150>
    8000219c:	00004097          	auipc	ra,0x4
    800021a0:	bca080e7          	jalr	-1078(ra) # 80005d66 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021a4:	70bc                	ld	a5,96(s1)
    800021a6:	577d                	li	a4,-1
    800021a8:	fbb8                	sd	a4,112(a5)
  }
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021b6:	1101                	addi	sp,sp,-32
    800021b8:	ec06                	sd	ra,24(sp)
    800021ba:	e822                	sd	s0,16(sp)
    800021bc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021be:	fec40593          	addi	a1,s0,-20
    800021c2:	4501                	li	a0,0
    800021c4:	00000097          	auipc	ra,0x0
    800021c8:	f0e080e7          	jalr	-242(ra) # 800020d2 <argint>
  exit(n);
    800021cc:	fec42503          	lw	a0,-20(s0)
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	5c8080e7          	jalr	1480(ra) # 80001798 <exit>
  return 0;  // not reached
}
    800021d8:	4501                	li	a0,0
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	6105                	addi	sp,sp,32
    800021e0:	8082                	ret

00000000800021e2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021e2:	1141                	addi	sp,sp,-16
    800021e4:	e406                	sd	ra,8(sp)
    800021e6:	e022                	sd	s0,0(sp)
    800021e8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021ea:	fffff097          	auipc	ra,0xfffff
    800021ee:	d54080e7          	jalr	-684(ra) # 80000f3e <myproc>
}
    800021f2:	5d08                	lw	a0,56(a0)
    800021f4:	60a2                	ld	ra,8(sp)
    800021f6:	6402                	ld	s0,0(sp)
    800021f8:	0141                	addi	sp,sp,16
    800021fa:	8082                	ret

00000000800021fc <sys_fork>:

uint64
sys_fork(void)
{
    800021fc:	1141                	addi	sp,sp,-16
    800021fe:	e406                	sd	ra,8(sp)
    80002200:	e022                	sd	s0,0(sp)
    80002202:	0800                	addi	s0,sp,16
  return fork();
    80002204:	fffff097          	auipc	ra,0xfffff
    80002208:	16e080e7          	jalr	366(ra) # 80001372 <fork>
}
    8000220c:	60a2                	ld	ra,8(sp)
    8000220e:	6402                	ld	s0,0(sp)
    80002210:	0141                	addi	sp,sp,16
    80002212:	8082                	ret

0000000080002214 <sys_wait>:

uint64
sys_wait(void)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000221c:	fe840593          	addi	a1,s0,-24
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	ed0080e7          	jalr	-304(ra) # 800020f2 <argaddr>
  return wait(p);
    8000222a:	fe843503          	ld	a0,-24(s0)
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	710080e7          	jalr	1808(ra) # 8000193e <wait>
}
    80002236:	60e2                	ld	ra,24(sp)
    80002238:	6442                	ld	s0,16(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000223e:	7179                	addi	sp,sp,-48
    80002240:	f406                	sd	ra,40(sp)
    80002242:	f022                	sd	s0,32(sp)
    80002244:	ec26                	sd	s1,24(sp)
    80002246:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002248:	fdc40593          	addi	a1,s0,-36
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	e84080e7          	jalr	-380(ra) # 800020d2 <argint>
  addr = myproc()->sz;
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	ce8080e7          	jalr	-792(ra) # 80000f3e <myproc>
    8000225e:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002260:	fdc42503          	lw	a0,-36(s0)
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	0b2080e7          	jalr	178(ra) # 80001316 <growproc>
    8000226c:	00054863          	bltz	a0,8000227c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002270:	8526                	mv	a0,s1
    80002272:	70a2                	ld	ra,40(sp)
    80002274:	7402                	ld	s0,32(sp)
    80002276:	64e2                	ld	s1,24(sp)
    80002278:	6145                	addi	sp,sp,48
    8000227a:	8082                	ret
    return -1;
    8000227c:	54fd                	li	s1,-1
    8000227e:	bfcd                	j	80002270 <sys_sbrk+0x32>

0000000080002280 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002280:	7139                	addi	sp,sp,-64
    80002282:	fc06                	sd	ra,56(sp)
    80002284:	f822                	sd	s0,48(sp)
    80002286:	f426                	sd	s1,40(sp)
    80002288:	f04a                	sd	s2,32(sp)
    8000228a:	ec4e                	sd	s3,24(sp)
    8000228c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000228e:	fcc40593          	addi	a1,s0,-52
    80002292:	4501                	li	a0,0
    80002294:	00000097          	auipc	ra,0x0
    80002298:	e3e080e7          	jalr	-450(ra) # 800020d2 <argint>
  acquire(&tickslock);
    8000229c:	0000c517          	auipc	a0,0xc
    800022a0:	72450513          	addi	a0,a0,1828 # 8000e9c0 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	fb0080e7          	jalr	-80(ra) # 80006254 <acquire>
  ticks0 = ticks;
    800022ac:	00006917          	auipc	s2,0x6
    800022b0:	6a492903          	lw	s2,1700(s2) # 80008950 <ticks>
  while(ticks - ticks0 < n){
    800022b4:	fcc42783          	lw	a5,-52(s0)
    800022b8:	cf9d                	beqz	a5,800022f6 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ba:	0000c997          	auipc	s3,0xc
    800022be:	70698993          	addi	s3,s3,1798 # 8000e9c0 <tickslock>
    800022c2:	00006497          	auipc	s1,0x6
    800022c6:	68e48493          	addi	s1,s1,1678 # 80008950 <ticks>
    if(killed(myproc())){
    800022ca:	fffff097          	auipc	ra,0xfffff
    800022ce:	c74080e7          	jalr	-908(ra) # 80000f3e <myproc>
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	63a080e7          	jalr	1594(ra) # 8000190c <killed>
    800022da:	ed15                	bnez	a0,80002316 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    800022dc:	85ce                	mv	a1,s3
    800022de:	8526                	mv	a0,s1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	384080e7          	jalr	900(ra) # 80001664 <sleep>
  while(ticks - ticks0 < n){
    800022e8:	409c                	lw	a5,0(s1)
    800022ea:	412787bb          	subw	a5,a5,s2
    800022ee:	fcc42703          	lw	a4,-52(s0)
    800022f2:	fce7ece3          	bltu	a5,a4,800022ca <sys_sleep+0x4a>
  }
  release(&tickslock);
    800022f6:	0000c517          	auipc	a0,0xc
    800022fa:	6ca50513          	addi	a0,a0,1738 # 8000e9c0 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	00a080e7          	jalr	10(ra) # 80006308 <release>
  return 0;
    80002306:	4501                	li	a0,0
}
    80002308:	70e2                	ld	ra,56(sp)
    8000230a:	7442                	ld	s0,48(sp)
    8000230c:	74a2                	ld	s1,40(sp)
    8000230e:	7902                	ld	s2,32(sp)
    80002310:	69e2                	ld	s3,24(sp)
    80002312:	6121                	addi	sp,sp,64
    80002314:	8082                	ret
      release(&tickslock);
    80002316:	0000c517          	auipc	a0,0xc
    8000231a:	6aa50513          	addi	a0,a0,1706 # 8000e9c0 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	fea080e7          	jalr	-22(ra) # 80006308 <release>
      return -1;
    80002326:	557d                	li	a0,-1
    80002328:	b7c5                	j	80002308 <sys_sleep+0x88>

000000008000232a <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000232a:	1141                	addi	sp,sp,-16
    8000232c:	e422                	sd	s0,8(sp)
    8000232e:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002330:	4501                	li	a0,0
    80002332:	6422                	ld	s0,8(sp)
    80002334:	0141                	addi	sp,sp,16
    80002336:	8082                	ret

0000000080002338 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002338:	1101                	addi	sp,sp,-32
    8000233a:	ec06                	sd	ra,24(sp)
    8000233c:	e822                	sd	s0,16(sp)
    8000233e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002340:	fec40593          	addi	a1,s0,-20
    80002344:	4501                	li	a0,0
    80002346:	00000097          	auipc	ra,0x0
    8000234a:	d8c080e7          	jalr	-628(ra) # 800020d2 <argint>
  return kill(pid);
    8000234e:	fec42503          	lw	a0,-20(s0)
    80002352:	fffff097          	auipc	ra,0xfffff
    80002356:	51c080e7          	jalr	1308(ra) # 8000186e <kill>
}
    8000235a:	60e2                	ld	ra,24(sp)
    8000235c:	6442                	ld	s0,16(sp)
    8000235e:	6105                	addi	sp,sp,32
    80002360:	8082                	ret

0000000080002362 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002362:	1101                	addi	sp,sp,-32
    80002364:	ec06                	sd	ra,24(sp)
    80002366:	e822                	sd	s0,16(sp)
    80002368:	e426                	sd	s1,8(sp)
    8000236a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000236c:	0000c517          	auipc	a0,0xc
    80002370:	65450513          	addi	a0,a0,1620 # 8000e9c0 <tickslock>
    80002374:	00004097          	auipc	ra,0x4
    80002378:	ee0080e7          	jalr	-288(ra) # 80006254 <acquire>
  xticks = ticks;
    8000237c:	00006497          	auipc	s1,0x6
    80002380:	5d44a483          	lw	s1,1492(s1) # 80008950 <ticks>
  release(&tickslock);
    80002384:	0000c517          	auipc	a0,0xc
    80002388:	63c50513          	addi	a0,a0,1596 # 8000e9c0 <tickslock>
    8000238c:	00004097          	auipc	ra,0x4
    80002390:	f7c080e7          	jalr	-132(ra) # 80006308 <release>
  return xticks;
}
    80002394:	02049513          	slli	a0,s1,0x20
    80002398:	9101                	srli	a0,a0,0x20
    8000239a:	60e2                	ld	ra,24(sp)
    8000239c:	6442                	ld	s0,16(sp)
    8000239e:	64a2                	ld	s1,8(sp)
    800023a0:	6105                	addi	sp,sp,32
    800023a2:	8082                	ret

00000000800023a4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023a4:	7179                	addi	sp,sp,-48
    800023a6:	f406                	sd	ra,40(sp)
    800023a8:	f022                	sd	s0,32(sp)
    800023aa:	ec26                	sd	s1,24(sp)
    800023ac:	e84a                	sd	s2,16(sp)
    800023ae:	e44e                	sd	s3,8(sp)
    800023b0:	e052                	sd	s4,0(sp)
    800023b2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023b4:	00006597          	auipc	a1,0x6
    800023b8:	14458593          	addi	a1,a1,324 # 800084f8 <syscalls+0xf8>
    800023bc:	0000c517          	auipc	a0,0xc
    800023c0:	61c50513          	addi	a0,a0,1564 # 8000e9d8 <bcache>
    800023c4:	00004097          	auipc	ra,0x4
    800023c8:	e00080e7          	jalr	-512(ra) # 800061c4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023cc:	00014797          	auipc	a5,0x14
    800023d0:	60c78793          	addi	a5,a5,1548 # 800169d8 <bcache+0x8000>
    800023d4:	00015717          	auipc	a4,0x15
    800023d8:	86c70713          	addi	a4,a4,-1940 # 80016c40 <bcache+0x8268>
    800023dc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023e0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e4:	0000c497          	auipc	s1,0xc
    800023e8:	60c48493          	addi	s1,s1,1548 # 8000e9f0 <bcache+0x18>
    b->next = bcache.head.next;
    800023ec:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023ee:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023f0:	00006a17          	auipc	s4,0x6
    800023f4:	110a0a13          	addi	s4,s4,272 # 80008500 <syscalls+0x100>
    b->next = bcache.head.next;
    800023f8:	2b893783          	ld	a5,696(s2)
    800023fc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023fe:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002402:	85d2                	mv	a1,s4
    80002404:	01048513          	addi	a0,s1,16
    80002408:	00001097          	auipc	ra,0x1
    8000240c:	4c8080e7          	jalr	1224(ra) # 800038d0 <initsleeplock>
    bcache.head.next->prev = b;
    80002410:	2b893783          	ld	a5,696(s2)
    80002414:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002416:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241a:	45848493          	addi	s1,s1,1112
    8000241e:	fd349de3          	bne	s1,s3,800023f8 <binit+0x54>
  }
}
    80002422:	70a2                	ld	ra,40(sp)
    80002424:	7402                	ld	s0,32(sp)
    80002426:	64e2                	ld	s1,24(sp)
    80002428:	6942                	ld	s2,16(sp)
    8000242a:	69a2                	ld	s3,8(sp)
    8000242c:	6a02                	ld	s4,0(sp)
    8000242e:	6145                	addi	sp,sp,48
    80002430:	8082                	ret

0000000080002432 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002432:	7179                	addi	sp,sp,-48
    80002434:	f406                	sd	ra,40(sp)
    80002436:	f022                	sd	s0,32(sp)
    80002438:	ec26                	sd	s1,24(sp)
    8000243a:	e84a                	sd	s2,16(sp)
    8000243c:	e44e                	sd	s3,8(sp)
    8000243e:	1800                	addi	s0,sp,48
    80002440:	892a                	mv	s2,a0
    80002442:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002444:	0000c517          	auipc	a0,0xc
    80002448:	59450513          	addi	a0,a0,1428 # 8000e9d8 <bcache>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	e08080e7          	jalr	-504(ra) # 80006254 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002454:	00015497          	auipc	s1,0x15
    80002458:	83c4b483          	ld	s1,-1988(s1) # 80016c90 <bcache+0x82b8>
    8000245c:	00014797          	auipc	a5,0x14
    80002460:	7e478793          	addi	a5,a5,2020 # 80016c40 <bcache+0x8268>
    80002464:	02f48f63          	beq	s1,a5,800024a2 <bread+0x70>
    80002468:	873e                	mv	a4,a5
    8000246a:	a021                	j	80002472 <bread+0x40>
    8000246c:	68a4                	ld	s1,80(s1)
    8000246e:	02e48a63          	beq	s1,a4,800024a2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002472:	449c                	lw	a5,8(s1)
    80002474:	ff279ce3          	bne	a5,s2,8000246c <bread+0x3a>
    80002478:	44dc                	lw	a5,12(s1)
    8000247a:	ff3799e3          	bne	a5,s3,8000246c <bread+0x3a>
      b->refcnt++;
    8000247e:	40bc                	lw	a5,64(s1)
    80002480:	2785                	addiw	a5,a5,1
    80002482:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002484:	0000c517          	auipc	a0,0xc
    80002488:	55450513          	addi	a0,a0,1364 # 8000e9d8 <bcache>
    8000248c:	00004097          	auipc	ra,0x4
    80002490:	e7c080e7          	jalr	-388(ra) # 80006308 <release>
      acquiresleep(&b->lock);
    80002494:	01048513          	addi	a0,s1,16
    80002498:	00001097          	auipc	ra,0x1
    8000249c:	472080e7          	jalr	1138(ra) # 8000390a <acquiresleep>
      return b;
    800024a0:	a8b9                	j	800024fe <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024a2:	00014497          	auipc	s1,0x14
    800024a6:	7e64b483          	ld	s1,2022(s1) # 80016c88 <bcache+0x82b0>
    800024aa:	00014797          	auipc	a5,0x14
    800024ae:	79678793          	addi	a5,a5,1942 # 80016c40 <bcache+0x8268>
    800024b2:	00f48863          	beq	s1,a5,800024c2 <bread+0x90>
    800024b6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024b8:	40bc                	lw	a5,64(s1)
    800024ba:	cf81                	beqz	a5,800024d2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024bc:	64a4                	ld	s1,72(s1)
    800024be:	fee49de3          	bne	s1,a4,800024b8 <bread+0x86>
  panic("bget: no buffers");
    800024c2:	00006517          	auipc	a0,0x6
    800024c6:	04650513          	addi	a0,a0,70 # 80008508 <syscalls+0x108>
    800024ca:	00004097          	auipc	ra,0x4
    800024ce:	852080e7          	jalr	-1966(ra) # 80005d1c <panic>
      b->dev = dev;
    800024d2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800024d6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024da:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024de:	4785                	li	a5,1
    800024e0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024e2:	0000c517          	auipc	a0,0xc
    800024e6:	4f650513          	addi	a0,a0,1270 # 8000e9d8 <bcache>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	e1e080e7          	jalr	-482(ra) # 80006308 <release>
      acquiresleep(&b->lock);
    800024f2:	01048513          	addi	a0,s1,16
    800024f6:	00001097          	auipc	ra,0x1
    800024fa:	414080e7          	jalr	1044(ra) # 8000390a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024fe:	409c                	lw	a5,0(s1)
    80002500:	cb89                	beqz	a5,80002512 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002502:	8526                	mv	a0,s1
    80002504:	70a2                	ld	ra,40(sp)
    80002506:	7402                	ld	s0,32(sp)
    80002508:	64e2                	ld	s1,24(sp)
    8000250a:	6942                	ld	s2,16(sp)
    8000250c:	69a2                	ld	s3,8(sp)
    8000250e:	6145                	addi	sp,sp,48
    80002510:	8082                	ret
    virtio_disk_rw(b, 0);
    80002512:	4581                	li	a1,0
    80002514:	8526                	mv	a0,s1
    80002516:	00003097          	auipc	ra,0x3
    8000251a:	ffc080e7          	jalr	-4(ra) # 80005512 <virtio_disk_rw>
    b->valid = 1;
    8000251e:	4785                	li	a5,1
    80002520:	c09c                	sw	a5,0(s1)
  return b;
    80002522:	b7c5                	j	80002502 <bread+0xd0>

0000000080002524 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002524:	1101                	addi	sp,sp,-32
    80002526:	ec06                	sd	ra,24(sp)
    80002528:	e822                	sd	s0,16(sp)
    8000252a:	e426                	sd	s1,8(sp)
    8000252c:	1000                	addi	s0,sp,32
    8000252e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002530:	0541                	addi	a0,a0,16
    80002532:	00001097          	auipc	ra,0x1
    80002536:	472080e7          	jalr	1138(ra) # 800039a4 <holdingsleep>
    8000253a:	cd01                	beqz	a0,80002552 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000253c:	4585                	li	a1,1
    8000253e:	8526                	mv	a0,s1
    80002540:	00003097          	auipc	ra,0x3
    80002544:	fd2080e7          	jalr	-46(ra) # 80005512 <virtio_disk_rw>
}
    80002548:	60e2                	ld	ra,24(sp)
    8000254a:	6442                	ld	s0,16(sp)
    8000254c:	64a2                	ld	s1,8(sp)
    8000254e:	6105                	addi	sp,sp,32
    80002550:	8082                	ret
    panic("bwrite");
    80002552:	00006517          	auipc	a0,0x6
    80002556:	fce50513          	addi	a0,a0,-50 # 80008520 <syscalls+0x120>
    8000255a:	00003097          	auipc	ra,0x3
    8000255e:	7c2080e7          	jalr	1986(ra) # 80005d1c <panic>

0000000080002562 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002562:	1101                	addi	sp,sp,-32
    80002564:	ec06                	sd	ra,24(sp)
    80002566:	e822                	sd	s0,16(sp)
    80002568:	e426                	sd	s1,8(sp)
    8000256a:	e04a                	sd	s2,0(sp)
    8000256c:	1000                	addi	s0,sp,32
    8000256e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002570:	01050913          	addi	s2,a0,16
    80002574:	854a                	mv	a0,s2
    80002576:	00001097          	auipc	ra,0x1
    8000257a:	42e080e7          	jalr	1070(ra) # 800039a4 <holdingsleep>
    8000257e:	c92d                	beqz	a0,800025f0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002580:	854a                	mv	a0,s2
    80002582:	00001097          	auipc	ra,0x1
    80002586:	3de080e7          	jalr	990(ra) # 80003960 <releasesleep>

  acquire(&bcache.lock);
    8000258a:	0000c517          	auipc	a0,0xc
    8000258e:	44e50513          	addi	a0,a0,1102 # 8000e9d8 <bcache>
    80002592:	00004097          	auipc	ra,0x4
    80002596:	cc2080e7          	jalr	-830(ra) # 80006254 <acquire>
  b->refcnt--;
    8000259a:	40bc                	lw	a5,64(s1)
    8000259c:	37fd                	addiw	a5,a5,-1
    8000259e:	0007871b          	sext.w	a4,a5
    800025a2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025a4:	eb05                	bnez	a4,800025d4 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025a6:	68bc                	ld	a5,80(s1)
    800025a8:	64b8                	ld	a4,72(s1)
    800025aa:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025ac:	64bc                	ld	a5,72(s1)
    800025ae:	68b8                	ld	a4,80(s1)
    800025b0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025b2:	00014797          	auipc	a5,0x14
    800025b6:	42678793          	addi	a5,a5,1062 # 800169d8 <bcache+0x8000>
    800025ba:	2b87b703          	ld	a4,696(a5)
    800025be:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025c0:	00014717          	auipc	a4,0x14
    800025c4:	68070713          	addi	a4,a4,1664 # 80016c40 <bcache+0x8268>
    800025c8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025ca:	2b87b703          	ld	a4,696(a5)
    800025ce:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025d0:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025d4:	0000c517          	auipc	a0,0xc
    800025d8:	40450513          	addi	a0,a0,1028 # 8000e9d8 <bcache>
    800025dc:	00004097          	auipc	ra,0x4
    800025e0:	d2c080e7          	jalr	-724(ra) # 80006308 <release>
}
    800025e4:	60e2                	ld	ra,24(sp)
    800025e6:	6442                	ld	s0,16(sp)
    800025e8:	64a2                	ld	s1,8(sp)
    800025ea:	6902                	ld	s2,0(sp)
    800025ec:	6105                	addi	sp,sp,32
    800025ee:	8082                	ret
    panic("brelse");
    800025f0:	00006517          	auipc	a0,0x6
    800025f4:	f3850513          	addi	a0,a0,-200 # 80008528 <syscalls+0x128>
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	724080e7          	jalr	1828(ra) # 80005d1c <panic>

0000000080002600 <bpin>:

void
bpin(struct buf *b) {
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260c:	0000c517          	auipc	a0,0xc
    80002610:	3cc50513          	addi	a0,a0,972 # 8000e9d8 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	c40080e7          	jalr	-960(ra) # 80006254 <acquire>
  b->refcnt++;
    8000261c:	40bc                	lw	a5,64(s1)
    8000261e:	2785                	addiw	a5,a5,1
    80002620:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002622:	0000c517          	auipc	a0,0xc
    80002626:	3b650513          	addi	a0,a0,950 # 8000e9d8 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	cde080e7          	jalr	-802(ra) # 80006308 <release>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <bunpin>:

void
bunpin(struct buf *b) {
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	1000                	addi	s0,sp,32
    80002646:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002648:	0000c517          	auipc	a0,0xc
    8000264c:	39050513          	addi	a0,a0,912 # 8000e9d8 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	c04080e7          	jalr	-1020(ra) # 80006254 <acquire>
  b->refcnt--;
    80002658:	40bc                	lw	a5,64(s1)
    8000265a:	37fd                	addiw	a5,a5,-1
    8000265c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265e:	0000c517          	auipc	a0,0xc
    80002662:	37a50513          	addi	a0,a0,890 # 8000e9d8 <bcache>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	ca2080e7          	jalr	-862(ra) # 80006308 <release>
}
    8000266e:	60e2                	ld	ra,24(sp)
    80002670:	6442                	ld	s0,16(sp)
    80002672:	64a2                	ld	s1,8(sp)
    80002674:	6105                	addi	sp,sp,32
    80002676:	8082                	ret

0000000080002678 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002678:	1101                	addi	sp,sp,-32
    8000267a:	ec06                	sd	ra,24(sp)
    8000267c:	e822                	sd	s0,16(sp)
    8000267e:	e426                	sd	s1,8(sp)
    80002680:	e04a                	sd	s2,0(sp)
    80002682:	1000                	addi	s0,sp,32
    80002684:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002686:	00d5d59b          	srliw	a1,a1,0xd
    8000268a:	00015797          	auipc	a5,0x15
    8000268e:	a2a7a783          	lw	a5,-1494(a5) # 800170b4 <sb+0x1c>
    80002692:	9dbd                	addw	a1,a1,a5
    80002694:	00000097          	auipc	ra,0x0
    80002698:	d9e080e7          	jalr	-610(ra) # 80002432 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000269c:	0074f713          	andi	a4,s1,7
    800026a0:	4785                	li	a5,1
    800026a2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026a6:	14ce                	slli	s1,s1,0x33
    800026a8:	90d9                	srli	s1,s1,0x36
    800026aa:	00950733          	add	a4,a0,s1
    800026ae:	05874703          	lbu	a4,88(a4)
    800026b2:	00e7f6b3          	and	a3,a5,a4
    800026b6:	c69d                	beqz	a3,800026e4 <bfree+0x6c>
    800026b8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ba:	94aa                	add	s1,s1,a0
    800026bc:	fff7c793          	not	a5,a5
    800026c0:	8f7d                	and	a4,a4,a5
    800026c2:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026c6:	00001097          	auipc	ra,0x1
    800026ca:	126080e7          	jalr	294(ra) # 800037ec <log_write>
  brelse(bp);
    800026ce:	854a                	mv	a0,s2
    800026d0:	00000097          	auipc	ra,0x0
    800026d4:	e92080e7          	jalr	-366(ra) # 80002562 <brelse>
}
    800026d8:	60e2                	ld	ra,24(sp)
    800026da:	6442                	ld	s0,16(sp)
    800026dc:	64a2                	ld	s1,8(sp)
    800026de:	6902                	ld	s2,0(sp)
    800026e0:	6105                	addi	sp,sp,32
    800026e2:	8082                	ret
    panic("freeing free block");
    800026e4:	00006517          	auipc	a0,0x6
    800026e8:	e4c50513          	addi	a0,a0,-436 # 80008530 <syscalls+0x130>
    800026ec:	00003097          	auipc	ra,0x3
    800026f0:	630080e7          	jalr	1584(ra) # 80005d1c <panic>

00000000800026f4 <balloc>:
{
    800026f4:	711d                	addi	sp,sp,-96
    800026f6:	ec86                	sd	ra,88(sp)
    800026f8:	e8a2                	sd	s0,80(sp)
    800026fa:	e4a6                	sd	s1,72(sp)
    800026fc:	e0ca                	sd	s2,64(sp)
    800026fe:	fc4e                	sd	s3,56(sp)
    80002700:	f852                	sd	s4,48(sp)
    80002702:	f456                	sd	s5,40(sp)
    80002704:	f05a                	sd	s6,32(sp)
    80002706:	ec5e                	sd	s7,24(sp)
    80002708:	e862                	sd	s8,16(sp)
    8000270a:	e466                	sd	s9,8(sp)
    8000270c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000270e:	00015797          	auipc	a5,0x15
    80002712:	98e7a783          	lw	a5,-1650(a5) # 8001709c <sb+0x4>
    80002716:	cff5                	beqz	a5,80002812 <balloc+0x11e>
    80002718:	8baa                	mv	s7,a0
    8000271a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000271c:	00015b17          	auipc	s6,0x15
    80002720:	97cb0b13          	addi	s6,s6,-1668 # 80017098 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002724:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002726:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002728:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000272a:	6c89                	lui	s9,0x2
    8000272c:	a061                	j	800027b4 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000272e:	97ca                	add	a5,a5,s2
    80002730:	8e55                	or	a2,a2,a3
    80002732:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002736:	854a                	mv	a0,s2
    80002738:	00001097          	auipc	ra,0x1
    8000273c:	0b4080e7          	jalr	180(ra) # 800037ec <log_write>
        brelse(bp);
    80002740:	854a                	mv	a0,s2
    80002742:	00000097          	auipc	ra,0x0
    80002746:	e20080e7          	jalr	-480(ra) # 80002562 <brelse>
  bp = bread(dev, bno);
    8000274a:	85a6                	mv	a1,s1
    8000274c:	855e                	mv	a0,s7
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	ce4080e7          	jalr	-796(ra) # 80002432 <bread>
    80002756:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002758:	40000613          	li	a2,1024
    8000275c:	4581                	li	a1,0
    8000275e:	05850513          	addi	a0,a0,88
    80002762:	ffffe097          	auipc	ra,0xffffe
    80002766:	a18080e7          	jalr	-1512(ra) # 8000017a <memset>
  log_write(bp);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00001097          	auipc	ra,0x1
    80002770:	080080e7          	jalr	128(ra) # 800037ec <log_write>
  brelse(bp);
    80002774:	854a                	mv	a0,s2
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	dec080e7          	jalr	-532(ra) # 80002562 <brelse>
}
    8000277e:	8526                	mv	a0,s1
    80002780:	60e6                	ld	ra,88(sp)
    80002782:	6446                	ld	s0,80(sp)
    80002784:	64a6                	ld	s1,72(sp)
    80002786:	6906                	ld	s2,64(sp)
    80002788:	79e2                	ld	s3,56(sp)
    8000278a:	7a42                	ld	s4,48(sp)
    8000278c:	7aa2                	ld	s5,40(sp)
    8000278e:	7b02                	ld	s6,32(sp)
    80002790:	6be2                	ld	s7,24(sp)
    80002792:	6c42                	ld	s8,16(sp)
    80002794:	6ca2                	ld	s9,8(sp)
    80002796:	6125                	addi	sp,sp,96
    80002798:	8082                	ret
    brelse(bp);
    8000279a:	854a                	mv	a0,s2
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	dc6080e7          	jalr	-570(ra) # 80002562 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027a4:	015c87bb          	addw	a5,s9,s5
    800027a8:	00078a9b          	sext.w	s5,a5
    800027ac:	004b2703          	lw	a4,4(s6)
    800027b0:	06eaf163          	bgeu	s5,a4,80002812 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027b4:	41fad79b          	sraiw	a5,s5,0x1f
    800027b8:	0137d79b          	srliw	a5,a5,0x13
    800027bc:	015787bb          	addw	a5,a5,s5
    800027c0:	40d7d79b          	sraiw	a5,a5,0xd
    800027c4:	01cb2583          	lw	a1,28(s6)
    800027c8:	9dbd                	addw	a1,a1,a5
    800027ca:	855e                	mv	a0,s7
    800027cc:	00000097          	auipc	ra,0x0
    800027d0:	c66080e7          	jalr	-922(ra) # 80002432 <bread>
    800027d4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027d6:	004b2503          	lw	a0,4(s6)
    800027da:	000a849b          	sext.w	s1,s5
    800027de:	8762                	mv	a4,s8
    800027e0:	faa4fde3          	bgeu	s1,a0,8000279a <balloc+0xa6>
      m = 1 << (bi % 8);
    800027e4:	00777693          	andi	a3,a4,7
    800027e8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027ec:	41f7579b          	sraiw	a5,a4,0x1f
    800027f0:	01d7d79b          	srliw	a5,a5,0x1d
    800027f4:	9fb9                	addw	a5,a5,a4
    800027f6:	4037d79b          	sraiw	a5,a5,0x3
    800027fa:	00f90633          	add	a2,s2,a5
    800027fe:	05864603          	lbu	a2,88(a2)
    80002802:	00c6f5b3          	and	a1,a3,a2
    80002806:	d585                	beqz	a1,8000272e <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	2705                	addiw	a4,a4,1
    8000280a:	2485                	addiw	s1,s1,1
    8000280c:	fd471ae3          	bne	a4,s4,800027e0 <balloc+0xec>
    80002810:	b769                	j	8000279a <balloc+0xa6>
  printf("balloc: out of blocks\n");
    80002812:	00006517          	auipc	a0,0x6
    80002816:	d3650513          	addi	a0,a0,-714 # 80008548 <syscalls+0x148>
    8000281a:	00003097          	auipc	ra,0x3
    8000281e:	54c080e7          	jalr	1356(ra) # 80005d66 <printf>
  return 0;
    80002822:	4481                	li	s1,0
    80002824:	bfa9                	j	8000277e <balloc+0x8a>

0000000080002826 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002826:	7179                	addi	sp,sp,-48
    80002828:	f406                	sd	ra,40(sp)
    8000282a:	f022                	sd	s0,32(sp)
    8000282c:	ec26                	sd	s1,24(sp)
    8000282e:	e84a                	sd	s2,16(sp)
    80002830:	e44e                	sd	s3,8(sp)
    80002832:	e052                	sd	s4,0(sp)
    80002834:	1800                	addi	s0,sp,48
    80002836:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002838:	47ad                	li	a5,11
    8000283a:	02b7e863          	bltu	a5,a1,8000286a <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    8000283e:	02059793          	slli	a5,a1,0x20
    80002842:	01e7d593          	srli	a1,a5,0x1e
    80002846:	00b504b3          	add	s1,a0,a1
    8000284a:	0504a903          	lw	s2,80(s1)
    8000284e:	06091e63          	bnez	s2,800028ca <bmap+0xa4>
      addr = balloc(ip->dev);
    80002852:	4108                	lw	a0,0(a0)
    80002854:	00000097          	auipc	ra,0x0
    80002858:	ea0080e7          	jalr	-352(ra) # 800026f4 <balloc>
    8000285c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002860:	06090563          	beqz	s2,800028ca <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002864:	0524a823          	sw	s2,80(s1)
    80002868:	a08d                	j	800028ca <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000286a:	ff45849b          	addiw	s1,a1,-12
    8000286e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002872:	0ff00793          	li	a5,255
    80002876:	08e7e563          	bltu	a5,a4,80002900 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000287a:	08052903          	lw	s2,128(a0)
    8000287e:	00091d63          	bnez	s2,80002898 <bmap+0x72>
      addr = balloc(ip->dev);
    80002882:	4108                	lw	a0,0(a0)
    80002884:	00000097          	auipc	ra,0x0
    80002888:	e70080e7          	jalr	-400(ra) # 800026f4 <balloc>
    8000288c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002890:	02090d63          	beqz	s2,800028ca <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002894:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002898:	85ca                	mv	a1,s2
    8000289a:	0009a503          	lw	a0,0(s3)
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	b94080e7          	jalr	-1132(ra) # 80002432 <bread>
    800028a6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028a8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028ac:	02049713          	slli	a4,s1,0x20
    800028b0:	01e75593          	srli	a1,a4,0x1e
    800028b4:	00b784b3          	add	s1,a5,a1
    800028b8:	0004a903          	lw	s2,0(s1)
    800028bc:	02090063          	beqz	s2,800028dc <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028c0:	8552                	mv	a0,s4
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	ca0080e7          	jalr	-864(ra) # 80002562 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028ca:	854a                	mv	a0,s2
    800028cc:	70a2                	ld	ra,40(sp)
    800028ce:	7402                	ld	s0,32(sp)
    800028d0:	64e2                	ld	s1,24(sp)
    800028d2:	6942                	ld	s2,16(sp)
    800028d4:	69a2                	ld	s3,8(sp)
    800028d6:	6a02                	ld	s4,0(sp)
    800028d8:	6145                	addi	sp,sp,48
    800028da:	8082                	ret
      addr = balloc(ip->dev);
    800028dc:	0009a503          	lw	a0,0(s3)
    800028e0:	00000097          	auipc	ra,0x0
    800028e4:	e14080e7          	jalr	-492(ra) # 800026f4 <balloc>
    800028e8:	0005091b          	sext.w	s2,a0
      if(addr){
    800028ec:	fc090ae3          	beqz	s2,800028c0 <bmap+0x9a>
        a[bn] = addr;
    800028f0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028f4:	8552                	mv	a0,s4
    800028f6:	00001097          	auipc	ra,0x1
    800028fa:	ef6080e7          	jalr	-266(ra) # 800037ec <log_write>
    800028fe:	b7c9                	j	800028c0 <bmap+0x9a>
  panic("bmap: out of range");
    80002900:	00006517          	auipc	a0,0x6
    80002904:	c6050513          	addi	a0,a0,-928 # 80008560 <syscalls+0x160>
    80002908:	00003097          	auipc	ra,0x3
    8000290c:	414080e7          	jalr	1044(ra) # 80005d1c <panic>

0000000080002910 <iget>:
{
    80002910:	7179                	addi	sp,sp,-48
    80002912:	f406                	sd	ra,40(sp)
    80002914:	f022                	sd	s0,32(sp)
    80002916:	ec26                	sd	s1,24(sp)
    80002918:	e84a                	sd	s2,16(sp)
    8000291a:	e44e                	sd	s3,8(sp)
    8000291c:	e052                	sd	s4,0(sp)
    8000291e:	1800                	addi	s0,sp,48
    80002920:	89aa                	mv	s3,a0
    80002922:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002924:	00014517          	auipc	a0,0x14
    80002928:	79450513          	addi	a0,a0,1940 # 800170b8 <itable>
    8000292c:	00004097          	auipc	ra,0x4
    80002930:	928080e7          	jalr	-1752(ra) # 80006254 <acquire>
  empty = 0;
    80002934:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002936:	00014497          	auipc	s1,0x14
    8000293a:	79a48493          	addi	s1,s1,1946 # 800170d0 <itable+0x18>
    8000293e:	00016697          	auipc	a3,0x16
    80002942:	22268693          	addi	a3,a3,546 # 80018b60 <log>
    80002946:	a039                	j	80002954 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002948:	02090b63          	beqz	s2,8000297e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000294c:	08848493          	addi	s1,s1,136
    80002950:	02d48a63          	beq	s1,a3,80002984 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002954:	449c                	lw	a5,8(s1)
    80002956:	fef059e3          	blez	a5,80002948 <iget+0x38>
    8000295a:	4098                	lw	a4,0(s1)
    8000295c:	ff3716e3          	bne	a4,s3,80002948 <iget+0x38>
    80002960:	40d8                	lw	a4,4(s1)
    80002962:	ff4713e3          	bne	a4,s4,80002948 <iget+0x38>
      ip->ref++;
    80002966:	2785                	addiw	a5,a5,1
    80002968:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000296a:	00014517          	auipc	a0,0x14
    8000296e:	74e50513          	addi	a0,a0,1870 # 800170b8 <itable>
    80002972:	00004097          	auipc	ra,0x4
    80002976:	996080e7          	jalr	-1642(ra) # 80006308 <release>
      return ip;
    8000297a:	8926                	mv	s2,s1
    8000297c:	a03d                	j	800029aa <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000297e:	f7f9                	bnez	a5,8000294c <iget+0x3c>
    80002980:	8926                	mv	s2,s1
    80002982:	b7e9                	j	8000294c <iget+0x3c>
  if(empty == 0)
    80002984:	02090c63          	beqz	s2,800029bc <iget+0xac>
  ip->dev = dev;
    80002988:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000298c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002990:	4785                	li	a5,1
    80002992:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002996:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000299a:	00014517          	auipc	a0,0x14
    8000299e:	71e50513          	addi	a0,a0,1822 # 800170b8 <itable>
    800029a2:	00004097          	auipc	ra,0x4
    800029a6:	966080e7          	jalr	-1690(ra) # 80006308 <release>
}
    800029aa:	854a                	mv	a0,s2
    800029ac:	70a2                	ld	ra,40(sp)
    800029ae:	7402                	ld	s0,32(sp)
    800029b0:	64e2                	ld	s1,24(sp)
    800029b2:	6942                	ld	s2,16(sp)
    800029b4:	69a2                	ld	s3,8(sp)
    800029b6:	6a02                	ld	s4,0(sp)
    800029b8:	6145                	addi	sp,sp,48
    800029ba:	8082                	ret
    panic("iget: no inodes");
    800029bc:	00006517          	auipc	a0,0x6
    800029c0:	bbc50513          	addi	a0,a0,-1092 # 80008578 <syscalls+0x178>
    800029c4:	00003097          	auipc	ra,0x3
    800029c8:	358080e7          	jalr	856(ra) # 80005d1c <panic>

00000000800029cc <fsinit>:
fsinit(int dev) {
    800029cc:	7179                	addi	sp,sp,-48
    800029ce:	f406                	sd	ra,40(sp)
    800029d0:	f022                	sd	s0,32(sp)
    800029d2:	ec26                	sd	s1,24(sp)
    800029d4:	e84a                	sd	s2,16(sp)
    800029d6:	e44e                	sd	s3,8(sp)
    800029d8:	1800                	addi	s0,sp,48
    800029da:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029dc:	4585                	li	a1,1
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	a54080e7          	jalr	-1452(ra) # 80002432 <bread>
    800029e6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029e8:	00014997          	auipc	s3,0x14
    800029ec:	6b098993          	addi	s3,s3,1712 # 80017098 <sb>
    800029f0:	02000613          	li	a2,32
    800029f4:	05850593          	addi	a1,a0,88
    800029f8:	854e                	mv	a0,s3
    800029fa:	ffffd097          	auipc	ra,0xffffd
    800029fe:	7dc080e7          	jalr	2012(ra) # 800001d6 <memmove>
  brelse(bp);
    80002a02:	8526                	mv	a0,s1
    80002a04:	00000097          	auipc	ra,0x0
    80002a08:	b5e080e7          	jalr	-1186(ra) # 80002562 <brelse>
  if(sb.magic != FSMAGIC)
    80002a0c:	0009a703          	lw	a4,0(s3)
    80002a10:	102037b7          	lui	a5,0x10203
    80002a14:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a18:	02f71263          	bne	a4,a5,80002a3c <fsinit+0x70>
  initlog(dev, &sb);
    80002a1c:	00014597          	auipc	a1,0x14
    80002a20:	67c58593          	addi	a1,a1,1660 # 80017098 <sb>
    80002a24:	854a                	mv	a0,s2
    80002a26:	00001097          	auipc	ra,0x1
    80002a2a:	b4a080e7          	jalr	-1206(ra) # 80003570 <initlog>
}
    80002a2e:	70a2                	ld	ra,40(sp)
    80002a30:	7402                	ld	s0,32(sp)
    80002a32:	64e2                	ld	s1,24(sp)
    80002a34:	6942                	ld	s2,16(sp)
    80002a36:	69a2                	ld	s3,8(sp)
    80002a38:	6145                	addi	sp,sp,48
    80002a3a:	8082                	ret
    panic("invalid file system");
    80002a3c:	00006517          	auipc	a0,0x6
    80002a40:	b4c50513          	addi	a0,a0,-1204 # 80008588 <syscalls+0x188>
    80002a44:	00003097          	auipc	ra,0x3
    80002a48:	2d8080e7          	jalr	728(ra) # 80005d1c <panic>

0000000080002a4c <iinit>:
{
    80002a4c:	7179                	addi	sp,sp,-48
    80002a4e:	f406                	sd	ra,40(sp)
    80002a50:	f022                	sd	s0,32(sp)
    80002a52:	ec26                	sd	s1,24(sp)
    80002a54:	e84a                	sd	s2,16(sp)
    80002a56:	e44e                	sd	s3,8(sp)
    80002a58:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a5a:	00006597          	auipc	a1,0x6
    80002a5e:	b4658593          	addi	a1,a1,-1210 # 800085a0 <syscalls+0x1a0>
    80002a62:	00014517          	auipc	a0,0x14
    80002a66:	65650513          	addi	a0,a0,1622 # 800170b8 <itable>
    80002a6a:	00003097          	auipc	ra,0x3
    80002a6e:	75a080e7          	jalr	1882(ra) # 800061c4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a72:	00014497          	auipc	s1,0x14
    80002a76:	66e48493          	addi	s1,s1,1646 # 800170e0 <itable+0x28>
    80002a7a:	00016997          	auipc	s3,0x16
    80002a7e:	0f698993          	addi	s3,s3,246 # 80018b70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a82:	00006917          	auipc	s2,0x6
    80002a86:	b2690913          	addi	s2,s2,-1242 # 800085a8 <syscalls+0x1a8>
    80002a8a:	85ca                	mv	a1,s2
    80002a8c:	8526                	mv	a0,s1
    80002a8e:	00001097          	auipc	ra,0x1
    80002a92:	e42080e7          	jalr	-446(ra) # 800038d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a96:	08848493          	addi	s1,s1,136
    80002a9a:	ff3498e3          	bne	s1,s3,80002a8a <iinit+0x3e>
}
    80002a9e:	70a2                	ld	ra,40(sp)
    80002aa0:	7402                	ld	s0,32(sp)
    80002aa2:	64e2                	ld	s1,24(sp)
    80002aa4:	6942                	ld	s2,16(sp)
    80002aa6:	69a2                	ld	s3,8(sp)
    80002aa8:	6145                	addi	sp,sp,48
    80002aaa:	8082                	ret

0000000080002aac <ialloc>:
{
    80002aac:	715d                	addi	sp,sp,-80
    80002aae:	e486                	sd	ra,72(sp)
    80002ab0:	e0a2                	sd	s0,64(sp)
    80002ab2:	fc26                	sd	s1,56(sp)
    80002ab4:	f84a                	sd	s2,48(sp)
    80002ab6:	f44e                	sd	s3,40(sp)
    80002ab8:	f052                	sd	s4,32(sp)
    80002aba:	ec56                	sd	s5,24(sp)
    80002abc:	e85a                	sd	s6,16(sp)
    80002abe:	e45e                	sd	s7,8(sp)
    80002ac0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ac2:	00014717          	auipc	a4,0x14
    80002ac6:	5e272703          	lw	a4,1506(a4) # 800170a4 <sb+0xc>
    80002aca:	4785                	li	a5,1
    80002acc:	04e7fa63          	bgeu	a5,a4,80002b20 <ialloc+0x74>
    80002ad0:	8aaa                	mv	s5,a0
    80002ad2:	8bae                	mv	s7,a1
    80002ad4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002ad6:	00014a17          	auipc	s4,0x14
    80002ada:	5c2a0a13          	addi	s4,s4,1474 # 80017098 <sb>
    80002ade:	00048b1b          	sext.w	s6,s1
    80002ae2:	0044d593          	srli	a1,s1,0x4
    80002ae6:	018a2783          	lw	a5,24(s4)
    80002aea:	9dbd                	addw	a1,a1,a5
    80002aec:	8556                	mv	a0,s5
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	944080e7          	jalr	-1724(ra) # 80002432 <bread>
    80002af6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002af8:	05850993          	addi	s3,a0,88
    80002afc:	00f4f793          	andi	a5,s1,15
    80002b00:	079a                	slli	a5,a5,0x6
    80002b02:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b04:	00099783          	lh	a5,0(s3)
    80002b08:	c3a1                	beqz	a5,80002b48 <ialloc+0x9c>
    brelse(bp);
    80002b0a:	00000097          	auipc	ra,0x0
    80002b0e:	a58080e7          	jalr	-1448(ra) # 80002562 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b12:	0485                	addi	s1,s1,1
    80002b14:	00ca2703          	lw	a4,12(s4)
    80002b18:	0004879b          	sext.w	a5,s1
    80002b1c:	fce7e1e3          	bltu	a5,a4,80002ade <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b20:	00006517          	auipc	a0,0x6
    80002b24:	a9050513          	addi	a0,a0,-1392 # 800085b0 <syscalls+0x1b0>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	23e080e7          	jalr	574(ra) # 80005d66 <printf>
  return 0;
    80002b30:	4501                	li	a0,0
}
    80002b32:	60a6                	ld	ra,72(sp)
    80002b34:	6406                	ld	s0,64(sp)
    80002b36:	74e2                	ld	s1,56(sp)
    80002b38:	7942                	ld	s2,48(sp)
    80002b3a:	79a2                	ld	s3,40(sp)
    80002b3c:	7a02                	ld	s4,32(sp)
    80002b3e:	6ae2                	ld	s5,24(sp)
    80002b40:	6b42                	ld	s6,16(sp)
    80002b42:	6ba2                	ld	s7,8(sp)
    80002b44:	6161                	addi	sp,sp,80
    80002b46:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b48:	04000613          	li	a2,64
    80002b4c:	4581                	li	a1,0
    80002b4e:	854e                	mv	a0,s3
    80002b50:	ffffd097          	auipc	ra,0xffffd
    80002b54:	62a080e7          	jalr	1578(ra) # 8000017a <memset>
      dip->type = type;
    80002b58:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b5c:	854a                	mv	a0,s2
    80002b5e:	00001097          	auipc	ra,0x1
    80002b62:	c8e080e7          	jalr	-882(ra) # 800037ec <log_write>
      brelse(bp);
    80002b66:	854a                	mv	a0,s2
    80002b68:	00000097          	auipc	ra,0x0
    80002b6c:	9fa080e7          	jalr	-1542(ra) # 80002562 <brelse>
      return iget(dev, inum);
    80002b70:	85da                	mv	a1,s6
    80002b72:	8556                	mv	a0,s5
    80002b74:	00000097          	auipc	ra,0x0
    80002b78:	d9c080e7          	jalr	-612(ra) # 80002910 <iget>
    80002b7c:	bf5d                	j	80002b32 <ialloc+0x86>

0000000080002b7e <iupdate>:
{
    80002b7e:	1101                	addi	sp,sp,-32
    80002b80:	ec06                	sd	ra,24(sp)
    80002b82:	e822                	sd	s0,16(sp)
    80002b84:	e426                	sd	s1,8(sp)
    80002b86:	e04a                	sd	s2,0(sp)
    80002b88:	1000                	addi	s0,sp,32
    80002b8a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b8c:	415c                	lw	a5,4(a0)
    80002b8e:	0047d79b          	srliw	a5,a5,0x4
    80002b92:	00014597          	auipc	a1,0x14
    80002b96:	51e5a583          	lw	a1,1310(a1) # 800170b0 <sb+0x18>
    80002b9a:	9dbd                	addw	a1,a1,a5
    80002b9c:	4108                	lw	a0,0(a0)
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	894080e7          	jalr	-1900(ra) # 80002432 <bread>
    80002ba6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ba8:	05850793          	addi	a5,a0,88
    80002bac:	40d8                	lw	a4,4(s1)
    80002bae:	8b3d                	andi	a4,a4,15
    80002bb0:	071a                	slli	a4,a4,0x6
    80002bb2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bb4:	04449703          	lh	a4,68(s1)
    80002bb8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bbc:	04649703          	lh	a4,70(s1)
    80002bc0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bc4:	04849703          	lh	a4,72(s1)
    80002bc8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bcc:	04a49703          	lh	a4,74(s1)
    80002bd0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bd4:	44f8                	lw	a4,76(s1)
    80002bd6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bd8:	03400613          	li	a2,52
    80002bdc:	05048593          	addi	a1,s1,80
    80002be0:	00c78513          	addi	a0,a5,12
    80002be4:	ffffd097          	auipc	ra,0xffffd
    80002be8:	5f2080e7          	jalr	1522(ra) # 800001d6 <memmove>
  log_write(bp);
    80002bec:	854a                	mv	a0,s2
    80002bee:	00001097          	auipc	ra,0x1
    80002bf2:	bfe080e7          	jalr	-1026(ra) # 800037ec <log_write>
  brelse(bp);
    80002bf6:	854a                	mv	a0,s2
    80002bf8:	00000097          	auipc	ra,0x0
    80002bfc:	96a080e7          	jalr	-1686(ra) # 80002562 <brelse>
}
    80002c00:	60e2                	ld	ra,24(sp)
    80002c02:	6442                	ld	s0,16(sp)
    80002c04:	64a2                	ld	s1,8(sp)
    80002c06:	6902                	ld	s2,0(sp)
    80002c08:	6105                	addi	sp,sp,32
    80002c0a:	8082                	ret

0000000080002c0c <idup>:
{
    80002c0c:	1101                	addi	sp,sp,-32
    80002c0e:	ec06                	sd	ra,24(sp)
    80002c10:	e822                	sd	s0,16(sp)
    80002c12:	e426                	sd	s1,8(sp)
    80002c14:	1000                	addi	s0,sp,32
    80002c16:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c18:	00014517          	auipc	a0,0x14
    80002c1c:	4a050513          	addi	a0,a0,1184 # 800170b8 <itable>
    80002c20:	00003097          	auipc	ra,0x3
    80002c24:	634080e7          	jalr	1588(ra) # 80006254 <acquire>
  ip->ref++;
    80002c28:	449c                	lw	a5,8(s1)
    80002c2a:	2785                	addiw	a5,a5,1
    80002c2c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c2e:	00014517          	auipc	a0,0x14
    80002c32:	48a50513          	addi	a0,a0,1162 # 800170b8 <itable>
    80002c36:	00003097          	auipc	ra,0x3
    80002c3a:	6d2080e7          	jalr	1746(ra) # 80006308 <release>
}
    80002c3e:	8526                	mv	a0,s1
    80002c40:	60e2                	ld	ra,24(sp)
    80002c42:	6442                	ld	s0,16(sp)
    80002c44:	64a2                	ld	s1,8(sp)
    80002c46:	6105                	addi	sp,sp,32
    80002c48:	8082                	ret

0000000080002c4a <ilock>:
{
    80002c4a:	1101                	addi	sp,sp,-32
    80002c4c:	ec06                	sd	ra,24(sp)
    80002c4e:	e822                	sd	s0,16(sp)
    80002c50:	e426                	sd	s1,8(sp)
    80002c52:	e04a                	sd	s2,0(sp)
    80002c54:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c56:	c115                	beqz	a0,80002c7a <ilock+0x30>
    80002c58:	84aa                	mv	s1,a0
    80002c5a:	451c                	lw	a5,8(a0)
    80002c5c:	00f05f63          	blez	a5,80002c7a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c60:	0541                	addi	a0,a0,16
    80002c62:	00001097          	auipc	ra,0x1
    80002c66:	ca8080e7          	jalr	-856(ra) # 8000390a <acquiresleep>
  if(ip->valid == 0){
    80002c6a:	40bc                	lw	a5,64(s1)
    80002c6c:	cf99                	beqz	a5,80002c8a <ilock+0x40>
}
    80002c6e:	60e2                	ld	ra,24(sp)
    80002c70:	6442                	ld	s0,16(sp)
    80002c72:	64a2                	ld	s1,8(sp)
    80002c74:	6902                	ld	s2,0(sp)
    80002c76:	6105                	addi	sp,sp,32
    80002c78:	8082                	ret
    panic("ilock");
    80002c7a:	00006517          	auipc	a0,0x6
    80002c7e:	94e50513          	addi	a0,a0,-1714 # 800085c8 <syscalls+0x1c8>
    80002c82:	00003097          	auipc	ra,0x3
    80002c86:	09a080e7          	jalr	154(ra) # 80005d1c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c8a:	40dc                	lw	a5,4(s1)
    80002c8c:	0047d79b          	srliw	a5,a5,0x4
    80002c90:	00014597          	auipc	a1,0x14
    80002c94:	4205a583          	lw	a1,1056(a1) # 800170b0 <sb+0x18>
    80002c98:	9dbd                	addw	a1,a1,a5
    80002c9a:	4088                	lw	a0,0(s1)
    80002c9c:	fffff097          	auipc	ra,0xfffff
    80002ca0:	796080e7          	jalr	1942(ra) # 80002432 <bread>
    80002ca4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ca6:	05850593          	addi	a1,a0,88
    80002caa:	40dc                	lw	a5,4(s1)
    80002cac:	8bbd                	andi	a5,a5,15
    80002cae:	079a                	slli	a5,a5,0x6
    80002cb0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cb2:	00059783          	lh	a5,0(a1)
    80002cb6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cba:	00259783          	lh	a5,2(a1)
    80002cbe:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cc2:	00459783          	lh	a5,4(a1)
    80002cc6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cca:	00659783          	lh	a5,6(a1)
    80002cce:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cd2:	459c                	lw	a5,8(a1)
    80002cd4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cd6:	03400613          	li	a2,52
    80002cda:	05b1                	addi	a1,a1,12
    80002cdc:	05048513          	addi	a0,s1,80
    80002ce0:	ffffd097          	auipc	ra,0xffffd
    80002ce4:	4f6080e7          	jalr	1270(ra) # 800001d6 <memmove>
    brelse(bp);
    80002ce8:	854a                	mv	a0,s2
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	878080e7          	jalr	-1928(ra) # 80002562 <brelse>
    ip->valid = 1;
    80002cf2:	4785                	li	a5,1
    80002cf4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cf6:	04449783          	lh	a5,68(s1)
    80002cfa:	fbb5                	bnez	a5,80002c6e <ilock+0x24>
      panic("ilock: no type");
    80002cfc:	00006517          	auipc	a0,0x6
    80002d00:	8d450513          	addi	a0,a0,-1836 # 800085d0 <syscalls+0x1d0>
    80002d04:	00003097          	auipc	ra,0x3
    80002d08:	018080e7          	jalr	24(ra) # 80005d1c <panic>

0000000080002d0c <iunlock>:
{
    80002d0c:	1101                	addi	sp,sp,-32
    80002d0e:	ec06                	sd	ra,24(sp)
    80002d10:	e822                	sd	s0,16(sp)
    80002d12:	e426                	sd	s1,8(sp)
    80002d14:	e04a                	sd	s2,0(sp)
    80002d16:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d18:	c905                	beqz	a0,80002d48 <iunlock+0x3c>
    80002d1a:	84aa                	mv	s1,a0
    80002d1c:	01050913          	addi	s2,a0,16
    80002d20:	854a                	mv	a0,s2
    80002d22:	00001097          	auipc	ra,0x1
    80002d26:	c82080e7          	jalr	-894(ra) # 800039a4 <holdingsleep>
    80002d2a:	cd19                	beqz	a0,80002d48 <iunlock+0x3c>
    80002d2c:	449c                	lw	a5,8(s1)
    80002d2e:	00f05d63          	blez	a5,80002d48 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d32:	854a                	mv	a0,s2
    80002d34:	00001097          	auipc	ra,0x1
    80002d38:	c2c080e7          	jalr	-980(ra) # 80003960 <releasesleep>
}
    80002d3c:	60e2                	ld	ra,24(sp)
    80002d3e:	6442                	ld	s0,16(sp)
    80002d40:	64a2                	ld	s1,8(sp)
    80002d42:	6902                	ld	s2,0(sp)
    80002d44:	6105                	addi	sp,sp,32
    80002d46:	8082                	ret
    panic("iunlock");
    80002d48:	00006517          	auipc	a0,0x6
    80002d4c:	89850513          	addi	a0,a0,-1896 # 800085e0 <syscalls+0x1e0>
    80002d50:	00003097          	auipc	ra,0x3
    80002d54:	fcc080e7          	jalr	-52(ra) # 80005d1c <panic>

0000000080002d58 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d58:	7179                	addi	sp,sp,-48
    80002d5a:	f406                	sd	ra,40(sp)
    80002d5c:	f022                	sd	s0,32(sp)
    80002d5e:	ec26                	sd	s1,24(sp)
    80002d60:	e84a                	sd	s2,16(sp)
    80002d62:	e44e                	sd	s3,8(sp)
    80002d64:	e052                	sd	s4,0(sp)
    80002d66:	1800                	addi	s0,sp,48
    80002d68:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d6a:	05050493          	addi	s1,a0,80
    80002d6e:	08050913          	addi	s2,a0,128
    80002d72:	a021                	j	80002d7a <itrunc+0x22>
    80002d74:	0491                	addi	s1,s1,4
    80002d76:	01248d63          	beq	s1,s2,80002d90 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d7a:	408c                	lw	a1,0(s1)
    80002d7c:	dde5                	beqz	a1,80002d74 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	8f6080e7          	jalr	-1802(ra) # 80002678 <bfree>
      ip->addrs[i] = 0;
    80002d8a:	0004a023          	sw	zero,0(s1)
    80002d8e:	b7dd                	j	80002d74 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d90:	0809a583          	lw	a1,128(s3)
    80002d94:	e185                	bnez	a1,80002db4 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d96:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d9a:	854e                	mv	a0,s3
    80002d9c:	00000097          	auipc	ra,0x0
    80002da0:	de2080e7          	jalr	-542(ra) # 80002b7e <iupdate>
}
    80002da4:	70a2                	ld	ra,40(sp)
    80002da6:	7402                	ld	s0,32(sp)
    80002da8:	64e2                	ld	s1,24(sp)
    80002daa:	6942                	ld	s2,16(sp)
    80002dac:	69a2                	ld	s3,8(sp)
    80002dae:	6a02                	ld	s4,0(sp)
    80002db0:	6145                	addi	sp,sp,48
    80002db2:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002db4:	0009a503          	lw	a0,0(s3)
    80002db8:	fffff097          	auipc	ra,0xfffff
    80002dbc:	67a080e7          	jalr	1658(ra) # 80002432 <bread>
    80002dc0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dc2:	05850493          	addi	s1,a0,88
    80002dc6:	45850913          	addi	s2,a0,1112
    80002dca:	a021                	j	80002dd2 <itrunc+0x7a>
    80002dcc:	0491                	addi	s1,s1,4
    80002dce:	01248b63          	beq	s1,s2,80002de4 <itrunc+0x8c>
      if(a[j])
    80002dd2:	408c                	lw	a1,0(s1)
    80002dd4:	dde5                	beqz	a1,80002dcc <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002dd6:	0009a503          	lw	a0,0(s3)
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	89e080e7          	jalr	-1890(ra) # 80002678 <bfree>
    80002de2:	b7ed                	j	80002dcc <itrunc+0x74>
    brelse(bp);
    80002de4:	8552                	mv	a0,s4
    80002de6:	fffff097          	auipc	ra,0xfffff
    80002dea:	77c080e7          	jalr	1916(ra) # 80002562 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dee:	0809a583          	lw	a1,128(s3)
    80002df2:	0009a503          	lw	a0,0(s3)
    80002df6:	00000097          	auipc	ra,0x0
    80002dfa:	882080e7          	jalr	-1918(ra) # 80002678 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dfe:	0809a023          	sw	zero,128(s3)
    80002e02:	bf51                	j	80002d96 <itrunc+0x3e>

0000000080002e04 <iput>:
{
    80002e04:	1101                	addi	sp,sp,-32
    80002e06:	ec06                	sd	ra,24(sp)
    80002e08:	e822                	sd	s0,16(sp)
    80002e0a:	e426                	sd	s1,8(sp)
    80002e0c:	e04a                	sd	s2,0(sp)
    80002e0e:	1000                	addi	s0,sp,32
    80002e10:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e12:	00014517          	auipc	a0,0x14
    80002e16:	2a650513          	addi	a0,a0,678 # 800170b8 <itable>
    80002e1a:	00003097          	auipc	ra,0x3
    80002e1e:	43a080e7          	jalr	1082(ra) # 80006254 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e22:	4498                	lw	a4,8(s1)
    80002e24:	4785                	li	a5,1
    80002e26:	02f70363          	beq	a4,a5,80002e4c <iput+0x48>
  ip->ref--;
    80002e2a:	449c                	lw	a5,8(s1)
    80002e2c:	37fd                	addiw	a5,a5,-1
    80002e2e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e30:	00014517          	auipc	a0,0x14
    80002e34:	28850513          	addi	a0,a0,648 # 800170b8 <itable>
    80002e38:	00003097          	auipc	ra,0x3
    80002e3c:	4d0080e7          	jalr	1232(ra) # 80006308 <release>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	64a2                	ld	s1,8(sp)
    80002e46:	6902                	ld	s2,0(sp)
    80002e48:	6105                	addi	sp,sp,32
    80002e4a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e4c:	40bc                	lw	a5,64(s1)
    80002e4e:	dff1                	beqz	a5,80002e2a <iput+0x26>
    80002e50:	04a49783          	lh	a5,74(s1)
    80002e54:	fbf9                	bnez	a5,80002e2a <iput+0x26>
    acquiresleep(&ip->lock);
    80002e56:	01048913          	addi	s2,s1,16
    80002e5a:	854a                	mv	a0,s2
    80002e5c:	00001097          	auipc	ra,0x1
    80002e60:	aae080e7          	jalr	-1362(ra) # 8000390a <acquiresleep>
    release(&itable.lock);
    80002e64:	00014517          	auipc	a0,0x14
    80002e68:	25450513          	addi	a0,a0,596 # 800170b8 <itable>
    80002e6c:	00003097          	auipc	ra,0x3
    80002e70:	49c080e7          	jalr	1180(ra) # 80006308 <release>
    itrunc(ip);
    80002e74:	8526                	mv	a0,s1
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	ee2080e7          	jalr	-286(ra) # 80002d58 <itrunc>
    ip->type = 0;
    80002e7e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e82:	8526                	mv	a0,s1
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	cfa080e7          	jalr	-774(ra) # 80002b7e <iupdate>
    ip->valid = 0;
    80002e8c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e90:	854a                	mv	a0,s2
    80002e92:	00001097          	auipc	ra,0x1
    80002e96:	ace080e7          	jalr	-1330(ra) # 80003960 <releasesleep>
    acquire(&itable.lock);
    80002e9a:	00014517          	auipc	a0,0x14
    80002e9e:	21e50513          	addi	a0,a0,542 # 800170b8 <itable>
    80002ea2:	00003097          	auipc	ra,0x3
    80002ea6:	3b2080e7          	jalr	946(ra) # 80006254 <acquire>
    80002eaa:	b741                	j	80002e2a <iput+0x26>

0000000080002eac <iunlockput>:
{
    80002eac:	1101                	addi	sp,sp,-32
    80002eae:	ec06                	sd	ra,24(sp)
    80002eb0:	e822                	sd	s0,16(sp)
    80002eb2:	e426                	sd	s1,8(sp)
    80002eb4:	1000                	addi	s0,sp,32
    80002eb6:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eb8:	00000097          	auipc	ra,0x0
    80002ebc:	e54080e7          	jalr	-428(ra) # 80002d0c <iunlock>
  iput(ip);
    80002ec0:	8526                	mv	a0,s1
    80002ec2:	00000097          	auipc	ra,0x0
    80002ec6:	f42080e7          	jalr	-190(ra) # 80002e04 <iput>
}
    80002eca:	60e2                	ld	ra,24(sp)
    80002ecc:	6442                	ld	s0,16(sp)
    80002ece:	64a2                	ld	s1,8(sp)
    80002ed0:	6105                	addi	sp,sp,32
    80002ed2:	8082                	ret

0000000080002ed4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ed4:	1141                	addi	sp,sp,-16
    80002ed6:	e422                	sd	s0,8(sp)
    80002ed8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002eda:	411c                	lw	a5,0(a0)
    80002edc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ede:	415c                	lw	a5,4(a0)
    80002ee0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ee2:	04451783          	lh	a5,68(a0)
    80002ee6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eea:	04a51783          	lh	a5,74(a0)
    80002eee:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002ef2:	04c56783          	lwu	a5,76(a0)
    80002ef6:	e99c                	sd	a5,16(a1)
}
    80002ef8:	6422                	ld	s0,8(sp)
    80002efa:	0141                	addi	sp,sp,16
    80002efc:	8082                	ret

0000000080002efe <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002efe:	457c                	lw	a5,76(a0)
    80002f00:	0ed7e963          	bltu	a5,a3,80002ff2 <readi+0xf4>
{
    80002f04:	7159                	addi	sp,sp,-112
    80002f06:	f486                	sd	ra,104(sp)
    80002f08:	f0a2                	sd	s0,96(sp)
    80002f0a:	eca6                	sd	s1,88(sp)
    80002f0c:	e8ca                	sd	s2,80(sp)
    80002f0e:	e4ce                	sd	s3,72(sp)
    80002f10:	e0d2                	sd	s4,64(sp)
    80002f12:	fc56                	sd	s5,56(sp)
    80002f14:	f85a                	sd	s6,48(sp)
    80002f16:	f45e                	sd	s7,40(sp)
    80002f18:	f062                	sd	s8,32(sp)
    80002f1a:	ec66                	sd	s9,24(sp)
    80002f1c:	e86a                	sd	s10,16(sp)
    80002f1e:	e46e                	sd	s11,8(sp)
    80002f20:	1880                	addi	s0,sp,112
    80002f22:	8b2a                	mv	s6,a0
    80002f24:	8bae                	mv	s7,a1
    80002f26:	8a32                	mv	s4,a2
    80002f28:	84b6                	mv	s1,a3
    80002f2a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f2c:	9f35                	addw	a4,a4,a3
    return 0;
    80002f2e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f30:	0ad76063          	bltu	a4,a3,80002fd0 <readi+0xd2>
  if(off + n > ip->size)
    80002f34:	00e7f463          	bgeu	a5,a4,80002f3c <readi+0x3e>
    n = ip->size - off;
    80002f38:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f3c:	0a0a8963          	beqz	s5,80002fee <readi+0xf0>
    80002f40:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f42:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f46:	5c7d                	li	s8,-1
    80002f48:	a82d                	j	80002f82 <readi+0x84>
    80002f4a:	020d1d93          	slli	s11,s10,0x20
    80002f4e:	020ddd93          	srli	s11,s11,0x20
    80002f52:	05890613          	addi	a2,s2,88
    80002f56:	86ee                	mv	a3,s11
    80002f58:	963a                	add	a2,a2,a4
    80002f5a:	85d2                	mv	a1,s4
    80002f5c:	855e                	mv	a0,s7
    80002f5e:	fffff097          	auipc	ra,0xfffff
    80002f62:	b0e080e7          	jalr	-1266(ra) # 80001a6c <either_copyout>
    80002f66:	05850d63          	beq	a0,s8,80002fc0 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	fffff097          	auipc	ra,0xfffff
    80002f70:	5f6080e7          	jalr	1526(ra) # 80002562 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f74:	013d09bb          	addw	s3,s10,s3
    80002f78:	009d04bb          	addw	s1,s10,s1
    80002f7c:	9a6e                	add	s4,s4,s11
    80002f7e:	0559f763          	bgeu	s3,s5,80002fcc <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f82:	00a4d59b          	srliw	a1,s1,0xa
    80002f86:	855a                	mv	a0,s6
    80002f88:	00000097          	auipc	ra,0x0
    80002f8c:	89e080e7          	jalr	-1890(ra) # 80002826 <bmap>
    80002f90:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f94:	cd85                	beqz	a1,80002fcc <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f96:	000b2503          	lw	a0,0(s6)
    80002f9a:	fffff097          	auipc	ra,0xfffff
    80002f9e:	498080e7          	jalr	1176(ra) # 80002432 <bread>
    80002fa2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa4:	3ff4f713          	andi	a4,s1,1023
    80002fa8:	40ec87bb          	subw	a5,s9,a4
    80002fac:	413a86bb          	subw	a3,s5,s3
    80002fb0:	8d3e                	mv	s10,a5
    80002fb2:	2781                	sext.w	a5,a5
    80002fb4:	0006861b          	sext.w	a2,a3
    80002fb8:	f8f679e3          	bgeu	a2,a5,80002f4a <readi+0x4c>
    80002fbc:	8d36                	mv	s10,a3
    80002fbe:	b771                	j	80002f4a <readi+0x4c>
      brelse(bp);
    80002fc0:	854a                	mv	a0,s2
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	5a0080e7          	jalr	1440(ra) # 80002562 <brelse>
      tot = -1;
    80002fca:	59fd                	li	s3,-1
  }
  return tot;
    80002fcc:	0009851b          	sext.w	a0,s3
}
    80002fd0:	70a6                	ld	ra,104(sp)
    80002fd2:	7406                	ld	s0,96(sp)
    80002fd4:	64e6                	ld	s1,88(sp)
    80002fd6:	6946                	ld	s2,80(sp)
    80002fd8:	69a6                	ld	s3,72(sp)
    80002fda:	6a06                	ld	s4,64(sp)
    80002fdc:	7ae2                	ld	s5,56(sp)
    80002fde:	7b42                	ld	s6,48(sp)
    80002fe0:	7ba2                	ld	s7,40(sp)
    80002fe2:	7c02                	ld	s8,32(sp)
    80002fe4:	6ce2                	ld	s9,24(sp)
    80002fe6:	6d42                	ld	s10,16(sp)
    80002fe8:	6da2                	ld	s11,8(sp)
    80002fea:	6165                	addi	sp,sp,112
    80002fec:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fee:	89d6                	mv	s3,s5
    80002ff0:	bff1                	j	80002fcc <readi+0xce>
    return 0;
    80002ff2:	4501                	li	a0,0
}
    80002ff4:	8082                	ret

0000000080002ff6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ff6:	457c                	lw	a5,76(a0)
    80002ff8:	10d7e863          	bltu	a5,a3,80003108 <writei+0x112>
{
    80002ffc:	7159                	addi	sp,sp,-112
    80002ffe:	f486                	sd	ra,104(sp)
    80003000:	f0a2                	sd	s0,96(sp)
    80003002:	eca6                	sd	s1,88(sp)
    80003004:	e8ca                	sd	s2,80(sp)
    80003006:	e4ce                	sd	s3,72(sp)
    80003008:	e0d2                	sd	s4,64(sp)
    8000300a:	fc56                	sd	s5,56(sp)
    8000300c:	f85a                	sd	s6,48(sp)
    8000300e:	f45e                	sd	s7,40(sp)
    80003010:	f062                	sd	s8,32(sp)
    80003012:	ec66                	sd	s9,24(sp)
    80003014:	e86a                	sd	s10,16(sp)
    80003016:	e46e                	sd	s11,8(sp)
    80003018:	1880                	addi	s0,sp,112
    8000301a:	8aaa                	mv	s5,a0
    8000301c:	8bae                	mv	s7,a1
    8000301e:	8a32                	mv	s4,a2
    80003020:	8936                	mv	s2,a3
    80003022:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003024:	00e687bb          	addw	a5,a3,a4
    80003028:	0ed7e263          	bltu	a5,a3,8000310c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000302c:	00043737          	lui	a4,0x43
    80003030:	0ef76063          	bltu	a4,a5,80003110 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003034:	0c0b0863          	beqz	s6,80003104 <writei+0x10e>
    80003038:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000303a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000303e:	5c7d                	li	s8,-1
    80003040:	a091                	j	80003084 <writei+0x8e>
    80003042:	020d1d93          	slli	s11,s10,0x20
    80003046:	020ddd93          	srli	s11,s11,0x20
    8000304a:	05848513          	addi	a0,s1,88
    8000304e:	86ee                	mv	a3,s11
    80003050:	8652                	mv	a2,s4
    80003052:	85de                	mv	a1,s7
    80003054:	953a                	add	a0,a0,a4
    80003056:	fffff097          	auipc	ra,0xfffff
    8000305a:	a6c080e7          	jalr	-1428(ra) # 80001ac2 <either_copyin>
    8000305e:	07850263          	beq	a0,s8,800030c2 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003062:	8526                	mv	a0,s1
    80003064:	00000097          	auipc	ra,0x0
    80003068:	788080e7          	jalr	1928(ra) # 800037ec <log_write>
    brelse(bp);
    8000306c:	8526                	mv	a0,s1
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	4f4080e7          	jalr	1268(ra) # 80002562 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003076:	013d09bb          	addw	s3,s10,s3
    8000307a:	012d093b          	addw	s2,s10,s2
    8000307e:	9a6e                	add	s4,s4,s11
    80003080:	0569f663          	bgeu	s3,s6,800030cc <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003084:	00a9559b          	srliw	a1,s2,0xa
    80003088:	8556                	mv	a0,s5
    8000308a:	fffff097          	auipc	ra,0xfffff
    8000308e:	79c080e7          	jalr	1948(ra) # 80002826 <bmap>
    80003092:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003096:	c99d                	beqz	a1,800030cc <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003098:	000aa503          	lw	a0,0(s5)
    8000309c:	fffff097          	auipc	ra,0xfffff
    800030a0:	396080e7          	jalr	918(ra) # 80002432 <bread>
    800030a4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a6:	3ff97713          	andi	a4,s2,1023
    800030aa:	40ec87bb          	subw	a5,s9,a4
    800030ae:	413b06bb          	subw	a3,s6,s3
    800030b2:	8d3e                	mv	s10,a5
    800030b4:	2781                	sext.w	a5,a5
    800030b6:	0006861b          	sext.w	a2,a3
    800030ba:	f8f674e3          	bgeu	a2,a5,80003042 <writei+0x4c>
    800030be:	8d36                	mv	s10,a3
    800030c0:	b749                	j	80003042 <writei+0x4c>
      brelse(bp);
    800030c2:	8526                	mv	a0,s1
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	49e080e7          	jalr	1182(ra) # 80002562 <brelse>
  }

  if(off > ip->size)
    800030cc:	04caa783          	lw	a5,76(s5)
    800030d0:	0127f463          	bgeu	a5,s2,800030d8 <writei+0xe2>
    ip->size = off;
    800030d4:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800030d8:	8556                	mv	a0,s5
    800030da:	00000097          	auipc	ra,0x0
    800030de:	aa4080e7          	jalr	-1372(ra) # 80002b7e <iupdate>

  return tot;
    800030e2:	0009851b          	sext.w	a0,s3
}
    800030e6:	70a6                	ld	ra,104(sp)
    800030e8:	7406                	ld	s0,96(sp)
    800030ea:	64e6                	ld	s1,88(sp)
    800030ec:	6946                	ld	s2,80(sp)
    800030ee:	69a6                	ld	s3,72(sp)
    800030f0:	6a06                	ld	s4,64(sp)
    800030f2:	7ae2                	ld	s5,56(sp)
    800030f4:	7b42                	ld	s6,48(sp)
    800030f6:	7ba2                	ld	s7,40(sp)
    800030f8:	7c02                	ld	s8,32(sp)
    800030fa:	6ce2                	ld	s9,24(sp)
    800030fc:	6d42                	ld	s10,16(sp)
    800030fe:	6da2                	ld	s11,8(sp)
    80003100:	6165                	addi	sp,sp,112
    80003102:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003104:	89da                	mv	s3,s6
    80003106:	bfc9                	j	800030d8 <writei+0xe2>
    return -1;
    80003108:	557d                	li	a0,-1
}
    8000310a:	8082                	ret
    return -1;
    8000310c:	557d                	li	a0,-1
    8000310e:	bfe1                	j	800030e6 <writei+0xf0>
    return -1;
    80003110:	557d                	li	a0,-1
    80003112:	bfd1                	j	800030e6 <writei+0xf0>

0000000080003114 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003114:	1141                	addi	sp,sp,-16
    80003116:	e406                	sd	ra,8(sp)
    80003118:	e022                	sd	s0,0(sp)
    8000311a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000311c:	4639                	li	a2,14
    8000311e:	ffffd097          	auipc	ra,0xffffd
    80003122:	12c080e7          	jalr	300(ra) # 8000024a <strncmp>
}
    80003126:	60a2                	ld	ra,8(sp)
    80003128:	6402                	ld	s0,0(sp)
    8000312a:	0141                	addi	sp,sp,16
    8000312c:	8082                	ret

000000008000312e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000312e:	7139                	addi	sp,sp,-64
    80003130:	fc06                	sd	ra,56(sp)
    80003132:	f822                	sd	s0,48(sp)
    80003134:	f426                	sd	s1,40(sp)
    80003136:	f04a                	sd	s2,32(sp)
    80003138:	ec4e                	sd	s3,24(sp)
    8000313a:	e852                	sd	s4,16(sp)
    8000313c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000313e:	04451703          	lh	a4,68(a0)
    80003142:	4785                	li	a5,1
    80003144:	00f71a63          	bne	a4,a5,80003158 <dirlookup+0x2a>
    80003148:	892a                	mv	s2,a0
    8000314a:	89ae                	mv	s3,a1
    8000314c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000314e:	457c                	lw	a5,76(a0)
    80003150:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003152:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003154:	e79d                	bnez	a5,80003182 <dirlookup+0x54>
    80003156:	a8a5                	j	800031ce <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003158:	00005517          	auipc	a0,0x5
    8000315c:	49050513          	addi	a0,a0,1168 # 800085e8 <syscalls+0x1e8>
    80003160:	00003097          	auipc	ra,0x3
    80003164:	bbc080e7          	jalr	-1092(ra) # 80005d1c <panic>
      panic("dirlookup read");
    80003168:	00005517          	auipc	a0,0x5
    8000316c:	49850513          	addi	a0,a0,1176 # 80008600 <syscalls+0x200>
    80003170:	00003097          	auipc	ra,0x3
    80003174:	bac080e7          	jalr	-1108(ra) # 80005d1c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003178:	24c1                	addiw	s1,s1,16
    8000317a:	04c92783          	lw	a5,76(s2)
    8000317e:	04f4f763          	bgeu	s1,a5,800031cc <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003182:	4741                	li	a4,16
    80003184:	86a6                	mv	a3,s1
    80003186:	fc040613          	addi	a2,s0,-64
    8000318a:	4581                	li	a1,0
    8000318c:	854a                	mv	a0,s2
    8000318e:	00000097          	auipc	ra,0x0
    80003192:	d70080e7          	jalr	-656(ra) # 80002efe <readi>
    80003196:	47c1                	li	a5,16
    80003198:	fcf518e3          	bne	a0,a5,80003168 <dirlookup+0x3a>
    if(de.inum == 0)
    8000319c:	fc045783          	lhu	a5,-64(s0)
    800031a0:	dfe1                	beqz	a5,80003178 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031a2:	fc240593          	addi	a1,s0,-62
    800031a6:	854e                	mv	a0,s3
    800031a8:	00000097          	auipc	ra,0x0
    800031ac:	f6c080e7          	jalr	-148(ra) # 80003114 <namecmp>
    800031b0:	f561                	bnez	a0,80003178 <dirlookup+0x4a>
      if(poff)
    800031b2:	000a0463          	beqz	s4,800031ba <dirlookup+0x8c>
        *poff = off;
    800031b6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ba:	fc045583          	lhu	a1,-64(s0)
    800031be:	00092503          	lw	a0,0(s2)
    800031c2:	fffff097          	auipc	ra,0xfffff
    800031c6:	74e080e7          	jalr	1870(ra) # 80002910 <iget>
    800031ca:	a011                	j	800031ce <dirlookup+0xa0>
  return 0;
    800031cc:	4501                	li	a0,0
}
    800031ce:	70e2                	ld	ra,56(sp)
    800031d0:	7442                	ld	s0,48(sp)
    800031d2:	74a2                	ld	s1,40(sp)
    800031d4:	7902                	ld	s2,32(sp)
    800031d6:	69e2                	ld	s3,24(sp)
    800031d8:	6a42                	ld	s4,16(sp)
    800031da:	6121                	addi	sp,sp,64
    800031dc:	8082                	ret

00000000800031de <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031de:	711d                	addi	sp,sp,-96
    800031e0:	ec86                	sd	ra,88(sp)
    800031e2:	e8a2                	sd	s0,80(sp)
    800031e4:	e4a6                	sd	s1,72(sp)
    800031e6:	e0ca                	sd	s2,64(sp)
    800031e8:	fc4e                	sd	s3,56(sp)
    800031ea:	f852                	sd	s4,48(sp)
    800031ec:	f456                	sd	s5,40(sp)
    800031ee:	f05a                	sd	s6,32(sp)
    800031f0:	ec5e                	sd	s7,24(sp)
    800031f2:	e862                	sd	s8,16(sp)
    800031f4:	e466                	sd	s9,8(sp)
    800031f6:	e06a                	sd	s10,0(sp)
    800031f8:	1080                	addi	s0,sp,96
    800031fa:	84aa                	mv	s1,a0
    800031fc:	8b2e                	mv	s6,a1
    800031fe:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003200:	00054703          	lbu	a4,0(a0)
    80003204:	02f00793          	li	a5,47
    80003208:	02f70363          	beq	a4,a5,8000322e <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000320c:	ffffe097          	auipc	ra,0xffffe
    80003210:	d32080e7          	jalr	-718(ra) # 80000f3e <myproc>
    80003214:	15853503          	ld	a0,344(a0)
    80003218:	00000097          	auipc	ra,0x0
    8000321c:	9f4080e7          	jalr	-1548(ra) # 80002c0c <idup>
    80003220:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003222:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003226:	4cb5                	li	s9,13
  len = path - s;
    80003228:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000322a:	4c05                	li	s8,1
    8000322c:	a87d                	j	800032ea <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000322e:	4585                	li	a1,1
    80003230:	4505                	li	a0,1
    80003232:	fffff097          	auipc	ra,0xfffff
    80003236:	6de080e7          	jalr	1758(ra) # 80002910 <iget>
    8000323a:	8a2a                	mv	s4,a0
    8000323c:	b7dd                	j	80003222 <namex+0x44>
      iunlockput(ip);
    8000323e:	8552                	mv	a0,s4
    80003240:	00000097          	auipc	ra,0x0
    80003244:	c6c080e7          	jalr	-916(ra) # 80002eac <iunlockput>
      return 0;
    80003248:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000324a:	8552                	mv	a0,s4
    8000324c:	60e6                	ld	ra,88(sp)
    8000324e:	6446                	ld	s0,80(sp)
    80003250:	64a6                	ld	s1,72(sp)
    80003252:	6906                	ld	s2,64(sp)
    80003254:	79e2                	ld	s3,56(sp)
    80003256:	7a42                	ld	s4,48(sp)
    80003258:	7aa2                	ld	s5,40(sp)
    8000325a:	7b02                	ld	s6,32(sp)
    8000325c:	6be2                	ld	s7,24(sp)
    8000325e:	6c42                	ld	s8,16(sp)
    80003260:	6ca2                	ld	s9,8(sp)
    80003262:	6d02                	ld	s10,0(sp)
    80003264:	6125                	addi	sp,sp,96
    80003266:	8082                	ret
      iunlock(ip);
    80003268:	8552                	mv	a0,s4
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	aa2080e7          	jalr	-1374(ra) # 80002d0c <iunlock>
      return ip;
    80003272:	bfe1                	j	8000324a <namex+0x6c>
      iunlockput(ip);
    80003274:	8552                	mv	a0,s4
    80003276:	00000097          	auipc	ra,0x0
    8000327a:	c36080e7          	jalr	-970(ra) # 80002eac <iunlockput>
      return 0;
    8000327e:	8a4e                	mv	s4,s3
    80003280:	b7e9                	j	8000324a <namex+0x6c>
  len = path - s;
    80003282:	40998633          	sub	a2,s3,s1
    80003286:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000328a:	09acd863          	bge	s9,s10,8000331a <namex+0x13c>
    memmove(name, s, DIRSIZ);
    8000328e:	4639                	li	a2,14
    80003290:	85a6                	mv	a1,s1
    80003292:	8556                	mv	a0,s5
    80003294:	ffffd097          	auipc	ra,0xffffd
    80003298:	f42080e7          	jalr	-190(ra) # 800001d6 <memmove>
    8000329c:	84ce                	mv	s1,s3
  while(*path == '/')
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	01279763          	bne	a5,s2,800032b0 <namex+0xd2>
    path++;
    800032a6:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032a8:	0004c783          	lbu	a5,0(s1)
    800032ac:	ff278de3          	beq	a5,s2,800032a6 <namex+0xc8>
    ilock(ip);
    800032b0:	8552                	mv	a0,s4
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	998080e7          	jalr	-1640(ra) # 80002c4a <ilock>
    if(ip->type != T_DIR){
    800032ba:	044a1783          	lh	a5,68(s4)
    800032be:	f98790e3          	bne	a5,s8,8000323e <namex+0x60>
    if(nameiparent && *path == '\0'){
    800032c2:	000b0563          	beqz	s6,800032cc <namex+0xee>
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	dfd9                	beqz	a5,80003268 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032cc:	865e                	mv	a2,s7
    800032ce:	85d6                	mv	a1,s5
    800032d0:	8552                	mv	a0,s4
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	e5c080e7          	jalr	-420(ra) # 8000312e <dirlookup>
    800032da:	89aa                	mv	s3,a0
    800032dc:	dd41                	beqz	a0,80003274 <namex+0x96>
    iunlockput(ip);
    800032de:	8552                	mv	a0,s4
    800032e0:	00000097          	auipc	ra,0x0
    800032e4:	bcc080e7          	jalr	-1076(ra) # 80002eac <iunlockput>
    ip = next;
    800032e8:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032ea:	0004c783          	lbu	a5,0(s1)
    800032ee:	01279763          	bne	a5,s2,800032fc <namex+0x11e>
    path++;
    800032f2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032f4:	0004c783          	lbu	a5,0(s1)
    800032f8:	ff278de3          	beq	a5,s2,800032f2 <namex+0x114>
  if(*path == 0)
    800032fc:	cb9d                	beqz	a5,80003332 <namex+0x154>
  while(*path != '/' && *path != 0)
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	89a6                	mv	s3,s1
  len = path - s;
    80003304:	8d5e                	mv	s10,s7
    80003306:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003308:	01278963          	beq	a5,s2,8000331a <namex+0x13c>
    8000330c:	dbbd                	beqz	a5,80003282 <namex+0xa4>
    path++;
    8000330e:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003310:	0009c783          	lbu	a5,0(s3)
    80003314:	ff279ce3          	bne	a5,s2,8000330c <namex+0x12e>
    80003318:	b7ad                	j	80003282 <namex+0xa4>
    memmove(name, s, len);
    8000331a:	2601                	sext.w	a2,a2
    8000331c:	85a6                	mv	a1,s1
    8000331e:	8556                	mv	a0,s5
    80003320:	ffffd097          	auipc	ra,0xffffd
    80003324:	eb6080e7          	jalr	-330(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003328:	9d56                	add	s10,s10,s5
    8000332a:	000d0023          	sb	zero,0(s10)
    8000332e:	84ce                	mv	s1,s3
    80003330:	b7bd                	j	8000329e <namex+0xc0>
  if(nameiparent){
    80003332:	f00b0ce3          	beqz	s6,8000324a <namex+0x6c>
    iput(ip);
    80003336:	8552                	mv	a0,s4
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	acc080e7          	jalr	-1332(ra) # 80002e04 <iput>
    return 0;
    80003340:	4a01                	li	s4,0
    80003342:	b721                	j	8000324a <namex+0x6c>

0000000080003344 <dirlink>:
{
    80003344:	7139                	addi	sp,sp,-64
    80003346:	fc06                	sd	ra,56(sp)
    80003348:	f822                	sd	s0,48(sp)
    8000334a:	f426                	sd	s1,40(sp)
    8000334c:	f04a                	sd	s2,32(sp)
    8000334e:	ec4e                	sd	s3,24(sp)
    80003350:	e852                	sd	s4,16(sp)
    80003352:	0080                	addi	s0,sp,64
    80003354:	892a                	mv	s2,a0
    80003356:	8a2e                	mv	s4,a1
    80003358:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000335a:	4601                	li	a2,0
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	dd2080e7          	jalr	-558(ra) # 8000312e <dirlookup>
    80003364:	e93d                	bnez	a0,800033da <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003366:	04c92483          	lw	s1,76(s2)
    8000336a:	c49d                	beqz	s1,80003398 <dirlink+0x54>
    8000336c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336e:	4741                	li	a4,16
    80003370:	86a6                	mv	a3,s1
    80003372:	fc040613          	addi	a2,s0,-64
    80003376:	4581                	li	a1,0
    80003378:	854a                	mv	a0,s2
    8000337a:	00000097          	auipc	ra,0x0
    8000337e:	b84080e7          	jalr	-1148(ra) # 80002efe <readi>
    80003382:	47c1                	li	a5,16
    80003384:	06f51163          	bne	a0,a5,800033e6 <dirlink+0xa2>
    if(de.inum == 0)
    80003388:	fc045783          	lhu	a5,-64(s0)
    8000338c:	c791                	beqz	a5,80003398 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000338e:	24c1                	addiw	s1,s1,16
    80003390:	04c92783          	lw	a5,76(s2)
    80003394:	fcf4ede3          	bltu	s1,a5,8000336e <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003398:	4639                	li	a2,14
    8000339a:	85d2                	mv	a1,s4
    8000339c:	fc240513          	addi	a0,s0,-62
    800033a0:	ffffd097          	auipc	ra,0xffffd
    800033a4:	ee6080e7          	jalr	-282(ra) # 80000286 <strncpy>
  de.inum = inum;
    800033a8:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ac:	4741                	li	a4,16
    800033ae:	86a6                	mv	a3,s1
    800033b0:	fc040613          	addi	a2,s0,-64
    800033b4:	4581                	li	a1,0
    800033b6:	854a                	mv	a0,s2
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	c3e080e7          	jalr	-962(ra) # 80002ff6 <writei>
    800033c0:	1541                	addi	a0,a0,-16
    800033c2:	00a03533          	snez	a0,a0
    800033c6:	40a00533          	neg	a0,a0
}
    800033ca:	70e2                	ld	ra,56(sp)
    800033cc:	7442                	ld	s0,48(sp)
    800033ce:	74a2                	ld	s1,40(sp)
    800033d0:	7902                	ld	s2,32(sp)
    800033d2:	69e2                	ld	s3,24(sp)
    800033d4:	6a42                	ld	s4,16(sp)
    800033d6:	6121                	addi	sp,sp,64
    800033d8:	8082                	ret
    iput(ip);
    800033da:	00000097          	auipc	ra,0x0
    800033de:	a2a080e7          	jalr	-1494(ra) # 80002e04 <iput>
    return -1;
    800033e2:	557d                	li	a0,-1
    800033e4:	b7dd                	j	800033ca <dirlink+0x86>
      panic("dirlink read");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	22a50513          	addi	a0,a0,554 # 80008610 <syscalls+0x210>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	92e080e7          	jalr	-1746(ra) # 80005d1c <panic>

00000000800033f6 <namei>:

struct inode*
namei(char *path)
{
    800033f6:	1101                	addi	sp,sp,-32
    800033f8:	ec06                	sd	ra,24(sp)
    800033fa:	e822                	sd	s0,16(sp)
    800033fc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033fe:	fe040613          	addi	a2,s0,-32
    80003402:	4581                	li	a1,0
    80003404:	00000097          	auipc	ra,0x0
    80003408:	dda080e7          	jalr	-550(ra) # 800031de <namex>
}
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003414:	1141                	addi	sp,sp,-16
    80003416:	e406                	sd	ra,8(sp)
    80003418:	e022                	sd	s0,0(sp)
    8000341a:	0800                	addi	s0,sp,16
    8000341c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000341e:	4585                	li	a1,1
    80003420:	00000097          	auipc	ra,0x0
    80003424:	dbe080e7          	jalr	-578(ra) # 800031de <namex>
}
    80003428:	60a2                	ld	ra,8(sp)
    8000342a:	6402                	ld	s0,0(sp)
    8000342c:	0141                	addi	sp,sp,16
    8000342e:	8082                	ret

0000000080003430 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003430:	1101                	addi	sp,sp,-32
    80003432:	ec06                	sd	ra,24(sp)
    80003434:	e822                	sd	s0,16(sp)
    80003436:	e426                	sd	s1,8(sp)
    80003438:	e04a                	sd	s2,0(sp)
    8000343a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000343c:	00015917          	auipc	s2,0x15
    80003440:	72490913          	addi	s2,s2,1828 # 80018b60 <log>
    80003444:	01892583          	lw	a1,24(s2)
    80003448:	02892503          	lw	a0,40(s2)
    8000344c:	fffff097          	auipc	ra,0xfffff
    80003450:	fe6080e7          	jalr	-26(ra) # 80002432 <bread>
    80003454:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003456:	02c92683          	lw	a3,44(s2)
    8000345a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	02d05863          	blez	a3,8000348c <write_head+0x5c>
    80003460:	00015797          	auipc	a5,0x15
    80003464:	73078793          	addi	a5,a5,1840 # 80018b90 <log+0x30>
    80003468:	05c50713          	addi	a4,a0,92
    8000346c:	36fd                	addiw	a3,a3,-1
    8000346e:	02069613          	slli	a2,a3,0x20
    80003472:	01e65693          	srli	a3,a2,0x1e
    80003476:	00015617          	auipc	a2,0x15
    8000347a:	71e60613          	addi	a2,a2,1822 # 80018b94 <log+0x34>
    8000347e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003480:	4390                	lw	a2,0(a5)
    80003482:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003484:	0791                	addi	a5,a5,4
    80003486:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    80003488:	fed79ce3          	bne	a5,a3,80003480 <write_head+0x50>
  }
  bwrite(buf);
    8000348c:	8526                	mv	a0,s1
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	096080e7          	jalr	150(ra) # 80002524 <bwrite>
  brelse(buf);
    80003496:	8526                	mv	a0,s1
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	0ca080e7          	jalr	202(ra) # 80002562 <brelse>
}
    800034a0:	60e2                	ld	ra,24(sp)
    800034a2:	6442                	ld	s0,16(sp)
    800034a4:	64a2                	ld	s1,8(sp)
    800034a6:	6902                	ld	s2,0(sp)
    800034a8:	6105                	addi	sp,sp,32
    800034aa:	8082                	ret

00000000800034ac <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ac:	00015797          	auipc	a5,0x15
    800034b0:	6e07a783          	lw	a5,1760(a5) # 80018b8c <log+0x2c>
    800034b4:	0af05d63          	blez	a5,8000356e <install_trans+0xc2>
{
    800034b8:	7139                	addi	sp,sp,-64
    800034ba:	fc06                	sd	ra,56(sp)
    800034bc:	f822                	sd	s0,48(sp)
    800034be:	f426                	sd	s1,40(sp)
    800034c0:	f04a                	sd	s2,32(sp)
    800034c2:	ec4e                	sd	s3,24(sp)
    800034c4:	e852                	sd	s4,16(sp)
    800034c6:	e456                	sd	s5,8(sp)
    800034c8:	e05a                	sd	s6,0(sp)
    800034ca:	0080                	addi	s0,sp,64
    800034cc:	8b2a                	mv	s6,a0
    800034ce:	00015a97          	auipc	s5,0x15
    800034d2:	6c2a8a93          	addi	s5,s5,1730 # 80018b90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034d8:	00015997          	auipc	s3,0x15
    800034dc:	68898993          	addi	s3,s3,1672 # 80018b60 <log>
    800034e0:	a00d                	j	80003502 <install_trans+0x56>
    brelse(lbuf);
    800034e2:	854a                	mv	a0,s2
    800034e4:	fffff097          	auipc	ra,0xfffff
    800034e8:	07e080e7          	jalr	126(ra) # 80002562 <brelse>
    brelse(dbuf);
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	074080e7          	jalr	116(ra) # 80002562 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f6:	2a05                	addiw	s4,s4,1
    800034f8:	0a91                	addi	s5,s5,4
    800034fa:	02c9a783          	lw	a5,44(s3)
    800034fe:	04fa5e63          	bge	s4,a5,8000355a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003502:	0189a583          	lw	a1,24(s3)
    80003506:	014585bb          	addw	a1,a1,s4
    8000350a:	2585                	addiw	a1,a1,1
    8000350c:	0289a503          	lw	a0,40(s3)
    80003510:	fffff097          	auipc	ra,0xfffff
    80003514:	f22080e7          	jalr	-222(ra) # 80002432 <bread>
    80003518:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000351a:	000aa583          	lw	a1,0(s5)
    8000351e:	0289a503          	lw	a0,40(s3)
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	f10080e7          	jalr	-240(ra) # 80002432 <bread>
    8000352a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000352c:	40000613          	li	a2,1024
    80003530:	05890593          	addi	a1,s2,88
    80003534:	05850513          	addi	a0,a0,88
    80003538:	ffffd097          	auipc	ra,0xffffd
    8000353c:	c9e080e7          	jalr	-866(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003540:	8526                	mv	a0,s1
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	fe2080e7          	jalr	-30(ra) # 80002524 <bwrite>
    if(recovering == 0)
    8000354a:	f80b1ce3          	bnez	s6,800034e2 <install_trans+0x36>
      bunpin(dbuf);
    8000354e:	8526                	mv	a0,s1
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	0ec080e7          	jalr	236(ra) # 8000263c <bunpin>
    80003558:	b769                	j	800034e2 <install_trans+0x36>
}
    8000355a:	70e2                	ld	ra,56(sp)
    8000355c:	7442                	ld	s0,48(sp)
    8000355e:	74a2                	ld	s1,40(sp)
    80003560:	7902                	ld	s2,32(sp)
    80003562:	69e2                	ld	s3,24(sp)
    80003564:	6a42                	ld	s4,16(sp)
    80003566:	6aa2                	ld	s5,8(sp)
    80003568:	6b02                	ld	s6,0(sp)
    8000356a:	6121                	addi	sp,sp,64
    8000356c:	8082                	ret
    8000356e:	8082                	ret

0000000080003570 <initlog>:
{
    80003570:	7179                	addi	sp,sp,-48
    80003572:	f406                	sd	ra,40(sp)
    80003574:	f022                	sd	s0,32(sp)
    80003576:	ec26                	sd	s1,24(sp)
    80003578:	e84a                	sd	s2,16(sp)
    8000357a:	e44e                	sd	s3,8(sp)
    8000357c:	1800                	addi	s0,sp,48
    8000357e:	892a                	mv	s2,a0
    80003580:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003582:	00015497          	auipc	s1,0x15
    80003586:	5de48493          	addi	s1,s1,1502 # 80018b60 <log>
    8000358a:	00005597          	auipc	a1,0x5
    8000358e:	09658593          	addi	a1,a1,150 # 80008620 <syscalls+0x220>
    80003592:	8526                	mv	a0,s1
    80003594:	00003097          	auipc	ra,0x3
    80003598:	c30080e7          	jalr	-976(ra) # 800061c4 <initlock>
  log.start = sb->logstart;
    8000359c:	0149a583          	lw	a1,20(s3)
    800035a0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035a2:	0109a783          	lw	a5,16(s3)
    800035a6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035a8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035ac:	854a                	mv	a0,s2
    800035ae:	fffff097          	auipc	ra,0xfffff
    800035b2:	e84080e7          	jalr	-380(ra) # 80002432 <bread>
  log.lh.n = lh->n;
    800035b6:	4d34                	lw	a3,88(a0)
    800035b8:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035ba:	02d05663          	blez	a3,800035e6 <initlog+0x76>
    800035be:	05c50793          	addi	a5,a0,92
    800035c2:	00015717          	auipc	a4,0x15
    800035c6:	5ce70713          	addi	a4,a4,1486 # 80018b90 <log+0x30>
    800035ca:	36fd                	addiw	a3,a3,-1
    800035cc:	02069613          	slli	a2,a3,0x20
    800035d0:	01e65693          	srli	a3,a2,0x1e
    800035d4:	06050613          	addi	a2,a0,96
    800035d8:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800035da:	4390                	lw	a2,0(a5)
    800035dc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800035de:	0791                	addi	a5,a5,4
    800035e0:	0711                	addi	a4,a4,4
    800035e2:	fed79ce3          	bne	a5,a3,800035da <initlog+0x6a>
  brelse(buf);
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	f7c080e7          	jalr	-132(ra) # 80002562 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ee:	4505                	li	a0,1
    800035f0:	00000097          	auipc	ra,0x0
    800035f4:	ebc080e7          	jalr	-324(ra) # 800034ac <install_trans>
  log.lh.n = 0;
    800035f8:	00015797          	auipc	a5,0x15
    800035fc:	5807aa23          	sw	zero,1428(a5) # 80018b8c <log+0x2c>
  write_head(); // clear the log
    80003600:	00000097          	auipc	ra,0x0
    80003604:	e30080e7          	jalr	-464(ra) # 80003430 <write_head>
}
    80003608:	70a2                	ld	ra,40(sp)
    8000360a:	7402                	ld	s0,32(sp)
    8000360c:	64e2                	ld	s1,24(sp)
    8000360e:	6942                	ld	s2,16(sp)
    80003610:	69a2                	ld	s3,8(sp)
    80003612:	6145                	addi	sp,sp,48
    80003614:	8082                	ret

0000000080003616 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003616:	1101                	addi	sp,sp,-32
    80003618:	ec06                	sd	ra,24(sp)
    8000361a:	e822                	sd	s0,16(sp)
    8000361c:	e426                	sd	s1,8(sp)
    8000361e:	e04a                	sd	s2,0(sp)
    80003620:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003622:	00015517          	auipc	a0,0x15
    80003626:	53e50513          	addi	a0,a0,1342 # 80018b60 <log>
    8000362a:	00003097          	auipc	ra,0x3
    8000362e:	c2a080e7          	jalr	-982(ra) # 80006254 <acquire>
  while(1){
    if(log.committing){
    80003632:	00015497          	auipc	s1,0x15
    80003636:	52e48493          	addi	s1,s1,1326 # 80018b60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000363a:	4979                	li	s2,30
    8000363c:	a039                	j	8000364a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000363e:	85a6                	mv	a1,s1
    80003640:	8526                	mv	a0,s1
    80003642:	ffffe097          	auipc	ra,0xffffe
    80003646:	022080e7          	jalr	34(ra) # 80001664 <sleep>
    if(log.committing){
    8000364a:	50dc                	lw	a5,36(s1)
    8000364c:	fbed                	bnez	a5,8000363e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000364e:	5098                	lw	a4,32(s1)
    80003650:	2705                	addiw	a4,a4,1
    80003652:	0007069b          	sext.w	a3,a4
    80003656:	0027179b          	slliw	a5,a4,0x2
    8000365a:	9fb9                	addw	a5,a5,a4
    8000365c:	0017979b          	slliw	a5,a5,0x1
    80003660:	54d8                	lw	a4,44(s1)
    80003662:	9fb9                	addw	a5,a5,a4
    80003664:	00f95963          	bge	s2,a5,80003676 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003668:	85a6                	mv	a1,s1
    8000366a:	8526                	mv	a0,s1
    8000366c:	ffffe097          	auipc	ra,0xffffe
    80003670:	ff8080e7          	jalr	-8(ra) # 80001664 <sleep>
    80003674:	bfd9                	j	8000364a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003676:	00015517          	auipc	a0,0x15
    8000367a:	4ea50513          	addi	a0,a0,1258 # 80018b60 <log>
    8000367e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003680:	00003097          	auipc	ra,0x3
    80003684:	c88080e7          	jalr	-888(ra) # 80006308 <release>
      break;
    }
  }
}
    80003688:	60e2                	ld	ra,24(sp)
    8000368a:	6442                	ld	s0,16(sp)
    8000368c:	64a2                	ld	s1,8(sp)
    8000368e:	6902                	ld	s2,0(sp)
    80003690:	6105                	addi	sp,sp,32
    80003692:	8082                	ret

0000000080003694 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003694:	7139                	addi	sp,sp,-64
    80003696:	fc06                	sd	ra,56(sp)
    80003698:	f822                	sd	s0,48(sp)
    8000369a:	f426                	sd	s1,40(sp)
    8000369c:	f04a                	sd	s2,32(sp)
    8000369e:	ec4e                	sd	s3,24(sp)
    800036a0:	e852                	sd	s4,16(sp)
    800036a2:	e456                	sd	s5,8(sp)
    800036a4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036a6:	00015497          	auipc	s1,0x15
    800036aa:	4ba48493          	addi	s1,s1,1210 # 80018b60 <log>
    800036ae:	8526                	mv	a0,s1
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	ba4080e7          	jalr	-1116(ra) # 80006254 <acquire>
  log.outstanding -= 1;
    800036b8:	509c                	lw	a5,32(s1)
    800036ba:	37fd                	addiw	a5,a5,-1
    800036bc:	0007891b          	sext.w	s2,a5
    800036c0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036c2:	50dc                	lw	a5,36(s1)
    800036c4:	e7b9                	bnez	a5,80003712 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036c6:	04091e63          	bnez	s2,80003722 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800036ca:	00015497          	auipc	s1,0x15
    800036ce:	49648493          	addi	s1,s1,1174 # 80018b60 <log>
    800036d2:	4785                	li	a5,1
    800036d4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036d6:	8526                	mv	a0,s1
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	c30080e7          	jalr	-976(ra) # 80006308 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036e0:	54dc                	lw	a5,44(s1)
    800036e2:	06f04763          	bgtz	a5,80003750 <end_op+0xbc>
    acquire(&log.lock);
    800036e6:	00015497          	auipc	s1,0x15
    800036ea:	47a48493          	addi	s1,s1,1146 # 80018b60 <log>
    800036ee:	8526                	mv	a0,s1
    800036f0:	00003097          	auipc	ra,0x3
    800036f4:	b64080e7          	jalr	-1180(ra) # 80006254 <acquire>
    log.committing = 0;
    800036f8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036fc:	8526                	mv	a0,s1
    800036fe:	ffffe097          	auipc	ra,0xffffe
    80003702:	fca080e7          	jalr	-54(ra) # 800016c8 <wakeup>
    release(&log.lock);
    80003706:	8526                	mv	a0,s1
    80003708:	00003097          	auipc	ra,0x3
    8000370c:	c00080e7          	jalr	-1024(ra) # 80006308 <release>
}
    80003710:	a03d                	j	8000373e <end_op+0xaa>
    panic("log.committing");
    80003712:	00005517          	auipc	a0,0x5
    80003716:	f1650513          	addi	a0,a0,-234 # 80008628 <syscalls+0x228>
    8000371a:	00002097          	auipc	ra,0x2
    8000371e:	602080e7          	jalr	1538(ra) # 80005d1c <panic>
    wakeup(&log);
    80003722:	00015497          	auipc	s1,0x15
    80003726:	43e48493          	addi	s1,s1,1086 # 80018b60 <log>
    8000372a:	8526                	mv	a0,s1
    8000372c:	ffffe097          	auipc	ra,0xffffe
    80003730:	f9c080e7          	jalr	-100(ra) # 800016c8 <wakeup>
  release(&log.lock);
    80003734:	8526                	mv	a0,s1
    80003736:	00003097          	auipc	ra,0x3
    8000373a:	bd2080e7          	jalr	-1070(ra) # 80006308 <release>
}
    8000373e:	70e2                	ld	ra,56(sp)
    80003740:	7442                	ld	s0,48(sp)
    80003742:	74a2                	ld	s1,40(sp)
    80003744:	7902                	ld	s2,32(sp)
    80003746:	69e2                	ld	s3,24(sp)
    80003748:	6a42                	ld	s4,16(sp)
    8000374a:	6aa2                	ld	s5,8(sp)
    8000374c:	6121                	addi	sp,sp,64
    8000374e:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003750:	00015a97          	auipc	s5,0x15
    80003754:	440a8a93          	addi	s5,s5,1088 # 80018b90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003758:	00015a17          	auipc	s4,0x15
    8000375c:	408a0a13          	addi	s4,s4,1032 # 80018b60 <log>
    80003760:	018a2583          	lw	a1,24(s4)
    80003764:	012585bb          	addw	a1,a1,s2
    80003768:	2585                	addiw	a1,a1,1
    8000376a:	028a2503          	lw	a0,40(s4)
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	cc4080e7          	jalr	-828(ra) # 80002432 <bread>
    80003776:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003778:	000aa583          	lw	a1,0(s5)
    8000377c:	028a2503          	lw	a0,40(s4)
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	cb2080e7          	jalr	-846(ra) # 80002432 <bread>
    80003788:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000378a:	40000613          	li	a2,1024
    8000378e:	05850593          	addi	a1,a0,88
    80003792:	05848513          	addi	a0,s1,88
    80003796:	ffffd097          	auipc	ra,0xffffd
    8000379a:	a40080e7          	jalr	-1472(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    8000379e:	8526                	mv	a0,s1
    800037a0:	fffff097          	auipc	ra,0xfffff
    800037a4:	d84080e7          	jalr	-636(ra) # 80002524 <bwrite>
    brelse(from);
    800037a8:	854e                	mv	a0,s3
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	db8080e7          	jalr	-584(ra) # 80002562 <brelse>
    brelse(to);
    800037b2:	8526                	mv	a0,s1
    800037b4:	fffff097          	auipc	ra,0xfffff
    800037b8:	dae080e7          	jalr	-594(ra) # 80002562 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037bc:	2905                	addiw	s2,s2,1
    800037be:	0a91                	addi	s5,s5,4
    800037c0:	02ca2783          	lw	a5,44(s4)
    800037c4:	f8f94ee3          	blt	s2,a5,80003760 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	c68080e7          	jalr	-920(ra) # 80003430 <write_head>
    install_trans(0); // Now install writes to home locations
    800037d0:	4501                	li	a0,0
    800037d2:	00000097          	auipc	ra,0x0
    800037d6:	cda080e7          	jalr	-806(ra) # 800034ac <install_trans>
    log.lh.n = 0;
    800037da:	00015797          	auipc	a5,0x15
    800037de:	3a07a923          	sw	zero,946(a5) # 80018b8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037e2:	00000097          	auipc	ra,0x0
    800037e6:	c4e080e7          	jalr	-946(ra) # 80003430 <write_head>
    800037ea:	bdf5                	j	800036e6 <end_op+0x52>

00000000800037ec <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037ec:	1101                	addi	sp,sp,-32
    800037ee:	ec06                	sd	ra,24(sp)
    800037f0:	e822                	sd	s0,16(sp)
    800037f2:	e426                	sd	s1,8(sp)
    800037f4:	e04a                	sd	s2,0(sp)
    800037f6:	1000                	addi	s0,sp,32
    800037f8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037fa:	00015917          	auipc	s2,0x15
    800037fe:	36690913          	addi	s2,s2,870 # 80018b60 <log>
    80003802:	854a                	mv	a0,s2
    80003804:	00003097          	auipc	ra,0x3
    80003808:	a50080e7          	jalr	-1456(ra) # 80006254 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000380c:	02c92603          	lw	a2,44(s2)
    80003810:	47f5                	li	a5,29
    80003812:	06c7c563          	blt	a5,a2,8000387c <log_write+0x90>
    80003816:	00015797          	auipc	a5,0x15
    8000381a:	3667a783          	lw	a5,870(a5) # 80018b7c <log+0x1c>
    8000381e:	37fd                	addiw	a5,a5,-1
    80003820:	04f65e63          	bge	a2,a5,8000387c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003824:	00015797          	auipc	a5,0x15
    80003828:	35c7a783          	lw	a5,860(a5) # 80018b80 <log+0x20>
    8000382c:	06f05063          	blez	a5,8000388c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003830:	4781                	li	a5,0
    80003832:	06c05563          	blez	a2,8000389c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003836:	44cc                	lw	a1,12(s1)
    80003838:	00015717          	auipc	a4,0x15
    8000383c:	35870713          	addi	a4,a4,856 # 80018b90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003840:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003842:	4314                	lw	a3,0(a4)
    80003844:	04b68c63          	beq	a3,a1,8000389c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003848:	2785                	addiw	a5,a5,1
    8000384a:	0711                	addi	a4,a4,4
    8000384c:	fef61be3          	bne	a2,a5,80003842 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003850:	0621                	addi	a2,a2,8
    80003852:	060a                	slli	a2,a2,0x2
    80003854:	00015797          	auipc	a5,0x15
    80003858:	30c78793          	addi	a5,a5,780 # 80018b60 <log>
    8000385c:	97b2                	add	a5,a5,a2
    8000385e:	44d8                	lw	a4,12(s1)
    80003860:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003862:	8526                	mv	a0,s1
    80003864:	fffff097          	auipc	ra,0xfffff
    80003868:	d9c080e7          	jalr	-612(ra) # 80002600 <bpin>
    log.lh.n++;
    8000386c:	00015717          	auipc	a4,0x15
    80003870:	2f470713          	addi	a4,a4,756 # 80018b60 <log>
    80003874:	575c                	lw	a5,44(a4)
    80003876:	2785                	addiw	a5,a5,1
    80003878:	d75c                	sw	a5,44(a4)
    8000387a:	a82d                	j	800038b4 <log_write+0xc8>
    panic("too big a transaction");
    8000387c:	00005517          	auipc	a0,0x5
    80003880:	dbc50513          	addi	a0,a0,-580 # 80008638 <syscalls+0x238>
    80003884:	00002097          	auipc	ra,0x2
    80003888:	498080e7          	jalr	1176(ra) # 80005d1c <panic>
    panic("log_write outside of trans");
    8000388c:	00005517          	auipc	a0,0x5
    80003890:	dc450513          	addi	a0,a0,-572 # 80008650 <syscalls+0x250>
    80003894:	00002097          	auipc	ra,0x2
    80003898:	488080e7          	jalr	1160(ra) # 80005d1c <panic>
  log.lh.block[i] = b->blockno;
    8000389c:	00878693          	addi	a3,a5,8
    800038a0:	068a                	slli	a3,a3,0x2
    800038a2:	00015717          	auipc	a4,0x15
    800038a6:	2be70713          	addi	a4,a4,702 # 80018b60 <log>
    800038aa:	9736                	add	a4,a4,a3
    800038ac:	44d4                	lw	a3,12(s1)
    800038ae:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038b0:	faf609e3          	beq	a2,a5,80003862 <log_write+0x76>
  }
  release(&log.lock);
    800038b4:	00015517          	auipc	a0,0x15
    800038b8:	2ac50513          	addi	a0,a0,684 # 80018b60 <log>
    800038bc:	00003097          	auipc	ra,0x3
    800038c0:	a4c080e7          	jalr	-1460(ra) # 80006308 <release>
}
    800038c4:	60e2                	ld	ra,24(sp)
    800038c6:	6442                	ld	s0,16(sp)
    800038c8:	64a2                	ld	s1,8(sp)
    800038ca:	6902                	ld	s2,0(sp)
    800038cc:	6105                	addi	sp,sp,32
    800038ce:	8082                	ret

00000000800038d0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038d0:	1101                	addi	sp,sp,-32
    800038d2:	ec06                	sd	ra,24(sp)
    800038d4:	e822                	sd	s0,16(sp)
    800038d6:	e426                	sd	s1,8(sp)
    800038d8:	e04a                	sd	s2,0(sp)
    800038da:	1000                	addi	s0,sp,32
    800038dc:	84aa                	mv	s1,a0
    800038de:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038e0:	00005597          	auipc	a1,0x5
    800038e4:	d9058593          	addi	a1,a1,-624 # 80008670 <syscalls+0x270>
    800038e8:	0521                	addi	a0,a0,8
    800038ea:	00003097          	auipc	ra,0x3
    800038ee:	8da080e7          	jalr	-1830(ra) # 800061c4 <initlock>
  lk->name = name;
    800038f2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038f6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038fa:	0204a423          	sw	zero,40(s1)
}
    800038fe:	60e2                	ld	ra,24(sp)
    80003900:	6442                	ld	s0,16(sp)
    80003902:	64a2                	ld	s1,8(sp)
    80003904:	6902                	ld	s2,0(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret

000000008000390a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000390a:	1101                	addi	sp,sp,-32
    8000390c:	ec06                	sd	ra,24(sp)
    8000390e:	e822                	sd	s0,16(sp)
    80003910:	e426                	sd	s1,8(sp)
    80003912:	e04a                	sd	s2,0(sp)
    80003914:	1000                	addi	s0,sp,32
    80003916:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003918:	00850913          	addi	s2,a0,8
    8000391c:	854a                	mv	a0,s2
    8000391e:	00003097          	auipc	ra,0x3
    80003922:	936080e7          	jalr	-1738(ra) # 80006254 <acquire>
  while (lk->locked) {
    80003926:	409c                	lw	a5,0(s1)
    80003928:	cb89                	beqz	a5,8000393a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000392a:	85ca                	mv	a1,s2
    8000392c:	8526                	mv	a0,s1
    8000392e:	ffffe097          	auipc	ra,0xffffe
    80003932:	d36080e7          	jalr	-714(ra) # 80001664 <sleep>
  while (lk->locked) {
    80003936:	409c                	lw	a5,0(s1)
    80003938:	fbed                	bnez	a5,8000392a <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000393a:	4785                	li	a5,1
    8000393c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	600080e7          	jalr	1536(ra) # 80000f3e <myproc>
    80003946:	5d1c                	lw	a5,56(a0)
    80003948:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	9bc080e7          	jalr	-1604(ra) # 80006308 <release>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003960:	1101                	addi	sp,sp,-32
    80003962:	ec06                	sd	ra,24(sp)
    80003964:	e822                	sd	s0,16(sp)
    80003966:	e426                	sd	s1,8(sp)
    80003968:	e04a                	sd	s2,0(sp)
    8000396a:	1000                	addi	s0,sp,32
    8000396c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000396e:	00850913          	addi	s2,a0,8
    80003972:	854a                	mv	a0,s2
    80003974:	00003097          	auipc	ra,0x3
    80003978:	8e0080e7          	jalr	-1824(ra) # 80006254 <acquire>
  lk->locked = 0;
    8000397c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003980:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003984:	8526                	mv	a0,s1
    80003986:	ffffe097          	auipc	ra,0xffffe
    8000398a:	d42080e7          	jalr	-702(ra) # 800016c8 <wakeup>
  release(&lk->lk);
    8000398e:	854a                	mv	a0,s2
    80003990:	00003097          	auipc	ra,0x3
    80003994:	978080e7          	jalr	-1672(ra) # 80006308 <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039a4:	7179                	addi	sp,sp,-48
    800039a6:	f406                	sd	ra,40(sp)
    800039a8:	f022                	sd	s0,32(sp)
    800039aa:	ec26                	sd	s1,24(sp)
    800039ac:	e84a                	sd	s2,16(sp)
    800039ae:	e44e                	sd	s3,8(sp)
    800039b0:	1800                	addi	s0,sp,48
    800039b2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039b4:	00850913          	addi	s2,a0,8
    800039b8:	854a                	mv	a0,s2
    800039ba:	00003097          	auipc	ra,0x3
    800039be:	89a080e7          	jalr	-1894(ra) # 80006254 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039c2:	409c                	lw	a5,0(s1)
    800039c4:	ef99                	bnez	a5,800039e2 <holdingsleep+0x3e>
    800039c6:	4481                	li	s1,0
  release(&lk->lk);
    800039c8:	854a                	mv	a0,s2
    800039ca:	00003097          	auipc	ra,0x3
    800039ce:	93e080e7          	jalr	-1730(ra) # 80006308 <release>
  return r;
}
    800039d2:	8526                	mv	a0,s1
    800039d4:	70a2                	ld	ra,40(sp)
    800039d6:	7402                	ld	s0,32(sp)
    800039d8:	64e2                	ld	s1,24(sp)
    800039da:	6942                	ld	s2,16(sp)
    800039dc:	69a2                	ld	s3,8(sp)
    800039de:	6145                	addi	sp,sp,48
    800039e0:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039e2:	0284a983          	lw	s3,40(s1)
    800039e6:	ffffd097          	auipc	ra,0xffffd
    800039ea:	558080e7          	jalr	1368(ra) # 80000f3e <myproc>
    800039ee:	5d04                	lw	s1,56(a0)
    800039f0:	413484b3          	sub	s1,s1,s3
    800039f4:	0014b493          	seqz	s1,s1
    800039f8:	bfc1                	j	800039c8 <holdingsleep+0x24>

00000000800039fa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039fa:	1141                	addi	sp,sp,-16
    800039fc:	e406                	sd	ra,8(sp)
    800039fe:	e022                	sd	s0,0(sp)
    80003a00:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a02:	00005597          	auipc	a1,0x5
    80003a06:	c7e58593          	addi	a1,a1,-898 # 80008680 <syscalls+0x280>
    80003a0a:	00015517          	auipc	a0,0x15
    80003a0e:	29e50513          	addi	a0,a0,670 # 80018ca8 <ftable>
    80003a12:	00002097          	auipc	ra,0x2
    80003a16:	7b2080e7          	jalr	1970(ra) # 800061c4 <initlock>
}
    80003a1a:	60a2                	ld	ra,8(sp)
    80003a1c:	6402                	ld	s0,0(sp)
    80003a1e:	0141                	addi	sp,sp,16
    80003a20:	8082                	ret

0000000080003a22 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a22:	1101                	addi	sp,sp,-32
    80003a24:	ec06                	sd	ra,24(sp)
    80003a26:	e822                	sd	s0,16(sp)
    80003a28:	e426                	sd	s1,8(sp)
    80003a2a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	27c50513          	addi	a0,a0,636 # 80018ca8 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	820080e7          	jalr	-2016(ra) # 80006254 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a3c:	00015497          	auipc	s1,0x15
    80003a40:	28448493          	addi	s1,s1,644 # 80018cc0 <ftable+0x18>
    80003a44:	00016717          	auipc	a4,0x16
    80003a48:	21c70713          	addi	a4,a4,540 # 80019c60 <disk>
    if(f->ref == 0){
    80003a4c:	40dc                	lw	a5,4(s1)
    80003a4e:	cf99                	beqz	a5,80003a6c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a50:	02848493          	addi	s1,s1,40
    80003a54:	fee49ce3          	bne	s1,a4,80003a4c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a58:	00015517          	auipc	a0,0x15
    80003a5c:	25050513          	addi	a0,a0,592 # 80018ca8 <ftable>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	8a8080e7          	jalr	-1880(ra) # 80006308 <release>
  return 0;
    80003a68:	4481                	li	s1,0
    80003a6a:	a819                	j	80003a80 <filealloc+0x5e>
      f->ref = 1;
    80003a6c:	4785                	li	a5,1
    80003a6e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a70:	00015517          	auipc	a0,0x15
    80003a74:	23850513          	addi	a0,a0,568 # 80018ca8 <ftable>
    80003a78:	00003097          	auipc	ra,0x3
    80003a7c:	890080e7          	jalr	-1904(ra) # 80006308 <release>
}
    80003a80:	8526                	mv	a0,s1
    80003a82:	60e2                	ld	ra,24(sp)
    80003a84:	6442                	ld	s0,16(sp)
    80003a86:	64a2                	ld	s1,8(sp)
    80003a88:	6105                	addi	sp,sp,32
    80003a8a:	8082                	ret

0000000080003a8c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a8c:	1101                	addi	sp,sp,-32
    80003a8e:	ec06                	sd	ra,24(sp)
    80003a90:	e822                	sd	s0,16(sp)
    80003a92:	e426                	sd	s1,8(sp)
    80003a94:	1000                	addi	s0,sp,32
    80003a96:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a98:	00015517          	auipc	a0,0x15
    80003a9c:	21050513          	addi	a0,a0,528 # 80018ca8 <ftable>
    80003aa0:	00002097          	auipc	ra,0x2
    80003aa4:	7b4080e7          	jalr	1972(ra) # 80006254 <acquire>
  if(f->ref < 1)
    80003aa8:	40dc                	lw	a5,4(s1)
    80003aaa:	02f05263          	blez	a5,80003ace <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003aae:	2785                	addiw	a5,a5,1
    80003ab0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ab2:	00015517          	auipc	a0,0x15
    80003ab6:	1f650513          	addi	a0,a0,502 # 80018ca8 <ftable>
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	84e080e7          	jalr	-1970(ra) # 80006308 <release>
  return f;
}
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	60e2                	ld	ra,24(sp)
    80003ac6:	6442                	ld	s0,16(sp)
    80003ac8:	64a2                	ld	s1,8(sp)
    80003aca:	6105                	addi	sp,sp,32
    80003acc:	8082                	ret
    panic("filedup");
    80003ace:	00005517          	auipc	a0,0x5
    80003ad2:	bba50513          	addi	a0,a0,-1094 # 80008688 <syscalls+0x288>
    80003ad6:	00002097          	auipc	ra,0x2
    80003ada:	246080e7          	jalr	582(ra) # 80005d1c <panic>

0000000080003ade <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ade:	7139                	addi	sp,sp,-64
    80003ae0:	fc06                	sd	ra,56(sp)
    80003ae2:	f822                	sd	s0,48(sp)
    80003ae4:	f426                	sd	s1,40(sp)
    80003ae6:	f04a                	sd	s2,32(sp)
    80003ae8:	ec4e                	sd	s3,24(sp)
    80003aea:	e852                	sd	s4,16(sp)
    80003aec:	e456                	sd	s5,8(sp)
    80003aee:	0080                	addi	s0,sp,64
    80003af0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003af2:	00015517          	auipc	a0,0x15
    80003af6:	1b650513          	addi	a0,a0,438 # 80018ca8 <ftable>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	75a080e7          	jalr	1882(ra) # 80006254 <acquire>
  if(f->ref < 1)
    80003b02:	40dc                	lw	a5,4(s1)
    80003b04:	06f05163          	blez	a5,80003b66 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b08:	37fd                	addiw	a5,a5,-1
    80003b0a:	0007871b          	sext.w	a4,a5
    80003b0e:	c0dc                	sw	a5,4(s1)
    80003b10:	06e04363          	bgtz	a4,80003b76 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b14:	0004a903          	lw	s2,0(s1)
    80003b18:	0094ca83          	lbu	s5,9(s1)
    80003b1c:	0104ba03          	ld	s4,16(s1)
    80003b20:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b24:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b28:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b2c:	00015517          	auipc	a0,0x15
    80003b30:	17c50513          	addi	a0,a0,380 # 80018ca8 <ftable>
    80003b34:	00002097          	auipc	ra,0x2
    80003b38:	7d4080e7          	jalr	2004(ra) # 80006308 <release>

  if(ff.type == FD_PIPE){
    80003b3c:	4785                	li	a5,1
    80003b3e:	04f90d63          	beq	s2,a5,80003b98 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b42:	3979                	addiw	s2,s2,-2
    80003b44:	4785                	li	a5,1
    80003b46:	0527e063          	bltu	a5,s2,80003b86 <fileclose+0xa8>
    begin_op();
    80003b4a:	00000097          	auipc	ra,0x0
    80003b4e:	acc080e7          	jalr	-1332(ra) # 80003616 <begin_op>
    iput(ff.ip);
    80003b52:	854e                	mv	a0,s3
    80003b54:	fffff097          	auipc	ra,0xfffff
    80003b58:	2b0080e7          	jalr	688(ra) # 80002e04 <iput>
    end_op();
    80003b5c:	00000097          	auipc	ra,0x0
    80003b60:	b38080e7          	jalr	-1224(ra) # 80003694 <end_op>
    80003b64:	a00d                	j	80003b86 <fileclose+0xa8>
    panic("fileclose");
    80003b66:	00005517          	auipc	a0,0x5
    80003b6a:	b2a50513          	addi	a0,a0,-1238 # 80008690 <syscalls+0x290>
    80003b6e:	00002097          	auipc	ra,0x2
    80003b72:	1ae080e7          	jalr	430(ra) # 80005d1c <panic>
    release(&ftable.lock);
    80003b76:	00015517          	auipc	a0,0x15
    80003b7a:	13250513          	addi	a0,a0,306 # 80018ca8 <ftable>
    80003b7e:	00002097          	auipc	ra,0x2
    80003b82:	78a080e7          	jalr	1930(ra) # 80006308 <release>
  }
}
    80003b86:	70e2                	ld	ra,56(sp)
    80003b88:	7442                	ld	s0,48(sp)
    80003b8a:	74a2                	ld	s1,40(sp)
    80003b8c:	7902                	ld	s2,32(sp)
    80003b8e:	69e2                	ld	s3,24(sp)
    80003b90:	6a42                	ld	s4,16(sp)
    80003b92:	6aa2                	ld	s5,8(sp)
    80003b94:	6121                	addi	sp,sp,64
    80003b96:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b98:	85d6                	mv	a1,s5
    80003b9a:	8552                	mv	a0,s4
    80003b9c:	00000097          	auipc	ra,0x0
    80003ba0:	34c080e7          	jalr	844(ra) # 80003ee8 <pipeclose>
    80003ba4:	b7cd                	j	80003b86 <fileclose+0xa8>

0000000080003ba6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ba6:	715d                	addi	sp,sp,-80
    80003ba8:	e486                	sd	ra,72(sp)
    80003baa:	e0a2                	sd	s0,64(sp)
    80003bac:	fc26                	sd	s1,56(sp)
    80003bae:	f84a                	sd	s2,48(sp)
    80003bb0:	f44e                	sd	s3,40(sp)
    80003bb2:	0880                	addi	s0,sp,80
    80003bb4:	84aa                	mv	s1,a0
    80003bb6:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bb8:	ffffd097          	auipc	ra,0xffffd
    80003bbc:	386080e7          	jalr	902(ra) # 80000f3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bc0:	409c                	lw	a5,0(s1)
    80003bc2:	37f9                	addiw	a5,a5,-2
    80003bc4:	4705                	li	a4,1
    80003bc6:	04f76763          	bltu	a4,a5,80003c14 <filestat+0x6e>
    80003bca:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bcc:	6c88                	ld	a0,24(s1)
    80003bce:	fffff097          	auipc	ra,0xfffff
    80003bd2:	07c080e7          	jalr	124(ra) # 80002c4a <ilock>
    stati(f->ip, &st);
    80003bd6:	fb840593          	addi	a1,s0,-72
    80003bda:	6c88                	ld	a0,24(s1)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	2f8080e7          	jalr	760(ra) # 80002ed4 <stati>
    iunlock(f->ip);
    80003be4:	6c88                	ld	a0,24(s1)
    80003be6:	fffff097          	auipc	ra,0xfffff
    80003bea:	126080e7          	jalr	294(ra) # 80002d0c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bee:	46e1                	li	a3,24
    80003bf0:	fb840613          	addi	a2,s0,-72
    80003bf4:	85ce                	mv	a1,s3
    80003bf6:	05893503          	ld	a0,88(s2)
    80003bfa:	ffffd097          	auipc	ra,0xffffd
    80003bfe:	f1a080e7          	jalr	-230(ra) # 80000b14 <copyout>
    80003c02:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c06:	60a6                	ld	ra,72(sp)
    80003c08:	6406                	ld	s0,64(sp)
    80003c0a:	74e2                	ld	s1,56(sp)
    80003c0c:	7942                	ld	s2,48(sp)
    80003c0e:	79a2                	ld	s3,40(sp)
    80003c10:	6161                	addi	sp,sp,80
    80003c12:	8082                	ret
  return -1;
    80003c14:	557d                	li	a0,-1
    80003c16:	bfc5                	j	80003c06 <filestat+0x60>

0000000080003c18 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c18:	7179                	addi	sp,sp,-48
    80003c1a:	f406                	sd	ra,40(sp)
    80003c1c:	f022                	sd	s0,32(sp)
    80003c1e:	ec26                	sd	s1,24(sp)
    80003c20:	e84a                	sd	s2,16(sp)
    80003c22:	e44e                	sd	s3,8(sp)
    80003c24:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c26:	00854783          	lbu	a5,8(a0)
    80003c2a:	c3d5                	beqz	a5,80003cce <fileread+0xb6>
    80003c2c:	84aa                	mv	s1,a0
    80003c2e:	89ae                	mv	s3,a1
    80003c30:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c32:	411c                	lw	a5,0(a0)
    80003c34:	4705                	li	a4,1
    80003c36:	04e78963          	beq	a5,a4,80003c88 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c3a:	470d                	li	a4,3
    80003c3c:	04e78d63          	beq	a5,a4,80003c96 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c40:	4709                	li	a4,2
    80003c42:	06e79e63          	bne	a5,a4,80003cbe <fileread+0xa6>
    ilock(f->ip);
    80003c46:	6d08                	ld	a0,24(a0)
    80003c48:	fffff097          	auipc	ra,0xfffff
    80003c4c:	002080e7          	jalr	2(ra) # 80002c4a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c50:	874a                	mv	a4,s2
    80003c52:	5094                	lw	a3,32(s1)
    80003c54:	864e                	mv	a2,s3
    80003c56:	4585                	li	a1,1
    80003c58:	6c88                	ld	a0,24(s1)
    80003c5a:	fffff097          	auipc	ra,0xfffff
    80003c5e:	2a4080e7          	jalr	676(ra) # 80002efe <readi>
    80003c62:	892a                	mv	s2,a0
    80003c64:	00a05563          	blez	a0,80003c6e <fileread+0x56>
      f->off += r;
    80003c68:	509c                	lw	a5,32(s1)
    80003c6a:	9fa9                	addw	a5,a5,a0
    80003c6c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c6e:	6c88                	ld	a0,24(s1)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	09c080e7          	jalr	156(ra) # 80002d0c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c78:	854a                	mv	a0,s2
    80003c7a:	70a2                	ld	ra,40(sp)
    80003c7c:	7402                	ld	s0,32(sp)
    80003c7e:	64e2                	ld	s1,24(sp)
    80003c80:	6942                	ld	s2,16(sp)
    80003c82:	69a2                	ld	s3,8(sp)
    80003c84:	6145                	addi	sp,sp,48
    80003c86:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c88:	6908                	ld	a0,16(a0)
    80003c8a:	00000097          	auipc	ra,0x0
    80003c8e:	3c6080e7          	jalr	966(ra) # 80004050 <piperead>
    80003c92:	892a                	mv	s2,a0
    80003c94:	b7d5                	j	80003c78 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c96:	02451783          	lh	a5,36(a0)
    80003c9a:	03079693          	slli	a3,a5,0x30
    80003c9e:	92c1                	srli	a3,a3,0x30
    80003ca0:	4725                	li	a4,9
    80003ca2:	02d76863          	bltu	a4,a3,80003cd2 <fileread+0xba>
    80003ca6:	0792                	slli	a5,a5,0x4
    80003ca8:	00015717          	auipc	a4,0x15
    80003cac:	f6070713          	addi	a4,a4,-160 # 80018c08 <devsw>
    80003cb0:	97ba                	add	a5,a5,a4
    80003cb2:	639c                	ld	a5,0(a5)
    80003cb4:	c38d                	beqz	a5,80003cd6 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cb6:	4505                	li	a0,1
    80003cb8:	9782                	jalr	a5
    80003cba:	892a                	mv	s2,a0
    80003cbc:	bf75                	j	80003c78 <fileread+0x60>
    panic("fileread");
    80003cbe:	00005517          	auipc	a0,0x5
    80003cc2:	9e250513          	addi	a0,a0,-1566 # 800086a0 <syscalls+0x2a0>
    80003cc6:	00002097          	auipc	ra,0x2
    80003cca:	056080e7          	jalr	86(ra) # 80005d1c <panic>
    return -1;
    80003cce:	597d                	li	s2,-1
    80003cd0:	b765                	j	80003c78 <fileread+0x60>
      return -1;
    80003cd2:	597d                	li	s2,-1
    80003cd4:	b755                	j	80003c78 <fileread+0x60>
    80003cd6:	597d                	li	s2,-1
    80003cd8:	b745                	j	80003c78 <fileread+0x60>

0000000080003cda <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cda:	715d                	addi	sp,sp,-80
    80003cdc:	e486                	sd	ra,72(sp)
    80003cde:	e0a2                	sd	s0,64(sp)
    80003ce0:	fc26                	sd	s1,56(sp)
    80003ce2:	f84a                	sd	s2,48(sp)
    80003ce4:	f44e                	sd	s3,40(sp)
    80003ce6:	f052                	sd	s4,32(sp)
    80003ce8:	ec56                	sd	s5,24(sp)
    80003cea:	e85a                	sd	s6,16(sp)
    80003cec:	e45e                	sd	s7,8(sp)
    80003cee:	e062                	sd	s8,0(sp)
    80003cf0:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003cf2:	00954783          	lbu	a5,9(a0)
    80003cf6:	10078663          	beqz	a5,80003e02 <filewrite+0x128>
    80003cfa:	892a                	mv	s2,a0
    80003cfc:	8b2e                	mv	s6,a1
    80003cfe:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d00:	411c                	lw	a5,0(a0)
    80003d02:	4705                	li	a4,1
    80003d04:	02e78263          	beq	a5,a4,80003d28 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d08:	470d                	li	a4,3
    80003d0a:	02e78663          	beq	a5,a4,80003d36 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d0e:	4709                	li	a4,2
    80003d10:	0ee79163          	bne	a5,a4,80003df2 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d14:	0ac05d63          	blez	a2,80003dce <filewrite+0xf4>
    int i = 0;
    80003d18:	4981                	li	s3,0
    80003d1a:	6b85                	lui	s7,0x1
    80003d1c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d20:	6c05                	lui	s8,0x1
    80003d22:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d26:	a861                	j	80003dbe <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d28:	6908                	ld	a0,16(a0)
    80003d2a:	00000097          	auipc	ra,0x0
    80003d2e:	22e080e7          	jalr	558(ra) # 80003f58 <pipewrite>
    80003d32:	8a2a                	mv	s4,a0
    80003d34:	a045                	j	80003dd4 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d36:	02451783          	lh	a5,36(a0)
    80003d3a:	03079693          	slli	a3,a5,0x30
    80003d3e:	92c1                	srli	a3,a3,0x30
    80003d40:	4725                	li	a4,9
    80003d42:	0cd76263          	bltu	a4,a3,80003e06 <filewrite+0x12c>
    80003d46:	0792                	slli	a5,a5,0x4
    80003d48:	00015717          	auipc	a4,0x15
    80003d4c:	ec070713          	addi	a4,a4,-320 # 80018c08 <devsw>
    80003d50:	97ba                	add	a5,a5,a4
    80003d52:	679c                	ld	a5,8(a5)
    80003d54:	cbdd                	beqz	a5,80003e0a <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d56:	4505                	li	a0,1
    80003d58:	9782                	jalr	a5
    80003d5a:	8a2a                	mv	s4,a0
    80003d5c:	a8a5                	j	80003dd4 <filewrite+0xfa>
    80003d5e:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	8b4080e7          	jalr	-1868(ra) # 80003616 <begin_op>
      ilock(f->ip);
    80003d6a:	01893503          	ld	a0,24(s2)
    80003d6e:	fffff097          	auipc	ra,0xfffff
    80003d72:	edc080e7          	jalr	-292(ra) # 80002c4a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d76:	8756                	mv	a4,s5
    80003d78:	02092683          	lw	a3,32(s2)
    80003d7c:	01698633          	add	a2,s3,s6
    80003d80:	4585                	li	a1,1
    80003d82:	01893503          	ld	a0,24(s2)
    80003d86:	fffff097          	auipc	ra,0xfffff
    80003d8a:	270080e7          	jalr	624(ra) # 80002ff6 <writei>
    80003d8e:	84aa                	mv	s1,a0
    80003d90:	00a05763          	blez	a0,80003d9e <filewrite+0xc4>
        f->off += r;
    80003d94:	02092783          	lw	a5,32(s2)
    80003d98:	9fa9                	addw	a5,a5,a0
    80003d9a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d9e:	01893503          	ld	a0,24(s2)
    80003da2:	fffff097          	auipc	ra,0xfffff
    80003da6:	f6a080e7          	jalr	-150(ra) # 80002d0c <iunlock>
      end_op();
    80003daa:	00000097          	auipc	ra,0x0
    80003dae:	8ea080e7          	jalr	-1814(ra) # 80003694 <end_op>

      if(r != n1){
    80003db2:	009a9f63          	bne	s5,s1,80003dd0 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003db6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dba:	0149db63          	bge	s3,s4,80003dd0 <filewrite+0xf6>
      int n1 = n - i;
    80003dbe:	413a04bb          	subw	s1,s4,s3
    80003dc2:	0004879b          	sext.w	a5,s1
    80003dc6:	f8fbdce3          	bge	s7,a5,80003d5e <filewrite+0x84>
    80003dca:	84e2                	mv	s1,s8
    80003dcc:	bf49                	j	80003d5e <filewrite+0x84>
    int i = 0;
    80003dce:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dd0:	013a1f63          	bne	s4,s3,80003dee <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dd4:	8552                	mv	a0,s4
    80003dd6:	60a6                	ld	ra,72(sp)
    80003dd8:	6406                	ld	s0,64(sp)
    80003dda:	74e2                	ld	s1,56(sp)
    80003ddc:	7942                	ld	s2,48(sp)
    80003dde:	79a2                	ld	s3,40(sp)
    80003de0:	7a02                	ld	s4,32(sp)
    80003de2:	6ae2                	ld	s5,24(sp)
    80003de4:	6b42                	ld	s6,16(sp)
    80003de6:	6ba2                	ld	s7,8(sp)
    80003de8:	6c02                	ld	s8,0(sp)
    80003dea:	6161                	addi	sp,sp,80
    80003dec:	8082                	ret
    ret = (i == n ? n : -1);
    80003dee:	5a7d                	li	s4,-1
    80003df0:	b7d5                	j	80003dd4 <filewrite+0xfa>
    panic("filewrite");
    80003df2:	00005517          	auipc	a0,0x5
    80003df6:	8be50513          	addi	a0,a0,-1858 # 800086b0 <syscalls+0x2b0>
    80003dfa:	00002097          	auipc	ra,0x2
    80003dfe:	f22080e7          	jalr	-222(ra) # 80005d1c <panic>
    return -1;
    80003e02:	5a7d                	li	s4,-1
    80003e04:	bfc1                	j	80003dd4 <filewrite+0xfa>
      return -1;
    80003e06:	5a7d                	li	s4,-1
    80003e08:	b7f1                	j	80003dd4 <filewrite+0xfa>
    80003e0a:	5a7d                	li	s4,-1
    80003e0c:	b7e1                	j	80003dd4 <filewrite+0xfa>

0000000080003e0e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e0e:	7179                	addi	sp,sp,-48
    80003e10:	f406                	sd	ra,40(sp)
    80003e12:	f022                	sd	s0,32(sp)
    80003e14:	ec26                	sd	s1,24(sp)
    80003e16:	e84a                	sd	s2,16(sp)
    80003e18:	e44e                	sd	s3,8(sp)
    80003e1a:	e052                	sd	s4,0(sp)
    80003e1c:	1800                	addi	s0,sp,48
    80003e1e:	84aa                	mv	s1,a0
    80003e20:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e22:	0005b023          	sd	zero,0(a1)
    80003e26:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	bf8080e7          	jalr	-1032(ra) # 80003a22 <filealloc>
    80003e32:	e088                	sd	a0,0(s1)
    80003e34:	c551                	beqz	a0,80003ec0 <pipealloc+0xb2>
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	bec080e7          	jalr	-1044(ra) # 80003a22 <filealloc>
    80003e3e:	00aa3023          	sd	a0,0(s4)
    80003e42:	c92d                	beqz	a0,80003eb4 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e44:	ffffc097          	auipc	ra,0xffffc
    80003e48:	2d6080e7          	jalr	726(ra) # 8000011a <kalloc>
    80003e4c:	892a                	mv	s2,a0
    80003e4e:	c125                	beqz	a0,80003eae <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e50:	4985                	li	s3,1
    80003e52:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e56:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e5a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e5e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e62:	00005597          	auipc	a1,0x5
    80003e66:	85e58593          	addi	a1,a1,-1954 # 800086c0 <syscalls+0x2c0>
    80003e6a:	00002097          	auipc	ra,0x2
    80003e6e:	35a080e7          	jalr	858(ra) # 800061c4 <initlock>
  (*f0)->type = FD_PIPE;
    80003e72:	609c                	ld	a5,0(s1)
    80003e74:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e78:	609c                	ld	a5,0(s1)
    80003e7a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e7e:	609c                	ld	a5,0(s1)
    80003e80:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e84:	609c                	ld	a5,0(s1)
    80003e86:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e8a:	000a3783          	ld	a5,0(s4)
    80003e8e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e92:	000a3783          	ld	a5,0(s4)
    80003e96:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e9a:	000a3783          	ld	a5,0(s4)
    80003e9e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ea2:	000a3783          	ld	a5,0(s4)
    80003ea6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eaa:	4501                	li	a0,0
    80003eac:	a025                	j	80003ed4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eae:	6088                	ld	a0,0(s1)
    80003eb0:	e501                	bnez	a0,80003eb8 <pipealloc+0xaa>
    80003eb2:	a039                	j	80003ec0 <pipealloc+0xb2>
    80003eb4:	6088                	ld	a0,0(s1)
    80003eb6:	c51d                	beqz	a0,80003ee4 <pipealloc+0xd6>
    fileclose(*f0);
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	c26080e7          	jalr	-986(ra) # 80003ade <fileclose>
  if(*f1)
    80003ec0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ec4:	557d                	li	a0,-1
  if(*f1)
    80003ec6:	c799                	beqz	a5,80003ed4 <pipealloc+0xc6>
    fileclose(*f1);
    80003ec8:	853e                	mv	a0,a5
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	c14080e7          	jalr	-1004(ra) # 80003ade <fileclose>
  return -1;
    80003ed2:	557d                	li	a0,-1
}
    80003ed4:	70a2                	ld	ra,40(sp)
    80003ed6:	7402                	ld	s0,32(sp)
    80003ed8:	64e2                	ld	s1,24(sp)
    80003eda:	6942                	ld	s2,16(sp)
    80003edc:	69a2                	ld	s3,8(sp)
    80003ede:	6a02                	ld	s4,0(sp)
    80003ee0:	6145                	addi	sp,sp,48
    80003ee2:	8082                	ret
  return -1;
    80003ee4:	557d                	li	a0,-1
    80003ee6:	b7fd                	j	80003ed4 <pipealloc+0xc6>

0000000080003ee8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	e04a                	sd	s2,0(sp)
    80003ef2:	1000                	addi	s0,sp,32
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ef8:	00002097          	auipc	ra,0x2
    80003efc:	35c080e7          	jalr	860(ra) # 80006254 <acquire>
  if(writable){
    80003f00:	02090d63          	beqz	s2,80003f3a <pipeclose+0x52>
    pi->writeopen = 0;
    80003f04:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f08:	21848513          	addi	a0,s1,536
    80003f0c:	ffffd097          	auipc	ra,0xffffd
    80003f10:	7bc080e7          	jalr	1980(ra) # 800016c8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f14:	2204b783          	ld	a5,544(s1)
    80003f18:	eb95                	bnez	a5,80003f4c <pipeclose+0x64>
    release(&pi->lock);
    80003f1a:	8526                	mv	a0,s1
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	3ec080e7          	jalr	1004(ra) # 80006308 <release>
    kfree((char*)pi);
    80003f24:	8526                	mv	a0,s1
    80003f26:	ffffc097          	auipc	ra,0xffffc
    80003f2a:	0f6080e7          	jalr	246(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f2e:	60e2                	ld	ra,24(sp)
    80003f30:	6442                	ld	s0,16(sp)
    80003f32:	64a2                	ld	s1,8(sp)
    80003f34:	6902                	ld	s2,0(sp)
    80003f36:	6105                	addi	sp,sp,32
    80003f38:	8082                	ret
    pi->readopen = 0;
    80003f3a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f3e:	21c48513          	addi	a0,s1,540
    80003f42:	ffffd097          	auipc	ra,0xffffd
    80003f46:	786080e7          	jalr	1926(ra) # 800016c8 <wakeup>
    80003f4a:	b7e9                	j	80003f14 <pipeclose+0x2c>
    release(&pi->lock);
    80003f4c:	8526                	mv	a0,s1
    80003f4e:	00002097          	auipc	ra,0x2
    80003f52:	3ba080e7          	jalr	954(ra) # 80006308 <release>
}
    80003f56:	bfe1                	j	80003f2e <pipeclose+0x46>

0000000080003f58 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f58:	711d                	addi	sp,sp,-96
    80003f5a:	ec86                	sd	ra,88(sp)
    80003f5c:	e8a2                	sd	s0,80(sp)
    80003f5e:	e4a6                	sd	s1,72(sp)
    80003f60:	e0ca                	sd	s2,64(sp)
    80003f62:	fc4e                	sd	s3,56(sp)
    80003f64:	f852                	sd	s4,48(sp)
    80003f66:	f456                	sd	s5,40(sp)
    80003f68:	f05a                	sd	s6,32(sp)
    80003f6a:	ec5e                	sd	s7,24(sp)
    80003f6c:	e862                	sd	s8,16(sp)
    80003f6e:	1080                	addi	s0,sp,96
    80003f70:	84aa                	mv	s1,a0
    80003f72:	8aae                	mv	s5,a1
    80003f74:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f76:	ffffd097          	auipc	ra,0xffffd
    80003f7a:	fc8080e7          	jalr	-56(ra) # 80000f3e <myproc>
    80003f7e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f80:	8526                	mv	a0,s1
    80003f82:	00002097          	auipc	ra,0x2
    80003f86:	2d2080e7          	jalr	722(ra) # 80006254 <acquire>
  while(i < n){
    80003f8a:	0b405663          	blez	s4,80004036 <pipewrite+0xde>
  int i = 0;
    80003f8e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f90:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f92:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f96:	21c48b93          	addi	s7,s1,540
    80003f9a:	a089                	j	80003fdc <pipewrite+0x84>
      release(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	36a080e7          	jalr	874(ra) # 80006308 <release>
      return -1;
    80003fa6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fa8:	854a                	mv	a0,s2
    80003faa:	60e6                	ld	ra,88(sp)
    80003fac:	6446                	ld	s0,80(sp)
    80003fae:	64a6                	ld	s1,72(sp)
    80003fb0:	6906                	ld	s2,64(sp)
    80003fb2:	79e2                	ld	s3,56(sp)
    80003fb4:	7a42                	ld	s4,48(sp)
    80003fb6:	7aa2                	ld	s5,40(sp)
    80003fb8:	7b02                	ld	s6,32(sp)
    80003fba:	6be2                	ld	s7,24(sp)
    80003fbc:	6c42                	ld	s8,16(sp)
    80003fbe:	6125                	addi	sp,sp,96
    80003fc0:	8082                	ret
      wakeup(&pi->nread);
    80003fc2:	8562                	mv	a0,s8
    80003fc4:	ffffd097          	auipc	ra,0xffffd
    80003fc8:	704080e7          	jalr	1796(ra) # 800016c8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fcc:	85a6                	mv	a1,s1
    80003fce:	855e                	mv	a0,s7
    80003fd0:	ffffd097          	auipc	ra,0xffffd
    80003fd4:	694080e7          	jalr	1684(ra) # 80001664 <sleep>
  while(i < n){
    80003fd8:	07495063          	bge	s2,s4,80004038 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003fdc:	2204a783          	lw	a5,544(s1)
    80003fe0:	dfd5                	beqz	a5,80003f9c <pipewrite+0x44>
    80003fe2:	854e                	mv	a0,s3
    80003fe4:	ffffe097          	auipc	ra,0xffffe
    80003fe8:	928080e7          	jalr	-1752(ra) # 8000190c <killed>
    80003fec:	f945                	bnez	a0,80003f9c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fee:	2184a783          	lw	a5,536(s1)
    80003ff2:	21c4a703          	lw	a4,540(s1)
    80003ff6:	2007879b          	addiw	a5,a5,512
    80003ffa:	fcf704e3          	beq	a4,a5,80003fc2 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ffe:	4685                	li	a3,1
    80004000:	01590633          	add	a2,s2,s5
    80004004:	faf40593          	addi	a1,s0,-81
    80004008:	0589b503          	ld	a0,88(s3)
    8000400c:	ffffd097          	auipc	ra,0xffffd
    80004010:	b94080e7          	jalr	-1132(ra) # 80000ba0 <copyin>
    80004014:	03650263          	beq	a0,s6,80004038 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004018:	21c4a783          	lw	a5,540(s1)
    8000401c:	0017871b          	addiw	a4,a5,1
    80004020:	20e4ae23          	sw	a4,540(s1)
    80004024:	1ff7f793          	andi	a5,a5,511
    80004028:	97a6                	add	a5,a5,s1
    8000402a:	faf44703          	lbu	a4,-81(s0)
    8000402e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004032:	2905                	addiw	s2,s2,1
    80004034:	b755                	j	80003fd8 <pipewrite+0x80>
  int i = 0;
    80004036:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004038:	21848513          	addi	a0,s1,536
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	68c080e7          	jalr	1676(ra) # 800016c8 <wakeup>
  release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	2c2080e7          	jalr	706(ra) # 80006308 <release>
  return i;
    8000404e:	bfa9                	j	80003fa8 <pipewrite+0x50>

0000000080004050 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004050:	715d                	addi	sp,sp,-80
    80004052:	e486                	sd	ra,72(sp)
    80004054:	e0a2                	sd	s0,64(sp)
    80004056:	fc26                	sd	s1,56(sp)
    80004058:	f84a                	sd	s2,48(sp)
    8000405a:	f44e                	sd	s3,40(sp)
    8000405c:	f052                	sd	s4,32(sp)
    8000405e:	ec56                	sd	s5,24(sp)
    80004060:	e85a                	sd	s6,16(sp)
    80004062:	0880                	addi	s0,sp,80
    80004064:	84aa                	mv	s1,a0
    80004066:	892e                	mv	s2,a1
    80004068:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	ed4080e7          	jalr	-300(ra) # 80000f3e <myproc>
    80004072:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	1de080e7          	jalr	478(ra) # 80006254 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000407e:	2184a703          	lw	a4,536(s1)
    80004082:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004086:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000408a:	02f71763          	bne	a4,a5,800040b8 <piperead+0x68>
    8000408e:	2244a783          	lw	a5,548(s1)
    80004092:	c39d                	beqz	a5,800040b8 <piperead+0x68>
    if(killed(pr)){
    80004094:	8552                	mv	a0,s4
    80004096:	ffffe097          	auipc	ra,0xffffe
    8000409a:	876080e7          	jalr	-1930(ra) # 8000190c <killed>
    8000409e:	e949                	bnez	a0,80004130 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a0:	85a6                	mv	a1,s1
    800040a2:	854e                	mv	a0,s3
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	5c0080e7          	jalr	1472(ra) # 80001664 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	2184a703          	lw	a4,536(s1)
    800040b0:	21c4a783          	lw	a5,540(s1)
    800040b4:	fcf70de3          	beq	a4,a5,8000408e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ba:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040bc:	05505463          	blez	s5,80004104 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040c0:	2184a783          	lw	a5,536(s1)
    800040c4:	21c4a703          	lw	a4,540(s1)
    800040c8:	02f70e63          	beq	a4,a5,80004104 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040cc:	0017871b          	addiw	a4,a5,1
    800040d0:	20e4ac23          	sw	a4,536(s1)
    800040d4:	1ff7f793          	andi	a5,a5,511
    800040d8:	97a6                	add	a5,a5,s1
    800040da:	0187c783          	lbu	a5,24(a5)
    800040de:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e2:	4685                	li	a3,1
    800040e4:	fbf40613          	addi	a2,s0,-65
    800040e8:	85ca                	mv	a1,s2
    800040ea:	058a3503          	ld	a0,88(s4)
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	a26080e7          	jalr	-1498(ra) # 80000b14 <copyout>
    800040f6:	01650763          	beq	a0,s6,80004104 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040fa:	2985                	addiw	s3,s3,1
    800040fc:	0905                	addi	s2,s2,1
    800040fe:	fd3a91e3          	bne	s5,s3,800040c0 <piperead+0x70>
    80004102:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004104:	21c48513          	addi	a0,s1,540
    80004108:	ffffd097          	auipc	ra,0xffffd
    8000410c:	5c0080e7          	jalr	1472(ra) # 800016c8 <wakeup>
  release(&pi->lock);
    80004110:	8526                	mv	a0,s1
    80004112:	00002097          	auipc	ra,0x2
    80004116:	1f6080e7          	jalr	502(ra) # 80006308 <release>
  return i;
}
    8000411a:	854e                	mv	a0,s3
    8000411c:	60a6                	ld	ra,72(sp)
    8000411e:	6406                	ld	s0,64(sp)
    80004120:	74e2                	ld	s1,56(sp)
    80004122:	7942                	ld	s2,48(sp)
    80004124:	79a2                	ld	s3,40(sp)
    80004126:	7a02                	ld	s4,32(sp)
    80004128:	6ae2                	ld	s5,24(sp)
    8000412a:	6b42                	ld	s6,16(sp)
    8000412c:	6161                	addi	sp,sp,80
    8000412e:	8082                	ret
      release(&pi->lock);
    80004130:	8526                	mv	a0,s1
    80004132:	00002097          	auipc	ra,0x2
    80004136:	1d6080e7          	jalr	470(ra) # 80006308 <release>
      return -1;
    8000413a:	59fd                	li	s3,-1
    8000413c:	bff9                	j	8000411a <piperead+0xca>

000000008000413e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000413e:	1141                	addi	sp,sp,-16
    80004140:	e422                	sd	s0,8(sp)
    80004142:	0800                	addi	s0,sp,16
    80004144:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004146:	8905                	andi	a0,a0,1
    80004148:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000414a:	8b89                	andi	a5,a5,2
    8000414c:	c399                	beqz	a5,80004152 <flags2perm+0x14>
      perm |= PTE_W;
    8000414e:	00456513          	ori	a0,a0,4
    return perm;
}
    80004152:	6422                	ld	s0,8(sp)
    80004154:	0141                	addi	sp,sp,16
    80004156:	8082                	ret

0000000080004158 <exec>:

int
exec(char *path, char **argv)
{
    80004158:	de010113          	addi	sp,sp,-544
    8000415c:	20113c23          	sd	ra,536(sp)
    80004160:	20813823          	sd	s0,528(sp)
    80004164:	20913423          	sd	s1,520(sp)
    80004168:	21213023          	sd	s2,512(sp)
    8000416c:	ffce                	sd	s3,504(sp)
    8000416e:	fbd2                	sd	s4,496(sp)
    80004170:	f7d6                	sd	s5,488(sp)
    80004172:	f3da                	sd	s6,480(sp)
    80004174:	efde                	sd	s7,472(sp)
    80004176:	ebe2                	sd	s8,464(sp)
    80004178:	e7e6                	sd	s9,456(sp)
    8000417a:	e3ea                	sd	s10,448(sp)
    8000417c:	ff6e                	sd	s11,440(sp)
    8000417e:	1400                	addi	s0,sp,544
    80004180:	892a                	mv	s2,a0
    80004182:	dea43423          	sd	a0,-536(s0)
    80004186:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	db4080e7          	jalr	-588(ra) # 80000f3e <myproc>
    80004192:	84aa                	mv	s1,a0

  begin_op();
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	482080e7          	jalr	1154(ra) # 80003616 <begin_op>

  if((ip = namei(path)) == 0){
    8000419c:	854a                	mv	a0,s2
    8000419e:	fffff097          	auipc	ra,0xfffff
    800041a2:	258080e7          	jalr	600(ra) # 800033f6 <namei>
    800041a6:	c93d                	beqz	a0,8000421c <exec+0xc4>
    800041a8:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	aa0080e7          	jalr	-1376(ra) # 80002c4a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b2:	04000713          	li	a4,64
    800041b6:	4681                	li	a3,0
    800041b8:	e5040613          	addi	a2,s0,-432
    800041bc:	4581                	li	a1,0
    800041be:	8556                	mv	a0,s5
    800041c0:	fffff097          	auipc	ra,0xfffff
    800041c4:	d3e080e7          	jalr	-706(ra) # 80002efe <readi>
    800041c8:	04000793          	li	a5,64
    800041cc:	00f51a63          	bne	a0,a5,800041e0 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041d0:	e5042703          	lw	a4,-432(s0)
    800041d4:	464c47b7          	lui	a5,0x464c4
    800041d8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041dc:	04f70663          	beq	a4,a5,80004228 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e0:	8556                	mv	a0,s5
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	cca080e7          	jalr	-822(ra) # 80002eac <iunlockput>
    end_op();
    800041ea:	fffff097          	auipc	ra,0xfffff
    800041ee:	4aa080e7          	jalr	1194(ra) # 80003694 <end_op>
  }
  return -1;
    800041f2:	557d                	li	a0,-1
}
    800041f4:	21813083          	ld	ra,536(sp)
    800041f8:	21013403          	ld	s0,528(sp)
    800041fc:	20813483          	ld	s1,520(sp)
    80004200:	20013903          	ld	s2,512(sp)
    80004204:	79fe                	ld	s3,504(sp)
    80004206:	7a5e                	ld	s4,496(sp)
    80004208:	7abe                	ld	s5,488(sp)
    8000420a:	7b1e                	ld	s6,480(sp)
    8000420c:	6bfe                	ld	s7,472(sp)
    8000420e:	6c5e                	ld	s8,464(sp)
    80004210:	6cbe                	ld	s9,456(sp)
    80004212:	6d1e                	ld	s10,448(sp)
    80004214:	7dfa                	ld	s11,440(sp)
    80004216:	22010113          	addi	sp,sp,544
    8000421a:	8082                	ret
    end_op();
    8000421c:	fffff097          	auipc	ra,0xfffff
    80004220:	478080e7          	jalr	1144(ra) # 80003694 <end_op>
    return -1;
    80004224:	557d                	li	a0,-1
    80004226:	b7f9                	j	800041f4 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004228:	8526                	mv	a0,s1
    8000422a:	ffffd097          	auipc	ra,0xffffd
    8000422e:	dd8080e7          	jalr	-552(ra) # 80001002 <proc_pagetable>
    80004232:	8b2a                	mv	s6,a0
    80004234:	d555                	beqz	a0,800041e0 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004236:	e7042783          	lw	a5,-400(s0)
    8000423a:	e8845703          	lhu	a4,-376(s0)
    8000423e:	c735                	beqz	a4,800042aa <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004240:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004242:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004246:	6a05                	lui	s4,0x1
    80004248:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000424c:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004250:	6d85                	lui	s11,0x1
    80004252:	7d7d                	lui	s10,0xfffff
    80004254:	ac99                	j	800044aa <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004256:	00004517          	auipc	a0,0x4
    8000425a:	47250513          	addi	a0,a0,1138 # 800086c8 <syscalls+0x2c8>
    8000425e:	00002097          	auipc	ra,0x2
    80004262:	abe080e7          	jalr	-1346(ra) # 80005d1c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004266:	874a                	mv	a4,s2
    80004268:	009c86bb          	addw	a3,s9,s1
    8000426c:	4581                	li	a1,0
    8000426e:	8556                	mv	a0,s5
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	c8e080e7          	jalr	-882(ra) # 80002efe <readi>
    80004278:	2501                	sext.w	a0,a0
    8000427a:	1ca91563          	bne	s2,a0,80004444 <exec+0x2ec>
  for(i = 0; i < sz; i += PGSIZE){
    8000427e:	009d84bb          	addw	s1,s11,s1
    80004282:	013d09bb          	addw	s3,s10,s3
    80004286:	2174f263          	bgeu	s1,s7,8000448a <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    8000428a:	02049593          	slli	a1,s1,0x20
    8000428e:	9181                	srli	a1,a1,0x20
    80004290:	95e2                	add	a1,a1,s8
    80004292:	855a                	mv	a0,s6
    80004294:	ffffc097          	auipc	ra,0xffffc
    80004298:	270080e7          	jalr	624(ra) # 80000504 <walkaddr>
    8000429c:	862a                	mv	a2,a0
    if(pa == 0)
    8000429e:	dd45                	beqz	a0,80004256 <exec+0xfe>
      n = PGSIZE;
    800042a0:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042a2:	fd49f2e3          	bgeu	s3,s4,80004266 <exec+0x10e>
      n = sz - i;
    800042a6:	894e                	mv	s2,s3
    800042a8:	bf7d                	j	80004266 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042aa:	4901                	li	s2,0
  iunlockput(ip);
    800042ac:	8556                	mv	a0,s5
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	bfe080e7          	jalr	-1026(ra) # 80002eac <iunlockput>
  end_op();
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	3de080e7          	jalr	990(ra) # 80003694 <end_op>
  p = myproc();
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	c80080e7          	jalr	-896(ra) # 80000f3e <myproc>
    800042c6:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800042c8:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800042cc:	6785                	lui	a5,0x1
    800042ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800042d0:	97ca                	add	a5,a5,s2
    800042d2:	777d                	lui	a4,0xfffff
    800042d4:	8ff9                	and	a5,a5,a4
    800042d6:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042da:	4691                	li	a3,4
    800042dc:	6609                	lui	a2,0x2
    800042de:	963e                	add	a2,a2,a5
    800042e0:	85be                	mv	a1,a5
    800042e2:	855a                	mv	a0,s6
    800042e4:	ffffc097          	auipc	ra,0xffffc
    800042e8:	5d4080e7          	jalr	1492(ra) # 800008b8 <uvmalloc>
    800042ec:	8c2a                	mv	s8,a0
  ip = 0;
    800042ee:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042f0:	14050a63          	beqz	a0,80004444 <exec+0x2ec>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042f4:	75f9                	lui	a1,0xffffe
    800042f6:	95aa                	add	a1,a1,a0
    800042f8:	855a                	mv	a0,s6
    800042fa:	ffffc097          	auipc	ra,0xffffc
    800042fe:	7e8080e7          	jalr	2024(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    80004302:	7afd                	lui	s5,0xfffff
    80004304:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004306:	df043783          	ld	a5,-528(s0)
    8000430a:	6388                	ld	a0,0(a5)
    8000430c:	c925                	beqz	a0,8000437c <exec+0x224>
    8000430e:	e9040993          	addi	s3,s0,-368
    80004312:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004316:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004318:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000431a:	ffffc097          	auipc	ra,0xffffc
    8000431e:	fdc080e7          	jalr	-36(ra) # 800002f6 <strlen>
    80004322:	0015079b          	addiw	a5,a0,1
    80004326:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000432a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000432e:	15596263          	bltu	s2,s5,80004472 <exec+0x31a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004332:	df043d83          	ld	s11,-528(s0)
    80004336:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000433a:	8552                	mv	a0,s4
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	fba080e7          	jalr	-70(ra) # 800002f6 <strlen>
    80004344:	0015069b          	addiw	a3,a0,1
    80004348:	8652                	mv	a2,s4
    8000434a:	85ca                	mv	a1,s2
    8000434c:	855a                	mv	a0,s6
    8000434e:	ffffc097          	auipc	ra,0xffffc
    80004352:	7c6080e7          	jalr	1990(ra) # 80000b14 <copyout>
    80004356:	12054263          	bltz	a0,8000447a <exec+0x322>
    ustack[argc] = sp;
    8000435a:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000435e:	0485                	addi	s1,s1,1
    80004360:	008d8793          	addi	a5,s11,8
    80004364:	def43823          	sd	a5,-528(s0)
    80004368:	008db503          	ld	a0,8(s11)
    8000436c:	c911                	beqz	a0,80004380 <exec+0x228>
    if(argc >= MAXARG)
    8000436e:	09a1                	addi	s3,s3,8
    80004370:	fb3c95e3          	bne	s9,s3,8000431a <exec+0x1c2>
  sz = sz1;
    80004374:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004378:	4a81                	li	s5,0
    8000437a:	a0e9                	j	80004444 <exec+0x2ec>
  sp = sz;
    8000437c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000437e:	4481                	li	s1,0
  ustack[argc] = 0;
    80004380:	00349793          	slli	a5,s1,0x3
    80004384:	f9078793          	addi	a5,a5,-112
    80004388:	97a2                	add	a5,a5,s0
    8000438a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000438e:	00148693          	addi	a3,s1,1
    80004392:	068e                	slli	a3,a3,0x3
    80004394:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004398:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000439c:	01597663          	bgeu	s2,s5,800043a8 <exec+0x250>
  sz = sz1;
    800043a0:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043a4:	4a81                	li	s5,0
    800043a6:	a879                	j	80004444 <exec+0x2ec>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043a8:	e9040613          	addi	a2,s0,-368
    800043ac:	85ca                	mv	a1,s2
    800043ae:	855a                	mv	a0,s6
    800043b0:	ffffc097          	auipc	ra,0xffffc
    800043b4:	764080e7          	jalr	1892(ra) # 80000b14 <copyout>
    800043b8:	0c054563          	bltz	a0,80004482 <exec+0x32a>
  p->trapframe->a1 = sp;
    800043bc:	060bb783          	ld	a5,96(s7)
    800043c0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043c4:	de843783          	ld	a5,-536(s0)
    800043c8:	0007c703          	lbu	a4,0(a5)
    800043cc:	cf11                	beqz	a4,800043e8 <exec+0x290>
    800043ce:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043d0:	02f00693          	li	a3,47
    800043d4:	a039                	j	800043e2 <exec+0x28a>
      last = s+1;
    800043d6:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800043da:	0785                	addi	a5,a5,1
    800043dc:	fff7c703          	lbu	a4,-1(a5)
    800043e0:	c701                	beqz	a4,800043e8 <exec+0x290>
    if(*s == '/')
    800043e2:	fed71ce3          	bne	a4,a3,800043da <exec+0x282>
    800043e6:	bfc5                	j	800043d6 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800043e8:	4641                	li	a2,16
    800043ea:	de843583          	ld	a1,-536(s0)
    800043ee:	160b8513          	addi	a0,s7,352
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	ed2080e7          	jalr	-302(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800043fa:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    800043fe:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    80004402:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004406:	060bb783          	ld	a5,96(s7)
    8000440a:	e6843703          	ld	a4,-408(s0)
    8000440e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004410:	060bb783          	ld	a5,96(s7)
    80004414:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004418:	85ea                	mv	a1,s10
    8000441a:	ffffd097          	auipc	ra,0xffffd
    8000441e:	cb2080e7          	jalr	-846(ra) # 800010cc <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    80004422:	038ba703          	lw	a4,56(s7)
    80004426:	4785                	li	a5,1
    80004428:	00f70563          	beq	a4,a5,80004432 <exec+0x2da>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000442c:	0004851b          	sext.w	a0,s1
    80004430:	b3d1                	j	800041f4 <exec+0x9c>
  if(p->pid==1) vmprint(p->pagetable);
    80004432:	058bb503          	ld	a0,88(s7)
    80004436:	ffffd097          	auipc	ra,0xffffd
    8000443a:	8a8080e7          	jalr	-1880(ra) # 80000cde <vmprint>
    8000443e:	b7fd                	j	8000442c <exec+0x2d4>
    80004440:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004444:	df843583          	ld	a1,-520(s0)
    80004448:	855a                	mv	a0,s6
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	c82080e7          	jalr	-894(ra) # 800010cc <proc_freepagetable>
  if(ip){
    80004452:	d80a97e3          	bnez	s5,800041e0 <exec+0x88>
  return -1;
    80004456:	557d                	li	a0,-1
    80004458:	bb71                	j	800041f4 <exec+0x9c>
    8000445a:	df243c23          	sd	s2,-520(s0)
    8000445e:	b7dd                	j	80004444 <exec+0x2ec>
    80004460:	df243c23          	sd	s2,-520(s0)
    80004464:	b7c5                	j	80004444 <exec+0x2ec>
    80004466:	df243c23          	sd	s2,-520(s0)
    8000446a:	bfe9                	j	80004444 <exec+0x2ec>
    8000446c:	df243c23          	sd	s2,-520(s0)
    80004470:	bfd1                	j	80004444 <exec+0x2ec>
  sz = sz1;
    80004472:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004476:	4a81                	li	s5,0
    80004478:	b7f1                	j	80004444 <exec+0x2ec>
  sz = sz1;
    8000447a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000447e:	4a81                	li	s5,0
    80004480:	b7d1                	j	80004444 <exec+0x2ec>
  sz = sz1;
    80004482:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004486:	4a81                	li	s5,0
    80004488:	bf75                	j	80004444 <exec+0x2ec>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000448e:	e0843783          	ld	a5,-504(s0)
    80004492:	0017869b          	addiw	a3,a5,1
    80004496:	e0d43423          	sd	a3,-504(s0)
    8000449a:	e0043783          	ld	a5,-512(s0)
    8000449e:	0387879b          	addiw	a5,a5,56
    800044a2:	e8845703          	lhu	a4,-376(s0)
    800044a6:	e0e6d3e3          	bge	a3,a4,800042ac <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044aa:	2781                	sext.w	a5,a5
    800044ac:	e0f43023          	sd	a5,-512(s0)
    800044b0:	03800713          	li	a4,56
    800044b4:	86be                	mv	a3,a5
    800044b6:	e1840613          	addi	a2,s0,-488
    800044ba:	4581                	li	a1,0
    800044bc:	8556                	mv	a0,s5
    800044be:	fffff097          	auipc	ra,0xfffff
    800044c2:	a40080e7          	jalr	-1472(ra) # 80002efe <readi>
    800044c6:	03800793          	li	a5,56
    800044ca:	f6f51be3          	bne	a0,a5,80004440 <exec+0x2e8>
    if(ph.type != ELF_PROG_LOAD)
    800044ce:	e1842783          	lw	a5,-488(s0)
    800044d2:	4705                	li	a4,1
    800044d4:	fae79de3          	bne	a5,a4,8000448e <exec+0x336>
    if(ph.memsz < ph.filesz)
    800044d8:	e4043483          	ld	s1,-448(s0)
    800044dc:	e3843783          	ld	a5,-456(s0)
    800044e0:	f6f4ede3          	bltu	s1,a5,8000445a <exec+0x302>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e4:	e2843783          	ld	a5,-472(s0)
    800044e8:	94be                	add	s1,s1,a5
    800044ea:	f6f4ebe3          	bltu	s1,a5,80004460 <exec+0x308>
    if(ph.vaddr % PGSIZE != 0)
    800044ee:	de043703          	ld	a4,-544(s0)
    800044f2:	8ff9                	and	a5,a5,a4
    800044f4:	fbad                	bnez	a5,80004466 <exec+0x30e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f6:	e1c42503          	lw	a0,-484(s0)
    800044fa:	00000097          	auipc	ra,0x0
    800044fe:	c44080e7          	jalr	-956(ra) # 8000413e <flags2perm>
    80004502:	86aa                	mv	a3,a0
    80004504:	8626                	mv	a2,s1
    80004506:	85ca                	mv	a1,s2
    80004508:	855a                	mv	a0,s6
    8000450a:	ffffc097          	auipc	ra,0xffffc
    8000450e:	3ae080e7          	jalr	942(ra) # 800008b8 <uvmalloc>
    80004512:	dea43c23          	sd	a0,-520(s0)
    80004516:	d939                	beqz	a0,8000446c <exec+0x314>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004518:	e2843c03          	ld	s8,-472(s0)
    8000451c:	e2042c83          	lw	s9,-480(s0)
    80004520:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004524:	f60b83e3          	beqz	s7,8000448a <exec+0x332>
    80004528:	89de                	mv	s3,s7
    8000452a:	4481                	li	s1,0
    8000452c:	bbb9                	j	8000428a <exec+0x132>

000000008000452e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000452e:	7179                	addi	sp,sp,-48
    80004530:	f406                	sd	ra,40(sp)
    80004532:	f022                	sd	s0,32(sp)
    80004534:	ec26                	sd	s1,24(sp)
    80004536:	e84a                	sd	s2,16(sp)
    80004538:	1800                	addi	s0,sp,48
    8000453a:	892e                	mv	s2,a1
    8000453c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000453e:	fdc40593          	addi	a1,s0,-36
    80004542:	ffffe097          	auipc	ra,0xffffe
    80004546:	b90080e7          	jalr	-1136(ra) # 800020d2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000454a:	fdc42703          	lw	a4,-36(s0)
    8000454e:	47bd                	li	a5,15
    80004550:	02e7eb63          	bltu	a5,a4,80004586 <argfd+0x58>
    80004554:	ffffd097          	auipc	ra,0xffffd
    80004558:	9ea080e7          	jalr	-1558(ra) # 80000f3e <myproc>
    8000455c:	fdc42703          	lw	a4,-36(s0)
    80004560:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd03a>
    80004564:	078e                	slli	a5,a5,0x3
    80004566:	953e                	add	a0,a0,a5
    80004568:	651c                	ld	a5,8(a0)
    8000456a:	c385                	beqz	a5,8000458a <argfd+0x5c>
    return -1;
  if(pfd)
    8000456c:	00090463          	beqz	s2,80004574 <argfd+0x46>
    *pfd = fd;
    80004570:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004574:	4501                	li	a0,0
  if(pf)
    80004576:	c091                	beqz	s1,8000457a <argfd+0x4c>
    *pf = f;
    80004578:	e09c                	sd	a5,0(s1)
}
    8000457a:	70a2                	ld	ra,40(sp)
    8000457c:	7402                	ld	s0,32(sp)
    8000457e:	64e2                	ld	s1,24(sp)
    80004580:	6942                	ld	s2,16(sp)
    80004582:	6145                	addi	sp,sp,48
    80004584:	8082                	ret
    return -1;
    80004586:	557d                	li	a0,-1
    80004588:	bfcd                	j	8000457a <argfd+0x4c>
    8000458a:	557d                	li	a0,-1
    8000458c:	b7fd                	j	8000457a <argfd+0x4c>

000000008000458e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000458e:	1101                	addi	sp,sp,-32
    80004590:	ec06                	sd	ra,24(sp)
    80004592:	e822                	sd	s0,16(sp)
    80004594:	e426                	sd	s1,8(sp)
    80004596:	1000                	addi	s0,sp,32
    80004598:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000459a:	ffffd097          	auipc	ra,0xffffd
    8000459e:	9a4080e7          	jalr	-1628(ra) # 80000f3e <myproc>
    800045a2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045a4:	0d850793          	addi	a5,a0,216
    800045a8:	4501                	li	a0,0
    800045aa:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045ac:	6398                	ld	a4,0(a5)
    800045ae:	cb19                	beqz	a4,800045c4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b0:	2505                	addiw	a0,a0,1
    800045b2:	07a1                	addi	a5,a5,8
    800045b4:	fed51ce3          	bne	a0,a3,800045ac <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045b8:	557d                	li	a0,-1
}
    800045ba:	60e2                	ld	ra,24(sp)
    800045bc:	6442                	ld	s0,16(sp)
    800045be:	64a2                	ld	s1,8(sp)
    800045c0:	6105                	addi	sp,sp,32
    800045c2:	8082                	ret
      p->ofile[fd] = f;
    800045c4:	01a50793          	addi	a5,a0,26
    800045c8:	078e                	slli	a5,a5,0x3
    800045ca:	963e                	add	a2,a2,a5
    800045cc:	e604                	sd	s1,8(a2)
      return fd;
    800045ce:	b7f5                	j	800045ba <fdalloc+0x2c>

00000000800045d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d0:	715d                	addi	sp,sp,-80
    800045d2:	e486                	sd	ra,72(sp)
    800045d4:	e0a2                	sd	s0,64(sp)
    800045d6:	fc26                	sd	s1,56(sp)
    800045d8:	f84a                	sd	s2,48(sp)
    800045da:	f44e                	sd	s3,40(sp)
    800045dc:	f052                	sd	s4,32(sp)
    800045de:	ec56                	sd	s5,24(sp)
    800045e0:	e85a                	sd	s6,16(sp)
    800045e2:	0880                	addi	s0,sp,80
    800045e4:	8b2e                	mv	s6,a1
    800045e6:	89b2                	mv	s3,a2
    800045e8:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	e26080e7          	jalr	-474(ra) # 80003414 <nameiparent>
    800045f6:	84aa                	mv	s1,a0
    800045f8:	14050f63          	beqz	a0,80004756 <create+0x186>
    return 0;

  ilock(dp);
    800045fc:	ffffe097          	auipc	ra,0xffffe
    80004600:	64e080e7          	jalr	1614(ra) # 80002c4a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004604:	4601                	li	a2,0
    80004606:	fb040593          	addi	a1,s0,-80
    8000460a:	8526                	mv	a0,s1
    8000460c:	fffff097          	auipc	ra,0xfffff
    80004610:	b22080e7          	jalr	-1246(ra) # 8000312e <dirlookup>
    80004614:	8aaa                	mv	s5,a0
    80004616:	c931                	beqz	a0,8000466a <create+0x9a>
    iunlockput(dp);
    80004618:	8526                	mv	a0,s1
    8000461a:	fffff097          	auipc	ra,0xfffff
    8000461e:	892080e7          	jalr	-1902(ra) # 80002eac <iunlockput>
    ilock(ip);
    80004622:	8556                	mv	a0,s5
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	626080e7          	jalr	1574(ra) # 80002c4a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000462c:	000b059b          	sext.w	a1,s6
    80004630:	4789                	li	a5,2
    80004632:	02f59563          	bne	a1,a5,8000465c <create+0x8c>
    80004636:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd064>
    8000463a:	37f9                	addiw	a5,a5,-2
    8000463c:	17c2                	slli	a5,a5,0x30
    8000463e:	93c1                	srli	a5,a5,0x30
    80004640:	4705                	li	a4,1
    80004642:	00f76d63          	bltu	a4,a5,8000465c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004646:	8556                	mv	a0,s5
    80004648:	60a6                	ld	ra,72(sp)
    8000464a:	6406                	ld	s0,64(sp)
    8000464c:	74e2                	ld	s1,56(sp)
    8000464e:	7942                	ld	s2,48(sp)
    80004650:	79a2                	ld	s3,40(sp)
    80004652:	7a02                	ld	s4,32(sp)
    80004654:	6ae2                	ld	s5,24(sp)
    80004656:	6b42                	ld	s6,16(sp)
    80004658:	6161                	addi	sp,sp,80
    8000465a:	8082                	ret
    iunlockput(ip);
    8000465c:	8556                	mv	a0,s5
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	84e080e7          	jalr	-1970(ra) # 80002eac <iunlockput>
    return 0;
    80004666:	4a81                	li	s5,0
    80004668:	bff9                	j	80004646 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000466a:	85da                	mv	a1,s6
    8000466c:	4088                	lw	a0,0(s1)
    8000466e:	ffffe097          	auipc	ra,0xffffe
    80004672:	43e080e7          	jalr	1086(ra) # 80002aac <ialloc>
    80004676:	8a2a                	mv	s4,a0
    80004678:	c539                	beqz	a0,800046c6 <create+0xf6>
  ilock(ip);
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	5d0080e7          	jalr	1488(ra) # 80002c4a <ilock>
  ip->major = major;
    80004682:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004686:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000468a:	4905                	li	s2,1
    8000468c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004690:	8552                	mv	a0,s4
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	4ec080e7          	jalr	1260(ra) # 80002b7e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000469a:	000b059b          	sext.w	a1,s6
    8000469e:	03258b63          	beq	a1,s2,800046d4 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a2:	004a2603          	lw	a2,4(s4)
    800046a6:	fb040593          	addi	a1,s0,-80
    800046aa:	8526                	mv	a0,s1
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	c98080e7          	jalr	-872(ra) # 80003344 <dirlink>
    800046b4:	06054f63          	bltz	a0,80004732 <create+0x162>
  iunlockput(dp);
    800046b8:	8526                	mv	a0,s1
    800046ba:	ffffe097          	auipc	ra,0xffffe
    800046be:	7f2080e7          	jalr	2034(ra) # 80002eac <iunlockput>
  return ip;
    800046c2:	8ad2                	mv	s5,s4
    800046c4:	b749                	j	80004646 <create+0x76>
    iunlockput(dp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	7e4080e7          	jalr	2020(ra) # 80002eac <iunlockput>
    return 0;
    800046d0:	8ad2                	mv	s5,s4
    800046d2:	bf95                	j	80004646 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046d4:	004a2603          	lw	a2,4(s4)
    800046d8:	00004597          	auipc	a1,0x4
    800046dc:	01058593          	addi	a1,a1,16 # 800086e8 <syscalls+0x2e8>
    800046e0:	8552                	mv	a0,s4
    800046e2:	fffff097          	auipc	ra,0xfffff
    800046e6:	c62080e7          	jalr	-926(ra) # 80003344 <dirlink>
    800046ea:	04054463          	bltz	a0,80004732 <create+0x162>
    800046ee:	40d0                	lw	a2,4(s1)
    800046f0:	00004597          	auipc	a1,0x4
    800046f4:	00058593          	mv	a1,a1
    800046f8:	8552                	mv	a0,s4
    800046fa:	fffff097          	auipc	ra,0xfffff
    800046fe:	c4a080e7          	jalr	-950(ra) # 80003344 <dirlink>
    80004702:	02054863          	bltz	a0,80004732 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004706:	004a2603          	lw	a2,4(s4)
    8000470a:	fb040593          	addi	a1,s0,-80
    8000470e:	8526                	mv	a0,s1
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	c34080e7          	jalr	-972(ra) # 80003344 <dirlink>
    80004718:	00054d63          	bltz	a0,80004732 <create+0x162>
    dp->nlink++;  // for ".."
    8000471c:	04a4d783          	lhu	a5,74(s1)
    80004720:	2785                	addiw	a5,a5,1
    80004722:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004726:	8526                	mv	a0,s1
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	456080e7          	jalr	1110(ra) # 80002b7e <iupdate>
    80004730:	b761                	j	800046b8 <create+0xe8>
  ip->nlink = 0;
    80004732:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004736:	8552                	mv	a0,s4
    80004738:	ffffe097          	auipc	ra,0xffffe
    8000473c:	446080e7          	jalr	1094(ra) # 80002b7e <iupdate>
  iunlockput(ip);
    80004740:	8552                	mv	a0,s4
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	76a080e7          	jalr	1898(ra) # 80002eac <iunlockput>
  iunlockput(dp);
    8000474a:	8526                	mv	a0,s1
    8000474c:	ffffe097          	auipc	ra,0xffffe
    80004750:	760080e7          	jalr	1888(ra) # 80002eac <iunlockput>
  return 0;
    80004754:	bdcd                	j	80004646 <create+0x76>
    return 0;
    80004756:	8aaa                	mv	s5,a0
    80004758:	b5fd                	j	80004646 <create+0x76>

000000008000475a <sys_dup>:
{
    8000475a:	7179                	addi	sp,sp,-48
    8000475c:	f406                	sd	ra,40(sp)
    8000475e:	f022                	sd	s0,32(sp)
    80004760:	ec26                	sd	s1,24(sp)
    80004762:	e84a                	sd	s2,16(sp)
    80004764:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004766:	fd840613          	addi	a2,s0,-40
    8000476a:	4581                	li	a1,0
    8000476c:	4501                	li	a0,0
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	dc0080e7          	jalr	-576(ra) # 8000452e <argfd>
    return -1;
    80004776:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004778:	02054363          	bltz	a0,8000479e <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000477c:	fd843903          	ld	s2,-40(s0)
    80004780:	854a                	mv	a0,s2
    80004782:	00000097          	auipc	ra,0x0
    80004786:	e0c080e7          	jalr	-500(ra) # 8000458e <fdalloc>
    8000478a:	84aa                	mv	s1,a0
    return -1;
    8000478c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000478e:	00054863          	bltz	a0,8000479e <sys_dup+0x44>
  filedup(f);
    80004792:	854a                	mv	a0,s2
    80004794:	fffff097          	auipc	ra,0xfffff
    80004798:	2f8080e7          	jalr	760(ra) # 80003a8c <filedup>
  return fd;
    8000479c:	87a6                	mv	a5,s1
}
    8000479e:	853e                	mv	a0,a5
    800047a0:	70a2                	ld	ra,40(sp)
    800047a2:	7402                	ld	s0,32(sp)
    800047a4:	64e2                	ld	s1,24(sp)
    800047a6:	6942                	ld	s2,16(sp)
    800047a8:	6145                	addi	sp,sp,48
    800047aa:	8082                	ret

00000000800047ac <sys_read>:
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047b4:	fd840593          	addi	a1,s0,-40
    800047b8:	4505                	li	a0,1
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	938080e7          	jalr	-1736(ra) # 800020f2 <argaddr>
  argint(2, &n);
    800047c2:	fe440593          	addi	a1,s0,-28
    800047c6:	4509                	li	a0,2
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	90a080e7          	jalr	-1782(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    800047d0:	fe840613          	addi	a2,s0,-24
    800047d4:	4581                	li	a1,0
    800047d6:	4501                	li	a0,0
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	d56080e7          	jalr	-682(ra) # 8000452e <argfd>
    800047e0:	87aa                	mv	a5,a0
    return -1;
    800047e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047e4:	0007cc63          	bltz	a5,800047fc <sys_read+0x50>
  return fileread(f, p, n);
    800047e8:	fe442603          	lw	a2,-28(s0)
    800047ec:	fd843583          	ld	a1,-40(s0)
    800047f0:	fe843503          	ld	a0,-24(s0)
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	424080e7          	jalr	1060(ra) # 80003c18 <fileread>
}
    800047fc:	70a2                	ld	ra,40(sp)
    800047fe:	7402                	ld	s0,32(sp)
    80004800:	6145                	addi	sp,sp,48
    80004802:	8082                	ret

0000000080004804 <sys_write>:
{
    80004804:	7179                	addi	sp,sp,-48
    80004806:	f406                	sd	ra,40(sp)
    80004808:	f022                	sd	s0,32(sp)
    8000480a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000480c:	fd840593          	addi	a1,s0,-40
    80004810:	4505                	li	a0,1
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	8e0080e7          	jalr	-1824(ra) # 800020f2 <argaddr>
  argint(2, &n);
    8000481a:	fe440593          	addi	a1,s0,-28
    8000481e:	4509                	li	a0,2
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	8b2080e7          	jalr	-1870(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004828:	fe840613          	addi	a2,s0,-24
    8000482c:	4581                	li	a1,0
    8000482e:	4501                	li	a0,0
    80004830:	00000097          	auipc	ra,0x0
    80004834:	cfe080e7          	jalr	-770(ra) # 8000452e <argfd>
    80004838:	87aa                	mv	a5,a0
    return -1;
    8000483a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000483c:	0007cc63          	bltz	a5,80004854 <sys_write+0x50>
  return filewrite(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	48e080e7          	jalr	1166(ra) # 80003cda <filewrite>
}
    80004854:	70a2                	ld	ra,40(sp)
    80004856:	7402                	ld	s0,32(sp)
    80004858:	6145                	addi	sp,sp,48
    8000485a:	8082                	ret

000000008000485c <sys_close>:
{
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004864:	fe040613          	addi	a2,s0,-32
    80004868:	fec40593          	addi	a1,s0,-20
    8000486c:	4501                	li	a0,0
    8000486e:	00000097          	auipc	ra,0x0
    80004872:	cc0080e7          	jalr	-832(ra) # 8000452e <argfd>
    return -1;
    80004876:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004878:	02054463          	bltz	a0,800048a0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	6c2080e7          	jalr	1730(ra) # 80000f3e <myproc>
    80004884:	fec42783          	lw	a5,-20(s0)
    80004888:	07e9                	addi	a5,a5,26
    8000488a:	078e                	slli	a5,a5,0x3
    8000488c:	953e                	add	a0,a0,a5
    8000488e:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004892:	fe043503          	ld	a0,-32(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	248080e7          	jalr	584(ra) # 80003ade <fileclose>
  return 0;
    8000489e:	4781                	li	a5,0
}
    800048a0:	853e                	mv	a0,a5
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_fstat>:
{
    800048aa:	1101                	addi	sp,sp,-32
    800048ac:	ec06                	sd	ra,24(sp)
    800048ae:	e822                	sd	s0,16(sp)
    800048b0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048b2:	fe040593          	addi	a1,s0,-32
    800048b6:	4505                	li	a0,1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	83a080e7          	jalr	-1990(ra) # 800020f2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048c0:	fe840613          	addi	a2,s0,-24
    800048c4:	4581                	li	a1,0
    800048c6:	4501                	li	a0,0
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	c66080e7          	jalr	-922(ra) # 8000452e <argfd>
    800048d0:	87aa                	mv	a5,a0
    return -1;
    800048d2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048d4:	0007ca63          	bltz	a5,800048e8 <sys_fstat+0x3e>
  return filestat(f, st);
    800048d8:	fe043583          	ld	a1,-32(s0)
    800048dc:	fe843503          	ld	a0,-24(s0)
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	2c6080e7          	jalr	710(ra) # 80003ba6 <filestat>
}
    800048e8:	60e2                	ld	ra,24(sp)
    800048ea:	6442                	ld	s0,16(sp)
    800048ec:	6105                	addi	sp,sp,32
    800048ee:	8082                	ret

00000000800048f0 <sys_link>:
{
    800048f0:	7169                	addi	sp,sp,-304
    800048f2:	f606                	sd	ra,296(sp)
    800048f4:	f222                	sd	s0,288(sp)
    800048f6:	ee26                	sd	s1,280(sp)
    800048f8:	ea4a                	sd	s2,272(sp)
    800048fa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fc:	08000613          	li	a2,128
    80004900:	ed040593          	addi	a1,s0,-304
    80004904:	4501                	li	a0,0
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	80c080e7          	jalr	-2036(ra) # 80002112 <argstr>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004910:	10054e63          	bltz	a0,80004a2c <sys_link+0x13c>
    80004914:	08000613          	li	a2,128
    80004918:	f5040593          	addi	a1,s0,-176
    8000491c:	4505                	li	a0,1
    8000491e:	ffffd097          	auipc	ra,0xffffd
    80004922:	7f4080e7          	jalr	2036(ra) # 80002112 <argstr>
    return -1;
    80004926:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004928:	10054263          	bltz	a0,80004a2c <sys_link+0x13c>
  begin_op();
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	cea080e7          	jalr	-790(ra) # 80003616 <begin_op>
  if((ip = namei(old)) == 0){
    80004934:	ed040513          	addi	a0,s0,-304
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	abe080e7          	jalr	-1346(ra) # 800033f6 <namei>
    80004940:	84aa                	mv	s1,a0
    80004942:	c551                	beqz	a0,800049ce <sys_link+0xde>
  ilock(ip);
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	306080e7          	jalr	774(ra) # 80002c4a <ilock>
  if(ip->type == T_DIR){
    8000494c:	04449703          	lh	a4,68(s1)
    80004950:	4785                	li	a5,1
    80004952:	08f70463          	beq	a4,a5,800049da <sys_link+0xea>
  ip->nlink++;
    80004956:	04a4d783          	lhu	a5,74(s1)
    8000495a:	2785                	addiw	a5,a5,1
    8000495c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	21c080e7          	jalr	540(ra) # 80002b7e <iupdate>
  iunlock(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	3a0080e7          	jalr	928(ra) # 80002d0c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004974:	fd040593          	addi	a1,s0,-48
    80004978:	f5040513          	addi	a0,s0,-176
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	a98080e7          	jalr	-1384(ra) # 80003414 <nameiparent>
    80004984:	892a                	mv	s2,a0
    80004986:	c935                	beqz	a0,800049fa <sys_link+0x10a>
  ilock(dp);
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	2c2080e7          	jalr	706(ra) # 80002c4a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004990:	00092703          	lw	a4,0(s2)
    80004994:	409c                	lw	a5,0(s1)
    80004996:	04f71d63          	bne	a4,a5,800049f0 <sys_link+0x100>
    8000499a:	40d0                	lw	a2,4(s1)
    8000499c:	fd040593          	addi	a1,s0,-48
    800049a0:	854a                	mv	a0,s2
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	9a2080e7          	jalr	-1630(ra) # 80003344 <dirlink>
    800049aa:	04054363          	bltz	a0,800049f0 <sys_link+0x100>
  iunlockput(dp);
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	4fc080e7          	jalr	1276(ra) # 80002eac <iunlockput>
  iput(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	44a080e7          	jalr	1098(ra) # 80002e04 <iput>
  end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	cd2080e7          	jalr	-814(ra) # 80003694 <end_op>
  return 0;
    800049ca:	4781                	li	a5,0
    800049cc:	a085                	j	80004a2c <sys_link+0x13c>
    end_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	cc6080e7          	jalr	-826(ra) # 80003694 <end_op>
    return -1;
    800049d6:	57fd                	li	a5,-1
    800049d8:	a891                	j	80004a2c <sys_link+0x13c>
    iunlockput(ip);
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	4d0080e7          	jalr	1232(ra) # 80002eac <iunlockput>
    end_op();
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	cb0080e7          	jalr	-848(ra) # 80003694 <end_op>
    return -1;
    800049ec:	57fd                	li	a5,-1
    800049ee:	a83d                	j	80004a2c <sys_link+0x13c>
    iunlockput(dp);
    800049f0:	854a                	mv	a0,s2
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	4ba080e7          	jalr	1210(ra) # 80002eac <iunlockput>
  ilock(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	24e080e7          	jalr	590(ra) # 80002c4a <ilock>
  ip->nlink--;
    80004a04:	04a4d783          	lhu	a5,74(s1)
    80004a08:	37fd                	addiw	a5,a5,-1
    80004a0a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	16e080e7          	jalr	366(ra) # 80002b7e <iupdate>
  iunlockput(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	492080e7          	jalr	1170(ra) # 80002eac <iunlockput>
  end_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	c72080e7          	jalr	-910(ra) # 80003694 <end_op>
  return -1;
    80004a2a:	57fd                	li	a5,-1
}
    80004a2c:	853e                	mv	a0,a5
    80004a2e:	70b2                	ld	ra,296(sp)
    80004a30:	7412                	ld	s0,288(sp)
    80004a32:	64f2                	ld	s1,280(sp)
    80004a34:	6952                	ld	s2,272(sp)
    80004a36:	6155                	addi	sp,sp,304
    80004a38:	8082                	ret

0000000080004a3a <sys_unlink>:
{
    80004a3a:	7151                	addi	sp,sp,-240
    80004a3c:	f586                	sd	ra,232(sp)
    80004a3e:	f1a2                	sd	s0,224(sp)
    80004a40:	eda6                	sd	s1,216(sp)
    80004a42:	e9ca                	sd	s2,208(sp)
    80004a44:	e5ce                	sd	s3,200(sp)
    80004a46:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a48:	08000613          	li	a2,128
    80004a4c:	f3040593          	addi	a1,s0,-208
    80004a50:	4501                	li	a0,0
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	6c0080e7          	jalr	1728(ra) # 80002112 <argstr>
    80004a5a:	18054163          	bltz	a0,80004bdc <sys_unlink+0x1a2>
  begin_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	bb8080e7          	jalr	-1096(ra) # 80003616 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a66:	fb040593          	addi	a1,s0,-80
    80004a6a:	f3040513          	addi	a0,s0,-208
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	9a6080e7          	jalr	-1626(ra) # 80003414 <nameiparent>
    80004a76:	84aa                	mv	s1,a0
    80004a78:	c979                	beqz	a0,80004b4e <sys_unlink+0x114>
  ilock(dp);
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	1d0080e7          	jalr	464(ra) # 80002c4a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a82:	00004597          	auipc	a1,0x4
    80004a86:	c6658593          	addi	a1,a1,-922 # 800086e8 <syscalls+0x2e8>
    80004a8a:	fb040513          	addi	a0,s0,-80
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	686080e7          	jalr	1670(ra) # 80003114 <namecmp>
    80004a96:	14050a63          	beqz	a0,80004bea <sys_unlink+0x1b0>
    80004a9a:	00004597          	auipc	a1,0x4
    80004a9e:	c5658593          	addi	a1,a1,-938 # 800086f0 <syscalls+0x2f0>
    80004aa2:	fb040513          	addi	a0,s0,-80
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	66e080e7          	jalr	1646(ra) # 80003114 <namecmp>
    80004aae:	12050e63          	beqz	a0,80004bea <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ab2:	f2c40613          	addi	a2,s0,-212
    80004ab6:	fb040593          	addi	a1,s0,-80
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	672080e7          	jalr	1650(ra) # 8000312e <dirlookup>
    80004ac4:	892a                	mv	s2,a0
    80004ac6:	12050263          	beqz	a0,80004bea <sys_unlink+0x1b0>
  ilock(ip);
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	180080e7          	jalr	384(ra) # 80002c4a <ilock>
  if(ip->nlink < 1)
    80004ad2:	04a91783          	lh	a5,74(s2)
    80004ad6:	08f05263          	blez	a5,80004b5a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ada:	04491703          	lh	a4,68(s2)
    80004ade:	4785                	li	a5,1
    80004ae0:	08f70563          	beq	a4,a5,80004b6a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ae4:	4641                	li	a2,16
    80004ae6:	4581                	li	a1,0
    80004ae8:	fc040513          	addi	a0,s0,-64
    80004aec:	ffffb097          	auipc	ra,0xffffb
    80004af0:	68e080e7          	jalr	1678(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af4:	4741                	li	a4,16
    80004af6:	f2c42683          	lw	a3,-212(s0)
    80004afa:	fc040613          	addi	a2,s0,-64
    80004afe:	4581                	li	a1,0
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	4f4080e7          	jalr	1268(ra) # 80002ff6 <writei>
    80004b0a:	47c1                	li	a5,16
    80004b0c:	0af51563          	bne	a0,a5,80004bb6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b10:	04491703          	lh	a4,68(s2)
    80004b14:	4785                	li	a5,1
    80004b16:	0af70863          	beq	a4,a5,80004bc6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	390080e7          	jalr	912(ra) # 80002eac <iunlockput>
  ip->nlink--;
    80004b24:	04a95783          	lhu	a5,74(s2)
    80004b28:	37fd                	addiw	a5,a5,-1
    80004b2a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	04e080e7          	jalr	78(ra) # 80002b7e <iupdate>
  iunlockput(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	372080e7          	jalr	882(ra) # 80002eac <iunlockput>
  end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	b52080e7          	jalr	-1198(ra) # 80003694 <end_op>
  return 0;
    80004b4a:	4501                	li	a0,0
    80004b4c:	a84d                	j	80004bfe <sys_unlink+0x1c4>
    end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	b46080e7          	jalr	-1210(ra) # 80003694 <end_op>
    return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	a05d                	j	80004bfe <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b5a:	00004517          	auipc	a0,0x4
    80004b5e:	b9e50513          	addi	a0,a0,-1122 # 800086f8 <syscalls+0x2f8>
    80004b62:	00001097          	auipc	ra,0x1
    80004b66:	1ba080e7          	jalr	442(ra) # 80005d1c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b6a:	04c92703          	lw	a4,76(s2)
    80004b6e:	02000793          	li	a5,32
    80004b72:	f6e7f9e3          	bgeu	a5,a4,80004ae4 <sys_unlink+0xaa>
    80004b76:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	86ce                	mv	a3,s3
    80004b7e:	f1840613          	addi	a2,s0,-232
    80004b82:	4581                	li	a1,0
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	378080e7          	jalr	888(ra) # 80002efe <readi>
    80004b8e:	47c1                	li	a5,16
    80004b90:	00f51b63          	bne	a0,a5,80004ba6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b94:	f1845783          	lhu	a5,-232(s0)
    80004b98:	e7a1                	bnez	a5,80004be0 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9a:	29c1                	addiw	s3,s3,16
    80004b9c:	04c92783          	lw	a5,76(s2)
    80004ba0:	fcf9ede3          	bltu	s3,a5,80004b7a <sys_unlink+0x140>
    80004ba4:	b781                	j	80004ae4 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ba6:	00004517          	auipc	a0,0x4
    80004baa:	b6a50513          	addi	a0,a0,-1174 # 80008710 <syscalls+0x310>
    80004bae:	00001097          	auipc	ra,0x1
    80004bb2:	16e080e7          	jalr	366(ra) # 80005d1c <panic>
    panic("unlink: writei");
    80004bb6:	00004517          	auipc	a0,0x4
    80004bba:	b7250513          	addi	a0,a0,-1166 # 80008728 <syscalls+0x328>
    80004bbe:	00001097          	auipc	ra,0x1
    80004bc2:	15e080e7          	jalr	350(ra) # 80005d1c <panic>
    dp->nlink--;
    80004bc6:	04a4d783          	lhu	a5,74(s1)
    80004bca:	37fd                	addiw	a5,a5,-1
    80004bcc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	fac080e7          	jalr	-84(ra) # 80002b7e <iupdate>
    80004bda:	b781                	j	80004b1a <sys_unlink+0xe0>
    return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a005                	j	80004bfe <sys_unlink+0x1c4>
    iunlockput(ip);
    80004be0:	854a                	mv	a0,s2
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	2ca080e7          	jalr	714(ra) # 80002eac <iunlockput>
  iunlockput(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	2c0080e7          	jalr	704(ra) # 80002eac <iunlockput>
  end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	aa0080e7          	jalr	-1376(ra) # 80003694 <end_op>
  return -1;
    80004bfc:	557d                	li	a0,-1
}
    80004bfe:	70ae                	ld	ra,232(sp)
    80004c00:	740e                	ld	s0,224(sp)
    80004c02:	64ee                	ld	s1,216(sp)
    80004c04:	694e                	ld	s2,208(sp)
    80004c06:	69ae                	ld	s3,200(sp)
    80004c08:	616d                	addi	sp,sp,240
    80004c0a:	8082                	ret

0000000080004c0c <sys_open>:

uint64
sys_open(void)
{
    80004c0c:	7131                	addi	sp,sp,-192
    80004c0e:	fd06                	sd	ra,184(sp)
    80004c10:	f922                	sd	s0,176(sp)
    80004c12:	f526                	sd	s1,168(sp)
    80004c14:	f14a                	sd	s2,160(sp)
    80004c16:	ed4e                	sd	s3,152(sp)
    80004c18:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c1a:	f4c40593          	addi	a1,s0,-180
    80004c1e:	4505                	li	a0,1
    80004c20:	ffffd097          	auipc	ra,0xffffd
    80004c24:	4b2080e7          	jalr	1202(ra) # 800020d2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c28:	08000613          	li	a2,128
    80004c2c:	f5040593          	addi	a1,s0,-176
    80004c30:	4501                	li	a0,0
    80004c32:	ffffd097          	auipc	ra,0xffffd
    80004c36:	4e0080e7          	jalr	1248(ra) # 80002112 <argstr>
    80004c3a:	87aa                	mv	a5,a0
    return -1;
    80004c3c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c3e:	0a07c963          	bltz	a5,80004cf0 <sys_open+0xe4>

  begin_op();
    80004c42:	fffff097          	auipc	ra,0xfffff
    80004c46:	9d4080e7          	jalr	-1580(ra) # 80003616 <begin_op>

  if(omode & O_CREATE){
    80004c4a:	f4c42783          	lw	a5,-180(s0)
    80004c4e:	2007f793          	andi	a5,a5,512
    80004c52:	cfc5                	beqz	a5,80004d0a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c54:	4681                	li	a3,0
    80004c56:	4601                	li	a2,0
    80004c58:	4589                	li	a1,2
    80004c5a:	f5040513          	addi	a0,s0,-176
    80004c5e:	00000097          	auipc	ra,0x0
    80004c62:	972080e7          	jalr	-1678(ra) # 800045d0 <create>
    80004c66:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c68:	c959                	beqz	a0,80004cfe <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c6a:	04449703          	lh	a4,68(s1)
    80004c6e:	478d                	li	a5,3
    80004c70:	00f71763          	bne	a4,a5,80004c7e <sys_open+0x72>
    80004c74:	0464d703          	lhu	a4,70(s1)
    80004c78:	47a5                	li	a5,9
    80004c7a:	0ce7ed63          	bltu	a5,a4,80004d54 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	da4080e7          	jalr	-604(ra) # 80003a22 <filealloc>
    80004c86:	89aa                	mv	s3,a0
    80004c88:	10050363          	beqz	a0,80004d8e <sys_open+0x182>
    80004c8c:	00000097          	auipc	ra,0x0
    80004c90:	902080e7          	jalr	-1790(ra) # 8000458e <fdalloc>
    80004c94:	892a                	mv	s2,a0
    80004c96:	0e054763          	bltz	a0,80004d84 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c9a:	04449703          	lh	a4,68(s1)
    80004c9e:	478d                	li	a5,3
    80004ca0:	0cf70563          	beq	a4,a5,80004d6a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca4:	4789                	li	a5,2
    80004ca6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004caa:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cae:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cb2:	f4c42783          	lw	a5,-180(s0)
    80004cb6:	0017c713          	xori	a4,a5,1
    80004cba:	8b05                	andi	a4,a4,1
    80004cbc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc0:	0037f713          	andi	a4,a5,3
    80004cc4:	00e03733          	snez	a4,a4
    80004cc8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ccc:	4007f793          	andi	a5,a5,1024
    80004cd0:	c791                	beqz	a5,80004cdc <sys_open+0xd0>
    80004cd2:	04449703          	lh	a4,68(s1)
    80004cd6:	4789                	li	a5,2
    80004cd8:	0af70063          	beq	a4,a5,80004d78 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	02e080e7          	jalr	46(ra) # 80002d0c <iunlock>
  end_op();
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	9ae080e7          	jalr	-1618(ra) # 80003694 <end_op>

  return fd;
    80004cee:	854a                	mv	a0,s2
}
    80004cf0:	70ea                	ld	ra,184(sp)
    80004cf2:	744a                	ld	s0,176(sp)
    80004cf4:	74aa                	ld	s1,168(sp)
    80004cf6:	790a                	ld	s2,160(sp)
    80004cf8:	69ea                	ld	s3,152(sp)
    80004cfa:	6129                	addi	sp,sp,192
    80004cfc:	8082                	ret
      end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	996080e7          	jalr	-1642(ra) # 80003694 <end_op>
      return -1;
    80004d06:	557d                	li	a0,-1
    80004d08:	b7e5                	j	80004cf0 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d0a:	f5040513          	addi	a0,s0,-176
    80004d0e:	ffffe097          	auipc	ra,0xffffe
    80004d12:	6e8080e7          	jalr	1768(ra) # 800033f6 <namei>
    80004d16:	84aa                	mv	s1,a0
    80004d18:	c905                	beqz	a0,80004d48 <sys_open+0x13c>
    ilock(ip);
    80004d1a:	ffffe097          	auipc	ra,0xffffe
    80004d1e:	f30080e7          	jalr	-208(ra) # 80002c4a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d22:	04449703          	lh	a4,68(s1)
    80004d26:	4785                	li	a5,1
    80004d28:	f4f711e3          	bne	a4,a5,80004c6a <sys_open+0x5e>
    80004d2c:	f4c42783          	lw	a5,-180(s0)
    80004d30:	d7b9                	beqz	a5,80004c7e <sys_open+0x72>
      iunlockput(ip);
    80004d32:	8526                	mv	a0,s1
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	178080e7          	jalr	376(ra) # 80002eac <iunlockput>
      end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	958080e7          	jalr	-1704(ra) # 80003694 <end_op>
      return -1;
    80004d44:	557d                	li	a0,-1
    80004d46:	b76d                	j	80004cf0 <sys_open+0xe4>
      end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	94c080e7          	jalr	-1716(ra) # 80003694 <end_op>
      return -1;
    80004d50:	557d                	li	a0,-1
    80004d52:	bf79                	j	80004cf0 <sys_open+0xe4>
    iunlockput(ip);
    80004d54:	8526                	mv	a0,s1
    80004d56:	ffffe097          	auipc	ra,0xffffe
    80004d5a:	156080e7          	jalr	342(ra) # 80002eac <iunlockput>
    end_op();
    80004d5e:	fffff097          	auipc	ra,0xfffff
    80004d62:	936080e7          	jalr	-1738(ra) # 80003694 <end_op>
    return -1;
    80004d66:	557d                	li	a0,-1
    80004d68:	b761                	j	80004cf0 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d6a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d6e:	04649783          	lh	a5,70(s1)
    80004d72:	02f99223          	sh	a5,36(s3)
    80004d76:	bf25                	j	80004cae <sys_open+0xa2>
    itrunc(ip);
    80004d78:	8526                	mv	a0,s1
    80004d7a:	ffffe097          	auipc	ra,0xffffe
    80004d7e:	fde080e7          	jalr	-34(ra) # 80002d58 <itrunc>
    80004d82:	bfa9                	j	80004cdc <sys_open+0xd0>
      fileclose(f);
    80004d84:	854e                	mv	a0,s3
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	d58080e7          	jalr	-680(ra) # 80003ade <fileclose>
    iunlockput(ip);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	11c080e7          	jalr	284(ra) # 80002eac <iunlockput>
    end_op();
    80004d98:	fffff097          	auipc	ra,0xfffff
    80004d9c:	8fc080e7          	jalr	-1796(ra) # 80003694 <end_op>
    return -1;
    80004da0:	557d                	li	a0,-1
    80004da2:	b7b9                	j	80004cf0 <sys_open+0xe4>

0000000080004da4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004da4:	7175                	addi	sp,sp,-144
    80004da6:	e506                	sd	ra,136(sp)
    80004da8:	e122                	sd	s0,128(sp)
    80004daa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	86a080e7          	jalr	-1942(ra) # 80003616 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004db4:	08000613          	li	a2,128
    80004db8:	f7040593          	addi	a1,s0,-144
    80004dbc:	4501                	li	a0,0
    80004dbe:	ffffd097          	auipc	ra,0xffffd
    80004dc2:	354080e7          	jalr	852(ra) # 80002112 <argstr>
    80004dc6:	02054963          	bltz	a0,80004df8 <sys_mkdir+0x54>
    80004dca:	4681                	li	a3,0
    80004dcc:	4601                	li	a2,0
    80004dce:	4585                	li	a1,1
    80004dd0:	f7040513          	addi	a0,s0,-144
    80004dd4:	fffff097          	auipc	ra,0xfffff
    80004dd8:	7fc080e7          	jalr	2044(ra) # 800045d0 <create>
    80004ddc:	cd11                	beqz	a0,80004df8 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dde:	ffffe097          	auipc	ra,0xffffe
    80004de2:	0ce080e7          	jalr	206(ra) # 80002eac <iunlockput>
  end_op();
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	8ae080e7          	jalr	-1874(ra) # 80003694 <end_op>
  return 0;
    80004dee:	4501                	li	a0,0
}
    80004df0:	60aa                	ld	ra,136(sp)
    80004df2:	640a                	ld	s0,128(sp)
    80004df4:	6149                	addi	sp,sp,144
    80004df6:	8082                	ret
    end_op();
    80004df8:	fffff097          	auipc	ra,0xfffff
    80004dfc:	89c080e7          	jalr	-1892(ra) # 80003694 <end_op>
    return -1;
    80004e00:	557d                	li	a0,-1
    80004e02:	b7fd                	j	80004df0 <sys_mkdir+0x4c>

0000000080004e04 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e04:	7135                	addi	sp,sp,-160
    80004e06:	ed06                	sd	ra,152(sp)
    80004e08:	e922                	sd	s0,144(sp)
    80004e0a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e0c:	fffff097          	auipc	ra,0xfffff
    80004e10:	80a080e7          	jalr	-2038(ra) # 80003616 <begin_op>
  argint(1, &major);
    80004e14:	f6c40593          	addi	a1,s0,-148
    80004e18:	4505                	li	a0,1
    80004e1a:	ffffd097          	auipc	ra,0xffffd
    80004e1e:	2b8080e7          	jalr	696(ra) # 800020d2 <argint>
  argint(2, &minor);
    80004e22:	f6840593          	addi	a1,s0,-152
    80004e26:	4509                	li	a0,2
    80004e28:	ffffd097          	auipc	ra,0xffffd
    80004e2c:	2aa080e7          	jalr	682(ra) # 800020d2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e30:	08000613          	li	a2,128
    80004e34:	f7040593          	addi	a1,s0,-144
    80004e38:	4501                	li	a0,0
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	2d8080e7          	jalr	728(ra) # 80002112 <argstr>
    80004e42:	02054b63          	bltz	a0,80004e78 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e46:	f6841683          	lh	a3,-152(s0)
    80004e4a:	f6c41603          	lh	a2,-148(s0)
    80004e4e:	458d                	li	a1,3
    80004e50:	f7040513          	addi	a0,s0,-144
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	77c080e7          	jalr	1916(ra) # 800045d0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5c:	cd11                	beqz	a0,80004e78 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e5e:	ffffe097          	auipc	ra,0xffffe
    80004e62:	04e080e7          	jalr	78(ra) # 80002eac <iunlockput>
  end_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	82e080e7          	jalr	-2002(ra) # 80003694 <end_op>
  return 0;
    80004e6e:	4501                	li	a0,0
}
    80004e70:	60ea                	ld	ra,152(sp)
    80004e72:	644a                	ld	s0,144(sp)
    80004e74:	610d                	addi	sp,sp,160
    80004e76:	8082                	ret
    end_op();
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	81c080e7          	jalr	-2020(ra) # 80003694 <end_op>
    return -1;
    80004e80:	557d                	li	a0,-1
    80004e82:	b7fd                	j	80004e70 <sys_mknod+0x6c>

0000000080004e84 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e84:	7135                	addi	sp,sp,-160
    80004e86:	ed06                	sd	ra,152(sp)
    80004e88:	e922                	sd	s0,144(sp)
    80004e8a:	e526                	sd	s1,136(sp)
    80004e8c:	e14a                	sd	s2,128(sp)
    80004e8e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e90:	ffffc097          	auipc	ra,0xffffc
    80004e94:	0ae080e7          	jalr	174(ra) # 80000f3e <myproc>
    80004e98:	892a                	mv	s2,a0
  
  begin_op();
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	77c080e7          	jalr	1916(ra) # 80003616 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea2:	08000613          	li	a2,128
    80004ea6:	f6040593          	addi	a1,s0,-160
    80004eaa:	4501                	li	a0,0
    80004eac:	ffffd097          	auipc	ra,0xffffd
    80004eb0:	266080e7          	jalr	614(ra) # 80002112 <argstr>
    80004eb4:	04054b63          	bltz	a0,80004f0a <sys_chdir+0x86>
    80004eb8:	f6040513          	addi	a0,s0,-160
    80004ebc:	ffffe097          	auipc	ra,0xffffe
    80004ec0:	53a080e7          	jalr	1338(ra) # 800033f6 <namei>
    80004ec4:	84aa                	mv	s1,a0
    80004ec6:	c131                	beqz	a0,80004f0a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ec8:	ffffe097          	auipc	ra,0xffffe
    80004ecc:	d82080e7          	jalr	-638(ra) # 80002c4a <ilock>
  if(ip->type != T_DIR){
    80004ed0:	04449703          	lh	a4,68(s1)
    80004ed4:	4785                	li	a5,1
    80004ed6:	04f71063          	bne	a4,a5,80004f16 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004eda:	8526                	mv	a0,s1
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	e30080e7          	jalr	-464(ra) # 80002d0c <iunlock>
  iput(p->cwd);
    80004ee4:	15893503          	ld	a0,344(s2)
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	f1c080e7          	jalr	-228(ra) # 80002e04 <iput>
  end_op();
    80004ef0:	ffffe097          	auipc	ra,0xffffe
    80004ef4:	7a4080e7          	jalr	1956(ra) # 80003694 <end_op>
  p->cwd = ip;
    80004ef8:	14993c23          	sd	s1,344(s2)
  return 0;
    80004efc:	4501                	li	a0,0
}
    80004efe:	60ea                	ld	ra,152(sp)
    80004f00:	644a                	ld	s0,144(sp)
    80004f02:	64aa                	ld	s1,136(sp)
    80004f04:	690a                	ld	s2,128(sp)
    80004f06:	610d                	addi	sp,sp,160
    80004f08:	8082                	ret
    end_op();
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	78a080e7          	jalr	1930(ra) # 80003694 <end_op>
    return -1;
    80004f12:	557d                	li	a0,-1
    80004f14:	b7ed                	j	80004efe <sys_chdir+0x7a>
    iunlockput(ip);
    80004f16:	8526                	mv	a0,s1
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	f94080e7          	jalr	-108(ra) # 80002eac <iunlockput>
    end_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	774080e7          	jalr	1908(ra) # 80003694 <end_op>
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	bfd1                	j	80004efe <sys_chdir+0x7a>

0000000080004f2c <sys_exec>:

uint64
sys_exec(void)
{
    80004f2c:	7145                	addi	sp,sp,-464
    80004f2e:	e786                	sd	ra,456(sp)
    80004f30:	e3a2                	sd	s0,448(sp)
    80004f32:	ff26                	sd	s1,440(sp)
    80004f34:	fb4a                	sd	s2,432(sp)
    80004f36:	f74e                	sd	s3,424(sp)
    80004f38:	f352                	sd	s4,416(sp)
    80004f3a:	ef56                	sd	s5,408(sp)
    80004f3c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f3e:	e3840593          	addi	a1,s0,-456
    80004f42:	4505                	li	a0,1
    80004f44:	ffffd097          	auipc	ra,0xffffd
    80004f48:	1ae080e7          	jalr	430(ra) # 800020f2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f4c:	08000613          	li	a2,128
    80004f50:	f4040593          	addi	a1,s0,-192
    80004f54:	4501                	li	a0,0
    80004f56:	ffffd097          	auipc	ra,0xffffd
    80004f5a:	1bc080e7          	jalr	444(ra) # 80002112 <argstr>
    80004f5e:	87aa                	mv	a5,a0
    return -1;
    80004f60:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f62:	0c07c363          	bltz	a5,80005028 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f66:	10000613          	li	a2,256
    80004f6a:	4581                	li	a1,0
    80004f6c:	e4040513          	addi	a0,s0,-448
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	20a080e7          	jalr	522(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f78:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f7c:	89a6                	mv	s3,s1
    80004f7e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f80:	02000a13          	li	s4,32
    80004f84:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f88:	00391513          	slli	a0,s2,0x3
    80004f8c:	e3040593          	addi	a1,s0,-464
    80004f90:	e3843783          	ld	a5,-456(s0)
    80004f94:	953e                	add	a0,a0,a5
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	09e080e7          	jalr	158(ra) # 80002034 <fetchaddr>
    80004f9e:	02054a63          	bltz	a0,80004fd2 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004fa2:	e3043783          	ld	a5,-464(s0)
    80004fa6:	c3b9                	beqz	a5,80004fec <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fa8:	ffffb097          	auipc	ra,0xffffb
    80004fac:	172080e7          	jalr	370(ra) # 8000011a <kalloc>
    80004fb0:	85aa                	mv	a1,a0
    80004fb2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fb6:	cd11                	beqz	a0,80004fd2 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fb8:	6605                	lui	a2,0x1
    80004fba:	e3043503          	ld	a0,-464(s0)
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	0c8080e7          	jalr	200(ra) # 80002086 <fetchstr>
    80004fc6:	00054663          	bltz	a0,80004fd2 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fca:	0905                	addi	s2,s2,1
    80004fcc:	09a1                	addi	s3,s3,8
    80004fce:	fb491be3          	bne	s2,s4,80004f84 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd2:	f4040913          	addi	s2,s0,-192
    80004fd6:	6088                	ld	a0,0(s1)
    80004fd8:	c539                	beqz	a0,80005026 <sys_exec+0xfa>
    kfree(argv[i]);
    80004fda:	ffffb097          	auipc	ra,0xffffb
    80004fde:	042080e7          	jalr	66(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe2:	04a1                	addi	s1,s1,8
    80004fe4:	ff2499e3          	bne	s1,s2,80004fd6 <sys_exec+0xaa>
  return -1;
    80004fe8:	557d                	li	a0,-1
    80004fea:	a83d                	j	80005028 <sys_exec+0xfc>
      argv[i] = 0;
    80004fec:	0a8e                	slli	s5,s5,0x3
    80004fee:	fc0a8793          	addi	a5,s5,-64
    80004ff2:	00878ab3          	add	s5,a5,s0
    80004ff6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ffa:	e4040593          	addi	a1,s0,-448
    80004ffe:	f4040513          	addi	a0,s0,-192
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	156080e7          	jalr	342(ra) # 80004158 <exec>
    8000500a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000500c:	f4040993          	addi	s3,s0,-192
    80005010:	6088                	ld	a0,0(s1)
    80005012:	c901                	beqz	a0,80005022 <sys_exec+0xf6>
    kfree(argv[i]);
    80005014:	ffffb097          	auipc	ra,0xffffb
    80005018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501c:	04a1                	addi	s1,s1,8
    8000501e:	ff3499e3          	bne	s1,s3,80005010 <sys_exec+0xe4>
  return ret;
    80005022:	854a                	mv	a0,s2
    80005024:	a011                	j	80005028 <sys_exec+0xfc>
  return -1;
    80005026:	557d                	li	a0,-1
}
    80005028:	60be                	ld	ra,456(sp)
    8000502a:	641e                	ld	s0,448(sp)
    8000502c:	74fa                	ld	s1,440(sp)
    8000502e:	795a                	ld	s2,432(sp)
    80005030:	79ba                	ld	s3,424(sp)
    80005032:	7a1a                	ld	s4,416(sp)
    80005034:	6afa                	ld	s5,408(sp)
    80005036:	6179                	addi	sp,sp,464
    80005038:	8082                	ret

000000008000503a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000503a:	7139                	addi	sp,sp,-64
    8000503c:	fc06                	sd	ra,56(sp)
    8000503e:	f822                	sd	s0,48(sp)
    80005040:	f426                	sd	s1,40(sp)
    80005042:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005044:	ffffc097          	auipc	ra,0xffffc
    80005048:	efa080e7          	jalr	-262(ra) # 80000f3e <myproc>
    8000504c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000504e:	fd840593          	addi	a1,s0,-40
    80005052:	4501                	li	a0,0
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	09e080e7          	jalr	158(ra) # 800020f2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000505c:	fc840593          	addi	a1,s0,-56
    80005060:	fd040513          	addi	a0,s0,-48
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	daa080e7          	jalr	-598(ra) # 80003e0e <pipealloc>
    return -1;
    8000506c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000506e:	0c054463          	bltz	a0,80005136 <sys_pipe+0xfc>
  fd0 = -1;
    80005072:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005076:	fd043503          	ld	a0,-48(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	514080e7          	jalr	1300(ra) # 8000458e <fdalloc>
    80005082:	fca42223          	sw	a0,-60(s0)
    80005086:	08054b63          	bltz	a0,8000511c <sys_pipe+0xe2>
    8000508a:	fc843503          	ld	a0,-56(s0)
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	500080e7          	jalr	1280(ra) # 8000458e <fdalloc>
    80005096:	fca42023          	sw	a0,-64(s0)
    8000509a:	06054863          	bltz	a0,8000510a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000509e:	4691                	li	a3,4
    800050a0:	fc440613          	addi	a2,s0,-60
    800050a4:	fd843583          	ld	a1,-40(s0)
    800050a8:	6ca8                	ld	a0,88(s1)
    800050aa:	ffffc097          	auipc	ra,0xffffc
    800050ae:	a6a080e7          	jalr	-1430(ra) # 80000b14 <copyout>
    800050b2:	02054063          	bltz	a0,800050d2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050b6:	4691                	li	a3,4
    800050b8:	fc040613          	addi	a2,s0,-64
    800050bc:	fd843583          	ld	a1,-40(s0)
    800050c0:	0591                	addi	a1,a1,4
    800050c2:	6ca8                	ld	a0,88(s1)
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	a50080e7          	jalr	-1456(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050cc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ce:	06055463          	bgez	a0,80005136 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050d2:	fc442783          	lw	a5,-60(s0)
    800050d6:	07e9                	addi	a5,a5,26
    800050d8:	078e                	slli	a5,a5,0x3
    800050da:	97a6                	add	a5,a5,s1
    800050dc:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800050e0:	fc042783          	lw	a5,-64(s0)
    800050e4:	07e9                	addi	a5,a5,26
    800050e6:	078e                	slli	a5,a5,0x3
    800050e8:	94be                	add	s1,s1,a5
    800050ea:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800050ee:	fd043503          	ld	a0,-48(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	9ec080e7          	jalr	-1556(ra) # 80003ade <fileclose>
    fileclose(wf);
    800050fa:	fc843503          	ld	a0,-56(s0)
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	9e0080e7          	jalr	-1568(ra) # 80003ade <fileclose>
    return -1;
    80005106:	57fd                	li	a5,-1
    80005108:	a03d                	j	80005136 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000510a:	fc442783          	lw	a5,-60(s0)
    8000510e:	0007c763          	bltz	a5,8000511c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005112:	07e9                	addi	a5,a5,26
    80005114:	078e                	slli	a5,a5,0x3
    80005116:	97a6                	add	a5,a5,s1
    80005118:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000511c:	fd043503          	ld	a0,-48(s0)
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	9be080e7          	jalr	-1602(ra) # 80003ade <fileclose>
    fileclose(wf);
    80005128:	fc843503          	ld	a0,-56(s0)
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	9b2080e7          	jalr	-1614(ra) # 80003ade <fileclose>
    return -1;
    80005134:	57fd                	li	a5,-1
}
    80005136:	853e                	mv	a0,a5
    80005138:	70e2                	ld	ra,56(sp)
    8000513a:	7442                	ld	s0,48(sp)
    8000513c:	74a2                	ld	s1,40(sp)
    8000513e:	6121                	addi	sp,sp,64
    80005140:	8082                	ret
	...

0000000080005150 <kernelvec>:
    80005150:	7111                	addi	sp,sp,-256
    80005152:	e006                	sd	ra,0(sp)
    80005154:	e40a                	sd	sp,8(sp)
    80005156:	e80e                	sd	gp,16(sp)
    80005158:	ec12                	sd	tp,24(sp)
    8000515a:	f016                	sd	t0,32(sp)
    8000515c:	f41a                	sd	t1,40(sp)
    8000515e:	f81e                	sd	t2,48(sp)
    80005160:	fc22                	sd	s0,56(sp)
    80005162:	e0a6                	sd	s1,64(sp)
    80005164:	e4aa                	sd	a0,72(sp)
    80005166:	e8ae                	sd	a1,80(sp)
    80005168:	ecb2                	sd	a2,88(sp)
    8000516a:	f0b6                	sd	a3,96(sp)
    8000516c:	f4ba                	sd	a4,104(sp)
    8000516e:	f8be                	sd	a5,112(sp)
    80005170:	fcc2                	sd	a6,120(sp)
    80005172:	e146                	sd	a7,128(sp)
    80005174:	e54a                	sd	s2,136(sp)
    80005176:	e94e                	sd	s3,144(sp)
    80005178:	ed52                	sd	s4,152(sp)
    8000517a:	f156                	sd	s5,160(sp)
    8000517c:	f55a                	sd	s6,168(sp)
    8000517e:	f95e                	sd	s7,176(sp)
    80005180:	fd62                	sd	s8,184(sp)
    80005182:	e1e6                	sd	s9,192(sp)
    80005184:	e5ea                	sd	s10,200(sp)
    80005186:	e9ee                	sd	s11,208(sp)
    80005188:	edf2                	sd	t3,216(sp)
    8000518a:	f1f6                	sd	t4,224(sp)
    8000518c:	f5fa                	sd	t5,232(sp)
    8000518e:	f9fe                	sd	t6,240(sp)
    80005190:	d71fc0ef          	jal	ra,80001f00 <kerneltrap>
    80005194:	6082                	ld	ra,0(sp)
    80005196:	6122                	ld	sp,8(sp)
    80005198:	61c2                	ld	gp,16(sp)
    8000519a:	7282                	ld	t0,32(sp)
    8000519c:	7322                	ld	t1,40(sp)
    8000519e:	73c2                	ld	t2,48(sp)
    800051a0:	7462                	ld	s0,56(sp)
    800051a2:	6486                	ld	s1,64(sp)
    800051a4:	6526                	ld	a0,72(sp)
    800051a6:	65c6                	ld	a1,80(sp)
    800051a8:	6666                	ld	a2,88(sp)
    800051aa:	7686                	ld	a3,96(sp)
    800051ac:	7726                	ld	a4,104(sp)
    800051ae:	77c6                	ld	a5,112(sp)
    800051b0:	7866                	ld	a6,120(sp)
    800051b2:	688a                	ld	a7,128(sp)
    800051b4:	692a                	ld	s2,136(sp)
    800051b6:	69ca                	ld	s3,144(sp)
    800051b8:	6a6a                	ld	s4,152(sp)
    800051ba:	7a8a                	ld	s5,160(sp)
    800051bc:	7b2a                	ld	s6,168(sp)
    800051be:	7bca                	ld	s7,176(sp)
    800051c0:	7c6a                	ld	s8,184(sp)
    800051c2:	6c8e                	ld	s9,192(sp)
    800051c4:	6d2e                	ld	s10,200(sp)
    800051c6:	6dce                	ld	s11,208(sp)
    800051c8:	6e6e                	ld	t3,216(sp)
    800051ca:	7e8e                	ld	t4,224(sp)
    800051cc:	7f2e                	ld	t5,232(sp)
    800051ce:	7fce                	ld	t6,240(sp)
    800051d0:	6111                	addi	sp,sp,256
    800051d2:	10200073          	sret
    800051d6:	00000013          	nop
    800051da:	00000013          	nop
    800051de:	0001                	nop

00000000800051e0 <timervec>:
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	e10c                	sd	a1,0(a0)
    800051e6:	e510                	sd	a2,8(a0)
    800051e8:	e914                	sd	a3,16(a0)
    800051ea:	6d0c                	ld	a1,24(a0)
    800051ec:	7110                	ld	a2,32(a0)
    800051ee:	6194                	ld	a3,0(a1)
    800051f0:	96b2                	add	a3,a3,a2
    800051f2:	e194                	sd	a3,0(a1)
    800051f4:	4589                	li	a1,2
    800051f6:	14459073          	csrw	sip,a1
    800051fa:	6914                	ld	a3,16(a0)
    800051fc:	6510                	ld	a2,8(a0)
    800051fe:	610c                	ld	a1,0(a0)
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	30200073          	mret
	...

000000008000520a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000520a:	1141                	addi	sp,sp,-16
    8000520c:	e422                	sd	s0,8(sp)
    8000520e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005210:	0c0007b7          	lui	a5,0xc000
    80005214:	4705                	li	a4,1
    80005216:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005218:	c3d8                	sw	a4,4(a5)
}
    8000521a:	6422                	ld	s0,8(sp)
    8000521c:	0141                	addi	sp,sp,16
    8000521e:	8082                	ret

0000000080005220 <plicinithart>:

void
plicinithart(void)
{
    80005220:	1141                	addi	sp,sp,-16
    80005222:	e406                	sd	ra,8(sp)
    80005224:	e022                	sd	s0,0(sp)
    80005226:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	cea080e7          	jalr	-790(ra) # 80000f12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005230:	0085171b          	slliw	a4,a0,0x8
    80005234:	0c0027b7          	lui	a5,0xc002
    80005238:	97ba                	add	a5,a5,a4
    8000523a:	40200713          	li	a4,1026
    8000523e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005242:	00d5151b          	slliw	a0,a0,0xd
    80005246:	0c2017b7          	lui	a5,0xc201
    8000524a:	97aa                	add	a5,a5,a0
    8000524c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret

0000000080005258 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005258:	1141                	addi	sp,sp,-16
    8000525a:	e406                	sd	ra,8(sp)
    8000525c:	e022                	sd	s0,0(sp)
    8000525e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	cb2080e7          	jalr	-846(ra) # 80000f12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005268:	00d5151b          	slliw	a0,a0,0xd
    8000526c:	0c2017b7          	lui	a5,0xc201
    80005270:	97aa                	add	a5,a5,a0
  return irq;
}
    80005272:	43c8                	lw	a0,4(a5)
    80005274:	60a2                	ld	ra,8(sp)
    80005276:	6402                	ld	s0,0(sp)
    80005278:	0141                	addi	sp,sp,16
    8000527a:	8082                	ret

000000008000527c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
    80005286:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	c8a080e7          	jalr	-886(ra) # 80000f12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005290:	00d5151b          	slliw	a0,a0,0xd
    80005294:	0c2017b7          	lui	a5,0xc201
    80005298:	97aa                	add	a5,a5,a0
    8000529a:	c3c4                	sw	s1,4(a5)
}
    8000529c:	60e2                	ld	ra,24(sp)
    8000529e:	6442                	ld	s0,16(sp)
    800052a0:	64a2                	ld	s1,8(sp)
    800052a2:	6105                	addi	sp,sp,32
    800052a4:	8082                	ret

00000000800052a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052a6:	1141                	addi	sp,sp,-16
    800052a8:	e406                	sd	ra,8(sp)
    800052aa:	e022                	sd	s0,0(sp)
    800052ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ae:	479d                	li	a5,7
    800052b0:	04a7cc63          	blt	a5,a0,80005308 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052b4:	00015797          	auipc	a5,0x15
    800052b8:	9ac78793          	addi	a5,a5,-1620 # 80019c60 <disk>
    800052bc:	97aa                	add	a5,a5,a0
    800052be:	0187c783          	lbu	a5,24(a5)
    800052c2:	ebb9                	bnez	a5,80005318 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052c4:	00451693          	slli	a3,a0,0x4
    800052c8:	00015797          	auipc	a5,0x15
    800052cc:	99878793          	addi	a5,a5,-1640 # 80019c60 <disk>
    800052d0:	6398                	ld	a4,0(a5)
    800052d2:	9736                	add	a4,a4,a3
    800052d4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052d8:	6398                	ld	a4,0(a5)
    800052da:	9736                	add	a4,a4,a3
    800052dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052e8:	97aa                	add	a5,a5,a0
    800052ea:	4705                	li	a4,1
    800052ec:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800052f0:	00015517          	auipc	a0,0x15
    800052f4:	98850513          	addi	a0,a0,-1656 # 80019c78 <disk+0x18>
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	3d0080e7          	jalr	976(ra) # 800016c8 <wakeup>
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret
    panic("free_desc 1");
    80005308:	00003517          	auipc	a0,0x3
    8000530c:	43050513          	addi	a0,a0,1072 # 80008738 <syscalls+0x338>
    80005310:	00001097          	auipc	ra,0x1
    80005314:	a0c080e7          	jalr	-1524(ra) # 80005d1c <panic>
    panic("free_desc 2");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	43050513          	addi	a0,a0,1072 # 80008748 <syscalls+0x348>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	9fc080e7          	jalr	-1540(ra) # 80005d1c <panic>

0000000080005328 <virtio_disk_init>:
{
    80005328:	1101                	addi	sp,sp,-32
    8000532a:	ec06                	sd	ra,24(sp)
    8000532c:	e822                	sd	s0,16(sp)
    8000532e:	e426                	sd	s1,8(sp)
    80005330:	e04a                	sd	s2,0(sp)
    80005332:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005334:	00003597          	auipc	a1,0x3
    80005338:	42458593          	addi	a1,a1,1060 # 80008758 <syscalls+0x358>
    8000533c:	00015517          	auipc	a0,0x15
    80005340:	a4c50513          	addi	a0,a0,-1460 # 80019d88 <disk+0x128>
    80005344:	00001097          	auipc	ra,0x1
    80005348:	e80080e7          	jalr	-384(ra) # 800061c4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	4398                	lw	a4,0(a5)
    80005352:	2701                	sext.w	a4,a4
    80005354:	747277b7          	lui	a5,0x74727
    80005358:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000535c:	14f71b63          	bne	a4,a5,800054b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	43dc                	lw	a5,4(a5)
    80005366:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005368:	4709                	li	a4,2
    8000536a:	14e79463          	bne	a5,a4,800054b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	479c                	lw	a5,8(a5)
    80005374:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005376:	12e79e63          	bne	a5,a4,800054b2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000537a:	100017b7          	lui	a5,0x10001
    8000537e:	47d8                	lw	a4,12(a5)
    80005380:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005382:	554d47b7          	lui	a5,0x554d4
    80005386:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000538a:	12f71463          	bne	a4,a5,800054b2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538e:	100017b7          	lui	a5,0x10001
    80005392:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005396:	4705                	li	a4,1
    80005398:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539a:	470d                	li	a4,3
    8000539c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000539e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053a0:	c7ffe6b7          	lui	a3,0xc7ffe
    800053a4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc77f>
    800053a8:	8f75                	and	a4,a4,a3
    800053aa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ac:	472d                	li	a4,11
    800053ae:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053b0:	5bbc                	lw	a5,112(a5)
    800053b2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053b6:	8ba1                	andi	a5,a5,8
    800053b8:	10078563          	beqz	a5,800054c2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053bc:	100017b7          	lui	a5,0x10001
    800053c0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053c4:	43fc                	lw	a5,68(a5)
    800053c6:	2781                	sext.w	a5,a5
    800053c8:	10079563          	bnez	a5,800054d2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053cc:	100017b7          	lui	a5,0x10001
    800053d0:	5bdc                	lw	a5,52(a5)
    800053d2:	2781                	sext.w	a5,a5
  if(max == 0)
    800053d4:	10078763          	beqz	a5,800054e2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800053d8:	471d                	li	a4,7
    800053da:	10f77c63          	bgeu	a4,a5,800054f2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800053de:	ffffb097          	auipc	ra,0xffffb
    800053e2:	d3c080e7          	jalr	-708(ra) # 8000011a <kalloc>
    800053e6:	00015497          	auipc	s1,0x15
    800053ea:	87a48493          	addi	s1,s1,-1926 # 80019c60 <disk>
    800053ee:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053f0:	ffffb097          	auipc	ra,0xffffb
    800053f4:	d2a080e7          	jalr	-726(ra) # 8000011a <kalloc>
    800053f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053fa:	ffffb097          	auipc	ra,0xffffb
    800053fe:	d20080e7          	jalr	-736(ra) # 8000011a <kalloc>
    80005402:	87aa                	mv	a5,a0
    80005404:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005406:	6088                	ld	a0,0(s1)
    80005408:	cd6d                	beqz	a0,80005502 <virtio_disk_init+0x1da>
    8000540a:	00015717          	auipc	a4,0x15
    8000540e:	85e73703          	ld	a4,-1954(a4) # 80019c68 <disk+0x8>
    80005412:	cb65                	beqz	a4,80005502 <virtio_disk_init+0x1da>
    80005414:	c7fd                	beqz	a5,80005502 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005416:	6605                	lui	a2,0x1
    80005418:	4581                	li	a1,0
    8000541a:	ffffb097          	auipc	ra,0xffffb
    8000541e:	d60080e7          	jalr	-672(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005422:	00015497          	auipc	s1,0x15
    80005426:	83e48493          	addi	s1,s1,-1986 # 80019c60 <disk>
    8000542a:	6605                	lui	a2,0x1
    8000542c:	4581                	li	a1,0
    8000542e:	6488                	ld	a0,8(s1)
    80005430:	ffffb097          	auipc	ra,0xffffb
    80005434:	d4a080e7          	jalr	-694(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005438:	6605                	lui	a2,0x1
    8000543a:	4581                	li	a1,0
    8000543c:	6888                	ld	a0,16(s1)
    8000543e:	ffffb097          	auipc	ra,0xffffb
    80005442:	d3c080e7          	jalr	-708(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	4721                	li	a4,8
    8000544c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000544e:	4098                	lw	a4,0(s1)
    80005450:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005454:	40d8                	lw	a4,4(s1)
    80005456:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000545a:	6498                	ld	a4,8(s1)
    8000545c:	0007069b          	sext.w	a3,a4
    80005460:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005464:	9701                	srai	a4,a4,0x20
    80005466:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000546a:	6898                	ld	a4,16(s1)
    8000546c:	0007069b          	sext.w	a3,a4
    80005470:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005474:	9701                	srai	a4,a4,0x20
    80005476:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000547a:	4705                	li	a4,1
    8000547c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000547e:	00e48c23          	sb	a4,24(s1)
    80005482:	00e48ca3          	sb	a4,25(s1)
    80005486:	00e48d23          	sb	a4,26(s1)
    8000548a:	00e48da3          	sb	a4,27(s1)
    8000548e:	00e48e23          	sb	a4,28(s1)
    80005492:	00e48ea3          	sb	a4,29(s1)
    80005496:	00e48f23          	sb	a4,30(s1)
    8000549a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000549e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a2:	0727a823          	sw	s2,112(a5)
}
    800054a6:	60e2                	ld	ra,24(sp)
    800054a8:	6442                	ld	s0,16(sp)
    800054aa:	64a2                	ld	s1,8(sp)
    800054ac:	6902                	ld	s2,0(sp)
    800054ae:	6105                	addi	sp,sp,32
    800054b0:	8082                	ret
    panic("could not find virtio disk");
    800054b2:	00003517          	auipc	a0,0x3
    800054b6:	2b650513          	addi	a0,a0,694 # 80008768 <syscalls+0x368>
    800054ba:	00001097          	auipc	ra,0x1
    800054be:	862080e7          	jalr	-1950(ra) # 80005d1c <panic>
    panic("virtio disk FEATURES_OK unset");
    800054c2:	00003517          	auipc	a0,0x3
    800054c6:	2c650513          	addi	a0,a0,710 # 80008788 <syscalls+0x388>
    800054ca:	00001097          	auipc	ra,0x1
    800054ce:	852080e7          	jalr	-1966(ra) # 80005d1c <panic>
    panic("virtio disk should not be ready");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	2d650513          	addi	a0,a0,726 # 800087a8 <syscalls+0x3a8>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	842080e7          	jalr	-1982(ra) # 80005d1c <panic>
    panic("virtio disk has no queue 0");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	2e650513          	addi	a0,a0,742 # 800087c8 <syscalls+0x3c8>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	832080e7          	jalr	-1998(ra) # 80005d1c <panic>
    panic("virtio disk max queue too short");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	2f650513          	addi	a0,a0,758 # 800087e8 <syscalls+0x3e8>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	822080e7          	jalr	-2014(ra) # 80005d1c <panic>
    panic("virtio disk kalloc");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	30650513          	addi	a0,a0,774 # 80008808 <syscalls+0x408>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	812080e7          	jalr	-2030(ra) # 80005d1c <panic>

0000000080005512 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005512:	7119                	addi	sp,sp,-128
    80005514:	fc86                	sd	ra,120(sp)
    80005516:	f8a2                	sd	s0,112(sp)
    80005518:	f4a6                	sd	s1,104(sp)
    8000551a:	f0ca                	sd	s2,96(sp)
    8000551c:	ecce                	sd	s3,88(sp)
    8000551e:	e8d2                	sd	s4,80(sp)
    80005520:	e4d6                	sd	s5,72(sp)
    80005522:	e0da                	sd	s6,64(sp)
    80005524:	fc5e                	sd	s7,56(sp)
    80005526:	f862                	sd	s8,48(sp)
    80005528:	f466                	sd	s9,40(sp)
    8000552a:	f06a                	sd	s10,32(sp)
    8000552c:	ec6e                	sd	s11,24(sp)
    8000552e:	0100                	addi	s0,sp,128
    80005530:	8aaa                	mv	s5,a0
    80005532:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005534:	00c52d03          	lw	s10,12(a0)
    80005538:	001d1d1b          	slliw	s10,s10,0x1
    8000553c:	1d02                	slli	s10,s10,0x20
    8000553e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005542:	00015517          	auipc	a0,0x15
    80005546:	84650513          	addi	a0,a0,-1978 # 80019d88 <disk+0x128>
    8000554a:	00001097          	auipc	ra,0x1
    8000554e:	d0a080e7          	jalr	-758(ra) # 80006254 <acquire>
  for(int i = 0; i < 3; i++){
    80005552:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005554:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005556:	00014b97          	auipc	s7,0x14
    8000555a:	70ab8b93          	addi	s7,s7,1802 # 80019c60 <disk>
  for(int i = 0; i < 3; i++){
    8000555e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005560:	00015c97          	auipc	s9,0x15
    80005564:	828c8c93          	addi	s9,s9,-2008 # 80019d88 <disk+0x128>
    80005568:	a08d                	j	800055ca <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000556a:	00fb8733          	add	a4,s7,a5
    8000556e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005572:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005574:	0207c563          	bltz	a5,8000559e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005578:	2905                	addiw	s2,s2,1
    8000557a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000557c:	05690c63          	beq	s2,s6,800055d4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005580:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005582:	00014717          	auipc	a4,0x14
    80005586:	6de70713          	addi	a4,a4,1758 # 80019c60 <disk>
    8000558a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000558c:	01874683          	lbu	a3,24(a4)
    80005590:	fee9                	bnez	a3,8000556a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005592:	2785                	addiw	a5,a5,1
    80005594:	0705                	addi	a4,a4,1
    80005596:	fe979be3          	bne	a5,s1,8000558c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000559a:	57fd                	li	a5,-1
    8000559c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000559e:	01205d63          	blez	s2,800055b8 <virtio_disk_rw+0xa6>
    800055a2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055a4:	000a2503          	lw	a0,0(s4)
    800055a8:	00000097          	auipc	ra,0x0
    800055ac:	cfe080e7          	jalr	-770(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    800055b0:	2d85                	addiw	s11,s11,1
    800055b2:	0a11                	addi	s4,s4,4
    800055b4:	ff2d98e3          	bne	s11,s2,800055a4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055b8:	85e6                	mv	a1,s9
    800055ba:	00014517          	auipc	a0,0x14
    800055be:	6be50513          	addi	a0,a0,1726 # 80019c78 <disk+0x18>
    800055c2:	ffffc097          	auipc	ra,0xffffc
    800055c6:	0a2080e7          	jalr	162(ra) # 80001664 <sleep>
  for(int i = 0; i < 3; i++){
    800055ca:	f8040a13          	addi	s4,s0,-128
{
    800055ce:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055d0:	894e                	mv	s2,s3
    800055d2:	b77d                	j	80005580 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055d4:	f8042503          	lw	a0,-128(s0)
    800055d8:	00a50713          	addi	a4,a0,10
    800055dc:	0712                	slli	a4,a4,0x4

  if(write)
    800055de:	00014797          	auipc	a5,0x14
    800055e2:	68278793          	addi	a5,a5,1666 # 80019c60 <disk>
    800055e6:	00e786b3          	add	a3,a5,a4
    800055ea:	01803633          	snez	a2,s8
    800055ee:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800055f0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800055f4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800055f8:	f6070613          	addi	a2,a4,-160
    800055fc:	6394                	ld	a3,0(a5)
    800055fe:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005600:	00870593          	addi	a1,a4,8
    80005604:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005606:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005608:	0007b803          	ld	a6,0(a5)
    8000560c:	9642                	add	a2,a2,a6
    8000560e:	46c1                	li	a3,16
    80005610:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005612:	4585                	li	a1,1
    80005614:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005618:	f8442683          	lw	a3,-124(s0)
    8000561c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005620:	0692                	slli	a3,a3,0x4
    80005622:	9836                	add	a6,a6,a3
    80005624:	058a8613          	addi	a2,s5,88
    80005628:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000562c:	0007b803          	ld	a6,0(a5)
    80005630:	96c2                	add	a3,a3,a6
    80005632:	40000613          	li	a2,1024
    80005636:	c690                	sw	a2,8(a3)
  if(write)
    80005638:	001c3613          	seqz	a2,s8
    8000563c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005640:	00166613          	ori	a2,a2,1
    80005644:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005648:	f8842603          	lw	a2,-120(s0)
    8000564c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005650:	00250693          	addi	a3,a0,2
    80005654:	0692                	slli	a3,a3,0x4
    80005656:	96be                	add	a3,a3,a5
    80005658:	58fd                	li	a7,-1
    8000565a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000565e:	0612                	slli	a2,a2,0x4
    80005660:	9832                	add	a6,a6,a2
    80005662:	f9070713          	addi	a4,a4,-112
    80005666:	973e                	add	a4,a4,a5
    80005668:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000566c:	6398                	ld	a4,0(a5)
    8000566e:	9732                	add	a4,a4,a2
    80005670:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005672:	4609                	li	a2,2
    80005674:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005678:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000567c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005680:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005684:	6794                	ld	a3,8(a5)
    80005686:	0026d703          	lhu	a4,2(a3)
    8000568a:	8b1d                	andi	a4,a4,7
    8000568c:	0706                	slli	a4,a4,0x1
    8000568e:	96ba                	add	a3,a3,a4
    80005690:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005694:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005698:	6798                	ld	a4,8(a5)
    8000569a:	00275783          	lhu	a5,2(a4)
    8000569e:	2785                	addiw	a5,a5,1
    800056a0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056a4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056a8:	100017b7          	lui	a5,0x10001
    800056ac:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056b0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800056b4:	00014917          	auipc	s2,0x14
    800056b8:	6d490913          	addi	s2,s2,1748 # 80019d88 <disk+0x128>
  while(b->disk == 1) {
    800056bc:	4485                	li	s1,1
    800056be:	00b79c63          	bne	a5,a1,800056d6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056c2:	85ca                	mv	a1,s2
    800056c4:	8556                	mv	a0,s5
    800056c6:	ffffc097          	auipc	ra,0xffffc
    800056ca:	f9e080e7          	jalr	-98(ra) # 80001664 <sleep>
  while(b->disk == 1) {
    800056ce:	004aa783          	lw	a5,4(s5)
    800056d2:	fe9788e3          	beq	a5,s1,800056c2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056d6:	f8042903          	lw	s2,-128(s0)
    800056da:	00290713          	addi	a4,s2,2
    800056de:	0712                	slli	a4,a4,0x4
    800056e0:	00014797          	auipc	a5,0x14
    800056e4:	58078793          	addi	a5,a5,1408 # 80019c60 <disk>
    800056e8:	97ba                	add	a5,a5,a4
    800056ea:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800056ee:	00014997          	auipc	s3,0x14
    800056f2:	57298993          	addi	s3,s3,1394 # 80019c60 <disk>
    800056f6:	00491713          	slli	a4,s2,0x4
    800056fa:	0009b783          	ld	a5,0(s3)
    800056fe:	97ba                	add	a5,a5,a4
    80005700:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005704:	854a                	mv	a0,s2
    80005706:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000570a:	00000097          	auipc	ra,0x0
    8000570e:	b9c080e7          	jalr	-1124(ra) # 800052a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005712:	8885                	andi	s1,s1,1
    80005714:	f0ed                	bnez	s1,800056f6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005716:	00014517          	auipc	a0,0x14
    8000571a:	67250513          	addi	a0,a0,1650 # 80019d88 <disk+0x128>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	bea080e7          	jalr	-1046(ra) # 80006308 <release>
}
    80005726:	70e6                	ld	ra,120(sp)
    80005728:	7446                	ld	s0,112(sp)
    8000572a:	74a6                	ld	s1,104(sp)
    8000572c:	7906                	ld	s2,96(sp)
    8000572e:	69e6                	ld	s3,88(sp)
    80005730:	6a46                	ld	s4,80(sp)
    80005732:	6aa6                	ld	s5,72(sp)
    80005734:	6b06                	ld	s6,64(sp)
    80005736:	7be2                	ld	s7,56(sp)
    80005738:	7c42                	ld	s8,48(sp)
    8000573a:	7ca2                	ld	s9,40(sp)
    8000573c:	7d02                	ld	s10,32(sp)
    8000573e:	6de2                	ld	s11,24(sp)
    80005740:	6109                	addi	sp,sp,128
    80005742:	8082                	ret

0000000080005744 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005744:	1101                	addi	sp,sp,-32
    80005746:	ec06                	sd	ra,24(sp)
    80005748:	e822                	sd	s0,16(sp)
    8000574a:	e426                	sd	s1,8(sp)
    8000574c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000574e:	00014497          	auipc	s1,0x14
    80005752:	51248493          	addi	s1,s1,1298 # 80019c60 <disk>
    80005756:	00014517          	auipc	a0,0x14
    8000575a:	63250513          	addi	a0,a0,1586 # 80019d88 <disk+0x128>
    8000575e:	00001097          	auipc	ra,0x1
    80005762:	af6080e7          	jalr	-1290(ra) # 80006254 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005766:	10001737          	lui	a4,0x10001
    8000576a:	533c                	lw	a5,96(a4)
    8000576c:	8b8d                	andi	a5,a5,3
    8000576e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005770:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005774:	689c                	ld	a5,16(s1)
    80005776:	0204d703          	lhu	a4,32(s1)
    8000577a:	0027d783          	lhu	a5,2(a5)
    8000577e:	04f70863          	beq	a4,a5,800057ce <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005782:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005786:	6898                	ld	a4,16(s1)
    80005788:	0204d783          	lhu	a5,32(s1)
    8000578c:	8b9d                	andi	a5,a5,7
    8000578e:	078e                	slli	a5,a5,0x3
    80005790:	97ba                	add	a5,a5,a4
    80005792:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005794:	00278713          	addi	a4,a5,2
    80005798:	0712                	slli	a4,a4,0x4
    8000579a:	9726                	add	a4,a4,s1
    8000579c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057a0:	e721                	bnez	a4,800057e8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057a2:	0789                	addi	a5,a5,2
    800057a4:	0792                	slli	a5,a5,0x4
    800057a6:	97a6                	add	a5,a5,s1
    800057a8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057aa:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ae:	ffffc097          	auipc	ra,0xffffc
    800057b2:	f1a080e7          	jalr	-230(ra) # 800016c8 <wakeup>

    disk.used_idx += 1;
    800057b6:	0204d783          	lhu	a5,32(s1)
    800057ba:	2785                	addiw	a5,a5,1
    800057bc:	17c2                	slli	a5,a5,0x30
    800057be:	93c1                	srli	a5,a5,0x30
    800057c0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057c4:	6898                	ld	a4,16(s1)
    800057c6:	00275703          	lhu	a4,2(a4)
    800057ca:	faf71ce3          	bne	a4,a5,80005782 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057ce:	00014517          	auipc	a0,0x14
    800057d2:	5ba50513          	addi	a0,a0,1466 # 80019d88 <disk+0x128>
    800057d6:	00001097          	auipc	ra,0x1
    800057da:	b32080e7          	jalr	-1230(ra) # 80006308 <release>
}
    800057de:	60e2                	ld	ra,24(sp)
    800057e0:	6442                	ld	s0,16(sp)
    800057e2:	64a2                	ld	s1,8(sp)
    800057e4:	6105                	addi	sp,sp,32
    800057e6:	8082                	ret
      panic("virtio_disk_intr status");
    800057e8:	00003517          	auipc	a0,0x3
    800057ec:	03850513          	addi	a0,a0,56 # 80008820 <syscalls+0x420>
    800057f0:	00000097          	auipc	ra,0x0
    800057f4:	52c080e7          	jalr	1324(ra) # 80005d1c <panic>

00000000800057f8 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057f8:	1141                	addi	sp,sp,-16
    800057fa:	e422                	sd	s0,8(sp)
    800057fc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057fe:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005802:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005806:	0037979b          	slliw	a5,a5,0x3
    8000580a:	02004737          	lui	a4,0x2004
    8000580e:	97ba                	add	a5,a5,a4
    80005810:	0200c737          	lui	a4,0x200c
    80005814:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005818:	000f4637          	lui	a2,0xf4
    8000581c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005820:	9732                	add	a4,a4,a2
    80005822:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005824:	00259693          	slli	a3,a1,0x2
    80005828:	96ae                	add	a3,a3,a1
    8000582a:	068e                	slli	a3,a3,0x3
    8000582c:	00014717          	auipc	a4,0x14
    80005830:	57470713          	addi	a4,a4,1396 # 80019da0 <timer_scratch>
    80005834:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005836:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005838:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000583a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000583e:	00000797          	auipc	a5,0x0
    80005842:	9a278793          	addi	a5,a5,-1630 # 800051e0 <timervec>
    80005846:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000584a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000584e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005852:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005856:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000585a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000585e:	30479073          	csrw	mie,a5
}
    80005862:	6422                	ld	s0,8(sp)
    80005864:	0141                	addi	sp,sp,16
    80005866:	8082                	ret

0000000080005868 <start>:
{
    80005868:	1141                	addi	sp,sp,-16
    8000586a:	e406                	sd	ra,8(sp)
    8000586c:	e022                	sd	s0,0(sp)
    8000586e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005870:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005874:	7779                	lui	a4,0xffffe
    80005876:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc81f>
    8000587a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000587c:	6705                	lui	a4,0x1
    8000587e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005882:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005884:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005888:	ffffb797          	auipc	a5,0xffffb
    8000588c:	a9878793          	addi	a5,a5,-1384 # 80000320 <main>
    80005890:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005894:	4781                	li	a5,0
    80005896:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000589a:	67c1                	lui	a5,0x10
    8000589c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000589e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058a2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058a6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058aa:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ae:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058b2:	57fd                	li	a5,-1
    800058b4:	83a9                	srli	a5,a5,0xa
    800058b6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058ba:	47bd                	li	a5,15
    800058bc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058c0:	00000097          	auipc	ra,0x0
    800058c4:	f38080e7          	jalr	-200(ra) # 800057f8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058c8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058cc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ce:	823e                	mv	tp,a5
  asm volatile("mret");
    800058d0:	30200073          	mret
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret

00000000800058dc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058dc:	715d                	addi	sp,sp,-80
    800058de:	e486                	sd	ra,72(sp)
    800058e0:	e0a2                	sd	s0,64(sp)
    800058e2:	fc26                	sd	s1,56(sp)
    800058e4:	f84a                	sd	s2,48(sp)
    800058e6:	f44e                	sd	s3,40(sp)
    800058e8:	f052                	sd	s4,32(sp)
    800058ea:	ec56                	sd	s5,24(sp)
    800058ec:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058ee:	04c05763          	blez	a2,8000593c <consolewrite+0x60>
    800058f2:	8a2a                	mv	s4,a0
    800058f4:	84ae                	mv	s1,a1
    800058f6:	89b2                	mv	s3,a2
    800058f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058fa:	5afd                	li	s5,-1
    800058fc:	4685                	li	a3,1
    800058fe:	8626                	mv	a2,s1
    80005900:	85d2                	mv	a1,s4
    80005902:	fbf40513          	addi	a0,s0,-65
    80005906:	ffffc097          	auipc	ra,0xffffc
    8000590a:	1bc080e7          	jalr	444(ra) # 80001ac2 <either_copyin>
    8000590e:	01550d63          	beq	a0,s5,80005928 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005912:	fbf44503          	lbu	a0,-65(s0)
    80005916:	00000097          	auipc	ra,0x0
    8000591a:	784080e7          	jalr	1924(ra) # 8000609a <uartputc>
  for(i = 0; i < n; i++){
    8000591e:	2905                	addiw	s2,s2,1
    80005920:	0485                	addi	s1,s1,1
    80005922:	fd299de3          	bne	s3,s2,800058fc <consolewrite+0x20>
    80005926:	894e                	mv	s2,s3
  }

  return i;
}
    80005928:	854a                	mv	a0,s2
    8000592a:	60a6                	ld	ra,72(sp)
    8000592c:	6406                	ld	s0,64(sp)
    8000592e:	74e2                	ld	s1,56(sp)
    80005930:	7942                	ld	s2,48(sp)
    80005932:	79a2                	ld	s3,40(sp)
    80005934:	7a02                	ld	s4,32(sp)
    80005936:	6ae2                	ld	s5,24(sp)
    80005938:	6161                	addi	sp,sp,80
    8000593a:	8082                	ret
  for(i = 0; i < n; i++){
    8000593c:	4901                	li	s2,0
    8000593e:	b7ed                	j	80005928 <consolewrite+0x4c>

0000000080005940 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005940:	7159                	addi	sp,sp,-112
    80005942:	f486                	sd	ra,104(sp)
    80005944:	f0a2                	sd	s0,96(sp)
    80005946:	eca6                	sd	s1,88(sp)
    80005948:	e8ca                	sd	s2,80(sp)
    8000594a:	e4ce                	sd	s3,72(sp)
    8000594c:	e0d2                	sd	s4,64(sp)
    8000594e:	fc56                	sd	s5,56(sp)
    80005950:	f85a                	sd	s6,48(sp)
    80005952:	f45e                	sd	s7,40(sp)
    80005954:	f062                	sd	s8,32(sp)
    80005956:	ec66                	sd	s9,24(sp)
    80005958:	e86a                	sd	s10,16(sp)
    8000595a:	1880                	addi	s0,sp,112
    8000595c:	8aaa                	mv	s5,a0
    8000595e:	8a2e                	mv	s4,a1
    80005960:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005962:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005966:	0001c517          	auipc	a0,0x1c
    8000596a:	57a50513          	addi	a0,a0,1402 # 80021ee0 <cons>
    8000596e:	00001097          	auipc	ra,0x1
    80005972:	8e6080e7          	jalr	-1818(ra) # 80006254 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005976:	0001c497          	auipc	s1,0x1c
    8000597a:	56a48493          	addi	s1,s1,1386 # 80021ee0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000597e:	0001c917          	auipc	s2,0x1c
    80005982:	5fa90913          	addi	s2,s2,1530 # 80021f78 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005986:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005988:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000598a:	4ca9                	li	s9,10
  while(n > 0){
    8000598c:	07305b63          	blez	s3,80005a02 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005990:	0984a783          	lw	a5,152(s1)
    80005994:	09c4a703          	lw	a4,156(s1)
    80005998:	02f71763          	bne	a4,a5,800059c6 <consoleread+0x86>
      if(killed(myproc())){
    8000599c:	ffffb097          	auipc	ra,0xffffb
    800059a0:	5a2080e7          	jalr	1442(ra) # 80000f3e <myproc>
    800059a4:	ffffc097          	auipc	ra,0xffffc
    800059a8:	f68080e7          	jalr	-152(ra) # 8000190c <killed>
    800059ac:	e535                	bnez	a0,80005a18 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059ae:	85a6                	mv	a1,s1
    800059b0:	854a                	mv	a0,s2
    800059b2:	ffffc097          	auipc	ra,0xffffc
    800059b6:	cb2080e7          	jalr	-846(ra) # 80001664 <sleep>
    while(cons.r == cons.w){
    800059ba:	0984a783          	lw	a5,152(s1)
    800059be:	09c4a703          	lw	a4,156(s1)
    800059c2:	fcf70de3          	beq	a4,a5,8000599c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059c6:	0017871b          	addiw	a4,a5,1
    800059ca:	08e4ac23          	sw	a4,152(s1)
    800059ce:	07f7f713          	andi	a4,a5,127
    800059d2:	9726                	add	a4,a4,s1
    800059d4:	01874703          	lbu	a4,24(a4)
    800059d8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800059dc:	077d0563          	beq	s10,s7,80005a46 <consoleread+0x106>
    cbuf = c;
    800059e0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059e4:	4685                	li	a3,1
    800059e6:	f9f40613          	addi	a2,s0,-97
    800059ea:	85d2                	mv	a1,s4
    800059ec:	8556                	mv	a0,s5
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	07e080e7          	jalr	126(ra) # 80001a6c <either_copyout>
    800059f6:	01850663          	beq	a0,s8,80005a02 <consoleread+0xc2>
    dst++;
    800059fa:	0a05                	addi	s4,s4,1
    --n;
    800059fc:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    800059fe:	f99d17e3          	bne	s10,s9,8000598c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a02:	0001c517          	auipc	a0,0x1c
    80005a06:	4de50513          	addi	a0,a0,1246 # 80021ee0 <cons>
    80005a0a:	00001097          	auipc	ra,0x1
    80005a0e:	8fe080e7          	jalr	-1794(ra) # 80006308 <release>

  return target - n;
    80005a12:	413b053b          	subw	a0,s6,s3
    80005a16:	a811                	j	80005a2a <consoleread+0xea>
        release(&cons.lock);
    80005a18:	0001c517          	auipc	a0,0x1c
    80005a1c:	4c850513          	addi	a0,a0,1224 # 80021ee0 <cons>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	8e8080e7          	jalr	-1816(ra) # 80006308 <release>
        return -1;
    80005a28:	557d                	li	a0,-1
}
    80005a2a:	70a6                	ld	ra,104(sp)
    80005a2c:	7406                	ld	s0,96(sp)
    80005a2e:	64e6                	ld	s1,88(sp)
    80005a30:	6946                	ld	s2,80(sp)
    80005a32:	69a6                	ld	s3,72(sp)
    80005a34:	6a06                	ld	s4,64(sp)
    80005a36:	7ae2                	ld	s5,56(sp)
    80005a38:	7b42                	ld	s6,48(sp)
    80005a3a:	7ba2                	ld	s7,40(sp)
    80005a3c:	7c02                	ld	s8,32(sp)
    80005a3e:	6ce2                	ld	s9,24(sp)
    80005a40:	6d42                	ld	s10,16(sp)
    80005a42:	6165                	addi	sp,sp,112
    80005a44:	8082                	ret
      if(n < target){
    80005a46:	0009871b          	sext.w	a4,s3
    80005a4a:	fb677ce3          	bgeu	a4,s6,80005a02 <consoleread+0xc2>
        cons.r--;
    80005a4e:	0001c717          	auipc	a4,0x1c
    80005a52:	52f72523          	sw	a5,1322(a4) # 80021f78 <cons+0x98>
    80005a56:	b775                	j	80005a02 <consoleread+0xc2>

0000000080005a58 <consputc>:
{
    80005a58:	1141                	addi	sp,sp,-16
    80005a5a:	e406                	sd	ra,8(sp)
    80005a5c:	e022                	sd	s0,0(sp)
    80005a5e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a60:	10000793          	li	a5,256
    80005a64:	00f50a63          	beq	a0,a5,80005a78 <consputc+0x20>
    uartputc_sync(c);
    80005a68:	00000097          	auipc	ra,0x0
    80005a6c:	560080e7          	jalr	1376(ra) # 80005fc8 <uartputc_sync>
}
    80005a70:	60a2                	ld	ra,8(sp)
    80005a72:	6402                	ld	s0,0(sp)
    80005a74:	0141                	addi	sp,sp,16
    80005a76:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a78:	4521                	li	a0,8
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	54e080e7          	jalr	1358(ra) # 80005fc8 <uartputc_sync>
    80005a82:	02000513          	li	a0,32
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	542080e7          	jalr	1346(ra) # 80005fc8 <uartputc_sync>
    80005a8e:	4521                	li	a0,8
    80005a90:	00000097          	auipc	ra,0x0
    80005a94:	538080e7          	jalr	1336(ra) # 80005fc8 <uartputc_sync>
    80005a98:	bfe1                	j	80005a70 <consputc+0x18>

0000000080005a9a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a9a:	1101                	addi	sp,sp,-32
    80005a9c:	ec06                	sd	ra,24(sp)
    80005a9e:	e822                	sd	s0,16(sp)
    80005aa0:	e426                	sd	s1,8(sp)
    80005aa2:	e04a                	sd	s2,0(sp)
    80005aa4:	1000                	addi	s0,sp,32
    80005aa6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005aa8:	0001c517          	auipc	a0,0x1c
    80005aac:	43850513          	addi	a0,a0,1080 # 80021ee0 <cons>
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	7a4080e7          	jalr	1956(ra) # 80006254 <acquire>

  switch(c){
    80005ab8:	47d5                	li	a5,21
    80005aba:	0af48663          	beq	s1,a5,80005b66 <consoleintr+0xcc>
    80005abe:	0297ca63          	blt	a5,s1,80005af2 <consoleintr+0x58>
    80005ac2:	47a1                	li	a5,8
    80005ac4:	0ef48763          	beq	s1,a5,80005bb2 <consoleintr+0x118>
    80005ac8:	47c1                	li	a5,16
    80005aca:	10f49a63          	bne	s1,a5,80005bde <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005ace:	ffffc097          	auipc	ra,0xffffc
    80005ad2:	04a080e7          	jalr	74(ra) # 80001b18 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005ad6:	0001c517          	auipc	a0,0x1c
    80005ada:	40a50513          	addi	a0,a0,1034 # 80021ee0 <cons>
    80005ade:	00001097          	auipc	ra,0x1
    80005ae2:	82a080e7          	jalr	-2006(ra) # 80006308 <release>
}
    80005ae6:	60e2                	ld	ra,24(sp)
    80005ae8:	6442                	ld	s0,16(sp)
    80005aea:	64a2                	ld	s1,8(sp)
    80005aec:	6902                	ld	s2,0(sp)
    80005aee:	6105                	addi	sp,sp,32
    80005af0:	8082                	ret
  switch(c){
    80005af2:	07f00793          	li	a5,127
    80005af6:	0af48e63          	beq	s1,a5,80005bb2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005afa:	0001c717          	auipc	a4,0x1c
    80005afe:	3e670713          	addi	a4,a4,998 # 80021ee0 <cons>
    80005b02:	0a072783          	lw	a5,160(a4)
    80005b06:	09872703          	lw	a4,152(a4)
    80005b0a:	9f99                	subw	a5,a5,a4
    80005b0c:	07f00713          	li	a4,127
    80005b10:	fcf763e3          	bltu	a4,a5,80005ad6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b14:	47b5                	li	a5,13
    80005b16:	0cf48763          	beq	s1,a5,80005be4 <consoleintr+0x14a>
      consputc(c);
    80005b1a:	8526                	mv	a0,s1
    80005b1c:	00000097          	auipc	ra,0x0
    80005b20:	f3c080e7          	jalr	-196(ra) # 80005a58 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b24:	0001c797          	auipc	a5,0x1c
    80005b28:	3bc78793          	addi	a5,a5,956 # 80021ee0 <cons>
    80005b2c:	0a07a683          	lw	a3,160(a5)
    80005b30:	0016871b          	addiw	a4,a3,1
    80005b34:	0007061b          	sext.w	a2,a4
    80005b38:	0ae7a023          	sw	a4,160(a5)
    80005b3c:	07f6f693          	andi	a3,a3,127
    80005b40:	97b6                	add	a5,a5,a3
    80005b42:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b46:	47a9                	li	a5,10
    80005b48:	0cf48563          	beq	s1,a5,80005c12 <consoleintr+0x178>
    80005b4c:	4791                	li	a5,4
    80005b4e:	0cf48263          	beq	s1,a5,80005c12 <consoleintr+0x178>
    80005b52:	0001c797          	auipc	a5,0x1c
    80005b56:	4267a783          	lw	a5,1062(a5) # 80021f78 <cons+0x98>
    80005b5a:	9f1d                	subw	a4,a4,a5
    80005b5c:	08000793          	li	a5,128
    80005b60:	f6f71be3          	bne	a4,a5,80005ad6 <consoleintr+0x3c>
    80005b64:	a07d                	j	80005c12 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b66:	0001c717          	auipc	a4,0x1c
    80005b6a:	37a70713          	addi	a4,a4,890 # 80021ee0 <cons>
    80005b6e:	0a072783          	lw	a5,160(a4)
    80005b72:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b76:	0001c497          	auipc	s1,0x1c
    80005b7a:	36a48493          	addi	s1,s1,874 # 80021ee0 <cons>
    while(cons.e != cons.w &&
    80005b7e:	4929                	li	s2,10
    80005b80:	f4f70be3          	beq	a4,a5,80005ad6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b84:	37fd                	addiw	a5,a5,-1
    80005b86:	07f7f713          	andi	a4,a5,127
    80005b8a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b8c:	01874703          	lbu	a4,24(a4)
    80005b90:	f52703e3          	beq	a4,s2,80005ad6 <consoleintr+0x3c>
      cons.e--;
    80005b94:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b98:	10000513          	li	a0,256
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	ebc080e7          	jalr	-324(ra) # 80005a58 <consputc>
    while(cons.e != cons.w &&
    80005ba4:	0a04a783          	lw	a5,160(s1)
    80005ba8:	09c4a703          	lw	a4,156(s1)
    80005bac:	fcf71ce3          	bne	a4,a5,80005b84 <consoleintr+0xea>
    80005bb0:	b71d                	j	80005ad6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bb2:	0001c717          	auipc	a4,0x1c
    80005bb6:	32e70713          	addi	a4,a4,814 # 80021ee0 <cons>
    80005bba:	0a072783          	lw	a5,160(a4)
    80005bbe:	09c72703          	lw	a4,156(a4)
    80005bc2:	f0f70ae3          	beq	a4,a5,80005ad6 <consoleintr+0x3c>
      cons.e--;
    80005bc6:	37fd                	addiw	a5,a5,-1
    80005bc8:	0001c717          	auipc	a4,0x1c
    80005bcc:	3af72c23          	sw	a5,952(a4) # 80021f80 <cons+0xa0>
      consputc(BACKSPACE);
    80005bd0:	10000513          	li	a0,256
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	e84080e7          	jalr	-380(ra) # 80005a58 <consputc>
    80005bdc:	bded                	j	80005ad6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bde:	ee048ce3          	beqz	s1,80005ad6 <consoleintr+0x3c>
    80005be2:	bf21                	j	80005afa <consoleintr+0x60>
      consputc(c);
    80005be4:	4529                	li	a0,10
    80005be6:	00000097          	auipc	ra,0x0
    80005bea:	e72080e7          	jalr	-398(ra) # 80005a58 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bee:	0001c797          	auipc	a5,0x1c
    80005bf2:	2f278793          	addi	a5,a5,754 # 80021ee0 <cons>
    80005bf6:	0a07a703          	lw	a4,160(a5)
    80005bfa:	0017069b          	addiw	a3,a4,1
    80005bfe:	0006861b          	sext.w	a2,a3
    80005c02:	0ad7a023          	sw	a3,160(a5)
    80005c06:	07f77713          	andi	a4,a4,127
    80005c0a:	97ba                	add	a5,a5,a4
    80005c0c:	4729                	li	a4,10
    80005c0e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c12:	0001c797          	auipc	a5,0x1c
    80005c16:	36c7a523          	sw	a2,874(a5) # 80021f7c <cons+0x9c>
        wakeup(&cons.r);
    80005c1a:	0001c517          	auipc	a0,0x1c
    80005c1e:	35e50513          	addi	a0,a0,862 # 80021f78 <cons+0x98>
    80005c22:	ffffc097          	auipc	ra,0xffffc
    80005c26:	aa6080e7          	jalr	-1370(ra) # 800016c8 <wakeup>
    80005c2a:	b575                	j	80005ad6 <consoleintr+0x3c>

0000000080005c2c <consoleinit>:

void
consoleinit(void)
{
    80005c2c:	1141                	addi	sp,sp,-16
    80005c2e:	e406                	sd	ra,8(sp)
    80005c30:	e022                	sd	s0,0(sp)
    80005c32:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c34:	00003597          	auipc	a1,0x3
    80005c38:	c0458593          	addi	a1,a1,-1020 # 80008838 <syscalls+0x438>
    80005c3c:	0001c517          	auipc	a0,0x1c
    80005c40:	2a450513          	addi	a0,a0,676 # 80021ee0 <cons>
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	580080e7          	jalr	1408(ra) # 800061c4 <initlock>

  uartinit();
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	32c080e7          	jalr	812(ra) # 80005f78 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c54:	00013797          	auipc	a5,0x13
    80005c58:	fb478793          	addi	a5,a5,-76 # 80018c08 <devsw>
    80005c5c:	00000717          	auipc	a4,0x0
    80005c60:	ce470713          	addi	a4,a4,-796 # 80005940 <consoleread>
    80005c64:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c66:	00000717          	auipc	a4,0x0
    80005c6a:	c7670713          	addi	a4,a4,-906 # 800058dc <consolewrite>
    80005c6e:	ef98                	sd	a4,24(a5)
}
    80005c70:	60a2                	ld	ra,8(sp)
    80005c72:	6402                	ld	s0,0(sp)
    80005c74:	0141                	addi	sp,sp,16
    80005c76:	8082                	ret

0000000080005c78 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c78:	7179                	addi	sp,sp,-48
    80005c7a:	f406                	sd	ra,40(sp)
    80005c7c:	f022                	sd	s0,32(sp)
    80005c7e:	ec26                	sd	s1,24(sp)
    80005c80:	e84a                	sd	s2,16(sp)
    80005c82:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c84:	c219                	beqz	a2,80005c8a <printint+0x12>
    80005c86:	08054763          	bltz	a0,80005d14 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c8a:	2501                	sext.w	a0,a0
    80005c8c:	4881                	li	a7,0
    80005c8e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c92:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c94:	2581                	sext.w	a1,a1
    80005c96:	00003617          	auipc	a2,0x3
    80005c9a:	bd260613          	addi	a2,a2,-1070 # 80008868 <digits>
    80005c9e:	883a                	mv	a6,a4
    80005ca0:	2705                	addiw	a4,a4,1
    80005ca2:	02b577bb          	remuw	a5,a0,a1
    80005ca6:	1782                	slli	a5,a5,0x20
    80005ca8:	9381                	srli	a5,a5,0x20
    80005caa:	97b2                	add	a5,a5,a2
    80005cac:	0007c783          	lbu	a5,0(a5)
    80005cb0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cb4:	0005079b          	sext.w	a5,a0
    80005cb8:	02b5553b          	divuw	a0,a0,a1
    80005cbc:	0685                	addi	a3,a3,1
    80005cbe:	feb7f0e3          	bgeu	a5,a1,80005c9e <printint+0x26>

  if(sign)
    80005cc2:	00088c63          	beqz	a7,80005cda <printint+0x62>
    buf[i++] = '-';
    80005cc6:	fe070793          	addi	a5,a4,-32
    80005cca:	00878733          	add	a4,a5,s0
    80005cce:	02d00793          	li	a5,45
    80005cd2:	fef70823          	sb	a5,-16(a4)
    80005cd6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cda:	02e05763          	blez	a4,80005d08 <printint+0x90>
    80005cde:	fd040793          	addi	a5,s0,-48
    80005ce2:	00e784b3          	add	s1,a5,a4
    80005ce6:	fff78913          	addi	s2,a5,-1
    80005cea:	993a                	add	s2,s2,a4
    80005cec:	377d                	addiw	a4,a4,-1
    80005cee:	1702                	slli	a4,a4,0x20
    80005cf0:	9301                	srli	a4,a4,0x20
    80005cf2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cf6:	fff4c503          	lbu	a0,-1(s1)
    80005cfa:	00000097          	auipc	ra,0x0
    80005cfe:	d5e080e7          	jalr	-674(ra) # 80005a58 <consputc>
  while(--i >= 0)
    80005d02:	14fd                	addi	s1,s1,-1
    80005d04:	ff2499e3          	bne	s1,s2,80005cf6 <printint+0x7e>
}
    80005d08:	70a2                	ld	ra,40(sp)
    80005d0a:	7402                	ld	s0,32(sp)
    80005d0c:	64e2                	ld	s1,24(sp)
    80005d0e:	6942                	ld	s2,16(sp)
    80005d10:	6145                	addi	sp,sp,48
    80005d12:	8082                	ret
    x = -xx;
    80005d14:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d18:	4885                	li	a7,1
    x = -xx;
    80005d1a:	bf95                	j	80005c8e <printint+0x16>

0000000080005d1c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d1c:	1101                	addi	sp,sp,-32
    80005d1e:	ec06                	sd	ra,24(sp)
    80005d20:	e822                	sd	s0,16(sp)
    80005d22:	e426                	sd	s1,8(sp)
    80005d24:	1000                	addi	s0,sp,32
    80005d26:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d28:	0001c797          	auipc	a5,0x1c
    80005d2c:	2607ac23          	sw	zero,632(a5) # 80021fa0 <pr+0x18>
  printf("panic: ");
    80005d30:	00003517          	auipc	a0,0x3
    80005d34:	b1050513          	addi	a0,a0,-1264 # 80008840 <syscalls+0x440>
    80005d38:	00000097          	auipc	ra,0x0
    80005d3c:	02e080e7          	jalr	46(ra) # 80005d66 <printf>
  printf(s);
    80005d40:	8526                	mv	a0,s1
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	024080e7          	jalr	36(ra) # 80005d66 <printf>
  printf("\n");
    80005d4a:	00002517          	auipc	a0,0x2
    80005d4e:	2fe50513          	addi	a0,a0,766 # 80008048 <etext+0x48>
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	014080e7          	jalr	20(ra) # 80005d66 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d5a:	4785                	li	a5,1
    80005d5c:	00003717          	auipc	a4,0x3
    80005d60:	bef72c23          	sw	a5,-1032(a4) # 80008954 <panicked>
  for(;;)
    80005d64:	a001                	j	80005d64 <panic+0x48>

0000000080005d66 <printf>:
{
    80005d66:	7131                	addi	sp,sp,-192
    80005d68:	fc86                	sd	ra,120(sp)
    80005d6a:	f8a2                	sd	s0,112(sp)
    80005d6c:	f4a6                	sd	s1,104(sp)
    80005d6e:	f0ca                	sd	s2,96(sp)
    80005d70:	ecce                	sd	s3,88(sp)
    80005d72:	e8d2                	sd	s4,80(sp)
    80005d74:	e4d6                	sd	s5,72(sp)
    80005d76:	e0da                	sd	s6,64(sp)
    80005d78:	fc5e                	sd	s7,56(sp)
    80005d7a:	f862                	sd	s8,48(sp)
    80005d7c:	f466                	sd	s9,40(sp)
    80005d7e:	f06a                	sd	s10,32(sp)
    80005d80:	ec6e                	sd	s11,24(sp)
    80005d82:	0100                	addi	s0,sp,128
    80005d84:	8a2a                	mv	s4,a0
    80005d86:	e40c                	sd	a1,8(s0)
    80005d88:	e810                	sd	a2,16(s0)
    80005d8a:	ec14                	sd	a3,24(s0)
    80005d8c:	f018                	sd	a4,32(s0)
    80005d8e:	f41c                	sd	a5,40(s0)
    80005d90:	03043823          	sd	a6,48(s0)
    80005d94:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d98:	0001cd97          	auipc	s11,0x1c
    80005d9c:	208dad83          	lw	s11,520(s11) # 80021fa0 <pr+0x18>
  if(locking)
    80005da0:	020d9b63          	bnez	s11,80005dd6 <printf+0x70>
  if (fmt == 0)
    80005da4:	040a0263          	beqz	s4,80005de8 <printf+0x82>
  va_start(ap, fmt);
    80005da8:	00840793          	addi	a5,s0,8
    80005dac:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005db0:	000a4503          	lbu	a0,0(s4)
    80005db4:	14050f63          	beqz	a0,80005f12 <printf+0x1ac>
    80005db8:	4981                	li	s3,0
    if(c != '%'){
    80005dba:	02500a93          	li	s5,37
    switch(c){
    80005dbe:	07000b93          	li	s7,112
  consputc('x');
    80005dc2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dc4:	00003b17          	auipc	s6,0x3
    80005dc8:	aa4b0b13          	addi	s6,s6,-1372 # 80008868 <digits>
    switch(c){
    80005dcc:	07300c93          	li	s9,115
    80005dd0:	06400c13          	li	s8,100
    80005dd4:	a82d                	j	80005e0e <printf+0xa8>
    acquire(&pr.lock);
    80005dd6:	0001c517          	auipc	a0,0x1c
    80005dda:	1b250513          	addi	a0,a0,434 # 80021f88 <pr>
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	476080e7          	jalr	1142(ra) # 80006254 <acquire>
    80005de6:	bf7d                	j	80005da4 <printf+0x3e>
    panic("null fmt");
    80005de8:	00003517          	auipc	a0,0x3
    80005dec:	a6850513          	addi	a0,a0,-1432 # 80008850 <syscalls+0x450>
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	f2c080e7          	jalr	-212(ra) # 80005d1c <panic>
      consputc(c);
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	c60080e7          	jalr	-928(ra) # 80005a58 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e00:	2985                	addiw	s3,s3,1
    80005e02:	013a07b3          	add	a5,s4,s3
    80005e06:	0007c503          	lbu	a0,0(a5)
    80005e0a:	10050463          	beqz	a0,80005f12 <printf+0x1ac>
    if(c != '%'){
    80005e0e:	ff5515e3          	bne	a0,s5,80005df8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e12:	2985                	addiw	s3,s3,1
    80005e14:	013a07b3          	add	a5,s4,s3
    80005e18:	0007c783          	lbu	a5,0(a5)
    80005e1c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e20:	cbed                	beqz	a5,80005f12 <printf+0x1ac>
    switch(c){
    80005e22:	05778a63          	beq	a5,s7,80005e76 <printf+0x110>
    80005e26:	02fbf663          	bgeu	s7,a5,80005e52 <printf+0xec>
    80005e2a:	09978863          	beq	a5,s9,80005eba <printf+0x154>
    80005e2e:	07800713          	li	a4,120
    80005e32:	0ce79563          	bne	a5,a4,80005efc <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e36:	f8843783          	ld	a5,-120(s0)
    80005e3a:	00878713          	addi	a4,a5,8
    80005e3e:	f8e43423          	sd	a4,-120(s0)
    80005e42:	4605                	li	a2,1
    80005e44:	85ea                	mv	a1,s10
    80005e46:	4388                	lw	a0,0(a5)
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	e30080e7          	jalr	-464(ra) # 80005c78 <printint>
      break;
    80005e50:	bf45                	j	80005e00 <printf+0x9a>
    switch(c){
    80005e52:	09578f63          	beq	a5,s5,80005ef0 <printf+0x18a>
    80005e56:	0b879363          	bne	a5,s8,80005efc <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e5a:	f8843783          	ld	a5,-120(s0)
    80005e5e:	00878713          	addi	a4,a5,8
    80005e62:	f8e43423          	sd	a4,-120(s0)
    80005e66:	4605                	li	a2,1
    80005e68:	45a9                	li	a1,10
    80005e6a:	4388                	lw	a0,0(a5)
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	e0c080e7          	jalr	-500(ra) # 80005c78 <printint>
      break;
    80005e74:	b771                	j	80005e00 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e76:	f8843783          	ld	a5,-120(s0)
    80005e7a:	00878713          	addi	a4,a5,8
    80005e7e:	f8e43423          	sd	a4,-120(s0)
    80005e82:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e86:	03000513          	li	a0,48
    80005e8a:	00000097          	auipc	ra,0x0
    80005e8e:	bce080e7          	jalr	-1074(ra) # 80005a58 <consputc>
  consputc('x');
    80005e92:	07800513          	li	a0,120
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	bc2080e7          	jalr	-1086(ra) # 80005a58 <consputc>
    80005e9e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea0:	03c95793          	srli	a5,s2,0x3c
    80005ea4:	97da                	add	a5,a5,s6
    80005ea6:	0007c503          	lbu	a0,0(a5)
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	bae080e7          	jalr	-1106(ra) # 80005a58 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005eb2:	0912                	slli	s2,s2,0x4
    80005eb4:	34fd                	addiw	s1,s1,-1
    80005eb6:	f4ed                	bnez	s1,80005ea0 <printf+0x13a>
    80005eb8:	b7a1                	j	80005e00 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eba:	f8843783          	ld	a5,-120(s0)
    80005ebe:	00878713          	addi	a4,a5,8
    80005ec2:	f8e43423          	sd	a4,-120(s0)
    80005ec6:	6384                	ld	s1,0(a5)
    80005ec8:	cc89                	beqz	s1,80005ee2 <printf+0x17c>
      for(; *s; s++)
    80005eca:	0004c503          	lbu	a0,0(s1)
    80005ece:	d90d                	beqz	a0,80005e00 <printf+0x9a>
        consputc(*s);
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	b88080e7          	jalr	-1144(ra) # 80005a58 <consputc>
      for(; *s; s++)
    80005ed8:	0485                	addi	s1,s1,1
    80005eda:	0004c503          	lbu	a0,0(s1)
    80005ede:	f96d                	bnez	a0,80005ed0 <printf+0x16a>
    80005ee0:	b705                	j	80005e00 <printf+0x9a>
        s = "(null)";
    80005ee2:	00003497          	auipc	s1,0x3
    80005ee6:	96648493          	addi	s1,s1,-1690 # 80008848 <syscalls+0x448>
      for(; *s; s++)
    80005eea:	02800513          	li	a0,40
    80005eee:	b7cd                	j	80005ed0 <printf+0x16a>
      consputc('%');
    80005ef0:	8556                	mv	a0,s5
    80005ef2:	00000097          	auipc	ra,0x0
    80005ef6:	b66080e7          	jalr	-1178(ra) # 80005a58 <consputc>
      break;
    80005efa:	b719                	j	80005e00 <printf+0x9a>
      consputc('%');
    80005efc:	8556                	mv	a0,s5
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	b5a080e7          	jalr	-1190(ra) # 80005a58 <consputc>
      consputc(c);
    80005f06:	8526                	mv	a0,s1
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	b50080e7          	jalr	-1200(ra) # 80005a58 <consputc>
      break;
    80005f10:	bdc5                	j	80005e00 <printf+0x9a>
  if(locking)
    80005f12:	020d9163          	bnez	s11,80005f34 <printf+0x1ce>
}
    80005f16:	70e6                	ld	ra,120(sp)
    80005f18:	7446                	ld	s0,112(sp)
    80005f1a:	74a6                	ld	s1,104(sp)
    80005f1c:	7906                	ld	s2,96(sp)
    80005f1e:	69e6                	ld	s3,88(sp)
    80005f20:	6a46                	ld	s4,80(sp)
    80005f22:	6aa6                	ld	s5,72(sp)
    80005f24:	6b06                	ld	s6,64(sp)
    80005f26:	7be2                	ld	s7,56(sp)
    80005f28:	7c42                	ld	s8,48(sp)
    80005f2a:	7ca2                	ld	s9,40(sp)
    80005f2c:	7d02                	ld	s10,32(sp)
    80005f2e:	6de2                	ld	s11,24(sp)
    80005f30:	6129                	addi	sp,sp,192
    80005f32:	8082                	ret
    release(&pr.lock);
    80005f34:	0001c517          	auipc	a0,0x1c
    80005f38:	05450513          	addi	a0,a0,84 # 80021f88 <pr>
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	3cc080e7          	jalr	972(ra) # 80006308 <release>
}
    80005f44:	bfc9                	j	80005f16 <printf+0x1b0>

0000000080005f46 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f46:	1101                	addi	sp,sp,-32
    80005f48:	ec06                	sd	ra,24(sp)
    80005f4a:	e822                	sd	s0,16(sp)
    80005f4c:	e426                	sd	s1,8(sp)
    80005f4e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f50:	0001c497          	auipc	s1,0x1c
    80005f54:	03848493          	addi	s1,s1,56 # 80021f88 <pr>
    80005f58:	00003597          	auipc	a1,0x3
    80005f5c:	90858593          	addi	a1,a1,-1784 # 80008860 <syscalls+0x460>
    80005f60:	8526                	mv	a0,s1
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	262080e7          	jalr	610(ra) # 800061c4 <initlock>
  pr.locking = 1;
    80005f6a:	4785                	li	a5,1
    80005f6c:	cc9c                	sw	a5,24(s1)
}
    80005f6e:	60e2                	ld	ra,24(sp)
    80005f70:	6442                	ld	s0,16(sp)
    80005f72:	64a2                	ld	s1,8(sp)
    80005f74:	6105                	addi	sp,sp,32
    80005f76:	8082                	ret

0000000080005f78 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f78:	1141                	addi	sp,sp,-16
    80005f7a:	e406                	sd	ra,8(sp)
    80005f7c:	e022                	sd	s0,0(sp)
    80005f7e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f80:	100007b7          	lui	a5,0x10000
    80005f84:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f88:	f8000713          	li	a4,-128
    80005f8c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f90:	470d                	li	a4,3
    80005f92:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f96:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f9a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f9e:	469d                	li	a3,7
    80005fa0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fa4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fa8:	00003597          	auipc	a1,0x3
    80005fac:	8d858593          	addi	a1,a1,-1832 # 80008880 <digits+0x18>
    80005fb0:	0001c517          	auipc	a0,0x1c
    80005fb4:	ff850513          	addi	a0,a0,-8 # 80021fa8 <uart_tx_lock>
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	20c080e7          	jalr	524(ra) # 800061c4 <initlock>
}
    80005fc0:	60a2                	ld	ra,8(sp)
    80005fc2:	6402                	ld	s0,0(sp)
    80005fc4:	0141                	addi	sp,sp,16
    80005fc6:	8082                	ret

0000000080005fc8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fc8:	1101                	addi	sp,sp,-32
    80005fca:	ec06                	sd	ra,24(sp)
    80005fcc:	e822                	sd	s0,16(sp)
    80005fce:	e426                	sd	s1,8(sp)
    80005fd0:	1000                	addi	s0,sp,32
    80005fd2:	84aa                	mv	s1,a0
  push_off();
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	234080e7          	jalr	564(ra) # 80006208 <push_off>

  if(panicked){
    80005fdc:	00003797          	auipc	a5,0x3
    80005fe0:	9787a783          	lw	a5,-1672(a5) # 80008954 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fe4:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fe8:	c391                	beqz	a5,80005fec <uartputc_sync+0x24>
    for(;;)
    80005fea:	a001                	j	80005fea <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fec:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005ff0:	0207f793          	andi	a5,a5,32
    80005ff4:	dfe5                	beqz	a5,80005fec <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005ff6:	0ff4f513          	zext.b	a0,s1
    80005ffa:	100007b7          	lui	a5,0x10000
    80005ffe:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006002:	00000097          	auipc	ra,0x0
    80006006:	2a6080e7          	jalr	678(ra) # 800062a8 <pop_off>
}
    8000600a:	60e2                	ld	ra,24(sp)
    8000600c:	6442                	ld	s0,16(sp)
    8000600e:	64a2                	ld	s1,8(sp)
    80006010:	6105                	addi	sp,sp,32
    80006012:	8082                	ret

0000000080006014 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006014:	00003797          	auipc	a5,0x3
    80006018:	9447b783          	ld	a5,-1724(a5) # 80008958 <uart_tx_r>
    8000601c:	00003717          	auipc	a4,0x3
    80006020:	94473703          	ld	a4,-1724(a4) # 80008960 <uart_tx_w>
    80006024:	06f70a63          	beq	a4,a5,80006098 <uartstart+0x84>
{
    80006028:	7139                	addi	sp,sp,-64
    8000602a:	fc06                	sd	ra,56(sp)
    8000602c:	f822                	sd	s0,48(sp)
    8000602e:	f426                	sd	s1,40(sp)
    80006030:	f04a                	sd	s2,32(sp)
    80006032:	ec4e                	sd	s3,24(sp)
    80006034:	e852                	sd	s4,16(sp)
    80006036:	e456                	sd	s5,8(sp)
    80006038:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000603a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000603e:	0001ca17          	auipc	s4,0x1c
    80006042:	f6aa0a13          	addi	s4,s4,-150 # 80021fa8 <uart_tx_lock>
    uart_tx_r += 1;
    80006046:	00003497          	auipc	s1,0x3
    8000604a:	91248493          	addi	s1,s1,-1774 # 80008958 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000604e:	00003997          	auipc	s3,0x3
    80006052:	91298993          	addi	s3,s3,-1774 # 80008960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006056:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000605a:	02077713          	andi	a4,a4,32
    8000605e:	c705                	beqz	a4,80006086 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006060:	01f7f713          	andi	a4,a5,31
    80006064:	9752                	add	a4,a4,s4
    80006066:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000606a:	0785                	addi	a5,a5,1
    8000606c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000606e:	8526                	mv	a0,s1
    80006070:	ffffb097          	auipc	ra,0xffffb
    80006074:	658080e7          	jalr	1624(ra) # 800016c8 <wakeup>
    
    WriteReg(THR, c);
    80006078:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000607c:	609c                	ld	a5,0(s1)
    8000607e:	0009b703          	ld	a4,0(s3)
    80006082:	fcf71ae3          	bne	a4,a5,80006056 <uartstart+0x42>
  }
}
    80006086:	70e2                	ld	ra,56(sp)
    80006088:	7442                	ld	s0,48(sp)
    8000608a:	74a2                	ld	s1,40(sp)
    8000608c:	7902                	ld	s2,32(sp)
    8000608e:	69e2                	ld	s3,24(sp)
    80006090:	6a42                	ld	s4,16(sp)
    80006092:	6aa2                	ld	s5,8(sp)
    80006094:	6121                	addi	sp,sp,64
    80006096:	8082                	ret
    80006098:	8082                	ret

000000008000609a <uartputc>:
{
    8000609a:	7179                	addi	sp,sp,-48
    8000609c:	f406                	sd	ra,40(sp)
    8000609e:	f022                	sd	s0,32(sp)
    800060a0:	ec26                	sd	s1,24(sp)
    800060a2:	e84a                	sd	s2,16(sp)
    800060a4:	e44e                	sd	s3,8(sp)
    800060a6:	e052                	sd	s4,0(sp)
    800060a8:	1800                	addi	s0,sp,48
    800060aa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060ac:	0001c517          	auipc	a0,0x1c
    800060b0:	efc50513          	addi	a0,a0,-260 # 80021fa8 <uart_tx_lock>
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	1a0080e7          	jalr	416(ra) # 80006254 <acquire>
  if(panicked){
    800060bc:	00003797          	auipc	a5,0x3
    800060c0:	8987a783          	lw	a5,-1896(a5) # 80008954 <panicked>
    800060c4:	e7c9                	bnez	a5,8000614e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060c6:	00003717          	auipc	a4,0x3
    800060ca:	89a73703          	ld	a4,-1894(a4) # 80008960 <uart_tx_w>
    800060ce:	00003797          	auipc	a5,0x3
    800060d2:	88a7b783          	ld	a5,-1910(a5) # 80008958 <uart_tx_r>
    800060d6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060da:	0001c997          	auipc	s3,0x1c
    800060de:	ece98993          	addi	s3,s3,-306 # 80021fa8 <uart_tx_lock>
    800060e2:	00003497          	auipc	s1,0x3
    800060e6:	87648493          	addi	s1,s1,-1930 # 80008958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060ea:	00003917          	auipc	s2,0x3
    800060ee:	87690913          	addi	s2,s2,-1930 # 80008960 <uart_tx_w>
    800060f2:	00e79f63          	bne	a5,a4,80006110 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060f6:	85ce                	mv	a1,s3
    800060f8:	8526                	mv	a0,s1
    800060fa:	ffffb097          	auipc	ra,0xffffb
    800060fe:	56a080e7          	jalr	1386(ra) # 80001664 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006102:	00093703          	ld	a4,0(s2)
    80006106:	609c                	ld	a5,0(s1)
    80006108:	02078793          	addi	a5,a5,32
    8000610c:	fee785e3          	beq	a5,a4,800060f6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006110:	0001c497          	auipc	s1,0x1c
    80006114:	e9848493          	addi	s1,s1,-360 # 80021fa8 <uart_tx_lock>
    80006118:	01f77793          	andi	a5,a4,31
    8000611c:	97a6                	add	a5,a5,s1
    8000611e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006122:	0705                	addi	a4,a4,1
    80006124:	00003797          	auipc	a5,0x3
    80006128:	82e7be23          	sd	a4,-1988(a5) # 80008960 <uart_tx_w>
  uartstart();
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	ee8080e7          	jalr	-280(ra) # 80006014 <uartstart>
  release(&uart_tx_lock);
    80006134:	8526                	mv	a0,s1
    80006136:	00000097          	auipc	ra,0x0
    8000613a:	1d2080e7          	jalr	466(ra) # 80006308 <release>
}
    8000613e:	70a2                	ld	ra,40(sp)
    80006140:	7402                	ld	s0,32(sp)
    80006142:	64e2                	ld	s1,24(sp)
    80006144:	6942                	ld	s2,16(sp)
    80006146:	69a2                	ld	s3,8(sp)
    80006148:	6a02                	ld	s4,0(sp)
    8000614a:	6145                	addi	sp,sp,48
    8000614c:	8082                	ret
    for(;;)
    8000614e:	a001                	j	8000614e <uartputc+0xb4>

0000000080006150 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006150:	1141                	addi	sp,sp,-16
    80006152:	e422                	sd	s0,8(sp)
    80006154:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006156:	100007b7          	lui	a5,0x10000
    8000615a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000615e:	8b85                	andi	a5,a5,1
    80006160:	cb81                	beqz	a5,80006170 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006162:	100007b7          	lui	a5,0x10000
    80006166:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000616a:	6422                	ld	s0,8(sp)
    8000616c:	0141                	addi	sp,sp,16
    8000616e:	8082                	ret
    return -1;
    80006170:	557d                	li	a0,-1
    80006172:	bfe5                	j	8000616a <uartgetc+0x1a>

0000000080006174 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006174:	1101                	addi	sp,sp,-32
    80006176:	ec06                	sd	ra,24(sp)
    80006178:	e822                	sd	s0,16(sp)
    8000617a:	e426                	sd	s1,8(sp)
    8000617c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000617e:	54fd                	li	s1,-1
    80006180:	a029                	j	8000618a <uartintr+0x16>
      break;
    consoleintr(c);
    80006182:	00000097          	auipc	ra,0x0
    80006186:	918080e7          	jalr	-1768(ra) # 80005a9a <consoleintr>
    int c = uartgetc();
    8000618a:	00000097          	auipc	ra,0x0
    8000618e:	fc6080e7          	jalr	-58(ra) # 80006150 <uartgetc>
    if(c == -1)
    80006192:	fe9518e3          	bne	a0,s1,80006182 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006196:	0001c497          	auipc	s1,0x1c
    8000619a:	e1248493          	addi	s1,s1,-494 # 80021fa8 <uart_tx_lock>
    8000619e:	8526                	mv	a0,s1
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	0b4080e7          	jalr	180(ra) # 80006254 <acquire>
  uartstart();
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	e6c080e7          	jalr	-404(ra) # 80006014 <uartstart>
  release(&uart_tx_lock);
    800061b0:	8526                	mv	a0,s1
    800061b2:	00000097          	auipc	ra,0x0
    800061b6:	156080e7          	jalr	342(ra) # 80006308 <release>
}
    800061ba:	60e2                	ld	ra,24(sp)
    800061bc:	6442                	ld	s0,16(sp)
    800061be:	64a2                	ld	s1,8(sp)
    800061c0:	6105                	addi	sp,sp,32
    800061c2:	8082                	ret

00000000800061c4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061c4:	1141                	addi	sp,sp,-16
    800061c6:	e422                	sd	s0,8(sp)
    800061c8:	0800                	addi	s0,sp,16
  lk->name = name;
    800061ca:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061cc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061d0:	00053823          	sd	zero,16(a0)
}
    800061d4:	6422                	ld	s0,8(sp)
    800061d6:	0141                	addi	sp,sp,16
    800061d8:	8082                	ret

00000000800061da <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061da:	411c                	lw	a5,0(a0)
    800061dc:	e399                	bnez	a5,800061e2 <holding+0x8>
    800061de:	4501                	li	a0,0
  return r;
}
    800061e0:	8082                	ret
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061ec:	6904                	ld	s1,16(a0)
    800061ee:	ffffb097          	auipc	ra,0xffffb
    800061f2:	d34080e7          	jalr	-716(ra) # 80000f22 <mycpu>
    800061f6:	40a48533          	sub	a0,s1,a0
    800061fa:	00153513          	seqz	a0,a0
}
    800061fe:	60e2                	ld	ra,24(sp)
    80006200:	6442                	ld	s0,16(sp)
    80006202:	64a2                	ld	s1,8(sp)
    80006204:	6105                	addi	sp,sp,32
    80006206:	8082                	ret

0000000080006208 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006208:	1101                	addi	sp,sp,-32
    8000620a:	ec06                	sd	ra,24(sp)
    8000620c:	e822                	sd	s0,16(sp)
    8000620e:	e426                	sd	s1,8(sp)
    80006210:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006212:	100024f3          	csrr	s1,sstatus
    80006216:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000621a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000621c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006220:	ffffb097          	auipc	ra,0xffffb
    80006224:	d02080e7          	jalr	-766(ra) # 80000f22 <mycpu>
    80006228:	5d3c                	lw	a5,120(a0)
    8000622a:	cf89                	beqz	a5,80006244 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000622c:	ffffb097          	auipc	ra,0xffffb
    80006230:	cf6080e7          	jalr	-778(ra) # 80000f22 <mycpu>
    80006234:	5d3c                	lw	a5,120(a0)
    80006236:	2785                	addiw	a5,a5,1
    80006238:	dd3c                	sw	a5,120(a0)
}
    8000623a:	60e2                	ld	ra,24(sp)
    8000623c:	6442                	ld	s0,16(sp)
    8000623e:	64a2                	ld	s1,8(sp)
    80006240:	6105                	addi	sp,sp,32
    80006242:	8082                	ret
    mycpu()->intena = old;
    80006244:	ffffb097          	auipc	ra,0xffffb
    80006248:	cde080e7          	jalr	-802(ra) # 80000f22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000624c:	8085                	srli	s1,s1,0x1
    8000624e:	8885                	andi	s1,s1,1
    80006250:	dd64                	sw	s1,124(a0)
    80006252:	bfe9                	j	8000622c <push_off+0x24>

0000000080006254 <acquire>:
{
    80006254:	1101                	addi	sp,sp,-32
    80006256:	ec06                	sd	ra,24(sp)
    80006258:	e822                	sd	s0,16(sp)
    8000625a:	e426                	sd	s1,8(sp)
    8000625c:	1000                	addi	s0,sp,32
    8000625e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006260:	00000097          	auipc	ra,0x0
    80006264:	fa8080e7          	jalr	-88(ra) # 80006208 <push_off>
  if(holding(lk))
    80006268:	8526                	mv	a0,s1
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	f70080e7          	jalr	-144(ra) # 800061da <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006272:	4705                	li	a4,1
  if(holding(lk))
    80006274:	e115                	bnez	a0,80006298 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006276:	87ba                	mv	a5,a4
    80006278:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000627c:	2781                	sext.w	a5,a5
    8000627e:	ffe5                	bnez	a5,80006276 <acquire+0x22>
  __sync_synchronize();
    80006280:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006284:	ffffb097          	auipc	ra,0xffffb
    80006288:	c9e080e7          	jalr	-866(ra) # 80000f22 <mycpu>
    8000628c:	e888                	sd	a0,16(s1)
}
    8000628e:	60e2                	ld	ra,24(sp)
    80006290:	6442                	ld	s0,16(sp)
    80006292:	64a2                	ld	s1,8(sp)
    80006294:	6105                	addi	sp,sp,32
    80006296:	8082                	ret
    panic("acquire");
    80006298:	00002517          	auipc	a0,0x2
    8000629c:	5f050513          	addi	a0,a0,1520 # 80008888 <digits+0x20>
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	a7c080e7          	jalr	-1412(ra) # 80005d1c <panic>

00000000800062a8 <pop_off>:

void
pop_off(void)
{
    800062a8:	1141                	addi	sp,sp,-16
    800062aa:	e406                	sd	ra,8(sp)
    800062ac:	e022                	sd	s0,0(sp)
    800062ae:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062b0:	ffffb097          	auipc	ra,0xffffb
    800062b4:	c72080e7          	jalr	-910(ra) # 80000f22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062b8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062bc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062be:	e78d                	bnez	a5,800062e8 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062c0:	5d3c                	lw	a5,120(a0)
    800062c2:	02f05b63          	blez	a5,800062f8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062c6:	37fd                	addiw	a5,a5,-1
    800062c8:	0007871b          	sext.w	a4,a5
    800062cc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062ce:	eb09                	bnez	a4,800062e0 <pop_off+0x38>
    800062d0:	5d7c                	lw	a5,124(a0)
    800062d2:	c799                	beqz	a5,800062e0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062d8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062dc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062e0:	60a2                	ld	ra,8(sp)
    800062e2:	6402                	ld	s0,0(sp)
    800062e4:	0141                	addi	sp,sp,16
    800062e6:	8082                	ret
    panic("pop_off - interruptible");
    800062e8:	00002517          	auipc	a0,0x2
    800062ec:	5a850513          	addi	a0,a0,1448 # 80008890 <digits+0x28>
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	a2c080e7          	jalr	-1492(ra) # 80005d1c <panic>
    panic("pop_off");
    800062f8:	00002517          	auipc	a0,0x2
    800062fc:	5b050513          	addi	a0,a0,1456 # 800088a8 <digits+0x40>
    80006300:	00000097          	auipc	ra,0x0
    80006304:	a1c080e7          	jalr	-1508(ra) # 80005d1c <panic>

0000000080006308 <release>:
{
    80006308:	1101                	addi	sp,sp,-32
    8000630a:	ec06                	sd	ra,24(sp)
    8000630c:	e822                	sd	s0,16(sp)
    8000630e:	e426                	sd	s1,8(sp)
    80006310:	1000                	addi	s0,sp,32
    80006312:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006314:	00000097          	auipc	ra,0x0
    80006318:	ec6080e7          	jalr	-314(ra) # 800061da <holding>
    8000631c:	c115                	beqz	a0,80006340 <release+0x38>
  lk->cpu = 0;
    8000631e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006322:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006326:	0f50000f          	fence	iorw,ow
    8000632a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000632e:	00000097          	auipc	ra,0x0
    80006332:	f7a080e7          	jalr	-134(ra) # 800062a8 <pop_off>
}
    80006336:	60e2                	ld	ra,24(sp)
    80006338:	6442                	ld	s0,16(sp)
    8000633a:	64a2                	ld	s1,8(sp)
    8000633c:	6105                	addi	sp,sp,32
    8000633e:	8082                	ret
    panic("release");
    80006340:	00002517          	auipc	a0,0x2
    80006344:	57050513          	addi	a0,a0,1392 # 800088b0 <digits+0x48>
    80006348:	00000097          	auipc	ra,0x0
    8000634c:	9d4080e7          	jalr	-1580(ra) # 80005d1c <panic>
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
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
