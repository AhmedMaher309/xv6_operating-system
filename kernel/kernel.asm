
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	94013103          	ld	sp,-1728(sp) # 80008940 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	133050ef          	jal	ra,80005948 <start>

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
    80000034:	fe078793          	addi	a5,a5,-32 # 80022010 <end>
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
    80000054:	95090913          	addi	s2,s2,-1712 # 800089a0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	2da080e7          	jalr	730(ra) # 80006334 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	37a080e7          	jalr	890(ra) # 800063e8 <release>
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
    8000008e:	d72080e7          	jalr	-654(ra) # 80005dfc <panic>

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
    800000f2:	8b250513          	addi	a0,a0,-1870 # 800089a0 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	1ae080e7          	jalr	430(ra) # 800062a4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	f0e50513          	addi	a0,a0,-242 # 80022010 <end>
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
    80000128:	87c48493          	addi	s1,s1,-1924 # 800089a0 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	206080e7          	jalr	518(ra) # 80006334 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	86450513          	addi	a0,a0,-1948 # 800089a0 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	2a2080e7          	jalr	674(ra) # 800063e8 <release>

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
    8000016c:	83850513          	addi	a0,a0,-1992 # 800089a0 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	278080e7          	jalr	632(ra) # 800063e8 <release>
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
    800001ee:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdcff1>
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
    80000334:	63070713          	addi	a4,a4,1584 # 80008960 <started>
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
    8000035a:	af0080e7          	jalr	-1296(ra) # 80005e46 <printf>
    kvminithart();    // turn on paging
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	0d8080e7          	jalr	216(ra) # 80000436 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000366:	00002097          	auipc	ra,0x2
    8000036a:	8f4080e7          	jalr	-1804(ra) # 80001c5a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000036e:	00005097          	auipc	ra,0x5
    80000372:	f92080e7          	jalr	-110(ra) # 80005300 <plicinithart>
  }

  scheduler();        
    80000376:	00001097          	auipc	ra,0x1
    8000037a:	13c080e7          	jalr	316(ra) # 800014b2 <scheduler>
    consoleinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	98e080e7          	jalr	-1650(ra) # 80005d0c <consoleinit>
    printfinit();
    80000386:	00006097          	auipc	ra,0x6
    8000038a:	ca0080e7          	jalr	-864(ra) # 80006026 <printfinit>
    printf("\n");
    8000038e:	00008517          	auipc	a0,0x8
    80000392:	cba50513          	addi	a0,a0,-838 # 80008048 <etext+0x48>
    80000396:	00006097          	auipc	ra,0x6
    8000039a:	ab0080e7          	jalr	-1360(ra) # 80005e46 <printf>
    printf("xv6 kernel is booting\n");
    8000039e:	00008517          	auipc	a0,0x8
    800003a2:	c8250513          	addi	a0,a0,-894 # 80008020 <etext+0x20>
    800003a6:	00006097          	auipc	ra,0x6
    800003aa:	aa0080e7          	jalr	-1376(ra) # 80005e46 <printf>
    printf("\n");
    800003ae:	00008517          	auipc	a0,0x8
    800003b2:	c9a50513          	addi	a0,a0,-870 # 80008048 <etext+0x48>
    800003b6:	00006097          	auipc	ra,0x6
    800003ba:	a90080e7          	jalr	-1392(ra) # 80005e46 <printf>
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
    800003f2:	efc080e7          	jalr	-260(ra) # 800052ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003f6:	00005097          	auipc	ra,0x5
    800003fa:	f0a080e7          	jalr	-246(ra) # 80005300 <plicinithart>
    binit();         // buffer cache
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	088080e7          	jalr	136(ra) # 80002486 <binit>
    iinit();         // inode table
    80000406:	00002097          	auipc	ra,0x2
    8000040a:	728080e7          	jalr	1832(ra) # 80002b2e <iinit>
    fileinit();      // file table
    8000040e:	00003097          	auipc	ra,0x3
    80000412:	6ce080e7          	jalr	1742(ra) # 80003adc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000416:	00005097          	auipc	ra,0x5
    8000041a:	ff2080e7          	jalr	-14(ra) # 80005408 <virtio_disk_init>
    userinit();      // first user process
    8000041e:	00001097          	auipc	ra,0x1
    80000422:	e76080e7          	jalr	-394(ra) # 80001294 <userinit>
    __sync_synchronize();
    80000426:	0ff0000f          	fence
    started = 1;
    8000042a:	4785                	li	a5,1
    8000042c:	00008717          	auipc	a4,0x8
    80000430:	52f72a23          	sw	a5,1332(a4) # 80008960 <started>
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
    80000444:	5307b783          	ld	a5,1328(a5) # 80008970 <kernel_pagetable>
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
    80000490:	970080e7          	jalr	-1680(ra) # 80005dfc <panic>
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
    800004be:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdcfe7>
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
    800005b2:	00006097          	auipc	ra,0x6
    800005b6:	84a080e7          	jalr	-1974(ra) # 80005dfc <panic>
      panic("mappages: remap");
    800005ba:	00008517          	auipc	a0,0x8
    800005be:	aae50513          	addi	a0,a0,-1362 # 80008068 <etext+0x68>
    800005c2:	00006097          	auipc	ra,0x6
    800005c6:	83a080e7          	jalr	-1990(ra) # 80005dfc <panic>
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
    80000612:	7ee080e7          	jalr	2030(ra) # 80005dfc <panic>

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
    80000700:	26a7ba23          	sd	a0,628(a5) # 80008970 <kernel_pagetable>
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
    8000075e:	6a2080e7          	jalr	1698(ra) # 80005dfc <panic>
      panic("uvmunmap: walk");
    80000762:	00008517          	auipc	a0,0x8
    80000766:	93650513          	addi	a0,a0,-1738 # 80008098 <etext+0x98>
    8000076a:	00005097          	auipc	ra,0x5
    8000076e:	692080e7          	jalr	1682(ra) # 80005dfc <panic>
      panic("uvmunmap: not mapped");
    80000772:	00008517          	auipc	a0,0x8
    80000776:	93650513          	addi	a0,a0,-1738 # 800080a8 <etext+0xa8>
    8000077a:	00005097          	auipc	ra,0x5
    8000077e:	682080e7          	jalr	1666(ra) # 80005dfc <panic>
      panic("uvmunmap: not a leaf");
    80000782:	00008517          	auipc	a0,0x8
    80000786:	93e50513          	addi	a0,a0,-1730 # 800080c0 <etext+0xc0>
    8000078a:	00005097          	auipc	ra,0x5
    8000078e:	672080e7          	jalr	1650(ra) # 80005dfc <panic>
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
    8000086c:	594080e7          	jalr	1428(ra) # 80005dfc <panic>

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
    800009b8:	448080e7          	jalr	1096(ra) # 80005dfc <panic>
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
    80000a96:	36a080e7          	jalr	874(ra) # 80005dfc <panic>
      panic("uvmcopy: page not present");
    80000a9a:	00007517          	auipc	a0,0x7
    80000a9e:	68e50513          	addi	a0,a0,1678 # 80008128 <etext+0x128>
    80000aa2:	00005097          	auipc	ra,0x5
    80000aa6:	35a080e7          	jalr	858(ra) # 80005dfc <panic>
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
    80000b10:	2f0080e7          	jalr	752(ra) # 80005dfc <panic>

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
    80000cb4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcff0>
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
    80000d00:	c6c7a783          	lw	a5,-916(a5) # 80008968 <printInside>
    80000d04:	c39d                	beqz	a5,80000d2a <vmprint+0x4c>
{
    80000d06:	4981                	li	s3,0
    printf("page table %p\n", (uint64)pagetable);
  for (int i = 0; i < 512; i++) {
    pte_t pte = pagetable[i];
    if (pte & PTE_V) {
      for (int j = 0; j <= printInside; j++) {
    80000d08:	00008a97          	auipc	s5,0x8
    80000d0c:	c60a8a93          	addi	s5,s5,-928 # 80008968 <printInside>
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
    80000d38:	112080e7          	jalr	274(ra) # 80005e46 <printf>
    80000d3c:	b7e9                	j	80000d06 <vmprint+0x28>
      printf("%d: pte %p pa %p\n", i, (uint64)pte, (uint64)PTE2PA(pte));
    80000d3e:	00a95693          	srli	a3,s2,0xa
    80000d42:	06b2                	slli	a3,a3,0xc
    80000d44:	864a                	mv	a2,s2
    80000d46:	85ce                	mv	a1,s3
    80000d48:	8566                	mv	a0,s9
    80000d4a:	00005097          	auipc	ra,0x5
    80000d4e:	0fc080e7          	jalr	252(ra) # 80005e46 <printf>
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
    80000d7c:	0ce080e7          	jalr	206(ra) # 80005e46 <printf>
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
    80000de6:	00e48493          	addi	s1,s1,14 # 80008df0 <proc>
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
    80000e00:	bf4a0a13          	addi	s4,s4,-1036 # 8000e9f0 <tickslock>
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
    80000e5c:	fa4080e7          	jalr	-92(ra) # 80005dfc <panic>

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
    80000e80:	b4450513          	addi	a0,a0,-1212 # 800089c0 <pid_lock>
    80000e84:	00005097          	auipc	ra,0x5
    80000e88:	420080e7          	jalr	1056(ra) # 800062a4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e8c:	00007597          	auipc	a1,0x7
    80000e90:	30c58593          	addi	a1,a1,780 # 80008198 <etext+0x198>
    80000e94:	00008517          	auipc	a0,0x8
    80000e98:	b4450513          	addi	a0,a0,-1212 # 800089d8 <wait_lock>
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	408080e7          	jalr	1032(ra) # 800062a4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ea4:	00008497          	auipc	s1,0x8
    80000ea8:	f4c48493          	addi	s1,s1,-180 # 80008df0 <proc>
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
    80000eca:	b2a98993          	addi	s3,s3,-1238 # 8000e9f0 <tickslock>
      initlock(&p->lock, "proc");
    80000ece:	85da                	mv	a1,s6
    80000ed0:	8526                	mv	a0,s1
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	3d2080e7          	jalr	978(ra) # 800062a4 <initlock>
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
    80000f32:	ac250513          	addi	a0,a0,-1342 # 800089f0 <cpus>
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
    80000f4c:	3a0080e7          	jalr	928(ra) # 800062e8 <push_off>
    80000f50:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f52:	2781                	sext.w	a5,a5
    80000f54:	079e                	slli	a5,a5,0x7
    80000f56:	00008717          	auipc	a4,0x8
    80000f5a:	a6a70713          	addi	a4,a4,-1430 # 800089c0 <pid_lock>
    80000f5e:	97ba                	add	a5,a5,a4
    80000f60:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	426080e7          	jalr	1062(ra) # 80006388 <pop_off>
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
    80000f8a:	462080e7          	jalr	1122(ra) # 800063e8 <release>

  if (first) {
    80000f8e:	00008797          	auipc	a5,0x8
    80000f92:	9627a783          	lw	a5,-1694(a5) # 800088f0 <first.1>
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
    80000fac:	9407a423          	sw	zero,-1720(a5) # 800088f0 <first.1>
    fsinit(ROOTDEV);
    80000fb0:	4505                	li	a0,1
    80000fb2:	00002097          	auipc	ra,0x2
    80000fb6:	afc080e7          	jalr	-1284(ra) # 80002aae <fsinit>
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
    80000fcc:	9f890913          	addi	s2,s2,-1544 # 800089c0 <pid_lock>
    80000fd0:	854a                	mv	a0,s2
    80000fd2:	00005097          	auipc	ra,0x5
    80000fd6:	362080e7          	jalr	866(ra) # 80006334 <acquire>
  pid = nextpid;
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	91a78793          	addi	a5,a5,-1766 # 800088f4 <nextpid>
    80000fe2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fe4:	0014871b          	addiw	a4,s1,1
    80000fe8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fea:	854a                	mv	a0,s2
    80000fec:	00005097          	auipc	ra,0x5
    80000ff0:	3fc080e7          	jalr	1020(ra) # 800063e8 <release>
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
    800011ac:	c4848493          	addi	s1,s1,-952 # 80008df0 <proc>
    800011b0:	0000e917          	auipc	s2,0xe
    800011b4:	84090913          	addi	s2,s2,-1984 # 8000e9f0 <tickslock>
    acquire(&p->lock);
    800011b8:	8526                	mv	a0,s1
    800011ba:	00005097          	auipc	ra,0x5
    800011be:	17a080e7          	jalr	378(ra) # 80006334 <acquire>
    if(p->state == UNUSED) {
    800011c2:	509c                	lw	a5,32(s1)
    800011c4:	cf81                	beqz	a5,800011dc <allocproc+0x40>
      release(&p->lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	00005097          	auipc	ra,0x5
    800011cc:	220080e7          	jalr	544(ra) # 800063e8 <release>
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
    8000125c:	190080e7          	jalr	400(ra) # 800063e8 <release>
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
    80001274:	178080e7          	jalr	376(ra) # 800063e8 <release>
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
    8000128c:	160080e7          	jalr	352(ra) # 800063e8 <release>
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
    800012ac:	6ca7b823          	sd	a0,1744(a5) # 80008978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012b0:	03400613          	li	a2,52
    800012b4:	00007597          	auipc	a1,0x7
    800012b8:	64c58593          	addi	a1,a1,1612 # 80008900 <initcode>
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
    800012f6:	1e6080e7          	jalr	486(ra) # 800034d8 <namei>
    800012fa:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800012fe:	478d                	li	a5,3
    80001300:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001302:	8526                	mv	a0,s1
    80001304:	00005097          	auipc	ra,0x5
    80001308:	0e4080e7          	jalr	228(ra) # 800063e8 <release>
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
    8000140e:	fde080e7          	jalr	-34(ra) # 800063e8 <release>
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
    80001426:	74c080e7          	jalr	1868(ra) # 80003b6e <filedup>
    8000142a:	00a93023          	sd	a0,0(s2)
    8000142e:	b7e5                	j	80001416 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001430:	158ab503          	ld	a0,344(s5)
    80001434:	00002097          	auipc	ra,0x2
    80001438:	8ba080e7          	jalr	-1862(ra) # 80002cee <idup>
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
    8000145c:	f90080e7          	jalr	-112(ra) # 800063e8 <release>
  acquire(&wait_lock);
    80001460:	00007497          	auipc	s1,0x7
    80001464:	57848493          	addi	s1,s1,1400 # 800089d8 <wait_lock>
    80001468:	8526                	mv	a0,s1
    8000146a:	00005097          	auipc	ra,0x5
    8000146e:	eca080e7          	jalr	-310(ra) # 80006334 <acquire>
  np->parent = p;
    80001472:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001476:	8526                	mv	a0,s1
    80001478:	00005097          	auipc	ra,0x5
    8000147c:	f70080e7          	jalr	-144(ra) # 800063e8 <release>
  acquire(&np->lock);
    80001480:	8552                	mv	a0,s4
    80001482:	00005097          	auipc	ra,0x5
    80001486:	eb2080e7          	jalr	-334(ra) # 80006334 <acquire>
  np->state = RUNNABLE;
    8000148a:	478d                	li	a5,3
    8000148c:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001490:	8552                	mv	a0,s4
    80001492:	00005097          	auipc	ra,0x5
    80001496:	f56080e7          	jalr	-170(ra) # 800063e8 <release>
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
    800014d2:	4f270713          	addi	a4,a4,1266 # 800089c0 <pid_lock>
    800014d6:	9756                	add	a4,a4,s5
    800014d8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014dc:	00007717          	auipc	a4,0x7
    800014e0:	51c70713          	addi	a4,a4,1308 # 800089f8 <cpus+0x8>
    800014e4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800014e6:	498d                	li	s3,3
        p->state = RUNNING;
    800014e8:	4b11                	li	s6,4
        c->proc = p;
    800014ea:	079e                	slli	a5,a5,0x7
    800014ec:	00007a17          	auipc	s4,0x7
    800014f0:	4d4a0a13          	addi	s4,s4,1236 # 800089c0 <pid_lock>
    800014f4:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800014f6:	0000d917          	auipc	s2,0xd
    800014fa:	4fa90913          	addi	s2,s2,1274 # 8000e9f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001502:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001506:	10079073          	csrw	sstatus,a5
    8000150a:	00008497          	auipc	s1,0x8
    8000150e:	8e648493          	addi	s1,s1,-1818 # 80008df0 <proc>
    80001512:	a811                	j	80001526 <scheduler+0x74>
      release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	ed2080e7          	jalr	-302(ra) # 800063e8 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000151e:	17048493          	addi	s1,s1,368
    80001522:	fd248ee3          	beq	s1,s2,800014fe <scheduler+0x4c>
      acquire(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	e0c080e7          	jalr	-500(ra) # 80006334 <acquire>
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
    8000156e:	d50080e7          	jalr	-688(ra) # 800062ba <holding>
    80001572:	c93d                	beqz	a0,800015e8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001574:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001576:	2781                	sext.w	a5,a5
    80001578:	079e                	slli	a5,a5,0x7
    8000157a:	00007717          	auipc	a4,0x7
    8000157e:	44670713          	addi	a4,a4,1094 # 800089c0 <pid_lock>
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
    800015a4:	42090913          	addi	s2,s2,1056 # 800089c0 <pid_lock>
    800015a8:	2781                	sext.w	a5,a5
    800015aa:	079e                	slli	a5,a5,0x7
    800015ac:	97ca                	add	a5,a5,s2
    800015ae:	0ac7a983          	lw	s3,172(a5)
    800015b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015b4:	2781                	sext.w	a5,a5
    800015b6:	079e                	slli	a5,a5,0x7
    800015b8:	00007597          	auipc	a1,0x7
    800015bc:	44058593          	addi	a1,a1,1088 # 800089f8 <cpus+0x8>
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
    800015f0:	00005097          	auipc	ra,0x5
    800015f4:	80c080e7          	jalr	-2036(ra) # 80005dfc <panic>
    panic("sched locks");
    800015f8:	00007517          	auipc	a0,0x7
    800015fc:	be050513          	addi	a0,a0,-1056 # 800081d8 <etext+0x1d8>
    80001600:	00004097          	auipc	ra,0x4
    80001604:	7fc080e7          	jalr	2044(ra) # 80005dfc <panic>
    panic("sched running");
    80001608:	00007517          	auipc	a0,0x7
    8000160c:	be050513          	addi	a0,a0,-1056 # 800081e8 <etext+0x1e8>
    80001610:	00004097          	auipc	ra,0x4
    80001614:	7ec080e7          	jalr	2028(ra) # 80005dfc <panic>
    panic("sched interruptible");
    80001618:	00007517          	auipc	a0,0x7
    8000161c:	be050513          	addi	a0,a0,-1056 # 800081f8 <etext+0x1f8>
    80001620:	00004097          	auipc	ra,0x4
    80001624:	7dc080e7          	jalr	2012(ra) # 80005dfc <panic>

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
    80001640:	cf8080e7          	jalr	-776(ra) # 80006334 <acquire>
  p->state = RUNNABLE;
    80001644:	478d                	li	a5,3
    80001646:	d09c                	sw	a5,32(s1)
  sched();
    80001648:	00000097          	auipc	ra,0x0
    8000164c:	f0a080e7          	jalr	-246(ra) # 80001552 <sched>
  release(&p->lock);
    80001650:	8526                	mv	a0,s1
    80001652:	00005097          	auipc	ra,0x5
    80001656:	d96080e7          	jalr	-618(ra) # 800063e8 <release>
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
    80001684:	cb4080e7          	jalr	-844(ra) # 80006334 <acquire>
  release(lk);
    80001688:	854a                	mv	a0,s2
    8000168a:	00005097          	auipc	ra,0x5
    8000168e:	d5e080e7          	jalr	-674(ra) # 800063e8 <release>

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
    800016ac:	d40080e7          	jalr	-704(ra) # 800063e8 <release>
  acquire(lk);
    800016b0:	854a                	mv	a0,s2
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	c82080e7          	jalr	-894(ra) # 80006334 <acquire>
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
    800016e0:	71448493          	addi	s1,s1,1812 # 80008df0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016e4:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016e6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016e8:	0000d917          	auipc	s2,0xd
    800016ec:	30890913          	addi	s2,s2,776 # 8000e9f0 <tickslock>
    800016f0:	a811                	j	80001704 <wakeup+0x3c>
      }
      release(&p->lock);
    800016f2:	8526                	mv	a0,s1
    800016f4:	00005097          	auipc	ra,0x5
    800016f8:	cf4080e7          	jalr	-780(ra) # 800063e8 <release>
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
    80001716:	c22080e7          	jalr	-990(ra) # 80006334 <acquire>
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
    80001754:	6a048493          	addi	s1,s1,1696 # 80008df0 <proc>
      pp->parent = initproc;
    80001758:	00007a17          	auipc	s4,0x7
    8000175c:	220a0a13          	addi	s4,s4,544 # 80008978 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001760:	0000d997          	auipc	s3,0xd
    80001764:	29098993          	addi	s3,s3,656 # 8000e9f0 <tickslock>
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
    800017b8:	1c47b783          	ld	a5,452(a5) # 80008978 <initproc>
    800017bc:	0d850493          	addi	s1,a0,216
    800017c0:	15850913          	addi	s2,a0,344
    800017c4:	02a79363          	bne	a5,a0,800017ea <exit+0x52>
    panic("init exiting");
    800017c8:	00007517          	auipc	a0,0x7
    800017cc:	a4850513          	addi	a0,a0,-1464 # 80008210 <etext+0x210>
    800017d0:	00004097          	auipc	ra,0x4
    800017d4:	62c080e7          	jalr	1580(ra) # 80005dfc <panic>
      fileclose(f);
    800017d8:	00002097          	auipc	ra,0x2
    800017dc:	3e8080e7          	jalr	1000(ra) # 80003bc0 <fileclose>
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
    800017f4:	f08080e7          	jalr	-248(ra) # 800036f8 <begin_op>
  iput(p->cwd);
    800017f8:	1589b503          	ld	a0,344(s3)
    800017fc:	00001097          	auipc	ra,0x1
    80001800:	6ea080e7          	jalr	1770(ra) # 80002ee6 <iput>
  end_op();
    80001804:	00002097          	auipc	ra,0x2
    80001808:	f72080e7          	jalr	-142(ra) # 80003776 <end_op>
  p->cwd = 0;
    8000180c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001810:	00007497          	auipc	s1,0x7
    80001814:	1c848493          	addi	s1,s1,456 # 800089d8 <wait_lock>
    80001818:	8526                	mv	a0,s1
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	b1a080e7          	jalr	-1254(ra) # 80006334 <acquire>
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
    8000183e:	afa080e7          	jalr	-1286(ra) # 80006334 <acquire>
  p->xstate = status;
    80001842:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80001846:	4795                	li	a5,5
    80001848:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    8000184c:	8526                	mv	a0,s1
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	b9a080e7          	jalr	-1126(ra) # 800063e8 <release>
  sched();
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	cfc080e7          	jalr	-772(ra) # 80001552 <sched>
  panic("zombie exit");
    8000185e:	00007517          	auipc	a0,0x7
    80001862:	9c250513          	addi	a0,a0,-1598 # 80008220 <etext+0x220>
    80001866:	00004097          	auipc	ra,0x4
    8000186a:	596080e7          	jalr	1430(ra) # 80005dfc <panic>

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
    80001882:	57248493          	addi	s1,s1,1394 # 80008df0 <proc>
    80001886:	0000d997          	auipc	s3,0xd
    8000188a:	16a98993          	addi	s3,s3,362 # 8000e9f0 <tickslock>
    acquire(&p->lock);
    8000188e:	8526                	mv	a0,s1
    80001890:	00005097          	auipc	ra,0x5
    80001894:	aa4080e7          	jalr	-1372(ra) # 80006334 <acquire>
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
    800018a4:	b48080e7          	jalr	-1208(ra) # 800063e8 <release>
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
    800018c6:	b26080e7          	jalr	-1242(ra) # 800063e8 <release>
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
    800018f0:	a48080e7          	jalr	-1464(ra) # 80006334 <acquire>
  p->killed = 1;
    800018f4:	4785                	li	a5,1
    800018f6:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	aee080e7          	jalr	-1298(ra) # 800063e8 <release>
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
    8000191e:	a1a080e7          	jalr	-1510(ra) # 80006334 <acquire>
  k = p->killed;
    80001922:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    80001926:	8526                	mv	a0,s1
    80001928:	00005097          	auipc	ra,0x5
    8000192c:	ac0080e7          	jalr	-1344(ra) # 800063e8 <release>
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
    80001966:	07650513          	addi	a0,a0,118 # 800089d8 <wait_lock>
    8000196a:	00005097          	auipc	ra,0x5
    8000196e:	9ca080e7          	jalr	-1590(ra) # 80006334 <acquire>
    havekids = 0;
    80001972:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001974:	4a15                	li	s4,5
        havekids = 1;
    80001976:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001978:	0000d997          	auipc	s3,0xd
    8000197c:	07898993          	addi	s3,s3,120 # 8000e9f0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001980:	00007c17          	auipc	s8,0x7
    80001984:	058c0c13          	addi	s8,s8,88 # 800089d8 <wait_lock>
    havekids = 0;
    80001988:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000198a:	00007497          	auipc	s1,0x7
    8000198e:	46648493          	addi	s1,s1,1126 # 80008df0 <proc>
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
    800019c4:	a28080e7          	jalr	-1496(ra) # 800063e8 <release>
          release(&wait_lock);
    800019c8:	00007517          	auipc	a0,0x7
    800019cc:	01050513          	addi	a0,a0,16 # 800089d8 <wait_lock>
    800019d0:	00005097          	auipc	ra,0x5
    800019d4:	a18080e7          	jalr	-1512(ra) # 800063e8 <release>
          return pid;
    800019d8:	a0b5                	j	80001a44 <wait+0x106>
            release(&pp->lock);
    800019da:	8526                	mv	a0,s1
    800019dc:	00005097          	auipc	ra,0x5
    800019e0:	a0c080e7          	jalr	-1524(ra) # 800063e8 <release>
            release(&wait_lock);
    800019e4:	00007517          	auipc	a0,0x7
    800019e8:	ff450513          	addi	a0,a0,-12 # 800089d8 <wait_lock>
    800019ec:	00005097          	auipc	ra,0x5
    800019f0:	9fc080e7          	jalr	-1540(ra) # 800063e8 <release>
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
    80001a0c:	92c080e7          	jalr	-1748(ra) # 80006334 <acquire>
        if(pp->state == ZOMBIE){
    80001a10:	509c                	lw	a5,32(s1)
    80001a12:	f94781e3          	beq	a5,s4,80001994 <wait+0x56>
        release(&pp->lock);
    80001a16:	8526                	mv	a0,s1
    80001a18:	00005097          	auipc	ra,0x5
    80001a1c:	9d0080e7          	jalr	-1584(ra) # 800063e8 <release>
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
    80001a36:	fa650513          	addi	a0,a0,-90 # 800089d8 <wait_lock>
    80001a3a:	00005097          	auipc	ra,0x5
    80001a3e:	9ae080e7          	jalr	-1618(ra) # 800063e8 <release>
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
    80001b3a:	310080e7          	jalr	784(ra) # 80005e46 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b3e:	00007497          	auipc	s1,0x7
    80001b42:	41248493          	addi	s1,s1,1042 # 80008f50 <proc+0x160>
    80001b46:	0000d917          	auipc	s2,0xd
    80001b4a:	00a90913          	addi	s2,s2,10 # 8000eb50 <bcache+0x148>
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
    80001b7c:	2ce080e7          	jalr	718(ra) # 80005e46 <printf>
    printf("\n");
    80001b80:	8552                	mv	a0,s4
    80001b82:	00004097          	auipc	ra,0x4
    80001b86:	2c4080e7          	jalr	708(ra) # 80005e46 <printf>
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
    80001c46:	dae50513          	addi	a0,a0,-594 # 8000e9f0 <tickslock>
    80001c4a:	00004097          	auipc	ra,0x4
    80001c4e:	65a080e7          	jalr	1626(ra) # 800062a4 <initlock>
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
    80001c64:	5d078793          	addi	a5,a5,1488 # 80005230 <kernelvec>
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
    80001d16:	cde48493          	addi	s1,s1,-802 # 8000e9f0 <tickslock>
    80001d1a:	8526                	mv	a0,s1
    80001d1c:	00004097          	auipc	ra,0x4
    80001d20:	618080e7          	jalr	1560(ra) # 80006334 <acquire>
  ticks++;
    80001d24:	00007517          	auipc	a0,0x7
    80001d28:	c5c50513          	addi	a0,a0,-932 # 80008980 <ticks>
    80001d2c:	411c                	lw	a5,0(a0)
    80001d2e:	2785                	addiw	a5,a5,1
    80001d30:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	996080e7          	jalr	-1642(ra) # 800016c8 <wakeup>
  release(&tickslock);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	6ac080e7          	jalr	1708(ra) # 800063e8 <release>
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
    80001d84:	5b8080e7          	jalr	1464(ra) # 80005338 <plic_claim>
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
    80001da8:	0a2080e7          	jalr	162(ra) # 80005e46 <printf>
      plic_complete(irq);
    80001dac:	8526                	mv	a0,s1
    80001dae:	00003097          	auipc	ra,0x3
    80001db2:	5ae080e7          	jalr	1454(ra) # 8000535c <plic_complete>
    return 1;
    80001db6:	4505                	li	a0,1
    80001db8:	bf55                	j	80001d6c <devintr+0x1e>
      uartintr();
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	49a080e7          	jalr	1178(ra) # 80006254 <uartintr>
    80001dc2:	b7ed                	j	80001dac <devintr+0x5e>
      virtio_disk_intr();
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	a60080e7          	jalr	-1440(ra) # 80005824 <virtio_disk_intr>
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
    80001e0a:	42a78793          	addi	a5,a5,1066 # 80005230 <kernelvec>
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
    80001e54:	fac080e7          	jalr	-84(ra) # 80005dfc <panic>
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
    80001ece:	f7c080e7          	jalr	-132(ra) # 80005e46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ed2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ed6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001eda:	00006517          	auipc	a0,0x6
    80001ede:	44650513          	addi	a0,a0,1094 # 80008320 <states.0+0xa8>
    80001ee2:	00004097          	auipc	ra,0x4
    80001ee6:	f64080e7          	jalr	-156(ra) # 80005e46 <printf>
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
    80001f5a:	ea6080e7          	jalr	-346(ra) # 80005dfc <panic>
    panic("kerneltrap: interrupts enabled");
    80001f5e:	00006517          	auipc	a0,0x6
    80001f62:	40a50513          	addi	a0,a0,1034 # 80008368 <states.0+0xf0>
    80001f66:	00004097          	auipc	ra,0x4
    80001f6a:	e96080e7          	jalr	-362(ra) # 80005dfc <panic>
    printf("scause %p\n", scause);
    80001f6e:	85ce                	mv	a1,s3
    80001f70:	00006517          	auipc	a0,0x6
    80001f74:	41850513          	addi	a0,a0,1048 # 80008388 <states.0+0x110>
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	ece080e7          	jalr	-306(ra) # 80005e46 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f84:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f88:	00006517          	auipc	a0,0x6
    80001f8c:	41050513          	addi	a0,a0,1040 # 80008398 <states.0+0x120>
    80001f90:	00004097          	auipc	ra,0x4
    80001f94:	eb6080e7          	jalr	-330(ra) # 80005e46 <printf>
    panic("kerneltrap");
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	41850513          	addi	a0,a0,1048 # 800083b0 <states.0+0x138>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	e5c080e7          	jalr	-420(ra) # 80005dfc <panic>
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
    80002030:	dd0080e7          	jalr	-560(ra) # 80005dfc <panic>

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
    800021a0:	caa080e7          	jalr	-854(ra) # 80005e46 <printf>
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
    800022a0:	75450513          	addi	a0,a0,1876 # 8000e9f0 <tickslock>
    800022a4:	00004097          	auipc	ra,0x4
    800022a8:	090080e7          	jalr	144(ra) # 80006334 <acquire>
  ticks0 = ticks;
    800022ac:	00006917          	auipc	s2,0x6
    800022b0:	6d492903          	lw	s2,1748(s2) # 80008980 <ticks>
  while(ticks - ticks0 < n){
    800022b4:	fcc42783          	lw	a5,-52(s0)
    800022b8:	cf9d                	beqz	a5,800022f6 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022ba:	0000c997          	auipc	s3,0xc
    800022be:	73698993          	addi	s3,s3,1846 # 8000e9f0 <tickslock>
    800022c2:	00006497          	auipc	s1,0x6
    800022c6:	6be48493          	addi	s1,s1,1726 # 80008980 <ticks>
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
    800022fa:	6fa50513          	addi	a0,a0,1786 # 8000e9f0 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	0ea080e7          	jalr	234(ra) # 800063e8 <release>
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
    8000231a:	6da50513          	addi	a0,a0,1754 # 8000e9f0 <tickslock>
    8000231e:	00004097          	auipc	ra,0x4
    80002322:	0ca080e7          	jalr	202(ra) # 800063e8 <release>
      return -1;
    80002326:	557d                	li	a0,-1
    80002328:	b7c5                	j	80002308 <sys_sleep+0x88>

000000008000232a <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    8000232a:	715d                	addi	sp,sp,-80
    8000232c:	e486                	sd	ra,72(sp)
    8000232e:	e0a2                	sd	s0,64(sp)
    80002330:	fc26                	sd	s1,56(sp)
    80002332:	f84a                	sd	s2,48(sp)
    80002334:	f44e                	sd	s3,40(sp)
    80002336:	f052                	sd	s4,32(sp)
    80002338:	0880                	addi	s0,sp,80
  // lab pgtbl: your code here.
  uint64 va;
  int pagenum;
  uint64 abitsaddr;
  argaddr(0, &va);
    8000233a:	fc840593          	addi	a1,s0,-56
    8000233e:	4501                	li	a0,0
    80002340:	00000097          	auipc	ra,0x0
    80002344:	db2080e7          	jalr	-590(ra) # 800020f2 <argaddr>
  argint(1, &pagenum);
    80002348:	fc440593          	addi	a1,s0,-60
    8000234c:	4505                	li	a0,1
    8000234e:	00000097          	auipc	ra,0x0
    80002352:	d84080e7          	jalr	-636(ra) # 800020d2 <argint>
  argaddr(2, &abitsaddr);
    80002356:	fb840593          	addi	a1,s0,-72
    8000235a:	4509                	li	a0,2
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	d96080e7          	jalr	-618(ra) # 800020f2 <argaddr>

  uint64 maskbits = 0;
    80002364:	fa043823          	sd	zero,-80(s0)
  struct proc *proc = myproc();
    80002368:	fffff097          	auipc	ra,0xfffff
    8000236c:	bd6080e7          	jalr	-1066(ra) # 80000f3e <myproc>
    80002370:	892a                	mv	s2,a0
  for (int i = 0; i < pagenum; i++) {
    80002372:	fc442783          	lw	a5,-60(s0)
    80002376:	06f05463          	blez	a5,800023de <sys_pgaccess+0xb4>
    8000237a:	4481                	li	s1,0
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    if (pte == 0)
      panic("page not exist.");
    if (PTE_FLAGS(*pte) & PTE_A) {
      maskbits = maskbits | (1L << i);
    8000237c:	4985                	li	s3,1
    8000237e:	a025                	j	800023a6 <sys_pgaccess+0x7c>
      panic("page not exist.");
    80002380:	00006517          	auipc	a0,0x6
    80002384:	17850513          	addi	a0,a0,376 # 800084f8 <syscalls+0xf8>
    80002388:	00004097          	auipc	ra,0x4
    8000238c:	a74080e7          	jalr	-1420(ra) # 80005dfc <panic>
    }
    // clear PTE_A, set PTE_A bits zero
    *pte = ((*pte&PTE_A) ^ *pte) ^ 0 ;
    80002390:	611c                	ld	a5,0(a0)
    80002392:	fbf7f793          	andi	a5,a5,-65
    80002396:	e11c                	sd	a5,0(a0)
  for (int i = 0; i < pagenum; i++) {
    80002398:	0485                	addi	s1,s1,1
    8000239a:	fc442703          	lw	a4,-60(s0)
    8000239e:	0004879b          	sext.w	a5,s1
    800023a2:	02e7de63          	bge	a5,a4,800023de <sys_pgaccess+0xb4>
    800023a6:	00048a1b          	sext.w	s4,s1
    pte_t *pte = walk(proc->pagetable, va+i*PGSIZE, 0);
    800023aa:	00c49593          	slli	a1,s1,0xc
    800023ae:	4601                	li	a2,0
    800023b0:	fc843783          	ld	a5,-56(s0)
    800023b4:	95be                	add	a1,a1,a5
    800023b6:	05893503          	ld	a0,88(s2)
    800023ba:	ffffe097          	auipc	ra,0xffffe
    800023be:	0a4080e7          	jalr	164(ra) # 8000045e <walk>
    if (pte == 0)
    800023c2:	dd5d                	beqz	a0,80002380 <sys_pgaccess+0x56>
    if (PTE_FLAGS(*pte) & PTE_A) {
    800023c4:	611c                	ld	a5,0(a0)
    800023c6:	0407f793          	andi	a5,a5,64
    800023ca:	d3f9                	beqz	a5,80002390 <sys_pgaccess+0x66>
      maskbits = maskbits | (1L << i);
    800023cc:	01499a33          	sll	s4,s3,s4
    800023d0:	fb043783          	ld	a5,-80(s0)
    800023d4:	0147e7b3          	or	a5,a5,s4
    800023d8:	faf43823          	sd	a5,-80(s0)
    800023dc:	bf55                	j	80002390 <sys_pgaccess+0x66>
  }
  if (copyout(proc->pagetable, abitsaddr, (char *)&maskbits, sizeof(maskbits)) < 0)
    800023de:	46a1                	li	a3,8
    800023e0:	fb040613          	addi	a2,s0,-80
    800023e4:	fb843583          	ld	a1,-72(s0)
    800023e8:	05893503          	ld	a0,88(s2)
    800023ec:	ffffe097          	auipc	ra,0xffffe
    800023f0:	728080e7          	jalr	1832(ra) # 80000b14 <copyout>
    800023f4:	00054b63          	bltz	a0,8000240a <sys_pgaccess+0xe0>
    panic("sys_pgacess copyout error");

  return 0;
}
    800023f8:	4501                	li	a0,0
    800023fa:	60a6                	ld	ra,72(sp)
    800023fc:	6406                	ld	s0,64(sp)
    800023fe:	74e2                	ld	s1,56(sp)
    80002400:	7942                	ld	s2,48(sp)
    80002402:	79a2                	ld	s3,40(sp)
    80002404:	7a02                	ld	s4,32(sp)
    80002406:	6161                	addi	sp,sp,80
    80002408:	8082                	ret
    panic("sys_pgacess copyout error");
    8000240a:	00006517          	auipc	a0,0x6
    8000240e:	0fe50513          	addi	a0,a0,254 # 80008508 <syscalls+0x108>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	9ea080e7          	jalr	-1558(ra) # 80005dfc <panic>

000000008000241a <sys_kill>:
#endif

uint64
sys_kill(void)
{
    8000241a:	1101                	addi	sp,sp,-32
    8000241c:	ec06                	sd	ra,24(sp)
    8000241e:	e822                	sd	s0,16(sp)
    80002420:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002422:	fec40593          	addi	a1,s0,-20
    80002426:	4501                	li	a0,0
    80002428:	00000097          	auipc	ra,0x0
    8000242c:	caa080e7          	jalr	-854(ra) # 800020d2 <argint>
  return kill(pid);
    80002430:	fec42503          	lw	a0,-20(s0)
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	43a080e7          	jalr	1082(ra) # 8000186e <kill>
}
    8000243c:	60e2                	ld	ra,24(sp)
    8000243e:	6442                	ld	s0,16(sp)
    80002440:	6105                	addi	sp,sp,32
    80002442:	8082                	ret

0000000080002444 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	e426                	sd	s1,8(sp)
    8000244c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000244e:	0000c517          	auipc	a0,0xc
    80002452:	5a250513          	addi	a0,a0,1442 # 8000e9f0 <tickslock>
    80002456:	00004097          	auipc	ra,0x4
    8000245a:	ede080e7          	jalr	-290(ra) # 80006334 <acquire>
  xticks = ticks;
    8000245e:	00006497          	auipc	s1,0x6
    80002462:	5224a483          	lw	s1,1314(s1) # 80008980 <ticks>
  release(&tickslock);
    80002466:	0000c517          	auipc	a0,0xc
    8000246a:	58a50513          	addi	a0,a0,1418 # 8000e9f0 <tickslock>
    8000246e:	00004097          	auipc	ra,0x4
    80002472:	f7a080e7          	jalr	-134(ra) # 800063e8 <release>
  return xticks;
}
    80002476:	02049513          	slli	a0,s1,0x20
    8000247a:	9101                	srli	a0,a0,0x20
    8000247c:	60e2                	ld	ra,24(sp)
    8000247e:	6442                	ld	s0,16(sp)
    80002480:	64a2                	ld	s1,8(sp)
    80002482:	6105                	addi	sp,sp,32
    80002484:	8082                	ret

0000000080002486 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002486:	7179                	addi	sp,sp,-48
    80002488:	f406                	sd	ra,40(sp)
    8000248a:	f022                	sd	s0,32(sp)
    8000248c:	ec26                	sd	s1,24(sp)
    8000248e:	e84a                	sd	s2,16(sp)
    80002490:	e44e                	sd	s3,8(sp)
    80002492:	e052                	sd	s4,0(sp)
    80002494:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002496:	00006597          	auipc	a1,0x6
    8000249a:	09258593          	addi	a1,a1,146 # 80008528 <syscalls+0x128>
    8000249e:	0000c517          	auipc	a0,0xc
    800024a2:	56a50513          	addi	a0,a0,1386 # 8000ea08 <bcache>
    800024a6:	00004097          	auipc	ra,0x4
    800024aa:	dfe080e7          	jalr	-514(ra) # 800062a4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024ae:	00014797          	auipc	a5,0x14
    800024b2:	55a78793          	addi	a5,a5,1370 # 80016a08 <bcache+0x8000>
    800024b6:	00014717          	auipc	a4,0x14
    800024ba:	7ba70713          	addi	a4,a4,1978 # 80016c70 <bcache+0x8268>
    800024be:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024c2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024c6:	0000c497          	auipc	s1,0xc
    800024ca:	55a48493          	addi	s1,s1,1370 # 8000ea20 <bcache+0x18>
    b->next = bcache.head.next;
    800024ce:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024d0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024d2:	00006a17          	auipc	s4,0x6
    800024d6:	05ea0a13          	addi	s4,s4,94 # 80008530 <syscalls+0x130>
    b->next = bcache.head.next;
    800024da:	2b893783          	ld	a5,696(s2)
    800024de:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800024e0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800024e4:	85d2                	mv	a1,s4
    800024e6:	01048513          	addi	a0,s1,16
    800024ea:	00001097          	auipc	ra,0x1
    800024ee:	4c8080e7          	jalr	1224(ra) # 800039b2 <initsleeplock>
    bcache.head.next->prev = b;
    800024f2:	2b893783          	ld	a5,696(s2)
    800024f6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800024f8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024fc:	45848493          	addi	s1,s1,1112
    80002500:	fd349de3          	bne	s1,s3,800024da <binit+0x54>
  }
}
    80002504:	70a2                	ld	ra,40(sp)
    80002506:	7402                	ld	s0,32(sp)
    80002508:	64e2                	ld	s1,24(sp)
    8000250a:	6942                	ld	s2,16(sp)
    8000250c:	69a2                	ld	s3,8(sp)
    8000250e:	6a02                	ld	s4,0(sp)
    80002510:	6145                	addi	sp,sp,48
    80002512:	8082                	ret

0000000080002514 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002514:	7179                	addi	sp,sp,-48
    80002516:	f406                	sd	ra,40(sp)
    80002518:	f022                	sd	s0,32(sp)
    8000251a:	ec26                	sd	s1,24(sp)
    8000251c:	e84a                	sd	s2,16(sp)
    8000251e:	e44e                	sd	s3,8(sp)
    80002520:	1800                	addi	s0,sp,48
    80002522:	892a                	mv	s2,a0
    80002524:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002526:	0000c517          	auipc	a0,0xc
    8000252a:	4e250513          	addi	a0,a0,1250 # 8000ea08 <bcache>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	e06080e7          	jalr	-506(ra) # 80006334 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002536:	00014497          	auipc	s1,0x14
    8000253a:	78a4b483          	ld	s1,1930(s1) # 80016cc0 <bcache+0x82b8>
    8000253e:	00014797          	auipc	a5,0x14
    80002542:	73278793          	addi	a5,a5,1842 # 80016c70 <bcache+0x8268>
    80002546:	02f48f63          	beq	s1,a5,80002584 <bread+0x70>
    8000254a:	873e                	mv	a4,a5
    8000254c:	a021                	j	80002554 <bread+0x40>
    8000254e:	68a4                	ld	s1,80(s1)
    80002550:	02e48a63          	beq	s1,a4,80002584 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002554:	449c                	lw	a5,8(s1)
    80002556:	ff279ce3          	bne	a5,s2,8000254e <bread+0x3a>
    8000255a:	44dc                	lw	a5,12(s1)
    8000255c:	ff3799e3          	bne	a5,s3,8000254e <bread+0x3a>
      b->refcnt++;
    80002560:	40bc                	lw	a5,64(s1)
    80002562:	2785                	addiw	a5,a5,1
    80002564:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002566:	0000c517          	auipc	a0,0xc
    8000256a:	4a250513          	addi	a0,a0,1186 # 8000ea08 <bcache>
    8000256e:	00004097          	auipc	ra,0x4
    80002572:	e7a080e7          	jalr	-390(ra) # 800063e8 <release>
      acquiresleep(&b->lock);
    80002576:	01048513          	addi	a0,s1,16
    8000257a:	00001097          	auipc	ra,0x1
    8000257e:	472080e7          	jalr	1138(ra) # 800039ec <acquiresleep>
      return b;
    80002582:	a8b9                	j	800025e0 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002584:	00014497          	auipc	s1,0x14
    80002588:	7344b483          	ld	s1,1844(s1) # 80016cb8 <bcache+0x82b0>
    8000258c:	00014797          	auipc	a5,0x14
    80002590:	6e478793          	addi	a5,a5,1764 # 80016c70 <bcache+0x8268>
    80002594:	00f48863          	beq	s1,a5,800025a4 <bread+0x90>
    80002598:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000259a:	40bc                	lw	a5,64(s1)
    8000259c:	cf81                	beqz	a5,800025b4 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000259e:	64a4                	ld	s1,72(s1)
    800025a0:	fee49de3          	bne	s1,a4,8000259a <bread+0x86>
  panic("bget: no buffers");
    800025a4:	00006517          	auipc	a0,0x6
    800025a8:	f9450513          	addi	a0,a0,-108 # 80008538 <syscalls+0x138>
    800025ac:	00004097          	auipc	ra,0x4
    800025b0:	850080e7          	jalr	-1968(ra) # 80005dfc <panic>
      b->dev = dev;
    800025b4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800025b8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800025bc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025c0:	4785                	li	a5,1
    800025c2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c4:	0000c517          	auipc	a0,0xc
    800025c8:	44450513          	addi	a0,a0,1092 # 8000ea08 <bcache>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	e1c080e7          	jalr	-484(ra) # 800063e8 <release>
      acquiresleep(&b->lock);
    800025d4:	01048513          	addi	a0,s1,16
    800025d8:	00001097          	auipc	ra,0x1
    800025dc:	414080e7          	jalr	1044(ra) # 800039ec <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800025e0:	409c                	lw	a5,0(s1)
    800025e2:	cb89                	beqz	a5,800025f4 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800025e4:	8526                	mv	a0,s1
    800025e6:	70a2                	ld	ra,40(sp)
    800025e8:	7402                	ld	s0,32(sp)
    800025ea:	64e2                	ld	s1,24(sp)
    800025ec:	6942                	ld	s2,16(sp)
    800025ee:	69a2                	ld	s3,8(sp)
    800025f0:	6145                	addi	sp,sp,48
    800025f2:	8082                	ret
    virtio_disk_rw(b, 0);
    800025f4:	4581                	li	a1,0
    800025f6:	8526                	mv	a0,s1
    800025f8:	00003097          	auipc	ra,0x3
    800025fc:	ffa080e7          	jalr	-6(ra) # 800055f2 <virtio_disk_rw>
    b->valid = 1;
    80002600:	4785                	li	a5,1
    80002602:	c09c                	sw	a5,0(s1)
  return b;
    80002604:	b7c5                	j	800025e4 <bread+0xd0>

0000000080002606 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	1000                	addi	s0,sp,32
    80002610:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002612:	0541                	addi	a0,a0,16
    80002614:	00001097          	auipc	ra,0x1
    80002618:	472080e7          	jalr	1138(ra) # 80003a86 <holdingsleep>
    8000261c:	cd01                	beqz	a0,80002634 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000261e:	4585                	li	a1,1
    80002620:	8526                	mv	a0,s1
    80002622:	00003097          	auipc	ra,0x3
    80002626:	fd0080e7          	jalr	-48(ra) # 800055f2 <virtio_disk_rw>
}
    8000262a:	60e2                	ld	ra,24(sp)
    8000262c:	6442                	ld	s0,16(sp)
    8000262e:	64a2                	ld	s1,8(sp)
    80002630:	6105                	addi	sp,sp,32
    80002632:	8082                	ret
    panic("bwrite");
    80002634:	00006517          	auipc	a0,0x6
    80002638:	f1c50513          	addi	a0,a0,-228 # 80008550 <syscalls+0x150>
    8000263c:	00003097          	auipc	ra,0x3
    80002640:	7c0080e7          	jalr	1984(ra) # 80005dfc <panic>

0000000080002644 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002644:	1101                	addi	sp,sp,-32
    80002646:	ec06                	sd	ra,24(sp)
    80002648:	e822                	sd	s0,16(sp)
    8000264a:	e426                	sd	s1,8(sp)
    8000264c:	e04a                	sd	s2,0(sp)
    8000264e:	1000                	addi	s0,sp,32
    80002650:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002652:	01050913          	addi	s2,a0,16
    80002656:	854a                	mv	a0,s2
    80002658:	00001097          	auipc	ra,0x1
    8000265c:	42e080e7          	jalr	1070(ra) # 80003a86 <holdingsleep>
    80002660:	c92d                	beqz	a0,800026d2 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002662:	854a                	mv	a0,s2
    80002664:	00001097          	auipc	ra,0x1
    80002668:	3de080e7          	jalr	990(ra) # 80003a42 <releasesleep>

  acquire(&bcache.lock);
    8000266c:	0000c517          	auipc	a0,0xc
    80002670:	39c50513          	addi	a0,a0,924 # 8000ea08 <bcache>
    80002674:	00004097          	auipc	ra,0x4
    80002678:	cc0080e7          	jalr	-832(ra) # 80006334 <acquire>
  b->refcnt--;
    8000267c:	40bc                	lw	a5,64(s1)
    8000267e:	37fd                	addiw	a5,a5,-1
    80002680:	0007871b          	sext.w	a4,a5
    80002684:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002686:	eb05                	bnez	a4,800026b6 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002688:	68bc                	ld	a5,80(s1)
    8000268a:	64b8                	ld	a4,72(s1)
    8000268c:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000268e:	64bc                	ld	a5,72(s1)
    80002690:	68b8                	ld	a4,80(s1)
    80002692:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002694:	00014797          	auipc	a5,0x14
    80002698:	37478793          	addi	a5,a5,884 # 80016a08 <bcache+0x8000>
    8000269c:	2b87b703          	ld	a4,696(a5)
    800026a0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026a2:	00014717          	auipc	a4,0x14
    800026a6:	5ce70713          	addi	a4,a4,1486 # 80016c70 <bcache+0x8268>
    800026aa:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026ac:	2b87b703          	ld	a4,696(a5)
    800026b0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026b2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026b6:	0000c517          	auipc	a0,0xc
    800026ba:	35250513          	addi	a0,a0,850 # 8000ea08 <bcache>
    800026be:	00004097          	auipc	ra,0x4
    800026c2:	d2a080e7          	jalr	-726(ra) # 800063e8 <release>
}
    800026c6:	60e2                	ld	ra,24(sp)
    800026c8:	6442                	ld	s0,16(sp)
    800026ca:	64a2                	ld	s1,8(sp)
    800026cc:	6902                	ld	s2,0(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret
    panic("brelse");
    800026d2:	00006517          	auipc	a0,0x6
    800026d6:	e8650513          	addi	a0,a0,-378 # 80008558 <syscalls+0x158>
    800026da:	00003097          	auipc	ra,0x3
    800026de:	722080e7          	jalr	1826(ra) # 80005dfc <panic>

00000000800026e2 <bpin>:

void
bpin(struct buf *b) {
    800026e2:	1101                	addi	sp,sp,-32
    800026e4:	ec06                	sd	ra,24(sp)
    800026e6:	e822                	sd	s0,16(sp)
    800026e8:	e426                	sd	s1,8(sp)
    800026ea:	1000                	addi	s0,sp,32
    800026ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800026ee:	0000c517          	auipc	a0,0xc
    800026f2:	31a50513          	addi	a0,a0,794 # 8000ea08 <bcache>
    800026f6:	00004097          	auipc	ra,0x4
    800026fa:	c3e080e7          	jalr	-962(ra) # 80006334 <acquire>
  b->refcnt++;
    800026fe:	40bc                	lw	a5,64(s1)
    80002700:	2785                	addiw	a5,a5,1
    80002702:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002704:	0000c517          	auipc	a0,0xc
    80002708:	30450513          	addi	a0,a0,772 # 8000ea08 <bcache>
    8000270c:	00004097          	auipc	ra,0x4
    80002710:	cdc080e7          	jalr	-804(ra) # 800063e8 <release>
}
    80002714:	60e2                	ld	ra,24(sp)
    80002716:	6442                	ld	s0,16(sp)
    80002718:	64a2                	ld	s1,8(sp)
    8000271a:	6105                	addi	sp,sp,32
    8000271c:	8082                	ret

000000008000271e <bunpin>:

void
bunpin(struct buf *b) {
    8000271e:	1101                	addi	sp,sp,-32
    80002720:	ec06                	sd	ra,24(sp)
    80002722:	e822                	sd	s0,16(sp)
    80002724:	e426                	sd	s1,8(sp)
    80002726:	1000                	addi	s0,sp,32
    80002728:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000272a:	0000c517          	auipc	a0,0xc
    8000272e:	2de50513          	addi	a0,a0,734 # 8000ea08 <bcache>
    80002732:	00004097          	auipc	ra,0x4
    80002736:	c02080e7          	jalr	-1022(ra) # 80006334 <acquire>
  b->refcnt--;
    8000273a:	40bc                	lw	a5,64(s1)
    8000273c:	37fd                	addiw	a5,a5,-1
    8000273e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002740:	0000c517          	auipc	a0,0xc
    80002744:	2c850513          	addi	a0,a0,712 # 8000ea08 <bcache>
    80002748:	00004097          	auipc	ra,0x4
    8000274c:	ca0080e7          	jalr	-864(ra) # 800063e8 <release>
}
    80002750:	60e2                	ld	ra,24(sp)
    80002752:	6442                	ld	s0,16(sp)
    80002754:	64a2                	ld	s1,8(sp)
    80002756:	6105                	addi	sp,sp,32
    80002758:	8082                	ret

000000008000275a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000275a:	1101                	addi	sp,sp,-32
    8000275c:	ec06                	sd	ra,24(sp)
    8000275e:	e822                	sd	s0,16(sp)
    80002760:	e426                	sd	s1,8(sp)
    80002762:	e04a                	sd	s2,0(sp)
    80002764:	1000                	addi	s0,sp,32
    80002766:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002768:	00d5d59b          	srliw	a1,a1,0xd
    8000276c:	00015797          	auipc	a5,0x15
    80002770:	9787a783          	lw	a5,-1672(a5) # 800170e4 <sb+0x1c>
    80002774:	9dbd                	addw	a1,a1,a5
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	d9e080e7          	jalr	-610(ra) # 80002514 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000277e:	0074f713          	andi	a4,s1,7
    80002782:	4785                	li	a5,1
    80002784:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002788:	14ce                	slli	s1,s1,0x33
    8000278a:	90d9                	srli	s1,s1,0x36
    8000278c:	00950733          	add	a4,a0,s1
    80002790:	05874703          	lbu	a4,88(a4)
    80002794:	00e7f6b3          	and	a3,a5,a4
    80002798:	c69d                	beqz	a3,800027c6 <bfree+0x6c>
    8000279a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000279c:	94aa                	add	s1,s1,a0
    8000279e:	fff7c793          	not	a5,a5
    800027a2:	8f7d                	and	a4,a4,a5
    800027a4:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800027a8:	00001097          	auipc	ra,0x1
    800027ac:	126080e7          	jalr	294(ra) # 800038ce <log_write>
  brelse(bp);
    800027b0:	854a                	mv	a0,s2
    800027b2:	00000097          	auipc	ra,0x0
    800027b6:	e92080e7          	jalr	-366(ra) # 80002644 <brelse>
}
    800027ba:	60e2                	ld	ra,24(sp)
    800027bc:	6442                	ld	s0,16(sp)
    800027be:	64a2                	ld	s1,8(sp)
    800027c0:	6902                	ld	s2,0(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret
    panic("freeing free block");
    800027c6:	00006517          	auipc	a0,0x6
    800027ca:	d9a50513          	addi	a0,a0,-614 # 80008560 <syscalls+0x160>
    800027ce:	00003097          	auipc	ra,0x3
    800027d2:	62e080e7          	jalr	1582(ra) # 80005dfc <panic>

00000000800027d6 <balloc>:
{
    800027d6:	711d                	addi	sp,sp,-96
    800027d8:	ec86                	sd	ra,88(sp)
    800027da:	e8a2                	sd	s0,80(sp)
    800027dc:	e4a6                	sd	s1,72(sp)
    800027de:	e0ca                	sd	s2,64(sp)
    800027e0:	fc4e                	sd	s3,56(sp)
    800027e2:	f852                	sd	s4,48(sp)
    800027e4:	f456                	sd	s5,40(sp)
    800027e6:	f05a                	sd	s6,32(sp)
    800027e8:	ec5e                	sd	s7,24(sp)
    800027ea:	e862                	sd	s8,16(sp)
    800027ec:	e466                	sd	s9,8(sp)
    800027ee:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800027f0:	00015797          	auipc	a5,0x15
    800027f4:	8dc7a783          	lw	a5,-1828(a5) # 800170cc <sb+0x4>
    800027f8:	cff5                	beqz	a5,800028f4 <balloc+0x11e>
    800027fa:	8baa                	mv	s7,a0
    800027fc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800027fe:	00015b17          	auipc	s6,0x15
    80002802:	8cab0b13          	addi	s6,s6,-1846 # 800170c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002806:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002808:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000280c:	6c89                	lui	s9,0x2
    8000280e:	a061                	j	80002896 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002810:	97ca                	add	a5,a5,s2
    80002812:	8e55                	or	a2,a2,a3
    80002814:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002818:	854a                	mv	a0,s2
    8000281a:	00001097          	auipc	ra,0x1
    8000281e:	0b4080e7          	jalr	180(ra) # 800038ce <log_write>
        brelse(bp);
    80002822:	854a                	mv	a0,s2
    80002824:	00000097          	auipc	ra,0x0
    80002828:	e20080e7          	jalr	-480(ra) # 80002644 <brelse>
  bp = bread(dev, bno);
    8000282c:	85a6                	mv	a1,s1
    8000282e:	855e                	mv	a0,s7
    80002830:	00000097          	auipc	ra,0x0
    80002834:	ce4080e7          	jalr	-796(ra) # 80002514 <bread>
    80002838:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000283a:	40000613          	li	a2,1024
    8000283e:	4581                	li	a1,0
    80002840:	05850513          	addi	a0,a0,88
    80002844:	ffffe097          	auipc	ra,0xffffe
    80002848:	936080e7          	jalr	-1738(ra) # 8000017a <memset>
  log_write(bp);
    8000284c:	854a                	mv	a0,s2
    8000284e:	00001097          	auipc	ra,0x1
    80002852:	080080e7          	jalr	128(ra) # 800038ce <log_write>
  brelse(bp);
    80002856:	854a                	mv	a0,s2
    80002858:	00000097          	auipc	ra,0x0
    8000285c:	dec080e7          	jalr	-532(ra) # 80002644 <brelse>
}
    80002860:	8526                	mv	a0,s1
    80002862:	60e6                	ld	ra,88(sp)
    80002864:	6446                	ld	s0,80(sp)
    80002866:	64a6                	ld	s1,72(sp)
    80002868:	6906                	ld	s2,64(sp)
    8000286a:	79e2                	ld	s3,56(sp)
    8000286c:	7a42                	ld	s4,48(sp)
    8000286e:	7aa2                	ld	s5,40(sp)
    80002870:	7b02                	ld	s6,32(sp)
    80002872:	6be2                	ld	s7,24(sp)
    80002874:	6c42                	ld	s8,16(sp)
    80002876:	6ca2                	ld	s9,8(sp)
    80002878:	6125                	addi	sp,sp,96
    8000287a:	8082                	ret
    brelse(bp);
    8000287c:	854a                	mv	a0,s2
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	dc6080e7          	jalr	-570(ra) # 80002644 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002886:	015c87bb          	addw	a5,s9,s5
    8000288a:	00078a9b          	sext.w	s5,a5
    8000288e:	004b2703          	lw	a4,4(s6)
    80002892:	06eaf163          	bgeu	s5,a4,800028f4 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002896:	41fad79b          	sraiw	a5,s5,0x1f
    8000289a:	0137d79b          	srliw	a5,a5,0x13
    8000289e:	015787bb          	addw	a5,a5,s5
    800028a2:	40d7d79b          	sraiw	a5,a5,0xd
    800028a6:	01cb2583          	lw	a1,28(s6)
    800028aa:	9dbd                	addw	a1,a1,a5
    800028ac:	855e                	mv	a0,s7
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	c66080e7          	jalr	-922(ra) # 80002514 <bread>
    800028b6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028b8:	004b2503          	lw	a0,4(s6)
    800028bc:	000a849b          	sext.w	s1,s5
    800028c0:	8762                	mv	a4,s8
    800028c2:	faa4fde3          	bgeu	s1,a0,8000287c <balloc+0xa6>
      m = 1 << (bi % 8);
    800028c6:	00777693          	andi	a3,a4,7
    800028ca:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028ce:	41f7579b          	sraiw	a5,a4,0x1f
    800028d2:	01d7d79b          	srliw	a5,a5,0x1d
    800028d6:	9fb9                	addw	a5,a5,a4
    800028d8:	4037d79b          	sraiw	a5,a5,0x3
    800028dc:	00f90633          	add	a2,s2,a5
    800028e0:	05864603          	lbu	a2,88(a2)
    800028e4:	00c6f5b3          	and	a1,a3,a2
    800028e8:	d585                	beqz	a1,80002810 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028ea:	2705                	addiw	a4,a4,1
    800028ec:	2485                	addiw	s1,s1,1
    800028ee:	fd471ae3          	bne	a4,s4,800028c2 <balloc+0xec>
    800028f2:	b769                	j	8000287c <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800028f4:	00006517          	auipc	a0,0x6
    800028f8:	c8450513          	addi	a0,a0,-892 # 80008578 <syscalls+0x178>
    800028fc:	00003097          	auipc	ra,0x3
    80002900:	54a080e7          	jalr	1354(ra) # 80005e46 <printf>
  return 0;
    80002904:	4481                	li	s1,0
    80002906:	bfa9                	j	80002860 <balloc+0x8a>

0000000080002908 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002908:	7179                	addi	sp,sp,-48
    8000290a:	f406                	sd	ra,40(sp)
    8000290c:	f022                	sd	s0,32(sp)
    8000290e:	ec26                	sd	s1,24(sp)
    80002910:	e84a                	sd	s2,16(sp)
    80002912:	e44e                	sd	s3,8(sp)
    80002914:	e052                	sd	s4,0(sp)
    80002916:	1800                	addi	s0,sp,48
    80002918:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000291a:	47ad                	li	a5,11
    8000291c:	02b7e863          	bltu	a5,a1,8000294c <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002920:	02059793          	slli	a5,a1,0x20
    80002924:	01e7d593          	srli	a1,a5,0x1e
    80002928:	00b504b3          	add	s1,a0,a1
    8000292c:	0504a903          	lw	s2,80(s1)
    80002930:	06091e63          	bnez	s2,800029ac <bmap+0xa4>
      addr = balloc(ip->dev);
    80002934:	4108                	lw	a0,0(a0)
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	ea0080e7          	jalr	-352(ra) # 800027d6 <balloc>
    8000293e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002942:	06090563          	beqz	s2,800029ac <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002946:	0524a823          	sw	s2,80(s1)
    8000294a:	a08d                	j	800029ac <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000294c:	ff45849b          	addiw	s1,a1,-12
    80002950:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002954:	0ff00793          	li	a5,255
    80002958:	08e7e563          	bltu	a5,a4,800029e2 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000295c:	08052903          	lw	s2,128(a0)
    80002960:	00091d63          	bnez	s2,8000297a <bmap+0x72>
      addr = balloc(ip->dev);
    80002964:	4108                	lw	a0,0(a0)
    80002966:	00000097          	auipc	ra,0x0
    8000296a:	e70080e7          	jalr	-400(ra) # 800027d6 <balloc>
    8000296e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002972:	02090d63          	beqz	s2,800029ac <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002976:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000297a:	85ca                	mv	a1,s2
    8000297c:	0009a503          	lw	a0,0(s3)
    80002980:	00000097          	auipc	ra,0x0
    80002984:	b94080e7          	jalr	-1132(ra) # 80002514 <bread>
    80002988:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000298a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000298e:	02049713          	slli	a4,s1,0x20
    80002992:	01e75593          	srli	a1,a4,0x1e
    80002996:	00b784b3          	add	s1,a5,a1
    8000299a:	0004a903          	lw	s2,0(s1)
    8000299e:	02090063          	beqz	s2,800029be <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029a2:	8552                	mv	a0,s4
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	ca0080e7          	jalr	-864(ra) # 80002644 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029ac:	854a                	mv	a0,s2
    800029ae:	70a2                	ld	ra,40(sp)
    800029b0:	7402                	ld	s0,32(sp)
    800029b2:	64e2                	ld	s1,24(sp)
    800029b4:	6942                	ld	s2,16(sp)
    800029b6:	69a2                	ld	s3,8(sp)
    800029b8:	6a02                	ld	s4,0(sp)
    800029ba:	6145                	addi	sp,sp,48
    800029bc:	8082                	ret
      addr = balloc(ip->dev);
    800029be:	0009a503          	lw	a0,0(s3)
    800029c2:	00000097          	auipc	ra,0x0
    800029c6:	e14080e7          	jalr	-492(ra) # 800027d6 <balloc>
    800029ca:	0005091b          	sext.w	s2,a0
      if(addr){
    800029ce:	fc090ae3          	beqz	s2,800029a2 <bmap+0x9a>
        a[bn] = addr;
    800029d2:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800029d6:	8552                	mv	a0,s4
    800029d8:	00001097          	auipc	ra,0x1
    800029dc:	ef6080e7          	jalr	-266(ra) # 800038ce <log_write>
    800029e0:	b7c9                	j	800029a2 <bmap+0x9a>
  panic("bmap: out of range");
    800029e2:	00006517          	auipc	a0,0x6
    800029e6:	bae50513          	addi	a0,a0,-1106 # 80008590 <syscalls+0x190>
    800029ea:	00003097          	auipc	ra,0x3
    800029ee:	412080e7          	jalr	1042(ra) # 80005dfc <panic>

00000000800029f2 <iget>:
{
    800029f2:	7179                	addi	sp,sp,-48
    800029f4:	f406                	sd	ra,40(sp)
    800029f6:	f022                	sd	s0,32(sp)
    800029f8:	ec26                	sd	s1,24(sp)
    800029fa:	e84a                	sd	s2,16(sp)
    800029fc:	e44e                	sd	s3,8(sp)
    800029fe:	e052                	sd	s4,0(sp)
    80002a00:	1800                	addi	s0,sp,48
    80002a02:	89aa                	mv	s3,a0
    80002a04:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a06:	00014517          	auipc	a0,0x14
    80002a0a:	6e250513          	addi	a0,a0,1762 # 800170e8 <itable>
    80002a0e:	00004097          	auipc	ra,0x4
    80002a12:	926080e7          	jalr	-1754(ra) # 80006334 <acquire>
  empty = 0;
    80002a16:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a18:	00014497          	auipc	s1,0x14
    80002a1c:	6e848493          	addi	s1,s1,1768 # 80017100 <itable+0x18>
    80002a20:	00016697          	auipc	a3,0x16
    80002a24:	17068693          	addi	a3,a3,368 # 80018b90 <log>
    80002a28:	a039                	j	80002a36 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a2a:	02090b63          	beqz	s2,80002a60 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a2e:	08848493          	addi	s1,s1,136
    80002a32:	02d48a63          	beq	s1,a3,80002a66 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a36:	449c                	lw	a5,8(s1)
    80002a38:	fef059e3          	blez	a5,80002a2a <iget+0x38>
    80002a3c:	4098                	lw	a4,0(s1)
    80002a3e:	ff3716e3          	bne	a4,s3,80002a2a <iget+0x38>
    80002a42:	40d8                	lw	a4,4(s1)
    80002a44:	ff4713e3          	bne	a4,s4,80002a2a <iget+0x38>
      ip->ref++;
    80002a48:	2785                	addiw	a5,a5,1
    80002a4a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a4c:	00014517          	auipc	a0,0x14
    80002a50:	69c50513          	addi	a0,a0,1692 # 800170e8 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	994080e7          	jalr	-1644(ra) # 800063e8 <release>
      return ip;
    80002a5c:	8926                	mv	s2,s1
    80002a5e:	a03d                	j	80002a8c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a60:	f7f9                	bnez	a5,80002a2e <iget+0x3c>
    80002a62:	8926                	mv	s2,s1
    80002a64:	b7e9                	j	80002a2e <iget+0x3c>
  if(empty == 0)
    80002a66:	02090c63          	beqz	s2,80002a9e <iget+0xac>
  ip->dev = dev;
    80002a6a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a6e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002a72:	4785                	li	a5,1
    80002a74:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002a78:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002a7c:	00014517          	auipc	a0,0x14
    80002a80:	66c50513          	addi	a0,a0,1644 # 800170e8 <itable>
    80002a84:	00004097          	auipc	ra,0x4
    80002a88:	964080e7          	jalr	-1692(ra) # 800063e8 <release>
}
    80002a8c:	854a                	mv	a0,s2
    80002a8e:	70a2                	ld	ra,40(sp)
    80002a90:	7402                	ld	s0,32(sp)
    80002a92:	64e2                	ld	s1,24(sp)
    80002a94:	6942                	ld	s2,16(sp)
    80002a96:	69a2                	ld	s3,8(sp)
    80002a98:	6a02                	ld	s4,0(sp)
    80002a9a:	6145                	addi	sp,sp,48
    80002a9c:	8082                	ret
    panic("iget: no inodes");
    80002a9e:	00006517          	auipc	a0,0x6
    80002aa2:	b0a50513          	addi	a0,a0,-1270 # 800085a8 <syscalls+0x1a8>
    80002aa6:	00003097          	auipc	ra,0x3
    80002aaa:	356080e7          	jalr	854(ra) # 80005dfc <panic>

0000000080002aae <fsinit>:
fsinit(int dev) {
    80002aae:	7179                	addi	sp,sp,-48
    80002ab0:	f406                	sd	ra,40(sp)
    80002ab2:	f022                	sd	s0,32(sp)
    80002ab4:	ec26                	sd	s1,24(sp)
    80002ab6:	e84a                	sd	s2,16(sp)
    80002ab8:	e44e                	sd	s3,8(sp)
    80002aba:	1800                	addi	s0,sp,48
    80002abc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002abe:	4585                	li	a1,1
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	a54080e7          	jalr	-1452(ra) # 80002514 <bread>
    80002ac8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aca:	00014997          	auipc	s3,0x14
    80002ace:	5fe98993          	addi	s3,s3,1534 # 800170c8 <sb>
    80002ad2:	02000613          	li	a2,32
    80002ad6:	05850593          	addi	a1,a0,88
    80002ada:	854e                	mv	a0,s3
    80002adc:	ffffd097          	auipc	ra,0xffffd
    80002ae0:	6fa080e7          	jalr	1786(ra) # 800001d6 <memmove>
  brelse(bp);
    80002ae4:	8526                	mv	a0,s1
    80002ae6:	00000097          	auipc	ra,0x0
    80002aea:	b5e080e7          	jalr	-1186(ra) # 80002644 <brelse>
  if(sb.magic != FSMAGIC)
    80002aee:	0009a703          	lw	a4,0(s3)
    80002af2:	102037b7          	lui	a5,0x10203
    80002af6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002afa:	02f71263          	bne	a4,a5,80002b1e <fsinit+0x70>
  initlog(dev, &sb);
    80002afe:	00014597          	auipc	a1,0x14
    80002b02:	5ca58593          	addi	a1,a1,1482 # 800170c8 <sb>
    80002b06:	854a                	mv	a0,s2
    80002b08:	00001097          	auipc	ra,0x1
    80002b0c:	b4a080e7          	jalr	-1206(ra) # 80003652 <initlog>
}
    80002b10:	70a2                	ld	ra,40(sp)
    80002b12:	7402                	ld	s0,32(sp)
    80002b14:	64e2                	ld	s1,24(sp)
    80002b16:	6942                	ld	s2,16(sp)
    80002b18:	69a2                	ld	s3,8(sp)
    80002b1a:	6145                	addi	sp,sp,48
    80002b1c:	8082                	ret
    panic("invalid file system");
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	a9a50513          	addi	a0,a0,-1382 # 800085b8 <syscalls+0x1b8>
    80002b26:	00003097          	auipc	ra,0x3
    80002b2a:	2d6080e7          	jalr	726(ra) # 80005dfc <panic>

0000000080002b2e <iinit>:
{
    80002b2e:	7179                	addi	sp,sp,-48
    80002b30:	f406                	sd	ra,40(sp)
    80002b32:	f022                	sd	s0,32(sp)
    80002b34:	ec26                	sd	s1,24(sp)
    80002b36:	e84a                	sd	s2,16(sp)
    80002b38:	e44e                	sd	s3,8(sp)
    80002b3a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b3c:	00006597          	auipc	a1,0x6
    80002b40:	a9458593          	addi	a1,a1,-1388 # 800085d0 <syscalls+0x1d0>
    80002b44:	00014517          	auipc	a0,0x14
    80002b48:	5a450513          	addi	a0,a0,1444 # 800170e8 <itable>
    80002b4c:	00003097          	auipc	ra,0x3
    80002b50:	758080e7          	jalr	1880(ra) # 800062a4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b54:	00014497          	auipc	s1,0x14
    80002b58:	5bc48493          	addi	s1,s1,1468 # 80017110 <itable+0x28>
    80002b5c:	00016997          	auipc	s3,0x16
    80002b60:	04498993          	addi	s3,s3,68 # 80018ba0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b64:	00006917          	auipc	s2,0x6
    80002b68:	a7490913          	addi	s2,s2,-1420 # 800085d8 <syscalls+0x1d8>
    80002b6c:	85ca                	mv	a1,s2
    80002b6e:	8526                	mv	a0,s1
    80002b70:	00001097          	auipc	ra,0x1
    80002b74:	e42080e7          	jalr	-446(ra) # 800039b2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b78:	08848493          	addi	s1,s1,136
    80002b7c:	ff3498e3          	bne	s1,s3,80002b6c <iinit+0x3e>
}
    80002b80:	70a2                	ld	ra,40(sp)
    80002b82:	7402                	ld	s0,32(sp)
    80002b84:	64e2                	ld	s1,24(sp)
    80002b86:	6942                	ld	s2,16(sp)
    80002b88:	69a2                	ld	s3,8(sp)
    80002b8a:	6145                	addi	sp,sp,48
    80002b8c:	8082                	ret

0000000080002b8e <ialloc>:
{
    80002b8e:	715d                	addi	sp,sp,-80
    80002b90:	e486                	sd	ra,72(sp)
    80002b92:	e0a2                	sd	s0,64(sp)
    80002b94:	fc26                	sd	s1,56(sp)
    80002b96:	f84a                	sd	s2,48(sp)
    80002b98:	f44e                	sd	s3,40(sp)
    80002b9a:	f052                	sd	s4,32(sp)
    80002b9c:	ec56                	sd	s5,24(sp)
    80002b9e:	e85a                	sd	s6,16(sp)
    80002ba0:	e45e                	sd	s7,8(sp)
    80002ba2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ba4:	00014717          	auipc	a4,0x14
    80002ba8:	53072703          	lw	a4,1328(a4) # 800170d4 <sb+0xc>
    80002bac:	4785                	li	a5,1
    80002bae:	04e7fa63          	bgeu	a5,a4,80002c02 <ialloc+0x74>
    80002bb2:	8aaa                	mv	s5,a0
    80002bb4:	8bae                	mv	s7,a1
    80002bb6:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bb8:	00014a17          	auipc	s4,0x14
    80002bbc:	510a0a13          	addi	s4,s4,1296 # 800170c8 <sb>
    80002bc0:	00048b1b          	sext.w	s6,s1
    80002bc4:	0044d593          	srli	a1,s1,0x4
    80002bc8:	018a2783          	lw	a5,24(s4)
    80002bcc:	9dbd                	addw	a1,a1,a5
    80002bce:	8556                	mv	a0,s5
    80002bd0:	00000097          	auipc	ra,0x0
    80002bd4:	944080e7          	jalr	-1724(ra) # 80002514 <bread>
    80002bd8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002bda:	05850993          	addi	s3,a0,88
    80002bde:	00f4f793          	andi	a5,s1,15
    80002be2:	079a                	slli	a5,a5,0x6
    80002be4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002be6:	00099783          	lh	a5,0(s3)
    80002bea:	c3a1                	beqz	a5,80002c2a <ialloc+0x9c>
    brelse(bp);
    80002bec:	00000097          	auipc	ra,0x0
    80002bf0:	a58080e7          	jalr	-1448(ra) # 80002644 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bf4:	0485                	addi	s1,s1,1
    80002bf6:	00ca2703          	lw	a4,12(s4)
    80002bfa:	0004879b          	sext.w	a5,s1
    80002bfe:	fce7e1e3          	bltu	a5,a4,80002bc0 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c02:	00006517          	auipc	a0,0x6
    80002c06:	9de50513          	addi	a0,a0,-1570 # 800085e0 <syscalls+0x1e0>
    80002c0a:	00003097          	auipc	ra,0x3
    80002c0e:	23c080e7          	jalr	572(ra) # 80005e46 <printf>
  return 0;
    80002c12:	4501                	li	a0,0
}
    80002c14:	60a6                	ld	ra,72(sp)
    80002c16:	6406                	ld	s0,64(sp)
    80002c18:	74e2                	ld	s1,56(sp)
    80002c1a:	7942                	ld	s2,48(sp)
    80002c1c:	79a2                	ld	s3,40(sp)
    80002c1e:	7a02                	ld	s4,32(sp)
    80002c20:	6ae2                	ld	s5,24(sp)
    80002c22:	6b42                	ld	s6,16(sp)
    80002c24:	6ba2                	ld	s7,8(sp)
    80002c26:	6161                	addi	sp,sp,80
    80002c28:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c2a:	04000613          	li	a2,64
    80002c2e:	4581                	li	a1,0
    80002c30:	854e                	mv	a0,s3
    80002c32:	ffffd097          	auipc	ra,0xffffd
    80002c36:	548080e7          	jalr	1352(ra) # 8000017a <memset>
      dip->type = type;
    80002c3a:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c3e:	854a                	mv	a0,s2
    80002c40:	00001097          	auipc	ra,0x1
    80002c44:	c8e080e7          	jalr	-882(ra) # 800038ce <log_write>
      brelse(bp);
    80002c48:	854a                	mv	a0,s2
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	9fa080e7          	jalr	-1542(ra) # 80002644 <brelse>
      return iget(dev, inum);
    80002c52:	85da                	mv	a1,s6
    80002c54:	8556                	mv	a0,s5
    80002c56:	00000097          	auipc	ra,0x0
    80002c5a:	d9c080e7          	jalr	-612(ra) # 800029f2 <iget>
    80002c5e:	bf5d                	j	80002c14 <ialloc+0x86>

0000000080002c60 <iupdate>:
{
    80002c60:	1101                	addi	sp,sp,-32
    80002c62:	ec06                	sd	ra,24(sp)
    80002c64:	e822                	sd	s0,16(sp)
    80002c66:	e426                	sd	s1,8(sp)
    80002c68:	e04a                	sd	s2,0(sp)
    80002c6a:	1000                	addi	s0,sp,32
    80002c6c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6e:	415c                	lw	a5,4(a0)
    80002c70:	0047d79b          	srliw	a5,a5,0x4
    80002c74:	00014597          	auipc	a1,0x14
    80002c78:	46c5a583          	lw	a1,1132(a1) # 800170e0 <sb+0x18>
    80002c7c:	9dbd                	addw	a1,a1,a5
    80002c7e:	4108                	lw	a0,0(a0)
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	894080e7          	jalr	-1900(ra) # 80002514 <bread>
    80002c88:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c8a:	05850793          	addi	a5,a0,88
    80002c8e:	40d8                	lw	a4,4(s1)
    80002c90:	8b3d                	andi	a4,a4,15
    80002c92:	071a                	slli	a4,a4,0x6
    80002c94:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c96:	04449703          	lh	a4,68(s1)
    80002c9a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c9e:	04649703          	lh	a4,70(s1)
    80002ca2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ca6:	04849703          	lh	a4,72(s1)
    80002caa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cae:	04a49703          	lh	a4,74(s1)
    80002cb2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cb6:	44f8                	lw	a4,76(s1)
    80002cb8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cba:	03400613          	li	a2,52
    80002cbe:	05048593          	addi	a1,s1,80
    80002cc2:	00c78513          	addi	a0,a5,12
    80002cc6:	ffffd097          	auipc	ra,0xffffd
    80002cca:	510080e7          	jalr	1296(ra) # 800001d6 <memmove>
  log_write(bp);
    80002cce:	854a                	mv	a0,s2
    80002cd0:	00001097          	auipc	ra,0x1
    80002cd4:	bfe080e7          	jalr	-1026(ra) # 800038ce <log_write>
  brelse(bp);
    80002cd8:	854a                	mv	a0,s2
    80002cda:	00000097          	auipc	ra,0x0
    80002cde:	96a080e7          	jalr	-1686(ra) # 80002644 <brelse>
}
    80002ce2:	60e2                	ld	ra,24(sp)
    80002ce4:	6442                	ld	s0,16(sp)
    80002ce6:	64a2                	ld	s1,8(sp)
    80002ce8:	6902                	ld	s2,0(sp)
    80002cea:	6105                	addi	sp,sp,32
    80002cec:	8082                	ret

0000000080002cee <idup>:
{
    80002cee:	1101                	addi	sp,sp,-32
    80002cf0:	ec06                	sd	ra,24(sp)
    80002cf2:	e822                	sd	s0,16(sp)
    80002cf4:	e426                	sd	s1,8(sp)
    80002cf6:	1000                	addi	s0,sp,32
    80002cf8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cfa:	00014517          	auipc	a0,0x14
    80002cfe:	3ee50513          	addi	a0,a0,1006 # 800170e8 <itable>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	632080e7          	jalr	1586(ra) # 80006334 <acquire>
  ip->ref++;
    80002d0a:	449c                	lw	a5,8(s1)
    80002d0c:	2785                	addiw	a5,a5,1
    80002d0e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d10:	00014517          	auipc	a0,0x14
    80002d14:	3d850513          	addi	a0,a0,984 # 800170e8 <itable>
    80002d18:	00003097          	auipc	ra,0x3
    80002d1c:	6d0080e7          	jalr	1744(ra) # 800063e8 <release>
}
    80002d20:	8526                	mv	a0,s1
    80002d22:	60e2                	ld	ra,24(sp)
    80002d24:	6442                	ld	s0,16(sp)
    80002d26:	64a2                	ld	s1,8(sp)
    80002d28:	6105                	addi	sp,sp,32
    80002d2a:	8082                	ret

0000000080002d2c <ilock>:
{
    80002d2c:	1101                	addi	sp,sp,-32
    80002d2e:	ec06                	sd	ra,24(sp)
    80002d30:	e822                	sd	s0,16(sp)
    80002d32:	e426                	sd	s1,8(sp)
    80002d34:	e04a                	sd	s2,0(sp)
    80002d36:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d38:	c115                	beqz	a0,80002d5c <ilock+0x30>
    80002d3a:	84aa                	mv	s1,a0
    80002d3c:	451c                	lw	a5,8(a0)
    80002d3e:	00f05f63          	blez	a5,80002d5c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d42:	0541                	addi	a0,a0,16
    80002d44:	00001097          	auipc	ra,0x1
    80002d48:	ca8080e7          	jalr	-856(ra) # 800039ec <acquiresleep>
  if(ip->valid == 0){
    80002d4c:	40bc                	lw	a5,64(s1)
    80002d4e:	cf99                	beqz	a5,80002d6c <ilock+0x40>
}
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6902                	ld	s2,0(sp)
    80002d58:	6105                	addi	sp,sp,32
    80002d5a:	8082                	ret
    panic("ilock");
    80002d5c:	00006517          	auipc	a0,0x6
    80002d60:	89c50513          	addi	a0,a0,-1892 # 800085f8 <syscalls+0x1f8>
    80002d64:	00003097          	auipc	ra,0x3
    80002d68:	098080e7          	jalr	152(ra) # 80005dfc <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d6c:	40dc                	lw	a5,4(s1)
    80002d6e:	0047d79b          	srliw	a5,a5,0x4
    80002d72:	00014597          	auipc	a1,0x14
    80002d76:	36e5a583          	lw	a1,878(a1) # 800170e0 <sb+0x18>
    80002d7a:	9dbd                	addw	a1,a1,a5
    80002d7c:	4088                	lw	a0,0(s1)
    80002d7e:	fffff097          	auipc	ra,0xfffff
    80002d82:	796080e7          	jalr	1942(ra) # 80002514 <bread>
    80002d86:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d88:	05850593          	addi	a1,a0,88
    80002d8c:	40dc                	lw	a5,4(s1)
    80002d8e:	8bbd                	andi	a5,a5,15
    80002d90:	079a                	slli	a5,a5,0x6
    80002d92:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d94:	00059783          	lh	a5,0(a1)
    80002d98:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d9c:	00259783          	lh	a5,2(a1)
    80002da0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002da4:	00459783          	lh	a5,4(a1)
    80002da8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dac:	00659783          	lh	a5,6(a1)
    80002db0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002db4:	459c                	lw	a5,8(a1)
    80002db6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002db8:	03400613          	li	a2,52
    80002dbc:	05b1                	addi	a1,a1,12
    80002dbe:	05048513          	addi	a0,s1,80
    80002dc2:	ffffd097          	auipc	ra,0xffffd
    80002dc6:	414080e7          	jalr	1044(ra) # 800001d6 <memmove>
    brelse(bp);
    80002dca:	854a                	mv	a0,s2
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	878080e7          	jalr	-1928(ra) # 80002644 <brelse>
    ip->valid = 1;
    80002dd4:	4785                	li	a5,1
    80002dd6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002dd8:	04449783          	lh	a5,68(s1)
    80002ddc:	fbb5                	bnez	a5,80002d50 <ilock+0x24>
      panic("ilock: no type");
    80002dde:	00006517          	auipc	a0,0x6
    80002de2:	82250513          	addi	a0,a0,-2014 # 80008600 <syscalls+0x200>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	016080e7          	jalr	22(ra) # 80005dfc <panic>

0000000080002dee <iunlock>:
{
    80002dee:	1101                	addi	sp,sp,-32
    80002df0:	ec06                	sd	ra,24(sp)
    80002df2:	e822                	sd	s0,16(sp)
    80002df4:	e426                	sd	s1,8(sp)
    80002df6:	e04a                	sd	s2,0(sp)
    80002df8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002dfa:	c905                	beqz	a0,80002e2a <iunlock+0x3c>
    80002dfc:	84aa                	mv	s1,a0
    80002dfe:	01050913          	addi	s2,a0,16
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	c82080e7          	jalr	-894(ra) # 80003a86 <holdingsleep>
    80002e0c:	cd19                	beqz	a0,80002e2a <iunlock+0x3c>
    80002e0e:	449c                	lw	a5,8(s1)
    80002e10:	00f05d63          	blez	a5,80002e2a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	00001097          	auipc	ra,0x1
    80002e1a:	c2c080e7          	jalr	-980(ra) # 80003a42 <releasesleep>
}
    80002e1e:	60e2                	ld	ra,24(sp)
    80002e20:	6442                	ld	s0,16(sp)
    80002e22:	64a2                	ld	s1,8(sp)
    80002e24:	6902                	ld	s2,0(sp)
    80002e26:	6105                	addi	sp,sp,32
    80002e28:	8082                	ret
    panic("iunlock");
    80002e2a:	00005517          	auipc	a0,0x5
    80002e2e:	7e650513          	addi	a0,a0,2022 # 80008610 <syscalls+0x210>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	fca080e7          	jalr	-54(ra) # 80005dfc <panic>

0000000080002e3a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e3a:	7179                	addi	sp,sp,-48
    80002e3c:	f406                	sd	ra,40(sp)
    80002e3e:	f022                	sd	s0,32(sp)
    80002e40:	ec26                	sd	s1,24(sp)
    80002e42:	e84a                	sd	s2,16(sp)
    80002e44:	e44e                	sd	s3,8(sp)
    80002e46:	e052                	sd	s4,0(sp)
    80002e48:	1800                	addi	s0,sp,48
    80002e4a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e4c:	05050493          	addi	s1,a0,80
    80002e50:	08050913          	addi	s2,a0,128
    80002e54:	a021                	j	80002e5c <itrunc+0x22>
    80002e56:	0491                	addi	s1,s1,4
    80002e58:	01248d63          	beq	s1,s2,80002e72 <itrunc+0x38>
    if(ip->addrs[i]){
    80002e5c:	408c                	lw	a1,0(s1)
    80002e5e:	dde5                	beqz	a1,80002e56 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e60:	0009a503          	lw	a0,0(s3)
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	8f6080e7          	jalr	-1802(ra) # 8000275a <bfree>
      ip->addrs[i] = 0;
    80002e6c:	0004a023          	sw	zero,0(s1)
    80002e70:	b7dd                	j	80002e56 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e72:	0809a583          	lw	a1,128(s3)
    80002e76:	e185                	bnez	a1,80002e96 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002e78:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002e7c:	854e                	mv	a0,s3
    80002e7e:	00000097          	auipc	ra,0x0
    80002e82:	de2080e7          	jalr	-542(ra) # 80002c60 <iupdate>
}
    80002e86:	70a2                	ld	ra,40(sp)
    80002e88:	7402                	ld	s0,32(sp)
    80002e8a:	64e2                	ld	s1,24(sp)
    80002e8c:	6942                	ld	s2,16(sp)
    80002e8e:	69a2                	ld	s3,8(sp)
    80002e90:	6a02                	ld	s4,0(sp)
    80002e92:	6145                	addi	sp,sp,48
    80002e94:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e96:	0009a503          	lw	a0,0(s3)
    80002e9a:	fffff097          	auipc	ra,0xfffff
    80002e9e:	67a080e7          	jalr	1658(ra) # 80002514 <bread>
    80002ea2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ea4:	05850493          	addi	s1,a0,88
    80002ea8:	45850913          	addi	s2,a0,1112
    80002eac:	a021                	j	80002eb4 <itrunc+0x7a>
    80002eae:	0491                	addi	s1,s1,4
    80002eb0:	01248b63          	beq	s1,s2,80002ec6 <itrunc+0x8c>
      if(a[j])
    80002eb4:	408c                	lw	a1,0(s1)
    80002eb6:	dde5                	beqz	a1,80002eae <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002eb8:	0009a503          	lw	a0,0(s3)
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	89e080e7          	jalr	-1890(ra) # 8000275a <bfree>
    80002ec4:	b7ed                	j	80002eae <itrunc+0x74>
    brelse(bp);
    80002ec6:	8552                	mv	a0,s4
    80002ec8:	fffff097          	auipc	ra,0xfffff
    80002ecc:	77c080e7          	jalr	1916(ra) # 80002644 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ed0:	0809a583          	lw	a1,128(s3)
    80002ed4:	0009a503          	lw	a0,0(s3)
    80002ed8:	00000097          	auipc	ra,0x0
    80002edc:	882080e7          	jalr	-1918(ra) # 8000275a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002ee0:	0809a023          	sw	zero,128(s3)
    80002ee4:	bf51                	j	80002e78 <itrunc+0x3e>

0000000080002ee6 <iput>:
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	e04a                	sd	s2,0(sp)
    80002ef0:	1000                	addi	s0,sp,32
    80002ef2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ef4:	00014517          	auipc	a0,0x14
    80002ef8:	1f450513          	addi	a0,a0,500 # 800170e8 <itable>
    80002efc:	00003097          	auipc	ra,0x3
    80002f00:	438080e7          	jalr	1080(ra) # 80006334 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f04:	4498                	lw	a4,8(s1)
    80002f06:	4785                	li	a5,1
    80002f08:	02f70363          	beq	a4,a5,80002f2e <iput+0x48>
  ip->ref--;
    80002f0c:	449c                	lw	a5,8(s1)
    80002f0e:	37fd                	addiw	a5,a5,-1
    80002f10:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f12:	00014517          	auipc	a0,0x14
    80002f16:	1d650513          	addi	a0,a0,470 # 800170e8 <itable>
    80002f1a:	00003097          	auipc	ra,0x3
    80002f1e:	4ce080e7          	jalr	1230(ra) # 800063e8 <release>
}
    80002f22:	60e2                	ld	ra,24(sp)
    80002f24:	6442                	ld	s0,16(sp)
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	6902                	ld	s2,0(sp)
    80002f2a:	6105                	addi	sp,sp,32
    80002f2c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f2e:	40bc                	lw	a5,64(s1)
    80002f30:	dff1                	beqz	a5,80002f0c <iput+0x26>
    80002f32:	04a49783          	lh	a5,74(s1)
    80002f36:	fbf9                	bnez	a5,80002f0c <iput+0x26>
    acquiresleep(&ip->lock);
    80002f38:	01048913          	addi	s2,s1,16
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	00001097          	auipc	ra,0x1
    80002f42:	aae080e7          	jalr	-1362(ra) # 800039ec <acquiresleep>
    release(&itable.lock);
    80002f46:	00014517          	auipc	a0,0x14
    80002f4a:	1a250513          	addi	a0,a0,418 # 800170e8 <itable>
    80002f4e:	00003097          	auipc	ra,0x3
    80002f52:	49a080e7          	jalr	1178(ra) # 800063e8 <release>
    itrunc(ip);
    80002f56:	8526                	mv	a0,s1
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	ee2080e7          	jalr	-286(ra) # 80002e3a <itrunc>
    ip->type = 0;
    80002f60:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	cfa080e7          	jalr	-774(ra) # 80002c60 <iupdate>
    ip->valid = 0;
    80002f6e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f72:	854a                	mv	a0,s2
    80002f74:	00001097          	auipc	ra,0x1
    80002f78:	ace080e7          	jalr	-1330(ra) # 80003a42 <releasesleep>
    acquire(&itable.lock);
    80002f7c:	00014517          	auipc	a0,0x14
    80002f80:	16c50513          	addi	a0,a0,364 # 800170e8 <itable>
    80002f84:	00003097          	auipc	ra,0x3
    80002f88:	3b0080e7          	jalr	944(ra) # 80006334 <acquire>
    80002f8c:	b741                	j	80002f0c <iput+0x26>

0000000080002f8e <iunlockput>:
{
    80002f8e:	1101                	addi	sp,sp,-32
    80002f90:	ec06                	sd	ra,24(sp)
    80002f92:	e822                	sd	s0,16(sp)
    80002f94:	e426                	sd	s1,8(sp)
    80002f96:	1000                	addi	s0,sp,32
    80002f98:	84aa                	mv	s1,a0
  iunlock(ip);
    80002f9a:	00000097          	auipc	ra,0x0
    80002f9e:	e54080e7          	jalr	-428(ra) # 80002dee <iunlock>
  iput(ip);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	f42080e7          	jalr	-190(ra) # 80002ee6 <iput>
}
    80002fac:	60e2                	ld	ra,24(sp)
    80002fae:	6442                	ld	s0,16(sp)
    80002fb0:	64a2                	ld	s1,8(sp)
    80002fb2:	6105                	addi	sp,sp,32
    80002fb4:	8082                	ret

0000000080002fb6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fb6:	1141                	addi	sp,sp,-16
    80002fb8:	e422                	sd	s0,8(sp)
    80002fba:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fbc:	411c                	lw	a5,0(a0)
    80002fbe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fc0:	415c                	lw	a5,4(a0)
    80002fc2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fc4:	04451783          	lh	a5,68(a0)
    80002fc8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fcc:	04a51783          	lh	a5,74(a0)
    80002fd0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fd4:	04c56783          	lwu	a5,76(a0)
    80002fd8:	e99c                	sd	a5,16(a1)
}
    80002fda:	6422                	ld	s0,8(sp)
    80002fdc:	0141                	addi	sp,sp,16
    80002fde:	8082                	ret

0000000080002fe0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fe0:	457c                	lw	a5,76(a0)
    80002fe2:	0ed7e963          	bltu	a5,a3,800030d4 <readi+0xf4>
{
    80002fe6:	7159                	addi	sp,sp,-112
    80002fe8:	f486                	sd	ra,104(sp)
    80002fea:	f0a2                	sd	s0,96(sp)
    80002fec:	eca6                	sd	s1,88(sp)
    80002fee:	e8ca                	sd	s2,80(sp)
    80002ff0:	e4ce                	sd	s3,72(sp)
    80002ff2:	e0d2                	sd	s4,64(sp)
    80002ff4:	fc56                	sd	s5,56(sp)
    80002ff6:	f85a                	sd	s6,48(sp)
    80002ff8:	f45e                	sd	s7,40(sp)
    80002ffa:	f062                	sd	s8,32(sp)
    80002ffc:	ec66                	sd	s9,24(sp)
    80002ffe:	e86a                	sd	s10,16(sp)
    80003000:	e46e                	sd	s11,8(sp)
    80003002:	1880                	addi	s0,sp,112
    80003004:	8b2a                	mv	s6,a0
    80003006:	8bae                	mv	s7,a1
    80003008:	8a32                	mv	s4,a2
    8000300a:	84b6                	mv	s1,a3
    8000300c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000300e:	9f35                	addw	a4,a4,a3
    return 0;
    80003010:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003012:	0ad76063          	bltu	a4,a3,800030b2 <readi+0xd2>
  if(off + n > ip->size)
    80003016:	00e7f463          	bgeu	a5,a4,8000301e <readi+0x3e>
    n = ip->size - off;
    8000301a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000301e:	0a0a8963          	beqz	s5,800030d0 <readi+0xf0>
    80003022:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003024:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003028:	5c7d                	li	s8,-1
    8000302a:	a82d                	j	80003064 <readi+0x84>
    8000302c:	020d1d93          	slli	s11,s10,0x20
    80003030:	020ddd93          	srli	s11,s11,0x20
    80003034:	05890613          	addi	a2,s2,88
    80003038:	86ee                	mv	a3,s11
    8000303a:	963a                	add	a2,a2,a4
    8000303c:	85d2                	mv	a1,s4
    8000303e:	855e                	mv	a0,s7
    80003040:	fffff097          	auipc	ra,0xfffff
    80003044:	a2c080e7          	jalr	-1492(ra) # 80001a6c <either_copyout>
    80003048:	05850d63          	beq	a0,s8,800030a2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000304c:	854a                	mv	a0,s2
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	5f6080e7          	jalr	1526(ra) # 80002644 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003056:	013d09bb          	addw	s3,s10,s3
    8000305a:	009d04bb          	addw	s1,s10,s1
    8000305e:	9a6e                	add	s4,s4,s11
    80003060:	0559f763          	bgeu	s3,s5,800030ae <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003064:	00a4d59b          	srliw	a1,s1,0xa
    80003068:	855a                	mv	a0,s6
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	89e080e7          	jalr	-1890(ra) # 80002908 <bmap>
    80003072:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003076:	cd85                	beqz	a1,800030ae <readi+0xce>
    bp = bread(ip->dev, addr);
    80003078:	000b2503          	lw	a0,0(s6)
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	498080e7          	jalr	1176(ra) # 80002514 <bread>
    80003084:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003086:	3ff4f713          	andi	a4,s1,1023
    8000308a:	40ec87bb          	subw	a5,s9,a4
    8000308e:	413a86bb          	subw	a3,s5,s3
    80003092:	8d3e                	mv	s10,a5
    80003094:	2781                	sext.w	a5,a5
    80003096:	0006861b          	sext.w	a2,a3
    8000309a:	f8f679e3          	bgeu	a2,a5,8000302c <readi+0x4c>
    8000309e:	8d36                	mv	s10,a3
    800030a0:	b771                	j	8000302c <readi+0x4c>
      brelse(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	5a0080e7          	jalr	1440(ra) # 80002644 <brelse>
      tot = -1;
    800030ac:	59fd                	li	s3,-1
  }
  return tot;
    800030ae:	0009851b          	sext.w	a0,s3
}
    800030b2:	70a6                	ld	ra,104(sp)
    800030b4:	7406                	ld	s0,96(sp)
    800030b6:	64e6                	ld	s1,88(sp)
    800030b8:	6946                	ld	s2,80(sp)
    800030ba:	69a6                	ld	s3,72(sp)
    800030bc:	6a06                	ld	s4,64(sp)
    800030be:	7ae2                	ld	s5,56(sp)
    800030c0:	7b42                	ld	s6,48(sp)
    800030c2:	7ba2                	ld	s7,40(sp)
    800030c4:	7c02                	ld	s8,32(sp)
    800030c6:	6ce2                	ld	s9,24(sp)
    800030c8:	6d42                	ld	s10,16(sp)
    800030ca:	6da2                	ld	s11,8(sp)
    800030cc:	6165                	addi	sp,sp,112
    800030ce:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	89d6                	mv	s3,s5
    800030d2:	bff1                	j	800030ae <readi+0xce>
    return 0;
    800030d4:	4501                	li	a0,0
}
    800030d6:	8082                	ret

00000000800030d8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030d8:	457c                	lw	a5,76(a0)
    800030da:	10d7e863          	bltu	a5,a3,800031ea <writei+0x112>
{
    800030de:	7159                	addi	sp,sp,-112
    800030e0:	f486                	sd	ra,104(sp)
    800030e2:	f0a2                	sd	s0,96(sp)
    800030e4:	eca6                	sd	s1,88(sp)
    800030e6:	e8ca                	sd	s2,80(sp)
    800030e8:	e4ce                	sd	s3,72(sp)
    800030ea:	e0d2                	sd	s4,64(sp)
    800030ec:	fc56                	sd	s5,56(sp)
    800030ee:	f85a                	sd	s6,48(sp)
    800030f0:	f45e                	sd	s7,40(sp)
    800030f2:	f062                	sd	s8,32(sp)
    800030f4:	ec66                	sd	s9,24(sp)
    800030f6:	e86a                	sd	s10,16(sp)
    800030f8:	e46e                	sd	s11,8(sp)
    800030fa:	1880                	addi	s0,sp,112
    800030fc:	8aaa                	mv	s5,a0
    800030fe:	8bae                	mv	s7,a1
    80003100:	8a32                	mv	s4,a2
    80003102:	8936                	mv	s2,a3
    80003104:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003106:	00e687bb          	addw	a5,a3,a4
    8000310a:	0ed7e263          	bltu	a5,a3,800031ee <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000310e:	00043737          	lui	a4,0x43
    80003112:	0ef76063          	bltu	a4,a5,800031f2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003116:	0c0b0863          	beqz	s6,800031e6 <writei+0x10e>
    8000311a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000311c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003120:	5c7d                	li	s8,-1
    80003122:	a091                	j	80003166 <writei+0x8e>
    80003124:	020d1d93          	slli	s11,s10,0x20
    80003128:	020ddd93          	srli	s11,s11,0x20
    8000312c:	05848513          	addi	a0,s1,88
    80003130:	86ee                	mv	a3,s11
    80003132:	8652                	mv	a2,s4
    80003134:	85de                	mv	a1,s7
    80003136:	953a                	add	a0,a0,a4
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	98a080e7          	jalr	-1654(ra) # 80001ac2 <either_copyin>
    80003140:	07850263          	beq	a0,s8,800031a4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003144:	8526                	mv	a0,s1
    80003146:	00000097          	auipc	ra,0x0
    8000314a:	788080e7          	jalr	1928(ra) # 800038ce <log_write>
    brelse(bp);
    8000314e:	8526                	mv	a0,s1
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	4f4080e7          	jalr	1268(ra) # 80002644 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003158:	013d09bb          	addw	s3,s10,s3
    8000315c:	012d093b          	addw	s2,s10,s2
    80003160:	9a6e                	add	s4,s4,s11
    80003162:	0569f663          	bgeu	s3,s6,800031ae <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003166:	00a9559b          	srliw	a1,s2,0xa
    8000316a:	8556                	mv	a0,s5
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	79c080e7          	jalr	1948(ra) # 80002908 <bmap>
    80003174:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003178:	c99d                	beqz	a1,800031ae <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000317a:	000aa503          	lw	a0,0(s5)
    8000317e:	fffff097          	auipc	ra,0xfffff
    80003182:	396080e7          	jalr	918(ra) # 80002514 <bread>
    80003186:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003188:	3ff97713          	andi	a4,s2,1023
    8000318c:	40ec87bb          	subw	a5,s9,a4
    80003190:	413b06bb          	subw	a3,s6,s3
    80003194:	8d3e                	mv	s10,a5
    80003196:	2781                	sext.w	a5,a5
    80003198:	0006861b          	sext.w	a2,a3
    8000319c:	f8f674e3          	bgeu	a2,a5,80003124 <writei+0x4c>
    800031a0:	8d36                	mv	s10,a3
    800031a2:	b749                	j	80003124 <writei+0x4c>
      brelse(bp);
    800031a4:	8526                	mv	a0,s1
    800031a6:	fffff097          	auipc	ra,0xfffff
    800031aa:	49e080e7          	jalr	1182(ra) # 80002644 <brelse>
  }

  if(off > ip->size)
    800031ae:	04caa783          	lw	a5,76(s5)
    800031b2:	0127f463          	bgeu	a5,s2,800031ba <writei+0xe2>
    ip->size = off;
    800031b6:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031ba:	8556                	mv	a0,s5
    800031bc:	00000097          	auipc	ra,0x0
    800031c0:	aa4080e7          	jalr	-1372(ra) # 80002c60 <iupdate>

  return tot;
    800031c4:	0009851b          	sext.w	a0,s3
}
    800031c8:	70a6                	ld	ra,104(sp)
    800031ca:	7406                	ld	s0,96(sp)
    800031cc:	64e6                	ld	s1,88(sp)
    800031ce:	6946                	ld	s2,80(sp)
    800031d0:	69a6                	ld	s3,72(sp)
    800031d2:	6a06                	ld	s4,64(sp)
    800031d4:	7ae2                	ld	s5,56(sp)
    800031d6:	7b42                	ld	s6,48(sp)
    800031d8:	7ba2                	ld	s7,40(sp)
    800031da:	7c02                	ld	s8,32(sp)
    800031dc:	6ce2                	ld	s9,24(sp)
    800031de:	6d42                	ld	s10,16(sp)
    800031e0:	6da2                	ld	s11,8(sp)
    800031e2:	6165                	addi	sp,sp,112
    800031e4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031e6:	89da                	mv	s3,s6
    800031e8:	bfc9                	j	800031ba <writei+0xe2>
    return -1;
    800031ea:	557d                	li	a0,-1
}
    800031ec:	8082                	ret
    return -1;
    800031ee:	557d                	li	a0,-1
    800031f0:	bfe1                	j	800031c8 <writei+0xf0>
    return -1;
    800031f2:	557d                	li	a0,-1
    800031f4:	bfd1                	j	800031c8 <writei+0xf0>

00000000800031f6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031f6:	1141                	addi	sp,sp,-16
    800031f8:	e406                	sd	ra,8(sp)
    800031fa:	e022                	sd	s0,0(sp)
    800031fc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031fe:	4639                	li	a2,14
    80003200:	ffffd097          	auipc	ra,0xffffd
    80003204:	04a080e7          	jalr	74(ra) # 8000024a <strncmp>
}
    80003208:	60a2                	ld	ra,8(sp)
    8000320a:	6402                	ld	s0,0(sp)
    8000320c:	0141                	addi	sp,sp,16
    8000320e:	8082                	ret

0000000080003210 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003210:	7139                	addi	sp,sp,-64
    80003212:	fc06                	sd	ra,56(sp)
    80003214:	f822                	sd	s0,48(sp)
    80003216:	f426                	sd	s1,40(sp)
    80003218:	f04a                	sd	s2,32(sp)
    8000321a:	ec4e                	sd	s3,24(sp)
    8000321c:	e852                	sd	s4,16(sp)
    8000321e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003220:	04451703          	lh	a4,68(a0)
    80003224:	4785                	li	a5,1
    80003226:	00f71a63          	bne	a4,a5,8000323a <dirlookup+0x2a>
    8000322a:	892a                	mv	s2,a0
    8000322c:	89ae                	mv	s3,a1
    8000322e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003230:	457c                	lw	a5,76(a0)
    80003232:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003234:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003236:	e79d                	bnez	a5,80003264 <dirlookup+0x54>
    80003238:	a8a5                	j	800032b0 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000323a:	00005517          	auipc	a0,0x5
    8000323e:	3de50513          	addi	a0,a0,990 # 80008618 <syscalls+0x218>
    80003242:	00003097          	auipc	ra,0x3
    80003246:	bba080e7          	jalr	-1094(ra) # 80005dfc <panic>
      panic("dirlookup read");
    8000324a:	00005517          	auipc	a0,0x5
    8000324e:	3e650513          	addi	a0,a0,998 # 80008630 <syscalls+0x230>
    80003252:	00003097          	auipc	ra,0x3
    80003256:	baa080e7          	jalr	-1110(ra) # 80005dfc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325a:	24c1                	addiw	s1,s1,16
    8000325c:	04c92783          	lw	a5,76(s2)
    80003260:	04f4f763          	bgeu	s1,a5,800032ae <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003264:	4741                	li	a4,16
    80003266:	86a6                	mv	a3,s1
    80003268:	fc040613          	addi	a2,s0,-64
    8000326c:	4581                	li	a1,0
    8000326e:	854a                	mv	a0,s2
    80003270:	00000097          	auipc	ra,0x0
    80003274:	d70080e7          	jalr	-656(ra) # 80002fe0 <readi>
    80003278:	47c1                	li	a5,16
    8000327a:	fcf518e3          	bne	a0,a5,8000324a <dirlookup+0x3a>
    if(de.inum == 0)
    8000327e:	fc045783          	lhu	a5,-64(s0)
    80003282:	dfe1                	beqz	a5,8000325a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003284:	fc240593          	addi	a1,s0,-62
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	f6c080e7          	jalr	-148(ra) # 800031f6 <namecmp>
    80003292:	f561                	bnez	a0,8000325a <dirlookup+0x4a>
      if(poff)
    80003294:	000a0463          	beqz	s4,8000329c <dirlookup+0x8c>
        *poff = off;
    80003298:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000329c:	fc045583          	lhu	a1,-64(s0)
    800032a0:	00092503          	lw	a0,0(s2)
    800032a4:	fffff097          	auipc	ra,0xfffff
    800032a8:	74e080e7          	jalr	1870(ra) # 800029f2 <iget>
    800032ac:	a011                	j	800032b0 <dirlookup+0xa0>
  return 0;
    800032ae:	4501                	li	a0,0
}
    800032b0:	70e2                	ld	ra,56(sp)
    800032b2:	7442                	ld	s0,48(sp)
    800032b4:	74a2                	ld	s1,40(sp)
    800032b6:	7902                	ld	s2,32(sp)
    800032b8:	69e2                	ld	s3,24(sp)
    800032ba:	6a42                	ld	s4,16(sp)
    800032bc:	6121                	addi	sp,sp,64
    800032be:	8082                	ret

00000000800032c0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032c0:	711d                	addi	sp,sp,-96
    800032c2:	ec86                	sd	ra,88(sp)
    800032c4:	e8a2                	sd	s0,80(sp)
    800032c6:	e4a6                	sd	s1,72(sp)
    800032c8:	e0ca                	sd	s2,64(sp)
    800032ca:	fc4e                	sd	s3,56(sp)
    800032cc:	f852                	sd	s4,48(sp)
    800032ce:	f456                	sd	s5,40(sp)
    800032d0:	f05a                	sd	s6,32(sp)
    800032d2:	ec5e                	sd	s7,24(sp)
    800032d4:	e862                	sd	s8,16(sp)
    800032d6:	e466                	sd	s9,8(sp)
    800032d8:	e06a                	sd	s10,0(sp)
    800032da:	1080                	addi	s0,sp,96
    800032dc:	84aa                	mv	s1,a0
    800032de:	8b2e                	mv	s6,a1
    800032e0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032e2:	00054703          	lbu	a4,0(a0)
    800032e6:	02f00793          	li	a5,47
    800032ea:	02f70363          	beq	a4,a5,80003310 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ee:	ffffe097          	auipc	ra,0xffffe
    800032f2:	c50080e7          	jalr	-944(ra) # 80000f3e <myproc>
    800032f6:	15853503          	ld	a0,344(a0)
    800032fa:	00000097          	auipc	ra,0x0
    800032fe:	9f4080e7          	jalr	-1548(ra) # 80002cee <idup>
    80003302:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003304:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003308:	4cb5                	li	s9,13
  len = path - s;
    8000330a:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000330c:	4c05                	li	s8,1
    8000330e:	a87d                	j	800033cc <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003310:	4585                	li	a1,1
    80003312:	4505                	li	a0,1
    80003314:	fffff097          	auipc	ra,0xfffff
    80003318:	6de080e7          	jalr	1758(ra) # 800029f2 <iget>
    8000331c:	8a2a                	mv	s4,a0
    8000331e:	b7dd                	j	80003304 <namex+0x44>
      iunlockput(ip);
    80003320:	8552                	mv	a0,s4
    80003322:	00000097          	auipc	ra,0x0
    80003326:	c6c080e7          	jalr	-916(ra) # 80002f8e <iunlockput>
      return 0;
    8000332a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000332c:	8552                	mv	a0,s4
    8000332e:	60e6                	ld	ra,88(sp)
    80003330:	6446                	ld	s0,80(sp)
    80003332:	64a6                	ld	s1,72(sp)
    80003334:	6906                	ld	s2,64(sp)
    80003336:	79e2                	ld	s3,56(sp)
    80003338:	7a42                	ld	s4,48(sp)
    8000333a:	7aa2                	ld	s5,40(sp)
    8000333c:	7b02                	ld	s6,32(sp)
    8000333e:	6be2                	ld	s7,24(sp)
    80003340:	6c42                	ld	s8,16(sp)
    80003342:	6ca2                	ld	s9,8(sp)
    80003344:	6d02                	ld	s10,0(sp)
    80003346:	6125                	addi	sp,sp,96
    80003348:	8082                	ret
      iunlock(ip);
    8000334a:	8552                	mv	a0,s4
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	aa2080e7          	jalr	-1374(ra) # 80002dee <iunlock>
      return ip;
    80003354:	bfe1                	j	8000332c <namex+0x6c>
      iunlockput(ip);
    80003356:	8552                	mv	a0,s4
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	c36080e7          	jalr	-970(ra) # 80002f8e <iunlockput>
      return 0;
    80003360:	8a4e                	mv	s4,s3
    80003362:	b7e9                	j	8000332c <namex+0x6c>
  len = path - s;
    80003364:	40998633          	sub	a2,s3,s1
    80003368:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000336c:	09acd863          	bge	s9,s10,800033fc <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003370:	4639                	li	a2,14
    80003372:	85a6                	mv	a1,s1
    80003374:	8556                	mv	a0,s5
    80003376:	ffffd097          	auipc	ra,0xffffd
    8000337a:	e60080e7          	jalr	-416(ra) # 800001d6 <memmove>
    8000337e:	84ce                	mv	s1,s3
  while(*path == '/')
    80003380:	0004c783          	lbu	a5,0(s1)
    80003384:	01279763          	bne	a5,s2,80003392 <namex+0xd2>
    path++;
    80003388:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000338a:	0004c783          	lbu	a5,0(s1)
    8000338e:	ff278de3          	beq	a5,s2,80003388 <namex+0xc8>
    ilock(ip);
    80003392:	8552                	mv	a0,s4
    80003394:	00000097          	auipc	ra,0x0
    80003398:	998080e7          	jalr	-1640(ra) # 80002d2c <ilock>
    if(ip->type != T_DIR){
    8000339c:	044a1783          	lh	a5,68(s4)
    800033a0:	f98790e3          	bne	a5,s8,80003320 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033a4:	000b0563          	beqz	s6,800033ae <namex+0xee>
    800033a8:	0004c783          	lbu	a5,0(s1)
    800033ac:	dfd9                	beqz	a5,8000334a <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033ae:	865e                	mv	a2,s7
    800033b0:	85d6                	mv	a1,s5
    800033b2:	8552                	mv	a0,s4
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	e5c080e7          	jalr	-420(ra) # 80003210 <dirlookup>
    800033bc:	89aa                	mv	s3,a0
    800033be:	dd41                	beqz	a0,80003356 <namex+0x96>
    iunlockput(ip);
    800033c0:	8552                	mv	a0,s4
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	bcc080e7          	jalr	-1076(ra) # 80002f8e <iunlockput>
    ip = next;
    800033ca:	8a4e                	mv	s4,s3
  while(*path == '/')
    800033cc:	0004c783          	lbu	a5,0(s1)
    800033d0:	01279763          	bne	a5,s2,800033de <namex+0x11e>
    path++;
    800033d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d6:	0004c783          	lbu	a5,0(s1)
    800033da:	ff278de3          	beq	a5,s2,800033d4 <namex+0x114>
  if(*path == 0)
    800033de:	cb9d                	beqz	a5,80003414 <namex+0x154>
  while(*path != '/' && *path != 0)
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	89a6                	mv	s3,s1
  len = path - s;
    800033e6:	8d5e                	mv	s10,s7
    800033e8:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800033ea:	01278963          	beq	a5,s2,800033fc <namex+0x13c>
    800033ee:	dbbd                	beqz	a5,80003364 <namex+0xa4>
    path++;
    800033f0:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800033f2:	0009c783          	lbu	a5,0(s3)
    800033f6:	ff279ce3          	bne	a5,s2,800033ee <namex+0x12e>
    800033fa:	b7ad                	j	80003364 <namex+0xa4>
    memmove(name, s, len);
    800033fc:	2601                	sext.w	a2,a2
    800033fe:	85a6                	mv	a1,s1
    80003400:	8556                	mv	a0,s5
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	dd4080e7          	jalr	-556(ra) # 800001d6 <memmove>
    name[len] = 0;
    8000340a:	9d56                	add	s10,s10,s5
    8000340c:	000d0023          	sb	zero,0(s10)
    80003410:	84ce                	mv	s1,s3
    80003412:	b7bd                	j	80003380 <namex+0xc0>
  if(nameiparent){
    80003414:	f00b0ce3          	beqz	s6,8000332c <namex+0x6c>
    iput(ip);
    80003418:	8552                	mv	a0,s4
    8000341a:	00000097          	auipc	ra,0x0
    8000341e:	acc080e7          	jalr	-1332(ra) # 80002ee6 <iput>
    return 0;
    80003422:	4a01                	li	s4,0
    80003424:	b721                	j	8000332c <namex+0x6c>

0000000080003426 <dirlink>:
{
    80003426:	7139                	addi	sp,sp,-64
    80003428:	fc06                	sd	ra,56(sp)
    8000342a:	f822                	sd	s0,48(sp)
    8000342c:	f426                	sd	s1,40(sp)
    8000342e:	f04a                	sd	s2,32(sp)
    80003430:	ec4e                	sd	s3,24(sp)
    80003432:	e852                	sd	s4,16(sp)
    80003434:	0080                	addi	s0,sp,64
    80003436:	892a                	mv	s2,a0
    80003438:	8a2e                	mv	s4,a1
    8000343a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000343c:	4601                	li	a2,0
    8000343e:	00000097          	auipc	ra,0x0
    80003442:	dd2080e7          	jalr	-558(ra) # 80003210 <dirlookup>
    80003446:	e93d                	bnez	a0,800034bc <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003448:	04c92483          	lw	s1,76(s2)
    8000344c:	c49d                	beqz	s1,8000347a <dirlink+0x54>
    8000344e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003450:	4741                	li	a4,16
    80003452:	86a6                	mv	a3,s1
    80003454:	fc040613          	addi	a2,s0,-64
    80003458:	4581                	li	a1,0
    8000345a:	854a                	mv	a0,s2
    8000345c:	00000097          	auipc	ra,0x0
    80003460:	b84080e7          	jalr	-1148(ra) # 80002fe0 <readi>
    80003464:	47c1                	li	a5,16
    80003466:	06f51163          	bne	a0,a5,800034c8 <dirlink+0xa2>
    if(de.inum == 0)
    8000346a:	fc045783          	lhu	a5,-64(s0)
    8000346e:	c791                	beqz	a5,8000347a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003470:	24c1                	addiw	s1,s1,16
    80003472:	04c92783          	lw	a5,76(s2)
    80003476:	fcf4ede3          	bltu	s1,a5,80003450 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000347a:	4639                	li	a2,14
    8000347c:	85d2                	mv	a1,s4
    8000347e:	fc240513          	addi	a0,s0,-62
    80003482:	ffffd097          	auipc	ra,0xffffd
    80003486:	e04080e7          	jalr	-508(ra) # 80000286 <strncpy>
  de.inum = inum;
    8000348a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348e:	4741                	li	a4,16
    80003490:	86a6                	mv	a3,s1
    80003492:	fc040613          	addi	a2,s0,-64
    80003496:	4581                	li	a1,0
    80003498:	854a                	mv	a0,s2
    8000349a:	00000097          	auipc	ra,0x0
    8000349e:	c3e080e7          	jalr	-962(ra) # 800030d8 <writei>
    800034a2:	1541                	addi	a0,a0,-16
    800034a4:	00a03533          	snez	a0,a0
    800034a8:	40a00533          	neg	a0,a0
}
    800034ac:	70e2                	ld	ra,56(sp)
    800034ae:	7442                	ld	s0,48(sp)
    800034b0:	74a2                	ld	s1,40(sp)
    800034b2:	7902                	ld	s2,32(sp)
    800034b4:	69e2                	ld	s3,24(sp)
    800034b6:	6a42                	ld	s4,16(sp)
    800034b8:	6121                	addi	sp,sp,64
    800034ba:	8082                	ret
    iput(ip);
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	a2a080e7          	jalr	-1494(ra) # 80002ee6 <iput>
    return -1;
    800034c4:	557d                	li	a0,-1
    800034c6:	b7dd                	j	800034ac <dirlink+0x86>
      panic("dirlink read");
    800034c8:	00005517          	auipc	a0,0x5
    800034cc:	17850513          	addi	a0,a0,376 # 80008640 <syscalls+0x240>
    800034d0:	00003097          	auipc	ra,0x3
    800034d4:	92c080e7          	jalr	-1748(ra) # 80005dfc <panic>

00000000800034d8 <namei>:

struct inode*
namei(char *path)
{
    800034d8:	1101                	addi	sp,sp,-32
    800034da:	ec06                	sd	ra,24(sp)
    800034dc:	e822                	sd	s0,16(sp)
    800034de:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034e0:	fe040613          	addi	a2,s0,-32
    800034e4:	4581                	li	a1,0
    800034e6:	00000097          	auipc	ra,0x0
    800034ea:	dda080e7          	jalr	-550(ra) # 800032c0 <namex>
}
    800034ee:	60e2                	ld	ra,24(sp)
    800034f0:	6442                	ld	s0,16(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034f6:	1141                	addi	sp,sp,-16
    800034f8:	e406                	sd	ra,8(sp)
    800034fa:	e022                	sd	s0,0(sp)
    800034fc:	0800                	addi	s0,sp,16
    800034fe:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003500:	4585                	li	a1,1
    80003502:	00000097          	auipc	ra,0x0
    80003506:	dbe080e7          	jalr	-578(ra) # 800032c0 <namex>
}
    8000350a:	60a2                	ld	ra,8(sp)
    8000350c:	6402                	ld	s0,0(sp)
    8000350e:	0141                	addi	sp,sp,16
    80003510:	8082                	ret

0000000080003512 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003512:	1101                	addi	sp,sp,-32
    80003514:	ec06                	sd	ra,24(sp)
    80003516:	e822                	sd	s0,16(sp)
    80003518:	e426                	sd	s1,8(sp)
    8000351a:	e04a                	sd	s2,0(sp)
    8000351c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000351e:	00015917          	auipc	s2,0x15
    80003522:	67290913          	addi	s2,s2,1650 # 80018b90 <log>
    80003526:	01892583          	lw	a1,24(s2)
    8000352a:	02892503          	lw	a0,40(s2)
    8000352e:	fffff097          	auipc	ra,0xfffff
    80003532:	fe6080e7          	jalr	-26(ra) # 80002514 <bread>
    80003536:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003538:	02c92683          	lw	a3,44(s2)
    8000353c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	02d05863          	blez	a3,8000356e <write_head+0x5c>
    80003542:	00015797          	auipc	a5,0x15
    80003546:	67e78793          	addi	a5,a5,1662 # 80018bc0 <log+0x30>
    8000354a:	05c50713          	addi	a4,a0,92
    8000354e:	36fd                	addiw	a3,a3,-1
    80003550:	02069613          	slli	a2,a3,0x20
    80003554:	01e65693          	srli	a3,a2,0x1e
    80003558:	00015617          	auipc	a2,0x15
    8000355c:	66c60613          	addi	a2,a2,1644 # 80018bc4 <log+0x34>
    80003560:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003562:	4390                	lw	a2,0(a5)
    80003564:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	0791                	addi	a5,a5,4
    80003568:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    8000356a:	fed79ce3          	bne	a5,a3,80003562 <write_head+0x50>
  }
  bwrite(buf);
    8000356e:	8526                	mv	a0,s1
    80003570:	fffff097          	auipc	ra,0xfffff
    80003574:	096080e7          	jalr	150(ra) # 80002606 <bwrite>
  brelse(buf);
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	0ca080e7          	jalr	202(ra) # 80002644 <brelse>
}
    80003582:	60e2                	ld	ra,24(sp)
    80003584:	6442                	ld	s0,16(sp)
    80003586:	64a2                	ld	s1,8(sp)
    80003588:	6902                	ld	s2,0(sp)
    8000358a:	6105                	addi	sp,sp,32
    8000358c:	8082                	ret

000000008000358e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000358e:	00015797          	auipc	a5,0x15
    80003592:	62e7a783          	lw	a5,1582(a5) # 80018bbc <log+0x2c>
    80003596:	0af05d63          	blez	a5,80003650 <install_trans+0xc2>
{
    8000359a:	7139                	addi	sp,sp,-64
    8000359c:	fc06                	sd	ra,56(sp)
    8000359e:	f822                	sd	s0,48(sp)
    800035a0:	f426                	sd	s1,40(sp)
    800035a2:	f04a                	sd	s2,32(sp)
    800035a4:	ec4e                	sd	s3,24(sp)
    800035a6:	e852                	sd	s4,16(sp)
    800035a8:	e456                	sd	s5,8(sp)
    800035aa:	e05a                	sd	s6,0(sp)
    800035ac:	0080                	addi	s0,sp,64
    800035ae:	8b2a                	mv	s6,a0
    800035b0:	00015a97          	auipc	s5,0x15
    800035b4:	610a8a93          	addi	s5,s5,1552 # 80018bc0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035ba:	00015997          	auipc	s3,0x15
    800035be:	5d698993          	addi	s3,s3,1494 # 80018b90 <log>
    800035c2:	a00d                	j	800035e4 <install_trans+0x56>
    brelse(lbuf);
    800035c4:	854a                	mv	a0,s2
    800035c6:	fffff097          	auipc	ra,0xfffff
    800035ca:	07e080e7          	jalr	126(ra) # 80002644 <brelse>
    brelse(dbuf);
    800035ce:	8526                	mv	a0,s1
    800035d0:	fffff097          	auipc	ra,0xfffff
    800035d4:	074080e7          	jalr	116(ra) # 80002644 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035d8:	2a05                	addiw	s4,s4,1
    800035da:	0a91                	addi	s5,s5,4
    800035dc:	02c9a783          	lw	a5,44(s3)
    800035e0:	04fa5e63          	bge	s4,a5,8000363c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035e4:	0189a583          	lw	a1,24(s3)
    800035e8:	014585bb          	addw	a1,a1,s4
    800035ec:	2585                	addiw	a1,a1,1
    800035ee:	0289a503          	lw	a0,40(s3)
    800035f2:	fffff097          	auipc	ra,0xfffff
    800035f6:	f22080e7          	jalr	-222(ra) # 80002514 <bread>
    800035fa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035fc:	000aa583          	lw	a1,0(s5)
    80003600:	0289a503          	lw	a0,40(s3)
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	f10080e7          	jalr	-240(ra) # 80002514 <bread>
    8000360c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000360e:	40000613          	li	a2,1024
    80003612:	05890593          	addi	a1,s2,88
    80003616:	05850513          	addi	a0,a0,88
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	bbc080e7          	jalr	-1092(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003622:	8526                	mv	a0,s1
    80003624:	fffff097          	auipc	ra,0xfffff
    80003628:	fe2080e7          	jalr	-30(ra) # 80002606 <bwrite>
    if(recovering == 0)
    8000362c:	f80b1ce3          	bnez	s6,800035c4 <install_trans+0x36>
      bunpin(dbuf);
    80003630:	8526                	mv	a0,s1
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	0ec080e7          	jalr	236(ra) # 8000271e <bunpin>
    8000363a:	b769                	j	800035c4 <install_trans+0x36>
}
    8000363c:	70e2                	ld	ra,56(sp)
    8000363e:	7442                	ld	s0,48(sp)
    80003640:	74a2                	ld	s1,40(sp)
    80003642:	7902                	ld	s2,32(sp)
    80003644:	69e2                	ld	s3,24(sp)
    80003646:	6a42                	ld	s4,16(sp)
    80003648:	6aa2                	ld	s5,8(sp)
    8000364a:	6b02                	ld	s6,0(sp)
    8000364c:	6121                	addi	sp,sp,64
    8000364e:	8082                	ret
    80003650:	8082                	ret

0000000080003652 <initlog>:
{
    80003652:	7179                	addi	sp,sp,-48
    80003654:	f406                	sd	ra,40(sp)
    80003656:	f022                	sd	s0,32(sp)
    80003658:	ec26                	sd	s1,24(sp)
    8000365a:	e84a                	sd	s2,16(sp)
    8000365c:	e44e                	sd	s3,8(sp)
    8000365e:	1800                	addi	s0,sp,48
    80003660:	892a                	mv	s2,a0
    80003662:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003664:	00015497          	auipc	s1,0x15
    80003668:	52c48493          	addi	s1,s1,1324 # 80018b90 <log>
    8000366c:	00005597          	auipc	a1,0x5
    80003670:	fe458593          	addi	a1,a1,-28 # 80008650 <syscalls+0x250>
    80003674:	8526                	mv	a0,s1
    80003676:	00003097          	auipc	ra,0x3
    8000367a:	c2e080e7          	jalr	-978(ra) # 800062a4 <initlock>
  log.start = sb->logstart;
    8000367e:	0149a583          	lw	a1,20(s3)
    80003682:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003684:	0109a783          	lw	a5,16(s3)
    80003688:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000368a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000368e:	854a                	mv	a0,s2
    80003690:	fffff097          	auipc	ra,0xfffff
    80003694:	e84080e7          	jalr	-380(ra) # 80002514 <bread>
  log.lh.n = lh->n;
    80003698:	4d34                	lw	a3,88(a0)
    8000369a:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000369c:	02d05663          	blez	a3,800036c8 <initlog+0x76>
    800036a0:	05c50793          	addi	a5,a0,92
    800036a4:	00015717          	auipc	a4,0x15
    800036a8:	51c70713          	addi	a4,a4,1308 # 80018bc0 <log+0x30>
    800036ac:	36fd                	addiw	a3,a3,-1
    800036ae:	02069613          	slli	a2,a3,0x20
    800036b2:	01e65693          	srli	a3,a2,0x1e
    800036b6:	06050613          	addi	a2,a0,96
    800036ba:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800036bc:	4390                	lw	a2,0(a5)
    800036be:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036c0:	0791                	addi	a5,a5,4
    800036c2:	0711                	addi	a4,a4,4
    800036c4:	fed79ce3          	bne	a5,a3,800036bc <initlog+0x6a>
  brelse(buf);
    800036c8:	fffff097          	auipc	ra,0xfffff
    800036cc:	f7c080e7          	jalr	-132(ra) # 80002644 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036d0:	4505                	li	a0,1
    800036d2:	00000097          	auipc	ra,0x0
    800036d6:	ebc080e7          	jalr	-324(ra) # 8000358e <install_trans>
  log.lh.n = 0;
    800036da:	00015797          	auipc	a5,0x15
    800036de:	4e07a123          	sw	zero,1250(a5) # 80018bbc <log+0x2c>
  write_head(); // clear the log
    800036e2:	00000097          	auipc	ra,0x0
    800036e6:	e30080e7          	jalr	-464(ra) # 80003512 <write_head>
}
    800036ea:	70a2                	ld	ra,40(sp)
    800036ec:	7402                	ld	s0,32(sp)
    800036ee:	64e2                	ld	s1,24(sp)
    800036f0:	6942                	ld	s2,16(sp)
    800036f2:	69a2                	ld	s3,8(sp)
    800036f4:	6145                	addi	sp,sp,48
    800036f6:	8082                	ret

00000000800036f8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036f8:	1101                	addi	sp,sp,-32
    800036fa:	ec06                	sd	ra,24(sp)
    800036fc:	e822                	sd	s0,16(sp)
    800036fe:	e426                	sd	s1,8(sp)
    80003700:	e04a                	sd	s2,0(sp)
    80003702:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003704:	00015517          	auipc	a0,0x15
    80003708:	48c50513          	addi	a0,a0,1164 # 80018b90 <log>
    8000370c:	00003097          	auipc	ra,0x3
    80003710:	c28080e7          	jalr	-984(ra) # 80006334 <acquire>
  while(1){
    if(log.committing){
    80003714:	00015497          	auipc	s1,0x15
    80003718:	47c48493          	addi	s1,s1,1148 # 80018b90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000371c:	4979                	li	s2,30
    8000371e:	a039                	j	8000372c <begin_op+0x34>
      sleep(&log, &log.lock);
    80003720:	85a6                	mv	a1,s1
    80003722:	8526                	mv	a0,s1
    80003724:	ffffe097          	auipc	ra,0xffffe
    80003728:	f40080e7          	jalr	-192(ra) # 80001664 <sleep>
    if(log.committing){
    8000372c:	50dc                	lw	a5,36(s1)
    8000372e:	fbed                	bnez	a5,80003720 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003730:	5098                	lw	a4,32(s1)
    80003732:	2705                	addiw	a4,a4,1
    80003734:	0007069b          	sext.w	a3,a4
    80003738:	0027179b          	slliw	a5,a4,0x2
    8000373c:	9fb9                	addw	a5,a5,a4
    8000373e:	0017979b          	slliw	a5,a5,0x1
    80003742:	54d8                	lw	a4,44(s1)
    80003744:	9fb9                	addw	a5,a5,a4
    80003746:	00f95963          	bge	s2,a5,80003758 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000374a:	85a6                	mv	a1,s1
    8000374c:	8526                	mv	a0,s1
    8000374e:	ffffe097          	auipc	ra,0xffffe
    80003752:	f16080e7          	jalr	-234(ra) # 80001664 <sleep>
    80003756:	bfd9                	j	8000372c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003758:	00015517          	auipc	a0,0x15
    8000375c:	43850513          	addi	a0,a0,1080 # 80018b90 <log>
    80003760:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003762:	00003097          	auipc	ra,0x3
    80003766:	c86080e7          	jalr	-890(ra) # 800063e8 <release>
      break;
    }
  }
}
    8000376a:	60e2                	ld	ra,24(sp)
    8000376c:	6442                	ld	s0,16(sp)
    8000376e:	64a2                	ld	s1,8(sp)
    80003770:	6902                	ld	s2,0(sp)
    80003772:	6105                	addi	sp,sp,32
    80003774:	8082                	ret

0000000080003776 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003776:	7139                	addi	sp,sp,-64
    80003778:	fc06                	sd	ra,56(sp)
    8000377a:	f822                	sd	s0,48(sp)
    8000377c:	f426                	sd	s1,40(sp)
    8000377e:	f04a                	sd	s2,32(sp)
    80003780:	ec4e                	sd	s3,24(sp)
    80003782:	e852                	sd	s4,16(sp)
    80003784:	e456                	sd	s5,8(sp)
    80003786:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003788:	00015497          	auipc	s1,0x15
    8000378c:	40848493          	addi	s1,s1,1032 # 80018b90 <log>
    80003790:	8526                	mv	a0,s1
    80003792:	00003097          	auipc	ra,0x3
    80003796:	ba2080e7          	jalr	-1118(ra) # 80006334 <acquire>
  log.outstanding -= 1;
    8000379a:	509c                	lw	a5,32(s1)
    8000379c:	37fd                	addiw	a5,a5,-1
    8000379e:	0007891b          	sext.w	s2,a5
    800037a2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037a4:	50dc                	lw	a5,36(s1)
    800037a6:	e7b9                	bnez	a5,800037f4 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037a8:	04091e63          	bnez	s2,80003804 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037ac:	00015497          	auipc	s1,0x15
    800037b0:	3e448493          	addi	s1,s1,996 # 80018b90 <log>
    800037b4:	4785                	li	a5,1
    800037b6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037b8:	8526                	mv	a0,s1
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	c2e080e7          	jalr	-978(ra) # 800063e8 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037c2:	54dc                	lw	a5,44(s1)
    800037c4:	06f04763          	bgtz	a5,80003832 <end_op+0xbc>
    acquire(&log.lock);
    800037c8:	00015497          	auipc	s1,0x15
    800037cc:	3c848493          	addi	s1,s1,968 # 80018b90 <log>
    800037d0:	8526                	mv	a0,s1
    800037d2:	00003097          	auipc	ra,0x3
    800037d6:	b62080e7          	jalr	-1182(ra) # 80006334 <acquire>
    log.committing = 0;
    800037da:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800037de:	8526                	mv	a0,s1
    800037e0:	ffffe097          	auipc	ra,0xffffe
    800037e4:	ee8080e7          	jalr	-280(ra) # 800016c8 <wakeup>
    release(&log.lock);
    800037e8:	8526                	mv	a0,s1
    800037ea:	00003097          	auipc	ra,0x3
    800037ee:	bfe080e7          	jalr	-1026(ra) # 800063e8 <release>
}
    800037f2:	a03d                	j	80003820 <end_op+0xaa>
    panic("log.committing");
    800037f4:	00005517          	auipc	a0,0x5
    800037f8:	e6450513          	addi	a0,a0,-412 # 80008658 <syscalls+0x258>
    800037fc:	00002097          	auipc	ra,0x2
    80003800:	600080e7          	jalr	1536(ra) # 80005dfc <panic>
    wakeup(&log);
    80003804:	00015497          	auipc	s1,0x15
    80003808:	38c48493          	addi	s1,s1,908 # 80018b90 <log>
    8000380c:	8526                	mv	a0,s1
    8000380e:	ffffe097          	auipc	ra,0xffffe
    80003812:	eba080e7          	jalr	-326(ra) # 800016c8 <wakeup>
  release(&log.lock);
    80003816:	8526                	mv	a0,s1
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	bd0080e7          	jalr	-1072(ra) # 800063e8 <release>
}
    80003820:	70e2                	ld	ra,56(sp)
    80003822:	7442                	ld	s0,48(sp)
    80003824:	74a2                	ld	s1,40(sp)
    80003826:	7902                	ld	s2,32(sp)
    80003828:	69e2                	ld	s3,24(sp)
    8000382a:	6a42                	ld	s4,16(sp)
    8000382c:	6aa2                	ld	s5,8(sp)
    8000382e:	6121                	addi	sp,sp,64
    80003830:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003832:	00015a97          	auipc	s5,0x15
    80003836:	38ea8a93          	addi	s5,s5,910 # 80018bc0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000383a:	00015a17          	auipc	s4,0x15
    8000383e:	356a0a13          	addi	s4,s4,854 # 80018b90 <log>
    80003842:	018a2583          	lw	a1,24(s4)
    80003846:	012585bb          	addw	a1,a1,s2
    8000384a:	2585                	addiw	a1,a1,1
    8000384c:	028a2503          	lw	a0,40(s4)
    80003850:	fffff097          	auipc	ra,0xfffff
    80003854:	cc4080e7          	jalr	-828(ra) # 80002514 <bread>
    80003858:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000385a:	000aa583          	lw	a1,0(s5)
    8000385e:	028a2503          	lw	a0,40(s4)
    80003862:	fffff097          	auipc	ra,0xfffff
    80003866:	cb2080e7          	jalr	-846(ra) # 80002514 <bread>
    8000386a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000386c:	40000613          	li	a2,1024
    80003870:	05850593          	addi	a1,a0,88
    80003874:	05848513          	addi	a0,s1,88
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	95e080e7          	jalr	-1698(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003880:	8526                	mv	a0,s1
    80003882:	fffff097          	auipc	ra,0xfffff
    80003886:	d84080e7          	jalr	-636(ra) # 80002606 <bwrite>
    brelse(from);
    8000388a:	854e                	mv	a0,s3
    8000388c:	fffff097          	auipc	ra,0xfffff
    80003890:	db8080e7          	jalr	-584(ra) # 80002644 <brelse>
    brelse(to);
    80003894:	8526                	mv	a0,s1
    80003896:	fffff097          	auipc	ra,0xfffff
    8000389a:	dae080e7          	jalr	-594(ra) # 80002644 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000389e:	2905                	addiw	s2,s2,1
    800038a0:	0a91                	addi	s5,s5,4
    800038a2:	02ca2783          	lw	a5,44(s4)
    800038a6:	f8f94ee3          	blt	s2,a5,80003842 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	c68080e7          	jalr	-920(ra) # 80003512 <write_head>
    install_trans(0); // Now install writes to home locations
    800038b2:	4501                	li	a0,0
    800038b4:	00000097          	auipc	ra,0x0
    800038b8:	cda080e7          	jalr	-806(ra) # 8000358e <install_trans>
    log.lh.n = 0;
    800038bc:	00015797          	auipc	a5,0x15
    800038c0:	3007a023          	sw	zero,768(a5) # 80018bbc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038c4:	00000097          	auipc	ra,0x0
    800038c8:	c4e080e7          	jalr	-946(ra) # 80003512 <write_head>
    800038cc:	bdf5                	j	800037c8 <end_op+0x52>

00000000800038ce <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038ce:	1101                	addi	sp,sp,-32
    800038d0:	ec06                	sd	ra,24(sp)
    800038d2:	e822                	sd	s0,16(sp)
    800038d4:	e426                	sd	s1,8(sp)
    800038d6:	e04a                	sd	s2,0(sp)
    800038d8:	1000                	addi	s0,sp,32
    800038da:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800038dc:	00015917          	auipc	s2,0x15
    800038e0:	2b490913          	addi	s2,s2,692 # 80018b90 <log>
    800038e4:	854a                	mv	a0,s2
    800038e6:	00003097          	auipc	ra,0x3
    800038ea:	a4e080e7          	jalr	-1458(ra) # 80006334 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800038ee:	02c92603          	lw	a2,44(s2)
    800038f2:	47f5                	li	a5,29
    800038f4:	06c7c563          	blt	a5,a2,8000395e <log_write+0x90>
    800038f8:	00015797          	auipc	a5,0x15
    800038fc:	2b47a783          	lw	a5,692(a5) # 80018bac <log+0x1c>
    80003900:	37fd                	addiw	a5,a5,-1
    80003902:	04f65e63          	bge	a2,a5,8000395e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003906:	00015797          	auipc	a5,0x15
    8000390a:	2aa7a783          	lw	a5,682(a5) # 80018bb0 <log+0x20>
    8000390e:	06f05063          	blez	a5,8000396e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003912:	4781                	li	a5,0
    80003914:	06c05563          	blez	a2,8000397e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003918:	44cc                	lw	a1,12(s1)
    8000391a:	00015717          	auipc	a4,0x15
    8000391e:	2a670713          	addi	a4,a4,678 # 80018bc0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003922:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003924:	4314                	lw	a3,0(a4)
    80003926:	04b68c63          	beq	a3,a1,8000397e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000392a:	2785                	addiw	a5,a5,1
    8000392c:	0711                	addi	a4,a4,4
    8000392e:	fef61be3          	bne	a2,a5,80003924 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003932:	0621                	addi	a2,a2,8
    80003934:	060a                	slli	a2,a2,0x2
    80003936:	00015797          	auipc	a5,0x15
    8000393a:	25a78793          	addi	a5,a5,602 # 80018b90 <log>
    8000393e:	97b2                	add	a5,a5,a2
    80003940:	44d8                	lw	a4,12(s1)
    80003942:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003944:	8526                	mv	a0,s1
    80003946:	fffff097          	auipc	ra,0xfffff
    8000394a:	d9c080e7          	jalr	-612(ra) # 800026e2 <bpin>
    log.lh.n++;
    8000394e:	00015717          	auipc	a4,0x15
    80003952:	24270713          	addi	a4,a4,578 # 80018b90 <log>
    80003956:	575c                	lw	a5,44(a4)
    80003958:	2785                	addiw	a5,a5,1
    8000395a:	d75c                	sw	a5,44(a4)
    8000395c:	a82d                	j	80003996 <log_write+0xc8>
    panic("too big a transaction");
    8000395e:	00005517          	auipc	a0,0x5
    80003962:	d0a50513          	addi	a0,a0,-758 # 80008668 <syscalls+0x268>
    80003966:	00002097          	auipc	ra,0x2
    8000396a:	496080e7          	jalr	1174(ra) # 80005dfc <panic>
    panic("log_write outside of trans");
    8000396e:	00005517          	auipc	a0,0x5
    80003972:	d1250513          	addi	a0,a0,-750 # 80008680 <syscalls+0x280>
    80003976:	00002097          	auipc	ra,0x2
    8000397a:	486080e7          	jalr	1158(ra) # 80005dfc <panic>
  log.lh.block[i] = b->blockno;
    8000397e:	00878693          	addi	a3,a5,8
    80003982:	068a                	slli	a3,a3,0x2
    80003984:	00015717          	auipc	a4,0x15
    80003988:	20c70713          	addi	a4,a4,524 # 80018b90 <log>
    8000398c:	9736                	add	a4,a4,a3
    8000398e:	44d4                	lw	a3,12(s1)
    80003990:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003992:	faf609e3          	beq	a2,a5,80003944 <log_write+0x76>
  }
  release(&log.lock);
    80003996:	00015517          	auipc	a0,0x15
    8000399a:	1fa50513          	addi	a0,a0,506 # 80018b90 <log>
    8000399e:	00003097          	auipc	ra,0x3
    800039a2:	a4a080e7          	jalr	-1462(ra) # 800063e8 <release>
}
    800039a6:	60e2                	ld	ra,24(sp)
    800039a8:	6442                	ld	s0,16(sp)
    800039aa:	64a2                	ld	s1,8(sp)
    800039ac:	6902                	ld	s2,0(sp)
    800039ae:	6105                	addi	sp,sp,32
    800039b0:	8082                	ret

00000000800039b2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	e04a                	sd	s2,0(sp)
    800039bc:	1000                	addi	s0,sp,32
    800039be:	84aa                	mv	s1,a0
    800039c0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039c2:	00005597          	auipc	a1,0x5
    800039c6:	cde58593          	addi	a1,a1,-802 # 800086a0 <syscalls+0x2a0>
    800039ca:	0521                	addi	a0,a0,8
    800039cc:	00003097          	auipc	ra,0x3
    800039d0:	8d8080e7          	jalr	-1832(ra) # 800062a4 <initlock>
  lk->name = name;
    800039d4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039d8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039dc:	0204a423          	sw	zero,40(s1)
}
    800039e0:	60e2                	ld	ra,24(sp)
    800039e2:	6442                	ld	s0,16(sp)
    800039e4:	64a2                	ld	s1,8(sp)
    800039e6:	6902                	ld	s2,0(sp)
    800039e8:	6105                	addi	sp,sp,32
    800039ea:	8082                	ret

00000000800039ec <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	e04a                	sd	s2,0(sp)
    800039f6:	1000                	addi	s0,sp,32
    800039f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039fa:	00850913          	addi	s2,a0,8
    800039fe:	854a                	mv	a0,s2
    80003a00:	00003097          	auipc	ra,0x3
    80003a04:	934080e7          	jalr	-1740(ra) # 80006334 <acquire>
  while (lk->locked) {
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	cb89                	beqz	a5,80003a1c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a0c:	85ca                	mv	a1,s2
    80003a0e:	8526                	mv	a0,s1
    80003a10:	ffffe097          	auipc	ra,0xffffe
    80003a14:	c54080e7          	jalr	-940(ra) # 80001664 <sleep>
  while (lk->locked) {
    80003a18:	409c                	lw	a5,0(s1)
    80003a1a:	fbed                	bnez	a5,80003a0c <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a1c:	4785                	li	a5,1
    80003a1e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a20:	ffffd097          	auipc	ra,0xffffd
    80003a24:	51e080e7          	jalr	1310(ra) # 80000f3e <myproc>
    80003a28:	5d1c                	lw	a5,56(a0)
    80003a2a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a2c:	854a                	mv	a0,s2
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	9ba080e7          	jalr	-1606(ra) # 800063e8 <release>
}
    80003a36:	60e2                	ld	ra,24(sp)
    80003a38:	6442                	ld	s0,16(sp)
    80003a3a:	64a2                	ld	s1,8(sp)
    80003a3c:	6902                	ld	s2,0(sp)
    80003a3e:	6105                	addi	sp,sp,32
    80003a40:	8082                	ret

0000000080003a42 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a42:	1101                	addi	sp,sp,-32
    80003a44:	ec06                	sd	ra,24(sp)
    80003a46:	e822                	sd	s0,16(sp)
    80003a48:	e426                	sd	s1,8(sp)
    80003a4a:	e04a                	sd	s2,0(sp)
    80003a4c:	1000                	addi	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a50:	00850913          	addi	s2,a0,8
    80003a54:	854a                	mv	a0,s2
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	8de080e7          	jalr	-1826(ra) # 80006334 <acquire>
  lk->locked = 0;
    80003a5e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a62:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a66:	8526                	mv	a0,s1
    80003a68:	ffffe097          	auipc	ra,0xffffe
    80003a6c:	c60080e7          	jalr	-928(ra) # 800016c8 <wakeup>
  release(&lk->lk);
    80003a70:	854a                	mv	a0,s2
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	976080e7          	jalr	-1674(ra) # 800063e8 <release>
}
    80003a7a:	60e2                	ld	ra,24(sp)
    80003a7c:	6442                	ld	s0,16(sp)
    80003a7e:	64a2                	ld	s1,8(sp)
    80003a80:	6902                	ld	s2,0(sp)
    80003a82:	6105                	addi	sp,sp,32
    80003a84:	8082                	ret

0000000080003a86 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003a86:	7179                	addi	sp,sp,-48
    80003a88:	f406                	sd	ra,40(sp)
    80003a8a:	f022                	sd	s0,32(sp)
    80003a8c:	ec26                	sd	s1,24(sp)
    80003a8e:	e84a                	sd	s2,16(sp)
    80003a90:	e44e                	sd	s3,8(sp)
    80003a92:	1800                	addi	s0,sp,48
    80003a94:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003a96:	00850913          	addi	s2,a0,8
    80003a9a:	854a                	mv	a0,s2
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	898080e7          	jalr	-1896(ra) # 80006334 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aa4:	409c                	lw	a5,0(s1)
    80003aa6:	ef99                	bnez	a5,80003ac4 <holdingsleep+0x3e>
    80003aa8:	4481                	li	s1,0
  release(&lk->lk);
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	93c080e7          	jalr	-1732(ra) # 800063e8 <release>
  return r;
}
    80003ab4:	8526                	mv	a0,s1
    80003ab6:	70a2                	ld	ra,40(sp)
    80003ab8:	7402                	ld	s0,32(sp)
    80003aba:	64e2                	ld	s1,24(sp)
    80003abc:	6942                	ld	s2,16(sp)
    80003abe:	69a2                	ld	s3,8(sp)
    80003ac0:	6145                	addi	sp,sp,48
    80003ac2:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ac4:	0284a983          	lw	s3,40(s1)
    80003ac8:	ffffd097          	auipc	ra,0xffffd
    80003acc:	476080e7          	jalr	1142(ra) # 80000f3e <myproc>
    80003ad0:	5d04                	lw	s1,56(a0)
    80003ad2:	413484b3          	sub	s1,s1,s3
    80003ad6:	0014b493          	seqz	s1,s1
    80003ada:	bfc1                	j	80003aaa <holdingsleep+0x24>

0000000080003adc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003adc:	1141                	addi	sp,sp,-16
    80003ade:	e406                	sd	ra,8(sp)
    80003ae0:	e022                	sd	s0,0(sp)
    80003ae2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003ae4:	00005597          	auipc	a1,0x5
    80003ae8:	bcc58593          	addi	a1,a1,-1076 # 800086b0 <syscalls+0x2b0>
    80003aec:	00015517          	auipc	a0,0x15
    80003af0:	1ec50513          	addi	a0,a0,492 # 80018cd8 <ftable>
    80003af4:	00002097          	auipc	ra,0x2
    80003af8:	7b0080e7          	jalr	1968(ra) # 800062a4 <initlock>
}
    80003afc:	60a2                	ld	ra,8(sp)
    80003afe:	6402                	ld	s0,0(sp)
    80003b00:	0141                	addi	sp,sp,16
    80003b02:	8082                	ret

0000000080003b04 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b04:	1101                	addi	sp,sp,-32
    80003b06:	ec06                	sd	ra,24(sp)
    80003b08:	e822                	sd	s0,16(sp)
    80003b0a:	e426                	sd	s1,8(sp)
    80003b0c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b0e:	00015517          	auipc	a0,0x15
    80003b12:	1ca50513          	addi	a0,a0,458 # 80018cd8 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	81e080e7          	jalr	-2018(ra) # 80006334 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b1e:	00015497          	auipc	s1,0x15
    80003b22:	1d248493          	addi	s1,s1,466 # 80018cf0 <ftable+0x18>
    80003b26:	00016717          	auipc	a4,0x16
    80003b2a:	16a70713          	addi	a4,a4,362 # 80019c90 <disk>
    if(f->ref == 0){
    80003b2e:	40dc                	lw	a5,4(s1)
    80003b30:	cf99                	beqz	a5,80003b4e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b32:	02848493          	addi	s1,s1,40
    80003b36:	fee49ce3          	bne	s1,a4,80003b2e <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b3a:	00015517          	auipc	a0,0x15
    80003b3e:	19e50513          	addi	a0,a0,414 # 80018cd8 <ftable>
    80003b42:	00003097          	auipc	ra,0x3
    80003b46:	8a6080e7          	jalr	-1882(ra) # 800063e8 <release>
  return 0;
    80003b4a:	4481                	li	s1,0
    80003b4c:	a819                	j	80003b62 <filealloc+0x5e>
      f->ref = 1;
    80003b4e:	4785                	li	a5,1
    80003b50:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b52:	00015517          	auipc	a0,0x15
    80003b56:	18650513          	addi	a0,a0,390 # 80018cd8 <ftable>
    80003b5a:	00003097          	auipc	ra,0x3
    80003b5e:	88e080e7          	jalr	-1906(ra) # 800063e8 <release>
}
    80003b62:	8526                	mv	a0,s1
    80003b64:	60e2                	ld	ra,24(sp)
    80003b66:	6442                	ld	s0,16(sp)
    80003b68:	64a2                	ld	s1,8(sp)
    80003b6a:	6105                	addi	sp,sp,32
    80003b6c:	8082                	ret

0000000080003b6e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b6e:	1101                	addi	sp,sp,-32
    80003b70:	ec06                	sd	ra,24(sp)
    80003b72:	e822                	sd	s0,16(sp)
    80003b74:	e426                	sd	s1,8(sp)
    80003b76:	1000                	addi	s0,sp,32
    80003b78:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003b7a:	00015517          	auipc	a0,0x15
    80003b7e:	15e50513          	addi	a0,a0,350 # 80018cd8 <ftable>
    80003b82:	00002097          	auipc	ra,0x2
    80003b86:	7b2080e7          	jalr	1970(ra) # 80006334 <acquire>
  if(f->ref < 1)
    80003b8a:	40dc                	lw	a5,4(s1)
    80003b8c:	02f05263          	blez	a5,80003bb0 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003b90:	2785                	addiw	a5,a5,1
    80003b92:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003b94:	00015517          	auipc	a0,0x15
    80003b98:	14450513          	addi	a0,a0,324 # 80018cd8 <ftable>
    80003b9c:	00003097          	auipc	ra,0x3
    80003ba0:	84c080e7          	jalr	-1972(ra) # 800063e8 <release>
  return f;
}
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	60e2                	ld	ra,24(sp)
    80003ba8:	6442                	ld	s0,16(sp)
    80003baa:	64a2                	ld	s1,8(sp)
    80003bac:	6105                	addi	sp,sp,32
    80003bae:	8082                	ret
    panic("filedup");
    80003bb0:	00005517          	auipc	a0,0x5
    80003bb4:	b0850513          	addi	a0,a0,-1272 # 800086b8 <syscalls+0x2b8>
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	244080e7          	jalr	580(ra) # 80005dfc <panic>

0000000080003bc0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003bc0:	7139                	addi	sp,sp,-64
    80003bc2:	fc06                	sd	ra,56(sp)
    80003bc4:	f822                	sd	s0,48(sp)
    80003bc6:	f426                	sd	s1,40(sp)
    80003bc8:	f04a                	sd	s2,32(sp)
    80003bca:	ec4e                	sd	s3,24(sp)
    80003bcc:	e852                	sd	s4,16(sp)
    80003bce:	e456                	sd	s5,8(sp)
    80003bd0:	0080                	addi	s0,sp,64
    80003bd2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bd4:	00015517          	auipc	a0,0x15
    80003bd8:	10450513          	addi	a0,a0,260 # 80018cd8 <ftable>
    80003bdc:	00002097          	auipc	ra,0x2
    80003be0:	758080e7          	jalr	1880(ra) # 80006334 <acquire>
  if(f->ref < 1)
    80003be4:	40dc                	lw	a5,4(s1)
    80003be6:	06f05163          	blez	a5,80003c48 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003bea:	37fd                	addiw	a5,a5,-1
    80003bec:	0007871b          	sext.w	a4,a5
    80003bf0:	c0dc                	sw	a5,4(s1)
    80003bf2:	06e04363          	bgtz	a4,80003c58 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003bf6:	0004a903          	lw	s2,0(s1)
    80003bfa:	0094ca83          	lbu	s5,9(s1)
    80003bfe:	0104ba03          	ld	s4,16(s1)
    80003c02:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c06:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c0a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c0e:	00015517          	auipc	a0,0x15
    80003c12:	0ca50513          	addi	a0,a0,202 # 80018cd8 <ftable>
    80003c16:	00002097          	auipc	ra,0x2
    80003c1a:	7d2080e7          	jalr	2002(ra) # 800063e8 <release>

  if(ff.type == FD_PIPE){
    80003c1e:	4785                	li	a5,1
    80003c20:	04f90d63          	beq	s2,a5,80003c7a <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c24:	3979                	addiw	s2,s2,-2
    80003c26:	4785                	li	a5,1
    80003c28:	0527e063          	bltu	a5,s2,80003c68 <fileclose+0xa8>
    begin_op();
    80003c2c:	00000097          	auipc	ra,0x0
    80003c30:	acc080e7          	jalr	-1332(ra) # 800036f8 <begin_op>
    iput(ff.ip);
    80003c34:	854e                	mv	a0,s3
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	2b0080e7          	jalr	688(ra) # 80002ee6 <iput>
    end_op();
    80003c3e:	00000097          	auipc	ra,0x0
    80003c42:	b38080e7          	jalr	-1224(ra) # 80003776 <end_op>
    80003c46:	a00d                	j	80003c68 <fileclose+0xa8>
    panic("fileclose");
    80003c48:	00005517          	auipc	a0,0x5
    80003c4c:	a7850513          	addi	a0,a0,-1416 # 800086c0 <syscalls+0x2c0>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	1ac080e7          	jalr	428(ra) # 80005dfc <panic>
    release(&ftable.lock);
    80003c58:	00015517          	auipc	a0,0x15
    80003c5c:	08050513          	addi	a0,a0,128 # 80018cd8 <ftable>
    80003c60:	00002097          	auipc	ra,0x2
    80003c64:	788080e7          	jalr	1928(ra) # 800063e8 <release>
  }
}
    80003c68:	70e2                	ld	ra,56(sp)
    80003c6a:	7442                	ld	s0,48(sp)
    80003c6c:	74a2                	ld	s1,40(sp)
    80003c6e:	7902                	ld	s2,32(sp)
    80003c70:	69e2                	ld	s3,24(sp)
    80003c72:	6a42                	ld	s4,16(sp)
    80003c74:	6aa2                	ld	s5,8(sp)
    80003c76:	6121                	addi	sp,sp,64
    80003c78:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003c7a:	85d6                	mv	a1,s5
    80003c7c:	8552                	mv	a0,s4
    80003c7e:	00000097          	auipc	ra,0x0
    80003c82:	34c080e7          	jalr	844(ra) # 80003fca <pipeclose>
    80003c86:	b7cd                	j	80003c68 <fileclose+0xa8>

0000000080003c88 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003c88:	715d                	addi	sp,sp,-80
    80003c8a:	e486                	sd	ra,72(sp)
    80003c8c:	e0a2                	sd	s0,64(sp)
    80003c8e:	fc26                	sd	s1,56(sp)
    80003c90:	f84a                	sd	s2,48(sp)
    80003c92:	f44e                	sd	s3,40(sp)
    80003c94:	0880                	addi	s0,sp,80
    80003c96:	84aa                	mv	s1,a0
    80003c98:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003c9a:	ffffd097          	auipc	ra,0xffffd
    80003c9e:	2a4080e7          	jalr	676(ra) # 80000f3e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ca2:	409c                	lw	a5,0(s1)
    80003ca4:	37f9                	addiw	a5,a5,-2
    80003ca6:	4705                	li	a4,1
    80003ca8:	04f76763          	bltu	a4,a5,80003cf6 <filestat+0x6e>
    80003cac:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cae:	6c88                	ld	a0,24(s1)
    80003cb0:	fffff097          	auipc	ra,0xfffff
    80003cb4:	07c080e7          	jalr	124(ra) # 80002d2c <ilock>
    stati(f->ip, &st);
    80003cb8:	fb840593          	addi	a1,s0,-72
    80003cbc:	6c88                	ld	a0,24(s1)
    80003cbe:	fffff097          	auipc	ra,0xfffff
    80003cc2:	2f8080e7          	jalr	760(ra) # 80002fb6 <stati>
    iunlock(f->ip);
    80003cc6:	6c88                	ld	a0,24(s1)
    80003cc8:	fffff097          	auipc	ra,0xfffff
    80003ccc:	126080e7          	jalr	294(ra) # 80002dee <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cd0:	46e1                	li	a3,24
    80003cd2:	fb840613          	addi	a2,s0,-72
    80003cd6:	85ce                	mv	a1,s3
    80003cd8:	05893503          	ld	a0,88(s2)
    80003cdc:	ffffd097          	auipc	ra,0xffffd
    80003ce0:	e38080e7          	jalr	-456(ra) # 80000b14 <copyout>
    80003ce4:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003ce8:	60a6                	ld	ra,72(sp)
    80003cea:	6406                	ld	s0,64(sp)
    80003cec:	74e2                	ld	s1,56(sp)
    80003cee:	7942                	ld	s2,48(sp)
    80003cf0:	79a2                	ld	s3,40(sp)
    80003cf2:	6161                	addi	sp,sp,80
    80003cf4:	8082                	ret
  return -1;
    80003cf6:	557d                	li	a0,-1
    80003cf8:	bfc5                	j	80003ce8 <filestat+0x60>

0000000080003cfa <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003cfa:	7179                	addi	sp,sp,-48
    80003cfc:	f406                	sd	ra,40(sp)
    80003cfe:	f022                	sd	s0,32(sp)
    80003d00:	ec26                	sd	s1,24(sp)
    80003d02:	e84a                	sd	s2,16(sp)
    80003d04:	e44e                	sd	s3,8(sp)
    80003d06:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d08:	00854783          	lbu	a5,8(a0)
    80003d0c:	c3d5                	beqz	a5,80003db0 <fileread+0xb6>
    80003d0e:	84aa                	mv	s1,a0
    80003d10:	89ae                	mv	s3,a1
    80003d12:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d14:	411c                	lw	a5,0(a0)
    80003d16:	4705                	li	a4,1
    80003d18:	04e78963          	beq	a5,a4,80003d6a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d1c:	470d                	li	a4,3
    80003d1e:	04e78d63          	beq	a5,a4,80003d78 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d22:	4709                	li	a4,2
    80003d24:	06e79e63          	bne	a5,a4,80003da0 <fileread+0xa6>
    ilock(f->ip);
    80003d28:	6d08                	ld	a0,24(a0)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	002080e7          	jalr	2(ra) # 80002d2c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d32:	874a                	mv	a4,s2
    80003d34:	5094                	lw	a3,32(s1)
    80003d36:	864e                	mv	a2,s3
    80003d38:	4585                	li	a1,1
    80003d3a:	6c88                	ld	a0,24(s1)
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	2a4080e7          	jalr	676(ra) # 80002fe0 <readi>
    80003d44:	892a                	mv	s2,a0
    80003d46:	00a05563          	blez	a0,80003d50 <fileread+0x56>
      f->off += r;
    80003d4a:	509c                	lw	a5,32(s1)
    80003d4c:	9fa9                	addw	a5,a5,a0
    80003d4e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d50:	6c88                	ld	a0,24(s1)
    80003d52:	fffff097          	auipc	ra,0xfffff
    80003d56:	09c080e7          	jalr	156(ra) # 80002dee <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d5a:	854a                	mv	a0,s2
    80003d5c:	70a2                	ld	ra,40(sp)
    80003d5e:	7402                	ld	s0,32(sp)
    80003d60:	64e2                	ld	s1,24(sp)
    80003d62:	6942                	ld	s2,16(sp)
    80003d64:	69a2                	ld	s3,8(sp)
    80003d66:	6145                	addi	sp,sp,48
    80003d68:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d6a:	6908                	ld	a0,16(a0)
    80003d6c:	00000097          	auipc	ra,0x0
    80003d70:	3c6080e7          	jalr	966(ra) # 80004132 <piperead>
    80003d74:	892a                	mv	s2,a0
    80003d76:	b7d5                	j	80003d5a <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d78:	02451783          	lh	a5,36(a0)
    80003d7c:	03079693          	slli	a3,a5,0x30
    80003d80:	92c1                	srli	a3,a3,0x30
    80003d82:	4725                	li	a4,9
    80003d84:	02d76863          	bltu	a4,a3,80003db4 <fileread+0xba>
    80003d88:	0792                	slli	a5,a5,0x4
    80003d8a:	00015717          	auipc	a4,0x15
    80003d8e:	eae70713          	addi	a4,a4,-338 # 80018c38 <devsw>
    80003d92:	97ba                	add	a5,a5,a4
    80003d94:	639c                	ld	a5,0(a5)
    80003d96:	c38d                	beqz	a5,80003db8 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003d98:	4505                	li	a0,1
    80003d9a:	9782                	jalr	a5
    80003d9c:	892a                	mv	s2,a0
    80003d9e:	bf75                	j	80003d5a <fileread+0x60>
    panic("fileread");
    80003da0:	00005517          	auipc	a0,0x5
    80003da4:	93050513          	addi	a0,a0,-1744 # 800086d0 <syscalls+0x2d0>
    80003da8:	00002097          	auipc	ra,0x2
    80003dac:	054080e7          	jalr	84(ra) # 80005dfc <panic>
    return -1;
    80003db0:	597d                	li	s2,-1
    80003db2:	b765                	j	80003d5a <fileread+0x60>
      return -1;
    80003db4:	597d                	li	s2,-1
    80003db6:	b755                	j	80003d5a <fileread+0x60>
    80003db8:	597d                	li	s2,-1
    80003dba:	b745                	j	80003d5a <fileread+0x60>

0000000080003dbc <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003dbc:	715d                	addi	sp,sp,-80
    80003dbe:	e486                	sd	ra,72(sp)
    80003dc0:	e0a2                	sd	s0,64(sp)
    80003dc2:	fc26                	sd	s1,56(sp)
    80003dc4:	f84a                	sd	s2,48(sp)
    80003dc6:	f44e                	sd	s3,40(sp)
    80003dc8:	f052                	sd	s4,32(sp)
    80003dca:	ec56                	sd	s5,24(sp)
    80003dcc:	e85a                	sd	s6,16(sp)
    80003dce:	e45e                	sd	s7,8(sp)
    80003dd0:	e062                	sd	s8,0(sp)
    80003dd2:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dd4:	00954783          	lbu	a5,9(a0)
    80003dd8:	10078663          	beqz	a5,80003ee4 <filewrite+0x128>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	8b2e                	mv	s6,a1
    80003de0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003de2:	411c                	lw	a5,0(a0)
    80003de4:	4705                	li	a4,1
    80003de6:	02e78263          	beq	a5,a4,80003e0a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003dea:	470d                	li	a4,3
    80003dec:	02e78663          	beq	a5,a4,80003e18 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003df0:	4709                	li	a4,2
    80003df2:	0ee79163          	bne	a5,a4,80003ed4 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003df6:	0ac05d63          	blez	a2,80003eb0 <filewrite+0xf4>
    int i = 0;
    80003dfa:	4981                	li	s3,0
    80003dfc:	6b85                	lui	s7,0x1
    80003dfe:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e02:	6c05                	lui	s8,0x1
    80003e04:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e08:	a861                	j	80003ea0 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e0a:	6908                	ld	a0,16(a0)
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	22e080e7          	jalr	558(ra) # 8000403a <pipewrite>
    80003e14:	8a2a                	mv	s4,a0
    80003e16:	a045                	j	80003eb6 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e18:	02451783          	lh	a5,36(a0)
    80003e1c:	03079693          	slli	a3,a5,0x30
    80003e20:	92c1                	srli	a3,a3,0x30
    80003e22:	4725                	li	a4,9
    80003e24:	0cd76263          	bltu	a4,a3,80003ee8 <filewrite+0x12c>
    80003e28:	0792                	slli	a5,a5,0x4
    80003e2a:	00015717          	auipc	a4,0x15
    80003e2e:	e0e70713          	addi	a4,a4,-498 # 80018c38 <devsw>
    80003e32:	97ba                	add	a5,a5,a4
    80003e34:	679c                	ld	a5,8(a5)
    80003e36:	cbdd                	beqz	a5,80003eec <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e38:	4505                	li	a0,1
    80003e3a:	9782                	jalr	a5
    80003e3c:	8a2a                	mv	s4,a0
    80003e3e:	a8a5                	j	80003eb6 <filewrite+0xfa>
    80003e40:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	8b4080e7          	jalr	-1868(ra) # 800036f8 <begin_op>
      ilock(f->ip);
    80003e4c:	01893503          	ld	a0,24(s2)
    80003e50:	fffff097          	auipc	ra,0xfffff
    80003e54:	edc080e7          	jalr	-292(ra) # 80002d2c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e58:	8756                	mv	a4,s5
    80003e5a:	02092683          	lw	a3,32(s2)
    80003e5e:	01698633          	add	a2,s3,s6
    80003e62:	4585                	li	a1,1
    80003e64:	01893503          	ld	a0,24(s2)
    80003e68:	fffff097          	auipc	ra,0xfffff
    80003e6c:	270080e7          	jalr	624(ra) # 800030d8 <writei>
    80003e70:	84aa                	mv	s1,a0
    80003e72:	00a05763          	blez	a0,80003e80 <filewrite+0xc4>
        f->off += r;
    80003e76:	02092783          	lw	a5,32(s2)
    80003e7a:	9fa9                	addw	a5,a5,a0
    80003e7c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003e80:	01893503          	ld	a0,24(s2)
    80003e84:	fffff097          	auipc	ra,0xfffff
    80003e88:	f6a080e7          	jalr	-150(ra) # 80002dee <iunlock>
      end_op();
    80003e8c:	00000097          	auipc	ra,0x0
    80003e90:	8ea080e7          	jalr	-1814(ra) # 80003776 <end_op>

      if(r != n1){
    80003e94:	009a9f63          	bne	s5,s1,80003eb2 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003e98:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003e9c:	0149db63          	bge	s3,s4,80003eb2 <filewrite+0xf6>
      int n1 = n - i;
    80003ea0:	413a04bb          	subw	s1,s4,s3
    80003ea4:	0004879b          	sext.w	a5,s1
    80003ea8:	f8fbdce3          	bge	s7,a5,80003e40 <filewrite+0x84>
    80003eac:	84e2                	mv	s1,s8
    80003eae:	bf49                	j	80003e40 <filewrite+0x84>
    int i = 0;
    80003eb0:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003eb2:	013a1f63          	bne	s4,s3,80003ed0 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003eb6:	8552                	mv	a0,s4
    80003eb8:	60a6                	ld	ra,72(sp)
    80003eba:	6406                	ld	s0,64(sp)
    80003ebc:	74e2                	ld	s1,56(sp)
    80003ebe:	7942                	ld	s2,48(sp)
    80003ec0:	79a2                	ld	s3,40(sp)
    80003ec2:	7a02                	ld	s4,32(sp)
    80003ec4:	6ae2                	ld	s5,24(sp)
    80003ec6:	6b42                	ld	s6,16(sp)
    80003ec8:	6ba2                	ld	s7,8(sp)
    80003eca:	6c02                	ld	s8,0(sp)
    80003ecc:	6161                	addi	sp,sp,80
    80003ece:	8082                	ret
    ret = (i == n ? n : -1);
    80003ed0:	5a7d                	li	s4,-1
    80003ed2:	b7d5                	j	80003eb6 <filewrite+0xfa>
    panic("filewrite");
    80003ed4:	00005517          	auipc	a0,0x5
    80003ed8:	80c50513          	addi	a0,a0,-2036 # 800086e0 <syscalls+0x2e0>
    80003edc:	00002097          	auipc	ra,0x2
    80003ee0:	f20080e7          	jalr	-224(ra) # 80005dfc <panic>
    return -1;
    80003ee4:	5a7d                	li	s4,-1
    80003ee6:	bfc1                	j	80003eb6 <filewrite+0xfa>
      return -1;
    80003ee8:	5a7d                	li	s4,-1
    80003eea:	b7f1                	j	80003eb6 <filewrite+0xfa>
    80003eec:	5a7d                	li	s4,-1
    80003eee:	b7e1                	j	80003eb6 <filewrite+0xfa>

0000000080003ef0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003ef0:	7179                	addi	sp,sp,-48
    80003ef2:	f406                	sd	ra,40(sp)
    80003ef4:	f022                	sd	s0,32(sp)
    80003ef6:	ec26                	sd	s1,24(sp)
    80003ef8:	e84a                	sd	s2,16(sp)
    80003efa:	e44e                	sd	s3,8(sp)
    80003efc:	e052                	sd	s4,0(sp)
    80003efe:	1800                	addi	s0,sp,48
    80003f00:	84aa                	mv	s1,a0
    80003f02:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f04:	0005b023          	sd	zero,0(a1)
    80003f08:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f0c:	00000097          	auipc	ra,0x0
    80003f10:	bf8080e7          	jalr	-1032(ra) # 80003b04 <filealloc>
    80003f14:	e088                	sd	a0,0(s1)
    80003f16:	c551                	beqz	a0,80003fa2 <pipealloc+0xb2>
    80003f18:	00000097          	auipc	ra,0x0
    80003f1c:	bec080e7          	jalr	-1044(ra) # 80003b04 <filealloc>
    80003f20:	00aa3023          	sd	a0,0(s4)
    80003f24:	c92d                	beqz	a0,80003f96 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f26:	ffffc097          	auipc	ra,0xffffc
    80003f2a:	1f4080e7          	jalr	500(ra) # 8000011a <kalloc>
    80003f2e:	892a                	mv	s2,a0
    80003f30:	c125                	beqz	a0,80003f90 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f32:	4985                	li	s3,1
    80003f34:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f38:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f3c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f40:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f44:	00004597          	auipc	a1,0x4
    80003f48:	7ac58593          	addi	a1,a1,1964 # 800086f0 <syscalls+0x2f0>
    80003f4c:	00002097          	auipc	ra,0x2
    80003f50:	358080e7          	jalr	856(ra) # 800062a4 <initlock>
  (*f0)->type = FD_PIPE;
    80003f54:	609c                	ld	a5,0(s1)
    80003f56:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f5a:	609c                	ld	a5,0(s1)
    80003f5c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f60:	609c                	ld	a5,0(s1)
    80003f62:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f66:	609c                	ld	a5,0(s1)
    80003f68:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f6c:	000a3783          	ld	a5,0(s4)
    80003f70:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f74:	000a3783          	ld	a5,0(s4)
    80003f78:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f7c:	000a3783          	ld	a5,0(s4)
    80003f80:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f84:	000a3783          	ld	a5,0(s4)
    80003f88:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f8c:	4501                	li	a0,0
    80003f8e:	a025                	j	80003fb6 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f90:	6088                	ld	a0,0(s1)
    80003f92:	e501                	bnez	a0,80003f9a <pipealloc+0xaa>
    80003f94:	a039                	j	80003fa2 <pipealloc+0xb2>
    80003f96:	6088                	ld	a0,0(s1)
    80003f98:	c51d                	beqz	a0,80003fc6 <pipealloc+0xd6>
    fileclose(*f0);
    80003f9a:	00000097          	auipc	ra,0x0
    80003f9e:	c26080e7          	jalr	-986(ra) # 80003bc0 <fileclose>
  if(*f1)
    80003fa2:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fa6:	557d                	li	a0,-1
  if(*f1)
    80003fa8:	c799                	beqz	a5,80003fb6 <pipealloc+0xc6>
    fileclose(*f1);
    80003faa:	853e                	mv	a0,a5
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	c14080e7          	jalr	-1004(ra) # 80003bc0 <fileclose>
  return -1;
    80003fb4:	557d                	li	a0,-1
}
    80003fb6:	70a2                	ld	ra,40(sp)
    80003fb8:	7402                	ld	s0,32(sp)
    80003fba:	64e2                	ld	s1,24(sp)
    80003fbc:	6942                	ld	s2,16(sp)
    80003fbe:	69a2                	ld	s3,8(sp)
    80003fc0:	6a02                	ld	s4,0(sp)
    80003fc2:	6145                	addi	sp,sp,48
    80003fc4:	8082                	ret
  return -1;
    80003fc6:	557d                	li	a0,-1
    80003fc8:	b7fd                	j	80003fb6 <pipealloc+0xc6>

0000000080003fca <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003fca:	1101                	addi	sp,sp,-32
    80003fcc:	ec06                	sd	ra,24(sp)
    80003fce:	e822                	sd	s0,16(sp)
    80003fd0:	e426                	sd	s1,8(sp)
    80003fd2:	e04a                	sd	s2,0(sp)
    80003fd4:	1000                	addi	s0,sp,32
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003fda:	00002097          	auipc	ra,0x2
    80003fde:	35a080e7          	jalr	858(ra) # 80006334 <acquire>
  if(writable){
    80003fe2:	02090d63          	beqz	s2,8000401c <pipeclose+0x52>
    pi->writeopen = 0;
    80003fe6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003fea:	21848513          	addi	a0,s1,536
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	6da080e7          	jalr	1754(ra) # 800016c8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ff6:	2204b783          	ld	a5,544(s1)
    80003ffa:	eb95                	bnez	a5,8000402e <pipeclose+0x64>
    release(&pi->lock);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	00002097          	auipc	ra,0x2
    80004002:	3ea080e7          	jalr	1002(ra) # 800063e8 <release>
    kfree((char*)pi);
    80004006:	8526                	mv	a0,s1
    80004008:	ffffc097          	auipc	ra,0xffffc
    8000400c:	014080e7          	jalr	20(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004010:	60e2                	ld	ra,24(sp)
    80004012:	6442                	ld	s0,16(sp)
    80004014:	64a2                	ld	s1,8(sp)
    80004016:	6902                	ld	s2,0(sp)
    80004018:	6105                	addi	sp,sp,32
    8000401a:	8082                	ret
    pi->readopen = 0;
    8000401c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004020:	21c48513          	addi	a0,s1,540
    80004024:	ffffd097          	auipc	ra,0xffffd
    80004028:	6a4080e7          	jalr	1700(ra) # 800016c8 <wakeup>
    8000402c:	b7e9                	j	80003ff6 <pipeclose+0x2c>
    release(&pi->lock);
    8000402e:	8526                	mv	a0,s1
    80004030:	00002097          	auipc	ra,0x2
    80004034:	3b8080e7          	jalr	952(ra) # 800063e8 <release>
}
    80004038:	bfe1                	j	80004010 <pipeclose+0x46>

000000008000403a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000403a:	711d                	addi	sp,sp,-96
    8000403c:	ec86                	sd	ra,88(sp)
    8000403e:	e8a2                	sd	s0,80(sp)
    80004040:	e4a6                	sd	s1,72(sp)
    80004042:	e0ca                	sd	s2,64(sp)
    80004044:	fc4e                	sd	s3,56(sp)
    80004046:	f852                	sd	s4,48(sp)
    80004048:	f456                	sd	s5,40(sp)
    8000404a:	f05a                	sd	s6,32(sp)
    8000404c:	ec5e                	sd	s7,24(sp)
    8000404e:	e862                	sd	s8,16(sp)
    80004050:	1080                	addi	s0,sp,96
    80004052:	84aa                	mv	s1,a0
    80004054:	8aae                	mv	s5,a1
    80004056:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004058:	ffffd097          	auipc	ra,0xffffd
    8000405c:	ee6080e7          	jalr	-282(ra) # 80000f3e <myproc>
    80004060:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004062:	8526                	mv	a0,s1
    80004064:	00002097          	auipc	ra,0x2
    80004068:	2d0080e7          	jalr	720(ra) # 80006334 <acquire>
  while(i < n){
    8000406c:	0b405663          	blez	s4,80004118 <pipewrite+0xde>
  int i = 0;
    80004070:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004072:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004074:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004078:	21c48b93          	addi	s7,s1,540
    8000407c:	a089                	j	800040be <pipewrite+0x84>
      release(&pi->lock);
    8000407e:	8526                	mv	a0,s1
    80004080:	00002097          	auipc	ra,0x2
    80004084:	368080e7          	jalr	872(ra) # 800063e8 <release>
      return -1;
    80004088:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000408a:	854a                	mv	a0,s2
    8000408c:	60e6                	ld	ra,88(sp)
    8000408e:	6446                	ld	s0,80(sp)
    80004090:	64a6                	ld	s1,72(sp)
    80004092:	6906                	ld	s2,64(sp)
    80004094:	79e2                	ld	s3,56(sp)
    80004096:	7a42                	ld	s4,48(sp)
    80004098:	7aa2                	ld	s5,40(sp)
    8000409a:	7b02                	ld	s6,32(sp)
    8000409c:	6be2                	ld	s7,24(sp)
    8000409e:	6c42                	ld	s8,16(sp)
    800040a0:	6125                	addi	sp,sp,96
    800040a2:	8082                	ret
      wakeup(&pi->nread);
    800040a4:	8562                	mv	a0,s8
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	622080e7          	jalr	1570(ra) # 800016c8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040ae:	85a6                	mv	a1,s1
    800040b0:	855e                	mv	a0,s7
    800040b2:	ffffd097          	auipc	ra,0xffffd
    800040b6:	5b2080e7          	jalr	1458(ra) # 80001664 <sleep>
  while(i < n){
    800040ba:	07495063          	bge	s2,s4,8000411a <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    800040be:	2204a783          	lw	a5,544(s1)
    800040c2:	dfd5                	beqz	a5,8000407e <pipewrite+0x44>
    800040c4:	854e                	mv	a0,s3
    800040c6:	ffffe097          	auipc	ra,0xffffe
    800040ca:	846080e7          	jalr	-1978(ra) # 8000190c <killed>
    800040ce:	f945                	bnez	a0,8000407e <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800040d0:	2184a783          	lw	a5,536(s1)
    800040d4:	21c4a703          	lw	a4,540(s1)
    800040d8:	2007879b          	addiw	a5,a5,512
    800040dc:	fcf704e3          	beq	a4,a5,800040a4 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040e0:	4685                	li	a3,1
    800040e2:	01590633          	add	a2,s2,s5
    800040e6:	faf40593          	addi	a1,s0,-81
    800040ea:	0589b503          	ld	a0,88(s3)
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	ab2080e7          	jalr	-1358(ra) # 80000ba0 <copyin>
    800040f6:	03650263          	beq	a0,s6,8000411a <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040fa:	21c4a783          	lw	a5,540(s1)
    800040fe:	0017871b          	addiw	a4,a5,1
    80004102:	20e4ae23          	sw	a4,540(s1)
    80004106:	1ff7f793          	andi	a5,a5,511
    8000410a:	97a6                	add	a5,a5,s1
    8000410c:	faf44703          	lbu	a4,-81(s0)
    80004110:	00e78c23          	sb	a4,24(a5)
      i++;
    80004114:	2905                	addiw	s2,s2,1
    80004116:	b755                	j	800040ba <pipewrite+0x80>
  int i = 0;
    80004118:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000411a:	21848513          	addi	a0,s1,536
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	5aa080e7          	jalr	1450(ra) # 800016c8 <wakeup>
  release(&pi->lock);
    80004126:	8526                	mv	a0,s1
    80004128:	00002097          	auipc	ra,0x2
    8000412c:	2c0080e7          	jalr	704(ra) # 800063e8 <release>
  return i;
    80004130:	bfa9                	j	8000408a <pipewrite+0x50>

0000000080004132 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004132:	715d                	addi	sp,sp,-80
    80004134:	e486                	sd	ra,72(sp)
    80004136:	e0a2                	sd	s0,64(sp)
    80004138:	fc26                	sd	s1,56(sp)
    8000413a:	f84a                	sd	s2,48(sp)
    8000413c:	f44e                	sd	s3,40(sp)
    8000413e:	f052                	sd	s4,32(sp)
    80004140:	ec56                	sd	s5,24(sp)
    80004142:	e85a                	sd	s6,16(sp)
    80004144:	0880                	addi	s0,sp,80
    80004146:	84aa                	mv	s1,a0
    80004148:	892e                	mv	s2,a1
    8000414a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	df2080e7          	jalr	-526(ra) # 80000f3e <myproc>
    80004154:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004156:	8526                	mv	a0,s1
    80004158:	00002097          	auipc	ra,0x2
    8000415c:	1dc080e7          	jalr	476(ra) # 80006334 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004160:	2184a703          	lw	a4,536(s1)
    80004164:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004168:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000416c:	02f71763          	bne	a4,a5,8000419a <piperead+0x68>
    80004170:	2244a783          	lw	a5,548(s1)
    80004174:	c39d                	beqz	a5,8000419a <piperead+0x68>
    if(killed(pr)){
    80004176:	8552                	mv	a0,s4
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	794080e7          	jalr	1940(ra) # 8000190c <killed>
    80004180:	e949                	bnez	a0,80004212 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004182:	85a6                	mv	a1,s1
    80004184:	854e                	mv	a0,s3
    80004186:	ffffd097          	auipc	ra,0xffffd
    8000418a:	4de080e7          	jalr	1246(ra) # 80001664 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000418e:	2184a703          	lw	a4,536(s1)
    80004192:	21c4a783          	lw	a5,540(s1)
    80004196:	fcf70de3          	beq	a4,a5,80004170 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000419c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000419e:	05505463          	blez	s5,800041e6 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800041a2:	2184a783          	lw	a5,536(s1)
    800041a6:	21c4a703          	lw	a4,540(s1)
    800041aa:	02f70e63          	beq	a4,a5,800041e6 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041ae:	0017871b          	addiw	a4,a5,1
    800041b2:	20e4ac23          	sw	a4,536(s1)
    800041b6:	1ff7f793          	andi	a5,a5,511
    800041ba:	97a6                	add	a5,a5,s1
    800041bc:	0187c783          	lbu	a5,24(a5)
    800041c0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041c4:	4685                	li	a3,1
    800041c6:	fbf40613          	addi	a2,s0,-65
    800041ca:	85ca                	mv	a1,s2
    800041cc:	058a3503          	ld	a0,88(s4)
    800041d0:	ffffd097          	auipc	ra,0xffffd
    800041d4:	944080e7          	jalr	-1724(ra) # 80000b14 <copyout>
    800041d8:	01650763          	beq	a0,s6,800041e6 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041dc:	2985                	addiw	s3,s3,1
    800041de:	0905                	addi	s2,s2,1
    800041e0:	fd3a91e3          	bne	s5,s3,800041a2 <piperead+0x70>
    800041e4:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800041e6:	21c48513          	addi	a0,s1,540
    800041ea:	ffffd097          	auipc	ra,0xffffd
    800041ee:	4de080e7          	jalr	1246(ra) # 800016c8 <wakeup>
  release(&pi->lock);
    800041f2:	8526                	mv	a0,s1
    800041f4:	00002097          	auipc	ra,0x2
    800041f8:	1f4080e7          	jalr	500(ra) # 800063e8 <release>
  return i;
}
    800041fc:	854e                	mv	a0,s3
    800041fe:	60a6                	ld	ra,72(sp)
    80004200:	6406                	ld	s0,64(sp)
    80004202:	74e2                	ld	s1,56(sp)
    80004204:	7942                	ld	s2,48(sp)
    80004206:	79a2                	ld	s3,40(sp)
    80004208:	7a02                	ld	s4,32(sp)
    8000420a:	6ae2                	ld	s5,24(sp)
    8000420c:	6b42                	ld	s6,16(sp)
    8000420e:	6161                	addi	sp,sp,80
    80004210:	8082                	ret
      release(&pi->lock);
    80004212:	8526                	mv	a0,s1
    80004214:	00002097          	auipc	ra,0x2
    80004218:	1d4080e7          	jalr	468(ra) # 800063e8 <release>
      return -1;
    8000421c:	59fd                	li	s3,-1
    8000421e:	bff9                	j	800041fc <piperead+0xca>

0000000080004220 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004220:	1141                	addi	sp,sp,-16
    80004222:	e422                	sd	s0,8(sp)
    80004224:	0800                	addi	s0,sp,16
    80004226:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004228:	8905                	andi	a0,a0,1
    8000422a:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000422c:	8b89                	andi	a5,a5,2
    8000422e:	c399                	beqz	a5,80004234 <flags2perm+0x14>
      perm |= PTE_W;
    80004230:	00456513          	ori	a0,a0,4
    return perm;
}
    80004234:	6422                	ld	s0,8(sp)
    80004236:	0141                	addi	sp,sp,16
    80004238:	8082                	ret

000000008000423a <exec>:

int
exec(char *path, char **argv)
{
    8000423a:	de010113          	addi	sp,sp,-544
    8000423e:	20113c23          	sd	ra,536(sp)
    80004242:	20813823          	sd	s0,528(sp)
    80004246:	20913423          	sd	s1,520(sp)
    8000424a:	21213023          	sd	s2,512(sp)
    8000424e:	ffce                	sd	s3,504(sp)
    80004250:	fbd2                	sd	s4,496(sp)
    80004252:	f7d6                	sd	s5,488(sp)
    80004254:	f3da                	sd	s6,480(sp)
    80004256:	efde                	sd	s7,472(sp)
    80004258:	ebe2                	sd	s8,464(sp)
    8000425a:	e7e6                	sd	s9,456(sp)
    8000425c:	e3ea                	sd	s10,448(sp)
    8000425e:	ff6e                	sd	s11,440(sp)
    80004260:	1400                	addi	s0,sp,544
    80004262:	892a                	mv	s2,a0
    80004264:	dea43423          	sd	a0,-536(s0)
    80004268:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000426c:	ffffd097          	auipc	ra,0xffffd
    80004270:	cd2080e7          	jalr	-814(ra) # 80000f3e <myproc>
    80004274:	84aa                	mv	s1,a0

  begin_op();
    80004276:	fffff097          	auipc	ra,0xfffff
    8000427a:	482080e7          	jalr	1154(ra) # 800036f8 <begin_op>

  if((ip = namei(path)) == 0){
    8000427e:	854a                	mv	a0,s2
    80004280:	fffff097          	auipc	ra,0xfffff
    80004284:	258080e7          	jalr	600(ra) # 800034d8 <namei>
    80004288:	c93d                	beqz	a0,800042fe <exec+0xc4>
    8000428a:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000428c:	fffff097          	auipc	ra,0xfffff
    80004290:	aa0080e7          	jalr	-1376(ra) # 80002d2c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004294:	04000713          	li	a4,64
    80004298:	4681                	li	a3,0
    8000429a:	e5040613          	addi	a2,s0,-432
    8000429e:	4581                	li	a1,0
    800042a0:	8556                	mv	a0,s5
    800042a2:	fffff097          	auipc	ra,0xfffff
    800042a6:	d3e080e7          	jalr	-706(ra) # 80002fe0 <readi>
    800042aa:	04000793          	li	a5,64
    800042ae:	00f51a63          	bne	a0,a5,800042c2 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042b2:	e5042703          	lw	a4,-432(s0)
    800042b6:	464c47b7          	lui	a5,0x464c4
    800042ba:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042be:	04f70663          	beq	a4,a5,8000430a <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042c2:	8556                	mv	a0,s5
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	cca080e7          	jalr	-822(ra) # 80002f8e <iunlockput>
    end_op();
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	4aa080e7          	jalr	1194(ra) # 80003776 <end_op>
  }
  return -1;
    800042d4:	557d                	li	a0,-1
}
    800042d6:	21813083          	ld	ra,536(sp)
    800042da:	21013403          	ld	s0,528(sp)
    800042de:	20813483          	ld	s1,520(sp)
    800042e2:	20013903          	ld	s2,512(sp)
    800042e6:	79fe                	ld	s3,504(sp)
    800042e8:	7a5e                	ld	s4,496(sp)
    800042ea:	7abe                	ld	s5,488(sp)
    800042ec:	7b1e                	ld	s6,480(sp)
    800042ee:	6bfe                	ld	s7,472(sp)
    800042f0:	6c5e                	ld	s8,464(sp)
    800042f2:	6cbe                	ld	s9,456(sp)
    800042f4:	6d1e                	ld	s10,448(sp)
    800042f6:	7dfa                	ld	s11,440(sp)
    800042f8:	22010113          	addi	sp,sp,544
    800042fc:	8082                	ret
    end_op();
    800042fe:	fffff097          	auipc	ra,0xfffff
    80004302:	478080e7          	jalr	1144(ra) # 80003776 <end_op>
    return -1;
    80004306:	557d                	li	a0,-1
    80004308:	b7f9                	j	800042d6 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000430a:	8526                	mv	a0,s1
    8000430c:	ffffd097          	auipc	ra,0xffffd
    80004310:	cf6080e7          	jalr	-778(ra) # 80001002 <proc_pagetable>
    80004314:	8b2a                	mv	s6,a0
    80004316:	d555                	beqz	a0,800042c2 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004318:	e7042783          	lw	a5,-400(s0)
    8000431c:	e8845703          	lhu	a4,-376(s0)
    80004320:	c735                	beqz	a4,8000438c <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004322:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004324:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004328:	6a05                	lui	s4,0x1
    8000432a:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    8000432e:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004332:	6d85                	lui	s11,0x1
    80004334:	7d7d                	lui	s10,0xfffff
    80004336:	ac99                	j	8000458c <exec+0x352>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004338:	00004517          	auipc	a0,0x4
    8000433c:	3c050513          	addi	a0,a0,960 # 800086f8 <syscalls+0x2f8>
    80004340:	00002097          	auipc	ra,0x2
    80004344:	abc080e7          	jalr	-1348(ra) # 80005dfc <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004348:	874a                	mv	a4,s2
    8000434a:	009c86bb          	addw	a3,s9,s1
    8000434e:	4581                	li	a1,0
    80004350:	8556                	mv	a0,s5
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	c8e080e7          	jalr	-882(ra) # 80002fe0 <readi>
    8000435a:	2501                	sext.w	a0,a0
    8000435c:	1ca91563          	bne	s2,a0,80004526 <exec+0x2ec>
  for(i = 0; i < sz; i += PGSIZE){
    80004360:	009d84bb          	addw	s1,s11,s1
    80004364:	013d09bb          	addw	s3,s10,s3
    80004368:	2174f263          	bgeu	s1,s7,8000456c <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    8000436c:	02049593          	slli	a1,s1,0x20
    80004370:	9181                	srli	a1,a1,0x20
    80004372:	95e2                	add	a1,a1,s8
    80004374:	855a                	mv	a0,s6
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	18e080e7          	jalr	398(ra) # 80000504 <walkaddr>
    8000437e:	862a                	mv	a2,a0
    if(pa == 0)
    80004380:	dd45                	beqz	a0,80004338 <exec+0xfe>
      n = PGSIZE;
    80004382:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004384:	fd49f2e3          	bgeu	s3,s4,80004348 <exec+0x10e>
      n = sz - i;
    80004388:	894e                	mv	s2,s3
    8000438a:	bf7d                	j	80004348 <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000438c:	4901                	li	s2,0
  iunlockput(ip);
    8000438e:	8556                	mv	a0,s5
    80004390:	fffff097          	auipc	ra,0xfffff
    80004394:	bfe080e7          	jalr	-1026(ra) # 80002f8e <iunlockput>
  end_op();
    80004398:	fffff097          	auipc	ra,0xfffff
    8000439c:	3de080e7          	jalr	990(ra) # 80003776 <end_op>
  p = myproc();
    800043a0:	ffffd097          	auipc	ra,0xffffd
    800043a4:	b9e080e7          	jalr	-1122(ra) # 80000f3e <myproc>
    800043a8:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800043aa:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800043ae:	6785                	lui	a5,0x1
    800043b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800043b2:	97ca                	add	a5,a5,s2
    800043b4:	777d                	lui	a4,0xfffff
    800043b6:	8ff9                	and	a5,a5,a4
    800043b8:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043bc:	4691                	li	a3,4
    800043be:	6609                	lui	a2,0x2
    800043c0:	963e                	add	a2,a2,a5
    800043c2:	85be                	mv	a1,a5
    800043c4:	855a                	mv	a0,s6
    800043c6:	ffffc097          	auipc	ra,0xffffc
    800043ca:	4f2080e7          	jalr	1266(ra) # 800008b8 <uvmalloc>
    800043ce:	8c2a                	mv	s8,a0
  ip = 0;
    800043d0:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043d2:	14050a63          	beqz	a0,80004526 <exec+0x2ec>
  uvmclear(pagetable, sz-2*PGSIZE);
    800043d6:	75f9                	lui	a1,0xffffe
    800043d8:	95aa                	add	a1,a1,a0
    800043da:	855a                	mv	a0,s6
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	706080e7          	jalr	1798(ra) # 80000ae2 <uvmclear>
  stackbase = sp - PGSIZE;
    800043e4:	7afd                	lui	s5,0xfffff
    800043e6:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    800043e8:	df043783          	ld	a5,-528(s0)
    800043ec:	6388                	ld	a0,0(a5)
    800043ee:	c925                	beqz	a0,8000445e <exec+0x224>
    800043f0:	e9040993          	addi	s3,s0,-368
    800043f4:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800043f8:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043fa:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	efa080e7          	jalr	-262(ra) # 800002f6 <strlen>
    80004404:	0015079b          	addiw	a5,a0,1
    80004408:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000440c:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004410:	15596263          	bltu	s2,s5,80004554 <exec+0x31a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004414:	df043d83          	ld	s11,-528(s0)
    80004418:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    8000441c:	8552                	mv	a0,s4
    8000441e:	ffffc097          	auipc	ra,0xffffc
    80004422:	ed8080e7          	jalr	-296(ra) # 800002f6 <strlen>
    80004426:	0015069b          	addiw	a3,a0,1
    8000442a:	8652                	mv	a2,s4
    8000442c:	85ca                	mv	a1,s2
    8000442e:	855a                	mv	a0,s6
    80004430:	ffffc097          	auipc	ra,0xffffc
    80004434:	6e4080e7          	jalr	1764(ra) # 80000b14 <copyout>
    80004438:	12054263          	bltz	a0,8000455c <exec+0x322>
    ustack[argc] = sp;
    8000443c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004440:	0485                	addi	s1,s1,1
    80004442:	008d8793          	addi	a5,s11,8
    80004446:	def43823          	sd	a5,-528(s0)
    8000444a:	008db503          	ld	a0,8(s11)
    8000444e:	c911                	beqz	a0,80004462 <exec+0x228>
    if(argc >= MAXARG)
    80004450:	09a1                	addi	s3,s3,8
    80004452:	fb3c95e3          	bne	s9,s3,800043fc <exec+0x1c2>
  sz = sz1;
    80004456:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000445a:	4a81                	li	s5,0
    8000445c:	a0e9                	j	80004526 <exec+0x2ec>
  sp = sz;
    8000445e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004460:	4481                	li	s1,0
  ustack[argc] = 0;
    80004462:	00349793          	slli	a5,s1,0x3
    80004466:	f9078793          	addi	a5,a5,-112
    8000446a:	97a2                	add	a5,a5,s0
    8000446c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004470:	00148693          	addi	a3,s1,1
    80004474:	068e                	slli	a3,a3,0x3
    80004476:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000447a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000447e:	01597663          	bgeu	s2,s5,8000448a <exec+0x250>
  sz = sz1;
    80004482:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004486:	4a81                	li	s5,0
    80004488:	a879                	j	80004526 <exec+0x2ec>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000448a:	e9040613          	addi	a2,s0,-368
    8000448e:	85ca                	mv	a1,s2
    80004490:	855a                	mv	a0,s6
    80004492:	ffffc097          	auipc	ra,0xffffc
    80004496:	682080e7          	jalr	1666(ra) # 80000b14 <copyout>
    8000449a:	0c054563          	bltz	a0,80004564 <exec+0x32a>
  p->trapframe->a1 = sp;
    8000449e:	060bb783          	ld	a5,96(s7)
    800044a2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044a6:	de843783          	ld	a5,-536(s0)
    800044aa:	0007c703          	lbu	a4,0(a5)
    800044ae:	cf11                	beqz	a4,800044ca <exec+0x290>
    800044b0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044b2:	02f00693          	li	a3,47
    800044b6:	a039                	j	800044c4 <exec+0x28a>
      last = s+1;
    800044b8:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800044bc:	0785                	addi	a5,a5,1
    800044be:	fff7c703          	lbu	a4,-1(a5)
    800044c2:	c701                	beqz	a4,800044ca <exec+0x290>
    if(*s == '/')
    800044c4:	fed71ce3          	bne	a4,a3,800044bc <exec+0x282>
    800044c8:	bfc5                	j	800044b8 <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    800044ca:	4641                	li	a2,16
    800044cc:	de843583          	ld	a1,-536(s0)
    800044d0:	160b8513          	addi	a0,s7,352
    800044d4:	ffffc097          	auipc	ra,0xffffc
    800044d8:	df0080e7          	jalr	-528(ra) # 800002c4 <safestrcpy>
  oldpagetable = p->pagetable;
    800044dc:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    800044e0:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    800044e4:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800044e8:	060bb783          	ld	a5,96(s7)
    800044ec:	e6843703          	ld	a4,-408(s0)
    800044f0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044f2:	060bb783          	ld	a5,96(s7)
    800044f6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044fa:	85ea                	mv	a1,s10
    800044fc:	ffffd097          	auipc	ra,0xffffd
    80004500:	bd0080e7          	jalr	-1072(ra) # 800010cc <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    80004504:	038ba703          	lw	a4,56(s7)
    80004508:	4785                	li	a5,1
    8000450a:	00f70563          	beq	a4,a5,80004514 <exec+0x2da>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000450e:	0004851b          	sext.w	a0,s1
    80004512:	b3d1                	j	800042d6 <exec+0x9c>
  if(p->pid==1) vmprint(p->pagetable);
    80004514:	058bb503          	ld	a0,88(s7)
    80004518:	ffffc097          	auipc	ra,0xffffc
    8000451c:	7c6080e7          	jalr	1990(ra) # 80000cde <vmprint>
    80004520:	b7fd                	j	8000450e <exec+0x2d4>
    80004522:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004526:	df843583          	ld	a1,-520(s0)
    8000452a:	855a                	mv	a0,s6
    8000452c:	ffffd097          	auipc	ra,0xffffd
    80004530:	ba0080e7          	jalr	-1120(ra) # 800010cc <proc_freepagetable>
  if(ip){
    80004534:	d80a97e3          	bnez	s5,800042c2 <exec+0x88>
  return -1;
    80004538:	557d                	li	a0,-1
    8000453a:	bb71                	j	800042d6 <exec+0x9c>
    8000453c:	df243c23          	sd	s2,-520(s0)
    80004540:	b7dd                	j	80004526 <exec+0x2ec>
    80004542:	df243c23          	sd	s2,-520(s0)
    80004546:	b7c5                	j	80004526 <exec+0x2ec>
    80004548:	df243c23          	sd	s2,-520(s0)
    8000454c:	bfe9                	j	80004526 <exec+0x2ec>
    8000454e:	df243c23          	sd	s2,-520(s0)
    80004552:	bfd1                	j	80004526 <exec+0x2ec>
  sz = sz1;
    80004554:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004558:	4a81                	li	s5,0
    8000455a:	b7f1                	j	80004526 <exec+0x2ec>
  sz = sz1;
    8000455c:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004560:	4a81                	li	s5,0
    80004562:	b7d1                	j	80004526 <exec+0x2ec>
  sz = sz1;
    80004564:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004568:	4a81                	li	s5,0
    8000456a:	bf75                	j	80004526 <exec+0x2ec>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000456c:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004570:	e0843783          	ld	a5,-504(s0)
    80004574:	0017869b          	addiw	a3,a5,1
    80004578:	e0d43423          	sd	a3,-504(s0)
    8000457c:	e0043783          	ld	a5,-512(s0)
    80004580:	0387879b          	addiw	a5,a5,56
    80004584:	e8845703          	lhu	a4,-376(s0)
    80004588:	e0e6d3e3          	bge	a3,a4,8000438e <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000458c:	2781                	sext.w	a5,a5
    8000458e:	e0f43023          	sd	a5,-512(s0)
    80004592:	03800713          	li	a4,56
    80004596:	86be                	mv	a3,a5
    80004598:	e1840613          	addi	a2,s0,-488
    8000459c:	4581                	li	a1,0
    8000459e:	8556                	mv	a0,s5
    800045a0:	fffff097          	auipc	ra,0xfffff
    800045a4:	a40080e7          	jalr	-1472(ra) # 80002fe0 <readi>
    800045a8:	03800793          	li	a5,56
    800045ac:	f6f51be3          	bne	a0,a5,80004522 <exec+0x2e8>
    if(ph.type != ELF_PROG_LOAD)
    800045b0:	e1842783          	lw	a5,-488(s0)
    800045b4:	4705                	li	a4,1
    800045b6:	fae79de3          	bne	a5,a4,80004570 <exec+0x336>
    if(ph.memsz < ph.filesz)
    800045ba:	e4043483          	ld	s1,-448(s0)
    800045be:	e3843783          	ld	a5,-456(s0)
    800045c2:	f6f4ede3          	bltu	s1,a5,8000453c <exec+0x302>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045c6:	e2843783          	ld	a5,-472(s0)
    800045ca:	94be                	add	s1,s1,a5
    800045cc:	f6f4ebe3          	bltu	s1,a5,80004542 <exec+0x308>
    if(ph.vaddr % PGSIZE != 0)
    800045d0:	de043703          	ld	a4,-544(s0)
    800045d4:	8ff9                	and	a5,a5,a4
    800045d6:	fbad                	bnez	a5,80004548 <exec+0x30e>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045d8:	e1c42503          	lw	a0,-484(s0)
    800045dc:	00000097          	auipc	ra,0x0
    800045e0:	c44080e7          	jalr	-956(ra) # 80004220 <flags2perm>
    800045e4:	86aa                	mv	a3,a0
    800045e6:	8626                	mv	a2,s1
    800045e8:	85ca                	mv	a1,s2
    800045ea:	855a                	mv	a0,s6
    800045ec:	ffffc097          	auipc	ra,0xffffc
    800045f0:	2cc080e7          	jalr	716(ra) # 800008b8 <uvmalloc>
    800045f4:	dea43c23          	sd	a0,-520(s0)
    800045f8:	d939                	beqz	a0,8000454e <exec+0x314>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800045fa:	e2843c03          	ld	s8,-472(s0)
    800045fe:	e2042c83          	lw	s9,-480(s0)
    80004602:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004606:	f60b83e3          	beqz	s7,8000456c <exec+0x332>
    8000460a:	89de                	mv	s3,s7
    8000460c:	4481                	li	s1,0
    8000460e:	bbb9                	j	8000436c <exec+0x132>

0000000080004610 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004610:	7179                	addi	sp,sp,-48
    80004612:	f406                	sd	ra,40(sp)
    80004614:	f022                	sd	s0,32(sp)
    80004616:	ec26                	sd	s1,24(sp)
    80004618:	e84a                	sd	s2,16(sp)
    8000461a:	1800                	addi	s0,sp,48
    8000461c:	892e                	mv	s2,a1
    8000461e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004620:	fdc40593          	addi	a1,s0,-36
    80004624:	ffffe097          	auipc	ra,0xffffe
    80004628:	aae080e7          	jalr	-1362(ra) # 800020d2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000462c:	fdc42703          	lw	a4,-36(s0)
    80004630:	47bd                	li	a5,15
    80004632:	02e7eb63          	bltu	a5,a4,80004668 <argfd+0x58>
    80004636:	ffffd097          	auipc	ra,0xffffd
    8000463a:	908080e7          	jalr	-1784(ra) # 80000f3e <myproc>
    8000463e:	fdc42703          	lw	a4,-36(s0)
    80004642:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdd00a>
    80004646:	078e                	slli	a5,a5,0x3
    80004648:	953e                	add	a0,a0,a5
    8000464a:	651c                	ld	a5,8(a0)
    8000464c:	c385                	beqz	a5,8000466c <argfd+0x5c>
    return -1;
  if(pfd)
    8000464e:	00090463          	beqz	s2,80004656 <argfd+0x46>
    *pfd = fd;
    80004652:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004656:	4501                	li	a0,0
  if(pf)
    80004658:	c091                	beqz	s1,8000465c <argfd+0x4c>
    *pf = f;
    8000465a:	e09c                	sd	a5,0(s1)
}
    8000465c:	70a2                	ld	ra,40(sp)
    8000465e:	7402                	ld	s0,32(sp)
    80004660:	64e2                	ld	s1,24(sp)
    80004662:	6942                	ld	s2,16(sp)
    80004664:	6145                	addi	sp,sp,48
    80004666:	8082                	ret
    return -1;
    80004668:	557d                	li	a0,-1
    8000466a:	bfcd                	j	8000465c <argfd+0x4c>
    8000466c:	557d                	li	a0,-1
    8000466e:	b7fd                	j	8000465c <argfd+0x4c>

0000000080004670 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004670:	1101                	addi	sp,sp,-32
    80004672:	ec06                	sd	ra,24(sp)
    80004674:	e822                	sd	s0,16(sp)
    80004676:	e426                	sd	s1,8(sp)
    80004678:	1000                	addi	s0,sp,32
    8000467a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000467c:	ffffd097          	auipc	ra,0xffffd
    80004680:	8c2080e7          	jalr	-1854(ra) # 80000f3e <myproc>
    80004684:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004686:	0d850793          	addi	a5,a0,216
    8000468a:	4501                	li	a0,0
    8000468c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000468e:	6398                	ld	a4,0(a5)
    80004690:	cb19                	beqz	a4,800046a6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004692:	2505                	addiw	a0,a0,1
    80004694:	07a1                	addi	a5,a5,8
    80004696:	fed51ce3          	bne	a0,a3,8000468e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000469a:	557d                	li	a0,-1
}
    8000469c:	60e2                	ld	ra,24(sp)
    8000469e:	6442                	ld	s0,16(sp)
    800046a0:	64a2                	ld	s1,8(sp)
    800046a2:	6105                	addi	sp,sp,32
    800046a4:	8082                	ret
      p->ofile[fd] = f;
    800046a6:	01a50793          	addi	a5,a0,26
    800046aa:	078e                	slli	a5,a5,0x3
    800046ac:	963e                	add	a2,a2,a5
    800046ae:	e604                	sd	s1,8(a2)
      return fd;
    800046b0:	b7f5                	j	8000469c <fdalloc+0x2c>

00000000800046b2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046b2:	715d                	addi	sp,sp,-80
    800046b4:	e486                	sd	ra,72(sp)
    800046b6:	e0a2                	sd	s0,64(sp)
    800046b8:	fc26                	sd	s1,56(sp)
    800046ba:	f84a                	sd	s2,48(sp)
    800046bc:	f44e                	sd	s3,40(sp)
    800046be:	f052                	sd	s4,32(sp)
    800046c0:	ec56                	sd	s5,24(sp)
    800046c2:	e85a                	sd	s6,16(sp)
    800046c4:	0880                	addi	s0,sp,80
    800046c6:	8b2e                	mv	s6,a1
    800046c8:	89b2                	mv	s3,a2
    800046ca:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046cc:	fb040593          	addi	a1,s0,-80
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	e26080e7          	jalr	-474(ra) # 800034f6 <nameiparent>
    800046d8:	84aa                	mv	s1,a0
    800046da:	14050f63          	beqz	a0,80004838 <create+0x186>
    return 0;

  ilock(dp);
    800046de:	ffffe097          	auipc	ra,0xffffe
    800046e2:	64e080e7          	jalr	1614(ra) # 80002d2c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800046e6:	4601                	li	a2,0
    800046e8:	fb040593          	addi	a1,s0,-80
    800046ec:	8526                	mv	a0,s1
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	b22080e7          	jalr	-1246(ra) # 80003210 <dirlookup>
    800046f6:	8aaa                	mv	s5,a0
    800046f8:	c931                	beqz	a0,8000474c <create+0x9a>
    iunlockput(dp);
    800046fa:	8526                	mv	a0,s1
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	892080e7          	jalr	-1902(ra) # 80002f8e <iunlockput>
    ilock(ip);
    80004704:	8556                	mv	a0,s5
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	626080e7          	jalr	1574(ra) # 80002d2c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000470e:	000b059b          	sext.w	a1,s6
    80004712:	4789                	li	a5,2
    80004714:	02f59563          	bne	a1,a5,8000473e <create+0x8c>
    80004718:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdd034>
    8000471c:	37f9                	addiw	a5,a5,-2
    8000471e:	17c2                	slli	a5,a5,0x30
    80004720:	93c1                	srli	a5,a5,0x30
    80004722:	4705                	li	a4,1
    80004724:	00f76d63          	bltu	a4,a5,8000473e <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004728:	8556                	mv	a0,s5
    8000472a:	60a6                	ld	ra,72(sp)
    8000472c:	6406                	ld	s0,64(sp)
    8000472e:	74e2                	ld	s1,56(sp)
    80004730:	7942                	ld	s2,48(sp)
    80004732:	79a2                	ld	s3,40(sp)
    80004734:	7a02                	ld	s4,32(sp)
    80004736:	6ae2                	ld	s5,24(sp)
    80004738:	6b42                	ld	s6,16(sp)
    8000473a:	6161                	addi	sp,sp,80
    8000473c:	8082                	ret
    iunlockput(ip);
    8000473e:	8556                	mv	a0,s5
    80004740:	fffff097          	auipc	ra,0xfffff
    80004744:	84e080e7          	jalr	-1970(ra) # 80002f8e <iunlockput>
    return 0;
    80004748:	4a81                	li	s5,0
    8000474a:	bff9                	j	80004728 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000474c:	85da                	mv	a1,s6
    8000474e:	4088                	lw	a0,0(s1)
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	43e080e7          	jalr	1086(ra) # 80002b8e <ialloc>
    80004758:	8a2a                	mv	s4,a0
    8000475a:	c539                	beqz	a0,800047a8 <create+0xf6>
  ilock(ip);
    8000475c:	ffffe097          	auipc	ra,0xffffe
    80004760:	5d0080e7          	jalr	1488(ra) # 80002d2c <ilock>
  ip->major = major;
    80004764:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004768:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000476c:	4905                	li	s2,1
    8000476e:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004772:	8552                	mv	a0,s4
    80004774:	ffffe097          	auipc	ra,0xffffe
    80004778:	4ec080e7          	jalr	1260(ra) # 80002c60 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000477c:	000b059b          	sext.w	a1,s6
    80004780:	03258b63          	beq	a1,s2,800047b6 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    80004784:	004a2603          	lw	a2,4(s4)
    80004788:	fb040593          	addi	a1,s0,-80
    8000478c:	8526                	mv	a0,s1
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	c98080e7          	jalr	-872(ra) # 80003426 <dirlink>
    80004796:	06054f63          	bltz	a0,80004814 <create+0x162>
  iunlockput(dp);
    8000479a:	8526                	mv	a0,s1
    8000479c:	ffffe097          	auipc	ra,0xffffe
    800047a0:	7f2080e7          	jalr	2034(ra) # 80002f8e <iunlockput>
  return ip;
    800047a4:	8ad2                	mv	s5,s4
    800047a6:	b749                	j	80004728 <create+0x76>
    iunlockput(dp);
    800047a8:	8526                	mv	a0,s1
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	7e4080e7          	jalr	2020(ra) # 80002f8e <iunlockput>
    return 0;
    800047b2:	8ad2                	mv	s5,s4
    800047b4:	bf95                	j	80004728 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047b6:	004a2603          	lw	a2,4(s4)
    800047ba:	00004597          	auipc	a1,0x4
    800047be:	f5e58593          	addi	a1,a1,-162 # 80008718 <syscalls+0x318>
    800047c2:	8552                	mv	a0,s4
    800047c4:	fffff097          	auipc	ra,0xfffff
    800047c8:	c62080e7          	jalr	-926(ra) # 80003426 <dirlink>
    800047cc:	04054463          	bltz	a0,80004814 <create+0x162>
    800047d0:	40d0                	lw	a2,4(s1)
    800047d2:	00004597          	auipc	a1,0x4
    800047d6:	f4e58593          	addi	a1,a1,-178 # 80008720 <syscalls+0x320>
    800047da:	8552                	mv	a0,s4
    800047dc:	fffff097          	auipc	ra,0xfffff
    800047e0:	c4a080e7          	jalr	-950(ra) # 80003426 <dirlink>
    800047e4:	02054863          	bltz	a0,80004814 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    800047e8:	004a2603          	lw	a2,4(s4)
    800047ec:	fb040593          	addi	a1,s0,-80
    800047f0:	8526                	mv	a0,s1
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	c34080e7          	jalr	-972(ra) # 80003426 <dirlink>
    800047fa:	00054d63          	bltz	a0,80004814 <create+0x162>
    dp->nlink++;  // for ".."
    800047fe:	04a4d783          	lhu	a5,74(s1)
    80004802:	2785                	addiw	a5,a5,1
    80004804:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004808:	8526                	mv	a0,s1
    8000480a:	ffffe097          	auipc	ra,0xffffe
    8000480e:	456080e7          	jalr	1110(ra) # 80002c60 <iupdate>
    80004812:	b761                	j	8000479a <create+0xe8>
  ip->nlink = 0;
    80004814:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004818:	8552                	mv	a0,s4
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	446080e7          	jalr	1094(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004822:	8552                	mv	a0,s4
    80004824:	ffffe097          	auipc	ra,0xffffe
    80004828:	76a080e7          	jalr	1898(ra) # 80002f8e <iunlockput>
  iunlockput(dp);
    8000482c:	8526                	mv	a0,s1
    8000482e:	ffffe097          	auipc	ra,0xffffe
    80004832:	760080e7          	jalr	1888(ra) # 80002f8e <iunlockput>
  return 0;
    80004836:	bdcd                	j	80004728 <create+0x76>
    return 0;
    80004838:	8aaa                	mv	s5,a0
    8000483a:	b5fd                	j	80004728 <create+0x76>

000000008000483c <sys_dup>:
{
    8000483c:	7179                	addi	sp,sp,-48
    8000483e:	f406                	sd	ra,40(sp)
    80004840:	f022                	sd	s0,32(sp)
    80004842:	ec26                	sd	s1,24(sp)
    80004844:	e84a                	sd	s2,16(sp)
    80004846:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004848:	fd840613          	addi	a2,s0,-40
    8000484c:	4581                	li	a1,0
    8000484e:	4501                	li	a0,0
    80004850:	00000097          	auipc	ra,0x0
    80004854:	dc0080e7          	jalr	-576(ra) # 80004610 <argfd>
    return -1;
    80004858:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000485a:	02054363          	bltz	a0,80004880 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000485e:	fd843903          	ld	s2,-40(s0)
    80004862:	854a                	mv	a0,s2
    80004864:	00000097          	auipc	ra,0x0
    80004868:	e0c080e7          	jalr	-500(ra) # 80004670 <fdalloc>
    8000486c:	84aa                	mv	s1,a0
    return -1;
    8000486e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004870:	00054863          	bltz	a0,80004880 <sys_dup+0x44>
  filedup(f);
    80004874:	854a                	mv	a0,s2
    80004876:	fffff097          	auipc	ra,0xfffff
    8000487a:	2f8080e7          	jalr	760(ra) # 80003b6e <filedup>
  return fd;
    8000487e:	87a6                	mv	a5,s1
}
    80004880:	853e                	mv	a0,a5
    80004882:	70a2                	ld	ra,40(sp)
    80004884:	7402                	ld	s0,32(sp)
    80004886:	64e2                	ld	s1,24(sp)
    80004888:	6942                	ld	s2,16(sp)
    8000488a:	6145                	addi	sp,sp,48
    8000488c:	8082                	ret

000000008000488e <sys_read>:
{
    8000488e:	7179                	addi	sp,sp,-48
    80004890:	f406                	sd	ra,40(sp)
    80004892:	f022                	sd	s0,32(sp)
    80004894:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004896:	fd840593          	addi	a1,s0,-40
    8000489a:	4505                	li	a0,1
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	856080e7          	jalr	-1962(ra) # 800020f2 <argaddr>
  argint(2, &n);
    800048a4:	fe440593          	addi	a1,s0,-28
    800048a8:	4509                	li	a0,2
    800048aa:	ffffe097          	auipc	ra,0xffffe
    800048ae:	828080e7          	jalr	-2008(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    800048b2:	fe840613          	addi	a2,s0,-24
    800048b6:	4581                	li	a1,0
    800048b8:	4501                	li	a0,0
    800048ba:	00000097          	auipc	ra,0x0
    800048be:	d56080e7          	jalr	-682(ra) # 80004610 <argfd>
    800048c2:	87aa                	mv	a5,a0
    return -1;
    800048c4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048c6:	0007cc63          	bltz	a5,800048de <sys_read+0x50>
  return fileread(f, p, n);
    800048ca:	fe442603          	lw	a2,-28(s0)
    800048ce:	fd843583          	ld	a1,-40(s0)
    800048d2:	fe843503          	ld	a0,-24(s0)
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	424080e7          	jalr	1060(ra) # 80003cfa <fileread>
}
    800048de:	70a2                	ld	ra,40(sp)
    800048e0:	7402                	ld	s0,32(sp)
    800048e2:	6145                	addi	sp,sp,48
    800048e4:	8082                	ret

00000000800048e6 <sys_write>:
{
    800048e6:	7179                	addi	sp,sp,-48
    800048e8:	f406                	sd	ra,40(sp)
    800048ea:	f022                	sd	s0,32(sp)
    800048ec:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048ee:	fd840593          	addi	a1,s0,-40
    800048f2:	4505                	li	a0,1
    800048f4:	ffffd097          	auipc	ra,0xffffd
    800048f8:	7fe080e7          	jalr	2046(ra) # 800020f2 <argaddr>
  argint(2, &n);
    800048fc:	fe440593          	addi	a1,s0,-28
    80004900:	4509                	li	a0,2
    80004902:	ffffd097          	auipc	ra,0xffffd
    80004906:	7d0080e7          	jalr	2000(ra) # 800020d2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000490a:	fe840613          	addi	a2,s0,-24
    8000490e:	4581                	li	a1,0
    80004910:	4501                	li	a0,0
    80004912:	00000097          	auipc	ra,0x0
    80004916:	cfe080e7          	jalr	-770(ra) # 80004610 <argfd>
    8000491a:	87aa                	mv	a5,a0
    return -1;
    8000491c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000491e:	0007cc63          	bltz	a5,80004936 <sys_write+0x50>
  return filewrite(f, p, n);
    80004922:	fe442603          	lw	a2,-28(s0)
    80004926:	fd843583          	ld	a1,-40(s0)
    8000492a:	fe843503          	ld	a0,-24(s0)
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	48e080e7          	jalr	1166(ra) # 80003dbc <filewrite>
}
    80004936:	70a2                	ld	ra,40(sp)
    80004938:	7402                	ld	s0,32(sp)
    8000493a:	6145                	addi	sp,sp,48
    8000493c:	8082                	ret

000000008000493e <sys_close>:
{
    8000493e:	1101                	addi	sp,sp,-32
    80004940:	ec06                	sd	ra,24(sp)
    80004942:	e822                	sd	s0,16(sp)
    80004944:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004946:	fe040613          	addi	a2,s0,-32
    8000494a:	fec40593          	addi	a1,s0,-20
    8000494e:	4501                	li	a0,0
    80004950:	00000097          	auipc	ra,0x0
    80004954:	cc0080e7          	jalr	-832(ra) # 80004610 <argfd>
    return -1;
    80004958:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000495a:	02054463          	bltz	a0,80004982 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000495e:	ffffc097          	auipc	ra,0xffffc
    80004962:	5e0080e7          	jalr	1504(ra) # 80000f3e <myproc>
    80004966:	fec42783          	lw	a5,-20(s0)
    8000496a:	07e9                	addi	a5,a5,26
    8000496c:	078e                	slli	a5,a5,0x3
    8000496e:	953e                	add	a0,a0,a5
    80004970:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004974:	fe043503          	ld	a0,-32(s0)
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	248080e7          	jalr	584(ra) # 80003bc0 <fileclose>
  return 0;
    80004980:	4781                	li	a5,0
}
    80004982:	853e                	mv	a0,a5
    80004984:	60e2                	ld	ra,24(sp)
    80004986:	6442                	ld	s0,16(sp)
    80004988:	6105                	addi	sp,sp,32
    8000498a:	8082                	ret

000000008000498c <sys_fstat>:
{
    8000498c:	1101                	addi	sp,sp,-32
    8000498e:	ec06                	sd	ra,24(sp)
    80004990:	e822                	sd	s0,16(sp)
    80004992:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004994:	fe040593          	addi	a1,s0,-32
    80004998:	4505                	li	a0,1
    8000499a:	ffffd097          	auipc	ra,0xffffd
    8000499e:	758080e7          	jalr	1880(ra) # 800020f2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049a2:	fe840613          	addi	a2,s0,-24
    800049a6:	4581                	li	a1,0
    800049a8:	4501                	li	a0,0
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	c66080e7          	jalr	-922(ra) # 80004610 <argfd>
    800049b2:	87aa                	mv	a5,a0
    return -1;
    800049b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049b6:	0007ca63          	bltz	a5,800049ca <sys_fstat+0x3e>
  return filestat(f, st);
    800049ba:	fe043583          	ld	a1,-32(s0)
    800049be:	fe843503          	ld	a0,-24(s0)
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	2c6080e7          	jalr	710(ra) # 80003c88 <filestat>
}
    800049ca:	60e2                	ld	ra,24(sp)
    800049cc:	6442                	ld	s0,16(sp)
    800049ce:	6105                	addi	sp,sp,32
    800049d0:	8082                	ret

00000000800049d2 <sys_link>:
{
    800049d2:	7169                	addi	sp,sp,-304
    800049d4:	f606                	sd	ra,296(sp)
    800049d6:	f222                	sd	s0,288(sp)
    800049d8:	ee26                	sd	s1,280(sp)
    800049da:	ea4a                	sd	s2,272(sp)
    800049dc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049de:	08000613          	li	a2,128
    800049e2:	ed040593          	addi	a1,s0,-304
    800049e6:	4501                	li	a0,0
    800049e8:	ffffd097          	auipc	ra,0xffffd
    800049ec:	72a080e7          	jalr	1834(ra) # 80002112 <argstr>
    return -1;
    800049f0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800049f2:	10054e63          	bltz	a0,80004b0e <sys_link+0x13c>
    800049f6:	08000613          	li	a2,128
    800049fa:	f5040593          	addi	a1,s0,-176
    800049fe:	4505                	li	a0,1
    80004a00:	ffffd097          	auipc	ra,0xffffd
    80004a04:	712080e7          	jalr	1810(ra) # 80002112 <argstr>
    return -1;
    80004a08:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a0a:	10054263          	bltz	a0,80004b0e <sys_link+0x13c>
  begin_op();
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	cea080e7          	jalr	-790(ra) # 800036f8 <begin_op>
  if((ip = namei(old)) == 0){
    80004a16:	ed040513          	addi	a0,s0,-304
    80004a1a:	fffff097          	auipc	ra,0xfffff
    80004a1e:	abe080e7          	jalr	-1346(ra) # 800034d8 <namei>
    80004a22:	84aa                	mv	s1,a0
    80004a24:	c551                	beqz	a0,80004ab0 <sys_link+0xde>
  ilock(ip);
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	306080e7          	jalr	774(ra) # 80002d2c <ilock>
  if(ip->type == T_DIR){
    80004a2e:	04449703          	lh	a4,68(s1)
    80004a32:	4785                	li	a5,1
    80004a34:	08f70463          	beq	a4,a5,80004abc <sys_link+0xea>
  ip->nlink++;
    80004a38:	04a4d783          	lhu	a5,74(s1)
    80004a3c:	2785                	addiw	a5,a5,1
    80004a3e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a42:	8526                	mv	a0,s1
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	21c080e7          	jalr	540(ra) # 80002c60 <iupdate>
  iunlock(ip);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	3a0080e7          	jalr	928(ra) # 80002dee <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a56:	fd040593          	addi	a1,s0,-48
    80004a5a:	f5040513          	addi	a0,s0,-176
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	a98080e7          	jalr	-1384(ra) # 800034f6 <nameiparent>
    80004a66:	892a                	mv	s2,a0
    80004a68:	c935                	beqz	a0,80004adc <sys_link+0x10a>
  ilock(dp);
    80004a6a:	ffffe097          	auipc	ra,0xffffe
    80004a6e:	2c2080e7          	jalr	706(ra) # 80002d2c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a72:	00092703          	lw	a4,0(s2)
    80004a76:	409c                	lw	a5,0(s1)
    80004a78:	04f71d63          	bne	a4,a5,80004ad2 <sys_link+0x100>
    80004a7c:	40d0                	lw	a2,4(s1)
    80004a7e:	fd040593          	addi	a1,s0,-48
    80004a82:	854a                	mv	a0,s2
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	9a2080e7          	jalr	-1630(ra) # 80003426 <dirlink>
    80004a8c:	04054363          	bltz	a0,80004ad2 <sys_link+0x100>
  iunlockput(dp);
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	4fc080e7          	jalr	1276(ra) # 80002f8e <iunlockput>
  iput(ip);
    80004a9a:	8526                	mv	a0,s1
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	44a080e7          	jalr	1098(ra) # 80002ee6 <iput>
  end_op();
    80004aa4:	fffff097          	auipc	ra,0xfffff
    80004aa8:	cd2080e7          	jalr	-814(ra) # 80003776 <end_op>
  return 0;
    80004aac:	4781                	li	a5,0
    80004aae:	a085                	j	80004b0e <sys_link+0x13c>
    end_op();
    80004ab0:	fffff097          	auipc	ra,0xfffff
    80004ab4:	cc6080e7          	jalr	-826(ra) # 80003776 <end_op>
    return -1;
    80004ab8:	57fd                	li	a5,-1
    80004aba:	a891                	j	80004b0e <sys_link+0x13c>
    iunlockput(ip);
    80004abc:	8526                	mv	a0,s1
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	4d0080e7          	jalr	1232(ra) # 80002f8e <iunlockput>
    end_op();
    80004ac6:	fffff097          	auipc	ra,0xfffff
    80004aca:	cb0080e7          	jalr	-848(ra) # 80003776 <end_op>
    return -1;
    80004ace:	57fd                	li	a5,-1
    80004ad0:	a83d                	j	80004b0e <sys_link+0x13c>
    iunlockput(dp);
    80004ad2:	854a                	mv	a0,s2
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	4ba080e7          	jalr	1210(ra) # 80002f8e <iunlockput>
  ilock(ip);
    80004adc:	8526                	mv	a0,s1
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	24e080e7          	jalr	590(ra) # 80002d2c <ilock>
  ip->nlink--;
    80004ae6:	04a4d783          	lhu	a5,74(s1)
    80004aea:	37fd                	addiw	a5,a5,-1
    80004aec:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004af0:	8526                	mv	a0,s1
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	16e080e7          	jalr	366(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	492080e7          	jalr	1170(ra) # 80002f8e <iunlockput>
  end_op();
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	c72080e7          	jalr	-910(ra) # 80003776 <end_op>
  return -1;
    80004b0c:	57fd                	li	a5,-1
}
    80004b0e:	853e                	mv	a0,a5
    80004b10:	70b2                	ld	ra,296(sp)
    80004b12:	7412                	ld	s0,288(sp)
    80004b14:	64f2                	ld	s1,280(sp)
    80004b16:	6952                	ld	s2,272(sp)
    80004b18:	6155                	addi	sp,sp,304
    80004b1a:	8082                	ret

0000000080004b1c <sys_unlink>:
{
    80004b1c:	7151                	addi	sp,sp,-240
    80004b1e:	f586                	sd	ra,232(sp)
    80004b20:	f1a2                	sd	s0,224(sp)
    80004b22:	eda6                	sd	s1,216(sp)
    80004b24:	e9ca                	sd	s2,208(sp)
    80004b26:	e5ce                	sd	s3,200(sp)
    80004b28:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b2a:	08000613          	li	a2,128
    80004b2e:	f3040593          	addi	a1,s0,-208
    80004b32:	4501                	li	a0,0
    80004b34:	ffffd097          	auipc	ra,0xffffd
    80004b38:	5de080e7          	jalr	1502(ra) # 80002112 <argstr>
    80004b3c:	18054163          	bltz	a0,80004cbe <sys_unlink+0x1a2>
  begin_op();
    80004b40:	fffff097          	auipc	ra,0xfffff
    80004b44:	bb8080e7          	jalr	-1096(ra) # 800036f8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b48:	fb040593          	addi	a1,s0,-80
    80004b4c:	f3040513          	addi	a0,s0,-208
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	9a6080e7          	jalr	-1626(ra) # 800034f6 <nameiparent>
    80004b58:	84aa                	mv	s1,a0
    80004b5a:	c979                	beqz	a0,80004c30 <sys_unlink+0x114>
  ilock(dp);
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	1d0080e7          	jalr	464(ra) # 80002d2c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b64:	00004597          	auipc	a1,0x4
    80004b68:	bb458593          	addi	a1,a1,-1100 # 80008718 <syscalls+0x318>
    80004b6c:	fb040513          	addi	a0,s0,-80
    80004b70:	ffffe097          	auipc	ra,0xffffe
    80004b74:	686080e7          	jalr	1670(ra) # 800031f6 <namecmp>
    80004b78:	14050a63          	beqz	a0,80004ccc <sys_unlink+0x1b0>
    80004b7c:	00004597          	auipc	a1,0x4
    80004b80:	ba458593          	addi	a1,a1,-1116 # 80008720 <syscalls+0x320>
    80004b84:	fb040513          	addi	a0,s0,-80
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	66e080e7          	jalr	1646(ra) # 800031f6 <namecmp>
    80004b90:	12050e63          	beqz	a0,80004ccc <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004b94:	f2c40613          	addi	a2,s0,-212
    80004b98:	fb040593          	addi	a1,s0,-80
    80004b9c:	8526                	mv	a0,s1
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	672080e7          	jalr	1650(ra) # 80003210 <dirlookup>
    80004ba6:	892a                	mv	s2,a0
    80004ba8:	12050263          	beqz	a0,80004ccc <sys_unlink+0x1b0>
  ilock(ip);
    80004bac:	ffffe097          	auipc	ra,0xffffe
    80004bb0:	180080e7          	jalr	384(ra) # 80002d2c <ilock>
  if(ip->nlink < 1)
    80004bb4:	04a91783          	lh	a5,74(s2)
    80004bb8:	08f05263          	blez	a5,80004c3c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004bbc:	04491703          	lh	a4,68(s2)
    80004bc0:	4785                	li	a5,1
    80004bc2:	08f70563          	beq	a4,a5,80004c4c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bc6:	4641                	li	a2,16
    80004bc8:	4581                	li	a1,0
    80004bca:	fc040513          	addi	a0,s0,-64
    80004bce:	ffffb097          	auipc	ra,0xffffb
    80004bd2:	5ac080e7          	jalr	1452(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bd6:	4741                	li	a4,16
    80004bd8:	f2c42683          	lw	a3,-212(s0)
    80004bdc:	fc040613          	addi	a2,s0,-64
    80004be0:	4581                	li	a1,0
    80004be2:	8526                	mv	a0,s1
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	4f4080e7          	jalr	1268(ra) # 800030d8 <writei>
    80004bec:	47c1                	li	a5,16
    80004bee:	0af51563          	bne	a0,a5,80004c98 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004bf2:	04491703          	lh	a4,68(s2)
    80004bf6:	4785                	li	a5,1
    80004bf8:	0af70863          	beq	a4,a5,80004ca8 <sys_unlink+0x18c>
  iunlockput(dp);
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	ffffe097          	auipc	ra,0xffffe
    80004c02:	390080e7          	jalr	912(ra) # 80002f8e <iunlockput>
  ip->nlink--;
    80004c06:	04a95783          	lhu	a5,74(s2)
    80004c0a:	37fd                	addiw	a5,a5,-1
    80004c0c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c10:	854a                	mv	a0,s2
    80004c12:	ffffe097          	auipc	ra,0xffffe
    80004c16:	04e080e7          	jalr	78(ra) # 80002c60 <iupdate>
  iunlockput(ip);
    80004c1a:	854a                	mv	a0,s2
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	372080e7          	jalr	882(ra) # 80002f8e <iunlockput>
  end_op();
    80004c24:	fffff097          	auipc	ra,0xfffff
    80004c28:	b52080e7          	jalr	-1198(ra) # 80003776 <end_op>
  return 0;
    80004c2c:	4501                	li	a0,0
    80004c2e:	a84d                	j	80004ce0 <sys_unlink+0x1c4>
    end_op();
    80004c30:	fffff097          	auipc	ra,0xfffff
    80004c34:	b46080e7          	jalr	-1210(ra) # 80003776 <end_op>
    return -1;
    80004c38:	557d                	li	a0,-1
    80004c3a:	a05d                	j	80004ce0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c3c:	00004517          	auipc	a0,0x4
    80004c40:	aec50513          	addi	a0,a0,-1300 # 80008728 <syscalls+0x328>
    80004c44:	00001097          	auipc	ra,0x1
    80004c48:	1b8080e7          	jalr	440(ra) # 80005dfc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c4c:	04c92703          	lw	a4,76(s2)
    80004c50:	02000793          	li	a5,32
    80004c54:	f6e7f9e3          	bgeu	a5,a4,80004bc6 <sys_unlink+0xaa>
    80004c58:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c5c:	4741                	li	a4,16
    80004c5e:	86ce                	mv	a3,s3
    80004c60:	f1840613          	addi	a2,s0,-232
    80004c64:	4581                	li	a1,0
    80004c66:	854a                	mv	a0,s2
    80004c68:	ffffe097          	auipc	ra,0xffffe
    80004c6c:	378080e7          	jalr	888(ra) # 80002fe0 <readi>
    80004c70:	47c1                	li	a5,16
    80004c72:	00f51b63          	bne	a0,a5,80004c88 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004c76:	f1845783          	lhu	a5,-232(s0)
    80004c7a:	e7a1                	bnez	a5,80004cc2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c7c:	29c1                	addiw	s3,s3,16
    80004c7e:	04c92783          	lw	a5,76(s2)
    80004c82:	fcf9ede3          	bltu	s3,a5,80004c5c <sys_unlink+0x140>
    80004c86:	b781                	j	80004bc6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004c88:	00004517          	auipc	a0,0x4
    80004c8c:	ab850513          	addi	a0,a0,-1352 # 80008740 <syscalls+0x340>
    80004c90:	00001097          	auipc	ra,0x1
    80004c94:	16c080e7          	jalr	364(ra) # 80005dfc <panic>
    panic("unlink: writei");
    80004c98:	00004517          	auipc	a0,0x4
    80004c9c:	ac050513          	addi	a0,a0,-1344 # 80008758 <syscalls+0x358>
    80004ca0:	00001097          	auipc	ra,0x1
    80004ca4:	15c080e7          	jalr	348(ra) # 80005dfc <panic>
    dp->nlink--;
    80004ca8:	04a4d783          	lhu	a5,74(s1)
    80004cac:	37fd                	addiw	a5,a5,-1
    80004cae:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	fac080e7          	jalr	-84(ra) # 80002c60 <iupdate>
    80004cbc:	b781                	j	80004bfc <sys_unlink+0xe0>
    return -1;
    80004cbe:	557d                	li	a0,-1
    80004cc0:	a005                	j	80004ce0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cc2:	854a                	mv	a0,s2
    80004cc4:	ffffe097          	auipc	ra,0xffffe
    80004cc8:	2ca080e7          	jalr	714(ra) # 80002f8e <iunlockput>
  iunlockput(dp);
    80004ccc:	8526                	mv	a0,s1
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	2c0080e7          	jalr	704(ra) # 80002f8e <iunlockput>
  end_op();
    80004cd6:	fffff097          	auipc	ra,0xfffff
    80004cda:	aa0080e7          	jalr	-1376(ra) # 80003776 <end_op>
  return -1;
    80004cde:	557d                	li	a0,-1
}
    80004ce0:	70ae                	ld	ra,232(sp)
    80004ce2:	740e                	ld	s0,224(sp)
    80004ce4:	64ee                	ld	s1,216(sp)
    80004ce6:	694e                	ld	s2,208(sp)
    80004ce8:	69ae                	ld	s3,200(sp)
    80004cea:	616d                	addi	sp,sp,240
    80004cec:	8082                	ret

0000000080004cee <sys_open>:

uint64
sys_open(void)
{
    80004cee:	7131                	addi	sp,sp,-192
    80004cf0:	fd06                	sd	ra,184(sp)
    80004cf2:	f922                	sd	s0,176(sp)
    80004cf4:	f526                	sd	s1,168(sp)
    80004cf6:	f14a                	sd	s2,160(sp)
    80004cf8:	ed4e                	sd	s3,152(sp)
    80004cfa:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004cfc:	f4c40593          	addi	a1,s0,-180
    80004d00:	4505                	li	a0,1
    80004d02:	ffffd097          	auipc	ra,0xffffd
    80004d06:	3d0080e7          	jalr	976(ra) # 800020d2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f5040593          	addi	a1,s0,-176
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	3fe080e7          	jalr	1022(ra) # 80002112 <argstr>
    80004d1c:	87aa                	mv	a5,a0
    return -1;
    80004d1e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d20:	0a07c963          	bltz	a5,80004dd2 <sys_open+0xe4>

  begin_op();
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	9d4080e7          	jalr	-1580(ra) # 800036f8 <begin_op>

  if(omode & O_CREATE){
    80004d2c:	f4c42783          	lw	a5,-180(s0)
    80004d30:	2007f793          	andi	a5,a5,512
    80004d34:	cfc5                	beqz	a5,80004dec <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d36:	4681                	li	a3,0
    80004d38:	4601                	li	a2,0
    80004d3a:	4589                	li	a1,2
    80004d3c:	f5040513          	addi	a0,s0,-176
    80004d40:	00000097          	auipc	ra,0x0
    80004d44:	972080e7          	jalr	-1678(ra) # 800046b2 <create>
    80004d48:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d4a:	c959                	beqz	a0,80004de0 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d4c:	04449703          	lh	a4,68(s1)
    80004d50:	478d                	li	a5,3
    80004d52:	00f71763          	bne	a4,a5,80004d60 <sys_open+0x72>
    80004d56:	0464d703          	lhu	a4,70(s1)
    80004d5a:	47a5                	li	a5,9
    80004d5c:	0ce7ed63          	bltu	a5,a4,80004e36 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	da4080e7          	jalr	-604(ra) # 80003b04 <filealloc>
    80004d68:	89aa                	mv	s3,a0
    80004d6a:	10050363          	beqz	a0,80004e70 <sys_open+0x182>
    80004d6e:	00000097          	auipc	ra,0x0
    80004d72:	902080e7          	jalr	-1790(ra) # 80004670 <fdalloc>
    80004d76:	892a                	mv	s2,a0
    80004d78:	0e054763          	bltz	a0,80004e66 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004d7c:	04449703          	lh	a4,68(s1)
    80004d80:	478d                	li	a5,3
    80004d82:	0cf70563          	beq	a4,a5,80004e4c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004d86:	4789                	li	a5,2
    80004d88:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004d8c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004d90:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004d94:	f4c42783          	lw	a5,-180(s0)
    80004d98:	0017c713          	xori	a4,a5,1
    80004d9c:	8b05                	andi	a4,a4,1
    80004d9e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004da2:	0037f713          	andi	a4,a5,3
    80004da6:	00e03733          	snez	a4,a4
    80004daa:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dae:	4007f793          	andi	a5,a5,1024
    80004db2:	c791                	beqz	a5,80004dbe <sys_open+0xd0>
    80004db4:	04449703          	lh	a4,68(s1)
    80004db8:	4789                	li	a5,2
    80004dba:	0af70063          	beq	a4,a5,80004e5a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004dbe:	8526                	mv	a0,s1
    80004dc0:	ffffe097          	auipc	ra,0xffffe
    80004dc4:	02e080e7          	jalr	46(ra) # 80002dee <iunlock>
  end_op();
    80004dc8:	fffff097          	auipc	ra,0xfffff
    80004dcc:	9ae080e7          	jalr	-1618(ra) # 80003776 <end_op>

  return fd;
    80004dd0:	854a                	mv	a0,s2
}
    80004dd2:	70ea                	ld	ra,184(sp)
    80004dd4:	744a                	ld	s0,176(sp)
    80004dd6:	74aa                	ld	s1,168(sp)
    80004dd8:	790a                	ld	s2,160(sp)
    80004dda:	69ea                	ld	s3,152(sp)
    80004ddc:	6129                	addi	sp,sp,192
    80004dde:	8082                	ret
      end_op();
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	996080e7          	jalr	-1642(ra) # 80003776 <end_op>
      return -1;
    80004de8:	557d                	li	a0,-1
    80004dea:	b7e5                	j	80004dd2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004dec:	f5040513          	addi	a0,s0,-176
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	6e8080e7          	jalr	1768(ra) # 800034d8 <namei>
    80004df8:	84aa                	mv	s1,a0
    80004dfa:	c905                	beqz	a0,80004e2a <sys_open+0x13c>
    ilock(ip);
    80004dfc:	ffffe097          	auipc	ra,0xffffe
    80004e00:	f30080e7          	jalr	-208(ra) # 80002d2c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e04:	04449703          	lh	a4,68(s1)
    80004e08:	4785                	li	a5,1
    80004e0a:	f4f711e3          	bne	a4,a5,80004d4c <sys_open+0x5e>
    80004e0e:	f4c42783          	lw	a5,-180(s0)
    80004e12:	d7b9                	beqz	a5,80004d60 <sys_open+0x72>
      iunlockput(ip);
    80004e14:	8526                	mv	a0,s1
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	178080e7          	jalr	376(ra) # 80002f8e <iunlockput>
      end_op();
    80004e1e:	fffff097          	auipc	ra,0xfffff
    80004e22:	958080e7          	jalr	-1704(ra) # 80003776 <end_op>
      return -1;
    80004e26:	557d                	li	a0,-1
    80004e28:	b76d                	j	80004dd2 <sys_open+0xe4>
      end_op();
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	94c080e7          	jalr	-1716(ra) # 80003776 <end_op>
      return -1;
    80004e32:	557d                	li	a0,-1
    80004e34:	bf79                	j	80004dd2 <sys_open+0xe4>
    iunlockput(ip);
    80004e36:	8526                	mv	a0,s1
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	156080e7          	jalr	342(ra) # 80002f8e <iunlockput>
    end_op();
    80004e40:	fffff097          	auipc	ra,0xfffff
    80004e44:	936080e7          	jalr	-1738(ra) # 80003776 <end_op>
    return -1;
    80004e48:	557d                	li	a0,-1
    80004e4a:	b761                	j	80004dd2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e4c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e50:	04649783          	lh	a5,70(s1)
    80004e54:	02f99223          	sh	a5,36(s3)
    80004e58:	bf25                	j	80004d90 <sys_open+0xa2>
    itrunc(ip);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	fde080e7          	jalr	-34(ra) # 80002e3a <itrunc>
    80004e64:	bfa9                	j	80004dbe <sys_open+0xd0>
      fileclose(f);
    80004e66:	854e                	mv	a0,s3
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	d58080e7          	jalr	-680(ra) # 80003bc0 <fileclose>
    iunlockput(ip);
    80004e70:	8526                	mv	a0,s1
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	11c080e7          	jalr	284(ra) # 80002f8e <iunlockput>
    end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	8fc080e7          	jalr	-1796(ra) # 80003776 <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	b7b9                	j	80004dd2 <sys_open+0xe4>

0000000080004e86 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004e86:	7175                	addi	sp,sp,-144
    80004e88:	e506                	sd	ra,136(sp)
    80004e8a:	e122                	sd	s0,128(sp)
    80004e8c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	86a080e7          	jalr	-1942(ra) # 800036f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004e96:	08000613          	li	a2,128
    80004e9a:	f7040593          	addi	a1,s0,-144
    80004e9e:	4501                	li	a0,0
    80004ea0:	ffffd097          	auipc	ra,0xffffd
    80004ea4:	272080e7          	jalr	626(ra) # 80002112 <argstr>
    80004ea8:	02054963          	bltz	a0,80004eda <sys_mkdir+0x54>
    80004eac:	4681                	li	a3,0
    80004eae:	4601                	li	a2,0
    80004eb0:	4585                	li	a1,1
    80004eb2:	f7040513          	addi	a0,s0,-144
    80004eb6:	fffff097          	auipc	ra,0xfffff
    80004eba:	7fc080e7          	jalr	2044(ra) # 800046b2 <create>
    80004ebe:	cd11                	beqz	a0,80004eda <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	0ce080e7          	jalr	206(ra) # 80002f8e <iunlockput>
  end_op();
    80004ec8:	fffff097          	auipc	ra,0xfffff
    80004ecc:	8ae080e7          	jalr	-1874(ra) # 80003776 <end_op>
  return 0;
    80004ed0:	4501                	li	a0,0
}
    80004ed2:	60aa                	ld	ra,136(sp)
    80004ed4:	640a                	ld	s0,128(sp)
    80004ed6:	6149                	addi	sp,sp,144
    80004ed8:	8082                	ret
    end_op();
    80004eda:	fffff097          	auipc	ra,0xfffff
    80004ede:	89c080e7          	jalr	-1892(ra) # 80003776 <end_op>
    return -1;
    80004ee2:	557d                	li	a0,-1
    80004ee4:	b7fd                	j	80004ed2 <sys_mkdir+0x4c>

0000000080004ee6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004ee6:	7135                	addi	sp,sp,-160
    80004ee8:	ed06                	sd	ra,152(sp)
    80004eea:	e922                	sd	s0,144(sp)
    80004eec:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	80a080e7          	jalr	-2038(ra) # 800036f8 <begin_op>
  argint(1, &major);
    80004ef6:	f6c40593          	addi	a1,s0,-148
    80004efa:	4505                	li	a0,1
    80004efc:	ffffd097          	auipc	ra,0xffffd
    80004f00:	1d6080e7          	jalr	470(ra) # 800020d2 <argint>
  argint(2, &minor);
    80004f04:	f6840593          	addi	a1,s0,-152
    80004f08:	4509                	li	a0,2
    80004f0a:	ffffd097          	auipc	ra,0xffffd
    80004f0e:	1c8080e7          	jalr	456(ra) # 800020d2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f12:	08000613          	li	a2,128
    80004f16:	f7040593          	addi	a1,s0,-144
    80004f1a:	4501                	li	a0,0
    80004f1c:	ffffd097          	auipc	ra,0xffffd
    80004f20:	1f6080e7          	jalr	502(ra) # 80002112 <argstr>
    80004f24:	02054b63          	bltz	a0,80004f5a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f28:	f6841683          	lh	a3,-152(s0)
    80004f2c:	f6c41603          	lh	a2,-148(s0)
    80004f30:	458d                	li	a1,3
    80004f32:	f7040513          	addi	a0,s0,-144
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	77c080e7          	jalr	1916(ra) # 800046b2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f3e:	cd11                	beqz	a0,80004f5a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	04e080e7          	jalr	78(ra) # 80002f8e <iunlockput>
  end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	82e080e7          	jalr	-2002(ra) # 80003776 <end_op>
  return 0;
    80004f50:	4501                	li	a0,0
}
    80004f52:	60ea                	ld	ra,152(sp)
    80004f54:	644a                	ld	s0,144(sp)
    80004f56:	610d                	addi	sp,sp,160
    80004f58:	8082                	ret
    end_op();
    80004f5a:	fffff097          	auipc	ra,0xfffff
    80004f5e:	81c080e7          	jalr	-2020(ra) # 80003776 <end_op>
    return -1;
    80004f62:	557d                	li	a0,-1
    80004f64:	b7fd                	j	80004f52 <sys_mknod+0x6c>

0000000080004f66 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f66:	7135                	addi	sp,sp,-160
    80004f68:	ed06                	sd	ra,152(sp)
    80004f6a:	e922                	sd	s0,144(sp)
    80004f6c:	e526                	sd	s1,136(sp)
    80004f6e:	e14a                	sd	s2,128(sp)
    80004f70:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f72:	ffffc097          	auipc	ra,0xffffc
    80004f76:	fcc080e7          	jalr	-52(ra) # 80000f3e <myproc>
    80004f7a:	892a                	mv	s2,a0
  
  begin_op();
    80004f7c:	ffffe097          	auipc	ra,0xffffe
    80004f80:	77c080e7          	jalr	1916(ra) # 800036f8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004f84:	08000613          	li	a2,128
    80004f88:	f6040593          	addi	a1,s0,-160
    80004f8c:	4501                	li	a0,0
    80004f8e:	ffffd097          	auipc	ra,0xffffd
    80004f92:	184080e7          	jalr	388(ra) # 80002112 <argstr>
    80004f96:	04054b63          	bltz	a0,80004fec <sys_chdir+0x86>
    80004f9a:	f6040513          	addi	a0,s0,-160
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	53a080e7          	jalr	1338(ra) # 800034d8 <namei>
    80004fa6:	84aa                	mv	s1,a0
    80004fa8:	c131                	beqz	a0,80004fec <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004faa:	ffffe097          	auipc	ra,0xffffe
    80004fae:	d82080e7          	jalr	-638(ra) # 80002d2c <ilock>
  if(ip->type != T_DIR){
    80004fb2:	04449703          	lh	a4,68(s1)
    80004fb6:	4785                	li	a5,1
    80004fb8:	04f71063          	bne	a4,a5,80004ff8 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fbc:	8526                	mv	a0,s1
    80004fbe:	ffffe097          	auipc	ra,0xffffe
    80004fc2:	e30080e7          	jalr	-464(ra) # 80002dee <iunlock>
  iput(p->cwd);
    80004fc6:	15893503          	ld	a0,344(s2)
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	f1c080e7          	jalr	-228(ra) # 80002ee6 <iput>
  end_op();
    80004fd2:	ffffe097          	auipc	ra,0xffffe
    80004fd6:	7a4080e7          	jalr	1956(ra) # 80003776 <end_op>
  p->cwd = ip;
    80004fda:	14993c23          	sd	s1,344(s2)
  return 0;
    80004fde:	4501                	li	a0,0
}
    80004fe0:	60ea                	ld	ra,152(sp)
    80004fe2:	644a                	ld	s0,144(sp)
    80004fe4:	64aa                	ld	s1,136(sp)
    80004fe6:	690a                	ld	s2,128(sp)
    80004fe8:	610d                	addi	sp,sp,160
    80004fea:	8082                	ret
    end_op();
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	78a080e7          	jalr	1930(ra) # 80003776 <end_op>
    return -1;
    80004ff4:	557d                	li	a0,-1
    80004ff6:	b7ed                	j	80004fe0 <sys_chdir+0x7a>
    iunlockput(ip);
    80004ff8:	8526                	mv	a0,s1
    80004ffa:	ffffe097          	auipc	ra,0xffffe
    80004ffe:	f94080e7          	jalr	-108(ra) # 80002f8e <iunlockput>
    end_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	774080e7          	jalr	1908(ra) # 80003776 <end_op>
    return -1;
    8000500a:	557d                	li	a0,-1
    8000500c:	bfd1                	j	80004fe0 <sys_chdir+0x7a>

000000008000500e <sys_exec>:

uint64
sys_exec(void)
{
    8000500e:	7145                	addi	sp,sp,-464
    80005010:	e786                	sd	ra,456(sp)
    80005012:	e3a2                	sd	s0,448(sp)
    80005014:	ff26                	sd	s1,440(sp)
    80005016:	fb4a                	sd	s2,432(sp)
    80005018:	f74e                	sd	s3,424(sp)
    8000501a:	f352                	sd	s4,416(sp)
    8000501c:	ef56                	sd	s5,408(sp)
    8000501e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005020:	e3840593          	addi	a1,s0,-456
    80005024:	4505                	li	a0,1
    80005026:	ffffd097          	auipc	ra,0xffffd
    8000502a:	0cc080e7          	jalr	204(ra) # 800020f2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000502e:	08000613          	li	a2,128
    80005032:	f4040593          	addi	a1,s0,-192
    80005036:	4501                	li	a0,0
    80005038:	ffffd097          	auipc	ra,0xffffd
    8000503c:	0da080e7          	jalr	218(ra) # 80002112 <argstr>
    80005040:	87aa                	mv	a5,a0
    return -1;
    80005042:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005044:	0c07c363          	bltz	a5,8000510a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80005048:	10000613          	li	a2,256
    8000504c:	4581                	li	a1,0
    8000504e:	e4040513          	addi	a0,s0,-448
    80005052:	ffffb097          	auipc	ra,0xffffb
    80005056:	128080e7          	jalr	296(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000505a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    8000505e:	89a6                	mv	s3,s1
    80005060:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005062:	02000a13          	li	s4,32
    80005066:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000506a:	00391513          	slli	a0,s2,0x3
    8000506e:	e3040593          	addi	a1,s0,-464
    80005072:	e3843783          	ld	a5,-456(s0)
    80005076:	953e                	add	a0,a0,a5
    80005078:	ffffd097          	auipc	ra,0xffffd
    8000507c:	fbc080e7          	jalr	-68(ra) # 80002034 <fetchaddr>
    80005080:	02054a63          	bltz	a0,800050b4 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005084:	e3043783          	ld	a5,-464(s0)
    80005088:	c3b9                	beqz	a5,800050ce <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000508a:	ffffb097          	auipc	ra,0xffffb
    8000508e:	090080e7          	jalr	144(ra) # 8000011a <kalloc>
    80005092:	85aa                	mv	a1,a0
    80005094:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005098:	cd11                	beqz	a0,800050b4 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000509a:	6605                	lui	a2,0x1
    8000509c:	e3043503          	ld	a0,-464(s0)
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	fe6080e7          	jalr	-26(ra) # 80002086 <fetchstr>
    800050a8:	00054663          	bltz	a0,800050b4 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050ac:	0905                	addi	s2,s2,1
    800050ae:	09a1                	addi	s3,s3,8
    800050b0:	fb491be3          	bne	s2,s4,80005066 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050b4:	f4040913          	addi	s2,s0,-192
    800050b8:	6088                	ld	a0,0(s1)
    800050ba:	c539                	beqz	a0,80005108 <sys_exec+0xfa>
    kfree(argv[i]);
    800050bc:	ffffb097          	auipc	ra,0xffffb
    800050c0:	f60080e7          	jalr	-160(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050c4:	04a1                	addi	s1,s1,8
    800050c6:	ff2499e3          	bne	s1,s2,800050b8 <sys_exec+0xaa>
  return -1;
    800050ca:	557d                	li	a0,-1
    800050cc:	a83d                	j	8000510a <sys_exec+0xfc>
      argv[i] = 0;
    800050ce:	0a8e                	slli	s5,s5,0x3
    800050d0:	fc0a8793          	addi	a5,s5,-64
    800050d4:	00878ab3          	add	s5,a5,s0
    800050d8:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800050dc:	e4040593          	addi	a1,s0,-448
    800050e0:	f4040513          	addi	a0,s0,-192
    800050e4:	fffff097          	auipc	ra,0xfffff
    800050e8:	156080e7          	jalr	342(ra) # 8000423a <exec>
    800050ec:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	f4040993          	addi	s3,s0,-192
    800050f2:	6088                	ld	a0,0(s1)
    800050f4:	c901                	beqz	a0,80005104 <sys_exec+0xf6>
    kfree(argv[i]);
    800050f6:	ffffb097          	auipc	ra,0xffffb
    800050fa:	f26080e7          	jalr	-218(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fe:	04a1                	addi	s1,s1,8
    80005100:	ff3499e3          	bne	s1,s3,800050f2 <sys_exec+0xe4>
  return ret;
    80005104:	854a                	mv	a0,s2
    80005106:	a011                	j	8000510a <sys_exec+0xfc>
  return -1;
    80005108:	557d                	li	a0,-1
}
    8000510a:	60be                	ld	ra,456(sp)
    8000510c:	641e                	ld	s0,448(sp)
    8000510e:	74fa                	ld	s1,440(sp)
    80005110:	795a                	ld	s2,432(sp)
    80005112:	79ba                	ld	s3,424(sp)
    80005114:	7a1a                	ld	s4,416(sp)
    80005116:	6afa                	ld	s5,408(sp)
    80005118:	6179                	addi	sp,sp,464
    8000511a:	8082                	ret

000000008000511c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000511c:	7139                	addi	sp,sp,-64
    8000511e:	fc06                	sd	ra,56(sp)
    80005120:	f822                	sd	s0,48(sp)
    80005122:	f426                	sd	s1,40(sp)
    80005124:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	e18080e7          	jalr	-488(ra) # 80000f3e <myproc>
    8000512e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005130:	fd840593          	addi	a1,s0,-40
    80005134:	4501                	li	a0,0
    80005136:	ffffd097          	auipc	ra,0xffffd
    8000513a:	fbc080e7          	jalr	-68(ra) # 800020f2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000513e:	fc840593          	addi	a1,s0,-56
    80005142:	fd040513          	addi	a0,s0,-48
    80005146:	fffff097          	auipc	ra,0xfffff
    8000514a:	daa080e7          	jalr	-598(ra) # 80003ef0 <pipealloc>
    return -1;
    8000514e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005150:	0c054463          	bltz	a0,80005218 <sys_pipe+0xfc>
  fd0 = -1;
    80005154:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005158:	fd043503          	ld	a0,-48(s0)
    8000515c:	fffff097          	auipc	ra,0xfffff
    80005160:	514080e7          	jalr	1300(ra) # 80004670 <fdalloc>
    80005164:	fca42223          	sw	a0,-60(s0)
    80005168:	08054b63          	bltz	a0,800051fe <sys_pipe+0xe2>
    8000516c:	fc843503          	ld	a0,-56(s0)
    80005170:	fffff097          	auipc	ra,0xfffff
    80005174:	500080e7          	jalr	1280(ra) # 80004670 <fdalloc>
    80005178:	fca42023          	sw	a0,-64(s0)
    8000517c:	06054863          	bltz	a0,800051ec <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005180:	4691                	li	a3,4
    80005182:	fc440613          	addi	a2,s0,-60
    80005186:	fd843583          	ld	a1,-40(s0)
    8000518a:	6ca8                	ld	a0,88(s1)
    8000518c:	ffffc097          	auipc	ra,0xffffc
    80005190:	988080e7          	jalr	-1656(ra) # 80000b14 <copyout>
    80005194:	02054063          	bltz	a0,800051b4 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005198:	4691                	li	a3,4
    8000519a:	fc040613          	addi	a2,s0,-64
    8000519e:	fd843583          	ld	a1,-40(s0)
    800051a2:	0591                	addi	a1,a1,4
    800051a4:	6ca8                	ld	a0,88(s1)
    800051a6:	ffffc097          	auipc	ra,0xffffc
    800051aa:	96e080e7          	jalr	-1682(ra) # 80000b14 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051ae:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051b0:	06055463          	bgez	a0,80005218 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051b4:	fc442783          	lw	a5,-60(s0)
    800051b8:	07e9                	addi	a5,a5,26
    800051ba:	078e                	slli	a5,a5,0x3
    800051bc:	97a6                	add	a5,a5,s1
    800051be:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800051c2:	fc042783          	lw	a5,-64(s0)
    800051c6:	07e9                	addi	a5,a5,26
    800051c8:	078e                	slli	a5,a5,0x3
    800051ca:	94be                	add	s1,s1,a5
    800051cc:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800051d0:	fd043503          	ld	a0,-48(s0)
    800051d4:	fffff097          	auipc	ra,0xfffff
    800051d8:	9ec080e7          	jalr	-1556(ra) # 80003bc0 <fileclose>
    fileclose(wf);
    800051dc:	fc843503          	ld	a0,-56(s0)
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	9e0080e7          	jalr	-1568(ra) # 80003bc0 <fileclose>
    return -1;
    800051e8:	57fd                	li	a5,-1
    800051ea:	a03d                	j	80005218 <sys_pipe+0xfc>
    if(fd0 >= 0)
    800051ec:	fc442783          	lw	a5,-60(s0)
    800051f0:	0007c763          	bltz	a5,800051fe <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    800051f4:	07e9                	addi	a5,a5,26
    800051f6:	078e                	slli	a5,a5,0x3
    800051f8:	97a6                	add	a5,a5,s1
    800051fa:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800051fe:	fd043503          	ld	a0,-48(s0)
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	9be080e7          	jalr	-1602(ra) # 80003bc0 <fileclose>
    fileclose(wf);
    8000520a:	fc843503          	ld	a0,-56(s0)
    8000520e:	fffff097          	auipc	ra,0xfffff
    80005212:	9b2080e7          	jalr	-1614(ra) # 80003bc0 <fileclose>
    return -1;
    80005216:	57fd                	li	a5,-1
}
    80005218:	853e                	mv	a0,a5
    8000521a:	70e2                	ld	ra,56(sp)
    8000521c:	7442                	ld	s0,48(sp)
    8000521e:	74a2                	ld	s1,40(sp)
    80005220:	6121                	addi	sp,sp,64
    80005222:	8082                	ret
	...

0000000080005230 <kernelvec>:
    80005230:	7111                	addi	sp,sp,-256
    80005232:	e006                	sd	ra,0(sp)
    80005234:	e40a                	sd	sp,8(sp)
    80005236:	e80e                	sd	gp,16(sp)
    80005238:	ec12                	sd	tp,24(sp)
    8000523a:	f016                	sd	t0,32(sp)
    8000523c:	f41a                	sd	t1,40(sp)
    8000523e:	f81e                	sd	t2,48(sp)
    80005240:	fc22                	sd	s0,56(sp)
    80005242:	e0a6                	sd	s1,64(sp)
    80005244:	e4aa                	sd	a0,72(sp)
    80005246:	e8ae                	sd	a1,80(sp)
    80005248:	ecb2                	sd	a2,88(sp)
    8000524a:	f0b6                	sd	a3,96(sp)
    8000524c:	f4ba                	sd	a4,104(sp)
    8000524e:	f8be                	sd	a5,112(sp)
    80005250:	fcc2                	sd	a6,120(sp)
    80005252:	e146                	sd	a7,128(sp)
    80005254:	e54a                	sd	s2,136(sp)
    80005256:	e94e                	sd	s3,144(sp)
    80005258:	ed52                	sd	s4,152(sp)
    8000525a:	f156                	sd	s5,160(sp)
    8000525c:	f55a                	sd	s6,168(sp)
    8000525e:	f95e                	sd	s7,176(sp)
    80005260:	fd62                	sd	s8,184(sp)
    80005262:	e1e6                	sd	s9,192(sp)
    80005264:	e5ea                	sd	s10,200(sp)
    80005266:	e9ee                	sd	s11,208(sp)
    80005268:	edf2                	sd	t3,216(sp)
    8000526a:	f1f6                	sd	t4,224(sp)
    8000526c:	f5fa                	sd	t5,232(sp)
    8000526e:	f9fe                	sd	t6,240(sp)
    80005270:	c91fc0ef          	jal	ra,80001f00 <kerneltrap>
    80005274:	6082                	ld	ra,0(sp)
    80005276:	6122                	ld	sp,8(sp)
    80005278:	61c2                	ld	gp,16(sp)
    8000527a:	7282                	ld	t0,32(sp)
    8000527c:	7322                	ld	t1,40(sp)
    8000527e:	73c2                	ld	t2,48(sp)
    80005280:	7462                	ld	s0,56(sp)
    80005282:	6486                	ld	s1,64(sp)
    80005284:	6526                	ld	a0,72(sp)
    80005286:	65c6                	ld	a1,80(sp)
    80005288:	6666                	ld	a2,88(sp)
    8000528a:	7686                	ld	a3,96(sp)
    8000528c:	7726                	ld	a4,104(sp)
    8000528e:	77c6                	ld	a5,112(sp)
    80005290:	7866                	ld	a6,120(sp)
    80005292:	688a                	ld	a7,128(sp)
    80005294:	692a                	ld	s2,136(sp)
    80005296:	69ca                	ld	s3,144(sp)
    80005298:	6a6a                	ld	s4,152(sp)
    8000529a:	7a8a                	ld	s5,160(sp)
    8000529c:	7b2a                	ld	s6,168(sp)
    8000529e:	7bca                	ld	s7,176(sp)
    800052a0:	7c6a                	ld	s8,184(sp)
    800052a2:	6c8e                	ld	s9,192(sp)
    800052a4:	6d2e                	ld	s10,200(sp)
    800052a6:	6dce                	ld	s11,208(sp)
    800052a8:	6e6e                	ld	t3,216(sp)
    800052aa:	7e8e                	ld	t4,224(sp)
    800052ac:	7f2e                	ld	t5,232(sp)
    800052ae:	7fce                	ld	t6,240(sp)
    800052b0:	6111                	addi	sp,sp,256
    800052b2:	10200073          	sret
    800052b6:	00000013          	nop
    800052ba:	00000013          	nop
    800052be:	0001                	nop

00000000800052c0 <timervec>:
    800052c0:	34051573          	csrrw	a0,mscratch,a0
    800052c4:	e10c                	sd	a1,0(a0)
    800052c6:	e510                	sd	a2,8(a0)
    800052c8:	e914                	sd	a3,16(a0)
    800052ca:	6d0c                	ld	a1,24(a0)
    800052cc:	7110                	ld	a2,32(a0)
    800052ce:	6194                	ld	a3,0(a1)
    800052d0:	96b2                	add	a3,a3,a2
    800052d2:	e194                	sd	a3,0(a1)
    800052d4:	4589                	li	a1,2
    800052d6:	14459073          	csrw	sip,a1
    800052da:	6914                	ld	a3,16(a0)
    800052dc:	6510                	ld	a2,8(a0)
    800052de:	610c                	ld	a1,0(a0)
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	30200073          	mret
	...

00000000800052ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800052ea:	1141                	addi	sp,sp,-16
    800052ec:	e422                	sd	s0,8(sp)
    800052ee:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800052f0:	0c0007b7          	lui	a5,0xc000
    800052f4:	4705                	li	a4,1
    800052f6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800052f8:	c3d8                	sw	a4,4(a5)
}
    800052fa:	6422                	ld	s0,8(sp)
    800052fc:	0141                	addi	sp,sp,16
    800052fe:	8082                	ret

0000000080005300 <plicinithart>:

void
plicinithart(void)
{
    80005300:	1141                	addi	sp,sp,-16
    80005302:	e406                	sd	ra,8(sp)
    80005304:	e022                	sd	s0,0(sp)
    80005306:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005308:	ffffc097          	auipc	ra,0xffffc
    8000530c:	c0a080e7          	jalr	-1014(ra) # 80000f12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005310:	0085171b          	slliw	a4,a0,0x8
    80005314:	0c0027b7          	lui	a5,0xc002
    80005318:	97ba                	add	a5,a5,a4
    8000531a:	40200713          	li	a4,1026
    8000531e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005322:	00d5151b          	slliw	a0,a0,0xd
    80005326:	0c2017b7          	lui	a5,0xc201
    8000532a:	97aa                	add	a5,a5,a0
    8000532c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005330:	60a2                	ld	ra,8(sp)
    80005332:	6402                	ld	s0,0(sp)
    80005334:	0141                	addi	sp,sp,16
    80005336:	8082                	ret

0000000080005338 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005338:	1141                	addi	sp,sp,-16
    8000533a:	e406                	sd	ra,8(sp)
    8000533c:	e022                	sd	s0,0(sp)
    8000533e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005340:	ffffc097          	auipc	ra,0xffffc
    80005344:	bd2080e7          	jalr	-1070(ra) # 80000f12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005348:	00d5151b          	slliw	a0,a0,0xd
    8000534c:	0c2017b7          	lui	a5,0xc201
    80005350:	97aa                	add	a5,a5,a0
  return irq;
}
    80005352:	43c8                	lw	a0,4(a5)
    80005354:	60a2                	ld	ra,8(sp)
    80005356:	6402                	ld	s0,0(sp)
    80005358:	0141                	addi	sp,sp,16
    8000535a:	8082                	ret

000000008000535c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000535c:	1101                	addi	sp,sp,-32
    8000535e:	ec06                	sd	ra,24(sp)
    80005360:	e822                	sd	s0,16(sp)
    80005362:	e426                	sd	s1,8(sp)
    80005364:	1000                	addi	s0,sp,32
    80005366:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005368:	ffffc097          	auipc	ra,0xffffc
    8000536c:	baa080e7          	jalr	-1110(ra) # 80000f12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005370:	00d5151b          	slliw	a0,a0,0xd
    80005374:	0c2017b7          	lui	a5,0xc201
    80005378:	97aa                	add	a5,a5,a0
    8000537a:	c3c4                	sw	s1,4(a5)
}
    8000537c:	60e2                	ld	ra,24(sp)
    8000537e:	6442                	ld	s0,16(sp)
    80005380:	64a2                	ld	s1,8(sp)
    80005382:	6105                	addi	sp,sp,32
    80005384:	8082                	ret

0000000080005386 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005386:	1141                	addi	sp,sp,-16
    80005388:	e406                	sd	ra,8(sp)
    8000538a:	e022                	sd	s0,0(sp)
    8000538c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000538e:	479d                	li	a5,7
    80005390:	04a7cc63          	blt	a5,a0,800053e8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005394:	00015797          	auipc	a5,0x15
    80005398:	8fc78793          	addi	a5,a5,-1796 # 80019c90 <disk>
    8000539c:	97aa                	add	a5,a5,a0
    8000539e:	0187c783          	lbu	a5,24(a5)
    800053a2:	ebb9                	bnez	a5,800053f8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053a4:	00451693          	slli	a3,a0,0x4
    800053a8:	00015797          	auipc	a5,0x15
    800053ac:	8e878793          	addi	a5,a5,-1816 # 80019c90 <disk>
    800053b0:	6398                	ld	a4,0(a5)
    800053b2:	9736                	add	a4,a4,a3
    800053b4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800053b8:	6398                	ld	a4,0(a5)
    800053ba:	9736                	add	a4,a4,a3
    800053bc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053c0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053c4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053c8:	97aa                	add	a5,a5,a0
    800053ca:	4705                	li	a4,1
    800053cc:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800053d0:	00015517          	auipc	a0,0x15
    800053d4:	8d850513          	addi	a0,a0,-1832 # 80019ca8 <disk+0x18>
    800053d8:	ffffc097          	auipc	ra,0xffffc
    800053dc:	2f0080e7          	jalr	752(ra) # 800016c8 <wakeup>
}
    800053e0:	60a2                	ld	ra,8(sp)
    800053e2:	6402                	ld	s0,0(sp)
    800053e4:	0141                	addi	sp,sp,16
    800053e6:	8082                	ret
    panic("free_desc 1");
    800053e8:	00003517          	auipc	a0,0x3
    800053ec:	38050513          	addi	a0,a0,896 # 80008768 <syscalls+0x368>
    800053f0:	00001097          	auipc	ra,0x1
    800053f4:	a0c080e7          	jalr	-1524(ra) # 80005dfc <panic>
    panic("free_desc 2");
    800053f8:	00003517          	auipc	a0,0x3
    800053fc:	38050513          	addi	a0,a0,896 # 80008778 <syscalls+0x378>
    80005400:	00001097          	auipc	ra,0x1
    80005404:	9fc080e7          	jalr	-1540(ra) # 80005dfc <panic>

0000000080005408 <virtio_disk_init>:
{
    80005408:	1101                	addi	sp,sp,-32
    8000540a:	ec06                	sd	ra,24(sp)
    8000540c:	e822                	sd	s0,16(sp)
    8000540e:	e426                	sd	s1,8(sp)
    80005410:	e04a                	sd	s2,0(sp)
    80005412:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005414:	00003597          	auipc	a1,0x3
    80005418:	37458593          	addi	a1,a1,884 # 80008788 <syscalls+0x388>
    8000541c:	00015517          	auipc	a0,0x15
    80005420:	99c50513          	addi	a0,a0,-1636 # 80019db8 <disk+0x128>
    80005424:	00001097          	auipc	ra,0x1
    80005428:	e80080e7          	jalr	-384(ra) # 800062a4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000542c:	100017b7          	lui	a5,0x10001
    80005430:	4398                	lw	a4,0(a5)
    80005432:	2701                	sext.w	a4,a4
    80005434:	747277b7          	lui	a5,0x74727
    80005438:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000543c:	14f71b63          	bne	a4,a5,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005440:	100017b7          	lui	a5,0x10001
    80005444:	43dc                	lw	a5,4(a5)
    80005446:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005448:	4709                	li	a4,2
    8000544a:	14e79463          	bne	a5,a4,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000544e:	100017b7          	lui	a5,0x10001
    80005452:	479c                	lw	a5,8(a5)
    80005454:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005456:	12e79e63          	bne	a5,a4,80005592 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000545a:	100017b7          	lui	a5,0x10001
    8000545e:	47d8                	lw	a4,12(a5)
    80005460:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005462:	554d47b7          	lui	a5,0x554d4
    80005466:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000546a:	12f71463          	bne	a4,a5,80005592 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000546e:	100017b7          	lui	a5,0x10001
    80005472:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005476:	4705                	li	a4,1
    80005478:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000547a:	470d                	li	a4,3
    8000547c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000547e:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005480:	c7ffe6b7          	lui	a3,0xc7ffe
    80005484:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc74f>
    80005488:	8f75                	and	a4,a4,a3
    8000548a:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548c:	472d                	li	a4,11
    8000548e:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005490:	5bbc                	lw	a5,112(a5)
    80005492:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005496:	8ba1                	andi	a5,a5,8
    80005498:	10078563          	beqz	a5,800055a2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000549c:	100017b7          	lui	a5,0x10001
    800054a0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054a4:	43fc                	lw	a5,68(a5)
    800054a6:	2781                	sext.w	a5,a5
    800054a8:	10079563          	bnez	a5,800055b2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054ac:	100017b7          	lui	a5,0x10001
    800054b0:	5bdc                	lw	a5,52(a5)
    800054b2:	2781                	sext.w	a5,a5
  if(max == 0)
    800054b4:	10078763          	beqz	a5,800055c2 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800054b8:	471d                	li	a4,7
    800054ba:	10f77c63          	bgeu	a4,a5,800055d2 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800054be:	ffffb097          	auipc	ra,0xffffb
    800054c2:	c5c080e7          	jalr	-932(ra) # 8000011a <kalloc>
    800054c6:	00014497          	auipc	s1,0x14
    800054ca:	7ca48493          	addi	s1,s1,1994 # 80019c90 <disk>
    800054ce:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054d0:	ffffb097          	auipc	ra,0xffffb
    800054d4:	c4a080e7          	jalr	-950(ra) # 8000011a <kalloc>
    800054d8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054da:	ffffb097          	auipc	ra,0xffffb
    800054de:	c40080e7          	jalr	-960(ra) # 8000011a <kalloc>
    800054e2:	87aa                	mv	a5,a0
    800054e4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800054e6:	6088                	ld	a0,0(s1)
    800054e8:	cd6d                	beqz	a0,800055e2 <virtio_disk_init+0x1da>
    800054ea:	00014717          	auipc	a4,0x14
    800054ee:	7ae73703          	ld	a4,1966(a4) # 80019c98 <disk+0x8>
    800054f2:	cb65                	beqz	a4,800055e2 <virtio_disk_init+0x1da>
    800054f4:	c7fd                	beqz	a5,800055e2 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    800054f6:	6605                	lui	a2,0x1
    800054f8:	4581                	li	a1,0
    800054fa:	ffffb097          	auipc	ra,0xffffb
    800054fe:	c80080e7          	jalr	-896(ra) # 8000017a <memset>
  memset(disk.avail, 0, PGSIZE);
    80005502:	00014497          	auipc	s1,0x14
    80005506:	78e48493          	addi	s1,s1,1934 # 80019c90 <disk>
    8000550a:	6605                	lui	a2,0x1
    8000550c:	4581                	li	a1,0
    8000550e:	6488                	ld	a0,8(s1)
    80005510:	ffffb097          	auipc	ra,0xffffb
    80005514:	c6a080e7          	jalr	-918(ra) # 8000017a <memset>
  memset(disk.used, 0, PGSIZE);
    80005518:	6605                	lui	a2,0x1
    8000551a:	4581                	li	a1,0
    8000551c:	6888                	ld	a0,16(s1)
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	c5c080e7          	jalr	-932(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005526:	100017b7          	lui	a5,0x10001
    8000552a:	4721                	li	a4,8
    8000552c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000552e:	4098                	lw	a4,0(s1)
    80005530:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005534:	40d8                	lw	a4,4(s1)
    80005536:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000553a:	6498                	ld	a4,8(s1)
    8000553c:	0007069b          	sext.w	a3,a4
    80005540:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005544:	9701                	srai	a4,a4,0x20
    80005546:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000554a:	6898                	ld	a4,16(s1)
    8000554c:	0007069b          	sext.w	a3,a4
    80005550:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005554:	9701                	srai	a4,a4,0x20
    80005556:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000555a:	4705                	li	a4,1
    8000555c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000555e:	00e48c23          	sb	a4,24(s1)
    80005562:	00e48ca3          	sb	a4,25(s1)
    80005566:	00e48d23          	sb	a4,26(s1)
    8000556a:	00e48da3          	sb	a4,27(s1)
    8000556e:	00e48e23          	sb	a4,28(s1)
    80005572:	00e48ea3          	sb	a4,29(s1)
    80005576:	00e48f23          	sb	a4,30(s1)
    8000557a:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    8000557e:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005582:	0727a823          	sw	s2,112(a5)
}
    80005586:	60e2                	ld	ra,24(sp)
    80005588:	6442                	ld	s0,16(sp)
    8000558a:	64a2                	ld	s1,8(sp)
    8000558c:	6902                	ld	s2,0(sp)
    8000558e:	6105                	addi	sp,sp,32
    80005590:	8082                	ret
    panic("could not find virtio disk");
    80005592:	00003517          	auipc	a0,0x3
    80005596:	20650513          	addi	a0,a0,518 # 80008798 <syscalls+0x398>
    8000559a:	00001097          	auipc	ra,0x1
    8000559e:	862080e7          	jalr	-1950(ra) # 80005dfc <panic>
    panic("virtio disk FEATURES_OK unset");
    800055a2:	00003517          	auipc	a0,0x3
    800055a6:	21650513          	addi	a0,a0,534 # 800087b8 <syscalls+0x3b8>
    800055aa:	00001097          	auipc	ra,0x1
    800055ae:	852080e7          	jalr	-1966(ra) # 80005dfc <panic>
    panic("virtio disk should not be ready");
    800055b2:	00003517          	auipc	a0,0x3
    800055b6:	22650513          	addi	a0,a0,550 # 800087d8 <syscalls+0x3d8>
    800055ba:	00001097          	auipc	ra,0x1
    800055be:	842080e7          	jalr	-1982(ra) # 80005dfc <panic>
    panic("virtio disk has no queue 0");
    800055c2:	00003517          	auipc	a0,0x3
    800055c6:	23650513          	addi	a0,a0,566 # 800087f8 <syscalls+0x3f8>
    800055ca:	00001097          	auipc	ra,0x1
    800055ce:	832080e7          	jalr	-1998(ra) # 80005dfc <panic>
    panic("virtio disk max queue too short");
    800055d2:	00003517          	auipc	a0,0x3
    800055d6:	24650513          	addi	a0,a0,582 # 80008818 <syscalls+0x418>
    800055da:	00001097          	auipc	ra,0x1
    800055de:	822080e7          	jalr	-2014(ra) # 80005dfc <panic>
    panic("virtio disk kalloc");
    800055e2:	00003517          	auipc	a0,0x3
    800055e6:	25650513          	addi	a0,a0,598 # 80008838 <syscalls+0x438>
    800055ea:	00001097          	auipc	ra,0x1
    800055ee:	812080e7          	jalr	-2030(ra) # 80005dfc <panic>

00000000800055f2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800055f2:	7119                	addi	sp,sp,-128
    800055f4:	fc86                	sd	ra,120(sp)
    800055f6:	f8a2                	sd	s0,112(sp)
    800055f8:	f4a6                	sd	s1,104(sp)
    800055fa:	f0ca                	sd	s2,96(sp)
    800055fc:	ecce                	sd	s3,88(sp)
    800055fe:	e8d2                	sd	s4,80(sp)
    80005600:	e4d6                	sd	s5,72(sp)
    80005602:	e0da                	sd	s6,64(sp)
    80005604:	fc5e                	sd	s7,56(sp)
    80005606:	f862                	sd	s8,48(sp)
    80005608:	f466                	sd	s9,40(sp)
    8000560a:	f06a                	sd	s10,32(sp)
    8000560c:	ec6e                	sd	s11,24(sp)
    8000560e:	0100                	addi	s0,sp,128
    80005610:	8aaa                	mv	s5,a0
    80005612:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005614:	00c52d03          	lw	s10,12(a0)
    80005618:	001d1d1b          	slliw	s10,s10,0x1
    8000561c:	1d02                	slli	s10,s10,0x20
    8000561e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005622:	00014517          	auipc	a0,0x14
    80005626:	79650513          	addi	a0,a0,1942 # 80019db8 <disk+0x128>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	d0a080e7          	jalr	-758(ra) # 80006334 <acquire>
  for(int i = 0; i < 3; i++){
    80005632:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005634:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005636:	00014b97          	auipc	s7,0x14
    8000563a:	65ab8b93          	addi	s7,s7,1626 # 80019c90 <disk>
  for(int i = 0; i < 3; i++){
    8000563e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005640:	00014c97          	auipc	s9,0x14
    80005644:	778c8c93          	addi	s9,s9,1912 # 80019db8 <disk+0x128>
    80005648:	a08d                	j	800056aa <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000564a:	00fb8733          	add	a4,s7,a5
    8000564e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005652:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005654:	0207c563          	bltz	a5,8000567e <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005658:	2905                	addiw	s2,s2,1
    8000565a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000565c:	05690c63          	beq	s2,s6,800056b4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    80005660:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005662:	00014717          	auipc	a4,0x14
    80005666:	62e70713          	addi	a4,a4,1582 # 80019c90 <disk>
    8000566a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000566c:	01874683          	lbu	a3,24(a4)
    80005670:	fee9                	bnez	a3,8000564a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005672:	2785                	addiw	a5,a5,1
    80005674:	0705                	addi	a4,a4,1
    80005676:	fe979be3          	bne	a5,s1,8000566c <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    8000567a:	57fd                	li	a5,-1
    8000567c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000567e:	01205d63          	blez	s2,80005698 <virtio_disk_rw+0xa6>
    80005682:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005684:	000a2503          	lw	a0,0(s4)
    80005688:	00000097          	auipc	ra,0x0
    8000568c:	cfe080e7          	jalr	-770(ra) # 80005386 <free_desc>
      for(int j = 0; j < i; j++)
    80005690:	2d85                	addiw	s11,s11,1
    80005692:	0a11                	addi	s4,s4,4
    80005694:	ff2d98e3          	bne	s11,s2,80005684 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005698:	85e6                	mv	a1,s9
    8000569a:	00014517          	auipc	a0,0x14
    8000569e:	60e50513          	addi	a0,a0,1550 # 80019ca8 <disk+0x18>
    800056a2:	ffffc097          	auipc	ra,0xffffc
    800056a6:	fc2080e7          	jalr	-62(ra) # 80001664 <sleep>
  for(int i = 0; i < 3; i++){
    800056aa:	f8040a13          	addi	s4,s0,-128
{
    800056ae:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800056b0:	894e                	mv	s2,s3
    800056b2:	b77d                	j	80005660 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056b4:	f8042503          	lw	a0,-128(s0)
    800056b8:	00a50713          	addi	a4,a0,10
    800056bc:	0712                	slli	a4,a4,0x4

  if(write)
    800056be:	00014797          	auipc	a5,0x14
    800056c2:	5d278793          	addi	a5,a5,1490 # 80019c90 <disk>
    800056c6:	00e786b3          	add	a3,a5,a4
    800056ca:	01803633          	snez	a2,s8
    800056ce:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800056d0:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    800056d4:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800056d8:	f6070613          	addi	a2,a4,-160
    800056dc:	6394                	ld	a3,0(a5)
    800056de:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e0:	00870593          	addi	a1,a4,8
    800056e4:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800056e6:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800056e8:	0007b803          	ld	a6,0(a5)
    800056ec:	9642                	add	a2,a2,a6
    800056ee:	46c1                	li	a3,16
    800056f0:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800056f2:	4585                	li	a1,1
    800056f4:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    800056f8:	f8442683          	lw	a3,-124(s0)
    800056fc:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005700:	0692                	slli	a3,a3,0x4
    80005702:	9836                	add	a6,a6,a3
    80005704:	058a8613          	addi	a2,s5,88
    80005708:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000570c:	0007b803          	ld	a6,0(a5)
    80005710:	96c2                	add	a3,a3,a6
    80005712:	40000613          	li	a2,1024
    80005716:	c690                	sw	a2,8(a3)
  if(write)
    80005718:	001c3613          	seqz	a2,s8
    8000571c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005720:	00166613          	ori	a2,a2,1
    80005724:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005728:	f8842603          	lw	a2,-120(s0)
    8000572c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005730:	00250693          	addi	a3,a0,2
    80005734:	0692                	slli	a3,a3,0x4
    80005736:	96be                	add	a3,a3,a5
    80005738:	58fd                	li	a7,-1
    8000573a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000573e:	0612                	slli	a2,a2,0x4
    80005740:	9832                	add	a6,a6,a2
    80005742:	f9070713          	addi	a4,a4,-112
    80005746:	973e                	add	a4,a4,a5
    80005748:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000574c:	6398                	ld	a4,0(a5)
    8000574e:	9732                	add	a4,a4,a2
    80005750:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005752:	4609                	li	a2,2
    80005754:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005758:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000575c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    80005760:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005764:	6794                	ld	a3,8(a5)
    80005766:	0026d703          	lhu	a4,2(a3)
    8000576a:	8b1d                	andi	a4,a4,7
    8000576c:	0706                	slli	a4,a4,0x1
    8000576e:	96ba                	add	a3,a3,a4
    80005770:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005774:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005778:	6798                	ld	a4,8(a5)
    8000577a:	00275783          	lhu	a5,2(a4)
    8000577e:	2785                	addiw	a5,a5,1
    80005780:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005784:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005788:	100017b7          	lui	a5,0x10001
    8000578c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005790:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    80005794:	00014917          	auipc	s2,0x14
    80005798:	62490913          	addi	s2,s2,1572 # 80019db8 <disk+0x128>
  while(b->disk == 1) {
    8000579c:	4485                	li	s1,1
    8000579e:	00b79c63          	bne	a5,a1,800057b6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800057a2:	85ca                	mv	a1,s2
    800057a4:	8556                	mv	a0,s5
    800057a6:	ffffc097          	auipc	ra,0xffffc
    800057aa:	ebe080e7          	jalr	-322(ra) # 80001664 <sleep>
  while(b->disk == 1) {
    800057ae:	004aa783          	lw	a5,4(s5)
    800057b2:	fe9788e3          	beq	a5,s1,800057a2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800057b6:	f8042903          	lw	s2,-128(s0)
    800057ba:	00290713          	addi	a4,s2,2
    800057be:	0712                	slli	a4,a4,0x4
    800057c0:	00014797          	auipc	a5,0x14
    800057c4:	4d078793          	addi	a5,a5,1232 # 80019c90 <disk>
    800057c8:	97ba                	add	a5,a5,a4
    800057ca:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800057ce:	00014997          	auipc	s3,0x14
    800057d2:	4c298993          	addi	s3,s3,1218 # 80019c90 <disk>
    800057d6:	00491713          	slli	a4,s2,0x4
    800057da:	0009b783          	ld	a5,0(s3)
    800057de:	97ba                	add	a5,a5,a4
    800057e0:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800057e4:	854a                	mv	a0,s2
    800057e6:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800057ea:	00000097          	auipc	ra,0x0
    800057ee:	b9c080e7          	jalr	-1124(ra) # 80005386 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800057f2:	8885                	andi	s1,s1,1
    800057f4:	f0ed                	bnez	s1,800057d6 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800057f6:	00014517          	auipc	a0,0x14
    800057fa:	5c250513          	addi	a0,a0,1474 # 80019db8 <disk+0x128>
    800057fe:	00001097          	auipc	ra,0x1
    80005802:	bea080e7          	jalr	-1046(ra) # 800063e8 <release>
}
    80005806:	70e6                	ld	ra,120(sp)
    80005808:	7446                	ld	s0,112(sp)
    8000580a:	74a6                	ld	s1,104(sp)
    8000580c:	7906                	ld	s2,96(sp)
    8000580e:	69e6                	ld	s3,88(sp)
    80005810:	6a46                	ld	s4,80(sp)
    80005812:	6aa6                	ld	s5,72(sp)
    80005814:	6b06                	ld	s6,64(sp)
    80005816:	7be2                	ld	s7,56(sp)
    80005818:	7c42                	ld	s8,48(sp)
    8000581a:	7ca2                	ld	s9,40(sp)
    8000581c:	7d02                	ld	s10,32(sp)
    8000581e:	6de2                	ld	s11,24(sp)
    80005820:	6109                	addi	sp,sp,128
    80005822:	8082                	ret

0000000080005824 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005824:	1101                	addi	sp,sp,-32
    80005826:	ec06                	sd	ra,24(sp)
    80005828:	e822                	sd	s0,16(sp)
    8000582a:	e426                	sd	s1,8(sp)
    8000582c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000582e:	00014497          	auipc	s1,0x14
    80005832:	46248493          	addi	s1,s1,1122 # 80019c90 <disk>
    80005836:	00014517          	auipc	a0,0x14
    8000583a:	58250513          	addi	a0,a0,1410 # 80019db8 <disk+0x128>
    8000583e:	00001097          	auipc	ra,0x1
    80005842:	af6080e7          	jalr	-1290(ra) # 80006334 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005846:	10001737          	lui	a4,0x10001
    8000584a:	533c                	lw	a5,96(a4)
    8000584c:	8b8d                	andi	a5,a5,3
    8000584e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005850:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005854:	689c                	ld	a5,16(s1)
    80005856:	0204d703          	lhu	a4,32(s1)
    8000585a:	0027d783          	lhu	a5,2(a5)
    8000585e:	04f70863          	beq	a4,a5,800058ae <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005862:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005866:	6898                	ld	a4,16(s1)
    80005868:	0204d783          	lhu	a5,32(s1)
    8000586c:	8b9d                	andi	a5,a5,7
    8000586e:	078e                	slli	a5,a5,0x3
    80005870:	97ba                	add	a5,a5,a4
    80005872:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005874:	00278713          	addi	a4,a5,2
    80005878:	0712                	slli	a4,a4,0x4
    8000587a:	9726                	add	a4,a4,s1
    8000587c:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005880:	e721                	bnez	a4,800058c8 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005882:	0789                	addi	a5,a5,2
    80005884:	0792                	slli	a5,a5,0x4
    80005886:	97a6                	add	a5,a5,s1
    80005888:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000588a:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000588e:	ffffc097          	auipc	ra,0xffffc
    80005892:	e3a080e7          	jalr	-454(ra) # 800016c8 <wakeup>

    disk.used_idx += 1;
    80005896:	0204d783          	lhu	a5,32(s1)
    8000589a:	2785                	addiw	a5,a5,1
    8000589c:	17c2                	slli	a5,a5,0x30
    8000589e:	93c1                	srli	a5,a5,0x30
    800058a0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800058a4:	6898                	ld	a4,16(s1)
    800058a6:	00275703          	lhu	a4,2(a4)
    800058aa:	faf71ce3          	bne	a4,a5,80005862 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800058ae:	00014517          	auipc	a0,0x14
    800058b2:	50a50513          	addi	a0,a0,1290 # 80019db8 <disk+0x128>
    800058b6:	00001097          	auipc	ra,0x1
    800058ba:	b32080e7          	jalr	-1230(ra) # 800063e8 <release>
}
    800058be:	60e2                	ld	ra,24(sp)
    800058c0:	6442                	ld	s0,16(sp)
    800058c2:	64a2                	ld	s1,8(sp)
    800058c4:	6105                	addi	sp,sp,32
    800058c6:	8082                	ret
      panic("virtio_disk_intr status");
    800058c8:	00003517          	auipc	a0,0x3
    800058cc:	f8850513          	addi	a0,a0,-120 # 80008850 <syscalls+0x450>
    800058d0:	00000097          	auipc	ra,0x0
    800058d4:	52c080e7          	jalr	1324(ra) # 80005dfc <panic>

00000000800058d8 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800058d8:	1141                	addi	sp,sp,-16
    800058da:	e422                	sd	s0,8(sp)
    800058dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058de:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800058e2:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800058e6:	0037979b          	slliw	a5,a5,0x3
    800058ea:	02004737          	lui	a4,0x2004
    800058ee:	97ba                	add	a5,a5,a4
    800058f0:	0200c737          	lui	a4,0x200c
    800058f4:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800058f8:	000f4637          	lui	a2,0xf4
    800058fc:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005900:	9732                	add	a4,a4,a2
    80005902:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005904:	00259693          	slli	a3,a1,0x2
    80005908:	96ae                	add	a3,a3,a1
    8000590a:	068e                	slli	a3,a3,0x3
    8000590c:	00014717          	auipc	a4,0x14
    80005910:	4c470713          	addi	a4,a4,1220 # 80019dd0 <timer_scratch>
    80005914:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005916:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005918:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000591a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000591e:	00000797          	auipc	a5,0x0
    80005922:	9a278793          	addi	a5,a5,-1630 # 800052c0 <timervec>
    80005926:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000592a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000592e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005932:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005936:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000593a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000593e:	30479073          	csrw	mie,a5
}
    80005942:	6422                	ld	s0,8(sp)
    80005944:	0141                	addi	sp,sp,16
    80005946:	8082                	ret

0000000080005948 <start>:
{
    80005948:	1141                	addi	sp,sp,-16
    8000594a:	e406                	sd	ra,8(sp)
    8000594c:	e022                	sd	s0,0(sp)
    8000594e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005950:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005954:	7779                	lui	a4,0xffffe
    80005956:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7ef>
    8000595a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000595c:	6705                	lui	a4,0x1
    8000595e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005962:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005964:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005968:	ffffb797          	auipc	a5,0xffffb
    8000596c:	9b878793          	addi	a5,a5,-1608 # 80000320 <main>
    80005970:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005974:	4781                	li	a5,0
    80005976:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000597a:	67c1                	lui	a5,0x10
    8000597c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000597e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005982:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005986:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000598a:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    8000598e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005992:	57fd                	li	a5,-1
    80005994:	83a9                	srli	a5,a5,0xa
    80005996:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000599a:	47bd                	li	a5,15
    8000599c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	f38080e7          	jalr	-200(ra) # 800058d8 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059a8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800059ac:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800059ae:	823e                	mv	tp,a5
  asm volatile("mret");
    800059b0:	30200073          	mret
}
    800059b4:	60a2                	ld	ra,8(sp)
    800059b6:	6402                	ld	s0,0(sp)
    800059b8:	0141                	addi	sp,sp,16
    800059ba:	8082                	ret

00000000800059bc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800059bc:	715d                	addi	sp,sp,-80
    800059be:	e486                	sd	ra,72(sp)
    800059c0:	e0a2                	sd	s0,64(sp)
    800059c2:	fc26                	sd	s1,56(sp)
    800059c4:	f84a                	sd	s2,48(sp)
    800059c6:	f44e                	sd	s3,40(sp)
    800059c8:	f052                	sd	s4,32(sp)
    800059ca:	ec56                	sd	s5,24(sp)
    800059cc:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800059ce:	04c05763          	blez	a2,80005a1c <consolewrite+0x60>
    800059d2:	8a2a                	mv	s4,a0
    800059d4:	84ae                	mv	s1,a1
    800059d6:	89b2                	mv	s3,a2
    800059d8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800059da:	5afd                	li	s5,-1
    800059dc:	4685                	li	a3,1
    800059de:	8626                	mv	a2,s1
    800059e0:	85d2                	mv	a1,s4
    800059e2:	fbf40513          	addi	a0,s0,-65
    800059e6:	ffffc097          	auipc	ra,0xffffc
    800059ea:	0dc080e7          	jalr	220(ra) # 80001ac2 <either_copyin>
    800059ee:	01550d63          	beq	a0,s5,80005a08 <consolewrite+0x4c>
      break;
    uartputc(c);
    800059f2:	fbf44503          	lbu	a0,-65(s0)
    800059f6:	00000097          	auipc	ra,0x0
    800059fa:	784080e7          	jalr	1924(ra) # 8000617a <uartputc>
  for(i = 0; i < n; i++){
    800059fe:	2905                	addiw	s2,s2,1
    80005a00:	0485                	addi	s1,s1,1
    80005a02:	fd299de3          	bne	s3,s2,800059dc <consolewrite+0x20>
    80005a06:	894e                	mv	s2,s3
  }

  return i;
}
    80005a08:	854a                	mv	a0,s2
    80005a0a:	60a6                	ld	ra,72(sp)
    80005a0c:	6406                	ld	s0,64(sp)
    80005a0e:	74e2                	ld	s1,56(sp)
    80005a10:	7942                	ld	s2,48(sp)
    80005a12:	79a2                	ld	s3,40(sp)
    80005a14:	7a02                	ld	s4,32(sp)
    80005a16:	6ae2                	ld	s5,24(sp)
    80005a18:	6161                	addi	sp,sp,80
    80005a1a:	8082                	ret
  for(i = 0; i < n; i++){
    80005a1c:	4901                	li	s2,0
    80005a1e:	b7ed                	j	80005a08 <consolewrite+0x4c>

0000000080005a20 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005a20:	7159                	addi	sp,sp,-112
    80005a22:	f486                	sd	ra,104(sp)
    80005a24:	f0a2                	sd	s0,96(sp)
    80005a26:	eca6                	sd	s1,88(sp)
    80005a28:	e8ca                	sd	s2,80(sp)
    80005a2a:	e4ce                	sd	s3,72(sp)
    80005a2c:	e0d2                	sd	s4,64(sp)
    80005a2e:	fc56                	sd	s5,56(sp)
    80005a30:	f85a                	sd	s6,48(sp)
    80005a32:	f45e                	sd	s7,40(sp)
    80005a34:	f062                	sd	s8,32(sp)
    80005a36:	ec66                	sd	s9,24(sp)
    80005a38:	e86a                	sd	s10,16(sp)
    80005a3a:	1880                	addi	s0,sp,112
    80005a3c:	8aaa                	mv	s5,a0
    80005a3e:	8a2e                	mv	s4,a1
    80005a40:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005a42:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005a46:	0001c517          	auipc	a0,0x1c
    80005a4a:	4ca50513          	addi	a0,a0,1226 # 80021f10 <cons>
    80005a4e:	00001097          	auipc	ra,0x1
    80005a52:	8e6080e7          	jalr	-1818(ra) # 80006334 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005a56:	0001c497          	auipc	s1,0x1c
    80005a5a:	4ba48493          	addi	s1,s1,1210 # 80021f10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005a5e:	0001c917          	auipc	s2,0x1c
    80005a62:	54a90913          	addi	s2,s2,1354 # 80021fa8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005a66:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a68:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005a6a:	4ca9                	li	s9,10
  while(n > 0){
    80005a6c:	07305b63          	blez	s3,80005ae2 <consoleread+0xc2>
    while(cons.r == cons.w){
    80005a70:	0984a783          	lw	a5,152(s1)
    80005a74:	09c4a703          	lw	a4,156(s1)
    80005a78:	02f71763          	bne	a4,a5,80005aa6 <consoleread+0x86>
      if(killed(myproc())){
    80005a7c:	ffffb097          	auipc	ra,0xffffb
    80005a80:	4c2080e7          	jalr	1218(ra) # 80000f3e <myproc>
    80005a84:	ffffc097          	auipc	ra,0xffffc
    80005a88:	e88080e7          	jalr	-376(ra) # 8000190c <killed>
    80005a8c:	e535                	bnez	a0,80005af8 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    80005a8e:	85a6                	mv	a1,s1
    80005a90:	854a                	mv	a0,s2
    80005a92:	ffffc097          	auipc	ra,0xffffc
    80005a96:	bd2080e7          	jalr	-1070(ra) # 80001664 <sleep>
    while(cons.r == cons.w){
    80005a9a:	0984a783          	lw	a5,152(s1)
    80005a9e:	09c4a703          	lw	a4,156(s1)
    80005aa2:	fcf70de3          	beq	a4,a5,80005a7c <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005aa6:	0017871b          	addiw	a4,a5,1
    80005aaa:	08e4ac23          	sw	a4,152(s1)
    80005aae:	07f7f713          	andi	a4,a5,127
    80005ab2:	9726                	add	a4,a4,s1
    80005ab4:	01874703          	lbu	a4,24(a4)
    80005ab8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005abc:	077d0563          	beq	s10,s7,80005b26 <consoleread+0x106>
    cbuf = c;
    80005ac0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005ac4:	4685                	li	a3,1
    80005ac6:	f9f40613          	addi	a2,s0,-97
    80005aca:	85d2                	mv	a1,s4
    80005acc:	8556                	mv	a0,s5
    80005ace:	ffffc097          	auipc	ra,0xffffc
    80005ad2:	f9e080e7          	jalr	-98(ra) # 80001a6c <either_copyout>
    80005ad6:	01850663          	beq	a0,s8,80005ae2 <consoleread+0xc2>
    dst++;
    80005ada:	0a05                	addi	s4,s4,1
    --n;
    80005adc:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005ade:	f99d17e3          	bne	s10,s9,80005a6c <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005ae2:	0001c517          	auipc	a0,0x1c
    80005ae6:	42e50513          	addi	a0,a0,1070 # 80021f10 <cons>
    80005aea:	00001097          	auipc	ra,0x1
    80005aee:	8fe080e7          	jalr	-1794(ra) # 800063e8 <release>

  return target - n;
    80005af2:	413b053b          	subw	a0,s6,s3
    80005af6:	a811                	j	80005b0a <consoleread+0xea>
        release(&cons.lock);
    80005af8:	0001c517          	auipc	a0,0x1c
    80005afc:	41850513          	addi	a0,a0,1048 # 80021f10 <cons>
    80005b00:	00001097          	auipc	ra,0x1
    80005b04:	8e8080e7          	jalr	-1816(ra) # 800063e8 <release>
        return -1;
    80005b08:	557d                	li	a0,-1
}
    80005b0a:	70a6                	ld	ra,104(sp)
    80005b0c:	7406                	ld	s0,96(sp)
    80005b0e:	64e6                	ld	s1,88(sp)
    80005b10:	6946                	ld	s2,80(sp)
    80005b12:	69a6                	ld	s3,72(sp)
    80005b14:	6a06                	ld	s4,64(sp)
    80005b16:	7ae2                	ld	s5,56(sp)
    80005b18:	7b42                	ld	s6,48(sp)
    80005b1a:	7ba2                	ld	s7,40(sp)
    80005b1c:	7c02                	ld	s8,32(sp)
    80005b1e:	6ce2                	ld	s9,24(sp)
    80005b20:	6d42                	ld	s10,16(sp)
    80005b22:	6165                	addi	sp,sp,112
    80005b24:	8082                	ret
      if(n < target){
    80005b26:	0009871b          	sext.w	a4,s3
    80005b2a:	fb677ce3          	bgeu	a4,s6,80005ae2 <consoleread+0xc2>
        cons.r--;
    80005b2e:	0001c717          	auipc	a4,0x1c
    80005b32:	46f72d23          	sw	a5,1146(a4) # 80021fa8 <cons+0x98>
    80005b36:	b775                	j	80005ae2 <consoleread+0xc2>

0000000080005b38 <consputc>:
{
    80005b38:	1141                	addi	sp,sp,-16
    80005b3a:	e406                	sd	ra,8(sp)
    80005b3c:	e022                	sd	s0,0(sp)
    80005b3e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005b40:	10000793          	li	a5,256
    80005b44:	00f50a63          	beq	a0,a5,80005b58 <consputc+0x20>
    uartputc_sync(c);
    80005b48:	00000097          	auipc	ra,0x0
    80005b4c:	560080e7          	jalr	1376(ra) # 800060a8 <uartputc_sync>
}
    80005b50:	60a2                	ld	ra,8(sp)
    80005b52:	6402                	ld	s0,0(sp)
    80005b54:	0141                	addi	sp,sp,16
    80005b56:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005b58:	4521                	li	a0,8
    80005b5a:	00000097          	auipc	ra,0x0
    80005b5e:	54e080e7          	jalr	1358(ra) # 800060a8 <uartputc_sync>
    80005b62:	02000513          	li	a0,32
    80005b66:	00000097          	auipc	ra,0x0
    80005b6a:	542080e7          	jalr	1346(ra) # 800060a8 <uartputc_sync>
    80005b6e:	4521                	li	a0,8
    80005b70:	00000097          	auipc	ra,0x0
    80005b74:	538080e7          	jalr	1336(ra) # 800060a8 <uartputc_sync>
    80005b78:	bfe1                	j	80005b50 <consputc+0x18>

0000000080005b7a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b7a:	1101                	addi	sp,sp,-32
    80005b7c:	ec06                	sd	ra,24(sp)
    80005b7e:	e822                	sd	s0,16(sp)
    80005b80:	e426                	sd	s1,8(sp)
    80005b82:	e04a                	sd	s2,0(sp)
    80005b84:	1000                	addi	s0,sp,32
    80005b86:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b88:	0001c517          	auipc	a0,0x1c
    80005b8c:	38850513          	addi	a0,a0,904 # 80021f10 <cons>
    80005b90:	00000097          	auipc	ra,0x0
    80005b94:	7a4080e7          	jalr	1956(ra) # 80006334 <acquire>

  switch(c){
    80005b98:	47d5                	li	a5,21
    80005b9a:	0af48663          	beq	s1,a5,80005c46 <consoleintr+0xcc>
    80005b9e:	0297ca63          	blt	a5,s1,80005bd2 <consoleintr+0x58>
    80005ba2:	47a1                	li	a5,8
    80005ba4:	0ef48763          	beq	s1,a5,80005c92 <consoleintr+0x118>
    80005ba8:	47c1                	li	a5,16
    80005baa:	10f49a63          	bne	s1,a5,80005cbe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005bae:	ffffc097          	auipc	ra,0xffffc
    80005bb2:	f6a080e7          	jalr	-150(ra) # 80001b18 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005bb6:	0001c517          	auipc	a0,0x1c
    80005bba:	35a50513          	addi	a0,a0,858 # 80021f10 <cons>
    80005bbe:	00001097          	auipc	ra,0x1
    80005bc2:	82a080e7          	jalr	-2006(ra) # 800063e8 <release>
}
    80005bc6:	60e2                	ld	ra,24(sp)
    80005bc8:	6442                	ld	s0,16(sp)
    80005bca:	64a2                	ld	s1,8(sp)
    80005bcc:	6902                	ld	s2,0(sp)
    80005bce:	6105                	addi	sp,sp,32
    80005bd0:	8082                	ret
  switch(c){
    80005bd2:	07f00793          	li	a5,127
    80005bd6:	0af48e63          	beq	s1,a5,80005c92 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bda:	0001c717          	auipc	a4,0x1c
    80005bde:	33670713          	addi	a4,a4,822 # 80021f10 <cons>
    80005be2:	0a072783          	lw	a5,160(a4)
    80005be6:	09872703          	lw	a4,152(a4)
    80005bea:	9f99                	subw	a5,a5,a4
    80005bec:	07f00713          	li	a4,127
    80005bf0:	fcf763e3          	bltu	a4,a5,80005bb6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005bf4:	47b5                	li	a5,13
    80005bf6:	0cf48763          	beq	s1,a5,80005cc4 <consoleintr+0x14a>
      consputc(c);
    80005bfa:	8526                	mv	a0,s1
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	f3c080e7          	jalr	-196(ra) # 80005b38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c04:	0001c797          	auipc	a5,0x1c
    80005c08:	30c78793          	addi	a5,a5,780 # 80021f10 <cons>
    80005c0c:	0a07a683          	lw	a3,160(a5)
    80005c10:	0016871b          	addiw	a4,a3,1
    80005c14:	0007061b          	sext.w	a2,a4
    80005c18:	0ae7a023          	sw	a4,160(a5)
    80005c1c:	07f6f693          	andi	a3,a3,127
    80005c20:	97b6                	add	a5,a5,a3
    80005c22:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005c26:	47a9                	li	a5,10
    80005c28:	0cf48563          	beq	s1,a5,80005cf2 <consoleintr+0x178>
    80005c2c:	4791                	li	a5,4
    80005c2e:	0cf48263          	beq	s1,a5,80005cf2 <consoleintr+0x178>
    80005c32:	0001c797          	auipc	a5,0x1c
    80005c36:	3767a783          	lw	a5,886(a5) # 80021fa8 <cons+0x98>
    80005c3a:	9f1d                	subw	a4,a4,a5
    80005c3c:	08000793          	li	a5,128
    80005c40:	f6f71be3          	bne	a4,a5,80005bb6 <consoleintr+0x3c>
    80005c44:	a07d                	j	80005cf2 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005c46:	0001c717          	auipc	a4,0x1c
    80005c4a:	2ca70713          	addi	a4,a4,714 # 80021f10 <cons>
    80005c4e:	0a072783          	lw	a5,160(a4)
    80005c52:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c56:	0001c497          	auipc	s1,0x1c
    80005c5a:	2ba48493          	addi	s1,s1,698 # 80021f10 <cons>
    while(cons.e != cons.w &&
    80005c5e:	4929                	li	s2,10
    80005c60:	f4f70be3          	beq	a4,a5,80005bb6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005c64:	37fd                	addiw	a5,a5,-1
    80005c66:	07f7f713          	andi	a4,a5,127
    80005c6a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005c6c:	01874703          	lbu	a4,24(a4)
    80005c70:	f52703e3          	beq	a4,s2,80005bb6 <consoleintr+0x3c>
      cons.e--;
    80005c74:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c78:	10000513          	li	a0,256
    80005c7c:	00000097          	auipc	ra,0x0
    80005c80:	ebc080e7          	jalr	-324(ra) # 80005b38 <consputc>
    while(cons.e != cons.w &&
    80005c84:	0a04a783          	lw	a5,160(s1)
    80005c88:	09c4a703          	lw	a4,156(s1)
    80005c8c:	fcf71ce3          	bne	a4,a5,80005c64 <consoleintr+0xea>
    80005c90:	b71d                	j	80005bb6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c92:	0001c717          	auipc	a4,0x1c
    80005c96:	27e70713          	addi	a4,a4,638 # 80021f10 <cons>
    80005c9a:	0a072783          	lw	a5,160(a4)
    80005c9e:	09c72703          	lw	a4,156(a4)
    80005ca2:	f0f70ae3          	beq	a4,a5,80005bb6 <consoleintr+0x3c>
      cons.e--;
    80005ca6:	37fd                	addiw	a5,a5,-1
    80005ca8:	0001c717          	auipc	a4,0x1c
    80005cac:	30f72423          	sw	a5,776(a4) # 80021fb0 <cons+0xa0>
      consputc(BACKSPACE);
    80005cb0:	10000513          	li	a0,256
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	e84080e7          	jalr	-380(ra) # 80005b38 <consputc>
    80005cbc:	bded                	j	80005bb6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005cbe:	ee048ce3          	beqz	s1,80005bb6 <consoleintr+0x3c>
    80005cc2:	bf21                	j	80005bda <consoleintr+0x60>
      consputc(c);
    80005cc4:	4529                	li	a0,10
    80005cc6:	00000097          	auipc	ra,0x0
    80005cca:	e72080e7          	jalr	-398(ra) # 80005b38 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cce:	0001c797          	auipc	a5,0x1c
    80005cd2:	24278793          	addi	a5,a5,578 # 80021f10 <cons>
    80005cd6:	0a07a703          	lw	a4,160(a5)
    80005cda:	0017069b          	addiw	a3,a4,1
    80005cde:	0006861b          	sext.w	a2,a3
    80005ce2:	0ad7a023          	sw	a3,160(a5)
    80005ce6:	07f77713          	andi	a4,a4,127
    80005cea:	97ba                	add	a5,a5,a4
    80005cec:	4729                	li	a4,10
    80005cee:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005cf2:	0001c797          	auipc	a5,0x1c
    80005cf6:	2ac7ad23          	sw	a2,698(a5) # 80021fac <cons+0x9c>
        wakeup(&cons.r);
    80005cfa:	0001c517          	auipc	a0,0x1c
    80005cfe:	2ae50513          	addi	a0,a0,686 # 80021fa8 <cons+0x98>
    80005d02:	ffffc097          	auipc	ra,0xffffc
    80005d06:	9c6080e7          	jalr	-1594(ra) # 800016c8 <wakeup>
    80005d0a:	b575                	j	80005bb6 <consoleintr+0x3c>

0000000080005d0c <consoleinit>:

void
consoleinit(void)
{
    80005d0c:	1141                	addi	sp,sp,-16
    80005d0e:	e406                	sd	ra,8(sp)
    80005d10:	e022                	sd	s0,0(sp)
    80005d12:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d14:	00003597          	auipc	a1,0x3
    80005d18:	b5458593          	addi	a1,a1,-1196 # 80008868 <syscalls+0x468>
    80005d1c:	0001c517          	auipc	a0,0x1c
    80005d20:	1f450513          	addi	a0,a0,500 # 80021f10 <cons>
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	580080e7          	jalr	1408(ra) # 800062a4 <initlock>

  uartinit();
    80005d2c:	00000097          	auipc	ra,0x0
    80005d30:	32c080e7          	jalr	812(ra) # 80006058 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005d34:	00013797          	auipc	a5,0x13
    80005d38:	f0478793          	addi	a5,a5,-252 # 80018c38 <devsw>
    80005d3c:	00000717          	auipc	a4,0x0
    80005d40:	ce470713          	addi	a4,a4,-796 # 80005a20 <consoleread>
    80005d44:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005d46:	00000717          	auipc	a4,0x0
    80005d4a:	c7670713          	addi	a4,a4,-906 # 800059bc <consolewrite>
    80005d4e:	ef98                	sd	a4,24(a5)
}
    80005d50:	60a2                	ld	ra,8(sp)
    80005d52:	6402                	ld	s0,0(sp)
    80005d54:	0141                	addi	sp,sp,16
    80005d56:	8082                	ret

0000000080005d58 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005d58:	7179                	addi	sp,sp,-48
    80005d5a:	f406                	sd	ra,40(sp)
    80005d5c:	f022                	sd	s0,32(sp)
    80005d5e:	ec26                	sd	s1,24(sp)
    80005d60:	e84a                	sd	s2,16(sp)
    80005d62:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005d64:	c219                	beqz	a2,80005d6a <printint+0x12>
    80005d66:	08054763          	bltz	a0,80005df4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005d6a:	2501                	sext.w	a0,a0
    80005d6c:	4881                	li	a7,0
    80005d6e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005d72:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005d74:	2581                	sext.w	a1,a1
    80005d76:	00003617          	auipc	a2,0x3
    80005d7a:	b2260613          	addi	a2,a2,-1246 # 80008898 <digits>
    80005d7e:	883a                	mv	a6,a4
    80005d80:	2705                	addiw	a4,a4,1
    80005d82:	02b577bb          	remuw	a5,a0,a1
    80005d86:	1782                	slli	a5,a5,0x20
    80005d88:	9381                	srli	a5,a5,0x20
    80005d8a:	97b2                	add	a5,a5,a2
    80005d8c:	0007c783          	lbu	a5,0(a5)
    80005d90:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d94:	0005079b          	sext.w	a5,a0
    80005d98:	02b5553b          	divuw	a0,a0,a1
    80005d9c:	0685                	addi	a3,a3,1
    80005d9e:	feb7f0e3          	bgeu	a5,a1,80005d7e <printint+0x26>

  if(sign)
    80005da2:	00088c63          	beqz	a7,80005dba <printint+0x62>
    buf[i++] = '-';
    80005da6:	fe070793          	addi	a5,a4,-32
    80005daa:	00878733          	add	a4,a5,s0
    80005dae:	02d00793          	li	a5,45
    80005db2:	fef70823          	sb	a5,-16(a4)
    80005db6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005dba:	02e05763          	blez	a4,80005de8 <printint+0x90>
    80005dbe:	fd040793          	addi	a5,s0,-48
    80005dc2:	00e784b3          	add	s1,a5,a4
    80005dc6:	fff78913          	addi	s2,a5,-1
    80005dca:	993a                	add	s2,s2,a4
    80005dcc:	377d                	addiw	a4,a4,-1
    80005dce:	1702                	slli	a4,a4,0x20
    80005dd0:	9301                	srli	a4,a4,0x20
    80005dd2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005dd6:	fff4c503          	lbu	a0,-1(s1)
    80005dda:	00000097          	auipc	ra,0x0
    80005dde:	d5e080e7          	jalr	-674(ra) # 80005b38 <consputc>
  while(--i >= 0)
    80005de2:	14fd                	addi	s1,s1,-1
    80005de4:	ff2499e3          	bne	s1,s2,80005dd6 <printint+0x7e>
}
    80005de8:	70a2                	ld	ra,40(sp)
    80005dea:	7402                	ld	s0,32(sp)
    80005dec:	64e2                	ld	s1,24(sp)
    80005dee:	6942                	ld	s2,16(sp)
    80005df0:	6145                	addi	sp,sp,48
    80005df2:	8082                	ret
    x = -xx;
    80005df4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005df8:	4885                	li	a7,1
    x = -xx;
    80005dfa:	bf95                	j	80005d6e <printint+0x16>

0000000080005dfc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005dfc:	1101                	addi	sp,sp,-32
    80005dfe:	ec06                	sd	ra,24(sp)
    80005e00:	e822                	sd	s0,16(sp)
    80005e02:	e426                	sd	s1,8(sp)
    80005e04:	1000                	addi	s0,sp,32
    80005e06:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e08:	0001c797          	auipc	a5,0x1c
    80005e0c:	1c07a423          	sw	zero,456(a5) # 80021fd0 <pr+0x18>
  printf("panic: ");
    80005e10:	00003517          	auipc	a0,0x3
    80005e14:	a6050513          	addi	a0,a0,-1440 # 80008870 <syscalls+0x470>
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	02e080e7          	jalr	46(ra) # 80005e46 <printf>
  printf(s);
    80005e20:	8526                	mv	a0,s1
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	024080e7          	jalr	36(ra) # 80005e46 <printf>
  printf("\n");
    80005e2a:	00002517          	auipc	a0,0x2
    80005e2e:	21e50513          	addi	a0,a0,542 # 80008048 <etext+0x48>
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	014080e7          	jalr	20(ra) # 80005e46 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005e3a:	4785                	li	a5,1
    80005e3c:	00003717          	auipc	a4,0x3
    80005e40:	b4f72423          	sw	a5,-1208(a4) # 80008984 <panicked>
  for(;;)
    80005e44:	a001                	j	80005e44 <panic+0x48>

0000000080005e46 <printf>:
{
    80005e46:	7131                	addi	sp,sp,-192
    80005e48:	fc86                	sd	ra,120(sp)
    80005e4a:	f8a2                	sd	s0,112(sp)
    80005e4c:	f4a6                	sd	s1,104(sp)
    80005e4e:	f0ca                	sd	s2,96(sp)
    80005e50:	ecce                	sd	s3,88(sp)
    80005e52:	e8d2                	sd	s4,80(sp)
    80005e54:	e4d6                	sd	s5,72(sp)
    80005e56:	e0da                	sd	s6,64(sp)
    80005e58:	fc5e                	sd	s7,56(sp)
    80005e5a:	f862                	sd	s8,48(sp)
    80005e5c:	f466                	sd	s9,40(sp)
    80005e5e:	f06a                	sd	s10,32(sp)
    80005e60:	ec6e                	sd	s11,24(sp)
    80005e62:	0100                	addi	s0,sp,128
    80005e64:	8a2a                	mv	s4,a0
    80005e66:	e40c                	sd	a1,8(s0)
    80005e68:	e810                	sd	a2,16(s0)
    80005e6a:	ec14                	sd	a3,24(s0)
    80005e6c:	f018                	sd	a4,32(s0)
    80005e6e:	f41c                	sd	a5,40(s0)
    80005e70:	03043823          	sd	a6,48(s0)
    80005e74:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e78:	0001cd97          	auipc	s11,0x1c
    80005e7c:	158dad83          	lw	s11,344(s11) # 80021fd0 <pr+0x18>
  if(locking)
    80005e80:	020d9b63          	bnez	s11,80005eb6 <printf+0x70>
  if (fmt == 0)
    80005e84:	040a0263          	beqz	s4,80005ec8 <printf+0x82>
  va_start(ap, fmt);
    80005e88:	00840793          	addi	a5,s0,8
    80005e8c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e90:	000a4503          	lbu	a0,0(s4)
    80005e94:	14050f63          	beqz	a0,80005ff2 <printf+0x1ac>
    80005e98:	4981                	li	s3,0
    if(c != '%'){
    80005e9a:	02500a93          	li	s5,37
    switch(c){
    80005e9e:	07000b93          	li	s7,112
  consputc('x');
    80005ea2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ea4:	00003b17          	auipc	s6,0x3
    80005ea8:	9f4b0b13          	addi	s6,s6,-1548 # 80008898 <digits>
    switch(c){
    80005eac:	07300c93          	li	s9,115
    80005eb0:	06400c13          	li	s8,100
    80005eb4:	a82d                	j	80005eee <printf+0xa8>
    acquire(&pr.lock);
    80005eb6:	0001c517          	auipc	a0,0x1c
    80005eba:	10250513          	addi	a0,a0,258 # 80021fb8 <pr>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	476080e7          	jalr	1142(ra) # 80006334 <acquire>
    80005ec6:	bf7d                	j	80005e84 <printf+0x3e>
    panic("null fmt");
    80005ec8:	00003517          	auipc	a0,0x3
    80005ecc:	9b850513          	addi	a0,a0,-1608 # 80008880 <syscalls+0x480>
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	f2c080e7          	jalr	-212(ra) # 80005dfc <panic>
      consputc(c);
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	c60080e7          	jalr	-928(ra) # 80005b38 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005ee0:	2985                	addiw	s3,s3,1
    80005ee2:	013a07b3          	add	a5,s4,s3
    80005ee6:	0007c503          	lbu	a0,0(a5)
    80005eea:	10050463          	beqz	a0,80005ff2 <printf+0x1ac>
    if(c != '%'){
    80005eee:	ff5515e3          	bne	a0,s5,80005ed8 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ef2:	2985                	addiw	s3,s3,1
    80005ef4:	013a07b3          	add	a5,s4,s3
    80005ef8:	0007c783          	lbu	a5,0(a5)
    80005efc:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f00:	cbed                	beqz	a5,80005ff2 <printf+0x1ac>
    switch(c){
    80005f02:	05778a63          	beq	a5,s7,80005f56 <printf+0x110>
    80005f06:	02fbf663          	bgeu	s7,a5,80005f32 <printf+0xec>
    80005f0a:	09978863          	beq	a5,s9,80005f9a <printf+0x154>
    80005f0e:	07800713          	li	a4,120
    80005f12:	0ce79563          	bne	a5,a4,80005fdc <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005f16:	f8843783          	ld	a5,-120(s0)
    80005f1a:	00878713          	addi	a4,a5,8
    80005f1e:	f8e43423          	sd	a4,-120(s0)
    80005f22:	4605                	li	a2,1
    80005f24:	85ea                	mv	a1,s10
    80005f26:	4388                	lw	a0,0(a5)
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	e30080e7          	jalr	-464(ra) # 80005d58 <printint>
      break;
    80005f30:	bf45                	j	80005ee0 <printf+0x9a>
    switch(c){
    80005f32:	09578f63          	beq	a5,s5,80005fd0 <printf+0x18a>
    80005f36:	0b879363          	bne	a5,s8,80005fdc <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005f3a:	f8843783          	ld	a5,-120(s0)
    80005f3e:	00878713          	addi	a4,a5,8
    80005f42:	f8e43423          	sd	a4,-120(s0)
    80005f46:	4605                	li	a2,1
    80005f48:	45a9                	li	a1,10
    80005f4a:	4388                	lw	a0,0(a5)
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	e0c080e7          	jalr	-500(ra) # 80005d58 <printint>
      break;
    80005f54:	b771                	j	80005ee0 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005f56:	f8843783          	ld	a5,-120(s0)
    80005f5a:	00878713          	addi	a4,a5,8
    80005f5e:	f8e43423          	sd	a4,-120(s0)
    80005f62:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f66:	03000513          	li	a0,48
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	bce080e7          	jalr	-1074(ra) # 80005b38 <consputc>
  consputc('x');
    80005f72:	07800513          	li	a0,120
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	bc2080e7          	jalr	-1086(ra) # 80005b38 <consputc>
    80005f7e:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f80:	03c95793          	srli	a5,s2,0x3c
    80005f84:	97da                	add	a5,a5,s6
    80005f86:	0007c503          	lbu	a0,0(a5)
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	bae080e7          	jalr	-1106(ra) # 80005b38 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f92:	0912                	slli	s2,s2,0x4
    80005f94:	34fd                	addiw	s1,s1,-1
    80005f96:	f4ed                	bnez	s1,80005f80 <printf+0x13a>
    80005f98:	b7a1                	j	80005ee0 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f9a:	f8843783          	ld	a5,-120(s0)
    80005f9e:	00878713          	addi	a4,a5,8
    80005fa2:	f8e43423          	sd	a4,-120(s0)
    80005fa6:	6384                	ld	s1,0(a5)
    80005fa8:	cc89                	beqz	s1,80005fc2 <printf+0x17c>
      for(; *s; s++)
    80005faa:	0004c503          	lbu	a0,0(s1)
    80005fae:	d90d                	beqz	a0,80005ee0 <printf+0x9a>
        consputc(*s);
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	b88080e7          	jalr	-1144(ra) # 80005b38 <consputc>
      for(; *s; s++)
    80005fb8:	0485                	addi	s1,s1,1
    80005fba:	0004c503          	lbu	a0,0(s1)
    80005fbe:	f96d                	bnez	a0,80005fb0 <printf+0x16a>
    80005fc0:	b705                	j	80005ee0 <printf+0x9a>
        s = "(null)";
    80005fc2:	00003497          	auipc	s1,0x3
    80005fc6:	8b648493          	addi	s1,s1,-1866 # 80008878 <syscalls+0x478>
      for(; *s; s++)
    80005fca:	02800513          	li	a0,40
    80005fce:	b7cd                	j	80005fb0 <printf+0x16a>
      consputc('%');
    80005fd0:	8556                	mv	a0,s5
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	b66080e7          	jalr	-1178(ra) # 80005b38 <consputc>
      break;
    80005fda:	b719                	j	80005ee0 <printf+0x9a>
      consputc('%');
    80005fdc:	8556                	mv	a0,s5
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	b5a080e7          	jalr	-1190(ra) # 80005b38 <consputc>
      consputc(c);
    80005fe6:	8526                	mv	a0,s1
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	b50080e7          	jalr	-1200(ra) # 80005b38 <consputc>
      break;
    80005ff0:	bdc5                	j	80005ee0 <printf+0x9a>
  if(locking)
    80005ff2:	020d9163          	bnez	s11,80006014 <printf+0x1ce>
}
    80005ff6:	70e6                	ld	ra,120(sp)
    80005ff8:	7446                	ld	s0,112(sp)
    80005ffa:	74a6                	ld	s1,104(sp)
    80005ffc:	7906                	ld	s2,96(sp)
    80005ffe:	69e6                	ld	s3,88(sp)
    80006000:	6a46                	ld	s4,80(sp)
    80006002:	6aa6                	ld	s5,72(sp)
    80006004:	6b06                	ld	s6,64(sp)
    80006006:	7be2                	ld	s7,56(sp)
    80006008:	7c42                	ld	s8,48(sp)
    8000600a:	7ca2                	ld	s9,40(sp)
    8000600c:	7d02                	ld	s10,32(sp)
    8000600e:	6de2                	ld	s11,24(sp)
    80006010:	6129                	addi	sp,sp,192
    80006012:	8082                	ret
    release(&pr.lock);
    80006014:	0001c517          	auipc	a0,0x1c
    80006018:	fa450513          	addi	a0,a0,-92 # 80021fb8 <pr>
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	3cc080e7          	jalr	972(ra) # 800063e8 <release>
}
    80006024:	bfc9                	j	80005ff6 <printf+0x1b0>

0000000080006026 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006026:	1101                	addi	sp,sp,-32
    80006028:	ec06                	sd	ra,24(sp)
    8000602a:	e822                	sd	s0,16(sp)
    8000602c:	e426                	sd	s1,8(sp)
    8000602e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006030:	0001c497          	auipc	s1,0x1c
    80006034:	f8848493          	addi	s1,s1,-120 # 80021fb8 <pr>
    80006038:	00003597          	auipc	a1,0x3
    8000603c:	85858593          	addi	a1,a1,-1960 # 80008890 <syscalls+0x490>
    80006040:	8526                	mv	a0,s1
    80006042:	00000097          	auipc	ra,0x0
    80006046:	262080e7          	jalr	610(ra) # 800062a4 <initlock>
  pr.locking = 1;
    8000604a:	4785                	li	a5,1
    8000604c:	cc9c                	sw	a5,24(s1)
}
    8000604e:	60e2                	ld	ra,24(sp)
    80006050:	6442                	ld	s0,16(sp)
    80006052:	64a2                	ld	s1,8(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret

0000000080006058 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006058:	1141                	addi	sp,sp,-16
    8000605a:	e406                	sd	ra,8(sp)
    8000605c:	e022                	sd	s0,0(sp)
    8000605e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006060:	100007b7          	lui	a5,0x10000
    80006064:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006068:	f8000713          	li	a4,-128
    8000606c:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006070:	470d                	li	a4,3
    80006072:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006076:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000607a:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000607e:	469d                	li	a3,7
    80006080:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006084:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006088:	00003597          	auipc	a1,0x3
    8000608c:	82858593          	addi	a1,a1,-2008 # 800088b0 <digits+0x18>
    80006090:	0001c517          	auipc	a0,0x1c
    80006094:	f4850513          	addi	a0,a0,-184 # 80021fd8 <uart_tx_lock>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	20c080e7          	jalr	524(ra) # 800062a4 <initlock>
}
    800060a0:	60a2                	ld	ra,8(sp)
    800060a2:	6402                	ld	s0,0(sp)
    800060a4:	0141                	addi	sp,sp,16
    800060a6:	8082                	ret

00000000800060a8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060a8:	1101                	addi	sp,sp,-32
    800060aa:	ec06                	sd	ra,24(sp)
    800060ac:	e822                	sd	s0,16(sp)
    800060ae:	e426                	sd	s1,8(sp)
    800060b0:	1000                	addi	s0,sp,32
    800060b2:	84aa                	mv	s1,a0
  push_off();
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	234080e7          	jalr	564(ra) # 800062e8 <push_off>

  if(panicked){
    800060bc:	00003797          	auipc	a5,0x3
    800060c0:	8c87a783          	lw	a5,-1848(a5) # 80008984 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060c4:	10000737          	lui	a4,0x10000
  if(panicked){
    800060c8:	c391                	beqz	a5,800060cc <uartputc_sync+0x24>
    for(;;)
    800060ca:	a001                	j	800060ca <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060cc:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800060d0:	0207f793          	andi	a5,a5,32
    800060d4:	dfe5                	beqz	a5,800060cc <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060d6:	0ff4f513          	zext.b	a0,s1
    800060da:	100007b7          	lui	a5,0x10000
    800060de:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	2a6080e7          	jalr	678(ra) # 80006388 <pop_off>
}
    800060ea:	60e2                	ld	ra,24(sp)
    800060ec:	6442                	ld	s0,16(sp)
    800060ee:	64a2                	ld	s1,8(sp)
    800060f0:	6105                	addi	sp,sp,32
    800060f2:	8082                	ret

00000000800060f4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800060f4:	00003797          	auipc	a5,0x3
    800060f8:	8947b783          	ld	a5,-1900(a5) # 80008988 <uart_tx_r>
    800060fc:	00003717          	auipc	a4,0x3
    80006100:	89473703          	ld	a4,-1900(a4) # 80008990 <uart_tx_w>
    80006104:	06f70a63          	beq	a4,a5,80006178 <uartstart+0x84>
{
    80006108:	7139                	addi	sp,sp,-64
    8000610a:	fc06                	sd	ra,56(sp)
    8000610c:	f822                	sd	s0,48(sp)
    8000610e:	f426                	sd	s1,40(sp)
    80006110:	f04a                	sd	s2,32(sp)
    80006112:	ec4e                	sd	s3,24(sp)
    80006114:	e852                	sd	s4,16(sp)
    80006116:	e456                	sd	s5,8(sp)
    80006118:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000611a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000611e:	0001ca17          	auipc	s4,0x1c
    80006122:	ebaa0a13          	addi	s4,s4,-326 # 80021fd8 <uart_tx_lock>
    uart_tx_r += 1;
    80006126:	00003497          	auipc	s1,0x3
    8000612a:	86248493          	addi	s1,s1,-1950 # 80008988 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000612e:	00003997          	auipc	s3,0x3
    80006132:	86298993          	addi	s3,s3,-1950 # 80008990 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006136:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000613a:	02077713          	andi	a4,a4,32
    8000613e:	c705                	beqz	a4,80006166 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006140:	01f7f713          	andi	a4,a5,31
    80006144:	9752                	add	a4,a4,s4
    80006146:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000614a:	0785                	addi	a5,a5,1
    8000614c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000614e:	8526                	mv	a0,s1
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	578080e7          	jalr	1400(ra) # 800016c8 <wakeup>
    
    WriteReg(THR, c);
    80006158:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000615c:	609c                	ld	a5,0(s1)
    8000615e:	0009b703          	ld	a4,0(s3)
    80006162:	fcf71ae3          	bne	a4,a5,80006136 <uartstart+0x42>
  }
}
    80006166:	70e2                	ld	ra,56(sp)
    80006168:	7442                	ld	s0,48(sp)
    8000616a:	74a2                	ld	s1,40(sp)
    8000616c:	7902                	ld	s2,32(sp)
    8000616e:	69e2                	ld	s3,24(sp)
    80006170:	6a42                	ld	s4,16(sp)
    80006172:	6aa2                	ld	s5,8(sp)
    80006174:	6121                	addi	sp,sp,64
    80006176:	8082                	ret
    80006178:	8082                	ret

000000008000617a <uartputc>:
{
    8000617a:	7179                	addi	sp,sp,-48
    8000617c:	f406                	sd	ra,40(sp)
    8000617e:	f022                	sd	s0,32(sp)
    80006180:	ec26                	sd	s1,24(sp)
    80006182:	e84a                	sd	s2,16(sp)
    80006184:	e44e                	sd	s3,8(sp)
    80006186:	e052                	sd	s4,0(sp)
    80006188:	1800                	addi	s0,sp,48
    8000618a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000618c:	0001c517          	auipc	a0,0x1c
    80006190:	e4c50513          	addi	a0,a0,-436 # 80021fd8 <uart_tx_lock>
    80006194:	00000097          	auipc	ra,0x0
    80006198:	1a0080e7          	jalr	416(ra) # 80006334 <acquire>
  if(panicked){
    8000619c:	00002797          	auipc	a5,0x2
    800061a0:	7e87a783          	lw	a5,2024(a5) # 80008984 <panicked>
    800061a4:	e7c9                	bnez	a5,8000622e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061a6:	00002717          	auipc	a4,0x2
    800061aa:	7ea73703          	ld	a4,2026(a4) # 80008990 <uart_tx_w>
    800061ae:	00002797          	auipc	a5,0x2
    800061b2:	7da7b783          	ld	a5,2010(a5) # 80008988 <uart_tx_r>
    800061b6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800061ba:	0001c997          	auipc	s3,0x1c
    800061be:	e1e98993          	addi	s3,s3,-482 # 80021fd8 <uart_tx_lock>
    800061c2:	00002497          	auipc	s1,0x2
    800061c6:	7c648493          	addi	s1,s1,1990 # 80008988 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ca:	00002917          	auipc	s2,0x2
    800061ce:	7c690913          	addi	s2,s2,1990 # 80008990 <uart_tx_w>
    800061d2:	00e79f63          	bne	a5,a4,800061f0 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800061d6:	85ce                	mv	a1,s3
    800061d8:	8526                	mv	a0,s1
    800061da:	ffffb097          	auipc	ra,0xffffb
    800061de:	48a080e7          	jalr	1162(ra) # 80001664 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061e2:	00093703          	ld	a4,0(s2)
    800061e6:	609c                	ld	a5,0(s1)
    800061e8:	02078793          	addi	a5,a5,32
    800061ec:	fee785e3          	beq	a5,a4,800061d6 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800061f0:	0001c497          	auipc	s1,0x1c
    800061f4:	de848493          	addi	s1,s1,-536 # 80021fd8 <uart_tx_lock>
    800061f8:	01f77793          	andi	a5,a4,31
    800061fc:	97a6                	add	a5,a5,s1
    800061fe:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006202:	0705                	addi	a4,a4,1
    80006204:	00002797          	auipc	a5,0x2
    80006208:	78e7b623          	sd	a4,1932(a5) # 80008990 <uart_tx_w>
  uartstart();
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	ee8080e7          	jalr	-280(ra) # 800060f4 <uartstart>
  release(&uart_tx_lock);
    80006214:	8526                	mv	a0,s1
    80006216:	00000097          	auipc	ra,0x0
    8000621a:	1d2080e7          	jalr	466(ra) # 800063e8 <release>
}
    8000621e:	70a2                	ld	ra,40(sp)
    80006220:	7402                	ld	s0,32(sp)
    80006222:	64e2                	ld	s1,24(sp)
    80006224:	6942                	ld	s2,16(sp)
    80006226:	69a2                	ld	s3,8(sp)
    80006228:	6a02                	ld	s4,0(sp)
    8000622a:	6145                	addi	sp,sp,48
    8000622c:	8082                	ret
    for(;;)
    8000622e:	a001                	j	8000622e <uartputc+0xb4>

0000000080006230 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006230:	1141                	addi	sp,sp,-16
    80006232:	e422                	sd	s0,8(sp)
    80006234:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006236:	100007b7          	lui	a5,0x10000
    8000623a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000623e:	8b85                	andi	a5,a5,1
    80006240:	cb81                	beqz	a5,80006250 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006242:	100007b7          	lui	a5,0x10000
    80006246:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000624a:	6422                	ld	s0,8(sp)
    8000624c:	0141                	addi	sp,sp,16
    8000624e:	8082                	ret
    return -1;
    80006250:	557d                	li	a0,-1
    80006252:	bfe5                	j	8000624a <uartgetc+0x1a>

0000000080006254 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006254:	1101                	addi	sp,sp,-32
    80006256:	ec06                	sd	ra,24(sp)
    80006258:	e822                	sd	s0,16(sp)
    8000625a:	e426                	sd	s1,8(sp)
    8000625c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000625e:	54fd                	li	s1,-1
    80006260:	a029                	j	8000626a <uartintr+0x16>
      break;
    consoleintr(c);
    80006262:	00000097          	auipc	ra,0x0
    80006266:	918080e7          	jalr	-1768(ra) # 80005b7a <consoleintr>
    int c = uartgetc();
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	fc6080e7          	jalr	-58(ra) # 80006230 <uartgetc>
    if(c == -1)
    80006272:	fe9518e3          	bne	a0,s1,80006262 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006276:	0001c497          	auipc	s1,0x1c
    8000627a:	d6248493          	addi	s1,s1,-670 # 80021fd8 <uart_tx_lock>
    8000627e:	8526                	mv	a0,s1
    80006280:	00000097          	auipc	ra,0x0
    80006284:	0b4080e7          	jalr	180(ra) # 80006334 <acquire>
  uartstart();
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	e6c080e7          	jalr	-404(ra) # 800060f4 <uartstart>
  release(&uart_tx_lock);
    80006290:	8526                	mv	a0,s1
    80006292:	00000097          	auipc	ra,0x0
    80006296:	156080e7          	jalr	342(ra) # 800063e8 <release>
}
    8000629a:	60e2                	ld	ra,24(sp)
    8000629c:	6442                	ld	s0,16(sp)
    8000629e:	64a2                	ld	s1,8(sp)
    800062a0:	6105                	addi	sp,sp,32
    800062a2:	8082                	ret

00000000800062a4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062a4:	1141                	addi	sp,sp,-16
    800062a6:	e422                	sd	s0,8(sp)
    800062a8:	0800                	addi	s0,sp,16
  lk->name = name;
    800062aa:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062ac:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062b0:	00053823          	sd	zero,16(a0)
}
    800062b4:	6422                	ld	s0,8(sp)
    800062b6:	0141                	addi	sp,sp,16
    800062b8:	8082                	ret

00000000800062ba <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062ba:	411c                	lw	a5,0(a0)
    800062bc:	e399                	bnez	a5,800062c2 <holding+0x8>
    800062be:	4501                	li	a0,0
  return r;
}
    800062c0:	8082                	ret
{
    800062c2:	1101                	addi	sp,sp,-32
    800062c4:	ec06                	sd	ra,24(sp)
    800062c6:	e822                	sd	s0,16(sp)
    800062c8:	e426                	sd	s1,8(sp)
    800062ca:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062cc:	6904                	ld	s1,16(a0)
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	c54080e7          	jalr	-940(ra) # 80000f22 <mycpu>
    800062d6:	40a48533          	sub	a0,s1,a0
    800062da:	00153513          	seqz	a0,a0
}
    800062de:	60e2                	ld	ra,24(sp)
    800062e0:	6442                	ld	s0,16(sp)
    800062e2:	64a2                	ld	s1,8(sp)
    800062e4:	6105                	addi	sp,sp,32
    800062e6:	8082                	ret

00000000800062e8 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800062e8:	1101                	addi	sp,sp,-32
    800062ea:	ec06                	sd	ra,24(sp)
    800062ec:	e822                	sd	s0,16(sp)
    800062ee:	e426                	sd	s1,8(sp)
    800062f0:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f2:	100024f3          	csrr	s1,sstatus
    800062f6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800062fa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062fc:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006300:	ffffb097          	auipc	ra,0xffffb
    80006304:	c22080e7          	jalr	-990(ra) # 80000f22 <mycpu>
    80006308:	5d3c                	lw	a5,120(a0)
    8000630a:	cf89                	beqz	a5,80006324 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000630c:	ffffb097          	auipc	ra,0xffffb
    80006310:	c16080e7          	jalr	-1002(ra) # 80000f22 <mycpu>
    80006314:	5d3c                	lw	a5,120(a0)
    80006316:	2785                	addiw	a5,a5,1
    80006318:	dd3c                	sw	a5,120(a0)
}
    8000631a:	60e2                	ld	ra,24(sp)
    8000631c:	6442                	ld	s0,16(sp)
    8000631e:	64a2                	ld	s1,8(sp)
    80006320:	6105                	addi	sp,sp,32
    80006322:	8082                	ret
    mycpu()->intena = old;
    80006324:	ffffb097          	auipc	ra,0xffffb
    80006328:	bfe080e7          	jalr	-1026(ra) # 80000f22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000632c:	8085                	srli	s1,s1,0x1
    8000632e:	8885                	andi	s1,s1,1
    80006330:	dd64                	sw	s1,124(a0)
    80006332:	bfe9                	j	8000630c <push_off+0x24>

0000000080006334 <acquire>:
{
    80006334:	1101                	addi	sp,sp,-32
    80006336:	ec06                	sd	ra,24(sp)
    80006338:	e822                	sd	s0,16(sp)
    8000633a:	e426                	sd	s1,8(sp)
    8000633c:	1000                	addi	s0,sp,32
    8000633e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006340:	00000097          	auipc	ra,0x0
    80006344:	fa8080e7          	jalr	-88(ra) # 800062e8 <push_off>
  if(holding(lk))
    80006348:	8526                	mv	a0,s1
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	f70080e7          	jalr	-144(ra) # 800062ba <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006352:	4705                	li	a4,1
  if(holding(lk))
    80006354:	e115                	bnez	a0,80006378 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006356:	87ba                	mv	a5,a4
    80006358:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000635c:	2781                	sext.w	a5,a5
    8000635e:	ffe5                	bnez	a5,80006356 <acquire+0x22>
  __sync_synchronize();
    80006360:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006364:	ffffb097          	auipc	ra,0xffffb
    80006368:	bbe080e7          	jalr	-1090(ra) # 80000f22 <mycpu>
    8000636c:	e888                	sd	a0,16(s1)
}
    8000636e:	60e2                	ld	ra,24(sp)
    80006370:	6442                	ld	s0,16(sp)
    80006372:	64a2                	ld	s1,8(sp)
    80006374:	6105                	addi	sp,sp,32
    80006376:	8082                	ret
    panic("acquire");
    80006378:	00002517          	auipc	a0,0x2
    8000637c:	54050513          	addi	a0,a0,1344 # 800088b8 <digits+0x20>
    80006380:	00000097          	auipc	ra,0x0
    80006384:	a7c080e7          	jalr	-1412(ra) # 80005dfc <panic>

0000000080006388 <pop_off>:

void
pop_off(void)
{
    80006388:	1141                	addi	sp,sp,-16
    8000638a:	e406                	sd	ra,8(sp)
    8000638c:	e022                	sd	s0,0(sp)
    8000638e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006390:	ffffb097          	auipc	ra,0xffffb
    80006394:	b92080e7          	jalr	-1134(ra) # 80000f22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006398:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000639c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000639e:	e78d                	bnez	a5,800063c8 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063a0:	5d3c                	lw	a5,120(a0)
    800063a2:	02f05b63          	blez	a5,800063d8 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800063a6:	37fd                	addiw	a5,a5,-1
    800063a8:	0007871b          	sext.w	a4,a5
    800063ac:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063ae:	eb09                	bnez	a4,800063c0 <pop_off+0x38>
    800063b0:	5d7c                	lw	a5,124(a0)
    800063b2:	c799                	beqz	a5,800063c0 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063b4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063b8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063bc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063c0:	60a2                	ld	ra,8(sp)
    800063c2:	6402                	ld	s0,0(sp)
    800063c4:	0141                	addi	sp,sp,16
    800063c6:	8082                	ret
    panic("pop_off - interruptible");
    800063c8:	00002517          	auipc	a0,0x2
    800063cc:	4f850513          	addi	a0,a0,1272 # 800088c0 <digits+0x28>
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	a2c080e7          	jalr	-1492(ra) # 80005dfc <panic>
    panic("pop_off");
    800063d8:	00002517          	auipc	a0,0x2
    800063dc:	50050513          	addi	a0,a0,1280 # 800088d8 <digits+0x40>
    800063e0:	00000097          	auipc	ra,0x0
    800063e4:	a1c080e7          	jalr	-1508(ra) # 80005dfc <panic>

00000000800063e8 <release>:
{
    800063e8:	1101                	addi	sp,sp,-32
    800063ea:	ec06                	sd	ra,24(sp)
    800063ec:	e822                	sd	s0,16(sp)
    800063ee:	e426                	sd	s1,8(sp)
    800063f0:	1000                	addi	s0,sp,32
    800063f2:	84aa                	mv	s1,a0
  if(!holding(lk))
    800063f4:	00000097          	auipc	ra,0x0
    800063f8:	ec6080e7          	jalr	-314(ra) # 800062ba <holding>
    800063fc:	c115                	beqz	a0,80006420 <release+0x38>
  lk->cpu = 0;
    800063fe:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006402:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006406:	0f50000f          	fence	iorw,ow
    8000640a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000640e:	00000097          	auipc	ra,0x0
    80006412:	f7a080e7          	jalr	-134(ra) # 80006388 <pop_off>
}
    80006416:	60e2                	ld	ra,24(sp)
    80006418:	6442                	ld	s0,16(sp)
    8000641a:	64a2                	ld	s1,8(sp)
    8000641c:	6105                	addi	sp,sp,32
    8000641e:	8082                	ret
    panic("release");
    80006420:	00002517          	auipc	a0,0x2
    80006424:	4c050513          	addi	a0,a0,1216 # 800088e0 <digits+0x48>
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	9d4080e7          	jalr	-1580(ra) # 80005dfc <panic>
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
