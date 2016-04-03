
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018
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
c010001e:	bc 00 f0 11 c0       	mov    $0xc011f000,%esp
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
c0100030:	ba b0 0b 12 c0       	mov    $0xc0120bb0,%edx
c0100035:	b8 68 fa 11 c0       	mov    $0xc011fa68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 fa 11 c0 	movl   $0xc011fa68,(%esp)
c0100051:	e8 d6 88 00 00       	call   c010892c <memset>

    cons_init();                // init the console
c0100056:	e8 7f 15 00 00       	call   c01015da <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 8a 10 c0 	movl   $0xc0108ac0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 8a 10 c0 	movl   $0xc0108adc,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 70 4b 00 00       	call   c0104bf4 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 2f 1f 00 00       	call   c0101fb8 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 81 20 00 00       	call   c010210f <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 01 73 00 00       	call   c0107394 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 73 16 00 00       	call   c010170b <ide_init>
    swap_init();                // init swap
c0100098:	e8 26 5f 00 00       	call   c0105fc3 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 ee 0c 00 00       	call   c0100d90 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 7f 1e 00 00       	call   c0101f26 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 f7 0b 00 00       	call   c0100cc2 <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 e1 8a 10 c0 	movl   $0xc0108ae1,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 ef 8a 10 c0 	movl   $0xc0108aef,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 fd 8a 10 c0 	movl   $0xc0108afd,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 0b 8b 10 c0 	movl   $0xc0108b0b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 19 8b 10 c0 	movl   $0xc0108b19,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 fa 11 c0       	mov    %eax,0xc011fa80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 28 8b 10 c0 	movl   $0xc0108b28,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 48 8b 10 c0 	movl   $0xc0108b48,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 67 8b 10 c0 	movl   $0xc0108b67,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 fa 11 c0    	mov    %dl,-0x3fee0560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 fa 11 c0       	add    $0xc011faa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 fa 11 c0       	mov    $0xc011faa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 fd 12 00 00       	call   c0101606 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 27 7d 00 00       	call   c010806d <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 84 12 00 00       	call   c0101606 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 64 12 00 00       	call   c0101642 <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 6c 8b 10 c0    	movl   $0xc0108b6c,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 6c 8b 10 c0 	movl   $0xc0108b6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 98 a9 10 c0 	movl   $0xc010a998,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 1c 97 11 c0 	movl   $0xc011971c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 1d 97 11 c0 	movl   $0xc011971d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 9e cf 11 c0 	movl   $0xc011cf9e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 a5 80 00 00       	call   c01087a0 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 76 8b 10 c0 	movl   $0xc0108b76,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 8f 8b 10 c0 	movl   $0xc0108b8f,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 b5 8a 10 	movl   $0xc0108ab5,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 a7 8b 10 c0 	movl   $0xc0108ba7,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 fa 11 	movl   $0xc011fa68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 bf 8b 10 c0 	movl   $0xc0108bbf,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 0b 12 	movl   $0xc0120bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 d7 8b 10 c0 	movl   $0xc0108bd7,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 f0 8b 10 c0 	movl   $0xc0108bf0,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 1a 8c 10 c0 	movl   $0xc0108c1a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 36 8c 10 c0 	movl   $0xc0108c36,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	e9 8d 00 00 00       	jmp    c0100a7b <print_stackframe+0xb2>
		if (ebp == 0) break;
c01009ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01009f2:	75 05                	jne    c01009f9 <print_stackframe+0x30>
c01009f4:	e9 8c 00 00 00       	jmp    c0100a85 <print_stackframe+0xbc>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 48 8c 10 c0 	movl   $0xc0108c48,(%esp)
c0100a0e:	e8 38 f9 ff ff       	call   c010034b <cprintf>
		int j;
		for (j = 0; j < 4; ++j) cprintf("0x%08x ", ((uint32_t *) ebp + 2)[j]);
c0100a13:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a1a:	eb 28                	jmp    c0100a44 <print_stackframe+0x7b>
c0100a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a29:	01 d0                	add    %edx,%eax
c0100a2b:	83 c0 08             	add    $0x8,%eax
c0100a2e:	8b 00                	mov    (%eax),%eax
c0100a30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a34:	c7 04 24 64 8c 10 c0 	movl   $0xc0108c64,(%esp)
c0100a3b:	e8 0b f9 ff ff       	call   c010034b <cprintf>
c0100a40:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a44:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a48:	7e d2                	jle    c0100a1c <print_stackframe+0x53>
		cprintf("\n");
c0100a4a:	c7 04 24 6c 8c 10 c0 	movl   $0xc0108c6c,(%esp)
c0100a51:	e8 f5 f8 ff ff       	call   c010034b <cprintf>
		print_debuginfo(eip - 1);
c0100a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a59:	83 e8 01             	sub    $0x1,%eax
c0100a5c:	89 04 24             	mov    %eax,(%esp)
c0100a5f:	e8 b1 fe ff ff       	call   c0100915 <print_debuginfo>
		eip = *((uint32_t *) ebp + 1);
c0100a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a67:	83 c0 04             	add    $0x4,%eax
c0100a6a:	8b 00                	mov    (%eax),%eax
c0100a6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t *) ebp);
c0100a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a72:	8b 00                	mov    (%eax),%eax
c0100a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i;
	for (i = 0; i < STACKFRAME_DEPTH; ++i) {
c0100a77:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a7f:	0f 8e 69 ff ff ff    	jle    c01009ee <print_stackframe+0x25>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t *) ebp + 1);
		ebp = *((uint32_t *) ebp);
	}
}
c0100a85:	c9                   	leave  
c0100a86:	c3                   	ret    

c0100a87 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a87:	55                   	push   %ebp
c0100a88:	89 e5                	mov    %esp,%ebp
c0100a8a:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	eb 0c                	jmp    c0100aa2 <parse+0x1b>
            *buf ++ = '\0';
c0100a96:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a99:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9c:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9f:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa5:	0f b6 00             	movzbl (%eax),%eax
c0100aa8:	84 c0                	test   %al,%al
c0100aaa:	74 1d                	je     c0100ac9 <parse+0x42>
c0100aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaf:	0f b6 00             	movzbl (%eax),%eax
c0100ab2:	0f be c0             	movsbl %al,%eax
c0100ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab9:	c7 04 24 f0 8c 10 c0 	movl   $0xc0108cf0,(%esp)
c0100ac0:	e8 a8 7c 00 00       	call   c010876d <strchr>
c0100ac5:	85 c0                	test   %eax,%eax
c0100ac7:	75 cd                	jne    c0100a96 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acc:	0f b6 00             	movzbl (%eax),%eax
c0100acf:	84 c0                	test   %al,%al
c0100ad1:	75 02                	jne    c0100ad5 <parse+0x4e>
            break;
c0100ad3:	eb 67                	jmp    c0100b3c <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad9:	75 14                	jne    c0100aef <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100adb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae2:	00 
c0100ae3:	c7 04 24 f5 8c 10 c0 	movl   $0xc0108cf5,(%esp)
c0100aea:	e8 5c f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af2:	8d 50 01             	lea    0x1(%eax),%edx
c0100af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100aff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b02:	01 c2                	add    %eax,%edx
c0100b04:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b07:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b09:	eb 04                	jmp    c0100b0f <parse+0x88>
            buf ++;
c0100b0b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b12:	0f b6 00             	movzbl (%eax),%eax
c0100b15:	84 c0                	test   %al,%al
c0100b17:	74 1d                	je     c0100b36 <parse+0xaf>
c0100b19:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1c:	0f b6 00             	movzbl (%eax),%eax
c0100b1f:	0f be c0             	movsbl %al,%eax
c0100b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b26:	c7 04 24 f0 8c 10 c0 	movl   $0xc0108cf0,(%esp)
c0100b2d:	e8 3b 7c 00 00       	call   c010876d <strchr>
c0100b32:	85 c0                	test   %eax,%eax
c0100b34:	74 d5                	je     c0100b0b <parse+0x84>
            buf ++;
        }
    }
c0100b36:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b37:	e9 66 ff ff ff       	jmp    c0100aa2 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3f:	c9                   	leave  
c0100b40:	c3                   	ret    

c0100b41 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b41:	55                   	push   %ebp
c0100b42:	89 e5                	mov    %esp,%ebp
c0100b44:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b47:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b51:	89 04 24             	mov    %eax,(%esp)
c0100b54:	e8 2e ff ff ff       	call   c0100a87 <parse>
c0100b59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b60:	75 0a                	jne    c0100b6c <runcmd+0x2b>
        return 0;
c0100b62:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b67:	e9 85 00 00 00       	jmp    c0100bf1 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b73:	eb 5c                	jmp    c0100bd1 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b75:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7b:	89 d0                	mov    %edx,%eax
c0100b7d:	01 c0                	add    %eax,%eax
c0100b7f:	01 d0                	add    %edx,%eax
c0100b81:	c1 e0 02             	shl    $0x2,%eax
c0100b84:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100b89:	8b 00                	mov    (%eax),%eax
c0100b8b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8f:	89 04 24             	mov    %eax,(%esp)
c0100b92:	e8 37 7b 00 00       	call   c01086ce <strcmp>
c0100b97:	85 c0                	test   %eax,%eax
c0100b99:	75 32                	jne    c0100bcd <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9e:	89 d0                	mov    %edx,%eax
c0100ba0:	01 c0                	add    %eax,%eax
c0100ba2:	01 d0                	add    %edx,%eax
c0100ba4:	c1 e0 02             	shl    $0x2,%eax
c0100ba7:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100bac:	8b 40 08             	mov    0x8(%eax),%eax
c0100baf:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb2:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbc:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bbf:	83 c2 04             	add    $0x4,%edx
c0100bc2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc6:	89 0c 24             	mov    %ecx,(%esp)
c0100bc9:	ff d0                	call   *%eax
c0100bcb:	eb 24                	jmp    c0100bf1 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bcd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd4:	83 f8 02             	cmp    $0x2,%eax
c0100bd7:	76 9c                	jbe    c0100b75 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be0:	c7 04 24 13 8d 10 c0 	movl   $0xc0108d13,(%esp)
c0100be7:	e8 5f f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf1:	c9                   	leave  
c0100bf2:	c3                   	ret    

c0100bf3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf3:	55                   	push   %ebp
c0100bf4:	89 e5                	mov    %esp,%ebp
c0100bf6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf9:	c7 04 24 2c 8d 10 c0 	movl   $0xc0108d2c,(%esp)
c0100c00:	e8 46 f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c05:	c7 04 24 54 8d 10 c0 	movl   $0xc0108d54,(%esp)
c0100c0c:	e8 3a f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c15:	74 0b                	je     c0100c22 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1a:	89 04 24             	mov    %eax,(%esp)
c0100c1d:	e8 44 16 00 00       	call   c0102266 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c22:	c7 04 24 79 8d 10 c0 	movl   $0xc0108d79,(%esp)
c0100c29:	e8 14 f6 ff ff       	call   c0100242 <readline>
c0100c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c35:	74 18                	je     c0100c4f <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c41:	89 04 24             	mov    %eax,(%esp)
c0100c44:	e8 f8 fe ff ff       	call   c0100b41 <runcmd>
c0100c49:	85 c0                	test   %eax,%eax
c0100c4b:	79 02                	jns    c0100c4f <kmonitor+0x5c>
                break;
c0100c4d:	eb 02                	jmp    c0100c51 <kmonitor+0x5e>
            }
        }
    }
c0100c4f:	eb d1                	jmp    c0100c22 <kmonitor+0x2f>
}
c0100c51:	c9                   	leave  
c0100c52:	c3                   	ret    

c0100c53 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c53:	55                   	push   %ebp
c0100c54:	89 e5                	mov    %esp,%ebp
c0100c56:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c60:	eb 3f                	jmp    c0100ca1 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c65:	89 d0                	mov    %edx,%eax
c0100c67:	01 c0                	add    %eax,%eax
c0100c69:	01 d0                	add    %edx,%eax
c0100c6b:	c1 e0 02             	shl    $0x2,%eax
c0100c6e:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c73:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c79:	89 d0                	mov    %edx,%eax
c0100c7b:	01 c0                	add    %eax,%eax
c0100c7d:	01 d0                	add    %edx,%eax
c0100c7f:	c1 e0 02             	shl    $0x2,%eax
c0100c82:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c87:	8b 00                	mov    (%eax),%eax
c0100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c91:	c7 04 24 7d 8d 10 c0 	movl   $0xc0108d7d,(%esp)
c0100c98:	e8 ae f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca4:	83 f8 02             	cmp    $0x2,%eax
c0100ca7:	76 b9                	jbe    c0100c62 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cae:	c9                   	leave  
c0100caf:	c3                   	ret    

c0100cb0 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb0:	55                   	push   %ebp
c0100cb1:	89 e5                	mov    %esp,%ebp
c0100cb3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb6:	e8 c4 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc0:	c9                   	leave  
c0100cc1:	c3                   	ret    

c0100cc2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc2:	55                   	push   %ebp
c0100cc3:	89 e5                	mov    %esp,%ebp
c0100cc5:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc8:	e8 fc fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd2:	c9                   	leave  
c0100cd3:	c3                   	ret    

c0100cd4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd4:	55                   	push   %ebp
c0100cd5:	89 e5                	mov    %esp,%ebp
c0100cd7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cda:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
c0100cdf:	85 c0                	test   %eax,%eax
c0100ce1:	74 02                	je     c0100ce5 <__panic+0x11>
        goto panic_dead;
c0100ce3:	eb 48                	jmp    c0100d2d <__panic+0x59>
    }
    is_panic = 1;
c0100ce5:	c7 05 a0 fe 11 c0 01 	movl   $0x1,0xc011fea0
c0100cec:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cef:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf8:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d03:	c7 04 24 86 8d 10 c0 	movl   $0xc0108d86,(%esp)
c0100d0a:	e8 3c f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d16:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d19:	89 04 24             	mov    %eax,(%esp)
c0100d1c:	e8 f7 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d21:	c7 04 24 a2 8d 10 c0 	movl   $0xc0108da2,(%esp)
c0100d28:	e8 1e f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2d:	e8 fa 11 00 00       	call   c0101f2c <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d39:	e8 b5 fe ff ff       	call   c0100bf3 <kmonitor>
    }
c0100d3e:	eb f2                	jmp    c0100d32 <__panic+0x5e>

c0100d40 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d40:	55                   	push   %ebp
c0100d41:	89 e5                	mov    %esp,%ebp
c0100d43:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d46:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d4f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d53:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5a:	c7 04 24 a4 8d 10 c0 	movl   $0xc0108da4,(%esp)
c0100d61:	e8 e5 f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d70:	89 04 24             	mov    %eax,(%esp)
c0100d73:	e8 a0 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d78:	c7 04 24 a2 8d 10 c0 	movl   $0xc0108da2,(%esp)
c0100d7f:	e8 c7 f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d84:	c9                   	leave  
c0100d85:	c3                   	ret    

c0100d86 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d86:	55                   	push   %ebp
c0100d87:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d89:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
}
c0100d8e:	5d                   	pop    %ebp
c0100d8f:	c3                   	ret    

c0100d90 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d90:	55                   	push   %ebp
c0100d91:	89 e5                	mov    %esp,%ebp
c0100d93:	83 ec 28             	sub    $0x28,%esp
c0100d96:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9c:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da8:	ee                   	out    %al,(%dx)
c0100da9:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100daf:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbb:	ee                   	out    %al,(%dx)
c0100dbc:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dca:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dce:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dcf:	c7 05 bc 0a 12 c0 00 	movl   $0x0,0xc0120abc
c0100dd6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd9:	c7 04 24 c2 8d 10 c0 	movl   $0xc0108dc2,(%esp)
c0100de0:	e8 66 f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100de5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dec:	e8 99 11 00 00       	call   c0101f8a <pic_enable>
}
c0100df1:	c9                   	leave  
c0100df2:	c3                   	ret    

c0100df3 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df3:	55                   	push   %ebp
c0100df4:	89 e5                	mov    %esp,%ebp
c0100df6:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df9:	9c                   	pushf  
c0100dfa:	58                   	pop    %eax
c0100dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e01:	25 00 02 00 00       	and    $0x200,%eax
c0100e06:	85 c0                	test   %eax,%eax
c0100e08:	74 0c                	je     c0100e16 <__intr_save+0x23>
        intr_disable();
c0100e0a:	e8 1d 11 00 00       	call   c0101f2c <intr_disable>
        return 1;
c0100e0f:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e14:	eb 05                	jmp    c0100e1b <__intr_save+0x28>
    }
    return 0;
c0100e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1b:	c9                   	leave  
c0100e1c:	c3                   	ret    

c0100e1d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1d:	55                   	push   %ebp
c0100e1e:	89 e5                	mov    %esp,%ebp
c0100e20:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e27:	74 05                	je     c0100e2e <__intr_restore+0x11>
        intr_enable();
c0100e29:	e8 f8 10 00 00       	call   c0101f26 <intr_enable>
    }
}
c0100e2e:	c9                   	leave  
c0100e2f:	c3                   	ret    

c0100e30 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e30:	55                   	push   %ebp
c0100e31:	89 e5                	mov    %esp,%ebp
c0100e33:	83 ec 10             	sub    $0x10,%esp
c0100e36:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e40:	89 c2                	mov    %eax,%edx
c0100e42:	ec                   	in     (%dx),%al
c0100e43:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e46:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e50:	89 c2                	mov    %eax,%edx
c0100e52:	ec                   	in     (%dx),%al
c0100e53:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e56:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e60:	89 c2                	mov    %eax,%edx
c0100e62:	ec                   	in     (%dx),%al
c0100e63:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e66:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e70:	89 c2                	mov    %eax,%edx
c0100e72:	ec                   	in     (%dx),%al
c0100e73:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e76:	c9                   	leave  
c0100e77:	c3                   	ret    

c0100e78 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e78:	55                   	push   %ebp
c0100e79:	89 e5                	mov    %esp,%ebp
c0100e7b:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7e:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e88:	0f b7 00             	movzwl (%eax),%eax
c0100e8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e92:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9a:	0f b7 00             	movzwl (%eax),%eax
c0100e9d:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea1:	74 12                	je     c0100eb5 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea3:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eaa:	66 c7 05 c6 fe 11 c0 	movw   $0x3b4,0xc011fec6
c0100eb1:	b4 03 
c0100eb3:	eb 13                	jmp    c0100ec8 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ebf:	66 c7 05 c6 fe 11 c0 	movw   $0x3d4,0xc011fec6
c0100ec6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec8:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100ecf:	0f b7 c0             	movzwl %ax,%eax
c0100ed2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed6:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eda:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ede:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee2:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee3:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100eea:	83 c0 01             	add    $0x1,%eax
c0100eed:	0f b7 c0             	movzwl %ax,%eax
c0100ef0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef4:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef8:	89 c2                	mov    %eax,%edx
c0100efa:	ec                   	in     (%dx),%al
c0100efb:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100efe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f02:	0f b6 c0             	movzbl %al,%eax
c0100f05:	c1 e0 08             	shl    $0x8,%eax
c0100f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0b:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f12:	0f b7 c0             	movzwl %ax,%eax
c0100f15:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f19:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f21:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f25:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f26:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f2d:	83 c0 01             	add    $0x1,%eax
c0100f30:	0f b7 c0             	movzwl %ax,%eax
c0100f33:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f37:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3b:	89 c2                	mov    %eax,%edx
c0100f3d:	ec                   	in     (%dx),%al
c0100f3e:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f41:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f45:	0f b6 c0             	movzbl %al,%eax
c0100f48:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4e:	a3 c0 fe 11 c0       	mov    %eax,0xc011fec0
    crt_pos = pos;
c0100f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f56:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
}
c0100f5c:	c9                   	leave  
c0100f5d:	c3                   	ret    

c0100f5e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5e:	55                   	push   %ebp
c0100f5f:	89 e5                	mov    %esp,%ebp
c0100f61:	83 ec 48             	sub    $0x48,%esp
c0100f64:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f72:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f76:	ee                   	out    %al,(%dx)
c0100f77:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7d:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f81:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f85:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f89:	ee                   	out    %al,(%dx)
c0100f8a:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f90:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f94:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f98:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9c:	ee                   	out    %al,(%dx)
c0100f9d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa3:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fab:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100faf:	ee                   	out    %al,(%dx)
c0100fb0:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb6:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fba:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbe:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc2:	ee                   	out    %al,(%dx)
c0100fc3:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc9:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fcd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd1:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd5:	ee                   	out    %al,(%dx)
c0100fd6:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdc:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe0:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe4:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe8:	ee                   	out    %al,(%dx)
c0100fe9:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fef:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff3:	89 c2                	mov    %eax,%edx
c0100ff5:	ec                   	in     (%dx),%al
c0100ff6:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff9:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffd:	3c ff                	cmp    $0xff,%al
c0100fff:	0f 95 c0             	setne  %al
c0101002:	0f b6 c0             	movzbl %al,%eax
c0101005:	a3 c8 fe 11 c0       	mov    %eax,0xc011fec8
c010100a:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101010:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101014:	89 c2                	mov    %eax,%edx
c0101016:	ec                   	in     (%dx),%al
c0101017:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101020:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101024:	89 c2                	mov    %eax,%edx
c0101026:	ec                   	in     (%dx),%al
c0101027:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102a:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c010102f:	85 c0                	test   %eax,%eax
c0101031:	74 0c                	je     c010103f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101033:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103a:	e8 4b 0f 00 00       	call   c0101f8a <pic_enable>
    }
}
c010103f:	c9                   	leave  
c0101040:	c3                   	ret    

c0101041 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101041:	55                   	push   %ebp
c0101042:	89 e5                	mov    %esp,%ebp
c0101044:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104e:	eb 09                	jmp    c0101059 <lpt_putc_sub+0x18>
        delay();
c0101050:	e8 db fd ff ff       	call   c0100e30 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101055:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101059:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010105f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101063:	89 c2                	mov    %eax,%edx
c0101065:	ec                   	in     (%dx),%al
c0101066:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101069:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106d:	84 c0                	test   %al,%al
c010106f:	78 09                	js     c010107a <lpt_putc_sub+0x39>
c0101071:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101078:	7e d6                	jle    c0101050 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107a:	8b 45 08             	mov    0x8(%ebp),%eax
c010107d:	0f b6 c0             	movzbl %al,%eax
c0101080:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101086:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101089:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101091:	ee                   	out    %al,(%dx)
c0101092:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101098:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a4:	ee                   	out    %al,(%dx)
c01010a5:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ab:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010af:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b8:	c9                   	leave  
c01010b9:	c3                   	ret    

c01010ba <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ba:	55                   	push   %ebp
c01010bb:	89 e5                	mov    %esp,%ebp
c01010bd:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c4:	74 0d                	je     c01010d3 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c9:	89 04 24             	mov    %eax,(%esp)
c01010cc:	e8 70 ff ff ff       	call   c0101041 <lpt_putc_sub>
c01010d1:	eb 24                	jmp    c01010f7 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010da:	e8 62 ff ff ff       	call   c0101041 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010df:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e6:	e8 56 ff ff ff       	call   c0101041 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f2:	e8 4a ff ff ff       	call   c0101041 <lpt_putc_sub>
    }
}
c01010f7:	c9                   	leave  
c01010f8:	c3                   	ret    

c01010f9 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f9:	55                   	push   %ebp
c01010fa:	89 e5                	mov    %esp,%ebp
c01010fc:	53                   	push   %ebx
c01010fd:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101100:	8b 45 08             	mov    0x8(%ebp),%eax
c0101103:	b0 00                	mov    $0x0,%al
c0101105:	85 c0                	test   %eax,%eax
c0101107:	75 07                	jne    c0101110 <cga_putc+0x17>
        c |= 0x0700;
c0101109:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101110:	8b 45 08             	mov    0x8(%ebp),%eax
c0101113:	0f b6 c0             	movzbl %al,%eax
c0101116:	83 f8 0a             	cmp    $0xa,%eax
c0101119:	74 4c                	je     c0101167 <cga_putc+0x6e>
c010111b:	83 f8 0d             	cmp    $0xd,%eax
c010111e:	74 57                	je     c0101177 <cga_putc+0x7e>
c0101120:	83 f8 08             	cmp    $0x8,%eax
c0101123:	0f 85 88 00 00 00    	jne    c01011b1 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101129:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101130:	66 85 c0             	test   %ax,%ax
c0101133:	74 30                	je     c0101165 <cga_putc+0x6c>
            crt_pos --;
c0101135:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010113c:	83 e8 01             	sub    $0x1,%eax
c010113f:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101145:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c010114a:	0f b7 15 c4 fe 11 c0 	movzwl 0xc011fec4,%edx
c0101151:	0f b7 d2             	movzwl %dx,%edx
c0101154:	01 d2                	add    %edx,%edx
c0101156:	01 c2                	add    %eax,%edx
c0101158:	8b 45 08             	mov    0x8(%ebp),%eax
c010115b:	b0 00                	mov    $0x0,%al
c010115d:	83 c8 20             	or     $0x20,%eax
c0101160:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101163:	eb 72                	jmp    c01011d7 <cga_putc+0xde>
c0101165:	eb 70                	jmp    c01011d7 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101167:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010116e:	83 c0 50             	add    $0x50,%eax
c0101171:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101177:	0f b7 1d c4 fe 11 c0 	movzwl 0xc011fec4,%ebx
c010117e:	0f b7 0d c4 fe 11 c0 	movzwl 0xc011fec4,%ecx
c0101185:	0f b7 c1             	movzwl %cx,%eax
c0101188:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118e:	c1 e8 10             	shr    $0x10,%eax
c0101191:	89 c2                	mov    %eax,%edx
c0101193:	66 c1 ea 06          	shr    $0x6,%dx
c0101197:	89 d0                	mov    %edx,%eax
c0101199:	c1 e0 02             	shl    $0x2,%eax
c010119c:	01 d0                	add    %edx,%eax
c010119e:	c1 e0 04             	shl    $0x4,%eax
c01011a1:	29 c1                	sub    %eax,%ecx
c01011a3:	89 ca                	mov    %ecx,%edx
c01011a5:	89 d8                	mov    %ebx,%eax
c01011a7:	29 d0                	sub    %edx,%eax
c01011a9:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
        break;
c01011af:	eb 26                	jmp    c01011d7 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b1:	8b 0d c0 fe 11 c0    	mov    0xc011fec0,%ecx
c01011b7:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011be:	8d 50 01             	lea    0x1(%eax),%edx
c01011c1:	66 89 15 c4 fe 11 c0 	mov    %dx,0xc011fec4
c01011c8:	0f b7 c0             	movzwl %ax,%eax
c01011cb:	01 c0                	add    %eax,%eax
c01011cd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d3:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d6:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d7:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011de:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e2:	76 5b                	jbe    c010123f <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e4:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011e9:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011ef:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011f4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fb:	00 
c01011fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101200:	89 04 24             	mov    %eax,(%esp)
c0101203:	e8 63 77 00 00       	call   c010896b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101208:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010120f:	eb 15                	jmp    c0101226 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101211:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c0101216:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101219:	01 d2                	add    %edx,%edx
c010121b:	01 d0                	add    %edx,%eax
c010121d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101222:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101226:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122d:	7e e2                	jle    c0101211 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010122f:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101236:	83 e8 50             	sub    $0x50,%eax
c0101239:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010123f:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0101246:	0f b7 c0             	movzwl %ax,%eax
c0101249:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101251:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101255:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101259:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125a:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101261:	66 c1 e8 08          	shr    $0x8,%ax
c0101265:	0f b6 c0             	movzbl %al,%eax
c0101268:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c010126f:	83 c2 01             	add    $0x1,%edx
c0101272:	0f b7 d2             	movzwl %dx,%edx
c0101275:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101279:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101280:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101284:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101285:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c010128c:	0f b7 c0             	movzwl %ax,%eax
c010128f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101293:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101297:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010129f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a0:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01012a7:	0f b6 c0             	movzbl %al,%eax
c01012aa:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c01012b1:	83 c2 01             	add    $0x1,%edx
c01012b4:	0f b7 d2             	movzwl %dx,%edx
c01012b7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012be:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c6:	ee                   	out    %al,(%dx)
}
c01012c7:	83 c4 34             	add    $0x34,%esp
c01012ca:	5b                   	pop    %ebx
c01012cb:	5d                   	pop    %ebp
c01012cc:	c3                   	ret    

c01012cd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012cd:	55                   	push   %ebp
c01012ce:	89 e5                	mov    %esp,%ebp
c01012d0:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012da:	eb 09                	jmp    c01012e5 <serial_putc_sub+0x18>
        delay();
c01012dc:	e8 4f fb ff ff       	call   c0100e30 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e5:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012eb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012ef:	89 c2                	mov    %eax,%edx
c01012f1:	ec                   	in     (%dx),%al
c01012f2:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f9:	0f b6 c0             	movzbl %al,%eax
c01012fc:	83 e0 20             	and    $0x20,%eax
c01012ff:	85 c0                	test   %eax,%eax
c0101301:	75 09                	jne    c010130c <serial_putc_sub+0x3f>
c0101303:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130a:	7e d0                	jle    c01012dc <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130c:	8b 45 08             	mov    0x8(%ebp),%eax
c010130f:	0f b6 c0             	movzbl %al,%eax
c0101312:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101318:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010131f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101323:	ee                   	out    %al,(%dx)
}
c0101324:	c9                   	leave  
c0101325:	c3                   	ret    

c0101326 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101326:	55                   	push   %ebp
c0101327:	89 e5                	mov    %esp,%ebp
c0101329:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101330:	74 0d                	je     c010133f <serial_putc+0x19>
        serial_putc_sub(c);
c0101332:	8b 45 08             	mov    0x8(%ebp),%eax
c0101335:	89 04 24             	mov    %eax,(%esp)
c0101338:	e8 90 ff ff ff       	call   c01012cd <serial_putc_sub>
c010133d:	eb 24                	jmp    c0101363 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010133f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101346:	e8 82 ff ff ff       	call   c01012cd <serial_putc_sub>
        serial_putc_sub(' ');
c010134b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101352:	e8 76 ff ff ff       	call   c01012cd <serial_putc_sub>
        serial_putc_sub('\b');
c0101357:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135e:	e8 6a ff ff ff       	call   c01012cd <serial_putc_sub>
    }
}
c0101363:	c9                   	leave  
c0101364:	c3                   	ret    

c0101365 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101365:	55                   	push   %ebp
c0101366:	89 e5                	mov    %esp,%ebp
c0101368:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136b:	eb 33                	jmp    c01013a0 <cons_intr+0x3b>
        if (c != 0) {
c010136d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101371:	74 2d                	je     c01013a0 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101373:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101378:	8d 50 01             	lea    0x1(%eax),%edx
c010137b:	89 15 e4 00 12 c0    	mov    %edx,0xc01200e4
c0101381:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101384:	88 90 e0 fe 11 c0    	mov    %dl,-0x3fee0120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138a:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c010138f:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101394:	75 0a                	jne    c01013a0 <cons_intr+0x3b>
                cons.wpos = 0;
c0101396:	c7 05 e4 00 12 c0 00 	movl   $0x0,0xc01200e4
c010139d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a3:	ff d0                	call   *%eax
c01013a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ac:	75 bf                	jne    c010136d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013ae:	c9                   	leave  
c01013af:	c3                   	ret    

c01013b0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b0:	55                   	push   %ebp
c01013b1:	89 e5                	mov    %esp,%ebp
c01013b3:	83 ec 10             	sub    $0x10,%esp
c01013b6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c0:	89 c2                	mov    %eax,%edx
c01013c2:	ec                   	in     (%dx),%al
c01013c3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013ca:	0f b6 c0             	movzbl %al,%eax
c01013cd:	83 e0 01             	and    $0x1,%eax
c01013d0:	85 c0                	test   %eax,%eax
c01013d2:	75 07                	jne    c01013db <serial_proc_data+0x2b>
        return -1;
c01013d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d9:	eb 2a                	jmp    c0101405 <serial_proc_data+0x55>
c01013db:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e5:	89 c2                	mov    %eax,%edx
c01013e7:	ec                   	in     (%dx),%al
c01013e8:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013eb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013ef:	0f b6 c0             	movzbl %al,%eax
c01013f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f5:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f9:	75 07                	jne    c0101402 <serial_proc_data+0x52>
        c = '\b';
c01013fb:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101402:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101405:	c9                   	leave  
c0101406:	c3                   	ret    

c0101407 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101407:	55                   	push   %ebp
c0101408:	89 e5                	mov    %esp,%ebp
c010140a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140d:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0101412:	85 c0                	test   %eax,%eax
c0101414:	74 0c                	je     c0101422 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101416:	c7 04 24 b0 13 10 c0 	movl   $0xc01013b0,(%esp)
c010141d:	e8 43 ff ff ff       	call   c0101365 <cons_intr>
    }
}
c0101422:	c9                   	leave  
c0101423:	c3                   	ret    

c0101424 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101424:	55                   	push   %ebp
c0101425:	89 e5                	mov    %esp,%ebp
c0101427:	83 ec 38             	sub    $0x38,%esp
c010142a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101430:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101434:	89 c2                	mov    %eax,%edx
c0101436:	ec                   	in     (%dx),%al
c0101437:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143e:	0f b6 c0             	movzbl %al,%eax
c0101441:	83 e0 01             	and    $0x1,%eax
c0101444:	85 c0                	test   %eax,%eax
c0101446:	75 0a                	jne    c0101452 <kbd_proc_data+0x2e>
        return -1;
c0101448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144d:	e9 59 01 00 00       	jmp    c01015ab <kbd_proc_data+0x187>
c0101452:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101458:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145c:	89 c2                	mov    %eax,%edx
c010145e:	ec                   	in     (%dx),%al
c010145f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101462:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101466:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101469:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146d:	75 17                	jne    c0101486 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146f:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101474:	83 c8 40             	or     $0x40,%eax
c0101477:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c010147c:	b8 00 00 00 00       	mov    $0x0,%eax
c0101481:	e9 25 01 00 00       	jmp    c01015ab <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101486:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148a:	84 c0                	test   %al,%al
c010148c:	79 47                	jns    c01014d5 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148e:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101493:	83 e0 40             	and    $0x40,%eax
c0101496:	85 c0                	test   %eax,%eax
c0101498:	75 09                	jne    c01014a3 <kbd_proc_data+0x7f>
c010149a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149e:	83 e0 7f             	and    $0x7f,%eax
c01014a1:	eb 04                	jmp    c01014a7 <kbd_proc_data+0x83>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014aa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ae:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01014b5:	83 c8 40             	or     $0x40,%eax
c01014b8:	0f b6 c0             	movzbl %al,%eax
c01014bb:	f7 d0                	not    %eax
c01014bd:	89 c2                	mov    %eax,%edx
c01014bf:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014c4:	21 d0                	and    %edx,%eax
c01014c6:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c01014cb:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d0:	e9 d6 00 00 00       	jmp    c01015ab <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d5:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014da:	83 e0 40             	and    $0x40,%eax
c01014dd:	85 c0                	test   %eax,%eax
c01014df:	74 11                	je     c01014f2 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e1:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e5:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014ea:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ed:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    }

    shift |= shiftcode[data];
c01014f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f6:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01014fd:	0f b6 d0             	movzbl %al,%edx
c0101500:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101505:	09 d0                	or     %edx,%eax
c0101507:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    shift ^= togglecode[data];
c010150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101510:	0f b6 80 60 f1 11 c0 	movzbl -0x3fee0ea0(%eax),%eax
c0101517:	0f b6 d0             	movzbl %al,%edx
c010151a:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010151f:	31 d0                	xor    %edx,%eax
c0101521:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101526:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010152b:	83 e0 03             	and    $0x3,%eax
c010152e:	8b 14 85 60 f5 11 c0 	mov    -0x3fee0aa0(,%eax,4),%edx
c0101535:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101539:	01 d0                	add    %edx,%eax
c010153b:	0f b6 00             	movzbl (%eax),%eax
c010153e:	0f b6 c0             	movzbl %al,%eax
c0101541:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101544:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101549:	83 e0 08             	and    $0x8,%eax
c010154c:	85 c0                	test   %eax,%eax
c010154e:	74 22                	je     c0101572 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101550:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101554:	7e 0c                	jle    c0101562 <kbd_proc_data+0x13e>
c0101556:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155a:	7f 06                	jg     c0101562 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101560:	eb 10                	jmp    c0101572 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101562:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101566:	7e 0a                	jle    c0101572 <kbd_proc_data+0x14e>
c0101568:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156c:	7f 04                	jg     c0101572 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101572:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101577:	f7 d0                	not    %eax
c0101579:	83 e0 06             	and    $0x6,%eax
c010157c:	85 c0                	test   %eax,%eax
c010157e:	75 28                	jne    c01015a8 <kbd_proc_data+0x184>
c0101580:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101587:	75 1f                	jne    c01015a8 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101589:	c7 04 24 dd 8d 10 c0 	movl   $0xc0108ddd,(%esp)
c0101590:	e8 b6 ed ff ff       	call   c010034b <cprintf>
c0101595:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a3:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a7:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ab:	c9                   	leave  
c01015ac:	c3                   	ret    

c01015ad <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ad:	55                   	push   %ebp
c01015ae:	89 e5                	mov    %esp,%ebp
c01015b0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b3:	c7 04 24 24 14 10 c0 	movl   $0xc0101424,(%esp)
c01015ba:	e8 a6 fd ff ff       	call   c0101365 <cons_intr>
}
c01015bf:	c9                   	leave  
c01015c0:	c3                   	ret    

c01015c1 <kbd_init>:

static void
kbd_init(void) {
c01015c1:	55                   	push   %ebp
c01015c2:	89 e5                	mov    %esp,%ebp
c01015c4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c7:	e8 e1 ff ff ff       	call   c01015ad <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d3:	e8 b2 09 00 00       	call   c0101f8a <pic_enable>
}
c01015d8:	c9                   	leave  
c01015d9:	c3                   	ret    

c01015da <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015da:	55                   	push   %ebp
c01015db:	89 e5                	mov    %esp,%ebp
c01015dd:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e0:	e8 93 f8 ff ff       	call   c0100e78 <cga_init>
    serial_init();
c01015e5:	e8 74 f9 ff ff       	call   c0100f5e <serial_init>
    kbd_init();
c01015ea:	e8 d2 ff ff ff       	call   c01015c1 <kbd_init>
    if (!serial_exists) {
c01015ef:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c01015f4:	85 c0                	test   %eax,%eax
c01015f6:	75 0c                	jne    c0101604 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f8:	c7 04 24 e9 8d 10 c0 	movl   $0xc0108de9,(%esp)
c01015ff:	e8 47 ed ff ff       	call   c010034b <cprintf>
    }
}
c0101604:	c9                   	leave  
c0101605:	c3                   	ret    

c0101606 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101606:	55                   	push   %ebp
c0101607:	89 e5                	mov    %esp,%ebp
c0101609:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160c:	e8 e2 f7 ff ff       	call   c0100df3 <__intr_save>
c0101611:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101614:	8b 45 08             	mov    0x8(%ebp),%eax
c0101617:	89 04 24             	mov    %eax,(%esp)
c010161a:	e8 9b fa ff ff       	call   c01010ba <lpt_putc>
        cga_putc(c);
c010161f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101622:	89 04 24             	mov    %eax,(%esp)
c0101625:	e8 cf fa ff ff       	call   c01010f9 <cga_putc>
        serial_putc(c);
c010162a:	8b 45 08             	mov    0x8(%ebp),%eax
c010162d:	89 04 24             	mov    %eax,(%esp)
c0101630:	e8 f1 fc ff ff       	call   c0101326 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101638:	89 04 24             	mov    %eax,(%esp)
c010163b:	e8 dd f7 ff ff       	call   c0100e1d <__intr_restore>
}
c0101640:	c9                   	leave  
c0101641:	c3                   	ret    

c0101642 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101642:	55                   	push   %ebp
c0101643:	89 e5                	mov    %esp,%ebp
c0101645:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101648:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010164f:	e8 9f f7 ff ff       	call   c0100df3 <__intr_save>
c0101654:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101657:	e8 ab fd ff ff       	call   c0101407 <serial_intr>
        kbd_intr();
c010165c:	e8 4c ff ff ff       	call   c01015ad <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101661:	8b 15 e0 00 12 c0    	mov    0xc01200e0,%edx
c0101667:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c010166c:	39 c2                	cmp    %eax,%edx
c010166e:	74 31                	je     c01016a1 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101670:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c0101675:	8d 50 01             	lea    0x1(%eax),%edx
c0101678:	89 15 e0 00 12 c0    	mov    %edx,0xc01200e0
c010167e:	0f b6 80 e0 fe 11 c0 	movzbl -0x3fee0120(%eax),%eax
c0101685:	0f b6 c0             	movzbl %al,%eax
c0101688:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168b:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c0101690:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101695:	75 0a                	jne    c01016a1 <cons_getc+0x5f>
                cons.rpos = 0;
c0101697:	c7 05 e0 00 12 c0 00 	movl   $0x0,0xc01200e0
c010169e:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a4:	89 04 24             	mov    %eax,(%esp)
c01016a7:	e8 71 f7 ff ff       	call   c0100e1d <__intr_restore>
    return c;
c01016ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016af:	c9                   	leave  
c01016b0:	c3                   	ret    

c01016b1 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b1:	55                   	push   %ebp
c01016b2:	89 e5                	mov    %esp,%ebp
c01016b4:	83 ec 14             	sub    $0x14,%esp
c01016b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ba:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016be:	90                   	nop
c01016bf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c3:	83 c0 07             	add    $0x7,%eax
c01016c6:	0f b7 c0             	movzwl %ax,%eax
c01016c9:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016cd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d1:	89 c2                	mov    %eax,%edx
c01016d3:	ec                   	in     (%dx),%al
c01016d4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016d7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016db:	0f b6 c0             	movzbl %al,%eax
c01016de:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e4:	25 80 00 00 00       	and    $0x80,%eax
c01016e9:	85 c0                	test   %eax,%eax
c01016eb:	75 d2                	jne    c01016bf <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f1:	74 11                	je     c0101704 <ide_wait_ready+0x53>
c01016f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f6:	83 e0 21             	and    $0x21,%eax
c01016f9:	85 c0                	test   %eax,%eax
c01016fb:	74 07                	je     c0101704 <ide_wait_ready+0x53>
        return -1;
c01016fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101702:	eb 05                	jmp    c0101709 <ide_wait_ready+0x58>
    }
    return 0;
c0101704:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101709:	c9                   	leave  
c010170a:	c3                   	ret    

c010170b <ide_init>:

void
ide_init(void) {
c010170b:	55                   	push   %ebp
c010170c:	89 e5                	mov    %esp,%ebp
c010170e:	57                   	push   %edi
c010170f:	53                   	push   %ebx
c0101710:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101716:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010171c:	e9 d6 02 00 00       	jmp    c01019f7 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101721:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101725:	c1 e0 03             	shl    $0x3,%eax
c0101728:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010172f:	29 c2                	sub    %eax,%edx
c0101731:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101737:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010173a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010173e:	66 d1 e8             	shr    %ax
c0101741:	0f b7 c0             	movzwl %ax,%eax
c0101744:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c010174b:	c0 
c010174c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101750:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101754:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010175b:	00 
c010175c:	89 04 24             	mov    %eax,(%esp)
c010175f:	e8 4d ff ff ff       	call   c01016b1 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101764:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101768:	83 e0 01             	and    $0x1,%eax
c010176b:	c1 e0 04             	shl    $0x4,%eax
c010176e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101771:	0f b6 c0             	movzbl %al,%eax
c0101774:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101778:	83 c2 06             	add    $0x6,%edx
c010177b:	0f b7 d2             	movzwl %dx,%edx
c010177e:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101782:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101785:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101789:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010178e:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101792:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101799:	00 
c010179a:	89 04 24             	mov    %eax,(%esp)
c010179d:	e8 0f ff ff ff       	call   c01016b1 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017a2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a6:	83 c0 07             	add    $0x7,%eax
c01017a9:	0f b7 c0             	movzwl %ax,%eax
c01017ac:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b0:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017b4:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017b8:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017bc:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017bd:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017c8:	00 
c01017c9:	89 04 24             	mov    %eax,(%esp)
c01017cc:	e8 e0 fe ff ff       	call   c01016b1 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d1:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d5:	83 c0 07             	add    $0x7,%eax
c01017d8:	0f b7 c0             	movzwl %ax,%eax
c01017db:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017df:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017e3:	89 c2                	mov    %eax,%edx
c01017e5:	ec                   	in     (%dx),%al
c01017e6:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017e9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ed:	84 c0                	test   %al,%al
c01017ef:	0f 84 f7 01 00 00    	je     c01019ec <ide_init+0x2e1>
c01017f5:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101800:	00 
c0101801:	89 04 24             	mov    %eax,(%esp)
c0101804:	e8 a8 fe ff ff       	call   c01016b1 <ide_wait_ready>
c0101809:	85 c0                	test   %eax,%eax
c010180b:	0f 85 db 01 00 00    	jne    c01019ec <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101811:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101815:	c1 e0 03             	shl    $0x3,%eax
c0101818:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010181f:	29 c2                	sub    %eax,%edx
c0101821:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101827:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182a:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010182e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101831:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101837:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183a:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101841:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101844:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101847:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184a:	89 cb                	mov    %ecx,%ebx
c010184c:	89 df                	mov    %ebx,%edi
c010184e:	89 c1                	mov    %eax,%ecx
c0101850:	fc                   	cld    
c0101851:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101853:	89 c8                	mov    %ecx,%eax
c0101855:	89 fb                	mov    %edi,%ebx
c0101857:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185a:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010185d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101863:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101869:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010186f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101872:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101875:	25 00 00 00 04       	and    $0x4000000,%eax
c010187a:	85 c0                	test   %eax,%eax
c010187c:	74 0e                	je     c010188c <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010187e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101881:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101887:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010188a:	eb 09                	jmp    c0101895 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010188c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188f:	8b 40 78             	mov    0x78(%eax),%eax
c0101892:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101895:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101899:	c1 e0 03             	shl    $0x3,%eax
c010189c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018a3:	29 c2                	sub    %eax,%edx
c01018a5:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018ae:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b5:	c1 e0 03             	shl    $0x3,%eax
c01018b8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018bf:	29 c2                	sub    %eax,%edx
c01018c1:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018ca:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d0:	83 c0 62             	add    $0x62,%eax
c01018d3:	0f b7 00             	movzwl (%eax),%eax
c01018d6:	0f b7 c0             	movzwl %ax,%eax
c01018d9:	25 00 02 00 00       	and    $0x200,%eax
c01018de:	85 c0                	test   %eax,%eax
c01018e0:	75 24                	jne    c0101906 <ide_init+0x1fb>
c01018e2:	c7 44 24 0c 10 8e 10 	movl   $0xc0108e10,0xc(%esp)
c01018e9:	c0 
c01018ea:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c01018f1:	c0 
c01018f2:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018f9:	00 
c01018fa:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101901:	e8 ce f3 ff ff       	call   c0100cd4 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101906:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010190a:	c1 e0 03             	shl    $0x3,%eax
c010190d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101914:	29 c2                	sub    %eax,%edx
c0101916:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010191c:	83 c0 0c             	add    $0xc,%eax
c010191f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101922:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101925:	83 c0 36             	add    $0x36,%eax
c0101928:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010192b:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101932:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101939:	eb 34                	jmp    c010196f <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010193b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010193e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101941:	01 c2                	add    %eax,%edx
c0101943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101946:	8d 48 01             	lea    0x1(%eax),%ecx
c0101949:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010194c:	01 c8                	add    %ecx,%eax
c010194e:	0f b6 00             	movzbl (%eax),%eax
c0101951:	88 02                	mov    %al,(%edx)
c0101953:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101956:	8d 50 01             	lea    0x1(%eax),%edx
c0101959:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010195c:	01 c2                	add    %eax,%edx
c010195e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101961:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101964:	01 c8                	add    %ecx,%eax
c0101966:	0f b6 00             	movzbl (%eax),%eax
c0101969:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010196b:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c010196f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101972:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101975:	72 c4                	jb     c010193b <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010197d:	01 d0                	add    %edx,%eax
c010197f:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101982:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101985:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101988:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010198b:	85 c0                	test   %eax,%eax
c010198d:	74 0f                	je     c010199e <ide_init+0x293>
c010198f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101992:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101995:	01 d0                	add    %edx,%eax
c0101997:	0f b6 00             	movzbl (%eax),%eax
c010199a:	3c 20                	cmp    $0x20,%al
c010199c:	74 d9                	je     c0101977 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010199e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019a2:	c1 e0 03             	shl    $0x3,%eax
c01019a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ac:	29 c2                	sub    %eax,%edx
c01019ae:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019b4:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019b7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019bb:	c1 e0 03             	shl    $0x3,%eax
c01019be:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c5:	29 c2                	sub    %eax,%edx
c01019c7:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019cd:	8b 50 08             	mov    0x8(%eax),%edx
c01019d0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019d8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e0:	c7 04 24 7a 8e 10 c0 	movl   $0xc0108e7a,(%esp)
c01019e7:	e8 5f e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ec:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f0:	83 c0 01             	add    $0x1,%eax
c01019f3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019f7:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019fc:	0f 86 1f fd ff ff    	jbe    c0101721 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a02:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a09:	e8 7c 05 00 00       	call   c0101f8a <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a0e:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a15:	e8 70 05 00 00       	call   c0101f8a <pic_enable>
}
c0101a1a:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a20:	5b                   	pop    %ebx
c0101a21:	5f                   	pop    %edi
c0101a22:	5d                   	pop    %ebp
c0101a23:	c3                   	ret    

c0101a24 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a24:	55                   	push   %ebp
c0101a25:	89 e5                	mov    %esp,%ebp
c0101a27:	83 ec 04             	sub    $0x4,%esp
c0101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a31:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a36:	77 24                	ja     c0101a5c <ide_device_valid+0x38>
c0101a38:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3c:	c1 e0 03             	shl    $0x3,%eax
c0101a3f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a46:	29 c2                	sub    %eax,%edx
c0101a48:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a4e:	0f b6 00             	movzbl (%eax),%eax
c0101a51:	84 c0                	test   %al,%al
c0101a53:	74 07                	je     c0101a5c <ide_device_valid+0x38>
c0101a55:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a5a:	eb 05                	jmp    c0101a61 <ide_device_valid+0x3d>
c0101a5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a61:	c9                   	leave  
c0101a62:	c3                   	ret    

c0101a63 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a63:	55                   	push   %ebp
c0101a64:	89 e5                	mov    %esp,%ebp
c0101a66:	83 ec 08             	sub    $0x8,%esp
c0101a69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a70:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a74:	89 04 24             	mov    %eax,(%esp)
c0101a77:	e8 a8 ff ff ff       	call   c0101a24 <ide_device_valid>
c0101a7c:	85 c0                	test   %eax,%eax
c0101a7e:	74 1b                	je     c0101a9b <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a80:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a84:	c1 e0 03             	shl    $0x3,%eax
c0101a87:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a8e:	29 c2                	sub    %eax,%edx
c0101a90:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a96:	8b 40 08             	mov    0x8(%eax),%eax
c0101a99:	eb 05                	jmp    c0101aa0 <ide_device_size+0x3d>
    }
    return 0;
c0101a9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa0:	c9                   	leave  
c0101aa1:	c3                   	ret    

c0101aa2 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aa2:	55                   	push   %ebp
c0101aa3:	89 e5                	mov    %esp,%ebp
c0101aa5:	57                   	push   %edi
c0101aa6:	53                   	push   %ebx
c0101aa7:	83 ec 50             	sub    $0x50,%esp
c0101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aad:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab1:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ab8:	77 24                	ja     c0101ade <ide_read_secs+0x3c>
c0101aba:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101abf:	77 1d                	ja     c0101ade <ide_read_secs+0x3c>
c0101ac1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac5:	c1 e0 03             	shl    $0x3,%eax
c0101ac8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101acf:	29 c2                	sub    %eax,%edx
c0101ad1:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101ad7:	0f b6 00             	movzbl (%eax),%eax
c0101ada:	84 c0                	test   %al,%al
c0101adc:	75 24                	jne    c0101b02 <ide_read_secs+0x60>
c0101ade:	c7 44 24 0c 98 8e 10 	movl   $0xc0108e98,0xc(%esp)
c0101ae5:	c0 
c0101ae6:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101aed:	c0 
c0101aee:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af5:	00 
c0101af6:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101afd:	e8 d2 f1 ff ff       	call   c0100cd4 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b02:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b09:	77 0f                	ja     c0101b1a <ide_read_secs+0x78>
c0101b0b:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b11:	01 d0                	add    %edx,%eax
c0101b13:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b18:	76 24                	jbe    c0101b3e <ide_read_secs+0x9c>
c0101b1a:	c7 44 24 0c c0 8e 10 	movl   $0xc0108ec0,0xc(%esp)
c0101b21:	c0 
c0101b22:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101b29:	c0 
c0101b2a:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b31:	00 
c0101b32:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101b39:	e8 96 f1 ff ff       	call   c0100cd4 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b3e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b42:	66 d1 e8             	shr    %ax
c0101b45:	0f b7 c0             	movzwl %ax,%eax
c0101b48:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c0101b4f:	c0 
c0101b50:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b54:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b58:	66 d1 e8             	shr    %ax
c0101b5b:	0f b7 c0             	movzwl %ax,%eax
c0101b5e:	0f b7 04 85 0a 8e 10 	movzwl -0x3fef71f6(,%eax,4),%eax
c0101b65:	c0 
c0101b66:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b6a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b75:	00 
c0101b76:	89 04 24             	mov    %eax,(%esp)
c0101b79:	e8 33 fb ff ff       	call   c01016b1 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b7e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b82:	83 c0 02             	add    $0x2,%eax
c0101b85:	0f b7 c0             	movzwl %ax,%eax
c0101b88:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b8c:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b90:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b94:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b99:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b9c:	0f b6 c0             	movzbl %al,%eax
c0101b9f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ba3:	83 c2 02             	add    $0x2,%edx
c0101ba6:	0f b7 d2             	movzwl %dx,%edx
c0101ba9:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bad:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bb8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbc:	0f b6 c0             	movzbl %al,%eax
c0101bbf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc3:	83 c2 03             	add    $0x3,%edx
c0101bc6:	0f b7 d2             	movzwl %dx,%edx
c0101bc9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bcd:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bd4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bd8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bdc:	c1 e8 08             	shr    $0x8,%eax
c0101bdf:	0f b6 c0             	movzbl %al,%eax
c0101be2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be6:	83 c2 04             	add    $0x4,%edx
c0101be9:	0f b7 d2             	movzwl %dx,%edx
c0101bec:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf0:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bf3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bf7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bfb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bff:	c1 e8 10             	shr    $0x10,%eax
c0101c02:	0f b6 c0             	movzbl %al,%eax
c0101c05:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c09:	83 c2 05             	add    $0x5,%edx
c0101c0c:	0f b7 d2             	movzwl %dx,%edx
c0101c0f:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c13:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c16:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c1a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c1e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c1f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c23:	83 e0 01             	and    $0x1,%eax
c0101c26:	c1 e0 04             	shl    $0x4,%eax
c0101c29:	89 c2                	mov    %eax,%edx
c0101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c2e:	c1 e8 18             	shr    $0x18,%eax
c0101c31:	83 e0 0f             	and    $0xf,%eax
c0101c34:	09 d0                	or     %edx,%eax
c0101c36:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c39:	0f b6 c0             	movzbl %al,%eax
c0101c3c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c40:	83 c2 06             	add    $0x6,%edx
c0101c43:	0f b7 d2             	movzwl %dx,%edx
c0101c46:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c4a:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c4d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c51:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c55:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c56:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c5a:	83 c0 07             	add    $0x7,%eax
c0101c5d:	0f b7 c0             	movzwl %ax,%eax
c0101c60:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c64:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c68:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c6c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c70:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c78:	eb 5a                	jmp    c0101cd4 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c7a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c7e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c85:	00 
c0101c86:	89 04 24             	mov    %eax,(%esp)
c0101c89:	e8 23 fa ff ff       	call   c01016b1 <ide_wait_ready>
c0101c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c95:	74 02                	je     c0101c99 <ide_read_secs+0x1f7>
            goto out;
c0101c97:	eb 41                	jmp    c0101cda <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca0:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ca3:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca6:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cad:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb6:	89 cb                	mov    %ecx,%ebx
c0101cb8:	89 df                	mov    %ebx,%edi
c0101cba:	89 c1                	mov    %eax,%ecx
c0101cbc:	fc                   	cld    
c0101cbd:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cbf:	89 c8                	mov    %ecx,%eax
c0101cc1:	89 fb                	mov    %edi,%ebx
c0101cc3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cc9:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101ccd:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cd4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cd8:	75 a0                	jne    c0101c7a <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cdd:	83 c4 50             	add    $0x50,%esp
c0101ce0:	5b                   	pop    %ebx
c0101ce1:	5f                   	pop    %edi
c0101ce2:	5d                   	pop    %ebp
c0101ce3:	c3                   	ret    

c0101ce4 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ce4:	55                   	push   %ebp
c0101ce5:	89 e5                	mov    %esp,%ebp
c0101ce7:	56                   	push   %esi
c0101ce8:	53                   	push   %ebx
c0101ce9:	83 ec 50             	sub    $0x50,%esp
c0101cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cef:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cf3:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cfa:	77 24                	ja     c0101d20 <ide_write_secs+0x3c>
c0101cfc:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d01:	77 1d                	ja     c0101d20 <ide_write_secs+0x3c>
c0101d03:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d07:	c1 e0 03             	shl    $0x3,%eax
c0101d0a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d11:	29 c2                	sub    %eax,%edx
c0101d13:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101d19:	0f b6 00             	movzbl (%eax),%eax
c0101d1c:	84 c0                	test   %al,%al
c0101d1e:	75 24                	jne    c0101d44 <ide_write_secs+0x60>
c0101d20:	c7 44 24 0c 98 8e 10 	movl   $0xc0108e98,0xc(%esp)
c0101d27:	c0 
c0101d28:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101d2f:	c0 
c0101d30:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d37:	00 
c0101d38:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101d3f:	e8 90 ef ff ff       	call   c0100cd4 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d44:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d4b:	77 0f                	ja     c0101d5c <ide_write_secs+0x78>
c0101d4d:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d50:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d53:	01 d0                	add    %edx,%eax
c0101d55:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d5a:	76 24                	jbe    c0101d80 <ide_write_secs+0x9c>
c0101d5c:	c7 44 24 0c c0 8e 10 	movl   $0xc0108ec0,0xc(%esp)
c0101d63:	c0 
c0101d64:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101d6b:	c0 
c0101d6c:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d73:	00 
c0101d74:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101d7b:	e8 54 ef ff ff       	call   c0100cd4 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d80:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d84:	66 d1 e8             	shr    %ax
c0101d87:	0f b7 c0             	movzwl %ax,%eax
c0101d8a:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c0101d91:	c0 
c0101d92:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d96:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d9a:	66 d1 e8             	shr    %ax
c0101d9d:	0f b7 c0             	movzwl %ax,%eax
c0101da0:	0f b7 04 85 0a 8e 10 	movzwl -0x3fef71f6(,%eax,4),%eax
c0101da7:	c0 
c0101da8:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101db7:	00 
c0101db8:	89 04 24             	mov    %eax,(%esp)
c0101dbb:	e8 f1 f8 ff ff       	call   c01016b1 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dc4:	83 c0 02             	add    $0x2,%eax
c0101dc7:	0f b7 c0             	movzwl %ax,%eax
c0101dca:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dce:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dd2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101dda:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ddb:	8b 45 14             	mov    0x14(%ebp),%eax
c0101dde:	0f b6 c0             	movzbl %al,%eax
c0101de1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de5:	83 c2 02             	add    $0x2,%edx
c0101de8:	0f b7 d2             	movzwl %dx,%edx
c0101deb:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101def:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101df2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101dfa:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101dfe:	0f b6 c0             	movzbl %al,%eax
c0101e01:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e05:	83 c2 03             	add    $0x3,%edx
c0101e08:	0f b7 d2             	movzwl %dx,%edx
c0101e0b:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e0f:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e12:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e16:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e1a:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1e:	c1 e8 08             	shr    $0x8,%eax
c0101e21:	0f b6 c0             	movzbl %al,%eax
c0101e24:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e28:	83 c2 04             	add    $0x4,%edx
c0101e2b:	0f b7 d2             	movzwl %dx,%edx
c0101e2e:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e32:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e35:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e39:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e3d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e41:	c1 e8 10             	shr    $0x10,%eax
c0101e44:	0f b6 c0             	movzbl %al,%eax
c0101e47:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4b:	83 c2 05             	add    $0x5,%edx
c0101e4e:	0f b7 d2             	movzwl %dx,%edx
c0101e51:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e55:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e58:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e5c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e60:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e61:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e65:	83 e0 01             	and    $0x1,%eax
c0101e68:	c1 e0 04             	shl    $0x4,%eax
c0101e6b:	89 c2                	mov    %eax,%edx
c0101e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e70:	c1 e8 18             	shr    $0x18,%eax
c0101e73:	83 e0 0f             	and    $0xf,%eax
c0101e76:	09 d0                	or     %edx,%eax
c0101e78:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e7b:	0f b6 c0             	movzbl %al,%eax
c0101e7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e82:	83 c2 06             	add    $0x6,%edx
c0101e85:	0f b7 d2             	movzwl %dx,%edx
c0101e88:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e8c:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e8f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e93:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e97:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e98:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e9c:	83 c0 07             	add    $0x7,%eax
c0101e9f:	0f b7 c0             	movzwl %ax,%eax
c0101ea2:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea6:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eaa:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eae:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eb2:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101eba:	eb 5a                	jmp    c0101f16 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ebc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ec7:	00 
c0101ec8:	89 04 24             	mov    %eax,(%esp)
c0101ecb:	e8 e1 f7 ff ff       	call   c01016b1 <ide_wait_ready>
c0101ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ed3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ed7:	74 02                	je     c0101edb <ide_write_secs+0x1f7>
            goto out;
c0101ed9:	eb 41                	jmp    c0101f1c <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101edb:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101edf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee5:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ee8:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101eef:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ef2:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ef8:	89 cb                	mov    %ecx,%ebx
c0101efa:	89 de                	mov    %ebx,%esi
c0101efc:	89 c1                	mov    %eax,%ecx
c0101efe:	fc                   	cld    
c0101eff:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f01:	89 c8                	mov    %ecx,%eax
c0101f03:	89 f3                	mov    %esi,%ebx
c0101f05:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f08:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f0b:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f0f:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f16:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f1a:	75 a0                	jne    c0101ebc <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f1f:	83 c4 50             	add    $0x50,%esp
c0101f22:	5b                   	pop    %ebx
c0101f23:	5e                   	pop    %esi
c0101f24:	5d                   	pop    %ebp
c0101f25:	c3                   	ret    

c0101f26 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f26:	55                   	push   %ebp
c0101f27:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f29:	fb                   	sti    
    sti();
}
c0101f2a:	5d                   	pop    %ebp
c0101f2b:	c3                   	ret    

c0101f2c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f2c:	55                   	push   %ebp
c0101f2d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f2f:	fa                   	cli    
    cli();
}
c0101f30:	5d                   	pop    %ebp
c0101f31:	c3                   	ret    

c0101f32 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f32:	55                   	push   %ebp
c0101f33:	89 e5                	mov    %esp,%ebp
c0101f35:	83 ec 14             	sub    $0x14,%esp
c0101f38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f3f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f43:	66 a3 70 f5 11 c0    	mov    %ax,0xc011f570
    if (did_init) {
c0101f49:	a1 e0 01 12 c0       	mov    0xc01201e0,%eax
c0101f4e:	85 c0                	test   %eax,%eax
c0101f50:	74 36                	je     c0101f88 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f52:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f56:	0f b6 c0             	movzbl %al,%eax
c0101f59:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f5f:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f62:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f66:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f6a:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f6b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f6f:	66 c1 e8 08          	shr    $0x8,%ax
c0101f73:	0f b6 c0             	movzbl %al,%eax
c0101f76:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f7c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f7f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f83:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f87:	ee                   	out    %al,(%dx)
    }
}
c0101f88:	c9                   	leave  
c0101f89:	c3                   	ret    

c0101f8a <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f8a:	55                   	push   %ebp
c0101f8b:	89 e5                	mov    %esp,%ebp
c0101f8d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f93:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f98:	89 c1                	mov    %eax,%ecx
c0101f9a:	d3 e2                	shl    %cl,%edx
c0101f9c:	89 d0                	mov    %edx,%eax
c0101f9e:	f7 d0                	not    %eax
c0101fa0:	89 c2                	mov    %eax,%edx
c0101fa2:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c0101fa9:	21 d0                	and    %edx,%eax
c0101fab:	0f b7 c0             	movzwl %ax,%eax
c0101fae:	89 04 24             	mov    %eax,(%esp)
c0101fb1:	e8 7c ff ff ff       	call   c0101f32 <pic_setmask>
}
c0101fb6:	c9                   	leave  
c0101fb7:	c3                   	ret    

c0101fb8 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fb8:	55                   	push   %ebp
c0101fb9:	89 e5                	mov    %esp,%ebp
c0101fbb:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fbe:	c7 05 e0 01 12 c0 01 	movl   $0x1,0xc01201e0
c0101fc5:	00 00 00 
c0101fc8:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fce:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fd2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fda:	ee                   	out    %al,(%dx)
c0101fdb:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe1:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fe9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fed:	ee                   	out    %al,(%dx)
c0101fee:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ff4:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ff8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ffc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102000:	ee                   	out    %al,(%dx)
c0102001:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102007:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010200b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010200f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102013:	ee                   	out    %al,(%dx)
c0102014:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010201a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010201e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102022:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102026:	ee                   	out    %al,(%dx)
c0102027:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010202d:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102031:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102035:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102039:	ee                   	out    %al,(%dx)
c010203a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102040:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102044:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102048:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010204c:	ee                   	out    %al,(%dx)
c010204d:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102053:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102057:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010205b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010205f:	ee                   	out    %al,(%dx)
c0102060:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102066:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010206a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010206e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102072:	ee                   	out    %al,(%dx)
c0102073:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102079:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010207d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102081:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102085:	ee                   	out    %al,(%dx)
c0102086:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010208c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102090:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102094:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102098:	ee                   	out    %al,(%dx)
c0102099:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010209f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020a3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020a7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020ab:	ee                   	out    %al,(%dx)
c01020ac:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020b2:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020ba:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020be:	ee                   	out    %al,(%dx)
c01020bf:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c5:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020c9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020cd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d1:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020d2:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020d9:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020dd:	74 12                	je     c01020f1 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020df:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020e6:	0f b7 c0             	movzwl %ax,%eax
c01020e9:	89 04 24             	mov    %eax,(%esp)
c01020ec:	e8 41 fe ff ff       	call   c0101f32 <pic_setmask>
    }
}
c01020f1:	c9                   	leave  
c01020f2:	c3                   	ret    

c01020f3 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020f3:	55                   	push   %ebp
c01020f4:	89 e5                	mov    %esp,%ebp
c01020f6:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020f9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102100:	00 
c0102101:	c7 04 24 00 8f 10 c0 	movl   $0xc0108f00,(%esp)
c0102108:	e8 3e e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010210d:	c9                   	leave  
c010210e:	c3                   	ret    

c010210f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010210f:	55                   	push   %ebp
c0102110:	89 e5                	mov    %esp,%ebp
c0102112:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c0102115:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010211c:	e9 e2 00 00 00       	jmp    c0102203 <idt_init+0xf4>
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
c0102121:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102124:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c010212b:	89 c2                	mov    %eax,%edx
c010212d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102130:	66 89 14 c5 00 02 12 	mov    %dx,-0x3fedfe00(,%eax,8)
c0102137:	c0 
c0102138:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213b:	66 c7 04 c5 02 02 12 	movw   $0x8,-0x3fedfdfe(,%eax,8)
c0102142:	c0 08 00 
c0102145:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102148:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c010214f:	c0 
c0102150:	83 e2 e0             	and    $0xffffffe0,%edx
c0102153:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215d:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c0102164:	c0 
c0102165:	83 e2 1f             	and    $0x1f,%edx
c0102168:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010216f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102172:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102179:	c0 
c010217a:	83 e2 f0             	and    $0xfffffff0,%edx
c010217d:	83 ca 0e             	or     $0xe,%edx
c0102180:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c0102187:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218a:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102191:	c0 
c0102192:	83 e2 ef             	and    $0xffffffef,%edx
c0102195:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c010219c:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01021a3:	75 07                	jne    c01021ac <idt_init+0x9d>
c01021a5:	ba 03 00 00 00       	mov    $0x3,%edx
c01021aa:	eb 05                	jmp    c01021b1 <idt_init+0xa2>
c01021ac:	ba 00 00 00 00       	mov    $0x0,%edx
c01021b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b4:	83 e2 03             	and    $0x3,%edx
c01021b7:	89 d1                	mov    %edx,%ecx
c01021b9:	c1 e1 05             	shl    $0x5,%ecx
c01021bc:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021c3:	c0 
c01021c4:	83 e2 9f             	and    $0xffffff9f,%edx
c01021c7:	09 ca                	or     %ecx,%edx
c01021c9:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d3:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021da:	c0 
c01021db:	83 ca 80             	or     $0xffffff80,%edx
c01021de:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e8:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c01021ef:	c1 e8 10             	shr    $0x10,%eax
c01021f2:	89 c2                	mov    %eax,%edx
c01021f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f7:	66 89 14 c5 06 02 12 	mov    %dx,-0x3fedfdfa(,%eax,8)
c01021fe:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	   extern uintptr_t __vectors[];
	    int i;
	    for (i = 0; i < 256; i++)
c01021ff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102203:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c010220a:	0f 8e 11 ff ff ff    	jle    c0102121 <idt_init+0x12>
c0102210:	c7 45 f8 80 f5 11 c0 	movl   $0xc011f580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102217:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010221a:	0f 01 18             	lidtl  (%eax)
	        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
	    lidt(&idt_pd);
}
c010221d:	c9                   	leave  
c010221e:	c3                   	ret    

c010221f <trapname>:

static const char *
trapname(int trapno) {
c010221f:	55                   	push   %ebp
c0102220:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102222:	8b 45 08             	mov    0x8(%ebp),%eax
c0102225:	83 f8 13             	cmp    $0x13,%eax
c0102228:	77 0c                	ja     c0102236 <trapname+0x17>
        return excnames[trapno];
c010222a:	8b 45 08             	mov    0x8(%ebp),%eax
c010222d:	8b 04 85 e0 92 10 c0 	mov    -0x3fef6d20(,%eax,4),%eax
c0102234:	eb 18                	jmp    c010224e <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102236:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010223a:	7e 0d                	jle    c0102249 <trapname+0x2a>
c010223c:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102240:	7f 07                	jg     c0102249 <trapname+0x2a>
        return "Hardware Interrupt";
c0102242:	b8 0a 8f 10 c0       	mov    $0xc0108f0a,%eax
c0102247:	eb 05                	jmp    c010224e <trapname+0x2f>
    }
    return "(unknown trap)";
c0102249:	b8 1d 8f 10 c0       	mov    $0xc0108f1d,%eax
}
c010224e:	5d                   	pop    %ebp
c010224f:	c3                   	ret    

c0102250 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102250:	55                   	push   %ebp
c0102251:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102253:	8b 45 08             	mov    0x8(%ebp),%eax
c0102256:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010225a:	66 83 f8 08          	cmp    $0x8,%ax
c010225e:	0f 94 c0             	sete   %al
c0102261:	0f b6 c0             	movzbl %al,%eax
}
c0102264:	5d                   	pop    %ebp
c0102265:	c3                   	ret    

c0102266 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102266:	55                   	push   %ebp
c0102267:	89 e5                	mov    %esp,%ebp
c0102269:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010226c:	8b 45 08             	mov    0x8(%ebp),%eax
c010226f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102273:	c7 04 24 5e 8f 10 c0 	movl   $0xc0108f5e,(%esp)
c010227a:	e8 cc e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c010227f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102282:	89 04 24             	mov    %eax,(%esp)
c0102285:	e8 a1 01 00 00       	call   c010242b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010228a:	8b 45 08             	mov    0x8(%ebp),%eax
c010228d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102291:	0f b7 c0             	movzwl %ax,%eax
c0102294:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102298:	c7 04 24 6f 8f 10 c0 	movl   $0xc0108f6f,(%esp)
c010229f:	e8 a7 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022ab:	0f b7 c0             	movzwl %ax,%eax
c01022ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022b2:	c7 04 24 82 8f 10 c0 	movl   $0xc0108f82,(%esp)
c01022b9:	e8 8d e0 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022be:	8b 45 08             	mov    0x8(%ebp),%eax
c01022c1:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022c5:	0f b7 c0             	movzwl %ax,%eax
c01022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022cc:	c7 04 24 95 8f 10 c0 	movl   $0xc0108f95,(%esp)
c01022d3:	e8 73 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01022db:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022df:	0f b7 c0             	movzwl %ax,%eax
c01022e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022e6:	c7 04 24 a8 8f 10 c0 	movl   $0xc0108fa8,(%esp)
c01022ed:	e8 59 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01022f5:	8b 40 30             	mov    0x30(%eax),%eax
c01022f8:	89 04 24             	mov    %eax,(%esp)
c01022fb:	e8 1f ff ff ff       	call   c010221f <trapname>
c0102300:	8b 55 08             	mov    0x8(%ebp),%edx
c0102303:	8b 52 30             	mov    0x30(%edx),%edx
c0102306:	89 44 24 08          	mov    %eax,0x8(%esp)
c010230a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010230e:	c7 04 24 bb 8f 10 c0 	movl   $0xc0108fbb,(%esp)
c0102315:	e8 31 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010231a:	8b 45 08             	mov    0x8(%ebp),%eax
c010231d:	8b 40 34             	mov    0x34(%eax),%eax
c0102320:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102324:	c7 04 24 cd 8f 10 c0 	movl   $0xc0108fcd,(%esp)
c010232b:	e8 1b e0 ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102330:	8b 45 08             	mov    0x8(%ebp),%eax
c0102333:	8b 40 38             	mov    0x38(%eax),%eax
c0102336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010233a:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0102341:	e8 05 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102346:	8b 45 08             	mov    0x8(%ebp),%eax
c0102349:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010234d:	0f b7 c0             	movzwl %ax,%eax
c0102350:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102354:	c7 04 24 eb 8f 10 c0 	movl   $0xc0108feb,(%esp)
c010235b:	e8 eb df ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102360:	8b 45 08             	mov    0x8(%ebp),%eax
c0102363:	8b 40 40             	mov    0x40(%eax),%eax
c0102366:	89 44 24 04          	mov    %eax,0x4(%esp)
c010236a:	c7 04 24 fe 8f 10 c0 	movl   $0xc0108ffe,(%esp)
c0102371:	e8 d5 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102376:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010237d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102384:	eb 3e                	jmp    c01023c4 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102386:	8b 45 08             	mov    0x8(%ebp),%eax
c0102389:	8b 50 40             	mov    0x40(%eax),%edx
c010238c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010238f:	21 d0                	and    %edx,%eax
c0102391:	85 c0                	test   %eax,%eax
c0102393:	74 28                	je     c01023bd <print_trapframe+0x157>
c0102395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102398:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c010239f:	85 c0                	test   %eax,%eax
c01023a1:	74 1a                	je     c01023bd <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023a6:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c01023ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023b1:	c7 04 24 0d 90 10 c0 	movl   $0xc010900d,(%esp)
c01023b8:	e8 8e df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023c1:	d1 65 f0             	shll   -0x10(%ebp)
c01023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023c7:	83 f8 17             	cmp    $0x17,%eax
c01023ca:	76 ba                	jbe    c0102386 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023cf:	8b 40 40             	mov    0x40(%eax),%eax
c01023d2:	25 00 30 00 00       	and    $0x3000,%eax
c01023d7:	c1 e8 0c             	shr    $0xc,%eax
c01023da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023de:	c7 04 24 11 90 10 c0 	movl   $0xc0109011,(%esp)
c01023e5:	e8 61 df ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c01023ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ed:	89 04 24             	mov    %eax,(%esp)
c01023f0:	e8 5b fe ff ff       	call   c0102250 <trap_in_kernel>
c01023f5:	85 c0                	test   %eax,%eax
c01023f7:	75 30                	jne    c0102429 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fc:	8b 40 44             	mov    0x44(%eax),%eax
c01023ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102403:	c7 04 24 1a 90 10 c0 	movl   $0xc010901a,(%esp)
c010240a:	e8 3c df ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010240f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102412:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102416:	0f b7 c0             	movzwl %ax,%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 29 90 10 c0 	movl   $0xc0109029,(%esp)
c0102424:	e8 22 df ff ff       	call   c010034b <cprintf>
    }
}
c0102429:	c9                   	leave  
c010242a:	c3                   	ret    

c010242b <print_regs>:

void
print_regs(struct pushregs *regs) {
c010242b:	55                   	push   %ebp
c010242c:	89 e5                	mov    %esp,%ebp
c010242e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102431:	8b 45 08             	mov    0x8(%ebp),%eax
c0102434:	8b 00                	mov    (%eax),%eax
c0102436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010243a:	c7 04 24 3c 90 10 c0 	movl   $0xc010903c,(%esp)
c0102441:	e8 05 df ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102446:	8b 45 08             	mov    0x8(%ebp),%eax
c0102449:	8b 40 04             	mov    0x4(%eax),%eax
c010244c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102450:	c7 04 24 4b 90 10 c0 	movl   $0xc010904b,(%esp)
c0102457:	e8 ef de ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	8b 40 08             	mov    0x8(%eax),%eax
c0102462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102466:	c7 04 24 5a 90 10 c0 	movl   $0xc010905a,(%esp)
c010246d:	e8 d9 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102472:	8b 45 08             	mov    0x8(%ebp),%eax
c0102475:	8b 40 0c             	mov    0xc(%eax),%eax
c0102478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010247c:	c7 04 24 69 90 10 c0 	movl   $0xc0109069,(%esp)
c0102483:	e8 c3 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102488:	8b 45 08             	mov    0x8(%ebp),%eax
c010248b:	8b 40 10             	mov    0x10(%eax),%eax
c010248e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102492:	c7 04 24 78 90 10 c0 	movl   $0xc0109078,(%esp)
c0102499:	e8 ad de ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c010249e:	8b 45 08             	mov    0x8(%ebp),%eax
c01024a1:	8b 40 14             	mov    0x14(%eax),%eax
c01024a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a8:	c7 04 24 87 90 10 c0 	movl   $0xc0109087,(%esp)
c01024af:	e8 97 de ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b7:	8b 40 18             	mov    0x18(%eax),%eax
c01024ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024be:	c7 04 24 96 90 10 c0 	movl   $0xc0109096,(%esp)
c01024c5:	e8 81 de ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cd:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024d4:	c7 04 24 a5 90 10 c0 	movl   $0xc01090a5,(%esp)
c01024db:	e8 6b de ff ff       	call   c010034b <cprintf>
}
c01024e0:	c9                   	leave  
c01024e1:	c3                   	ret    

c01024e2 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024e2:	55                   	push   %ebp
c01024e3:	89 e5                	mov    %esp,%ebp
c01024e5:	53                   	push   %ebx
c01024e6:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ec:	8b 40 34             	mov    0x34(%eax),%eax
c01024ef:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024f2:	85 c0                	test   %eax,%eax
c01024f4:	74 07                	je     c01024fd <print_pgfault+0x1b>
c01024f6:	b9 b4 90 10 c0       	mov    $0xc01090b4,%ecx
c01024fb:	eb 05                	jmp    c0102502 <print_pgfault+0x20>
c01024fd:	b9 c5 90 10 c0       	mov    $0xc01090c5,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	8b 40 34             	mov    0x34(%eax),%eax
c0102508:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010250b:	85 c0                	test   %eax,%eax
c010250d:	74 07                	je     c0102516 <print_pgfault+0x34>
c010250f:	ba 57 00 00 00       	mov    $0x57,%edx
c0102514:	eb 05                	jmp    c010251b <print_pgfault+0x39>
c0102516:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010251b:	8b 45 08             	mov    0x8(%ebp),%eax
c010251e:	8b 40 34             	mov    0x34(%eax),%eax
c0102521:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102524:	85 c0                	test   %eax,%eax
c0102526:	74 07                	je     c010252f <print_pgfault+0x4d>
c0102528:	b8 55 00 00 00       	mov    $0x55,%eax
c010252d:	eb 05                	jmp    c0102534 <print_pgfault+0x52>
c010252f:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102534:	0f 20 d3             	mov    %cr2,%ebx
c0102537:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010253a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010253d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102541:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102545:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102549:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010254d:	c7 04 24 d4 90 10 c0 	movl   $0xc01090d4,(%esp)
c0102554:	e8 f2 dd ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102559:	83 c4 34             	add    $0x34,%esp
c010255c:	5b                   	pop    %ebx
c010255d:	5d                   	pop    %ebp
c010255e:	c3                   	ret    

c010255f <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010255f:	55                   	push   %ebp
c0102560:	89 e5                	mov    %esp,%ebp
c0102562:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102565:	8b 45 08             	mov    0x8(%ebp),%eax
c0102568:	89 04 24             	mov    %eax,(%esp)
c010256b:	e8 72 ff ff ff       	call   c01024e2 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102570:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0102575:	85 c0                	test   %eax,%eax
c0102577:	74 28                	je     c01025a1 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102579:	0f 20 d0             	mov    %cr2,%eax
c010257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102582:	89 c1                	mov    %eax,%ecx
c0102584:	8b 45 08             	mov    0x8(%ebp),%eax
c0102587:	8b 50 34             	mov    0x34(%eax),%edx
c010258a:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c010258f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102593:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102597:	89 04 24             	mov    %eax,(%esp)
c010259a:	e8 62 55 00 00       	call   c0107b01 <do_pgfault>
c010259f:	eb 1c                	jmp    c01025bd <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c01025a1:	c7 44 24 08 f7 90 10 	movl   $0xc01090f7,0x8(%esp)
c01025a8:	c0 
c01025a9:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c01025b0:	00 
c01025b1:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c01025b8:	e8 17 e7 ff ff       	call   c0100cd4 <__panic>
}
c01025bd:	c9                   	leave  
c01025be:	c3                   	ret    

c01025bf <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025bf:	55                   	push   %ebp
c01025c0:	89 e5                	mov    %esp,%ebp
c01025c2:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c8:	8b 40 30             	mov    0x30(%eax),%eax
c01025cb:	83 f8 24             	cmp    $0x24,%eax
c01025ce:	0f 84 b2 00 00 00    	je     c0102686 <trap_dispatch+0xc7>
c01025d4:	83 f8 24             	cmp    $0x24,%eax
c01025d7:	77 18                	ja     c01025f1 <trap_dispatch+0x32>
c01025d9:	83 f8 20             	cmp    $0x20,%eax
c01025dc:	74 7d                	je     c010265b <trap_dispatch+0x9c>
c01025de:	83 f8 21             	cmp    $0x21,%eax
c01025e1:	0f 84 c5 00 00 00    	je     c01026ac <trap_dispatch+0xed>
c01025e7:	83 f8 0e             	cmp    $0xe,%eax
c01025ea:	74 28                	je     c0102614 <trap_dispatch+0x55>
c01025ec:	e9 fd 00 00 00       	jmp    c01026ee <trap_dispatch+0x12f>
c01025f1:	83 f8 2e             	cmp    $0x2e,%eax
c01025f4:	0f 82 f4 00 00 00    	jb     c01026ee <trap_dispatch+0x12f>
c01025fa:	83 f8 2f             	cmp    $0x2f,%eax
c01025fd:	0f 86 23 01 00 00    	jbe    c0102726 <trap_dispatch+0x167>
c0102603:	83 e8 78             	sub    $0x78,%eax
c0102606:	83 f8 01             	cmp    $0x1,%eax
c0102609:	0f 87 df 00 00 00    	ja     c01026ee <trap_dispatch+0x12f>
c010260f:	e9 be 00 00 00       	jmp    c01026d2 <trap_dispatch+0x113>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102614:	8b 45 08             	mov    0x8(%ebp),%eax
c0102617:	89 04 24             	mov    %eax,(%esp)
c010261a:	e8 40 ff ff ff       	call   c010255f <pgfault_handler>
c010261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102622:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102626:	74 2e                	je     c0102656 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102628:	8b 45 08             	mov    0x8(%ebp),%eax
c010262b:	89 04 24             	mov    %eax,(%esp)
c010262e:	e8 33 fc ff ff       	call   c0102266 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102633:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102636:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010263a:	c7 44 24 08 1f 91 10 	movl   $0xc010911f,0x8(%esp)
c0102641:	c0 
c0102642:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102649:	00 
c010264a:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c0102651:	e8 7e e6 ff ff       	call   c0100cd4 <__panic>
        }
        break;
c0102656:	e9 cc 00 00 00       	jmp    c0102727 <trap_dispatch+0x168>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	if (++ticks == TICK_NUM) {
c010265b:	a1 bc 0a 12 c0       	mov    0xc0120abc,%eax
c0102660:	83 c0 01             	add    $0x1,%eax
c0102663:	a3 bc 0a 12 c0       	mov    %eax,0xc0120abc
c0102668:	83 f8 64             	cmp    $0x64,%eax
c010266b:	75 14                	jne    c0102681 <trap_dispatch+0xc2>
    		print_ticks();
c010266d:	e8 81 fa ff ff       	call   c01020f3 <print_ticks>
    		ticks = 0;
c0102672:	c7 05 bc 0a 12 c0 00 	movl   $0x0,0xc0120abc
c0102679:	00 00 00 
    	}
        break;
c010267c:	e9 a6 00 00 00       	jmp    c0102727 <trap_dispatch+0x168>
c0102681:	e9 a1 00 00 00       	jmp    c0102727 <trap_dispatch+0x168>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102686:	e8 b7 ef ff ff       	call   c0101642 <cons_getc>
c010268b:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c010268e:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102692:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102696:	89 54 24 08          	mov    %edx,0x8(%esp)
c010269a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010269e:	c7 04 24 3a 91 10 c0 	movl   $0xc010913a,(%esp)
c01026a5:	e8 a1 dc ff ff       	call   c010034b <cprintf>
        break;
c01026aa:	eb 7b                	jmp    c0102727 <trap_dispatch+0x168>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026ac:	e8 91 ef ff ff       	call   c0101642 <cons_getc>
c01026b1:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026b4:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026b8:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026c4:	c7 04 24 4c 91 10 c0 	movl   $0xc010914c,(%esp)
c01026cb:	e8 7b dc ff ff       	call   c010034b <cprintf>
        break;
c01026d0:	eb 55                	jmp    c0102727 <trap_dispatch+0x168>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026d2:	c7 44 24 08 5b 91 10 	movl   $0xc010915b,0x8(%esp)
c01026d9:	c0 
c01026da:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01026e1:	00 
c01026e2:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c01026e9:	e8 e6 e5 ff ff       	call   c0100cd4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01026f5:	0f b7 c0             	movzwl %ax,%eax
c01026f8:	83 e0 03             	and    $0x3,%eax
c01026fb:	85 c0                	test   %eax,%eax
c01026fd:	75 28                	jne    c0102727 <trap_dispatch+0x168>
            print_trapframe(tf);
c01026ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102702:	89 04 24             	mov    %eax,(%esp)
c0102705:	e8 5c fb ff ff       	call   c0102266 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c010270a:	c7 44 24 08 6b 91 10 	movl   $0xc010916b,0x8(%esp)
c0102711:	c0 
c0102712:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102719:	00 
c010271a:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c0102721:	e8 ae e5 ff ff       	call   c0100cd4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102726:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102727:	c9                   	leave  
c0102728:	c3                   	ret    

c0102729 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102729:	55                   	push   %ebp
c010272a:	89 e5                	mov    %esp,%ebp
c010272c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010272f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102732:	89 04 24             	mov    %eax,(%esp)
c0102735:	e8 85 fe ff ff       	call   c01025bf <trap_dispatch>
}
c010273a:	c9                   	leave  
c010273b:	c3                   	ret    

c010273c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010273c:	1e                   	push   %ds
    pushl %es
c010273d:	06                   	push   %es
    pushl %fs
c010273e:	0f a0                	push   %fs
    pushl %gs
c0102740:	0f a8                	push   %gs
    pushal
c0102742:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102743:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102748:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010274a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010274c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010274d:	e8 d7 ff ff ff       	call   c0102729 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102752:	5c                   	pop    %esp

c0102753 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102753:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102754:	0f a9                	pop    %gs
    popl %fs
c0102756:	0f a1                	pop    %fs
    popl %es
c0102758:	07                   	pop    %es
    popl %ds
c0102759:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010275a:	83 c4 08             	add    $0x8,%esp
    iret
c010275d:	cf                   	iret   

c010275e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c010275e:	6a 00                	push   $0x0
  pushl $0
c0102760:	6a 00                	push   $0x0
  jmp __alltraps
c0102762:	e9 d5 ff ff ff       	jmp    c010273c <__alltraps>

c0102767 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $1
c0102769:	6a 01                	push   $0x1
  jmp __alltraps
c010276b:	e9 cc ff ff ff       	jmp    c010273c <__alltraps>

c0102770 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $2
c0102772:	6a 02                	push   $0x2
  jmp __alltraps
c0102774:	e9 c3 ff ff ff       	jmp    c010273c <__alltraps>

c0102779 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $3
c010277b:	6a 03                	push   $0x3
  jmp __alltraps
c010277d:	e9 ba ff ff ff       	jmp    c010273c <__alltraps>

c0102782 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102782:	6a 00                	push   $0x0
  pushl $4
c0102784:	6a 04                	push   $0x4
  jmp __alltraps
c0102786:	e9 b1 ff ff ff       	jmp    c010273c <__alltraps>

c010278b <vector5>:
.globl vector5
vector5:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $5
c010278d:	6a 05                	push   $0x5
  jmp __alltraps
c010278f:	e9 a8 ff ff ff       	jmp    c010273c <__alltraps>

c0102794 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $6
c0102796:	6a 06                	push   $0x6
  jmp __alltraps
c0102798:	e9 9f ff ff ff       	jmp    c010273c <__alltraps>

c010279d <vector7>:
.globl vector7
vector7:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $7
c010279f:	6a 07                	push   $0x7
  jmp __alltraps
c01027a1:	e9 96 ff ff ff       	jmp    c010273c <__alltraps>

c01027a6 <vector8>:
.globl vector8
vector8:
  pushl $8
c01027a6:	6a 08                	push   $0x8
  jmp __alltraps
c01027a8:	e9 8f ff ff ff       	jmp    c010273c <__alltraps>

c01027ad <vector9>:
.globl vector9
vector9:
  pushl $9
c01027ad:	6a 09                	push   $0x9
  jmp __alltraps
c01027af:	e9 88 ff ff ff       	jmp    c010273c <__alltraps>

c01027b4 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027b4:	6a 0a                	push   $0xa
  jmp __alltraps
c01027b6:	e9 81 ff ff ff       	jmp    c010273c <__alltraps>

c01027bb <vector11>:
.globl vector11
vector11:
  pushl $11
c01027bb:	6a 0b                	push   $0xb
  jmp __alltraps
c01027bd:	e9 7a ff ff ff       	jmp    c010273c <__alltraps>

c01027c2 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027c2:	6a 0c                	push   $0xc
  jmp __alltraps
c01027c4:	e9 73 ff ff ff       	jmp    c010273c <__alltraps>

c01027c9 <vector13>:
.globl vector13
vector13:
  pushl $13
c01027c9:	6a 0d                	push   $0xd
  jmp __alltraps
c01027cb:	e9 6c ff ff ff       	jmp    c010273c <__alltraps>

c01027d0 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027d0:	6a 0e                	push   $0xe
  jmp __alltraps
c01027d2:	e9 65 ff ff ff       	jmp    c010273c <__alltraps>

c01027d7 <vector15>:
.globl vector15
vector15:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $15
c01027d9:	6a 0f                	push   $0xf
  jmp __alltraps
c01027db:	e9 5c ff ff ff       	jmp    c010273c <__alltraps>

c01027e0 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $16
c01027e2:	6a 10                	push   $0x10
  jmp __alltraps
c01027e4:	e9 53 ff ff ff       	jmp    c010273c <__alltraps>

c01027e9 <vector17>:
.globl vector17
vector17:
  pushl $17
c01027e9:	6a 11                	push   $0x11
  jmp __alltraps
c01027eb:	e9 4c ff ff ff       	jmp    c010273c <__alltraps>

c01027f0 <vector18>:
.globl vector18
vector18:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $18
c01027f2:	6a 12                	push   $0x12
  jmp __alltraps
c01027f4:	e9 43 ff ff ff       	jmp    c010273c <__alltraps>

c01027f9 <vector19>:
.globl vector19
vector19:
  pushl $0
c01027f9:	6a 00                	push   $0x0
  pushl $19
c01027fb:	6a 13                	push   $0x13
  jmp __alltraps
c01027fd:	e9 3a ff ff ff       	jmp    c010273c <__alltraps>

c0102802 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $20
c0102804:	6a 14                	push   $0x14
  jmp __alltraps
c0102806:	e9 31 ff ff ff       	jmp    c010273c <__alltraps>

c010280b <vector21>:
.globl vector21
vector21:
  pushl $0
c010280b:	6a 00                	push   $0x0
  pushl $21
c010280d:	6a 15                	push   $0x15
  jmp __alltraps
c010280f:	e9 28 ff ff ff       	jmp    c010273c <__alltraps>

c0102814 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $22
c0102816:	6a 16                	push   $0x16
  jmp __alltraps
c0102818:	e9 1f ff ff ff       	jmp    c010273c <__alltraps>

c010281d <vector23>:
.globl vector23
vector23:
  pushl $0
c010281d:	6a 00                	push   $0x0
  pushl $23
c010281f:	6a 17                	push   $0x17
  jmp __alltraps
c0102821:	e9 16 ff ff ff       	jmp    c010273c <__alltraps>

c0102826 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $24
c0102828:	6a 18                	push   $0x18
  jmp __alltraps
c010282a:	e9 0d ff ff ff       	jmp    c010273c <__alltraps>

c010282f <vector25>:
.globl vector25
vector25:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $25
c0102831:	6a 19                	push   $0x19
  jmp __alltraps
c0102833:	e9 04 ff ff ff       	jmp    c010273c <__alltraps>

c0102838 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $26
c010283a:	6a 1a                	push   $0x1a
  jmp __alltraps
c010283c:	e9 fb fe ff ff       	jmp    c010273c <__alltraps>

c0102841 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $27
c0102843:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102845:	e9 f2 fe ff ff       	jmp    c010273c <__alltraps>

c010284a <vector28>:
.globl vector28
vector28:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $28
c010284c:	6a 1c                	push   $0x1c
  jmp __alltraps
c010284e:	e9 e9 fe ff ff       	jmp    c010273c <__alltraps>

c0102853 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $29
c0102855:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102857:	e9 e0 fe ff ff       	jmp    c010273c <__alltraps>

c010285c <vector30>:
.globl vector30
vector30:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $30
c010285e:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102860:	e9 d7 fe ff ff       	jmp    c010273c <__alltraps>

c0102865 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $31
c0102867:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102869:	e9 ce fe ff ff       	jmp    c010273c <__alltraps>

c010286e <vector32>:
.globl vector32
vector32:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $32
c0102870:	6a 20                	push   $0x20
  jmp __alltraps
c0102872:	e9 c5 fe ff ff       	jmp    c010273c <__alltraps>

c0102877 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $33
c0102879:	6a 21                	push   $0x21
  jmp __alltraps
c010287b:	e9 bc fe ff ff       	jmp    c010273c <__alltraps>

c0102880 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $34
c0102882:	6a 22                	push   $0x22
  jmp __alltraps
c0102884:	e9 b3 fe ff ff       	jmp    c010273c <__alltraps>

c0102889 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $35
c010288b:	6a 23                	push   $0x23
  jmp __alltraps
c010288d:	e9 aa fe ff ff       	jmp    c010273c <__alltraps>

c0102892 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $36
c0102894:	6a 24                	push   $0x24
  jmp __alltraps
c0102896:	e9 a1 fe ff ff       	jmp    c010273c <__alltraps>

c010289b <vector37>:
.globl vector37
vector37:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $37
c010289d:	6a 25                	push   $0x25
  jmp __alltraps
c010289f:	e9 98 fe ff ff       	jmp    c010273c <__alltraps>

c01028a4 <vector38>:
.globl vector38
vector38:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $38
c01028a6:	6a 26                	push   $0x26
  jmp __alltraps
c01028a8:	e9 8f fe ff ff       	jmp    c010273c <__alltraps>

c01028ad <vector39>:
.globl vector39
vector39:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $39
c01028af:	6a 27                	push   $0x27
  jmp __alltraps
c01028b1:	e9 86 fe ff ff       	jmp    c010273c <__alltraps>

c01028b6 <vector40>:
.globl vector40
vector40:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $40
c01028b8:	6a 28                	push   $0x28
  jmp __alltraps
c01028ba:	e9 7d fe ff ff       	jmp    c010273c <__alltraps>

c01028bf <vector41>:
.globl vector41
vector41:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $41
c01028c1:	6a 29                	push   $0x29
  jmp __alltraps
c01028c3:	e9 74 fe ff ff       	jmp    c010273c <__alltraps>

c01028c8 <vector42>:
.globl vector42
vector42:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $42
c01028ca:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028cc:	e9 6b fe ff ff       	jmp    c010273c <__alltraps>

c01028d1 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $43
c01028d3:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028d5:	e9 62 fe ff ff       	jmp    c010273c <__alltraps>

c01028da <vector44>:
.globl vector44
vector44:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $44
c01028dc:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028de:	e9 59 fe ff ff       	jmp    c010273c <__alltraps>

c01028e3 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $45
c01028e5:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028e7:	e9 50 fe ff ff       	jmp    c010273c <__alltraps>

c01028ec <vector46>:
.globl vector46
vector46:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $46
c01028ee:	6a 2e                	push   $0x2e
  jmp __alltraps
c01028f0:	e9 47 fe ff ff       	jmp    c010273c <__alltraps>

c01028f5 <vector47>:
.globl vector47
vector47:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $47
c01028f7:	6a 2f                	push   $0x2f
  jmp __alltraps
c01028f9:	e9 3e fe ff ff       	jmp    c010273c <__alltraps>

c01028fe <vector48>:
.globl vector48
vector48:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $48
c0102900:	6a 30                	push   $0x30
  jmp __alltraps
c0102902:	e9 35 fe ff ff       	jmp    c010273c <__alltraps>

c0102907 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $49
c0102909:	6a 31                	push   $0x31
  jmp __alltraps
c010290b:	e9 2c fe ff ff       	jmp    c010273c <__alltraps>

c0102910 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $50
c0102912:	6a 32                	push   $0x32
  jmp __alltraps
c0102914:	e9 23 fe ff ff       	jmp    c010273c <__alltraps>

c0102919 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $51
c010291b:	6a 33                	push   $0x33
  jmp __alltraps
c010291d:	e9 1a fe ff ff       	jmp    c010273c <__alltraps>

c0102922 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $52
c0102924:	6a 34                	push   $0x34
  jmp __alltraps
c0102926:	e9 11 fe ff ff       	jmp    c010273c <__alltraps>

c010292b <vector53>:
.globl vector53
vector53:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $53
c010292d:	6a 35                	push   $0x35
  jmp __alltraps
c010292f:	e9 08 fe ff ff       	jmp    c010273c <__alltraps>

c0102934 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $54
c0102936:	6a 36                	push   $0x36
  jmp __alltraps
c0102938:	e9 ff fd ff ff       	jmp    c010273c <__alltraps>

c010293d <vector55>:
.globl vector55
vector55:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $55
c010293f:	6a 37                	push   $0x37
  jmp __alltraps
c0102941:	e9 f6 fd ff ff       	jmp    c010273c <__alltraps>

c0102946 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $56
c0102948:	6a 38                	push   $0x38
  jmp __alltraps
c010294a:	e9 ed fd ff ff       	jmp    c010273c <__alltraps>

c010294f <vector57>:
.globl vector57
vector57:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $57
c0102951:	6a 39                	push   $0x39
  jmp __alltraps
c0102953:	e9 e4 fd ff ff       	jmp    c010273c <__alltraps>

c0102958 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $58
c010295a:	6a 3a                	push   $0x3a
  jmp __alltraps
c010295c:	e9 db fd ff ff       	jmp    c010273c <__alltraps>

c0102961 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $59
c0102963:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102965:	e9 d2 fd ff ff       	jmp    c010273c <__alltraps>

c010296a <vector60>:
.globl vector60
vector60:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $60
c010296c:	6a 3c                	push   $0x3c
  jmp __alltraps
c010296e:	e9 c9 fd ff ff       	jmp    c010273c <__alltraps>

c0102973 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $61
c0102975:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102977:	e9 c0 fd ff ff       	jmp    c010273c <__alltraps>

c010297c <vector62>:
.globl vector62
vector62:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $62
c010297e:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102980:	e9 b7 fd ff ff       	jmp    c010273c <__alltraps>

c0102985 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $63
c0102987:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102989:	e9 ae fd ff ff       	jmp    c010273c <__alltraps>

c010298e <vector64>:
.globl vector64
vector64:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $64
c0102990:	6a 40                	push   $0x40
  jmp __alltraps
c0102992:	e9 a5 fd ff ff       	jmp    c010273c <__alltraps>

c0102997 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $65
c0102999:	6a 41                	push   $0x41
  jmp __alltraps
c010299b:	e9 9c fd ff ff       	jmp    c010273c <__alltraps>

c01029a0 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $66
c01029a2:	6a 42                	push   $0x42
  jmp __alltraps
c01029a4:	e9 93 fd ff ff       	jmp    c010273c <__alltraps>

c01029a9 <vector67>:
.globl vector67
vector67:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $67
c01029ab:	6a 43                	push   $0x43
  jmp __alltraps
c01029ad:	e9 8a fd ff ff       	jmp    c010273c <__alltraps>

c01029b2 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $68
c01029b4:	6a 44                	push   $0x44
  jmp __alltraps
c01029b6:	e9 81 fd ff ff       	jmp    c010273c <__alltraps>

c01029bb <vector69>:
.globl vector69
vector69:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $69
c01029bd:	6a 45                	push   $0x45
  jmp __alltraps
c01029bf:	e9 78 fd ff ff       	jmp    c010273c <__alltraps>

c01029c4 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $70
c01029c6:	6a 46                	push   $0x46
  jmp __alltraps
c01029c8:	e9 6f fd ff ff       	jmp    c010273c <__alltraps>

c01029cd <vector71>:
.globl vector71
vector71:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $71
c01029cf:	6a 47                	push   $0x47
  jmp __alltraps
c01029d1:	e9 66 fd ff ff       	jmp    c010273c <__alltraps>

c01029d6 <vector72>:
.globl vector72
vector72:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $72
c01029d8:	6a 48                	push   $0x48
  jmp __alltraps
c01029da:	e9 5d fd ff ff       	jmp    c010273c <__alltraps>

c01029df <vector73>:
.globl vector73
vector73:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $73
c01029e1:	6a 49                	push   $0x49
  jmp __alltraps
c01029e3:	e9 54 fd ff ff       	jmp    c010273c <__alltraps>

c01029e8 <vector74>:
.globl vector74
vector74:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $74
c01029ea:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029ec:	e9 4b fd ff ff       	jmp    c010273c <__alltraps>

c01029f1 <vector75>:
.globl vector75
vector75:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $75
c01029f3:	6a 4b                	push   $0x4b
  jmp __alltraps
c01029f5:	e9 42 fd ff ff       	jmp    c010273c <__alltraps>

c01029fa <vector76>:
.globl vector76
vector76:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $76
c01029fc:	6a 4c                	push   $0x4c
  jmp __alltraps
c01029fe:	e9 39 fd ff ff       	jmp    c010273c <__alltraps>

c0102a03 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $77
c0102a05:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a07:	e9 30 fd ff ff       	jmp    c010273c <__alltraps>

c0102a0c <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $78
c0102a0e:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a10:	e9 27 fd ff ff       	jmp    c010273c <__alltraps>

c0102a15 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $79
c0102a17:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a19:	e9 1e fd ff ff       	jmp    c010273c <__alltraps>

c0102a1e <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $80
c0102a20:	6a 50                	push   $0x50
  jmp __alltraps
c0102a22:	e9 15 fd ff ff       	jmp    c010273c <__alltraps>

c0102a27 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $81
c0102a29:	6a 51                	push   $0x51
  jmp __alltraps
c0102a2b:	e9 0c fd ff ff       	jmp    c010273c <__alltraps>

c0102a30 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $82
c0102a32:	6a 52                	push   $0x52
  jmp __alltraps
c0102a34:	e9 03 fd ff ff       	jmp    c010273c <__alltraps>

c0102a39 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $83
c0102a3b:	6a 53                	push   $0x53
  jmp __alltraps
c0102a3d:	e9 fa fc ff ff       	jmp    c010273c <__alltraps>

c0102a42 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $84
c0102a44:	6a 54                	push   $0x54
  jmp __alltraps
c0102a46:	e9 f1 fc ff ff       	jmp    c010273c <__alltraps>

c0102a4b <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $85
c0102a4d:	6a 55                	push   $0x55
  jmp __alltraps
c0102a4f:	e9 e8 fc ff ff       	jmp    c010273c <__alltraps>

c0102a54 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $86
c0102a56:	6a 56                	push   $0x56
  jmp __alltraps
c0102a58:	e9 df fc ff ff       	jmp    c010273c <__alltraps>

c0102a5d <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $87
c0102a5f:	6a 57                	push   $0x57
  jmp __alltraps
c0102a61:	e9 d6 fc ff ff       	jmp    c010273c <__alltraps>

c0102a66 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $88
c0102a68:	6a 58                	push   $0x58
  jmp __alltraps
c0102a6a:	e9 cd fc ff ff       	jmp    c010273c <__alltraps>

c0102a6f <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $89
c0102a71:	6a 59                	push   $0x59
  jmp __alltraps
c0102a73:	e9 c4 fc ff ff       	jmp    c010273c <__alltraps>

c0102a78 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $90
c0102a7a:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a7c:	e9 bb fc ff ff       	jmp    c010273c <__alltraps>

c0102a81 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $91
c0102a83:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a85:	e9 b2 fc ff ff       	jmp    c010273c <__alltraps>

c0102a8a <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $92
c0102a8c:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102a8e:	e9 a9 fc ff ff       	jmp    c010273c <__alltraps>

c0102a93 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $93
c0102a95:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a97:	e9 a0 fc ff ff       	jmp    c010273c <__alltraps>

c0102a9c <vector94>:
.globl vector94
vector94:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $94
c0102a9e:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102aa0:	e9 97 fc ff ff       	jmp    c010273c <__alltraps>

c0102aa5 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $95
c0102aa7:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102aa9:	e9 8e fc ff ff       	jmp    c010273c <__alltraps>

c0102aae <vector96>:
.globl vector96
vector96:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $96
c0102ab0:	6a 60                	push   $0x60
  jmp __alltraps
c0102ab2:	e9 85 fc ff ff       	jmp    c010273c <__alltraps>

c0102ab7 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $97
c0102ab9:	6a 61                	push   $0x61
  jmp __alltraps
c0102abb:	e9 7c fc ff ff       	jmp    c010273c <__alltraps>

c0102ac0 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $98
c0102ac2:	6a 62                	push   $0x62
  jmp __alltraps
c0102ac4:	e9 73 fc ff ff       	jmp    c010273c <__alltraps>

c0102ac9 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $99
c0102acb:	6a 63                	push   $0x63
  jmp __alltraps
c0102acd:	e9 6a fc ff ff       	jmp    c010273c <__alltraps>

c0102ad2 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $100
c0102ad4:	6a 64                	push   $0x64
  jmp __alltraps
c0102ad6:	e9 61 fc ff ff       	jmp    c010273c <__alltraps>

c0102adb <vector101>:
.globl vector101
vector101:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $101
c0102add:	6a 65                	push   $0x65
  jmp __alltraps
c0102adf:	e9 58 fc ff ff       	jmp    c010273c <__alltraps>

c0102ae4 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $102
c0102ae6:	6a 66                	push   $0x66
  jmp __alltraps
c0102ae8:	e9 4f fc ff ff       	jmp    c010273c <__alltraps>

c0102aed <vector103>:
.globl vector103
vector103:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $103
c0102aef:	6a 67                	push   $0x67
  jmp __alltraps
c0102af1:	e9 46 fc ff ff       	jmp    c010273c <__alltraps>

c0102af6 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $104
c0102af8:	6a 68                	push   $0x68
  jmp __alltraps
c0102afa:	e9 3d fc ff ff       	jmp    c010273c <__alltraps>

c0102aff <vector105>:
.globl vector105
vector105:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $105
c0102b01:	6a 69                	push   $0x69
  jmp __alltraps
c0102b03:	e9 34 fc ff ff       	jmp    c010273c <__alltraps>

c0102b08 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $106
c0102b0a:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b0c:	e9 2b fc ff ff       	jmp    c010273c <__alltraps>

c0102b11 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $107
c0102b13:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b15:	e9 22 fc ff ff       	jmp    c010273c <__alltraps>

c0102b1a <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $108
c0102b1c:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b1e:	e9 19 fc ff ff       	jmp    c010273c <__alltraps>

c0102b23 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $109
c0102b25:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b27:	e9 10 fc ff ff       	jmp    c010273c <__alltraps>

c0102b2c <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $110
c0102b2e:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b30:	e9 07 fc ff ff       	jmp    c010273c <__alltraps>

c0102b35 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $111
c0102b37:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b39:	e9 fe fb ff ff       	jmp    c010273c <__alltraps>

c0102b3e <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $112
c0102b40:	6a 70                	push   $0x70
  jmp __alltraps
c0102b42:	e9 f5 fb ff ff       	jmp    c010273c <__alltraps>

c0102b47 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $113
c0102b49:	6a 71                	push   $0x71
  jmp __alltraps
c0102b4b:	e9 ec fb ff ff       	jmp    c010273c <__alltraps>

c0102b50 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $114
c0102b52:	6a 72                	push   $0x72
  jmp __alltraps
c0102b54:	e9 e3 fb ff ff       	jmp    c010273c <__alltraps>

c0102b59 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $115
c0102b5b:	6a 73                	push   $0x73
  jmp __alltraps
c0102b5d:	e9 da fb ff ff       	jmp    c010273c <__alltraps>

c0102b62 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $116
c0102b64:	6a 74                	push   $0x74
  jmp __alltraps
c0102b66:	e9 d1 fb ff ff       	jmp    c010273c <__alltraps>

c0102b6b <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $117
c0102b6d:	6a 75                	push   $0x75
  jmp __alltraps
c0102b6f:	e9 c8 fb ff ff       	jmp    c010273c <__alltraps>

c0102b74 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $118
c0102b76:	6a 76                	push   $0x76
  jmp __alltraps
c0102b78:	e9 bf fb ff ff       	jmp    c010273c <__alltraps>

c0102b7d <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $119
c0102b7f:	6a 77                	push   $0x77
  jmp __alltraps
c0102b81:	e9 b6 fb ff ff       	jmp    c010273c <__alltraps>

c0102b86 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $120
c0102b88:	6a 78                	push   $0x78
  jmp __alltraps
c0102b8a:	e9 ad fb ff ff       	jmp    c010273c <__alltraps>

c0102b8f <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $121
c0102b91:	6a 79                	push   $0x79
  jmp __alltraps
c0102b93:	e9 a4 fb ff ff       	jmp    c010273c <__alltraps>

c0102b98 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $122
c0102b9a:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102b9c:	e9 9b fb ff ff       	jmp    c010273c <__alltraps>

c0102ba1 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $123
c0102ba3:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102ba5:	e9 92 fb ff ff       	jmp    c010273c <__alltraps>

c0102baa <vector124>:
.globl vector124
vector124:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $124
c0102bac:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102bae:	e9 89 fb ff ff       	jmp    c010273c <__alltraps>

c0102bb3 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $125
c0102bb5:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bb7:	e9 80 fb ff ff       	jmp    c010273c <__alltraps>

c0102bbc <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $126
c0102bbe:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bc0:	e9 77 fb ff ff       	jmp    c010273c <__alltraps>

c0102bc5 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $127
c0102bc7:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bc9:	e9 6e fb ff ff       	jmp    c010273c <__alltraps>

c0102bce <vector128>:
.globl vector128
vector128:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $128
c0102bd0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102bd5:	e9 62 fb ff ff       	jmp    c010273c <__alltraps>

c0102bda <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bda:	6a 00                	push   $0x0
  pushl $129
c0102bdc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102be1:	e9 56 fb ff ff       	jmp    c010273c <__alltraps>

c0102be6 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102be6:	6a 00                	push   $0x0
  pushl $130
c0102be8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102bed:	e9 4a fb ff ff       	jmp    c010273c <__alltraps>

c0102bf2 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $131
c0102bf4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102bf9:	e9 3e fb ff ff       	jmp    c010273c <__alltraps>

c0102bfe <vector132>:
.globl vector132
vector132:
  pushl $0
c0102bfe:	6a 00                	push   $0x0
  pushl $132
c0102c00:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c05:	e9 32 fb ff ff       	jmp    c010273c <__alltraps>

c0102c0a <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c0a:	6a 00                	push   $0x0
  pushl $133
c0102c0c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c11:	e9 26 fb ff ff       	jmp    c010273c <__alltraps>

c0102c16 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c16:	6a 00                	push   $0x0
  pushl $134
c0102c18:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c1d:	e9 1a fb ff ff       	jmp    c010273c <__alltraps>

c0102c22 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c22:	6a 00                	push   $0x0
  pushl $135
c0102c24:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c29:	e9 0e fb ff ff       	jmp    c010273c <__alltraps>

c0102c2e <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c2e:	6a 00                	push   $0x0
  pushl $136
c0102c30:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c35:	e9 02 fb ff ff       	jmp    c010273c <__alltraps>

c0102c3a <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c3a:	6a 00                	push   $0x0
  pushl $137
c0102c3c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c41:	e9 f6 fa ff ff       	jmp    c010273c <__alltraps>

c0102c46 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c46:	6a 00                	push   $0x0
  pushl $138
c0102c48:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c4d:	e9 ea fa ff ff       	jmp    c010273c <__alltraps>

c0102c52 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c52:	6a 00                	push   $0x0
  pushl $139
c0102c54:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c59:	e9 de fa ff ff       	jmp    c010273c <__alltraps>

c0102c5e <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c5e:	6a 00                	push   $0x0
  pushl $140
c0102c60:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c65:	e9 d2 fa ff ff       	jmp    c010273c <__alltraps>

c0102c6a <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c6a:	6a 00                	push   $0x0
  pushl $141
c0102c6c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c71:	e9 c6 fa ff ff       	jmp    c010273c <__alltraps>

c0102c76 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c76:	6a 00                	push   $0x0
  pushl $142
c0102c78:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c7d:	e9 ba fa ff ff       	jmp    c010273c <__alltraps>

c0102c82 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c82:	6a 00                	push   $0x0
  pushl $143
c0102c84:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c89:	e9 ae fa ff ff       	jmp    c010273c <__alltraps>

c0102c8e <vector144>:
.globl vector144
vector144:
  pushl $0
c0102c8e:	6a 00                	push   $0x0
  pushl $144
c0102c90:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c95:	e9 a2 fa ff ff       	jmp    c010273c <__alltraps>

c0102c9a <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c9a:	6a 00                	push   $0x0
  pushl $145
c0102c9c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102ca1:	e9 96 fa ff ff       	jmp    c010273c <__alltraps>

c0102ca6 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102ca6:	6a 00                	push   $0x0
  pushl $146
c0102ca8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102cad:	e9 8a fa ff ff       	jmp    c010273c <__alltraps>

c0102cb2 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102cb2:	6a 00                	push   $0x0
  pushl $147
c0102cb4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cb9:	e9 7e fa ff ff       	jmp    c010273c <__alltraps>

c0102cbe <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cbe:	6a 00                	push   $0x0
  pushl $148
c0102cc0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cc5:	e9 72 fa ff ff       	jmp    c010273c <__alltraps>

c0102cca <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $149
c0102ccc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102cd1:	e9 66 fa ff ff       	jmp    c010273c <__alltraps>

c0102cd6 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cd6:	6a 00                	push   $0x0
  pushl $150
c0102cd8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102cdd:	e9 5a fa ff ff       	jmp    c010273c <__alltraps>

c0102ce2 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102ce2:	6a 00                	push   $0x0
  pushl $151
c0102ce4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102ce9:	e9 4e fa ff ff       	jmp    c010273c <__alltraps>

c0102cee <vector152>:
.globl vector152
vector152:
  pushl $0
c0102cee:	6a 00                	push   $0x0
  pushl $152
c0102cf0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102cf5:	e9 42 fa ff ff       	jmp    c010273c <__alltraps>

c0102cfa <vector153>:
.globl vector153
vector153:
  pushl $0
c0102cfa:	6a 00                	push   $0x0
  pushl $153
c0102cfc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d01:	e9 36 fa ff ff       	jmp    c010273c <__alltraps>

c0102d06 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d06:	6a 00                	push   $0x0
  pushl $154
c0102d08:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d0d:	e9 2a fa ff ff       	jmp    c010273c <__alltraps>

c0102d12 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d12:	6a 00                	push   $0x0
  pushl $155
c0102d14:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d19:	e9 1e fa ff ff       	jmp    c010273c <__alltraps>

c0102d1e <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d1e:	6a 00                	push   $0x0
  pushl $156
c0102d20:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d25:	e9 12 fa ff ff       	jmp    c010273c <__alltraps>

c0102d2a <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d2a:	6a 00                	push   $0x0
  pushl $157
c0102d2c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d31:	e9 06 fa ff ff       	jmp    c010273c <__alltraps>

c0102d36 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d36:	6a 00                	push   $0x0
  pushl $158
c0102d38:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d3d:	e9 fa f9 ff ff       	jmp    c010273c <__alltraps>

c0102d42 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d42:	6a 00                	push   $0x0
  pushl $159
c0102d44:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d49:	e9 ee f9 ff ff       	jmp    c010273c <__alltraps>

c0102d4e <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d4e:	6a 00                	push   $0x0
  pushl $160
c0102d50:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d55:	e9 e2 f9 ff ff       	jmp    c010273c <__alltraps>

c0102d5a <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d5a:	6a 00                	push   $0x0
  pushl $161
c0102d5c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d61:	e9 d6 f9 ff ff       	jmp    c010273c <__alltraps>

c0102d66 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d66:	6a 00                	push   $0x0
  pushl $162
c0102d68:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d6d:	e9 ca f9 ff ff       	jmp    c010273c <__alltraps>

c0102d72 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d72:	6a 00                	push   $0x0
  pushl $163
c0102d74:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d79:	e9 be f9 ff ff       	jmp    c010273c <__alltraps>

c0102d7e <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d7e:	6a 00                	push   $0x0
  pushl $164
c0102d80:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d85:	e9 b2 f9 ff ff       	jmp    c010273c <__alltraps>

c0102d8a <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d8a:	6a 00                	push   $0x0
  pushl $165
c0102d8c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d91:	e9 a6 f9 ff ff       	jmp    c010273c <__alltraps>

c0102d96 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d96:	6a 00                	push   $0x0
  pushl $166
c0102d98:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102d9d:	e9 9a f9 ff ff       	jmp    c010273c <__alltraps>

c0102da2 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102da2:	6a 00                	push   $0x0
  pushl $167
c0102da4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102da9:	e9 8e f9 ff ff       	jmp    c010273c <__alltraps>

c0102dae <vector168>:
.globl vector168
vector168:
  pushl $0
c0102dae:	6a 00                	push   $0x0
  pushl $168
c0102db0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102db5:	e9 82 f9 ff ff       	jmp    c010273c <__alltraps>

c0102dba <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dba:	6a 00                	push   $0x0
  pushl $169
c0102dbc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102dc1:	e9 76 f9 ff ff       	jmp    c010273c <__alltraps>

c0102dc6 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dc6:	6a 00                	push   $0x0
  pushl $170
c0102dc8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102dcd:	e9 6a f9 ff ff       	jmp    c010273c <__alltraps>

c0102dd2 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102dd2:	6a 00                	push   $0x0
  pushl $171
c0102dd4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102dd9:	e9 5e f9 ff ff       	jmp    c010273c <__alltraps>

c0102dde <vector172>:
.globl vector172
vector172:
  pushl $0
c0102dde:	6a 00                	push   $0x0
  pushl $172
c0102de0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102de5:	e9 52 f9 ff ff       	jmp    c010273c <__alltraps>

c0102dea <vector173>:
.globl vector173
vector173:
  pushl $0
c0102dea:	6a 00                	push   $0x0
  pushl $173
c0102dec:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102df1:	e9 46 f9 ff ff       	jmp    c010273c <__alltraps>

c0102df6 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102df6:	6a 00                	push   $0x0
  pushl $174
c0102df8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102dfd:	e9 3a f9 ff ff       	jmp    c010273c <__alltraps>

c0102e02 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e02:	6a 00                	push   $0x0
  pushl $175
c0102e04:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e09:	e9 2e f9 ff ff       	jmp    c010273c <__alltraps>

c0102e0e <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e0e:	6a 00                	push   $0x0
  pushl $176
c0102e10:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e15:	e9 22 f9 ff ff       	jmp    c010273c <__alltraps>

c0102e1a <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e1a:	6a 00                	push   $0x0
  pushl $177
c0102e1c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e21:	e9 16 f9 ff ff       	jmp    c010273c <__alltraps>

c0102e26 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e26:	6a 00                	push   $0x0
  pushl $178
c0102e28:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e2d:	e9 0a f9 ff ff       	jmp    c010273c <__alltraps>

c0102e32 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e32:	6a 00                	push   $0x0
  pushl $179
c0102e34:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e39:	e9 fe f8 ff ff       	jmp    c010273c <__alltraps>

c0102e3e <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e3e:	6a 00                	push   $0x0
  pushl $180
c0102e40:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e45:	e9 f2 f8 ff ff       	jmp    c010273c <__alltraps>

c0102e4a <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e4a:	6a 00                	push   $0x0
  pushl $181
c0102e4c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e51:	e9 e6 f8 ff ff       	jmp    c010273c <__alltraps>

c0102e56 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e56:	6a 00                	push   $0x0
  pushl $182
c0102e58:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e5d:	e9 da f8 ff ff       	jmp    c010273c <__alltraps>

c0102e62 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e62:	6a 00                	push   $0x0
  pushl $183
c0102e64:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e69:	e9 ce f8 ff ff       	jmp    c010273c <__alltraps>

c0102e6e <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e6e:	6a 00                	push   $0x0
  pushl $184
c0102e70:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e75:	e9 c2 f8 ff ff       	jmp    c010273c <__alltraps>

c0102e7a <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e7a:	6a 00                	push   $0x0
  pushl $185
c0102e7c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e81:	e9 b6 f8 ff ff       	jmp    c010273c <__alltraps>

c0102e86 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e86:	6a 00                	push   $0x0
  pushl $186
c0102e88:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e8d:	e9 aa f8 ff ff       	jmp    c010273c <__alltraps>

c0102e92 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e92:	6a 00                	push   $0x0
  pushl $187
c0102e94:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e99:	e9 9e f8 ff ff       	jmp    c010273c <__alltraps>

c0102e9e <vector188>:
.globl vector188
vector188:
  pushl $0
c0102e9e:	6a 00                	push   $0x0
  pushl $188
c0102ea0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102ea5:	e9 92 f8 ff ff       	jmp    c010273c <__alltraps>

c0102eaa <vector189>:
.globl vector189
vector189:
  pushl $0
c0102eaa:	6a 00                	push   $0x0
  pushl $189
c0102eac:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102eb1:	e9 86 f8 ff ff       	jmp    c010273c <__alltraps>

c0102eb6 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102eb6:	6a 00                	push   $0x0
  pushl $190
c0102eb8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ebd:	e9 7a f8 ff ff       	jmp    c010273c <__alltraps>

c0102ec2 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ec2:	6a 00                	push   $0x0
  pushl $191
c0102ec4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102ec9:	e9 6e f8 ff ff       	jmp    c010273c <__alltraps>

c0102ece <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ece:	6a 00                	push   $0x0
  pushl $192
c0102ed0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ed5:	e9 62 f8 ff ff       	jmp    c010273c <__alltraps>

c0102eda <vector193>:
.globl vector193
vector193:
  pushl $0
c0102eda:	6a 00                	push   $0x0
  pushl $193
c0102edc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ee1:	e9 56 f8 ff ff       	jmp    c010273c <__alltraps>

c0102ee6 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ee6:	6a 00                	push   $0x0
  pushl $194
c0102ee8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102eed:	e9 4a f8 ff ff       	jmp    c010273c <__alltraps>

c0102ef2 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102ef2:	6a 00                	push   $0x0
  pushl $195
c0102ef4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102ef9:	e9 3e f8 ff ff       	jmp    c010273c <__alltraps>

c0102efe <vector196>:
.globl vector196
vector196:
  pushl $0
c0102efe:	6a 00                	push   $0x0
  pushl $196
c0102f00:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f05:	e9 32 f8 ff ff       	jmp    c010273c <__alltraps>

c0102f0a <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f0a:	6a 00                	push   $0x0
  pushl $197
c0102f0c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f11:	e9 26 f8 ff ff       	jmp    c010273c <__alltraps>

c0102f16 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f16:	6a 00                	push   $0x0
  pushl $198
c0102f18:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f1d:	e9 1a f8 ff ff       	jmp    c010273c <__alltraps>

c0102f22 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f22:	6a 00                	push   $0x0
  pushl $199
c0102f24:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f29:	e9 0e f8 ff ff       	jmp    c010273c <__alltraps>

c0102f2e <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f2e:	6a 00                	push   $0x0
  pushl $200
c0102f30:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f35:	e9 02 f8 ff ff       	jmp    c010273c <__alltraps>

c0102f3a <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f3a:	6a 00                	push   $0x0
  pushl $201
c0102f3c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f41:	e9 f6 f7 ff ff       	jmp    c010273c <__alltraps>

c0102f46 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f46:	6a 00                	push   $0x0
  pushl $202
c0102f48:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f4d:	e9 ea f7 ff ff       	jmp    c010273c <__alltraps>

c0102f52 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f52:	6a 00                	push   $0x0
  pushl $203
c0102f54:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f59:	e9 de f7 ff ff       	jmp    c010273c <__alltraps>

c0102f5e <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f5e:	6a 00                	push   $0x0
  pushl $204
c0102f60:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f65:	e9 d2 f7 ff ff       	jmp    c010273c <__alltraps>

c0102f6a <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f6a:	6a 00                	push   $0x0
  pushl $205
c0102f6c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f71:	e9 c6 f7 ff ff       	jmp    c010273c <__alltraps>

c0102f76 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f76:	6a 00                	push   $0x0
  pushl $206
c0102f78:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f7d:	e9 ba f7 ff ff       	jmp    c010273c <__alltraps>

c0102f82 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f82:	6a 00                	push   $0x0
  pushl $207
c0102f84:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f89:	e9 ae f7 ff ff       	jmp    c010273c <__alltraps>

c0102f8e <vector208>:
.globl vector208
vector208:
  pushl $0
c0102f8e:	6a 00                	push   $0x0
  pushl $208
c0102f90:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f95:	e9 a2 f7 ff ff       	jmp    c010273c <__alltraps>

c0102f9a <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f9a:	6a 00                	push   $0x0
  pushl $209
c0102f9c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fa1:	e9 96 f7 ff ff       	jmp    c010273c <__alltraps>

c0102fa6 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102fa6:	6a 00                	push   $0x0
  pushl $210
c0102fa8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fad:	e9 8a f7 ff ff       	jmp    c010273c <__alltraps>

c0102fb2 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fb2:	6a 00                	push   $0x0
  pushl $211
c0102fb4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fb9:	e9 7e f7 ff ff       	jmp    c010273c <__alltraps>

c0102fbe <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fbe:	6a 00                	push   $0x0
  pushl $212
c0102fc0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fc5:	e9 72 f7 ff ff       	jmp    c010273c <__alltraps>

c0102fca <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fca:	6a 00                	push   $0x0
  pushl $213
c0102fcc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fd1:	e9 66 f7 ff ff       	jmp    c010273c <__alltraps>

c0102fd6 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fd6:	6a 00                	push   $0x0
  pushl $214
c0102fd8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fdd:	e9 5a f7 ff ff       	jmp    c010273c <__alltraps>

c0102fe2 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102fe2:	6a 00                	push   $0x0
  pushl $215
c0102fe4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102fe9:	e9 4e f7 ff ff       	jmp    c010273c <__alltraps>

c0102fee <vector216>:
.globl vector216
vector216:
  pushl $0
c0102fee:	6a 00                	push   $0x0
  pushl $216
c0102ff0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102ff5:	e9 42 f7 ff ff       	jmp    c010273c <__alltraps>

c0102ffa <vector217>:
.globl vector217
vector217:
  pushl $0
c0102ffa:	6a 00                	push   $0x0
  pushl $217
c0102ffc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103001:	e9 36 f7 ff ff       	jmp    c010273c <__alltraps>

c0103006 <vector218>:
.globl vector218
vector218:
  pushl $0
c0103006:	6a 00                	push   $0x0
  pushl $218
c0103008:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010300d:	e9 2a f7 ff ff       	jmp    c010273c <__alltraps>

c0103012 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103012:	6a 00                	push   $0x0
  pushl $219
c0103014:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103019:	e9 1e f7 ff ff       	jmp    c010273c <__alltraps>

c010301e <vector220>:
.globl vector220
vector220:
  pushl $0
c010301e:	6a 00                	push   $0x0
  pushl $220
c0103020:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103025:	e9 12 f7 ff ff       	jmp    c010273c <__alltraps>

c010302a <vector221>:
.globl vector221
vector221:
  pushl $0
c010302a:	6a 00                	push   $0x0
  pushl $221
c010302c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103031:	e9 06 f7 ff ff       	jmp    c010273c <__alltraps>

c0103036 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103036:	6a 00                	push   $0x0
  pushl $222
c0103038:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010303d:	e9 fa f6 ff ff       	jmp    c010273c <__alltraps>

c0103042 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103042:	6a 00                	push   $0x0
  pushl $223
c0103044:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103049:	e9 ee f6 ff ff       	jmp    c010273c <__alltraps>

c010304e <vector224>:
.globl vector224
vector224:
  pushl $0
c010304e:	6a 00                	push   $0x0
  pushl $224
c0103050:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103055:	e9 e2 f6 ff ff       	jmp    c010273c <__alltraps>

c010305a <vector225>:
.globl vector225
vector225:
  pushl $0
c010305a:	6a 00                	push   $0x0
  pushl $225
c010305c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103061:	e9 d6 f6 ff ff       	jmp    c010273c <__alltraps>

c0103066 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103066:	6a 00                	push   $0x0
  pushl $226
c0103068:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010306d:	e9 ca f6 ff ff       	jmp    c010273c <__alltraps>

c0103072 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103072:	6a 00                	push   $0x0
  pushl $227
c0103074:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103079:	e9 be f6 ff ff       	jmp    c010273c <__alltraps>

c010307e <vector228>:
.globl vector228
vector228:
  pushl $0
c010307e:	6a 00                	push   $0x0
  pushl $228
c0103080:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103085:	e9 b2 f6 ff ff       	jmp    c010273c <__alltraps>

c010308a <vector229>:
.globl vector229
vector229:
  pushl $0
c010308a:	6a 00                	push   $0x0
  pushl $229
c010308c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103091:	e9 a6 f6 ff ff       	jmp    c010273c <__alltraps>

c0103096 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103096:	6a 00                	push   $0x0
  pushl $230
c0103098:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010309d:	e9 9a f6 ff ff       	jmp    c010273c <__alltraps>

c01030a2 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030a2:	6a 00                	push   $0x0
  pushl $231
c01030a4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030a9:	e9 8e f6 ff ff       	jmp    c010273c <__alltraps>

c01030ae <vector232>:
.globl vector232
vector232:
  pushl $0
c01030ae:	6a 00                	push   $0x0
  pushl $232
c01030b0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030b5:	e9 82 f6 ff ff       	jmp    c010273c <__alltraps>

c01030ba <vector233>:
.globl vector233
vector233:
  pushl $0
c01030ba:	6a 00                	push   $0x0
  pushl $233
c01030bc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030c1:	e9 76 f6 ff ff       	jmp    c010273c <__alltraps>

c01030c6 <vector234>:
.globl vector234
vector234:
  pushl $0
c01030c6:	6a 00                	push   $0x0
  pushl $234
c01030c8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030cd:	e9 6a f6 ff ff       	jmp    c010273c <__alltraps>

c01030d2 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030d2:	6a 00                	push   $0x0
  pushl $235
c01030d4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030d9:	e9 5e f6 ff ff       	jmp    c010273c <__alltraps>

c01030de <vector236>:
.globl vector236
vector236:
  pushl $0
c01030de:	6a 00                	push   $0x0
  pushl $236
c01030e0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030e5:	e9 52 f6 ff ff       	jmp    c010273c <__alltraps>

c01030ea <vector237>:
.globl vector237
vector237:
  pushl $0
c01030ea:	6a 00                	push   $0x0
  pushl $237
c01030ec:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01030f1:	e9 46 f6 ff ff       	jmp    c010273c <__alltraps>

c01030f6 <vector238>:
.globl vector238
vector238:
  pushl $0
c01030f6:	6a 00                	push   $0x0
  pushl $238
c01030f8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01030fd:	e9 3a f6 ff ff       	jmp    c010273c <__alltraps>

c0103102 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103102:	6a 00                	push   $0x0
  pushl $239
c0103104:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0103109:	e9 2e f6 ff ff       	jmp    c010273c <__alltraps>

c010310e <vector240>:
.globl vector240
vector240:
  pushl $0
c010310e:	6a 00                	push   $0x0
  pushl $240
c0103110:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103115:	e9 22 f6 ff ff       	jmp    c010273c <__alltraps>

c010311a <vector241>:
.globl vector241
vector241:
  pushl $0
c010311a:	6a 00                	push   $0x0
  pushl $241
c010311c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103121:	e9 16 f6 ff ff       	jmp    c010273c <__alltraps>

c0103126 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103126:	6a 00                	push   $0x0
  pushl $242
c0103128:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010312d:	e9 0a f6 ff ff       	jmp    c010273c <__alltraps>

c0103132 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103132:	6a 00                	push   $0x0
  pushl $243
c0103134:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103139:	e9 fe f5 ff ff       	jmp    c010273c <__alltraps>

c010313e <vector244>:
.globl vector244
vector244:
  pushl $0
c010313e:	6a 00                	push   $0x0
  pushl $244
c0103140:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103145:	e9 f2 f5 ff ff       	jmp    c010273c <__alltraps>

c010314a <vector245>:
.globl vector245
vector245:
  pushl $0
c010314a:	6a 00                	push   $0x0
  pushl $245
c010314c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103151:	e9 e6 f5 ff ff       	jmp    c010273c <__alltraps>

c0103156 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103156:	6a 00                	push   $0x0
  pushl $246
c0103158:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010315d:	e9 da f5 ff ff       	jmp    c010273c <__alltraps>

c0103162 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103162:	6a 00                	push   $0x0
  pushl $247
c0103164:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103169:	e9 ce f5 ff ff       	jmp    c010273c <__alltraps>

c010316e <vector248>:
.globl vector248
vector248:
  pushl $0
c010316e:	6a 00                	push   $0x0
  pushl $248
c0103170:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103175:	e9 c2 f5 ff ff       	jmp    c010273c <__alltraps>

c010317a <vector249>:
.globl vector249
vector249:
  pushl $0
c010317a:	6a 00                	push   $0x0
  pushl $249
c010317c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103181:	e9 b6 f5 ff ff       	jmp    c010273c <__alltraps>

c0103186 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103186:	6a 00                	push   $0x0
  pushl $250
c0103188:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010318d:	e9 aa f5 ff ff       	jmp    c010273c <__alltraps>

c0103192 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103192:	6a 00                	push   $0x0
  pushl $251
c0103194:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103199:	e9 9e f5 ff ff       	jmp    c010273c <__alltraps>

c010319e <vector252>:
.globl vector252
vector252:
  pushl $0
c010319e:	6a 00                	push   $0x0
  pushl $252
c01031a0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031a5:	e9 92 f5 ff ff       	jmp    c010273c <__alltraps>

c01031aa <vector253>:
.globl vector253
vector253:
  pushl $0
c01031aa:	6a 00                	push   $0x0
  pushl $253
c01031ac:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031b1:	e9 86 f5 ff ff       	jmp    c010273c <__alltraps>

c01031b6 <vector254>:
.globl vector254
vector254:
  pushl $0
c01031b6:	6a 00                	push   $0x0
  pushl $254
c01031b8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031bd:	e9 7a f5 ff ff       	jmp    c010273c <__alltraps>

c01031c2 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031c2:	6a 00                	push   $0x0
  pushl $255
c01031c4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031c9:	e9 6e f5 ff ff       	jmp    c010273c <__alltraps>

c01031ce <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01031ce:	55                   	push   %ebp
c01031cf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01031d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01031d4:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01031d9:	29 c2                	sub    %eax,%edx
c01031db:	89 d0                	mov    %edx,%eax
c01031dd:	c1 f8 05             	sar    $0x5,%eax
}
c01031e0:	5d                   	pop    %ebp
c01031e1:	c3                   	ret    

c01031e2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01031e2:	55                   	push   %ebp
c01031e3:	89 e5                	mov    %esp,%ebp
c01031e5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01031e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01031eb:	89 04 24             	mov    %eax,(%esp)
c01031ee:	e8 db ff ff ff       	call   c01031ce <page2ppn>
c01031f3:	c1 e0 0c             	shl    $0xc,%eax
}
c01031f6:	c9                   	leave  
c01031f7:	c3                   	ret    

c01031f8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01031f8:	55                   	push   %ebp
c01031f9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01031fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fe:	8b 00                	mov    (%eax),%eax
}
c0103200:	5d                   	pop    %ebp
c0103201:	c3                   	ret    

c0103202 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103202:	55                   	push   %ebp
c0103203:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103205:	8b 45 08             	mov    0x8(%ebp),%eax
c0103208:	8b 55 0c             	mov    0xc(%ebp),%edx
c010320b:	89 10                	mov    %edx,(%eax)
}
c010320d:	5d                   	pop    %ebp
c010320e:	c3                   	ret    

c010320f <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010320f:	55                   	push   %ebp
c0103210:	89 e5                	mov    %esp,%ebp
c0103212:	83 ec 10             	sub    $0x10,%esp
c0103215:	c7 45 fc c0 0a 12 c0 	movl   $0xc0120ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010321c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103222:	89 50 04             	mov    %edx,0x4(%eax)
c0103225:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103228:	8b 50 04             	mov    0x4(%eax),%edx
c010322b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010322e:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103230:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103237:	00 00 00 
}
c010323a:	c9                   	leave  
c010323b:	c3                   	ret    

c010323c <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010323c:	55                   	push   %ebp
c010323d:	89 e5                	mov    %esp,%ebp
c010323f:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103242:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103246:	75 24                	jne    c010326c <default_init_memmap+0x30>
c0103248:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c010324f:	c0 
c0103250:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103257:	c0 
c0103258:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010325f:	00 
c0103260:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103267:	e8 68 da ff ff       	call   c0100cd4 <__panic>
    struct Page* p = base;
c010326c:	8b 45 08             	mov    0x8(%ebp),%eax
c010326f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(; p != base + n; p ++)
c0103272:	e9 d2 00 00 00       	jmp    c0103349 <default_init_memmap+0x10d>
    {
	assert(PageReserved(p));
c0103277:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010327a:	83 c0 04             	add    $0x4,%eax
c010327d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103284:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103287:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010328a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010328d:	0f a3 10             	bt     %edx,(%eax)
c0103290:	19 c0                	sbb    %eax,%eax
c0103292:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103299:	0f 95 c0             	setne  %al
c010329c:	0f b6 c0             	movzbl %al,%eax
c010329f:	85 c0                	test   %eax,%eax
c01032a1:	75 24                	jne    c01032c7 <default_init_memmap+0x8b>
c01032a3:	c7 44 24 0c 61 93 10 	movl   $0xc0109361,0xc(%esp)
c01032aa:	c0 
c01032ab:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01032b2:	c0 
c01032b3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c01032ba:	00 
c01032bb:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01032c2:	e8 0d da ff ff       	call   c0100cd4 <__panic>
	SetPageProperty(p);
c01032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032ca:	83 c0 04             	add    $0x4,%eax
c01032cd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01032d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01032d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032dd:	0f ab 10             	bts    %edx,(%eax)
	p->property = 0;
c01032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	set_page_ref(p, 0);
c01032ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032f1:	00 
c01032f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f5:	89 04 24             	mov    %eax,(%esp)
c01032f8:	e8 05 ff ff ff       	call   c0103202 <set_page_ref>
	list_add_before(&free_list, &(p->page_link));
c01032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103300:	83 c0 0c             	add    $0xc,%eax
c0103303:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
c010330a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010330d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103310:	8b 00                	mov    (%eax),%eax
c0103312:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103315:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103318:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010331b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010331e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103321:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103324:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103327:	89 10                	mov    %edx,(%eax)
c0103329:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010332c:	8b 10                	mov    (%eax),%edx
c010332e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103331:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103334:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103337:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010333a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010333d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103340:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103343:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page* p = base;
    for(; p != base + n; p ++)
c0103345:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103349:	8b 45 0c             	mov    0xc(%ebp),%eax
c010334c:	c1 e0 05             	shl    $0x5,%eax
c010334f:	89 c2                	mov    %eax,%edx
c0103351:	8b 45 08             	mov    0x8(%ebp),%eax
c0103354:	01 d0                	add    %edx,%eax
c0103356:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103359:	0f 85 18 ff ff ff    	jne    c0103277 <default_init_memmap+0x3b>
	SetPageProperty(p);
	p->property = 0;
	set_page_ref(p, 0);
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c010335f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103362:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103365:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free+=n;
c0103368:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c010336e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103371:	01 d0                	add    %edx,%eax
c0103373:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
}
c0103378:	c9                   	leave  
c0103379:	c3                   	ret    

c010337a <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010337a:	55                   	push   %ebp
c010337b:	89 e5                	mov    %esp,%ebp
c010337d:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103380:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103384:	75 24                	jne    c01033aa <default_alloc_pages+0x30>
c0103386:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c010338d:	c0 
c010338e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103395:	c0 
c0103396:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c010339d:	00 
c010339e:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01033a5:	e8 2a d9 ff ff       	call   c0100cd4 <__panic>
    if(n > nr_free){
c01033aa:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01033af:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033b2:	73 0a                	jae    c01033be <default_alloc_pages+0x44>
	return NULL;
c01033b4:	b8 00 00 00 00       	mov    $0x0,%eax
c01033b9:	e9 45 01 00 00       	jmp    c0103503 <default_alloc_pages+0x189>
    }
    struct Page *page = NULL;
c01033be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01033c5:	c7 45 f0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033cc:	eb 1c                	jmp    c01033ea <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033d1:	83 e8 0c             	sub    $0xc,%eax
c01033d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c01033d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033da:	8b 40 08             	mov    0x8(%eax),%eax
c01033dd:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033e0:	72 08                	jb     c01033ea <default_alloc_pages+0x70>
            page = p;
c01033e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01033e8:	eb 18                	jmp    c0103402 <default_alloc_pages+0x88>
c01033ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033f3:	8b 40 04             	mov    0x4(%eax),%eax
    if(n > nr_free){
	return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033f9:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c0103400:	75 cc                	jne    c01033ce <default_alloc_pages+0x54>
            page = p;
            break;
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
c0103402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103406:	0f 84 f2 00 00 00    	je     c01034fe <default_alloc_pages+0x184>
	int i = n;
c010340c:	8b 45 08             	mov    0x8(%ebp),%eax
c010340f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	while(i--)
c0103412:	eb 78                	jmp    c010348c <default_alloc_pages+0x112>
c0103414:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103417:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010341a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010341d:	8b 40 04             	mov    0x4(%eax),%eax
	{
	    tle = list_next(le);
c0103420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    struct Page *tp = le2page(le, page_link);
c0103423:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103426:	83 e8 0c             	sub    $0xc,%eax
c0103429:	89 45 e0             	mov    %eax,-0x20(%ebp)
	    SetPageReserved(tp);
c010342c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010342f:	83 c0 04             	add    $0x4,%eax
c0103432:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0103439:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010343c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010343f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103442:	0f ab 10             	bts    %edx,(%eax)
	    ClearPageProperty(tp);
c0103445:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103448:	83 c0 04             	add    $0x4,%eax
c010344b:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0103452:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103455:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103458:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010345b:	0f b3 10             	btr    %edx,(%eax)
c010345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103461:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103464:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103467:	8b 40 04             	mov    0x4(%eax),%eax
c010346a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010346d:	8b 12                	mov    (%edx),%edx
c010346f:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0103472:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103475:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103478:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010347b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010347e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103481:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103484:	89 10                	mov    %edx,(%eax)
	    list_del(le);
	    le = tle;
c0103486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103489:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
    }
    list_entry_t *tle;
    if (page != NULL) {
	int i = n;
	while(i--)
c010348c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010348f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103492:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0103495:	85 c0                	test   %eax,%eax
c0103497:	0f 85 77 ff ff ff    	jne    c0103414 <default_alloc_pages+0x9a>
	    SetPageReserved(tp);
	    ClearPageProperty(tp);
	    list_del(le);
	    le = tle;
	}
	if(page->property > n)
c010349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034a0:	8b 40 08             	mov    0x8(%eax),%eax
c01034a3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034a6:	76 12                	jbe    c01034ba <default_alloc_pages+0x140>
	{
	    (le2page(le,page_link))->property = page->property - n;
c01034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034ab:	8d 50 f4             	lea    -0xc(%eax),%edx
c01034ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b1:	8b 40 08             	mov    0x8(%eax),%eax
c01034b4:	2b 45 08             	sub    0x8(%ebp),%eax
c01034b7:	89 42 08             	mov    %eax,0x8(%edx)
	}
	ClearPageProperty(page);
c01034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034bd:	83 c0 04             	add    $0x4,%eax
c01034c0:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01034c7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01034ca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034cd:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034d0:	0f b3 10             	btr    %edx,(%eax)
	SetPageReserved(page);
c01034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d6:	83 c0 04             	add    $0x4,%eax
c01034d9:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
c01034e0:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01034e6:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01034e9:	0f ab 10             	bts    %edx,(%eax)
	nr_free -= n;
c01034ec:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01034f1:	2b 45 08             	sub    0x8(%ebp),%eax
c01034f4:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
	return page;
c01034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034fc:	eb 05                	jmp    c0103503 <default_alloc_pages+0x189>
    }
    return NULL;
c01034fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103503:	c9                   	leave  
c0103504:	c3                   	ret    

c0103505 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103505:	55                   	push   %ebp
c0103506:	89 e5                	mov    %esp,%ebp
c0103508:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c010350b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010350f:	75 24                	jne    c0103535 <default_free_pages+0x30>
c0103511:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c0103518:	c0 
c0103519:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103520:	c0 
c0103521:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0103528:	00 
c0103529:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103530:	e8 9f d7 ff ff       	call   c0100cd4 <__panic>
    struct Page *p = base;
c0103535:	8b 45 08             	mov    0x8(%ebp),%eax
c0103538:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010353b:	c7 45 f0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x10(%ebp)
    while((le = list_next(le)) != &free_list)
c0103542:	eb 13                	jmp    c0103557 <default_free_pages+0x52>
    {
	p = le2page(le, page_link);
c0103544:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103547:	83 e8 0c             	sub    $0xc,%eax
c010354a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(p > base) 
c010354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103550:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103553:	76 02                	jbe    c0103557 <default_free_pages+0x52>
	    break;
c0103555:	eb 18                	jmp    c010356f <default_free_pages+0x6a>
c0103557:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010355a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010355d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103560:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list)
c0103563:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103566:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c010356d:	75 d5                	jne    c0103544 <default_free_pages+0x3f>
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c010356f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103572:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103575:	eb 4b                	jmp    c01035c2 <default_free_pages+0xbd>
	list_add_before(le, &(p->page_link));
c0103577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357a:	8d 50 0c             	lea    0xc(%eax),%edx
c010357d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103580:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103583:	89 55 e4             	mov    %edx,-0x1c(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103586:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103589:	8b 00                	mov    (%eax),%eax
c010358b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010358e:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0103591:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103594:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103597:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010359a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010359d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01035a0:	89 10                	mov    %edx,(%eax)
c01035a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035a5:	8b 10                	mov    (%eax),%edx
c01035a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035aa:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035b3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01035b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01035bc:	89 10                	mov    %edx,(%eax)
    {
	p = le2page(le, page_link);
	if(p > base) 
	    break;
    }
    for(p=base;p<base+n;p++){
c01035be:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01035c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035c5:	c1 e0 05             	shl    $0x5,%eax
c01035c8:	89 c2                	mov    %eax,%edx
c01035ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01035cd:	01 d0                	add    %edx,%eax
c01035cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01035d2:	77 a3                	ja     c0103577 <default_free_pages+0x72>
	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c01035d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c01035de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01035e5:	00 
c01035e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e9:	89 04 24             	mov    %eax,(%esp)
c01035ec:	e8 11 fc ff ff       	call   c0103202 <set_page_ref>
    SetPageProperty(base);
c01035f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f4:	83 c0 04             	add    $0x4,%eax
c01035f7:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01035fe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103601:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103604:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103607:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c010360a:	8b 45 08             	mov    0x8(%ebp),%eax
c010360d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103610:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0103613:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c0103619:	8b 45 0c             	mov    0xc(%ebp),%eax
c010361c:	01 d0                	add    %edx,%eax
c010361e:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    p = le2page(le,page_link) ;
c0103623:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103626:	83 e8 0c             	sub    $0xc,%eax
c0103629:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if( base + n == p ){
c010362c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010362f:	c1 e0 05             	shl    $0x5,%eax
c0103632:	89 c2                	mov    %eax,%edx
c0103634:	8b 45 08             	mov    0x8(%ebp),%eax
c0103637:	01 d0                	add    %edx,%eax
c0103639:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010363c:	75 1e                	jne    c010365c <default_free_pages+0x157>
	base->property += p->property;
c010363e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103641:	8b 50 08             	mov    0x8(%eax),%edx
c0103644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103647:	8b 40 08             	mov    0x8(%eax),%eax
c010364a:	01 c2                	add    %eax,%edx
c010364c:	8b 45 08             	mov    0x8(%ebp),%eax
c010364f:	89 50 08             	mov    %edx,0x8(%eax)
	p->property = 0;
c0103652:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103655:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le =  list_prev(&(base->page_link));
c010365c:	8b 45 08             	mov    0x8(%ebp),%eax
c010365f:	83 c0 0c             	add    $0xc,%eax
c0103662:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103665:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103668:	8b 00                	mov    (%eax),%eax
c010366a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(le,page_link);
c010366d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103670:	83 e8 0c             	sub    $0xc,%eax
c0103673:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(le!=&free_list && p == base - 1)
c0103676:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c010367d:	74 52                	je     c01036d1 <default_free_pages+0x1cc>
c010367f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103682:	83 e8 20             	sub    $0x20,%eax
c0103685:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103688:	75 47                	jne    c01036d1 <default_free_pages+0x1cc>
    {
	while(le != &free_list)
c010368a:	eb 3c                	jmp    c01036c8 <default_free_pages+0x1c3>
	{
	    if(p -> property > 0)
c010368c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010368f:	8b 40 08             	mov    0x8(%eax),%eax
c0103692:	85 c0                	test   %eax,%eax
c0103694:	74 20                	je     c01036b6 <default_free_pages+0x1b1>
	    {
		p->property += base->property;
c0103696:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103699:	8b 50 08             	mov    0x8(%eax),%edx
c010369c:	8b 45 08             	mov    0x8(%ebp),%eax
c010369f:	8b 40 08             	mov    0x8(%eax),%eax
c01036a2:	01 c2                	add    %eax,%edx
c01036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a7:	89 50 08             	mov    %edx,0x8(%eax)
		base->property = 0;
c01036aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		break;
c01036b4:	eb 1b                	jmp    c01036d1 <default_free_pages+0x1cc>
c01036b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01036bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01036bf:	8b 00                	mov    (%eax),%eax
	    }
	    le = list_prev(le);
c01036c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	    p--;
c01036c4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
    }
    le =  list_prev(&(base->page_link));
    p = le2page(le,page_link);
    if(le!=&free_list && p == base - 1)
    {
	while(le != &free_list)
c01036c8:	81 7d f0 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x10(%ebp)
c01036cf:	75 bb                	jne    c010368c <default_free_pages+0x187>
	    }
	    le = list_prev(le);
	    p--;
    	}
    }
}
c01036d1:	c9                   	leave  
c01036d2:	c3                   	ret    

c01036d3 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01036d3:	55                   	push   %ebp
c01036d4:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01036d6:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
}
c01036db:	5d                   	pop    %ebp
c01036dc:	c3                   	ret    

c01036dd <basic_check>:

static void
basic_check(void) {
c01036dd:	55                   	push   %ebp
c01036de:	89 e5                	mov    %esp,%ebp
c01036e0:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01036e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01036f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036fd:	e8 bf 0e 00 00       	call   c01045c1 <alloc_pages>
c0103702:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103705:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103709:	75 24                	jne    c010372f <basic_check+0x52>
c010370b:	c7 44 24 0c 71 93 10 	movl   $0xc0109371,0xc(%esp)
c0103712:	c0 
c0103713:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010371a:	c0 
c010371b:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103722:	00 
c0103723:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010372a:	e8 a5 d5 ff ff       	call   c0100cd4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010372f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103736:	e8 86 0e 00 00       	call   c01045c1 <alloc_pages>
c010373b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010373e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103742:	75 24                	jne    c0103768 <basic_check+0x8b>
c0103744:	c7 44 24 0c 8d 93 10 	movl   $0xc010938d,0xc(%esp)
c010374b:	c0 
c010374c:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103753:	c0 
c0103754:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c010375b:	00 
c010375c:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103763:	e8 6c d5 ff ff       	call   c0100cd4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103768:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010376f:	e8 4d 0e 00 00       	call   c01045c1 <alloc_pages>
c0103774:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010377b:	75 24                	jne    c01037a1 <basic_check+0xc4>
c010377d:	c7 44 24 0c a9 93 10 	movl   $0xc01093a9,0xc(%esp)
c0103784:	c0 
c0103785:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010378c:	c0 
c010378d:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0103794:	00 
c0103795:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010379c:	e8 33 d5 ff ff       	call   c0100cd4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01037a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037a7:	74 10                	je     c01037b9 <basic_check+0xdc>
c01037a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037af:	74 08                	je     c01037b9 <basic_check+0xdc>
c01037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01037b7:	75 24                	jne    c01037dd <basic_check+0x100>
c01037b9:	c7 44 24 0c c8 93 10 	movl   $0xc01093c8,0xc(%esp)
c01037c0:	c0 
c01037c1:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01037c8:	c0 
c01037c9:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01037d0:	00 
c01037d1:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01037d8:	e8 f7 d4 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01037dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037e0:	89 04 24             	mov    %eax,(%esp)
c01037e3:	e8 10 fa ff ff       	call   c01031f8 <page_ref>
c01037e8:	85 c0                	test   %eax,%eax
c01037ea:	75 1e                	jne    c010380a <basic_check+0x12d>
c01037ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037ef:	89 04 24             	mov    %eax,(%esp)
c01037f2:	e8 01 fa ff ff       	call   c01031f8 <page_ref>
c01037f7:	85 c0                	test   %eax,%eax
c01037f9:	75 0f                	jne    c010380a <basic_check+0x12d>
c01037fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037fe:	89 04 24             	mov    %eax,(%esp)
c0103801:	e8 f2 f9 ff ff       	call   c01031f8 <page_ref>
c0103806:	85 c0                	test   %eax,%eax
c0103808:	74 24                	je     c010382e <basic_check+0x151>
c010380a:	c7 44 24 0c ec 93 10 	movl   $0xc01093ec,0xc(%esp)
c0103811:	c0 
c0103812:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103819:	c0 
c010381a:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103821:	00 
c0103822:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103829:	e8 a6 d4 ff ff       	call   c0100cd4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010382e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103831:	89 04 24             	mov    %eax,(%esp)
c0103834:	e8 a9 f9 ff ff       	call   c01031e2 <page2pa>
c0103839:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010383f:	c1 e2 0c             	shl    $0xc,%edx
c0103842:	39 d0                	cmp    %edx,%eax
c0103844:	72 24                	jb     c010386a <basic_check+0x18d>
c0103846:	c7 44 24 0c 28 94 10 	movl   $0xc0109428,0xc(%esp)
c010384d:	c0 
c010384e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103855:	c0 
c0103856:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010385d:	00 
c010385e:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103865:	e8 6a d4 ff ff       	call   c0100cd4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010386a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010386d:	89 04 24             	mov    %eax,(%esp)
c0103870:	e8 6d f9 ff ff       	call   c01031e2 <page2pa>
c0103875:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010387b:	c1 e2 0c             	shl    $0xc,%edx
c010387e:	39 d0                	cmp    %edx,%eax
c0103880:	72 24                	jb     c01038a6 <basic_check+0x1c9>
c0103882:	c7 44 24 0c 45 94 10 	movl   $0xc0109445,0xc(%esp)
c0103889:	c0 
c010388a:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103891:	c0 
c0103892:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103899:	00 
c010389a:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01038a1:	e8 2e d4 ff ff       	call   c0100cd4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01038a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038a9:	89 04 24             	mov    %eax,(%esp)
c01038ac:	e8 31 f9 ff ff       	call   c01031e2 <page2pa>
c01038b1:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c01038b7:	c1 e2 0c             	shl    $0xc,%edx
c01038ba:	39 d0                	cmp    %edx,%eax
c01038bc:	72 24                	jb     c01038e2 <basic_check+0x205>
c01038be:	c7 44 24 0c 62 94 10 	movl   $0xc0109462,0xc(%esp)
c01038c5:	c0 
c01038c6:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01038cd:	c0 
c01038ce:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01038d5:	00 
c01038d6:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01038dd:	e8 f2 d3 ff ff       	call   c0100cd4 <__panic>

    list_entry_t free_list_store = free_list;
c01038e2:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c01038e7:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c01038ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01038f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01038f3:	c7 45 e0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01038fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103900:	89 50 04             	mov    %edx,0x4(%eax)
c0103903:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103906:	8b 50 04             	mov    0x4(%eax),%edx
c0103909:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010390c:	89 10                	mov    %edx,(%eax)
c010390e:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103915:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103918:	8b 40 04             	mov    0x4(%eax),%eax
c010391b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010391e:	0f 94 c0             	sete   %al
c0103921:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103924:	85 c0                	test   %eax,%eax
c0103926:	75 24                	jne    c010394c <basic_check+0x26f>
c0103928:	c7 44 24 0c 7f 94 10 	movl   $0xc010947f,0xc(%esp)
c010392f:	c0 
c0103930:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103937:	c0 
c0103938:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c010393f:	00 
c0103940:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103947:	e8 88 d3 ff ff       	call   c0100cd4 <__panic>

    unsigned int nr_free_store = nr_free;
c010394c:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103951:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103954:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c010395b:	00 00 00 

    assert(alloc_page() == NULL);
c010395e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103965:	e8 57 0c 00 00       	call   c01045c1 <alloc_pages>
c010396a:	85 c0                	test   %eax,%eax
c010396c:	74 24                	je     c0103992 <basic_check+0x2b5>
c010396e:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0103975:	c0 
c0103976:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010397d:	c0 
c010397e:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103985:	00 
c0103986:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010398d:	e8 42 d3 ff ff       	call   c0100cd4 <__panic>

    free_page(p0);
c0103992:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103999:	00 
c010399a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010399d:	89 04 24             	mov    %eax,(%esp)
c01039a0:	e8 87 0c 00 00       	call   c010462c <free_pages>
    free_page(p1);
c01039a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039ac:	00 
c01039ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b0:	89 04 24             	mov    %eax,(%esp)
c01039b3:	e8 74 0c 00 00       	call   c010462c <free_pages>
    free_page(p2);
c01039b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039bf:	00 
c01039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c3:	89 04 24             	mov    %eax,(%esp)
c01039c6:	e8 61 0c 00 00       	call   c010462c <free_pages>
    assert(nr_free == 3);
c01039cb:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01039d0:	83 f8 03             	cmp    $0x3,%eax
c01039d3:	74 24                	je     c01039f9 <basic_check+0x31c>
c01039d5:	c7 44 24 0c ab 94 10 	movl   $0xc01094ab,0xc(%esp)
c01039dc:	c0 
c01039dd:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01039e4:	c0 
c01039e5:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01039ec:	00 
c01039ed:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01039f4:	e8 db d2 ff ff       	call   c0100cd4 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01039f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a00:	e8 bc 0b 00 00       	call   c01045c1 <alloc_pages>
c0103a05:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a0c:	75 24                	jne    c0103a32 <basic_check+0x355>
c0103a0e:	c7 44 24 0c 71 93 10 	movl   $0xc0109371,0xc(%esp)
c0103a15:	c0 
c0103a16:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103a1d:	c0 
c0103a1e:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103a25:	00 
c0103a26:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103a2d:	e8 a2 d2 ff ff       	call   c0100cd4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a39:	e8 83 0b 00 00       	call   c01045c1 <alloc_pages>
c0103a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a45:	75 24                	jne    c0103a6b <basic_check+0x38e>
c0103a47:	c7 44 24 0c 8d 93 10 	movl   $0xc010938d,0xc(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103a5e:	00 
c0103a5f:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103a66:	e8 69 d2 ff ff       	call   c0100cd4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103a6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a72:	e8 4a 0b 00 00       	call   c01045c1 <alloc_pages>
c0103a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a7e:	75 24                	jne    c0103aa4 <basic_check+0x3c7>
c0103a80:	c7 44 24 0c a9 93 10 	movl   $0xc01093a9,0xc(%esp)
c0103a87:	c0 
c0103a88:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103a8f:	c0 
c0103a90:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103a97:	00 
c0103a98:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103a9f:	e8 30 d2 ff ff       	call   c0100cd4 <__panic>

    assert(alloc_page() == NULL);
c0103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aab:	e8 11 0b 00 00       	call   c01045c1 <alloc_pages>
c0103ab0:	85 c0                	test   %eax,%eax
c0103ab2:	74 24                	je     c0103ad8 <basic_check+0x3fb>
c0103ab4:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0103abb:	c0 
c0103abc:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103ac3:	c0 
c0103ac4:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103acb:	00 
c0103acc:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103ad3:	e8 fc d1 ff ff       	call   c0100cd4 <__panic>

    free_page(p0);
c0103ad8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103adf:	00 
c0103ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ae3:	89 04 24             	mov    %eax,(%esp)
c0103ae6:	e8 41 0b 00 00       	call   c010462c <free_pages>
c0103aeb:	c7 45 d8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x28(%ebp)
c0103af2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103af5:	8b 40 04             	mov    0x4(%eax),%eax
c0103af8:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103afb:	0f 94 c0             	sete   %al
c0103afe:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b01:	85 c0                	test   %eax,%eax
c0103b03:	74 24                	je     c0103b29 <basic_check+0x44c>
c0103b05:	c7 44 24 0c b8 94 10 	movl   $0xc01094b8,0xc(%esp)
c0103b0c:	c0 
c0103b0d:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103b14:	c0 
c0103b15:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103b1c:	00 
c0103b1d:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103b24:	e8 ab d1 ff ff       	call   c0100cd4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103b29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b30:	e8 8c 0a 00 00       	call   c01045c1 <alloc_pages>
c0103b35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b3e:	74 24                	je     c0103b64 <basic_check+0x487>
c0103b40:	c7 44 24 0c d0 94 10 	movl   $0xc01094d0,0xc(%esp)
c0103b47:	c0 
c0103b48:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103b4f:	c0 
c0103b50:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103b57:	00 
c0103b58:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103b5f:	e8 70 d1 ff ff       	call   c0100cd4 <__panic>
    assert(alloc_page() == NULL);
c0103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b6b:	e8 51 0a 00 00       	call   c01045c1 <alloc_pages>
c0103b70:	85 c0                	test   %eax,%eax
c0103b72:	74 24                	je     c0103b98 <basic_check+0x4bb>
c0103b74:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0103b7b:	c0 
c0103b7c:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103b83:	c0 
c0103b84:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103b8b:	00 
c0103b8c:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103b93:	e8 3c d1 ff ff       	call   c0100cd4 <__panic>

    assert(nr_free == 0);
c0103b98:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103b9d:	85 c0                	test   %eax,%eax
c0103b9f:	74 24                	je     c0103bc5 <basic_check+0x4e8>
c0103ba1:	c7 44 24 0c e9 94 10 	movl   $0xc01094e9,0xc(%esp)
c0103ba8:	c0 
c0103ba9:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103bb0:	c0 
c0103bb1:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103bb8:	00 
c0103bb9:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103bc0:	e8 0f d1 ff ff       	call   c0100cd4 <__panic>
    free_list = free_list_store;
c0103bc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103bc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103bcb:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0103bd0:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    nr_free = nr_free_store;
c0103bd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103bd9:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_page(p);
c0103bde:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103be5:	00 
c0103be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103be9:	89 04 24             	mov    %eax,(%esp)
c0103bec:	e8 3b 0a 00 00       	call   c010462c <free_pages>
    free_page(p1);
c0103bf1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103bf8:	00 
c0103bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bfc:	89 04 24             	mov    %eax,(%esp)
c0103bff:	e8 28 0a 00 00       	call   c010462c <free_pages>
    free_page(p2);
c0103c04:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c0b:	00 
c0103c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c0f:	89 04 24             	mov    %eax,(%esp)
c0103c12:	e8 15 0a 00 00       	call   c010462c <free_pages>
}
c0103c17:	c9                   	leave  
c0103c18:	c3                   	ret    

c0103c19 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103c19:	55                   	push   %ebp
c0103c1a:	89 e5                	mov    %esp,%ebp
c0103c1c:	53                   	push   %ebx
c0103c1d:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103c31:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103c38:	eb 6b                	jmp    c0103ca5 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103c3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c3d:	83 e8 0c             	sub    $0xc,%eax
c0103c40:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103c43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c46:	83 c0 04             	add    $0x4,%eax
c0103c49:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103c50:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103c53:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103c56:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103c59:	0f a3 10             	bt     %edx,(%eax)
c0103c5c:	19 c0                	sbb    %eax,%eax
c0103c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103c61:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103c65:	0f 95 c0             	setne  %al
c0103c68:	0f b6 c0             	movzbl %al,%eax
c0103c6b:	85 c0                	test   %eax,%eax
c0103c6d:	75 24                	jne    c0103c93 <default_check+0x7a>
c0103c6f:	c7 44 24 0c f6 94 10 	movl   $0xc01094f6,0xc(%esp)
c0103c76:	c0 
c0103c77:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103c7e:	c0 
c0103c7f:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0103c86:	00 
c0103c87:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103c8e:	e8 41 d0 ff ff       	call   c0100cd4 <__panic>
        count ++, total += p->property;
c0103c93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103c97:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c9a:	8b 50 08             	mov    0x8(%eax),%edx
c0103c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ca0:	01 d0                	add    %edx,%eax
c0103ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103cab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103cae:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103cb4:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c0103cbb:	0f 85 79 ff ff ff    	jne    c0103c3a <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103cc1:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103cc4:	e8 95 09 00 00       	call   c010465e <nr_free_pages>
c0103cc9:	39 c3                	cmp    %eax,%ebx
c0103ccb:	74 24                	je     c0103cf1 <default_check+0xd8>
c0103ccd:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103cd4:	c0 
c0103cd5:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103cdc:	c0 
c0103cdd:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0103ce4:	00 
c0103ce5:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103cec:	e8 e3 cf ff ff       	call   c0100cd4 <__panic>

    basic_check();
c0103cf1:	e8 e7 f9 ff ff       	call   c01036dd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103cf6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103cfd:	e8 bf 08 00 00       	call   c01045c1 <alloc_pages>
c0103d02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103d05:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d09:	75 24                	jne    c0103d2f <default_check+0x116>
c0103d0b:	c7 44 24 0c 1f 95 10 	movl   $0xc010951f,0xc(%esp)
c0103d12:	c0 
c0103d13:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103d1a:	c0 
c0103d1b:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103d22:	00 
c0103d23:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103d2a:	e8 a5 cf ff ff       	call   c0100cd4 <__panic>
    assert(!PageProperty(p0));
c0103d2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d32:	83 c0 04             	add    $0x4,%eax
c0103d35:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103d3c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d3f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103d42:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103d45:	0f a3 10             	bt     %edx,(%eax)
c0103d48:	19 c0                	sbb    %eax,%eax
c0103d4a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103d4d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103d51:	0f 95 c0             	setne  %al
c0103d54:	0f b6 c0             	movzbl %al,%eax
c0103d57:	85 c0                	test   %eax,%eax
c0103d59:	74 24                	je     c0103d7f <default_check+0x166>
c0103d5b:	c7 44 24 0c 2a 95 10 	movl   $0xc010952a,0xc(%esp)
c0103d62:	c0 
c0103d63:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103d6a:	c0 
c0103d6b:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0103d72:	00 
c0103d73:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103d7a:	e8 55 cf ff ff       	call   c0100cd4 <__panic>

    list_entry_t free_list_store = free_list;
c0103d7f:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0103d84:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0103d8a:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103d8d:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103d90:	c7 45 b4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103d97:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103d9a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d9d:	89 50 04             	mov    %edx,0x4(%eax)
c0103da0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103da3:	8b 50 04             	mov    0x4(%eax),%edx
c0103da6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103da9:	89 10                	mov    %edx,(%eax)
c0103dab:	c7 45 b0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103db2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103db5:	8b 40 04             	mov    0x4(%eax),%eax
c0103db8:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103dbb:	0f 94 c0             	sete   %al
c0103dbe:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103dc1:	85 c0                	test   %eax,%eax
c0103dc3:	75 24                	jne    c0103de9 <default_check+0x1d0>
c0103dc5:	c7 44 24 0c 7f 94 10 	movl   $0xc010947f,0xc(%esp)
c0103dcc:	c0 
c0103dcd:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103dd4:	c0 
c0103dd5:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103ddc:	00 
c0103ddd:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103de4:	e8 eb ce ff ff       	call   c0100cd4 <__panic>
    assert(alloc_page() == NULL);
c0103de9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103df0:	e8 cc 07 00 00       	call   c01045c1 <alloc_pages>
c0103df5:	85 c0                	test   %eax,%eax
c0103df7:	74 24                	je     c0103e1d <default_check+0x204>
c0103df9:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0103e00:	c0 
c0103e01:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103e08:	c0 
c0103e09:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103e10:	00 
c0103e11:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103e18:	e8 b7 ce ff ff       	call   c0100cd4 <__panic>

    unsigned int nr_free_store = nr_free;
c0103e1d:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103e22:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103e25:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103e2c:	00 00 00 

    free_pages(p0 + 2, 3);
c0103e2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e32:	83 c0 40             	add    $0x40,%eax
c0103e35:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103e3c:	00 
c0103e3d:	89 04 24             	mov    %eax,(%esp)
c0103e40:	e8 e7 07 00 00       	call   c010462c <free_pages>
    assert(alloc_pages(4) == NULL);
c0103e45:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103e4c:	e8 70 07 00 00       	call   c01045c1 <alloc_pages>
c0103e51:	85 c0                	test   %eax,%eax
c0103e53:	74 24                	je     c0103e79 <default_check+0x260>
c0103e55:	c7 44 24 0c 3c 95 10 	movl   $0xc010953c,0xc(%esp)
c0103e5c:	c0 
c0103e5d:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103e64:	c0 
c0103e65:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103e6c:	00 
c0103e6d:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103e74:	e8 5b ce ff ff       	call   c0100cd4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e7c:	83 c0 40             	add    $0x40,%eax
c0103e7f:	83 c0 04             	add    $0x4,%eax
c0103e82:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103e89:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e8c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103e8f:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103e92:	0f a3 10             	bt     %edx,(%eax)
c0103e95:	19 c0                	sbb    %eax,%eax
c0103e97:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103e9a:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103e9e:	0f 95 c0             	setne  %al
c0103ea1:	0f b6 c0             	movzbl %al,%eax
c0103ea4:	85 c0                	test   %eax,%eax
c0103ea6:	74 0e                	je     c0103eb6 <default_check+0x29d>
c0103ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103eab:	83 c0 40             	add    $0x40,%eax
c0103eae:	8b 40 08             	mov    0x8(%eax),%eax
c0103eb1:	83 f8 03             	cmp    $0x3,%eax
c0103eb4:	74 24                	je     c0103eda <default_check+0x2c1>
c0103eb6:	c7 44 24 0c 54 95 10 	movl   $0xc0109554,0xc(%esp)
c0103ebd:	c0 
c0103ebe:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103ec5:	c0 
c0103ec6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103ecd:	00 
c0103ece:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103ed5:	e8 fa cd ff ff       	call   c0100cd4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103eda:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103ee1:	e8 db 06 00 00       	call   c01045c1 <alloc_pages>
c0103ee6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103ee9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103eed:	75 24                	jne    c0103f13 <default_check+0x2fa>
c0103eef:	c7 44 24 0c 80 95 10 	movl   $0xc0109580,0xc(%esp)
c0103ef6:	c0 
c0103ef7:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103efe:	c0 
c0103eff:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f06:	00 
c0103f07:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f0e:	e8 c1 cd ff ff       	call   c0100cd4 <__panic>
    assert(alloc_page() == NULL);
c0103f13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f1a:	e8 a2 06 00 00       	call   c01045c1 <alloc_pages>
c0103f1f:	85 c0                	test   %eax,%eax
c0103f21:	74 24                	je     c0103f47 <default_check+0x32e>
c0103f23:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0103f2a:	c0 
c0103f2b:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103f32:	c0 
c0103f33:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103f3a:	00 
c0103f3b:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f42:	e8 8d cd ff ff       	call   c0100cd4 <__panic>
    assert(p0 + 2 == p1);
c0103f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f4a:	83 c0 40             	add    $0x40,%eax
c0103f4d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f50:	74 24                	je     c0103f76 <default_check+0x35d>
c0103f52:	c7 44 24 0c 9e 95 10 	movl   $0xc010959e,0xc(%esp)
c0103f59:	c0 
c0103f5a:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103f61:	c0 
c0103f62:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0103f69:	00 
c0103f6a:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f71:	e8 5e cd ff ff       	call   c0100cd4 <__panic>

    p2 = p0 + 1;
c0103f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f79:	83 c0 20             	add    $0x20,%eax
c0103f7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103f7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f86:	00 
c0103f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f8a:	89 04 24             	mov    %eax,(%esp)
c0103f8d:	e8 9a 06 00 00       	call   c010462c <free_pages>
    free_pages(p1, 3);
c0103f92:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f99:	00 
c0103f9a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103f9d:	89 04 24             	mov    %eax,(%esp)
c0103fa0:	e8 87 06 00 00       	call   c010462c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fa8:	83 c0 04             	add    $0x4,%eax
c0103fab:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103fb2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fb5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103fb8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103fbb:	0f a3 10             	bt     %edx,(%eax)
c0103fbe:	19 c0                	sbb    %eax,%eax
c0103fc0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103fc3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103fc7:	0f 95 c0             	setne  %al
c0103fca:	0f b6 c0             	movzbl %al,%eax
c0103fcd:	85 c0                	test   %eax,%eax
c0103fcf:	74 0b                	je     c0103fdc <default_check+0x3c3>
c0103fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd4:	8b 40 08             	mov    0x8(%eax),%eax
c0103fd7:	83 f8 01             	cmp    $0x1,%eax
c0103fda:	74 24                	je     c0104000 <default_check+0x3e7>
c0103fdc:	c7 44 24 0c ac 95 10 	movl   $0xc01095ac,0xc(%esp)
c0103fe3:	c0 
c0103fe4:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103feb:	c0 
c0103fec:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103ff3:	00 
c0103ff4:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103ffb:	e8 d4 cc ff ff       	call   c0100cd4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104000:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104003:	83 c0 04             	add    $0x4,%eax
c0104006:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010400d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104010:	8b 45 90             	mov    -0x70(%ebp),%eax
c0104013:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0104016:	0f a3 10             	bt     %edx,(%eax)
c0104019:	19 c0                	sbb    %eax,%eax
c010401b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010401e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0104022:	0f 95 c0             	setne  %al
c0104025:	0f b6 c0             	movzbl %al,%eax
c0104028:	85 c0                	test   %eax,%eax
c010402a:	74 0b                	je     c0104037 <default_check+0x41e>
c010402c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010402f:	8b 40 08             	mov    0x8(%eax),%eax
c0104032:	83 f8 03             	cmp    $0x3,%eax
c0104035:	74 24                	je     c010405b <default_check+0x442>
c0104037:	c7 44 24 0c d4 95 10 	movl   $0xc01095d4,0xc(%esp)
c010403e:	c0 
c010403f:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104046:	c0 
c0104047:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010404e:	00 
c010404f:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104056:	e8 79 cc ff ff       	call   c0100cd4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010405b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104062:	e8 5a 05 00 00       	call   c01045c1 <alloc_pages>
c0104067:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010406a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010406d:	83 e8 20             	sub    $0x20,%eax
c0104070:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104073:	74 24                	je     c0104099 <default_check+0x480>
c0104075:	c7 44 24 0c fa 95 10 	movl   $0xc01095fa,0xc(%esp)
c010407c:	c0 
c010407d:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104084:	c0 
c0104085:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c010408c:	00 
c010408d:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104094:	e8 3b cc ff ff       	call   c0100cd4 <__panic>
    free_page(p0);
c0104099:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040a0:	00 
c01040a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040a4:	89 04 24             	mov    %eax,(%esp)
c01040a7:	e8 80 05 00 00       	call   c010462c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01040ac:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01040b3:	e8 09 05 00 00       	call   c01045c1 <alloc_pages>
c01040b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040be:	83 c0 20             	add    $0x20,%eax
c01040c1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040c4:	74 24                	je     c01040ea <default_check+0x4d1>
c01040c6:	c7 44 24 0c 18 96 10 	movl   $0xc0109618,0xc(%esp)
c01040cd:	c0 
c01040ce:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01040d5:	c0 
c01040d6:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01040dd:	00 
c01040de:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01040e5:	e8 ea cb ff ff       	call   c0100cd4 <__panic>

    free_pages(p0, 2);
c01040ea:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01040f1:	00 
c01040f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040f5:	89 04 24             	mov    %eax,(%esp)
c01040f8:	e8 2f 05 00 00       	call   c010462c <free_pages>
    free_page(p2);
c01040fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104104:	00 
c0104105:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104108:	89 04 24             	mov    %eax,(%esp)
c010410b:	e8 1c 05 00 00       	call   c010462c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104110:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104117:	e8 a5 04 00 00       	call   c01045c1 <alloc_pages>
c010411c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010411f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104123:	75 24                	jne    c0104149 <default_check+0x530>
c0104125:	c7 44 24 0c 38 96 10 	movl   $0xc0109638,0xc(%esp)
c010412c:	c0 
c010412d:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104134:	c0 
c0104135:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010413c:	00 
c010413d:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104144:	e8 8b cb ff ff       	call   c0100cd4 <__panic>
    assert(alloc_page() == NULL);
c0104149:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104150:	e8 6c 04 00 00       	call   c01045c1 <alloc_pages>
c0104155:	85 c0                	test   %eax,%eax
c0104157:	74 24                	je     c010417d <default_check+0x564>
c0104159:	c7 44 24 0c 96 94 10 	movl   $0xc0109496,0xc(%esp)
c0104160:	c0 
c0104161:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104168:	c0 
c0104169:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104170:	00 
c0104171:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104178:	e8 57 cb ff ff       	call   c0100cd4 <__panic>

    assert(nr_free == 0);
c010417d:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0104182:	85 c0                	test   %eax,%eax
c0104184:	74 24                	je     c01041aa <default_check+0x591>
c0104186:	c7 44 24 0c e9 94 10 	movl   $0xc01094e9,0xc(%esp)
c010418d:	c0 
c010418e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104195:	c0 
c0104196:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c010419d:	00 
c010419e:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01041a5:	e8 2a cb ff ff       	call   c0100cd4 <__panic>
    nr_free = nr_free_store;
c01041aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041ad:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_list = free_list_store;
c01041b2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01041b5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041b8:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c01041bd:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    free_pages(p0, 5);
c01041c3:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01041ca:	00 
c01041cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041ce:	89 04 24             	mov    %eax,(%esp)
c01041d1:	e8 56 04 00 00       	call   c010462c <free_pages>

    le = &free_list;
c01041d6:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01041dd:	eb 1d                	jmp    c01041fc <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01041df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041e2:	83 e8 0c             	sub    $0xc,%eax
c01041e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01041e8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01041ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041f2:	8b 40 08             	mov    0x8(%eax),%eax
c01041f5:	29 c2                	sub    %eax,%edx
c01041f7:	89 d0                	mov    %edx,%eax
c01041f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041ff:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104202:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104205:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104208:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010420b:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c0104212:	75 cb                	jne    c01041df <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0104214:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104218:	74 24                	je     c010423e <default_check+0x625>
c010421a:	c7 44 24 0c 56 96 10 	movl   $0xc0109656,0xc(%esp)
c0104221:	c0 
c0104222:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104229:	c0 
c010422a:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0104231:	00 
c0104232:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104239:	e8 96 ca ff ff       	call   c0100cd4 <__panic>
    assert(total == 0);
c010423e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104242:	74 24                	je     c0104268 <default_check+0x64f>
c0104244:	c7 44 24 0c 61 96 10 	movl   $0xc0109661,0xc(%esp)
c010424b:	c0 
c010424c:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104253:	c0 
c0104254:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c010425b:	00 
c010425c:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104263:	e8 6c ca ff ff       	call   c0100cd4 <__panic>
}
c0104268:	81 c4 94 00 00 00    	add    $0x94,%esp
c010426e:	5b                   	pop    %ebx
c010426f:	5d                   	pop    %ebp
c0104270:	c3                   	ret    

c0104271 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104271:	55                   	push   %ebp
c0104272:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104274:	8b 55 08             	mov    0x8(%ebp),%edx
c0104277:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010427c:	29 c2                	sub    %eax,%edx
c010427e:	89 d0                	mov    %edx,%eax
c0104280:	c1 f8 05             	sar    $0x5,%eax
}
c0104283:	5d                   	pop    %ebp
c0104284:	c3                   	ret    

c0104285 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104285:	55                   	push   %ebp
c0104286:	89 e5                	mov    %esp,%ebp
c0104288:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010428b:	8b 45 08             	mov    0x8(%ebp),%eax
c010428e:	89 04 24             	mov    %eax,(%esp)
c0104291:	e8 db ff ff ff       	call   c0104271 <page2ppn>
c0104296:	c1 e0 0c             	shl    $0xc,%eax
}
c0104299:	c9                   	leave  
c010429a:	c3                   	ret    

c010429b <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010429b:	55                   	push   %ebp
c010429c:	89 e5                	mov    %esp,%ebp
c010429e:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01042a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01042a4:	c1 e8 0c             	shr    $0xc,%eax
c01042a7:	89 c2                	mov    %eax,%edx
c01042a9:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01042ae:	39 c2                	cmp    %eax,%edx
c01042b0:	72 1c                	jb     c01042ce <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01042b2:	c7 44 24 08 9c 96 10 	movl   $0xc010969c,0x8(%esp)
c01042b9:	c0 
c01042ba:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01042c1:	00 
c01042c2:	c7 04 24 bb 96 10 c0 	movl   $0xc01096bb,(%esp)
c01042c9:	e8 06 ca ff ff       	call   c0100cd4 <__panic>
    }
    return &pages[PPN(pa)];
c01042ce:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01042d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01042d6:	c1 ea 0c             	shr    $0xc,%edx
c01042d9:	c1 e2 05             	shl    $0x5,%edx
c01042dc:	01 d0                	add    %edx,%eax
}
c01042de:	c9                   	leave  
c01042df:	c3                   	ret    

c01042e0 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01042e0:	55                   	push   %ebp
c01042e1:	89 e5                	mov    %esp,%ebp
c01042e3:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01042e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01042e9:	89 04 24             	mov    %eax,(%esp)
c01042ec:	e8 94 ff ff ff       	call   c0104285 <page2pa>
c01042f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f7:	c1 e8 0c             	shr    $0xc,%eax
c01042fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042fd:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104302:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104305:	72 23                	jb     c010432a <page2kva+0x4a>
c0104307:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010430a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010430e:	c7 44 24 08 cc 96 10 	movl   $0xc01096cc,0x8(%esp)
c0104315:	c0 
c0104316:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c010431d:	00 
c010431e:	c7 04 24 bb 96 10 c0 	movl   $0xc01096bb,(%esp)
c0104325:	e8 aa c9 ff ff       	call   c0100cd4 <__panic>
c010432a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010432d:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104332:	c9                   	leave  
c0104333:	c3                   	ret    

c0104334 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104334:	55                   	push   %ebp
c0104335:	89 e5                	mov    %esp,%ebp
c0104337:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010433a:	8b 45 08             	mov    0x8(%ebp),%eax
c010433d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104340:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104347:	77 23                	ja     c010436c <kva2page+0x38>
c0104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104350:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c0104357:	c0 
c0104358:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010435f:	00 
c0104360:	c7 04 24 bb 96 10 c0 	movl   $0xc01096bb,(%esp)
c0104367:	e8 68 c9 ff ff       	call   c0100cd4 <__panic>
c010436c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104374:	89 04 24             	mov    %eax,(%esp)
c0104377:	e8 1f ff ff ff       	call   c010429b <pa2page>
}
c010437c:	c9                   	leave  
c010437d:	c3                   	ret    

c010437e <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c010437e:	55                   	push   %ebp
c010437f:	89 e5                	mov    %esp,%ebp
c0104381:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104384:	8b 45 08             	mov    0x8(%ebp),%eax
c0104387:	83 e0 01             	and    $0x1,%eax
c010438a:	85 c0                	test   %eax,%eax
c010438c:	75 1c                	jne    c01043aa <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010438e:	c7 44 24 08 14 97 10 	movl   $0xc0109714,0x8(%esp)
c0104395:	c0 
c0104396:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010439d:	00 
c010439e:	c7 04 24 bb 96 10 c0 	movl   $0xc01096bb,(%esp)
c01043a5:	e8 2a c9 ff ff       	call   c0100cd4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01043aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01043b2:	89 04 24             	mov    %eax,(%esp)
c01043b5:	e8 e1 fe ff ff       	call   c010429b <pa2page>
}
c01043ba:	c9                   	leave  
c01043bb:	c3                   	ret    

c01043bc <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01043bc:	55                   	push   %ebp
c01043bd:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01043bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c2:	8b 00                	mov    (%eax),%eax
}
c01043c4:	5d                   	pop    %ebp
c01043c5:	c3                   	ret    

c01043c6 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01043c6:	55                   	push   %ebp
c01043c7:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01043c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043cc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043cf:	89 10                	mov    %edx,(%eax)
}
c01043d1:	5d                   	pop    %ebp
c01043d2:	c3                   	ret    

c01043d3 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01043d3:	55                   	push   %ebp
c01043d4:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01043d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d9:	8b 00                	mov    (%eax),%eax
c01043db:	8d 50 01             	lea    0x1(%eax),%edx
c01043de:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e1:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01043e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e6:	8b 00                	mov    (%eax),%eax
}
c01043e8:	5d                   	pop    %ebp
c01043e9:	c3                   	ret    

c01043ea <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01043ea:	55                   	push   %ebp
c01043eb:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01043ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f0:	8b 00                	mov    (%eax),%eax
c01043f2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01043f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01043fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01043fd:	8b 00                	mov    (%eax),%eax
}
c01043ff:	5d                   	pop    %ebp
c0104400:	c3                   	ret    

c0104401 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104401:	55                   	push   %ebp
c0104402:	89 e5                	mov    %esp,%ebp
c0104404:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104407:	9c                   	pushf  
c0104408:	58                   	pop    %eax
c0104409:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010440c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010440f:	25 00 02 00 00       	and    $0x200,%eax
c0104414:	85 c0                	test   %eax,%eax
c0104416:	74 0c                	je     c0104424 <__intr_save+0x23>
        intr_disable();
c0104418:	e8 0f db ff ff       	call   c0101f2c <intr_disable>
        return 1;
c010441d:	b8 01 00 00 00       	mov    $0x1,%eax
c0104422:	eb 05                	jmp    c0104429 <__intr_save+0x28>
    }
    return 0;
c0104424:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104429:	c9                   	leave  
c010442a:	c3                   	ret    

c010442b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010442b:	55                   	push   %ebp
c010442c:	89 e5                	mov    %esp,%ebp
c010442e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104431:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104435:	74 05                	je     c010443c <__intr_restore+0x11>
        intr_enable();
c0104437:	e8 ea da ff ff       	call   c0101f26 <intr_enable>
    }
}
c010443c:	c9                   	leave  
c010443d:	c3                   	ret    

c010443e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010443e:	55                   	push   %ebp
c010443f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104441:	8b 45 08             	mov    0x8(%ebp),%eax
c0104444:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104447:	b8 23 00 00 00       	mov    $0x23,%eax
c010444c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c010444e:	b8 23 00 00 00       	mov    $0x23,%eax
c0104453:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104455:	b8 10 00 00 00       	mov    $0x10,%eax
c010445a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c010445c:	b8 10 00 00 00       	mov    $0x10,%eax
c0104461:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104463:	b8 10 00 00 00       	mov    $0x10,%eax
c0104468:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c010446a:	ea 71 44 10 c0 08 00 	ljmp   $0x8,$0xc0104471
}
c0104471:	5d                   	pop    %ebp
c0104472:	c3                   	ret    

c0104473 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104473:	55                   	push   %ebp
c0104474:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104476:	8b 45 08             	mov    0x8(%ebp),%eax
c0104479:	a3 44 0a 12 c0       	mov    %eax,0xc0120a44
}
c010447e:	5d                   	pop    %ebp
c010447f:	c3                   	ret    

c0104480 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104480:	55                   	push   %ebp
c0104481:	89 e5                	mov    %esp,%ebp
c0104483:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104486:	b8 00 f0 11 c0       	mov    $0xc011f000,%eax
c010448b:	89 04 24             	mov    %eax,(%esp)
c010448e:	e8 e0 ff ff ff       	call   c0104473 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104493:	66 c7 05 48 0a 12 c0 	movw   $0x10,0xc0120a48
c010449a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010449c:	66 c7 05 28 fa 11 c0 	movw   $0x68,0xc011fa28
c01044a3:	68 00 
c01044a5:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c01044aa:	66 a3 2a fa 11 c0    	mov    %ax,0xc011fa2a
c01044b0:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c01044b5:	c1 e8 10             	shr    $0x10,%eax
c01044b8:	a2 2c fa 11 c0       	mov    %al,0xc011fa2c
c01044bd:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01044c4:	83 e0 f0             	and    $0xfffffff0,%eax
c01044c7:	83 c8 09             	or     $0x9,%eax
c01044ca:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01044cf:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01044d6:	83 e0 ef             	and    $0xffffffef,%eax
c01044d9:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01044de:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01044e5:	83 e0 9f             	and    $0xffffff9f,%eax
c01044e8:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01044ed:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c01044f4:	83 c8 80             	or     $0xffffff80,%eax
c01044f7:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c01044fc:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104503:	83 e0 f0             	and    $0xfffffff0,%eax
c0104506:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c010450b:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104512:	83 e0 ef             	and    $0xffffffef,%eax
c0104515:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c010451a:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104521:	83 e0 df             	and    $0xffffffdf,%eax
c0104524:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104529:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104530:	83 c8 40             	or     $0x40,%eax
c0104533:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104538:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c010453f:	83 e0 7f             	and    $0x7f,%eax
c0104542:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104547:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c010454c:	c1 e8 18             	shr    $0x18,%eax
c010454f:	a2 2f fa 11 c0       	mov    %al,0xc011fa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104554:	c7 04 24 30 fa 11 c0 	movl   $0xc011fa30,(%esp)
c010455b:	e8 de fe ff ff       	call   c010443e <lgdt>
c0104560:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104566:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c010456a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c010456d:	c9                   	leave  
c010456e:	c3                   	ret    

c010456f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010456f:	55                   	push   %ebp
c0104570:	89 e5                	mov    %esp,%ebp
c0104572:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104575:	c7 05 cc 0a 12 c0 80 	movl   $0xc0109680,0xc0120acc
c010457c:	96 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010457f:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104584:	8b 00                	mov    (%eax),%eax
c0104586:	89 44 24 04          	mov    %eax,0x4(%esp)
c010458a:	c7 04 24 40 97 10 c0 	movl   $0xc0109740,(%esp)
c0104591:	e8 b5 bd ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c0104596:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010459b:	8b 40 04             	mov    0x4(%eax),%eax
c010459e:	ff d0                	call   *%eax
}
c01045a0:	c9                   	leave  
c01045a1:	c3                   	ret    

c01045a2 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01045a2:	55                   	push   %ebp
c01045a3:	89 e5                	mov    %esp,%ebp
c01045a5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c01045a8:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01045ad:	8b 40 08             	mov    0x8(%eax),%eax
c01045b0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01045b7:	8b 55 08             	mov    0x8(%ebp),%edx
c01045ba:	89 14 24             	mov    %edx,(%esp)
c01045bd:	ff d0                	call   *%eax
}
c01045bf:	c9                   	leave  
c01045c0:	c3                   	ret    

c01045c1 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01045c1:	55                   	push   %ebp
c01045c2:	89 e5                	mov    %esp,%ebp
c01045c4:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01045c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01045ce:	e8 2e fe ff ff       	call   c0104401 <__intr_save>
c01045d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01045d6:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01045db:	8b 40 0c             	mov    0xc(%eax),%eax
c01045de:	8b 55 08             	mov    0x8(%ebp),%edx
c01045e1:	89 14 24             	mov    %edx,(%esp)
c01045e4:	ff d0                	call   *%eax
c01045e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01045e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045ec:	89 04 24             	mov    %eax,(%esp)
c01045ef:	e8 37 fe ff ff       	call   c010442b <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01045f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045f8:	75 2d                	jne    c0104627 <alloc_pages+0x66>
c01045fa:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01045fe:	77 27                	ja     c0104627 <alloc_pages+0x66>
c0104600:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0104605:	85 c0                	test   %eax,%eax
c0104607:	74 1e                	je     c0104627 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104609:	8b 55 08             	mov    0x8(%ebp),%edx
c010460c:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0104611:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104618:	00 
c0104619:	89 54 24 04          	mov    %edx,0x4(%esp)
c010461d:	89 04 24             	mov    %eax,(%esp)
c0104620:	e8 aa 1a 00 00       	call   c01060cf <swap_out>
    }
c0104625:	eb a7                	jmp    c01045ce <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010462a:	c9                   	leave  
c010462b:	c3                   	ret    

c010462c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c010462c:	55                   	push   %ebp
c010462d:	89 e5                	mov    %esp,%ebp
c010462f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104632:	e8 ca fd ff ff       	call   c0104401 <__intr_save>
c0104637:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c010463a:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010463f:	8b 40 10             	mov    0x10(%eax),%eax
c0104642:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104645:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104649:	8b 55 08             	mov    0x8(%ebp),%edx
c010464c:	89 14 24             	mov    %edx,(%esp)
c010464f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104654:	89 04 24             	mov    %eax,(%esp)
c0104657:	e8 cf fd ff ff       	call   c010442b <__intr_restore>
}
c010465c:	c9                   	leave  
c010465d:	c3                   	ret    

c010465e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c010465e:	55                   	push   %ebp
c010465f:	89 e5                	mov    %esp,%ebp
c0104661:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104664:	e8 98 fd ff ff       	call   c0104401 <__intr_save>
c0104669:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c010466c:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104671:	8b 40 14             	mov    0x14(%eax),%eax
c0104674:	ff d0                	call   *%eax
c0104676:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104679:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010467c:	89 04 24             	mov    %eax,(%esp)
c010467f:	e8 a7 fd ff ff       	call   c010442b <__intr_restore>
    return ret;
c0104684:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104687:	c9                   	leave  
c0104688:	c3                   	ret    

c0104689 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104689:	55                   	push   %ebp
c010468a:	89 e5                	mov    %esp,%ebp
c010468c:	57                   	push   %edi
c010468d:	56                   	push   %esi
c010468e:	53                   	push   %ebx
c010468f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104695:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010469c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01046a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c01046aa:	c7 04 24 57 97 10 c0 	movl   $0xc0109757,(%esp)
c01046b1:	e8 95 bc ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01046b6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01046bd:	e9 15 01 00 00       	jmp    c01047d7 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01046c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01046c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046c8:	89 d0                	mov    %edx,%eax
c01046ca:	c1 e0 02             	shl    $0x2,%eax
c01046cd:	01 d0                	add    %edx,%eax
c01046cf:	c1 e0 02             	shl    $0x2,%eax
c01046d2:	01 c8                	add    %ecx,%eax
c01046d4:	8b 50 08             	mov    0x8(%eax),%edx
c01046d7:	8b 40 04             	mov    0x4(%eax),%eax
c01046da:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01046dd:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01046e0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01046e3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01046e6:	89 d0                	mov    %edx,%eax
c01046e8:	c1 e0 02             	shl    $0x2,%eax
c01046eb:	01 d0                	add    %edx,%eax
c01046ed:	c1 e0 02             	shl    $0x2,%eax
c01046f0:	01 c8                	add    %ecx,%eax
c01046f2:	8b 48 0c             	mov    0xc(%eax),%ecx
c01046f5:	8b 58 10             	mov    0x10(%eax),%ebx
c01046f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01046fb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01046fe:	01 c8                	add    %ecx,%eax
c0104700:	11 da                	adc    %ebx,%edx
c0104702:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104705:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104708:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010470b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010470e:	89 d0                	mov    %edx,%eax
c0104710:	c1 e0 02             	shl    $0x2,%eax
c0104713:	01 d0                	add    %edx,%eax
c0104715:	c1 e0 02             	shl    $0x2,%eax
c0104718:	01 c8                	add    %ecx,%eax
c010471a:	83 c0 14             	add    $0x14,%eax
c010471d:	8b 00                	mov    (%eax),%eax
c010471f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104725:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104728:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010472b:	83 c0 ff             	add    $0xffffffff,%eax
c010472e:	83 d2 ff             	adc    $0xffffffff,%edx
c0104731:	89 c6                	mov    %eax,%esi
c0104733:	89 d7                	mov    %edx,%edi
c0104735:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104738:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010473b:	89 d0                	mov    %edx,%eax
c010473d:	c1 e0 02             	shl    $0x2,%eax
c0104740:	01 d0                	add    %edx,%eax
c0104742:	c1 e0 02             	shl    $0x2,%eax
c0104745:	01 c8                	add    %ecx,%eax
c0104747:	8b 48 0c             	mov    0xc(%eax),%ecx
c010474a:	8b 58 10             	mov    0x10(%eax),%ebx
c010474d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104753:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104757:	89 74 24 14          	mov    %esi,0x14(%esp)
c010475b:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010475f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104762:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104765:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104769:	89 54 24 10          	mov    %edx,0x10(%esp)
c010476d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104771:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104775:	c7 04 24 64 97 10 c0 	movl   $0xc0109764,(%esp)
c010477c:	e8 ca bb ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104781:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104784:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104787:	89 d0                	mov    %edx,%eax
c0104789:	c1 e0 02             	shl    $0x2,%eax
c010478c:	01 d0                	add    %edx,%eax
c010478e:	c1 e0 02             	shl    $0x2,%eax
c0104791:	01 c8                	add    %ecx,%eax
c0104793:	83 c0 14             	add    $0x14,%eax
c0104796:	8b 00                	mov    (%eax),%eax
c0104798:	83 f8 01             	cmp    $0x1,%eax
c010479b:	75 36                	jne    c01047d3 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010479d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047a3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01047a6:	77 2b                	ja     c01047d3 <page_init+0x14a>
c01047a8:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01047ab:	72 05                	jb     c01047b2 <page_init+0x129>
c01047ad:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01047b0:	73 21                	jae    c01047d3 <page_init+0x14a>
c01047b2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01047b6:	77 1b                	ja     c01047d3 <page_init+0x14a>
c01047b8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01047bc:	72 09                	jb     c01047c7 <page_init+0x13e>
c01047be:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01047c5:	77 0c                	ja     c01047d3 <page_init+0x14a>
                maxpa = end;
c01047c7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01047ca:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01047cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01047d0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01047d3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01047d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01047da:	8b 00                	mov    (%eax),%eax
c01047dc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01047df:	0f 8f dd fe ff ff    	jg     c01046c2 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01047e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01047e9:	72 1d                	jb     c0104808 <page_init+0x17f>
c01047eb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01047ef:	77 09                	ja     c01047fa <page_init+0x171>
c01047f1:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01047f8:	76 0e                	jbe    c0104808 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01047fa:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104801:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104808:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010480b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010480e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104812:	c1 ea 0c             	shr    $0xc,%edx
c0104815:	a3 20 0a 12 c0       	mov    %eax,0xc0120a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010481a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104821:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c0104826:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104829:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010482c:	01 d0                	add    %edx,%eax
c010482e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104831:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104834:	ba 00 00 00 00       	mov    $0x0,%edx
c0104839:	f7 75 ac             	divl   -0x54(%ebp)
c010483c:	89 d0                	mov    %edx,%eax
c010483e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104841:	29 c2                	sub    %eax,%edx
c0104843:	89 d0                	mov    %edx,%eax
c0104845:	a3 d4 0a 12 c0       	mov    %eax,0xc0120ad4

    for (i = 0; i < npage; i ++) {
c010484a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104851:	eb 27                	jmp    c010487a <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104853:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104858:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010485b:	c1 e2 05             	shl    $0x5,%edx
c010485e:	01 d0                	add    %edx,%eax
c0104860:	83 c0 04             	add    $0x4,%eax
c0104863:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010486a:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010486d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104870:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104873:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104876:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010487a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010487d:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104882:	39 c2                	cmp    %eax,%edx
c0104884:	72 cd                	jb     c0104853 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104886:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010488b:	c1 e0 05             	shl    $0x5,%eax
c010488e:	89 c2                	mov    %eax,%edx
c0104890:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0104895:	01 d0                	add    %edx,%eax
c0104897:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010489a:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01048a1:	77 23                	ja     c01048c6 <page_init+0x23d>
c01048a3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01048a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048aa:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c01048b1:	c0 
c01048b2:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01048b9:	00 
c01048ba:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01048c1:	e8 0e c4 ff ff       	call   c0100cd4 <__panic>
c01048c6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01048c9:	05 00 00 00 40       	add    $0x40000000,%eax
c01048ce:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01048d1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01048d8:	e9 74 01 00 00       	jmp    c0104a51 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01048dd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048e3:	89 d0                	mov    %edx,%eax
c01048e5:	c1 e0 02             	shl    $0x2,%eax
c01048e8:	01 d0                	add    %edx,%eax
c01048ea:	c1 e0 02             	shl    $0x2,%eax
c01048ed:	01 c8                	add    %ecx,%eax
c01048ef:	8b 50 08             	mov    0x8(%eax),%edx
c01048f2:	8b 40 04             	mov    0x4(%eax),%eax
c01048f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01048f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01048fb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048fe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104901:	89 d0                	mov    %edx,%eax
c0104903:	c1 e0 02             	shl    $0x2,%eax
c0104906:	01 d0                	add    %edx,%eax
c0104908:	c1 e0 02             	shl    $0x2,%eax
c010490b:	01 c8                	add    %ecx,%eax
c010490d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104910:	8b 58 10             	mov    0x10(%eax),%ebx
c0104913:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104916:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104919:	01 c8                	add    %ecx,%eax
c010491b:	11 da                	adc    %ebx,%edx
c010491d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104920:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104923:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104926:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104929:	89 d0                	mov    %edx,%eax
c010492b:	c1 e0 02             	shl    $0x2,%eax
c010492e:	01 d0                	add    %edx,%eax
c0104930:	c1 e0 02             	shl    $0x2,%eax
c0104933:	01 c8                	add    %ecx,%eax
c0104935:	83 c0 14             	add    $0x14,%eax
c0104938:	8b 00                	mov    (%eax),%eax
c010493a:	83 f8 01             	cmp    $0x1,%eax
c010493d:	0f 85 0a 01 00 00    	jne    c0104a4d <page_init+0x3c4>
            if (begin < freemem) {
c0104943:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104946:	ba 00 00 00 00       	mov    $0x0,%edx
c010494b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010494e:	72 17                	jb     c0104967 <page_init+0x2de>
c0104950:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104953:	77 05                	ja     c010495a <page_init+0x2d1>
c0104955:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104958:	76 0d                	jbe    c0104967 <page_init+0x2de>
                begin = freemem;
c010495a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010495d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104960:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104967:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010496b:	72 1d                	jb     c010498a <page_init+0x301>
c010496d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104971:	77 09                	ja     c010497c <page_init+0x2f3>
c0104973:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010497a:	76 0e                	jbe    c010498a <page_init+0x301>
                end = KMEMSIZE;
c010497c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104983:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010498a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010498d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104990:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104993:	0f 87 b4 00 00 00    	ja     c0104a4d <page_init+0x3c4>
c0104999:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010499c:	72 09                	jb     c01049a7 <page_init+0x31e>
c010499e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01049a1:	0f 83 a6 00 00 00    	jae    c0104a4d <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01049a7:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01049ae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01049b1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01049b4:	01 d0                	add    %edx,%eax
c01049b6:	83 e8 01             	sub    $0x1,%eax
c01049b9:	89 45 98             	mov    %eax,-0x68(%ebp)
c01049bc:	8b 45 98             	mov    -0x68(%ebp),%eax
c01049bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01049c4:	f7 75 9c             	divl   -0x64(%ebp)
c01049c7:	89 d0                	mov    %edx,%eax
c01049c9:	8b 55 98             	mov    -0x68(%ebp),%edx
c01049cc:	29 c2                	sub    %eax,%edx
c01049ce:	89 d0                	mov    %edx,%eax
c01049d0:	ba 00 00 00 00       	mov    $0x0,%edx
c01049d5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049d8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01049db:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01049de:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01049e1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01049e4:	ba 00 00 00 00       	mov    $0x0,%edx
c01049e9:	89 c7                	mov    %eax,%edi
c01049eb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01049f1:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01049f4:	89 d0                	mov    %edx,%eax
c01049f6:	83 e0 00             	and    $0x0,%eax
c01049f9:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01049fc:	8b 45 80             	mov    -0x80(%ebp),%eax
c01049ff:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a02:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a05:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104a08:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a0b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a0e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a11:	77 3a                	ja     c0104a4d <page_init+0x3c4>
c0104a13:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a16:	72 05                	jb     c0104a1d <page_init+0x394>
c0104a18:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104a1b:	73 30                	jae    c0104a4d <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104a1d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104a20:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104a23:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a26:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a29:	29 c8                	sub    %ecx,%eax
c0104a2b:	19 da                	sbb    %ebx,%edx
c0104a2d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104a31:	c1 ea 0c             	shr    $0xc,%edx
c0104a34:	89 c3                	mov    %eax,%ebx
c0104a36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a39:	89 04 24             	mov    %eax,(%esp)
c0104a3c:	e8 5a f8 ff ff       	call   c010429b <pa2page>
c0104a41:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104a45:	89 04 24             	mov    %eax,(%esp)
c0104a48:	e8 55 fb ff ff       	call   c01045a2 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104a4d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104a51:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104a54:	8b 00                	mov    (%eax),%eax
c0104a56:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104a59:	0f 8f 7e fe ff ff    	jg     c01048dd <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104a5f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104a65:	5b                   	pop    %ebx
c0104a66:	5e                   	pop    %esi
c0104a67:	5f                   	pop    %edi
c0104a68:	5d                   	pop    %ebp
c0104a69:	c3                   	ret    

c0104a6a <enable_paging>:

static void
enable_paging(void) {
c0104a6a:	55                   	push   %ebp
c0104a6b:	89 e5                	mov    %esp,%ebp
c0104a6d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104a70:	a1 d0 0a 12 c0       	mov    0xc0120ad0,%eax
c0104a75:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104a78:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104a7b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104a7e:	0f 20 c0             	mov    %cr0,%eax
c0104a81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104a84:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104a87:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104a8a:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104a91:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104a98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a9e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104aa1:	c9                   	leave  
c0104aa2:	c3                   	ret    

c0104aa3 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104aa3:	55                   	push   %ebp
c0104aa4:	89 e5                	mov    %esp,%ebp
c0104aa6:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104aa9:	8b 45 14             	mov    0x14(%ebp),%eax
c0104aac:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104aaf:	31 d0                	xor    %edx,%eax
c0104ab1:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104ab6:	85 c0                	test   %eax,%eax
c0104ab8:	74 24                	je     c0104ade <boot_map_segment+0x3b>
c0104aba:	c7 44 24 0c a2 97 10 	movl   $0xc01097a2,0xc(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0104ac9:	c0 
c0104aca:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104ad1:	00 
c0104ad2:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104ad9:	e8 f6 c1 ff ff       	call   c0100cd4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104ade:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ae8:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104aed:	89 c2                	mov    %eax,%edx
c0104aef:	8b 45 10             	mov    0x10(%ebp),%eax
c0104af2:	01 c2                	add    %eax,%edx
c0104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af7:	01 d0                	add    %edx,%eax
c0104af9:	83 e8 01             	sub    $0x1,%eax
c0104afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b02:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b07:	f7 75 f0             	divl   -0x10(%ebp)
c0104b0a:	89 d0                	mov    %edx,%eax
c0104b0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b0f:	29 c2                	sub    %eax,%edx
c0104b11:	89 d0                	mov    %edx,%eax
c0104b13:	c1 e8 0c             	shr    $0xc,%eax
c0104b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104b19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b22:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b27:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104b2a:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b38:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104b3b:	eb 6b                	jmp    c0104ba8 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104b3d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104b44:	00 
c0104b45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4f:	89 04 24             	mov    %eax,(%esp)
c0104b52:	e8 cc 01 00 00       	call   c0104d23 <get_pte>
c0104b57:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104b5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104b5e:	75 24                	jne    c0104b84 <boot_map_segment+0xe1>
c0104b60:	c7 44 24 0c ce 97 10 	movl   $0xc01097ce,0xc(%esp)
c0104b67:	c0 
c0104b68:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0104b6f:	c0 
c0104b70:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104b77:	00 
c0104b78:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104b7f:	e8 50 c1 ff ff       	call   c0100cd4 <__panic>
        *ptep = pa | PTE_P | perm;
c0104b84:	8b 45 18             	mov    0x18(%ebp),%eax
c0104b87:	8b 55 14             	mov    0x14(%ebp),%edx
c0104b8a:	09 d0                	or     %edx,%eax
c0104b8c:	83 c8 01             	or     $0x1,%eax
c0104b8f:	89 c2                	mov    %eax,%edx
c0104b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b94:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104b96:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104b9a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104ba1:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104ba8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bac:	75 8f                	jne    c0104b3d <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104bae:	c9                   	leave  
c0104baf:	c3                   	ret    

c0104bb0 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104bb0:	55                   	push   %ebp
c0104bb1:	89 e5                	mov    %esp,%ebp
c0104bb3:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104bb6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bbd:	e8 ff f9 ff ff       	call   c01045c1 <alloc_pages>
c0104bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104bc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bc9:	75 1c                	jne    c0104be7 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104bcb:	c7 44 24 08 db 97 10 	movl   $0xc01097db,0x8(%esp)
c0104bd2:	c0 
c0104bd3:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104bda:	00 
c0104bdb:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104be2:	e8 ed c0 ff ff       	call   c0100cd4 <__panic>
    }
    return page2kva(p);
c0104be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bea:	89 04 24             	mov    %eax,(%esp)
c0104bed:	e8 ee f6 ff ff       	call   c01042e0 <page2kva>
}
c0104bf2:	c9                   	leave  
c0104bf3:	c3                   	ret    

c0104bf4 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104bf4:	55                   	push   %ebp
c0104bf5:	89 e5                	mov    %esp,%ebp
c0104bf7:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104bfa:	e8 70 f9 ff ff       	call   c010456f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104bff:	e8 85 fa ff ff       	call   c0104689 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104c04:	e8 44 05 00 00       	call   c010514d <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104c09:	e8 a2 ff ff ff       	call   c0104bb0 <boot_alloc_page>
c0104c0e:	a3 24 0a 12 c0       	mov    %eax,0xc0120a24
    memset(boot_pgdir, 0, PGSIZE);
c0104c13:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c18:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c1f:	00 
c0104c20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c27:	00 
c0104c28:	89 04 24             	mov    %eax,(%esp)
c0104c2b:	e8 fc 3c 00 00       	call   c010892c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104c30:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c38:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104c3f:	77 23                	ja     c0104c64 <pmm_init+0x70>
c0104c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c44:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c48:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c0104c4f:	c0 
c0104c50:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104c57:	00 
c0104c58:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104c5f:	e8 70 c0 ff ff       	call   c0100cd4 <__panic>
c0104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c67:	05 00 00 00 40       	add    $0x40000000,%eax
c0104c6c:	a3 d0 0a 12 c0       	mov    %eax,0xc0120ad0

    check_pgdir();
c0104c71:	e8 f5 04 00 00       	call   c010516b <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104c76:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c7b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104c81:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c86:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c89:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104c90:	77 23                	ja     c0104cb5 <pmm_init+0xc1>
c0104c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c95:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c99:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c0104ca0:	c0 
c0104ca1:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104ca8:	00 
c0104ca9:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104cb0:	e8 1f c0 ff ff       	call   c0100cd4 <__panic>
c0104cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cb8:	05 00 00 00 40       	add    $0x40000000,%eax
c0104cbd:	83 c8 03             	or     $0x3,%eax
c0104cc0:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104cc2:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104cc7:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104cce:	00 
c0104ccf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104cd6:	00 
c0104cd7:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104cde:	38 
c0104cdf:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104ce6:	c0 
c0104ce7:	89 04 24             	mov    %eax,(%esp)
c0104cea:	e8 b4 fd ff ff       	call   c0104aa3 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104cef:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104cf4:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0104cfa:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104d00:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104d02:	e8 63 fd ff ff       	call   c0104a6a <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104d07:	e8 74 f7 ff ff       	call   c0104480 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104d0c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104d17:	e8 ea 0a 00 00       	call   c0105806 <check_boot_pgdir>

    print_pgdir();
c0104d1c:	e8 77 0f 00 00       	call   c0105c98 <print_pgdir>

}
c0104d21:	c9                   	leave  
c0104d22:	c3                   	ret    

c0104d23 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104d23:	55                   	push   %ebp
c0104d24:	89 e5                	mov    %esp,%ebp
c0104d26:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

pde_t *pdep = &pgdir[PDX(la)];
c0104d29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d2c:	c1 e8 16             	shr    $0x16,%eax
c0104d2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d39:	01 d0                	add    %edx,%eax
c0104d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
if(!(*pdep & PTE_P))
c0104d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d41:	8b 00                	mov    (%eax),%eax
c0104d43:	83 e0 01             	and    $0x1,%eax
c0104d46:	85 c0                	test   %eax,%eax
c0104d48:	0f 85 bd 00 00 00    	jne    c0104e0b <get_pte+0xe8>
{
    struct Page* p;
    if(create){
c0104d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104d52:	0f 84 ac 00 00 00    	je     c0104e04 <get_pte+0xe1>
    	p = alloc_page();
c0104d58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d5f:	e8 5d f8 ff ff       	call   c01045c1 <alloc_pages>
c0104d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(p != NULL)
c0104d67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d6b:	0f 84 8c 00 00 00    	je     c0104dfd <get_pte+0xda>
	{
	    set_page_ref(p,1);
c0104d71:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d78:	00 
c0104d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d7c:	89 04 24             	mov    %eax,(%esp)
c0104d7f:	e8 42 f6 ff ff       	call   c01043c6 <set_page_ref>
	    uintptr_t pa = page2pa(p);
c0104d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d87:	89 04 24             	mov    %eax,(%esp)
c0104d8a:	e8 f6 f4 ff ff       	call   c0104285 <page2pa>
c0104d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    memset(KADDR(pa),0,PGSIZE);
c0104d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d95:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d98:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d9b:	c1 e8 0c             	shr    $0xc,%eax
c0104d9e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104da1:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104da6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104da9:	72 23                	jb     c0104dce <get_pte+0xab>
c0104dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104db2:	c7 44 24 08 cc 96 10 	movl   $0xc01096cc,0x8(%esp)
c0104db9:	c0 
c0104dba:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0104dc1:	00 
c0104dc2:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104dc9:	e8 06 bf ff ff       	call   c0100cd4 <__panic>
c0104dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104dd1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104dd6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104ddd:	00 
c0104dde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104de5:	00 
c0104de6:	89 04 24             	mov    %eax,(%esp)
c0104de9:	e8 3e 3b 00 00       	call   c010892c <memset>
	    *pdep = pa | PTE_P | PTE_W | PTE_U; //why?
c0104dee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104df1:	83 c8 07             	or     $0x7,%eax
c0104df4:	89 c2                	mov    %eax,%edx
c0104df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df9:	89 10                	mov    %edx,(%eax)
c0104dfb:	eb 0e                	jmp    c0104e0b <get_pte+0xe8>
	}
	else return NULL;
c0104dfd:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e02:	eb 63                	jmp    c0104e67 <get_pte+0x144>
    }
    else return NULL;
c0104e04:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e09:	eb 5c                	jmp    c0104e67 <get_pte+0x144>
  }
  return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e0e:	8b 00                	mov    (%eax),%eax
c0104e10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e15:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e1b:	c1 e8 0c             	shr    $0xc,%eax
c0104e1e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e21:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104e26:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e29:	72 23                	jb     c0104e4e <get_pte+0x12b>
c0104e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e32:	c7 44 24 08 cc 96 10 	movl   $0xc01096cc,0x8(%esp)
c0104e39:	c0 
c0104e3a:	c7 44 24 04 9e 01 00 	movl   $0x19e,0x4(%esp)
c0104e41:	00 
c0104e42:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0104e49:	e8 86 be ff ff       	call   c0100cd4 <__panic>
c0104e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e51:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e56:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e59:	c1 ea 0c             	shr    $0xc,%edx
c0104e5c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104e62:	c1 e2 02             	shl    $0x2,%edx
c0104e65:	01 d0                	add    %edx,%eax
}
c0104e67:	c9                   	leave  
c0104e68:	c3                   	ret    

c0104e69 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104e69:	55                   	push   %ebp
c0104e6a:	89 e5                	mov    %esp,%ebp
c0104e6c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104e6f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e76:	00 
c0104e77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e81:	89 04 24             	mov    %eax,(%esp)
c0104e84:	e8 9a fe ff ff       	call   c0104d23 <get_pte>
c0104e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104e90:	74 08                	je     c0104e9a <get_page+0x31>
        *ptep_store = ptep;
c0104e92:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e98:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e9e:	74 1b                	je     c0104ebb <get_page+0x52>
c0104ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ea3:	8b 00                	mov    (%eax),%eax
c0104ea5:	83 e0 01             	and    $0x1,%eax
c0104ea8:	85 c0                	test   %eax,%eax
c0104eaa:	74 0f                	je     c0104ebb <get_page+0x52>
        return pa2page(*ptep);
c0104eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eaf:	8b 00                	mov    (%eax),%eax
c0104eb1:	89 04 24             	mov    %eax,(%esp)
c0104eb4:	e8 e2 f3 ff ff       	call   c010429b <pa2page>
c0104eb9:	eb 05                	jmp    c0104ec0 <get_page+0x57>
    }
    return NULL;
c0104ebb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ec0:	c9                   	leave  
c0104ec1:	c3                   	ret    

c0104ec2 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104ec2:	55                   	push   %ebp
c0104ec3:	89 e5                	mov    %esp,%ebp
c0104ec5:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c0104ec8:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ecb:	8b 00                	mov    (%eax),%eax
c0104ecd:	83 e0 01             	and    $0x1,%eax
c0104ed0:	85 c0                	test   %eax,%eax
c0104ed2:	74 52                	je     c0104f26 <page_remove_pte+0x64>
    struct Page *page = pte2page(*ptep);
c0104ed4:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ed7:	8b 00                	mov    (%eax),%eax
c0104ed9:	89 04 24             	mov    %eax,(%esp)
c0104edc:	e8 9d f4 ff ff       	call   c010437e <pte2page>
c0104ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    page_ref_dec(page);
c0104ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ee7:	89 04 24             	mov    %eax,(%esp)
c0104eea:	e8 fb f4 ff ff       	call   c01043ea <page_ref_dec>
    if(page->ref == 0)
c0104eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef2:	8b 00                	mov    (%eax),%eax
c0104ef4:	85 c0                	test   %eax,%eax
c0104ef6:	75 13                	jne    c0104f0b <page_remove_pte+0x49>
    {
	free_page(page);
c0104ef8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104eff:	00 
c0104f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f03:	89 04 24             	mov    %eax,(%esp)
c0104f06:	e8 21 f7 ff ff       	call   c010462c <free_pages>
    }
    *ptep = 0;
c0104f0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    tlb_invalidate(pgdir,la);
c0104f14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f1e:	89 04 24             	mov    %eax,(%esp)
c0104f21:	e8 ff 00 00 00       	call   c0105025 <tlb_invalidate>
  }
}
c0104f26:	c9                   	leave  
c0104f27:	c3                   	ret    

c0104f28 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104f28:	55                   	push   %ebp
c0104f29:	89 e5                	mov    %esp,%ebp
c0104f2b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f2e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f35:	00 
c0104f36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f40:	89 04 24             	mov    %eax,(%esp)
c0104f43:	e8 db fd ff ff       	call   c0104d23 <get_pte>
c0104f48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104f4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f4f:	74 19                	je     c0104f6a <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f54:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104f58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f62:	89 04 24             	mov    %eax,(%esp)
c0104f65:	e8 58 ff ff ff       	call   c0104ec2 <page_remove_pte>
    }
}
c0104f6a:	c9                   	leave  
c0104f6b:	c3                   	ret    

c0104f6c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104f6c:	55                   	push   %ebp
c0104f6d:	89 e5                	mov    %esp,%ebp
c0104f6f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104f72:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104f79:	00 
c0104f7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f81:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f84:	89 04 24             	mov    %eax,(%esp)
c0104f87:	e8 97 fd ff ff       	call   c0104d23 <get_pte>
c0104f8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104f8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f93:	75 0a                	jne    c0104f9f <page_insert+0x33>
        return -E_NO_MEM;
c0104f95:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104f9a:	e9 84 00 00 00       	jmp    c0105023 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fa2:	89 04 24             	mov    %eax,(%esp)
c0104fa5:	e8 29 f4 ff ff       	call   c01043d3 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fad:	8b 00                	mov    (%eax),%eax
c0104faf:	83 e0 01             	and    $0x1,%eax
c0104fb2:	85 c0                	test   %eax,%eax
c0104fb4:	74 3e                	je     c0104ff4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fb9:	8b 00                	mov    (%eax),%eax
c0104fbb:	89 04 24             	mov    %eax,(%esp)
c0104fbe:	e8 bb f3 ff ff       	call   c010437e <pte2page>
c0104fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104fcc:	75 0d                	jne    c0104fdb <page_insert+0x6f>
            page_ref_dec(page);
c0104fce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fd1:	89 04 24             	mov    %eax,(%esp)
c0104fd4:	e8 11 f4 ff ff       	call   c01043ea <page_ref_dec>
c0104fd9:	eb 19                	jmp    c0104ff4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fde:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104fe2:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fe9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fec:	89 04 24             	mov    %eax,(%esp)
c0104fef:	e8 ce fe ff ff       	call   c0104ec2 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ff7:	89 04 24             	mov    %eax,(%esp)
c0104ffa:	e8 86 f2 ff ff       	call   c0104285 <page2pa>
c0104fff:	0b 45 14             	or     0x14(%ebp),%eax
c0105002:	83 c8 01             	or     $0x1,%eax
c0105005:	89 c2                	mov    %eax,%edx
c0105007:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010500a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010500c:	8b 45 10             	mov    0x10(%ebp),%eax
c010500f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105013:	8b 45 08             	mov    0x8(%ebp),%eax
c0105016:	89 04 24             	mov    %eax,(%esp)
c0105019:	e8 07 00 00 00       	call   c0105025 <tlb_invalidate>
    return 0;
c010501e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105023:	c9                   	leave  
c0105024:	c3                   	ret    

c0105025 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105025:	55                   	push   %ebp
c0105026:	89 e5                	mov    %esp,%ebp
c0105028:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010502b:	0f 20 d8             	mov    %cr3,%eax
c010502e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105031:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105034:	89 c2                	mov    %eax,%edx
c0105036:	8b 45 08             	mov    0x8(%ebp),%eax
c0105039:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010503c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105043:	77 23                	ja     c0105068 <tlb_invalidate+0x43>
c0105045:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105048:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010504c:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c0105053:	c0 
c0105054:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c010505b:	00 
c010505c:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105063:	e8 6c bc ff ff       	call   c0100cd4 <__panic>
c0105068:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010506b:	05 00 00 00 40       	add    $0x40000000,%eax
c0105070:	39 c2                	cmp    %eax,%edx
c0105072:	75 0c                	jne    c0105080 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105074:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105077:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010507a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010507d:	0f 01 38             	invlpg (%eax)
    }
}
c0105080:	c9                   	leave  
c0105081:	c3                   	ret    

c0105082 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105082:	55                   	push   %ebp
c0105083:	89 e5                	mov    %esp,%ebp
c0105085:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105088:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010508f:	e8 2d f5 ff ff       	call   c01045c1 <alloc_pages>
c0105094:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105097:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010509b:	0f 84 a7 00 00 00    	je     c0105148 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01050a1:	8b 45 10             	mov    0x10(%ebp),%eax
c01050a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050ab:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01050b9:	89 04 24             	mov    %eax,(%esp)
c01050bc:	e8 ab fe ff ff       	call   c0104f6c <page_insert>
c01050c1:	85 c0                	test   %eax,%eax
c01050c3:	74 1a                	je     c01050df <pgdir_alloc_page+0x5d>
            free_page(page);
c01050c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050cc:	00 
c01050cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050d0:	89 04 24             	mov    %eax,(%esp)
c01050d3:	e8 54 f5 ff ff       	call   c010462c <free_pages>
            return NULL;
c01050d8:	b8 00 00 00 00       	mov    $0x0,%eax
c01050dd:	eb 6c                	jmp    c010514b <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01050df:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c01050e4:	85 c0                	test   %eax,%eax
c01050e6:	74 60                	je     c0105148 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01050e8:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01050ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01050f4:	00 
c01050f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050f8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01050fc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01050ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105103:	89 04 24             	mov    %eax,(%esp)
c0105106:	e8 78 0f 00 00       	call   c0106083 <swap_map_swappable>
            page->pra_vaddr=la;
c010510b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010510e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105111:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105114:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105117:	89 04 24             	mov    %eax,(%esp)
c010511a:	e8 9d f2 ff ff       	call   c01043bc <page_ref>
c010511f:	83 f8 01             	cmp    $0x1,%eax
c0105122:	74 24                	je     c0105148 <pgdir_alloc_page+0xc6>
c0105124:	c7 44 24 0c f4 97 10 	movl   $0xc01097f4,0xc(%esp)
c010512b:	c0 
c010512c:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105133:	c0 
c0105134:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c010513b:	00 
c010513c:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105143:	e8 8c bb ff ff       	call   c0100cd4 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105148:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010514b:	c9                   	leave  
c010514c:	c3                   	ret    

c010514d <check_alloc_page>:

static void
check_alloc_page(void) {
c010514d:	55                   	push   %ebp
c010514e:	89 e5                	mov    %esp,%ebp
c0105150:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105153:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0105158:	8b 40 18             	mov    0x18(%eax),%eax
c010515b:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010515d:	c7 04 24 08 98 10 c0 	movl   $0xc0109808,(%esp)
c0105164:	e8 e2 b1 ff ff       	call   c010034b <cprintf>
}
c0105169:	c9                   	leave  
c010516a:	c3                   	ret    

c010516b <check_pgdir>:

static void
check_pgdir(void) {
c010516b:	55                   	push   %ebp
c010516c:	89 e5                	mov    %esp,%ebp
c010516e:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105171:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105176:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010517b:	76 24                	jbe    c01051a1 <check_pgdir+0x36>
c010517d:	c7 44 24 0c 27 98 10 	movl   $0xc0109827,0xc(%esp)
c0105184:	c0 
c0105185:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010518c:	c0 
c010518d:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105194:	00 
c0105195:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010519c:	e8 33 bb ff ff       	call   c0100cd4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01051a1:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01051a6:	85 c0                	test   %eax,%eax
c01051a8:	74 0e                	je     c01051b8 <check_pgdir+0x4d>
c01051aa:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01051af:	25 ff 0f 00 00       	and    $0xfff,%eax
c01051b4:	85 c0                	test   %eax,%eax
c01051b6:	74 24                	je     c01051dc <check_pgdir+0x71>
c01051b8:	c7 44 24 0c 44 98 10 	movl   $0xc0109844,0xc(%esp)
c01051bf:	c0 
c01051c0:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01051c7:	c0 
c01051c8:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c01051cf:	00 
c01051d0:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01051d7:	e8 f8 ba ff ff       	call   c0100cd4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01051dc:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01051e1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01051e8:	00 
c01051e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01051f0:	00 
c01051f1:	89 04 24             	mov    %eax,(%esp)
c01051f4:	e8 70 fc ff ff       	call   c0104e69 <get_page>
c01051f9:	85 c0                	test   %eax,%eax
c01051fb:	74 24                	je     c0105221 <check_pgdir+0xb6>
c01051fd:	c7 44 24 0c 7c 98 10 	movl   $0xc010987c,0xc(%esp)
c0105204:	c0 
c0105205:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010520c:	c0 
c010520d:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105214:	00 
c0105215:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010521c:	e8 b3 ba ff ff       	call   c0100cd4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105221:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105228:	e8 94 f3 ff ff       	call   c01045c1 <alloc_pages>
c010522d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105230:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105235:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010523c:	00 
c010523d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105244:	00 
c0105245:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105248:	89 54 24 04          	mov    %edx,0x4(%esp)
c010524c:	89 04 24             	mov    %eax,(%esp)
c010524f:	e8 18 fd ff ff       	call   c0104f6c <page_insert>
c0105254:	85 c0                	test   %eax,%eax
c0105256:	74 24                	je     c010527c <check_pgdir+0x111>
c0105258:	c7 44 24 0c a4 98 10 	movl   $0xc01098a4,0xc(%esp)
c010525f:	c0 
c0105260:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105267:	c0 
c0105268:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010526f:	00 
c0105270:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105277:	e8 58 ba ff ff       	call   c0100cd4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010527c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105281:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105288:	00 
c0105289:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105290:	00 
c0105291:	89 04 24             	mov    %eax,(%esp)
c0105294:	e8 8a fa ff ff       	call   c0104d23 <get_pte>
c0105299:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010529c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052a0:	75 24                	jne    c01052c6 <check_pgdir+0x15b>
c01052a2:	c7 44 24 0c d0 98 10 	movl   $0xc01098d0,0xc(%esp)
c01052a9:	c0 
c01052aa:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01052b1:	c0 
c01052b2:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01052b9:	00 
c01052ba:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01052c1:	e8 0e ba ff ff       	call   c0100cd4 <__panic>
    assert(pa2page(*ptep) == p1);
c01052c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052c9:	8b 00                	mov    (%eax),%eax
c01052cb:	89 04 24             	mov    %eax,(%esp)
c01052ce:	e8 c8 ef ff ff       	call   c010429b <pa2page>
c01052d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01052d6:	74 24                	je     c01052fc <check_pgdir+0x191>
c01052d8:	c7 44 24 0c fd 98 10 	movl   $0xc01098fd,0xc(%esp)
c01052df:	c0 
c01052e0:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01052e7:	c0 
c01052e8:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01052ef:	00 
c01052f0:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01052f7:	e8 d8 b9 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p1) == 1);
c01052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052ff:	89 04 24             	mov    %eax,(%esp)
c0105302:	e8 b5 f0 ff ff       	call   c01043bc <page_ref>
c0105307:	83 f8 01             	cmp    $0x1,%eax
c010530a:	74 24                	je     c0105330 <check_pgdir+0x1c5>
c010530c:	c7 44 24 0c 12 99 10 	movl   $0xc0109912,0xc(%esp)
c0105313:	c0 
c0105314:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010531b:	c0 
c010531c:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105323:	00 
c0105324:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010532b:	e8 a4 b9 ff ff       	call   c0100cd4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105330:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105335:	8b 00                	mov    (%eax),%eax
c0105337:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010533c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010533f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105342:	c1 e8 0c             	shr    $0xc,%eax
c0105345:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105348:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010534d:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105350:	72 23                	jb     c0105375 <check_pgdir+0x20a>
c0105352:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105355:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105359:	c7 44 24 08 cc 96 10 	movl   $0xc01096cc,0x8(%esp)
c0105360:	c0 
c0105361:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105368:	00 
c0105369:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105370:	e8 5f b9 ff ff       	call   c0100cd4 <__panic>
c0105375:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105378:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010537d:	83 c0 04             	add    $0x4,%eax
c0105380:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105383:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010538f:	00 
c0105390:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105397:	00 
c0105398:	89 04 24             	mov    %eax,(%esp)
c010539b:	e8 83 f9 ff ff       	call   c0104d23 <get_pte>
c01053a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01053a3:	74 24                	je     c01053c9 <check_pgdir+0x25e>
c01053a5:	c7 44 24 0c 24 99 10 	movl   $0xc0109924,0xc(%esp)
c01053ac:	c0 
c01053ad:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01053b4:	c0 
c01053b5:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c01053bc:	00 
c01053bd:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01053c4:	e8 0b b9 ff ff       	call   c0100cd4 <__panic>

    p2 = alloc_page();
c01053c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01053d0:	e8 ec f1 ff ff       	call   c01045c1 <alloc_pages>
c01053d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01053d8:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01053dd:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01053e4:	00 
c01053e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01053ec:	00 
c01053ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01053f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053f4:	89 04 24             	mov    %eax,(%esp)
c01053f7:	e8 70 fb ff ff       	call   c0104f6c <page_insert>
c01053fc:	85 c0                	test   %eax,%eax
c01053fe:	74 24                	je     c0105424 <check_pgdir+0x2b9>
c0105400:	c7 44 24 0c 4c 99 10 	movl   $0xc010994c,0xc(%esp)
c0105407:	c0 
c0105408:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010540f:	c0 
c0105410:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105417:	00 
c0105418:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010541f:	e8 b0 b8 ff ff       	call   c0100cd4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105424:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105429:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105430:	00 
c0105431:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105438:	00 
c0105439:	89 04 24             	mov    %eax,(%esp)
c010543c:	e8 e2 f8 ff ff       	call   c0104d23 <get_pte>
c0105441:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105448:	75 24                	jne    c010546e <check_pgdir+0x303>
c010544a:	c7 44 24 0c 84 99 10 	movl   $0xc0109984,0xc(%esp)
c0105451:	c0 
c0105452:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105459:	c0 
c010545a:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105461:	00 
c0105462:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105469:	e8 66 b8 ff ff       	call   c0100cd4 <__panic>
    assert(*ptep & PTE_U);
c010546e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105471:	8b 00                	mov    (%eax),%eax
c0105473:	83 e0 04             	and    $0x4,%eax
c0105476:	85 c0                	test   %eax,%eax
c0105478:	75 24                	jne    c010549e <check_pgdir+0x333>
c010547a:	c7 44 24 0c b4 99 10 	movl   $0xc01099b4,0xc(%esp)
c0105481:	c0 
c0105482:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105489:	c0 
c010548a:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105491:	00 
c0105492:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105499:	e8 36 b8 ff ff       	call   c0100cd4 <__panic>
    assert(*ptep & PTE_W);
c010549e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a1:	8b 00                	mov    (%eax),%eax
c01054a3:	83 e0 02             	and    $0x2,%eax
c01054a6:	85 c0                	test   %eax,%eax
c01054a8:	75 24                	jne    c01054ce <check_pgdir+0x363>
c01054aa:	c7 44 24 0c c2 99 10 	movl   $0xc01099c2,0xc(%esp)
c01054b1:	c0 
c01054b2:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01054b9:	c0 
c01054ba:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01054c1:	00 
c01054c2:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01054c9:	e8 06 b8 ff ff       	call   c0100cd4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01054ce:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01054d3:	8b 00                	mov    (%eax),%eax
c01054d5:	83 e0 04             	and    $0x4,%eax
c01054d8:	85 c0                	test   %eax,%eax
c01054da:	75 24                	jne    c0105500 <check_pgdir+0x395>
c01054dc:	c7 44 24 0c d0 99 10 	movl   $0xc01099d0,0xc(%esp)
c01054e3:	c0 
c01054e4:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01054eb:	c0 
c01054ec:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c01054f3:	00 
c01054f4:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01054fb:	e8 d4 b7 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p2) == 1);
c0105500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105503:	89 04 24             	mov    %eax,(%esp)
c0105506:	e8 b1 ee ff ff       	call   c01043bc <page_ref>
c010550b:	83 f8 01             	cmp    $0x1,%eax
c010550e:	74 24                	je     c0105534 <check_pgdir+0x3c9>
c0105510:	c7 44 24 0c e6 99 10 	movl   $0xc01099e6,0xc(%esp)
c0105517:	c0 
c0105518:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010551f:	c0 
c0105520:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105527:	00 
c0105528:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010552f:	e8 a0 b7 ff ff       	call   c0100cd4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105534:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105539:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105540:	00 
c0105541:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105548:	00 
c0105549:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010554c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105550:	89 04 24             	mov    %eax,(%esp)
c0105553:	e8 14 fa ff ff       	call   c0104f6c <page_insert>
c0105558:	85 c0                	test   %eax,%eax
c010555a:	74 24                	je     c0105580 <check_pgdir+0x415>
c010555c:	c7 44 24 0c f8 99 10 	movl   $0xc01099f8,0xc(%esp)
c0105563:	c0 
c0105564:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010556b:	c0 
c010556c:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105573:	00 
c0105574:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010557b:	e8 54 b7 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p1) == 2);
c0105580:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105583:	89 04 24             	mov    %eax,(%esp)
c0105586:	e8 31 ee ff ff       	call   c01043bc <page_ref>
c010558b:	83 f8 02             	cmp    $0x2,%eax
c010558e:	74 24                	je     c01055b4 <check_pgdir+0x449>
c0105590:	c7 44 24 0c 24 9a 10 	movl   $0xc0109a24,0xc(%esp)
c0105597:	c0 
c0105598:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010559f:	c0 
c01055a0:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01055a7:	00 
c01055a8:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01055af:	e8 20 b7 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p2) == 0);
c01055b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055b7:	89 04 24             	mov    %eax,(%esp)
c01055ba:	e8 fd ed ff ff       	call   c01043bc <page_ref>
c01055bf:	85 c0                	test   %eax,%eax
c01055c1:	74 24                	je     c01055e7 <check_pgdir+0x47c>
c01055c3:	c7 44 24 0c 36 9a 10 	movl   $0xc0109a36,0xc(%esp)
c01055ca:	c0 
c01055cb:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01055d2:	c0 
c01055d3:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01055da:	00 
c01055db:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01055e2:	e8 ed b6 ff ff       	call   c0100cd4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01055e7:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01055ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01055f3:	00 
c01055f4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01055fb:	00 
c01055fc:	89 04 24             	mov    %eax,(%esp)
c01055ff:	e8 1f f7 ff ff       	call   c0104d23 <get_pte>
c0105604:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010560b:	75 24                	jne    c0105631 <check_pgdir+0x4c6>
c010560d:	c7 44 24 0c 84 99 10 	movl   $0xc0109984,0xc(%esp)
c0105614:	c0 
c0105615:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010561c:	c0 
c010561d:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105624:	00 
c0105625:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010562c:	e8 a3 b6 ff ff       	call   c0100cd4 <__panic>
    assert(pa2page(*ptep) == p1);
c0105631:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105634:	8b 00                	mov    (%eax),%eax
c0105636:	89 04 24             	mov    %eax,(%esp)
c0105639:	e8 5d ec ff ff       	call   c010429b <pa2page>
c010563e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105641:	74 24                	je     c0105667 <check_pgdir+0x4fc>
c0105643:	c7 44 24 0c fd 98 10 	movl   $0xc01098fd,0xc(%esp)
c010564a:	c0 
c010564b:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105652:	c0 
c0105653:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c010565a:	00 
c010565b:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105662:	e8 6d b6 ff ff       	call   c0100cd4 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105667:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010566a:	8b 00                	mov    (%eax),%eax
c010566c:	83 e0 04             	and    $0x4,%eax
c010566f:	85 c0                	test   %eax,%eax
c0105671:	74 24                	je     c0105697 <check_pgdir+0x52c>
c0105673:	c7 44 24 0c 48 9a 10 	movl   $0xc0109a48,0xc(%esp)
c010567a:	c0 
c010567b:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105682:	c0 
c0105683:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c010568a:	00 
c010568b:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105692:	e8 3d b6 ff ff       	call   c0100cd4 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105697:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010569c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056a3:	00 
c01056a4:	89 04 24             	mov    %eax,(%esp)
c01056a7:	e8 7c f8 ff ff       	call   c0104f28 <page_remove>
    assert(page_ref(p1) == 1);
c01056ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056af:	89 04 24             	mov    %eax,(%esp)
c01056b2:	e8 05 ed ff ff       	call   c01043bc <page_ref>
c01056b7:	83 f8 01             	cmp    $0x1,%eax
c01056ba:	74 24                	je     c01056e0 <check_pgdir+0x575>
c01056bc:	c7 44 24 0c 12 99 10 	movl   $0xc0109912,0xc(%esp)
c01056c3:	c0 
c01056c4:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01056cb:	c0 
c01056cc:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01056d3:	00 
c01056d4:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01056db:	e8 f4 b5 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p2) == 0);
c01056e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056e3:	89 04 24             	mov    %eax,(%esp)
c01056e6:	e8 d1 ec ff ff       	call   c01043bc <page_ref>
c01056eb:	85 c0                	test   %eax,%eax
c01056ed:	74 24                	je     c0105713 <check_pgdir+0x5a8>
c01056ef:	c7 44 24 0c 36 9a 10 	movl   $0xc0109a36,0xc(%esp)
c01056f6:	c0 
c01056f7:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01056fe:	c0 
c01056ff:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105706:	00 
c0105707:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010570e:	e8 c1 b5 ff ff       	call   c0100cd4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105713:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105718:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010571f:	00 
c0105720:	89 04 24             	mov    %eax,(%esp)
c0105723:	e8 00 f8 ff ff       	call   c0104f28 <page_remove>
    assert(page_ref(p1) == 0);
c0105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010572b:	89 04 24             	mov    %eax,(%esp)
c010572e:	e8 89 ec ff ff       	call   c01043bc <page_ref>
c0105733:	85 c0                	test   %eax,%eax
c0105735:	74 24                	je     c010575b <check_pgdir+0x5f0>
c0105737:	c7 44 24 0c 5d 9a 10 	movl   $0xc0109a5d,0xc(%esp)
c010573e:	c0 
c010573f:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105746:	c0 
c0105747:	c7 44 24 04 4a 02 00 	movl   $0x24a,0x4(%esp)
c010574e:	00 
c010574f:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105756:	e8 79 b5 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p2) == 0);
c010575b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010575e:	89 04 24             	mov    %eax,(%esp)
c0105761:	e8 56 ec ff ff       	call   c01043bc <page_ref>
c0105766:	85 c0                	test   %eax,%eax
c0105768:	74 24                	je     c010578e <check_pgdir+0x623>
c010576a:	c7 44 24 0c 36 9a 10 	movl   $0xc0109a36,0xc(%esp)
c0105771:	c0 
c0105772:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105779:	c0 
c010577a:	c7 44 24 04 4b 02 00 	movl   $0x24b,0x4(%esp)
c0105781:	00 
c0105782:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105789:	e8 46 b5 ff ff       	call   c0100cd4 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c010578e:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105793:	8b 00                	mov    (%eax),%eax
c0105795:	89 04 24             	mov    %eax,(%esp)
c0105798:	e8 fe ea ff ff       	call   c010429b <pa2page>
c010579d:	89 04 24             	mov    %eax,(%esp)
c01057a0:	e8 17 ec ff ff       	call   c01043bc <page_ref>
c01057a5:	83 f8 01             	cmp    $0x1,%eax
c01057a8:	74 24                	je     c01057ce <check_pgdir+0x663>
c01057aa:	c7 44 24 0c 70 9a 10 	movl   $0xc0109a70,0xc(%esp)
c01057b1:	c0 
c01057b2:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01057b9:	c0 
c01057ba:	c7 44 24 04 4d 02 00 	movl   $0x24d,0x4(%esp)
c01057c1:	00 
c01057c2:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01057c9:	e8 06 b5 ff ff       	call   c0100cd4 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c01057ce:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01057d3:	8b 00                	mov    (%eax),%eax
c01057d5:	89 04 24             	mov    %eax,(%esp)
c01057d8:	e8 be ea ff ff       	call   c010429b <pa2page>
c01057dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057e4:	00 
c01057e5:	89 04 24             	mov    %eax,(%esp)
c01057e8:	e8 3f ee ff ff       	call   c010462c <free_pages>
    boot_pgdir[0] = 0;
c01057ed:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01057f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01057f8:	c7 04 24 96 9a 10 c0 	movl   $0xc0109a96,(%esp)
c01057ff:	e8 47 ab ff ff       	call   c010034b <cprintf>
}
c0105804:	c9                   	leave  
c0105805:	c3                   	ret    

c0105806 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105806:	55                   	push   %ebp
c0105807:	89 e5                	mov    %esp,%ebp
c0105809:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010580c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105813:	e9 ca 00 00 00       	jmp    c01058e2 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105818:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010581b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010581e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105821:	c1 e8 0c             	shr    $0xc,%eax
c0105824:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105827:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010582c:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010582f:	72 23                	jb     c0105854 <check_boot_pgdir+0x4e>
c0105831:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105834:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105838:	c7 44 24 08 cc 96 10 	movl   $0xc01096cc,0x8(%esp)
c010583f:	c0 
c0105840:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105847:	00 
c0105848:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010584f:	e8 80 b4 ff ff       	call   c0100cd4 <__panic>
c0105854:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105857:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010585c:	89 c2                	mov    %eax,%edx
c010585e:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105863:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010586a:	00 
c010586b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010586f:	89 04 24             	mov    %eax,(%esp)
c0105872:	e8 ac f4 ff ff       	call   c0104d23 <get_pte>
c0105877:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010587a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010587e:	75 24                	jne    c01058a4 <check_boot_pgdir+0x9e>
c0105880:	c7 44 24 0c b0 9a 10 	movl   $0xc0109ab0,0xc(%esp)
c0105887:	c0 
c0105888:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c010588f:	c0 
c0105890:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105897:	00 
c0105898:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c010589f:	e8 30 b4 ff ff       	call   c0100cd4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01058a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058a7:	8b 00                	mov    (%eax),%eax
c01058a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01058ae:	89 c2                	mov    %eax,%edx
c01058b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058b3:	39 c2                	cmp    %eax,%edx
c01058b5:	74 24                	je     c01058db <check_boot_pgdir+0xd5>
c01058b7:	c7 44 24 0c ed 9a 10 	movl   $0xc0109aed,0xc(%esp)
c01058be:	c0 
c01058bf:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01058c6:	c0 
c01058c7:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c01058ce:	00 
c01058cf:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01058d6:	e8 f9 b3 ff ff       	call   c0100cd4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01058db:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01058e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058e5:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01058ea:	39 c2                	cmp    %eax,%edx
c01058ec:	0f 82 26 ff ff ff    	jb     c0105818 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01058f2:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01058f7:	05 ac 0f 00 00       	add    $0xfac,%eax
c01058fc:	8b 00                	mov    (%eax),%eax
c01058fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105903:	89 c2                	mov    %eax,%edx
c0105905:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010590a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010590d:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105914:	77 23                	ja     c0105939 <check_boot_pgdir+0x133>
c0105916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105919:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010591d:	c7 44 24 08 f0 96 10 	movl   $0xc01096f0,0x8(%esp)
c0105924:	c0 
c0105925:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c010592c:	00 
c010592d:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105934:	e8 9b b3 ff ff       	call   c0100cd4 <__panic>
c0105939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010593c:	05 00 00 00 40       	add    $0x40000000,%eax
c0105941:	39 c2                	cmp    %eax,%edx
c0105943:	74 24                	je     c0105969 <check_boot_pgdir+0x163>
c0105945:	c7 44 24 0c 04 9b 10 	movl   $0xc0109b04,0xc(%esp)
c010594c:	c0 
c010594d:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105954:	c0 
c0105955:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c010595c:	00 
c010595d:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105964:	e8 6b b3 ff ff       	call   c0100cd4 <__panic>

    assert(boot_pgdir[0] == 0);
c0105969:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010596e:	8b 00                	mov    (%eax),%eax
c0105970:	85 c0                	test   %eax,%eax
c0105972:	74 24                	je     c0105998 <check_boot_pgdir+0x192>
c0105974:	c7 44 24 0c 38 9b 10 	movl   $0xc0109b38,0xc(%esp)
c010597b:	c0 
c010597c:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105983:	c0 
c0105984:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c010598b:	00 
c010598c:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105993:	e8 3c b3 ff ff       	call   c0100cd4 <__panic>

    struct Page *p;
    p = alloc_page();
c0105998:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010599f:	e8 1d ec ff ff       	call   c01045c1 <alloc_pages>
c01059a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01059a7:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01059ac:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01059b3:	00 
c01059b4:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01059bb:	00 
c01059bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01059bf:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059c3:	89 04 24             	mov    %eax,(%esp)
c01059c6:	e8 a1 f5 ff ff       	call   c0104f6c <page_insert>
c01059cb:	85 c0                	test   %eax,%eax
c01059cd:	74 24                	je     c01059f3 <check_boot_pgdir+0x1ed>
c01059cf:	c7 44 24 0c 4c 9b 10 	movl   $0xc0109b4c,0xc(%esp)
c01059d6:	c0 
c01059d7:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c01059de:	c0 
c01059df:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c01059e6:	00 
c01059e7:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c01059ee:	e8 e1 b2 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p) == 1);
c01059f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059f6:	89 04 24             	mov    %eax,(%esp)
c01059f9:	e8 be e9 ff ff       	call   c01043bc <page_ref>
c01059fe:	83 f8 01             	cmp    $0x1,%eax
c0105a01:	74 24                	je     c0105a27 <check_boot_pgdir+0x221>
c0105a03:	c7 44 24 0c 7a 9b 10 	movl   $0xc0109b7a,0xc(%esp)
c0105a0a:	c0 
c0105a0b:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105a12:	c0 
c0105a13:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0105a1a:	00 
c0105a1b:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105a22:	e8 ad b2 ff ff       	call   c0100cd4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105a27:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105a2c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a33:	00 
c0105a34:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105a3b:	00 
c0105a3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a3f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a43:	89 04 24             	mov    %eax,(%esp)
c0105a46:	e8 21 f5 ff ff       	call   c0104f6c <page_insert>
c0105a4b:	85 c0                	test   %eax,%eax
c0105a4d:	74 24                	je     c0105a73 <check_boot_pgdir+0x26d>
c0105a4f:	c7 44 24 0c 8c 9b 10 	movl   $0xc0109b8c,0xc(%esp)
c0105a56:	c0 
c0105a57:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105a5e:	c0 
c0105a5f:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c0105a66:	00 
c0105a67:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105a6e:	e8 61 b2 ff ff       	call   c0100cd4 <__panic>
    assert(page_ref(p) == 2);
c0105a73:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a76:	89 04 24             	mov    %eax,(%esp)
c0105a79:	e8 3e e9 ff ff       	call   c01043bc <page_ref>
c0105a7e:	83 f8 02             	cmp    $0x2,%eax
c0105a81:	74 24                	je     c0105aa7 <check_boot_pgdir+0x2a1>
c0105a83:	c7 44 24 0c c3 9b 10 	movl   $0xc0109bc3,0xc(%esp)
c0105a8a:	c0 
c0105a8b:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105a92:	c0 
c0105a93:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c0105a9a:	00 
c0105a9b:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105aa2:	e8 2d b2 ff ff       	call   c0100cd4 <__panic>

    const char *str = "ucore: Hello world!!";
c0105aa7:	c7 45 dc d4 9b 10 c0 	movl   $0xc0109bd4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105aae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105abc:	e8 94 2b 00 00       	call   c0108655 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105ac1:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105ac8:	00 
c0105ac9:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105ad0:	e8 f9 2b 00 00       	call   c01086ce <strcmp>
c0105ad5:	85 c0                	test   %eax,%eax
c0105ad7:	74 24                	je     c0105afd <check_boot_pgdir+0x2f7>
c0105ad9:	c7 44 24 0c ec 9b 10 	movl   $0xc0109bec,0xc(%esp)
c0105ae0:	c0 
c0105ae1:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105ae8:	c0 
c0105ae9:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c0105af0:	00 
c0105af1:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105af8:	e8 d7 b1 ff ff       	call   c0100cd4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105afd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b00:	89 04 24             	mov    %eax,(%esp)
c0105b03:	e8 d8 e7 ff ff       	call   c01042e0 <page2kva>
c0105b08:	05 00 01 00 00       	add    $0x100,%eax
c0105b0d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105b10:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b17:	e8 e1 2a 00 00       	call   c01085fd <strlen>
c0105b1c:	85 c0                	test   %eax,%eax
c0105b1e:	74 24                	je     c0105b44 <check_boot_pgdir+0x33e>
c0105b20:	c7 44 24 0c 24 9c 10 	movl   $0xc0109c24,0xc(%esp)
c0105b27:	c0 
c0105b28:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105b2f:	c0 
c0105b30:	c7 44 24 04 6d 02 00 	movl   $0x26d,0x4(%esp)
c0105b37:	00 
c0105b38:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105b3f:	e8 90 b1 ff ff       	call   c0100cd4 <__panic>

    free_page(p);
c0105b44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b4b:	00 
c0105b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b4f:	89 04 24             	mov    %eax,(%esp)
c0105b52:	e8 d5 ea ff ff       	call   c010462c <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105b57:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105b5c:	8b 00                	mov    (%eax),%eax
c0105b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105b63:	89 04 24             	mov    %eax,(%esp)
c0105b66:	e8 30 e7 ff ff       	call   c010429b <pa2page>
c0105b6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b72:	00 
c0105b73:	89 04 24             	mov    %eax,(%esp)
c0105b76:	e8 b1 ea ff ff       	call   c010462c <free_pages>
    boot_pgdir[0] = 0;
c0105b7b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105b80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105b86:	c7 04 24 48 9c 10 c0 	movl   $0xc0109c48,(%esp)
c0105b8d:	e8 b9 a7 ff ff       	call   c010034b <cprintf>
}
c0105b92:	c9                   	leave  
c0105b93:	c3                   	ret    

c0105b94 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105b94:	55                   	push   %ebp
c0105b95:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b9a:	83 e0 04             	and    $0x4,%eax
c0105b9d:	85 c0                	test   %eax,%eax
c0105b9f:	74 07                	je     c0105ba8 <perm2str+0x14>
c0105ba1:	b8 75 00 00 00       	mov    $0x75,%eax
c0105ba6:	eb 05                	jmp    c0105bad <perm2str+0x19>
c0105ba8:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105bad:	a2 a8 0a 12 c0       	mov    %al,0xc0120aa8
    str[1] = 'r';
c0105bb2:	c6 05 a9 0a 12 c0 72 	movb   $0x72,0xc0120aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105bb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbc:	83 e0 02             	and    $0x2,%eax
c0105bbf:	85 c0                	test   %eax,%eax
c0105bc1:	74 07                	je     c0105bca <perm2str+0x36>
c0105bc3:	b8 77 00 00 00       	mov    $0x77,%eax
c0105bc8:	eb 05                	jmp    c0105bcf <perm2str+0x3b>
c0105bca:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105bcf:	a2 aa 0a 12 c0       	mov    %al,0xc0120aaa
    str[3] = '\0';
c0105bd4:	c6 05 ab 0a 12 c0 00 	movb   $0x0,0xc0120aab
    return str;
c0105bdb:	b8 a8 0a 12 c0       	mov    $0xc0120aa8,%eax
}
c0105be0:	5d                   	pop    %ebp
c0105be1:	c3                   	ret    

c0105be2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105be2:	55                   	push   %ebp
c0105be3:	89 e5                	mov    %esp,%ebp
c0105be5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105be8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105beb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105bee:	72 0a                	jb     c0105bfa <get_pgtable_items+0x18>
        return 0;
c0105bf0:	b8 00 00 00 00       	mov    $0x0,%eax
c0105bf5:	e9 9c 00 00 00       	jmp    c0105c96 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105bfa:	eb 04                	jmp    c0105c00 <get_pgtable_items+0x1e>
        start ++;
c0105bfc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105c00:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c03:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c06:	73 18                	jae    c0105c20 <get_pgtable_items+0x3e>
c0105c08:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c0b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c12:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c15:	01 d0                	add    %edx,%eax
c0105c17:	8b 00                	mov    (%eax),%eax
c0105c19:	83 e0 01             	and    $0x1,%eax
c0105c1c:	85 c0                	test   %eax,%eax
c0105c1e:	74 dc                	je     c0105bfc <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105c20:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c23:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c26:	73 69                	jae    c0105c91 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105c28:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105c2c:	74 08                	je     c0105c36 <get_pgtable_items+0x54>
            *left_store = start;
c0105c2e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c31:	8b 55 10             	mov    0x10(%ebp),%edx
c0105c34:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105c36:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c39:	8d 50 01             	lea    0x1(%eax),%edx
c0105c3c:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c3f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c46:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c49:	01 d0                	add    %edx,%eax
c0105c4b:	8b 00                	mov    (%eax),%eax
c0105c4d:	83 e0 07             	and    $0x7,%eax
c0105c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105c53:	eb 04                	jmp    c0105c59 <get_pgtable_items+0x77>
            start ++;
c0105c55:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105c59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c5f:	73 1d                	jae    c0105c7e <get_pgtable_items+0x9c>
c0105c61:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c64:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c6b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c6e:	01 d0                	add    %edx,%eax
c0105c70:	8b 00                	mov    (%eax),%eax
c0105c72:	83 e0 07             	and    $0x7,%eax
c0105c75:	89 c2                	mov    %eax,%edx
c0105c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c7a:	39 c2                	cmp    %eax,%edx
c0105c7c:	74 d7                	je     c0105c55 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105c7e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105c82:	74 08                	je     c0105c8c <get_pgtable_items+0xaa>
            *right_store = start;
c0105c84:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105c87:	8b 55 10             	mov    0x10(%ebp),%edx
c0105c8a:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c8f:	eb 05                	jmp    c0105c96 <get_pgtable_items+0xb4>
    }
    return 0;
c0105c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c96:	c9                   	leave  
c0105c97:	c3                   	ret    

c0105c98 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105c98:	55                   	push   %ebp
c0105c99:	89 e5                	mov    %esp,%ebp
c0105c9b:	57                   	push   %edi
c0105c9c:	56                   	push   %esi
c0105c9d:	53                   	push   %ebx
c0105c9e:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105ca1:	c7 04 24 68 9c 10 c0 	movl   $0xc0109c68,(%esp)
c0105ca8:	e8 9e a6 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105cad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105cb4:	e9 fa 00 00 00       	jmp    c0105db3 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105cbc:	89 04 24             	mov    %eax,(%esp)
c0105cbf:	e8 d0 fe ff ff       	call   c0105b94 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105cc4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105cc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105cca:	29 d1                	sub    %edx,%ecx
c0105ccc:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105cce:	89 d6                	mov    %edx,%esi
c0105cd0:	c1 e6 16             	shl    $0x16,%esi
c0105cd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105cd6:	89 d3                	mov    %edx,%ebx
c0105cd8:	c1 e3 16             	shl    $0x16,%ebx
c0105cdb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105cde:	89 d1                	mov    %edx,%ecx
c0105ce0:	c1 e1 16             	shl    $0x16,%ecx
c0105ce3:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105ce6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105ce9:	29 d7                	sub    %edx,%edi
c0105ceb:	89 fa                	mov    %edi,%edx
c0105ced:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105cf1:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105cf5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105cf9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105cfd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d01:	c7 04 24 99 9c 10 c0 	movl   $0xc0109c99,(%esp)
c0105d08:	e8 3e a6 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d10:	c1 e0 0a             	shl    $0xa,%eax
c0105d13:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105d16:	eb 54                	jmp    c0105d6c <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d1b:	89 04 24             	mov    %eax,(%esp)
c0105d1e:	e8 71 fe ff ff       	call   c0105b94 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105d23:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105d26:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d29:	29 d1                	sub    %edx,%ecx
c0105d2b:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d2d:	89 d6                	mov    %edx,%esi
c0105d2f:	c1 e6 0c             	shl    $0xc,%esi
c0105d32:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d35:	89 d3                	mov    %edx,%ebx
c0105d37:	c1 e3 0c             	shl    $0xc,%ebx
c0105d3a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d3d:	c1 e2 0c             	shl    $0xc,%edx
c0105d40:	89 d1                	mov    %edx,%ecx
c0105d42:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105d45:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d48:	29 d7                	sub    %edx,%edi
c0105d4a:	89 fa                	mov    %edi,%edx
c0105d4c:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105d50:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105d54:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105d5c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d60:	c7 04 24 b8 9c 10 c0 	movl   $0xc0109cb8,(%esp)
c0105d67:	e8 df a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105d6c:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105d71:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105d74:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d77:	89 ce                	mov    %ecx,%esi
c0105d79:	c1 e6 0a             	shl    $0xa,%esi
c0105d7c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105d7f:	89 cb                	mov    %ecx,%ebx
c0105d81:	c1 e3 0a             	shl    $0xa,%ebx
c0105d84:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105d87:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105d8b:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105d8e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105d92:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105d96:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d9a:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105d9e:	89 1c 24             	mov    %ebx,(%esp)
c0105da1:	e8 3c fe ff ff       	call   c0105be2 <get_pgtable_items>
c0105da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105da9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105dad:	0f 85 65 ff ff ff    	jne    c0105d18 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105db3:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105db8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105dbb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105dbe:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105dc2:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105dc5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105dc9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105dcd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105dd1:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105dd8:	00 
c0105dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105de0:	e8 fd fd ff ff       	call   c0105be2 <get_pgtable_items>
c0105de5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105de8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105dec:	0f 85 c7 fe ff ff    	jne    c0105cb9 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105df2:	c7 04 24 dc 9c 10 c0 	movl   $0xc0109cdc,(%esp)
c0105df9:	e8 4d a5 ff ff       	call   c010034b <cprintf>
}
c0105dfe:	83 c4 4c             	add    $0x4c,%esp
c0105e01:	5b                   	pop    %ebx
c0105e02:	5e                   	pop    %esi
c0105e03:	5f                   	pop    %edi
c0105e04:	5d                   	pop    %ebp
c0105e05:	c3                   	ret    

c0105e06 <kmalloc>:

void *
kmalloc(size_t n) {
c0105e06:	55                   	push   %ebp
c0105e07:	89 e5                	mov    %esp,%ebp
c0105e09:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105e0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105e1e:	74 09                	je     c0105e29 <kmalloc+0x23>
c0105e20:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105e27:	76 24                	jbe    c0105e4d <kmalloc+0x47>
c0105e29:	c7 44 24 0c 0d 9d 10 	movl   $0xc0109d0d,0xc(%esp)
c0105e30:	c0 
c0105e31:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105e38:	c0 
c0105e39:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c0105e40:	00 
c0105e41:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105e48:	e8 87 ae ff ff       	call   c0100cd4 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105e4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e50:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105e55:	c1 e8 0c             	shr    $0xc,%eax
c0105e58:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e5e:	89 04 24             	mov    %eax,(%esp)
c0105e61:	e8 5b e7 ff ff       	call   c01045c1 <alloc_pages>
c0105e66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105e69:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105e6d:	75 24                	jne    c0105e93 <kmalloc+0x8d>
c0105e6f:	c7 44 24 0c 24 9d 10 	movl   $0xc0109d24,0xc(%esp)
c0105e76:	c0 
c0105e77:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105e7e:	c0 
c0105e7f:	c7 44 24 04 bc 02 00 	movl   $0x2bc,0x4(%esp)
c0105e86:	00 
c0105e87:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105e8e:	e8 41 ae ff ff       	call   c0100cd4 <__panic>
    ptr=page2kva(base);
c0105e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e96:	89 04 24             	mov    %eax,(%esp)
c0105e99:	e8 42 e4 ff ff       	call   c01042e0 <page2kva>
c0105e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ea4:	c9                   	leave  
c0105ea5:	c3                   	ret    

c0105ea6 <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105ea6:	55                   	push   %ebp
c0105ea7:	89 e5                	mov    %esp,%ebp
c0105ea9:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105eac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105eb0:	74 09                	je     c0105ebb <kfree+0x15>
c0105eb2:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105eb9:	76 24                	jbe    c0105edf <kfree+0x39>
c0105ebb:	c7 44 24 0c 0d 9d 10 	movl   $0xc0109d0d,0xc(%esp)
c0105ec2:	c0 
c0105ec3:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105eca:	c0 
c0105ecb:	c7 44 24 04 c3 02 00 	movl   $0x2c3,0x4(%esp)
c0105ed2:	00 
c0105ed3:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105eda:	e8 f5 ad ff ff       	call   c0100cd4 <__panic>
    assert(ptr != NULL);
c0105edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ee3:	75 24                	jne    c0105f09 <kfree+0x63>
c0105ee5:	c7 44 24 0c 31 9d 10 	movl   $0xc0109d31,0xc(%esp)
c0105eec:	c0 
c0105eed:	c7 44 24 08 b9 97 10 	movl   $0xc01097b9,0x8(%esp)
c0105ef4:	c0 
c0105ef5:	c7 44 24 04 c4 02 00 	movl   $0x2c4,0x4(%esp)
c0105efc:	00 
c0105efd:	c7 04 24 94 97 10 c0 	movl   $0xc0109794,(%esp)
c0105f04:	e8 cb ad ff ff       	call   c0100cd4 <__panic>
    struct Page *base=NULL;
c0105f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f13:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f18:	c1 e8 0c             	shr    $0xc,%eax
c0105f1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f21:	89 04 24             	mov    %eax,(%esp)
c0105f24:	e8 0b e4 ff ff       	call   c0104334 <kva2page>
c0105f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f36:	89 04 24             	mov    %eax,(%esp)
c0105f39:	e8 ee e6 ff ff       	call   c010462c <free_pages>
}
c0105f3e:	c9                   	leave  
c0105f3f:	c3                   	ret    

c0105f40 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105f40:	55                   	push   %ebp
c0105f41:	89 e5                	mov    %esp,%ebp
c0105f43:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105f46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f49:	c1 e8 0c             	shr    $0xc,%eax
c0105f4c:	89 c2                	mov    %eax,%edx
c0105f4e:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105f53:	39 c2                	cmp    %eax,%edx
c0105f55:	72 1c                	jb     c0105f73 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0105f57:	c7 44 24 08 40 9d 10 	movl   $0xc0109d40,0x8(%esp)
c0105f5e:	c0 
c0105f5f:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0105f66:	00 
c0105f67:	c7 04 24 5f 9d 10 c0 	movl   $0xc0109d5f,(%esp)
c0105f6e:	e8 61 ad ff ff       	call   c0100cd4 <__panic>
    }
    return &pages[PPN(pa)];
c0105f73:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0105f78:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f7b:	c1 ea 0c             	shr    $0xc,%edx
c0105f7e:	c1 e2 05             	shl    $0x5,%edx
c0105f81:	01 d0                	add    %edx,%eax
}
c0105f83:	c9                   	leave  
c0105f84:	c3                   	ret    

c0105f85 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105f85:	55                   	push   %ebp
c0105f86:	89 e5                	mov    %esp,%ebp
c0105f88:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0105f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8e:	83 e0 01             	and    $0x1,%eax
c0105f91:	85 c0                	test   %eax,%eax
c0105f93:	75 1c                	jne    c0105fb1 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0105f95:	c7 44 24 08 70 9d 10 	movl   $0xc0109d70,0x8(%esp)
c0105f9c:	c0 
c0105f9d:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105fa4:	00 
c0105fa5:	c7 04 24 5f 9d 10 c0 	movl   $0xc0109d5f,(%esp)
c0105fac:	e8 23 ad ff ff       	call   c0100cd4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105fb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105fb9:	89 04 24             	mov    %eax,(%esp)
c0105fbc:	e8 7f ff ff ff       	call   c0105f40 <pa2page>
}
c0105fc1:	c9                   	leave  
c0105fc2:	c3                   	ret    

c0105fc3 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0105fc3:	55                   	push   %ebp
c0105fc4:	89 e5                	mov    %esp,%ebp
c0105fc6:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0105fc9:	e8 aa 1d 00 00       	call   c0107d78 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0105fce:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105fd3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0105fd8:	76 0c                	jbe    c0105fe6 <swap_init+0x23>
c0105fda:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105fdf:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0105fe4:	76 25                	jbe    c010600b <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0105fe6:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0105feb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fef:	c7 44 24 08 91 9d 10 	movl   $0xc0109d91,0x8(%esp)
c0105ff6:	c0 
c0105ff7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0105ffe:	00 
c0105fff:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106006:	e8 c9 ac ff ff       	call   c0100cd4 <__panic>
     }
     

     sm = &swap_manager_fifo;
c010600b:	c7 05 b4 0a 12 c0 40 	movl   $0xc011fa40,0xc0120ab4
c0106012:	fa 11 c0 
     int r = sm->init();
c0106015:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010601a:	8b 40 04             	mov    0x4(%eax),%eax
c010601d:	ff d0                	call   *%eax
c010601f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106022:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106026:	75 26                	jne    c010604e <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106028:	c7 05 ac 0a 12 c0 01 	movl   $0x1,0xc0120aac
c010602f:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106032:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106037:	8b 00                	mov    (%eax),%eax
c0106039:	89 44 24 04          	mov    %eax,0x4(%esp)
c010603d:	c7 04 24 bb 9d 10 c0 	movl   $0xc0109dbb,(%esp)
c0106044:	e8 02 a3 ff ff       	call   c010034b <cprintf>
          check_swap();
c0106049:	e8 a4 04 00 00       	call   c01064f2 <check_swap>
     }

     return r;
c010604e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106051:	c9                   	leave  
c0106052:	c3                   	ret    

c0106053 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106053:	55                   	push   %ebp
c0106054:	89 e5                	mov    %esp,%ebp
c0106056:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106059:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010605e:	8b 40 08             	mov    0x8(%eax),%eax
c0106061:	8b 55 08             	mov    0x8(%ebp),%edx
c0106064:	89 14 24             	mov    %edx,(%esp)
c0106067:	ff d0                	call   *%eax
}
c0106069:	c9                   	leave  
c010606a:	c3                   	ret    

c010606b <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010606b:	55                   	push   %ebp
c010606c:	89 e5                	mov    %esp,%ebp
c010606e:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106071:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106076:	8b 40 0c             	mov    0xc(%eax),%eax
c0106079:	8b 55 08             	mov    0x8(%ebp),%edx
c010607c:	89 14 24             	mov    %edx,(%esp)
c010607f:	ff d0                	call   *%eax
}
c0106081:	c9                   	leave  
c0106082:	c3                   	ret    

c0106083 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106083:	55                   	push   %ebp
c0106084:	89 e5                	mov    %esp,%ebp
c0106086:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106089:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010608e:	8b 40 10             	mov    0x10(%eax),%eax
c0106091:	8b 55 14             	mov    0x14(%ebp),%edx
c0106094:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106098:	8b 55 10             	mov    0x10(%ebp),%edx
c010609b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010609f:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01060a9:	89 14 24             	mov    %edx,(%esp)
c01060ac:	ff d0                	call   *%eax
}
c01060ae:	c9                   	leave  
c01060af:	c3                   	ret    

c01060b0 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01060b0:	55                   	push   %ebp
c01060b1:	89 e5                	mov    %esp,%ebp
c01060b3:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01060b6:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060bb:	8b 40 14             	mov    0x14(%eax),%eax
c01060be:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060c1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01060c8:	89 14 24             	mov    %edx,(%esp)
c01060cb:	ff d0                	call   *%eax
}
c01060cd:	c9                   	leave  
c01060ce:	c3                   	ret    

c01060cf <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01060cf:	55                   	push   %ebp
c01060d0:	89 e5                	mov    %esp,%ebp
c01060d2:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01060d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01060dc:	e9 5a 01 00 00       	jmp    c010623b <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01060e1:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060e6:	8b 40 18             	mov    0x18(%eax),%eax
c01060e9:	8b 55 10             	mov    0x10(%ebp),%edx
c01060ec:	89 54 24 08          	mov    %edx,0x8(%esp)
c01060f0:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c01060f3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060f7:	8b 55 08             	mov    0x8(%ebp),%edx
c01060fa:	89 14 24             	mov    %edx,(%esp)
c01060fd:	ff d0                	call   *%eax
c01060ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106102:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106106:	74 18                	je     c0106120 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106108:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010610b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010610f:	c7 04 24 d0 9d 10 c0 	movl   $0xc0109dd0,(%esp)
c0106116:	e8 30 a2 ff ff       	call   c010034b <cprintf>
c010611b:	e9 27 01 00 00       	jmp    c0106247 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106123:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106126:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106129:	8b 45 08             	mov    0x8(%ebp),%eax
c010612c:	8b 40 0c             	mov    0xc(%eax),%eax
c010612f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106136:	00 
c0106137:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010613a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010613e:	89 04 24             	mov    %eax,(%esp)
c0106141:	e8 dd eb ff ff       	call   c0104d23 <get_pte>
c0106146:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106149:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010614c:	8b 00                	mov    (%eax),%eax
c010614e:	83 e0 01             	and    $0x1,%eax
c0106151:	85 c0                	test   %eax,%eax
c0106153:	75 24                	jne    c0106179 <swap_out+0xaa>
c0106155:	c7 44 24 0c fd 9d 10 	movl   $0xc0109dfd,0xc(%esp)
c010615c:	c0 
c010615d:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106164:	c0 
c0106165:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010616c:	00 
c010616d:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106174:	e8 5b ab ff ff       	call   c0100cd4 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010617c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010617f:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106182:	c1 ea 0c             	shr    $0xc,%edx
c0106185:	83 c2 01             	add    $0x1,%edx
c0106188:	c1 e2 08             	shl    $0x8,%edx
c010618b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010618f:	89 14 24             	mov    %edx,(%esp)
c0106192:	e8 9b 1c 00 00       	call   c0107e32 <swapfs_write>
c0106197:	85 c0                	test   %eax,%eax
c0106199:	74 34                	je     c01061cf <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010619b:	c7 04 24 27 9e 10 c0 	movl   $0xc0109e27,(%esp)
c01061a2:	e8 a4 a1 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01061a7:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01061ac:	8b 40 10             	mov    0x10(%eax),%eax
c01061af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01061b9:	00 
c01061ba:	89 54 24 08          	mov    %edx,0x8(%esp)
c01061be:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01061c1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01061c8:	89 14 24             	mov    %edx,(%esp)
c01061cb:	ff d0                	call   *%eax
c01061cd:	eb 68                	jmp    c0106237 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01061cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061d2:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061d5:	c1 e8 0c             	shr    $0xc,%eax
c01061d8:	83 c0 01             	add    $0x1,%eax
c01061db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01061e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061ed:	c7 04 24 40 9e 10 c0 	movl   $0xc0109e40,(%esp)
c01061f4:	e8 52 a1 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01061f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061fc:	8b 40 1c             	mov    0x1c(%eax),%eax
c01061ff:	c1 e8 0c             	shr    $0xc,%eax
c0106202:	83 c0 01             	add    $0x1,%eax
c0106205:	c1 e0 08             	shl    $0x8,%eax
c0106208:	89 c2                	mov    %eax,%edx
c010620a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010620d:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c010620f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106212:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106219:	00 
c010621a:	89 04 24             	mov    %eax,(%esp)
c010621d:	e8 0a e4 ff ff       	call   c010462c <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106222:	8b 45 08             	mov    0x8(%ebp),%eax
c0106225:	8b 40 0c             	mov    0xc(%eax),%eax
c0106228:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010622b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010622f:	89 04 24             	mov    %eax,(%esp)
c0106232:	e8 ee ed ff ff       	call   c0105025 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106237:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010623b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010623e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106241:	0f 85 9a fe ff ff    	jne    c01060e1 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106247:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010624a:	c9                   	leave  
c010624b:	c3                   	ret    

c010624c <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c010624c:	55                   	push   %ebp
c010624d:	89 e5                	mov    %esp,%ebp
c010624f:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106259:	e8 63 e3 ff ff       	call   c01045c1 <alloc_pages>
c010625e:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106265:	75 24                	jne    c010628b <swap_in+0x3f>
c0106267:	c7 44 24 0c 80 9e 10 	movl   $0xc0109e80,0xc(%esp)
c010626e:	c0 
c010626f:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106276:	c0 
c0106277:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c010627e:	00 
c010627f:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106286:	e8 49 aa ff ff       	call   c0100cd4 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010628b:	8b 45 08             	mov    0x8(%ebp),%eax
c010628e:	8b 40 0c             	mov    0xc(%eax),%eax
c0106291:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106298:	00 
c0106299:	8b 55 0c             	mov    0xc(%ebp),%edx
c010629c:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062a0:	89 04 24             	mov    %eax,(%esp)
c01062a3:	e8 7b ea ff ff       	call   c0104d23 <get_pte>
c01062a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01062ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062ae:	8b 00                	mov    (%eax),%eax
c01062b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062b3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062b7:	89 04 24             	mov    %eax,(%esp)
c01062ba:	e8 01 1b 00 00       	call   c0107dc0 <swapfs_read>
c01062bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01062c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01062c6:	74 2a                	je     c01062f2 <swap_in+0xa6>
     {
        assert(r!=0);
c01062c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01062cc:	75 24                	jne    c01062f2 <swap_in+0xa6>
c01062ce:	c7 44 24 0c 8d 9e 10 	movl   $0xc0109e8d,0xc(%esp)
c01062d5:	c0 
c01062d6:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01062dd:	c0 
c01062de:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01062e5:	00 
c01062e6:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01062ed:	e8 e2 a9 ff ff       	call   c0100cd4 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01062f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062f5:	8b 00                	mov    (%eax),%eax
c01062f7:	c1 e8 08             	shr    $0x8,%eax
c01062fa:	89 c2                	mov    %eax,%edx
c01062fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106303:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106307:	c7 04 24 94 9e 10 c0 	movl   $0xc0109e94,(%esp)
c010630e:	e8 38 a0 ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c0106313:	8b 45 10             	mov    0x10(%ebp),%eax
c0106316:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106319:	89 10                	mov    %edx,(%eax)
     return 0;
c010631b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106320:	c9                   	leave  
c0106321:	c3                   	ret    

c0106322 <check_content_set>:



static inline void
check_content_set(void)
{
c0106322:	55                   	push   %ebp
c0106323:	89 e5                	mov    %esp,%ebp
c0106325:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106328:	b8 00 10 00 00       	mov    $0x1000,%eax
c010632d:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106330:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106335:	83 f8 01             	cmp    $0x1,%eax
c0106338:	74 24                	je     c010635e <check_content_set+0x3c>
c010633a:	c7 44 24 0c d2 9e 10 	movl   $0xc0109ed2,0xc(%esp)
c0106341:	c0 
c0106342:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106349:	c0 
c010634a:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106351:	00 
c0106352:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106359:	e8 76 a9 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c010635e:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106363:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106366:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010636b:	83 f8 01             	cmp    $0x1,%eax
c010636e:	74 24                	je     c0106394 <check_content_set+0x72>
c0106370:	c7 44 24 0c d2 9e 10 	movl   $0xc0109ed2,0xc(%esp)
c0106377:	c0 
c0106378:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010637f:	c0 
c0106380:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106387:	00 
c0106388:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010638f:	e8 40 a9 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106394:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106399:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010639c:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01063a1:	83 f8 02             	cmp    $0x2,%eax
c01063a4:	74 24                	je     c01063ca <check_content_set+0xa8>
c01063a6:	c7 44 24 0c e1 9e 10 	movl   $0xc0109ee1,0xc(%esp)
c01063ad:	c0 
c01063ae:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01063b5:	c0 
c01063b6:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01063bd:	00 
c01063be:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01063c5:	e8 0a a9 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01063ca:	b8 10 20 00 00       	mov    $0x2010,%eax
c01063cf:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01063d2:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01063d7:	83 f8 02             	cmp    $0x2,%eax
c01063da:	74 24                	je     c0106400 <check_content_set+0xde>
c01063dc:	c7 44 24 0c e1 9e 10 	movl   $0xc0109ee1,0xc(%esp)
c01063e3:	c0 
c01063e4:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01063eb:	c0 
c01063ec:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01063f3:	00 
c01063f4:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01063fb:	e8 d4 a8 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106400:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106405:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106408:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010640d:	83 f8 03             	cmp    $0x3,%eax
c0106410:	74 24                	je     c0106436 <check_content_set+0x114>
c0106412:	c7 44 24 0c f0 9e 10 	movl   $0xc0109ef0,0xc(%esp)
c0106419:	c0 
c010641a:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106421:	c0 
c0106422:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106429:	00 
c010642a:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106431:	e8 9e a8 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106436:	b8 10 30 00 00       	mov    $0x3010,%eax
c010643b:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010643e:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106443:	83 f8 03             	cmp    $0x3,%eax
c0106446:	74 24                	je     c010646c <check_content_set+0x14a>
c0106448:	c7 44 24 0c f0 9e 10 	movl   $0xc0109ef0,0xc(%esp)
c010644f:	c0 
c0106450:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106457:	c0 
c0106458:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c010645f:	00 
c0106460:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106467:	e8 68 a8 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c010646c:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106471:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106474:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106479:	83 f8 04             	cmp    $0x4,%eax
c010647c:	74 24                	je     c01064a2 <check_content_set+0x180>
c010647e:	c7 44 24 0c ff 9e 10 	movl   $0xc0109eff,0xc(%esp)
c0106485:	c0 
c0106486:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010648d:	c0 
c010648e:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106495:	00 
c0106496:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010649d:	e8 32 a8 ff ff       	call   c0100cd4 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01064a2:	b8 10 40 00 00       	mov    $0x4010,%eax
c01064a7:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01064aa:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01064af:	83 f8 04             	cmp    $0x4,%eax
c01064b2:	74 24                	je     c01064d8 <check_content_set+0x1b6>
c01064b4:	c7 44 24 0c ff 9e 10 	movl   $0xc0109eff,0xc(%esp)
c01064bb:	c0 
c01064bc:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01064c3:	c0 
c01064c4:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01064cb:	00 
c01064cc:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01064d3:	e8 fc a7 ff ff       	call   c0100cd4 <__panic>
}
c01064d8:	c9                   	leave  
c01064d9:	c3                   	ret    

c01064da <check_content_access>:

static inline int
check_content_access(void)
{
c01064da:	55                   	push   %ebp
c01064db:	89 e5                	mov    %esp,%ebp
c01064dd:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01064e0:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01064e5:	8b 40 1c             	mov    0x1c(%eax),%eax
c01064e8:	ff d0                	call   *%eax
c01064ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01064ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01064f0:	c9                   	leave  
c01064f1:	c3                   	ret    

c01064f2 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01064f2:	55                   	push   %ebp
c01064f3:	89 e5                	mov    %esp,%ebp
c01064f5:	53                   	push   %ebx
c01064f6:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01064f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106500:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106507:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010650e:	eb 6b                	jmp    c010657b <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106510:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106513:	83 e8 0c             	sub    $0xc,%eax
c0106516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010651c:	83 c0 04             	add    $0x4,%eax
c010651f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106526:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106529:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010652c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010652f:	0f a3 10             	bt     %edx,(%eax)
c0106532:	19 c0                	sbb    %eax,%eax
c0106534:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106537:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010653b:	0f 95 c0             	setne  %al
c010653e:	0f b6 c0             	movzbl %al,%eax
c0106541:	85 c0                	test   %eax,%eax
c0106543:	75 24                	jne    c0106569 <check_swap+0x77>
c0106545:	c7 44 24 0c 0e 9f 10 	movl   $0xc0109f0e,0xc(%esp)
c010654c:	c0 
c010654d:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106554:	c0 
c0106555:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c010655c:	00 
c010655d:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106564:	e8 6b a7 ff ff       	call   c0100cd4 <__panic>
        count ++, total += p->property;
c0106569:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010656d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106570:	8b 50 08             	mov    0x8(%eax),%edx
c0106573:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106576:	01 d0                	add    %edx,%eax
c0106578:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010657b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010657e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106581:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106584:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106587:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010658a:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106591:	0f 85 79 ff ff ff    	jne    c0106510 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106597:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010659a:	e8 bf e0 ff ff       	call   c010465e <nr_free_pages>
c010659f:	39 c3                	cmp    %eax,%ebx
c01065a1:	74 24                	je     c01065c7 <check_swap+0xd5>
c01065a3:	c7 44 24 0c 1e 9f 10 	movl   $0xc0109f1e,0xc(%esp)
c01065aa:	c0 
c01065ab:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01065b2:	c0 
c01065b3:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01065ba:	00 
c01065bb:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01065c2:	e8 0d a7 ff ff       	call   c0100cd4 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01065c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01065ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01065d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01065d5:	c7 04 24 38 9f 10 c0 	movl   $0xc0109f38,(%esp)
c01065dc:	e8 6a 9d ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01065e1:	e8 f7 09 00 00       	call   c0106fdd <mm_create>
c01065e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01065e9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01065ed:	75 24                	jne    c0106613 <check_swap+0x121>
c01065ef:	c7 44 24 0c 5e 9f 10 	movl   $0xc0109f5e,0xc(%esp)
c01065f6:	c0 
c01065f7:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01065fe:	c0 
c01065ff:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106606:	00 
c0106607:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010660e:	e8 c1 a6 ff ff       	call   c0100cd4 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106613:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0106618:	85 c0                	test   %eax,%eax
c010661a:	74 24                	je     c0106640 <check_swap+0x14e>
c010661c:	c7 44 24 0c 69 9f 10 	movl   $0xc0109f69,0xc(%esp)
c0106623:	c0 
c0106624:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010662b:	c0 
c010662c:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106633:	00 
c0106634:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010663b:	e8 94 a6 ff ff       	call   c0100cd4 <__panic>

     check_mm_struct = mm;
c0106640:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106643:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106648:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c010664e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106651:	89 50 0c             	mov    %edx,0xc(%eax)
c0106654:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106657:	8b 40 0c             	mov    0xc(%eax),%eax
c010665a:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c010665d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106660:	8b 00                	mov    (%eax),%eax
c0106662:	85 c0                	test   %eax,%eax
c0106664:	74 24                	je     c010668a <check_swap+0x198>
c0106666:	c7 44 24 0c 81 9f 10 	movl   $0xc0109f81,0xc(%esp)
c010666d:	c0 
c010666e:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106675:	c0 
c0106676:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c010667d:	00 
c010667e:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106685:	e8 4a a6 ff ff       	call   c0100cd4 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010668a:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106691:	00 
c0106692:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106699:	00 
c010669a:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01066a1:	e8 af 09 00 00       	call   c0107055 <vma_create>
c01066a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01066a9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01066ad:	75 24                	jne    c01066d3 <check_swap+0x1e1>
c01066af:	c7 44 24 0c 8f 9f 10 	movl   $0xc0109f8f,0xc(%esp)
c01066b6:	c0 
c01066b7:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01066be:	c0 
c01066bf:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01066c6:	00 
c01066c7:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01066ce:	e8 01 a6 ff ff       	call   c0100cd4 <__panic>

     insert_vma_struct(mm, vma);
c01066d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01066d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01066da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066dd:	89 04 24             	mov    %eax,(%esp)
c01066e0:	e8 00 0b 00 00       	call   c01071e5 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01066e5:	c7 04 24 9c 9f 10 c0 	movl   $0xc0109f9c,(%esp)
c01066ec:	e8 5a 9c ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c01066f1:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01066f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066fb:	8b 40 0c             	mov    0xc(%eax),%eax
c01066fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106705:	00 
c0106706:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010670d:	00 
c010670e:	89 04 24             	mov    %eax,(%esp)
c0106711:	e8 0d e6 ff ff       	call   c0104d23 <get_pte>
c0106716:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106719:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010671d:	75 24                	jne    c0106743 <check_swap+0x251>
c010671f:	c7 44 24 0c d0 9f 10 	movl   $0xc0109fd0,0xc(%esp)
c0106726:	c0 
c0106727:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010672e:	c0 
c010672f:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106736:	00 
c0106737:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010673e:	e8 91 a5 ff ff       	call   c0100cd4 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106743:	c7 04 24 e4 9f 10 c0 	movl   $0xc0109fe4,(%esp)
c010674a:	e8 fc 9b ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010674f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106756:	e9 a3 00 00 00       	jmp    c01067fe <check_swap+0x30c>
          check_rp[i] = alloc_page();
c010675b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106762:	e8 5a de ff ff       	call   c01045c1 <alloc_pages>
c0106767:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010676a:	89 04 95 e0 0a 12 c0 	mov    %eax,-0x3fedf520(,%edx,4)
          assert(check_rp[i] != NULL );
c0106771:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106774:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c010677b:	85 c0                	test   %eax,%eax
c010677d:	75 24                	jne    c01067a3 <check_swap+0x2b1>
c010677f:	c7 44 24 0c 08 a0 10 	movl   $0xc010a008,0xc(%esp)
c0106786:	c0 
c0106787:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010678e:	c0 
c010678f:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106796:	00 
c0106797:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010679e:	e8 31 a5 ff ff       	call   c0100cd4 <__panic>
          assert(!PageProperty(check_rp[i]));
c01067a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067a6:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01067ad:	83 c0 04             	add    $0x4,%eax
c01067b0:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01067b7:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067ba:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01067bd:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01067c0:	0f a3 10             	bt     %edx,(%eax)
c01067c3:	19 c0                	sbb    %eax,%eax
c01067c5:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c01067c8:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01067cc:	0f 95 c0             	setne  %al
c01067cf:	0f b6 c0             	movzbl %al,%eax
c01067d2:	85 c0                	test   %eax,%eax
c01067d4:	74 24                	je     c01067fa <check_swap+0x308>
c01067d6:	c7 44 24 0c 1c a0 10 	movl   $0xc010a01c,0xc(%esp)
c01067dd:	c0 
c01067de:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01067e5:	c0 
c01067e6:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01067ed:	00 
c01067ee:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01067f5:	e8 da a4 ff ff       	call   c0100cd4 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01067fa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01067fe:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106802:	0f 8e 53 ff ff ff    	jle    c010675b <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106808:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c010680d:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0106813:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106816:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106819:	c7 45 a8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106820:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106823:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106826:	89 50 04             	mov    %edx,0x4(%eax)
c0106829:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010682c:	8b 50 04             	mov    0x4(%eax),%edx
c010682f:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106832:	89 10                	mov    %edx,(%eax)
c0106834:	c7 45 a4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010683b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010683e:	8b 40 04             	mov    0x4(%eax),%eax
c0106841:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106844:	0f 94 c0             	sete   %al
c0106847:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010684a:	85 c0                	test   %eax,%eax
c010684c:	75 24                	jne    c0106872 <check_swap+0x380>
c010684e:	c7 44 24 0c 37 a0 10 	movl   $0xc010a037,0xc(%esp)
c0106855:	c0 
c0106856:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c010685d:	c0 
c010685e:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106865:	00 
c0106866:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c010686d:	e8 62 a4 ff ff       	call   c0100cd4 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106872:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0106877:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c010687a:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0106881:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106884:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010688b:	eb 1e                	jmp    c01068ab <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c010688d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106890:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c0106897:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010689e:	00 
c010689f:	89 04 24             	mov    %eax,(%esp)
c01068a2:	e8 85 dd ff ff       	call   c010462c <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068a7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068ab:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068af:	7e dc                	jle    c010688d <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01068b1:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01068b6:	83 f8 04             	cmp    $0x4,%eax
c01068b9:	74 24                	je     c01068df <check_swap+0x3ed>
c01068bb:	c7 44 24 0c 50 a0 10 	movl   $0xc010a050,0xc(%esp)
c01068c2:	c0 
c01068c3:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01068ca:	c0 
c01068cb:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01068d2:	00 
c01068d3:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01068da:	e8 f5 a3 ff ff       	call   c0100cd4 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01068df:	c7 04 24 74 a0 10 c0 	movl   $0xc010a074,(%esp)
c01068e6:	e8 60 9a ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01068eb:	c7 05 b8 0a 12 c0 00 	movl   $0x0,0xc0120ab8
c01068f2:	00 00 00 
     
     check_content_set();
c01068f5:	e8 28 fa ff ff       	call   c0106322 <check_content_set>
     assert( nr_free == 0);         
c01068fa:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01068ff:	85 c0                	test   %eax,%eax
c0106901:	74 24                	je     c0106927 <check_swap+0x435>
c0106903:	c7 44 24 0c 9b a0 10 	movl   $0xc010a09b,0xc(%esp)
c010690a:	c0 
c010690b:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106912:	c0 
c0106913:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010691a:	00 
c010691b:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106922:	e8 ad a3 ff ff       	call   c0100cd4 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106927:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010692e:	eb 26                	jmp    c0106956 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106930:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106933:	c7 04 85 00 0b 12 c0 	movl   $0xffffffff,-0x3fedf500(,%eax,4)
c010693a:	ff ff ff ff 
c010693e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106941:	8b 14 85 00 0b 12 c0 	mov    -0x3fedf500(,%eax,4),%edx
c0106948:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010694b:	89 14 85 40 0b 12 c0 	mov    %edx,-0x3fedf4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106952:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106956:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010695a:	7e d4                	jle    c0106930 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010695c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106963:	e9 eb 00 00 00       	jmp    c0106a53 <check_swap+0x561>
         check_ptep[i]=0;
c0106968:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010696b:	c7 04 85 94 0b 12 c0 	movl   $0x0,-0x3fedf46c(,%eax,4)
c0106972:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106976:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106979:	83 c0 01             	add    $0x1,%eax
c010697c:	c1 e0 0c             	shl    $0xc,%eax
c010697f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106986:	00 
c0106987:	89 44 24 04          	mov    %eax,0x4(%esp)
c010698b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010698e:	89 04 24             	mov    %eax,(%esp)
c0106991:	e8 8d e3 ff ff       	call   c0104d23 <get_pte>
c0106996:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106999:	89 04 95 94 0b 12 c0 	mov    %eax,-0x3fedf46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01069a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069a3:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c01069aa:	85 c0                	test   %eax,%eax
c01069ac:	75 24                	jne    c01069d2 <check_swap+0x4e0>
c01069ae:	c7 44 24 0c a8 a0 10 	movl   $0xc010a0a8,0xc(%esp)
c01069b5:	c0 
c01069b6:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c01069bd:	c0 
c01069be:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01069c5:	00 
c01069c6:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c01069cd:	e8 02 a3 ff ff       	call   c0100cd4 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01069d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069d5:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c01069dc:	8b 00                	mov    (%eax),%eax
c01069de:	89 04 24             	mov    %eax,(%esp)
c01069e1:	e8 9f f5 ff ff       	call   c0105f85 <pte2page>
c01069e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01069e9:	8b 14 95 e0 0a 12 c0 	mov    -0x3fedf520(,%edx,4),%edx
c01069f0:	39 d0                	cmp    %edx,%eax
c01069f2:	74 24                	je     c0106a18 <check_swap+0x526>
c01069f4:	c7 44 24 0c c0 a0 10 	movl   $0xc010a0c0,0xc(%esp)
c01069fb:	c0 
c01069fc:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106a03:	c0 
c0106a04:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106a0b:	00 
c0106a0c:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106a13:	e8 bc a2 ff ff       	call   c0100cd4 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1b:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106a22:	8b 00                	mov    (%eax),%eax
c0106a24:	83 e0 01             	and    $0x1,%eax
c0106a27:	85 c0                	test   %eax,%eax
c0106a29:	75 24                	jne    c0106a4f <check_swap+0x55d>
c0106a2b:	c7 44 24 0c e8 a0 10 	movl   $0xc010a0e8,0xc(%esp)
c0106a32:	c0 
c0106a33:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106a3a:	c0 
c0106a3b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106a42:	00 
c0106a43:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106a4a:	e8 85 a2 ff ff       	call   c0100cd4 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a4f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a53:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106a57:	0f 8e 0b ff ff ff    	jle    c0106968 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106a5d:	c7 04 24 04 a1 10 c0 	movl   $0xc010a104,(%esp)
c0106a64:	e8 e2 98 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106a69:	e8 6c fa ff ff       	call   c01064da <check_content_access>
c0106a6e:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106a71:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106a75:	74 24                	je     c0106a9b <check_swap+0x5a9>
c0106a77:	c7 44 24 0c 2a a1 10 	movl   $0xc010a12a,0xc(%esp)
c0106a7e:	c0 
c0106a7f:	c7 44 24 08 12 9e 10 	movl   $0xc0109e12,0x8(%esp)
c0106a86:	c0 
c0106a87:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106a8e:	00 
c0106a8f:	c7 04 24 ac 9d 10 c0 	movl   $0xc0109dac,(%esp)
c0106a96:	e8 39 a2 ff ff       	call   c0100cd4 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106aa2:	eb 1e                	jmp    c0106ac2 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106aa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106aa7:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c0106aae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106ab5:	00 
c0106ab6:	89 04 24             	mov    %eax,(%esp)
c0106ab9:	e8 6e db ff ff       	call   c010462c <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106abe:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ac2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106ac6:	7e dc                	jle    c0106aa4 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106acb:	89 04 24             	mov    %eax,(%esp)
c0106ace:	e8 42 08 00 00       	call   c0107315 <mm_destroy>
         
     nr_free = nr_free_store;
c0106ad3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106ad6:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
     free_list = free_list_store;
c0106adb:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106ade:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106ae1:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0106ae6:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4

     
     le = &free_list;
c0106aec:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106af3:	eb 1d                	jmp    c0106b12 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106af5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106af8:	83 e8 0c             	sub    $0xc,%eax
c0106afb:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106afe:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106b05:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106b08:	8b 40 08             	mov    0x8(%eax),%eax
c0106b0b:	29 c2                	sub    %eax,%edx
c0106b0d:	89 d0                	mov    %edx,%eax
c0106b0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b15:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106b18:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106b1b:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106b1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b21:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106b28:	75 cb                	jne    c0106af5 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b2d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b38:	c7 04 24 31 a1 10 c0 	movl   $0xc010a131,(%esp)
c0106b3f:	e8 07 98 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106b44:	c7 04 24 4b a1 10 c0 	movl   $0xc010a14b,(%esp)
c0106b4b:	e8 fb 97 ff ff       	call   c010034b <cprintf>
}
c0106b50:	83 c4 74             	add    $0x74,%esp
c0106b53:	5b                   	pop    %ebx
c0106b54:	5d                   	pop    %ebp
c0106b55:	c3                   	ret    

c0106b56 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106b56:	55                   	push   %ebp
c0106b57:	89 e5                	mov    %esp,%ebp
c0106b59:	83 ec 10             	sub    $0x10,%esp
c0106b5c:	c7 45 fc a4 0b 12 c0 	movl   $0xc0120ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106b63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b66:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106b69:	89 50 04             	mov    %edx,0x4(%eax)
c0106b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b6f:	8b 50 04             	mov    0x4(%eax),%edx
c0106b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106b75:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b7a:	c7 40 14 a4 0b 12 c0 	movl   $0xc0120ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106b86:	c9                   	leave  
c0106b87:	c3                   	ret    

c0106b88 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106b88:	55                   	push   %ebp
c0106b89:	89 e5                	mov    %esp,%ebp
c0106b8b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b91:	8b 40 14             	mov    0x14(%eax),%eax
c0106b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106b97:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b9a:	83 c0 14             	add    $0x14,%eax
c0106b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106ba4:	74 06                	je     c0106bac <_fifo_map_swappable+0x24>
c0106ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106baa:	75 24                	jne    c0106bd0 <_fifo_map_swappable+0x48>
c0106bac:	c7 44 24 0c 64 a1 10 	movl   $0xc010a164,0xc(%esp)
c0106bb3:	c0 
c0106bb4:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106bbb:	c0 
c0106bbc:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106bc3:	00 
c0106bc4:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106bcb:	e8 04 a1 ff ff       	call   c0100cd4 <__panic>
c0106bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106bd3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bd9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106be5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0106be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106beb:	8b 40 04             	mov    0x4(%eax),%eax
c0106bee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106bf1:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0106bf4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106bf7:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0106bfa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106bfd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c00:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c03:	89 10                	mov    %edx,(%eax)
c0106c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106c08:	8b 10                	mov    (%eax),%edx
c0106c0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106c0d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106c10:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c13:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106c16:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106c19:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106c1f:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2013011303*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add(head,entry);
    return 0;
c0106c21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c26:	c9                   	leave  
c0106c27:	c3                   	ret    

c0106c28 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106c28:	55                   	push   %ebp
c0106c29:	89 e5                	mov    %esp,%ebp
c0106c2b:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c31:	8b 40 14             	mov    0x14(%eax),%eax
c0106c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106c37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c3b:	75 24                	jne    c0106c61 <_fifo_swap_out_victim+0x39>
c0106c3d:	c7 44 24 0c ab a1 10 	movl   $0xc010a1ab,0xc(%esp)
c0106c44:	c0 
c0106c45:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106c4c:	c0 
c0106c4d:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106c54:	00 
c0106c55:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106c5c:	e8 73 a0 ff ff       	call   c0100cd4 <__panic>
     assert(in_tick==0);
c0106c61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106c65:	74 24                	je     c0106c8b <_fifo_swap_out_victim+0x63>
c0106c67:	c7 44 24 0c b8 a1 10 	movl   $0xc010a1b8,0xc(%esp)
c0106c6e:	c0 
c0106c6f:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106c76:	c0 
c0106c77:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106c7e:	00 
c0106c7f:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106c86:	e8 49 a0 ff ff       	call   c0100cd4 <__panic>
c0106c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c8e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0106c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c94:	8b 00                	mov    (%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2013011303*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *entry = list_prev(head);
c0106c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(entry, pra_page_link);
c0106c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c9c:	83 e8 14             	sub    $0x14,%eax
c0106c9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106ca8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cab:	8b 40 04             	mov    0x4(%eax),%eax
c0106cae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cb1:	8b 12                	mov    (%edx),%edx
c0106cb3:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0106cb6:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106cb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106cbf:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106cc2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106cc8:	89 10                	mov    %edx,(%eax)
     list_del(entry);
     *ptr_page = page;
c0106cca:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ccd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106cd0:	89 10                	mov    %edx,(%eax)
     return 0;
c0106cd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106cd7:	c9                   	leave  
c0106cd8:	c3                   	ret    

c0106cd9 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106cd9:	55                   	push   %ebp
c0106cda:	89 e5                	mov    %esp,%ebp
c0106cdc:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106cdf:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106ce6:	e8 60 96 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106ceb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106cf0:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106cf3:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106cf8:	83 f8 04             	cmp    $0x4,%eax
c0106cfb:	74 24                	je     c0106d21 <_fifo_check_swap+0x48>
c0106cfd:	c7 44 24 0c ea a1 10 	movl   $0xc010a1ea,0xc(%esp)
c0106d04:	c0 
c0106d05:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106d0c:	c0 
c0106d0d:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c0106d14:	00 
c0106d15:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106d1c:	e8 b3 9f ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106d21:	c7 04 24 fc a1 10 c0 	movl   $0xc010a1fc,(%esp)
c0106d28:	e8 1e 96 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106d2d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106d32:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106d35:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106d3a:	83 f8 04             	cmp    $0x4,%eax
c0106d3d:	74 24                	je     c0106d63 <_fifo_check_swap+0x8a>
c0106d3f:	c7 44 24 0c ea a1 10 	movl   $0xc010a1ea,0xc(%esp)
c0106d46:	c0 
c0106d47:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106d4e:	c0 
c0106d4f:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0106d56:	00 
c0106d57:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106d5e:	e8 71 9f ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106d63:	c7 04 24 24 a2 10 c0 	movl   $0xc010a224,(%esp)
c0106d6a:	e8 dc 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106d6f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106d74:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106d77:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106d7c:	83 f8 04             	cmp    $0x4,%eax
c0106d7f:	74 24                	je     c0106da5 <_fifo_check_swap+0xcc>
c0106d81:	c7 44 24 0c ea a1 10 	movl   $0xc010a1ea,0xc(%esp)
c0106d88:	c0 
c0106d89:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106d90:	c0 
c0106d91:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0106d98:	00 
c0106d99:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106da0:	e8 2f 9f ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106da5:	c7 04 24 4c a2 10 c0 	movl   $0xc010a24c,(%esp)
c0106dac:	e8 9a 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106db1:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106db6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106db9:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106dbe:	83 f8 04             	cmp    $0x4,%eax
c0106dc1:	74 24                	je     c0106de7 <_fifo_check_swap+0x10e>
c0106dc3:	c7 44 24 0c ea a1 10 	movl   $0xc010a1ea,0xc(%esp)
c0106dca:	c0 
c0106dcb:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106dd2:	c0 
c0106dd3:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106dda:	00 
c0106ddb:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106de2:	e8 ed 9e ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106de7:	c7 04 24 74 a2 10 c0 	movl   $0xc010a274,(%esp)
c0106dee:	e8 58 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106df3:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106df8:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106dfb:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e00:	83 f8 05             	cmp    $0x5,%eax
c0106e03:	74 24                	je     c0106e29 <_fifo_check_swap+0x150>
c0106e05:	c7 44 24 0c 9a a2 10 	movl   $0xc010a29a,0xc(%esp)
c0106e0c:	c0 
c0106e0d:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106e14:	c0 
c0106e15:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106e1c:	00 
c0106e1d:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106e24:	e8 ab 9e ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106e29:	c7 04 24 4c a2 10 c0 	movl   $0xc010a24c,(%esp)
c0106e30:	e8 16 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e35:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e3a:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106e3d:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e42:	83 f8 05             	cmp    $0x5,%eax
c0106e45:	74 24                	je     c0106e6b <_fifo_check_swap+0x192>
c0106e47:	c7 44 24 0c 9a a2 10 	movl   $0xc010a29a,0xc(%esp)
c0106e4e:	c0 
c0106e4f:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106e56:	c0 
c0106e57:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0106e5e:	00 
c0106e5f:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106e66:	e8 69 9e ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106e6b:	c7 04 24 fc a1 10 c0 	movl   $0xc010a1fc,(%esp)
c0106e72:	e8 d4 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106e77:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106e7c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106e7f:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e84:	83 f8 06             	cmp    $0x6,%eax
c0106e87:	74 24                	je     c0106ead <_fifo_check_swap+0x1d4>
c0106e89:	c7 44 24 0c a9 a2 10 	movl   $0xc010a2a9,0xc(%esp)
c0106e90:	c0 
c0106e91:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106e98:	c0 
c0106e99:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0106ea0:	00 
c0106ea1:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106ea8:	e8 27 9e ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ead:	c7 04 24 4c a2 10 c0 	movl   $0xc010a24c,(%esp)
c0106eb4:	e8 92 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106eb9:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ebe:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106ec1:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106ec6:	83 f8 07             	cmp    $0x7,%eax
c0106ec9:	74 24                	je     c0106eef <_fifo_check_swap+0x216>
c0106ecb:	c7 44 24 0c b8 a2 10 	movl   $0xc010a2b8,0xc(%esp)
c0106ed2:	c0 
c0106ed3:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106eda:	c0 
c0106edb:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106ee2:	00 
c0106ee3:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106eea:	e8 e5 9d ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106eef:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106ef6:	e8 50 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106efb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106f00:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106f03:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f08:	83 f8 08             	cmp    $0x8,%eax
c0106f0b:	74 24                	je     c0106f31 <_fifo_check_swap+0x258>
c0106f0d:	c7 44 24 0c c7 a2 10 	movl   $0xc010a2c7,0xc(%esp)
c0106f14:	c0 
c0106f15:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106f1c:	c0 
c0106f1d:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0106f24:	00 
c0106f25:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106f2c:	e8 a3 9d ff ff       	call   c0100cd4 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106f31:	c7 04 24 24 a2 10 c0 	movl   $0xc010a224,(%esp)
c0106f38:	e8 0e 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f3d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106f42:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106f45:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f4a:	83 f8 09             	cmp    $0x9,%eax
c0106f4d:	74 24                	je     c0106f73 <_fifo_check_swap+0x29a>
c0106f4f:	c7 44 24 0c d6 a2 10 	movl   $0xc010a2d6,0xc(%esp)
c0106f56:	c0 
c0106f57:	c7 44 24 08 82 a1 10 	movl   $0xc010a182,0x8(%esp)
c0106f5e:	c0 
c0106f5f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106f66:	00 
c0106f67:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c0106f6e:	e8 61 9d ff ff       	call   c0100cd4 <__panic>
    return 0;
c0106f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f78:	c9                   	leave  
c0106f79:	c3                   	ret    

c0106f7a <_fifo_init>:


static int
_fifo_init(void)
{
c0106f7a:	55                   	push   %ebp
c0106f7b:	89 e5                	mov    %esp,%ebp
    return 0;
c0106f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f82:	5d                   	pop    %ebp
c0106f83:	c3                   	ret    

c0106f84 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106f84:	55                   	push   %ebp
c0106f85:	89 e5                	mov    %esp,%ebp
    return 0;
c0106f87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f8c:	5d                   	pop    %ebp
c0106f8d:	c3                   	ret    

c0106f8e <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0106f8e:	55                   	push   %ebp
c0106f8f:	89 e5                	mov    %esp,%ebp
c0106f91:	b8 00 00 00 00       	mov    $0x0,%eax
c0106f96:	5d                   	pop    %ebp
c0106f97:	c3                   	ret    

c0106f98 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106f98:	55                   	push   %ebp
c0106f99:	89 e5                	mov    %esp,%ebp
c0106f9b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106f9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fa1:	c1 e8 0c             	shr    $0xc,%eax
c0106fa4:	89 c2                	mov    %eax,%edx
c0106fa6:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0106fab:	39 c2                	cmp    %eax,%edx
c0106fad:	72 1c                	jb     c0106fcb <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106faf:	c7 44 24 08 f8 a2 10 	movl   $0xc010a2f8,0x8(%esp)
c0106fb6:	c0 
c0106fb7:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106fbe:	00 
c0106fbf:	c7 04 24 17 a3 10 c0 	movl   $0xc010a317,(%esp)
c0106fc6:	e8 09 9d ff ff       	call   c0100cd4 <__panic>
    }
    return &pages[PPN(pa)];
c0106fcb:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0106fd0:	8b 55 08             	mov    0x8(%ebp),%edx
c0106fd3:	c1 ea 0c             	shr    $0xc,%edx
c0106fd6:	c1 e2 05             	shl    $0x5,%edx
c0106fd9:	01 d0                	add    %edx,%eax
}
c0106fdb:	c9                   	leave  
c0106fdc:	c3                   	ret    

c0106fdd <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0106fdd:	55                   	push   %ebp
c0106fde:	89 e5                	mov    %esp,%ebp
c0106fe0:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0106fe3:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0106fea:	e8 17 ee ff ff       	call   c0105e06 <kmalloc>
c0106fef:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0106ff2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106ff6:	74 58                	je     c0107050 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c0106ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106ffe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107001:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107004:	89 50 04             	mov    %edx,0x4(%eax)
c0107007:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010700a:	8b 50 04             	mov    0x4(%eax),%edx
c010700d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107010:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107012:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107015:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c010701c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010701f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107026:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107029:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107030:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0107035:	85 c0                	test   %eax,%eax
c0107037:	74 0d                	je     c0107046 <mm_create+0x69>
c0107039:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010703c:	89 04 24             	mov    %eax,(%esp)
c010703f:	e8 0f f0 ff ff       	call   c0106053 <swap_init_mm>
c0107044:	eb 0a                	jmp    c0107050 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107046:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107049:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107050:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107053:	c9                   	leave  
c0107054:	c3                   	ret    

c0107055 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107055:	55                   	push   %ebp
c0107056:	89 e5                	mov    %esp,%ebp
c0107058:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010705b:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107062:	e8 9f ed ff ff       	call   c0105e06 <kmalloc>
c0107067:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010706a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010706e:	74 1b                	je     c010708b <vma_create+0x36>
        vma->vm_start = vm_start;
c0107070:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107073:	8b 55 08             	mov    0x8(%ebp),%edx
c0107076:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107079:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010707c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010707f:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107082:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107085:	8b 55 10             	mov    0x10(%ebp),%edx
c0107088:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010708b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010708e:	c9                   	leave  
c010708f:	c3                   	ret    

c0107090 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107090:	55                   	push   %ebp
c0107091:	89 e5                	mov    %esp,%ebp
c0107093:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107096:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010709d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01070a1:	0f 84 95 00 00 00    	je     c010713c <find_vma+0xac>
        vma = mm->mmap_cache;
c01070a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01070aa:	8b 40 08             	mov    0x8(%eax),%eax
c01070ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01070b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01070b4:	74 16                	je     c01070cc <find_vma+0x3c>
c01070b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070b9:	8b 40 04             	mov    0x4(%eax),%eax
c01070bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070bf:	77 0b                	ja     c01070cc <find_vma+0x3c>
c01070c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070c4:	8b 40 08             	mov    0x8(%eax),%eax
c01070c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070ca:	77 61                	ja     c010712d <find_vma+0x9d>
                bool found = 0;
c01070cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01070d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01070d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01070d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01070df:	eb 28                	jmp    c0107109 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01070e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070e4:	83 e8 10             	sub    $0x10,%eax
c01070e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01070ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070ed:	8b 40 04             	mov    0x4(%eax),%eax
c01070f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070f3:	77 14                	ja     c0107109 <find_vma+0x79>
c01070f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070f8:	8b 40 08             	mov    0x8(%eax),%eax
c01070fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070fe:	76 09                	jbe    c0107109 <find_vma+0x79>
                        found = 1;
c0107100:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107107:	eb 17                	jmp    c0107120 <find_vma+0x90>
c0107109:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010710c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010710f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107112:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107115:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107118:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010711b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010711e:	75 c1                	jne    c01070e1 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107120:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107124:	75 07                	jne    c010712d <find_vma+0x9d>
                    vma = NULL;
c0107126:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c010712d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107131:	74 09                	je     c010713c <find_vma+0xac>
            mm->mmap_cache = vma;
c0107133:	8b 45 08             	mov    0x8(%ebp),%eax
c0107136:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107139:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c010713c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010713f:	c9                   	leave  
c0107140:	c3                   	ret    

c0107141 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107141:	55                   	push   %ebp
c0107142:	89 e5                	mov    %esp,%ebp
c0107144:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107147:	8b 45 08             	mov    0x8(%ebp),%eax
c010714a:	8b 50 04             	mov    0x4(%eax),%edx
c010714d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107150:	8b 40 08             	mov    0x8(%eax),%eax
c0107153:	39 c2                	cmp    %eax,%edx
c0107155:	72 24                	jb     c010717b <check_vma_overlap+0x3a>
c0107157:	c7 44 24 0c 25 a3 10 	movl   $0xc010a325,0xc(%esp)
c010715e:	c0 
c010715f:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107166:	c0 
c0107167:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010716e:	00 
c010716f:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107176:	e8 59 9b ff ff       	call   c0100cd4 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010717b:	8b 45 08             	mov    0x8(%ebp),%eax
c010717e:	8b 50 08             	mov    0x8(%eax),%edx
c0107181:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107184:	8b 40 04             	mov    0x4(%eax),%eax
c0107187:	39 c2                	cmp    %eax,%edx
c0107189:	76 24                	jbe    c01071af <check_vma_overlap+0x6e>
c010718b:	c7 44 24 0c 68 a3 10 	movl   $0xc010a368,0xc(%esp)
c0107192:	c0 
c0107193:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c010719a:	c0 
c010719b:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01071a2:	00 
c01071a3:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01071aa:	e8 25 9b ff ff       	call   c0100cd4 <__panic>
    assert(next->vm_start < next->vm_end);
c01071af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071b2:	8b 50 04             	mov    0x4(%eax),%edx
c01071b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071b8:	8b 40 08             	mov    0x8(%eax),%eax
c01071bb:	39 c2                	cmp    %eax,%edx
c01071bd:	72 24                	jb     c01071e3 <check_vma_overlap+0xa2>
c01071bf:	c7 44 24 0c 87 a3 10 	movl   $0xc010a387,0xc(%esp)
c01071c6:	c0 
c01071c7:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01071ce:	c0 
c01071cf:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01071d6:	00 
c01071d7:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01071de:	e8 f1 9a ff ff       	call   c0100cd4 <__panic>
}
c01071e3:	c9                   	leave  
c01071e4:	c3                   	ret    

c01071e5 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01071e5:	55                   	push   %ebp
c01071e6:	89 e5                	mov    %esp,%ebp
c01071e8:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01071eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071ee:	8b 50 04             	mov    0x4(%eax),%edx
c01071f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071f4:	8b 40 08             	mov    0x8(%eax),%eax
c01071f7:	39 c2                	cmp    %eax,%edx
c01071f9:	72 24                	jb     c010721f <insert_vma_struct+0x3a>
c01071fb:	c7 44 24 0c a5 a3 10 	movl   $0xc010a3a5,0xc(%esp)
c0107202:	c0 
c0107203:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c010720a:	c0 
c010720b:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107212:	00 
c0107213:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c010721a:	e8 b5 9a ff ff       	call   c0100cd4 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010721f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107222:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107225:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107228:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010722b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010722e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107231:	eb 21                	jmp    c0107254 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107233:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107236:	83 e8 10             	sub    $0x10,%eax
c0107239:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010723c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010723f:	8b 50 04             	mov    0x4(%eax),%edx
c0107242:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107245:	8b 40 04             	mov    0x4(%eax),%eax
c0107248:	39 c2                	cmp    %eax,%edx
c010724a:	76 02                	jbe    c010724e <insert_vma_struct+0x69>
                break;
c010724c:	eb 1d                	jmp    c010726b <insert_vma_struct+0x86>
            }
            le_prev = le;
c010724e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107251:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107254:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107257:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010725a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010725d:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107260:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107263:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107266:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107269:	75 c8                	jne    c0107233 <insert_vma_struct+0x4e>
c010726b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010726e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107271:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107274:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107277:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c010727a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010727d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107280:	74 15                	je     c0107297 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107282:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107285:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107288:	8b 45 0c             	mov    0xc(%ebp),%eax
c010728b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010728f:	89 14 24             	mov    %edx,(%esp)
c0107292:	e8 aa fe ff ff       	call   c0107141 <check_vma_overlap>
    }
    if (le_next != list) {
c0107297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010729a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010729d:	74 15                	je     c01072b4 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010729f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072a2:	83 e8 10             	sub    $0x10,%eax
c01072a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072ac:	89 04 24             	mov    %eax,(%esp)
c01072af:	e8 8d fe ff ff       	call   c0107141 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01072b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072b7:	8b 55 08             	mov    0x8(%ebp),%edx
c01072ba:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01072bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072bf:	8d 50 10             	lea    0x10(%eax),%edx
c01072c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01072c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01072cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01072ce:	8b 40 04             	mov    0x4(%eax),%eax
c01072d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01072d4:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01072d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01072da:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01072dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01072e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01072e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01072e6:	89 10                	mov    %edx,(%eax)
c01072e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01072eb:	8b 10                	mov    (%eax),%edx
c01072ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01072f0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01072f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01072f6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01072f9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01072fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01072ff:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107302:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107304:	8b 45 08             	mov    0x8(%ebp),%eax
c0107307:	8b 40 10             	mov    0x10(%eax),%eax
c010730a:	8d 50 01             	lea    0x1(%eax),%edx
c010730d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107310:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107313:	c9                   	leave  
c0107314:	c3                   	ret    

c0107315 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107315:	55                   	push   %ebp
c0107316:	89 e5                	mov    %esp,%ebp
c0107318:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c010731b:	8b 45 08             	mov    0x8(%ebp),%eax
c010731e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107321:	eb 3e                	jmp    c0107361 <mm_destroy+0x4c>
c0107323:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107326:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107329:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010732c:	8b 40 04             	mov    0x4(%eax),%eax
c010732f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107332:	8b 12                	mov    (%edx),%edx
c0107334:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107337:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010733a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010733d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107340:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107346:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107349:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c010734b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010734e:	83 e8 10             	sub    $0x10,%eax
c0107351:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107358:	00 
c0107359:	89 04 24             	mov    %eax,(%esp)
c010735c:	e8 45 eb ff ff       	call   c0105ea6 <kfree>
c0107361:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107364:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107367:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010736a:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010736d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107370:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107373:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107376:	75 ab                	jne    c0107323 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0107378:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010737f:	00 
c0107380:	8b 45 08             	mov    0x8(%ebp),%eax
c0107383:	89 04 24             	mov    %eax,(%esp)
c0107386:	e8 1b eb ff ff       	call   c0105ea6 <kfree>
    mm=NULL;
c010738b:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107392:	c9                   	leave  
c0107393:	c3                   	ret    

c0107394 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107394:	55                   	push   %ebp
c0107395:	89 e5                	mov    %esp,%ebp
c0107397:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010739a:	e8 02 00 00 00       	call   c01073a1 <check_vmm>
}
c010739f:	c9                   	leave  
c01073a0:	c3                   	ret    

c01073a1 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01073a1:	55                   	push   %ebp
c01073a2:	89 e5                	mov    %esp,%ebp
c01073a4:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01073a7:	e8 b2 d2 ff ff       	call   c010465e <nr_free_pages>
c01073ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01073af:	e8 41 00 00 00       	call   c01073f5 <check_vma_struct>
    check_pgfault();
c01073b4:	e8 03 05 00 00       	call   c01078bc <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01073b9:	e8 a0 d2 ff ff       	call   c010465e <nr_free_pages>
c01073be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01073c1:	74 24                	je     c01073e7 <check_vmm+0x46>
c01073c3:	c7 44 24 0c c4 a3 10 	movl   $0xc010a3c4,0xc(%esp)
c01073ca:	c0 
c01073cb:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01073d2:	c0 
c01073d3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01073da:	00 
c01073db:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01073e2:	e8 ed 98 ff ff       	call   c0100cd4 <__panic>

    cprintf("check_vmm() succeeded.\n");
c01073e7:	c7 04 24 eb a3 10 c0 	movl   $0xc010a3eb,(%esp)
c01073ee:	e8 58 8f ff ff       	call   c010034b <cprintf>
}
c01073f3:	c9                   	leave  
c01073f4:	c3                   	ret    

c01073f5 <check_vma_struct>:

static void
check_vma_struct(void) {
c01073f5:	55                   	push   %ebp
c01073f6:	89 e5                	mov    %esp,%ebp
c01073f8:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01073fb:	e8 5e d2 ff ff       	call   c010465e <nr_free_pages>
c0107400:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107403:	e8 d5 fb ff ff       	call   c0106fdd <mm_create>
c0107408:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c010740b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010740f:	75 24                	jne    c0107435 <check_vma_struct+0x40>
c0107411:	c7 44 24 0c 03 a4 10 	movl   $0xc010a403,0xc(%esp)
c0107418:	c0 
c0107419:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107420:	c0 
c0107421:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107428:	00 
c0107429:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107430:	e8 9f 98 ff ff       	call   c0100cd4 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107435:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010743c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010743f:	89 d0                	mov    %edx,%eax
c0107441:	c1 e0 02             	shl    $0x2,%eax
c0107444:	01 d0                	add    %edx,%eax
c0107446:	01 c0                	add    %eax,%eax
c0107448:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010744b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010744e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107451:	eb 70                	jmp    c01074c3 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107453:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107456:	89 d0                	mov    %edx,%eax
c0107458:	c1 e0 02             	shl    $0x2,%eax
c010745b:	01 d0                	add    %edx,%eax
c010745d:	83 c0 02             	add    $0x2,%eax
c0107460:	89 c1                	mov    %eax,%ecx
c0107462:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107465:	89 d0                	mov    %edx,%eax
c0107467:	c1 e0 02             	shl    $0x2,%eax
c010746a:	01 d0                	add    %edx,%eax
c010746c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107473:	00 
c0107474:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107478:	89 04 24             	mov    %eax,(%esp)
c010747b:	e8 d5 fb ff ff       	call   c0107055 <vma_create>
c0107480:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107483:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107487:	75 24                	jne    c01074ad <check_vma_struct+0xb8>
c0107489:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0107490:	c0 
c0107491:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107498:	c0 
c0107499:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01074a0:	00 
c01074a1:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01074a8:	e8 27 98 ff ff       	call   c0100cd4 <__panic>
        insert_vma_struct(mm, vma);
c01074ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074b7:	89 04 24             	mov    %eax,(%esp)
c01074ba:	e8 26 fd ff ff       	call   c01071e5 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01074bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01074c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074c7:	7f 8a                	jg     c0107453 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01074c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074cc:	83 c0 01             	add    $0x1,%eax
c01074cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01074d2:	eb 70                	jmp    c0107544 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01074d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074d7:	89 d0                	mov    %edx,%eax
c01074d9:	c1 e0 02             	shl    $0x2,%eax
c01074dc:	01 d0                	add    %edx,%eax
c01074de:	83 c0 02             	add    $0x2,%eax
c01074e1:	89 c1                	mov    %eax,%ecx
c01074e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01074e6:	89 d0                	mov    %edx,%eax
c01074e8:	c1 e0 02             	shl    $0x2,%eax
c01074eb:	01 d0                	add    %edx,%eax
c01074ed:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074f4:	00 
c01074f5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01074f9:	89 04 24             	mov    %eax,(%esp)
c01074fc:	e8 54 fb ff ff       	call   c0107055 <vma_create>
c0107501:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107504:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107508:	75 24                	jne    c010752e <check_vma_struct+0x139>
c010750a:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0107511:	c0 
c0107512:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107519:	c0 
c010751a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107521:	00 
c0107522:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107529:	e8 a6 97 ff ff       	call   c0100cd4 <__panic>
        insert_vma_struct(mm, vma);
c010752e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107531:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107535:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107538:	89 04 24             	mov    %eax,(%esp)
c010753b:	e8 a5 fc ff ff       	call   c01071e5 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107540:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107544:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107547:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010754a:	7e 88                	jle    c01074d4 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010754c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010754f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107552:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107555:	8b 40 04             	mov    0x4(%eax),%eax
c0107558:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010755b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107562:	e9 97 00 00 00       	jmp    c01075fe <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107567:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010756a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010756d:	75 24                	jne    c0107593 <check_vma_struct+0x19e>
c010756f:	c7 44 24 0c 1a a4 10 	movl   $0xc010a41a,0xc(%esp)
c0107576:	c0 
c0107577:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c010757e:	c0 
c010757f:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107586:	00 
c0107587:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c010758e:	e8 41 97 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107593:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107596:	83 e8 10             	sub    $0x10,%eax
c0107599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010759c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010759f:	8b 48 04             	mov    0x4(%eax),%ecx
c01075a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075a5:	89 d0                	mov    %edx,%eax
c01075a7:	c1 e0 02             	shl    $0x2,%eax
c01075aa:	01 d0                	add    %edx,%eax
c01075ac:	39 c1                	cmp    %eax,%ecx
c01075ae:	75 17                	jne    c01075c7 <check_vma_struct+0x1d2>
c01075b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01075b3:	8b 48 08             	mov    0x8(%eax),%ecx
c01075b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075b9:	89 d0                	mov    %edx,%eax
c01075bb:	c1 e0 02             	shl    $0x2,%eax
c01075be:	01 d0                	add    %edx,%eax
c01075c0:	83 c0 02             	add    $0x2,%eax
c01075c3:	39 c1                	cmp    %eax,%ecx
c01075c5:	74 24                	je     c01075eb <check_vma_struct+0x1f6>
c01075c7:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c01075ce:	c0 
c01075cf:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01075d6:	c0 
c01075d7:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01075de:	00 
c01075df:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01075e6:	e8 e9 96 ff ff       	call   c0100cd4 <__panic>
c01075eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01075f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01075f4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01075f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01075fa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01075fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107601:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107604:	0f 8e 5d ff ff ff    	jle    c0107567 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010760a:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107611:	e9 cd 01 00 00       	jmp    c01077e3 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107616:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010761d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107620:	89 04 24             	mov    %eax,(%esp)
c0107623:	e8 68 fa ff ff       	call   c0107090 <find_vma>
c0107628:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c010762b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010762f:	75 24                	jne    c0107655 <check_vma_struct+0x260>
c0107631:	c7 44 24 0c 69 a4 10 	movl   $0xc010a469,0xc(%esp)
c0107638:	c0 
c0107639:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107640:	c0 
c0107641:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0107648:	00 
c0107649:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107650:	e8 7f 96 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107658:	83 c0 01             	add    $0x1,%eax
c010765b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010765f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107662:	89 04 24             	mov    %eax,(%esp)
c0107665:	e8 26 fa ff ff       	call   c0107090 <find_vma>
c010766a:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010766d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107671:	75 24                	jne    c0107697 <check_vma_struct+0x2a2>
c0107673:	c7 44 24 0c 76 a4 10 	movl   $0xc010a476,0xc(%esp)
c010767a:	c0 
c010767b:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107682:	c0 
c0107683:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010768a:	00 
c010768b:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107692:	e8 3d 96 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107697:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010769a:	83 c0 02             	add    $0x2,%eax
c010769d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076a4:	89 04 24             	mov    %eax,(%esp)
c01076a7:	e8 e4 f9 ff ff       	call   c0107090 <find_vma>
c01076ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c01076af:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01076b3:	74 24                	je     c01076d9 <check_vma_struct+0x2e4>
c01076b5:	c7 44 24 0c 83 a4 10 	movl   $0xc010a483,0xc(%esp)
c01076bc:	c0 
c01076bd:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01076c4:	c0 
c01076c5:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01076cc:	00 
c01076cd:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01076d4:	e8 fb 95 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01076d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076dc:	83 c0 03             	add    $0x3,%eax
c01076df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076e6:	89 04 24             	mov    %eax,(%esp)
c01076e9:	e8 a2 f9 ff ff       	call   c0107090 <find_vma>
c01076ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01076f1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01076f5:	74 24                	je     c010771b <check_vma_struct+0x326>
c01076f7:	c7 44 24 0c 90 a4 10 	movl   $0xc010a490,0xc(%esp)
c01076fe:	c0 
c01076ff:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107706:	c0 
c0107707:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c010770e:	00 
c010770f:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107716:	e8 b9 95 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c010771b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010771e:	83 c0 04             	add    $0x4,%eax
c0107721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107725:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107728:	89 04 24             	mov    %eax,(%esp)
c010772b:	e8 60 f9 ff ff       	call   c0107090 <find_vma>
c0107730:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107733:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107737:	74 24                	je     c010775d <check_vma_struct+0x368>
c0107739:	c7 44 24 0c 9d a4 10 	movl   $0xc010a49d,0xc(%esp)
c0107740:	c0 
c0107741:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107748:	c0 
c0107749:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107750:	00 
c0107751:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107758:	e8 77 95 ff ff       	call   c0100cd4 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c010775d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107760:	8b 50 04             	mov    0x4(%eax),%edx
c0107763:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107766:	39 c2                	cmp    %eax,%edx
c0107768:	75 10                	jne    c010777a <check_vma_struct+0x385>
c010776a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010776d:	8b 50 08             	mov    0x8(%eax),%edx
c0107770:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107773:	83 c0 02             	add    $0x2,%eax
c0107776:	39 c2                	cmp    %eax,%edx
c0107778:	74 24                	je     c010779e <check_vma_struct+0x3a9>
c010777a:	c7 44 24 0c ac a4 10 	movl   $0xc010a4ac,0xc(%esp)
c0107781:	c0 
c0107782:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107789:	c0 
c010778a:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107791:	00 
c0107792:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107799:	e8 36 95 ff ff       	call   c0100cd4 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010779e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01077a1:	8b 50 04             	mov    0x4(%eax),%edx
c01077a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077a7:	39 c2                	cmp    %eax,%edx
c01077a9:	75 10                	jne    c01077bb <check_vma_struct+0x3c6>
c01077ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01077ae:	8b 50 08             	mov    0x8(%eax),%edx
c01077b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077b4:	83 c0 02             	add    $0x2,%eax
c01077b7:	39 c2                	cmp    %eax,%edx
c01077b9:	74 24                	je     c01077df <check_vma_struct+0x3ea>
c01077bb:	c7 44 24 0c dc a4 10 	movl   $0xc010a4dc,0xc(%esp)
c01077c2:	c0 
c01077c3:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01077ca:	c0 
c01077cb:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01077d2:	00 
c01077d3:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01077da:	e8 f5 94 ff ff       	call   c0100cd4 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01077df:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01077e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01077e6:	89 d0                	mov    %edx,%eax
c01077e8:	c1 e0 02             	shl    $0x2,%eax
c01077eb:	01 d0                	add    %edx,%eax
c01077ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01077f0:	0f 8d 20 fe ff ff    	jge    c0107616 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01077f6:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01077fd:	eb 70                	jmp    c010786f <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01077ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107802:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107806:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107809:	89 04 24             	mov    %eax,(%esp)
c010780c:	e8 7f f8 ff ff       	call   c0107090 <find_vma>
c0107811:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107814:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107818:	74 27                	je     c0107841 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010781a:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010781d:	8b 50 08             	mov    0x8(%eax),%edx
c0107820:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107823:	8b 40 04             	mov    0x4(%eax),%eax
c0107826:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010782a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010782e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107831:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107835:	c7 04 24 0c a5 10 c0 	movl   $0xc010a50c,(%esp)
c010783c:	e8 0a 8b ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107841:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107845:	74 24                	je     c010786b <check_vma_struct+0x476>
c0107847:	c7 44 24 0c 31 a5 10 	movl   $0xc010a531,0xc(%esp)
c010784e:	c0 
c010784f:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107856:	c0 
c0107857:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c010785e:	00 
c010785f:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107866:	e8 69 94 ff ff       	call   c0100cd4 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010786b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010786f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107873:	79 8a                	jns    c01077ff <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107875:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107878:	89 04 24             	mov    %eax,(%esp)
c010787b:	e8 95 fa ff ff       	call   c0107315 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107880:	e8 d9 cd ff ff       	call   c010465e <nr_free_pages>
c0107885:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107888:	74 24                	je     c01078ae <check_vma_struct+0x4b9>
c010788a:	c7 44 24 0c c4 a3 10 	movl   $0xc010a3c4,0xc(%esp)
c0107891:	c0 
c0107892:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107899:	c0 
c010789a:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01078a1:	00 
c01078a2:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01078a9:	e8 26 94 ff ff       	call   c0100cd4 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c01078ae:	c7 04 24 48 a5 10 c0 	movl   $0xc010a548,(%esp)
c01078b5:	e8 91 8a ff ff       	call   c010034b <cprintf>
}
c01078ba:	c9                   	leave  
c01078bb:	c3                   	ret    

c01078bc <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01078bc:	55                   	push   %ebp
c01078bd:	89 e5                	mov    %esp,%ebp
c01078bf:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01078c2:	e8 97 cd ff ff       	call   c010465e <nr_free_pages>
c01078c7:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c01078ca:	e8 0e f7 ff ff       	call   c0106fdd <mm_create>
c01078cf:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac
    assert(check_mm_struct != NULL);
c01078d4:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c01078d9:	85 c0                	test   %eax,%eax
c01078db:	75 24                	jne    c0107901 <check_pgfault+0x45>
c01078dd:	c7 44 24 0c 67 a5 10 	movl   $0xc010a567,0xc(%esp)
c01078e4:	c0 
c01078e5:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01078ec:	c0 
c01078ed:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01078f4:	00 
c01078f5:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01078fc:	e8 d3 93 ff ff       	call   c0100cd4 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107901:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0107906:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107909:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c010790f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107912:	89 50 0c             	mov    %edx,0xc(%eax)
c0107915:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107918:	8b 40 0c             	mov    0xc(%eax),%eax
c010791b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c010791e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107921:	8b 00                	mov    (%eax),%eax
c0107923:	85 c0                	test   %eax,%eax
c0107925:	74 24                	je     c010794b <check_pgfault+0x8f>
c0107927:	c7 44 24 0c 7f a5 10 	movl   $0xc010a57f,0xc(%esp)
c010792e:	c0 
c010792f:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107936:	c0 
c0107937:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010793e:	00 
c010793f:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107946:	e8 89 93 ff ff       	call   c0100cd4 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c010794b:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107952:	00 
c0107953:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c010795a:	00 
c010795b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107962:	e8 ee f6 ff ff       	call   c0107055 <vma_create>
c0107967:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c010796a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010796e:	75 24                	jne    c0107994 <check_pgfault+0xd8>
c0107970:	c7 44 24 0c 0e a4 10 	movl   $0xc010a40e,0xc(%esp)
c0107977:	c0 
c0107978:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c010797f:	c0 
c0107980:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107987:	00 
c0107988:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c010798f:	e8 40 93 ff ff       	call   c0100cd4 <__panic>

    insert_vma_struct(mm, vma);
c0107994:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010799b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010799e:	89 04 24             	mov    %eax,(%esp)
c01079a1:	e8 3f f8 ff ff       	call   c01071e5 <insert_vma_struct>

    uintptr_t addr = 0x100;
c01079a6:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c01079ad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079b7:	89 04 24             	mov    %eax,(%esp)
c01079ba:	e8 d1 f6 ff ff       	call   c0107090 <find_vma>
c01079bf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01079c2:	74 24                	je     c01079e8 <check_pgfault+0x12c>
c01079c4:	c7 44 24 0c 8d a5 10 	movl   $0xc010a58d,0xc(%esp)
c01079cb:	c0 
c01079cc:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c01079d3:	c0 
c01079d4:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01079db:	00 
c01079dc:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c01079e3:	e8 ec 92 ff ff       	call   c0100cd4 <__panic>

    int i, sum = 0;
c01079e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c01079ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01079f6:	eb 17                	jmp    c0107a0f <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c01079f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01079fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079fe:	01 d0                	add    %edx,%eax
c0107a00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a03:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a08:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107a0b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a0f:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a13:	7e e3                	jle    c01079f8 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a1c:	eb 15                	jmp    c0107a33 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a24:	01 d0                	add    %edx,%eax
c0107a26:	0f b6 00             	movzbl (%eax),%eax
c0107a29:	0f be c0             	movsbl %al,%eax
c0107a2c:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a2f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a33:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a37:	7e e5                	jle    c0107a1e <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a3d:	74 24                	je     c0107a63 <check_pgfault+0x1a7>
c0107a3f:	c7 44 24 0c a7 a5 10 	movl   $0xc010a5a7,0xc(%esp)
c0107a46:	c0 
c0107a47:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107a4e:	c0 
c0107a4f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107a56:	00 
c0107a57:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107a5e:	e8 71 92 ff ff       	call   c0100cd4 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107a63:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a66:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107a69:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107a71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a78:	89 04 24             	mov    %eax,(%esp)
c0107a7b:	e8 a8 d4 ff ff       	call   c0104f28 <page_remove>
    free_page(pa2page(pgdir[0]));
c0107a80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a83:	8b 00                	mov    (%eax),%eax
c0107a85:	89 04 24             	mov    %eax,(%esp)
c0107a88:	e8 0b f5 ff ff       	call   c0106f98 <pa2page>
c0107a8d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107a94:	00 
c0107a95:	89 04 24             	mov    %eax,(%esp)
c0107a98:	e8 8f cb ff ff       	call   c010462c <free_pages>
    pgdir[0] = 0;
c0107a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107aa9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ab3:	89 04 24             	mov    %eax,(%esp)
c0107ab6:	e8 5a f8 ff ff       	call   c0107315 <mm_destroy>
    check_mm_struct = NULL;
c0107abb:	c7 05 ac 0b 12 c0 00 	movl   $0x0,0xc0120bac
c0107ac2:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107ac5:	e8 94 cb ff ff       	call   c010465e <nr_free_pages>
c0107aca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107acd:	74 24                	je     c0107af3 <check_pgfault+0x237>
c0107acf:	c7 44 24 0c c4 a3 10 	movl   $0xc010a3c4,0xc(%esp)
c0107ad6:	c0 
c0107ad7:	c7 44 24 08 43 a3 10 	movl   $0xc010a343,0x8(%esp)
c0107ade:	c0 
c0107adf:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107ae6:	00 
c0107ae7:	c7 04 24 58 a3 10 c0 	movl   $0xc010a358,(%esp)
c0107aee:	e8 e1 91 ff ff       	call   c0100cd4 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107af3:	c7 04 24 b0 a5 10 c0 	movl   $0xc010a5b0,(%esp)
c0107afa:	e8 4c 88 ff ff       	call   c010034b <cprintf>
}
c0107aff:	c9                   	leave  
c0107b00:	c3                   	ret    

c0107b01 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107b01:	55                   	push   %ebp
c0107b02:	89 e5                	mov    %esp,%ebp
c0107b04:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107b07:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107b0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b18:	89 04 24             	mov    %eax,(%esp)
c0107b1b:	e8 70 f5 ff ff       	call   c0107090 <find_vma>
c0107b20:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107b23:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0107b28:	83 c0 01             	add    $0x1,%eax
c0107b2b:	a3 b8 0a 12 c0       	mov    %eax,0xc0120ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107b30:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107b34:	74 0b                	je     c0107b41 <do_pgfault+0x40>
c0107b36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b39:	8b 40 04             	mov    0x4(%eax),%eax
c0107b3c:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107b3f:	76 18                	jbe    c0107b59 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107b41:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b48:	c7 04 24 cc a5 10 c0 	movl   $0xc010a5cc,(%esp)
c0107b4f:	e8 f7 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107b54:	e9 9c 01 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
    }
    //check the error_code
    switch (error_code & 3) {
c0107b59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b5c:	83 e0 03             	and    $0x3,%eax
c0107b5f:	85 c0                	test   %eax,%eax
c0107b61:	74 36                	je     c0107b99 <do_pgfault+0x98>
c0107b63:	83 f8 01             	cmp    $0x1,%eax
c0107b66:	74 20                	je     c0107b88 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107b68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b6b:	8b 40 0c             	mov    0xc(%eax),%eax
c0107b6e:	83 e0 02             	and    $0x2,%eax
c0107b71:	85 c0                	test   %eax,%eax
c0107b73:	75 11                	jne    c0107b86 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107b75:	c7 04 24 fc a5 10 c0 	movl   $0xc010a5fc,(%esp)
c0107b7c:	e8 ca 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107b81:	e9 6f 01 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
        }
        break;
c0107b86:	eb 2f                	jmp    c0107bb7 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107b88:	c7 04 24 5c a6 10 c0 	movl   $0xc010a65c,(%esp)
c0107b8f:	e8 b7 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107b94:	e9 5c 01 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107b99:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b9c:	8b 40 0c             	mov    0xc(%eax),%eax
c0107b9f:	83 e0 05             	and    $0x5,%eax
c0107ba2:	85 c0                	test   %eax,%eax
c0107ba4:	75 11                	jne    c0107bb7 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107ba6:	c7 04 24 94 a6 10 c0 	movl   $0xc010a694,(%esp)
c0107bad:	e8 99 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107bb2:	e9 3e 01 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107bb7:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bc1:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bc4:	83 e0 02             	and    $0x2,%eax
c0107bc7:	85 c0                	test   %eax,%eax
c0107bc9:	74 04                	je     c0107bcf <do_pgfault+0xce>
        perm |= PTE_W;
c0107bcb:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107bcf:	8b 45 10             	mov    0x10(%ebp),%eax
c0107bd2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107bd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107bd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107bdd:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107be0:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107be7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
   ptep = get_pte(mm->pgdir, addr, 1);
c0107bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bf1:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bf4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107bfb:	00 
c0107bfc:	8b 55 10             	mov    0x10(%ebp),%edx
c0107bff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c03:	89 04 24             	mov    %eax,(%esp)
c0107c06:	e8 18 d1 ff ff       	call   c0104d23 <get_pte>
c0107c0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
   if(ptep == NULL) goto failed;
c0107c0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107c12:	75 05                	jne    c0107c19 <do_pgfault+0x118>
c0107c14:	e9 dc 00 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
   if(*ptep == 0){
c0107c19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c1c:	8b 00                	mov    (%eax),%eax
c0107c1e:	85 c0                	test   %eax,%eax
c0107c20:	75 2f                	jne    c0107c51 <do_pgfault+0x150>
	   struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
c0107c22:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c25:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107c2b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107c2f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c32:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c36:	89 04 24             	mov    %eax,(%esp)
c0107c39:	e8 44 d4 ff ff       	call   c0105082 <pgdir_alloc_page>
c0107c3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	   if(page == NULL) goto failed;
c0107c41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107c45:	75 05                	jne    c0107c4c <do_pgfault+0x14b>
c0107c47:	e9 a9 00 00 00       	jmp    c0107cf5 <do_pgfault+0x1f4>
c0107c4c:	e9 9d 00 00 00       	jmp    c0107cee <do_pgfault+0x1ed>
   }
   else{
	   if(swap_init_ok){
c0107c51:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0107c56:	85 c0                	test   %eax,%eax
c0107c58:	74 7d                	je     c0107cd7 <do_pgfault+0x1d6>
		   struct Page *page = NULL;
c0107c5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		   ret = swap_in(mm, addr, &page);
c0107c61:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0107c64:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107c68:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c72:	89 04 24             	mov    %eax,(%esp)
c0107c75:	e8 d2 e5 ff ff       	call   c010624c <swap_in>
c0107c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		   if( ret != 0) goto failed;
c0107c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107c81:	74 02                	je     c0107c85 <do_pgfault+0x184>
c0107c83:	eb 70                	jmp    c0107cf5 <do_pgfault+0x1f4>
		   ret = page_insert(mm->pgdir, page, addr, perm);
c0107c85:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c8b:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c8e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107c91:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107c95:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107c98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107ca0:	89 04 24             	mov    %eax,(%esp)
c0107ca3:	e8 c4 d2 ff ff       	call   c0104f6c <page_insert>
c0107ca8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		   if( ret != 0) goto failed;
c0107cab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107caf:	74 03                	je     c0107cb4 <do_pgfault+0x1b3>
c0107cb1:	90                   	nop
c0107cb2:	eb 41                	jmp    c0107cf5 <do_pgfault+0x1f4>
		   swap_map_swappable(mm,addr,page,1);
c0107cb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107cb7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107cbe:	00 
c0107cbf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107cc3:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cca:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ccd:	89 04 24             	mov    %eax,(%esp)
c0107cd0:	e8 ae e3 ff ff       	call   c0106083 <swap_map_swappable>
c0107cd5:	eb 17                	jmp    c0107cee <do_pgfault+0x1ed>
	   }else {
		   cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cda:	8b 00                	mov    (%eax),%eax
c0107cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ce0:	c7 04 24 f8 a6 10 c0 	movl   $0xc010a6f8,(%esp)
c0107ce7:	e8 5f 86 ff ff       	call   c010034b <cprintf>
		   goto failed;
c0107cec:	eb 07                	jmp    c0107cf5 <do_pgfault+0x1f4>
	   }
   }
   ret = 0;
c0107cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107cf8:	c9                   	leave  
c0107cf9:	c3                   	ret    

c0107cfa <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107cfa:	55                   	push   %ebp
c0107cfb:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107cfd:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d00:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0107d05:	29 c2                	sub    %eax,%edx
c0107d07:	89 d0                	mov    %edx,%eax
c0107d09:	c1 f8 05             	sar    $0x5,%eax
}
c0107d0c:	5d                   	pop    %ebp
c0107d0d:	c3                   	ret    

c0107d0e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107d0e:	55                   	push   %ebp
c0107d0f:	89 e5                	mov    %esp,%ebp
c0107d11:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d17:	89 04 24             	mov    %eax,(%esp)
c0107d1a:	e8 db ff ff ff       	call   c0107cfa <page2ppn>
c0107d1f:	c1 e0 0c             	shl    $0xc,%eax
}
c0107d22:	c9                   	leave  
c0107d23:	c3                   	ret    

c0107d24 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107d24:	55                   	push   %ebp
c0107d25:	89 e5                	mov    %esp,%ebp
c0107d27:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d2d:	89 04 24             	mov    %eax,(%esp)
c0107d30:	e8 d9 ff ff ff       	call   c0107d0e <page2pa>
c0107d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d3b:	c1 e8 0c             	shr    $0xc,%eax
c0107d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d41:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0107d46:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107d49:	72 23                	jb     c0107d6e <page2kva+0x4a>
c0107d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d4e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107d52:	c7 44 24 08 20 a7 10 	movl   $0xc010a720,0x8(%esp)
c0107d59:	c0 
c0107d5a:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107d61:	00 
c0107d62:	c7 04 24 43 a7 10 c0 	movl   $0xc010a743,(%esp)
c0107d69:	e8 66 8f ff ff       	call   c0100cd4 <__panic>
c0107d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d71:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107d76:	c9                   	leave  
c0107d77:	c3                   	ret    

c0107d78 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107d78:	55                   	push   %ebp
c0107d79:	89 e5                	mov    %esp,%ebp
c0107d7b:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107d7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107d85:	e8 9a 9c ff ff       	call   c0101a24 <ide_device_valid>
c0107d8a:	85 c0                	test   %eax,%eax
c0107d8c:	75 1c                	jne    c0107daa <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107d8e:	c7 44 24 08 51 a7 10 	movl   $0xc010a751,0x8(%esp)
c0107d95:	c0 
c0107d96:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107d9d:	00 
c0107d9e:	c7 04 24 6b a7 10 c0 	movl   $0xc010a76b,(%esp)
c0107da5:	e8 2a 8f ff ff       	call   c0100cd4 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107daa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107db1:	e8 ad 9c ff ff       	call   c0101a63 <ide_device_size>
c0107db6:	c1 e8 03             	shr    $0x3,%eax
c0107db9:	a3 7c 0b 12 c0       	mov    %eax,0xc0120b7c
}
c0107dbe:	c9                   	leave  
c0107dbf:	c3                   	ret    

c0107dc0 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107dc0:	55                   	push   %ebp
c0107dc1:	89 e5                	mov    %esp,%ebp
c0107dc3:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dc9:	89 04 24             	mov    %eax,(%esp)
c0107dcc:	e8 53 ff ff ff       	call   c0107d24 <page2kva>
c0107dd1:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dd4:	c1 ea 08             	shr    $0x8,%edx
c0107dd7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107dda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107dde:	74 0b                	je     c0107deb <swapfs_read+0x2b>
c0107de0:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107de6:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107de9:	72 23                	jb     c0107e0e <swapfs_read+0x4e>
c0107deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107df2:	c7 44 24 08 7c a7 10 	movl   $0xc010a77c,0x8(%esp)
c0107df9:	c0 
c0107dfa:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107e01:	00 
c0107e02:	c7 04 24 6b a7 10 c0 	movl   $0xc010a76b,(%esp)
c0107e09:	e8 c6 8e ff ff       	call   c0100cd4 <__panic>
c0107e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e11:	c1 e2 03             	shl    $0x3,%edx
c0107e14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107e1b:	00 
c0107e1c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e20:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e2b:	e8 72 9c ff ff       	call   c0101aa2 <ide_read_secs>
}
c0107e30:	c9                   	leave  
c0107e31:	c3                   	ret    

c0107e32 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107e32:	55                   	push   %ebp
c0107e33:	89 e5                	mov    %esp,%ebp
c0107e35:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107e38:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e3b:	89 04 24             	mov    %eax,(%esp)
c0107e3e:	e8 e1 fe ff ff       	call   c0107d24 <page2kva>
c0107e43:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e46:	c1 ea 08             	shr    $0x8,%edx
c0107e49:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e50:	74 0b                	je     c0107e5d <swapfs_write+0x2b>
c0107e52:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107e58:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107e5b:	72 23                	jb     c0107e80 <swapfs_write+0x4e>
c0107e5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e60:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e64:	c7 44 24 08 7c a7 10 	movl   $0xc010a77c,0x8(%esp)
c0107e6b:	c0 
c0107e6c:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107e73:	00 
c0107e74:	c7 04 24 6b a7 10 c0 	movl   $0xc010a76b,(%esp)
c0107e7b:	e8 54 8e ff ff       	call   c0100cd4 <__panic>
c0107e80:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e83:	c1 e2 03             	shl    $0x3,%edx
c0107e86:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107e8d:	00 
c0107e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e92:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e9d:	e8 42 9e ff ff       	call   c0101ce4 <ide_write_secs>
}
c0107ea2:	c9                   	leave  
c0107ea3:	c3                   	ret    

c0107ea4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107ea4:	55                   	push   %ebp
c0107ea5:	89 e5                	mov    %esp,%ebp
c0107ea7:	83 ec 58             	sub    $0x58,%esp
c0107eaa:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ead:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107eb0:	8b 45 14             	mov    0x14(%ebp),%eax
c0107eb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107eb6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107eb9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107ebc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ebf:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107ec2:	8b 45 18             	mov    0x18(%ebp),%eax
c0107ec5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ecb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107ece:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107ed1:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ed7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107eda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ede:	74 1c                	je     c0107efc <printnum+0x58>
c0107ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ee3:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ee8:	f7 75 e4             	divl   -0x1c(%ebp)
c0107eeb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ef1:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ef6:	f7 75 e4             	divl   -0x1c(%ebp)
c0107ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f02:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f08:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107f0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f0e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f11:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f14:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107f17:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f1a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107f1d:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f20:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f25:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f28:	77 56                	ja     c0107f80 <printnum+0xdc>
c0107f2a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f2d:	72 05                	jb     c0107f34 <printnum+0x90>
c0107f2f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107f32:	77 4c                	ja     c0107f80 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107f34:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107f37:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107f3a:	8b 45 20             	mov    0x20(%ebp),%eax
c0107f3d:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107f41:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107f45:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f48:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f56:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f61:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f64:	89 04 24             	mov    %eax,(%esp)
c0107f67:	e8 38 ff ff ff       	call   c0107ea4 <printnum>
c0107f6c:	eb 1c                	jmp    c0107f8a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f75:	8b 45 20             	mov    0x20(%ebp),%eax
c0107f78:	89 04 24             	mov    %eax,(%esp)
c0107f7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f7e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0107f80:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0107f84:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107f88:	7f e4                	jg     c0107f6e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107f8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107f8d:	05 1c a8 10 c0       	add    $0xc010a81c,%eax
c0107f92:	0f b6 00             	movzbl (%eax),%eax
c0107f95:	0f be c0             	movsbl %al,%eax
c0107f98:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107f9b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f9f:	89 04 24             	mov    %eax,(%esp)
c0107fa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa5:	ff d0                	call   *%eax
}
c0107fa7:	c9                   	leave  
c0107fa8:	c3                   	ret    

c0107fa9 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107fa9:	55                   	push   %ebp
c0107faa:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107fac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107fb0:	7e 14                	jle    c0107fc6 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0107fb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fb5:	8b 00                	mov    (%eax),%eax
c0107fb7:	8d 48 08             	lea    0x8(%eax),%ecx
c0107fba:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fbd:	89 0a                	mov    %ecx,(%edx)
c0107fbf:	8b 50 04             	mov    0x4(%eax),%edx
c0107fc2:	8b 00                	mov    (%eax),%eax
c0107fc4:	eb 30                	jmp    c0107ff6 <getuint+0x4d>
    }
    else if (lflag) {
c0107fc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107fca:	74 16                	je     c0107fe2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0107fcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fcf:	8b 00                	mov    (%eax),%eax
c0107fd1:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fd4:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fd7:	89 0a                	mov    %ecx,(%edx)
c0107fd9:	8b 00                	mov    (%eax),%eax
c0107fdb:	ba 00 00 00 00       	mov    $0x0,%edx
c0107fe0:	eb 14                	jmp    c0107ff6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0107fe2:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe5:	8b 00                	mov    (%eax),%eax
c0107fe7:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fea:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fed:	89 0a                	mov    %ecx,(%edx)
c0107fef:	8b 00                	mov    (%eax),%eax
c0107ff1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107ff6:	5d                   	pop    %ebp
c0107ff7:	c3                   	ret    

c0107ff8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107ff8:	55                   	push   %ebp
c0107ff9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107ffb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107fff:	7e 14                	jle    c0108015 <getint+0x1d>
        return va_arg(*ap, long long);
c0108001:	8b 45 08             	mov    0x8(%ebp),%eax
c0108004:	8b 00                	mov    (%eax),%eax
c0108006:	8d 48 08             	lea    0x8(%eax),%ecx
c0108009:	8b 55 08             	mov    0x8(%ebp),%edx
c010800c:	89 0a                	mov    %ecx,(%edx)
c010800e:	8b 50 04             	mov    0x4(%eax),%edx
c0108011:	8b 00                	mov    (%eax),%eax
c0108013:	eb 28                	jmp    c010803d <getint+0x45>
    }
    else if (lflag) {
c0108015:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108019:	74 12                	je     c010802d <getint+0x35>
        return va_arg(*ap, long);
c010801b:	8b 45 08             	mov    0x8(%ebp),%eax
c010801e:	8b 00                	mov    (%eax),%eax
c0108020:	8d 48 04             	lea    0x4(%eax),%ecx
c0108023:	8b 55 08             	mov    0x8(%ebp),%edx
c0108026:	89 0a                	mov    %ecx,(%edx)
c0108028:	8b 00                	mov    (%eax),%eax
c010802a:	99                   	cltd   
c010802b:	eb 10                	jmp    c010803d <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010802d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108030:	8b 00                	mov    (%eax),%eax
c0108032:	8d 48 04             	lea    0x4(%eax),%ecx
c0108035:	8b 55 08             	mov    0x8(%ebp),%edx
c0108038:	89 0a                	mov    %ecx,(%edx)
c010803a:	8b 00                	mov    (%eax),%eax
c010803c:	99                   	cltd   
    }
}
c010803d:	5d                   	pop    %ebp
c010803e:	c3                   	ret    

c010803f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010803f:	55                   	push   %ebp
c0108040:	89 e5                	mov    %esp,%ebp
c0108042:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108045:	8d 45 14             	lea    0x14(%ebp),%eax
c0108048:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010804e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108052:	8b 45 10             	mov    0x10(%ebp),%eax
c0108055:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108059:	8b 45 0c             	mov    0xc(%ebp),%eax
c010805c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108060:	8b 45 08             	mov    0x8(%ebp),%eax
c0108063:	89 04 24             	mov    %eax,(%esp)
c0108066:	e8 02 00 00 00       	call   c010806d <vprintfmt>
    va_end(ap);
}
c010806b:	c9                   	leave  
c010806c:	c3                   	ret    

c010806d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010806d:	55                   	push   %ebp
c010806e:	89 e5                	mov    %esp,%ebp
c0108070:	56                   	push   %esi
c0108071:	53                   	push   %ebx
c0108072:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108075:	eb 18                	jmp    c010808f <vprintfmt+0x22>
            if (ch == '\0') {
c0108077:	85 db                	test   %ebx,%ebx
c0108079:	75 05                	jne    c0108080 <vprintfmt+0x13>
                return;
c010807b:	e9 d1 03 00 00       	jmp    c0108451 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108080:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108083:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108087:	89 1c 24             	mov    %ebx,(%esp)
c010808a:	8b 45 08             	mov    0x8(%ebp),%eax
c010808d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010808f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108092:	8d 50 01             	lea    0x1(%eax),%edx
c0108095:	89 55 10             	mov    %edx,0x10(%ebp)
c0108098:	0f b6 00             	movzbl (%eax),%eax
c010809b:	0f b6 d8             	movzbl %al,%ebx
c010809e:	83 fb 25             	cmp    $0x25,%ebx
c01080a1:	75 d4                	jne    c0108077 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01080a3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01080a7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01080ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01080b4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01080bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080be:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01080c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01080c4:	8d 50 01             	lea    0x1(%eax),%edx
c01080c7:	89 55 10             	mov    %edx,0x10(%ebp)
c01080ca:	0f b6 00             	movzbl (%eax),%eax
c01080cd:	0f b6 d8             	movzbl %al,%ebx
c01080d0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01080d3:	83 f8 55             	cmp    $0x55,%eax
c01080d6:	0f 87 44 03 00 00    	ja     c0108420 <vprintfmt+0x3b3>
c01080dc:	8b 04 85 40 a8 10 c0 	mov    -0x3fef57c0(,%eax,4),%eax
c01080e3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01080e5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01080e9:	eb d6                	jmp    c01080c1 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01080eb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01080ef:	eb d0                	jmp    c01080c1 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01080f1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01080f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01080fb:	89 d0                	mov    %edx,%eax
c01080fd:	c1 e0 02             	shl    $0x2,%eax
c0108100:	01 d0                	add    %edx,%eax
c0108102:	01 c0                	add    %eax,%eax
c0108104:	01 d8                	add    %ebx,%eax
c0108106:	83 e8 30             	sub    $0x30,%eax
c0108109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010810c:	8b 45 10             	mov    0x10(%ebp),%eax
c010810f:	0f b6 00             	movzbl (%eax),%eax
c0108112:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108115:	83 fb 2f             	cmp    $0x2f,%ebx
c0108118:	7e 0b                	jle    c0108125 <vprintfmt+0xb8>
c010811a:	83 fb 39             	cmp    $0x39,%ebx
c010811d:	7f 06                	jg     c0108125 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010811f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108123:	eb d3                	jmp    c01080f8 <vprintfmt+0x8b>
            goto process_precision;
c0108125:	eb 33                	jmp    c010815a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0108127:	8b 45 14             	mov    0x14(%ebp),%eax
c010812a:	8d 50 04             	lea    0x4(%eax),%edx
c010812d:	89 55 14             	mov    %edx,0x14(%ebp)
c0108130:	8b 00                	mov    (%eax),%eax
c0108132:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108135:	eb 23                	jmp    c010815a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0108137:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010813b:	79 0c                	jns    c0108149 <vprintfmt+0xdc>
                width = 0;
c010813d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108144:	e9 78 ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>
c0108149:	e9 73 ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010814e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108155:	e9 67 ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010815a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010815e:	79 12                	jns    c0108172 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108163:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108166:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010816d:	e9 4f ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>
c0108172:	e9 4a ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0108177:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010817b:	e9 41 ff ff ff       	jmp    c01080c1 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108180:	8b 45 14             	mov    0x14(%ebp),%eax
c0108183:	8d 50 04             	lea    0x4(%eax),%edx
c0108186:	89 55 14             	mov    %edx,0x14(%ebp)
c0108189:	8b 00                	mov    (%eax),%eax
c010818b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010818e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108192:	89 04 24             	mov    %eax,(%esp)
c0108195:	8b 45 08             	mov    0x8(%ebp),%eax
c0108198:	ff d0                	call   *%eax
            break;
c010819a:	e9 ac 02 00 00       	jmp    c010844b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010819f:	8b 45 14             	mov    0x14(%ebp),%eax
c01081a2:	8d 50 04             	lea    0x4(%eax),%edx
c01081a5:	89 55 14             	mov    %edx,0x14(%ebp)
c01081a8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01081aa:	85 db                	test   %ebx,%ebx
c01081ac:	79 02                	jns    c01081b0 <vprintfmt+0x143>
                err = -err;
c01081ae:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01081b0:	83 fb 06             	cmp    $0x6,%ebx
c01081b3:	7f 0b                	jg     c01081c0 <vprintfmt+0x153>
c01081b5:	8b 34 9d 00 a8 10 c0 	mov    -0x3fef5800(,%ebx,4),%esi
c01081bc:	85 f6                	test   %esi,%esi
c01081be:	75 23                	jne    c01081e3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01081c0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01081c4:	c7 44 24 08 2d a8 10 	movl   $0xc010a82d,0x8(%esp)
c01081cb:	c0 
c01081cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01081d6:	89 04 24             	mov    %eax,(%esp)
c01081d9:	e8 61 fe ff ff       	call   c010803f <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01081de:	e9 68 02 00 00       	jmp    c010844b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01081e3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01081e7:	c7 44 24 08 36 a8 10 	movl   $0xc010a836,0x8(%esp)
c01081ee:	c0 
c01081ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01081f9:	89 04 24             	mov    %eax,(%esp)
c01081fc:	e8 3e fe ff ff       	call   c010803f <printfmt>
            }
            break;
c0108201:	e9 45 02 00 00       	jmp    c010844b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108206:	8b 45 14             	mov    0x14(%ebp),%eax
c0108209:	8d 50 04             	lea    0x4(%eax),%edx
c010820c:	89 55 14             	mov    %edx,0x14(%ebp)
c010820f:	8b 30                	mov    (%eax),%esi
c0108211:	85 f6                	test   %esi,%esi
c0108213:	75 05                	jne    c010821a <vprintfmt+0x1ad>
                p = "(null)";
c0108215:	be 39 a8 10 c0       	mov    $0xc010a839,%esi
            }
            if (width > 0 && padc != '-') {
c010821a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010821e:	7e 3e                	jle    c010825e <vprintfmt+0x1f1>
c0108220:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108224:	74 38                	je     c010825e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108226:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0108229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010822c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108230:	89 34 24             	mov    %esi,(%esp)
c0108233:	e8 ed 03 00 00       	call   c0108625 <strnlen>
c0108238:	29 c3                	sub    %eax,%ebx
c010823a:	89 d8                	mov    %ebx,%eax
c010823c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010823f:	eb 17                	jmp    c0108258 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108241:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108245:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108248:	89 54 24 04          	mov    %edx,0x4(%esp)
c010824c:	89 04 24             	mov    %eax,(%esp)
c010824f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108252:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108254:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108258:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010825c:	7f e3                	jg     c0108241 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010825e:	eb 38                	jmp    c0108298 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108260:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108264:	74 1f                	je     c0108285 <vprintfmt+0x218>
c0108266:	83 fb 1f             	cmp    $0x1f,%ebx
c0108269:	7e 05                	jle    c0108270 <vprintfmt+0x203>
c010826b:	83 fb 7e             	cmp    $0x7e,%ebx
c010826e:	7e 15                	jle    c0108285 <vprintfmt+0x218>
                    putch('?', putdat);
c0108270:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108273:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108277:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010827e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108281:	ff d0                	call   *%eax
c0108283:	eb 0f                	jmp    c0108294 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108288:	89 44 24 04          	mov    %eax,0x4(%esp)
c010828c:	89 1c 24             	mov    %ebx,(%esp)
c010828f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108292:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108294:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108298:	89 f0                	mov    %esi,%eax
c010829a:	8d 70 01             	lea    0x1(%eax),%esi
c010829d:	0f b6 00             	movzbl (%eax),%eax
c01082a0:	0f be d8             	movsbl %al,%ebx
c01082a3:	85 db                	test   %ebx,%ebx
c01082a5:	74 10                	je     c01082b7 <vprintfmt+0x24a>
c01082a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01082ab:	78 b3                	js     c0108260 <vprintfmt+0x1f3>
c01082ad:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01082b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01082b5:	79 a9                	jns    c0108260 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01082b7:	eb 17                	jmp    c01082d0 <vprintfmt+0x263>
                putch(' ', putdat);
c01082b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082c0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01082c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ca:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01082cc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01082d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082d4:	7f e3                	jg     c01082b9 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01082d6:	e9 70 01 00 00       	jmp    c010844b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01082db:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e2:	8d 45 14             	lea    0x14(%ebp),%eax
c01082e5:	89 04 24             	mov    %eax,(%esp)
c01082e8:	e8 0b fd ff ff       	call   c0107ff8 <getint>
c01082ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01082f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01082f9:	85 d2                	test   %edx,%edx
c01082fb:	79 26                	jns    c0108323 <vprintfmt+0x2b6>
                putch('-', putdat);
c01082fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108300:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108304:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010830b:	8b 45 08             	mov    0x8(%ebp),%eax
c010830e:	ff d0                	call   *%eax
                num = -(long long)num;
c0108310:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108313:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108316:	f7 d8                	neg    %eax
c0108318:	83 d2 00             	adc    $0x0,%edx
c010831b:	f7 da                	neg    %edx
c010831d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108320:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108323:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010832a:	e9 a8 00 00 00       	jmp    c01083d7 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010832f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108336:	8d 45 14             	lea    0x14(%ebp),%eax
c0108339:	89 04 24             	mov    %eax,(%esp)
c010833c:	e8 68 fc ff ff       	call   c0107fa9 <getuint>
c0108341:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108344:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0108347:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010834e:	e9 84 00 00 00       	jmp    c01083d7 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108353:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108356:	89 44 24 04          	mov    %eax,0x4(%esp)
c010835a:	8d 45 14             	lea    0x14(%ebp),%eax
c010835d:	89 04 24             	mov    %eax,(%esp)
c0108360:	e8 44 fc ff ff       	call   c0107fa9 <getuint>
c0108365:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108368:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010836b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108372:	eb 63                	jmp    c01083d7 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108374:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108377:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108382:	8b 45 08             	mov    0x8(%ebp),%eax
c0108385:	ff d0                	call   *%eax
            putch('x', putdat);
c0108387:	8b 45 0c             	mov    0xc(%ebp),%eax
c010838a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010838e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108395:	8b 45 08             	mov    0x8(%ebp),%eax
c0108398:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010839a:	8b 45 14             	mov    0x14(%ebp),%eax
c010839d:	8d 50 04             	lea    0x4(%eax),%edx
c01083a0:	89 55 14             	mov    %edx,0x14(%ebp)
c01083a3:	8b 00                	mov    (%eax),%eax
c01083a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01083af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01083b6:	eb 1f                	jmp    c01083d7 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01083b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083bf:	8d 45 14             	lea    0x14(%ebp),%eax
c01083c2:	89 04 24             	mov    %eax,(%esp)
c01083c5:	e8 df fb ff ff       	call   c0107fa9 <getuint>
c01083ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083cd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01083d0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01083d7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01083db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083de:	89 54 24 18          	mov    %edx,0x18(%esp)
c01083e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01083e5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01083e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01083ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083f7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108402:	8b 45 08             	mov    0x8(%ebp),%eax
c0108405:	89 04 24             	mov    %eax,(%esp)
c0108408:	e8 97 fa ff ff       	call   c0107ea4 <printnum>
            break;
c010840d:	eb 3c                	jmp    c010844b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010840f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108416:	89 1c 24             	mov    %ebx,(%esp)
c0108419:	8b 45 08             	mov    0x8(%ebp),%eax
c010841c:	ff d0                	call   *%eax
            break;
c010841e:	eb 2b                	jmp    c010844b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108420:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108423:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108427:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010842e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108431:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108433:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108437:	eb 04                	jmp    c010843d <vprintfmt+0x3d0>
c0108439:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010843d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108440:	83 e8 01             	sub    $0x1,%eax
c0108443:	0f b6 00             	movzbl (%eax),%eax
c0108446:	3c 25                	cmp    $0x25,%al
c0108448:	75 ef                	jne    c0108439 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010844a:	90                   	nop
        }
    }
c010844b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010844c:	e9 3e fc ff ff       	jmp    c010808f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108451:	83 c4 40             	add    $0x40,%esp
c0108454:	5b                   	pop    %ebx
c0108455:	5e                   	pop    %esi
c0108456:	5d                   	pop    %ebp
c0108457:	c3                   	ret    

c0108458 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0108458:	55                   	push   %ebp
c0108459:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010845b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010845e:	8b 40 08             	mov    0x8(%eax),%eax
c0108461:	8d 50 01             	lea    0x1(%eax),%edx
c0108464:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108467:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010846a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010846d:	8b 10                	mov    (%eax),%edx
c010846f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108472:	8b 40 04             	mov    0x4(%eax),%eax
c0108475:	39 c2                	cmp    %eax,%edx
c0108477:	73 12                	jae    c010848b <sprintputch+0x33>
        *b->buf ++ = ch;
c0108479:	8b 45 0c             	mov    0xc(%ebp),%eax
c010847c:	8b 00                	mov    (%eax),%eax
c010847e:	8d 48 01             	lea    0x1(%eax),%ecx
c0108481:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108484:	89 0a                	mov    %ecx,(%edx)
c0108486:	8b 55 08             	mov    0x8(%ebp),%edx
c0108489:	88 10                	mov    %dl,(%eax)
    }
}
c010848b:	5d                   	pop    %ebp
c010848c:	c3                   	ret    

c010848d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010848d:	55                   	push   %ebp
c010848e:	89 e5                	mov    %esp,%ebp
c0108490:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108493:	8d 45 14             	lea    0x14(%ebp),%eax
c0108496:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0108499:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010849c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01084a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01084a3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b1:	89 04 24             	mov    %eax,(%esp)
c01084b4:	e8 08 00 00 00       	call   c01084c1 <vsnprintf>
c01084b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01084bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084bf:	c9                   	leave  
c01084c0:	c3                   	ret    

c01084c1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01084c1:	55                   	push   %ebp
c01084c2:	89 e5                	mov    %esp,%ebp
c01084c4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01084c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01084ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01084cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084d0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01084d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01084d6:	01 d0                	add    %edx,%eax
c01084d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01084e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084e6:	74 0a                	je     c01084f2 <vsnprintf+0x31>
c01084e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01084eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084ee:	39 c2                	cmp    %eax,%edx
c01084f0:	76 07                	jbe    c01084f9 <vsnprintf+0x38>
        return -E_INVAL;
c01084f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01084f7:	eb 2a                	jmp    c0108523 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01084f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01084fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108500:	8b 45 10             	mov    0x10(%ebp),%eax
c0108503:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108507:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010850a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010850e:	c7 04 24 58 84 10 c0 	movl   $0xc0108458,(%esp)
c0108515:	e8 53 fb ff ff       	call   c010806d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010851a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010851d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108520:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108523:	c9                   	leave  
c0108524:	c3                   	ret    

c0108525 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108525:	55                   	push   %ebp
c0108526:	89 e5                	mov    %esp,%ebp
c0108528:	57                   	push   %edi
c0108529:	56                   	push   %esi
c010852a:	53                   	push   %ebx
c010852b:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010852e:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108533:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c0108539:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010853f:	6b f0 05             	imul   $0x5,%eax,%esi
c0108542:	01 f7                	add    %esi,%edi
c0108544:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c0108549:	f7 e6                	mul    %esi
c010854b:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010854e:	89 f2                	mov    %esi,%edx
c0108550:	83 c0 0b             	add    $0xb,%eax
c0108553:	83 d2 00             	adc    $0x0,%edx
c0108556:	89 c7                	mov    %eax,%edi
c0108558:	83 e7 ff             	and    $0xffffffff,%edi
c010855b:	89 f9                	mov    %edi,%ecx
c010855d:	0f b7 da             	movzwl %dx,%ebx
c0108560:	89 0d 60 fa 11 c0    	mov    %ecx,0xc011fa60
c0108566:	89 1d 64 fa 11 c0    	mov    %ebx,0xc011fa64
    unsigned long long result = (next >> 12);
c010856c:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108571:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c0108577:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010857b:	c1 ea 0c             	shr    $0xc,%edx
c010857e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108581:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108584:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010858b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010858e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108591:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108594:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010859a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010859d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085a1:	74 1c                	je     c01085bf <rand+0x9a>
c01085a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085a6:	ba 00 00 00 00       	mov    $0x0,%edx
c01085ab:	f7 75 dc             	divl   -0x24(%ebp)
c01085ae:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01085b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085b4:	ba 00 00 00 00       	mov    $0x0,%edx
c01085b9:	f7 75 dc             	divl   -0x24(%ebp)
c01085bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01085bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01085c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01085c5:	f7 75 dc             	divl   -0x24(%ebp)
c01085c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01085cb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01085ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01085d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01085d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085d7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01085da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01085dd:	83 c4 24             	add    $0x24,%esp
c01085e0:	5b                   	pop    %ebx
c01085e1:	5e                   	pop    %esi
c01085e2:	5f                   	pop    %edi
c01085e3:	5d                   	pop    %ebp
c01085e4:	c3                   	ret    

c01085e5 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01085e5:	55                   	push   %ebp
c01085e6:	89 e5                	mov    %esp,%ebp
    next = seed;
c01085e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01085eb:	ba 00 00 00 00       	mov    $0x0,%edx
c01085f0:	a3 60 fa 11 c0       	mov    %eax,0xc011fa60
c01085f5:	89 15 64 fa 11 c0    	mov    %edx,0xc011fa64
}
c01085fb:	5d                   	pop    %ebp
c01085fc:	c3                   	ret    

c01085fd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01085fd:	55                   	push   %ebp
c01085fe:	89 e5                	mov    %esp,%ebp
c0108600:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010860a:	eb 04                	jmp    c0108610 <strlen+0x13>
        cnt ++;
c010860c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108610:	8b 45 08             	mov    0x8(%ebp),%eax
c0108613:	8d 50 01             	lea    0x1(%eax),%edx
c0108616:	89 55 08             	mov    %edx,0x8(%ebp)
c0108619:	0f b6 00             	movzbl (%eax),%eax
c010861c:	84 c0                	test   %al,%al
c010861e:	75 ec                	jne    c010860c <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108620:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108623:	c9                   	leave  
c0108624:	c3                   	ret    

c0108625 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108625:	55                   	push   %ebp
c0108626:	89 e5                	mov    %esp,%ebp
c0108628:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010862b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108632:	eb 04                	jmp    c0108638 <strnlen+0x13>
        cnt ++;
c0108634:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0108638:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010863b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010863e:	73 10                	jae    c0108650 <strnlen+0x2b>
c0108640:	8b 45 08             	mov    0x8(%ebp),%eax
c0108643:	8d 50 01             	lea    0x1(%eax),%edx
c0108646:	89 55 08             	mov    %edx,0x8(%ebp)
c0108649:	0f b6 00             	movzbl (%eax),%eax
c010864c:	84 c0                	test   %al,%al
c010864e:	75 e4                	jne    c0108634 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108650:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108653:	c9                   	leave  
c0108654:	c3                   	ret    

c0108655 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108655:	55                   	push   %ebp
c0108656:	89 e5                	mov    %esp,%ebp
c0108658:	57                   	push   %edi
c0108659:	56                   	push   %esi
c010865a:	83 ec 20             	sub    $0x20,%esp
c010865d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108660:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108663:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108666:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108669:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010866c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010866f:	89 d1                	mov    %edx,%ecx
c0108671:	89 c2                	mov    %eax,%edx
c0108673:	89 ce                	mov    %ecx,%esi
c0108675:	89 d7                	mov    %edx,%edi
c0108677:	ac                   	lods   %ds:(%esi),%al
c0108678:	aa                   	stos   %al,%es:(%edi)
c0108679:	84 c0                	test   %al,%al
c010867b:	75 fa                	jne    c0108677 <strcpy+0x22>
c010867d:	89 fa                	mov    %edi,%edx
c010867f:	89 f1                	mov    %esi,%ecx
c0108681:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108684:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0108687:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010868a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010868d:	83 c4 20             	add    $0x20,%esp
c0108690:	5e                   	pop    %esi
c0108691:	5f                   	pop    %edi
c0108692:	5d                   	pop    %ebp
c0108693:	c3                   	ret    

c0108694 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108694:	55                   	push   %ebp
c0108695:	89 e5                	mov    %esp,%ebp
c0108697:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010869a:	8b 45 08             	mov    0x8(%ebp),%eax
c010869d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01086a0:	eb 21                	jmp    c01086c3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01086a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086a5:	0f b6 10             	movzbl (%eax),%edx
c01086a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086ab:	88 10                	mov    %dl,(%eax)
c01086ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086b0:	0f b6 00             	movzbl (%eax),%eax
c01086b3:	84 c0                	test   %al,%al
c01086b5:	74 04                	je     c01086bb <strncpy+0x27>
            src ++;
c01086b7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01086bb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01086bf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01086c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01086c7:	75 d9                	jne    c01086a2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01086c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01086cc:	c9                   	leave  
c01086cd:	c3                   	ret    

c01086ce <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01086ce:	55                   	push   %ebp
c01086cf:	89 e5                	mov    %esp,%ebp
c01086d1:	57                   	push   %edi
c01086d2:	56                   	push   %esi
c01086d3:	83 ec 20             	sub    $0x20,%esp
c01086d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01086d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086df:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01086e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086e8:	89 d1                	mov    %edx,%ecx
c01086ea:	89 c2                	mov    %eax,%edx
c01086ec:	89 ce                	mov    %ecx,%esi
c01086ee:	89 d7                	mov    %edx,%edi
c01086f0:	ac                   	lods   %ds:(%esi),%al
c01086f1:	ae                   	scas   %es:(%edi),%al
c01086f2:	75 08                	jne    c01086fc <strcmp+0x2e>
c01086f4:	84 c0                	test   %al,%al
c01086f6:	75 f8                	jne    c01086f0 <strcmp+0x22>
c01086f8:	31 c0                	xor    %eax,%eax
c01086fa:	eb 04                	jmp    c0108700 <strcmp+0x32>
c01086fc:	19 c0                	sbb    %eax,%eax
c01086fe:	0c 01                	or     $0x1,%al
c0108700:	89 fa                	mov    %edi,%edx
c0108702:	89 f1                	mov    %esi,%ecx
c0108704:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108707:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010870a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010870d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108710:	83 c4 20             	add    $0x20,%esp
c0108713:	5e                   	pop    %esi
c0108714:	5f                   	pop    %edi
c0108715:	5d                   	pop    %ebp
c0108716:	c3                   	ret    

c0108717 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108717:	55                   	push   %ebp
c0108718:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010871a:	eb 0c                	jmp    c0108728 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010871c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108720:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108724:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010872c:	74 1a                	je     c0108748 <strncmp+0x31>
c010872e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108731:	0f b6 00             	movzbl (%eax),%eax
c0108734:	84 c0                	test   %al,%al
c0108736:	74 10                	je     c0108748 <strncmp+0x31>
c0108738:	8b 45 08             	mov    0x8(%ebp),%eax
c010873b:	0f b6 10             	movzbl (%eax),%edx
c010873e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108741:	0f b6 00             	movzbl (%eax),%eax
c0108744:	38 c2                	cmp    %al,%dl
c0108746:	74 d4                	je     c010871c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108748:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010874c:	74 18                	je     c0108766 <strncmp+0x4f>
c010874e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108751:	0f b6 00             	movzbl (%eax),%eax
c0108754:	0f b6 d0             	movzbl %al,%edx
c0108757:	8b 45 0c             	mov    0xc(%ebp),%eax
c010875a:	0f b6 00             	movzbl (%eax),%eax
c010875d:	0f b6 c0             	movzbl %al,%eax
c0108760:	29 c2                	sub    %eax,%edx
c0108762:	89 d0                	mov    %edx,%eax
c0108764:	eb 05                	jmp    c010876b <strncmp+0x54>
c0108766:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010876b:	5d                   	pop    %ebp
c010876c:	c3                   	ret    

c010876d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010876d:	55                   	push   %ebp
c010876e:	89 e5                	mov    %esp,%ebp
c0108770:	83 ec 04             	sub    $0x4,%esp
c0108773:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108776:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108779:	eb 14                	jmp    c010878f <strchr+0x22>
        if (*s == c) {
c010877b:	8b 45 08             	mov    0x8(%ebp),%eax
c010877e:	0f b6 00             	movzbl (%eax),%eax
c0108781:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108784:	75 05                	jne    c010878b <strchr+0x1e>
            return (char *)s;
c0108786:	8b 45 08             	mov    0x8(%ebp),%eax
c0108789:	eb 13                	jmp    c010879e <strchr+0x31>
        }
        s ++;
c010878b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010878f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108792:	0f b6 00             	movzbl (%eax),%eax
c0108795:	84 c0                	test   %al,%al
c0108797:	75 e2                	jne    c010877b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108799:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010879e:	c9                   	leave  
c010879f:	c3                   	ret    

c01087a0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01087a0:	55                   	push   %ebp
c01087a1:	89 e5                	mov    %esp,%ebp
c01087a3:	83 ec 04             	sub    $0x4,%esp
c01087a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087a9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01087ac:	eb 11                	jmp    c01087bf <strfind+0x1f>
        if (*s == c) {
c01087ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01087b1:	0f b6 00             	movzbl (%eax),%eax
c01087b4:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01087b7:	75 02                	jne    c01087bb <strfind+0x1b>
            break;
c01087b9:	eb 0e                	jmp    c01087c9 <strfind+0x29>
        }
        s ++;
c01087bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01087bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01087c2:	0f b6 00             	movzbl (%eax),%eax
c01087c5:	84 c0                	test   %al,%al
c01087c7:	75 e5                	jne    c01087ae <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01087c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01087cc:	c9                   	leave  
c01087cd:	c3                   	ret    

c01087ce <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01087ce:	55                   	push   %ebp
c01087cf:	89 e5                	mov    %esp,%ebp
c01087d1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01087d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01087db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01087e2:	eb 04                	jmp    c01087e8 <strtol+0x1a>
        s ++;
c01087e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01087e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01087eb:	0f b6 00             	movzbl (%eax),%eax
c01087ee:	3c 20                	cmp    $0x20,%al
c01087f0:	74 f2                	je     c01087e4 <strtol+0x16>
c01087f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f5:	0f b6 00             	movzbl (%eax),%eax
c01087f8:	3c 09                	cmp    $0x9,%al
c01087fa:	74 e8                	je     c01087e4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01087fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ff:	0f b6 00             	movzbl (%eax),%eax
c0108802:	3c 2b                	cmp    $0x2b,%al
c0108804:	75 06                	jne    c010880c <strtol+0x3e>
        s ++;
c0108806:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010880a:	eb 15                	jmp    c0108821 <strtol+0x53>
    }
    else if (*s == '-') {
c010880c:	8b 45 08             	mov    0x8(%ebp),%eax
c010880f:	0f b6 00             	movzbl (%eax),%eax
c0108812:	3c 2d                	cmp    $0x2d,%al
c0108814:	75 0b                	jne    c0108821 <strtol+0x53>
        s ++, neg = 1;
c0108816:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010881a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108821:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108825:	74 06                	je     c010882d <strtol+0x5f>
c0108827:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010882b:	75 24                	jne    c0108851 <strtol+0x83>
c010882d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108830:	0f b6 00             	movzbl (%eax),%eax
c0108833:	3c 30                	cmp    $0x30,%al
c0108835:	75 1a                	jne    c0108851 <strtol+0x83>
c0108837:	8b 45 08             	mov    0x8(%ebp),%eax
c010883a:	83 c0 01             	add    $0x1,%eax
c010883d:	0f b6 00             	movzbl (%eax),%eax
c0108840:	3c 78                	cmp    $0x78,%al
c0108842:	75 0d                	jne    c0108851 <strtol+0x83>
        s += 2, base = 16;
c0108844:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108848:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010884f:	eb 2a                	jmp    c010887b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108851:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108855:	75 17                	jne    c010886e <strtol+0xa0>
c0108857:	8b 45 08             	mov    0x8(%ebp),%eax
c010885a:	0f b6 00             	movzbl (%eax),%eax
c010885d:	3c 30                	cmp    $0x30,%al
c010885f:	75 0d                	jne    c010886e <strtol+0xa0>
        s ++, base = 8;
c0108861:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108865:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010886c:	eb 0d                	jmp    c010887b <strtol+0xad>
    }
    else if (base == 0) {
c010886e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108872:	75 07                	jne    c010887b <strtol+0xad>
        base = 10;
c0108874:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010887b:	8b 45 08             	mov    0x8(%ebp),%eax
c010887e:	0f b6 00             	movzbl (%eax),%eax
c0108881:	3c 2f                	cmp    $0x2f,%al
c0108883:	7e 1b                	jle    c01088a0 <strtol+0xd2>
c0108885:	8b 45 08             	mov    0x8(%ebp),%eax
c0108888:	0f b6 00             	movzbl (%eax),%eax
c010888b:	3c 39                	cmp    $0x39,%al
c010888d:	7f 11                	jg     c01088a0 <strtol+0xd2>
            dig = *s - '0';
c010888f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108892:	0f b6 00             	movzbl (%eax),%eax
c0108895:	0f be c0             	movsbl %al,%eax
c0108898:	83 e8 30             	sub    $0x30,%eax
c010889b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010889e:	eb 48                	jmp    c01088e8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01088a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a3:	0f b6 00             	movzbl (%eax),%eax
c01088a6:	3c 60                	cmp    $0x60,%al
c01088a8:	7e 1b                	jle    c01088c5 <strtol+0xf7>
c01088aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ad:	0f b6 00             	movzbl (%eax),%eax
c01088b0:	3c 7a                	cmp    $0x7a,%al
c01088b2:	7f 11                	jg     c01088c5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01088b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b7:	0f b6 00             	movzbl (%eax),%eax
c01088ba:	0f be c0             	movsbl %al,%eax
c01088bd:	83 e8 57             	sub    $0x57,%eax
c01088c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088c3:	eb 23                	jmp    c01088e8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01088c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01088c8:	0f b6 00             	movzbl (%eax),%eax
c01088cb:	3c 40                	cmp    $0x40,%al
c01088cd:	7e 3d                	jle    c010890c <strtol+0x13e>
c01088cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d2:	0f b6 00             	movzbl (%eax),%eax
c01088d5:	3c 5a                	cmp    $0x5a,%al
c01088d7:	7f 33                	jg     c010890c <strtol+0x13e>
            dig = *s - 'A' + 10;
c01088d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01088dc:	0f b6 00             	movzbl (%eax),%eax
c01088df:	0f be c0             	movsbl %al,%eax
c01088e2:	83 e8 37             	sub    $0x37,%eax
c01088e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01088e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088eb:	3b 45 10             	cmp    0x10(%ebp),%eax
c01088ee:	7c 02                	jl     c01088f2 <strtol+0x124>
            break;
c01088f0:	eb 1a                	jmp    c010890c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01088f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01088f9:	0f af 45 10          	imul   0x10(%ebp),%eax
c01088fd:	89 c2                	mov    %eax,%edx
c01088ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108902:	01 d0                	add    %edx,%eax
c0108904:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108907:	e9 6f ff ff ff       	jmp    c010887b <strtol+0xad>

    if (endptr) {
c010890c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108910:	74 08                	je     c010891a <strtol+0x14c>
        *endptr = (char *) s;
c0108912:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108915:	8b 55 08             	mov    0x8(%ebp),%edx
c0108918:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010891a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010891e:	74 07                	je     c0108927 <strtol+0x159>
c0108920:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108923:	f7 d8                	neg    %eax
c0108925:	eb 03                	jmp    c010892a <strtol+0x15c>
c0108927:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010892a:	c9                   	leave  
c010892b:	c3                   	ret    

c010892c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010892c:	55                   	push   %ebp
c010892d:	89 e5                	mov    %esp,%ebp
c010892f:	57                   	push   %edi
c0108930:	83 ec 24             	sub    $0x24,%esp
c0108933:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108936:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108939:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010893d:	8b 55 08             	mov    0x8(%ebp),%edx
c0108940:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108943:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108946:	8b 45 10             	mov    0x10(%ebp),%eax
c0108949:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010894c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010894f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108953:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108956:	89 d7                	mov    %edx,%edi
c0108958:	f3 aa                	rep stos %al,%es:(%edi)
c010895a:	89 fa                	mov    %edi,%edx
c010895c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010895f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108962:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108965:	83 c4 24             	add    $0x24,%esp
c0108968:	5f                   	pop    %edi
c0108969:	5d                   	pop    %ebp
c010896a:	c3                   	ret    

c010896b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010896b:	55                   	push   %ebp
c010896c:	89 e5                	mov    %esp,%ebp
c010896e:	57                   	push   %edi
c010896f:	56                   	push   %esi
c0108970:	53                   	push   %ebx
c0108971:	83 ec 30             	sub    $0x30,%esp
c0108974:	8b 45 08             	mov    0x8(%ebp),%eax
c0108977:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010897a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010897d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108980:	8b 45 10             	mov    0x10(%ebp),%eax
c0108983:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108986:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108989:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010898c:	73 42                	jae    c01089d0 <memmove+0x65>
c010898e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108994:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108997:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010899a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010899d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01089a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089a3:	c1 e8 02             	shr    $0x2,%eax
c01089a6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01089a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01089ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01089ae:	89 d7                	mov    %edx,%edi
c01089b0:	89 c6                	mov    %eax,%esi
c01089b2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01089b4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01089b7:	83 e1 03             	and    $0x3,%ecx
c01089ba:	74 02                	je     c01089be <memmove+0x53>
c01089bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01089be:	89 f0                	mov    %esi,%eax
c01089c0:	89 fa                	mov    %edi,%edx
c01089c2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01089c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01089c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01089cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01089ce:	eb 36                	jmp    c0108a06 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01089d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089d3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01089d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089d9:	01 c2                	add    %eax,%edx
c01089db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089de:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01089e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089e4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01089e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089ea:	89 c1                	mov    %eax,%ecx
c01089ec:	89 d8                	mov    %ebx,%eax
c01089ee:	89 d6                	mov    %edx,%esi
c01089f0:	89 c7                	mov    %eax,%edi
c01089f2:	fd                   	std    
c01089f3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01089f5:	fc                   	cld    
c01089f6:	89 f8                	mov    %edi,%eax
c01089f8:	89 f2                	mov    %esi,%edx
c01089fa:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01089fd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108a00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108a06:	83 c4 30             	add    $0x30,%esp
c0108a09:	5b                   	pop    %ebx
c0108a0a:	5e                   	pop    %esi
c0108a0b:	5f                   	pop    %edi
c0108a0c:	5d                   	pop    %ebp
c0108a0d:	c3                   	ret    

c0108a0e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108a0e:	55                   	push   %ebp
c0108a0f:	89 e5                	mov    %esp,%ebp
c0108a11:	57                   	push   %edi
c0108a12:	56                   	push   %esi
c0108a13:	83 ec 20             	sub    $0x20,%esp
c0108a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a22:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a25:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a2b:	c1 e8 02             	shr    $0x2,%eax
c0108a2e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a36:	89 d7                	mov    %edx,%edi
c0108a38:	89 c6                	mov    %eax,%esi
c0108a3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108a3c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108a3f:	83 e1 03             	and    $0x3,%ecx
c0108a42:	74 02                	je     c0108a46 <memcpy+0x38>
c0108a44:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a46:	89 f0                	mov    %esi,%eax
c0108a48:	89 fa                	mov    %edi,%edx
c0108a4a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108a4d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108a50:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108a56:	83 c4 20             	add    $0x20,%esp
c0108a59:	5e                   	pop    %esi
c0108a5a:	5f                   	pop    %edi
c0108a5b:	5d                   	pop    %ebp
c0108a5c:	c3                   	ret    

c0108a5d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108a5d:	55                   	push   %ebp
c0108a5e:	89 e5                	mov    %esp,%ebp
c0108a60:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a66:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108a69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108a6f:	eb 30                	jmp    c0108aa1 <memcmp+0x44>
        if (*s1 != *s2) {
c0108a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a74:	0f b6 10             	movzbl (%eax),%edx
c0108a77:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a7a:	0f b6 00             	movzbl (%eax),%eax
c0108a7d:	38 c2                	cmp    %al,%dl
c0108a7f:	74 18                	je     c0108a99 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a84:	0f b6 00             	movzbl (%eax),%eax
c0108a87:	0f b6 d0             	movzbl %al,%edx
c0108a8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a8d:	0f b6 00             	movzbl (%eax),%eax
c0108a90:	0f b6 c0             	movzbl %al,%eax
c0108a93:	29 c2                	sub    %eax,%edx
c0108a95:	89 d0                	mov    %edx,%eax
c0108a97:	eb 1a                	jmp    c0108ab3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108a99:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108a9d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108aa1:	8b 45 10             	mov    0x10(%ebp),%eax
c0108aa4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108aa7:	89 55 10             	mov    %edx,0x10(%ebp)
c0108aaa:	85 c0                	test   %eax,%eax
c0108aac:	75 c3                	jne    c0108a71 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108aae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ab3:	c9                   	leave  
c0108ab4:	c3                   	ret    
