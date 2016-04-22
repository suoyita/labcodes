
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 9c 9a 00 00       	call   c0109af2 <memset>

    cons_init();                // init the console
c0100056:	e8 87 15 00 00       	call   c01015e2 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 9c 10 c0 	movl   $0xc0109c80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 9c 10 c0 	movl   $0xc0109c9c,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 ac 52 00 00       	call   c0105330 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 37 1f 00 00       	call   c0101fc0 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 af 20 00 00       	call   c010213d <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 f8 78 00 00       	call   c010798b <vmm_init>
    proc_init();                // init process table
c0100093:	e8 50 8c 00 00       	call   c0108ce8 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 76 16 00 00       	call   c0101713 <ide_init>
    swap_init();                // init swap
c010009d:	e8 28 65 00 00       	call   c01065ca <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 f1 0c 00 00       	call   c0100d98 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 82 1e 00 00       	call   c0101f2e <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 f6 8d 00 00       	call   c0108ea7 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f7 0b 00 00       	call   c0100cca <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 a1 9c 10 c0 	movl   $0xc0109ca1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 af 9c 10 c0 	movl   $0xc0109caf,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 bd 9c 10 c0 	movl   $0xc0109cbd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 cb 9c 10 c0 	movl   $0xc0109ccb,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 d9 9c 10 c0 	movl   $0xc0109cd9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 e8 9c 10 c0 	movl   $0xc0109ce8,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 08 9d 10 c0 	movl   $0xc0109d08,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 27 9d 10 c0 	movl   $0xc0109d27,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 fd 12 00 00       	call   c010160e <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 e5 8e 00 00       	call   c0109233 <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 84 12 00 00       	call   c010160e <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 64 12 00 00       	call   c010164a <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 2c 9d 10 c0    	movl   $0xc0109d2c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 2c 9d 10 c0 	movl   $0xc0109d2c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 50 be 10 c0 	movl   $0xc010be50,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 54 d1 11 c0 	movl   $0xc011d154,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec 55 d1 11 c0 	movl   $0xc011d155,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 11 19 12 c0 	movl   $0xc0121911,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 63 92 00 00       	call   c0109966 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 36 9d 10 c0 	movl   $0xc0109d36,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 4f 9d 10 c0 	movl   $0xc0109d4f,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 7b 9c 10 	movl   $0xc0109c7b,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 67 9d 10 c0 	movl   $0xc0109d67,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 7f 9d 10 c0 	movl   $0xc0109d7f,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 97 9d 10 c0 	movl   $0xc0109d97,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 b0 9d 10 c0 	movl   $0xc0109db0,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 da 9d 10 c0 	movl   $0xc0109dda,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 f6 9d 10 c0 	movl   $0xc0109df6,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 8d 00 00 00       	jmp    c0100a83 <print_stackframe+0xb2>
		if (ebp == 0) break;
c01009f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009fa:	75 05                	jne    c0100a01 <print_stackframe+0x30>
c01009fc:	e9 8c 00 00 00       	jmp    c0100a8d <print_stackframe+0xbc>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0f:	c7 04 24 08 9e 10 c0 	movl   $0xc0109e08,(%esp)
c0100a16:	e8 38 f9 ff ff       	call   c0100353 <cprintf>
		int j;
		for (j = 0; j < 4; ++j) cprintf("0x%08x ", ((uint32_t *) ebp + 2)[j]);
c0100a1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a22:	eb 28                	jmp    c0100a4c <print_stackframe+0x7b>
c0100a24:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a31:	01 d0                	add    %edx,%eax
c0100a33:	83 c0 08             	add    $0x8,%eax
c0100a36:	8b 00                	mov    (%eax),%eax
c0100a38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3c:	c7 04 24 24 9e 10 c0 	movl   $0xc0109e24,(%esp)
c0100a43:	e8 0b f9 ff ff       	call   c0100353 <cprintf>
c0100a48:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a4c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a50:	7e d2                	jle    c0100a24 <print_stackframe+0x53>
		cprintf("\n");
c0100a52:	c7 04 24 2c 9e 10 c0 	movl   $0xc0109e2c,(%esp)
c0100a59:	e8 f5 f8 ff ff       	call   c0100353 <cprintf>
		print_debuginfo(eip - 1);
c0100a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a61:	83 e8 01             	sub    $0x1,%eax
c0100a64:	89 04 24             	mov    %eax,(%esp)
c0100a67:	e8 b1 fe ff ff       	call   c010091d <print_debuginfo>
		eip = *((uint32_t *) ebp + 1);
c0100a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6f:	83 c0 04             	add    $0x4,%eax
c0100a72:	8b 00                	mov    (%eax),%eax
c0100a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t *) ebp);
c0100a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7a:	8b 00                	mov    (%eax),%eax
c0100a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c0100a7f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a83:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a87:	0f 8e 69 ff ff ff    	jle    c01009f6 <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t *) ebp + 1);
		ebp = *((uint32_t *) ebp);
	}
}
c0100a8d:	c9                   	leave  
c0100a8e:	c3                   	ret    

c0100a8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a8f:	55                   	push   %ebp
c0100a90:	89 e5                	mov    %esp,%ebp
c0100a92:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9c:	eb 0c                	jmp    c0100aaa <parse+0x1b>
            *buf ++ = '\0';
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa4:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aad:	0f b6 00             	movzbl (%eax),%eax
c0100ab0:	84 c0                	test   %al,%al
c0100ab2:	74 1d                	je     c0100ad1 <parse+0x42>
c0100ab4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab7:	0f b6 00             	movzbl (%eax),%eax
c0100aba:	0f be c0             	movsbl %al,%eax
c0100abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac1:	c7 04 24 b0 9e 10 c0 	movl   $0xc0109eb0,(%esp)
c0100ac8:	e8 66 8e 00 00       	call   c0109933 <strchr>
c0100acd:	85 c0                	test   %eax,%eax
c0100acf:	75 cd                	jne    c0100a9e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad4:	0f b6 00             	movzbl (%eax),%eax
c0100ad7:	84 c0                	test   %al,%al
c0100ad9:	75 02                	jne    c0100add <parse+0x4e>
            break;
c0100adb:	eb 67                	jmp    c0100b44 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100add:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae1:	75 14                	jne    c0100af7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aea:	00 
c0100aeb:	c7 04 24 b5 9e 10 c0 	movl   $0xc0109eb5,(%esp)
c0100af2:	e8 5c f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afa:	8d 50 01             	lea    0x1(%eax),%edx
c0100afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b07:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0a:	01 c2                	add    %eax,%edx
c0100b0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b11:	eb 04                	jmp    c0100b17 <parse+0x88>
            buf ++;
c0100b13:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	84 c0                	test   %al,%al
c0100b1f:	74 1d                	je     c0100b3e <parse+0xaf>
c0100b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b24:	0f b6 00             	movzbl (%eax),%eax
c0100b27:	0f be c0             	movsbl %al,%eax
c0100b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2e:	c7 04 24 b0 9e 10 c0 	movl   $0xc0109eb0,(%esp)
c0100b35:	e8 f9 8d 00 00       	call   c0109933 <strchr>
c0100b3a:	85 c0                	test   %eax,%eax
c0100b3c:	74 d5                	je     c0100b13 <parse+0x84>
            buf ++;
        }
    }
c0100b3e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b3f:	e9 66 ff ff ff       	jmp    c0100aaa <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b47:	c9                   	leave  
c0100b48:	c3                   	ret    

c0100b49 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b49:	55                   	push   %ebp
c0100b4a:	89 e5                	mov    %esp,%ebp
c0100b4c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b4f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b59:	89 04 24             	mov    %eax,(%esp)
c0100b5c:	e8 2e ff ff ff       	call   c0100a8f <parse>
c0100b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b68:	75 0a                	jne    c0100b74 <runcmd+0x2b>
        return 0;
c0100b6a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b6f:	e9 85 00 00 00       	jmp    c0100bf9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7b:	eb 5c                	jmp    c0100bd9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b83:	89 d0                	mov    %edx,%eax
c0100b85:	01 c0                	add    %eax,%eax
c0100b87:	01 d0                	add    %edx,%eax
c0100b89:	c1 e0 02             	shl    $0x2,%eax
c0100b8c:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b91:	8b 00                	mov    (%eax),%eax
c0100b93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b97:	89 04 24             	mov    %eax,(%esp)
c0100b9a:	e8 f5 8c 00 00       	call   c0109894 <strcmp>
c0100b9f:	85 c0                	test   %eax,%eax
c0100ba1:	75 32                	jne    c0100bd5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba6:	89 d0                	mov    %edx,%eax
c0100ba8:	01 c0                	add    %eax,%eax
c0100baa:	01 d0                	add    %edx,%eax
c0100bac:	c1 e0 02             	shl    $0x2,%eax
c0100baf:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bb4:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bba:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc7:	83 c2 04             	add    $0x4,%edx
c0100bca:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bce:	89 0c 24             	mov    %ecx,(%esp)
c0100bd1:	ff d0                	call   *%eax
c0100bd3:	eb 24                	jmp    c0100bf9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdc:	83 f8 02             	cmp    $0x2,%eax
c0100bdf:	76 9c                	jbe    c0100b7d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be8:	c7 04 24 d3 9e 10 c0 	movl   $0xc0109ed3,(%esp)
c0100bef:	e8 5f f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf9:	c9                   	leave  
c0100bfa:	c3                   	ret    

c0100bfb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfb:	55                   	push   %ebp
c0100bfc:	89 e5                	mov    %esp,%ebp
c0100bfe:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c01:	c7 04 24 ec 9e 10 c0 	movl   $0xc0109eec,(%esp)
c0100c08:	e8 46 f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0d:	c7 04 24 14 9f 10 c0 	movl   $0xc0109f14,(%esp)
c0100c14:	e8 3a f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1d:	74 0b                	je     c0100c2a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	89 04 24             	mov    %eax,(%esp)
c0100c25:	e8 6a 16 00 00       	call   c0102294 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2a:	c7 04 24 39 9f 10 c0 	movl   $0xc0109f39,(%esp)
c0100c31:	e8 14 f6 ff ff       	call   c010024a <readline>
c0100c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3d:	74 18                	je     c0100c57 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c49:	89 04 24             	mov    %eax,(%esp)
c0100c4c:	e8 f8 fe ff ff       	call   c0100b49 <runcmd>
c0100c51:	85 c0                	test   %eax,%eax
c0100c53:	79 02                	jns    c0100c57 <kmonitor+0x5c>
                break;
c0100c55:	eb 02                	jmp    c0100c59 <kmonitor+0x5e>
            }
        }
    }
c0100c57:	eb d1                	jmp    c0100c2a <kmonitor+0x2f>
}
c0100c59:	c9                   	leave  
c0100c5a:	c3                   	ret    

c0100c5b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5b:	55                   	push   %ebp
c0100c5c:	89 e5                	mov    %esp,%ebp
c0100c5e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c68:	eb 3f                	jmp    c0100ca9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6d:	89 d0                	mov    %edx,%eax
c0100c6f:	01 c0                	add    %eax,%eax
c0100c71:	01 d0                	add    %edx,%eax
c0100c73:	c1 e0 02             	shl    $0x2,%eax
c0100c76:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c7b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c81:	89 d0                	mov    %edx,%eax
c0100c83:	01 c0                	add    %eax,%eax
c0100c85:	01 d0                	add    %edx,%eax
c0100c87:	c1 e0 02             	shl    $0x2,%eax
c0100c8a:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c8f:	8b 00                	mov    (%eax),%eax
c0100c91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c99:	c7 04 24 3d 9f 10 c0 	movl   $0xc0109f3d,(%esp)
c0100ca0:	e8 ae f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cac:	83 f8 02             	cmp    $0x2,%eax
c0100caf:	76 b9                	jbe    c0100c6a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb6:	c9                   	leave  
c0100cb7:	c3                   	ret    

c0100cb8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb8:	55                   	push   %ebp
c0100cb9:	89 e5                	mov    %esp,%ebp
c0100cbb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbe:	e8 c4 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc8:	c9                   	leave  
c0100cc9:	c3                   	ret    

c0100cca <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cca:	55                   	push   %ebp
c0100ccb:	89 e5                	mov    %esp,%ebp
c0100ccd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd0:	e8 fc fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cda:	c9                   	leave  
c0100cdb:	c3                   	ret    

c0100cdc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdc:	55                   	push   %ebp
c0100cdd:	89 e5                	mov    %esp,%ebp
c0100cdf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce2:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce7:	85 c0                	test   %eax,%eax
c0100ce9:	74 02                	je     c0100ced <__panic+0x11>
        goto panic_dead;
c0100ceb:	eb 48                	jmp    c0100d35 <__panic+0x59>
    }
    is_panic = 1;
c0100ced:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cf4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d00:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0b:	c7 04 24 46 9f 10 c0 	movl   $0xc0109f46,(%esp)
c0100d12:	e8 3c f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d21:	89 04 24             	mov    %eax,(%esp)
c0100d24:	e8 f7 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d29:	c7 04 24 62 9f 10 c0 	movl   $0xc0109f62,(%esp)
c0100d30:	e8 1e f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d35:	e8 fa 11 00 00       	call   c0101f34 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d41:	e8 b5 fe ff ff       	call   c0100bfb <kmonitor>
    }
c0100d46:	eb f2                	jmp    c0100d3a <__panic+0x5e>

c0100d48 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d48:	55                   	push   %ebp
c0100d49:	89 e5                	mov    %esp,%ebp
c0100d4b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d57:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d62:	c7 04 24 64 9f 10 c0 	movl   $0xc0109f64,(%esp)
c0100d69:	e8 e5 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d75:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d78:	89 04 24             	mov    %eax,(%esp)
c0100d7b:	e8 a0 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d80:	c7 04 24 62 9f 10 c0 	movl   $0xc0109f62,(%esp)
c0100d87:	e8 c7 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d8c:	c9                   	leave  
c0100d8d:	c3                   	ret    

c0100d8e <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8e:	55                   	push   %ebp
c0100d8f:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d91:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d96:	5d                   	pop    %ebp
c0100d97:	c3                   	ret    

c0100d98 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d98:	55                   	push   %ebp
c0100d99:	89 e5                	mov    %esp,%ebp
c0100d9b:	83 ec 28             	sub    $0x28,%esp
c0100d9e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dac:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db0:	ee                   	out    %al,(%dx)
c0100db1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dbf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc3:	ee                   	out    %al,(%dx)
c0100dc4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dca:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dce:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd7:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100dde:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de1:	c7 04 24 82 9f 10 c0 	movl   $0xc0109f82,(%esp)
c0100de8:	e8 66 f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ded:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df4:	e8 99 11 00 00       	call   c0101f92 <pic_enable>
}
c0100df9:	c9                   	leave  
c0100dfa:	c3                   	ret    

c0100dfb <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfb:	55                   	push   %ebp
c0100dfc:	89 e5                	mov    %esp,%ebp
c0100dfe:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e01:	9c                   	pushf  
c0100e02:	58                   	pop    %eax
c0100e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e09:	25 00 02 00 00       	and    $0x200,%eax
c0100e0e:	85 c0                	test   %eax,%eax
c0100e10:	74 0c                	je     c0100e1e <__intr_save+0x23>
        intr_disable();
c0100e12:	e8 1d 11 00 00       	call   c0101f34 <intr_disable>
        return 1;
c0100e17:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1c:	eb 05                	jmp    c0100e23 <__intr_save+0x28>
    }
    return 0;
c0100e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e23:	c9                   	leave  
c0100e24:	c3                   	ret    

c0100e25 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e25:	55                   	push   %ebp
c0100e26:	89 e5                	mov    %esp,%ebp
c0100e28:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e2f:	74 05                	je     c0100e36 <__intr_restore+0x11>
        intr_enable();
c0100e31:	e8 f8 10 00 00       	call   c0101f2e <intr_enable>
    }
}
c0100e36:	c9                   	leave  
c0100e37:	c3                   	ret    

c0100e38 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e38:	55                   	push   %ebp
c0100e39:	89 e5                	mov    %esp,%ebp
c0100e3b:	83 ec 10             	sub    $0x10,%esp
c0100e3e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e44:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e48:	89 c2                	mov    %eax,%edx
c0100e4a:	ec                   	in     (%dx),%al
c0100e4b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e54:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e58:	89 c2                	mov    %eax,%edx
c0100e5a:	ec                   	in     (%dx),%al
c0100e5b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e64:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e68:	89 c2                	mov    %eax,%edx
c0100e6a:	ec                   	in     (%dx),%al
c0100e6b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e74:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e78:	89 c2                	mov    %eax,%edx
c0100e7a:	ec                   	in     (%dx),%al
c0100e7b:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7e:	c9                   	leave  
c0100e7f:	c3                   	ret    

c0100e80 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e80:	55                   	push   %ebp
c0100e81:	89 e5                	mov    %esp,%ebp
c0100e83:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e86:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e90:	0f b7 00             	movzwl (%eax),%eax
c0100e93:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea2:	0f b7 00             	movzwl (%eax),%eax
c0100ea5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea9:	74 12                	je     c0100ebd <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eab:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb2:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eb9:	b4 03 
c0100ebb:	eb 13                	jmp    c0100ed0 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec7:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ece:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed0:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed7:	0f b7 c0             	movzwl %ax,%eax
c0100eda:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ede:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eeb:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef2:	83 c0 01             	add    $0x1,%eax
c0100ef5:	0f b7 c0             	movzwl %ax,%eax
c0100ef8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efc:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f00:	89 c2                	mov    %eax,%edx
c0100f02:	ec                   	in     (%dx),%al
c0100f03:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0a:	0f b6 c0             	movzbl %al,%eax
c0100f0d:	c1 e0 08             	shl    $0x8,%eax
c0100f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f13:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f1a:	0f b7 c0             	movzwl %ax,%eax
c0100f1d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f21:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f25:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f29:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f35:	83 c0 01             	add    $0x1,%eax
c0100f38:	0f b7 c0             	movzwl %ax,%eax
c0100f3b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f43:	89 c2                	mov    %eax,%edx
c0100f45:	ec                   	in     (%dx),%al
c0100f46:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f49:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4d:	0f b6 c0             	movzbl %al,%eax
c0100f50:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f53:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f56:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5e:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f64:	c9                   	leave  
c0100f65:	c3                   	ret    

c0100f66 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f66:	55                   	push   %ebp
c0100f67:	89 e5                	mov    %esp,%ebp
c0100f69:	83 ec 48             	sub    $0x48,%esp
c0100f6c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f72:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f76:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7e:	ee                   	out    %al,(%dx)
c0100f7f:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f85:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f89:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f91:	ee                   	out    %al,(%dx)
c0100f92:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f98:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa4:	ee                   	out    %al,(%dx)
c0100fa5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fab:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100faf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb7:	ee                   	out    %al,(%dx)
c0100fb8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbe:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fca:	ee                   	out    %al,(%dx)
c0100fcb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd1:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd9:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fdd:	ee                   	out    %al,(%dx)
c0100fde:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe4:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fec:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff0:	ee                   	out    %al,(%dx)
c0100ff1:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff7:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffb:	89 c2                	mov    %eax,%edx
c0100ffd:	ec                   	in     (%dx),%al
c0100ffe:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101001:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101005:	3c ff                	cmp    $0xff,%al
c0101007:	0f 95 c0             	setne  %al
c010100a:	0f b6 c0             	movzbl %al,%eax
c010100d:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c0101012:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101018:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101c:	89 c2                	mov    %eax,%edx
c010101e:	ec                   	in     (%dx),%al
c010101f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101022:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101028:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102c:	89 c2                	mov    %eax,%edx
c010102e:	ec                   	in     (%dx),%al
c010102f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101032:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101037:	85 c0                	test   %eax,%eax
c0101039:	74 0c                	je     c0101047 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101042:	e8 4b 0f 00 00       	call   c0101f92 <pic_enable>
    }
}
c0101047:	c9                   	leave  
c0101048:	c3                   	ret    

c0101049 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101049:	55                   	push   %ebp
c010104a:	89 e5                	mov    %esp,%ebp
c010104c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101056:	eb 09                	jmp    c0101061 <lpt_putc_sub+0x18>
        delay();
c0101058:	e8 db fd ff ff       	call   c0100e38 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101061:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101067:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106b:	89 c2                	mov    %eax,%edx
c010106d:	ec                   	in     (%dx),%al
c010106e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101071:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101075:	84 c0                	test   %al,%al
c0101077:	78 09                	js     c0101082 <lpt_putc_sub+0x39>
c0101079:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101080:	7e d6                	jle    c0101058 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101082:	8b 45 08             	mov    0x8(%ebp),%eax
c0101085:	0f b6 c0             	movzbl %al,%eax
c0101088:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101091:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101095:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101099:	ee                   	out    %al,(%dx)
c010109a:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ac:	ee                   	out    %al,(%dx)
c01010ad:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010bf:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c0:	c9                   	leave  
c01010c1:	c3                   	ret    

c01010c2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c2:	55                   	push   %ebp
c01010c3:	89 e5                	mov    %esp,%ebp
c01010c5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cc:	74 0d                	je     c01010db <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d1:	89 04 24             	mov    %eax,(%esp)
c01010d4:	e8 70 ff ff ff       	call   c0101049 <lpt_putc_sub>
c01010d9:	eb 24                	jmp    c01010ff <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e2:	e8 62 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ee:	e8 56 ff ff ff       	call   c0101049 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fa:	e8 4a ff ff ff       	call   c0101049 <lpt_putc_sub>
    }
}
c01010ff:	c9                   	leave  
c0101100:	c3                   	ret    

c0101101 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101101:	55                   	push   %ebp
c0101102:	89 e5                	mov    %esp,%ebp
c0101104:	53                   	push   %ebx
c0101105:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	b0 00                	mov    $0x0,%al
c010110d:	85 c0                	test   %eax,%eax
c010110f:	75 07                	jne    c0101118 <cga_putc+0x17>
        c |= 0x0700;
c0101111:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101118:	8b 45 08             	mov    0x8(%ebp),%eax
c010111b:	0f b6 c0             	movzbl %al,%eax
c010111e:	83 f8 0a             	cmp    $0xa,%eax
c0101121:	74 4c                	je     c010116f <cga_putc+0x6e>
c0101123:	83 f8 0d             	cmp    $0xd,%eax
c0101126:	74 57                	je     c010117f <cga_putc+0x7e>
c0101128:	83 f8 08             	cmp    $0x8,%eax
c010112b:	0f 85 88 00 00 00    	jne    c01011b9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101131:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101138:	66 85 c0             	test   %ax,%ax
c010113b:	74 30                	je     c010116d <cga_putc+0x6c>
            crt_pos --;
c010113d:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101144:	83 e8 01             	sub    $0x1,%eax
c0101147:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114d:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101152:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c0101159:	0f b7 d2             	movzwl %dx,%edx
c010115c:	01 d2                	add    %edx,%edx
c010115e:	01 c2                	add    %eax,%edx
c0101160:	8b 45 08             	mov    0x8(%ebp),%eax
c0101163:	b0 00                	mov    $0x0,%al
c0101165:	83 c8 20             	or     $0x20,%eax
c0101168:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116b:	eb 72                	jmp    c01011df <cga_putc+0xde>
c010116d:	eb 70                	jmp    c01011df <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010116f:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101176:	83 c0 50             	add    $0x50,%eax
c0101179:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010117f:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101186:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c010118d:	0f b7 c1             	movzwl %cx,%eax
c0101190:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101196:	c1 e8 10             	shr    $0x10,%eax
c0101199:	89 c2                	mov    %eax,%edx
c010119b:	66 c1 ea 06          	shr    $0x6,%dx
c010119f:	89 d0                	mov    %edx,%eax
c01011a1:	c1 e0 02             	shl    $0x2,%eax
c01011a4:	01 d0                	add    %edx,%eax
c01011a6:	c1 e0 04             	shl    $0x4,%eax
c01011a9:	29 c1                	sub    %eax,%ecx
c01011ab:	89 ca                	mov    %ecx,%edx
c01011ad:	89 d8                	mov    %ebx,%eax
c01011af:	29 d0                	sub    %edx,%eax
c01011b1:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b7:	eb 26                	jmp    c01011df <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b9:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011bf:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c6:	8d 50 01             	lea    0x1(%eax),%edx
c01011c9:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011d0:	0f b7 c0             	movzwl %ax,%eax
c01011d3:	01 c0                	add    %eax,%eax
c01011d5:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01011db:	66 89 02             	mov    %ax,(%edx)
        break;
c01011de:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011df:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e6:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011ea:	76 5b                	jbe    c0101247 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ec:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f7:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011fc:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101203:	00 
c0101204:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101208:	89 04 24             	mov    %eax,(%esp)
c010120b:	e8 21 89 00 00       	call   c0109b31 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101210:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101217:	eb 15                	jmp    c010122e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101219:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010121e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101221:	01 d2                	add    %edx,%edx
c0101223:	01 d0                	add    %edx,%eax
c0101225:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101235:	7e e2                	jle    c0101219 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101237:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010123e:	83 e8 50             	sub    $0x50,%eax
c0101241:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101247:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010124e:	0f b7 c0             	movzwl %ax,%eax
c0101251:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101255:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101259:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101261:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101262:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101269:	66 c1 e8 08          	shr    $0x8,%ax
c010126d:	0f b6 c0             	movzbl %al,%eax
c0101270:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101277:	83 c2 01             	add    $0x1,%edx
c010127a:	0f b7 d2             	movzwl %dx,%edx
c010127d:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101281:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101284:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101288:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128c:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128d:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101294:	0f b7 c0             	movzwl %ax,%eax
c0101297:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010129f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a8:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012af:	0f b6 c0             	movzbl %al,%eax
c01012b2:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012b9:	83 c2 01             	add    $0x1,%edx
c01012bc:	0f b7 d2             	movzwl %dx,%edx
c01012bf:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012ca:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012ce:	ee                   	out    %al,(%dx)
}
c01012cf:	83 c4 34             	add    $0x34,%esp
c01012d2:	5b                   	pop    %ebx
c01012d3:	5d                   	pop    %ebp
c01012d4:	c3                   	ret    

c01012d5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d5:	55                   	push   %ebp
c01012d6:	89 e5                	mov    %esp,%ebp
c01012d8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e2:	eb 09                	jmp    c01012ed <serial_putc_sub+0x18>
        delay();
c01012e4:	e8 4f fb ff ff       	call   c0100e38 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ed:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f7:	89 c2                	mov    %eax,%edx
c01012f9:	ec                   	in     (%dx),%al
c01012fa:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	83 e0 20             	and    $0x20,%eax
c0101307:	85 c0                	test   %eax,%eax
c0101309:	75 09                	jne    c0101314 <serial_putc_sub+0x3f>
c010130b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101312:	7e d0                	jle    c01012e4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101314:	8b 45 08             	mov    0x8(%ebp),%eax
c0101317:	0f b6 c0             	movzbl %al,%eax
c010131a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101320:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101327:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132b:	ee                   	out    %al,(%dx)
}
c010132c:	c9                   	leave  
c010132d:	c3                   	ret    

c010132e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132e:	55                   	push   %ebp
c010132f:	89 e5                	mov    %esp,%ebp
c0101331:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101334:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101338:	74 0d                	je     c0101347 <serial_putc+0x19>
        serial_putc_sub(c);
c010133a:	8b 45 08             	mov    0x8(%ebp),%eax
c010133d:	89 04 24             	mov    %eax,(%esp)
c0101340:	e8 90 ff ff ff       	call   c01012d5 <serial_putc_sub>
c0101345:	eb 24                	jmp    c010136b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101347:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134e:	e8 82 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub(' ');
c0101353:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135a:	e8 76 ff ff ff       	call   c01012d5 <serial_putc_sub>
        serial_putc_sub('\b');
c010135f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101366:	e8 6a ff ff ff       	call   c01012d5 <serial_putc_sub>
    }
}
c010136b:	c9                   	leave  
c010136c:	c3                   	ret    

c010136d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136d:	55                   	push   %ebp
c010136e:	89 e5                	mov    %esp,%ebp
c0101370:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101373:	eb 33                	jmp    c01013a8 <cons_intr+0x3b>
        if (c != 0) {
c0101375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101379:	74 2d                	je     c01013a8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137b:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101380:	8d 50 01             	lea    0x1(%eax),%edx
c0101383:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c0101389:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138c:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101392:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101397:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139c:	75 0a                	jne    c01013a8 <cons_intr+0x3b>
                cons.wpos = 0;
c010139e:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ab:	ff d0                	call   *%eax
c01013ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b4:	75 bf                	jne    c0101375 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b6:	c9                   	leave  
c01013b7:	c3                   	ret    

c01013b8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b8:	55                   	push   %ebp
c01013b9:	89 e5                	mov    %esp,%ebp
c01013bb:	83 ec 10             	sub    $0x10,%esp
c01013be:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c8:	89 c2                	mov    %eax,%edx
c01013ca:	ec                   	in     (%dx),%al
c01013cb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013ce:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d2:	0f b6 c0             	movzbl %al,%eax
c01013d5:	83 e0 01             	and    $0x1,%eax
c01013d8:	85 c0                	test   %eax,%eax
c01013da:	75 07                	jne    c01013e3 <serial_proc_data+0x2b>
        return -1;
c01013dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e1:	eb 2a                	jmp    c010140d <serial_proc_data+0x55>
c01013e3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ed:	89 c2                	mov    %eax,%edx
c01013ef:	ec                   	in     (%dx),%al
c01013f0:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f7:	0f b6 c0             	movzbl %al,%eax
c01013fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fd:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101401:	75 07                	jne    c010140a <serial_proc_data+0x52>
        c = '\b';
c0101403:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140d:	c9                   	leave  
c010140e:	c3                   	ret    

c010140f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010140f:	55                   	push   %ebp
c0101410:	89 e5                	mov    %esp,%ebp
c0101412:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101415:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c010141a:	85 c0                	test   %eax,%eax
c010141c:	74 0c                	je     c010142a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141e:	c7 04 24 b8 13 10 c0 	movl   $0xc01013b8,(%esp)
c0101425:	e8 43 ff ff ff       	call   c010136d <cons_intr>
    }
}
c010142a:	c9                   	leave  
c010142b:	c3                   	ret    

c010142c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 38             	sub    $0x38,%esp
c0101432:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101438:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143c:	89 c2                	mov    %eax,%edx
c010143e:	ec                   	in     (%dx),%al
c010143f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101442:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101446:	0f b6 c0             	movzbl %al,%eax
c0101449:	83 e0 01             	and    $0x1,%eax
c010144c:	85 c0                	test   %eax,%eax
c010144e:	75 0a                	jne    c010145a <kbd_proc_data+0x2e>
        return -1;
c0101450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101455:	e9 59 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
c010145a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101460:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101464:	89 c2                	mov    %eax,%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101471:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101475:	75 17                	jne    c010148e <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101477:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010147c:	83 c8 40             	or     $0x40,%eax
c010147f:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c0101484:	b8 00 00 00 00       	mov    $0x0,%eax
c0101489:	e9 25 01 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101492:	84 c0                	test   %al,%al
c0101494:	79 47                	jns    c01014dd <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101496:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010149b:	83 e0 40             	and    $0x40,%eax
c010149e:	85 c0                	test   %eax,%eax
c01014a0:	75 09                	jne    c01014ab <kbd_proc_data+0x7f>
c01014a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a6:	83 e0 7f             	and    $0x7f,%eax
c01014a9:	eb 04                	jmp    c01014af <kbd_proc_data+0x83>
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b6:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014bd:	83 c8 40             	or     $0x40,%eax
c01014c0:	0f b6 c0             	movzbl %al,%eax
c01014c3:	f7 d0                	not    %eax
c01014c5:	89 c2                	mov    %eax,%edx
c01014c7:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014cc:	21 d0                	and    %edx,%eax
c01014ce:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d8:	e9 d6 00 00 00       	jmp    c01015b3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014dd:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e2:	83 e0 40             	and    $0x40,%eax
c01014e5:	85 c0                	test   %eax,%eax
c01014e7:	74 11                	je     c01014fa <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e9:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ed:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014f2:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f5:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014fa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014fe:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101505:	0f b6 d0             	movzbl %al,%edx
c0101508:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150d:	09 d0                	or     %edx,%eax
c010150f:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101518:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c010151f:	0f b6 d0             	movzbl %al,%edx
c0101522:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101527:	31 d0                	xor    %edx,%eax
c0101529:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010152e:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101533:	83 e0 03             	and    $0x3,%eax
c0101536:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c010153d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101541:	01 d0                	add    %edx,%eax
c0101543:	0f b6 00             	movzbl (%eax),%eax
c0101546:	0f b6 c0             	movzbl %al,%eax
c0101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154c:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101551:	83 e0 08             	and    $0x8,%eax
c0101554:	85 c0                	test   %eax,%eax
c0101556:	74 22                	je     c010157a <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101558:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155c:	7e 0c                	jle    c010156a <kbd_proc_data+0x13e>
c010155e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101562:	7f 06                	jg     c010156a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101564:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101568:	eb 10                	jmp    c010157a <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156e:	7e 0a                	jle    c010157a <kbd_proc_data+0x14e>
c0101570:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101574:	7f 04                	jg     c010157a <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101576:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157a:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010157f:	f7 d0                	not    %eax
c0101581:	83 e0 06             	and    $0x6,%eax
c0101584:	85 c0                	test   %eax,%eax
c0101586:	75 28                	jne    c01015b0 <kbd_proc_data+0x184>
c0101588:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010158f:	75 1f                	jne    c01015b0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101591:	c7 04 24 9d 9f 10 c0 	movl   $0xc0109f9d,(%esp)
c0101598:	e8 b6 ed ff ff       	call   c0100353 <cprintf>
c010159d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ab:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015af:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b3:	c9                   	leave  
c01015b4:	c3                   	ret    

c01015b5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b5:	55                   	push   %ebp
c01015b6:	89 e5                	mov    %esp,%ebp
c01015b8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bb:	c7 04 24 2c 14 10 c0 	movl   $0xc010142c,(%esp)
c01015c2:	e8 a6 fd ff ff       	call   c010136d <cons_intr>
}
c01015c7:	c9                   	leave  
c01015c8:	c3                   	ret    

c01015c9 <kbd_init>:

static void
kbd_init(void) {
c01015c9:	55                   	push   %ebp
c01015ca:	89 e5                	mov    %esp,%ebp
c01015cc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cf:	e8 e1 ff ff ff       	call   c01015b5 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015db:	e8 b2 09 00 00       	call   c0101f92 <pic_enable>
}
c01015e0:	c9                   	leave  
c01015e1:	c3                   	ret    

c01015e2 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e2:	55                   	push   %ebp
c01015e3:	89 e5                	mov    %esp,%ebp
c01015e5:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e8:	e8 93 f8 ff ff       	call   c0100e80 <cga_init>
    serial_init();
c01015ed:	e8 74 f9 ff ff       	call   c0100f66 <serial_init>
    kbd_init();
c01015f2:	e8 d2 ff ff ff       	call   c01015c9 <kbd_init>
    if (!serial_exists) {
c01015f7:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015fc:	85 c0                	test   %eax,%eax
c01015fe:	75 0c                	jne    c010160c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101600:	c7 04 24 a9 9f 10 c0 	movl   $0xc0109fa9,(%esp)
c0101607:	e8 47 ed ff ff       	call   c0100353 <cprintf>
    }
}
c010160c:	c9                   	leave  
c010160d:	c3                   	ret    

c010160e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160e:	55                   	push   %ebp
c010160f:	89 e5                	mov    %esp,%ebp
c0101611:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101614:	e8 e2 f7 ff ff       	call   c0100dfb <__intr_save>
c0101619:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 9b fa ff ff       	call   c01010c2 <lpt_putc>
        cga_putc(c);
c0101627:	8b 45 08             	mov    0x8(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 cf fa ff ff       	call   c0101101 <cga_putc>
        serial_putc(c);
c0101632:	8b 45 08             	mov    0x8(%ebp),%eax
c0101635:	89 04 24             	mov    %eax,(%esp)
c0101638:	e8 f1 fc ff ff       	call   c010132e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101640:	89 04 24             	mov    %eax,(%esp)
c0101643:	e8 dd f7 ff ff       	call   c0100e25 <__intr_restore>
}
c0101648:	c9                   	leave  
c0101649:	c3                   	ret    

c010164a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164a:	55                   	push   %ebp
c010164b:	89 e5                	mov    %esp,%ebp
c010164d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101650:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101657:	e8 9f f7 ff ff       	call   c0100dfb <__intr_save>
c010165c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010165f:	e8 ab fd ff ff       	call   c010140f <serial_intr>
        kbd_intr();
c0101664:	e8 4c ff ff ff       	call   c01015b5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101669:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c010166f:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101674:	39 c2                	cmp    %eax,%edx
c0101676:	74 31                	je     c01016a9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101678:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c010167d:	8d 50 01             	lea    0x1(%eax),%edx
c0101680:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101686:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c010168d:	0f b6 c0             	movzbl %al,%eax
c0101690:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101693:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101698:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169d:	75 0a                	jne    c01016a9 <cons_getc+0x5f>
                cons.rpos = 0;
c010169f:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ac:	89 04 24             	mov    %eax,(%esp)
c01016af:	e8 71 f7 ff ff       	call   c0100e25 <__intr_restore>
    return c;
c01016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b7:	c9                   	leave  
c01016b8:	c3                   	ret    

c01016b9 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b9:	55                   	push   %ebp
c01016ba:	89 e5                	mov    %esp,%ebp
c01016bc:	83 ec 14             	sub    $0x14,%esp
c01016bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c6:	90                   	nop
c01016c7:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cb:	83 c0 07             	add    $0x7,%eax
c01016ce:	0f b7 c0             	movzwl %ax,%eax
c01016d1:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d9:	89 c2                	mov    %eax,%edx
c01016db:	ec                   	in     (%dx),%al
c01016dc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e3:	0f b6 c0             	movzbl %al,%eax
c01016e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ec:	25 80 00 00 00       	and    $0x80,%eax
c01016f1:	85 c0                	test   %eax,%eax
c01016f3:	75 d2                	jne    c01016c7 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f9:	74 11                	je     c010170c <ide_wait_ready+0x53>
c01016fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016fe:	83 e0 21             	and    $0x21,%eax
c0101701:	85 c0                	test   %eax,%eax
c0101703:	74 07                	je     c010170c <ide_wait_ready+0x53>
        return -1;
c0101705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170a:	eb 05                	jmp    c0101711 <ide_wait_ready+0x58>
    }
    return 0;
c010170c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101711:	c9                   	leave  
c0101712:	c3                   	ret    

c0101713 <ide_init>:

void
ide_init(void) {
c0101713:	55                   	push   %ebp
c0101714:	89 e5                	mov    %esp,%ebp
c0101716:	57                   	push   %edi
c0101717:	53                   	push   %ebx
c0101718:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171e:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101724:	e9 d6 02 00 00       	jmp    c01019ff <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101729:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172d:	c1 e0 03             	shl    $0x3,%eax
c0101730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101737:	29 c2                	sub    %eax,%edx
c0101739:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010173f:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101742:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101746:	66 d1 e8             	shr    %ax
c0101749:	0f b7 c0             	movzwl %ax,%eax
c010174c:	0f b7 04 85 c8 9f 10 	movzwl -0x3fef6038(,%eax,4),%eax
c0101753:	c0 
c0101754:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101758:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101763:	00 
c0101764:	89 04 24             	mov    %eax,(%esp)
c0101767:	e8 4d ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101770:	83 e0 01             	and    $0x1,%eax
c0101773:	c1 e0 04             	shl    $0x4,%eax
c0101776:	83 c8 e0             	or     $0xffffffe0,%eax
c0101779:	0f b6 c0             	movzbl %al,%eax
c010177c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101780:	83 c2 06             	add    $0x6,%edx
c0101783:	0f b7 d2             	movzwl %dx,%edx
c0101786:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178a:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101791:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101796:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a1:	00 
c01017a2:	89 04 24             	mov    %eax,(%esp)
c01017a5:	e8 0f ff ff ff       	call   c01016b9 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017aa:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ae:	83 c0 07             	add    $0x7,%eax
c01017b1:	0f b7 c0             	movzwl %ax,%eax
c01017b4:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b8:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d0:	00 
c01017d1:	89 04 24             	mov    %eax,(%esp)
c01017d4:	e8 e0 fe ff ff       	call   c01016b9 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d9:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017dd:	83 c0 07             	add    $0x7,%eax
c01017e0:	0f b7 c0             	movzwl %ax,%eax
c01017e3:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e7:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017eb:	89 c2                	mov    %eax,%edx
c01017ed:	ec                   	in     (%dx),%al
c01017ee:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f5:	84 c0                	test   %al,%al
c01017f7:	0f 84 f7 01 00 00    	je     c01019f4 <ide_init+0x2e1>
c01017fd:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101801:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101808:	00 
c0101809:	89 04 24             	mov    %eax,(%esp)
c010180c:	e8 a8 fe ff ff       	call   c01016b9 <ide_wait_ready>
c0101811:	85 c0                	test   %eax,%eax
c0101813:	0f 85 db 01 00 00    	jne    c01019f4 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101819:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181d:	c1 e0 03             	shl    $0x3,%eax
c0101820:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101827:	29 c2                	sub    %eax,%edx
c0101829:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c010182f:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101832:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101836:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101839:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010183f:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101842:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101849:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010184f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101852:	89 cb                	mov    %ecx,%ebx
c0101854:	89 df                	mov    %ebx,%edi
c0101856:	89 c1                	mov    %eax,%ecx
c0101858:	fc                   	cld    
c0101859:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185b:	89 c8                	mov    %ecx,%eax
c010185d:	89 fb                	mov    %edi,%ebx
c010185f:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101862:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101865:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101871:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101877:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187d:	25 00 00 00 04       	and    $0x4000000,%eax
c0101882:	85 c0                	test   %eax,%eax
c0101884:	74 0e                	je     c0101894 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101889:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010188f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101892:	eb 09                	jmp    c010189d <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101897:	8b 40 78             	mov    0x78(%eax),%eax
c010189a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a1:	c1 e0 03             	shl    $0x3,%eax
c01018a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ab:	29 c2                	sub    %eax,%edx
c01018ad:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b6:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018bd:	c1 e0 03             	shl    $0x3,%eax
c01018c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c7:	29 c2                	sub    %eax,%edx
c01018c9:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d2:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d8:	83 c0 62             	add    $0x62,%eax
c01018db:	0f b7 00             	movzwl (%eax),%eax
c01018de:	0f b7 c0             	movzwl %ax,%eax
c01018e1:	25 00 02 00 00       	and    $0x200,%eax
c01018e6:	85 c0                	test   %eax,%eax
c01018e8:	75 24                	jne    c010190e <ide_init+0x1fb>
c01018ea:	c7 44 24 0c d0 9f 10 	movl   $0xc0109fd0,0xc(%esp)
c01018f1:	c0 
c01018f2:	c7 44 24 08 13 a0 10 	movl   $0xc010a013,0x8(%esp)
c01018f9:	c0 
c01018fa:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101901:	00 
c0101902:	c7 04 24 28 a0 10 c0 	movl   $0xc010a028,(%esp)
c0101909:	e8 ce f3 ff ff       	call   c0100cdc <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101912:	c1 e0 03             	shl    $0x3,%eax
c0101915:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191c:	29 c2                	sub    %eax,%edx
c010191e:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101924:	83 c0 0c             	add    $0xc,%eax
c0101927:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192d:	83 c0 36             	add    $0x36,%eax
c0101930:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101933:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101941:	eb 34                	jmp    c0101977 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101946:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101949:	01 c2                	add    %eax,%edx
c010194b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194e:	8d 48 01             	lea    0x1(%eax),%ecx
c0101951:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101954:	01 c8                	add    %ecx,%eax
c0101956:	0f b6 00             	movzbl (%eax),%eax
c0101959:	88 02                	mov    %al,(%edx)
c010195b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195e:	8d 50 01             	lea    0x1(%eax),%edx
c0101961:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101964:	01 c2                	add    %eax,%edx
c0101966:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101969:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196c:	01 c8                	add    %ecx,%eax
c010196e:	0f b6 00             	movzbl (%eax),%eax
c0101971:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101973:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197d:	72 c4                	jb     c0101943 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c010197f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101982:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101985:	01 d0                	add    %edx,%eax
c0101987:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101990:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101993:	85 c0                	test   %eax,%eax
c0101995:	74 0f                	je     c01019a6 <ide_init+0x293>
c0101997:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199d:	01 d0                	add    %edx,%eax
c010199f:	0f b6 00             	movzbl (%eax),%eax
c01019a2:	3c 20                	cmp    $0x20,%al
c01019a4:	74 d9                	je     c010197f <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019aa:	c1 e0 03             	shl    $0x3,%eax
c01019ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b4:	29 c2                	sub    %eax,%edx
c01019b6:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019bc:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019bf:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c3:	c1 e0 03             	shl    $0x3,%eax
c01019c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019cd:	29 c2                	sub    %eax,%edx
c01019cf:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d5:	8b 50 08             	mov    0x8(%eax),%edx
c01019d8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e8:	c7 04 24 3a a0 10 c0 	movl   $0xc010a03a,(%esp)
c01019ef:	e8 5f e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f8:	83 c0 01             	add    $0x1,%eax
c01019fb:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019ff:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a04:	0f 86 1f fd ff ff    	jbe    c0101729 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0a:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a11:	e8 7c 05 00 00       	call   c0101f92 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a16:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1d:	e8 70 05 00 00       	call   c0101f92 <pic_enable>
}
c0101a22:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a28:	5b                   	pop    %ebx
c0101a29:	5f                   	pop    %edi
c0101a2a:	5d                   	pop    %ebp
c0101a2b:	c3                   	ret    

c0101a2c <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2c:	55                   	push   %ebp
c0101a2d:	89 e5                	mov    %esp,%ebp
c0101a2f:	83 ec 04             	sub    $0x4,%esp
c0101a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a35:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a39:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3e:	77 24                	ja     c0101a64 <ide_device_valid+0x38>
c0101a40:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a44:	c1 e0 03             	shl    $0x3,%eax
c0101a47:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4e:	29 c2                	sub    %eax,%edx
c0101a50:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a56:	0f b6 00             	movzbl (%eax),%eax
c0101a59:	84 c0                	test   %al,%al
c0101a5b:	74 07                	je     c0101a64 <ide_device_valid+0x38>
c0101a5d:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a62:	eb 05                	jmp    c0101a69 <ide_device_valid+0x3d>
c0101a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a69:	c9                   	leave  
c0101a6a:	c3                   	ret    

c0101a6b <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6b:	55                   	push   %ebp
c0101a6c:	89 e5                	mov    %esp,%ebp
c0101a6e:	83 ec 08             	sub    $0x8,%esp
c0101a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a78:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7c:	89 04 24             	mov    %eax,(%esp)
c0101a7f:	e8 a8 ff ff ff       	call   c0101a2c <ide_device_valid>
c0101a84:	85 c0                	test   %eax,%eax
c0101a86:	74 1b                	je     c0101aa3 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a88:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8c:	c1 e0 03             	shl    $0x3,%eax
c0101a8f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a96:	29 c2                	sub    %eax,%edx
c0101a98:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a9e:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa1:	eb 05                	jmp    c0101aa8 <ide_device_size+0x3d>
    }
    return 0;
c0101aa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa8:	c9                   	leave  
c0101aa9:	c3                   	ret    

c0101aaa <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aaa:	55                   	push   %ebp
c0101aab:	89 e5                	mov    %esp,%ebp
c0101aad:	57                   	push   %edi
c0101aae:	53                   	push   %ebx
c0101aaf:	83 ec 50             	sub    $0x50,%esp
c0101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac0:	77 24                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac7:	77 1d                	ja     c0101ae6 <ide_read_secs+0x3c>
c0101ac9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101acd:	c1 e0 03             	shl    $0x3,%eax
c0101ad0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad7:	29 c2                	sub    %eax,%edx
c0101ad9:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101adf:	0f b6 00             	movzbl (%eax),%eax
c0101ae2:	84 c0                	test   %al,%al
c0101ae4:	75 24                	jne    c0101b0a <ide_read_secs+0x60>
c0101ae6:	c7 44 24 0c 58 a0 10 	movl   $0xc010a058,0xc(%esp)
c0101aed:	c0 
c0101aee:	c7 44 24 08 13 a0 10 	movl   $0xc010a013,0x8(%esp)
c0101af5:	c0 
c0101af6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afd:	00 
c0101afe:	c7 04 24 28 a0 10 c0 	movl   $0xc010a028,(%esp)
c0101b05:	e8 d2 f1 ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0a:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b11:	77 0f                	ja     c0101b22 <ide_read_secs+0x78>
c0101b13:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b16:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b19:	01 d0                	add    %edx,%eax
c0101b1b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b20:	76 24                	jbe    c0101b46 <ide_read_secs+0x9c>
c0101b22:	c7 44 24 0c 80 a0 10 	movl   $0xc010a080,0xc(%esp)
c0101b29:	c0 
c0101b2a:	c7 44 24 08 13 a0 10 	movl   $0xc010a013,0x8(%esp)
c0101b31:	c0 
c0101b32:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b39:	00 
c0101b3a:	c7 04 24 28 a0 10 c0 	movl   $0xc010a028,(%esp)
c0101b41:	e8 96 f1 ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b46:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4a:	66 d1 e8             	shr    %ax
c0101b4d:	0f b7 c0             	movzwl %ax,%eax
c0101b50:	0f b7 04 85 c8 9f 10 	movzwl -0x3fef6038(,%eax,4),%eax
c0101b57:	c0 
c0101b58:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b60:	66 d1 e8             	shr    %ax
c0101b63:	0f b7 c0             	movzwl %ax,%eax
c0101b66:	0f b7 04 85 ca 9f 10 	movzwl -0x3fef6036(,%eax,4),%eax
c0101b6d:	c0 
c0101b6e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7d:	00 
c0101b7e:	89 04 24             	mov    %eax,(%esp)
c0101b81:	e8 33 fb ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b86:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8a:	83 c0 02             	add    $0x2,%eax
c0101b8d:	0f b7 c0             	movzwl %ax,%eax
c0101b90:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b94:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba1:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba4:	0f b6 c0             	movzbl %al,%eax
c0101ba7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bab:	83 c2 02             	add    $0x2,%edx
c0101bae:	0f b7 d2             	movzwl %dx,%edx
c0101bb1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc4:	0f b6 c0             	movzbl %al,%eax
c0101bc7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcb:	83 c2 03             	add    $0x3,%edx
c0101bce:	0f b7 d2             	movzwl %dx,%edx
c0101bd1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be4:	c1 e8 08             	shr    $0x8,%eax
c0101be7:	0f b6 c0             	movzbl %al,%eax
c0101bea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bee:	83 c2 04             	add    $0x4,%edx
c0101bf1:	0f b7 d2             	movzwl %dx,%edx
c0101bf4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bff:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c07:	c1 e8 10             	shr    $0x10,%eax
c0101c0a:	0f b6 c0             	movzbl %al,%eax
c0101c0d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c11:	83 c2 05             	add    $0x5,%edx
c0101c14:	0f b7 d2             	movzwl %dx,%edx
c0101c17:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1b:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c26:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c27:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2b:	83 e0 01             	and    $0x1,%eax
c0101c2e:	c1 e0 04             	shl    $0x4,%eax
c0101c31:	89 c2                	mov    %eax,%edx
c0101c33:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c36:	c1 e8 18             	shr    $0x18,%eax
c0101c39:	83 e0 0f             	and    $0xf,%eax
c0101c3c:	09 d0                	or     %edx,%eax
c0101c3e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c41:	0f b6 c0             	movzbl %al,%eax
c0101c44:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c48:	83 c2 06             	add    $0x6,%edx
c0101c4b:	0f b7 d2             	movzwl %dx,%edx
c0101c4e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c52:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c55:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c59:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c62:	83 c0 07             	add    $0x7,%eax
c0101c65:	0f b7 c0             	movzwl %ax,%eax
c0101c68:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c70:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c74:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c78:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c80:	eb 5a                	jmp    c0101cdc <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c82:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8d:	00 
c0101c8e:	89 04 24             	mov    %eax,(%esp)
c0101c91:	e8 23 fa ff ff       	call   c01016b9 <ide_wait_ready>
c0101c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9d:	74 02                	je     c0101ca1 <ide_read_secs+0x1f7>
            goto out;
c0101c9f:	eb 41                	jmp    c0101ce2 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca8:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cab:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101cae:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb8:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbe:	89 cb                	mov    %ecx,%ebx
c0101cc0:	89 df                	mov    %ebx,%edi
c0101cc2:	89 c1                	mov    %eax,%ecx
c0101cc4:	fc                   	cld    
c0101cc5:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc7:	89 c8                	mov    %ecx,%eax
c0101cc9:	89 fb                	mov    %edi,%ebx
c0101ccb:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cce:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd1:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd5:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce0:	75 a0                	jne    c0101c82 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce5:	83 c4 50             	add    $0x50,%esp
c0101ce8:	5b                   	pop    %ebx
c0101ce9:	5f                   	pop    %edi
c0101cea:	5d                   	pop    %ebp
c0101ceb:	c3                   	ret    

c0101cec <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101cec:	55                   	push   %ebp
c0101ced:	89 e5                	mov    %esp,%ebp
c0101cef:	56                   	push   %esi
c0101cf0:	53                   	push   %ebx
c0101cf1:	83 ec 50             	sub    $0x50,%esp
c0101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf7:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfb:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d02:	77 24                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d04:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d09:	77 1d                	ja     c0101d28 <ide_write_secs+0x3c>
c0101d0b:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d0f:	c1 e0 03             	shl    $0x3,%eax
c0101d12:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d19:	29 c2                	sub    %eax,%edx
c0101d1b:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d21:	0f b6 00             	movzbl (%eax),%eax
c0101d24:	84 c0                	test   %al,%al
c0101d26:	75 24                	jne    c0101d4c <ide_write_secs+0x60>
c0101d28:	c7 44 24 0c 58 a0 10 	movl   $0xc010a058,0xc(%esp)
c0101d2f:	c0 
c0101d30:	c7 44 24 08 13 a0 10 	movl   $0xc010a013,0x8(%esp)
c0101d37:	c0 
c0101d38:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d3f:	00 
c0101d40:	c7 04 24 28 a0 10 c0 	movl   $0xc010a028,(%esp)
c0101d47:	e8 90 ef ff ff       	call   c0100cdc <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4c:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d53:	77 0f                	ja     c0101d64 <ide_write_secs+0x78>
c0101d55:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5b:	01 d0                	add    %edx,%eax
c0101d5d:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d62:	76 24                	jbe    c0101d88 <ide_write_secs+0x9c>
c0101d64:	c7 44 24 0c 80 a0 10 	movl   $0xc010a080,0xc(%esp)
c0101d6b:	c0 
c0101d6c:	c7 44 24 08 13 a0 10 	movl   $0xc010a013,0x8(%esp)
c0101d73:	c0 
c0101d74:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7b:	00 
c0101d7c:	c7 04 24 28 a0 10 c0 	movl   $0xc010a028,(%esp)
c0101d83:	e8 54 ef ff ff       	call   c0100cdc <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d88:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8c:	66 d1 e8             	shr    %ax
c0101d8f:	0f b7 c0             	movzwl %ax,%eax
c0101d92:	0f b7 04 85 c8 9f 10 	movzwl -0x3fef6038(,%eax,4),%eax
c0101d99:	c0 
c0101d9a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da2:	66 d1 e8             	shr    %ax
c0101da5:	0f b7 c0             	movzwl %ax,%eax
c0101da8:	0f b7 04 85 ca 9f 10 	movzwl -0x3fef6036(,%eax,4),%eax
c0101daf:	c0 
c0101db0:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dbf:	00 
c0101dc0:	89 04 24             	mov    %eax,(%esp)
c0101dc3:	e8 f1 f8 ff ff       	call   c01016b9 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcc:	83 c0 02             	add    $0x2,%eax
c0101dcf:	0f b7 c0             	movzwl %ax,%eax
c0101dd2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd6:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dda:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dde:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de2:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de3:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de6:	0f b6 c0             	movzbl %al,%eax
c0101de9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ded:	83 c2 02             	add    $0x2,%edx
c0101df0:	0f b7 d2             	movzwl %dx,%edx
c0101df3:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df7:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dfe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e02:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e06:	0f b6 c0             	movzbl %al,%eax
c0101e09:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0d:	83 c2 03             	add    $0x3,%edx
c0101e10:	0f b7 d2             	movzwl %dx,%edx
c0101e13:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e17:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e22:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e26:	c1 e8 08             	shr    $0x8,%eax
c0101e29:	0f b6 c0             	movzbl %al,%eax
c0101e2c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e30:	83 c2 04             	add    $0x4,%edx
c0101e33:	0f b7 d2             	movzwl %dx,%edx
c0101e36:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3a:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e41:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e45:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e49:	c1 e8 10             	shr    $0x10,%eax
c0101e4c:	0f b6 c0             	movzbl %al,%eax
c0101e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e53:	83 c2 05             	add    $0x5,%edx
c0101e56:	0f b7 d2             	movzwl %dx,%edx
c0101e59:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5d:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e60:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e64:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e68:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e69:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6d:	83 e0 01             	and    $0x1,%eax
c0101e70:	c1 e0 04             	shl    $0x4,%eax
c0101e73:	89 c2                	mov    %eax,%edx
c0101e75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e78:	c1 e8 18             	shr    $0x18,%eax
c0101e7b:	83 e0 0f             	and    $0xf,%eax
c0101e7e:	09 d0                	or     %edx,%eax
c0101e80:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e83:	0f b6 c0             	movzbl %al,%eax
c0101e86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8a:	83 c2 06             	add    $0x6,%edx
c0101e8d:	0f b7 d2             	movzwl %dx,%edx
c0101e90:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e94:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e97:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e9f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea4:	83 c0 07             	add    $0x7,%eax
c0101ea7:	0f b7 c0             	movzwl %ax,%eax
c0101eaa:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eae:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eba:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec2:	eb 5a                	jmp    c0101f1e <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ecf:	00 
c0101ed0:	89 04 24             	mov    %eax,(%esp)
c0101ed3:	e8 e1 f7 ff ff       	call   c01016b9 <ide_wait_ready>
c0101ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101edf:	74 02                	je     c0101ee3 <ide_write_secs+0x1f7>
            goto out;
c0101ee1:	eb 41                	jmp    c0101f24 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee3:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eea:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eed:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef0:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efa:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f00:	89 cb                	mov    %ecx,%ebx
c0101f02:	89 de                	mov    %ebx,%esi
c0101f04:	89 c1                	mov    %eax,%ecx
c0101f06:	fc                   	cld    
c0101f07:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f09:	89 c8                	mov    %ecx,%eax
c0101f0b:	89 f3                	mov    %esi,%ebx
c0101f0d:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f10:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f13:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f17:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f22:	75 a0                	jne    c0101ec4 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f27:	83 c4 50             	add    $0x50,%esp
c0101f2a:	5b                   	pop    %ebx
c0101f2b:	5e                   	pop    %esi
c0101f2c:	5d                   	pop    %ebp
c0101f2d:	c3                   	ret    

c0101f2e <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2e:	55                   	push   %ebp
c0101f2f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f31:	fb                   	sti    
    sti();
}
c0101f32:	5d                   	pop    %ebp
c0101f33:	c3                   	ret    

c0101f34 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f34:	55                   	push   %ebp
c0101f35:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f37:	fa                   	cli    
    cli();
}
c0101f38:	5d                   	pop    %ebp
c0101f39:	c3                   	ret    

c0101f3a <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3a:	55                   	push   %ebp
c0101f3b:	89 e5                	mov    %esp,%ebp
c0101f3d:	83 ec 14             	sub    $0x14,%esp
c0101f40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f43:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f47:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4b:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f51:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f56:	85 c0                	test   %eax,%eax
c0101f58:	74 36                	je     c0101f90 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5e:	0f b6 c0             	movzbl %al,%eax
c0101f61:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f67:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f72:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f73:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f77:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7b:	0f b6 c0             	movzbl %al,%eax
c0101f7e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f84:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f87:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f8f:	ee                   	out    %al,(%dx)
    }
}
c0101f90:	c9                   	leave  
c0101f91:	c3                   	ret    

c0101f92 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f92:	55                   	push   %ebp
c0101f93:	89 e5                	mov    %esp,%ebp
c0101f95:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9b:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa0:	89 c1                	mov    %eax,%ecx
c0101fa2:	d3 e2                	shl    %cl,%edx
c0101fa4:	89 d0                	mov    %edx,%eax
c0101fa6:	f7 d0                	not    %eax
c0101fa8:	89 c2                	mov    %eax,%edx
c0101faa:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fb1:	21 d0                	and    %edx,%eax
c0101fb3:	0f b7 c0             	movzwl %ax,%eax
c0101fb6:	89 04 24             	mov    %eax,(%esp)
c0101fb9:	e8 7c ff ff ff       	call   c0101f3a <pic_setmask>
}
c0101fbe:	c9                   	leave  
c0101fbf:	c3                   	ret    

c0101fc0 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc0:	55                   	push   %ebp
c0101fc1:	89 e5                	mov    %esp,%ebp
c0101fc3:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc6:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fcd:	00 00 00 
c0101fd0:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd6:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fda:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fde:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe2:	ee                   	out    %al,(%dx)
c0101fe3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe9:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fed:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff5:	ee                   	out    %al,(%dx)
c0101ff6:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffc:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102000:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102004:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102008:	ee                   	out    %al,(%dx)
c0102009:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010200f:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102013:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102017:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201b:	ee                   	out    %al,(%dx)
c010201c:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102022:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102026:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202e:	ee                   	out    %al,(%dx)
c010202f:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102035:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102039:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102041:	ee                   	out    %al,(%dx)
c0102042:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102048:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102050:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102054:	ee                   	out    %al,(%dx)
c0102055:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205b:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010205f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102063:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102067:	ee                   	out    %al,(%dx)
c0102068:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206e:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102072:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102076:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207a:	ee                   	out    %al,(%dx)
c010207b:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102081:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102085:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102089:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208d:	ee                   	out    %al,(%dx)
c010208e:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102094:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102098:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a0:	ee                   	out    %al,(%dx)
c01020a1:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a7:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ab:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020af:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b3:	ee                   	out    %al,(%dx)
c01020b4:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020ba:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020be:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c6:	ee                   	out    %al,(%dx)
c01020c7:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020cd:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d1:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d5:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d9:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020da:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e1:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e5:	74 12                	je     c01020f9 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e7:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020ee:	0f b7 c0             	movzwl %ax,%eax
c01020f1:	89 04 24             	mov    %eax,(%esp)
c01020f4:	e8 41 fe ff ff       	call   c0101f3a <pic_setmask>
    }
}
c01020f9:	c9                   	leave  
c01020fa:	c3                   	ret    

c01020fb <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fb:	55                   	push   %ebp
c01020fc:	89 e5                	mov    %esp,%ebp
c01020fe:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102101:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102108:	00 
c0102109:	c7 04 24 c0 a0 10 c0 	movl   $0xc010a0c0,(%esp)
c0102110:	e8 3e e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102115:	c7 04 24 ca a0 10 c0 	movl   $0xc010a0ca,(%esp)
c010211c:	e8 32 e2 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c0102121:	c7 44 24 08 d8 a0 10 	movl   $0xc010a0d8,0x8(%esp)
c0102128:	c0 
c0102129:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102130:	00 
c0102131:	c7 04 24 ee a0 10 c0 	movl   $0xc010a0ee,(%esp)
c0102138:	e8 9f eb ff ff       	call   c0100cdc <__panic>

c010213d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010213d:	55                   	push   %ebp
c010213e:	89 e5                	mov    %esp,%ebp
c0102140:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c0102143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010214a:	e9 e2 00 00 00       	jmp    c0102231 <idt_init+0xf4>
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
c010214f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102152:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c0102159:	89 c2                	mov    %eax,%edx
c010215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215e:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102165:	c0 
c0102166:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102169:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c0102170:	c0 08 00 
c0102173:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102176:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010217d:	c0 
c010217e:	83 e2 e0             	and    $0xffffffe0,%edx
c0102181:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102192:	c0 
c0102193:	83 e2 1f             	and    $0x1f,%edx
c0102196:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 e2 f0             	and    $0xfffffff0,%edx
c01021ab:	83 ca 0e             	or     $0xe,%edx
c01021ae:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b8:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021bf:	c0 
c01021c0:	83 e2 ef             	and    $0xffffffef,%edx
c01021c3:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021ca:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01021d1:	75 07                	jne    c01021da <idt_init+0x9d>
c01021d3:	ba 03 00 00 00       	mov    $0x3,%edx
c01021d8:	eb 05                	jmp    c01021df <idt_init+0xa2>
c01021da:	ba 00 00 00 00       	mov    $0x0,%edx
c01021df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e2:	83 e2 03             	and    $0x3,%edx
c01021e5:	89 d1                	mov    %edx,%ecx
c01021e7:	c1 e1 05             	shl    $0x5,%ecx
c01021ea:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021f1:	c0 
c01021f2:	83 e2 9f             	and    $0xffffff9f,%edx
c01021f5:	09 ca                	or     %ecx,%edx
c01021f7:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102201:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c0102208:	c0 
c0102209:	83 ca 80             	or     $0xffffff80,%edx
c010220c:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c0102213:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102216:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c010221d:	c1 e8 10             	shr    $0x10,%eax
c0102220:	89 c2                	mov    %eax,%edx
c0102222:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102225:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c010222c:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c010222d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102231:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102238:	0f 8e 11 ff ff ff    	jle    c010214f <idt_init+0x12>
c010223e:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102245:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102248:	0f 01 18             	lidtl  (%eax)
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
	    lidt(&idt_pd);
}
c010224b:	c9                   	leave  
c010224c:	c3                   	ret    

c010224d <trapname>:

static const char *
trapname(int trapno) {
c010224d:	55                   	push   %ebp
c010224e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102250:	8b 45 08             	mov    0x8(%ebp),%eax
c0102253:	83 f8 13             	cmp    $0x13,%eax
c0102256:	77 0c                	ja     c0102264 <trapname+0x17>
        return excnames[trapno];
c0102258:	8b 45 08             	mov    0x8(%ebp),%eax
c010225b:	8b 04 85 c0 a4 10 c0 	mov    -0x3fef5b40(,%eax,4),%eax
c0102262:	eb 18                	jmp    c010227c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102264:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102268:	7e 0d                	jle    c0102277 <trapname+0x2a>
c010226a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010226e:	7f 07                	jg     c0102277 <trapname+0x2a>
        return "Hardware Interrupt";
c0102270:	b8 ff a0 10 c0       	mov    $0xc010a0ff,%eax
c0102275:	eb 05                	jmp    c010227c <trapname+0x2f>
    }
    return "(unknown trap)";
c0102277:	b8 12 a1 10 c0       	mov    $0xc010a112,%eax
}
c010227c:	5d                   	pop    %ebp
c010227d:	c3                   	ret    

c010227e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010227e:	55                   	push   %ebp
c010227f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102281:	8b 45 08             	mov    0x8(%ebp),%eax
c0102284:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102288:	66 83 f8 08          	cmp    $0x8,%ax
c010228c:	0f 94 c0             	sete   %al
c010228f:	0f b6 c0             	movzbl %al,%eax
}
c0102292:	5d                   	pop    %ebp
c0102293:	c3                   	ret    

c0102294 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102294:	55                   	push   %ebp
c0102295:	89 e5                	mov    %esp,%ebp
c0102297:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010229a:	8b 45 08             	mov    0x8(%ebp),%eax
c010229d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022a1:	c7 04 24 53 a1 10 c0 	movl   $0xc010a153,(%esp)
c01022a8:	e8 a6 e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c01022ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b0:	89 04 24             	mov    %eax,(%esp)
c01022b3:	e8 a1 01 00 00       	call   c0102459 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01022b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022bb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022bf:	0f b7 c0             	movzwl %ax,%eax
c01022c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022c6:	c7 04 24 64 a1 10 c0 	movl   $0xc010a164,(%esp)
c01022cd:	e8 81 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022d9:	0f b7 c0             	movzwl %ax,%eax
c01022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022e0:	c7 04 24 77 a1 10 c0 	movl   $0xc010a177,(%esp)
c01022e7:	e8 67 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ef:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022f3:	0f b7 c0             	movzwl %ax,%eax
c01022f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022fa:	c7 04 24 8a a1 10 c0 	movl   $0xc010a18a,(%esp)
c0102301:	e8 4d e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102306:	8b 45 08             	mov    0x8(%ebp),%eax
c0102309:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010230d:	0f b7 c0             	movzwl %ax,%eax
c0102310:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102314:	c7 04 24 9d a1 10 c0 	movl   $0xc010a19d,(%esp)
c010231b:	e8 33 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102320:	8b 45 08             	mov    0x8(%ebp),%eax
c0102323:	8b 40 30             	mov    0x30(%eax),%eax
c0102326:	89 04 24             	mov    %eax,(%esp)
c0102329:	e8 1f ff ff ff       	call   c010224d <trapname>
c010232e:	8b 55 08             	mov    0x8(%ebp),%edx
c0102331:	8b 52 30             	mov    0x30(%edx),%edx
c0102334:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102338:	89 54 24 04          	mov    %edx,0x4(%esp)
c010233c:	c7 04 24 b0 a1 10 c0 	movl   $0xc010a1b0,(%esp)
c0102343:	e8 0b e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102348:	8b 45 08             	mov    0x8(%ebp),%eax
c010234b:	8b 40 34             	mov    0x34(%eax),%eax
c010234e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102352:	c7 04 24 c2 a1 10 c0 	movl   $0xc010a1c2,(%esp)
c0102359:	e8 f5 df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010235e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102361:	8b 40 38             	mov    0x38(%eax),%eax
c0102364:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102368:	c7 04 24 d1 a1 10 c0 	movl   $0xc010a1d1,(%esp)
c010236f:	e8 df df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102374:	8b 45 08             	mov    0x8(%ebp),%eax
c0102377:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010237b:	0f b7 c0             	movzwl %ax,%eax
c010237e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102382:	c7 04 24 e0 a1 10 c0 	movl   $0xc010a1e0,(%esp)
c0102389:	e8 c5 df ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010238e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102391:	8b 40 40             	mov    0x40(%eax),%eax
c0102394:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102398:	c7 04 24 f3 a1 10 c0 	movl   $0xc010a1f3,(%esp)
c010239f:	e8 af df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01023ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01023b2:	eb 3e                	jmp    c01023f2 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01023b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b7:	8b 50 40             	mov    0x40(%eax),%edx
c01023ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023bd:	21 d0                	and    %edx,%eax
c01023bf:	85 c0                	test   %eax,%eax
c01023c1:	74 28                	je     c01023eb <print_trapframe+0x157>
c01023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023c6:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01023cd:	85 c0                	test   %eax,%eax
c01023cf:	74 1a                	je     c01023eb <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023d4:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01023db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023df:	c7 04 24 02 a2 10 c0 	movl   $0xc010a202,(%esp)
c01023e6:	e8 68 df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023ef:	d1 65 f0             	shll   -0x10(%ebp)
c01023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023f5:	83 f8 17             	cmp    $0x17,%eax
c01023f8:	76 ba                	jbe    c01023b4 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fd:	8b 40 40             	mov    0x40(%eax),%eax
c0102400:	25 00 30 00 00       	and    $0x3000,%eax
c0102405:	c1 e8 0c             	shr    $0xc,%eax
c0102408:	89 44 24 04          	mov    %eax,0x4(%esp)
c010240c:	c7 04 24 06 a2 10 c0 	movl   $0xc010a206,(%esp)
c0102413:	e8 3b df ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102418:	8b 45 08             	mov    0x8(%ebp),%eax
c010241b:	89 04 24             	mov    %eax,(%esp)
c010241e:	e8 5b fe ff ff       	call   c010227e <trap_in_kernel>
c0102423:	85 c0                	test   %eax,%eax
c0102425:	75 30                	jne    c0102457 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102427:	8b 45 08             	mov    0x8(%ebp),%eax
c010242a:	8b 40 44             	mov    0x44(%eax),%eax
c010242d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102431:	c7 04 24 0f a2 10 c0 	movl   $0xc010a20f,(%esp)
c0102438:	e8 16 df ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010243d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102440:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102444:	0f b7 c0             	movzwl %ax,%eax
c0102447:	89 44 24 04          	mov    %eax,0x4(%esp)
c010244b:	c7 04 24 1e a2 10 c0 	movl   $0xc010a21e,(%esp)
c0102452:	e8 fc de ff ff       	call   c0100353 <cprintf>
    }
}
c0102457:	c9                   	leave  
c0102458:	c3                   	ret    

c0102459 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102459:	55                   	push   %ebp
c010245a:	89 e5                	mov    %esp,%ebp
c010245c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010245f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102462:	8b 00                	mov    (%eax),%eax
c0102464:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102468:	c7 04 24 31 a2 10 c0 	movl   $0xc010a231,(%esp)
c010246f:	e8 df de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102474:	8b 45 08             	mov    0x8(%ebp),%eax
c0102477:	8b 40 04             	mov    0x4(%eax),%eax
c010247a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247e:	c7 04 24 40 a2 10 c0 	movl   $0xc010a240,(%esp)
c0102485:	e8 c9 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010248a:	8b 45 08             	mov    0x8(%ebp),%eax
c010248d:	8b 40 08             	mov    0x8(%eax),%eax
c0102490:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102494:	c7 04 24 4f a2 10 c0 	movl   $0xc010a24f,(%esp)
c010249b:	e8 b3 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01024a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a3:	8b 40 0c             	mov    0xc(%eax),%eax
c01024a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024aa:	c7 04 24 5e a2 10 c0 	movl   $0xc010a25e,(%esp)
c01024b1:	e8 9d de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01024b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b9:	8b 40 10             	mov    0x10(%eax),%eax
c01024bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024c0:	c7 04 24 6d a2 10 c0 	movl   $0xc010a26d,(%esp)
c01024c7:	e8 87 de ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01024cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cf:	8b 40 14             	mov    0x14(%eax),%eax
c01024d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d6:	c7 04 24 7c a2 10 c0 	movl   $0xc010a27c,(%esp)
c01024dd:	e8 71 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e5:	8b 40 18             	mov    0x18(%eax),%eax
c01024e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ec:	c7 04 24 8b a2 10 c0 	movl   $0xc010a28b,(%esp)
c01024f3:	e8 5b de ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102502:	c7 04 24 9a a2 10 c0 	movl   $0xc010a29a,(%esp)
c0102509:	e8 45 de ff ff       	call   c0100353 <cprintf>
}
c010250e:	c9                   	leave  
c010250f:	c3                   	ret    

c0102510 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102510:	55                   	push   %ebp
c0102511:	89 e5                	mov    %esp,%ebp
c0102513:	53                   	push   %ebx
c0102514:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102517:	8b 45 08             	mov    0x8(%ebp),%eax
c010251a:	8b 40 34             	mov    0x34(%eax),%eax
c010251d:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102520:	85 c0                	test   %eax,%eax
c0102522:	74 07                	je     c010252b <print_pgfault+0x1b>
c0102524:	b9 a9 a2 10 c0       	mov    $0xc010a2a9,%ecx
c0102529:	eb 05                	jmp    c0102530 <print_pgfault+0x20>
c010252b:	b9 ba a2 10 c0       	mov    $0xc010a2ba,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102530:	8b 45 08             	mov    0x8(%ebp),%eax
c0102533:	8b 40 34             	mov    0x34(%eax),%eax
c0102536:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102539:	85 c0                	test   %eax,%eax
c010253b:	74 07                	je     c0102544 <print_pgfault+0x34>
c010253d:	ba 57 00 00 00       	mov    $0x57,%edx
c0102542:	eb 05                	jmp    c0102549 <print_pgfault+0x39>
c0102544:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102549:	8b 45 08             	mov    0x8(%ebp),%eax
c010254c:	8b 40 34             	mov    0x34(%eax),%eax
c010254f:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102552:	85 c0                	test   %eax,%eax
c0102554:	74 07                	je     c010255d <print_pgfault+0x4d>
c0102556:	b8 55 00 00 00       	mov    $0x55,%eax
c010255b:	eb 05                	jmp    c0102562 <print_pgfault+0x52>
c010255d:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102562:	0f 20 d3             	mov    %cr2,%ebx
c0102565:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102568:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010256b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010256f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102573:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102577:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010257b:	c7 04 24 c8 a2 10 c0 	movl   $0xc010a2c8,(%esp)
c0102582:	e8 cc dd ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102587:	83 c4 34             	add    $0x34,%esp
c010258a:	5b                   	pop    %ebx
c010258b:	5d                   	pop    %ebp
c010258c:	c3                   	ret    

c010258d <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010258d:	55                   	push   %ebp
c010258e:	89 e5                	mov    %esp,%ebp
c0102590:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102593:	8b 45 08             	mov    0x8(%ebp),%eax
c0102596:	89 04 24             	mov    %eax,(%esp)
c0102599:	e8 72 ff ff ff       	call   c0102510 <print_pgfault>
    if (check_mm_struct != NULL) {
c010259e:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025a3:	85 c0                	test   %eax,%eax
c01025a5:	74 28                	je     c01025cf <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01025a7:	0f 20 d0             	mov    %cr2,%eax
c01025aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c01025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01025b0:	89 c1                	mov    %eax,%ecx
c01025b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b5:	8b 50 34             	mov    0x34(%eax),%edx
c01025b8:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025c1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025c5:	89 04 24             	mov    %eax,(%esp)
c01025c8:	e8 cf 5a 00 00       	call   c010809c <do_pgfault>
c01025cd:	eb 1c                	jmp    c01025eb <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01025cf:	c7 44 24 08 eb a2 10 	movl   $0xc010a2eb,0x8(%esp)
c01025d6:	c0 
c01025d7:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01025de:	00 
c01025df:	c7 04 24 ee a0 10 c0 	movl   $0xc010a0ee,(%esp)
c01025e6:	e8 f1 e6 ff ff       	call   c0100cdc <__panic>
}
c01025eb:	c9                   	leave  
c01025ec:	c3                   	ret    

c01025ed <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025ed:	55                   	push   %ebp
c01025ee:	89 e5                	mov    %esp,%ebp
c01025f0:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f6:	8b 40 30             	mov    0x30(%eax),%eax
c01025f9:	83 f8 24             	cmp    $0x24,%eax
c01025fc:	0f 84 b2 00 00 00    	je     c01026b4 <trap_dispatch+0xc7>
c0102602:	83 f8 24             	cmp    $0x24,%eax
c0102605:	77 18                	ja     c010261f <trap_dispatch+0x32>
c0102607:	83 f8 20             	cmp    $0x20,%eax
c010260a:	74 7d                	je     c0102689 <trap_dispatch+0x9c>
c010260c:	83 f8 21             	cmp    $0x21,%eax
c010260f:	0f 84 c5 00 00 00    	je     c01026da <trap_dispatch+0xed>
c0102615:	83 f8 0e             	cmp    $0xe,%eax
c0102618:	74 28                	je     c0102642 <trap_dispatch+0x55>
c010261a:	e9 fd 00 00 00       	jmp    c010271c <trap_dispatch+0x12f>
c010261f:	83 f8 2e             	cmp    $0x2e,%eax
c0102622:	0f 82 f4 00 00 00    	jb     c010271c <trap_dispatch+0x12f>
c0102628:	83 f8 2f             	cmp    $0x2f,%eax
c010262b:	0f 86 23 01 00 00    	jbe    c0102754 <trap_dispatch+0x167>
c0102631:	83 e8 78             	sub    $0x78,%eax
c0102634:	83 f8 01             	cmp    $0x1,%eax
c0102637:	0f 87 df 00 00 00    	ja     c010271c <trap_dispatch+0x12f>
c010263d:	e9 be 00 00 00       	jmp    c0102700 <trap_dispatch+0x113>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102642:	8b 45 08             	mov    0x8(%ebp),%eax
c0102645:	89 04 24             	mov    %eax,(%esp)
c0102648:	e8 40 ff ff ff       	call   c010258d <pgfault_handler>
c010264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102654:	74 2e                	je     c0102684 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102656:	8b 45 08             	mov    0x8(%ebp),%eax
c0102659:	89 04 24             	mov    %eax,(%esp)
c010265c:	e8 33 fc ff ff       	call   c0102294 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102664:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102668:	c7 44 24 08 02 a3 10 	movl   $0xc010a302,0x8(%esp)
c010266f:	c0 
c0102670:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102677:	00 
c0102678:	c7 04 24 ee a0 10 c0 	movl   $0xc010a0ee,(%esp)
c010267f:	e8 58 e6 ff ff       	call   c0100cdc <__panic>
        }
        break;
c0102684:	e9 cc 00 00 00       	jmp    c0102755 <trap_dispatch+0x168>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if (++ticks == TICK_NUM) {
c0102689:	a1 14 7b 12 c0       	mov    0xc0127b14,%eax
c010268e:	83 c0 01             	add    $0x1,%eax
c0102691:	a3 14 7b 12 c0       	mov    %eax,0xc0127b14
c0102696:	83 f8 64             	cmp    $0x64,%eax
c0102699:	75 14                	jne    c01026af <trap_dispatch+0xc2>
    		print_ticks();
c010269b:	e8 5b fa ff ff       	call   c01020fb <print_ticks>
    		ticks = 0;
c01026a0:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c01026a7:	00 00 00 
    	}
        break;
c01026aa:	e9 a6 00 00 00       	jmp    c0102755 <trap_dispatch+0x168>
c01026af:	e9 a1 00 00 00       	jmp    c0102755 <trap_dispatch+0x168>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026b4:	e8 91 ef ff ff       	call   c010164a <cons_getc>
c01026b9:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026bc:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026c0:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026cc:	c7 04 24 1d a3 10 c0 	movl   $0xc010a31d,(%esp)
c01026d3:	e8 7b dc ff ff       	call   c0100353 <cprintf>
        break;
c01026d8:	eb 7b                	jmp    c0102755 <trap_dispatch+0x168>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026da:	e8 6b ef ff ff       	call   c010164a <cons_getc>
c01026df:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026e2:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026e6:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026ea:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026f2:	c7 04 24 2f a3 10 c0 	movl   $0xc010a32f,(%esp)
c01026f9:	e8 55 dc ff ff       	call   c0100353 <cprintf>
        break;
c01026fe:	eb 55                	jmp    c0102755 <trap_dispatch+0x168>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102700:	c7 44 24 08 3e a3 10 	movl   $0xc010a33e,0x8(%esp)
c0102707:	c0 
c0102708:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c010270f:	00 
c0102710:	c7 04 24 ee a0 10 c0 	movl   $0xc010a0ee,(%esp)
c0102717:	e8 c0 e5 ff ff       	call   c0100cdc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010271c:	8b 45 08             	mov    0x8(%ebp),%eax
c010271f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102723:	0f b7 c0             	movzwl %ax,%eax
c0102726:	83 e0 03             	and    $0x3,%eax
c0102729:	85 c0                	test   %eax,%eax
c010272b:	75 28                	jne    c0102755 <trap_dispatch+0x168>
            print_trapframe(tf);
c010272d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102730:	89 04 24             	mov    %eax,(%esp)
c0102733:	e8 5c fb ff ff       	call   c0102294 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102738:	c7 44 24 08 4e a3 10 	movl   $0xc010a34e,0x8(%esp)
c010273f:	c0 
c0102740:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102747:	00 
c0102748:	c7 04 24 ee a0 10 c0 	movl   $0xc010a0ee,(%esp)
c010274f:	e8 88 e5 ff ff       	call   c0100cdc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102754:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102755:	c9                   	leave  
c0102756:	c3                   	ret    

c0102757 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102757:	55                   	push   %ebp
c0102758:	89 e5                	mov    %esp,%ebp
c010275a:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010275d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102760:	89 04 24             	mov    %eax,(%esp)
c0102763:	e8 85 fe ff ff       	call   c01025ed <trap_dispatch>
}
c0102768:	c9                   	leave  
c0102769:	c3                   	ret    

c010276a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010276a:	1e                   	push   %ds
    pushl %es
c010276b:	06                   	push   %es
    pushl %fs
c010276c:	0f a0                	push   %fs
    pushl %gs
c010276e:	0f a8                	push   %gs
    pushal
c0102770:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102771:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102776:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102778:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010277a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010277b:	e8 d7 ff ff ff       	call   c0102757 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102780:	5c                   	pop    %esp

c0102781 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102781:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102782:	0f a9                	pop    %gs
    popl %fs
c0102784:	0f a1                	pop    %fs
    popl %es
c0102786:	07                   	pop    %es
    popl %ds
c0102787:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102788:	83 c4 08             	add    $0x8,%esp
    iret
c010278b:	cf                   	iret   

c010278c <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c010278c:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102790:	e9 ec ff ff ff       	jmp    c0102781 <__trapret>

c0102795 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $0
c0102797:	6a 00                	push   $0x0
  jmp __alltraps
c0102799:	e9 cc ff ff ff       	jmp    c010276a <__alltraps>

c010279e <vector1>:
.globl vector1
vector1:
  pushl $0
c010279e:	6a 00                	push   $0x0
  pushl $1
c01027a0:	6a 01                	push   $0x1
  jmp __alltraps
c01027a2:	e9 c3 ff ff ff       	jmp    c010276a <__alltraps>

c01027a7 <vector2>:
.globl vector2
vector2:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $2
c01027a9:	6a 02                	push   $0x2
  jmp __alltraps
c01027ab:	e9 ba ff ff ff       	jmp    c010276a <__alltraps>

c01027b0 <vector3>:
.globl vector3
vector3:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $3
c01027b2:	6a 03                	push   $0x3
  jmp __alltraps
c01027b4:	e9 b1 ff ff ff       	jmp    c010276a <__alltraps>

c01027b9 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $4
c01027bb:	6a 04                	push   $0x4
  jmp __alltraps
c01027bd:	e9 a8 ff ff ff       	jmp    c010276a <__alltraps>

c01027c2 <vector5>:
.globl vector5
vector5:
  pushl $0
c01027c2:	6a 00                	push   $0x0
  pushl $5
c01027c4:	6a 05                	push   $0x5
  jmp __alltraps
c01027c6:	e9 9f ff ff ff       	jmp    c010276a <__alltraps>

c01027cb <vector6>:
.globl vector6
vector6:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $6
c01027cd:	6a 06                	push   $0x6
  jmp __alltraps
c01027cf:	e9 96 ff ff ff       	jmp    c010276a <__alltraps>

c01027d4 <vector7>:
.globl vector7
vector7:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $7
c01027d6:	6a 07                	push   $0x7
  jmp __alltraps
c01027d8:	e9 8d ff ff ff       	jmp    c010276a <__alltraps>

c01027dd <vector8>:
.globl vector8
vector8:
  pushl $8
c01027dd:	6a 08                	push   $0x8
  jmp __alltraps
c01027df:	e9 86 ff ff ff       	jmp    c010276a <__alltraps>

c01027e4 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027e4:	6a 09                	push   $0x9
  jmp __alltraps
c01027e6:	e9 7f ff ff ff       	jmp    c010276a <__alltraps>

c01027eb <vector10>:
.globl vector10
vector10:
  pushl $10
c01027eb:	6a 0a                	push   $0xa
  jmp __alltraps
c01027ed:	e9 78 ff ff ff       	jmp    c010276a <__alltraps>

c01027f2 <vector11>:
.globl vector11
vector11:
  pushl $11
c01027f2:	6a 0b                	push   $0xb
  jmp __alltraps
c01027f4:	e9 71 ff ff ff       	jmp    c010276a <__alltraps>

c01027f9 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027f9:	6a 0c                	push   $0xc
  jmp __alltraps
c01027fb:	e9 6a ff ff ff       	jmp    c010276a <__alltraps>

c0102800 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102800:	6a 0d                	push   $0xd
  jmp __alltraps
c0102802:	e9 63 ff ff ff       	jmp    c010276a <__alltraps>

c0102807 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102807:	6a 0e                	push   $0xe
  jmp __alltraps
c0102809:	e9 5c ff ff ff       	jmp    c010276a <__alltraps>

c010280e <vector15>:
.globl vector15
vector15:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $15
c0102810:	6a 0f                	push   $0xf
  jmp __alltraps
c0102812:	e9 53 ff ff ff       	jmp    c010276a <__alltraps>

c0102817 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102817:	6a 00                	push   $0x0
  pushl $16
c0102819:	6a 10                	push   $0x10
  jmp __alltraps
c010281b:	e9 4a ff ff ff       	jmp    c010276a <__alltraps>

c0102820 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102820:	6a 11                	push   $0x11
  jmp __alltraps
c0102822:	e9 43 ff ff ff       	jmp    c010276a <__alltraps>

c0102827 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $18
c0102829:	6a 12                	push   $0x12
  jmp __alltraps
c010282b:	e9 3a ff ff ff       	jmp    c010276a <__alltraps>

c0102830 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $19
c0102832:	6a 13                	push   $0x13
  jmp __alltraps
c0102834:	e9 31 ff ff ff       	jmp    c010276a <__alltraps>

c0102839 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102839:	6a 00                	push   $0x0
  pushl $20
c010283b:	6a 14                	push   $0x14
  jmp __alltraps
c010283d:	e9 28 ff ff ff       	jmp    c010276a <__alltraps>

c0102842 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102842:	6a 00                	push   $0x0
  pushl $21
c0102844:	6a 15                	push   $0x15
  jmp __alltraps
c0102846:	e9 1f ff ff ff       	jmp    c010276a <__alltraps>

c010284b <vector22>:
.globl vector22
vector22:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $22
c010284d:	6a 16                	push   $0x16
  jmp __alltraps
c010284f:	e9 16 ff ff ff       	jmp    c010276a <__alltraps>

c0102854 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $23
c0102856:	6a 17                	push   $0x17
  jmp __alltraps
c0102858:	e9 0d ff ff ff       	jmp    c010276a <__alltraps>

c010285d <vector24>:
.globl vector24
vector24:
  pushl $0
c010285d:	6a 00                	push   $0x0
  pushl $24
c010285f:	6a 18                	push   $0x18
  jmp __alltraps
c0102861:	e9 04 ff ff ff       	jmp    c010276a <__alltraps>

c0102866 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102866:	6a 00                	push   $0x0
  pushl $25
c0102868:	6a 19                	push   $0x19
  jmp __alltraps
c010286a:	e9 fb fe ff ff       	jmp    c010276a <__alltraps>

c010286f <vector26>:
.globl vector26
vector26:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $26
c0102871:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102873:	e9 f2 fe ff ff       	jmp    c010276a <__alltraps>

c0102878 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $27
c010287a:	6a 1b                	push   $0x1b
  jmp __alltraps
c010287c:	e9 e9 fe ff ff       	jmp    c010276a <__alltraps>

c0102881 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102881:	6a 00                	push   $0x0
  pushl $28
c0102883:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102885:	e9 e0 fe ff ff       	jmp    c010276a <__alltraps>

c010288a <vector29>:
.globl vector29
vector29:
  pushl $0
c010288a:	6a 00                	push   $0x0
  pushl $29
c010288c:	6a 1d                	push   $0x1d
  jmp __alltraps
c010288e:	e9 d7 fe ff ff       	jmp    c010276a <__alltraps>

c0102893 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $30
c0102895:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102897:	e9 ce fe ff ff       	jmp    c010276a <__alltraps>

c010289c <vector31>:
.globl vector31
vector31:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $31
c010289e:	6a 1f                	push   $0x1f
  jmp __alltraps
c01028a0:	e9 c5 fe ff ff       	jmp    c010276a <__alltraps>

c01028a5 <vector32>:
.globl vector32
vector32:
  pushl $0
c01028a5:	6a 00                	push   $0x0
  pushl $32
c01028a7:	6a 20                	push   $0x20
  jmp __alltraps
c01028a9:	e9 bc fe ff ff       	jmp    c010276a <__alltraps>

c01028ae <vector33>:
.globl vector33
vector33:
  pushl $0
c01028ae:	6a 00                	push   $0x0
  pushl $33
c01028b0:	6a 21                	push   $0x21
  jmp __alltraps
c01028b2:	e9 b3 fe ff ff       	jmp    c010276a <__alltraps>

c01028b7 <vector34>:
.globl vector34
vector34:
  pushl $0
c01028b7:	6a 00                	push   $0x0
  pushl $34
c01028b9:	6a 22                	push   $0x22
  jmp __alltraps
c01028bb:	e9 aa fe ff ff       	jmp    c010276a <__alltraps>

c01028c0 <vector35>:
.globl vector35
vector35:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $35
c01028c2:	6a 23                	push   $0x23
  jmp __alltraps
c01028c4:	e9 a1 fe ff ff       	jmp    c010276a <__alltraps>

c01028c9 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028c9:	6a 00                	push   $0x0
  pushl $36
c01028cb:	6a 24                	push   $0x24
  jmp __alltraps
c01028cd:	e9 98 fe ff ff       	jmp    c010276a <__alltraps>

c01028d2 <vector37>:
.globl vector37
vector37:
  pushl $0
c01028d2:	6a 00                	push   $0x0
  pushl $37
c01028d4:	6a 25                	push   $0x25
  jmp __alltraps
c01028d6:	e9 8f fe ff ff       	jmp    c010276a <__alltraps>

c01028db <vector38>:
.globl vector38
vector38:
  pushl $0
c01028db:	6a 00                	push   $0x0
  pushl $38
c01028dd:	6a 26                	push   $0x26
  jmp __alltraps
c01028df:	e9 86 fe ff ff       	jmp    c010276a <__alltraps>

c01028e4 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $39
c01028e6:	6a 27                	push   $0x27
  jmp __alltraps
c01028e8:	e9 7d fe ff ff       	jmp    c010276a <__alltraps>

c01028ed <vector40>:
.globl vector40
vector40:
  pushl $0
c01028ed:	6a 00                	push   $0x0
  pushl $40
c01028ef:	6a 28                	push   $0x28
  jmp __alltraps
c01028f1:	e9 74 fe ff ff       	jmp    c010276a <__alltraps>

c01028f6 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028f6:	6a 00                	push   $0x0
  pushl $41
c01028f8:	6a 29                	push   $0x29
  jmp __alltraps
c01028fa:	e9 6b fe ff ff       	jmp    c010276a <__alltraps>

c01028ff <vector42>:
.globl vector42
vector42:
  pushl $0
c01028ff:	6a 00                	push   $0x0
  pushl $42
c0102901:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102903:	e9 62 fe ff ff       	jmp    c010276a <__alltraps>

c0102908 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $43
c010290a:	6a 2b                	push   $0x2b
  jmp __alltraps
c010290c:	e9 59 fe ff ff       	jmp    c010276a <__alltraps>

c0102911 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102911:	6a 00                	push   $0x0
  pushl $44
c0102913:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102915:	e9 50 fe ff ff       	jmp    c010276a <__alltraps>

c010291a <vector45>:
.globl vector45
vector45:
  pushl $0
c010291a:	6a 00                	push   $0x0
  pushl $45
c010291c:	6a 2d                	push   $0x2d
  jmp __alltraps
c010291e:	e9 47 fe ff ff       	jmp    c010276a <__alltraps>

c0102923 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102923:	6a 00                	push   $0x0
  pushl $46
c0102925:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102927:	e9 3e fe ff ff       	jmp    c010276a <__alltraps>

c010292c <vector47>:
.globl vector47
vector47:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $47
c010292e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102930:	e9 35 fe ff ff       	jmp    c010276a <__alltraps>

c0102935 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102935:	6a 00                	push   $0x0
  pushl $48
c0102937:	6a 30                	push   $0x30
  jmp __alltraps
c0102939:	e9 2c fe ff ff       	jmp    c010276a <__alltraps>

c010293e <vector49>:
.globl vector49
vector49:
  pushl $0
c010293e:	6a 00                	push   $0x0
  pushl $49
c0102940:	6a 31                	push   $0x31
  jmp __alltraps
c0102942:	e9 23 fe ff ff       	jmp    c010276a <__alltraps>

c0102947 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102947:	6a 00                	push   $0x0
  pushl $50
c0102949:	6a 32                	push   $0x32
  jmp __alltraps
c010294b:	e9 1a fe ff ff       	jmp    c010276a <__alltraps>

c0102950 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $51
c0102952:	6a 33                	push   $0x33
  jmp __alltraps
c0102954:	e9 11 fe ff ff       	jmp    c010276a <__alltraps>

c0102959 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102959:	6a 00                	push   $0x0
  pushl $52
c010295b:	6a 34                	push   $0x34
  jmp __alltraps
c010295d:	e9 08 fe ff ff       	jmp    c010276a <__alltraps>

c0102962 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102962:	6a 00                	push   $0x0
  pushl $53
c0102964:	6a 35                	push   $0x35
  jmp __alltraps
c0102966:	e9 ff fd ff ff       	jmp    c010276a <__alltraps>

c010296b <vector54>:
.globl vector54
vector54:
  pushl $0
c010296b:	6a 00                	push   $0x0
  pushl $54
c010296d:	6a 36                	push   $0x36
  jmp __alltraps
c010296f:	e9 f6 fd ff ff       	jmp    c010276a <__alltraps>

c0102974 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $55
c0102976:	6a 37                	push   $0x37
  jmp __alltraps
c0102978:	e9 ed fd ff ff       	jmp    c010276a <__alltraps>

c010297d <vector56>:
.globl vector56
vector56:
  pushl $0
c010297d:	6a 00                	push   $0x0
  pushl $56
c010297f:	6a 38                	push   $0x38
  jmp __alltraps
c0102981:	e9 e4 fd ff ff       	jmp    c010276a <__alltraps>

c0102986 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102986:	6a 00                	push   $0x0
  pushl $57
c0102988:	6a 39                	push   $0x39
  jmp __alltraps
c010298a:	e9 db fd ff ff       	jmp    c010276a <__alltraps>

c010298f <vector58>:
.globl vector58
vector58:
  pushl $0
c010298f:	6a 00                	push   $0x0
  pushl $58
c0102991:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102993:	e9 d2 fd ff ff       	jmp    c010276a <__alltraps>

c0102998 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $59
c010299a:	6a 3b                	push   $0x3b
  jmp __alltraps
c010299c:	e9 c9 fd ff ff       	jmp    c010276a <__alltraps>

c01029a1 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029a1:	6a 00                	push   $0x0
  pushl $60
c01029a3:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029a5:	e9 c0 fd ff ff       	jmp    c010276a <__alltraps>

c01029aa <vector61>:
.globl vector61
vector61:
  pushl $0
c01029aa:	6a 00                	push   $0x0
  pushl $61
c01029ac:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029ae:	e9 b7 fd ff ff       	jmp    c010276a <__alltraps>

c01029b3 <vector62>:
.globl vector62
vector62:
  pushl $0
c01029b3:	6a 00                	push   $0x0
  pushl $62
c01029b5:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029b7:	e9 ae fd ff ff       	jmp    c010276a <__alltraps>

c01029bc <vector63>:
.globl vector63
vector63:
  pushl $0
c01029bc:	6a 00                	push   $0x0
  pushl $63
c01029be:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029c0:	e9 a5 fd ff ff       	jmp    c010276a <__alltraps>

c01029c5 <vector64>:
.globl vector64
vector64:
  pushl $0
c01029c5:	6a 00                	push   $0x0
  pushl $64
c01029c7:	6a 40                	push   $0x40
  jmp __alltraps
c01029c9:	e9 9c fd ff ff       	jmp    c010276a <__alltraps>

c01029ce <vector65>:
.globl vector65
vector65:
  pushl $0
c01029ce:	6a 00                	push   $0x0
  pushl $65
c01029d0:	6a 41                	push   $0x41
  jmp __alltraps
c01029d2:	e9 93 fd ff ff       	jmp    c010276a <__alltraps>

c01029d7 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029d7:	6a 00                	push   $0x0
  pushl $66
c01029d9:	6a 42                	push   $0x42
  jmp __alltraps
c01029db:	e9 8a fd ff ff       	jmp    c010276a <__alltraps>

c01029e0 <vector67>:
.globl vector67
vector67:
  pushl $0
c01029e0:	6a 00                	push   $0x0
  pushl $67
c01029e2:	6a 43                	push   $0x43
  jmp __alltraps
c01029e4:	e9 81 fd ff ff       	jmp    c010276a <__alltraps>

c01029e9 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029e9:	6a 00                	push   $0x0
  pushl $68
c01029eb:	6a 44                	push   $0x44
  jmp __alltraps
c01029ed:	e9 78 fd ff ff       	jmp    c010276a <__alltraps>

c01029f2 <vector69>:
.globl vector69
vector69:
  pushl $0
c01029f2:	6a 00                	push   $0x0
  pushl $69
c01029f4:	6a 45                	push   $0x45
  jmp __alltraps
c01029f6:	e9 6f fd ff ff       	jmp    c010276a <__alltraps>

c01029fb <vector70>:
.globl vector70
vector70:
  pushl $0
c01029fb:	6a 00                	push   $0x0
  pushl $70
c01029fd:	6a 46                	push   $0x46
  jmp __alltraps
c01029ff:	e9 66 fd ff ff       	jmp    c010276a <__alltraps>

c0102a04 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a04:	6a 00                	push   $0x0
  pushl $71
c0102a06:	6a 47                	push   $0x47
  jmp __alltraps
c0102a08:	e9 5d fd ff ff       	jmp    c010276a <__alltraps>

c0102a0d <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  pushl $72
c0102a0f:	6a 48                	push   $0x48
  jmp __alltraps
c0102a11:	e9 54 fd ff ff       	jmp    c010276a <__alltraps>

c0102a16 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a16:	6a 00                	push   $0x0
  pushl $73
c0102a18:	6a 49                	push   $0x49
  jmp __alltraps
c0102a1a:	e9 4b fd ff ff       	jmp    c010276a <__alltraps>

c0102a1f <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a1f:	6a 00                	push   $0x0
  pushl $74
c0102a21:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a23:	e9 42 fd ff ff       	jmp    c010276a <__alltraps>

c0102a28 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a28:	6a 00                	push   $0x0
  pushl $75
c0102a2a:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a2c:	e9 39 fd ff ff       	jmp    c010276a <__alltraps>

c0102a31 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a31:	6a 00                	push   $0x0
  pushl $76
c0102a33:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a35:	e9 30 fd ff ff       	jmp    c010276a <__alltraps>

c0102a3a <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a3a:	6a 00                	push   $0x0
  pushl $77
c0102a3c:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a3e:	e9 27 fd ff ff       	jmp    c010276a <__alltraps>

c0102a43 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a43:	6a 00                	push   $0x0
  pushl $78
c0102a45:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a47:	e9 1e fd ff ff       	jmp    c010276a <__alltraps>

c0102a4c <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a4c:	6a 00                	push   $0x0
  pushl $79
c0102a4e:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a50:	e9 15 fd ff ff       	jmp    c010276a <__alltraps>

c0102a55 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a55:	6a 00                	push   $0x0
  pushl $80
c0102a57:	6a 50                	push   $0x50
  jmp __alltraps
c0102a59:	e9 0c fd ff ff       	jmp    c010276a <__alltraps>

c0102a5e <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a5e:	6a 00                	push   $0x0
  pushl $81
c0102a60:	6a 51                	push   $0x51
  jmp __alltraps
c0102a62:	e9 03 fd ff ff       	jmp    c010276a <__alltraps>

c0102a67 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a67:	6a 00                	push   $0x0
  pushl $82
c0102a69:	6a 52                	push   $0x52
  jmp __alltraps
c0102a6b:	e9 fa fc ff ff       	jmp    c010276a <__alltraps>

c0102a70 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a70:	6a 00                	push   $0x0
  pushl $83
c0102a72:	6a 53                	push   $0x53
  jmp __alltraps
c0102a74:	e9 f1 fc ff ff       	jmp    c010276a <__alltraps>

c0102a79 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a79:	6a 00                	push   $0x0
  pushl $84
c0102a7b:	6a 54                	push   $0x54
  jmp __alltraps
c0102a7d:	e9 e8 fc ff ff       	jmp    c010276a <__alltraps>

c0102a82 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a82:	6a 00                	push   $0x0
  pushl $85
c0102a84:	6a 55                	push   $0x55
  jmp __alltraps
c0102a86:	e9 df fc ff ff       	jmp    c010276a <__alltraps>

c0102a8b <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a8b:	6a 00                	push   $0x0
  pushl $86
c0102a8d:	6a 56                	push   $0x56
  jmp __alltraps
c0102a8f:	e9 d6 fc ff ff       	jmp    c010276a <__alltraps>

c0102a94 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a94:	6a 00                	push   $0x0
  pushl $87
c0102a96:	6a 57                	push   $0x57
  jmp __alltraps
c0102a98:	e9 cd fc ff ff       	jmp    c010276a <__alltraps>

c0102a9d <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a9d:	6a 00                	push   $0x0
  pushl $88
c0102a9f:	6a 58                	push   $0x58
  jmp __alltraps
c0102aa1:	e9 c4 fc ff ff       	jmp    c010276a <__alltraps>

c0102aa6 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $89
c0102aa8:	6a 59                	push   $0x59
  jmp __alltraps
c0102aaa:	e9 bb fc ff ff       	jmp    c010276a <__alltraps>

c0102aaf <vector90>:
.globl vector90
vector90:
  pushl $0
c0102aaf:	6a 00                	push   $0x0
  pushl $90
c0102ab1:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102ab3:	e9 b2 fc ff ff       	jmp    c010276a <__alltraps>

c0102ab8 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102ab8:	6a 00                	push   $0x0
  pushl $91
c0102aba:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102abc:	e9 a9 fc ff ff       	jmp    c010276a <__alltraps>

c0102ac1 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ac1:	6a 00                	push   $0x0
  pushl $92
c0102ac3:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102ac5:	e9 a0 fc ff ff       	jmp    c010276a <__alltraps>

c0102aca <vector93>:
.globl vector93
vector93:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $93
c0102acc:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102ace:	e9 97 fc ff ff       	jmp    c010276a <__alltraps>

c0102ad3 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102ad3:	6a 00                	push   $0x0
  pushl $94
c0102ad5:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102ad7:	e9 8e fc ff ff       	jmp    c010276a <__alltraps>

c0102adc <vector95>:
.globl vector95
vector95:
  pushl $0
c0102adc:	6a 00                	push   $0x0
  pushl $95
c0102ade:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102ae0:	e9 85 fc ff ff       	jmp    c010276a <__alltraps>

c0102ae5 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ae5:	6a 00                	push   $0x0
  pushl $96
c0102ae7:	6a 60                	push   $0x60
  jmp __alltraps
c0102ae9:	e9 7c fc ff ff       	jmp    c010276a <__alltraps>

c0102aee <vector97>:
.globl vector97
vector97:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $97
c0102af0:	6a 61                	push   $0x61
  jmp __alltraps
c0102af2:	e9 73 fc ff ff       	jmp    c010276a <__alltraps>

c0102af7 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102af7:	6a 00                	push   $0x0
  pushl $98
c0102af9:	6a 62                	push   $0x62
  jmp __alltraps
c0102afb:	e9 6a fc ff ff       	jmp    c010276a <__alltraps>

c0102b00 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102b00:	6a 00                	push   $0x0
  pushl $99
c0102b02:	6a 63                	push   $0x63
  jmp __alltraps
c0102b04:	e9 61 fc ff ff       	jmp    c010276a <__alltraps>

c0102b09 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b09:	6a 00                	push   $0x0
  pushl $100
c0102b0b:	6a 64                	push   $0x64
  jmp __alltraps
c0102b0d:	e9 58 fc ff ff       	jmp    c010276a <__alltraps>

c0102b12 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $101
c0102b14:	6a 65                	push   $0x65
  jmp __alltraps
c0102b16:	e9 4f fc ff ff       	jmp    c010276a <__alltraps>

c0102b1b <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b1b:	6a 00                	push   $0x0
  pushl $102
c0102b1d:	6a 66                	push   $0x66
  jmp __alltraps
c0102b1f:	e9 46 fc ff ff       	jmp    c010276a <__alltraps>

c0102b24 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b24:	6a 00                	push   $0x0
  pushl $103
c0102b26:	6a 67                	push   $0x67
  jmp __alltraps
c0102b28:	e9 3d fc ff ff       	jmp    c010276a <__alltraps>

c0102b2d <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b2d:	6a 00                	push   $0x0
  pushl $104
c0102b2f:	6a 68                	push   $0x68
  jmp __alltraps
c0102b31:	e9 34 fc ff ff       	jmp    c010276a <__alltraps>

c0102b36 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $105
c0102b38:	6a 69                	push   $0x69
  jmp __alltraps
c0102b3a:	e9 2b fc ff ff       	jmp    c010276a <__alltraps>

c0102b3f <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b3f:	6a 00                	push   $0x0
  pushl $106
c0102b41:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b43:	e9 22 fc ff ff       	jmp    c010276a <__alltraps>

c0102b48 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b48:	6a 00                	push   $0x0
  pushl $107
c0102b4a:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b4c:	e9 19 fc ff ff       	jmp    c010276a <__alltraps>

c0102b51 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b51:	6a 00                	push   $0x0
  pushl $108
c0102b53:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b55:	e9 10 fc ff ff       	jmp    c010276a <__alltraps>

c0102b5a <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $109
c0102b5c:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b5e:	e9 07 fc ff ff       	jmp    c010276a <__alltraps>

c0102b63 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b63:	6a 00                	push   $0x0
  pushl $110
c0102b65:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b67:	e9 fe fb ff ff       	jmp    c010276a <__alltraps>

c0102b6c <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b6c:	6a 00                	push   $0x0
  pushl $111
c0102b6e:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b70:	e9 f5 fb ff ff       	jmp    c010276a <__alltraps>

c0102b75 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b75:	6a 00                	push   $0x0
  pushl $112
c0102b77:	6a 70                	push   $0x70
  jmp __alltraps
c0102b79:	e9 ec fb ff ff       	jmp    c010276a <__alltraps>

c0102b7e <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $113
c0102b80:	6a 71                	push   $0x71
  jmp __alltraps
c0102b82:	e9 e3 fb ff ff       	jmp    c010276a <__alltraps>

c0102b87 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b87:	6a 00                	push   $0x0
  pushl $114
c0102b89:	6a 72                	push   $0x72
  jmp __alltraps
c0102b8b:	e9 da fb ff ff       	jmp    c010276a <__alltraps>

c0102b90 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b90:	6a 00                	push   $0x0
  pushl $115
c0102b92:	6a 73                	push   $0x73
  jmp __alltraps
c0102b94:	e9 d1 fb ff ff       	jmp    c010276a <__alltraps>

c0102b99 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b99:	6a 00                	push   $0x0
  pushl $116
c0102b9b:	6a 74                	push   $0x74
  jmp __alltraps
c0102b9d:	e9 c8 fb ff ff       	jmp    c010276a <__alltraps>

c0102ba2 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $117
c0102ba4:	6a 75                	push   $0x75
  jmp __alltraps
c0102ba6:	e9 bf fb ff ff       	jmp    c010276a <__alltraps>

c0102bab <vector118>:
.globl vector118
vector118:
  pushl $0
c0102bab:	6a 00                	push   $0x0
  pushl $118
c0102bad:	6a 76                	push   $0x76
  jmp __alltraps
c0102baf:	e9 b6 fb ff ff       	jmp    c010276a <__alltraps>

c0102bb4 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bb4:	6a 00                	push   $0x0
  pushl $119
c0102bb6:	6a 77                	push   $0x77
  jmp __alltraps
c0102bb8:	e9 ad fb ff ff       	jmp    c010276a <__alltraps>

c0102bbd <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bbd:	6a 00                	push   $0x0
  pushl $120
c0102bbf:	6a 78                	push   $0x78
  jmp __alltraps
c0102bc1:	e9 a4 fb ff ff       	jmp    c010276a <__alltraps>

c0102bc6 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $121
c0102bc8:	6a 79                	push   $0x79
  jmp __alltraps
c0102bca:	e9 9b fb ff ff       	jmp    c010276a <__alltraps>

c0102bcf <vector122>:
.globl vector122
vector122:
  pushl $0
c0102bcf:	6a 00                	push   $0x0
  pushl $122
c0102bd1:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bd3:	e9 92 fb ff ff       	jmp    c010276a <__alltraps>

c0102bd8 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bd8:	6a 00                	push   $0x0
  pushl $123
c0102bda:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bdc:	e9 89 fb ff ff       	jmp    c010276a <__alltraps>

c0102be1 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102be1:	6a 00                	push   $0x0
  pushl $124
c0102be3:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102be5:	e9 80 fb ff ff       	jmp    c010276a <__alltraps>

c0102bea <vector125>:
.globl vector125
vector125:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $125
c0102bec:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bee:	e9 77 fb ff ff       	jmp    c010276a <__alltraps>

c0102bf3 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bf3:	6a 00                	push   $0x0
  pushl $126
c0102bf5:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bf7:	e9 6e fb ff ff       	jmp    c010276a <__alltraps>

c0102bfc <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bfc:	6a 00                	push   $0x0
  pushl $127
c0102bfe:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102c00:	e9 65 fb ff ff       	jmp    c010276a <__alltraps>

c0102c05 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c05:	6a 00                	push   $0x0
  pushl $128
c0102c07:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c0c:	e9 59 fb ff ff       	jmp    c010276a <__alltraps>

c0102c11 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c11:	6a 00                	push   $0x0
  pushl $129
c0102c13:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c18:	e9 4d fb ff ff       	jmp    c010276a <__alltraps>

c0102c1d <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c1d:	6a 00                	push   $0x0
  pushl $130
c0102c1f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c24:	e9 41 fb ff ff       	jmp    c010276a <__alltraps>

c0102c29 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c29:	6a 00                	push   $0x0
  pushl $131
c0102c2b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c30:	e9 35 fb ff ff       	jmp    c010276a <__alltraps>

c0102c35 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c35:	6a 00                	push   $0x0
  pushl $132
c0102c37:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c3c:	e9 29 fb ff ff       	jmp    c010276a <__alltraps>

c0102c41 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c41:	6a 00                	push   $0x0
  pushl $133
c0102c43:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c48:	e9 1d fb ff ff       	jmp    c010276a <__alltraps>

c0102c4d <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c4d:	6a 00                	push   $0x0
  pushl $134
c0102c4f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c54:	e9 11 fb ff ff       	jmp    c010276a <__alltraps>

c0102c59 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c59:	6a 00                	push   $0x0
  pushl $135
c0102c5b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c60:	e9 05 fb ff ff       	jmp    c010276a <__alltraps>

c0102c65 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c65:	6a 00                	push   $0x0
  pushl $136
c0102c67:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c6c:	e9 f9 fa ff ff       	jmp    c010276a <__alltraps>

c0102c71 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c71:	6a 00                	push   $0x0
  pushl $137
c0102c73:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c78:	e9 ed fa ff ff       	jmp    c010276a <__alltraps>

c0102c7d <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c7d:	6a 00                	push   $0x0
  pushl $138
c0102c7f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c84:	e9 e1 fa ff ff       	jmp    c010276a <__alltraps>

c0102c89 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c89:	6a 00                	push   $0x0
  pushl $139
c0102c8b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c90:	e9 d5 fa ff ff       	jmp    c010276a <__alltraps>

c0102c95 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c95:	6a 00                	push   $0x0
  pushl $140
c0102c97:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c9c:	e9 c9 fa ff ff       	jmp    c010276a <__alltraps>

c0102ca1 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102ca1:	6a 00                	push   $0x0
  pushl $141
c0102ca3:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ca8:	e9 bd fa ff ff       	jmp    c010276a <__alltraps>

c0102cad <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cad:	6a 00                	push   $0x0
  pushl $142
c0102caf:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cb4:	e9 b1 fa ff ff       	jmp    c010276a <__alltraps>

c0102cb9 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cb9:	6a 00                	push   $0x0
  pushl $143
c0102cbb:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cc0:	e9 a5 fa ff ff       	jmp    c010276a <__alltraps>

c0102cc5 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cc5:	6a 00                	push   $0x0
  pushl $144
c0102cc7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ccc:	e9 99 fa ff ff       	jmp    c010276a <__alltraps>

c0102cd1 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102cd1:	6a 00                	push   $0x0
  pushl $145
c0102cd3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cd8:	e9 8d fa ff ff       	jmp    c010276a <__alltraps>

c0102cdd <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cdd:	6a 00                	push   $0x0
  pushl $146
c0102cdf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ce4:	e9 81 fa ff ff       	jmp    c010276a <__alltraps>

c0102ce9 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102ce9:	6a 00                	push   $0x0
  pushl $147
c0102ceb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cf0:	e9 75 fa ff ff       	jmp    c010276a <__alltraps>

c0102cf5 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cf5:	6a 00                	push   $0x0
  pushl $148
c0102cf7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cfc:	e9 69 fa ff ff       	jmp    c010276a <__alltraps>

c0102d01 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d01:	6a 00                	push   $0x0
  pushl $149
c0102d03:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d08:	e9 5d fa ff ff       	jmp    c010276a <__alltraps>

c0102d0d <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d0d:	6a 00                	push   $0x0
  pushl $150
c0102d0f:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d14:	e9 51 fa ff ff       	jmp    c010276a <__alltraps>

c0102d19 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d19:	6a 00                	push   $0x0
  pushl $151
c0102d1b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d20:	e9 45 fa ff ff       	jmp    c010276a <__alltraps>

c0102d25 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d25:	6a 00                	push   $0x0
  pushl $152
c0102d27:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d2c:	e9 39 fa ff ff       	jmp    c010276a <__alltraps>

c0102d31 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d31:	6a 00                	push   $0x0
  pushl $153
c0102d33:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d38:	e9 2d fa ff ff       	jmp    c010276a <__alltraps>

c0102d3d <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d3d:	6a 00                	push   $0x0
  pushl $154
c0102d3f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d44:	e9 21 fa ff ff       	jmp    c010276a <__alltraps>

c0102d49 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d49:	6a 00                	push   $0x0
  pushl $155
c0102d4b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d50:	e9 15 fa ff ff       	jmp    c010276a <__alltraps>

c0102d55 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d55:	6a 00                	push   $0x0
  pushl $156
c0102d57:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d5c:	e9 09 fa ff ff       	jmp    c010276a <__alltraps>

c0102d61 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d61:	6a 00                	push   $0x0
  pushl $157
c0102d63:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d68:	e9 fd f9 ff ff       	jmp    c010276a <__alltraps>

c0102d6d <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d6d:	6a 00                	push   $0x0
  pushl $158
c0102d6f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d74:	e9 f1 f9 ff ff       	jmp    c010276a <__alltraps>

c0102d79 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d79:	6a 00                	push   $0x0
  pushl $159
c0102d7b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d80:	e9 e5 f9 ff ff       	jmp    c010276a <__alltraps>

c0102d85 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d85:	6a 00                	push   $0x0
  pushl $160
c0102d87:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d8c:	e9 d9 f9 ff ff       	jmp    c010276a <__alltraps>

c0102d91 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d91:	6a 00                	push   $0x0
  pushl $161
c0102d93:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d98:	e9 cd f9 ff ff       	jmp    c010276a <__alltraps>

c0102d9d <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d9d:	6a 00                	push   $0x0
  pushl $162
c0102d9f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102da4:	e9 c1 f9 ff ff       	jmp    c010276a <__alltraps>

c0102da9 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102da9:	6a 00                	push   $0x0
  pushl $163
c0102dab:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102db0:	e9 b5 f9 ff ff       	jmp    c010276a <__alltraps>

c0102db5 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102db5:	6a 00                	push   $0x0
  pushl $164
c0102db7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102dbc:	e9 a9 f9 ff ff       	jmp    c010276a <__alltraps>

c0102dc1 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dc1:	6a 00                	push   $0x0
  pushl $165
c0102dc3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102dc8:	e9 9d f9 ff ff       	jmp    c010276a <__alltraps>

c0102dcd <vector166>:
.globl vector166
vector166:
  pushl $0
c0102dcd:	6a 00                	push   $0x0
  pushl $166
c0102dcf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102dd4:	e9 91 f9 ff ff       	jmp    c010276a <__alltraps>

c0102dd9 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102dd9:	6a 00                	push   $0x0
  pushl $167
c0102ddb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102de0:	e9 85 f9 ff ff       	jmp    c010276a <__alltraps>

c0102de5 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102de5:	6a 00                	push   $0x0
  pushl $168
c0102de7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102dec:	e9 79 f9 ff ff       	jmp    c010276a <__alltraps>

c0102df1 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102df1:	6a 00                	push   $0x0
  pushl $169
c0102df3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102df8:	e9 6d f9 ff ff       	jmp    c010276a <__alltraps>

c0102dfd <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dfd:	6a 00                	push   $0x0
  pushl $170
c0102dff:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e04:	e9 61 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e09 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e09:	6a 00                	push   $0x0
  pushl $171
c0102e0b:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e10:	e9 55 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e15 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e15:	6a 00                	push   $0x0
  pushl $172
c0102e17:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e1c:	e9 49 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e21 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e21:	6a 00                	push   $0x0
  pushl $173
c0102e23:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e28:	e9 3d f9 ff ff       	jmp    c010276a <__alltraps>

c0102e2d <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e2d:	6a 00                	push   $0x0
  pushl $174
c0102e2f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e34:	e9 31 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e39 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e39:	6a 00                	push   $0x0
  pushl $175
c0102e3b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e40:	e9 25 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e45 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e45:	6a 00                	push   $0x0
  pushl $176
c0102e47:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e4c:	e9 19 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e51 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e51:	6a 00                	push   $0x0
  pushl $177
c0102e53:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e58:	e9 0d f9 ff ff       	jmp    c010276a <__alltraps>

c0102e5d <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e5d:	6a 00                	push   $0x0
  pushl $178
c0102e5f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e64:	e9 01 f9 ff ff       	jmp    c010276a <__alltraps>

c0102e69 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e69:	6a 00                	push   $0x0
  pushl $179
c0102e6b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e70:	e9 f5 f8 ff ff       	jmp    c010276a <__alltraps>

c0102e75 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e75:	6a 00                	push   $0x0
  pushl $180
c0102e77:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e7c:	e9 e9 f8 ff ff       	jmp    c010276a <__alltraps>

c0102e81 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e81:	6a 00                	push   $0x0
  pushl $181
c0102e83:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e88:	e9 dd f8 ff ff       	jmp    c010276a <__alltraps>

c0102e8d <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e8d:	6a 00                	push   $0x0
  pushl $182
c0102e8f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e94:	e9 d1 f8 ff ff       	jmp    c010276a <__alltraps>

c0102e99 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e99:	6a 00                	push   $0x0
  pushl $183
c0102e9b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102ea0:	e9 c5 f8 ff ff       	jmp    c010276a <__alltraps>

c0102ea5 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ea5:	6a 00                	push   $0x0
  pushl $184
c0102ea7:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102eac:	e9 b9 f8 ff ff       	jmp    c010276a <__alltraps>

c0102eb1 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102eb1:	6a 00                	push   $0x0
  pushl $185
c0102eb3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102eb8:	e9 ad f8 ff ff       	jmp    c010276a <__alltraps>

c0102ebd <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ebd:	6a 00                	push   $0x0
  pushl $186
c0102ebf:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ec4:	e9 a1 f8 ff ff       	jmp    c010276a <__alltraps>

c0102ec9 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ec9:	6a 00                	push   $0x0
  pushl $187
c0102ecb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ed0:	e9 95 f8 ff ff       	jmp    c010276a <__alltraps>

c0102ed5 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102ed5:	6a 00                	push   $0x0
  pushl $188
c0102ed7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102edc:	e9 89 f8 ff ff       	jmp    c010276a <__alltraps>

c0102ee1 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ee1:	6a 00                	push   $0x0
  pushl $189
c0102ee3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ee8:	e9 7d f8 ff ff       	jmp    c010276a <__alltraps>

c0102eed <vector190>:
.globl vector190
vector190:
  pushl $0
c0102eed:	6a 00                	push   $0x0
  pushl $190
c0102eef:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ef4:	e9 71 f8 ff ff       	jmp    c010276a <__alltraps>

c0102ef9 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ef9:	6a 00                	push   $0x0
  pushl $191
c0102efb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102f00:	e9 65 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f05 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f05:	6a 00                	push   $0x0
  pushl $192
c0102f07:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f0c:	e9 59 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f11 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f11:	6a 00                	push   $0x0
  pushl $193
c0102f13:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f18:	e9 4d f8 ff ff       	jmp    c010276a <__alltraps>

c0102f1d <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f1d:	6a 00                	push   $0x0
  pushl $194
c0102f1f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f24:	e9 41 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f29 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f29:	6a 00                	push   $0x0
  pushl $195
c0102f2b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f30:	e9 35 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f35 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f35:	6a 00                	push   $0x0
  pushl $196
c0102f37:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f3c:	e9 29 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f41 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f41:	6a 00                	push   $0x0
  pushl $197
c0102f43:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f48:	e9 1d f8 ff ff       	jmp    c010276a <__alltraps>

c0102f4d <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f4d:	6a 00                	push   $0x0
  pushl $198
c0102f4f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f54:	e9 11 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f59 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f59:	6a 00                	push   $0x0
  pushl $199
c0102f5b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f60:	e9 05 f8 ff ff       	jmp    c010276a <__alltraps>

c0102f65 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f65:	6a 00                	push   $0x0
  pushl $200
c0102f67:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f6c:	e9 f9 f7 ff ff       	jmp    c010276a <__alltraps>

c0102f71 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f71:	6a 00                	push   $0x0
  pushl $201
c0102f73:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f78:	e9 ed f7 ff ff       	jmp    c010276a <__alltraps>

c0102f7d <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f7d:	6a 00                	push   $0x0
  pushl $202
c0102f7f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f84:	e9 e1 f7 ff ff       	jmp    c010276a <__alltraps>

c0102f89 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f89:	6a 00                	push   $0x0
  pushl $203
c0102f8b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f90:	e9 d5 f7 ff ff       	jmp    c010276a <__alltraps>

c0102f95 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f95:	6a 00                	push   $0x0
  pushl $204
c0102f97:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f9c:	e9 c9 f7 ff ff       	jmp    c010276a <__alltraps>

c0102fa1 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fa1:	6a 00                	push   $0x0
  pushl $205
c0102fa3:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fa8:	e9 bd f7 ff ff       	jmp    c010276a <__alltraps>

c0102fad <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fad:	6a 00                	push   $0x0
  pushl $206
c0102faf:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fb4:	e9 b1 f7 ff ff       	jmp    c010276a <__alltraps>

c0102fb9 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102fb9:	6a 00                	push   $0x0
  pushl $207
c0102fbb:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102fc0:	e9 a5 f7 ff ff       	jmp    c010276a <__alltraps>

c0102fc5 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fc5:	6a 00                	push   $0x0
  pushl $208
c0102fc7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fcc:	e9 99 f7 ff ff       	jmp    c010276a <__alltraps>

c0102fd1 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fd1:	6a 00                	push   $0x0
  pushl $209
c0102fd3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fd8:	e9 8d f7 ff ff       	jmp    c010276a <__alltraps>

c0102fdd <vector210>:
.globl vector210
vector210:
  pushl $0
c0102fdd:	6a 00                	push   $0x0
  pushl $210
c0102fdf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fe4:	e9 81 f7 ff ff       	jmp    c010276a <__alltraps>

c0102fe9 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fe9:	6a 00                	push   $0x0
  pushl $211
c0102feb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102ff0:	e9 75 f7 ff ff       	jmp    c010276a <__alltraps>

c0102ff5 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102ff5:	6a 00                	push   $0x0
  pushl $212
c0102ff7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102ffc:	e9 69 f7 ff ff       	jmp    c010276a <__alltraps>

c0103001 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103001:	6a 00                	push   $0x0
  pushl $213
c0103003:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103008:	e9 5d f7 ff ff       	jmp    c010276a <__alltraps>

c010300d <vector214>:
.globl vector214
vector214:
  pushl $0
c010300d:	6a 00                	push   $0x0
  pushl $214
c010300f:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103014:	e9 51 f7 ff ff       	jmp    c010276a <__alltraps>

c0103019 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103019:	6a 00                	push   $0x0
  pushl $215
c010301b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103020:	e9 45 f7 ff ff       	jmp    c010276a <__alltraps>

c0103025 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103025:	6a 00                	push   $0x0
  pushl $216
c0103027:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010302c:	e9 39 f7 ff ff       	jmp    c010276a <__alltraps>

c0103031 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103031:	6a 00                	push   $0x0
  pushl $217
c0103033:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103038:	e9 2d f7 ff ff       	jmp    c010276a <__alltraps>

c010303d <vector218>:
.globl vector218
vector218:
  pushl $0
c010303d:	6a 00                	push   $0x0
  pushl $218
c010303f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103044:	e9 21 f7 ff ff       	jmp    c010276a <__alltraps>

c0103049 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103049:	6a 00                	push   $0x0
  pushl $219
c010304b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103050:	e9 15 f7 ff ff       	jmp    c010276a <__alltraps>

c0103055 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103055:	6a 00                	push   $0x0
  pushl $220
c0103057:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010305c:	e9 09 f7 ff ff       	jmp    c010276a <__alltraps>

c0103061 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103061:	6a 00                	push   $0x0
  pushl $221
c0103063:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103068:	e9 fd f6 ff ff       	jmp    c010276a <__alltraps>

c010306d <vector222>:
.globl vector222
vector222:
  pushl $0
c010306d:	6a 00                	push   $0x0
  pushl $222
c010306f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103074:	e9 f1 f6 ff ff       	jmp    c010276a <__alltraps>

c0103079 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103079:	6a 00                	push   $0x0
  pushl $223
c010307b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103080:	e9 e5 f6 ff ff       	jmp    c010276a <__alltraps>

c0103085 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103085:	6a 00                	push   $0x0
  pushl $224
c0103087:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010308c:	e9 d9 f6 ff ff       	jmp    c010276a <__alltraps>

c0103091 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103091:	6a 00                	push   $0x0
  pushl $225
c0103093:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103098:	e9 cd f6 ff ff       	jmp    c010276a <__alltraps>

c010309d <vector226>:
.globl vector226
vector226:
  pushl $0
c010309d:	6a 00                	push   $0x0
  pushl $226
c010309f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030a4:	e9 c1 f6 ff ff       	jmp    c010276a <__alltraps>

c01030a9 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030a9:	6a 00                	push   $0x0
  pushl $227
c01030ab:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030b0:	e9 b5 f6 ff ff       	jmp    c010276a <__alltraps>

c01030b5 <vector228>:
.globl vector228
vector228:
  pushl $0
c01030b5:	6a 00                	push   $0x0
  pushl $228
c01030b7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030bc:	e9 a9 f6 ff ff       	jmp    c010276a <__alltraps>

c01030c1 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030c1:	6a 00                	push   $0x0
  pushl $229
c01030c3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030c8:	e9 9d f6 ff ff       	jmp    c010276a <__alltraps>

c01030cd <vector230>:
.globl vector230
vector230:
  pushl $0
c01030cd:	6a 00                	push   $0x0
  pushl $230
c01030cf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030d4:	e9 91 f6 ff ff       	jmp    c010276a <__alltraps>

c01030d9 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030d9:	6a 00                	push   $0x0
  pushl $231
c01030db:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030e0:	e9 85 f6 ff ff       	jmp    c010276a <__alltraps>

c01030e5 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030e5:	6a 00                	push   $0x0
  pushl $232
c01030e7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030ec:	e9 79 f6 ff ff       	jmp    c010276a <__alltraps>

c01030f1 <vector233>:
.globl vector233
vector233:
  pushl $0
c01030f1:	6a 00                	push   $0x0
  pushl $233
c01030f3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030f8:	e9 6d f6 ff ff       	jmp    c010276a <__alltraps>

c01030fd <vector234>:
.globl vector234
vector234:
  pushl $0
c01030fd:	6a 00                	push   $0x0
  pushl $234
c01030ff:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103104:	e9 61 f6 ff ff       	jmp    c010276a <__alltraps>

c0103109 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103109:	6a 00                	push   $0x0
  pushl $235
c010310b:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103110:	e9 55 f6 ff ff       	jmp    c010276a <__alltraps>

c0103115 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103115:	6a 00                	push   $0x0
  pushl $236
c0103117:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010311c:	e9 49 f6 ff ff       	jmp    c010276a <__alltraps>

c0103121 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103121:	6a 00                	push   $0x0
  pushl $237
c0103123:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103128:	e9 3d f6 ff ff       	jmp    c010276a <__alltraps>

c010312d <vector238>:
.globl vector238
vector238:
  pushl $0
c010312d:	6a 00                	push   $0x0
  pushl $238
c010312f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103134:	e9 31 f6 ff ff       	jmp    c010276a <__alltraps>

c0103139 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103139:	6a 00                	push   $0x0
  pushl $239
c010313b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103140:	e9 25 f6 ff ff       	jmp    c010276a <__alltraps>

c0103145 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103145:	6a 00                	push   $0x0
  pushl $240
c0103147:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010314c:	e9 19 f6 ff ff       	jmp    c010276a <__alltraps>

c0103151 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103151:	6a 00                	push   $0x0
  pushl $241
c0103153:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103158:	e9 0d f6 ff ff       	jmp    c010276a <__alltraps>

c010315d <vector242>:
.globl vector242
vector242:
  pushl $0
c010315d:	6a 00                	push   $0x0
  pushl $242
c010315f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103164:	e9 01 f6 ff ff       	jmp    c010276a <__alltraps>

c0103169 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103169:	6a 00                	push   $0x0
  pushl $243
c010316b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103170:	e9 f5 f5 ff ff       	jmp    c010276a <__alltraps>

c0103175 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103175:	6a 00                	push   $0x0
  pushl $244
c0103177:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010317c:	e9 e9 f5 ff ff       	jmp    c010276a <__alltraps>

c0103181 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103181:	6a 00                	push   $0x0
  pushl $245
c0103183:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103188:	e9 dd f5 ff ff       	jmp    c010276a <__alltraps>

c010318d <vector246>:
.globl vector246
vector246:
  pushl $0
c010318d:	6a 00                	push   $0x0
  pushl $246
c010318f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103194:	e9 d1 f5 ff ff       	jmp    c010276a <__alltraps>

c0103199 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103199:	6a 00                	push   $0x0
  pushl $247
c010319b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01031a0:	e9 c5 f5 ff ff       	jmp    c010276a <__alltraps>

c01031a5 <vector248>:
.globl vector248
vector248:
  pushl $0
c01031a5:	6a 00                	push   $0x0
  pushl $248
c01031a7:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031ac:	e9 b9 f5 ff ff       	jmp    c010276a <__alltraps>

c01031b1 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031b1:	6a 00                	push   $0x0
  pushl $249
c01031b3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031b8:	e9 ad f5 ff ff       	jmp    c010276a <__alltraps>

c01031bd <vector250>:
.globl vector250
vector250:
  pushl $0
c01031bd:	6a 00                	push   $0x0
  pushl $250
c01031bf:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031c4:	e9 a1 f5 ff ff       	jmp    c010276a <__alltraps>

c01031c9 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031c9:	6a 00                	push   $0x0
  pushl $251
c01031cb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031d0:	e9 95 f5 ff ff       	jmp    c010276a <__alltraps>

c01031d5 <vector252>:
.globl vector252
vector252:
  pushl $0
c01031d5:	6a 00                	push   $0x0
  pushl $252
c01031d7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031dc:	e9 89 f5 ff ff       	jmp    c010276a <__alltraps>

c01031e1 <vector253>:
.globl vector253
vector253:
  pushl $0
c01031e1:	6a 00                	push   $0x0
  pushl $253
c01031e3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031e8:	e9 7d f5 ff ff       	jmp    c010276a <__alltraps>

c01031ed <vector254>:
.globl vector254
vector254:
  pushl $0
c01031ed:	6a 00                	push   $0x0
  pushl $254
c01031ef:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031f4:	e9 71 f5 ff ff       	jmp    c010276a <__alltraps>

c01031f9 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031f9:	6a 00                	push   $0x0
  pushl $255
c01031fb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103200:	e9 65 f5 ff ff       	jmp    c010276a <__alltraps>

c0103205 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103205:	55                   	push   %ebp
c0103206:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103208:	8b 55 08             	mov    0x8(%ebp),%edx
c010320b:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0103210:	29 c2                	sub    %eax,%edx
c0103212:	89 d0                	mov    %edx,%eax
c0103214:	c1 f8 05             	sar    $0x5,%eax
}
c0103217:	5d                   	pop    %ebp
c0103218:	c3                   	ret    

c0103219 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103219:	55                   	push   %ebp
c010321a:	89 e5                	mov    %esp,%ebp
c010321c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010321f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103222:	89 04 24             	mov    %eax,(%esp)
c0103225:	e8 db ff ff ff       	call   c0103205 <page2ppn>
c010322a:	c1 e0 0c             	shl    $0xc,%eax
}
c010322d:	c9                   	leave  
c010322e:	c3                   	ret    

c010322f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010322f:	55                   	push   %ebp
c0103230:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103232:	8b 45 08             	mov    0x8(%ebp),%eax
c0103235:	8b 00                	mov    (%eax),%eax
}
c0103237:	5d                   	pop    %ebp
c0103238:	c3                   	ret    

c0103239 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103239:	55                   	push   %ebp
c010323a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010323c:	8b 45 08             	mov    0x8(%ebp),%eax
c010323f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103242:	89 10                	mov    %edx,(%eax)
}
c0103244:	5d                   	pop    %ebp
c0103245:	c3                   	ret    

c0103246 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103246:	55                   	push   %ebp
c0103247:	89 e5                	mov    %esp,%ebp
c0103249:	83 ec 10             	sub    $0x10,%esp
c010324c:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103253:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103256:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103259:	89 50 04             	mov    %edx,0x4(%eax)
c010325c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010325f:	8b 50 04             	mov    0x4(%eax),%edx
c0103262:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103265:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103267:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c010326e:	00 00 00 
}
c0103271:	c9                   	leave  
c0103272:	c3                   	ret    

c0103273 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103273:	55                   	push   %ebp
c0103274:	89 e5                	mov    %esp,%ebp
c0103276:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103279:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010327d:	75 24                	jne    c01032a3 <default_init_memmap+0x30>
c010327f:	c7 44 24 0c 10 a5 10 	movl   $0xc010a510,0xc(%esp)
c0103286:	c0 
c0103287:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010328e:	c0 
c010328f:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103296:	00 
c0103297:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010329e:	e8 39 da ff ff       	call   c0100cdc <__panic>
    struct Page* p = base;
c01032a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; p != base + n; p ++)
c01032a9:	e9 d2 00 00 00       	jmp    c0103380 <default_init_memmap+0x10d>
    {
	assert(PageReserved(p));
c01032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032b1:	83 c0 04             	add    $0x4,%eax
c01032b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032c4:	0f a3 10             	bt     %edx,(%eax)
c01032c7:	19 c0                	sbb    %eax,%eax
c01032c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032d0:	0f 95 c0             	setne  %al
c01032d3:	0f b6 c0             	movzbl %al,%eax
c01032d6:	85 c0                	test   %eax,%eax
c01032d8:	75 24                	jne    c01032fe <default_init_memmap+0x8b>
c01032da:	c7 44 24 0c 41 a5 10 	movl   $0xc010a541,0xc(%esp)
c01032e1:	c0 
c01032e2:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01032e9:	c0 
c01032ea:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c01032f1:	00 
c01032f2:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01032f9:	e8 de d9 ff ff       	call   c0100cdc <__panic>
	SetPageProperty(p);
c01032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103301:	83 c0 04             	add    $0x4,%eax
c0103304:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010330b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010330e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103314:	0f ab 10             	bts    %edx,(%eax)
	p->property = 0;
c0103317:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010331a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
c0103321:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103328:	00 
c0103329:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010332c:	89 04 24             	mov    %eax,(%esp)
c010332f:	e8 05 ff ff ff       	call   c0103239 <set_page_ref>
	list_add_before(&free_list, &(p->page_link));
c0103334:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103337:	83 c0 0c             	add    $0xc,%eax
c010333a:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c0103341:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103344:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103347:	8b 00                	mov    (%eax),%eax
c0103349:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010334c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010334f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103352:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103355:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103358:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010335b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010335e:	89 10                	mov    %edx,(%eax)
c0103360:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103363:	8b 10                	mov    (%eax),%edx
c0103365:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103368:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010336b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010336e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103371:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103377:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010337a:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for(; p != base + n; p ++)
c010337c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103380:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103383:	c1 e0 05             	shl    $0x5,%eax
c0103386:	89 c2                	mov    %eax,%edx
c0103388:	8b 45 08             	mov    0x8(%ebp),%eax
c010338b:	01 d0                	add    %edx,%eax
c010338d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103390:	0f 85 18 ff ff ff    	jne    c01032ae <default_init_memmap+0x3b>
	SetPageProperty(p);
	p->property = 0;
	set_page_ref(p, 0);
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0103396:	8b 45 08             	mov    0x8(%ebp),%eax
c0103399:	8b 55 0c             	mov    0xc(%ebp),%edx
c010339c:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free+=n;
c010339f:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c01033a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a8:	01 d0                	add    %edx,%eax
c01033aa:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
}
c01033af:	c9                   	leave  
c01033b0:	c3                   	ret    

c01033b1 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033b1:	55                   	push   %ebp
c01033b2:	89 e5                	mov    %esp,%ebp
c01033b4:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033bb:	75 24                	jne    c01033e1 <default_alloc_pages+0x30>
c01033bd:	c7 44 24 0c 10 a5 10 	movl   $0xc010a510,0xc(%esp)
c01033c4:	c0 
c01033c5:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01033cc:	c0 
c01033cd:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c01033d4:	00 
c01033d5:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01033dc:	e8 fb d8 ff ff       	call   c0100cdc <__panic>
    if(n > nr_free){
c01033e1:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01033e6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033e9:	73 0a                	jae    c01033f5 <default_alloc_pages+0x44>
	return NULL;
c01033eb:	b8 00 00 00 00       	mov    $0x0,%eax
c01033f0:	e9 45 01 00 00       	jmp    c010353a <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
c01033f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01033fc:	c7 45 f0 18 7b 12 c0 	movl   $0xc0127b18,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103403:	eb 1c                	jmp    c0103421 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0103405:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103408:	83 e8 0c             	sub    $0xc,%eax
c010340b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c010340e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103411:	8b 40 08             	mov    0x8(%eax),%eax
c0103414:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103417:	72 08                	jb     c0103421 <default_alloc_pages+0x70>
            page = p;
c0103419:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010341c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010341f:	eb 18                	jmp    c0103439 <default_alloc_pages+0x88>
c0103421:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103424:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103427:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010342a:	8b 40 04             	mov    0x4(%eax),%eax
    if(n > nr_free){
	return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010342d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103430:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103437:	75 cc                	jne    c0103405 <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
c0103439:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010343d:	0f 84 f2 00 00 00    	je     c0103535 <default_alloc_pages+0x184>
	int i = n;
c0103443:	8b 45 08             	mov    0x8(%ebp),%eax
c0103446:	89 45 ec             	mov    %eax,-0x14(%ebp)
	while(i--)
c0103449:	eb 78                	jmp    c01034c3 <default_alloc_pages+0x112>
c010344b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010344e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103451:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103454:	8b 40 04             	mov    0x4(%eax),%eax
	{
	    tle = list_next(le);
c0103457:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    struct Page *tp = le2page(le, page_link);
c010345a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010345d:	83 e8 0c             	sub    $0xc,%eax
c0103460:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    SetPageReserved(tp);
c0103463:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103466:	83 c0 04             	add    $0x4,%eax
c0103469:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0103470:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103473:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103476:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103479:	0f ab 10             	bts    %edx,(%eax)
	    ClearPageProperty(tp);
c010347c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010347f:	83 c0 04             	add    $0x4,%eax
c0103482:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103489:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010348c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010348f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103492:	0f b3 10             	btr    %edx,(%eax)
c0103495:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103498:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010349b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010349e:	8b 40 04             	mov    0x4(%eax),%eax
c01034a1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01034a4:	8b 12                	mov    (%edx),%edx
c01034a6:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01034a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01034ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01034af:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01034b2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01034b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034b8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034bb:	89 10                	mov    %edx,(%eax)
	    list_del(le);
	    le = tle;
c01034bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
	int i = n;
	while(i--)
c01034c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01034c9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01034cc:	85 c0                	test   %eax,%eax
c01034ce:	0f 85 77 ff ff ff    	jne    c010344b <default_alloc_pages+0x9a>
	    SetPageReserved(tp);
	    ClearPageProperty(tp);
	    list_del(le);
	    le = tle;
	}
	if(page->property > n)
c01034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d7:	8b 40 08             	mov    0x8(%eax),%eax
c01034da:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034dd:	76 12                	jbe    c01034f1 <default_alloc_pages+0x140>
	{
	    (le2page(le,page_link))->property = page->property - n;
c01034df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034e2:	8d 50 f4             	lea    -0xc(%eax),%edx
c01034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e8:	8b 40 08             	mov    0x8(%eax),%eax
c01034eb:	2b 45 08             	sub    0x8(%ebp),%eax
c01034ee:	89 42 08             	mov    %eax,0x8(%edx)
	}
	ClearPageProperty(page);
c01034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034f4:	83 c0 04             	add    $0x4,%eax
c01034f7:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01034fe:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103501:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103504:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0103507:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(page);
c010350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010350d:	83 c0 04             	add    $0x4,%eax
c0103510:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
c0103517:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010351a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010351d:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103520:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;
c0103523:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103528:	2b 45 08             	sub    0x8(%ebp),%eax
c010352b:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
	return page;
c0103530:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103533:	eb 05                	jmp    c010353a <default_alloc_pages+0x189>
    }
    return NULL;
c0103535:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010353a:	c9                   	leave  
c010353b:	c3                   	ret    

c010353c <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010353c:	55                   	push   %ebp
c010353d:	89 e5                	mov    %esp,%ebp
c010353f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103546:	75 24                	jne    c010356c <default_free_pages+0x30>
c0103548:	c7 44 24 0c 10 a5 10 	movl   $0xc010a510,0xc(%esp)
c010354f:	c0 
c0103550:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103557:	c0 
c0103558:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c010355f:	00 
c0103560:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103567:	e8 70 d7 ff ff       	call   c0100cdc <__panic>
    struct Page *p = base;
c010356c:	8b 45 08             	mov    0x8(%ebp),%eax
c010356f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103572:	c7 45 f0 18 7b 12 c0 	movl   $0xc0127b18,-0x10(%ebp)
    while((le = list_next(le)) != &free_list)
c0103579:	eb 13                	jmp    c010358e <default_free_pages+0x52>
    {
	p = le2page(le, page_link);
c010357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010357e:	83 e8 0c             	sub    $0xc,%eax
c0103581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > base) 
c0103584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103587:	3b 45 08             	cmp    0x8(%ebp),%eax
c010358a:	76 02                	jbe    c010358e <default_free_pages+0x52>
	    break;
c010358c:	eb 18                	jmp    c01035a6 <default_free_pages+0x6a>
c010358e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103591:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103594:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103597:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list)
c010359a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010359d:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c01035a4:	75 d5                	jne    c010357b <default_free_pages+0x3f>
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c01035a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01035a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035ac:	eb 4b                	jmp    c01035f9 <default_free_pages+0xbd>
	list_add_before(le, &(p->page_link));
c01035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b1:	8d 50 0c             	lea    0xc(%eax),%edx
c01035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01035ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01035bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035c0:	8b 00                	mov    (%eax),%eax
c01035c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01035c5:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01035c8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01035d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01035d7:	89 10                	mov    %edx,(%eax)
c01035d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035dc:	8b 10                	mov    (%eax),%edx
c01035de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01035ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01035f3:	89 10                	mov    %edx,(%eax)
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c01035f5:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01035f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035fc:	c1 e0 05             	shl    $0x5,%eax
c01035ff:	89 c2                	mov    %eax,%edx
c0103601:	8b 45 08             	mov    0x8(%ebp),%eax
c0103604:	01 d0                	add    %edx,%eax
c0103606:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103609:	77 a3                	ja     c01035ae <default_free_pages+0x72>
	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010360b:	8b 45 08             	mov    0x8(%ebp),%eax
c010360e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103615:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010361c:	00 
c010361d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103620:	89 04 24             	mov    %eax,(%esp)
c0103623:	e8 11 fc ff ff       	call   c0103239 <set_page_ref>
    SetPageProperty(base);
c0103628:	8b 45 08             	mov    0x8(%ebp),%eax
c010362b:	83 c0 04             	add    $0x4,%eax
c010362e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103635:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103638:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010363b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010363e:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0103641:	8b 45 08             	mov    0x8(%ebp),%eax
c0103644:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103647:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c010364a:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103650:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103653:	01 d0                	add    %edx,%eax
c0103655:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    p = le2page(le,page_link) ;
c010365a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010365d:	83 e8 0c             	sub    $0xc,%eax
c0103660:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if( base + n == p ){
c0103663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103666:	c1 e0 05             	shl    $0x5,%eax
c0103669:	89 c2                	mov    %eax,%edx
c010366b:	8b 45 08             	mov    0x8(%ebp),%eax
c010366e:	01 d0                	add    %edx,%eax
c0103670:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103673:	75 1e                	jne    c0103693 <default_free_pages+0x157>
	base->property += p->property;
c0103675:	8b 45 08             	mov    0x8(%ebp),%eax
c0103678:	8b 50 08             	mov    0x8(%eax),%edx
c010367b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010367e:	8b 40 08             	mov    0x8(%eax),%eax
c0103681:	01 c2                	add    %eax,%edx
c0103683:	8b 45 08             	mov    0x8(%ebp),%eax
c0103686:	89 50 08             	mov    %edx,0x8(%eax)
	p->property = 0;
c0103689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010368c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le =  list_prev(&(base->page_link));
c0103693:	8b 45 08             	mov    0x8(%ebp),%eax
c0103696:	83 c0 0c             	add    $0xc,%eax
c0103699:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010369c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010369f:	8b 00                	mov    (%eax),%eax
c01036a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le,page_link);
c01036a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036a7:	83 e8 0c             	sub    $0xc,%eax
c01036aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p == base - 1)
c01036ad:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c01036b4:	74 52                	je     c0103708 <default_free_pages+0x1cc>
c01036b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b9:	83 e8 20             	sub    $0x20,%eax
c01036bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01036bf:	75 47                	jne    c0103708 <default_free_pages+0x1cc>
    {
	while(le != &free_list)
c01036c1:	eb 3c                	jmp    c01036ff <default_free_pages+0x1c3>
	{
	    if(p -> property > 0)
c01036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c6:	8b 40 08             	mov    0x8(%eax),%eax
c01036c9:	85 c0                	test   %eax,%eax
c01036cb:	74 20                	je     c01036ed <default_free_pages+0x1b1>
	    {
		p->property += base->property;
c01036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036d0:	8b 50 08             	mov    0x8(%eax),%edx
c01036d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d6:	8b 40 08             	mov    0x8(%eax),%eax
c01036d9:	01 c2                	add    %eax,%edx
c01036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036de:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
c01036e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		break;
c01036eb:	eb 1b                	jmp    c0103708 <default_free_pages+0x1cc>
c01036ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01036f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036f6:	8b 00                	mov    (%eax),%eax
	    }
	    le = list_prev(le);
c01036f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    p--;
c01036fb:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
    }
    le =  list_prev(&(base->page_link));
    p = le2page(le,page_link);
    if(le!=&free_list && p == base - 1)
    {
	while(le != &free_list)
c01036ff:	81 7d f0 18 7b 12 c0 	cmpl   $0xc0127b18,-0x10(%ebp)
c0103706:	75 bb                	jne    c01036c3 <default_free_pages+0x187>
	    }
	    le = list_prev(le);
	    p--;
    	}
    }
}
c0103708:	c9                   	leave  
c0103709:	c3                   	ret    

c010370a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010370a:	55                   	push   %ebp
c010370b:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010370d:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103712:	5d                   	pop    %ebp
c0103713:	c3                   	ret    

c0103714 <basic_check>:

static void
basic_check(void) {
c0103714:	55                   	push   %ebp
c0103715:	89 e5                	mov    %esp,%ebp
c0103717:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010371a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103721:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103724:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103727:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010372a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010372d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103734:	e8 c4 15 00 00       	call   c0104cfd <alloc_pages>
c0103739:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010373c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103740:	75 24                	jne    c0103766 <basic_check+0x52>
c0103742:	c7 44 24 0c 51 a5 10 	movl   $0xc010a551,0xc(%esp)
c0103749:	c0 
c010374a:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103751:	c0 
c0103752:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103759:	00 
c010375a:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103761:	e8 76 d5 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103766:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010376d:	e8 8b 15 00 00       	call   c0104cfd <alloc_pages>
c0103772:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103779:	75 24                	jne    c010379f <basic_check+0x8b>
c010377b:	c7 44 24 0c 6d a5 10 	movl   $0xc010a56d,0xc(%esp)
c0103782:	c0 
c0103783:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010378a:	c0 
c010378b:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0103792:	00 
c0103793:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010379a:	e8 3d d5 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c010379f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037a6:	e8 52 15 00 00       	call   c0104cfd <alloc_pages>
c01037ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037b2:	75 24                	jne    c01037d8 <basic_check+0xc4>
c01037b4:	c7 44 24 0c 89 a5 10 	movl   $0xc010a589,0xc(%esp)
c01037bb:	c0 
c01037bc:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01037c3:	c0 
c01037c4:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01037cb:	00 
c01037cc:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01037d3:	e8 04 d5 ff ff       	call   c0100cdc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01037d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037de:	74 10                	je     c01037f0 <basic_check+0xdc>
c01037e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037e6:	74 08                	je     c01037f0 <basic_check+0xdc>
c01037e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037eb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037ee:	75 24                	jne    c0103814 <basic_check+0x100>
c01037f0:	c7 44 24 0c a8 a5 10 	movl   $0xc010a5a8,0xc(%esp)
c01037f7:	c0 
c01037f8:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01037ff:	c0 
c0103800:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103807:	00 
c0103808:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010380f:	e8 c8 d4 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103814:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103817:	89 04 24             	mov    %eax,(%esp)
c010381a:	e8 10 fa ff ff       	call   c010322f <page_ref>
c010381f:	85 c0                	test   %eax,%eax
c0103821:	75 1e                	jne    c0103841 <basic_check+0x12d>
c0103823:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103826:	89 04 24             	mov    %eax,(%esp)
c0103829:	e8 01 fa ff ff       	call   c010322f <page_ref>
c010382e:	85 c0                	test   %eax,%eax
c0103830:	75 0f                	jne    c0103841 <basic_check+0x12d>
c0103832:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103835:	89 04 24             	mov    %eax,(%esp)
c0103838:	e8 f2 f9 ff ff       	call   c010322f <page_ref>
c010383d:	85 c0                	test   %eax,%eax
c010383f:	74 24                	je     c0103865 <basic_check+0x151>
c0103841:	c7 44 24 0c cc a5 10 	movl   $0xc010a5cc,0xc(%esp)
c0103848:	c0 
c0103849:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103850:	c0 
c0103851:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103858:	00 
c0103859:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103860:	e8 77 d4 ff ff       	call   c0100cdc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103865:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103868:	89 04 24             	mov    %eax,(%esp)
c010386b:	e8 a9 f9 ff ff       	call   c0103219 <page2pa>
c0103870:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103876:	c1 e2 0c             	shl    $0xc,%edx
c0103879:	39 d0                	cmp    %edx,%eax
c010387b:	72 24                	jb     c01038a1 <basic_check+0x18d>
c010387d:	c7 44 24 0c 08 a6 10 	movl   $0xc010a608,0xc(%esp)
c0103884:	c0 
c0103885:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010388c:	c0 
c010388d:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103894:	00 
c0103895:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010389c:	e8 3b d4 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038a4:	89 04 24             	mov    %eax,(%esp)
c01038a7:	e8 6d f9 ff ff       	call   c0103219 <page2pa>
c01038ac:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038b2:	c1 e2 0c             	shl    $0xc,%edx
c01038b5:	39 d0                	cmp    %edx,%eax
c01038b7:	72 24                	jb     c01038dd <basic_check+0x1c9>
c01038b9:	c7 44 24 0c 25 a6 10 	movl   $0xc010a625,0xc(%esp)
c01038c0:	c0 
c01038c1:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01038c8:	c0 
c01038c9:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c01038d0:	00 
c01038d1:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01038d8:	e8 ff d3 ff ff       	call   c0100cdc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01038dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038e0:	89 04 24             	mov    %eax,(%esp)
c01038e3:	e8 31 f9 ff ff       	call   c0103219 <page2pa>
c01038e8:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038ee:	c1 e2 0c             	shl    $0xc,%edx
c01038f1:	39 d0                	cmp    %edx,%eax
c01038f3:	72 24                	jb     c0103919 <basic_check+0x205>
c01038f5:	c7 44 24 0c 42 a6 10 	movl   $0xc010a642,0xc(%esp)
c01038fc:	c0 
c01038fd:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103904:	c0 
c0103905:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c010390c:	00 
c010390d:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103914:	e8 c3 d3 ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c0103919:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c010391e:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103924:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103927:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010392a:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103931:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103934:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103937:	89 50 04             	mov    %edx,0x4(%eax)
c010393a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010393d:	8b 50 04             	mov    0x4(%eax),%edx
c0103940:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103943:	89 10                	mov    %edx,(%eax)
c0103945:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010394c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010394f:	8b 40 04             	mov    0x4(%eax),%eax
c0103952:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103955:	0f 94 c0             	sete   %al
c0103958:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010395b:	85 c0                	test   %eax,%eax
c010395d:	75 24                	jne    c0103983 <basic_check+0x26f>
c010395f:	c7 44 24 0c 5f a6 10 	movl   $0xc010a65f,0xc(%esp)
c0103966:	c0 
c0103967:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010396e:	c0 
c010396f:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103976:	00 
c0103977:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010397e:	e8 59 d3 ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103983:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103988:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010398b:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103992:	00 00 00 

    assert(alloc_page() == NULL);
c0103995:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010399c:	e8 5c 13 00 00       	call   c0104cfd <alloc_pages>
c01039a1:	85 c0                	test   %eax,%eax
c01039a3:	74 24                	je     c01039c9 <basic_check+0x2b5>
c01039a5:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c01039ac:	c0 
c01039ad:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01039b4:	c0 
c01039b5:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01039bc:	00 
c01039bd:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01039c4:	e8 13 d3 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c01039c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039d0:	00 
c01039d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d4:	89 04 24             	mov    %eax,(%esp)
c01039d7:	e8 8c 13 00 00       	call   c0104d68 <free_pages>
    free_page(p1);
c01039dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039e3:	00 
c01039e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039e7:	89 04 24             	mov    %eax,(%esp)
c01039ea:	e8 79 13 00 00       	call   c0104d68 <free_pages>
    free_page(p2);
c01039ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039f6:	00 
c01039f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039fa:	89 04 24             	mov    %eax,(%esp)
c01039fd:	e8 66 13 00 00       	call   c0104d68 <free_pages>
    assert(nr_free == 3);
c0103a02:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103a07:	83 f8 03             	cmp    $0x3,%eax
c0103a0a:	74 24                	je     c0103a30 <basic_check+0x31c>
c0103a0c:	c7 44 24 0c 8b a6 10 	movl   $0xc010a68b,0xc(%esp)
c0103a13:	c0 
c0103a14:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103a1b:	c0 
c0103a1c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103a23:	00 
c0103a24:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103a2b:	e8 ac d2 ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a37:	e8 c1 12 00 00       	call   c0104cfd <alloc_pages>
c0103a3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a43:	75 24                	jne    c0103a69 <basic_check+0x355>
c0103a45:	c7 44 24 0c 51 a5 10 	movl   $0xc010a551,0xc(%esp)
c0103a4c:	c0 
c0103a4d:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103a54:	c0 
c0103a55:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103a5c:	00 
c0103a5d:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103a64:	e8 73 d2 ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a70:	e8 88 12 00 00       	call   c0104cfd <alloc_pages>
c0103a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a7c:	75 24                	jne    c0103aa2 <basic_check+0x38e>
c0103a7e:	c7 44 24 0c 6d a5 10 	movl   $0xc010a56d,0xc(%esp)
c0103a85:	c0 
c0103a86:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103a8d:	c0 
c0103a8e:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103a95:	00 
c0103a96:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103a9d:	e8 3a d2 ff ff       	call   c0100cdc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103aa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aa9:	e8 4f 12 00 00       	call   c0104cfd <alloc_pages>
c0103aae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ab5:	75 24                	jne    c0103adb <basic_check+0x3c7>
c0103ab7:	c7 44 24 0c 89 a5 10 	movl   $0xc010a589,0xc(%esp)
c0103abe:	c0 
c0103abf:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103ac6:	c0 
c0103ac7:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103ace:	00 
c0103acf:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103ad6:	e8 01 d2 ff ff       	call   c0100cdc <__panic>

    assert(alloc_page() == NULL);
c0103adb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ae2:	e8 16 12 00 00       	call   c0104cfd <alloc_pages>
c0103ae7:	85 c0                	test   %eax,%eax
c0103ae9:	74 24                	je     c0103b0f <basic_check+0x3fb>
c0103aeb:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c0103af2:	c0 
c0103af3:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103afa:	c0 
c0103afb:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103b02:	00 
c0103b03:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103b0a:	e8 cd d1 ff ff       	call   c0100cdc <__panic>

    free_page(p0);
c0103b0f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b16:	00 
c0103b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b1a:	89 04 24             	mov    %eax,(%esp)
c0103b1d:	e8 46 12 00 00       	call   c0104d68 <free_pages>
c0103b22:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b2c:	8b 40 04             	mov    0x4(%eax),%eax
c0103b2f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b32:	0f 94 c0             	sete   %al
c0103b35:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b38:	85 c0                	test   %eax,%eax
c0103b3a:	74 24                	je     c0103b60 <basic_check+0x44c>
c0103b3c:	c7 44 24 0c 98 a6 10 	movl   $0xc010a698,0xc(%esp)
c0103b43:	c0 
c0103b44:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103b4b:	c0 
c0103b4c:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103b53:	00 
c0103b54:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103b5b:	e8 7c d1 ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103b60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b67:	e8 91 11 00 00       	call   c0104cfd <alloc_pages>
c0103b6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b72:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b75:	74 24                	je     c0103b9b <basic_check+0x487>
c0103b77:	c7 44 24 0c b0 a6 10 	movl   $0xc010a6b0,0xc(%esp)
c0103b7e:	c0 
c0103b7f:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103b86:	c0 
c0103b87:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103b8e:	00 
c0103b8f:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103b96:	e8 41 d1 ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103b9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ba2:	e8 56 11 00 00       	call   c0104cfd <alloc_pages>
c0103ba7:	85 c0                	test   %eax,%eax
c0103ba9:	74 24                	je     c0103bcf <basic_check+0x4bb>
c0103bab:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c0103bb2:	c0 
c0103bb3:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103bba:	c0 
c0103bbb:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103bc2:	00 
c0103bc3:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103bca:	e8 0d d1 ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c0103bcf:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103bd4:	85 c0                	test   %eax,%eax
c0103bd6:	74 24                	je     c0103bfc <basic_check+0x4e8>
c0103bd8:	c7 44 24 0c c9 a6 10 	movl   $0xc010a6c9,0xc(%esp)
c0103bdf:	c0 
c0103be0:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103be7:	c0 
c0103be8:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103bef:	00 
c0103bf0:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103bf7:	e8 e0 d0 ff ff       	call   c0100cdc <__panic>
    free_list = free_list_store;
c0103bfc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103bff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c02:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103c07:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103c0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c10:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103c15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c1c:	00 
c0103c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c20:	89 04 24             	mov    %eax,(%esp)
c0103c23:	e8 40 11 00 00       	call   c0104d68 <free_pages>
    free_page(p1);
c0103c28:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c2f:	00 
c0103c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c33:	89 04 24             	mov    %eax,(%esp)
c0103c36:	e8 2d 11 00 00       	call   c0104d68 <free_pages>
    free_page(p2);
c0103c3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c42:	00 
c0103c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c46:	89 04 24             	mov    %eax,(%esp)
c0103c49:	e8 1a 11 00 00       	call   c0104d68 <free_pages>
}
c0103c4e:	c9                   	leave  
c0103c4f:	c3                   	ret    

c0103c50 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103c50:	55                   	push   %ebp
c0103c51:	89 e5                	mov    %esp,%ebp
c0103c53:	53                   	push   %ebx
c0103c54:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103c68:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103c6f:	eb 6b                	jmp    c0103cdc <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c74:	83 e8 0c             	sub    $0xc,%eax
c0103c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c7d:	83 c0 04             	add    $0x4,%eax
c0103c80:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103c87:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103c8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103c8d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103c90:	0f a3 10             	bt     %edx,(%eax)
c0103c93:	19 c0                	sbb    %eax,%eax
c0103c95:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103c98:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103c9c:	0f 95 c0             	setne  %al
c0103c9f:	0f b6 c0             	movzbl %al,%eax
c0103ca2:	85 c0                	test   %eax,%eax
c0103ca4:	75 24                	jne    c0103cca <default_check+0x7a>
c0103ca6:	c7 44 24 0c d6 a6 10 	movl   $0xc010a6d6,0xc(%esp)
c0103cad:	c0 
c0103cae:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103cb5:	c0 
c0103cb6:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103cbd:	00 
c0103cbe:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103cc5:	e8 12 d0 ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c0103cca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103cce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cd1:	8b 50 08             	mov    0x8(%eax),%edx
c0103cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cd7:	01 d0                	add    %edx,%eax
c0103cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cdf:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103ce2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ce5:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103ce8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ceb:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103cf2:	0f 85 79 ff ff ff    	jne    c0103c71 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103cf8:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103cfb:	e8 9a 10 00 00       	call   c0104d9a <nr_free_pages>
c0103d00:	39 c3                	cmp    %eax,%ebx
c0103d02:	74 24                	je     c0103d28 <default_check+0xd8>
c0103d04:	c7 44 24 0c e6 a6 10 	movl   $0xc010a6e6,0xc(%esp)
c0103d0b:	c0 
c0103d0c:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103d13:	c0 
c0103d14:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103d1b:	00 
c0103d1c:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103d23:	e8 b4 cf ff ff       	call   c0100cdc <__panic>

    basic_check();
c0103d28:	e8 e7 f9 ff ff       	call   c0103714 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d2d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d34:	e8 c4 0f 00 00       	call   c0104cfd <alloc_pages>
c0103d39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103d3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d40:	75 24                	jne    c0103d66 <default_check+0x116>
c0103d42:	c7 44 24 0c ff a6 10 	movl   $0xc010a6ff,0xc(%esp)
c0103d49:	c0 
c0103d4a:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103d51:	c0 
c0103d52:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103d59:	00 
c0103d5a:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103d61:	e8 76 cf ff ff       	call   c0100cdc <__panic>
    assert(!PageProperty(p0));
c0103d66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d69:	83 c0 04             	add    $0x4,%eax
c0103d6c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103d73:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d76:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103d79:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103d7c:	0f a3 10             	bt     %edx,(%eax)
c0103d7f:	19 c0                	sbb    %eax,%eax
c0103d81:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103d84:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103d88:	0f 95 c0             	setne  %al
c0103d8b:	0f b6 c0             	movzbl %al,%eax
c0103d8e:	85 c0                	test   %eax,%eax
c0103d90:	74 24                	je     c0103db6 <default_check+0x166>
c0103d92:	c7 44 24 0c 0a a7 10 	movl   $0xc010a70a,0xc(%esp)
c0103d99:	c0 
c0103d9a:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103da1:	c0 
c0103da2:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103da9:	00 
c0103daa:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103db1:	e8 26 cf ff ff       	call   c0100cdc <__panic>

    list_entry_t free_list_store = free_list;
c0103db6:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103dbb:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103dc1:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103dc4:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103dc7:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103dce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103dd1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103dd4:	89 50 04             	mov    %edx,0x4(%eax)
c0103dd7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103dda:	8b 50 04             	mov    0x4(%eax),%edx
c0103ddd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103de0:	89 10                	mov    %edx,(%eax)
c0103de2:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103de9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103dec:	8b 40 04             	mov    0x4(%eax),%eax
c0103def:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103df2:	0f 94 c0             	sete   %al
c0103df5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103df8:	85 c0                	test   %eax,%eax
c0103dfa:	75 24                	jne    c0103e20 <default_check+0x1d0>
c0103dfc:	c7 44 24 0c 5f a6 10 	movl   $0xc010a65f,0xc(%esp)
c0103e03:	c0 
c0103e04:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103e0b:	c0 
c0103e0c:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103e13:	00 
c0103e14:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103e1b:	e8 bc ce ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103e20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e27:	e8 d1 0e 00 00       	call   c0104cfd <alloc_pages>
c0103e2c:	85 c0                	test   %eax,%eax
c0103e2e:	74 24                	je     c0103e54 <default_check+0x204>
c0103e30:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c0103e37:	c0 
c0103e38:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103e3f:	c0 
c0103e40:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103e47:	00 
c0103e48:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103e4f:	e8 88 ce ff ff       	call   c0100cdc <__panic>

    unsigned int nr_free_store = nr_free;
c0103e54:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103e59:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103e5c:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103e63:	00 00 00 

    free_pages(p0 + 2, 3);
c0103e66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e69:	83 c0 40             	add    $0x40,%eax
c0103e6c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103e73:	00 
c0103e74:	89 04 24             	mov    %eax,(%esp)
c0103e77:	e8 ec 0e 00 00       	call   c0104d68 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103e7c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103e83:	e8 75 0e 00 00       	call   c0104cfd <alloc_pages>
c0103e88:	85 c0                	test   %eax,%eax
c0103e8a:	74 24                	je     c0103eb0 <default_check+0x260>
c0103e8c:	c7 44 24 0c 1c a7 10 	movl   $0xc010a71c,0xc(%esp)
c0103e93:	c0 
c0103e94:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103e9b:	c0 
c0103e9c:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103ea3:	00 
c0103ea4:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103eab:	e8 2c ce ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103eb3:	83 c0 40             	add    $0x40,%eax
c0103eb6:	83 c0 04             	add    $0x4,%eax
c0103eb9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103ec0:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ec3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ec6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103ec9:	0f a3 10             	bt     %edx,(%eax)
c0103ecc:	19 c0                	sbb    %eax,%eax
c0103ece:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103ed1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103ed5:	0f 95 c0             	setne  %al
c0103ed8:	0f b6 c0             	movzbl %al,%eax
c0103edb:	85 c0                	test   %eax,%eax
c0103edd:	74 0e                	je     c0103eed <default_check+0x29d>
c0103edf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ee2:	83 c0 40             	add    $0x40,%eax
c0103ee5:	8b 40 08             	mov    0x8(%eax),%eax
c0103ee8:	83 f8 03             	cmp    $0x3,%eax
c0103eeb:	74 24                	je     c0103f11 <default_check+0x2c1>
c0103eed:	c7 44 24 0c 34 a7 10 	movl   $0xc010a734,0xc(%esp)
c0103ef4:	c0 
c0103ef5:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103efc:	c0 
c0103efd:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103f04:	00 
c0103f05:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103f0c:	e8 cb cd ff ff       	call   c0100cdc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f11:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f18:	e8 e0 0d 00 00       	call   c0104cfd <alloc_pages>
c0103f1d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f20:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f24:	75 24                	jne    c0103f4a <default_check+0x2fa>
c0103f26:	c7 44 24 0c 60 a7 10 	movl   $0xc010a760,0xc(%esp)
c0103f2d:	c0 
c0103f2e:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103f35:	c0 
c0103f36:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f3d:	00 
c0103f3e:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103f45:	e8 92 cd ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0103f4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f51:	e8 a7 0d 00 00       	call   c0104cfd <alloc_pages>
c0103f56:	85 c0                	test   %eax,%eax
c0103f58:	74 24                	je     c0103f7e <default_check+0x32e>
c0103f5a:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c0103f61:	c0 
c0103f62:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103f69:	c0 
c0103f6a:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103f71:	00 
c0103f72:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103f79:	e8 5e cd ff ff       	call   c0100cdc <__panic>
    assert(p0 + 2 == p1);
c0103f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f81:	83 c0 40             	add    $0x40,%eax
c0103f84:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f87:	74 24                	je     c0103fad <default_check+0x35d>
c0103f89:	c7 44 24 0c 7e a7 10 	movl   $0xc010a77e,0xc(%esp)
c0103f90:	c0 
c0103f91:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0103f98:	c0 
c0103f99:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103fa0:	00 
c0103fa1:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0103fa8:	e8 2f cd ff ff       	call   c0100cdc <__panic>

    p2 = p0 + 1;
c0103fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fb0:	83 c0 20             	add    $0x20,%eax
c0103fb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103fb6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fbd:	00 
c0103fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fc1:	89 04 24             	mov    %eax,(%esp)
c0103fc4:	e8 9f 0d 00 00       	call   c0104d68 <free_pages>
    free_pages(p1, 3);
c0103fc9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103fd0:	00 
c0103fd1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103fd4:	89 04 24             	mov    %eax,(%esp)
c0103fd7:	e8 8c 0d 00 00       	call   c0104d68 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fdf:	83 c0 04             	add    $0x4,%eax
c0103fe2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103fe9:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fec:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103fef:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103ff2:	0f a3 10             	bt     %edx,(%eax)
c0103ff5:	19 c0                	sbb    %eax,%eax
c0103ff7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103ffa:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103ffe:	0f 95 c0             	setne  %al
c0104001:	0f b6 c0             	movzbl %al,%eax
c0104004:	85 c0                	test   %eax,%eax
c0104006:	74 0b                	je     c0104013 <default_check+0x3c3>
c0104008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010400b:	8b 40 08             	mov    0x8(%eax),%eax
c010400e:	83 f8 01             	cmp    $0x1,%eax
c0104011:	74 24                	je     c0104037 <default_check+0x3e7>
c0104013:	c7 44 24 0c 8c a7 10 	movl   $0xc010a78c,0xc(%esp)
c010401a:	c0 
c010401b:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0104022:	c0 
c0104023:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c010402a:	00 
c010402b:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0104032:	e8 a5 cc ff ff       	call   c0100cdc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104037:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010403a:	83 c0 04             	add    $0x4,%eax
c010403d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104044:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104047:	8b 45 90             	mov    -0x70(%ebp),%eax
c010404a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010404d:	0f a3 10             	bt     %edx,(%eax)
c0104050:	19 c0                	sbb    %eax,%eax
c0104052:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104055:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104059:	0f 95 c0             	setne  %al
c010405c:	0f b6 c0             	movzbl %al,%eax
c010405f:	85 c0                	test   %eax,%eax
c0104061:	74 0b                	je     c010406e <default_check+0x41e>
c0104063:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104066:	8b 40 08             	mov    0x8(%eax),%eax
c0104069:	83 f8 03             	cmp    $0x3,%eax
c010406c:	74 24                	je     c0104092 <default_check+0x442>
c010406e:	c7 44 24 0c b4 a7 10 	movl   $0xc010a7b4,0xc(%esp)
c0104075:	c0 
c0104076:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010407d:	c0 
c010407e:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104085:	00 
c0104086:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010408d:	e8 4a cc ff ff       	call   c0100cdc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104092:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104099:	e8 5f 0c 00 00       	call   c0104cfd <alloc_pages>
c010409e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040a4:	83 e8 20             	sub    $0x20,%eax
c01040a7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040aa:	74 24                	je     c01040d0 <default_check+0x480>
c01040ac:	c7 44 24 0c da a7 10 	movl   $0xc010a7da,0xc(%esp)
c01040b3:	c0 
c01040b4:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01040bb:	c0 
c01040bc:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c01040c3:	00 
c01040c4:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01040cb:	e8 0c cc ff ff       	call   c0100cdc <__panic>
    free_page(p0);
c01040d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040d7:	00 
c01040d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040db:	89 04 24             	mov    %eax,(%esp)
c01040de:	e8 85 0c 00 00       	call   c0104d68 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01040e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01040ea:	e8 0e 0c 00 00       	call   c0104cfd <alloc_pages>
c01040ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040f5:	83 c0 20             	add    $0x20,%eax
c01040f8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040fb:	74 24                	je     c0104121 <default_check+0x4d1>
c01040fd:	c7 44 24 0c f8 a7 10 	movl   $0xc010a7f8,0xc(%esp)
c0104104:	c0 
c0104105:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010410c:	c0 
c010410d:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104114:	00 
c0104115:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010411c:	e8 bb cb ff ff       	call   c0100cdc <__panic>

    free_pages(p0, 2);
c0104121:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104128:	00 
c0104129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010412c:	89 04 24             	mov    %eax,(%esp)
c010412f:	e8 34 0c 00 00       	call   c0104d68 <free_pages>
    free_page(p2);
c0104134:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010413b:	00 
c010413c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010413f:	89 04 24             	mov    %eax,(%esp)
c0104142:	e8 21 0c 00 00       	call   c0104d68 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104147:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010414e:	e8 aa 0b 00 00       	call   c0104cfd <alloc_pages>
c0104153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104156:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010415a:	75 24                	jne    c0104180 <default_check+0x530>
c010415c:	c7 44 24 0c 18 a8 10 	movl   $0xc010a818,0xc(%esp)
c0104163:	c0 
c0104164:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010416b:	c0 
c010416c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104173:	00 
c0104174:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010417b:	e8 5c cb ff ff       	call   c0100cdc <__panic>
    assert(alloc_page() == NULL);
c0104180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104187:	e8 71 0b 00 00       	call   c0104cfd <alloc_pages>
c010418c:	85 c0                	test   %eax,%eax
c010418e:	74 24                	je     c01041b4 <default_check+0x564>
c0104190:	c7 44 24 0c 76 a6 10 	movl   $0xc010a676,0xc(%esp)
c0104197:	c0 
c0104198:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010419f:	c0 
c01041a0:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01041a7:	00 
c01041a8:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01041af:	e8 28 cb ff ff       	call   c0100cdc <__panic>

    assert(nr_free == 0);
c01041b4:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01041b9:	85 c0                	test   %eax,%eax
c01041bb:	74 24                	je     c01041e1 <default_check+0x591>
c01041bd:	c7 44 24 0c c9 a6 10 	movl   $0xc010a6c9,0xc(%esp)
c01041c4:	c0 
c01041c5:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c01041cc:	c0 
c01041cd:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c01041d4:	00 
c01041d5:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c01041dc:	e8 fb ca ff ff       	call   c0100cdc <__panic>
    nr_free = nr_free_store;
c01041e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041e4:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c01041e9:	8b 45 80             	mov    -0x80(%ebp),%eax
c01041ec:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041ef:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c01041f4:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c01041fa:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104201:	00 
c0104202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104205:	89 04 24             	mov    %eax,(%esp)
c0104208:	e8 5b 0b 00 00       	call   c0104d68 <free_pages>

    le = &free_list;
c010420d:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104214:	eb 1d                	jmp    c0104233 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104216:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104219:	83 e8 0c             	sub    $0xc,%eax
c010421c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010421f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104223:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104226:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104229:	8b 40 08             	mov    0x8(%eax),%eax
c010422c:	29 c2                	sub    %eax,%edx
c010422e:	89 d0                	mov    %edx,%eax
c0104230:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104233:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104236:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104239:	8b 45 88             	mov    -0x78(%ebp),%eax
c010423c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010423f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104242:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0104249:	75 cb                	jne    c0104216 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010424b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010424f:	74 24                	je     c0104275 <default_check+0x625>
c0104251:	c7 44 24 0c 36 a8 10 	movl   $0xc010a836,0xc(%esp)
c0104258:	c0 
c0104259:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c0104260:	c0 
c0104261:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104268:	00 
c0104269:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c0104270:	e8 67 ca ff ff       	call   c0100cdc <__panic>
    assert(total == 0);
c0104275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104279:	74 24                	je     c010429f <default_check+0x64f>
c010427b:	c7 44 24 0c 41 a8 10 	movl   $0xc010a841,0xc(%esp)
c0104282:	c0 
c0104283:	c7 44 24 08 16 a5 10 	movl   $0xc010a516,0x8(%esp)
c010428a:	c0 
c010428b:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c0104292:	00 
c0104293:	c7 04 24 2b a5 10 c0 	movl   $0xc010a52b,(%esp)
c010429a:	e8 3d ca ff ff       	call   c0100cdc <__panic>
}
c010429f:	81 c4 94 00 00 00    	add    $0x94,%esp
c01042a5:	5b                   	pop    %ebx
c01042a6:	5d                   	pop    %ebp
c01042a7:	c3                   	ret    

c01042a8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01042a8:	55                   	push   %ebp
c01042a9:	89 e5                	mov    %esp,%ebp
c01042ab:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01042ae:	9c                   	pushf  
c01042af:	58                   	pop    %eax
c01042b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01042b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01042b6:	25 00 02 00 00       	and    $0x200,%eax
c01042bb:	85 c0                	test   %eax,%eax
c01042bd:	74 0c                	je     c01042cb <__intr_save+0x23>
        intr_disable();
c01042bf:	e8 70 dc ff ff       	call   c0101f34 <intr_disable>
        return 1;
c01042c4:	b8 01 00 00 00       	mov    $0x1,%eax
c01042c9:	eb 05                	jmp    c01042d0 <__intr_save+0x28>
    }
    return 0;
c01042cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042d0:	c9                   	leave  
c01042d1:	c3                   	ret    

c01042d2 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01042d2:	55                   	push   %ebp
c01042d3:	89 e5                	mov    %esp,%ebp
c01042d5:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01042d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01042dc:	74 05                	je     c01042e3 <__intr_restore+0x11>
        intr_enable();
c01042de:	e8 4b dc ff ff       	call   c0101f2e <intr_enable>
    }
}
c01042e3:	c9                   	leave  
c01042e4:	c3                   	ret    

c01042e5 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01042e5:	55                   	push   %ebp
c01042e6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01042e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01042eb:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01042f0:	29 c2                	sub    %eax,%edx
c01042f2:	89 d0                	mov    %edx,%eax
c01042f4:	c1 f8 05             	sar    $0x5,%eax
}
c01042f7:	5d                   	pop    %ebp
c01042f8:	c3                   	ret    

c01042f9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01042f9:	55                   	push   %ebp
c01042fa:	89 e5                	mov    %esp,%ebp
c01042fc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01042ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104302:	89 04 24             	mov    %eax,(%esp)
c0104305:	e8 db ff ff ff       	call   c01042e5 <page2ppn>
c010430a:	c1 e0 0c             	shl    $0xc,%eax
}
c010430d:	c9                   	leave  
c010430e:	c3                   	ret    

c010430f <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010430f:	55                   	push   %ebp
c0104310:	89 e5                	mov    %esp,%ebp
c0104312:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104315:	8b 45 08             	mov    0x8(%ebp),%eax
c0104318:	c1 e8 0c             	shr    $0xc,%eax
c010431b:	89 c2                	mov    %eax,%edx
c010431d:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104322:	39 c2                	cmp    %eax,%edx
c0104324:	72 1c                	jb     c0104342 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104326:	c7 44 24 08 7c a8 10 	movl   $0xc010a87c,0x8(%esp)
c010432d:	c0 
c010432e:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104335:	00 
c0104336:	c7 04 24 9b a8 10 c0 	movl   $0xc010a89b,(%esp)
c010433d:	e8 9a c9 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0104342:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104347:	8b 55 08             	mov    0x8(%ebp),%edx
c010434a:	c1 ea 0c             	shr    $0xc,%edx
c010434d:	c1 e2 05             	shl    $0x5,%edx
c0104350:	01 d0                	add    %edx,%eax
}
c0104352:	c9                   	leave  
c0104353:	c3                   	ret    

c0104354 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104354:	55                   	push   %ebp
c0104355:	89 e5                	mov    %esp,%ebp
c0104357:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010435a:	8b 45 08             	mov    0x8(%ebp),%eax
c010435d:	89 04 24             	mov    %eax,(%esp)
c0104360:	e8 94 ff ff ff       	call   c01042f9 <page2pa>
c0104365:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104368:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436b:	c1 e8 0c             	shr    $0xc,%eax
c010436e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104371:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104376:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104379:	72 23                	jb     c010439e <page2kva+0x4a>
c010437b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104382:	c7 44 24 08 ac a8 10 	movl   $0xc010a8ac,0x8(%esp)
c0104389:	c0 
c010438a:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104391:	00 
c0104392:	c7 04 24 9b a8 10 c0 	movl   $0xc010a89b,(%esp)
c0104399:	e8 3e c9 ff ff       	call   c0100cdc <__panic>
c010439e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a1:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01043a6:	c9                   	leave  
c01043a7:	c3                   	ret    

c01043a8 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01043a8:	55                   	push   %ebp
c01043a9:	89 e5                	mov    %esp,%ebp
c01043ab:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01043ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01043b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043b4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01043bb:	77 23                	ja     c01043e0 <kva2page+0x38>
c01043bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043c4:	c7 44 24 08 d0 a8 10 	movl   $0xc010a8d0,0x8(%esp)
c01043cb:	c0 
c01043cc:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01043d3:	00 
c01043d4:	c7 04 24 9b a8 10 c0 	movl   $0xc010a89b,(%esp)
c01043db:	e8 fc c8 ff ff       	call   c0100cdc <__panic>
c01043e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e3:	05 00 00 00 40       	add    $0x40000000,%eax
c01043e8:	89 04 24             	mov    %eax,(%esp)
c01043eb:	e8 1f ff ff ff       	call   c010430f <pa2page>
}
c01043f0:	c9                   	leave  
c01043f1:	c3                   	ret    

c01043f2 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c01043f2:	55                   	push   %ebp
c01043f3:	89 e5                	mov    %esp,%ebp
c01043f5:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c01043f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043fb:	ba 01 00 00 00       	mov    $0x1,%edx
c0104400:	89 c1                	mov    %eax,%ecx
c0104402:	d3 e2                	shl    %cl,%edx
c0104404:	89 d0                	mov    %edx,%eax
c0104406:	89 04 24             	mov    %eax,(%esp)
c0104409:	e8 ef 08 00 00       	call   c0104cfd <alloc_pages>
c010440e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104415:	75 07                	jne    c010441e <__slob_get_free_pages+0x2c>
    return NULL;
c0104417:	b8 00 00 00 00       	mov    $0x0,%eax
c010441c:	eb 0b                	jmp    c0104429 <__slob_get_free_pages+0x37>
  return page2kva(page);
c010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104421:	89 04 24             	mov    %eax,(%esp)
c0104424:	e8 2b ff ff ff       	call   c0104354 <page2kva>
}
c0104429:	c9                   	leave  
c010442a:	c3                   	ret    

c010442b <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010442b:	55                   	push   %ebp
c010442c:	89 e5                	mov    %esp,%ebp
c010442e:	53                   	push   %ebx
c010442f:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104432:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104435:	ba 01 00 00 00       	mov    $0x1,%edx
c010443a:	89 c1                	mov    %eax,%ecx
c010443c:	d3 e2                	shl    %cl,%edx
c010443e:	89 d0                	mov    %edx,%eax
c0104440:	89 c3                	mov    %eax,%ebx
c0104442:	8b 45 08             	mov    0x8(%ebp),%eax
c0104445:	89 04 24             	mov    %eax,(%esp)
c0104448:	e8 5b ff ff ff       	call   c01043a8 <kva2page>
c010444d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104451:	89 04 24             	mov    %eax,(%esp)
c0104454:	e8 0f 09 00 00       	call   c0104d68 <free_pages>
}
c0104459:	83 c4 14             	add    $0x14,%esp
c010445c:	5b                   	pop    %ebx
c010445d:	5d                   	pop    %ebp
c010445e:	c3                   	ret    

c010445f <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c010445f:	55                   	push   %ebp
c0104460:	89 e5                	mov    %esp,%ebp
c0104462:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104465:	8b 45 08             	mov    0x8(%ebp),%eax
c0104468:	83 c0 08             	add    $0x8,%eax
c010446b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104470:	76 24                	jbe    c0104496 <slob_alloc+0x37>
c0104472:	c7 44 24 0c f4 a8 10 	movl   $0xc010a8f4,0xc(%esp)
c0104479:	c0 
c010447a:	c7 44 24 08 13 a9 10 	movl   $0xc010a913,0x8(%esp)
c0104481:	c0 
c0104482:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104489:	00 
c010448a:	c7 04 24 28 a9 10 c0 	movl   $0xc010a928,(%esp)
c0104491:	e8 46 c8 ff ff       	call   c0100cdc <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104496:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c010449d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01044a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a7:	83 c0 07             	add    $0x7,%eax
c01044aa:	c1 e8 03             	shr    $0x3,%eax
c01044ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01044b0:	e8 f3 fd ff ff       	call   c01042a8 <__intr_save>
c01044b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01044b8:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01044bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01044c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c3:	8b 40 04             	mov    0x4(%eax),%eax
c01044c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01044c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044cd:	74 25                	je     c01044f4 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01044cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01044d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01044d5:	01 d0                	add    %edx,%eax
c01044d7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01044da:	8b 45 10             	mov    0x10(%ebp),%eax
c01044dd:	f7 d8                	neg    %eax
c01044df:	21 d0                	and    %edx,%eax
c01044e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c01044e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01044e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044ea:	29 c2                	sub    %eax,%edx
c01044ec:	89 d0                	mov    %edx,%eax
c01044ee:	c1 f8 03             	sar    $0x3,%eax
c01044f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01044f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044f7:	8b 00                	mov    (%eax),%eax
c01044f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01044fc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01044ff:	01 ca                	add    %ecx,%edx
c0104501:	39 d0                	cmp    %edx,%eax
c0104503:	0f 8c aa 00 00 00    	jl     c01045b3 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010450d:	74 38                	je     c0104547 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c010450f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104512:	8b 00                	mov    (%eax),%eax
c0104514:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104517:	89 c2                	mov    %eax,%edx
c0104519:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010451c:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c010451e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104521:	8b 50 04             	mov    0x4(%eax),%edx
c0104524:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104527:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010452a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010452d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104530:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104533:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104536:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104539:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010453b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010453e:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104541:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104544:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104547:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454a:	8b 00                	mov    (%eax),%eax
c010454c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010454f:	75 0e                	jne    c010455f <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104554:	8b 50 04             	mov    0x4(%eax),%edx
c0104557:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010455a:	89 50 04             	mov    %edx,0x4(%eax)
c010455d:	eb 3c                	jmp    c010459b <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c010455f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104562:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104569:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010456c:	01 c2                	add    %eax,%edx
c010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104571:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104574:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104577:	8b 40 04             	mov    0x4(%eax),%eax
c010457a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010457d:	8b 12                	mov    (%edx),%edx
c010457f:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104582:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104587:	8b 40 04             	mov    0x4(%eax),%eax
c010458a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010458d:	8b 52 04             	mov    0x4(%edx),%edx
c0104590:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104593:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104596:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104599:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c010459b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010459e:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c01045a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045a6:	89 04 24             	mov    %eax,(%esp)
c01045a9:	e8 24 fd ff ff       	call   c01042d2 <__intr_restore>
			return cur;
c01045ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b1:	eb 7f                	jmp    c0104632 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c01045b3:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01045b8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01045bb:	75 61                	jne    c010461e <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c01045bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045c0:	89 04 24             	mov    %eax,(%esp)
c01045c3:	e8 0a fd ff ff       	call   c01042d2 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01045c8:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01045cf:	75 07                	jne    c01045d8 <slob_alloc+0x179>
				return 0;
c01045d1:	b8 00 00 00 00       	mov    $0x0,%eax
c01045d6:	eb 5a                	jmp    c0104632 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01045d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045df:	00 
c01045e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045e3:	89 04 24             	mov    %eax,(%esp)
c01045e6:	e8 07 fe ff ff       	call   c01043f2 <__slob_get_free_pages>
c01045eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c01045ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01045f2:	75 07                	jne    c01045fb <slob_alloc+0x19c>
				return 0;
c01045f4:	b8 00 00 00 00       	mov    $0x0,%eax
c01045f9:	eb 37                	jmp    c0104632 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c01045fb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104602:	00 
c0104603:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104606:	89 04 24             	mov    %eax,(%esp)
c0104609:	e8 26 00 00 00       	call   c0104634 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c010460e:	e8 95 fc ff ff       	call   c01042a8 <__intr_save>
c0104613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104616:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010461b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c010461e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104621:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104624:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104627:	8b 40 04             	mov    0x4(%eax),%eax
c010462a:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c010462d:	e9 97 fe ff ff       	jmp    c01044c9 <slob_alloc+0x6a>
}
c0104632:	c9                   	leave  
c0104633:	c3                   	ret    

c0104634 <slob_free>:

static void slob_free(void *block, int size)
{
c0104634:	55                   	push   %ebp
c0104635:	89 e5                	mov    %esp,%ebp
c0104637:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010463a:	8b 45 08             	mov    0x8(%ebp),%eax
c010463d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104640:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104644:	75 05                	jne    c010464b <slob_free+0x17>
		return;
c0104646:	e9 ff 00 00 00       	jmp    c010474a <slob_free+0x116>

	if (size)
c010464b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010464f:	74 10                	je     c0104661 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104651:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104654:	83 c0 07             	add    $0x7,%eax
c0104657:	c1 e8 03             	shr    $0x3,%eax
c010465a:	89 c2                	mov    %eax,%edx
c010465c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010465f:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104661:	e8 42 fc ff ff       	call   c01042a8 <__intr_save>
c0104666:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104669:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010466e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104671:	eb 27                	jmp    c010469a <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104673:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104676:	8b 40 04             	mov    0x4(%eax),%eax
c0104679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010467c:	77 13                	ja     c0104691 <slob_free+0x5d>
c010467e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104681:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104684:	77 27                	ja     c01046ad <slob_free+0x79>
c0104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104689:	8b 40 04             	mov    0x4(%eax),%eax
c010468c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010468f:	77 1c                	ja     c01046ad <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104694:	8b 40 04             	mov    0x4(%eax),%eax
c0104697:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010469a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046a0:	76 d1                	jbe    c0104673 <slob_free+0x3f>
c01046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a5:	8b 40 04             	mov    0x4(%eax),%eax
c01046a8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046ab:	76 c6                	jbe    c0104673 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c01046ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b0:	8b 00                	mov    (%eax),%eax
c01046b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01046b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046bc:	01 c2                	add    %eax,%edx
c01046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c1:	8b 40 04             	mov    0x4(%eax),%eax
c01046c4:	39 c2                	cmp    %eax,%edx
c01046c6:	75 25                	jne    c01046ed <slob_free+0xb9>
		b->units += cur->next->units;
c01046c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cb:	8b 10                	mov    (%eax),%edx
c01046cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d0:	8b 40 04             	mov    0x4(%eax),%eax
c01046d3:	8b 00                	mov    (%eax),%eax
c01046d5:	01 c2                	add    %eax,%edx
c01046d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046da:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c01046dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046df:	8b 40 04             	mov    0x4(%eax),%eax
c01046e2:	8b 50 04             	mov    0x4(%eax),%edx
c01046e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e8:	89 50 04             	mov    %edx,0x4(%eax)
c01046eb:	eb 0c                	jmp    c01046f9 <slob_free+0xc5>
	} else
		b->next = cur->next;
c01046ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f0:	8b 50 04             	mov    0x4(%eax),%edx
c01046f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f6:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c01046f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046fc:	8b 00                	mov    (%eax),%eax
c01046fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104705:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104708:	01 d0                	add    %edx,%eax
c010470a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010470d:	75 1f                	jne    c010472e <slob_free+0xfa>
		cur->units += b->units;
c010470f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104712:	8b 10                	mov    (%eax),%edx
c0104714:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104717:	8b 00                	mov    (%eax),%eax
c0104719:	01 c2                	add    %eax,%edx
c010471b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471e:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104723:	8b 50 04             	mov    0x4(%eax),%edx
c0104726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104729:	89 50 04             	mov    %edx,0x4(%eax)
c010472c:	eb 09                	jmp    c0104737 <slob_free+0x103>
	} else
		cur->next = b;
c010472e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104731:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104734:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104737:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473a:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c010473f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104742:	89 04 24             	mov    %eax,(%esp)
c0104745:	e8 88 fb ff ff       	call   c01042d2 <__intr_restore>
}
c010474a:	c9                   	leave  
c010474b:	c3                   	ret    

c010474c <slob_init>:



void
slob_init(void) {
c010474c:	55                   	push   %ebp
c010474d:	89 e5                	mov    %esp,%ebp
c010474f:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104752:	c7 04 24 3a a9 10 c0 	movl   $0xc010a93a,(%esp)
c0104759:	e8 f5 bb ff ff       	call   c0100353 <cprintf>
}
c010475e:	c9                   	leave  
c010475f:	c3                   	ret    

c0104760 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104760:	55                   	push   %ebp
c0104761:	89 e5                	mov    %esp,%ebp
c0104763:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104766:	e8 e1 ff ff ff       	call   c010474c <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c010476b:	c7 04 24 4e a9 10 c0 	movl   $0xc010a94e,(%esp)
c0104772:	e8 dc bb ff ff       	call   c0100353 <cprintf>
}
c0104777:	c9                   	leave  
c0104778:	c3                   	ret    

c0104779 <slob_allocated>:

size_t
slob_allocated(void) {
c0104779:	55                   	push   %ebp
c010477a:	89 e5                	mov    %esp,%ebp
  return 0;
c010477c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104781:	5d                   	pop    %ebp
c0104782:	c3                   	ret    

c0104783 <kallocated>:

size_t
kallocated(void) {
c0104783:	55                   	push   %ebp
c0104784:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104786:	e8 ee ff ff ff       	call   c0104779 <slob_allocated>
}
c010478b:	5d                   	pop    %ebp
c010478c:	c3                   	ret    

c010478d <find_order>:

static int find_order(int size)
{
c010478d:	55                   	push   %ebp
c010478e:	89 e5                	mov    %esp,%ebp
c0104790:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104793:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c010479a:	eb 07                	jmp    c01047a3 <find_order+0x16>
		order++;
c010479c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c01047a0:	d1 7d 08             	sarl   0x8(%ebp)
c01047a3:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01047aa:	7f f0                	jg     c010479c <find_order+0xf>
		order++;
	return order;
c01047ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01047af:	c9                   	leave  
c01047b0:	c3                   	ret    

c01047b1 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c01047b1:	55                   	push   %ebp
c01047b2:	89 e5                	mov    %esp,%ebp
c01047b4:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c01047b7:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c01047be:	77 38                	ja     c01047f8 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c01047c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c3:	8d 50 08             	lea    0x8(%eax),%edx
c01047c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047cd:	00 
c01047ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047d5:	89 14 24             	mov    %edx,(%esp)
c01047d8:	e8 82 fc ff ff       	call   c010445f <slob_alloc>
c01047dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c01047e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047e4:	74 08                	je     c01047ee <__kmalloc+0x3d>
c01047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e9:	83 c0 08             	add    $0x8,%eax
c01047ec:	eb 05                	jmp    c01047f3 <__kmalloc+0x42>
c01047ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01047f3:	e9 a6 00 00 00       	jmp    c010489e <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c01047f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ff:	00 
c0104800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104803:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104807:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c010480e:	e8 4c fc ff ff       	call   c010445f <slob_alloc>
c0104813:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010481a:	75 07                	jne    c0104823 <__kmalloc+0x72>
		return 0;
c010481c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104821:	eb 7b                	jmp    c010489e <__kmalloc+0xed>

	bb->order = find_order(size);
c0104823:	8b 45 08             	mov    0x8(%ebp),%eax
c0104826:	89 04 24             	mov    %eax,(%esp)
c0104829:	e8 5f ff ff ff       	call   c010478d <find_order>
c010482e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104831:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104833:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104836:	8b 00                	mov    (%eax),%eax
c0104838:	89 44 24 04          	mov    %eax,0x4(%esp)
c010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010483f:	89 04 24             	mov    %eax,(%esp)
c0104842:	e8 ab fb ff ff       	call   c01043f2 <__slob_get_free_pages>
c0104847:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010484a:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c010484d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104850:	8b 40 04             	mov    0x4(%eax),%eax
c0104853:	85 c0                	test   %eax,%eax
c0104855:	74 2f                	je     c0104886 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104857:	e8 4c fa ff ff       	call   c01042a8 <__intr_save>
c010485c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c010485f:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c0104865:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104868:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c010486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010486e:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c0104873:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104876:	89 04 24             	mov    %eax,(%esp)
c0104879:	e8 54 fa ff ff       	call   c01042d2 <__intr_restore>
		return bb->pages;
c010487e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104881:	8b 40 04             	mov    0x4(%eax),%eax
c0104884:	eb 18                	jmp    c010489e <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104886:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c010488d:	00 
c010488e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104891:	89 04 24             	mov    %eax,(%esp)
c0104894:	e8 9b fd ff ff       	call   c0104634 <slob_free>
	return 0;
c0104899:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010489e:	c9                   	leave  
c010489f:	c3                   	ret    

c01048a0 <kmalloc>:

void *
kmalloc(size_t size)
{
c01048a0:	55                   	push   %ebp
c01048a1:	89 e5                	mov    %esp,%ebp
c01048a3:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c01048a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048ad:	00 
c01048ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01048b1:	89 04 24             	mov    %eax,(%esp)
c01048b4:	e8 f8 fe ff ff       	call   c01047b1 <__kmalloc>
}
c01048b9:	c9                   	leave  
c01048ba:	c3                   	ret    

c01048bb <kfree>:


void kfree(void *block)
{
c01048bb:	55                   	push   %ebp
c01048bc:	89 e5                	mov    %esp,%ebp
c01048be:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c01048c1:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01048c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01048cc:	75 05                	jne    c01048d3 <kfree+0x18>
		return;
c01048ce:	e9 a2 00 00 00       	jmp    c0104975 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01048d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01048d6:	25 ff 0f 00 00       	and    $0xfff,%eax
c01048db:	85 c0                	test   %eax,%eax
c01048dd:	75 7f                	jne    c010495e <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01048df:	e8 c4 f9 ff ff       	call   c01042a8 <__intr_save>
c01048e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01048e7:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c01048ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048ef:	eb 5c                	jmp    c010494d <kfree+0x92>
			if (bb->pages == block) {
c01048f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048f4:	8b 40 04             	mov    0x4(%eax),%eax
c01048f7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01048fa:	75 3f                	jne    c010493b <kfree+0x80>
				*last = bb->next;
c01048fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ff:	8b 50 08             	mov    0x8(%eax),%edx
c0104902:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104905:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104907:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010490a:	89 04 24             	mov    %eax,(%esp)
c010490d:	e8 c0 f9 ff ff       	call   c01042d2 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104912:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104915:	8b 10                	mov    (%eax),%edx
c0104917:	8b 45 08             	mov    0x8(%ebp),%eax
c010491a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010491e:	89 04 24             	mov    %eax,(%esp)
c0104921:	e8 05 fb ff ff       	call   c010442b <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104926:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c010492d:	00 
c010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104931:	89 04 24             	mov    %eax,(%esp)
c0104934:	e8 fb fc ff ff       	call   c0104634 <slob_free>
				return;
c0104939:	eb 3a                	jmp    c0104975 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010493b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010493e:	83 c0 08             	add    $0x8,%eax
c0104941:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104947:	8b 40 08             	mov    0x8(%eax),%eax
c010494a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010494d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104951:	75 9e                	jne    c01048f1 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104953:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104956:	89 04 24             	mov    %eax,(%esp)
c0104959:	e8 74 f9 ff ff       	call   c01042d2 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c010495e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104961:	83 e8 08             	sub    $0x8,%eax
c0104964:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010496b:	00 
c010496c:	89 04 24             	mov    %eax,(%esp)
c010496f:	e8 c0 fc ff ff       	call   c0104634 <slob_free>
	return;
c0104974:	90                   	nop
}
c0104975:	c9                   	leave  
c0104976:	c3                   	ret    

c0104977 <ksize>:


unsigned int ksize(const void *block)
{
c0104977:	55                   	push   %ebp
c0104978:	89 e5                	mov    %esp,%ebp
c010497a:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c010497d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104981:	75 07                	jne    c010498a <ksize+0x13>
		return 0;
c0104983:	b8 00 00 00 00       	mov    $0x0,%eax
c0104988:	eb 6b                	jmp    c01049f5 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c010498a:	8b 45 08             	mov    0x8(%ebp),%eax
c010498d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104992:	85 c0                	test   %eax,%eax
c0104994:	75 54                	jne    c01049ea <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104996:	e8 0d f9 ff ff       	call   c01042a8 <__intr_save>
c010499b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c010499e:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c01049a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049a6:	eb 31                	jmp    c01049d9 <ksize+0x62>
			if (bb->pages == block) {
c01049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ab:	8b 40 04             	mov    0x4(%eax),%eax
c01049ae:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049b1:	75 1d                	jne    c01049d0 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c01049b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b6:	89 04 24             	mov    %eax,(%esp)
c01049b9:	e8 14 f9 ff ff       	call   c01042d2 <__intr_restore>
				return PAGE_SIZE << bb->order;
c01049be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c1:	8b 00                	mov    (%eax),%eax
c01049c3:	ba 00 10 00 00       	mov    $0x1000,%edx
c01049c8:	89 c1                	mov    %eax,%ecx
c01049ca:	d3 e2                	shl    %cl,%edx
c01049cc:	89 d0                	mov    %edx,%eax
c01049ce:	eb 25                	jmp    c01049f5 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c01049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d3:	8b 40 08             	mov    0x8(%eax),%eax
c01049d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049dd:	75 c9                	jne    c01049a8 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c01049df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049e2:	89 04 24             	mov    %eax,(%esp)
c01049e5:	e8 e8 f8 ff ff       	call   c01042d2 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c01049ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01049ed:	83 e8 08             	sub    $0x8,%eax
c01049f0:	8b 00                	mov    (%eax),%eax
c01049f2:	c1 e0 03             	shl    $0x3,%eax
}
c01049f5:	c9                   	leave  
c01049f6:	c3                   	ret    

c01049f7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01049f7:	55                   	push   %ebp
c01049f8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01049fa:	8b 55 08             	mov    0x8(%ebp),%edx
c01049fd:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a02:	29 c2                	sub    %eax,%edx
c0104a04:	89 d0                	mov    %edx,%eax
c0104a06:	c1 f8 05             	sar    $0x5,%eax
}
c0104a09:	5d                   	pop    %ebp
c0104a0a:	c3                   	ret    

c0104a0b <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104a0b:	55                   	push   %ebp
c0104a0c:	89 e5                	mov    %esp,%ebp
c0104a0e:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a14:	89 04 24             	mov    %eax,(%esp)
c0104a17:	e8 db ff ff ff       	call   c01049f7 <page2ppn>
c0104a1c:	c1 e0 0c             	shl    $0xc,%eax
}
c0104a1f:	c9                   	leave  
c0104a20:	c3                   	ret    

c0104a21 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104a21:	55                   	push   %ebp
c0104a22:	89 e5                	mov    %esp,%ebp
c0104a24:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a2a:	c1 e8 0c             	shr    $0xc,%eax
c0104a2d:	89 c2                	mov    %eax,%edx
c0104a2f:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104a34:	39 c2                	cmp    %eax,%edx
c0104a36:	72 1c                	jb     c0104a54 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104a38:	c7 44 24 08 6c a9 10 	movl   $0xc010a96c,0x8(%esp)
c0104a3f:	c0 
c0104a40:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104a47:	00 
c0104a48:	c7 04 24 8b a9 10 c0 	movl   $0xc010a98b,(%esp)
c0104a4f:	e8 88 c2 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c0104a54:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a59:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a5c:	c1 ea 0c             	shr    $0xc,%edx
c0104a5f:	c1 e2 05             	shl    $0x5,%edx
c0104a62:	01 d0                	add    %edx,%eax
}
c0104a64:	c9                   	leave  
c0104a65:	c3                   	ret    

c0104a66 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104a66:	55                   	push   %ebp
c0104a67:	89 e5                	mov    %esp,%ebp
c0104a69:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a6f:	89 04 24             	mov    %eax,(%esp)
c0104a72:	e8 94 ff ff ff       	call   c0104a0b <page2pa>
c0104a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a7d:	c1 e8 0c             	shr    $0xc,%eax
c0104a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a83:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104a88:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104a8b:	72 23                	jb     c0104ab0 <page2kva+0x4a>
c0104a8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a90:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a94:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c0104a9b:	c0 
c0104a9c:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104aa3:	00 
c0104aa4:	c7 04 24 8b a9 10 c0 	movl   $0xc010a98b,(%esp)
c0104aab:	e8 2c c2 ff ff       	call   c0100cdc <__panic>
c0104ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104ab8:	c9                   	leave  
c0104ab9:	c3                   	ret    

c0104aba <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104aba:	55                   	push   %ebp
c0104abb:	89 e5                	mov    %esp,%ebp
c0104abd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ac3:	83 e0 01             	and    $0x1,%eax
c0104ac6:	85 c0                	test   %eax,%eax
c0104ac8:	75 1c                	jne    c0104ae6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104aca:	c7 44 24 08 c0 a9 10 	movl   $0xc010a9c0,0x8(%esp)
c0104ad1:	c0 
c0104ad2:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104ad9:	00 
c0104ada:	c7 04 24 8b a9 10 c0 	movl   $0xc010a98b,(%esp)
c0104ae1:	e8 f6 c1 ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ae9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104aee:	89 04 24             	mov    %eax,(%esp)
c0104af1:	e8 2b ff ff ff       	call   c0104a21 <pa2page>
}
c0104af6:	c9                   	leave  
c0104af7:	c3                   	ret    

c0104af8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104af8:	55                   	push   %ebp
c0104af9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0104afe:	8b 00                	mov    (%eax),%eax
}
c0104b00:	5d                   	pop    %ebp
c0104b01:	c3                   	ret    

c0104b02 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104b02:	55                   	push   %ebp
c0104b03:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b08:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b0b:	89 10                	mov    %edx,(%eax)
}
c0104b0d:	5d                   	pop    %ebp
c0104b0e:	c3                   	ret    

c0104b0f <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104b0f:	55                   	push   %ebp
c0104b10:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b15:	8b 00                	mov    (%eax),%eax
c0104b17:	8d 50 01             	lea    0x1(%eax),%edx
c0104b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b1d:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b22:	8b 00                	mov    (%eax),%eax
}
c0104b24:	5d                   	pop    %ebp
c0104b25:	c3                   	ret    

c0104b26 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104b26:	55                   	push   %ebp
c0104b27:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b2c:	8b 00                	mov    (%eax),%eax
c0104b2e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104b31:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b34:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b39:	8b 00                	mov    (%eax),%eax
}
c0104b3b:	5d                   	pop    %ebp
c0104b3c:	c3                   	ret    

c0104b3d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104b3d:	55                   	push   %ebp
c0104b3e:	89 e5                	mov    %esp,%ebp
c0104b40:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104b43:	9c                   	pushf  
c0104b44:	58                   	pop    %eax
c0104b45:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104b4b:	25 00 02 00 00       	and    $0x200,%eax
c0104b50:	85 c0                	test   %eax,%eax
c0104b52:	74 0c                	je     c0104b60 <__intr_save+0x23>
        intr_disable();
c0104b54:	e8 db d3 ff ff       	call   c0101f34 <intr_disable>
        return 1;
c0104b59:	b8 01 00 00 00       	mov    $0x1,%eax
c0104b5e:	eb 05                	jmp    c0104b65 <__intr_save+0x28>
    }
    return 0;
c0104b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b65:	c9                   	leave  
c0104b66:	c3                   	ret    

c0104b67 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104b67:	55                   	push   %ebp
c0104b68:	89 e5                	mov    %esp,%ebp
c0104b6a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b71:	74 05                	je     c0104b78 <__intr_restore+0x11>
        intr_enable();
c0104b73:	e8 b6 d3 ff ff       	call   c0101f2e <intr_enable>
    }
}
c0104b78:	c9                   	leave  
c0104b79:	c3                   	ret    

c0104b7a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104b7a:	55                   	push   %ebp
c0104b7b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b80:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104b83:	b8 23 00 00 00       	mov    $0x23,%eax
c0104b88:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104b8a:	b8 23 00 00 00       	mov    $0x23,%eax
c0104b8f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104b91:	b8 10 00 00 00       	mov    $0x10,%eax
c0104b96:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104b98:	b8 10 00 00 00       	mov    $0x10,%eax
c0104b9d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104b9f:	b8 10 00 00 00       	mov    $0x10,%eax
c0104ba4:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104ba6:	ea ad 4b 10 c0 08 00 	ljmp   $0x8,$0xc0104bad
}
c0104bad:	5d                   	pop    %ebp
c0104bae:	c3                   	ret    

c0104baf <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104baf:	55                   	push   %ebp
c0104bb0:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bb5:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104bba:	5d                   	pop    %ebp
c0104bbb:	c3                   	ret    

c0104bbc <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104bbc:	55                   	push   %ebp
c0104bbd:	89 e5                	mov    %esp,%ebp
c0104bbf:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104bc2:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104bc7:	89 04 24             	mov    %eax,(%esp)
c0104bca:	e8 e0 ff ff ff       	call   c0104baf <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104bcf:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104bd6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104bd8:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104bdf:	68 00 
c0104be1:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104be6:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104bec:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104bf1:	c1 e8 10             	shr    $0x10,%eax
c0104bf4:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104bf9:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c00:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c03:	83 c8 09             	or     $0x9,%eax
c0104c06:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c0b:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c12:	83 e0 ef             	and    $0xffffffef,%eax
c0104c15:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c1a:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c21:	83 e0 9f             	and    $0xffffff9f,%eax
c0104c24:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c29:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c30:	83 c8 80             	or     $0xffffff80,%eax
c0104c33:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c38:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c3f:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c42:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c47:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c4e:	83 e0 ef             	and    $0xffffffef,%eax
c0104c51:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c56:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c5d:	83 e0 df             	and    $0xffffffdf,%eax
c0104c60:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c65:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c6c:	83 c8 40             	or     $0x40,%eax
c0104c6f:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c74:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104c7b:	83 e0 7f             	and    $0x7f,%eax
c0104c7e:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104c83:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c88:	c1 e8 18             	shr    $0x18,%eax
c0104c8b:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104c90:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104c97:	e8 de fe ff ff       	call   c0104b7a <lgdt>
c0104c9c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104ca2:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104ca6:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104ca9:	c9                   	leave  
c0104caa:	c3                   	ret    

c0104cab <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104cab:	55                   	push   %ebp
c0104cac:	89 e5                	mov    %esp,%ebp
c0104cae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104cb1:	c7 05 24 7b 12 c0 60 	movl   $0xc010a860,0xc0127b24
c0104cb8:	a8 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104cbb:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104cc0:	8b 00                	mov    (%eax),%eax
c0104cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104cc6:	c7 04 24 ec a9 10 c0 	movl   $0xc010a9ec,(%esp)
c0104ccd:	e8 81 b6 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104cd2:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104cd7:	8b 40 04             	mov    0x4(%eax),%eax
c0104cda:	ff d0                	call   *%eax
}
c0104cdc:	c9                   	leave  
c0104cdd:	c3                   	ret    

c0104cde <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104cde:	55                   	push   %ebp
c0104cdf:	89 e5                	mov    %esp,%ebp
c0104ce1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104ce4:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104ce9:	8b 40 08             	mov    0x8(%eax),%eax
c0104cec:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104cef:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cf3:	8b 55 08             	mov    0x8(%ebp),%edx
c0104cf6:	89 14 24             	mov    %edx,(%esp)
c0104cf9:	ff d0                	call   *%eax
}
c0104cfb:	c9                   	leave  
c0104cfc:	c3                   	ret    

c0104cfd <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104cfd:	55                   	push   %ebp
c0104cfe:	89 e5                	mov    %esp,%ebp
c0104d00:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104d03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104d0a:	e8 2e fe ff ff       	call   c0104b3d <__intr_save>
c0104d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104d12:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d17:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d1d:	89 14 24             	mov    %edx,(%esp)
c0104d20:	ff d0                	call   *%eax
c0104d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d28:	89 04 24             	mov    %eax,(%esp)
c0104d2b:	e8 37 fe ff ff       	call   c0104b67 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d34:	75 2d                	jne    c0104d63 <alloc_pages+0x66>
c0104d36:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104d3a:	77 27                	ja     c0104d63 <alloc_pages+0x66>
c0104d3c:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104d41:	85 c0                	test   %eax,%eax
c0104d43:	74 1e                	je     c0104d63 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104d45:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d48:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104d4d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d54:	00 
c0104d55:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d59:	89 04 24             	mov    %eax,(%esp)
c0104d5c:	e8 75 19 00 00       	call   c01066d6 <swap_out>
    }
c0104d61:	eb a7                	jmp    c0104d0a <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104d66:	c9                   	leave  
c0104d67:	c3                   	ret    

c0104d68 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104d68:	55                   	push   %ebp
c0104d69:	89 e5                	mov    %esp,%ebp
c0104d6b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104d6e:	e8 ca fd ff ff       	call   c0104b3d <__intr_save>
c0104d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104d76:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d7b:	8b 40 10             	mov    0x10(%eax),%eax
c0104d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d81:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d85:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d88:	89 14 24             	mov    %edx,(%esp)
c0104d8b:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d90:	89 04 24             	mov    %eax,(%esp)
c0104d93:	e8 cf fd ff ff       	call   c0104b67 <__intr_restore>
}
c0104d98:	c9                   	leave  
c0104d99:	c3                   	ret    

c0104d9a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104d9a:	55                   	push   %ebp
c0104d9b:	89 e5                	mov    %esp,%ebp
c0104d9d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104da0:	e8 98 fd ff ff       	call   c0104b3d <__intr_save>
c0104da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104da8:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104dad:	8b 40 14             	mov    0x14(%eax),%eax
c0104db0:	ff d0                	call   *%eax
c0104db2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104db8:	89 04 24             	mov    %eax,(%esp)
c0104dbb:	e8 a7 fd ff ff       	call   c0104b67 <__intr_restore>
    return ret;
c0104dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104dc3:	c9                   	leave  
c0104dc4:	c3                   	ret    

c0104dc5 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104dc5:	55                   	push   %ebp
c0104dc6:	89 e5                	mov    %esp,%ebp
c0104dc8:	57                   	push   %edi
c0104dc9:	56                   	push   %esi
c0104dca:	53                   	push   %ebx
c0104dcb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104dd1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104dd8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104ddf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104de6:	c7 04 24 03 aa 10 c0 	movl   $0xc010aa03,(%esp)
c0104ded:	e8 61 b5 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104df2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104df9:	e9 15 01 00 00       	jmp    c0104f13 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104dfe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e01:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e04:	89 d0                	mov    %edx,%eax
c0104e06:	c1 e0 02             	shl    $0x2,%eax
c0104e09:	01 d0                	add    %edx,%eax
c0104e0b:	c1 e0 02             	shl    $0x2,%eax
c0104e0e:	01 c8                	add    %ecx,%eax
c0104e10:	8b 50 08             	mov    0x8(%eax),%edx
c0104e13:	8b 40 04             	mov    0x4(%eax),%eax
c0104e16:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e19:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104e1c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e22:	89 d0                	mov    %edx,%eax
c0104e24:	c1 e0 02             	shl    $0x2,%eax
c0104e27:	01 d0                	add    %edx,%eax
c0104e29:	c1 e0 02             	shl    $0x2,%eax
c0104e2c:	01 c8                	add    %ecx,%eax
c0104e2e:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e31:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e34:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e37:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e3a:	01 c8                	add    %ecx,%eax
c0104e3c:	11 da                	adc    %ebx,%edx
c0104e3e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104e41:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104e44:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e47:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e4a:	89 d0                	mov    %edx,%eax
c0104e4c:	c1 e0 02             	shl    $0x2,%eax
c0104e4f:	01 d0                	add    %edx,%eax
c0104e51:	c1 e0 02             	shl    $0x2,%eax
c0104e54:	01 c8                	add    %ecx,%eax
c0104e56:	83 c0 14             	add    $0x14,%eax
c0104e59:	8b 00                	mov    (%eax),%eax
c0104e5b:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104e61:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104e64:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104e67:	83 c0 ff             	add    $0xffffffff,%eax
c0104e6a:	83 d2 ff             	adc    $0xffffffff,%edx
c0104e6d:	89 c6                	mov    %eax,%esi
c0104e6f:	89 d7                	mov    %edx,%edi
c0104e71:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e74:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e77:	89 d0                	mov    %edx,%eax
c0104e79:	c1 e0 02             	shl    $0x2,%eax
c0104e7c:	01 d0                	add    %edx,%eax
c0104e7e:	c1 e0 02             	shl    $0x2,%eax
c0104e81:	01 c8                	add    %ecx,%eax
c0104e83:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e86:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e89:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104e8f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104e93:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104e97:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104e9b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e9e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104ea1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ea5:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104ea9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104ead:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104eb1:	c7 04 24 10 aa 10 c0 	movl   $0xc010aa10,(%esp)
c0104eb8:	e8 96 b4 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104ebd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ec0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ec3:	89 d0                	mov    %edx,%eax
c0104ec5:	c1 e0 02             	shl    $0x2,%eax
c0104ec8:	01 d0                	add    %edx,%eax
c0104eca:	c1 e0 02             	shl    $0x2,%eax
c0104ecd:	01 c8                	add    %ecx,%eax
c0104ecf:	83 c0 14             	add    $0x14,%eax
c0104ed2:	8b 00                	mov    (%eax),%eax
c0104ed4:	83 f8 01             	cmp    $0x1,%eax
c0104ed7:	75 36                	jne    c0104f0f <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104ed9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104edc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104edf:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104ee2:	77 2b                	ja     c0104f0f <page_init+0x14a>
c0104ee4:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104ee7:	72 05                	jb     c0104eee <page_init+0x129>
c0104ee9:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104eec:	73 21                	jae    c0104f0f <page_init+0x14a>
c0104eee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104ef2:	77 1b                	ja     c0104f0f <page_init+0x14a>
c0104ef4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104ef8:	72 09                	jb     c0104f03 <page_init+0x13e>
c0104efa:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104f01:	77 0c                	ja     c0104f0f <page_init+0x14a>
                maxpa = end;
c0104f03:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f06:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f0c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f0f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104f13:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f16:	8b 00                	mov    (%eax),%eax
c0104f18:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104f1b:	0f 8f dd fe ff ff    	jg     c0104dfe <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f25:	72 1d                	jb     c0104f44 <page_init+0x17f>
c0104f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f2b:	77 09                	ja     c0104f36 <page_init+0x171>
c0104f2d:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104f34:	76 0e                	jbe    c0104f44 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104f36:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104f3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f4a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104f4e:	c1 ea 0c             	shr    $0xc,%edx
c0104f51:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104f56:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104f5d:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c0104f62:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104f65:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104f68:	01 d0                	add    %edx,%eax
c0104f6a:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104f6d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104f70:	ba 00 00 00 00       	mov    $0x0,%edx
c0104f75:	f7 75 ac             	divl   -0x54(%ebp)
c0104f78:	89 d0                	mov    %edx,%eax
c0104f7a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104f7d:	29 c2                	sub    %eax,%edx
c0104f7f:	89 d0                	mov    %edx,%eax
c0104f81:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c0104f86:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104f8d:	eb 27                	jmp    c0104fb6 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104f8f:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104f94:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f97:	c1 e2 05             	shl    $0x5,%edx
c0104f9a:	01 d0                	add    %edx,%eax
c0104f9c:	83 c0 04             	add    $0x4,%eax
c0104f9f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104fa6:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104fa9:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104fac:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104faf:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104fb2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104fb6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fb9:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104fbe:	39 c2                	cmp    %eax,%edx
c0104fc0:	72 cd                	jb     c0104f8f <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104fc2:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104fc7:	c1 e0 05             	shl    $0x5,%eax
c0104fca:	89 c2                	mov    %eax,%edx
c0104fcc:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104fd1:	01 d0                	add    %edx,%eax
c0104fd3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104fd6:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104fdd:	77 23                	ja     c0105002 <page_init+0x23d>
c0104fdf:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104fe2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fe6:	c7 44 24 08 40 aa 10 	movl   $0xc010aa40,0x8(%esp)
c0104fed:	c0 
c0104fee:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0104ff5:	00 
c0104ff6:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0104ffd:	e8 da bc ff ff       	call   c0100cdc <__panic>
c0105002:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105005:	05 00 00 00 40       	add    $0x40000000,%eax
c010500a:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010500d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105014:	e9 74 01 00 00       	jmp    c010518d <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105019:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010501c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010501f:	89 d0                	mov    %edx,%eax
c0105021:	c1 e0 02             	shl    $0x2,%eax
c0105024:	01 d0                	add    %edx,%eax
c0105026:	c1 e0 02             	shl    $0x2,%eax
c0105029:	01 c8                	add    %ecx,%eax
c010502b:	8b 50 08             	mov    0x8(%eax),%edx
c010502e:	8b 40 04             	mov    0x4(%eax),%eax
c0105031:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105034:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105037:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010503a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010503d:	89 d0                	mov    %edx,%eax
c010503f:	c1 e0 02             	shl    $0x2,%eax
c0105042:	01 d0                	add    %edx,%eax
c0105044:	c1 e0 02             	shl    $0x2,%eax
c0105047:	01 c8                	add    %ecx,%eax
c0105049:	8b 48 0c             	mov    0xc(%eax),%ecx
c010504c:	8b 58 10             	mov    0x10(%eax),%ebx
c010504f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105052:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105055:	01 c8                	add    %ecx,%eax
c0105057:	11 da                	adc    %ebx,%edx
c0105059:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010505c:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010505f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105062:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105065:	89 d0                	mov    %edx,%eax
c0105067:	c1 e0 02             	shl    $0x2,%eax
c010506a:	01 d0                	add    %edx,%eax
c010506c:	c1 e0 02             	shl    $0x2,%eax
c010506f:	01 c8                	add    %ecx,%eax
c0105071:	83 c0 14             	add    $0x14,%eax
c0105074:	8b 00                	mov    (%eax),%eax
c0105076:	83 f8 01             	cmp    $0x1,%eax
c0105079:	0f 85 0a 01 00 00    	jne    c0105189 <page_init+0x3c4>
            if (begin < freemem) {
c010507f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105082:	ba 00 00 00 00       	mov    $0x0,%edx
c0105087:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010508a:	72 17                	jb     c01050a3 <page_init+0x2de>
c010508c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010508f:	77 05                	ja     c0105096 <page_init+0x2d1>
c0105091:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105094:	76 0d                	jbe    c01050a3 <page_init+0x2de>
                begin = freemem;
c0105096:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105099:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010509c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01050a3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01050a7:	72 1d                	jb     c01050c6 <page_init+0x301>
c01050a9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01050ad:	77 09                	ja     c01050b8 <page_init+0x2f3>
c01050af:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01050b6:	76 0e                	jbe    c01050c6 <page_init+0x301>
                end = KMEMSIZE;
c01050b8:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01050bf:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01050c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01050cc:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01050cf:	0f 87 b4 00 00 00    	ja     c0105189 <page_init+0x3c4>
c01050d5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01050d8:	72 09                	jb     c01050e3 <page_init+0x31e>
c01050da:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01050dd:	0f 83 a6 00 00 00    	jae    c0105189 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01050e3:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01050ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01050ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01050f0:	01 d0                	add    %edx,%eax
c01050f2:	83 e8 01             	sub    $0x1,%eax
c01050f5:	89 45 98             	mov    %eax,-0x68(%ebp)
c01050f8:	8b 45 98             	mov    -0x68(%ebp),%eax
c01050fb:	ba 00 00 00 00       	mov    $0x0,%edx
c0105100:	f7 75 9c             	divl   -0x64(%ebp)
c0105103:	89 d0                	mov    %edx,%eax
c0105105:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105108:	29 c2                	sub    %eax,%edx
c010510a:	89 d0                	mov    %edx,%eax
c010510c:	ba 00 00 00 00       	mov    $0x0,%edx
c0105111:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105114:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105117:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010511a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010511d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105120:	ba 00 00 00 00       	mov    $0x0,%edx
c0105125:	89 c7                	mov    %eax,%edi
c0105127:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010512d:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105130:	89 d0                	mov    %edx,%eax
c0105132:	83 e0 00             	and    $0x0,%eax
c0105135:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105138:	8b 45 80             	mov    -0x80(%ebp),%eax
c010513b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010513e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105141:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105144:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105147:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010514a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010514d:	77 3a                	ja     c0105189 <page_init+0x3c4>
c010514f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105152:	72 05                	jb     c0105159 <page_init+0x394>
c0105154:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105157:	73 30                	jae    c0105189 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105159:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010515c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010515f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105162:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105165:	29 c8                	sub    %ecx,%eax
c0105167:	19 da                	sbb    %ebx,%edx
c0105169:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010516d:	c1 ea 0c             	shr    $0xc,%edx
c0105170:	89 c3                	mov    %eax,%ebx
c0105172:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105175:	89 04 24             	mov    %eax,(%esp)
c0105178:	e8 a4 f8 ff ff       	call   c0104a21 <pa2page>
c010517d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105181:	89 04 24             	mov    %eax,(%esp)
c0105184:	e8 55 fb ff ff       	call   c0104cde <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0105189:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010518d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105190:	8b 00                	mov    (%eax),%eax
c0105192:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105195:	0f 8f 7e fe ff ff    	jg     c0105019 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010519b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01051a1:	5b                   	pop    %ebx
c01051a2:	5e                   	pop    %esi
c01051a3:	5f                   	pop    %edi
c01051a4:	5d                   	pop    %ebp
c01051a5:	c3                   	ret    

c01051a6 <enable_paging>:

static void
enable_paging(void) {
c01051a6:	55                   	push   %ebp
c01051a7:	89 e5                	mov    %esp,%ebp
c01051a9:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01051ac:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c01051b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01051b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01051b7:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01051ba:	0f 20 c0             	mov    %cr0,%eax
c01051bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01051c0:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01051c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01051c6:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01051cd:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01051d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01051d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051da:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01051dd:	c9                   	leave  
c01051de:	c3                   	ret    

c01051df <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01051df:	55                   	push   %ebp
c01051e0:	89 e5                	mov    %esp,%ebp
c01051e2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01051e5:	8b 45 14             	mov    0x14(%ebp),%eax
c01051e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051eb:	31 d0                	xor    %edx,%eax
c01051ed:	25 ff 0f 00 00       	and    $0xfff,%eax
c01051f2:	85 c0                	test   %eax,%eax
c01051f4:	74 24                	je     c010521a <boot_map_segment+0x3b>
c01051f6:	c7 44 24 0c 72 aa 10 	movl   $0xc010aa72,0xc(%esp)
c01051fd:	c0 
c01051fe:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105205:	c0 
c0105206:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010520d:	00 
c010520e:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105215:	e8 c2 ba ff ff       	call   c0100cdc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010521a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105221:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105224:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105229:	89 c2                	mov    %eax,%edx
c010522b:	8b 45 10             	mov    0x10(%ebp),%eax
c010522e:	01 c2                	add    %eax,%edx
c0105230:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105233:	01 d0                	add    %edx,%eax
c0105235:	83 e8 01             	sub    $0x1,%eax
c0105238:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010523b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010523e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105243:	f7 75 f0             	divl   -0x10(%ebp)
c0105246:	89 d0                	mov    %edx,%eax
c0105248:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010524b:	29 c2                	sub    %eax,%edx
c010524d:	89 d0                	mov    %edx,%eax
c010524f:	c1 e8 0c             	shr    $0xc,%eax
c0105252:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105255:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105258:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010525b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010525e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105263:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105266:	8b 45 14             	mov    0x14(%ebp),%eax
c0105269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010526c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010526f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105274:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105277:	eb 6b                	jmp    c01052e4 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105279:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105280:	00 
c0105281:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105284:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105288:	8b 45 08             	mov    0x8(%ebp),%eax
c010528b:	89 04 24             	mov    %eax,(%esp)
c010528e:	e8 d1 01 00 00       	call   c0105464 <get_pte>
c0105293:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105296:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010529a:	75 24                	jne    c01052c0 <boot_map_segment+0xe1>
c010529c:	c7 44 24 0c 9e aa 10 	movl   $0xc010aa9e,0xc(%esp)
c01052a3:	c0 
c01052a4:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01052ab:	c0 
c01052ac:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01052b3:	00 
c01052b4:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01052bb:	e8 1c ba ff ff       	call   c0100cdc <__panic>
        *ptep = pa | PTE_P | perm;
c01052c0:	8b 45 18             	mov    0x18(%ebp),%eax
c01052c3:	8b 55 14             	mov    0x14(%ebp),%edx
c01052c6:	09 d0                	or     %edx,%eax
c01052c8:	83 c8 01             	or     $0x1,%eax
c01052cb:	89 c2                	mov    %eax,%edx
c01052cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052d0:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01052d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01052d6:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01052dd:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01052e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01052e8:	75 8f                	jne    c0105279 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01052ea:	c9                   	leave  
c01052eb:	c3                   	ret    

c01052ec <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01052ec:	55                   	push   %ebp
c01052ed:	89 e5                	mov    %esp,%ebp
c01052ef:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01052f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01052f9:	e8 ff f9 ff ff       	call   c0104cfd <alloc_pages>
c01052fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105301:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105305:	75 1c                	jne    c0105323 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105307:	c7 44 24 08 ab aa 10 	movl   $0xc010aaab,0x8(%esp)
c010530e:	c0 
c010530f:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105316:	00 
c0105317:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010531e:	e8 b9 b9 ff ff       	call   c0100cdc <__panic>
    }
    return page2kva(p);
c0105323:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105326:	89 04 24             	mov    %eax,(%esp)
c0105329:	e8 38 f7 ff ff       	call   c0104a66 <page2kva>
}
c010532e:	c9                   	leave  
c010532f:	c3                   	ret    

c0105330 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105330:	55                   	push   %ebp
c0105331:	89 e5                	mov    %esp,%ebp
c0105333:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105336:	e8 70 f9 ff ff       	call   c0104cab <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010533b:	e8 85 fa ff ff       	call   c0104dc5 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105340:	e8 49 05 00 00       	call   c010588e <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105345:	e8 a2 ff ff ff       	call   c01052ec <boot_alloc_page>
c010534a:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c010534f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105354:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010535b:	00 
c010535c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105363:	00 
c0105364:	89 04 24             	mov    %eax,(%esp)
c0105367:	e8 86 47 00 00       	call   c0109af2 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010536c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105371:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105374:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010537b:	77 23                	ja     c01053a0 <pmm_init+0x70>
c010537d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105380:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105384:	c7 44 24 08 40 aa 10 	movl   $0xc010aa40,0x8(%esp)
c010538b:	c0 
c010538c:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105393:	00 
c0105394:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010539b:	e8 3c b9 ff ff       	call   c0100cdc <__panic>
c01053a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053a3:	05 00 00 00 40       	add    $0x40000000,%eax
c01053a8:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c01053ad:	e8 fa 04 00 00       	call   c01058ac <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01053b2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053b7:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01053bd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053c5:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01053cc:	77 23                	ja     c01053f1 <pmm_init+0xc1>
c01053ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053d5:	c7 44 24 08 40 aa 10 	movl   $0xc010aa40,0x8(%esp)
c01053dc:	c0 
c01053dd:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01053e4:	00 
c01053e5:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01053ec:	e8 eb b8 ff ff       	call   c0100cdc <__panic>
c01053f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053f4:	05 00 00 00 40       	add    $0x40000000,%eax
c01053f9:	83 c8 03             	or     $0x3,%eax
c01053fc:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01053fe:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105403:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010540a:	00 
c010540b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105412:	00 
c0105413:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010541a:	38 
c010541b:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105422:	c0 
c0105423:	89 04 24             	mov    %eax,(%esp)
c0105426:	e8 b4 fd ff ff       	call   c01051df <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010542b:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105430:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0105436:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010543c:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010543e:	e8 63 fd ff ff       	call   c01051a6 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105443:	e8 74 f7 ff ff       	call   c0104bbc <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105448:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010544d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105453:	e8 ef 0a 00 00       	call   c0105f47 <check_boot_pgdir>

    print_pgdir();
c0105458:	e8 7c 0f 00 00       	call   c01063d9 <print_pgdir>
    
    kmalloc_init();
c010545d:	e8 fe f2 ff ff       	call   c0104760 <kmalloc_init>

}
c0105462:	c9                   	leave  
c0105463:	c3                   	ret    

c0105464 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105464:	55                   	push   %ebp
c0105465:	89 e5                	mov    %esp,%ebp
c0105467:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

pde_t *pdep = &pgdir[PDX(la)];
c010546a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010546d:	c1 e8 16             	shr    $0x16,%eax
c0105470:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105477:	8b 45 08             	mov    0x8(%ebp),%eax
c010547a:	01 d0                	add    %edx,%eax
c010547c:	89 45 f4             	mov    %eax,-0xc(%ebp)
if(!(*pdep & PTE_P))
c010547f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105482:	8b 00                	mov    (%eax),%eax
c0105484:	83 e0 01             	and    $0x1,%eax
c0105487:	85 c0                	test   %eax,%eax
c0105489:	0f 85 bd 00 00 00    	jne    c010554c <get_pte+0xe8>
{
    struct Page* p;
    if(create){
c010548f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105493:	0f 84 ac 00 00 00    	je     c0105545 <get_pte+0xe1>
    	p = alloc_page();
c0105499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054a0:	e8 58 f8 ff ff       	call   c0104cfd <alloc_pages>
c01054a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(p != NULL)
c01054a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01054ac:	0f 84 8c 00 00 00    	je     c010553e <get_pte+0xda>
	{
	    set_page_ref(p,1);
c01054b2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01054b9:	00 
c01054ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054bd:	89 04 24             	mov    %eax,(%esp)
c01054c0:	e8 3d f6 ff ff       	call   c0104b02 <set_page_ref>
	    uintptr_t pa = page2pa(p);
c01054c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054c8:	89 04 24             	mov    %eax,(%esp)
c01054cb:	e8 3b f5 ff ff       	call   c0104a0b <page2pa>
c01054d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa),0,PGSIZE);
c01054d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054dc:	c1 e8 0c             	shr    $0xc,%eax
c01054df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01054e2:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01054e7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01054ea:	72 23                	jb     c010550f <get_pte+0xab>
c01054ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054f3:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c01054fa:	c0 
c01054fb:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c0105502:	00 
c0105503:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010550a:	e8 cd b7 ff ff       	call   c0100cdc <__panic>
c010550f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105512:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105517:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010551e:	00 
c010551f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105526:	00 
c0105527:	89 04 24             	mov    %eax,(%esp)
c010552a:	e8 c3 45 00 00       	call   c0109af2 <memset>
	    *pdep = pa | PTE_P | PTE_W | PTE_U; //why?
c010552f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105532:	83 c8 07             	or     $0x7,%eax
c0105535:	89 c2                	mov    %eax,%edx
c0105537:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010553a:	89 10                	mov    %edx,(%eax)
c010553c:	eb 0e                	jmp    c010554c <get_pte+0xe8>
	}
	else return NULL;
c010553e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105543:	eb 63                	jmp    c01055a8 <get_pte+0x144>
    }
    else return NULL;
c0105545:	b8 00 00 00 00       	mov    $0x0,%eax
c010554a:	eb 5c                	jmp    c01055a8 <get_pte+0x144>
  }
  return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010554c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010554f:	8b 00                	mov    (%eax),%eax
c0105551:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105556:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105559:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010555c:	c1 e8 0c             	shr    $0xc,%eax
c010555f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105562:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105567:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010556a:	72 23                	jb     c010558f <get_pte+0x12b>
c010556c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010556f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105573:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c010557a:	c0 
c010557b:	c7 44 24 04 a1 01 00 	movl   $0x1a1,0x4(%esp)
c0105582:	00 
c0105583:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010558a:	e8 4d b7 ff ff       	call   c0100cdc <__panic>
c010558f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105592:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105597:	8b 55 0c             	mov    0xc(%ebp),%edx
c010559a:	c1 ea 0c             	shr    $0xc,%edx
c010559d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01055a3:	c1 e2 02             	shl    $0x2,%edx
c01055a6:	01 d0                	add    %edx,%eax
}
c01055a8:	c9                   	leave  
c01055a9:	c3                   	ret    

c01055aa <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01055aa:	55                   	push   %ebp
c01055ab:	89 e5                	mov    %esp,%ebp
c01055ad:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01055b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055b7:	00 
c01055b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c2:	89 04 24             	mov    %eax,(%esp)
c01055c5:	e8 9a fe ff ff       	call   c0105464 <get_pte>
c01055ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01055cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055d1:	74 08                	je     c01055db <get_page+0x31>
        *ptep_store = ptep;
c01055d3:	8b 45 10             	mov    0x10(%ebp),%eax
c01055d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055d9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01055db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01055df:	74 1b                	je     c01055fc <get_page+0x52>
c01055e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055e4:	8b 00                	mov    (%eax),%eax
c01055e6:	83 e0 01             	and    $0x1,%eax
c01055e9:	85 c0                	test   %eax,%eax
c01055eb:	74 0f                	je     c01055fc <get_page+0x52>
        return pa2page(*ptep);
c01055ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055f0:	8b 00                	mov    (%eax),%eax
c01055f2:	89 04 24             	mov    %eax,(%esp)
c01055f5:	e8 27 f4 ff ff       	call   c0104a21 <pa2page>
c01055fa:	eb 05                	jmp    c0105601 <get_page+0x57>
    }
    return NULL;
c01055fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105601:	c9                   	leave  
c0105602:	c3                   	ret    

c0105603 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105603:	55                   	push   %ebp
c0105604:	89 e5                	mov    %esp,%ebp
c0105606:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c0105609:	8b 45 10             	mov    0x10(%ebp),%eax
c010560c:	8b 00                	mov    (%eax),%eax
c010560e:	83 e0 01             	and    $0x1,%eax
c0105611:	85 c0                	test   %eax,%eax
c0105613:	74 52                	je     c0105667 <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
c0105615:	8b 45 10             	mov    0x10(%ebp),%eax
c0105618:	8b 00                	mov    (%eax),%eax
c010561a:	89 04 24             	mov    %eax,(%esp)
c010561d:	e8 98 f4 ff ff       	call   c0104aba <pte2page>
c0105622:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
c0105625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105628:	89 04 24             	mov    %eax,(%esp)
c010562b:	e8 f6 f4 ff ff       	call   c0104b26 <page_ref_dec>
    if(page->ref == 0)
c0105630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105633:	8b 00                	mov    (%eax),%eax
c0105635:	85 c0                	test   %eax,%eax
c0105637:	75 13                	jne    c010564c <page_remove_pte+0x49>
    {
	free_page(page);
c0105639:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105640:	00 
c0105641:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105644:	89 04 24             	mov    %eax,(%esp)
c0105647:	e8 1c f7 ff ff       	call   c0104d68 <free_pages>
    }
    *ptep = 0;
c010564c:	8b 45 10             	mov    0x10(%ebp),%eax
c010564f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir,la);
c0105655:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105658:	89 44 24 04          	mov    %eax,0x4(%esp)
c010565c:	8b 45 08             	mov    0x8(%ebp),%eax
c010565f:	89 04 24             	mov    %eax,(%esp)
c0105662:	e8 ff 00 00 00       	call   c0105766 <tlb_invalidate>
  }
}
c0105667:	c9                   	leave  
c0105668:	c3                   	ret    

c0105669 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105669:	55                   	push   %ebp
c010566a:	89 e5                	mov    %esp,%ebp
c010566c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010566f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105676:	00 
c0105677:	8b 45 0c             	mov    0xc(%ebp),%eax
c010567a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010567e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105681:	89 04 24             	mov    %eax,(%esp)
c0105684:	e8 db fd ff ff       	call   c0105464 <get_pte>
c0105689:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010568c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105690:	74 19                	je     c01056ab <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105692:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105695:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105699:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a3:	89 04 24             	mov    %eax,(%esp)
c01056a6:	e8 58 ff ff ff       	call   c0105603 <page_remove_pte>
    }
}
c01056ab:	c9                   	leave  
c01056ac:	c3                   	ret    

c01056ad <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01056ad:	55                   	push   %ebp
c01056ae:	89 e5                	mov    %esp,%ebp
c01056b0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01056b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01056ba:	00 
c01056bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01056be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c5:	89 04 24             	mov    %eax,(%esp)
c01056c8:	e8 97 fd ff ff       	call   c0105464 <get_pte>
c01056cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01056d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056d4:	75 0a                	jne    c01056e0 <page_insert+0x33>
        return -E_NO_MEM;
c01056d6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01056db:	e9 84 00 00 00       	jmp    c0105764 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e3:	89 04 24             	mov    %eax,(%esp)
c01056e6:	e8 24 f4 ff ff       	call   c0104b0f <page_ref_inc>
    if (*ptep & PTE_P) {
c01056eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ee:	8b 00                	mov    (%eax),%eax
c01056f0:	83 e0 01             	and    $0x1,%eax
c01056f3:	85 c0                	test   %eax,%eax
c01056f5:	74 3e                	je     c0105735 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01056f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056fa:	8b 00                	mov    (%eax),%eax
c01056fc:	89 04 24             	mov    %eax,(%esp)
c01056ff:	e8 b6 f3 ff ff       	call   c0104aba <pte2page>
c0105704:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105707:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010570a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010570d:	75 0d                	jne    c010571c <page_insert+0x6f>
            page_ref_dec(page);
c010570f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105712:	89 04 24             	mov    %eax,(%esp)
c0105715:	e8 0c f4 ff ff       	call   c0104b26 <page_ref_dec>
c010571a:	eb 19                	jmp    c0105735 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010571c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010571f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105723:	8b 45 10             	mov    0x10(%ebp),%eax
c0105726:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572a:	8b 45 08             	mov    0x8(%ebp),%eax
c010572d:	89 04 24             	mov    %eax,(%esp)
c0105730:	e8 ce fe ff ff       	call   c0105603 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105735:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105738:	89 04 24             	mov    %eax,(%esp)
c010573b:	e8 cb f2 ff ff       	call   c0104a0b <page2pa>
c0105740:	0b 45 14             	or     0x14(%ebp),%eax
c0105743:	83 c8 01             	or     $0x1,%eax
c0105746:	89 c2                	mov    %eax,%edx
c0105748:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010574b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010574d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105750:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105754:	8b 45 08             	mov    0x8(%ebp),%eax
c0105757:	89 04 24             	mov    %eax,(%esp)
c010575a:	e8 07 00 00 00       	call   c0105766 <tlb_invalidate>
    return 0;
c010575f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105764:	c9                   	leave  
c0105765:	c3                   	ret    

c0105766 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105766:	55                   	push   %ebp
c0105767:	89 e5                	mov    %esp,%ebp
c0105769:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010576c:	0f 20 d8             	mov    %cr3,%eax
c010576f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105772:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105775:	89 c2                	mov    %eax,%edx
c0105777:	8b 45 08             	mov    0x8(%ebp),%eax
c010577a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010577d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105784:	77 23                	ja     c01057a9 <tlb_invalidate+0x43>
c0105786:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105789:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010578d:	c7 44 24 08 40 aa 10 	movl   $0xc010aa40,0x8(%esp)
c0105794:	c0 
c0105795:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010579c:	00 
c010579d:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01057a4:	e8 33 b5 ff ff       	call   c0100cdc <__panic>
c01057a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057ac:	05 00 00 00 40       	add    $0x40000000,%eax
c01057b1:	39 c2                	cmp    %eax,%edx
c01057b3:	75 0c                	jne    c01057c1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01057b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01057bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057be:	0f 01 38             	invlpg (%eax)
    }
}
c01057c1:	c9                   	leave  
c01057c2:	c3                   	ret    

c01057c3 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01057c3:	55                   	push   %ebp
c01057c4:	89 e5                	mov    %esp,%ebp
c01057c6:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01057c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01057d0:	e8 28 f5 ff ff       	call   c0104cfd <alloc_pages>
c01057d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01057d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057dc:	0f 84 a7 00 00 00    	je     c0105889 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01057e2:	8b 45 10             	mov    0x10(%ebp),%eax
c01057e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01057fa:	89 04 24             	mov    %eax,(%esp)
c01057fd:	e8 ab fe ff ff       	call   c01056ad <page_insert>
c0105802:	85 c0                	test   %eax,%eax
c0105804:	74 1a                	je     c0105820 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105806:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010580d:	00 
c010580e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105811:	89 04 24             	mov    %eax,(%esp)
c0105814:	e8 4f f5 ff ff       	call   c0104d68 <free_pages>
            return NULL;
c0105819:	b8 00 00 00 00       	mov    $0x0,%eax
c010581e:	eb 6c                	jmp    c010588c <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105820:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0105825:	85 c0                	test   %eax,%eax
c0105827:	74 60                	je     c0105889 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c0105829:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010582e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105835:	00 
c0105836:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105839:	89 54 24 08          	mov    %edx,0x8(%esp)
c010583d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105840:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105844:	89 04 24             	mov    %eax,(%esp)
c0105847:	e8 3e 0e 00 00       	call   c010668a <swap_map_swappable>
            page->pra_vaddr=la;
c010584c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010584f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105852:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105855:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105858:	89 04 24             	mov    %eax,(%esp)
c010585b:	e8 98 f2 ff ff       	call   c0104af8 <page_ref>
c0105860:	83 f8 01             	cmp    $0x1,%eax
c0105863:	74 24                	je     c0105889 <pgdir_alloc_page+0xc6>
c0105865:	c7 44 24 0c c4 aa 10 	movl   $0xc010aac4,0xc(%esp)
c010586c:	c0 
c010586d:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105874:	c0 
c0105875:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c010587c:	00 
c010587d:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105884:	e8 53 b4 ff ff       	call   c0100cdc <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105889:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010588c:	c9                   	leave  
c010588d:	c3                   	ret    

c010588e <check_alloc_page>:

static void
check_alloc_page(void) {
c010588e:	55                   	push   %ebp
c010588f:	89 e5                	mov    %esp,%ebp
c0105891:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105894:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0105899:	8b 40 18             	mov    0x18(%eax),%eax
c010589c:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010589e:	c7 04 24 d8 aa 10 c0 	movl   $0xc010aad8,(%esp)
c01058a5:	e8 a9 aa ff ff       	call   c0100353 <cprintf>
}
c01058aa:	c9                   	leave  
c01058ab:	c3                   	ret    

c01058ac <check_pgdir>:

static void
check_pgdir(void) {
c01058ac:	55                   	push   %ebp
c01058ad:	89 e5                	mov    %esp,%ebp
c01058af:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01058b2:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01058b7:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01058bc:	76 24                	jbe    c01058e2 <check_pgdir+0x36>
c01058be:	c7 44 24 0c f7 aa 10 	movl   $0xc010aaf7,0xc(%esp)
c01058c5:	c0 
c01058c6:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01058cd:	c0 
c01058ce:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c01058d5:	00 
c01058d6:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01058dd:	e8 fa b3 ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01058e2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01058e7:	85 c0                	test   %eax,%eax
c01058e9:	74 0e                	je     c01058f9 <check_pgdir+0x4d>
c01058eb:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01058f0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01058f5:	85 c0                	test   %eax,%eax
c01058f7:	74 24                	je     c010591d <check_pgdir+0x71>
c01058f9:	c7 44 24 0c 14 ab 10 	movl   $0xc010ab14,0xc(%esp)
c0105900:	c0 
c0105901:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105908:	c0 
c0105909:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105910:	00 
c0105911:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105918:	e8 bf b3 ff ff       	call   c0100cdc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010591d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105922:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105929:	00 
c010592a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105931:	00 
c0105932:	89 04 24             	mov    %eax,(%esp)
c0105935:	e8 70 fc ff ff       	call   c01055aa <get_page>
c010593a:	85 c0                	test   %eax,%eax
c010593c:	74 24                	je     c0105962 <check_pgdir+0xb6>
c010593e:	c7 44 24 0c 4c ab 10 	movl   $0xc010ab4c,0xc(%esp)
c0105945:	c0 
c0105946:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c010594d:	c0 
c010594e:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105955:	00 
c0105956:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010595d:	e8 7a b3 ff ff       	call   c0100cdc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105962:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105969:	e8 8f f3 ff ff       	call   c0104cfd <alloc_pages>
c010596e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105971:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105976:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010597d:	00 
c010597e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105985:	00 
c0105986:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105989:	89 54 24 04          	mov    %edx,0x4(%esp)
c010598d:	89 04 24             	mov    %eax,(%esp)
c0105990:	e8 18 fd ff ff       	call   c01056ad <page_insert>
c0105995:	85 c0                	test   %eax,%eax
c0105997:	74 24                	je     c01059bd <check_pgdir+0x111>
c0105999:	c7 44 24 0c 74 ab 10 	movl   $0xc010ab74,0xc(%esp)
c01059a0:	c0 
c01059a1:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01059a8:	c0 
c01059a9:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01059b0:	00 
c01059b1:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01059b8:	e8 1f b3 ff ff       	call   c0100cdc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01059bd:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059c9:	00 
c01059ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01059d1:	00 
c01059d2:	89 04 24             	mov    %eax,(%esp)
c01059d5:	e8 8a fa ff ff       	call   c0105464 <get_pte>
c01059da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01059e1:	75 24                	jne    c0105a07 <check_pgdir+0x15b>
c01059e3:	c7 44 24 0c a0 ab 10 	movl   $0xc010aba0,0xc(%esp)
c01059ea:	c0 
c01059eb:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01059f2:	c0 
c01059f3:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c01059fa:	00 
c01059fb:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105a02:	e8 d5 b2 ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c0105a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a0a:	8b 00                	mov    (%eax),%eax
c0105a0c:	89 04 24             	mov    %eax,(%esp)
c0105a0f:	e8 0d f0 ff ff       	call   c0104a21 <pa2page>
c0105a14:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a17:	74 24                	je     c0105a3d <check_pgdir+0x191>
c0105a19:	c7 44 24 0c cd ab 10 	movl   $0xc010abcd,0xc(%esp)
c0105a20:	c0 
c0105a21:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105a28:	c0 
c0105a29:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105a30:	00 
c0105a31:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105a38:	e8 9f b2 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 1);
c0105a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a40:	89 04 24             	mov    %eax,(%esp)
c0105a43:	e8 b0 f0 ff ff       	call   c0104af8 <page_ref>
c0105a48:	83 f8 01             	cmp    $0x1,%eax
c0105a4b:	74 24                	je     c0105a71 <check_pgdir+0x1c5>
c0105a4d:	c7 44 24 0c e2 ab 10 	movl   $0xc010abe2,0xc(%esp)
c0105a54:	c0 
c0105a55:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105a5c:	c0 
c0105a5d:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105a64:	00 
c0105a65:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105a6c:	e8 6b b2 ff ff       	call   c0100cdc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105a71:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a76:	8b 00                	mov    (%eax),%eax
c0105a78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105a7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a83:	c1 e8 0c             	shr    $0xc,%eax
c0105a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a89:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105a8e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105a91:	72 23                	jb     c0105ab6 <check_pgdir+0x20a>
c0105a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a9a:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c0105aa1:	c0 
c0105aa2:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105aa9:	00 
c0105aaa:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105ab1:	e8 26 b2 ff ff       	call   c0100cdc <__panic>
c0105ab6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ab9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105abe:	83 c0 04             	add    $0x4,%eax
c0105ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105ac4:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ac9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ad0:	00 
c0105ad1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105ad8:	00 
c0105ad9:	89 04 24             	mov    %eax,(%esp)
c0105adc:	e8 83 f9 ff ff       	call   c0105464 <get_pte>
c0105ae1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105ae4:	74 24                	je     c0105b0a <check_pgdir+0x25e>
c0105ae6:	c7 44 24 0c f4 ab 10 	movl   $0xc010abf4,0xc(%esp)
c0105aed:	c0 
c0105aee:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105af5:	c0 
c0105af6:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105afd:	00 
c0105afe:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105b05:	e8 d2 b1 ff ff       	call   c0100cdc <__panic>

    p2 = alloc_page();
c0105b0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b11:	e8 e7 f1 ff ff       	call   c0104cfd <alloc_pages>
c0105b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105b19:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b1e:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105b25:	00 
c0105b26:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b2d:	00 
c0105b2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b31:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b35:	89 04 24             	mov    %eax,(%esp)
c0105b38:	e8 70 fb ff ff       	call   c01056ad <page_insert>
c0105b3d:	85 c0                	test   %eax,%eax
c0105b3f:	74 24                	je     c0105b65 <check_pgdir+0x2b9>
c0105b41:	c7 44 24 0c 1c ac 10 	movl   $0xc010ac1c,0xc(%esp)
c0105b48:	c0 
c0105b49:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105b50:	c0 
c0105b51:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105b58:	00 
c0105b59:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105b60:	e8 77 b1 ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105b65:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b71:	00 
c0105b72:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b79:	00 
c0105b7a:	89 04 24             	mov    %eax,(%esp)
c0105b7d:	e8 e2 f8 ff ff       	call   c0105464 <get_pte>
c0105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105b89:	75 24                	jne    c0105baf <check_pgdir+0x303>
c0105b8b:	c7 44 24 0c 54 ac 10 	movl   $0xc010ac54,0xc(%esp)
c0105b92:	c0 
c0105b93:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105b9a:	c0 
c0105b9b:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105ba2:	00 
c0105ba3:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105baa:	e8 2d b1 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_U);
c0105baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bb2:	8b 00                	mov    (%eax),%eax
c0105bb4:	83 e0 04             	and    $0x4,%eax
c0105bb7:	85 c0                	test   %eax,%eax
c0105bb9:	75 24                	jne    c0105bdf <check_pgdir+0x333>
c0105bbb:	c7 44 24 0c 84 ac 10 	movl   $0xc010ac84,0xc(%esp)
c0105bc2:	c0 
c0105bc3:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105bca:	c0 
c0105bcb:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105bd2:	00 
c0105bd3:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105bda:	e8 fd b0 ff ff       	call   c0100cdc <__panic>
    assert(*ptep & PTE_W);
c0105bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be2:	8b 00                	mov    (%eax),%eax
c0105be4:	83 e0 02             	and    $0x2,%eax
c0105be7:	85 c0                	test   %eax,%eax
c0105be9:	75 24                	jne    c0105c0f <check_pgdir+0x363>
c0105beb:	c7 44 24 0c 92 ac 10 	movl   $0xc010ac92,0xc(%esp)
c0105bf2:	c0 
c0105bf3:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105bfa:	c0 
c0105bfb:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105c02:	00 
c0105c03:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105c0a:	e8 cd b0 ff ff       	call   c0100cdc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105c0f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c14:	8b 00                	mov    (%eax),%eax
c0105c16:	83 e0 04             	and    $0x4,%eax
c0105c19:	85 c0                	test   %eax,%eax
c0105c1b:	75 24                	jne    c0105c41 <check_pgdir+0x395>
c0105c1d:	c7 44 24 0c a0 ac 10 	movl   $0xc010aca0,0xc(%esp)
c0105c24:	c0 
c0105c25:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105c2c:	c0 
c0105c2d:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105c34:	00 
c0105c35:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105c3c:	e8 9b b0 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 1);
c0105c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c44:	89 04 24             	mov    %eax,(%esp)
c0105c47:	e8 ac ee ff ff       	call   c0104af8 <page_ref>
c0105c4c:	83 f8 01             	cmp    $0x1,%eax
c0105c4f:	74 24                	je     c0105c75 <check_pgdir+0x3c9>
c0105c51:	c7 44 24 0c b6 ac 10 	movl   $0xc010acb6,0xc(%esp)
c0105c58:	c0 
c0105c59:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105c60:	c0 
c0105c61:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105c68:	00 
c0105c69:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105c70:	e8 67 b0 ff ff       	call   c0100cdc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105c75:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c7a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105c81:	00 
c0105c82:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105c89:	00 
c0105c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c8d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c91:	89 04 24             	mov    %eax,(%esp)
c0105c94:	e8 14 fa ff ff       	call   c01056ad <page_insert>
c0105c99:	85 c0                	test   %eax,%eax
c0105c9b:	74 24                	je     c0105cc1 <check_pgdir+0x415>
c0105c9d:	c7 44 24 0c c8 ac 10 	movl   $0xc010acc8,0xc(%esp)
c0105ca4:	c0 
c0105ca5:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105cac:	c0 
c0105cad:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105cb4:	00 
c0105cb5:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105cbc:	e8 1b b0 ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p1) == 2);
c0105cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cc4:	89 04 24             	mov    %eax,(%esp)
c0105cc7:	e8 2c ee ff ff       	call   c0104af8 <page_ref>
c0105ccc:	83 f8 02             	cmp    $0x2,%eax
c0105ccf:	74 24                	je     c0105cf5 <check_pgdir+0x449>
c0105cd1:	c7 44 24 0c f4 ac 10 	movl   $0xc010acf4,0xc(%esp)
c0105cd8:	c0 
c0105cd9:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105ce0:	c0 
c0105ce1:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c0105ce8:	00 
c0105ce9:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105cf0:	e8 e7 af ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c0105cf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cf8:	89 04 24             	mov    %eax,(%esp)
c0105cfb:	e8 f8 ed ff ff       	call   c0104af8 <page_ref>
c0105d00:	85 c0                	test   %eax,%eax
c0105d02:	74 24                	je     c0105d28 <check_pgdir+0x47c>
c0105d04:	c7 44 24 0c 06 ad 10 	movl   $0xc010ad06,0xc(%esp)
c0105d0b:	c0 
c0105d0c:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105d13:	c0 
c0105d14:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105d1b:	00 
c0105d1c:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105d23:	e8 b4 af ff ff       	call   c0100cdc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105d28:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d34:	00 
c0105d35:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d3c:	00 
c0105d3d:	89 04 24             	mov    %eax,(%esp)
c0105d40:	e8 1f f7 ff ff       	call   c0105464 <get_pte>
c0105d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d4c:	75 24                	jne    c0105d72 <check_pgdir+0x4c6>
c0105d4e:	c7 44 24 0c 54 ac 10 	movl   $0xc010ac54,0xc(%esp)
c0105d55:	c0 
c0105d56:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105d5d:	c0 
c0105d5e:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105d65:	00 
c0105d66:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105d6d:	e8 6a af ff ff       	call   c0100cdc <__panic>
    assert(pa2page(*ptep) == p1);
c0105d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d75:	8b 00                	mov    (%eax),%eax
c0105d77:	89 04 24             	mov    %eax,(%esp)
c0105d7a:	e8 a2 ec ff ff       	call   c0104a21 <pa2page>
c0105d7f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105d82:	74 24                	je     c0105da8 <check_pgdir+0x4fc>
c0105d84:	c7 44 24 0c cd ab 10 	movl   $0xc010abcd,0xc(%esp)
c0105d8b:	c0 
c0105d8c:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105d93:	c0 
c0105d94:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105d9b:	00 
c0105d9c:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105da3:	e8 34 af ff ff       	call   c0100cdc <__panic>
    assert((*ptep & PTE_U) == 0);
c0105da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dab:	8b 00                	mov    (%eax),%eax
c0105dad:	83 e0 04             	and    $0x4,%eax
c0105db0:	85 c0                	test   %eax,%eax
c0105db2:	74 24                	je     c0105dd8 <check_pgdir+0x52c>
c0105db4:	c7 44 24 0c 18 ad 10 	movl   $0xc010ad18,0xc(%esp)
c0105dbb:	c0 
c0105dbc:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105dc3:	c0 
c0105dc4:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c0105dcb:	00 
c0105dcc:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105dd3:	e8 04 af ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, 0x0);
c0105dd8:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ddd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105de4:	00 
c0105de5:	89 04 24             	mov    %eax,(%esp)
c0105de8:	e8 7c f8 ff ff       	call   c0105669 <page_remove>
    assert(page_ref(p1) == 1);
c0105ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105df0:	89 04 24             	mov    %eax,(%esp)
c0105df3:	e8 00 ed ff ff       	call   c0104af8 <page_ref>
c0105df8:	83 f8 01             	cmp    $0x1,%eax
c0105dfb:	74 24                	je     c0105e21 <check_pgdir+0x575>
c0105dfd:	c7 44 24 0c e2 ab 10 	movl   $0xc010abe2,0xc(%esp)
c0105e04:	c0 
c0105e05:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105e0c:	c0 
c0105e0d:	c7 44 24 04 49 02 00 	movl   $0x249,0x4(%esp)
c0105e14:	00 
c0105e15:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105e1c:	e8 bb ae ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c0105e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e24:	89 04 24             	mov    %eax,(%esp)
c0105e27:	e8 cc ec ff ff       	call   c0104af8 <page_ref>
c0105e2c:	85 c0                	test   %eax,%eax
c0105e2e:	74 24                	je     c0105e54 <check_pgdir+0x5a8>
c0105e30:	c7 44 24 0c 06 ad 10 	movl   $0xc010ad06,0xc(%esp)
c0105e37:	c0 
c0105e38:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105e3f:	c0 
c0105e40:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c0105e47:	00 
c0105e48:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105e4f:	e8 88 ae ff ff       	call   c0100cdc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105e54:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e59:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105e60:	00 
c0105e61:	89 04 24             	mov    %eax,(%esp)
c0105e64:	e8 00 f8 ff ff       	call   c0105669 <page_remove>
    assert(page_ref(p1) == 0);
c0105e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e6c:	89 04 24             	mov    %eax,(%esp)
c0105e6f:	e8 84 ec ff ff       	call   c0104af8 <page_ref>
c0105e74:	85 c0                	test   %eax,%eax
c0105e76:	74 24                	je     c0105e9c <check_pgdir+0x5f0>
c0105e78:	c7 44 24 0c 2d ad 10 	movl   $0xc010ad2d,0xc(%esp)
c0105e7f:	c0 
c0105e80:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105e87:	c0 
c0105e88:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c0105e8f:	00 
c0105e90:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105e97:	e8 40 ae ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p2) == 0);
c0105e9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e9f:	89 04 24             	mov    %eax,(%esp)
c0105ea2:	e8 51 ec ff ff       	call   c0104af8 <page_ref>
c0105ea7:	85 c0                	test   %eax,%eax
c0105ea9:	74 24                	je     c0105ecf <check_pgdir+0x623>
c0105eab:	c7 44 24 0c 06 ad 10 	movl   $0xc010ad06,0xc(%esp)
c0105eb2:	c0 
c0105eb3:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105eba:	c0 
c0105ebb:	c7 44 24 04 4e 02 00 	movl   $0x24e,0x4(%esp)
c0105ec2:	00 
c0105ec3:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105eca:	e8 0d ae ff ff       	call   c0100cdc <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105ecf:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ed4:	8b 00                	mov    (%eax),%eax
c0105ed6:	89 04 24             	mov    %eax,(%esp)
c0105ed9:	e8 43 eb ff ff       	call   c0104a21 <pa2page>
c0105ede:	89 04 24             	mov    %eax,(%esp)
c0105ee1:	e8 12 ec ff ff       	call   c0104af8 <page_ref>
c0105ee6:	83 f8 01             	cmp    $0x1,%eax
c0105ee9:	74 24                	je     c0105f0f <check_pgdir+0x663>
c0105eeb:	c7 44 24 0c 40 ad 10 	movl   $0xc010ad40,0xc(%esp)
c0105ef2:	c0 
c0105ef3:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105efa:	c0 
c0105efb:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0105f02:	00 
c0105f03:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105f0a:	e8 cd ad ff ff       	call   c0100cdc <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105f0f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f14:	8b 00                	mov    (%eax),%eax
c0105f16:	89 04 24             	mov    %eax,(%esp)
c0105f19:	e8 03 eb ff ff       	call   c0104a21 <pa2page>
c0105f1e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f25:	00 
c0105f26:	89 04 24             	mov    %eax,(%esp)
c0105f29:	e8 3a ee ff ff       	call   c0104d68 <free_pages>
    boot_pgdir[0] = 0;
c0105f2e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105f39:	c7 04 24 66 ad 10 c0 	movl   $0xc010ad66,(%esp)
c0105f40:	e8 0e a4 ff ff       	call   c0100353 <cprintf>
}
c0105f45:	c9                   	leave  
c0105f46:	c3                   	ret    

c0105f47 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105f47:	55                   	push   %ebp
c0105f48:	89 e5                	mov    %esp,%ebp
c0105f4a:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105f54:	e9 ca 00 00 00       	jmp    c0106023 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f62:	c1 e8 0c             	shr    $0xc,%eax
c0105f65:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105f68:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105f6d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105f70:	72 23                	jb     c0105f95 <check_boot_pgdir+0x4e>
c0105f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f75:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105f79:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c0105f80:	c0 
c0105f81:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105f88:	00 
c0105f89:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105f90:	e8 47 ad ff ff       	call   c0100cdc <__panic>
c0105f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f98:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105f9d:	89 c2                	mov    %eax,%edx
c0105f9f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105fa4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105fab:	00 
c0105fac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105fb0:	89 04 24             	mov    %eax,(%esp)
c0105fb3:	e8 ac f4 ff ff       	call   c0105464 <get_pte>
c0105fb8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105fbb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105fbf:	75 24                	jne    c0105fe5 <check_boot_pgdir+0x9e>
c0105fc1:	c7 44 24 0c 80 ad 10 	movl   $0xc010ad80,0xc(%esp)
c0105fc8:	c0 
c0105fc9:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0105fd0:	c0 
c0105fd1:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105fd8:	00 
c0105fd9:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0105fe0:	e8 f7 ac ff ff       	call   c0100cdc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105fe5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105fe8:	8b 00                	mov    (%eax),%eax
c0105fea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105fef:	89 c2                	mov    %eax,%edx
c0105ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ff4:	39 c2                	cmp    %eax,%edx
c0105ff6:	74 24                	je     c010601c <check_boot_pgdir+0xd5>
c0105ff8:	c7 44 24 0c bd ad 10 	movl   $0xc010adbd,0xc(%esp)
c0105fff:	c0 
c0106000:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0106007:	c0 
c0106008:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c010600f:	00 
c0106010:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0106017:	e8 c0 ac ff ff       	call   c0100cdc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010601c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106023:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106026:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010602b:	39 c2                	cmp    %eax,%edx
c010602d:	0f 82 26 ff ff ff    	jb     c0105f59 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106033:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106038:	05 ac 0f 00 00       	add    $0xfac,%eax
c010603d:	8b 00                	mov    (%eax),%eax
c010603f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106044:	89 c2                	mov    %eax,%edx
c0106046:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010604b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010604e:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0106055:	77 23                	ja     c010607a <check_boot_pgdir+0x133>
c0106057:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010605a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010605e:	c7 44 24 08 40 aa 10 	movl   $0xc010aa40,0x8(%esp)
c0106065:	c0 
c0106066:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c010606d:	00 
c010606e:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0106075:	e8 62 ac ff ff       	call   c0100cdc <__panic>
c010607a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010607d:	05 00 00 00 40       	add    $0x40000000,%eax
c0106082:	39 c2                	cmp    %eax,%edx
c0106084:	74 24                	je     c01060aa <check_boot_pgdir+0x163>
c0106086:	c7 44 24 0c d4 ad 10 	movl   $0xc010add4,0xc(%esp)
c010608d:	c0 
c010608e:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0106095:	c0 
c0106096:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c010609d:	00 
c010609e:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01060a5:	e8 32 ac ff ff       	call   c0100cdc <__panic>

    assert(boot_pgdir[0] == 0);
c01060aa:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01060af:	8b 00                	mov    (%eax),%eax
c01060b1:	85 c0                	test   %eax,%eax
c01060b3:	74 24                	je     c01060d9 <check_boot_pgdir+0x192>
c01060b5:	c7 44 24 0c 08 ae 10 	movl   $0xc010ae08,0xc(%esp)
c01060bc:	c0 
c01060bd:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01060c4:	c0 
c01060c5:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c01060cc:	00 
c01060cd:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01060d4:	e8 03 ac ff ff       	call   c0100cdc <__panic>

    struct Page *p;
    p = alloc_page();
c01060d9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060e0:	e8 18 ec ff ff       	call   c0104cfd <alloc_pages>
c01060e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01060e8:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01060ed:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01060f4:	00 
c01060f5:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01060fc:	00 
c01060fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106100:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106104:	89 04 24             	mov    %eax,(%esp)
c0106107:	e8 a1 f5 ff ff       	call   c01056ad <page_insert>
c010610c:	85 c0                	test   %eax,%eax
c010610e:	74 24                	je     c0106134 <check_boot_pgdir+0x1ed>
c0106110:	c7 44 24 0c 1c ae 10 	movl   $0xc010ae1c,0xc(%esp)
c0106117:	c0 
c0106118:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c010611f:	c0 
c0106120:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0106127:	00 
c0106128:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c010612f:	e8 a8 ab ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 1);
c0106134:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106137:	89 04 24             	mov    %eax,(%esp)
c010613a:	e8 b9 e9 ff ff       	call   c0104af8 <page_ref>
c010613f:	83 f8 01             	cmp    $0x1,%eax
c0106142:	74 24                	je     c0106168 <check_boot_pgdir+0x221>
c0106144:	c7 44 24 0c 4a ae 10 	movl   $0xc010ae4a,0xc(%esp)
c010614b:	c0 
c010614c:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0106153:	c0 
c0106154:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c010615b:	00 
c010615c:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0106163:	e8 74 ab ff ff       	call   c0100cdc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106168:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010616d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106174:	00 
c0106175:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010617c:	00 
c010617d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106180:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106184:	89 04 24             	mov    %eax,(%esp)
c0106187:	e8 21 f5 ff ff       	call   c01056ad <page_insert>
c010618c:	85 c0                	test   %eax,%eax
c010618e:	74 24                	je     c01061b4 <check_boot_pgdir+0x26d>
c0106190:	c7 44 24 0c 5c ae 10 	movl   $0xc010ae5c,0xc(%esp)
c0106197:	c0 
c0106198:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c010619f:	c0 
c01061a0:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c01061a7:	00 
c01061a8:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01061af:	e8 28 ab ff ff       	call   c0100cdc <__panic>
    assert(page_ref(p) == 2);
c01061b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01061b7:	89 04 24             	mov    %eax,(%esp)
c01061ba:	e8 39 e9 ff ff       	call   c0104af8 <page_ref>
c01061bf:	83 f8 02             	cmp    $0x2,%eax
c01061c2:	74 24                	je     c01061e8 <check_boot_pgdir+0x2a1>
c01061c4:	c7 44 24 0c 93 ae 10 	movl   $0xc010ae93,0xc(%esp)
c01061cb:	c0 
c01061cc:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c01061d3:	c0 
c01061d4:	c7 44 24 04 69 02 00 	movl   $0x269,0x4(%esp)
c01061db:	00 
c01061dc:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c01061e3:	e8 f4 aa ff ff       	call   c0100cdc <__panic>

    const char *str = "ucore: Hello world!!";
c01061e8:	c7 45 dc a4 ae 10 c0 	movl   $0xc010aea4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01061ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01061f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061f6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01061fd:	e8 19 36 00 00       	call   c010981b <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106202:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106209:	00 
c010620a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106211:	e8 7e 36 00 00       	call   c0109894 <strcmp>
c0106216:	85 c0                	test   %eax,%eax
c0106218:	74 24                	je     c010623e <check_boot_pgdir+0x2f7>
c010621a:	c7 44 24 0c bc ae 10 	movl   $0xc010aebc,0xc(%esp)
c0106221:	c0 
c0106222:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0106229:	c0 
c010622a:	c7 44 24 04 6d 02 00 	movl   $0x26d,0x4(%esp)
c0106231:	00 
c0106232:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0106239:	e8 9e aa ff ff       	call   c0100cdc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010623e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106241:	89 04 24             	mov    %eax,(%esp)
c0106244:	e8 1d e8 ff ff       	call   c0104a66 <page2kva>
c0106249:	05 00 01 00 00       	add    $0x100,%eax
c010624e:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106251:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106258:	e8 66 35 00 00       	call   c01097c3 <strlen>
c010625d:	85 c0                	test   %eax,%eax
c010625f:	74 24                	je     c0106285 <check_boot_pgdir+0x33e>
c0106261:	c7 44 24 0c f4 ae 10 	movl   $0xc010aef4,0xc(%esp)
c0106268:	c0 
c0106269:	c7 44 24 08 89 aa 10 	movl   $0xc010aa89,0x8(%esp)
c0106270:	c0 
c0106271:	c7 44 24 04 70 02 00 	movl   $0x270,0x4(%esp)
c0106278:	00 
c0106279:	c7 04 24 64 aa 10 c0 	movl   $0xc010aa64,(%esp)
c0106280:	e8 57 aa ff ff       	call   c0100cdc <__panic>

    free_page(p);
c0106285:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010628c:	00 
c010628d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106290:	89 04 24             	mov    %eax,(%esp)
c0106293:	e8 d0 ea ff ff       	call   c0104d68 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0106298:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010629d:	8b 00                	mov    (%eax),%eax
c010629f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062a4:	89 04 24             	mov    %eax,(%esp)
c01062a7:	e8 75 e7 ff ff       	call   c0104a21 <pa2page>
c01062ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062b3:	00 
c01062b4:	89 04 24             	mov    %eax,(%esp)
c01062b7:	e8 ac ea ff ff       	call   c0104d68 <free_pages>
    boot_pgdir[0] = 0;
c01062bc:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01062c7:	c7 04 24 18 af 10 c0 	movl   $0xc010af18,(%esp)
c01062ce:	e8 80 a0 ff ff       	call   c0100353 <cprintf>
}
c01062d3:	c9                   	leave  
c01062d4:	c3                   	ret    

c01062d5 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01062d5:	55                   	push   %ebp
c01062d6:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01062d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01062db:	83 e0 04             	and    $0x4,%eax
c01062de:	85 c0                	test   %eax,%eax
c01062e0:	74 07                	je     c01062e9 <perm2str+0x14>
c01062e2:	b8 75 00 00 00       	mov    $0x75,%eax
c01062e7:	eb 05                	jmp    c01062ee <perm2str+0x19>
c01062e9:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01062ee:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c01062f3:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01062fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01062fd:	83 e0 02             	and    $0x2,%eax
c0106300:	85 c0                	test   %eax,%eax
c0106302:	74 07                	je     c010630b <perm2str+0x36>
c0106304:	b8 77 00 00 00       	mov    $0x77,%eax
c0106309:	eb 05                	jmp    c0106310 <perm2str+0x3b>
c010630b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106310:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c0106315:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c010631c:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c0106321:	5d                   	pop    %ebp
c0106322:	c3                   	ret    

c0106323 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106323:	55                   	push   %ebp
c0106324:	89 e5                	mov    %esp,%ebp
c0106326:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106329:	8b 45 10             	mov    0x10(%ebp),%eax
c010632c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010632f:	72 0a                	jb     c010633b <get_pgtable_items+0x18>
        return 0;
c0106331:	b8 00 00 00 00       	mov    $0x0,%eax
c0106336:	e9 9c 00 00 00       	jmp    c01063d7 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010633b:	eb 04                	jmp    c0106341 <get_pgtable_items+0x1e>
        start ++;
c010633d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106341:	8b 45 10             	mov    0x10(%ebp),%eax
c0106344:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106347:	73 18                	jae    c0106361 <get_pgtable_items+0x3e>
c0106349:	8b 45 10             	mov    0x10(%ebp),%eax
c010634c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106353:	8b 45 14             	mov    0x14(%ebp),%eax
c0106356:	01 d0                	add    %edx,%eax
c0106358:	8b 00                	mov    (%eax),%eax
c010635a:	83 e0 01             	and    $0x1,%eax
c010635d:	85 c0                	test   %eax,%eax
c010635f:	74 dc                	je     c010633d <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106361:	8b 45 10             	mov    0x10(%ebp),%eax
c0106364:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106367:	73 69                	jae    c01063d2 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106369:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010636d:	74 08                	je     c0106377 <get_pgtable_items+0x54>
            *left_store = start;
c010636f:	8b 45 18             	mov    0x18(%ebp),%eax
c0106372:	8b 55 10             	mov    0x10(%ebp),%edx
c0106375:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106377:	8b 45 10             	mov    0x10(%ebp),%eax
c010637a:	8d 50 01             	lea    0x1(%eax),%edx
c010637d:	89 55 10             	mov    %edx,0x10(%ebp)
c0106380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106387:	8b 45 14             	mov    0x14(%ebp),%eax
c010638a:	01 d0                	add    %edx,%eax
c010638c:	8b 00                	mov    (%eax),%eax
c010638e:	83 e0 07             	and    $0x7,%eax
c0106391:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106394:	eb 04                	jmp    c010639a <get_pgtable_items+0x77>
            start ++;
c0106396:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010639a:	8b 45 10             	mov    0x10(%ebp),%eax
c010639d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063a0:	73 1d                	jae    c01063bf <get_pgtable_items+0x9c>
c01063a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01063a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01063af:	01 d0                	add    %edx,%eax
c01063b1:	8b 00                	mov    (%eax),%eax
c01063b3:	83 e0 07             	and    $0x7,%eax
c01063b6:	89 c2                	mov    %eax,%edx
c01063b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01063bb:	39 c2                	cmp    %eax,%edx
c01063bd:	74 d7                	je     c0106396 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01063bf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01063c3:	74 08                	je     c01063cd <get_pgtable_items+0xaa>
            *right_store = start;
c01063c5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01063c8:	8b 55 10             	mov    0x10(%ebp),%edx
c01063cb:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01063cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01063d0:	eb 05                	jmp    c01063d7 <get_pgtable_items+0xb4>
    }
    return 0;
c01063d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01063d7:	c9                   	leave  
c01063d8:	c3                   	ret    

c01063d9 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01063d9:	55                   	push   %ebp
c01063da:	89 e5                	mov    %esp,%ebp
c01063dc:	57                   	push   %edi
c01063dd:	56                   	push   %esi
c01063de:	53                   	push   %ebx
c01063df:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01063e2:	c7 04 24 38 af 10 c0 	movl   $0xc010af38,(%esp)
c01063e9:	e8 65 9f ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c01063ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01063f5:	e9 fa 00 00 00       	jmp    c01064f4 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01063fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063fd:	89 04 24             	mov    %eax,(%esp)
c0106400:	e8 d0 fe ff ff       	call   c01062d5 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106405:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106408:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010640b:	29 d1                	sub    %edx,%ecx
c010640d:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010640f:	89 d6                	mov    %edx,%esi
c0106411:	c1 e6 16             	shl    $0x16,%esi
c0106414:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106417:	89 d3                	mov    %edx,%ebx
c0106419:	c1 e3 16             	shl    $0x16,%ebx
c010641c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010641f:	89 d1                	mov    %edx,%ecx
c0106421:	c1 e1 16             	shl    $0x16,%ecx
c0106424:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106427:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010642a:	29 d7                	sub    %edx,%edi
c010642c:	89 fa                	mov    %edi,%edx
c010642e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106432:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106436:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010643a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010643e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106442:	c7 04 24 69 af 10 c0 	movl   $0xc010af69,(%esp)
c0106449:	e8 05 9f ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010644e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106451:	c1 e0 0a             	shl    $0xa,%eax
c0106454:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106457:	eb 54                	jmp    c01064ad <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010645c:	89 04 24             	mov    %eax,(%esp)
c010645f:	e8 71 fe ff ff       	call   c01062d5 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106464:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106467:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010646a:	29 d1                	sub    %edx,%ecx
c010646c:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010646e:	89 d6                	mov    %edx,%esi
c0106470:	c1 e6 0c             	shl    $0xc,%esi
c0106473:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106476:	89 d3                	mov    %edx,%ebx
c0106478:	c1 e3 0c             	shl    $0xc,%ebx
c010647b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010647e:	c1 e2 0c             	shl    $0xc,%edx
c0106481:	89 d1                	mov    %edx,%ecx
c0106483:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106486:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106489:	29 d7                	sub    %edx,%edi
c010648b:	89 fa                	mov    %edi,%edx
c010648d:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106491:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106495:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106499:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010649d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064a1:	c7 04 24 88 af 10 c0 	movl   $0xc010af88,(%esp)
c01064a8:	e8 a6 9e ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01064ad:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01064b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01064b5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01064b8:	89 ce                	mov    %ecx,%esi
c01064ba:	c1 e6 0a             	shl    $0xa,%esi
c01064bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01064c0:	89 cb                	mov    %ecx,%ebx
c01064c2:	c1 e3 0a             	shl    $0xa,%ebx
c01064c5:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01064c8:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01064cc:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01064cf:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01064d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01064d7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01064db:	89 74 24 04          	mov    %esi,0x4(%esp)
c01064df:	89 1c 24             	mov    %ebx,(%esp)
c01064e2:	e8 3c fe ff ff       	call   c0106323 <get_pgtable_items>
c01064e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01064ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01064ee:	0f 85 65 ff ff ff    	jne    c0106459 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01064f4:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01064f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01064fc:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01064ff:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106503:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106506:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010650a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010650e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106512:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106519:	00 
c010651a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106521:	e8 fd fd ff ff       	call   c0106323 <get_pgtable_items>
c0106526:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106529:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010652d:	0f 85 c7 fe ff ff    	jne    c01063fa <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106533:	c7 04 24 ac af 10 c0 	movl   $0xc010afac,(%esp)
c010653a:	e8 14 9e ff ff       	call   c0100353 <cprintf>
}
c010653f:	83 c4 4c             	add    $0x4c,%esp
c0106542:	5b                   	pop    %ebx
c0106543:	5e                   	pop    %esi
c0106544:	5f                   	pop    %edi
c0106545:	5d                   	pop    %ebp
c0106546:	c3                   	ret    

c0106547 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106547:	55                   	push   %ebp
c0106548:	89 e5                	mov    %esp,%ebp
c010654a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010654d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106550:	c1 e8 0c             	shr    $0xc,%eax
c0106553:	89 c2                	mov    %eax,%edx
c0106555:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010655a:	39 c2                	cmp    %eax,%edx
c010655c:	72 1c                	jb     c010657a <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010655e:	c7 44 24 08 e0 af 10 	movl   $0xc010afe0,0x8(%esp)
c0106565:	c0 
c0106566:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010656d:	00 
c010656e:	c7 04 24 ff af 10 c0 	movl   $0xc010afff,(%esp)
c0106575:	e8 62 a7 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c010657a:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010657f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106582:	c1 ea 0c             	shr    $0xc,%edx
c0106585:	c1 e2 05             	shl    $0x5,%edx
c0106588:	01 d0                	add    %edx,%eax
}
c010658a:	c9                   	leave  
c010658b:	c3                   	ret    

c010658c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010658c:	55                   	push   %ebp
c010658d:	89 e5                	mov    %esp,%ebp
c010658f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106592:	8b 45 08             	mov    0x8(%ebp),%eax
c0106595:	83 e0 01             	and    $0x1,%eax
c0106598:	85 c0                	test   %eax,%eax
c010659a:	75 1c                	jne    c01065b8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010659c:	c7 44 24 08 10 b0 10 	movl   $0xc010b010,0x8(%esp)
c01065a3:	c0 
c01065a4:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01065ab:	00 
c01065ac:	c7 04 24 ff af 10 c0 	movl   $0xc010afff,(%esp)
c01065b3:	e8 24 a7 ff ff       	call   c0100cdc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01065b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01065bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01065c0:	89 04 24             	mov    %eax,(%esp)
c01065c3:	e8 7f ff ff ff       	call   c0106547 <pa2page>
}
c01065c8:	c9                   	leave  
c01065c9:	c3                   	ret    

c01065ca <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01065ca:	55                   	push   %ebp
c01065cb:	89 e5                	mov    %esp,%ebp
c01065cd:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01065d0:	e8 3e 1d 00 00       	call   c0108313 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01065d5:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01065da:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01065df:	76 0c                	jbe    c01065ed <swap_init+0x23>
c01065e1:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01065e6:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01065eb:	76 25                	jbe    c0106612 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01065ed:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c01065f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01065f6:	c7 44 24 08 31 b0 10 	movl   $0xc010b031,0x8(%esp)
c01065fd:	c0 
c01065fe:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106605:	00 
c0106606:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c010660d:	e8 ca a6 ff ff       	call   c0100cdc <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106612:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c0106619:	4a 12 c0 
     int r = sm->init();
c010661c:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106621:	8b 40 04             	mov    0x4(%eax),%eax
c0106624:	ff d0                	call   *%eax
c0106626:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010662d:	75 26                	jne    c0106655 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010662f:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c0106636:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106639:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010663e:	8b 00                	mov    (%eax),%eax
c0106640:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106644:	c7 04 24 5b b0 10 c0 	movl   $0xc010b05b,(%esp)
c010664b:	e8 03 9d ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106650:	e8 a4 04 00 00       	call   c0106af9 <check_swap>
     }

     return r;
c0106655:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106658:	c9                   	leave  
c0106659:	c3                   	ret    

c010665a <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c010665a:	55                   	push   %ebp
c010665b:	89 e5                	mov    %esp,%ebp
c010665d:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106660:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106665:	8b 40 08             	mov    0x8(%eax),%eax
c0106668:	8b 55 08             	mov    0x8(%ebp),%edx
c010666b:	89 14 24             	mov    %edx,(%esp)
c010666e:	ff d0                	call   *%eax
}
c0106670:	c9                   	leave  
c0106671:	c3                   	ret    

c0106672 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106672:	55                   	push   %ebp
c0106673:	89 e5                	mov    %esp,%ebp
c0106675:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106678:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010667d:	8b 40 0c             	mov    0xc(%eax),%eax
c0106680:	8b 55 08             	mov    0x8(%ebp),%edx
c0106683:	89 14 24             	mov    %edx,(%esp)
c0106686:	ff d0                	call   *%eax
}
c0106688:	c9                   	leave  
c0106689:	c3                   	ret    

c010668a <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010668a:	55                   	push   %ebp
c010668b:	89 e5                	mov    %esp,%ebp
c010668d:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106690:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106695:	8b 40 10             	mov    0x10(%eax),%eax
c0106698:	8b 55 14             	mov    0x14(%ebp),%edx
c010669b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010669f:	8b 55 10             	mov    0x10(%ebp),%edx
c01066a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01066a6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066a9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066ad:	8b 55 08             	mov    0x8(%ebp),%edx
c01066b0:	89 14 24             	mov    %edx,(%esp)
c01066b3:	ff d0                	call   *%eax
}
c01066b5:	c9                   	leave  
c01066b6:	c3                   	ret    

c01066b7 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01066b7:	55                   	push   %ebp
c01066b8:	89 e5                	mov    %esp,%ebp
c01066ba:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01066bd:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066c2:	8b 40 14             	mov    0x14(%eax),%eax
c01066c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01066cf:	89 14 24             	mov    %edx,(%esp)
c01066d2:	ff d0                	call   *%eax
}
c01066d4:	c9                   	leave  
c01066d5:	c3                   	ret    

c01066d6 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01066d6:	55                   	push   %ebp
c01066d7:	89 e5                	mov    %esp,%ebp
c01066d9:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01066dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01066e3:	e9 5a 01 00 00       	jmp    c0106842 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01066e8:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066ed:	8b 40 18             	mov    0x18(%eax),%eax
c01066f0:	8b 55 10             	mov    0x10(%ebp),%edx
c01066f3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01066f7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01066fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066fe:	8b 55 08             	mov    0x8(%ebp),%edx
c0106701:	89 14 24             	mov    %edx,(%esp)
c0106704:	ff d0                	call   *%eax
c0106706:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010670d:	74 18                	je     c0106727 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010670f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106716:	c7 04 24 70 b0 10 c0 	movl   $0xc010b070,(%esp)
c010671d:	e8 31 9c ff ff       	call   c0100353 <cprintf>
c0106722:	e9 27 01 00 00       	jmp    c010684e <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010672a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010672d:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106730:	8b 45 08             	mov    0x8(%ebp),%eax
c0106733:	8b 40 0c             	mov    0xc(%eax),%eax
c0106736:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010673d:	00 
c010673e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106741:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106745:	89 04 24             	mov    %eax,(%esp)
c0106748:	e8 17 ed ff ff       	call   c0105464 <get_pte>
c010674d:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106750:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106753:	8b 00                	mov    (%eax),%eax
c0106755:	83 e0 01             	and    $0x1,%eax
c0106758:	85 c0                	test   %eax,%eax
c010675a:	75 24                	jne    c0106780 <swap_out+0xaa>
c010675c:	c7 44 24 0c 9d b0 10 	movl   $0xc010b09d,0xc(%esp)
c0106763:	c0 
c0106764:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c010676b:	c0 
c010676c:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106773:	00 
c0106774:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c010677b:	e8 5c a5 ff ff       	call   c0100cdc <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106786:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106789:	c1 ea 0c             	shr    $0xc,%edx
c010678c:	83 c2 01             	add    $0x1,%edx
c010678f:	c1 e2 08             	shl    $0x8,%edx
c0106792:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106796:	89 14 24             	mov    %edx,(%esp)
c0106799:	e8 2f 1c 00 00       	call   c01083cd <swapfs_write>
c010679e:	85 c0                	test   %eax,%eax
c01067a0:	74 34                	je     c01067d6 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01067a2:	c7 04 24 c7 b0 10 c0 	movl   $0xc010b0c7,(%esp)
c01067a9:	e8 a5 9b ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01067ae:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01067b3:	8b 40 10             	mov    0x10(%eax),%eax
c01067b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067b9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01067c0:	00 
c01067c1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01067c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01067c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01067cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01067cf:	89 14 24             	mov    %edx,(%esp)
c01067d2:	ff d0                	call   *%eax
c01067d4:	eb 68                	jmp    c010683e <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01067d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067d9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01067dc:	c1 e8 0c             	shr    $0xc,%eax
c01067df:	83 c0 01             	add    $0x1,%eax
c01067e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067f4:	c7 04 24 e0 b0 10 c0 	movl   $0xc010b0e0,(%esp)
c01067fb:	e8 53 9b ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106800:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106803:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106806:	c1 e8 0c             	shr    $0xc,%eax
c0106809:	83 c0 01             	add    $0x1,%eax
c010680c:	c1 e0 08             	shl    $0x8,%eax
c010680f:	89 c2                	mov    %eax,%edx
c0106811:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106814:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106816:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106819:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106820:	00 
c0106821:	89 04 24             	mov    %eax,(%esp)
c0106824:	e8 3f e5 ff ff       	call   c0104d68 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106829:	8b 45 08             	mov    0x8(%ebp),%eax
c010682c:	8b 40 0c             	mov    0xc(%eax),%eax
c010682f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106832:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106836:	89 04 24             	mov    %eax,(%esp)
c0106839:	e8 28 ef ff ff       	call   c0105766 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010683e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106842:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106845:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106848:	0f 85 9a fe ff ff    	jne    c01066e8 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010684e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106851:	c9                   	leave  
c0106852:	c3                   	ret    

c0106853 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106853:	55                   	push   %ebp
c0106854:	89 e5                	mov    %esp,%ebp
c0106856:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106860:	e8 98 e4 ff ff       	call   c0104cfd <alloc_pages>
c0106865:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010686c:	75 24                	jne    c0106892 <swap_in+0x3f>
c010686e:	c7 44 24 0c 20 b1 10 	movl   $0xc010b120,0xc(%esp)
c0106875:	c0 
c0106876:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c010687d:	c0 
c010687e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106885:	00 
c0106886:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c010688d:	e8 4a a4 ff ff       	call   c0100cdc <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106892:	8b 45 08             	mov    0x8(%ebp),%eax
c0106895:	8b 40 0c             	mov    0xc(%eax),%eax
c0106898:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010689f:	00 
c01068a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01068a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068a7:	89 04 24             	mov    %eax,(%esp)
c01068aa:	e8 b5 eb ff ff       	call   c0105464 <get_pte>
c01068af:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01068b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068b5:	8b 00                	mov    (%eax),%eax
c01068b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01068ba:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068be:	89 04 24             	mov    %eax,(%esp)
c01068c1:	e8 95 1a 00 00       	call   c010835b <swapfs_read>
c01068c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01068c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01068cd:	74 2a                	je     c01068f9 <swap_in+0xa6>
     {
        assert(r!=0);
c01068cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01068d3:	75 24                	jne    c01068f9 <swap_in+0xa6>
c01068d5:	c7 44 24 0c 2d b1 10 	movl   $0xc010b12d,0xc(%esp)
c01068dc:	c0 
c01068dd:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c01068e4:	c0 
c01068e5:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01068ec:	00 
c01068ed:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c01068f4:	e8 e3 a3 ff ff       	call   c0100cdc <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01068f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01068fc:	8b 00                	mov    (%eax),%eax
c01068fe:	c1 e8 08             	shr    $0x8,%eax
c0106901:	89 c2                	mov    %eax,%edx
c0106903:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106906:	89 44 24 08          	mov    %eax,0x8(%esp)
c010690a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010690e:	c7 04 24 34 b1 10 c0 	movl   $0xc010b134,(%esp)
c0106915:	e8 39 9a ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c010691a:	8b 45 10             	mov    0x10(%ebp),%eax
c010691d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106920:	89 10                	mov    %edx,(%eax)
     return 0;
c0106922:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106927:	c9                   	leave  
c0106928:	c3                   	ret    

c0106929 <check_content_set>:



static inline void
check_content_set(void)
{
c0106929:	55                   	push   %ebp
c010692a:	89 e5                	mov    %esp,%ebp
c010692c:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010692f:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106934:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106937:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010693c:	83 f8 01             	cmp    $0x1,%eax
c010693f:	74 24                	je     c0106965 <check_content_set+0x3c>
c0106941:	c7 44 24 0c 72 b1 10 	movl   $0xc010b172,0xc(%esp)
c0106948:	c0 
c0106949:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106950:	c0 
c0106951:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106958:	00 
c0106959:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106960:	e8 77 a3 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106965:	b8 10 10 00 00       	mov    $0x1010,%eax
c010696a:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010696d:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106972:	83 f8 01             	cmp    $0x1,%eax
c0106975:	74 24                	je     c010699b <check_content_set+0x72>
c0106977:	c7 44 24 0c 72 b1 10 	movl   $0xc010b172,0xc(%esp)
c010697e:	c0 
c010697f:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106986:	c0 
c0106987:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010698e:	00 
c010698f:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106996:	e8 41 a3 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010699b:	b8 00 20 00 00       	mov    $0x2000,%eax
c01069a0:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069a3:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069a8:	83 f8 02             	cmp    $0x2,%eax
c01069ab:	74 24                	je     c01069d1 <check_content_set+0xa8>
c01069ad:	c7 44 24 0c 81 b1 10 	movl   $0xc010b181,0xc(%esp)
c01069b4:	c0 
c01069b5:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c01069bc:	c0 
c01069bd:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01069c4:	00 
c01069c5:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c01069cc:	e8 0b a3 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01069d1:	b8 10 20 00 00       	mov    $0x2010,%eax
c01069d6:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069d9:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069de:	83 f8 02             	cmp    $0x2,%eax
c01069e1:	74 24                	je     c0106a07 <check_content_set+0xde>
c01069e3:	c7 44 24 0c 81 b1 10 	movl   $0xc010b181,0xc(%esp)
c01069ea:	c0 
c01069eb:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c01069f2:	c0 
c01069f3:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01069fa:	00 
c01069fb:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106a02:	e8 d5 a2 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106a07:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106a0c:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a0f:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a14:	83 f8 03             	cmp    $0x3,%eax
c0106a17:	74 24                	je     c0106a3d <check_content_set+0x114>
c0106a19:	c7 44 24 0c 90 b1 10 	movl   $0xc010b190,0xc(%esp)
c0106a20:	c0 
c0106a21:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106a28:	c0 
c0106a29:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106a30:	00 
c0106a31:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106a38:	e8 9f a2 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106a3d:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106a42:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a45:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a4a:	83 f8 03             	cmp    $0x3,%eax
c0106a4d:	74 24                	je     c0106a73 <check_content_set+0x14a>
c0106a4f:	c7 44 24 0c 90 b1 10 	movl   $0xc010b190,0xc(%esp)
c0106a56:	c0 
c0106a57:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106a5e:	c0 
c0106a5f:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106a66:	00 
c0106a67:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106a6e:	e8 69 a2 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106a73:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106a78:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106a7b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a80:	83 f8 04             	cmp    $0x4,%eax
c0106a83:	74 24                	je     c0106aa9 <check_content_set+0x180>
c0106a85:	c7 44 24 0c 9f b1 10 	movl   $0xc010b19f,0xc(%esp)
c0106a8c:	c0 
c0106a8d:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106a94:	c0 
c0106a95:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106a9c:	00 
c0106a9d:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106aa4:	e8 33 a2 ff ff       	call   c0100cdc <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106aa9:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106aae:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106ab1:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ab6:	83 f8 04             	cmp    $0x4,%eax
c0106ab9:	74 24                	je     c0106adf <check_content_set+0x1b6>
c0106abb:	c7 44 24 0c 9f b1 10 	movl   $0xc010b19f,0xc(%esp)
c0106ac2:	c0 
c0106ac3:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106aca:	c0 
c0106acb:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106ad2:	00 
c0106ad3:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106ada:	e8 fd a1 ff ff       	call   c0100cdc <__panic>
}
c0106adf:	c9                   	leave  
c0106ae0:	c3                   	ret    

c0106ae1 <check_content_access>:

static inline int
check_content_access(void)
{
c0106ae1:	55                   	push   %ebp
c0106ae2:	89 e5                	mov    %esp,%ebp
c0106ae4:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106ae7:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106aec:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106aef:	ff d0                	call   *%eax
c0106af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106af7:	c9                   	leave  
c0106af8:	c3                   	ret    

c0106af9 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106af9:	55                   	push   %ebp
c0106afa:	89 e5                	mov    %esp,%ebp
c0106afc:	53                   	push   %ebx
c0106afd:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106b07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106b0e:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b15:	eb 6b                	jmp    c0106b82 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106b17:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b1a:	83 e8 0c             	sub    $0xc,%eax
c0106b1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106b20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b23:	83 c0 04             	add    $0x4,%eax
c0106b26:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106b2d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106b30:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b33:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106b36:	0f a3 10             	bt     %edx,(%eax)
c0106b39:	19 c0                	sbb    %eax,%eax
c0106b3b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106b3e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b42:	0f 95 c0             	setne  %al
c0106b45:	0f b6 c0             	movzbl %al,%eax
c0106b48:	85 c0                	test   %eax,%eax
c0106b4a:	75 24                	jne    c0106b70 <check_swap+0x77>
c0106b4c:	c7 44 24 0c ae b1 10 	movl   $0xc010b1ae,0xc(%esp)
c0106b53:	c0 
c0106b54:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106b5b:	c0 
c0106b5c:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106b63:	00 
c0106b64:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106b6b:	e8 6c a1 ff ff       	call   c0100cdc <__panic>
        count ++, total += p->property;
c0106b70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b77:	8b 50 08             	mov    0x8(%eax),%edx
c0106b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b7d:	01 d0                	add    %edx,%eax
c0106b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b85:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106b88:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106b8b:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106b8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b91:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106b98:	0f 85 79 ff ff ff    	jne    c0106b17 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106b9e:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106ba1:	e8 f4 e1 ff ff       	call   c0104d9a <nr_free_pages>
c0106ba6:	39 c3                	cmp    %eax,%ebx
c0106ba8:	74 24                	je     c0106bce <check_swap+0xd5>
c0106baa:	c7 44 24 0c be b1 10 	movl   $0xc010b1be,0xc(%esp)
c0106bb1:	c0 
c0106bb2:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106bb9:	c0 
c0106bba:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106bc1:	00 
c0106bc2:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106bc9:	e8 0e a1 ff ff       	call   c0100cdc <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bd1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bdc:	c7 04 24 d8 b1 10 c0 	movl   $0xc010b1d8,(%esp)
c0106be3:	e8 6b 97 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106be8:	e8 f7 09 00 00       	call   c01075e4 <mm_create>
c0106bed:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106bf0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106bf4:	75 24                	jne    c0106c1a <check_swap+0x121>
c0106bf6:	c7 44 24 0c fe b1 10 	movl   $0xc010b1fe,0xc(%esp)
c0106bfd:	c0 
c0106bfe:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106c05:	c0 
c0106c06:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106c0d:	00 
c0106c0e:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106c15:	e8 c2 a0 ff ff       	call   c0100cdc <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106c1a:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106c1f:	85 c0                	test   %eax,%eax
c0106c21:	74 24                	je     c0106c47 <check_swap+0x14e>
c0106c23:	c7 44 24 0c 09 b2 10 	movl   $0xc010b209,0xc(%esp)
c0106c2a:	c0 
c0106c2b:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106c32:	c0 
c0106c33:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106c3a:	00 
c0106c3b:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106c42:	e8 95 a0 ff ff       	call   c0100cdc <__panic>

     check_mm_struct = mm;
c0106c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c4a:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106c4f:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c58:	89 50 0c             	mov    %edx,0xc(%eax)
c0106c5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c5e:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c61:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106c64:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c67:	8b 00                	mov    (%eax),%eax
c0106c69:	85 c0                	test   %eax,%eax
c0106c6b:	74 24                	je     c0106c91 <check_swap+0x198>
c0106c6d:	c7 44 24 0c 21 b2 10 	movl   $0xc010b221,0xc(%esp)
c0106c74:	c0 
c0106c75:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106c7c:	c0 
c0106c7d:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106c84:	00 
c0106c85:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106c8c:	e8 4b a0 ff ff       	call   c0100cdc <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106c91:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106c98:	00 
c0106c99:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106ca0:	00 
c0106ca1:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106ca8:	e8 af 09 00 00       	call   c010765c <vma_create>
c0106cad:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106cb0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106cb4:	75 24                	jne    c0106cda <check_swap+0x1e1>
c0106cb6:	c7 44 24 0c 2f b2 10 	movl   $0xc010b22f,0xc(%esp)
c0106cbd:	c0 
c0106cbe:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106cc5:	c0 
c0106cc6:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106ccd:	00 
c0106cce:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106cd5:	e8 02 a0 ff ff       	call   c0100cdc <__panic>

     insert_vma_struct(mm, vma);
c0106cda:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ce4:	89 04 24             	mov    %eax,(%esp)
c0106ce7:	e8 00 0b 00 00       	call   c01077ec <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106cec:	c7 04 24 3c b2 10 c0 	movl   $0xc010b23c,(%esp)
c0106cf3:	e8 5b 96 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106cf8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d02:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d05:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106d0c:	00 
c0106d0d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106d14:	00 
c0106d15:	89 04 24             	mov    %eax,(%esp)
c0106d18:	e8 47 e7 ff ff       	call   c0105464 <get_pte>
c0106d1d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106d20:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106d24:	75 24                	jne    c0106d4a <check_swap+0x251>
c0106d26:	c7 44 24 0c 70 b2 10 	movl   $0xc010b270,0xc(%esp)
c0106d2d:	c0 
c0106d2e:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106d35:	c0 
c0106d36:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106d3d:	00 
c0106d3e:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106d45:	e8 92 9f ff ff       	call   c0100cdc <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106d4a:	c7 04 24 84 b2 10 c0 	movl   $0xc010b284,(%esp)
c0106d51:	e8 fd 95 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106d56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106d5d:	e9 a3 00 00 00       	jmp    c0106e05 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106d62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106d69:	e8 8f df ff ff       	call   c0104cfd <alloc_pages>
c0106d6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d71:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d7b:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106d82:	85 c0                	test   %eax,%eax
c0106d84:	75 24                	jne    c0106daa <check_swap+0x2b1>
c0106d86:	c7 44 24 0c a8 b2 10 	movl   $0xc010b2a8,0xc(%esp)
c0106d8d:	c0 
c0106d8e:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106d95:	c0 
c0106d96:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106d9d:	00 
c0106d9e:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106da5:	e8 32 9f ff ff       	call   c0100cdc <__panic>
          assert(!PageProperty(check_rp[i]));
c0106daa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dad:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106db4:	83 c0 04             	add    $0x4,%eax
c0106db7:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106dbe:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106dc1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106dc4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106dc7:	0f a3 10             	bt     %edx,(%eax)
c0106dca:	19 c0                	sbb    %eax,%eax
c0106dcc:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106dcf:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106dd3:	0f 95 c0             	setne  %al
c0106dd6:	0f b6 c0             	movzbl %al,%eax
c0106dd9:	85 c0                	test   %eax,%eax
c0106ddb:	74 24                	je     c0106e01 <check_swap+0x308>
c0106ddd:	c7 44 24 0c bc b2 10 	movl   $0xc010b2bc,0xc(%esp)
c0106de4:	c0 
c0106de5:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106dec:	c0 
c0106ded:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106df4:	00 
c0106df5:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106dfc:	e8 db 9e ff ff       	call   c0100cdc <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e01:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106e05:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106e09:	0f 8e 53 ff ff ff    	jle    c0106d62 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106e0f:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106e14:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106e1a:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106e1d:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106e20:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106e27:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e2a:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106e2d:	89 50 04             	mov    %edx,0x4(%eax)
c0106e30:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e33:	8b 50 04             	mov    0x4(%eax),%edx
c0106e36:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e39:	89 10                	mov    %edx,(%eax)
c0106e3b:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106e42:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106e45:	8b 40 04             	mov    0x4(%eax),%eax
c0106e48:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106e4b:	0f 94 c0             	sete   %al
c0106e4e:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106e51:	85 c0                	test   %eax,%eax
c0106e53:	75 24                	jne    c0106e79 <check_swap+0x380>
c0106e55:	c7 44 24 0c d7 b2 10 	movl   $0xc010b2d7,0xc(%esp)
c0106e5c:	c0 
c0106e5d:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106e64:	c0 
c0106e65:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106e6c:	00 
c0106e6d:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106e74:	e8 63 9e ff ff       	call   c0100cdc <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106e79:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106e7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106e81:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106e88:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e8b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106e92:	eb 1e                	jmp    c0106eb2 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106e97:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106e9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106ea5:	00 
c0106ea6:	89 04 24             	mov    %eax,(%esp)
c0106ea9:	e8 ba de ff ff       	call   c0104d68 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106eae:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106eb2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106eb6:	7e dc                	jle    c0106e94 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106eb8:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106ebd:	83 f8 04             	cmp    $0x4,%eax
c0106ec0:	74 24                	je     c0106ee6 <check_swap+0x3ed>
c0106ec2:	c7 44 24 0c f0 b2 10 	movl   $0xc010b2f0,0xc(%esp)
c0106ec9:	c0 
c0106eca:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106ed1:	c0 
c0106ed2:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106ed9:	00 
c0106eda:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106ee1:	e8 f6 9d ff ff       	call   c0100cdc <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106ee6:	c7 04 24 14 b3 10 c0 	movl   $0xc010b314,(%esp)
c0106eed:	e8 61 94 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106ef2:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0106ef9:	00 00 00 
     
     check_content_set();
c0106efc:	e8 28 fa ff ff       	call   c0106929 <check_content_set>
     assert( nr_free == 0);         
c0106f01:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f06:	85 c0                	test   %eax,%eax
c0106f08:	74 24                	je     c0106f2e <check_swap+0x435>
c0106f0a:	c7 44 24 0c 3b b3 10 	movl   $0xc010b33b,0xc(%esp)
c0106f11:	c0 
c0106f12:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106f19:	c0 
c0106f1a:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106f21:	00 
c0106f22:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106f29:	e8 ae 9d ff ff       	call   c0100cdc <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f2e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f35:	eb 26                	jmp    c0106f5d <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f3a:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c0106f41:	ff ff ff ff 
c0106f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f48:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c0106f4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f52:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f59:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f5d:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106f61:	7e d4                	jle    c0106f37 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f63:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f6a:	e9 eb 00 00 00       	jmp    c010705a <check_swap+0x561>
         check_ptep[i]=0;
c0106f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f72:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c0106f79:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f80:	83 c0 01             	add    $0x1,%eax
c0106f83:	c1 e0 0c             	shl    $0xc,%eax
c0106f86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106f8d:	00 
c0106f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f92:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106f95:	89 04 24             	mov    %eax,(%esp)
c0106f98:	e8 c7 e4 ff ff       	call   c0105464 <get_pte>
c0106f9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106fa0:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106faa:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0106fb1:	85 c0                	test   %eax,%eax
c0106fb3:	75 24                	jne    c0106fd9 <check_swap+0x4e0>
c0106fb5:	c7 44 24 0c 48 b3 10 	movl   $0xc010b348,0xc(%esp)
c0106fbc:	c0 
c0106fbd:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0106fc4:	c0 
c0106fc5:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106fcc:	00 
c0106fcd:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0106fd4:	e8 03 9d ff ff       	call   c0100cdc <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106fd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fdc:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0106fe3:	8b 00                	mov    (%eax),%eax
c0106fe5:	89 04 24             	mov    %eax,(%esp)
c0106fe8:	e8 9f f5 ff ff       	call   c010658c <pte2page>
c0106fed:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ff0:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c0106ff7:	39 d0                	cmp    %edx,%eax
c0106ff9:	74 24                	je     c010701f <check_swap+0x526>
c0106ffb:	c7 44 24 0c 60 b3 10 	movl   $0xc010b360,0xc(%esp)
c0107002:	c0 
c0107003:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c010700a:	c0 
c010700b:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0107012:	00 
c0107013:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c010701a:	e8 bd 9c ff ff       	call   c0100cdc <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010701f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107022:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107029:	8b 00                	mov    (%eax),%eax
c010702b:	83 e0 01             	and    $0x1,%eax
c010702e:	85 c0                	test   %eax,%eax
c0107030:	75 24                	jne    c0107056 <check_swap+0x55d>
c0107032:	c7 44 24 0c 88 b3 10 	movl   $0xc010b388,0xc(%esp)
c0107039:	c0 
c010703a:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c0107041:	c0 
c0107042:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107049:	00 
c010704a:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c0107051:	e8 86 9c ff ff       	call   c0100cdc <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107056:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010705a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010705e:	0f 8e 0b ff ff ff    	jle    c0106f6f <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0107064:	c7 04 24 a4 b3 10 c0 	movl   $0xc010b3a4,(%esp)
c010706b:	e8 e3 92 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0107070:	e8 6c fa ff ff       	call   c0106ae1 <check_content_access>
c0107075:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0107078:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010707c:	74 24                	je     c01070a2 <check_swap+0x5a9>
c010707e:	c7 44 24 0c ca b3 10 	movl   $0xc010b3ca,0xc(%esp)
c0107085:	c0 
c0107086:	c7 44 24 08 b2 b0 10 	movl   $0xc010b0b2,0x8(%esp)
c010708d:	c0 
c010708e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0107095:	00 
c0107096:	c7 04 24 4c b0 10 c0 	movl   $0xc010b04c,(%esp)
c010709d:	e8 3a 9c ff ff       	call   c0100cdc <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01070a9:	eb 1e                	jmp    c01070c9 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01070ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070ae:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c01070b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01070bc:	00 
c01070bd:	89 04 24             	mov    %eax,(%esp)
c01070c0:	e8 a3 dc ff ff       	call   c0104d68 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070c5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01070c9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01070cd:	7e dc                	jle    c01070ab <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01070cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01070d2:	89 04 24             	mov    %eax,(%esp)
c01070d5:	e8 42 08 00 00       	call   c010791c <mm_destroy>
         
     nr_free = nr_free_store;
c01070da:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01070dd:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c01070e2:	8b 45 98             	mov    -0x68(%ebp),%eax
c01070e5:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01070e8:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c01070ed:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c01070f3:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01070fa:	eb 1d                	jmp    c0107119 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c01070fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01070ff:	83 e8 0c             	sub    $0xc,%eax
c0107102:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107105:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107109:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010710c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010710f:	8b 40 08             	mov    0x8(%eax),%eax
c0107112:	29 c2                	sub    %eax,%edx
c0107114:	89 d0                	mov    %edx,%eax
c0107116:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107119:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010711c:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010711f:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107122:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107125:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107128:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c010712f:	75 cb                	jne    c01070fc <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107134:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107138:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010713b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010713f:	c7 04 24 d1 b3 10 c0 	movl   $0xc010b3d1,(%esp)
c0107146:	e8 08 92 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010714b:	c7 04 24 eb b3 10 c0 	movl   $0xc010b3eb,(%esp)
c0107152:	e8 fc 91 ff ff       	call   c0100353 <cprintf>
}
c0107157:	83 c4 74             	add    $0x74,%esp
c010715a:	5b                   	pop    %ebx
c010715b:	5d                   	pop    %ebp
c010715c:	c3                   	ret    

c010715d <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010715d:	55                   	push   %ebp
c010715e:	89 e5                	mov    %esp,%ebp
c0107160:	83 ec 10             	sub    $0x10,%esp
c0107163:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010716a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010716d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107170:	89 50 04             	mov    %edx,0x4(%eax)
c0107173:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107176:	8b 50 04             	mov    0x4(%eax),%edx
c0107179:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010717c:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010717e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107181:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107188:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010718d:	c9                   	leave  
c010718e:	c3                   	ret    

c010718f <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010718f:	55                   	push   %ebp
c0107190:	89 e5                	mov    %esp,%ebp
c0107192:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107195:	8b 45 08             	mov    0x8(%ebp),%eax
c0107198:	8b 40 14             	mov    0x14(%eax),%eax
c010719b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c010719e:	8b 45 10             	mov    0x10(%ebp),%eax
c01071a1:	83 c0 14             	add    $0x14,%eax
c01071a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01071a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01071ab:	74 06                	je     c01071b3 <_fifo_map_swappable+0x24>
c01071ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01071b1:	75 24                	jne    c01071d7 <_fifo_map_swappable+0x48>
c01071b3:	c7 44 24 0c 04 b4 10 	movl   $0xc010b404,0xc(%esp)
c01071ba:	c0 
c01071bb:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c01071c2:	c0 
c01071c3:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01071ca:	00 
c01071cb:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c01071d2:	e8 05 9b ff ff       	call   c0100cdc <__panic>
c01071d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01071da:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01071dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01071e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01071e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01071e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01071ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01071ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01071f2:	8b 40 04             	mov    0x4(%eax),%eax
c01071f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01071f8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01071fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01071fe:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0107201:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107204:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107207:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010720a:	89 10                	mov    %edx,(%eax)
c010720c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010720f:	8b 10                	mov    (%eax),%edx
c0107211:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107214:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107217:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010721a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010721d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107220:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107223:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107226:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2013011303*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head,entry);
    return 0;
c0107228:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010722d:	c9                   	leave  
c010722e:	c3                   	ret    

c010722f <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c010722f:	55                   	push   %ebp
c0107230:	89 e5                	mov    %esp,%ebp
c0107232:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107235:	8b 45 08             	mov    0x8(%ebp),%eax
c0107238:	8b 40 14             	mov    0x14(%eax),%eax
c010723b:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c010723e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107242:	75 24                	jne    c0107268 <_fifo_swap_out_victim+0x39>
c0107244:	c7 44 24 0c 4b b4 10 	movl   $0xc010b44b,0xc(%esp)
c010724b:	c0 
c010724c:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107253:	c0 
c0107254:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c010725b:	00 
c010725c:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0107263:	e8 74 9a ff ff       	call   c0100cdc <__panic>
     assert(in_tick==0);
c0107268:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010726c:	74 24                	je     c0107292 <_fifo_swap_out_victim+0x63>
c010726e:	c7 44 24 0c 58 b4 10 	movl   $0xc010b458,0xc(%esp)
c0107275:	c0 
c0107276:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c010727d:	c0 
c010727e:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107285:	00 
c0107286:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c010728d:	e8 4a 9a ff ff       	call   c0100cdc <__panic>
c0107292:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107295:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0107298:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010729b:	8b 00                	mov    (%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2013011303*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *entry = list_prev(head);
c010729d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(entry, pra_page_link);
c01072a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072a3:	83 e8 14             	sub    $0x14,%eax
c01072a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01072af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072b2:	8b 40 04             	mov    0x4(%eax),%eax
c01072b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01072b8:	8b 12                	mov    (%edx),%edx
c01072ba:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01072bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01072c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072c3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01072c6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01072c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01072cf:	89 10                	mov    %edx,(%eax)
     list_del(entry);
     *ptr_page = page;
c01072d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01072d7:	89 10                	mov    %edx,(%eax)
     return 0;
c01072d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01072de:	c9                   	leave  
c01072df:	c3                   	ret    

c01072e0 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01072e0:	55                   	push   %ebp
c01072e1:	89 e5                	mov    %esp,%ebp
c01072e3:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01072e6:	c7 04 24 64 b4 10 c0 	movl   $0xc010b464,(%esp)
c01072ed:	e8 61 90 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01072f2:	b8 00 30 00 00       	mov    $0x3000,%eax
c01072f7:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01072fa:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01072ff:	83 f8 04             	cmp    $0x4,%eax
c0107302:	74 24                	je     c0107328 <_fifo_check_swap+0x48>
c0107304:	c7 44 24 0c 8a b4 10 	movl   $0xc010b48a,0xc(%esp)
c010730b:	c0 
c010730c:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107313:	c0 
c0107314:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c010731b:	00 
c010731c:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0107323:	e8 b4 99 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107328:	c7 04 24 9c b4 10 c0 	movl   $0xc010b49c,(%esp)
c010732f:	e8 1f 90 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107334:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107339:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010733c:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107341:	83 f8 04             	cmp    $0x4,%eax
c0107344:	74 24                	je     c010736a <_fifo_check_swap+0x8a>
c0107346:	c7 44 24 0c 8a b4 10 	movl   $0xc010b48a,0xc(%esp)
c010734d:	c0 
c010734e:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107355:	c0 
c0107356:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010735d:	00 
c010735e:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0107365:	e8 72 99 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c010736a:	c7 04 24 c4 b4 10 c0 	movl   $0xc010b4c4,(%esp)
c0107371:	e8 dd 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107376:	b8 00 40 00 00       	mov    $0x4000,%eax
c010737b:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c010737e:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107383:	83 f8 04             	cmp    $0x4,%eax
c0107386:	74 24                	je     c01073ac <_fifo_check_swap+0xcc>
c0107388:	c7 44 24 0c 8a b4 10 	movl   $0xc010b48a,0xc(%esp)
c010738f:	c0 
c0107390:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107397:	c0 
c0107398:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c010739f:	00 
c01073a0:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c01073a7:	e8 30 99 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01073ac:	c7 04 24 ec b4 10 c0 	movl   $0xc010b4ec,(%esp)
c01073b3:	e8 9b 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01073b8:	b8 00 20 00 00       	mov    $0x2000,%eax
c01073bd:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01073c0:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073c5:	83 f8 04             	cmp    $0x4,%eax
c01073c8:	74 24                	je     c01073ee <_fifo_check_swap+0x10e>
c01073ca:	c7 44 24 0c 8a b4 10 	movl   $0xc010b48a,0xc(%esp)
c01073d1:	c0 
c01073d2:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c01073d9:	c0 
c01073da:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01073e1:	00 
c01073e2:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c01073e9:	e8 ee 98 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01073ee:	c7 04 24 14 b5 10 c0 	movl   $0xc010b514,(%esp)
c01073f5:	e8 59 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01073fa:	b8 00 50 00 00       	mov    $0x5000,%eax
c01073ff:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107402:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107407:	83 f8 05             	cmp    $0x5,%eax
c010740a:	74 24                	je     c0107430 <_fifo_check_swap+0x150>
c010740c:	c7 44 24 0c 3a b5 10 	movl   $0xc010b53a,0xc(%esp)
c0107413:	c0 
c0107414:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c010741b:	c0 
c010741c:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107423:	00 
c0107424:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c010742b:	e8 ac 98 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107430:	c7 04 24 ec b4 10 c0 	movl   $0xc010b4ec,(%esp)
c0107437:	e8 17 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010743c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107441:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107444:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107449:	83 f8 05             	cmp    $0x5,%eax
c010744c:	74 24                	je     c0107472 <_fifo_check_swap+0x192>
c010744e:	c7 44 24 0c 3a b5 10 	movl   $0xc010b53a,0xc(%esp)
c0107455:	c0 
c0107456:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c010745d:	c0 
c010745e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0107465:	00 
c0107466:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c010746d:	e8 6a 98 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107472:	c7 04 24 9c b4 10 c0 	movl   $0xc010b49c,(%esp)
c0107479:	e8 d5 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010747e:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107483:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107486:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010748b:	83 f8 06             	cmp    $0x6,%eax
c010748e:	74 24                	je     c01074b4 <_fifo_check_swap+0x1d4>
c0107490:	c7 44 24 0c 49 b5 10 	movl   $0xc010b549,0xc(%esp)
c0107497:	c0 
c0107498:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c010749f:	c0 
c01074a0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01074a7:	00 
c01074a8:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c01074af:	e8 28 98 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01074b4:	c7 04 24 ec b4 10 c0 	movl   $0xc010b4ec,(%esp)
c01074bb:	e8 93 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01074c0:	b8 00 20 00 00       	mov    $0x2000,%eax
c01074c5:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01074c8:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074cd:	83 f8 07             	cmp    $0x7,%eax
c01074d0:	74 24                	je     c01074f6 <_fifo_check_swap+0x216>
c01074d2:	c7 44 24 0c 58 b5 10 	movl   $0xc010b558,0xc(%esp)
c01074d9:	c0 
c01074da:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c01074e1:	c0 
c01074e2:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01074e9:	00 
c01074ea:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c01074f1:	e8 e6 97 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c01074f6:	c7 04 24 64 b4 10 c0 	movl   $0xc010b464,(%esp)
c01074fd:	e8 51 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107502:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107507:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c010750a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010750f:	83 f8 08             	cmp    $0x8,%eax
c0107512:	74 24                	je     c0107538 <_fifo_check_swap+0x258>
c0107514:	c7 44 24 0c 67 b5 10 	movl   $0xc010b567,0xc(%esp)
c010751b:	c0 
c010751c:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107523:	c0 
c0107524:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010752b:	00 
c010752c:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0107533:	e8 a4 97 ff ff       	call   c0100cdc <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107538:	c7 04 24 c4 b4 10 c0 	movl   $0xc010b4c4,(%esp)
c010753f:	e8 0f 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107544:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107549:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010754c:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107551:	83 f8 09             	cmp    $0x9,%eax
c0107554:	74 24                	je     c010757a <_fifo_check_swap+0x29a>
c0107556:	c7 44 24 0c 76 b5 10 	movl   $0xc010b576,0xc(%esp)
c010755d:	c0 
c010755e:	c7 44 24 08 22 b4 10 	movl   $0xc010b422,0x8(%esp)
c0107565:	c0 
c0107566:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010756d:	00 
c010756e:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0107575:	e8 62 97 ff ff       	call   c0100cdc <__panic>
    return 0;
c010757a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010757f:	c9                   	leave  
c0107580:	c3                   	ret    

c0107581 <_fifo_init>:


static int
_fifo_init(void)
{
c0107581:	55                   	push   %ebp
c0107582:	89 e5                	mov    %esp,%ebp
    return 0;
c0107584:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107589:	5d                   	pop    %ebp
c010758a:	c3                   	ret    

c010758b <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010758b:	55                   	push   %ebp
c010758c:	89 e5                	mov    %esp,%ebp
    return 0;
c010758e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107593:	5d                   	pop    %ebp
c0107594:	c3                   	ret    

c0107595 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107595:	55                   	push   %ebp
c0107596:	89 e5                	mov    %esp,%ebp
c0107598:	b8 00 00 00 00       	mov    $0x0,%eax
c010759d:	5d                   	pop    %ebp
c010759e:	c3                   	ret    

c010759f <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010759f:	55                   	push   %ebp
c01075a0:	89 e5                	mov    %esp,%ebp
c01075a2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01075a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01075a8:	c1 e8 0c             	shr    $0xc,%eax
c01075ab:	89 c2                	mov    %eax,%edx
c01075ad:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01075b2:	39 c2                	cmp    %eax,%edx
c01075b4:	72 1c                	jb     c01075d2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01075b6:	c7 44 24 08 98 b5 10 	movl   $0xc010b598,0x8(%esp)
c01075bd:	c0 
c01075be:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01075c5:	00 
c01075c6:	c7 04 24 b7 b5 10 c0 	movl   $0xc010b5b7,(%esp)
c01075cd:	e8 0a 97 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c01075d2:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01075d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01075da:	c1 ea 0c             	shr    $0xc,%edx
c01075dd:	c1 e2 05             	shl    $0x5,%edx
c01075e0:	01 d0                	add    %edx,%eax
}
c01075e2:	c9                   	leave  
c01075e3:	c3                   	ret    

c01075e4 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01075e4:	55                   	push   %ebp
c01075e5:	89 e5                	mov    %esp,%ebp
c01075e7:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01075ea:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01075f1:	e8 aa d2 ff ff       	call   c01048a0 <kmalloc>
c01075f6:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01075f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01075fd:	74 58                	je     c0107657 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01075ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107602:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107605:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107608:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010760b:	89 50 04             	mov    %edx,0x4(%eax)
c010760e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107611:	8b 50 04             	mov    0x4(%eax),%edx
c0107614:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107617:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107619:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010761c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107626:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010762d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107630:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107637:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010763c:	85 c0                	test   %eax,%eax
c010763e:	74 0d                	je     c010764d <mm_create+0x69>
c0107640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107643:	89 04 24             	mov    %eax,(%esp)
c0107646:	e8 0f f0 ff ff       	call   c010665a <swap_init_mm>
c010764b:	eb 0a                	jmp    c0107657 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010764d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107650:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107657:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010765a:	c9                   	leave  
c010765b:	c3                   	ret    

c010765c <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010765c:	55                   	push   %ebp
c010765d:	89 e5                	mov    %esp,%ebp
c010765f:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107662:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107669:	e8 32 d2 ff ff       	call   c01048a0 <kmalloc>
c010766e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107671:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107675:	74 1b                	je     c0107692 <vma_create+0x36>
        vma->vm_start = vm_start;
c0107677:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010767a:	8b 55 08             	mov    0x8(%ebp),%edx
c010767d:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107683:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107686:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768c:	8b 55 10             	mov    0x10(%ebp),%edx
c010768f:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107692:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107695:	c9                   	leave  
c0107696:	c3                   	ret    

c0107697 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107697:	55                   	push   %ebp
c0107698:	89 e5                	mov    %esp,%ebp
c010769a:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c010769d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01076a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01076a8:	0f 84 95 00 00 00    	je     c0107743 <find_vma+0xac>
        vma = mm->mmap_cache;
c01076ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01076b1:	8b 40 08             	mov    0x8(%eax),%eax
c01076b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01076b7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01076bb:	74 16                	je     c01076d3 <find_vma+0x3c>
c01076bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076c0:	8b 40 04             	mov    0x4(%eax),%eax
c01076c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076c6:	77 0b                	ja     c01076d3 <find_vma+0x3c>
c01076c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076cb:	8b 40 08             	mov    0x8(%eax),%eax
c01076ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076d1:	77 61                	ja     c0107734 <find_vma+0x9d>
                bool found = 0;
c01076d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01076da:	8b 45 08             	mov    0x8(%ebp),%eax
c01076dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01076e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01076e6:	eb 28                	jmp    c0107710 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01076e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076eb:	83 e8 10             	sub    $0x10,%eax
c01076ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01076f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076f4:	8b 40 04             	mov    0x4(%eax),%eax
c01076f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01076fa:	77 14                	ja     c0107710 <find_vma+0x79>
c01076fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076ff:	8b 40 08             	mov    0x8(%eax),%eax
c0107702:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107705:	76 09                	jbe    c0107710 <find_vma+0x79>
                        found = 1;
c0107707:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010770e:	eb 17                	jmp    c0107727 <find_vma+0x90>
c0107710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107713:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107716:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107719:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010771c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010771f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107722:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107725:	75 c1                	jne    c01076e8 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107727:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010772b:	75 07                	jne    c0107734 <find_vma+0x9d>
                    vma = NULL;
c010772d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107734:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107738:	74 09                	je     c0107743 <find_vma+0xac>
            mm->mmap_cache = vma;
c010773a:	8b 45 08             	mov    0x8(%ebp),%eax
c010773d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107740:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107743:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107746:	c9                   	leave  
c0107747:	c3                   	ret    

c0107748 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107748:	55                   	push   %ebp
c0107749:	89 e5                	mov    %esp,%ebp
c010774b:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010774e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107751:	8b 50 04             	mov    0x4(%eax),%edx
c0107754:	8b 45 08             	mov    0x8(%ebp),%eax
c0107757:	8b 40 08             	mov    0x8(%eax),%eax
c010775a:	39 c2                	cmp    %eax,%edx
c010775c:	72 24                	jb     c0107782 <check_vma_overlap+0x3a>
c010775e:	c7 44 24 0c c5 b5 10 	movl   $0xc010b5c5,0xc(%esp)
c0107765:	c0 
c0107766:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c010776d:	c0 
c010776e:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107775:	00 
c0107776:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c010777d:	e8 5a 95 ff ff       	call   c0100cdc <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107782:	8b 45 08             	mov    0x8(%ebp),%eax
c0107785:	8b 50 08             	mov    0x8(%eax),%edx
c0107788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010778b:	8b 40 04             	mov    0x4(%eax),%eax
c010778e:	39 c2                	cmp    %eax,%edx
c0107790:	76 24                	jbe    c01077b6 <check_vma_overlap+0x6e>
c0107792:	c7 44 24 0c 08 b6 10 	movl   $0xc010b608,0xc(%esp)
c0107799:	c0 
c010779a:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c01077a1:	c0 
c01077a2:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01077a9:	00 
c01077aa:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c01077b1:	e8 26 95 ff ff       	call   c0100cdc <__panic>
    assert(next->vm_start < next->vm_end);
c01077b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077b9:	8b 50 04             	mov    0x4(%eax),%edx
c01077bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077bf:	8b 40 08             	mov    0x8(%eax),%eax
c01077c2:	39 c2                	cmp    %eax,%edx
c01077c4:	72 24                	jb     c01077ea <check_vma_overlap+0xa2>
c01077c6:	c7 44 24 0c 27 b6 10 	movl   $0xc010b627,0xc(%esp)
c01077cd:	c0 
c01077ce:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c01077d5:	c0 
c01077d6:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01077dd:	00 
c01077de:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c01077e5:	e8 f2 94 ff ff       	call   c0100cdc <__panic>
}
c01077ea:	c9                   	leave  
c01077eb:	c3                   	ret    

c01077ec <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01077ec:	55                   	push   %ebp
c01077ed:	89 e5                	mov    %esp,%ebp
c01077ef:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01077f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077f5:	8b 50 04             	mov    0x4(%eax),%edx
c01077f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077fb:	8b 40 08             	mov    0x8(%eax),%eax
c01077fe:	39 c2                	cmp    %eax,%edx
c0107800:	72 24                	jb     c0107826 <insert_vma_struct+0x3a>
c0107802:	c7 44 24 0c 45 b6 10 	movl   $0xc010b645,0xc(%esp)
c0107809:	c0 
c010780a:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107811:	c0 
c0107812:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0107819:	00 
c010781a:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107821:	e8 b6 94 ff ff       	call   c0100cdc <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107826:	8b 45 08             	mov    0x8(%ebp),%eax
c0107829:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010782c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010782f:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107832:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107835:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107838:	eb 21                	jmp    c010785b <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010783a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010783d:	83 e8 10             	sub    $0x10,%eax
c0107840:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107843:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107846:	8b 50 04             	mov    0x4(%eax),%edx
c0107849:	8b 45 0c             	mov    0xc(%ebp),%eax
c010784c:	8b 40 04             	mov    0x4(%eax),%eax
c010784f:	39 c2                	cmp    %eax,%edx
c0107851:	76 02                	jbe    c0107855 <insert_vma_struct+0x69>
                break;
c0107853:	eb 1d                	jmp    c0107872 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107855:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107858:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010785b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010785e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107861:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107864:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107867:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010786a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010786d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107870:	75 c8                	jne    c010783a <insert_vma_struct+0x4e>
c0107872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107875:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107878:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010787b:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c010787e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107881:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107884:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107887:	74 15                	je     c010789e <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107889:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010788c:	8d 50 f0             	lea    -0x10(%eax),%edx
c010788f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107892:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107896:	89 14 24             	mov    %edx,(%esp)
c0107899:	e8 aa fe ff ff       	call   c0107748 <check_vma_overlap>
    }
    if (le_next != list) {
c010789e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078a4:	74 15                	je     c01078bb <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01078a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078a9:	83 e8 10             	sub    $0x10,%eax
c01078ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078b3:	89 04 24             	mov    %eax,(%esp)
c01078b6:	e8 8d fe ff ff       	call   c0107748 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01078bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078be:	8b 55 08             	mov    0x8(%ebp),%edx
c01078c1:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01078c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078c6:	8d 50 10             	lea    0x10(%eax),%edx
c01078c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01078cf:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01078d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01078d5:	8b 40 04             	mov    0x4(%eax),%eax
c01078d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01078db:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01078de:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01078e1:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01078e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01078e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01078ea:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01078ed:	89 10                	mov    %edx,(%eax)
c01078ef:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01078f2:	8b 10                	mov    (%eax),%edx
c01078f4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01078f7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01078fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01078fd:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107900:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107903:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107906:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107909:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010790b:	8b 45 08             	mov    0x8(%ebp),%eax
c010790e:	8b 40 10             	mov    0x10(%eax),%eax
c0107911:	8d 50 01             	lea    0x1(%eax),%edx
c0107914:	8b 45 08             	mov    0x8(%ebp),%eax
c0107917:	89 50 10             	mov    %edx,0x10(%eax)
}
c010791a:	c9                   	leave  
c010791b:	c3                   	ret    

c010791c <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010791c:	55                   	push   %ebp
c010791d:	89 e5                	mov    %esp,%ebp
c010791f:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107922:	8b 45 08             	mov    0x8(%ebp),%eax
c0107925:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107928:	eb 36                	jmp    c0107960 <mm_destroy+0x44>
c010792a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010792d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107930:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107933:	8b 40 04             	mov    0x4(%eax),%eax
c0107936:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107939:	8b 12                	mov    (%edx),%edx
c010793b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010793e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107941:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107944:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107947:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010794a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010794d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107950:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107952:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107955:	83 e8 10             	sub    $0x10,%eax
c0107958:	89 04 24             	mov    %eax,(%esp)
c010795b:	e8 5b cf ff ff       	call   c01048bb <kfree>
c0107960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107963:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107966:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107969:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010796c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010796f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107972:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107975:	75 b3                	jne    c010792a <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107977:	8b 45 08             	mov    0x8(%ebp),%eax
c010797a:	89 04 24             	mov    %eax,(%esp)
c010797d:	e8 39 cf ff ff       	call   c01048bb <kfree>
    mm=NULL;
c0107982:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107989:	c9                   	leave  
c010798a:	c3                   	ret    

c010798b <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c010798b:	55                   	push   %ebp
c010798c:	89 e5                	mov    %esp,%ebp
c010798e:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107991:	e8 02 00 00 00       	call   c0107998 <check_vmm>
}
c0107996:	c9                   	leave  
c0107997:	c3                   	ret    

c0107998 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107998:	55                   	push   %ebp
c0107999:	89 e5                	mov    %esp,%ebp
c010799b:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010799e:	e8 f7 d3 ff ff       	call   c0104d9a <nr_free_pages>
c01079a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01079a6:	e8 13 00 00 00       	call   c01079be <check_vma_struct>
    check_pgfault();
c01079ab:	e8 a7 04 00 00       	call   c0107e57 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c01079b0:	c7 04 24 61 b6 10 c0 	movl   $0xc010b661,(%esp)
c01079b7:	e8 97 89 ff ff       	call   c0100353 <cprintf>
}
c01079bc:	c9                   	leave  
c01079bd:	c3                   	ret    

c01079be <check_vma_struct>:

static void
check_vma_struct(void) {
c01079be:	55                   	push   %ebp
c01079bf:	89 e5                	mov    %esp,%ebp
c01079c1:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01079c4:	e8 d1 d3 ff ff       	call   c0104d9a <nr_free_pages>
c01079c9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01079cc:	e8 13 fc ff ff       	call   c01075e4 <mm_create>
c01079d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01079d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01079d8:	75 24                	jne    c01079fe <check_vma_struct+0x40>
c01079da:	c7 44 24 0c 79 b6 10 	movl   $0xc010b679,0xc(%esp)
c01079e1:	c0 
c01079e2:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c01079e9:	c0 
c01079ea:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01079f1:	00 
c01079f2:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c01079f9:	e8 de 92 ff ff       	call   c0100cdc <__panic>

    int step1 = 10, step2 = step1 * 10;
c01079fe:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107a05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a08:	89 d0                	mov    %edx,%eax
c0107a0a:	c1 e0 02             	shl    $0x2,%eax
c0107a0d:	01 d0                	add    %edx,%eax
c0107a0f:	01 c0                	add    %eax,%eax
c0107a11:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a1a:	eb 70                	jmp    c0107a8c <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a1f:	89 d0                	mov    %edx,%eax
c0107a21:	c1 e0 02             	shl    $0x2,%eax
c0107a24:	01 d0                	add    %edx,%eax
c0107a26:	83 c0 02             	add    $0x2,%eax
c0107a29:	89 c1                	mov    %eax,%ecx
c0107a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a2e:	89 d0                	mov    %edx,%eax
c0107a30:	c1 e0 02             	shl    $0x2,%eax
c0107a33:	01 d0                	add    %edx,%eax
c0107a35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a3c:	00 
c0107a3d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107a41:	89 04 24             	mov    %eax,(%esp)
c0107a44:	e8 13 fc ff ff       	call   c010765c <vma_create>
c0107a49:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107a4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107a50:	75 24                	jne    c0107a76 <check_vma_struct+0xb8>
c0107a52:	c7 44 24 0c 84 b6 10 	movl   $0xc010b684,0xc(%esp)
c0107a59:	c0 
c0107a5a:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107a61:	c0 
c0107a62:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107a69:	00 
c0107a6a:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107a71:	e8 66 92 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c0107a76:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a80:	89 04 24             	mov    %eax,(%esp)
c0107a83:	e8 64 fd ff ff       	call   c01077ec <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107a88:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a90:	7f 8a                	jg     c0107a1c <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a95:	83 c0 01             	add    $0x1,%eax
c0107a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a9b:	eb 70                	jmp    c0107b0d <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107aa0:	89 d0                	mov    %edx,%eax
c0107aa2:	c1 e0 02             	shl    $0x2,%eax
c0107aa5:	01 d0                	add    %edx,%eax
c0107aa7:	83 c0 02             	add    $0x2,%eax
c0107aaa:	89 c1                	mov    %eax,%ecx
c0107aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107aaf:	89 d0                	mov    %edx,%eax
c0107ab1:	c1 e0 02             	shl    $0x2,%eax
c0107ab4:	01 d0                	add    %edx,%eax
c0107ab6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107abd:	00 
c0107abe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107ac2:	89 04 24             	mov    %eax,(%esp)
c0107ac5:	e8 92 fb ff ff       	call   c010765c <vma_create>
c0107aca:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107acd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107ad1:	75 24                	jne    c0107af7 <check_vma_struct+0x139>
c0107ad3:	c7 44 24 0c 84 b6 10 	movl   $0xc010b684,0xc(%esp)
c0107ada:	c0 
c0107adb:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107ae2:	c0 
c0107ae3:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107aea:	00 
c0107aeb:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107af2:	e8 e5 91 ff ff       	call   c0100cdc <__panic>
        insert_vma_struct(mm, vma);
c0107af7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107afa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b01:	89 04 24             	mov    %eax,(%esp)
c0107b04:	e8 e3 fc ff ff       	call   c01077ec <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b10:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b13:	7e 88                	jle    c0107a9d <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b18:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107b1b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107b1e:	8b 40 04             	mov    0x4(%eax),%eax
c0107b21:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107b24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107b2b:	e9 97 00 00 00       	jmp    c0107bc7 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b33:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107b36:	75 24                	jne    c0107b5c <check_vma_struct+0x19e>
c0107b38:	c7 44 24 0c 90 b6 10 	movl   $0xc010b690,0xc(%esp)
c0107b3f:	c0 
c0107b40:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107b47:	c0 
c0107b48:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107b4f:	00 
c0107b50:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107b57:	e8 80 91 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b5f:	83 e8 10             	sub    $0x10,%eax
c0107b62:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107b65:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107b68:	8b 48 04             	mov    0x4(%eax),%ecx
c0107b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b6e:	89 d0                	mov    %edx,%eax
c0107b70:	c1 e0 02             	shl    $0x2,%eax
c0107b73:	01 d0                	add    %edx,%eax
c0107b75:	39 c1                	cmp    %eax,%ecx
c0107b77:	75 17                	jne    c0107b90 <check_vma_struct+0x1d2>
c0107b79:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107b7c:	8b 48 08             	mov    0x8(%eax),%ecx
c0107b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107b82:	89 d0                	mov    %edx,%eax
c0107b84:	c1 e0 02             	shl    $0x2,%eax
c0107b87:	01 d0                	add    %edx,%eax
c0107b89:	83 c0 02             	add    $0x2,%eax
c0107b8c:	39 c1                	cmp    %eax,%ecx
c0107b8e:	74 24                	je     c0107bb4 <check_vma_struct+0x1f6>
c0107b90:	c7 44 24 0c a8 b6 10 	movl   $0xc010b6a8,0xc(%esp)
c0107b97:	c0 
c0107b98:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107b9f:	c0 
c0107ba0:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107ba7:	00 
c0107ba8:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107baf:	e8 28 91 ff ff       	call   c0100cdc <__panic>
c0107bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bb7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107bba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107bbd:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107bc3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bca:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107bcd:	0f 8e 5d ff ff ff    	jle    c0107b30 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107bd3:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107bda:	e9 cd 01 00 00       	jmp    c0107dac <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107be2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107be9:	89 04 24             	mov    %eax,(%esp)
c0107bec:	e8 a6 fa ff ff       	call   c0107697 <find_vma>
c0107bf1:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107bf4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107bf8:	75 24                	jne    c0107c1e <check_vma_struct+0x260>
c0107bfa:	c7 44 24 0c dd b6 10 	movl   $0xc010b6dd,0xc(%esp)
c0107c01:	c0 
c0107c02:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107c09:	c0 
c0107c0a:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107c11:	00 
c0107c12:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107c19:	e8 be 90 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c21:	83 c0 01             	add    $0x1,%eax
c0107c24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c2b:	89 04 24             	mov    %eax,(%esp)
c0107c2e:	e8 64 fa ff ff       	call   c0107697 <find_vma>
c0107c33:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107c36:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107c3a:	75 24                	jne    c0107c60 <check_vma_struct+0x2a2>
c0107c3c:	c7 44 24 0c ea b6 10 	movl   $0xc010b6ea,0xc(%esp)
c0107c43:	c0 
c0107c44:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107c4b:	c0 
c0107c4c:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107c53:	00 
c0107c54:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107c5b:	e8 7c 90 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c63:	83 c0 02             	add    $0x2,%eax
c0107c66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c6d:	89 04 24             	mov    %eax,(%esp)
c0107c70:	e8 22 fa ff ff       	call   c0107697 <find_vma>
c0107c75:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107c78:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107c7c:	74 24                	je     c0107ca2 <check_vma_struct+0x2e4>
c0107c7e:	c7 44 24 0c f7 b6 10 	movl   $0xc010b6f7,0xc(%esp)
c0107c85:	c0 
c0107c86:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107c8d:	c0 
c0107c8e:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107c95:	00 
c0107c96:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107c9d:	e8 3a 90 ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ca5:	83 c0 03             	add    $0x3,%eax
c0107ca8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107caf:	89 04 24             	mov    %eax,(%esp)
c0107cb2:	e8 e0 f9 ff ff       	call   c0107697 <find_vma>
c0107cb7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107cba:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107cbe:	74 24                	je     c0107ce4 <check_vma_struct+0x326>
c0107cc0:	c7 44 24 0c 04 b7 10 	movl   $0xc010b704,0xc(%esp)
c0107cc7:	c0 
c0107cc8:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107ccf:	c0 
c0107cd0:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107cd7:	00 
c0107cd8:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107cdf:	e8 f8 8f ff ff       	call   c0100cdc <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ce7:	83 c0 04             	add    $0x4,%eax
c0107cea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cf1:	89 04 24             	mov    %eax,(%esp)
c0107cf4:	e8 9e f9 ff ff       	call   c0107697 <find_vma>
c0107cf9:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107cfc:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107d00:	74 24                	je     c0107d26 <check_vma_struct+0x368>
c0107d02:	c7 44 24 0c 11 b7 10 	movl   $0xc010b711,0xc(%esp)
c0107d09:	c0 
c0107d0a:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107d11:	c0 
c0107d12:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107d19:	00 
c0107d1a:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107d21:	e8 b6 8f ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107d26:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d29:	8b 50 04             	mov    0x4(%eax),%edx
c0107d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d2f:	39 c2                	cmp    %eax,%edx
c0107d31:	75 10                	jne    c0107d43 <check_vma_struct+0x385>
c0107d33:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d36:	8b 50 08             	mov    0x8(%eax),%edx
c0107d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d3c:	83 c0 02             	add    $0x2,%eax
c0107d3f:	39 c2                	cmp    %eax,%edx
c0107d41:	74 24                	je     c0107d67 <check_vma_struct+0x3a9>
c0107d43:	c7 44 24 0c 20 b7 10 	movl   $0xc010b720,0xc(%esp)
c0107d4a:	c0 
c0107d4b:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107d52:	c0 
c0107d53:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107d5a:	00 
c0107d5b:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107d62:	e8 75 8f ff ff       	call   c0100cdc <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107d67:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107d6a:	8b 50 04             	mov    0x4(%eax),%edx
c0107d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d70:	39 c2                	cmp    %eax,%edx
c0107d72:	75 10                	jne    c0107d84 <check_vma_struct+0x3c6>
c0107d74:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107d77:	8b 50 08             	mov    0x8(%eax),%edx
c0107d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d7d:	83 c0 02             	add    $0x2,%eax
c0107d80:	39 c2                	cmp    %eax,%edx
c0107d82:	74 24                	je     c0107da8 <check_vma_struct+0x3ea>
c0107d84:	c7 44 24 0c 50 b7 10 	movl   $0xc010b750,0xc(%esp)
c0107d8b:	c0 
c0107d8c:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107d93:	c0 
c0107d94:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107d9b:	00 
c0107d9c:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107da3:	e8 34 8f ff ff       	call   c0100cdc <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107da8:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107dac:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107daf:	89 d0                	mov    %edx,%eax
c0107db1:	c1 e0 02             	shl    $0x2,%eax
c0107db4:	01 d0                	add    %edx,%eax
c0107db6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107db9:	0f 8d 20 fe ff ff    	jge    c0107bdf <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107dbf:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107dc6:	eb 70                	jmp    c0107e38 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dd2:	89 04 24             	mov    %eax,(%esp)
c0107dd5:	e8 bd f8 ff ff       	call   c0107697 <find_vma>
c0107dda:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107ddd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107de1:	74 27                	je     c0107e0a <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107de3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107de6:	8b 50 08             	mov    0x8(%eax),%edx
c0107de9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107dec:	8b 40 04             	mov    0x4(%eax),%eax
c0107def:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107df3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dfa:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107dfe:	c7 04 24 80 b7 10 c0 	movl   $0xc010b780,(%esp)
c0107e05:	e8 49 85 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107e0a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e0e:	74 24                	je     c0107e34 <check_vma_struct+0x476>
c0107e10:	c7 44 24 0c a5 b7 10 	movl   $0xc010b7a5,0xc(%esp)
c0107e17:	c0 
c0107e18:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107e1f:	c0 
c0107e20:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107e27:	00 
c0107e28:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107e2f:	e8 a8 8e ff ff       	call   c0100cdc <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e34:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107e38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e3c:	79 8a                	jns    c0107dc8 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e41:	89 04 24             	mov    %eax,(%esp)
c0107e44:	e8 d3 fa ff ff       	call   c010791c <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0107e49:	c7 04 24 bc b7 10 c0 	movl   $0xc010b7bc,(%esp)
c0107e50:	e8 fe 84 ff ff       	call   c0100353 <cprintf>
}
c0107e55:	c9                   	leave  
c0107e56:	c3                   	ret    

c0107e57 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107e57:	55                   	push   %ebp
c0107e58:	89 e5                	mov    %esp,%ebp
c0107e5a:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107e5d:	e8 38 cf ff ff       	call   c0104d9a <nr_free_pages>
c0107e62:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107e65:	e8 7a f7 ff ff       	call   c01075e4 <mm_create>
c0107e6a:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0107e6f:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107e74:	85 c0                	test   %eax,%eax
c0107e76:	75 24                	jne    c0107e9c <check_pgfault+0x45>
c0107e78:	c7 44 24 0c db b7 10 	movl   $0xc010b7db,0xc(%esp)
c0107e7f:	c0 
c0107e80:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107e87:	c0 
c0107e88:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0107e8f:	00 
c0107e90:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107e97:	e8 40 8e ff ff       	call   c0100cdc <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107e9c:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107ea1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107ea4:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0107eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ead:	89 50 0c             	mov    %edx,0xc(%eax)
c0107eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eb3:	8b 40 0c             	mov    0xc(%eax),%eax
c0107eb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ebc:	8b 00                	mov    (%eax),%eax
c0107ebe:	85 c0                	test   %eax,%eax
c0107ec0:	74 24                	je     c0107ee6 <check_pgfault+0x8f>
c0107ec2:	c7 44 24 0c f3 b7 10 	movl   $0xc010b7f3,0xc(%esp)
c0107ec9:	c0 
c0107eca:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107ed1:	c0 
c0107ed2:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0107ed9:	00 
c0107eda:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107ee1:	e8 f6 8d ff ff       	call   c0100cdc <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107ee6:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107eed:	00 
c0107eee:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107ef5:	00 
c0107ef6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107efd:	e8 5a f7 ff ff       	call   c010765c <vma_create>
c0107f02:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107f05:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f09:	75 24                	jne    c0107f2f <check_pgfault+0xd8>
c0107f0b:	c7 44 24 0c 84 b6 10 	movl   $0xc010b684,0xc(%esp)
c0107f12:	c0 
c0107f13:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107f1a:	c0 
c0107f1b:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107f22:	00 
c0107f23:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107f2a:	e8 ad 8d ff ff       	call   c0100cdc <__panic>

    insert_vma_struct(mm, vma);
c0107f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f39:	89 04 24             	mov    %eax,(%esp)
c0107f3c:	e8 ab f8 ff ff       	call   c01077ec <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107f41:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f52:	89 04 24             	mov    %eax,(%esp)
c0107f55:	e8 3d f7 ff ff       	call   c0107697 <find_vma>
c0107f5a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107f5d:	74 24                	je     c0107f83 <check_pgfault+0x12c>
c0107f5f:	c7 44 24 0c 01 b8 10 	movl   $0xc010b801,0xc(%esp)
c0107f66:	c0 
c0107f67:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107f6e:	c0 
c0107f6f:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0107f76:	00 
c0107f77:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107f7e:	e8 59 8d ff ff       	call   c0100cdc <__panic>

    int i, sum = 0;
c0107f83:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107f8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107f91:	eb 17                	jmp    c0107faa <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f96:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f99:	01 d0                	add    %edx,%eax
c0107f9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f9e:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fa3:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107fa6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107faa:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107fae:	7e e3                	jle    c0107f93 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107fb7:	eb 15                	jmp    c0107fce <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fbf:	01 d0                	add    %edx,%eax
c0107fc1:	0f b6 00             	movzbl (%eax),%eax
c0107fc4:	0f be c0             	movsbl %al,%eax
c0107fc7:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107fca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107fce:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107fd2:	7e e5                	jle    c0107fb9 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107fd8:	74 24                	je     c0107ffe <check_pgfault+0x1a7>
c0107fda:	c7 44 24 0c 1b b8 10 	movl   $0xc010b81b,0xc(%esp)
c0107fe1:	c0 
c0107fe2:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0107fe9:	c0 
c0107fea:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0107ff1:	00 
c0107ff2:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0107ff9:	e8 de 8c ff ff       	call   c0100cdc <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107ffe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108001:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108004:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108007:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010800c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108013:	89 04 24             	mov    %eax,(%esp)
c0108016:	e8 4e d6 ff ff       	call   c0105669 <page_remove>
    free_page(pa2page(pgdir[0]));
c010801b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010801e:	8b 00                	mov    (%eax),%eax
c0108020:	89 04 24             	mov    %eax,(%esp)
c0108023:	e8 77 f5 ff ff       	call   c010759f <pa2page>
c0108028:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010802f:	00 
c0108030:	89 04 24             	mov    %eax,(%esp)
c0108033:	e8 30 cd ff ff       	call   c0104d68 <free_pages>
    pgdir[0] = 0;
c0108038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010803b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108041:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108044:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010804b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010804e:	89 04 24             	mov    %eax,(%esp)
c0108051:	e8 c6 f8 ff ff       	call   c010791c <mm_destroy>
    check_mm_struct = NULL;
c0108056:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c010805d:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108060:	e8 35 cd ff ff       	call   c0104d9a <nr_free_pages>
c0108065:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108068:	74 24                	je     c010808e <check_pgfault+0x237>
c010806a:	c7 44 24 0c 24 b8 10 	movl   $0xc010b824,0xc(%esp)
c0108071:	c0 
c0108072:	c7 44 24 08 e3 b5 10 	movl   $0xc010b5e3,0x8(%esp)
c0108079:	c0 
c010807a:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0108081:	00 
c0108082:	c7 04 24 f8 b5 10 c0 	movl   $0xc010b5f8,(%esp)
c0108089:	e8 4e 8c ff ff       	call   c0100cdc <__panic>

    cprintf("check_pgfault() succeeded!\n");
c010808e:	c7 04 24 4b b8 10 c0 	movl   $0xc010b84b,(%esp)
c0108095:	e8 b9 82 ff ff       	call   c0100353 <cprintf>
}
c010809a:	c9                   	leave  
c010809b:	c3                   	ret    

c010809c <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c010809c:	55                   	push   %ebp
c010809d:	89 e5                	mov    %esp,%ebp
c010809f:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c01080a2:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c01080a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01080ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01080b3:	89 04 24             	mov    %eax,(%esp)
c01080b6:	e8 dc f5 ff ff       	call   c0107697 <find_vma>
c01080bb:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01080be:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01080c3:	83 c0 01             	add    $0x1,%eax
c01080c6:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c01080cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01080cf:	74 0b                	je     c01080dc <do_pgfault+0x40>
c01080d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01080d4:	8b 40 04             	mov    0x4(%eax),%eax
c01080d7:	3b 45 10             	cmp    0x10(%ebp),%eax
c01080da:	76 18                	jbe    c01080f4 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01080dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01080df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080e3:	c7 04 24 68 b8 10 c0 	movl   $0xc010b868,(%esp)
c01080ea:	e8 64 82 ff ff       	call   c0100353 <cprintf>
        goto failed;
c01080ef:	e9 9c 01 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
    }
    //check the error_code
    switch (error_code & 3) {
c01080f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080f7:	83 e0 03             	and    $0x3,%eax
c01080fa:	85 c0                	test   %eax,%eax
c01080fc:	74 36                	je     c0108134 <do_pgfault+0x98>
c01080fe:	83 f8 01             	cmp    $0x1,%eax
c0108101:	74 20                	je     c0108123 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108103:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108106:	8b 40 0c             	mov    0xc(%eax),%eax
c0108109:	83 e0 02             	and    $0x2,%eax
c010810c:	85 c0                	test   %eax,%eax
c010810e:	75 11                	jne    c0108121 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108110:	c7 04 24 98 b8 10 c0 	movl   $0xc010b898,(%esp)
c0108117:	e8 37 82 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010811c:	e9 6f 01 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
        }
        break;
c0108121:	eb 2f                	jmp    c0108152 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108123:	c7 04 24 f8 b8 10 c0 	movl   $0xc010b8f8,(%esp)
c010812a:	e8 24 82 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010812f:	e9 5c 01 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108134:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108137:	8b 40 0c             	mov    0xc(%eax),%eax
c010813a:	83 e0 05             	and    $0x5,%eax
c010813d:	85 c0                	test   %eax,%eax
c010813f:	75 11                	jne    c0108152 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108141:	c7 04 24 30 b9 10 c0 	movl   $0xc010b930,(%esp)
c0108148:	e8 06 82 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010814d:	e9 3e 01 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108152:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108159:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010815c:	8b 40 0c             	mov    0xc(%eax),%eax
c010815f:	83 e0 02             	and    $0x2,%eax
c0108162:	85 c0                	test   %eax,%eax
c0108164:	74 04                	je     c010816a <do_pgfault+0xce>
        perm |= PTE_W;
c0108166:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010816a:	8b 45 10             	mov    0x10(%ebp),%eax
c010816d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108170:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108178:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c010817b:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108182:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
   ptep = get_pte(mm->pgdir, addr, 1);
c0108189:	8b 45 08             	mov    0x8(%ebp),%eax
c010818c:	8b 40 0c             	mov    0xc(%eax),%eax
c010818f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108196:	00 
c0108197:	8b 55 10             	mov    0x10(%ebp),%edx
c010819a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010819e:	89 04 24             	mov    %eax,(%esp)
c01081a1:	e8 be d2 ff ff       	call   c0105464 <get_pte>
c01081a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   if(ptep == NULL) goto failed;
c01081a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01081ad:	75 05                	jne    c01081b4 <do_pgfault+0x118>
c01081af:	e9 dc 00 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
   if(*ptep == 0){
c01081b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081b7:	8b 00                	mov    (%eax),%eax
c01081b9:	85 c0                	test   %eax,%eax
c01081bb:	75 2f                	jne    c01081ec <do_pgfault+0x150>
	   struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
c01081bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01081c0:	8b 40 0c             	mov    0xc(%eax),%eax
c01081c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01081c6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01081ca:	8b 55 10             	mov    0x10(%ebp),%edx
c01081cd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081d1:	89 04 24             	mov    %eax,(%esp)
c01081d4:	e8 ea d5 ff ff       	call   c01057c3 <pgdir_alloc_page>
c01081d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	   if(page == NULL) goto failed;
c01081dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01081e0:	75 05                	jne    c01081e7 <do_pgfault+0x14b>
c01081e2:	e9 a9 00 00 00       	jmp    c0108290 <do_pgfault+0x1f4>
c01081e7:	e9 9d 00 00 00       	jmp    c0108289 <do_pgfault+0x1ed>
   }
   else{
	   if(swap_init_ok){
c01081ec:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c01081f1:	85 c0                	test   %eax,%eax
c01081f3:	74 7d                	je     c0108272 <do_pgfault+0x1d6>
		   struct Page *page = NULL;
c01081f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		   ret = swap_in(mm, addr, &page);
c01081fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01081ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108203:	8b 45 10             	mov    0x10(%ebp),%eax
c0108206:	89 44 24 04          	mov    %eax,0x4(%esp)
c010820a:	8b 45 08             	mov    0x8(%ebp),%eax
c010820d:	89 04 24             	mov    %eax,(%esp)
c0108210:	e8 3e e6 ff ff       	call   c0106853 <swap_in>
c0108215:	89 45 f4             	mov    %eax,-0xc(%ebp)
		   if( ret != 0) goto failed;
c0108218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010821c:	74 02                	je     c0108220 <do_pgfault+0x184>
c010821e:	eb 70                	jmp    c0108290 <do_pgfault+0x1f4>
		   ret = page_insert(mm->pgdir, page, addr, perm);
c0108220:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108223:	8b 45 08             	mov    0x8(%ebp),%eax
c0108226:	8b 40 0c             	mov    0xc(%eax),%eax
c0108229:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010822c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108230:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108237:	89 54 24 04          	mov    %edx,0x4(%esp)
c010823b:	89 04 24             	mov    %eax,(%esp)
c010823e:	e8 6a d4 ff ff       	call   c01056ad <page_insert>
c0108243:	89 45 f4             	mov    %eax,-0xc(%ebp)
		   if( ret != 0) goto failed;
c0108246:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010824a:	74 03                	je     c010824f <do_pgfault+0x1b3>
c010824c:	90                   	nop
c010824d:	eb 41                	jmp    c0108290 <do_pgfault+0x1f4>
		   swap_map_swappable(mm,addr,page,1);
c010824f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108252:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108259:	00 
c010825a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010825e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108261:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108265:	8b 45 08             	mov    0x8(%ebp),%eax
c0108268:	89 04 24             	mov    %eax,(%esp)
c010826b:	e8 1a e4 ff ff       	call   c010668a <swap_map_swappable>
c0108270:	eb 17                	jmp    c0108289 <do_pgfault+0x1ed>
	   }else {
		   cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108275:	8b 00                	mov    (%eax),%eax
c0108277:	89 44 24 04          	mov    %eax,0x4(%esp)
c010827b:	c7 04 24 94 b9 10 c0 	movl   $0xc010b994,(%esp)
c0108282:	e8 cc 80 ff ff       	call   c0100353 <cprintf>
		   goto failed;
c0108287:	eb 07                	jmp    c0108290 <do_pgfault+0x1f4>
	   }
   }
   ret = 0;
c0108289:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108290:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108293:	c9                   	leave  
c0108294:	c3                   	ret    

c0108295 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108295:	55                   	push   %ebp
c0108296:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108298:	8b 55 08             	mov    0x8(%ebp),%edx
c010829b:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01082a0:	29 c2                	sub    %eax,%edx
c01082a2:	89 d0                	mov    %edx,%eax
c01082a4:	c1 f8 05             	sar    $0x5,%eax
}
c01082a7:	5d                   	pop    %ebp
c01082a8:	c3                   	ret    

c01082a9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01082a9:	55                   	push   %ebp
c01082aa:	89 e5                	mov    %esp,%ebp
c01082ac:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01082af:	8b 45 08             	mov    0x8(%ebp),%eax
c01082b2:	89 04 24             	mov    %eax,(%esp)
c01082b5:	e8 db ff ff ff       	call   c0108295 <page2ppn>
c01082ba:	c1 e0 0c             	shl    $0xc,%eax
}
c01082bd:	c9                   	leave  
c01082be:	c3                   	ret    

c01082bf <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01082bf:	55                   	push   %ebp
c01082c0:	89 e5                	mov    %esp,%ebp
c01082c2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01082c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c8:	89 04 24             	mov    %eax,(%esp)
c01082cb:	e8 d9 ff ff ff       	call   c01082a9 <page2pa>
c01082d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082d6:	c1 e8 0c             	shr    $0xc,%eax
c01082d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082dc:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01082e1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01082e4:	72 23                	jb     c0108309 <page2kva+0x4a>
c01082e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01082ed:	c7 44 24 08 bc b9 10 	movl   $0xc010b9bc,0x8(%esp)
c01082f4:	c0 
c01082f5:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01082fc:	00 
c01082fd:	c7 04 24 df b9 10 c0 	movl   $0xc010b9df,(%esp)
c0108304:	e8 d3 89 ff ff       	call   c0100cdc <__panic>
c0108309:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010830c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108311:	c9                   	leave  
c0108312:	c3                   	ret    

c0108313 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108313:	55                   	push   %ebp
c0108314:	89 e5                	mov    %esp,%ebp
c0108316:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108319:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108320:	e8 07 97 ff ff       	call   c0101a2c <ide_device_valid>
c0108325:	85 c0                	test   %eax,%eax
c0108327:	75 1c                	jne    c0108345 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108329:	c7 44 24 08 ed b9 10 	movl   $0xc010b9ed,0x8(%esp)
c0108330:	c0 
c0108331:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108338:	00 
c0108339:	c7 04 24 07 ba 10 c0 	movl   $0xc010ba07,(%esp)
c0108340:	e8 97 89 ff ff       	call   c0100cdc <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108345:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010834c:	e8 1a 97 ff ff       	call   c0101a6b <ide_device_size>
c0108351:	c1 e8 03             	shr    $0x3,%eax
c0108354:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c0108359:	c9                   	leave  
c010835a:	c3                   	ret    

c010835b <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010835b:	55                   	push   %ebp
c010835c:	89 e5                	mov    %esp,%ebp
c010835e:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108361:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108364:	89 04 24             	mov    %eax,(%esp)
c0108367:	e8 53 ff ff ff       	call   c01082bf <page2kva>
c010836c:	8b 55 08             	mov    0x8(%ebp),%edx
c010836f:	c1 ea 08             	shr    $0x8,%edx
c0108372:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108375:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108379:	74 0b                	je     c0108386 <swapfs_read+0x2b>
c010837b:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108381:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108384:	72 23                	jb     c01083a9 <swapfs_read+0x4e>
c0108386:	8b 45 08             	mov    0x8(%ebp),%eax
c0108389:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010838d:	c7 44 24 08 18 ba 10 	movl   $0xc010ba18,0x8(%esp)
c0108394:	c0 
c0108395:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c010839c:	00 
c010839d:	c7 04 24 07 ba 10 c0 	movl   $0xc010ba07,(%esp)
c01083a4:	e8 33 89 ff ff       	call   c0100cdc <__panic>
c01083a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083ac:	c1 e2 03             	shl    $0x3,%edx
c01083af:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01083b6:	00 
c01083b7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083bb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083c6:	e8 df 96 ff ff       	call   c0101aaa <ide_read_secs>
}
c01083cb:	c9                   	leave  
c01083cc:	c3                   	ret    

c01083cd <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01083cd:	55                   	push   %ebp
c01083ce:	89 e5                	mov    %esp,%ebp
c01083d0:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01083d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d6:	89 04 24             	mov    %eax,(%esp)
c01083d9:	e8 e1 fe ff ff       	call   c01082bf <page2kva>
c01083de:	8b 55 08             	mov    0x8(%ebp),%edx
c01083e1:	c1 ea 08             	shr    $0x8,%edx
c01083e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01083e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01083eb:	74 0b                	je     c01083f8 <swapfs_write+0x2b>
c01083ed:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c01083f3:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01083f6:	72 23                	jb     c010841b <swapfs_write+0x4e>
c01083f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01083fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01083ff:	c7 44 24 08 18 ba 10 	movl   $0xc010ba18,0x8(%esp)
c0108406:	c0 
c0108407:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010840e:	00 
c010840f:	c7 04 24 07 ba 10 c0 	movl   $0xc010ba07,(%esp)
c0108416:	e8 c1 88 ff ff       	call   c0100cdc <__panic>
c010841b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010841e:	c1 e2 03             	shl    $0x3,%edx
c0108421:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108428:	00 
c0108429:	89 44 24 08          	mov    %eax,0x8(%esp)
c010842d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108438:	e8 af 98 ff ff       	call   c0101cec <ide_write_secs>
}
c010843d:	c9                   	leave  
c010843e:	c3                   	ret    

c010843f <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010843f:	52                   	push   %edx
    call *%ebx              # call fn
c0108440:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108442:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108443:	e8 28 08 00 00       	call   c0108c70 <do_exit>

c0108448 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108448:	55                   	push   %ebp
c0108449:	89 e5                	mov    %esp,%ebp
c010844b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010844e:	9c                   	pushf  
c010844f:	58                   	pop    %eax
c0108450:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108453:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108456:	25 00 02 00 00       	and    $0x200,%eax
c010845b:	85 c0                	test   %eax,%eax
c010845d:	74 0c                	je     c010846b <__intr_save+0x23>
        intr_disable();
c010845f:	e8 d0 9a ff ff       	call   c0101f34 <intr_disable>
        return 1;
c0108464:	b8 01 00 00 00       	mov    $0x1,%eax
c0108469:	eb 05                	jmp    c0108470 <__intr_save+0x28>
    }
    return 0;
c010846b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108470:	c9                   	leave  
c0108471:	c3                   	ret    

c0108472 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108472:	55                   	push   %ebp
c0108473:	89 e5                	mov    %esp,%ebp
c0108475:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108478:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010847c:	74 05                	je     c0108483 <__intr_restore+0x11>
        intr_enable();
c010847e:	e8 ab 9a ff ff       	call   c0101f2e <intr_enable>
    }
}
c0108483:	c9                   	leave  
c0108484:	c3                   	ret    

c0108485 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108485:	55                   	push   %ebp
c0108486:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108488:	8b 55 08             	mov    0x8(%ebp),%edx
c010848b:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0108490:	29 c2                	sub    %eax,%edx
c0108492:	89 d0                	mov    %edx,%eax
c0108494:	c1 f8 05             	sar    $0x5,%eax
}
c0108497:	5d                   	pop    %ebp
c0108498:	c3                   	ret    

c0108499 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108499:	55                   	push   %ebp
c010849a:	89 e5                	mov    %esp,%ebp
c010849c:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010849f:	8b 45 08             	mov    0x8(%ebp),%eax
c01084a2:	89 04 24             	mov    %eax,(%esp)
c01084a5:	e8 db ff ff ff       	call   c0108485 <page2ppn>
c01084aa:	c1 e0 0c             	shl    $0xc,%eax
}
c01084ad:	c9                   	leave  
c01084ae:	c3                   	ret    

c01084af <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01084af:	55                   	push   %ebp
c01084b0:	89 e5                	mov    %esp,%ebp
c01084b2:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01084b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b8:	c1 e8 0c             	shr    $0xc,%eax
c01084bb:	89 c2                	mov    %eax,%edx
c01084bd:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01084c2:	39 c2                	cmp    %eax,%edx
c01084c4:	72 1c                	jb     c01084e2 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01084c6:	c7 44 24 08 38 ba 10 	movl   $0xc010ba38,0x8(%esp)
c01084cd:	c0 
c01084ce:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01084d5:	00 
c01084d6:	c7 04 24 57 ba 10 c0 	movl   $0xc010ba57,(%esp)
c01084dd:	e8 fa 87 ff ff       	call   c0100cdc <__panic>
    }
    return &pages[PPN(pa)];
c01084e2:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01084e7:	8b 55 08             	mov    0x8(%ebp),%edx
c01084ea:	c1 ea 0c             	shr    $0xc,%edx
c01084ed:	c1 e2 05             	shl    $0x5,%edx
c01084f0:	01 d0                	add    %edx,%eax
}
c01084f2:	c9                   	leave  
c01084f3:	c3                   	ret    

c01084f4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01084f4:	55                   	push   %ebp
c01084f5:	89 e5                	mov    %esp,%ebp
c01084f7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01084fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01084fd:	89 04 24             	mov    %eax,(%esp)
c0108500:	e8 94 ff ff ff       	call   c0108499 <page2pa>
c0108505:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108508:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010850b:	c1 e8 0c             	shr    $0xc,%eax
c010850e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108511:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108516:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108519:	72 23                	jb     c010853e <page2kva+0x4a>
c010851b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010851e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108522:	c7 44 24 08 68 ba 10 	movl   $0xc010ba68,0x8(%esp)
c0108529:	c0 
c010852a:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108531:	00 
c0108532:	c7 04 24 57 ba 10 c0 	movl   $0xc010ba57,(%esp)
c0108539:	e8 9e 87 ff ff       	call   c0100cdc <__panic>
c010853e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108541:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108546:	c9                   	leave  
c0108547:	c3                   	ret    

c0108548 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0108548:	55                   	push   %ebp
c0108549:	89 e5                	mov    %esp,%ebp
c010854b:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010854e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108551:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108554:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010855b:	77 23                	ja     c0108580 <kva2page+0x38>
c010855d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108560:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108564:	c7 44 24 08 8c ba 10 	movl   $0xc010ba8c,0x8(%esp)
c010856b:	c0 
c010856c:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0108573:	00 
c0108574:	c7 04 24 57 ba 10 c0 	movl   $0xc010ba57,(%esp)
c010857b:	e8 5c 87 ff ff       	call   c0100cdc <__panic>
c0108580:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108583:	05 00 00 00 40       	add    $0x40000000,%eax
c0108588:	89 04 24             	mov    %eax,(%esp)
c010858b:	e8 1f ff ff ff       	call   c01084af <pa2page>
}
c0108590:	c9                   	leave  
c0108591:	c3                   	ret    

c0108592 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0108592:	55                   	push   %ebp
c0108593:	89 e5                	mov    %esp,%ebp
c0108595:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0108598:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c010859f:	e8 fc c2 ff ff       	call   c01048a0 <kmalloc>
c01085a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01085a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01085ab:	0f 84 a1 00 00 00    	je     c0108652 <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
c01085b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c01085ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085bd:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs = 0;
c01085c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c01085ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c01085d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085db:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c01085e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c01085ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085ef:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c01085f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085f9:	83 c0 1c             	add    $0x1c,%eax
c01085fc:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108603:	00 
c0108604:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010860b:	00 
c010860c:	89 04 24             	mov    %eax,(%esp)
c010860f:	e8 de 14 00 00       	call   c0109af2 <memset>
        proc->tf = NULL;
c0108614:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108617:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;
c010861e:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c0108624:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108627:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c010862a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010862d:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN);
c0108634:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108637:	83 c0 48             	add    $0x48,%eax
c010863a:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108641:	00 
c0108642:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108649:	00 
c010864a:	89 04 24             	mov    %eax,(%esp)
c010864d:	e8 a0 14 00 00       	call   c0109af2 <memset>
    }
    return proc;
c0108652:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108655:	c9                   	leave  
c0108656:	c3                   	ret    

c0108657 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108657:	55                   	push   %ebp
c0108658:	89 e5                	mov    %esp,%ebp
c010865a:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010865d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108660:	83 c0 48             	add    $0x48,%eax
c0108663:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010866a:	00 
c010866b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108672:	00 
c0108673:	89 04 24             	mov    %eax,(%esp)
c0108676:	e8 77 14 00 00       	call   c0109af2 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010867b:	8b 45 08             	mov    0x8(%ebp),%eax
c010867e:	8d 50 48             	lea    0x48(%eax),%edx
c0108681:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108688:	00 
c0108689:	8b 45 0c             	mov    0xc(%ebp),%eax
c010868c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108690:	89 14 24             	mov    %edx,(%esp)
c0108693:	e8 3c 15 00 00       	call   c0109bd4 <memcpy>
}
c0108698:	c9                   	leave  
c0108699:	c3                   	ret    

c010869a <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c010869a:	55                   	push   %ebp
c010869b:	89 e5                	mov    %esp,%ebp
c010869d:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01086a0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01086a7:	00 
c01086a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086af:	00 
c01086b0:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01086b7:	e8 36 14 00 00       	call   c0109af2 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01086bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01086bf:	83 c0 48             	add    $0x48,%eax
c01086c2:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01086c9:	00 
c01086ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086ce:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01086d5:	e8 fa 14 00 00       	call   c0109bd4 <memcpy>
}
c01086da:	c9                   	leave  
c01086db:	c3                   	ret    

c01086dc <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01086dc:	55                   	push   %ebp
c01086dd:	89 e5                	mov    %esp,%ebp
c01086df:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01086e2:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01086e9:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01086ee:	83 c0 01             	add    $0x1,%eax
c01086f1:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c01086f6:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01086fb:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108700:	7e 0c                	jle    c010870e <get_pid+0x32>
        last_pid = 1;
c0108702:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108709:	00 00 00 
        goto inside;
c010870c:	eb 13                	jmp    c0108721 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010870e:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c0108714:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108719:	39 c2                	cmp    %eax,%edx
c010871b:	0f 8c ac 00 00 00    	jl     c01087cd <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108721:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108728:	20 00 00 
    repeat:
        le = list;
c010872b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010872e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108731:	eb 7f                	jmp    c01087b2 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108733:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108736:	83 e8 58             	sub    $0x58,%eax
c0108739:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c010873c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010873f:	8b 50 04             	mov    0x4(%eax),%edx
c0108742:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108747:	39 c2                	cmp    %eax,%edx
c0108749:	75 3e                	jne    c0108789 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c010874b:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108750:	83 c0 01             	add    $0x1,%eax
c0108753:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108758:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c010875e:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108763:	39 c2                	cmp    %eax,%edx
c0108765:	7c 4b                	jl     c01087b2 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108767:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010876c:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108771:	7e 0a                	jle    c010877d <get_pid+0xa1>
                        last_pid = 1;
c0108773:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c010877a:	00 00 00 
                    }
                    next_safe = MAX_PID;
c010877d:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108784:	20 00 00 
                    goto repeat;
c0108787:	eb a2                	jmp    c010872b <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010878c:	8b 50 04             	mov    0x4(%eax),%edx
c010878f:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108794:	39 c2                	cmp    %eax,%edx
c0108796:	7e 1a                	jle    c01087b2 <get_pid+0xd6>
c0108798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010879b:	8b 50 04             	mov    0x4(%eax),%edx
c010879e:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01087a3:	39 c2                	cmp    %eax,%edx
c01087a5:	7d 0b                	jge    c01087b2 <get_pid+0xd6>
                next_safe = proc->pid;
c01087a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087aa:	8b 40 04             	mov    0x4(%eax),%eax
c01087ad:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c01087b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01087b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087bb:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c01087be:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01087c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087c4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01087c7:	0f 85 66 ff ff ff    	jne    c0108733 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c01087cd:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c01087d2:	c9                   	leave  
c01087d3:	c3                   	ret    

c01087d4 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c01087d4:	55                   	push   %ebp
c01087d5:	89 e5                	mov    %esp,%ebp
c01087d7:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01087da:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01087df:	39 45 08             	cmp    %eax,0x8(%ebp)
c01087e2:	74 63                	je     c0108847 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01087e4:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01087e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01087f2:	e8 51 fc ff ff       	call   c0108448 <__intr_save>
c01087f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01087fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fd:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108802:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108805:	8b 40 0c             	mov    0xc(%eax),%eax
c0108808:	05 00 20 00 00       	add    $0x2000,%eax
c010880d:	89 04 24             	mov    %eax,(%esp)
c0108810:	e8 9a c3 ff ff       	call   c0104baf <load_esp0>
            lcr3(next->cr3);
c0108815:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108818:	8b 40 40             	mov    0x40(%eax),%eax
c010881b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010881e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108821:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108824:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108827:	8d 50 1c             	lea    0x1c(%eax),%edx
c010882a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010882d:	83 c0 1c             	add    $0x1c,%eax
c0108830:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108834:	89 04 24             	mov    %eax,(%esp)
c0108837:	e8 86 06 00 00       	call   c0108ec2 <switch_to>
        }
        local_intr_restore(intr_flag);
c010883c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010883f:	89 04 24             	mov    %eax,(%esp)
c0108842:	e8 2b fc ff ff       	call   c0108472 <__intr_restore>
    }
}
c0108847:	c9                   	leave  
c0108848:	c3                   	ret    

c0108849 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108849:	55                   	push   %ebp
c010884a:	89 e5                	mov    %esp,%ebp
c010884c:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c010884f:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108854:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108857:	89 04 24             	mov    %eax,(%esp)
c010885a:	e8 2d 9f ff ff       	call   c010278c <forkrets>
}
c010885f:	c9                   	leave  
c0108860:	c3                   	ret    

c0108861 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108861:	55                   	push   %ebp
c0108862:	89 e5                	mov    %esp,%ebp
c0108864:	53                   	push   %ebx
c0108865:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108868:	8b 45 08             	mov    0x8(%ebp),%eax
c010886b:	8d 58 60             	lea    0x60(%eax),%ebx
c010886e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108871:	8b 40 04             	mov    0x4(%eax),%eax
c0108874:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010887b:	00 
c010887c:	89 04 24             	mov    %eax,(%esp)
c010887f:	e8 c1 07 00 00       	call   c0109045 <hash32>
c0108884:	c1 e0 03             	shl    $0x3,%eax
c0108887:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010888c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010888f:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108892:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108895:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108898:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010889b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010889e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088a1:	8b 40 04             	mov    0x4(%eax),%eax
c01088a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01088a7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01088aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01088ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01088b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01088b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01088b9:	89 10                	mov    %edx,(%eax)
c01088bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088be:	8b 10                	mov    (%eax),%edx
c01088c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01088c3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01088c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01088cc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01088cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01088d5:	89 10                	mov    %edx,(%eax)
}
c01088d7:	83 c4 34             	add    $0x34,%esp
c01088da:	5b                   	pop    %ebx
c01088db:	5d                   	pop    %ebp
c01088dc:	c3                   	ret    

c01088dd <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c01088dd:	55                   	push   %ebp
c01088de:	89 e5                	mov    %esp,%ebp
c01088e0:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c01088e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01088e7:	7e 5f                	jle    c0108948 <find_proc+0x6b>
c01088e9:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01088f0:	7f 56                	jg     c0108948 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c01088f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01088f5:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01088fc:	00 
c01088fd:	89 04 24             	mov    %eax,(%esp)
c0108900:	e8 40 07 00 00       	call   c0109045 <hash32>
c0108905:	c1 e0 03             	shl    $0x3,%eax
c0108908:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010890d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108910:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108913:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108916:	eb 19                	jmp    c0108931 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108918:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010891b:	83 e8 60             	sub    $0x60,%eax
c010891e:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108921:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108924:	8b 40 04             	mov    0x4(%eax),%eax
c0108927:	3b 45 08             	cmp    0x8(%ebp),%eax
c010892a:	75 05                	jne    c0108931 <find_proc+0x54>
                return proc;
c010892c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010892f:	eb 1c                	jmp    c010894d <find_proc+0x70>
c0108931:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108934:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108937:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010893a:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c010893d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108943:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108946:	75 d0                	jne    c0108918 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108948:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010894d:	c9                   	leave  
c010894e:	c3                   	ret    

c010894f <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c010894f:	55                   	push   %ebp
c0108950:	89 e5                	mov    %esp,%ebp
c0108952:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108955:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010895c:	00 
c010895d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108964:	00 
c0108965:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108968:	89 04 24             	mov    %eax,(%esp)
c010896b:	e8 82 11 00 00       	call   c0109af2 <memset>
    tf.tf_cs = KERNEL_CS;
c0108970:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108976:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c010897c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108980:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108984:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108988:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c010898c:	8b 45 08             	mov    0x8(%ebp),%eax
c010898f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108992:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108995:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108998:	b8 3f 84 10 c0       	mov    $0xc010843f,%eax
c010899d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c01089a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01089a3:	80 cc 01             	or     $0x1,%ah
c01089a6:	89 c2                	mov    %eax,%edx
c01089a8:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01089ab:	89 44 24 08          	mov    %eax,0x8(%esp)
c01089af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089b6:	00 
c01089b7:	89 14 24             	mov    %edx,(%esp)
c01089ba:	e8 79 01 00 00       	call   c0108b38 <do_fork>
}
c01089bf:	c9                   	leave  
c01089c0:	c3                   	ret    

c01089c1 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c01089c1:	55                   	push   %ebp
c01089c2:	89 e5                	mov    %esp,%ebp
c01089c4:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c01089c7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01089ce:	e8 2a c3 ff ff       	call   c0104cfd <alloc_pages>
c01089d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01089d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01089da:	74 1a                	je     c01089f6 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c01089dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089df:	89 04 24             	mov    %eax,(%esp)
c01089e2:	e8 0d fb ff ff       	call   c01084f4 <page2kva>
c01089e7:	89 c2                	mov    %eax,%edx
c01089e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ec:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c01089ef:	b8 00 00 00 00       	mov    $0x0,%eax
c01089f4:	eb 05                	jmp    c01089fb <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c01089f6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c01089fb:	c9                   	leave  
c01089fc:	c3                   	ret    

c01089fd <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c01089fd:	55                   	push   %ebp
c01089fe:	89 e5                	mov    %esp,%ebp
c0108a00:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a06:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a09:	89 04 24             	mov    %eax,(%esp)
c0108a0c:	e8 37 fb ff ff       	call   c0108548 <kva2page>
c0108a11:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108a18:	00 
c0108a19:	89 04 24             	mov    %eax,(%esp)
c0108a1c:	e8 47 c3 ff ff       	call   c0104d68 <free_pages>
}
c0108a21:	c9                   	leave  
c0108a22:	c3                   	ret    

c0108a23 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108a23:	55                   	push   %ebp
c0108a24:	89 e5                	mov    %esp,%ebp
c0108a26:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108a29:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108a2e:	8b 40 18             	mov    0x18(%eax),%eax
c0108a31:	85 c0                	test   %eax,%eax
c0108a33:	74 24                	je     c0108a59 <copy_mm+0x36>
c0108a35:	c7 44 24 0c b0 ba 10 	movl   $0xc010bab0,0xc(%esp)
c0108a3c:	c0 
c0108a3d:	c7 44 24 08 c4 ba 10 	movl   $0xc010bac4,0x8(%esp)
c0108a44:	c0 
c0108a45:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108a4c:	00 
c0108a4d:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108a54:	e8 83 82 ff ff       	call   c0100cdc <__panic>
    /* do nothing in this project */
    return 0;
c0108a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108a5e:	c9                   	leave  
c0108a5f:	c3                   	ret    

c0108a60 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108a60:	55                   	push   %ebp
c0108a61:	89 e5                	mov    %esp,%ebp
c0108a63:	57                   	push   %edi
c0108a64:	56                   	push   %esi
c0108a65:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a69:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a6c:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108a71:	89 c2                	mov    %eax,%edx
c0108a73:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a76:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a7c:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108a7f:	8b 55 10             	mov    0x10(%ebp),%edx
c0108a82:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108a87:	89 c1                	mov    %eax,%ecx
c0108a89:	83 e1 01             	and    $0x1,%ecx
c0108a8c:	85 c9                	test   %ecx,%ecx
c0108a8e:	74 0e                	je     c0108a9e <copy_thread+0x3e>
c0108a90:	0f b6 0a             	movzbl (%edx),%ecx
c0108a93:	88 08                	mov    %cl,(%eax)
c0108a95:	83 c0 01             	add    $0x1,%eax
c0108a98:	83 c2 01             	add    $0x1,%edx
c0108a9b:	83 eb 01             	sub    $0x1,%ebx
c0108a9e:	89 c1                	mov    %eax,%ecx
c0108aa0:	83 e1 02             	and    $0x2,%ecx
c0108aa3:	85 c9                	test   %ecx,%ecx
c0108aa5:	74 0f                	je     c0108ab6 <copy_thread+0x56>
c0108aa7:	0f b7 0a             	movzwl (%edx),%ecx
c0108aaa:	66 89 08             	mov    %cx,(%eax)
c0108aad:	83 c0 02             	add    $0x2,%eax
c0108ab0:	83 c2 02             	add    $0x2,%edx
c0108ab3:	83 eb 02             	sub    $0x2,%ebx
c0108ab6:	89 d9                	mov    %ebx,%ecx
c0108ab8:	c1 e9 02             	shr    $0x2,%ecx
c0108abb:	89 c7                	mov    %eax,%edi
c0108abd:	89 d6                	mov    %edx,%esi
c0108abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108ac1:	89 f2                	mov    %esi,%edx
c0108ac3:	89 f8                	mov    %edi,%eax
c0108ac5:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108aca:	89 de                	mov    %ebx,%esi
c0108acc:	83 e6 02             	and    $0x2,%esi
c0108acf:	85 f6                	test   %esi,%esi
c0108ad1:	74 0b                	je     c0108ade <copy_thread+0x7e>
c0108ad3:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108ad7:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108adb:	83 c1 02             	add    $0x2,%ecx
c0108ade:	83 e3 01             	and    $0x1,%ebx
c0108ae1:	85 db                	test   %ebx,%ebx
c0108ae3:	74 07                	je     c0108aec <copy_thread+0x8c>
c0108ae5:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108ae9:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aef:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108af2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108af9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afc:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108aff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108b02:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b08:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b0e:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108b11:	8b 52 40             	mov    0x40(%edx),%edx
c0108b14:	80 ce 02             	or     $0x2,%dh
c0108b17:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108b1a:	ba 49 88 10 c0       	mov    $0xc0108849,%edx
c0108b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b22:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b28:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b2b:	89 c2                	mov    %eax,%edx
c0108b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b30:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108b33:	5b                   	pop    %ebx
c0108b34:	5e                   	pop    %esi
c0108b35:	5f                   	pop    %edi
c0108b36:	5d                   	pop    %ebp
c0108b37:	c3                   	ret    

c0108b38 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108b38:	55                   	push   %ebp
c0108b39:	89 e5                	mov    %esp,%ebp
c0108b3b:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108b3e:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108b45:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108b4a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108b4f:	7e 05                	jle    c0108b56 <do_fork+0x1e>
        goto fork_out;
c0108b51:	e9 06 01 00 00       	jmp    c0108c5c <do_fork+0x124>
    }
    ret = -E_NO_MEM;
c0108b56:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
    if ((proc = alloc_proc()) == NULL) {
c0108b5d:	e8 30 fa ff ff       	call   c0108592 <alloc_proc>
c0108b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108b69:	75 05                	jne    c0108b70 <do_fork+0x38>
    	goto fork_out;
c0108b6b:	e9 ec 00 00 00       	jmp    c0108c5c <do_fork+0x124>
    }
    proc->pid = get_pid();
c0108b70:	e8 67 fb ff ff       	call   c01086dc <get_pid>
c0108b75:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108b78:	89 42 04             	mov    %eax,0x4(%edx)
    proc->parent = current;
c0108b7b:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b84:	89 50 14             	mov    %edx,0x14(%eax)
    nr_process++;
c0108b87:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108b8c:	83 c0 01             	add    $0x1,%eax
c0108b8f:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00
    if (setup_kstack(proc)) {
c0108b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b97:	89 04 24             	mov    %eax,(%esp)
c0108b9a:	e8 22 fe ff ff       	call   c01089c1 <setup_kstack>
c0108b9f:	85 c0                	test   %eax,%eax
c0108ba1:	74 05                	je     c0108ba8 <do_fork+0x70>
    	goto bad_fork_cleanup_proc;
c0108ba3:	e9 b9 00 00 00       	jmp    c0108c61 <do_fork+0x129>
    }
    if (copy_mm(clone_flags, proc)) {
c0108ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108baf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb2:	89 04 24             	mov    %eax,(%esp)
c0108bb5:	e8 69 fe ff ff       	call   c0108a23 <copy_mm>
c0108bba:	85 c0                	test   %eax,%eax
c0108bbc:	74 11                	je     c0108bcf <do_fork+0x97>
    	goto bad_fork_cleanup_kstack;
c0108bbe:	90                   	nop

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bc2:	89 04 24             	mov    %eax,(%esp)
c0108bc5:	e8 33 fe ff ff       	call   c01089fd <put_kstack>
c0108bca:	e9 92 00 00 00       	jmp    c0108c61 <do_fork+0x129>
    	goto bad_fork_cleanup_proc;
    }
    if (copy_mm(clone_flags, proc)) {
    	goto bad_fork_cleanup_kstack;
    }
    copy_thread(proc, stack, tf);
c0108bcf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bd2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108be0:	89 04 24             	mov    %eax,(%esp)
c0108be3:	e8 78 fe ff ff       	call   c0108a60 <copy_thread>
    hash_proc(proc);
c0108be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108beb:	89 04 24             	mov    %eax,(%esp)
c0108bee:	e8 6e fc ff ff       	call   c0108861 <hash_proc>
    list_add(&proc_list, &(proc->list_link));
c0108bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bf6:	83 c0 58             	add    $0x58,%eax
c0108bf9:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
c0108c00:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108c09:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c0c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c12:	8b 40 04             	mov    0x4(%eax),%eax
c0108c15:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c18:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108c1e:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108c21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108c24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c27:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c2a:	89 10                	mov    %edx,(%eax)
c0108c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c2f:	8b 10                	mov    (%eax),%edx
c0108c31:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c34:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108c37:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c3a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108c3d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108c40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c43:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108c46:	89 10                	mov    %edx,(%eax)
    wakeup_proc(proc);
c0108c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c4b:	89 04 24             	mov    %eax,(%esp)
c0108c4e:	e8 e3 02 00 00       	call   c0108f36 <wakeup_proc>
    ret = proc->pid;
c0108c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c56:	8b 40 04             	mov    0x4(%eax),%eax
c0108c59:	89 45 f4             	mov    %eax,-0xc(%ebp)

fork_out:
    return ret;
c0108c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c5f:	eb 0d                	jmp    c0108c6e <do_fork+0x136>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c64:	89 04 24             	mov    %eax,(%esp)
c0108c67:	e8 4f bc ff ff       	call   c01048bb <kfree>
    goto fork_out;
c0108c6c:	eb ee                	jmp    c0108c5c <do_fork+0x124>
}
c0108c6e:	c9                   	leave  
c0108c6f:	c3                   	ret    

c0108c70 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108c70:	55                   	push   %ebp
c0108c71:	89 e5                	mov    %esp,%ebp
c0108c73:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108c76:	c7 44 24 08 ed ba 10 	movl   $0xc010baed,0x8(%esp)
c0108c7d:	c0 
c0108c7e:	c7 44 24 04 59 01 00 	movl   $0x159,0x4(%esp)
c0108c85:	00 
c0108c86:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108c8d:	e8 4a 80 ff ff       	call   c0100cdc <__panic>

c0108c92 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108c92:	55                   	push   %ebp
c0108c93:	89 e5                	mov    %esp,%ebp
c0108c95:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108c98:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108c9d:	89 04 24             	mov    %eax,(%esp)
c0108ca0:	e8 f5 f9 ff ff       	call   c010869a <get_proc_name>
c0108ca5:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108cab:	8b 52 04             	mov    0x4(%edx),%edx
c0108cae:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cb2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108cb6:	c7 04 24 00 bb 10 c0 	movl   $0xc010bb00,(%esp)
c0108cbd:	e8 91 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cc9:	c7 04 24 26 bb 10 c0 	movl   $0xc010bb26,(%esp)
c0108cd0:	e8 7e 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108cd5:	c7 04 24 33 bb 10 c0 	movl   $0xc010bb33,(%esp)
c0108cdc:	e8 72 76 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ce6:	c9                   	leave  
c0108ce7:	c3                   	ret    

c0108ce8 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108ce8:	55                   	push   %ebp
c0108ce9:	89 e5                	mov    %esp,%ebp
c0108ceb:	83 ec 28             	sub    $0x28,%esp
c0108cee:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108cf8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108cfb:	89 50 04             	mov    %edx,0x4(%eax)
c0108cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d01:	8b 50 04             	mov    0x4(%eax),%edx
c0108d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d07:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d10:	eb 26                	jmp    c0108d38 <proc_init+0x50>
        list_init(hash_list + i);
c0108d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d15:	c1 e0 03             	shl    $0x3,%eax
c0108d18:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d26:	89 50 04             	mov    %edx,0x4(%eax)
c0108d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d2c:	8b 50 04             	mov    0x4(%eax),%edx
c0108d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d32:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d34:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108d38:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108d3f:	7e d1                	jle    c0108d12 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108d41:	e8 4c f8 ff ff       	call   c0108592 <alloc_proc>
c0108d46:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108d4b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d50:	85 c0                	test   %eax,%eax
c0108d52:	75 1c                	jne    c0108d70 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108d54:	c7 44 24 08 4f bb 10 	movl   $0xc010bb4f,0x8(%esp)
c0108d5b:	c0 
c0108d5c:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
c0108d63:	00 
c0108d64:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108d6b:	e8 6c 7f ff ff       	call   c0100cdc <__panic>
    }

    idleproc->pid = 0;
c0108d70:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108d7c:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d81:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108d87:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d8c:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108d91:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108d94:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d99:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108da0:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108da5:	c7 44 24 04 67 bb 10 	movl   $0xc010bb67,0x4(%esp)
c0108dac:	c0 
c0108dad:	89 04 24             	mov    %eax,(%esp)
c0108db0:	e8 a2 f8 ff ff       	call   c0108657 <set_proc_name>
    nr_process ++;
c0108db5:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108dba:	83 c0 01             	add    $0x1,%eax
c0108dbd:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108dc2:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dc7:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108dcc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108dd3:	00 
c0108dd4:	c7 44 24 04 6c bb 10 	movl   $0xc010bb6c,0x4(%esp)
c0108ddb:	c0 
c0108ddc:	c7 04 24 92 8c 10 c0 	movl   $0xc0108c92,(%esp)
c0108de3:	e8 67 fb ff ff       	call   c010894f <kernel_thread>
c0108de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108deb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108def:	7f 1c                	jg     c0108e0d <proc_init+0x125>
        panic("create init_main failed.\n");
c0108df1:	c7 44 24 08 7a bb 10 	movl   $0xc010bb7a,0x8(%esp)
c0108df8:	c0 
c0108df9:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c0108e00:	00 
c0108e01:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108e08:	e8 cf 7e ff ff       	call   c0100cdc <__panic>
    }

    initproc = find_proc(pid);
c0108e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e10:	89 04 24             	mov    %eax,(%esp)
c0108e13:	e8 c5 fa ff ff       	call   c01088dd <find_proc>
c0108e18:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108e1d:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e22:	c7 44 24 04 94 bb 10 	movl   $0xc010bb94,0x4(%esp)
c0108e29:	c0 
c0108e2a:	89 04 24             	mov    %eax,(%esp)
c0108e2d:	e8 25 f8 ff ff       	call   c0108657 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108e32:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e37:	85 c0                	test   %eax,%eax
c0108e39:	74 0c                	je     c0108e47 <proc_init+0x15f>
c0108e3b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e40:	8b 40 04             	mov    0x4(%eax),%eax
c0108e43:	85 c0                	test   %eax,%eax
c0108e45:	74 24                	je     c0108e6b <proc_init+0x183>
c0108e47:	c7 44 24 0c 9c bb 10 	movl   $0xc010bb9c,0xc(%esp)
c0108e4e:	c0 
c0108e4f:	c7 44 24 08 c4 ba 10 	movl   $0xc010bac4,0x8(%esp)
c0108e56:	c0 
c0108e57:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
c0108e5e:	00 
c0108e5f:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108e66:	e8 71 7e ff ff       	call   c0100cdc <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108e6b:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e70:	85 c0                	test   %eax,%eax
c0108e72:	74 0d                	je     c0108e81 <proc_init+0x199>
c0108e74:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e79:	8b 40 04             	mov    0x4(%eax),%eax
c0108e7c:	83 f8 01             	cmp    $0x1,%eax
c0108e7f:	74 24                	je     c0108ea5 <proc_init+0x1bd>
c0108e81:	c7 44 24 0c c4 bb 10 	movl   $0xc010bbc4,0xc(%esp)
c0108e88:	c0 
c0108e89:	c7 44 24 08 c4 ba 10 	movl   $0xc010bac4,0x8(%esp)
c0108e90:	c0 
c0108e91:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c0108e98:	00 
c0108e99:	c7 04 24 d9 ba 10 c0 	movl   $0xc010bad9,(%esp)
c0108ea0:	e8 37 7e ff ff       	call   c0100cdc <__panic>
}
c0108ea5:	c9                   	leave  
c0108ea6:	c3                   	ret    

c0108ea7 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108ea7:	55                   	push   %ebp
c0108ea8:	89 e5                	mov    %esp,%ebp
c0108eaa:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0108ead:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108eb2:	8b 40 10             	mov    0x10(%eax),%eax
c0108eb5:	85 c0                	test   %eax,%eax
c0108eb7:	74 07                	je     c0108ec0 <cpu_idle+0x19>
            schedule();
c0108eb9:	e8 c1 00 00 00       	call   c0108f7f <schedule>
        }
    }
c0108ebe:	eb ed                	jmp    c0108ead <cpu_idle+0x6>
c0108ec0:	eb eb                	jmp    c0108ead <cpu_idle+0x6>

c0108ec2 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108ec2:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108ec6:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0108ec8:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0108ecb:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0108ece:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0108ed1:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0108ed4:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0108ed7:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0108eda:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108edd:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0108ee1:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0108ee4:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0108ee7:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0108eea:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c0108eed:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0108ef0:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0108ef3:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108ef6:	ff 30                	pushl  (%eax)

    ret
c0108ef8:	c3                   	ret    

c0108ef9 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108ef9:	55                   	push   %ebp
c0108efa:	89 e5                	mov    %esp,%ebp
c0108efc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108eff:	9c                   	pushf  
c0108f00:	58                   	pop    %eax
c0108f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108f07:	25 00 02 00 00       	and    $0x200,%eax
c0108f0c:	85 c0                	test   %eax,%eax
c0108f0e:	74 0c                	je     c0108f1c <__intr_save+0x23>
        intr_disable();
c0108f10:	e8 1f 90 ff ff       	call   c0101f34 <intr_disable>
        return 1;
c0108f15:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f1a:	eb 05                	jmp    c0108f21 <__intr_save+0x28>
    }
    return 0;
c0108f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f21:	c9                   	leave  
c0108f22:	c3                   	ret    

c0108f23 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108f23:	55                   	push   %ebp
c0108f24:	89 e5                	mov    %esp,%ebp
c0108f26:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108f29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108f2d:	74 05                	je     c0108f34 <__intr_restore+0x11>
        intr_enable();
c0108f2f:	e8 fa 8f ff ff       	call   c0101f2e <intr_enable>
    }
}
c0108f34:	c9                   	leave  
c0108f35:	c3                   	ret    

c0108f36 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108f36:	55                   	push   %ebp
c0108f37:	89 e5                	mov    %esp,%ebp
c0108f39:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108f3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f3f:	8b 00                	mov    (%eax),%eax
c0108f41:	83 f8 03             	cmp    $0x3,%eax
c0108f44:	74 0a                	je     c0108f50 <wakeup_proc+0x1a>
c0108f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f49:	8b 00                	mov    (%eax),%eax
c0108f4b:	83 f8 02             	cmp    $0x2,%eax
c0108f4e:	75 24                	jne    c0108f74 <wakeup_proc+0x3e>
c0108f50:	c7 44 24 0c ec bb 10 	movl   $0xc010bbec,0xc(%esp)
c0108f57:	c0 
c0108f58:	c7 44 24 08 27 bc 10 	movl   $0xc010bc27,0x8(%esp)
c0108f5f:	c0 
c0108f60:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0108f67:	00 
c0108f68:	c7 04 24 3c bc 10 c0 	movl   $0xc010bc3c,(%esp)
c0108f6f:	e8 68 7d ff ff       	call   c0100cdc <__panic>
    proc->state = PROC_RUNNABLE;
c0108f74:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f77:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0108f7d:	c9                   	leave  
c0108f7e:	c3                   	ret    

c0108f7f <schedule>:

void
schedule(void) {
c0108f7f:	55                   	push   %ebp
c0108f80:	89 e5                	mov    %esp,%ebp
c0108f82:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0108f85:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0108f8c:	e8 68 ff ff ff       	call   c0108ef9 <__intr_save>
c0108f91:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0108f94:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108f99:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0108fa0:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108fa6:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108fab:	39 c2                	cmp    %eax,%edx
c0108fad:	74 0a                	je     c0108fb9 <schedule+0x3a>
c0108faf:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108fb4:	83 c0 58             	add    $0x58,%eax
c0108fb7:	eb 05                	jmp    c0108fbe <schedule+0x3f>
c0108fb9:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c0108fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0108fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108fcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fd0:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0108fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108fd6:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c0108fdd:	74 15                	je     c0108ff4 <schedule+0x75>
                next = le2proc(le, list_link);
c0108fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fe2:	83 e8 58             	sub    $0x58,%eax
c0108fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0108fe8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108feb:	8b 00                	mov    (%eax),%eax
c0108fed:	83 f8 02             	cmp    $0x2,%eax
c0108ff0:	75 02                	jne    c0108ff4 <schedule+0x75>
                    break;
c0108ff2:	eb 08                	jmp    c0108ffc <schedule+0x7d>
                }
            }
        } while (le != last);
c0108ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ff7:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0108ffa:	75 cb                	jne    c0108fc7 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c0108ffc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109000:	74 0a                	je     c010900c <schedule+0x8d>
c0109002:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109005:	8b 00                	mov    (%eax),%eax
c0109007:	83 f8 02             	cmp    $0x2,%eax
c010900a:	74 08                	je     c0109014 <schedule+0x95>
            next = idleproc;
c010900c:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109011:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109014:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109017:	8b 40 08             	mov    0x8(%eax),%eax
c010901a:	8d 50 01             	lea    0x1(%eax),%edx
c010901d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109020:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109023:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109028:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010902b:	74 0b                	je     c0109038 <schedule+0xb9>
            proc_run(next);
c010902d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109030:	89 04 24             	mov    %eax,(%esp)
c0109033:	e8 9c f7 ff ff       	call   c01087d4 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010903b:	89 04 24             	mov    %eax,(%esp)
c010903e:	e8 e0 fe ff ff       	call   c0108f23 <__intr_restore>
}
c0109043:	c9                   	leave  
c0109044:	c3                   	ret    

c0109045 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109045:	55                   	push   %ebp
c0109046:	89 e5                	mov    %esp,%ebp
c0109048:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010904b:	8b 45 08             	mov    0x8(%ebp),%eax
c010904e:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109054:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109057:	b8 20 00 00 00       	mov    $0x20,%eax
c010905c:	2b 45 0c             	sub    0xc(%ebp),%eax
c010905f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109062:	89 c1                	mov    %eax,%ecx
c0109064:	d3 ea                	shr    %cl,%edx
c0109066:	89 d0                	mov    %edx,%eax
}
c0109068:	c9                   	leave  
c0109069:	c3                   	ret    

c010906a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010906a:	55                   	push   %ebp
c010906b:	89 e5                	mov    %esp,%ebp
c010906d:	83 ec 58             	sub    $0x58,%esp
c0109070:	8b 45 10             	mov    0x10(%ebp),%eax
c0109073:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109076:	8b 45 14             	mov    0x14(%ebp),%eax
c0109079:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010907c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010907f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109082:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109085:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109088:	8b 45 18             	mov    0x18(%ebp),%eax
c010908b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010908e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109091:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109094:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109097:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010909a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010909d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01090a4:	74 1c                	je     c01090c2 <printnum+0x58>
c01090a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01090ae:	f7 75 e4             	divl   -0x1c(%ebp)
c01090b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090b7:	ba 00 00 00 00       	mov    $0x0,%edx
c01090bc:	f7 75 e4             	divl   -0x1c(%ebp)
c01090bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090c8:	f7 75 e4             	divl   -0x1c(%ebp)
c01090cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01090ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01090d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01090d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01090da:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01090dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01090e0:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01090e3:	8b 45 18             	mov    0x18(%ebp),%eax
c01090e6:	ba 00 00 00 00       	mov    $0x0,%edx
c01090eb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01090ee:	77 56                	ja     c0109146 <printnum+0xdc>
c01090f0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01090f3:	72 05                	jb     c01090fa <printnum+0x90>
c01090f5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01090f8:	77 4c                	ja     c0109146 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01090fa:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01090fd:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109100:	8b 45 20             	mov    0x20(%ebp),%eax
c0109103:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109107:	89 54 24 14          	mov    %edx,0x14(%esp)
c010910b:	8b 45 18             	mov    0x18(%ebp),%eax
c010910e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109112:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109115:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109118:	89 44 24 08          	mov    %eax,0x8(%esp)
c010911c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109120:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109123:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109127:	8b 45 08             	mov    0x8(%ebp),%eax
c010912a:	89 04 24             	mov    %eax,(%esp)
c010912d:	e8 38 ff ff ff       	call   c010906a <printnum>
c0109132:	eb 1c                	jmp    c0109150 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109134:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109137:	89 44 24 04          	mov    %eax,0x4(%esp)
c010913b:	8b 45 20             	mov    0x20(%ebp),%eax
c010913e:	89 04 24             	mov    %eax,(%esp)
c0109141:	8b 45 08             	mov    0x8(%ebp),%eax
c0109144:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109146:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010914a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010914e:	7f e4                	jg     c0109134 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0109150:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109153:	05 d4 bc 10 c0       	add    $0xc010bcd4,%eax
c0109158:	0f b6 00             	movzbl (%eax),%eax
c010915b:	0f be c0             	movsbl %al,%eax
c010915e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109161:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109165:	89 04 24             	mov    %eax,(%esp)
c0109168:	8b 45 08             	mov    0x8(%ebp),%eax
c010916b:	ff d0                	call   *%eax
}
c010916d:	c9                   	leave  
c010916e:	c3                   	ret    

c010916f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010916f:	55                   	push   %ebp
c0109170:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109172:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109176:	7e 14                	jle    c010918c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109178:	8b 45 08             	mov    0x8(%ebp),%eax
c010917b:	8b 00                	mov    (%eax),%eax
c010917d:	8d 48 08             	lea    0x8(%eax),%ecx
c0109180:	8b 55 08             	mov    0x8(%ebp),%edx
c0109183:	89 0a                	mov    %ecx,(%edx)
c0109185:	8b 50 04             	mov    0x4(%eax),%edx
c0109188:	8b 00                	mov    (%eax),%eax
c010918a:	eb 30                	jmp    c01091bc <getuint+0x4d>
    }
    else if (lflag) {
c010918c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109190:	74 16                	je     c01091a8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109192:	8b 45 08             	mov    0x8(%ebp),%eax
c0109195:	8b 00                	mov    (%eax),%eax
c0109197:	8d 48 04             	lea    0x4(%eax),%ecx
c010919a:	8b 55 08             	mov    0x8(%ebp),%edx
c010919d:	89 0a                	mov    %ecx,(%edx)
c010919f:	8b 00                	mov    (%eax),%eax
c01091a1:	ba 00 00 00 00       	mov    $0x0,%edx
c01091a6:	eb 14                	jmp    c01091bc <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01091a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ab:	8b 00                	mov    (%eax),%eax
c01091ad:	8d 48 04             	lea    0x4(%eax),%ecx
c01091b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01091b3:	89 0a                	mov    %ecx,(%edx)
c01091b5:	8b 00                	mov    (%eax),%eax
c01091b7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01091bc:	5d                   	pop    %ebp
c01091bd:	c3                   	ret    

c01091be <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01091be:	55                   	push   %ebp
c01091bf:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01091c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01091c5:	7e 14                	jle    c01091db <getint+0x1d>
        return va_arg(*ap, long long);
c01091c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ca:	8b 00                	mov    (%eax),%eax
c01091cc:	8d 48 08             	lea    0x8(%eax),%ecx
c01091cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01091d2:	89 0a                	mov    %ecx,(%edx)
c01091d4:	8b 50 04             	mov    0x4(%eax),%edx
c01091d7:	8b 00                	mov    (%eax),%eax
c01091d9:	eb 28                	jmp    c0109203 <getint+0x45>
    }
    else if (lflag) {
c01091db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01091df:	74 12                	je     c01091f3 <getint+0x35>
        return va_arg(*ap, long);
c01091e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01091e4:	8b 00                	mov    (%eax),%eax
c01091e6:	8d 48 04             	lea    0x4(%eax),%ecx
c01091e9:	8b 55 08             	mov    0x8(%ebp),%edx
c01091ec:	89 0a                	mov    %ecx,(%edx)
c01091ee:	8b 00                	mov    (%eax),%eax
c01091f0:	99                   	cltd   
c01091f1:	eb 10                	jmp    c0109203 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01091f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f6:	8b 00                	mov    (%eax),%eax
c01091f8:	8d 48 04             	lea    0x4(%eax),%ecx
c01091fb:	8b 55 08             	mov    0x8(%ebp),%edx
c01091fe:	89 0a                	mov    %ecx,(%edx)
c0109200:	8b 00                	mov    (%eax),%eax
c0109202:	99                   	cltd   
    }
}
c0109203:	5d                   	pop    %ebp
c0109204:	c3                   	ret    

c0109205 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109205:	55                   	push   %ebp
c0109206:	89 e5                	mov    %esp,%ebp
c0109208:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010920b:	8d 45 14             	lea    0x14(%ebp),%eax
c010920e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109211:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109214:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109218:	8b 45 10             	mov    0x10(%ebp),%eax
c010921b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010921f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109222:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109226:	8b 45 08             	mov    0x8(%ebp),%eax
c0109229:	89 04 24             	mov    %eax,(%esp)
c010922c:	e8 02 00 00 00       	call   c0109233 <vprintfmt>
    va_end(ap);
}
c0109231:	c9                   	leave  
c0109232:	c3                   	ret    

c0109233 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109233:	55                   	push   %ebp
c0109234:	89 e5                	mov    %esp,%ebp
c0109236:	56                   	push   %esi
c0109237:	53                   	push   %ebx
c0109238:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010923b:	eb 18                	jmp    c0109255 <vprintfmt+0x22>
            if (ch == '\0') {
c010923d:	85 db                	test   %ebx,%ebx
c010923f:	75 05                	jne    c0109246 <vprintfmt+0x13>
                return;
c0109241:	e9 d1 03 00 00       	jmp    c0109617 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109246:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109249:	89 44 24 04          	mov    %eax,0x4(%esp)
c010924d:	89 1c 24             	mov    %ebx,(%esp)
c0109250:	8b 45 08             	mov    0x8(%ebp),%eax
c0109253:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109255:	8b 45 10             	mov    0x10(%ebp),%eax
c0109258:	8d 50 01             	lea    0x1(%eax),%edx
c010925b:	89 55 10             	mov    %edx,0x10(%ebp)
c010925e:	0f b6 00             	movzbl (%eax),%eax
c0109261:	0f b6 d8             	movzbl %al,%ebx
c0109264:	83 fb 25             	cmp    $0x25,%ebx
c0109267:	75 d4                	jne    c010923d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0109269:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010926d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109274:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109277:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010927a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109281:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109284:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109287:	8b 45 10             	mov    0x10(%ebp),%eax
c010928a:	8d 50 01             	lea    0x1(%eax),%edx
c010928d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109290:	0f b6 00             	movzbl (%eax),%eax
c0109293:	0f b6 d8             	movzbl %al,%ebx
c0109296:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0109299:	83 f8 55             	cmp    $0x55,%eax
c010929c:	0f 87 44 03 00 00    	ja     c01095e6 <vprintfmt+0x3b3>
c01092a2:	8b 04 85 f8 bc 10 c0 	mov    -0x3fef4308(,%eax,4),%eax
c01092a9:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01092ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01092af:	eb d6                	jmp    c0109287 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01092b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01092b5:	eb d0                	jmp    c0109287 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01092b7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01092be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01092c1:	89 d0                	mov    %edx,%eax
c01092c3:	c1 e0 02             	shl    $0x2,%eax
c01092c6:	01 d0                	add    %edx,%eax
c01092c8:	01 c0                	add    %eax,%eax
c01092ca:	01 d8                	add    %ebx,%eax
c01092cc:	83 e8 30             	sub    $0x30,%eax
c01092cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01092d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01092d5:	0f b6 00             	movzbl (%eax),%eax
c01092d8:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01092db:	83 fb 2f             	cmp    $0x2f,%ebx
c01092de:	7e 0b                	jle    c01092eb <vprintfmt+0xb8>
c01092e0:	83 fb 39             	cmp    $0x39,%ebx
c01092e3:	7f 06                	jg     c01092eb <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01092e5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01092e9:	eb d3                	jmp    c01092be <vprintfmt+0x8b>
            goto process_precision;
c01092eb:	eb 33                	jmp    c0109320 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01092ed:	8b 45 14             	mov    0x14(%ebp),%eax
c01092f0:	8d 50 04             	lea    0x4(%eax),%edx
c01092f3:	89 55 14             	mov    %edx,0x14(%ebp)
c01092f6:	8b 00                	mov    (%eax),%eax
c01092f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01092fb:	eb 23                	jmp    c0109320 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01092fd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109301:	79 0c                	jns    c010930f <vprintfmt+0xdc>
                width = 0;
c0109303:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010930a:	e9 78 ff ff ff       	jmp    c0109287 <vprintfmt+0x54>
c010930f:	e9 73 ff ff ff       	jmp    c0109287 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109314:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010931b:	e9 67 ff ff ff       	jmp    c0109287 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0109320:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109324:	79 12                	jns    c0109338 <vprintfmt+0x105>
                width = precision, precision = -1;
c0109326:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109329:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010932c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109333:	e9 4f ff ff ff       	jmp    c0109287 <vprintfmt+0x54>
c0109338:	e9 4a ff ff ff       	jmp    c0109287 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010933d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109341:	e9 41 ff ff ff       	jmp    c0109287 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109346:	8b 45 14             	mov    0x14(%ebp),%eax
c0109349:	8d 50 04             	lea    0x4(%eax),%edx
c010934c:	89 55 14             	mov    %edx,0x14(%ebp)
c010934f:	8b 00                	mov    (%eax),%eax
c0109351:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109354:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109358:	89 04 24             	mov    %eax,(%esp)
c010935b:	8b 45 08             	mov    0x8(%ebp),%eax
c010935e:	ff d0                	call   *%eax
            break;
c0109360:	e9 ac 02 00 00       	jmp    c0109611 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109365:	8b 45 14             	mov    0x14(%ebp),%eax
c0109368:	8d 50 04             	lea    0x4(%eax),%edx
c010936b:	89 55 14             	mov    %edx,0x14(%ebp)
c010936e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109370:	85 db                	test   %ebx,%ebx
c0109372:	79 02                	jns    c0109376 <vprintfmt+0x143>
                err = -err;
c0109374:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109376:	83 fb 06             	cmp    $0x6,%ebx
c0109379:	7f 0b                	jg     c0109386 <vprintfmt+0x153>
c010937b:	8b 34 9d b8 bc 10 c0 	mov    -0x3fef4348(,%ebx,4),%esi
c0109382:	85 f6                	test   %esi,%esi
c0109384:	75 23                	jne    c01093a9 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109386:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010938a:	c7 44 24 08 e5 bc 10 	movl   $0xc010bce5,0x8(%esp)
c0109391:	c0 
c0109392:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109395:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109399:	8b 45 08             	mov    0x8(%ebp),%eax
c010939c:	89 04 24             	mov    %eax,(%esp)
c010939f:	e8 61 fe ff ff       	call   c0109205 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01093a4:	e9 68 02 00 00       	jmp    c0109611 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01093a9:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01093ad:	c7 44 24 08 ee bc 10 	movl   $0xc010bcee,0x8(%esp)
c01093b4:	c0 
c01093b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01093bf:	89 04 24             	mov    %eax,(%esp)
c01093c2:	e8 3e fe ff ff       	call   c0109205 <printfmt>
            }
            break;
c01093c7:	e9 45 02 00 00       	jmp    c0109611 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01093cc:	8b 45 14             	mov    0x14(%ebp),%eax
c01093cf:	8d 50 04             	lea    0x4(%eax),%edx
c01093d2:	89 55 14             	mov    %edx,0x14(%ebp)
c01093d5:	8b 30                	mov    (%eax),%esi
c01093d7:	85 f6                	test   %esi,%esi
c01093d9:	75 05                	jne    c01093e0 <vprintfmt+0x1ad>
                p = "(null)";
c01093db:	be f1 bc 10 c0       	mov    $0xc010bcf1,%esi
            }
            if (width > 0 && padc != '-') {
c01093e0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01093e4:	7e 3e                	jle    c0109424 <vprintfmt+0x1f1>
c01093e6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01093ea:	74 38                	je     c0109424 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01093ec:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01093ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01093f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093f6:	89 34 24             	mov    %esi,(%esp)
c01093f9:	e8 ed 03 00 00       	call   c01097eb <strnlen>
c01093fe:	29 c3                	sub    %eax,%ebx
c0109400:	89 d8                	mov    %ebx,%eax
c0109402:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109405:	eb 17                	jmp    c010941e <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109407:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010940b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010940e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109412:	89 04 24             	mov    %eax,(%esp)
c0109415:	8b 45 08             	mov    0x8(%ebp),%eax
c0109418:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010941a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010941e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109422:	7f e3                	jg     c0109407 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109424:	eb 38                	jmp    c010945e <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109426:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010942a:	74 1f                	je     c010944b <vprintfmt+0x218>
c010942c:	83 fb 1f             	cmp    $0x1f,%ebx
c010942f:	7e 05                	jle    c0109436 <vprintfmt+0x203>
c0109431:	83 fb 7e             	cmp    $0x7e,%ebx
c0109434:	7e 15                	jle    c010944b <vprintfmt+0x218>
                    putch('?', putdat);
c0109436:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109439:	89 44 24 04          	mov    %eax,0x4(%esp)
c010943d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109444:	8b 45 08             	mov    0x8(%ebp),%eax
c0109447:	ff d0                	call   *%eax
c0109449:	eb 0f                	jmp    c010945a <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010944b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010944e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109452:	89 1c 24             	mov    %ebx,(%esp)
c0109455:	8b 45 08             	mov    0x8(%ebp),%eax
c0109458:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010945a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010945e:	89 f0                	mov    %esi,%eax
c0109460:	8d 70 01             	lea    0x1(%eax),%esi
c0109463:	0f b6 00             	movzbl (%eax),%eax
c0109466:	0f be d8             	movsbl %al,%ebx
c0109469:	85 db                	test   %ebx,%ebx
c010946b:	74 10                	je     c010947d <vprintfmt+0x24a>
c010946d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109471:	78 b3                	js     c0109426 <vprintfmt+0x1f3>
c0109473:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109477:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010947b:	79 a9                	jns    c0109426 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010947d:	eb 17                	jmp    c0109496 <vprintfmt+0x263>
                putch(' ', putdat);
c010947f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109482:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109486:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010948d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109490:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109492:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109496:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010949a:	7f e3                	jg     c010947f <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010949c:	e9 70 01 00 00       	jmp    c0109611 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01094a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01094a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094a8:	8d 45 14             	lea    0x14(%ebp),%eax
c01094ab:	89 04 24             	mov    %eax,(%esp)
c01094ae:	e8 0b fd ff ff       	call   c01091be <getint>
c01094b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01094b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01094bf:	85 d2                	test   %edx,%edx
c01094c1:	79 26                	jns    c01094e9 <vprintfmt+0x2b6>
                putch('-', putdat);
c01094c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094ca:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01094d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01094d4:	ff d0                	call   *%eax
                num = -(long long)num;
c01094d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01094dc:	f7 d8                	neg    %eax
c01094de:	83 d2 00             	adc    $0x0,%edx
c01094e1:	f7 da                	neg    %edx
c01094e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01094e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01094f0:	e9 a8 00 00 00       	jmp    c010959d <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01094f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01094f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094fc:	8d 45 14             	lea    0x14(%ebp),%eax
c01094ff:	89 04 24             	mov    %eax,(%esp)
c0109502:	e8 68 fc ff ff       	call   c010916f <getuint>
c0109507:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010950a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010950d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109514:	e9 84 00 00 00       	jmp    c010959d <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109519:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010951c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109520:	8d 45 14             	lea    0x14(%ebp),%eax
c0109523:	89 04 24             	mov    %eax,(%esp)
c0109526:	e8 44 fc ff ff       	call   c010916f <getuint>
c010952b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010952e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109531:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109538:	eb 63                	jmp    c010959d <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010953a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010953d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109541:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109548:	8b 45 08             	mov    0x8(%ebp),%eax
c010954b:	ff d0                	call   *%eax
            putch('x', putdat);
c010954d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109550:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109554:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010955b:	8b 45 08             	mov    0x8(%ebp),%eax
c010955e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109560:	8b 45 14             	mov    0x14(%ebp),%eax
c0109563:	8d 50 04             	lea    0x4(%eax),%edx
c0109566:	89 55 14             	mov    %edx,0x14(%ebp)
c0109569:	8b 00                	mov    (%eax),%eax
c010956b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010956e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109575:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010957c:	eb 1f                	jmp    c010959d <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010957e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109581:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109585:	8d 45 14             	lea    0x14(%ebp),%eax
c0109588:	89 04 24             	mov    %eax,(%esp)
c010958b:	e8 df fb ff ff       	call   c010916f <getuint>
c0109590:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109593:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0109596:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010959d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01095a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095a4:	89 54 24 18          	mov    %edx,0x18(%esp)
c01095a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095ab:	89 54 24 14          	mov    %edx,0x14(%esp)
c01095af:	89 44 24 10          	mov    %eax,0x10(%esp)
c01095b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01095b9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01095bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01095c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01095cb:	89 04 24             	mov    %eax,(%esp)
c01095ce:	e8 97 fa ff ff       	call   c010906a <printnum>
            break;
c01095d3:	eb 3c                	jmp    c0109611 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01095d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095dc:	89 1c 24             	mov    %ebx,(%esp)
c01095df:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e2:	ff d0                	call   *%eax
            break;
c01095e4:	eb 2b                	jmp    c0109611 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01095e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095ed:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01095f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01095f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01095fd:	eb 04                	jmp    c0109603 <vprintfmt+0x3d0>
c01095ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109603:	8b 45 10             	mov    0x10(%ebp),%eax
c0109606:	83 e8 01             	sub    $0x1,%eax
c0109609:	0f b6 00             	movzbl (%eax),%eax
c010960c:	3c 25                	cmp    $0x25,%al
c010960e:	75 ef                	jne    c01095ff <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0109610:	90                   	nop
        }
    }
c0109611:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109612:	e9 3e fc ff ff       	jmp    c0109255 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109617:	83 c4 40             	add    $0x40,%esp
c010961a:	5b                   	pop    %ebx
c010961b:	5e                   	pop    %esi
c010961c:	5d                   	pop    %ebp
c010961d:	c3                   	ret    

c010961e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010961e:	55                   	push   %ebp
c010961f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109621:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109624:	8b 40 08             	mov    0x8(%eax),%eax
c0109627:	8d 50 01             	lea    0x1(%eax),%edx
c010962a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010962d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0109630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109633:	8b 10                	mov    (%eax),%edx
c0109635:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109638:	8b 40 04             	mov    0x4(%eax),%eax
c010963b:	39 c2                	cmp    %eax,%edx
c010963d:	73 12                	jae    c0109651 <sprintputch+0x33>
        *b->buf ++ = ch;
c010963f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109642:	8b 00                	mov    (%eax),%eax
c0109644:	8d 48 01             	lea    0x1(%eax),%ecx
c0109647:	8b 55 0c             	mov    0xc(%ebp),%edx
c010964a:	89 0a                	mov    %ecx,(%edx)
c010964c:	8b 55 08             	mov    0x8(%ebp),%edx
c010964f:	88 10                	mov    %dl,(%eax)
    }
}
c0109651:	5d                   	pop    %ebp
c0109652:	c3                   	ret    

c0109653 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109653:	55                   	push   %ebp
c0109654:	89 e5                	mov    %esp,%ebp
c0109656:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109659:	8d 45 14             	lea    0x14(%ebp),%eax
c010965c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010965f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109662:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109666:	8b 45 10             	mov    0x10(%ebp),%eax
c0109669:	89 44 24 08          	mov    %eax,0x8(%esp)
c010966d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109670:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109674:	8b 45 08             	mov    0x8(%ebp),%eax
c0109677:	89 04 24             	mov    %eax,(%esp)
c010967a:	e8 08 00 00 00       	call   c0109687 <vsnprintf>
c010967f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109682:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109685:	c9                   	leave  
c0109686:	c3                   	ret    

c0109687 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109687:	55                   	push   %ebp
c0109688:	89 e5                	mov    %esp,%ebp
c010968a:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010968d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109690:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109696:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109699:	8b 45 08             	mov    0x8(%ebp),%eax
c010969c:	01 d0                	add    %edx,%eax
c010969e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01096a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01096ac:	74 0a                	je     c01096b8 <vsnprintf+0x31>
c01096ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01096b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096b4:	39 c2                	cmp    %eax,%edx
c01096b6:	76 07                	jbe    c01096bf <vsnprintf+0x38>
        return -E_INVAL;
c01096b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01096bd:	eb 2a                	jmp    c01096e9 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01096bf:	8b 45 14             	mov    0x14(%ebp),%eax
c01096c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01096c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01096c9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01096d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096d4:	c7 04 24 1e 96 10 c0 	movl   $0xc010961e,(%esp)
c01096db:	e8 53 fb ff ff       	call   c0109233 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01096e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01096e3:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01096e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096e9:	c9                   	leave  
c01096ea:	c3                   	ret    

c01096eb <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01096eb:	55                   	push   %ebp
c01096ec:	89 e5                	mov    %esp,%ebp
c01096ee:	57                   	push   %edi
c01096ef:	56                   	push   %esi
c01096f0:	53                   	push   %ebx
c01096f1:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01096f4:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c01096f9:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c01096ff:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109705:	6b f0 05             	imul   $0x5,%eax,%esi
c0109708:	01 f7                	add    %esi,%edi
c010970a:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010970f:	f7 e6                	mul    %esi
c0109711:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109714:	89 f2                	mov    %esi,%edx
c0109716:	83 c0 0b             	add    $0xb,%eax
c0109719:	83 d2 00             	adc    $0x0,%edx
c010971c:	89 c7                	mov    %eax,%edi
c010971e:	83 e7 ff             	and    $0xffffffff,%edi
c0109721:	89 f9                	mov    %edi,%ecx
c0109723:	0f b7 da             	movzwl %dx,%ebx
c0109726:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c010972c:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c0109732:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109737:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010973d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109741:	c1 ea 0c             	shr    $0xc,%edx
c0109744:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109747:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010974a:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109751:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109754:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109757:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010975a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010975d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109760:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109763:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109767:	74 1c                	je     c0109785 <rand+0x9a>
c0109769:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010976c:	ba 00 00 00 00       	mov    $0x0,%edx
c0109771:	f7 75 dc             	divl   -0x24(%ebp)
c0109774:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109777:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010977a:	ba 00 00 00 00       	mov    $0x0,%edx
c010977f:	f7 75 dc             	divl   -0x24(%ebp)
c0109782:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109785:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109788:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010978b:	f7 75 dc             	divl   -0x24(%ebp)
c010978e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109791:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109794:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109797:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010979a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010979d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01097a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01097a3:	83 c4 24             	add    $0x24,%esp
c01097a6:	5b                   	pop    %ebx
c01097a7:	5e                   	pop    %esi
c01097a8:	5f                   	pop    %edi
c01097a9:	5d                   	pop    %ebp
c01097aa:	c3                   	ret    

c01097ab <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01097ab:	55                   	push   %ebp
c01097ac:	89 e5                	mov    %esp,%ebp
    next = seed;
c01097ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01097b1:	ba 00 00 00 00       	mov    $0x0,%edx
c01097b6:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c01097bb:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c01097c1:	5d                   	pop    %ebp
c01097c2:	c3                   	ret    

c01097c3 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01097c3:	55                   	push   %ebp
c01097c4:	89 e5                	mov    %esp,%ebp
c01097c6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01097c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01097d0:	eb 04                	jmp    c01097d6 <strlen+0x13>
        cnt ++;
c01097d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01097d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01097d9:	8d 50 01             	lea    0x1(%eax),%edx
c01097dc:	89 55 08             	mov    %edx,0x8(%ebp)
c01097df:	0f b6 00             	movzbl (%eax),%eax
c01097e2:	84 c0                	test   %al,%al
c01097e4:	75 ec                	jne    c01097d2 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01097e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01097e9:	c9                   	leave  
c01097ea:	c3                   	ret    

c01097eb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01097eb:	55                   	push   %ebp
c01097ec:	89 e5                	mov    %esp,%ebp
c01097ee:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01097f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01097f8:	eb 04                	jmp    c01097fe <strnlen+0x13>
        cnt ++;
c01097fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01097fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109801:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109804:	73 10                	jae    c0109816 <strnlen+0x2b>
c0109806:	8b 45 08             	mov    0x8(%ebp),%eax
c0109809:	8d 50 01             	lea    0x1(%eax),%edx
c010980c:	89 55 08             	mov    %edx,0x8(%ebp)
c010980f:	0f b6 00             	movzbl (%eax),%eax
c0109812:	84 c0                	test   %al,%al
c0109814:	75 e4                	jne    c01097fa <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109819:	c9                   	leave  
c010981a:	c3                   	ret    

c010981b <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010981b:	55                   	push   %ebp
c010981c:	89 e5                	mov    %esp,%ebp
c010981e:	57                   	push   %edi
c010981f:	56                   	push   %esi
c0109820:	83 ec 20             	sub    $0x20,%esp
c0109823:	8b 45 08             	mov    0x8(%ebp),%eax
c0109826:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010982c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010982f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109832:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109835:	89 d1                	mov    %edx,%ecx
c0109837:	89 c2                	mov    %eax,%edx
c0109839:	89 ce                	mov    %ecx,%esi
c010983b:	89 d7                	mov    %edx,%edi
c010983d:	ac                   	lods   %ds:(%esi),%al
c010983e:	aa                   	stos   %al,%es:(%edi)
c010983f:	84 c0                	test   %al,%al
c0109841:	75 fa                	jne    c010983d <strcpy+0x22>
c0109843:	89 fa                	mov    %edi,%edx
c0109845:	89 f1                	mov    %esi,%ecx
c0109847:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010984a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010984d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109850:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109853:	83 c4 20             	add    $0x20,%esp
c0109856:	5e                   	pop    %esi
c0109857:	5f                   	pop    %edi
c0109858:	5d                   	pop    %ebp
c0109859:	c3                   	ret    

c010985a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010985a:	55                   	push   %ebp
c010985b:	89 e5                	mov    %esp,%ebp
c010985d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109860:	8b 45 08             	mov    0x8(%ebp),%eax
c0109863:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109866:	eb 21                	jmp    c0109889 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109868:	8b 45 0c             	mov    0xc(%ebp),%eax
c010986b:	0f b6 10             	movzbl (%eax),%edx
c010986e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109871:	88 10                	mov    %dl,(%eax)
c0109873:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109876:	0f b6 00             	movzbl (%eax),%eax
c0109879:	84 c0                	test   %al,%al
c010987b:	74 04                	je     c0109881 <strncpy+0x27>
            src ++;
c010987d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109881:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109885:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0109889:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010988d:	75 d9                	jne    c0109868 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010988f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109892:	c9                   	leave  
c0109893:	c3                   	ret    

c0109894 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109894:	55                   	push   %ebp
c0109895:	89 e5                	mov    %esp,%ebp
c0109897:	57                   	push   %edi
c0109898:	56                   	push   %esi
c0109899:	83 ec 20             	sub    $0x20,%esp
c010989c:	8b 45 08             	mov    0x8(%ebp),%eax
c010989f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01098a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01098a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098ae:	89 d1                	mov    %edx,%ecx
c01098b0:	89 c2                	mov    %eax,%edx
c01098b2:	89 ce                	mov    %ecx,%esi
c01098b4:	89 d7                	mov    %edx,%edi
c01098b6:	ac                   	lods   %ds:(%esi),%al
c01098b7:	ae                   	scas   %es:(%edi),%al
c01098b8:	75 08                	jne    c01098c2 <strcmp+0x2e>
c01098ba:	84 c0                	test   %al,%al
c01098bc:	75 f8                	jne    c01098b6 <strcmp+0x22>
c01098be:	31 c0                	xor    %eax,%eax
c01098c0:	eb 04                	jmp    c01098c6 <strcmp+0x32>
c01098c2:	19 c0                	sbb    %eax,%eax
c01098c4:	0c 01                	or     $0x1,%al
c01098c6:	89 fa                	mov    %edi,%edx
c01098c8:	89 f1                	mov    %esi,%ecx
c01098ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01098cd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01098d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01098d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01098d6:	83 c4 20             	add    $0x20,%esp
c01098d9:	5e                   	pop    %esi
c01098da:	5f                   	pop    %edi
c01098db:	5d                   	pop    %ebp
c01098dc:	c3                   	ret    

c01098dd <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01098dd:	55                   	push   %ebp
c01098de:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01098e0:	eb 0c                	jmp    c01098ee <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01098e2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01098e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01098ea:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01098ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01098f2:	74 1a                	je     c010990e <strncmp+0x31>
c01098f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01098f7:	0f b6 00             	movzbl (%eax),%eax
c01098fa:	84 c0                	test   %al,%al
c01098fc:	74 10                	je     c010990e <strncmp+0x31>
c01098fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109901:	0f b6 10             	movzbl (%eax),%edx
c0109904:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109907:	0f b6 00             	movzbl (%eax),%eax
c010990a:	38 c2                	cmp    %al,%dl
c010990c:	74 d4                	je     c01098e2 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010990e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109912:	74 18                	je     c010992c <strncmp+0x4f>
c0109914:	8b 45 08             	mov    0x8(%ebp),%eax
c0109917:	0f b6 00             	movzbl (%eax),%eax
c010991a:	0f b6 d0             	movzbl %al,%edx
c010991d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109920:	0f b6 00             	movzbl (%eax),%eax
c0109923:	0f b6 c0             	movzbl %al,%eax
c0109926:	29 c2                	sub    %eax,%edx
c0109928:	89 d0                	mov    %edx,%eax
c010992a:	eb 05                	jmp    c0109931 <strncmp+0x54>
c010992c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109931:	5d                   	pop    %ebp
c0109932:	c3                   	ret    

c0109933 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109933:	55                   	push   %ebp
c0109934:	89 e5                	mov    %esp,%ebp
c0109936:	83 ec 04             	sub    $0x4,%esp
c0109939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010993c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010993f:	eb 14                	jmp    c0109955 <strchr+0x22>
        if (*s == c) {
c0109941:	8b 45 08             	mov    0x8(%ebp),%eax
c0109944:	0f b6 00             	movzbl (%eax),%eax
c0109947:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010994a:	75 05                	jne    c0109951 <strchr+0x1e>
            return (char *)s;
c010994c:	8b 45 08             	mov    0x8(%ebp),%eax
c010994f:	eb 13                	jmp    c0109964 <strchr+0x31>
        }
        s ++;
c0109951:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109955:	8b 45 08             	mov    0x8(%ebp),%eax
c0109958:	0f b6 00             	movzbl (%eax),%eax
c010995b:	84 c0                	test   %al,%al
c010995d:	75 e2                	jne    c0109941 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010995f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109964:	c9                   	leave  
c0109965:	c3                   	ret    

c0109966 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109966:	55                   	push   %ebp
c0109967:	89 e5                	mov    %esp,%ebp
c0109969:	83 ec 04             	sub    $0x4,%esp
c010996c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010996f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109972:	eb 11                	jmp    c0109985 <strfind+0x1f>
        if (*s == c) {
c0109974:	8b 45 08             	mov    0x8(%ebp),%eax
c0109977:	0f b6 00             	movzbl (%eax),%eax
c010997a:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010997d:	75 02                	jne    c0109981 <strfind+0x1b>
            break;
c010997f:	eb 0e                	jmp    c010998f <strfind+0x29>
        }
        s ++;
c0109981:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109985:	8b 45 08             	mov    0x8(%ebp),%eax
c0109988:	0f b6 00             	movzbl (%eax),%eax
c010998b:	84 c0                	test   %al,%al
c010998d:	75 e5                	jne    c0109974 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010998f:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109992:	c9                   	leave  
c0109993:	c3                   	ret    

c0109994 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109994:	55                   	push   %ebp
c0109995:	89 e5                	mov    %esp,%ebp
c0109997:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010999a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01099a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099a8:	eb 04                	jmp    c01099ae <strtol+0x1a>
        s ++;
c01099aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b1:	0f b6 00             	movzbl (%eax),%eax
c01099b4:	3c 20                	cmp    $0x20,%al
c01099b6:	74 f2                	je     c01099aa <strtol+0x16>
c01099b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01099bb:	0f b6 00             	movzbl (%eax),%eax
c01099be:	3c 09                	cmp    $0x9,%al
c01099c0:	74 e8                	je     c01099aa <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01099c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c5:	0f b6 00             	movzbl (%eax),%eax
c01099c8:	3c 2b                	cmp    $0x2b,%al
c01099ca:	75 06                	jne    c01099d2 <strtol+0x3e>
        s ++;
c01099cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01099d0:	eb 15                	jmp    c01099e7 <strtol+0x53>
    }
    else if (*s == '-') {
c01099d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01099d5:	0f b6 00             	movzbl (%eax),%eax
c01099d8:	3c 2d                	cmp    $0x2d,%al
c01099da:	75 0b                	jne    c01099e7 <strtol+0x53>
        s ++, neg = 1;
c01099dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01099e0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01099e7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01099eb:	74 06                	je     c01099f3 <strtol+0x5f>
c01099ed:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01099f1:	75 24                	jne    c0109a17 <strtol+0x83>
c01099f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01099f6:	0f b6 00             	movzbl (%eax),%eax
c01099f9:	3c 30                	cmp    $0x30,%al
c01099fb:	75 1a                	jne    c0109a17 <strtol+0x83>
c01099fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a00:	83 c0 01             	add    $0x1,%eax
c0109a03:	0f b6 00             	movzbl (%eax),%eax
c0109a06:	3c 78                	cmp    $0x78,%al
c0109a08:	75 0d                	jne    c0109a17 <strtol+0x83>
        s += 2, base = 16;
c0109a0a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109a0e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109a15:	eb 2a                	jmp    c0109a41 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109a17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a1b:	75 17                	jne    c0109a34 <strtol+0xa0>
c0109a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a20:	0f b6 00             	movzbl (%eax),%eax
c0109a23:	3c 30                	cmp    $0x30,%al
c0109a25:	75 0d                	jne    c0109a34 <strtol+0xa0>
        s ++, base = 8;
c0109a27:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a2b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109a32:	eb 0d                	jmp    c0109a41 <strtol+0xad>
    }
    else if (base == 0) {
c0109a34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a38:	75 07                	jne    c0109a41 <strtol+0xad>
        base = 10;
c0109a3a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a44:	0f b6 00             	movzbl (%eax),%eax
c0109a47:	3c 2f                	cmp    $0x2f,%al
c0109a49:	7e 1b                	jle    c0109a66 <strtol+0xd2>
c0109a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a4e:	0f b6 00             	movzbl (%eax),%eax
c0109a51:	3c 39                	cmp    $0x39,%al
c0109a53:	7f 11                	jg     c0109a66 <strtol+0xd2>
            dig = *s - '0';
c0109a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a58:	0f b6 00             	movzbl (%eax),%eax
c0109a5b:	0f be c0             	movsbl %al,%eax
c0109a5e:	83 e8 30             	sub    $0x30,%eax
c0109a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a64:	eb 48                	jmp    c0109aae <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a69:	0f b6 00             	movzbl (%eax),%eax
c0109a6c:	3c 60                	cmp    $0x60,%al
c0109a6e:	7e 1b                	jle    c0109a8b <strtol+0xf7>
c0109a70:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a73:	0f b6 00             	movzbl (%eax),%eax
c0109a76:	3c 7a                	cmp    $0x7a,%al
c0109a78:	7f 11                	jg     c0109a8b <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109a7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a7d:	0f b6 00             	movzbl (%eax),%eax
c0109a80:	0f be c0             	movsbl %al,%eax
c0109a83:	83 e8 57             	sub    $0x57,%eax
c0109a86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a89:	eb 23                	jmp    c0109aae <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a8e:	0f b6 00             	movzbl (%eax),%eax
c0109a91:	3c 40                	cmp    $0x40,%al
c0109a93:	7e 3d                	jle    c0109ad2 <strtol+0x13e>
c0109a95:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a98:	0f b6 00             	movzbl (%eax),%eax
c0109a9b:	3c 5a                	cmp    $0x5a,%al
c0109a9d:	7f 33                	jg     c0109ad2 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aa2:	0f b6 00             	movzbl (%eax),%eax
c0109aa5:	0f be c0             	movsbl %al,%eax
c0109aa8:	83 e8 37             	sub    $0x37,%eax
c0109aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109ab4:	7c 02                	jl     c0109ab8 <strtol+0x124>
            break;
c0109ab6:	eb 1a                	jmp    c0109ad2 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109ab8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109abc:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109abf:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109ac3:	89 c2                	mov    %eax,%edx
c0109ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ac8:	01 d0                	add    %edx,%eax
c0109aca:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109acd:	e9 6f ff ff ff       	jmp    c0109a41 <strtol+0xad>

    if (endptr) {
c0109ad2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109ad6:	74 08                	je     c0109ae0 <strtol+0x14c>
        *endptr = (char *) s;
c0109ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109adb:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ade:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109ae0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109ae4:	74 07                	je     c0109aed <strtol+0x159>
c0109ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109ae9:	f7 d8                	neg    %eax
c0109aeb:	eb 03                	jmp    c0109af0 <strtol+0x15c>
c0109aed:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109af0:	c9                   	leave  
c0109af1:	c3                   	ret    

c0109af2 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109af2:	55                   	push   %ebp
c0109af3:	89 e5                	mov    %esp,%ebp
c0109af5:	57                   	push   %edi
c0109af6:	83 ec 24             	sub    $0x24,%esp
c0109af9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109afc:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109aff:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109b03:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b06:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109b09:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109b0c:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109b12:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109b15:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109b19:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109b1c:	89 d7                	mov    %edx,%edi
c0109b1e:	f3 aa                	rep stos %al,%es:(%edi)
c0109b20:	89 fa                	mov    %edi,%edx
c0109b22:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109b25:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109b28:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109b2b:	83 c4 24             	add    $0x24,%esp
c0109b2e:	5f                   	pop    %edi
c0109b2f:	5d                   	pop    %ebp
c0109b30:	c3                   	ret    

c0109b31 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109b31:	55                   	push   %ebp
c0109b32:	89 e5                	mov    %esp,%ebp
c0109b34:	57                   	push   %edi
c0109b35:	56                   	push   %esi
c0109b36:	53                   	push   %ebx
c0109b37:	83 ec 30             	sub    $0x30,%esp
c0109b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b43:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109b46:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b49:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109b52:	73 42                	jae    c0109b96 <memmove+0x65>
c0109b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109b60:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b63:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109b66:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109b69:	c1 e8 02             	shr    $0x2,%eax
c0109b6c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109b6e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109b74:	89 d7                	mov    %edx,%edi
c0109b76:	89 c6                	mov    %eax,%esi
c0109b78:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109b7a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109b7d:	83 e1 03             	and    $0x3,%ecx
c0109b80:	74 02                	je     c0109b84 <memmove+0x53>
c0109b82:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109b84:	89 f0                	mov    %esi,%eax
c0109b86:	89 fa                	mov    %edi,%edx
c0109b88:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109b8b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109b91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109b94:	eb 36                	jmp    c0109bcc <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109b96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b99:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b9f:	01 c2                	add    %eax,%edx
c0109ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ba4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109baa:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bb0:	89 c1                	mov    %eax,%ecx
c0109bb2:	89 d8                	mov    %ebx,%eax
c0109bb4:	89 d6                	mov    %edx,%esi
c0109bb6:	89 c7                	mov    %eax,%edi
c0109bb8:	fd                   	std    
c0109bb9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109bbb:	fc                   	cld    
c0109bbc:	89 f8                	mov    %edi,%eax
c0109bbe:	89 f2                	mov    %esi,%edx
c0109bc0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109bc3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109bc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109bcc:	83 c4 30             	add    $0x30,%esp
c0109bcf:	5b                   	pop    %ebx
c0109bd0:	5e                   	pop    %esi
c0109bd1:	5f                   	pop    %edi
c0109bd2:	5d                   	pop    %ebp
c0109bd3:	c3                   	ret    

c0109bd4 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109bd4:	55                   	push   %ebp
c0109bd5:	89 e5                	mov    %esp,%ebp
c0109bd7:	57                   	push   %edi
c0109bd8:	56                   	push   %esi
c0109bd9:	83 ec 20             	sub    $0x20,%esp
c0109bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109be8:	8b 45 10             	mov    0x10(%ebp),%eax
c0109beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bf1:	c1 e8 02             	shr    $0x2,%eax
c0109bf4:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109bf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bfc:	89 d7                	mov    %edx,%edi
c0109bfe:	89 c6                	mov    %eax,%esi
c0109c00:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c02:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109c05:	83 e1 03             	and    $0x3,%ecx
c0109c08:	74 02                	je     c0109c0c <memcpy+0x38>
c0109c0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c0c:	89 f0                	mov    %esi,%eax
c0109c0e:	89 fa                	mov    %edi,%edx
c0109c10:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109c13:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109c16:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109c1c:	83 c4 20             	add    $0x20,%esp
c0109c1f:	5e                   	pop    %esi
c0109c20:	5f                   	pop    %edi
c0109c21:	5d                   	pop    %ebp
c0109c22:	c3                   	ret    

c0109c23 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109c23:	55                   	push   %ebp
c0109c24:	89 e5                	mov    %esp,%ebp
c0109c26:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c32:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109c35:	eb 30                	jmp    c0109c67 <memcmp+0x44>
        if (*s1 != *s2) {
c0109c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c3a:	0f b6 10             	movzbl (%eax),%edx
c0109c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c40:	0f b6 00             	movzbl (%eax),%eax
c0109c43:	38 c2                	cmp    %al,%dl
c0109c45:	74 18                	je     c0109c5f <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c4a:	0f b6 00             	movzbl (%eax),%eax
c0109c4d:	0f b6 d0             	movzbl %al,%edx
c0109c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c53:	0f b6 00             	movzbl (%eax),%eax
c0109c56:	0f b6 c0             	movzbl %al,%eax
c0109c59:	29 c2                	sub    %eax,%edx
c0109c5b:	89 d0                	mov    %edx,%eax
c0109c5d:	eb 1a                	jmp    c0109c79 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109c5f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109c63:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109c67:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c6a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c6d:	89 55 10             	mov    %edx,0x10(%ebp)
c0109c70:	85 c0                	test   %eax,%eax
c0109c72:	75 c3                	jne    c0109c37 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109c79:	c9                   	leave  
c0109c7a:	c3                   	ret    
