
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ae013103          	ld	sp,-1312(sp) # 80008ae0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	073050ef          	jal	ra,80005888 <start>

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
    80000034:	17078793          	addi	a5,a5,368 # 800221a0 <end>
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
    8000004c:	17e080e7          	jalr	382(ra) # 800001c6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	ae090913          	addi	s2,s2,-1312 # 80008b30 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	21a080e7          	jalr	538(ra) # 80006274 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2ba080e7          	jalr	698(ra) # 80006328 <release>
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
    8000008e:	cb2080e7          	jalr	-846(ra) # 80005d3c <panic>

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
    800000f2:	a4250513          	addi	a0,a0,-1470 # 80008b30 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	0ee080e7          	jalr	238(ra) # 800061e4 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00022517          	auipc	a0,0x22
    80000106:	09e50513          	addi	a0,a0,158 # 800221a0 <end>
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
    80000128:	a0c48493          	addi	s1,s1,-1524 # 80008b30 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	146080e7          	jalr	326(ra) # 80006274 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	9f450513          	addi	a0,a0,-1548 # 80008b30 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	1e2080e7          	jalr	482(ra) # 80006328 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	072080e7          	jalr	114(ra) # 800001c6 <memset>
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
    8000016c:	9c850513          	addi	a0,a0,-1592 # 80008b30 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	1b8080e7          	jalr	440(ra) # 80006328 <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <freememsize>:

// return the amount of free memory allocated (freemem)
int 
freememsize()
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  // loop on the memory free list and increment each time
  // by PGSIZE(4069) to get the amount of free memory
  struct run *freeptr;
  uint64 freemem = 0;
  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	9ac48493          	addi	s1,s1,-1620 # 80008b30 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	0e6080e7          	jalr	230(ra) # 80006274 <acquire>
  freeptr = kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while (freeptr) {
    80000198:	c78d                	beqz	a5,800001c2 <freememsize+0x48>
  uint64 freemem = 0;
    8000019a:	4481                	li	s1,0
    freemem += PGSIZE;
    8000019c:	6705                	lui	a4,0x1
    8000019e:	94ba                	add	s1,s1,a4
    freeptr = freeptr->next;
    800001a0:	639c                	ld	a5,0(a5)
  while (freeptr) {
    800001a2:	fff5                	bnez	a5,8000019e <freememsize+0x24>
  }
  release(&kmem.lock);
    800001a4:	00009517          	auipc	a0,0x9
    800001a8:	98c50513          	addi	a0,a0,-1652 # 80008b30 <kmem>
    800001ac:	00006097          	auipc	ra,0x6
    800001b0:	17c080e7          	jalr	380(ra) # 80006328 <release>
  return freemem;
    800001b4:	0004851b          	sext.w	a0,s1
    800001b8:	60e2                	ld	ra,24(sp)
    800001ba:	6442                	ld	s0,16(sp)
    800001bc:	64a2                	ld	s1,8(sp)
    800001be:	6105                	addi	sp,sp,32
    800001c0:	8082                	ret
  uint64 freemem = 0;
    800001c2:	4481                	li	s1,0
    800001c4:	b7c5                	j	800001a4 <freememsize+0x2a>

00000000800001c6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c6:	1141                	addi	sp,sp,-16
    800001c8:	e422                	sd	s0,8(sp)
    800001ca:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001cc:	ca19                	beqz	a2,800001e2 <memset+0x1c>
    800001ce:	87aa                	mv	a5,a0
    800001d0:	1602                	slli	a2,a2,0x20
    800001d2:	9201                	srli	a2,a2,0x20
    800001d4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001dc:	0785                	addi	a5,a5,1
    800001de:	fee79de3          	bne	a5,a4,800001d8 <memset+0x12>
  }
  return dst;
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret

00000000800001e8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e8:	1141                	addi	sp,sp,-16
    800001ea:	e422                	sd	s0,8(sp)
    800001ec:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ee:	ca05                	beqz	a2,8000021e <memcmp+0x36>
    800001f0:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f4:	1682                	slli	a3,a3,0x20
    800001f6:	9281                	srli	a3,a3,0x20
    800001f8:	0685                	addi	a3,a3,1
    800001fa:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fc:	00054783          	lbu	a5,0(a0)
    80000200:	0005c703          	lbu	a4,0(a1)
    80000204:	00e79863          	bne	a5,a4,80000214 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000208:	0505                	addi	a0,a0,1
    8000020a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020c:	fed518e3          	bne	a0,a3,800001fc <memcmp+0x14>
  }

  return 0;
    80000210:	4501                	li	a0,0
    80000212:	a019                	j	80000218 <memcmp+0x30>
      return *s1 - *s2;
    80000214:	40e7853b          	subw	a0,a5,a4
}
    80000218:	6422                	ld	s0,8(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret
  return 0;
    8000021e:	4501                	li	a0,0
    80000220:	bfe5                	j	80000218 <memcmp+0x30>

0000000080000222 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000222:	1141                	addi	sp,sp,-16
    80000224:	e422                	sd	s0,8(sp)
    80000226:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000228:	c205                	beqz	a2,80000248 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000022a:	02a5e263          	bltu	a1,a0,8000024e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022e:	1602                	slli	a2,a2,0x20
    80000230:	9201                	srli	a2,a2,0x20
    80000232:	00c587b3          	add	a5,a1,a2
{
    80000236:	872a                	mv	a4,a0
      *d++ = *s++;
    80000238:	0585                	addi	a1,a1,1
    8000023a:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000023c:	fff5c683          	lbu	a3,-1(a1)
    80000240:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000244:	fef59ae3          	bne	a1,a5,80000238 <memmove+0x16>

  return dst;
}
    80000248:	6422                	ld	s0,8(sp)
    8000024a:	0141                	addi	sp,sp,16
    8000024c:	8082                	ret
  if(s < d && s + n > d){
    8000024e:	02061693          	slli	a3,a2,0x20
    80000252:	9281                	srli	a3,a3,0x20
    80000254:	00d58733          	add	a4,a1,a3
    80000258:	fce57be3          	bgeu	a0,a4,8000022e <memmove+0xc>
    d += n;
    8000025c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025e:	fff6079b          	addiw	a5,a2,-1
    80000262:	1782                	slli	a5,a5,0x20
    80000264:	9381                	srli	a5,a5,0x20
    80000266:	fff7c793          	not	a5,a5
    8000026a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026c:	177d                	addi	a4,a4,-1
    8000026e:	16fd                	addi	a3,a3,-1
    80000270:	00074603          	lbu	a2,0(a4)
    80000274:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000278:	fee79ae3          	bne	a5,a4,8000026c <memmove+0x4a>
    8000027c:	b7f1                	j	80000248 <memmove+0x26>

000000008000027e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000286:	00000097          	auipc	ra,0x0
    8000028a:	f9c080e7          	jalr	-100(ra) # 80000222 <memmove>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret

0000000080000296 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000296:	1141                	addi	sp,sp,-16
    80000298:	e422                	sd	s0,8(sp)
    8000029a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029c:	ce11                	beqz	a2,800002b8 <strncmp+0x22>
    8000029e:	00054783          	lbu	a5,0(a0)
    800002a2:	cf89                	beqz	a5,800002bc <strncmp+0x26>
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	00f71a63          	bne	a4,a5,800002bc <strncmp+0x26>
    n--, p++, q++;
    800002ac:	367d                	addiw	a2,a2,-1
    800002ae:	0505                	addi	a0,a0,1
    800002b0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b2:	f675                	bnez	a2,8000029e <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b4:	4501                	li	a0,0
    800002b6:	a809                	j	800002c8 <strncmp+0x32>
    800002b8:	4501                	li	a0,0
    800002ba:	a039                	j	800002c8 <strncmp+0x32>
  if(n == 0)
    800002bc:	ca09                	beqz	a2,800002ce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002be:	00054503          	lbu	a0,0(a0)
    800002c2:	0005c783          	lbu	a5,0(a1)
    800002c6:	9d1d                	subw	a0,a0,a5
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret
    return 0;
    800002ce:	4501                	li	a0,0
    800002d0:	bfe5                	j	800002c8 <strncmp+0x32>

00000000800002d2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d2:	1141                	addi	sp,sp,-16
    800002d4:	e422                	sd	s0,8(sp)
    800002d6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d8:	872a                	mv	a4,a0
    800002da:	8832                	mv	a6,a2
    800002dc:	367d                	addiw	a2,a2,-1
    800002de:	01005963          	blez	a6,800002f0 <strncpy+0x1e>
    800002e2:	0705                	addi	a4,a4,1
    800002e4:	0005c783          	lbu	a5,0(a1)
    800002e8:	fef70fa3          	sb	a5,-1(a4)
    800002ec:	0585                	addi	a1,a1,1
    800002ee:	f7f5                	bnez	a5,800002da <strncpy+0x8>
    ;
  while(n-- > 0)
    800002f0:	86ba                	mv	a3,a4
    800002f2:	00c05c63          	blez	a2,8000030a <strncpy+0x38>
    *s++ = 0;
    800002f6:	0685                	addi	a3,a3,1
    800002f8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002fc:	40d707bb          	subw	a5,a4,a3
    80000300:	37fd                	addiw	a5,a5,-1
    80000302:	010787bb          	addw	a5,a5,a6
    80000306:	fef048e3          	bgtz	a5,800002f6 <strncpy+0x24>
  return os;
}
    8000030a:	6422                	ld	s0,8(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret

0000000080000310 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000310:	1141                	addi	sp,sp,-16
    80000312:	e422                	sd	s0,8(sp)
    80000314:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000316:	02c05363          	blez	a2,8000033c <safestrcpy+0x2c>
    8000031a:	fff6069b          	addiw	a3,a2,-1
    8000031e:	1682                	slli	a3,a3,0x20
    80000320:	9281                	srli	a3,a3,0x20
    80000322:	96ae                	add	a3,a3,a1
    80000324:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000326:	00d58963          	beq	a1,a3,80000338 <safestrcpy+0x28>
    8000032a:	0585                	addi	a1,a1,1
    8000032c:	0785                	addi	a5,a5,1
    8000032e:	fff5c703          	lbu	a4,-1(a1)
    80000332:	fee78fa3          	sb	a4,-1(a5)
    80000336:	fb65                	bnez	a4,80000326 <safestrcpy+0x16>
    ;
  *s = 0;
    80000338:	00078023          	sb	zero,0(a5)
  return os;
}
    8000033c:	6422                	ld	s0,8(sp)
    8000033e:	0141                	addi	sp,sp,16
    80000340:	8082                	ret

0000000080000342 <strlen>:

int
strlen(const char *s)
{
    80000342:	1141                	addi	sp,sp,-16
    80000344:	e422                	sd	s0,8(sp)
    80000346:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000348:	00054783          	lbu	a5,0(a0)
    8000034c:	cf91                	beqz	a5,80000368 <strlen+0x26>
    8000034e:	0505                	addi	a0,a0,1
    80000350:	87aa                	mv	a5,a0
    80000352:	4685                	li	a3,1
    80000354:	9e89                	subw	a3,a3,a0
    80000356:	00f6853b          	addw	a0,a3,a5
    8000035a:	0785                	addi	a5,a5,1
    8000035c:	fff7c703          	lbu	a4,-1(a5)
    80000360:	fb7d                	bnez	a4,80000356 <strlen+0x14>
    ;
  return n;
}
    80000362:	6422                	ld	s0,8(sp)
    80000364:	0141                	addi	sp,sp,16
    80000366:	8082                	ret
  for(n = 0; s[n]; n++)
    80000368:	4501                	li	a0,0
    8000036a:	bfe5                	j	80000362 <strlen+0x20>

000000008000036c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000036c:	1141                	addi	sp,sp,-16
    8000036e:	e406                	sd	ra,8(sp)
    80000370:	e022                	sd	s0,0(sp)
    80000372:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000374:	00001097          	auipc	ra,0x1
    80000378:	b02080e7          	jalr	-1278(ra) # 80000e76 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000037c:	00008717          	auipc	a4,0x8
    80000380:	78470713          	addi	a4,a4,1924 # 80008b00 <started>
  if(cpuid() == 0){
    80000384:	c139                	beqz	a0,800003ca <main+0x5e>
    while(started == 0)
    80000386:	431c                	lw	a5,0(a4)
    80000388:	2781                	sext.w	a5,a5
    8000038a:	dff5                	beqz	a5,80000386 <main+0x1a>
      ;
    __sync_synchronize();
    8000038c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000390:	00001097          	auipc	ra,0x1
    80000394:	ae6080e7          	jalr	-1306(ra) # 80000e76 <cpuid>
    80000398:	85aa                	mv	a1,a0
    8000039a:	00008517          	auipc	a0,0x8
    8000039e:	c9e50513          	addi	a0,a0,-866 # 80008038 <etext+0x38>
    800003a2:	00006097          	auipc	ra,0x6
    800003a6:	9e4080e7          	jalr	-1564(ra) # 80005d86 <printf>
    kvminithart();    // turn on paging
    800003aa:	00000097          	auipc	ra,0x0
    800003ae:	0d8080e7          	jalr	216(ra) # 80000482 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b2:	00002097          	auipc	ra,0x2
    800003b6:	81c080e7          	jalr	-2020(ra) # 80001bce <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003ba:	00005097          	auipc	ra,0x5
    800003be:	e86080e7          	jalr	-378(ra) # 80005240 <plicinithart>
  }

  scheduler();        
    800003c2:	00001097          	auipc	ra,0x1
    800003c6:	ff0080e7          	jalr	-16(ra) # 800013b2 <scheduler>
    consoleinit();
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	882080e7          	jalr	-1918(ra) # 80005c4c <consoleinit>
    printfinit();
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	b94080e7          	jalr	-1132(ra) # 80005f66 <printfinit>
    printf("\n");
    800003da:	00008517          	auipc	a0,0x8
    800003de:	c6e50513          	addi	a0,a0,-914 # 80008048 <etext+0x48>
    800003e2:	00006097          	auipc	ra,0x6
    800003e6:	9a4080e7          	jalr	-1628(ra) # 80005d86 <printf>
    printf("xv6 kernel is booting\n");
    800003ea:	00008517          	auipc	a0,0x8
    800003ee:	c3650513          	addi	a0,a0,-970 # 80008020 <etext+0x20>
    800003f2:	00006097          	auipc	ra,0x6
    800003f6:	994080e7          	jalr	-1644(ra) # 80005d86 <printf>
    printf("\n");
    800003fa:	00008517          	auipc	a0,0x8
    800003fe:	c4e50513          	addi	a0,a0,-946 # 80008048 <etext+0x48>
    80000402:	00006097          	auipc	ra,0x6
    80000406:	984080e7          	jalr	-1660(ra) # 80005d86 <printf>
    kinit();         // physical page allocator
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	cd4080e7          	jalr	-812(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000412:	00000097          	auipc	ra,0x0
    80000416:	326080e7          	jalr	806(ra) # 80000738 <kvminit>
    kvminithart();   // turn on paging
    8000041a:	00000097          	auipc	ra,0x0
    8000041e:	068080e7          	jalr	104(ra) # 80000482 <kvminithart>
    procinit();      // process table
    80000422:	00001097          	auipc	ra,0x1
    80000426:	99e080e7          	jalr	-1634(ra) # 80000dc0 <procinit>
    trapinit();      // trap vectors
    8000042a:	00001097          	auipc	ra,0x1
    8000042e:	77c080e7          	jalr	1916(ra) # 80001ba6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000432:	00001097          	auipc	ra,0x1
    80000436:	79c080e7          	jalr	1948(ra) # 80001bce <trapinithart>
    plicinit();      // set up interrupt controller
    8000043a:	00005097          	auipc	ra,0x5
    8000043e:	df0080e7          	jalr	-528(ra) # 8000522a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000442:	00005097          	auipc	ra,0x5
    80000446:	dfe080e7          	jalr	-514(ra) # 80005240 <plicinithart>
    binit();         // buffer cache
    8000044a:	00002097          	auipc	ra,0x2
    8000044e:	f92080e7          	jalr	-110(ra) # 800023dc <binit>
    iinit();         // inode table
    80000452:	00002097          	auipc	ra,0x2
    80000456:	632080e7          	jalr	1586(ra) # 80002a84 <iinit>
    fileinit();      // file table
    8000045a:	00003097          	auipc	ra,0x3
    8000045e:	5d8080e7          	jalr	1496(ra) # 80003a32 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000462:	00005097          	auipc	ra,0x5
    80000466:	ee6080e7          	jalr	-282(ra) # 80005348 <virtio_disk_init>
    userinit();      // first user process
    8000046a:	00001097          	auipc	ra,0x1
    8000046e:	d1a080e7          	jalr	-742(ra) # 80001184 <userinit>
    __sync_synchronize();
    80000472:	0ff0000f          	fence
    started = 1;
    80000476:	4785                	li	a5,1
    80000478:	00008717          	auipc	a4,0x8
    8000047c:	68f72423          	sw	a5,1672(a4) # 80008b00 <started>
    80000480:	b789                	j	800003c2 <main+0x56>

0000000080000482 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000482:	1141                	addi	sp,sp,-16
    80000484:	e422                	sd	s0,8(sp)
    80000486:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000488:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000048c:	00008797          	auipc	a5,0x8
    80000490:	67c7b783          	ld	a5,1660(a5) # 80008b08 <kernel_pagetable>
    80000494:	83b1                	srli	a5,a5,0xc
    80000496:	577d                	li	a4,-1
    80000498:	177e                	slli	a4,a4,0x3f
    8000049a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000049c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004a0:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004a4:	6422                	ld	s0,8(sp)
    800004a6:	0141                	addi	sp,sp,16
    800004a8:	8082                	ret

00000000800004aa <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004aa:	7139                	addi	sp,sp,-64
    800004ac:	fc06                	sd	ra,56(sp)
    800004ae:	f822                	sd	s0,48(sp)
    800004b0:	f426                	sd	s1,40(sp)
    800004b2:	f04a                	sd	s2,32(sp)
    800004b4:	ec4e                	sd	s3,24(sp)
    800004b6:	e852                	sd	s4,16(sp)
    800004b8:	e456                	sd	s5,8(sp)
    800004ba:	e05a                	sd	s6,0(sp)
    800004bc:	0080                	addi	s0,sp,64
    800004be:	84aa                	mv	s1,a0
    800004c0:	89ae                	mv	s3,a1
    800004c2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004c4:	57fd                	li	a5,-1
    800004c6:	83e9                	srli	a5,a5,0x1a
    800004c8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004ca:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004cc:	04b7f263          	bgeu	a5,a1,80000510 <walk+0x66>
    panic("walk");
    800004d0:	00008517          	auipc	a0,0x8
    800004d4:	b8050513          	addi	a0,a0,-1152 # 80008050 <etext+0x50>
    800004d8:	00006097          	auipc	ra,0x6
    800004dc:	864080e7          	jalr	-1948(ra) # 80005d3c <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004e0:	060a8663          	beqz	s5,8000054c <walk+0xa2>
    800004e4:	00000097          	auipc	ra,0x0
    800004e8:	c36080e7          	jalr	-970(ra) # 8000011a <kalloc>
    800004ec:	84aa                	mv	s1,a0
    800004ee:	c529                	beqz	a0,80000538 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004f0:	6605                	lui	a2,0x1
    800004f2:	4581                	li	a1,0
    800004f4:	00000097          	auipc	ra,0x0
    800004f8:	cd2080e7          	jalr	-814(ra) # 800001c6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004fc:	00c4d793          	srli	a5,s1,0xc
    80000500:	07aa                	slli	a5,a5,0xa
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    8000050a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdce57>
    8000050c:	036a0063          	beq	s4,s6,8000052c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    80000510:	0149d933          	srl	s2,s3,s4
    80000514:	1ff97913          	andi	s2,s2,511
    80000518:	090e                	slli	s2,s2,0x3
    8000051a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000051c:	00093483          	ld	s1,0(s2)
    80000520:	0014f793          	andi	a5,s1,1
    80000524:	dfd5                	beqz	a5,800004e0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000526:	80a9                	srli	s1,s1,0xa
    80000528:	04b2                	slli	s1,s1,0xc
    8000052a:	b7c5                	j	8000050a <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000052c:	00c9d513          	srli	a0,s3,0xc
    80000530:	1ff57513          	andi	a0,a0,511
    80000534:	050e                	slli	a0,a0,0x3
    80000536:	9526                	add	a0,a0,s1
}
    80000538:	70e2                	ld	ra,56(sp)
    8000053a:	7442                	ld	s0,48(sp)
    8000053c:	74a2                	ld	s1,40(sp)
    8000053e:	7902                	ld	s2,32(sp)
    80000540:	69e2                	ld	s3,24(sp)
    80000542:	6a42                	ld	s4,16(sp)
    80000544:	6aa2                	ld	s5,8(sp)
    80000546:	6b02                	ld	s6,0(sp)
    80000548:	6121                	addi	sp,sp,64
    8000054a:	8082                	ret
        return 0;
    8000054c:	4501                	li	a0,0
    8000054e:	b7ed                	j	80000538 <walk+0x8e>

0000000080000550 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000550:	57fd                	li	a5,-1
    80000552:	83e9                	srli	a5,a5,0x1a
    80000554:	00b7f463          	bgeu	a5,a1,8000055c <walkaddr+0xc>
    return 0;
    80000558:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055a:	8082                	ret
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000564:	4601                	li	a2,0
    80000566:	00000097          	auipc	ra,0x0
    8000056a:	f44080e7          	jalr	-188(ra) # 800004aa <walk>
  if(pte == 0)
    8000056e:	c105                	beqz	a0,8000058e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x36>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	83a9                	srli	a5,a5,0xa
    80000588:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2e>
    return 0;
    8000058e:	4501                	li	a0,0
    80000590:	b7fd                	j	8000057e <walkaddr+0x2e>

0000000080000592 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000592:	715d                	addi	sp,sp,-80
    80000594:	e486                	sd	ra,72(sp)
    80000596:	e0a2                	sd	s0,64(sp)
    80000598:	fc26                	sd	s1,56(sp)
    8000059a:	f84a                	sd	s2,48(sp)
    8000059c:	f44e                	sd	s3,40(sp)
    8000059e:	f052                	sd	s4,32(sp)
    800005a0:	ec56                	sd	s5,24(sp)
    800005a2:	e85a                	sd	s6,16(sp)
    800005a4:	e45e                	sd	s7,8(sp)
    800005a6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a8:	c639                	beqz	a2,800005f6 <mappages+0x64>
    800005aa:	8aaa                	mv	s5,a0
    800005ac:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005ae:	777d                	lui	a4,0xfffff
    800005b0:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005b4:	fff58993          	addi	s3,a1,-1
    800005b8:	99b2                	add	s3,s3,a2
    800005ba:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005be:	893e                	mv	s2,a5
    800005c0:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005c4:	6b85                	lui	s7,0x1
    800005c6:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ca:	4605                	li	a2,1
    800005cc:	85ca                	mv	a1,s2
    800005ce:	8556                	mv	a0,s5
    800005d0:	00000097          	auipc	ra,0x0
    800005d4:	eda080e7          	jalr	-294(ra) # 800004aa <walk>
    800005d8:	cd1d                	beqz	a0,80000616 <mappages+0x84>
    if(*pte & PTE_V)
    800005da:	611c                	ld	a5,0(a0)
    800005dc:	8b85                	andi	a5,a5,1
    800005de:	e785                	bnez	a5,80000606 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e0:	80b1                	srli	s1,s1,0xc
    800005e2:	04aa                	slli	s1,s1,0xa
    800005e4:	0164e4b3          	or	s1,s1,s6
    800005e8:	0014e493          	ori	s1,s1,1
    800005ec:	e104                	sd	s1,0(a0)
    if(a == last)
    800005ee:	05390063          	beq	s2,s3,8000062e <mappages+0x9c>
    a += PGSIZE;
    800005f2:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f4:	bfc9                	j	800005c6 <mappages+0x34>
    panic("mappages: size");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a6250513          	addi	a0,a0,-1438 # 80008058 <etext+0x58>
    800005fe:	00005097          	auipc	ra,0x5
    80000602:	73e080e7          	jalr	1854(ra) # 80005d3c <panic>
      panic("mappages: remap");
    80000606:	00008517          	auipc	a0,0x8
    8000060a:	a6250513          	addi	a0,a0,-1438 # 80008068 <etext+0x68>
    8000060e:	00005097          	auipc	ra,0x5
    80000612:	72e080e7          	jalr	1838(ra) # 80005d3c <panic>
      return -1;
    80000616:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000618:	60a6                	ld	ra,72(sp)
    8000061a:	6406                	ld	s0,64(sp)
    8000061c:	74e2                	ld	s1,56(sp)
    8000061e:	7942                	ld	s2,48(sp)
    80000620:	79a2                	ld	s3,40(sp)
    80000622:	7a02                	ld	s4,32(sp)
    80000624:	6ae2                	ld	s5,24(sp)
    80000626:	6b42                	ld	s6,16(sp)
    80000628:	6ba2                	ld	s7,8(sp)
    8000062a:	6161                	addi	sp,sp,80
    8000062c:	8082                	ret
  return 0;
    8000062e:	4501                	li	a0,0
    80000630:	b7e5                	j	80000618 <mappages+0x86>

0000000080000632 <kvmmap>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
    8000063a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000063c:	86b2                	mv	a3,a2
    8000063e:	863e                	mv	a2,a5
    80000640:	00000097          	auipc	ra,0x0
    80000644:	f52080e7          	jalr	-174(ra) # 80000592 <mappages>
    80000648:	e509                	bnez	a0,80000652 <kvmmap+0x20>
}
    8000064a:	60a2                	ld	ra,8(sp)
    8000064c:	6402                	ld	s0,0(sp)
    8000064e:	0141                	addi	sp,sp,16
    80000650:	8082                	ret
    panic("kvmmap");
    80000652:	00008517          	auipc	a0,0x8
    80000656:	a2650513          	addi	a0,a0,-1498 # 80008078 <etext+0x78>
    8000065a:	00005097          	auipc	ra,0x5
    8000065e:	6e2080e7          	jalr	1762(ra) # 80005d3c <panic>

0000000080000662 <kvmmake>:
{
    80000662:	1101                	addi	sp,sp,-32
    80000664:	ec06                	sd	ra,24(sp)
    80000666:	e822                	sd	s0,16(sp)
    80000668:	e426                	sd	s1,8(sp)
    8000066a:	e04a                	sd	s2,0(sp)
    8000066c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000066e:	00000097          	auipc	ra,0x0
    80000672:	aac080e7          	jalr	-1364(ra) # 8000011a <kalloc>
    80000676:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000678:	6605                	lui	a2,0x1
    8000067a:	4581                	li	a1,0
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	b4a080e7          	jalr	-1206(ra) # 800001c6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	100005b7          	lui	a1,0x10000
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	fa0080e7          	jalr	-96(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	6685                	lui	a3,0x1
    8000069e:	10001637          	lui	a2,0x10001
    800006a2:	100015b7          	lui	a1,0x10001
    800006a6:	8526                	mv	a0,s1
    800006a8:	00000097          	auipc	ra,0x0
    800006ac:	f8a080e7          	jalr	-118(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006b0:	4719                	li	a4,6
    800006b2:	004006b7          	lui	a3,0x400
    800006b6:	0c000637          	lui	a2,0xc000
    800006ba:	0c0005b7          	lui	a1,0xc000
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f72080e7          	jalr	-142(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c8:	00008917          	auipc	s2,0x8
    800006cc:	93890913          	addi	s2,s2,-1736 # 80008000 <etext>
    800006d0:	4729                	li	a4,10
    800006d2:	80008697          	auipc	a3,0x80008
    800006d6:	92e68693          	addi	a3,a3,-1746 # 8000 <_entry-0x7fff8000>
    800006da:	4605                	li	a2,1
    800006dc:	067e                	slli	a2,a2,0x1f
    800006de:	85b2                	mv	a1,a2
    800006e0:	8526                	mv	a0,s1
    800006e2:	00000097          	auipc	ra,0x0
    800006e6:	f50080e7          	jalr	-176(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ea:	4719                	li	a4,6
    800006ec:	46c5                	li	a3,17
    800006ee:	06ee                	slli	a3,a3,0x1b
    800006f0:	412686b3          	sub	a3,a3,s2
    800006f4:	864a                	mv	a2,s2
    800006f6:	85ca                	mv	a1,s2
    800006f8:	8526                	mv	a0,s1
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f38080e7          	jalr	-200(ra) # 80000632 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000702:	4729                	li	a4,10
    80000704:	6685                	lui	a3,0x1
    80000706:	00007617          	auipc	a2,0x7
    8000070a:	8fa60613          	addi	a2,a2,-1798 # 80007000 <_trampoline>
    8000070e:	040005b7          	lui	a1,0x4000
    80000712:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000714:	05b2                	slli	a1,a1,0xc
    80000716:	8526                	mv	a0,s1
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	f1a080e7          	jalr	-230(ra) # 80000632 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000720:	8526                	mv	a0,s1
    80000722:	00000097          	auipc	ra,0x0
    80000726:	608080e7          	jalr	1544(ra) # 80000d2a <proc_mapstacks>
}
    8000072a:	8526                	mv	a0,s1
    8000072c:	60e2                	ld	ra,24(sp)
    8000072e:	6442                	ld	s0,16(sp)
    80000730:	64a2                	ld	s1,8(sp)
    80000732:	6902                	ld	s2,0(sp)
    80000734:	6105                	addi	sp,sp,32
    80000736:	8082                	ret

0000000080000738 <kvminit>:
{
    80000738:	1141                	addi	sp,sp,-16
    8000073a:	e406                	sd	ra,8(sp)
    8000073c:	e022                	sd	s0,0(sp)
    8000073e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f22080e7          	jalr	-222(ra) # 80000662 <kvmmake>
    80000748:	00008797          	auipc	a5,0x8
    8000074c:	3ca7b023          	sd	a0,960(a5) # 80008b08 <kernel_pagetable>
}
    80000750:	60a2                	ld	ra,8(sp)
    80000752:	6402                	ld	s0,0(sp)
    80000754:	0141                	addi	sp,sp,16
    80000756:	8082                	ret

0000000080000758 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000758:	715d                	addi	sp,sp,-80
    8000075a:	e486                	sd	ra,72(sp)
    8000075c:	e0a2                	sd	s0,64(sp)
    8000075e:	fc26                	sd	s1,56(sp)
    80000760:	f84a                	sd	s2,48(sp)
    80000762:	f44e                	sd	s3,40(sp)
    80000764:	f052                	sd	s4,32(sp)
    80000766:	ec56                	sd	s5,24(sp)
    80000768:	e85a                	sd	s6,16(sp)
    8000076a:	e45e                	sd	s7,8(sp)
    8000076c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000076e:	03459793          	slli	a5,a1,0x34
    80000772:	e795                	bnez	a5,8000079e <uvmunmap+0x46>
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000780:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000782:	6b05                	lui	s6,0x1
    80000784:	0735e263          	bltu	a1,s3,800007e8 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000788:	60a6                	ld	ra,72(sp)
    8000078a:	6406                	ld	s0,64(sp)
    8000078c:	74e2                	ld	s1,56(sp)
    8000078e:	7942                	ld	s2,48(sp)
    80000790:	79a2                	ld	s3,40(sp)
    80000792:	7a02                	ld	s4,32(sp)
    80000794:	6ae2                	ld	s5,24(sp)
    80000796:	6b42                	ld	s6,16(sp)
    80000798:	6ba2                	ld	s7,8(sp)
    8000079a:	6161                	addi	sp,sp,80
    8000079c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	8e250513          	addi	a0,a0,-1822 # 80008080 <etext+0x80>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	596080e7          	jalr	1430(ra) # 80005d3c <panic>
      panic("uvmunmap: walk");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	8ea50513          	addi	a0,a0,-1814 # 80008098 <etext+0x98>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	586080e7          	jalr	1414(ra) # 80005d3c <panic>
      panic("uvmunmap: not mapped");
    800007be:	00008517          	auipc	a0,0x8
    800007c2:	8ea50513          	addi	a0,a0,-1814 # 800080a8 <etext+0xa8>
    800007c6:	00005097          	auipc	ra,0x5
    800007ca:	576080e7          	jalr	1398(ra) # 80005d3c <panic>
      panic("uvmunmap: not a leaf");
    800007ce:	00008517          	auipc	a0,0x8
    800007d2:	8f250513          	addi	a0,a0,-1806 # 800080c0 <etext+0xc0>
    800007d6:	00005097          	auipc	ra,0x5
    800007da:	566080e7          	jalr	1382(ra) # 80005d3c <panic>
    *pte = 0;
    800007de:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007e2:	995a                	add	s2,s2,s6
    800007e4:	fb3972e3          	bgeu	s2,s3,80000788 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e8:	4601                	li	a2,0
    800007ea:	85ca                	mv	a1,s2
    800007ec:	8552                	mv	a0,s4
    800007ee:	00000097          	auipc	ra,0x0
    800007f2:	cbc080e7          	jalr	-836(ra) # 800004aa <walk>
    800007f6:	84aa                	mv	s1,a0
    800007f8:	d95d                	beqz	a0,800007ae <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007fa:	6108                	ld	a0,0(a0)
    800007fc:	00157793          	andi	a5,a0,1
    80000800:	dfdd                	beqz	a5,800007be <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000802:	3ff57793          	andi	a5,a0,1023
    80000806:	fd7784e3          	beq	a5,s7,800007ce <uvmunmap+0x76>
    if(do_free){
    8000080a:	fc0a8ae3          	beqz	s5,800007de <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    8000080e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000810:	0532                	slli	a0,a0,0xc
    80000812:	00000097          	auipc	ra,0x0
    80000816:	80a080e7          	jalr	-2038(ra) # 8000001c <kfree>
    8000081a:	b7d1                	j	800007de <uvmunmap+0x86>

000000008000081c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000081c:	1101                	addi	sp,sp,-32
    8000081e:	ec06                	sd	ra,24(sp)
    80000820:	e822                	sd	s0,16(sp)
    80000822:	e426                	sd	s1,8(sp)
    80000824:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000826:	00000097          	auipc	ra,0x0
    8000082a:	8f4080e7          	jalr	-1804(ra) # 8000011a <kalloc>
    8000082e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000830:	c519                	beqz	a0,8000083e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000832:	6605                	lui	a2,0x1
    80000834:	4581                	li	a1,0
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	990080e7          	jalr	-1648(ra) # 800001c6 <memset>
  return pagetable;
}
    8000083e:	8526                	mv	a0,s1
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000084a:	7179                	addi	sp,sp,-48
    8000084c:	f406                	sd	ra,40(sp)
    8000084e:	f022                	sd	s0,32(sp)
    80000850:	ec26                	sd	s1,24(sp)
    80000852:	e84a                	sd	s2,16(sp)
    80000854:	e44e                	sd	s3,8(sp)
    80000856:	e052                	sd	s4,0(sp)
    80000858:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000085a:	6785                	lui	a5,0x1
    8000085c:	04f67863          	bgeu	a2,a5,800008ac <uvmfirst+0x62>
    80000860:	8a2a                	mv	s4,a0
    80000862:	89ae                	mv	s3,a1
    80000864:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	8b4080e7          	jalr	-1868(ra) # 8000011a <kalloc>
    8000086e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000870:	6605                	lui	a2,0x1
    80000872:	4581                	li	a1,0
    80000874:	00000097          	auipc	ra,0x0
    80000878:	952080e7          	jalr	-1710(ra) # 800001c6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000087c:	4779                	li	a4,30
    8000087e:	86ca                	mv	a3,s2
    80000880:	6605                	lui	a2,0x1
    80000882:	4581                	li	a1,0
    80000884:	8552                	mv	a0,s4
    80000886:	00000097          	auipc	ra,0x0
    8000088a:	d0c080e7          	jalr	-756(ra) # 80000592 <mappages>
  memmove(mem, src, sz);
    8000088e:	8626                	mv	a2,s1
    80000890:	85ce                	mv	a1,s3
    80000892:	854a                	mv	a0,s2
    80000894:	00000097          	auipc	ra,0x0
    80000898:	98e080e7          	jalr	-1650(ra) # 80000222 <memmove>
}
    8000089c:	70a2                	ld	ra,40(sp)
    8000089e:	7402                	ld	s0,32(sp)
    800008a0:	64e2                	ld	s1,24(sp)
    800008a2:	6942                	ld	s2,16(sp)
    800008a4:	69a2                	ld	s3,8(sp)
    800008a6:	6a02                	ld	s4,0(sp)
    800008a8:	6145                	addi	sp,sp,48
    800008aa:	8082                	ret
    panic("uvmfirst: more than a page");
    800008ac:	00008517          	auipc	a0,0x8
    800008b0:	82c50513          	addi	a0,a0,-2004 # 800080d8 <etext+0xd8>
    800008b4:	00005097          	auipc	ra,0x5
    800008b8:	488080e7          	jalr	1160(ra) # 80005d3c <panic>

00000000800008bc <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008bc:	1101                	addi	sp,sp,-32
    800008be:	ec06                	sd	ra,24(sp)
    800008c0:	e822                	sd	s0,16(sp)
    800008c2:	e426                	sd	s1,8(sp)
    800008c4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c8:	00b67d63          	bgeu	a2,a1,800008e2 <uvmdealloc+0x26>
    800008cc:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ce:	6785                	lui	a5,0x1
    800008d0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d2:	00f60733          	add	a4,a2,a5
    800008d6:	76fd                	lui	a3,0xfffff
    800008d8:	8f75                	and	a4,a4,a3
    800008da:	97ae                	add	a5,a5,a1
    800008dc:	8ff5                	and	a5,a5,a3
    800008de:	00f76863          	bltu	a4,a5,800008ee <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008e2:	8526                	mv	a0,s1
    800008e4:	60e2                	ld	ra,24(sp)
    800008e6:	6442                	ld	s0,16(sp)
    800008e8:	64a2                	ld	s1,8(sp)
    800008ea:	6105                	addi	sp,sp,32
    800008ec:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ee:	8f99                	sub	a5,a5,a4
    800008f0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008f2:	4685                	li	a3,1
    800008f4:	0007861b          	sext.w	a2,a5
    800008f8:	85ba                	mv	a1,a4
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	e5e080e7          	jalr	-418(ra) # 80000758 <uvmunmap>
    80000902:	b7c5                	j	800008e2 <uvmdealloc+0x26>

0000000080000904 <uvmalloc>:
  if(newsz < oldsz)
    80000904:	0ab66563          	bltu	a2,a1,800009ae <uvmalloc+0xaa>
{
    80000908:	7139                	addi	sp,sp,-64
    8000090a:	fc06                	sd	ra,56(sp)
    8000090c:	f822                	sd	s0,48(sp)
    8000090e:	f426                	sd	s1,40(sp)
    80000910:	f04a                	sd	s2,32(sp)
    80000912:	ec4e                	sd	s3,24(sp)
    80000914:	e852                	sd	s4,16(sp)
    80000916:	e456                	sd	s5,8(sp)
    80000918:	e05a                	sd	s6,0(sp)
    8000091a:	0080                	addi	s0,sp,64
    8000091c:	8aaa                	mv	s5,a0
    8000091e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000920:	6785                	lui	a5,0x1
    80000922:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000924:	95be                	add	a1,a1,a5
    80000926:	77fd                	lui	a5,0xfffff
    80000928:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000092c:	08c9f363          	bgeu	s3,a2,800009b2 <uvmalloc+0xae>
    80000930:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000932:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000936:	fffff097          	auipc	ra,0xfffff
    8000093a:	7e4080e7          	jalr	2020(ra) # 8000011a <kalloc>
    8000093e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000940:	c51d                	beqz	a0,8000096e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000942:	6605                	lui	a2,0x1
    80000944:	4581                	li	a1,0
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	880080e7          	jalr	-1920(ra) # 800001c6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000094e:	875a                	mv	a4,s6
    80000950:	86a6                	mv	a3,s1
    80000952:	6605                	lui	a2,0x1
    80000954:	85ca                	mv	a1,s2
    80000956:	8556                	mv	a0,s5
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	c3a080e7          	jalr	-966(ra) # 80000592 <mappages>
    80000960:	e90d                	bnez	a0,80000992 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000962:	6785                	lui	a5,0x1
    80000964:	993e                	add	s2,s2,a5
    80000966:	fd4968e3          	bltu	s2,s4,80000936 <uvmalloc+0x32>
  return newsz;
    8000096a:	8552                	mv	a0,s4
    8000096c:	a809                	j	8000097e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000096e:	864e                	mv	a2,s3
    80000970:	85ca                	mv	a1,s2
    80000972:	8556                	mv	a0,s5
    80000974:	00000097          	auipc	ra,0x0
    80000978:	f48080e7          	jalr	-184(ra) # 800008bc <uvmdealloc>
      return 0;
    8000097c:	4501                	li	a0,0
}
    8000097e:	70e2                	ld	ra,56(sp)
    80000980:	7442                	ld	s0,48(sp)
    80000982:	74a2                	ld	s1,40(sp)
    80000984:	7902                	ld	s2,32(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6b02                	ld	s6,0(sp)
    8000098e:	6121                	addi	sp,sp,64
    80000990:	8082                	ret
      kfree(mem);
    80000992:	8526                	mv	a0,s1
    80000994:	fffff097          	auipc	ra,0xfffff
    80000998:	688080e7          	jalr	1672(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000099c:	864e                	mv	a2,s3
    8000099e:	85ca                	mv	a1,s2
    800009a0:	8556                	mv	a0,s5
    800009a2:	00000097          	auipc	ra,0x0
    800009a6:	f1a080e7          	jalr	-230(ra) # 800008bc <uvmdealloc>
      return 0;
    800009aa:	4501                	li	a0,0
    800009ac:	bfc9                	j	8000097e <uvmalloc+0x7a>
    return oldsz;
    800009ae:	852e                	mv	a0,a1
}
    800009b0:	8082                	ret
  return newsz;
    800009b2:	8532                	mv	a0,a2
    800009b4:	b7e9                	j	8000097e <uvmalloc+0x7a>

00000000800009b6 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009b6:	7179                	addi	sp,sp,-48
    800009b8:	f406                	sd	ra,40(sp)
    800009ba:	f022                	sd	s0,32(sp)
    800009bc:	ec26                	sd	s1,24(sp)
    800009be:	e84a                	sd	s2,16(sp)
    800009c0:	e44e                	sd	s3,8(sp)
    800009c2:	e052                	sd	s4,0(sp)
    800009c4:	1800                	addi	s0,sp,48
    800009c6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009c8:	84aa                	mv	s1,a0
    800009ca:	6905                	lui	s2,0x1
    800009cc:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ce:	4985                	li	s3,1
    800009d0:	a829                	j	800009ea <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009d2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009d4:	00c79513          	slli	a0,a5,0xc
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	fde080e7          	jalr	-34(ra) # 800009b6 <freewalk>
      pagetable[i] = 0;
    800009e0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009e4:	04a1                	addi	s1,s1,8
    800009e6:	03248163          	beq	s1,s2,80000a08 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009ea:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ec:	00f7f713          	andi	a4,a5,15
    800009f0:	ff3701e3          	beq	a4,s3,800009d2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009f4:	8b85                	andi	a5,a5,1
    800009f6:	d7fd                	beqz	a5,800009e4 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009f8:	00007517          	auipc	a0,0x7
    800009fc:	70050513          	addi	a0,a0,1792 # 800080f8 <etext+0xf8>
    80000a00:	00005097          	auipc	ra,0x5
    80000a04:	33c080e7          	jalr	828(ra) # 80005d3c <panic>
    }
  }
  kfree((void*)pagetable);
    80000a08:	8552                	mv	a0,s4
    80000a0a:	fffff097          	auipc	ra,0xfffff
    80000a0e:	612080e7          	jalr	1554(ra) # 8000001c <kfree>
}
    80000a12:	70a2                	ld	ra,40(sp)
    80000a14:	7402                	ld	s0,32(sp)
    80000a16:	64e2                	ld	s1,24(sp)
    80000a18:	6942                	ld	s2,16(sp)
    80000a1a:	69a2                	ld	s3,8(sp)
    80000a1c:	6a02                	ld	s4,0(sp)
    80000a1e:	6145                	addi	sp,sp,48
    80000a20:	8082                	ret

0000000080000a22 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a22:	1101                	addi	sp,sp,-32
    80000a24:	ec06                	sd	ra,24(sp)
    80000a26:	e822                	sd	s0,16(sp)
    80000a28:	e426                	sd	s1,8(sp)
    80000a2a:	1000                	addi	s0,sp,32
    80000a2c:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a2e:	e999                	bnez	a1,80000a44 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a30:	8526                	mv	a0,s1
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	f84080e7          	jalr	-124(ra) # 800009b6 <freewalk>
}
    80000a3a:	60e2                	ld	ra,24(sp)
    80000a3c:	6442                	ld	s0,16(sp)
    80000a3e:	64a2                	ld	s1,8(sp)
    80000a40:	6105                	addi	sp,sp,32
    80000a42:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a44:	6785                	lui	a5,0x1
    80000a46:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a48:	95be                	add	a1,a1,a5
    80000a4a:	4685                	li	a3,1
    80000a4c:	00c5d613          	srli	a2,a1,0xc
    80000a50:	4581                	li	a1,0
    80000a52:	00000097          	auipc	ra,0x0
    80000a56:	d06080e7          	jalr	-762(ra) # 80000758 <uvmunmap>
    80000a5a:	bfd9                	j	80000a30 <uvmfree+0xe>

0000000080000a5c <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a5c:	c679                	beqz	a2,80000b2a <uvmcopy+0xce>
{
    80000a5e:	715d                	addi	sp,sp,-80
    80000a60:	e486                	sd	ra,72(sp)
    80000a62:	e0a2                	sd	s0,64(sp)
    80000a64:	fc26                	sd	s1,56(sp)
    80000a66:	f84a                	sd	s2,48(sp)
    80000a68:	f44e                	sd	s3,40(sp)
    80000a6a:	f052                	sd	s4,32(sp)
    80000a6c:	ec56                	sd	s5,24(sp)
    80000a6e:	e85a                	sd	s6,16(sp)
    80000a70:	e45e                	sd	s7,8(sp)
    80000a72:	0880                	addi	s0,sp,80
    80000a74:	8b2a                	mv	s6,a0
    80000a76:	8aae                	mv	s5,a1
    80000a78:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a7a:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a7c:	4601                	li	a2,0
    80000a7e:	85ce                	mv	a1,s3
    80000a80:	855a                	mv	a0,s6
    80000a82:	00000097          	auipc	ra,0x0
    80000a86:	a28080e7          	jalr	-1496(ra) # 800004aa <walk>
    80000a8a:	c531                	beqz	a0,80000ad6 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a8c:	6118                	ld	a4,0(a0)
    80000a8e:	00177793          	andi	a5,a4,1
    80000a92:	cbb1                	beqz	a5,80000ae6 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a94:	00a75593          	srli	a1,a4,0xa
    80000a98:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a9c:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000aa0:	fffff097          	auipc	ra,0xfffff
    80000aa4:	67a080e7          	jalr	1658(ra) # 8000011a <kalloc>
    80000aa8:	892a                	mv	s2,a0
    80000aaa:	c939                	beqz	a0,80000b00 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000aac:	6605                	lui	a2,0x1
    80000aae:	85de                	mv	a1,s7
    80000ab0:	fffff097          	auipc	ra,0xfffff
    80000ab4:	772080e7          	jalr	1906(ra) # 80000222 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000ab8:	8726                	mv	a4,s1
    80000aba:	86ca                	mv	a3,s2
    80000abc:	6605                	lui	a2,0x1
    80000abe:	85ce                	mv	a1,s3
    80000ac0:	8556                	mv	a0,s5
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	ad0080e7          	jalr	-1328(ra) # 80000592 <mappages>
    80000aca:	e515                	bnez	a0,80000af6 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000acc:	6785                	lui	a5,0x1
    80000ace:	99be                	add	s3,s3,a5
    80000ad0:	fb49e6e3          	bltu	s3,s4,80000a7c <uvmcopy+0x20>
    80000ad4:	a081                	j	80000b14 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ad6:	00007517          	auipc	a0,0x7
    80000ada:	63250513          	addi	a0,a0,1586 # 80008108 <etext+0x108>
    80000ade:	00005097          	auipc	ra,0x5
    80000ae2:	25e080e7          	jalr	606(ra) # 80005d3c <panic>
      panic("uvmcopy: page not present");
    80000ae6:	00007517          	auipc	a0,0x7
    80000aea:	64250513          	addi	a0,a0,1602 # 80008128 <etext+0x128>
    80000aee:	00005097          	auipc	ra,0x5
    80000af2:	24e080e7          	jalr	590(ra) # 80005d3c <panic>
      kfree(mem);
    80000af6:	854a                	mv	a0,s2
    80000af8:	fffff097          	auipc	ra,0xfffff
    80000afc:	524080e7          	jalr	1316(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b00:	4685                	li	a3,1
    80000b02:	00c9d613          	srli	a2,s3,0xc
    80000b06:	4581                	li	a1,0
    80000b08:	8556                	mv	a0,s5
    80000b0a:	00000097          	auipc	ra,0x0
    80000b0e:	c4e080e7          	jalr	-946(ra) # 80000758 <uvmunmap>
  return -1;
    80000b12:	557d                	li	a0,-1
}
    80000b14:	60a6                	ld	ra,72(sp)
    80000b16:	6406                	ld	s0,64(sp)
    80000b18:	74e2                	ld	s1,56(sp)
    80000b1a:	7942                	ld	s2,48(sp)
    80000b1c:	79a2                	ld	s3,40(sp)
    80000b1e:	7a02                	ld	s4,32(sp)
    80000b20:	6ae2                	ld	s5,24(sp)
    80000b22:	6b42                	ld	s6,16(sp)
    80000b24:	6ba2                	ld	s7,8(sp)
    80000b26:	6161                	addi	sp,sp,80
    80000b28:	8082                	ret
  return 0;
    80000b2a:	4501                	li	a0,0
}
    80000b2c:	8082                	ret

0000000080000b2e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b2e:	1141                	addi	sp,sp,-16
    80000b30:	e406                	sd	ra,8(sp)
    80000b32:	e022                	sd	s0,0(sp)
    80000b34:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b36:	4601                	li	a2,0
    80000b38:	00000097          	auipc	ra,0x0
    80000b3c:	972080e7          	jalr	-1678(ra) # 800004aa <walk>
  if(pte == 0)
    80000b40:	c901                	beqz	a0,80000b50 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b42:	611c                	ld	a5,0(a0)
    80000b44:	9bbd                	andi	a5,a5,-17
    80000b46:	e11c                	sd	a5,0(a0)
}
    80000b48:	60a2                	ld	ra,8(sp)
    80000b4a:	6402                	ld	s0,0(sp)
    80000b4c:	0141                	addi	sp,sp,16
    80000b4e:	8082                	ret
    panic("uvmclear");
    80000b50:	00007517          	auipc	a0,0x7
    80000b54:	5f850513          	addi	a0,a0,1528 # 80008148 <etext+0x148>
    80000b58:	00005097          	auipc	ra,0x5
    80000b5c:	1e4080e7          	jalr	484(ra) # 80005d3c <panic>

0000000080000b60 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b60:	c6bd                	beqz	a3,80000bce <copyout+0x6e>
{
    80000b62:	715d                	addi	sp,sp,-80
    80000b64:	e486                	sd	ra,72(sp)
    80000b66:	e0a2                	sd	s0,64(sp)
    80000b68:	fc26                	sd	s1,56(sp)
    80000b6a:	f84a                	sd	s2,48(sp)
    80000b6c:	f44e                	sd	s3,40(sp)
    80000b6e:	f052                	sd	s4,32(sp)
    80000b70:	ec56                	sd	s5,24(sp)
    80000b72:	e85a                	sd	s6,16(sp)
    80000b74:	e45e                	sd	s7,8(sp)
    80000b76:	e062                	sd	s8,0(sp)
    80000b78:	0880                	addi	s0,sp,80
    80000b7a:	8b2a                	mv	s6,a0
    80000b7c:	8c2e                	mv	s8,a1
    80000b7e:	8a32                	mv	s4,a2
    80000b80:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b82:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b84:	6a85                	lui	s5,0x1
    80000b86:	a015                	j	80000baa <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b88:	9562                	add	a0,a0,s8
    80000b8a:	0004861b          	sext.w	a2,s1
    80000b8e:	85d2                	mv	a1,s4
    80000b90:	41250533          	sub	a0,a0,s2
    80000b94:	fffff097          	auipc	ra,0xfffff
    80000b98:	68e080e7          	jalr	1678(ra) # 80000222 <memmove>

    len -= n;
    80000b9c:	409989b3          	sub	s3,s3,s1
    src += n;
    80000ba0:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000ba2:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000ba6:	02098263          	beqz	s3,80000bca <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000baa:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bae:	85ca                	mv	a1,s2
    80000bb0:	855a                	mv	a0,s6
    80000bb2:	00000097          	auipc	ra,0x0
    80000bb6:	99e080e7          	jalr	-1634(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000bba:	cd01                	beqz	a0,80000bd2 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bbc:	418904b3          	sub	s1,s2,s8
    80000bc0:	94d6                	add	s1,s1,s5
    80000bc2:	fc99f3e3          	bgeu	s3,s1,80000b88 <copyout+0x28>
    80000bc6:	84ce                	mv	s1,s3
    80000bc8:	b7c1                	j	80000b88 <copyout+0x28>
  }
  return 0;
    80000bca:	4501                	li	a0,0
    80000bcc:	a021                	j	80000bd4 <copyout+0x74>
    80000bce:	4501                	li	a0,0
}
    80000bd0:	8082                	ret
      return -1;
    80000bd2:	557d                	li	a0,-1
}
    80000bd4:	60a6                	ld	ra,72(sp)
    80000bd6:	6406                	ld	s0,64(sp)
    80000bd8:	74e2                	ld	s1,56(sp)
    80000bda:	7942                	ld	s2,48(sp)
    80000bdc:	79a2                	ld	s3,40(sp)
    80000bde:	7a02                	ld	s4,32(sp)
    80000be0:	6ae2                	ld	s5,24(sp)
    80000be2:	6b42                	ld	s6,16(sp)
    80000be4:	6ba2                	ld	s7,8(sp)
    80000be6:	6c02                	ld	s8,0(sp)
    80000be8:	6161                	addi	sp,sp,80
    80000bea:	8082                	ret

0000000080000bec <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bec:	caa5                	beqz	a3,80000c5c <copyin+0x70>
{
    80000bee:	715d                	addi	sp,sp,-80
    80000bf0:	e486                	sd	ra,72(sp)
    80000bf2:	e0a2                	sd	s0,64(sp)
    80000bf4:	fc26                	sd	s1,56(sp)
    80000bf6:	f84a                	sd	s2,48(sp)
    80000bf8:	f44e                	sd	s3,40(sp)
    80000bfa:	f052                	sd	s4,32(sp)
    80000bfc:	ec56                	sd	s5,24(sp)
    80000bfe:	e85a                	sd	s6,16(sp)
    80000c00:	e45e                	sd	s7,8(sp)
    80000c02:	e062                	sd	s8,0(sp)
    80000c04:	0880                	addi	s0,sp,80
    80000c06:	8b2a                	mv	s6,a0
    80000c08:	8a2e                	mv	s4,a1
    80000c0a:	8c32                	mv	s8,a2
    80000c0c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c0e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c10:	6a85                	lui	s5,0x1
    80000c12:	a01d                	j	80000c38 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c14:	018505b3          	add	a1,a0,s8
    80000c18:	0004861b          	sext.w	a2,s1
    80000c1c:	412585b3          	sub	a1,a1,s2
    80000c20:	8552                	mv	a0,s4
    80000c22:	fffff097          	auipc	ra,0xfffff
    80000c26:	600080e7          	jalr	1536(ra) # 80000222 <memmove>

    len -= n;
    80000c2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c34:	02098263          	beqz	s3,80000c58 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c3c:	85ca                	mv	a1,s2
    80000c3e:	855a                	mv	a0,s6
    80000c40:	00000097          	auipc	ra,0x0
    80000c44:	910080e7          	jalr	-1776(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000c48:	cd01                	beqz	a0,80000c60 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c4a:	418904b3          	sub	s1,s2,s8
    80000c4e:	94d6                	add	s1,s1,s5
    80000c50:	fc99f2e3          	bgeu	s3,s1,80000c14 <copyin+0x28>
    80000c54:	84ce                	mv	s1,s3
    80000c56:	bf7d                	j	80000c14 <copyin+0x28>
  }
  return 0;
    80000c58:	4501                	li	a0,0
    80000c5a:	a021                	j	80000c62 <copyin+0x76>
    80000c5c:	4501                	li	a0,0
}
    80000c5e:	8082                	ret
      return -1;
    80000c60:	557d                	li	a0,-1
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6c02                	ld	s8,0(sp)
    80000c76:	6161                	addi	sp,sp,80
    80000c78:	8082                	ret

0000000080000c7a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c7a:	c2dd                	beqz	a3,80000d20 <copyinstr+0xa6>
{
    80000c7c:	715d                	addi	sp,sp,-80
    80000c7e:	e486                	sd	ra,72(sp)
    80000c80:	e0a2                	sd	s0,64(sp)
    80000c82:	fc26                	sd	s1,56(sp)
    80000c84:	f84a                	sd	s2,48(sp)
    80000c86:	f44e                	sd	s3,40(sp)
    80000c88:	f052                	sd	s4,32(sp)
    80000c8a:	ec56                	sd	s5,24(sp)
    80000c8c:	e85a                	sd	s6,16(sp)
    80000c8e:	e45e                	sd	s7,8(sp)
    80000c90:	0880                	addi	s0,sp,80
    80000c92:	8a2a                	mv	s4,a0
    80000c94:	8b2e                	mv	s6,a1
    80000c96:	8bb2                	mv	s7,a2
    80000c98:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c9a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c9c:	6985                	lui	s3,0x1
    80000c9e:	a02d                	j	80000cc8 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000ca0:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ca4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ca6:	37fd                	addiw	a5,a5,-1
    80000ca8:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cac:	60a6                	ld	ra,72(sp)
    80000cae:	6406                	ld	s0,64(sp)
    80000cb0:	74e2                	ld	s1,56(sp)
    80000cb2:	7942                	ld	s2,48(sp)
    80000cb4:	79a2                	ld	s3,40(sp)
    80000cb6:	7a02                	ld	s4,32(sp)
    80000cb8:	6ae2                	ld	s5,24(sp)
    80000cba:	6b42                	ld	s6,16(sp)
    80000cbc:	6ba2                	ld	s7,8(sp)
    80000cbe:	6161                	addi	sp,sp,80
    80000cc0:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cc2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cc6:	c8a9                	beqz	s1,80000d18 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cc8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ccc:	85ca                	mv	a1,s2
    80000cce:	8552                	mv	a0,s4
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	880080e7          	jalr	-1920(ra) # 80000550 <walkaddr>
    if(pa0 == 0)
    80000cd8:	c131                	beqz	a0,80000d1c <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cda:	417906b3          	sub	a3,s2,s7
    80000cde:	96ce                	add	a3,a3,s3
    80000ce0:	00d4f363          	bgeu	s1,a3,80000ce6 <copyinstr+0x6c>
    80000ce4:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ce6:	955e                	add	a0,a0,s7
    80000ce8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cec:	daf9                	beqz	a3,80000cc2 <copyinstr+0x48>
    80000cee:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cf0:	41650633          	sub	a2,a0,s6
    80000cf4:	fff48593          	addi	a1,s1,-1
    80000cf8:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cfa:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cfc:	00f60733          	add	a4,a2,a5
    80000d00:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdce60>
    80000d04:	df51                	beqz	a4,80000ca0 <copyinstr+0x26>
        *dst = *p;
    80000d06:	00e78023          	sb	a4,0(a5)
      --max;
    80000d0a:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d0e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d10:	fed796e3          	bne	a5,a3,80000cfc <copyinstr+0x82>
      dst++;
    80000d14:	8b3e                	mv	s6,a5
    80000d16:	b775                	j	80000cc2 <copyinstr+0x48>
    80000d18:	4781                	li	a5,0
    80000d1a:	b771                	j	80000ca6 <copyinstr+0x2c>
      return -1;
    80000d1c:	557d                	li	a0,-1
    80000d1e:	b779                	j	80000cac <copyinstr+0x32>
  int got_null = 0;
    80000d20:	4781                	li	a5,0
  if(got_null){
    80000d22:	37fd                	addiw	a5,a5,-1
    80000d24:	0007851b          	sext.w	a0,a5
}
    80000d28:	8082                	ret

0000000080000d2a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d2a:	7139                	addi	sp,sp,-64
    80000d2c:	fc06                	sd	ra,56(sp)
    80000d2e:	f822                	sd	s0,48(sp)
    80000d30:	f426                	sd	s1,40(sp)
    80000d32:	f04a                	sd	s2,32(sp)
    80000d34:	ec4e                	sd	s3,24(sp)
    80000d36:	e852                	sd	s4,16(sp)
    80000d38:	e456                	sd	s5,8(sp)
    80000d3a:	e05a                	sd	s6,0(sp)
    80000d3c:	0080                	addi	s0,sp,64
    80000d3e:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	00008497          	auipc	s1,0x8
    80000d44:	24048493          	addi	s1,s1,576 # 80008f80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d48:	8b26                	mv	s6,s1
    80000d4a:	00007a97          	auipc	s5,0x7
    80000d4e:	2b6a8a93          	addi	s5,s5,694 # 80008000 <etext>
    80000d52:	04000937          	lui	s2,0x4000
    80000d56:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d58:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5a:	0000ea17          	auipc	s4,0xe
    80000d5e:	e26a0a13          	addi	s4,s4,-474 # 8000eb80 <tickslock>
    char *pa = kalloc();
    80000d62:	fffff097          	auipc	ra,0xfffff
    80000d66:	3b8080e7          	jalr	952(ra) # 8000011a <kalloc>
    80000d6a:	862a                	mv	a2,a0
    if(pa == 0)
    80000d6c:	c131                	beqz	a0,80000db0 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d6e:	416485b3          	sub	a1,s1,s6
    80000d72:	8591                	srai	a1,a1,0x4
    80000d74:	000ab783          	ld	a5,0(s5)
    80000d78:	02f585b3          	mul	a1,a1,a5
    80000d7c:	2585                	addiw	a1,a1,1
    80000d7e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d82:	4719                	li	a4,6
    80000d84:	6685                	lui	a3,0x1
    80000d86:	40b905b3          	sub	a1,s2,a1
    80000d8a:	854e                	mv	a0,s3
    80000d8c:	00000097          	auipc	ra,0x0
    80000d90:	8a6080e7          	jalr	-1882(ra) # 80000632 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d94:	17048493          	addi	s1,s1,368
    80000d98:	fd4495e3          	bne	s1,s4,80000d62 <proc_mapstacks+0x38>
  }
}
    80000d9c:	70e2                	ld	ra,56(sp)
    80000d9e:	7442                	ld	s0,48(sp)
    80000da0:	74a2                	ld	s1,40(sp)
    80000da2:	7902                	ld	s2,32(sp)
    80000da4:	69e2                	ld	s3,24(sp)
    80000da6:	6a42                	ld	s4,16(sp)
    80000da8:	6aa2                	ld	s5,8(sp)
    80000daa:	6b02                	ld	s6,0(sp)
    80000dac:	6121                	addi	sp,sp,64
    80000dae:	8082                	ret
      panic("kalloc");
    80000db0:	00007517          	auipc	a0,0x7
    80000db4:	3a850513          	addi	a0,a0,936 # 80008158 <etext+0x158>
    80000db8:	00005097          	auipc	ra,0x5
    80000dbc:	f84080e7          	jalr	-124(ra) # 80005d3c <panic>

0000000080000dc0 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000dc0:	7139                	addi	sp,sp,-64
    80000dc2:	fc06                	sd	ra,56(sp)
    80000dc4:	f822                	sd	s0,48(sp)
    80000dc6:	f426                	sd	s1,40(sp)
    80000dc8:	f04a                	sd	s2,32(sp)
    80000dca:	ec4e                	sd	s3,24(sp)
    80000dcc:	e852                	sd	s4,16(sp)
    80000dce:	e456                	sd	s5,8(sp)
    80000dd0:	e05a                	sd	s6,0(sp)
    80000dd2:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dd4:	00007597          	auipc	a1,0x7
    80000dd8:	38c58593          	addi	a1,a1,908 # 80008160 <etext+0x160>
    80000ddc:	00008517          	auipc	a0,0x8
    80000de0:	d7450513          	addi	a0,a0,-652 # 80008b50 <pid_lock>
    80000de4:	00005097          	auipc	ra,0x5
    80000de8:	400080e7          	jalr	1024(ra) # 800061e4 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dec:	00007597          	auipc	a1,0x7
    80000df0:	37c58593          	addi	a1,a1,892 # 80008168 <etext+0x168>
    80000df4:	00008517          	auipc	a0,0x8
    80000df8:	d7450513          	addi	a0,a0,-652 # 80008b68 <wait_lock>
    80000dfc:	00005097          	auipc	ra,0x5
    80000e00:	3e8080e7          	jalr	1000(ra) # 800061e4 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e04:	00008497          	auipc	s1,0x8
    80000e08:	17c48493          	addi	s1,s1,380 # 80008f80 <proc>
      initlock(&p->lock, "proc");
    80000e0c:	00007b17          	auipc	s6,0x7
    80000e10:	36cb0b13          	addi	s6,s6,876 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000e14:	8aa6                	mv	s5,s1
    80000e16:	00007a17          	auipc	s4,0x7
    80000e1a:	1eaa0a13          	addi	s4,s4,490 # 80008000 <etext>
    80000e1e:	04000937          	lui	s2,0x4000
    80000e22:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e24:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e26:	0000e997          	auipc	s3,0xe
    80000e2a:	d5a98993          	addi	s3,s3,-678 # 8000eb80 <tickslock>
      initlock(&p->lock, "proc");
    80000e2e:	85da                	mv	a1,s6
    80000e30:	00848513          	addi	a0,s1,8
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	3b0080e7          	jalr	944(ra) # 800061e4 <initlock>
      p->state = UNUSED;
    80000e3c:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e40:	415487b3          	sub	a5,s1,s5
    80000e44:	8791                	srai	a5,a5,0x4
    80000e46:	000a3703          	ld	a4,0(s4)
    80000e4a:	02e787b3          	mul	a5,a5,a4
    80000e4e:	2785                	addiw	a5,a5,1
    80000e50:	00d7979b          	slliw	a5,a5,0xd
    80000e54:	40f907b3          	sub	a5,s2,a5
    80000e58:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e5a:	17048493          	addi	s1,s1,368
    80000e5e:	fd3498e3          	bne	s1,s3,80000e2e <procinit+0x6e>
  }
}
    80000e62:	70e2                	ld	ra,56(sp)
    80000e64:	7442                	ld	s0,48(sp)
    80000e66:	74a2                	ld	s1,40(sp)
    80000e68:	7902                	ld	s2,32(sp)
    80000e6a:	69e2                	ld	s3,24(sp)
    80000e6c:	6a42                	ld	s4,16(sp)
    80000e6e:	6aa2                	ld	s5,8(sp)
    80000e70:	6b02                	ld	s6,0(sp)
    80000e72:	6121                	addi	sp,sp,64
    80000e74:	8082                	ret

0000000080000e76 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e422                	sd	s0,8(sp)
    80000e7a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e7c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e7e:	2501                	sext.w	a0,a0
    80000e80:	6422                	ld	s0,8(sp)
    80000e82:	0141                	addi	sp,sp,16
    80000e84:	8082                	ret

0000000080000e86 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e422                	sd	s0,8(sp)
    80000e8a:	0800                	addi	s0,sp,16
    80000e8c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e8e:	2781                	sext.w	a5,a5
    80000e90:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e92:	00008517          	auipc	a0,0x8
    80000e96:	cee50513          	addi	a0,a0,-786 # 80008b80 <cpus>
    80000e9a:	953e                	add	a0,a0,a5
    80000e9c:	6422                	ld	s0,8(sp)
    80000e9e:	0141                	addi	sp,sp,16
    80000ea0:	8082                	ret

0000000080000ea2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000ea2:	1101                	addi	sp,sp,-32
    80000ea4:	ec06                	sd	ra,24(sp)
    80000ea6:	e822                	sd	s0,16(sp)
    80000ea8:	e426                	sd	s1,8(sp)
    80000eaa:	1000                	addi	s0,sp,32
  push_off();
    80000eac:	00005097          	auipc	ra,0x5
    80000eb0:	37c080e7          	jalr	892(ra) # 80006228 <push_off>
    80000eb4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000eb6:	2781                	sext.w	a5,a5
    80000eb8:	079e                	slli	a5,a5,0x7
    80000eba:	00008717          	auipc	a4,0x8
    80000ebe:	c9670713          	addi	a4,a4,-874 # 80008b50 <pid_lock>
    80000ec2:	97ba                	add	a5,a5,a4
    80000ec4:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	402080e7          	jalr	1026(ra) # 800062c8 <pop_off>
  return p;
}
    80000ece:	8526                	mv	a0,s1
    80000ed0:	60e2                	ld	ra,24(sp)
    80000ed2:	6442                	ld	s0,16(sp)
    80000ed4:	64a2                	ld	s1,8(sp)
    80000ed6:	6105                	addi	sp,sp,32
    80000ed8:	8082                	ret

0000000080000eda <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e406                	sd	ra,8(sp)
    80000ede:	e022                	sd	s0,0(sp)
    80000ee0:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ee2:	00000097          	auipc	ra,0x0
    80000ee6:	fc0080e7          	jalr	-64(ra) # 80000ea2 <myproc>
    80000eea:	0521                	addi	a0,a0,8
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	43c080e7          	jalr	1084(ra) # 80006328 <release>

  if (first) {
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	b9c7a783          	lw	a5,-1124(a5) # 80008a90 <first.1>
    80000efc:	eb89                	bnez	a5,80000f0e <forkret+0x34>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000efe:	00001097          	auipc	ra,0x1
    80000f02:	ce8080e7          	jalr	-792(ra) # 80001be6 <usertrapret>
}
    80000f06:	60a2                	ld	ra,8(sp)
    80000f08:	6402                	ld	s0,0(sp)
    80000f0a:	0141                	addi	sp,sp,16
    80000f0c:	8082                	ret
    first = 0;
    80000f0e:	00008797          	auipc	a5,0x8
    80000f12:	b807a123          	sw	zero,-1150(a5) # 80008a90 <first.1>
    fsinit(ROOTDEV);
    80000f16:	4505                	li	a0,1
    80000f18:	00002097          	auipc	ra,0x2
    80000f1c:	aec080e7          	jalr	-1300(ra) # 80002a04 <fsinit>
    80000f20:	bff9                	j	80000efe <forkret+0x24>

0000000080000f22 <allocpid>:
{
    80000f22:	1101                	addi	sp,sp,-32
    80000f24:	ec06                	sd	ra,24(sp)
    80000f26:	e822                	sd	s0,16(sp)
    80000f28:	e426                	sd	s1,8(sp)
    80000f2a:	e04a                	sd	s2,0(sp)
    80000f2c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f2e:	00008917          	auipc	s2,0x8
    80000f32:	c2290913          	addi	s2,s2,-990 # 80008b50 <pid_lock>
    80000f36:	854a                	mv	a0,s2
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	33c080e7          	jalr	828(ra) # 80006274 <acquire>
  pid = nextpid;
    80000f40:	00008797          	auipc	a5,0x8
    80000f44:	b5478793          	addi	a5,a5,-1196 # 80008a94 <nextpid>
    80000f48:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f4a:	0014871b          	addiw	a4,s1,1
    80000f4e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f50:	854a                	mv	a0,s2
    80000f52:	00005097          	auipc	ra,0x5
    80000f56:	3d6080e7          	jalr	982(ra) # 80006328 <release>
}
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6902                	ld	s2,0(sp)
    80000f64:	6105                	addi	sp,sp,32
    80000f66:	8082                	ret

0000000080000f68 <proc_pagetable>:
{
    80000f68:	1101                	addi	sp,sp,-32
    80000f6a:	ec06                	sd	ra,24(sp)
    80000f6c:	e822                	sd	s0,16(sp)
    80000f6e:	e426                	sd	s1,8(sp)
    80000f70:	e04a                	sd	s2,0(sp)
    80000f72:	1000                	addi	s0,sp,32
    80000f74:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f76:	00000097          	auipc	ra,0x0
    80000f7a:	8a6080e7          	jalr	-1882(ra) # 8000081c <uvmcreate>
    80000f7e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f80:	c121                	beqz	a0,80000fc0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f82:	4729                	li	a4,10
    80000f84:	00006697          	auipc	a3,0x6
    80000f88:	07c68693          	addi	a3,a3,124 # 80007000 <_trampoline>
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	040005b7          	lui	a1,0x4000
    80000f92:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f94:	05b2                	slli	a1,a1,0xc
    80000f96:	fffff097          	auipc	ra,0xfffff
    80000f9a:	5fc080e7          	jalr	1532(ra) # 80000592 <mappages>
    80000f9e:	02054863          	bltz	a0,80000fce <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000fa2:	4719                	li	a4,6
    80000fa4:	06093683          	ld	a3,96(s2)
    80000fa8:	6605                	lui	a2,0x1
    80000faa:	020005b7          	lui	a1,0x2000
    80000fae:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fb0:	05b6                	slli	a1,a1,0xd
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	fffff097          	auipc	ra,0xfffff
    80000fb8:	5de080e7          	jalr	1502(ra) # 80000592 <mappages>
    80000fbc:	02054163          	bltz	a0,80000fde <proc_pagetable+0x76>
}
    80000fc0:	8526                	mv	a0,s1
    80000fc2:	60e2                	ld	ra,24(sp)
    80000fc4:	6442                	ld	s0,16(sp)
    80000fc6:	64a2                	ld	s1,8(sp)
    80000fc8:	6902                	ld	s2,0(sp)
    80000fca:	6105                	addi	sp,sp,32
    80000fcc:	8082                	ret
    uvmfree(pagetable, 0);
    80000fce:	4581                	li	a1,0
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	a50080e7          	jalr	-1456(ra) # 80000a22 <uvmfree>
    return 0;
    80000fda:	4481                	li	s1,0
    80000fdc:	b7d5                	j	80000fc0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fde:	4681                	li	a3,0
    80000fe0:	4605                	li	a2,1
    80000fe2:	040005b7          	lui	a1,0x4000
    80000fe6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fe8:	05b2                	slli	a1,a1,0xc
    80000fea:	8526                	mv	a0,s1
    80000fec:	fffff097          	auipc	ra,0xfffff
    80000ff0:	76c080e7          	jalr	1900(ra) # 80000758 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ff4:	4581                	li	a1,0
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	00000097          	auipc	ra,0x0
    80000ffc:	a2a080e7          	jalr	-1494(ra) # 80000a22 <uvmfree>
    return 0;
    80001000:	4481                	li	s1,0
    80001002:	bf7d                	j	80000fc0 <proc_pagetable+0x58>

0000000080001004 <proc_freepagetable>:
{
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
    80001010:	84aa                	mv	s1,a0
    80001012:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001014:	4681                	li	a3,0
    80001016:	4605                	li	a2,1
    80001018:	040005b7          	lui	a1,0x4000
    8000101c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000101e:	05b2                	slli	a1,a1,0xc
    80001020:	fffff097          	auipc	ra,0xfffff
    80001024:	738080e7          	jalr	1848(ra) # 80000758 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001028:	4681                	li	a3,0
    8000102a:	4605                	li	a2,1
    8000102c:	020005b7          	lui	a1,0x2000
    80001030:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001032:	05b6                	slli	a1,a1,0xd
    80001034:	8526                	mv	a0,s1
    80001036:	fffff097          	auipc	ra,0xfffff
    8000103a:	722080e7          	jalr	1826(ra) # 80000758 <uvmunmap>
  uvmfree(pagetable, sz);
    8000103e:	85ca                	mv	a1,s2
    80001040:	8526                	mv	a0,s1
    80001042:	00000097          	auipc	ra,0x0
    80001046:	9e0080e7          	jalr	-1568(ra) # 80000a22 <uvmfree>
}
    8000104a:	60e2                	ld	ra,24(sp)
    8000104c:	6442                	ld	s0,16(sp)
    8000104e:	64a2                	ld	s1,8(sp)
    80001050:	6902                	ld	s2,0(sp)
    80001052:	6105                	addi	sp,sp,32
    80001054:	8082                	ret

0000000080001056 <freeproc>:
{
    80001056:	1101                	addi	sp,sp,-32
    80001058:	ec06                	sd	ra,24(sp)
    8000105a:	e822                	sd	s0,16(sp)
    8000105c:	e426                	sd	s1,8(sp)
    8000105e:	1000                	addi	s0,sp,32
    80001060:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001062:	7128                	ld	a0,96(a0)
    80001064:	c509                	beqz	a0,8000106e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001066:	fffff097          	auipc	ra,0xfffff
    8000106a:	fb6080e7          	jalr	-74(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000106e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001072:	6ca8                	ld	a0,88(s1)
    80001074:	c511                	beqz	a0,80001080 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001076:	68ac                	ld	a1,80(s1)
    80001078:	00000097          	auipc	ra,0x0
    8000107c:	f8c080e7          	jalr	-116(ra) # 80001004 <proc_freepagetable>
  p->pagetable = 0;
    80001080:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001084:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001088:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    8000108c:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001090:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001094:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001098:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    8000109c:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    800010a0:	0204a023          	sw	zero,32(s1)
}
    800010a4:	60e2                	ld	ra,24(sp)
    800010a6:	6442                	ld	s0,16(sp)
    800010a8:	64a2                	ld	s1,8(sp)
    800010aa:	6105                	addi	sp,sp,32
    800010ac:	8082                	ret

00000000800010ae <allocproc>:
{
    800010ae:	7179                	addi	sp,sp,-48
    800010b0:	f406                	sd	ra,40(sp)
    800010b2:	f022                	sd	s0,32(sp)
    800010b4:	ec26                	sd	s1,24(sp)
    800010b6:	e84a                	sd	s2,16(sp)
    800010b8:	e44e                	sd	s3,8(sp)
    800010ba:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    800010bc:	00008497          	auipc	s1,0x8
    800010c0:	ec448493          	addi	s1,s1,-316 # 80008f80 <proc>
    800010c4:	0000e997          	auipc	s3,0xe
    800010c8:	abc98993          	addi	s3,s3,-1348 # 8000eb80 <tickslock>
    acquire(&p->lock);
    800010cc:	00848913          	addi	s2,s1,8
    800010d0:	854a                	mv	a0,s2
    800010d2:	00005097          	auipc	ra,0x5
    800010d6:	1a2080e7          	jalr	418(ra) # 80006274 <acquire>
    if(p->state == UNUSED) {
    800010da:	509c                	lw	a5,32(s1)
    800010dc:	cf81                	beqz	a5,800010f4 <allocproc+0x46>
      release(&p->lock);
    800010de:	854a                	mv	a0,s2
    800010e0:	00005097          	auipc	ra,0x5
    800010e4:	248080e7          	jalr	584(ra) # 80006328 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e8:	17048493          	addi	s1,s1,368
    800010ec:	ff3490e3          	bne	s1,s3,800010cc <allocproc+0x1e>
  return 0;
    800010f0:	4481                	li	s1,0
    800010f2:	a889                	j	80001144 <allocproc+0x96>
  p->pid = allocpid();
    800010f4:	00000097          	auipc	ra,0x0
    800010f8:	e2e080e7          	jalr	-466(ra) # 80000f22 <allocpid>
    800010fc:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800010fe:	4785                	li	a5,1
    80001100:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001102:	fffff097          	auipc	ra,0xfffff
    80001106:	018080e7          	jalr	24(ra) # 8000011a <kalloc>
    8000110a:	89aa                	mv	s3,a0
    8000110c:	f0a8                	sd	a0,96(s1)
    8000110e:	c139                	beqz	a0,80001154 <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    80001110:	8526                	mv	a0,s1
    80001112:	00000097          	auipc	ra,0x0
    80001116:	e56080e7          	jalr	-426(ra) # 80000f68 <proc_pagetable>
    8000111a:	89aa                	mv	s3,a0
    8000111c:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    8000111e:	c539                	beqz	a0,8000116c <allocproc+0xbe>
  memset(&p->context, 0, sizeof(p->context));
    80001120:	07000613          	li	a2,112
    80001124:	4581                	li	a1,0
    80001126:	06848513          	addi	a0,s1,104
    8000112a:	fffff097          	auipc	ra,0xfffff
    8000112e:	09c080e7          	jalr	156(ra) # 800001c6 <memset>
  p->context.ra = (uint64)forkret;
    80001132:	00000797          	auipc	a5,0x0
    80001136:	da878793          	addi	a5,a5,-600 # 80000eda <forkret>
    8000113a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000113c:	64bc                	ld	a5,72(s1)
    8000113e:	6705                	lui	a4,0x1
    80001140:	97ba                	add	a5,a5,a4
    80001142:	f8bc                	sd	a5,112(s1)
}
    80001144:	8526                	mv	a0,s1
    80001146:	70a2                	ld	ra,40(sp)
    80001148:	7402                	ld	s0,32(sp)
    8000114a:	64e2                	ld	s1,24(sp)
    8000114c:	6942                	ld	s2,16(sp)
    8000114e:	69a2                	ld	s3,8(sp)
    80001150:	6145                	addi	sp,sp,48
    80001152:	8082                	ret
    freeproc(p);
    80001154:	8526                	mv	a0,s1
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	f00080e7          	jalr	-256(ra) # 80001056 <freeproc>
    release(&p->lock);
    8000115e:	854a                	mv	a0,s2
    80001160:	00005097          	auipc	ra,0x5
    80001164:	1c8080e7          	jalr	456(ra) # 80006328 <release>
    return 0;
    80001168:	84ce                	mv	s1,s3
    8000116a:	bfe9                	j	80001144 <allocproc+0x96>
    freeproc(p);
    8000116c:	8526                	mv	a0,s1
    8000116e:	00000097          	auipc	ra,0x0
    80001172:	ee8080e7          	jalr	-280(ra) # 80001056 <freeproc>
    release(&p->lock);
    80001176:	854a                	mv	a0,s2
    80001178:	00005097          	auipc	ra,0x5
    8000117c:	1b0080e7          	jalr	432(ra) # 80006328 <release>
    return 0;
    80001180:	84ce                	mv	s1,s3
    80001182:	b7c9                	j	80001144 <allocproc+0x96>

0000000080001184 <userinit>:
{
    80001184:	1101                	addi	sp,sp,-32
    80001186:	ec06                	sd	ra,24(sp)
    80001188:	e822                	sd	s0,16(sp)
    8000118a:	e426                	sd	s1,8(sp)
    8000118c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	f20080e7          	jalr	-224(ra) # 800010ae <allocproc>
    80001196:	84aa                	mv	s1,a0
  initproc = p;
    80001198:	00008797          	auipc	a5,0x8
    8000119c:	96a7bc23          	sd	a0,-1672(a5) # 80008b10 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800011a0:	03400613          	li	a2,52
    800011a4:	00008597          	auipc	a1,0x8
    800011a8:	8fc58593          	addi	a1,a1,-1796 # 80008aa0 <initcode>
    800011ac:	6d28                	ld	a0,88(a0)
    800011ae:	fffff097          	auipc	ra,0xfffff
    800011b2:	69c080e7          	jalr	1692(ra) # 8000084a <uvmfirst>
  p->sz = PGSIZE;
    800011b6:	6785                	lui	a5,0x1
    800011b8:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800011ba:	70b8                	ld	a4,96(s1)
    800011bc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c0:	70b8                	ld	a4,96(s1)
    800011c2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c4:	4641                	li	a2,16
    800011c6:	00007597          	auipc	a1,0x7
    800011ca:	fba58593          	addi	a1,a1,-70 # 80008180 <etext+0x180>
    800011ce:	16048513          	addi	a0,s1,352
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	13e080e7          	jalr	318(ra) # 80000310 <safestrcpy>
  p->cwd = namei("/");
    800011da:	00007517          	auipc	a0,0x7
    800011de:	fb650513          	addi	a0,a0,-74 # 80008190 <etext+0x190>
    800011e2:	00002097          	auipc	ra,0x2
    800011e6:	24c080e7          	jalr	588(ra) # 8000342e <namei>
    800011ea:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800011ee:	478d                	li	a5,3
    800011f0:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    800011f2:	00848513          	addi	a0,s1,8
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	132080e7          	jalr	306(ra) # 80006328 <release>
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6105                	addi	sp,sp,32
    80001206:	8082                	ret

0000000080001208 <growproc>:
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	e04a                	sd	s2,0(sp)
    80001212:	1000                	addi	s0,sp,32
    80001214:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	c8c080e7          	jalr	-884(ra) # 80000ea2 <myproc>
    8000121e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001220:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001222:	01204c63          	bgtz	s2,8000123a <growproc+0x32>
  } else if(n < 0){
    80001226:	02094663          	bltz	s2,80001252 <growproc+0x4a>
  p->sz = sz;
    8000122a:	e8ac                	sd	a1,80(s1)
  return 0;
    8000122c:	4501                	li	a0,0
}
    8000122e:	60e2                	ld	ra,24(sp)
    80001230:	6442                	ld	s0,16(sp)
    80001232:	64a2                	ld	s1,8(sp)
    80001234:	6902                	ld	s2,0(sp)
    80001236:	6105                	addi	sp,sp,32
    80001238:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000123a:	4691                	li	a3,4
    8000123c:	00b90633          	add	a2,s2,a1
    80001240:	6d28                	ld	a0,88(a0)
    80001242:	fffff097          	auipc	ra,0xfffff
    80001246:	6c2080e7          	jalr	1730(ra) # 80000904 <uvmalloc>
    8000124a:	85aa                	mv	a1,a0
    8000124c:	fd79                	bnez	a0,8000122a <growproc+0x22>
      return -1;
    8000124e:	557d                	li	a0,-1
    80001250:	bff9                	j	8000122e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001252:	00b90633          	add	a2,s2,a1
    80001256:	6d28                	ld	a0,88(a0)
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	664080e7          	jalr	1636(ra) # 800008bc <uvmdealloc>
    80001260:	85aa                	mv	a1,a0
    80001262:	b7e1                	j	8000122a <growproc+0x22>

0000000080001264 <fork>:
{
    80001264:	7139                	addi	sp,sp,-64
    80001266:	fc06                	sd	ra,56(sp)
    80001268:	f822                	sd	s0,48(sp)
    8000126a:	f426                	sd	s1,40(sp)
    8000126c:	f04a                	sd	s2,32(sp)
    8000126e:	ec4e                	sd	s3,24(sp)
    80001270:	e852                	sd	s4,16(sp)
    80001272:	e456                	sd	s5,8(sp)
    80001274:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	c2c080e7          	jalr	-980(ra) # 80000ea2 <myproc>
    8000127e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001280:	00000097          	auipc	ra,0x0
    80001284:	e2e080e7          	jalr	-466(ra) # 800010ae <allocproc>
    80001288:	12050363          	beqz	a0,800013ae <fork+0x14a>
    8000128c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000128e:	050ab603          	ld	a2,80(s5)
    80001292:	6d2c                	ld	a1,88(a0)
    80001294:	058ab503          	ld	a0,88(s5)
    80001298:	fffff097          	auipc	ra,0xfffff
    8000129c:	7c4080e7          	jalr	1988(ra) # 80000a5c <uvmcopy>
    800012a0:	04054c63          	bltz	a0,800012f8 <fork+0x94>
  np->sz = p->sz;
    800012a4:	050ab783          	ld	a5,80(s5)
    800012a8:	04fa3823          	sd	a5,80(s4)
  np->mask = p->mask;
    800012ac:	000ab783          	ld	a5,0(s5)
    800012b0:	00fa3023          	sd	a5,0(s4)
  *(np->trapframe) = *(p->trapframe);
    800012b4:	060ab683          	ld	a3,96(s5)
    800012b8:	87b6                	mv	a5,a3
    800012ba:	060a3703          	ld	a4,96(s4)
    800012be:	12068693          	addi	a3,a3,288
    800012c2:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012c6:	6788                	ld	a0,8(a5)
    800012c8:	6b8c                	ld	a1,16(a5)
    800012ca:	6f90                	ld	a2,24(a5)
    800012cc:	01073023          	sd	a6,0(a4)
    800012d0:	e708                	sd	a0,8(a4)
    800012d2:	eb0c                	sd	a1,16(a4)
    800012d4:	ef10                	sd	a2,24(a4)
    800012d6:	02078793          	addi	a5,a5,32
    800012da:	02070713          	addi	a4,a4,32
    800012de:	fed792e3          	bne	a5,a3,800012c2 <fork+0x5e>
  np->trapframe->a0 = 0;
    800012e2:	060a3783          	ld	a5,96(s4)
    800012e6:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012ea:	0d8a8493          	addi	s1,s5,216
    800012ee:	0d8a0913          	addi	s2,s4,216
    800012f2:	158a8993          	addi	s3,s5,344
    800012f6:	a015                	j	8000131a <fork+0xb6>
    freeproc(np);
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	d5c080e7          	jalr	-676(ra) # 80001056 <freeproc>
    release(&np->lock);
    80001302:	008a0513          	addi	a0,s4,8
    80001306:	00005097          	auipc	ra,0x5
    8000130a:	022080e7          	jalr	34(ra) # 80006328 <release>
    return -1;
    8000130e:	59fd                	li	s3,-1
    80001310:	a069                	j	8000139a <fork+0x136>
  for(i = 0; i < NOFILE; i++)
    80001312:	04a1                	addi	s1,s1,8
    80001314:	0921                	addi	s2,s2,8
    80001316:	01348b63          	beq	s1,s3,8000132c <fork+0xc8>
    if(p->ofile[i])
    8000131a:	6088                	ld	a0,0(s1)
    8000131c:	d97d                	beqz	a0,80001312 <fork+0xae>
      np->ofile[i] = filedup(p->ofile[i]);
    8000131e:	00002097          	auipc	ra,0x2
    80001322:	7a6080e7          	jalr	1958(ra) # 80003ac4 <filedup>
    80001326:	00a93023          	sd	a0,0(s2)
    8000132a:	b7e5                	j	80001312 <fork+0xae>
  np->cwd = idup(p->cwd);
    8000132c:	158ab503          	ld	a0,344(s5)
    80001330:	00002097          	auipc	ra,0x2
    80001334:	914080e7          	jalr	-1772(ra) # 80002c44 <idup>
    80001338:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000133c:	4641                	li	a2,16
    8000133e:	160a8593          	addi	a1,s5,352
    80001342:	160a0513          	addi	a0,s4,352
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	fca080e7          	jalr	-54(ra) # 80000310 <safestrcpy>
  pid = np->pid;
    8000134e:	038a2983          	lw	s3,56(s4)
  release(&np->lock);
    80001352:	008a0493          	addi	s1,s4,8
    80001356:	8526                	mv	a0,s1
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	fd0080e7          	jalr	-48(ra) # 80006328 <release>
  acquire(&wait_lock);
    80001360:	00008917          	auipc	s2,0x8
    80001364:	80890913          	addi	s2,s2,-2040 # 80008b68 <wait_lock>
    80001368:	854a                	mv	a0,s2
    8000136a:	00005097          	auipc	ra,0x5
    8000136e:	f0a080e7          	jalr	-246(ra) # 80006274 <acquire>
  np->parent = p;
    80001372:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001376:	854a                	mv	a0,s2
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	fb0080e7          	jalr	-80(ra) # 80006328 <release>
  acquire(&np->lock);
    80001380:	8526                	mv	a0,s1
    80001382:	00005097          	auipc	ra,0x5
    80001386:	ef2080e7          	jalr	-270(ra) # 80006274 <acquire>
  np->state = RUNNABLE;
    8000138a:	478d                	li	a5,3
    8000138c:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    80001390:	8526                	mv	a0,s1
    80001392:	00005097          	auipc	ra,0x5
    80001396:	f96080e7          	jalr	-106(ra) # 80006328 <release>
}
    8000139a:	854e                	mv	a0,s3
    8000139c:	70e2                	ld	ra,56(sp)
    8000139e:	7442                	ld	s0,48(sp)
    800013a0:	74a2                	ld	s1,40(sp)
    800013a2:	7902                	ld	s2,32(sp)
    800013a4:	69e2                	ld	s3,24(sp)
    800013a6:	6a42                	ld	s4,16(sp)
    800013a8:	6aa2                	ld	s5,8(sp)
    800013aa:	6121                	addi	sp,sp,64
    800013ac:	8082                	ret
    return -1;
    800013ae:	59fd                	li	s3,-1
    800013b0:	b7ed                	j	8000139a <fork+0x136>

00000000800013b2 <scheduler>:
{
    800013b2:	715d                	addi	sp,sp,-80
    800013b4:	e486                	sd	ra,72(sp)
    800013b6:	e0a2                	sd	s0,64(sp)
    800013b8:	fc26                	sd	s1,56(sp)
    800013ba:	f84a                	sd	s2,48(sp)
    800013bc:	f44e                	sd	s3,40(sp)
    800013be:	f052                	sd	s4,32(sp)
    800013c0:	ec56                	sd	s5,24(sp)
    800013c2:	e85a                	sd	s6,16(sp)
    800013c4:	e45e                	sd	s7,8(sp)
    800013c6:	0880                	addi	s0,sp,80
    800013c8:	8792                	mv	a5,tp
  int id = r_tp();
    800013ca:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013cc:	00779b13          	slli	s6,a5,0x7
    800013d0:	00007717          	auipc	a4,0x7
    800013d4:	78070713          	addi	a4,a4,1920 # 80008b50 <pid_lock>
    800013d8:	975a                	add	a4,a4,s6
    800013da:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013de:	00007717          	auipc	a4,0x7
    800013e2:	7aa70713          	addi	a4,a4,1962 # 80008b88 <cpus+0x8>
    800013e6:	9b3a                	add	s6,s6,a4
      if(p->state == RUNNABLE) {
    800013e8:	4a0d                	li	s4,3
        p->state = RUNNING;
    800013ea:	4b91                	li	s7,4
        c->proc = p;
    800013ec:	079e                	slli	a5,a5,0x7
    800013ee:	00007a97          	auipc	s5,0x7
    800013f2:	762a8a93          	addi	s5,s5,1890 # 80008b50 <pid_lock>
    800013f6:	9abe                	add	s5,s5,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f8:	0000d997          	auipc	s3,0xd
    800013fc:	78898993          	addi	s3,s3,1928 # 8000eb80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001400:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001404:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001408:	10079073          	csrw	sstatus,a5
    8000140c:	00008497          	auipc	s1,0x8
    80001410:	b7448493          	addi	s1,s1,-1164 # 80008f80 <proc>
    80001414:	a811                	j	80001428 <scheduler+0x76>
      release(&p->lock);
    80001416:	854a                	mv	a0,s2
    80001418:	00005097          	auipc	ra,0x5
    8000141c:	f10080e7          	jalr	-240(ra) # 80006328 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001420:	17048493          	addi	s1,s1,368
    80001424:	fd348ee3          	beq	s1,s3,80001400 <scheduler+0x4e>
      acquire(&p->lock);
    80001428:	00848913          	addi	s2,s1,8
    8000142c:	854a                	mv	a0,s2
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	e46080e7          	jalr	-442(ra) # 80006274 <acquire>
      if(p->state == RUNNABLE) {
    80001436:	509c                	lw	a5,32(s1)
    80001438:	fd479fe3          	bne	a5,s4,80001416 <scheduler+0x64>
        p->state = RUNNING;
    8000143c:	0374a023          	sw	s7,32(s1)
        c->proc = p;
    80001440:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001444:	06848593          	addi	a1,s1,104
    80001448:	855a                	mv	a0,s6
    8000144a:	00000097          	auipc	ra,0x0
    8000144e:	6f2080e7          	jalr	1778(ra) # 80001b3c <swtch>
        c->proc = 0;
    80001452:	020ab823          	sd	zero,48(s5)
    80001456:	b7c1                	j	80001416 <scheduler+0x64>

0000000080001458 <sched>:
{
    80001458:	7179                	addi	sp,sp,-48
    8000145a:	f406                	sd	ra,40(sp)
    8000145c:	f022                	sd	s0,32(sp)
    8000145e:	ec26                	sd	s1,24(sp)
    80001460:	e84a                	sd	s2,16(sp)
    80001462:	e44e                	sd	s3,8(sp)
    80001464:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001466:	00000097          	auipc	ra,0x0
    8000146a:	a3c080e7          	jalr	-1476(ra) # 80000ea2 <myproc>
    8000146e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001470:	0521                	addi	a0,a0,8
    80001472:	00005097          	auipc	ra,0x5
    80001476:	d88080e7          	jalr	-632(ra) # 800061fa <holding>
    8000147a:	c93d                	beqz	a0,800014f0 <sched+0x98>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000147c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	00007717          	auipc	a4,0x7
    80001486:	6ce70713          	addi	a4,a4,1742 # 80008b50 <pid_lock>
    8000148a:	97ba                	add	a5,a5,a4
    8000148c:	0a87a703          	lw	a4,168(a5)
    80001490:	4785                	li	a5,1
    80001492:	06f71763          	bne	a4,a5,80001500 <sched+0xa8>
  if(p->state == RUNNING)
    80001496:	5098                	lw	a4,32(s1)
    80001498:	4791                	li	a5,4
    8000149a:	06f70b63          	beq	a4,a5,80001510 <sched+0xb8>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000149e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014a2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014a4:	efb5                	bnez	a5,80001520 <sched+0xc8>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014a6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014a8:	00007917          	auipc	s2,0x7
    800014ac:	6a890913          	addi	s2,s2,1704 # 80008b50 <pid_lock>
    800014b0:	2781                	sext.w	a5,a5
    800014b2:	079e                	slli	a5,a5,0x7
    800014b4:	97ca                	add	a5,a5,s2
    800014b6:	0ac7a983          	lw	s3,172(a5)
    800014ba:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014bc:	2781                	sext.w	a5,a5
    800014be:	079e                	slli	a5,a5,0x7
    800014c0:	00007597          	auipc	a1,0x7
    800014c4:	6c858593          	addi	a1,a1,1736 # 80008b88 <cpus+0x8>
    800014c8:	95be                	add	a1,a1,a5
    800014ca:	06848513          	addi	a0,s1,104
    800014ce:	00000097          	auipc	ra,0x0
    800014d2:	66e080e7          	jalr	1646(ra) # 80001b3c <swtch>
    800014d6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014d8:	2781                	sext.w	a5,a5
    800014da:	079e                	slli	a5,a5,0x7
    800014dc:	993e                	add	s2,s2,a5
    800014de:	0b392623          	sw	s3,172(s2)
}
    800014e2:	70a2                	ld	ra,40(sp)
    800014e4:	7402                	ld	s0,32(sp)
    800014e6:	64e2                	ld	s1,24(sp)
    800014e8:	6942                	ld	s2,16(sp)
    800014ea:	69a2                	ld	s3,8(sp)
    800014ec:	6145                	addi	sp,sp,48
    800014ee:	8082                	ret
    panic("sched p->lock");
    800014f0:	00007517          	auipc	a0,0x7
    800014f4:	ca850513          	addi	a0,a0,-856 # 80008198 <etext+0x198>
    800014f8:	00005097          	auipc	ra,0x5
    800014fc:	844080e7          	jalr	-1980(ra) # 80005d3c <panic>
    panic("sched locks");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	ca850513          	addi	a0,a0,-856 # 800081a8 <etext+0x1a8>
    80001508:	00005097          	auipc	ra,0x5
    8000150c:	834080e7          	jalr	-1996(ra) # 80005d3c <panic>
    panic("sched running");
    80001510:	00007517          	auipc	a0,0x7
    80001514:	ca850513          	addi	a0,a0,-856 # 800081b8 <etext+0x1b8>
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	824080e7          	jalr	-2012(ra) # 80005d3c <panic>
    panic("sched interruptible");
    80001520:	00007517          	auipc	a0,0x7
    80001524:	ca850513          	addi	a0,a0,-856 # 800081c8 <etext+0x1c8>
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	814080e7          	jalr	-2028(ra) # 80005d3c <panic>

0000000080001530 <yield>:
{
    80001530:	1101                	addi	sp,sp,-32
    80001532:	ec06                	sd	ra,24(sp)
    80001534:	e822                	sd	s0,16(sp)
    80001536:	e426                	sd	s1,8(sp)
    80001538:	e04a                	sd	s2,0(sp)
    8000153a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	966080e7          	jalr	-1690(ra) # 80000ea2 <myproc>
    80001544:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001546:	00850913          	addi	s2,a0,8
    8000154a:	854a                	mv	a0,s2
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	d28080e7          	jalr	-728(ra) # 80006274 <acquire>
  p->state = RUNNABLE;
    80001554:	478d                	li	a5,3
    80001556:	d09c                	sw	a5,32(s1)
  sched();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	f00080e7          	jalr	-256(ra) # 80001458 <sched>
  release(&p->lock);
    80001560:	854a                	mv	a0,s2
    80001562:	00005097          	auipc	ra,0x5
    80001566:	dc6080e7          	jalr	-570(ra) # 80006328 <release>
}
    8000156a:	60e2                	ld	ra,24(sp)
    8000156c:	6442                	ld	s0,16(sp)
    8000156e:	64a2                	ld	s1,8(sp)
    80001570:	6902                	ld	s2,0(sp)
    80001572:	6105                	addi	sp,sp,32
    80001574:	8082                	ret

0000000080001576 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001576:	7179                	addi	sp,sp,-48
    80001578:	f406                	sd	ra,40(sp)
    8000157a:	f022                	sd	s0,32(sp)
    8000157c:	ec26                	sd	s1,24(sp)
    8000157e:	e84a                	sd	s2,16(sp)
    80001580:	e44e                	sd	s3,8(sp)
    80001582:	e052                	sd	s4,0(sp)
    80001584:	1800                	addi	s0,sp,48
    80001586:	89aa                	mv	s3,a0
    80001588:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	918080e7          	jalr	-1768(ra) # 80000ea2 <myproc>
    80001592:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001594:	00850a13          	addi	s4,a0,8
    80001598:	8552                	mv	a0,s4
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	cda080e7          	jalr	-806(ra) # 80006274 <acquire>
  release(lk);
    800015a2:	854a                	mv	a0,s2
    800015a4:	00005097          	auipc	ra,0x5
    800015a8:	d84080e7          	jalr	-636(ra) # 80006328 <release>

  // Go to sleep.
  p->chan = chan;
    800015ac:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800015b0:	4789                	li	a5,2
    800015b2:	d09c                	sw	a5,32(s1)

  sched();
    800015b4:	00000097          	auipc	ra,0x0
    800015b8:	ea4080e7          	jalr	-348(ra) # 80001458 <sched>

  // Tidy up.
  p->chan = 0;
    800015bc:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015c0:	8552                	mv	a0,s4
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	d66080e7          	jalr	-666(ra) # 80006328 <release>
  acquire(lk);
    800015ca:	854a                	mv	a0,s2
    800015cc:	00005097          	auipc	ra,0x5
    800015d0:	ca8080e7          	jalr	-856(ra) # 80006274 <acquire>
}
    800015d4:	70a2                	ld	ra,40(sp)
    800015d6:	7402                	ld	s0,32(sp)
    800015d8:	64e2                	ld	s1,24(sp)
    800015da:	6942                	ld	s2,16(sp)
    800015dc:	69a2                	ld	s3,8(sp)
    800015de:	6a02                	ld	s4,0(sp)
    800015e0:	6145                	addi	sp,sp,48
    800015e2:	8082                	ret

00000000800015e4 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800015e4:	7139                	addi	sp,sp,-64
    800015e6:	fc06                	sd	ra,56(sp)
    800015e8:	f822                	sd	s0,48(sp)
    800015ea:	f426                	sd	s1,40(sp)
    800015ec:	f04a                	sd	s2,32(sp)
    800015ee:	ec4e                	sd	s3,24(sp)
    800015f0:	e852                	sd	s4,16(sp)
    800015f2:	e456                	sd	s5,8(sp)
    800015f4:	e05a                	sd	s6,0(sp)
    800015f6:	0080                	addi	s0,sp,64
    800015f8:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015fa:	00008497          	auipc	s1,0x8
    800015fe:	98648493          	addi	s1,s1,-1658 # 80008f80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001602:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001604:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001606:	0000d997          	auipc	s3,0xd
    8000160a:	57a98993          	addi	s3,s3,1402 # 8000eb80 <tickslock>
    8000160e:	a811                	j	80001622 <wakeup+0x3e>
      }
      release(&p->lock);
    80001610:	854a                	mv	a0,s2
    80001612:	00005097          	auipc	ra,0x5
    80001616:	d16080e7          	jalr	-746(ra) # 80006328 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000161a:	17048493          	addi	s1,s1,368
    8000161e:	03348863          	beq	s1,s3,8000164e <wakeup+0x6a>
    if(p != myproc()){
    80001622:	00000097          	auipc	ra,0x0
    80001626:	880080e7          	jalr	-1920(ra) # 80000ea2 <myproc>
    8000162a:	fea488e3          	beq	s1,a0,8000161a <wakeup+0x36>
      acquire(&p->lock);
    8000162e:	00848913          	addi	s2,s1,8
    80001632:	854a                	mv	a0,s2
    80001634:	00005097          	auipc	ra,0x5
    80001638:	c40080e7          	jalr	-960(ra) # 80006274 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000163c:	509c                	lw	a5,32(s1)
    8000163e:	fd4799e3          	bne	a5,s4,80001610 <wakeup+0x2c>
    80001642:	749c                	ld	a5,40(s1)
    80001644:	fd5796e3          	bne	a5,s5,80001610 <wakeup+0x2c>
        p->state = RUNNABLE;
    80001648:	0364a023          	sw	s6,32(s1)
    8000164c:	b7d1                	j	80001610 <wakeup+0x2c>
    }
  }
}
    8000164e:	70e2                	ld	ra,56(sp)
    80001650:	7442                	ld	s0,48(sp)
    80001652:	74a2                	ld	s1,40(sp)
    80001654:	7902                	ld	s2,32(sp)
    80001656:	69e2                	ld	s3,24(sp)
    80001658:	6a42                	ld	s4,16(sp)
    8000165a:	6aa2                	ld	s5,8(sp)
    8000165c:	6b02                	ld	s6,0(sp)
    8000165e:	6121                	addi	sp,sp,64
    80001660:	8082                	ret

0000000080001662 <reparent>:
{
    80001662:	7179                	addi	sp,sp,-48
    80001664:	f406                	sd	ra,40(sp)
    80001666:	f022                	sd	s0,32(sp)
    80001668:	ec26                	sd	s1,24(sp)
    8000166a:	e84a                	sd	s2,16(sp)
    8000166c:	e44e                	sd	s3,8(sp)
    8000166e:	e052                	sd	s4,0(sp)
    80001670:	1800                	addi	s0,sp,48
    80001672:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001674:	00008497          	auipc	s1,0x8
    80001678:	90c48493          	addi	s1,s1,-1780 # 80008f80 <proc>
      pp->parent = initproc;
    8000167c:	00007a17          	auipc	s4,0x7
    80001680:	494a0a13          	addi	s4,s4,1172 # 80008b10 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001684:	0000d997          	auipc	s3,0xd
    80001688:	4fc98993          	addi	s3,s3,1276 # 8000eb80 <tickslock>
    8000168c:	a029                	j	80001696 <reparent+0x34>
    8000168e:	17048493          	addi	s1,s1,368
    80001692:	01348d63          	beq	s1,s3,800016ac <reparent+0x4a>
    if(pp->parent == p){
    80001696:	60bc                	ld	a5,64(s1)
    80001698:	ff279be3          	bne	a5,s2,8000168e <reparent+0x2c>
      pp->parent = initproc;
    8000169c:	000a3503          	ld	a0,0(s4)
    800016a0:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800016a2:	00000097          	auipc	ra,0x0
    800016a6:	f42080e7          	jalr	-190(ra) # 800015e4 <wakeup>
    800016aa:	b7d5                	j	8000168e <reparent+0x2c>
}
    800016ac:	70a2                	ld	ra,40(sp)
    800016ae:	7402                	ld	s0,32(sp)
    800016b0:	64e2                	ld	s1,24(sp)
    800016b2:	6942                	ld	s2,16(sp)
    800016b4:	69a2                	ld	s3,8(sp)
    800016b6:	6a02                	ld	s4,0(sp)
    800016b8:	6145                	addi	sp,sp,48
    800016ba:	8082                	ret

00000000800016bc <exit>:
{
    800016bc:	7179                	addi	sp,sp,-48
    800016be:	f406                	sd	ra,40(sp)
    800016c0:	f022                	sd	s0,32(sp)
    800016c2:	ec26                	sd	s1,24(sp)
    800016c4:	e84a                	sd	s2,16(sp)
    800016c6:	e44e                	sd	s3,8(sp)
    800016c8:	e052                	sd	s4,0(sp)
    800016ca:	1800                	addi	s0,sp,48
    800016cc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800016ce:	fffff097          	auipc	ra,0xfffff
    800016d2:	7d4080e7          	jalr	2004(ra) # 80000ea2 <myproc>
    800016d6:	89aa                	mv	s3,a0
  if(p == initproc)
    800016d8:	00007797          	auipc	a5,0x7
    800016dc:	4387b783          	ld	a5,1080(a5) # 80008b10 <initproc>
    800016e0:	0d850493          	addi	s1,a0,216
    800016e4:	15850913          	addi	s2,a0,344
    800016e8:	02a79363          	bne	a5,a0,8000170e <exit+0x52>
    panic("init exiting");
    800016ec:	00007517          	auipc	a0,0x7
    800016f0:	af450513          	addi	a0,a0,-1292 # 800081e0 <etext+0x1e0>
    800016f4:	00004097          	auipc	ra,0x4
    800016f8:	648080e7          	jalr	1608(ra) # 80005d3c <panic>
      fileclose(f);
    800016fc:	00002097          	auipc	ra,0x2
    80001700:	41a080e7          	jalr	1050(ra) # 80003b16 <fileclose>
      p->ofile[fd] = 0;
    80001704:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001708:	04a1                	addi	s1,s1,8
    8000170a:	01248563          	beq	s1,s2,80001714 <exit+0x58>
    if(p->ofile[fd]){
    8000170e:	6088                	ld	a0,0(s1)
    80001710:	f575                	bnez	a0,800016fc <exit+0x40>
    80001712:	bfdd                	j	80001708 <exit+0x4c>
  begin_op();
    80001714:	00002097          	auipc	ra,0x2
    80001718:	f3a080e7          	jalr	-198(ra) # 8000364e <begin_op>
  iput(p->cwd);
    8000171c:	1589b503          	ld	a0,344(s3)
    80001720:	00001097          	auipc	ra,0x1
    80001724:	71c080e7          	jalr	1820(ra) # 80002e3c <iput>
  end_op();
    80001728:	00002097          	auipc	ra,0x2
    8000172c:	fa4080e7          	jalr	-92(ra) # 800036cc <end_op>
  p->cwd = 0;
    80001730:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001734:	00007497          	auipc	s1,0x7
    80001738:	43448493          	addi	s1,s1,1076 # 80008b68 <wait_lock>
    8000173c:	8526                	mv	a0,s1
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	b36080e7          	jalr	-1226(ra) # 80006274 <acquire>
  reparent(p);
    80001746:	854e                	mv	a0,s3
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	f1a080e7          	jalr	-230(ra) # 80001662 <reparent>
  wakeup(p->parent);
    80001750:	0409b503          	ld	a0,64(s3)
    80001754:	00000097          	auipc	ra,0x0
    80001758:	e90080e7          	jalr	-368(ra) # 800015e4 <wakeup>
  acquire(&p->lock);
    8000175c:	00898513          	addi	a0,s3,8
    80001760:	00005097          	auipc	ra,0x5
    80001764:	b14080e7          	jalr	-1260(ra) # 80006274 <acquire>
  p->xstate = status;
    80001768:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000176c:	4795                	li	a5,5
    8000176e:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001772:	8526                	mv	a0,s1
    80001774:	00005097          	auipc	ra,0x5
    80001778:	bb4080e7          	jalr	-1100(ra) # 80006328 <release>
  sched();
    8000177c:	00000097          	auipc	ra,0x0
    80001780:	cdc080e7          	jalr	-804(ra) # 80001458 <sched>
  panic("zombie exit");
    80001784:	00007517          	auipc	a0,0x7
    80001788:	a6c50513          	addi	a0,a0,-1428 # 800081f0 <etext+0x1f0>
    8000178c:	00004097          	auipc	ra,0x4
    80001790:	5b0080e7          	jalr	1456(ra) # 80005d3c <panic>

0000000080001794 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001794:	7179                	addi	sp,sp,-48
    80001796:	f406                	sd	ra,40(sp)
    80001798:	f022                	sd	s0,32(sp)
    8000179a:	ec26                	sd	s1,24(sp)
    8000179c:	e84a                	sd	s2,16(sp)
    8000179e:	e44e                	sd	s3,8(sp)
    800017a0:	e052                	sd	s4,0(sp)
    800017a2:	1800                	addi	s0,sp,48
    800017a4:	89aa                	mv	s3,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017a6:	00007497          	auipc	s1,0x7
    800017aa:	7da48493          	addi	s1,s1,2010 # 80008f80 <proc>
    800017ae:	0000da17          	auipc	s4,0xd
    800017b2:	3d2a0a13          	addi	s4,s4,978 # 8000eb80 <tickslock>
    acquire(&p->lock);
    800017b6:	00848913          	addi	s2,s1,8
    800017ba:	854a                	mv	a0,s2
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	ab8080e7          	jalr	-1352(ra) # 80006274 <acquire>
    if(p->pid == pid){
    800017c4:	5c9c                	lw	a5,56(s1)
    800017c6:	01378d63          	beq	a5,s3,800017e0 <kill+0x4c>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800017ca:	854a                	mv	a0,s2
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	b5c080e7          	jalr	-1188(ra) # 80006328 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800017d4:	17048493          	addi	s1,s1,368
    800017d8:	fd449fe3          	bne	s1,s4,800017b6 <kill+0x22>
  }
  return -1;
    800017dc:	557d                	li	a0,-1
    800017de:	a829                	j	800017f8 <kill+0x64>
      p->killed = 1;
    800017e0:	4785                	li	a5,1
    800017e2:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    800017e4:	5098                	lw	a4,32(s1)
    800017e6:	4789                	li	a5,2
    800017e8:	02f70063          	beq	a4,a5,80001808 <kill+0x74>
      release(&p->lock);
    800017ec:	854a                	mv	a0,s2
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	b3a080e7          	jalr	-1222(ra) # 80006328 <release>
      return 0;
    800017f6:	4501                	li	a0,0
}
    800017f8:	70a2                	ld	ra,40(sp)
    800017fa:	7402                	ld	s0,32(sp)
    800017fc:	64e2                	ld	s1,24(sp)
    800017fe:	6942                	ld	s2,16(sp)
    80001800:	69a2                	ld	s3,8(sp)
    80001802:	6a02                	ld	s4,0(sp)
    80001804:	6145                	addi	sp,sp,48
    80001806:	8082                	ret
        p->state = RUNNABLE;
    80001808:	478d                	li	a5,3
    8000180a:	d09c                	sw	a5,32(s1)
    8000180c:	b7c5                	j	800017ec <kill+0x58>

000000008000180e <setkilled>:

void
setkilled(struct proc *p)
{
    8000180e:	1101                	addi	sp,sp,-32
    80001810:	ec06                	sd	ra,24(sp)
    80001812:	e822                	sd	s0,16(sp)
    80001814:	e426                	sd	s1,8(sp)
    80001816:	e04a                	sd	s2,0(sp)
    80001818:	1000                	addi	s0,sp,32
    8000181a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000181c:	00850913          	addi	s2,a0,8
    80001820:	854a                	mv	a0,s2
    80001822:	00005097          	auipc	ra,0x5
    80001826:	a52080e7          	jalr	-1454(ra) # 80006274 <acquire>
  p->killed = 1;
    8000182a:	4785                	li	a5,1
    8000182c:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    8000182e:	854a                	mv	a0,s2
    80001830:	00005097          	auipc	ra,0x5
    80001834:	af8080e7          	jalr	-1288(ra) # 80006328 <release>
}
    80001838:	60e2                	ld	ra,24(sp)
    8000183a:	6442                	ld	s0,16(sp)
    8000183c:	64a2                	ld	s1,8(sp)
    8000183e:	6902                	ld	s2,0(sp)
    80001840:	6105                	addi	sp,sp,32
    80001842:	8082                	ret

0000000080001844 <killed>:

int
killed(struct proc *p)
{
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	e04a                	sd	s2,0(sp)
    8000184e:	1000                	addi	s0,sp,32
    80001850:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001852:	00850913          	addi	s2,a0,8
    80001856:	854a                	mv	a0,s2
    80001858:	00005097          	auipc	ra,0x5
    8000185c:	a1c080e7          	jalr	-1508(ra) # 80006274 <acquire>
  k = p->killed;
    80001860:	5884                	lw	s1,48(s1)
  release(&p->lock);
    80001862:	854a                	mv	a0,s2
    80001864:	00005097          	auipc	ra,0x5
    80001868:	ac4080e7          	jalr	-1340(ra) # 80006328 <release>
  return k;
}
    8000186c:	8526                	mv	a0,s1
    8000186e:	60e2                	ld	ra,24(sp)
    80001870:	6442                	ld	s0,16(sp)
    80001872:	64a2                	ld	s1,8(sp)
    80001874:	6902                	ld	s2,0(sp)
    80001876:	6105                	addi	sp,sp,32
    80001878:	8082                	ret

000000008000187a <wait>:
{
    8000187a:	711d                	addi	sp,sp,-96
    8000187c:	ec86                	sd	ra,88(sp)
    8000187e:	e8a2                	sd	s0,80(sp)
    80001880:	e4a6                	sd	s1,72(sp)
    80001882:	e0ca                	sd	s2,64(sp)
    80001884:	fc4e                	sd	s3,56(sp)
    80001886:	f852                	sd	s4,48(sp)
    80001888:	f456                	sd	s5,40(sp)
    8000188a:	f05a                	sd	s6,32(sp)
    8000188c:	ec5e                	sd	s7,24(sp)
    8000188e:	e862                	sd	s8,16(sp)
    80001890:	e466                	sd	s9,8(sp)
    80001892:	1080                	addi	s0,sp,96
    80001894:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001896:	fffff097          	auipc	ra,0xfffff
    8000189a:	60c080e7          	jalr	1548(ra) # 80000ea2 <myproc>
    8000189e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018a0:	00007517          	auipc	a0,0x7
    800018a4:	2c850513          	addi	a0,a0,712 # 80008b68 <wait_lock>
    800018a8:	00005097          	auipc	ra,0x5
    800018ac:	9cc080e7          	jalr	-1588(ra) # 80006274 <acquire>
    havekids = 0;
    800018b0:	4c01                	li	s8,0
        if(pp->state == ZOMBIE){
    800018b2:	4a95                	li	s5,5
        havekids = 1;
    800018b4:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018b6:	0000d997          	auipc	s3,0xd
    800018ba:	2ca98993          	addi	s3,s3,714 # 8000eb80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018be:	00007c97          	auipc	s9,0x7
    800018c2:	2aac8c93          	addi	s9,s9,682 # 80008b68 <wait_lock>
    havekids = 0;
    800018c6:	8762                	mv	a4,s8
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c8:	00007497          	auipc	s1,0x7
    800018cc:	6b848493          	addi	s1,s1,1720 # 80008f80 <proc>
    800018d0:	a0bd                	j	8000193e <wait+0xc4>
          pid = pp->pid;
    800018d2:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018d6:	000b8e63          	beqz	s7,800018f2 <wait+0x78>
    800018da:	4691                	li	a3,4
    800018dc:	03448613          	addi	a2,s1,52
    800018e0:	85de                	mv	a1,s7
    800018e2:	05893503          	ld	a0,88(s2)
    800018e6:	fffff097          	auipc	ra,0xfffff
    800018ea:	27a080e7          	jalr	634(ra) # 80000b60 <copyout>
    800018ee:	02054563          	bltz	a0,80001918 <wait+0x9e>
          freeproc(pp);
    800018f2:	8526                	mv	a0,s1
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	762080e7          	jalr	1890(ra) # 80001056 <freeproc>
          release(&pp->lock);
    800018fc:	8552                	mv	a0,s4
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	a2a080e7          	jalr	-1494(ra) # 80006328 <release>
          release(&wait_lock);
    80001906:	00007517          	auipc	a0,0x7
    8000190a:	26250513          	addi	a0,a0,610 # 80008b68 <wait_lock>
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	a1a080e7          	jalr	-1510(ra) # 80006328 <release>
          return pid;
    80001916:	a885                	j	80001986 <wait+0x10c>
            release(&pp->lock);
    80001918:	8552                	mv	a0,s4
    8000191a:	00005097          	auipc	ra,0x5
    8000191e:	a0e080e7          	jalr	-1522(ra) # 80006328 <release>
            release(&wait_lock);
    80001922:	00007517          	auipc	a0,0x7
    80001926:	24650513          	addi	a0,a0,582 # 80008b68 <wait_lock>
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	9fe080e7          	jalr	-1538(ra) # 80006328 <release>
            return -1;
    80001932:	59fd                	li	s3,-1
    80001934:	a889                	j	80001986 <wait+0x10c>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001936:	17048493          	addi	s1,s1,368
    8000193a:	03348663          	beq	s1,s3,80001966 <wait+0xec>
      if(pp->parent == p){
    8000193e:	60bc                	ld	a5,64(s1)
    80001940:	ff279be3          	bne	a5,s2,80001936 <wait+0xbc>
        acquire(&pp->lock);
    80001944:	00848a13          	addi	s4,s1,8
    80001948:	8552                	mv	a0,s4
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	92a080e7          	jalr	-1750(ra) # 80006274 <acquire>
        if(pp->state == ZOMBIE){
    80001952:	509c                	lw	a5,32(s1)
    80001954:	f7578fe3          	beq	a5,s5,800018d2 <wait+0x58>
        release(&pp->lock);
    80001958:	8552                	mv	a0,s4
    8000195a:	00005097          	auipc	ra,0x5
    8000195e:	9ce080e7          	jalr	-1586(ra) # 80006328 <release>
        havekids = 1;
    80001962:	875a                	mv	a4,s6
    80001964:	bfc9                	j	80001936 <wait+0xbc>
    if(!havekids || killed(p)){
    80001966:	c719                	beqz	a4,80001974 <wait+0xfa>
    80001968:	854a                	mv	a0,s2
    8000196a:	00000097          	auipc	ra,0x0
    8000196e:	eda080e7          	jalr	-294(ra) # 80001844 <killed>
    80001972:	c905                	beqz	a0,800019a2 <wait+0x128>
      release(&wait_lock);
    80001974:	00007517          	auipc	a0,0x7
    80001978:	1f450513          	addi	a0,a0,500 # 80008b68 <wait_lock>
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	9ac080e7          	jalr	-1620(ra) # 80006328 <release>
      return -1;
    80001984:	59fd                	li	s3,-1
}
    80001986:	854e                	mv	a0,s3
    80001988:	60e6                	ld	ra,88(sp)
    8000198a:	6446                	ld	s0,80(sp)
    8000198c:	64a6                	ld	s1,72(sp)
    8000198e:	6906                	ld	s2,64(sp)
    80001990:	79e2                	ld	s3,56(sp)
    80001992:	7a42                	ld	s4,48(sp)
    80001994:	7aa2                	ld	s5,40(sp)
    80001996:	7b02                	ld	s6,32(sp)
    80001998:	6be2                	ld	s7,24(sp)
    8000199a:	6c42                	ld	s8,16(sp)
    8000199c:	6ca2                	ld	s9,8(sp)
    8000199e:	6125                	addi	sp,sp,96
    800019a0:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019a2:	85e6                	mv	a1,s9
    800019a4:	854a                	mv	a0,s2
    800019a6:	00000097          	auipc	ra,0x0
    800019aa:	bd0080e7          	jalr	-1072(ra) # 80001576 <sleep>
    havekids = 0;
    800019ae:	bf21                	j	800018c6 <wait+0x4c>

00000000800019b0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800019b0:	7179                	addi	sp,sp,-48
    800019b2:	f406                	sd	ra,40(sp)
    800019b4:	f022                	sd	s0,32(sp)
    800019b6:	ec26                	sd	s1,24(sp)
    800019b8:	e84a                	sd	s2,16(sp)
    800019ba:	e44e                	sd	s3,8(sp)
    800019bc:	e052                	sd	s4,0(sp)
    800019be:	1800                	addi	s0,sp,48
    800019c0:	84aa                	mv	s1,a0
    800019c2:	892e                	mv	s2,a1
    800019c4:	89b2                	mv	s3,a2
    800019c6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019c8:	fffff097          	auipc	ra,0xfffff
    800019cc:	4da080e7          	jalr	1242(ra) # 80000ea2 <myproc>
  if(user_dst){
    800019d0:	c08d                	beqz	s1,800019f2 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    800019d2:	86d2                	mv	a3,s4
    800019d4:	864e                	mv	a2,s3
    800019d6:	85ca                	mv	a1,s2
    800019d8:	6d28                	ld	a0,88(a0)
    800019da:	fffff097          	auipc	ra,0xfffff
    800019de:	186080e7          	jalr	390(ra) # 80000b60 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019e2:	70a2                	ld	ra,40(sp)
    800019e4:	7402                	ld	s0,32(sp)
    800019e6:	64e2                	ld	s1,24(sp)
    800019e8:	6942                	ld	s2,16(sp)
    800019ea:	69a2                	ld	s3,8(sp)
    800019ec:	6a02                	ld	s4,0(sp)
    800019ee:	6145                	addi	sp,sp,48
    800019f0:	8082                	ret
    memmove((char *)dst, src, len);
    800019f2:	000a061b          	sext.w	a2,s4
    800019f6:	85ce                	mv	a1,s3
    800019f8:	854a                	mv	a0,s2
    800019fa:	fffff097          	auipc	ra,0xfffff
    800019fe:	828080e7          	jalr	-2008(ra) # 80000222 <memmove>
    return 0;
    80001a02:	8526                	mv	a0,s1
    80001a04:	bff9                	j	800019e2 <either_copyout+0x32>

0000000080001a06 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001a06:	7179                	addi	sp,sp,-48
    80001a08:	f406                	sd	ra,40(sp)
    80001a0a:	f022                	sd	s0,32(sp)
    80001a0c:	ec26                	sd	s1,24(sp)
    80001a0e:	e84a                	sd	s2,16(sp)
    80001a10:	e44e                	sd	s3,8(sp)
    80001a12:	e052                	sd	s4,0(sp)
    80001a14:	1800                	addi	s0,sp,48
    80001a16:	892a                	mv	s2,a0
    80001a18:	84ae                	mv	s1,a1
    80001a1a:	89b2                	mv	s3,a2
    80001a1c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001a1e:	fffff097          	auipc	ra,0xfffff
    80001a22:	484080e7          	jalr	1156(ra) # 80000ea2 <myproc>
  if(user_src){
    80001a26:	c08d                	beqz	s1,80001a48 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001a28:	86d2                	mv	a3,s4
    80001a2a:	864e                	mv	a2,s3
    80001a2c:	85ca                	mv	a1,s2
    80001a2e:	6d28                	ld	a0,88(a0)
    80001a30:	fffff097          	auipc	ra,0xfffff
    80001a34:	1bc080e7          	jalr	444(ra) # 80000bec <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001a38:	70a2                	ld	ra,40(sp)
    80001a3a:	7402                	ld	s0,32(sp)
    80001a3c:	64e2                	ld	s1,24(sp)
    80001a3e:	6942                	ld	s2,16(sp)
    80001a40:	69a2                	ld	s3,8(sp)
    80001a42:	6a02                	ld	s4,0(sp)
    80001a44:	6145                	addi	sp,sp,48
    80001a46:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a48:	000a061b          	sext.w	a2,s4
    80001a4c:	85ce                	mv	a1,s3
    80001a4e:	854a                	mv	a0,s2
    80001a50:	ffffe097          	auipc	ra,0xffffe
    80001a54:	7d2080e7          	jalr	2002(ra) # 80000222 <memmove>
    return 0;
    80001a58:	8526                	mv	a0,s1
    80001a5a:	bff9                	j	80001a38 <either_copyin+0x32>

0000000080001a5c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a5c:	715d                	addi	sp,sp,-80
    80001a5e:	e486                	sd	ra,72(sp)
    80001a60:	e0a2                	sd	s0,64(sp)
    80001a62:	fc26                	sd	s1,56(sp)
    80001a64:	f84a                	sd	s2,48(sp)
    80001a66:	f44e                	sd	s3,40(sp)
    80001a68:	f052                	sd	s4,32(sp)
    80001a6a:	ec56                	sd	s5,24(sp)
    80001a6c:	e85a                	sd	s6,16(sp)
    80001a6e:	e45e                	sd	s7,8(sp)
    80001a70:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a72:	00006517          	auipc	a0,0x6
    80001a76:	5d650513          	addi	a0,a0,1494 # 80008048 <etext+0x48>
    80001a7a:	00004097          	auipc	ra,0x4
    80001a7e:	30c080e7          	jalr	780(ra) # 80005d86 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a82:	00007497          	auipc	s1,0x7
    80001a86:	65e48493          	addi	s1,s1,1630 # 800090e0 <proc+0x160>
    80001a8a:	0000d917          	auipc	s2,0xd
    80001a8e:	25690913          	addi	s2,s2,598 # 8000ece0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a92:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a94:	00006997          	auipc	s3,0x6
    80001a98:	76c98993          	addi	s3,s3,1900 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a9c:	00006a97          	auipc	s5,0x6
    80001aa0:	76ca8a93          	addi	s5,s5,1900 # 80008208 <etext+0x208>
    printf("\n");
    80001aa4:	00006a17          	auipc	s4,0x6
    80001aa8:	5a4a0a13          	addi	s4,s4,1444 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001aac:	00006b97          	auipc	s7,0x6
    80001ab0:	79cb8b93          	addi	s7,s7,1948 # 80008248 <states.0>
    80001ab4:	a00d                	j	80001ad6 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ab6:	ed86a583          	lw	a1,-296(a3)
    80001aba:	8556                	mv	a0,s5
    80001abc:	00004097          	auipc	ra,0x4
    80001ac0:	2ca080e7          	jalr	714(ra) # 80005d86 <printf>
    printf("\n");
    80001ac4:	8552                	mv	a0,s4
    80001ac6:	00004097          	auipc	ra,0x4
    80001aca:	2c0080e7          	jalr	704(ra) # 80005d86 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ace:	17048493          	addi	s1,s1,368
    80001ad2:	03248263          	beq	s1,s2,80001af6 <procdump+0x9a>
    if(p->state == UNUSED)
    80001ad6:	86a6                	mv	a3,s1
    80001ad8:	ec04a783          	lw	a5,-320(s1)
    80001adc:	dbed                	beqz	a5,80001ace <procdump+0x72>
      state = "???";
    80001ade:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ae0:	fcfb6be3          	bltu	s6,a5,80001ab6 <procdump+0x5a>
    80001ae4:	02079713          	slli	a4,a5,0x20
    80001ae8:	01d75793          	srli	a5,a4,0x1d
    80001aec:	97de                	add	a5,a5,s7
    80001aee:	6390                	ld	a2,0(a5)
    80001af0:	f279                	bnez	a2,80001ab6 <procdump+0x5a>
      state = "???";
    80001af2:	864e                	mv	a2,s3
    80001af4:	b7c9                	j	80001ab6 <procdump+0x5a>
  }
}
    80001af6:	60a6                	ld	ra,72(sp)
    80001af8:	6406                	ld	s0,64(sp)
    80001afa:	74e2                	ld	s1,56(sp)
    80001afc:	7942                	ld	s2,48(sp)
    80001afe:	79a2                	ld	s3,40(sp)
    80001b00:	7a02                	ld	s4,32(sp)
    80001b02:	6ae2                	ld	s5,24(sp)
    80001b04:	6b42                	ld	s6,16(sp)
    80001b06:	6ba2                	ld	s7,8(sp)
    80001b08:	6161                	addi	sp,sp,80
    80001b0a:	8082                	ret

0000000080001b0c <freeprocesses>:

// return the number of unused processes
int 
freeprocesses(void)
{
    80001b0c:	1141                	addi	sp,sp,-16
    80001b0e:	e422                	sd	s0,8(sp)
    80001b10:	0800                	addi	s0,sp,16
  // loop on the processes list and see which processes are unused
  int procnum = 0;
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    80001b12:	00007797          	auipc	a5,0x7
    80001b16:	46e78793          	addi	a5,a5,1134 # 80008f80 <proc>
  int procnum = 0;
    80001b1a:	4501                	li	a0,0
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    80001b1c:	0000d697          	auipc	a3,0xd
    80001b20:	06468693          	addi	a3,a3,100 # 8000eb80 <tickslock>
    80001b24:	a029                	j	80001b2e <freeprocesses+0x22>
    80001b26:	17078793          	addi	a5,a5,368
    80001b2a:	00d78663          	beq	a5,a3,80001b36 <freeprocesses+0x2a>
    if (p->state != UNUSED)
    80001b2e:	5398                	lw	a4,32(a5)
    80001b30:	db7d                	beqz	a4,80001b26 <freeprocesses+0x1a>
      procnum++;
    80001b32:	2505                	addiw	a0,a0,1
    80001b34:	bfcd                	j	80001b26 <freeprocesses+0x1a>
  }
  return procnum;
}
    80001b36:	6422                	ld	s0,8(sp)
    80001b38:	0141                	addi	sp,sp,16
    80001b3a:	8082                	ret

0000000080001b3c <swtch>:
    80001b3c:	00153023          	sd	ra,0(a0)
    80001b40:	00253423          	sd	sp,8(a0)
    80001b44:	e900                	sd	s0,16(a0)
    80001b46:	ed04                	sd	s1,24(a0)
    80001b48:	03253023          	sd	s2,32(a0)
    80001b4c:	03353423          	sd	s3,40(a0)
    80001b50:	03453823          	sd	s4,48(a0)
    80001b54:	03553c23          	sd	s5,56(a0)
    80001b58:	05653023          	sd	s6,64(a0)
    80001b5c:	05753423          	sd	s7,72(a0)
    80001b60:	05853823          	sd	s8,80(a0)
    80001b64:	05953c23          	sd	s9,88(a0)
    80001b68:	07a53023          	sd	s10,96(a0)
    80001b6c:	07b53423          	sd	s11,104(a0)
    80001b70:	0005b083          	ld	ra,0(a1)
    80001b74:	0085b103          	ld	sp,8(a1)
    80001b78:	6980                	ld	s0,16(a1)
    80001b7a:	6d84                	ld	s1,24(a1)
    80001b7c:	0205b903          	ld	s2,32(a1)
    80001b80:	0285b983          	ld	s3,40(a1)
    80001b84:	0305ba03          	ld	s4,48(a1)
    80001b88:	0385ba83          	ld	s5,56(a1)
    80001b8c:	0405bb03          	ld	s6,64(a1)
    80001b90:	0485bb83          	ld	s7,72(a1)
    80001b94:	0505bc03          	ld	s8,80(a1)
    80001b98:	0585bc83          	ld	s9,88(a1)
    80001b9c:	0605bd03          	ld	s10,96(a1)
    80001ba0:	0685bd83          	ld	s11,104(a1)
    80001ba4:	8082                	ret

0000000080001ba6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ba6:	1141                	addi	sp,sp,-16
    80001ba8:	e406                	sd	ra,8(sp)
    80001baa:	e022                	sd	s0,0(sp)
    80001bac:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001bae:	00006597          	auipc	a1,0x6
    80001bb2:	6ca58593          	addi	a1,a1,1738 # 80008278 <states.0+0x30>
    80001bb6:	0000d517          	auipc	a0,0xd
    80001bba:	fca50513          	addi	a0,a0,-54 # 8000eb80 <tickslock>
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	626080e7          	jalr	1574(ra) # 800061e4 <initlock>
}
    80001bc6:	60a2                	ld	ra,8(sp)
    80001bc8:	6402                	ld	s0,0(sp)
    80001bca:	0141                	addi	sp,sp,16
    80001bcc:	8082                	ret

0000000080001bce <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001bce:	1141                	addi	sp,sp,-16
    80001bd0:	e422                	sd	s0,8(sp)
    80001bd2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bd4:	00003797          	auipc	a5,0x3
    80001bd8:	59c78793          	addi	a5,a5,1436 # 80005170 <kernelvec>
    80001bdc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001be0:	6422                	ld	s0,8(sp)
    80001be2:	0141                	addi	sp,sp,16
    80001be4:	8082                	ret

0000000080001be6 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001be6:	1141                	addi	sp,sp,-16
    80001be8:	e406                	sd	ra,8(sp)
    80001bea:	e022                	sd	s0,0(sp)
    80001bec:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001bee:	fffff097          	auipc	ra,0xfffff
    80001bf2:	2b4080e7          	jalr	692(ra) # 80000ea2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001bfa:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bfc:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001c00:	00005697          	auipc	a3,0x5
    80001c04:	40068693          	addi	a3,a3,1024 # 80007000 <_trampoline>
    80001c08:	00005717          	auipc	a4,0x5
    80001c0c:	3f870713          	addi	a4,a4,1016 # 80007000 <_trampoline>
    80001c10:	8f15                	sub	a4,a4,a3
    80001c12:	040007b7          	lui	a5,0x4000
    80001c16:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001c18:	07b2                	slli	a5,a5,0xc
    80001c1a:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c1c:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001c20:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001c22:	18002673          	csrr	a2,satp
    80001c26:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001c28:	7130                	ld	a2,96(a0)
    80001c2a:	6538                	ld	a4,72(a0)
    80001c2c:	6585                	lui	a1,0x1
    80001c2e:	972e                	add	a4,a4,a1
    80001c30:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001c32:	7138                	ld	a4,96(a0)
    80001c34:	00000617          	auipc	a2,0x0
    80001c38:	13060613          	addi	a2,a2,304 # 80001d64 <usertrap>
    80001c3c:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001c3e:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c40:	8612                	mv	a2,tp
    80001c42:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c44:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001c48:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001c4c:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c50:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001c54:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c56:	6f18                	ld	a4,24(a4)
    80001c58:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c5c:	6d28                	ld	a0,88(a0)
    80001c5e:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c60:	00005717          	auipc	a4,0x5
    80001c64:	43c70713          	addi	a4,a4,1084 # 8000709c <userret>
    80001c68:	8f15                	sub	a4,a4,a3
    80001c6a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c6c:	577d                	li	a4,-1
    80001c6e:	177e                	slli	a4,a4,0x3f
    80001c70:	8d59                	or	a0,a0,a4
    80001c72:	9782                	jalr	a5
}
    80001c74:	60a2                	ld	ra,8(sp)
    80001c76:	6402                	ld	s0,0(sp)
    80001c78:	0141                	addi	sp,sp,16
    80001c7a:	8082                	ret

0000000080001c7c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c7c:	1101                	addi	sp,sp,-32
    80001c7e:	ec06                	sd	ra,24(sp)
    80001c80:	e822                	sd	s0,16(sp)
    80001c82:	e426                	sd	s1,8(sp)
    80001c84:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c86:	0000d497          	auipc	s1,0xd
    80001c8a:	efa48493          	addi	s1,s1,-262 # 8000eb80 <tickslock>
    80001c8e:	8526                	mv	a0,s1
    80001c90:	00004097          	auipc	ra,0x4
    80001c94:	5e4080e7          	jalr	1508(ra) # 80006274 <acquire>
  ticks++;
    80001c98:	00007517          	auipc	a0,0x7
    80001c9c:	e8050513          	addi	a0,a0,-384 # 80008b18 <ticks>
    80001ca0:	411c                	lw	a5,0(a0)
    80001ca2:	2785                	addiw	a5,a5,1
    80001ca4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	93e080e7          	jalr	-1730(ra) # 800015e4 <wakeup>
  release(&tickslock);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	678080e7          	jalr	1656(ra) # 80006328 <release>
}
    80001cb8:	60e2                	ld	ra,24(sp)
    80001cba:	6442                	ld	s0,16(sp)
    80001cbc:	64a2                	ld	s1,8(sp)
    80001cbe:	6105                	addi	sp,sp,32
    80001cc0:	8082                	ret

0000000080001cc2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ccc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001cd0:	00074d63          	bltz	a4,80001cea <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001cd4:	57fd                	li	a5,-1
    80001cd6:	17fe                	slli	a5,a5,0x3f
    80001cd8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001cda:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001cdc:	06f70363          	beq	a4,a5,80001d42 <devintr+0x80>
  }
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6105                	addi	sp,sp,32
    80001ce8:	8082                	ret
     (scause & 0xff) == 9){
    80001cea:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001cee:	46a5                	li	a3,9
    80001cf0:	fed792e3          	bne	a5,a3,80001cd4 <devintr+0x12>
    int irq = plic_claim();
    80001cf4:	00003097          	auipc	ra,0x3
    80001cf8:	584080e7          	jalr	1412(ra) # 80005278 <plic_claim>
    80001cfc:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001cfe:	47a9                	li	a5,10
    80001d00:	02f50763          	beq	a0,a5,80001d2e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001d04:	4785                	li	a5,1
    80001d06:	02f50963          	beq	a0,a5,80001d38 <devintr+0x76>
    return 1;
    80001d0a:	4505                	li	a0,1
    } else if(irq){
    80001d0c:	d8f1                	beqz	s1,80001ce0 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001d0e:	85a6                	mv	a1,s1
    80001d10:	00006517          	auipc	a0,0x6
    80001d14:	57050513          	addi	a0,a0,1392 # 80008280 <states.0+0x38>
    80001d18:	00004097          	auipc	ra,0x4
    80001d1c:	06e080e7          	jalr	110(ra) # 80005d86 <printf>
      plic_complete(irq);
    80001d20:	8526                	mv	a0,s1
    80001d22:	00003097          	auipc	ra,0x3
    80001d26:	57a080e7          	jalr	1402(ra) # 8000529c <plic_complete>
    return 1;
    80001d2a:	4505                	li	a0,1
    80001d2c:	bf55                	j	80001ce0 <devintr+0x1e>
      uartintr();
    80001d2e:	00004097          	auipc	ra,0x4
    80001d32:	466080e7          	jalr	1126(ra) # 80006194 <uartintr>
    80001d36:	b7ed                	j	80001d20 <devintr+0x5e>
      virtio_disk_intr();
    80001d38:	00004097          	auipc	ra,0x4
    80001d3c:	a2c080e7          	jalr	-1492(ra) # 80005764 <virtio_disk_intr>
    80001d40:	b7c5                	j	80001d20 <devintr+0x5e>
    if(cpuid() == 0){
    80001d42:	fffff097          	auipc	ra,0xfffff
    80001d46:	134080e7          	jalr	308(ra) # 80000e76 <cpuid>
    80001d4a:	c901                	beqz	a0,80001d5a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001d4c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001d50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001d52:	14479073          	csrw	sip,a5
    return 2;
    80001d56:	4509                	li	a0,2
    80001d58:	b761                	j	80001ce0 <devintr+0x1e>
      clockintr();
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	f22080e7          	jalr	-222(ra) # 80001c7c <clockintr>
    80001d62:	b7ed                	j	80001d4c <devintr+0x8a>

0000000080001d64 <usertrap>:
{
    80001d64:	1101                	addi	sp,sp,-32
    80001d66:	ec06                	sd	ra,24(sp)
    80001d68:	e822                	sd	s0,16(sp)
    80001d6a:	e426                	sd	s1,8(sp)
    80001d6c:	e04a                	sd	s2,0(sp)
    80001d6e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d70:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d74:	1007f793          	andi	a5,a5,256
    80001d78:	e3b1                	bnez	a5,80001dbc <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d7a:	00003797          	auipc	a5,0x3
    80001d7e:	3f678793          	addi	a5,a5,1014 # 80005170 <kernelvec>
    80001d82:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d86:	fffff097          	auipc	ra,0xfffff
    80001d8a:	11c080e7          	jalr	284(ra) # 80000ea2 <myproc>
    80001d8e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d90:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d92:	14102773          	csrr	a4,sepc
    80001d96:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d98:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d9c:	47a1                	li	a5,8
    80001d9e:	02f70763          	beq	a4,a5,80001dcc <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	f20080e7          	jalr	-224(ra) # 80001cc2 <devintr>
    80001daa:	892a                	mv	s2,a0
    80001dac:	c151                	beqz	a0,80001e30 <usertrap+0xcc>
  if(killed(p))
    80001dae:	8526                	mv	a0,s1
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a94080e7          	jalr	-1388(ra) # 80001844 <killed>
    80001db8:	c929                	beqz	a0,80001e0a <usertrap+0xa6>
    80001dba:	a099                	j	80001e00 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	4e450513          	addi	a0,a0,1252 # 800082a0 <states.0+0x58>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	f78080e7          	jalr	-136(ra) # 80005d3c <panic>
    if(killed(p))
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	a78080e7          	jalr	-1416(ra) # 80001844 <killed>
    80001dd4:	e921                	bnez	a0,80001e24 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001dd6:	70b8                	ld	a4,96(s1)
    80001dd8:	6f1c                	ld	a5,24(a4)
    80001dda:	0791                	addi	a5,a5,4
    80001ddc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001de2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001de6:	10079073          	csrw	sstatus,a5
    syscall();
    80001dea:	00000097          	auipc	ra,0x0
    80001dee:	2d4080e7          	jalr	724(ra) # 800020be <syscall>
  if(killed(p))
    80001df2:	8526                	mv	a0,s1
    80001df4:	00000097          	auipc	ra,0x0
    80001df8:	a50080e7          	jalr	-1456(ra) # 80001844 <killed>
    80001dfc:	c911                	beqz	a0,80001e10 <usertrap+0xac>
    80001dfe:	4901                	li	s2,0
    exit(-1);
    80001e00:	557d                	li	a0,-1
    80001e02:	00000097          	auipc	ra,0x0
    80001e06:	8ba080e7          	jalr	-1862(ra) # 800016bc <exit>
  if(which_dev == 2)
    80001e0a:	4789                	li	a5,2
    80001e0c:	04f90f63          	beq	s2,a5,80001e6a <usertrap+0x106>
  usertrapret();
    80001e10:	00000097          	auipc	ra,0x0
    80001e14:	dd6080e7          	jalr	-554(ra) # 80001be6 <usertrapret>
}
    80001e18:	60e2                	ld	ra,24(sp)
    80001e1a:	6442                	ld	s0,16(sp)
    80001e1c:	64a2                	ld	s1,8(sp)
    80001e1e:	6902                	ld	s2,0(sp)
    80001e20:	6105                	addi	sp,sp,32
    80001e22:	8082                	ret
      exit(-1);
    80001e24:	557d                	li	a0,-1
    80001e26:	00000097          	auipc	ra,0x0
    80001e2a:	896080e7          	jalr	-1898(ra) # 800016bc <exit>
    80001e2e:	b765                	j	80001dd6 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e30:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001e34:	5c90                	lw	a2,56(s1)
    80001e36:	00006517          	auipc	a0,0x6
    80001e3a:	48a50513          	addi	a0,a0,1162 # 800082c0 <states.0+0x78>
    80001e3e:	00004097          	auipc	ra,0x4
    80001e42:	f48080e7          	jalr	-184(ra) # 80005d86 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e46:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e4a:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	4a250513          	addi	a0,a0,1186 # 800082f0 <states.0+0xa8>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	f30080e7          	jalr	-208(ra) # 80005d86 <printf>
    setkilled(p);
    80001e5e:	8526                	mv	a0,s1
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	9ae080e7          	jalr	-1618(ra) # 8000180e <setkilled>
    80001e68:	b769                	j	80001df2 <usertrap+0x8e>
    yield();
    80001e6a:	fffff097          	auipc	ra,0xfffff
    80001e6e:	6c6080e7          	jalr	1734(ra) # 80001530 <yield>
    80001e72:	bf79                	j	80001e10 <usertrap+0xac>

0000000080001e74 <kerneltrap>:
{
    80001e74:	7179                	addi	sp,sp,-48
    80001e76:	f406                	sd	ra,40(sp)
    80001e78:	f022                	sd	s0,32(sp)
    80001e7a:	ec26                	sd	s1,24(sp)
    80001e7c:	e84a                	sd	s2,16(sp)
    80001e7e:	e44e                	sd	s3,8(sp)
    80001e80:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e82:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e86:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e8a:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e8e:	1004f793          	andi	a5,s1,256
    80001e92:	cb85                	beqz	a5,80001ec2 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e94:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e98:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e9a:	ef85                	bnez	a5,80001ed2 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e9c:	00000097          	auipc	ra,0x0
    80001ea0:	e26080e7          	jalr	-474(ra) # 80001cc2 <devintr>
    80001ea4:	cd1d                	beqz	a0,80001ee2 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ea6:	4789                	li	a5,2
    80001ea8:	06f50a63          	beq	a0,a5,80001f1c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001eac:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb0:	10049073          	csrw	sstatus,s1
}
    80001eb4:	70a2                	ld	ra,40(sp)
    80001eb6:	7402                	ld	s0,32(sp)
    80001eb8:	64e2                	ld	s1,24(sp)
    80001eba:	6942                	ld	s2,16(sp)
    80001ebc:	69a2                	ld	s3,8(sp)
    80001ebe:	6145                	addi	sp,sp,48
    80001ec0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ec2:	00006517          	auipc	a0,0x6
    80001ec6:	44e50513          	addi	a0,a0,1102 # 80008310 <states.0+0xc8>
    80001eca:	00004097          	auipc	ra,0x4
    80001ece:	e72080e7          	jalr	-398(ra) # 80005d3c <panic>
    panic("kerneltrap: interrupts enabled");
    80001ed2:	00006517          	auipc	a0,0x6
    80001ed6:	46650513          	addi	a0,a0,1126 # 80008338 <states.0+0xf0>
    80001eda:	00004097          	auipc	ra,0x4
    80001ede:	e62080e7          	jalr	-414(ra) # 80005d3c <panic>
    printf("scause %p\n", scause);
    80001ee2:	85ce                	mv	a1,s3
    80001ee4:	00006517          	auipc	a0,0x6
    80001ee8:	47450513          	addi	a0,a0,1140 # 80008358 <states.0+0x110>
    80001eec:	00004097          	auipc	ra,0x4
    80001ef0:	e9a080e7          	jalr	-358(ra) # 80005d86 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ef4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001efc:	00006517          	auipc	a0,0x6
    80001f00:	46c50513          	addi	a0,a0,1132 # 80008368 <states.0+0x120>
    80001f04:	00004097          	auipc	ra,0x4
    80001f08:	e82080e7          	jalr	-382(ra) # 80005d86 <printf>
    panic("kerneltrap");
    80001f0c:	00006517          	auipc	a0,0x6
    80001f10:	47450513          	addi	a0,a0,1140 # 80008380 <states.0+0x138>
    80001f14:	00004097          	auipc	ra,0x4
    80001f18:	e28080e7          	jalr	-472(ra) # 80005d3c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	f86080e7          	jalr	-122(ra) # 80000ea2 <myproc>
    80001f24:	d541                	beqz	a0,80001eac <kerneltrap+0x38>
    80001f26:	fffff097          	auipc	ra,0xfffff
    80001f2a:	f7c080e7          	jalr	-132(ra) # 80000ea2 <myproc>
    80001f2e:	5118                	lw	a4,32(a0)
    80001f30:	4791                	li	a5,4
    80001f32:	f6f71de3          	bne	a4,a5,80001eac <kerneltrap+0x38>
    yield();
    80001f36:	fffff097          	auipc	ra,0xfffff
    80001f3a:	5fa080e7          	jalr	1530(ra) # 80001530 <yield>
    80001f3e:	b7bd                	j	80001eac <kerneltrap+0x38>

0000000080001f40 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f40:	1101                	addi	sp,sp,-32
    80001f42:	ec06                	sd	ra,24(sp)
    80001f44:	e822                	sd	s0,16(sp)
    80001f46:	e426                	sd	s1,8(sp)
    80001f48:	1000                	addi	s0,sp,32
    80001f4a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	f56080e7          	jalr	-170(ra) # 80000ea2 <myproc>
  switch (n) {
    80001f54:	4795                	li	a5,5
    80001f56:	0497e163          	bltu	a5,s1,80001f98 <argraw+0x58>
    80001f5a:	048a                	slli	s1,s1,0x2
    80001f5c:	00006717          	auipc	a4,0x6
    80001f60:	5dc70713          	addi	a4,a4,1500 # 80008538 <states.0+0x2f0>
    80001f64:	94ba                	add	s1,s1,a4
    80001f66:	409c                	lw	a5,0(s1)
    80001f68:	97ba                	add	a5,a5,a4
    80001f6a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f6c:	713c                	ld	a5,96(a0)
    80001f6e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f70:	60e2                	ld	ra,24(sp)
    80001f72:	6442                	ld	s0,16(sp)
    80001f74:	64a2                	ld	s1,8(sp)
    80001f76:	6105                	addi	sp,sp,32
    80001f78:	8082                	ret
    return p->trapframe->a1;
    80001f7a:	713c                	ld	a5,96(a0)
    80001f7c:	7fa8                	ld	a0,120(a5)
    80001f7e:	bfcd                	j	80001f70 <argraw+0x30>
    return p->trapframe->a2;
    80001f80:	713c                	ld	a5,96(a0)
    80001f82:	63c8                	ld	a0,128(a5)
    80001f84:	b7f5                	j	80001f70 <argraw+0x30>
    return p->trapframe->a3;
    80001f86:	713c                	ld	a5,96(a0)
    80001f88:	67c8                	ld	a0,136(a5)
    80001f8a:	b7dd                	j	80001f70 <argraw+0x30>
    return p->trapframe->a4;
    80001f8c:	713c                	ld	a5,96(a0)
    80001f8e:	6bc8                	ld	a0,144(a5)
    80001f90:	b7c5                	j	80001f70 <argraw+0x30>
    return p->trapframe->a5;
    80001f92:	713c                	ld	a5,96(a0)
    80001f94:	6fc8                	ld	a0,152(a5)
    80001f96:	bfe9                	j	80001f70 <argraw+0x30>
  panic("argraw");
    80001f98:	00006517          	auipc	a0,0x6
    80001f9c:	3f850513          	addi	a0,a0,1016 # 80008390 <states.0+0x148>
    80001fa0:	00004097          	auipc	ra,0x4
    80001fa4:	d9c080e7          	jalr	-612(ra) # 80005d3c <panic>

0000000080001fa8 <fetchaddr>:
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	e04a                	sd	s2,0(sp)
    80001fb2:	1000                	addi	s0,sp,32
    80001fb4:	84aa                	mv	s1,a0
    80001fb6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fb8:	fffff097          	auipc	ra,0xfffff
    80001fbc:	eea080e7          	jalr	-278(ra) # 80000ea2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fc0:	693c                	ld	a5,80(a0)
    80001fc2:	02f4f863          	bgeu	s1,a5,80001ff2 <fetchaddr+0x4a>
    80001fc6:	00848713          	addi	a4,s1,8
    80001fca:	02e7e663          	bltu	a5,a4,80001ff6 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fce:	46a1                	li	a3,8
    80001fd0:	8626                	mv	a2,s1
    80001fd2:	85ca                	mv	a1,s2
    80001fd4:	6d28                	ld	a0,88(a0)
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	c16080e7          	jalr	-1002(ra) # 80000bec <copyin>
    80001fde:	00a03533          	snez	a0,a0
    80001fe2:	40a00533          	neg	a0,a0
}
    80001fe6:	60e2                	ld	ra,24(sp)
    80001fe8:	6442                	ld	s0,16(sp)
    80001fea:	64a2                	ld	s1,8(sp)
    80001fec:	6902                	ld	s2,0(sp)
    80001fee:	6105                	addi	sp,sp,32
    80001ff0:	8082                	ret
    return -1;
    80001ff2:	557d                	li	a0,-1
    80001ff4:	bfcd                	j	80001fe6 <fetchaddr+0x3e>
    80001ff6:	557d                	li	a0,-1
    80001ff8:	b7fd                	j	80001fe6 <fetchaddr+0x3e>

0000000080001ffa <fetchstr>:
{
    80001ffa:	7179                	addi	sp,sp,-48
    80001ffc:	f406                	sd	ra,40(sp)
    80001ffe:	f022                	sd	s0,32(sp)
    80002000:	ec26                	sd	s1,24(sp)
    80002002:	e84a                	sd	s2,16(sp)
    80002004:	e44e                	sd	s3,8(sp)
    80002006:	1800                	addi	s0,sp,48
    80002008:	892a                	mv	s2,a0
    8000200a:	84ae                	mv	s1,a1
    8000200c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    8000200e:	fffff097          	auipc	ra,0xfffff
    80002012:	e94080e7          	jalr	-364(ra) # 80000ea2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002016:	86ce                	mv	a3,s3
    80002018:	864a                	mv	a2,s2
    8000201a:	85a6                	mv	a1,s1
    8000201c:	6d28                	ld	a0,88(a0)
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	c5c080e7          	jalr	-932(ra) # 80000c7a <copyinstr>
    80002026:	00054e63          	bltz	a0,80002042 <fetchstr+0x48>
  return strlen(buf);
    8000202a:	8526                	mv	a0,s1
    8000202c:	ffffe097          	auipc	ra,0xffffe
    80002030:	316080e7          	jalr	790(ra) # 80000342 <strlen>
}
    80002034:	70a2                	ld	ra,40(sp)
    80002036:	7402                	ld	s0,32(sp)
    80002038:	64e2                	ld	s1,24(sp)
    8000203a:	6942                	ld	s2,16(sp)
    8000203c:	69a2                	ld	s3,8(sp)
    8000203e:	6145                	addi	sp,sp,48
    80002040:	8082                	ret
    return -1;
    80002042:	557d                	li	a0,-1
    80002044:	bfc5                	j	80002034 <fetchstr+0x3a>

0000000080002046 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002046:	1101                	addi	sp,sp,-32
    80002048:	ec06                	sd	ra,24(sp)
    8000204a:	e822                	sd	s0,16(sp)
    8000204c:	e426                	sd	s1,8(sp)
    8000204e:	1000                	addi	s0,sp,32
    80002050:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002052:	00000097          	auipc	ra,0x0
    80002056:	eee080e7          	jalr	-274(ra) # 80001f40 <argraw>
    8000205a:	c088                	sw	a0,0(s1)
}
    8000205c:	60e2                	ld	ra,24(sp)
    8000205e:	6442                	ld	s0,16(sp)
    80002060:	64a2                	ld	s1,8(sp)
    80002062:	6105                	addi	sp,sp,32
    80002064:	8082                	ret

0000000080002066 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002066:	1101                	addi	sp,sp,-32
    80002068:	ec06                	sd	ra,24(sp)
    8000206a:	e822                	sd	s0,16(sp)
    8000206c:	e426                	sd	s1,8(sp)
    8000206e:	1000                	addi	s0,sp,32
    80002070:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002072:	00000097          	auipc	ra,0x0
    80002076:	ece080e7          	jalr	-306(ra) # 80001f40 <argraw>
    8000207a:	e088                	sd	a0,0(s1)
}
    8000207c:	60e2                	ld	ra,24(sp)
    8000207e:	6442                	ld	s0,16(sp)
    80002080:	64a2                	ld	s1,8(sp)
    80002082:	6105                	addi	sp,sp,32
    80002084:	8082                	ret

0000000080002086 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	1800                	addi	s0,sp,48
    80002092:	84ae                	mv	s1,a1
    80002094:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002096:	fd840593          	addi	a1,s0,-40
    8000209a:	00000097          	auipc	ra,0x0
    8000209e:	fcc080e7          	jalr	-52(ra) # 80002066 <argaddr>
  return fetchstr(addr, buf, max);
    800020a2:	864a                	mv	a2,s2
    800020a4:	85a6                	mv	a1,s1
    800020a6:	fd843503          	ld	a0,-40(s0)
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	f50080e7          	jalr	-176(ra) # 80001ffa <fetchstr>
}
    800020b2:	70a2                	ld	ra,40(sp)
    800020b4:	7402                	ld	s0,32(sp)
    800020b6:	64e2                	ld	s1,24(sp)
    800020b8:	6942                	ld	s2,16(sp)
    800020ba:	6145                	addi	sp,sp,48
    800020bc:	8082                	ret

00000000800020be <syscall>:
};


void
syscall(void)
{
    800020be:	7179                	addi	sp,sp,-48
    800020c0:	f406                	sd	ra,40(sp)
    800020c2:	f022                	sd	s0,32(sp)
    800020c4:	ec26                	sd	s1,24(sp)
    800020c6:	e84a                	sd	s2,16(sp)
    800020c8:	e44e                	sd	s3,8(sp)
    800020ca:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	dd6080e7          	jalr	-554(ra) # 80000ea2 <myproc>
    800020d4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800020d6:	06053903          	ld	s2,96(a0)
    800020da:	0a893783          	ld	a5,168(s2)
    800020de:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800020e2:	37fd                	addiw	a5,a5,-1
    800020e4:	4759                	li	a4,22
    800020e6:	04f76563          	bltu	a4,a5,80002130 <syscall+0x72>
    800020ea:	00399713          	slli	a4,s3,0x3
    800020ee:	00006797          	auipc	a5,0x6
    800020f2:	46278793          	addi	a5,a5,1122 # 80008550 <syscalls>
    800020f6:	97ba                	add	a5,a5,a4
    800020f8:	639c                	ld	a5,0(a5)
    800020fa:	cb9d                	beqz	a5,80002130 <syscall+0x72>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020fc:	9782                	jalr	a5
    800020fe:	06a93823          	sd	a0,112(s2)
    if (p->mask >> num) {
    80002102:	609c                	ld	a5,0(s1)
    80002104:	0137d7b3          	srl	a5,a5,s3
    80002108:	c3b9                	beqz	a5,8000214e <syscall+0x90>
      printf("%d: %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    8000210a:	70b8                	ld	a4,96(s1)
    8000210c:	098e                	slli	s3,s3,0x3
    8000210e:	00006797          	auipc	a5,0x6
    80002112:	44278793          	addi	a5,a5,1090 # 80008550 <syscalls>
    80002116:	97ce                	add	a5,a5,s3
    80002118:	7b34                	ld	a3,112(a4)
    8000211a:	63f0                	ld	a2,192(a5)
    8000211c:	5c8c                	lw	a1,56(s1)
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	27a50513          	addi	a0,a0,634 # 80008398 <states.0+0x150>
    80002126:	00004097          	auipc	ra,0x4
    8000212a:	c60080e7          	jalr	-928(ra) # 80005d86 <printf>
    8000212e:	a005                	j	8000214e <syscall+0x90>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002130:	86ce                	mv	a3,s3
    80002132:	16048613          	addi	a2,s1,352
    80002136:	5c8c                	lw	a1,56(s1)
    80002138:	00006517          	auipc	a0,0x6
    8000213c:	27050513          	addi	a0,a0,624 # 800083a8 <states.0+0x160>
    80002140:	00004097          	auipc	ra,0x4
    80002144:	c46080e7          	jalr	-954(ra) # 80005d86 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002148:	70bc                	ld	a5,96(s1)
    8000214a:	577d                	li	a4,-1
    8000214c:	fbb8                	sd	a4,112(a5)
  }
}
    8000214e:	70a2                	ld	ra,40(sp)
    80002150:	7402                	ld	s0,32(sp)
    80002152:	64e2                	ld	s1,24(sp)
    80002154:	6942                	ld	s2,16(sp)
    80002156:	69a2                	ld	s3,8(sp)
    80002158:	6145                	addi	sp,sp,48
    8000215a:	8082                	ret

000000008000215c <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002164:	fec40593          	addi	a1,s0,-20
    80002168:	4501                	li	a0,0
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	edc080e7          	jalr	-292(ra) # 80002046 <argint>
  exit(n);
    80002172:	fec42503          	lw	a0,-20(s0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	546080e7          	jalr	1350(ra) # 800016bc <exit>
  return 0;  // not reached
}
    8000217e:	4501                	li	a0,0
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	6105                	addi	sp,sp,32
    80002186:	8082                	ret

0000000080002188 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002188:	1141                	addi	sp,sp,-16
    8000218a:	e406                	sd	ra,8(sp)
    8000218c:	e022                	sd	s0,0(sp)
    8000218e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	d12080e7          	jalr	-750(ra) # 80000ea2 <myproc>
}
    80002198:	5d08                	lw	a0,56(a0)
    8000219a:	60a2                	ld	ra,8(sp)
    8000219c:	6402                	ld	s0,0(sp)
    8000219e:	0141                	addi	sp,sp,16
    800021a0:	8082                	ret

00000000800021a2 <sys_fork>:

uint64
sys_fork(void)
{
    800021a2:	1141                	addi	sp,sp,-16
    800021a4:	e406                	sd	ra,8(sp)
    800021a6:	e022                	sd	s0,0(sp)
    800021a8:	0800                	addi	s0,sp,16
  return fork();
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	0ba080e7          	jalr	186(ra) # 80001264 <fork>
}
    800021b2:	60a2                	ld	ra,8(sp)
    800021b4:	6402                	ld	s0,0(sp)
    800021b6:	0141                	addi	sp,sp,16
    800021b8:	8082                	ret

00000000800021ba <sys_wait>:

uint64
sys_wait(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021c2:	fe840593          	addi	a1,s0,-24
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	e9e080e7          	jalr	-354(ra) # 80002066 <argaddr>
  return wait(p);
    800021d0:	fe843503          	ld	a0,-24(s0)
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	6a6080e7          	jalr	1702(ra) # 8000187a <wait>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021e4:	7179                	addi	sp,sp,-48
    800021e6:	f406                	sd	ra,40(sp)
    800021e8:	f022                	sd	s0,32(sp)
    800021ea:	ec26                	sd	s1,24(sp)
    800021ec:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021ee:	fdc40593          	addi	a1,s0,-36
    800021f2:	4501                	li	a0,0
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	e52080e7          	jalr	-430(ra) # 80002046 <argint>
  addr = myproc()->sz;
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	ca6080e7          	jalr	-858(ra) # 80000ea2 <myproc>
    80002204:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    80002206:	fdc42503          	lw	a0,-36(s0)
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	ffe080e7          	jalr	-2(ra) # 80001208 <growproc>
    80002212:	00054863          	bltz	a0,80002222 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002216:	8526                	mv	a0,s1
    80002218:	70a2                	ld	ra,40(sp)
    8000221a:	7402                	ld	s0,32(sp)
    8000221c:	64e2                	ld	s1,24(sp)
    8000221e:	6145                	addi	sp,sp,48
    80002220:	8082                	ret
    return -1;
    80002222:	54fd                	li	s1,-1
    80002224:	bfcd                	j	80002216 <sys_sbrk+0x32>

0000000080002226 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002226:	7139                	addi	sp,sp,-64
    80002228:	fc06                	sd	ra,56(sp)
    8000222a:	f822                	sd	s0,48(sp)
    8000222c:	f426                	sd	s1,40(sp)
    8000222e:	f04a                	sd	s2,32(sp)
    80002230:	ec4e                	sd	s3,24(sp)
    80002232:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002234:	fcc40593          	addi	a1,s0,-52
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	e0c080e7          	jalr	-500(ra) # 80002046 <argint>
  if(n < 0)
    80002242:	fcc42783          	lw	a5,-52(s0)
    80002246:	0607cf63          	bltz	a5,800022c4 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000224a:	0000d517          	auipc	a0,0xd
    8000224e:	93650513          	addi	a0,a0,-1738 # 8000eb80 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	022080e7          	jalr	34(ra) # 80006274 <acquire>
  ticks0 = ticks;
    8000225a:	00007917          	auipc	s2,0x7
    8000225e:	8be92903          	lw	s2,-1858(s2) # 80008b18 <ticks>
  while(ticks - ticks0 < n){
    80002262:	fcc42783          	lw	a5,-52(s0)
    80002266:	cf9d                	beqz	a5,800022a4 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002268:	0000d997          	auipc	s3,0xd
    8000226c:	91898993          	addi	s3,s3,-1768 # 8000eb80 <tickslock>
    80002270:	00007497          	auipc	s1,0x7
    80002274:	8a848493          	addi	s1,s1,-1880 # 80008b18 <ticks>
    if(killed(myproc())){
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	c2a080e7          	jalr	-982(ra) # 80000ea2 <myproc>
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	5c4080e7          	jalr	1476(ra) # 80001844 <killed>
    80002288:	e129                	bnez	a0,800022ca <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000228a:	85ce                	mv	a1,s3
    8000228c:	8526                	mv	a0,s1
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	2e8080e7          	jalr	744(ra) # 80001576 <sleep>
  while(ticks - ticks0 < n){
    80002296:	409c                	lw	a5,0(s1)
    80002298:	412787bb          	subw	a5,a5,s2
    8000229c:	fcc42703          	lw	a4,-52(s0)
    800022a0:	fce7ece3          	bltu	a5,a4,80002278 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022a4:	0000d517          	auipc	a0,0xd
    800022a8:	8dc50513          	addi	a0,a0,-1828 # 8000eb80 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	07c080e7          	jalr	124(ra) # 80006328 <release>
  return 0;
    800022b4:	4501                	li	a0,0
}
    800022b6:	70e2                	ld	ra,56(sp)
    800022b8:	7442                	ld	s0,48(sp)
    800022ba:	74a2                	ld	s1,40(sp)
    800022bc:	7902                	ld	s2,32(sp)
    800022be:	69e2                	ld	s3,24(sp)
    800022c0:	6121                	addi	sp,sp,64
    800022c2:	8082                	ret
    n = 0;
    800022c4:	fc042623          	sw	zero,-52(s0)
    800022c8:	b749                	j	8000224a <sys_sleep+0x24>
      release(&tickslock);
    800022ca:	0000d517          	auipc	a0,0xd
    800022ce:	8b650513          	addi	a0,a0,-1866 # 8000eb80 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	056080e7          	jalr	86(ra) # 80006328 <release>
      return -1;
    800022da:	557d                	li	a0,-1
    800022dc:	bfe9                	j	800022b6 <sys_sleep+0x90>

00000000800022de <sys_kill>:

uint64
sys_kill(void)
{
    800022de:	1101                	addi	sp,sp,-32
    800022e0:	ec06                	sd	ra,24(sp)
    800022e2:	e822                	sd	s0,16(sp)
    800022e4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022e6:	fec40593          	addi	a1,s0,-20
    800022ea:	4501                	li	a0,0
    800022ec:	00000097          	auipc	ra,0x0
    800022f0:	d5a080e7          	jalr	-678(ra) # 80002046 <argint>
  return kill(pid);
    800022f4:	fec42503          	lw	a0,-20(s0)
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	49c080e7          	jalr	1180(ra) # 80001794 <kill>
}
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002308:	1101                	addi	sp,sp,-32
    8000230a:	ec06                	sd	ra,24(sp)
    8000230c:	e822                	sd	s0,16(sp)
    8000230e:	e426                	sd	s1,8(sp)
    80002310:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002312:	0000d517          	auipc	a0,0xd
    80002316:	86e50513          	addi	a0,a0,-1938 # 8000eb80 <tickslock>
    8000231a:	00004097          	auipc	ra,0x4
    8000231e:	f5a080e7          	jalr	-166(ra) # 80006274 <acquire>
  xticks = ticks;
    80002322:	00006497          	auipc	s1,0x6
    80002326:	7f64a483          	lw	s1,2038(s1) # 80008b18 <ticks>
  release(&tickslock);
    8000232a:	0000d517          	auipc	a0,0xd
    8000232e:	85650513          	addi	a0,a0,-1962 # 8000eb80 <tickslock>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	ff6080e7          	jalr	-10(ra) # 80006328 <release>
  return xticks;
}
    8000233a:	02049513          	slli	a0,s1,0x20
    8000233e:	9101                	srli	a0,a0,0x20
    80002340:	60e2                	ld	ra,24(sp)
    80002342:	6442                	ld	s0,16(sp)
    80002344:	64a2                	ld	s1,8(sp)
    80002346:	6105                	addi	sp,sp,32
    80002348:	8082                	ret

000000008000234a <sys_trace>:


uint64
sys_trace(void)
{
    8000234a:	1101                	addi	sp,sp,-32
    8000234c:	ec06                	sd	ra,24(sp)
    8000234e:	e822                	sd	s0,16(sp)
    80002350:	1000                	addi	s0,sp,32
  int mask=0;
    80002352:	fe042623          	sw	zero,-20(s0)
  argint(0, &mask);
    80002356:	fec40593          	addi	a1,s0,-20
    8000235a:	4501                	li	a0,0
    8000235c:	00000097          	auipc	ra,0x0
    80002360:	cea080e7          	jalr	-790(ra) # 80002046 <argint>
  
  struct proc *p = myproc();
    80002364:	fffff097          	auipc	ra,0xfffff
    80002368:	b3e080e7          	jalr	-1218(ra) # 80000ea2 <myproc>
  p->mask = mask;
    8000236c:	fec42783          	lw	a5,-20(s0)
    80002370:	e11c                	sd	a5,0(a0)
  return 0;
}
    80002372:	4501                	li	a0,0
    80002374:	60e2                	ld	ra,24(sp)
    80002376:	6442                	ld	s0,16(sp)
    80002378:	6105                	addi	sp,sp,32
    8000237a:	8082                	ret

000000008000237c <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    8000237c:	7139                	addi	sp,sp,-64
    8000237e:	fc06                	sd	ra,56(sp)
    80002380:	f822                	sd	s0,48(sp)
    80002382:	f426                	sd	s1,40(sp)
    80002384:	f04a                	sd	s2,32(sp)
    80002386:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	b1a080e7          	jalr	-1254(ra) # 80000ea2 <myproc>
    80002390:	84aa                	mv	s1,a0

  // user pointer to struct sysinfo
  uint64 dstva;

  argaddr(0, &dstva);
    80002392:	fd840593          	addi	a1,s0,-40
    80002396:	4501                	li	a0,0
    80002398:	00000097          	auipc	ra,0x0
    8000239c:	cce080e7          	jalr	-818(ra) # 80002066 <argaddr>
  int procnum;
  int freemem;

  procnum = freeprocesses();
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	76c080e7          	jalr	1900(ra) # 80001b0c <freeprocesses>
    800023a8:	892a                	mv	s2,a0
  freemem = freememsize();
    800023aa:	ffffe097          	auipc	ra,0xffffe
    800023ae:	dd0080e7          	jalr	-560(ra) # 8000017a <freememsize>

  struct sysinfo sysinfo;
  sysinfo.freemem = freemem;
    800023b2:	fca43423          	sd	a0,-56(s0)
  sysinfo.nproc = procnum;
    800023b6:	fd243823          	sd	s2,-48(s0)

  if (copyout(p->pagetable, dstva, (char *)&sysinfo, sizeof(sysinfo)) < 0)
    800023ba:	46c1                	li	a3,16
    800023bc:	fc840613          	addi	a2,s0,-56
    800023c0:	fd843583          	ld	a1,-40(s0)
    800023c4:	6ca8                	ld	a0,88(s1)
    800023c6:	ffffe097          	auipc	ra,0xffffe
    800023ca:	79a080e7          	jalr	1946(ra) # 80000b60 <copyout>
    return -1;

  return 0;
}
    800023ce:	957d                	srai	a0,a0,0x3f
    800023d0:	70e2                	ld	ra,56(sp)
    800023d2:	7442                	ld	s0,48(sp)
    800023d4:	74a2                	ld	s1,40(sp)
    800023d6:	7902                	ld	s2,32(sp)
    800023d8:	6121                	addi	sp,sp,64
    800023da:	8082                	ret

00000000800023dc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023dc:	7179                	addi	sp,sp,-48
    800023de:	f406                	sd	ra,40(sp)
    800023e0:	f022                	sd	s0,32(sp)
    800023e2:	ec26                	sd	s1,24(sp)
    800023e4:	e84a                	sd	s2,16(sp)
    800023e6:	e44e                	sd	s3,8(sp)
    800023e8:	e052                	sd	s4,0(sp)
    800023ea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023ec:	00006597          	auipc	a1,0x6
    800023f0:	2e458593          	addi	a1,a1,740 # 800086d0 <syscalls_name+0xc0>
    800023f4:	0000c517          	auipc	a0,0xc
    800023f8:	7a450513          	addi	a0,a0,1956 # 8000eb98 <bcache>
    800023fc:	00004097          	auipc	ra,0x4
    80002400:	de8080e7          	jalr	-536(ra) # 800061e4 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002404:	00014797          	auipc	a5,0x14
    80002408:	79478793          	addi	a5,a5,1940 # 80016b98 <bcache+0x8000>
    8000240c:	00015717          	auipc	a4,0x15
    80002410:	9f470713          	addi	a4,a4,-1548 # 80016e00 <bcache+0x8268>
    80002414:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002418:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000241c:	0000c497          	auipc	s1,0xc
    80002420:	79448493          	addi	s1,s1,1940 # 8000ebb0 <bcache+0x18>
    b->next = bcache.head.next;
    80002424:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002426:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002428:	00006a17          	auipc	s4,0x6
    8000242c:	2b0a0a13          	addi	s4,s4,688 # 800086d8 <syscalls_name+0xc8>
    b->next = bcache.head.next;
    80002430:	2b893783          	ld	a5,696(s2)
    80002434:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002436:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000243a:	85d2                	mv	a1,s4
    8000243c:	01048513          	addi	a0,s1,16
    80002440:	00001097          	auipc	ra,0x1
    80002444:	4c8080e7          	jalr	1224(ra) # 80003908 <initsleeplock>
    bcache.head.next->prev = b;
    80002448:	2b893783          	ld	a5,696(s2)
    8000244c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000244e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002452:	45848493          	addi	s1,s1,1112
    80002456:	fd349de3          	bne	s1,s3,80002430 <binit+0x54>
  }
}
    8000245a:	70a2                	ld	ra,40(sp)
    8000245c:	7402                	ld	s0,32(sp)
    8000245e:	64e2                	ld	s1,24(sp)
    80002460:	6942                	ld	s2,16(sp)
    80002462:	69a2                	ld	s3,8(sp)
    80002464:	6a02                	ld	s4,0(sp)
    80002466:	6145                	addi	sp,sp,48
    80002468:	8082                	ret

000000008000246a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000246a:	7179                	addi	sp,sp,-48
    8000246c:	f406                	sd	ra,40(sp)
    8000246e:	f022                	sd	s0,32(sp)
    80002470:	ec26                	sd	s1,24(sp)
    80002472:	e84a                	sd	s2,16(sp)
    80002474:	e44e                	sd	s3,8(sp)
    80002476:	1800                	addi	s0,sp,48
    80002478:	892a                	mv	s2,a0
    8000247a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000247c:	0000c517          	auipc	a0,0xc
    80002480:	71c50513          	addi	a0,a0,1820 # 8000eb98 <bcache>
    80002484:	00004097          	auipc	ra,0x4
    80002488:	df0080e7          	jalr	-528(ra) # 80006274 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000248c:	00015497          	auipc	s1,0x15
    80002490:	9c44b483          	ld	s1,-1596(s1) # 80016e50 <bcache+0x82b8>
    80002494:	00015797          	auipc	a5,0x15
    80002498:	96c78793          	addi	a5,a5,-1684 # 80016e00 <bcache+0x8268>
    8000249c:	02f48f63          	beq	s1,a5,800024da <bread+0x70>
    800024a0:	873e                	mv	a4,a5
    800024a2:	a021                	j	800024aa <bread+0x40>
    800024a4:	68a4                	ld	s1,80(s1)
    800024a6:	02e48a63          	beq	s1,a4,800024da <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024aa:	449c                	lw	a5,8(s1)
    800024ac:	ff279ce3          	bne	a5,s2,800024a4 <bread+0x3a>
    800024b0:	44dc                	lw	a5,12(s1)
    800024b2:	ff3799e3          	bne	a5,s3,800024a4 <bread+0x3a>
      b->refcnt++;
    800024b6:	40bc                	lw	a5,64(s1)
    800024b8:	2785                	addiw	a5,a5,1
    800024ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024bc:	0000c517          	auipc	a0,0xc
    800024c0:	6dc50513          	addi	a0,a0,1756 # 8000eb98 <bcache>
    800024c4:	00004097          	auipc	ra,0x4
    800024c8:	e64080e7          	jalr	-412(ra) # 80006328 <release>
      acquiresleep(&b->lock);
    800024cc:	01048513          	addi	a0,s1,16
    800024d0:	00001097          	auipc	ra,0x1
    800024d4:	472080e7          	jalr	1138(ra) # 80003942 <acquiresleep>
      return b;
    800024d8:	a8b9                	j	80002536 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024da:	00015497          	auipc	s1,0x15
    800024de:	96e4b483          	ld	s1,-1682(s1) # 80016e48 <bcache+0x82b0>
    800024e2:	00015797          	auipc	a5,0x15
    800024e6:	91e78793          	addi	a5,a5,-1762 # 80016e00 <bcache+0x8268>
    800024ea:	00f48863          	beq	s1,a5,800024fa <bread+0x90>
    800024ee:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024f0:	40bc                	lw	a5,64(s1)
    800024f2:	cf81                	beqz	a5,8000250a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024f4:	64a4                	ld	s1,72(s1)
    800024f6:	fee49de3          	bne	s1,a4,800024f0 <bread+0x86>
  panic("bget: no buffers");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	1e650513          	addi	a0,a0,486 # 800086e0 <syscalls_name+0xd0>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	83a080e7          	jalr	-1990(ra) # 80005d3c <panic>
      b->dev = dev;
    8000250a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000250e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002512:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002516:	4785                	li	a5,1
    80002518:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000251a:	0000c517          	auipc	a0,0xc
    8000251e:	67e50513          	addi	a0,a0,1662 # 8000eb98 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	e06080e7          	jalr	-506(ra) # 80006328 <release>
      acquiresleep(&b->lock);
    8000252a:	01048513          	addi	a0,s1,16
    8000252e:	00001097          	auipc	ra,0x1
    80002532:	414080e7          	jalr	1044(ra) # 80003942 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002536:	409c                	lw	a5,0(s1)
    80002538:	cb89                	beqz	a5,8000254a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000253a:	8526                	mv	a0,s1
    8000253c:	70a2                	ld	ra,40(sp)
    8000253e:	7402                	ld	s0,32(sp)
    80002540:	64e2                	ld	s1,24(sp)
    80002542:	6942                	ld	s2,16(sp)
    80002544:	69a2                	ld	s3,8(sp)
    80002546:	6145                	addi	sp,sp,48
    80002548:	8082                	ret
    virtio_disk_rw(b, 0);
    8000254a:	4581                	li	a1,0
    8000254c:	8526                	mv	a0,s1
    8000254e:	00003097          	auipc	ra,0x3
    80002552:	fe4080e7          	jalr	-28(ra) # 80005532 <virtio_disk_rw>
    b->valid = 1;
    80002556:	4785                	li	a5,1
    80002558:	c09c                	sw	a5,0(s1)
  return b;
    8000255a:	b7c5                	j	8000253a <bread+0xd0>

000000008000255c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	e426                	sd	s1,8(sp)
    80002564:	1000                	addi	s0,sp,32
    80002566:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002568:	0541                	addi	a0,a0,16
    8000256a:	00001097          	auipc	ra,0x1
    8000256e:	472080e7          	jalr	1138(ra) # 800039dc <holdingsleep>
    80002572:	cd01                	beqz	a0,8000258a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002574:	4585                	li	a1,1
    80002576:	8526                	mv	a0,s1
    80002578:	00003097          	auipc	ra,0x3
    8000257c:	fba080e7          	jalr	-70(ra) # 80005532 <virtio_disk_rw>
}
    80002580:	60e2                	ld	ra,24(sp)
    80002582:	6442                	ld	s0,16(sp)
    80002584:	64a2                	ld	s1,8(sp)
    80002586:	6105                	addi	sp,sp,32
    80002588:	8082                	ret
    panic("bwrite");
    8000258a:	00006517          	auipc	a0,0x6
    8000258e:	16e50513          	addi	a0,a0,366 # 800086f8 <syscalls_name+0xe8>
    80002592:	00003097          	auipc	ra,0x3
    80002596:	7aa080e7          	jalr	1962(ra) # 80005d3c <panic>

000000008000259a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000259a:	1101                	addi	sp,sp,-32
    8000259c:	ec06                	sd	ra,24(sp)
    8000259e:	e822                	sd	s0,16(sp)
    800025a0:	e426                	sd	s1,8(sp)
    800025a2:	e04a                	sd	s2,0(sp)
    800025a4:	1000                	addi	s0,sp,32
    800025a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a8:	01050913          	addi	s2,a0,16
    800025ac:	854a                	mv	a0,s2
    800025ae:	00001097          	auipc	ra,0x1
    800025b2:	42e080e7          	jalr	1070(ra) # 800039dc <holdingsleep>
    800025b6:	c92d                	beqz	a0,80002628 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b8:	854a                	mv	a0,s2
    800025ba:	00001097          	auipc	ra,0x1
    800025be:	3de080e7          	jalr	990(ra) # 80003998 <releasesleep>

  acquire(&bcache.lock);
    800025c2:	0000c517          	auipc	a0,0xc
    800025c6:	5d650513          	addi	a0,a0,1494 # 8000eb98 <bcache>
    800025ca:	00004097          	auipc	ra,0x4
    800025ce:	caa080e7          	jalr	-854(ra) # 80006274 <acquire>
  b->refcnt--;
    800025d2:	40bc                	lw	a5,64(s1)
    800025d4:	37fd                	addiw	a5,a5,-1
    800025d6:	0007871b          	sext.w	a4,a5
    800025da:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025dc:	eb05                	bnez	a4,8000260c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025de:	68bc                	ld	a5,80(s1)
    800025e0:	64b8                	ld	a4,72(s1)
    800025e2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025e4:	64bc                	ld	a5,72(s1)
    800025e6:	68b8                	ld	a4,80(s1)
    800025e8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025ea:	00014797          	auipc	a5,0x14
    800025ee:	5ae78793          	addi	a5,a5,1454 # 80016b98 <bcache+0x8000>
    800025f2:	2b87b703          	ld	a4,696(a5)
    800025f6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f8:	00015717          	auipc	a4,0x15
    800025fc:	80870713          	addi	a4,a4,-2040 # 80016e00 <bcache+0x8268>
    80002600:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002602:	2b87b703          	ld	a4,696(a5)
    80002606:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002608:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000260c:	0000c517          	auipc	a0,0xc
    80002610:	58c50513          	addi	a0,a0,1420 # 8000eb98 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	d14080e7          	jalr	-748(ra) # 80006328 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6902                	ld	s2,0(sp)
    80002624:	6105                	addi	sp,sp,32
    80002626:	8082                	ret
    panic("brelse");
    80002628:	00006517          	auipc	a0,0x6
    8000262c:	0d850513          	addi	a0,a0,216 # 80008700 <syscalls_name+0xf0>
    80002630:	00003097          	auipc	ra,0x3
    80002634:	70c080e7          	jalr	1804(ra) # 80005d3c <panic>

0000000080002638 <bpin>:

void
bpin(struct buf *b) {
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	1000                	addi	s0,sp,32
    80002642:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002644:	0000c517          	auipc	a0,0xc
    80002648:	55450513          	addi	a0,a0,1364 # 8000eb98 <bcache>
    8000264c:	00004097          	auipc	ra,0x4
    80002650:	c28080e7          	jalr	-984(ra) # 80006274 <acquire>
  b->refcnt++;
    80002654:	40bc                	lw	a5,64(s1)
    80002656:	2785                	addiw	a5,a5,1
    80002658:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000265a:	0000c517          	auipc	a0,0xc
    8000265e:	53e50513          	addi	a0,a0,1342 # 8000eb98 <bcache>
    80002662:	00004097          	auipc	ra,0x4
    80002666:	cc6080e7          	jalr	-826(ra) # 80006328 <release>
}
    8000266a:	60e2                	ld	ra,24(sp)
    8000266c:	6442                	ld	s0,16(sp)
    8000266e:	64a2                	ld	s1,8(sp)
    80002670:	6105                	addi	sp,sp,32
    80002672:	8082                	ret

0000000080002674 <bunpin>:

void
bunpin(struct buf *b) {
    80002674:	1101                	addi	sp,sp,-32
    80002676:	ec06                	sd	ra,24(sp)
    80002678:	e822                	sd	s0,16(sp)
    8000267a:	e426                	sd	s1,8(sp)
    8000267c:	1000                	addi	s0,sp,32
    8000267e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002680:	0000c517          	auipc	a0,0xc
    80002684:	51850513          	addi	a0,a0,1304 # 8000eb98 <bcache>
    80002688:	00004097          	auipc	ra,0x4
    8000268c:	bec080e7          	jalr	-1044(ra) # 80006274 <acquire>
  b->refcnt--;
    80002690:	40bc                	lw	a5,64(s1)
    80002692:	37fd                	addiw	a5,a5,-1
    80002694:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002696:	0000c517          	auipc	a0,0xc
    8000269a:	50250513          	addi	a0,a0,1282 # 8000eb98 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	c8a080e7          	jalr	-886(ra) # 80006328 <release>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret

00000000800026b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	e04a                	sd	s2,0(sp)
    800026ba:	1000                	addi	s0,sp,32
    800026bc:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026be:	00d5d59b          	srliw	a1,a1,0xd
    800026c2:	00015797          	auipc	a5,0x15
    800026c6:	bb27a783          	lw	a5,-1102(a5) # 80017274 <sb+0x1c>
    800026ca:	9dbd                	addw	a1,a1,a5
    800026cc:	00000097          	auipc	ra,0x0
    800026d0:	d9e080e7          	jalr	-610(ra) # 8000246a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026d4:	0074f713          	andi	a4,s1,7
    800026d8:	4785                	li	a5,1
    800026da:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026de:	14ce                	slli	s1,s1,0x33
    800026e0:	90d9                	srli	s1,s1,0x36
    800026e2:	00950733          	add	a4,a0,s1
    800026e6:	05874703          	lbu	a4,88(a4)
    800026ea:	00e7f6b3          	and	a3,a5,a4
    800026ee:	c69d                	beqz	a3,8000271c <bfree+0x6c>
    800026f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026f2:	94aa                	add	s1,s1,a0
    800026f4:	fff7c793          	not	a5,a5
    800026f8:	8f7d                	and	a4,a4,a5
    800026fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800026fe:	00001097          	auipc	ra,0x1
    80002702:	126080e7          	jalr	294(ra) # 80003824 <log_write>
  brelse(bp);
    80002706:	854a                	mv	a0,s2
    80002708:	00000097          	auipc	ra,0x0
    8000270c:	e92080e7          	jalr	-366(ra) # 8000259a <brelse>
}
    80002710:	60e2                	ld	ra,24(sp)
    80002712:	6442                	ld	s0,16(sp)
    80002714:	64a2                	ld	s1,8(sp)
    80002716:	6902                	ld	s2,0(sp)
    80002718:	6105                	addi	sp,sp,32
    8000271a:	8082                	ret
    panic("freeing free block");
    8000271c:	00006517          	auipc	a0,0x6
    80002720:	fec50513          	addi	a0,a0,-20 # 80008708 <syscalls_name+0xf8>
    80002724:	00003097          	auipc	ra,0x3
    80002728:	618080e7          	jalr	1560(ra) # 80005d3c <panic>

000000008000272c <balloc>:
{
    8000272c:	711d                	addi	sp,sp,-96
    8000272e:	ec86                	sd	ra,88(sp)
    80002730:	e8a2                	sd	s0,80(sp)
    80002732:	e4a6                	sd	s1,72(sp)
    80002734:	e0ca                	sd	s2,64(sp)
    80002736:	fc4e                	sd	s3,56(sp)
    80002738:	f852                	sd	s4,48(sp)
    8000273a:	f456                	sd	s5,40(sp)
    8000273c:	f05a                	sd	s6,32(sp)
    8000273e:	ec5e                	sd	s7,24(sp)
    80002740:	e862                	sd	s8,16(sp)
    80002742:	e466                	sd	s9,8(sp)
    80002744:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002746:	00015797          	auipc	a5,0x15
    8000274a:	b167a783          	lw	a5,-1258(a5) # 8001725c <sb+0x4>
    8000274e:	cff5                	beqz	a5,8000284a <balloc+0x11e>
    80002750:	8baa                	mv	s7,a0
    80002752:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002754:	00015b17          	auipc	s6,0x15
    80002758:	b04b0b13          	addi	s6,s6,-1276 # 80017258 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275c:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000275e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002760:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002762:	6c89                	lui	s9,0x2
    80002764:	a061                	j	800027ec <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002766:	97ca                	add	a5,a5,s2
    80002768:	8e55                	or	a2,a2,a3
    8000276a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000276e:	854a                	mv	a0,s2
    80002770:	00001097          	auipc	ra,0x1
    80002774:	0b4080e7          	jalr	180(ra) # 80003824 <log_write>
        brelse(bp);
    80002778:	854a                	mv	a0,s2
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	e20080e7          	jalr	-480(ra) # 8000259a <brelse>
  bp = bread(dev, bno);
    80002782:	85a6                	mv	a1,s1
    80002784:	855e                	mv	a0,s7
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	ce4080e7          	jalr	-796(ra) # 8000246a <bread>
    8000278e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002790:	40000613          	li	a2,1024
    80002794:	4581                	li	a1,0
    80002796:	05850513          	addi	a0,a0,88
    8000279a:	ffffe097          	auipc	ra,0xffffe
    8000279e:	a2c080e7          	jalr	-1492(ra) # 800001c6 <memset>
  log_write(bp);
    800027a2:	854a                	mv	a0,s2
    800027a4:	00001097          	auipc	ra,0x1
    800027a8:	080080e7          	jalr	128(ra) # 80003824 <log_write>
  brelse(bp);
    800027ac:	854a                	mv	a0,s2
    800027ae:	00000097          	auipc	ra,0x0
    800027b2:	dec080e7          	jalr	-532(ra) # 8000259a <brelse>
}
    800027b6:	8526                	mv	a0,s1
    800027b8:	60e6                	ld	ra,88(sp)
    800027ba:	6446                	ld	s0,80(sp)
    800027bc:	64a6                	ld	s1,72(sp)
    800027be:	6906                	ld	s2,64(sp)
    800027c0:	79e2                	ld	s3,56(sp)
    800027c2:	7a42                	ld	s4,48(sp)
    800027c4:	7aa2                	ld	s5,40(sp)
    800027c6:	7b02                	ld	s6,32(sp)
    800027c8:	6be2                	ld	s7,24(sp)
    800027ca:	6c42                	ld	s8,16(sp)
    800027cc:	6ca2                	ld	s9,8(sp)
    800027ce:	6125                	addi	sp,sp,96
    800027d0:	8082                	ret
    brelse(bp);
    800027d2:	854a                	mv	a0,s2
    800027d4:	00000097          	auipc	ra,0x0
    800027d8:	dc6080e7          	jalr	-570(ra) # 8000259a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027dc:	015c87bb          	addw	a5,s9,s5
    800027e0:	00078a9b          	sext.w	s5,a5
    800027e4:	004b2703          	lw	a4,4(s6)
    800027e8:	06eaf163          	bgeu	s5,a4,8000284a <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    800027ec:	41fad79b          	sraiw	a5,s5,0x1f
    800027f0:	0137d79b          	srliw	a5,a5,0x13
    800027f4:	015787bb          	addw	a5,a5,s5
    800027f8:	40d7d79b          	sraiw	a5,a5,0xd
    800027fc:	01cb2583          	lw	a1,28(s6)
    80002800:	9dbd                	addw	a1,a1,a5
    80002802:	855e                	mv	a0,s7
    80002804:	00000097          	auipc	ra,0x0
    80002808:	c66080e7          	jalr	-922(ra) # 8000246a <bread>
    8000280c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000280e:	004b2503          	lw	a0,4(s6)
    80002812:	000a849b          	sext.w	s1,s5
    80002816:	8762                	mv	a4,s8
    80002818:	faa4fde3          	bgeu	s1,a0,800027d2 <balloc+0xa6>
      m = 1 << (bi % 8);
    8000281c:	00777693          	andi	a3,a4,7
    80002820:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002824:	41f7579b          	sraiw	a5,a4,0x1f
    80002828:	01d7d79b          	srliw	a5,a5,0x1d
    8000282c:	9fb9                	addw	a5,a5,a4
    8000282e:	4037d79b          	sraiw	a5,a5,0x3
    80002832:	00f90633          	add	a2,s2,a5
    80002836:	05864603          	lbu	a2,88(a2)
    8000283a:	00c6f5b3          	and	a1,a3,a2
    8000283e:	d585                	beqz	a1,80002766 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002840:	2705                	addiw	a4,a4,1
    80002842:	2485                	addiw	s1,s1,1
    80002844:	fd471ae3          	bne	a4,s4,80002818 <balloc+0xec>
    80002848:	b769                	j	800027d2 <balloc+0xa6>
  printf("balloc: out of blocks\n");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	ed650513          	addi	a0,a0,-298 # 80008720 <syscalls_name+0x110>
    80002852:	00003097          	auipc	ra,0x3
    80002856:	534080e7          	jalr	1332(ra) # 80005d86 <printf>
  return 0;
    8000285a:	4481                	li	s1,0
    8000285c:	bfa9                	j	800027b6 <balloc+0x8a>

000000008000285e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285e:	7179                	addi	sp,sp,-48
    80002860:	f406                	sd	ra,40(sp)
    80002862:	f022                	sd	s0,32(sp)
    80002864:	ec26                	sd	s1,24(sp)
    80002866:	e84a                	sd	s2,16(sp)
    80002868:	e44e                	sd	s3,8(sp)
    8000286a:	e052                	sd	s4,0(sp)
    8000286c:	1800                	addi	s0,sp,48
    8000286e:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002870:	47ad                	li	a5,11
    80002872:	02b7e863          	bltu	a5,a1,800028a2 <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002876:	02059793          	slli	a5,a1,0x20
    8000287a:	01e7d593          	srli	a1,a5,0x1e
    8000287e:	00b504b3          	add	s1,a0,a1
    80002882:	0504a903          	lw	s2,80(s1)
    80002886:	06091e63          	bnez	s2,80002902 <bmap+0xa4>
      addr = balloc(ip->dev);
    8000288a:	4108                	lw	a0,0(a0)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	ea0080e7          	jalr	-352(ra) # 8000272c <balloc>
    80002894:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002898:	06090563          	beqz	s2,80002902 <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    8000289c:	0524a823          	sw	s2,80(s1)
    800028a0:	a08d                	j	80002902 <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    800028a2:	ff45849b          	addiw	s1,a1,-12
    800028a6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028aa:	0ff00793          	li	a5,255
    800028ae:	08e7e563          	bltu	a5,a4,80002938 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028b2:	08052903          	lw	s2,128(a0)
    800028b6:	00091d63          	bnez	s2,800028d0 <bmap+0x72>
      addr = balloc(ip->dev);
    800028ba:	4108                	lw	a0,0(a0)
    800028bc:	00000097          	auipc	ra,0x0
    800028c0:	e70080e7          	jalr	-400(ra) # 8000272c <balloc>
    800028c4:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c8:	02090d63          	beqz	s2,80002902 <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028cc:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028d0:	85ca                	mv	a1,s2
    800028d2:	0009a503          	lw	a0,0(s3)
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	b94080e7          	jalr	-1132(ra) # 8000246a <bread>
    800028de:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028e0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e4:	02049713          	slli	a4,s1,0x20
    800028e8:	01e75593          	srli	a1,a4,0x1e
    800028ec:	00b784b3          	add	s1,a5,a1
    800028f0:	0004a903          	lw	s2,0(s1)
    800028f4:	02090063          	beqz	s2,80002914 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028f8:	8552                	mv	a0,s4
    800028fa:	00000097          	auipc	ra,0x0
    800028fe:	ca0080e7          	jalr	-864(ra) # 8000259a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002902:	854a                	mv	a0,s2
    80002904:	70a2                	ld	ra,40(sp)
    80002906:	7402                	ld	s0,32(sp)
    80002908:	64e2                	ld	s1,24(sp)
    8000290a:	6942                	ld	s2,16(sp)
    8000290c:	69a2                	ld	s3,8(sp)
    8000290e:	6a02                	ld	s4,0(sp)
    80002910:	6145                	addi	sp,sp,48
    80002912:	8082                	ret
      addr = balloc(ip->dev);
    80002914:	0009a503          	lw	a0,0(s3)
    80002918:	00000097          	auipc	ra,0x0
    8000291c:	e14080e7          	jalr	-492(ra) # 8000272c <balloc>
    80002920:	0005091b          	sext.w	s2,a0
      if(addr){
    80002924:	fc090ae3          	beqz	s2,800028f8 <bmap+0x9a>
        a[bn] = addr;
    80002928:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000292c:	8552                	mv	a0,s4
    8000292e:	00001097          	auipc	ra,0x1
    80002932:	ef6080e7          	jalr	-266(ra) # 80003824 <log_write>
    80002936:	b7c9                	j	800028f8 <bmap+0x9a>
  panic("bmap: out of range");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	e0050513          	addi	a0,a0,-512 # 80008738 <syscalls_name+0x128>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	3fc080e7          	jalr	1020(ra) # 80005d3c <panic>

0000000080002948 <iget>:
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	e052                	sd	s4,0(sp)
    80002956:	1800                	addi	s0,sp,48
    80002958:	89aa                	mv	s3,a0
    8000295a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000295c:	00015517          	auipc	a0,0x15
    80002960:	91c50513          	addi	a0,a0,-1764 # 80017278 <itable>
    80002964:	00004097          	auipc	ra,0x4
    80002968:	910080e7          	jalr	-1776(ra) # 80006274 <acquire>
  empty = 0;
    8000296c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296e:	00015497          	auipc	s1,0x15
    80002972:	92248493          	addi	s1,s1,-1758 # 80017290 <itable+0x18>
    80002976:	00016697          	auipc	a3,0x16
    8000297a:	3aa68693          	addi	a3,a3,938 # 80018d20 <log>
    8000297e:	a039                	j	8000298c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002980:	02090b63          	beqz	s2,800029b6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002984:	08848493          	addi	s1,s1,136
    80002988:	02d48a63          	beq	s1,a3,800029bc <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000298c:	449c                	lw	a5,8(s1)
    8000298e:	fef059e3          	blez	a5,80002980 <iget+0x38>
    80002992:	4098                	lw	a4,0(s1)
    80002994:	ff3716e3          	bne	a4,s3,80002980 <iget+0x38>
    80002998:	40d8                	lw	a4,4(s1)
    8000299a:	ff4713e3          	bne	a4,s4,80002980 <iget+0x38>
      ip->ref++;
    8000299e:	2785                	addiw	a5,a5,1
    800029a0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800029a2:	00015517          	auipc	a0,0x15
    800029a6:	8d650513          	addi	a0,a0,-1834 # 80017278 <itable>
    800029aa:	00004097          	auipc	ra,0x4
    800029ae:	97e080e7          	jalr	-1666(ra) # 80006328 <release>
      return ip;
    800029b2:	8926                	mv	s2,s1
    800029b4:	a03d                	j	800029e2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b6:	f7f9                	bnez	a5,80002984 <iget+0x3c>
    800029b8:	8926                	mv	s2,s1
    800029ba:	b7e9                	j	80002984 <iget+0x3c>
  if(empty == 0)
    800029bc:	02090c63          	beqz	s2,800029f4 <iget+0xac>
  ip->dev = dev;
    800029c0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029c4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029c8:	4785                	li	a5,1
    800029ca:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029ce:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029d2:	00015517          	auipc	a0,0x15
    800029d6:	8a650513          	addi	a0,a0,-1882 # 80017278 <itable>
    800029da:	00004097          	auipc	ra,0x4
    800029de:	94e080e7          	jalr	-1714(ra) # 80006328 <release>
}
    800029e2:	854a                	mv	a0,s2
    800029e4:	70a2                	ld	ra,40(sp)
    800029e6:	7402                	ld	s0,32(sp)
    800029e8:	64e2                	ld	s1,24(sp)
    800029ea:	6942                	ld	s2,16(sp)
    800029ec:	69a2                	ld	s3,8(sp)
    800029ee:	6a02                	ld	s4,0(sp)
    800029f0:	6145                	addi	sp,sp,48
    800029f2:	8082                	ret
    panic("iget: no inodes");
    800029f4:	00006517          	auipc	a0,0x6
    800029f8:	d5c50513          	addi	a0,a0,-676 # 80008750 <syscalls_name+0x140>
    800029fc:	00003097          	auipc	ra,0x3
    80002a00:	340080e7          	jalr	832(ra) # 80005d3c <panic>

0000000080002a04 <fsinit>:
fsinit(int dev) {
    80002a04:	7179                	addi	sp,sp,-48
    80002a06:	f406                	sd	ra,40(sp)
    80002a08:	f022                	sd	s0,32(sp)
    80002a0a:	ec26                	sd	s1,24(sp)
    80002a0c:	e84a                	sd	s2,16(sp)
    80002a0e:	e44e                	sd	s3,8(sp)
    80002a10:	1800                	addi	s0,sp,48
    80002a12:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a14:	4585                	li	a1,1
    80002a16:	00000097          	auipc	ra,0x0
    80002a1a:	a54080e7          	jalr	-1452(ra) # 8000246a <bread>
    80002a1e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a20:	00015997          	auipc	s3,0x15
    80002a24:	83898993          	addi	s3,s3,-1992 # 80017258 <sb>
    80002a28:	02000613          	li	a2,32
    80002a2c:	05850593          	addi	a1,a0,88
    80002a30:	854e                	mv	a0,s3
    80002a32:	ffffd097          	auipc	ra,0xffffd
    80002a36:	7f0080e7          	jalr	2032(ra) # 80000222 <memmove>
  brelse(bp);
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	00000097          	auipc	ra,0x0
    80002a40:	b5e080e7          	jalr	-1186(ra) # 8000259a <brelse>
  if(sb.magic != FSMAGIC)
    80002a44:	0009a703          	lw	a4,0(s3)
    80002a48:	102037b7          	lui	a5,0x10203
    80002a4c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a50:	02f71263          	bne	a4,a5,80002a74 <fsinit+0x70>
  initlog(dev, &sb);
    80002a54:	00015597          	auipc	a1,0x15
    80002a58:	80458593          	addi	a1,a1,-2044 # 80017258 <sb>
    80002a5c:	854a                	mv	a0,s2
    80002a5e:	00001097          	auipc	ra,0x1
    80002a62:	b4a080e7          	jalr	-1206(ra) # 800035a8 <initlog>
}
    80002a66:	70a2                	ld	ra,40(sp)
    80002a68:	7402                	ld	s0,32(sp)
    80002a6a:	64e2                	ld	s1,24(sp)
    80002a6c:	6942                	ld	s2,16(sp)
    80002a6e:	69a2                	ld	s3,8(sp)
    80002a70:	6145                	addi	sp,sp,48
    80002a72:	8082                	ret
    panic("invalid file system");
    80002a74:	00006517          	auipc	a0,0x6
    80002a78:	cec50513          	addi	a0,a0,-788 # 80008760 <syscalls_name+0x150>
    80002a7c:	00003097          	auipc	ra,0x3
    80002a80:	2c0080e7          	jalr	704(ra) # 80005d3c <panic>

0000000080002a84 <iinit>:
{
    80002a84:	7179                	addi	sp,sp,-48
    80002a86:	f406                	sd	ra,40(sp)
    80002a88:	f022                	sd	s0,32(sp)
    80002a8a:	ec26                	sd	s1,24(sp)
    80002a8c:	e84a                	sd	s2,16(sp)
    80002a8e:	e44e                	sd	s3,8(sp)
    80002a90:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a92:	00006597          	auipc	a1,0x6
    80002a96:	ce658593          	addi	a1,a1,-794 # 80008778 <syscalls_name+0x168>
    80002a9a:	00014517          	auipc	a0,0x14
    80002a9e:	7de50513          	addi	a0,a0,2014 # 80017278 <itable>
    80002aa2:	00003097          	auipc	ra,0x3
    80002aa6:	742080e7          	jalr	1858(ra) # 800061e4 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aaa:	00014497          	auipc	s1,0x14
    80002aae:	7f648493          	addi	s1,s1,2038 # 800172a0 <itable+0x28>
    80002ab2:	00016997          	auipc	s3,0x16
    80002ab6:	27e98993          	addi	s3,s3,638 # 80018d30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002aba:	00006917          	auipc	s2,0x6
    80002abe:	cc690913          	addi	s2,s2,-826 # 80008780 <syscalls_name+0x170>
    80002ac2:	85ca                	mv	a1,s2
    80002ac4:	8526                	mv	a0,s1
    80002ac6:	00001097          	auipc	ra,0x1
    80002aca:	e42080e7          	jalr	-446(ra) # 80003908 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ace:	08848493          	addi	s1,s1,136
    80002ad2:	ff3498e3          	bne	s1,s3,80002ac2 <iinit+0x3e>
}
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret

0000000080002ae4 <ialloc>:
{
    80002ae4:	715d                	addi	sp,sp,-80
    80002ae6:	e486                	sd	ra,72(sp)
    80002ae8:	e0a2                	sd	s0,64(sp)
    80002aea:	fc26                	sd	s1,56(sp)
    80002aec:	f84a                	sd	s2,48(sp)
    80002aee:	f44e                	sd	s3,40(sp)
    80002af0:	f052                	sd	s4,32(sp)
    80002af2:	ec56                	sd	s5,24(sp)
    80002af4:	e85a                	sd	s6,16(sp)
    80002af6:	e45e                	sd	s7,8(sp)
    80002af8:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002afa:	00014717          	auipc	a4,0x14
    80002afe:	76a72703          	lw	a4,1898(a4) # 80017264 <sb+0xc>
    80002b02:	4785                	li	a5,1
    80002b04:	04e7fa63          	bgeu	a5,a4,80002b58 <ialloc+0x74>
    80002b08:	8aaa                	mv	s5,a0
    80002b0a:	8bae                	mv	s7,a1
    80002b0c:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b0e:	00014a17          	auipc	s4,0x14
    80002b12:	74aa0a13          	addi	s4,s4,1866 # 80017258 <sb>
    80002b16:	00048b1b          	sext.w	s6,s1
    80002b1a:	0044d593          	srli	a1,s1,0x4
    80002b1e:	018a2783          	lw	a5,24(s4)
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	8556                	mv	a0,s5
    80002b26:	00000097          	auipc	ra,0x0
    80002b2a:	944080e7          	jalr	-1724(ra) # 8000246a <bread>
    80002b2e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b30:	05850993          	addi	s3,a0,88
    80002b34:	00f4f793          	andi	a5,s1,15
    80002b38:	079a                	slli	a5,a5,0x6
    80002b3a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b3c:	00099783          	lh	a5,0(s3)
    80002b40:	c3a1                	beqz	a5,80002b80 <ialloc+0x9c>
    brelse(bp);
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	a58080e7          	jalr	-1448(ra) # 8000259a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b4a:	0485                	addi	s1,s1,1
    80002b4c:	00ca2703          	lw	a4,12(s4)
    80002b50:	0004879b          	sext.w	a5,s1
    80002b54:	fce7e1e3          	bltu	a5,a4,80002b16 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b58:	00006517          	auipc	a0,0x6
    80002b5c:	c3050513          	addi	a0,a0,-976 # 80008788 <syscalls_name+0x178>
    80002b60:	00003097          	auipc	ra,0x3
    80002b64:	226080e7          	jalr	550(ra) # 80005d86 <printf>
  return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	60a6                	ld	ra,72(sp)
    80002b6c:	6406                	ld	s0,64(sp)
    80002b6e:	74e2                	ld	s1,56(sp)
    80002b70:	7942                	ld	s2,48(sp)
    80002b72:	79a2                	ld	s3,40(sp)
    80002b74:	7a02                	ld	s4,32(sp)
    80002b76:	6ae2                	ld	s5,24(sp)
    80002b78:	6b42                	ld	s6,16(sp)
    80002b7a:	6ba2                	ld	s7,8(sp)
    80002b7c:	6161                	addi	sp,sp,80
    80002b7e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b80:	04000613          	li	a2,64
    80002b84:	4581                	li	a1,0
    80002b86:	854e                	mv	a0,s3
    80002b88:	ffffd097          	auipc	ra,0xffffd
    80002b8c:	63e080e7          	jalr	1598(ra) # 800001c6 <memset>
      dip->type = type;
    80002b90:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b94:	854a                	mv	a0,s2
    80002b96:	00001097          	auipc	ra,0x1
    80002b9a:	c8e080e7          	jalr	-882(ra) # 80003824 <log_write>
      brelse(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	9fa080e7          	jalr	-1542(ra) # 8000259a <brelse>
      return iget(dev, inum);
    80002ba8:	85da                	mv	a1,s6
    80002baa:	8556                	mv	a0,s5
    80002bac:	00000097          	auipc	ra,0x0
    80002bb0:	d9c080e7          	jalr	-612(ra) # 80002948 <iget>
    80002bb4:	bf5d                	j	80002b6a <ialloc+0x86>

0000000080002bb6 <iupdate>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	e04a                	sd	s2,0(sp)
    80002bc0:	1000                	addi	s0,sp,32
    80002bc2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc4:	415c                	lw	a5,4(a0)
    80002bc6:	0047d79b          	srliw	a5,a5,0x4
    80002bca:	00014597          	auipc	a1,0x14
    80002bce:	6a65a583          	lw	a1,1702(a1) # 80017270 <sb+0x18>
    80002bd2:	9dbd                	addw	a1,a1,a5
    80002bd4:	4108                	lw	a0,0(a0)
    80002bd6:	00000097          	auipc	ra,0x0
    80002bda:	894080e7          	jalr	-1900(ra) # 8000246a <bread>
    80002bde:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002be0:	05850793          	addi	a5,a0,88
    80002be4:	40d8                	lw	a4,4(s1)
    80002be6:	8b3d                	andi	a4,a4,15
    80002be8:	071a                	slli	a4,a4,0x6
    80002bea:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bec:	04449703          	lh	a4,68(s1)
    80002bf0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002bf4:	04649703          	lh	a4,70(s1)
    80002bf8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002bfc:	04849703          	lh	a4,72(s1)
    80002c00:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c04:	04a49703          	lh	a4,74(s1)
    80002c08:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c0c:	44f8                	lw	a4,76(s1)
    80002c0e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c10:	03400613          	li	a2,52
    80002c14:	05048593          	addi	a1,s1,80
    80002c18:	00c78513          	addi	a0,a5,12
    80002c1c:	ffffd097          	auipc	ra,0xffffd
    80002c20:	606080e7          	jalr	1542(ra) # 80000222 <memmove>
  log_write(bp);
    80002c24:	854a                	mv	a0,s2
    80002c26:	00001097          	auipc	ra,0x1
    80002c2a:	bfe080e7          	jalr	-1026(ra) # 80003824 <log_write>
  brelse(bp);
    80002c2e:	854a                	mv	a0,s2
    80002c30:	00000097          	auipc	ra,0x0
    80002c34:	96a080e7          	jalr	-1686(ra) # 8000259a <brelse>
}
    80002c38:	60e2                	ld	ra,24(sp)
    80002c3a:	6442                	ld	s0,16(sp)
    80002c3c:	64a2                	ld	s1,8(sp)
    80002c3e:	6902                	ld	s2,0(sp)
    80002c40:	6105                	addi	sp,sp,32
    80002c42:	8082                	ret

0000000080002c44 <idup>:
{
    80002c44:	1101                	addi	sp,sp,-32
    80002c46:	ec06                	sd	ra,24(sp)
    80002c48:	e822                	sd	s0,16(sp)
    80002c4a:	e426                	sd	s1,8(sp)
    80002c4c:	1000                	addi	s0,sp,32
    80002c4e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c50:	00014517          	auipc	a0,0x14
    80002c54:	62850513          	addi	a0,a0,1576 # 80017278 <itable>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	61c080e7          	jalr	1564(ra) # 80006274 <acquire>
  ip->ref++;
    80002c60:	449c                	lw	a5,8(s1)
    80002c62:	2785                	addiw	a5,a5,1
    80002c64:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c66:	00014517          	auipc	a0,0x14
    80002c6a:	61250513          	addi	a0,a0,1554 # 80017278 <itable>
    80002c6e:	00003097          	auipc	ra,0x3
    80002c72:	6ba080e7          	jalr	1722(ra) # 80006328 <release>
}
    80002c76:	8526                	mv	a0,s1
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret

0000000080002c82 <ilock>:
{
    80002c82:	1101                	addi	sp,sp,-32
    80002c84:	ec06                	sd	ra,24(sp)
    80002c86:	e822                	sd	s0,16(sp)
    80002c88:	e426                	sd	s1,8(sp)
    80002c8a:	e04a                	sd	s2,0(sp)
    80002c8c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c8e:	c115                	beqz	a0,80002cb2 <ilock+0x30>
    80002c90:	84aa                	mv	s1,a0
    80002c92:	451c                	lw	a5,8(a0)
    80002c94:	00f05f63          	blez	a5,80002cb2 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c98:	0541                	addi	a0,a0,16
    80002c9a:	00001097          	auipc	ra,0x1
    80002c9e:	ca8080e7          	jalr	-856(ra) # 80003942 <acquiresleep>
  if(ip->valid == 0){
    80002ca2:	40bc                	lw	a5,64(s1)
    80002ca4:	cf99                	beqz	a5,80002cc2 <ilock+0x40>
}
    80002ca6:	60e2                	ld	ra,24(sp)
    80002ca8:	6442                	ld	s0,16(sp)
    80002caa:	64a2                	ld	s1,8(sp)
    80002cac:	6902                	ld	s2,0(sp)
    80002cae:	6105                	addi	sp,sp,32
    80002cb0:	8082                	ret
    panic("ilock");
    80002cb2:	00006517          	auipc	a0,0x6
    80002cb6:	aee50513          	addi	a0,a0,-1298 # 800087a0 <syscalls_name+0x190>
    80002cba:	00003097          	auipc	ra,0x3
    80002cbe:	082080e7          	jalr	130(ra) # 80005d3c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cc2:	40dc                	lw	a5,4(s1)
    80002cc4:	0047d79b          	srliw	a5,a5,0x4
    80002cc8:	00014597          	auipc	a1,0x14
    80002ccc:	5a85a583          	lw	a1,1448(a1) # 80017270 <sb+0x18>
    80002cd0:	9dbd                	addw	a1,a1,a5
    80002cd2:	4088                	lw	a0,0(s1)
    80002cd4:	fffff097          	auipc	ra,0xfffff
    80002cd8:	796080e7          	jalr	1942(ra) # 8000246a <bread>
    80002cdc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cde:	05850593          	addi	a1,a0,88
    80002ce2:	40dc                	lw	a5,4(s1)
    80002ce4:	8bbd                	andi	a5,a5,15
    80002ce6:	079a                	slli	a5,a5,0x6
    80002ce8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cea:	00059783          	lh	a5,0(a1)
    80002cee:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cf2:	00259783          	lh	a5,2(a1)
    80002cf6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cfa:	00459783          	lh	a5,4(a1)
    80002cfe:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d02:	00659783          	lh	a5,6(a1)
    80002d06:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d0a:	459c                	lw	a5,8(a1)
    80002d0c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d0e:	03400613          	li	a2,52
    80002d12:	05b1                	addi	a1,a1,12
    80002d14:	05048513          	addi	a0,s1,80
    80002d18:	ffffd097          	auipc	ra,0xffffd
    80002d1c:	50a080e7          	jalr	1290(ra) # 80000222 <memmove>
    brelse(bp);
    80002d20:	854a                	mv	a0,s2
    80002d22:	00000097          	auipc	ra,0x0
    80002d26:	878080e7          	jalr	-1928(ra) # 8000259a <brelse>
    ip->valid = 1;
    80002d2a:	4785                	li	a5,1
    80002d2c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d2e:	04449783          	lh	a5,68(s1)
    80002d32:	fbb5                	bnez	a5,80002ca6 <ilock+0x24>
      panic("ilock: no type");
    80002d34:	00006517          	auipc	a0,0x6
    80002d38:	a7450513          	addi	a0,a0,-1420 # 800087a8 <syscalls_name+0x198>
    80002d3c:	00003097          	auipc	ra,0x3
    80002d40:	000080e7          	jalr	ra # 80005d3c <panic>

0000000080002d44 <iunlock>:
{
    80002d44:	1101                	addi	sp,sp,-32
    80002d46:	ec06                	sd	ra,24(sp)
    80002d48:	e822                	sd	s0,16(sp)
    80002d4a:	e426                	sd	s1,8(sp)
    80002d4c:	e04a                	sd	s2,0(sp)
    80002d4e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d50:	c905                	beqz	a0,80002d80 <iunlock+0x3c>
    80002d52:	84aa                	mv	s1,a0
    80002d54:	01050913          	addi	s2,a0,16
    80002d58:	854a                	mv	a0,s2
    80002d5a:	00001097          	auipc	ra,0x1
    80002d5e:	c82080e7          	jalr	-894(ra) # 800039dc <holdingsleep>
    80002d62:	cd19                	beqz	a0,80002d80 <iunlock+0x3c>
    80002d64:	449c                	lw	a5,8(s1)
    80002d66:	00f05d63          	blez	a5,80002d80 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d6a:	854a                	mv	a0,s2
    80002d6c:	00001097          	auipc	ra,0x1
    80002d70:	c2c080e7          	jalr	-980(ra) # 80003998 <releasesleep>
}
    80002d74:	60e2                	ld	ra,24(sp)
    80002d76:	6442                	ld	s0,16(sp)
    80002d78:	64a2                	ld	s1,8(sp)
    80002d7a:	6902                	ld	s2,0(sp)
    80002d7c:	6105                	addi	sp,sp,32
    80002d7e:	8082                	ret
    panic("iunlock");
    80002d80:	00006517          	auipc	a0,0x6
    80002d84:	a3850513          	addi	a0,a0,-1480 # 800087b8 <syscalls_name+0x1a8>
    80002d88:	00003097          	auipc	ra,0x3
    80002d8c:	fb4080e7          	jalr	-76(ra) # 80005d3c <panic>

0000000080002d90 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d90:	7179                	addi	sp,sp,-48
    80002d92:	f406                	sd	ra,40(sp)
    80002d94:	f022                	sd	s0,32(sp)
    80002d96:	ec26                	sd	s1,24(sp)
    80002d98:	e84a                	sd	s2,16(sp)
    80002d9a:	e44e                	sd	s3,8(sp)
    80002d9c:	e052                	sd	s4,0(sp)
    80002d9e:	1800                	addi	s0,sp,48
    80002da0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002da2:	05050493          	addi	s1,a0,80
    80002da6:	08050913          	addi	s2,a0,128
    80002daa:	a021                	j	80002db2 <itrunc+0x22>
    80002dac:	0491                	addi	s1,s1,4
    80002dae:	01248d63          	beq	s1,s2,80002dc8 <itrunc+0x38>
    if(ip->addrs[i]){
    80002db2:	408c                	lw	a1,0(s1)
    80002db4:	dde5                	beqz	a1,80002dac <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db6:	0009a503          	lw	a0,0(s3)
    80002dba:	00000097          	auipc	ra,0x0
    80002dbe:	8f6080e7          	jalr	-1802(ra) # 800026b0 <bfree>
      ip->addrs[i] = 0;
    80002dc2:	0004a023          	sw	zero,0(s1)
    80002dc6:	b7dd                	j	80002dac <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc8:	0809a583          	lw	a1,128(s3)
    80002dcc:	e185                	bnez	a1,80002dec <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dce:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dd2:	854e                	mv	a0,s3
    80002dd4:	00000097          	auipc	ra,0x0
    80002dd8:	de2080e7          	jalr	-542(ra) # 80002bb6 <iupdate>
}
    80002ddc:	70a2                	ld	ra,40(sp)
    80002dde:	7402                	ld	s0,32(sp)
    80002de0:	64e2                	ld	s1,24(sp)
    80002de2:	6942                	ld	s2,16(sp)
    80002de4:	69a2                	ld	s3,8(sp)
    80002de6:	6a02                	ld	s4,0(sp)
    80002de8:	6145                	addi	sp,sp,48
    80002dea:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dec:	0009a503          	lw	a0,0(s3)
    80002df0:	fffff097          	auipc	ra,0xfffff
    80002df4:	67a080e7          	jalr	1658(ra) # 8000246a <bread>
    80002df8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dfa:	05850493          	addi	s1,a0,88
    80002dfe:	45850913          	addi	s2,a0,1112
    80002e02:	a021                	j	80002e0a <itrunc+0x7a>
    80002e04:	0491                	addi	s1,s1,4
    80002e06:	01248b63          	beq	s1,s2,80002e1c <itrunc+0x8c>
      if(a[j])
    80002e0a:	408c                	lw	a1,0(s1)
    80002e0c:	dde5                	beqz	a1,80002e04 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002e0e:	0009a503          	lw	a0,0(s3)
    80002e12:	00000097          	auipc	ra,0x0
    80002e16:	89e080e7          	jalr	-1890(ra) # 800026b0 <bfree>
    80002e1a:	b7ed                	j	80002e04 <itrunc+0x74>
    brelse(bp);
    80002e1c:	8552                	mv	a0,s4
    80002e1e:	fffff097          	auipc	ra,0xfffff
    80002e22:	77c080e7          	jalr	1916(ra) # 8000259a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e26:	0809a583          	lw	a1,128(s3)
    80002e2a:	0009a503          	lw	a0,0(s3)
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	882080e7          	jalr	-1918(ra) # 800026b0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e36:	0809a023          	sw	zero,128(s3)
    80002e3a:	bf51                	j	80002dce <itrunc+0x3e>

0000000080002e3c <iput>:
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	e04a                	sd	s2,0(sp)
    80002e46:	1000                	addi	s0,sp,32
    80002e48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e4a:	00014517          	auipc	a0,0x14
    80002e4e:	42e50513          	addi	a0,a0,1070 # 80017278 <itable>
    80002e52:	00003097          	auipc	ra,0x3
    80002e56:	422080e7          	jalr	1058(ra) # 80006274 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e5a:	4498                	lw	a4,8(s1)
    80002e5c:	4785                	li	a5,1
    80002e5e:	02f70363          	beq	a4,a5,80002e84 <iput+0x48>
  ip->ref--;
    80002e62:	449c                	lw	a5,8(s1)
    80002e64:	37fd                	addiw	a5,a5,-1
    80002e66:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e68:	00014517          	auipc	a0,0x14
    80002e6c:	41050513          	addi	a0,a0,1040 # 80017278 <itable>
    80002e70:	00003097          	auipc	ra,0x3
    80002e74:	4b8080e7          	jalr	1208(ra) # 80006328 <release>
}
    80002e78:	60e2                	ld	ra,24(sp)
    80002e7a:	6442                	ld	s0,16(sp)
    80002e7c:	64a2                	ld	s1,8(sp)
    80002e7e:	6902                	ld	s2,0(sp)
    80002e80:	6105                	addi	sp,sp,32
    80002e82:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e84:	40bc                	lw	a5,64(s1)
    80002e86:	dff1                	beqz	a5,80002e62 <iput+0x26>
    80002e88:	04a49783          	lh	a5,74(s1)
    80002e8c:	fbf9                	bnez	a5,80002e62 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e8e:	01048913          	addi	s2,s1,16
    80002e92:	854a                	mv	a0,s2
    80002e94:	00001097          	auipc	ra,0x1
    80002e98:	aae080e7          	jalr	-1362(ra) # 80003942 <acquiresleep>
    release(&itable.lock);
    80002e9c:	00014517          	auipc	a0,0x14
    80002ea0:	3dc50513          	addi	a0,a0,988 # 80017278 <itable>
    80002ea4:	00003097          	auipc	ra,0x3
    80002ea8:	484080e7          	jalr	1156(ra) # 80006328 <release>
    itrunc(ip);
    80002eac:	8526                	mv	a0,s1
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	ee2080e7          	jalr	-286(ra) # 80002d90 <itrunc>
    ip->type = 0;
    80002eb6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eba:	8526                	mv	a0,s1
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	cfa080e7          	jalr	-774(ra) # 80002bb6 <iupdate>
    ip->valid = 0;
    80002ec4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	00001097          	auipc	ra,0x1
    80002ece:	ace080e7          	jalr	-1330(ra) # 80003998 <releasesleep>
    acquire(&itable.lock);
    80002ed2:	00014517          	auipc	a0,0x14
    80002ed6:	3a650513          	addi	a0,a0,934 # 80017278 <itable>
    80002eda:	00003097          	auipc	ra,0x3
    80002ede:	39a080e7          	jalr	922(ra) # 80006274 <acquire>
    80002ee2:	b741                	j	80002e62 <iput+0x26>

0000000080002ee4 <iunlockput>:
{
    80002ee4:	1101                	addi	sp,sp,-32
    80002ee6:	ec06                	sd	ra,24(sp)
    80002ee8:	e822                	sd	s0,16(sp)
    80002eea:	e426                	sd	s1,8(sp)
    80002eec:	1000                	addi	s0,sp,32
    80002eee:	84aa                	mv	s1,a0
  iunlock(ip);
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	e54080e7          	jalr	-428(ra) # 80002d44 <iunlock>
  iput(ip);
    80002ef8:	8526                	mv	a0,s1
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	f42080e7          	jalr	-190(ra) # 80002e3c <iput>
}
    80002f02:	60e2                	ld	ra,24(sp)
    80002f04:	6442                	ld	s0,16(sp)
    80002f06:	64a2                	ld	s1,8(sp)
    80002f08:	6105                	addi	sp,sp,32
    80002f0a:	8082                	ret

0000000080002f0c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f0c:	1141                	addi	sp,sp,-16
    80002f0e:	e422                	sd	s0,8(sp)
    80002f10:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f12:	411c                	lw	a5,0(a0)
    80002f14:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f16:	415c                	lw	a5,4(a0)
    80002f18:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f1a:	04451783          	lh	a5,68(a0)
    80002f1e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f22:	04a51783          	lh	a5,74(a0)
    80002f26:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f2a:	04c56783          	lwu	a5,76(a0)
    80002f2e:	e99c                	sd	a5,16(a1)
}
    80002f30:	6422                	ld	s0,8(sp)
    80002f32:	0141                	addi	sp,sp,16
    80002f34:	8082                	ret

0000000080002f36 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f36:	457c                	lw	a5,76(a0)
    80002f38:	0ed7e963          	bltu	a5,a3,8000302a <readi+0xf4>
{
    80002f3c:	7159                	addi	sp,sp,-112
    80002f3e:	f486                	sd	ra,104(sp)
    80002f40:	f0a2                	sd	s0,96(sp)
    80002f42:	eca6                	sd	s1,88(sp)
    80002f44:	e8ca                	sd	s2,80(sp)
    80002f46:	e4ce                	sd	s3,72(sp)
    80002f48:	e0d2                	sd	s4,64(sp)
    80002f4a:	fc56                	sd	s5,56(sp)
    80002f4c:	f85a                	sd	s6,48(sp)
    80002f4e:	f45e                	sd	s7,40(sp)
    80002f50:	f062                	sd	s8,32(sp)
    80002f52:	ec66                	sd	s9,24(sp)
    80002f54:	e86a                	sd	s10,16(sp)
    80002f56:	e46e                	sd	s11,8(sp)
    80002f58:	1880                	addi	s0,sp,112
    80002f5a:	8b2a                	mv	s6,a0
    80002f5c:	8bae                	mv	s7,a1
    80002f5e:	8a32                	mv	s4,a2
    80002f60:	84b6                	mv	s1,a3
    80002f62:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f64:	9f35                	addw	a4,a4,a3
    return 0;
    80002f66:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f68:	0ad76063          	bltu	a4,a3,80003008 <readi+0xd2>
  if(off + n > ip->size)
    80002f6c:	00e7f463          	bgeu	a5,a4,80002f74 <readi+0x3e>
    n = ip->size - off;
    80002f70:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f74:	0a0a8963          	beqz	s5,80003026 <readi+0xf0>
    80002f78:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f7e:	5c7d                	li	s8,-1
    80002f80:	a82d                	j	80002fba <readi+0x84>
    80002f82:	020d1d93          	slli	s11,s10,0x20
    80002f86:	020ddd93          	srli	s11,s11,0x20
    80002f8a:	05890613          	addi	a2,s2,88
    80002f8e:	86ee                	mv	a3,s11
    80002f90:	963a                	add	a2,a2,a4
    80002f92:	85d2                	mv	a1,s4
    80002f94:	855e                	mv	a0,s7
    80002f96:	fffff097          	auipc	ra,0xfffff
    80002f9a:	a1a080e7          	jalr	-1510(ra) # 800019b0 <either_copyout>
    80002f9e:	05850d63          	beq	a0,s8,80002ff8 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	fffff097          	auipc	ra,0xfffff
    80002fa8:	5f6080e7          	jalr	1526(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fac:	013d09bb          	addw	s3,s10,s3
    80002fb0:	009d04bb          	addw	s1,s10,s1
    80002fb4:	9a6e                	add	s4,s4,s11
    80002fb6:	0559f763          	bgeu	s3,s5,80003004 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fba:	00a4d59b          	srliw	a1,s1,0xa
    80002fbe:	855a                	mv	a0,s6
    80002fc0:	00000097          	auipc	ra,0x0
    80002fc4:	89e080e7          	jalr	-1890(ra) # 8000285e <bmap>
    80002fc8:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fcc:	cd85                	beqz	a1,80003004 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fce:	000b2503          	lw	a0,0(s6)
    80002fd2:	fffff097          	auipc	ra,0xfffff
    80002fd6:	498080e7          	jalr	1176(ra) # 8000246a <bread>
    80002fda:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fdc:	3ff4f713          	andi	a4,s1,1023
    80002fe0:	40ec87bb          	subw	a5,s9,a4
    80002fe4:	413a86bb          	subw	a3,s5,s3
    80002fe8:	8d3e                	mv	s10,a5
    80002fea:	2781                	sext.w	a5,a5
    80002fec:	0006861b          	sext.w	a2,a3
    80002ff0:	f8f679e3          	bgeu	a2,a5,80002f82 <readi+0x4c>
    80002ff4:	8d36                	mv	s10,a3
    80002ff6:	b771                	j	80002f82 <readi+0x4c>
      brelse(bp);
    80002ff8:	854a                	mv	a0,s2
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	5a0080e7          	jalr	1440(ra) # 8000259a <brelse>
      tot = -1;
    80003002:	59fd                	li	s3,-1
  }
  return tot;
    80003004:	0009851b          	sext.w	a0,s3
}
    80003008:	70a6                	ld	ra,104(sp)
    8000300a:	7406                	ld	s0,96(sp)
    8000300c:	64e6                	ld	s1,88(sp)
    8000300e:	6946                	ld	s2,80(sp)
    80003010:	69a6                	ld	s3,72(sp)
    80003012:	6a06                	ld	s4,64(sp)
    80003014:	7ae2                	ld	s5,56(sp)
    80003016:	7b42                	ld	s6,48(sp)
    80003018:	7ba2                	ld	s7,40(sp)
    8000301a:	7c02                	ld	s8,32(sp)
    8000301c:	6ce2                	ld	s9,24(sp)
    8000301e:	6d42                	ld	s10,16(sp)
    80003020:	6da2                	ld	s11,8(sp)
    80003022:	6165                	addi	sp,sp,112
    80003024:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003026:	89d6                	mv	s3,s5
    80003028:	bff1                	j	80003004 <readi+0xce>
    return 0;
    8000302a:	4501                	li	a0,0
}
    8000302c:	8082                	ret

000000008000302e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000302e:	457c                	lw	a5,76(a0)
    80003030:	10d7e863          	bltu	a5,a3,80003140 <writei+0x112>
{
    80003034:	7159                	addi	sp,sp,-112
    80003036:	f486                	sd	ra,104(sp)
    80003038:	f0a2                	sd	s0,96(sp)
    8000303a:	eca6                	sd	s1,88(sp)
    8000303c:	e8ca                	sd	s2,80(sp)
    8000303e:	e4ce                	sd	s3,72(sp)
    80003040:	e0d2                	sd	s4,64(sp)
    80003042:	fc56                	sd	s5,56(sp)
    80003044:	f85a                	sd	s6,48(sp)
    80003046:	f45e                	sd	s7,40(sp)
    80003048:	f062                	sd	s8,32(sp)
    8000304a:	ec66                	sd	s9,24(sp)
    8000304c:	e86a                	sd	s10,16(sp)
    8000304e:	e46e                	sd	s11,8(sp)
    80003050:	1880                	addi	s0,sp,112
    80003052:	8aaa                	mv	s5,a0
    80003054:	8bae                	mv	s7,a1
    80003056:	8a32                	mv	s4,a2
    80003058:	8936                	mv	s2,a3
    8000305a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000305c:	00e687bb          	addw	a5,a3,a4
    80003060:	0ed7e263          	bltu	a5,a3,80003144 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003064:	00043737          	lui	a4,0x43
    80003068:	0ef76063          	bltu	a4,a5,80003148 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000306c:	0c0b0863          	beqz	s6,8000313c <writei+0x10e>
    80003070:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003072:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003076:	5c7d                	li	s8,-1
    80003078:	a091                	j	800030bc <writei+0x8e>
    8000307a:	020d1d93          	slli	s11,s10,0x20
    8000307e:	020ddd93          	srli	s11,s11,0x20
    80003082:	05848513          	addi	a0,s1,88
    80003086:	86ee                	mv	a3,s11
    80003088:	8652                	mv	a2,s4
    8000308a:	85de                	mv	a1,s7
    8000308c:	953a                	add	a0,a0,a4
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	978080e7          	jalr	-1672(ra) # 80001a06 <either_copyin>
    80003096:	07850263          	beq	a0,s8,800030fa <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000309a:	8526                	mv	a0,s1
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	788080e7          	jalr	1928(ra) # 80003824 <log_write>
    brelse(bp);
    800030a4:	8526                	mv	a0,s1
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	4f4080e7          	jalr	1268(ra) # 8000259a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ae:	013d09bb          	addw	s3,s10,s3
    800030b2:	012d093b          	addw	s2,s10,s2
    800030b6:	9a6e                	add	s4,s4,s11
    800030b8:	0569f663          	bgeu	s3,s6,80003104 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030bc:	00a9559b          	srliw	a1,s2,0xa
    800030c0:	8556                	mv	a0,s5
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	79c080e7          	jalr	1948(ra) # 8000285e <bmap>
    800030ca:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030ce:	c99d                	beqz	a1,80003104 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030d0:	000aa503          	lw	a0,0(s5)
    800030d4:	fffff097          	auipc	ra,0xfffff
    800030d8:	396080e7          	jalr	918(ra) # 8000246a <bread>
    800030dc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030de:	3ff97713          	andi	a4,s2,1023
    800030e2:	40ec87bb          	subw	a5,s9,a4
    800030e6:	413b06bb          	subw	a3,s6,s3
    800030ea:	8d3e                	mv	s10,a5
    800030ec:	2781                	sext.w	a5,a5
    800030ee:	0006861b          	sext.w	a2,a3
    800030f2:	f8f674e3          	bgeu	a2,a5,8000307a <writei+0x4c>
    800030f6:	8d36                	mv	s10,a3
    800030f8:	b749                	j	8000307a <writei+0x4c>
      brelse(bp);
    800030fa:	8526                	mv	a0,s1
    800030fc:	fffff097          	auipc	ra,0xfffff
    80003100:	49e080e7          	jalr	1182(ra) # 8000259a <brelse>
  }

  if(off > ip->size)
    80003104:	04caa783          	lw	a5,76(s5)
    80003108:	0127f463          	bgeu	a5,s2,80003110 <writei+0xe2>
    ip->size = off;
    8000310c:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003110:	8556                	mv	a0,s5
    80003112:	00000097          	auipc	ra,0x0
    80003116:	aa4080e7          	jalr	-1372(ra) # 80002bb6 <iupdate>

  return tot;
    8000311a:	0009851b          	sext.w	a0,s3
}
    8000311e:	70a6                	ld	ra,104(sp)
    80003120:	7406                	ld	s0,96(sp)
    80003122:	64e6                	ld	s1,88(sp)
    80003124:	6946                	ld	s2,80(sp)
    80003126:	69a6                	ld	s3,72(sp)
    80003128:	6a06                	ld	s4,64(sp)
    8000312a:	7ae2                	ld	s5,56(sp)
    8000312c:	7b42                	ld	s6,48(sp)
    8000312e:	7ba2                	ld	s7,40(sp)
    80003130:	7c02                	ld	s8,32(sp)
    80003132:	6ce2                	ld	s9,24(sp)
    80003134:	6d42                	ld	s10,16(sp)
    80003136:	6da2                	ld	s11,8(sp)
    80003138:	6165                	addi	sp,sp,112
    8000313a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313c:	89da                	mv	s3,s6
    8000313e:	bfc9                	j	80003110 <writei+0xe2>
    return -1;
    80003140:	557d                	li	a0,-1
}
    80003142:	8082                	ret
    return -1;
    80003144:	557d                	li	a0,-1
    80003146:	bfe1                	j	8000311e <writei+0xf0>
    return -1;
    80003148:	557d                	li	a0,-1
    8000314a:	bfd1                	j	8000311e <writei+0xf0>

000000008000314c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000314c:	1141                	addi	sp,sp,-16
    8000314e:	e406                	sd	ra,8(sp)
    80003150:	e022                	sd	s0,0(sp)
    80003152:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003154:	4639                	li	a2,14
    80003156:	ffffd097          	auipc	ra,0xffffd
    8000315a:	140080e7          	jalr	320(ra) # 80000296 <strncmp>
}
    8000315e:	60a2                	ld	ra,8(sp)
    80003160:	6402                	ld	s0,0(sp)
    80003162:	0141                	addi	sp,sp,16
    80003164:	8082                	ret

0000000080003166 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003166:	7139                	addi	sp,sp,-64
    80003168:	fc06                	sd	ra,56(sp)
    8000316a:	f822                	sd	s0,48(sp)
    8000316c:	f426                	sd	s1,40(sp)
    8000316e:	f04a                	sd	s2,32(sp)
    80003170:	ec4e                	sd	s3,24(sp)
    80003172:	e852                	sd	s4,16(sp)
    80003174:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003176:	04451703          	lh	a4,68(a0)
    8000317a:	4785                	li	a5,1
    8000317c:	00f71a63          	bne	a4,a5,80003190 <dirlookup+0x2a>
    80003180:	892a                	mv	s2,a0
    80003182:	89ae                	mv	s3,a1
    80003184:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003186:	457c                	lw	a5,76(a0)
    80003188:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000318a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000318c:	e79d                	bnez	a5,800031ba <dirlookup+0x54>
    8000318e:	a8a5                	j	80003206 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003190:	00005517          	auipc	a0,0x5
    80003194:	63050513          	addi	a0,a0,1584 # 800087c0 <syscalls_name+0x1b0>
    80003198:	00003097          	auipc	ra,0x3
    8000319c:	ba4080e7          	jalr	-1116(ra) # 80005d3c <panic>
      panic("dirlookup read");
    800031a0:	00005517          	auipc	a0,0x5
    800031a4:	63850513          	addi	a0,a0,1592 # 800087d8 <syscalls_name+0x1c8>
    800031a8:	00003097          	auipc	ra,0x3
    800031ac:	b94080e7          	jalr	-1132(ra) # 80005d3c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031b0:	24c1                	addiw	s1,s1,16
    800031b2:	04c92783          	lw	a5,76(s2)
    800031b6:	04f4f763          	bgeu	s1,a5,80003204 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031ba:	4741                	li	a4,16
    800031bc:	86a6                	mv	a3,s1
    800031be:	fc040613          	addi	a2,s0,-64
    800031c2:	4581                	li	a1,0
    800031c4:	854a                	mv	a0,s2
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	d70080e7          	jalr	-656(ra) # 80002f36 <readi>
    800031ce:	47c1                	li	a5,16
    800031d0:	fcf518e3          	bne	a0,a5,800031a0 <dirlookup+0x3a>
    if(de.inum == 0)
    800031d4:	fc045783          	lhu	a5,-64(s0)
    800031d8:	dfe1                	beqz	a5,800031b0 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031da:	fc240593          	addi	a1,s0,-62
    800031de:	854e                	mv	a0,s3
    800031e0:	00000097          	auipc	ra,0x0
    800031e4:	f6c080e7          	jalr	-148(ra) # 8000314c <namecmp>
    800031e8:	f561                	bnez	a0,800031b0 <dirlookup+0x4a>
      if(poff)
    800031ea:	000a0463          	beqz	s4,800031f2 <dirlookup+0x8c>
        *poff = off;
    800031ee:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031f2:	fc045583          	lhu	a1,-64(s0)
    800031f6:	00092503          	lw	a0,0(s2)
    800031fa:	fffff097          	auipc	ra,0xfffff
    800031fe:	74e080e7          	jalr	1870(ra) # 80002948 <iget>
    80003202:	a011                	j	80003206 <dirlookup+0xa0>
  return 0;
    80003204:	4501                	li	a0,0
}
    80003206:	70e2                	ld	ra,56(sp)
    80003208:	7442                	ld	s0,48(sp)
    8000320a:	74a2                	ld	s1,40(sp)
    8000320c:	7902                	ld	s2,32(sp)
    8000320e:	69e2                	ld	s3,24(sp)
    80003210:	6a42                	ld	s4,16(sp)
    80003212:	6121                	addi	sp,sp,64
    80003214:	8082                	ret

0000000080003216 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003216:	711d                	addi	sp,sp,-96
    80003218:	ec86                	sd	ra,88(sp)
    8000321a:	e8a2                	sd	s0,80(sp)
    8000321c:	e4a6                	sd	s1,72(sp)
    8000321e:	e0ca                	sd	s2,64(sp)
    80003220:	fc4e                	sd	s3,56(sp)
    80003222:	f852                	sd	s4,48(sp)
    80003224:	f456                	sd	s5,40(sp)
    80003226:	f05a                	sd	s6,32(sp)
    80003228:	ec5e                	sd	s7,24(sp)
    8000322a:	e862                	sd	s8,16(sp)
    8000322c:	e466                	sd	s9,8(sp)
    8000322e:	e06a                	sd	s10,0(sp)
    80003230:	1080                	addi	s0,sp,96
    80003232:	84aa                	mv	s1,a0
    80003234:	8b2e                	mv	s6,a1
    80003236:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003238:	00054703          	lbu	a4,0(a0)
    8000323c:	02f00793          	li	a5,47
    80003240:	02f70363          	beq	a4,a5,80003266 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003244:	ffffe097          	auipc	ra,0xffffe
    80003248:	c5e080e7          	jalr	-930(ra) # 80000ea2 <myproc>
    8000324c:	15853503          	ld	a0,344(a0)
    80003250:	00000097          	auipc	ra,0x0
    80003254:	9f4080e7          	jalr	-1548(ra) # 80002c44 <idup>
    80003258:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000325a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000325e:	4cb5                	li	s9,13
  len = path - s;
    80003260:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003262:	4c05                	li	s8,1
    80003264:	a87d                	j	80003322 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80003266:	4585                	li	a1,1
    80003268:	4505                	li	a0,1
    8000326a:	fffff097          	auipc	ra,0xfffff
    8000326e:	6de080e7          	jalr	1758(ra) # 80002948 <iget>
    80003272:	8a2a                	mv	s4,a0
    80003274:	b7dd                	j	8000325a <namex+0x44>
      iunlockput(ip);
    80003276:	8552                	mv	a0,s4
    80003278:	00000097          	auipc	ra,0x0
    8000327c:	c6c080e7          	jalr	-916(ra) # 80002ee4 <iunlockput>
      return 0;
    80003280:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003282:	8552                	mv	a0,s4
    80003284:	60e6                	ld	ra,88(sp)
    80003286:	6446                	ld	s0,80(sp)
    80003288:	64a6                	ld	s1,72(sp)
    8000328a:	6906                	ld	s2,64(sp)
    8000328c:	79e2                	ld	s3,56(sp)
    8000328e:	7a42                	ld	s4,48(sp)
    80003290:	7aa2                	ld	s5,40(sp)
    80003292:	7b02                	ld	s6,32(sp)
    80003294:	6be2                	ld	s7,24(sp)
    80003296:	6c42                	ld	s8,16(sp)
    80003298:	6ca2                	ld	s9,8(sp)
    8000329a:	6d02                	ld	s10,0(sp)
    8000329c:	6125                	addi	sp,sp,96
    8000329e:	8082                	ret
      iunlock(ip);
    800032a0:	8552                	mv	a0,s4
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	aa2080e7          	jalr	-1374(ra) # 80002d44 <iunlock>
      return ip;
    800032aa:	bfe1                	j	80003282 <namex+0x6c>
      iunlockput(ip);
    800032ac:	8552                	mv	a0,s4
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	c36080e7          	jalr	-970(ra) # 80002ee4 <iunlockput>
      return 0;
    800032b6:	8a4e                	mv	s4,s3
    800032b8:	b7e9                	j	80003282 <namex+0x6c>
  len = path - s;
    800032ba:	40998633          	sub	a2,s3,s1
    800032be:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800032c2:	09acd863          	bge	s9,s10,80003352 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800032c6:	4639                	li	a2,14
    800032c8:	85a6                	mv	a1,s1
    800032ca:	8556                	mv	a0,s5
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	f56080e7          	jalr	-170(ra) # 80000222 <memmove>
    800032d4:	84ce                	mv	s1,s3
  while(*path == '/')
    800032d6:	0004c783          	lbu	a5,0(s1)
    800032da:	01279763          	bne	a5,s2,800032e8 <namex+0xd2>
    path++;
    800032de:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	ff278de3          	beq	a5,s2,800032de <namex+0xc8>
    ilock(ip);
    800032e8:	8552                	mv	a0,s4
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	998080e7          	jalr	-1640(ra) # 80002c82 <ilock>
    if(ip->type != T_DIR){
    800032f2:	044a1783          	lh	a5,68(s4)
    800032f6:	f98790e3          	bne	a5,s8,80003276 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800032fa:	000b0563          	beqz	s6,80003304 <namex+0xee>
    800032fe:	0004c783          	lbu	a5,0(s1)
    80003302:	dfd9                	beqz	a5,800032a0 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003304:	865e                	mv	a2,s7
    80003306:	85d6                	mv	a1,s5
    80003308:	8552                	mv	a0,s4
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	e5c080e7          	jalr	-420(ra) # 80003166 <dirlookup>
    80003312:	89aa                	mv	s3,a0
    80003314:	dd41                	beqz	a0,800032ac <namex+0x96>
    iunlockput(ip);
    80003316:	8552                	mv	a0,s4
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	bcc080e7          	jalr	-1076(ra) # 80002ee4 <iunlockput>
    ip = next;
    80003320:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003322:	0004c783          	lbu	a5,0(s1)
    80003326:	01279763          	bne	a5,s2,80003334 <namex+0x11e>
    path++;
    8000332a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	ff278de3          	beq	a5,s2,8000332a <namex+0x114>
  if(*path == 0)
    80003334:	cb9d                	beqz	a5,8000336a <namex+0x154>
  while(*path != '/' && *path != 0)
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	89a6                	mv	s3,s1
  len = path - s;
    8000333c:	8d5e                	mv	s10,s7
    8000333e:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003340:	01278963          	beq	a5,s2,80003352 <namex+0x13c>
    80003344:	dbbd                	beqz	a5,800032ba <namex+0xa4>
    path++;
    80003346:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003348:	0009c783          	lbu	a5,0(s3)
    8000334c:	ff279ce3          	bne	a5,s2,80003344 <namex+0x12e>
    80003350:	b7ad                	j	800032ba <namex+0xa4>
    memmove(name, s, len);
    80003352:	2601                	sext.w	a2,a2
    80003354:	85a6                	mv	a1,s1
    80003356:	8556                	mv	a0,s5
    80003358:	ffffd097          	auipc	ra,0xffffd
    8000335c:	eca080e7          	jalr	-310(ra) # 80000222 <memmove>
    name[len] = 0;
    80003360:	9d56                	add	s10,s10,s5
    80003362:	000d0023          	sb	zero,0(s10)
    80003366:	84ce                	mv	s1,s3
    80003368:	b7bd                	j	800032d6 <namex+0xc0>
  if(nameiparent){
    8000336a:	f00b0ce3          	beqz	s6,80003282 <namex+0x6c>
    iput(ip);
    8000336e:	8552                	mv	a0,s4
    80003370:	00000097          	auipc	ra,0x0
    80003374:	acc080e7          	jalr	-1332(ra) # 80002e3c <iput>
    return 0;
    80003378:	4a01                	li	s4,0
    8000337a:	b721                	j	80003282 <namex+0x6c>

000000008000337c <dirlink>:
{
    8000337c:	7139                	addi	sp,sp,-64
    8000337e:	fc06                	sd	ra,56(sp)
    80003380:	f822                	sd	s0,48(sp)
    80003382:	f426                	sd	s1,40(sp)
    80003384:	f04a                	sd	s2,32(sp)
    80003386:	ec4e                	sd	s3,24(sp)
    80003388:	e852                	sd	s4,16(sp)
    8000338a:	0080                	addi	s0,sp,64
    8000338c:	892a                	mv	s2,a0
    8000338e:	8a2e                	mv	s4,a1
    80003390:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003392:	4601                	li	a2,0
    80003394:	00000097          	auipc	ra,0x0
    80003398:	dd2080e7          	jalr	-558(ra) # 80003166 <dirlookup>
    8000339c:	e93d                	bnez	a0,80003412 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000339e:	04c92483          	lw	s1,76(s2)
    800033a2:	c49d                	beqz	s1,800033d0 <dirlink+0x54>
    800033a4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033a6:	4741                	li	a4,16
    800033a8:	86a6                	mv	a3,s1
    800033aa:	fc040613          	addi	a2,s0,-64
    800033ae:	4581                	li	a1,0
    800033b0:	854a                	mv	a0,s2
    800033b2:	00000097          	auipc	ra,0x0
    800033b6:	b84080e7          	jalr	-1148(ra) # 80002f36 <readi>
    800033ba:	47c1                	li	a5,16
    800033bc:	06f51163          	bne	a0,a5,8000341e <dirlink+0xa2>
    if(de.inum == 0)
    800033c0:	fc045783          	lhu	a5,-64(s0)
    800033c4:	c791                	beqz	a5,800033d0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033c6:	24c1                	addiw	s1,s1,16
    800033c8:	04c92783          	lw	a5,76(s2)
    800033cc:	fcf4ede3          	bltu	s1,a5,800033a6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033d0:	4639                	li	a2,14
    800033d2:	85d2                	mv	a1,s4
    800033d4:	fc240513          	addi	a0,s0,-62
    800033d8:	ffffd097          	auipc	ra,0xffffd
    800033dc:	efa080e7          	jalr	-262(ra) # 800002d2 <strncpy>
  de.inum = inum;
    800033e0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033e4:	4741                	li	a4,16
    800033e6:	86a6                	mv	a3,s1
    800033e8:	fc040613          	addi	a2,s0,-64
    800033ec:	4581                	li	a1,0
    800033ee:	854a                	mv	a0,s2
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	c3e080e7          	jalr	-962(ra) # 8000302e <writei>
    800033f8:	1541                	addi	a0,a0,-16
    800033fa:	00a03533          	snez	a0,a0
    800033fe:	40a00533          	neg	a0,a0
}
    80003402:	70e2                	ld	ra,56(sp)
    80003404:	7442                	ld	s0,48(sp)
    80003406:	74a2                	ld	s1,40(sp)
    80003408:	7902                	ld	s2,32(sp)
    8000340a:	69e2                	ld	s3,24(sp)
    8000340c:	6a42                	ld	s4,16(sp)
    8000340e:	6121                	addi	sp,sp,64
    80003410:	8082                	ret
    iput(ip);
    80003412:	00000097          	auipc	ra,0x0
    80003416:	a2a080e7          	jalr	-1494(ra) # 80002e3c <iput>
    return -1;
    8000341a:	557d                	li	a0,-1
    8000341c:	b7dd                	j	80003402 <dirlink+0x86>
      panic("dirlink read");
    8000341e:	00005517          	auipc	a0,0x5
    80003422:	3ca50513          	addi	a0,a0,970 # 800087e8 <syscalls_name+0x1d8>
    80003426:	00003097          	auipc	ra,0x3
    8000342a:	916080e7          	jalr	-1770(ra) # 80005d3c <panic>

000000008000342e <namei>:

struct inode*
namei(char *path)
{
    8000342e:	1101                	addi	sp,sp,-32
    80003430:	ec06                	sd	ra,24(sp)
    80003432:	e822                	sd	s0,16(sp)
    80003434:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003436:	fe040613          	addi	a2,s0,-32
    8000343a:	4581                	li	a1,0
    8000343c:	00000097          	auipc	ra,0x0
    80003440:	dda080e7          	jalr	-550(ra) # 80003216 <namex>
}
    80003444:	60e2                	ld	ra,24(sp)
    80003446:	6442                	ld	s0,16(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000344c:	1141                	addi	sp,sp,-16
    8000344e:	e406                	sd	ra,8(sp)
    80003450:	e022                	sd	s0,0(sp)
    80003452:	0800                	addi	s0,sp,16
    80003454:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003456:	4585                	li	a1,1
    80003458:	00000097          	auipc	ra,0x0
    8000345c:	dbe080e7          	jalr	-578(ra) # 80003216 <namex>
}
    80003460:	60a2                	ld	ra,8(sp)
    80003462:	6402                	ld	s0,0(sp)
    80003464:	0141                	addi	sp,sp,16
    80003466:	8082                	ret

0000000080003468 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003468:	1101                	addi	sp,sp,-32
    8000346a:	ec06                	sd	ra,24(sp)
    8000346c:	e822                	sd	s0,16(sp)
    8000346e:	e426                	sd	s1,8(sp)
    80003470:	e04a                	sd	s2,0(sp)
    80003472:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003474:	00016917          	auipc	s2,0x16
    80003478:	8ac90913          	addi	s2,s2,-1876 # 80018d20 <log>
    8000347c:	01892583          	lw	a1,24(s2)
    80003480:	02892503          	lw	a0,40(s2)
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	fe6080e7          	jalr	-26(ra) # 8000246a <bread>
    8000348c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000348e:	02c92683          	lw	a3,44(s2)
    80003492:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003494:	02d05863          	blez	a3,800034c4 <write_head+0x5c>
    80003498:	00016797          	auipc	a5,0x16
    8000349c:	8b878793          	addi	a5,a5,-1864 # 80018d50 <log+0x30>
    800034a0:	05c50713          	addi	a4,a0,92
    800034a4:	36fd                	addiw	a3,a3,-1
    800034a6:	02069613          	slli	a2,a3,0x20
    800034aa:	01e65693          	srli	a3,a2,0x1e
    800034ae:	00016617          	auipc	a2,0x16
    800034b2:	8a660613          	addi	a2,a2,-1882 # 80018d54 <log+0x34>
    800034b6:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034b8:	4390                	lw	a2,0(a5)
    800034ba:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034bc:	0791                	addi	a5,a5,4
    800034be:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800034c0:	fed79ce3          	bne	a5,a3,800034b8 <write_head+0x50>
  }
  bwrite(buf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	096080e7          	jalr	150(ra) # 8000255c <bwrite>
  brelse(buf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	0ca080e7          	jalr	202(ra) # 8000259a <brelse>
}
    800034d8:	60e2                	ld	ra,24(sp)
    800034da:	6442                	ld	s0,16(sp)
    800034dc:	64a2                	ld	s1,8(sp)
    800034de:	6902                	ld	s2,0(sp)
    800034e0:	6105                	addi	sp,sp,32
    800034e2:	8082                	ret

00000000800034e4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034e4:	00016797          	auipc	a5,0x16
    800034e8:	8687a783          	lw	a5,-1944(a5) # 80018d4c <log+0x2c>
    800034ec:	0af05d63          	blez	a5,800035a6 <install_trans+0xc2>
{
    800034f0:	7139                	addi	sp,sp,-64
    800034f2:	fc06                	sd	ra,56(sp)
    800034f4:	f822                	sd	s0,48(sp)
    800034f6:	f426                	sd	s1,40(sp)
    800034f8:	f04a                	sd	s2,32(sp)
    800034fa:	ec4e                	sd	s3,24(sp)
    800034fc:	e852                	sd	s4,16(sp)
    800034fe:	e456                	sd	s5,8(sp)
    80003500:	e05a                	sd	s6,0(sp)
    80003502:	0080                	addi	s0,sp,64
    80003504:	8b2a                	mv	s6,a0
    80003506:	00016a97          	auipc	s5,0x16
    8000350a:	84aa8a93          	addi	s5,s5,-1974 # 80018d50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000350e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003510:	00016997          	auipc	s3,0x16
    80003514:	81098993          	addi	s3,s3,-2032 # 80018d20 <log>
    80003518:	a00d                	j	8000353a <install_trans+0x56>
    brelse(lbuf);
    8000351a:	854a                	mv	a0,s2
    8000351c:	fffff097          	auipc	ra,0xfffff
    80003520:	07e080e7          	jalr	126(ra) # 8000259a <brelse>
    brelse(dbuf);
    80003524:	8526                	mv	a0,s1
    80003526:	fffff097          	auipc	ra,0xfffff
    8000352a:	074080e7          	jalr	116(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352e:	2a05                	addiw	s4,s4,1
    80003530:	0a91                	addi	s5,s5,4
    80003532:	02c9a783          	lw	a5,44(s3)
    80003536:	04fa5e63          	bge	s4,a5,80003592 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000353a:	0189a583          	lw	a1,24(s3)
    8000353e:	014585bb          	addw	a1,a1,s4
    80003542:	2585                	addiw	a1,a1,1
    80003544:	0289a503          	lw	a0,40(s3)
    80003548:	fffff097          	auipc	ra,0xfffff
    8000354c:	f22080e7          	jalr	-222(ra) # 8000246a <bread>
    80003550:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003552:	000aa583          	lw	a1,0(s5)
    80003556:	0289a503          	lw	a0,40(s3)
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	f10080e7          	jalr	-240(ra) # 8000246a <bread>
    80003562:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003564:	40000613          	li	a2,1024
    80003568:	05890593          	addi	a1,s2,88
    8000356c:	05850513          	addi	a0,a0,88
    80003570:	ffffd097          	auipc	ra,0xffffd
    80003574:	cb2080e7          	jalr	-846(ra) # 80000222 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	fe2080e7          	jalr	-30(ra) # 8000255c <bwrite>
    if(recovering == 0)
    80003582:	f80b1ce3          	bnez	s6,8000351a <install_trans+0x36>
      bunpin(dbuf);
    80003586:	8526                	mv	a0,s1
    80003588:	fffff097          	auipc	ra,0xfffff
    8000358c:	0ec080e7          	jalr	236(ra) # 80002674 <bunpin>
    80003590:	b769                	j	8000351a <install_trans+0x36>
}
    80003592:	70e2                	ld	ra,56(sp)
    80003594:	7442                	ld	s0,48(sp)
    80003596:	74a2                	ld	s1,40(sp)
    80003598:	7902                	ld	s2,32(sp)
    8000359a:	69e2                	ld	s3,24(sp)
    8000359c:	6a42                	ld	s4,16(sp)
    8000359e:	6aa2                	ld	s5,8(sp)
    800035a0:	6b02                	ld	s6,0(sp)
    800035a2:	6121                	addi	sp,sp,64
    800035a4:	8082                	ret
    800035a6:	8082                	ret

00000000800035a8 <initlog>:
{
    800035a8:	7179                	addi	sp,sp,-48
    800035aa:	f406                	sd	ra,40(sp)
    800035ac:	f022                	sd	s0,32(sp)
    800035ae:	ec26                	sd	s1,24(sp)
    800035b0:	e84a                	sd	s2,16(sp)
    800035b2:	e44e                	sd	s3,8(sp)
    800035b4:	1800                	addi	s0,sp,48
    800035b6:	892a                	mv	s2,a0
    800035b8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035ba:	00015497          	auipc	s1,0x15
    800035be:	76648493          	addi	s1,s1,1894 # 80018d20 <log>
    800035c2:	00005597          	auipc	a1,0x5
    800035c6:	23658593          	addi	a1,a1,566 # 800087f8 <syscalls_name+0x1e8>
    800035ca:	8526                	mv	a0,s1
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	c18080e7          	jalr	-1000(ra) # 800061e4 <initlock>
  log.start = sb->logstart;
    800035d4:	0149a583          	lw	a1,20(s3)
    800035d8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035da:	0109a783          	lw	a5,16(s3)
    800035de:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035e0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035e4:	854a                	mv	a0,s2
    800035e6:	fffff097          	auipc	ra,0xfffff
    800035ea:	e84080e7          	jalr	-380(ra) # 8000246a <bread>
  log.lh.n = lh->n;
    800035ee:	4d34                	lw	a3,88(a0)
    800035f0:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035f2:	02d05663          	blez	a3,8000361e <initlog+0x76>
    800035f6:	05c50793          	addi	a5,a0,92
    800035fa:	00015717          	auipc	a4,0x15
    800035fe:	75670713          	addi	a4,a4,1878 # 80018d50 <log+0x30>
    80003602:	36fd                	addiw	a3,a3,-1
    80003604:	02069613          	slli	a2,a3,0x20
    80003608:	01e65693          	srli	a3,a2,0x1e
    8000360c:	06050613          	addi	a2,a0,96
    80003610:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003612:	4390                	lw	a2,0(a5)
    80003614:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003616:	0791                	addi	a5,a5,4
    80003618:	0711                	addi	a4,a4,4
    8000361a:	fed79ce3          	bne	a5,a3,80003612 <initlog+0x6a>
  brelse(buf);
    8000361e:	fffff097          	auipc	ra,0xfffff
    80003622:	f7c080e7          	jalr	-132(ra) # 8000259a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003626:	4505                	li	a0,1
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	ebc080e7          	jalr	-324(ra) # 800034e4 <install_trans>
  log.lh.n = 0;
    80003630:	00015797          	auipc	a5,0x15
    80003634:	7007ae23          	sw	zero,1820(a5) # 80018d4c <log+0x2c>
  write_head(); // clear the log
    80003638:	00000097          	auipc	ra,0x0
    8000363c:	e30080e7          	jalr	-464(ra) # 80003468 <write_head>
}
    80003640:	70a2                	ld	ra,40(sp)
    80003642:	7402                	ld	s0,32(sp)
    80003644:	64e2                	ld	s1,24(sp)
    80003646:	6942                	ld	s2,16(sp)
    80003648:	69a2                	ld	s3,8(sp)
    8000364a:	6145                	addi	sp,sp,48
    8000364c:	8082                	ret

000000008000364e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000364e:	1101                	addi	sp,sp,-32
    80003650:	ec06                	sd	ra,24(sp)
    80003652:	e822                	sd	s0,16(sp)
    80003654:	e426                	sd	s1,8(sp)
    80003656:	e04a                	sd	s2,0(sp)
    80003658:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000365a:	00015517          	auipc	a0,0x15
    8000365e:	6c650513          	addi	a0,a0,1734 # 80018d20 <log>
    80003662:	00003097          	auipc	ra,0x3
    80003666:	c12080e7          	jalr	-1006(ra) # 80006274 <acquire>
  while(1){
    if(log.committing){
    8000366a:	00015497          	auipc	s1,0x15
    8000366e:	6b648493          	addi	s1,s1,1718 # 80018d20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003672:	4979                	li	s2,30
    80003674:	a039                	j	80003682 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003676:	85a6                	mv	a1,s1
    80003678:	8526                	mv	a0,s1
    8000367a:	ffffe097          	auipc	ra,0xffffe
    8000367e:	efc080e7          	jalr	-260(ra) # 80001576 <sleep>
    if(log.committing){
    80003682:	50dc                	lw	a5,36(s1)
    80003684:	fbed                	bnez	a5,80003676 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003686:	5098                	lw	a4,32(s1)
    80003688:	2705                	addiw	a4,a4,1
    8000368a:	0007069b          	sext.w	a3,a4
    8000368e:	0027179b          	slliw	a5,a4,0x2
    80003692:	9fb9                	addw	a5,a5,a4
    80003694:	0017979b          	slliw	a5,a5,0x1
    80003698:	54d8                	lw	a4,44(s1)
    8000369a:	9fb9                	addw	a5,a5,a4
    8000369c:	00f95963          	bge	s2,a5,800036ae <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036a0:	85a6                	mv	a1,s1
    800036a2:	8526                	mv	a0,s1
    800036a4:	ffffe097          	auipc	ra,0xffffe
    800036a8:	ed2080e7          	jalr	-302(ra) # 80001576 <sleep>
    800036ac:	bfd9                	j	80003682 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036ae:	00015517          	auipc	a0,0x15
    800036b2:	67250513          	addi	a0,a0,1650 # 80018d20 <log>
    800036b6:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	c70080e7          	jalr	-912(ra) # 80006328 <release>
      break;
    }
  }
}
    800036c0:	60e2                	ld	ra,24(sp)
    800036c2:	6442                	ld	s0,16(sp)
    800036c4:	64a2                	ld	s1,8(sp)
    800036c6:	6902                	ld	s2,0(sp)
    800036c8:	6105                	addi	sp,sp,32
    800036ca:	8082                	ret

00000000800036cc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036cc:	7139                	addi	sp,sp,-64
    800036ce:	fc06                	sd	ra,56(sp)
    800036d0:	f822                	sd	s0,48(sp)
    800036d2:	f426                	sd	s1,40(sp)
    800036d4:	f04a                	sd	s2,32(sp)
    800036d6:	ec4e                	sd	s3,24(sp)
    800036d8:	e852                	sd	s4,16(sp)
    800036da:	e456                	sd	s5,8(sp)
    800036dc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036de:	00015497          	auipc	s1,0x15
    800036e2:	64248493          	addi	s1,s1,1602 # 80018d20 <log>
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	b8c080e7          	jalr	-1140(ra) # 80006274 <acquire>
  log.outstanding -= 1;
    800036f0:	509c                	lw	a5,32(s1)
    800036f2:	37fd                	addiw	a5,a5,-1
    800036f4:	0007891b          	sext.w	s2,a5
    800036f8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036fa:	50dc                	lw	a5,36(s1)
    800036fc:	e7b9                	bnez	a5,8000374a <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036fe:	04091e63          	bnez	s2,8000375a <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003702:	00015497          	auipc	s1,0x15
    80003706:	61e48493          	addi	s1,s1,1566 # 80018d20 <log>
    8000370a:	4785                	li	a5,1
    8000370c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000370e:	8526                	mv	a0,s1
    80003710:	00003097          	auipc	ra,0x3
    80003714:	c18080e7          	jalr	-1000(ra) # 80006328 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003718:	54dc                	lw	a5,44(s1)
    8000371a:	06f04763          	bgtz	a5,80003788 <end_op+0xbc>
    acquire(&log.lock);
    8000371e:	00015497          	auipc	s1,0x15
    80003722:	60248493          	addi	s1,s1,1538 # 80018d20 <log>
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	b4c080e7          	jalr	-1204(ra) # 80006274 <acquire>
    log.committing = 0;
    80003730:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003734:	8526                	mv	a0,s1
    80003736:	ffffe097          	auipc	ra,0xffffe
    8000373a:	eae080e7          	jalr	-338(ra) # 800015e4 <wakeup>
    release(&log.lock);
    8000373e:	8526                	mv	a0,s1
    80003740:	00003097          	auipc	ra,0x3
    80003744:	be8080e7          	jalr	-1048(ra) # 80006328 <release>
}
    80003748:	a03d                	j	80003776 <end_op+0xaa>
    panic("log.committing");
    8000374a:	00005517          	auipc	a0,0x5
    8000374e:	0b650513          	addi	a0,a0,182 # 80008800 <syscalls_name+0x1f0>
    80003752:	00002097          	auipc	ra,0x2
    80003756:	5ea080e7          	jalr	1514(ra) # 80005d3c <panic>
    wakeup(&log);
    8000375a:	00015497          	auipc	s1,0x15
    8000375e:	5c648493          	addi	s1,s1,1478 # 80018d20 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	ffffe097          	auipc	ra,0xffffe
    80003768:	e80080e7          	jalr	-384(ra) # 800015e4 <wakeup>
  release(&log.lock);
    8000376c:	8526                	mv	a0,s1
    8000376e:	00003097          	auipc	ra,0x3
    80003772:	bba080e7          	jalr	-1094(ra) # 80006328 <release>
}
    80003776:	70e2                	ld	ra,56(sp)
    80003778:	7442                	ld	s0,48(sp)
    8000377a:	74a2                	ld	s1,40(sp)
    8000377c:	7902                	ld	s2,32(sp)
    8000377e:	69e2                	ld	s3,24(sp)
    80003780:	6a42                	ld	s4,16(sp)
    80003782:	6aa2                	ld	s5,8(sp)
    80003784:	6121                	addi	sp,sp,64
    80003786:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80003788:	00015a97          	auipc	s5,0x15
    8000378c:	5c8a8a93          	addi	s5,s5,1480 # 80018d50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003790:	00015a17          	auipc	s4,0x15
    80003794:	590a0a13          	addi	s4,s4,1424 # 80018d20 <log>
    80003798:	018a2583          	lw	a1,24(s4)
    8000379c:	012585bb          	addw	a1,a1,s2
    800037a0:	2585                	addiw	a1,a1,1
    800037a2:	028a2503          	lw	a0,40(s4)
    800037a6:	fffff097          	auipc	ra,0xfffff
    800037aa:	cc4080e7          	jalr	-828(ra) # 8000246a <bread>
    800037ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037b0:	000aa583          	lw	a1,0(s5)
    800037b4:	028a2503          	lw	a0,40(s4)
    800037b8:	fffff097          	auipc	ra,0xfffff
    800037bc:	cb2080e7          	jalr	-846(ra) # 8000246a <bread>
    800037c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037c2:	40000613          	li	a2,1024
    800037c6:	05850593          	addi	a1,a0,88
    800037ca:	05848513          	addi	a0,s1,88
    800037ce:	ffffd097          	auipc	ra,0xffffd
    800037d2:	a54080e7          	jalr	-1452(ra) # 80000222 <memmove>
    bwrite(to);  // write the log
    800037d6:	8526                	mv	a0,s1
    800037d8:	fffff097          	auipc	ra,0xfffff
    800037dc:	d84080e7          	jalr	-636(ra) # 8000255c <bwrite>
    brelse(from);
    800037e0:	854e                	mv	a0,s3
    800037e2:	fffff097          	auipc	ra,0xfffff
    800037e6:	db8080e7          	jalr	-584(ra) # 8000259a <brelse>
    brelse(to);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	dae080e7          	jalr	-594(ra) # 8000259a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037f4:	2905                	addiw	s2,s2,1
    800037f6:	0a91                	addi	s5,s5,4
    800037f8:	02ca2783          	lw	a5,44(s4)
    800037fc:	f8f94ee3          	blt	s2,a5,80003798 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003800:	00000097          	auipc	ra,0x0
    80003804:	c68080e7          	jalr	-920(ra) # 80003468 <write_head>
    install_trans(0); // Now install writes to home locations
    80003808:	4501                	li	a0,0
    8000380a:	00000097          	auipc	ra,0x0
    8000380e:	cda080e7          	jalr	-806(ra) # 800034e4 <install_trans>
    log.lh.n = 0;
    80003812:	00015797          	auipc	a5,0x15
    80003816:	5207ad23          	sw	zero,1338(a5) # 80018d4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000381a:	00000097          	auipc	ra,0x0
    8000381e:	c4e080e7          	jalr	-946(ra) # 80003468 <write_head>
    80003822:	bdf5                	j	8000371e <end_op+0x52>

0000000080003824 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003824:	1101                	addi	sp,sp,-32
    80003826:	ec06                	sd	ra,24(sp)
    80003828:	e822                	sd	s0,16(sp)
    8000382a:	e426                	sd	s1,8(sp)
    8000382c:	e04a                	sd	s2,0(sp)
    8000382e:	1000                	addi	s0,sp,32
    80003830:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003832:	00015917          	auipc	s2,0x15
    80003836:	4ee90913          	addi	s2,s2,1262 # 80018d20 <log>
    8000383a:	854a                	mv	a0,s2
    8000383c:	00003097          	auipc	ra,0x3
    80003840:	a38080e7          	jalr	-1480(ra) # 80006274 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003844:	02c92603          	lw	a2,44(s2)
    80003848:	47f5                	li	a5,29
    8000384a:	06c7c563          	blt	a5,a2,800038b4 <log_write+0x90>
    8000384e:	00015797          	auipc	a5,0x15
    80003852:	4ee7a783          	lw	a5,1262(a5) # 80018d3c <log+0x1c>
    80003856:	37fd                	addiw	a5,a5,-1
    80003858:	04f65e63          	bge	a2,a5,800038b4 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000385c:	00015797          	auipc	a5,0x15
    80003860:	4e47a783          	lw	a5,1252(a5) # 80018d40 <log+0x20>
    80003864:	06f05063          	blez	a5,800038c4 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003868:	4781                	li	a5,0
    8000386a:	06c05563          	blez	a2,800038d4 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000386e:	44cc                	lw	a1,12(s1)
    80003870:	00015717          	auipc	a4,0x15
    80003874:	4e070713          	addi	a4,a4,1248 # 80018d50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003878:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000387a:	4314                	lw	a3,0(a4)
    8000387c:	04b68c63          	beq	a3,a1,800038d4 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003880:	2785                	addiw	a5,a5,1
    80003882:	0711                	addi	a4,a4,4
    80003884:	fef61be3          	bne	a2,a5,8000387a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003888:	0621                	addi	a2,a2,8
    8000388a:	060a                	slli	a2,a2,0x2
    8000388c:	00015797          	auipc	a5,0x15
    80003890:	49478793          	addi	a5,a5,1172 # 80018d20 <log>
    80003894:	97b2                	add	a5,a5,a2
    80003896:	44d8                	lw	a4,12(s1)
    80003898:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000389a:	8526                	mv	a0,s1
    8000389c:	fffff097          	auipc	ra,0xfffff
    800038a0:	d9c080e7          	jalr	-612(ra) # 80002638 <bpin>
    log.lh.n++;
    800038a4:	00015717          	auipc	a4,0x15
    800038a8:	47c70713          	addi	a4,a4,1148 # 80018d20 <log>
    800038ac:	575c                	lw	a5,44(a4)
    800038ae:	2785                	addiw	a5,a5,1
    800038b0:	d75c                	sw	a5,44(a4)
    800038b2:	a82d                	j	800038ec <log_write+0xc8>
    panic("too big a transaction");
    800038b4:	00005517          	auipc	a0,0x5
    800038b8:	f5c50513          	addi	a0,a0,-164 # 80008810 <syscalls_name+0x200>
    800038bc:	00002097          	auipc	ra,0x2
    800038c0:	480080e7          	jalr	1152(ra) # 80005d3c <panic>
    panic("log_write outside of trans");
    800038c4:	00005517          	auipc	a0,0x5
    800038c8:	f6450513          	addi	a0,a0,-156 # 80008828 <syscalls_name+0x218>
    800038cc:	00002097          	auipc	ra,0x2
    800038d0:	470080e7          	jalr	1136(ra) # 80005d3c <panic>
  log.lh.block[i] = b->blockno;
    800038d4:	00878693          	addi	a3,a5,8
    800038d8:	068a                	slli	a3,a3,0x2
    800038da:	00015717          	auipc	a4,0x15
    800038de:	44670713          	addi	a4,a4,1094 # 80018d20 <log>
    800038e2:	9736                	add	a4,a4,a3
    800038e4:	44d4                	lw	a3,12(s1)
    800038e6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038e8:	faf609e3          	beq	a2,a5,8000389a <log_write+0x76>
  }
  release(&log.lock);
    800038ec:	00015517          	auipc	a0,0x15
    800038f0:	43450513          	addi	a0,a0,1076 # 80018d20 <log>
    800038f4:	00003097          	auipc	ra,0x3
    800038f8:	a34080e7          	jalr	-1484(ra) # 80006328 <release>
}
    800038fc:	60e2                	ld	ra,24(sp)
    800038fe:	6442                	ld	s0,16(sp)
    80003900:	64a2                	ld	s1,8(sp)
    80003902:	6902                	ld	s2,0(sp)
    80003904:	6105                	addi	sp,sp,32
    80003906:	8082                	ret

0000000080003908 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003908:	1101                	addi	sp,sp,-32
    8000390a:	ec06                	sd	ra,24(sp)
    8000390c:	e822                	sd	s0,16(sp)
    8000390e:	e426                	sd	s1,8(sp)
    80003910:	e04a                	sd	s2,0(sp)
    80003912:	1000                	addi	s0,sp,32
    80003914:	84aa                	mv	s1,a0
    80003916:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003918:	00005597          	auipc	a1,0x5
    8000391c:	f3058593          	addi	a1,a1,-208 # 80008848 <syscalls_name+0x238>
    80003920:	0521                	addi	a0,a0,8
    80003922:	00003097          	auipc	ra,0x3
    80003926:	8c2080e7          	jalr	-1854(ra) # 800061e4 <initlock>
  lk->name = name;
    8000392a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000392e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003932:	0204a423          	sw	zero,40(s1)
}
    80003936:	60e2                	ld	ra,24(sp)
    80003938:	6442                	ld	s0,16(sp)
    8000393a:	64a2                	ld	s1,8(sp)
    8000393c:	6902                	ld	s2,0(sp)
    8000393e:	6105                	addi	sp,sp,32
    80003940:	8082                	ret

0000000080003942 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003942:	1101                	addi	sp,sp,-32
    80003944:	ec06                	sd	ra,24(sp)
    80003946:	e822                	sd	s0,16(sp)
    80003948:	e426                	sd	s1,8(sp)
    8000394a:	e04a                	sd	s2,0(sp)
    8000394c:	1000                	addi	s0,sp,32
    8000394e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003950:	00850913          	addi	s2,a0,8
    80003954:	854a                	mv	a0,s2
    80003956:	00003097          	auipc	ra,0x3
    8000395a:	91e080e7          	jalr	-1762(ra) # 80006274 <acquire>
  while (lk->locked) {
    8000395e:	409c                	lw	a5,0(s1)
    80003960:	cb89                	beqz	a5,80003972 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003962:	85ca                	mv	a1,s2
    80003964:	8526                	mv	a0,s1
    80003966:	ffffe097          	auipc	ra,0xffffe
    8000396a:	c10080e7          	jalr	-1008(ra) # 80001576 <sleep>
  while (lk->locked) {
    8000396e:	409c                	lw	a5,0(s1)
    80003970:	fbed                	bnez	a5,80003962 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003972:	4785                	li	a5,1
    80003974:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003976:	ffffd097          	auipc	ra,0xffffd
    8000397a:	52c080e7          	jalr	1324(ra) # 80000ea2 <myproc>
    8000397e:	5d1c                	lw	a5,56(a0)
    80003980:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	9a4080e7          	jalr	-1628(ra) # 80006328 <release>
}
    8000398c:	60e2                	ld	ra,24(sp)
    8000398e:	6442                	ld	s0,16(sp)
    80003990:	64a2                	ld	s1,8(sp)
    80003992:	6902                	ld	s2,0(sp)
    80003994:	6105                	addi	sp,sp,32
    80003996:	8082                	ret

0000000080003998 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003998:	1101                	addi	sp,sp,-32
    8000399a:	ec06                	sd	ra,24(sp)
    8000399c:	e822                	sd	s0,16(sp)
    8000399e:	e426                	sd	s1,8(sp)
    800039a0:	e04a                	sd	s2,0(sp)
    800039a2:	1000                	addi	s0,sp,32
    800039a4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039a6:	00850913          	addi	s2,a0,8
    800039aa:	854a                	mv	a0,s2
    800039ac:	00003097          	auipc	ra,0x3
    800039b0:	8c8080e7          	jalr	-1848(ra) # 80006274 <acquire>
  lk->locked = 0;
    800039b4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039b8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039bc:	8526                	mv	a0,s1
    800039be:	ffffe097          	auipc	ra,0xffffe
    800039c2:	c26080e7          	jalr	-986(ra) # 800015e4 <wakeup>
  release(&lk->lk);
    800039c6:	854a                	mv	a0,s2
    800039c8:	00003097          	auipc	ra,0x3
    800039cc:	960080e7          	jalr	-1696(ra) # 80006328 <release>
}
    800039d0:	60e2                	ld	ra,24(sp)
    800039d2:	6442                	ld	s0,16(sp)
    800039d4:	64a2                	ld	s1,8(sp)
    800039d6:	6902                	ld	s2,0(sp)
    800039d8:	6105                	addi	sp,sp,32
    800039da:	8082                	ret

00000000800039dc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039dc:	7179                	addi	sp,sp,-48
    800039de:	f406                	sd	ra,40(sp)
    800039e0:	f022                	sd	s0,32(sp)
    800039e2:	ec26                	sd	s1,24(sp)
    800039e4:	e84a                	sd	s2,16(sp)
    800039e6:	e44e                	sd	s3,8(sp)
    800039e8:	1800                	addi	s0,sp,48
    800039ea:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039ec:	00850913          	addi	s2,a0,8
    800039f0:	854a                	mv	a0,s2
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	882080e7          	jalr	-1918(ra) # 80006274 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039fa:	409c                	lw	a5,0(s1)
    800039fc:	ef99                	bnez	a5,80003a1a <holdingsleep+0x3e>
    800039fe:	4481                	li	s1,0
  release(&lk->lk);
    80003a00:	854a                	mv	a0,s2
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	926080e7          	jalr	-1754(ra) # 80006328 <release>
  return r;
}
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	70a2                	ld	ra,40(sp)
    80003a0e:	7402                	ld	s0,32(sp)
    80003a10:	64e2                	ld	s1,24(sp)
    80003a12:	6942                	ld	s2,16(sp)
    80003a14:	69a2                	ld	s3,8(sp)
    80003a16:	6145                	addi	sp,sp,48
    80003a18:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a1a:	0284a983          	lw	s3,40(s1)
    80003a1e:	ffffd097          	auipc	ra,0xffffd
    80003a22:	484080e7          	jalr	1156(ra) # 80000ea2 <myproc>
    80003a26:	5d04                	lw	s1,56(a0)
    80003a28:	413484b3          	sub	s1,s1,s3
    80003a2c:	0014b493          	seqz	s1,s1
    80003a30:	bfc1                	j	80003a00 <holdingsleep+0x24>

0000000080003a32 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a32:	1141                	addi	sp,sp,-16
    80003a34:	e406                	sd	ra,8(sp)
    80003a36:	e022                	sd	s0,0(sp)
    80003a38:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a3a:	00005597          	auipc	a1,0x5
    80003a3e:	e1e58593          	addi	a1,a1,-482 # 80008858 <syscalls_name+0x248>
    80003a42:	00015517          	auipc	a0,0x15
    80003a46:	42650513          	addi	a0,a0,1062 # 80018e68 <ftable>
    80003a4a:	00002097          	auipc	ra,0x2
    80003a4e:	79a080e7          	jalr	1946(ra) # 800061e4 <initlock>
}
    80003a52:	60a2                	ld	ra,8(sp)
    80003a54:	6402                	ld	s0,0(sp)
    80003a56:	0141                	addi	sp,sp,16
    80003a58:	8082                	ret

0000000080003a5a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a5a:	1101                	addi	sp,sp,-32
    80003a5c:	ec06                	sd	ra,24(sp)
    80003a5e:	e822                	sd	s0,16(sp)
    80003a60:	e426                	sd	s1,8(sp)
    80003a62:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a64:	00015517          	auipc	a0,0x15
    80003a68:	40450513          	addi	a0,a0,1028 # 80018e68 <ftable>
    80003a6c:	00003097          	auipc	ra,0x3
    80003a70:	808080e7          	jalr	-2040(ra) # 80006274 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a74:	00015497          	auipc	s1,0x15
    80003a78:	40c48493          	addi	s1,s1,1036 # 80018e80 <ftable+0x18>
    80003a7c:	00016717          	auipc	a4,0x16
    80003a80:	3a470713          	addi	a4,a4,932 # 80019e20 <disk>
    if(f->ref == 0){
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	cf99                	beqz	a5,80003aa4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a88:	02848493          	addi	s1,s1,40
    80003a8c:	fee49ce3          	bne	s1,a4,80003a84 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a90:	00015517          	auipc	a0,0x15
    80003a94:	3d850513          	addi	a0,a0,984 # 80018e68 <ftable>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	890080e7          	jalr	-1904(ra) # 80006328 <release>
  return 0;
    80003aa0:	4481                	li	s1,0
    80003aa2:	a819                	j	80003ab8 <filealloc+0x5e>
      f->ref = 1;
    80003aa4:	4785                	li	a5,1
    80003aa6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa8:	00015517          	auipc	a0,0x15
    80003aac:	3c050513          	addi	a0,a0,960 # 80018e68 <ftable>
    80003ab0:	00003097          	auipc	ra,0x3
    80003ab4:	878080e7          	jalr	-1928(ra) # 80006328 <release>
}
    80003ab8:	8526                	mv	a0,s1
    80003aba:	60e2                	ld	ra,24(sp)
    80003abc:	6442                	ld	s0,16(sp)
    80003abe:	64a2                	ld	s1,8(sp)
    80003ac0:	6105                	addi	sp,sp,32
    80003ac2:	8082                	ret

0000000080003ac4 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ac4:	1101                	addi	sp,sp,-32
    80003ac6:	ec06                	sd	ra,24(sp)
    80003ac8:	e822                	sd	s0,16(sp)
    80003aca:	e426                	sd	s1,8(sp)
    80003acc:	1000                	addi	s0,sp,32
    80003ace:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ad0:	00015517          	auipc	a0,0x15
    80003ad4:	39850513          	addi	a0,a0,920 # 80018e68 <ftable>
    80003ad8:	00002097          	auipc	ra,0x2
    80003adc:	79c080e7          	jalr	1948(ra) # 80006274 <acquire>
  if(f->ref < 1)
    80003ae0:	40dc                	lw	a5,4(s1)
    80003ae2:	02f05263          	blez	a5,80003b06 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ae6:	2785                	addiw	a5,a5,1
    80003ae8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003aea:	00015517          	auipc	a0,0x15
    80003aee:	37e50513          	addi	a0,a0,894 # 80018e68 <ftable>
    80003af2:	00003097          	auipc	ra,0x3
    80003af6:	836080e7          	jalr	-1994(ra) # 80006328 <release>
  return f;
}
    80003afa:	8526                	mv	a0,s1
    80003afc:	60e2                	ld	ra,24(sp)
    80003afe:	6442                	ld	s0,16(sp)
    80003b00:	64a2                	ld	s1,8(sp)
    80003b02:	6105                	addi	sp,sp,32
    80003b04:	8082                	ret
    panic("filedup");
    80003b06:	00005517          	auipc	a0,0x5
    80003b0a:	d5a50513          	addi	a0,a0,-678 # 80008860 <syscalls_name+0x250>
    80003b0e:	00002097          	auipc	ra,0x2
    80003b12:	22e080e7          	jalr	558(ra) # 80005d3c <panic>

0000000080003b16 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b16:	7139                	addi	sp,sp,-64
    80003b18:	fc06                	sd	ra,56(sp)
    80003b1a:	f822                	sd	s0,48(sp)
    80003b1c:	f426                	sd	s1,40(sp)
    80003b1e:	f04a                	sd	s2,32(sp)
    80003b20:	ec4e                	sd	s3,24(sp)
    80003b22:	e852                	sd	s4,16(sp)
    80003b24:	e456                	sd	s5,8(sp)
    80003b26:	0080                	addi	s0,sp,64
    80003b28:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b2a:	00015517          	auipc	a0,0x15
    80003b2e:	33e50513          	addi	a0,a0,830 # 80018e68 <ftable>
    80003b32:	00002097          	auipc	ra,0x2
    80003b36:	742080e7          	jalr	1858(ra) # 80006274 <acquire>
  if(f->ref < 1)
    80003b3a:	40dc                	lw	a5,4(s1)
    80003b3c:	06f05163          	blez	a5,80003b9e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b40:	37fd                	addiw	a5,a5,-1
    80003b42:	0007871b          	sext.w	a4,a5
    80003b46:	c0dc                	sw	a5,4(s1)
    80003b48:	06e04363          	bgtz	a4,80003bae <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b4c:	0004a903          	lw	s2,0(s1)
    80003b50:	0094ca83          	lbu	s5,9(s1)
    80003b54:	0104ba03          	ld	s4,16(s1)
    80003b58:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b5c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b60:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b64:	00015517          	auipc	a0,0x15
    80003b68:	30450513          	addi	a0,a0,772 # 80018e68 <ftable>
    80003b6c:	00002097          	auipc	ra,0x2
    80003b70:	7bc080e7          	jalr	1980(ra) # 80006328 <release>

  if(ff.type == FD_PIPE){
    80003b74:	4785                	li	a5,1
    80003b76:	04f90d63          	beq	s2,a5,80003bd0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b7a:	3979                	addiw	s2,s2,-2
    80003b7c:	4785                	li	a5,1
    80003b7e:	0527e063          	bltu	a5,s2,80003bbe <fileclose+0xa8>
    begin_op();
    80003b82:	00000097          	auipc	ra,0x0
    80003b86:	acc080e7          	jalr	-1332(ra) # 8000364e <begin_op>
    iput(ff.ip);
    80003b8a:	854e                	mv	a0,s3
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	2b0080e7          	jalr	688(ra) # 80002e3c <iput>
    end_op();
    80003b94:	00000097          	auipc	ra,0x0
    80003b98:	b38080e7          	jalr	-1224(ra) # 800036cc <end_op>
    80003b9c:	a00d                	j	80003bbe <fileclose+0xa8>
    panic("fileclose");
    80003b9e:	00005517          	auipc	a0,0x5
    80003ba2:	cca50513          	addi	a0,a0,-822 # 80008868 <syscalls_name+0x258>
    80003ba6:	00002097          	auipc	ra,0x2
    80003baa:	196080e7          	jalr	406(ra) # 80005d3c <panic>
    release(&ftable.lock);
    80003bae:	00015517          	auipc	a0,0x15
    80003bb2:	2ba50513          	addi	a0,a0,698 # 80018e68 <ftable>
    80003bb6:	00002097          	auipc	ra,0x2
    80003bba:	772080e7          	jalr	1906(ra) # 80006328 <release>
  }
}
    80003bbe:	70e2                	ld	ra,56(sp)
    80003bc0:	7442                	ld	s0,48(sp)
    80003bc2:	74a2                	ld	s1,40(sp)
    80003bc4:	7902                	ld	s2,32(sp)
    80003bc6:	69e2                	ld	s3,24(sp)
    80003bc8:	6a42                	ld	s4,16(sp)
    80003bca:	6aa2                	ld	s5,8(sp)
    80003bcc:	6121                	addi	sp,sp,64
    80003bce:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bd0:	85d6                	mv	a1,s5
    80003bd2:	8552                	mv	a0,s4
    80003bd4:	00000097          	auipc	ra,0x0
    80003bd8:	34c080e7          	jalr	844(ra) # 80003f20 <pipeclose>
    80003bdc:	b7cd                	j	80003bbe <fileclose+0xa8>

0000000080003bde <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bde:	715d                	addi	sp,sp,-80
    80003be0:	e486                	sd	ra,72(sp)
    80003be2:	e0a2                	sd	s0,64(sp)
    80003be4:	fc26                	sd	s1,56(sp)
    80003be6:	f84a                	sd	s2,48(sp)
    80003be8:	f44e                	sd	s3,40(sp)
    80003bea:	0880                	addi	s0,sp,80
    80003bec:	84aa                	mv	s1,a0
    80003bee:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003bf0:	ffffd097          	auipc	ra,0xffffd
    80003bf4:	2b2080e7          	jalr	690(ra) # 80000ea2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bf8:	409c                	lw	a5,0(s1)
    80003bfa:	37f9                	addiw	a5,a5,-2
    80003bfc:	4705                	li	a4,1
    80003bfe:	04f76763          	bltu	a4,a5,80003c4c <filestat+0x6e>
    80003c02:	892a                	mv	s2,a0
    ilock(f->ip);
    80003c04:	6c88                	ld	a0,24(s1)
    80003c06:	fffff097          	auipc	ra,0xfffff
    80003c0a:	07c080e7          	jalr	124(ra) # 80002c82 <ilock>
    stati(f->ip, &st);
    80003c0e:	fb840593          	addi	a1,s0,-72
    80003c12:	6c88                	ld	a0,24(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	2f8080e7          	jalr	760(ra) # 80002f0c <stati>
    iunlock(f->ip);
    80003c1c:	6c88                	ld	a0,24(s1)
    80003c1e:	fffff097          	auipc	ra,0xfffff
    80003c22:	126080e7          	jalr	294(ra) # 80002d44 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c26:	46e1                	li	a3,24
    80003c28:	fb840613          	addi	a2,s0,-72
    80003c2c:	85ce                	mv	a1,s3
    80003c2e:	05893503          	ld	a0,88(s2)
    80003c32:	ffffd097          	auipc	ra,0xffffd
    80003c36:	f2e080e7          	jalr	-210(ra) # 80000b60 <copyout>
    80003c3a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c3e:	60a6                	ld	ra,72(sp)
    80003c40:	6406                	ld	s0,64(sp)
    80003c42:	74e2                	ld	s1,56(sp)
    80003c44:	7942                	ld	s2,48(sp)
    80003c46:	79a2                	ld	s3,40(sp)
    80003c48:	6161                	addi	sp,sp,80
    80003c4a:	8082                	ret
  return -1;
    80003c4c:	557d                	li	a0,-1
    80003c4e:	bfc5                	j	80003c3e <filestat+0x60>

0000000080003c50 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c50:	7179                	addi	sp,sp,-48
    80003c52:	f406                	sd	ra,40(sp)
    80003c54:	f022                	sd	s0,32(sp)
    80003c56:	ec26                	sd	s1,24(sp)
    80003c58:	e84a                	sd	s2,16(sp)
    80003c5a:	e44e                	sd	s3,8(sp)
    80003c5c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c5e:	00854783          	lbu	a5,8(a0)
    80003c62:	c3d5                	beqz	a5,80003d06 <fileread+0xb6>
    80003c64:	84aa                	mv	s1,a0
    80003c66:	89ae                	mv	s3,a1
    80003c68:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c6a:	411c                	lw	a5,0(a0)
    80003c6c:	4705                	li	a4,1
    80003c6e:	04e78963          	beq	a5,a4,80003cc0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c72:	470d                	li	a4,3
    80003c74:	04e78d63          	beq	a5,a4,80003cce <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c78:	4709                	li	a4,2
    80003c7a:	06e79e63          	bne	a5,a4,80003cf6 <fileread+0xa6>
    ilock(f->ip);
    80003c7e:	6d08                	ld	a0,24(a0)
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	002080e7          	jalr	2(ra) # 80002c82 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c88:	874a                	mv	a4,s2
    80003c8a:	5094                	lw	a3,32(s1)
    80003c8c:	864e                	mv	a2,s3
    80003c8e:	4585                	li	a1,1
    80003c90:	6c88                	ld	a0,24(s1)
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	2a4080e7          	jalr	676(ra) # 80002f36 <readi>
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	00a05563          	blez	a0,80003ca6 <fileread+0x56>
      f->off += r;
    80003ca0:	509c                	lw	a5,32(s1)
    80003ca2:	9fa9                	addw	a5,a5,a0
    80003ca4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ca6:	6c88                	ld	a0,24(s1)
    80003ca8:	fffff097          	auipc	ra,0xfffff
    80003cac:	09c080e7          	jalr	156(ra) # 80002d44 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003cb0:	854a                	mv	a0,s2
    80003cb2:	70a2                	ld	ra,40(sp)
    80003cb4:	7402                	ld	s0,32(sp)
    80003cb6:	64e2                	ld	s1,24(sp)
    80003cb8:	6942                	ld	s2,16(sp)
    80003cba:	69a2                	ld	s3,8(sp)
    80003cbc:	6145                	addi	sp,sp,48
    80003cbe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cc0:	6908                	ld	a0,16(a0)
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	3c6080e7          	jalr	966(ra) # 80004088 <piperead>
    80003cca:	892a                	mv	s2,a0
    80003ccc:	b7d5                	j	80003cb0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cce:	02451783          	lh	a5,36(a0)
    80003cd2:	03079693          	slli	a3,a5,0x30
    80003cd6:	92c1                	srli	a3,a3,0x30
    80003cd8:	4725                	li	a4,9
    80003cda:	02d76863          	bltu	a4,a3,80003d0a <fileread+0xba>
    80003cde:	0792                	slli	a5,a5,0x4
    80003ce0:	00015717          	auipc	a4,0x15
    80003ce4:	0e870713          	addi	a4,a4,232 # 80018dc8 <devsw>
    80003ce8:	97ba                	add	a5,a5,a4
    80003cea:	639c                	ld	a5,0(a5)
    80003cec:	c38d                	beqz	a5,80003d0e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003cee:	4505                	li	a0,1
    80003cf0:	9782                	jalr	a5
    80003cf2:	892a                	mv	s2,a0
    80003cf4:	bf75                	j	80003cb0 <fileread+0x60>
    panic("fileread");
    80003cf6:	00005517          	auipc	a0,0x5
    80003cfa:	b8250513          	addi	a0,a0,-1150 # 80008878 <syscalls_name+0x268>
    80003cfe:	00002097          	auipc	ra,0x2
    80003d02:	03e080e7          	jalr	62(ra) # 80005d3c <panic>
    return -1;
    80003d06:	597d                	li	s2,-1
    80003d08:	b765                	j	80003cb0 <fileread+0x60>
      return -1;
    80003d0a:	597d                	li	s2,-1
    80003d0c:	b755                	j	80003cb0 <fileread+0x60>
    80003d0e:	597d                	li	s2,-1
    80003d10:	b745                	j	80003cb0 <fileread+0x60>

0000000080003d12 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d12:	715d                	addi	sp,sp,-80
    80003d14:	e486                	sd	ra,72(sp)
    80003d16:	e0a2                	sd	s0,64(sp)
    80003d18:	fc26                	sd	s1,56(sp)
    80003d1a:	f84a                	sd	s2,48(sp)
    80003d1c:	f44e                	sd	s3,40(sp)
    80003d1e:	f052                	sd	s4,32(sp)
    80003d20:	ec56                	sd	s5,24(sp)
    80003d22:	e85a                	sd	s6,16(sp)
    80003d24:	e45e                	sd	s7,8(sp)
    80003d26:	e062                	sd	s8,0(sp)
    80003d28:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d2a:	00954783          	lbu	a5,9(a0)
    80003d2e:	10078663          	beqz	a5,80003e3a <filewrite+0x128>
    80003d32:	892a                	mv	s2,a0
    80003d34:	8b2e                	mv	s6,a1
    80003d36:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d38:	411c                	lw	a5,0(a0)
    80003d3a:	4705                	li	a4,1
    80003d3c:	02e78263          	beq	a5,a4,80003d60 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d40:	470d                	li	a4,3
    80003d42:	02e78663          	beq	a5,a4,80003d6e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d46:	4709                	li	a4,2
    80003d48:	0ee79163          	bne	a5,a4,80003e2a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d4c:	0ac05d63          	blez	a2,80003e06 <filewrite+0xf4>
    int i = 0;
    80003d50:	4981                	li	s3,0
    80003d52:	6b85                	lui	s7,0x1
    80003d54:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d58:	6c05                	lui	s8,0x1
    80003d5a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003d5e:	a861                	j	80003df6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d60:	6908                	ld	a0,16(a0)
    80003d62:	00000097          	auipc	ra,0x0
    80003d66:	22e080e7          	jalr	558(ra) # 80003f90 <pipewrite>
    80003d6a:	8a2a                	mv	s4,a0
    80003d6c:	a045                	j	80003e0c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d6e:	02451783          	lh	a5,36(a0)
    80003d72:	03079693          	slli	a3,a5,0x30
    80003d76:	92c1                	srli	a3,a3,0x30
    80003d78:	4725                	li	a4,9
    80003d7a:	0cd76263          	bltu	a4,a3,80003e3e <filewrite+0x12c>
    80003d7e:	0792                	slli	a5,a5,0x4
    80003d80:	00015717          	auipc	a4,0x15
    80003d84:	04870713          	addi	a4,a4,72 # 80018dc8 <devsw>
    80003d88:	97ba                	add	a5,a5,a4
    80003d8a:	679c                	ld	a5,8(a5)
    80003d8c:	cbdd                	beqz	a5,80003e42 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d8e:	4505                	li	a0,1
    80003d90:	9782                	jalr	a5
    80003d92:	8a2a                	mv	s4,a0
    80003d94:	a8a5                	j	80003e0c <filewrite+0xfa>
    80003d96:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	8b4080e7          	jalr	-1868(ra) # 8000364e <begin_op>
      ilock(f->ip);
    80003da2:	01893503          	ld	a0,24(s2)
    80003da6:	fffff097          	auipc	ra,0xfffff
    80003daa:	edc080e7          	jalr	-292(ra) # 80002c82 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003dae:	8756                	mv	a4,s5
    80003db0:	02092683          	lw	a3,32(s2)
    80003db4:	01698633          	add	a2,s3,s6
    80003db8:	4585                	li	a1,1
    80003dba:	01893503          	ld	a0,24(s2)
    80003dbe:	fffff097          	auipc	ra,0xfffff
    80003dc2:	270080e7          	jalr	624(ra) # 8000302e <writei>
    80003dc6:	84aa                	mv	s1,a0
    80003dc8:	00a05763          	blez	a0,80003dd6 <filewrite+0xc4>
        f->off += r;
    80003dcc:	02092783          	lw	a5,32(s2)
    80003dd0:	9fa9                	addw	a5,a5,a0
    80003dd2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dd6:	01893503          	ld	a0,24(s2)
    80003dda:	fffff097          	auipc	ra,0xfffff
    80003dde:	f6a080e7          	jalr	-150(ra) # 80002d44 <iunlock>
      end_op();
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	8ea080e7          	jalr	-1814(ra) # 800036cc <end_op>

      if(r != n1){
    80003dea:	009a9f63          	bne	s5,s1,80003e08 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dee:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003df2:	0149db63          	bge	s3,s4,80003e08 <filewrite+0xf6>
      int n1 = n - i;
    80003df6:	413a04bb          	subw	s1,s4,s3
    80003dfa:	0004879b          	sext.w	a5,s1
    80003dfe:	f8fbdce3          	bge	s7,a5,80003d96 <filewrite+0x84>
    80003e02:	84e2                	mv	s1,s8
    80003e04:	bf49                	j	80003d96 <filewrite+0x84>
    int i = 0;
    80003e06:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003e08:	013a1f63          	bne	s4,s3,80003e26 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e0c:	8552                	mv	a0,s4
    80003e0e:	60a6                	ld	ra,72(sp)
    80003e10:	6406                	ld	s0,64(sp)
    80003e12:	74e2                	ld	s1,56(sp)
    80003e14:	7942                	ld	s2,48(sp)
    80003e16:	79a2                	ld	s3,40(sp)
    80003e18:	7a02                	ld	s4,32(sp)
    80003e1a:	6ae2                	ld	s5,24(sp)
    80003e1c:	6b42                	ld	s6,16(sp)
    80003e1e:	6ba2                	ld	s7,8(sp)
    80003e20:	6c02                	ld	s8,0(sp)
    80003e22:	6161                	addi	sp,sp,80
    80003e24:	8082                	ret
    ret = (i == n ? n : -1);
    80003e26:	5a7d                	li	s4,-1
    80003e28:	b7d5                	j	80003e0c <filewrite+0xfa>
    panic("filewrite");
    80003e2a:	00005517          	auipc	a0,0x5
    80003e2e:	a5e50513          	addi	a0,a0,-1442 # 80008888 <syscalls_name+0x278>
    80003e32:	00002097          	auipc	ra,0x2
    80003e36:	f0a080e7          	jalr	-246(ra) # 80005d3c <panic>
    return -1;
    80003e3a:	5a7d                	li	s4,-1
    80003e3c:	bfc1                	j	80003e0c <filewrite+0xfa>
      return -1;
    80003e3e:	5a7d                	li	s4,-1
    80003e40:	b7f1                	j	80003e0c <filewrite+0xfa>
    80003e42:	5a7d                	li	s4,-1
    80003e44:	b7e1                	j	80003e0c <filewrite+0xfa>

0000000080003e46 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e46:	7179                	addi	sp,sp,-48
    80003e48:	f406                	sd	ra,40(sp)
    80003e4a:	f022                	sd	s0,32(sp)
    80003e4c:	ec26                	sd	s1,24(sp)
    80003e4e:	e84a                	sd	s2,16(sp)
    80003e50:	e44e                	sd	s3,8(sp)
    80003e52:	e052                	sd	s4,0(sp)
    80003e54:	1800                	addi	s0,sp,48
    80003e56:	84aa                	mv	s1,a0
    80003e58:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e5a:	0005b023          	sd	zero,0(a1)
    80003e5e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	bf8080e7          	jalr	-1032(ra) # 80003a5a <filealloc>
    80003e6a:	e088                	sd	a0,0(s1)
    80003e6c:	c551                	beqz	a0,80003ef8 <pipealloc+0xb2>
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	bec080e7          	jalr	-1044(ra) # 80003a5a <filealloc>
    80003e76:	00aa3023          	sd	a0,0(s4)
    80003e7a:	c92d                	beqz	a0,80003eec <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e7c:	ffffc097          	auipc	ra,0xffffc
    80003e80:	29e080e7          	jalr	670(ra) # 8000011a <kalloc>
    80003e84:	892a                	mv	s2,a0
    80003e86:	c125                	beqz	a0,80003ee6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e88:	4985                	li	s3,1
    80003e8a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e8e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e92:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e96:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e9a:	00004597          	auipc	a1,0x4
    80003e9e:	56658593          	addi	a1,a1,1382 # 80008400 <states.0+0x1b8>
    80003ea2:	00002097          	auipc	ra,0x2
    80003ea6:	342080e7          	jalr	834(ra) # 800061e4 <initlock>
  (*f0)->type = FD_PIPE;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eb6:	609c                	ld	a5,0(s1)
    80003eb8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ebc:	609c                	ld	a5,0(s1)
    80003ebe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ec2:	000a3783          	ld	a5,0(s4)
    80003ec6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eca:	000a3783          	ld	a5,0(s4)
    80003ece:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ed2:	000a3783          	ld	a5,0(s4)
    80003ed6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eda:	000a3783          	ld	a5,0(s4)
    80003ede:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ee2:	4501                	li	a0,0
    80003ee4:	a025                	j	80003f0c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ee6:	6088                	ld	a0,0(s1)
    80003ee8:	e501                	bnez	a0,80003ef0 <pipealloc+0xaa>
    80003eea:	a039                	j	80003ef8 <pipealloc+0xb2>
    80003eec:	6088                	ld	a0,0(s1)
    80003eee:	c51d                	beqz	a0,80003f1c <pipealloc+0xd6>
    fileclose(*f0);
    80003ef0:	00000097          	auipc	ra,0x0
    80003ef4:	c26080e7          	jalr	-986(ra) # 80003b16 <fileclose>
  if(*f1)
    80003ef8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003efc:	557d                	li	a0,-1
  if(*f1)
    80003efe:	c799                	beqz	a5,80003f0c <pipealloc+0xc6>
    fileclose(*f1);
    80003f00:	853e                	mv	a0,a5
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	c14080e7          	jalr	-1004(ra) # 80003b16 <fileclose>
  return -1;
    80003f0a:	557d                	li	a0,-1
}
    80003f0c:	70a2                	ld	ra,40(sp)
    80003f0e:	7402                	ld	s0,32(sp)
    80003f10:	64e2                	ld	s1,24(sp)
    80003f12:	6942                	ld	s2,16(sp)
    80003f14:	69a2                	ld	s3,8(sp)
    80003f16:	6a02                	ld	s4,0(sp)
    80003f18:	6145                	addi	sp,sp,48
    80003f1a:	8082                	ret
  return -1;
    80003f1c:	557d                	li	a0,-1
    80003f1e:	b7fd                	j	80003f0c <pipealloc+0xc6>

0000000080003f20 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f20:	1101                	addi	sp,sp,-32
    80003f22:	ec06                	sd	ra,24(sp)
    80003f24:	e822                	sd	s0,16(sp)
    80003f26:	e426                	sd	s1,8(sp)
    80003f28:	e04a                	sd	s2,0(sp)
    80003f2a:	1000                	addi	s0,sp,32
    80003f2c:	84aa                	mv	s1,a0
    80003f2e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f30:	00002097          	auipc	ra,0x2
    80003f34:	344080e7          	jalr	836(ra) # 80006274 <acquire>
  if(writable){
    80003f38:	02090d63          	beqz	s2,80003f72 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f3c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f40:	21848513          	addi	a0,s1,536
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	6a0080e7          	jalr	1696(ra) # 800015e4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f4c:	2204b783          	ld	a5,544(s1)
    80003f50:	eb95                	bnez	a5,80003f84 <pipeclose+0x64>
    release(&pi->lock);
    80003f52:	8526                	mv	a0,s1
    80003f54:	00002097          	auipc	ra,0x2
    80003f58:	3d4080e7          	jalr	980(ra) # 80006328 <release>
    kfree((char*)pi);
    80003f5c:	8526                	mv	a0,s1
    80003f5e:	ffffc097          	auipc	ra,0xffffc
    80003f62:	0be080e7          	jalr	190(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f66:	60e2                	ld	ra,24(sp)
    80003f68:	6442                	ld	s0,16(sp)
    80003f6a:	64a2                	ld	s1,8(sp)
    80003f6c:	6902                	ld	s2,0(sp)
    80003f6e:	6105                	addi	sp,sp,32
    80003f70:	8082                	ret
    pi->readopen = 0;
    80003f72:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f76:	21c48513          	addi	a0,s1,540
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	66a080e7          	jalr	1642(ra) # 800015e4 <wakeup>
    80003f82:	b7e9                	j	80003f4c <pipeclose+0x2c>
    release(&pi->lock);
    80003f84:	8526                	mv	a0,s1
    80003f86:	00002097          	auipc	ra,0x2
    80003f8a:	3a2080e7          	jalr	930(ra) # 80006328 <release>
}
    80003f8e:	bfe1                	j	80003f66 <pipeclose+0x46>

0000000080003f90 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f90:	711d                	addi	sp,sp,-96
    80003f92:	ec86                	sd	ra,88(sp)
    80003f94:	e8a2                	sd	s0,80(sp)
    80003f96:	e4a6                	sd	s1,72(sp)
    80003f98:	e0ca                	sd	s2,64(sp)
    80003f9a:	fc4e                	sd	s3,56(sp)
    80003f9c:	f852                	sd	s4,48(sp)
    80003f9e:	f456                	sd	s5,40(sp)
    80003fa0:	f05a                	sd	s6,32(sp)
    80003fa2:	ec5e                	sd	s7,24(sp)
    80003fa4:	e862                	sd	s8,16(sp)
    80003fa6:	1080                	addi	s0,sp,96
    80003fa8:	84aa                	mv	s1,a0
    80003faa:	8aae                	mv	s5,a1
    80003fac:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fae:	ffffd097          	auipc	ra,0xffffd
    80003fb2:	ef4080e7          	jalr	-268(ra) # 80000ea2 <myproc>
    80003fb6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	00002097          	auipc	ra,0x2
    80003fbe:	2ba080e7          	jalr	698(ra) # 80006274 <acquire>
  while(i < n){
    80003fc2:	0b405663          	blez	s4,8000406e <pipewrite+0xde>
  int i = 0;
    80003fc6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fca:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fce:	21c48b93          	addi	s7,s1,540
    80003fd2:	a089                	j	80004014 <pipewrite+0x84>
      release(&pi->lock);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	352080e7          	jalr	850(ra) # 80006328 <release>
      return -1;
    80003fde:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fe0:	854a                	mv	a0,s2
    80003fe2:	60e6                	ld	ra,88(sp)
    80003fe4:	6446                	ld	s0,80(sp)
    80003fe6:	64a6                	ld	s1,72(sp)
    80003fe8:	6906                	ld	s2,64(sp)
    80003fea:	79e2                	ld	s3,56(sp)
    80003fec:	7a42                	ld	s4,48(sp)
    80003fee:	7aa2                	ld	s5,40(sp)
    80003ff0:	7b02                	ld	s6,32(sp)
    80003ff2:	6be2                	ld	s7,24(sp)
    80003ff4:	6c42                	ld	s8,16(sp)
    80003ff6:	6125                	addi	sp,sp,96
    80003ff8:	8082                	ret
      wakeup(&pi->nread);
    80003ffa:	8562                	mv	a0,s8
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	5e8080e7          	jalr	1512(ra) # 800015e4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004004:	85a6                	mv	a1,s1
    80004006:	855e                	mv	a0,s7
    80004008:	ffffd097          	auipc	ra,0xffffd
    8000400c:	56e080e7          	jalr	1390(ra) # 80001576 <sleep>
  while(i < n){
    80004010:	07495063          	bge	s2,s4,80004070 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80004014:	2204a783          	lw	a5,544(s1)
    80004018:	dfd5                	beqz	a5,80003fd4 <pipewrite+0x44>
    8000401a:	854e                	mv	a0,s3
    8000401c:	ffffe097          	auipc	ra,0xffffe
    80004020:	828080e7          	jalr	-2008(ra) # 80001844 <killed>
    80004024:	f945                	bnez	a0,80003fd4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004026:	2184a783          	lw	a5,536(s1)
    8000402a:	21c4a703          	lw	a4,540(s1)
    8000402e:	2007879b          	addiw	a5,a5,512
    80004032:	fcf704e3          	beq	a4,a5,80003ffa <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004036:	4685                	li	a3,1
    80004038:	01590633          	add	a2,s2,s5
    8000403c:	faf40593          	addi	a1,s0,-81
    80004040:	0589b503          	ld	a0,88(s3)
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	ba8080e7          	jalr	-1112(ra) # 80000bec <copyin>
    8000404c:	03650263          	beq	a0,s6,80004070 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004050:	21c4a783          	lw	a5,540(s1)
    80004054:	0017871b          	addiw	a4,a5,1
    80004058:	20e4ae23          	sw	a4,540(s1)
    8000405c:	1ff7f793          	andi	a5,a5,511
    80004060:	97a6                	add	a5,a5,s1
    80004062:	faf44703          	lbu	a4,-81(s0)
    80004066:	00e78c23          	sb	a4,24(a5)
      i++;
    8000406a:	2905                	addiw	s2,s2,1
    8000406c:	b755                	j	80004010 <pipewrite+0x80>
  int i = 0;
    8000406e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004070:	21848513          	addi	a0,s1,536
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	570080e7          	jalr	1392(ra) # 800015e4 <wakeup>
  release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	2aa080e7          	jalr	682(ra) # 80006328 <release>
  return i;
    80004086:	bfa9                	j	80003fe0 <pipewrite+0x50>

0000000080004088 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004088:	715d                	addi	sp,sp,-80
    8000408a:	e486                	sd	ra,72(sp)
    8000408c:	e0a2                	sd	s0,64(sp)
    8000408e:	fc26                	sd	s1,56(sp)
    80004090:	f84a                	sd	s2,48(sp)
    80004092:	f44e                	sd	s3,40(sp)
    80004094:	f052                	sd	s4,32(sp)
    80004096:	ec56                	sd	s5,24(sp)
    80004098:	e85a                	sd	s6,16(sp)
    8000409a:	0880                	addi	s0,sp,80
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
    800040a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040a2:	ffffd097          	auipc	ra,0xffffd
    800040a6:	e00080e7          	jalr	-512(ra) # 80000ea2 <myproc>
    800040aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040ac:	8526                	mv	a0,s1
    800040ae:	00002097          	auipc	ra,0x2
    800040b2:	1c6080e7          	jalr	454(ra) # 80006274 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b6:	2184a703          	lw	a4,536(s1)
    800040ba:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040be:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c2:	02f71763          	bne	a4,a5,800040f0 <piperead+0x68>
    800040c6:	2244a783          	lw	a5,548(s1)
    800040ca:	c39d                	beqz	a5,800040f0 <piperead+0x68>
    if(killed(pr)){
    800040cc:	8552                	mv	a0,s4
    800040ce:	ffffd097          	auipc	ra,0xffffd
    800040d2:	776080e7          	jalr	1910(ra) # 80001844 <killed>
    800040d6:	e949                	bnez	a0,80004168 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d8:	85a6                	mv	a1,s1
    800040da:	854e                	mv	a0,s3
    800040dc:	ffffd097          	auipc	ra,0xffffd
    800040e0:	49a080e7          	jalr	1178(ra) # 80001576 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e4:	2184a703          	lw	a4,536(s1)
    800040e8:	21c4a783          	lw	a5,540(s1)
    800040ec:	fcf70de3          	beq	a4,a5,800040c6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f2:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f4:	05505463          	blez	s5,8000413c <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    800040f8:	2184a783          	lw	a5,536(s1)
    800040fc:	21c4a703          	lw	a4,540(s1)
    80004100:	02f70e63          	beq	a4,a5,8000413c <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004104:	0017871b          	addiw	a4,a5,1
    80004108:	20e4ac23          	sw	a4,536(s1)
    8000410c:	1ff7f793          	andi	a5,a5,511
    80004110:	97a6                	add	a5,a5,s1
    80004112:	0187c783          	lbu	a5,24(a5)
    80004116:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000411a:	4685                	li	a3,1
    8000411c:	fbf40613          	addi	a2,s0,-65
    80004120:	85ca                	mv	a1,s2
    80004122:	058a3503          	ld	a0,88(s4)
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	a3a080e7          	jalr	-1478(ra) # 80000b60 <copyout>
    8000412e:	01650763          	beq	a0,s6,8000413c <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004132:	2985                	addiw	s3,s3,1
    80004134:	0905                	addi	s2,s2,1
    80004136:	fd3a91e3          	bne	s5,s3,800040f8 <piperead+0x70>
    8000413a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000413c:	21c48513          	addi	a0,s1,540
    80004140:	ffffd097          	auipc	ra,0xffffd
    80004144:	4a4080e7          	jalr	1188(ra) # 800015e4 <wakeup>
  release(&pi->lock);
    80004148:	8526                	mv	a0,s1
    8000414a:	00002097          	auipc	ra,0x2
    8000414e:	1de080e7          	jalr	478(ra) # 80006328 <release>
  return i;
}
    80004152:	854e                	mv	a0,s3
    80004154:	60a6                	ld	ra,72(sp)
    80004156:	6406                	ld	s0,64(sp)
    80004158:	74e2                	ld	s1,56(sp)
    8000415a:	7942                	ld	s2,48(sp)
    8000415c:	79a2                	ld	s3,40(sp)
    8000415e:	7a02                	ld	s4,32(sp)
    80004160:	6ae2                	ld	s5,24(sp)
    80004162:	6b42                	ld	s6,16(sp)
    80004164:	6161                	addi	sp,sp,80
    80004166:	8082                	ret
      release(&pi->lock);
    80004168:	8526                	mv	a0,s1
    8000416a:	00002097          	auipc	ra,0x2
    8000416e:	1be080e7          	jalr	446(ra) # 80006328 <release>
      return -1;
    80004172:	59fd                	li	s3,-1
    80004174:	bff9                	j	80004152 <piperead+0xca>

0000000080004176 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004176:	1141                	addi	sp,sp,-16
    80004178:	e422                	sd	s0,8(sp)
    8000417a:	0800                	addi	s0,sp,16
    8000417c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000417e:	8905                	andi	a0,a0,1
    80004180:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004182:	8b89                	andi	a5,a5,2
    80004184:	c399                	beqz	a5,8000418a <flags2perm+0x14>
      perm |= PTE_W;
    80004186:	00456513          	ori	a0,a0,4
    return perm;
}
    8000418a:	6422                	ld	s0,8(sp)
    8000418c:	0141                	addi	sp,sp,16
    8000418e:	8082                	ret

0000000080004190 <exec>:

int
exec(char *path, char **argv)
{
    80004190:	de010113          	addi	sp,sp,-544
    80004194:	20113c23          	sd	ra,536(sp)
    80004198:	20813823          	sd	s0,528(sp)
    8000419c:	20913423          	sd	s1,520(sp)
    800041a0:	21213023          	sd	s2,512(sp)
    800041a4:	ffce                	sd	s3,504(sp)
    800041a6:	fbd2                	sd	s4,496(sp)
    800041a8:	f7d6                	sd	s5,488(sp)
    800041aa:	f3da                	sd	s6,480(sp)
    800041ac:	efde                	sd	s7,472(sp)
    800041ae:	ebe2                	sd	s8,464(sp)
    800041b0:	e7e6                	sd	s9,456(sp)
    800041b2:	e3ea                	sd	s10,448(sp)
    800041b4:	ff6e                	sd	s11,440(sp)
    800041b6:	1400                	addi	s0,sp,544
    800041b8:	892a                	mv	s2,a0
    800041ba:	dea43423          	sd	a0,-536(s0)
    800041be:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c2:	ffffd097          	auipc	ra,0xffffd
    800041c6:	ce0080e7          	jalr	-800(ra) # 80000ea2 <myproc>
    800041ca:	84aa                	mv	s1,a0

  begin_op();
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	482080e7          	jalr	1154(ra) # 8000364e <begin_op>

  if((ip = namei(path)) == 0){
    800041d4:	854a                	mv	a0,s2
    800041d6:	fffff097          	auipc	ra,0xfffff
    800041da:	258080e7          	jalr	600(ra) # 8000342e <namei>
    800041de:	c93d                	beqz	a0,80004254 <exec+0xc4>
    800041e0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041e2:	fffff097          	auipc	ra,0xfffff
    800041e6:	aa0080e7          	jalr	-1376(ra) # 80002c82 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041ea:	04000713          	li	a4,64
    800041ee:	4681                	li	a3,0
    800041f0:	e5040613          	addi	a2,s0,-432
    800041f4:	4581                	li	a1,0
    800041f6:	8556                	mv	a0,s5
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	d3e080e7          	jalr	-706(ra) # 80002f36 <readi>
    80004200:	04000793          	li	a5,64
    80004204:	00f51a63          	bne	a0,a5,80004218 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004208:	e5042703          	lw	a4,-432(s0)
    8000420c:	464c47b7          	lui	a5,0x464c4
    80004210:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004214:	04f70663          	beq	a4,a5,80004260 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004218:	8556                	mv	a0,s5
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	cca080e7          	jalr	-822(ra) # 80002ee4 <iunlockput>
    end_op();
    80004222:	fffff097          	auipc	ra,0xfffff
    80004226:	4aa080e7          	jalr	1194(ra) # 800036cc <end_op>
  }
  return -1;
    8000422a:	557d                	li	a0,-1
}
    8000422c:	21813083          	ld	ra,536(sp)
    80004230:	21013403          	ld	s0,528(sp)
    80004234:	20813483          	ld	s1,520(sp)
    80004238:	20013903          	ld	s2,512(sp)
    8000423c:	79fe                	ld	s3,504(sp)
    8000423e:	7a5e                	ld	s4,496(sp)
    80004240:	7abe                	ld	s5,488(sp)
    80004242:	7b1e                	ld	s6,480(sp)
    80004244:	6bfe                	ld	s7,472(sp)
    80004246:	6c5e                	ld	s8,464(sp)
    80004248:	6cbe                	ld	s9,456(sp)
    8000424a:	6d1e                	ld	s10,448(sp)
    8000424c:	7dfa                	ld	s11,440(sp)
    8000424e:	22010113          	addi	sp,sp,544
    80004252:	8082                	ret
    end_op();
    80004254:	fffff097          	auipc	ra,0xfffff
    80004258:	478080e7          	jalr	1144(ra) # 800036cc <end_op>
    return -1;
    8000425c:	557d                	li	a0,-1
    8000425e:	b7f9                	j	8000422c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004260:	8526                	mv	a0,s1
    80004262:	ffffd097          	auipc	ra,0xffffd
    80004266:	d06080e7          	jalr	-762(ra) # 80000f68 <proc_pagetable>
    8000426a:	8b2a                	mv	s6,a0
    8000426c:	d555                	beqz	a0,80004218 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426e:	e7042783          	lw	a5,-400(s0)
    80004272:	e8845703          	lhu	a4,-376(s0)
    80004276:	c735                	beqz	a4,800042e2 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004278:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427a:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000427e:	6a05                	lui	s4,0x1
    80004280:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004284:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004288:	6d85                	lui	s11,0x1
    8000428a:	7d7d                	lui	s10,0xfffff
    8000428c:	ac3d                	j	800044ca <exec+0x33a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000428e:	00004517          	auipc	a0,0x4
    80004292:	60a50513          	addi	a0,a0,1546 # 80008898 <syscalls_name+0x288>
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	aa6080e7          	jalr	-1370(ra) # 80005d3c <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000429e:	874a                	mv	a4,s2
    800042a0:	009c86bb          	addw	a3,s9,s1
    800042a4:	4581                	li	a1,0
    800042a6:	8556                	mv	a0,s5
    800042a8:	fffff097          	auipc	ra,0xfffff
    800042ac:	c8e080e7          	jalr	-882(ra) # 80002f36 <readi>
    800042b0:	2501                	sext.w	a0,a0
    800042b2:	1aa91963          	bne	s2,a0,80004464 <exec+0x2d4>
  for(i = 0; i < sz; i += PGSIZE){
    800042b6:	009d84bb          	addw	s1,s11,s1
    800042ba:	013d09bb          	addw	s3,s10,s3
    800042be:	1f74f663          	bgeu	s1,s7,800044aa <exec+0x31a>
    pa = walkaddr(pagetable, va + i);
    800042c2:	02049593          	slli	a1,s1,0x20
    800042c6:	9181                	srli	a1,a1,0x20
    800042c8:	95e2                	add	a1,a1,s8
    800042ca:	855a                	mv	a0,s6
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	284080e7          	jalr	644(ra) # 80000550 <walkaddr>
    800042d4:	862a                	mv	a2,a0
    if(pa == 0)
    800042d6:	dd45                	beqz	a0,8000428e <exec+0xfe>
      n = PGSIZE;
    800042d8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800042da:	fd49f2e3          	bgeu	s3,s4,8000429e <exec+0x10e>
      n = sz - i;
    800042de:	894e                	mv	s2,s3
    800042e0:	bf7d                	j	8000429e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e2:	4901                	li	s2,0
  iunlockput(ip);
    800042e4:	8556                	mv	a0,s5
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	bfe080e7          	jalr	-1026(ra) # 80002ee4 <iunlockput>
  end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	3de080e7          	jalr	990(ra) # 800036cc <end_op>
  p = myproc();
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	bac080e7          	jalr	-1108(ra) # 80000ea2 <myproc>
    800042fe:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004300:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80004304:	6785                	lui	a5,0x1
    80004306:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004308:	97ca                	add	a5,a5,s2
    8000430a:	777d                	lui	a4,0xfffff
    8000430c:	8ff9                	and	a5,a5,a4
    8000430e:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004312:	4691                	li	a3,4
    80004314:	6609                	lui	a2,0x2
    80004316:	963e                	add	a2,a2,a5
    80004318:	85be                	mv	a1,a5
    8000431a:	855a                	mv	a0,s6
    8000431c:	ffffc097          	auipc	ra,0xffffc
    80004320:	5e8080e7          	jalr	1512(ra) # 80000904 <uvmalloc>
    80004324:	8c2a                	mv	s8,a0
  ip = 0;
    80004326:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004328:	12050e63          	beqz	a0,80004464 <exec+0x2d4>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000432c:	75f9                	lui	a1,0xffffe
    8000432e:	95aa                	add	a1,a1,a0
    80004330:	855a                	mv	a0,s6
    80004332:	ffffc097          	auipc	ra,0xffffc
    80004336:	7fc080e7          	jalr	2044(ra) # 80000b2e <uvmclear>
  stackbase = sp - PGSIZE;
    8000433a:	7afd                	lui	s5,0xfffff
    8000433c:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000433e:	df043783          	ld	a5,-528(s0)
    80004342:	6388                	ld	a0,0(a5)
    80004344:	c925                	beqz	a0,800043b4 <exec+0x224>
    80004346:	e9040993          	addi	s3,s0,-368
    8000434a:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000434e:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004350:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	ff0080e7          	jalr	-16(ra) # 80000342 <strlen>
    8000435a:	0015079b          	addiw	a5,a0,1
    8000435e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004362:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004366:	13596663          	bltu	s2,s5,80004492 <exec+0x302>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000436a:	df043d83          	ld	s11,-528(s0)
    8000436e:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004372:	8552                	mv	a0,s4
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	fce080e7          	jalr	-50(ra) # 80000342 <strlen>
    8000437c:	0015069b          	addiw	a3,a0,1
    80004380:	8652                	mv	a2,s4
    80004382:	85ca                	mv	a1,s2
    80004384:	855a                	mv	a0,s6
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	7da080e7          	jalr	2010(ra) # 80000b60 <copyout>
    8000438e:	10054663          	bltz	a0,8000449a <exec+0x30a>
    ustack[argc] = sp;
    80004392:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004396:	0485                	addi	s1,s1,1
    80004398:	008d8793          	addi	a5,s11,8
    8000439c:	def43823          	sd	a5,-528(s0)
    800043a0:	008db503          	ld	a0,8(s11)
    800043a4:	c911                	beqz	a0,800043b8 <exec+0x228>
    if(argc >= MAXARG)
    800043a6:	09a1                	addi	s3,s3,8
    800043a8:	fb3c95e3          	bne	s9,s3,80004352 <exec+0x1c2>
  sz = sz1;
    800043ac:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043b0:	4a81                	li	s5,0
    800043b2:	a84d                	j	80004464 <exec+0x2d4>
  sp = sz;
    800043b4:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800043b6:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b8:	00349793          	slli	a5,s1,0x3
    800043bc:	f9078793          	addi	a5,a5,-112
    800043c0:	97a2                	add	a5,a5,s0
    800043c2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043c6:	00148693          	addi	a3,s1,1
    800043ca:	068e                	slli	a3,a3,0x3
    800043cc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043d0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043d4:	01597663          	bgeu	s2,s5,800043e0 <exec+0x250>
  sz = sz1;
    800043d8:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800043dc:	4a81                	li	s5,0
    800043de:	a059                	j	80004464 <exec+0x2d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043e0:	e9040613          	addi	a2,s0,-368
    800043e4:	85ca                	mv	a1,s2
    800043e6:	855a                	mv	a0,s6
    800043e8:	ffffc097          	auipc	ra,0xffffc
    800043ec:	778080e7          	jalr	1912(ra) # 80000b60 <copyout>
    800043f0:	0a054963          	bltz	a0,800044a2 <exec+0x312>
  p->trapframe->a1 = sp;
    800043f4:	060bb783          	ld	a5,96(s7)
    800043f8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043fc:	de843783          	ld	a5,-536(s0)
    80004400:	0007c703          	lbu	a4,0(a5)
    80004404:	cf11                	beqz	a4,80004420 <exec+0x290>
    80004406:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004408:	02f00693          	li	a3,47
    8000440c:	a039                	j	8000441a <exec+0x28a>
      last = s+1;
    8000440e:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004412:	0785                	addi	a5,a5,1
    80004414:	fff7c703          	lbu	a4,-1(a5)
    80004418:	c701                	beqz	a4,80004420 <exec+0x290>
    if(*s == '/')
    8000441a:	fed71ce3          	bne	a4,a3,80004412 <exec+0x282>
    8000441e:	bfc5                	j	8000440e <exec+0x27e>
  safestrcpy(p->name, last, sizeof(p->name));
    80004420:	4641                	li	a2,16
    80004422:	de843583          	ld	a1,-536(s0)
    80004426:	160b8513          	addi	a0,s7,352
    8000442a:	ffffc097          	auipc	ra,0xffffc
    8000442e:	ee6080e7          	jalr	-282(ra) # 80000310 <safestrcpy>
  oldpagetable = p->pagetable;
    80004432:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    80004436:	056bbc23          	sd	s6,88(s7)
  p->sz = sz;
    8000443a:	058bb823          	sd	s8,80(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000443e:	060bb783          	ld	a5,96(s7)
    80004442:	e6843703          	ld	a4,-408(s0)
    80004446:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004448:	060bb783          	ld	a5,96(s7)
    8000444c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004450:	85ea                	mv	a1,s10
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	bb2080e7          	jalr	-1102(ra) # 80001004 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000445a:	0004851b          	sext.w	a0,s1
    8000445e:	b3f9                	j	8000422c <exec+0x9c>
    80004460:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004464:	df843583          	ld	a1,-520(s0)
    80004468:	855a                	mv	a0,s6
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	b9a080e7          	jalr	-1126(ra) # 80001004 <proc_freepagetable>
  if(ip){
    80004472:	da0a93e3          	bnez	s5,80004218 <exec+0x88>
  return -1;
    80004476:	557d                	li	a0,-1
    80004478:	bb55                	j	8000422c <exec+0x9c>
    8000447a:	df243c23          	sd	s2,-520(s0)
    8000447e:	b7dd                	j	80004464 <exec+0x2d4>
    80004480:	df243c23          	sd	s2,-520(s0)
    80004484:	b7c5                	j	80004464 <exec+0x2d4>
    80004486:	df243c23          	sd	s2,-520(s0)
    8000448a:	bfe9                	j	80004464 <exec+0x2d4>
    8000448c:	df243c23          	sd	s2,-520(s0)
    80004490:	bfd1                	j	80004464 <exec+0x2d4>
  sz = sz1;
    80004492:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004496:	4a81                	li	s5,0
    80004498:	b7f1                	j	80004464 <exec+0x2d4>
  sz = sz1;
    8000449a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000449e:	4a81                	li	s5,0
    800044a0:	b7d1                	j	80004464 <exec+0x2d4>
  sz = sz1;
    800044a2:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800044a6:	4a81                	li	s5,0
    800044a8:	bf75                	j	80004464 <exec+0x2d4>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044aa:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ae:	e0843783          	ld	a5,-504(s0)
    800044b2:	0017869b          	addiw	a3,a5,1
    800044b6:	e0d43423          	sd	a3,-504(s0)
    800044ba:	e0043783          	ld	a5,-512(s0)
    800044be:	0387879b          	addiw	a5,a5,56
    800044c2:	e8845703          	lhu	a4,-376(s0)
    800044c6:	e0e6dfe3          	bge	a3,a4,800042e4 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044ca:	2781                	sext.w	a5,a5
    800044cc:	e0f43023          	sd	a5,-512(s0)
    800044d0:	03800713          	li	a4,56
    800044d4:	86be                	mv	a3,a5
    800044d6:	e1840613          	addi	a2,s0,-488
    800044da:	4581                	li	a1,0
    800044dc:	8556                	mv	a0,s5
    800044de:	fffff097          	auipc	ra,0xfffff
    800044e2:	a58080e7          	jalr	-1448(ra) # 80002f36 <readi>
    800044e6:	03800793          	li	a5,56
    800044ea:	f6f51be3          	bne	a0,a5,80004460 <exec+0x2d0>
    if(ph.type != ELF_PROG_LOAD)
    800044ee:	e1842783          	lw	a5,-488(s0)
    800044f2:	4705                	li	a4,1
    800044f4:	fae79de3          	bne	a5,a4,800044ae <exec+0x31e>
    if(ph.memsz < ph.filesz)
    800044f8:	e4043483          	ld	s1,-448(s0)
    800044fc:	e3843783          	ld	a5,-456(s0)
    80004500:	f6f4ede3          	bltu	s1,a5,8000447a <exec+0x2ea>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004504:	e2843783          	ld	a5,-472(s0)
    80004508:	94be                	add	s1,s1,a5
    8000450a:	f6f4ebe3          	bltu	s1,a5,80004480 <exec+0x2f0>
    if(ph.vaddr % PGSIZE != 0)
    8000450e:	de043703          	ld	a4,-544(s0)
    80004512:	8ff9                	and	a5,a5,a4
    80004514:	fbad                	bnez	a5,80004486 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004516:	e1c42503          	lw	a0,-484(s0)
    8000451a:	00000097          	auipc	ra,0x0
    8000451e:	c5c080e7          	jalr	-932(ra) # 80004176 <flags2perm>
    80004522:	86aa                	mv	a3,a0
    80004524:	8626                	mv	a2,s1
    80004526:	85ca                	mv	a1,s2
    80004528:	855a                	mv	a0,s6
    8000452a:	ffffc097          	auipc	ra,0xffffc
    8000452e:	3da080e7          	jalr	986(ra) # 80000904 <uvmalloc>
    80004532:	dea43c23          	sd	a0,-520(s0)
    80004536:	d939                	beqz	a0,8000448c <exec+0x2fc>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004538:	e2843c03          	ld	s8,-472(s0)
    8000453c:	e2042c83          	lw	s9,-480(s0)
    80004540:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004544:	f60b83e3          	beqz	s7,800044aa <exec+0x31a>
    80004548:	89de                	mv	s3,s7
    8000454a:	4481                	li	s1,0
    8000454c:	bb9d                	j	800042c2 <exec+0x132>

000000008000454e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000454e:	7179                	addi	sp,sp,-48
    80004550:	f406                	sd	ra,40(sp)
    80004552:	f022                	sd	s0,32(sp)
    80004554:	ec26                	sd	s1,24(sp)
    80004556:	e84a                	sd	s2,16(sp)
    80004558:	1800                	addi	s0,sp,48
    8000455a:	892e                	mv	s2,a1
    8000455c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000455e:	fdc40593          	addi	a1,s0,-36
    80004562:	ffffe097          	auipc	ra,0xffffe
    80004566:	ae4080e7          	jalr	-1308(ra) # 80002046 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000456a:	fdc42703          	lw	a4,-36(s0)
    8000456e:	47bd                	li	a5,15
    80004570:	02e7eb63          	bltu	a5,a4,800045a6 <argfd+0x58>
    80004574:	ffffd097          	auipc	ra,0xffffd
    80004578:	92e080e7          	jalr	-1746(ra) # 80000ea2 <myproc>
    8000457c:	fdc42703          	lw	a4,-36(s0)
    80004580:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffdce7a>
    80004584:	078e                	slli	a5,a5,0x3
    80004586:	953e                	add	a0,a0,a5
    80004588:	651c                	ld	a5,8(a0)
    8000458a:	c385                	beqz	a5,800045aa <argfd+0x5c>
    return -1;
  if(pfd)
    8000458c:	00090463          	beqz	s2,80004594 <argfd+0x46>
    *pfd = fd;
    80004590:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004594:	4501                	li	a0,0
  if(pf)
    80004596:	c091                	beqz	s1,8000459a <argfd+0x4c>
    *pf = f;
    80004598:	e09c                	sd	a5,0(s1)
}
    8000459a:	70a2                	ld	ra,40(sp)
    8000459c:	7402                	ld	s0,32(sp)
    8000459e:	64e2                	ld	s1,24(sp)
    800045a0:	6942                	ld	s2,16(sp)
    800045a2:	6145                	addi	sp,sp,48
    800045a4:	8082                	ret
    return -1;
    800045a6:	557d                	li	a0,-1
    800045a8:	bfcd                	j	8000459a <argfd+0x4c>
    800045aa:	557d                	li	a0,-1
    800045ac:	b7fd                	j	8000459a <argfd+0x4c>

00000000800045ae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045ae:	1101                	addi	sp,sp,-32
    800045b0:	ec06                	sd	ra,24(sp)
    800045b2:	e822                	sd	s0,16(sp)
    800045b4:	e426                	sd	s1,8(sp)
    800045b6:	1000                	addi	s0,sp,32
    800045b8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800045ba:	ffffd097          	auipc	ra,0xffffd
    800045be:	8e8080e7          	jalr	-1816(ra) # 80000ea2 <myproc>
    800045c2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045c4:	0d850793          	addi	a5,a0,216
    800045c8:	4501                	li	a0,0
    800045ca:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045cc:	6398                	ld	a4,0(a5)
    800045ce:	cb19                	beqz	a4,800045e4 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045d0:	2505                	addiw	a0,a0,1
    800045d2:	07a1                	addi	a5,a5,8
    800045d4:	fed51ce3          	bne	a0,a3,800045cc <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045d8:	557d                	li	a0,-1
}
    800045da:	60e2                	ld	ra,24(sp)
    800045dc:	6442                	ld	s0,16(sp)
    800045de:	64a2                	ld	s1,8(sp)
    800045e0:	6105                	addi	sp,sp,32
    800045e2:	8082                	ret
      p->ofile[fd] = f;
    800045e4:	01a50793          	addi	a5,a0,26
    800045e8:	078e                	slli	a5,a5,0x3
    800045ea:	963e                	add	a2,a2,a5
    800045ec:	e604                	sd	s1,8(a2)
      return fd;
    800045ee:	b7f5                	j	800045da <fdalloc+0x2c>

00000000800045f0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045f0:	715d                	addi	sp,sp,-80
    800045f2:	e486                	sd	ra,72(sp)
    800045f4:	e0a2                	sd	s0,64(sp)
    800045f6:	fc26                	sd	s1,56(sp)
    800045f8:	f84a                	sd	s2,48(sp)
    800045fa:	f44e                	sd	s3,40(sp)
    800045fc:	f052                	sd	s4,32(sp)
    800045fe:	ec56                	sd	s5,24(sp)
    80004600:	e85a                	sd	s6,16(sp)
    80004602:	0880                	addi	s0,sp,80
    80004604:	8b2e                	mv	s6,a1
    80004606:	89b2                	mv	s3,a2
    80004608:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000460a:	fb040593          	addi	a1,s0,-80
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	e3e080e7          	jalr	-450(ra) # 8000344c <nameiparent>
    80004616:	84aa                	mv	s1,a0
    80004618:	14050f63          	beqz	a0,80004776 <create+0x186>
    return 0;

  ilock(dp);
    8000461c:	ffffe097          	auipc	ra,0xffffe
    80004620:	666080e7          	jalr	1638(ra) # 80002c82 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004624:	4601                	li	a2,0
    80004626:	fb040593          	addi	a1,s0,-80
    8000462a:	8526                	mv	a0,s1
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	b3a080e7          	jalr	-1222(ra) # 80003166 <dirlookup>
    80004634:	8aaa                	mv	s5,a0
    80004636:	c931                	beqz	a0,8000468a <create+0x9a>
    iunlockput(dp);
    80004638:	8526                	mv	a0,s1
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	8aa080e7          	jalr	-1878(ra) # 80002ee4 <iunlockput>
    ilock(ip);
    80004642:	8556                	mv	a0,s5
    80004644:	ffffe097          	auipc	ra,0xffffe
    80004648:	63e080e7          	jalr	1598(ra) # 80002c82 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000464c:	000b059b          	sext.w	a1,s6
    80004650:	4789                	li	a5,2
    80004652:	02f59563          	bne	a1,a5,8000467c <create+0x8c>
    80004656:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdcea4>
    8000465a:	37f9                	addiw	a5,a5,-2
    8000465c:	17c2                	slli	a5,a5,0x30
    8000465e:	93c1                	srli	a5,a5,0x30
    80004660:	4705                	li	a4,1
    80004662:	00f76d63          	bltu	a4,a5,8000467c <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004666:	8556                	mv	a0,s5
    80004668:	60a6                	ld	ra,72(sp)
    8000466a:	6406                	ld	s0,64(sp)
    8000466c:	74e2                	ld	s1,56(sp)
    8000466e:	7942                	ld	s2,48(sp)
    80004670:	79a2                	ld	s3,40(sp)
    80004672:	7a02                	ld	s4,32(sp)
    80004674:	6ae2                	ld	s5,24(sp)
    80004676:	6b42                	ld	s6,16(sp)
    80004678:	6161                	addi	sp,sp,80
    8000467a:	8082                	ret
    iunlockput(ip);
    8000467c:	8556                	mv	a0,s5
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	866080e7          	jalr	-1946(ra) # 80002ee4 <iunlockput>
    return 0;
    80004686:	4a81                	li	s5,0
    80004688:	bff9                	j	80004666 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000468a:	85da                	mv	a1,s6
    8000468c:	4088                	lw	a0,0(s1)
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	456080e7          	jalr	1110(ra) # 80002ae4 <ialloc>
    80004696:	8a2a                	mv	s4,a0
    80004698:	c539                	beqz	a0,800046e6 <create+0xf6>
  ilock(ip);
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	5e8080e7          	jalr	1512(ra) # 80002c82 <ilock>
  ip->major = major;
    800046a2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800046a6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800046aa:	4905                	li	s2,1
    800046ac:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800046b0:	8552                	mv	a0,s4
    800046b2:	ffffe097          	auipc	ra,0xffffe
    800046b6:	504080e7          	jalr	1284(ra) # 80002bb6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800046ba:	000b059b          	sext.w	a1,s6
    800046be:	03258b63          	beq	a1,s2,800046f4 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
    800046c2:	004a2603          	lw	a2,4(s4)
    800046c6:	fb040593          	addi	a1,s0,-80
    800046ca:	8526                	mv	a0,s1
    800046cc:	fffff097          	auipc	ra,0xfffff
    800046d0:	cb0080e7          	jalr	-848(ra) # 8000337c <dirlink>
    800046d4:	06054f63          	bltz	a0,80004752 <create+0x162>
  iunlockput(dp);
    800046d8:	8526                	mv	a0,s1
    800046da:	fffff097          	auipc	ra,0xfffff
    800046de:	80a080e7          	jalr	-2038(ra) # 80002ee4 <iunlockput>
  return ip;
    800046e2:	8ad2                	mv	s5,s4
    800046e4:	b749                	j	80004666 <create+0x76>
    iunlockput(dp);
    800046e6:	8526                	mv	a0,s1
    800046e8:	ffffe097          	auipc	ra,0xffffe
    800046ec:	7fc080e7          	jalr	2044(ra) # 80002ee4 <iunlockput>
    return 0;
    800046f0:	8ad2                	mv	s5,s4
    800046f2:	bf95                	j	80004666 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046f4:	004a2603          	lw	a2,4(s4)
    800046f8:	00004597          	auipc	a1,0x4
    800046fc:	1c058593          	addi	a1,a1,448 # 800088b8 <syscalls_name+0x2a8>
    80004700:	8552                	mv	a0,s4
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	c7a080e7          	jalr	-902(ra) # 8000337c <dirlink>
    8000470a:	04054463          	bltz	a0,80004752 <create+0x162>
    8000470e:	40d0                	lw	a2,4(s1)
    80004710:	00004597          	auipc	a1,0x4
    80004714:	1b058593          	addi	a1,a1,432 # 800088c0 <syscalls_name+0x2b0>
    80004718:	8552                	mv	a0,s4
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	c62080e7          	jalr	-926(ra) # 8000337c <dirlink>
    80004722:	02054863          	bltz	a0,80004752 <create+0x162>
  if(dirlink(dp, name, ip->inum) < 0)
    80004726:	004a2603          	lw	a2,4(s4)
    8000472a:	fb040593          	addi	a1,s0,-80
    8000472e:	8526                	mv	a0,s1
    80004730:	fffff097          	auipc	ra,0xfffff
    80004734:	c4c080e7          	jalr	-948(ra) # 8000337c <dirlink>
    80004738:	00054d63          	bltz	a0,80004752 <create+0x162>
    dp->nlink++;  // for ".."
    8000473c:	04a4d783          	lhu	a5,74(s1)
    80004740:	2785                	addiw	a5,a5,1
    80004742:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004746:	8526                	mv	a0,s1
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	46e080e7          	jalr	1134(ra) # 80002bb6 <iupdate>
    80004750:	b761                	j	800046d8 <create+0xe8>
  ip->nlink = 0;
    80004752:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004756:	8552                	mv	a0,s4
    80004758:	ffffe097          	auipc	ra,0xffffe
    8000475c:	45e080e7          	jalr	1118(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004760:	8552                	mv	a0,s4
    80004762:	ffffe097          	auipc	ra,0xffffe
    80004766:	782080e7          	jalr	1922(ra) # 80002ee4 <iunlockput>
  iunlockput(dp);
    8000476a:	8526                	mv	a0,s1
    8000476c:	ffffe097          	auipc	ra,0xffffe
    80004770:	778080e7          	jalr	1912(ra) # 80002ee4 <iunlockput>
  return 0;
    80004774:	bdcd                	j	80004666 <create+0x76>
    return 0;
    80004776:	8aaa                	mv	s5,a0
    80004778:	b5fd                	j	80004666 <create+0x76>

000000008000477a <sys_dup>:
{
    8000477a:	7179                	addi	sp,sp,-48
    8000477c:	f406                	sd	ra,40(sp)
    8000477e:	f022                	sd	s0,32(sp)
    80004780:	ec26                	sd	s1,24(sp)
    80004782:	e84a                	sd	s2,16(sp)
    80004784:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004786:	fd840613          	addi	a2,s0,-40
    8000478a:	4581                	li	a1,0
    8000478c:	4501                	li	a0,0
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	dc0080e7          	jalr	-576(ra) # 8000454e <argfd>
    return -1;
    80004796:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004798:	02054363          	bltz	a0,800047be <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    8000479c:	fd843903          	ld	s2,-40(s0)
    800047a0:	854a                	mv	a0,s2
    800047a2:	00000097          	auipc	ra,0x0
    800047a6:	e0c080e7          	jalr	-500(ra) # 800045ae <fdalloc>
    800047aa:	84aa                	mv	s1,a0
    return -1;
    800047ac:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800047ae:	00054863          	bltz	a0,800047be <sys_dup+0x44>
  filedup(f);
    800047b2:	854a                	mv	a0,s2
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	310080e7          	jalr	784(ra) # 80003ac4 <filedup>
  return fd;
    800047bc:	87a6                	mv	a5,s1
}
    800047be:	853e                	mv	a0,a5
    800047c0:	70a2                	ld	ra,40(sp)
    800047c2:	7402                	ld	s0,32(sp)
    800047c4:	64e2                	ld	s1,24(sp)
    800047c6:	6942                	ld	s2,16(sp)
    800047c8:	6145                	addi	sp,sp,48
    800047ca:	8082                	ret

00000000800047cc <sys_read>:
{
    800047cc:	7179                	addi	sp,sp,-48
    800047ce:	f406                	sd	ra,40(sp)
    800047d0:	f022                	sd	s0,32(sp)
    800047d2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047d4:	fd840593          	addi	a1,s0,-40
    800047d8:	4505                	li	a0,1
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	88c080e7          	jalr	-1908(ra) # 80002066 <argaddr>
  argint(2, &n);
    800047e2:	fe440593          	addi	a1,s0,-28
    800047e6:	4509                	li	a0,2
    800047e8:	ffffe097          	auipc	ra,0xffffe
    800047ec:	85e080e7          	jalr	-1954(ra) # 80002046 <argint>
  if(argfd(0, 0, &f) < 0)
    800047f0:	fe840613          	addi	a2,s0,-24
    800047f4:	4581                	li	a1,0
    800047f6:	4501                	li	a0,0
    800047f8:	00000097          	auipc	ra,0x0
    800047fc:	d56080e7          	jalr	-682(ra) # 8000454e <argfd>
    80004800:	87aa                	mv	a5,a0
    return -1;
    80004802:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004804:	0007cc63          	bltz	a5,8000481c <sys_read+0x50>
  return fileread(f, p, n);
    80004808:	fe442603          	lw	a2,-28(s0)
    8000480c:	fd843583          	ld	a1,-40(s0)
    80004810:	fe843503          	ld	a0,-24(s0)
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	43c080e7          	jalr	1084(ra) # 80003c50 <fileread>
}
    8000481c:	70a2                	ld	ra,40(sp)
    8000481e:	7402                	ld	s0,32(sp)
    80004820:	6145                	addi	sp,sp,48
    80004822:	8082                	ret

0000000080004824 <sys_write>:
{
    80004824:	7179                	addi	sp,sp,-48
    80004826:	f406                	sd	ra,40(sp)
    80004828:	f022                	sd	s0,32(sp)
    8000482a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000482c:	fd840593          	addi	a1,s0,-40
    80004830:	4505                	li	a0,1
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	834080e7          	jalr	-1996(ra) # 80002066 <argaddr>
  argint(2, &n);
    8000483a:	fe440593          	addi	a1,s0,-28
    8000483e:	4509                	li	a0,2
    80004840:	ffffe097          	auipc	ra,0xffffe
    80004844:	806080e7          	jalr	-2042(ra) # 80002046 <argint>
  if(argfd(0, 0, &f) < 0)
    80004848:	fe840613          	addi	a2,s0,-24
    8000484c:	4581                	li	a1,0
    8000484e:	4501                	li	a0,0
    80004850:	00000097          	auipc	ra,0x0
    80004854:	cfe080e7          	jalr	-770(ra) # 8000454e <argfd>
    80004858:	87aa                	mv	a5,a0
    return -1;
    8000485a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000485c:	0007cc63          	bltz	a5,80004874 <sys_write+0x50>
  return filewrite(f, p, n);
    80004860:	fe442603          	lw	a2,-28(s0)
    80004864:	fd843583          	ld	a1,-40(s0)
    80004868:	fe843503          	ld	a0,-24(s0)
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	4a6080e7          	jalr	1190(ra) # 80003d12 <filewrite>
}
    80004874:	70a2                	ld	ra,40(sp)
    80004876:	7402                	ld	s0,32(sp)
    80004878:	6145                	addi	sp,sp,48
    8000487a:	8082                	ret

000000008000487c <sys_close>:
{
    8000487c:	1101                	addi	sp,sp,-32
    8000487e:	ec06                	sd	ra,24(sp)
    80004880:	e822                	sd	s0,16(sp)
    80004882:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004884:	fe040613          	addi	a2,s0,-32
    80004888:	fec40593          	addi	a1,s0,-20
    8000488c:	4501                	li	a0,0
    8000488e:	00000097          	auipc	ra,0x0
    80004892:	cc0080e7          	jalr	-832(ra) # 8000454e <argfd>
    return -1;
    80004896:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004898:	02054463          	bltz	a0,800048c0 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000489c:	ffffc097          	auipc	ra,0xffffc
    800048a0:	606080e7          	jalr	1542(ra) # 80000ea2 <myproc>
    800048a4:	fec42783          	lw	a5,-20(s0)
    800048a8:	07e9                	addi	a5,a5,26
    800048aa:	078e                	slli	a5,a5,0x3
    800048ac:	953e                	add	a0,a0,a5
    800048ae:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800048b2:	fe043503          	ld	a0,-32(s0)
    800048b6:	fffff097          	auipc	ra,0xfffff
    800048ba:	260080e7          	jalr	608(ra) # 80003b16 <fileclose>
  return 0;
    800048be:	4781                	li	a5,0
}
    800048c0:	853e                	mv	a0,a5
    800048c2:	60e2                	ld	ra,24(sp)
    800048c4:	6442                	ld	s0,16(sp)
    800048c6:	6105                	addi	sp,sp,32
    800048c8:	8082                	ret

00000000800048ca <sys_fstat>:
{
    800048ca:	1101                	addi	sp,sp,-32
    800048cc:	ec06                	sd	ra,24(sp)
    800048ce:	e822                	sd	s0,16(sp)
    800048d0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048d2:	fe040593          	addi	a1,s0,-32
    800048d6:	4505                	li	a0,1
    800048d8:	ffffd097          	auipc	ra,0xffffd
    800048dc:	78e080e7          	jalr	1934(ra) # 80002066 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048e0:	fe840613          	addi	a2,s0,-24
    800048e4:	4581                	li	a1,0
    800048e6:	4501                	li	a0,0
    800048e8:	00000097          	auipc	ra,0x0
    800048ec:	c66080e7          	jalr	-922(ra) # 8000454e <argfd>
    800048f0:	87aa                	mv	a5,a0
    return -1;
    800048f2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048f4:	0007ca63          	bltz	a5,80004908 <sys_fstat+0x3e>
  return filestat(f, st);
    800048f8:	fe043583          	ld	a1,-32(s0)
    800048fc:	fe843503          	ld	a0,-24(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	2de080e7          	jalr	734(ra) # 80003bde <filestat>
}
    80004908:	60e2                	ld	ra,24(sp)
    8000490a:	6442                	ld	s0,16(sp)
    8000490c:	6105                	addi	sp,sp,32
    8000490e:	8082                	ret

0000000080004910 <sys_link>:
{
    80004910:	7169                	addi	sp,sp,-304
    80004912:	f606                	sd	ra,296(sp)
    80004914:	f222                	sd	s0,288(sp)
    80004916:	ee26                	sd	s1,280(sp)
    80004918:	ea4a                	sd	s2,272(sp)
    8000491a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000491c:	08000613          	li	a2,128
    80004920:	ed040593          	addi	a1,s0,-304
    80004924:	4501                	li	a0,0
    80004926:	ffffd097          	auipc	ra,0xffffd
    8000492a:	760080e7          	jalr	1888(ra) # 80002086 <argstr>
    return -1;
    8000492e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004930:	10054e63          	bltz	a0,80004a4c <sys_link+0x13c>
    80004934:	08000613          	li	a2,128
    80004938:	f5040593          	addi	a1,s0,-176
    8000493c:	4505                	li	a0,1
    8000493e:	ffffd097          	auipc	ra,0xffffd
    80004942:	748080e7          	jalr	1864(ra) # 80002086 <argstr>
    return -1;
    80004946:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004948:	10054263          	bltz	a0,80004a4c <sys_link+0x13c>
  begin_op();
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	d02080e7          	jalr	-766(ra) # 8000364e <begin_op>
  if((ip = namei(old)) == 0){
    80004954:	ed040513          	addi	a0,s0,-304
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	ad6080e7          	jalr	-1322(ra) # 8000342e <namei>
    80004960:	84aa                	mv	s1,a0
    80004962:	c551                	beqz	a0,800049ee <sys_link+0xde>
  ilock(ip);
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	31e080e7          	jalr	798(ra) # 80002c82 <ilock>
  if(ip->type == T_DIR){
    8000496c:	04449703          	lh	a4,68(s1)
    80004970:	4785                	li	a5,1
    80004972:	08f70463          	beq	a4,a5,800049fa <sys_link+0xea>
  ip->nlink++;
    80004976:	04a4d783          	lhu	a5,74(s1)
    8000497a:	2785                	addiw	a5,a5,1
    8000497c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004980:	8526                	mv	a0,s1
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	234080e7          	jalr	564(ra) # 80002bb6 <iupdate>
  iunlock(ip);
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	3b8080e7          	jalr	952(ra) # 80002d44 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004994:	fd040593          	addi	a1,s0,-48
    80004998:	f5040513          	addi	a0,s0,-176
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	ab0080e7          	jalr	-1360(ra) # 8000344c <nameiparent>
    800049a4:	892a                	mv	s2,a0
    800049a6:	c935                	beqz	a0,80004a1a <sys_link+0x10a>
  ilock(dp);
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	2da080e7          	jalr	730(ra) # 80002c82 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800049b0:	00092703          	lw	a4,0(s2)
    800049b4:	409c                	lw	a5,0(s1)
    800049b6:	04f71d63          	bne	a4,a5,80004a10 <sys_link+0x100>
    800049ba:	40d0                	lw	a2,4(s1)
    800049bc:	fd040593          	addi	a1,s0,-48
    800049c0:	854a                	mv	a0,s2
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	9ba080e7          	jalr	-1606(ra) # 8000337c <dirlink>
    800049ca:	04054363          	bltz	a0,80004a10 <sys_link+0x100>
  iunlockput(dp);
    800049ce:	854a                	mv	a0,s2
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	514080e7          	jalr	1300(ra) # 80002ee4 <iunlockput>
  iput(ip);
    800049d8:	8526                	mv	a0,s1
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	462080e7          	jalr	1122(ra) # 80002e3c <iput>
  end_op();
    800049e2:	fffff097          	auipc	ra,0xfffff
    800049e6:	cea080e7          	jalr	-790(ra) # 800036cc <end_op>
  return 0;
    800049ea:	4781                	li	a5,0
    800049ec:	a085                	j	80004a4c <sys_link+0x13c>
    end_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	cde080e7          	jalr	-802(ra) # 800036cc <end_op>
    return -1;
    800049f6:	57fd                	li	a5,-1
    800049f8:	a891                	j	80004a4c <sys_link+0x13c>
    iunlockput(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	4e8080e7          	jalr	1256(ra) # 80002ee4 <iunlockput>
    end_op();
    80004a04:	fffff097          	auipc	ra,0xfffff
    80004a08:	cc8080e7          	jalr	-824(ra) # 800036cc <end_op>
    return -1;
    80004a0c:	57fd                	li	a5,-1
    80004a0e:	a83d                	j	80004a4c <sys_link+0x13c>
    iunlockput(dp);
    80004a10:	854a                	mv	a0,s2
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	4d2080e7          	jalr	1234(ra) # 80002ee4 <iunlockput>
  ilock(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	266080e7          	jalr	614(ra) # 80002c82 <ilock>
  ip->nlink--;
    80004a24:	04a4d783          	lhu	a5,74(s1)
    80004a28:	37fd                	addiw	a5,a5,-1
    80004a2a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	186080e7          	jalr	390(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004a38:	8526                	mv	a0,s1
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	4aa080e7          	jalr	1194(ra) # 80002ee4 <iunlockput>
  end_op();
    80004a42:	fffff097          	auipc	ra,0xfffff
    80004a46:	c8a080e7          	jalr	-886(ra) # 800036cc <end_op>
  return -1;
    80004a4a:	57fd                	li	a5,-1
}
    80004a4c:	853e                	mv	a0,a5
    80004a4e:	70b2                	ld	ra,296(sp)
    80004a50:	7412                	ld	s0,288(sp)
    80004a52:	64f2                	ld	s1,280(sp)
    80004a54:	6952                	ld	s2,272(sp)
    80004a56:	6155                	addi	sp,sp,304
    80004a58:	8082                	ret

0000000080004a5a <sys_unlink>:
{
    80004a5a:	7151                	addi	sp,sp,-240
    80004a5c:	f586                	sd	ra,232(sp)
    80004a5e:	f1a2                	sd	s0,224(sp)
    80004a60:	eda6                	sd	s1,216(sp)
    80004a62:	e9ca                	sd	s2,208(sp)
    80004a64:	e5ce                	sd	s3,200(sp)
    80004a66:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a68:	08000613          	li	a2,128
    80004a6c:	f3040593          	addi	a1,s0,-208
    80004a70:	4501                	li	a0,0
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	614080e7          	jalr	1556(ra) # 80002086 <argstr>
    80004a7a:	18054163          	bltz	a0,80004bfc <sys_unlink+0x1a2>
  begin_op();
    80004a7e:	fffff097          	auipc	ra,0xfffff
    80004a82:	bd0080e7          	jalr	-1072(ra) # 8000364e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a86:	fb040593          	addi	a1,s0,-80
    80004a8a:	f3040513          	addi	a0,s0,-208
    80004a8e:	fffff097          	auipc	ra,0xfffff
    80004a92:	9be080e7          	jalr	-1602(ra) # 8000344c <nameiparent>
    80004a96:	84aa                	mv	s1,a0
    80004a98:	c979                	beqz	a0,80004b6e <sys_unlink+0x114>
  ilock(dp);
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	1e8080e7          	jalr	488(ra) # 80002c82 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004aa2:	00004597          	auipc	a1,0x4
    80004aa6:	e1658593          	addi	a1,a1,-490 # 800088b8 <syscalls_name+0x2a8>
    80004aaa:	fb040513          	addi	a0,s0,-80
    80004aae:	ffffe097          	auipc	ra,0xffffe
    80004ab2:	69e080e7          	jalr	1694(ra) # 8000314c <namecmp>
    80004ab6:	14050a63          	beqz	a0,80004c0a <sys_unlink+0x1b0>
    80004aba:	00004597          	auipc	a1,0x4
    80004abe:	e0658593          	addi	a1,a1,-506 # 800088c0 <syscalls_name+0x2b0>
    80004ac2:	fb040513          	addi	a0,s0,-80
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	686080e7          	jalr	1670(ra) # 8000314c <namecmp>
    80004ace:	12050e63          	beqz	a0,80004c0a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ad2:	f2c40613          	addi	a2,s0,-212
    80004ad6:	fb040593          	addi	a1,s0,-80
    80004ada:	8526                	mv	a0,s1
    80004adc:	ffffe097          	auipc	ra,0xffffe
    80004ae0:	68a080e7          	jalr	1674(ra) # 80003166 <dirlookup>
    80004ae4:	892a                	mv	s2,a0
    80004ae6:	12050263          	beqz	a0,80004c0a <sys_unlink+0x1b0>
  ilock(ip);
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	198080e7          	jalr	408(ra) # 80002c82 <ilock>
  if(ip->nlink < 1)
    80004af2:	04a91783          	lh	a5,74(s2)
    80004af6:	08f05263          	blez	a5,80004b7a <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004afa:	04491703          	lh	a4,68(s2)
    80004afe:	4785                	li	a5,1
    80004b00:	08f70563          	beq	a4,a5,80004b8a <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004b04:	4641                	li	a2,16
    80004b06:	4581                	li	a1,0
    80004b08:	fc040513          	addi	a0,s0,-64
    80004b0c:	ffffb097          	auipc	ra,0xffffb
    80004b10:	6ba080e7          	jalr	1722(ra) # 800001c6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b14:	4741                	li	a4,16
    80004b16:	f2c42683          	lw	a3,-212(s0)
    80004b1a:	fc040613          	addi	a2,s0,-64
    80004b1e:	4581                	li	a1,0
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	50c080e7          	jalr	1292(ra) # 8000302e <writei>
    80004b2a:	47c1                	li	a5,16
    80004b2c:	0af51563          	bne	a0,a5,80004bd6 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b30:	04491703          	lh	a4,68(s2)
    80004b34:	4785                	li	a5,1
    80004b36:	0af70863          	beq	a4,a5,80004be6 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	3a8080e7          	jalr	936(ra) # 80002ee4 <iunlockput>
  ip->nlink--;
    80004b44:	04a95783          	lhu	a5,74(s2)
    80004b48:	37fd                	addiw	a5,a5,-1
    80004b4a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b4e:	854a                	mv	a0,s2
    80004b50:	ffffe097          	auipc	ra,0xffffe
    80004b54:	066080e7          	jalr	102(ra) # 80002bb6 <iupdate>
  iunlockput(ip);
    80004b58:	854a                	mv	a0,s2
    80004b5a:	ffffe097          	auipc	ra,0xffffe
    80004b5e:	38a080e7          	jalr	906(ra) # 80002ee4 <iunlockput>
  end_op();
    80004b62:	fffff097          	auipc	ra,0xfffff
    80004b66:	b6a080e7          	jalr	-1174(ra) # 800036cc <end_op>
  return 0;
    80004b6a:	4501                	li	a0,0
    80004b6c:	a84d                	j	80004c1e <sys_unlink+0x1c4>
    end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	b5e080e7          	jalr	-1186(ra) # 800036cc <end_op>
    return -1;
    80004b76:	557d                	li	a0,-1
    80004b78:	a05d                	j	80004c1e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b7a:	00004517          	auipc	a0,0x4
    80004b7e:	d4e50513          	addi	a0,a0,-690 # 800088c8 <syscalls_name+0x2b8>
    80004b82:	00001097          	auipc	ra,0x1
    80004b86:	1ba080e7          	jalr	442(ra) # 80005d3c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b8a:	04c92703          	lw	a4,76(s2)
    80004b8e:	02000793          	li	a5,32
    80004b92:	f6e7f9e3          	bgeu	a5,a4,80004b04 <sys_unlink+0xaa>
    80004b96:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b9a:	4741                	li	a4,16
    80004b9c:	86ce                	mv	a3,s3
    80004b9e:	f1840613          	addi	a2,s0,-232
    80004ba2:	4581                	li	a1,0
    80004ba4:	854a                	mv	a0,s2
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	390080e7          	jalr	912(ra) # 80002f36 <readi>
    80004bae:	47c1                	li	a5,16
    80004bb0:	00f51b63          	bne	a0,a5,80004bc6 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004bb4:	f1845783          	lhu	a5,-232(s0)
    80004bb8:	e7a1                	bnez	a5,80004c00 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004bba:	29c1                	addiw	s3,s3,16
    80004bbc:	04c92783          	lw	a5,76(s2)
    80004bc0:	fcf9ede3          	bltu	s3,a5,80004b9a <sys_unlink+0x140>
    80004bc4:	b781                	j	80004b04 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bc6:	00004517          	auipc	a0,0x4
    80004bca:	d1a50513          	addi	a0,a0,-742 # 800088e0 <syscalls_name+0x2d0>
    80004bce:	00001097          	auipc	ra,0x1
    80004bd2:	16e080e7          	jalr	366(ra) # 80005d3c <panic>
    panic("unlink: writei");
    80004bd6:	00004517          	auipc	a0,0x4
    80004bda:	d2250513          	addi	a0,a0,-734 # 800088f8 <syscalls_name+0x2e8>
    80004bde:	00001097          	auipc	ra,0x1
    80004be2:	15e080e7          	jalr	350(ra) # 80005d3c <panic>
    dp->nlink--;
    80004be6:	04a4d783          	lhu	a5,74(s1)
    80004bea:	37fd                	addiw	a5,a5,-1
    80004bec:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bf0:	8526                	mv	a0,s1
    80004bf2:	ffffe097          	auipc	ra,0xffffe
    80004bf6:	fc4080e7          	jalr	-60(ra) # 80002bb6 <iupdate>
    80004bfa:	b781                	j	80004b3a <sys_unlink+0xe0>
    return -1;
    80004bfc:	557d                	li	a0,-1
    80004bfe:	a005                	j	80004c1e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004c00:	854a                	mv	a0,s2
    80004c02:	ffffe097          	auipc	ra,0xffffe
    80004c06:	2e2080e7          	jalr	738(ra) # 80002ee4 <iunlockput>
  iunlockput(dp);
    80004c0a:	8526                	mv	a0,s1
    80004c0c:	ffffe097          	auipc	ra,0xffffe
    80004c10:	2d8080e7          	jalr	728(ra) # 80002ee4 <iunlockput>
  end_op();
    80004c14:	fffff097          	auipc	ra,0xfffff
    80004c18:	ab8080e7          	jalr	-1352(ra) # 800036cc <end_op>
  return -1;
    80004c1c:	557d                	li	a0,-1
}
    80004c1e:	70ae                	ld	ra,232(sp)
    80004c20:	740e                	ld	s0,224(sp)
    80004c22:	64ee                	ld	s1,216(sp)
    80004c24:	694e                	ld	s2,208(sp)
    80004c26:	69ae                	ld	s3,200(sp)
    80004c28:	616d                	addi	sp,sp,240
    80004c2a:	8082                	ret

0000000080004c2c <sys_open>:

uint64
sys_open(void)
{
    80004c2c:	7131                	addi	sp,sp,-192
    80004c2e:	fd06                	sd	ra,184(sp)
    80004c30:	f922                	sd	s0,176(sp)
    80004c32:	f526                	sd	s1,168(sp)
    80004c34:	f14a                	sd	s2,160(sp)
    80004c36:	ed4e                	sd	s3,152(sp)
    80004c38:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c3a:	f4c40593          	addi	a1,s0,-180
    80004c3e:	4505                	li	a0,1
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	406080e7          	jalr	1030(ra) # 80002046 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c48:	08000613          	li	a2,128
    80004c4c:	f5040593          	addi	a1,s0,-176
    80004c50:	4501                	li	a0,0
    80004c52:	ffffd097          	auipc	ra,0xffffd
    80004c56:	434080e7          	jalr	1076(ra) # 80002086 <argstr>
    80004c5a:	87aa                	mv	a5,a0
    return -1;
    80004c5c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c5e:	0a07c963          	bltz	a5,80004d10 <sys_open+0xe4>

  begin_op();
    80004c62:	fffff097          	auipc	ra,0xfffff
    80004c66:	9ec080e7          	jalr	-1556(ra) # 8000364e <begin_op>

  if(omode & O_CREATE){
    80004c6a:	f4c42783          	lw	a5,-180(s0)
    80004c6e:	2007f793          	andi	a5,a5,512
    80004c72:	cfc5                	beqz	a5,80004d2a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c74:	4681                	li	a3,0
    80004c76:	4601                	li	a2,0
    80004c78:	4589                	li	a1,2
    80004c7a:	f5040513          	addi	a0,s0,-176
    80004c7e:	00000097          	auipc	ra,0x0
    80004c82:	972080e7          	jalr	-1678(ra) # 800045f0 <create>
    80004c86:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c88:	c959                	beqz	a0,80004d1e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c8a:	04449703          	lh	a4,68(s1)
    80004c8e:	478d                	li	a5,3
    80004c90:	00f71763          	bne	a4,a5,80004c9e <sys_open+0x72>
    80004c94:	0464d703          	lhu	a4,70(s1)
    80004c98:	47a5                	li	a5,9
    80004c9a:	0ce7ed63          	bltu	a5,a4,80004d74 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	dbc080e7          	jalr	-580(ra) # 80003a5a <filealloc>
    80004ca6:	89aa                	mv	s3,a0
    80004ca8:	10050363          	beqz	a0,80004dae <sys_open+0x182>
    80004cac:	00000097          	auipc	ra,0x0
    80004cb0:	902080e7          	jalr	-1790(ra) # 800045ae <fdalloc>
    80004cb4:	892a                	mv	s2,a0
    80004cb6:	0e054763          	bltz	a0,80004da4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cba:	04449703          	lh	a4,68(s1)
    80004cbe:	478d                	li	a5,3
    80004cc0:	0cf70563          	beq	a4,a5,80004d8a <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cc4:	4789                	li	a5,2
    80004cc6:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cca:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cce:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cd2:	f4c42783          	lw	a5,-180(s0)
    80004cd6:	0017c713          	xori	a4,a5,1
    80004cda:	8b05                	andi	a4,a4,1
    80004cdc:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ce0:	0037f713          	andi	a4,a5,3
    80004ce4:	00e03733          	snez	a4,a4
    80004ce8:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cec:	4007f793          	andi	a5,a5,1024
    80004cf0:	c791                	beqz	a5,80004cfc <sys_open+0xd0>
    80004cf2:	04449703          	lh	a4,68(s1)
    80004cf6:	4789                	li	a5,2
    80004cf8:	0af70063          	beq	a4,a5,80004d98 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	ffffe097          	auipc	ra,0xffffe
    80004d02:	046080e7          	jalr	70(ra) # 80002d44 <iunlock>
  end_op();
    80004d06:	fffff097          	auipc	ra,0xfffff
    80004d0a:	9c6080e7          	jalr	-1594(ra) # 800036cc <end_op>

  return fd;
    80004d0e:	854a                	mv	a0,s2
}
    80004d10:	70ea                	ld	ra,184(sp)
    80004d12:	744a                	ld	s0,176(sp)
    80004d14:	74aa                	ld	s1,168(sp)
    80004d16:	790a                	ld	s2,160(sp)
    80004d18:	69ea                	ld	s3,152(sp)
    80004d1a:	6129                	addi	sp,sp,192
    80004d1c:	8082                	ret
      end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	9ae080e7          	jalr	-1618(ra) # 800036cc <end_op>
      return -1;
    80004d26:	557d                	li	a0,-1
    80004d28:	b7e5                	j	80004d10 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d2a:	f5040513          	addi	a0,s0,-176
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	700080e7          	jalr	1792(ra) # 8000342e <namei>
    80004d36:	84aa                	mv	s1,a0
    80004d38:	c905                	beqz	a0,80004d68 <sys_open+0x13c>
    ilock(ip);
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	f48080e7          	jalr	-184(ra) # 80002c82 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d42:	04449703          	lh	a4,68(s1)
    80004d46:	4785                	li	a5,1
    80004d48:	f4f711e3          	bne	a4,a5,80004c8a <sys_open+0x5e>
    80004d4c:	f4c42783          	lw	a5,-180(s0)
    80004d50:	d7b9                	beqz	a5,80004c9e <sys_open+0x72>
      iunlockput(ip);
    80004d52:	8526                	mv	a0,s1
    80004d54:	ffffe097          	auipc	ra,0xffffe
    80004d58:	190080e7          	jalr	400(ra) # 80002ee4 <iunlockput>
      end_op();
    80004d5c:	fffff097          	auipc	ra,0xfffff
    80004d60:	970080e7          	jalr	-1680(ra) # 800036cc <end_op>
      return -1;
    80004d64:	557d                	li	a0,-1
    80004d66:	b76d                	j	80004d10 <sys_open+0xe4>
      end_op();
    80004d68:	fffff097          	auipc	ra,0xfffff
    80004d6c:	964080e7          	jalr	-1692(ra) # 800036cc <end_op>
      return -1;
    80004d70:	557d                	li	a0,-1
    80004d72:	bf79                	j	80004d10 <sys_open+0xe4>
    iunlockput(ip);
    80004d74:	8526                	mv	a0,s1
    80004d76:	ffffe097          	auipc	ra,0xffffe
    80004d7a:	16e080e7          	jalr	366(ra) # 80002ee4 <iunlockput>
    end_op();
    80004d7e:	fffff097          	auipc	ra,0xfffff
    80004d82:	94e080e7          	jalr	-1714(ra) # 800036cc <end_op>
    return -1;
    80004d86:	557d                	li	a0,-1
    80004d88:	b761                	j	80004d10 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d8a:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d8e:	04649783          	lh	a5,70(s1)
    80004d92:	02f99223          	sh	a5,36(s3)
    80004d96:	bf25                	j	80004cce <sys_open+0xa2>
    itrunc(ip);
    80004d98:	8526                	mv	a0,s1
    80004d9a:	ffffe097          	auipc	ra,0xffffe
    80004d9e:	ff6080e7          	jalr	-10(ra) # 80002d90 <itrunc>
    80004da2:	bfa9                	j	80004cfc <sys_open+0xd0>
      fileclose(f);
    80004da4:	854e                	mv	a0,s3
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	d70080e7          	jalr	-656(ra) # 80003b16 <fileclose>
    iunlockput(ip);
    80004dae:	8526                	mv	a0,s1
    80004db0:	ffffe097          	auipc	ra,0xffffe
    80004db4:	134080e7          	jalr	308(ra) # 80002ee4 <iunlockput>
    end_op();
    80004db8:	fffff097          	auipc	ra,0xfffff
    80004dbc:	914080e7          	jalr	-1772(ra) # 800036cc <end_op>
    return -1;
    80004dc0:	557d                	li	a0,-1
    80004dc2:	b7b9                	j	80004d10 <sys_open+0xe4>

0000000080004dc4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dc4:	7175                	addi	sp,sp,-144
    80004dc6:	e506                	sd	ra,136(sp)
    80004dc8:	e122                	sd	s0,128(sp)
    80004dca:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dcc:	fffff097          	auipc	ra,0xfffff
    80004dd0:	882080e7          	jalr	-1918(ra) # 8000364e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dd4:	08000613          	li	a2,128
    80004dd8:	f7040593          	addi	a1,s0,-144
    80004ddc:	4501                	li	a0,0
    80004dde:	ffffd097          	auipc	ra,0xffffd
    80004de2:	2a8080e7          	jalr	680(ra) # 80002086 <argstr>
    80004de6:	02054963          	bltz	a0,80004e18 <sys_mkdir+0x54>
    80004dea:	4681                	li	a3,0
    80004dec:	4601                	li	a2,0
    80004dee:	4585                	li	a1,1
    80004df0:	f7040513          	addi	a0,s0,-144
    80004df4:	fffff097          	auipc	ra,0xfffff
    80004df8:	7fc080e7          	jalr	2044(ra) # 800045f0 <create>
    80004dfc:	cd11                	beqz	a0,80004e18 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dfe:	ffffe097          	auipc	ra,0xffffe
    80004e02:	0e6080e7          	jalr	230(ra) # 80002ee4 <iunlockput>
  end_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	8c6080e7          	jalr	-1850(ra) # 800036cc <end_op>
  return 0;
    80004e0e:	4501                	li	a0,0
}
    80004e10:	60aa                	ld	ra,136(sp)
    80004e12:	640a                	ld	s0,128(sp)
    80004e14:	6149                	addi	sp,sp,144
    80004e16:	8082                	ret
    end_op();
    80004e18:	fffff097          	auipc	ra,0xfffff
    80004e1c:	8b4080e7          	jalr	-1868(ra) # 800036cc <end_op>
    return -1;
    80004e20:	557d                	li	a0,-1
    80004e22:	b7fd                	j	80004e10 <sys_mkdir+0x4c>

0000000080004e24 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e24:	7135                	addi	sp,sp,-160
    80004e26:	ed06                	sd	ra,152(sp)
    80004e28:	e922                	sd	s0,144(sp)
    80004e2a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e2c:	fffff097          	auipc	ra,0xfffff
    80004e30:	822080e7          	jalr	-2014(ra) # 8000364e <begin_op>
  argint(1, &major);
    80004e34:	f6c40593          	addi	a1,s0,-148
    80004e38:	4505                	li	a0,1
    80004e3a:	ffffd097          	auipc	ra,0xffffd
    80004e3e:	20c080e7          	jalr	524(ra) # 80002046 <argint>
  argint(2, &minor);
    80004e42:	f6840593          	addi	a1,s0,-152
    80004e46:	4509                	li	a0,2
    80004e48:	ffffd097          	auipc	ra,0xffffd
    80004e4c:	1fe080e7          	jalr	510(ra) # 80002046 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e50:	08000613          	li	a2,128
    80004e54:	f7040593          	addi	a1,s0,-144
    80004e58:	4501                	li	a0,0
    80004e5a:	ffffd097          	auipc	ra,0xffffd
    80004e5e:	22c080e7          	jalr	556(ra) # 80002086 <argstr>
    80004e62:	02054b63          	bltz	a0,80004e98 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e66:	f6841683          	lh	a3,-152(s0)
    80004e6a:	f6c41603          	lh	a2,-148(s0)
    80004e6e:	458d                	li	a1,3
    80004e70:	f7040513          	addi	a0,s0,-144
    80004e74:	fffff097          	auipc	ra,0xfffff
    80004e78:	77c080e7          	jalr	1916(ra) # 800045f0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e7c:	cd11                	beqz	a0,80004e98 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	066080e7          	jalr	102(ra) # 80002ee4 <iunlockput>
  end_op();
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	846080e7          	jalr	-1978(ra) # 800036cc <end_op>
  return 0;
    80004e8e:	4501                	li	a0,0
}
    80004e90:	60ea                	ld	ra,152(sp)
    80004e92:	644a                	ld	s0,144(sp)
    80004e94:	610d                	addi	sp,sp,160
    80004e96:	8082                	ret
    end_op();
    80004e98:	fffff097          	auipc	ra,0xfffff
    80004e9c:	834080e7          	jalr	-1996(ra) # 800036cc <end_op>
    return -1;
    80004ea0:	557d                	li	a0,-1
    80004ea2:	b7fd                	j	80004e90 <sys_mknod+0x6c>

0000000080004ea4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ea4:	7135                	addi	sp,sp,-160
    80004ea6:	ed06                	sd	ra,152(sp)
    80004ea8:	e922                	sd	s0,144(sp)
    80004eaa:	e526                	sd	s1,136(sp)
    80004eac:	e14a                	sd	s2,128(sp)
    80004eae:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	ff2080e7          	jalr	-14(ra) # 80000ea2 <myproc>
    80004eb8:	892a                	mv	s2,a0
  
  begin_op();
    80004eba:	ffffe097          	auipc	ra,0xffffe
    80004ebe:	794080e7          	jalr	1940(ra) # 8000364e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ec2:	08000613          	li	a2,128
    80004ec6:	f6040593          	addi	a1,s0,-160
    80004eca:	4501                	li	a0,0
    80004ecc:	ffffd097          	auipc	ra,0xffffd
    80004ed0:	1ba080e7          	jalr	442(ra) # 80002086 <argstr>
    80004ed4:	04054b63          	bltz	a0,80004f2a <sys_chdir+0x86>
    80004ed8:	f6040513          	addi	a0,s0,-160
    80004edc:	ffffe097          	auipc	ra,0xffffe
    80004ee0:	552080e7          	jalr	1362(ra) # 8000342e <namei>
    80004ee4:	84aa                	mv	s1,a0
    80004ee6:	c131                	beqz	a0,80004f2a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ee8:	ffffe097          	auipc	ra,0xffffe
    80004eec:	d9a080e7          	jalr	-614(ra) # 80002c82 <ilock>
  if(ip->type != T_DIR){
    80004ef0:	04449703          	lh	a4,68(s1)
    80004ef4:	4785                	li	a5,1
    80004ef6:	04f71063          	bne	a4,a5,80004f36 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004efa:	8526                	mv	a0,s1
    80004efc:	ffffe097          	auipc	ra,0xffffe
    80004f00:	e48080e7          	jalr	-440(ra) # 80002d44 <iunlock>
  iput(p->cwd);
    80004f04:	15893503          	ld	a0,344(s2)
    80004f08:	ffffe097          	auipc	ra,0xffffe
    80004f0c:	f34080e7          	jalr	-204(ra) # 80002e3c <iput>
  end_op();
    80004f10:	ffffe097          	auipc	ra,0xffffe
    80004f14:	7bc080e7          	jalr	1980(ra) # 800036cc <end_op>
  p->cwd = ip;
    80004f18:	14993c23          	sd	s1,344(s2)
  return 0;
    80004f1c:	4501                	li	a0,0
}
    80004f1e:	60ea                	ld	ra,152(sp)
    80004f20:	644a                	ld	s0,144(sp)
    80004f22:	64aa                	ld	s1,136(sp)
    80004f24:	690a                	ld	s2,128(sp)
    80004f26:	610d                	addi	sp,sp,160
    80004f28:	8082                	ret
    end_op();
    80004f2a:	ffffe097          	auipc	ra,0xffffe
    80004f2e:	7a2080e7          	jalr	1954(ra) # 800036cc <end_op>
    return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	b7ed                	j	80004f1e <sys_chdir+0x7a>
    iunlockput(ip);
    80004f36:	8526                	mv	a0,s1
    80004f38:	ffffe097          	auipc	ra,0xffffe
    80004f3c:	fac080e7          	jalr	-84(ra) # 80002ee4 <iunlockput>
    end_op();
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	78c080e7          	jalr	1932(ra) # 800036cc <end_op>
    return -1;
    80004f48:	557d                	li	a0,-1
    80004f4a:	bfd1                	j	80004f1e <sys_chdir+0x7a>

0000000080004f4c <sys_exec>:

uint64
sys_exec(void)
{
    80004f4c:	7145                	addi	sp,sp,-464
    80004f4e:	e786                	sd	ra,456(sp)
    80004f50:	e3a2                	sd	s0,448(sp)
    80004f52:	ff26                	sd	s1,440(sp)
    80004f54:	fb4a                	sd	s2,432(sp)
    80004f56:	f74e                	sd	s3,424(sp)
    80004f58:	f352                	sd	s4,416(sp)
    80004f5a:	ef56                	sd	s5,408(sp)
    80004f5c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f5e:	e3840593          	addi	a1,s0,-456
    80004f62:	4505                	li	a0,1
    80004f64:	ffffd097          	auipc	ra,0xffffd
    80004f68:	102080e7          	jalr	258(ra) # 80002066 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f6c:	08000613          	li	a2,128
    80004f70:	f4040593          	addi	a1,s0,-192
    80004f74:	4501                	li	a0,0
    80004f76:	ffffd097          	auipc	ra,0xffffd
    80004f7a:	110080e7          	jalr	272(ra) # 80002086 <argstr>
    80004f7e:	87aa                	mv	a5,a0
    return -1;
    80004f80:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f82:	0c07c363          	bltz	a5,80005048 <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    80004f86:	10000613          	li	a2,256
    80004f8a:	4581                	li	a1,0
    80004f8c:	e4040513          	addi	a0,s0,-448
    80004f90:	ffffb097          	auipc	ra,0xffffb
    80004f94:	236080e7          	jalr	566(ra) # 800001c6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f98:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f9c:	89a6                	mv	s3,s1
    80004f9e:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004fa0:	02000a13          	li	s4,32
    80004fa4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fa8:	00391513          	slli	a0,s2,0x3
    80004fac:	e3040593          	addi	a1,s0,-464
    80004fb0:	e3843783          	ld	a5,-456(s0)
    80004fb4:	953e                	add	a0,a0,a5
    80004fb6:	ffffd097          	auipc	ra,0xffffd
    80004fba:	ff2080e7          	jalr	-14(ra) # 80001fa8 <fetchaddr>
    80004fbe:	02054a63          	bltz	a0,80004ff2 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004fc2:	e3043783          	ld	a5,-464(s0)
    80004fc6:	c3b9                	beqz	a5,8000500c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004fc8:	ffffb097          	auipc	ra,0xffffb
    80004fcc:	152080e7          	jalr	338(ra) # 8000011a <kalloc>
    80004fd0:	85aa                	mv	a1,a0
    80004fd2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fd6:	cd11                	beqz	a0,80004ff2 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fd8:	6605                	lui	a2,0x1
    80004fda:	e3043503          	ld	a0,-464(s0)
    80004fde:	ffffd097          	auipc	ra,0xffffd
    80004fe2:	01c080e7          	jalr	28(ra) # 80001ffa <fetchstr>
    80004fe6:	00054663          	bltz	a0,80004ff2 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fea:	0905                	addi	s2,s2,1
    80004fec:	09a1                	addi	s3,s3,8
    80004fee:	fb491be3          	bne	s2,s4,80004fa4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ff2:	f4040913          	addi	s2,s0,-192
    80004ff6:	6088                	ld	a0,0(s1)
    80004ff8:	c539                	beqz	a0,80005046 <sys_exec+0xfa>
    kfree(argv[i]);
    80004ffa:	ffffb097          	auipc	ra,0xffffb
    80004ffe:	022080e7          	jalr	34(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005002:	04a1                	addi	s1,s1,8
    80005004:	ff2499e3          	bne	s1,s2,80004ff6 <sys_exec+0xaa>
  return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	a83d                	j	80005048 <sys_exec+0xfc>
      argv[i] = 0;
    8000500c:	0a8e                	slli	s5,s5,0x3
    8000500e:	fc0a8793          	addi	a5,s5,-64
    80005012:	00878ab3          	add	s5,a5,s0
    80005016:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000501a:	e4040593          	addi	a1,s0,-448
    8000501e:	f4040513          	addi	a0,s0,-192
    80005022:	fffff097          	auipc	ra,0xfffff
    80005026:	16e080e7          	jalr	366(ra) # 80004190 <exec>
    8000502a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000502c:	f4040993          	addi	s3,s0,-192
    80005030:	6088                	ld	a0,0(s1)
    80005032:	c901                	beqz	a0,80005042 <sys_exec+0xf6>
    kfree(argv[i]);
    80005034:	ffffb097          	auipc	ra,0xffffb
    80005038:	fe8080e7          	jalr	-24(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000503c:	04a1                	addi	s1,s1,8
    8000503e:	ff3499e3          	bne	s1,s3,80005030 <sys_exec+0xe4>
  return ret;
    80005042:	854a                	mv	a0,s2
    80005044:	a011                	j	80005048 <sys_exec+0xfc>
  return -1;
    80005046:	557d                	li	a0,-1
}
    80005048:	60be                	ld	ra,456(sp)
    8000504a:	641e                	ld	s0,448(sp)
    8000504c:	74fa                	ld	s1,440(sp)
    8000504e:	795a                	ld	s2,432(sp)
    80005050:	79ba                	ld	s3,424(sp)
    80005052:	7a1a                	ld	s4,416(sp)
    80005054:	6afa                	ld	s5,408(sp)
    80005056:	6179                	addi	sp,sp,464
    80005058:	8082                	ret

000000008000505a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000505a:	7139                	addi	sp,sp,-64
    8000505c:	fc06                	sd	ra,56(sp)
    8000505e:	f822                	sd	s0,48(sp)
    80005060:	f426                	sd	s1,40(sp)
    80005062:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005064:	ffffc097          	auipc	ra,0xffffc
    80005068:	e3e080e7          	jalr	-450(ra) # 80000ea2 <myproc>
    8000506c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000506e:	fd840593          	addi	a1,s0,-40
    80005072:	4501                	li	a0,0
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	ff2080e7          	jalr	-14(ra) # 80002066 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000507c:	fc840593          	addi	a1,s0,-56
    80005080:	fd040513          	addi	a0,s0,-48
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	dc2080e7          	jalr	-574(ra) # 80003e46 <pipealloc>
    return -1;
    8000508c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000508e:	0c054463          	bltz	a0,80005156 <sys_pipe+0xfc>
  fd0 = -1;
    80005092:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005096:	fd043503          	ld	a0,-48(s0)
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	514080e7          	jalr	1300(ra) # 800045ae <fdalloc>
    800050a2:	fca42223          	sw	a0,-60(s0)
    800050a6:	08054b63          	bltz	a0,8000513c <sys_pipe+0xe2>
    800050aa:	fc843503          	ld	a0,-56(s0)
    800050ae:	fffff097          	auipc	ra,0xfffff
    800050b2:	500080e7          	jalr	1280(ra) # 800045ae <fdalloc>
    800050b6:	fca42023          	sw	a0,-64(s0)
    800050ba:	06054863          	bltz	a0,8000512a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050be:	4691                	li	a3,4
    800050c0:	fc440613          	addi	a2,s0,-60
    800050c4:	fd843583          	ld	a1,-40(s0)
    800050c8:	6ca8                	ld	a0,88(s1)
    800050ca:	ffffc097          	auipc	ra,0xffffc
    800050ce:	a96080e7          	jalr	-1386(ra) # 80000b60 <copyout>
    800050d2:	02054063          	bltz	a0,800050f2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050d6:	4691                	li	a3,4
    800050d8:	fc040613          	addi	a2,s0,-64
    800050dc:	fd843583          	ld	a1,-40(s0)
    800050e0:	0591                	addi	a1,a1,4
    800050e2:	6ca8                	ld	a0,88(s1)
    800050e4:	ffffc097          	auipc	ra,0xffffc
    800050e8:	a7c080e7          	jalr	-1412(ra) # 80000b60 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050ec:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ee:	06055463          	bgez	a0,80005156 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050f2:	fc442783          	lw	a5,-60(s0)
    800050f6:	07e9                	addi	a5,a5,26
    800050f8:	078e                	slli	a5,a5,0x3
    800050fa:	97a6                	add	a5,a5,s1
    800050fc:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005100:	fc042783          	lw	a5,-64(s0)
    80005104:	07e9                	addi	a5,a5,26
    80005106:	078e                	slli	a5,a5,0x3
    80005108:	94be                	add	s1,s1,a5
    8000510a:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    8000510e:	fd043503          	ld	a0,-48(s0)
    80005112:	fffff097          	auipc	ra,0xfffff
    80005116:	a04080e7          	jalr	-1532(ra) # 80003b16 <fileclose>
    fileclose(wf);
    8000511a:	fc843503          	ld	a0,-56(s0)
    8000511e:	fffff097          	auipc	ra,0xfffff
    80005122:	9f8080e7          	jalr	-1544(ra) # 80003b16 <fileclose>
    return -1;
    80005126:	57fd                	li	a5,-1
    80005128:	a03d                	j	80005156 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000512a:	fc442783          	lw	a5,-60(s0)
    8000512e:	0007c763          	bltz	a5,8000513c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005132:	07e9                	addi	a5,a5,26
    80005134:	078e                	slli	a5,a5,0x3
    80005136:	97a6                	add	a5,a5,s1
    80005138:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000513c:	fd043503          	ld	a0,-48(s0)
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	9d6080e7          	jalr	-1578(ra) # 80003b16 <fileclose>
    fileclose(wf);
    80005148:	fc843503          	ld	a0,-56(s0)
    8000514c:	fffff097          	auipc	ra,0xfffff
    80005150:	9ca080e7          	jalr	-1590(ra) # 80003b16 <fileclose>
    return -1;
    80005154:	57fd                	li	a5,-1
}
    80005156:	853e                	mv	a0,a5
    80005158:	70e2                	ld	ra,56(sp)
    8000515a:	7442                	ld	s0,48(sp)
    8000515c:	74a2                	ld	s1,40(sp)
    8000515e:	6121                	addi	sp,sp,64
    80005160:	8082                	ret
	...

0000000080005170 <kernelvec>:
    80005170:	7111                	addi	sp,sp,-256
    80005172:	e006                	sd	ra,0(sp)
    80005174:	e40a                	sd	sp,8(sp)
    80005176:	e80e                	sd	gp,16(sp)
    80005178:	ec12                	sd	tp,24(sp)
    8000517a:	f016                	sd	t0,32(sp)
    8000517c:	f41a                	sd	t1,40(sp)
    8000517e:	f81e                	sd	t2,48(sp)
    80005180:	fc22                	sd	s0,56(sp)
    80005182:	e0a6                	sd	s1,64(sp)
    80005184:	e4aa                	sd	a0,72(sp)
    80005186:	e8ae                	sd	a1,80(sp)
    80005188:	ecb2                	sd	a2,88(sp)
    8000518a:	f0b6                	sd	a3,96(sp)
    8000518c:	f4ba                	sd	a4,104(sp)
    8000518e:	f8be                	sd	a5,112(sp)
    80005190:	fcc2                	sd	a6,120(sp)
    80005192:	e146                	sd	a7,128(sp)
    80005194:	e54a                	sd	s2,136(sp)
    80005196:	e94e                	sd	s3,144(sp)
    80005198:	ed52                	sd	s4,152(sp)
    8000519a:	f156                	sd	s5,160(sp)
    8000519c:	f55a                	sd	s6,168(sp)
    8000519e:	f95e                	sd	s7,176(sp)
    800051a0:	fd62                	sd	s8,184(sp)
    800051a2:	e1e6                	sd	s9,192(sp)
    800051a4:	e5ea                	sd	s10,200(sp)
    800051a6:	e9ee                	sd	s11,208(sp)
    800051a8:	edf2                	sd	t3,216(sp)
    800051aa:	f1f6                	sd	t4,224(sp)
    800051ac:	f5fa                	sd	t5,232(sp)
    800051ae:	f9fe                	sd	t6,240(sp)
    800051b0:	cc5fc0ef          	jal	ra,80001e74 <kerneltrap>
    800051b4:	6082                	ld	ra,0(sp)
    800051b6:	6122                	ld	sp,8(sp)
    800051b8:	61c2                	ld	gp,16(sp)
    800051ba:	7282                	ld	t0,32(sp)
    800051bc:	7322                	ld	t1,40(sp)
    800051be:	73c2                	ld	t2,48(sp)
    800051c0:	7462                	ld	s0,56(sp)
    800051c2:	6486                	ld	s1,64(sp)
    800051c4:	6526                	ld	a0,72(sp)
    800051c6:	65c6                	ld	a1,80(sp)
    800051c8:	6666                	ld	a2,88(sp)
    800051ca:	7686                	ld	a3,96(sp)
    800051cc:	7726                	ld	a4,104(sp)
    800051ce:	77c6                	ld	a5,112(sp)
    800051d0:	7866                	ld	a6,120(sp)
    800051d2:	688a                	ld	a7,128(sp)
    800051d4:	692a                	ld	s2,136(sp)
    800051d6:	69ca                	ld	s3,144(sp)
    800051d8:	6a6a                	ld	s4,152(sp)
    800051da:	7a8a                	ld	s5,160(sp)
    800051dc:	7b2a                	ld	s6,168(sp)
    800051de:	7bca                	ld	s7,176(sp)
    800051e0:	7c6a                	ld	s8,184(sp)
    800051e2:	6c8e                	ld	s9,192(sp)
    800051e4:	6d2e                	ld	s10,200(sp)
    800051e6:	6dce                	ld	s11,208(sp)
    800051e8:	6e6e                	ld	t3,216(sp)
    800051ea:	7e8e                	ld	t4,224(sp)
    800051ec:	7f2e                	ld	t5,232(sp)
    800051ee:	7fce                	ld	t6,240(sp)
    800051f0:	6111                	addi	sp,sp,256
    800051f2:	10200073          	sret
    800051f6:	00000013          	nop
    800051fa:	00000013          	nop
    800051fe:	0001                	nop

0000000080005200 <timervec>:
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	e10c                	sd	a1,0(a0)
    80005206:	e510                	sd	a2,8(a0)
    80005208:	e914                	sd	a3,16(a0)
    8000520a:	6d0c                	ld	a1,24(a0)
    8000520c:	7110                	ld	a2,32(a0)
    8000520e:	6194                	ld	a3,0(a1)
    80005210:	96b2                	add	a3,a3,a2
    80005212:	e194                	sd	a3,0(a1)
    80005214:	4589                	li	a1,2
    80005216:	14459073          	csrw	sip,a1
    8000521a:	6914                	ld	a3,16(a0)
    8000521c:	6510                	ld	a2,8(a0)
    8000521e:	610c                	ld	a1,0(a0)
    80005220:	34051573          	csrrw	a0,mscratch,a0
    80005224:	30200073          	mret
	...

000000008000522a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000522a:	1141                	addi	sp,sp,-16
    8000522c:	e422                	sd	s0,8(sp)
    8000522e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005230:	0c0007b7          	lui	a5,0xc000
    80005234:	4705                	li	a4,1
    80005236:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005238:	c3d8                	sw	a4,4(a5)
}
    8000523a:	6422                	ld	s0,8(sp)
    8000523c:	0141                	addi	sp,sp,16
    8000523e:	8082                	ret

0000000080005240 <plicinithart>:

void
plicinithart(void)
{
    80005240:	1141                	addi	sp,sp,-16
    80005242:	e406                	sd	ra,8(sp)
    80005244:	e022                	sd	s0,0(sp)
    80005246:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	c2e080e7          	jalr	-978(ra) # 80000e76 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005250:	0085171b          	slliw	a4,a0,0x8
    80005254:	0c0027b7          	lui	a5,0xc002
    80005258:	97ba                	add	a5,a5,a4
    8000525a:	40200713          	li	a4,1026
    8000525e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005262:	00d5151b          	slliw	a0,a0,0xd
    80005266:	0c2017b7          	lui	a5,0xc201
    8000526a:	97aa                	add	a5,a5,a0
    8000526c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret

0000000080005278 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005278:	1141                	addi	sp,sp,-16
    8000527a:	e406                	sd	ra,8(sp)
    8000527c:	e022                	sd	s0,0(sp)
    8000527e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005280:	ffffc097          	auipc	ra,0xffffc
    80005284:	bf6080e7          	jalr	-1034(ra) # 80000e76 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005288:	00d5151b          	slliw	a0,a0,0xd
    8000528c:	0c2017b7          	lui	a5,0xc201
    80005290:	97aa                	add	a5,a5,a0
  return irq;
}
    80005292:	43c8                	lw	a0,4(a5)
    80005294:	60a2                	ld	ra,8(sp)
    80005296:	6402                	ld	s0,0(sp)
    80005298:	0141                	addi	sp,sp,16
    8000529a:	8082                	ret

000000008000529c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000529c:	1101                	addi	sp,sp,-32
    8000529e:	ec06                	sd	ra,24(sp)
    800052a0:	e822                	sd	s0,16(sp)
    800052a2:	e426                	sd	s1,8(sp)
    800052a4:	1000                	addi	s0,sp,32
    800052a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	bce080e7          	jalr	-1074(ra) # 80000e76 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052b0:	00d5151b          	slliw	a0,a0,0xd
    800052b4:	0c2017b7          	lui	a5,0xc201
    800052b8:	97aa                	add	a5,a5,a0
    800052ba:	c3c4                	sw	s1,4(a5)
}
    800052bc:	60e2                	ld	ra,24(sp)
    800052be:	6442                	ld	s0,16(sp)
    800052c0:	64a2                	ld	s1,8(sp)
    800052c2:	6105                	addi	sp,sp,32
    800052c4:	8082                	ret

00000000800052c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052c6:	1141                	addi	sp,sp,-16
    800052c8:	e406                	sd	ra,8(sp)
    800052ca:	e022                	sd	s0,0(sp)
    800052cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ce:	479d                	li	a5,7
    800052d0:	04a7cc63          	blt	a5,a0,80005328 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052d4:	00015797          	auipc	a5,0x15
    800052d8:	b4c78793          	addi	a5,a5,-1204 # 80019e20 <disk>
    800052dc:	97aa                	add	a5,a5,a0
    800052de:	0187c783          	lbu	a5,24(a5)
    800052e2:	ebb9                	bnez	a5,80005338 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052e4:	00451693          	slli	a3,a0,0x4
    800052e8:	00015797          	auipc	a5,0x15
    800052ec:	b3878793          	addi	a5,a5,-1224 # 80019e20 <disk>
    800052f0:	6398                	ld	a4,0(a5)
    800052f2:	9736                	add	a4,a4,a3
    800052f4:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800052f8:	6398                	ld	a4,0(a5)
    800052fa:	9736                	add	a4,a4,a3
    800052fc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005300:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005304:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005308:	97aa                	add	a5,a5,a0
    8000530a:	4705                	li	a4,1
    8000530c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005310:	00015517          	auipc	a0,0x15
    80005314:	b2850513          	addi	a0,a0,-1240 # 80019e38 <disk+0x18>
    80005318:	ffffc097          	auipc	ra,0xffffc
    8000531c:	2cc080e7          	jalr	716(ra) # 800015e4 <wakeup>
}
    80005320:	60a2                	ld	ra,8(sp)
    80005322:	6402                	ld	s0,0(sp)
    80005324:	0141                	addi	sp,sp,16
    80005326:	8082                	ret
    panic("free_desc 1");
    80005328:	00003517          	auipc	a0,0x3
    8000532c:	5e050513          	addi	a0,a0,1504 # 80008908 <syscalls_name+0x2f8>
    80005330:	00001097          	auipc	ra,0x1
    80005334:	a0c080e7          	jalr	-1524(ra) # 80005d3c <panic>
    panic("free_desc 2");
    80005338:	00003517          	auipc	a0,0x3
    8000533c:	5e050513          	addi	a0,a0,1504 # 80008918 <syscalls_name+0x308>
    80005340:	00001097          	auipc	ra,0x1
    80005344:	9fc080e7          	jalr	-1540(ra) # 80005d3c <panic>

0000000080005348 <virtio_disk_init>:
{
    80005348:	1101                	addi	sp,sp,-32
    8000534a:	ec06                	sd	ra,24(sp)
    8000534c:	e822                	sd	s0,16(sp)
    8000534e:	e426                	sd	s1,8(sp)
    80005350:	e04a                	sd	s2,0(sp)
    80005352:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005354:	00003597          	auipc	a1,0x3
    80005358:	5d458593          	addi	a1,a1,1492 # 80008928 <syscalls_name+0x318>
    8000535c:	00015517          	auipc	a0,0x15
    80005360:	bec50513          	addi	a0,a0,-1044 # 80019f48 <disk+0x128>
    80005364:	00001097          	auipc	ra,0x1
    80005368:	e80080e7          	jalr	-384(ra) # 800061e4 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000536c:	100017b7          	lui	a5,0x10001
    80005370:	4398                	lw	a4,0(a5)
    80005372:	2701                	sext.w	a4,a4
    80005374:	747277b7          	lui	a5,0x74727
    80005378:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000537c:	14f71b63          	bne	a4,a5,800054d2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005380:	100017b7          	lui	a5,0x10001
    80005384:	43dc                	lw	a5,4(a5)
    80005386:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005388:	4709                	li	a4,2
    8000538a:	14e79463          	bne	a5,a4,800054d2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000538e:	100017b7          	lui	a5,0x10001
    80005392:	479c                	lw	a5,8(a5)
    80005394:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005396:	12e79e63          	bne	a5,a4,800054d2 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000539a:	100017b7          	lui	a5,0x10001
    8000539e:	47d8                	lw	a4,12(a5)
    800053a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053a2:	554d47b7          	lui	a5,0x554d4
    800053a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800053aa:	12f71463          	bne	a4,a5,800054d2 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ae:	100017b7          	lui	a5,0x10001
    800053b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800053b6:	4705                	li	a4,1
    800053b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ba:	470d                	li	a4,3
    800053bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800053be:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053c0:	c7ffe6b7          	lui	a3,0xc7ffe
    800053c4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc5bf>
    800053c8:	8f75                	and	a4,a4,a3
    800053ca:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053cc:	472d                	li	a4,11
    800053ce:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053d0:	5bbc                	lw	a5,112(a5)
    800053d2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053d6:	8ba1                	andi	a5,a5,8
    800053d8:	10078563          	beqz	a5,800054e2 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053dc:	100017b7          	lui	a5,0x10001
    800053e0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053e4:	43fc                	lw	a5,68(a5)
    800053e6:	2781                	sext.w	a5,a5
    800053e8:	10079563          	bnez	a5,800054f2 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053ec:	100017b7          	lui	a5,0x10001
    800053f0:	5bdc                	lw	a5,52(a5)
    800053f2:	2781                	sext.w	a5,a5
  if(max == 0)
    800053f4:	10078763          	beqz	a5,80005502 <virtio_disk_init+0x1ba>
  if(max < NUM)
    800053f8:	471d                	li	a4,7
    800053fa:	10f77c63          	bgeu	a4,a5,80005512 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	d1c080e7          	jalr	-740(ra) # 8000011a <kalloc>
    80005406:	00015497          	auipc	s1,0x15
    8000540a:	a1a48493          	addi	s1,s1,-1510 # 80019e20 <disk>
    8000540e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005410:	ffffb097          	auipc	ra,0xffffb
    80005414:	d0a080e7          	jalr	-758(ra) # 8000011a <kalloc>
    80005418:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000541a:	ffffb097          	auipc	ra,0xffffb
    8000541e:	d00080e7          	jalr	-768(ra) # 8000011a <kalloc>
    80005422:	87aa                	mv	a5,a0
    80005424:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005426:	6088                	ld	a0,0(s1)
    80005428:	cd6d                	beqz	a0,80005522 <virtio_disk_init+0x1da>
    8000542a:	00015717          	auipc	a4,0x15
    8000542e:	9fe73703          	ld	a4,-1538(a4) # 80019e28 <disk+0x8>
    80005432:	cb65                	beqz	a4,80005522 <virtio_disk_init+0x1da>
    80005434:	c7fd                	beqz	a5,80005522 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005436:	6605                	lui	a2,0x1
    80005438:	4581                	li	a1,0
    8000543a:	ffffb097          	auipc	ra,0xffffb
    8000543e:	d8c080e7          	jalr	-628(ra) # 800001c6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005442:	00015497          	auipc	s1,0x15
    80005446:	9de48493          	addi	s1,s1,-1570 # 80019e20 <disk>
    8000544a:	6605                	lui	a2,0x1
    8000544c:	4581                	li	a1,0
    8000544e:	6488                	ld	a0,8(s1)
    80005450:	ffffb097          	auipc	ra,0xffffb
    80005454:	d76080e7          	jalr	-650(ra) # 800001c6 <memset>
  memset(disk.used, 0, PGSIZE);
    80005458:	6605                	lui	a2,0x1
    8000545a:	4581                	li	a1,0
    8000545c:	6888                	ld	a0,16(s1)
    8000545e:	ffffb097          	auipc	ra,0xffffb
    80005462:	d68080e7          	jalr	-664(ra) # 800001c6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005466:	100017b7          	lui	a5,0x10001
    8000546a:	4721                	li	a4,8
    8000546c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000546e:	4098                	lw	a4,0(s1)
    80005470:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005474:	40d8                	lw	a4,4(s1)
    80005476:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000547a:	6498                	ld	a4,8(s1)
    8000547c:	0007069b          	sext.w	a3,a4
    80005480:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005484:	9701                	srai	a4,a4,0x20
    80005486:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000548a:	6898                	ld	a4,16(s1)
    8000548c:	0007069b          	sext.w	a3,a4
    80005490:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005494:	9701                	srai	a4,a4,0x20
    80005496:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000549a:	4705                	li	a4,1
    8000549c:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    8000549e:	00e48c23          	sb	a4,24(s1)
    800054a2:	00e48ca3          	sb	a4,25(s1)
    800054a6:	00e48d23          	sb	a4,26(s1)
    800054aa:	00e48da3          	sb	a4,27(s1)
    800054ae:	00e48e23          	sb	a4,28(s1)
    800054b2:	00e48ea3          	sb	a4,29(s1)
    800054b6:	00e48f23          	sb	a4,30(s1)
    800054ba:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054be:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054c2:	0727a823          	sw	s2,112(a5)
}
    800054c6:	60e2                	ld	ra,24(sp)
    800054c8:	6442                	ld	s0,16(sp)
    800054ca:	64a2                	ld	s1,8(sp)
    800054cc:	6902                	ld	s2,0(sp)
    800054ce:	6105                	addi	sp,sp,32
    800054d0:	8082                	ret
    panic("could not find virtio disk");
    800054d2:	00003517          	auipc	a0,0x3
    800054d6:	46650513          	addi	a0,a0,1126 # 80008938 <syscalls_name+0x328>
    800054da:	00001097          	auipc	ra,0x1
    800054de:	862080e7          	jalr	-1950(ra) # 80005d3c <panic>
    panic("virtio disk FEATURES_OK unset");
    800054e2:	00003517          	auipc	a0,0x3
    800054e6:	47650513          	addi	a0,a0,1142 # 80008958 <syscalls_name+0x348>
    800054ea:	00001097          	auipc	ra,0x1
    800054ee:	852080e7          	jalr	-1966(ra) # 80005d3c <panic>
    panic("virtio disk should not be ready");
    800054f2:	00003517          	auipc	a0,0x3
    800054f6:	48650513          	addi	a0,a0,1158 # 80008978 <syscalls_name+0x368>
    800054fa:	00001097          	auipc	ra,0x1
    800054fe:	842080e7          	jalr	-1982(ra) # 80005d3c <panic>
    panic("virtio disk has no queue 0");
    80005502:	00003517          	auipc	a0,0x3
    80005506:	49650513          	addi	a0,a0,1174 # 80008998 <syscalls_name+0x388>
    8000550a:	00001097          	auipc	ra,0x1
    8000550e:	832080e7          	jalr	-1998(ra) # 80005d3c <panic>
    panic("virtio disk max queue too short");
    80005512:	00003517          	auipc	a0,0x3
    80005516:	4a650513          	addi	a0,a0,1190 # 800089b8 <syscalls_name+0x3a8>
    8000551a:	00001097          	auipc	ra,0x1
    8000551e:	822080e7          	jalr	-2014(ra) # 80005d3c <panic>
    panic("virtio disk kalloc");
    80005522:	00003517          	auipc	a0,0x3
    80005526:	4b650513          	addi	a0,a0,1206 # 800089d8 <syscalls_name+0x3c8>
    8000552a:	00001097          	auipc	ra,0x1
    8000552e:	812080e7          	jalr	-2030(ra) # 80005d3c <panic>

0000000080005532 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005532:	7119                	addi	sp,sp,-128
    80005534:	fc86                	sd	ra,120(sp)
    80005536:	f8a2                	sd	s0,112(sp)
    80005538:	f4a6                	sd	s1,104(sp)
    8000553a:	f0ca                	sd	s2,96(sp)
    8000553c:	ecce                	sd	s3,88(sp)
    8000553e:	e8d2                	sd	s4,80(sp)
    80005540:	e4d6                	sd	s5,72(sp)
    80005542:	e0da                	sd	s6,64(sp)
    80005544:	fc5e                	sd	s7,56(sp)
    80005546:	f862                	sd	s8,48(sp)
    80005548:	f466                	sd	s9,40(sp)
    8000554a:	f06a                	sd	s10,32(sp)
    8000554c:	ec6e                	sd	s11,24(sp)
    8000554e:	0100                	addi	s0,sp,128
    80005550:	8aaa                	mv	s5,a0
    80005552:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005554:	00c52d03          	lw	s10,12(a0)
    80005558:	001d1d1b          	slliw	s10,s10,0x1
    8000555c:	1d02                	slli	s10,s10,0x20
    8000555e:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80005562:	00015517          	auipc	a0,0x15
    80005566:	9e650513          	addi	a0,a0,-1562 # 80019f48 <disk+0x128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	d0a080e7          	jalr	-758(ra) # 80006274 <acquire>
  for(int i = 0; i < 3; i++){
    80005572:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005574:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005576:	00015b97          	auipc	s7,0x15
    8000557a:	8aab8b93          	addi	s7,s7,-1878 # 80019e20 <disk>
  for(int i = 0; i < 3; i++){
    8000557e:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005580:	00015c97          	auipc	s9,0x15
    80005584:	9c8c8c93          	addi	s9,s9,-1592 # 80019f48 <disk+0x128>
    80005588:	a08d                	j	800055ea <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000558a:	00fb8733          	add	a4,s7,a5
    8000558e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005592:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005594:	0207c563          	bltz	a5,800055be <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    80005598:	2905                	addiw	s2,s2,1
    8000559a:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000559c:	05690c63          	beq	s2,s6,800055f4 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800055a0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800055a2:	00015717          	auipc	a4,0x15
    800055a6:	87e70713          	addi	a4,a4,-1922 # 80019e20 <disk>
    800055aa:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800055ac:	01874683          	lbu	a3,24(a4)
    800055b0:	fee9                	bnez	a3,8000558a <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800055b2:	2785                	addiw	a5,a5,1
    800055b4:	0705                	addi	a4,a4,1
    800055b6:	fe979be3          	bne	a5,s1,800055ac <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055ba:	57fd                	li	a5,-1
    800055bc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800055be:	01205d63          	blez	s2,800055d8 <virtio_disk_rw+0xa6>
    800055c2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800055c4:	000a2503          	lw	a0,0(s4)
    800055c8:	00000097          	auipc	ra,0x0
    800055cc:	cfe080e7          	jalr	-770(ra) # 800052c6 <free_desc>
      for(int j = 0; j < i; j++)
    800055d0:	2d85                	addiw	s11,s11,1
    800055d2:	0a11                	addi	s4,s4,4
    800055d4:	ff2d98e3          	bne	s11,s2,800055c4 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d8:	85e6                	mv	a1,s9
    800055da:	00015517          	auipc	a0,0x15
    800055de:	85e50513          	addi	a0,a0,-1954 # 80019e38 <disk+0x18>
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	f94080e7          	jalr	-108(ra) # 80001576 <sleep>
  for(int i = 0; i < 3; i++){
    800055ea:	f8040a13          	addi	s4,s0,-128
{
    800055ee:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    800055f0:	894e                	mv	s2,s3
    800055f2:	b77d                	j	800055a0 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055f4:	f8042503          	lw	a0,-128(s0)
    800055f8:	00a50713          	addi	a4,a0,10
    800055fc:	0712                	slli	a4,a4,0x4

  if(write)
    800055fe:	00015797          	auipc	a5,0x15
    80005602:	82278793          	addi	a5,a5,-2014 # 80019e20 <disk>
    80005606:	00e786b3          	add	a3,a5,a4
    8000560a:	01803633          	snez	a2,s8
    8000560e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005610:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005614:	01a6b823          	sd	s10,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005618:	f6070613          	addi	a2,a4,-160
    8000561c:	6394                	ld	a3,0(a5)
    8000561e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005620:	00870593          	addi	a1,a4,8
    80005624:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005626:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005628:	0007b803          	ld	a6,0(a5)
    8000562c:	9642                	add	a2,a2,a6
    8000562e:	46c1                	li	a3,16
    80005630:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005632:	4585                	li	a1,1
    80005634:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f8442683          	lw	a3,-124(s0)
    8000563c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005640:	0692                	slli	a3,a3,0x4
    80005642:	9836                	add	a6,a6,a3
    80005644:	058a8613          	addi	a2,s5,88
    80005648:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000564c:	0007b803          	ld	a6,0(a5)
    80005650:	96c2                	add	a3,a3,a6
    80005652:	40000613          	li	a2,1024
    80005656:	c690                	sw	a2,8(a3)
  if(write)
    80005658:	001c3613          	seqz	a2,s8
    8000565c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005660:	00166613          	ori	a2,a2,1
    80005664:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005668:	f8842603          	lw	a2,-120(s0)
    8000566c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005670:	00250693          	addi	a3,a0,2
    80005674:	0692                	slli	a3,a3,0x4
    80005676:	96be                	add	a3,a3,a5
    80005678:	58fd                	li	a7,-1
    8000567a:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000567e:	0612                	slli	a2,a2,0x4
    80005680:	9832                	add	a6,a6,a2
    80005682:	f9070713          	addi	a4,a4,-112
    80005686:	973e                	add	a4,a4,a5
    80005688:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    8000568c:	6398                	ld	a4,0(a5)
    8000568e:	9732                	add	a4,a4,a2
    80005690:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005692:	4609                	li	a2,2
    80005694:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    80005698:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000569c:	00baa223          	sw	a1,4(s5)
  disk.info[idx[0]].b = b;
    800056a0:	0156b423          	sd	s5,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056a4:	6794                	ld	a3,8(a5)
    800056a6:	0026d703          	lhu	a4,2(a3)
    800056aa:	8b1d                	andi	a4,a4,7
    800056ac:	0706                	slli	a4,a4,0x1
    800056ae:	96ba                	add	a3,a3,a4
    800056b0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800056b4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056b8:	6798                	ld	a4,8(a5)
    800056ba:	00275783          	lhu	a5,2(a4)
    800056be:	2785                	addiw	a5,a5,1
    800056c0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056c4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056c8:	100017b7          	lui	a5,0x10001
    800056cc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056d0:	004aa783          	lw	a5,4(s5)
    sleep(b, &disk.vdisk_lock);
    800056d4:	00015917          	auipc	s2,0x15
    800056d8:	87490913          	addi	s2,s2,-1932 # 80019f48 <disk+0x128>
  while(b->disk == 1) {
    800056dc:	4485                	li	s1,1
    800056de:	00b79c63          	bne	a5,a1,800056f6 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    800056e2:	85ca                	mv	a1,s2
    800056e4:	8556                	mv	a0,s5
    800056e6:	ffffc097          	auipc	ra,0xffffc
    800056ea:	e90080e7          	jalr	-368(ra) # 80001576 <sleep>
  while(b->disk == 1) {
    800056ee:	004aa783          	lw	a5,4(s5)
    800056f2:	fe9788e3          	beq	a5,s1,800056e2 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800056f6:	f8042903          	lw	s2,-128(s0)
    800056fa:	00290713          	addi	a4,s2,2
    800056fe:	0712                	slli	a4,a4,0x4
    80005700:	00014797          	auipc	a5,0x14
    80005704:	72078793          	addi	a5,a5,1824 # 80019e20 <disk>
    80005708:	97ba                	add	a5,a5,a4
    8000570a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000570e:	00014997          	auipc	s3,0x14
    80005712:	71298993          	addi	s3,s3,1810 # 80019e20 <disk>
    80005716:	00491713          	slli	a4,s2,0x4
    8000571a:	0009b783          	ld	a5,0(s3)
    8000571e:	97ba                	add	a5,a5,a4
    80005720:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005724:	854a                	mv	a0,s2
    80005726:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000572a:	00000097          	auipc	ra,0x0
    8000572e:	b9c080e7          	jalr	-1124(ra) # 800052c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005732:	8885                	andi	s1,s1,1
    80005734:	f0ed                	bnez	s1,80005716 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005736:	00015517          	auipc	a0,0x15
    8000573a:	81250513          	addi	a0,a0,-2030 # 80019f48 <disk+0x128>
    8000573e:	00001097          	auipc	ra,0x1
    80005742:	bea080e7          	jalr	-1046(ra) # 80006328 <release>
}
    80005746:	70e6                	ld	ra,120(sp)
    80005748:	7446                	ld	s0,112(sp)
    8000574a:	74a6                	ld	s1,104(sp)
    8000574c:	7906                	ld	s2,96(sp)
    8000574e:	69e6                	ld	s3,88(sp)
    80005750:	6a46                	ld	s4,80(sp)
    80005752:	6aa6                	ld	s5,72(sp)
    80005754:	6b06                	ld	s6,64(sp)
    80005756:	7be2                	ld	s7,56(sp)
    80005758:	7c42                	ld	s8,48(sp)
    8000575a:	7ca2                	ld	s9,40(sp)
    8000575c:	7d02                	ld	s10,32(sp)
    8000575e:	6de2                	ld	s11,24(sp)
    80005760:	6109                	addi	sp,sp,128
    80005762:	8082                	ret

0000000080005764 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005764:	1101                	addi	sp,sp,-32
    80005766:	ec06                	sd	ra,24(sp)
    80005768:	e822                	sd	s0,16(sp)
    8000576a:	e426                	sd	s1,8(sp)
    8000576c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000576e:	00014497          	auipc	s1,0x14
    80005772:	6b248493          	addi	s1,s1,1714 # 80019e20 <disk>
    80005776:	00014517          	auipc	a0,0x14
    8000577a:	7d250513          	addi	a0,a0,2002 # 80019f48 <disk+0x128>
    8000577e:	00001097          	auipc	ra,0x1
    80005782:	af6080e7          	jalr	-1290(ra) # 80006274 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005786:	10001737          	lui	a4,0x10001
    8000578a:	533c                	lw	a5,96(a4)
    8000578c:	8b8d                	andi	a5,a5,3
    8000578e:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005790:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005794:	689c                	ld	a5,16(s1)
    80005796:	0204d703          	lhu	a4,32(s1)
    8000579a:	0027d783          	lhu	a5,2(a5)
    8000579e:	04f70863          	beq	a4,a5,800057ee <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057a2:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057a6:	6898                	ld	a4,16(s1)
    800057a8:	0204d783          	lhu	a5,32(s1)
    800057ac:	8b9d                	andi	a5,a5,7
    800057ae:	078e                	slli	a5,a5,0x3
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057b4:	00278713          	addi	a4,a5,2
    800057b8:	0712                	slli	a4,a4,0x4
    800057ba:	9726                	add	a4,a4,s1
    800057bc:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800057c0:	e721                	bnez	a4,80005808 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057c2:	0789                	addi	a5,a5,2
    800057c4:	0792                	slli	a5,a5,0x4
    800057c6:	97a6                	add	a5,a5,s1
    800057c8:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800057ca:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057ce:	ffffc097          	auipc	ra,0xffffc
    800057d2:	e16080e7          	jalr	-490(ra) # 800015e4 <wakeup>

    disk.used_idx += 1;
    800057d6:	0204d783          	lhu	a5,32(s1)
    800057da:	2785                	addiw	a5,a5,1
    800057dc:	17c2                	slli	a5,a5,0x30
    800057de:	93c1                	srli	a5,a5,0x30
    800057e0:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800057e4:	6898                	ld	a4,16(s1)
    800057e6:	00275703          	lhu	a4,2(a4)
    800057ea:	faf71ce3          	bne	a4,a5,800057a2 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057ee:	00014517          	auipc	a0,0x14
    800057f2:	75a50513          	addi	a0,a0,1882 # 80019f48 <disk+0x128>
    800057f6:	00001097          	auipc	ra,0x1
    800057fa:	b32080e7          	jalr	-1230(ra) # 80006328 <release>
}
    800057fe:	60e2                	ld	ra,24(sp)
    80005800:	6442                	ld	s0,16(sp)
    80005802:	64a2                	ld	s1,8(sp)
    80005804:	6105                	addi	sp,sp,32
    80005806:	8082                	ret
      panic("virtio_disk_intr status");
    80005808:	00003517          	auipc	a0,0x3
    8000580c:	1e850513          	addi	a0,a0,488 # 800089f0 <syscalls_name+0x3e0>
    80005810:	00000097          	auipc	ra,0x0
    80005814:	52c080e7          	jalr	1324(ra) # 80005d3c <panic>

0000000080005818 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005818:	1141                	addi	sp,sp,-16
    8000581a:	e422                	sd	s0,8(sp)
    8000581c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000581e:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005822:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005826:	0037979b          	slliw	a5,a5,0x3
    8000582a:	02004737          	lui	a4,0x2004
    8000582e:	97ba                	add	a5,a5,a4
    80005830:	0200c737          	lui	a4,0x200c
    80005834:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005838:	000f4637          	lui	a2,0xf4
    8000583c:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005840:	9732                	add	a4,a4,a2
    80005842:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005844:	00259693          	slli	a3,a1,0x2
    80005848:	96ae                	add	a3,a3,a1
    8000584a:	068e                	slli	a3,a3,0x3
    8000584c:	00014717          	auipc	a4,0x14
    80005850:	71470713          	addi	a4,a4,1812 # 80019f60 <timer_scratch>
    80005854:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005856:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005858:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000585a:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000585e:	00000797          	auipc	a5,0x0
    80005862:	9a278793          	addi	a5,a5,-1630 # 80005200 <timervec>
    80005866:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000586a:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000586e:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005872:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005876:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000587a:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000587e:	30479073          	csrw	mie,a5
}
    80005882:	6422                	ld	s0,8(sp)
    80005884:	0141                	addi	sp,sp,16
    80005886:	8082                	ret

0000000080005888 <start>:
{
    80005888:	1141                	addi	sp,sp,-16
    8000588a:	e406                	sd	ra,8(sp)
    8000588c:	e022                	sd	s0,0(sp)
    8000588e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005890:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005894:	7779                	lui	a4,0xffffe
    80005896:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc65f>
    8000589a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000589c:	6705                	lui	a4,0x1
    8000589e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058a2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058a4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058a8:	ffffb797          	auipc	a5,0xffffb
    800058ac:	ac478793          	addi	a5,a5,-1340 # 8000036c <main>
    800058b0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058b4:	4781                	li	a5,0
    800058b6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058ba:	67c1                	lui	a5,0x10
    800058bc:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058be:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058c2:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058c6:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058ca:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058ce:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800058d2:	57fd                	li	a5,-1
    800058d4:	83a9                	srli	a5,a5,0xa
    800058d6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800058da:	47bd                	li	a5,15
    800058dc:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800058e0:	00000097          	auipc	ra,0x0
    800058e4:	f38080e7          	jalr	-200(ra) # 80005818 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800058e8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058ec:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058ee:	823e                	mv	tp,a5
  asm volatile("mret");
    800058f0:	30200073          	mret
}
    800058f4:	60a2                	ld	ra,8(sp)
    800058f6:	6402                	ld	s0,0(sp)
    800058f8:	0141                	addi	sp,sp,16
    800058fa:	8082                	ret

00000000800058fc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058fc:	715d                	addi	sp,sp,-80
    800058fe:	e486                	sd	ra,72(sp)
    80005900:	e0a2                	sd	s0,64(sp)
    80005902:	fc26                	sd	s1,56(sp)
    80005904:	f84a                	sd	s2,48(sp)
    80005906:	f44e                	sd	s3,40(sp)
    80005908:	f052                	sd	s4,32(sp)
    8000590a:	ec56                	sd	s5,24(sp)
    8000590c:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000590e:	04c05763          	blez	a2,8000595c <consolewrite+0x60>
    80005912:	8a2a                	mv	s4,a0
    80005914:	84ae                	mv	s1,a1
    80005916:	89b2                	mv	s3,a2
    80005918:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000591a:	5afd                	li	s5,-1
    8000591c:	4685                	li	a3,1
    8000591e:	8626                	mv	a2,s1
    80005920:	85d2                	mv	a1,s4
    80005922:	fbf40513          	addi	a0,s0,-65
    80005926:	ffffc097          	auipc	ra,0xffffc
    8000592a:	0e0080e7          	jalr	224(ra) # 80001a06 <either_copyin>
    8000592e:	01550d63          	beq	a0,s5,80005948 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005932:	fbf44503          	lbu	a0,-65(s0)
    80005936:	00000097          	auipc	ra,0x0
    8000593a:	784080e7          	jalr	1924(ra) # 800060ba <uartputc>
  for(i = 0; i < n; i++){
    8000593e:	2905                	addiw	s2,s2,1
    80005940:	0485                	addi	s1,s1,1
    80005942:	fd299de3          	bne	s3,s2,8000591c <consolewrite+0x20>
    80005946:	894e                	mv	s2,s3
  }

  return i;
}
    80005948:	854a                	mv	a0,s2
    8000594a:	60a6                	ld	ra,72(sp)
    8000594c:	6406                	ld	s0,64(sp)
    8000594e:	74e2                	ld	s1,56(sp)
    80005950:	7942                	ld	s2,48(sp)
    80005952:	79a2                	ld	s3,40(sp)
    80005954:	7a02                	ld	s4,32(sp)
    80005956:	6ae2                	ld	s5,24(sp)
    80005958:	6161                	addi	sp,sp,80
    8000595a:	8082                	ret
  for(i = 0; i < n; i++){
    8000595c:	4901                	li	s2,0
    8000595e:	b7ed                	j	80005948 <consolewrite+0x4c>

0000000080005960 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005960:	7159                	addi	sp,sp,-112
    80005962:	f486                	sd	ra,104(sp)
    80005964:	f0a2                	sd	s0,96(sp)
    80005966:	eca6                	sd	s1,88(sp)
    80005968:	e8ca                	sd	s2,80(sp)
    8000596a:	e4ce                	sd	s3,72(sp)
    8000596c:	e0d2                	sd	s4,64(sp)
    8000596e:	fc56                	sd	s5,56(sp)
    80005970:	f85a                	sd	s6,48(sp)
    80005972:	f45e                	sd	s7,40(sp)
    80005974:	f062                	sd	s8,32(sp)
    80005976:	ec66                	sd	s9,24(sp)
    80005978:	e86a                	sd	s10,16(sp)
    8000597a:	1880                	addi	s0,sp,112
    8000597c:	8aaa                	mv	s5,a0
    8000597e:	8a2e                	mv	s4,a1
    80005980:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005982:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005986:	0001c517          	auipc	a0,0x1c
    8000598a:	71a50513          	addi	a0,a0,1818 # 800220a0 <cons>
    8000598e:	00001097          	auipc	ra,0x1
    80005992:	8e6080e7          	jalr	-1818(ra) # 80006274 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005996:	0001c497          	auipc	s1,0x1c
    8000599a:	70a48493          	addi	s1,s1,1802 # 800220a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000599e:	0001c917          	auipc	s2,0x1c
    800059a2:	79a90913          	addi	s2,s2,1946 # 80022138 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059a6:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059a8:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059aa:	4ca9                	li	s9,10
  while(n > 0){
    800059ac:	07305b63          	blez	s3,80005a22 <consoleread+0xc2>
    while(cons.r == cons.w){
    800059b0:	0984a783          	lw	a5,152(s1)
    800059b4:	09c4a703          	lw	a4,156(s1)
    800059b8:	02f71763          	bne	a4,a5,800059e6 <consoleread+0x86>
      if(killed(myproc())){
    800059bc:	ffffb097          	auipc	ra,0xffffb
    800059c0:	4e6080e7          	jalr	1254(ra) # 80000ea2 <myproc>
    800059c4:	ffffc097          	auipc	ra,0xffffc
    800059c8:	e80080e7          	jalr	-384(ra) # 80001844 <killed>
    800059cc:	e535                	bnez	a0,80005a38 <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800059ce:	85a6                	mv	a1,s1
    800059d0:	854a                	mv	a0,s2
    800059d2:	ffffc097          	auipc	ra,0xffffc
    800059d6:	ba4080e7          	jalr	-1116(ra) # 80001576 <sleep>
    while(cons.r == cons.w){
    800059da:	0984a783          	lw	a5,152(s1)
    800059de:	09c4a703          	lw	a4,156(s1)
    800059e2:	fcf70de3          	beq	a4,a5,800059bc <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800059e6:	0017871b          	addiw	a4,a5,1
    800059ea:	08e4ac23          	sw	a4,152(s1)
    800059ee:	07f7f713          	andi	a4,a5,127
    800059f2:	9726                	add	a4,a4,s1
    800059f4:	01874703          	lbu	a4,24(a4)
    800059f8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800059fc:	077d0563          	beq	s10,s7,80005a66 <consoleread+0x106>
    cbuf = c;
    80005a00:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a04:	4685                	li	a3,1
    80005a06:	f9f40613          	addi	a2,s0,-97
    80005a0a:	85d2                	mv	a1,s4
    80005a0c:	8556                	mv	a0,s5
    80005a0e:	ffffc097          	auipc	ra,0xffffc
    80005a12:	fa2080e7          	jalr	-94(ra) # 800019b0 <either_copyout>
    80005a16:	01850663          	beq	a0,s8,80005a22 <consoleread+0xc2>
    dst++;
    80005a1a:	0a05                	addi	s4,s4,1
    --n;
    80005a1c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005a1e:	f99d17e3          	bne	s10,s9,800059ac <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a22:	0001c517          	auipc	a0,0x1c
    80005a26:	67e50513          	addi	a0,a0,1662 # 800220a0 <cons>
    80005a2a:	00001097          	auipc	ra,0x1
    80005a2e:	8fe080e7          	jalr	-1794(ra) # 80006328 <release>

  return target - n;
    80005a32:	413b053b          	subw	a0,s6,s3
    80005a36:	a811                	j	80005a4a <consoleread+0xea>
        release(&cons.lock);
    80005a38:	0001c517          	auipc	a0,0x1c
    80005a3c:	66850513          	addi	a0,a0,1640 # 800220a0 <cons>
    80005a40:	00001097          	auipc	ra,0x1
    80005a44:	8e8080e7          	jalr	-1816(ra) # 80006328 <release>
        return -1;
    80005a48:	557d                	li	a0,-1
}
    80005a4a:	70a6                	ld	ra,104(sp)
    80005a4c:	7406                	ld	s0,96(sp)
    80005a4e:	64e6                	ld	s1,88(sp)
    80005a50:	6946                	ld	s2,80(sp)
    80005a52:	69a6                	ld	s3,72(sp)
    80005a54:	6a06                	ld	s4,64(sp)
    80005a56:	7ae2                	ld	s5,56(sp)
    80005a58:	7b42                	ld	s6,48(sp)
    80005a5a:	7ba2                	ld	s7,40(sp)
    80005a5c:	7c02                	ld	s8,32(sp)
    80005a5e:	6ce2                	ld	s9,24(sp)
    80005a60:	6d42                	ld	s10,16(sp)
    80005a62:	6165                	addi	sp,sp,112
    80005a64:	8082                	ret
      if(n < target){
    80005a66:	0009871b          	sext.w	a4,s3
    80005a6a:	fb677ce3          	bgeu	a4,s6,80005a22 <consoleread+0xc2>
        cons.r--;
    80005a6e:	0001c717          	auipc	a4,0x1c
    80005a72:	6cf72523          	sw	a5,1738(a4) # 80022138 <cons+0x98>
    80005a76:	b775                	j	80005a22 <consoleread+0xc2>

0000000080005a78 <consputc>:
{
    80005a78:	1141                	addi	sp,sp,-16
    80005a7a:	e406                	sd	ra,8(sp)
    80005a7c:	e022                	sd	s0,0(sp)
    80005a7e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a80:	10000793          	li	a5,256
    80005a84:	00f50a63          	beq	a0,a5,80005a98 <consputc+0x20>
    uartputc_sync(c);
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	560080e7          	jalr	1376(ra) # 80005fe8 <uartputc_sync>
}
    80005a90:	60a2                	ld	ra,8(sp)
    80005a92:	6402                	ld	s0,0(sp)
    80005a94:	0141                	addi	sp,sp,16
    80005a96:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a98:	4521                	li	a0,8
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	54e080e7          	jalr	1358(ra) # 80005fe8 <uartputc_sync>
    80005aa2:	02000513          	li	a0,32
    80005aa6:	00000097          	auipc	ra,0x0
    80005aaa:	542080e7          	jalr	1346(ra) # 80005fe8 <uartputc_sync>
    80005aae:	4521                	li	a0,8
    80005ab0:	00000097          	auipc	ra,0x0
    80005ab4:	538080e7          	jalr	1336(ra) # 80005fe8 <uartputc_sync>
    80005ab8:	bfe1                	j	80005a90 <consputc+0x18>

0000000080005aba <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005aba:	1101                	addi	sp,sp,-32
    80005abc:	ec06                	sd	ra,24(sp)
    80005abe:	e822                	sd	s0,16(sp)
    80005ac0:	e426                	sd	s1,8(sp)
    80005ac2:	e04a                	sd	s2,0(sp)
    80005ac4:	1000                	addi	s0,sp,32
    80005ac6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ac8:	0001c517          	auipc	a0,0x1c
    80005acc:	5d850513          	addi	a0,a0,1496 # 800220a0 <cons>
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	7a4080e7          	jalr	1956(ra) # 80006274 <acquire>

  switch(c){
    80005ad8:	47d5                	li	a5,21
    80005ada:	0af48663          	beq	s1,a5,80005b86 <consoleintr+0xcc>
    80005ade:	0297ca63          	blt	a5,s1,80005b12 <consoleintr+0x58>
    80005ae2:	47a1                	li	a5,8
    80005ae4:	0ef48763          	beq	s1,a5,80005bd2 <consoleintr+0x118>
    80005ae8:	47c1                	li	a5,16
    80005aea:	10f49a63          	bne	s1,a5,80005bfe <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005aee:	ffffc097          	auipc	ra,0xffffc
    80005af2:	f6e080e7          	jalr	-146(ra) # 80001a5c <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005af6:	0001c517          	auipc	a0,0x1c
    80005afa:	5aa50513          	addi	a0,a0,1450 # 800220a0 <cons>
    80005afe:	00001097          	auipc	ra,0x1
    80005b02:	82a080e7          	jalr	-2006(ra) # 80006328 <release>
}
    80005b06:	60e2                	ld	ra,24(sp)
    80005b08:	6442                	ld	s0,16(sp)
    80005b0a:	64a2                	ld	s1,8(sp)
    80005b0c:	6902                	ld	s2,0(sp)
    80005b0e:	6105                	addi	sp,sp,32
    80005b10:	8082                	ret
  switch(c){
    80005b12:	07f00793          	li	a5,127
    80005b16:	0af48e63          	beq	s1,a5,80005bd2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b1a:	0001c717          	auipc	a4,0x1c
    80005b1e:	58670713          	addi	a4,a4,1414 # 800220a0 <cons>
    80005b22:	0a072783          	lw	a5,160(a4)
    80005b26:	09872703          	lw	a4,152(a4)
    80005b2a:	9f99                	subw	a5,a5,a4
    80005b2c:	07f00713          	li	a4,127
    80005b30:	fcf763e3          	bltu	a4,a5,80005af6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b34:	47b5                	li	a5,13
    80005b36:	0cf48763          	beq	s1,a5,80005c04 <consoleintr+0x14a>
      consputc(c);
    80005b3a:	8526                	mv	a0,s1
    80005b3c:	00000097          	auipc	ra,0x0
    80005b40:	f3c080e7          	jalr	-196(ra) # 80005a78 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b44:	0001c797          	auipc	a5,0x1c
    80005b48:	55c78793          	addi	a5,a5,1372 # 800220a0 <cons>
    80005b4c:	0a07a683          	lw	a3,160(a5)
    80005b50:	0016871b          	addiw	a4,a3,1
    80005b54:	0007061b          	sext.w	a2,a4
    80005b58:	0ae7a023          	sw	a4,160(a5)
    80005b5c:	07f6f693          	andi	a3,a3,127
    80005b60:	97b6                	add	a5,a5,a3
    80005b62:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b66:	47a9                	li	a5,10
    80005b68:	0cf48563          	beq	s1,a5,80005c32 <consoleintr+0x178>
    80005b6c:	4791                	li	a5,4
    80005b6e:	0cf48263          	beq	s1,a5,80005c32 <consoleintr+0x178>
    80005b72:	0001c797          	auipc	a5,0x1c
    80005b76:	5c67a783          	lw	a5,1478(a5) # 80022138 <cons+0x98>
    80005b7a:	9f1d                	subw	a4,a4,a5
    80005b7c:	08000793          	li	a5,128
    80005b80:	f6f71be3          	bne	a4,a5,80005af6 <consoleintr+0x3c>
    80005b84:	a07d                	j	80005c32 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b86:	0001c717          	auipc	a4,0x1c
    80005b8a:	51a70713          	addi	a4,a4,1306 # 800220a0 <cons>
    80005b8e:	0a072783          	lw	a5,160(a4)
    80005b92:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b96:	0001c497          	auipc	s1,0x1c
    80005b9a:	50a48493          	addi	s1,s1,1290 # 800220a0 <cons>
    while(cons.e != cons.w &&
    80005b9e:	4929                	li	s2,10
    80005ba0:	f4f70be3          	beq	a4,a5,80005af6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ba4:	37fd                	addiw	a5,a5,-1
    80005ba6:	07f7f713          	andi	a4,a5,127
    80005baa:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bac:	01874703          	lbu	a4,24(a4)
    80005bb0:	f52703e3          	beq	a4,s2,80005af6 <consoleintr+0x3c>
      cons.e--;
    80005bb4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005bb8:	10000513          	li	a0,256
    80005bbc:	00000097          	auipc	ra,0x0
    80005bc0:	ebc080e7          	jalr	-324(ra) # 80005a78 <consputc>
    while(cons.e != cons.w &&
    80005bc4:	0a04a783          	lw	a5,160(s1)
    80005bc8:	09c4a703          	lw	a4,156(s1)
    80005bcc:	fcf71ce3          	bne	a4,a5,80005ba4 <consoleintr+0xea>
    80005bd0:	b71d                	j	80005af6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005bd2:	0001c717          	auipc	a4,0x1c
    80005bd6:	4ce70713          	addi	a4,a4,1230 # 800220a0 <cons>
    80005bda:	0a072783          	lw	a5,160(a4)
    80005bde:	09c72703          	lw	a4,156(a4)
    80005be2:	f0f70ae3          	beq	a4,a5,80005af6 <consoleintr+0x3c>
      cons.e--;
    80005be6:	37fd                	addiw	a5,a5,-1
    80005be8:	0001c717          	auipc	a4,0x1c
    80005bec:	54f72c23          	sw	a5,1368(a4) # 80022140 <cons+0xa0>
      consputc(BACKSPACE);
    80005bf0:	10000513          	li	a0,256
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	e84080e7          	jalr	-380(ra) # 80005a78 <consputc>
    80005bfc:	bded                	j	80005af6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bfe:	ee048ce3          	beqz	s1,80005af6 <consoleintr+0x3c>
    80005c02:	bf21                	j	80005b1a <consoleintr+0x60>
      consputc(c);
    80005c04:	4529                	li	a0,10
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	e72080e7          	jalr	-398(ra) # 80005a78 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c0e:	0001c797          	auipc	a5,0x1c
    80005c12:	49278793          	addi	a5,a5,1170 # 800220a0 <cons>
    80005c16:	0a07a703          	lw	a4,160(a5)
    80005c1a:	0017069b          	addiw	a3,a4,1
    80005c1e:	0006861b          	sext.w	a2,a3
    80005c22:	0ad7a023          	sw	a3,160(a5)
    80005c26:	07f77713          	andi	a4,a4,127
    80005c2a:	97ba                	add	a5,a5,a4
    80005c2c:	4729                	li	a4,10
    80005c2e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c32:	0001c797          	auipc	a5,0x1c
    80005c36:	50c7a523          	sw	a2,1290(a5) # 8002213c <cons+0x9c>
        wakeup(&cons.r);
    80005c3a:	0001c517          	auipc	a0,0x1c
    80005c3e:	4fe50513          	addi	a0,a0,1278 # 80022138 <cons+0x98>
    80005c42:	ffffc097          	auipc	ra,0xffffc
    80005c46:	9a2080e7          	jalr	-1630(ra) # 800015e4 <wakeup>
    80005c4a:	b575                	j	80005af6 <consoleintr+0x3c>

0000000080005c4c <consoleinit>:

void
consoleinit(void)
{
    80005c4c:	1141                	addi	sp,sp,-16
    80005c4e:	e406                	sd	ra,8(sp)
    80005c50:	e022                	sd	s0,0(sp)
    80005c52:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c54:	00003597          	auipc	a1,0x3
    80005c58:	db458593          	addi	a1,a1,-588 # 80008a08 <syscalls_name+0x3f8>
    80005c5c:	0001c517          	auipc	a0,0x1c
    80005c60:	44450513          	addi	a0,a0,1092 # 800220a0 <cons>
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	580080e7          	jalr	1408(ra) # 800061e4 <initlock>

  uartinit();
    80005c6c:	00000097          	auipc	ra,0x0
    80005c70:	32c080e7          	jalr	812(ra) # 80005f98 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c74:	00013797          	auipc	a5,0x13
    80005c78:	15478793          	addi	a5,a5,340 # 80018dc8 <devsw>
    80005c7c:	00000717          	auipc	a4,0x0
    80005c80:	ce470713          	addi	a4,a4,-796 # 80005960 <consoleread>
    80005c84:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c86:	00000717          	auipc	a4,0x0
    80005c8a:	c7670713          	addi	a4,a4,-906 # 800058fc <consolewrite>
    80005c8e:	ef98                	sd	a4,24(a5)
}
    80005c90:	60a2                	ld	ra,8(sp)
    80005c92:	6402                	ld	s0,0(sp)
    80005c94:	0141                	addi	sp,sp,16
    80005c96:	8082                	ret

0000000080005c98 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c98:	7179                	addi	sp,sp,-48
    80005c9a:	f406                	sd	ra,40(sp)
    80005c9c:	f022                	sd	s0,32(sp)
    80005c9e:	ec26                	sd	s1,24(sp)
    80005ca0:	e84a                	sd	s2,16(sp)
    80005ca2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005ca4:	c219                	beqz	a2,80005caa <printint+0x12>
    80005ca6:	08054763          	bltz	a0,80005d34 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005caa:	2501                	sext.w	a0,a0
    80005cac:	4881                	li	a7,0
    80005cae:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cb2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cb4:	2581                	sext.w	a1,a1
    80005cb6:	00003617          	auipc	a2,0x3
    80005cba:	d8260613          	addi	a2,a2,-638 # 80008a38 <digits>
    80005cbe:	883a                	mv	a6,a4
    80005cc0:	2705                	addiw	a4,a4,1
    80005cc2:	02b577bb          	remuw	a5,a0,a1
    80005cc6:	1782                	slli	a5,a5,0x20
    80005cc8:	9381                	srli	a5,a5,0x20
    80005cca:	97b2                	add	a5,a5,a2
    80005ccc:	0007c783          	lbu	a5,0(a5)
    80005cd0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005cd4:	0005079b          	sext.w	a5,a0
    80005cd8:	02b5553b          	divuw	a0,a0,a1
    80005cdc:	0685                	addi	a3,a3,1
    80005cde:	feb7f0e3          	bgeu	a5,a1,80005cbe <printint+0x26>

  if(sign)
    80005ce2:	00088c63          	beqz	a7,80005cfa <printint+0x62>
    buf[i++] = '-';
    80005ce6:	fe070793          	addi	a5,a4,-32
    80005cea:	00878733          	add	a4,a5,s0
    80005cee:	02d00793          	li	a5,45
    80005cf2:	fef70823          	sb	a5,-16(a4)
    80005cf6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cfa:	02e05763          	blez	a4,80005d28 <printint+0x90>
    80005cfe:	fd040793          	addi	a5,s0,-48
    80005d02:	00e784b3          	add	s1,a5,a4
    80005d06:	fff78913          	addi	s2,a5,-1
    80005d0a:	993a                	add	s2,s2,a4
    80005d0c:	377d                	addiw	a4,a4,-1
    80005d0e:	1702                	slli	a4,a4,0x20
    80005d10:	9301                	srli	a4,a4,0x20
    80005d12:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d16:	fff4c503          	lbu	a0,-1(s1)
    80005d1a:	00000097          	auipc	ra,0x0
    80005d1e:	d5e080e7          	jalr	-674(ra) # 80005a78 <consputc>
  while(--i >= 0)
    80005d22:	14fd                	addi	s1,s1,-1
    80005d24:	ff2499e3          	bne	s1,s2,80005d16 <printint+0x7e>
}
    80005d28:	70a2                	ld	ra,40(sp)
    80005d2a:	7402                	ld	s0,32(sp)
    80005d2c:	64e2                	ld	s1,24(sp)
    80005d2e:	6942                	ld	s2,16(sp)
    80005d30:	6145                	addi	sp,sp,48
    80005d32:	8082                	ret
    x = -xx;
    80005d34:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d38:	4885                	li	a7,1
    x = -xx;
    80005d3a:	bf95                	j	80005cae <printint+0x16>

0000000080005d3c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d3c:	1101                	addi	sp,sp,-32
    80005d3e:	ec06                	sd	ra,24(sp)
    80005d40:	e822                	sd	s0,16(sp)
    80005d42:	e426                	sd	s1,8(sp)
    80005d44:	1000                	addi	s0,sp,32
    80005d46:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d48:	0001c797          	auipc	a5,0x1c
    80005d4c:	4007ac23          	sw	zero,1048(a5) # 80022160 <pr+0x18>
  printf("panic: ");
    80005d50:	00003517          	auipc	a0,0x3
    80005d54:	cc050513          	addi	a0,a0,-832 # 80008a10 <syscalls_name+0x400>
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	02e080e7          	jalr	46(ra) # 80005d86 <printf>
  printf(s);
    80005d60:	8526                	mv	a0,s1
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	024080e7          	jalr	36(ra) # 80005d86 <printf>
  printf("\n");
    80005d6a:	00002517          	auipc	a0,0x2
    80005d6e:	2de50513          	addi	a0,a0,734 # 80008048 <etext+0x48>
    80005d72:	00000097          	auipc	ra,0x0
    80005d76:	014080e7          	jalr	20(ra) # 80005d86 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d7a:	4785                	li	a5,1
    80005d7c:	00003717          	auipc	a4,0x3
    80005d80:	daf72023          	sw	a5,-608(a4) # 80008b1c <panicked>
  for(;;)
    80005d84:	a001                	j	80005d84 <panic+0x48>

0000000080005d86 <printf>:
{
    80005d86:	7131                	addi	sp,sp,-192
    80005d88:	fc86                	sd	ra,120(sp)
    80005d8a:	f8a2                	sd	s0,112(sp)
    80005d8c:	f4a6                	sd	s1,104(sp)
    80005d8e:	f0ca                	sd	s2,96(sp)
    80005d90:	ecce                	sd	s3,88(sp)
    80005d92:	e8d2                	sd	s4,80(sp)
    80005d94:	e4d6                	sd	s5,72(sp)
    80005d96:	e0da                	sd	s6,64(sp)
    80005d98:	fc5e                	sd	s7,56(sp)
    80005d9a:	f862                	sd	s8,48(sp)
    80005d9c:	f466                	sd	s9,40(sp)
    80005d9e:	f06a                	sd	s10,32(sp)
    80005da0:	ec6e                	sd	s11,24(sp)
    80005da2:	0100                	addi	s0,sp,128
    80005da4:	8a2a                	mv	s4,a0
    80005da6:	e40c                	sd	a1,8(s0)
    80005da8:	e810                	sd	a2,16(s0)
    80005daa:	ec14                	sd	a3,24(s0)
    80005dac:	f018                	sd	a4,32(s0)
    80005dae:	f41c                	sd	a5,40(s0)
    80005db0:	03043823          	sd	a6,48(s0)
    80005db4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005db8:	0001cd97          	auipc	s11,0x1c
    80005dbc:	3a8dad83          	lw	s11,936(s11) # 80022160 <pr+0x18>
  if(locking)
    80005dc0:	020d9b63          	bnez	s11,80005df6 <printf+0x70>
  if (fmt == 0)
    80005dc4:	040a0263          	beqz	s4,80005e08 <printf+0x82>
  va_start(ap, fmt);
    80005dc8:	00840793          	addi	a5,s0,8
    80005dcc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dd0:	000a4503          	lbu	a0,0(s4)
    80005dd4:	14050f63          	beqz	a0,80005f32 <printf+0x1ac>
    80005dd8:	4981                	li	s3,0
    if(c != '%'){
    80005dda:	02500a93          	li	s5,37
    switch(c){
    80005dde:	07000b93          	li	s7,112
  consputc('x');
    80005de2:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005de4:	00003b17          	auipc	s6,0x3
    80005de8:	c54b0b13          	addi	s6,s6,-940 # 80008a38 <digits>
    switch(c){
    80005dec:	07300c93          	li	s9,115
    80005df0:	06400c13          	li	s8,100
    80005df4:	a82d                	j	80005e2e <printf+0xa8>
    acquire(&pr.lock);
    80005df6:	0001c517          	auipc	a0,0x1c
    80005dfa:	35250513          	addi	a0,a0,850 # 80022148 <pr>
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	476080e7          	jalr	1142(ra) # 80006274 <acquire>
    80005e06:	bf7d                	j	80005dc4 <printf+0x3e>
    panic("null fmt");
    80005e08:	00003517          	auipc	a0,0x3
    80005e0c:	c1850513          	addi	a0,a0,-1000 # 80008a20 <syscalls_name+0x410>
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	f2c080e7          	jalr	-212(ra) # 80005d3c <panic>
      consputc(c);
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	c60080e7          	jalr	-928(ra) # 80005a78 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e20:	2985                	addiw	s3,s3,1
    80005e22:	013a07b3          	add	a5,s4,s3
    80005e26:	0007c503          	lbu	a0,0(a5)
    80005e2a:	10050463          	beqz	a0,80005f32 <printf+0x1ac>
    if(c != '%'){
    80005e2e:	ff5515e3          	bne	a0,s5,80005e18 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e32:	2985                	addiw	s3,s3,1
    80005e34:	013a07b3          	add	a5,s4,s3
    80005e38:	0007c783          	lbu	a5,0(a5)
    80005e3c:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005e40:	cbed                	beqz	a5,80005f32 <printf+0x1ac>
    switch(c){
    80005e42:	05778a63          	beq	a5,s7,80005e96 <printf+0x110>
    80005e46:	02fbf663          	bgeu	s7,a5,80005e72 <printf+0xec>
    80005e4a:	09978863          	beq	a5,s9,80005eda <printf+0x154>
    80005e4e:	07800713          	li	a4,120
    80005e52:	0ce79563          	bne	a5,a4,80005f1c <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005e56:	f8843783          	ld	a5,-120(s0)
    80005e5a:	00878713          	addi	a4,a5,8
    80005e5e:	f8e43423          	sd	a4,-120(s0)
    80005e62:	4605                	li	a2,1
    80005e64:	85ea                	mv	a1,s10
    80005e66:	4388                	lw	a0,0(a5)
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	e30080e7          	jalr	-464(ra) # 80005c98 <printint>
      break;
    80005e70:	bf45                	j	80005e20 <printf+0x9a>
    switch(c){
    80005e72:	09578f63          	beq	a5,s5,80005f10 <printf+0x18a>
    80005e76:	0b879363          	bne	a5,s8,80005f1c <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005e7a:	f8843783          	ld	a5,-120(s0)
    80005e7e:	00878713          	addi	a4,a5,8
    80005e82:	f8e43423          	sd	a4,-120(s0)
    80005e86:	4605                	li	a2,1
    80005e88:	45a9                	li	a1,10
    80005e8a:	4388                	lw	a0,0(a5)
    80005e8c:	00000097          	auipc	ra,0x0
    80005e90:	e0c080e7          	jalr	-500(ra) # 80005c98 <printint>
      break;
    80005e94:	b771                	j	80005e20 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e96:	f8843783          	ld	a5,-120(s0)
    80005e9a:	00878713          	addi	a4,a5,8
    80005e9e:	f8e43423          	sd	a4,-120(s0)
    80005ea2:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005ea6:	03000513          	li	a0,48
    80005eaa:	00000097          	auipc	ra,0x0
    80005eae:	bce080e7          	jalr	-1074(ra) # 80005a78 <consputc>
  consputc('x');
    80005eb2:	07800513          	li	a0,120
    80005eb6:	00000097          	auipc	ra,0x0
    80005eba:	bc2080e7          	jalr	-1086(ra) # 80005a78 <consputc>
    80005ebe:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ec0:	03c95793          	srli	a5,s2,0x3c
    80005ec4:	97da                	add	a5,a5,s6
    80005ec6:	0007c503          	lbu	a0,0(a5)
    80005eca:	00000097          	auipc	ra,0x0
    80005ece:	bae080e7          	jalr	-1106(ra) # 80005a78 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005ed2:	0912                	slli	s2,s2,0x4
    80005ed4:	34fd                	addiw	s1,s1,-1
    80005ed6:	f4ed                	bnez	s1,80005ec0 <printf+0x13a>
    80005ed8:	b7a1                	j	80005e20 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005eda:	f8843783          	ld	a5,-120(s0)
    80005ede:	00878713          	addi	a4,a5,8
    80005ee2:	f8e43423          	sd	a4,-120(s0)
    80005ee6:	6384                	ld	s1,0(a5)
    80005ee8:	cc89                	beqz	s1,80005f02 <printf+0x17c>
      for(; *s; s++)
    80005eea:	0004c503          	lbu	a0,0(s1)
    80005eee:	d90d                	beqz	a0,80005e20 <printf+0x9a>
        consputc(*s);
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	b88080e7          	jalr	-1144(ra) # 80005a78 <consputc>
      for(; *s; s++)
    80005ef8:	0485                	addi	s1,s1,1
    80005efa:	0004c503          	lbu	a0,0(s1)
    80005efe:	f96d                	bnez	a0,80005ef0 <printf+0x16a>
    80005f00:	b705                	j	80005e20 <printf+0x9a>
        s = "(null)";
    80005f02:	00003497          	auipc	s1,0x3
    80005f06:	b1648493          	addi	s1,s1,-1258 # 80008a18 <syscalls_name+0x408>
      for(; *s; s++)
    80005f0a:	02800513          	li	a0,40
    80005f0e:	b7cd                	j	80005ef0 <printf+0x16a>
      consputc('%');
    80005f10:	8556                	mv	a0,s5
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	b66080e7          	jalr	-1178(ra) # 80005a78 <consputc>
      break;
    80005f1a:	b719                	j	80005e20 <printf+0x9a>
      consputc('%');
    80005f1c:	8556                	mv	a0,s5
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	b5a080e7          	jalr	-1190(ra) # 80005a78 <consputc>
      consputc(c);
    80005f26:	8526                	mv	a0,s1
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	b50080e7          	jalr	-1200(ra) # 80005a78 <consputc>
      break;
    80005f30:	bdc5                	j	80005e20 <printf+0x9a>
  if(locking)
    80005f32:	020d9163          	bnez	s11,80005f54 <printf+0x1ce>
}
    80005f36:	70e6                	ld	ra,120(sp)
    80005f38:	7446                	ld	s0,112(sp)
    80005f3a:	74a6                	ld	s1,104(sp)
    80005f3c:	7906                	ld	s2,96(sp)
    80005f3e:	69e6                	ld	s3,88(sp)
    80005f40:	6a46                	ld	s4,80(sp)
    80005f42:	6aa6                	ld	s5,72(sp)
    80005f44:	6b06                	ld	s6,64(sp)
    80005f46:	7be2                	ld	s7,56(sp)
    80005f48:	7c42                	ld	s8,48(sp)
    80005f4a:	7ca2                	ld	s9,40(sp)
    80005f4c:	7d02                	ld	s10,32(sp)
    80005f4e:	6de2                	ld	s11,24(sp)
    80005f50:	6129                	addi	sp,sp,192
    80005f52:	8082                	ret
    release(&pr.lock);
    80005f54:	0001c517          	auipc	a0,0x1c
    80005f58:	1f450513          	addi	a0,a0,500 # 80022148 <pr>
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	3cc080e7          	jalr	972(ra) # 80006328 <release>
}
    80005f64:	bfc9                	j	80005f36 <printf+0x1b0>

0000000080005f66 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f66:	1101                	addi	sp,sp,-32
    80005f68:	ec06                	sd	ra,24(sp)
    80005f6a:	e822                	sd	s0,16(sp)
    80005f6c:	e426                	sd	s1,8(sp)
    80005f6e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f70:	0001c497          	auipc	s1,0x1c
    80005f74:	1d848493          	addi	s1,s1,472 # 80022148 <pr>
    80005f78:	00003597          	auipc	a1,0x3
    80005f7c:	ab858593          	addi	a1,a1,-1352 # 80008a30 <syscalls_name+0x420>
    80005f80:	8526                	mv	a0,s1
    80005f82:	00000097          	auipc	ra,0x0
    80005f86:	262080e7          	jalr	610(ra) # 800061e4 <initlock>
  pr.locking = 1;
    80005f8a:	4785                	li	a5,1
    80005f8c:	cc9c                	sw	a5,24(s1)
}
    80005f8e:	60e2                	ld	ra,24(sp)
    80005f90:	6442                	ld	s0,16(sp)
    80005f92:	64a2                	ld	s1,8(sp)
    80005f94:	6105                	addi	sp,sp,32
    80005f96:	8082                	ret

0000000080005f98 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f98:	1141                	addi	sp,sp,-16
    80005f9a:	e406                	sd	ra,8(sp)
    80005f9c:	e022                	sd	s0,0(sp)
    80005f9e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fa0:	100007b7          	lui	a5,0x10000
    80005fa4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fa8:	f8000713          	li	a4,-128
    80005fac:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fb0:	470d                	li	a4,3
    80005fb2:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fb6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fba:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fbe:	469d                	li	a3,7
    80005fc0:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fc4:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fc8:	00003597          	auipc	a1,0x3
    80005fcc:	a8858593          	addi	a1,a1,-1400 # 80008a50 <digits+0x18>
    80005fd0:	0001c517          	auipc	a0,0x1c
    80005fd4:	19850513          	addi	a0,a0,408 # 80022168 <uart_tx_lock>
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	20c080e7          	jalr	524(ra) # 800061e4 <initlock>
}
    80005fe0:	60a2                	ld	ra,8(sp)
    80005fe2:	6402                	ld	s0,0(sp)
    80005fe4:	0141                	addi	sp,sp,16
    80005fe6:	8082                	ret

0000000080005fe8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fe8:	1101                	addi	sp,sp,-32
    80005fea:	ec06                	sd	ra,24(sp)
    80005fec:	e822                	sd	s0,16(sp)
    80005fee:	e426                	sd	s1,8(sp)
    80005ff0:	1000                	addi	s0,sp,32
    80005ff2:	84aa                	mv	s1,a0
  push_off();
    80005ff4:	00000097          	auipc	ra,0x0
    80005ff8:	234080e7          	jalr	564(ra) # 80006228 <push_off>

  if(panicked){
    80005ffc:	00003797          	auipc	a5,0x3
    80006000:	b207a783          	lw	a5,-1248(a5) # 80008b1c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006004:	10000737          	lui	a4,0x10000
  if(panicked){
    80006008:	c391                	beqz	a5,8000600c <uartputc_sync+0x24>
    for(;;)
    8000600a:	a001                	j	8000600a <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000600c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006010:	0207f793          	andi	a5,a5,32
    80006014:	dfe5                	beqz	a5,8000600c <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006016:	0ff4f513          	zext.b	a0,s1
    8000601a:	100007b7          	lui	a5,0x10000
    8000601e:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006022:	00000097          	auipc	ra,0x0
    80006026:	2a6080e7          	jalr	678(ra) # 800062c8 <pop_off>
}
    8000602a:	60e2                	ld	ra,24(sp)
    8000602c:	6442                	ld	s0,16(sp)
    8000602e:	64a2                	ld	s1,8(sp)
    80006030:	6105                	addi	sp,sp,32
    80006032:	8082                	ret

0000000080006034 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006034:	00003797          	auipc	a5,0x3
    80006038:	aec7b783          	ld	a5,-1300(a5) # 80008b20 <uart_tx_r>
    8000603c:	00003717          	auipc	a4,0x3
    80006040:	aec73703          	ld	a4,-1300(a4) # 80008b28 <uart_tx_w>
    80006044:	06f70a63          	beq	a4,a5,800060b8 <uartstart+0x84>
{
    80006048:	7139                	addi	sp,sp,-64
    8000604a:	fc06                	sd	ra,56(sp)
    8000604c:	f822                	sd	s0,48(sp)
    8000604e:	f426                	sd	s1,40(sp)
    80006050:	f04a                	sd	s2,32(sp)
    80006052:	ec4e                	sd	s3,24(sp)
    80006054:	e852                	sd	s4,16(sp)
    80006056:	e456                	sd	s5,8(sp)
    80006058:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000605a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000605e:	0001ca17          	auipc	s4,0x1c
    80006062:	10aa0a13          	addi	s4,s4,266 # 80022168 <uart_tx_lock>
    uart_tx_r += 1;
    80006066:	00003497          	auipc	s1,0x3
    8000606a:	aba48493          	addi	s1,s1,-1350 # 80008b20 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000606e:	00003997          	auipc	s3,0x3
    80006072:	aba98993          	addi	s3,s3,-1350 # 80008b28 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006076:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000607a:	02077713          	andi	a4,a4,32
    8000607e:	c705                	beqz	a4,800060a6 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006080:	01f7f713          	andi	a4,a5,31
    80006084:	9752                	add	a4,a4,s4
    80006086:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000608a:	0785                	addi	a5,a5,1
    8000608c:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000608e:	8526                	mv	a0,s1
    80006090:	ffffb097          	auipc	ra,0xffffb
    80006094:	554080e7          	jalr	1364(ra) # 800015e4 <wakeup>
    
    WriteReg(THR, c);
    80006098:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000609c:	609c                	ld	a5,0(s1)
    8000609e:	0009b703          	ld	a4,0(s3)
    800060a2:	fcf71ae3          	bne	a4,a5,80006076 <uartstart+0x42>
  }
}
    800060a6:	70e2                	ld	ra,56(sp)
    800060a8:	7442                	ld	s0,48(sp)
    800060aa:	74a2                	ld	s1,40(sp)
    800060ac:	7902                	ld	s2,32(sp)
    800060ae:	69e2                	ld	s3,24(sp)
    800060b0:	6a42                	ld	s4,16(sp)
    800060b2:	6aa2                	ld	s5,8(sp)
    800060b4:	6121                	addi	sp,sp,64
    800060b6:	8082                	ret
    800060b8:	8082                	ret

00000000800060ba <uartputc>:
{
    800060ba:	7179                	addi	sp,sp,-48
    800060bc:	f406                	sd	ra,40(sp)
    800060be:	f022                	sd	s0,32(sp)
    800060c0:	ec26                	sd	s1,24(sp)
    800060c2:	e84a                	sd	s2,16(sp)
    800060c4:	e44e                	sd	s3,8(sp)
    800060c6:	e052                	sd	s4,0(sp)
    800060c8:	1800                	addi	s0,sp,48
    800060ca:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800060cc:	0001c517          	auipc	a0,0x1c
    800060d0:	09c50513          	addi	a0,a0,156 # 80022168 <uart_tx_lock>
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	1a0080e7          	jalr	416(ra) # 80006274 <acquire>
  if(panicked){
    800060dc:	00003797          	auipc	a5,0x3
    800060e0:	a407a783          	lw	a5,-1472(a5) # 80008b1c <panicked>
    800060e4:	e7c9                	bnez	a5,8000616e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060e6:	00003717          	auipc	a4,0x3
    800060ea:	a4273703          	ld	a4,-1470(a4) # 80008b28 <uart_tx_w>
    800060ee:	00003797          	auipc	a5,0x3
    800060f2:	a327b783          	ld	a5,-1486(a5) # 80008b20 <uart_tx_r>
    800060f6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060fa:	0001c997          	auipc	s3,0x1c
    800060fe:	06e98993          	addi	s3,s3,110 # 80022168 <uart_tx_lock>
    80006102:	00003497          	auipc	s1,0x3
    80006106:	a1e48493          	addi	s1,s1,-1506 # 80008b20 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610a:	00003917          	auipc	s2,0x3
    8000610e:	a1e90913          	addi	s2,s2,-1506 # 80008b28 <uart_tx_w>
    80006112:	00e79f63          	bne	a5,a4,80006130 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006116:	85ce                	mv	a1,s3
    80006118:	8526                	mv	a0,s1
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	45c080e7          	jalr	1116(ra) # 80001576 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006122:	00093703          	ld	a4,0(s2)
    80006126:	609c                	ld	a5,0(s1)
    80006128:	02078793          	addi	a5,a5,32
    8000612c:	fee785e3          	beq	a5,a4,80006116 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006130:	0001c497          	auipc	s1,0x1c
    80006134:	03848493          	addi	s1,s1,56 # 80022168 <uart_tx_lock>
    80006138:	01f77793          	andi	a5,a4,31
    8000613c:	97a6                	add	a5,a5,s1
    8000613e:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80006142:	0705                	addi	a4,a4,1
    80006144:	00003797          	auipc	a5,0x3
    80006148:	9ee7b223          	sd	a4,-1564(a5) # 80008b28 <uart_tx_w>
  uartstart();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	ee8080e7          	jalr	-280(ra) # 80006034 <uartstart>
  release(&uart_tx_lock);
    80006154:	8526                	mv	a0,s1
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	1d2080e7          	jalr	466(ra) # 80006328 <release>
}
    8000615e:	70a2                	ld	ra,40(sp)
    80006160:	7402                	ld	s0,32(sp)
    80006162:	64e2                	ld	s1,24(sp)
    80006164:	6942                	ld	s2,16(sp)
    80006166:	69a2                	ld	s3,8(sp)
    80006168:	6a02                	ld	s4,0(sp)
    8000616a:	6145                	addi	sp,sp,48
    8000616c:	8082                	ret
    for(;;)
    8000616e:	a001                	j	8000616e <uartputc+0xb4>

0000000080006170 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006170:	1141                	addi	sp,sp,-16
    80006172:	e422                	sd	s0,8(sp)
    80006174:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006176:	100007b7          	lui	a5,0x10000
    8000617a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000617e:	8b85                	andi	a5,a5,1
    80006180:	cb81                	beqz	a5,80006190 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006182:	100007b7          	lui	a5,0x10000
    80006186:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000618a:	6422                	ld	s0,8(sp)
    8000618c:	0141                	addi	sp,sp,16
    8000618e:	8082                	ret
    return -1;
    80006190:	557d                	li	a0,-1
    80006192:	bfe5                	j	8000618a <uartgetc+0x1a>

0000000080006194 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006194:	1101                	addi	sp,sp,-32
    80006196:	ec06                	sd	ra,24(sp)
    80006198:	e822                	sd	s0,16(sp)
    8000619a:	e426                	sd	s1,8(sp)
    8000619c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000619e:	54fd                	li	s1,-1
    800061a0:	a029                	j	800061aa <uartintr+0x16>
      break;
    consoleintr(c);
    800061a2:	00000097          	auipc	ra,0x0
    800061a6:	918080e7          	jalr	-1768(ra) # 80005aba <consoleintr>
    int c = uartgetc();
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	fc6080e7          	jalr	-58(ra) # 80006170 <uartgetc>
    if(c == -1)
    800061b2:	fe9518e3          	bne	a0,s1,800061a2 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061b6:	0001c497          	auipc	s1,0x1c
    800061ba:	fb248493          	addi	s1,s1,-78 # 80022168 <uart_tx_lock>
    800061be:	8526                	mv	a0,s1
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	0b4080e7          	jalr	180(ra) # 80006274 <acquire>
  uartstart();
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	e6c080e7          	jalr	-404(ra) # 80006034 <uartstart>
  release(&uart_tx_lock);
    800061d0:	8526                	mv	a0,s1
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	156080e7          	jalr	342(ra) # 80006328 <release>
}
    800061da:	60e2                	ld	ra,24(sp)
    800061dc:	6442                	ld	s0,16(sp)
    800061de:	64a2                	ld	s1,8(sp)
    800061e0:	6105                	addi	sp,sp,32
    800061e2:	8082                	ret

00000000800061e4 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061e4:	1141                	addi	sp,sp,-16
    800061e6:	e422                	sd	s0,8(sp)
    800061e8:	0800                	addi	s0,sp,16
  lk->name = name;
    800061ea:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061ec:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061f0:	00053823          	sd	zero,16(a0)
}
    800061f4:	6422                	ld	s0,8(sp)
    800061f6:	0141                	addi	sp,sp,16
    800061f8:	8082                	ret

00000000800061fa <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061fa:	411c                	lw	a5,0(a0)
    800061fc:	e399                	bnez	a5,80006202 <holding+0x8>
    800061fe:	4501                	li	a0,0
  return r;
}
    80006200:	8082                	ret
{
    80006202:	1101                	addi	sp,sp,-32
    80006204:	ec06                	sd	ra,24(sp)
    80006206:	e822                	sd	s0,16(sp)
    80006208:	e426                	sd	s1,8(sp)
    8000620a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000620c:	6904                	ld	s1,16(a0)
    8000620e:	ffffb097          	auipc	ra,0xffffb
    80006212:	c78080e7          	jalr	-904(ra) # 80000e86 <mycpu>
    80006216:	40a48533          	sub	a0,s1,a0
    8000621a:	00153513          	seqz	a0,a0
}
    8000621e:	60e2                	ld	ra,24(sp)
    80006220:	6442                	ld	s0,16(sp)
    80006222:	64a2                	ld	s1,8(sp)
    80006224:	6105                	addi	sp,sp,32
    80006226:	8082                	ret

0000000080006228 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006228:	1101                	addi	sp,sp,-32
    8000622a:	ec06                	sd	ra,24(sp)
    8000622c:	e822                	sd	s0,16(sp)
    8000622e:	e426                	sd	s1,8(sp)
    80006230:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006232:	100024f3          	csrr	s1,sstatus
    80006236:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000623a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000623c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006240:	ffffb097          	auipc	ra,0xffffb
    80006244:	c46080e7          	jalr	-954(ra) # 80000e86 <mycpu>
    80006248:	5d3c                	lw	a5,120(a0)
    8000624a:	cf89                	beqz	a5,80006264 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000624c:	ffffb097          	auipc	ra,0xffffb
    80006250:	c3a080e7          	jalr	-966(ra) # 80000e86 <mycpu>
    80006254:	5d3c                	lw	a5,120(a0)
    80006256:	2785                	addiw	a5,a5,1
    80006258:	dd3c                	sw	a5,120(a0)
}
    8000625a:	60e2                	ld	ra,24(sp)
    8000625c:	6442                	ld	s0,16(sp)
    8000625e:	64a2                	ld	s1,8(sp)
    80006260:	6105                	addi	sp,sp,32
    80006262:	8082                	ret
    mycpu()->intena = old;
    80006264:	ffffb097          	auipc	ra,0xffffb
    80006268:	c22080e7          	jalr	-990(ra) # 80000e86 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000626c:	8085                	srli	s1,s1,0x1
    8000626e:	8885                	andi	s1,s1,1
    80006270:	dd64                	sw	s1,124(a0)
    80006272:	bfe9                	j	8000624c <push_off+0x24>

0000000080006274 <acquire>:
{
    80006274:	1101                	addi	sp,sp,-32
    80006276:	ec06                	sd	ra,24(sp)
    80006278:	e822                	sd	s0,16(sp)
    8000627a:	e426                	sd	s1,8(sp)
    8000627c:	1000                	addi	s0,sp,32
    8000627e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006280:	00000097          	auipc	ra,0x0
    80006284:	fa8080e7          	jalr	-88(ra) # 80006228 <push_off>
  if(holding(lk))
    80006288:	8526                	mv	a0,s1
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	f70080e7          	jalr	-144(ra) # 800061fa <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006292:	4705                	li	a4,1
  if(holding(lk))
    80006294:	e115                	bnez	a0,800062b8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006296:	87ba                	mv	a5,a4
    80006298:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000629c:	2781                	sext.w	a5,a5
    8000629e:	ffe5                	bnez	a5,80006296 <acquire+0x22>
  __sync_synchronize();
    800062a0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	be2080e7          	jalr	-1054(ra) # 80000e86 <mycpu>
    800062ac:	e888                	sd	a0,16(s1)
}
    800062ae:	60e2                	ld	ra,24(sp)
    800062b0:	6442                	ld	s0,16(sp)
    800062b2:	64a2                	ld	s1,8(sp)
    800062b4:	6105                	addi	sp,sp,32
    800062b6:	8082                	ret
    panic("acquire");
    800062b8:	00002517          	auipc	a0,0x2
    800062bc:	7a050513          	addi	a0,a0,1952 # 80008a58 <digits+0x20>
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	a7c080e7          	jalr	-1412(ra) # 80005d3c <panic>

00000000800062c8 <pop_off>:

void
pop_off(void)
{
    800062c8:	1141                	addi	sp,sp,-16
    800062ca:	e406                	sd	ra,8(sp)
    800062cc:	e022                	sd	s0,0(sp)
    800062ce:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062d0:	ffffb097          	auipc	ra,0xffffb
    800062d4:	bb6080e7          	jalr	-1098(ra) # 80000e86 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062d8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062dc:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062de:	e78d                	bnez	a5,80006308 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062e0:	5d3c                	lw	a5,120(a0)
    800062e2:	02f05b63          	blez	a5,80006318 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062e6:	37fd                	addiw	a5,a5,-1
    800062e8:	0007871b          	sext.w	a4,a5
    800062ec:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062ee:	eb09                	bnez	a4,80006300 <pop_off+0x38>
    800062f0:	5d7c                	lw	a5,124(a0)
    800062f2:	c799                	beqz	a5,80006300 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062f8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062fc:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006300:	60a2                	ld	ra,8(sp)
    80006302:	6402                	ld	s0,0(sp)
    80006304:	0141                	addi	sp,sp,16
    80006306:	8082                	ret
    panic("pop_off - interruptible");
    80006308:	00002517          	auipc	a0,0x2
    8000630c:	75850513          	addi	a0,a0,1880 # 80008a60 <digits+0x28>
    80006310:	00000097          	auipc	ra,0x0
    80006314:	a2c080e7          	jalr	-1492(ra) # 80005d3c <panic>
    panic("pop_off");
    80006318:	00002517          	auipc	a0,0x2
    8000631c:	76050513          	addi	a0,a0,1888 # 80008a78 <digits+0x40>
    80006320:	00000097          	auipc	ra,0x0
    80006324:	a1c080e7          	jalr	-1508(ra) # 80005d3c <panic>

0000000080006328 <release>:
{
    80006328:	1101                	addi	sp,sp,-32
    8000632a:	ec06                	sd	ra,24(sp)
    8000632c:	e822                	sd	s0,16(sp)
    8000632e:	e426                	sd	s1,8(sp)
    80006330:	1000                	addi	s0,sp,32
    80006332:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006334:	00000097          	auipc	ra,0x0
    80006338:	ec6080e7          	jalr	-314(ra) # 800061fa <holding>
    8000633c:	c115                	beqz	a0,80006360 <release+0x38>
  lk->cpu = 0;
    8000633e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006342:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006346:	0f50000f          	fence	iorw,ow
    8000634a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000634e:	00000097          	auipc	ra,0x0
    80006352:	f7a080e7          	jalr	-134(ra) # 800062c8 <pop_off>
}
    80006356:	60e2                	ld	ra,24(sp)
    80006358:	6442                	ld	s0,16(sp)
    8000635a:	64a2                	ld	s1,8(sp)
    8000635c:	6105                	addi	sp,sp,32
    8000635e:	8082                	ret
    panic("release");
    80006360:	00002517          	auipc	a0,0x2
    80006364:	72050513          	addi	a0,a0,1824 # 80008a80 <digits+0x48>
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	9d4080e7          	jalr	-1580(ra) # 80005d3c <panic>
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
