
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 c0 12 00 	lgdtl  0x12c018
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
c010001e:	bc 00 c0 12 c0       	mov    $0xc012c000,%esp
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
c0100030:	ba 78 0f 1b c0       	mov    $0xc01b0f78,%edx
c0100035:	b8 d4 dd 1a c0       	mov    $0xc01addd4,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 d4 dd 1a c0 	movl   $0xc01addd4,(%esp)
c0100051:	e8 c3 bc 00 00       	call   c010bd19 <memset>

    cons_init();                // init the console
c0100056:	e8 85 16 00 00       	call   c01016e0 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 be 10 c0 	movl   $0xc010bec0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc be 10 c0 	movl   $0xc010bedc,(%esp)
c0100070:	e8 e3 02 00 00       	call   c0100358 <cprintf>

    print_kerninfo();
c0100075:	e8 0a 09 00 00       	call   c0100984 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 a2 00 00 00       	call   c0100121 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 c6 53 00 00       	call   c010544a <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 35 20 00 00       	call   c01020be <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 ad 21 00 00       	call   c010223b <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 96 82 00 00       	call   c0108329 <vmm_init>
    sched_init();               // init scheduler
c0100093:	e8 05 ae 00 00       	call   c010ae9d <sched_init>
    proc_init();                // init process table
c0100098:	e8 c9 a7 00 00       	call   c010a866 <proc_init>
    
    ide_init();                 // init ide devices
c010009d:	e8 6f 17 00 00       	call   c0101811 <ide_init>
    swap_init();                // init swap
c01000a2:	e8 6e 6a 00 00       	call   c0106b15 <swap_init>

    clock_init();               // init clock interrupt
c01000a7:	e8 ea 0d 00 00       	call   c0100e96 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ac:	e8 7b 1f 00 00       	call   c010202c <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b1:	e8 6f a9 00 00       	call   c010aa25 <cpu_idle>

c01000b6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b6:	55                   	push   %ebp
c01000b7:	89 e5                	mov    %esp,%ebp
c01000b9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c3:	00 
c01000c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000cb:	00 
c01000cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d3:	e8 f0 0c 00 00       	call   c0100dc8 <mon_backtrace>
}
c01000d8:	c9                   	leave  
c01000d9:	c3                   	ret    

c01000da <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000da:	55                   	push   %ebp
c01000db:	89 e5                	mov    %esp,%ebp
c01000dd:	53                   	push   %ebx
c01000de:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ed:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f9:	89 04 24             	mov    %eax,(%esp)
c01000fc:	e8 b5 ff ff ff       	call   c01000b6 <grade_backtrace2>
}
c0100101:	83 c4 14             	add    $0x14,%esp
c0100104:	5b                   	pop    %ebx
c0100105:	5d                   	pop    %ebp
c0100106:	c3                   	ret    

c0100107 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100107:	55                   	push   %ebp
c0100108:	89 e5                	mov    %esp,%ebp
c010010a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100110:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100114:	8b 45 08             	mov    0x8(%ebp),%eax
c0100117:	89 04 24             	mov    %eax,(%esp)
c010011a:	e8 bb ff ff ff       	call   c01000da <grade_backtrace1>
}
c010011f:	c9                   	leave  
c0100120:	c3                   	ret    

c0100121 <grade_backtrace>:

void
grade_backtrace(void) {
c0100121:	55                   	push   %ebp
c0100122:	89 e5                	mov    %esp,%ebp
c0100124:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100127:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010012c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100133:	ff 
c0100134:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013f:	e8 c3 ff ff ff       	call   c0100107 <grade_backtrace0>
}
c0100144:	c9                   	leave  
c0100145:	c3                   	ret    

c0100146 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100146:	55                   	push   %ebp
c0100147:	89 e5                	mov    %esp,%ebp
c0100149:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100152:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100155:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100158:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015c:	0f b7 c0             	movzwl %ax,%eax
c010015f:	83 e0 03             	and    $0x3,%eax
c0100162:	89 c2                	mov    %eax,%edx
c0100164:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c0100169:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100171:	c7 04 24 e1 be 10 c0 	movl   $0xc010bee1,(%esp)
c0100178:	e8 db 01 00 00       	call   c0100358 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100181:	0f b7 d0             	movzwl %ax,%edx
c0100184:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c0100189:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100191:	c7 04 24 ef be 10 c0 	movl   $0xc010beef,(%esp)
c0100198:	e8 bb 01 00 00       	call   c0100358 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a1:	0f b7 d0             	movzwl %ax,%edx
c01001a4:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c01001a9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b1:	c7 04 24 fd be 10 c0 	movl   $0xc010befd,(%esp)
c01001b8:	e8 9b 01 00 00       	call   c0100358 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c1:	0f b7 d0             	movzwl %ax,%edx
c01001c4:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c01001c9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d1:	c7 04 24 0b bf 10 c0 	movl   $0xc010bf0b,(%esp)
c01001d8:	e8 7b 01 00 00       	call   c0100358 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e1:	0f b7 d0             	movzwl %ax,%edx
c01001e4:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c01001e9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f1:	c7 04 24 19 bf 10 c0 	movl   $0xc010bf19,(%esp)
c01001f8:	e8 5b 01 00 00       	call   c0100358 <cprintf>
    round ++;
c01001fd:	a1 e0 dd 1a c0       	mov    0xc01adde0,%eax
c0100202:	83 c0 01             	add    $0x1,%eax
c0100205:	a3 e0 dd 1a c0       	mov    %eax,0xc01adde0
}
c010020a:	c9                   	leave  
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100214:	5d                   	pop    %ebp
c0100215:	c3                   	ret    

c0100216 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100216:	55                   	push   %ebp
c0100217:	89 e5                	mov    %esp,%ebp
c0100219:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021c:	e8 25 ff ff ff       	call   c0100146 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100221:	c7 04 24 28 bf 10 c0 	movl   $0xc010bf28,(%esp)
c0100228:	e8 2b 01 00 00       	call   c0100358 <cprintf>
    lab1_switch_to_user();
c010022d:	e8 da ff ff ff       	call   c010020c <lab1_switch_to_user>
    lab1_print_cur_status();
c0100232:	e8 0f ff ff ff       	call   c0100146 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100237:	c7 04 24 48 bf 10 c0 	movl   $0xc010bf48,(%esp)
c010023e:	e8 15 01 00 00       	call   c0100358 <cprintf>
    lab1_switch_to_kernel();
c0100243:	e8 c9 ff ff ff       	call   c0100211 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100248:	e8 f9 fe ff ff       	call   c0100146 <lab1_print_cur_status>
}
c010024d:	c9                   	leave  
c010024e:	c3                   	ret    

c010024f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024f:	55                   	push   %ebp
c0100250:	89 e5                	mov    %esp,%ebp
c0100252:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100255:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100259:	74 13                	je     c010026e <readline+0x1f>
        cprintf("%s", prompt);
c010025b:	8b 45 08             	mov    0x8(%ebp),%eax
c010025e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100262:	c7 04 24 67 bf 10 c0 	movl   $0xc010bf67,(%esp)
c0100269:	e8 ea 00 00 00       	call   c0100358 <cprintf>
    }
    int i = 0, c;
c010026e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100275:	e8 66 01 00 00       	call   c01003e0 <getchar>
c010027a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010027d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100281:	79 07                	jns    c010028a <readline+0x3b>
            return NULL;
c0100283:	b8 00 00 00 00       	mov    $0x0,%eax
c0100288:	eb 79                	jmp    c0100303 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010028a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010028e:	7e 28                	jle    c01002b8 <readline+0x69>
c0100290:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100297:	7f 1f                	jg     c01002b8 <readline+0x69>
            cputchar(c);
c0100299:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029c:	89 04 24             	mov    %eax,(%esp)
c010029f:	e8 da 00 00 00       	call   c010037e <cputchar>
            buf[i ++] = c;
c01002a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a7:	8d 50 01             	lea    0x1(%eax),%edx
c01002aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002b0:	88 90 00 de 1a c0    	mov    %dl,-0x3fe52200(%eax)
c01002b6:	eb 46                	jmp    c01002fe <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002bc:	75 17                	jne    c01002d5 <readline+0x86>
c01002be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c2:	7e 11                	jle    c01002d5 <readline+0x86>
            cputchar(c);
c01002c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c7:	89 04 24             	mov    %eax,(%esp)
c01002ca:	e8 af 00 00 00       	call   c010037e <cputchar>
            i --;
c01002cf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002d3:	eb 29                	jmp    c01002fe <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d9:	74 06                	je     c01002e1 <readline+0x92>
c01002db:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002df:	75 1d                	jne    c01002fe <readline+0xaf>
            cputchar(c);
c01002e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e4:	89 04 24             	mov    %eax,(%esp)
c01002e7:	e8 92 00 00 00       	call   c010037e <cputchar>
            buf[i] = '\0';
c01002ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ef:	05 00 de 1a c0       	add    $0xc01ade00,%eax
c01002f4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f7:	b8 00 de 1a c0       	mov    $0xc01ade00,%eax
c01002fc:	eb 05                	jmp    c0100303 <readline+0xb4>
        }
    }
c01002fe:	e9 72 ff ff ff       	jmp    c0100275 <readline+0x26>
}
c0100303:	c9                   	leave  
c0100304:	c3                   	ret    

c0100305 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100305:	55                   	push   %ebp
c0100306:	89 e5                	mov    %esp,%ebp
c0100308:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030b:	8b 45 08             	mov    0x8(%ebp),%eax
c010030e:	89 04 24             	mov    %eax,(%esp)
c0100311:	e8 f6 13 00 00       	call   c010170c <cons_putc>
    (*cnt) ++;
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	8b 00                	mov    (%eax),%eax
c010031b:	8d 50 01             	lea    0x1(%eax),%edx
c010031e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100321:	89 10                	mov    %edx,(%eax)
}
c0100323:	c9                   	leave  
c0100324:	c3                   	ret    

c0100325 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100325:	55                   	push   %ebp
c0100326:	89 e5                	mov    %esp,%ebp
c0100328:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100332:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100335:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100339:	8b 45 08             	mov    0x8(%ebp),%eax
c010033c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100340:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100343:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100347:	c7 04 24 05 03 10 c0 	movl   $0xc0100305,(%esp)
c010034e:	e8 07 b1 00 00       	call   c010b45a <vprintfmt>
    return cnt;
c0100353:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100356:	c9                   	leave  
c0100357:	c3                   	ret    

c0100358 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100358:	55                   	push   %ebp
c0100359:	89 e5                	mov    %esp,%ebp
c010035b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100361:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100364:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100367:	89 44 24 04          	mov    %eax,0x4(%esp)
c010036b:	8b 45 08             	mov    0x8(%ebp),%eax
c010036e:	89 04 24             	mov    %eax,(%esp)
c0100371:	e8 af ff ff ff       	call   c0100325 <vcprintf>
c0100376:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100379:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037c:	c9                   	leave  
c010037d:	c3                   	ret    

c010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037e:	55                   	push   %ebp
c010037f:	89 e5                	mov    %esp,%ebp
c0100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	89 04 24             	mov    %eax,(%esp)
c010038a:	e8 7d 13 00 00       	call   c010170c <cons_putc>
}
c010038f:	c9                   	leave  
c0100390:	c3                   	ret    

c0100391 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100391:	55                   	push   %ebp
c0100392:	89 e5                	mov    %esp,%ebp
c0100394:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100397:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010039e:	eb 13                	jmp    c01003b3 <cputs+0x22>
        cputch(c, &cnt);
c01003a0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a4:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ab:	89 04 24             	mov    %eax,(%esp)
c01003ae:	e8 52 ff ff ff       	call   c0100305 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b6:	8d 50 01             	lea    0x1(%eax),%edx
c01003b9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bc:	0f b6 00             	movzbl (%eax),%eax
c01003bf:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c6:	75 d8                	jne    c01003a0 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003cf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d6:	e8 2a ff ff ff       	call   c0100305 <cputch>
    return cnt;
c01003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003de:	c9                   	leave  
c01003df:	c3                   	ret    

c01003e0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e0:	55                   	push   %ebp
c01003e1:	89 e5                	mov    %esp,%ebp
c01003e3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e6:	e8 5d 13 00 00       	call   c0101748 <cons_getc>
c01003eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f2:	74 f2                	je     c01003e6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f7:	c9                   	leave  
c01003f8:	c3                   	ret    

c01003f9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f9:	55                   	push   %ebp
c01003fa:	89 e5                	mov    %esp,%ebp
c01003fc:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100402:	8b 00                	mov    (%eax),%eax
c0100404:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100407:	8b 45 10             	mov    0x10(%ebp),%eax
c010040a:	8b 00                	mov    (%eax),%eax
c010040c:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100416:	e9 d2 00 00 00       	jmp    c01004ed <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010041b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010041e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100421:	01 d0                	add    %edx,%eax
c0100423:	89 c2                	mov    %eax,%edx
c0100425:	c1 ea 1f             	shr    $0x1f,%edx
c0100428:	01 d0                	add    %edx,%eax
c010042a:	d1 f8                	sar    %eax
c010042c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100432:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100435:	eb 04                	jmp    c010043b <stab_binsearch+0x42>
            m --;
c0100437:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010043e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100441:	7c 1f                	jl     c0100462 <stab_binsearch+0x69>
c0100443:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100446:	89 d0                	mov    %edx,%eax
c0100448:	01 c0                	add    %eax,%eax
c010044a:	01 d0                	add    %edx,%eax
c010044c:	c1 e0 02             	shl    $0x2,%eax
c010044f:	89 c2                	mov    %eax,%edx
c0100451:	8b 45 08             	mov    0x8(%ebp),%eax
c0100454:	01 d0                	add    %edx,%eax
c0100456:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010045a:	0f b6 c0             	movzbl %al,%eax
c010045d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100460:	75 d5                	jne    c0100437 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100462:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100465:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100468:	7d 0b                	jge    c0100475 <stab_binsearch+0x7c>
            l = true_m + 1;
c010046a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010046d:	83 c0 01             	add    $0x1,%eax
c0100470:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100473:	eb 78                	jmp    c01004ed <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100475:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010047c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047f:	89 d0                	mov    %edx,%eax
c0100481:	01 c0                	add    %eax,%eax
c0100483:	01 d0                	add    %edx,%eax
c0100485:	c1 e0 02             	shl    $0x2,%eax
c0100488:	89 c2                	mov    %eax,%edx
c010048a:	8b 45 08             	mov    0x8(%ebp),%eax
c010048d:	01 d0                	add    %edx,%eax
c010048f:	8b 40 08             	mov    0x8(%eax),%eax
c0100492:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100495:	73 13                	jae    c01004aa <stab_binsearch+0xb1>
            *region_left = m;
c0100497:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a2:	83 c0 01             	add    $0x1,%eax
c01004a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a8:	eb 43                	jmp    c01004ed <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ad:	89 d0                	mov    %edx,%eax
c01004af:	01 c0                	add    %eax,%eax
c01004b1:	01 d0                	add    %edx,%eax
c01004b3:	c1 e0 02             	shl    $0x2,%eax
c01004b6:	89 c2                	mov    %eax,%edx
c01004b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004bb:	01 d0                	add    %edx,%eax
c01004bd:	8b 40 08             	mov    0x8(%eax),%eax
c01004c0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004c3:	76 16                	jbe    c01004db <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004cb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ce:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d3:	83 e8 01             	sub    $0x1,%eax
c01004d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d9:	eb 12                	jmp    c01004ed <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004de:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f3:	0f 8e 22 ff ff ff    	jle    c010041b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fd:	75 0f                	jne    c010050e <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100502:	8b 00                	mov    (%eax),%eax
c0100504:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100507:	8b 45 10             	mov    0x10(%ebp),%eax
c010050a:	89 10                	mov    %edx,(%eax)
c010050c:	eb 3f                	jmp    c010054d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c010050e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100516:	eb 04                	jmp    c010051c <stab_binsearch+0x123>
c0100518:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010051c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051f:	8b 00                	mov    (%eax),%eax
c0100521:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100524:	7d 1f                	jge    c0100545 <stab_binsearch+0x14c>
c0100526:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100529:	89 d0                	mov    %edx,%eax
c010052b:	01 c0                	add    %eax,%eax
c010052d:	01 d0                	add    %edx,%eax
c010052f:	c1 e0 02             	shl    $0x2,%eax
c0100532:	89 c2                	mov    %eax,%edx
c0100534:	8b 45 08             	mov    0x8(%ebp),%eax
c0100537:	01 d0                	add    %edx,%eax
c0100539:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053d:	0f b6 c0             	movzbl %al,%eax
c0100540:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100543:	75 d3                	jne    c0100518 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054b:	89 10                	mov    %edx,(%eax)
    }
}
c010054d:	c9                   	leave  
c010054e:	c3                   	ret    

c010054f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054f:	55                   	push   %ebp
c0100550:	89 e5                	mov    %esp,%ebp
c0100552:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100558:	c7 00 6c bf 10 c0    	movl   $0xc010bf6c,(%eax)
    info->eip_line = 0;
c010055e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100568:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056b:	c7 40 08 6c bf 10 c0 	movl   $0xc010bf6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100575:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100582:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100585:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100588:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058f:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100596:	76 21                	jbe    c01005b9 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100598:	c7 45 f4 c0 e5 10 c0 	movl   $0xc010e5c0,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059f:	c7 45 f0 b0 30 12 c0 	movl   $0xc01230b0,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a6:	c7 45 ec b1 30 12 c0 	movl   $0xc01230b1,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005ad:	c7 45 e8 d4 91 12 c0 	movl   $0xc01291d4,-0x18(%ebp)
c01005b4:	e9 ea 00 00 00       	jmp    c01006a3 <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b9:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005c0:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01005c5:	85 c0                	test   %eax,%eax
c01005c7:	74 11                	je     c01005da <debuginfo_eip+0x8b>
c01005c9:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01005ce:	8b 40 18             	mov    0x18(%eax),%eax
c01005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d8:	75 0a                	jne    c01005e4 <debuginfo_eip+0x95>
            return -1;
c01005da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005df:	e9 9e 03 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005ee:	00 
c01005ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f6:	00 
c01005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005fe:	89 04 24             	mov    %eax,(%esp)
c0100601:	e8 1f 86 00 00       	call   c0108c25 <user_mem_check>
c0100606:	85 c0                	test   %eax,%eax
c0100608:	75 0a                	jne    c0100614 <debuginfo_eip+0xc5>
            return -1;
c010060a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060f:	e9 6e 03 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c0100614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100617:	8b 00                	mov    (%eax),%eax
c0100619:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c010061c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061f:	8b 40 04             	mov    0x4(%eax),%eax
c0100622:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100628:	8b 40 08             	mov    0x8(%eax),%eax
c010062b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c010062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100631:	8b 40 0c             	mov    0xc(%eax),%eax
c0100634:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100637:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	29 c2                	sub    %eax,%edx
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100649:	00 
c010064a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010064e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100652:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100655:	89 04 24             	mov    %eax,(%esp)
c0100658:	e8 c8 85 00 00       	call   c0108c25 <user_mem_check>
c010065d:	85 c0                	test   %eax,%eax
c010065f:	75 0a                	jne    c010066b <debuginfo_eip+0x11c>
            return -1;
c0100661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100666:	e9 17 03 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c010066b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c2                	sub    %eax,%edx
c0100673:	89 d0                	mov    %edx,%eax
c0100675:	89 c2                	mov    %eax,%edx
c0100677:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010067a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100681:	00 
c0100682:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100686:	89 44 24 04          	mov    %eax,0x4(%esp)
c010068a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010068d:	89 04 24             	mov    %eax,(%esp)
c0100690:	e8 90 85 00 00       	call   c0108c25 <user_mem_check>
c0100695:	85 c0                	test   %eax,%eax
c0100697:	75 0a                	jne    c01006a3 <debuginfo_eip+0x154>
            return -1;
c0100699:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010069e:	e9 df 02 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a9:	76 0d                	jbe    c01006b8 <debuginfo_eip+0x169>
c01006ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006ae:	83 e8 01             	sub    $0x1,%eax
c01006b1:	0f b6 00             	movzbl (%eax),%eax
c01006b4:	84 c0                	test   %al,%al
c01006b6:	74 0a                	je     c01006c2 <debuginfo_eip+0x173>
        return -1;
c01006b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006bd:	e9 c0 02 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006cf:	29 c2                	sub    %eax,%edx
c01006d1:	89 d0                	mov    %edx,%eax
c01006d3:	c1 f8 02             	sar    $0x2,%eax
c01006d6:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006dc:	83 e8 01             	sub    $0x1,%eax
c01006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e9:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006f0:	00 
c01006f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100702:	89 04 24             	mov    %eax,(%esp)
c0100705:	e8 ef fc ff ff       	call   c01003f9 <stab_binsearch>
    if (lfile == 0)
c010070a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010070d:	85 c0                	test   %eax,%eax
c010070f:	75 0a                	jne    c010071b <debuginfo_eip+0x1cc>
        return -1;
c0100711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100716:	e9 67 02 00 00       	jmp    c0100982 <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010071b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010071e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100721:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100724:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100727:	8b 45 08             	mov    0x8(%ebp),%eax
c010072a:	89 44 24 10          	mov    %eax,0x10(%esp)
c010072e:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100735:	00 
c0100736:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100739:	89 44 24 08          	mov    %eax,0x8(%esp)
c010073d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100740:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100744:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100747:	89 04 24             	mov    %eax,(%esp)
c010074a:	e8 aa fc ff ff       	call   c01003f9 <stab_binsearch>

    if (lfun <= rfun) {
c010074f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100752:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100755:	39 c2                	cmp    %eax,%edx
c0100757:	7f 7c                	jg     c01007d5 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100759:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075c:	89 c2                	mov    %eax,%edx
c010075e:	89 d0                	mov    %edx,%eax
c0100760:	01 c0                	add    %eax,%eax
c0100762:	01 d0                	add    %edx,%eax
c0100764:	c1 e0 02             	shl    $0x2,%eax
c0100767:	89 c2                	mov    %eax,%edx
c0100769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076c:	01 d0                	add    %edx,%eax
c010076e:	8b 10                	mov    (%eax),%edx
c0100770:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100776:	29 c1                	sub    %eax,%ecx
c0100778:	89 c8                	mov    %ecx,%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	73 22                	jae    c01007a0 <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	8b 10                	mov    (%eax),%edx
c0100795:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100798:	01 c2                	add    %eax,%edx
c010079a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010079d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01007a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a3:	89 c2                	mov    %eax,%edx
c01007a5:	89 d0                	mov    %edx,%eax
c01007a7:	01 c0                	add    %eax,%eax
c01007a9:	01 d0                	add    %edx,%eax
c01007ab:	c1 e0 02             	shl    $0x2,%eax
c01007ae:	89 c2                	mov    %eax,%edx
c01007b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b3:	01 d0                	add    %edx,%eax
c01007b5:	8b 50 08             	mov    0x8(%eax),%edx
c01007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bb:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c1:	8b 40 10             	mov    0x10(%eax),%eax
c01007c4:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007d3:	eb 15                	jmp    c01007ea <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01007db:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ed:	8b 40 08             	mov    0x8(%eax),%eax
c01007f0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f7:	00 
c01007f8:	89 04 24             	mov    %eax,(%esp)
c01007fb:	e8 8d b3 00 00       	call   c010bb8d <strfind>
c0100800:	89 c2                	mov    %eax,%edx
c0100802:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100805:	8b 40 08             	mov    0x8(%eax),%eax
c0100808:	29 c2                	sub    %eax,%edx
c010080a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010080d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100810:	8b 45 08             	mov    0x8(%ebp),%eax
c0100813:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100817:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010081e:	00 
c010081f:	8d 45 c8             	lea    -0x38(%ebp),%eax
c0100822:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100826:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100829:	89 44 24 04          	mov    %eax,0x4(%esp)
c010082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100830:	89 04 24             	mov    %eax,(%esp)
c0100833:	e8 c1 fb ff ff       	call   c01003f9 <stab_binsearch>
    if (lline <= rline) {
c0100838:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010083b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010083e:	39 c2                	cmp    %eax,%edx
c0100840:	7f 24                	jg     c0100866 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c0100842:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100845:	89 c2                	mov    %eax,%edx
c0100847:	89 d0                	mov    %edx,%eax
c0100849:	01 c0                	add    %eax,%eax
c010084b:	01 d0                	add    %edx,%eax
c010084d:	c1 e0 02             	shl    $0x2,%eax
c0100850:	89 c2                	mov    %eax,%edx
c0100852:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010085b:	0f b7 d0             	movzwl %ax,%edx
c010085e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100861:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100864:	eb 13                	jmp    c0100879 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100866:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010086b:	e9 12 01 00 00       	jmp    c0100982 <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100870:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100873:	83 e8 01             	sub    $0x1,%eax
c0100876:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100879:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010087c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087f:	39 c2                	cmp    %eax,%edx
c0100881:	7c 56                	jl     c01008d9 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c0100883:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100886:	89 c2                	mov    %eax,%edx
c0100888:	89 d0                	mov    %edx,%eax
c010088a:	01 c0                	add    %eax,%eax
c010088c:	01 d0                	add    %edx,%eax
c010088e:	c1 e0 02             	shl    $0x2,%eax
c0100891:	89 c2                	mov    %eax,%edx
c0100893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100896:	01 d0                	add    %edx,%eax
c0100898:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010089c:	3c 84                	cmp    $0x84,%al
c010089e:	74 39                	je     c01008d9 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01008a0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008a3:	89 c2                	mov    %eax,%edx
c01008a5:	89 d0                	mov    %edx,%eax
c01008a7:	01 c0                	add    %eax,%eax
c01008a9:	01 d0                	add    %edx,%eax
c01008ab:	c1 e0 02             	shl    $0x2,%eax
c01008ae:	89 c2                	mov    %eax,%edx
c01008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008b3:	01 d0                	add    %edx,%eax
c01008b5:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b9:	3c 64                	cmp    $0x64,%al
c01008bb:	75 b3                	jne    c0100870 <debuginfo_eip+0x321>
c01008bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008c0:	89 c2                	mov    %eax,%edx
c01008c2:	89 d0                	mov    %edx,%eax
c01008c4:	01 c0                	add    %eax,%eax
c01008c6:	01 d0                	add    %edx,%eax
c01008c8:	c1 e0 02             	shl    $0x2,%eax
c01008cb:	89 c2                	mov    %eax,%edx
c01008cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d0:	01 d0                	add    %edx,%eax
c01008d2:	8b 40 08             	mov    0x8(%eax),%eax
c01008d5:	85 c0                	test   %eax,%eax
c01008d7:	74 97                	je     c0100870 <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008df:	39 c2                	cmp    %eax,%edx
c01008e1:	7c 46                	jl     c0100929 <debuginfo_eip+0x3da>
c01008e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e6:	89 c2                	mov    %eax,%edx
c01008e8:	89 d0                	mov    %edx,%eax
c01008ea:	01 c0                	add    %eax,%eax
c01008ec:	01 d0                	add    %edx,%eax
c01008ee:	c1 e0 02             	shl    $0x2,%eax
c01008f1:	89 c2                	mov    %eax,%edx
c01008f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f6:	01 d0                	add    %edx,%eax
c01008f8:	8b 10                	mov    (%eax),%edx
c01008fa:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100900:	29 c1                	sub    %eax,%ecx
c0100902:	89 c8                	mov    %ecx,%eax
c0100904:	39 c2                	cmp    %eax,%edx
c0100906:	73 21                	jae    c0100929 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100908:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010090b:	89 c2                	mov    %eax,%edx
c010090d:	89 d0                	mov    %edx,%eax
c010090f:	01 c0                	add    %eax,%eax
c0100911:	01 d0                	add    %edx,%eax
c0100913:	c1 e0 02             	shl    $0x2,%eax
c0100916:	89 c2                	mov    %eax,%edx
c0100918:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010091b:	01 d0                	add    %edx,%eax
c010091d:	8b 10                	mov    (%eax),%edx
c010091f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100922:	01 c2                	add    %eax,%edx
c0100924:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100927:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010092c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092f:	39 c2                	cmp    %eax,%edx
c0100931:	7d 4a                	jge    c010097d <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c0100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100936:	83 c0 01             	add    $0x1,%eax
c0100939:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010093c:	eb 18                	jmp    c0100956 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010093e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100941:	8b 40 14             	mov    0x14(%eax),%eax
c0100944:	8d 50 01             	lea    0x1(%eax),%edx
c0100947:	8b 45 0c             	mov    0xc(%ebp),%eax
c010094a:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010094d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100950:	83 c0 01             	add    $0x1,%eax
c0100953:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100956:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100959:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010095c:	39 c2                	cmp    %eax,%edx
c010095e:	7d 1d                	jge    c010097d <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100960:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100963:	89 c2                	mov    %eax,%edx
c0100965:	89 d0                	mov    %edx,%eax
c0100967:	01 c0                	add    %eax,%eax
c0100969:	01 d0                	add    %edx,%eax
c010096b:	c1 e0 02             	shl    $0x2,%eax
c010096e:	89 c2                	mov    %eax,%edx
c0100970:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100973:	01 d0                	add    %edx,%eax
c0100975:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100979:	3c a0                	cmp    $0xa0,%al
c010097b:	74 c1                	je     c010093e <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010097d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100982:	c9                   	leave  
c0100983:	c3                   	ret    

c0100984 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100984:	55                   	push   %ebp
c0100985:	89 e5                	mov    %esp,%ebp
c0100987:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010098a:	c7 04 24 76 bf 10 c0 	movl   $0xc010bf76,(%esp)
c0100991:	e8 c2 f9 ff ff       	call   c0100358 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100996:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c010099d:	c0 
c010099e:	c7 04 24 8f bf 10 c0 	movl   $0xc010bf8f,(%esp)
c01009a5:	e8 ae f9 ff ff       	call   c0100358 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009aa:	c7 44 24 04 a2 be 10 	movl   $0xc010bea2,0x4(%esp)
c01009b1:	c0 
c01009b2:	c7 04 24 a7 bf 10 c0 	movl   $0xc010bfa7,(%esp)
c01009b9:	e8 9a f9 ff ff       	call   c0100358 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009be:	c7 44 24 04 d4 dd 1a 	movl   $0xc01addd4,0x4(%esp)
c01009c5:	c0 
c01009c6:	c7 04 24 bf bf 10 c0 	movl   $0xc010bfbf,(%esp)
c01009cd:	e8 86 f9 ff ff       	call   c0100358 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009d2:	c7 44 24 04 78 0f 1b 	movl   $0xc01b0f78,0x4(%esp)
c01009d9:	c0 
c01009da:	c7 04 24 d7 bf 10 c0 	movl   $0xc010bfd7,(%esp)
c01009e1:	e8 72 f9 ff ff       	call   c0100358 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e6:	b8 78 0f 1b c0       	mov    $0xc01b0f78,%eax
c01009eb:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009f1:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f6:	29 c2                	sub    %eax,%edx
c01009f8:	89 d0                	mov    %edx,%eax
c01009fa:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100a00:	85 c0                	test   %eax,%eax
c0100a02:	0f 48 c2             	cmovs  %edx,%eax
c0100a05:	c1 f8 0a             	sar    $0xa,%eax
c0100a08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a0c:	c7 04 24 f0 bf 10 c0 	movl   $0xc010bff0,(%esp)
c0100a13:	e8 40 f9 ff ff       	call   c0100358 <cprintf>
}
c0100a18:	c9                   	leave  
c0100a19:	c3                   	ret    

c0100a1a <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a1a:	55                   	push   %ebp
c0100a1b:	89 e5                	mov    %esp,%ebp
c0100a1d:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a23:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a2d:	89 04 24             	mov    %eax,(%esp)
c0100a30:	e8 1a fb ff ff       	call   c010054f <debuginfo_eip>
c0100a35:	85 c0                	test   %eax,%eax
c0100a37:	74 15                	je     c0100a4e <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a40:	c7 04 24 1a c0 10 c0 	movl   $0xc010c01a,(%esp)
c0100a47:	e8 0c f9 ff ff       	call   c0100358 <cprintf>
c0100a4c:	eb 6d                	jmp    c0100abb <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a55:	eb 1c                	jmp    c0100a73 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5d:	01 d0                	add    %edx,%eax
c0100a5f:	0f b6 00             	movzbl (%eax),%eax
c0100a62:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a6b:	01 ca                	add    %ecx,%edx
c0100a6d:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a76:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a79:	7f dc                	jg     c0100a57 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a7b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a84:	01 d0                	add    %edx,%eax
c0100a86:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a8c:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8f:	89 d1                	mov    %edx,%ecx
c0100a91:	29 c1                	sub    %eax,%ecx
c0100a93:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a96:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a99:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a9d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100aa3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaf:	c7 04 24 36 c0 10 c0 	movl   $0xc010c036,(%esp)
c0100ab6:	e8 9d f8 ff ff       	call   c0100358 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100abb:	c9                   	leave  
c0100abc:	c3                   	ret    

c0100abd <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100abd:	55                   	push   %ebp
c0100abe:	89 e5                	mov    %esp,%ebp
c0100ac0:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100ac3:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100acc:	c9                   	leave  
c0100acd:	c3                   	ret    

c0100ace <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ace:	55                   	push   %ebp
c0100acf:	89 e5                	mov    %esp,%ebp
c0100ad1:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100ad4:	89 e8                	mov    %ebp,%eax
c0100ad6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
c0100adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c0100adf:	e8 d9 ff ff ff       	call   c0100abd <read_eip>
c0100ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
c0100ae7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100aee:	e9 88 00 00 00       	jmp    c0100b7b <print_stackframe+0xad>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af6:	83 c0 08             	add    $0x8,%eax
c0100af9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        int j;
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0a:	c7 04 24 48 c0 10 c0 	movl   $0xc010c048,(%esp)
c0100b11:	e8 42 f8 ff ff       	call   c0100358 <cprintf>
        for (j = 0; j < 4; j++)
c0100b16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b1d:	eb 25                	jmp    c0100b44 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100b1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b2c:	01 d0                	add    %edx,%eax
c0100b2e:	8b 00                	mov    (%eax),%eax
c0100b30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b34:	c7 04 24 64 c0 10 c0 	movl   $0xc010c064,(%esp)
c0100b3b:	e8 18 f8 ff ff       	call   c0100358 <cprintf>
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
        uint32_t *args = (uint32_t *)ebp + 2;
        int j;
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        for (j = 0; j < 4; j++)
c0100b40:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b44:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b48:	7e d5                	jle    c0100b1f <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        cprintf("\n");
c0100b4a:	c7 04 24 6c c0 10 c0 	movl   $0xc010c06c,(%esp)
c0100b51:	e8 02 f8 ff ff       	call   c0100358 <cprintf>
        print_debuginfo(eip - 1);
c0100b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b59:	83 e8 01             	sub    $0x1,%eax
c0100b5c:	89 04 24             	mov    %eax,(%esp)
c0100b5f:	e8 b6 fe ff ff       	call   c0100a1a <print_debuginfo>
        eip = *(uint32_t *)(ebp + 4);
c0100b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b67:	83 c0 04             	add    $0x4,%eax
c0100b6a:	8b 00                	mov    (%eax),%eax
c0100b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)ebp;
c0100b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b72:	8b 00                	mov    (%eax),%eax
c0100b74:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
c0100b77:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b7b:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b7f:	7f 0a                	jg     c0100b8b <print_stackframe+0xbd>
c0100b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b85:	0f 85 68 ff ff ff    	jne    c0100af3 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = *(uint32_t *)(ebp + 4);
        ebp = *(uint32_t *)ebp;
    }
}
c0100b8b:	c9                   	leave  
c0100b8c:	c3                   	ret    

c0100b8d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b8d:	55                   	push   %ebp
c0100b8e:	89 e5                	mov    %esp,%ebp
c0100b90:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b9a:	eb 0c                	jmp    c0100ba8 <parse+0x1b>
            *buf ++ = '\0';
c0100b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9f:	8d 50 01             	lea    0x1(%eax),%edx
c0100ba2:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba5:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bab:	0f b6 00             	movzbl (%eax),%eax
c0100bae:	84 c0                	test   %al,%al
c0100bb0:	74 1d                	je     c0100bcf <parse+0x42>
c0100bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb5:	0f b6 00             	movzbl (%eax),%eax
c0100bb8:	0f be c0             	movsbl %al,%eax
c0100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bbf:	c7 04 24 f0 c0 10 c0 	movl   $0xc010c0f0,(%esp)
c0100bc6:	e8 8f af 00 00       	call   c010bb5a <strchr>
c0100bcb:	85 c0                	test   %eax,%eax
c0100bcd:	75 cd                	jne    c0100b9c <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bd2:	0f b6 00             	movzbl (%eax),%eax
c0100bd5:	84 c0                	test   %al,%al
c0100bd7:	75 02                	jne    c0100bdb <parse+0x4e>
            break;
c0100bd9:	eb 67                	jmp    c0100c42 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bdb:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bdf:	75 14                	jne    c0100bf5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100be1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be8:	00 
c0100be9:	c7 04 24 f5 c0 10 c0 	movl   $0xc010c0f5,(%esp)
c0100bf0:	e8 63 f7 ff ff       	call   c0100358 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf8:	8d 50 01             	lea    0x1(%eax),%edx
c0100bfb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bfe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c08:	01 c2                	add    %eax,%edx
c0100c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0f:	eb 04                	jmp    c0100c15 <parse+0x88>
            buf ++;
c0100c11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c18:	0f b6 00             	movzbl (%eax),%eax
c0100c1b:	84 c0                	test   %al,%al
c0100c1d:	74 1d                	je     c0100c3c <parse+0xaf>
c0100c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c22:	0f b6 00             	movzbl (%eax),%eax
c0100c25:	0f be c0             	movsbl %al,%eax
c0100c28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2c:	c7 04 24 f0 c0 10 c0 	movl   $0xc010c0f0,(%esp)
c0100c33:	e8 22 af 00 00       	call   c010bb5a <strchr>
c0100c38:	85 c0                	test   %eax,%eax
c0100c3a:	74 d5                	je     c0100c11 <parse+0x84>
            buf ++;
        }
    }
c0100c3c:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c3d:	e9 66 ff ff ff       	jmp    c0100ba8 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c45:	c9                   	leave  
c0100c46:	c3                   	ret    

c0100c47 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c47:	55                   	push   %ebp
c0100c48:	89 e5                	mov    %esp,%ebp
c0100c4a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c4d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c57:	89 04 24             	mov    %eax,(%esp)
c0100c5a:	e8 2e ff ff ff       	call   c0100b8d <parse>
c0100c5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c66:	75 0a                	jne    c0100c72 <runcmd+0x2b>
        return 0;
c0100c68:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c6d:	e9 85 00 00 00       	jmp    c0100cf7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c79:	eb 5c                	jmp    c0100cd7 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c7b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c81:	89 d0                	mov    %edx,%eax
c0100c83:	01 c0                	add    %eax,%eax
c0100c85:	01 d0                	add    %edx,%eax
c0100c87:	c1 e0 02             	shl    $0x2,%eax
c0100c8a:	05 20 c0 12 c0       	add    $0xc012c020,%eax
c0100c8f:	8b 00                	mov    (%eax),%eax
c0100c91:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c95:	89 04 24             	mov    %eax,(%esp)
c0100c98:	e8 1e ae 00 00       	call   c010babb <strcmp>
c0100c9d:	85 c0                	test   %eax,%eax
c0100c9f:	75 32                	jne    c0100cd3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ca1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ca4:	89 d0                	mov    %edx,%eax
c0100ca6:	01 c0                	add    %eax,%eax
c0100ca8:	01 d0                	add    %edx,%eax
c0100caa:	c1 e0 02             	shl    $0x2,%eax
c0100cad:	05 20 c0 12 c0       	add    $0xc012c020,%eax
c0100cb2:	8b 40 08             	mov    0x8(%eax),%eax
c0100cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cb8:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cbb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cbe:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cc2:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cc5:	83 c2 04             	add    $0x4,%edx
c0100cc8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ccc:	89 0c 24             	mov    %ecx,(%esp)
c0100ccf:	ff d0                	call   *%eax
c0100cd1:	eb 24                	jmp    c0100cf7 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cd3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cda:	83 f8 02             	cmp    $0x2,%eax
c0100cdd:	76 9c                	jbe    c0100c7b <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cdf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce6:	c7 04 24 13 c1 10 c0 	movl   $0xc010c113,(%esp)
c0100ced:	e8 66 f6 ff ff       	call   c0100358 <cprintf>
    return 0;
c0100cf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf7:	c9                   	leave  
c0100cf8:	c3                   	ret    

c0100cf9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf9:	55                   	push   %ebp
c0100cfa:	89 e5                	mov    %esp,%ebp
c0100cfc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cff:	c7 04 24 2c c1 10 c0 	movl   $0xc010c12c,(%esp)
c0100d06:	e8 4d f6 ff ff       	call   c0100358 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d0b:	c7 04 24 54 c1 10 c0 	movl   $0xc010c154,(%esp)
c0100d12:	e8 41 f6 ff ff       	call   c0100358 <cprintf>

    if (tf != NULL) {
c0100d17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d1b:	74 0b                	je     c0100d28 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d20:	89 04 24             	mov    %eax,(%esp)
c0100d23:	e8 6a 16 00 00       	call   c0102392 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d28:	c7 04 24 79 c1 10 c0 	movl   $0xc010c179,(%esp)
c0100d2f:	e8 1b f5 ff ff       	call   c010024f <readline>
c0100d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d3b:	74 18                	je     c0100d55 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d47:	89 04 24             	mov    %eax,(%esp)
c0100d4a:	e8 f8 fe ff ff       	call   c0100c47 <runcmd>
c0100d4f:	85 c0                	test   %eax,%eax
c0100d51:	79 02                	jns    c0100d55 <kmonitor+0x5c>
                break;
c0100d53:	eb 02                	jmp    c0100d57 <kmonitor+0x5e>
            }
        }
    }
c0100d55:	eb d1                	jmp    c0100d28 <kmonitor+0x2f>
}
c0100d57:	c9                   	leave  
c0100d58:	c3                   	ret    

c0100d59 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d59:	55                   	push   %ebp
c0100d5a:	89 e5                	mov    %esp,%ebp
c0100d5c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d66:	eb 3f                	jmp    c0100da7 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d6b:	89 d0                	mov    %edx,%eax
c0100d6d:	01 c0                	add    %eax,%eax
c0100d6f:	01 d0                	add    %edx,%eax
c0100d71:	c1 e0 02             	shl    $0x2,%eax
c0100d74:	05 20 c0 12 c0       	add    $0xc012c020,%eax
c0100d79:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7f:	89 d0                	mov    %edx,%eax
c0100d81:	01 c0                	add    %eax,%eax
c0100d83:	01 d0                	add    %edx,%eax
c0100d85:	c1 e0 02             	shl    $0x2,%eax
c0100d88:	05 20 c0 12 c0       	add    $0xc012c020,%eax
c0100d8d:	8b 00                	mov    (%eax),%eax
c0100d8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d97:	c7 04 24 7d c1 10 c0 	movl   $0xc010c17d,(%esp)
c0100d9e:	e8 b5 f5 ff ff       	call   c0100358 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100da3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100daa:	83 f8 02             	cmp    $0x2,%eax
c0100dad:	76 b9                	jbe    c0100d68 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100db4:	c9                   	leave  
c0100db5:	c3                   	ret    

c0100db6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db6:	55                   	push   %ebp
c0100db7:	89 e5                	mov    %esp,%ebp
c0100db9:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100dbc:	e8 c3 fb ff ff       	call   c0100984 <print_kerninfo>
    return 0;
c0100dc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc6:	c9                   	leave  
c0100dc7:	c3                   	ret    

c0100dc8 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc8:	55                   	push   %ebp
c0100dc9:	89 e5                	mov    %esp,%ebp
c0100dcb:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dce:	e8 fb fc ff ff       	call   c0100ace <print_stackframe>
    return 0;
c0100dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd8:	c9                   	leave  
c0100dd9:	c3                   	ret    

c0100dda <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dda:	55                   	push   %ebp
c0100ddb:	89 e5                	mov    %esp,%ebp
c0100ddd:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100de0:	a1 00 e2 1a c0       	mov    0xc01ae200,%eax
c0100de5:	85 c0                	test   %eax,%eax
c0100de7:	74 02                	je     c0100deb <__panic+0x11>
        goto panic_dead;
c0100de9:	eb 48                	jmp    c0100e33 <__panic+0x59>
    }
    is_panic = 1;
c0100deb:	c7 05 00 e2 1a c0 01 	movl   $0x1,0xc01ae200
c0100df2:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100df5:	8d 45 14             	lea    0x14(%ebp),%eax
c0100df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100dfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100dfe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e02:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e09:	c7 04 24 86 c1 10 c0 	movl   $0xc010c186,(%esp)
c0100e10:	e8 43 f5 ff ff       	call   c0100358 <cprintf>
    vcprintf(fmt, ap);
c0100e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e1c:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e1f:	89 04 24             	mov    %eax,(%esp)
c0100e22:	e8 fe f4 ff ff       	call   c0100325 <vcprintf>
    cprintf("\n");
c0100e27:	c7 04 24 a2 c1 10 c0 	movl   $0xc010c1a2,(%esp)
c0100e2e:	e8 25 f5 ff ff       	call   c0100358 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e33:	e8 fa 11 00 00       	call   c0102032 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e3f:	e8 b5 fe ff ff       	call   c0100cf9 <kmonitor>
    }
c0100e44:	eb f2                	jmp    c0100e38 <__panic+0x5e>

c0100e46 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e46:	55                   	push   %ebp
c0100e47:	89 e5                	mov    %esp,%ebp
c0100e49:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e4c:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e55:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e59:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e60:	c7 04 24 a4 c1 10 c0 	movl   $0xc010c1a4,(%esp)
c0100e67:	e8 ec f4 ff ff       	call   c0100358 <cprintf>
    vcprintf(fmt, ap);
c0100e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e73:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e76:	89 04 24             	mov    %eax,(%esp)
c0100e79:	e8 a7 f4 ff ff       	call   c0100325 <vcprintf>
    cprintf("\n");
c0100e7e:	c7 04 24 a2 c1 10 c0 	movl   $0xc010c1a2,(%esp)
c0100e85:	e8 ce f4 ff ff       	call   c0100358 <cprintf>
    va_end(ap);
}
c0100e8a:	c9                   	leave  
c0100e8b:	c3                   	ret    

c0100e8c <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e8c:	55                   	push   %ebp
c0100e8d:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e8f:	a1 00 e2 1a c0       	mov    0xc01ae200,%eax
}
c0100e94:	5d                   	pop    %ebp
c0100e95:	c3                   	ret    

c0100e96 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e96:	55                   	push   %ebp
c0100e97:	89 e5                	mov    %esp,%ebp
c0100e99:	83 ec 28             	sub    $0x28,%esp
c0100e9c:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100ea2:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eae:	ee                   	out    %al,(%dx)
c0100eaf:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eb5:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eb9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ebd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
c0100ec2:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ec8:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ed5:	c7 05 78 0e 1b c0 00 	movl   $0x0,0xc01b0e78
c0100edc:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100edf:	c7 04 24 c2 c1 10 c0 	movl   $0xc010c1c2,(%esp)
c0100ee6:	e8 6d f4 ff ff       	call   c0100358 <cprintf>
    pic_enable(IRQ_TIMER);
c0100eeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ef2:	e8 99 11 00 00       	call   c0102090 <pic_enable>
}
c0100ef7:	c9                   	leave  
c0100ef8:	c3                   	ret    

c0100ef9 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ef9:	55                   	push   %ebp
c0100efa:	89 e5                	mov    %esp,%ebp
c0100efc:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100eff:	9c                   	pushf  
c0100f00:	58                   	pop    %eax
c0100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100f07:	25 00 02 00 00       	and    $0x200,%eax
c0100f0c:	85 c0                	test   %eax,%eax
c0100f0e:	74 0c                	je     c0100f1c <__intr_save+0x23>
        intr_disable();
c0100f10:	e8 1d 11 00 00       	call   c0102032 <intr_disable>
        return 1;
c0100f15:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f1a:	eb 05                	jmp    c0100f21 <__intr_save+0x28>
    }
    return 0;
c0100f1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f21:	c9                   	leave  
c0100f22:	c3                   	ret    

c0100f23 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f23:	55                   	push   %ebp
c0100f24:	89 e5                	mov    %esp,%ebp
c0100f26:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f2d:	74 05                	je     c0100f34 <__intr_restore+0x11>
        intr_enable();
c0100f2f:	e8 f8 10 00 00       	call   c010202c <intr_enable>
    }
}
c0100f34:	c9                   	leave  
c0100f35:	c3                   	ret    

c0100f36 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f36:	55                   	push   %ebp
c0100f37:	89 e5                	mov    %esp,%ebp
c0100f39:	83 ec 10             	sub    $0x10,%esp
c0100f3c:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f42:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f46:	89 c2                	mov    %eax,%edx
c0100f48:	ec                   	in     (%dx),%al
c0100f49:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f4c:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f52:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f56:	89 c2                	mov    %eax,%edx
c0100f58:	ec                   	in     (%dx),%al
c0100f59:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f5c:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f62:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f66:	89 c2                	mov    %eax,%edx
c0100f68:	ec                   	in     (%dx),%al
c0100f69:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f6c:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f76:	89 c2                	mov    %eax,%edx
c0100f78:	ec                   	in     (%dx),%al
c0100f79:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f7c:	c9                   	leave  
c0100f7d:	c3                   	ret    

c0100f7e <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f7e:	55                   	push   %ebp
c0100f7f:	89 e5                	mov    %esp,%ebp
c0100f81:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f84:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f8e:	0f b7 00             	movzwl (%eax),%eax
c0100f91:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f98:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fa0:	0f b7 00             	movzwl (%eax),%eax
c0100fa3:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fa7:	74 12                	je     c0100fbb <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fa9:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fb0:	66 c7 05 26 e2 1a c0 	movw   $0x3b4,0xc01ae226
c0100fb7:	b4 03 
c0100fb9:	eb 13                	jmp    c0100fce <cga_init+0x50>
    } else {
        *cp = was;
c0100fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fbe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fc2:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fc5:	66 c7 05 26 e2 1a c0 	movw   $0x3d4,0xc01ae226
c0100fcc:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fce:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c0100fd5:	0f b7 c0             	movzwl %ax,%eax
c0100fd8:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fdc:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fe0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fe4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe8:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fe9:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c0100ff0:	83 c0 01             	add    $0x1,%eax
c0100ff3:	0f b7 c0             	movzwl %ax,%eax
c0100ff6:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ffa:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ffe:	89 c2                	mov    %eax,%edx
c0101000:	ec                   	in     (%dx),%al
c0101001:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0101004:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101008:	0f b6 c0             	movzbl %al,%eax
c010100b:	c1 e0 08             	shl    $0x8,%eax
c010100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0101011:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c0101018:	0f b7 c0             	movzwl %ax,%eax
c010101b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010101f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101023:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101027:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010102b:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c010102c:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c0101033:	83 c0 01             	add    $0x1,%eax
c0101036:	0f b7 c0             	movzwl %ax,%eax
c0101039:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010103d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101041:	89 c2                	mov    %eax,%edx
c0101043:	ec                   	in     (%dx),%al
c0101044:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0101047:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010104b:	0f b6 c0             	movzbl %al,%eax
c010104e:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0101051:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101054:	a3 20 e2 1a c0       	mov    %eax,0xc01ae220
    crt_pos = pos;
c0101059:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010105c:	66 a3 24 e2 1a c0    	mov    %ax,0xc01ae224
}
c0101062:	c9                   	leave  
c0101063:	c3                   	ret    

c0101064 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0101064:	55                   	push   %ebp
c0101065:	89 e5                	mov    %esp,%ebp
c0101067:	83 ec 48             	sub    $0x48,%esp
c010106a:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0101070:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101074:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101078:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010107c:	ee                   	out    %al,(%dx)
c010107d:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0101083:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101087:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010108b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108f:	ee                   	out    %al,(%dx)
c0101090:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101096:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c010109a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010109e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a2:	ee                   	out    %al,(%dx)
c01010a3:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010a9:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010ad:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010b1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010b5:	ee                   	out    %al,(%dx)
c01010b6:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010bc:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010c0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010c4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010c8:	ee                   	out    %al,(%dx)
c01010c9:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010cf:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010d3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010d7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010db:	ee                   	out    %al,(%dx)
c01010dc:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010e2:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010e6:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010ea:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010ee:	ee                   	out    %al,(%dx)
c01010ef:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010f5:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010f9:	89 c2                	mov    %eax,%edx
c01010fb:	ec                   	in     (%dx),%al
c01010fc:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010ff:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101103:	3c ff                	cmp    $0xff,%al
c0101105:	0f 95 c0             	setne  %al
c0101108:	0f b6 c0             	movzbl %al,%eax
c010110b:	a3 28 e2 1a c0       	mov    %eax,0xc01ae228
c0101110:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101116:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010111a:	89 c2                	mov    %eax,%edx
c010111c:	ec                   	in     (%dx),%al
c010111d:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101120:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101126:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010112a:	89 c2                	mov    %eax,%edx
c010112c:	ec                   	in     (%dx),%al
c010112d:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101130:	a1 28 e2 1a c0       	mov    0xc01ae228,%eax
c0101135:	85 c0                	test   %eax,%eax
c0101137:	74 0c                	je     c0101145 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101139:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101140:	e8 4b 0f 00 00       	call   c0102090 <pic_enable>
    }
}
c0101145:	c9                   	leave  
c0101146:	c3                   	ret    

c0101147 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101147:	55                   	push   %ebp
c0101148:	89 e5                	mov    %esp,%ebp
c010114a:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010114d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101154:	eb 09                	jmp    c010115f <lpt_putc_sub+0x18>
        delay();
c0101156:	e8 db fd ff ff       	call   c0100f36 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010115b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010115f:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101165:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101169:	89 c2                	mov    %eax,%edx
c010116b:	ec                   	in     (%dx),%al
c010116c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010116f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101173:	84 c0                	test   %al,%al
c0101175:	78 09                	js     c0101180 <lpt_putc_sub+0x39>
c0101177:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010117e:	7e d6                	jle    c0101156 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101180:	8b 45 08             	mov    0x8(%ebp),%eax
c0101183:	0f b6 c0             	movzbl %al,%eax
c0101186:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010118c:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010118f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101193:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101197:	ee                   	out    %al,(%dx)
c0101198:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010119e:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01011a2:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011a6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011aa:	ee                   	out    %al,(%dx)
c01011ab:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011b1:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011b5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011bd:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011be:	c9                   	leave  
c01011bf:	c3                   	ret    

c01011c0 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011c0:	55                   	push   %ebp
c01011c1:	89 e5                	mov    %esp,%ebp
c01011c3:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011c6:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011ca:	74 0d                	je     c01011d9 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cf:	89 04 24             	mov    %eax,(%esp)
c01011d2:	e8 70 ff ff ff       	call   c0101147 <lpt_putc_sub>
c01011d7:	eb 24                	jmp    c01011fd <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011d9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011e0:	e8 62 ff ff ff       	call   c0101147 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011ec:	e8 56 ff ff ff       	call   c0101147 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011f1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011f8:	e8 4a ff ff ff       	call   c0101147 <lpt_putc_sub>
    }
}
c01011fd:	c9                   	leave  
c01011fe:	c3                   	ret    

c01011ff <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011ff:	55                   	push   %ebp
c0101200:	89 e5                	mov    %esp,%ebp
c0101202:	53                   	push   %ebx
c0101203:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101206:	8b 45 08             	mov    0x8(%ebp),%eax
c0101209:	b0 00                	mov    $0x0,%al
c010120b:	85 c0                	test   %eax,%eax
c010120d:	75 07                	jne    c0101216 <cga_putc+0x17>
        c |= 0x0700;
c010120f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101216:	8b 45 08             	mov    0x8(%ebp),%eax
c0101219:	0f b6 c0             	movzbl %al,%eax
c010121c:	83 f8 0a             	cmp    $0xa,%eax
c010121f:	74 4c                	je     c010126d <cga_putc+0x6e>
c0101221:	83 f8 0d             	cmp    $0xd,%eax
c0101224:	74 57                	je     c010127d <cga_putc+0x7e>
c0101226:	83 f8 08             	cmp    $0x8,%eax
c0101229:	0f 85 88 00 00 00    	jne    c01012b7 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010122f:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c0101236:	66 85 c0             	test   %ax,%ax
c0101239:	74 30                	je     c010126b <cga_putc+0x6c>
            crt_pos --;
c010123b:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c0101242:	83 e8 01             	sub    $0x1,%eax
c0101245:	66 a3 24 e2 1a c0    	mov    %ax,0xc01ae224
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010124b:	a1 20 e2 1a c0       	mov    0xc01ae220,%eax
c0101250:	0f b7 15 24 e2 1a c0 	movzwl 0xc01ae224,%edx
c0101257:	0f b7 d2             	movzwl %dx,%edx
c010125a:	01 d2                	add    %edx,%edx
c010125c:	01 c2                	add    %eax,%edx
c010125e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101261:	b0 00                	mov    $0x0,%al
c0101263:	83 c8 20             	or     $0x20,%eax
c0101266:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101269:	eb 72                	jmp    c01012dd <cga_putc+0xde>
c010126b:	eb 70                	jmp    c01012dd <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010126d:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c0101274:	83 c0 50             	add    $0x50,%eax
c0101277:	66 a3 24 e2 1a c0    	mov    %ax,0xc01ae224
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010127d:	0f b7 1d 24 e2 1a c0 	movzwl 0xc01ae224,%ebx
c0101284:	0f b7 0d 24 e2 1a c0 	movzwl 0xc01ae224,%ecx
c010128b:	0f b7 c1             	movzwl %cx,%eax
c010128e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101294:	c1 e8 10             	shr    $0x10,%eax
c0101297:	89 c2                	mov    %eax,%edx
c0101299:	66 c1 ea 06          	shr    $0x6,%dx
c010129d:	89 d0                	mov    %edx,%eax
c010129f:	c1 e0 02             	shl    $0x2,%eax
c01012a2:	01 d0                	add    %edx,%eax
c01012a4:	c1 e0 04             	shl    $0x4,%eax
c01012a7:	29 c1                	sub    %eax,%ecx
c01012a9:	89 ca                	mov    %ecx,%edx
c01012ab:	89 d8                	mov    %ebx,%eax
c01012ad:	29 d0                	sub    %edx,%eax
c01012af:	66 a3 24 e2 1a c0    	mov    %ax,0xc01ae224
        break;
c01012b5:	eb 26                	jmp    c01012dd <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012b7:	8b 0d 20 e2 1a c0    	mov    0xc01ae220,%ecx
c01012bd:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c01012c4:	8d 50 01             	lea    0x1(%eax),%edx
c01012c7:	66 89 15 24 e2 1a c0 	mov    %dx,0xc01ae224
c01012ce:	0f b7 c0             	movzwl %ax,%eax
c01012d1:	01 c0                	add    %eax,%eax
c01012d3:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d9:	66 89 02             	mov    %ax,(%edx)
        break;
c01012dc:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012dd:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c01012e4:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012e8:	76 5b                	jbe    c0101345 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012ea:	a1 20 e2 1a c0       	mov    0xc01ae220,%eax
c01012ef:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012f5:	a1 20 e2 1a c0       	mov    0xc01ae220,%eax
c01012fa:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101301:	00 
c0101302:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101306:	89 04 24             	mov    %eax,(%esp)
c0101309:	e8 4a aa 00 00       	call   c010bd58 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010130e:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101315:	eb 15                	jmp    c010132c <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101317:	a1 20 e2 1a c0       	mov    0xc01ae220,%eax
c010131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010131f:	01 d2                	add    %edx,%edx
c0101321:	01 d0                	add    %edx,%eax
c0101323:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101328:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010132c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101333:	7e e2                	jle    c0101317 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101335:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c010133c:	83 e8 50             	sub    $0x50,%eax
c010133f:	66 a3 24 e2 1a c0    	mov    %ax,0xc01ae224
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101345:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c010134c:	0f b7 c0             	movzwl %ax,%eax
c010134f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101353:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101357:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010135b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101360:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c0101367:	66 c1 e8 08          	shr    $0x8,%ax
c010136b:	0f b6 c0             	movzbl %al,%eax
c010136e:	0f b7 15 26 e2 1a c0 	movzwl 0xc01ae226,%edx
c0101375:	83 c2 01             	add    $0x1,%edx
c0101378:	0f b7 d2             	movzwl %dx,%edx
c010137b:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010137f:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101382:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101386:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010138a:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010138b:	0f b7 05 26 e2 1a c0 	movzwl 0xc01ae226,%eax
c0101392:	0f b7 c0             	movzwl %ax,%eax
c0101395:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101399:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010139d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01013a1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013a5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013a6:	0f b7 05 24 e2 1a c0 	movzwl 0xc01ae224,%eax
c01013ad:	0f b6 c0             	movzbl %al,%eax
c01013b0:	0f b7 15 26 e2 1a c0 	movzwl 0xc01ae226,%edx
c01013b7:	83 c2 01             	add    $0x1,%edx
c01013ba:	0f b7 d2             	movzwl %dx,%edx
c01013bd:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013c1:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013c4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013c8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013cc:	ee                   	out    %al,(%dx)
}
c01013cd:	83 c4 34             	add    $0x34,%esp
c01013d0:	5b                   	pop    %ebx
c01013d1:	5d                   	pop    %ebp
c01013d2:	c3                   	ret    

c01013d3 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013d3:	55                   	push   %ebp
c01013d4:	89 e5                	mov    %esp,%ebp
c01013d6:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013e0:	eb 09                	jmp    c01013eb <serial_putc_sub+0x18>
        delay();
c01013e2:	e8 4f fb ff ff       	call   c0100f36 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013eb:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013f1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f5:	89 c2                	mov    %eax,%edx
c01013f7:	ec                   	in     (%dx),%al
c01013f8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013fb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013ff:	0f b6 c0             	movzbl %al,%eax
c0101402:	83 e0 20             	and    $0x20,%eax
c0101405:	85 c0                	test   %eax,%eax
c0101407:	75 09                	jne    c0101412 <serial_putc_sub+0x3f>
c0101409:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101410:	7e d0                	jle    c01013e2 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101412:	8b 45 08             	mov    0x8(%ebp),%eax
c0101415:	0f b6 c0             	movzbl %al,%eax
c0101418:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010141e:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101421:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101425:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101429:	ee                   	out    %al,(%dx)
}
c010142a:	c9                   	leave  
c010142b:	c3                   	ret    

c010142c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010142c:	55                   	push   %ebp
c010142d:	89 e5                	mov    %esp,%ebp
c010142f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101432:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101436:	74 0d                	je     c0101445 <serial_putc+0x19>
        serial_putc_sub(c);
c0101438:	8b 45 08             	mov    0x8(%ebp),%eax
c010143b:	89 04 24             	mov    %eax,(%esp)
c010143e:	e8 90 ff ff ff       	call   c01013d3 <serial_putc_sub>
c0101443:	eb 24                	jmp    c0101469 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101445:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010144c:	e8 82 ff ff ff       	call   c01013d3 <serial_putc_sub>
        serial_putc_sub(' ');
c0101451:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101458:	e8 76 ff ff ff       	call   c01013d3 <serial_putc_sub>
        serial_putc_sub('\b');
c010145d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101464:	e8 6a ff ff ff       	call   c01013d3 <serial_putc_sub>
    }
}
c0101469:	c9                   	leave  
c010146a:	c3                   	ret    

c010146b <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010146b:	55                   	push   %ebp
c010146c:	89 e5                	mov    %esp,%ebp
c010146e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101471:	eb 33                	jmp    c01014a6 <cons_intr+0x3b>
        if (c != 0) {
c0101473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101477:	74 2d                	je     c01014a6 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101479:	a1 44 e4 1a c0       	mov    0xc01ae444,%eax
c010147e:	8d 50 01             	lea    0x1(%eax),%edx
c0101481:	89 15 44 e4 1a c0    	mov    %edx,0xc01ae444
c0101487:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010148a:	88 90 40 e2 1a c0    	mov    %dl,-0x3fe51dc0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101490:	a1 44 e4 1a c0       	mov    0xc01ae444,%eax
c0101495:	3d 00 02 00 00       	cmp    $0x200,%eax
c010149a:	75 0a                	jne    c01014a6 <cons_intr+0x3b>
                cons.wpos = 0;
c010149c:	c7 05 44 e4 1a c0 00 	movl   $0x0,0xc01ae444
c01014a3:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01014a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01014a9:	ff d0                	call   *%eax
c01014ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014ae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014b2:	75 bf                	jne    c0101473 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014b4:	c9                   	leave  
c01014b5:	c3                   	ret    

c01014b6 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014b6:	55                   	push   %ebp
c01014b7:	89 e5                	mov    %esp,%ebp
c01014b9:	83 ec 10             	sub    $0x10,%esp
c01014bc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014c2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	ec                   	in     (%dx),%al
c01014c9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014cc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014d0:	0f b6 c0             	movzbl %al,%eax
c01014d3:	83 e0 01             	and    $0x1,%eax
c01014d6:	85 c0                	test   %eax,%eax
c01014d8:	75 07                	jne    c01014e1 <serial_proc_data+0x2b>
        return -1;
c01014da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014df:	eb 2a                	jmp    c010150b <serial_proc_data+0x55>
c01014e1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014eb:	89 c2                	mov    %eax,%edx
c01014ed:	ec                   	in     (%dx),%al
c01014ee:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014f1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014f5:	0f b6 c0             	movzbl %al,%eax
c01014f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014fb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014ff:	75 07                	jne    c0101508 <serial_proc_data+0x52>
        c = '\b';
c0101501:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101508:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010150b:	c9                   	leave  
c010150c:	c3                   	ret    

c010150d <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010150d:	55                   	push   %ebp
c010150e:	89 e5                	mov    %esp,%ebp
c0101510:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101513:	a1 28 e2 1a c0       	mov    0xc01ae228,%eax
c0101518:	85 c0                	test   %eax,%eax
c010151a:	74 0c                	je     c0101528 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010151c:	c7 04 24 b6 14 10 c0 	movl   $0xc01014b6,(%esp)
c0101523:	e8 43 ff ff ff       	call   c010146b <cons_intr>
    }
}
c0101528:	c9                   	leave  
c0101529:	c3                   	ret    

c010152a <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010152a:	55                   	push   %ebp
c010152b:	89 e5                	mov    %esp,%ebp
c010152d:	83 ec 38             	sub    $0x38,%esp
c0101530:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101536:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010153a:	89 c2                	mov    %eax,%edx
c010153c:	ec                   	in     (%dx),%al
c010153d:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101540:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101544:	0f b6 c0             	movzbl %al,%eax
c0101547:	83 e0 01             	and    $0x1,%eax
c010154a:	85 c0                	test   %eax,%eax
c010154c:	75 0a                	jne    c0101558 <kbd_proc_data+0x2e>
        return -1;
c010154e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101553:	e9 59 01 00 00       	jmp    c01016b1 <kbd_proc_data+0x187>
c0101558:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010155e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101562:	89 c2                	mov    %eax,%edx
c0101564:	ec                   	in     (%dx),%al
c0101565:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101568:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010156c:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010156f:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101573:	75 17                	jne    c010158c <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101575:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c010157a:	83 c8 40             	or     $0x40,%eax
c010157d:	a3 48 e4 1a c0       	mov    %eax,0xc01ae448
        return 0;
c0101582:	b8 00 00 00 00       	mov    $0x0,%eax
c0101587:	e9 25 01 00 00       	jmp    c01016b1 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010158c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101590:	84 c0                	test   %al,%al
c0101592:	79 47                	jns    c01015db <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101594:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c0101599:	83 e0 40             	and    $0x40,%eax
c010159c:	85 c0                	test   %eax,%eax
c010159e:	75 09                	jne    c01015a9 <kbd_proc_data+0x7f>
c01015a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a4:	83 e0 7f             	and    $0x7f,%eax
c01015a7:	eb 04                	jmp    c01015ad <kbd_proc_data+0x83>
c01015a9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015ad:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015b0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b4:	0f b6 80 60 c0 12 c0 	movzbl -0x3fed3fa0(%eax),%eax
c01015bb:	83 c8 40             	or     $0x40,%eax
c01015be:	0f b6 c0             	movzbl %al,%eax
c01015c1:	f7 d0                	not    %eax
c01015c3:	89 c2                	mov    %eax,%edx
c01015c5:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c01015ca:	21 d0                	and    %edx,%eax
c01015cc:	a3 48 e4 1a c0       	mov    %eax,0xc01ae448
        return 0;
c01015d1:	b8 00 00 00 00       	mov    $0x0,%eax
c01015d6:	e9 d6 00 00 00       	jmp    c01016b1 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015db:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c01015e0:	83 e0 40             	and    $0x40,%eax
c01015e3:	85 c0                	test   %eax,%eax
c01015e5:	74 11                	je     c01015f8 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015e7:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015eb:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c01015f0:	83 e0 bf             	and    $0xffffffbf,%eax
c01015f3:	a3 48 e4 1a c0       	mov    %eax,0xc01ae448
    }

    shift |= shiftcode[data];
c01015f8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015fc:	0f b6 80 60 c0 12 c0 	movzbl -0x3fed3fa0(%eax),%eax
c0101603:	0f b6 d0             	movzbl %al,%edx
c0101606:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c010160b:	09 d0                	or     %edx,%eax
c010160d:	a3 48 e4 1a c0       	mov    %eax,0xc01ae448
    shift ^= togglecode[data];
c0101612:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101616:	0f b6 80 60 c1 12 c0 	movzbl -0x3fed3ea0(%eax),%eax
c010161d:	0f b6 d0             	movzbl %al,%edx
c0101620:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c0101625:	31 d0                	xor    %edx,%eax
c0101627:	a3 48 e4 1a c0       	mov    %eax,0xc01ae448

    c = charcode[shift & (CTL | SHIFT)][data];
c010162c:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c0101631:	83 e0 03             	and    $0x3,%eax
c0101634:	8b 14 85 60 c5 12 c0 	mov    -0x3fed3aa0(,%eax,4),%edx
c010163b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163f:	01 d0                	add    %edx,%eax
c0101641:	0f b6 00             	movzbl (%eax),%eax
c0101644:	0f b6 c0             	movzbl %al,%eax
c0101647:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010164a:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c010164f:	83 e0 08             	and    $0x8,%eax
c0101652:	85 c0                	test   %eax,%eax
c0101654:	74 22                	je     c0101678 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101656:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010165a:	7e 0c                	jle    c0101668 <kbd_proc_data+0x13e>
c010165c:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101660:	7f 06                	jg     c0101668 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101662:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101666:	eb 10                	jmp    c0101678 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101668:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010166c:	7e 0a                	jle    c0101678 <kbd_proc_data+0x14e>
c010166e:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101672:	7f 04                	jg     c0101678 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101674:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101678:	a1 48 e4 1a c0       	mov    0xc01ae448,%eax
c010167d:	f7 d0                	not    %eax
c010167f:	83 e0 06             	and    $0x6,%eax
c0101682:	85 c0                	test   %eax,%eax
c0101684:	75 28                	jne    c01016ae <kbd_proc_data+0x184>
c0101686:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010168d:	75 1f                	jne    c01016ae <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010168f:	c7 04 24 dd c1 10 c0 	movl   $0xc010c1dd,(%esp)
c0101696:	e8 bd ec ff ff       	call   c0100358 <cprintf>
c010169b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01016a1:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016a5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016a9:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016ad:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b1:	c9                   	leave  
c01016b2:	c3                   	ret    

c01016b3 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016b3:	55                   	push   %ebp
c01016b4:	89 e5                	mov    %esp,%ebp
c01016b6:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016b9:	c7 04 24 2a 15 10 c0 	movl   $0xc010152a,(%esp)
c01016c0:	e8 a6 fd ff ff       	call   c010146b <cons_intr>
}
c01016c5:	c9                   	leave  
c01016c6:	c3                   	ret    

c01016c7 <kbd_init>:

static void
kbd_init(void) {
c01016c7:	55                   	push   %ebp
c01016c8:	89 e5                	mov    %esp,%ebp
c01016ca:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016cd:	e8 e1 ff ff ff       	call   c01016b3 <kbd_intr>
    pic_enable(IRQ_KBD);
c01016d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d9:	e8 b2 09 00 00       	call   c0102090 <pic_enable>
}
c01016de:	c9                   	leave  
c01016df:	c3                   	ret    

c01016e0 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016e0:	55                   	push   %ebp
c01016e1:	89 e5                	mov    %esp,%ebp
c01016e3:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e6:	e8 93 f8 ff ff       	call   c0100f7e <cga_init>
    serial_init();
c01016eb:	e8 74 f9 ff ff       	call   c0101064 <serial_init>
    kbd_init();
c01016f0:	e8 d2 ff ff ff       	call   c01016c7 <kbd_init>
    if (!serial_exists) {
c01016f5:	a1 28 e2 1a c0       	mov    0xc01ae228,%eax
c01016fa:	85 c0                	test   %eax,%eax
c01016fc:	75 0c                	jne    c010170a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016fe:	c7 04 24 e9 c1 10 c0 	movl   $0xc010c1e9,(%esp)
c0101705:	e8 4e ec ff ff       	call   c0100358 <cprintf>
    }
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101712:	e8 e2 f7 ff ff       	call   c0100ef9 <__intr_save>
c0101717:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010171a:	8b 45 08             	mov    0x8(%ebp),%eax
c010171d:	89 04 24             	mov    %eax,(%esp)
c0101720:	e8 9b fa ff ff       	call   c01011c0 <lpt_putc>
        cga_putc(c);
c0101725:	8b 45 08             	mov    0x8(%ebp),%eax
c0101728:	89 04 24             	mov    %eax,(%esp)
c010172b:	e8 cf fa ff ff       	call   c01011ff <cga_putc>
        serial_putc(c);
c0101730:	8b 45 08             	mov    0x8(%ebp),%eax
c0101733:	89 04 24             	mov    %eax,(%esp)
c0101736:	e8 f1 fc ff ff       	call   c010142c <serial_putc>
    }
    local_intr_restore(intr_flag);
c010173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010173e:	89 04 24             	mov    %eax,(%esp)
c0101741:	e8 dd f7 ff ff       	call   c0100f23 <__intr_restore>
}
c0101746:	c9                   	leave  
c0101747:	c3                   	ret    

c0101748 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101748:	55                   	push   %ebp
c0101749:	89 e5                	mov    %esp,%ebp
c010174b:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010174e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101755:	e8 9f f7 ff ff       	call   c0100ef9 <__intr_save>
c010175a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010175d:	e8 ab fd ff ff       	call   c010150d <serial_intr>
        kbd_intr();
c0101762:	e8 4c ff ff ff       	call   c01016b3 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101767:	8b 15 40 e4 1a c0    	mov    0xc01ae440,%edx
c010176d:	a1 44 e4 1a c0       	mov    0xc01ae444,%eax
c0101772:	39 c2                	cmp    %eax,%edx
c0101774:	74 31                	je     c01017a7 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101776:	a1 40 e4 1a c0       	mov    0xc01ae440,%eax
c010177b:	8d 50 01             	lea    0x1(%eax),%edx
c010177e:	89 15 40 e4 1a c0    	mov    %edx,0xc01ae440
c0101784:	0f b6 80 40 e2 1a c0 	movzbl -0x3fe51dc0(%eax),%eax
c010178b:	0f b6 c0             	movzbl %al,%eax
c010178e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101791:	a1 40 e4 1a c0       	mov    0xc01ae440,%eax
c0101796:	3d 00 02 00 00       	cmp    $0x200,%eax
c010179b:	75 0a                	jne    c01017a7 <cons_getc+0x5f>
                cons.rpos = 0;
c010179d:	c7 05 40 e4 1a c0 00 	movl   $0x0,0xc01ae440
c01017a4:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017aa:	89 04 24             	mov    %eax,(%esp)
c01017ad:	e8 71 f7 ff ff       	call   c0100f23 <__intr_restore>
    return c;
c01017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017b5:	c9                   	leave  
c01017b6:	c3                   	ret    

c01017b7 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017b7:	55                   	push   %ebp
c01017b8:	89 e5                	mov    %esp,%ebp
c01017ba:	83 ec 14             	sub    $0x14,%esp
c01017bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01017c0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017c4:	90                   	nop
c01017c5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c9:	83 c0 07             	add    $0x7,%eax
c01017cc:	0f b7 c0             	movzwl %ax,%eax
c01017cf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017d3:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017d7:	89 c2                	mov    %eax,%edx
c01017d9:	ec                   	in     (%dx),%al
c01017da:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017dd:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017e1:	0f b6 c0             	movzbl %al,%eax
c01017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017ea:	25 80 00 00 00       	and    $0x80,%eax
c01017ef:	85 c0                	test   %eax,%eax
c01017f1:	75 d2                	jne    c01017c5 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017f7:	74 11                	je     c010180a <ide_wait_ready+0x53>
c01017f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017fc:	83 e0 21             	and    $0x21,%eax
c01017ff:	85 c0                	test   %eax,%eax
c0101801:	74 07                	je     c010180a <ide_wait_ready+0x53>
        return -1;
c0101803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101808:	eb 05                	jmp    c010180f <ide_wait_ready+0x58>
    }
    return 0;
c010180a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010180f:	c9                   	leave  
c0101810:	c3                   	ret    

c0101811 <ide_init>:

void
ide_init(void) {
c0101811:	55                   	push   %ebp
c0101812:	89 e5                	mov    %esp,%ebp
c0101814:	57                   	push   %edi
c0101815:	53                   	push   %ebx
c0101816:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010181c:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101822:	e9 d6 02 00 00       	jmp    c0101afd <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101827:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010182b:	c1 e0 03             	shl    $0x3,%eax
c010182e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101835:	29 c2                	sub    %eax,%edx
c0101837:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c010183d:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101840:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101844:	66 d1 e8             	shr    %ax
c0101847:	0f b7 c0             	movzwl %ax,%eax
c010184a:	0f b7 04 85 08 c2 10 	movzwl -0x3fef3df8(,%eax,4),%eax
c0101851:	c0 
c0101852:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101856:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010185a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101861:	00 
c0101862:	89 04 24             	mov    %eax,(%esp)
c0101865:	e8 4d ff ff ff       	call   c01017b7 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010186a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010186e:	83 e0 01             	and    $0x1,%eax
c0101871:	c1 e0 04             	shl    $0x4,%eax
c0101874:	83 c8 e0             	or     $0xffffffe0,%eax
c0101877:	0f b6 c0             	movzbl %al,%eax
c010187a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010187e:	83 c2 06             	add    $0x6,%edx
c0101881:	0f b7 d2             	movzwl %dx,%edx
c0101884:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101888:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010188b:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010188f:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101893:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101894:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101898:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010189f:	00 
c01018a0:	89 04 24             	mov    %eax,(%esp)
c01018a3:	e8 0f ff ff ff       	call   c01017b7 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01018a8:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018ac:	83 c0 07             	add    $0x7,%eax
c01018af:	0f b7 c0             	movzwl %ax,%eax
c01018b2:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018b6:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018ba:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018be:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018c2:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018c3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018ce:	00 
c01018cf:	89 04 24             	mov    %eax,(%esp)
c01018d2:	e8 e0 fe ff ff       	call   c01017b7 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018d7:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018db:	83 c0 07             	add    $0x7,%eax
c01018de:	0f b7 c0             	movzwl %ax,%eax
c01018e1:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018e5:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018e9:	89 c2                	mov    %eax,%edx
c01018eb:	ec                   	in     (%dx),%al
c01018ec:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018ef:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018f3:	84 c0                	test   %al,%al
c01018f5:	0f 84 f7 01 00 00    	je     c0101af2 <ide_init+0x2e1>
c01018fb:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101906:	00 
c0101907:	89 04 24             	mov    %eax,(%esp)
c010190a:	e8 a8 fe ff ff       	call   c01017b7 <ide_wait_ready>
c010190f:	85 c0                	test   %eax,%eax
c0101911:	0f 85 db 01 00 00    	jne    c0101af2 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101917:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010191b:	c1 e0 03             	shl    $0x3,%eax
c010191e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101925:	29 c2                	sub    %eax,%edx
c0101927:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c010192d:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101930:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101934:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101937:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010193d:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101940:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101947:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010194a:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010194d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101950:	89 cb                	mov    %ecx,%ebx
c0101952:	89 df                	mov    %ebx,%edi
c0101954:	89 c1                	mov    %eax,%ecx
c0101956:	fc                   	cld    
c0101957:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101959:	89 c8                	mov    %ecx,%eax
c010195b:	89 fb                	mov    %edi,%ebx
c010195d:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101960:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101963:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101969:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010196c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010196f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101975:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101978:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010197b:	25 00 00 00 04       	and    $0x4000000,%eax
c0101980:	85 c0                	test   %eax,%eax
c0101982:	74 0e                	je     c0101992 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101987:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010198d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101990:	eb 09                	jmp    c010199b <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101995:	8b 40 78             	mov    0x78(%eax),%eax
c0101998:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010199b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199f:	c1 e0 03             	shl    $0x3,%eax
c01019a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a9:	29 c2                	sub    %eax,%edx
c01019ab:	81 c2 60 e4 1a c0    	add    $0xc01ae460,%edx
c01019b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019b4:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019b7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019bb:	c1 e0 03             	shl    $0x3,%eax
c01019be:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c5:	29 c2                	sub    %eax,%edx
c01019c7:	81 c2 60 e4 1a c0    	add    $0xc01ae460,%edx
c01019cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019d0:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019d6:	83 c0 62             	add    $0x62,%eax
c01019d9:	0f b7 00             	movzwl (%eax),%eax
c01019dc:	0f b7 c0             	movzwl %ax,%eax
c01019df:	25 00 02 00 00       	and    $0x200,%eax
c01019e4:	85 c0                	test   %eax,%eax
c01019e6:	75 24                	jne    c0101a0c <ide_init+0x1fb>
c01019e8:	c7 44 24 0c 10 c2 10 	movl   $0xc010c210,0xc(%esp)
c01019ef:	c0 
c01019f0:	c7 44 24 08 53 c2 10 	movl   $0xc010c253,0x8(%esp)
c01019f7:	c0 
c01019f8:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019ff:	00 
c0101a00:	c7 04 24 68 c2 10 c0 	movl   $0xc010c268,(%esp)
c0101a07:	e8 ce f3 ff ff       	call   c0100dda <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a0c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a10:	c1 e0 03             	shl    $0x3,%eax
c0101a13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a1a:	29 c2                	sub    %eax,%edx
c0101a1c:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101a22:	83 c0 0c             	add    $0xc,%eax
c0101a25:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a2b:	83 c0 36             	add    $0x36,%eax
c0101a2e:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a31:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a3f:	eb 34                	jmp    c0101a75 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a44:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a47:	01 c2                	add    %eax,%edx
c0101a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a4c:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a52:	01 c8                	add    %ecx,%eax
c0101a54:	0f b6 00             	movzbl (%eax),%eax
c0101a57:	88 02                	mov    %al,(%edx)
c0101a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a5c:	8d 50 01             	lea    0x1(%eax),%edx
c0101a5f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a62:	01 c2                	add    %eax,%edx
c0101a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a67:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a6a:	01 c8                	add    %ecx,%eax
c0101a6c:	0f b6 00             	movzbl (%eax),%eax
c0101a6f:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a71:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a78:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a7b:	72 c4                	jb     c0101a41 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a80:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a83:	01 d0                	add    %edx,%eax
c0101a85:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a8b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a8e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a91:	85 c0                	test   %eax,%eax
c0101a93:	74 0f                	je     c0101aa4 <ide_init+0x293>
c0101a95:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a98:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a9b:	01 d0                	add    %edx,%eax
c0101a9d:	0f b6 00             	movzbl (%eax),%eax
c0101aa0:	3c 20                	cmp    $0x20,%al
c0101aa2:	74 d9                	je     c0101a7d <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101aa4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aa8:	c1 e0 03             	shl    $0x3,%eax
c0101aab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ab2:	29 c2                	sub    %eax,%edx
c0101ab4:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101aba:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101abd:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ac1:	c1 e0 03             	shl    $0x3,%eax
c0101ac4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101acb:	29 c2                	sub    %eax,%edx
c0101acd:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101ad3:	8b 50 08             	mov    0x8(%eax),%edx
c0101ad6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ada:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ade:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae6:	c7 04 24 7a c2 10 c0 	movl   $0xc010c27a,(%esp)
c0101aed:	e8 66 e8 ff ff       	call   c0100358 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101af2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101af6:	83 c0 01             	add    $0x1,%eax
c0101af9:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101afd:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101b02:	0f 86 1f fd ff ff    	jbe    c0101827 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101b08:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b0f:	e8 7c 05 00 00       	call   c0102090 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b14:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b1b:	e8 70 05 00 00       	call   c0102090 <pic_enable>
}
c0101b20:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b26:	5b                   	pop    %ebx
c0101b27:	5f                   	pop    %edi
c0101b28:	5d                   	pop    %ebp
c0101b29:	c3                   	ret    

c0101b2a <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b2a:	55                   	push   %ebp
c0101b2b:	89 e5                	mov    %esp,%ebp
c0101b2d:	83 ec 04             	sub    $0x4,%esp
c0101b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b33:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b37:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b3c:	77 24                	ja     c0101b62 <ide_device_valid+0x38>
c0101b3e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b42:	c1 e0 03             	shl    $0x3,%eax
c0101b45:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b4c:	29 c2                	sub    %eax,%edx
c0101b4e:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101b54:	0f b6 00             	movzbl (%eax),%eax
c0101b57:	84 c0                	test   %al,%al
c0101b59:	74 07                	je     c0101b62 <ide_device_valid+0x38>
c0101b5b:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b60:	eb 05                	jmp    c0101b67 <ide_device_valid+0x3d>
c0101b62:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b67:	c9                   	leave  
c0101b68:	c3                   	ret    

c0101b69 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b69:	55                   	push   %ebp
c0101b6a:	89 e5                	mov    %esp,%ebp
c0101b6c:	83 ec 08             	sub    $0x8,%esp
c0101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b72:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b76:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b7a:	89 04 24             	mov    %eax,(%esp)
c0101b7d:	e8 a8 ff ff ff       	call   c0101b2a <ide_device_valid>
c0101b82:	85 c0                	test   %eax,%eax
c0101b84:	74 1b                	je     c0101ba1 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b86:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b8a:	c1 e0 03             	shl    $0x3,%eax
c0101b8d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b94:	29 c2                	sub    %eax,%edx
c0101b96:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101b9c:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9f:	eb 05                	jmp    c0101ba6 <ide_device_size+0x3d>
    }
    return 0;
c0101ba1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ba6:	c9                   	leave  
c0101ba7:	c3                   	ret    

c0101ba8 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ba8:	55                   	push   %ebp
c0101ba9:	89 e5                	mov    %esp,%ebp
c0101bab:	57                   	push   %edi
c0101bac:	53                   	push   %ebx
c0101bad:	83 ec 50             	sub    $0x50,%esp
c0101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb3:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bb7:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bbe:	77 24                	ja     c0101be4 <ide_read_secs+0x3c>
c0101bc0:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bc5:	77 1d                	ja     c0101be4 <ide_read_secs+0x3c>
c0101bc7:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bcb:	c1 e0 03             	shl    $0x3,%eax
c0101bce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bd5:	29 c2                	sub    %eax,%edx
c0101bd7:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101bdd:	0f b6 00             	movzbl (%eax),%eax
c0101be0:	84 c0                	test   %al,%al
c0101be2:	75 24                	jne    c0101c08 <ide_read_secs+0x60>
c0101be4:	c7 44 24 0c 98 c2 10 	movl   $0xc010c298,0xc(%esp)
c0101beb:	c0 
c0101bec:	c7 44 24 08 53 c2 10 	movl   $0xc010c253,0x8(%esp)
c0101bf3:	c0 
c0101bf4:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bfb:	00 
c0101bfc:	c7 04 24 68 c2 10 c0 	movl   $0xc010c268,(%esp)
c0101c03:	e8 d2 f1 ff ff       	call   c0100dda <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c08:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c0f:	77 0f                	ja     c0101c20 <ide_read_secs+0x78>
c0101c11:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c14:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c17:	01 d0                	add    %edx,%eax
c0101c19:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c1e:	76 24                	jbe    c0101c44 <ide_read_secs+0x9c>
c0101c20:	c7 44 24 0c c0 c2 10 	movl   $0xc010c2c0,0xc(%esp)
c0101c27:	c0 
c0101c28:	c7 44 24 08 53 c2 10 	movl   $0xc010c253,0x8(%esp)
c0101c2f:	c0 
c0101c30:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c37:	00 
c0101c38:	c7 04 24 68 c2 10 c0 	movl   $0xc010c268,(%esp)
c0101c3f:	e8 96 f1 ff ff       	call   c0100dda <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c44:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c48:	66 d1 e8             	shr    %ax
c0101c4b:	0f b7 c0             	movzwl %ax,%eax
c0101c4e:	0f b7 04 85 08 c2 10 	movzwl -0x3fef3df8(,%eax,4),%eax
c0101c55:	c0 
c0101c56:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c5a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c5e:	66 d1 e8             	shr    %ax
c0101c61:	0f b7 c0             	movzwl %ax,%eax
c0101c64:	0f b7 04 85 0a c2 10 	movzwl -0x3fef3df6(,%eax,4),%eax
c0101c6b:	c0 
c0101c6c:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c70:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c7b:	00 
c0101c7c:	89 04 24             	mov    %eax,(%esp)
c0101c7f:	e8 33 fb ff ff       	call   c01017b7 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c84:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c88:	83 c0 02             	add    $0x2,%eax
c0101c8b:	0f b7 c0             	movzwl %ax,%eax
c0101c8e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c92:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c96:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c9a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c9e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c9f:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ca2:	0f b6 c0             	movzbl %al,%eax
c0101ca5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ca9:	83 c2 02             	add    $0x2,%edx
c0101cac:	0f b7 d2             	movzwl %dx,%edx
c0101caf:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cb3:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cb6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cbe:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cc2:	0f b6 c0             	movzbl %al,%eax
c0101cc5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cc9:	83 c2 03             	add    $0x3,%edx
c0101ccc:	0f b7 d2             	movzwl %dx,%edx
c0101ccf:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cd3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101cd6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101cda:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cde:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ce2:	c1 e8 08             	shr    $0x8,%eax
c0101ce5:	0f b6 c0             	movzbl %al,%eax
c0101ce8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cec:	83 c2 04             	add    $0x4,%edx
c0101cef:	0f b7 d2             	movzwl %dx,%edx
c0101cf2:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101cf6:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cf9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cfd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101d01:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101d02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d05:	c1 e8 10             	shr    $0x10,%eax
c0101d08:	0f b6 c0             	movzbl %al,%eax
c0101d0b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d0f:	83 c2 05             	add    $0x5,%edx
c0101d12:	0f b7 d2             	movzwl %dx,%edx
c0101d15:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d19:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d1c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d20:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d24:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d25:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d29:	83 e0 01             	and    $0x1,%eax
c0101d2c:	c1 e0 04             	shl    $0x4,%eax
c0101d2f:	89 c2                	mov    %eax,%edx
c0101d31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d34:	c1 e8 18             	shr    $0x18,%eax
c0101d37:	83 e0 0f             	and    $0xf,%eax
c0101d3a:	09 d0                	or     %edx,%eax
c0101d3c:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d3f:	0f b6 c0             	movzbl %al,%eax
c0101d42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d46:	83 c2 06             	add    $0x6,%edx
c0101d49:	0f b7 d2             	movzwl %dx,%edx
c0101d4c:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d50:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d53:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d57:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d5b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d5c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d60:	83 c0 07             	add    $0x7,%eax
c0101d63:	0f b7 c0             	movzwl %ax,%eax
c0101d66:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d6a:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d6e:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d72:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d76:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d7e:	eb 5a                	jmp    c0101dda <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d80:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d8b:	00 
c0101d8c:	89 04 24             	mov    %eax,(%esp)
c0101d8f:	e8 23 fa ff ff       	call   c01017b7 <ide_wait_ready>
c0101d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d9b:	74 02                	je     c0101d9f <ide_read_secs+0x1f7>
            goto out;
c0101d9d:	eb 41                	jmp    c0101de0 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d9f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101da3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101da6:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da9:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101dac:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101db3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101db6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101db9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101dbc:	89 cb                	mov    %ecx,%ebx
c0101dbe:	89 df                	mov    %ebx,%edi
c0101dc0:	89 c1                	mov    %eax,%ecx
c0101dc2:	fc                   	cld    
c0101dc3:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dc5:	89 c8                	mov    %ecx,%eax
c0101dc7:	89 fb                	mov    %edi,%ebx
c0101dc9:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dcc:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dcf:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dd3:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dda:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dde:	75 a0                	jne    c0101d80 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101de3:	83 c4 50             	add    $0x50,%esp
c0101de6:	5b                   	pop    %ebx
c0101de7:	5f                   	pop    %edi
c0101de8:	5d                   	pop    %ebp
c0101de9:	c3                   	ret    

c0101dea <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101dea:	55                   	push   %ebp
c0101deb:	89 e5                	mov    %esp,%ebp
c0101ded:	56                   	push   %esi
c0101dee:	53                   	push   %ebx
c0101def:	83 ec 50             	sub    $0x50,%esp
c0101df2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101df9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101e00:	77 24                	ja     c0101e26 <ide_write_secs+0x3c>
c0101e02:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101e07:	77 1d                	ja     c0101e26 <ide_write_secs+0x3c>
c0101e09:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e0d:	c1 e0 03             	shl    $0x3,%eax
c0101e10:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e17:	29 c2                	sub    %eax,%edx
c0101e19:	8d 82 60 e4 1a c0    	lea    -0x3fe51ba0(%edx),%eax
c0101e1f:	0f b6 00             	movzbl (%eax),%eax
c0101e22:	84 c0                	test   %al,%al
c0101e24:	75 24                	jne    c0101e4a <ide_write_secs+0x60>
c0101e26:	c7 44 24 0c 98 c2 10 	movl   $0xc010c298,0xc(%esp)
c0101e2d:	c0 
c0101e2e:	c7 44 24 08 53 c2 10 	movl   $0xc010c253,0x8(%esp)
c0101e35:	c0 
c0101e36:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e3d:	00 
c0101e3e:	c7 04 24 68 c2 10 c0 	movl   $0xc010c268,(%esp)
c0101e45:	e8 90 ef ff ff       	call   c0100dda <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e4a:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e51:	77 0f                	ja     c0101e62 <ide_write_secs+0x78>
c0101e53:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e56:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e59:	01 d0                	add    %edx,%eax
c0101e5b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e60:	76 24                	jbe    c0101e86 <ide_write_secs+0x9c>
c0101e62:	c7 44 24 0c c0 c2 10 	movl   $0xc010c2c0,0xc(%esp)
c0101e69:	c0 
c0101e6a:	c7 44 24 08 53 c2 10 	movl   $0xc010c253,0x8(%esp)
c0101e71:	c0 
c0101e72:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e79:	00 
c0101e7a:	c7 04 24 68 c2 10 c0 	movl   $0xc010c268,(%esp)
c0101e81:	e8 54 ef ff ff       	call   c0100dda <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e86:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e8a:	66 d1 e8             	shr    %ax
c0101e8d:	0f b7 c0             	movzwl %ax,%eax
c0101e90:	0f b7 04 85 08 c2 10 	movzwl -0x3fef3df8(,%eax,4),%eax
c0101e97:	c0 
c0101e98:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e9c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ea0:	66 d1 e8             	shr    %ax
c0101ea3:	0f b7 c0             	movzwl %ax,%eax
c0101ea6:	0f b7 04 85 0a c2 10 	movzwl -0x3fef3df6(,%eax,4),%eax
c0101ead:	c0 
c0101eae:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101eb2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101ebd:	00 
c0101ebe:	89 04 24             	mov    %eax,(%esp)
c0101ec1:	e8 f1 f8 ff ff       	call   c01017b7 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ec6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101eca:	83 c0 02             	add    $0x2,%eax
c0101ecd:	0f b7 c0             	movzwl %ax,%eax
c0101ed0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ed4:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101edc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ee0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ee1:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ee4:	0f b6 c0             	movzbl %al,%eax
c0101ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101eeb:	83 c2 02             	add    $0x2,%edx
c0101eee:	0f b7 d2             	movzwl %dx,%edx
c0101ef1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ef5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ef8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101efc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101f00:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101f01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f04:	0f b6 c0             	movzbl %al,%eax
c0101f07:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f0b:	83 c2 03             	add    $0x3,%edx
c0101f0e:	0f b7 d2             	movzwl %dx,%edx
c0101f11:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f15:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f18:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f1c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f20:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f24:	c1 e8 08             	shr    $0x8,%eax
c0101f27:	0f b6 c0             	movzbl %al,%eax
c0101f2a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f2e:	83 c2 04             	add    $0x4,%edx
c0101f31:	0f b7 d2             	movzwl %dx,%edx
c0101f34:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f38:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f3b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f3f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f43:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f47:	c1 e8 10             	shr    $0x10,%eax
c0101f4a:	0f b6 c0             	movzbl %al,%eax
c0101f4d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f51:	83 c2 05             	add    $0x5,%edx
c0101f54:	0f b7 d2             	movzwl %dx,%edx
c0101f57:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f5b:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f5e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f62:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f66:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f67:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f6b:	83 e0 01             	and    $0x1,%eax
c0101f6e:	c1 e0 04             	shl    $0x4,%eax
c0101f71:	89 c2                	mov    %eax,%edx
c0101f73:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f76:	c1 e8 18             	shr    $0x18,%eax
c0101f79:	83 e0 0f             	and    $0xf,%eax
c0101f7c:	09 d0                	or     %edx,%eax
c0101f7e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f81:	0f b6 c0             	movzbl %al,%eax
c0101f84:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f88:	83 c2 06             	add    $0x6,%edx
c0101f8b:	0f b7 d2             	movzwl %dx,%edx
c0101f8e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f92:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f95:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f99:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f9d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f9e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fa2:	83 c0 07             	add    $0x7,%eax
c0101fa5:	0f b7 c0             	movzwl %ax,%eax
c0101fa8:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fac:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fb0:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101fb4:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fb8:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fc0:	eb 5a                	jmp    c010201c <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fc2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fc6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fcd:	00 
c0101fce:	89 04 24             	mov    %eax,(%esp)
c0101fd1:	e8 e1 f7 ff ff       	call   c01017b7 <ide_wait_ready>
c0101fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fdd:	74 02                	je     c0101fe1 <ide_write_secs+0x1f7>
            goto out;
c0101fdf:	eb 41                	jmp    c0102022 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fe1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fe5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fe8:	8b 45 10             	mov    0x10(%ebp),%eax
c0101feb:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fee:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ff5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ff8:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ffb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ffe:	89 cb                	mov    %ecx,%ebx
c0102000:	89 de                	mov    %ebx,%esi
c0102002:	89 c1                	mov    %eax,%ecx
c0102004:	fc                   	cld    
c0102005:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0102007:	89 c8                	mov    %ecx,%eax
c0102009:	89 f3                	mov    %esi,%ebx
c010200b:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c010200e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0102011:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0102015:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c010201c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0102020:	75 a0                	jne    c0101fc2 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0102022:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102025:	83 c4 50             	add    $0x50,%esp
c0102028:	5b                   	pop    %ebx
c0102029:	5e                   	pop    %esi
c010202a:	5d                   	pop    %ebp
c010202b:	c3                   	ret    

c010202c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010202c:	55                   	push   %ebp
c010202d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010202f:	fb                   	sti    
    sti();
}
c0102030:	5d                   	pop    %ebp
c0102031:	c3                   	ret    

c0102032 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0102032:	55                   	push   %ebp
c0102033:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102035:	fa                   	cli    
    cli();
}
c0102036:	5d                   	pop    %ebp
c0102037:	c3                   	ret    

c0102038 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0102038:	55                   	push   %ebp
c0102039:	89 e5                	mov    %esp,%ebp
c010203b:	83 ec 14             	sub    $0x14,%esp
c010203e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102041:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102045:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102049:	66 a3 70 c5 12 c0    	mov    %ax,0xc012c570
    if (did_init) {
c010204f:	a1 40 e5 1a c0       	mov    0xc01ae540,%eax
c0102054:	85 c0                	test   %eax,%eax
c0102056:	74 36                	je     c010208e <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102058:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010205c:	0f b6 c0             	movzbl %al,%eax
c010205f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102065:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102068:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010206c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102070:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0102071:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102075:	66 c1 e8 08          	shr    $0x8,%ax
c0102079:	0f b6 c0             	movzbl %al,%eax
c010207c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0102082:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102085:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102089:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010208d:	ee                   	out    %al,(%dx)
    }
}
c010208e:	c9                   	leave  
c010208f:	c3                   	ret    

c0102090 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0102090:	55                   	push   %ebp
c0102091:	89 e5                	mov    %esp,%ebp
c0102093:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102096:	8b 45 08             	mov    0x8(%ebp),%eax
c0102099:	ba 01 00 00 00       	mov    $0x1,%edx
c010209e:	89 c1                	mov    %eax,%ecx
c01020a0:	d3 e2                	shl    %cl,%edx
c01020a2:	89 d0                	mov    %edx,%eax
c01020a4:	f7 d0                	not    %eax
c01020a6:	89 c2                	mov    %eax,%edx
c01020a8:	0f b7 05 70 c5 12 c0 	movzwl 0xc012c570,%eax
c01020af:	21 d0                	and    %edx,%eax
c01020b1:	0f b7 c0             	movzwl %ax,%eax
c01020b4:	89 04 24             	mov    %eax,(%esp)
c01020b7:	e8 7c ff ff ff       	call   c0102038 <pic_setmask>
}
c01020bc:	c9                   	leave  
c01020bd:	c3                   	ret    

c01020be <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020be:	55                   	push   %ebp
c01020bf:	89 e5                	mov    %esp,%ebp
c01020c1:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020c4:	c7 05 40 e5 1a c0 01 	movl   $0x1,0xc01ae540
c01020cb:	00 00 00 
c01020ce:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020d4:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020d8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020dc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020e0:	ee                   	out    %al,(%dx)
c01020e1:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020e7:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020eb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020ef:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020f3:	ee                   	out    %al,(%dx)
c01020f4:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020fa:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020fe:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102102:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102106:	ee                   	out    %al,(%dx)
c0102107:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010210d:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102111:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102115:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102119:	ee                   	out    %al,(%dx)
c010211a:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102120:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102124:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102128:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010212c:	ee                   	out    %al,(%dx)
c010212d:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102133:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102137:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010213b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010213f:	ee                   	out    %al,(%dx)
c0102140:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102146:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010214a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010214e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102152:	ee                   	out    %al,(%dx)
c0102153:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102159:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010215d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102161:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102165:	ee                   	out    %al,(%dx)
c0102166:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010216c:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102170:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102174:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102178:	ee                   	out    %al,(%dx)
c0102179:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010217f:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102183:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102187:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010218b:	ee                   	out    %al,(%dx)
c010218c:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102192:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102196:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010219a:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010219e:	ee                   	out    %al,(%dx)
c010219f:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01021a5:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01021a9:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021ad:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021b1:	ee                   	out    %al,(%dx)
c01021b2:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021b8:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021bc:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021c0:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021c4:	ee                   	out    %al,(%dx)
c01021c5:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021cb:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021cf:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021d3:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021d7:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021d8:	0f b7 05 70 c5 12 c0 	movzwl 0xc012c570,%eax
c01021df:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021e3:	74 12                	je     c01021f7 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021e5:	0f b7 05 70 c5 12 c0 	movzwl 0xc012c570,%eax
c01021ec:	0f b7 c0             	movzwl %ax,%eax
c01021ef:	89 04 24             	mov    %eax,(%esp)
c01021f2:	e8 41 fe ff ff       	call   c0102038 <pic_setmask>
    }
}
c01021f7:	c9                   	leave  
c01021f8:	c3                   	ret    

c01021f9 <print_ticks>:
#include <sync.h>
#include <proc.h>

#define TICK_NUM 100

static void print_ticks() {
c01021f9:	55                   	push   %ebp
c01021fa:	89 e5                	mov    %esp,%ebp
c01021fc:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021ff:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102206:	00 
c0102207:	c7 04 24 00 c3 10 c0 	movl   $0xc010c300,(%esp)
c010220e:	e8 45 e1 ff ff       	call   c0100358 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102213:	c7 04 24 0a c3 10 c0 	movl   $0xc010c30a,(%esp)
c010221a:	e8 39 e1 ff ff       	call   c0100358 <cprintf>
    panic("EOT: kernel seems ok.");
c010221f:	c7 44 24 08 18 c3 10 	movl   $0xc010c318,0x8(%esp)
c0102226:	c0 
c0102227:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
c010222e:	00 
c010222f:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102236:	e8 9f eb ff ff       	call   c0100dda <__panic>

c010223b <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010223b:	55                   	push   %ebp
c010223c:	89 e5                	mov    %esp,%ebp
c010223e:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c0102241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102248:	e9 e2 00 00 00       	jmp    c010232f <idt_init+0xf4>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
c010224d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102250:	8b 04 85 00 c6 12 c0 	mov    -0x3fed3a00(,%eax,4),%eax
c0102257:	89 c2                	mov    %eax,%edx
c0102259:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010225c:	66 89 14 c5 60 e5 1a 	mov    %dx,-0x3fe51aa0(,%eax,8)
c0102263:	c0 
c0102264:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102267:	66 c7 04 c5 62 e5 1a 	movw   $0x8,-0x3fe51a9e(,%eax,8)
c010226e:	c0 08 00 
c0102271:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102274:	0f b6 14 c5 64 e5 1a 	movzbl -0x3fe51a9c(,%eax,8),%edx
c010227b:	c0 
c010227c:	83 e2 e0             	and    $0xffffffe0,%edx
c010227f:	88 14 c5 64 e5 1a c0 	mov    %dl,-0x3fe51a9c(,%eax,8)
c0102286:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102289:	0f b6 14 c5 64 e5 1a 	movzbl -0x3fe51a9c(,%eax,8),%edx
c0102290:	c0 
c0102291:	83 e2 1f             	and    $0x1f,%edx
c0102294:	88 14 c5 64 e5 1a c0 	mov    %dl,-0x3fe51a9c(,%eax,8)
c010229b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229e:	0f b6 14 c5 65 e5 1a 	movzbl -0x3fe51a9b(,%eax,8),%edx
c01022a5:	c0 
c01022a6:	83 e2 f0             	and    $0xfffffff0,%edx
c01022a9:	83 ca 0e             	or     $0xe,%edx
c01022ac:	88 14 c5 65 e5 1a c0 	mov    %dl,-0x3fe51a9b(,%eax,8)
c01022b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b6:	0f b6 14 c5 65 e5 1a 	movzbl -0x3fe51a9b(,%eax,8),%edx
c01022bd:	c0 
c01022be:	83 e2 ef             	and    $0xffffffef,%edx
c01022c1:	88 14 c5 65 e5 1a c0 	mov    %dl,-0x3fe51a9b(,%eax,8)
c01022c8:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01022cf:	75 07                	jne    c01022d8 <idt_init+0x9d>
c01022d1:	ba 03 00 00 00       	mov    $0x3,%edx
c01022d6:	eb 05                	jmp    c01022dd <idt_init+0xa2>
c01022d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01022dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022e0:	83 e2 03             	and    $0x3,%edx
c01022e3:	89 d1                	mov    %edx,%ecx
c01022e5:	c1 e1 05             	shl    $0x5,%ecx
c01022e8:	0f b6 14 c5 65 e5 1a 	movzbl -0x3fe51a9b(,%eax,8),%edx
c01022ef:	c0 
c01022f0:	83 e2 9f             	and    $0xffffff9f,%edx
c01022f3:	09 ca                	or     %ecx,%edx
c01022f5:	88 14 c5 65 e5 1a c0 	mov    %dl,-0x3fe51a9b(,%eax,8)
c01022fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ff:	0f b6 14 c5 65 e5 1a 	movzbl -0x3fe51a9b(,%eax,8),%edx
c0102306:	c0 
c0102307:	83 ca 80             	or     $0xffffff80,%edx
c010230a:	88 14 c5 65 e5 1a c0 	mov    %dl,-0x3fe51a9b(,%eax,8)
c0102311:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102314:	8b 04 85 00 c6 12 c0 	mov    -0x3fed3a00(,%eax,4),%eax
c010231b:	c1 e8 10             	shr    $0x10,%eax
c010231e:	89 c2                	mov    %eax,%edx
c0102320:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102323:	66 89 14 c5 66 e5 1a 	mov    %dx,-0x3fe51a9a(,%eax,8)
c010232a:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c010232b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010232f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102336:	0f 8e 11 ff ff ff    	jle    c010224d <idt_init+0x12>
c010233c:	c7 45 f8 80 c5 12 c0 	movl   $0xc012c580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102343:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102346:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
    lidt(&idt_pd);
     /* LAB5 2013011303*/ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
}
c0102349:	c9                   	leave  
c010234a:	c3                   	ret    

c010234b <trapname>:

static const char *
trapname(int trapno) {
c010234b:	55                   	push   %ebp
c010234c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010234e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102351:	83 f8 13             	cmp    $0x13,%eax
c0102354:	77 0c                	ja     c0102362 <trapname+0x17>
        return excnames[trapno];
c0102356:	8b 45 08             	mov    0x8(%ebp),%eax
c0102359:	8b 04 85 a0 c7 10 c0 	mov    -0x3fef3860(,%eax,4),%eax
c0102360:	eb 18                	jmp    c010237a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102362:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102366:	7e 0d                	jle    c0102375 <trapname+0x2a>
c0102368:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010236c:	7f 07                	jg     c0102375 <trapname+0x2a>
        return "Hardware Interrupt";
c010236e:	b8 3f c3 10 c0       	mov    $0xc010c33f,%eax
c0102373:	eb 05                	jmp    c010237a <trapname+0x2f>
    }
    return "(unknown trap)";
c0102375:	b8 52 c3 10 c0       	mov    $0xc010c352,%eax
}
c010237a:	5d                   	pop    %ebp
c010237b:	c3                   	ret    

c010237c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010237c:	55                   	push   %ebp
c010237d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010237f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102382:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102386:	66 83 f8 08          	cmp    $0x8,%ax
c010238a:	0f 94 c0             	sete   %al
c010238d:	0f b6 c0             	movzbl %al,%eax
}
c0102390:	5d                   	pop    %ebp
c0102391:	c3                   	ret    

c0102392 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102392:	55                   	push   %ebp
c0102393:	89 e5                	mov    %esp,%ebp
c0102395:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102398:	8b 45 08             	mov    0x8(%ebp),%eax
c010239b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010239f:	c7 04 24 93 c3 10 c0 	movl   $0xc010c393,(%esp)
c01023a6:	e8 ad df ff ff       	call   c0100358 <cprintf>
    print_regs(&tf->tf_regs);
c01023ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ae:	89 04 24             	mov    %eax,(%esp)
c01023b1:	e8 a1 01 00 00       	call   c0102557 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01023b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b9:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01023bd:	0f b7 c0             	movzwl %ax,%eax
c01023c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c4:	c7 04 24 a4 c3 10 c0 	movl   $0xc010c3a4,(%esp)
c01023cb:	e8 88 df ff ff       	call   c0100358 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01023d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d3:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01023d7:	0f b7 c0             	movzwl %ax,%eax
c01023da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023de:	c7 04 24 b7 c3 10 c0 	movl   $0xc010c3b7,(%esp)
c01023e5:	e8 6e df ff ff       	call   c0100358 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01023ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ed:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01023f1:	0f b7 c0             	movzwl %ax,%eax
c01023f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f8:	c7 04 24 ca c3 10 c0 	movl   $0xc010c3ca,(%esp)
c01023ff:	e8 54 df ff ff       	call   c0100358 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102404:	8b 45 08             	mov    0x8(%ebp),%eax
c0102407:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010240b:	0f b7 c0             	movzwl %ax,%eax
c010240e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102412:	c7 04 24 dd c3 10 c0 	movl   $0xc010c3dd,(%esp)
c0102419:	e8 3a df ff ff       	call   c0100358 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010241e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102421:	8b 40 30             	mov    0x30(%eax),%eax
c0102424:	89 04 24             	mov    %eax,(%esp)
c0102427:	e8 1f ff ff ff       	call   c010234b <trapname>
c010242c:	8b 55 08             	mov    0x8(%ebp),%edx
c010242f:	8b 52 30             	mov    0x30(%edx),%edx
c0102432:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102436:	89 54 24 04          	mov    %edx,0x4(%esp)
c010243a:	c7 04 24 f0 c3 10 c0 	movl   $0xc010c3f0,(%esp)
c0102441:	e8 12 df ff ff       	call   c0100358 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102446:	8b 45 08             	mov    0x8(%ebp),%eax
c0102449:	8b 40 34             	mov    0x34(%eax),%eax
c010244c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102450:	c7 04 24 02 c4 10 c0 	movl   $0xc010c402,(%esp)
c0102457:	e8 fc de ff ff       	call   c0100358 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010245c:	8b 45 08             	mov    0x8(%ebp),%eax
c010245f:	8b 40 38             	mov    0x38(%eax),%eax
c0102462:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102466:	c7 04 24 11 c4 10 c0 	movl   $0xc010c411,(%esp)
c010246d:	e8 e6 de ff ff       	call   c0100358 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102472:	8b 45 08             	mov    0x8(%ebp),%eax
c0102475:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102479:	0f b7 c0             	movzwl %ax,%eax
c010247c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102480:	c7 04 24 20 c4 10 c0 	movl   $0xc010c420,(%esp)
c0102487:	e8 cc de ff ff       	call   c0100358 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010248c:	8b 45 08             	mov    0x8(%ebp),%eax
c010248f:	8b 40 40             	mov    0x40(%eax),%eax
c0102492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102496:	c7 04 24 33 c4 10 c0 	movl   $0xc010c433,(%esp)
c010249d:	e8 b6 de ff ff       	call   c0100358 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01024a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01024b0:	eb 3e                	jmp    c01024f0 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01024b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b5:	8b 50 40             	mov    0x40(%eax),%edx
c01024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024bb:	21 d0                	and    %edx,%eax
c01024bd:	85 c0                	test   %eax,%eax
c01024bf:	74 28                	je     c01024e9 <print_trapframe+0x157>
c01024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024c4:	8b 04 85 a0 c5 12 c0 	mov    -0x3fed3a60(,%eax,4),%eax
c01024cb:	85 c0                	test   %eax,%eax
c01024cd:	74 1a                	je     c01024e9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024d2:	8b 04 85 a0 c5 12 c0 	mov    -0x3fed3a60(,%eax,4),%eax
c01024d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024dd:	c7 04 24 42 c4 10 c0 	movl   $0xc010c442,(%esp)
c01024e4:	e8 6f de ff ff       	call   c0100358 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024e9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024ed:	d1 65 f0             	shll   -0x10(%ebp)
c01024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024f3:	83 f8 17             	cmp    $0x17,%eax
c01024f6:	76 ba                	jbe    c01024b2 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01024f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fb:	8b 40 40             	mov    0x40(%eax),%eax
c01024fe:	25 00 30 00 00       	and    $0x3000,%eax
c0102503:	c1 e8 0c             	shr    $0xc,%eax
c0102506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010250a:	c7 04 24 46 c4 10 c0 	movl   $0xc010c446,(%esp)
c0102511:	e8 42 de ff ff       	call   c0100358 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102516:	8b 45 08             	mov    0x8(%ebp),%eax
c0102519:	89 04 24             	mov    %eax,(%esp)
c010251c:	e8 5b fe ff ff       	call   c010237c <trap_in_kernel>
c0102521:	85 c0                	test   %eax,%eax
c0102523:	75 30                	jne    c0102555 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102525:	8b 45 08             	mov    0x8(%ebp),%eax
c0102528:	8b 40 44             	mov    0x44(%eax),%eax
c010252b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010252f:	c7 04 24 4f c4 10 c0 	movl   $0xc010c44f,(%esp)
c0102536:	e8 1d de ff ff       	call   c0100358 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010253b:	8b 45 08             	mov    0x8(%ebp),%eax
c010253e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102542:	0f b7 c0             	movzwl %ax,%eax
c0102545:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102549:	c7 04 24 5e c4 10 c0 	movl   $0xc010c45e,(%esp)
c0102550:	e8 03 de ff ff       	call   c0100358 <cprintf>
    }
}
c0102555:	c9                   	leave  
c0102556:	c3                   	ret    

c0102557 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102557:	55                   	push   %ebp
c0102558:	89 e5                	mov    %esp,%ebp
c010255a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010255d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102560:	8b 00                	mov    (%eax),%eax
c0102562:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102566:	c7 04 24 71 c4 10 c0 	movl   $0xc010c471,(%esp)
c010256d:	e8 e6 dd ff ff       	call   c0100358 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102572:	8b 45 08             	mov    0x8(%ebp),%eax
c0102575:	8b 40 04             	mov    0x4(%eax),%eax
c0102578:	89 44 24 04          	mov    %eax,0x4(%esp)
c010257c:	c7 04 24 80 c4 10 c0 	movl   $0xc010c480,(%esp)
c0102583:	e8 d0 dd ff ff       	call   c0100358 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102588:	8b 45 08             	mov    0x8(%ebp),%eax
c010258b:	8b 40 08             	mov    0x8(%eax),%eax
c010258e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102592:	c7 04 24 8f c4 10 c0 	movl   $0xc010c48f,(%esp)
c0102599:	e8 ba dd ff ff       	call   c0100358 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010259e:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a1:	8b 40 0c             	mov    0xc(%eax),%eax
c01025a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025a8:	c7 04 24 9e c4 10 c0 	movl   $0xc010c49e,(%esp)
c01025af:	e8 a4 dd ff ff       	call   c0100358 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01025b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01025b7:	8b 40 10             	mov    0x10(%eax),%eax
c01025ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025be:	c7 04 24 ad c4 10 c0 	movl   $0xc010c4ad,(%esp)
c01025c5:	e8 8e dd ff ff       	call   c0100358 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01025ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01025cd:	8b 40 14             	mov    0x14(%eax),%eax
c01025d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025d4:	c7 04 24 bc c4 10 c0 	movl   $0xc010c4bc,(%esp)
c01025db:	e8 78 dd ff ff       	call   c0100358 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01025e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e3:	8b 40 18             	mov    0x18(%eax),%eax
c01025e6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025ea:	c7 04 24 cb c4 10 c0 	movl   $0xc010c4cb,(%esp)
c01025f1:	e8 62 dd ff ff       	call   c0100358 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01025f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01025fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102600:	c7 04 24 da c4 10 c0 	movl   $0xc010c4da,(%esp)
c0102607:	e8 4c dd ff ff       	call   c0100358 <cprintf>
}
c010260c:	c9                   	leave  
c010260d:	c3                   	ret    

c010260e <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010260e:	55                   	push   %ebp
c010260f:	89 e5                	mov    %esp,%ebp
c0102611:	53                   	push   %ebx
c0102612:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102615:	8b 45 08             	mov    0x8(%ebp),%eax
c0102618:	8b 40 34             	mov    0x34(%eax),%eax
c010261b:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010261e:	85 c0                	test   %eax,%eax
c0102620:	74 07                	je     c0102629 <print_pgfault+0x1b>
c0102622:	b9 e9 c4 10 c0       	mov    $0xc010c4e9,%ecx
c0102627:	eb 05                	jmp    c010262e <print_pgfault+0x20>
c0102629:	b9 fa c4 10 c0       	mov    $0xc010c4fa,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010262e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102631:	8b 40 34             	mov    0x34(%eax),%eax
c0102634:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102637:	85 c0                	test   %eax,%eax
c0102639:	74 07                	je     c0102642 <print_pgfault+0x34>
c010263b:	ba 57 00 00 00       	mov    $0x57,%edx
c0102640:	eb 05                	jmp    c0102647 <print_pgfault+0x39>
c0102642:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102647:	8b 45 08             	mov    0x8(%ebp),%eax
c010264a:	8b 40 34             	mov    0x34(%eax),%eax
c010264d:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102650:	85 c0                	test   %eax,%eax
c0102652:	74 07                	je     c010265b <print_pgfault+0x4d>
c0102654:	b8 55 00 00 00       	mov    $0x55,%eax
c0102659:	eb 05                	jmp    c0102660 <print_pgfault+0x52>
c010265b:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102660:	0f 20 d3             	mov    %cr2,%ebx
c0102663:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102666:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102669:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010266d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102671:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102675:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102679:	c7 04 24 08 c5 10 c0 	movl   $0xc010c508,(%esp)
c0102680:	e8 d3 dc ff ff       	call   c0100358 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102685:	83 c4 34             	add    $0x34,%esp
c0102688:	5b                   	pop    %ebx
c0102689:	5d                   	pop    %ebp
c010268a:	c3                   	ret    

c010268b <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010268b:	55                   	push   %ebp
c010268c:	89 e5                	mov    %esp,%ebp
c010268e:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c0102691:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c0102696:	85 c0                	test   %eax,%eax
c0102698:	74 0b                	je     c01026a5 <pgfault_handler+0x1a>
            print_pgfault(tf);
c010269a:	8b 45 08             	mov    0x8(%ebp),%eax
c010269d:	89 04 24             	mov    %eax,(%esp)
c01026a0:	e8 69 ff ff ff       	call   c010260e <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c01026a5:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c01026aa:	85 c0                	test   %eax,%eax
c01026ac:	74 3d                	je     c01026eb <pgfault_handler+0x60>
        assert(current == idleproc);
c01026ae:	8b 15 28 ee 1a c0    	mov    0xc01aee28,%edx
c01026b4:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c01026b9:	39 c2                	cmp    %eax,%edx
c01026bb:	74 24                	je     c01026e1 <pgfault_handler+0x56>
c01026bd:	c7 44 24 0c 2b c5 10 	movl   $0xc010c52b,0xc(%esp)
c01026c4:	c0 
c01026c5:	c7 44 24 08 3f c5 10 	movl   $0xc010c53f,0x8(%esp)
c01026cc:	c0 
c01026cd:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01026d4:	00 
c01026d5:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c01026dc:	e8 f9 e6 ff ff       	call   c0100dda <__panic>
        mm = check_mm_struct;
c01026e1:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c01026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026e9:	eb 46                	jmp    c0102731 <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c01026eb:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01026f0:	85 c0                	test   %eax,%eax
c01026f2:	75 32                	jne    c0102726 <pgfault_handler+0x9b>
            print_trapframe(tf);
c01026f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f7:	89 04 24             	mov    %eax,(%esp)
c01026fa:	e8 93 fc ff ff       	call   c0102392 <print_trapframe>
            print_pgfault(tf);
c01026ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102702:	89 04 24             	mov    %eax,(%esp)
c0102705:	e8 04 ff ff ff       	call   c010260e <print_pgfault>
            panic("unhandled page fault.\n");
c010270a:	c7 44 24 08 54 c5 10 	movl   $0xc010c554,0x8(%esp)
c0102711:	c0 
c0102712:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0102719:	00 
c010271a:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102721:	e8 b4 e6 ff ff       	call   c0100dda <__panic>
        }
        mm = current->mm;
c0102726:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010272b:	8b 40 18             	mov    0x18(%eax),%eax
c010272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102731:	0f 20 d0             	mov    %cr2,%eax
c0102734:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c0102737:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c010273a:	89 c2                	mov    %eax,%edx
c010273c:	8b 45 08             	mov    0x8(%ebp),%eax
c010273f:	8b 40 34             	mov    0x34(%eax),%eax
c0102742:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102746:	89 44 24 04          	mov    %eax,0x4(%esp)
c010274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010274d:	89 04 24             	mov    %eax,(%esp)
c0102750:	e8 e5 62 00 00       	call   c0108a3a <do_pgfault>
}
c0102755:	c9                   	leave  
c0102756:	c3                   	ret    

c0102757 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102757:	55                   	push   %ebp
c0102758:	89 e5                	mov    %esp,%ebp
c010275a:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c010275d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c0102764:	8b 45 08             	mov    0x8(%ebp),%eax
c0102767:	8b 40 30             	mov    0x30(%eax),%eax
c010276a:	83 f8 2f             	cmp    $0x2f,%eax
c010276d:	77 38                	ja     c01027a7 <trap_dispatch+0x50>
c010276f:	83 f8 2e             	cmp    $0x2e,%eax
c0102772:	0f 83 da 01 00 00    	jae    c0102952 <trap_dispatch+0x1fb>
c0102778:	83 f8 20             	cmp    $0x20,%eax
c010277b:	0f 84 07 01 00 00    	je     c0102888 <trap_dispatch+0x131>
c0102781:	83 f8 20             	cmp    $0x20,%eax
c0102784:	77 0a                	ja     c0102790 <trap_dispatch+0x39>
c0102786:	83 f8 0e             	cmp    $0xe,%eax
c0102789:	74 3e                	je     c01027c9 <trap_dispatch+0x72>
c010278b:	e9 7a 01 00 00       	jmp    c010290a <trap_dispatch+0x1b3>
c0102790:	83 f8 21             	cmp    $0x21,%eax
c0102793:	0f 84 2f 01 00 00    	je     c01028c8 <trap_dispatch+0x171>
c0102799:	83 f8 24             	cmp    $0x24,%eax
c010279c:	0f 84 fd 00 00 00    	je     c010289f <trap_dispatch+0x148>
c01027a2:	e9 63 01 00 00       	jmp    c010290a <trap_dispatch+0x1b3>
c01027a7:	83 f8 78             	cmp    $0x78,%eax
c01027aa:	0f 82 5a 01 00 00    	jb     c010290a <trap_dispatch+0x1b3>
c01027b0:	83 f8 79             	cmp    $0x79,%eax
c01027b3:	0f 86 35 01 00 00    	jbe    c01028ee <trap_dispatch+0x197>
c01027b9:	3d 80 00 00 00       	cmp    $0x80,%eax
c01027be:	0f 84 ba 00 00 00    	je     c010287e <trap_dispatch+0x127>
c01027c4:	e9 41 01 00 00       	jmp    c010290a <trap_dispatch+0x1b3>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01027c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01027cc:	89 04 24             	mov    %eax,(%esp)
c01027cf:	e8 b7 fe ff ff       	call   c010268b <pgfault_handler>
c01027d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01027d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01027db:	0f 84 98 00 00 00    	je     c0102879 <trap_dispatch+0x122>
            print_trapframe(tf);
c01027e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e4:	89 04 24             	mov    %eax,(%esp)
c01027e7:	e8 a6 fb ff ff       	call   c0102392 <print_trapframe>
            if (current == NULL) {
c01027ec:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01027f1:	85 c0                	test   %eax,%eax
c01027f3:	75 23                	jne    c0102818 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c01027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01027fc:	c7 44 24 08 6c c5 10 	movl   $0xc010c56c,0x8(%esp)
c0102803:	c0 
c0102804:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010280b:	00 
c010280c:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102813:	e8 c2 e5 ff ff       	call   c0100dda <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c0102818:	8b 45 08             	mov    0x8(%ebp),%eax
c010281b:	89 04 24             	mov    %eax,(%esp)
c010281e:	e8 59 fb ff ff       	call   c010237c <trap_in_kernel>
c0102823:	85 c0                	test   %eax,%eax
c0102825:	74 23                	je     c010284a <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102827:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010282a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010282e:	c7 44 24 08 8c c5 10 	movl   $0xc010c58c,0x8(%esp)
c0102835:	c0 
c0102836:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c010283d:	00 
c010283e:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102845:	e8 90 e5 ff ff       	call   c0100dda <__panic>
                }
                cprintf("killed by kernel.\n");
c010284a:	c7 04 24 ba c5 10 c0 	movl   $0xc010c5ba,(%esp)
c0102851:	e8 02 db ff ff       	call   c0100358 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c0102856:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102859:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010285d:	c7 44 24 08 d0 c5 10 	movl   $0xc010c5d0,0x8(%esp)
c0102864:	c0 
c0102865:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c010286c:	00 
c010286d:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102874:	e8 61 e5 ff ff       	call   c0100dda <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c0102879:	e9 d5 00 00 00       	jmp    c0102953 <trap_dispatch+0x1fc>
    case T_SYSCALL:
        syscall();
c010287e:	e8 21 89 00 00       	call   c010b1a4 <syscall>
        break;
c0102883:	e9 cb 00 00 00       	jmp    c0102953 <trap_dispatch+0x1fc>
        /* LAB6 2013011303 */
        /* you should upate you lab5 code
         * IMPORTANT FUNCTIONS:
	     * sched_class_proc_tick
         */
        ticks++;
c0102888:	a1 78 0e 1b c0       	mov    0xc01b0e78,%eax
c010288d:	83 c0 01             	add    $0x1,%eax
c0102890:	a3 78 0e 1b c0       	mov    %eax,0xc01b0e78
        schedule_tick();
c0102895:	e8 94 87 00 00       	call   c010b02e <schedule_tick>
        break;
c010289a:	e9 b4 00 00 00       	jmp    c0102953 <trap_dispatch+0x1fc>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c010289f:	e8 a4 ee ff ff       	call   c0101748 <cons_getc>
c01028a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01028a7:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028ab:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028af:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028b7:	c7 04 24 f9 c5 10 c0 	movl   $0xc010c5f9,(%esp)
c01028be:	e8 95 da ff ff       	call   c0100358 <cprintf>
        break;
c01028c3:	e9 8b 00 00 00       	jmp    c0102953 <trap_dispatch+0x1fc>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01028c8:	e8 7b ee ff ff       	call   c0101748 <cons_getc>
c01028cd:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01028d0:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028d4:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028d8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028e0:	c7 04 24 0b c6 10 c0 	movl   $0xc010c60b,(%esp)
c01028e7:	e8 6c da ff ff       	call   c0100358 <cprintf>
        break;
c01028ec:	eb 65                	jmp    c0102953 <trap_dispatch+0x1fc>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01028ee:	c7 44 24 08 1a c6 10 	movl   $0xc010c61a,0x8(%esp)
c01028f5:	c0 
c01028f6:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01028fd:	00 
c01028fe:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c0102905:	e8 d0 e4 ff ff       	call   c0100dda <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c010290a:	8b 45 08             	mov    0x8(%ebp),%eax
c010290d:	89 04 24             	mov    %eax,(%esp)
c0102910:	e8 7d fa ff ff       	call   c0102392 <print_trapframe>
        if (current != NULL) {
c0102915:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010291a:	85 c0                	test   %eax,%eax
c010291c:	74 18                	je     c0102936 <trap_dispatch+0x1df>
            cprintf("unhandled trap.\n");
c010291e:	c7 04 24 2a c6 10 c0 	movl   $0xc010c62a,(%esp)
c0102925:	e8 2e da ff ff       	call   c0100358 <cprintf>
            do_exit(-E_KILLED);
c010292a:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102931:	e8 9d 71 00 00       	call   c0109ad3 <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102936:	c7 44 24 08 3b c6 10 	movl   $0xc010c63b,0x8(%esp)
c010293d:	c0 
c010293e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0102945:	00 
c0102946:	c7 04 24 2e c3 10 c0 	movl   $0xc010c32e,(%esp)
c010294d:	e8 88 e4 ff ff       	call   c0100dda <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102952:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c0102953:	c9                   	leave  
c0102954:	c3                   	ret    

c0102955 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102955:	55                   	push   %ebp
c0102956:	89 e5                	mov    %esp,%ebp
c0102958:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c010295b:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0102960:	85 c0                	test   %eax,%eax
c0102962:	75 0d                	jne    c0102971 <trap+0x1c>
        trap_dispatch(tf);
c0102964:	8b 45 08             	mov    0x8(%ebp),%eax
c0102967:	89 04 24             	mov    %eax,(%esp)
c010296a:	e8 e8 fd ff ff       	call   c0102757 <trap_dispatch>
c010296f:	eb 6c                	jmp    c01029dd <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c0102971:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0102976:	8b 40 3c             	mov    0x3c(%eax),%eax
c0102979:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c010297c:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0102981:	8b 55 08             	mov    0x8(%ebp),%edx
c0102984:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c0102987:	8b 45 08             	mov    0x8(%ebp),%eax
c010298a:	89 04 24             	mov    %eax,(%esp)
c010298d:	e8 ea f9 ff ff       	call   c010237c <trap_in_kernel>
c0102992:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c0102995:	8b 45 08             	mov    0x8(%ebp),%eax
c0102998:	89 04 24             	mov    %eax,(%esp)
c010299b:	e8 b7 fd ff ff       	call   c0102757 <trap_dispatch>
    
        current->tf = otf;
c01029a0:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01029a8:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c01029ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01029af:	75 2c                	jne    c01029dd <trap+0x88>
            if (current->flags & PF_EXITING) {
c01029b1:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01029b6:	8b 40 44             	mov    0x44(%eax),%eax
c01029b9:	83 e0 01             	and    $0x1,%eax
c01029bc:	85 c0                	test   %eax,%eax
c01029be:	74 0c                	je     c01029cc <trap+0x77>
                do_exit(-E_KILLED);
c01029c0:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c01029c7:	e8 07 71 00 00       	call   c0109ad3 <do_exit>
            }
            if (current->need_resched) {
c01029cc:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01029d1:	8b 40 10             	mov    0x10(%eax),%eax
c01029d4:	85 c0                	test   %eax,%eax
c01029d6:	74 05                	je     c01029dd <trap+0x88>
                schedule();
c01029d8:	e8 c6 85 00 00       	call   c010afa3 <schedule>
            }
        }
    }
}
c01029dd:	c9                   	leave  
c01029de:	c3                   	ret    

c01029df <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029df:	1e                   	push   %ds
    pushl %es
c01029e0:	06                   	push   %es
    pushl %fs
c01029e1:	0f a0                	push   %fs
    pushl %gs
c01029e3:	0f a8                	push   %gs
    pushal
c01029e5:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029e6:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01029eb:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01029ed:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01029ef:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01029f0:	e8 60 ff ff ff       	call   c0102955 <trap>

    # pop the pushed stack pointer
    popl %esp
c01029f5:	5c                   	pop    %esp

c01029f6 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01029f6:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01029f7:	0f a9                	pop    %gs
    popl %fs
c01029f9:	0f a1                	pop    %fs
    popl %es
c01029fb:	07                   	pop    %es
    popl %ds
c01029fc:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029fd:	83 c4 08             	add    $0x8,%esp
    iret
c0102a00:	cf                   	iret   

c0102a01 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102a01:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102a05:	e9 ec ff ff ff       	jmp    c01029f6 <__trapret>

c0102a0a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  jmp __alltraps
c0102a0e:	e9 cc ff ff ff       	jmp    c01029df <__alltraps>

c0102a13 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102a13:	6a 00                	push   $0x0
  pushl $1
c0102a15:	6a 01                	push   $0x1
  jmp __alltraps
c0102a17:	e9 c3 ff ff ff       	jmp    c01029df <__alltraps>

c0102a1c <vector2>:
.globl vector2
vector2:
  pushl $0
c0102a1c:	6a 00                	push   $0x0
  pushl $2
c0102a1e:	6a 02                	push   $0x2
  jmp __alltraps
c0102a20:	e9 ba ff ff ff       	jmp    c01029df <__alltraps>

c0102a25 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102a25:	6a 00                	push   $0x0
  pushl $3
c0102a27:	6a 03                	push   $0x3
  jmp __alltraps
c0102a29:	e9 b1 ff ff ff       	jmp    c01029df <__alltraps>

c0102a2e <vector4>:
.globl vector4
vector4:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $4
c0102a30:	6a 04                	push   $0x4
  jmp __alltraps
c0102a32:	e9 a8 ff ff ff       	jmp    c01029df <__alltraps>

c0102a37 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102a37:	6a 00                	push   $0x0
  pushl $5
c0102a39:	6a 05                	push   $0x5
  jmp __alltraps
c0102a3b:	e9 9f ff ff ff       	jmp    c01029df <__alltraps>

c0102a40 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102a40:	6a 00                	push   $0x0
  pushl $6
c0102a42:	6a 06                	push   $0x6
  jmp __alltraps
c0102a44:	e9 96 ff ff ff       	jmp    c01029df <__alltraps>

c0102a49 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102a49:	6a 00                	push   $0x0
  pushl $7
c0102a4b:	6a 07                	push   $0x7
  jmp __alltraps
c0102a4d:	e9 8d ff ff ff       	jmp    c01029df <__alltraps>

c0102a52 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102a52:	6a 08                	push   $0x8
  jmp __alltraps
c0102a54:	e9 86 ff ff ff       	jmp    c01029df <__alltraps>

c0102a59 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102a59:	6a 09                	push   $0x9
  jmp __alltraps
c0102a5b:	e9 7f ff ff ff       	jmp    c01029df <__alltraps>

c0102a60 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102a60:	6a 0a                	push   $0xa
  jmp __alltraps
c0102a62:	e9 78 ff ff ff       	jmp    c01029df <__alltraps>

c0102a67 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102a67:	6a 0b                	push   $0xb
  jmp __alltraps
c0102a69:	e9 71 ff ff ff       	jmp    c01029df <__alltraps>

c0102a6e <vector12>:
.globl vector12
vector12:
  pushl $12
c0102a6e:	6a 0c                	push   $0xc
  jmp __alltraps
c0102a70:	e9 6a ff ff ff       	jmp    c01029df <__alltraps>

c0102a75 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102a75:	6a 0d                	push   $0xd
  jmp __alltraps
c0102a77:	e9 63 ff ff ff       	jmp    c01029df <__alltraps>

c0102a7c <vector14>:
.globl vector14
vector14:
  pushl $14
c0102a7c:	6a 0e                	push   $0xe
  jmp __alltraps
c0102a7e:	e9 5c ff ff ff       	jmp    c01029df <__alltraps>

c0102a83 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102a83:	6a 00                	push   $0x0
  pushl $15
c0102a85:	6a 0f                	push   $0xf
  jmp __alltraps
c0102a87:	e9 53 ff ff ff       	jmp    c01029df <__alltraps>

c0102a8c <vector16>:
.globl vector16
vector16:
  pushl $0
c0102a8c:	6a 00                	push   $0x0
  pushl $16
c0102a8e:	6a 10                	push   $0x10
  jmp __alltraps
c0102a90:	e9 4a ff ff ff       	jmp    c01029df <__alltraps>

c0102a95 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102a95:	6a 11                	push   $0x11
  jmp __alltraps
c0102a97:	e9 43 ff ff ff       	jmp    c01029df <__alltraps>

c0102a9c <vector18>:
.globl vector18
vector18:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $18
c0102a9e:	6a 12                	push   $0x12
  jmp __alltraps
c0102aa0:	e9 3a ff ff ff       	jmp    c01029df <__alltraps>

c0102aa5 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $19
c0102aa7:	6a 13                	push   $0x13
  jmp __alltraps
c0102aa9:	e9 31 ff ff ff       	jmp    c01029df <__alltraps>

c0102aae <vector20>:
.globl vector20
vector20:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $20
c0102ab0:	6a 14                	push   $0x14
  jmp __alltraps
c0102ab2:	e9 28 ff ff ff       	jmp    c01029df <__alltraps>

c0102ab7 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $21
c0102ab9:	6a 15                	push   $0x15
  jmp __alltraps
c0102abb:	e9 1f ff ff ff       	jmp    c01029df <__alltraps>

c0102ac0 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $22
c0102ac2:	6a 16                	push   $0x16
  jmp __alltraps
c0102ac4:	e9 16 ff ff ff       	jmp    c01029df <__alltraps>

c0102ac9 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $23
c0102acb:	6a 17                	push   $0x17
  jmp __alltraps
c0102acd:	e9 0d ff ff ff       	jmp    c01029df <__alltraps>

c0102ad2 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $24
c0102ad4:	6a 18                	push   $0x18
  jmp __alltraps
c0102ad6:	e9 04 ff ff ff       	jmp    c01029df <__alltraps>

c0102adb <vector25>:
.globl vector25
vector25:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $25
c0102add:	6a 19                	push   $0x19
  jmp __alltraps
c0102adf:	e9 fb fe ff ff       	jmp    c01029df <__alltraps>

c0102ae4 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $26
c0102ae6:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102ae8:	e9 f2 fe ff ff       	jmp    c01029df <__alltraps>

c0102aed <vector27>:
.globl vector27
vector27:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $27
c0102aef:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102af1:	e9 e9 fe ff ff       	jmp    c01029df <__alltraps>

c0102af6 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $28
c0102af8:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102afa:	e9 e0 fe ff ff       	jmp    c01029df <__alltraps>

c0102aff <vector29>:
.globl vector29
vector29:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $29
c0102b01:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102b03:	e9 d7 fe ff ff       	jmp    c01029df <__alltraps>

c0102b08 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $30
c0102b0a:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102b0c:	e9 ce fe ff ff       	jmp    c01029df <__alltraps>

c0102b11 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $31
c0102b13:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102b15:	e9 c5 fe ff ff       	jmp    c01029df <__alltraps>

c0102b1a <vector32>:
.globl vector32
vector32:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $32
c0102b1c:	6a 20                	push   $0x20
  jmp __alltraps
c0102b1e:	e9 bc fe ff ff       	jmp    c01029df <__alltraps>

c0102b23 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $33
c0102b25:	6a 21                	push   $0x21
  jmp __alltraps
c0102b27:	e9 b3 fe ff ff       	jmp    c01029df <__alltraps>

c0102b2c <vector34>:
.globl vector34
vector34:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $34
c0102b2e:	6a 22                	push   $0x22
  jmp __alltraps
c0102b30:	e9 aa fe ff ff       	jmp    c01029df <__alltraps>

c0102b35 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $35
c0102b37:	6a 23                	push   $0x23
  jmp __alltraps
c0102b39:	e9 a1 fe ff ff       	jmp    c01029df <__alltraps>

c0102b3e <vector36>:
.globl vector36
vector36:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $36
c0102b40:	6a 24                	push   $0x24
  jmp __alltraps
c0102b42:	e9 98 fe ff ff       	jmp    c01029df <__alltraps>

c0102b47 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $37
c0102b49:	6a 25                	push   $0x25
  jmp __alltraps
c0102b4b:	e9 8f fe ff ff       	jmp    c01029df <__alltraps>

c0102b50 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $38
c0102b52:	6a 26                	push   $0x26
  jmp __alltraps
c0102b54:	e9 86 fe ff ff       	jmp    c01029df <__alltraps>

c0102b59 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $39
c0102b5b:	6a 27                	push   $0x27
  jmp __alltraps
c0102b5d:	e9 7d fe ff ff       	jmp    c01029df <__alltraps>

c0102b62 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $40
c0102b64:	6a 28                	push   $0x28
  jmp __alltraps
c0102b66:	e9 74 fe ff ff       	jmp    c01029df <__alltraps>

c0102b6b <vector41>:
.globl vector41
vector41:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $41
c0102b6d:	6a 29                	push   $0x29
  jmp __alltraps
c0102b6f:	e9 6b fe ff ff       	jmp    c01029df <__alltraps>

c0102b74 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $42
c0102b76:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102b78:	e9 62 fe ff ff       	jmp    c01029df <__alltraps>

c0102b7d <vector43>:
.globl vector43
vector43:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $43
c0102b7f:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102b81:	e9 59 fe ff ff       	jmp    c01029df <__alltraps>

c0102b86 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $44
c0102b88:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102b8a:	e9 50 fe ff ff       	jmp    c01029df <__alltraps>

c0102b8f <vector45>:
.globl vector45
vector45:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $45
c0102b91:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102b93:	e9 47 fe ff ff       	jmp    c01029df <__alltraps>

c0102b98 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $46
c0102b9a:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102b9c:	e9 3e fe ff ff       	jmp    c01029df <__alltraps>

c0102ba1 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $47
c0102ba3:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102ba5:	e9 35 fe ff ff       	jmp    c01029df <__alltraps>

c0102baa <vector48>:
.globl vector48
vector48:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $48
c0102bac:	6a 30                	push   $0x30
  jmp __alltraps
c0102bae:	e9 2c fe ff ff       	jmp    c01029df <__alltraps>

c0102bb3 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $49
c0102bb5:	6a 31                	push   $0x31
  jmp __alltraps
c0102bb7:	e9 23 fe ff ff       	jmp    c01029df <__alltraps>

c0102bbc <vector50>:
.globl vector50
vector50:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $50
c0102bbe:	6a 32                	push   $0x32
  jmp __alltraps
c0102bc0:	e9 1a fe ff ff       	jmp    c01029df <__alltraps>

c0102bc5 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $51
c0102bc7:	6a 33                	push   $0x33
  jmp __alltraps
c0102bc9:	e9 11 fe ff ff       	jmp    c01029df <__alltraps>

c0102bce <vector52>:
.globl vector52
vector52:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $52
c0102bd0:	6a 34                	push   $0x34
  jmp __alltraps
c0102bd2:	e9 08 fe ff ff       	jmp    c01029df <__alltraps>

c0102bd7 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $53
c0102bd9:	6a 35                	push   $0x35
  jmp __alltraps
c0102bdb:	e9 ff fd ff ff       	jmp    c01029df <__alltraps>

c0102be0 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $54
c0102be2:	6a 36                	push   $0x36
  jmp __alltraps
c0102be4:	e9 f6 fd ff ff       	jmp    c01029df <__alltraps>

c0102be9 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102be9:	6a 00                	push   $0x0
  pushl $55
c0102beb:	6a 37                	push   $0x37
  jmp __alltraps
c0102bed:	e9 ed fd ff ff       	jmp    c01029df <__alltraps>

c0102bf2 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $56
c0102bf4:	6a 38                	push   $0x38
  jmp __alltraps
c0102bf6:	e9 e4 fd ff ff       	jmp    c01029df <__alltraps>

c0102bfb <vector57>:
.globl vector57
vector57:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $57
c0102bfd:	6a 39                	push   $0x39
  jmp __alltraps
c0102bff:	e9 db fd ff ff       	jmp    c01029df <__alltraps>

c0102c04 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $58
c0102c06:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102c08:	e9 d2 fd ff ff       	jmp    c01029df <__alltraps>

c0102c0d <vector59>:
.globl vector59
vector59:
  pushl $0
c0102c0d:	6a 00                	push   $0x0
  pushl $59
c0102c0f:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102c11:	e9 c9 fd ff ff       	jmp    c01029df <__alltraps>

c0102c16 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102c16:	6a 00                	push   $0x0
  pushl $60
c0102c18:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102c1a:	e9 c0 fd ff ff       	jmp    c01029df <__alltraps>

c0102c1f <vector61>:
.globl vector61
vector61:
  pushl $0
c0102c1f:	6a 00                	push   $0x0
  pushl $61
c0102c21:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102c23:	e9 b7 fd ff ff       	jmp    c01029df <__alltraps>

c0102c28 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $62
c0102c2a:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102c2c:	e9 ae fd ff ff       	jmp    c01029df <__alltraps>

c0102c31 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102c31:	6a 00                	push   $0x0
  pushl $63
c0102c33:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102c35:	e9 a5 fd ff ff       	jmp    c01029df <__alltraps>

c0102c3a <vector64>:
.globl vector64
vector64:
  pushl $0
c0102c3a:	6a 00                	push   $0x0
  pushl $64
c0102c3c:	6a 40                	push   $0x40
  jmp __alltraps
c0102c3e:	e9 9c fd ff ff       	jmp    c01029df <__alltraps>

c0102c43 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102c43:	6a 00                	push   $0x0
  pushl $65
c0102c45:	6a 41                	push   $0x41
  jmp __alltraps
c0102c47:	e9 93 fd ff ff       	jmp    c01029df <__alltraps>

c0102c4c <vector66>:
.globl vector66
vector66:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $66
c0102c4e:	6a 42                	push   $0x42
  jmp __alltraps
c0102c50:	e9 8a fd ff ff       	jmp    c01029df <__alltraps>

c0102c55 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102c55:	6a 00                	push   $0x0
  pushl $67
c0102c57:	6a 43                	push   $0x43
  jmp __alltraps
c0102c59:	e9 81 fd ff ff       	jmp    c01029df <__alltraps>

c0102c5e <vector68>:
.globl vector68
vector68:
  pushl $0
c0102c5e:	6a 00                	push   $0x0
  pushl $68
c0102c60:	6a 44                	push   $0x44
  jmp __alltraps
c0102c62:	e9 78 fd ff ff       	jmp    c01029df <__alltraps>

c0102c67 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102c67:	6a 00                	push   $0x0
  pushl $69
c0102c69:	6a 45                	push   $0x45
  jmp __alltraps
c0102c6b:	e9 6f fd ff ff       	jmp    c01029df <__alltraps>

c0102c70 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $70
c0102c72:	6a 46                	push   $0x46
  jmp __alltraps
c0102c74:	e9 66 fd ff ff       	jmp    c01029df <__alltraps>

c0102c79 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102c79:	6a 00                	push   $0x0
  pushl $71
c0102c7b:	6a 47                	push   $0x47
  jmp __alltraps
c0102c7d:	e9 5d fd ff ff       	jmp    c01029df <__alltraps>

c0102c82 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102c82:	6a 00                	push   $0x0
  pushl $72
c0102c84:	6a 48                	push   $0x48
  jmp __alltraps
c0102c86:	e9 54 fd ff ff       	jmp    c01029df <__alltraps>

c0102c8b <vector73>:
.globl vector73
vector73:
  pushl $0
c0102c8b:	6a 00                	push   $0x0
  pushl $73
c0102c8d:	6a 49                	push   $0x49
  jmp __alltraps
c0102c8f:	e9 4b fd ff ff       	jmp    c01029df <__alltraps>

c0102c94 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $74
c0102c96:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102c98:	e9 42 fd ff ff       	jmp    c01029df <__alltraps>

c0102c9d <vector75>:
.globl vector75
vector75:
  pushl $0
c0102c9d:	6a 00                	push   $0x0
  pushl $75
c0102c9f:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ca1:	e9 39 fd ff ff       	jmp    c01029df <__alltraps>

c0102ca6 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ca6:	6a 00                	push   $0x0
  pushl $76
c0102ca8:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102caa:	e9 30 fd ff ff       	jmp    c01029df <__alltraps>

c0102caf <vector77>:
.globl vector77
vector77:
  pushl $0
c0102caf:	6a 00                	push   $0x0
  pushl $77
c0102cb1:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102cb3:	e9 27 fd ff ff       	jmp    c01029df <__alltraps>

c0102cb8 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $78
c0102cba:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102cbc:	e9 1e fd ff ff       	jmp    c01029df <__alltraps>

c0102cc1 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102cc1:	6a 00                	push   $0x0
  pushl $79
c0102cc3:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102cc5:	e9 15 fd ff ff       	jmp    c01029df <__alltraps>

c0102cca <vector80>:
.globl vector80
vector80:
  pushl $0
c0102cca:	6a 00                	push   $0x0
  pushl $80
c0102ccc:	6a 50                	push   $0x50
  jmp __alltraps
c0102cce:	e9 0c fd ff ff       	jmp    c01029df <__alltraps>

c0102cd3 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102cd3:	6a 00                	push   $0x0
  pushl $81
c0102cd5:	6a 51                	push   $0x51
  jmp __alltraps
c0102cd7:	e9 03 fd ff ff       	jmp    c01029df <__alltraps>

c0102cdc <vector82>:
.globl vector82
vector82:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $82
c0102cde:	6a 52                	push   $0x52
  jmp __alltraps
c0102ce0:	e9 fa fc ff ff       	jmp    c01029df <__alltraps>

c0102ce5 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102ce5:	6a 00                	push   $0x0
  pushl $83
c0102ce7:	6a 53                	push   $0x53
  jmp __alltraps
c0102ce9:	e9 f1 fc ff ff       	jmp    c01029df <__alltraps>

c0102cee <vector84>:
.globl vector84
vector84:
  pushl $0
c0102cee:	6a 00                	push   $0x0
  pushl $84
c0102cf0:	6a 54                	push   $0x54
  jmp __alltraps
c0102cf2:	e9 e8 fc ff ff       	jmp    c01029df <__alltraps>

c0102cf7 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102cf7:	6a 00                	push   $0x0
  pushl $85
c0102cf9:	6a 55                	push   $0x55
  jmp __alltraps
c0102cfb:	e9 df fc ff ff       	jmp    c01029df <__alltraps>

c0102d00 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $86
c0102d02:	6a 56                	push   $0x56
  jmp __alltraps
c0102d04:	e9 d6 fc ff ff       	jmp    c01029df <__alltraps>

c0102d09 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102d09:	6a 00                	push   $0x0
  pushl $87
c0102d0b:	6a 57                	push   $0x57
  jmp __alltraps
c0102d0d:	e9 cd fc ff ff       	jmp    c01029df <__alltraps>

c0102d12 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102d12:	6a 00                	push   $0x0
  pushl $88
c0102d14:	6a 58                	push   $0x58
  jmp __alltraps
c0102d16:	e9 c4 fc ff ff       	jmp    c01029df <__alltraps>

c0102d1b <vector89>:
.globl vector89
vector89:
  pushl $0
c0102d1b:	6a 00                	push   $0x0
  pushl $89
c0102d1d:	6a 59                	push   $0x59
  jmp __alltraps
c0102d1f:	e9 bb fc ff ff       	jmp    c01029df <__alltraps>

c0102d24 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $90
c0102d26:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102d28:	e9 b2 fc ff ff       	jmp    c01029df <__alltraps>

c0102d2d <vector91>:
.globl vector91
vector91:
  pushl $0
c0102d2d:	6a 00                	push   $0x0
  pushl $91
c0102d2f:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102d31:	e9 a9 fc ff ff       	jmp    c01029df <__alltraps>

c0102d36 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102d36:	6a 00                	push   $0x0
  pushl $92
c0102d38:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102d3a:	e9 a0 fc ff ff       	jmp    c01029df <__alltraps>

c0102d3f <vector93>:
.globl vector93
vector93:
  pushl $0
c0102d3f:	6a 00                	push   $0x0
  pushl $93
c0102d41:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102d43:	e9 97 fc ff ff       	jmp    c01029df <__alltraps>

c0102d48 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $94
c0102d4a:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102d4c:	e9 8e fc ff ff       	jmp    c01029df <__alltraps>

c0102d51 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102d51:	6a 00                	push   $0x0
  pushl $95
c0102d53:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102d55:	e9 85 fc ff ff       	jmp    c01029df <__alltraps>

c0102d5a <vector96>:
.globl vector96
vector96:
  pushl $0
c0102d5a:	6a 00                	push   $0x0
  pushl $96
c0102d5c:	6a 60                	push   $0x60
  jmp __alltraps
c0102d5e:	e9 7c fc ff ff       	jmp    c01029df <__alltraps>

c0102d63 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102d63:	6a 00                	push   $0x0
  pushl $97
c0102d65:	6a 61                	push   $0x61
  jmp __alltraps
c0102d67:	e9 73 fc ff ff       	jmp    c01029df <__alltraps>

c0102d6c <vector98>:
.globl vector98
vector98:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $98
c0102d6e:	6a 62                	push   $0x62
  jmp __alltraps
c0102d70:	e9 6a fc ff ff       	jmp    c01029df <__alltraps>

c0102d75 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102d75:	6a 00                	push   $0x0
  pushl $99
c0102d77:	6a 63                	push   $0x63
  jmp __alltraps
c0102d79:	e9 61 fc ff ff       	jmp    c01029df <__alltraps>

c0102d7e <vector100>:
.globl vector100
vector100:
  pushl $0
c0102d7e:	6a 00                	push   $0x0
  pushl $100
c0102d80:	6a 64                	push   $0x64
  jmp __alltraps
c0102d82:	e9 58 fc ff ff       	jmp    c01029df <__alltraps>

c0102d87 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102d87:	6a 00                	push   $0x0
  pushl $101
c0102d89:	6a 65                	push   $0x65
  jmp __alltraps
c0102d8b:	e9 4f fc ff ff       	jmp    c01029df <__alltraps>

c0102d90 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $102
c0102d92:	6a 66                	push   $0x66
  jmp __alltraps
c0102d94:	e9 46 fc ff ff       	jmp    c01029df <__alltraps>

c0102d99 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102d99:	6a 00                	push   $0x0
  pushl $103
c0102d9b:	6a 67                	push   $0x67
  jmp __alltraps
c0102d9d:	e9 3d fc ff ff       	jmp    c01029df <__alltraps>

c0102da2 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102da2:	6a 00                	push   $0x0
  pushl $104
c0102da4:	6a 68                	push   $0x68
  jmp __alltraps
c0102da6:	e9 34 fc ff ff       	jmp    c01029df <__alltraps>

c0102dab <vector105>:
.globl vector105
vector105:
  pushl $0
c0102dab:	6a 00                	push   $0x0
  pushl $105
c0102dad:	6a 69                	push   $0x69
  jmp __alltraps
c0102daf:	e9 2b fc ff ff       	jmp    c01029df <__alltraps>

c0102db4 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $106
c0102db6:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102db8:	e9 22 fc ff ff       	jmp    c01029df <__alltraps>

c0102dbd <vector107>:
.globl vector107
vector107:
  pushl $0
c0102dbd:	6a 00                	push   $0x0
  pushl $107
c0102dbf:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102dc1:	e9 19 fc ff ff       	jmp    c01029df <__alltraps>

c0102dc6 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102dc6:	6a 00                	push   $0x0
  pushl $108
c0102dc8:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102dca:	e9 10 fc ff ff       	jmp    c01029df <__alltraps>

c0102dcf <vector109>:
.globl vector109
vector109:
  pushl $0
c0102dcf:	6a 00                	push   $0x0
  pushl $109
c0102dd1:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102dd3:	e9 07 fc ff ff       	jmp    c01029df <__alltraps>

c0102dd8 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $110
c0102dda:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102ddc:	e9 fe fb ff ff       	jmp    c01029df <__alltraps>

c0102de1 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102de1:	6a 00                	push   $0x0
  pushl $111
c0102de3:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102de5:	e9 f5 fb ff ff       	jmp    c01029df <__alltraps>

c0102dea <vector112>:
.globl vector112
vector112:
  pushl $0
c0102dea:	6a 00                	push   $0x0
  pushl $112
c0102dec:	6a 70                	push   $0x70
  jmp __alltraps
c0102dee:	e9 ec fb ff ff       	jmp    c01029df <__alltraps>

c0102df3 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102df3:	6a 00                	push   $0x0
  pushl $113
c0102df5:	6a 71                	push   $0x71
  jmp __alltraps
c0102df7:	e9 e3 fb ff ff       	jmp    c01029df <__alltraps>

c0102dfc <vector114>:
.globl vector114
vector114:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $114
c0102dfe:	6a 72                	push   $0x72
  jmp __alltraps
c0102e00:	e9 da fb ff ff       	jmp    c01029df <__alltraps>

c0102e05 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102e05:	6a 00                	push   $0x0
  pushl $115
c0102e07:	6a 73                	push   $0x73
  jmp __alltraps
c0102e09:	e9 d1 fb ff ff       	jmp    c01029df <__alltraps>

c0102e0e <vector116>:
.globl vector116
vector116:
  pushl $0
c0102e0e:	6a 00                	push   $0x0
  pushl $116
c0102e10:	6a 74                	push   $0x74
  jmp __alltraps
c0102e12:	e9 c8 fb ff ff       	jmp    c01029df <__alltraps>

c0102e17 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102e17:	6a 00                	push   $0x0
  pushl $117
c0102e19:	6a 75                	push   $0x75
  jmp __alltraps
c0102e1b:	e9 bf fb ff ff       	jmp    c01029df <__alltraps>

c0102e20 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $118
c0102e22:	6a 76                	push   $0x76
  jmp __alltraps
c0102e24:	e9 b6 fb ff ff       	jmp    c01029df <__alltraps>

c0102e29 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102e29:	6a 00                	push   $0x0
  pushl $119
c0102e2b:	6a 77                	push   $0x77
  jmp __alltraps
c0102e2d:	e9 ad fb ff ff       	jmp    c01029df <__alltraps>

c0102e32 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102e32:	6a 00                	push   $0x0
  pushl $120
c0102e34:	6a 78                	push   $0x78
  jmp __alltraps
c0102e36:	e9 a4 fb ff ff       	jmp    c01029df <__alltraps>

c0102e3b <vector121>:
.globl vector121
vector121:
  pushl $0
c0102e3b:	6a 00                	push   $0x0
  pushl $121
c0102e3d:	6a 79                	push   $0x79
  jmp __alltraps
c0102e3f:	e9 9b fb ff ff       	jmp    c01029df <__alltraps>

c0102e44 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $122
c0102e46:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102e48:	e9 92 fb ff ff       	jmp    c01029df <__alltraps>

c0102e4d <vector123>:
.globl vector123
vector123:
  pushl $0
c0102e4d:	6a 00                	push   $0x0
  pushl $123
c0102e4f:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102e51:	e9 89 fb ff ff       	jmp    c01029df <__alltraps>

c0102e56 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102e56:	6a 00                	push   $0x0
  pushl $124
c0102e58:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102e5a:	e9 80 fb ff ff       	jmp    c01029df <__alltraps>

c0102e5f <vector125>:
.globl vector125
vector125:
  pushl $0
c0102e5f:	6a 00                	push   $0x0
  pushl $125
c0102e61:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102e63:	e9 77 fb ff ff       	jmp    c01029df <__alltraps>

c0102e68 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $126
c0102e6a:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102e6c:	e9 6e fb ff ff       	jmp    c01029df <__alltraps>

c0102e71 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102e71:	6a 00                	push   $0x0
  pushl $127
c0102e73:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102e75:	e9 65 fb ff ff       	jmp    c01029df <__alltraps>

c0102e7a <vector128>:
.globl vector128
vector128:
  pushl $0
c0102e7a:	6a 00                	push   $0x0
  pushl $128
c0102e7c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102e81:	e9 59 fb ff ff       	jmp    c01029df <__alltraps>

c0102e86 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102e86:	6a 00                	push   $0x0
  pushl $129
c0102e88:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102e8d:	e9 4d fb ff ff       	jmp    c01029df <__alltraps>

c0102e92 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102e92:	6a 00                	push   $0x0
  pushl $130
c0102e94:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102e99:	e9 41 fb ff ff       	jmp    c01029df <__alltraps>

c0102e9e <vector131>:
.globl vector131
vector131:
  pushl $0
c0102e9e:	6a 00                	push   $0x0
  pushl $131
c0102ea0:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102ea5:	e9 35 fb ff ff       	jmp    c01029df <__alltraps>

c0102eaa <vector132>:
.globl vector132
vector132:
  pushl $0
c0102eaa:	6a 00                	push   $0x0
  pushl $132
c0102eac:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102eb1:	e9 29 fb ff ff       	jmp    c01029df <__alltraps>

c0102eb6 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102eb6:	6a 00                	push   $0x0
  pushl $133
c0102eb8:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ebd:	e9 1d fb ff ff       	jmp    c01029df <__alltraps>

c0102ec2 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102ec2:	6a 00                	push   $0x0
  pushl $134
c0102ec4:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102ec9:	e9 11 fb ff ff       	jmp    c01029df <__alltraps>

c0102ece <vector135>:
.globl vector135
vector135:
  pushl $0
c0102ece:	6a 00                	push   $0x0
  pushl $135
c0102ed0:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102ed5:	e9 05 fb ff ff       	jmp    c01029df <__alltraps>

c0102eda <vector136>:
.globl vector136
vector136:
  pushl $0
c0102eda:	6a 00                	push   $0x0
  pushl $136
c0102edc:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ee1:	e9 f9 fa ff ff       	jmp    c01029df <__alltraps>

c0102ee6 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102ee6:	6a 00                	push   $0x0
  pushl $137
c0102ee8:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102eed:	e9 ed fa ff ff       	jmp    c01029df <__alltraps>

c0102ef2 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102ef2:	6a 00                	push   $0x0
  pushl $138
c0102ef4:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102ef9:	e9 e1 fa ff ff       	jmp    c01029df <__alltraps>

c0102efe <vector139>:
.globl vector139
vector139:
  pushl $0
c0102efe:	6a 00                	push   $0x0
  pushl $139
c0102f00:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102f05:	e9 d5 fa ff ff       	jmp    c01029df <__alltraps>

c0102f0a <vector140>:
.globl vector140
vector140:
  pushl $0
c0102f0a:	6a 00                	push   $0x0
  pushl $140
c0102f0c:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102f11:	e9 c9 fa ff ff       	jmp    c01029df <__alltraps>

c0102f16 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102f16:	6a 00                	push   $0x0
  pushl $141
c0102f18:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102f1d:	e9 bd fa ff ff       	jmp    c01029df <__alltraps>

c0102f22 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102f22:	6a 00                	push   $0x0
  pushl $142
c0102f24:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102f29:	e9 b1 fa ff ff       	jmp    c01029df <__alltraps>

c0102f2e <vector143>:
.globl vector143
vector143:
  pushl $0
c0102f2e:	6a 00                	push   $0x0
  pushl $143
c0102f30:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102f35:	e9 a5 fa ff ff       	jmp    c01029df <__alltraps>

c0102f3a <vector144>:
.globl vector144
vector144:
  pushl $0
c0102f3a:	6a 00                	push   $0x0
  pushl $144
c0102f3c:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102f41:	e9 99 fa ff ff       	jmp    c01029df <__alltraps>

c0102f46 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102f46:	6a 00                	push   $0x0
  pushl $145
c0102f48:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102f4d:	e9 8d fa ff ff       	jmp    c01029df <__alltraps>

c0102f52 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102f52:	6a 00                	push   $0x0
  pushl $146
c0102f54:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102f59:	e9 81 fa ff ff       	jmp    c01029df <__alltraps>

c0102f5e <vector147>:
.globl vector147
vector147:
  pushl $0
c0102f5e:	6a 00                	push   $0x0
  pushl $147
c0102f60:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102f65:	e9 75 fa ff ff       	jmp    c01029df <__alltraps>

c0102f6a <vector148>:
.globl vector148
vector148:
  pushl $0
c0102f6a:	6a 00                	push   $0x0
  pushl $148
c0102f6c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102f71:	e9 69 fa ff ff       	jmp    c01029df <__alltraps>

c0102f76 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102f76:	6a 00                	push   $0x0
  pushl $149
c0102f78:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102f7d:	e9 5d fa ff ff       	jmp    c01029df <__alltraps>

c0102f82 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102f82:	6a 00                	push   $0x0
  pushl $150
c0102f84:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102f89:	e9 51 fa ff ff       	jmp    c01029df <__alltraps>

c0102f8e <vector151>:
.globl vector151
vector151:
  pushl $0
c0102f8e:	6a 00                	push   $0x0
  pushl $151
c0102f90:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102f95:	e9 45 fa ff ff       	jmp    c01029df <__alltraps>

c0102f9a <vector152>:
.globl vector152
vector152:
  pushl $0
c0102f9a:	6a 00                	push   $0x0
  pushl $152
c0102f9c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102fa1:	e9 39 fa ff ff       	jmp    c01029df <__alltraps>

c0102fa6 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102fa6:	6a 00                	push   $0x0
  pushl $153
c0102fa8:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102fad:	e9 2d fa ff ff       	jmp    c01029df <__alltraps>

c0102fb2 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102fb2:	6a 00                	push   $0x0
  pushl $154
c0102fb4:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102fb9:	e9 21 fa ff ff       	jmp    c01029df <__alltraps>

c0102fbe <vector155>:
.globl vector155
vector155:
  pushl $0
c0102fbe:	6a 00                	push   $0x0
  pushl $155
c0102fc0:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102fc5:	e9 15 fa ff ff       	jmp    c01029df <__alltraps>

c0102fca <vector156>:
.globl vector156
vector156:
  pushl $0
c0102fca:	6a 00                	push   $0x0
  pushl $156
c0102fcc:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102fd1:	e9 09 fa ff ff       	jmp    c01029df <__alltraps>

c0102fd6 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102fd6:	6a 00                	push   $0x0
  pushl $157
c0102fd8:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102fdd:	e9 fd f9 ff ff       	jmp    c01029df <__alltraps>

c0102fe2 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102fe2:	6a 00                	push   $0x0
  pushl $158
c0102fe4:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102fe9:	e9 f1 f9 ff ff       	jmp    c01029df <__alltraps>

c0102fee <vector159>:
.globl vector159
vector159:
  pushl $0
c0102fee:	6a 00                	push   $0x0
  pushl $159
c0102ff0:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102ff5:	e9 e5 f9 ff ff       	jmp    c01029df <__alltraps>

c0102ffa <vector160>:
.globl vector160
vector160:
  pushl $0
c0102ffa:	6a 00                	push   $0x0
  pushl $160
c0102ffc:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0103001:	e9 d9 f9 ff ff       	jmp    c01029df <__alltraps>

c0103006 <vector161>:
.globl vector161
vector161:
  pushl $0
c0103006:	6a 00                	push   $0x0
  pushl $161
c0103008:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010300d:	e9 cd f9 ff ff       	jmp    c01029df <__alltraps>

c0103012 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103012:	6a 00                	push   $0x0
  pushl $162
c0103014:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0103019:	e9 c1 f9 ff ff       	jmp    c01029df <__alltraps>

c010301e <vector163>:
.globl vector163
vector163:
  pushl $0
c010301e:	6a 00                	push   $0x0
  pushl $163
c0103020:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0103025:	e9 b5 f9 ff ff       	jmp    c01029df <__alltraps>

c010302a <vector164>:
.globl vector164
vector164:
  pushl $0
c010302a:	6a 00                	push   $0x0
  pushl $164
c010302c:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0103031:	e9 a9 f9 ff ff       	jmp    c01029df <__alltraps>

c0103036 <vector165>:
.globl vector165
vector165:
  pushl $0
c0103036:	6a 00                	push   $0x0
  pushl $165
c0103038:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010303d:	e9 9d f9 ff ff       	jmp    c01029df <__alltraps>

c0103042 <vector166>:
.globl vector166
vector166:
  pushl $0
c0103042:	6a 00                	push   $0x0
  pushl $166
c0103044:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0103049:	e9 91 f9 ff ff       	jmp    c01029df <__alltraps>

c010304e <vector167>:
.globl vector167
vector167:
  pushl $0
c010304e:	6a 00                	push   $0x0
  pushl $167
c0103050:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0103055:	e9 85 f9 ff ff       	jmp    c01029df <__alltraps>

c010305a <vector168>:
.globl vector168
vector168:
  pushl $0
c010305a:	6a 00                	push   $0x0
  pushl $168
c010305c:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0103061:	e9 79 f9 ff ff       	jmp    c01029df <__alltraps>

c0103066 <vector169>:
.globl vector169
vector169:
  pushl $0
c0103066:	6a 00                	push   $0x0
  pushl $169
c0103068:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010306d:	e9 6d f9 ff ff       	jmp    c01029df <__alltraps>

c0103072 <vector170>:
.globl vector170
vector170:
  pushl $0
c0103072:	6a 00                	push   $0x0
  pushl $170
c0103074:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0103079:	e9 61 f9 ff ff       	jmp    c01029df <__alltraps>

c010307e <vector171>:
.globl vector171
vector171:
  pushl $0
c010307e:	6a 00                	push   $0x0
  pushl $171
c0103080:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0103085:	e9 55 f9 ff ff       	jmp    c01029df <__alltraps>

c010308a <vector172>:
.globl vector172
vector172:
  pushl $0
c010308a:	6a 00                	push   $0x0
  pushl $172
c010308c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0103091:	e9 49 f9 ff ff       	jmp    c01029df <__alltraps>

c0103096 <vector173>:
.globl vector173
vector173:
  pushl $0
c0103096:	6a 00                	push   $0x0
  pushl $173
c0103098:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010309d:	e9 3d f9 ff ff       	jmp    c01029df <__alltraps>

c01030a2 <vector174>:
.globl vector174
vector174:
  pushl $0
c01030a2:	6a 00                	push   $0x0
  pushl $174
c01030a4:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01030a9:	e9 31 f9 ff ff       	jmp    c01029df <__alltraps>

c01030ae <vector175>:
.globl vector175
vector175:
  pushl $0
c01030ae:	6a 00                	push   $0x0
  pushl $175
c01030b0:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01030b5:	e9 25 f9 ff ff       	jmp    c01029df <__alltraps>

c01030ba <vector176>:
.globl vector176
vector176:
  pushl $0
c01030ba:	6a 00                	push   $0x0
  pushl $176
c01030bc:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01030c1:	e9 19 f9 ff ff       	jmp    c01029df <__alltraps>

c01030c6 <vector177>:
.globl vector177
vector177:
  pushl $0
c01030c6:	6a 00                	push   $0x0
  pushl $177
c01030c8:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01030cd:	e9 0d f9 ff ff       	jmp    c01029df <__alltraps>

c01030d2 <vector178>:
.globl vector178
vector178:
  pushl $0
c01030d2:	6a 00                	push   $0x0
  pushl $178
c01030d4:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01030d9:	e9 01 f9 ff ff       	jmp    c01029df <__alltraps>

c01030de <vector179>:
.globl vector179
vector179:
  pushl $0
c01030de:	6a 00                	push   $0x0
  pushl $179
c01030e0:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01030e5:	e9 f5 f8 ff ff       	jmp    c01029df <__alltraps>

c01030ea <vector180>:
.globl vector180
vector180:
  pushl $0
c01030ea:	6a 00                	push   $0x0
  pushl $180
c01030ec:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01030f1:	e9 e9 f8 ff ff       	jmp    c01029df <__alltraps>

c01030f6 <vector181>:
.globl vector181
vector181:
  pushl $0
c01030f6:	6a 00                	push   $0x0
  pushl $181
c01030f8:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01030fd:	e9 dd f8 ff ff       	jmp    c01029df <__alltraps>

c0103102 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103102:	6a 00                	push   $0x0
  pushl $182
c0103104:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103109:	e9 d1 f8 ff ff       	jmp    c01029df <__alltraps>

c010310e <vector183>:
.globl vector183
vector183:
  pushl $0
c010310e:	6a 00                	push   $0x0
  pushl $183
c0103110:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103115:	e9 c5 f8 ff ff       	jmp    c01029df <__alltraps>

c010311a <vector184>:
.globl vector184
vector184:
  pushl $0
c010311a:	6a 00                	push   $0x0
  pushl $184
c010311c:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0103121:	e9 b9 f8 ff ff       	jmp    c01029df <__alltraps>

c0103126 <vector185>:
.globl vector185
vector185:
  pushl $0
c0103126:	6a 00                	push   $0x0
  pushl $185
c0103128:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010312d:	e9 ad f8 ff ff       	jmp    c01029df <__alltraps>

c0103132 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103132:	6a 00                	push   $0x0
  pushl $186
c0103134:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0103139:	e9 a1 f8 ff ff       	jmp    c01029df <__alltraps>

c010313e <vector187>:
.globl vector187
vector187:
  pushl $0
c010313e:	6a 00                	push   $0x0
  pushl $187
c0103140:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0103145:	e9 95 f8 ff ff       	jmp    c01029df <__alltraps>

c010314a <vector188>:
.globl vector188
vector188:
  pushl $0
c010314a:	6a 00                	push   $0x0
  pushl $188
c010314c:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0103151:	e9 89 f8 ff ff       	jmp    c01029df <__alltraps>

c0103156 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103156:	6a 00                	push   $0x0
  pushl $189
c0103158:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010315d:	e9 7d f8 ff ff       	jmp    c01029df <__alltraps>

c0103162 <vector190>:
.globl vector190
vector190:
  pushl $0
c0103162:	6a 00                	push   $0x0
  pushl $190
c0103164:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0103169:	e9 71 f8 ff ff       	jmp    c01029df <__alltraps>

c010316e <vector191>:
.globl vector191
vector191:
  pushl $0
c010316e:	6a 00                	push   $0x0
  pushl $191
c0103170:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0103175:	e9 65 f8 ff ff       	jmp    c01029df <__alltraps>

c010317a <vector192>:
.globl vector192
vector192:
  pushl $0
c010317a:	6a 00                	push   $0x0
  pushl $192
c010317c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0103181:	e9 59 f8 ff ff       	jmp    c01029df <__alltraps>

c0103186 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103186:	6a 00                	push   $0x0
  pushl $193
c0103188:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010318d:	e9 4d f8 ff ff       	jmp    c01029df <__alltraps>

c0103192 <vector194>:
.globl vector194
vector194:
  pushl $0
c0103192:	6a 00                	push   $0x0
  pushl $194
c0103194:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103199:	e9 41 f8 ff ff       	jmp    c01029df <__alltraps>

c010319e <vector195>:
.globl vector195
vector195:
  pushl $0
c010319e:	6a 00                	push   $0x0
  pushl $195
c01031a0:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01031a5:	e9 35 f8 ff ff       	jmp    c01029df <__alltraps>

c01031aa <vector196>:
.globl vector196
vector196:
  pushl $0
c01031aa:	6a 00                	push   $0x0
  pushl $196
c01031ac:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01031b1:	e9 29 f8 ff ff       	jmp    c01029df <__alltraps>

c01031b6 <vector197>:
.globl vector197
vector197:
  pushl $0
c01031b6:	6a 00                	push   $0x0
  pushl $197
c01031b8:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01031bd:	e9 1d f8 ff ff       	jmp    c01029df <__alltraps>

c01031c2 <vector198>:
.globl vector198
vector198:
  pushl $0
c01031c2:	6a 00                	push   $0x0
  pushl $198
c01031c4:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01031c9:	e9 11 f8 ff ff       	jmp    c01029df <__alltraps>

c01031ce <vector199>:
.globl vector199
vector199:
  pushl $0
c01031ce:	6a 00                	push   $0x0
  pushl $199
c01031d0:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01031d5:	e9 05 f8 ff ff       	jmp    c01029df <__alltraps>

c01031da <vector200>:
.globl vector200
vector200:
  pushl $0
c01031da:	6a 00                	push   $0x0
  pushl $200
c01031dc:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01031e1:	e9 f9 f7 ff ff       	jmp    c01029df <__alltraps>

c01031e6 <vector201>:
.globl vector201
vector201:
  pushl $0
c01031e6:	6a 00                	push   $0x0
  pushl $201
c01031e8:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01031ed:	e9 ed f7 ff ff       	jmp    c01029df <__alltraps>

c01031f2 <vector202>:
.globl vector202
vector202:
  pushl $0
c01031f2:	6a 00                	push   $0x0
  pushl $202
c01031f4:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01031f9:	e9 e1 f7 ff ff       	jmp    c01029df <__alltraps>

c01031fe <vector203>:
.globl vector203
vector203:
  pushl $0
c01031fe:	6a 00                	push   $0x0
  pushl $203
c0103200:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103205:	e9 d5 f7 ff ff       	jmp    c01029df <__alltraps>

c010320a <vector204>:
.globl vector204
vector204:
  pushl $0
c010320a:	6a 00                	push   $0x0
  pushl $204
c010320c:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103211:	e9 c9 f7 ff ff       	jmp    c01029df <__alltraps>

c0103216 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103216:	6a 00                	push   $0x0
  pushl $205
c0103218:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010321d:	e9 bd f7 ff ff       	jmp    c01029df <__alltraps>

c0103222 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103222:	6a 00                	push   $0x0
  pushl $206
c0103224:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103229:	e9 b1 f7 ff ff       	jmp    c01029df <__alltraps>

c010322e <vector207>:
.globl vector207
vector207:
  pushl $0
c010322e:	6a 00                	push   $0x0
  pushl $207
c0103230:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103235:	e9 a5 f7 ff ff       	jmp    c01029df <__alltraps>

c010323a <vector208>:
.globl vector208
vector208:
  pushl $0
c010323a:	6a 00                	push   $0x0
  pushl $208
c010323c:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103241:	e9 99 f7 ff ff       	jmp    c01029df <__alltraps>

c0103246 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103246:	6a 00                	push   $0x0
  pushl $209
c0103248:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010324d:	e9 8d f7 ff ff       	jmp    c01029df <__alltraps>

c0103252 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103252:	6a 00                	push   $0x0
  pushl $210
c0103254:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103259:	e9 81 f7 ff ff       	jmp    c01029df <__alltraps>

c010325e <vector211>:
.globl vector211
vector211:
  pushl $0
c010325e:	6a 00                	push   $0x0
  pushl $211
c0103260:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103265:	e9 75 f7 ff ff       	jmp    c01029df <__alltraps>

c010326a <vector212>:
.globl vector212
vector212:
  pushl $0
c010326a:	6a 00                	push   $0x0
  pushl $212
c010326c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103271:	e9 69 f7 ff ff       	jmp    c01029df <__alltraps>

c0103276 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103276:	6a 00                	push   $0x0
  pushl $213
c0103278:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010327d:	e9 5d f7 ff ff       	jmp    c01029df <__alltraps>

c0103282 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103282:	6a 00                	push   $0x0
  pushl $214
c0103284:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103289:	e9 51 f7 ff ff       	jmp    c01029df <__alltraps>

c010328e <vector215>:
.globl vector215
vector215:
  pushl $0
c010328e:	6a 00                	push   $0x0
  pushl $215
c0103290:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103295:	e9 45 f7 ff ff       	jmp    c01029df <__alltraps>

c010329a <vector216>:
.globl vector216
vector216:
  pushl $0
c010329a:	6a 00                	push   $0x0
  pushl $216
c010329c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01032a1:	e9 39 f7 ff ff       	jmp    c01029df <__alltraps>

c01032a6 <vector217>:
.globl vector217
vector217:
  pushl $0
c01032a6:	6a 00                	push   $0x0
  pushl $217
c01032a8:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01032ad:	e9 2d f7 ff ff       	jmp    c01029df <__alltraps>

c01032b2 <vector218>:
.globl vector218
vector218:
  pushl $0
c01032b2:	6a 00                	push   $0x0
  pushl $218
c01032b4:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01032b9:	e9 21 f7 ff ff       	jmp    c01029df <__alltraps>

c01032be <vector219>:
.globl vector219
vector219:
  pushl $0
c01032be:	6a 00                	push   $0x0
  pushl $219
c01032c0:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01032c5:	e9 15 f7 ff ff       	jmp    c01029df <__alltraps>

c01032ca <vector220>:
.globl vector220
vector220:
  pushl $0
c01032ca:	6a 00                	push   $0x0
  pushl $220
c01032cc:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01032d1:	e9 09 f7 ff ff       	jmp    c01029df <__alltraps>

c01032d6 <vector221>:
.globl vector221
vector221:
  pushl $0
c01032d6:	6a 00                	push   $0x0
  pushl $221
c01032d8:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01032dd:	e9 fd f6 ff ff       	jmp    c01029df <__alltraps>

c01032e2 <vector222>:
.globl vector222
vector222:
  pushl $0
c01032e2:	6a 00                	push   $0x0
  pushl $222
c01032e4:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01032e9:	e9 f1 f6 ff ff       	jmp    c01029df <__alltraps>

c01032ee <vector223>:
.globl vector223
vector223:
  pushl $0
c01032ee:	6a 00                	push   $0x0
  pushl $223
c01032f0:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01032f5:	e9 e5 f6 ff ff       	jmp    c01029df <__alltraps>

c01032fa <vector224>:
.globl vector224
vector224:
  pushl $0
c01032fa:	6a 00                	push   $0x0
  pushl $224
c01032fc:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103301:	e9 d9 f6 ff ff       	jmp    c01029df <__alltraps>

c0103306 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103306:	6a 00                	push   $0x0
  pushl $225
c0103308:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010330d:	e9 cd f6 ff ff       	jmp    c01029df <__alltraps>

c0103312 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103312:	6a 00                	push   $0x0
  pushl $226
c0103314:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103319:	e9 c1 f6 ff ff       	jmp    c01029df <__alltraps>

c010331e <vector227>:
.globl vector227
vector227:
  pushl $0
c010331e:	6a 00                	push   $0x0
  pushl $227
c0103320:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103325:	e9 b5 f6 ff ff       	jmp    c01029df <__alltraps>

c010332a <vector228>:
.globl vector228
vector228:
  pushl $0
c010332a:	6a 00                	push   $0x0
  pushl $228
c010332c:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103331:	e9 a9 f6 ff ff       	jmp    c01029df <__alltraps>

c0103336 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103336:	6a 00                	push   $0x0
  pushl $229
c0103338:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010333d:	e9 9d f6 ff ff       	jmp    c01029df <__alltraps>

c0103342 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103342:	6a 00                	push   $0x0
  pushl $230
c0103344:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103349:	e9 91 f6 ff ff       	jmp    c01029df <__alltraps>

c010334e <vector231>:
.globl vector231
vector231:
  pushl $0
c010334e:	6a 00                	push   $0x0
  pushl $231
c0103350:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103355:	e9 85 f6 ff ff       	jmp    c01029df <__alltraps>

c010335a <vector232>:
.globl vector232
vector232:
  pushl $0
c010335a:	6a 00                	push   $0x0
  pushl $232
c010335c:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103361:	e9 79 f6 ff ff       	jmp    c01029df <__alltraps>

c0103366 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103366:	6a 00                	push   $0x0
  pushl $233
c0103368:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010336d:	e9 6d f6 ff ff       	jmp    c01029df <__alltraps>

c0103372 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103372:	6a 00                	push   $0x0
  pushl $234
c0103374:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103379:	e9 61 f6 ff ff       	jmp    c01029df <__alltraps>

c010337e <vector235>:
.globl vector235
vector235:
  pushl $0
c010337e:	6a 00                	push   $0x0
  pushl $235
c0103380:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103385:	e9 55 f6 ff ff       	jmp    c01029df <__alltraps>

c010338a <vector236>:
.globl vector236
vector236:
  pushl $0
c010338a:	6a 00                	push   $0x0
  pushl $236
c010338c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103391:	e9 49 f6 ff ff       	jmp    c01029df <__alltraps>

c0103396 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103396:	6a 00                	push   $0x0
  pushl $237
c0103398:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010339d:	e9 3d f6 ff ff       	jmp    c01029df <__alltraps>

c01033a2 <vector238>:
.globl vector238
vector238:
  pushl $0
c01033a2:	6a 00                	push   $0x0
  pushl $238
c01033a4:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01033a9:	e9 31 f6 ff ff       	jmp    c01029df <__alltraps>

c01033ae <vector239>:
.globl vector239
vector239:
  pushl $0
c01033ae:	6a 00                	push   $0x0
  pushl $239
c01033b0:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01033b5:	e9 25 f6 ff ff       	jmp    c01029df <__alltraps>

c01033ba <vector240>:
.globl vector240
vector240:
  pushl $0
c01033ba:	6a 00                	push   $0x0
  pushl $240
c01033bc:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01033c1:	e9 19 f6 ff ff       	jmp    c01029df <__alltraps>

c01033c6 <vector241>:
.globl vector241
vector241:
  pushl $0
c01033c6:	6a 00                	push   $0x0
  pushl $241
c01033c8:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01033cd:	e9 0d f6 ff ff       	jmp    c01029df <__alltraps>

c01033d2 <vector242>:
.globl vector242
vector242:
  pushl $0
c01033d2:	6a 00                	push   $0x0
  pushl $242
c01033d4:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01033d9:	e9 01 f6 ff ff       	jmp    c01029df <__alltraps>

c01033de <vector243>:
.globl vector243
vector243:
  pushl $0
c01033de:	6a 00                	push   $0x0
  pushl $243
c01033e0:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01033e5:	e9 f5 f5 ff ff       	jmp    c01029df <__alltraps>

c01033ea <vector244>:
.globl vector244
vector244:
  pushl $0
c01033ea:	6a 00                	push   $0x0
  pushl $244
c01033ec:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01033f1:	e9 e9 f5 ff ff       	jmp    c01029df <__alltraps>

c01033f6 <vector245>:
.globl vector245
vector245:
  pushl $0
c01033f6:	6a 00                	push   $0x0
  pushl $245
c01033f8:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01033fd:	e9 dd f5 ff ff       	jmp    c01029df <__alltraps>

c0103402 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103402:	6a 00                	push   $0x0
  pushl $246
c0103404:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103409:	e9 d1 f5 ff ff       	jmp    c01029df <__alltraps>

c010340e <vector247>:
.globl vector247
vector247:
  pushl $0
c010340e:	6a 00                	push   $0x0
  pushl $247
c0103410:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103415:	e9 c5 f5 ff ff       	jmp    c01029df <__alltraps>

c010341a <vector248>:
.globl vector248
vector248:
  pushl $0
c010341a:	6a 00                	push   $0x0
  pushl $248
c010341c:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103421:	e9 b9 f5 ff ff       	jmp    c01029df <__alltraps>

c0103426 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103426:	6a 00                	push   $0x0
  pushl $249
c0103428:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010342d:	e9 ad f5 ff ff       	jmp    c01029df <__alltraps>

c0103432 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103432:	6a 00                	push   $0x0
  pushl $250
c0103434:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103439:	e9 a1 f5 ff ff       	jmp    c01029df <__alltraps>

c010343e <vector251>:
.globl vector251
vector251:
  pushl $0
c010343e:	6a 00                	push   $0x0
  pushl $251
c0103440:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103445:	e9 95 f5 ff ff       	jmp    c01029df <__alltraps>

c010344a <vector252>:
.globl vector252
vector252:
  pushl $0
c010344a:	6a 00                	push   $0x0
  pushl $252
c010344c:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103451:	e9 89 f5 ff ff       	jmp    c01029df <__alltraps>

c0103456 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103456:	6a 00                	push   $0x0
  pushl $253
c0103458:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010345d:	e9 7d f5 ff ff       	jmp    c01029df <__alltraps>

c0103462 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103462:	6a 00                	push   $0x0
  pushl $254
c0103464:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103469:	e9 71 f5 ff ff       	jmp    c01029df <__alltraps>

c010346e <vector255>:
.globl vector255
vector255:
  pushl $0
c010346e:	6a 00                	push   $0x0
  pushl $255
c0103470:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103475:	e9 65 f5 ff ff       	jmp    c01029df <__alltraps>

c010347a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010347a:	55                   	push   %ebp
c010347b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010347d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103480:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0103485:	29 c2                	sub    %eax,%edx
c0103487:	89 d0                	mov    %edx,%eax
c0103489:	c1 f8 05             	sar    $0x5,%eax
}
c010348c:	5d                   	pop    %ebp
c010348d:	c3                   	ret    

c010348e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010348e:	55                   	push   %ebp
c010348f:	89 e5                	mov    %esp,%ebp
c0103491:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103494:	8b 45 08             	mov    0x8(%ebp),%eax
c0103497:	89 04 24             	mov    %eax,(%esp)
c010349a:	e8 db ff ff ff       	call   c010347a <page2ppn>
c010349f:	c1 e0 0c             	shl    $0xc,%eax
}
c01034a2:	c9                   	leave  
c01034a3:	c3                   	ret    

c01034a4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01034a4:	55                   	push   %ebp
c01034a5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01034a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01034aa:	8b 00                	mov    (%eax),%eax
}
c01034ac:	5d                   	pop    %ebp
c01034ad:	c3                   	ret    

c01034ae <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01034ae:	55                   	push   %ebp
c01034af:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01034b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034b7:	89 10                	mov    %edx,(%eax)
}
c01034b9:	5d                   	pop    %ebp
c01034ba:	c3                   	ret    

c01034bb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01034bb:	55                   	push   %ebp
c01034bc:	89 e5                	mov    %esp,%ebp
c01034be:	83 ec 10             	sub    $0x10,%esp
c01034c1:	c7 45 fc 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034ce:	89 50 04             	mov    %edx,0x4(%eax)
c01034d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034d4:	8b 50 04             	mov    0x4(%eax),%edx
c01034d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034da:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01034dc:	c7 05 84 0e 1b c0 00 	movl   $0x0,0xc01b0e84
c01034e3:	00 00 00 
}
c01034e6:	c9                   	leave  
c01034e7:	c3                   	ret    

c01034e8 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01034e8:	55                   	push   %ebp
c01034e9:	89 e5                	mov    %esp,%ebp
c01034eb:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01034ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01034f2:	75 24                	jne    c0103518 <default_alloc_pages+0x30>
c01034f4:	c7 44 24 0c f0 c7 10 	movl   $0xc010c7f0,0xc(%esp)
c01034fb:	c0 
c01034fc:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103503:	c0 
c0103504:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010350b:	00 
c010350c:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103513:	e8 c2 d8 ff ff       	call   c0100dda <__panic>
    if (n > nr_free) {
c0103518:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c010351d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103520:	73 0a                	jae    c010352c <default_alloc_pages+0x44>
        return NULL;
c0103522:	b8 00 00 00 00       	mov    $0x0,%eax
c0103527:	e9 0d 01 00 00       	jmp    c0103639 <default_alloc_pages+0x151>
    }
    struct Page *page = NULL;
c010352c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *le = &free_list;
c0103533:	c7 45 f4 7c 0e 1b c0 	movl   $0xc01b0e7c,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
c010353a:	e9 d9 00 00 00       	jmp    c0103618 <default_alloc_pages+0x130>
        page = le2page(le, page_link);
c010353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103542:	83 e8 0c             	sub    $0xc,%eax
c0103545:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (page->property >= n) {
c0103548:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010354b:	8b 40 08             	mov    0x8(%eax),%eax
c010354e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103551:	0f 82 c1 00 00 00    	jb     c0103618 <default_alloc_pages+0x130>
            int i;
            for (i=0; i<n; i++) {
c0103557:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010355e:	eb 7c                	jmp    c01035dc <default_alloc_pages+0xf4>
                 struct Page* tempp = le2page(le, page_link);
c0103560:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103563:	83 e8 0c             	sub    $0xc,%eax
c0103566:	89 45 e8             	mov    %eax,-0x18(%ebp)
                 SetPageReserved(tempp);
c0103569:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010356c:	83 c0 04             	add    $0x4,%eax
c010356f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103576:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103579:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010357c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010357f:	0f ab 10             	bts    %edx,(%eax)
                 ClearPageProperty(tempp);
c0103582:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103585:	83 c0 04             	add    $0x4,%eax
c0103588:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010358f:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103592:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103595:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103598:	0f b3 10             	btr    %edx,(%eax)
c010359b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010359e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01035a1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035a4:	8b 40 04             	mov    0x4(%eax),%eax
                 temp = list_next(le);
c01035a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01035b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035b3:	8b 40 04             	mov    0x4(%eax),%eax
c01035b6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01035b9:	8b 12                	mov    (%edx),%edx
c01035bb:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01035be:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035c1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035c4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01035c7:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035ca:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01035cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035d0:	89 10                	mov    %edx,(%eax)
                 list_del(le);
                 le = temp;
c01035d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
        page = le2page(le, page_link);
        if (page->property >= n) {
            int i;
            for (i=0; i<n; i++) {
c01035d8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01035dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035df:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035e2:	0f 82 78 ff ff ff    	jb     c0103560 <default_alloc_pages+0x78>
                 ClearPageProperty(tempp);
                 temp = list_next(le);
                 list_del(le);
                 le = temp;
            }
            size_t rest = page->property - n;
c01035e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035eb:	8b 40 08             	mov    0x8(%eax),%eax
c01035ee:	2b 45 08             	sub    0x8(%ebp),%eax
c01035f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
            if (rest > 0) {
c01035f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035f8:	74 0c                	je     c0103606 <default_alloc_pages+0x11e>
                (le2page(le, page_link))->property = rest;
c01035fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fd:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103600:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103603:	89 42 08             	mov    %eax,0x8(%edx)
            }
            nr_free -= n;
c0103606:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c010360b:	2b 45 08             	sub    0x8(%ebp),%eax
c010360e:	a3 84 0e 1b c0       	mov    %eax,0xc01b0e84
            return page;
c0103613:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103616:	eb 21                	jmp    c0103639 <default_alloc_pages+0x151>
c0103618:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010361b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010361e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103621:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    list_entry_t *temp;
    while ((le = list_next(le)) != &free_list) {
c0103624:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103627:	81 7d f4 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0xc(%ebp)
c010362e:	0f 85 0b ff ff ff    	jne    c010353f <default_alloc_pages+0x57>
            }
            nr_free -= n;
            return page;
        }
    }
    return NULL;
c0103634:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103639:	c9                   	leave  
c010363a:	c3                   	ret    

c010363b <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010363b:	55                   	push   %ebp
c010363c:	89 e5                	mov    %esp,%ebp
c010363e:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103641:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103645:	75 24                	jne    c010366b <default_free_pages+0x30>
c0103647:	c7 44 24 0c f0 c7 10 	movl   $0xc010c7f0,0xc(%esp)
c010364e:	c0 
c010364f:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103656:	c0 
c0103657:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010365e:	00 
c010365f:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103666:	e8 6f d7 ff ff       	call   c0100dda <__panic>
    struct Page *p = base;
c010366b:	8b 45 08             	mov    0x8(%ebp),%eax
c010366e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103671:	c7 45 f0 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x10(%ebp)
    while ((le=list_next(le)) != &free_list) {
c0103678:	eb 0d                	jmp    c0103687 <default_free_pages+0x4c>
        if ((le2page(le, page_link)) > base)
c010367a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010367d:	83 e8 0c             	sub    $0xc,%eax
c0103680:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103683:	76 02                	jbe    c0103687 <default_free_pages+0x4c>
            break;
c0103685:	eb 18                	jmp    c010369f <default_free_pages+0x64>
c0103687:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010368a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010368d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103690:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
c0103693:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103696:	81 7d f0 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x10(%ebp)
c010369d:	75 db                	jne    c010367a <default_free_pages+0x3f>
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (; p != base + n; p++) {
c010369f:	e9 8d 00 00 00       	jmp    c0103731 <default_free_pages+0xf6>
        p->flags = p->property = 0;
c01036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01036ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b1:	8b 50 08             	mov    0x8(%eax),%edx
c01036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b7:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);
c01036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036bd:	83 c0 04             	add    $0x4,%eax
c01036c0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c01036c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036cd:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01036d0:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c01036d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036da:	00 
c01036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036de:	89 04 24             	mov    %eax,(%esp)
c01036e1:	e8 c8 fd ff ff       	call   c01034ae <set_page_ref>
        list_add_before(le, &(p->page_link));
c01036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e9:	8d 50 0c             	lea    0xc(%eax),%edx
c01036ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01036f2:	89 55 dc             	mov    %edx,-0x24(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01036f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036f8:	8b 00                	mov    (%eax),%eax
c01036fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01036fd:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0103700:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103703:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103706:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103709:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010370c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010370f:	89 10                	mov    %edx,(%eax)
c0103711:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103714:	8b 10                	mov    (%eax),%edx
c0103716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103719:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010371c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010371f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103722:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103725:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103728:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010372b:	89 10                	mov    %edx,(%eax)
    list_entry_t *le = &free_list;
    while ((le=list_next(le)) != &free_list) {
        if ((le2page(le, page_link)) > base)
            break;
    }
    for (; p != base + n; p++) {
c010372d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103731:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103734:	c1 e0 05             	shl    $0x5,%eax
c0103737:	89 c2                	mov    %eax,%edx
c0103739:	8b 45 08             	mov    0x8(%ebp),%eax
c010373c:	01 d0                	add    %edx,%eax
c010373e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103741:	0f 85 5d ff ff ff    	jne    c01036a4 <default_free_pages+0x69>
        p->flags = p->property = 0;
        SetPageProperty(p);
        set_page_ref(p, 0);
        list_add_before(le, &(p->page_link));
    }
    base->property = n;
c0103747:	8b 45 08             	mov    0x8(%ebp),%eax
c010374a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010374d:	89 50 08             	mov    %edx,0x8(%eax)
    p = le2page(le, page_link);
c0103750:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103753:	83 e8 0c             	sub    $0xc,%eax
c0103756:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (base + n == p) {
c0103759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010375c:	c1 e0 05             	shl    $0x5,%eax
c010375f:	89 c2                	mov    %eax,%edx
c0103761:	8b 45 08             	mov    0x8(%ebp),%eax
c0103764:	01 d0                	add    %edx,%eax
c0103766:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103769:	75 1e                	jne    c0103789 <default_free_pages+0x14e>
        base->property += p->property;
c010376b:	8b 45 08             	mov    0x8(%ebp),%eax
c010376e:	8b 50 08             	mov    0x8(%eax),%edx
c0103771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103774:	8b 40 08             	mov    0x8(%eax),%eax
c0103777:	01 c2                	add    %eax,%edx
c0103779:	8b 45 08             	mov    0x8(%ebp),%eax
c010377c:	89 50 08             	mov    %edx,0x8(%eax)
        p->property = 0;
c010377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103782:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&base->page_link);
c0103789:	8b 45 08             	mov    0x8(%ebp),%eax
c010378c:	83 c0 0c             	add    $0xc,%eax
c010378f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103792:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103795:	8b 00                	mov    (%eax),%eax
c0103797:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if ((le != &free_list) && (le2page(le, page_link) + 1 == base)) {
c010379a:	81 7d f0 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x10(%ebp)
c01037a1:	74 57                	je     c01037fa <default_free_pages+0x1bf>
c01037a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037a6:	83 c0 14             	add    $0x14,%eax
c01037a9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037ac:	75 4c                	jne    c01037fa <default_free_pages+0x1bf>
        while (le != &free_list) {
c01037ae:	eb 41                	jmp    c01037f1 <default_free_pages+0x1b6>
            p = le2page(le, page_link);
c01037b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b3:	83 e8 0c             	sub    $0xc,%eax
c01037b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (p->property > 0) {
c01037b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037bc:	8b 40 08             	mov    0x8(%eax),%eax
c01037bf:	85 c0                	test   %eax,%eax
c01037c1:	74 20                	je     c01037e3 <default_free_pages+0x1a8>
                p->property += base->property;
c01037c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c6:	8b 50 08             	mov    0x8(%eax),%edx
c01037c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01037cc:	8b 40 08             	mov    0x8(%eax),%eax
c01037cf:	01 c2                	add    %eax,%edx
c01037d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d4:	89 50 08             	mov    %edx,0x8(%eax)
                base->property = 0;
c01037d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01037da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                break;
c01037e1:	eb 17                	jmp    c01037fa <default_free_pages+0x1bf>
c01037e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037e6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01037e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037ec:	8b 00                	mov    (%eax),%eax
            }
            le = list_prev(le);
c01037ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
        base->property += p->property;
        p->property = 0;
    }
    le = list_prev(&base->page_link);
    if ((le != &free_list) && (le2page(le, page_link) + 1 == base)) {
        while (le != &free_list) {
c01037f1:	81 7d f0 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x10(%ebp)
c01037f8:	75 b6                	jne    c01037b0 <default_free_pages+0x175>
                break;
            }
            le = list_prev(le);
        }
    }
    nr_free += n;
c01037fa:	8b 15 84 0e 1b c0    	mov    0xc01b0e84,%edx
c0103800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103803:	01 d0                	add    %edx,%eax
c0103805:	a3 84 0e 1b c0       	mov    %eax,0xc01b0e84
}
c010380a:	c9                   	leave  
c010380b:	c3                   	ret    

c010380c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010380c:	55                   	push   %ebp
c010380d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010380f:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
}
c0103814:	5d                   	pop    %ebp
c0103815:	c3                   	ret    

c0103816 <basic_check>:

static void
basic_check(void) {
c0103816:	55                   	push   %ebp
c0103817:	89 e5                	mov    %esp,%ebp
c0103819:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010381c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103826:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103829:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010382c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010382f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103836:	e8 dc 15 00 00       	call   c0104e17 <alloc_pages>
c010383b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010383e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103842:	75 24                	jne    c0103868 <basic_check+0x52>
c0103844:	c7 44 24 0c 21 c8 10 	movl   $0xc010c821,0xc(%esp)
c010384b:	c0 
c010384c:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103853:	c0 
c0103854:	c7 44 24 04 91 00 00 	movl   $0x91,0x4(%esp)
c010385b:	00 
c010385c:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103863:	e8 72 d5 ff ff       	call   c0100dda <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010386f:	e8 a3 15 00 00       	call   c0104e17 <alloc_pages>
c0103874:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103877:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010387b:	75 24                	jne    c01038a1 <basic_check+0x8b>
c010387d:	c7 44 24 0c 3d c8 10 	movl   $0xc010c83d,0xc(%esp)
c0103884:	c0 
c0103885:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010388c:	c0 
c010388d:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0103894:	00 
c0103895:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010389c:	e8 39 d5 ff ff       	call   c0100dda <__panic>
    assert((p2 = alloc_page()) != NULL);
c01038a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038a8:	e8 6a 15 00 00       	call   c0104e17 <alloc_pages>
c01038ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038b4:	75 24                	jne    c01038da <basic_check+0xc4>
c01038b6:	c7 44 24 0c 59 c8 10 	movl   $0xc010c859,0xc(%esp)
c01038bd:	c0 
c01038be:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c01038c5:	c0 
c01038c6:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c01038cd:	00 
c01038ce:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01038d5:	e8 00 d5 ff ff       	call   c0100dda <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01038da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01038e0:	74 10                	je     c01038f2 <basic_check+0xdc>
c01038e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038e8:	74 08                	je     c01038f2 <basic_check+0xdc>
c01038ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01038f0:	75 24                	jne    c0103916 <basic_check+0x100>
c01038f2:	c7 44 24 0c 78 c8 10 	movl   $0xc010c878,0xc(%esp)
c01038f9:	c0 
c01038fa:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103901:	c0 
c0103902:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c0103909:	00 
c010390a:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103911:	e8 c4 d4 ff ff       	call   c0100dda <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103916:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103919:	89 04 24             	mov    %eax,(%esp)
c010391c:	e8 83 fb ff ff       	call   c01034a4 <page_ref>
c0103921:	85 c0                	test   %eax,%eax
c0103923:	75 1e                	jne    c0103943 <basic_check+0x12d>
c0103925:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103928:	89 04 24             	mov    %eax,(%esp)
c010392b:	e8 74 fb ff ff       	call   c01034a4 <page_ref>
c0103930:	85 c0                	test   %eax,%eax
c0103932:	75 0f                	jne    c0103943 <basic_check+0x12d>
c0103934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103937:	89 04 24             	mov    %eax,(%esp)
c010393a:	e8 65 fb ff ff       	call   c01034a4 <page_ref>
c010393f:	85 c0                	test   %eax,%eax
c0103941:	74 24                	je     c0103967 <basic_check+0x151>
c0103943:	c7 44 24 0c 9c c8 10 	movl   $0xc010c89c,0xc(%esp)
c010394a:	c0 
c010394b:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103952:	c0 
c0103953:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c010395a:	00 
c010395b:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103962:	e8 73 d4 ff ff       	call   c0100dda <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010396a:	89 04 24             	mov    %eax,(%esp)
c010396d:	e8 1c fb ff ff       	call   c010348e <page2pa>
c0103972:	8b 15 80 ed 1a c0    	mov    0xc01aed80,%edx
c0103978:	c1 e2 0c             	shl    $0xc,%edx
c010397b:	39 d0                	cmp    %edx,%eax
c010397d:	72 24                	jb     c01039a3 <basic_check+0x18d>
c010397f:	c7 44 24 0c d8 c8 10 	movl   $0xc010c8d8,0xc(%esp)
c0103986:	c0 
c0103987:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010398e:	c0 
c010398f:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0103996:	00 
c0103997:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010399e:	e8 37 d4 ff ff       	call   c0100dda <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01039a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039a6:	89 04 24             	mov    %eax,(%esp)
c01039a9:	e8 e0 fa ff ff       	call   c010348e <page2pa>
c01039ae:	8b 15 80 ed 1a c0    	mov    0xc01aed80,%edx
c01039b4:	c1 e2 0c             	shl    $0xc,%edx
c01039b7:	39 d0                	cmp    %edx,%eax
c01039b9:	72 24                	jb     c01039df <basic_check+0x1c9>
c01039bb:	c7 44 24 0c f5 c8 10 	movl   $0xc010c8f5,0xc(%esp)
c01039c2:	c0 
c01039c3:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c01039d2:	00 
c01039d3:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01039da:	e8 fb d3 ff ff       	call   c0100dda <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01039df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039e2:	89 04 24             	mov    %eax,(%esp)
c01039e5:	e8 a4 fa ff ff       	call   c010348e <page2pa>
c01039ea:	8b 15 80 ed 1a c0    	mov    0xc01aed80,%edx
c01039f0:	c1 e2 0c             	shl    $0xc,%edx
c01039f3:	39 d0                	cmp    %edx,%eax
c01039f5:	72 24                	jb     c0103a1b <basic_check+0x205>
c01039f7:	c7 44 24 0c 12 c9 10 	movl   $0xc010c912,0xc(%esp)
c01039fe:	c0 
c01039ff:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103a06:	c0 
c0103a07:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0103a0e:	00 
c0103a0f:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103a16:	e8 bf d3 ff ff       	call   c0100dda <__panic>

    list_entry_t free_list_store = free_list;
c0103a1b:	a1 7c 0e 1b c0       	mov    0xc01b0e7c,%eax
c0103a20:	8b 15 80 0e 1b c0    	mov    0xc01b0e80,%edx
c0103a26:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a29:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a2c:	c7 45 e0 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103a39:	89 50 04             	mov    %edx,0x4(%eax)
c0103a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a3f:	8b 50 04             	mov    0x4(%eax),%edx
c0103a42:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a45:	89 10                	mov    %edx,(%eax)
c0103a47:	c7 45 dc 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103a4e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a51:	8b 40 04             	mov    0x4(%eax),%eax
c0103a54:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103a57:	0f 94 c0             	sete   %al
c0103a5a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103a5d:	85 c0                	test   %eax,%eax
c0103a5f:	75 24                	jne    c0103a85 <basic_check+0x26f>
c0103a61:	c7 44 24 0c 2f c9 10 	movl   $0xc010c92f,0xc(%esp)
c0103a68:	c0 
c0103a69:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103a70:	c0 
c0103a71:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0103a78:	00 
c0103a79:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103a80:	e8 55 d3 ff ff       	call   c0100dda <__panic>

    unsigned int nr_free_store = nr_free;
c0103a85:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0103a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103a8d:	c7 05 84 0e 1b c0 00 	movl   $0x0,0xc01b0e84
c0103a94:	00 00 00 

    assert(alloc_page() == NULL);
c0103a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a9e:	e8 74 13 00 00       	call   c0104e17 <alloc_pages>
c0103aa3:	85 c0                	test   %eax,%eax
c0103aa5:	74 24                	je     c0103acb <basic_check+0x2b5>
c0103aa7:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103ab6:	c0 
c0103ab7:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
c0103abe:	00 
c0103abf:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103ac6:	e8 0f d3 ff ff       	call   c0100dda <__panic>

    free_page(p0);
c0103acb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ad2:	00 
c0103ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ad6:	89 04 24             	mov    %eax,(%esp)
c0103ad9:	e8 a4 13 00 00       	call   c0104e82 <free_pages>
    free_page(p1);
c0103ade:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ae5:	00 
c0103ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ae9:	89 04 24             	mov    %eax,(%esp)
c0103aec:	e8 91 13 00 00       	call   c0104e82 <free_pages>
    free_page(p2);
c0103af1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103af8:	00 
c0103af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afc:	89 04 24             	mov    %eax,(%esp)
c0103aff:	e8 7e 13 00 00       	call   c0104e82 <free_pages>
    assert(nr_free == 3);
c0103b04:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0103b09:	83 f8 03             	cmp    $0x3,%eax
c0103b0c:	74 24                	je     c0103b32 <basic_check+0x31c>
c0103b0e:	c7 44 24 0c 5b c9 10 	movl   $0xc010c95b,0xc(%esp)
c0103b15:	c0 
c0103b16:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103b1d:	c0 
c0103b1e:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103b25:	00 
c0103b26:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103b2d:	e8 a8 d2 ff ff       	call   c0100dda <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b39:	e8 d9 12 00 00       	call   c0104e17 <alloc_pages>
c0103b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b45:	75 24                	jne    c0103b6b <basic_check+0x355>
c0103b47:	c7 44 24 0c 21 c8 10 	movl   $0xc010c821,0xc(%esp)
c0103b4e:	c0 
c0103b4f:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103b56:	c0 
c0103b57:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
c0103b5e:	00 
c0103b5f:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103b66:	e8 6f d2 ff ff       	call   c0100dda <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b72:	e8 a0 12 00 00       	call   c0104e17 <alloc_pages>
c0103b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b7e:	75 24                	jne    c0103ba4 <basic_check+0x38e>
c0103b80:	c7 44 24 0c 3d c8 10 	movl   $0xc010c83d,0xc(%esp)
c0103b87:	c0 
c0103b88:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103b8f:	c0 
c0103b90:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0103b97:	00 
c0103b98:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103b9f:	e8 36 d2 ff ff       	call   c0100dda <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bab:	e8 67 12 00 00       	call   c0104e17 <alloc_pages>
c0103bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bb7:	75 24                	jne    c0103bdd <basic_check+0x3c7>
c0103bb9:	c7 44 24 0c 59 c8 10 	movl   $0xc010c859,0xc(%esp)
c0103bc0:	c0 
c0103bc1:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103bc8:	c0 
c0103bc9:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103bd0:	00 
c0103bd1:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103bd8:	e8 fd d1 ff ff       	call   c0100dda <__panic>

    assert(alloc_page() == NULL);
c0103bdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103be4:	e8 2e 12 00 00       	call   c0104e17 <alloc_pages>
c0103be9:	85 c0                	test   %eax,%eax
c0103beb:	74 24                	je     c0103c11 <basic_check+0x3fb>
c0103bed:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0103bf4:	c0 
c0103bf5:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103bfc:	c0 
c0103bfd:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103c04:	00 
c0103c05:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103c0c:	e8 c9 d1 ff ff       	call   c0100dda <__panic>

    free_page(p0);
c0103c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c18:	00 
c0103c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c1c:	89 04 24             	mov    %eax,(%esp)
c0103c1f:	e8 5e 12 00 00       	call   c0104e82 <free_pages>
c0103c24:	c7 45 d8 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x28(%ebp)
c0103c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c2e:	8b 40 04             	mov    0x4(%eax),%eax
c0103c31:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c34:	0f 94 c0             	sete   %al
c0103c37:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103c3a:	85 c0                	test   %eax,%eax
c0103c3c:	74 24                	je     c0103c62 <basic_check+0x44c>
c0103c3e:	c7 44 24 0c 68 c9 10 	movl   $0xc010c968,0xc(%esp)
c0103c45:	c0 
c0103c46:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103c4d:	c0 
c0103c4e:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103c55:	00 
c0103c56:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103c5d:	e8 78 d1 ff ff       	call   c0100dda <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103c62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c69:	e8 a9 11 00 00       	call   c0104e17 <alloc_pages>
c0103c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103c77:	74 24                	je     c0103c9d <basic_check+0x487>
c0103c79:	c7 44 24 0c 80 c9 10 	movl   $0xc010c980,0xc(%esp)
c0103c80:	c0 
c0103c81:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103c88:	c0 
c0103c89:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103c90:	00 
c0103c91:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103c98:	e8 3d d1 ff ff       	call   c0100dda <__panic>
    assert(alloc_page() == NULL);
c0103c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ca4:	e8 6e 11 00 00       	call   c0104e17 <alloc_pages>
c0103ca9:	85 c0                	test   %eax,%eax
c0103cab:	74 24                	je     c0103cd1 <basic_check+0x4bb>
c0103cad:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0103cb4:	c0 
c0103cb5:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103cbc:	c0 
c0103cbd:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103cc4:	00 
c0103cc5:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103ccc:	e8 09 d1 ff ff       	call   c0100dda <__panic>

    assert(nr_free == 0);
c0103cd1:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0103cd6:	85 c0                	test   %eax,%eax
c0103cd8:	74 24                	je     c0103cfe <basic_check+0x4e8>
c0103cda:	c7 44 24 0c 99 c9 10 	movl   $0xc010c999,0xc(%esp)
c0103ce1:	c0 
c0103ce2:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103ce9:	c0 
c0103cea:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103cf1:	00 
c0103cf2:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103cf9:	e8 dc d0 ff ff       	call   c0100dda <__panic>
    free_list = free_list_store;
c0103cfe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d04:	a3 7c 0e 1b c0       	mov    %eax,0xc01b0e7c
c0103d09:	89 15 80 0e 1b c0    	mov    %edx,0xc01b0e80
    nr_free = nr_free_store;
c0103d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d12:	a3 84 0e 1b c0       	mov    %eax,0xc01b0e84

    free_page(p);
c0103d17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d1e:	00 
c0103d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d22:	89 04 24             	mov    %eax,(%esp)
c0103d25:	e8 58 11 00 00       	call   c0104e82 <free_pages>
    free_page(p1);
c0103d2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d31:	00 
c0103d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d35:	89 04 24             	mov    %eax,(%esp)
c0103d38:	e8 45 11 00 00       	call   c0104e82 <free_pages>
    free_page(p2);
c0103d3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d44:	00 
c0103d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d48:	89 04 24             	mov    %eax,(%esp)
c0103d4b:	e8 32 11 00 00       	call   c0104e82 <free_pages>
}
c0103d50:	c9                   	leave  
c0103d51:	c3                   	ret    

c0103d52 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103d52:	55                   	push   %ebp
c0103d53:	89 e5                	mov    %esp,%ebp
c0103d55:	53                   	push   %ebx
c0103d56:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103d5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103d63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103d6a:	c7 45 ec 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103d71:	eb 6b                	jmp    c0103dde <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d76:	83 e8 0c             	sub    $0xc,%eax
c0103d79:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103d7c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d7f:	83 c0 04             	add    $0x4,%eax
c0103d82:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103d89:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103d8f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103d92:	0f a3 10             	bt     %edx,(%eax)
c0103d95:	19 c0                	sbb    %eax,%eax
c0103d97:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103d9a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d9e:	0f 95 c0             	setne  %al
c0103da1:	0f b6 c0             	movzbl %al,%eax
c0103da4:	85 c0                	test   %eax,%eax
c0103da6:	75 24                	jne    c0103dcc <default_check+0x7a>
c0103da8:	c7 44 24 0c a6 c9 10 	movl   $0xc010c9a6,0xc(%esp)
c0103daf:	c0 
c0103db0:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103db7:	c0 
c0103db8:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103dbf:	00 
c0103dc0:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103dc7:	e8 0e d0 ff ff       	call   c0100dda <__panic>
        count ++, total += p->property;
c0103dcc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103dd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dd3:	8b 50 08             	mov    0x8(%eax),%edx
c0103dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd9:	01 d0                	add    %edx,%eax
c0103ddb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103de4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103de7:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103dea:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ded:	81 7d ec 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x14(%ebp)
c0103df4:	0f 85 79 ff ff ff    	jne    c0103d73 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103dfa:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103dfd:	e8 b2 10 00 00       	call   c0104eb4 <nr_free_pages>
c0103e02:	39 c3                	cmp    %eax,%ebx
c0103e04:	74 24                	je     c0103e2a <default_check+0xd8>
c0103e06:	c7 44 24 0c b6 c9 10 	movl   $0xc010c9b6,0xc(%esp)
c0103e0d:	c0 
c0103e0e:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103e15:	c0 
c0103e16:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103e1d:	00 
c0103e1e:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103e25:	e8 b0 cf ff ff       	call   c0100dda <__panic>

    basic_check();
c0103e2a:	e8 e7 f9 ff ff       	call   c0103816 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e2f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e36:	e8 dc 0f 00 00       	call   c0104e17 <alloc_pages>
c0103e3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103e3e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e42:	75 24                	jne    c0103e68 <default_check+0x116>
c0103e44:	c7 44 24 0c cf c9 10 	movl   $0xc010c9cf,0xc(%esp)
c0103e4b:	c0 
c0103e4c:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103e53:	c0 
c0103e54:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103e5b:	00 
c0103e5c:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103e63:	e8 72 cf ff ff       	call   c0100dda <__panic>
    assert(!PageProperty(p0));
c0103e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e6b:	83 c0 04             	add    $0x4,%eax
c0103e6e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103e75:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e78:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e7b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103e7e:	0f a3 10             	bt     %edx,(%eax)
c0103e81:	19 c0                	sbb    %eax,%eax
c0103e83:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103e86:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103e8a:	0f 95 c0             	setne  %al
c0103e8d:	0f b6 c0             	movzbl %al,%eax
c0103e90:	85 c0                	test   %eax,%eax
c0103e92:	74 24                	je     c0103eb8 <default_check+0x166>
c0103e94:	c7 44 24 0c da c9 10 	movl   $0xc010c9da,0xc(%esp)
c0103e9b:	c0 
c0103e9c:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103ea3:	c0 
c0103ea4:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103eab:	00 
c0103eac:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103eb3:	e8 22 cf ff ff       	call   c0100dda <__panic>

    list_entry_t free_list_store = free_list;
c0103eb8:	a1 7c 0e 1b c0       	mov    0xc01b0e7c,%eax
c0103ebd:	8b 15 80 0e 1b c0    	mov    0xc01b0e80,%edx
c0103ec3:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103ec6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103ec9:	c7 45 b4 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103ed0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ed3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ed6:	89 50 04             	mov    %edx,0x4(%eax)
c0103ed9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103edc:	8b 50 04             	mov    0x4(%eax),%edx
c0103edf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103ee2:	89 10                	mov    %edx,(%eax)
c0103ee4:	c7 45 b0 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103eeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103eee:	8b 40 04             	mov    0x4(%eax),%eax
c0103ef1:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103ef4:	0f 94 c0             	sete   %al
c0103ef7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103efa:	85 c0                	test   %eax,%eax
c0103efc:	75 24                	jne    c0103f22 <default_check+0x1d0>
c0103efe:	c7 44 24 0c 2f c9 10 	movl   $0xc010c92f,0xc(%esp)
c0103f05:	c0 
c0103f06:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103f0d:	c0 
c0103f0e:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103f15:	00 
c0103f16:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103f1d:	e8 b8 ce ff ff       	call   c0100dda <__panic>
    assert(alloc_page() == NULL);
c0103f22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f29:	e8 e9 0e 00 00       	call   c0104e17 <alloc_pages>
c0103f2e:	85 c0                	test   %eax,%eax
c0103f30:	74 24                	je     c0103f56 <default_check+0x204>
c0103f32:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0103f39:	c0 
c0103f3a:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103f41:	c0 
c0103f42:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103f49:	00 
c0103f4a:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103f51:	e8 84 ce ff ff       	call   c0100dda <__panic>

    unsigned int nr_free_store = nr_free;
c0103f56:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0103f5b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103f5e:	c7 05 84 0e 1b c0 00 	movl   $0x0,0xc01b0e84
c0103f65:	00 00 00 

    free_pages(p0 + 2, 3);
c0103f68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f6b:	83 c0 40             	add    $0x40,%eax
c0103f6e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103f75:	00 
c0103f76:	89 04 24             	mov    %eax,(%esp)
c0103f79:	e8 04 0f 00 00       	call   c0104e82 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103f7e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103f85:	e8 8d 0e 00 00       	call   c0104e17 <alloc_pages>
c0103f8a:	85 c0                	test   %eax,%eax
c0103f8c:	74 24                	je     c0103fb2 <default_check+0x260>
c0103f8e:	c7 44 24 0c ec c9 10 	movl   $0xc010c9ec,0xc(%esp)
c0103f95:	c0 
c0103f96:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103f9d:	c0 
c0103f9e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103fa5:	00 
c0103fa6:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0103fad:	e8 28 ce ff ff       	call   c0100dda <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fb5:	83 c0 40             	add    $0x40,%eax
c0103fb8:	83 c0 04             	add    $0x4,%eax
c0103fbb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103fc2:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103fc5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fc8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103fcb:	0f a3 10             	bt     %edx,(%eax)
c0103fce:	19 c0                	sbb    %eax,%eax
c0103fd0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103fd3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103fd7:	0f 95 c0             	setne  %al
c0103fda:	0f b6 c0             	movzbl %al,%eax
c0103fdd:	85 c0                	test   %eax,%eax
c0103fdf:	74 0e                	je     c0103fef <default_check+0x29d>
c0103fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe4:	83 c0 40             	add    $0x40,%eax
c0103fe7:	8b 40 08             	mov    0x8(%eax),%eax
c0103fea:	83 f8 03             	cmp    $0x3,%eax
c0103fed:	74 24                	je     c0104013 <default_check+0x2c1>
c0103fef:	c7 44 24 0c 04 ca 10 	movl   $0xc010ca04,0xc(%esp)
c0103ff6:	c0 
c0103ff7:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0103ffe:	c0 
c0103fff:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0104006:	00 
c0104007:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010400e:	e8 c7 cd ff ff       	call   c0100dda <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104013:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010401a:	e8 f8 0d 00 00       	call   c0104e17 <alloc_pages>
c010401f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104022:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104026:	75 24                	jne    c010404c <default_check+0x2fa>
c0104028:	c7 44 24 0c 30 ca 10 	movl   $0xc010ca30,0xc(%esp)
c010402f:	c0 
c0104030:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0104037:	c0 
c0104038:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010403f:	00 
c0104040:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0104047:	e8 8e cd ff ff       	call   c0100dda <__panic>
    assert(alloc_page() == NULL);
c010404c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104053:	e8 bf 0d 00 00       	call   c0104e17 <alloc_pages>
c0104058:	85 c0                	test   %eax,%eax
c010405a:	74 24                	je     c0104080 <default_check+0x32e>
c010405c:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0104063:	c0 
c0104064:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010406b:	c0 
c010406c:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104073:	00 
c0104074:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010407b:	e8 5a cd ff ff       	call   c0100dda <__panic>
    assert(p0 + 2 == p1);
c0104080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104083:	83 c0 40             	add    $0x40,%eax
c0104086:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104089:	74 24                	je     c01040af <default_check+0x35d>
c010408b:	c7 44 24 0c 4e ca 10 	movl   $0xc010ca4e,0xc(%esp)
c0104092:	c0 
c0104093:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010409a:	c0 
c010409b:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01040a2:	00 
c01040a3:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01040aa:	e8 2b cd ff ff       	call   c0100dda <__panic>

    p2 = p0 + 1;
c01040af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040b2:	83 c0 20             	add    $0x20,%eax
c01040b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01040b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040bf:	00 
c01040c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040c3:	89 04 24             	mov    %eax,(%esp)
c01040c6:	e8 b7 0d 00 00       	call   c0104e82 <free_pages>
    free_pages(p1, 3);
c01040cb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01040d2:	00 
c01040d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040d6:	89 04 24             	mov    %eax,(%esp)
c01040d9:	e8 a4 0d 00 00       	call   c0104e82 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e1:	83 c0 04             	add    $0x4,%eax
c01040e4:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01040eb:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040ee:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040f1:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01040f4:	0f a3 10             	bt     %edx,(%eax)
c01040f7:	19 c0                	sbb    %eax,%eax
c01040f9:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01040fc:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104100:	0f 95 c0             	setne  %al
c0104103:	0f b6 c0             	movzbl %al,%eax
c0104106:	85 c0                	test   %eax,%eax
c0104108:	74 0b                	je     c0104115 <default_check+0x3c3>
c010410a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010410d:	8b 40 08             	mov    0x8(%eax),%eax
c0104110:	83 f8 01             	cmp    $0x1,%eax
c0104113:	74 24                	je     c0104139 <default_check+0x3e7>
c0104115:	c7 44 24 0c 5c ca 10 	movl   $0xc010ca5c,0xc(%esp)
c010411c:	c0 
c010411d:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0104124:	c0 
c0104125:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010412c:	00 
c010412d:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0104134:	e8 a1 cc ff ff       	call   c0100dda <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104139:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010413c:	83 c0 04             	add    $0x4,%eax
c010413f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104146:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104149:	8b 45 90             	mov    -0x70(%ebp),%eax
c010414c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010414f:	0f a3 10             	bt     %edx,(%eax)
c0104152:	19 c0                	sbb    %eax,%eax
c0104154:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104157:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010415b:	0f 95 c0             	setne  %al
c010415e:	0f b6 c0             	movzbl %al,%eax
c0104161:	85 c0                	test   %eax,%eax
c0104163:	74 0b                	je     c0104170 <default_check+0x41e>
c0104165:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104168:	8b 40 08             	mov    0x8(%eax),%eax
c010416b:	83 f8 03             	cmp    $0x3,%eax
c010416e:	74 24                	je     c0104194 <default_check+0x442>
c0104170:	c7 44 24 0c 84 ca 10 	movl   $0xc010ca84,0xc(%esp)
c0104177:	c0 
c0104178:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010417f:	c0 
c0104180:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0104187:	00 
c0104188:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010418f:	e8 46 cc ff ff       	call   c0100dda <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104194:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010419b:	e8 77 0c 00 00       	call   c0104e17 <alloc_pages>
c01041a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041a6:	83 e8 20             	sub    $0x20,%eax
c01041a9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041ac:	74 24                	je     c01041d2 <default_check+0x480>
c01041ae:	c7 44 24 0c aa ca 10 	movl   $0xc010caaa,0xc(%esp)
c01041b5:	c0 
c01041b6:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c01041bd:	c0 
c01041be:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c01041c5:	00 
c01041c6:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01041cd:	e8 08 cc ff ff       	call   c0100dda <__panic>
    free_page(p0);
c01041d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01041d9:	00 
c01041da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041dd:	89 04 24             	mov    %eax,(%esp)
c01041e0:	e8 9d 0c 00 00       	call   c0104e82 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01041e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01041ec:	e8 26 0c 00 00       	call   c0104e17 <alloc_pages>
c01041f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041f7:	83 c0 20             	add    $0x20,%eax
c01041fa:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01041fd:	74 24                	je     c0104223 <default_check+0x4d1>
c01041ff:	c7 44 24 0c c8 ca 10 	movl   $0xc010cac8,0xc(%esp)
c0104206:	c0 
c0104207:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010420e:	c0 
c010420f:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0104216:	00 
c0104217:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010421e:	e8 b7 cb ff ff       	call   c0100dda <__panic>

    free_pages(p0, 2);
c0104223:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010422a:	00 
c010422b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010422e:	89 04 24             	mov    %eax,(%esp)
c0104231:	e8 4c 0c 00 00       	call   c0104e82 <free_pages>
    free_page(p2);
c0104236:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010423d:	00 
c010423e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104241:	89 04 24             	mov    %eax,(%esp)
c0104244:	e8 39 0c 00 00       	call   c0104e82 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104249:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104250:	e8 c2 0b 00 00       	call   c0104e17 <alloc_pages>
c0104255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104258:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010425c:	75 24                	jne    c0104282 <default_check+0x530>
c010425e:	c7 44 24 0c e8 ca 10 	movl   $0xc010cae8,0xc(%esp)
c0104265:	c0 
c0104266:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010426d:	c0 
c010426e:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0104275:	00 
c0104276:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010427d:	e8 58 cb ff ff       	call   c0100dda <__panic>
    assert(alloc_page() == NULL);
c0104282:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104289:	e8 89 0b 00 00       	call   c0104e17 <alloc_pages>
c010428e:	85 c0                	test   %eax,%eax
c0104290:	74 24                	je     c01042b6 <default_check+0x564>
c0104292:	c7 44 24 0c 46 c9 10 	movl   $0xc010c946,0xc(%esp)
c0104299:	c0 
c010429a:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c01042a1:	c0 
c01042a2:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01042a9:	00 
c01042aa:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01042b1:	e8 24 cb ff ff       	call   c0100dda <__panic>

    assert(nr_free == 0);
c01042b6:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c01042bb:	85 c0                	test   %eax,%eax
c01042bd:	74 24                	je     c01042e3 <default_check+0x591>
c01042bf:	c7 44 24 0c 99 c9 10 	movl   $0xc010c999,0xc(%esp)
c01042c6:	c0 
c01042c7:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c01042ce:	c0 
c01042cf:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01042d6:	00 
c01042d7:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c01042de:	e8 f7 ca ff ff       	call   c0100dda <__panic>
    nr_free = nr_free_store;
c01042e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042e6:	a3 84 0e 1b c0       	mov    %eax,0xc01b0e84

    free_list = free_list_store;
c01042eb:	8b 45 80             	mov    -0x80(%ebp),%eax
c01042ee:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01042f1:	a3 7c 0e 1b c0       	mov    %eax,0xc01b0e7c
c01042f6:	89 15 80 0e 1b c0    	mov    %edx,0xc01b0e80
    free_pages(p0, 5);
c01042fc:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104303:	00 
c0104304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104307:	89 04 24             	mov    %eax,(%esp)
c010430a:	e8 73 0b 00 00       	call   c0104e82 <free_pages>

    le = &free_list;
c010430f:	c7 45 ec 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104316:	eb 1d                	jmp    c0104335 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104318:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010431b:	83 e8 0c             	sub    $0xc,%eax
c010431e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104321:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104325:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010432b:	8b 40 08             	mov    0x8(%eax),%eax
c010432e:	29 c2                	sub    %eax,%edx
c0104330:	89 d0                	mov    %edx,%eax
c0104332:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104335:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104338:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010433b:	8b 45 88             	mov    -0x78(%ebp),%eax
c010433e:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104341:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104344:	81 7d ec 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x14(%ebp)
c010434b:	75 cb                	jne    c0104318 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010434d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104351:	74 24                	je     c0104377 <default_check+0x625>
c0104353:	c7 44 24 0c 06 cb 10 	movl   $0xc010cb06,0xc(%esp)
c010435a:	c0 
c010435b:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c0104362:	c0 
c0104363:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010436a:	00 
c010436b:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c0104372:	e8 63 ca ff ff       	call   c0100dda <__panic>
    assert(total == 0);
c0104377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010437b:	74 24                	je     c01043a1 <default_check+0x64f>
c010437d:	c7 44 24 0c 11 cb 10 	movl   $0xc010cb11,0xc(%esp)
c0104384:	c0 
c0104385:	c7 44 24 08 f6 c7 10 	movl   $0xc010c7f6,0x8(%esp)
c010438c:	c0 
c010438d:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104394:	00 
c0104395:	c7 04 24 0b c8 10 c0 	movl   $0xc010c80b,(%esp)
c010439c:	e8 39 ca ff ff       	call   c0100dda <__panic>
}
c01043a1:	81 c4 94 00 00 00    	add    $0x94,%esp
c01043a7:	5b                   	pop    %ebx
c01043a8:	5d                   	pop    %ebp
c01043a9:	c3                   	ret    

c01043aa <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01043aa:	55                   	push   %ebp
c01043ab:	89 e5                	mov    %esp,%ebp
c01043ad:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01043b0:	9c                   	pushf  
c01043b1:	58                   	pop    %eax
c01043b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01043b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01043b8:	25 00 02 00 00       	and    $0x200,%eax
c01043bd:	85 c0                	test   %eax,%eax
c01043bf:	74 0c                	je     c01043cd <__intr_save+0x23>
        intr_disable();
c01043c1:	e8 6c dc ff ff       	call   c0102032 <intr_disable>
        return 1;
c01043c6:	b8 01 00 00 00       	mov    $0x1,%eax
c01043cb:	eb 05                	jmp    c01043d2 <__intr_save+0x28>
    }
    return 0;
c01043cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01043d2:	c9                   	leave  
c01043d3:	c3                   	ret    

c01043d4 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01043d4:	55                   	push   %ebp
c01043d5:	89 e5                	mov    %esp,%ebp
c01043d7:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01043da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01043de:	74 05                	je     c01043e5 <__intr_restore+0x11>
        intr_enable();
c01043e0:	e8 47 dc ff ff       	call   c010202c <intr_enable>
    }
}
c01043e5:	c9                   	leave  
c01043e6:	c3                   	ret    

c01043e7 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01043e7:	55                   	push   %ebp
c01043e8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01043ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01043ed:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c01043f2:	29 c2                	sub    %eax,%edx
c01043f4:	89 d0                	mov    %edx,%eax
c01043f6:	c1 f8 05             	sar    $0x5,%eax
}
c01043f9:	5d                   	pop    %ebp
c01043fa:	c3                   	ret    

c01043fb <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01043fb:	55                   	push   %ebp
c01043fc:	89 e5                	mov    %esp,%ebp
c01043fe:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104401:	8b 45 08             	mov    0x8(%ebp),%eax
c0104404:	89 04 24             	mov    %eax,(%esp)
c0104407:	e8 db ff ff ff       	call   c01043e7 <page2ppn>
c010440c:	c1 e0 0c             	shl    $0xc,%eax
}
c010440f:	c9                   	leave  
c0104410:	c3                   	ret    

c0104411 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104411:	55                   	push   %ebp
c0104412:	89 e5                	mov    %esp,%ebp
c0104414:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104417:	8b 45 08             	mov    0x8(%ebp),%eax
c010441a:	c1 e8 0c             	shr    $0xc,%eax
c010441d:	89 c2                	mov    %eax,%edx
c010441f:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0104424:	39 c2                	cmp    %eax,%edx
c0104426:	72 1c                	jb     c0104444 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104428:	c7 44 24 08 4c cb 10 	movl   $0xc010cb4c,0x8(%esp)
c010442f:	c0 
c0104430:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104437:	00 
c0104438:	c7 04 24 6b cb 10 c0 	movl   $0xc010cb6b,(%esp)
c010443f:	e8 96 c9 ff ff       	call   c0100dda <__panic>
    }
    return &pages[PPN(pa)];
c0104444:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0104449:	8b 55 08             	mov    0x8(%ebp),%edx
c010444c:	c1 ea 0c             	shr    $0xc,%edx
c010444f:	c1 e2 05             	shl    $0x5,%edx
c0104452:	01 d0                	add    %edx,%eax
}
c0104454:	c9                   	leave  
c0104455:	c3                   	ret    

c0104456 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104456:	55                   	push   %ebp
c0104457:	89 e5                	mov    %esp,%ebp
c0104459:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010445c:	8b 45 08             	mov    0x8(%ebp),%eax
c010445f:	89 04 24             	mov    %eax,(%esp)
c0104462:	e8 94 ff ff ff       	call   c01043fb <page2pa>
c0104467:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010446a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010446d:	c1 e8 0c             	shr    $0xc,%eax
c0104470:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104473:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0104478:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010447b:	72 23                	jb     c01044a0 <page2kva+0x4a>
c010447d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104480:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104484:	c7 44 24 08 7c cb 10 	movl   $0xc010cb7c,0x8(%esp)
c010448b:	c0 
c010448c:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104493:	00 
c0104494:	c7 04 24 6b cb 10 c0 	movl   $0xc010cb6b,(%esp)
c010449b:	e8 3a c9 ff ff       	call   c0100dda <__panic>
c01044a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044a3:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01044a8:	c9                   	leave  
c01044a9:	c3                   	ret    

c01044aa <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01044aa:	55                   	push   %ebp
c01044ab:	89 e5                	mov    %esp,%ebp
c01044ad:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01044b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044b6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044bd:	77 23                	ja     c01044e2 <kva2page+0x38>
c01044bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044c6:	c7 44 24 08 a0 cb 10 	movl   $0xc010cba0,0x8(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01044d5:	00 
c01044d6:	c7 04 24 6b cb 10 c0 	movl   $0xc010cb6b,(%esp)
c01044dd:	e8 f8 c8 ff ff       	call   c0100dda <__panic>
c01044e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e5:	05 00 00 00 40       	add    $0x40000000,%eax
c01044ea:	89 04 24             	mov    %eax,(%esp)
c01044ed:	e8 1f ff ff ff       	call   c0104411 <pa2page>
}
c01044f2:	c9                   	leave  
c01044f3:	c3                   	ret    

c01044f4 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c01044f4:	55                   	push   %ebp
c01044f5:	89 e5                	mov    %esp,%ebp
c01044f7:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c01044fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044fd:	ba 01 00 00 00       	mov    $0x1,%edx
c0104502:	89 c1                	mov    %eax,%ecx
c0104504:	d3 e2                	shl    %cl,%edx
c0104506:	89 d0                	mov    %edx,%eax
c0104508:	89 04 24             	mov    %eax,(%esp)
c010450b:	e8 07 09 00 00       	call   c0104e17 <alloc_pages>
c0104510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104513:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104517:	75 07                	jne    c0104520 <__slob_get_free_pages+0x2c>
    return NULL;
c0104519:	b8 00 00 00 00       	mov    $0x0,%eax
c010451e:	eb 0b                	jmp    c010452b <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104520:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104523:	89 04 24             	mov    %eax,(%esp)
c0104526:	e8 2b ff ff ff       	call   c0104456 <page2kva>
}
c010452b:	c9                   	leave  
c010452c:	c3                   	ret    

c010452d <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010452d:	55                   	push   %ebp
c010452e:	89 e5                	mov    %esp,%ebp
c0104530:	53                   	push   %ebx
c0104531:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104534:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104537:	ba 01 00 00 00       	mov    $0x1,%edx
c010453c:	89 c1                	mov    %eax,%ecx
c010453e:	d3 e2                	shl    %cl,%edx
c0104540:	89 d0                	mov    %edx,%eax
c0104542:	89 c3                	mov    %eax,%ebx
c0104544:	8b 45 08             	mov    0x8(%ebp),%eax
c0104547:	89 04 24             	mov    %eax,(%esp)
c010454a:	e8 5b ff ff ff       	call   c01044aa <kva2page>
c010454f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104553:	89 04 24             	mov    %eax,(%esp)
c0104556:	e8 27 09 00 00       	call   c0104e82 <free_pages>
}
c010455b:	83 c4 14             	add    $0x14,%esp
c010455e:	5b                   	pop    %ebx
c010455f:	5d                   	pop    %ebp
c0104560:	c3                   	ret    

c0104561 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104561:	55                   	push   %ebp
c0104562:	89 e5                	mov    %esp,%ebp
c0104564:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104567:	8b 45 08             	mov    0x8(%ebp),%eax
c010456a:	83 c0 08             	add    $0x8,%eax
c010456d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104572:	76 24                	jbe    c0104598 <slob_alloc+0x37>
c0104574:	c7 44 24 0c c4 cb 10 	movl   $0xc010cbc4,0xc(%esp)
c010457b:	c0 
c010457c:	c7 44 24 08 e3 cb 10 	movl   $0xc010cbe3,0x8(%esp)
c0104583:	c0 
c0104584:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010458b:	00 
c010458c:	c7 04 24 f8 cb 10 c0 	movl   $0xc010cbf8,(%esp)
c0104593:	e8 42 c8 ff ff       	call   c0100dda <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104598:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c010459f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01045a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a9:	83 c0 07             	add    $0x7,%eax
c01045ac:	c1 e8 03             	shr    $0x3,%eax
c01045af:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01045b2:	e8 f3 fd ff ff       	call   c01043aa <__intr_save>
c01045b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01045ba:	a1 08 ca 12 c0       	mov    0xc012ca08,%eax
c01045bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c5:	8b 40 04             	mov    0x4(%eax),%eax
c01045c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01045cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045cf:	74 25                	je     c01045f6 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01045d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01045d7:	01 d0                	add    %edx,%eax
c01045d9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01045dc:	8b 45 10             	mov    0x10(%ebp),%eax
c01045df:	f7 d8                	neg    %eax
c01045e1:	21 d0                	and    %edx,%eax
c01045e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c01045e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045ec:	29 c2                	sub    %eax,%edx
c01045ee:	89 d0                	mov    %edx,%eax
c01045f0:	c1 f8 03             	sar    $0x3,%eax
c01045f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01045f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f9:	8b 00                	mov    (%eax),%eax
c01045fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01045fe:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104601:	01 ca                	add    %ecx,%edx
c0104603:	39 d0                	cmp    %edx,%eax
c0104605:	0f 8c aa 00 00 00    	jl     c01046b5 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010460b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010460f:	74 38                	je     c0104649 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104611:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104614:	8b 00                	mov    (%eax),%eax
c0104616:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104619:	89 c2                	mov    %eax,%edx
c010461b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010461e:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104620:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104623:	8b 50 04             	mov    0x4(%eax),%edx
c0104626:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104629:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010462c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010462f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104632:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104635:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104638:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010463b:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010463d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104640:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104643:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104646:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c0104649:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010464c:	8b 00                	mov    (%eax),%eax
c010464e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104651:	75 0e                	jne    c0104661 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c0104653:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104656:	8b 50 04             	mov    0x4(%eax),%edx
c0104659:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010465c:	89 50 04             	mov    %edx,0x4(%eax)
c010465f:	eb 3c                	jmp    c010469d <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c0104661:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010466b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010466e:	01 c2                	add    %eax,%edx
c0104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104673:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104679:	8b 40 04             	mov    0x4(%eax),%eax
c010467c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010467f:	8b 12                	mov    (%edx),%edx
c0104681:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104684:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104689:	8b 40 04             	mov    0x4(%eax),%eax
c010468c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010468f:	8b 52 04             	mov    0x4(%edx),%edx
c0104692:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104695:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104698:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010469b:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c010469d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a0:	a3 08 ca 12 c0       	mov    %eax,0xc012ca08
			spin_unlock_irqrestore(&slob_lock, flags);
c01046a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046a8:	89 04 24             	mov    %eax,(%esp)
c01046ab:	e8 24 fd ff ff       	call   c01043d4 <__intr_restore>
			return cur;
c01046b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b3:	eb 7f                	jmp    c0104734 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c01046b5:	a1 08 ca 12 c0       	mov    0xc012ca08,%eax
c01046ba:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01046bd:	75 61                	jne    c0104720 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c01046bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01046c2:	89 04 24             	mov    %eax,(%esp)
c01046c5:	e8 0a fd ff ff       	call   c01043d4 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01046ca:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01046d1:	75 07                	jne    c01046da <slob_alloc+0x179>
				return 0;
c01046d3:	b8 00 00 00 00       	mov    $0x0,%eax
c01046d8:	eb 5a                	jmp    c0104734 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01046da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046e1:	00 
c01046e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e5:	89 04 24             	mov    %eax,(%esp)
c01046e8:	e8 07 fe ff ff       	call   c01044f4 <__slob_get_free_pages>
c01046ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c01046f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046f4:	75 07                	jne    c01046fd <slob_alloc+0x19c>
				return 0;
c01046f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01046fb:	eb 37                	jmp    c0104734 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c01046fd:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104704:	00 
c0104705:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104708:	89 04 24             	mov    %eax,(%esp)
c010470b:	e8 26 00 00 00       	call   c0104736 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104710:	e8 95 fc ff ff       	call   c01043aa <__intr_save>
c0104715:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104718:	a1 08 ca 12 c0       	mov    0xc012ca08,%eax
c010471d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104723:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104726:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104729:	8b 40 04             	mov    0x4(%eax),%eax
c010472c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c010472f:	e9 97 fe ff ff       	jmp    c01045cb <slob_alloc+0x6a>
}
c0104734:	c9                   	leave  
c0104735:	c3                   	ret    

c0104736 <slob_free>:

static void slob_free(void *block, int size)
{
c0104736:	55                   	push   %ebp
c0104737:	89 e5                	mov    %esp,%ebp
c0104739:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010473c:	8b 45 08             	mov    0x8(%ebp),%eax
c010473f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104742:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104746:	75 05                	jne    c010474d <slob_free+0x17>
		return;
c0104748:	e9 ff 00 00 00       	jmp    c010484c <slob_free+0x116>

	if (size)
c010474d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104751:	74 10                	je     c0104763 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c0104753:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104756:	83 c0 07             	add    $0x7,%eax
c0104759:	c1 e8 03             	shr    $0x3,%eax
c010475c:	89 c2                	mov    %eax,%edx
c010475e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104761:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104763:	e8 42 fc ff ff       	call   c01043aa <__intr_save>
c0104768:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c010476b:	a1 08 ca 12 c0       	mov    0xc012ca08,%eax
c0104770:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104773:	eb 27                	jmp    c010479c <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104778:	8b 40 04             	mov    0x4(%eax),%eax
c010477b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010477e:	77 13                	ja     c0104793 <slob_free+0x5d>
c0104780:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104783:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104786:	77 27                	ja     c01047af <slob_free+0x79>
c0104788:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478b:	8b 40 04             	mov    0x4(%eax),%eax
c010478e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104791:	77 1c                	ja     c01047af <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104793:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104796:	8b 40 04             	mov    0x4(%eax),%eax
c0104799:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010479c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010479f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047a2:	76 d1                	jbe    c0104775 <slob_free+0x3f>
c01047a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a7:	8b 40 04             	mov    0x4(%eax),%eax
c01047aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047ad:	76 c6                	jbe    c0104775 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c01047af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047b2:	8b 00                	mov    (%eax),%eax
c01047b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01047bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047be:	01 c2                	add    %eax,%edx
c01047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c3:	8b 40 04             	mov    0x4(%eax),%eax
c01047c6:	39 c2                	cmp    %eax,%edx
c01047c8:	75 25                	jne    c01047ef <slob_free+0xb9>
		b->units += cur->next->units;
c01047ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047cd:	8b 10                	mov    (%eax),%edx
c01047cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d2:	8b 40 04             	mov    0x4(%eax),%eax
c01047d5:	8b 00                	mov    (%eax),%eax
c01047d7:	01 c2                	add    %eax,%edx
c01047d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047dc:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c01047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e1:	8b 40 04             	mov    0x4(%eax),%eax
c01047e4:	8b 50 04             	mov    0x4(%eax),%edx
c01047e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ea:	89 50 04             	mov    %edx,0x4(%eax)
c01047ed:	eb 0c                	jmp    c01047fb <slob_free+0xc5>
	} else
		b->next = cur->next;
c01047ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f2:	8b 50 04             	mov    0x4(%eax),%edx
c01047f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047f8:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c01047fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fe:	8b 00                	mov    (%eax),%eax
c0104800:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010480a:	01 d0                	add    %edx,%eax
c010480c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010480f:	75 1f                	jne    c0104830 <slob_free+0xfa>
		cur->units += b->units;
c0104811:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104814:	8b 10                	mov    (%eax),%edx
c0104816:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104819:	8b 00                	mov    (%eax),%eax
c010481b:	01 c2                	add    %eax,%edx
c010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104820:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104822:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104825:	8b 50 04             	mov    0x4(%eax),%edx
c0104828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482b:	89 50 04             	mov    %edx,0x4(%eax)
c010482e:	eb 09                	jmp    c0104839 <slob_free+0x103>
	} else
		cur->next = b;
c0104830:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104833:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104836:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104839:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483c:	a3 08 ca 12 c0       	mov    %eax,0xc012ca08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104841:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104844:	89 04 24             	mov    %eax,(%esp)
c0104847:	e8 88 fb ff ff       	call   c01043d4 <__intr_restore>
}
c010484c:	c9                   	leave  
c010484d:	c3                   	ret    

c010484e <slob_init>:



void
slob_init(void) {
c010484e:	55                   	push   %ebp
c010484f:	89 e5                	mov    %esp,%ebp
c0104851:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104854:	c7 04 24 0a cc 10 c0 	movl   $0xc010cc0a,(%esp)
c010485b:	e8 f8 ba ff ff       	call   c0100358 <cprintf>
}
c0104860:	c9                   	leave  
c0104861:	c3                   	ret    

c0104862 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104862:	55                   	push   %ebp
c0104863:	89 e5                	mov    %esp,%ebp
c0104865:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104868:	e8 e1 ff ff ff       	call   c010484e <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c010486d:	c7 04 24 1e cc 10 c0 	movl   $0xc010cc1e,(%esp)
c0104874:	e8 df ba ff ff       	call   c0100358 <cprintf>
}
c0104879:	c9                   	leave  
c010487a:	c3                   	ret    

c010487b <slob_allocated>:

size_t
slob_allocated(void) {
c010487b:	55                   	push   %ebp
c010487c:	89 e5                	mov    %esp,%ebp
  return 0;
c010487e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104883:	5d                   	pop    %ebp
c0104884:	c3                   	ret    

c0104885 <kallocated>:

size_t
kallocated(void) {
c0104885:	55                   	push   %ebp
c0104886:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104888:	e8 ee ff ff ff       	call   c010487b <slob_allocated>
}
c010488d:	5d                   	pop    %ebp
c010488e:	c3                   	ret    

c010488f <find_order>:

static int find_order(int size)
{
c010488f:	55                   	push   %ebp
c0104890:	89 e5                	mov    %esp,%ebp
c0104892:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104895:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c010489c:	eb 07                	jmp    c01048a5 <find_order+0x16>
		order++;
c010489e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c01048a2:	d1 7d 08             	sarl   0x8(%ebp)
c01048a5:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01048ac:	7f f0                	jg     c010489e <find_order+0xf>
		order++;
	return order;
c01048ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01048b1:	c9                   	leave  
c01048b2:	c3                   	ret    

c01048b3 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c01048b3:	55                   	push   %ebp
c01048b4:	89 e5                	mov    %esp,%ebp
c01048b6:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c01048b9:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c01048c0:	77 38                	ja     c01048fa <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c01048c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c5:	8d 50 08             	lea    0x8(%eax),%edx
c01048c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048cf:	00 
c01048d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048d7:	89 14 24             	mov    %edx,(%esp)
c01048da:	e8 82 fc ff ff       	call   c0104561 <slob_alloc>
c01048df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c01048e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048e6:	74 08                	je     c01048f0 <__kmalloc+0x3d>
c01048e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048eb:	83 c0 08             	add    $0x8,%eax
c01048ee:	eb 05                	jmp    c01048f5 <__kmalloc+0x42>
c01048f0:	b8 00 00 00 00       	mov    $0x0,%eax
c01048f5:	e9 a6 00 00 00       	jmp    c01049a0 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c01048fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104901:	00 
c0104902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104905:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104909:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104910:	e8 4c fc ff ff       	call   c0104561 <slob_alloc>
c0104915:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104918:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010491c:	75 07                	jne    c0104925 <__kmalloc+0x72>
		return 0;
c010491e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104923:	eb 7b                	jmp    c01049a0 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104925:	8b 45 08             	mov    0x8(%ebp),%eax
c0104928:	89 04 24             	mov    %eax,(%esp)
c010492b:	e8 5f ff ff ff       	call   c010488f <find_order>
c0104930:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104933:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104938:	8b 00                	mov    (%eax),%eax
c010493a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010493e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104941:	89 04 24             	mov    %eax,(%esp)
c0104944:	e8 ab fb ff ff       	call   c01044f4 <__slob_get_free_pages>
c0104949:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010494c:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c010494f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104952:	8b 40 04             	mov    0x4(%eax),%eax
c0104955:	85 c0                	test   %eax,%eax
c0104957:	74 2f                	je     c0104988 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104959:	e8 4c fa ff ff       	call   c01043aa <__intr_save>
c010495e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104961:	8b 15 64 ed 1a c0    	mov    0xc01aed64,%edx
c0104967:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010496a:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c010496d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104970:	a3 64 ed 1a c0       	mov    %eax,0xc01aed64
		spin_unlock_irqrestore(&block_lock, flags);
c0104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104978:	89 04 24             	mov    %eax,(%esp)
c010497b:	e8 54 fa ff ff       	call   c01043d4 <__intr_restore>
		return bb->pages;
c0104980:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104983:	8b 40 04             	mov    0x4(%eax),%eax
c0104986:	eb 18                	jmp    c01049a0 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104988:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c010498f:	00 
c0104990:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104993:	89 04 24             	mov    %eax,(%esp)
c0104996:	e8 9b fd ff ff       	call   c0104736 <slob_free>
	return 0;
c010499b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049a0:	c9                   	leave  
c01049a1:	c3                   	ret    

c01049a2 <kmalloc>:

void *
kmalloc(size_t size)
{
c01049a2:	55                   	push   %ebp
c01049a3:	89 e5                	mov    %esp,%ebp
c01049a5:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c01049a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049af:	00 
c01049b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049b3:	89 04 24             	mov    %eax,(%esp)
c01049b6:	e8 f8 fe ff ff       	call   c01048b3 <__kmalloc>
}
c01049bb:	c9                   	leave  
c01049bc:	c3                   	ret    

c01049bd <kfree>:


void kfree(void *block)
{
c01049bd:	55                   	push   %ebp
c01049be:	89 e5                	mov    %esp,%ebp
c01049c0:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c01049c3:	c7 45 f0 64 ed 1a c0 	movl   $0xc01aed64,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01049ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049ce:	75 05                	jne    c01049d5 <kfree+0x18>
		return;
c01049d0:	e9 a2 00 00 00       	jmp    c0104a77 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01049d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01049d8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049dd:	85 c0                	test   %eax,%eax
c01049df:	75 7f                	jne    c0104a60 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c01049e1:	e8 c4 f9 ff ff       	call   c01043aa <__intr_save>
c01049e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c01049e9:	a1 64 ed 1a c0       	mov    0xc01aed64,%eax
c01049ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049f1:	eb 5c                	jmp    c0104a4f <kfree+0x92>
			if (bb->pages == block) {
c01049f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f6:	8b 40 04             	mov    0x4(%eax),%eax
c01049f9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01049fc:	75 3f                	jne    c0104a3d <kfree+0x80>
				*last = bb->next;
c01049fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a01:	8b 50 08             	mov    0x8(%eax),%edx
c0104a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a07:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104a09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a0c:	89 04 24             	mov    %eax,(%esp)
c0104a0f:	e8 c0 f9 ff ff       	call   c01043d4 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a17:	8b 10                	mov    (%eax),%edx
c0104a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a1c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a20:	89 04 24             	mov    %eax,(%esp)
c0104a23:	e8 05 fb ff ff       	call   c010452d <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104a28:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104a2f:	00 
c0104a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a33:	89 04 24             	mov    %eax,(%esp)
c0104a36:	e8 fb fc ff ff       	call   c0104736 <slob_free>
				return;
c0104a3b:	eb 3a                	jmp    c0104a77 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a40:	83 c0 08             	add    $0x8,%eax
c0104a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a49:	8b 40 08             	mov    0x8(%eax),%eax
c0104a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a53:	75 9e                	jne    c01049f3 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a58:	89 04 24             	mov    %eax,(%esp)
c0104a5b:	e8 74 f9 ff ff       	call   c01043d4 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a63:	83 e8 08             	sub    $0x8,%eax
c0104a66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a6d:	00 
c0104a6e:	89 04 24             	mov    %eax,(%esp)
c0104a71:	e8 c0 fc ff ff       	call   c0104736 <slob_free>
	return;
c0104a76:	90                   	nop
}
c0104a77:	c9                   	leave  
c0104a78:	c3                   	ret    

c0104a79 <ksize>:


unsigned int ksize(const void *block)
{
c0104a79:	55                   	push   %ebp
c0104a7a:	89 e5                	mov    %esp,%ebp
c0104a7c:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104a7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a83:	75 07                	jne    c0104a8c <ksize+0x13>
		return 0;
c0104a85:	b8 00 00 00 00       	mov    $0x0,%eax
c0104a8a:	eb 6b                	jmp    c0104af7 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a8f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a94:	85 c0                	test   %eax,%eax
c0104a96:	75 54                	jne    c0104aec <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104a98:	e8 0d f9 ff ff       	call   c01043aa <__intr_save>
c0104a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104aa0:	a1 64 ed 1a c0       	mov    0xc01aed64,%eax
c0104aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104aa8:	eb 31                	jmp    c0104adb <ksize+0x62>
			if (bb->pages == block) {
c0104aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aad:	8b 40 04             	mov    0x4(%eax),%eax
c0104ab0:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104ab3:	75 1d                	jne    c0104ad2 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ab8:	89 04 24             	mov    %eax,(%esp)
c0104abb:	e8 14 f9 ff ff       	call   c01043d4 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac3:	8b 00                	mov    (%eax),%eax
c0104ac5:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104aca:	89 c1                	mov    %eax,%ecx
c0104acc:	d3 e2                	shl    %cl,%edx
c0104ace:	89 d0                	mov    %edx,%eax
c0104ad0:	eb 25                	jmp    c0104af7 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad5:	8b 40 08             	mov    0x8(%eax),%eax
c0104ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104adb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104adf:	75 c9                	jne    c0104aaa <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae4:	89 04 24             	mov    %eax,(%esp)
c0104ae7:	e8 e8 f8 ff ff       	call   c01043d4 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0104aef:	83 e8 08             	sub    $0x8,%eax
c0104af2:	8b 00                	mov    (%eax),%eax
c0104af4:	c1 e0 03             	shl    $0x3,%eax
}
c0104af7:	c9                   	leave  
c0104af8:	c3                   	ret    

c0104af9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104af9:	55                   	push   %ebp
c0104afa:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104afc:	8b 55 08             	mov    0x8(%ebp),%edx
c0104aff:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0104b04:	29 c2                	sub    %eax,%edx
c0104b06:	89 d0                	mov    %edx,%eax
c0104b08:	c1 f8 05             	sar    $0x5,%eax
}
c0104b0b:	5d                   	pop    %ebp
c0104b0c:	c3                   	ret    

c0104b0d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104b0d:	55                   	push   %ebp
c0104b0e:	89 e5                	mov    %esp,%ebp
c0104b10:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b16:	89 04 24             	mov    %eax,(%esp)
c0104b19:	e8 db ff ff ff       	call   c0104af9 <page2ppn>
c0104b1e:	c1 e0 0c             	shl    $0xc,%eax
}
c0104b21:	c9                   	leave  
c0104b22:	c3                   	ret    

c0104b23 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b23:	55                   	push   %ebp
c0104b24:	89 e5                	mov    %esp,%ebp
c0104b26:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b2c:	c1 e8 0c             	shr    $0xc,%eax
c0104b2f:	89 c2                	mov    %eax,%edx
c0104b31:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0104b36:	39 c2                	cmp    %eax,%edx
c0104b38:	72 1c                	jb     c0104b56 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104b3a:	c7 44 24 08 3c cc 10 	movl   $0xc010cc3c,0x8(%esp)
c0104b41:	c0 
c0104b42:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104b49:	00 
c0104b4a:	c7 04 24 5b cc 10 c0 	movl   $0xc010cc5b,(%esp)
c0104b51:	e8 84 c2 ff ff       	call   c0100dda <__panic>
    }
    return &pages[PPN(pa)];
c0104b56:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0104b5b:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b5e:	c1 ea 0c             	shr    $0xc,%edx
c0104b61:	c1 e2 05             	shl    $0x5,%edx
c0104b64:	01 d0                	add    %edx,%eax
}
c0104b66:	c9                   	leave  
c0104b67:	c3                   	ret    

c0104b68 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104b68:	55                   	push   %ebp
c0104b69:	89 e5                	mov    %esp,%ebp
c0104b6b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b71:	89 04 24             	mov    %eax,(%esp)
c0104b74:	e8 94 ff ff ff       	call   c0104b0d <page2pa>
c0104b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7f:	c1 e8 0c             	shr    $0xc,%eax
c0104b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b85:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0104b8a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104b8d:	72 23                	jb     c0104bb2 <page2kva+0x4a>
c0104b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b92:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b96:	c7 44 24 08 6c cc 10 	movl   $0xc010cc6c,0x8(%esp)
c0104b9d:	c0 
c0104b9e:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104ba5:	00 
c0104ba6:	c7 04 24 5b cc 10 c0 	movl   $0xc010cc5b,(%esp)
c0104bad:	e8 28 c2 ff ff       	call   c0100dda <__panic>
c0104bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104bba:	c9                   	leave  
c0104bbb:	c3                   	ret    

c0104bbc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104bbc:	55                   	push   %ebp
c0104bbd:	89 e5                	mov    %esp,%ebp
c0104bbf:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104bc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc5:	83 e0 01             	and    $0x1,%eax
c0104bc8:	85 c0                	test   %eax,%eax
c0104bca:	75 1c                	jne    c0104be8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104bcc:	c7 44 24 08 90 cc 10 	movl   $0xc010cc90,0x8(%esp)
c0104bd3:	c0 
c0104bd4:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104bdb:	00 
c0104bdc:	c7 04 24 5b cc 10 c0 	movl   $0xc010cc5b,(%esp)
c0104be3:	e8 f2 c1 ff ff       	call   c0100dda <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104beb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bf0:	89 04 24             	mov    %eax,(%esp)
c0104bf3:	e8 2b ff ff ff       	call   c0104b23 <pa2page>
}
c0104bf8:	c9                   	leave  
c0104bf9:	c3                   	ret    

c0104bfa <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104bfa:	55                   	push   %ebp
c0104bfb:	89 e5                	mov    %esp,%ebp
c0104bfd:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104c00:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c08:	89 04 24             	mov    %eax,(%esp)
c0104c0b:	e8 13 ff ff ff       	call   c0104b23 <pa2page>
}
c0104c10:	c9                   	leave  
c0104c11:	c3                   	ret    

c0104c12 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104c12:	55                   	push   %ebp
c0104c13:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c18:	8b 00                	mov    (%eax),%eax
}
c0104c1a:	5d                   	pop    %ebp
c0104c1b:	c3                   	ret    

c0104c1c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104c1c:	55                   	push   %ebp
c0104c1d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c22:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c25:	89 10                	mov    %edx,(%eax)
}
c0104c27:	5d                   	pop    %ebp
c0104c28:	c3                   	ret    

c0104c29 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104c29:	55                   	push   %ebp
c0104c2a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104c2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c2f:	8b 00                	mov    (%eax),%eax
c0104c31:	8d 50 01             	lea    0x1(%eax),%edx
c0104c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c37:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c3c:	8b 00                	mov    (%eax),%eax
}
c0104c3e:	5d                   	pop    %ebp
c0104c3f:	c3                   	ret    

c0104c40 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104c40:	55                   	push   %ebp
c0104c41:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104c43:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c46:	8b 00                	mov    (%eax),%eax
c0104c48:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c4e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104c50:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c53:	8b 00                	mov    (%eax),%eax
}
c0104c55:	5d                   	pop    %ebp
c0104c56:	c3                   	ret    

c0104c57 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104c57:	55                   	push   %ebp
c0104c58:	89 e5                	mov    %esp,%ebp
c0104c5a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104c5d:	9c                   	pushf  
c0104c5e:	58                   	pop    %eax
c0104c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104c65:	25 00 02 00 00       	and    $0x200,%eax
c0104c6a:	85 c0                	test   %eax,%eax
c0104c6c:	74 0c                	je     c0104c7a <__intr_save+0x23>
        intr_disable();
c0104c6e:	e8 bf d3 ff ff       	call   c0102032 <intr_disable>
        return 1;
c0104c73:	b8 01 00 00 00       	mov    $0x1,%eax
c0104c78:	eb 05                	jmp    c0104c7f <__intr_save+0x28>
    }
    return 0;
c0104c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104c7f:	c9                   	leave  
c0104c80:	c3                   	ret    

c0104c81 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104c81:	55                   	push   %ebp
c0104c82:	89 e5                	mov    %esp,%ebp
c0104c84:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104c87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104c8b:	74 05                	je     c0104c92 <__intr_restore+0x11>
        intr_enable();
c0104c8d:	e8 9a d3 ff ff       	call   c010202c <intr_enable>
    }
}
c0104c92:	c9                   	leave  
c0104c93:	c3                   	ret    

c0104c94 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104c94:	55                   	push   %ebp
c0104c95:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104c9d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ca2:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104ca4:	b8 23 00 00 00       	mov    $0x23,%eax
c0104ca9:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104cab:	b8 10 00 00 00       	mov    $0x10,%eax
c0104cb0:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104cb2:	b8 10 00 00 00       	mov    $0x10,%eax
c0104cb7:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104cb9:	b8 10 00 00 00       	mov    $0x10,%eax
c0104cbe:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104cc0:	ea c7 4c 10 c0 08 00 	ljmp   $0x8,$0xc0104cc7
}
c0104cc7:	5d                   	pop    %ebp
c0104cc8:	c3                   	ret    

c0104cc9 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104cc9:	55                   	push   %ebp
c0104cca:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ccf:	a3 a4 ed 1a c0       	mov    %eax,0xc01aeda4
}
c0104cd4:	5d                   	pop    %ebp
c0104cd5:	c3                   	ret    

c0104cd6 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104cd6:	55                   	push   %ebp
c0104cd7:	89 e5                	mov    %esp,%ebp
c0104cd9:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104cdc:	b8 00 c0 12 c0       	mov    $0xc012c000,%eax
c0104ce1:	89 04 24             	mov    %eax,(%esp)
c0104ce4:	e8 e0 ff ff ff       	call   c0104cc9 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104ce9:	66 c7 05 a8 ed 1a c0 	movw   $0x10,0xc01aeda8
c0104cf0:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104cf2:	66 c7 05 48 ca 12 c0 	movw   $0x68,0xc012ca48
c0104cf9:	68 00 
c0104cfb:	b8 a0 ed 1a c0       	mov    $0xc01aeda0,%eax
c0104d00:	66 a3 4a ca 12 c0    	mov    %ax,0xc012ca4a
c0104d06:	b8 a0 ed 1a c0       	mov    $0xc01aeda0,%eax
c0104d0b:	c1 e8 10             	shr    $0x10,%eax
c0104d0e:	a2 4c ca 12 c0       	mov    %al,0xc012ca4c
c0104d13:	0f b6 05 4d ca 12 c0 	movzbl 0xc012ca4d,%eax
c0104d1a:	83 e0 f0             	and    $0xfffffff0,%eax
c0104d1d:	83 c8 09             	or     $0x9,%eax
c0104d20:	a2 4d ca 12 c0       	mov    %al,0xc012ca4d
c0104d25:	0f b6 05 4d ca 12 c0 	movzbl 0xc012ca4d,%eax
c0104d2c:	83 e0 ef             	and    $0xffffffef,%eax
c0104d2f:	a2 4d ca 12 c0       	mov    %al,0xc012ca4d
c0104d34:	0f b6 05 4d ca 12 c0 	movzbl 0xc012ca4d,%eax
c0104d3b:	83 e0 9f             	and    $0xffffff9f,%eax
c0104d3e:	a2 4d ca 12 c0       	mov    %al,0xc012ca4d
c0104d43:	0f b6 05 4d ca 12 c0 	movzbl 0xc012ca4d,%eax
c0104d4a:	83 c8 80             	or     $0xffffff80,%eax
c0104d4d:	a2 4d ca 12 c0       	mov    %al,0xc012ca4d
c0104d52:	0f b6 05 4e ca 12 c0 	movzbl 0xc012ca4e,%eax
c0104d59:	83 e0 f0             	and    $0xfffffff0,%eax
c0104d5c:	a2 4e ca 12 c0       	mov    %al,0xc012ca4e
c0104d61:	0f b6 05 4e ca 12 c0 	movzbl 0xc012ca4e,%eax
c0104d68:	83 e0 ef             	and    $0xffffffef,%eax
c0104d6b:	a2 4e ca 12 c0       	mov    %al,0xc012ca4e
c0104d70:	0f b6 05 4e ca 12 c0 	movzbl 0xc012ca4e,%eax
c0104d77:	83 e0 df             	and    $0xffffffdf,%eax
c0104d7a:	a2 4e ca 12 c0       	mov    %al,0xc012ca4e
c0104d7f:	0f b6 05 4e ca 12 c0 	movzbl 0xc012ca4e,%eax
c0104d86:	83 c8 40             	or     $0x40,%eax
c0104d89:	a2 4e ca 12 c0       	mov    %al,0xc012ca4e
c0104d8e:	0f b6 05 4e ca 12 c0 	movzbl 0xc012ca4e,%eax
c0104d95:	83 e0 7f             	and    $0x7f,%eax
c0104d98:	a2 4e ca 12 c0       	mov    %al,0xc012ca4e
c0104d9d:	b8 a0 ed 1a c0       	mov    $0xc01aeda0,%eax
c0104da2:	c1 e8 18             	shr    $0x18,%eax
c0104da5:	a2 4f ca 12 c0       	mov    %al,0xc012ca4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104daa:	c7 04 24 50 ca 12 c0 	movl   $0xc012ca50,(%esp)
c0104db1:	e8 de fe ff ff       	call   c0104c94 <lgdt>
c0104db6:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104dbc:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104dc0:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104dc3:	c9                   	leave  
c0104dc4:	c3                   	ret    

c0104dc5 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104dc5:	55                   	push   %ebp
c0104dc6:	89 e5                	mov    %esp,%ebp
c0104dc8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104dcb:	c7 05 88 0e 1b c0 30 	movl   $0xc010cb30,0xc01b0e88
c0104dd2:	cb 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104dd5:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104dda:	8b 00                	mov    (%eax),%eax
c0104ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104de0:	c7 04 24 bc cc 10 c0 	movl   $0xc010ccbc,(%esp)
c0104de7:	e8 6c b5 ff ff       	call   c0100358 <cprintf>
    pmm_manager->init();
c0104dec:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104df1:	8b 40 04             	mov    0x4(%eax),%eax
c0104df4:	ff d0                	call   *%eax
}
c0104df6:	c9                   	leave  
c0104df7:	c3                   	ret    

c0104df8 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104df8:	55                   	push   %ebp
c0104df9:	89 e5                	mov    %esp,%ebp
c0104dfb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104dfe:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104e03:	8b 40 08             	mov    0x8(%eax),%eax
c0104e06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e09:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e0d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e10:	89 14 24             	mov    %edx,(%esp)
c0104e13:	ff d0                	call   *%eax
}
c0104e15:	c9                   	leave  
c0104e16:	c3                   	ret    

c0104e17 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104e17:	55                   	push   %ebp
c0104e18:	89 e5                	mov    %esp,%ebp
c0104e1a:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104e24:	e8 2e fe ff ff       	call   c0104c57 <__intr_save>
c0104e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104e2c:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104e31:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e34:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e37:	89 14 24             	mov    %edx,(%esp)
c0104e3a:	ff d0                	call   *%eax
c0104e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e42:	89 04 24             	mov    %eax,(%esp)
c0104e45:	e8 37 fe ff ff       	call   c0104c81 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104e4e:	75 2d                	jne    c0104e7d <alloc_pages+0x66>
c0104e50:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104e54:	77 27                	ja     c0104e7d <alloc_pages+0x66>
c0104e56:	a1 0c ee 1a c0       	mov    0xc01aee0c,%eax
c0104e5b:	85 c0                	test   %eax,%eax
c0104e5d:	74 1e                	je     c0104e7d <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104e5f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e62:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c0104e67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e6e:	00 
c0104e6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e73:	89 04 24             	mov    %eax,(%esp)
c0104e76:	e8 a6 1d 00 00       	call   c0106c21 <swap_out>
    }
c0104e7b:	eb a7                	jmp    c0104e24 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104e80:	c9                   	leave  
c0104e81:	c3                   	ret    

c0104e82 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104e82:	55                   	push   %ebp
c0104e83:	89 e5                	mov    %esp,%ebp
c0104e85:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104e88:	e8 ca fd ff ff       	call   c0104c57 <__intr_save>
c0104e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104e90:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104e95:	8b 40 10             	mov    0x10(%eax),%eax
c0104e98:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e9b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e9f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ea2:	89 14 24             	mov    %edx,(%esp)
c0104ea5:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eaa:	89 04 24             	mov    %eax,(%esp)
c0104ead:	e8 cf fd ff ff       	call   c0104c81 <__intr_restore>
}
c0104eb2:	c9                   	leave  
c0104eb3:	c3                   	ret    

c0104eb4 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104eb4:	55                   	push   %ebp
c0104eb5:	89 e5                	mov    %esp,%ebp
c0104eb7:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104eba:	e8 98 fd ff ff       	call   c0104c57 <__intr_save>
c0104ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104ec2:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0104ec7:	8b 40 14             	mov    0x14(%eax),%eax
c0104eca:	ff d0                	call   *%eax
c0104ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed2:	89 04 24             	mov    %eax,(%esp)
c0104ed5:	e8 a7 fd ff ff       	call   c0104c81 <__intr_restore>
    return ret;
c0104eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104edd:	c9                   	leave  
c0104ede:	c3                   	ret    

c0104edf <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104edf:	55                   	push   %ebp
c0104ee0:	89 e5                	mov    %esp,%ebp
c0104ee2:	57                   	push   %edi
c0104ee3:	56                   	push   %esi
c0104ee4:	53                   	push   %ebx
c0104ee5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104eeb:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104ef2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104ef9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104f00:	c7 04 24 d3 cc 10 c0 	movl   $0xc010ccd3,(%esp)
c0104f07:	e8 4c b4 ff ff       	call   c0100358 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104f13:	e9 15 01 00 00       	jmp    c010502d <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104f18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f1e:	89 d0                	mov    %edx,%eax
c0104f20:	c1 e0 02             	shl    $0x2,%eax
c0104f23:	01 d0                	add    %edx,%eax
c0104f25:	c1 e0 02             	shl    $0x2,%eax
c0104f28:	01 c8                	add    %ecx,%eax
c0104f2a:	8b 50 08             	mov    0x8(%eax),%edx
c0104f2d:	8b 40 04             	mov    0x4(%eax),%eax
c0104f30:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104f33:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104f36:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f39:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f3c:	89 d0                	mov    %edx,%eax
c0104f3e:	c1 e0 02             	shl    $0x2,%eax
c0104f41:	01 d0                	add    %edx,%eax
c0104f43:	c1 e0 02             	shl    $0x2,%eax
c0104f46:	01 c8                	add    %ecx,%eax
c0104f48:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104f4b:	8b 58 10             	mov    0x10(%eax),%ebx
c0104f4e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f51:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f54:	01 c8                	add    %ecx,%eax
c0104f56:	11 da                	adc    %ebx,%edx
c0104f58:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104f5b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104f5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f64:	89 d0                	mov    %edx,%eax
c0104f66:	c1 e0 02             	shl    $0x2,%eax
c0104f69:	01 d0                	add    %edx,%eax
c0104f6b:	c1 e0 02             	shl    $0x2,%eax
c0104f6e:	01 c8                	add    %ecx,%eax
c0104f70:	83 c0 14             	add    $0x14,%eax
c0104f73:	8b 00                	mov    (%eax),%eax
c0104f75:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104f7b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f7e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f81:	83 c0 ff             	add    $0xffffffff,%eax
c0104f84:	83 d2 ff             	adc    $0xffffffff,%edx
c0104f87:	89 c6                	mov    %eax,%esi
c0104f89:	89 d7                	mov    %edx,%edi
c0104f8b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f91:	89 d0                	mov    %edx,%eax
c0104f93:	c1 e0 02             	shl    $0x2,%eax
c0104f96:	01 d0                	add    %edx,%eax
c0104f98:	c1 e0 02             	shl    $0x2,%eax
c0104f9b:	01 c8                	add    %ecx,%eax
c0104f9d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104fa0:	8b 58 10             	mov    0x10(%eax),%ebx
c0104fa3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104fa9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104fad:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104fb1:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104fb5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104fb8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104fbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fbf:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104fc3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104fc7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104fcb:	c7 04 24 e0 cc 10 c0 	movl   $0xc010cce0,(%esp)
c0104fd2:	e8 81 b3 ff ff       	call   c0100358 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104fd7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fda:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fdd:	89 d0                	mov    %edx,%eax
c0104fdf:	c1 e0 02             	shl    $0x2,%eax
c0104fe2:	01 d0                	add    %edx,%eax
c0104fe4:	c1 e0 02             	shl    $0x2,%eax
c0104fe7:	01 c8                	add    %ecx,%eax
c0104fe9:	83 c0 14             	add    $0x14,%eax
c0104fec:	8b 00                	mov    (%eax),%eax
c0104fee:	83 f8 01             	cmp    $0x1,%eax
c0104ff1:	75 36                	jne    c0105029 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ff6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104ff9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104ffc:	77 2b                	ja     c0105029 <page_init+0x14a>
c0104ffe:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105001:	72 05                	jb     c0105008 <page_init+0x129>
c0105003:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105006:	73 21                	jae    c0105029 <page_init+0x14a>
c0105008:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010500c:	77 1b                	ja     c0105029 <page_init+0x14a>
c010500e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105012:	72 09                	jb     c010501d <page_init+0x13e>
c0105014:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010501b:	77 0c                	ja     c0105029 <page_init+0x14a>
                maxpa = end;
c010501d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105020:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105023:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105026:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105029:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010502d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105030:	8b 00                	mov    (%eax),%eax
c0105032:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105035:	0f 8f dd fe ff ff    	jg     c0104f18 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010503b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010503f:	72 1d                	jb     c010505e <page_init+0x17f>
c0105041:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105045:	77 09                	ja     c0105050 <page_init+0x171>
c0105047:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010504e:	76 0e                	jbe    c010505e <page_init+0x17f>
        maxpa = KMEMSIZE;
c0105050:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105057:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010505e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105061:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105064:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105068:	c1 ea 0c             	shr    $0xc,%edx
c010506b:	a3 80 ed 1a c0       	mov    %eax,0xc01aed80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105070:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0105077:	b8 78 0f 1b c0       	mov    $0xc01b0f78,%eax
c010507c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010507f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0105082:	01 d0                	add    %edx,%eax
c0105084:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105087:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010508a:	ba 00 00 00 00       	mov    $0x0,%edx
c010508f:	f7 75 ac             	divl   -0x54(%ebp)
c0105092:	89 d0                	mov    %edx,%eax
c0105094:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105097:	29 c2                	sub    %eax,%edx
c0105099:	89 d0                	mov    %edx,%eax
c010509b:	a3 90 0e 1b c0       	mov    %eax,0xc01b0e90

    for (i = 0; i < npage; i ++) {
c01050a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01050a7:	eb 27                	jmp    c01050d0 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01050a9:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c01050ae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050b1:	c1 e2 05             	shl    $0x5,%edx
c01050b4:	01 d0                	add    %edx,%eax
c01050b6:	83 c0 04             	add    $0x4,%eax
c01050b9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01050c0:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01050c3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01050c6:	8b 55 90             	mov    -0x70(%ebp),%edx
c01050c9:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01050cc:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01050d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050d3:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c01050d8:	39 c2                	cmp    %eax,%edx
c01050da:	72 cd                	jb     c01050a9 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01050dc:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c01050e1:	c1 e0 05             	shl    $0x5,%eax
c01050e4:	89 c2                	mov    %eax,%edx
c01050e6:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c01050eb:	01 d0                	add    %edx,%eax
c01050ed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01050f0:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01050f7:	77 23                	ja     c010511c <page_init+0x23d>
c01050f9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01050fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105100:	c7 44 24 08 10 cd 10 	movl   $0xc010cd10,0x8(%esp)
c0105107:	c0 
c0105108:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010510f:	00 
c0105110:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105117:	e8 be bc ff ff       	call   c0100dda <__panic>
c010511c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010511f:	05 00 00 00 40       	add    $0x40000000,%eax
c0105124:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105127:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010512e:	e9 74 01 00 00       	jmp    c01052a7 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105133:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105136:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105139:	89 d0                	mov    %edx,%eax
c010513b:	c1 e0 02             	shl    $0x2,%eax
c010513e:	01 d0                	add    %edx,%eax
c0105140:	c1 e0 02             	shl    $0x2,%eax
c0105143:	01 c8                	add    %ecx,%eax
c0105145:	8b 50 08             	mov    0x8(%eax),%edx
c0105148:	8b 40 04             	mov    0x4(%eax),%eax
c010514b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010514e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105151:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105154:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105157:	89 d0                	mov    %edx,%eax
c0105159:	c1 e0 02             	shl    $0x2,%eax
c010515c:	01 d0                	add    %edx,%eax
c010515e:	c1 e0 02             	shl    $0x2,%eax
c0105161:	01 c8                	add    %ecx,%eax
c0105163:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105166:	8b 58 10             	mov    0x10(%eax),%ebx
c0105169:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010516c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010516f:	01 c8                	add    %ecx,%eax
c0105171:	11 da                	adc    %ebx,%edx
c0105173:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105176:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105179:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010517c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010517f:	89 d0                	mov    %edx,%eax
c0105181:	c1 e0 02             	shl    $0x2,%eax
c0105184:	01 d0                	add    %edx,%eax
c0105186:	c1 e0 02             	shl    $0x2,%eax
c0105189:	01 c8                	add    %ecx,%eax
c010518b:	83 c0 14             	add    $0x14,%eax
c010518e:	8b 00                	mov    (%eax),%eax
c0105190:	83 f8 01             	cmp    $0x1,%eax
c0105193:	0f 85 0a 01 00 00    	jne    c01052a3 <page_init+0x3c4>
            if (begin < freemem) {
c0105199:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010519c:	ba 00 00 00 00       	mov    $0x0,%edx
c01051a1:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01051a4:	72 17                	jb     c01051bd <page_init+0x2de>
c01051a6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01051a9:	77 05                	ja     c01051b0 <page_init+0x2d1>
c01051ab:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01051ae:	76 0d                	jbe    c01051bd <page_init+0x2de>
                begin = freemem;
c01051b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01051b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01051b6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01051bd:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01051c1:	72 1d                	jb     c01051e0 <page_init+0x301>
c01051c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01051c7:	77 09                	ja     c01051d2 <page_init+0x2f3>
c01051c9:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01051d0:	76 0e                	jbe    c01051e0 <page_init+0x301>
                end = KMEMSIZE;
c01051d2:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01051d9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01051e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051e6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051e9:	0f 87 b4 00 00 00    	ja     c01052a3 <page_init+0x3c4>
c01051ef:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051f2:	72 09                	jb     c01051fd <page_init+0x31e>
c01051f4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01051f7:	0f 83 a6 00 00 00    	jae    c01052a3 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01051fd:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105204:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105207:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010520a:	01 d0                	add    %edx,%eax
c010520c:	83 e8 01             	sub    $0x1,%eax
c010520f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0105212:	8b 45 98             	mov    -0x68(%ebp),%eax
c0105215:	ba 00 00 00 00       	mov    $0x0,%edx
c010521a:	f7 75 9c             	divl   -0x64(%ebp)
c010521d:	89 d0                	mov    %edx,%eax
c010521f:	8b 55 98             	mov    -0x68(%ebp),%edx
c0105222:	29 c2                	sub    %eax,%edx
c0105224:	89 d0                	mov    %edx,%eax
c0105226:	ba 00 00 00 00       	mov    $0x0,%edx
c010522b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010522e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0105231:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105234:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105237:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010523a:	ba 00 00 00 00       	mov    $0x0,%edx
c010523f:	89 c7                	mov    %eax,%edi
c0105241:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105247:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010524a:	89 d0                	mov    %edx,%eax
c010524c:	83 e0 00             	and    $0x0,%eax
c010524f:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0105252:	8b 45 80             	mov    -0x80(%ebp),%eax
c0105255:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105258:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010525b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010525e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105261:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105264:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105267:	77 3a                	ja     c01052a3 <page_init+0x3c4>
c0105269:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010526c:	72 05                	jb     c0105273 <page_init+0x394>
c010526e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105271:	73 30                	jae    c01052a3 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105273:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0105276:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0105279:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010527c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010527f:	29 c8                	sub    %ecx,%eax
c0105281:	19 da                	sbb    %ebx,%edx
c0105283:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105287:	c1 ea 0c             	shr    $0xc,%edx
c010528a:	89 c3                	mov    %eax,%ebx
c010528c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010528f:	89 04 24             	mov    %eax,(%esp)
c0105292:	e8 8c f8 ff ff       	call   c0104b23 <pa2page>
c0105297:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010529b:	89 04 24             	mov    %eax,(%esp)
c010529e:	e8 55 fb ff ff       	call   c0104df8 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01052a3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01052a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01052aa:	8b 00                	mov    (%eax),%eax
c01052ac:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01052af:	0f 8f 7e fe ff ff    	jg     c0105133 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01052b5:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01052bb:	5b                   	pop    %ebx
c01052bc:	5e                   	pop    %esi
c01052bd:	5f                   	pop    %edi
c01052be:	5d                   	pop    %ebp
c01052bf:	c3                   	ret    

c01052c0 <enable_paging>:

static void
enable_paging(void) {
c01052c0:	55                   	push   %ebp
c01052c1:	89 e5                	mov    %esp,%ebp
c01052c3:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01052c6:	a1 8c 0e 1b c0       	mov    0xc01b0e8c,%eax
c01052cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01052ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01052d1:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01052d4:	0f 20 c0             	mov    %cr0,%eax
c01052d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01052da:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01052dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01052e0:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01052e7:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01052eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01052f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052f4:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01052f7:	c9                   	leave  
c01052f8:	c3                   	ret    

c01052f9 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01052f9:	55                   	push   %ebp
c01052fa:	89 e5                	mov    %esp,%ebp
c01052fc:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01052ff:	8b 45 14             	mov    0x14(%ebp),%eax
c0105302:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105305:	31 d0                	xor    %edx,%eax
c0105307:	25 ff 0f 00 00       	and    $0xfff,%eax
c010530c:	85 c0                	test   %eax,%eax
c010530e:	74 24                	je     c0105334 <boot_map_segment+0x3b>
c0105310:	c7 44 24 0c 42 cd 10 	movl   $0xc010cd42,0xc(%esp)
c0105317:	c0 
c0105318:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010531f:	c0 
c0105320:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105327:	00 
c0105328:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010532f:	e8 a6 ba ff ff       	call   c0100dda <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105334:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010533b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010533e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105343:	89 c2                	mov    %eax,%edx
c0105345:	8b 45 10             	mov    0x10(%ebp),%eax
c0105348:	01 c2                	add    %eax,%edx
c010534a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010534d:	01 d0                	add    %edx,%eax
c010534f:	83 e8 01             	sub    $0x1,%eax
c0105352:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105355:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105358:	ba 00 00 00 00       	mov    $0x0,%edx
c010535d:	f7 75 f0             	divl   -0x10(%ebp)
c0105360:	89 d0                	mov    %edx,%eax
c0105362:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105365:	29 c2                	sub    %eax,%edx
c0105367:	89 d0                	mov    %edx,%eax
c0105369:	c1 e8 0c             	shr    $0xc,%eax
c010536c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010536f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105372:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105375:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105378:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010537d:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105380:	8b 45 14             	mov    0x14(%ebp),%eax
c0105383:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105386:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010538e:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105391:	eb 6b                	jmp    c01053fe <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105393:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010539a:	00 
c010539b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010539e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a5:	89 04 24             	mov    %eax,(%esp)
c01053a8:	e8 d1 01 00 00       	call   c010557e <get_pte>
c01053ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01053b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01053b4:	75 24                	jne    c01053da <boot_map_segment+0xe1>
c01053b6:	c7 44 24 0c 6e cd 10 	movl   $0xc010cd6e,0xc(%esp)
c01053bd:	c0 
c01053be:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01053c5:	c0 
c01053c6:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01053cd:	00 
c01053ce:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01053d5:	e8 00 ba ff ff       	call   c0100dda <__panic>
        *ptep = pa | PTE_P | perm;
c01053da:	8b 45 18             	mov    0x18(%ebp),%eax
c01053dd:	8b 55 14             	mov    0x14(%ebp),%edx
c01053e0:	09 d0                	or     %edx,%eax
c01053e2:	83 c8 01             	or     $0x1,%eax
c01053e5:	89 c2                	mov    %eax,%edx
c01053e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053ea:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01053ec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01053f0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01053f7:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01053fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105402:	75 8f                	jne    c0105393 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0105404:	c9                   	leave  
c0105405:	c3                   	ret    

c0105406 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105406:	55                   	push   %ebp
c0105407:	89 e5                	mov    %esp,%ebp
c0105409:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010540c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105413:	e8 ff f9 ff ff       	call   c0104e17 <alloc_pages>
c0105418:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010541b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010541f:	75 1c                	jne    c010543d <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0105421:	c7 44 24 08 7b cd 10 	movl   $0xc010cd7b,0x8(%esp)
c0105428:	c0 
c0105429:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105430:	00 
c0105431:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105438:	e8 9d b9 ff ff       	call   c0100dda <__panic>
    }
    return page2kva(p);
c010543d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105440:	89 04 24             	mov    %eax,(%esp)
c0105443:	e8 20 f7 ff ff       	call   c0104b68 <page2kva>
}
c0105448:	c9                   	leave  
c0105449:	c3                   	ret    

c010544a <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010544a:	55                   	push   %ebp
c010544b:	89 e5                	mov    %esp,%ebp
c010544d:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105450:	e8 70 f9 ff ff       	call   c0104dc5 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0105455:	e8 85 fa ff ff       	call   c0104edf <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010545a:	e8 67 09 00 00       	call   c0105dc6 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010545f:	e8 a2 ff ff ff       	call   c0105406 <boot_alloc_page>
c0105464:	a3 84 ed 1a c0       	mov    %eax,0xc01aed84
    memset(boot_pgdir, 0, PGSIZE);
c0105469:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010546e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105475:	00 
c0105476:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010547d:	00 
c010547e:	89 04 24             	mov    %eax,(%esp)
c0105481:	e8 93 68 00 00       	call   c010bd19 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0105486:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010548b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010548e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105495:	77 23                	ja     c01054ba <pmm_init+0x70>
c0105497:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010549a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010549e:	c7 44 24 08 10 cd 10 	movl   $0xc010cd10,0x8(%esp)
c01054a5:	c0 
c01054a6:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01054ad:	00 
c01054ae:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01054b5:	e8 20 b9 ff ff       	call   c0100dda <__panic>
c01054ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054bd:	05 00 00 00 40       	add    $0x40000000,%eax
c01054c2:	a3 8c 0e 1b c0       	mov    %eax,0xc01b0e8c

    check_pgdir();
c01054c7:	e8 18 09 00 00       	call   c0105de4 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01054cc:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01054d1:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01054d7:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01054dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054df:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01054e6:	77 23                	ja     c010550b <pmm_init+0xc1>
c01054e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01054ef:	c7 44 24 08 10 cd 10 	movl   $0xc010cd10,0x8(%esp)
c01054f6:	c0 
c01054f7:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01054fe:	00 
c01054ff:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105506:	e8 cf b8 ff ff       	call   c0100dda <__panic>
c010550b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010550e:	05 00 00 00 40       	add    $0x40000000,%eax
c0105513:	83 c8 03             	or     $0x3,%eax
c0105516:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105518:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010551d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0105524:	00 
c0105525:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010552c:	00 
c010552d:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0105534:	38 
c0105535:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010553c:	c0 
c010553d:	89 04 24             	mov    %eax,(%esp)
c0105540:	e8 b4 fd ff ff       	call   c01052f9 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0105545:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010554a:	8b 15 84 ed 1a c0    	mov    0xc01aed84,%edx
c0105550:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0105556:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105558:	e8 63 fd ff ff       	call   c01052c0 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010555d:	e8 74 f7 ff ff       	call   c0104cd6 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105562:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105567:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010556d:	e8 0d 0f 00 00       	call   c010647f <check_boot_pgdir>

    print_pgdir();
c0105572:	e8 95 13 00 00       	call   c010690c <print_pgdir>
    
    kmalloc_init();
c0105577:	e8 e6 f2 ff ff       	call   c0104862 <kmalloc_init>

}
c010557c:	c9                   	leave  
c010557d:	c3                   	ret    

c010557e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010557e:	55                   	push   %ebp
c010557f:	89 e5                	mov    %esp,%ebp
c0105581:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0105584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105587:	c1 e8 16             	shr    $0x16,%eax
c010558a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105591:	8b 45 08             	mov    0x8(%ebp),%eax
c0105594:	01 d0                	add    %edx,%eax
c0105596:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0105599:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010559c:	8b 00                	mov    (%eax),%eax
c010559e:	83 e0 01             	and    $0x1,%eax
c01055a1:	85 c0                	test   %eax,%eax
c01055a3:	0f 85 b9 00 00 00    	jne    c0105662 <get_pte+0xe4>
        if (!create) return 0;
c01055a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01055ad:	75 0a                	jne    c01055b9 <get_pte+0x3b>
c01055af:	b8 00 00 00 00       	mov    $0x0,%eax
c01055b4:	e9 05 01 00 00       	jmp    c01056be <get_pte+0x140>
        struct Page *new_page = alloc_page();
c01055b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055c0:	e8 52 f8 ff ff       	call   c0104e17 <alloc_pages>
c01055c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (!new_page) return 0;
c01055c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055cc:	75 0a                	jne    c01055d8 <get_pte+0x5a>
c01055ce:	b8 00 00 00 00       	mov    $0x0,%eax
c01055d3:	e9 e6 00 00 00       	jmp    c01056be <get_pte+0x140>
        set_page_ref(new_page, 1);
c01055d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01055df:	00 
c01055e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055e3:	89 04 24             	mov    %eax,(%esp)
c01055e6:	e8 31 f6 ff ff       	call   c0104c1c <set_page_ref>
        uintptr_t pa = page2pa(new_page);
c01055eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055ee:	89 04 24             	mov    %eax,(%esp)
c01055f1:	e8 17 f5 ff ff       	call   c0104b0d <page2pa>
c01055f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01055f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105602:	c1 e8 0c             	shr    $0xc,%eax
c0105605:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105608:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c010560d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105610:	72 23                	jb     c0105635 <get_pte+0xb7>
c0105612:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105615:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105619:	c7 44 24 08 6c cc 10 	movl   $0xc010cc6c,0x8(%esp)
c0105620:	c0 
c0105621:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0105628:	00 
c0105629:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105630:	e8 a5 b7 ff ff       	call   c0100dda <__panic>
c0105635:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105638:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010563d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105644:	00 
c0105645:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010564c:	00 
c010564d:	89 04 24             	mov    %eax,(%esp)
c0105650:	e8 c4 66 00 00       	call   c010bd19 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0105655:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105658:	83 c8 07             	or     $0x7,%eax
c010565b:	89 c2                	mov    %eax,%edx
c010565d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105660:	89 10                	mov    %edx,(%eax)
    }
    return (pte_t *)KADDR(PDE_ADDR(*pdep)) + PTX(la);
c0105662:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105665:	8b 00                	mov    (%eax),%eax
c0105667:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010566c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010566f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105672:	c1 e8 0c             	shr    $0xc,%eax
c0105675:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105678:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c010567d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0105680:	72 23                	jb     c01056a5 <get_pte+0x127>
c0105682:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105685:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105689:	c7 44 24 08 6c cc 10 	movl   $0xc010cc6c,0x8(%esp)
c0105690:	c0 
c0105691:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c0105698:	00 
c0105699:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01056a0:	e8 35 b7 ff ff       	call   c0100dda <__panic>
c01056a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056a8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01056ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056b0:	c1 ea 0c             	shr    $0xc,%edx
c01056b3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01056b9:	c1 e2 02             	shl    $0x2,%edx
c01056bc:	01 d0                	add    %edx,%eax
}
c01056be:	c9                   	leave  
c01056bf:	c3                   	ret    

c01056c0 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01056c0:	55                   	push   %ebp
c01056c1:	89 e5                	mov    %esp,%ebp
c01056c3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01056c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056cd:	00 
c01056ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d8:	89 04 24             	mov    %eax,(%esp)
c01056db:	e8 9e fe ff ff       	call   c010557e <get_pte>
c01056e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01056e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056e7:	74 08                	je     c01056f1 <get_page+0x31>
        *ptep_store = ptep;
c01056e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01056ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056ef:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01056f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056f5:	74 1b                	je     c0105712 <get_page+0x52>
c01056f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056fa:	8b 00                	mov    (%eax),%eax
c01056fc:	83 e0 01             	and    $0x1,%eax
c01056ff:	85 c0                	test   %eax,%eax
c0105701:	74 0f                	je     c0105712 <get_page+0x52>
        return pte2page(*ptep);
c0105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105706:	8b 00                	mov    (%eax),%eax
c0105708:	89 04 24             	mov    %eax,(%esp)
c010570b:	e8 ac f4 ff ff       	call   c0104bbc <pte2page>
c0105710:	eb 05                	jmp    c0105717 <get_page+0x57>
    }
    return NULL;
c0105712:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105717:	c9                   	leave  
c0105718:	c3                   	ret    

c0105719 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105719:	55                   	push   %ebp
c010571a:	89 e5                	mov    %esp,%ebp
c010571c:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010571f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105722:	8b 00                	mov    (%eax),%eax
c0105724:	83 e0 01             	and    $0x1,%eax
c0105727:	85 c0                	test   %eax,%eax
c0105729:	74 4d                	je     c0105778 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c010572b:	8b 45 10             	mov    0x10(%ebp),%eax
c010572e:	8b 00                	mov    (%eax),%eax
c0105730:	89 04 24             	mov    %eax,(%esp)
c0105733:	e8 84 f4 ff ff       	call   c0104bbc <pte2page>
c0105738:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (!page_ref_dec(page))
c010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010573e:	89 04 24             	mov    %eax,(%esp)
c0105741:	e8 fa f4 ff ff       	call   c0104c40 <page_ref_dec>
c0105746:	85 c0                	test   %eax,%eax
c0105748:	75 13                	jne    c010575d <page_remove_pte+0x44>
            free_page(page);
c010574a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105751:	00 
c0105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105755:	89 04 24             	mov    %eax,(%esp)
c0105758:	e8 25 f7 ff ff       	call   c0104e82 <free_pages>
        *ptep = 0;
c010575d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105766:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105769:	89 44 24 04          	mov    %eax,0x4(%esp)
c010576d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105770:	89 04 24             	mov    %eax,(%esp)
c0105773:	e8 1d 05 00 00       	call   c0105c95 <tlb_invalidate>
    }
}
c0105778:	c9                   	leave  
c0105779:	c3                   	ret    

c010577a <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c010577a:	55                   	push   %ebp
c010577b:	89 e5                	mov    %esp,%ebp
c010577d:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105780:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105783:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105788:	85 c0                	test   %eax,%eax
c010578a:	75 0c                	jne    c0105798 <unmap_range+0x1e>
c010578c:	8b 45 10             	mov    0x10(%ebp),%eax
c010578f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105794:	85 c0                	test   %eax,%eax
c0105796:	74 24                	je     c01057bc <unmap_range+0x42>
c0105798:	c7 44 24 0c 94 cd 10 	movl   $0xc010cd94,0xc(%esp)
c010579f:	c0 
c01057a0:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01057a7:	c0 
c01057a8:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c01057af:	00 
c01057b0:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01057b7:	e8 1e b6 ff ff       	call   c0100dda <__panic>
    assert(USER_ACCESS(start, end));
c01057bc:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01057c3:	76 11                	jbe    c01057d6 <unmap_range+0x5c>
c01057c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c8:	3b 45 10             	cmp    0x10(%ebp),%eax
c01057cb:	73 09                	jae    c01057d6 <unmap_range+0x5c>
c01057cd:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c01057d4:	76 24                	jbe    c01057fa <unmap_range+0x80>
c01057d6:	c7 44 24 0c bd cd 10 	movl   $0xc010cdbd,0xc(%esp)
c01057dd:	c0 
c01057de:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01057e5:	c0 
c01057e6:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
c01057ed:	00 
c01057ee:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01057f5:	e8 e0 b5 ff ff       	call   c0100dda <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c01057fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105801:	00 
c0105802:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105805:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105809:	8b 45 08             	mov    0x8(%ebp),%eax
c010580c:	89 04 24             	mov    %eax,(%esp)
c010580f:	e8 6a fd ff ff       	call   c010557e <get_pte>
c0105814:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010581b:	75 18                	jne    c0105835 <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c010581d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105820:	05 00 00 40 00       	add    $0x400000,%eax
c0105825:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105828:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010582b:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105830:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105833:	eb 29                	jmp    c010585e <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105835:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105838:	8b 00                	mov    (%eax),%eax
c010583a:	85 c0                	test   %eax,%eax
c010583c:	74 19                	je     c0105857 <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c010583e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105841:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105845:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105848:	89 44 24 04          	mov    %eax,0x4(%esp)
c010584c:	8b 45 08             	mov    0x8(%ebp),%eax
c010584f:	89 04 24             	mov    %eax,(%esp)
c0105852:	e8 c2 fe ff ff       	call   c0105719 <page_remove_pte>
        }
        start += PGSIZE;
c0105857:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c010585e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105862:	74 08                	je     c010586c <unmap_range+0xf2>
c0105864:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105867:	3b 45 10             	cmp    0x10(%ebp),%eax
c010586a:	72 8e                	jb     c01057fa <unmap_range+0x80>
}
c010586c:	c9                   	leave  
c010586d:	c3                   	ret    

c010586e <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c010586e:	55                   	push   %ebp
c010586f:	89 e5                	mov    %esp,%ebp
c0105871:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105874:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105877:	25 ff 0f 00 00       	and    $0xfff,%eax
c010587c:	85 c0                	test   %eax,%eax
c010587e:	75 0c                	jne    c010588c <exit_range+0x1e>
c0105880:	8b 45 10             	mov    0x10(%ebp),%eax
c0105883:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105888:	85 c0                	test   %eax,%eax
c010588a:	74 24                	je     c01058b0 <exit_range+0x42>
c010588c:	c7 44 24 0c 94 cd 10 	movl   $0xc010cd94,0xc(%esp)
c0105893:	c0 
c0105894:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010589b:	c0 
c010589c:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01058a3:	00 
c01058a4:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01058ab:	e8 2a b5 ff ff       	call   c0100dda <__panic>
    assert(USER_ACCESS(start, end));
c01058b0:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01058b7:	76 11                	jbe    c01058ca <exit_range+0x5c>
c01058b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058bc:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058bf:	73 09                	jae    c01058ca <exit_range+0x5c>
c01058c1:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c01058c8:	76 24                	jbe    c01058ee <exit_range+0x80>
c01058ca:	c7 44 24 0c bd cd 10 	movl   $0xc010cdbd,0xc(%esp)
c01058d1:	c0 
c01058d2:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01058d9:	c0 
c01058da:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01058e1:	00 
c01058e2:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01058e9:	e8 ec b4 ff ff       	call   c0100dda <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c01058ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058f7:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c01058fc:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c01058ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105902:	c1 e8 16             	shr    $0x16,%eax
c0105905:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105908:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010590b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105912:	8b 45 08             	mov    0x8(%ebp),%eax
c0105915:	01 d0                	add    %edx,%eax
c0105917:	8b 00                	mov    (%eax),%eax
c0105919:	83 e0 01             	and    $0x1,%eax
c010591c:	85 c0                	test   %eax,%eax
c010591e:	74 3e                	je     c010595e <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105920:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105923:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010592a:	8b 45 08             	mov    0x8(%ebp),%eax
c010592d:	01 d0                	add    %edx,%eax
c010592f:	8b 00                	mov    (%eax),%eax
c0105931:	89 04 24             	mov    %eax,(%esp)
c0105934:	e8 c1 f2 ff ff       	call   c0104bfa <pde2page>
c0105939:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105940:	00 
c0105941:	89 04 24             	mov    %eax,(%esp)
c0105944:	e8 39 f5 ff ff       	call   c0104e82 <free_pages>
            pgdir[pde_idx] = 0;
c0105949:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010594c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105953:	8b 45 08             	mov    0x8(%ebp),%eax
c0105956:	01 d0                	add    %edx,%eax
c0105958:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c010595e:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105965:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105969:	74 08                	je     c0105973 <exit_range+0x105>
c010596b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010596e:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105971:	72 8c                	jb     c01058ff <exit_range+0x91>
}
c0105973:	c9                   	leave  
c0105974:	c3                   	ret    

c0105975 <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105975:	55                   	push   %ebp
c0105976:	89 e5                	mov    %esp,%ebp
c0105978:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c010597b:	8b 45 10             	mov    0x10(%ebp),%eax
c010597e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105983:	85 c0                	test   %eax,%eax
c0105985:	75 0c                	jne    c0105993 <copy_range+0x1e>
c0105987:	8b 45 14             	mov    0x14(%ebp),%eax
c010598a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010598f:	85 c0                	test   %eax,%eax
c0105991:	74 24                	je     c01059b7 <copy_range+0x42>
c0105993:	c7 44 24 0c 94 cd 10 	movl   $0xc010cd94,0xc(%esp)
c010599a:	c0 
c010599b:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01059a2:	c0 
c01059a3:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01059aa:	00 
c01059ab:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01059b2:	e8 23 b4 ff ff       	call   c0100dda <__panic>
    assert(USER_ACCESS(start, end));
c01059b7:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c01059be:	76 11                	jbe    c01059d1 <copy_range+0x5c>
c01059c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c3:	3b 45 14             	cmp    0x14(%ebp),%eax
c01059c6:	73 09                	jae    c01059d1 <copy_range+0x5c>
c01059c8:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c01059cf:	76 24                	jbe    c01059f5 <copy_range+0x80>
c01059d1:	c7 44 24 0c bd cd 10 	movl   $0xc010cdbd,0xc(%esp)
c01059d8:	c0 
c01059d9:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01059e0:	c0 
c01059e1:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c01059e8:	00 
c01059e9:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01059f0:	e8 e5 b3 ff ff       	call   c0100dda <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c01059f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059fc:	00 
c01059fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a07:	89 04 24             	mov    %eax,(%esp)
c0105a0a:	e8 6f fb ff ff       	call   c010557e <get_pte>
c0105a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a16:	75 1b                	jne    c0105a33 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105a18:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a1b:	05 00 00 40 00       	add    $0x400000,%eax
c0105a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a26:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105a2b:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105a2e:	e9 4c 01 00 00       	jmp    c0105b7f <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a36:	8b 00                	mov    (%eax),%eax
c0105a38:	83 e0 01             	and    $0x1,%eax
c0105a3b:	85 c0                	test   %eax,%eax
c0105a3d:	0f 84 35 01 00 00    	je     c0105b78 <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105a43:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105a4a:	00 
c0105a4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a52:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a55:	89 04 24             	mov    %eax,(%esp)
c0105a58:	e8 21 fb ff ff       	call   c010557e <get_pte>
c0105a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105a64:	75 0a                	jne    c0105a70 <copy_range+0xfb>
                return -E_NO_MEM;
c0105a66:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105a6b:	e9 26 01 00 00       	jmp    c0105b96 <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a73:	8b 00                	mov    (%eax),%eax
c0105a75:	83 e0 07             	and    $0x7,%eax
c0105a78:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a7e:	8b 00                	mov    (%eax),%eax
c0105a80:	89 04 24             	mov    %eax,(%esp)
c0105a83:	e8 34 f1 ff ff       	call   c0104bbc <pte2page>
c0105a88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105a8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105a92:	e8 80 f3 ff ff       	call   c0104e17 <alloc_pages>
c0105a97:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105a9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105a9e:	75 24                	jne    c0105ac4 <copy_range+0x14f>
c0105aa0:	c7 44 24 0c d5 cd 10 	movl   $0xc010cdd5,0xc(%esp)
c0105aa7:	c0 
c0105aa8:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105aaf:	c0 
c0105ab0:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105ab7:	00 
c0105ab8:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105abf:	e8 16 b3 ff ff       	call   c0100dda <__panic>
        assert(npage!=NULL);
c0105ac4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105ac8:	75 24                	jne    c0105aee <copy_range+0x179>
c0105aca:	c7 44 24 0c e0 cd 10 	movl   $0xc010cde0,0xc(%esp)
c0105ad1:	c0 
c0105ad2:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105ad9:	c0 
c0105ada:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105ae1:	00 
c0105ae2:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105ae9:	e8 ec b2 ff ff       	call   c0100dda <__panic>
        int ret=0;
c0105aee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        void *src_kvaddr = page2kva(page);
c0105af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105af8:	89 04 24             	mov    %eax,(%esp)
c0105afb:	e8 68 f0 ff ff       	call   c0104b68 <page2kva>
c0105b00:	89 45 d8             	mov    %eax,-0x28(%ebp)
        void *dst_kvaddr = page2kva(npage);
c0105b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b06:	89 04 24             	mov    %eax,(%esp)
c0105b09:	e8 5a f0 ff ff       	call   c0104b68 <page2kva>
c0105b0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105b11:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b18:	00 
c0105b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b23:	89 04 24             	mov    %eax,(%esp)
c0105b26:	e8 d0 62 00 00       	call   c010bdfb <memcpy>
        ret = page_insert(to, npage, start, perm);
c0105b2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b32:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b35:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b43:	89 04 24             	mov    %eax,(%esp)
c0105b46:	e8 91 00 00 00       	call   c0105bdc <page_insert>
c0105b4b:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(ret == 0);
c0105b4e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105b52:	74 24                	je     c0105b78 <copy_range+0x203>
c0105b54:	c7 44 24 0c ec cd 10 	movl   $0xc010cdec,0xc(%esp)
c0105b5b:	c0 
c0105b5c:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105b63:	c0 
c0105b64:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105b6b:	00 
c0105b6c:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105b73:	e8 62 b2 ff ff       	call   c0100dda <__panic>
        }
        start += PGSIZE;
c0105b78:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105b7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b83:	74 0c                	je     c0105b91 <copy_range+0x21c>
c0105b85:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b88:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105b8b:	0f 82 64 fe ff ff    	jb     c01059f5 <copy_range+0x80>
    return 0;
c0105b91:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b96:	c9                   	leave  
c0105b97:	c3                   	ret    

c0105b98 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105b98:	55                   	push   %ebp
c0105b99:	89 e5                	mov    %esp,%ebp
c0105b9b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105b9e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ba5:	00 
c0105ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb0:	89 04 24             	mov    %eax,(%esp)
c0105bb3:	e8 c6 f9 ff ff       	call   c010557e <get_pte>
c0105bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105bbf:	74 19                	je     c0105bda <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd2:	89 04 24             	mov    %eax,(%esp)
c0105bd5:	e8 3f fb ff ff       	call   c0105719 <page_remove_pte>
    }
}
c0105bda:	c9                   	leave  
c0105bdb:	c3                   	ret    

c0105bdc <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105bdc:	55                   	push   %ebp
c0105bdd:	89 e5                	mov    %esp,%ebp
c0105bdf:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105be2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105be9:	00 
c0105bea:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bed:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf4:	89 04 24             	mov    %eax,(%esp)
c0105bf7:	e8 82 f9 ff ff       	call   c010557e <get_pte>
c0105bfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105bff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c03:	75 0a                	jne    c0105c0f <page_insert+0x33>
        return -E_NO_MEM;
c0105c05:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105c0a:	e9 84 00 00 00       	jmp    c0105c93 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c12:	89 04 24             	mov    %eax,(%esp)
c0105c15:	e8 0f f0 ff ff       	call   c0104c29 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c1d:	8b 00                	mov    (%eax),%eax
c0105c1f:	83 e0 01             	and    $0x1,%eax
c0105c22:	85 c0                	test   %eax,%eax
c0105c24:	74 3e                	je     c0105c64 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c29:	8b 00                	mov    (%eax),%eax
c0105c2b:	89 04 24             	mov    %eax,(%esp)
c0105c2e:	e8 89 ef ff ff       	call   c0104bbc <pte2page>
c0105c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c39:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c3c:	75 0d                	jne    c0105c4b <page_insert+0x6f>
            page_ref_dec(page);
c0105c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c41:	89 04 24             	mov    %eax,(%esp)
c0105c44:	e8 f7 ef ff ff       	call   c0104c40 <page_ref_dec>
c0105c49:	eb 19                	jmp    c0105c64 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c52:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c59:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5c:	89 04 24             	mov    %eax,(%esp)
c0105c5f:	e8 b5 fa ff ff       	call   c0105719 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105c64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c67:	89 04 24             	mov    %eax,(%esp)
c0105c6a:	e8 9e ee ff ff       	call   c0104b0d <page2pa>
c0105c6f:	0b 45 14             	or     0x14(%ebp),%eax
c0105c72:	83 c8 01             	or     $0x1,%eax
c0105c75:	89 c2                	mov    %eax,%edx
c0105c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c7a:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105c7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c86:	89 04 24             	mov    %eax,(%esp)
c0105c89:	e8 07 00 00 00       	call   c0105c95 <tlb_invalidate>
    return 0;
c0105c8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c93:	c9                   	leave  
c0105c94:	c3                   	ret    

c0105c95 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105c95:	55                   	push   %ebp
c0105c96:	89 e5                	mov    %esp,%ebp
c0105c98:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105c9b:	0f 20 d8             	mov    %cr3,%eax
c0105c9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105ca4:	89 c2                	mov    %eax,%edx
c0105ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cac:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105cb3:	77 23                	ja     c0105cd8 <tlb_invalidate+0x43>
c0105cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105cbc:	c7 44 24 08 10 cd 10 	movl   $0xc010cd10,0x8(%esp)
c0105cc3:	c0 
c0105cc4:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0105ccb:	00 
c0105ccc:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105cd3:	e8 02 b1 ff ff       	call   c0100dda <__panic>
c0105cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cdb:	05 00 00 00 40       	add    $0x40000000,%eax
c0105ce0:	39 c2                	cmp    %eax,%edx
c0105ce2:	75 0c                	jne    c0105cf0 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ce7:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105cea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ced:	0f 01 38             	invlpg (%eax)
    }
}
c0105cf0:	c9                   	leave  
c0105cf1:	c3                   	ret    

c0105cf2 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105cf2:	55                   	push   %ebp
c0105cf3:	89 e5                	mov    %esp,%ebp
c0105cf5:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105cf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105cff:	e8 13 f1 ff ff       	call   c0104e17 <alloc_pages>
c0105d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d0b:	0f 84 b0 00 00 00    	je     c0105dc1 <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105d11:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d14:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d1b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d29:	89 04 24             	mov    %eax,(%esp)
c0105d2c:	e8 ab fe ff ff       	call   c0105bdc <page_insert>
c0105d31:	85 c0                	test   %eax,%eax
c0105d33:	74 1a                	je     c0105d4f <pgdir_alloc_page+0x5d>
            free_page(page);
c0105d35:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d3c:	00 
c0105d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d40:	89 04 24             	mov    %eax,(%esp)
c0105d43:	e8 3a f1 ff ff       	call   c0104e82 <free_pages>
            return NULL;
c0105d48:	b8 00 00 00 00       	mov    $0x0,%eax
c0105d4d:	eb 75                	jmp    c0105dc4 <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0105d4f:	a1 0c ee 1a c0       	mov    0xc01aee0c,%eax
c0105d54:	85 c0                	test   %eax,%eax
c0105d56:	74 69                	je     c0105dc1 <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c0105d58:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c0105d5d:	85 c0                	test   %eax,%eax
c0105d5f:	74 60                	je     c0105dc1 <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0105d61:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c0105d66:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105d6d:	00 
c0105d6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d71:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105d75:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d78:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d7c:	89 04 24             	mov    %eax,(%esp)
c0105d7f:	e8 51 0e 00 00       	call   c0106bd5 <swap_map_swappable>
                page->pra_vaddr=la;
c0105d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d87:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d8a:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c0105d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d90:	89 04 24             	mov    %eax,(%esp)
c0105d93:	e8 7a ee ff ff       	call   c0104c12 <page_ref>
c0105d98:	83 f8 01             	cmp    $0x1,%eax
c0105d9b:	74 24                	je     c0105dc1 <pgdir_alloc_page+0xcf>
c0105d9d:	c7 44 24 0c f5 cd 10 	movl   $0xc010cdf5,0xc(%esp)
c0105da4:	c0 
c0105da5:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105dac:	c0 
c0105dad:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0105db4:	00 
c0105db5:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105dbc:	e8 19 b0 ff ff       	call   c0100dda <__panic>
            }
        }

    }

    return page;
c0105dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105dc4:	c9                   	leave  
c0105dc5:	c3                   	ret    

c0105dc6 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105dc6:	55                   	push   %ebp
c0105dc7:	89 e5                	mov    %esp,%ebp
c0105dc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105dcc:	a1 88 0e 1b c0       	mov    0xc01b0e88,%eax
c0105dd1:	8b 40 18             	mov    0x18(%eax),%eax
c0105dd4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105dd6:	c7 04 24 0c ce 10 c0 	movl   $0xc010ce0c,(%esp)
c0105ddd:	e8 76 a5 ff ff       	call   c0100358 <cprintf>
}
c0105de2:	c9                   	leave  
c0105de3:	c3                   	ret    

c0105de4 <check_pgdir>:

static void
check_pgdir(void) {
c0105de4:	55                   	push   %ebp
c0105de5:	89 e5                	mov    %esp,%ebp
c0105de7:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105dea:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0105def:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105df4:	76 24                	jbe    c0105e1a <check_pgdir+0x36>
c0105df6:	c7 44 24 0c 2b ce 10 	movl   $0xc010ce2b,0xc(%esp)
c0105dfd:	c0 
c0105dfe:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105e05:	c0 
c0105e06:	c7 44 24 04 80 02 00 	movl   $0x280,0x4(%esp)
c0105e0d:	00 
c0105e0e:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105e15:	e8 c0 af ff ff       	call   c0100dda <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105e1a:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105e1f:	85 c0                	test   %eax,%eax
c0105e21:	74 0e                	je     c0105e31 <check_pgdir+0x4d>
c0105e23:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105e28:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105e2d:	85 c0                	test   %eax,%eax
c0105e2f:	74 24                	je     c0105e55 <check_pgdir+0x71>
c0105e31:	c7 44 24 0c 48 ce 10 	movl   $0xc010ce48,0xc(%esp)
c0105e38:	c0 
c0105e39:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105e40:	c0 
c0105e41:	c7 44 24 04 81 02 00 	movl   $0x281,0x4(%esp)
c0105e48:	00 
c0105e49:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105e50:	e8 85 af ff ff       	call   c0100dda <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105e55:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105e61:	00 
c0105e62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105e69:	00 
c0105e6a:	89 04 24             	mov    %eax,(%esp)
c0105e6d:	e8 4e f8 ff ff       	call   c01056c0 <get_page>
c0105e72:	85 c0                	test   %eax,%eax
c0105e74:	74 24                	je     c0105e9a <check_pgdir+0xb6>
c0105e76:	c7 44 24 0c 80 ce 10 	movl   $0xc010ce80,0xc(%esp)
c0105e7d:	c0 
c0105e7e:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105e85:	c0 
c0105e86:	c7 44 24 04 82 02 00 	movl   $0x282,0x4(%esp)
c0105e8d:	00 
c0105e8e:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105e95:	e8 40 af ff ff       	call   c0100dda <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105e9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ea1:	e8 71 ef ff ff       	call   c0104e17 <alloc_pages>
c0105ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105ea9:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105eae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105eb5:	00 
c0105eb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ebd:	00 
c0105ebe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ec5:	89 04 24             	mov    %eax,(%esp)
c0105ec8:	e8 0f fd ff ff       	call   c0105bdc <page_insert>
c0105ecd:	85 c0                	test   %eax,%eax
c0105ecf:	74 24                	je     c0105ef5 <check_pgdir+0x111>
c0105ed1:	c7 44 24 0c a8 ce 10 	movl   $0xc010cea8,0xc(%esp)
c0105ed8:	c0 
c0105ed9:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105ee0:	c0 
c0105ee1:	c7 44 24 04 86 02 00 	movl   $0x286,0x4(%esp)
c0105ee8:	00 
c0105ee9:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105ef0:	e8 e5 ae ff ff       	call   c0100dda <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105ef5:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105efa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105f01:	00 
c0105f02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105f09:	00 
c0105f0a:	89 04 24             	mov    %eax,(%esp)
c0105f0d:	e8 6c f6 ff ff       	call   c010557e <get_pte>
c0105f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f19:	75 24                	jne    c0105f3f <check_pgdir+0x15b>
c0105f1b:	c7 44 24 0c d4 ce 10 	movl   $0xc010ced4,0xc(%esp)
c0105f22:	c0 
c0105f23:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105f2a:	c0 
c0105f2b:	c7 44 24 04 89 02 00 	movl   $0x289,0x4(%esp)
c0105f32:	00 
c0105f33:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105f3a:	e8 9b ae ff ff       	call   c0100dda <__panic>
    assert(pte2page(*ptep) == p1);
c0105f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f42:	8b 00                	mov    (%eax),%eax
c0105f44:	89 04 24             	mov    %eax,(%esp)
c0105f47:	e8 70 ec ff ff       	call   c0104bbc <pte2page>
c0105f4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105f4f:	74 24                	je     c0105f75 <check_pgdir+0x191>
c0105f51:	c7 44 24 0c 01 cf 10 	movl   $0xc010cf01,0xc(%esp)
c0105f58:	c0 
c0105f59:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105f60:	c0 
c0105f61:	c7 44 24 04 8a 02 00 	movl   $0x28a,0x4(%esp)
c0105f68:	00 
c0105f69:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105f70:	e8 65 ae ff ff       	call   c0100dda <__panic>
    assert(page_ref(p1) == 1);
c0105f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f78:	89 04 24             	mov    %eax,(%esp)
c0105f7b:	e8 92 ec ff ff       	call   c0104c12 <page_ref>
c0105f80:	83 f8 01             	cmp    $0x1,%eax
c0105f83:	74 24                	je     c0105fa9 <check_pgdir+0x1c5>
c0105f85:	c7 44 24 0c 17 cf 10 	movl   $0xc010cf17,0xc(%esp)
c0105f8c:	c0 
c0105f8d:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0105f94:	c0 
c0105f95:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
c0105f9c:	00 
c0105f9d:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105fa4:	e8 31 ae ff ff       	call   c0100dda <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105fa9:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0105fae:	8b 00                	mov    (%eax),%eax
c0105fb0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105fb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fbb:	c1 e8 0c             	shr    $0xc,%eax
c0105fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105fc1:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0105fc6:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105fc9:	72 23                	jb     c0105fee <check_pgdir+0x20a>
c0105fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105fce:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fd2:	c7 44 24 08 6c cc 10 	movl   $0xc010cc6c,0x8(%esp)
c0105fd9:	c0 
c0105fda:	c7 44 24 04 8d 02 00 	movl   $0x28d,0x4(%esp)
c0105fe1:	00 
c0105fe2:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0105fe9:	e8 ec ad ff ff       	call   c0100dda <__panic>
c0105fee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ff1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105ff6:	83 c0 04             	add    $0x4,%eax
c0105ff9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105ffc:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106001:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106008:	00 
c0106009:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106010:	00 
c0106011:	89 04 24             	mov    %eax,(%esp)
c0106014:	e8 65 f5 ff ff       	call   c010557e <get_pte>
c0106019:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010601c:	74 24                	je     c0106042 <check_pgdir+0x25e>
c010601e:	c7 44 24 0c 2c cf 10 	movl   $0xc010cf2c,0xc(%esp)
c0106025:	c0 
c0106026:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010602d:	c0 
c010602e:	c7 44 24 04 8e 02 00 	movl   $0x28e,0x4(%esp)
c0106035:	00 
c0106036:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010603d:	e8 98 ad ff ff       	call   c0100dda <__panic>

    p2 = alloc_page();
c0106042:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106049:	e8 c9 ed ff ff       	call   c0104e17 <alloc_pages>
c010604e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106051:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106056:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010605d:	00 
c010605e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0106065:	00 
c0106066:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106069:	89 54 24 04          	mov    %edx,0x4(%esp)
c010606d:	89 04 24             	mov    %eax,(%esp)
c0106070:	e8 67 fb ff ff       	call   c0105bdc <page_insert>
c0106075:	85 c0                	test   %eax,%eax
c0106077:	74 24                	je     c010609d <check_pgdir+0x2b9>
c0106079:	c7 44 24 0c 54 cf 10 	movl   $0xc010cf54,0xc(%esp)
c0106080:	c0 
c0106081:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106088:	c0 
c0106089:	c7 44 24 04 91 02 00 	movl   $0x291,0x4(%esp)
c0106090:	00 
c0106091:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106098:	e8 3d ad ff ff       	call   c0100dda <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010609d:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01060a2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01060a9:	00 
c01060aa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01060b1:	00 
c01060b2:	89 04 24             	mov    %eax,(%esp)
c01060b5:	e8 c4 f4 ff ff       	call   c010557e <get_pte>
c01060ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01060bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01060c1:	75 24                	jne    c01060e7 <check_pgdir+0x303>
c01060c3:	c7 44 24 0c 8c cf 10 	movl   $0xc010cf8c,0xc(%esp)
c01060ca:	c0 
c01060cb:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01060d2:	c0 
c01060d3:	c7 44 24 04 92 02 00 	movl   $0x292,0x4(%esp)
c01060da:	00 
c01060db:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01060e2:	e8 f3 ac ff ff       	call   c0100dda <__panic>
    assert(*ptep & PTE_U);
c01060e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01060ea:	8b 00                	mov    (%eax),%eax
c01060ec:	83 e0 04             	and    $0x4,%eax
c01060ef:	85 c0                	test   %eax,%eax
c01060f1:	75 24                	jne    c0106117 <check_pgdir+0x333>
c01060f3:	c7 44 24 0c bc cf 10 	movl   $0xc010cfbc,0xc(%esp)
c01060fa:	c0 
c01060fb:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106102:	c0 
c0106103:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c010610a:	00 
c010610b:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106112:	e8 c3 ac ff ff       	call   c0100dda <__panic>
    assert(*ptep & PTE_W);
c0106117:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010611a:	8b 00                	mov    (%eax),%eax
c010611c:	83 e0 02             	and    $0x2,%eax
c010611f:	85 c0                	test   %eax,%eax
c0106121:	75 24                	jne    c0106147 <check_pgdir+0x363>
c0106123:	c7 44 24 0c ca cf 10 	movl   $0xc010cfca,0xc(%esp)
c010612a:	c0 
c010612b:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106132:	c0 
c0106133:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c010613a:	00 
c010613b:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106142:	e8 93 ac ff ff       	call   c0100dda <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0106147:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010614c:	8b 00                	mov    (%eax),%eax
c010614e:	83 e0 04             	and    $0x4,%eax
c0106151:	85 c0                	test   %eax,%eax
c0106153:	75 24                	jne    c0106179 <check_pgdir+0x395>
c0106155:	c7 44 24 0c d8 cf 10 	movl   $0xc010cfd8,0xc(%esp)
c010615c:	c0 
c010615d:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106164:	c0 
c0106165:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c010616c:	00 
c010616d:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106174:	e8 61 ac ff ff       	call   c0100dda <__panic>
    assert(page_ref(p2) == 1);
c0106179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010617c:	89 04 24             	mov    %eax,(%esp)
c010617f:	e8 8e ea ff ff       	call   c0104c12 <page_ref>
c0106184:	83 f8 01             	cmp    $0x1,%eax
c0106187:	74 24                	je     c01061ad <check_pgdir+0x3c9>
c0106189:	c7 44 24 0c ee cf 10 	movl   $0xc010cfee,0xc(%esp)
c0106190:	c0 
c0106191:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106198:	c0 
c0106199:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c01061a0:	00 
c01061a1:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01061a8:	e8 2d ac ff ff       	call   c0100dda <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01061ad:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01061b2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01061b9:	00 
c01061ba:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01061c1:	00 
c01061c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061c9:	89 04 24             	mov    %eax,(%esp)
c01061cc:	e8 0b fa ff ff       	call   c0105bdc <page_insert>
c01061d1:	85 c0                	test   %eax,%eax
c01061d3:	74 24                	je     c01061f9 <check_pgdir+0x415>
c01061d5:	c7 44 24 0c 00 d0 10 	movl   $0xc010d000,0xc(%esp)
c01061dc:	c0 
c01061dd:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01061e4:	c0 
c01061e5:	c7 44 24 04 98 02 00 	movl   $0x298,0x4(%esp)
c01061ec:	00 
c01061ed:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01061f4:	e8 e1 ab ff ff       	call   c0100dda <__panic>
    assert(page_ref(p1) == 2);
c01061f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061fc:	89 04 24             	mov    %eax,(%esp)
c01061ff:	e8 0e ea ff ff       	call   c0104c12 <page_ref>
c0106204:	83 f8 02             	cmp    $0x2,%eax
c0106207:	74 24                	je     c010622d <check_pgdir+0x449>
c0106209:	c7 44 24 0c 2c d0 10 	movl   $0xc010d02c,0xc(%esp)
c0106210:	c0 
c0106211:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106218:	c0 
c0106219:	c7 44 24 04 99 02 00 	movl   $0x299,0x4(%esp)
c0106220:	00 
c0106221:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106228:	e8 ad ab ff ff       	call   c0100dda <__panic>
    assert(page_ref(p2) == 0);
c010622d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106230:	89 04 24             	mov    %eax,(%esp)
c0106233:	e8 da e9 ff ff       	call   c0104c12 <page_ref>
c0106238:	85 c0                	test   %eax,%eax
c010623a:	74 24                	je     c0106260 <check_pgdir+0x47c>
c010623c:	c7 44 24 0c 3e d0 10 	movl   $0xc010d03e,0xc(%esp)
c0106243:	c0 
c0106244:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010624b:	c0 
c010624c:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c0106253:	00 
c0106254:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010625b:	e8 7a ab ff ff       	call   c0100dda <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106260:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106265:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010626c:	00 
c010626d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106274:	00 
c0106275:	89 04 24             	mov    %eax,(%esp)
c0106278:	e8 01 f3 ff ff       	call   c010557e <get_pte>
c010627d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106284:	75 24                	jne    c01062aa <check_pgdir+0x4c6>
c0106286:	c7 44 24 0c 8c cf 10 	movl   $0xc010cf8c,0xc(%esp)
c010628d:	c0 
c010628e:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106295:	c0 
c0106296:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c010629d:	00 
c010629e:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01062a5:	e8 30 ab ff ff       	call   c0100dda <__panic>
    assert(pte2page(*ptep) == p1);
c01062aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062ad:	8b 00                	mov    (%eax),%eax
c01062af:	89 04 24             	mov    %eax,(%esp)
c01062b2:	e8 05 e9 ff ff       	call   c0104bbc <pte2page>
c01062b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01062ba:	74 24                	je     c01062e0 <check_pgdir+0x4fc>
c01062bc:	c7 44 24 0c 01 cf 10 	movl   $0xc010cf01,0xc(%esp)
c01062c3:	c0 
c01062c4:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01062cb:	c0 
c01062cc:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c01062d3:	00 
c01062d4:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01062db:	e8 fa aa ff ff       	call   c0100dda <__panic>
    assert((*ptep & PTE_U) == 0);
c01062e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062e3:	8b 00                	mov    (%eax),%eax
c01062e5:	83 e0 04             	and    $0x4,%eax
c01062e8:	85 c0                	test   %eax,%eax
c01062ea:	74 24                	je     c0106310 <check_pgdir+0x52c>
c01062ec:	c7 44 24 0c 50 d0 10 	movl   $0xc010d050,0xc(%esp)
c01062f3:	c0 
c01062f4:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01062fb:	c0 
c01062fc:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c0106303:	00 
c0106304:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010630b:	e8 ca aa ff ff       	call   c0100dda <__panic>

    page_remove(boot_pgdir, 0x0);
c0106310:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106315:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010631c:	00 
c010631d:	89 04 24             	mov    %eax,(%esp)
c0106320:	e8 73 f8 ff ff       	call   c0105b98 <page_remove>
    assert(page_ref(p1) == 1);
c0106325:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106328:	89 04 24             	mov    %eax,(%esp)
c010632b:	e8 e2 e8 ff ff       	call   c0104c12 <page_ref>
c0106330:	83 f8 01             	cmp    $0x1,%eax
c0106333:	74 24                	je     c0106359 <check_pgdir+0x575>
c0106335:	c7 44 24 0c 17 cf 10 	movl   $0xc010cf17,0xc(%esp)
c010633c:	c0 
c010633d:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106344:	c0 
c0106345:	c7 44 24 04 a0 02 00 	movl   $0x2a0,0x4(%esp)
c010634c:	00 
c010634d:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106354:	e8 81 aa ff ff       	call   c0100dda <__panic>
    assert(page_ref(p2) == 0);
c0106359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010635c:	89 04 24             	mov    %eax,(%esp)
c010635f:	e8 ae e8 ff ff       	call   c0104c12 <page_ref>
c0106364:	85 c0                	test   %eax,%eax
c0106366:	74 24                	je     c010638c <check_pgdir+0x5a8>
c0106368:	c7 44 24 0c 3e d0 10 	movl   $0xc010d03e,0xc(%esp)
c010636f:	c0 
c0106370:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106377:	c0 
c0106378:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c010637f:	00 
c0106380:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106387:	e8 4e aa ff ff       	call   c0100dda <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010638c:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106391:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106398:	00 
c0106399:	89 04 24             	mov    %eax,(%esp)
c010639c:	e8 f7 f7 ff ff       	call   c0105b98 <page_remove>
    assert(page_ref(p1) == 0);
c01063a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063a4:	89 04 24             	mov    %eax,(%esp)
c01063a7:	e8 66 e8 ff ff       	call   c0104c12 <page_ref>
c01063ac:	85 c0                	test   %eax,%eax
c01063ae:	74 24                	je     c01063d4 <check_pgdir+0x5f0>
c01063b0:	c7 44 24 0c 65 d0 10 	movl   $0xc010d065,0xc(%esp)
c01063b7:	c0 
c01063b8:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01063bf:	c0 
c01063c0:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c01063c7:	00 
c01063c8:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01063cf:	e8 06 aa ff ff       	call   c0100dda <__panic>
    assert(page_ref(p2) == 0);
c01063d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063d7:	89 04 24             	mov    %eax,(%esp)
c01063da:	e8 33 e8 ff ff       	call   c0104c12 <page_ref>
c01063df:	85 c0                	test   %eax,%eax
c01063e1:	74 24                	je     c0106407 <check_pgdir+0x623>
c01063e3:	c7 44 24 0c 3e d0 10 	movl   $0xc010d03e,0xc(%esp)
c01063ea:	c0 
c01063eb:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01063f2:	c0 
c01063f3:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c01063fa:	00 
c01063fb:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106402:	e8 d3 a9 ff ff       	call   c0100dda <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0106407:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010640c:	8b 00                	mov    (%eax),%eax
c010640e:	89 04 24             	mov    %eax,(%esp)
c0106411:	e8 e4 e7 ff ff       	call   c0104bfa <pde2page>
c0106416:	89 04 24             	mov    %eax,(%esp)
c0106419:	e8 f4 e7 ff ff       	call   c0104c12 <page_ref>
c010641e:	83 f8 01             	cmp    $0x1,%eax
c0106421:	74 24                	je     c0106447 <check_pgdir+0x663>
c0106423:	c7 44 24 0c 78 d0 10 	movl   $0xc010d078,0xc(%esp)
c010642a:	c0 
c010642b:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106432:	c0 
c0106433:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c010643a:	00 
c010643b:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106442:	e8 93 a9 ff ff       	call   c0100dda <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0106447:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010644c:	8b 00                	mov    (%eax),%eax
c010644e:	89 04 24             	mov    %eax,(%esp)
c0106451:	e8 a4 e7 ff ff       	call   c0104bfa <pde2page>
c0106456:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010645d:	00 
c010645e:	89 04 24             	mov    %eax,(%esp)
c0106461:	e8 1c ea ff ff       	call   c0104e82 <free_pages>
    boot_pgdir[0] = 0;
c0106466:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c010646b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106471:	c7 04 24 9f d0 10 c0 	movl   $0xc010d09f,(%esp)
c0106478:	e8 db 9e ff ff       	call   c0100358 <cprintf>
}
c010647d:	c9                   	leave  
c010647e:	c3                   	ret    

c010647f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010647f:	55                   	push   %ebp
c0106480:	89 e5                	mov    %esp,%ebp
c0106482:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106485:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010648c:	e9 ca 00 00 00       	jmp    c010655b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0106491:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106494:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106497:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010649a:	c1 e8 0c             	shr    $0xc,%eax
c010649d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01064a0:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c01064a5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01064a8:	72 23                	jb     c01064cd <check_boot_pgdir+0x4e>
c01064aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01064b1:	c7 44 24 08 6c cc 10 	movl   $0xc010cc6c,0x8(%esp)
c01064b8:	c0 
c01064b9:	c7 44 24 04 b3 02 00 	movl   $0x2b3,0x4(%esp)
c01064c0:	00 
c01064c1:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01064c8:	e8 0d a9 ff ff       	call   c0100dda <__panic>
c01064cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064d0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01064d5:	89 c2                	mov    %eax,%edx
c01064d7:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01064dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01064e3:	00 
c01064e4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064e8:	89 04 24             	mov    %eax,(%esp)
c01064eb:	e8 8e f0 ff ff       	call   c010557e <get_pte>
c01064f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01064f3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01064f7:	75 24                	jne    c010651d <check_boot_pgdir+0x9e>
c01064f9:	c7 44 24 0c bc d0 10 	movl   $0xc010d0bc,0xc(%esp)
c0106500:	c0 
c0106501:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106508:	c0 
c0106509:	c7 44 24 04 b3 02 00 	movl   $0x2b3,0x4(%esp)
c0106510:	00 
c0106511:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106518:	e8 bd a8 ff ff       	call   c0100dda <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010651d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106520:	8b 00                	mov    (%eax),%eax
c0106522:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106527:	89 c2                	mov    %eax,%edx
c0106529:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010652c:	39 c2                	cmp    %eax,%edx
c010652e:	74 24                	je     c0106554 <check_boot_pgdir+0xd5>
c0106530:	c7 44 24 0c f9 d0 10 	movl   $0xc010d0f9,0xc(%esp)
c0106537:	c0 
c0106538:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010653f:	c0 
c0106540:	c7 44 24 04 b4 02 00 	movl   $0x2b4,0x4(%esp)
c0106547:	00 
c0106548:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010654f:	e8 86 a8 ff ff       	call   c0100dda <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106554:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c010655b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010655e:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0106563:	39 c2                	cmp    %eax,%edx
c0106565:	0f 82 26 ff ff ff    	jb     c0106491 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c010656b:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106570:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106575:	8b 00                	mov    (%eax),%eax
c0106577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010657c:	89 c2                	mov    %eax,%edx
c010657e:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106586:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010658d:	77 23                	ja     c01065b2 <check_boot_pgdir+0x133>
c010658f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106592:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106596:	c7 44 24 08 10 cd 10 	movl   $0xc010cd10,0x8(%esp)
c010659d:	c0 
c010659e:	c7 44 24 04 b7 02 00 	movl   $0x2b7,0x4(%esp)
c01065a5:	00 
c01065a6:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01065ad:	e8 28 a8 ff ff       	call   c0100dda <__panic>
c01065b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065b5:	05 00 00 00 40       	add    $0x40000000,%eax
c01065ba:	39 c2                	cmp    %eax,%edx
c01065bc:	74 24                	je     c01065e2 <check_boot_pgdir+0x163>
c01065be:	c7 44 24 0c 10 d1 10 	movl   $0xc010d110,0xc(%esp)
c01065c5:	c0 
c01065c6:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01065cd:	c0 
c01065ce:	c7 44 24 04 b7 02 00 	movl   $0x2b7,0x4(%esp)
c01065d5:	00 
c01065d6:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01065dd:	e8 f8 a7 ff ff       	call   c0100dda <__panic>

    assert(boot_pgdir[0] == 0);
c01065e2:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01065e7:	8b 00                	mov    (%eax),%eax
c01065e9:	85 c0                	test   %eax,%eax
c01065eb:	74 24                	je     c0106611 <check_boot_pgdir+0x192>
c01065ed:	c7 44 24 0c 44 d1 10 	movl   $0xc010d144,0xc(%esp)
c01065f4:	c0 
c01065f5:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01065fc:	c0 
c01065fd:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c0106604:	00 
c0106605:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010660c:	e8 c9 a7 ff ff       	call   c0100dda <__panic>

    struct Page *p;
    p = alloc_page();
c0106611:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106618:	e8 fa e7 ff ff       	call   c0104e17 <alloc_pages>
c010661d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106620:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0106625:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010662c:	00 
c010662d:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0106634:	00 
c0106635:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106638:	89 54 24 04          	mov    %edx,0x4(%esp)
c010663c:	89 04 24             	mov    %eax,(%esp)
c010663f:	e8 98 f5 ff ff       	call   c0105bdc <page_insert>
c0106644:	85 c0                	test   %eax,%eax
c0106646:	74 24                	je     c010666c <check_boot_pgdir+0x1ed>
c0106648:	c7 44 24 0c 58 d1 10 	movl   $0xc010d158,0xc(%esp)
c010664f:	c0 
c0106650:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106657:	c0 
c0106658:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
c010665f:	00 
c0106660:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106667:	e8 6e a7 ff ff       	call   c0100dda <__panic>
    assert(page_ref(p) == 1);
c010666c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010666f:	89 04 24             	mov    %eax,(%esp)
c0106672:	e8 9b e5 ff ff       	call   c0104c12 <page_ref>
c0106677:	83 f8 01             	cmp    $0x1,%eax
c010667a:	74 24                	je     c01066a0 <check_boot_pgdir+0x221>
c010667c:	c7 44 24 0c 86 d1 10 	movl   $0xc010d186,0xc(%esp)
c0106683:	c0 
c0106684:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010668b:	c0 
c010668c:	c7 44 24 04 be 02 00 	movl   $0x2be,0x4(%esp)
c0106693:	00 
c0106694:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010669b:	e8 3a a7 ff ff       	call   c0100dda <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01066a0:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01066a5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01066ac:	00 
c01066ad:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01066b4:	00 
c01066b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066b8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066bc:	89 04 24             	mov    %eax,(%esp)
c01066bf:	e8 18 f5 ff ff       	call   c0105bdc <page_insert>
c01066c4:	85 c0                	test   %eax,%eax
c01066c6:	74 24                	je     c01066ec <check_boot_pgdir+0x26d>
c01066c8:	c7 44 24 0c 98 d1 10 	movl   $0xc010d198,0xc(%esp)
c01066cf:	c0 
c01066d0:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01066d7:	c0 
c01066d8:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c01066df:	00 
c01066e0:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01066e7:	e8 ee a6 ff ff       	call   c0100dda <__panic>
    assert(page_ref(p) == 2);
c01066ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066ef:	89 04 24             	mov    %eax,(%esp)
c01066f2:	e8 1b e5 ff ff       	call   c0104c12 <page_ref>
c01066f7:	83 f8 02             	cmp    $0x2,%eax
c01066fa:	74 24                	je     c0106720 <check_boot_pgdir+0x2a1>
c01066fc:	c7 44 24 0c cf d1 10 	movl   $0xc010d1cf,0xc(%esp)
c0106703:	c0 
c0106704:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c010670b:	c0 
c010670c:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c0106713:	00 
c0106714:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c010671b:	e8 ba a6 ff ff       	call   c0100dda <__panic>

    const char *str = "ucore: Hello world!!";
c0106720:	c7 45 dc e0 d1 10 c0 	movl   $0xc010d1e0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106727:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010672a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010672e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106735:	e8 08 53 00 00       	call   c010ba42 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010673a:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106741:	00 
c0106742:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106749:	e8 6d 53 00 00       	call   c010babb <strcmp>
c010674e:	85 c0                	test   %eax,%eax
c0106750:	74 24                	je     c0106776 <check_boot_pgdir+0x2f7>
c0106752:	c7 44 24 0c f8 d1 10 	movl   $0xc010d1f8,0xc(%esp)
c0106759:	c0 
c010675a:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c0106761:	c0 
c0106762:	c7 44 24 04 c4 02 00 	movl   $0x2c4,0x4(%esp)
c0106769:	00 
c010676a:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c0106771:	e8 64 a6 ff ff       	call   c0100dda <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106776:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106779:	89 04 24             	mov    %eax,(%esp)
c010677c:	e8 e7 e3 ff ff       	call   c0104b68 <page2kva>
c0106781:	05 00 01 00 00       	add    $0x100,%eax
c0106786:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106789:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106790:	e8 55 52 00 00       	call   c010b9ea <strlen>
c0106795:	85 c0                	test   %eax,%eax
c0106797:	74 24                	je     c01067bd <check_boot_pgdir+0x33e>
c0106799:	c7 44 24 0c 30 d2 10 	movl   $0xc010d230,0xc(%esp)
c01067a0:	c0 
c01067a1:	c7 44 24 08 59 cd 10 	movl   $0xc010cd59,0x8(%esp)
c01067a8:	c0 
c01067a9:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c01067b0:	00 
c01067b1:	c7 04 24 34 cd 10 c0 	movl   $0xc010cd34,(%esp)
c01067b8:	e8 1d a6 ff ff       	call   c0100dda <__panic>

    free_page(p);
c01067bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067c4:	00 
c01067c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067c8:	89 04 24             	mov    %eax,(%esp)
c01067cb:	e8 b2 e6 ff ff       	call   c0104e82 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c01067d0:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01067d5:	8b 00                	mov    (%eax),%eax
c01067d7:	89 04 24             	mov    %eax,(%esp)
c01067da:	e8 1b e4 ff ff       	call   c0104bfa <pde2page>
c01067df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01067e6:	00 
c01067e7:	89 04 24             	mov    %eax,(%esp)
c01067ea:	e8 93 e6 ff ff       	call   c0104e82 <free_pages>
    boot_pgdir[0] = 0;
c01067ef:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c01067f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01067fa:	c7 04 24 54 d2 10 c0 	movl   $0xc010d254,(%esp)
c0106801:	e8 52 9b ff ff       	call   c0100358 <cprintf>
}
c0106806:	c9                   	leave  
c0106807:	c3                   	ret    

c0106808 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106808:	55                   	push   %ebp
c0106809:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010680b:	8b 45 08             	mov    0x8(%ebp),%eax
c010680e:	83 e0 04             	and    $0x4,%eax
c0106811:	85 c0                	test   %eax,%eax
c0106813:	74 07                	je     c010681c <perm2str+0x14>
c0106815:	b8 75 00 00 00       	mov    $0x75,%eax
c010681a:	eb 05                	jmp    c0106821 <perm2str+0x19>
c010681c:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106821:	a2 08 ee 1a c0       	mov    %al,0xc01aee08
    str[1] = 'r';
c0106826:	c6 05 09 ee 1a c0 72 	movb   $0x72,0xc01aee09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010682d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106830:	83 e0 02             	and    $0x2,%eax
c0106833:	85 c0                	test   %eax,%eax
c0106835:	74 07                	je     c010683e <perm2str+0x36>
c0106837:	b8 77 00 00 00       	mov    $0x77,%eax
c010683c:	eb 05                	jmp    c0106843 <perm2str+0x3b>
c010683e:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106843:	a2 0a ee 1a c0       	mov    %al,0xc01aee0a
    str[3] = '\0';
c0106848:	c6 05 0b ee 1a c0 00 	movb   $0x0,0xc01aee0b
    return str;
c010684f:	b8 08 ee 1a c0       	mov    $0xc01aee08,%eax
}
c0106854:	5d                   	pop    %ebp
c0106855:	c3                   	ret    

c0106856 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106856:	55                   	push   %ebp
c0106857:	89 e5                	mov    %esp,%ebp
c0106859:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010685c:	8b 45 10             	mov    0x10(%ebp),%eax
c010685f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106862:	72 0a                	jb     c010686e <get_pgtable_items+0x18>
        return 0;
c0106864:	b8 00 00 00 00       	mov    $0x0,%eax
c0106869:	e9 9c 00 00 00       	jmp    c010690a <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010686e:	eb 04                	jmp    c0106874 <get_pgtable_items+0x1e>
        start ++;
c0106870:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106874:	8b 45 10             	mov    0x10(%ebp),%eax
c0106877:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010687a:	73 18                	jae    c0106894 <get_pgtable_items+0x3e>
c010687c:	8b 45 10             	mov    0x10(%ebp),%eax
c010687f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106886:	8b 45 14             	mov    0x14(%ebp),%eax
c0106889:	01 d0                	add    %edx,%eax
c010688b:	8b 00                	mov    (%eax),%eax
c010688d:	83 e0 01             	and    $0x1,%eax
c0106890:	85 c0                	test   %eax,%eax
c0106892:	74 dc                	je     c0106870 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0106894:	8b 45 10             	mov    0x10(%ebp),%eax
c0106897:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010689a:	73 69                	jae    c0106905 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010689c:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01068a0:	74 08                	je     c01068aa <get_pgtable_items+0x54>
            *left_store = start;
c01068a2:	8b 45 18             	mov    0x18(%ebp),%eax
c01068a5:	8b 55 10             	mov    0x10(%ebp),%edx
c01068a8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01068aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01068ad:	8d 50 01             	lea    0x1(%eax),%edx
c01068b0:	89 55 10             	mov    %edx,0x10(%ebp)
c01068b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01068ba:	8b 45 14             	mov    0x14(%ebp),%eax
c01068bd:	01 d0                	add    %edx,%eax
c01068bf:	8b 00                	mov    (%eax),%eax
c01068c1:	83 e0 07             	and    $0x7,%eax
c01068c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01068c7:	eb 04                	jmp    c01068cd <get_pgtable_items+0x77>
            start ++;
c01068c9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01068cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01068d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01068d3:	73 1d                	jae    c01068f2 <get_pgtable_items+0x9c>
c01068d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01068d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01068df:	8b 45 14             	mov    0x14(%ebp),%eax
c01068e2:	01 d0                	add    %edx,%eax
c01068e4:	8b 00                	mov    (%eax),%eax
c01068e6:	83 e0 07             	and    $0x7,%eax
c01068e9:	89 c2                	mov    %eax,%edx
c01068eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01068ee:	39 c2                	cmp    %eax,%edx
c01068f0:	74 d7                	je     c01068c9 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01068f2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01068f6:	74 08                	je     c0106900 <get_pgtable_items+0xaa>
            *right_store = start;
c01068f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01068fb:	8b 55 10             	mov    0x10(%ebp),%edx
c01068fe:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106900:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106903:	eb 05                	jmp    c010690a <get_pgtable_items+0xb4>
    }
    return 0;
c0106905:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010690a:	c9                   	leave  
c010690b:	c3                   	ret    

c010690c <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010690c:	55                   	push   %ebp
c010690d:	89 e5                	mov    %esp,%ebp
c010690f:	57                   	push   %edi
c0106910:	56                   	push   %esi
c0106911:	53                   	push   %ebx
c0106912:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106915:	c7 04 24 74 d2 10 c0 	movl   $0xc010d274,(%esp)
c010691c:	e8 37 9a ff ff       	call   c0100358 <cprintf>
    size_t left, right = 0, perm;
c0106921:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106928:	e9 fa 00 00 00       	jmp    c0106a27 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010692d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106930:	89 04 24             	mov    %eax,(%esp)
c0106933:	e8 d0 fe ff ff       	call   c0106808 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106938:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010693b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010693e:	29 d1                	sub    %edx,%ecx
c0106940:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106942:	89 d6                	mov    %edx,%esi
c0106944:	c1 e6 16             	shl    $0x16,%esi
c0106947:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010694a:	89 d3                	mov    %edx,%ebx
c010694c:	c1 e3 16             	shl    $0x16,%ebx
c010694f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106952:	89 d1                	mov    %edx,%ecx
c0106954:	c1 e1 16             	shl    $0x16,%ecx
c0106957:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010695a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010695d:	29 d7                	sub    %edx,%edi
c010695f:	89 fa                	mov    %edi,%edx
c0106961:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106965:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106969:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010696d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106971:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106975:	c7 04 24 a5 d2 10 c0 	movl   $0xc010d2a5,(%esp)
c010697c:	e8 d7 99 ff ff       	call   c0100358 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106981:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106984:	c1 e0 0a             	shl    $0xa,%eax
c0106987:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010698a:	eb 54                	jmp    c01069e0 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010698c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010698f:	89 04 24             	mov    %eax,(%esp)
c0106992:	e8 71 fe ff ff       	call   c0106808 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106997:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010699a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010699d:	29 d1                	sub    %edx,%ecx
c010699f:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01069a1:	89 d6                	mov    %edx,%esi
c01069a3:	c1 e6 0c             	shl    $0xc,%esi
c01069a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01069a9:	89 d3                	mov    %edx,%ebx
c01069ab:	c1 e3 0c             	shl    $0xc,%ebx
c01069ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01069b1:	c1 e2 0c             	shl    $0xc,%edx
c01069b4:	89 d1                	mov    %edx,%ecx
c01069b6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01069b9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01069bc:	29 d7                	sub    %edx,%edi
c01069be:	89 fa                	mov    %edi,%edx
c01069c0:	89 44 24 14          	mov    %eax,0x14(%esp)
c01069c4:	89 74 24 10          	mov    %esi,0x10(%esp)
c01069c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01069cc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01069d0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069d4:	c7 04 24 c4 d2 10 c0 	movl   $0xc010d2c4,(%esp)
c01069db:	e8 78 99 ff ff       	call   c0100358 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01069e0:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01069e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01069e8:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01069eb:	89 ce                	mov    %ecx,%esi
c01069ed:	c1 e6 0a             	shl    $0xa,%esi
c01069f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01069f3:	89 cb                	mov    %ecx,%ebx
c01069f5:	c1 e3 0a             	shl    $0xa,%ebx
c01069f8:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01069fb:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01069ff:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106a02:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106a06:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106a0a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a0e:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106a12:	89 1c 24             	mov    %ebx,(%esp)
c0106a15:	e8 3c fe ff ff       	call   c0106856 <get_pgtable_items>
c0106a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106a1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106a21:	0f 85 65 ff ff ff    	jne    c010698c <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106a27:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106a2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a2f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106a32:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106a36:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106a39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106a3d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106a41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a45:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106a4c:	00 
c0106a4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106a54:	e8 fd fd ff ff       	call   c0106856 <get_pgtable_items>
c0106a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106a5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106a60:	0f 85 c7 fe ff ff    	jne    c010692d <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106a66:	c7 04 24 e8 d2 10 c0 	movl   $0xc010d2e8,(%esp)
c0106a6d:	e8 e6 98 ff ff       	call   c0100358 <cprintf>
}
c0106a72:	83 c4 4c             	add    $0x4c,%esp
c0106a75:	5b                   	pop    %ebx
c0106a76:	5e                   	pop    %esi
c0106a77:	5f                   	pop    %edi
c0106a78:	5d                   	pop    %ebp
c0106a79:	c3                   	ret    

c0106a7a <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106a7a:	55                   	push   %ebp
c0106a7b:	89 e5                	mov    %esp,%ebp
c0106a7d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a83:	c1 e8 0c             	shr    $0xc,%eax
c0106a86:	89 c2                	mov    %eax,%edx
c0106a88:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0106a8d:	39 c2                	cmp    %eax,%edx
c0106a8f:	72 1c                	jb     c0106aad <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106a91:	c7 44 24 08 1c d3 10 	movl   $0xc010d31c,0x8(%esp)
c0106a98:	c0 
c0106a99:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106aa0:	00 
c0106aa1:	c7 04 24 3b d3 10 c0 	movl   $0xc010d33b,(%esp)
c0106aa8:	e8 2d a3 ff ff       	call   c0100dda <__panic>
    }
    return &pages[PPN(pa)];
c0106aad:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0106ab2:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ab5:	c1 ea 0c             	shr    $0xc,%edx
c0106ab8:	c1 e2 05             	shl    $0x5,%edx
c0106abb:	01 d0                	add    %edx,%eax
}
c0106abd:	c9                   	leave  
c0106abe:	c3                   	ret    

c0106abf <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106abf:	55                   	push   %ebp
c0106ac0:	89 e5                	mov    %esp,%ebp
c0106ac2:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ac8:	83 e0 01             	and    $0x1,%eax
c0106acb:	85 c0                	test   %eax,%eax
c0106acd:	75 1c                	jne    c0106aeb <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106acf:	c7 44 24 08 4c d3 10 	movl   $0xc010d34c,0x8(%esp)
c0106ad6:	c0 
c0106ad7:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106ade:	00 
c0106adf:	c7 04 24 3b d3 10 c0 	movl   $0xc010d33b,(%esp)
c0106ae6:	e8 ef a2 ff ff       	call   c0100dda <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106af3:	89 04 24             	mov    %eax,(%esp)
c0106af6:	e8 7f ff ff ff       	call   c0106a7a <pa2page>
}
c0106afb:	c9                   	leave  
c0106afc:	c3                   	ret    

c0106afd <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106afd:	55                   	push   %ebp
c0106afe:	89 e5                	mov    %esp,%ebp
c0106b00:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106b0b:	89 04 24             	mov    %eax,(%esp)
c0106b0e:	e8 67 ff ff ff       	call   c0106a7a <pa2page>
}
c0106b13:	c9                   	leave  
c0106b14:	c3                   	ret    

c0106b15 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106b15:	55                   	push   %ebp
c0106b16:	89 e5                	mov    %esp,%ebp
c0106b18:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106b1b:	e8 a6 22 00 00       	call   c0108dc6 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106b20:	a1 3c 0f 1b c0       	mov    0xc01b0f3c,%eax
c0106b25:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106b2a:	76 0c                	jbe    c0106b38 <swap_init+0x23>
c0106b2c:	a1 3c 0f 1b c0       	mov    0xc01b0f3c,%eax
c0106b31:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106b36:	76 25                	jbe    c0106b5d <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106b38:	a1 3c 0f 1b c0       	mov    0xc01b0f3c,%eax
c0106b3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106b41:	c7 44 24 08 6d d3 10 	movl   $0xc010d36d,0x8(%esp)
c0106b48:	c0 
c0106b49:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106b50:	00 
c0106b51:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106b58:	e8 7d a2 ff ff       	call   c0100dda <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106b5d:	c7 05 14 ee 1a c0 60 	movl   $0xc012ca60,0xc01aee14
c0106b64:	ca 12 c0 
     int r = sm->init();
c0106b67:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106b6c:	8b 40 04             	mov    0x4(%eax),%eax
c0106b6f:	ff d0                	call   *%eax
c0106b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106b78:	75 26                	jne    c0106ba0 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106b7a:	c7 05 0c ee 1a c0 01 	movl   $0x1,0xc01aee0c
c0106b81:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106b84:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106b89:	8b 00                	mov    (%eax),%eax
c0106b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b8f:	c7 04 24 97 d3 10 c0 	movl   $0xc010d397,(%esp)
c0106b96:	e8 bd 97 ff ff       	call   c0100358 <cprintf>
          check_swap();
c0106b9b:	e8 a4 04 00 00       	call   c0107044 <check_swap>
     }

     return r;
c0106ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106ba3:	c9                   	leave  
c0106ba4:	c3                   	ret    

c0106ba5 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106ba5:	55                   	push   %ebp
c0106ba6:	89 e5                	mov    %esp,%ebp
c0106ba8:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106bab:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106bb0:	8b 40 08             	mov    0x8(%eax),%eax
c0106bb3:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bb6:	89 14 24             	mov    %edx,(%esp)
c0106bb9:	ff d0                	call   *%eax
}
c0106bbb:	c9                   	leave  
c0106bbc:	c3                   	ret    

c0106bbd <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106bbd:	55                   	push   %ebp
c0106bbe:	89 e5                	mov    %esp,%ebp
c0106bc0:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106bc3:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106bc8:	8b 40 0c             	mov    0xc(%eax),%eax
c0106bcb:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bce:	89 14 24             	mov    %edx,(%esp)
c0106bd1:	ff d0                	call   *%eax
}
c0106bd3:	c9                   	leave  
c0106bd4:	c3                   	ret    

c0106bd5 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106bd5:	55                   	push   %ebp
c0106bd6:	89 e5                	mov    %esp,%ebp
c0106bd8:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106bdb:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106be0:	8b 40 10             	mov    0x10(%eax),%eax
c0106be3:	8b 55 14             	mov    0x14(%ebp),%edx
c0106be6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106bea:	8b 55 10             	mov    0x10(%ebp),%edx
c0106bed:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106bf1:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106bf4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106bf8:	8b 55 08             	mov    0x8(%ebp),%edx
c0106bfb:	89 14 24             	mov    %edx,(%esp)
c0106bfe:	ff d0                	call   *%eax
}
c0106c00:	c9                   	leave  
c0106c01:	c3                   	ret    

c0106c02 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106c02:	55                   	push   %ebp
c0106c03:	89 e5                	mov    %esp,%ebp
c0106c05:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106c08:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106c0d:	8b 40 14             	mov    0x14(%eax),%eax
c0106c10:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c17:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c1a:	89 14 24             	mov    %edx,(%esp)
c0106c1d:	ff d0                	call   *%eax
}
c0106c1f:	c9                   	leave  
c0106c20:	c3                   	ret    

c0106c21 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106c21:	55                   	push   %ebp
c0106c22:	89 e5                	mov    %esp,%ebp
c0106c24:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106c27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106c2e:	e9 5a 01 00 00       	jmp    c0106d8d <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106c33:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106c38:	8b 40 18             	mov    0x18(%eax),%eax
c0106c3b:	8b 55 10             	mov    0x10(%ebp),%edx
c0106c3e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106c42:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106c45:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c49:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c4c:	89 14 24             	mov    %edx,(%esp)
c0106c4f:	ff d0                	call   *%eax
c0106c51:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106c54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106c58:	74 18                	je     c0106c72 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c61:	c7 04 24 ac d3 10 c0 	movl   $0xc010d3ac,(%esp)
c0106c68:	e8 eb 96 ff ff       	call   c0100358 <cprintf>
c0106c6d:	e9 27 01 00 00       	jmp    c0106d99 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c75:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106c7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c7e:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c81:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106c88:	00 
c0106c89:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106c8c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c90:	89 04 24             	mov    %eax,(%esp)
c0106c93:	e8 e6 e8 ff ff       	call   c010557e <get_pte>
c0106c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106c9e:	8b 00                	mov    (%eax),%eax
c0106ca0:	83 e0 01             	and    $0x1,%eax
c0106ca3:	85 c0                	test   %eax,%eax
c0106ca5:	75 24                	jne    c0106ccb <swap_out+0xaa>
c0106ca7:	c7 44 24 0c d9 d3 10 	movl   $0xc010d3d9,0xc(%esp)
c0106cae:	c0 
c0106caf:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106cb6:	c0 
c0106cb7:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106cbe:	00 
c0106cbf:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106cc6:	e8 0f a1 ff ff       	call   c0100dda <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cd1:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106cd4:	c1 ea 0c             	shr    $0xc,%edx
c0106cd7:	83 c2 01             	add    $0x1,%edx
c0106cda:	c1 e2 08             	shl    $0x8,%edx
c0106cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106ce1:	89 14 24             	mov    %edx,(%esp)
c0106ce4:	e8 97 21 00 00       	call   c0108e80 <swapfs_write>
c0106ce9:	85 c0                	test   %eax,%eax
c0106ceb:	74 34                	je     c0106d21 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106ced:	c7 04 24 03 d4 10 c0 	movl   $0xc010d403,(%esp)
c0106cf4:	e8 5f 96 ff ff       	call   c0100358 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106cf9:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0106cfe:	8b 40 10             	mov    0x10(%eax),%eax
c0106d01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d04:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106d0b:	00 
c0106d0c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106d10:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d17:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d1a:	89 14 24             	mov    %edx,(%esp)
c0106d1d:	ff d0                	call   *%eax
c0106d1f:	eb 68                	jmp    c0106d89 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106d21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d24:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106d27:	c1 e8 0c             	shr    $0xc,%eax
c0106d2a:	83 c0 01             	add    $0x1,%eax
c0106d2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d34:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d3f:	c7 04 24 1c d4 10 c0 	movl   $0xc010d41c,(%esp)
c0106d46:	e8 0d 96 ff ff       	call   c0100358 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106d4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d4e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106d51:	c1 e8 0c             	shr    $0xc,%eax
c0106d54:	83 c0 01             	add    $0x1,%eax
c0106d57:	c1 e0 08             	shl    $0x8,%eax
c0106d5a:	89 c2                	mov    %eax,%edx
c0106d5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d5f:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106d61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106d6b:	00 
c0106d6c:	89 04 24             	mov    %eax,(%esp)
c0106d6f:	e8 0e e1 ff ff       	call   c0104e82 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d77:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d7d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d81:	89 04 24             	mov    %eax,(%esp)
c0106d84:	e8 0c ef ff ff       	call   c0105c95 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106d89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d90:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106d93:	0f 85 9a fe ff ff    	jne    c0106c33 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106d9c:	c9                   	leave  
c0106d9d:	c3                   	ret    

c0106d9e <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106d9e:	55                   	push   %ebp
c0106d9f:	89 e5                	mov    %esp,%ebp
c0106da1:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106da4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106dab:	e8 67 e0 ff ff       	call   c0104e17 <alloc_pages>
c0106db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106db3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106db7:	75 24                	jne    c0106ddd <swap_in+0x3f>
c0106db9:	c7 44 24 0c 5c d4 10 	movl   $0xc010d45c,0xc(%esp)
c0106dc0:	c0 
c0106dc1:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106dc8:	c0 
c0106dc9:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0106dd0:	00 
c0106dd1:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106dd8:	e8 fd 9f ff ff       	call   c0100dda <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106de0:	8b 40 0c             	mov    0xc(%eax),%eax
c0106de3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106dea:	00 
c0106deb:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106dee:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106df2:	89 04 24             	mov    %eax,(%esp)
c0106df5:	e8 84 e7 ff ff       	call   c010557e <get_pte>
c0106dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e00:	8b 00                	mov    (%eax),%eax
c0106e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e05:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e09:	89 04 24             	mov    %eax,(%esp)
c0106e0c:	e8 fd 1f 00 00       	call   c0108e0e <swapfs_read>
c0106e11:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106e18:	74 2a                	je     c0106e44 <swap_in+0xa6>
     {
        assert(r!=0);
c0106e1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106e1e:	75 24                	jne    c0106e44 <swap_in+0xa6>
c0106e20:	c7 44 24 0c 69 d4 10 	movl   $0xc010d469,0xc(%esp)
c0106e27:	c0 
c0106e28:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106e2f:	c0 
c0106e30:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0106e37:	00 
c0106e38:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106e3f:	e8 96 9f ff ff       	call   c0100dda <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e47:	8b 00                	mov    (%eax),%eax
c0106e49:	c1 e8 08             	shr    $0x8,%eax
c0106e4c:	89 c2                	mov    %eax,%edx
c0106e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106e51:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106e55:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e59:	c7 04 24 70 d4 10 c0 	movl   $0xc010d470,(%esp)
c0106e60:	e8 f3 94 ff ff       	call   c0100358 <cprintf>
     *ptr_result=result;
c0106e65:	8b 45 10             	mov    0x10(%ebp),%eax
c0106e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e6b:	89 10                	mov    %edx,(%eax)
     return 0;
c0106e6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106e72:	c9                   	leave  
c0106e73:	c3                   	ret    

c0106e74 <check_content_set>:



static inline void
check_content_set(void)
{
c0106e74:	55                   	push   %ebp
c0106e75:	89 e5                	mov    %esp,%ebp
c0106e77:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106e7a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106e7f:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106e82:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106e87:	83 f8 01             	cmp    $0x1,%eax
c0106e8a:	74 24                	je     c0106eb0 <check_content_set+0x3c>
c0106e8c:	c7 44 24 0c ae d4 10 	movl   $0xc010d4ae,0xc(%esp)
c0106e93:	c0 
c0106e94:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106e9b:	c0 
c0106e9c:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106ea3:	00 
c0106ea4:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106eab:	e8 2a 9f ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106eb0:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106eb5:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106eb8:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106ebd:	83 f8 01             	cmp    $0x1,%eax
c0106ec0:	74 24                	je     c0106ee6 <check_content_set+0x72>
c0106ec2:	c7 44 24 0c ae d4 10 	movl   $0xc010d4ae,0xc(%esp)
c0106ec9:	c0 
c0106eca:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106ed1:	c0 
c0106ed2:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106ed9:	00 
c0106eda:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106ee1:	e8 f4 9e ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106ee6:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106eeb:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106eee:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106ef3:	83 f8 02             	cmp    $0x2,%eax
c0106ef6:	74 24                	je     c0106f1c <check_content_set+0xa8>
c0106ef8:	c7 44 24 0c bd d4 10 	movl   $0xc010d4bd,0xc(%esp)
c0106eff:	c0 
c0106f00:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106f07:	c0 
c0106f08:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106f0f:	00 
c0106f10:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106f17:	e8 be 9e ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106f1c:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106f21:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106f24:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106f29:	83 f8 02             	cmp    $0x2,%eax
c0106f2c:	74 24                	je     c0106f52 <check_content_set+0xde>
c0106f2e:	c7 44 24 0c bd d4 10 	movl   $0xc010d4bd,0xc(%esp)
c0106f35:	c0 
c0106f36:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106f3d:	c0 
c0106f3e:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106f45:	00 
c0106f46:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106f4d:	e8 88 9e ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106f52:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106f57:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106f5a:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106f5f:	83 f8 03             	cmp    $0x3,%eax
c0106f62:	74 24                	je     c0106f88 <check_content_set+0x114>
c0106f64:	c7 44 24 0c cc d4 10 	movl   $0xc010d4cc,0xc(%esp)
c0106f6b:	c0 
c0106f6c:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106f73:	c0 
c0106f74:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106f7b:	00 
c0106f7c:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106f83:	e8 52 9e ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106f88:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106f8d:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106f90:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106f95:	83 f8 03             	cmp    $0x3,%eax
c0106f98:	74 24                	je     c0106fbe <check_content_set+0x14a>
c0106f9a:	c7 44 24 0c cc d4 10 	movl   $0xc010d4cc,0xc(%esp)
c0106fa1:	c0 
c0106fa2:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106fa9:	c0 
c0106faa:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106fb1:	00 
c0106fb2:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106fb9:	e8 1c 9e ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106fbe:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106fc3:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106fc6:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0106fcb:	83 f8 04             	cmp    $0x4,%eax
c0106fce:	74 24                	je     c0106ff4 <check_content_set+0x180>
c0106fd0:	c7 44 24 0c db d4 10 	movl   $0xc010d4db,0xc(%esp)
c0106fd7:	c0 
c0106fd8:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0106fdf:	c0 
c0106fe0:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106fe7:	00 
c0106fe8:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0106fef:	e8 e6 9d ff ff       	call   c0100dda <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106ff4:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106ff9:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106ffc:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107001:	83 f8 04             	cmp    $0x4,%eax
c0107004:	74 24                	je     c010702a <check_content_set+0x1b6>
c0107006:	c7 44 24 0c db d4 10 	movl   $0xc010d4db,0xc(%esp)
c010700d:	c0 
c010700e:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107015:	c0 
c0107016:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c010701d:	00 
c010701e:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107025:	e8 b0 9d ff ff       	call   c0100dda <__panic>
}
c010702a:	c9                   	leave  
c010702b:	c3                   	ret    

c010702c <check_content_access>:

static inline int
check_content_access(void)
{
c010702c:	55                   	push   %ebp
c010702d:	89 e5                	mov    %esp,%ebp
c010702f:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0107032:	a1 14 ee 1a c0       	mov    0xc01aee14,%eax
c0107037:	8b 40 1c             	mov    0x1c(%eax),%eax
c010703a:	ff d0                	call   *%eax
c010703c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c010703f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107042:	c9                   	leave  
c0107043:	c3                   	ret    

c0107044 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0107044:	55                   	push   %ebp
c0107045:	89 e5                	mov    %esp,%ebp
c0107047:	53                   	push   %ebx
c0107048:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010704b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107052:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0107059:	c7 45 e8 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107060:	eb 6b                	jmp    c01070cd <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0107062:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107065:	83 e8 0c             	sub    $0xc,%eax
c0107068:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010706b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010706e:	83 c0 04             	add    $0x4,%eax
c0107071:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0107078:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010707b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010707e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0107081:	0f a3 10             	bt     %edx,(%eax)
c0107084:	19 c0                	sbb    %eax,%eax
c0107086:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0107089:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010708d:	0f 95 c0             	setne  %al
c0107090:	0f b6 c0             	movzbl %al,%eax
c0107093:	85 c0                	test   %eax,%eax
c0107095:	75 24                	jne    c01070bb <check_swap+0x77>
c0107097:	c7 44 24 0c ea d4 10 	movl   $0xc010d4ea,0xc(%esp)
c010709e:	c0 
c010709f:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c01070a6:	c0 
c01070a7:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01070ae:	00 
c01070af:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c01070b6:	e8 1f 9d ff ff       	call   c0100dda <__panic>
        count ++, total += p->property;
c01070bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01070bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01070c2:	8b 50 08             	mov    0x8(%eax),%edx
c01070c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01070c8:	01 d0                	add    %edx,%eax
c01070ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01070cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01070d0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01070d3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01070d6:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01070d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01070dc:	81 7d e8 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x18(%ebp)
c01070e3:	0f 85 79 ff ff ff    	jne    c0107062 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01070e9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01070ec:	e8 c3 dd ff ff       	call   c0104eb4 <nr_free_pages>
c01070f1:	39 c3                	cmp    %eax,%ebx
c01070f3:	74 24                	je     c0107119 <check_swap+0xd5>
c01070f5:	c7 44 24 0c fa d4 10 	movl   $0xc010d4fa,0xc(%esp)
c01070fc:	c0 
c01070fd:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107104:	c0 
c0107105:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010710c:	00 
c010710d:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107114:	e8 c1 9c ff ff       	call   c0100dda <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0107119:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010711c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107120:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107123:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107127:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c010712e:	e8 25 92 ff ff       	call   c0100358 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0107133:	e8 5e 0a 00 00       	call   c0107b96 <mm_create>
c0107138:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010713b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010713f:	75 24                	jne    c0107165 <check_swap+0x121>
c0107141:	c7 44 24 0c 3a d5 10 	movl   $0xc010d53a,0xc(%esp)
c0107148:	c0 
c0107149:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107150:	c0 
c0107151:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0107158:	00 
c0107159:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107160:	e8 75 9c ff ff       	call   c0100dda <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0107165:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c010716a:	85 c0                	test   %eax,%eax
c010716c:	74 24                	je     c0107192 <check_swap+0x14e>
c010716e:	c7 44 24 0c 45 d5 10 	movl   $0xc010d545,0xc(%esp)
c0107175:	c0 
c0107176:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c010717d:	c0 
c010717e:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107185:	00 
c0107186:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c010718d:	e8 48 9c ff ff       	call   c0100dda <__panic>

     check_mm_struct = mm;
c0107192:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107195:	a3 6c 0f 1b c0       	mov    %eax,0xc01b0f6c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010719a:	8b 15 84 ed 1a c0    	mov    0xc01aed84,%edx
c01071a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01071a3:	89 50 0c             	mov    %edx,0xc(%eax)
c01071a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01071a9:	8b 40 0c             	mov    0xc(%eax),%eax
c01071ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01071af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01071b2:	8b 00                	mov    (%eax),%eax
c01071b4:	85 c0                	test   %eax,%eax
c01071b6:	74 24                	je     c01071dc <check_swap+0x198>
c01071b8:	c7 44 24 0c 5d d5 10 	movl   $0xc010d55d,0xc(%esp)
c01071bf:	c0 
c01071c0:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c01071c7:	c0 
c01071c8:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01071cf:	00 
c01071d0:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c01071d7:	e8 fe 9b ff ff       	call   c0100dda <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01071dc:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01071e3:	00 
c01071e4:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01071eb:	00 
c01071ec:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01071f3:	e8 37 0a 00 00       	call   c0107c2f <vma_create>
c01071f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01071fb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01071ff:	75 24                	jne    c0107225 <check_swap+0x1e1>
c0107201:	c7 44 24 0c 6b d5 10 	movl   $0xc010d56b,0xc(%esp)
c0107208:	c0 
c0107209:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107210:	c0 
c0107211:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107218:	00 
c0107219:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107220:	e8 b5 9b ff ff       	call   c0100dda <__panic>

     insert_vma_struct(mm, vma);
c0107225:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107228:	89 44 24 04          	mov    %eax,0x4(%esp)
c010722c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010722f:	89 04 24             	mov    %eax,(%esp)
c0107232:	e8 88 0b 00 00       	call   c0107dbf <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0107237:	c7 04 24 78 d5 10 c0 	movl   $0xc010d578,(%esp)
c010723e:	e8 15 91 ff ff       	call   c0100358 <cprintf>
     pte_t *temp_ptep=NULL;
c0107243:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010724a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010724d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107250:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107257:	00 
c0107258:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010725f:	00 
c0107260:	89 04 24             	mov    %eax,(%esp)
c0107263:	e8 16 e3 ff ff       	call   c010557e <get_pte>
c0107268:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c010726b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c010726f:	75 24                	jne    c0107295 <check_swap+0x251>
c0107271:	c7 44 24 0c ac d5 10 	movl   $0xc010d5ac,0xc(%esp)
c0107278:	c0 
c0107279:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107280:	c0 
c0107281:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107288:	00 
c0107289:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107290:	e8 45 9b ff ff       	call   c0100dda <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0107295:	c7 04 24 c0 d5 10 c0 	movl   $0xc010d5c0,(%esp)
c010729c:	e8 b7 90 ff ff       	call   c0100358 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01072a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01072a8:	e9 a3 00 00 00       	jmp    c0107350 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01072ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01072b4:	e8 5e db ff ff       	call   c0104e17 <alloc_pages>
c01072b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01072bc:	89 04 95 a0 0e 1b c0 	mov    %eax,-0x3fe4f160(,%edx,4)
          assert(check_rp[i] != NULL );
c01072c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072c6:	8b 04 85 a0 0e 1b c0 	mov    -0x3fe4f160(,%eax,4),%eax
c01072cd:	85 c0                	test   %eax,%eax
c01072cf:	75 24                	jne    c01072f5 <check_swap+0x2b1>
c01072d1:	c7 44 24 0c e4 d5 10 	movl   $0xc010d5e4,0xc(%esp)
c01072d8:	c0 
c01072d9:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c01072e0:	c0 
c01072e1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01072e8:	00 
c01072e9:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c01072f0:	e8 e5 9a ff ff       	call   c0100dda <__panic>
          assert(!PageProperty(check_rp[i]));
c01072f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01072f8:	8b 04 85 a0 0e 1b c0 	mov    -0x3fe4f160(,%eax,4),%eax
c01072ff:	83 c0 04             	add    $0x4,%eax
c0107302:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0107309:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010730c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010730f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107312:	0f a3 10             	bt     %edx,(%eax)
c0107315:	19 c0                	sbb    %eax,%eax
c0107317:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010731a:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c010731e:	0f 95 c0             	setne  %al
c0107321:	0f b6 c0             	movzbl %al,%eax
c0107324:	85 c0                	test   %eax,%eax
c0107326:	74 24                	je     c010734c <check_swap+0x308>
c0107328:	c7 44 24 0c f8 d5 10 	movl   $0xc010d5f8,0xc(%esp)
c010732f:	c0 
c0107330:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107337:	c0 
c0107338:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010733f:	00 
c0107340:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107347:	e8 8e 9a ff ff       	call   c0100dda <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010734c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107350:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107354:	0f 8e 53 ff ff ff    	jle    c01072ad <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c010735a:	a1 7c 0e 1b c0       	mov    0xc01b0e7c,%eax
c010735f:	8b 15 80 0e 1b c0    	mov    0xc01b0e80,%edx
c0107365:	89 45 98             	mov    %eax,-0x68(%ebp)
c0107368:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010736b:	c7 45 a8 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107372:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107375:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0107378:	89 50 04             	mov    %edx,0x4(%eax)
c010737b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010737e:	8b 50 04             	mov    0x4(%eax),%edx
c0107381:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107384:	89 10                	mov    %edx,(%eax)
c0107386:	c7 45 a4 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010738d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107390:	8b 40 04             	mov    0x4(%eax),%eax
c0107393:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0107396:	0f 94 c0             	sete   %al
c0107399:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010739c:	85 c0                	test   %eax,%eax
c010739e:	75 24                	jne    c01073c4 <check_swap+0x380>
c01073a0:	c7 44 24 0c 13 d6 10 	movl   $0xc010d613,0xc(%esp)
c01073a7:	c0 
c01073a8:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c01073af:	c0 
c01073b0:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01073b7:	00 
c01073b8:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c01073bf:	e8 16 9a ff ff       	call   c0100dda <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01073c4:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c01073c9:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01073cc:	c7 05 84 0e 1b c0 00 	movl   $0x0,0xc01b0e84
c01073d3:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01073d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01073dd:	eb 1e                	jmp    c01073fd <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01073df:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073e2:	8b 04 85 a0 0e 1b c0 	mov    -0x3fe4f160(,%eax,4),%eax
c01073e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01073f0:	00 
c01073f1:	89 04 24             	mov    %eax,(%esp)
c01073f4:	e8 89 da ff ff       	call   c0104e82 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01073f9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01073fd:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107401:	7e dc                	jle    c01073df <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107403:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0107408:	83 f8 04             	cmp    $0x4,%eax
c010740b:	74 24                	je     c0107431 <check_swap+0x3ed>
c010740d:	c7 44 24 0c 2c d6 10 	movl   $0xc010d62c,0xc(%esp)
c0107414:	c0 
c0107415:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c010741c:	c0 
c010741d:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0107424:	00 
c0107425:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c010742c:	e8 a9 99 ff ff       	call   c0100dda <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0107431:	c7 04 24 50 d6 10 c0 	movl   $0xc010d650,(%esp)
c0107438:	e8 1b 8f ff ff       	call   c0100358 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c010743d:	c7 05 18 ee 1a c0 00 	movl   $0x0,0xc01aee18
c0107444:	00 00 00 
     
     check_content_set();
c0107447:	e8 28 fa ff ff       	call   c0106e74 <check_content_set>
     assert( nr_free == 0);         
c010744c:	a1 84 0e 1b c0       	mov    0xc01b0e84,%eax
c0107451:	85 c0                	test   %eax,%eax
c0107453:	74 24                	je     c0107479 <check_swap+0x435>
c0107455:	c7 44 24 0c 77 d6 10 	movl   $0xc010d677,0xc(%esp)
c010745c:	c0 
c010745d:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107464:	c0 
c0107465:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c010746c:	00 
c010746d:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107474:	e8 61 99 ff ff       	call   c0100dda <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0107479:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107480:	eb 26                	jmp    c01074a8 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0107482:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107485:	c7 04 85 c0 0e 1b c0 	movl   $0xffffffff,-0x3fe4f140(,%eax,4)
c010748c:	ff ff ff ff 
c0107490:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107493:	8b 14 85 c0 0e 1b c0 	mov    -0x3fe4f140(,%eax,4),%edx
c010749a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010749d:	89 14 85 00 0f 1b c0 	mov    %edx,-0x3fe4f100(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01074a4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01074a8:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01074ac:	7e d4                	jle    c0107482 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01074ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01074b5:	e9 eb 00 00 00       	jmp    c01075a5 <check_swap+0x561>
         check_ptep[i]=0;
c01074ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074bd:	c7 04 85 54 0f 1b c0 	movl   $0x0,-0x3fe4f0ac(,%eax,4)
c01074c4:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01074c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074cb:	83 c0 01             	add    $0x1,%eax
c01074ce:	c1 e0 0c             	shl    $0xc,%eax
c01074d1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074d8:	00 
c01074d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074e0:	89 04 24             	mov    %eax,(%esp)
c01074e3:	e8 96 e0 ff ff       	call   c010557e <get_pte>
c01074e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01074eb:	89 04 95 54 0f 1b c0 	mov    %eax,-0x3fe4f0ac(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01074f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074f5:	8b 04 85 54 0f 1b c0 	mov    -0x3fe4f0ac(,%eax,4),%eax
c01074fc:	85 c0                	test   %eax,%eax
c01074fe:	75 24                	jne    c0107524 <check_swap+0x4e0>
c0107500:	c7 44 24 0c 84 d6 10 	movl   $0xc010d684,0xc(%esp)
c0107507:	c0 
c0107508:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c010750f:	c0 
c0107510:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107517:	00 
c0107518:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c010751f:	e8 b6 98 ff ff       	call   c0100dda <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0107524:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107527:	8b 04 85 54 0f 1b c0 	mov    -0x3fe4f0ac(,%eax,4),%eax
c010752e:	8b 00                	mov    (%eax),%eax
c0107530:	89 04 24             	mov    %eax,(%esp)
c0107533:	e8 87 f5 ff ff       	call   c0106abf <pte2page>
c0107538:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010753b:	8b 14 95 a0 0e 1b c0 	mov    -0x3fe4f160(,%edx,4),%edx
c0107542:	39 d0                	cmp    %edx,%eax
c0107544:	74 24                	je     c010756a <check_swap+0x526>
c0107546:	c7 44 24 0c 9c d6 10 	movl   $0xc010d69c,0xc(%esp)
c010754d:	c0 
c010754e:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c0107555:	c0 
c0107556:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010755d:	00 
c010755e:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c0107565:	e8 70 98 ff ff       	call   c0100dda <__panic>
         assert((*check_ptep[i] & PTE_P));          
c010756a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010756d:	8b 04 85 54 0f 1b c0 	mov    -0x3fe4f0ac(,%eax,4),%eax
c0107574:	8b 00                	mov    (%eax),%eax
c0107576:	83 e0 01             	and    $0x1,%eax
c0107579:	85 c0                	test   %eax,%eax
c010757b:	75 24                	jne    c01075a1 <check_swap+0x55d>
c010757d:	c7 44 24 0c c4 d6 10 	movl   $0xc010d6c4,0xc(%esp)
c0107584:	c0 
c0107585:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c010758c:	c0 
c010758d:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0107594:	00 
c0107595:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c010759c:	e8 39 98 ff ff       	call   c0100dda <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075a1:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01075a5:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01075a9:	0f 8e 0b ff ff ff    	jle    c01074ba <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01075af:	c7 04 24 e0 d6 10 c0 	movl   $0xc010d6e0,(%esp)
c01075b6:	e8 9d 8d ff ff       	call   c0100358 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01075bb:	e8 6c fa ff ff       	call   c010702c <check_content_access>
c01075c0:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01075c3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01075c7:	74 24                	je     c01075ed <check_swap+0x5a9>
c01075c9:	c7 44 24 0c 06 d7 10 	movl   $0xc010d706,0xc(%esp)
c01075d0:	c0 
c01075d1:	c7 44 24 08 ee d3 10 	movl   $0xc010d3ee,0x8(%esp)
c01075d8:	c0 
c01075d9:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c01075e0:	00 
c01075e1:	c7 04 24 88 d3 10 c0 	movl   $0xc010d388,(%esp)
c01075e8:	e8 ed 97 ff ff       	call   c0100dda <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01075f4:	eb 1e                	jmp    c0107614 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01075f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075f9:	8b 04 85 a0 0e 1b c0 	mov    -0x3fe4f160(,%eax,4),%eax
c0107600:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107607:	00 
c0107608:	89 04 24             	mov    %eax,(%esp)
c010760b:	e8 72 d8 ff ff       	call   c0104e82 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107610:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107614:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107618:	7e dc                	jle    c01075f6 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pde2page(pgdir[0]));
c010761a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010761d:	8b 00                	mov    (%eax),%eax
c010761f:	89 04 24             	mov    %eax,(%esp)
c0107622:	e8 d6 f4 ff ff       	call   c0106afd <pde2page>
c0107627:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010762e:	00 
c010762f:	89 04 24             	mov    %eax,(%esp)
c0107632:	e8 4b d8 ff ff       	call   c0104e82 <free_pages>
     pgdir[0] = 0;
c0107637:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010763a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c0107640:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107643:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c010764a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010764d:	89 04 24             	mov    %eax,(%esp)
c0107650:	e8 9a 08 00 00       	call   c0107eef <mm_destroy>
     check_mm_struct = NULL;
c0107655:	c7 05 6c 0f 1b c0 00 	movl   $0x0,0xc01b0f6c
c010765c:	00 00 00 
     
     nr_free = nr_free_store;
c010765f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107662:	a3 84 0e 1b c0       	mov    %eax,0xc01b0e84
     free_list = free_list_store;
c0107667:	8b 45 98             	mov    -0x68(%ebp),%eax
c010766a:	8b 55 9c             	mov    -0x64(%ebp),%edx
c010766d:	a3 7c 0e 1b c0       	mov    %eax,0xc01b0e7c
c0107672:	89 15 80 0e 1b c0    	mov    %edx,0xc01b0e80

     
     le = &free_list;
c0107678:	c7 45 e8 7c 0e 1b c0 	movl   $0xc01b0e7c,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010767f:	eb 1d                	jmp    c010769e <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c0107681:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107684:	83 e8 0c             	sub    $0xc,%eax
c0107687:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c010768a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010768e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107691:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107694:	8b 40 08             	mov    0x8(%eax),%eax
c0107697:	29 c2                	sub    %eax,%edx
c0107699:	89 d0                	mov    %edx,%eax
c010769b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010769e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076a1:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01076a4:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01076a7:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01076aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01076ad:	81 7d e8 7c 0e 1b c0 	cmpl   $0xc01b0e7c,-0x18(%ebp)
c01076b4:	75 cb                	jne    c0107681 <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c01076b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01076b9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01076bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076c4:	c7 04 24 0d d7 10 c0 	movl   $0xc010d70d,(%esp)
c01076cb:	e8 88 8c ff ff       	call   c0100358 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01076d0:	c7 04 24 27 d7 10 c0 	movl   $0xc010d727,(%esp)
c01076d7:	e8 7c 8c ff ff       	call   c0100358 <cprintf>
}
c01076dc:	83 c4 74             	add    $0x74,%esp
c01076df:	5b                   	pop    %ebx
c01076e0:	5d                   	pop    %ebp
c01076e1:	c3                   	ret    

c01076e2 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01076e2:	55                   	push   %ebp
c01076e3:	89 e5                	mov    %esp,%ebp
c01076e5:	83 ec 10             	sub    $0x10,%esp
c01076e8:	c7 45 fc 64 0f 1b c0 	movl   $0xc01b0f64,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01076ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01076f5:	89 50 04             	mov    %edx,0x4(%eax)
c01076f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076fb:	8b 50 04             	mov    0x4(%eax),%edx
c01076fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107701:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0107703:	8b 45 08             	mov    0x8(%ebp),%eax
c0107706:	c7 40 14 64 0f 1b c0 	movl   $0xc01b0f64,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c010770d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107712:	c9                   	leave  
c0107713:	c3                   	ret    

c0107714 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107714:	55                   	push   %ebp
c0107715:	89 e5                	mov    %esp,%ebp
c0107717:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c010771a:	8b 45 08             	mov    0x8(%ebp),%eax
c010771d:	8b 40 14             	mov    0x14(%eax),%eax
c0107720:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107723:	8b 45 10             	mov    0x10(%ebp),%eax
c0107726:	83 c0 14             	add    $0x14,%eax
c0107729:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010772c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107730:	74 06                	je     c0107738 <_fifo_map_swappable+0x24>
c0107732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107736:	75 24                	jne    c010775c <_fifo_map_swappable+0x48>
c0107738:	c7 44 24 0c 40 d7 10 	movl   $0xc010d740,0xc(%esp)
c010773f:	c0 
c0107740:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107747:	c0 
c0107748:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010774f:	00 
c0107750:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107757:	e8 7e 96 ff ff       	call   c0100dda <__panic>
c010775c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010775f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107762:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107765:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107768:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010776b:	8b 40 04             	mov    0x4(%eax),%eax
c010776e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107771:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107774:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107777:	89 55 e0             	mov    %edx,-0x20(%ebp)
c010777a:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010777d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107783:	89 10                	mov    %edx,(%eax)
c0107785:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107788:	8b 10                	mov    (%eax),%edx
c010778a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010778d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107793:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107796:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010779c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010779f:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2013011303*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
c01077a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01077a6:	c9                   	leave  
c01077a7:	c3                   	ret    

c01077a8 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01077a8:	55                   	push   %ebp
c01077a9:	89 e5                	mov    %esp,%ebp
c01077ab:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01077ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01077b1:	8b 40 14             	mov    0x14(%eax),%eax
c01077b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c01077b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077bb:	75 24                	jne    c01077e1 <_fifo_swap_out_victim+0x39>
c01077bd:	c7 44 24 0c 87 d7 10 	movl   $0xc010d787,0xc(%esp)
c01077c4:	c0 
c01077c5:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c01077cc:	c0 
c01077cd:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c01077d4:	00 
c01077d5:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c01077dc:	e8 f9 95 ff ff       	call   c0100dda <__panic>
     assert(in_tick==0);
c01077e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01077e5:	74 24                	je     c010780b <_fifo_swap_out_victim+0x63>
c01077e7:	c7 44 24 0c 94 d7 10 	movl   $0xc010d794,0xc(%esp)
c01077ee:	c0 
c01077ef:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c01077f6:	c0 
c01077f7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01077fe:	00 
c01077ff:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107806:	e8 cf 95 ff ff       	call   c0100dda <__panic>
c010780b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010780e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0107811:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107814:	8b 00                	mov    (%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2013011303*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = list_prev(head);
c0107816:	89 45 f0             	mov    %eax,-0x10(%ebp)
     *ptr_page = le2page(le, pra_page_link);
c0107819:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010781c:	8d 50 ec             	lea    -0x14(%eax),%edx
c010781f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107822:	89 10                	mov    %edx,(%eax)
c0107824:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107827:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010782a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010782d:	8b 40 04             	mov    0x4(%eax),%eax
c0107830:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107833:	8b 12                	mov    (%edx),%edx
c0107835:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107838:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010783b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010783e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107841:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107844:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107847:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010784a:	89 10                	mov    %edx,(%eax)
     list_del(le);
     return 0;
c010784c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107851:	c9                   	leave  
c0107852:	c3                   	ret    

c0107853 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107853:	55                   	push   %ebp
c0107854:	89 e5                	mov    %esp,%ebp
c0107856:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107859:	c7 04 24 a0 d7 10 c0 	movl   $0xc010d7a0,(%esp)
c0107860:	e8 f3 8a ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107865:	b8 00 30 00 00       	mov    $0x3000,%eax
c010786a:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c010786d:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107872:	83 f8 04             	cmp    $0x4,%eax
c0107875:	74 24                	je     c010789b <_fifo_check_swap+0x48>
c0107877:	c7 44 24 0c c6 d7 10 	movl   $0xc010d7c6,0xc(%esp)
c010787e:	c0 
c010787f:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107886:	c0 
c0107887:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c010788e:	00 
c010788f:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107896:	e8 3f 95 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010789b:	c7 04 24 d8 d7 10 c0 	movl   $0xc010d7d8,(%esp)
c01078a2:	e8 b1 8a ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01078a7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01078ac:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c01078af:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c01078b4:	83 f8 04             	cmp    $0x4,%eax
c01078b7:	74 24                	je     c01078dd <_fifo_check_swap+0x8a>
c01078b9:	c7 44 24 0c c6 d7 10 	movl   $0xc010d7c6,0xc(%esp)
c01078c0:	c0 
c01078c1:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c01078c8:	c0 
c01078c9:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c01078d0:	00 
c01078d1:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c01078d8:	e8 fd 94 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01078dd:	c7 04 24 00 d8 10 c0 	movl   $0xc010d800,(%esp)
c01078e4:	e8 6f 8a ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01078e9:	b8 00 40 00 00       	mov    $0x4000,%eax
c01078ee:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01078f1:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c01078f6:	83 f8 04             	cmp    $0x4,%eax
c01078f9:	74 24                	je     c010791f <_fifo_check_swap+0xcc>
c01078fb:	c7 44 24 0c c6 d7 10 	movl   $0xc010d7c6,0xc(%esp)
c0107902:	c0 
c0107903:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c010790a:	c0 
c010790b:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107912:	00 
c0107913:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c010791a:	e8 bb 94 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010791f:	c7 04 24 28 d8 10 c0 	movl   $0xc010d828,(%esp)
c0107926:	e8 2d 8a ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010792b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107930:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107933:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107938:	83 f8 04             	cmp    $0x4,%eax
c010793b:	74 24                	je     c0107961 <_fifo_check_swap+0x10e>
c010793d:	c7 44 24 0c c6 d7 10 	movl   $0xc010d7c6,0xc(%esp)
c0107944:	c0 
c0107945:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c010794c:	c0 
c010794d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0107954:	00 
c0107955:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c010795c:	e8 79 94 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107961:	c7 04 24 50 d8 10 c0 	movl   $0xc010d850,(%esp)
c0107968:	e8 eb 89 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c010796d:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107972:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107975:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c010797a:	83 f8 05             	cmp    $0x5,%eax
c010797d:	74 24                	je     c01079a3 <_fifo_check_swap+0x150>
c010797f:	c7 44 24 0c 76 d8 10 	movl   $0xc010d876,0xc(%esp)
c0107986:	c0 
c0107987:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c010798e:	c0 
c010798f:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0107996:	00 
c0107997:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c010799e:	e8 37 94 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01079a3:	c7 04 24 28 d8 10 c0 	movl   $0xc010d828,(%esp)
c01079aa:	e8 a9 89 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01079af:	b8 00 20 00 00       	mov    $0x2000,%eax
c01079b4:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c01079b7:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c01079bc:	83 f8 05             	cmp    $0x5,%eax
c01079bf:	74 24                	je     c01079e5 <_fifo_check_swap+0x192>
c01079c1:	c7 44 24 0c 76 d8 10 	movl   $0xc010d876,0xc(%esp)
c01079c8:	c0 
c01079c9:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c01079d0:	c0 
c01079d1:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c01079d8:	00 
c01079d9:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c01079e0:	e8 f5 93 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01079e5:	c7 04 24 d8 d7 10 c0 	movl   $0xc010d7d8,(%esp)
c01079ec:	e8 67 89 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01079f1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01079f6:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01079f9:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c01079fe:	83 f8 06             	cmp    $0x6,%eax
c0107a01:	74 24                	je     c0107a27 <_fifo_check_swap+0x1d4>
c0107a03:	c7 44 24 0c 85 d8 10 	movl   $0xc010d885,0xc(%esp)
c0107a0a:	c0 
c0107a0b:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107a12:	c0 
c0107a13:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107a1a:	00 
c0107a1b:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107a22:	e8 b3 93 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107a27:	c7 04 24 28 d8 10 c0 	movl   $0xc010d828,(%esp)
c0107a2e:	e8 25 89 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107a33:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107a38:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107a3b:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107a40:	83 f8 07             	cmp    $0x7,%eax
c0107a43:	74 24                	je     c0107a69 <_fifo_check_swap+0x216>
c0107a45:	c7 44 24 0c 94 d8 10 	movl   $0xc010d894,0xc(%esp)
c0107a4c:	c0 
c0107a4d:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107a54:	c0 
c0107a55:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107a5c:	00 
c0107a5d:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107a64:	e8 71 93 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107a69:	c7 04 24 a0 d7 10 c0 	movl   $0xc010d7a0,(%esp)
c0107a70:	e8 e3 88 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107a75:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107a7a:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107a7d:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107a82:	83 f8 08             	cmp    $0x8,%eax
c0107a85:	74 24                	je     c0107aab <_fifo_check_swap+0x258>
c0107a87:	c7 44 24 0c a3 d8 10 	movl   $0xc010d8a3,0xc(%esp)
c0107a8e:	c0 
c0107a8f:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107a96:	c0 
c0107a97:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107a9e:	00 
c0107a9f:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107aa6:	e8 2f 93 ff ff       	call   c0100dda <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107aab:	c7 04 24 00 d8 10 c0 	movl   $0xc010d800,(%esp)
c0107ab2:	e8 a1 88 ff ff       	call   c0100358 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107ab7:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107abc:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107abf:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0107ac4:	83 f8 09             	cmp    $0x9,%eax
c0107ac7:	74 24                	je     c0107aed <_fifo_check_swap+0x29a>
c0107ac9:	c7 44 24 0c b2 d8 10 	movl   $0xc010d8b2,0xc(%esp)
c0107ad0:	c0 
c0107ad1:	c7 44 24 08 5e d7 10 	movl   $0xc010d75e,0x8(%esp)
c0107ad8:	c0 
c0107ad9:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107ae0:	00 
c0107ae1:	c7 04 24 73 d7 10 c0 	movl   $0xc010d773,(%esp)
c0107ae8:	e8 ed 92 ff ff       	call   c0100dda <__panic>
    return 0;
c0107aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107af2:	c9                   	leave  
c0107af3:	c3                   	ret    

c0107af4 <_fifo_init>:


static int
_fifo_init(void)
{
c0107af4:	55                   	push   %ebp
c0107af5:	89 e5                	mov    %esp,%ebp
    return 0;
c0107af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107afc:	5d                   	pop    %ebp
c0107afd:	c3                   	ret    

c0107afe <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107afe:	55                   	push   %ebp
c0107aff:	89 e5                	mov    %esp,%ebp
    return 0;
c0107b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b06:	5d                   	pop    %ebp
c0107b07:	c3                   	ret    

c0107b08 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107b08:	55                   	push   %ebp
c0107b09:	89 e5                	mov    %esp,%ebp
c0107b0b:	b8 00 00 00 00       	mov    $0x0,%eax
c0107b10:	5d                   	pop    %ebp
c0107b11:	c3                   	ret    

c0107b12 <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107b12:	55                   	push   %ebp
c0107b13:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107b15:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107b1e:	5d                   	pop    %ebp
c0107b1f:	c3                   	ret    

c0107b20 <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107b20:	55                   	push   %ebp
c0107b21:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b26:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107b29:	5d                   	pop    %ebp
c0107b2a:	c3                   	ret    

c0107b2b <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107b2b:	55                   	push   %ebp
c0107b2c:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b31:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107b34:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107b37:	5d                   	pop    %ebp
c0107b38:	c3                   	ret    

c0107b39 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107b39:	55                   	push   %ebp
c0107b3a:	89 e5                	mov    %esp,%ebp
c0107b3c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b42:	c1 e8 0c             	shr    $0xc,%eax
c0107b45:	89 c2                	mov    %eax,%edx
c0107b47:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0107b4c:	39 c2                	cmp    %eax,%edx
c0107b4e:	72 1c                	jb     c0107b6c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107b50:	c7 44 24 08 d4 d8 10 	movl   $0xc010d8d4,0x8(%esp)
c0107b57:	c0 
c0107b58:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107b5f:	00 
c0107b60:	c7 04 24 f3 d8 10 c0 	movl   $0xc010d8f3,(%esp)
c0107b67:	e8 6e 92 ff ff       	call   c0100dda <__panic>
    }
    return &pages[PPN(pa)];
c0107b6c:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0107b71:	8b 55 08             	mov    0x8(%ebp),%edx
c0107b74:	c1 ea 0c             	shr    $0xc,%edx
c0107b77:	c1 e2 05             	shl    $0x5,%edx
c0107b7a:	01 d0                	add    %edx,%eax
}
c0107b7c:	c9                   	leave  
c0107b7d:	c3                   	ret    

c0107b7e <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0107b7e:	55                   	push   %ebp
c0107b7f:	89 e5                	mov    %esp,%ebp
c0107b81:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107b8c:	89 04 24             	mov    %eax,(%esp)
c0107b8f:	e8 a5 ff ff ff       	call   c0107b39 <pa2page>
}
c0107b94:	c9                   	leave  
c0107b95:	c3                   	ret    

c0107b96 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107b96:	55                   	push   %ebp
c0107b97:	89 e5                	mov    %esp,%ebp
c0107b99:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107b9c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107ba3:	e8 fa cd ff ff       	call   c01049a2 <kmalloc>
c0107ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107baf:	74 79                	je     c0107c2a <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107bbd:	89 50 04             	mov    %edx,0x4(%eax)
c0107bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bc3:	8b 50 04             	mov    0x4(%eax),%edx
c0107bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bc9:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bd8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107be2:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107be9:	a1 0c ee 1a c0       	mov    0xc01aee0c,%eax
c0107bee:	85 c0                	test   %eax,%eax
c0107bf0:	74 0d                	je     c0107bff <mm_create+0x69>
c0107bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bf5:	89 04 24             	mov    %eax,(%esp)
c0107bf8:	e8 a8 ef ff ff       	call   c0106ba5 <swap_init_mm>
c0107bfd:	eb 0a                	jmp    c0107c09 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c02:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0107c09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107c10:	00 
c0107c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c14:	89 04 24             	mov    %eax,(%esp)
c0107c17:	e8 0f ff ff ff       	call   c0107b2b <set_mm_count>
        lock_init(&(mm->mm_lock));
c0107c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c1f:	83 c0 1c             	add    $0x1c,%eax
c0107c22:	89 04 24             	mov    %eax,(%esp)
c0107c25:	e8 e8 fe ff ff       	call   c0107b12 <lock_init>
    }    
    return mm;
c0107c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107c2d:	c9                   	leave  
c0107c2e:	c3                   	ret    

c0107c2f <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107c2f:	55                   	push   %ebp
c0107c30:	89 e5                	mov    %esp,%ebp
c0107c32:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107c35:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107c3c:	e8 61 cd ff ff       	call   c01049a2 <kmalloc>
c0107c41:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107c44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107c48:	74 1b                	je     c0107c65 <vma_create+0x36>
        vma->vm_start = vm_start;
c0107c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c4d:	8b 55 08             	mov    0x8(%ebp),%edx
c0107c50:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c56:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107c59:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c5f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c62:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107c68:	c9                   	leave  
c0107c69:	c3                   	ret    

c0107c6a <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107c6a:	55                   	push   %ebp
c0107c6b:	89 e5                	mov    %esp,%ebp
c0107c6d:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107c70:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107c77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107c7b:	0f 84 95 00 00 00    	je     c0107d16 <find_vma+0xac>
        vma = mm->mmap_cache;
c0107c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c84:	8b 40 08             	mov    0x8(%eax),%eax
c0107c87:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107c8a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107c8e:	74 16                	je     c0107ca6 <find_vma+0x3c>
c0107c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107c93:	8b 40 04             	mov    0x4(%eax),%eax
c0107c96:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107c99:	77 0b                	ja     c0107ca6 <find_vma+0x3c>
c0107c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107c9e:	8b 40 08             	mov    0x8(%eax),%eax
c0107ca1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ca4:	77 61                	ja     c0107d07 <find_vma+0x9d>
                bool found = 0;
c0107ca6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107cad:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107cb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107cb9:	eb 28                	jmp    c0107ce3 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cbe:	83 e8 10             	sub    $0x10,%eax
c0107cc1:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cc7:	8b 40 04             	mov    0x4(%eax),%eax
c0107cca:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107ccd:	77 14                	ja     c0107ce3 <find_vma+0x79>
c0107ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cd2:	8b 40 08             	mov    0x8(%eax),%eax
c0107cd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107cd8:	76 09                	jbe    c0107ce3 <find_vma+0x79>
                        found = 1;
c0107cda:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107ce1:	eb 17                	jmp    c0107cfa <find_vma+0x90>
c0107ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107ce9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107cec:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cf5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107cf8:	75 c1                	jne    c0107cbb <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107cfa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107cfe:	75 07                	jne    c0107d07 <find_vma+0x9d>
                    vma = NULL;
c0107d00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107d07:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107d0b:	74 09                	je     c0107d16 <find_vma+0xac>
            mm->mmap_cache = vma;
c0107d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d10:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107d13:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107d16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107d19:	c9                   	leave  
c0107d1a:	c3                   	ret    

c0107d1b <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107d1b:	55                   	push   %ebp
c0107d1c:	89 e5                	mov    %esp,%ebp
c0107d1e:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107d21:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d24:	8b 50 04             	mov    0x4(%eax),%edx
c0107d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d2a:	8b 40 08             	mov    0x8(%eax),%eax
c0107d2d:	39 c2                	cmp    %eax,%edx
c0107d2f:	72 24                	jb     c0107d55 <check_vma_overlap+0x3a>
c0107d31:	c7 44 24 0c 01 d9 10 	movl   $0xc010d901,0xc(%esp)
c0107d38:	c0 
c0107d39:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0107d40:	c0 
c0107d41:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107d48:	00 
c0107d49:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0107d50:	e8 85 90 ff ff       	call   c0100dda <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d58:	8b 50 08             	mov    0x8(%eax),%edx
c0107d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d5e:	8b 40 04             	mov    0x4(%eax),%eax
c0107d61:	39 c2                	cmp    %eax,%edx
c0107d63:	76 24                	jbe    c0107d89 <check_vma_overlap+0x6e>
c0107d65:	c7 44 24 0c 44 d9 10 	movl   $0xc010d944,0xc(%esp)
c0107d6c:	c0 
c0107d6d:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0107d74:	c0 
c0107d75:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107d7c:	00 
c0107d7d:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0107d84:	e8 51 90 ff ff       	call   c0100dda <__panic>
    assert(next->vm_start < next->vm_end);
c0107d89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d8c:	8b 50 04             	mov    0x4(%eax),%edx
c0107d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107d92:	8b 40 08             	mov    0x8(%eax),%eax
c0107d95:	39 c2                	cmp    %eax,%edx
c0107d97:	72 24                	jb     c0107dbd <check_vma_overlap+0xa2>
c0107d99:	c7 44 24 0c 63 d9 10 	movl   $0xc010d963,0xc(%esp)
c0107da0:	c0 
c0107da1:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0107da8:	c0 
c0107da9:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107db0:	00 
c0107db1:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0107db8:	e8 1d 90 ff ff       	call   c0100dda <__panic>
}
c0107dbd:	c9                   	leave  
c0107dbe:	c3                   	ret    

c0107dbf <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107dbf:	55                   	push   %ebp
c0107dc0:	89 e5                	mov    %esp,%ebp
c0107dc2:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dc8:	8b 50 04             	mov    0x4(%eax),%edx
c0107dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dce:	8b 40 08             	mov    0x8(%eax),%eax
c0107dd1:	39 c2                	cmp    %eax,%edx
c0107dd3:	72 24                	jb     c0107df9 <insert_vma_struct+0x3a>
c0107dd5:	c7 44 24 0c 81 d9 10 	movl   $0xc010d981,0xc(%esp)
c0107ddc:	c0 
c0107ddd:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0107de4:	c0 
c0107de5:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107dec:	00 
c0107ded:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0107df4:	e8 e1 8f ff ff       	call   c0100dda <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107df9:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e02:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107e0b:	eb 21                	jmp    c0107e2e <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e10:	83 e8 10             	sub    $0x10,%eax
c0107e13:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107e16:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e19:	8b 50 04             	mov    0x4(%eax),%edx
c0107e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e1f:	8b 40 04             	mov    0x4(%eax),%eax
c0107e22:	39 c2                	cmp    %eax,%edx
c0107e24:	76 02                	jbe    c0107e28 <insert_vma_struct+0x69>
                break;
c0107e26:	eb 1d                	jmp    c0107e45 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e31:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107e34:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107e37:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107e43:	75 c8                	jne    c0107e0d <insert_vma_struct+0x4e>
c0107e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e48:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107e4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107e4e:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e57:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107e5a:	74 15                	je     c0107e71 <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e5f:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107e62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e69:	89 14 24             	mov    %edx,(%esp)
c0107e6c:	e8 aa fe ff ff       	call   c0107d1b <check_vma_overlap>
    }
    if (le_next != list) {
c0107e71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107e77:	74 15                	je     c0107e8e <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107e79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107e7c:	83 e8 10             	sub    $0x10,%eax
c0107e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e83:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e86:	89 04 24             	mov    %eax,(%esp)
c0107e89:	e8 8d fe ff ff       	call   c0107d1b <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e91:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e94:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107e96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e99:	8d 50 10             	lea    0x10(%eax),%edx
c0107e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107ea2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107ea5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107ea8:	8b 40 04             	mov    0x4(%eax),%eax
c0107eab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107eae:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107eb1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107eb4:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107eb7:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107eba:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107ebd:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107ec0:	89 10                	mov    %edx,(%eax)
c0107ec2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107ec5:	8b 10                	mov    (%eax),%edx
c0107ec7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107eca:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107ecd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ed0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107ed3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107ed6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ed9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107edc:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ee1:	8b 40 10             	mov    0x10(%eax),%eax
c0107ee4:	8d 50 01             	lea    0x1(%eax),%edx
c0107ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107eea:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107eed:	c9                   	leave  
c0107eee:	c3                   	ret    

c0107eef <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107eef:	55                   	push   %ebp
c0107ef0:	89 e5                	mov    %esp,%ebp
c0107ef2:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c0107ef5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ef8:	89 04 24             	mov    %eax,(%esp)
c0107efb:	e8 20 fc ff ff       	call   c0107b20 <mm_count>
c0107f00:	85 c0                	test   %eax,%eax
c0107f02:	74 24                	je     c0107f28 <mm_destroy+0x39>
c0107f04:	c7 44 24 0c 9d d9 10 	movl   $0xc010d99d,0xc(%esp)
c0107f0b:	c0 
c0107f0c:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0107f13:	c0 
c0107f14:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0107f1b:	00 
c0107f1c:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0107f23:	e8 b2 8e ff ff       	call   c0100dda <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c0107f28:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107f2e:	eb 36                	jmp    c0107f66 <mm_destroy+0x77>
c0107f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f33:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107f39:	8b 40 04             	mov    0x4(%eax),%eax
c0107f3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f3f:	8b 12                	mov    (%edx),%edx
c0107f41:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f4a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107f4d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107f50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f53:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107f56:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f5b:	83 e8 10             	sub    $0x10,%eax
c0107f5e:	89 04 24             	mov    %eax,(%esp)
c0107f61:	e8 57 ca ff ff       	call   c01049bd <kfree>
c0107f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f69:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107f6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f6f:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107f7b:	75 b3                	jne    c0107f30 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107f7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f80:	89 04 24             	mov    %eax,(%esp)
c0107f83:	e8 35 ca ff ff       	call   c01049bd <kfree>
    mm=NULL;
c0107f88:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107f8f:	c9                   	leave  
c0107f90:	c3                   	ret    

c0107f91 <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c0107f91:	55                   	push   %ebp
c0107f92:	89 e5                	mov    %esp,%ebp
c0107f94:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c0107f97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107fa0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107fa8:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0107faf:	8b 45 10             	mov    0x10(%ebp),%eax
c0107fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107fb5:	01 c2                	add    %eax,%edx
c0107fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fba:	01 d0                	add    %edx,%eax
c0107fbc:	83 e8 01             	sub    $0x1,%eax
c0107fbf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fc5:	ba 00 00 00 00       	mov    $0x0,%edx
c0107fca:	f7 75 e8             	divl   -0x18(%ebp)
c0107fcd:	89 d0                	mov    %edx,%eax
c0107fcf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107fd2:	29 c2                	sub    %eax,%edx
c0107fd4:	89 d0                	mov    %edx,%eax
c0107fd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c0107fd9:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c0107fe0:	76 11                	jbe    c0107ff3 <mm_map+0x62>
c0107fe2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107fe5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107fe8:	73 09                	jae    c0107ff3 <mm_map+0x62>
c0107fea:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c0107ff1:	76 0a                	jbe    c0107ffd <mm_map+0x6c>
        return -E_INVAL;
c0107ff3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0107ff8:	e9 ae 00 00 00       	jmp    c01080ab <mm_map+0x11a>
    }

    assert(mm != NULL);
c0107ffd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108001:	75 24                	jne    c0108027 <mm_map+0x96>
c0108003:	c7 44 24 0c af d9 10 	movl   $0xc010d9af,0xc(%esp)
c010800a:	c0 
c010800b:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108012:	c0 
c0108013:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c010801a:	00 
c010801b:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108022:	e8 b3 8d ff ff       	call   c0100dda <__panic>

    int ret = -E_INVAL;
c0108027:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c010802e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108031:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108035:	8b 45 08             	mov    0x8(%ebp),%eax
c0108038:	89 04 24             	mov    %eax,(%esp)
c010803b:	e8 2a fc ff ff       	call   c0107c6a <find_vma>
c0108040:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108043:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108047:	74 0d                	je     c0108056 <mm_map+0xc5>
c0108049:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010804c:	8b 40 04             	mov    0x4(%eax),%eax
c010804f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108052:	73 02                	jae    c0108056 <mm_map+0xc5>
        goto out;
c0108054:	eb 52                	jmp    c01080a8 <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c0108056:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c010805d:	8b 45 14             	mov    0x14(%ebp),%eax
c0108060:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108064:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108067:	89 44 24 04          	mov    %eax,0x4(%esp)
c010806b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010806e:	89 04 24             	mov    %eax,(%esp)
c0108071:	e8 b9 fb ff ff       	call   c0107c2f <vma_create>
c0108076:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108079:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010807d:	75 02                	jne    c0108081 <mm_map+0xf0>
        goto out;
c010807f:	eb 27                	jmp    c01080a8 <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c0108081:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108084:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108088:	8b 45 08             	mov    0x8(%ebp),%eax
c010808b:	89 04 24             	mov    %eax,(%esp)
c010808e:	e8 2c fd ff ff       	call   c0107dbf <insert_vma_struct>
    if (vma_store != NULL) {
c0108093:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0108097:	74 08                	je     c01080a1 <mm_map+0x110>
        *vma_store = vma;
c0108099:	8b 45 18             	mov    0x18(%ebp),%eax
c010809c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010809f:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c01080a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c01080a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01080ab:	c9                   	leave  
c01080ac:	c3                   	ret    

c01080ad <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c01080ad:	55                   	push   %ebp
c01080ae:	89 e5                	mov    %esp,%ebp
c01080b0:	56                   	push   %esi
c01080b1:	53                   	push   %ebx
c01080b2:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c01080b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01080b9:	74 06                	je     c01080c1 <dup_mmap+0x14>
c01080bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01080bf:	75 24                	jne    c01080e5 <dup_mmap+0x38>
c01080c1:	c7 44 24 0c ba d9 10 	movl   $0xc010d9ba,0xc(%esp)
c01080c8:	c0 
c01080c9:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01080d0:	c0 
c01080d1:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01080d8:	00 
c01080d9:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01080e0:	e8 f5 8c ff ff       	call   c0100dda <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c01080e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01080e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c01080f1:	e9 92 00 00 00       	jmp    c0108188 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c01080f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080f9:	83 e8 10             	sub    $0x10,%eax
c01080fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c01080ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108102:	8b 48 0c             	mov    0xc(%eax),%ecx
c0108105:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108108:	8b 50 08             	mov    0x8(%eax),%edx
c010810b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010810e:	8b 40 04             	mov    0x4(%eax),%eax
c0108111:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108115:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108119:	89 04 24             	mov    %eax,(%esp)
c010811c:	e8 0e fb ff ff       	call   c0107c2f <vma_create>
c0108121:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c0108124:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108128:	75 07                	jne    c0108131 <dup_mmap+0x84>
            return -E_NO_MEM;
c010812a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010812f:	eb 76                	jmp    c01081a7 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c0108131:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108134:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108138:	8b 45 08             	mov    0x8(%ebp),%eax
c010813b:	89 04 24             	mov    %eax,(%esp)
c010813e:	e8 7c fc ff ff       	call   c0107dbf <insert_vma_struct>

        bool share = 0;
c0108143:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c010814a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010814d:	8b 58 08             	mov    0x8(%eax),%ebx
c0108150:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108153:	8b 48 04             	mov    0x4(%eax),%ecx
c0108156:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108159:	8b 50 0c             	mov    0xc(%eax),%edx
c010815c:	8b 45 08             	mov    0x8(%ebp),%eax
c010815f:	8b 40 0c             	mov    0xc(%eax),%eax
c0108162:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c0108165:	89 74 24 10          	mov    %esi,0x10(%esp)
c0108169:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010816d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108171:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108175:	89 04 24             	mov    %eax,(%esp)
c0108178:	e8 f8 d7 ff ff       	call   c0105975 <copy_range>
c010817d:	85 c0                	test   %eax,%eax
c010817f:	74 07                	je     c0108188 <dup_mmap+0xdb>
            return -E_NO_MEM;
c0108181:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108186:	eb 1f                	jmp    c01081a7 <dup_mmap+0xfa>
c0108188:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010818b:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010818e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108191:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c0108193:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108196:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108199:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010819c:	0f 85 54 ff ff ff    	jne    c01080f6 <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c01081a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01081a7:	83 c4 40             	add    $0x40,%esp
c01081aa:	5b                   	pop    %ebx
c01081ab:	5e                   	pop    %esi
c01081ac:	5d                   	pop    %ebp
c01081ad:	c3                   	ret    

c01081ae <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c01081ae:	55                   	push   %ebp
c01081af:	89 e5                	mov    %esp,%ebp
c01081b1:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c01081b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01081b8:	74 0f                	je     c01081c9 <exit_mmap+0x1b>
c01081ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01081bd:	89 04 24             	mov    %eax,(%esp)
c01081c0:	e8 5b f9 ff ff       	call   c0107b20 <mm_count>
c01081c5:	85 c0                	test   %eax,%eax
c01081c7:	74 24                	je     c01081ed <exit_mmap+0x3f>
c01081c9:	c7 44 24 0c d8 d9 10 	movl   $0xc010d9d8,0xc(%esp)
c01081d0:	c0 
c01081d1:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01081d8:	c0 
c01081d9:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01081e0:	00 
c01081e1:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01081e8:	e8 ed 8b ff ff       	call   c0100dda <__panic>
    pde_t *pgdir = mm->pgdir;
c01081ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01081f0:	8b 40 0c             	mov    0xc(%eax),%eax
c01081f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c01081f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01081f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01081fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c0108202:	eb 28                	jmp    c010822c <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108207:	83 e8 10             	sub    $0x10,%eax
c010820a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c010820d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108210:	8b 50 08             	mov    0x8(%eax),%edx
c0108213:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108216:	8b 40 04             	mov    0x4(%eax),%eax
c0108219:	89 54 24 08          	mov    %edx,0x8(%esp)
c010821d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108221:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108224:	89 04 24             	mov    %eax,(%esp)
c0108227:	e8 4e d5 ff ff       	call   c010577a <unmap_range>
c010822c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010822f:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108232:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108235:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c0108238:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010823b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010823e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108241:	75 c1                	jne    c0108204 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108243:	eb 28                	jmp    c010826d <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c0108245:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108248:	83 e8 10             	sub    $0x10,%eax
c010824b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c010824e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108251:	8b 50 08             	mov    0x8(%eax),%edx
c0108254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108257:	8b 40 04             	mov    0x4(%eax),%eax
c010825a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010825e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108262:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108265:	89 04 24             	mov    %eax,(%esp)
c0108268:	e8 01 d6 ff ff       	call   c010586e <exit_range>
c010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108270:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108273:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108276:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108279:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010827c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010827f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108282:	75 c1                	jne    c0108245 <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c0108284:	c9                   	leave  
c0108285:	c3                   	ret    

c0108286 <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c0108286:	55                   	push   %ebp
c0108287:	89 e5                	mov    %esp,%ebp
c0108289:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c010828c:	8b 45 10             	mov    0x10(%ebp),%eax
c010828f:	8b 55 18             	mov    0x18(%ebp),%edx
c0108292:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108296:	8b 55 14             	mov    0x14(%ebp),%edx
c0108299:	89 54 24 08          	mov    %edx,0x8(%esp)
c010829d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01082a4:	89 04 24             	mov    %eax,(%esp)
c01082a7:	e8 79 09 00 00       	call   c0108c25 <user_mem_check>
c01082ac:	85 c0                	test   %eax,%eax
c01082ae:	75 07                	jne    c01082b7 <copy_from_user+0x31>
        return 0;
c01082b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01082b5:	eb 1e                	jmp    c01082d5 <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c01082b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01082ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082be:	8b 45 10             	mov    0x10(%ebp),%eax
c01082c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082c8:	89 04 24             	mov    %eax,(%esp)
c01082cb:	e8 2b 3b 00 00       	call   c010bdfb <memcpy>
    return 1;
c01082d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
c01082d5:	c9                   	leave  
c01082d6:	c3                   	ret    

c01082d7 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c01082d7:	55                   	push   %ebp
c01082d8:	89 e5                	mov    %esp,%ebp
c01082da:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c01082dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082e0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c01082e7:	00 
c01082e8:	8b 55 14             	mov    0x14(%ebp),%edx
c01082eb:	89 54 24 08          	mov    %edx,0x8(%esp)
c01082ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01082f6:	89 04 24             	mov    %eax,(%esp)
c01082f9:	e8 27 09 00 00       	call   c0108c25 <user_mem_check>
c01082fe:	85 c0                	test   %eax,%eax
c0108300:	75 07                	jne    c0108309 <copy_to_user+0x32>
        return 0;
c0108302:	b8 00 00 00 00       	mov    $0x0,%eax
c0108307:	eb 1e                	jmp    c0108327 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c0108309:	8b 45 14             	mov    0x14(%ebp),%eax
c010830c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108310:	8b 45 10             	mov    0x10(%ebp),%eax
c0108313:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108317:	8b 45 0c             	mov    0xc(%ebp),%eax
c010831a:	89 04 24             	mov    %eax,(%esp)
c010831d:	e8 d9 3a 00 00       	call   c010bdfb <memcpy>
    return 1;
c0108322:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108327:	c9                   	leave  
c0108328:	c3                   	ret    

c0108329 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0108329:	55                   	push   %ebp
c010832a:	89 e5                	mov    %esp,%ebp
c010832c:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010832f:	e8 02 00 00 00       	call   c0108336 <check_vmm>
}
c0108334:	c9                   	leave  
c0108335:	c3                   	ret    

c0108336 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0108336:	55                   	push   %ebp
c0108337:	89 e5                	mov    %esp,%ebp
c0108339:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010833c:	e8 73 cb ff ff       	call   c0104eb4 <nr_free_pages>
c0108341:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0108344:	e8 13 00 00 00       	call   c010835c <check_vma_struct>
    check_pgfault();
c0108349:	e8 a7 04 00 00       	call   c01087f5 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c010834e:	c7 04 24 f8 d9 10 c0 	movl   $0xc010d9f8,(%esp)
c0108355:	e8 fe 7f ff ff       	call   c0100358 <cprintf>
}
c010835a:	c9                   	leave  
c010835b:	c3                   	ret    

c010835c <check_vma_struct>:

static void
check_vma_struct(void) {
c010835c:	55                   	push   %ebp
c010835d:	89 e5                	mov    %esp,%ebp
c010835f:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108362:	e8 4d cb ff ff       	call   c0104eb4 <nr_free_pages>
c0108367:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c010836a:	e8 27 f8 ff ff       	call   c0107b96 <mm_create>
c010836f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0108372:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108376:	75 24                	jne    c010839c <check_vma_struct+0x40>
c0108378:	c7 44 24 0c af d9 10 	movl   $0xc010d9af,0xc(%esp)
c010837f:	c0 
c0108380:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108387:	c0 
c0108388:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010838f:	00 
c0108390:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108397:	e8 3e 8a ff ff       	call   c0100dda <__panic>

    int step1 = 10, step2 = step1 * 10;
c010839c:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01083a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01083a6:	89 d0                	mov    %edx,%eax
c01083a8:	c1 e0 02             	shl    $0x2,%eax
c01083ab:	01 d0                	add    %edx,%eax
c01083ad:	01 c0                	add    %eax,%eax
c01083af:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01083b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01083b8:	eb 70                	jmp    c010842a <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01083ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083bd:	89 d0                	mov    %edx,%eax
c01083bf:	c1 e0 02             	shl    $0x2,%eax
c01083c2:	01 d0                	add    %edx,%eax
c01083c4:	83 c0 02             	add    $0x2,%eax
c01083c7:	89 c1                	mov    %eax,%ecx
c01083c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083cc:	89 d0                	mov    %edx,%eax
c01083ce:	c1 e0 02             	shl    $0x2,%eax
c01083d1:	01 d0                	add    %edx,%eax
c01083d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01083da:	00 
c01083db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01083df:	89 04 24             	mov    %eax,(%esp)
c01083e2:	e8 48 f8 ff ff       	call   c0107c2f <vma_create>
c01083e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01083ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01083ee:	75 24                	jne    c0108414 <check_vma_struct+0xb8>
c01083f0:	c7 44 24 0c 10 da 10 	movl   $0xc010da10,0xc(%esp)
c01083f7:	c0 
c01083f8:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01083ff:	c0 
c0108400:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108407:	00 
c0108408:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010840f:	e8 c6 89 ff ff       	call   c0100dda <__panic>
        insert_vma_struct(mm, vma);
c0108414:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108417:	89 44 24 04          	mov    %eax,0x4(%esp)
c010841b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010841e:	89 04 24             	mov    %eax,(%esp)
c0108421:	e8 99 f9 ff ff       	call   c0107dbf <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0108426:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010842a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010842e:	7f 8a                	jg     c01083ba <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108433:	83 c0 01             	add    $0x1,%eax
c0108436:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108439:	eb 70                	jmp    c01084ab <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c010843b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010843e:	89 d0                	mov    %edx,%eax
c0108440:	c1 e0 02             	shl    $0x2,%eax
c0108443:	01 d0                	add    %edx,%eax
c0108445:	83 c0 02             	add    $0x2,%eax
c0108448:	89 c1                	mov    %eax,%ecx
c010844a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010844d:	89 d0                	mov    %edx,%eax
c010844f:	c1 e0 02             	shl    $0x2,%eax
c0108452:	01 d0                	add    %edx,%eax
c0108454:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010845b:	00 
c010845c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0108460:	89 04 24             	mov    %eax,(%esp)
c0108463:	e8 c7 f7 ff ff       	call   c0107c2f <vma_create>
c0108468:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c010846b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010846f:	75 24                	jne    c0108495 <check_vma_struct+0x139>
c0108471:	c7 44 24 0c 10 da 10 	movl   $0xc010da10,0xc(%esp)
c0108478:	c0 
c0108479:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108480:	c0 
c0108481:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0108488:	00 
c0108489:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108490:	e8 45 89 ff ff       	call   c0100dda <__panic>
        insert_vma_struct(mm, vma);
c0108495:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108498:	89 44 24 04          	mov    %eax,0x4(%esp)
c010849c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010849f:	89 04 24             	mov    %eax,(%esp)
c01084a2:	e8 18 f9 ff ff       	call   c0107dbf <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01084a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01084ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01084ae:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01084b1:	7e 88                	jle    c010843b <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01084b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084b6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01084b9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01084bc:	8b 40 04             	mov    0x4(%eax),%eax
c01084bf:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01084c2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c01084c9:	e9 97 00 00 00       	jmp    c0108565 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c01084ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01084d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01084d4:	75 24                	jne    c01084fa <check_vma_struct+0x19e>
c01084d6:	c7 44 24 0c 1c da 10 	movl   $0xc010da1c,0xc(%esp)
c01084dd:	c0 
c01084de:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01084e5:	c0 
c01084e6:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01084ed:	00 
c01084ee:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01084f5:	e8 e0 88 ff ff       	call   c0100dda <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01084fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084fd:	83 e8 10             	sub    $0x10,%eax
c0108500:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108506:	8b 48 04             	mov    0x4(%eax),%ecx
c0108509:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010850c:	89 d0                	mov    %edx,%eax
c010850e:	c1 e0 02             	shl    $0x2,%eax
c0108511:	01 d0                	add    %edx,%eax
c0108513:	39 c1                	cmp    %eax,%ecx
c0108515:	75 17                	jne    c010852e <check_vma_struct+0x1d2>
c0108517:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010851a:	8b 48 08             	mov    0x8(%eax),%ecx
c010851d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108520:	89 d0                	mov    %edx,%eax
c0108522:	c1 e0 02             	shl    $0x2,%eax
c0108525:	01 d0                	add    %edx,%eax
c0108527:	83 c0 02             	add    $0x2,%eax
c010852a:	39 c1                	cmp    %eax,%ecx
c010852c:	74 24                	je     c0108552 <check_vma_struct+0x1f6>
c010852e:	c7 44 24 0c 34 da 10 	movl   $0xc010da34,0xc(%esp)
c0108535:	c0 
c0108536:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c010853d:	c0 
c010853e:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0108545:	00 
c0108546:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010854d:	e8 88 88 ff ff       	call   c0100dda <__panic>
c0108552:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108555:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0108558:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010855b:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010855e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0108561:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108565:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108568:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010856b:	0f 8e 5d ff ff ff    	jle    c01084ce <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108571:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0108578:	e9 cd 01 00 00       	jmp    c010874a <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108580:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108584:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108587:	89 04 24             	mov    %eax,(%esp)
c010858a:	e8 db f6 ff ff       	call   c0107c6a <find_vma>
c010858f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0108592:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0108596:	75 24                	jne    c01085bc <check_vma_struct+0x260>
c0108598:	c7 44 24 0c 69 da 10 	movl   $0xc010da69,0xc(%esp)
c010859f:	c0 
c01085a0:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01085a7:	c0 
c01085a8:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01085af:	00 
c01085b0:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01085b7:	e8 1e 88 ff ff       	call   c0100dda <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01085bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085bf:	83 c0 01             	add    $0x1,%eax
c01085c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085c9:	89 04 24             	mov    %eax,(%esp)
c01085cc:	e8 99 f6 ff ff       	call   c0107c6a <find_vma>
c01085d1:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01085d4:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01085d8:	75 24                	jne    c01085fe <check_vma_struct+0x2a2>
c01085da:	c7 44 24 0c 76 da 10 	movl   $0xc010da76,0xc(%esp)
c01085e1:	c0 
c01085e2:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01085e9:	c0 
c01085ea:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c01085f1:	00 
c01085f2:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01085f9:	e8 dc 87 ff ff       	call   c0100dda <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01085fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108601:	83 c0 02             	add    $0x2,%eax
c0108604:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108608:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010860b:	89 04 24             	mov    %eax,(%esp)
c010860e:	e8 57 f6 ff ff       	call   c0107c6a <find_vma>
c0108613:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0108616:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010861a:	74 24                	je     c0108640 <check_vma_struct+0x2e4>
c010861c:	c7 44 24 0c 83 da 10 	movl   $0xc010da83,0xc(%esp)
c0108623:	c0 
c0108624:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c010862b:	c0 
c010862c:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108633:	00 
c0108634:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010863b:	e8 9a 87 ff ff       	call   c0100dda <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0108640:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108643:	83 c0 03             	add    $0x3,%eax
c0108646:	89 44 24 04          	mov    %eax,0x4(%esp)
c010864a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010864d:	89 04 24             	mov    %eax,(%esp)
c0108650:	e8 15 f6 ff ff       	call   c0107c6a <find_vma>
c0108655:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0108658:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c010865c:	74 24                	je     c0108682 <check_vma_struct+0x326>
c010865e:	c7 44 24 0c 90 da 10 	movl   $0xc010da90,0xc(%esp)
c0108665:	c0 
c0108666:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c010866d:	c0 
c010866e:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0108675:	00 
c0108676:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010867d:	e8 58 87 ff ff       	call   c0100dda <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0108682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108685:	83 c0 04             	add    $0x4,%eax
c0108688:	89 44 24 04          	mov    %eax,0x4(%esp)
c010868c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010868f:	89 04 24             	mov    %eax,(%esp)
c0108692:	e8 d3 f5 ff ff       	call   c0107c6a <find_vma>
c0108697:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c010869a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010869e:	74 24                	je     c01086c4 <check_vma_struct+0x368>
c01086a0:	c7 44 24 0c 9d da 10 	movl   $0xc010da9d,0xc(%esp)
c01086a7:	c0 
c01086a8:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01086af:	c0 
c01086b0:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01086b7:	00 
c01086b8:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01086bf:	e8 16 87 ff ff       	call   c0100dda <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c01086c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01086c7:	8b 50 04             	mov    0x4(%eax),%edx
c01086ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086cd:	39 c2                	cmp    %eax,%edx
c01086cf:	75 10                	jne    c01086e1 <check_vma_struct+0x385>
c01086d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01086d4:	8b 50 08             	mov    0x8(%eax),%edx
c01086d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086da:	83 c0 02             	add    $0x2,%eax
c01086dd:	39 c2                	cmp    %eax,%edx
c01086df:	74 24                	je     c0108705 <check_vma_struct+0x3a9>
c01086e1:	c7 44 24 0c ac da 10 	movl   $0xc010daac,0xc(%esp)
c01086e8:	c0 
c01086e9:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01086f0:	c0 
c01086f1:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c01086f8:	00 
c01086f9:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108700:	e8 d5 86 ff ff       	call   c0100dda <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108705:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108708:	8b 50 04             	mov    0x4(%eax),%edx
c010870b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010870e:	39 c2                	cmp    %eax,%edx
c0108710:	75 10                	jne    c0108722 <check_vma_struct+0x3c6>
c0108712:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108715:	8b 50 08             	mov    0x8(%eax),%edx
c0108718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010871b:	83 c0 02             	add    $0x2,%eax
c010871e:	39 c2                	cmp    %eax,%edx
c0108720:	74 24                	je     c0108746 <check_vma_struct+0x3ea>
c0108722:	c7 44 24 0c dc da 10 	movl   $0xc010dadc,0xc(%esp)
c0108729:	c0 
c010872a:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108731:	c0 
c0108732:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0108739:	00 
c010873a:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108741:	e8 94 86 ff ff       	call   c0100dda <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108746:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c010874a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010874d:	89 d0                	mov    %edx,%eax
c010874f:	c1 e0 02             	shl    $0x2,%eax
c0108752:	01 d0                	add    %edx,%eax
c0108754:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108757:	0f 8d 20 fe ff ff    	jge    c010857d <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010875d:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0108764:	eb 70                	jmp    c01087d6 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0108766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108769:	89 44 24 04          	mov    %eax,0x4(%esp)
c010876d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108770:	89 04 24             	mov    %eax,(%esp)
c0108773:	e8 f2 f4 ff ff       	call   c0107c6a <find_vma>
c0108778:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c010877b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010877f:	74 27                	je     c01087a8 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0108781:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108784:	8b 50 08             	mov    0x8(%eax),%edx
c0108787:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010878a:	8b 40 04             	mov    0x4(%eax),%eax
c010878d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108791:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108795:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108798:	89 44 24 04          	mov    %eax,0x4(%esp)
c010879c:	c7 04 24 0c db 10 c0 	movl   $0xc010db0c,(%esp)
c01087a3:	e8 b0 7b ff ff       	call   c0100358 <cprintf>
        }
        assert(vma_below_5 == NULL);
c01087a8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01087ac:	74 24                	je     c01087d2 <check_vma_struct+0x476>
c01087ae:	c7 44 24 0c 31 db 10 	movl   $0xc010db31,0xc(%esp)
c01087b5:	c0 
c01087b6:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01087bd:	c0 
c01087be:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c01087c5:	00 
c01087c6:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01087cd:	e8 08 86 ff ff       	call   c0100dda <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01087d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01087d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01087da:	79 8a                	jns    c0108766 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01087dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087df:	89 04 24             	mov    %eax,(%esp)
c01087e2:	e8 08 f7 ff ff       	call   c0107eef <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c01087e7:	c7 04 24 48 db 10 c0 	movl   $0xc010db48,(%esp)
c01087ee:	e8 65 7b ff ff       	call   c0100358 <cprintf>
}
c01087f3:	c9                   	leave  
c01087f4:	c3                   	ret    

c01087f5 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01087f5:	55                   	push   %ebp
c01087f6:	89 e5                	mov    %esp,%ebp
c01087f8:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01087fb:	e8 b4 c6 ff ff       	call   c0104eb4 <nr_free_pages>
c0108800:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108803:	e8 8e f3 ff ff       	call   c0107b96 <mm_create>
c0108808:	a3 6c 0f 1b c0       	mov    %eax,0xc01b0f6c
    assert(check_mm_struct != NULL);
c010880d:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c0108812:	85 c0                	test   %eax,%eax
c0108814:	75 24                	jne    c010883a <check_pgfault+0x45>
c0108816:	c7 44 24 0c 67 db 10 	movl   $0xc010db67,0xc(%esp)
c010881d:	c0 
c010881e:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108825:	c0 
c0108826:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c010882d:	00 
c010882e:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108835:	e8 a0 85 ff ff       	call   c0100dda <__panic>

    struct mm_struct *mm = check_mm_struct;
c010883a:	a1 6c 0f 1b c0       	mov    0xc01b0f6c,%eax
c010883f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108842:	8b 15 84 ed 1a c0    	mov    0xc01aed84,%edx
c0108848:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010884b:	89 50 0c             	mov    %edx,0xc(%eax)
c010884e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108851:	8b 40 0c             	mov    0xc(%eax),%eax
c0108854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010885a:	8b 00                	mov    (%eax),%eax
c010885c:	85 c0                	test   %eax,%eax
c010885e:	74 24                	je     c0108884 <check_pgfault+0x8f>
c0108860:	c7 44 24 0c 7f db 10 	movl   $0xc010db7f,0xc(%esp)
c0108867:	c0 
c0108868:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c010886f:	c0 
c0108870:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108877:	00 
c0108878:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010887f:	e8 56 85 ff ff       	call   c0100dda <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108884:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c010888b:	00 
c010888c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108893:	00 
c0108894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010889b:	e8 8f f3 ff ff       	call   c0107c2f <vma_create>
c01088a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01088a3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01088a7:	75 24                	jne    c01088cd <check_pgfault+0xd8>
c01088a9:	c7 44 24 0c 10 da 10 	movl   $0xc010da10,0xc(%esp)
c01088b0:	c0 
c01088b1:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c01088b8:	c0 
c01088b9:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c01088c0:	00 
c01088c1:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c01088c8:	e8 0d 85 ff ff       	call   c0100dda <__panic>

    insert_vma_struct(mm, vma);
c01088cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01088d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088d7:	89 04 24             	mov    %eax,(%esp)
c01088da:	e8 e0 f4 ff ff       	call   c0107dbf <insert_vma_struct>

    uintptr_t addr = 0x100;
c01088df:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c01088e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088f0:	89 04 24             	mov    %eax,(%esp)
c01088f3:	e8 72 f3 ff ff       	call   c0107c6a <find_vma>
c01088f8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01088fb:	74 24                	je     c0108921 <check_pgfault+0x12c>
c01088fd:	c7 44 24 0c 8d db 10 	movl   $0xc010db8d,0xc(%esp)
c0108904:	c0 
c0108905:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c010890c:	c0 
c010890d:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108914:	00 
c0108915:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c010891c:	e8 b9 84 ff ff       	call   c0100dda <__panic>

    int i, sum = 0;
c0108921:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108928:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010892f:	eb 17                	jmp    c0108948 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0108931:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108934:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108937:	01 d0                	add    %edx,%eax
c0108939:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010893c:	88 10                	mov    %dl,(%eax)
        sum += i;
c010893e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108941:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108944:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108948:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c010894c:	7e e3                	jle    c0108931 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c010894e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108955:	eb 15                	jmp    c010896c <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0108957:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010895a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010895d:	01 d0                	add    %edx,%eax
c010895f:	0f b6 00             	movzbl (%eax),%eax
c0108962:	0f be c0             	movsbl %al,%eax
c0108965:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108968:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010896c:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108970:	7e e5                	jle    c0108957 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108972:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108976:	74 24                	je     c010899c <check_pgfault+0x1a7>
c0108978:	c7 44 24 0c a7 db 10 	movl   $0xc010dba7,0xc(%esp)
c010897f:	c0 
c0108980:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108987:	c0 
c0108988:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c010898f:	00 
c0108990:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108997:	e8 3e 84 ff ff       	call   c0100dda <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010899c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010899f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01089a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01089a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01089aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01089b1:	89 04 24             	mov    %eax,(%esp)
c01089b4:	e8 df d1 ff ff       	call   c0105b98 <page_remove>
    free_page(pde2page(pgdir[0]));
c01089b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01089bc:	8b 00                	mov    (%eax),%eax
c01089be:	89 04 24             	mov    %eax,(%esp)
c01089c1:	e8 b8 f1 ff ff       	call   c0107b7e <pde2page>
c01089c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01089cd:	00 
c01089ce:	89 04 24             	mov    %eax,(%esp)
c01089d1:	e8 ac c4 ff ff       	call   c0104e82 <free_pages>
    pgdir[0] = 0;
c01089d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01089d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c01089df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c01089e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089ec:	89 04 24             	mov    %eax,(%esp)
c01089ef:	e8 fb f4 ff ff       	call   c0107eef <mm_destroy>
    check_mm_struct = NULL;
c01089f4:	c7 05 6c 0f 1b c0 00 	movl   $0x0,0xc01b0f6c
c01089fb:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c01089fe:	e8 b1 c4 ff ff       	call   c0104eb4 <nr_free_pages>
c0108a03:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108a06:	74 24                	je     c0108a2c <check_pgfault+0x237>
c0108a08:	c7 44 24 0c b0 db 10 	movl   $0xc010dbb0,0xc(%esp)
c0108a0f:	c0 
c0108a10:	c7 44 24 08 1f d9 10 	movl   $0xc010d91f,0x8(%esp)
c0108a17:	c0 
c0108a18:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108a1f:	00 
c0108a20:	c7 04 24 34 d9 10 c0 	movl   $0xc010d934,(%esp)
c0108a27:	e8 ae 83 ff ff       	call   c0100dda <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108a2c:	c7 04 24 d7 db 10 c0 	movl   $0xc010dbd7,(%esp)
c0108a33:	e8 20 79 ff ff       	call   c0100358 <cprintf>
}
c0108a38:	c9                   	leave  
c0108a39:	c3                   	ret    

c0108a3a <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108a3a:	55                   	push   %ebp
c0108a3b:	89 e5                	mov    %esp,%ebp
c0108a3d:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108a40:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108a47:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a51:	89 04 24             	mov    %eax,(%esp)
c0108a54:	e8 11 f2 ff ff       	call   c0107c6a <find_vma>
c0108a59:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108a5c:	a1 18 ee 1a c0       	mov    0xc01aee18,%eax
c0108a61:	83 c0 01             	add    $0x1,%eax
c0108a64:	a3 18 ee 1a c0       	mov    %eax,0xc01aee18
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108a69:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108a6d:	74 0b                	je     c0108a7a <do_pgfault+0x40>
c0108a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a72:	8b 40 04             	mov    0x4(%eax),%eax
c0108a75:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108a78:	76 18                	jbe    c0108a92 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108a7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a81:	c7 04 24 f4 db 10 c0 	movl   $0xc010dbf4,(%esp)
c0108a88:	e8 cb 78 ff ff       	call   c0100358 <cprintf>
        goto failed;
c0108a8d:	e9 8e 01 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
    }
    //check the error_code
    switch (error_code & 3) {
c0108a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a95:	83 e0 03             	and    $0x3,%eax
c0108a98:	85 c0                	test   %eax,%eax
c0108a9a:	74 36                	je     c0108ad2 <do_pgfault+0x98>
c0108a9c:	83 f8 01             	cmp    $0x1,%eax
c0108a9f:	74 20                	je     c0108ac1 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108aa4:	8b 40 0c             	mov    0xc(%eax),%eax
c0108aa7:	83 e0 02             	and    $0x2,%eax
c0108aaa:	85 c0                	test   %eax,%eax
c0108aac:	75 11                	jne    c0108abf <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108aae:	c7 04 24 24 dc 10 c0 	movl   $0xc010dc24,(%esp)
c0108ab5:	e8 9e 78 ff ff       	call   c0100358 <cprintf>
            goto failed;
c0108aba:	e9 61 01 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
        }
        break;
c0108abf:	eb 2f                	jmp    c0108af0 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108ac1:	c7 04 24 84 dc 10 c0 	movl   $0xc010dc84,(%esp)
c0108ac8:	e8 8b 78 ff ff       	call   c0100358 <cprintf>
        goto failed;
c0108acd:	e9 4e 01 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108ad5:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ad8:	83 e0 05             	and    $0x5,%eax
c0108adb:	85 c0                	test   %eax,%eax
c0108add:	75 11                	jne    c0108af0 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108adf:	c7 04 24 bc dc 10 c0 	movl   $0xc010dcbc,(%esp)
c0108ae6:	e8 6d 78 ff ff       	call   c0100358 <cprintf>
            goto failed;
c0108aeb:	e9 30 01 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108af0:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108afa:	8b 40 0c             	mov    0xc(%eax),%eax
c0108afd:	83 e0 02             	and    $0x2,%eax
c0108b00:	85 c0                	test   %eax,%eax
c0108b02:	74 04                	je     c0108b08 <do_pgfault+0xce>
        perm |= PTE_W;
c0108b04:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108b08:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108b0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108b16:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108b19:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108b20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: 2013011303*/
    ptep = get_pte(mm->pgdir, addr, 1); //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0108b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b2a:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b2d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108b34:	00 
c0108b35:	8b 55 10             	mov    0x10(%ebp),%edx
c0108b38:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b3c:	89 04 24             	mov    %eax,(%esp)
c0108b3f:	e8 3a ca ff ff       	call   c010557e <get_pte>
c0108b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (!ptep) goto failed;
c0108b47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108b4b:	75 05                	jne    c0108b52 <do_pgfault+0x118>
c0108b4d:	e9 ce 00 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
    if (*ptep == 0) {
c0108b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108b55:	8b 00                	mov    (%eax),%eax
c0108b57:	85 c0                	test   %eax,%eax
c0108b59:	75 2f                	jne    c0108b8a <do_pgfault+0x150>
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        struct Page *page = pgdir_alloc_page(mm->pgdir, addr, perm);
c0108b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b5e:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b61:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108b64:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108b68:	8b 55 10             	mov    0x10(%ebp),%edx
c0108b6b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b6f:	89 04 24             	mov    %eax,(%esp)
c0108b72:	e8 7b d1 ff ff       	call   c0105cf2 <pgdir_alloc_page>
c0108b77:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (!page) goto failed;
c0108b7a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108b7e:	75 05                	jne    c0108b85 <do_pgfault+0x14b>
c0108b80:	e9 9b 00 00 00       	jmp    c0108c20 <do_pgfault+0x1e6>
c0108b85:	e9 8f 00 00 00       	jmp    c0108c19 <do_pgfault+0x1df>
		     If the vma includes this addr is writable, then we can set the page writable by rewrite the *ptep.
		     This method could be used to implement the Copy on Write (COW) thchnology(a fast fork process method).
		  2) *ptep & PTE_P == 0 & but *ptep!=0, it means this pte is a  swap entry.
		     We should add the LAB3's results here.
     */
        if(swap_init_ok) {
c0108b8a:	a1 0c ee 1a c0       	mov    0xc01aee0c,%eax
c0108b8f:	85 c0                	test   %eax,%eax
c0108b91:	74 6f                	je     c0108c02 <do_pgfault+0x1c8>
            struct Page *page=NULL;
c0108b93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
                                    //(1）According to the mm AND addr, try to load the content of right disk page
                                    //    into the memory which page managed.
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                    //(3) make the page swappable.
            ret = swap_in(mm, addr, &page);
c0108b9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0108b9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ba1:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bab:	89 04 24             	mov    %eax,(%esp)
c0108bae:	e8 eb e1 ff ff       	call   c0106d9e <swap_in>
c0108bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) goto failed;
c0108bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108bba:	75 64                	jne    c0108c20 <do_pgfault+0x1e6>
            page_insert(mm->pgdir, page, addr, perm);
c0108bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bc2:	8b 40 0c             	mov    0xc(%eax),%eax
c0108bc5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108bc8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108bcc:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108bcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108bd3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108bd7:	89 04 24             	mov    %eax,(%esp)
c0108bda:	e8 fd cf ff ff       	call   c0105bdc <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0108bdf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108be2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108be9:	00 
c0108bea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bee:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf8:	89 04 24             	mov    %eax,(%esp)
c0108bfb:	e8 d5 df ff ff       	call   c0106bd5 <swap_map_swappable>
c0108c00:	eb 17                	jmp    c0108c19 <do_pgfault+0x1df>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c05:	8b 00                	mov    (%eax),%eax
c0108c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c0b:	c7 04 24 20 dd 10 c0 	movl   $0xc010dd20,(%esp)
c0108c12:	e8 41 77 ff ff       	call   c0100358 <cprintf>
            goto failed;
c0108c17:	eb 07                	jmp    c0108c20 <do_pgfault+0x1e6>
        }
   }
   ret = 0;
c0108c19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108c23:	c9                   	leave  
c0108c24:	c3                   	ret    

c0108c25 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c0108c25:	55                   	push   %ebp
c0108c26:	89 e5                	mov    %esp,%ebp
c0108c28:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0108c2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108c2f:	0f 84 e0 00 00 00    	je     c0108d15 <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c0108c35:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0108c3c:	76 1c                	jbe    c0108c5a <user_mem_check+0x35>
c0108c3e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c41:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c44:	01 d0                	add    %edx,%eax
c0108c46:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108c49:	76 0f                	jbe    c0108c5a <user_mem_check+0x35>
c0108c4b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c51:	01 d0                	add    %edx,%eax
c0108c53:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c0108c58:	76 0a                	jbe    c0108c64 <user_mem_check+0x3f>
            return 0;
c0108c5a:	b8 00 00 00 00       	mov    $0x0,%eax
c0108c5f:	e9 e2 00 00 00       	jmp    c0108d46 <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0108c64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108c67:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108c6a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108c70:	01 d0                	add    %edx,%eax
c0108c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0108c75:	e9 88 00 00 00       	jmp    c0108d02 <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0108c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c84:	89 04 24             	mov    %eax,(%esp)
c0108c87:	e8 de ef ff ff       	call   c0107c6a <find_vma>
c0108c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108c93:	74 0b                	je     c0108ca0 <user_mem_check+0x7b>
c0108c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c98:	8b 40 04             	mov    0x4(%eax),%eax
c0108c9b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108c9e:	76 0a                	jbe    c0108caa <user_mem_check+0x85>
                return 0;
c0108ca0:	b8 00 00 00 00       	mov    $0x0,%eax
c0108ca5:	e9 9c 00 00 00       	jmp    c0108d46 <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0108caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cad:	8b 50 0c             	mov    0xc(%eax),%edx
c0108cb0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108cb4:	74 07                	je     c0108cbd <user_mem_check+0x98>
c0108cb6:	b8 02 00 00 00       	mov    $0x2,%eax
c0108cbb:	eb 05                	jmp    c0108cc2 <user_mem_check+0x9d>
c0108cbd:	b8 01 00 00 00       	mov    $0x1,%eax
c0108cc2:	21 d0                	and    %edx,%eax
c0108cc4:	85 c0                	test   %eax,%eax
c0108cc6:	75 07                	jne    c0108ccf <user_mem_check+0xaa>
                return 0;
c0108cc8:	b8 00 00 00 00       	mov    $0x0,%eax
c0108ccd:	eb 77                	jmp    c0108d46 <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0108ccf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108cd3:	74 24                	je     c0108cf9 <user_mem_check+0xd4>
c0108cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cd8:	8b 40 0c             	mov    0xc(%eax),%eax
c0108cdb:	83 e0 08             	and    $0x8,%eax
c0108cde:	85 c0                	test   %eax,%eax
c0108ce0:	74 17                	je     c0108cf9 <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0108ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ce5:	8b 40 04             	mov    0x4(%eax),%eax
c0108ce8:	05 00 10 00 00       	add    $0x1000,%eax
c0108ced:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108cf0:	76 07                	jbe    c0108cf9 <user_mem_check+0xd4>
                    return 0;
c0108cf2:	b8 00 00 00 00       	mov    $0x0,%eax
c0108cf7:	eb 4d                	jmp    c0108d46 <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0108cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108cfc:	8b 40 08             	mov    0x8(%eax),%eax
c0108cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0108d02:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108d05:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108d08:	0f 82 6c ff ff ff    	jb     c0108c7a <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0108d0e:	b8 01 00 00 00       	mov    $0x1,%eax
c0108d13:	eb 31                	jmp    c0108d46 <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0108d15:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c0108d1c:	76 23                	jbe    c0108d41 <user_mem_check+0x11c>
c0108d1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d21:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108d24:	01 d0                	add    %edx,%eax
c0108d26:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108d29:	76 16                	jbe    c0108d41 <user_mem_check+0x11c>
c0108d2b:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108d31:	01 d0                	add    %edx,%eax
c0108d33:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c0108d38:	77 07                	ja     c0108d41 <user_mem_check+0x11c>
c0108d3a:	b8 01 00 00 00       	mov    $0x1,%eax
c0108d3f:	eb 05                	jmp    c0108d46 <user_mem_check+0x121>
c0108d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108d46:	c9                   	leave  
c0108d47:	c3                   	ret    

c0108d48 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108d48:	55                   	push   %ebp
c0108d49:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108d4b:	8b 55 08             	mov    0x8(%ebp),%edx
c0108d4e:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0108d53:	29 c2                	sub    %eax,%edx
c0108d55:	89 d0                	mov    %edx,%eax
c0108d57:	c1 f8 05             	sar    $0x5,%eax
}
c0108d5a:	5d                   	pop    %ebp
c0108d5b:	c3                   	ret    

c0108d5c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108d5c:	55                   	push   %ebp
c0108d5d:	89 e5                	mov    %esp,%ebp
c0108d5f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108d62:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d65:	89 04 24             	mov    %eax,(%esp)
c0108d68:	e8 db ff ff ff       	call   c0108d48 <page2ppn>
c0108d6d:	c1 e0 0c             	shl    $0xc,%eax
}
c0108d70:	c9                   	leave  
c0108d71:	c3                   	ret    

c0108d72 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108d72:	55                   	push   %ebp
c0108d73:	89 e5                	mov    %esp,%ebp
c0108d75:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d7b:	89 04 24             	mov    %eax,(%esp)
c0108d7e:	e8 d9 ff ff ff       	call   c0108d5c <page2pa>
c0108d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d89:	c1 e8 0c             	shr    $0xc,%eax
c0108d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d8f:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0108d94:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108d97:	72 23                	jb     c0108dbc <page2kva+0x4a>
c0108d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108da0:	c7 44 24 08 48 dd 10 	movl   $0xc010dd48,0x8(%esp)
c0108da7:	c0 
c0108da8:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0108daf:	00 
c0108db0:	c7 04 24 6b dd 10 c0 	movl   $0xc010dd6b,(%esp)
c0108db7:	e8 1e 80 ff ff       	call   c0100dda <__panic>
c0108dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108dbf:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108dc4:	c9                   	leave  
c0108dc5:	c3                   	ret    

c0108dc6 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108dc6:	55                   	push   %ebp
c0108dc7:	89 e5                	mov    %esp,%ebp
c0108dc9:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108dcc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108dd3:	e8 52 8d ff ff       	call   c0101b2a <ide_device_valid>
c0108dd8:	85 c0                	test   %eax,%eax
c0108dda:	75 1c                	jne    c0108df8 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108ddc:	c7 44 24 08 79 dd 10 	movl   $0xc010dd79,0x8(%esp)
c0108de3:	c0 
c0108de4:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108deb:	00 
c0108dec:	c7 04 24 93 dd 10 c0 	movl   $0xc010dd93,(%esp)
c0108df3:	e8 e2 7f ff ff       	call   c0100dda <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108df8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108dff:	e8 65 8d ff ff       	call   c0101b69 <ide_device_size>
c0108e04:	c1 e8 03             	shr    $0x3,%eax
c0108e07:	a3 3c 0f 1b c0       	mov    %eax,0xc01b0f3c
}
c0108e0c:	c9                   	leave  
c0108e0d:	c3                   	ret    

c0108e0e <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108e0e:	55                   	push   %ebp
c0108e0f:	89 e5                	mov    %esp,%ebp
c0108e11:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108e14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e17:	89 04 24             	mov    %eax,(%esp)
c0108e1a:	e8 53 ff ff ff       	call   c0108d72 <page2kva>
c0108e1f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e22:	c1 ea 08             	shr    $0x8,%edx
c0108e25:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e2c:	74 0b                	je     c0108e39 <swapfs_read+0x2b>
c0108e2e:	8b 15 3c 0f 1b c0    	mov    0xc01b0f3c,%edx
c0108e34:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108e37:	72 23                	jb     c0108e5c <swapfs_read+0x4e>
c0108e39:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108e40:	c7 44 24 08 a4 dd 10 	movl   $0xc010dda4,0x8(%esp)
c0108e47:	c0 
c0108e48:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108e4f:	00 
c0108e50:	c7 04 24 93 dd 10 c0 	movl   $0xc010dd93,(%esp)
c0108e57:	e8 7e 7f ff ff       	call   c0100dda <__panic>
c0108e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108e5f:	c1 e2 03             	shl    $0x3,%edx
c0108e62:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108e69:	00 
c0108e6a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108e6e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108e72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108e79:	e8 2a 8d ff ff       	call   c0101ba8 <ide_read_secs>
}
c0108e7e:	c9                   	leave  
c0108e7f:	c3                   	ret    

c0108e80 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108e80:	55                   	push   %ebp
c0108e81:	89 e5                	mov    %esp,%ebp
c0108e83:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108e86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e89:	89 04 24             	mov    %eax,(%esp)
c0108e8c:	e8 e1 fe ff ff       	call   c0108d72 <page2kva>
c0108e91:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e94:	c1 ea 08             	shr    $0x8,%edx
c0108e97:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e9e:	74 0b                	je     c0108eab <swapfs_write+0x2b>
c0108ea0:	8b 15 3c 0f 1b c0    	mov    0xc01b0f3c,%edx
c0108ea6:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108ea9:	72 23                	jb     c0108ece <swapfs_write+0x4e>
c0108eab:	8b 45 08             	mov    0x8(%ebp),%eax
c0108eae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108eb2:	c7 44 24 08 a4 dd 10 	movl   $0xc010dda4,0x8(%esp)
c0108eb9:	c0 
c0108eba:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108ec1:	00 
c0108ec2:	c7 04 24 93 dd 10 c0 	movl   $0xc010dd93,(%esp)
c0108ec9:	e8 0c 7f ff ff       	call   c0100dda <__panic>
c0108ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108ed1:	c1 e2 03             	shl    $0x3,%edx
c0108ed4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108edb:	00 
c0108edc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ee0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108ee4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108eeb:	e8 fa 8e ff ff       	call   c0101dea <ide_write_secs>
}
c0108ef0:	c9                   	leave  
c0108ef1:	c3                   	ret    

c0108ef2 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108ef2:	52                   	push   %edx
    call *%ebx              # call fn
c0108ef3:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108ef5:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108ef6:	e8 d8 0b 00 00       	call   c0109ad3 <do_exit>

c0108efb <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c0108efb:	55                   	push   %ebp
c0108efc:	89 e5                	mov    %esp,%ebp
c0108efe:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0108f01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f04:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f07:	0f ab 02             	bts    %eax,(%edx)
c0108f0a:	19 c0                	sbb    %eax,%eax
c0108f0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0108f0f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108f13:	0f 95 c0             	setne  %al
c0108f16:	0f b6 c0             	movzbl %al,%eax
}
c0108f19:	c9                   	leave  
c0108f1a:	c3                   	ret    

c0108f1b <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c0108f1b:	55                   	push   %ebp
c0108f1c:	89 e5                	mov    %esp,%ebp
c0108f1e:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0108f21:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f27:	0f b3 02             	btr    %eax,(%edx)
c0108f2a:	19 c0                	sbb    %eax,%eax
c0108f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0108f2f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108f33:	0f 95 c0             	setne  %al
c0108f36:	0f b6 c0             	movzbl %al,%eax
}
c0108f39:	c9                   	leave  
c0108f3a:	c3                   	ret    

c0108f3b <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0108f3b:	55                   	push   %ebp
c0108f3c:	89 e5                	mov    %esp,%ebp
c0108f3e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108f41:	9c                   	pushf  
c0108f42:	58                   	pop    %eax
c0108f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108f49:	25 00 02 00 00       	and    $0x200,%eax
c0108f4e:	85 c0                	test   %eax,%eax
c0108f50:	74 0c                	je     c0108f5e <__intr_save+0x23>
        intr_disable();
c0108f52:	e8 db 90 ff ff       	call   c0102032 <intr_disable>
        return 1;
c0108f57:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f5c:	eb 05                	jmp    c0108f63 <__intr_save+0x28>
    }
    return 0;
c0108f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f63:	c9                   	leave  
c0108f64:	c3                   	ret    

c0108f65 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108f65:	55                   	push   %ebp
c0108f66:	89 e5                	mov    %esp,%ebp
c0108f68:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108f6b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108f6f:	74 05                	je     c0108f76 <__intr_restore+0x11>
        intr_enable();
c0108f71:	e8 b6 90 ff ff       	call   c010202c <intr_enable>
    }
}
c0108f76:	c9                   	leave  
c0108f77:	c3                   	ret    

c0108f78 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0108f78:	55                   	push   %ebp
c0108f79:	89 e5                	mov    %esp,%ebp
c0108f7b:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c0108f7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108f8c:	e8 6a ff ff ff       	call   c0108efb <test_and_set_bit>
c0108f91:	85 c0                	test   %eax,%eax
c0108f93:	0f 94 c0             	sete   %al
c0108f96:	0f b6 c0             	movzbl %al,%eax
}
c0108f99:	c9                   	leave  
c0108f9a:	c3                   	ret    

c0108f9b <lock>:

static inline void
lock(lock_t *lock) {
c0108f9b:	55                   	push   %ebp
c0108f9c:	89 e5                	mov    %esp,%ebp
c0108f9e:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c0108fa1:	eb 05                	jmp    c0108fa8 <lock+0xd>
        schedule();
c0108fa3:	e8 fb 1f 00 00       	call   c010afa3 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0108fa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fab:	89 04 24             	mov    %eax,(%esp)
c0108fae:	e8 c5 ff ff ff       	call   c0108f78 <try_lock>
c0108fb3:	85 c0                	test   %eax,%eax
c0108fb5:	74 ec                	je     c0108fa3 <lock+0x8>
        schedule();
    }
}
c0108fb7:	c9                   	leave  
c0108fb8:	c3                   	ret    

c0108fb9 <unlock>:

static inline void
unlock(lock_t *lock) {
c0108fb9:	55                   	push   %ebp
c0108fba:	89 e5                	mov    %esp,%ebp
c0108fbc:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c0108fbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108fcd:	e8 49 ff ff ff       	call   c0108f1b <test_and_clear_bit>
c0108fd2:	85 c0                	test   %eax,%eax
c0108fd4:	75 1c                	jne    c0108ff2 <unlock+0x39>
        panic("Unlock failed.\n");
c0108fd6:	c7 44 24 08 c4 dd 10 	movl   $0xc010ddc4,0x8(%esp)
c0108fdd:	c0 
c0108fde:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c0108fe5:	00 
c0108fe6:	c7 04 24 d4 dd 10 c0 	movl   $0xc010ddd4,(%esp)
c0108fed:	e8 e8 7d ff ff       	call   c0100dda <__panic>
    }
}
c0108ff2:	c9                   	leave  
c0108ff3:	c3                   	ret    

c0108ff4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108ff4:	55                   	push   %ebp
c0108ff5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108ff7:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ffa:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0108fff:	29 c2                	sub    %eax,%edx
c0109001:	89 d0                	mov    %edx,%eax
c0109003:	c1 f8 05             	sar    $0x5,%eax
}
c0109006:	5d                   	pop    %ebp
c0109007:	c3                   	ret    

c0109008 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0109008:	55                   	push   %ebp
c0109009:	89 e5                	mov    %esp,%ebp
c010900b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010900e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109011:	89 04 24             	mov    %eax,(%esp)
c0109014:	e8 db ff ff ff       	call   c0108ff4 <page2ppn>
c0109019:	c1 e0 0c             	shl    $0xc,%eax
}
c010901c:	c9                   	leave  
c010901d:	c3                   	ret    

c010901e <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010901e:	55                   	push   %ebp
c010901f:	89 e5                	mov    %esp,%ebp
c0109021:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0109024:	8b 45 08             	mov    0x8(%ebp),%eax
c0109027:	c1 e8 0c             	shr    $0xc,%eax
c010902a:	89 c2                	mov    %eax,%edx
c010902c:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0109031:	39 c2                	cmp    %eax,%edx
c0109033:	72 1c                	jb     c0109051 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0109035:	c7 44 24 08 e8 dd 10 	movl   $0xc010dde8,0x8(%esp)
c010903c:	c0 
c010903d:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0109044:	00 
c0109045:	c7 04 24 07 de 10 c0 	movl   $0xc010de07,(%esp)
c010904c:	e8 89 7d ff ff       	call   c0100dda <__panic>
    }
    return &pages[PPN(pa)];
c0109051:	a1 90 0e 1b c0       	mov    0xc01b0e90,%eax
c0109056:	8b 55 08             	mov    0x8(%ebp),%edx
c0109059:	c1 ea 0c             	shr    $0xc,%edx
c010905c:	c1 e2 05             	shl    $0x5,%edx
c010905f:	01 d0                	add    %edx,%eax
}
c0109061:	c9                   	leave  
c0109062:	c3                   	ret    

c0109063 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0109063:	55                   	push   %ebp
c0109064:	89 e5                	mov    %esp,%ebp
c0109066:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109069:	8b 45 08             	mov    0x8(%ebp),%eax
c010906c:	89 04 24             	mov    %eax,(%esp)
c010906f:	e8 94 ff ff ff       	call   c0109008 <page2pa>
c0109074:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109077:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010907a:	c1 e8 0c             	shr    $0xc,%eax
c010907d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109080:	a1 80 ed 1a c0       	mov    0xc01aed80,%eax
c0109085:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109088:	72 23                	jb     c01090ad <page2kva+0x4a>
c010908a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010908d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109091:	c7 44 24 08 18 de 10 	movl   $0xc010de18,0x8(%esp)
c0109098:	c0 
c0109099:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01090a0:	00 
c01090a1:	c7 04 24 07 de 10 c0 	movl   $0xc010de07,(%esp)
c01090a8:	e8 2d 7d ff ff       	call   c0100dda <__panic>
c01090ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01090b5:	c9                   	leave  
c01090b6:	c3                   	ret    

c01090b7 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01090b7:	55                   	push   %ebp
c01090b8:	89 e5                	mov    %esp,%ebp
c01090ba:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01090bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01090c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090c3:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01090ca:	77 23                	ja     c01090ef <kva2page+0x38>
c01090cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01090d3:	c7 44 24 08 3c de 10 	movl   $0xc010de3c,0x8(%esp)
c01090da:	c0 
c01090db:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01090e2:	00 
c01090e3:	c7 04 24 07 de 10 c0 	movl   $0xc010de07,(%esp)
c01090ea:	e8 eb 7c ff ff       	call   c0100dda <__panic>
c01090ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090f2:	05 00 00 00 40       	add    $0x40000000,%eax
c01090f7:	89 04 24             	mov    %eax,(%esp)
c01090fa:	e8 1f ff ff ff       	call   c010901e <pa2page>
}
c01090ff:	c9                   	leave  
c0109100:	c3                   	ret    

c0109101 <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c0109101:	55                   	push   %ebp
c0109102:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c0109104:	8b 45 08             	mov    0x8(%ebp),%eax
c0109107:	8b 40 18             	mov    0x18(%eax),%eax
c010910a:	8d 50 01             	lea    0x1(%eax),%edx
c010910d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109110:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c0109113:	8b 45 08             	mov    0x8(%ebp),%eax
c0109116:	8b 40 18             	mov    0x18(%eax),%eax
}
c0109119:	5d                   	pop    %ebp
c010911a:	c3                   	ret    

c010911b <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c010911b:	55                   	push   %ebp
c010911c:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c010911e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109121:	8b 40 18             	mov    0x18(%eax),%eax
c0109124:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109127:	8b 45 08             	mov    0x8(%ebp),%eax
c010912a:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c010912d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109130:	8b 40 18             	mov    0x18(%eax),%eax
}
c0109133:	5d                   	pop    %ebp
c0109134:	c3                   	ret    

c0109135 <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c0109135:	55                   	push   %ebp
c0109136:	89 e5                	mov    %esp,%ebp
c0109138:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c010913b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010913f:	74 0e                	je     c010914f <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c0109141:	8b 45 08             	mov    0x8(%ebp),%eax
c0109144:	83 c0 1c             	add    $0x1c,%eax
c0109147:	89 04 24             	mov    %eax,(%esp)
c010914a:	e8 4c fe ff ff       	call   c0108f9b <lock>
    }
}
c010914f:	c9                   	leave  
c0109150:	c3                   	ret    

c0109151 <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c0109151:	55                   	push   %ebp
c0109152:	89 e5                	mov    %esp,%ebp
c0109154:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0109157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010915b:	74 0e                	je     c010916b <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c010915d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109160:	83 c0 1c             	add    $0x1c,%eax
c0109163:	89 04 24             	mov    %eax,(%esp)
c0109166:	e8 4e fe ff ff       	call   c0108fb9 <unlock>
    }
}
c010916b:	c9                   	leave  
c010916c:	c3                   	ret    

c010916d <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c010916d:	55                   	push   %ebp
c010916e:	89 e5                	mov    %esp,%ebp
c0109170:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c0109173:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
c010917a:	e8 23 b8 ff ff       	call   c01049a2 <kmalloc>
c010917f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c0109182:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109186:	74 3a                	je     c01091c2 <alloc_proc+0x55>
     *     int time_slice;                             // time slice for occupying the CPU
     *     skew_heap_entry_t lab6_run_pool;            // FOR LAB6 ONLY: the entry in the run pool
     *     uint32_t lab6_stride;                       // FOR LAB6 ONLY: the current stride of the process
     *     uint32_t lab6_priority;                     // FOR LAB6 ONLY: the priority of process, set by lab6_set_priority(uint32_t)
     */
        memset(proc, 0, sizeof(struct proc_struct));
c0109188:	c7 44 24 08 a0 00 00 	movl   $0xa0,0x8(%esp)
c010918f:	00 
c0109190:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109197:	00 
c0109198:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010919b:	89 04 24             	mov    %eax,(%esp)
c010919e:	e8 76 2b 00 00       	call   c010bd19 <memset>
        proc->state = PROC_UNINIT;
c01091a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01091a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c01091ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01091af:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->cr3 = boot_cr3;
c01091b6:	8b 15 8c 0e 1b c0    	mov    0xc01b0e8c,%edx
c01091bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01091bf:	89 50 40             	mov    %edx,0x40(%eax)
    }
    return proc;
c01091c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01091c5:	c9                   	leave  
c01091c6:	c3                   	ret    

c01091c7 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01091c7:	55                   	push   %ebp
c01091c8:	89 e5                	mov    %esp,%ebp
c01091ca:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01091cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01091d0:	83 c0 48             	add    $0x48,%eax
c01091d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01091da:	00 
c01091db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01091e2:	00 
c01091e3:	89 04 24             	mov    %eax,(%esp)
c01091e6:	e8 2e 2b 00 00       	call   c010bd19 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01091eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ee:	8d 50 48             	lea    0x48(%eax),%edx
c01091f1:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01091f8:	00 
c01091f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01091fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109200:	89 14 24             	mov    %edx,(%esp)
c0109203:	e8 f3 2b 00 00       	call   c010bdfb <memcpy>
}
c0109208:	c9                   	leave  
c0109209:	c3                   	ret    

c010920a <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c010920a:	55                   	push   %ebp
c010920b:	89 e5                	mov    %esp,%ebp
c010920d:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0109210:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109217:	00 
c0109218:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010921f:	00 
c0109220:	c7 04 24 44 0e 1b c0 	movl   $0xc01b0e44,(%esp)
c0109227:	e8 ed 2a 00 00       	call   c010bd19 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010922c:	8b 45 08             	mov    0x8(%ebp),%eax
c010922f:	83 c0 48             	add    $0x48,%eax
c0109232:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109239:	00 
c010923a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010923e:	c7 04 24 44 0e 1b c0 	movl   $0xc01b0e44,(%esp)
c0109245:	e8 b1 2b 00 00       	call   c010bdfb <memcpy>
}
c010924a:	c9                   	leave  
c010924b:	c3                   	ret    

c010924c <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c010924c:	55                   	push   %ebp
c010924d:	89 e5                	mov    %esp,%ebp
c010924f:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c0109252:	8b 45 08             	mov    0x8(%ebp),%eax
c0109255:	83 c0 58             	add    $0x58,%eax
c0109258:	c7 45 fc 70 0f 1b c0 	movl   $0xc01b0f70,-0x4(%ebp)
c010925f:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0109262:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109265:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109268:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010926b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010926e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109271:	8b 40 04             	mov    0x4(%eax),%eax
c0109274:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109277:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010927a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010927d:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0109280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109286:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109289:	89 10                	mov    %edx,(%eax)
c010928b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010928e:	8b 10                	mov    (%eax),%edx
c0109290:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109293:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0109296:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109299:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010929c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010929f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01092a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01092a5:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c01092a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01092aa:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c01092b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01092b4:	8b 40 14             	mov    0x14(%eax),%eax
c01092b7:	8b 50 70             	mov    0x70(%eax),%edx
c01092ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01092bd:	89 50 78             	mov    %edx,0x78(%eax)
c01092c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01092c3:	8b 40 78             	mov    0x78(%eax),%eax
c01092c6:	85 c0                	test   %eax,%eax
c01092c8:	74 0c                	je     c01092d6 <set_links+0x8a>
        proc->optr->yptr = proc;
c01092ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01092cd:	8b 40 78             	mov    0x78(%eax),%eax
c01092d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01092d3:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c01092d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01092d9:	8b 40 14             	mov    0x14(%eax),%eax
c01092dc:	8b 55 08             	mov    0x8(%ebp),%edx
c01092df:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c01092e2:	a1 40 0e 1b c0       	mov    0xc01b0e40,%eax
c01092e7:	83 c0 01             	add    $0x1,%eax
c01092ea:	a3 40 0e 1b c0       	mov    %eax,0xc01b0e40
}
c01092ef:	c9                   	leave  
c01092f0:	c3                   	ret    

c01092f1 <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c01092f1:	55                   	push   %ebp
c01092f2:	89 e5                	mov    %esp,%ebp
c01092f4:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c01092f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01092fa:	83 c0 58             	add    $0x58,%eax
c01092fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109300:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109303:	8b 40 04             	mov    0x4(%eax),%eax
c0109306:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109309:	8b 12                	mov    (%edx),%edx
c010930b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010930e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109311:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109314:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109317:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010931a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010931d:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109320:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c0109322:	8b 45 08             	mov    0x8(%ebp),%eax
c0109325:	8b 40 78             	mov    0x78(%eax),%eax
c0109328:	85 c0                	test   %eax,%eax
c010932a:	74 0f                	je     c010933b <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c010932c:	8b 45 08             	mov    0x8(%ebp),%eax
c010932f:	8b 40 78             	mov    0x78(%eax),%eax
c0109332:	8b 55 08             	mov    0x8(%ebp),%edx
c0109335:	8b 52 74             	mov    0x74(%edx),%edx
c0109338:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c010933b:	8b 45 08             	mov    0x8(%ebp),%eax
c010933e:	8b 40 74             	mov    0x74(%eax),%eax
c0109341:	85 c0                	test   %eax,%eax
c0109343:	74 11                	je     c0109356 <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c0109345:	8b 45 08             	mov    0x8(%ebp),%eax
c0109348:	8b 40 74             	mov    0x74(%eax),%eax
c010934b:	8b 55 08             	mov    0x8(%ebp),%edx
c010934e:	8b 52 78             	mov    0x78(%edx),%edx
c0109351:	89 50 78             	mov    %edx,0x78(%eax)
c0109354:	eb 0f                	jmp    c0109365 <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c0109356:	8b 45 08             	mov    0x8(%ebp),%eax
c0109359:	8b 40 14             	mov    0x14(%eax),%eax
c010935c:	8b 55 08             	mov    0x8(%ebp),%edx
c010935f:	8b 52 78             	mov    0x78(%edx),%edx
c0109362:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c0109365:	a1 40 0e 1b c0       	mov    0xc01b0e40,%eax
c010936a:	83 e8 01             	sub    $0x1,%eax
c010936d:	a3 40 0e 1b c0       	mov    %eax,0xc01b0e40
}
c0109372:	c9                   	leave  
c0109373:	c3                   	ret    

c0109374 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0109374:	55                   	push   %ebp
c0109375:	89 e5                	mov    %esp,%ebp
c0109377:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c010937a:	c7 45 f8 70 0f 1b c0 	movl   $0xc01b0f70,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0109381:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c0109386:	83 c0 01             	add    $0x1,%eax
c0109389:	a3 80 ca 12 c0       	mov    %eax,0xc012ca80
c010938e:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c0109393:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109398:	7e 0c                	jle    c01093a6 <get_pid+0x32>
        last_pid = 1;
c010939a:	c7 05 80 ca 12 c0 01 	movl   $0x1,0xc012ca80
c01093a1:	00 00 00 
        goto inside;
c01093a4:	eb 13                	jmp    c01093b9 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01093a6:	8b 15 80 ca 12 c0    	mov    0xc012ca80,%edx
c01093ac:	a1 84 ca 12 c0       	mov    0xc012ca84,%eax
c01093b1:	39 c2                	cmp    %eax,%edx
c01093b3:	0f 8c ac 00 00 00    	jl     c0109465 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01093b9:	c7 05 84 ca 12 c0 00 	movl   $0x2000,0xc012ca84
c01093c0:	20 00 00 
    repeat:
        le = list;
c01093c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01093c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01093c9:	eb 7f                	jmp    c010944a <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01093cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01093ce:	83 e8 58             	sub    $0x58,%eax
c01093d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c01093d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01093d7:	8b 50 04             	mov    0x4(%eax),%edx
c01093da:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c01093df:	39 c2                	cmp    %eax,%edx
c01093e1:	75 3e                	jne    c0109421 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c01093e3:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c01093e8:	83 c0 01             	add    $0x1,%eax
c01093eb:	a3 80 ca 12 c0       	mov    %eax,0xc012ca80
c01093f0:	8b 15 80 ca 12 c0    	mov    0xc012ca80,%edx
c01093f6:	a1 84 ca 12 c0       	mov    0xc012ca84,%eax
c01093fb:	39 c2                	cmp    %eax,%edx
c01093fd:	7c 4b                	jl     c010944a <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c01093ff:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c0109404:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109409:	7e 0a                	jle    c0109415 <get_pid+0xa1>
                        last_pid = 1;
c010940b:	c7 05 80 ca 12 c0 01 	movl   $0x1,0xc012ca80
c0109412:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0109415:	c7 05 84 ca 12 c0 00 	movl   $0x2000,0xc012ca84
c010941c:	20 00 00 
                    goto repeat;
c010941f:	eb a2                	jmp    c01093c3 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0109421:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109424:	8b 50 04             	mov    0x4(%eax),%edx
c0109427:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
c010942c:	39 c2                	cmp    %eax,%edx
c010942e:	7e 1a                	jle    c010944a <get_pid+0xd6>
c0109430:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109433:	8b 50 04             	mov    0x4(%eax),%edx
c0109436:	a1 84 ca 12 c0       	mov    0xc012ca84,%eax
c010943b:	39 c2                	cmp    %eax,%edx
c010943d:	7d 0b                	jge    c010944a <get_pid+0xd6>
                next_safe = proc->pid;
c010943f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109442:	8b 40 04             	mov    0x4(%eax),%eax
c0109445:	a3 84 ca 12 c0       	mov    %eax,0xc012ca84
c010944a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010944d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109450:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109453:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0109456:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0109459:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010945c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010945f:	0f 85 66 ff ff ff    	jne    c01093cb <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0109465:	a1 80 ca 12 c0       	mov    0xc012ca80,%eax
}
c010946a:	c9                   	leave  
c010946b:	c3                   	ret    

c010946c <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c010946c:	55                   	push   %ebp
c010946d:	89 e5                	mov    %esp,%ebp
c010946f:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0109472:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109477:	39 45 08             	cmp    %eax,0x8(%ebp)
c010947a:	74 63                	je     c01094df <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c010947c:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109481:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109484:	8b 45 08             	mov    0x8(%ebp),%eax
c0109487:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c010948a:	e8 ac fa ff ff       	call   c0108f3b <__intr_save>
c010948f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0109492:	8b 45 08             	mov    0x8(%ebp),%eax
c0109495:	a3 28 ee 1a c0       	mov    %eax,0xc01aee28
            load_esp0(next->kstack + KSTACKSIZE);
c010949a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010949d:	8b 40 0c             	mov    0xc(%eax),%eax
c01094a0:	05 00 20 00 00       	add    $0x2000,%eax
c01094a5:	89 04 24             	mov    %eax,(%esp)
c01094a8:	e8 1c b8 ff ff       	call   c0104cc9 <load_esp0>
            lcr3(next->cr3);
c01094ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094b0:	8b 40 40             	mov    0x40(%eax),%eax
c01094b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01094b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01094b9:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01094bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094bf:	8d 50 1c             	lea    0x1c(%eax),%edx
c01094c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094c5:	83 c0 1c             	add    $0x1c,%eax
c01094c8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01094cc:	89 04 24             	mov    %eax,(%esp)
c01094cf:	e8 96 15 00 00       	call   c010aa6a <switch_to>
        }
        local_intr_restore(intr_flag);
c01094d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01094d7:	89 04 24             	mov    %eax,(%esp)
c01094da:	e8 86 fa ff ff       	call   c0108f65 <__intr_restore>
    }
}
c01094df:	c9                   	leave  
c01094e0:	c3                   	ret    

c01094e1 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c01094e1:	55                   	push   %ebp
c01094e2:	89 e5                	mov    %esp,%ebp
c01094e4:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c01094e7:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01094ec:	8b 40 3c             	mov    0x3c(%eax),%eax
c01094ef:	89 04 24             	mov    %eax,(%esp)
c01094f2:	e8 0a 95 ff ff       	call   c0102a01 <forkrets>
}
c01094f7:	c9                   	leave  
c01094f8:	c3                   	ret    

c01094f9 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c01094f9:	55                   	push   %ebp
c01094fa:	89 e5                	mov    %esp,%ebp
c01094fc:	53                   	push   %ebx
c01094fd:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0109500:	8b 45 08             	mov    0x8(%ebp),%eax
c0109503:	8d 58 60             	lea    0x60(%eax),%ebx
c0109506:	8b 45 08             	mov    0x8(%ebp),%eax
c0109509:	8b 40 04             	mov    0x4(%eax),%eax
c010950c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109513:	00 
c0109514:	89 04 24             	mov    %eax,(%esp)
c0109517:	e8 50 1d 00 00       	call   c010b26c <hash32>
c010951c:	c1 e0 03             	shl    $0x3,%eax
c010951f:	05 40 ee 1a c0       	add    $0xc01aee40,%eax
c0109524:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109527:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010952a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010952d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109530:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109533:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109536:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109539:	8b 40 04             	mov    0x4(%eax),%eax
c010953c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010953f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109542:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109545:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109548:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010954b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010954e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109551:	89 10                	mov    %edx,(%eax)
c0109553:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109556:	8b 10                	mov    (%eax),%edx
c0109558:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010955b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010955e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109561:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109564:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010956a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010956d:	89 10                	mov    %edx,(%eax)
}
c010956f:	83 c4 34             	add    $0x34,%esp
c0109572:	5b                   	pop    %ebx
c0109573:	5d                   	pop    %ebp
c0109574:	c3                   	ret    

c0109575 <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c0109575:	55                   	push   %ebp
c0109576:	89 e5                	mov    %esp,%ebp
c0109578:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c010957b:	8b 45 08             	mov    0x8(%ebp),%eax
c010957e:	83 c0 60             	add    $0x60,%eax
c0109581:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109584:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109587:	8b 40 04             	mov    0x4(%eax),%eax
c010958a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010958d:	8b 12                	mov    (%edx),%edx
c010958f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109592:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109595:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109598:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010959b:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010959e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01095a4:	89 10                	mov    %edx,(%eax)
}
c01095a6:	c9                   	leave  
c01095a7:	c3                   	ret    

c01095a8 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c01095a8:	55                   	push   %ebp
c01095a9:	89 e5                	mov    %esp,%ebp
c01095ab:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c01095ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01095b2:	7e 5f                	jle    c0109613 <find_proc+0x6b>
c01095b4:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01095bb:	7f 56                	jg     c0109613 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c01095bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c01095c7:	00 
c01095c8:	89 04 24             	mov    %eax,(%esp)
c01095cb:	e8 9c 1c 00 00       	call   c010b26c <hash32>
c01095d0:	c1 e0 03             	shl    $0x3,%eax
c01095d3:	05 40 ee 1a c0       	add    $0xc01aee40,%eax
c01095d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c01095e1:	eb 19                	jmp    c01095fc <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c01095e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095e6:	83 e8 60             	sub    $0x60,%eax
c01095e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c01095ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095ef:	8b 40 04             	mov    0x4(%eax),%eax
c01095f2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01095f5:	75 05                	jne    c01095fc <find_proc+0x54>
                return proc;
c01095f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095fa:	eb 1c                	jmp    c0109618 <find_proc+0x70>
c01095fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109602:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109605:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109608:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010960b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010960e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0109611:	75 d0                	jne    c01095e3 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0109613:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109618:	c9                   	leave  
c0109619:	c3                   	ret    

c010961a <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c010961a:	55                   	push   %ebp
c010961b:	89 e5                	mov    %esp,%ebp
c010961d:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0109620:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109627:	00 
c0109628:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010962f:	00 
c0109630:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109633:	89 04 24             	mov    %eax,(%esp)
c0109636:	e8 de 26 00 00       	call   c010bd19 <memset>
    tf.tf_cs = KERNEL_CS;
c010963b:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0109641:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0109647:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010964b:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c010964f:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0109653:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0109657:	8b 45 08             	mov    0x8(%ebp),%eax
c010965a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c010965d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109660:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0109663:	b8 f2 8e 10 c0       	mov    $0xc0108ef2,%eax
c0109668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c010966b:	8b 45 10             	mov    0x10(%ebp),%eax
c010966e:	80 cc 01             	or     $0x1,%ah
c0109671:	89 c2                	mov    %eax,%edx
c0109673:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109676:	89 44 24 08          	mov    %eax,0x8(%esp)
c010967a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109681:	00 
c0109682:	89 14 24             	mov    %edx,(%esp)
c0109685:	e8 25 03 00 00       	call   c01099af <do_fork>
}
c010968a:	c9                   	leave  
c010968b:	c3                   	ret    

c010968c <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c010968c:	55                   	push   %ebp
c010968d:	89 e5                	mov    %esp,%ebp
c010968f:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0109692:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109699:	e8 79 b7 ff ff       	call   c0104e17 <alloc_pages>
c010969e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01096a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01096a5:	74 1a                	je     c01096c1 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c01096a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096aa:	89 04 24             	mov    %eax,(%esp)
c01096ad:	e8 b1 f9 ff ff       	call   c0109063 <page2kva>
c01096b2:	89 c2                	mov    %eax,%edx
c01096b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01096b7:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c01096ba:	b8 00 00 00 00       	mov    $0x0,%eax
c01096bf:	eb 05                	jmp    c01096c6 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c01096c1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c01096c6:	c9                   	leave  
c01096c7:	c3                   	ret    

c01096c8 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c01096c8:	55                   	push   %ebp
c01096c9:	89 e5                	mov    %esp,%ebp
c01096cb:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c01096ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01096d1:	8b 40 0c             	mov    0xc(%eax),%eax
c01096d4:	89 04 24             	mov    %eax,(%esp)
c01096d7:	e8 db f9 ff ff       	call   c01090b7 <kva2page>
c01096dc:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01096e3:	00 
c01096e4:	89 04 24             	mov    %eax,(%esp)
c01096e7:	e8 96 b7 ff ff       	call   c0104e82 <free_pages>
}
c01096ec:	c9                   	leave  
c01096ed:	c3                   	ret    

c01096ee <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c01096ee:	55                   	push   %ebp
c01096ef:	89 e5                	mov    %esp,%ebp
c01096f1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c01096f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01096fb:	e8 17 b7 ff ff       	call   c0104e17 <alloc_pages>
c0109700:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109707:	75 0a                	jne    c0109713 <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109709:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010970e:	e9 80 00 00 00       	jmp    c0109793 <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c0109713:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109716:	89 04 24             	mov    %eax,(%esp)
c0109719:	e8 45 f9 ff ff       	call   c0109063 <page2kva>
c010971e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c0109721:	a1 84 ed 1a c0       	mov    0xc01aed84,%eax
c0109726:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010972d:	00 
c010972e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109732:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109735:	89 04 24             	mov    %eax,(%esp)
c0109738:	e8 be 26 00 00       	call   c010bdfb <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c010973d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109740:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0109746:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109749:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010974c:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109753:	77 23                	ja     c0109778 <setup_pgdir+0x8a>
c0109755:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109758:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010975c:	c7 44 24 08 3c de 10 	movl   $0xc010de3c,0x8(%esp)
c0109763:	c0 
c0109764:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c010976b:	00 
c010976c:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109773:	e8 62 76 ff ff       	call   c0100dda <__panic>
c0109778:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010977b:	05 00 00 00 40       	add    $0x40000000,%eax
c0109780:	83 c8 03             	or     $0x3,%eax
c0109783:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109785:	8b 45 08             	mov    0x8(%ebp),%eax
c0109788:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010978b:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c010978e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109793:	c9                   	leave  
c0109794:	c3                   	ret    

c0109795 <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109795:	55                   	push   %ebp
c0109796:	89 e5                	mov    %esp,%ebp
c0109798:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c010979b:	8b 45 08             	mov    0x8(%ebp),%eax
c010979e:	8b 40 0c             	mov    0xc(%eax),%eax
c01097a1:	89 04 24             	mov    %eax,(%esp)
c01097a4:	e8 0e f9 ff ff       	call   c01090b7 <kva2page>
c01097a9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01097b0:	00 
c01097b1:	89 04 24             	mov    %eax,(%esp)
c01097b4:	e8 c9 b6 ff ff       	call   c0104e82 <free_pages>
}
c01097b9:	c9                   	leave  
c01097ba:	c3                   	ret    

c01097bb <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c01097bb:	55                   	push   %ebp
c01097bc:	89 e5                	mov    %esp,%ebp
c01097be:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c01097c1:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c01097c6:	8b 40 18             	mov    0x18(%eax),%eax
c01097c9:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c01097cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01097d0:	75 0a                	jne    c01097dc <copy_mm+0x21>
        return 0;
c01097d2:	b8 00 00 00 00       	mov    $0x0,%eax
c01097d7:	e9 f9 00 00 00       	jmp    c01098d5 <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c01097dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01097df:	25 00 01 00 00       	and    $0x100,%eax
c01097e4:	85 c0                	test   %eax,%eax
c01097e6:	74 08                	je     c01097f0 <copy_mm+0x35>
        mm = oldmm;
c01097e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c01097ee:	eb 78                	jmp    c0109868 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c01097f0:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c01097f7:	e8 9a e3 ff ff       	call   c0107b96 <mm_create>
c01097fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01097ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109803:	75 05                	jne    c010980a <copy_mm+0x4f>
        goto bad_mm;
c0109805:	e9 c8 00 00 00       	jmp    c01098d2 <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c010980a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010980d:	89 04 24             	mov    %eax,(%esp)
c0109810:	e8 d9 fe ff ff       	call   c01096ee <setup_pgdir>
c0109815:	85 c0                	test   %eax,%eax
c0109817:	74 05                	je     c010981e <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109819:	e9 a9 00 00 00       	jmp    c01098c7 <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c010981e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109821:	89 04 24             	mov    %eax,(%esp)
c0109824:	e8 0c f9 ff ff       	call   c0109135 <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109829:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010982c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109830:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109833:	89 04 24             	mov    %eax,(%esp)
c0109836:	e8 72 e8 ff ff       	call   c01080ad <dup_mmap>
c010983b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c010983e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109841:	89 04 24             	mov    %eax,(%esp)
c0109844:	e8 08 f9 ff ff       	call   c0109151 <unlock_mm>

    if (ret != 0) {
c0109849:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010984d:	74 19                	je     c0109868 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c010984f:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109850:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109853:	89 04 24             	mov    %eax,(%esp)
c0109856:	e8 53 e9 ff ff       	call   c01081ae <exit_mmap>
    put_pgdir(mm);
c010985b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010985e:	89 04 24             	mov    %eax,(%esp)
c0109861:	e8 2f ff ff ff       	call   c0109795 <put_pgdir>
c0109866:	eb 5f                	jmp    c01098c7 <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010986b:	89 04 24             	mov    %eax,(%esp)
c010986e:	e8 8e f8 ff ff       	call   c0109101 <mm_count_inc>
    proc->mm = mm;
c0109873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109876:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109879:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c010987c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010987f:	8b 40 0c             	mov    0xc(%eax),%eax
c0109882:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109885:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c010988c:	77 23                	ja     c01098b1 <copy_mm+0xf6>
c010988e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109891:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109895:	c7 44 24 08 3c de 10 	movl   $0xc010de3c,0x8(%esp)
c010989c:	c0 
c010989d:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c01098a4:	00 
c01098a5:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c01098ac:	e8 29 75 ff ff       	call   c0100dda <__panic>
c01098b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098b4:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01098ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098bd:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c01098c0:	b8 00 00 00 00       	mov    $0x0,%eax
c01098c5:	eb 0e                	jmp    c01098d5 <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c01098c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098ca:	89 04 24             	mov    %eax,(%esp)
c01098cd:	e8 1d e6 ff ff       	call   c0107eef <mm_destroy>
bad_mm:
    return ret;
c01098d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01098d5:	c9                   	leave  
c01098d6:	c3                   	ret    

c01098d7 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c01098d7:	55                   	push   %ebp
c01098d8:	89 e5                	mov    %esp,%ebp
c01098da:	57                   	push   %edi
c01098db:	56                   	push   %esi
c01098dc:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c01098dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01098e0:	8b 40 0c             	mov    0xc(%eax),%eax
c01098e3:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c01098e8:	89 c2                	mov    %eax,%edx
c01098ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01098ed:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c01098f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01098f3:	8b 40 3c             	mov    0x3c(%eax),%eax
c01098f6:	8b 55 10             	mov    0x10(%ebp),%edx
c01098f9:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c01098fe:	89 c1                	mov    %eax,%ecx
c0109900:	83 e1 01             	and    $0x1,%ecx
c0109903:	85 c9                	test   %ecx,%ecx
c0109905:	74 0e                	je     c0109915 <copy_thread+0x3e>
c0109907:	0f b6 0a             	movzbl (%edx),%ecx
c010990a:	88 08                	mov    %cl,(%eax)
c010990c:	83 c0 01             	add    $0x1,%eax
c010990f:	83 c2 01             	add    $0x1,%edx
c0109912:	83 eb 01             	sub    $0x1,%ebx
c0109915:	89 c1                	mov    %eax,%ecx
c0109917:	83 e1 02             	and    $0x2,%ecx
c010991a:	85 c9                	test   %ecx,%ecx
c010991c:	74 0f                	je     c010992d <copy_thread+0x56>
c010991e:	0f b7 0a             	movzwl (%edx),%ecx
c0109921:	66 89 08             	mov    %cx,(%eax)
c0109924:	83 c0 02             	add    $0x2,%eax
c0109927:	83 c2 02             	add    $0x2,%edx
c010992a:	83 eb 02             	sub    $0x2,%ebx
c010992d:	89 d9                	mov    %ebx,%ecx
c010992f:	c1 e9 02             	shr    $0x2,%ecx
c0109932:	89 c7                	mov    %eax,%edi
c0109934:	89 d6                	mov    %edx,%esi
c0109936:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109938:	89 f2                	mov    %esi,%edx
c010993a:	89 f8                	mov    %edi,%eax
c010993c:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109941:	89 de                	mov    %ebx,%esi
c0109943:	83 e6 02             	and    $0x2,%esi
c0109946:	85 f6                	test   %esi,%esi
c0109948:	74 0b                	je     c0109955 <copy_thread+0x7e>
c010994a:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c010994e:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109952:	83 c1 02             	add    $0x2,%ecx
c0109955:	83 e3 01             	and    $0x1,%ebx
c0109958:	85 db                	test   %ebx,%ebx
c010995a:	74 07                	je     c0109963 <copy_thread+0x8c>
c010995c:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109960:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109963:	8b 45 08             	mov    0x8(%ebp),%eax
c0109966:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109969:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109970:	8b 45 08             	mov    0x8(%ebp),%eax
c0109973:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109976:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109979:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c010997c:	8b 45 08             	mov    0x8(%ebp),%eax
c010997f:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109982:	8b 55 08             	mov    0x8(%ebp),%edx
c0109985:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109988:	8b 52 40             	mov    0x40(%edx),%edx
c010998b:	80 ce 02             	or     $0x2,%dh
c010998e:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109991:	ba e1 94 10 c0       	mov    $0xc01094e1,%edx
c0109996:	8b 45 08             	mov    0x8(%ebp),%eax
c0109999:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c010999c:	8b 45 08             	mov    0x8(%ebp),%eax
c010999f:	8b 40 3c             	mov    0x3c(%eax),%eax
c01099a2:	89 c2                	mov    %eax,%edx
c01099a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01099a7:	89 50 20             	mov    %edx,0x20(%eax)
}
c01099aa:	5b                   	pop    %ebx
c01099ab:	5e                   	pop    %esi
c01099ac:	5f                   	pop    %edi
c01099ad:	5d                   	pop    %ebp
c01099ae:	c3                   	ret    

c01099af <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c01099af:	55                   	push   %ebp
c01099b0:	89 e5                	mov    %esp,%ebp
c01099b2:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c01099b5:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c01099bc:	a1 40 0e 1b c0       	mov    0xc01b0e40,%eax
c01099c1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01099c6:	7e 05                	jle    c01099cd <do_fork+0x1e>
        goto fork_out;
c01099c8:	e9 f2 00 00 00       	jmp    c0109abf <do_fork+0x110>
    }
    ret = -E_NO_MEM;
c01099cd:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
c01099d4:	e8 94 f7 ff ff       	call   c010916d <alloc_proc>
c01099d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!proc) goto fork_out;
c01099dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01099e0:	75 05                	jne    c01099e7 <do_fork+0x38>
c01099e2:	e9 d8 00 00 00       	jmp    c0109abf <do_fork+0x110>
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc)) goto bad_fork_cleanup_proc;
c01099e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099ea:	89 04 24             	mov    %eax,(%esp)
c01099ed:	e8 9a fc ff ff       	call   c010968c <setup_kstack>
c01099f2:	85 c0                	test   %eax,%eax
c01099f4:	74 05                	je     c01099fb <do_fork+0x4c>
c01099f6:	e9 c9 00 00 00       	jmp    c0109ac4 <do_fork+0x115>
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc)) goto bad_fork_cleanup_kstack;
c01099fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a05:	89 04 24             	mov    %eax,(%esp)
c0109a08:	e8 ae fd ff ff       	call   c01097bb <copy_mm>
c0109a0d:	85 c0                	test   %eax,%eax
c0109a0f:	74 11                	je     c0109a22 <do_fork+0x73>
c0109a11:	90                   	nop
	
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a15:	89 04 24             	mov    %eax,(%esp)
c0109a18:	e8 ab fc ff ff       	call   c01096c8 <put_kstack>
c0109a1d:	e9 a2 00 00 00       	jmp    c0109ac4 <do_fork+0x115>
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc)) goto bad_fork_cleanup_proc;
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc)) goto bad_fork_cleanup_kstack;
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
c0109a22:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a25:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109a29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a33:	89 04 24             	mov    %eax,(%esp)
c0109a36:	e8 9c fe ff ff       	call   c01098d7 <copy_thread>
    //    5. insert proc_struct into hash_list && proc_list
    proc->parent = current;
c0109a3b:	8b 15 28 ee 1a c0    	mov    0xc01aee28,%edx
c0109a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a44:	89 50 14             	mov    %edx,0x14(%eax)
    assert(current->wait_state == 0);
c0109a47:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109a4c:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109a4f:	85 c0                	test   %eax,%eax
c0109a51:	74 24                	je     c0109a77 <do_fork+0xc8>
c0109a53:	c7 44 24 0c 74 de 10 	movl   $0xc010de74,0xc(%esp)
c0109a5a:	c0 
c0109a5b:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c0109a62:	c0 
c0109a63:	c7 44 24 04 a0 01 00 	movl   $0x1a0,0x4(%esp)
c0109a6a:	00 
c0109a6b:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109a72:	e8 63 73 ff ff       	call   c0100dda <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c0109a77:	e8 bf f4 ff ff       	call   c0108f3b <__intr_save>
c0109a7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    proc->pid = get_pid();
c0109a7f:	e8 f0 f8 ff ff       	call   c0109374 <get_pid>
c0109a84:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109a87:	89 42 04             	mov    %eax,0x4(%edx)
    hash_proc(proc);
c0109a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a8d:	89 04 24             	mov    %eax,(%esp)
c0109a90:	e8 64 fa ff ff       	call   c01094f9 <hash_proc>
    set_links(proc);
c0109a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a98:	89 04 24             	mov    %eax,(%esp)
c0109a9b:	e8 ac f7 ff ff       	call   c010924c <set_links>
    local_intr_restore(intr_flag);
c0109aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109aa3:	89 04 24             	mov    %eax,(%esp)
c0109aa6:	e8 ba f4 ff ff       	call   c0108f65 <__intr_restore>
    //    6. call wakup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0109aab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109aae:	89 04 24             	mov    %eax,(%esp)
c0109ab1:	e8 54 14 00 00       	call   c010af0a <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0109ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ab9:	8b 40 04             	mov    0x4(%eax),%eax
c0109abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */
	
fork_out:
    return ret;
c0109abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ac2:	eb 0d                	jmp    c0109ad1 <do_fork+0x122>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0109ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ac7:	89 04 24             	mov    %eax,(%esp)
c0109aca:	e8 ee ae ff ff       	call   c01049bd <kfree>
    goto fork_out;
c0109acf:	eb ee                	jmp    c0109abf <do_fork+0x110>
}
c0109ad1:	c9                   	leave  
c0109ad2:	c3                   	ret    

c0109ad3 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109ad3:	55                   	push   %ebp
c0109ad4:	89 e5                	mov    %esp,%ebp
c0109ad6:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c0109ad9:	8b 15 28 ee 1a c0    	mov    0xc01aee28,%edx
c0109adf:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c0109ae4:	39 c2                	cmp    %eax,%edx
c0109ae6:	75 1c                	jne    c0109b04 <do_exit+0x31>
        panic("idleproc exit.\n");
c0109ae8:	c7 44 24 08 a2 de 10 	movl   $0xc010dea2,0x8(%esp)
c0109aef:	c0 
c0109af0:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
c0109af7:	00 
c0109af8:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109aff:	e8 d6 72 ff ff       	call   c0100dda <__panic>
    }
    if (current == initproc) {
c0109b04:	8b 15 28 ee 1a c0    	mov    0xc01aee28,%edx
c0109b0a:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109b0f:	39 c2                	cmp    %eax,%edx
c0109b11:	75 1c                	jne    c0109b2f <do_exit+0x5c>
        panic("initproc exit.\n");
c0109b13:	c7 44 24 08 b2 de 10 	movl   $0xc010deb2,0x8(%esp)
c0109b1a:	c0 
c0109b1b:	c7 44 24 04 c8 01 00 	movl   $0x1c8,0x4(%esp)
c0109b22:	00 
c0109b23:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109b2a:	e8 ab 72 ff ff       	call   c0100dda <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c0109b2f:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109b34:	8b 40 18             	mov    0x18(%eax),%eax
c0109b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c0109b3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109b3e:	74 4a                	je     c0109b8a <do_exit+0xb7>
        lcr3(boot_cr3);
c0109b40:	a1 8c 0e 1b c0       	mov    0xc01b0e8c,%eax
c0109b45:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b4b:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c0109b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b51:	89 04 24             	mov    %eax,(%esp)
c0109b54:	e8 c2 f5 ff ff       	call   c010911b <mm_count_dec>
c0109b59:	85 c0                	test   %eax,%eax
c0109b5b:	75 21                	jne    c0109b7e <do_exit+0xab>
            exit_mmap(mm);
c0109b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b60:	89 04 24             	mov    %eax,(%esp)
c0109b63:	e8 46 e6 ff ff       	call   c01081ae <exit_mmap>
            put_pgdir(mm);
c0109b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b6b:	89 04 24             	mov    %eax,(%esp)
c0109b6e:	e8 22 fc ff ff       	call   c0109795 <put_pgdir>
            mm_destroy(mm);
c0109b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b76:	89 04 24             	mov    %eax,(%esp)
c0109b79:	e8 71 e3 ff ff       	call   c0107eef <mm_destroy>
        }
        current->mm = NULL;
c0109b7e:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109b83:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c0109b8a:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109b8f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c0109b95:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109b9a:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b9d:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c0109ba0:	e8 96 f3 ff ff       	call   c0108f3b <__intr_save>
c0109ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c0109ba8:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109bad:	8b 40 14             	mov    0x14(%eax),%eax
c0109bb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c0109bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bb6:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109bb9:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109bbe:	75 10                	jne    c0109bd0 <do_exit+0xfd>
            wakeup_proc(proc);
c0109bc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bc3:	89 04 24             	mov    %eax,(%esp)
c0109bc6:	e8 3f 13 00 00       	call   c010af0a <wakeup_proc>
        }
        while (current->cptr != NULL) {
c0109bcb:	e9 8b 00 00 00       	jmp    c0109c5b <do_exit+0x188>
c0109bd0:	e9 86 00 00 00       	jmp    c0109c5b <do_exit+0x188>
            proc = current->cptr;
c0109bd5:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109bda:	8b 40 70             	mov    0x70(%eax),%eax
c0109bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c0109be0:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109be5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109be8:	8b 52 78             	mov    0x78(%edx),%edx
c0109beb:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c0109bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bf1:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c0109bf8:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109bfd:	8b 50 70             	mov    0x70(%eax),%edx
c0109c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c03:	89 50 78             	mov    %edx,0x78(%eax)
c0109c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c09:	8b 40 78             	mov    0x78(%eax),%eax
c0109c0c:	85 c0                	test   %eax,%eax
c0109c0e:	74 0e                	je     c0109c1e <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c0109c10:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109c15:	8b 40 70             	mov    0x70(%eax),%eax
c0109c18:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c1b:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c0109c1e:	8b 15 24 ee 1a c0    	mov    0xc01aee24,%edx
c0109c24:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c27:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c0109c2a:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c32:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c0109c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c38:	8b 00                	mov    (%eax),%eax
c0109c3a:	83 f8 03             	cmp    $0x3,%eax
c0109c3d:	75 1c                	jne    c0109c5b <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c0109c3f:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109c44:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109c47:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109c4c:	75 0d                	jne    c0109c5b <do_exit+0x188>
                    wakeup_proc(initproc);
c0109c4e:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c0109c53:	89 04 24             	mov    %eax,(%esp)
c0109c56:	e8 af 12 00 00       	call   c010af0a <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c0109c5b:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109c60:	8b 40 70             	mov    0x70(%eax),%eax
c0109c63:	85 c0                	test   %eax,%eax
c0109c65:	0f 85 6a ff ff ff    	jne    c0109bd5 <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c0109c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c6e:	89 04 24             	mov    %eax,(%esp)
c0109c71:	e8 ef f2 ff ff       	call   c0108f65 <__intr_restore>
    
    schedule();
c0109c76:	e8 28 13 00 00       	call   c010afa3 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c0109c7b:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109c80:	8b 40 04             	mov    0x4(%eax),%eax
c0109c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109c87:	c7 44 24 08 c4 de 10 	movl   $0xc010dec4,0x8(%esp)
c0109c8e:	c0 
c0109c8f:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0109c96:	00 
c0109c97:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109c9e:	e8 37 71 ff ff       	call   c0100dda <__panic>

c0109ca3 <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c0109ca3:	55                   	push   %ebp
c0109ca4:	89 e5                	mov    %esp,%ebp
c0109ca6:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c0109ca9:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c0109cae:	8b 40 18             	mov    0x18(%eax),%eax
c0109cb1:	85 c0                	test   %eax,%eax
c0109cb3:	74 1c                	je     c0109cd1 <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c0109cb5:	c7 44 24 08 e4 de 10 	movl   $0xc010dee4,0x8(%esp)
c0109cbc:	c0 
c0109cbd:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0109cc4:	00 
c0109cc5:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109ccc:	e8 09 71 ff ff       	call   c0100dda <__panic>
    }

    int ret = -E_NO_MEM;
c0109cd1:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c0109cd8:	e8 b9 de ff ff       	call   c0107b96 <mm_create>
c0109cdd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109ce0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0109ce4:	75 06                	jne    c0109cec <load_icode+0x49>
        goto bad_mm;
c0109ce6:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c0109ce7:	e9 ef 05 00 00       	jmp    c010a2db <load_icode+0x638>
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c0109cec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109cef:	89 04 24             	mov    %eax,(%esp)
c0109cf2:	e8 f7 f9 ff ff       	call   c01096ee <setup_pgdir>
c0109cf7:	85 c0                	test   %eax,%eax
c0109cf9:	74 05                	je     c0109d00 <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c0109cfb:	e9 f6 05 00 00       	jmp    c010a2f6 <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c0109d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d03:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c0109d06:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d09:	8b 50 1c             	mov    0x1c(%eax),%edx
c0109d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d0f:	01 d0                	add    %edx,%eax
c0109d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c0109d14:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d17:	8b 00                	mov    (%eax),%eax
c0109d19:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0109d1e:	74 0c                	je     c0109d2c <load_icode+0x89>
        ret = -E_INVAL_ELF;
c0109d20:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c0109d27:	e9 bf 05 00 00       	jmp    c010a2eb <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c0109d2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d2f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0109d33:	0f b7 c0             	movzwl %ax,%eax
c0109d36:	c1 e0 05             	shl    $0x5,%eax
c0109d39:	89 c2                	mov    %eax,%edx
c0109d3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d3e:	01 d0                	add    %edx,%eax
c0109d40:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c0109d43:	e9 13 03 00 00       	jmp    c010a05b <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c0109d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d4b:	8b 00                	mov    (%eax),%eax
c0109d4d:	83 f8 01             	cmp    $0x1,%eax
c0109d50:	74 05                	je     c0109d57 <load_icode+0xb4>
            continue ;
c0109d52:	e9 00 03 00 00       	jmp    c010a057 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c0109d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d5a:	8b 50 10             	mov    0x10(%eax),%edx
c0109d5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d60:	8b 40 14             	mov    0x14(%eax),%eax
c0109d63:	39 c2                	cmp    %eax,%edx
c0109d65:	76 0c                	jbe    c0109d73 <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c0109d67:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c0109d6e:	e9 6d 05 00 00       	jmp    c010a2e0 <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c0109d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d76:	8b 40 10             	mov    0x10(%eax),%eax
c0109d79:	85 c0                	test   %eax,%eax
c0109d7b:	75 05                	jne    c0109d82 <load_icode+0xdf>
            continue ;
c0109d7d:	e9 d5 02 00 00       	jmp    c010a057 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c0109d82:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0109d89:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c0109d90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d93:	8b 40 18             	mov    0x18(%eax),%eax
c0109d96:	83 e0 01             	and    $0x1,%eax
c0109d99:	85 c0                	test   %eax,%eax
c0109d9b:	74 04                	je     c0109da1 <load_icode+0xfe>
c0109d9d:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c0109da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109da4:	8b 40 18             	mov    0x18(%eax),%eax
c0109da7:	83 e0 02             	and    $0x2,%eax
c0109daa:	85 c0                	test   %eax,%eax
c0109dac:	74 04                	je     c0109db2 <load_icode+0x10f>
c0109dae:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c0109db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109db5:	8b 40 18             	mov    0x18(%eax),%eax
c0109db8:	83 e0 04             	and    $0x4,%eax
c0109dbb:	85 c0                	test   %eax,%eax
c0109dbd:	74 04                	je     c0109dc3 <load_icode+0x120>
c0109dbf:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c0109dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109dc6:	83 e0 02             	and    $0x2,%eax
c0109dc9:	85 c0                	test   %eax,%eax
c0109dcb:	74 04                	je     c0109dd1 <load_icode+0x12e>
c0109dcd:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c0109dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dd4:	8b 50 14             	mov    0x14(%eax),%edx
c0109dd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dda:	8b 40 08             	mov    0x8(%eax),%eax
c0109ddd:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c0109de4:	00 
c0109de5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0109de8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0109dec:	89 54 24 08          	mov    %edx,0x8(%esp)
c0109df0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109df4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109df7:	89 04 24             	mov    %eax,(%esp)
c0109dfa:	e8 92 e1 ff ff       	call   c0107f91 <mm_map>
c0109dff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109e06:	74 05                	je     c0109e0d <load_icode+0x16a>
            goto bad_cleanup_mmap;
c0109e08:	e9 d3 04 00 00       	jmp    c010a2e0 <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c0109e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e10:	8b 50 04             	mov    0x4(%eax),%edx
c0109e13:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e16:	01 d0                	add    %edx,%eax
c0109e18:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c0109e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e1e:	8b 40 08             	mov    0x8(%eax),%eax
c0109e21:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109e24:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109e27:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0109e2a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0109e2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0109e32:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c0109e35:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c0109e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e3f:	8b 50 08             	mov    0x8(%eax),%edx
c0109e42:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e45:	8b 40 10             	mov    0x10(%eax),%eax
c0109e48:	01 d0                	add    %edx,%eax
c0109e4a:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c0109e4d:	e9 90 00 00 00       	jmp    c0109ee2 <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c0109e52:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109e55:	8b 40 0c             	mov    0xc(%eax),%eax
c0109e58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109e5b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0109e5f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109e62:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109e66:	89 04 24             	mov    %eax,(%esp)
c0109e69:	e8 84 be ff ff       	call   c0105cf2 <pgdir_alloc_page>
c0109e6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109e71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109e75:	75 05                	jne    c0109e7c <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c0109e77:	e9 64 04 00 00       	jmp    c010a2e0 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c0109e7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109e7f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109e82:	29 c2                	sub    %eax,%edx
c0109e84:	89 d0                	mov    %edx,%eax
c0109e86:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0109e89:	b8 00 10 00 00       	mov    $0x1000,%eax
c0109e8e:	2b 45 bc             	sub    -0x44(%ebp),%eax
c0109e91:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0109e94:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c0109e9b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109e9e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109ea1:	73 0d                	jae    c0109eb0 <load_icode+0x20d>
                size -= la - end;
c0109ea3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109ea6:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0109ea9:	29 c2                	sub    %eax,%edx
c0109eab:	89 d0                	mov    %edx,%eax
c0109ead:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c0109eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109eb3:	89 04 24             	mov    %eax,(%esp)
c0109eb6:	e8 a8 f1 ff ff       	call   c0109063 <page2kva>
c0109ebb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0109ebe:	01 c2                	add    %eax,%edx
c0109ec0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109ec3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109eca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109ece:	89 14 24             	mov    %edx,(%esp)
c0109ed1:	e8 25 1f 00 00       	call   c010bdfb <memcpy>
            start += size, from += size;
c0109ed6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109ed9:	01 45 d8             	add    %eax,-0x28(%ebp)
c0109edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109edf:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c0109ee2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109ee5:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109ee8:	0f 82 64 ff ff ff    	jb     c0109e52 <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c0109eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ef1:	8b 50 08             	mov    0x8(%eax),%edx
c0109ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ef7:	8b 40 14             	mov    0x14(%eax),%eax
c0109efa:	01 d0                	add    %edx,%eax
c0109efc:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c0109eff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f02:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f05:	0f 83 b0 00 00 00    	jae    c0109fbb <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c0109f0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f0e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109f11:	75 05                	jne    c0109f18 <load_icode+0x275>
                continue ;
c0109f13:	e9 3f 01 00 00       	jmp    c010a057 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c0109f18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109f1b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109f1e:	29 c2                	sub    %eax,%edx
c0109f20:	89 d0                	mov    %edx,%eax
c0109f22:	05 00 10 00 00       	add    $0x1000,%eax
c0109f27:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0109f2a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0109f2f:	2b 45 bc             	sub    -0x44(%ebp),%eax
c0109f32:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c0109f35:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109f38:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f3b:	73 0d                	jae    c0109f4a <load_icode+0x2a7>
                size -= la - end;
c0109f3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109f40:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0109f43:	29 c2                	sub    %eax,%edx
c0109f45:	89 d0                	mov    %edx,%eax
c0109f47:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c0109f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f4d:	89 04 24             	mov    %eax,(%esp)
c0109f50:	e8 0e f1 ff ff       	call   c0109063 <page2kva>
c0109f55:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0109f58:	01 c2                	add    %eax,%edx
c0109f5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f5d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109f68:	00 
c0109f69:	89 14 24             	mov    %edx,(%esp)
c0109f6c:	e8 a8 1d 00 00       	call   c010bd19 <memset>
            start += size;
c0109f71:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f74:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c0109f77:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109f7a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f7d:	73 08                	jae    c0109f87 <load_icode+0x2e4>
c0109f7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f82:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109f85:	74 34                	je     c0109fbb <load_icode+0x318>
c0109f87:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109f8a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f8d:	72 08                	jb     c0109f97 <load_icode+0x2f4>
c0109f8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f92:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f95:	74 24                	je     c0109fbb <load_icode+0x318>
c0109f97:	c7 44 24 0c 0c df 10 	movl   $0xc010df0c,0xc(%esp)
c0109f9e:	c0 
c0109f9f:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c0109fa6:	c0 
c0109fa7:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0109fae:	00 
c0109faf:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c0109fb6:	e8 1f 6e ff ff       	call   c0100dda <__panic>
        }
        while (start < end) {
c0109fbb:	e9 8b 00 00 00       	jmp    c010a04b <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c0109fc0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109fc3:	8b 40 0c             	mov    0xc(%eax),%eax
c0109fc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109fc9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0109fcd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109fd0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109fd4:	89 04 24             	mov    %eax,(%esp)
c0109fd7:	e8 16 bd ff ff       	call   c0105cf2 <pgdir_alloc_page>
c0109fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109fe3:	75 05                	jne    c0109fea <load_icode+0x347>
                goto bad_cleanup_mmap;
c0109fe5:	e9 f6 02 00 00       	jmp    c010a2e0 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c0109fea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109fed:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109ff0:	29 c2                	sub    %eax,%edx
c0109ff2:	89 d0                	mov    %edx,%eax
c0109ff4:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0109ff7:	b8 00 10 00 00       	mov    $0x1000,%eax
c0109ffc:	2b 45 bc             	sub    -0x44(%ebp),%eax
c0109fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a002:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a009:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a00c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a00f:	73 0d                	jae    c010a01e <load_icode+0x37b>
                size -= la - end;
c010a011:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a014:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a017:	29 c2                	sub    %eax,%edx
c010a019:	89 d0                	mov    %edx,%eax
c010a01b:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a01e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a021:	89 04 24             	mov    %eax,(%esp)
c010a024:	e8 3a f0 ff ff       	call   c0109063 <page2kva>
c010a029:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a02c:	01 c2                	add    %eax,%edx
c010a02e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a031:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a035:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a03c:	00 
c010a03d:	89 14 24             	mov    %edx,(%esp)
c010a040:	e8 d4 1c 00 00       	call   c010bd19 <memset>
            start += size;
c010a045:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a048:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a04b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a04e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a051:	0f 82 69 ff ff ff    	jb     c0109fc0 <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a057:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a05b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a05e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a061:	0f 82 e1 fc ff ff    	jb     c0109d48 <load_icode+0xa5>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a067:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a06e:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a075:	00 
c010a076:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a079:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a07d:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a084:	00 
c010a085:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a08c:	af 
c010a08d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a090:	89 04 24             	mov    %eax,(%esp)
c010a093:	e8 f9 de ff ff       	call   c0107f91 <mm_map>
c010a098:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a09b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a09f:	74 05                	je     c010a0a6 <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a0a1:	e9 3a 02 00 00       	jmp    c010a2e0 <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a0a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a0a9:	8b 40 0c             	mov    0xc(%eax),%eax
c010a0ac:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a0b3:	00 
c010a0b4:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a0bb:	af 
c010a0bc:	89 04 24             	mov    %eax,(%esp)
c010a0bf:	e8 2e bc ff ff       	call   c0105cf2 <pgdir_alloc_page>
c010a0c4:	85 c0                	test   %eax,%eax
c010a0c6:	75 24                	jne    c010a0ec <load_icode+0x449>
c010a0c8:	c7 44 24 0c 48 df 10 	movl   $0xc010df48,0xc(%esp)
c010a0cf:	c0 
c010a0d0:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a0d7:	c0 
c010a0d8:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c010a0df:	00 
c010a0e0:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a0e7:	e8 ee 6c ff ff       	call   c0100dda <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a0ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a0ef:	8b 40 0c             	mov    0xc(%eax),%eax
c010a0f2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a0f9:	00 
c010a0fa:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a101:	af 
c010a102:	89 04 24             	mov    %eax,(%esp)
c010a105:	e8 e8 bb ff ff       	call   c0105cf2 <pgdir_alloc_page>
c010a10a:	85 c0                	test   %eax,%eax
c010a10c:	75 24                	jne    c010a132 <load_icode+0x48f>
c010a10e:	c7 44 24 0c 8c df 10 	movl   $0xc010df8c,0xc(%esp)
c010a115:	c0 
c010a116:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a11d:	c0 
c010a11e:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c010a125:	00 
c010a126:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a12d:	e8 a8 6c ff ff       	call   c0100dda <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a132:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a135:	8b 40 0c             	mov    0xc(%eax),%eax
c010a138:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a13f:	00 
c010a140:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a147:	af 
c010a148:	89 04 24             	mov    %eax,(%esp)
c010a14b:	e8 a2 bb ff ff       	call   c0105cf2 <pgdir_alloc_page>
c010a150:	85 c0                	test   %eax,%eax
c010a152:	75 24                	jne    c010a178 <load_icode+0x4d5>
c010a154:	c7 44 24 0c d0 df 10 	movl   $0xc010dfd0,0xc(%esp)
c010a15b:	c0 
c010a15c:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a163:	c0 
c010a164:	c7 44 24 04 65 02 00 	movl   $0x265,0x4(%esp)
c010a16b:	00 
c010a16c:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a173:	e8 62 6c ff ff       	call   c0100dda <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a178:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a17b:	8b 40 0c             	mov    0xc(%eax),%eax
c010a17e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a185:	00 
c010a186:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a18d:	af 
c010a18e:	89 04 24             	mov    %eax,(%esp)
c010a191:	e8 5c bb ff ff       	call   c0105cf2 <pgdir_alloc_page>
c010a196:	85 c0                	test   %eax,%eax
c010a198:	75 24                	jne    c010a1be <load_icode+0x51b>
c010a19a:	c7 44 24 0c 14 e0 10 	movl   $0xc010e014,0xc(%esp)
c010a1a1:	c0 
c010a1a2:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a1a9:	c0 
c010a1aa:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c010a1b1:	00 
c010a1b2:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a1b9:	e8 1c 6c ff ff       	call   c0100dda <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a1be:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a1c1:	89 04 24             	mov    %eax,(%esp)
c010a1c4:	e8 38 ef ff ff       	call   c0109101 <mm_count_inc>
    current->mm = mm;
c010a1c9:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a1ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a1d1:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a1d4:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a1d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a1dc:	8b 52 0c             	mov    0xc(%edx),%edx
c010a1df:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a1e2:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a1e9:	77 23                	ja     c010a20e <load_icode+0x56b>
c010a1eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a1ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a1f2:	c7 44 24 08 3c de 10 	movl   $0xc010de3c,0x8(%esp)
c010a1f9:	c0 
c010a1fa:	c7 44 24 04 6b 02 00 	movl   $0x26b,0x4(%esp)
c010a201:	00 
c010a202:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a209:	e8 cc 6b ff ff       	call   c0100dda <__panic>
c010a20e:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a211:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a217:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a21a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a21d:	8b 40 0c             	mov    0xc(%eax),%eax
c010a220:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a223:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a22a:	77 23                	ja     c010a24f <load_icode+0x5ac>
c010a22c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a22f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a233:	c7 44 24 08 3c de 10 	movl   $0xc010de3c,0x8(%esp)
c010a23a:	c0 
c010a23b:	c7 44 24 04 6c 02 00 	movl   $0x26c,0x4(%esp)
c010a242:	00 
c010a243:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a24a:	e8 8b 6b ff ff       	call   c0100dda <__panic>
c010a24f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a252:	05 00 00 00 40       	add    $0x40000000,%eax
c010a257:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a25a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a25d:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a260:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a265:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a268:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a26b:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a272:	00 
c010a273:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a27a:	00 
c010a27b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a27e:	89 04 24             	mov    %eax,(%esp)
c010a281:	e8 93 1a 00 00       	call   c010bd19 <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a286:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a289:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a28f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a292:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a298:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a29b:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a29f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2a2:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a2a6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2a9:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a2ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2b0:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a2b4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2b7:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a2be:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a2c1:	8b 50 18             	mov    0x18(%eax),%edx
c010a2c4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2c7:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a2ca:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2cd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    ret = 0;
c010a2d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a2de:	eb 23                	jmp    c010a303 <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a2e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a2e3:	89 04 24             	mov    %eax,(%esp)
c010a2e6:	e8 c3 de ff ff       	call   c01081ae <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a2eb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a2ee:	89 04 24             	mov    %eax,(%esp)
c010a2f1:	e8 9f f4 ff ff       	call   c0109795 <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a2f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a2f9:	89 04 24             	mov    %eax,(%esp)
c010a2fc:	e8 ee db ff ff       	call   c0107eef <mm_destroy>
bad_mm:
    goto out;
c010a301:	eb d8                	jmp    c010a2db <load_icode+0x638>
}
c010a303:	c9                   	leave  
c010a304:	c3                   	ret    

c010a305 <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a305:	55                   	push   %ebp
c010a306:	89 e5                	mov    %esp,%ebp
c010a308:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a30b:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a310:	8b 40 18             	mov    0x18(%eax),%eax
c010a313:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a316:	8b 45 08             	mov    0x8(%ebp),%eax
c010a319:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a320:	00 
c010a321:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a324:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a328:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a32c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a32f:	89 04 24             	mov    %eax,(%esp)
c010a332:	e8 ee e8 ff ff       	call   c0108c25 <user_mem_check>
c010a337:	85 c0                	test   %eax,%eax
c010a339:	75 0a                	jne    c010a345 <do_execve+0x40>
        return -E_INVAL;
c010a33b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a340:	e9 f4 00 00 00       	jmp    c010a439 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a345:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a349:	76 07                	jbe    c010a352 <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a34b:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a352:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a359:	00 
c010a35a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a361:	00 
c010a362:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a365:	89 04 24             	mov    %eax,(%esp)
c010a368:	e8 ac 19 00 00       	call   c010bd19 <memset>
    memcpy(local_name, name, len);
c010a36d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a370:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a374:	8b 45 08             	mov    0x8(%ebp),%eax
c010a377:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a37b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a37e:	89 04 24             	mov    %eax,(%esp)
c010a381:	e8 75 1a 00 00       	call   c010bdfb <memcpy>

    if (mm != NULL) {
c010a386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a38a:	74 4a                	je     c010a3d6 <do_execve+0xd1>
        lcr3(boot_cr3);
c010a38c:	a1 8c 0e 1b c0       	mov    0xc01b0e8c,%eax
c010a391:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a394:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a397:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a39a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a39d:	89 04 24             	mov    %eax,(%esp)
c010a3a0:	e8 76 ed ff ff       	call   c010911b <mm_count_dec>
c010a3a5:	85 c0                	test   %eax,%eax
c010a3a7:	75 21                	jne    c010a3ca <do_execve+0xc5>
            exit_mmap(mm);
c010a3a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a3ac:	89 04 24             	mov    %eax,(%esp)
c010a3af:	e8 fa dd ff ff       	call   c01081ae <exit_mmap>
            put_pgdir(mm);
c010a3b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a3b7:	89 04 24             	mov    %eax,(%esp)
c010a3ba:	e8 d6 f3 ff ff       	call   c0109795 <put_pgdir>
            mm_destroy(mm);
c010a3bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a3c2:	89 04 24             	mov    %eax,(%esp)
c010a3c5:	e8 25 db ff ff       	call   c0107eef <mm_destroy>
        }
        current->mm = NULL;
c010a3ca:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a3cf:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a3d6:	8b 45 14             	mov    0x14(%ebp),%eax
c010a3d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a3dd:	8b 45 10             	mov    0x10(%ebp),%eax
c010a3e0:	89 04 24             	mov    %eax,(%esp)
c010a3e3:	e8 bb f8 ff ff       	call   c0109ca3 <load_icode>
c010a3e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a3eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a3ef:	74 2f                	je     c010a420 <do_execve+0x11b>
        goto execve_exit;
c010a3f1:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a3f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a3f5:	89 04 24             	mov    %eax,(%esp)
c010a3f8:	e8 d6 f6 ff ff       	call   c0109ad3 <do_exit>
    panic("already exit: %e.\n", ret);
c010a3fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a400:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a404:	c7 44 24 08 57 e0 10 	movl   $0xc010e057,0x8(%esp)
c010a40b:	c0 
c010a40c:	c7 44 24 04 ae 02 00 	movl   $0x2ae,0x4(%esp)
c010a413:	00 
c010a414:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a41b:	e8 ba 69 ff ff       	call   c0100dda <__panic>
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a420:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a425:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a428:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a42c:	89 04 24             	mov    %eax,(%esp)
c010a42f:	e8 93 ed ff ff       	call   c01091c7 <set_proc_name>
    return 0;
c010a434:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a439:	c9                   	leave  
c010a43a:	c3                   	ret    

c010a43b <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a43b:	55                   	push   %ebp
c010a43c:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a43e:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a443:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a44a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a44f:	5d                   	pop    %ebp
c010a450:	c3                   	ret    

c010a451 <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a451:	55                   	push   %ebp
c010a452:	89 e5                	mov    %esp,%ebp
c010a454:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a457:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a45c:	8b 40 18             	mov    0x18(%eax),%eax
c010a45f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a462:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a466:	74 30                	je     c010a498 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a468:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a46b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a472:	00 
c010a473:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a47a:	00 
c010a47b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a47f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a482:	89 04 24             	mov    %eax,(%esp)
c010a485:	e8 9b e7 ff ff       	call   c0108c25 <user_mem_check>
c010a48a:	85 c0                	test   %eax,%eax
c010a48c:	75 0a                	jne    c010a498 <do_wait+0x47>
            return -E_INVAL;
c010a48e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a493:	e9 4b 01 00 00       	jmp    c010a5e3 <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a49f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a4a3:	74 39                	je     c010a4de <do_wait+0x8d>
        proc = find_proc(pid);
c010a4a5:	8b 45 08             	mov    0x8(%ebp),%eax
c010a4a8:	89 04 24             	mov    %eax,(%esp)
c010a4ab:	e8 f8 f0 ff ff       	call   c01095a8 <find_proc>
c010a4b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a4b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a4b7:	74 54                	je     c010a50d <do_wait+0xbc>
c010a4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a4bc:	8b 50 14             	mov    0x14(%eax),%edx
c010a4bf:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a4c4:	39 c2                	cmp    %eax,%edx
c010a4c6:	75 45                	jne    c010a50d <do_wait+0xbc>
            haskid = 1;
c010a4c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a4cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a4d2:	8b 00                	mov    (%eax),%eax
c010a4d4:	83 f8 03             	cmp    $0x3,%eax
c010a4d7:	75 34                	jne    c010a50d <do_wait+0xbc>
                goto found;
c010a4d9:	e9 80 00 00 00       	jmp    c010a55e <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010a4de:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a4e3:	8b 40 70             	mov    0x70(%eax),%eax
c010a4e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010a4e9:	eb 1c                	jmp    c010a507 <do_wait+0xb6>
            haskid = 1;
c010a4eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a4f5:	8b 00                	mov    (%eax),%eax
c010a4f7:	83 f8 03             	cmp    $0x3,%eax
c010a4fa:	75 02                	jne    c010a4fe <do_wait+0xad>
                goto found;
c010a4fc:	eb 60                	jmp    c010a55e <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010a4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a501:	8b 40 78             	mov    0x78(%eax),%eax
c010a504:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a507:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a50b:	75 de                	jne    c010a4eb <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010a50d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a511:	74 41                	je     c010a554 <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010a513:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a518:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010a51e:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a523:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010a52a:	e8 74 0a 00 00       	call   c010afa3 <schedule>
        if (current->flags & PF_EXITING) {
c010a52f:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a534:	8b 40 44             	mov    0x44(%eax),%eax
c010a537:	83 e0 01             	and    $0x1,%eax
c010a53a:	85 c0                	test   %eax,%eax
c010a53c:	74 11                	je     c010a54f <do_wait+0xfe>
            do_exit(-E_KILLED);
c010a53e:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010a545:	e8 89 f5 ff ff       	call   c0109ad3 <do_exit>
        }
        goto repeat;
c010a54a:	e9 49 ff ff ff       	jmp    c010a498 <do_wait+0x47>
c010a54f:	e9 44 ff ff ff       	jmp    c010a498 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010a554:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010a559:	e9 85 00 00 00       	jmp    c010a5e3 <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010a55e:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a563:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a566:	74 0a                	je     c010a572 <do_wait+0x121>
c010a568:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a56d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a570:	75 1c                	jne    c010a58e <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010a572:	c7 44 24 08 6a e0 10 	movl   $0xc010e06a,0x8(%esp)
c010a579:	c0 
c010a57a:	c7 44 24 04 e7 02 00 	movl   $0x2e7,0x4(%esp)
c010a581:	00 
c010a582:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a589:	e8 4c 68 ff ff       	call   c0100dda <__panic>
    }
    if (code_store != NULL) {
c010a58e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a592:	74 0b                	je     c010a59f <do_wait+0x14e>
        *code_store = proc->exit_code;
c010a594:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a597:	8b 50 68             	mov    0x68(%eax),%edx
c010a59a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a59d:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010a59f:	e8 97 e9 ff ff       	call   c0108f3b <__intr_save>
c010a5a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010a5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5aa:	89 04 24             	mov    %eax,(%esp)
c010a5ad:	e8 c3 ef ff ff       	call   c0109575 <unhash_proc>
        remove_links(proc);
c010a5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5b5:	89 04 24             	mov    %eax,(%esp)
c010a5b8:	e8 34 ed ff ff       	call   c01092f1 <remove_links>
    }
    local_intr_restore(intr_flag);
c010a5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a5c0:	89 04 24             	mov    %eax,(%esp)
c010a5c3:	e8 9d e9 ff ff       	call   c0108f65 <__intr_restore>
    put_kstack(proc);
c010a5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5cb:	89 04 24             	mov    %eax,(%esp)
c010a5ce:	e8 f5 f0 ff ff       	call   c01096c8 <put_kstack>
    kfree(proc);
c010a5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a5d6:	89 04 24             	mov    %eax,(%esp)
c010a5d9:	e8 df a3 ff ff       	call   c01049bd <kfree>
    return 0;
c010a5de:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a5e3:	c9                   	leave  
c010a5e4:	c3                   	ret    

c010a5e5 <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010a5e5:	55                   	push   %ebp
c010a5e6:	89 e5                	mov    %esp,%ebp
c010a5e8:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010a5eb:	8b 45 08             	mov    0x8(%ebp),%eax
c010a5ee:	89 04 24             	mov    %eax,(%esp)
c010a5f1:	e8 b2 ef ff ff       	call   c01095a8 <find_proc>
c010a5f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a5f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a5fd:	74 41                	je     c010a640 <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010a5ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a602:	8b 40 44             	mov    0x44(%eax),%eax
c010a605:	83 e0 01             	and    $0x1,%eax
c010a608:	85 c0                	test   %eax,%eax
c010a60a:	75 2d                	jne    c010a639 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010a60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a60f:	8b 40 44             	mov    0x44(%eax),%eax
c010a612:	83 c8 01             	or     $0x1,%eax
c010a615:	89 c2                	mov    %eax,%edx
c010a617:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a61a:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010a61d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a620:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a623:	85 c0                	test   %eax,%eax
c010a625:	79 0b                	jns    c010a632 <do_kill+0x4d>
                wakeup_proc(proc);
c010a627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a62a:	89 04 24             	mov    %eax,(%esp)
c010a62d:	e8 d8 08 00 00       	call   c010af0a <wakeup_proc>
            }
            return 0;
c010a632:	b8 00 00 00 00       	mov    $0x0,%eax
c010a637:	eb 0c                	jmp    c010a645 <do_kill+0x60>
        }
        return -E_KILLED;
c010a639:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010a63e:	eb 05                	jmp    c010a645 <do_kill+0x60>
    }
    return -E_INVAL;
c010a640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010a645:	c9                   	leave  
c010a646:	c3                   	ret    

c010a647 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010a647:	55                   	push   %ebp
c010a648:	89 e5                	mov    %esp,%ebp
c010a64a:	57                   	push   %edi
c010a64b:	56                   	push   %esi
c010a64c:	53                   	push   %ebx
c010a64d:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010a650:	8b 45 08             	mov    0x8(%ebp),%eax
c010a653:	89 04 24             	mov    %eax,(%esp)
c010a656:	e8 8f 13 00 00       	call   c010b9ea <strlen>
c010a65b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010a65e:	b8 04 00 00 00       	mov    $0x4,%eax
c010a663:	8b 55 08             	mov    0x8(%ebp),%edx
c010a666:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010a669:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010a66c:	8b 75 10             	mov    0x10(%ebp),%esi
c010a66f:	89 f7                	mov    %esi,%edi
c010a671:	cd 80                	int    $0x80
c010a673:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010a676:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010a679:	83 c4 2c             	add    $0x2c,%esp
c010a67c:	5b                   	pop    %ebx
c010a67d:	5e                   	pop    %esi
c010a67e:	5f                   	pop    %edi
c010a67f:	5d                   	pop    %ebp
c010a680:	c3                   	ret    

c010a681 <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010a681:	55                   	push   %ebp
c010a682:	89 e5                	mov    %esp,%ebp
c010a684:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010a687:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010a68c:	8b 40 04             	mov    0x4(%eax),%eax
c010a68f:	c7 44 24 08 86 e0 10 	movl   $0xc010e086,0x8(%esp)
c010a696:	c0 
c010a697:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a69b:	c7 04 24 90 e0 10 c0 	movl   $0xc010e090,(%esp)
c010a6a2:	e8 b1 5c ff ff       	call   c0100358 <cprintf>
c010a6a7:	b8 c7 79 00 00       	mov    $0x79c7,%eax
c010a6ac:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a6b0:	c7 44 24 04 11 05 18 	movl   $0xc0180511,0x4(%esp)
c010a6b7:	c0 
c010a6b8:	c7 04 24 86 e0 10 c0 	movl   $0xc010e086,(%esp)
c010a6bf:	e8 83 ff ff ff       	call   c010a647 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010a6c4:	c7 44 24 08 b7 e0 10 	movl   $0xc010e0b7,0x8(%esp)
c010a6cb:	c0 
c010a6cc:	c7 44 24 04 30 03 00 	movl   $0x330,0x4(%esp)
c010a6d3:	00 
c010a6d4:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a6db:	e8 fa 66 ff ff       	call   c0100dda <__panic>

c010a6e0 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010a6e0:	55                   	push   %ebp
c010a6e1:	89 e5                	mov    %esp,%ebp
c010a6e3:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010a6e6:	e8 c9 a7 ff ff       	call   c0104eb4 <nr_free_pages>
c010a6eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010a6ee:	e8 92 a1 ff ff       	call   c0104885 <kallocated>
c010a6f3:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010a6f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010a6fd:	00 
c010a6fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a705:	00 
c010a706:	c7 04 24 81 a6 10 c0 	movl   $0xc010a681,(%esp)
c010a70d:	e8 08 ef ff ff       	call   c010961a <kernel_thread>
c010a712:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010a715:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010a719:	7f 1c                	jg     c010a737 <init_main+0x57>
        panic("create user_main failed.\n");
c010a71b:	c7 44 24 08 d1 e0 10 	movl   $0xc010e0d1,0x8(%esp)
c010a722:	c0 
c010a723:	c7 44 24 04 3b 03 00 	movl   $0x33b,0x4(%esp)
c010a72a:	00 
c010a72b:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a732:	e8 a3 66 ff ff       	call   c0100dda <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010a737:	eb 05                	jmp    c010a73e <init_main+0x5e>
        schedule();
c010a739:	e8 65 08 00 00       	call   c010afa3 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010a73e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a745:	00 
c010a746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010a74d:	e8 ff fc ff ff       	call   c010a451 <do_wait>
c010a752:	85 c0                	test   %eax,%eax
c010a754:	74 e3                	je     c010a739 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010a756:	c7 04 24 ec e0 10 c0 	movl   $0xc010e0ec,(%esp)
c010a75d:	e8 f6 5b ff ff       	call   c0100358 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010a762:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a767:	8b 40 70             	mov    0x70(%eax),%eax
c010a76a:	85 c0                	test   %eax,%eax
c010a76c:	75 18                	jne    c010a786 <init_main+0xa6>
c010a76e:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a773:	8b 40 74             	mov    0x74(%eax),%eax
c010a776:	85 c0                	test   %eax,%eax
c010a778:	75 0c                	jne    c010a786 <init_main+0xa6>
c010a77a:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a77f:	8b 40 78             	mov    0x78(%eax),%eax
c010a782:	85 c0                	test   %eax,%eax
c010a784:	74 24                	je     c010a7aa <init_main+0xca>
c010a786:	c7 44 24 0c 10 e1 10 	movl   $0xc010e110,0xc(%esp)
c010a78d:	c0 
c010a78e:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a795:	c0 
c010a796:	c7 44 24 04 43 03 00 	movl   $0x343,0x4(%esp)
c010a79d:	00 
c010a79e:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a7a5:	e8 30 66 ff ff       	call   c0100dda <__panic>
    assert(nr_process == 2);
c010a7aa:	a1 40 0e 1b c0       	mov    0xc01b0e40,%eax
c010a7af:	83 f8 02             	cmp    $0x2,%eax
c010a7b2:	74 24                	je     c010a7d8 <init_main+0xf8>
c010a7b4:	c7 44 24 0c 5b e1 10 	movl   $0xc010e15b,0xc(%esp)
c010a7bb:	c0 
c010a7bc:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a7c3:	c0 
c010a7c4:	c7 44 24 04 44 03 00 	movl   $0x344,0x4(%esp)
c010a7cb:	00 
c010a7cc:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a7d3:	e8 02 66 ff ff       	call   c0100dda <__panic>
c010a7d8:	c7 45 e8 70 0f 1b c0 	movl   $0xc01b0f70,-0x18(%ebp)
c010a7df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a7e2:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010a7e5:	8b 15 24 ee 1a c0    	mov    0xc01aee24,%edx
c010a7eb:	83 c2 58             	add    $0x58,%edx
c010a7ee:	39 d0                	cmp    %edx,%eax
c010a7f0:	74 24                	je     c010a816 <init_main+0x136>
c010a7f2:	c7 44 24 0c 6c e1 10 	movl   $0xc010e16c,0xc(%esp)
c010a7f9:	c0 
c010a7fa:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a801:	c0 
c010a802:	c7 44 24 04 45 03 00 	movl   $0x345,0x4(%esp)
c010a809:	00 
c010a80a:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a811:	e8 c4 65 ff ff       	call   c0100dda <__panic>
c010a816:	c7 45 e4 70 0f 1b c0 	movl   $0xc01b0f70,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010a81d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010a820:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010a822:	8b 15 24 ee 1a c0    	mov    0xc01aee24,%edx
c010a828:	83 c2 58             	add    $0x58,%edx
c010a82b:	39 d0                	cmp    %edx,%eax
c010a82d:	74 24                	je     c010a853 <init_main+0x173>
c010a82f:	c7 44 24 0c 9c e1 10 	movl   $0xc010e19c,0xc(%esp)
c010a836:	c0 
c010a837:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a83e:	c0 
c010a83f:	c7 44 24 04 46 03 00 	movl   $0x346,0x4(%esp)
c010a846:	00 
c010a847:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a84e:	e8 87 65 ff ff       	call   c0100dda <__panic>

    cprintf("init check memory pass.\n");
c010a853:	c7 04 24 cc e1 10 c0 	movl   $0xc010e1cc,(%esp)
c010a85a:	e8 f9 5a ff ff       	call   c0100358 <cprintf>
    return 0;
c010a85f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a864:	c9                   	leave  
c010a865:	c3                   	ret    

c010a866 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010a866:	55                   	push   %ebp
c010a867:	89 e5                	mov    %esp,%ebp
c010a869:	83 ec 28             	sub    $0x28,%esp
c010a86c:	c7 45 ec 70 0f 1b c0 	movl   $0xc01b0f70,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010a873:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a876:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a879:	89 50 04             	mov    %edx,0x4(%eax)
c010a87c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a87f:	8b 50 04             	mov    0x4(%eax),%edx
c010a882:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a885:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010a887:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010a88e:	eb 26                	jmp    c010a8b6 <proc_init+0x50>
        list_init(hash_list + i);
c010a890:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a893:	c1 e0 03             	shl    $0x3,%eax
c010a896:	05 40 ee 1a c0       	add    $0xc01aee40,%eax
c010a89b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010a89e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a8a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010a8a4:	89 50 04             	mov    %edx,0x4(%eax)
c010a8a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a8aa:	8b 50 04             	mov    0x4(%eax),%edx
c010a8ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a8b0:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010a8b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010a8b6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010a8bd:	7e d1                	jle    c010a890 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010a8bf:	e8 a9 e8 ff ff       	call   c010916d <alloc_proc>
c010a8c4:	a3 20 ee 1a c0       	mov    %eax,0xc01aee20
c010a8c9:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a8ce:	85 c0                	test   %eax,%eax
c010a8d0:	75 1c                	jne    c010a8ee <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010a8d2:	c7 44 24 08 e5 e1 10 	movl   $0xc010e1e5,0x8(%esp)
c010a8d9:	c0 
c010a8da:	c7 44 24 04 58 03 00 	movl   $0x358,0x4(%esp)
c010a8e1:	00 
c010a8e2:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a8e9:	e8 ec 64 ff ff       	call   c0100dda <__panic>
    }

    idleproc->pid = 0;
c010a8ee:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a8f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010a8fa:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a8ff:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010a905:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a90a:	ba 00 a0 12 c0       	mov    $0xc012a000,%edx
c010a90f:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010a912:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a917:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010a91e:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a923:	c7 44 24 04 fd e1 10 	movl   $0xc010e1fd,0x4(%esp)
c010a92a:	c0 
c010a92b:	89 04 24             	mov    %eax,(%esp)
c010a92e:	e8 94 e8 ff ff       	call   c01091c7 <set_proc_name>
    nr_process ++;
c010a933:	a1 40 0e 1b c0       	mov    0xc01b0e40,%eax
c010a938:	83 c0 01             	add    $0x1,%eax
c010a93b:	a3 40 0e 1b c0       	mov    %eax,0xc01b0e40

    current = idleproc;
c010a940:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a945:	a3 28 ee 1a c0       	mov    %eax,0xc01aee28

    int pid = kernel_thread(init_main, NULL, 0);
c010a94a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010a951:	00 
c010a952:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a959:	00 
c010a95a:	c7 04 24 e0 a6 10 c0 	movl   $0xc010a6e0,(%esp)
c010a961:	e8 b4 ec ff ff       	call   c010961a <kernel_thread>
c010a966:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010a969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a96d:	7f 1c                	jg     c010a98b <proc_init+0x125>
        panic("create init_main failed.\n");
c010a96f:	c7 44 24 08 02 e2 10 	movl   $0xc010e202,0x8(%esp)
c010a976:	c0 
c010a977:	c7 44 24 04 66 03 00 	movl   $0x366,0x4(%esp)
c010a97e:	00 
c010a97f:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a986:	e8 4f 64 ff ff       	call   c0100dda <__panic>
    }

    initproc = find_proc(pid);
c010a98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a98e:	89 04 24             	mov    %eax,(%esp)
c010a991:	e8 12 ec ff ff       	call   c01095a8 <find_proc>
c010a996:	a3 24 ee 1a c0       	mov    %eax,0xc01aee24
    set_proc_name(initproc, "init");
c010a99b:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a9a0:	c7 44 24 04 1c e2 10 	movl   $0xc010e21c,0x4(%esp)
c010a9a7:	c0 
c010a9a8:	89 04 24             	mov    %eax,(%esp)
c010a9ab:	e8 17 e8 ff ff       	call   c01091c7 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010a9b0:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a9b5:	85 c0                	test   %eax,%eax
c010a9b7:	74 0c                	je     c010a9c5 <proc_init+0x15f>
c010a9b9:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010a9be:	8b 40 04             	mov    0x4(%eax),%eax
c010a9c1:	85 c0                	test   %eax,%eax
c010a9c3:	74 24                	je     c010a9e9 <proc_init+0x183>
c010a9c5:	c7 44 24 0c 24 e2 10 	movl   $0xc010e224,0xc(%esp)
c010a9cc:	c0 
c010a9cd:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010a9d4:	c0 
c010a9d5:	c7 44 24 04 6c 03 00 	movl   $0x36c,0x4(%esp)
c010a9dc:	00 
c010a9dd:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010a9e4:	e8 f1 63 ff ff       	call   c0100dda <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010a9e9:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a9ee:	85 c0                	test   %eax,%eax
c010a9f0:	74 0d                	je     c010a9ff <proc_init+0x199>
c010a9f2:	a1 24 ee 1a c0       	mov    0xc01aee24,%eax
c010a9f7:	8b 40 04             	mov    0x4(%eax),%eax
c010a9fa:	83 f8 01             	cmp    $0x1,%eax
c010a9fd:	74 24                	je     c010aa23 <proc_init+0x1bd>
c010a9ff:	c7 44 24 0c 4c e2 10 	movl   $0xc010e24c,0xc(%esp)
c010aa06:	c0 
c010aa07:	c7 44 24 08 8d de 10 	movl   $0xc010de8d,0x8(%esp)
c010aa0e:	c0 
c010aa0f:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
c010aa16:	00 
c010aa17:	c7 04 24 60 de 10 c0 	movl   $0xc010de60,(%esp)
c010aa1e:	e8 b7 63 ff ff       	call   c0100dda <__panic>
}
c010aa23:	c9                   	leave  
c010aa24:	c3                   	ret    

c010aa25 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010aa25:	55                   	push   %ebp
c010aa26:	89 e5                	mov    %esp,%ebp
c010aa28:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010aa2b:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010aa30:	8b 40 10             	mov    0x10(%eax),%eax
c010aa33:	85 c0                	test   %eax,%eax
c010aa35:	74 07                	je     c010aa3e <cpu_idle+0x19>
            schedule();
c010aa37:	e8 67 05 00 00       	call   c010afa3 <schedule>
        }
    }
c010aa3c:	eb ed                	jmp    c010aa2b <cpu_idle+0x6>
c010aa3e:	eb eb                	jmp    c010aa2b <cpu_idle+0x6>

c010aa40 <lab6_set_priority>:
}

//FOR LAB6, set the process's priority (bigger value will get more CPU time) 
void
lab6_set_priority(uint32_t priority)
{
c010aa40:	55                   	push   %ebp
c010aa41:	89 e5                	mov    %esp,%ebp
    if (priority == 0)
c010aa43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010aa47:	75 11                	jne    c010aa5a <lab6_set_priority+0x1a>
        current->lab6_priority = 1;
c010aa49:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010aa4e:	c7 80 9c 00 00 00 01 	movl   $0x1,0x9c(%eax)
c010aa55:	00 00 00 
c010aa58:	eb 0e                	jmp    c010aa68 <lab6_set_priority+0x28>
    else current->lab6_priority = priority;
c010aa5a:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010aa5f:	8b 55 08             	mov    0x8(%ebp),%edx
c010aa62:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
}
c010aa68:	5d                   	pop    %ebp
c010aa69:	c3                   	ret    

c010aa6a <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010aa6a:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010aa6e:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010aa70:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010aa73:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010aa76:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010aa79:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010aa7c:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010aa7f:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010aa82:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010aa85:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010aa89:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010aa8c:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010aa8f:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010aa92:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010aa95:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010aa98:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010aa9b:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010aa9e:	ff 30                	pushl  (%eax)

    ret
c010aaa0:	c3                   	ret    

c010aaa1 <skew_heap_merge>:
}

static inline skew_heap_entry_t *
skew_heap_merge(skew_heap_entry_t *a, skew_heap_entry_t *b,
                compare_f comp)
{
c010aaa1:	55                   	push   %ebp
c010aaa2:	89 e5                	mov    %esp,%ebp
c010aaa4:	83 ec 28             	sub    $0x28,%esp
     if (a == NULL) return b;
c010aaa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010aaab:	75 08                	jne    c010aab5 <skew_heap_merge+0x14>
c010aaad:	8b 45 0c             	mov    0xc(%ebp),%eax
c010aab0:	e9 bd 00 00 00       	jmp    c010ab72 <skew_heap_merge+0xd1>
     else if (b == NULL) return a;
c010aab5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010aab9:	75 08                	jne    c010aac3 <skew_heap_merge+0x22>
c010aabb:	8b 45 08             	mov    0x8(%ebp),%eax
c010aabe:	e9 af 00 00 00       	jmp    c010ab72 <skew_heap_merge+0xd1>
     
     skew_heap_entry_t *l, *r;
     if (comp(a, b) == -1)
c010aac3:	8b 45 0c             	mov    0xc(%ebp),%eax
c010aac6:	89 44 24 04          	mov    %eax,0x4(%esp)
c010aaca:	8b 45 08             	mov    0x8(%ebp),%eax
c010aacd:	89 04 24             	mov    %eax,(%esp)
c010aad0:	8b 45 10             	mov    0x10(%ebp),%eax
c010aad3:	ff d0                	call   *%eax
c010aad5:	83 f8 ff             	cmp    $0xffffffff,%eax
c010aad8:	75 4d                	jne    c010ab27 <skew_heap_merge+0x86>
     {
          r = a->left;
c010aada:	8b 45 08             	mov    0x8(%ebp),%eax
c010aadd:	8b 40 04             	mov    0x4(%eax),%eax
c010aae0:	89 45 f4             	mov    %eax,-0xc(%ebp)
          l = skew_heap_merge(a->right, b, comp);
c010aae3:	8b 45 08             	mov    0x8(%ebp),%eax
c010aae6:	8b 40 08             	mov    0x8(%eax),%eax
c010aae9:	8b 55 10             	mov    0x10(%ebp),%edx
c010aaec:	89 54 24 08          	mov    %edx,0x8(%esp)
c010aaf0:	8b 55 0c             	mov    0xc(%ebp),%edx
c010aaf3:	89 54 24 04          	mov    %edx,0x4(%esp)
c010aaf7:	89 04 24             	mov    %eax,(%esp)
c010aafa:	e8 a2 ff ff ff       	call   c010aaa1 <skew_heap_merge>
c010aaff:	89 45 f0             	mov    %eax,-0x10(%ebp)
          
          a->left = l;
c010ab02:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab05:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010ab08:	89 50 04             	mov    %edx,0x4(%eax)
          a->right = r;
c010ab0b:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010ab11:	89 50 08             	mov    %edx,0x8(%eax)
          if (l) l->parent = a;
c010ab14:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ab18:	74 08                	je     c010ab22 <skew_heap_merge+0x81>
c010ab1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ab1d:	8b 55 08             	mov    0x8(%ebp),%edx
c010ab20:	89 10                	mov    %edx,(%eax)

          return a;
c010ab22:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab25:	eb 4b                	jmp    c010ab72 <skew_heap_merge+0xd1>
     }
     else
     {
          r = b->left;
c010ab27:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ab2a:	8b 40 04             	mov    0x4(%eax),%eax
c010ab2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
          l = skew_heap_merge(a, b->right, comp);
c010ab30:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ab33:	8b 40 08             	mov    0x8(%eax),%eax
c010ab36:	8b 55 10             	mov    0x10(%ebp),%edx
c010ab39:	89 54 24 08          	mov    %edx,0x8(%esp)
c010ab3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010ab41:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab44:	89 04 24             	mov    %eax,(%esp)
c010ab47:	e8 55 ff ff ff       	call   c010aaa1 <skew_heap_merge>
c010ab4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
          
          b->left = l;
c010ab4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ab52:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010ab55:	89 50 04             	mov    %edx,0x4(%eax)
          b->right = r;
c010ab58:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ab5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010ab5e:	89 50 08             	mov    %edx,0x8(%eax)
          if (l) l->parent = b;
c010ab61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ab65:	74 08                	je     c010ab6f <skew_heap_merge+0xce>
c010ab67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ab6a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010ab6d:	89 10                	mov    %edx,(%eax)

          return b;
c010ab6f:	8b 45 0c             	mov    0xc(%ebp),%eax
     }
}
c010ab72:	c9                   	leave  
c010ab73:	c3                   	ret    

c010ab74 <proc_stride_comp_f>:

/* The compare function for two skew_heap_node_t's and the
 * corresponding procs*/
static int
proc_stride_comp_f(void *a, void *b)
{
c010ab74:	55                   	push   %ebp
c010ab75:	89 e5                	mov    %esp,%ebp
c010ab77:	83 ec 10             	sub    $0x10,%esp
    struct proc_struct *p = le2proc(a, lab6_run_pool);
c010ab7a:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab7d:	2d 8c 00 00 00       	sub    $0x8c,%eax
c010ab82:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc_struct *q = le2proc(b, lab6_run_pool);
c010ab85:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ab88:	2d 8c 00 00 00       	sub    $0x8c,%eax
c010ab8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    int32_t c = p->lab6_stride - q->lab6_stride;
c010ab90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ab93:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
c010ab99:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ab9c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
c010aba2:	29 c2                	sub    %eax,%edx
c010aba4:	89 d0                	mov    %edx,%eax
c010aba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (c > 0) return 1;
c010aba9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010abad:	7e 07                	jle    c010abb6 <proc_stride_comp_f+0x42>
c010abaf:	b8 01 00 00 00       	mov    $0x1,%eax
c010abb4:	eb 12                	jmp    c010abc8 <proc_stride_comp_f+0x54>
    else if (c == 0) return 0;
c010abb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010abba:	75 07                	jne    c010abc3 <proc_stride_comp_f+0x4f>
c010abbc:	b8 00 00 00 00       	mov    $0x0,%eax
c010abc1:	eb 05                	jmp    c010abc8 <proc_stride_comp_f+0x54>
    else return -1;
c010abc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
c010abc8:	c9                   	leave  
c010abc9:	c3                   	ret    

c010abca <stride_init>:
 *   - max_time_slice: no need here, the variable would be assigned by the caller.
 *
 * hint: see libs/list.h for routines of the list structures.
 */
static void
stride_init(struct run_queue *rq) {
c010abca:	55                   	push   %ebp
c010abcb:	89 e5                	mov    %esp,%ebp
      * (1) init the ready process list: rq->run_list
      * (2) init the run pool: rq->lab6_run_pool
      * (3) set number of process: rq->proc_num to 0       
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = 0;
c010abcd:	8b 45 08             	mov    0x8(%ebp),%eax
c010abd0:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
#else
    list_init(&rq->run_list);
#endif
    rq->proc_num = 0;
c010abd7:	8b 45 08             	mov    0x8(%ebp),%eax
c010abda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
c010abe1:	5d                   	pop    %ebp
c010abe2:	c3                   	ret    

c010abe3 <stride_enqueue>:
 * 
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_enqueue(struct run_queue *rq, struct proc_struct *proc) {
c010abe3:	55                   	push   %ebp
c010abe4:	89 e5                	mov    %esp,%ebp
c010abe6:	83 ec 28             	sub    $0x28,%esp
      * (2) recalculate proc->time_slice
      * (3) set proc->rq pointer to rq
      * (4) increase rq->proc_num
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
c010abe9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010abec:	8d 90 8c 00 00 00    	lea    0x8c(%eax),%edx
c010abf2:	8b 45 08             	mov    0x8(%ebp),%eax
c010abf5:	8b 40 10             	mov    0x10(%eax),%eax
c010abf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010abfb:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010abfe:	c7 45 ec 74 ab 10 c0 	movl   $0xc010ab74,-0x14(%ebp)
c010ac05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac08:	89 45 e8             	mov    %eax,-0x18(%ebp)
     compare_f comp) __attribute__((always_inline));

static inline void
skew_heap_init(skew_heap_entry_t *a)
{
     a->left = a->right = a->parent = NULL;
c010ac0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ac0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
c010ac14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ac17:	8b 10                	mov    (%eax),%edx
c010ac19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ac1c:	89 50 08             	mov    %edx,0x8(%eax)
c010ac1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ac22:	8b 50 08             	mov    0x8(%eax),%edx
c010ac25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ac28:	89 50 04             	mov    %edx,0x4(%eax)
static inline skew_heap_entry_t *
skew_heap_insert(skew_heap_entry_t *a, skew_heap_entry_t *b,
                 compare_f comp)
{
     skew_heap_init(b);
     return skew_heap_merge(a, b, comp);
c010ac2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ac2e:	89 44 24 08          	mov    %eax,0x8(%esp)
c010ac32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac35:	89 44 24 04          	mov    %eax,0x4(%esp)
c010ac39:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac3c:	89 04 24             	mov    %eax,(%esp)
c010ac3f:	e8 5d fe ff ff       	call   c010aaa1 <skew_heap_merge>
c010ac44:	89 c2                	mov    %eax,%edx
c010ac46:	8b 45 08             	mov    0x8(%ebp),%eax
c010ac49:	89 50 10             	mov    %edx,0x10(%eax)
#else
    list_add(&rq->run_list, &proc->run_link);
#endif
    proc->time_slice = rq->max_time_slice;
c010ac4c:	8b 45 08             	mov    0x8(%ebp),%eax
c010ac4f:	8b 50 0c             	mov    0xc(%eax),%edx
c010ac52:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ac55:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
    proc->rq = rq;
c010ac5b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ac5e:	8b 55 08             	mov    0x8(%ebp),%edx
c010ac61:	89 50 7c             	mov    %edx,0x7c(%eax)
    if (proc->lab6_priority == 0) proc->lab6_priority = 1;
c010ac64:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ac67:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
c010ac6d:	85 c0                	test   %eax,%eax
c010ac6f:	75 0d                	jne    c010ac7e <stride_enqueue+0x9b>
c010ac71:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ac74:	c7 80 9c 00 00 00 01 	movl   $0x1,0x9c(%eax)
c010ac7b:	00 00 00 
    rq->proc_num++;
c010ac7e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ac81:	8b 40 08             	mov    0x8(%eax),%eax
c010ac84:	8d 50 01             	lea    0x1(%eax),%edx
c010ac87:	8b 45 08             	mov    0x8(%ebp),%eax
c010ac8a:	89 50 08             	mov    %edx,0x8(%eax)
}
c010ac8d:	c9                   	leave  
c010ac8e:	c3                   	ret    

c010ac8f <stride_dequeue>:
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static void
stride_dequeue(struct run_queue *rq, struct proc_struct *proc) {
c010ac8f:	55                   	push   %ebp
c010ac90:	89 e5                	mov    %esp,%ebp
c010ac92:	83 ec 38             	sub    $0x38,%esp
      * NOTICE: you can use skew_heap or list. Important functions
      *         skew_heap_remove: remove a entry from skew_heap
      *         list_del_init: remove a entry from the  list
      */
#if USE_SKEW_HEAP
    rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);
c010ac95:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ac98:	8d 90 8c 00 00 00    	lea    0x8c(%eax),%edx
c010ac9e:	8b 45 08             	mov    0x8(%ebp),%eax
c010aca1:	8b 40 10             	mov    0x10(%eax),%eax
c010aca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aca7:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010acaa:	c7 45 ec 74 ab 10 c0 	movl   $0xc010ab74,-0x14(%ebp)

static inline skew_heap_entry_t *
skew_heap_remove(skew_heap_entry_t *a, skew_heap_entry_t *b,
                 compare_f comp)
{
     skew_heap_entry_t *p   = b->parent;
c010acb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010acb4:	8b 00                	mov    (%eax),%eax
c010acb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
     skew_heap_entry_t *rep = skew_heap_merge(b->left, b->right, comp);
c010acb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010acbc:	8b 50 08             	mov    0x8(%eax),%edx
c010acbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010acc2:	8b 40 04             	mov    0x4(%eax),%eax
c010acc5:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010acc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010accc:	89 54 24 04          	mov    %edx,0x4(%esp)
c010acd0:	89 04 24             	mov    %eax,(%esp)
c010acd3:	e8 c9 fd ff ff       	call   c010aaa1 <skew_heap_merge>
c010acd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     if (rep) rep->parent = p;
c010acdb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010acdf:	74 08                	je     c010ace9 <stride_dequeue+0x5a>
c010ace1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ace4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010ace7:	89 10                	mov    %edx,(%eax)
     
     if (p)
c010ace9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010aced:	74 24                	je     c010ad13 <stride_dequeue+0x84>
     {
          if (p->left == b)
c010acef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010acf2:	8b 40 04             	mov    0x4(%eax),%eax
c010acf5:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010acf8:	75 0b                	jne    c010ad05 <stride_dequeue+0x76>
               p->left = rep;
c010acfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010acfd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010ad00:	89 50 04             	mov    %edx,0x4(%eax)
c010ad03:	eb 09                	jmp    c010ad0e <stride_dequeue+0x7f>
          else p->right = rep;
c010ad05:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ad08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010ad0b:	89 50 08             	mov    %edx,0x8(%eax)
          return a;
c010ad0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ad11:	eb 03                	jmp    c010ad16 <stride_dequeue+0x87>
     }
     else return rep;
c010ad13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ad16:	89 c2                	mov    %eax,%edx
c010ad18:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad1b:	89 50 10             	mov    %edx,0x10(%eax)
#else
    list_del(&proc->run_link);
#endif
    rq->proc_num--;
c010ad1e:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad21:	8b 40 08             	mov    0x8(%eax),%eax
c010ad24:	8d 50 ff             	lea    -0x1(%eax),%edx
c010ad27:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad2a:	89 50 08             	mov    %edx,0x8(%eax)
}
c010ad2d:	c9                   	leave  
c010ad2e:	c3                   	ret    

c010ad2f <stride_pick_next>:
 *
 * hint: see libs/skew_heap.h for routines of the priority
 * queue structures.
 */
static struct proc_struct *
stride_pick_next(struct run_queue *rq) {
c010ad2f:	55                   	push   %ebp
c010ad30:	89 e5                	mov    %esp,%ebp
c010ad32:	53                   	push   %ebx
c010ad33:	83 ec 10             	sub    $0x10,%esp
             (1.2) If using list, we have to search list to find the p with minimum stride value
      * (2) update p;s stride value: p->lab6_stride
      * (3) return p
      */
#if USE_SKEW_HEAP
    if (!rq->lab6_run_pool) return NULL;
c010ad36:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad39:	8b 40 10             	mov    0x10(%eax),%eax
c010ad3c:	85 c0                	test   %eax,%eax
c010ad3e:	75 07                	jne    c010ad47 <stride_pick_next+0x18>
c010ad40:	b8 00 00 00 00       	mov    $0x0,%eax
c010ad45:	eb 41                	jmp    c010ad88 <stride_pick_next+0x59>
    struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);
c010ad47:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad4a:	8b 40 10             	mov    0x10(%eax),%eax
c010ad4d:	2d 8c 00 00 00       	sub    $0x8c,%eax
c010ad52:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for (le = list_next(&rq->run_list); le != &rq->run_list; le = list_next(le)) {
        struct proc_struct *q = le2proc(le, run_link);
        if (!p || proc_stride_comp_f(&p->lab6_run_pool, &q->lab6_run_pool) == 1) p = q;
    }
#endif
    if (p) p->lab6_stride += BIG_STRIDE / p->lab6_priority;
c010ad55:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010ad59:	74 2a                	je     c010ad85 <stride_pick_next+0x56>
c010ad5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ad5e:	8b 88 98 00 00 00    	mov    0x98(%eax),%ecx
c010ad64:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ad67:	8b 98 9c 00 00 00    	mov    0x9c(%eax),%ebx
c010ad6d:	b8 ff ff ff 7f       	mov    $0x7fffffff,%eax
c010ad72:	ba 00 00 00 00       	mov    $0x0,%edx
c010ad77:	f7 f3                	div    %ebx
c010ad79:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c010ad7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ad7f:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    return p;
c010ad85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010ad88:	83 c4 10             	add    $0x10,%esp
c010ad8b:	5b                   	pop    %ebx
c010ad8c:	5d                   	pop    %ebp
c010ad8d:	c3                   	ret    

c010ad8e <stride_proc_tick>:
 * denotes the time slices left for current
 * process. proc->need_resched is the flag variable for process
 * switching.
 */
static void
stride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {
c010ad8e:	55                   	push   %ebp
c010ad8f:	89 e5                	mov    %esp,%ebp
     /* LAB6: 2013011303 */
    if (--proc->time_slice <= 0) proc->need_resched = 1;
c010ad91:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ad94:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
c010ad9a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010ad9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ada0:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
c010ada6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ada9:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
c010adaf:	85 c0                	test   %eax,%eax
c010adb1:	7f 0a                	jg     c010adbd <stride_proc_tick+0x2f>
c010adb3:	8b 45 0c             	mov    0xc(%ebp),%eax
c010adb6:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
}
c010adbd:	5d                   	pop    %ebp
c010adbe:	c3                   	ret    

c010adbf <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010adbf:	55                   	push   %ebp
c010adc0:	89 e5                	mov    %esp,%ebp
c010adc2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010adc5:	9c                   	pushf  
c010adc6:	58                   	pop    %eax
c010adc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010adca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010adcd:	25 00 02 00 00       	and    $0x200,%eax
c010add2:	85 c0                	test   %eax,%eax
c010add4:	74 0c                	je     c010ade2 <__intr_save+0x23>
        intr_disable();
c010add6:	e8 57 72 ff ff       	call   c0102032 <intr_disable>
        return 1;
c010addb:	b8 01 00 00 00       	mov    $0x1,%eax
c010ade0:	eb 05                	jmp    c010ade7 <__intr_save+0x28>
    }
    return 0;
c010ade2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ade7:	c9                   	leave  
c010ade8:	c3                   	ret    

c010ade9 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010ade9:	55                   	push   %ebp
c010adea:	89 e5                	mov    %esp,%ebp
c010adec:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010adef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010adf3:	74 05                	je     c010adfa <__intr_restore+0x11>
        intr_enable();
c010adf5:	e8 32 72 ff ff       	call   c010202c <intr_enable>
    }
}
c010adfa:	c9                   	leave  
c010adfb:	c3                   	ret    

c010adfc <sched_class_enqueue>:
static struct sched_class *sched_class;

static struct run_queue *rq;

static inline void
sched_class_enqueue(struct proc_struct *proc) {
c010adfc:	55                   	push   %ebp
c010adfd:	89 e5                	mov    %esp,%ebp
c010adff:	83 ec 18             	sub    $0x18,%esp
    if (proc != idleproc) {
c010ae02:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010ae07:	39 45 08             	cmp    %eax,0x8(%ebp)
c010ae0a:	74 1a                	je     c010ae26 <sched_class_enqueue+0x2a>
        sched_class->enqueue(rq, proc);
c010ae0c:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010ae11:	8b 40 08             	mov    0x8(%eax),%eax
c010ae14:	8b 15 60 0e 1b c0    	mov    0xc01b0e60,%edx
c010ae1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
c010ae1d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010ae21:	89 14 24             	mov    %edx,(%esp)
c010ae24:	ff d0                	call   *%eax
    }
}
c010ae26:	c9                   	leave  
c010ae27:	c3                   	ret    

c010ae28 <sched_class_dequeue>:

static inline void
sched_class_dequeue(struct proc_struct *proc) {
c010ae28:	55                   	push   %ebp
c010ae29:	89 e5                	mov    %esp,%ebp
c010ae2b:	83 ec 18             	sub    $0x18,%esp
    sched_class->dequeue(rq, proc);
c010ae2e:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010ae33:	8b 40 0c             	mov    0xc(%eax),%eax
c010ae36:	8b 15 60 0e 1b c0    	mov    0xc01b0e60,%edx
c010ae3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
c010ae3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010ae43:	89 14 24             	mov    %edx,(%esp)
c010ae46:	ff d0                	call   *%eax
}
c010ae48:	c9                   	leave  
c010ae49:	c3                   	ret    

c010ae4a <sched_class_pick_next>:

static inline struct proc_struct *
sched_class_pick_next(void) {
c010ae4a:	55                   	push   %ebp
c010ae4b:	89 e5                	mov    %esp,%ebp
c010ae4d:	83 ec 18             	sub    $0x18,%esp
    return sched_class->pick_next(rq);
c010ae50:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010ae55:	8b 40 10             	mov    0x10(%eax),%eax
c010ae58:	8b 15 60 0e 1b c0    	mov    0xc01b0e60,%edx
c010ae5e:	89 14 24             	mov    %edx,(%esp)
c010ae61:	ff d0                	call   *%eax
}
c010ae63:	c9                   	leave  
c010ae64:	c3                   	ret    

c010ae65 <sched_class_proc_tick>:

static void
sched_class_proc_tick(struct proc_struct *proc) {
c010ae65:	55                   	push   %ebp
c010ae66:	89 e5                	mov    %esp,%ebp
c010ae68:	83 ec 18             	sub    $0x18,%esp
    if (proc != idleproc) {
c010ae6b:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010ae70:	39 45 08             	cmp    %eax,0x8(%ebp)
c010ae73:	74 1c                	je     c010ae91 <sched_class_proc_tick+0x2c>
        sched_class->proc_tick(rq, proc);
c010ae75:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010ae7a:	8b 40 14             	mov    0x14(%eax),%eax
c010ae7d:	8b 15 60 0e 1b c0    	mov    0xc01b0e60,%edx
c010ae83:	8b 4d 08             	mov    0x8(%ebp),%ecx
c010ae86:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010ae8a:	89 14 24             	mov    %edx,(%esp)
c010ae8d:	ff d0                	call   *%eax
c010ae8f:	eb 0a                	jmp    c010ae9b <sched_class_proc_tick+0x36>
    }
    else {
        proc->need_resched = 1;
c010ae91:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae94:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    }
}
c010ae9b:	c9                   	leave  
c010ae9c:	c3                   	ret    

c010ae9d <sched_init>:

static struct run_queue __rq;

void
sched_init(void) {
c010ae9d:	55                   	push   %ebp
c010ae9e:	89 e5                	mov    %esp,%ebp
c010aea0:	83 ec 28             	sub    $0x28,%esp
c010aea3:	c7 45 f4 54 0e 1b c0 	movl   $0xc01b0e54,-0xc(%ebp)
c010aeaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aead:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010aeb0:	89 50 04             	mov    %edx,0x4(%eax)
c010aeb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aeb6:	8b 50 04             	mov    0x4(%eax),%edx
c010aeb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aebc:	89 10                	mov    %edx,(%eax)
    list_init(&timer_list);

    sched_class = &default_sched_class;
c010aebe:	c7 05 5c 0e 1b c0 88 	movl   $0xc012ca88,0xc01b0e5c
c010aec5:	ca 12 c0 

    rq = &__rq;
c010aec8:	c7 05 60 0e 1b c0 64 	movl   $0xc01b0e64,0xc01b0e60
c010aecf:	0e 1b c0 
    rq->max_time_slice = MAX_TIME_SLICE;
c010aed2:	a1 60 0e 1b c0       	mov    0xc01b0e60,%eax
c010aed7:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    sched_class->init(rq);
c010aede:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010aee3:	8b 40 04             	mov    0x4(%eax),%eax
c010aee6:	8b 15 60 0e 1b c0    	mov    0xc01b0e60,%edx
c010aeec:	89 14 24             	mov    %edx,(%esp)
c010aeef:	ff d0                	call   *%eax

    cprintf("sched class: %s\n", sched_class->name);
c010aef1:	a1 5c 0e 1b c0       	mov    0xc01b0e5c,%eax
c010aef6:	8b 00                	mov    (%eax),%eax
c010aef8:	89 44 24 04          	mov    %eax,0x4(%esp)
c010aefc:	c7 04 24 84 e2 10 c0 	movl   $0xc010e284,(%esp)
c010af03:	e8 50 54 ff ff       	call   c0100358 <cprintf>
}
c010af08:	c9                   	leave  
c010af09:	c3                   	ret    

c010af0a <wakeup_proc>:

void
wakeup_proc(struct proc_struct *proc) {
c010af0a:	55                   	push   %ebp
c010af0b:	89 e5                	mov    %esp,%ebp
c010af0d:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010af10:	8b 45 08             	mov    0x8(%ebp),%eax
c010af13:	8b 00                	mov    (%eax),%eax
c010af15:	83 f8 03             	cmp    $0x3,%eax
c010af18:	75 24                	jne    c010af3e <wakeup_proc+0x34>
c010af1a:	c7 44 24 0c 95 e2 10 	movl   $0xc010e295,0xc(%esp)
c010af21:	c0 
c010af22:	c7 44 24 08 b0 e2 10 	movl   $0xc010e2b0,0x8(%esp)
c010af29:	c0 
c010af2a:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
c010af31:	00 
c010af32:	c7 04 24 c5 e2 10 c0 	movl   $0xc010e2c5,(%esp)
c010af39:	e8 9c 5e ff ff       	call   c0100dda <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010af3e:	e8 7c fe ff ff       	call   c010adbf <__intr_save>
c010af43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010af46:	8b 45 08             	mov    0x8(%ebp),%eax
c010af49:	8b 00                	mov    (%eax),%eax
c010af4b:	83 f8 02             	cmp    $0x2,%eax
c010af4e:	74 2a                	je     c010af7a <wakeup_proc+0x70>
            proc->state = PROC_RUNNABLE;
c010af50:	8b 45 08             	mov    0x8(%ebp),%eax
c010af53:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010af59:	8b 45 08             	mov    0x8(%ebp),%eax
c010af5c:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
            if (proc != current) {
c010af63:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010af68:	39 45 08             	cmp    %eax,0x8(%ebp)
c010af6b:	74 29                	je     c010af96 <wakeup_proc+0x8c>
                sched_class_enqueue(proc);
c010af6d:	8b 45 08             	mov    0x8(%ebp),%eax
c010af70:	89 04 24             	mov    %eax,(%esp)
c010af73:	e8 84 fe ff ff       	call   c010adfc <sched_class_enqueue>
c010af78:	eb 1c                	jmp    c010af96 <wakeup_proc+0x8c>
            }
        }
        else {
            warn("wakeup runnable process.\n");
c010af7a:	c7 44 24 08 db e2 10 	movl   $0xc010e2db,0x8(%esp)
c010af81:	c0 
c010af82:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c010af89:	00 
c010af8a:	c7 04 24 c5 e2 10 c0 	movl   $0xc010e2c5,(%esp)
c010af91:	e8 b0 5e ff ff       	call   c0100e46 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010af96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010af99:	89 04 24             	mov    %eax,(%esp)
c010af9c:	e8 48 fe ff ff       	call   c010ade9 <__intr_restore>
}
c010afa1:	c9                   	leave  
c010afa2:	c3                   	ret    

c010afa3 <schedule>:

void
schedule(void) {
c010afa3:	55                   	push   %ebp
c010afa4:	89 e5                	mov    %esp,%ebp
c010afa6:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    struct proc_struct *next;
    local_intr_save(intr_flag);
c010afa9:	e8 11 fe ff ff       	call   c010adbf <__intr_save>
c010afae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        current->need_resched = 0;
c010afb1:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010afb6:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        if (current->state == PROC_RUNNABLE) {
c010afbd:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010afc2:	8b 00                	mov    (%eax),%eax
c010afc4:	83 f8 02             	cmp    $0x2,%eax
c010afc7:	75 0d                	jne    c010afd6 <schedule+0x33>
            sched_class_enqueue(current);
c010afc9:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010afce:	89 04 24             	mov    %eax,(%esp)
c010afd1:	e8 26 fe ff ff       	call   c010adfc <sched_class_enqueue>
        }
        if ((next = sched_class_pick_next()) != NULL) {
c010afd6:	e8 6f fe ff ff       	call   c010ae4a <sched_class_pick_next>
c010afdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010afde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010afe2:	74 0b                	je     c010afef <schedule+0x4c>
            sched_class_dequeue(next);
c010afe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010afe7:	89 04 24             	mov    %eax,(%esp)
c010afea:	e8 39 fe ff ff       	call   c010ae28 <sched_class_dequeue>
        }
        if (next == NULL) {
c010afef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010aff3:	75 08                	jne    c010affd <schedule+0x5a>
            next = idleproc;
c010aff5:	a1 20 ee 1a c0       	mov    0xc01aee20,%eax
c010affa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        next->runs ++;
c010affd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b000:	8b 40 08             	mov    0x8(%eax),%eax
c010b003:	8d 50 01             	lea    0x1(%eax),%edx
c010b006:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b009:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010b00c:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b011:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010b014:	74 0b                	je     c010b021 <schedule+0x7e>
            proc_run(next);
c010b016:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b019:	89 04 24             	mov    %eax,(%esp)
c010b01c:	e8 4b e4 ff ff       	call   c010946c <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010b021:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b024:	89 04 24             	mov    %eax,(%esp)
c010b027:	e8 bd fd ff ff       	call   c010ade9 <__intr_restore>
}
c010b02c:	c9                   	leave  
c010b02d:	c3                   	ret    

c010b02e <schedule_tick>:

int schedule_tick() {
c010b02e:	55                   	push   %ebp
c010b02f:	89 e5                	mov    %esp,%ebp
c010b031:	83 ec 18             	sub    $0x18,%esp
    sched_class_proc_tick(current);
c010b034:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b039:	89 04 24             	mov    %eax,(%esp)
c010b03c:	e8 24 fe ff ff       	call   c010ae65 <sched_class_proc_tick>
    return 0;
c010b041:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b046:	c9                   	leave  
c010b047:	c3                   	ret    

c010b048 <sys_exit>:
#include <pmm.h>
#include <assert.h>
#include <clock.h>

static int
sys_exit(uint32_t arg[]) {
c010b048:	55                   	push   %ebp
c010b049:	89 e5                	mov    %esp,%ebp
c010b04b:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010b04e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b051:	8b 00                	mov    (%eax),%eax
c010b053:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010b056:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b059:	89 04 24             	mov    %eax,(%esp)
c010b05c:	e8 72 ea ff ff       	call   c0109ad3 <do_exit>
}
c010b061:	c9                   	leave  
c010b062:	c3                   	ret    

c010b063 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010b063:	55                   	push   %ebp
c010b064:	89 e5                	mov    %esp,%ebp
c010b066:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010b069:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b06e:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b071:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010b074:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b077:	8b 40 44             	mov    0x44(%eax),%eax
c010b07a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010b07d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b080:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b084:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b087:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b08b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010b092:	e8 18 e9 ff ff       	call   c01099af <do_fork>
}
c010b097:	c9                   	leave  
c010b098:	c3                   	ret    

c010b099 <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010b099:	55                   	push   %ebp
c010b09a:	89 e5                	mov    %esp,%ebp
c010b09c:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b09f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0a2:	8b 00                	mov    (%eax),%eax
c010b0a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010b0a7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0aa:	83 c0 04             	add    $0x4,%eax
c010b0ad:	8b 00                	mov    (%eax),%eax
c010b0af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010b0b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b0b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0bc:	89 04 24             	mov    %eax,(%esp)
c010b0bf:	e8 8d f3 ff ff       	call   c010a451 <do_wait>
}
c010b0c4:	c9                   	leave  
c010b0c5:	c3                   	ret    

c010b0c6 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010b0c6:	55                   	push   %ebp
c010b0c7:	89 e5                	mov    %esp,%ebp
c010b0c9:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010b0cc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0cf:	8b 00                	mov    (%eax),%eax
c010b0d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010b0d4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0d7:	8b 40 04             	mov    0x4(%eax),%eax
c010b0da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010b0dd:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0e0:	83 c0 08             	add    $0x8,%eax
c010b0e3:	8b 00                	mov    (%eax),%eax
c010b0e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010b0e8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b0eb:	8b 40 0c             	mov    0xc(%eax),%eax
c010b0ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010b0f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b0f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b0f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b0fb:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b0ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b102:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b106:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b109:	89 04 24             	mov    %eax,(%esp)
c010b10c:	e8 f4 f1 ff ff       	call   c010a305 <do_execve>
}
c010b111:	c9                   	leave  
c010b112:	c3                   	ret    

c010b113 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010b113:	55                   	push   %ebp
c010b114:	89 e5                	mov    %esp,%ebp
c010b116:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010b119:	e8 1d f3 ff ff       	call   c010a43b <do_yield>
}
c010b11e:	c9                   	leave  
c010b11f:	c3                   	ret    

c010b120 <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010b120:	55                   	push   %ebp
c010b121:	89 e5                	mov    %esp,%ebp
c010b123:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b126:	8b 45 08             	mov    0x8(%ebp),%eax
c010b129:	8b 00                	mov    (%eax),%eax
c010b12b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010b12e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b131:	89 04 24             	mov    %eax,(%esp)
c010b134:	e8 ac f4 ff ff       	call   c010a5e5 <do_kill>
}
c010b139:	c9                   	leave  
c010b13a:	c3                   	ret    

c010b13b <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010b13b:	55                   	push   %ebp
c010b13c:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010b13e:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b143:	8b 40 04             	mov    0x4(%eax),%eax
}
c010b146:	5d                   	pop    %ebp
c010b147:	c3                   	ret    

c010b148 <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010b148:	55                   	push   %ebp
c010b149:	89 e5                	mov    %esp,%ebp
c010b14b:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010b14e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b151:	8b 00                	mov    (%eax),%eax
c010b153:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010b156:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b159:	89 04 24             	mov    %eax,(%esp)
c010b15c:	e8 1d 52 ff ff       	call   c010037e <cputchar>
    return 0;
c010b161:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b166:	c9                   	leave  
c010b167:	c3                   	ret    

c010b168 <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010b168:	55                   	push   %ebp
c010b169:	89 e5                	mov    %esp,%ebp
c010b16b:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010b16e:	e8 99 b7 ff ff       	call   c010690c <print_pgdir>
    return 0;
c010b173:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b178:	c9                   	leave  
c010b179:	c3                   	ret    

c010b17a <sys_gettime>:

static int
sys_gettime(uint32_t arg[]) {
c010b17a:	55                   	push   %ebp
c010b17b:	89 e5                	mov    %esp,%ebp
    return (int)ticks;
c010b17d:	a1 78 0e 1b c0       	mov    0xc01b0e78,%eax
}
c010b182:	5d                   	pop    %ebp
c010b183:	c3                   	ret    

c010b184 <sys_lab6_set_priority>:
static int
sys_lab6_set_priority(uint32_t arg[])
{
c010b184:	55                   	push   %ebp
c010b185:	89 e5                	mov    %esp,%ebp
c010b187:	83 ec 28             	sub    $0x28,%esp
    uint32_t priority = (uint32_t)arg[0];
c010b18a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b18d:	8b 00                	mov    (%eax),%eax
c010b18f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    lab6_set_priority(priority);
c010b192:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b195:	89 04 24             	mov    %eax,(%esp)
c010b198:	e8 a3 f8 ff ff       	call   c010aa40 <lab6_set_priority>
    return 0;
c010b19d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b1a2:	c9                   	leave  
c010b1a3:	c3                   	ret    

c010b1a4 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010b1a4:	55                   	push   %ebp
c010b1a5:	89 e5                	mov    %esp,%ebp
c010b1a7:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010b1aa:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b1af:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010b1b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1b8:	8b 40 1c             	mov    0x1c(%eax),%eax
c010b1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010b1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b1c2:	78 60                	js     c010b224 <syscall+0x80>
c010b1c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b1c7:	3d ff 00 00 00       	cmp    $0xff,%eax
c010b1cc:	77 56                	ja     c010b224 <syscall+0x80>
        if (syscalls[num] != NULL) {
c010b1ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b1d1:	8b 04 85 a0 ca 12 c0 	mov    -0x3fed3560(,%eax,4),%eax
c010b1d8:	85 c0                	test   %eax,%eax
c010b1da:	74 48                	je     c010b224 <syscall+0x80>
            arg[0] = tf->tf_regs.reg_edx;
c010b1dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1df:	8b 40 14             	mov    0x14(%eax),%eax
c010b1e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010b1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1e8:	8b 40 18             	mov    0x18(%eax),%eax
c010b1eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b1ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1f1:	8b 40 10             	mov    0x10(%eax),%eax
c010b1f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b1f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1fa:	8b 00                	mov    (%eax),%eax
c010b1fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b1ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b202:	8b 40 04             	mov    0x4(%eax),%eax
c010b205:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b208:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b20b:	8b 04 85 a0 ca 12 c0 	mov    -0x3fed3560(,%eax,4),%eax
c010b212:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010b215:	89 14 24             	mov    %edx,(%esp)
c010b218:	ff d0                	call   *%eax
c010b21a:	89 c2                	mov    %eax,%edx
c010b21c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b21f:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010b222:	eb 46                	jmp    c010b26a <syscall+0xc6>
        }
    }
    print_trapframe(tf);
c010b224:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b227:	89 04 24             	mov    %eax,(%esp)
c010b22a:	e8 63 71 ff ff       	call   c0102392 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b22f:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b234:	8d 50 48             	lea    0x48(%eax),%edx
c010b237:	a1 28 ee 1a c0       	mov    0xc01aee28,%eax
c010b23c:	8b 40 04             	mov    0x4(%eax),%eax
c010b23f:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b243:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b247:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b24a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b24e:	c7 44 24 08 f8 e2 10 	movl   $0xc010e2f8,0x8(%esp)
c010b255:	c0 
c010b256:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c010b25d:	00 
c010b25e:	c7 04 24 24 e3 10 c0 	movl   $0xc010e324,(%esp)
c010b265:	e8 70 5b ff ff       	call   c0100dda <__panic>
            num, current->pid, current->name);
}
c010b26a:	c9                   	leave  
c010b26b:	c3                   	ret    

c010b26c <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b26c:	55                   	push   %ebp
c010b26d:	89 e5                	mov    %esp,%ebp
c010b26f:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b272:	8b 45 08             	mov    0x8(%ebp),%eax
c010b275:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b27b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010b27e:	b8 20 00 00 00       	mov    $0x20,%eax
c010b283:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b286:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010b289:	89 c1                	mov    %eax,%ecx
c010b28b:	d3 ea                	shr    %cl,%edx
c010b28d:	89 d0                	mov    %edx,%eax
}
c010b28f:	c9                   	leave  
c010b290:	c3                   	ret    

c010b291 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b291:	55                   	push   %ebp
c010b292:	89 e5                	mov    %esp,%ebp
c010b294:	83 ec 58             	sub    $0x58,%esp
c010b297:	8b 45 10             	mov    0x10(%ebp),%eax
c010b29a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b29d:	8b 45 14             	mov    0x14(%ebp),%eax
c010b2a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b2a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b2a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b2a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b2ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b2af:	8b 45 18             	mov    0x18(%ebp),%eax
c010b2b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b2b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b2b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b2bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b2be:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010b2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b2c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b2cb:	74 1c                	je     c010b2e9 <printnum+0x58>
c010b2cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2d0:	ba 00 00 00 00       	mov    $0x0,%edx
c010b2d5:	f7 75 e4             	divl   -0x1c(%ebp)
c010b2d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b2db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2de:	ba 00 00 00 00       	mov    $0x0,%edx
c010b2e3:	f7 75 e4             	divl   -0x1c(%ebp)
c010b2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b2e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b2ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b2ef:	f7 75 e4             	divl   -0x1c(%ebp)
c010b2f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b2f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010b2f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b2fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b2fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b301:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b304:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b307:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b30a:	8b 45 18             	mov    0x18(%ebp),%eax
c010b30d:	ba 00 00 00 00       	mov    $0x0,%edx
c010b312:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b315:	77 56                	ja     c010b36d <printnum+0xdc>
c010b317:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b31a:	72 05                	jb     c010b321 <printnum+0x90>
c010b31c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b31f:	77 4c                	ja     c010b36d <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b321:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b324:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b327:	8b 45 20             	mov    0x20(%ebp),%eax
c010b32a:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b32e:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b332:	8b 45 18             	mov    0x18(%ebp),%eax
c010b335:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b339:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b33c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b33f:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b343:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b347:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b34a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b34e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b351:	89 04 24             	mov    %eax,(%esp)
c010b354:	e8 38 ff ff ff       	call   c010b291 <printnum>
c010b359:	eb 1c                	jmp    c010b377 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b35b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b35e:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b362:	8b 45 20             	mov    0x20(%ebp),%eax
c010b365:	89 04 24             	mov    %eax,(%esp)
c010b368:	8b 45 08             	mov    0x8(%ebp),%eax
c010b36b:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b36d:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b371:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b375:	7f e4                	jg     c010b35b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b377:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b37a:	05 44 e4 10 c0       	add    $0xc010e444,%eax
c010b37f:	0f b6 00             	movzbl (%eax),%eax
c010b382:	0f be c0             	movsbl %al,%eax
c010b385:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b388:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b38c:	89 04 24             	mov    %eax,(%esp)
c010b38f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b392:	ff d0                	call   *%eax
}
c010b394:	c9                   	leave  
c010b395:	c3                   	ret    

c010b396 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b396:	55                   	push   %ebp
c010b397:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b399:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b39d:	7e 14                	jle    c010b3b3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b39f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3a2:	8b 00                	mov    (%eax),%eax
c010b3a4:	8d 48 08             	lea    0x8(%eax),%ecx
c010b3a7:	8b 55 08             	mov    0x8(%ebp),%edx
c010b3aa:	89 0a                	mov    %ecx,(%edx)
c010b3ac:	8b 50 04             	mov    0x4(%eax),%edx
c010b3af:	8b 00                	mov    (%eax),%eax
c010b3b1:	eb 30                	jmp    c010b3e3 <getuint+0x4d>
    }
    else if (lflag) {
c010b3b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b3b7:	74 16                	je     c010b3cf <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b3b9:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3bc:	8b 00                	mov    (%eax),%eax
c010b3be:	8d 48 04             	lea    0x4(%eax),%ecx
c010b3c1:	8b 55 08             	mov    0x8(%ebp),%edx
c010b3c4:	89 0a                	mov    %ecx,(%edx)
c010b3c6:	8b 00                	mov    (%eax),%eax
c010b3c8:	ba 00 00 00 00       	mov    $0x0,%edx
c010b3cd:	eb 14                	jmp    c010b3e3 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b3cf:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3d2:	8b 00                	mov    (%eax),%eax
c010b3d4:	8d 48 04             	lea    0x4(%eax),%ecx
c010b3d7:	8b 55 08             	mov    0x8(%ebp),%edx
c010b3da:	89 0a                	mov    %ecx,(%edx)
c010b3dc:	8b 00                	mov    (%eax),%eax
c010b3de:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b3e3:	5d                   	pop    %ebp
c010b3e4:	c3                   	ret    

c010b3e5 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b3e5:	55                   	push   %ebp
c010b3e6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b3e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b3ec:	7e 14                	jle    c010b402 <getint+0x1d>
        return va_arg(*ap, long long);
c010b3ee:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3f1:	8b 00                	mov    (%eax),%eax
c010b3f3:	8d 48 08             	lea    0x8(%eax),%ecx
c010b3f6:	8b 55 08             	mov    0x8(%ebp),%edx
c010b3f9:	89 0a                	mov    %ecx,(%edx)
c010b3fb:	8b 50 04             	mov    0x4(%eax),%edx
c010b3fe:	8b 00                	mov    (%eax),%eax
c010b400:	eb 28                	jmp    c010b42a <getint+0x45>
    }
    else if (lflag) {
c010b402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b406:	74 12                	je     c010b41a <getint+0x35>
        return va_arg(*ap, long);
c010b408:	8b 45 08             	mov    0x8(%ebp),%eax
c010b40b:	8b 00                	mov    (%eax),%eax
c010b40d:	8d 48 04             	lea    0x4(%eax),%ecx
c010b410:	8b 55 08             	mov    0x8(%ebp),%edx
c010b413:	89 0a                	mov    %ecx,(%edx)
c010b415:	8b 00                	mov    (%eax),%eax
c010b417:	99                   	cltd   
c010b418:	eb 10                	jmp    c010b42a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b41a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b41d:	8b 00                	mov    (%eax),%eax
c010b41f:	8d 48 04             	lea    0x4(%eax),%ecx
c010b422:	8b 55 08             	mov    0x8(%ebp),%edx
c010b425:	89 0a                	mov    %ecx,(%edx)
c010b427:	8b 00                	mov    (%eax),%eax
c010b429:	99                   	cltd   
    }
}
c010b42a:	5d                   	pop    %ebp
c010b42b:	c3                   	ret    

c010b42c <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b42c:	55                   	push   %ebp
c010b42d:	89 e5                	mov    %esp,%ebp
c010b42f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b432:	8d 45 14             	lea    0x14(%ebp),%eax
c010b435:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b438:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b43b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b43f:	8b 45 10             	mov    0x10(%ebp),%eax
c010b442:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b446:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b449:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b44d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b450:	89 04 24             	mov    %eax,(%esp)
c010b453:	e8 02 00 00 00       	call   c010b45a <vprintfmt>
    va_end(ap);
}
c010b458:	c9                   	leave  
c010b459:	c3                   	ret    

c010b45a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b45a:	55                   	push   %ebp
c010b45b:	89 e5                	mov    %esp,%ebp
c010b45d:	56                   	push   %esi
c010b45e:	53                   	push   %ebx
c010b45f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b462:	eb 18                	jmp    c010b47c <vprintfmt+0x22>
            if (ch == '\0') {
c010b464:	85 db                	test   %ebx,%ebx
c010b466:	75 05                	jne    c010b46d <vprintfmt+0x13>
                return;
c010b468:	e9 d1 03 00 00       	jmp    c010b83e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b46d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b470:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b474:	89 1c 24             	mov    %ebx,(%esp)
c010b477:	8b 45 08             	mov    0x8(%ebp),%eax
c010b47a:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b47c:	8b 45 10             	mov    0x10(%ebp),%eax
c010b47f:	8d 50 01             	lea    0x1(%eax),%edx
c010b482:	89 55 10             	mov    %edx,0x10(%ebp)
c010b485:	0f b6 00             	movzbl (%eax),%eax
c010b488:	0f b6 d8             	movzbl %al,%ebx
c010b48b:	83 fb 25             	cmp    $0x25,%ebx
c010b48e:	75 d4                	jne    c010b464 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b490:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b494:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b49b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b49e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b4a1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b4a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b4ab:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b4ae:	8b 45 10             	mov    0x10(%ebp),%eax
c010b4b1:	8d 50 01             	lea    0x1(%eax),%edx
c010b4b4:	89 55 10             	mov    %edx,0x10(%ebp)
c010b4b7:	0f b6 00             	movzbl (%eax),%eax
c010b4ba:	0f b6 d8             	movzbl %al,%ebx
c010b4bd:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b4c0:	83 f8 55             	cmp    $0x55,%eax
c010b4c3:	0f 87 44 03 00 00    	ja     c010b80d <vprintfmt+0x3b3>
c010b4c9:	8b 04 85 68 e4 10 c0 	mov    -0x3fef1b98(,%eax,4),%eax
c010b4d0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b4d2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b4d6:	eb d6                	jmp    c010b4ae <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b4d8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b4dc:	eb d0                	jmp    c010b4ae <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b4de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b4e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b4e8:	89 d0                	mov    %edx,%eax
c010b4ea:	c1 e0 02             	shl    $0x2,%eax
c010b4ed:	01 d0                	add    %edx,%eax
c010b4ef:	01 c0                	add    %eax,%eax
c010b4f1:	01 d8                	add    %ebx,%eax
c010b4f3:	83 e8 30             	sub    $0x30,%eax
c010b4f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b4f9:	8b 45 10             	mov    0x10(%ebp),%eax
c010b4fc:	0f b6 00             	movzbl (%eax),%eax
c010b4ff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b502:	83 fb 2f             	cmp    $0x2f,%ebx
c010b505:	7e 0b                	jle    c010b512 <vprintfmt+0xb8>
c010b507:	83 fb 39             	cmp    $0x39,%ebx
c010b50a:	7f 06                	jg     c010b512 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b50c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b510:	eb d3                	jmp    c010b4e5 <vprintfmt+0x8b>
            goto process_precision;
c010b512:	eb 33                	jmp    c010b547 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b514:	8b 45 14             	mov    0x14(%ebp),%eax
c010b517:	8d 50 04             	lea    0x4(%eax),%edx
c010b51a:	89 55 14             	mov    %edx,0x14(%ebp)
c010b51d:	8b 00                	mov    (%eax),%eax
c010b51f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b522:	eb 23                	jmp    c010b547 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b524:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b528:	79 0c                	jns    c010b536 <vprintfmt+0xdc>
                width = 0;
c010b52a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b531:	e9 78 ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>
c010b536:	e9 73 ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b53b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b542:	e9 67 ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b547:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b54b:	79 12                	jns    c010b55f <vprintfmt+0x105>
                width = precision, precision = -1;
c010b54d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b550:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b553:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b55a:	e9 4f ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>
c010b55f:	e9 4a ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b564:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b568:	e9 41 ff ff ff       	jmp    c010b4ae <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b56d:	8b 45 14             	mov    0x14(%ebp),%eax
c010b570:	8d 50 04             	lea    0x4(%eax),%edx
c010b573:	89 55 14             	mov    %edx,0x14(%ebp)
c010b576:	8b 00                	mov    (%eax),%eax
c010b578:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b57b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b57f:	89 04 24             	mov    %eax,(%esp)
c010b582:	8b 45 08             	mov    0x8(%ebp),%eax
c010b585:	ff d0                	call   *%eax
            break;
c010b587:	e9 ac 02 00 00       	jmp    c010b838 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b58c:	8b 45 14             	mov    0x14(%ebp),%eax
c010b58f:	8d 50 04             	lea    0x4(%eax),%edx
c010b592:	89 55 14             	mov    %edx,0x14(%ebp)
c010b595:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b597:	85 db                	test   %ebx,%ebx
c010b599:	79 02                	jns    c010b59d <vprintfmt+0x143>
                err = -err;
c010b59b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b59d:	83 fb 18             	cmp    $0x18,%ebx
c010b5a0:	7f 0b                	jg     c010b5ad <vprintfmt+0x153>
c010b5a2:	8b 34 9d e0 e3 10 c0 	mov    -0x3fef1c20(,%ebx,4),%esi
c010b5a9:	85 f6                	test   %esi,%esi
c010b5ab:	75 23                	jne    c010b5d0 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b5ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b5b1:	c7 44 24 08 55 e4 10 	movl   $0xc010e455,0x8(%esp)
c010b5b8:	c0 
c010b5b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5c0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5c3:	89 04 24             	mov    %eax,(%esp)
c010b5c6:	e8 61 fe ff ff       	call   c010b42c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b5cb:	e9 68 02 00 00       	jmp    c010b838 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b5d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b5d4:	c7 44 24 08 5e e4 10 	movl   $0xc010e45e,0x8(%esp)
c010b5db:	c0 
c010b5dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b5df:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b5e3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5e6:	89 04 24             	mov    %eax,(%esp)
c010b5e9:	e8 3e fe ff ff       	call   c010b42c <printfmt>
            }
            break;
c010b5ee:	e9 45 02 00 00       	jmp    c010b838 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b5f3:	8b 45 14             	mov    0x14(%ebp),%eax
c010b5f6:	8d 50 04             	lea    0x4(%eax),%edx
c010b5f9:	89 55 14             	mov    %edx,0x14(%ebp)
c010b5fc:	8b 30                	mov    (%eax),%esi
c010b5fe:	85 f6                	test   %esi,%esi
c010b600:	75 05                	jne    c010b607 <vprintfmt+0x1ad>
                p = "(null)";
c010b602:	be 61 e4 10 c0       	mov    $0xc010e461,%esi
            }
            if (width > 0 && padc != '-') {
c010b607:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b60b:	7e 3e                	jle    c010b64b <vprintfmt+0x1f1>
c010b60d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b611:	74 38                	je     c010b64b <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b613:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b619:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b61d:	89 34 24             	mov    %esi,(%esp)
c010b620:	e8 ed 03 00 00       	call   c010ba12 <strnlen>
c010b625:	29 c3                	sub    %eax,%ebx
c010b627:	89 d8                	mov    %ebx,%eax
c010b629:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b62c:	eb 17                	jmp    c010b645 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b62e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b632:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b635:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b639:	89 04 24             	mov    %eax,(%esp)
c010b63c:	8b 45 08             	mov    0x8(%ebp),%eax
c010b63f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b641:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b645:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b649:	7f e3                	jg     c010b62e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b64b:	eb 38                	jmp    c010b685 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b64d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b651:	74 1f                	je     c010b672 <vprintfmt+0x218>
c010b653:	83 fb 1f             	cmp    $0x1f,%ebx
c010b656:	7e 05                	jle    c010b65d <vprintfmt+0x203>
c010b658:	83 fb 7e             	cmp    $0x7e,%ebx
c010b65b:	7e 15                	jle    c010b672 <vprintfmt+0x218>
                    putch('?', putdat);
c010b65d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b660:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b664:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b66b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b66e:	ff d0                	call   *%eax
c010b670:	eb 0f                	jmp    c010b681 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b672:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b675:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b679:	89 1c 24             	mov    %ebx,(%esp)
c010b67c:	8b 45 08             	mov    0x8(%ebp),%eax
c010b67f:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b681:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b685:	89 f0                	mov    %esi,%eax
c010b687:	8d 70 01             	lea    0x1(%eax),%esi
c010b68a:	0f b6 00             	movzbl (%eax),%eax
c010b68d:	0f be d8             	movsbl %al,%ebx
c010b690:	85 db                	test   %ebx,%ebx
c010b692:	74 10                	je     c010b6a4 <vprintfmt+0x24a>
c010b694:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b698:	78 b3                	js     c010b64d <vprintfmt+0x1f3>
c010b69a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b69e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b6a2:	79 a9                	jns    c010b64d <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b6a4:	eb 17                	jmp    c010b6bd <vprintfmt+0x263>
                putch(' ', putdat);
c010b6a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6ad:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b6b4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b7:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b6b9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b6bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b6c1:	7f e3                	jg     c010b6a6 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b6c3:	e9 70 01 00 00       	jmp    c010b838 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b6c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b6cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6cf:	8d 45 14             	lea    0x14(%ebp),%eax
c010b6d2:	89 04 24             	mov    %eax,(%esp)
c010b6d5:	e8 0b fd ff ff       	call   c010b3e5 <getint>
c010b6da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b6dd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b6e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b6e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b6e6:	85 d2                	test   %edx,%edx
c010b6e8:	79 26                	jns    c010b710 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b6ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6f1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b6f8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6fb:	ff d0                	call   *%eax
                num = -(long long)num;
c010b6fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b700:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b703:	f7 d8                	neg    %eax
c010b705:	83 d2 00             	adc    $0x0,%edx
c010b708:	f7 da                	neg    %edx
c010b70a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b70d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b710:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b717:	e9 a8 00 00 00       	jmp    c010b7c4 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b71c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b71f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b723:	8d 45 14             	lea    0x14(%ebp),%eax
c010b726:	89 04 24             	mov    %eax,(%esp)
c010b729:	e8 68 fc ff ff       	call   c010b396 <getuint>
c010b72e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b731:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b734:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b73b:	e9 84 00 00 00       	jmp    c010b7c4 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b740:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b743:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b747:	8d 45 14             	lea    0x14(%ebp),%eax
c010b74a:	89 04 24             	mov    %eax,(%esp)
c010b74d:	e8 44 fc ff ff       	call   c010b396 <getuint>
c010b752:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b755:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b758:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b75f:	eb 63                	jmp    c010b7c4 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b761:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b764:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b768:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b76f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b772:	ff d0                	call   *%eax
            putch('x', putdat);
c010b774:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b777:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b77b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b782:	8b 45 08             	mov    0x8(%ebp),%eax
c010b785:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b787:	8b 45 14             	mov    0x14(%ebp),%eax
c010b78a:	8d 50 04             	lea    0x4(%eax),%edx
c010b78d:	89 55 14             	mov    %edx,0x14(%ebp)
c010b790:	8b 00                	mov    (%eax),%eax
c010b792:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b795:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b79c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b7a3:	eb 1f                	jmp    c010b7c4 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b7a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7ac:	8d 45 14             	lea    0x14(%ebp),%eax
c010b7af:	89 04 24             	mov    %eax,(%esp)
c010b7b2:	e8 df fb ff ff       	call   c010b396 <getuint>
c010b7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b7ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b7bd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b7c4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b7cb:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b7cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b7d2:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b7d6:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b7dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b7e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b7e4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b7e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b7eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7ef:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7f2:	89 04 24             	mov    %eax,(%esp)
c010b7f5:	e8 97 fa ff ff       	call   c010b291 <printnum>
            break;
c010b7fa:	eb 3c                	jmp    c010b838 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b7fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b7ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b803:	89 1c 24             	mov    %ebx,(%esp)
c010b806:	8b 45 08             	mov    0x8(%ebp),%eax
c010b809:	ff d0                	call   *%eax
            break;
c010b80b:	eb 2b                	jmp    c010b838 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b80d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b810:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b814:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b81b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b81e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b820:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b824:	eb 04                	jmp    c010b82a <vprintfmt+0x3d0>
c010b826:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b82a:	8b 45 10             	mov    0x10(%ebp),%eax
c010b82d:	83 e8 01             	sub    $0x1,%eax
c010b830:	0f b6 00             	movzbl (%eax),%eax
c010b833:	3c 25                	cmp    $0x25,%al
c010b835:	75 ef                	jne    c010b826 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b837:	90                   	nop
        }
    }
c010b838:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b839:	e9 3e fc ff ff       	jmp    c010b47c <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b83e:	83 c4 40             	add    $0x40,%esp
c010b841:	5b                   	pop    %ebx
c010b842:	5e                   	pop    %esi
c010b843:	5d                   	pop    %ebp
c010b844:	c3                   	ret    

c010b845 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b845:	55                   	push   %ebp
c010b846:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b848:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b84b:	8b 40 08             	mov    0x8(%eax),%eax
c010b84e:	8d 50 01             	lea    0x1(%eax),%edx
c010b851:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b854:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b857:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b85a:	8b 10                	mov    (%eax),%edx
c010b85c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b85f:	8b 40 04             	mov    0x4(%eax),%eax
c010b862:	39 c2                	cmp    %eax,%edx
c010b864:	73 12                	jae    c010b878 <sprintputch+0x33>
        *b->buf ++ = ch;
c010b866:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b869:	8b 00                	mov    (%eax),%eax
c010b86b:	8d 48 01             	lea    0x1(%eax),%ecx
c010b86e:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b871:	89 0a                	mov    %ecx,(%edx)
c010b873:	8b 55 08             	mov    0x8(%ebp),%edx
c010b876:	88 10                	mov    %dl,(%eax)
    }
}
c010b878:	5d                   	pop    %ebp
c010b879:	c3                   	ret    

c010b87a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b87a:	55                   	push   %ebp
c010b87b:	89 e5                	mov    %esp,%ebp
c010b87d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b880:	8d 45 14             	lea    0x14(%ebp),%eax
c010b883:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b886:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b889:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b88d:	8b 45 10             	mov    0x10(%ebp),%eax
c010b890:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b894:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b897:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b89b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b89e:	89 04 24             	mov    %eax,(%esp)
c010b8a1:	e8 08 00 00 00       	call   c010b8ae <vsnprintf>
c010b8a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b8ac:	c9                   	leave  
c010b8ad:	c3                   	ret    

c010b8ae <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b8ae:	55                   	push   %ebp
c010b8af:	89 e5                	mov    %esp,%ebp
c010b8b1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b8b4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b8ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8bd:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b8c0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8c3:	01 d0                	add    %edx,%eax
c010b8c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b8c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b8cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b8d3:	74 0a                	je     c010b8df <vsnprintf+0x31>
c010b8d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b8db:	39 c2                	cmp    %eax,%edx
c010b8dd:	76 07                	jbe    c010b8e6 <vsnprintf+0x38>
        return -E_INVAL;
c010b8df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b8e4:	eb 2a                	jmp    c010b910 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b8e6:	8b 45 14             	mov    0x14(%ebp),%eax
c010b8e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b8ed:	8b 45 10             	mov    0x10(%ebp),%eax
c010b8f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b8f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b8f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8fb:	c7 04 24 45 b8 10 c0 	movl   $0xc010b845,(%esp)
c010b902:	e8 53 fb ff ff       	call   c010b45a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b907:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b90a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b910:	c9                   	leave  
c010b911:	c3                   	ret    

c010b912 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b912:	55                   	push   %ebp
c010b913:	89 e5                	mov    %esp,%ebp
c010b915:	57                   	push   %edi
c010b916:	56                   	push   %esi
c010b917:	53                   	push   %ebx
c010b918:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b91b:	a1 a0 ce 12 c0       	mov    0xc012cea0,%eax
c010b920:	8b 15 a4 ce 12 c0    	mov    0xc012cea4,%edx
c010b926:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b92c:	6b f0 05             	imul   $0x5,%eax,%esi
c010b92f:	01 f7                	add    %esi,%edi
c010b931:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b936:	f7 e6                	mul    %esi
c010b938:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b93b:	89 f2                	mov    %esi,%edx
c010b93d:	83 c0 0b             	add    $0xb,%eax
c010b940:	83 d2 00             	adc    $0x0,%edx
c010b943:	89 c7                	mov    %eax,%edi
c010b945:	83 e7 ff             	and    $0xffffffff,%edi
c010b948:	89 f9                	mov    %edi,%ecx
c010b94a:	0f b7 da             	movzwl %dx,%ebx
c010b94d:	89 0d a0 ce 12 c0    	mov    %ecx,0xc012cea0
c010b953:	89 1d a4 ce 12 c0    	mov    %ebx,0xc012cea4
    unsigned long long result = (next >> 12);
c010b959:	a1 a0 ce 12 c0       	mov    0xc012cea0,%eax
c010b95e:	8b 15 a4 ce 12 c0    	mov    0xc012cea4,%edx
c010b964:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010b968:	c1 ea 0c             	shr    $0xc,%edx
c010b96b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b96e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010b971:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010b978:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b97b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b97e:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b981:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b984:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b987:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b98a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b98e:	74 1c                	je     c010b9ac <rand+0x9a>
c010b990:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b993:	ba 00 00 00 00       	mov    $0x0,%edx
c010b998:	f7 75 dc             	divl   -0x24(%ebp)
c010b99b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b99e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b9a1:	ba 00 00 00 00       	mov    $0x0,%edx
c010b9a6:	f7 75 dc             	divl   -0x24(%ebp)
c010b9a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b9ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b9af:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b9b2:	f7 75 dc             	divl   -0x24(%ebp)
c010b9b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b9b8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b9bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b9be:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b9c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b9c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010b9c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010b9ca:	83 c4 24             	add    $0x24,%esp
c010b9cd:	5b                   	pop    %ebx
c010b9ce:	5e                   	pop    %esi
c010b9cf:	5f                   	pop    %edi
c010b9d0:	5d                   	pop    %ebp
c010b9d1:	c3                   	ret    

c010b9d2 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010b9d2:	55                   	push   %ebp
c010b9d3:	89 e5                	mov    %esp,%ebp
    next = seed;
c010b9d5:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9d8:	ba 00 00 00 00       	mov    $0x0,%edx
c010b9dd:	a3 a0 ce 12 c0       	mov    %eax,0xc012cea0
c010b9e2:	89 15 a4 ce 12 c0    	mov    %edx,0xc012cea4
}
c010b9e8:	5d                   	pop    %ebp
c010b9e9:	c3                   	ret    

c010b9ea <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010b9ea:	55                   	push   %ebp
c010b9eb:	89 e5                	mov    %esp,%ebp
c010b9ed:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b9f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010b9f7:	eb 04                	jmp    c010b9fd <strlen+0x13>
        cnt ++;
c010b9f9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010b9fd:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba00:	8d 50 01             	lea    0x1(%eax),%edx
c010ba03:	89 55 08             	mov    %edx,0x8(%ebp)
c010ba06:	0f b6 00             	movzbl (%eax),%eax
c010ba09:	84 c0                	test   %al,%al
c010ba0b:	75 ec                	jne    c010b9f9 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010ba0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010ba10:	c9                   	leave  
c010ba11:	c3                   	ret    

c010ba12 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010ba12:	55                   	push   %ebp
c010ba13:	89 e5                	mov    %esp,%ebp
c010ba15:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010ba18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010ba1f:	eb 04                	jmp    c010ba25 <strnlen+0x13>
        cnt ++;
c010ba21:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010ba25:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ba28:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010ba2b:	73 10                	jae    c010ba3d <strnlen+0x2b>
c010ba2d:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba30:	8d 50 01             	lea    0x1(%eax),%edx
c010ba33:	89 55 08             	mov    %edx,0x8(%ebp)
c010ba36:	0f b6 00             	movzbl (%eax),%eax
c010ba39:	84 c0                	test   %al,%al
c010ba3b:	75 e4                	jne    c010ba21 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010ba3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010ba40:	c9                   	leave  
c010ba41:	c3                   	ret    

c010ba42 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010ba42:	55                   	push   %ebp
c010ba43:	89 e5                	mov    %esp,%ebp
c010ba45:	57                   	push   %edi
c010ba46:	56                   	push   %esi
c010ba47:	83 ec 20             	sub    $0x20,%esp
c010ba4a:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ba50:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba53:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010ba56:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010ba59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ba5c:	89 d1                	mov    %edx,%ecx
c010ba5e:	89 c2                	mov    %eax,%edx
c010ba60:	89 ce                	mov    %ecx,%esi
c010ba62:	89 d7                	mov    %edx,%edi
c010ba64:	ac                   	lods   %ds:(%esi),%al
c010ba65:	aa                   	stos   %al,%es:(%edi)
c010ba66:	84 c0                	test   %al,%al
c010ba68:	75 fa                	jne    c010ba64 <strcpy+0x22>
c010ba6a:	89 fa                	mov    %edi,%edx
c010ba6c:	89 f1                	mov    %esi,%ecx
c010ba6e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010ba71:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010ba74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010ba77:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010ba7a:	83 c4 20             	add    $0x20,%esp
c010ba7d:	5e                   	pop    %esi
c010ba7e:	5f                   	pop    %edi
c010ba7f:	5d                   	pop    %ebp
c010ba80:	c3                   	ret    

c010ba81 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010ba81:	55                   	push   %ebp
c010ba82:	89 e5                	mov    %esp,%ebp
c010ba84:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010ba87:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010ba8d:	eb 21                	jmp    c010bab0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010ba8f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba92:	0f b6 10             	movzbl (%eax),%edx
c010ba95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ba98:	88 10                	mov    %dl,(%eax)
c010ba9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ba9d:	0f b6 00             	movzbl (%eax),%eax
c010baa0:	84 c0                	test   %al,%al
c010baa2:	74 04                	je     c010baa8 <strncpy+0x27>
            src ++;
c010baa4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010baa8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010baac:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010bab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bab4:	75 d9                	jne    c010ba8f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010bab6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bab9:	c9                   	leave  
c010baba:	c3                   	ret    

c010babb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010babb:	55                   	push   %ebp
c010babc:	89 e5                	mov    %esp,%ebp
c010babe:	57                   	push   %edi
c010babf:	56                   	push   %esi
c010bac0:	83 ec 20             	sub    $0x20,%esp
c010bac3:	8b 45 08             	mov    0x8(%ebp),%eax
c010bac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bac9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bacc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010bacf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010bad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bad5:	89 d1                	mov    %edx,%ecx
c010bad7:	89 c2                	mov    %eax,%edx
c010bad9:	89 ce                	mov    %ecx,%esi
c010badb:	89 d7                	mov    %edx,%edi
c010badd:	ac                   	lods   %ds:(%esi),%al
c010bade:	ae                   	scas   %es:(%edi),%al
c010badf:	75 08                	jne    c010bae9 <strcmp+0x2e>
c010bae1:	84 c0                	test   %al,%al
c010bae3:	75 f8                	jne    c010badd <strcmp+0x22>
c010bae5:	31 c0                	xor    %eax,%eax
c010bae7:	eb 04                	jmp    c010baed <strcmp+0x32>
c010bae9:	19 c0                	sbb    %eax,%eax
c010baeb:	0c 01                	or     $0x1,%al
c010baed:	89 fa                	mov    %edi,%edx
c010baef:	89 f1                	mov    %esi,%ecx
c010baf1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010baf4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010baf7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010bafa:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010bafd:	83 c4 20             	add    $0x20,%esp
c010bb00:	5e                   	pop    %esi
c010bb01:	5f                   	pop    %edi
c010bb02:	5d                   	pop    %ebp
c010bb03:	c3                   	ret    

c010bb04 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010bb04:	55                   	push   %ebp
c010bb05:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bb07:	eb 0c                	jmp    c010bb15 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010bb09:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010bb0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bb11:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bb15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bb19:	74 1a                	je     c010bb35 <strncmp+0x31>
c010bb1b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb1e:	0f b6 00             	movzbl (%eax),%eax
c010bb21:	84 c0                	test   %al,%al
c010bb23:	74 10                	je     c010bb35 <strncmp+0x31>
c010bb25:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb28:	0f b6 10             	movzbl (%eax),%edx
c010bb2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb2e:	0f b6 00             	movzbl (%eax),%eax
c010bb31:	38 c2                	cmp    %al,%dl
c010bb33:	74 d4                	je     c010bb09 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bb35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bb39:	74 18                	je     c010bb53 <strncmp+0x4f>
c010bb3b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb3e:	0f b6 00             	movzbl (%eax),%eax
c010bb41:	0f b6 d0             	movzbl %al,%edx
c010bb44:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb47:	0f b6 00             	movzbl (%eax),%eax
c010bb4a:	0f b6 c0             	movzbl %al,%eax
c010bb4d:	29 c2                	sub    %eax,%edx
c010bb4f:	89 d0                	mov    %edx,%eax
c010bb51:	eb 05                	jmp    c010bb58 <strncmp+0x54>
c010bb53:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bb58:	5d                   	pop    %ebp
c010bb59:	c3                   	ret    

c010bb5a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010bb5a:	55                   	push   %ebp
c010bb5b:	89 e5                	mov    %esp,%ebp
c010bb5d:	83 ec 04             	sub    $0x4,%esp
c010bb60:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb63:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bb66:	eb 14                	jmp    c010bb7c <strchr+0x22>
        if (*s == c) {
c010bb68:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb6b:	0f b6 00             	movzbl (%eax),%eax
c010bb6e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bb71:	75 05                	jne    c010bb78 <strchr+0x1e>
            return (char *)s;
c010bb73:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb76:	eb 13                	jmp    c010bb8b <strchr+0x31>
        }
        s ++;
c010bb78:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010bb7c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb7f:	0f b6 00             	movzbl (%eax),%eax
c010bb82:	84 c0                	test   %al,%al
c010bb84:	75 e2                	jne    c010bb68 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010bb86:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bb8b:	c9                   	leave  
c010bb8c:	c3                   	ret    

c010bb8d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010bb8d:	55                   	push   %ebp
c010bb8e:	89 e5                	mov    %esp,%ebp
c010bb90:	83 ec 04             	sub    $0x4,%esp
c010bb93:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bb96:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bb99:	eb 11                	jmp    c010bbac <strfind+0x1f>
        if (*s == c) {
c010bb9b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb9e:	0f b6 00             	movzbl (%eax),%eax
c010bba1:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bba4:	75 02                	jne    c010bba8 <strfind+0x1b>
            break;
c010bba6:	eb 0e                	jmp    c010bbb6 <strfind+0x29>
        }
        s ++;
c010bba8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010bbac:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbaf:	0f b6 00             	movzbl (%eax),%eax
c010bbb2:	84 c0                	test   %al,%al
c010bbb4:	75 e5                	jne    c010bb9b <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010bbb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bbb9:	c9                   	leave  
c010bbba:	c3                   	ret    

c010bbbb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010bbbb:	55                   	push   %ebp
c010bbbc:	89 e5                	mov    %esp,%ebp
c010bbbe:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010bbc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010bbc8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bbcf:	eb 04                	jmp    c010bbd5 <strtol+0x1a>
        s ++;
c010bbd1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bbd5:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbd8:	0f b6 00             	movzbl (%eax),%eax
c010bbdb:	3c 20                	cmp    $0x20,%al
c010bbdd:	74 f2                	je     c010bbd1 <strtol+0x16>
c010bbdf:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbe2:	0f b6 00             	movzbl (%eax),%eax
c010bbe5:	3c 09                	cmp    $0x9,%al
c010bbe7:	74 e8                	je     c010bbd1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010bbe9:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbec:	0f b6 00             	movzbl (%eax),%eax
c010bbef:	3c 2b                	cmp    $0x2b,%al
c010bbf1:	75 06                	jne    c010bbf9 <strtol+0x3e>
        s ++;
c010bbf3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bbf7:	eb 15                	jmp    c010bc0e <strtol+0x53>
    }
    else if (*s == '-') {
c010bbf9:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbfc:	0f b6 00             	movzbl (%eax),%eax
c010bbff:	3c 2d                	cmp    $0x2d,%al
c010bc01:	75 0b                	jne    c010bc0e <strtol+0x53>
        s ++, neg = 1;
c010bc03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bc07:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010bc0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bc12:	74 06                	je     c010bc1a <strtol+0x5f>
c010bc14:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010bc18:	75 24                	jne    c010bc3e <strtol+0x83>
c010bc1a:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc1d:	0f b6 00             	movzbl (%eax),%eax
c010bc20:	3c 30                	cmp    $0x30,%al
c010bc22:	75 1a                	jne    c010bc3e <strtol+0x83>
c010bc24:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc27:	83 c0 01             	add    $0x1,%eax
c010bc2a:	0f b6 00             	movzbl (%eax),%eax
c010bc2d:	3c 78                	cmp    $0x78,%al
c010bc2f:	75 0d                	jne    c010bc3e <strtol+0x83>
        s += 2, base = 16;
c010bc31:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010bc35:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010bc3c:	eb 2a                	jmp    c010bc68 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010bc3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bc42:	75 17                	jne    c010bc5b <strtol+0xa0>
c010bc44:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc47:	0f b6 00             	movzbl (%eax),%eax
c010bc4a:	3c 30                	cmp    $0x30,%al
c010bc4c:	75 0d                	jne    c010bc5b <strtol+0xa0>
        s ++, base = 8;
c010bc4e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bc52:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010bc59:	eb 0d                	jmp    c010bc68 <strtol+0xad>
    }
    else if (base == 0) {
c010bc5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bc5f:	75 07                	jne    c010bc68 <strtol+0xad>
        base = 10;
c010bc61:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010bc68:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc6b:	0f b6 00             	movzbl (%eax),%eax
c010bc6e:	3c 2f                	cmp    $0x2f,%al
c010bc70:	7e 1b                	jle    c010bc8d <strtol+0xd2>
c010bc72:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc75:	0f b6 00             	movzbl (%eax),%eax
c010bc78:	3c 39                	cmp    $0x39,%al
c010bc7a:	7f 11                	jg     c010bc8d <strtol+0xd2>
            dig = *s - '0';
c010bc7c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc7f:	0f b6 00             	movzbl (%eax),%eax
c010bc82:	0f be c0             	movsbl %al,%eax
c010bc85:	83 e8 30             	sub    $0x30,%eax
c010bc88:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bc8b:	eb 48                	jmp    c010bcd5 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010bc8d:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc90:	0f b6 00             	movzbl (%eax),%eax
c010bc93:	3c 60                	cmp    $0x60,%al
c010bc95:	7e 1b                	jle    c010bcb2 <strtol+0xf7>
c010bc97:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc9a:	0f b6 00             	movzbl (%eax),%eax
c010bc9d:	3c 7a                	cmp    $0x7a,%al
c010bc9f:	7f 11                	jg     c010bcb2 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010bca1:	8b 45 08             	mov    0x8(%ebp),%eax
c010bca4:	0f b6 00             	movzbl (%eax),%eax
c010bca7:	0f be c0             	movsbl %al,%eax
c010bcaa:	83 e8 57             	sub    $0x57,%eax
c010bcad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bcb0:	eb 23                	jmp    c010bcd5 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010bcb2:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcb5:	0f b6 00             	movzbl (%eax),%eax
c010bcb8:	3c 40                	cmp    $0x40,%al
c010bcba:	7e 3d                	jle    c010bcf9 <strtol+0x13e>
c010bcbc:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcbf:	0f b6 00             	movzbl (%eax),%eax
c010bcc2:	3c 5a                	cmp    $0x5a,%al
c010bcc4:	7f 33                	jg     c010bcf9 <strtol+0x13e>
            dig = *s - 'A' + 10;
c010bcc6:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcc9:	0f b6 00             	movzbl (%eax),%eax
c010bccc:	0f be c0             	movsbl %al,%eax
c010bccf:	83 e8 37             	sub    $0x37,%eax
c010bcd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010bcd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bcd8:	3b 45 10             	cmp    0x10(%ebp),%eax
c010bcdb:	7c 02                	jl     c010bcdf <strtol+0x124>
            break;
c010bcdd:	eb 1a                	jmp    c010bcf9 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010bcdf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bce3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bce6:	0f af 45 10          	imul   0x10(%ebp),%eax
c010bcea:	89 c2                	mov    %eax,%edx
c010bcec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010bcef:	01 d0                	add    %edx,%eax
c010bcf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010bcf4:	e9 6f ff ff ff       	jmp    c010bc68 <strtol+0xad>

    if (endptr) {
c010bcf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010bcfd:	74 08                	je     c010bd07 <strtol+0x14c>
        *endptr = (char *) s;
c010bcff:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bd02:	8b 55 08             	mov    0x8(%ebp),%edx
c010bd05:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010bd07:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010bd0b:	74 07                	je     c010bd14 <strtol+0x159>
c010bd0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010bd10:	f7 d8                	neg    %eax
c010bd12:	eb 03                	jmp    c010bd17 <strtol+0x15c>
c010bd14:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010bd17:	c9                   	leave  
c010bd18:	c3                   	ret    

c010bd19 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010bd19:	55                   	push   %ebp
c010bd1a:	89 e5                	mov    %esp,%ebp
c010bd1c:	57                   	push   %edi
c010bd1d:	83 ec 24             	sub    $0x24,%esp
c010bd20:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bd23:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010bd26:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010bd2a:	8b 55 08             	mov    0x8(%ebp),%edx
c010bd2d:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010bd30:	88 45 f7             	mov    %al,-0x9(%ebp)
c010bd33:	8b 45 10             	mov    0x10(%ebp),%eax
c010bd36:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bd39:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010bd3c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010bd40:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010bd43:	89 d7                	mov    %edx,%edi
c010bd45:	f3 aa                	rep stos %al,%es:(%edi)
c010bd47:	89 fa                	mov    %edi,%edx
c010bd49:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010bd4c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010bd4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010bd52:	83 c4 24             	add    $0x24,%esp
c010bd55:	5f                   	pop    %edi
c010bd56:	5d                   	pop    %ebp
c010bd57:	c3                   	ret    

c010bd58 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010bd58:	55                   	push   %ebp
c010bd59:	89 e5                	mov    %esp,%ebp
c010bd5b:	57                   	push   %edi
c010bd5c:	56                   	push   %esi
c010bd5d:	53                   	push   %ebx
c010bd5e:	83 ec 30             	sub    $0x30,%esp
c010bd61:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bd67:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bd6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bd6d:	8b 45 10             	mov    0x10(%ebp),%eax
c010bd70:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010bd73:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bd76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010bd79:	73 42                	jae    c010bdbd <memmove+0x65>
c010bd7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bd7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010bd81:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bd84:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010bd87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bd8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bd8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010bd90:	c1 e8 02             	shr    $0x2,%eax
c010bd93:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bd95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bd98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010bd9b:	89 d7                	mov    %edx,%edi
c010bd9d:	89 c6                	mov    %eax,%esi
c010bd9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bda1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010bda4:	83 e1 03             	and    $0x3,%ecx
c010bda7:	74 02                	je     c010bdab <memmove+0x53>
c010bda9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bdab:	89 f0                	mov    %esi,%eax
c010bdad:	89 fa                	mov    %edi,%edx
c010bdaf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010bdb2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010bdb5:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bdb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010bdbb:	eb 36                	jmp    c010bdf3 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010bdbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bdc0:	8d 50 ff             	lea    -0x1(%eax),%edx
c010bdc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bdc6:	01 c2                	add    %eax,%edx
c010bdc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bdcb:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010bdce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bdd1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010bdd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bdd7:	89 c1                	mov    %eax,%ecx
c010bdd9:	89 d8                	mov    %ebx,%eax
c010bddb:	89 d6                	mov    %edx,%esi
c010bddd:	89 c7                	mov    %eax,%edi
c010bddf:	fd                   	std    
c010bde0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bde2:	fc                   	cld    
c010bde3:	89 f8                	mov    %edi,%eax
c010bde5:	89 f2                	mov    %esi,%edx
c010bde7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010bdea:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010bded:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bdf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bdf3:	83 c4 30             	add    $0x30,%esp
c010bdf6:	5b                   	pop    %ebx
c010bdf7:	5e                   	pop    %esi
c010bdf8:	5f                   	pop    %edi
c010bdf9:	5d                   	pop    %ebp
c010bdfa:	c3                   	ret    

c010bdfb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010bdfb:	55                   	push   %ebp
c010bdfc:	89 e5                	mov    %esp,%ebp
c010bdfe:	57                   	push   %edi
c010bdff:	56                   	push   %esi
c010be00:	83 ec 20             	sub    $0x20,%esp
c010be03:	8b 45 08             	mov    0x8(%ebp),%eax
c010be06:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010be09:	8b 45 0c             	mov    0xc(%ebp),%eax
c010be0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010be0f:	8b 45 10             	mov    0x10(%ebp),%eax
c010be12:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010be15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010be18:	c1 e8 02             	shr    $0x2,%eax
c010be1b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010be1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010be20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010be23:	89 d7                	mov    %edx,%edi
c010be25:	89 c6                	mov    %eax,%esi
c010be27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010be29:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010be2c:	83 e1 03             	and    $0x3,%ecx
c010be2f:	74 02                	je     c010be33 <memcpy+0x38>
c010be31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010be33:	89 f0                	mov    %esi,%eax
c010be35:	89 fa                	mov    %edi,%edx
c010be37:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010be3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010be3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010be40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010be43:	83 c4 20             	add    $0x20,%esp
c010be46:	5e                   	pop    %esi
c010be47:	5f                   	pop    %edi
c010be48:	5d                   	pop    %ebp
c010be49:	c3                   	ret    

c010be4a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010be4a:	55                   	push   %ebp
c010be4b:	89 e5                	mov    %esp,%ebp
c010be4d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010be50:	8b 45 08             	mov    0x8(%ebp),%eax
c010be53:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010be56:	8b 45 0c             	mov    0xc(%ebp),%eax
c010be59:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010be5c:	eb 30                	jmp    c010be8e <memcmp+0x44>
        if (*s1 != *s2) {
c010be5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010be61:	0f b6 10             	movzbl (%eax),%edx
c010be64:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010be67:	0f b6 00             	movzbl (%eax),%eax
c010be6a:	38 c2                	cmp    %al,%dl
c010be6c:	74 18                	je     c010be86 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010be6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010be71:	0f b6 00             	movzbl (%eax),%eax
c010be74:	0f b6 d0             	movzbl %al,%edx
c010be77:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010be7a:	0f b6 00             	movzbl (%eax),%eax
c010be7d:	0f b6 c0             	movzbl %al,%eax
c010be80:	29 c2                	sub    %eax,%edx
c010be82:	89 d0                	mov    %edx,%eax
c010be84:	eb 1a                	jmp    c010bea0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010be86:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010be8a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010be8e:	8b 45 10             	mov    0x10(%ebp),%eax
c010be91:	8d 50 ff             	lea    -0x1(%eax),%edx
c010be94:	89 55 10             	mov    %edx,0x10(%ebp)
c010be97:	85 c0                	test   %eax,%eax
c010be99:	75 c3                	jne    c010be5e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010be9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bea0:	c9                   	leave  
c010bea1:	c3                   	ret    
