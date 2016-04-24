
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 90 12 00 	lgdtl  0x129018
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
c010001e:	bc 00 90 12 c0       	mov    $0xc0129000,%esp
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
c0100030:	ba b8 e0 19 c0       	mov    $0xc019e0b8,%edx
c0100035:	b8 2a af 19 c0       	mov    $0xc019af2a,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 2a af 19 c0 	movl   $0xc019af2a,(%esp)
c0100051:	e8 b6 b8 00 00       	call   c010b90c <memset>

    cons_init();                // init the console
c0100056:	e8 80 16 00 00       	call   c01016db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 ba 10 c0 	movl   $0xc010baa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc ba 10 c0 	movl   $0xc010babc,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 05 09 00 00       	call   c010097f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 2f 54 00 00       	call   c01054b3 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 20 00 00       	call   c01020b9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 8e 21 00 00       	call   c010221c <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 ff 82 00 00       	call   c0108392 <vmm_init>
    proc_init();                // init process table
c0100093:	e8 37 a8 00 00       	call   c010a8cf <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 6f 17 00 00       	call   c010180c <ide_init>
    swap_init();                // init swap
c010009d:	e8 dc 6a 00 00       	call   c0106b7e <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 ea 0d 00 00       	call   c0100e91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 7b 1f 00 00       	call   c0102027 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 dd a9 00 00       	call   c010aa8e <cpu_idle>

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
c01000ce:	e8 f0 0c 00 00       	call   c0100dc3 <mon_backtrace>
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
c010015f:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 c1 ba 10 c0 	movl   $0xc010bac1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 cf ba 10 c0 	movl   $0xc010bacf,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 dd ba 10 c0 	movl   $0xc010badd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 eb ba 10 c0 	movl   $0xc010baeb,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 f9 ba 10 c0 	movl   $0xc010baf9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 40 af 19 c0       	mov    0xc019af40,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 40 af 19 c0       	mov    %eax,0xc019af40
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
c010021c:	c7 04 24 08 bb 10 c0 	movl   $0xc010bb08,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 28 bb 10 c0 	movl   $0xc010bb28,(%esp)
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
c010025d:	c7 04 24 47 bb 10 c0 	movl   $0xc010bb47,(%esp)
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
c01002ab:	88 90 60 af 19 c0    	mov    %dl,-0x3fe650a0(%eax)
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
c01002ea:	05 60 af 19 c0       	add    $0xc019af60,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 60 af 19 c0       	mov    $0xc019af60,%eax
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
c010030c:	e8 f6 13 00 00       	call   c0101707 <cons_putc>
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
c0100349:	e8 ff ac 00 00       	call   c010b04d <vprintfmt>
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
c0100385:	e8 7d 13 00 00       	call   c0101707 <cons_putc>
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
c01003e1:	e8 5d 13 00 00       	call   c0101743 <cons_getc>
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
c0100553:	c7 00 4c bb 10 c0    	movl   $0xc010bb4c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 4c bb 10 c0 	movl   $0xc010bb4c,0x8(%eax)
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

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058a:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100591:	76 21                	jbe    c01005b4 <debuginfo_eip+0x6a>
        stabs = __STAB_BEGIN__;
c0100593:	c7 45 f4 80 e1 10 c0 	movl   $0xc010e180,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059a:	c7 45 f0 d4 22 12 c0 	movl   $0xc01222d4,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a1:	c7 45 ec d5 22 12 c0 	movl   $0xc01222d5,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005a8:	c7 45 e8 fb 6f 12 c0 	movl   $0xc0126ffb,-0x18(%ebp)
c01005af:	e9 ea 00 00 00       	jmp    c010069e <debuginfo_eip+0x154>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b4:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005bb:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01005c0:	85 c0                	test   %eax,%eax
c01005c2:	74 11                	je     c01005d5 <debuginfo_eip+0x8b>
c01005c4:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01005c9:	8b 40 18             	mov    0x18(%eax),%eax
c01005cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d3:	75 0a                	jne    c01005df <debuginfo_eip+0x95>
            return -1;
c01005d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005da:	e9 9e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005e9:	00 
c01005ea:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f1:	00 
c01005f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f9:	89 04 24             	mov    %eax,(%esp)
c01005fc:	e8 8d 86 00 00       	call   c0108c8e <user_mem_check>
c0100601:	85 c0                	test   %eax,%eax
c0100603:	75 0a                	jne    c010060f <debuginfo_eip+0xc5>
            return -1;
c0100605:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060a:	e9 6e 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }

        stabs = usd->stabs;
c010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100612:	8b 00                	mov    (%eax),%eax
c0100614:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c0100617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061a:	8b 40 04             	mov    0x4(%eax),%eax
c010061d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100623:	8b 40 08             	mov    0x8(%eax),%eax
c0100626:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c0100629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010062c:	8b 40 0c             	mov    0xc(%eax),%eax
c010062f:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100632:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100638:	29 c2                	sub    %eax,%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100644:	00 
c0100645:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100650:	89 04 24             	mov    %eax,(%esp)
c0100653:	e8 36 86 00 00       	call   c0108c8e <user_mem_check>
c0100658:	85 c0                	test   %eax,%eax
c010065a:	75 0a                	jne    c0100666 <debuginfo_eip+0x11c>
            return -1;
c010065c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100661:	e9 17 03 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c0100666:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0100669:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066c:	29 c2                	sub    %eax,%edx
c010066e:	89 d0                	mov    %edx,%eax
c0100670:	89 c2                	mov    %eax,%edx
c0100672:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100675:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010067c:	00 
c010067d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100681:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100688:	89 04 24             	mov    %eax,(%esp)
c010068b:	e8 fe 85 00 00       	call   c0108c8e <user_mem_check>
c0100690:	85 c0                	test   %eax,%eax
c0100692:	75 0a                	jne    c010069e <debuginfo_eip+0x154>
            return -1;
c0100694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100699:	e9 df 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010069e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006a4:	76 0d                	jbe    c01006b3 <debuginfo_eip+0x169>
c01006a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a9:	83 e8 01             	sub    $0x1,%eax
c01006ac:	0f b6 00             	movzbl (%eax),%eax
c01006af:	84 c0                	test   %al,%al
c01006b1:	74 0a                	je     c01006bd <debuginfo_eip+0x173>
        return -1;
c01006b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006b8:	e9 c0 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ca:	29 c2                	sub    %eax,%edx
c01006cc:	89 d0                	mov    %edx,%eax
c01006ce:	c1 f8 02             	sar    $0x2,%eax
c01006d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006d7:	83 e8 01             	sub    $0x1,%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ef fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c0100705:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100708:	85 c0                	test   %eax,%eax
c010070a:	75 0a                	jne    c0100716 <debuginfo_eip+0x1cc>
        return -1;
c010070c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100711:	e9 67 02 00 00       	jmp    c010097d <debuginfo_eip+0x433>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100716:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100719:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010071c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010071f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100722:	8b 45 08             	mov    0x8(%ebp),%eax
c0100725:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100729:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100730:	00 
c0100731:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100734:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100738:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010073b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100742:	89 04 24             	mov    %eax,(%esp)
c0100745:	e8 aa fc ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c010074a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010074d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100750:	39 c2                	cmp    %eax,%edx
c0100752:	7f 7c                	jg     c01007d0 <debuginfo_eip+0x286>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	89 c2                	mov    %eax,%edx
c0100759:	89 d0                	mov    %edx,%eax
c010075b:	01 c0                	add    %eax,%eax
c010075d:	01 d0                	add    %edx,%eax
c010075f:	c1 e0 02             	shl    $0x2,%eax
c0100762:	89 c2                	mov    %eax,%edx
c0100764:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100767:	01 d0                	add    %edx,%eax
c0100769:	8b 10                	mov    (%eax),%edx
c010076b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010076e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100771:	29 c1                	sub    %eax,%ecx
c0100773:	89 c8                	mov    %ecx,%eax
c0100775:	39 c2                	cmp    %eax,%edx
c0100777:	73 22                	jae    c010079b <debuginfo_eip+0x251>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100779:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077c:	89 c2                	mov    %eax,%edx
c010077e:	89 d0                	mov    %edx,%eax
c0100780:	01 c0                	add    %eax,%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	c1 e0 02             	shl    $0x2,%eax
c0100787:	89 c2                	mov    %eax,%edx
c0100789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078c:	01 d0                	add    %edx,%eax
c010078e:	8b 10                	mov    (%eax),%edx
c0100790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100793:	01 c2                	add    %eax,%edx
c0100795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100798:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	8b 50 08             	mov    0x8(%eax),%edx
c01007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bc:	8b 40 10             	mov    0x10(%eax),%eax
c01007bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007cb:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007ce:	eb 15                	jmp    c01007e5 <debuginfo_eip+0x29b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007dc:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e2:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e8:	8b 40 08             	mov    0x8(%eax),%eax
c01007eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f2:	00 
c01007f3:	89 04 24             	mov    %eax,(%esp)
c01007f6:	e8 85 af 00 00       	call   c010b780 <strfind>
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100800:	8b 40 08             	mov    0x8(%eax),%eax
c0100803:	29 c2                	sub    %eax,%edx
c0100805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100808:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080b:	8b 45 08             	mov    0x8(%ebp),%eax
c010080e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100812:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100819:	00 
c010081a:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100821:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100824:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100828:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082b:	89 04 24             	mov    %eax,(%esp)
c010082e:	e8 c1 fb ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c0100833:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100836:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100839:	39 c2                	cmp    %eax,%edx
c010083b:	7f 24                	jg     c0100861 <debuginfo_eip+0x317>
        info->eip_line = stabs[rline].n_desc;
c010083d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100840:	89 c2                	mov    %eax,%edx
c0100842:	89 d0                	mov    %edx,%eax
c0100844:	01 c0                	add    %eax,%eax
c0100846:	01 d0                	add    %edx,%eax
c0100848:	c1 e0 02             	shl    $0x2,%eax
c010084b:	89 c2                	mov    %eax,%edx
c010084d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100850:	01 d0                	add    %edx,%eax
c0100852:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100856:	0f b7 d0             	movzwl %ax,%edx
c0100859:	8b 45 0c             	mov    0xc(%ebp),%eax
c010085c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085f:	eb 13                	jmp    c0100874 <debuginfo_eip+0x32a>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100866:	e9 12 01 00 00       	jmp    c010097d <debuginfo_eip+0x433>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010086b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010086e:	83 e8 01             	sub    $0x1,%eax
c0100871:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100874:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100877:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010087a:	39 c2                	cmp    %eax,%edx
c010087c:	7c 56                	jl     c01008d4 <debuginfo_eip+0x38a>
           && stabs[lline].n_type != N_SOL
c010087e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100881:	89 c2                	mov    %eax,%edx
c0100883:	89 d0                	mov    %edx,%eax
c0100885:	01 c0                	add    %eax,%eax
c0100887:	01 d0                	add    %edx,%eax
c0100889:	c1 e0 02             	shl    $0x2,%eax
c010088c:	89 c2                	mov    %eax,%edx
c010088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100891:	01 d0                	add    %edx,%eax
c0100893:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100897:	3c 84                	cmp    $0x84,%al
c0100899:	74 39                	je     c01008d4 <debuginfo_eip+0x38a>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010089b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008b4:	3c 64                	cmp    $0x64,%al
c01008b6:	75 b3                	jne    c010086b <debuginfo_eip+0x321>
c01008b8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008bb:	89 c2                	mov    %eax,%edx
c01008bd:	89 d0                	mov    %edx,%eax
c01008bf:	01 c0                	add    %eax,%eax
c01008c1:	01 d0                	add    %edx,%eax
c01008c3:	c1 e0 02             	shl    $0x2,%eax
c01008c6:	89 c2                	mov    %eax,%edx
c01008c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008cb:	01 d0                	add    %edx,%eax
c01008cd:	8b 40 08             	mov    0x8(%eax),%eax
c01008d0:	85 c0                	test   %eax,%eax
c01008d2:	74 97                	je     c010086b <debuginfo_eip+0x321>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008d4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008da:	39 c2                	cmp    %eax,%edx
c01008dc:	7c 46                	jl     c0100924 <debuginfo_eip+0x3da>
c01008de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008e1:	89 c2                	mov    %eax,%edx
c01008e3:	89 d0                	mov    %edx,%eax
c01008e5:	01 c0                	add    %eax,%eax
c01008e7:	01 d0                	add    %edx,%eax
c01008e9:	c1 e0 02             	shl    $0x2,%eax
c01008ec:	89 c2                	mov    %eax,%edx
c01008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008f1:	01 d0                	add    %edx,%eax
c01008f3:	8b 10                	mov    (%eax),%edx
c01008f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008fb:	29 c1                	sub    %eax,%ecx
c01008fd:	89 c8                	mov    %ecx,%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	73 21                	jae    c0100924 <debuginfo_eip+0x3da>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100903:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100906:	89 c2                	mov    %eax,%edx
c0100908:	89 d0                	mov    %edx,%eax
c010090a:	01 c0                	add    %eax,%eax
c010090c:	01 d0                	add    %edx,%eax
c010090e:	c1 e0 02             	shl    $0x2,%eax
c0100911:	89 c2                	mov    %eax,%edx
c0100913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100916:	01 d0                	add    %edx,%eax
c0100918:	8b 10                	mov    (%eax),%edx
c010091a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010091d:	01 c2                	add    %eax,%edx
c010091f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100922:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100924:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100927:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010092a:	39 c2                	cmp    %eax,%edx
c010092c:	7d 4a                	jge    c0100978 <debuginfo_eip+0x42e>
        for (lline = lfun + 1;
c010092e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100931:	83 c0 01             	add    $0x1,%eax
c0100934:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100937:	eb 18                	jmp    c0100951 <debuginfo_eip+0x407>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010093c:	8b 40 14             	mov    0x14(%eax),%eax
c010093f:	8d 50 01             	lea    0x1(%eax),%edx
c0100942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100945:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100948:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010094b:	83 c0 01             	add    $0x1,%eax
c010094e:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100951:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100954:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100957:	39 c2                	cmp    %eax,%edx
c0100959:	7d 1d                	jge    c0100978 <debuginfo_eip+0x42e>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010095b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010095e:	89 c2                	mov    %eax,%edx
c0100960:	89 d0                	mov    %edx,%eax
c0100962:	01 c0                	add    %eax,%eax
c0100964:	01 d0                	add    %edx,%eax
c0100966:	c1 e0 02             	shl    $0x2,%eax
c0100969:	89 c2                	mov    %eax,%edx
c010096b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010096e:	01 d0                	add    %edx,%eax
c0100970:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100974:	3c a0                	cmp    $0xa0,%al
c0100976:	74 c1                	je     c0100939 <debuginfo_eip+0x3ef>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100978:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010097d:	c9                   	leave  
c010097e:	c3                   	ret    

c010097f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010097f:	55                   	push   %ebp
c0100980:	89 e5                	mov    %esp,%ebp
c0100982:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100985:	c7 04 24 56 bb 10 c0 	movl   $0xc010bb56,(%esp)
c010098c:	e8 c2 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100991:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100998:	c0 
c0100999:	c7 04 24 6f bb 10 c0 	movl   $0xc010bb6f,(%esp)
c01009a0:	e8 ae f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01009a5:	c7 44 24 04 95 ba 10 	movl   $0xc010ba95,0x4(%esp)
c01009ac:	c0 
c01009ad:	c7 04 24 87 bb 10 c0 	movl   $0xc010bb87,(%esp)
c01009b4:	e8 9a f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009b9:	c7 44 24 04 2a af 19 	movl   $0xc019af2a,0x4(%esp)
c01009c0:	c0 
c01009c1:	c7 04 24 9f bb 10 c0 	movl   $0xc010bb9f,(%esp)
c01009c8:	e8 86 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009cd:	c7 44 24 04 b8 e0 19 	movl   $0xc019e0b8,0x4(%esp)
c01009d4:	c0 
c01009d5:	c7 04 24 b7 bb 10 c0 	movl   $0xc010bbb7,(%esp)
c01009dc:	e8 72 f9 ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009e1:	b8 b8 e0 19 c0       	mov    $0xc019e0b8,%eax
c01009e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01009f1:	29 c2                	sub    %eax,%edx
c01009f3:	89 d0                	mov    %edx,%eax
c01009f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009fb:	85 c0                	test   %eax,%eax
c01009fd:	0f 48 c2             	cmovs  %edx,%eax
c0100a00:	c1 f8 0a             	sar    $0xa,%eax
c0100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a07:	c7 04 24 d0 bb 10 c0 	movl   $0xc010bbd0,(%esp)
c0100a0e:	e8 40 f9 ff ff       	call   c0100353 <cprintf>
}
c0100a13:	c9                   	leave  
c0100a14:	c3                   	ret    

c0100a15 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a15:	55                   	push   %ebp
c0100a16:	89 e5                	mov    %esp,%ebp
c0100a18:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a1e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a28:	89 04 24             	mov    %eax,(%esp)
c0100a2b:	e8 1a fb ff ff       	call   c010054a <debuginfo_eip>
c0100a30:	85 c0                	test   %eax,%eax
c0100a32:	74 15                	je     c0100a49 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a3b:	c7 04 24 fa bb 10 c0 	movl   $0xc010bbfa,(%esp)
c0100a42:	e8 0c f9 ff ff       	call   c0100353 <cprintf>
c0100a47:	eb 6d                	jmp    c0100ab6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a50:	eb 1c                	jmp    c0100a6e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a58:	01 d0                	add    %edx,%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a66:	01 ca                	add    %ecx,%edx
c0100a68:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a6a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a71:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a74:	7f dc                	jg     c0100a52 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a76:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7f:	01 d0                	add    %edx,%eax
c0100a81:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a84:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a87:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a8a:	89 d1                	mov    %edx,%ecx
c0100a8c:	29 c1                	sub    %eax,%ecx
c0100a8e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a94:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a98:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a9e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100aa2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaa:	c7 04 24 16 bc 10 c0 	movl   $0xc010bc16,(%esp)
c0100ab1:	e8 9d f8 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100ab6:	c9                   	leave  
c0100ab7:	c3                   	ret    

c0100ab8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100ab8:	55                   	push   %ebp
c0100ab9:	89 e5                	mov    %esp,%ebp
c0100abb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100abe:	8b 45 04             	mov    0x4(%ebp),%eax
c0100ac1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100ac7:	c9                   	leave  
c0100ac8:	c3                   	ret    

c0100ac9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ac9:	55                   	push   %ebp
c0100aca:	89 e5                	mov    %esp,%ebp
c0100acc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100acf:	89 e8                	mov    %ebp,%eax
c0100ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
c0100ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c0100ada:	e8 d9 ff ff ff       	call   c0100ab8 <read_eip>
c0100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
c0100ae2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ae9:	e9 88 00 00 00       	jmp    c0100b76 <print_stackframe+0xad>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af1:	83 c0 08             	add    $0x8,%eax
c0100af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        int j;
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100afa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b05:	c7 04 24 28 bc 10 c0 	movl   $0xc010bc28,(%esp)
c0100b0c:	e8 42 f8 ff ff       	call   c0100353 <cprintf>
        for (j = 0; j < 4; j++)
c0100b11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b18:	eb 25                	jmp    c0100b3f <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100b1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100b27:	01 d0                	add    %edx,%eax
c0100b29:	8b 00                	mov    (%eax),%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 44 bc 10 c0 	movl   $0xc010bc44,(%esp)
c0100b36:	e8 18 f8 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
        uint32_t *args = (uint32_t *)ebp + 2;
        int j;
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        for (j = 0; j < 4; j++)
c0100b3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b43:	7e d5                	jle    c0100b1a <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        cprintf("\n");
c0100b45:	c7 04 24 4c bc 10 c0 	movl   $0xc010bc4c,(%esp)
c0100b4c:	e8 02 f8 ff ff       	call   c0100353 <cprintf>
        print_debuginfo(eip - 1);
c0100b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b54:	83 e8 01             	sub    $0x1,%eax
c0100b57:	89 04 24             	mov    %eax,(%esp)
c0100b5a:	e8 b6 fe ff ff       	call   c0100a15 <print_debuginfo>
        eip = *(uint32_t *)(ebp + 4);
c0100b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b62:	83 c0 04             	add    $0x4,%eax
c0100b65:	8b 00                	mov    (%eax),%eax
c0100b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)ebp;
c0100b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i;
    for (i = 0; i < STACKFRAME_DEPTH && ebp; i++) {
c0100b72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b76:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b7a:	7f 0a                	jg     c0100b86 <print_stackframe+0xbd>
c0100b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b80:	0f 85 68 ff ff ff    	jne    c0100aee <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = *(uint32_t *)(ebp + 4);
        ebp = *(uint32_t *)ebp;
    }
}
c0100b86:	c9                   	leave  
c0100b87:	c3                   	ret    

c0100b88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b88:	55                   	push   %ebp
c0100b89:	89 e5                	mov    %esp,%ebp
c0100b8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b95:	eb 0c                	jmp    c0100ba3 <parse+0x1b>
            *buf ++ = '\0';
c0100b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100b9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100ba0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba6:	0f b6 00             	movzbl (%eax),%eax
c0100ba9:	84 c0                	test   %al,%al
c0100bab:	74 1d                	je     c0100bca <parse+0x42>
c0100bad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb0:	0f b6 00             	movzbl (%eax),%eax
c0100bb3:	0f be c0             	movsbl %al,%eax
c0100bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bba:	c7 04 24 d0 bc 10 c0 	movl   $0xc010bcd0,(%esp)
c0100bc1:	e8 87 ab 00 00       	call   c010b74d <strchr>
c0100bc6:	85 c0                	test   %eax,%eax
c0100bc8:	75 cd                	jne    c0100b97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bcd:	0f b6 00             	movzbl (%eax),%eax
c0100bd0:	84 c0                	test   %al,%al
c0100bd2:	75 02                	jne    c0100bd6 <parse+0x4e>
            break;
c0100bd4:	eb 67                	jmp    c0100c3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bd6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bda:	75 14                	jne    c0100bf0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bdc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100be3:	00 
c0100be4:	c7 04 24 d5 bc 10 c0 	movl   $0xc010bcd5,(%esp)
c0100beb:	e8 63 f7 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf3:	8d 50 01             	lea    0x1(%eax),%edx
c0100bf6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bf9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100c00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c03:	01 c2                	add    %eax,%edx
c0100c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c0a:	eb 04                	jmp    c0100c10 <parse+0x88>
            buf ++;
c0100c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	0f b6 00             	movzbl (%eax),%eax
c0100c16:	84 c0                	test   %al,%al
c0100c18:	74 1d                	je     c0100c37 <parse+0xaf>
c0100c1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1d:	0f b6 00             	movzbl (%eax),%eax
c0100c20:	0f be c0             	movsbl %al,%eax
c0100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c27:	c7 04 24 d0 bc 10 c0 	movl   $0xc010bcd0,(%esp)
c0100c2e:	e8 1a ab 00 00       	call   c010b74d <strchr>
c0100c33:	85 c0                	test   %eax,%eax
c0100c35:	74 d5                	je     c0100c0c <parse+0x84>
            buf ++;
        }
    }
c0100c37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c38:	e9 66 ff ff ff       	jmp    c0100ba3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c40:	c9                   	leave  
c0100c41:	c3                   	ret    

c0100c42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c42:	55                   	push   %ebp
c0100c43:	89 e5                	mov    %esp,%ebp
c0100c45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c52:	89 04 24             	mov    %eax,(%esp)
c0100c55:	e8 2e ff ff ff       	call   c0100b88 <parse>
c0100c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c61:	75 0a                	jne    c0100c6d <runcmd+0x2b>
        return 0;
c0100c63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c68:	e9 85 00 00 00       	jmp    c0100cf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c74:	eb 5c                	jmp    c0100cd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7c:	89 d0                	mov    %edx,%eax
c0100c7e:	01 c0                	add    %eax,%eax
c0100c80:	01 d0                	add    %edx,%eax
c0100c82:	c1 e0 02             	shl    $0x2,%eax
c0100c85:	05 20 90 12 c0       	add    $0xc0129020,%eax
c0100c8a:	8b 00                	mov    (%eax),%eax
c0100c8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c90:	89 04 24             	mov    %eax,(%esp)
c0100c93:	e8 16 aa 00 00       	call   c010b6ae <strcmp>
c0100c98:	85 c0                	test   %eax,%eax
c0100c9a:	75 32                	jne    c0100cce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c9f:	89 d0                	mov    %edx,%eax
c0100ca1:	01 c0                	add    %eax,%eax
c0100ca3:	01 d0                	add    %edx,%eax
c0100ca5:	c1 e0 02             	shl    $0x2,%eax
c0100ca8:	05 20 90 12 c0       	add    $0xc0129020,%eax
c0100cad:	8b 40 08             	mov    0x8(%eax),%eax
c0100cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100cb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100cb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100cb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100cbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100cc0:	83 c2 04             	add    $0x4,%edx
c0100cc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100cc7:	89 0c 24             	mov    %ecx,(%esp)
c0100cca:	ff d0                	call   *%eax
c0100ccc:	eb 24                	jmp    c0100cf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cd5:	83 f8 02             	cmp    $0x2,%eax
c0100cd8:	76 9c                	jbe    c0100c76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce1:	c7 04 24 f3 bc 10 c0 	movl   $0xc010bcf3,(%esp)
c0100ce8:	e8 66 f6 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf2:	c9                   	leave  
c0100cf3:	c3                   	ret    

c0100cf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cf4:	55                   	push   %ebp
c0100cf5:	89 e5                	mov    %esp,%ebp
c0100cf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cfa:	c7 04 24 0c bd 10 c0 	movl   $0xc010bd0c,(%esp)
c0100d01:	e8 4d f6 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100d06:	c7 04 24 34 bd 10 c0 	movl   $0xc010bd34,(%esp)
c0100d0d:	e8 41 f6 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d16:	74 0b                	je     c0100d23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1b:	89 04 24             	mov    %eax,(%esp)
c0100d1e:	e8 50 16 00 00       	call   c0102373 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d23:	c7 04 24 59 bd 10 c0 	movl   $0xc010bd59,(%esp)
c0100d2a:	e8 1b f5 ff ff       	call   c010024a <readline>
c0100d2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d36:	74 18                	je     c0100d50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d42:	89 04 24             	mov    %eax,(%esp)
c0100d45:	e8 f8 fe ff ff       	call   c0100c42 <runcmd>
c0100d4a:	85 c0                	test   %eax,%eax
c0100d4c:	79 02                	jns    c0100d50 <kmonitor+0x5c>
                break;
c0100d4e:	eb 02                	jmp    c0100d52 <kmonitor+0x5e>
            }
        }
    }
c0100d50:	eb d1                	jmp    c0100d23 <kmonitor+0x2f>
}
c0100d52:	c9                   	leave  
c0100d53:	c3                   	ret    

c0100d54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d54:	55                   	push   %ebp
c0100d55:	89 e5                	mov    %esp,%ebp
c0100d57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d61:	eb 3f                	jmp    c0100da2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d66:	89 d0                	mov    %edx,%eax
c0100d68:	01 c0                	add    %eax,%eax
c0100d6a:	01 d0                	add    %edx,%eax
c0100d6c:	c1 e0 02             	shl    $0x2,%eax
c0100d6f:	05 20 90 12 c0       	add    $0xc0129020,%eax
c0100d74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d7a:	89 d0                	mov    %edx,%eax
c0100d7c:	01 c0                	add    %eax,%eax
c0100d7e:	01 d0                	add    %edx,%eax
c0100d80:	c1 e0 02             	shl    $0x2,%eax
c0100d83:	05 20 90 12 c0       	add    $0xc0129020,%eax
c0100d88:	8b 00                	mov    (%eax),%eax
c0100d8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d92:	c7 04 24 5d bd 10 c0 	movl   $0xc010bd5d,(%esp)
c0100d99:	e8 b5 f5 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100da5:	83 f8 02             	cmp    $0x2,%eax
c0100da8:	76 b9                	jbe    c0100d63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100daf:	c9                   	leave  
c0100db0:	c3                   	ret    

c0100db1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100db1:	55                   	push   %ebp
c0100db2:	89 e5                	mov    %esp,%ebp
c0100db4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100db7:	e8 c3 fb ff ff       	call   c010097f <print_kerninfo>
    return 0;
c0100dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dc1:	c9                   	leave  
c0100dc2:	c3                   	ret    

c0100dc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100dc3:	55                   	push   %ebp
c0100dc4:	89 e5                	mov    %esp,%ebp
c0100dc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dc9:	e8 fb fc ff ff       	call   c0100ac9 <print_stackframe>
    return 0;
c0100dce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dd3:	c9                   	leave  
c0100dd4:	c3                   	ret    

c0100dd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100dd5:	55                   	push   %ebp
c0100dd6:	89 e5                	mov    %esp,%ebp
c0100dd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ddb:	a1 60 b3 19 c0       	mov    0xc019b360,%eax
c0100de0:	85 c0                	test   %eax,%eax
c0100de2:	74 02                	je     c0100de6 <__panic+0x11>
        goto panic_dead;
c0100de4:	eb 48                	jmp    c0100e2e <__panic+0x59>
    }
    is_panic = 1;
c0100de6:	c7 05 60 b3 19 c0 01 	movl   $0x1,0xc019b360
c0100ded:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100df0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100df3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100df6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100df9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100dfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e04:	c7 04 24 66 bd 10 c0 	movl   $0xc010bd66,(%esp)
c0100e0b:	e8 43 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e1a:	89 04 24             	mov    %eax,(%esp)
c0100e1d:	e8 fe f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e22:	c7 04 24 82 bd 10 c0 	movl   $0xc010bd82,(%esp)
c0100e29:	e8 25 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100e2e:	e8 fa 11 00 00       	call   c010202d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e3a:	e8 b5 fe ff ff       	call   c0100cf4 <kmonitor>
    }
c0100e3f:	eb f2                	jmp    c0100e33 <__panic+0x5e>

c0100e41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e41:	55                   	push   %ebp
c0100e42:	89 e5                	mov    %esp,%ebp
c0100e44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e5b:	c7 04 24 84 bd 10 c0 	movl   $0xc010bd84,(%esp)
c0100e62:	e8 ec f4 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e71:	89 04 24             	mov    %eax,(%esp)
c0100e74:	e8 a7 f4 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100e79:	c7 04 24 82 bd 10 c0 	movl   $0xc010bd82,(%esp)
c0100e80:	e8 ce f4 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100e85:	c9                   	leave  
c0100e86:	c3                   	ret    

c0100e87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e87:	55                   	push   %ebp
c0100e88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e8a:	a1 60 b3 19 c0       	mov    0xc019b360,%eax
}
c0100e8f:	5d                   	pop    %ebp
c0100e90:	c3                   	ret    

c0100e91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e91:	55                   	push   %ebp
c0100e92:	89 e5                	mov    %esp,%ebp
c0100e94:	83 ec 28             	sub    $0x28,%esp
c0100e97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100ea5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ea9:	ee                   	out    %al,(%dx)
c0100eaa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100eb0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100eb4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ebc:	ee                   	out    %al,(%dx)
c0100ebd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ec3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100ec7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ecb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ecf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ed0:	c7 05 b4 df 19 c0 00 	movl   $0x0,0xc019dfb4
c0100ed7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100eda:	c7 04 24 a2 bd 10 c0 	movl   $0xc010bda2,(%esp)
c0100ee1:	e8 6d f4 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100ee6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100eed:	e8 99 11 00 00       	call   c010208b <pic_enable>
}
c0100ef2:	c9                   	leave  
c0100ef3:	c3                   	ret    

c0100ef4 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ef4:	55                   	push   %ebp
c0100ef5:	89 e5                	mov    %esp,%ebp
c0100ef7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100efa:	9c                   	pushf  
c0100efb:	58                   	pop    %eax
c0100efc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100f02:	25 00 02 00 00       	and    $0x200,%eax
c0100f07:	85 c0                	test   %eax,%eax
c0100f09:	74 0c                	je     c0100f17 <__intr_save+0x23>
        intr_disable();
c0100f0b:	e8 1d 11 00 00       	call   c010202d <intr_disable>
        return 1;
c0100f10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f15:	eb 05                	jmp    c0100f1c <__intr_save+0x28>
    }
    return 0;
c0100f17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f1c:	c9                   	leave  
c0100f1d:	c3                   	ret    

c0100f1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f1e:	55                   	push   %ebp
c0100f1f:	89 e5                	mov    %esp,%ebp
c0100f21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f28:	74 05                	je     c0100f2f <__intr_restore+0x11>
        intr_enable();
c0100f2a:	e8 f8 10 00 00       	call   c0102027 <intr_enable>
    }
}
c0100f2f:	c9                   	leave  
c0100f30:	c3                   	ret    

c0100f31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f31:	55                   	push   %ebp
c0100f32:	89 e5                	mov    %esp,%ebp
c0100f34:	83 ec 10             	sub    $0x10,%esp
c0100f37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100f41:	89 c2                	mov    %eax,%edx
c0100f43:	ec                   	in     (%dx),%al
c0100f44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100f47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100f4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f51:	89 c2                	mov    %eax,%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100f57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100f5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f61:	89 c2                	mov    %eax,%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100f67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100f6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f71:	89 c2                	mov    %eax,%edx
c0100f73:	ec                   	in     (%dx),%al
c0100f74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f89:	0f b7 00             	movzwl (%eax),%eax
c0100f8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100f90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f9b:	0f b7 00             	movzwl (%eax),%eax
c0100f9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fa2:	74 12                	je     c0100fb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fa4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100fab:	66 c7 05 86 b3 19 c0 	movw   $0x3b4,0xc019b386
c0100fb2:	b4 03 
c0100fb4:	eb 13                	jmp    c0100fc9 <cga_init+0x50>
    } else {
        *cp = was;
c0100fb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100fb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fbd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fc0:	66 c7 05 86 b3 19 c0 	movw   $0x3d4,0xc019b386
c0100fc7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fc9:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c0100fd0:	0f b7 c0             	movzwl %ax,%eax
c0100fd3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100fd7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fdb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fdf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fe3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100fe4:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c0100feb:	83 c0 01             	add    $0x1,%eax
c0100fee:	0f b7 c0             	movzwl %ax,%eax
c0100ff1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ff9:	89 c2                	mov    %eax,%edx
c0100ffb:	ec                   	in     (%dx),%al
c0100ffc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	c1 e0 08             	shl    $0x8,%eax
c0101009:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c010100c:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c0101013:	0f b7 c0             	movzwl %ax,%eax
c0101016:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010101a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101022:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101026:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101027:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c010102e:	83 c0 01             	add    $0x1,%eax
c0101031:	0f b7 c0             	movzwl %ax,%eax
c0101034:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101038:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010103c:	89 c2                	mov    %eax,%edx
c010103e:	ec                   	in     (%dx),%al
c010103f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0101042:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101046:	0f b6 c0             	movzbl %al,%eax
c0101049:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c010104c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010104f:	a3 80 b3 19 c0       	mov    %eax,0xc019b380
    crt_pos = pos;
c0101054:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101057:	66 a3 84 b3 19 c0    	mov    %ax,0xc019b384
}
c010105d:	c9                   	leave  
c010105e:	c3                   	ret    

c010105f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010105f:	55                   	push   %ebp
c0101060:	89 e5                	mov    %esp,%ebp
c0101062:	83 ec 48             	sub    $0x48,%esp
c0101065:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c010106b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101073:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101077:	ee                   	out    %al,(%dx)
c0101078:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c010107e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0101082:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101086:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0101091:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0101095:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101099:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010a4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010a8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010ac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
c01010b1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010b7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010bb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010bf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010c3:	ee                   	out    %al,(%dx)
c01010c4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010ca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01010d6:	ee                   	out    %al,(%dx)
c01010d7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c01010dd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c01010e1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01010e5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01010e9:	ee                   	out    %al,(%dx)
c01010ea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01010f0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01010f4:	89 c2                	mov    %eax,%edx
c01010f6:	ec                   	in     (%dx),%al
c01010f7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c01010fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c01010fe:	3c ff                	cmp    $0xff,%al
c0101100:	0f 95 c0             	setne  %al
c0101103:	0f b6 c0             	movzbl %al,%eax
c0101106:	a3 88 b3 19 c0       	mov    %eax,0xc019b388
c010110b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101111:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101115:	89 c2                	mov    %eax,%edx
c0101117:	ec                   	in     (%dx),%al
c0101118:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010111b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101121:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101125:	89 c2                	mov    %eax,%edx
c0101127:	ec                   	in     (%dx),%al
c0101128:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010112b:	a1 88 b3 19 c0       	mov    0xc019b388,%eax
c0101130:	85 c0                	test   %eax,%eax
c0101132:	74 0c                	je     c0101140 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101134:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010113b:	e8 4b 0f 00 00       	call   c010208b <pic_enable>
    }
}
c0101140:	c9                   	leave  
c0101141:	c3                   	ret    

c0101142 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101142:	55                   	push   %ebp
c0101143:	89 e5                	mov    %esp,%ebp
c0101145:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101148:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010114f:	eb 09                	jmp    c010115a <lpt_putc_sub+0x18>
        delay();
c0101151:	e8 db fd ff ff       	call   c0100f31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101156:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010115a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101160:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101164:	89 c2                	mov    %eax,%edx
c0101166:	ec                   	in     (%dx),%al
c0101167:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010116a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010116e:	84 c0                	test   %al,%al
c0101170:	78 09                	js     c010117b <lpt_putc_sub+0x39>
c0101172:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101179:	7e d6                	jle    c0101151 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010117b:	8b 45 08             	mov    0x8(%ebp),%eax
c010117e:	0f b6 c0             	movzbl %al,%eax
c0101181:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101187:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010118a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010118e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101192:	ee                   	out    %al,(%dx)
c0101193:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101199:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010119d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a5:	ee                   	out    %al,(%dx)
c01011a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01011b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01011b9:	c9                   	leave  
c01011ba:	c3                   	ret    

c01011bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01011bb:	55                   	push   %ebp
c01011bc:	89 e5                	mov    %esp,%ebp
c01011be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01011c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01011c5:	74 0d                	je     c01011d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01011c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ca:	89 04 24             	mov    %eax,(%esp)
c01011cd:	e8 70 ff ff ff       	call   c0101142 <lpt_putc_sub>
c01011d2:	eb 24                	jmp    c01011f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01011d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011db:	e8 62 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01011e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01011e7:	e8 56 ff ff ff       	call   c0101142 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01011ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01011f3:	e8 4a ff ff ff       	call   c0101142 <lpt_putc_sub>
    }
}
c01011f8:	c9                   	leave  
c01011f9:	c3                   	ret    

c01011fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01011fa:	55                   	push   %ebp
c01011fb:	89 e5                	mov    %esp,%ebp
c01011fd:	53                   	push   %ebx
c01011fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101201:	8b 45 08             	mov    0x8(%ebp),%eax
c0101204:	b0 00                	mov    $0x0,%al
c0101206:	85 c0                	test   %eax,%eax
c0101208:	75 07                	jne    c0101211 <cga_putc+0x17>
        c |= 0x0700;
c010120a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101211:	8b 45 08             	mov    0x8(%ebp),%eax
c0101214:	0f b6 c0             	movzbl %al,%eax
c0101217:	83 f8 0a             	cmp    $0xa,%eax
c010121a:	74 4c                	je     c0101268 <cga_putc+0x6e>
c010121c:	83 f8 0d             	cmp    $0xd,%eax
c010121f:	74 57                	je     c0101278 <cga_putc+0x7e>
c0101221:	83 f8 08             	cmp    $0x8,%eax
c0101224:	0f 85 88 00 00 00    	jne    c01012b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010122a:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c0101231:	66 85 c0             	test   %ax,%ax
c0101234:	74 30                	je     c0101266 <cga_putc+0x6c>
            crt_pos --;
c0101236:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c010123d:	83 e8 01             	sub    $0x1,%eax
c0101240:	66 a3 84 b3 19 c0    	mov    %ax,0xc019b384
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101246:	a1 80 b3 19 c0       	mov    0xc019b380,%eax
c010124b:	0f b7 15 84 b3 19 c0 	movzwl 0xc019b384,%edx
c0101252:	0f b7 d2             	movzwl %dx,%edx
c0101255:	01 d2                	add    %edx,%edx
c0101257:	01 c2                	add    %eax,%edx
c0101259:	8b 45 08             	mov    0x8(%ebp),%eax
c010125c:	b0 00                	mov    $0x0,%al
c010125e:	83 c8 20             	or     $0x20,%eax
c0101261:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101264:	eb 72                	jmp    c01012d8 <cga_putc+0xde>
c0101266:	eb 70                	jmp    c01012d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101268:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c010126f:	83 c0 50             	add    $0x50,%eax
c0101272:	66 a3 84 b3 19 c0    	mov    %ax,0xc019b384
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101278:	0f b7 1d 84 b3 19 c0 	movzwl 0xc019b384,%ebx
c010127f:	0f b7 0d 84 b3 19 c0 	movzwl 0xc019b384,%ecx
c0101286:	0f b7 c1             	movzwl %cx,%eax
c0101289:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010128f:	c1 e8 10             	shr    $0x10,%eax
c0101292:	89 c2                	mov    %eax,%edx
c0101294:	66 c1 ea 06          	shr    $0x6,%dx
c0101298:	89 d0                	mov    %edx,%eax
c010129a:	c1 e0 02             	shl    $0x2,%eax
c010129d:	01 d0                	add    %edx,%eax
c010129f:	c1 e0 04             	shl    $0x4,%eax
c01012a2:	29 c1                	sub    %eax,%ecx
c01012a4:	89 ca                	mov    %ecx,%edx
c01012a6:	89 d8                	mov    %ebx,%eax
c01012a8:	29 d0                	sub    %edx,%eax
c01012aa:	66 a3 84 b3 19 c0    	mov    %ax,0xc019b384
        break;
c01012b0:	eb 26                	jmp    c01012d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01012b2:	8b 0d 80 b3 19 c0    	mov    0xc019b380,%ecx
c01012b8:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	66 89 15 84 b3 19 c0 	mov    %dx,0xc019b384
c01012c9:	0f b7 c0             	movzwl %ax,%eax
c01012cc:	01 c0                	add    %eax,%eax
c01012ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01012d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01012d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01012d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01012d8:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c01012df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01012e3:	76 5b                	jbe    c0101340 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01012e5:	a1 80 b3 19 c0       	mov    0xc019b380,%eax
c01012ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01012f0:	a1 80 b3 19 c0       	mov    0xc019b380,%eax
c01012f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01012fc:	00 
c01012fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101301:	89 04 24             	mov    %eax,(%esp)
c0101304:	e8 42 a6 00 00       	call   c010b94b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101309:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101310:	eb 15                	jmp    c0101327 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101312:	a1 80 b3 19 c0       	mov    0xc019b380,%eax
c0101317:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010131a:	01 d2                	add    %edx,%edx
c010131c:	01 d0                	add    %edx,%eax
c010131e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101327:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010132e:	7e e2                	jle    c0101312 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101330:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c0101337:	83 e8 50             	sub    $0x50,%eax
c010133a:	66 a3 84 b3 19 c0    	mov    %ax,0xc019b384
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101340:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c0101347:	0f b7 c0             	movzwl %ax,%eax
c010134a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010134e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101352:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101356:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010135a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010135b:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c0101362:	66 c1 e8 08          	shr    $0x8,%ax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	0f b7 15 86 b3 19 c0 	movzwl 0xc019b386,%edx
c0101370:	83 c2 01             	add    $0x1,%edx
c0101373:	0f b7 d2             	movzwl %dx,%edx
c0101376:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010137a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010137d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101381:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101385:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101386:	0f b7 05 86 b3 19 c0 	movzwl 0xc019b386,%eax
c010138d:	0f b7 c0             	movzwl %ax,%eax
c0101390:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101394:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101398:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010139c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013a1:	0f b7 05 84 b3 19 c0 	movzwl 0xc019b384,%eax
c01013a8:	0f b6 c0             	movzbl %al,%eax
c01013ab:	0f b7 15 86 b3 19 c0 	movzwl 0xc019b386,%edx
c01013b2:	83 c2 01             	add    $0x1,%edx
c01013b5:	0f b7 d2             	movzwl %dx,%edx
c01013b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01013bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01013bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01013c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01013c7:	ee                   	out    %al,(%dx)
}
c01013c8:	83 c4 34             	add    $0x34,%esp
c01013cb:	5b                   	pop    %ebx
c01013cc:	5d                   	pop    %ebp
c01013cd:	c3                   	ret    

c01013ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01013db:	eb 09                	jmp    c01013e6 <serial_putc_sub+0x18>
        delay();
c01013dd:	e8 4f fb ff ff       	call   c0100f31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01013e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f0:	89 c2                	mov    %eax,%edx
c01013f2:	ec                   	in     (%dx),%al
c01013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01013fa:	0f b6 c0             	movzbl %al,%eax
c01013fd:	83 e0 20             	and    $0x20,%eax
c0101400:	85 c0                	test   %eax,%eax
c0101402:	75 09                	jne    c010140d <serial_putc_sub+0x3f>
c0101404:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010140b:	7e d0                	jle    c01013dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010140d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101410:	0f b6 c0             	movzbl %al,%eax
c0101413:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101419:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010141c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101420:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101424:	ee                   	out    %al,(%dx)
}
c0101425:	c9                   	leave  
c0101426:	c3                   	ret    

c0101427 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101427:	55                   	push   %ebp
c0101428:	89 e5                	mov    %esp,%ebp
c010142a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010142d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101431:	74 0d                	je     c0101440 <serial_putc+0x19>
        serial_putc_sub(c);
c0101433:	8b 45 08             	mov    0x8(%ebp),%eax
c0101436:	89 04 24             	mov    %eax,(%esp)
c0101439:	e8 90 ff ff ff       	call   c01013ce <serial_putc_sub>
c010143e:	eb 24                	jmp    c0101464 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101440:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101447:	e8 82 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub(' ');
c010144c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101453:	e8 76 ff ff ff       	call   c01013ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101458:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010145f:	e8 6a ff ff ff       	call   c01013ce <serial_putc_sub>
    }
}
c0101464:	c9                   	leave  
c0101465:	c3                   	ret    

c0101466 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101466:	55                   	push   %ebp
c0101467:	89 e5                	mov    %esp,%ebp
c0101469:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010146c:	eb 33                	jmp    c01014a1 <cons_intr+0x3b>
        if (c != 0) {
c010146e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101472:	74 2d                	je     c01014a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101474:	a1 a4 b5 19 c0       	mov    0xc019b5a4,%eax
c0101479:	8d 50 01             	lea    0x1(%eax),%edx
c010147c:	89 15 a4 b5 19 c0    	mov    %edx,0xc019b5a4
c0101482:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101485:	88 90 a0 b3 19 c0    	mov    %dl,-0x3fe64c60(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010148b:	a1 a4 b5 19 c0       	mov    0xc019b5a4,%eax
c0101490:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101495:	75 0a                	jne    c01014a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101497:	c7 05 a4 b5 19 c0 00 	movl   $0x0,0xc019b5a4
c010149e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01014a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01014a4:	ff d0                	call   *%eax
c01014a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01014a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01014ad:	75 bf                	jne    c010146e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01014af:	c9                   	leave  
c01014b0:	c3                   	ret    

c01014b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01014b1:	55                   	push   %ebp
c01014b2:	89 e5                	mov    %esp,%ebp
c01014b4:	83 ec 10             	sub    $0x10,%esp
c01014b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01014c1:	89 c2                	mov    %eax,%edx
c01014c3:	ec                   	in     (%dx),%al
c01014c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01014c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01014cb:	0f b6 c0             	movzbl %al,%eax
c01014ce:	83 e0 01             	and    $0x1,%eax
c01014d1:	85 c0                	test   %eax,%eax
c01014d3:	75 07                	jne    c01014dc <serial_proc_data+0x2b>
        return -1;
c01014d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014da:	eb 2a                	jmp    c0101506 <serial_proc_data+0x55>
c01014dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01014e6:	89 c2                	mov    %eax,%edx
c01014e8:	ec                   	in     (%dx),%al
c01014e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01014ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01014f0:	0f b6 c0             	movzbl %al,%eax
c01014f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01014f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01014fa:	75 07                	jne    c0101503 <serial_proc_data+0x52>
        c = '\b';
c01014fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101503:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101506:	c9                   	leave  
c0101507:	c3                   	ret    

c0101508 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101508:	55                   	push   %ebp
c0101509:	89 e5                	mov    %esp,%ebp
c010150b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010150e:	a1 88 b3 19 c0       	mov    0xc019b388,%eax
c0101513:	85 c0                	test   %eax,%eax
c0101515:	74 0c                	je     c0101523 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101517:	c7 04 24 b1 14 10 c0 	movl   $0xc01014b1,(%esp)
c010151e:	e8 43 ff ff ff       	call   c0101466 <cons_intr>
    }
}
c0101523:	c9                   	leave  
c0101524:	c3                   	ret    

c0101525 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101525:	55                   	push   %ebp
c0101526:	89 e5                	mov    %esp,%ebp
c0101528:	83 ec 38             	sub    $0x38,%esp
c010152b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101531:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101535:	89 c2                	mov    %eax,%edx
c0101537:	ec                   	in     (%dx),%al
c0101538:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010153b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	83 e0 01             	and    $0x1,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	75 0a                	jne    c0101553 <kbd_proc_data+0x2e>
        return -1;
c0101549:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010154e:	e9 59 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
c0101553:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101559:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010155d:	89 c2                	mov    %eax,%edx
c010155f:	ec                   	in     (%dx),%al
c0101560:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101563:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101567:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010156a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010156e:	75 17                	jne    c0101587 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101570:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c0101575:	83 c8 40             	or     $0x40,%eax
c0101578:	a3 a8 b5 19 c0       	mov    %eax,0xc019b5a8
        return 0;
c010157d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101582:	e9 25 01 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101587:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158b:	84 c0                	test   %al,%al
c010158d:	79 47                	jns    c01015d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010158f:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c0101594:	83 e0 40             	and    $0x40,%eax
c0101597:	85 c0                	test   %eax,%eax
c0101599:	75 09                	jne    c01015a4 <kbd_proc_data+0x7f>
c010159b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010159f:	83 e0 7f             	and    $0x7f,%eax
c01015a2:	eb 04                	jmp    c01015a8 <kbd_proc_data+0x83>
c01015a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01015ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015af:	0f b6 80 60 90 12 c0 	movzbl -0x3fed6fa0(%eax),%eax
c01015b6:	83 c8 40             	or     $0x40,%eax
c01015b9:	0f b6 c0             	movzbl %al,%eax
c01015bc:	f7 d0                	not    %eax
c01015be:	89 c2                	mov    %eax,%edx
c01015c0:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c01015c5:	21 d0                	and    %edx,%eax
c01015c7:	a3 a8 b5 19 c0       	mov    %eax,0xc019b5a8
        return 0;
c01015cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01015d1:	e9 d6 00 00 00       	jmp    c01016ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01015d6:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c01015db:	83 e0 40             	and    $0x40,%eax
c01015de:	85 c0                	test   %eax,%eax
c01015e0:	74 11                	je     c01015f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01015e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01015e6:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c01015eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01015ee:	a3 a8 b5 19 c0       	mov    %eax,0xc019b5a8
    }

    shift |= shiftcode[data];
c01015f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015f7:	0f b6 80 60 90 12 c0 	movzbl -0x3fed6fa0(%eax),%eax
c01015fe:	0f b6 d0             	movzbl %al,%edx
c0101601:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c0101606:	09 d0                	or     %edx,%eax
c0101608:	a3 a8 b5 19 c0       	mov    %eax,0xc019b5a8
    shift ^= togglecode[data];
c010160d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101611:	0f b6 80 60 91 12 c0 	movzbl -0x3fed6ea0(%eax),%eax
c0101618:	0f b6 d0             	movzbl %al,%edx
c010161b:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c0101620:	31 d0                	xor    %edx,%eax
c0101622:	a3 a8 b5 19 c0       	mov    %eax,0xc019b5a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101627:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c010162c:	83 e0 03             	and    $0x3,%eax
c010162f:	8b 14 85 60 95 12 c0 	mov    -0x3fed6aa0(,%eax,4),%edx
c0101636:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163a:	01 d0                	add    %edx,%eax
c010163c:	0f b6 00             	movzbl (%eax),%eax
c010163f:	0f b6 c0             	movzbl %al,%eax
c0101642:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101645:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c010164a:	83 e0 08             	and    $0x8,%eax
c010164d:	85 c0                	test   %eax,%eax
c010164f:	74 22                	je     c0101673 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101651:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101655:	7e 0c                	jle    c0101663 <kbd_proc_data+0x13e>
c0101657:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010165b:	7f 06                	jg     c0101663 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010165d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101661:	eb 10                	jmp    c0101673 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101663:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101667:	7e 0a                	jle    c0101673 <kbd_proc_data+0x14e>
c0101669:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010166d:	7f 04                	jg     c0101673 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010166f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101673:	a1 a8 b5 19 c0       	mov    0xc019b5a8,%eax
c0101678:	f7 d0                	not    %eax
c010167a:	83 e0 06             	and    $0x6,%eax
c010167d:	85 c0                	test   %eax,%eax
c010167f:	75 28                	jne    c01016a9 <kbd_proc_data+0x184>
c0101681:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101688:	75 1f                	jne    c01016a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010168a:	c7 04 24 bd bd 10 c0 	movl   $0xc010bdbd,(%esp)
c0101691:	e8 bd ec ff ff       	call   c0100353 <cprintf>
c0101696:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010169c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01016a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01016a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016ac:	c9                   	leave  
c01016ad:	c3                   	ret    

c01016ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01016ae:	55                   	push   %ebp
c01016af:	89 e5                	mov    %esp,%ebp
c01016b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01016b4:	c7 04 24 25 15 10 c0 	movl   $0xc0101525,(%esp)
c01016bb:	e8 a6 fd ff ff       	call   c0101466 <cons_intr>
}
c01016c0:	c9                   	leave  
c01016c1:	c3                   	ret    

c01016c2 <kbd_init>:

static void
kbd_init(void) {
c01016c2:	55                   	push   %ebp
c01016c3:	89 e5                	mov    %esp,%ebp
c01016c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01016c8:	e8 e1 ff ff ff       	call   c01016ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01016cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01016d4:	e8 b2 09 00 00       	call   c010208b <pic_enable>
}
c01016d9:	c9                   	leave  
c01016da:	c3                   	ret    

c01016db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01016db:	55                   	push   %ebp
c01016dc:	89 e5                	mov    %esp,%ebp
c01016de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01016e1:	e8 93 f8 ff ff       	call   c0100f79 <cga_init>
    serial_init();
c01016e6:	e8 74 f9 ff ff       	call   c010105f <serial_init>
    kbd_init();
c01016eb:	e8 d2 ff ff ff       	call   c01016c2 <kbd_init>
    if (!serial_exists) {
c01016f0:	a1 88 b3 19 c0       	mov    0xc019b388,%eax
c01016f5:	85 c0                	test   %eax,%eax
c01016f7:	75 0c                	jne    c0101705 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01016f9:	c7 04 24 c9 bd 10 c0 	movl   $0xc010bdc9,(%esp)
c0101700:	e8 4e ec ff ff       	call   c0100353 <cprintf>
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010170d:	e8 e2 f7 ff ff       	call   c0100ef4 <__intr_save>
c0101712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101715:	8b 45 08             	mov    0x8(%ebp),%eax
c0101718:	89 04 24             	mov    %eax,(%esp)
c010171b:	e8 9b fa ff ff       	call   c01011bb <lpt_putc>
        cga_putc(c);
c0101720:	8b 45 08             	mov    0x8(%ebp),%eax
c0101723:	89 04 24             	mov    %eax,(%esp)
c0101726:	e8 cf fa ff ff       	call   c01011fa <cga_putc>
        serial_putc(c);
c010172b:	8b 45 08             	mov    0x8(%ebp),%eax
c010172e:	89 04 24             	mov    %eax,(%esp)
c0101731:	e8 f1 fc ff ff       	call   c0101427 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101739:	89 04 24             	mov    %eax,(%esp)
c010173c:	e8 dd f7 ff ff       	call   c0100f1e <__intr_restore>
}
c0101741:	c9                   	leave  
c0101742:	c3                   	ret    

c0101743 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101743:	55                   	push   %ebp
c0101744:	89 e5                	mov    %esp,%ebp
c0101746:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101750:	e8 9f f7 ff ff       	call   c0100ef4 <__intr_save>
c0101755:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101758:	e8 ab fd ff ff       	call   c0101508 <serial_intr>
        kbd_intr();
c010175d:	e8 4c ff ff ff       	call   c01016ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101762:	8b 15 a0 b5 19 c0    	mov    0xc019b5a0,%edx
c0101768:	a1 a4 b5 19 c0       	mov    0xc019b5a4,%eax
c010176d:	39 c2                	cmp    %eax,%edx
c010176f:	74 31                	je     c01017a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101771:	a1 a0 b5 19 c0       	mov    0xc019b5a0,%eax
c0101776:	8d 50 01             	lea    0x1(%eax),%edx
c0101779:	89 15 a0 b5 19 c0    	mov    %edx,0xc019b5a0
c010177f:	0f b6 80 a0 b3 19 c0 	movzbl -0x3fe64c60(%eax),%eax
c0101786:	0f b6 c0             	movzbl %al,%eax
c0101789:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010178c:	a1 a0 b5 19 c0       	mov    0xc019b5a0,%eax
c0101791:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101796:	75 0a                	jne    c01017a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101798:	c7 05 a0 b5 19 c0 00 	movl   $0x0,0xc019b5a0
c010179f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01017a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01017a5:	89 04 24             	mov    %eax,(%esp)
c01017a8:	e8 71 f7 ff ff       	call   c0100f1e <__intr_restore>
    return c;
c01017ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01017b0:	c9                   	leave  
c01017b1:	c3                   	ret    

c01017b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01017b2:	55                   	push   %ebp
c01017b3:	89 e5                	mov    %esp,%ebp
c01017b5:	83 ec 14             	sub    $0x14,%esp
c01017b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01017bf:	90                   	nop
c01017c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01017c4:	83 c0 07             	add    $0x7,%eax
c01017c7:	0f b7 c0             	movzwl %ax,%eax
c01017ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01017d2:	89 c2                	mov    %eax,%edx
c01017d4:	ec                   	in     (%dx),%al
c01017d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01017d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017dc:	0f b6 c0             	movzbl %al,%eax
c01017df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01017e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017e5:	25 80 00 00 00       	and    $0x80,%eax
c01017ea:	85 c0                	test   %eax,%eax
c01017ec:	75 d2                	jne    c01017c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01017ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01017f2:	74 11                	je     c0101805 <ide_wait_ready+0x53>
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	83 e0 21             	and    $0x21,%eax
c01017fa:	85 c0                	test   %eax,%eax
c01017fc:	74 07                	je     c0101805 <ide_wait_ready+0x53>
        return -1;
c01017fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101803:	eb 05                	jmp    c010180a <ide_wait_ready+0x58>
    }
    return 0;
c0101805:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010180a:	c9                   	leave  
c010180b:	c3                   	ret    

c010180c <ide_init>:

void
ide_init(void) {
c010180c:	55                   	push   %ebp
c010180d:	89 e5                	mov    %esp,%ebp
c010180f:	57                   	push   %edi
c0101810:	53                   	push   %ebx
c0101811:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101817:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010181d:	e9 d6 02 00 00       	jmp    c0101af8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101822:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101826:	c1 e0 03             	shl    $0x3,%eax
c0101829:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101830:	29 c2                	sub    %eax,%edx
c0101832:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101838:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010183b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010183f:	66 d1 e8             	shr    %ax
c0101842:	0f b7 c0             	movzwl %ax,%eax
c0101845:	0f b7 04 85 e8 bd 10 	movzwl -0x3fef4218(,%eax,4),%eax
c010184c:	c0 
c010184d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101851:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101855:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010185c:	00 
c010185d:	89 04 24             	mov    %eax,(%esp)
c0101860:	e8 4d ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101865:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101869:	83 e0 01             	and    $0x1,%eax
c010186c:	c1 e0 04             	shl    $0x4,%eax
c010186f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101872:	0f b6 c0             	movzbl %al,%eax
c0101875:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101879:	83 c2 06             	add    $0x6,%edx
c010187c:	0f b7 d2             	movzwl %dx,%edx
c010187f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101883:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101886:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010188a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010188e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010188f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101893:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010189a:	00 
c010189b:	89 04 24             	mov    %eax,(%esp)
c010189e:	e8 0f ff ff ff       	call   c01017b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01018a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018a7:	83 c0 07             	add    $0x7,%eax
c01018aa:	0f b7 c0             	movzwl %ax,%eax
c01018ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01018b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01018b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01018be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018c9:	00 
c01018ca:	89 04 24             	mov    %eax,(%esp)
c01018cd:	e8 e0 fe ff ff       	call   c01017b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01018d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018d6:	83 c0 07             	add    $0x7,%eax
c01018d9:	0f b7 c0             	movzwl %ax,%eax
c01018dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01018e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01018e4:	89 c2                	mov    %eax,%edx
c01018e6:	ec                   	in     (%dx),%al
c01018e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01018ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018ee:	84 c0                	test   %al,%al
c01018f0:	0f 84 f7 01 00 00    	je     c0101aed <ide_init+0x2e1>
c01018f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01018fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101901:	00 
c0101902:	89 04 24             	mov    %eax,(%esp)
c0101905:	e8 a8 fe ff ff       	call   c01017b2 <ide_wait_ready>
c010190a:	85 c0                	test   %eax,%eax
c010190c:	0f 85 db 01 00 00    	jne    c0101aed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101912:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101916:	c1 e0 03             	shl    $0x3,%eax
c0101919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101920:	29 c2                	sub    %eax,%edx
c0101922:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101928:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010192b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010192f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101932:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101938:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010193b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101942:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101945:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101948:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010194b:	89 cb                	mov    %ecx,%ebx
c010194d:	89 df                	mov    %ebx,%edi
c010194f:	89 c1                	mov    %eax,%ecx
c0101951:	fc                   	cld    
c0101952:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101954:	89 c8                	mov    %ecx,%eax
c0101956:	89 fb                	mov    %edi,%ebx
c0101958:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010195b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010195e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010196a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101970:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101973:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101976:	25 00 00 00 04       	and    $0x4000000,%eax
c010197b:	85 c0                	test   %eax,%eax
c010197d:	74 0e                	je     c010198d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010197f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101982:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101988:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010198b:	eb 09                	jmp    c0101996 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010198d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101990:	8b 40 78             	mov    0x78(%eax),%eax
c0101993:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101996:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010199a:	c1 e0 03             	shl    $0x3,%eax
c010199d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019a4:	29 c2                	sub    %eax,%edx
c01019a6:	81 c2 c0 b5 19 c0    	add    $0xc019b5c0,%edx
c01019ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01019af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01019b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019b6:	c1 e0 03             	shl    $0x3,%eax
c01019b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c0:	29 c2                	sub    %eax,%edx
c01019c2:	81 c2 c0 b5 19 c0    	add    $0xc019b5c0,%edx
c01019c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01019ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01019d1:	83 c0 62             	add    $0x62,%eax
c01019d4:	0f b7 00             	movzwl (%eax),%eax
c01019d7:	0f b7 c0             	movzwl %ax,%eax
c01019da:	25 00 02 00 00       	and    $0x200,%eax
c01019df:	85 c0                	test   %eax,%eax
c01019e1:	75 24                	jne    c0101a07 <ide_init+0x1fb>
c01019e3:	c7 44 24 0c f0 bd 10 	movl   $0xc010bdf0,0xc(%esp)
c01019ea:	c0 
c01019eb:	c7 44 24 08 33 be 10 	movl   $0xc010be33,0x8(%esp)
c01019f2:	c0 
c01019f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019fa:	00 
c01019fb:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0101a02:	e8 ce f3 ff ff       	call   c0100dd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101a07:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101a0b:	c1 e0 03             	shl    $0x3,%eax
c0101a0e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a15:	29 c2                	sub    %eax,%edx
c0101a17:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101a1d:	83 c0 0c             	add    $0xc,%eax
c0101a20:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101a26:	83 c0 36             	add    $0x36,%eax
c0101a29:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101a2c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101a33:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101a3a:	eb 34                	jmp    c0101a70 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a42:	01 c2                	add    %eax,%edx
c0101a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a47:	8d 48 01             	lea    0x1(%eax),%ecx
c0101a4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101a4d:	01 c8                	add    %ecx,%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	88 02                	mov    %al,(%edx)
c0101a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a57:	8d 50 01             	lea    0x1(%eax),%edx
c0101a5a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a5d:	01 c2                	add    %eax,%edx
c0101a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a62:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101a65:	01 c8                	add    %ecx,%eax
c0101a67:	0f b6 00             	movzbl (%eax),%eax
c0101a6a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a6c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101a70:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a73:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101a76:	72 c4                	jb     c0101a3c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a7e:	01 d0                	add    %edx,%eax
c0101a80:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a86:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101a89:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101a8c:	85 c0                	test   %eax,%eax
c0101a8e:	74 0f                	je     c0101a9f <ide_init+0x293>
c0101a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101a93:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a96:	01 d0                	add    %edx,%eax
c0101a98:	0f b6 00             	movzbl (%eax),%eax
c0101a9b:	3c 20                	cmp    $0x20,%al
c0101a9d:	74 d9                	je     c0101a78 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a9f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101aa3:	c1 e0 03             	shl    $0x3,%eax
c0101aa6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101aad:	29 c2                	sub    %eax,%edx
c0101aaf:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101ab5:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101ab8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101abc:	c1 e0 03             	shl    $0x3,%eax
c0101abf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac6:	29 c2                	sub    %eax,%edx
c0101ac8:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101ace:	8b 50 08             	mov    0x8(%eax),%edx
c0101ad1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101ad5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101ad9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101add:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae1:	c7 04 24 5a be 10 c0 	movl   $0xc010be5a,(%esp)
c0101ae8:	e8 66 e8 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101af1:	83 c0 01             	add    $0x1,%eax
c0101af4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101af8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101afd:	0f 86 1f fd ff ff    	jbe    c0101822 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101b03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101b0a:	e8 7c 05 00 00       	call   c010208b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101b0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101b16:	e8 70 05 00 00       	call   c010208b <pic_enable>
}
c0101b1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101b21:	5b                   	pop    %ebx
c0101b22:	5f                   	pop    %edi
c0101b23:	5d                   	pop    %ebp
c0101b24:	c3                   	ret    

c0101b25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101b25:	55                   	push   %ebp
c0101b26:	89 e5                	mov    %esp,%ebp
c0101b28:	83 ec 04             	sub    $0x4,%esp
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101b32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101b37:	77 24                	ja     c0101b5d <ide_device_valid+0x38>
c0101b39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b3d:	c1 e0 03             	shl    $0x3,%eax
c0101b40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b47:	29 c2                	sub    %eax,%edx
c0101b49:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101b4f:	0f b6 00             	movzbl (%eax),%eax
c0101b52:	84 c0                	test   %al,%al
c0101b54:	74 07                	je     c0101b5d <ide_device_valid+0x38>
c0101b56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b5b:	eb 05                	jmp    c0101b62 <ide_device_valid+0x3d>
c0101b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b62:	c9                   	leave  
c0101b63:	c3                   	ret    

c0101b64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b64:	55                   	push   %ebp
c0101b65:	89 e5                	mov    %esp,%ebp
c0101b67:	83 ec 08             	sub    $0x8,%esp
c0101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b75:	89 04 24             	mov    %eax,(%esp)
c0101b78:	e8 a8 ff ff ff       	call   c0101b25 <ide_device_valid>
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 1b                	je     c0101b9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b85:	c1 e0 03             	shl    $0x3,%eax
c0101b88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b8f:	29 c2                	sub    %eax,%edx
c0101b91:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101b97:	8b 40 08             	mov    0x8(%eax),%eax
c0101b9a:	eb 05                	jmp    c0101ba1 <ide_device_size+0x3d>
    }
    return 0;
c0101b9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101ba1:	c9                   	leave  
c0101ba2:	c3                   	ret    

c0101ba3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101ba3:	55                   	push   %ebp
c0101ba4:	89 e5                	mov    %esp,%ebp
c0101ba6:	57                   	push   %edi
c0101ba7:	53                   	push   %ebx
c0101ba8:	83 ec 50             	sub    $0x50,%esp
c0101bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101bb2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101bb9:	77 24                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bbb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101bc0:	77 1d                	ja     c0101bdf <ide_read_secs+0x3c>
c0101bc2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101bc6:	c1 e0 03             	shl    $0x3,%eax
c0101bc9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bd0:	29 c2                	sub    %eax,%edx
c0101bd2:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101bd8:	0f b6 00             	movzbl (%eax),%eax
c0101bdb:	84 c0                	test   %al,%al
c0101bdd:	75 24                	jne    c0101c03 <ide_read_secs+0x60>
c0101bdf:	c7 44 24 0c 78 be 10 	movl   $0xc010be78,0xc(%esp)
c0101be6:	c0 
c0101be7:	c7 44 24 08 33 be 10 	movl   $0xc010be33,0x8(%esp)
c0101bee:	c0 
c0101bef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bf6:	00 
c0101bf7:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0101bfe:	e8 d2 f1 ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101c03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101c0a:	77 0f                	ja     c0101c1b <ide_read_secs+0x78>
c0101c0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101c12:	01 d0                	add    %edx,%eax
c0101c14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101c19:	76 24                	jbe    c0101c3f <ide_read_secs+0x9c>
c0101c1b:	c7 44 24 0c a0 be 10 	movl   $0xc010bea0,0xc(%esp)
c0101c22:	c0 
c0101c23:	c7 44 24 08 33 be 10 	movl   $0xc010be33,0x8(%esp)
c0101c2a:	c0 
c0101c2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101c32:	00 
c0101c33:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0101c3a:	e8 96 f1 ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101c3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c43:	66 d1 e8             	shr    %ax
c0101c46:	0f b7 c0             	movzwl %ax,%eax
c0101c49:	0f b7 04 85 e8 bd 10 	movzwl -0x3fef4218(,%eax,4),%eax
c0101c50:	c0 
c0101c51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101c55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c59:	66 d1 e8             	shr    %ax
c0101c5c:	0f b7 c0             	movzwl %ax,%eax
c0101c5f:	0f b7 04 85 ea bd 10 	movzwl -0x3fef4216(,%eax,4),%eax
c0101c66:	c0 
c0101c67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101c6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c76:	00 
c0101c77:	89 04 24             	mov    %eax,(%esp)
c0101c7a:	e8 33 fb ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101c83:	83 c0 02             	add    $0x2,%eax
c0101c86:	0f b7 c0             	movzwl %ax,%eax
c0101c89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101c8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101c95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101c99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c9d:	0f b6 c0             	movzbl %al,%eax
c0101ca0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ca4:	83 c2 02             	add    $0x2,%edx
c0101ca7:	0f b7 d2             	movzwl %dx,%edx
c0101caa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101cae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101cb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101cb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101cb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101cba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cbd:	0f b6 c0             	movzbl %al,%eax
c0101cc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101cc4:	83 c2 03             	add    $0x3,%edx
c0101cc7:	0f b7 d2             	movzwl %dx,%edx
c0101cca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101cce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101cd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101cd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101cd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101cda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cdd:	c1 e8 08             	shr    $0x8,%eax
c0101ce0:	0f b6 c0             	movzbl %al,%eax
c0101ce3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ce7:	83 c2 04             	add    $0x4,%edx
c0101cea:	0f b7 d2             	movzwl %dx,%edx
c0101ced:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101cf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101cf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101cf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d00:	c1 e8 10             	shr    $0x10,%eax
c0101d03:	0f b6 c0             	movzbl %al,%eax
c0101d06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d0a:	83 c2 05             	add    $0x5,%edx
c0101d0d:	0f b7 d2             	movzwl %dx,%edx
c0101d10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101d14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101d17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101d20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d24:	83 e0 01             	and    $0x1,%eax
c0101d27:	c1 e0 04             	shl    $0x4,%eax
c0101d2a:	89 c2                	mov    %eax,%edx
c0101d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d2f:	c1 e8 18             	shr    $0x18,%eax
c0101d32:	83 e0 0f             	and    $0xf,%eax
c0101d35:	09 d0                	or     %edx,%eax
c0101d37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101d3a:	0f b6 c0             	movzbl %al,%eax
c0101d3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101d41:	83 c2 06             	add    $0x6,%edx
c0101d44:	0f b7 d2             	movzwl %dx,%edx
c0101d47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d5b:	83 c0 07             	add    $0x7,%eax
c0101d5e:	0f b7 c0             	movzwl %ax,%eax
c0101d61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101d65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101d69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d79:	eb 5a                	jmp    c0101dd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d86:	00 
c0101d87:	89 04 24             	mov    %eax,(%esp)
c0101d8a:	e8 23 fa ff ff       	call   c01017b2 <ide_wait_ready>
c0101d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101d96:	74 02                	je     c0101d9a <ide_read_secs+0x1f7>
            goto out;
c0101d98:	eb 41                	jmp    c0101ddb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101d9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101da1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101da4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101da7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101dae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101db1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101db4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101db7:	89 cb                	mov    %ecx,%ebx
c0101db9:	89 df                	mov    %ebx,%edi
c0101dbb:	89 c1                	mov    %eax,%ecx
c0101dbd:	fc                   	cld    
c0101dbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101dc0:	89 c8                	mov    %ecx,%eax
c0101dc2:	89 fb                	mov    %edi,%ebx
c0101dc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101dc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101dca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101dce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101dd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101dd9:	75 a0                	jne    c0101d7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101dde:	83 c4 50             	add    $0x50,%esp
c0101de1:	5b                   	pop    %ebx
c0101de2:	5f                   	pop    %edi
c0101de3:	5d                   	pop    %ebp
c0101de4:	c3                   	ret    

c0101de5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101de5:	55                   	push   %ebp
c0101de6:	89 e5                	mov    %esp,%ebp
c0101de8:	56                   	push   %esi
c0101de9:	53                   	push   %ebx
c0101dea:	83 ec 50             	sub    $0x50,%esp
c0101ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101df4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101dfb:	77 24                	ja     c0101e21 <ide_write_secs+0x3c>
c0101dfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101e02:	77 1d                	ja     c0101e21 <ide_write_secs+0x3c>
c0101e04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e08:	c1 e0 03             	shl    $0x3,%eax
c0101e0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101e12:	29 c2                	sub    %eax,%edx
c0101e14:	8d 82 c0 b5 19 c0    	lea    -0x3fe64a40(%edx),%eax
c0101e1a:	0f b6 00             	movzbl (%eax),%eax
c0101e1d:	84 c0                	test   %al,%al
c0101e1f:	75 24                	jne    c0101e45 <ide_write_secs+0x60>
c0101e21:	c7 44 24 0c 78 be 10 	movl   $0xc010be78,0xc(%esp)
c0101e28:	c0 
c0101e29:	c7 44 24 08 33 be 10 	movl   $0xc010be33,0x8(%esp)
c0101e30:	c0 
c0101e31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101e38:	00 
c0101e39:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0101e40:	e8 90 ef ff ff       	call   c0100dd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e4c:	77 0f                	ja     c0101e5d <ide_write_secs+0x78>
c0101e4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e54:	01 d0                	add    %edx,%eax
c0101e56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e5b:	76 24                	jbe    c0101e81 <ide_write_secs+0x9c>
c0101e5d:	c7 44 24 0c a0 be 10 	movl   $0xc010bea0,0xc(%esp)
c0101e64:	c0 
c0101e65:	c7 44 24 08 33 be 10 	movl   $0xc010be33,0x8(%esp)
c0101e6c:	c0 
c0101e6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e74:	00 
c0101e75:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c0101e7c:	e8 54 ef ff ff       	call   c0100dd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e85:	66 d1 e8             	shr    %ax
c0101e88:	0f b7 c0             	movzwl %ax,%eax
c0101e8b:	0f b7 04 85 e8 bd 10 	movzwl -0x3fef4218(,%eax,4),%eax
c0101e92:	c0 
c0101e93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e9b:	66 d1 e8             	shr    %ax
c0101e9e:	0f b7 c0             	movzwl %ax,%eax
c0101ea1:	0f b7 04 85 ea bd 10 	movzwl -0x3fef4216(,%eax,4),%eax
c0101ea8:	c0 
c0101ea9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101ead:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101eb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101eb8:	00 
c0101eb9:	89 04 24             	mov    %eax,(%esp)
c0101ebc:	e8 f1 f8 ff ff       	call   c01017b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101ec1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101ec5:	83 c0 02             	add    $0x2,%eax
c0101ec8:	0f b7 c0             	movzwl %ax,%eax
c0101ecb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101ecf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ed3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ed7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101edb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101edc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101edf:	0f b6 c0             	movzbl %al,%eax
c0101ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee6:	83 c2 02             	add    $0x2,%edx
c0101ee9:	0f b7 d2             	movzwl %dx,%edx
c0101eec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ef0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ef3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101ef7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101efb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eff:	0f b6 c0             	movzbl %al,%eax
c0101f02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f06:	83 c2 03             	add    $0x3,%edx
c0101f09:	0f b7 d2             	movzwl %dx,%edx
c0101f0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101f10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101f13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101f17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101f1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f1f:	c1 e8 08             	shr    $0x8,%eax
c0101f22:	0f b6 c0             	movzbl %al,%eax
c0101f25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f29:	83 c2 04             	add    $0x4,%edx
c0101f2c:	0f b7 d2             	movzwl %dx,%edx
c0101f2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101f33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101f36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101f3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101f3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f42:	c1 e8 10             	shr    $0x10,%eax
c0101f45:	0f b6 c0             	movzbl %al,%eax
c0101f48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f4c:	83 c2 05             	add    $0x5,%edx
c0101f4f:	0f b7 d2             	movzwl %dx,%edx
c0101f52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f66:	83 e0 01             	and    $0x1,%eax
c0101f69:	c1 e0 04             	shl    $0x4,%eax
c0101f6c:	89 c2                	mov    %eax,%edx
c0101f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f71:	c1 e8 18             	shr    $0x18,%eax
c0101f74:	83 e0 0f             	and    $0xf,%eax
c0101f77:	09 d0                	or     %edx,%eax
c0101f79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f83:	83 c2 06             	add    $0x6,%edx
c0101f86:	0f b7 d2             	movzwl %dx,%edx
c0101f89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f9d:	83 c0 07             	add    $0x7,%eax
c0101fa0:	0f b7 c0             	movzwl %ax,%eax
c0101fa3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101fa7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101fab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101faf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101fb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fbb:	eb 5a                	jmp    c0102017 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101fbd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101fc8:	00 
c0101fc9:	89 04 24             	mov    %eax,(%esp)
c0101fcc:	e8 e1 f7 ff ff       	call   c01017b2 <ide_wait_ready>
c0101fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101fd8:	74 02                	je     c0101fdc <ide_write_secs+0x1f7>
            goto out;
c0101fda:	eb 41                	jmp    c010201d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101fdc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101fe0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101fe3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fe6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fe9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ff0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ff3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ff6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ff9:	89 cb                	mov    %ecx,%ebx
c0101ffb:	89 de                	mov    %ebx,%esi
c0101ffd:	89 c1                	mov    %eax,%ecx
c0101fff:	fc                   	cld    
c0102000:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0102002:	89 c8                	mov    %ecx,%eax
c0102004:	89 f3                	mov    %esi,%ebx
c0102006:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0102009:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c010200c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0102010:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0102017:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c010201b:	75 a0                	jne    c0101fbd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c010201d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102020:	83 c4 50             	add    $0x50,%esp
c0102023:	5b                   	pop    %ebx
c0102024:	5e                   	pop    %esi
c0102025:	5d                   	pop    %ebp
c0102026:	c3                   	ret    

c0102027 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0102027:	55                   	push   %ebp
c0102028:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010202a:	fb                   	sti    
    sti();
}
c010202b:	5d                   	pop    %ebp
c010202c:	c3                   	ret    

c010202d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010202d:	55                   	push   %ebp
c010202e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0102030:	fa                   	cli    
    cli();
}
c0102031:	5d                   	pop    %ebp
c0102032:	c3                   	ret    

c0102033 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0102033:	55                   	push   %ebp
c0102034:	89 e5                	mov    %esp,%ebp
c0102036:	83 ec 14             	sub    $0x14,%esp
c0102039:	8b 45 08             	mov    0x8(%ebp),%eax
c010203c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102040:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102044:	66 a3 70 95 12 c0    	mov    %ax,0xc0129570
    if (did_init) {
c010204a:	a1 a0 b6 19 c0       	mov    0xc019b6a0,%eax
c010204f:	85 c0                	test   %eax,%eax
c0102051:	74 36                	je     c0102089 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102053:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102057:	0f b6 c0             	movzbl %al,%eax
c010205a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102060:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102063:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102067:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010206b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010206c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102070:	66 c1 e8 08          	shr    $0x8,%ax
c0102074:	0f b6 c0             	movzbl %al,%eax
c0102077:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010207d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102080:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102084:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102088:	ee                   	out    %al,(%dx)
    }
}
c0102089:	c9                   	leave  
c010208a:	c3                   	ret    

c010208b <pic_enable>:

void
pic_enable(unsigned int irq) {
c010208b:	55                   	push   %ebp
c010208c:	89 e5                	mov    %esp,%ebp
c010208e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102091:	8b 45 08             	mov    0x8(%ebp),%eax
c0102094:	ba 01 00 00 00       	mov    $0x1,%edx
c0102099:	89 c1                	mov    %eax,%ecx
c010209b:	d3 e2                	shl    %cl,%edx
c010209d:	89 d0                	mov    %edx,%eax
c010209f:	f7 d0                	not    %eax
c01020a1:	89 c2                	mov    %eax,%edx
c01020a3:	0f b7 05 70 95 12 c0 	movzwl 0xc0129570,%eax
c01020aa:	21 d0                	and    %edx,%eax
c01020ac:	0f b7 c0             	movzwl %ax,%eax
c01020af:	89 04 24             	mov    %eax,(%esp)
c01020b2:	e8 7c ff ff ff       	call   c0102033 <pic_setmask>
}
c01020b7:	c9                   	leave  
c01020b8:	c3                   	ret    

c01020b9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01020b9:	55                   	push   %ebp
c01020ba:	89 e5                	mov    %esp,%ebp
c01020bc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01020bf:	c7 05 a0 b6 19 c0 01 	movl   $0x1,0xc019b6a0
c01020c6:	00 00 00 
c01020c9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01020cf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01020d3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01020d7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020db:	ee                   	out    %al,(%dx)
c01020dc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020e2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020ea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020ee:	ee                   	out    %al,(%dx)
c01020ef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020f5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020fd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102101:	ee                   	out    %al,(%dx)
c0102102:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102108:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010210c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102110:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102114:	ee                   	out    %al,(%dx)
c0102115:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010211b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010211f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102123:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102127:	ee                   	out    %al,(%dx)
c0102128:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010212e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102132:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102136:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010213a:	ee                   	out    %al,(%dx)
c010213b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102141:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102145:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102149:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010214d:	ee                   	out    %al,(%dx)
c010214e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102154:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102158:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010215c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102160:	ee                   	out    %al,(%dx)
c0102161:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102167:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010216b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010216f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102173:	ee                   	out    %al,(%dx)
c0102174:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010217a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010217e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102182:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102186:	ee                   	out    %al,(%dx)
c0102187:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010218d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102191:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102195:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102199:	ee                   	out    %al,(%dx)
c010219a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01021a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01021a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01021a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01021ac:	ee                   	out    %al,(%dx)
c01021ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01021b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01021b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01021bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01021bf:	ee                   	out    %al,(%dx)
c01021c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01021c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01021ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01021ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01021d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01021d3:	0f b7 05 70 95 12 c0 	movzwl 0xc0129570,%eax
c01021da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021de:	74 12                	je     c01021f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021e0:	0f b7 05 70 95 12 c0 	movzwl 0xc0129570,%eax
c01021e7:	0f b7 c0             	movzwl %ax,%eax
c01021ea:	89 04 24             	mov    %eax,(%esp)
c01021ed:	e8 41 fe ff ff       	call   c0102033 <pic_setmask>
    }
}
c01021f2:	c9                   	leave  
c01021f3:	c3                   	ret    

c01021f4 <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01021f4:	55                   	push   %ebp
c01021f5:	89 e5                	mov    %esp,%ebp
c01021f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102201:	00 
c0102202:	c7 04 24 e0 be 10 c0 	movl   $0xc010bee0,(%esp)
c0102209:	e8 45 e1 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010220e:	c7 04 24 ea be 10 c0 	movl   $0xc010beea,(%esp)
c0102215:	e8 39 e1 ff ff       	call   c0100353 <cprintf>
    // panic("EOT: kernel seems ok.");
#endif
}
c010221a:	c9                   	leave  
c010221b:	c3                   	ret    

c010221c <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010221c:	55                   	push   %ebp
c010221d:	89 e5                	mov    %esp,%ebp
c010221f:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c0102222:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102229:	e9 e2 00 00 00       	jmp    c0102310 <idt_init+0xf4>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
c010222e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102231:	8b 04 85 00 96 12 c0 	mov    -0x3fed6a00(,%eax,4),%eax
c0102238:	89 c2                	mov    %eax,%edx
c010223a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010223d:	66 89 14 c5 c0 b6 19 	mov    %dx,-0x3fe64940(,%eax,8)
c0102244:	c0 
c0102245:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102248:	66 c7 04 c5 c2 b6 19 	movw   $0x8,-0x3fe6493e(,%eax,8)
c010224f:	c0 08 00 
c0102252:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102255:	0f b6 14 c5 c4 b6 19 	movzbl -0x3fe6493c(,%eax,8),%edx
c010225c:	c0 
c010225d:	83 e2 e0             	and    $0xffffffe0,%edx
c0102260:	88 14 c5 c4 b6 19 c0 	mov    %dl,-0x3fe6493c(,%eax,8)
c0102267:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010226a:	0f b6 14 c5 c4 b6 19 	movzbl -0x3fe6493c(,%eax,8),%edx
c0102271:	c0 
c0102272:	83 e2 1f             	and    $0x1f,%edx
c0102275:	88 14 c5 c4 b6 19 c0 	mov    %dl,-0x3fe6493c(,%eax,8)
c010227c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010227f:	0f b6 14 c5 c5 b6 19 	movzbl -0x3fe6493b(,%eax,8),%edx
c0102286:	c0 
c0102287:	83 e2 f0             	and    $0xfffffff0,%edx
c010228a:	83 ca 0e             	or     $0xe,%edx
c010228d:	88 14 c5 c5 b6 19 c0 	mov    %dl,-0x3fe6493b(,%eax,8)
c0102294:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102297:	0f b6 14 c5 c5 b6 19 	movzbl -0x3fe6493b(,%eax,8),%edx
c010229e:	c0 
c010229f:	83 e2 ef             	and    $0xffffffef,%edx
c01022a2:	88 14 c5 c5 b6 19 c0 	mov    %dl,-0x3fe6493b(,%eax,8)
c01022a9:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01022b0:	75 07                	jne    c01022b9 <idt_init+0x9d>
c01022b2:	ba 03 00 00 00       	mov    $0x3,%edx
c01022b7:	eb 05                	jmp    c01022be <idt_init+0xa2>
c01022b9:	ba 00 00 00 00       	mov    $0x0,%edx
c01022be:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022c1:	83 e2 03             	and    $0x3,%edx
c01022c4:	89 d1                	mov    %edx,%ecx
c01022c6:	c1 e1 05             	shl    $0x5,%ecx
c01022c9:	0f b6 14 c5 c5 b6 19 	movzbl -0x3fe6493b(,%eax,8),%edx
c01022d0:	c0 
c01022d1:	83 e2 9f             	and    $0xffffff9f,%edx
c01022d4:	09 ca                	or     %ecx,%edx
c01022d6:	88 14 c5 c5 b6 19 c0 	mov    %dl,-0x3fe6493b(,%eax,8)
c01022dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022e0:	0f b6 14 c5 c5 b6 19 	movzbl -0x3fe6493b(,%eax,8),%edx
c01022e7:	c0 
c01022e8:	83 ca 80             	or     $0xffffff80,%edx
c01022eb:	88 14 c5 c5 b6 19 c0 	mov    %dl,-0x3fe6493b(,%eax,8)
c01022f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022f5:	8b 04 85 00 96 12 c0 	mov    -0x3fed6a00(,%eax,4),%eax
c01022fc:	c1 e8 10             	shr    $0x10,%eax
c01022ff:	89 c2                	mov    %eax,%edx
c0102301:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102304:	66 89 14 c5 c6 b6 19 	mov    %dx,-0x3fe6493a(,%eax,8)
c010230b:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < 256; i++)
c010230c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102310:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0102317:	0f 8e 11 ff ff ff    	jle    c010222e <idt_init+0x12>
c010231d:	c7 45 f8 80 95 12 c0 	movl   $0xc0129580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102324:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102327:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], i == T_SYSCALL ? DPL_USER : DPL_KERNEL);
    lidt(&idt_pd);
     /* LAB5 2013011303*/ 
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here 
}
c010232a:	c9                   	leave  
c010232b:	c3                   	ret    

c010232c <trapname>:

static const char *
trapname(int trapno) {
c010232c:	55                   	push   %ebp
c010232d:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010232f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102332:	83 f8 13             	cmp    $0x13,%eax
c0102335:	77 0c                	ja     c0102343 <trapname+0x17>
        return excnames[trapno];
c0102337:	8b 45 08             	mov    0x8(%ebp),%eax
c010233a:	8b 04 85 80 c3 10 c0 	mov    -0x3fef3c80(,%eax,4),%eax
c0102341:	eb 18                	jmp    c010235b <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102343:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102347:	7e 0d                	jle    c0102356 <trapname+0x2a>
c0102349:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c010234d:	7f 07                	jg     c0102356 <trapname+0x2a>
        return "Hardware Interrupt";
c010234f:	b8 f8 be 10 c0       	mov    $0xc010bef8,%eax
c0102354:	eb 05                	jmp    c010235b <trapname+0x2f>
    }
    return "(unknown trap)";
c0102356:	b8 0b bf 10 c0       	mov    $0xc010bf0b,%eax
}
c010235b:	5d                   	pop    %ebp
c010235c:	c3                   	ret    

c010235d <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c010235d:	55                   	push   %ebp
c010235e:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102360:	8b 45 08             	mov    0x8(%ebp),%eax
c0102363:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102367:	66 83 f8 08          	cmp    $0x8,%ax
c010236b:	0f 94 c0             	sete   %al
c010236e:	0f b6 c0             	movzbl %al,%eax
}
c0102371:	5d                   	pop    %ebp
c0102372:	c3                   	ret    

c0102373 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102373:	55                   	push   %ebp
c0102374:	89 e5                	mov    %esp,%ebp
c0102376:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0102379:	8b 45 08             	mov    0x8(%ebp),%eax
c010237c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102380:	c7 04 24 4c bf 10 c0 	movl   $0xc010bf4c,(%esp)
c0102387:	e8 c7 df ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c010238c:	8b 45 08             	mov    0x8(%ebp),%eax
c010238f:	89 04 24             	mov    %eax,(%esp)
c0102392:	e8 a1 01 00 00       	call   c0102538 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0102397:	8b 45 08             	mov    0x8(%ebp),%eax
c010239a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010239e:	0f b7 c0             	movzwl %ax,%eax
c01023a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023a5:	c7 04 24 5d bf 10 c0 	movl   $0xc010bf5d,(%esp)
c01023ac:	e8 a2 df ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01023b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b4:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01023b8:	0f b7 c0             	movzwl %ax,%eax
c01023bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023bf:	c7 04 24 70 bf 10 c0 	movl   $0xc010bf70,(%esp)
c01023c6:	e8 88 df ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01023cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ce:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01023d2:	0f b7 c0             	movzwl %ax,%eax
c01023d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023d9:	c7 04 24 83 bf 10 c0 	movl   $0xc010bf83,(%esp)
c01023e0:	e8 6e df ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01023e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e8:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01023ec:	0f b7 c0             	movzwl %ax,%eax
c01023ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023f3:	c7 04 24 96 bf 10 c0 	movl   $0xc010bf96,(%esp)
c01023fa:	e8 54 df ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01023ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102402:	8b 40 30             	mov    0x30(%eax),%eax
c0102405:	89 04 24             	mov    %eax,(%esp)
c0102408:	e8 1f ff ff ff       	call   c010232c <trapname>
c010240d:	8b 55 08             	mov    0x8(%ebp),%edx
c0102410:	8b 52 30             	mov    0x30(%edx),%edx
c0102413:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102417:	89 54 24 04          	mov    %edx,0x4(%esp)
c010241b:	c7 04 24 a9 bf 10 c0 	movl   $0xc010bfa9,(%esp)
c0102422:	e8 2c df ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102427:	8b 45 08             	mov    0x8(%ebp),%eax
c010242a:	8b 40 34             	mov    0x34(%eax),%eax
c010242d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102431:	c7 04 24 bb bf 10 c0 	movl   $0xc010bfbb,(%esp)
c0102438:	e8 16 df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c010243d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102440:	8b 40 38             	mov    0x38(%eax),%eax
c0102443:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102447:	c7 04 24 ca bf 10 c0 	movl   $0xc010bfca,(%esp)
c010244e:	e8 00 df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102453:	8b 45 08             	mov    0x8(%ebp),%eax
c0102456:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010245a:	0f b7 c0             	movzwl %ax,%eax
c010245d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102461:	c7 04 24 d9 bf 10 c0 	movl   $0xc010bfd9,(%esp)
c0102468:	e8 e6 de ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c010246d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102470:	8b 40 40             	mov    0x40(%eax),%eax
c0102473:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102477:	c7 04 24 ec bf 10 c0 	movl   $0xc010bfec,(%esp)
c010247e:	e8 d0 de ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102483:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010248a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102491:	eb 3e                	jmp    c01024d1 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102493:	8b 45 08             	mov    0x8(%ebp),%eax
c0102496:	8b 50 40             	mov    0x40(%eax),%edx
c0102499:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010249c:	21 d0                	and    %edx,%eax
c010249e:	85 c0                	test   %eax,%eax
c01024a0:	74 28                	je     c01024ca <print_trapframe+0x157>
c01024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024a5:	8b 04 85 a0 95 12 c0 	mov    -0x3fed6a60(,%eax,4),%eax
c01024ac:	85 c0                	test   %eax,%eax
c01024ae:	74 1a                	je     c01024ca <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024b3:	8b 04 85 a0 95 12 c0 	mov    -0x3fed6a60(,%eax,4),%eax
c01024ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024be:	c7 04 24 fb bf 10 c0 	movl   $0xc010bffb,(%esp)
c01024c5:	e8 89 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01024ce:	d1 65 f0             	shll   -0x10(%ebp)
c01024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024d4:	83 f8 17             	cmp    $0x17,%eax
c01024d7:	76 ba                	jbe    c0102493 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01024d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01024dc:	8b 40 40             	mov    0x40(%eax),%eax
c01024df:	25 00 30 00 00       	and    $0x3000,%eax
c01024e4:	c1 e8 0c             	shr    $0xc,%eax
c01024e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024eb:	c7 04 24 ff bf 10 c0 	movl   $0xc010bfff,(%esp)
c01024f2:	e8 5c de ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c01024f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fa:	89 04 24             	mov    %eax,(%esp)
c01024fd:	e8 5b fe ff ff       	call   c010235d <trap_in_kernel>
c0102502:	85 c0                	test   %eax,%eax
c0102504:	75 30                	jne    c0102536 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102506:	8b 45 08             	mov    0x8(%ebp),%eax
c0102509:	8b 40 44             	mov    0x44(%eax),%eax
c010250c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102510:	c7 04 24 08 c0 10 c0 	movl   $0xc010c008,(%esp)
c0102517:	e8 37 de ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010251c:	8b 45 08             	mov    0x8(%ebp),%eax
c010251f:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102523:	0f b7 c0             	movzwl %ax,%eax
c0102526:	89 44 24 04          	mov    %eax,0x4(%esp)
c010252a:	c7 04 24 17 c0 10 c0 	movl   $0xc010c017,(%esp)
c0102531:	e8 1d de ff ff       	call   c0100353 <cprintf>
    }
}
c0102536:	c9                   	leave  
c0102537:	c3                   	ret    

c0102538 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102538:	55                   	push   %ebp
c0102539:	89 e5                	mov    %esp,%ebp
c010253b:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c010253e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102541:	8b 00                	mov    (%eax),%eax
c0102543:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102547:	c7 04 24 2a c0 10 c0 	movl   $0xc010c02a,(%esp)
c010254e:	e8 00 de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102553:	8b 45 08             	mov    0x8(%ebp),%eax
c0102556:	8b 40 04             	mov    0x4(%eax),%eax
c0102559:	89 44 24 04          	mov    %eax,0x4(%esp)
c010255d:	c7 04 24 39 c0 10 c0 	movl   $0xc010c039,(%esp)
c0102564:	e8 ea dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0102569:	8b 45 08             	mov    0x8(%ebp),%eax
c010256c:	8b 40 08             	mov    0x8(%eax),%eax
c010256f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102573:	c7 04 24 48 c0 10 c0 	movl   $0xc010c048,(%esp)
c010257a:	e8 d4 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c010257f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102582:	8b 40 0c             	mov    0xc(%eax),%eax
c0102585:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102589:	c7 04 24 57 c0 10 c0 	movl   $0xc010c057,(%esp)
c0102590:	e8 be dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102595:	8b 45 08             	mov    0x8(%ebp),%eax
c0102598:	8b 40 10             	mov    0x10(%eax),%eax
c010259b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010259f:	c7 04 24 66 c0 10 c0 	movl   $0xc010c066,(%esp)
c01025a6:	e8 a8 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01025ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ae:	8b 40 14             	mov    0x14(%eax),%eax
c01025b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025b5:	c7 04 24 75 c0 10 c0 	movl   $0xc010c075,(%esp)
c01025bc:	e8 92 dd ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01025c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c4:	8b 40 18             	mov    0x18(%eax),%eax
c01025c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025cb:	c7 04 24 84 c0 10 c0 	movl   $0xc010c084,(%esp)
c01025d2:	e8 7c dd ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01025d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025da:	8b 40 1c             	mov    0x1c(%eax),%eax
c01025dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025e1:	c7 04 24 93 c0 10 c0 	movl   $0xc010c093,(%esp)
c01025e8:	e8 66 dd ff ff       	call   c0100353 <cprintf>
}
c01025ed:	c9                   	leave  
c01025ee:	c3                   	ret    

c01025ef <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01025ef:	55                   	push   %ebp
c01025f0:	89 e5                	mov    %esp,%ebp
c01025f2:	53                   	push   %ebx
c01025f3:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01025f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f9:	8b 40 34             	mov    0x34(%eax),%eax
c01025fc:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01025ff:	85 c0                	test   %eax,%eax
c0102601:	74 07                	je     c010260a <print_pgfault+0x1b>
c0102603:	b9 a2 c0 10 c0       	mov    $0xc010c0a2,%ecx
c0102608:	eb 05                	jmp    c010260f <print_pgfault+0x20>
c010260a:	b9 b3 c0 10 c0       	mov    $0xc010c0b3,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010260f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102612:	8b 40 34             	mov    0x34(%eax),%eax
c0102615:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102618:	85 c0                	test   %eax,%eax
c010261a:	74 07                	je     c0102623 <print_pgfault+0x34>
c010261c:	ba 57 00 00 00       	mov    $0x57,%edx
c0102621:	eb 05                	jmp    c0102628 <print_pgfault+0x39>
c0102623:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102628:	8b 45 08             	mov    0x8(%ebp),%eax
c010262b:	8b 40 34             	mov    0x34(%eax),%eax
c010262e:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102631:	85 c0                	test   %eax,%eax
c0102633:	74 07                	je     c010263c <print_pgfault+0x4d>
c0102635:	b8 55 00 00 00       	mov    $0x55,%eax
c010263a:	eb 05                	jmp    c0102641 <print_pgfault+0x52>
c010263c:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102641:	0f 20 d3             	mov    %cr2,%ebx
c0102644:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102647:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010264a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010264e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102652:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102656:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010265a:	c7 04 24 c4 c0 10 c0 	movl   $0xc010c0c4,(%esp)
c0102661:	e8 ed dc ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c0102666:	83 c4 34             	add    $0x34,%esp
c0102669:	5b                   	pop    %ebx
c010266a:	5d                   	pop    %ebp
c010266b:	c3                   	ret    

c010266c <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c010266c:	55                   	push   %ebp
c010266d:	89 e5                	mov    %esp,%ebp
c010266f:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c0102672:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c0102677:	85 c0                	test   %eax,%eax
c0102679:	74 0b                	je     c0102686 <pgfault_handler+0x1a>
            print_pgfault(tf);
c010267b:	8b 45 08             	mov    0x8(%ebp),%eax
c010267e:	89 04 24             	mov    %eax,(%esp)
c0102681:	e8 69 ff ff ff       	call   c01025ef <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c0102686:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c010268b:	85 c0                	test   %eax,%eax
c010268d:	74 3d                	je     c01026cc <pgfault_handler+0x60>
        assert(current == idleproc);
c010268f:	8b 15 88 bf 19 c0    	mov    0xc019bf88,%edx
c0102695:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010269a:	39 c2                	cmp    %eax,%edx
c010269c:	74 24                	je     c01026c2 <pgfault_handler+0x56>
c010269e:	c7 44 24 0c e7 c0 10 	movl   $0xc010c0e7,0xc(%esp)
c01026a5:	c0 
c01026a6:	c7 44 24 08 fb c0 10 	movl   $0xc010c0fb,0x8(%esp)
c01026ad:	c0 
c01026ae:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c01026b5:	00 
c01026b6:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c01026bd:	e8 13 e7 ff ff       	call   c0100dd5 <__panic>
        mm = check_mm_struct;
c01026c2:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c01026c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01026ca:	eb 46                	jmp    c0102712 <pgfault_handler+0xa6>
    }
    else {
        if (current == NULL) {
c01026cc:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01026d1:	85 c0                	test   %eax,%eax
c01026d3:	75 32                	jne    c0102707 <pgfault_handler+0x9b>
            print_trapframe(tf);
c01026d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d8:	89 04 24             	mov    %eax,(%esp)
c01026db:	e8 93 fc ff ff       	call   c0102373 <print_trapframe>
            print_pgfault(tf);
c01026e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e3:	89 04 24             	mov    %eax,(%esp)
c01026e6:	e8 04 ff ff ff       	call   c01025ef <print_pgfault>
            panic("unhandled page fault.\n");
c01026eb:	c7 44 24 08 21 c1 10 	movl   $0xc010c121,0x8(%esp)
c01026f2:	c0 
c01026f3:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01026fa:	00 
c01026fb:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c0102702:	e8 ce e6 ff ff       	call   c0100dd5 <__panic>
        }
        mm = current->mm;
c0102707:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010270c:	8b 40 18             	mov    0x18(%eax),%eax
c010270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102712:	0f 20 d0             	mov    %cr2,%eax
c0102715:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr2;
c0102718:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c010271b:	89 c2                	mov    %eax,%edx
c010271d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102720:	8b 40 34             	mov    0x34(%eax),%eax
c0102723:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010272e:	89 04 24             	mov    %eax,(%esp)
c0102731:	e8 6d 63 00 00       	call   c0108aa3 <do_pgfault>
}
c0102736:	c9                   	leave  
c0102737:	c3                   	ret    

c0102738 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102738:	55                   	push   %ebp
c0102739:	89 e5                	mov    %esp,%ebp
c010273b:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c010273e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c0102745:	8b 45 08             	mov    0x8(%ebp),%eax
c0102748:	8b 40 30             	mov    0x30(%eax),%eax
c010274b:	83 f8 2f             	cmp    $0x2f,%eax
c010274e:	77 38                	ja     c0102788 <trap_dispatch+0x50>
c0102750:	83 f8 2e             	cmp    $0x2e,%eax
c0102753:	0f 83 fa 01 00 00    	jae    c0102953 <trap_dispatch+0x21b>
c0102759:	83 f8 20             	cmp    $0x20,%eax
c010275c:	0f 84 07 01 00 00    	je     c0102869 <trap_dispatch+0x131>
c0102762:	83 f8 20             	cmp    $0x20,%eax
c0102765:	77 0a                	ja     c0102771 <trap_dispatch+0x39>
c0102767:	83 f8 0e             	cmp    $0xe,%eax
c010276a:	74 3e                	je     c01027aa <trap_dispatch+0x72>
c010276c:	e9 9a 01 00 00       	jmp    c010290b <trap_dispatch+0x1d3>
c0102771:	83 f8 21             	cmp    $0x21,%eax
c0102774:	0f 84 4f 01 00 00    	je     c01028c9 <trap_dispatch+0x191>
c010277a:	83 f8 24             	cmp    $0x24,%eax
c010277d:	0f 84 1d 01 00 00    	je     c01028a0 <trap_dispatch+0x168>
c0102783:	e9 83 01 00 00       	jmp    c010290b <trap_dispatch+0x1d3>
c0102788:	83 f8 78             	cmp    $0x78,%eax
c010278b:	0f 82 7a 01 00 00    	jb     c010290b <trap_dispatch+0x1d3>
c0102791:	83 f8 79             	cmp    $0x79,%eax
c0102794:	0f 86 55 01 00 00    	jbe    c01028ef <trap_dispatch+0x1b7>
c010279a:	3d 80 00 00 00       	cmp    $0x80,%eax
c010279f:	0f 84 ba 00 00 00    	je     c010285f <trap_dispatch+0x127>
c01027a5:	e9 61 01 00 00       	jmp    c010290b <trap_dispatch+0x1d3>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01027aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01027ad:	89 04 24             	mov    %eax,(%esp)
c01027b0:	e8 b7 fe ff ff       	call   c010266c <pgfault_handler>
c01027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01027b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01027bc:	0f 84 98 00 00 00    	je     c010285a <trap_dispatch+0x122>
            print_trapframe(tf);
c01027c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01027c5:	89 04 24             	mov    %eax,(%esp)
c01027c8:	e8 a6 fb ff ff       	call   c0102373 <print_trapframe>
            if (current == NULL) {
c01027cd:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01027d2:	85 c0                	test   %eax,%eax
c01027d4:	75 23                	jne    c01027f9 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c01027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01027dd:	c7 44 24 08 38 c1 10 	movl   $0xc010c138,0x8(%esp)
c01027e4:	c0 
c01027e5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01027ec:	00 
c01027ed:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c01027f4:	e8 dc e5 ff ff       	call   c0100dd5 <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c01027f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01027fc:	89 04 24             	mov    %eax,(%esp)
c01027ff:	e8 59 fb ff ff       	call   c010235d <trap_in_kernel>
c0102804:	85 c0                	test   %eax,%eax
c0102806:	74 23                	je     c010282b <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010280b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010280f:	c7 44 24 08 58 c1 10 	movl   $0xc010c158,0x8(%esp)
c0102816:	c0 
c0102817:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c010281e:	00 
c010281f:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c0102826:	e8 aa e5 ff ff       	call   c0100dd5 <__panic>
                }
                cprintf("killed by kernel.\n");
c010282b:	c7 04 24 86 c1 10 c0 	movl   $0xc010c186,(%esp)
c0102832:	e8 1c db ff ff       	call   c0100353 <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c0102837:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010283a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010283e:	c7 44 24 08 9c c1 10 	movl   $0xc010c19c,0x8(%esp)
c0102845:	c0 
c0102846:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010284d:	00 
c010284e:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c0102855:	e8 7b e5 ff ff       	call   c0100dd5 <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
c010285a:	e9 f5 00 00 00       	jmp    c0102954 <trap_dispatch+0x21c>
    case T_SYSCALL:
        syscall();
c010285f:	e8 35 85 00 00       	call   c010ad99 <syscall>
        break;
c0102864:	e9 eb 00 00 00       	jmp    c0102954 <trap_dispatch+0x21c>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if (++ticks == TICK_NUM) {
c0102869:	a1 b4 df 19 c0       	mov    0xc019dfb4,%eax
c010286e:	83 c0 01             	add    $0x1,%eax
c0102871:	a3 b4 df 19 c0       	mov    %eax,0xc019dfb4
c0102876:	83 f8 64             	cmp    $0x64,%eax
c0102879:	75 20                	jne    c010289b <trap_dispatch+0x163>
            print_ticks();
c010287b:	e8 74 f9 ff ff       	call   c01021f4 <print_ticks>
            ticks = 0;
c0102880:	c7 05 b4 df 19 c0 00 	movl   $0x0,0xc019dfb4
c0102887:	00 00 00 
            current->need_resched = 1;
c010288a:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010288f:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
        /* LAB5 2013011303 */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
  
        break;
c0102896:	e9 b9 00 00 00       	jmp    c0102954 <trap_dispatch+0x21c>
c010289b:	e9 b4 00 00 00       	jmp    c0102954 <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01028a0:	e8 9e ee ff ff       	call   c0101743 <cons_getc>
c01028a5:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01028a8:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028ac:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028b0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028b8:	c7 04 24 c5 c1 10 c0 	movl   $0xc010c1c5,(%esp)
c01028bf:	e8 8f da ff ff       	call   c0100353 <cprintf>
        break;
c01028c4:	e9 8b 00 00 00       	jmp    c0102954 <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01028c9:	e8 75 ee ff ff       	call   c0101743 <cons_getc>
c01028ce:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01028d1:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01028d5:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01028d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01028dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01028e1:	c7 04 24 d7 c1 10 c0 	movl   $0xc010c1d7,(%esp)
c01028e8:	e8 66 da ff ff       	call   c0100353 <cprintf>
        break;
c01028ed:	eb 65                	jmp    c0102954 <trap_dispatch+0x21c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01028ef:	c7 44 24 08 e6 c1 10 	movl   $0xc010c1e6,0x8(%esp)
c01028f6:	c0 
c01028f7:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01028fe:	00 
c01028ff:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c0102906:	e8 ca e4 ff ff       	call   c0100dd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c010290b:	8b 45 08             	mov    0x8(%ebp),%eax
c010290e:	89 04 24             	mov    %eax,(%esp)
c0102911:	e8 5d fa ff ff       	call   c0102373 <print_trapframe>
        if (current != NULL) {
c0102916:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010291b:	85 c0                	test   %eax,%eax
c010291d:	74 18                	je     c0102937 <trap_dispatch+0x1ff>
            cprintf("unhandled trap.\n");
c010291f:	c7 04 24 f6 c1 10 c0 	movl   $0xc010c1f6,(%esp)
c0102926:	e8 28 da ff ff       	call   c0100353 <cprintf>
            do_exit(-E_KILLED);
c010292b:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102932:	e8 05 72 00 00       	call   c0109b3c <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102937:	c7 44 24 08 07 c2 10 	movl   $0xc010c207,0x8(%esp)
c010293e:	c0 
c010293f:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0102946:	00 
c0102947:	c7 04 24 10 c1 10 c0 	movl   $0xc010c110,(%esp)
c010294e:	e8 82 e4 ff ff       	call   c0100dd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102953:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c0102954:	c9                   	leave  
c0102955:	c3                   	ret    

c0102956 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102956:	55                   	push   %ebp
c0102957:	89 e5                	mov    %esp,%ebp
c0102959:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c010295c:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0102961:	85 c0                	test   %eax,%eax
c0102963:	75 0d                	jne    c0102972 <trap+0x1c>
        trap_dispatch(tf);
c0102965:	8b 45 08             	mov    0x8(%ebp),%eax
c0102968:	89 04 24             	mov    %eax,(%esp)
c010296b:	e8 c8 fd ff ff       	call   c0102738 <trap_dispatch>
c0102970:	eb 6c                	jmp    c01029de <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c0102972:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0102977:	8b 40 3c             	mov    0x3c(%eax),%eax
c010297a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c010297d:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0102982:	8b 55 08             	mov    0x8(%ebp),%edx
c0102985:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c0102988:	8b 45 08             	mov    0x8(%ebp),%eax
c010298b:	89 04 24             	mov    %eax,(%esp)
c010298e:	e8 ca f9 ff ff       	call   c010235d <trap_in_kernel>
c0102993:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c0102996:	8b 45 08             	mov    0x8(%ebp),%eax
c0102999:	89 04 24             	mov    %eax,(%esp)
c010299c:	e8 97 fd ff ff       	call   c0102738 <trap_dispatch>
    
        current->tf = otf;
c01029a1:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01029a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01029a9:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c01029ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01029b0:	75 2c                	jne    c01029de <trap+0x88>
            if (current->flags & PF_EXITING) {
c01029b2:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01029b7:	8b 40 44             	mov    0x44(%eax),%eax
c01029ba:	83 e0 01             	and    $0x1,%eax
c01029bd:	85 c0                	test   %eax,%eax
c01029bf:	74 0c                	je     c01029cd <trap+0x77>
                do_exit(-E_KILLED);
c01029c1:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c01029c8:	e8 6f 71 00 00       	call   c0109b3c <do_exit>
            }
            if (current->need_resched) {
c01029cd:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01029d2:	8b 40 10             	mov    0x10(%eax),%eax
c01029d5:	85 c0                	test   %eax,%eax
c01029d7:	74 05                	je     c01029de <trap+0x88>
                schedule();
c01029d9:	e8 c3 81 00 00       	call   c010aba1 <schedule>
            }
        }
    }
}
c01029de:	c9                   	leave  
c01029df:	c3                   	ret    

c01029e0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029e0:	1e                   	push   %ds
    pushl %es
c01029e1:	06                   	push   %es
    pushl %fs
c01029e2:	0f a0                	push   %fs
    pushl %gs
c01029e4:	0f a8                	push   %gs
    pushal
c01029e6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029e7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01029ec:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01029ee:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01029f0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01029f1:	e8 60 ff ff ff       	call   c0102956 <trap>

    # pop the pushed stack pointer
    popl %esp
c01029f6:	5c                   	pop    %esp

c01029f7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01029f7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01029f8:	0f a9                	pop    %gs
    popl %fs
c01029fa:	0f a1                	pop    %fs
    popl %es
c01029fc:	07                   	pop    %es
    popl %ds
c01029fd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029fe:	83 c4 08             	add    $0x8,%esp
    iret
c0102a01:	cf                   	iret   

c0102a02 <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102a02:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102a06:	e9 ec ff ff ff       	jmp    c01029f7 <__trapret>

c0102a0b <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102a0b:	6a 00                	push   $0x0
  pushl $0
c0102a0d:	6a 00                	push   $0x0
  jmp __alltraps
c0102a0f:	e9 cc ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a14 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102a14:	6a 00                	push   $0x0
  pushl $1
c0102a16:	6a 01                	push   $0x1
  jmp __alltraps
c0102a18:	e9 c3 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a1d <vector2>:
.globl vector2
vector2:
  pushl $0
c0102a1d:	6a 00                	push   $0x0
  pushl $2
c0102a1f:	6a 02                	push   $0x2
  jmp __alltraps
c0102a21:	e9 ba ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a26 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102a26:	6a 00                	push   $0x0
  pushl $3
c0102a28:	6a 03                	push   $0x3
  jmp __alltraps
c0102a2a:	e9 b1 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a2f <vector4>:
.globl vector4
vector4:
  pushl $0
c0102a2f:	6a 00                	push   $0x0
  pushl $4
c0102a31:	6a 04                	push   $0x4
  jmp __alltraps
c0102a33:	e9 a8 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a38 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102a38:	6a 00                	push   $0x0
  pushl $5
c0102a3a:	6a 05                	push   $0x5
  jmp __alltraps
c0102a3c:	e9 9f ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a41 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102a41:	6a 00                	push   $0x0
  pushl $6
c0102a43:	6a 06                	push   $0x6
  jmp __alltraps
c0102a45:	e9 96 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a4a <vector7>:
.globl vector7
vector7:
  pushl $0
c0102a4a:	6a 00                	push   $0x0
  pushl $7
c0102a4c:	6a 07                	push   $0x7
  jmp __alltraps
c0102a4e:	e9 8d ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a53 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102a53:	6a 08                	push   $0x8
  jmp __alltraps
c0102a55:	e9 86 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a5a <vector9>:
.globl vector9
vector9:
  pushl $9
c0102a5a:	6a 09                	push   $0x9
  jmp __alltraps
c0102a5c:	e9 7f ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a61 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102a61:	6a 0a                	push   $0xa
  jmp __alltraps
c0102a63:	e9 78 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a68 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102a68:	6a 0b                	push   $0xb
  jmp __alltraps
c0102a6a:	e9 71 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a6f <vector12>:
.globl vector12
vector12:
  pushl $12
c0102a6f:	6a 0c                	push   $0xc
  jmp __alltraps
c0102a71:	e9 6a ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a76 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102a76:	6a 0d                	push   $0xd
  jmp __alltraps
c0102a78:	e9 63 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a7d <vector14>:
.globl vector14
vector14:
  pushl $14
c0102a7d:	6a 0e                	push   $0xe
  jmp __alltraps
c0102a7f:	e9 5c ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a84 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102a84:	6a 00                	push   $0x0
  pushl $15
c0102a86:	6a 0f                	push   $0xf
  jmp __alltraps
c0102a88:	e9 53 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a8d <vector16>:
.globl vector16
vector16:
  pushl $0
c0102a8d:	6a 00                	push   $0x0
  pushl $16
c0102a8f:	6a 10                	push   $0x10
  jmp __alltraps
c0102a91:	e9 4a ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a96 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102a96:	6a 11                	push   $0x11
  jmp __alltraps
c0102a98:	e9 43 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102a9d <vector18>:
.globl vector18
vector18:
  pushl $0
c0102a9d:	6a 00                	push   $0x0
  pushl $18
c0102a9f:	6a 12                	push   $0x12
  jmp __alltraps
c0102aa1:	e9 3a ff ff ff       	jmp    c01029e0 <__alltraps>

c0102aa6 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102aa6:	6a 00                	push   $0x0
  pushl $19
c0102aa8:	6a 13                	push   $0x13
  jmp __alltraps
c0102aaa:	e9 31 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102aaf <vector20>:
.globl vector20
vector20:
  pushl $0
c0102aaf:	6a 00                	push   $0x0
  pushl $20
c0102ab1:	6a 14                	push   $0x14
  jmp __alltraps
c0102ab3:	e9 28 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102ab8 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102ab8:	6a 00                	push   $0x0
  pushl $21
c0102aba:	6a 15                	push   $0x15
  jmp __alltraps
c0102abc:	e9 1f ff ff ff       	jmp    c01029e0 <__alltraps>

c0102ac1 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102ac1:	6a 00                	push   $0x0
  pushl $22
c0102ac3:	6a 16                	push   $0x16
  jmp __alltraps
c0102ac5:	e9 16 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102aca <vector23>:
.globl vector23
vector23:
  pushl $0
c0102aca:	6a 00                	push   $0x0
  pushl $23
c0102acc:	6a 17                	push   $0x17
  jmp __alltraps
c0102ace:	e9 0d ff ff ff       	jmp    c01029e0 <__alltraps>

c0102ad3 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102ad3:	6a 00                	push   $0x0
  pushl $24
c0102ad5:	6a 18                	push   $0x18
  jmp __alltraps
c0102ad7:	e9 04 ff ff ff       	jmp    c01029e0 <__alltraps>

c0102adc <vector25>:
.globl vector25
vector25:
  pushl $0
c0102adc:	6a 00                	push   $0x0
  pushl $25
c0102ade:	6a 19                	push   $0x19
  jmp __alltraps
c0102ae0:	e9 fb fe ff ff       	jmp    c01029e0 <__alltraps>

c0102ae5 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102ae5:	6a 00                	push   $0x0
  pushl $26
c0102ae7:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102ae9:	e9 f2 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102aee <vector27>:
.globl vector27
vector27:
  pushl $0
c0102aee:	6a 00                	push   $0x0
  pushl $27
c0102af0:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102af2:	e9 e9 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102af7 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102af7:	6a 00                	push   $0x0
  pushl $28
c0102af9:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102afb:	e9 e0 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b00 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102b00:	6a 00                	push   $0x0
  pushl $29
c0102b02:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102b04:	e9 d7 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b09 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102b09:	6a 00                	push   $0x0
  pushl $30
c0102b0b:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102b0d:	e9 ce fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b12 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102b12:	6a 00                	push   $0x0
  pushl $31
c0102b14:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102b16:	e9 c5 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b1b <vector32>:
.globl vector32
vector32:
  pushl $0
c0102b1b:	6a 00                	push   $0x0
  pushl $32
c0102b1d:	6a 20                	push   $0x20
  jmp __alltraps
c0102b1f:	e9 bc fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b24 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102b24:	6a 00                	push   $0x0
  pushl $33
c0102b26:	6a 21                	push   $0x21
  jmp __alltraps
c0102b28:	e9 b3 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b2d <vector34>:
.globl vector34
vector34:
  pushl $0
c0102b2d:	6a 00                	push   $0x0
  pushl $34
c0102b2f:	6a 22                	push   $0x22
  jmp __alltraps
c0102b31:	e9 aa fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b36 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102b36:	6a 00                	push   $0x0
  pushl $35
c0102b38:	6a 23                	push   $0x23
  jmp __alltraps
c0102b3a:	e9 a1 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b3f <vector36>:
.globl vector36
vector36:
  pushl $0
c0102b3f:	6a 00                	push   $0x0
  pushl $36
c0102b41:	6a 24                	push   $0x24
  jmp __alltraps
c0102b43:	e9 98 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b48 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102b48:	6a 00                	push   $0x0
  pushl $37
c0102b4a:	6a 25                	push   $0x25
  jmp __alltraps
c0102b4c:	e9 8f fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b51 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102b51:	6a 00                	push   $0x0
  pushl $38
c0102b53:	6a 26                	push   $0x26
  jmp __alltraps
c0102b55:	e9 86 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b5a <vector39>:
.globl vector39
vector39:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $39
c0102b5c:	6a 27                	push   $0x27
  jmp __alltraps
c0102b5e:	e9 7d fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b63 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102b63:	6a 00                	push   $0x0
  pushl $40
c0102b65:	6a 28                	push   $0x28
  jmp __alltraps
c0102b67:	e9 74 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b6c <vector41>:
.globl vector41
vector41:
  pushl $0
c0102b6c:	6a 00                	push   $0x0
  pushl $41
c0102b6e:	6a 29                	push   $0x29
  jmp __alltraps
c0102b70:	e9 6b fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b75 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102b75:	6a 00                	push   $0x0
  pushl $42
c0102b77:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102b79:	e9 62 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b7e <vector43>:
.globl vector43
vector43:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $43
c0102b80:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102b82:	e9 59 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b87 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102b87:	6a 00                	push   $0x0
  pushl $44
c0102b89:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102b8b:	e9 50 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b90 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102b90:	6a 00                	push   $0x0
  pushl $45
c0102b92:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102b94:	e9 47 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102b99 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102b99:	6a 00                	push   $0x0
  pushl $46
c0102b9b:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102b9d:	e9 3e fe ff ff       	jmp    c01029e0 <__alltraps>

c0102ba2 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102ba2:	6a 00                	push   $0x0
  pushl $47
c0102ba4:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102ba6:	e9 35 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bab <vector48>:
.globl vector48
vector48:
  pushl $0
c0102bab:	6a 00                	push   $0x0
  pushl $48
c0102bad:	6a 30                	push   $0x30
  jmp __alltraps
c0102baf:	e9 2c fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bb4 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102bb4:	6a 00                	push   $0x0
  pushl $49
c0102bb6:	6a 31                	push   $0x31
  jmp __alltraps
c0102bb8:	e9 23 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bbd <vector50>:
.globl vector50
vector50:
  pushl $0
c0102bbd:	6a 00                	push   $0x0
  pushl $50
c0102bbf:	6a 32                	push   $0x32
  jmp __alltraps
c0102bc1:	e9 1a fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bc6 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102bc6:	6a 00                	push   $0x0
  pushl $51
c0102bc8:	6a 33                	push   $0x33
  jmp __alltraps
c0102bca:	e9 11 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bcf <vector52>:
.globl vector52
vector52:
  pushl $0
c0102bcf:	6a 00                	push   $0x0
  pushl $52
c0102bd1:	6a 34                	push   $0x34
  jmp __alltraps
c0102bd3:	e9 08 fe ff ff       	jmp    c01029e0 <__alltraps>

c0102bd8 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102bd8:	6a 00                	push   $0x0
  pushl $53
c0102bda:	6a 35                	push   $0x35
  jmp __alltraps
c0102bdc:	e9 ff fd ff ff       	jmp    c01029e0 <__alltraps>

c0102be1 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102be1:	6a 00                	push   $0x0
  pushl $54
c0102be3:	6a 36                	push   $0x36
  jmp __alltraps
c0102be5:	e9 f6 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102bea <vector55>:
.globl vector55
vector55:
  pushl $0
c0102bea:	6a 00                	push   $0x0
  pushl $55
c0102bec:	6a 37                	push   $0x37
  jmp __alltraps
c0102bee:	e9 ed fd ff ff       	jmp    c01029e0 <__alltraps>

c0102bf3 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102bf3:	6a 00                	push   $0x0
  pushl $56
c0102bf5:	6a 38                	push   $0x38
  jmp __alltraps
c0102bf7:	e9 e4 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102bfc <vector57>:
.globl vector57
vector57:
  pushl $0
c0102bfc:	6a 00                	push   $0x0
  pushl $57
c0102bfe:	6a 39                	push   $0x39
  jmp __alltraps
c0102c00:	e9 db fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c05 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102c05:	6a 00                	push   $0x0
  pushl $58
c0102c07:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102c09:	e9 d2 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c0e <vector59>:
.globl vector59
vector59:
  pushl $0
c0102c0e:	6a 00                	push   $0x0
  pushl $59
c0102c10:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102c12:	e9 c9 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c17 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102c17:	6a 00                	push   $0x0
  pushl $60
c0102c19:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102c1b:	e9 c0 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c20 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102c20:	6a 00                	push   $0x0
  pushl $61
c0102c22:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102c24:	e9 b7 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c29 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102c29:	6a 00                	push   $0x0
  pushl $62
c0102c2b:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102c2d:	e9 ae fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c32 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102c32:	6a 00                	push   $0x0
  pushl $63
c0102c34:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102c36:	e9 a5 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c3b <vector64>:
.globl vector64
vector64:
  pushl $0
c0102c3b:	6a 00                	push   $0x0
  pushl $64
c0102c3d:	6a 40                	push   $0x40
  jmp __alltraps
c0102c3f:	e9 9c fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c44 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102c44:	6a 00                	push   $0x0
  pushl $65
c0102c46:	6a 41                	push   $0x41
  jmp __alltraps
c0102c48:	e9 93 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c4d <vector66>:
.globl vector66
vector66:
  pushl $0
c0102c4d:	6a 00                	push   $0x0
  pushl $66
c0102c4f:	6a 42                	push   $0x42
  jmp __alltraps
c0102c51:	e9 8a fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c56 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102c56:	6a 00                	push   $0x0
  pushl $67
c0102c58:	6a 43                	push   $0x43
  jmp __alltraps
c0102c5a:	e9 81 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c5f <vector68>:
.globl vector68
vector68:
  pushl $0
c0102c5f:	6a 00                	push   $0x0
  pushl $68
c0102c61:	6a 44                	push   $0x44
  jmp __alltraps
c0102c63:	e9 78 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c68 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102c68:	6a 00                	push   $0x0
  pushl $69
c0102c6a:	6a 45                	push   $0x45
  jmp __alltraps
c0102c6c:	e9 6f fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c71 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102c71:	6a 00                	push   $0x0
  pushl $70
c0102c73:	6a 46                	push   $0x46
  jmp __alltraps
c0102c75:	e9 66 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c7a <vector71>:
.globl vector71
vector71:
  pushl $0
c0102c7a:	6a 00                	push   $0x0
  pushl $71
c0102c7c:	6a 47                	push   $0x47
  jmp __alltraps
c0102c7e:	e9 5d fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c83 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102c83:	6a 00                	push   $0x0
  pushl $72
c0102c85:	6a 48                	push   $0x48
  jmp __alltraps
c0102c87:	e9 54 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c8c <vector73>:
.globl vector73
vector73:
  pushl $0
c0102c8c:	6a 00                	push   $0x0
  pushl $73
c0102c8e:	6a 49                	push   $0x49
  jmp __alltraps
c0102c90:	e9 4b fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c95 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102c95:	6a 00                	push   $0x0
  pushl $74
c0102c97:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102c99:	e9 42 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102c9e <vector75>:
.globl vector75
vector75:
  pushl $0
c0102c9e:	6a 00                	push   $0x0
  pushl $75
c0102ca0:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ca2:	e9 39 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102ca7 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102ca7:	6a 00                	push   $0x0
  pushl $76
c0102ca9:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102cab:	e9 30 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102cb0 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102cb0:	6a 00                	push   $0x0
  pushl $77
c0102cb2:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102cb4:	e9 27 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102cb9 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102cb9:	6a 00                	push   $0x0
  pushl $78
c0102cbb:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102cbd:	e9 1e fd ff ff       	jmp    c01029e0 <__alltraps>

c0102cc2 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102cc2:	6a 00                	push   $0x0
  pushl $79
c0102cc4:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102cc6:	e9 15 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102ccb <vector80>:
.globl vector80
vector80:
  pushl $0
c0102ccb:	6a 00                	push   $0x0
  pushl $80
c0102ccd:	6a 50                	push   $0x50
  jmp __alltraps
c0102ccf:	e9 0c fd ff ff       	jmp    c01029e0 <__alltraps>

c0102cd4 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102cd4:	6a 00                	push   $0x0
  pushl $81
c0102cd6:	6a 51                	push   $0x51
  jmp __alltraps
c0102cd8:	e9 03 fd ff ff       	jmp    c01029e0 <__alltraps>

c0102cdd <vector82>:
.globl vector82
vector82:
  pushl $0
c0102cdd:	6a 00                	push   $0x0
  pushl $82
c0102cdf:	6a 52                	push   $0x52
  jmp __alltraps
c0102ce1:	e9 fa fc ff ff       	jmp    c01029e0 <__alltraps>

c0102ce6 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102ce6:	6a 00                	push   $0x0
  pushl $83
c0102ce8:	6a 53                	push   $0x53
  jmp __alltraps
c0102cea:	e9 f1 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102cef <vector84>:
.globl vector84
vector84:
  pushl $0
c0102cef:	6a 00                	push   $0x0
  pushl $84
c0102cf1:	6a 54                	push   $0x54
  jmp __alltraps
c0102cf3:	e9 e8 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102cf8 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102cf8:	6a 00                	push   $0x0
  pushl $85
c0102cfa:	6a 55                	push   $0x55
  jmp __alltraps
c0102cfc:	e9 df fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d01 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102d01:	6a 00                	push   $0x0
  pushl $86
c0102d03:	6a 56                	push   $0x56
  jmp __alltraps
c0102d05:	e9 d6 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d0a <vector87>:
.globl vector87
vector87:
  pushl $0
c0102d0a:	6a 00                	push   $0x0
  pushl $87
c0102d0c:	6a 57                	push   $0x57
  jmp __alltraps
c0102d0e:	e9 cd fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d13 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102d13:	6a 00                	push   $0x0
  pushl $88
c0102d15:	6a 58                	push   $0x58
  jmp __alltraps
c0102d17:	e9 c4 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d1c <vector89>:
.globl vector89
vector89:
  pushl $0
c0102d1c:	6a 00                	push   $0x0
  pushl $89
c0102d1e:	6a 59                	push   $0x59
  jmp __alltraps
c0102d20:	e9 bb fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d25 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102d25:	6a 00                	push   $0x0
  pushl $90
c0102d27:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102d29:	e9 b2 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d2e <vector91>:
.globl vector91
vector91:
  pushl $0
c0102d2e:	6a 00                	push   $0x0
  pushl $91
c0102d30:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102d32:	e9 a9 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d37 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102d37:	6a 00                	push   $0x0
  pushl $92
c0102d39:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102d3b:	e9 a0 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d40 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102d40:	6a 00                	push   $0x0
  pushl $93
c0102d42:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102d44:	e9 97 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d49 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102d49:	6a 00                	push   $0x0
  pushl $94
c0102d4b:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102d4d:	e9 8e fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d52 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102d52:	6a 00                	push   $0x0
  pushl $95
c0102d54:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102d56:	e9 85 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d5b <vector96>:
.globl vector96
vector96:
  pushl $0
c0102d5b:	6a 00                	push   $0x0
  pushl $96
c0102d5d:	6a 60                	push   $0x60
  jmp __alltraps
c0102d5f:	e9 7c fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d64 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102d64:	6a 00                	push   $0x0
  pushl $97
c0102d66:	6a 61                	push   $0x61
  jmp __alltraps
c0102d68:	e9 73 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d6d <vector98>:
.globl vector98
vector98:
  pushl $0
c0102d6d:	6a 00                	push   $0x0
  pushl $98
c0102d6f:	6a 62                	push   $0x62
  jmp __alltraps
c0102d71:	e9 6a fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d76 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102d76:	6a 00                	push   $0x0
  pushl $99
c0102d78:	6a 63                	push   $0x63
  jmp __alltraps
c0102d7a:	e9 61 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d7f <vector100>:
.globl vector100
vector100:
  pushl $0
c0102d7f:	6a 00                	push   $0x0
  pushl $100
c0102d81:	6a 64                	push   $0x64
  jmp __alltraps
c0102d83:	e9 58 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d88 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102d88:	6a 00                	push   $0x0
  pushl $101
c0102d8a:	6a 65                	push   $0x65
  jmp __alltraps
c0102d8c:	e9 4f fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d91 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102d91:	6a 00                	push   $0x0
  pushl $102
c0102d93:	6a 66                	push   $0x66
  jmp __alltraps
c0102d95:	e9 46 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102d9a <vector103>:
.globl vector103
vector103:
  pushl $0
c0102d9a:	6a 00                	push   $0x0
  pushl $103
c0102d9c:	6a 67                	push   $0x67
  jmp __alltraps
c0102d9e:	e9 3d fc ff ff       	jmp    c01029e0 <__alltraps>

c0102da3 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102da3:	6a 00                	push   $0x0
  pushl $104
c0102da5:	6a 68                	push   $0x68
  jmp __alltraps
c0102da7:	e9 34 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102dac <vector105>:
.globl vector105
vector105:
  pushl $0
c0102dac:	6a 00                	push   $0x0
  pushl $105
c0102dae:	6a 69                	push   $0x69
  jmp __alltraps
c0102db0:	e9 2b fc ff ff       	jmp    c01029e0 <__alltraps>

c0102db5 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102db5:	6a 00                	push   $0x0
  pushl $106
c0102db7:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102db9:	e9 22 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102dbe <vector107>:
.globl vector107
vector107:
  pushl $0
c0102dbe:	6a 00                	push   $0x0
  pushl $107
c0102dc0:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102dc2:	e9 19 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102dc7 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102dc7:	6a 00                	push   $0x0
  pushl $108
c0102dc9:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102dcb:	e9 10 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102dd0 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102dd0:	6a 00                	push   $0x0
  pushl $109
c0102dd2:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102dd4:	e9 07 fc ff ff       	jmp    c01029e0 <__alltraps>

c0102dd9 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102dd9:	6a 00                	push   $0x0
  pushl $110
c0102ddb:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102ddd:	e9 fe fb ff ff       	jmp    c01029e0 <__alltraps>

c0102de2 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102de2:	6a 00                	push   $0x0
  pushl $111
c0102de4:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102de6:	e9 f5 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102deb <vector112>:
.globl vector112
vector112:
  pushl $0
c0102deb:	6a 00                	push   $0x0
  pushl $112
c0102ded:	6a 70                	push   $0x70
  jmp __alltraps
c0102def:	e9 ec fb ff ff       	jmp    c01029e0 <__alltraps>

c0102df4 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102df4:	6a 00                	push   $0x0
  pushl $113
c0102df6:	6a 71                	push   $0x71
  jmp __alltraps
c0102df8:	e9 e3 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102dfd <vector114>:
.globl vector114
vector114:
  pushl $0
c0102dfd:	6a 00                	push   $0x0
  pushl $114
c0102dff:	6a 72                	push   $0x72
  jmp __alltraps
c0102e01:	e9 da fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e06 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102e06:	6a 00                	push   $0x0
  pushl $115
c0102e08:	6a 73                	push   $0x73
  jmp __alltraps
c0102e0a:	e9 d1 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e0f <vector116>:
.globl vector116
vector116:
  pushl $0
c0102e0f:	6a 00                	push   $0x0
  pushl $116
c0102e11:	6a 74                	push   $0x74
  jmp __alltraps
c0102e13:	e9 c8 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e18 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102e18:	6a 00                	push   $0x0
  pushl $117
c0102e1a:	6a 75                	push   $0x75
  jmp __alltraps
c0102e1c:	e9 bf fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e21 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102e21:	6a 00                	push   $0x0
  pushl $118
c0102e23:	6a 76                	push   $0x76
  jmp __alltraps
c0102e25:	e9 b6 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e2a <vector119>:
.globl vector119
vector119:
  pushl $0
c0102e2a:	6a 00                	push   $0x0
  pushl $119
c0102e2c:	6a 77                	push   $0x77
  jmp __alltraps
c0102e2e:	e9 ad fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e33 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102e33:	6a 00                	push   $0x0
  pushl $120
c0102e35:	6a 78                	push   $0x78
  jmp __alltraps
c0102e37:	e9 a4 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e3c <vector121>:
.globl vector121
vector121:
  pushl $0
c0102e3c:	6a 00                	push   $0x0
  pushl $121
c0102e3e:	6a 79                	push   $0x79
  jmp __alltraps
c0102e40:	e9 9b fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e45 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102e45:	6a 00                	push   $0x0
  pushl $122
c0102e47:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102e49:	e9 92 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e4e <vector123>:
.globl vector123
vector123:
  pushl $0
c0102e4e:	6a 00                	push   $0x0
  pushl $123
c0102e50:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102e52:	e9 89 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e57 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102e57:	6a 00                	push   $0x0
  pushl $124
c0102e59:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102e5b:	e9 80 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e60 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102e60:	6a 00                	push   $0x0
  pushl $125
c0102e62:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102e64:	e9 77 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e69 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102e69:	6a 00                	push   $0x0
  pushl $126
c0102e6b:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102e6d:	e9 6e fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e72 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102e72:	6a 00                	push   $0x0
  pushl $127
c0102e74:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102e76:	e9 65 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e7b <vector128>:
.globl vector128
vector128:
  pushl $0
c0102e7b:	6a 00                	push   $0x0
  pushl $128
c0102e7d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102e82:	e9 59 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e87 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102e87:	6a 00                	push   $0x0
  pushl $129
c0102e89:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102e8e:	e9 4d fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e93 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102e93:	6a 00                	push   $0x0
  pushl $130
c0102e95:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102e9a:	e9 41 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102e9f <vector131>:
.globl vector131
vector131:
  pushl $0
c0102e9f:	6a 00                	push   $0x0
  pushl $131
c0102ea1:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102ea6:	e9 35 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102eab <vector132>:
.globl vector132
vector132:
  pushl $0
c0102eab:	6a 00                	push   $0x0
  pushl $132
c0102ead:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102eb2:	e9 29 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102eb7 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102eb7:	6a 00                	push   $0x0
  pushl $133
c0102eb9:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ebe:	e9 1d fb ff ff       	jmp    c01029e0 <__alltraps>

c0102ec3 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102ec3:	6a 00                	push   $0x0
  pushl $134
c0102ec5:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102eca:	e9 11 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102ecf <vector135>:
.globl vector135
vector135:
  pushl $0
c0102ecf:	6a 00                	push   $0x0
  pushl $135
c0102ed1:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102ed6:	e9 05 fb ff ff       	jmp    c01029e0 <__alltraps>

c0102edb <vector136>:
.globl vector136
vector136:
  pushl $0
c0102edb:	6a 00                	push   $0x0
  pushl $136
c0102edd:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102ee2:	e9 f9 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102ee7 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102ee7:	6a 00                	push   $0x0
  pushl $137
c0102ee9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102eee:	e9 ed fa ff ff       	jmp    c01029e0 <__alltraps>

c0102ef3 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102ef3:	6a 00                	push   $0x0
  pushl $138
c0102ef5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102efa:	e9 e1 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102eff <vector139>:
.globl vector139
vector139:
  pushl $0
c0102eff:	6a 00                	push   $0x0
  pushl $139
c0102f01:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102f06:	e9 d5 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f0b <vector140>:
.globl vector140
vector140:
  pushl $0
c0102f0b:	6a 00                	push   $0x0
  pushl $140
c0102f0d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102f12:	e9 c9 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f17 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102f17:	6a 00                	push   $0x0
  pushl $141
c0102f19:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102f1e:	e9 bd fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f23 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102f23:	6a 00                	push   $0x0
  pushl $142
c0102f25:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102f2a:	e9 b1 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f2f <vector143>:
.globl vector143
vector143:
  pushl $0
c0102f2f:	6a 00                	push   $0x0
  pushl $143
c0102f31:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102f36:	e9 a5 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f3b <vector144>:
.globl vector144
vector144:
  pushl $0
c0102f3b:	6a 00                	push   $0x0
  pushl $144
c0102f3d:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102f42:	e9 99 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f47 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102f47:	6a 00                	push   $0x0
  pushl $145
c0102f49:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102f4e:	e9 8d fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f53 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102f53:	6a 00                	push   $0x0
  pushl $146
c0102f55:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102f5a:	e9 81 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f5f <vector147>:
.globl vector147
vector147:
  pushl $0
c0102f5f:	6a 00                	push   $0x0
  pushl $147
c0102f61:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102f66:	e9 75 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f6b <vector148>:
.globl vector148
vector148:
  pushl $0
c0102f6b:	6a 00                	push   $0x0
  pushl $148
c0102f6d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102f72:	e9 69 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f77 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102f77:	6a 00                	push   $0x0
  pushl $149
c0102f79:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102f7e:	e9 5d fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f83 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102f83:	6a 00                	push   $0x0
  pushl $150
c0102f85:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102f8a:	e9 51 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f8f <vector151>:
.globl vector151
vector151:
  pushl $0
c0102f8f:	6a 00                	push   $0x0
  pushl $151
c0102f91:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102f96:	e9 45 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102f9b <vector152>:
.globl vector152
vector152:
  pushl $0
c0102f9b:	6a 00                	push   $0x0
  pushl $152
c0102f9d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102fa2:	e9 39 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102fa7 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102fa7:	6a 00                	push   $0x0
  pushl $153
c0102fa9:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102fae:	e9 2d fa ff ff       	jmp    c01029e0 <__alltraps>

c0102fb3 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102fb3:	6a 00                	push   $0x0
  pushl $154
c0102fb5:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102fba:	e9 21 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102fbf <vector155>:
.globl vector155
vector155:
  pushl $0
c0102fbf:	6a 00                	push   $0x0
  pushl $155
c0102fc1:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102fc6:	e9 15 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102fcb <vector156>:
.globl vector156
vector156:
  pushl $0
c0102fcb:	6a 00                	push   $0x0
  pushl $156
c0102fcd:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102fd2:	e9 09 fa ff ff       	jmp    c01029e0 <__alltraps>

c0102fd7 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102fd7:	6a 00                	push   $0x0
  pushl $157
c0102fd9:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102fde:	e9 fd f9 ff ff       	jmp    c01029e0 <__alltraps>

c0102fe3 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102fe3:	6a 00                	push   $0x0
  pushl $158
c0102fe5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102fea:	e9 f1 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0102fef <vector159>:
.globl vector159
vector159:
  pushl $0
c0102fef:	6a 00                	push   $0x0
  pushl $159
c0102ff1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102ff6:	e9 e5 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0102ffb <vector160>:
.globl vector160
vector160:
  pushl $0
c0102ffb:	6a 00                	push   $0x0
  pushl $160
c0102ffd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0103002:	e9 d9 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103007 <vector161>:
.globl vector161
vector161:
  pushl $0
c0103007:	6a 00                	push   $0x0
  pushl $161
c0103009:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010300e:	e9 cd f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103013 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103013:	6a 00                	push   $0x0
  pushl $162
c0103015:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010301a:	e9 c1 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010301f <vector163>:
.globl vector163
vector163:
  pushl $0
c010301f:	6a 00                	push   $0x0
  pushl $163
c0103021:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0103026:	e9 b5 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010302b <vector164>:
.globl vector164
vector164:
  pushl $0
c010302b:	6a 00                	push   $0x0
  pushl $164
c010302d:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0103032:	e9 a9 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103037 <vector165>:
.globl vector165
vector165:
  pushl $0
c0103037:	6a 00                	push   $0x0
  pushl $165
c0103039:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010303e:	e9 9d f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103043 <vector166>:
.globl vector166
vector166:
  pushl $0
c0103043:	6a 00                	push   $0x0
  pushl $166
c0103045:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010304a:	e9 91 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010304f <vector167>:
.globl vector167
vector167:
  pushl $0
c010304f:	6a 00                	push   $0x0
  pushl $167
c0103051:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0103056:	e9 85 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010305b <vector168>:
.globl vector168
vector168:
  pushl $0
c010305b:	6a 00                	push   $0x0
  pushl $168
c010305d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0103062:	e9 79 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103067 <vector169>:
.globl vector169
vector169:
  pushl $0
c0103067:	6a 00                	push   $0x0
  pushl $169
c0103069:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010306e:	e9 6d f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103073 <vector170>:
.globl vector170
vector170:
  pushl $0
c0103073:	6a 00                	push   $0x0
  pushl $170
c0103075:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010307a:	e9 61 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010307f <vector171>:
.globl vector171
vector171:
  pushl $0
c010307f:	6a 00                	push   $0x0
  pushl $171
c0103081:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0103086:	e9 55 f9 ff ff       	jmp    c01029e0 <__alltraps>

c010308b <vector172>:
.globl vector172
vector172:
  pushl $0
c010308b:	6a 00                	push   $0x0
  pushl $172
c010308d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0103092:	e9 49 f9 ff ff       	jmp    c01029e0 <__alltraps>

c0103097 <vector173>:
.globl vector173
vector173:
  pushl $0
c0103097:	6a 00                	push   $0x0
  pushl $173
c0103099:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010309e:	e9 3d f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030a3 <vector174>:
.globl vector174
vector174:
  pushl $0
c01030a3:	6a 00                	push   $0x0
  pushl $174
c01030a5:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01030aa:	e9 31 f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030af <vector175>:
.globl vector175
vector175:
  pushl $0
c01030af:	6a 00                	push   $0x0
  pushl $175
c01030b1:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01030b6:	e9 25 f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030bb <vector176>:
.globl vector176
vector176:
  pushl $0
c01030bb:	6a 00                	push   $0x0
  pushl $176
c01030bd:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01030c2:	e9 19 f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030c7 <vector177>:
.globl vector177
vector177:
  pushl $0
c01030c7:	6a 00                	push   $0x0
  pushl $177
c01030c9:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01030ce:	e9 0d f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030d3 <vector178>:
.globl vector178
vector178:
  pushl $0
c01030d3:	6a 00                	push   $0x0
  pushl $178
c01030d5:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01030da:	e9 01 f9 ff ff       	jmp    c01029e0 <__alltraps>

c01030df <vector179>:
.globl vector179
vector179:
  pushl $0
c01030df:	6a 00                	push   $0x0
  pushl $179
c01030e1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01030e6:	e9 f5 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01030eb <vector180>:
.globl vector180
vector180:
  pushl $0
c01030eb:	6a 00                	push   $0x0
  pushl $180
c01030ed:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01030f2:	e9 e9 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01030f7 <vector181>:
.globl vector181
vector181:
  pushl $0
c01030f7:	6a 00                	push   $0x0
  pushl $181
c01030f9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01030fe:	e9 dd f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103103 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103103:	6a 00                	push   $0x0
  pushl $182
c0103105:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010310a:	e9 d1 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010310f <vector183>:
.globl vector183
vector183:
  pushl $0
c010310f:	6a 00                	push   $0x0
  pushl $183
c0103111:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103116:	e9 c5 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010311b <vector184>:
.globl vector184
vector184:
  pushl $0
c010311b:	6a 00                	push   $0x0
  pushl $184
c010311d:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0103122:	e9 b9 f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103127 <vector185>:
.globl vector185
vector185:
  pushl $0
c0103127:	6a 00                	push   $0x0
  pushl $185
c0103129:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010312e:	e9 ad f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103133 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103133:	6a 00                	push   $0x0
  pushl $186
c0103135:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010313a:	e9 a1 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010313f <vector187>:
.globl vector187
vector187:
  pushl $0
c010313f:	6a 00                	push   $0x0
  pushl $187
c0103141:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0103146:	e9 95 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010314b <vector188>:
.globl vector188
vector188:
  pushl $0
c010314b:	6a 00                	push   $0x0
  pushl $188
c010314d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0103152:	e9 89 f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103157 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103157:	6a 00                	push   $0x0
  pushl $189
c0103159:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010315e:	e9 7d f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103163 <vector190>:
.globl vector190
vector190:
  pushl $0
c0103163:	6a 00                	push   $0x0
  pushl $190
c0103165:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010316a:	e9 71 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010316f <vector191>:
.globl vector191
vector191:
  pushl $0
c010316f:	6a 00                	push   $0x0
  pushl $191
c0103171:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0103176:	e9 65 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010317b <vector192>:
.globl vector192
vector192:
  pushl $0
c010317b:	6a 00                	push   $0x0
  pushl $192
c010317d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0103182:	e9 59 f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103187 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103187:	6a 00                	push   $0x0
  pushl $193
c0103189:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010318e:	e9 4d f8 ff ff       	jmp    c01029e0 <__alltraps>

c0103193 <vector194>:
.globl vector194
vector194:
  pushl $0
c0103193:	6a 00                	push   $0x0
  pushl $194
c0103195:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010319a:	e9 41 f8 ff ff       	jmp    c01029e0 <__alltraps>

c010319f <vector195>:
.globl vector195
vector195:
  pushl $0
c010319f:	6a 00                	push   $0x0
  pushl $195
c01031a1:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01031a6:	e9 35 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01031ab <vector196>:
.globl vector196
vector196:
  pushl $0
c01031ab:	6a 00                	push   $0x0
  pushl $196
c01031ad:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01031b2:	e9 29 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01031b7 <vector197>:
.globl vector197
vector197:
  pushl $0
c01031b7:	6a 00                	push   $0x0
  pushl $197
c01031b9:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01031be:	e9 1d f8 ff ff       	jmp    c01029e0 <__alltraps>

c01031c3 <vector198>:
.globl vector198
vector198:
  pushl $0
c01031c3:	6a 00                	push   $0x0
  pushl $198
c01031c5:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01031ca:	e9 11 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01031cf <vector199>:
.globl vector199
vector199:
  pushl $0
c01031cf:	6a 00                	push   $0x0
  pushl $199
c01031d1:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01031d6:	e9 05 f8 ff ff       	jmp    c01029e0 <__alltraps>

c01031db <vector200>:
.globl vector200
vector200:
  pushl $0
c01031db:	6a 00                	push   $0x0
  pushl $200
c01031dd:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01031e2:	e9 f9 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01031e7 <vector201>:
.globl vector201
vector201:
  pushl $0
c01031e7:	6a 00                	push   $0x0
  pushl $201
c01031e9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01031ee:	e9 ed f7 ff ff       	jmp    c01029e0 <__alltraps>

c01031f3 <vector202>:
.globl vector202
vector202:
  pushl $0
c01031f3:	6a 00                	push   $0x0
  pushl $202
c01031f5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01031fa:	e9 e1 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01031ff <vector203>:
.globl vector203
vector203:
  pushl $0
c01031ff:	6a 00                	push   $0x0
  pushl $203
c0103201:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103206:	e9 d5 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010320b <vector204>:
.globl vector204
vector204:
  pushl $0
c010320b:	6a 00                	push   $0x0
  pushl $204
c010320d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0103212:	e9 c9 f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103217 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103217:	6a 00                	push   $0x0
  pushl $205
c0103219:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010321e:	e9 bd f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103223 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103223:	6a 00                	push   $0x0
  pushl $206
c0103225:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010322a:	e9 b1 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010322f <vector207>:
.globl vector207
vector207:
  pushl $0
c010322f:	6a 00                	push   $0x0
  pushl $207
c0103231:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103236:	e9 a5 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010323b <vector208>:
.globl vector208
vector208:
  pushl $0
c010323b:	6a 00                	push   $0x0
  pushl $208
c010323d:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0103242:	e9 99 f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103247 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103247:	6a 00                	push   $0x0
  pushl $209
c0103249:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010324e:	e9 8d f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103253 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103253:	6a 00                	push   $0x0
  pushl $210
c0103255:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010325a:	e9 81 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010325f <vector211>:
.globl vector211
vector211:
  pushl $0
c010325f:	6a 00                	push   $0x0
  pushl $211
c0103261:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0103266:	e9 75 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010326b <vector212>:
.globl vector212
vector212:
  pushl $0
c010326b:	6a 00                	push   $0x0
  pushl $212
c010326d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0103272:	e9 69 f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103277 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103277:	6a 00                	push   $0x0
  pushl $213
c0103279:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010327e:	e9 5d f7 ff ff       	jmp    c01029e0 <__alltraps>

c0103283 <vector214>:
.globl vector214
vector214:
  pushl $0
c0103283:	6a 00                	push   $0x0
  pushl $214
c0103285:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010328a:	e9 51 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010328f <vector215>:
.globl vector215
vector215:
  pushl $0
c010328f:	6a 00                	push   $0x0
  pushl $215
c0103291:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0103296:	e9 45 f7 ff ff       	jmp    c01029e0 <__alltraps>

c010329b <vector216>:
.globl vector216
vector216:
  pushl $0
c010329b:	6a 00                	push   $0x0
  pushl $216
c010329d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01032a2:	e9 39 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01032a7 <vector217>:
.globl vector217
vector217:
  pushl $0
c01032a7:	6a 00                	push   $0x0
  pushl $217
c01032a9:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01032ae:	e9 2d f7 ff ff       	jmp    c01029e0 <__alltraps>

c01032b3 <vector218>:
.globl vector218
vector218:
  pushl $0
c01032b3:	6a 00                	push   $0x0
  pushl $218
c01032b5:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01032ba:	e9 21 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01032bf <vector219>:
.globl vector219
vector219:
  pushl $0
c01032bf:	6a 00                	push   $0x0
  pushl $219
c01032c1:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01032c6:	e9 15 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01032cb <vector220>:
.globl vector220
vector220:
  pushl $0
c01032cb:	6a 00                	push   $0x0
  pushl $220
c01032cd:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01032d2:	e9 09 f7 ff ff       	jmp    c01029e0 <__alltraps>

c01032d7 <vector221>:
.globl vector221
vector221:
  pushl $0
c01032d7:	6a 00                	push   $0x0
  pushl $221
c01032d9:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01032de:	e9 fd f6 ff ff       	jmp    c01029e0 <__alltraps>

c01032e3 <vector222>:
.globl vector222
vector222:
  pushl $0
c01032e3:	6a 00                	push   $0x0
  pushl $222
c01032e5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01032ea:	e9 f1 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01032ef <vector223>:
.globl vector223
vector223:
  pushl $0
c01032ef:	6a 00                	push   $0x0
  pushl $223
c01032f1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01032f6:	e9 e5 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01032fb <vector224>:
.globl vector224
vector224:
  pushl $0
c01032fb:	6a 00                	push   $0x0
  pushl $224
c01032fd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103302:	e9 d9 f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103307 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103307:	6a 00                	push   $0x0
  pushl $225
c0103309:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010330e:	e9 cd f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103313 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103313:	6a 00                	push   $0x0
  pushl $226
c0103315:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010331a:	e9 c1 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010331f <vector227>:
.globl vector227
vector227:
  pushl $0
c010331f:	6a 00                	push   $0x0
  pushl $227
c0103321:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103326:	e9 b5 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010332b <vector228>:
.globl vector228
vector228:
  pushl $0
c010332b:	6a 00                	push   $0x0
  pushl $228
c010332d:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103332:	e9 a9 f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103337 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103337:	6a 00                	push   $0x0
  pushl $229
c0103339:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010333e:	e9 9d f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103343 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103343:	6a 00                	push   $0x0
  pushl $230
c0103345:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010334a:	e9 91 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010334f <vector231>:
.globl vector231
vector231:
  pushl $0
c010334f:	6a 00                	push   $0x0
  pushl $231
c0103351:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103356:	e9 85 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010335b <vector232>:
.globl vector232
vector232:
  pushl $0
c010335b:	6a 00                	push   $0x0
  pushl $232
c010335d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0103362:	e9 79 f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103367 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103367:	6a 00                	push   $0x0
  pushl $233
c0103369:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010336e:	e9 6d f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103373 <vector234>:
.globl vector234
vector234:
  pushl $0
c0103373:	6a 00                	push   $0x0
  pushl $234
c0103375:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010337a:	e9 61 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010337f <vector235>:
.globl vector235
vector235:
  pushl $0
c010337f:	6a 00                	push   $0x0
  pushl $235
c0103381:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0103386:	e9 55 f6 ff ff       	jmp    c01029e0 <__alltraps>

c010338b <vector236>:
.globl vector236
vector236:
  pushl $0
c010338b:	6a 00                	push   $0x0
  pushl $236
c010338d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0103392:	e9 49 f6 ff ff       	jmp    c01029e0 <__alltraps>

c0103397 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103397:	6a 00                	push   $0x0
  pushl $237
c0103399:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010339e:	e9 3d f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033a3 <vector238>:
.globl vector238
vector238:
  pushl $0
c01033a3:	6a 00                	push   $0x0
  pushl $238
c01033a5:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01033aa:	e9 31 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033af <vector239>:
.globl vector239
vector239:
  pushl $0
c01033af:	6a 00                	push   $0x0
  pushl $239
c01033b1:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01033b6:	e9 25 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033bb <vector240>:
.globl vector240
vector240:
  pushl $0
c01033bb:	6a 00                	push   $0x0
  pushl $240
c01033bd:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01033c2:	e9 19 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033c7 <vector241>:
.globl vector241
vector241:
  pushl $0
c01033c7:	6a 00                	push   $0x0
  pushl $241
c01033c9:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01033ce:	e9 0d f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033d3 <vector242>:
.globl vector242
vector242:
  pushl $0
c01033d3:	6a 00                	push   $0x0
  pushl $242
c01033d5:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01033da:	e9 01 f6 ff ff       	jmp    c01029e0 <__alltraps>

c01033df <vector243>:
.globl vector243
vector243:
  pushl $0
c01033df:	6a 00                	push   $0x0
  pushl $243
c01033e1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01033e6:	e9 f5 f5 ff ff       	jmp    c01029e0 <__alltraps>

c01033eb <vector244>:
.globl vector244
vector244:
  pushl $0
c01033eb:	6a 00                	push   $0x0
  pushl $244
c01033ed:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01033f2:	e9 e9 f5 ff ff       	jmp    c01029e0 <__alltraps>

c01033f7 <vector245>:
.globl vector245
vector245:
  pushl $0
c01033f7:	6a 00                	push   $0x0
  pushl $245
c01033f9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01033fe:	e9 dd f5 ff ff       	jmp    c01029e0 <__alltraps>

c0103403 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103403:	6a 00                	push   $0x0
  pushl $246
c0103405:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010340a:	e9 d1 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010340f <vector247>:
.globl vector247
vector247:
  pushl $0
c010340f:	6a 00                	push   $0x0
  pushl $247
c0103411:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103416:	e9 c5 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010341b <vector248>:
.globl vector248
vector248:
  pushl $0
c010341b:	6a 00                	push   $0x0
  pushl $248
c010341d:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103422:	e9 b9 f5 ff ff       	jmp    c01029e0 <__alltraps>

c0103427 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103427:	6a 00                	push   $0x0
  pushl $249
c0103429:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010342e:	e9 ad f5 ff ff       	jmp    c01029e0 <__alltraps>

c0103433 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103433:	6a 00                	push   $0x0
  pushl $250
c0103435:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010343a:	e9 a1 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010343f <vector251>:
.globl vector251
vector251:
  pushl $0
c010343f:	6a 00                	push   $0x0
  pushl $251
c0103441:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103446:	e9 95 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010344b <vector252>:
.globl vector252
vector252:
  pushl $0
c010344b:	6a 00                	push   $0x0
  pushl $252
c010344d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103452:	e9 89 f5 ff ff       	jmp    c01029e0 <__alltraps>

c0103457 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103457:	6a 00                	push   $0x0
  pushl $253
c0103459:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010345e:	e9 7d f5 ff ff       	jmp    c01029e0 <__alltraps>

c0103463 <vector254>:
.globl vector254
vector254:
  pushl $0
c0103463:	6a 00                	push   $0x0
  pushl $254
c0103465:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010346a:	e9 71 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010346f <vector255>:
.globl vector255
vector255:
  pushl $0
c010346f:	6a 00                	push   $0x0
  pushl $255
c0103471:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0103476:	e9 65 f5 ff ff       	jmp    c01029e0 <__alltraps>

c010347b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010347b:	55                   	push   %ebp
c010347c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010347e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103481:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0103486:	29 c2                	sub    %eax,%edx
c0103488:	89 d0                	mov    %edx,%eax
c010348a:	c1 f8 05             	sar    $0x5,%eax
}
c010348d:	5d                   	pop    %ebp
c010348e:	c3                   	ret    

c010348f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010348f:	55                   	push   %ebp
c0103490:	89 e5                	mov    %esp,%ebp
c0103492:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103495:	8b 45 08             	mov    0x8(%ebp),%eax
c0103498:	89 04 24             	mov    %eax,(%esp)
c010349b:	e8 db ff ff ff       	call   c010347b <page2ppn>
c01034a0:	c1 e0 0c             	shl    $0xc,%eax
}
c01034a3:	c9                   	leave  
c01034a4:	c3                   	ret    

c01034a5 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01034a5:	55                   	push   %ebp
c01034a6:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01034a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ab:	8b 00                	mov    (%eax),%eax
}
c01034ad:	5d                   	pop    %ebp
c01034ae:	c3                   	ret    

c01034af <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01034af:	55                   	push   %ebp
c01034b0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01034b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01034b5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034b8:	89 10                	mov    %edx,(%eax)
}
c01034ba:	5d                   	pop    %ebp
c01034bb:	c3                   	ret    

c01034bc <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01034bc:	55                   	push   %ebp
c01034bd:	89 e5                	mov    %esp,%ebp
c01034bf:	83 ec 10             	sub    $0x10,%esp
c01034c2:	c7 45 fc b8 df 19 c0 	movl   $0xc019dfb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01034cf:	89 50 04             	mov    %edx,0x4(%eax)
c01034d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034d5:	8b 50 04             	mov    0x4(%eax),%edx
c01034d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01034db:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01034dd:	c7 05 c0 df 19 c0 00 	movl   $0x0,0xc019dfc0
c01034e4:	00 00 00 
}
c01034e7:	c9                   	leave  
c01034e8:	c3                   	ret    

c01034e9 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01034e9:	55                   	push   %ebp
c01034ea:	89 e5                	mov    %esp,%ebp
c01034ec:	83 ec 78             	sub    $0x78,%esp
    assert(n > 0);
c01034ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01034f3:	75 24                	jne    c0103519 <default_alloc_pages+0x30>
c01034f5:	c7 44 24 0c d0 c3 10 	movl   $0xc010c3d0,0xc(%esp)
c01034fc:	c0 
c01034fd:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103504:	c0 
c0103505:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010350c:	00 
c010350d:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103514:	e8 bc d8 ff ff       	call   c0100dd5 <__panic>
    if (n > nr_free) {
c0103519:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c010351e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103521:	73 0a                	jae    c010352d <default_alloc_pages+0x44>
        return NULL;
c0103523:	b8 00 00 00 00       	mov    $0x0,%eax
c0103528:	e9 74 01 00 00       	jmp    c01036a1 <default_alloc_pages+0x1b8>
    }
    struct Page *page = NULL;
c010352d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0103534:	c7 45 f0 b8 df 19 c0 	movl   $0xc019dfb8,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010353b:	eb 1c                	jmp    c0103559 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c010353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103540:	83 e8 0c             	sub    $0xc,%eax
c0103543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0103546:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103549:	8b 40 08             	mov    0x8(%eax),%eax
c010354c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010354f:	72 08                	jb     c0103559 <default_alloc_pages+0x70>
            page = p;
c0103551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103554:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0103557:	eb 18                	jmp    c0103571 <default_alloc_pages+0x88>
c0103559:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010355c:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010355f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103562:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103565:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103568:	81 7d f0 b8 df 19 c0 	cmpl   $0xc019dfb8,-0x10(%ebp)
c010356f:	75 cc                	jne    c010353d <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0103571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103575:	0f 84 23 01 00 00    	je     c010369e <default_alloc_pages+0x1b5>
        int i;
        list_entry_t *le_to_change = &page->page_link;
c010357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357e:	83 c0 0c             	add    $0xc,%eax
c0103581:	89 45 e8             	mov    %eax,-0x18(%ebp)
        for (i = 0; i < n; i++) {
c0103584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010358b:	eb 4e                	jmp    c01035db <default_alloc_pages+0xf2>
              struct Page *p = le2page(le_to_change, page_link);
c010358d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103590:	83 e8 0c             	sub    $0xc,%eax
c0103593:	89 45 e0             	mov    %eax,-0x20(%ebp)
              ClearPageProperty(p);
c0103596:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103599:	83 c0 04             	add    $0x4,%eax
c010359c:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01035a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035a6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035ac:	0f b3 10             	btr    %edx,(%eax)
              SetPageReserved(p);
c01035af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035b2:	83 c0 04             	add    $0x4,%eax
c01035b5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c01035bc:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035c2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035c5:	0f ab 10             	bts    %edx,(%eax)
c01035c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035cb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c01035ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035d1:	8b 40 04             	mov    0x4(%eax),%eax
              le_to_change = list_next(le_to_change);
c01035d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        }
    }
    if (page != NULL) {
        int i;
        list_entry_t *le_to_change = &page->page_link;
        for (i = 0; i < n; i++) {
c01035d7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01035db:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035de:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035e1:	72 aa                	jb     c010358d <default_alloc_pages+0xa4>
              struct Page *p = le2page(le_to_change, page_link);
              ClearPageProperty(p);
              SetPageReserved(p);
              le_to_change = list_next(le_to_change);
        }
        if (page->property > n) {
c01035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035e6:	8b 40 08             	mov    0x8(%eax),%eax
c01035e9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035ec:	76 78                	jbe    c0103666 <default_alloc_pages+0x17d>
            struct Page *p = page + n;
c01035ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f1:	c1 e0 05             	shl    $0x5,%eax
c01035f4:	89 c2                	mov    %eax,%edx
c01035f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f9:	01 d0                	add    %edx,%eax
c01035fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
            p->property = page->property - n;
c01035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103601:	8b 40 08             	mov    0x8(%eax),%eax
c0103604:	2b 45 08             	sub    0x8(%ebp),%eax
c0103607:	89 c2                	mov    %eax,%edx
c0103609:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010360c:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&page->page_link, &(p->page_link));
c010360f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103612:	83 c0 0c             	add    $0xc,%eax
c0103615:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103618:	83 c2 0c             	add    $0xc,%edx
c010361b:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010361e:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103621:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103624:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103627:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010362a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010362d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103630:	8b 40 04             	mov    0x4(%eax),%eax
c0103633:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103636:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0103639:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010363c:	89 55 ac             	mov    %edx,-0x54(%ebp)
c010363f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103642:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103645:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103648:	89 10                	mov    %edx,(%eax)
c010364a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010364d:	8b 10                	mov    (%eax),%edx
c010364f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103652:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103655:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103658:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010365b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010365e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103661:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103664:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0103666:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103669:	83 c0 0c             	add    $0xc,%eax
c010366c:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010366f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103672:	8b 40 04             	mov    0x4(%eax),%eax
c0103675:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103678:	8b 12                	mov    (%edx),%edx
c010367a:	89 55 a0             	mov    %edx,-0x60(%ebp)
c010367d:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103680:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103683:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103686:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103689:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010368c:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010368f:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0103691:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0103696:	2b 45 08             	sub    0x8(%ebp),%eax
c0103699:	a3 c0 df 19 c0       	mov    %eax,0xc019dfc0
    }
    return page;
c010369e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01036a1:	c9                   	leave  
c01036a2:	c3                   	ret    

c01036a3 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01036a3:	55                   	push   %ebp
c01036a4:	89 e5                	mov    %esp,%ebp
c01036a6:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01036a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01036ad:	75 24                	jne    c01036d3 <default_free_pages+0x30>
c01036af:	c7 44 24 0c d0 c3 10 	movl   $0xc010c3d0,0xc(%esp)
c01036b6:	c0 
c01036b7:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01036be:	c0 
c01036bf:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01036c6:	00 
c01036c7:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01036ce:	e8 02 d7 ff ff       	call   c0100dd5 <__panic>
    struct Page *p = base;
c01036d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01036d9:	eb 46                	jmp    c0103721 <default_free_pages+0x7e>
        p->flags = p->property = 0;
c01036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036e8:	8b 50 08             	mov    0x8(%eax),%edx
c01036eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ee:	89 50 04             	mov    %edx,0x4(%eax)
        SetPageProperty(p);
c01036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f4:	83 c0 04             	add    $0x4,%eax
c01036f7:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01036fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103701:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103704:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103707:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);
c010370a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103711:	00 
c0103712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103715:	89 04 24             	mov    %eax,(%esp)
c0103718:	e8 92 fd ff ff       	call   c01034af <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010371d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103721:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103724:	c1 e0 05             	shl    $0x5,%eax
c0103727:	89 c2                	mov    %eax,%edx
c0103729:	8b 45 08             	mov    0x8(%ebp),%eax
c010372c:	01 d0                	add    %edx,%eax
c010372e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103731:	75 a8                	jne    c01036db <default_free_pages+0x38>
        p->flags = p->property = 0;
        SetPageProperty(p);
        set_page_ref(p, 0);
    }
    base->property = n;
c0103733:	8b 45 08             	mov    0x8(%ebp),%eax
c0103736:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103739:	89 50 08             	mov    %edx,0x8(%eax)
c010373c:	c7 45 d8 b8 df 19 c0 	movl   $0xc019dfb8,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103743:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103746:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0103749:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (; le != &free_list; le = list_next(le))
c010374c:	eb 1c                	jmp    c010376a <default_free_pages+0xc7>
        if (le2page(le, page_link) > base)
c010374e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103751:	83 e8 0c             	sub    $0xc,%eax
c0103754:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103757:	76 02                	jbe    c010375b <default_free_pages+0xb8>
            break;
c0103759:	eb 18                	jmp    c0103773 <default_free_pages+0xd0>
c010375b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010375e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0103761:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103764:	8b 40 04             	mov    0x4(%eax),%eax
        SetPageProperty(p);
        set_page_ref(p, 0);
    }
    base->property = n;
    list_entry_t *le = list_next(&free_list);
    for (; le != &free_list; le = list_next(le))
c0103767:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010376a:	81 7d f0 b8 df 19 c0 	cmpl   $0xc019dfb8,-0x10(%ebp)
c0103771:	75 db                	jne    c010374e <default_free_pages+0xab>
        if (le2page(le, page_link) > base)
            break;
    list_add_before(le, &base->page_link);
c0103773:	8b 45 08             	mov    0x8(%ebp),%eax
c0103776:	8d 50 0c             	lea    0xc(%eax),%edx
c0103779:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010377c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010377f:	89 55 cc             	mov    %edx,-0x34(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103782:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103785:	8b 00                	mov    (%eax),%eax
c0103787:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010378a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010378d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0103790:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103793:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103796:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103799:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010379c:	89 10                	mov    %edx,(%eax)
c010379e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01037a1:	8b 10                	mov    (%eax),%edx
c01037a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01037a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01037a9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037ac:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01037af:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01037b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01037b5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01037b8:	89 10                	mov    %edx,(%eax)
c01037ba:	c7 45 bc b8 df 19 c0 	movl   $0xc019dfb8,-0x44(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01037c4:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c01037c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01037ca:	e9 87 00 00 00       	jmp    c0103856 <default_free_pages+0x1b3>
c01037cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01037d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01037d8:	8b 40 04             	mov    0x4(%eax),%eax
        list_entry_t *le_next = list_next(le);
c01037db:	89 45 ec             	mov    %eax,-0x14(%ebp)
        struct Page *p = le2page(le, page_link);
c01037de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037e1:	83 e8 0c             	sub    $0xc,%eax
c01037e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        struct Page *p_next = le2page(le_next, page_link);
c01037e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ea:	83 e8 0c             	sub    $0xc,%eax
c01037ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p + p->property == p_next) {
c01037f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037f3:	8b 40 08             	mov    0x8(%eax),%eax
c01037f6:	c1 e0 05             	shl    $0x5,%eax
c01037f9:	89 c2                	mov    %eax,%edx
c01037fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037fe:	01 d0                	add    %edx,%eax
c0103800:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
c0103803:	75 4b                	jne    c0103850 <default_free_pages+0x1ad>
            p->property += p_next->property;
c0103805:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103808:	8b 50 08             	mov    0x8(%eax),%edx
c010380b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010380e:	8b 40 08             	mov    0x8(%eax),%eax
c0103811:	01 c2                	add    %eax,%edx
c0103813:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103816:	89 50 08             	mov    %edx,0x8(%eax)
            p_next->property = 0;
c0103819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010381c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            list_del(&(p_next->page_link));
c0103823:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103826:	83 c0 0c             	add    $0xc,%eax
c0103829:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010382c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010382f:	8b 40 04             	mov    0x4(%eax),%eax
c0103832:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103835:	8b 12                	mov    (%edx),%edx
c0103837:	89 55 b0             	mov    %edx,-0x50(%ebp)
c010383a:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010383d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103840:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103843:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103846:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103849:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010384c:	89 10                	mov    %edx,(%eax)
c010384e:	eb 06                	jmp    c0103856 <default_free_pages+0x1b3>
        } else
            le = le_next;
c0103850:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103853:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for (; le != &free_list; le = list_next(le))
        if (le2page(le, page_link) > base)
            break;
    list_add_before(le, &base->page_link);
    le = list_next(&free_list);
    while (le != &free_list) {
c0103856:	81 7d f0 b8 df 19 c0 	cmpl   $0xc019dfb8,-0x10(%ebp)
c010385d:	0f 85 6c ff ff ff    	jne    c01037cf <default_free_pages+0x12c>
            p_next->property = 0;
            list_del(&(p_next->page_link));
        } else
            le = le_next;
    }
    nr_free += n;
c0103863:	8b 15 c0 df 19 c0    	mov    0xc019dfc0,%edx
c0103869:	8b 45 0c             	mov    0xc(%ebp),%eax
c010386c:	01 d0                	add    %edx,%eax
c010386e:	a3 c0 df 19 c0       	mov    %eax,0xc019dfc0
}
c0103873:	c9                   	leave  
c0103874:	c3                   	ret    

c0103875 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103875:	55                   	push   %ebp
c0103876:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103878:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
}
c010387d:	5d                   	pop    %ebp
c010387e:	c3                   	ret    

c010387f <basic_check>:

static void
basic_check(void) {
c010387f:	55                   	push   %ebp
c0103880:	89 e5                	mov    %esp,%ebp
c0103882:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103885:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010388c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010388f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103892:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103895:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103898:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010389f:	e8 dc 15 00 00       	call   c0104e80 <alloc_pages>
c01038a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01038ab:	75 24                	jne    c01038d1 <basic_check+0x52>
c01038ad:	c7 44 24 0c 01 c4 10 	movl   $0xc010c401,0xc(%esp)
c01038b4:	c0 
c01038b5:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01038bc:	c0 
c01038bd:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
c01038c4:	00 
c01038c5:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01038cc:	e8 04 d5 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01038d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d8:	e8 a3 15 00 00       	call   c0104e80 <alloc_pages>
c01038dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038e4:	75 24                	jne    c010390a <basic_check+0x8b>
c01038e6:	c7 44 24 0c 1d c4 10 	movl   $0xc010c41d,0xc(%esp)
c01038ed:	c0 
c01038ee:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01038f5:	c0 
c01038f6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
c01038fd:	00 
c01038fe:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103905:	e8 cb d4 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010390a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103911:	e8 6a 15 00 00       	call   c0104e80 <alloc_pages>
c0103916:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103919:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010391d:	75 24                	jne    c0103943 <basic_check+0xc4>
c010391f:	c7 44 24 0c 39 c4 10 	movl   $0xc010c439,0xc(%esp)
c0103926:	c0 
c0103927:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c010392e:	c0 
c010392f:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0103936:	00 
c0103937:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c010393e:	e8 92 d4 ff ff       	call   c0100dd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103943:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103946:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103949:	74 10                	je     c010395b <basic_check+0xdc>
c010394b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010394e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103951:	74 08                	je     c010395b <basic_check+0xdc>
c0103953:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103956:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103959:	75 24                	jne    c010397f <basic_check+0x100>
c010395b:	c7 44 24 0c 58 c4 10 	movl   $0xc010c458,0xc(%esp)
c0103962:	c0 
c0103963:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c010396a:	c0 
c010396b:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0103972:	00 
c0103973:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c010397a:	e8 56 d4 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c010397f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103982:	89 04 24             	mov    %eax,(%esp)
c0103985:	e8 1b fb ff ff       	call   c01034a5 <page_ref>
c010398a:	85 c0                	test   %eax,%eax
c010398c:	75 1e                	jne    c01039ac <basic_check+0x12d>
c010398e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103991:	89 04 24             	mov    %eax,(%esp)
c0103994:	e8 0c fb ff ff       	call   c01034a5 <page_ref>
c0103999:	85 c0                	test   %eax,%eax
c010399b:	75 0f                	jne    c01039ac <basic_check+0x12d>
c010399d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039a0:	89 04 24             	mov    %eax,(%esp)
c01039a3:	e8 fd fa ff ff       	call   c01034a5 <page_ref>
c01039a8:	85 c0                	test   %eax,%eax
c01039aa:	74 24                	je     c01039d0 <basic_check+0x151>
c01039ac:	c7 44 24 0c 7c c4 10 	movl   $0xc010c47c,0xc(%esp)
c01039b3:	c0 
c01039b4:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01039bb:	c0 
c01039bc:	c7 44 24 04 93 00 00 	movl   $0x93,0x4(%esp)
c01039c3:	00 
c01039c4:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01039cb:	e8 05 d4 ff ff       	call   c0100dd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01039d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d3:	89 04 24             	mov    %eax,(%esp)
c01039d6:	e8 b4 fa ff ff       	call   c010348f <page2pa>
c01039db:	8b 15 e0 be 19 c0    	mov    0xc019bee0,%edx
c01039e1:	c1 e2 0c             	shl    $0xc,%edx
c01039e4:	39 d0                	cmp    %edx,%eax
c01039e6:	72 24                	jb     c0103a0c <basic_check+0x18d>
c01039e8:	c7 44 24 0c b8 c4 10 	movl   $0xc010c4b8,0xc(%esp)
c01039ef:	c0 
c01039f0:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01039f7:	c0 
c01039f8:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
c01039ff:	00 
c0103a00:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103a07:	e8 c9 d3 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a0f:	89 04 24             	mov    %eax,(%esp)
c0103a12:	e8 78 fa ff ff       	call   c010348f <page2pa>
c0103a17:	8b 15 e0 be 19 c0    	mov    0xc019bee0,%edx
c0103a1d:	c1 e2 0c             	shl    $0xc,%edx
c0103a20:	39 d0                	cmp    %edx,%eax
c0103a22:	72 24                	jb     c0103a48 <basic_check+0x1c9>
c0103a24:	c7 44 24 0c d5 c4 10 	movl   $0xc010c4d5,0xc(%esp)
c0103a2b:	c0 
c0103a2c:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103a33:	c0 
c0103a34:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0103a3b:	00 
c0103a3c:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103a43:	e8 8d d3 ff ff       	call   c0100dd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a4b:	89 04 24             	mov    %eax,(%esp)
c0103a4e:	e8 3c fa ff ff       	call   c010348f <page2pa>
c0103a53:	8b 15 e0 be 19 c0    	mov    0xc019bee0,%edx
c0103a59:	c1 e2 0c             	shl    $0xc,%edx
c0103a5c:	39 d0                	cmp    %edx,%eax
c0103a5e:	72 24                	jb     c0103a84 <basic_check+0x205>
c0103a60:	c7 44 24 0c f2 c4 10 	movl   $0xc010c4f2,0xc(%esp)
c0103a67:	c0 
c0103a68:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103a6f:	c0 
c0103a70:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0103a77:	00 
c0103a78:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103a7f:	e8 51 d3 ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103a84:	a1 b8 df 19 c0       	mov    0xc019dfb8,%eax
c0103a89:	8b 15 bc df 19 c0    	mov    0xc019dfbc,%edx
c0103a8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103a92:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103a95:	c7 45 e0 b8 df 19 c0 	movl   $0xc019dfb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103a9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103aa2:	89 50 04             	mov    %edx,0x4(%eax)
c0103aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aa8:	8b 50 04             	mov    0x4(%eax),%edx
c0103aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103aae:	89 10                	mov    %edx,(%eax)
c0103ab0:	c7 45 dc b8 df 19 c0 	movl   $0xc019dfb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103ab7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103aba:	8b 40 04             	mov    0x4(%eax),%eax
c0103abd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103ac0:	0f 94 c0             	sete   %al
c0103ac3:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ac6:	85 c0                	test   %eax,%eax
c0103ac8:	75 24                	jne    c0103aee <basic_check+0x26f>
c0103aca:	c7 44 24 0c 0f c5 10 	movl   $0xc010c50f,0xc(%esp)
c0103ad1:	c0 
c0103ad2:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103ad9:	c0 
c0103ada:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0103ae1:	00 
c0103ae2:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103ae9:	e8 e7 d2 ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103aee:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0103af3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103af6:	c7 05 c0 df 19 c0 00 	movl   $0x0,0xc019dfc0
c0103afd:	00 00 00 

    assert(alloc_page() == NULL);
c0103b00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b07:	e8 74 13 00 00       	call   c0104e80 <alloc_pages>
c0103b0c:	85 c0                	test   %eax,%eax
c0103b0e:	74 24                	je     c0103b34 <basic_check+0x2b5>
c0103b10:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c0103b17:	c0 
c0103b18:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103b1f:	c0 
c0103b20:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0103b27:	00 
c0103b28:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103b2f:	e8 a1 d2 ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103b34:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b3b:	00 
c0103b3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3f:	89 04 24             	mov    %eax,(%esp)
c0103b42:	e8 a4 13 00 00       	call   c0104eeb <free_pages>
    free_page(p1);
c0103b47:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b4e:	00 
c0103b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b52:	89 04 24             	mov    %eax,(%esp)
c0103b55:	e8 91 13 00 00       	call   c0104eeb <free_pages>
    free_page(p2);
c0103b5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b61:	00 
c0103b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b65:	89 04 24             	mov    %eax,(%esp)
c0103b68:	e8 7e 13 00 00       	call   c0104eeb <free_pages>
    assert(nr_free == 3);
c0103b6d:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0103b72:	83 f8 03             	cmp    $0x3,%eax
c0103b75:	74 24                	je     c0103b9b <basic_check+0x31c>
c0103b77:	c7 44 24 0c 3b c5 10 	movl   $0xc010c53b,0xc(%esp)
c0103b7e:	c0 
c0103b7f:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103b86:	c0 
c0103b87:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0103b8e:	00 
c0103b8f:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103b96:	e8 3a d2 ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103b9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ba2:	e8 d9 12 00 00       	call   c0104e80 <alloc_pages>
c0103ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103bae:	75 24                	jne    c0103bd4 <basic_check+0x355>
c0103bb0:	c7 44 24 0c 01 c4 10 	movl   $0xc010c401,0xc(%esp)
c0103bb7:	c0 
c0103bb8:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103bbf:	c0 
c0103bc0:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0103bc7:	00 
c0103bc8:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103bcf:	e8 01 d2 ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103bd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bdb:	e8 a0 12 00 00       	call   c0104e80 <alloc_pages>
c0103be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103be3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103be7:	75 24                	jne    c0103c0d <basic_check+0x38e>
c0103be9:	c7 44 24 0c 1d c4 10 	movl   $0xc010c41d,0xc(%esp)
c0103bf0:	c0 
c0103bf1:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103bf8:	c0 
c0103bf9:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0103c00:	00 
c0103c01:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103c08:	e8 c8 d1 ff ff       	call   c0100dd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c14:	e8 67 12 00 00       	call   c0104e80 <alloc_pages>
c0103c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c20:	75 24                	jne    c0103c46 <basic_check+0x3c7>
c0103c22:	c7 44 24 0c 39 c4 10 	movl   $0xc010c439,0xc(%esp)
c0103c29:	c0 
c0103c2a:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103c31:	c0 
c0103c32:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0103c39:	00 
c0103c3a:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103c41:	e8 8f d1 ff ff       	call   c0100dd5 <__panic>

    assert(alloc_page() == NULL);
c0103c46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c4d:	e8 2e 12 00 00       	call   c0104e80 <alloc_pages>
c0103c52:	85 c0                	test   %eax,%eax
c0103c54:	74 24                	je     c0103c7a <basic_check+0x3fb>
c0103c56:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c0103c5d:	c0 
c0103c5e:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103c65:	c0 
c0103c66:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0103c6d:	00 
c0103c6e:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103c75:	e8 5b d1 ff ff       	call   c0100dd5 <__panic>

    free_page(p0);
c0103c7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c81:	00 
c0103c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c85:	89 04 24             	mov    %eax,(%esp)
c0103c88:	e8 5e 12 00 00       	call   c0104eeb <free_pages>
c0103c8d:	c7 45 d8 b8 df 19 c0 	movl   $0xc019dfb8,-0x28(%ebp)
c0103c94:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103c97:	8b 40 04             	mov    0x4(%eax),%eax
c0103c9a:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103c9d:	0f 94 c0             	sete   %al
c0103ca0:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103ca3:	85 c0                	test   %eax,%eax
c0103ca5:	74 24                	je     c0103ccb <basic_check+0x44c>
c0103ca7:	c7 44 24 0c 48 c5 10 	movl   $0xc010c548,0xc(%esp)
c0103cae:	c0 
c0103caf:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103cb6:	c0 
c0103cb7:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103cbe:	00 
c0103cbf:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103cc6:	e8 0a d1 ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103ccb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cd2:	e8 a9 11 00 00       	call   c0104e80 <alloc_pages>
c0103cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cdd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103ce0:	74 24                	je     c0103d06 <basic_check+0x487>
c0103ce2:	c7 44 24 0c 60 c5 10 	movl   $0xc010c560,0xc(%esp)
c0103ce9:	c0 
c0103cea:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103cf1:	c0 
c0103cf2:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103cf9:	00 
c0103cfa:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103d01:	e8 cf d0 ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0103d06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d0d:	e8 6e 11 00 00       	call   c0104e80 <alloc_pages>
c0103d12:	85 c0                	test   %eax,%eax
c0103d14:	74 24                	je     c0103d3a <basic_check+0x4bb>
c0103d16:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c0103d1d:	c0 
c0103d1e:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103d25:	c0 
c0103d26:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103d2d:	00 
c0103d2e:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103d35:	e8 9b d0 ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c0103d3a:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0103d3f:	85 c0                	test   %eax,%eax
c0103d41:	74 24                	je     c0103d67 <basic_check+0x4e8>
c0103d43:	c7 44 24 0c 79 c5 10 	movl   $0xc010c579,0xc(%esp)
c0103d4a:	c0 
c0103d4b:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103d52:	c0 
c0103d53:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103d5a:	00 
c0103d5b:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103d62:	e8 6e d0 ff ff       	call   c0100dd5 <__panic>
    free_list = free_list_store;
c0103d67:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d6d:	a3 b8 df 19 c0       	mov    %eax,0xc019dfb8
c0103d72:	89 15 bc df 19 c0    	mov    %edx,0xc019dfbc
    nr_free = nr_free_store;
c0103d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d7b:	a3 c0 df 19 c0       	mov    %eax,0xc019dfc0

    free_page(p);
c0103d80:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d87:	00 
c0103d88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d8b:	89 04 24             	mov    %eax,(%esp)
c0103d8e:	e8 58 11 00 00       	call   c0104eeb <free_pages>
    free_page(p1);
c0103d93:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d9a:	00 
c0103d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d9e:	89 04 24             	mov    %eax,(%esp)
c0103da1:	e8 45 11 00 00       	call   c0104eeb <free_pages>
    free_page(p2);
c0103da6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dad:	00 
c0103dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103db1:	89 04 24             	mov    %eax,(%esp)
c0103db4:	e8 32 11 00 00       	call   c0104eeb <free_pages>
}
c0103db9:	c9                   	leave  
c0103dba:	c3                   	ret    

c0103dbb <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103dbb:	55                   	push   %ebp
c0103dbc:	89 e5                	mov    %esp,%ebp
c0103dbe:	53                   	push   %ebx
c0103dbf:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103dc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dcc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103dd3:	c7 45 ec b8 df 19 c0 	movl   $0xc019dfb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103dda:	eb 6b                	jmp    c0103e47 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ddf:	83 e8 0c             	sub    $0xc,%eax
c0103de2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103de8:	83 c0 04             	add    $0x4,%eax
c0103deb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103df2:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103df5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103df8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103dfb:	0f a3 10             	bt     %edx,(%eax)
c0103dfe:	19 c0                	sbb    %eax,%eax
c0103e00:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103e03:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103e07:	0f 95 c0             	setne  %al
c0103e0a:	0f b6 c0             	movzbl %al,%eax
c0103e0d:	85 c0                	test   %eax,%eax
c0103e0f:	75 24                	jne    c0103e35 <default_check+0x7a>
c0103e11:	c7 44 24 0c 86 c5 10 	movl   $0xc010c586,0xc(%esp)
c0103e18:	c0 
c0103e19:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103e20:	c0 
c0103e21:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103e28:	00 
c0103e29:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103e30:	e8 a0 cf ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0103e35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e3c:	8b 50 08             	mov    0x8(%eax),%edx
c0103e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e42:	01 d0                	add    %edx,%eax
c0103e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e50:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e53:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e56:	81 7d ec b8 df 19 c0 	cmpl   $0xc019dfb8,-0x14(%ebp)
c0103e5d:	0f 85 79 ff ff ff    	jne    c0103ddc <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e63:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e66:	e8 b2 10 00 00       	call   c0104f1d <nr_free_pages>
c0103e6b:	39 c3                	cmp    %eax,%ebx
c0103e6d:	74 24                	je     c0103e93 <default_check+0xd8>
c0103e6f:	c7 44 24 0c 96 c5 10 	movl   $0xc010c596,0xc(%esp)
c0103e76:	c0 
c0103e77:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103e7e:	c0 
c0103e7f:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103e86:	00 
c0103e87:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103e8e:	e8 42 cf ff ff       	call   c0100dd5 <__panic>

    basic_check();
c0103e93:	e8 e7 f9 ff ff       	call   c010387f <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103e98:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103e9f:	e8 dc 0f 00 00       	call   c0104e80 <alloc_pages>
c0103ea4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103ea7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eab:	75 24                	jne    c0103ed1 <default_check+0x116>
c0103ead:	c7 44 24 0c af c5 10 	movl   $0xc010c5af,0xc(%esp)
c0103eb4:	c0 
c0103eb5:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103ebc:	c0 
c0103ebd:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103ec4:	00 
c0103ec5:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103ecc:	e8 04 cf ff ff       	call   c0100dd5 <__panic>
    assert(!PageProperty(p0));
c0103ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ed4:	83 c0 04             	add    $0x4,%eax
c0103ed7:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103ede:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ee1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ee4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103ee7:	0f a3 10             	bt     %edx,(%eax)
c0103eea:	19 c0                	sbb    %eax,%eax
c0103eec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103eef:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103ef3:	0f 95 c0             	setne  %al
c0103ef6:	0f b6 c0             	movzbl %al,%eax
c0103ef9:	85 c0                	test   %eax,%eax
c0103efb:	74 24                	je     c0103f21 <default_check+0x166>
c0103efd:	c7 44 24 0c ba c5 10 	movl   $0xc010c5ba,0xc(%esp)
c0103f04:	c0 
c0103f05:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103f0c:	c0 
c0103f0d:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103f14:	00 
c0103f15:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103f1c:	e8 b4 ce ff ff       	call   c0100dd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103f21:	a1 b8 df 19 c0       	mov    0xc019dfb8,%eax
c0103f26:	8b 15 bc df 19 c0    	mov    0xc019dfbc,%edx
c0103f2c:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f2f:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f32:	c7 45 b4 b8 df 19 c0 	movl   $0xc019dfb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f39:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f3c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f3f:	89 50 04             	mov    %edx,0x4(%eax)
c0103f42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f45:	8b 50 04             	mov    0x4(%eax),%edx
c0103f48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f4b:	89 10                	mov    %edx,(%eax)
c0103f4d:	c7 45 b0 b8 df 19 c0 	movl   $0xc019dfb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f54:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f57:	8b 40 04             	mov    0x4(%eax),%eax
c0103f5a:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f5d:	0f 94 c0             	sete   %al
c0103f60:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f63:	85 c0                	test   %eax,%eax
c0103f65:	75 24                	jne    c0103f8b <default_check+0x1d0>
c0103f67:	c7 44 24 0c 0f c5 10 	movl   $0xc010c50f,0xc(%esp)
c0103f6e:	c0 
c0103f6f:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103f76:	c0 
c0103f77:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0103f7e:	00 
c0103f7f:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103f86:	e8 4a ce ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c0103f8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f92:	e8 e9 0e 00 00       	call   c0104e80 <alloc_pages>
c0103f97:	85 c0                	test   %eax,%eax
c0103f99:	74 24                	je     c0103fbf <default_check+0x204>
c0103f9b:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c0103fa2:	c0 
c0103fa3:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0103faa:	c0 
c0103fab:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103fb2:	00 
c0103fb3:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0103fba:	e8 16 ce ff ff       	call   c0100dd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103fbf:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0103fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103fc7:	c7 05 c0 df 19 c0 00 	movl   $0x0,0xc019dfc0
c0103fce:	00 00 00 

    free_pages(p0 + 2, 3);
c0103fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd4:	83 c0 40             	add    $0x40,%eax
c0103fd7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103fde:	00 
c0103fdf:	89 04 24             	mov    %eax,(%esp)
c0103fe2:	e8 04 0f 00 00       	call   c0104eeb <free_pages>
    assert(alloc_pages(4) == NULL);
c0103fe7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103fee:	e8 8d 0e 00 00       	call   c0104e80 <alloc_pages>
c0103ff3:	85 c0                	test   %eax,%eax
c0103ff5:	74 24                	je     c010401b <default_check+0x260>
c0103ff7:	c7 44 24 0c cc c5 10 	movl   $0xc010c5cc,0xc(%esp)
c0103ffe:	c0 
c0103fff:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104006:	c0 
c0104007:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010400e:	00 
c010400f:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104016:	e8 ba cd ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010401b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010401e:	83 c0 40             	add    $0x40,%eax
c0104021:	83 c0 04             	add    $0x4,%eax
c0104024:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010402b:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010402e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104031:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104034:	0f a3 10             	bt     %edx,(%eax)
c0104037:	19 c0                	sbb    %eax,%eax
c0104039:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010403c:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104040:	0f 95 c0             	setne  %al
c0104043:	0f b6 c0             	movzbl %al,%eax
c0104046:	85 c0                	test   %eax,%eax
c0104048:	74 0e                	je     c0104058 <default_check+0x29d>
c010404a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010404d:	83 c0 40             	add    $0x40,%eax
c0104050:	8b 40 08             	mov    0x8(%eax),%eax
c0104053:	83 f8 03             	cmp    $0x3,%eax
c0104056:	74 24                	je     c010407c <default_check+0x2c1>
c0104058:	c7 44 24 0c e4 c5 10 	movl   $0xc010c5e4,0xc(%esp)
c010405f:	c0 
c0104060:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104067:	c0 
c0104068:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010406f:	00 
c0104070:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104077:	e8 59 cd ff ff       	call   c0100dd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010407c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104083:	e8 f8 0d 00 00       	call   c0104e80 <alloc_pages>
c0104088:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010408b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010408f:	75 24                	jne    c01040b5 <default_check+0x2fa>
c0104091:	c7 44 24 0c 10 c6 10 	movl   $0xc010c610,0xc(%esp)
c0104098:	c0 
c0104099:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01040a0:	c0 
c01040a1:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01040a8:	00 
c01040a9:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01040b0:	e8 20 cd ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c01040b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040bc:	e8 bf 0d 00 00       	call   c0104e80 <alloc_pages>
c01040c1:	85 c0                	test   %eax,%eax
c01040c3:	74 24                	je     c01040e9 <default_check+0x32e>
c01040c5:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c01040cc:	c0 
c01040cd:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01040d4:	c0 
c01040d5:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01040dc:	00 
c01040dd:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01040e4:	e8 ec cc ff ff       	call   c0100dd5 <__panic>
    assert(p0 + 2 == p1);
c01040e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040ec:	83 c0 40             	add    $0x40,%eax
c01040ef:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01040f2:	74 24                	je     c0104118 <default_check+0x35d>
c01040f4:	c7 44 24 0c 2e c6 10 	movl   $0xc010c62e,0xc(%esp)
c01040fb:	c0 
c01040fc:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104103:	c0 
c0104104:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010410b:	00 
c010410c:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104113:	e8 bd cc ff ff       	call   c0100dd5 <__panic>

    p2 = p0 + 1;
c0104118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010411b:	83 c0 20             	add    $0x20,%eax
c010411e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104121:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104128:	00 
c0104129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010412c:	89 04 24             	mov    %eax,(%esp)
c010412f:	e8 b7 0d 00 00       	call   c0104eeb <free_pages>
    free_pages(p1, 3);
c0104134:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010413b:	00 
c010413c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010413f:	89 04 24             	mov    %eax,(%esp)
c0104142:	e8 a4 0d 00 00       	call   c0104eeb <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010414a:	83 c0 04             	add    $0x4,%eax
c010414d:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104154:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104157:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010415a:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010415d:	0f a3 10             	bt     %edx,(%eax)
c0104160:	19 c0                	sbb    %eax,%eax
c0104162:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104165:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104169:	0f 95 c0             	setne  %al
c010416c:	0f b6 c0             	movzbl %al,%eax
c010416f:	85 c0                	test   %eax,%eax
c0104171:	74 0b                	je     c010417e <default_check+0x3c3>
c0104173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104176:	8b 40 08             	mov    0x8(%eax),%eax
c0104179:	83 f8 01             	cmp    $0x1,%eax
c010417c:	74 24                	je     c01041a2 <default_check+0x3e7>
c010417e:	c7 44 24 0c 3c c6 10 	movl   $0xc010c63c,0xc(%esp)
c0104185:	c0 
c0104186:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c010418d:	c0 
c010418e:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104195:	00 
c0104196:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c010419d:	e8 33 cc ff ff       	call   c0100dd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01041a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041a5:	83 c0 04             	add    $0x4,%eax
c01041a8:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01041af:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041b2:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041b5:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041b8:	0f a3 10             	bt     %edx,(%eax)
c01041bb:	19 c0                	sbb    %eax,%eax
c01041bd:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01041c0:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01041c4:	0f 95 c0             	setne  %al
c01041c7:	0f b6 c0             	movzbl %al,%eax
c01041ca:	85 c0                	test   %eax,%eax
c01041cc:	74 0b                	je     c01041d9 <default_check+0x41e>
c01041ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041d1:	8b 40 08             	mov    0x8(%eax),%eax
c01041d4:	83 f8 03             	cmp    $0x3,%eax
c01041d7:	74 24                	je     c01041fd <default_check+0x442>
c01041d9:	c7 44 24 0c 64 c6 10 	movl   $0xc010c664,0xc(%esp)
c01041e0:	c0 
c01041e1:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01041e8:	c0 
c01041e9:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01041f0:	00 
c01041f1:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01041f8:	e8 d8 cb ff ff       	call   c0100dd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01041fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104204:	e8 77 0c 00 00       	call   c0104e80 <alloc_pages>
c0104209:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010420f:	83 e8 20             	sub    $0x20,%eax
c0104212:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104215:	74 24                	je     c010423b <default_check+0x480>
c0104217:	c7 44 24 0c 8a c6 10 	movl   $0xc010c68a,0xc(%esp)
c010421e:	c0 
c010421f:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104226:	c0 
c0104227:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010422e:	00 
c010422f:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104236:	e8 9a cb ff ff       	call   c0100dd5 <__panic>
    free_page(p0);
c010423b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104242:	00 
c0104243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104246:	89 04 24             	mov    %eax,(%esp)
c0104249:	e8 9d 0c 00 00       	call   c0104eeb <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010424e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104255:	e8 26 0c 00 00       	call   c0104e80 <alloc_pages>
c010425a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010425d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104260:	83 c0 20             	add    $0x20,%eax
c0104263:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104266:	74 24                	je     c010428c <default_check+0x4d1>
c0104268:	c7 44 24 0c a8 c6 10 	movl   $0xc010c6a8,0xc(%esp)
c010426f:	c0 
c0104270:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104277:	c0 
c0104278:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c010427f:	00 
c0104280:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104287:	e8 49 cb ff ff       	call   c0100dd5 <__panic>

    free_pages(p0, 2);
c010428c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104293:	00 
c0104294:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104297:	89 04 24             	mov    %eax,(%esp)
c010429a:	e8 4c 0c 00 00       	call   c0104eeb <free_pages>
    free_page(p2);
c010429f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042a6:	00 
c01042a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042aa:	89 04 24             	mov    %eax,(%esp)
c01042ad:	e8 39 0c 00 00       	call   c0104eeb <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01042b2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042b9:	e8 c2 0b 00 00       	call   c0104e80 <alloc_pages>
c01042be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042c5:	75 24                	jne    c01042eb <default_check+0x530>
c01042c7:	c7 44 24 0c c8 c6 10 	movl   $0xc010c6c8,0xc(%esp)
c01042ce:	c0 
c01042cf:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01042d6:	c0 
c01042d7:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01042de:	00 
c01042df:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01042e6:	e8 ea ca ff ff       	call   c0100dd5 <__panic>
    assert(alloc_page() == NULL);
c01042eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042f2:	e8 89 0b 00 00       	call   c0104e80 <alloc_pages>
c01042f7:	85 c0                	test   %eax,%eax
c01042f9:	74 24                	je     c010431f <default_check+0x564>
c01042fb:	c7 44 24 0c 26 c5 10 	movl   $0xc010c526,0xc(%esp)
c0104302:	c0 
c0104303:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c010430a:	c0 
c010430b:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0104312:	00 
c0104313:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c010431a:	e8 b6 ca ff ff       	call   c0100dd5 <__panic>

    assert(nr_free == 0);
c010431f:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0104324:	85 c0                	test   %eax,%eax
c0104326:	74 24                	je     c010434c <default_check+0x591>
c0104328:	c7 44 24 0c 79 c5 10 	movl   $0xc010c579,0xc(%esp)
c010432f:	c0 
c0104330:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c0104337:	c0 
c0104338:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c010433f:	00 
c0104340:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104347:	e8 89 ca ff ff       	call   c0100dd5 <__panic>
    nr_free = nr_free_store;
c010434c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010434f:	a3 c0 df 19 c0       	mov    %eax,0xc019dfc0

    free_list = free_list_store;
c0104354:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104357:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010435a:	a3 b8 df 19 c0       	mov    %eax,0xc019dfb8
c010435f:	89 15 bc df 19 c0    	mov    %edx,0xc019dfbc
    free_pages(p0, 5);
c0104365:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010436c:	00 
c010436d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104370:	89 04 24             	mov    %eax,(%esp)
c0104373:	e8 73 0b 00 00       	call   c0104eeb <free_pages>

    le = &free_list;
c0104378:	c7 45 ec b8 df 19 c0 	movl   $0xc019dfb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010437f:	eb 1d                	jmp    c010439e <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104381:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104384:	83 e8 0c             	sub    $0xc,%eax
c0104387:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010438a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010438e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104391:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104394:	8b 40 08             	mov    0x8(%eax),%eax
c0104397:	29 c2                	sub    %eax,%edx
c0104399:	89 d0                	mov    %edx,%eax
c010439b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010439e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043a1:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01043a4:	8b 45 88             	mov    -0x78(%ebp),%eax
c01043a7:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01043aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043ad:	81 7d ec b8 df 19 c0 	cmpl   $0xc019dfb8,-0x14(%ebp)
c01043b4:	75 cb                	jne    c0104381 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01043b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043ba:	74 24                	je     c01043e0 <default_check+0x625>
c01043bc:	c7 44 24 0c e6 c6 10 	movl   $0xc010c6e6,0xc(%esp)
c01043c3:	c0 
c01043c4:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01043cb:	c0 
c01043cc:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01043d3:	00 
c01043d4:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c01043db:	e8 f5 c9 ff ff       	call   c0100dd5 <__panic>
    assert(total == 0);
c01043e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043e4:	74 24                	je     c010440a <default_check+0x64f>
c01043e6:	c7 44 24 0c f1 c6 10 	movl   $0xc010c6f1,0xc(%esp)
c01043ed:	c0 
c01043ee:	c7 44 24 08 d6 c3 10 	movl   $0xc010c3d6,0x8(%esp)
c01043f5:	c0 
c01043f6:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01043fd:	00 
c01043fe:	c7 04 24 eb c3 10 c0 	movl   $0xc010c3eb,(%esp)
c0104405:	e8 cb c9 ff ff       	call   c0100dd5 <__panic>
}
c010440a:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104410:	5b                   	pop    %ebx
c0104411:	5d                   	pop    %ebp
c0104412:	c3                   	ret    

c0104413 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104413:	55                   	push   %ebp
c0104414:	89 e5                	mov    %esp,%ebp
c0104416:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104419:	9c                   	pushf  
c010441a:	58                   	pop    %eax
c010441b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010441e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104421:	25 00 02 00 00       	and    $0x200,%eax
c0104426:	85 c0                	test   %eax,%eax
c0104428:	74 0c                	je     c0104436 <__intr_save+0x23>
        intr_disable();
c010442a:	e8 fe db ff ff       	call   c010202d <intr_disable>
        return 1;
c010442f:	b8 01 00 00 00       	mov    $0x1,%eax
c0104434:	eb 05                	jmp    c010443b <__intr_save+0x28>
    }
    return 0;
c0104436:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010443b:	c9                   	leave  
c010443c:	c3                   	ret    

c010443d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010443d:	55                   	push   %ebp
c010443e:	89 e5                	mov    %esp,%ebp
c0104440:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104447:	74 05                	je     c010444e <__intr_restore+0x11>
        intr_enable();
c0104449:	e8 d9 db ff ff       	call   c0102027 <intr_enable>
    }
}
c010444e:	c9                   	leave  
c010444f:	c3                   	ret    

c0104450 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104450:	55                   	push   %ebp
c0104451:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104453:	8b 55 08             	mov    0x8(%ebp),%edx
c0104456:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c010445b:	29 c2                	sub    %eax,%edx
c010445d:	89 d0                	mov    %edx,%eax
c010445f:	c1 f8 05             	sar    $0x5,%eax
}
c0104462:	5d                   	pop    %ebp
c0104463:	c3                   	ret    

c0104464 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104464:	55                   	push   %ebp
c0104465:	89 e5                	mov    %esp,%ebp
c0104467:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010446a:	8b 45 08             	mov    0x8(%ebp),%eax
c010446d:	89 04 24             	mov    %eax,(%esp)
c0104470:	e8 db ff ff ff       	call   c0104450 <page2ppn>
c0104475:	c1 e0 0c             	shl    $0xc,%eax
}
c0104478:	c9                   	leave  
c0104479:	c3                   	ret    

c010447a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010447a:	55                   	push   %ebp
c010447b:	89 e5                	mov    %esp,%ebp
c010447d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104480:	8b 45 08             	mov    0x8(%ebp),%eax
c0104483:	c1 e8 0c             	shr    $0xc,%eax
c0104486:	89 c2                	mov    %eax,%edx
c0104488:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c010448d:	39 c2                	cmp    %eax,%edx
c010448f:	72 1c                	jb     c01044ad <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104491:	c7 44 24 08 2c c7 10 	movl   $0xc010c72c,0x8(%esp)
c0104498:	c0 
c0104499:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01044a0:	00 
c01044a1:	c7 04 24 4b c7 10 c0 	movl   $0xc010c74b,(%esp)
c01044a8:	e8 28 c9 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c01044ad:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c01044b2:	8b 55 08             	mov    0x8(%ebp),%edx
c01044b5:	c1 ea 0c             	shr    $0xc,%edx
c01044b8:	c1 e2 05             	shl    $0x5,%edx
c01044bb:	01 d0                	add    %edx,%eax
}
c01044bd:	c9                   	leave  
c01044be:	c3                   	ret    

c01044bf <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01044bf:	55                   	push   %ebp
c01044c0:	89 e5                	mov    %esp,%ebp
c01044c2:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01044c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01044c8:	89 04 24             	mov    %eax,(%esp)
c01044cb:	e8 94 ff ff ff       	call   c0104464 <page2pa>
c01044d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d6:	c1 e8 0c             	shr    $0xc,%eax
c01044d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044dc:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c01044e1:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01044e4:	72 23                	jb     c0104509 <page2kva+0x4a>
c01044e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044ed:	c7 44 24 08 5c c7 10 	movl   $0xc010c75c,0x8(%esp)
c01044f4:	c0 
c01044f5:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01044fc:	00 
c01044fd:	c7 04 24 4b c7 10 c0 	movl   $0xc010c74b,(%esp)
c0104504:	e8 cc c8 ff ff       	call   c0100dd5 <__panic>
c0104509:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010450c:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104511:	c9                   	leave  
c0104512:	c3                   	ret    

c0104513 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0104513:	55                   	push   %ebp
c0104514:	89 e5                	mov    %esp,%ebp
c0104516:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104519:	8b 45 08             	mov    0x8(%ebp),%eax
c010451c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010451f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104526:	77 23                	ja     c010454b <kva2page+0x38>
c0104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010452f:	c7 44 24 08 80 c7 10 	movl   $0xc010c780,0x8(%esp)
c0104536:	c0 
c0104537:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010453e:	00 
c010453f:	c7 04 24 4b c7 10 c0 	movl   $0xc010c74b,(%esp)
c0104546:	e8 8a c8 ff ff       	call   c0100dd5 <__panic>
c010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010454e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104553:	89 04 24             	mov    %eax,(%esp)
c0104556:	e8 1f ff ff ff       	call   c010447a <pa2page>
}
c010455b:	c9                   	leave  
c010455c:	c3                   	ret    

c010455d <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c010455d:	55                   	push   %ebp
c010455e:	89 e5                	mov    %esp,%ebp
c0104560:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c0104563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104566:	ba 01 00 00 00       	mov    $0x1,%edx
c010456b:	89 c1                	mov    %eax,%ecx
c010456d:	d3 e2                	shl    %cl,%edx
c010456f:	89 d0                	mov    %edx,%eax
c0104571:	89 04 24             	mov    %eax,(%esp)
c0104574:	e8 07 09 00 00       	call   c0104e80 <alloc_pages>
c0104579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c010457c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104580:	75 07                	jne    c0104589 <__slob_get_free_pages+0x2c>
    return NULL;
c0104582:	b8 00 00 00 00       	mov    $0x0,%eax
c0104587:	eb 0b                	jmp    c0104594 <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458c:	89 04 24             	mov    %eax,(%esp)
c010458f:	e8 2b ff ff ff       	call   c01044bf <page2kva>
}
c0104594:	c9                   	leave  
c0104595:	c3                   	ret    

c0104596 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c0104596:	55                   	push   %ebp
c0104597:	89 e5                	mov    %esp,%ebp
c0104599:	53                   	push   %ebx
c010459a:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c010459d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a0:	ba 01 00 00 00       	mov    $0x1,%edx
c01045a5:	89 c1                	mov    %eax,%ecx
c01045a7:	d3 e2                	shl    %cl,%edx
c01045a9:	89 d0                	mov    %edx,%eax
c01045ab:	89 c3                	mov    %eax,%ebx
c01045ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b0:	89 04 24             	mov    %eax,(%esp)
c01045b3:	e8 5b ff ff ff       	call   c0104513 <kva2page>
c01045b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01045bc:	89 04 24             	mov    %eax,(%esp)
c01045bf:	e8 27 09 00 00       	call   c0104eeb <free_pages>
}
c01045c4:	83 c4 14             	add    $0x14,%esp
c01045c7:	5b                   	pop    %ebx
c01045c8:	5d                   	pop    %ebp
c01045c9:	c3                   	ret    

c01045ca <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01045ca:	55                   	push   %ebp
c01045cb:	89 e5                	mov    %esp,%ebp
c01045cd:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01045d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d3:	83 c0 08             	add    $0x8,%eax
c01045d6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01045db:	76 24                	jbe    c0104601 <slob_alloc+0x37>
c01045dd:	c7 44 24 0c a4 c7 10 	movl   $0xc010c7a4,0xc(%esp)
c01045e4:	c0 
c01045e5:	c7 44 24 08 c3 c7 10 	movl   $0xc010c7c3,0x8(%esp)
c01045ec:	c0 
c01045ed:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01045f4:	00 
c01045f5:	c7 04 24 d8 c7 10 c0 	movl   $0xc010c7d8,(%esp)
c01045fc:	e8 d4 c7 ff ff       	call   c0100dd5 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104601:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104608:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010460f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104612:	83 c0 07             	add    $0x7,%eax
c0104615:	c1 e8 03             	shr    $0x3,%eax
c0104618:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c010461b:	e8 f3 fd ff ff       	call   c0104413 <__intr_save>
c0104620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104623:	a1 08 9a 12 c0       	mov    0xc0129a08,%eax
c0104628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c010462b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462e:	8b 40 04             	mov    0x4(%eax),%eax
c0104631:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104634:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104638:	74 25                	je     c010465f <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c010463a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010463d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104640:	01 d0                	add    %edx,%eax
c0104642:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104645:	8b 45 10             	mov    0x10(%ebp),%eax
c0104648:	f7 d8                	neg    %eax
c010464a:	21 d0                	and    %edx,%eax
c010464c:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c010464f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104652:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104655:	29 c2                	sub    %eax,%edx
c0104657:	89 d0                	mov    %edx,%eax
c0104659:	c1 f8 03             	sar    $0x3,%eax
c010465c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c010465f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104662:	8b 00                	mov    (%eax),%eax
c0104664:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010466a:	01 ca                	add    %ecx,%edx
c010466c:	39 d0                	cmp    %edx,%eax
c010466e:	0f 8c aa 00 00 00    	jl     c010471e <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c0104674:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104678:	74 38                	je     c01046b2 <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c010467a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010467d:	8b 00                	mov    (%eax),%eax
c010467f:	2b 45 e8             	sub    -0x18(%ebp),%eax
c0104682:	89 c2                	mov    %eax,%edx
c0104684:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104687:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104689:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010468c:	8b 50 04             	mov    0x4(%eax),%edx
c010468f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104692:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104695:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104698:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010469b:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c010469e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01046a4:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01046a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01046ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01046b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b5:	8b 00                	mov    (%eax),%eax
c01046b7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01046ba:	75 0e                	jne    c01046ca <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c01046bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046bf:	8b 50 04             	mov    0x4(%eax),%edx
c01046c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c5:	89 50 04             	mov    %edx,0x4(%eax)
c01046c8:	eb 3c                	jmp    c0104706 <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c01046ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01046cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01046d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d7:	01 c2                	add    %eax,%edx
c01046d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046dc:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01046df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e2:	8b 40 04             	mov    0x4(%eax),%eax
c01046e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046e8:	8b 12                	mov    (%edx),%edx
c01046ea:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01046ed:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01046ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f2:	8b 40 04             	mov    0x4(%eax),%eax
c01046f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01046f8:	8b 52 04             	mov    0x4(%edx),%edx
c01046fb:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01046fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104701:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104704:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104709:	a3 08 9a 12 c0       	mov    %eax,0xc0129a08
			spin_unlock_irqrestore(&slob_lock, flags);
c010470e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104711:	89 04 24             	mov    %eax,(%esp)
c0104714:	e8 24 fd ff ff       	call   c010443d <__intr_restore>
			return cur;
c0104719:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471c:	eb 7f                	jmp    c010479d <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c010471e:	a1 08 9a 12 c0       	mov    0xc0129a08,%eax
c0104723:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104726:	75 61                	jne    c0104789 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010472b:	89 04 24             	mov    %eax,(%esp)
c010472e:	e8 0a fd ff ff       	call   c010443d <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104733:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010473a:	75 07                	jne    c0104743 <slob_alloc+0x179>
				return 0;
c010473c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104741:	eb 5a                	jmp    c010479d <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104743:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010474a:	00 
c010474b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010474e:	89 04 24             	mov    %eax,(%esp)
c0104751:	e8 07 fe ff ff       	call   c010455d <__slob_get_free_pages>
c0104756:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010475d:	75 07                	jne    c0104766 <slob_alloc+0x19c>
				return 0;
c010475f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104764:	eb 37                	jmp    c010479d <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c0104766:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010476d:	00 
c010476e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104771:	89 04 24             	mov    %eax,(%esp)
c0104774:	e8 26 00 00 00       	call   c010479f <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104779:	e8 95 fc ff ff       	call   c0104413 <__intr_save>
c010477e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104781:	a1 08 9a 12 c0       	mov    0xc0129a08,%eax
c0104786:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104789:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010478c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010478f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104792:	8b 40 04             	mov    0x4(%eax),%eax
c0104795:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104798:	e9 97 fe ff ff       	jmp    c0104634 <slob_alloc+0x6a>
}
c010479d:	c9                   	leave  
c010479e:	c3                   	ret    

c010479f <slob_free>:

static void slob_free(void *block, int size)
{
c010479f:	55                   	push   %ebp
c01047a0:	89 e5                	mov    %esp,%ebp
c01047a2:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c01047a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01047ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01047af:	75 05                	jne    c01047b6 <slob_free+0x17>
		return;
c01047b1:	e9 ff 00 00 00       	jmp    c01048b5 <slob_free+0x116>

	if (size)
c01047b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01047ba:	74 10                	je     c01047cc <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c01047bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047bf:	83 c0 07             	add    $0x7,%eax
c01047c2:	c1 e8 03             	shr    $0x3,%eax
c01047c5:	89 c2                	mov    %eax,%edx
c01047c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ca:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c01047cc:	e8 42 fc ff ff       	call   c0104413 <__intr_save>
c01047d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01047d4:	a1 08 9a 12 c0       	mov    0xc0129a08,%eax
c01047d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047dc:	eb 27                	jmp    c0104805 <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e1:	8b 40 04             	mov    0x4(%eax),%eax
c01047e4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047e7:	77 13                	ja     c01047fc <slob_free+0x5d>
c01047e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047ef:	77 27                	ja     c0104818 <slob_free+0x79>
c01047f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047f4:	8b 40 04             	mov    0x4(%eax),%eax
c01047f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047fa:	77 1c                	ja     c0104818 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01047fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047ff:	8b 40 04             	mov    0x4(%eax),%eax
c0104802:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104805:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104808:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010480b:	76 d1                	jbe    c01047de <slob_free+0x3f>
c010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104810:	8b 40 04             	mov    0x4(%eax),%eax
c0104813:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104816:	76 c6                	jbe    c01047de <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104818:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010481b:	8b 00                	mov    (%eax),%eax
c010481d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104824:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104827:	01 c2                	add    %eax,%edx
c0104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482c:	8b 40 04             	mov    0x4(%eax),%eax
c010482f:	39 c2                	cmp    %eax,%edx
c0104831:	75 25                	jne    c0104858 <slob_free+0xb9>
		b->units += cur->next->units;
c0104833:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104836:	8b 10                	mov    (%eax),%edx
c0104838:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483b:	8b 40 04             	mov    0x4(%eax),%eax
c010483e:	8b 00                	mov    (%eax),%eax
c0104840:	01 c2                	add    %eax,%edx
c0104842:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104845:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104847:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010484a:	8b 40 04             	mov    0x4(%eax),%eax
c010484d:	8b 50 04             	mov    0x4(%eax),%edx
c0104850:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104853:	89 50 04             	mov    %edx,0x4(%eax)
c0104856:	eb 0c                	jmp    c0104864 <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104858:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485b:	8b 50 04             	mov    0x4(%eax),%edx
c010485e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104861:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104864:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104867:	8b 00                	mov    (%eax),%eax
c0104869:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104870:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104873:	01 d0                	add    %edx,%eax
c0104875:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104878:	75 1f                	jne    c0104899 <slob_free+0xfa>
		cur->units += b->units;
c010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487d:	8b 10                	mov    (%eax),%edx
c010487f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104882:	8b 00                	mov    (%eax),%eax
c0104884:	01 c2                	add    %eax,%edx
c0104886:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104889:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c010488b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010488e:	8b 50 04             	mov    0x4(%eax),%edx
c0104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104894:	89 50 04             	mov    %edx,0x4(%eax)
c0104897:	eb 09                	jmp    c01048a2 <slob_free+0x103>
	} else
		cur->next = b;
c0104899:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010489c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010489f:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c01048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a5:	a3 08 9a 12 c0       	mov    %eax,0xc0129a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01048aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048ad:	89 04 24             	mov    %eax,(%esp)
c01048b0:	e8 88 fb ff ff       	call   c010443d <__intr_restore>
}
c01048b5:	c9                   	leave  
c01048b6:	c3                   	ret    

c01048b7 <slob_init>:



void
slob_init(void) {
c01048b7:	55                   	push   %ebp
c01048b8:	89 e5                	mov    %esp,%ebp
c01048ba:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01048bd:	c7 04 24 ea c7 10 c0 	movl   $0xc010c7ea,(%esp)
c01048c4:	e8 8a ba ff ff       	call   c0100353 <cprintf>
}
c01048c9:	c9                   	leave  
c01048ca:	c3                   	ret    

c01048cb <kmalloc_init>:

inline void 
kmalloc_init(void) {
c01048cb:	55                   	push   %ebp
c01048cc:	89 e5                	mov    %esp,%ebp
c01048ce:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c01048d1:	e8 e1 ff ff ff       	call   c01048b7 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c01048d6:	c7 04 24 fe c7 10 c0 	movl   $0xc010c7fe,(%esp)
c01048dd:	e8 71 ba ff ff       	call   c0100353 <cprintf>
}
c01048e2:	c9                   	leave  
c01048e3:	c3                   	ret    

c01048e4 <slob_allocated>:

size_t
slob_allocated(void) {
c01048e4:	55                   	push   %ebp
c01048e5:	89 e5                	mov    %esp,%ebp
  return 0;
c01048e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048ec:	5d                   	pop    %ebp
c01048ed:	c3                   	ret    

c01048ee <kallocated>:

size_t
kallocated(void) {
c01048ee:	55                   	push   %ebp
c01048ef:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c01048f1:	e8 ee ff ff ff       	call   c01048e4 <slob_allocated>
}
c01048f6:	5d                   	pop    %ebp
c01048f7:	c3                   	ret    

c01048f8 <find_order>:

static int find_order(int size)
{
c01048f8:	55                   	push   %ebp
c01048f9:	89 e5                	mov    %esp,%ebp
c01048fb:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c01048fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104905:	eb 07                	jmp    c010490e <find_order+0x16>
		order++;
c0104907:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c010490b:	d1 7d 08             	sarl   0x8(%ebp)
c010490e:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104915:	7f f0                	jg     c0104907 <find_order+0xf>
		order++;
	return order;
c0104917:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010491a:	c9                   	leave  
c010491b:	c3                   	ret    

c010491c <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c010491c:	55                   	push   %ebp
c010491d:	89 e5                	mov    %esp,%ebp
c010491f:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104922:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104929:	77 38                	ja     c0104963 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c010492b:	8b 45 08             	mov    0x8(%ebp),%eax
c010492e:	8d 50 08             	lea    0x8(%eax),%edx
c0104931:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104938:	00 
c0104939:	8b 45 0c             	mov    0xc(%ebp),%eax
c010493c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104940:	89 14 24             	mov    %edx,(%esp)
c0104943:	e8 82 fc ff ff       	call   c01045ca <slob_alloc>
c0104948:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c010494b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010494f:	74 08                	je     c0104959 <__kmalloc+0x3d>
c0104951:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104954:	83 c0 08             	add    $0x8,%eax
c0104957:	eb 05                	jmp    c010495e <__kmalloc+0x42>
c0104959:	b8 00 00 00 00       	mov    $0x0,%eax
c010495e:	e9 a6 00 00 00       	jmp    c0104a09 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104963:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010496a:	00 
c010496b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010496e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104972:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104979:	e8 4c fc ff ff       	call   c01045ca <slob_alloc>
c010497e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104981:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104985:	75 07                	jne    c010498e <__kmalloc+0x72>
		return 0;
c0104987:	b8 00 00 00 00       	mov    $0x0,%eax
c010498c:	eb 7b                	jmp    c0104a09 <__kmalloc+0xed>

	bb->order = find_order(size);
c010498e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104991:	89 04 24             	mov    %eax,(%esp)
c0104994:	e8 5f ff ff ff       	call   c01048f8 <find_order>
c0104999:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010499c:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c010499e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a1:	8b 00                	mov    (%eax),%eax
c01049a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049aa:	89 04 24             	mov    %eax,(%esp)
c01049ad:	e8 ab fb ff ff       	call   c010455d <__slob_get_free_pages>
c01049b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049b5:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c01049b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049bb:	8b 40 04             	mov    0x4(%eax),%eax
c01049be:	85 c0                	test   %eax,%eax
c01049c0:	74 2f                	je     c01049f1 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c01049c2:	e8 4c fa ff ff       	call   c0104413 <__intr_save>
c01049c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01049ca:	8b 15 c4 be 19 c0    	mov    0xc019bec4,%edx
c01049d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d3:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01049d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d9:	a3 c4 be 19 c0       	mov    %eax,0xc019bec4
		spin_unlock_irqrestore(&block_lock, flags);
c01049de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049e1:	89 04 24             	mov    %eax,(%esp)
c01049e4:	e8 54 fa ff ff       	call   c010443d <__intr_restore>
		return bb->pages;
c01049e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049ec:	8b 40 04             	mov    0x4(%eax),%eax
c01049ef:	eb 18                	jmp    c0104a09 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01049f1:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01049f8:	00 
c01049f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049fc:	89 04 24             	mov    %eax,(%esp)
c01049ff:	e8 9b fd ff ff       	call   c010479f <slob_free>
	return 0;
c0104a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a09:	c9                   	leave  
c0104a0a:	c3                   	ret    

c0104a0b <kmalloc>:

void *
kmalloc(size_t size)
{
c0104a0b:	55                   	push   %ebp
c0104a0c:	89 e5                	mov    %esp,%ebp
c0104a0e:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104a11:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a18:	00 
c0104a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a1c:	89 04 24             	mov    %eax,(%esp)
c0104a1f:	e8 f8 fe ff ff       	call   c010491c <__kmalloc>
}
c0104a24:	c9                   	leave  
c0104a25:	c3                   	ret    

c0104a26 <kfree>:


void kfree(void *block)
{
c0104a26:	55                   	push   %ebp
c0104a27:	89 e5                	mov    %esp,%ebp
c0104a29:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104a2c:	c7 45 f0 c4 be 19 c0 	movl   $0xc019bec4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104a33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a37:	75 05                	jne    c0104a3e <kfree+0x18>
		return;
c0104a39:	e9 a2 00 00 00       	jmp    c0104ae0 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104a3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a41:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a46:	85 c0                	test   %eax,%eax
c0104a48:	75 7f                	jne    c0104ac9 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104a4a:	e8 c4 f9 ff ff       	call   c0104413 <__intr_save>
c0104a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104a52:	a1 c4 be 19 c0       	mov    0xc019bec4,%eax
c0104a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a5a:	eb 5c                	jmp    c0104ab8 <kfree+0x92>
			if (bb->pages == block) {
c0104a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a5f:	8b 40 04             	mov    0x4(%eax),%eax
c0104a62:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a65:	75 3f                	jne    c0104aa6 <kfree+0x80>
				*last = bb->next;
c0104a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a6a:	8b 50 08             	mov    0x8(%eax),%edx
c0104a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a70:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a75:	89 04 24             	mov    %eax,(%esp)
c0104a78:	e8 c0 f9 ff ff       	call   c010443d <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a80:	8b 10                	mov    (%eax),%edx
c0104a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a85:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a89:	89 04 24             	mov    %eax,(%esp)
c0104a8c:	e8 05 fb ff ff       	call   c0104596 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104a91:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104a98:	00 
c0104a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a9c:	89 04 24             	mov    %eax,(%esp)
c0104a9f:	e8 fb fc ff ff       	call   c010479f <slob_free>
				return;
c0104aa4:	eb 3a                	jmp    c0104ae0 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa9:	83 c0 08             	add    $0x8,%eax
c0104aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab2:	8b 40 08             	mov    0x8(%eax),%eax
c0104ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104abc:	75 9e                	jne    c0104a5c <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ac1:	89 04 24             	mov    %eax,(%esp)
c0104ac4:	e8 74 f9 ff ff       	call   c010443d <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104acc:	83 e8 08             	sub    $0x8,%eax
c0104acf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ad6:	00 
c0104ad7:	89 04 24             	mov    %eax,(%esp)
c0104ada:	e8 c0 fc ff ff       	call   c010479f <slob_free>
	return;
c0104adf:	90                   	nop
}
c0104ae0:	c9                   	leave  
c0104ae1:	c3                   	ret    

c0104ae2 <ksize>:


unsigned int ksize(const void *block)
{
c0104ae2:	55                   	push   %ebp
c0104ae3:	89 e5                	mov    %esp,%ebp
c0104ae5:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104aec:	75 07                	jne    c0104af5 <ksize+0x13>
		return 0;
c0104aee:	b8 00 00 00 00       	mov    $0x0,%eax
c0104af3:	eb 6b                	jmp    c0104b60 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104af8:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104afd:	85 c0                	test   %eax,%eax
c0104aff:	75 54                	jne    c0104b55 <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c0104b01:	e8 0d f9 ff ff       	call   c0104413 <__intr_save>
c0104b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104b09:	a1 c4 be 19 c0       	mov    0xc019bec4,%eax
c0104b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b11:	eb 31                	jmp    c0104b44 <ksize+0x62>
			if (bb->pages == block) {
c0104b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b16:	8b 40 04             	mov    0x4(%eax),%eax
c0104b19:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b1c:	75 1d                	jne    c0104b3b <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b21:	89 04 24             	mov    %eax,(%esp)
c0104b24:	e8 14 f9 ff ff       	call   c010443d <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b2c:	8b 00                	mov    (%eax),%eax
c0104b2e:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104b33:	89 c1                	mov    %eax,%ecx
c0104b35:	d3 e2                	shl    %cl,%edx
c0104b37:	89 d0                	mov    %edx,%eax
c0104b39:	eb 25                	jmp    c0104b60 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b3e:	8b 40 08             	mov    0x8(%eax),%eax
c0104b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b48:	75 c9                	jne    c0104b13 <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b4d:	89 04 24             	mov    %eax,(%esp)
c0104b50:	e8 e8 f8 ff ff       	call   c010443d <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b58:	83 e8 08             	sub    $0x8,%eax
c0104b5b:	8b 00                	mov    (%eax),%eax
c0104b5d:	c1 e0 03             	shl    $0x3,%eax
}
c0104b60:	c9                   	leave  
c0104b61:	c3                   	ret    

c0104b62 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104b62:	55                   	push   %ebp
c0104b63:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104b65:	8b 55 08             	mov    0x8(%ebp),%edx
c0104b68:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0104b6d:	29 c2                	sub    %eax,%edx
c0104b6f:	89 d0                	mov    %edx,%eax
c0104b71:	c1 f8 05             	sar    $0x5,%eax
}
c0104b74:	5d                   	pop    %ebp
c0104b75:	c3                   	ret    

c0104b76 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104b76:	55                   	push   %ebp
c0104b77:	89 e5                	mov    %esp,%ebp
c0104b79:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b7f:	89 04 24             	mov    %eax,(%esp)
c0104b82:	e8 db ff ff ff       	call   c0104b62 <page2ppn>
c0104b87:	c1 e0 0c             	shl    $0xc,%eax
}
c0104b8a:	c9                   	leave  
c0104b8b:	c3                   	ret    

c0104b8c <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104b8c:	55                   	push   %ebp
c0104b8d:	89 e5                	mov    %esp,%ebp
c0104b8f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104b92:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b95:	c1 e8 0c             	shr    $0xc,%eax
c0104b98:	89 c2                	mov    %eax,%edx
c0104b9a:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0104b9f:	39 c2                	cmp    %eax,%edx
c0104ba1:	72 1c                	jb     c0104bbf <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104ba3:	c7 44 24 08 1c c8 10 	movl   $0xc010c81c,0x8(%esp)
c0104baa:	c0 
c0104bab:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104bb2:	00 
c0104bb3:	c7 04 24 3b c8 10 c0 	movl   $0xc010c83b,(%esp)
c0104bba:	e8 16 c2 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104bbf:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0104bc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bc7:	c1 ea 0c             	shr    $0xc,%edx
c0104bca:	c1 e2 05             	shl    $0x5,%edx
c0104bcd:	01 d0                	add    %edx,%eax
}
c0104bcf:	c9                   	leave  
c0104bd0:	c3                   	ret    

c0104bd1 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104bd1:	55                   	push   %ebp
c0104bd2:	89 e5                	mov    %esp,%ebp
c0104bd4:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bda:	89 04 24             	mov    %eax,(%esp)
c0104bdd:	e8 94 ff ff ff       	call   c0104b76 <page2pa>
c0104be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104be8:	c1 e8 0c             	shr    $0xc,%eax
c0104beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104bee:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0104bf3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104bf6:	72 23                	jb     c0104c1b <page2kva+0x4a>
c0104bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bfb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104bff:	c7 44 24 08 4c c8 10 	movl   $0xc010c84c,0x8(%esp)
c0104c06:	c0 
c0104c07:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104c0e:	00 
c0104c0f:	c7 04 24 3b c8 10 c0 	movl   $0xc010c83b,(%esp)
c0104c16:	e8 ba c1 ff ff       	call   c0100dd5 <__panic>
c0104c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c1e:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104c23:	c9                   	leave  
c0104c24:	c3                   	ret    

c0104c25 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104c25:	55                   	push   %ebp
c0104c26:	89 e5                	mov    %esp,%ebp
c0104c28:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104c2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c2e:	83 e0 01             	and    $0x1,%eax
c0104c31:	85 c0                	test   %eax,%eax
c0104c33:	75 1c                	jne    c0104c51 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104c35:	c7 44 24 08 70 c8 10 	movl   $0xc010c870,0x8(%esp)
c0104c3c:	c0 
c0104c3d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104c44:	00 
c0104c45:	c7 04 24 3b c8 10 c0 	movl   $0xc010c83b,(%esp)
c0104c4c:	e8 84 c1 ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c59:	89 04 24             	mov    %eax,(%esp)
c0104c5c:	e8 2b ff ff ff       	call   c0104b8c <pa2page>
}
c0104c61:	c9                   	leave  
c0104c62:	c3                   	ret    

c0104c63 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104c63:	55                   	push   %ebp
c0104c64:	89 e5                	mov    %esp,%ebp
c0104c66:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104c69:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c71:	89 04 24             	mov    %eax,(%esp)
c0104c74:	e8 13 ff ff ff       	call   c0104b8c <pa2page>
}
c0104c79:	c9                   	leave  
c0104c7a:	c3                   	ret    

c0104c7b <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104c7b:	55                   	push   %ebp
c0104c7c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c81:	8b 00                	mov    (%eax),%eax
}
c0104c83:	5d                   	pop    %ebp
c0104c84:	c3                   	ret    

c0104c85 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104c85:	55                   	push   %ebp
c0104c86:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104c88:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c8e:	89 10                	mov    %edx,(%eax)
}
c0104c90:	5d                   	pop    %ebp
c0104c91:	c3                   	ret    

c0104c92 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104c92:	55                   	push   %ebp
c0104c93:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c98:	8b 00                	mov    (%eax),%eax
c0104c9a:	8d 50 01             	lea    0x1(%eax),%edx
c0104c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca0:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ca5:	8b 00                	mov    (%eax),%eax
}
c0104ca7:	5d                   	pop    %ebp
c0104ca8:	c3                   	ret    

c0104ca9 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104ca9:	55                   	push   %ebp
c0104caa:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104cac:	8b 45 08             	mov    0x8(%ebp),%eax
c0104caf:	8b 00                	mov    (%eax),%eax
c0104cb1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cb7:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cbc:	8b 00                	mov    (%eax),%eax
}
c0104cbe:	5d                   	pop    %ebp
c0104cbf:	c3                   	ret    

c0104cc0 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104cc0:	55                   	push   %ebp
c0104cc1:	89 e5                	mov    %esp,%ebp
c0104cc3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104cc6:	9c                   	pushf  
c0104cc7:	58                   	pop    %eax
c0104cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104cce:	25 00 02 00 00       	and    $0x200,%eax
c0104cd3:	85 c0                	test   %eax,%eax
c0104cd5:	74 0c                	je     c0104ce3 <__intr_save+0x23>
        intr_disable();
c0104cd7:	e8 51 d3 ff ff       	call   c010202d <intr_disable>
        return 1;
c0104cdc:	b8 01 00 00 00       	mov    $0x1,%eax
c0104ce1:	eb 05                	jmp    c0104ce8 <__intr_save+0x28>
    }
    return 0;
c0104ce3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ce8:	c9                   	leave  
c0104ce9:	c3                   	ret    

c0104cea <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104cea:	55                   	push   %ebp
c0104ceb:	89 e5                	mov    %esp,%ebp
c0104ced:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104cf0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104cf4:	74 05                	je     c0104cfb <__intr_restore+0x11>
        intr_enable();
c0104cf6:	e8 2c d3 ff ff       	call   c0102027 <intr_enable>
    }
}
c0104cfb:	c9                   	leave  
c0104cfc:	c3                   	ret    

c0104cfd <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104cfd:	55                   	push   %ebp
c0104cfe:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104d00:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d03:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104d06:	b8 23 00 00 00       	mov    $0x23,%eax
c0104d0b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104d0d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104d12:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104d14:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d19:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104d1b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d20:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104d22:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d27:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104d29:	ea 30 4d 10 c0 08 00 	ljmp   $0x8,$0xc0104d30
}
c0104d30:	5d                   	pop    %ebp
c0104d31:	c3                   	ret    

c0104d32 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104d32:	55                   	push   %ebp
c0104d33:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d38:	a3 04 bf 19 c0       	mov    %eax,0xc019bf04
}
c0104d3d:	5d                   	pop    %ebp
c0104d3e:	c3                   	ret    

c0104d3f <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104d3f:	55                   	push   %ebp
c0104d40:	89 e5                	mov    %esp,%ebp
c0104d42:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104d45:	b8 00 90 12 c0       	mov    $0xc0129000,%eax
c0104d4a:	89 04 24             	mov    %eax,(%esp)
c0104d4d:	e8 e0 ff ff ff       	call   c0104d32 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104d52:	66 c7 05 08 bf 19 c0 	movw   $0x10,0xc019bf08
c0104d59:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104d5b:	66 c7 05 48 9a 12 c0 	movw   $0x68,0xc0129a48
c0104d62:	68 00 
c0104d64:	b8 00 bf 19 c0       	mov    $0xc019bf00,%eax
c0104d69:	66 a3 4a 9a 12 c0    	mov    %ax,0xc0129a4a
c0104d6f:	b8 00 bf 19 c0       	mov    $0xc019bf00,%eax
c0104d74:	c1 e8 10             	shr    $0x10,%eax
c0104d77:	a2 4c 9a 12 c0       	mov    %al,0xc0129a4c
c0104d7c:	0f b6 05 4d 9a 12 c0 	movzbl 0xc0129a4d,%eax
c0104d83:	83 e0 f0             	and    $0xfffffff0,%eax
c0104d86:	83 c8 09             	or     $0x9,%eax
c0104d89:	a2 4d 9a 12 c0       	mov    %al,0xc0129a4d
c0104d8e:	0f b6 05 4d 9a 12 c0 	movzbl 0xc0129a4d,%eax
c0104d95:	83 e0 ef             	and    $0xffffffef,%eax
c0104d98:	a2 4d 9a 12 c0       	mov    %al,0xc0129a4d
c0104d9d:	0f b6 05 4d 9a 12 c0 	movzbl 0xc0129a4d,%eax
c0104da4:	83 e0 9f             	and    $0xffffff9f,%eax
c0104da7:	a2 4d 9a 12 c0       	mov    %al,0xc0129a4d
c0104dac:	0f b6 05 4d 9a 12 c0 	movzbl 0xc0129a4d,%eax
c0104db3:	83 c8 80             	or     $0xffffff80,%eax
c0104db6:	a2 4d 9a 12 c0       	mov    %al,0xc0129a4d
c0104dbb:	0f b6 05 4e 9a 12 c0 	movzbl 0xc0129a4e,%eax
c0104dc2:	83 e0 f0             	and    $0xfffffff0,%eax
c0104dc5:	a2 4e 9a 12 c0       	mov    %al,0xc0129a4e
c0104dca:	0f b6 05 4e 9a 12 c0 	movzbl 0xc0129a4e,%eax
c0104dd1:	83 e0 ef             	and    $0xffffffef,%eax
c0104dd4:	a2 4e 9a 12 c0       	mov    %al,0xc0129a4e
c0104dd9:	0f b6 05 4e 9a 12 c0 	movzbl 0xc0129a4e,%eax
c0104de0:	83 e0 df             	and    $0xffffffdf,%eax
c0104de3:	a2 4e 9a 12 c0       	mov    %al,0xc0129a4e
c0104de8:	0f b6 05 4e 9a 12 c0 	movzbl 0xc0129a4e,%eax
c0104def:	83 c8 40             	or     $0x40,%eax
c0104df2:	a2 4e 9a 12 c0       	mov    %al,0xc0129a4e
c0104df7:	0f b6 05 4e 9a 12 c0 	movzbl 0xc0129a4e,%eax
c0104dfe:	83 e0 7f             	and    $0x7f,%eax
c0104e01:	a2 4e 9a 12 c0       	mov    %al,0xc0129a4e
c0104e06:	b8 00 bf 19 c0       	mov    $0xc019bf00,%eax
c0104e0b:	c1 e8 18             	shr    $0x18,%eax
c0104e0e:	a2 4f 9a 12 c0       	mov    %al,0xc0129a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104e13:	c7 04 24 50 9a 12 c0 	movl   $0xc0129a50,(%esp)
c0104e1a:	e8 de fe ff ff       	call   c0104cfd <lgdt>
c0104e1f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104e25:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104e29:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104e2c:	c9                   	leave  
c0104e2d:	c3                   	ret    

c0104e2e <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104e2e:	55                   	push   %ebp
c0104e2f:	89 e5                	mov    %esp,%ebp
c0104e31:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104e34:	c7 05 c4 df 19 c0 10 	movl   $0xc010c710,0xc019dfc4
c0104e3b:	c7 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104e3e:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104e43:	8b 00                	mov    (%eax),%eax
c0104e45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e49:	c7 04 24 9c c8 10 c0 	movl   $0xc010c89c,(%esp)
c0104e50:	e8 fe b4 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104e55:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104e5a:	8b 40 04             	mov    0x4(%eax),%eax
c0104e5d:	ff d0                	call   *%eax
}
c0104e5f:	c9                   	leave  
c0104e60:	c3                   	ret    

c0104e61 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104e61:	55                   	push   %ebp
c0104e62:	89 e5                	mov    %esp,%ebp
c0104e64:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104e67:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104e6c:	8b 40 08             	mov    0x8(%eax),%eax
c0104e6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104e72:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e76:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e79:	89 14 24             	mov    %edx,(%esp)
c0104e7c:	ff d0                	call   *%eax
}
c0104e7e:	c9                   	leave  
c0104e7f:	c3                   	ret    

c0104e80 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104e80:	55                   	push   %ebp
c0104e81:	89 e5                	mov    %esp,%ebp
c0104e83:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104e86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104e8d:	e8 2e fe ff ff       	call   c0104cc0 <__intr_save>
c0104e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104e95:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104e9a:	8b 40 0c             	mov    0xc(%eax),%eax
c0104e9d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ea0:	89 14 24             	mov    %edx,(%esp)
c0104ea3:	ff d0                	call   *%eax
c0104ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104eab:	89 04 24             	mov    %eax,(%esp)
c0104eae:	e8 37 fe ff ff       	call   c0104cea <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104eb7:	75 2d                	jne    c0104ee6 <alloc_pages+0x66>
c0104eb9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104ebd:	77 27                	ja     c0104ee6 <alloc_pages+0x66>
c0104ebf:	a1 6c bf 19 c0       	mov    0xc019bf6c,%eax
c0104ec4:	85 c0                	test   %eax,%eax
c0104ec6:	74 1e                	je     c0104ee6 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104ec8:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ecb:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c0104ed0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ed7:	00 
c0104ed8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104edc:	89 04 24             	mov    %eax,(%esp)
c0104edf:	e8 a6 1d 00 00       	call   c0106c8a <swap_out>
    }
c0104ee4:	eb a7                	jmp    c0104e8d <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104ee9:	c9                   	leave  
c0104eea:	c3                   	ret    

c0104eeb <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104eeb:	55                   	push   %ebp
c0104eec:	89 e5                	mov    %esp,%ebp
c0104eee:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104ef1:	e8 ca fd ff ff       	call   c0104cc0 <__intr_save>
c0104ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104ef9:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104efe:	8b 40 10             	mov    0x10(%eax),%eax
c0104f01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f04:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f08:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f0b:	89 14 24             	mov    %edx,(%esp)
c0104f0e:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f13:	89 04 24             	mov    %eax,(%esp)
c0104f16:	e8 cf fd ff ff       	call   c0104cea <__intr_restore>
}
c0104f1b:	c9                   	leave  
c0104f1c:	c3                   	ret    

c0104f1d <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104f1d:	55                   	push   %ebp
c0104f1e:	89 e5                	mov    %esp,%ebp
c0104f20:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104f23:	e8 98 fd ff ff       	call   c0104cc0 <__intr_save>
c0104f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104f2b:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0104f30:	8b 40 14             	mov    0x14(%eax),%eax
c0104f33:	ff d0                	call   *%eax
c0104f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f3b:	89 04 24             	mov    %eax,(%esp)
c0104f3e:	e8 a7 fd ff ff       	call   c0104cea <__intr_restore>
    return ret;
c0104f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104f46:	c9                   	leave  
c0104f47:	c3                   	ret    

c0104f48 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104f48:	55                   	push   %ebp
c0104f49:	89 e5                	mov    %esp,%ebp
c0104f4b:	57                   	push   %edi
c0104f4c:	56                   	push   %esi
c0104f4d:	53                   	push   %ebx
c0104f4e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104f54:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104f5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104f62:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104f69:	c7 04 24 b3 c8 10 c0 	movl   $0xc010c8b3,(%esp)
c0104f70:	e8 de b3 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104f7c:	e9 15 01 00 00       	jmp    c0105096 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104f81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f87:	89 d0                	mov    %edx,%eax
c0104f89:	c1 e0 02             	shl    $0x2,%eax
c0104f8c:	01 d0                	add    %edx,%eax
c0104f8e:	c1 e0 02             	shl    $0x2,%eax
c0104f91:	01 c8                	add    %ecx,%eax
c0104f93:	8b 50 08             	mov    0x8(%eax),%edx
c0104f96:	8b 40 04             	mov    0x4(%eax),%eax
c0104f99:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104f9c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104f9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fa2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fa5:	89 d0                	mov    %edx,%eax
c0104fa7:	c1 e0 02             	shl    $0x2,%eax
c0104faa:	01 d0                	add    %edx,%eax
c0104fac:	c1 e0 02             	shl    $0x2,%eax
c0104faf:	01 c8                	add    %ecx,%eax
c0104fb1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104fb4:	8b 58 10             	mov    0x10(%eax),%ebx
c0104fb7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104fba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104fbd:	01 c8                	add    %ecx,%eax
c0104fbf:	11 da                	adc    %ebx,%edx
c0104fc1:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104fc4:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104fc7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fcd:	89 d0                	mov    %edx,%eax
c0104fcf:	c1 e0 02             	shl    $0x2,%eax
c0104fd2:	01 d0                	add    %edx,%eax
c0104fd4:	c1 e0 02             	shl    $0x2,%eax
c0104fd7:	01 c8                	add    %ecx,%eax
c0104fd9:	83 c0 14             	add    $0x14,%eax
c0104fdc:	8b 00                	mov    (%eax),%eax
c0104fde:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104fe4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104fe7:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104fea:	83 c0 ff             	add    $0xffffffff,%eax
c0104fed:	83 d2 ff             	adc    $0xffffffff,%edx
c0104ff0:	89 c6                	mov    %eax,%esi
c0104ff2:	89 d7                	mov    %edx,%edi
c0104ff4:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ff7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ffa:	89 d0                	mov    %edx,%eax
c0104ffc:	c1 e0 02             	shl    $0x2,%eax
c0104fff:	01 d0                	add    %edx,%eax
c0105001:	c1 e0 02             	shl    $0x2,%eax
c0105004:	01 c8                	add    %ecx,%eax
c0105006:	8b 48 0c             	mov    0xc(%eax),%ecx
c0105009:	8b 58 10             	mov    0x10(%eax),%ebx
c010500c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0105012:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105016:	89 74 24 14          	mov    %esi,0x14(%esp)
c010501a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010501e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105021:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105024:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105028:	89 54 24 10          	mov    %edx,0x10(%esp)
c010502c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105030:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105034:	c7 04 24 c0 c8 10 c0 	movl   $0xc010c8c0,(%esp)
c010503b:	e8 13 b3 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0105040:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105043:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105046:	89 d0                	mov    %edx,%eax
c0105048:	c1 e0 02             	shl    $0x2,%eax
c010504b:	01 d0                	add    %edx,%eax
c010504d:	c1 e0 02             	shl    $0x2,%eax
c0105050:	01 c8                	add    %ecx,%eax
c0105052:	83 c0 14             	add    $0x14,%eax
c0105055:	8b 00                	mov    (%eax),%eax
c0105057:	83 f8 01             	cmp    $0x1,%eax
c010505a:	75 36                	jne    c0105092 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c010505c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010505f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105062:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105065:	77 2b                	ja     c0105092 <page_init+0x14a>
c0105067:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010506a:	72 05                	jb     c0105071 <page_init+0x129>
c010506c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010506f:	73 21                	jae    c0105092 <page_init+0x14a>
c0105071:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105075:	77 1b                	ja     c0105092 <page_init+0x14a>
c0105077:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010507b:	72 09                	jb     c0105086 <page_init+0x13e>
c010507d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0105084:	77 0c                	ja     c0105092 <page_init+0x14a>
                maxpa = end;
c0105086:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105089:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010508c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010508f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105092:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105096:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105099:	8b 00                	mov    (%eax),%eax
c010509b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010509e:	0f 8f dd fe ff ff    	jg     c0104f81 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01050a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050a8:	72 1d                	jb     c01050c7 <page_init+0x17f>
c01050aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050ae:	77 09                	ja     c01050b9 <page_init+0x171>
c01050b0:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01050b7:	76 0e                	jbe    c01050c7 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01050b9:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01050c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01050c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01050cd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01050d1:	c1 ea 0c             	shr    $0xc,%edx
c01050d4:	a3 e0 be 19 c0       	mov    %eax,0xc019bee0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01050d9:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01050e0:	b8 b8 e0 19 c0       	mov    $0xc019e0b8,%eax
c01050e5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01050e8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01050eb:	01 d0                	add    %edx,%eax
c01050ed:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01050f0:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01050f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01050f8:	f7 75 ac             	divl   -0x54(%ebp)
c01050fb:	89 d0                	mov    %edx,%eax
c01050fd:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105100:	29 c2                	sub    %eax,%edx
c0105102:	89 d0                	mov    %edx,%eax
c0105104:	a3 cc df 19 c0       	mov    %eax,0xc019dfcc

    for (i = 0; i < npage; i ++) {
c0105109:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105110:	eb 27                	jmp    c0105139 <page_init+0x1f1>
        SetPageReserved(pages + i);
c0105112:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0105117:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010511a:	c1 e2 05             	shl    $0x5,%edx
c010511d:	01 d0                	add    %edx,%eax
c010511f:	83 c0 04             	add    $0x4,%eax
c0105122:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0105129:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010512c:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010512f:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105132:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105135:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105139:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010513c:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0105141:	39 c2                	cmp    %eax,%edx
c0105143:	72 cd                	jb     c0105112 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105145:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c010514a:	c1 e0 05             	shl    $0x5,%eax
c010514d:	89 c2                	mov    %eax,%edx
c010514f:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0105154:	01 d0                	add    %edx,%eax
c0105156:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105159:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105160:	77 23                	ja     c0105185 <page_init+0x23d>
c0105162:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105165:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105169:	c7 44 24 08 f0 c8 10 	movl   $0xc010c8f0,0x8(%esp)
c0105170:	c0 
c0105171:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0105178:	00 
c0105179:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105180:	e8 50 bc ff ff       	call   c0100dd5 <__panic>
c0105185:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105188:	05 00 00 00 40       	add    $0x40000000,%eax
c010518d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105190:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105197:	e9 74 01 00 00       	jmp    c0105310 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010519c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010519f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051a2:	89 d0                	mov    %edx,%eax
c01051a4:	c1 e0 02             	shl    $0x2,%eax
c01051a7:	01 d0                	add    %edx,%eax
c01051a9:	c1 e0 02             	shl    $0x2,%eax
c01051ac:	01 c8                	add    %ecx,%eax
c01051ae:	8b 50 08             	mov    0x8(%eax),%edx
c01051b1:	8b 40 04             	mov    0x4(%eax),%eax
c01051b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01051b7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01051ba:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051c0:	89 d0                	mov    %edx,%eax
c01051c2:	c1 e0 02             	shl    $0x2,%eax
c01051c5:	01 d0                	add    %edx,%eax
c01051c7:	c1 e0 02             	shl    $0x2,%eax
c01051ca:	01 c8                	add    %ecx,%eax
c01051cc:	8b 48 0c             	mov    0xc(%eax),%ecx
c01051cf:	8b 58 10             	mov    0x10(%eax),%ebx
c01051d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051d8:	01 c8                	add    %ecx,%eax
c01051da:	11 da                	adc    %ebx,%edx
c01051dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01051df:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01051e2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051e8:	89 d0                	mov    %edx,%eax
c01051ea:	c1 e0 02             	shl    $0x2,%eax
c01051ed:	01 d0                	add    %edx,%eax
c01051ef:	c1 e0 02             	shl    $0x2,%eax
c01051f2:	01 c8                	add    %ecx,%eax
c01051f4:	83 c0 14             	add    $0x14,%eax
c01051f7:	8b 00                	mov    (%eax),%eax
c01051f9:	83 f8 01             	cmp    $0x1,%eax
c01051fc:	0f 85 0a 01 00 00    	jne    c010530c <page_init+0x3c4>
            if (begin < freemem) {
c0105202:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105205:	ba 00 00 00 00       	mov    $0x0,%edx
c010520a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010520d:	72 17                	jb     c0105226 <page_init+0x2de>
c010520f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105212:	77 05                	ja     c0105219 <page_init+0x2d1>
c0105214:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105217:	76 0d                	jbe    c0105226 <page_init+0x2de>
                begin = freemem;
c0105219:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010521c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010521f:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105226:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010522a:	72 1d                	jb     c0105249 <page_init+0x301>
c010522c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105230:	77 09                	ja     c010523b <page_init+0x2f3>
c0105232:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0105239:	76 0e                	jbe    c0105249 <page_init+0x301>
                end = KMEMSIZE;
c010523b:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105242:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0105249:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010524c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010524f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105252:	0f 87 b4 00 00 00    	ja     c010530c <page_init+0x3c4>
c0105258:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010525b:	72 09                	jb     c0105266 <page_init+0x31e>
c010525d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105260:	0f 83 a6 00 00 00    	jae    c010530c <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105266:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010526d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105270:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105273:	01 d0                	add    %edx,%eax
c0105275:	83 e8 01             	sub    $0x1,%eax
c0105278:	89 45 98             	mov    %eax,-0x68(%ebp)
c010527b:	8b 45 98             	mov    -0x68(%ebp),%eax
c010527e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105283:	f7 75 9c             	divl   -0x64(%ebp)
c0105286:	89 d0                	mov    %edx,%eax
c0105288:	8b 55 98             	mov    -0x68(%ebp),%edx
c010528b:	29 c2                	sub    %eax,%edx
c010528d:	89 d0                	mov    %edx,%eax
c010528f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105294:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105297:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010529a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010529d:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01052a0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01052a3:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a8:	89 c7                	mov    %eax,%edi
c01052aa:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01052b0:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01052b3:	89 d0                	mov    %edx,%eax
c01052b5:	83 e0 00             	and    $0x0,%eax
c01052b8:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01052bb:	8b 45 80             	mov    -0x80(%ebp),%eax
c01052be:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01052c1:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01052c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01052c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052ca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01052d0:	77 3a                	ja     c010530c <page_init+0x3c4>
c01052d2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01052d5:	72 05                	jb     c01052dc <page_init+0x394>
c01052d7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01052da:	73 30                	jae    c010530c <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01052dc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01052df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01052e2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01052e5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01052e8:	29 c8                	sub    %ecx,%eax
c01052ea:	19 da                	sbb    %ebx,%edx
c01052ec:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01052f0:	c1 ea 0c             	shr    $0xc,%edx
c01052f3:	89 c3                	mov    %eax,%ebx
c01052f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052f8:	89 04 24             	mov    %eax,(%esp)
c01052fb:	e8 8c f8 ff ff       	call   c0104b8c <pa2page>
c0105300:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105304:	89 04 24             	mov    %eax,(%esp)
c0105307:	e8 55 fb ff ff       	call   c0104e61 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c010530c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0105310:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105313:	8b 00                	mov    (%eax),%eax
c0105315:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105318:	0f 8f 7e fe ff ff    	jg     c010519c <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010531e:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105324:	5b                   	pop    %ebx
c0105325:	5e                   	pop    %esi
c0105326:	5f                   	pop    %edi
c0105327:	5d                   	pop    %ebp
c0105328:	c3                   	ret    

c0105329 <enable_paging>:

static void
enable_paging(void) {
c0105329:	55                   	push   %ebp
c010532a:	89 e5                	mov    %esp,%ebp
c010532c:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010532f:	a1 c8 df 19 c0       	mov    0xc019dfc8,%eax
c0105334:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105337:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010533a:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010533d:	0f 20 c0             	mov    %cr0,%eax
c0105340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105343:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105346:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105349:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105350:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105354:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105357:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010535a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010535d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105360:	c9                   	leave  
c0105361:	c3                   	ret    

c0105362 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105362:	55                   	push   %ebp
c0105363:	89 e5                	mov    %esp,%ebp
c0105365:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105368:	8b 45 14             	mov    0x14(%ebp),%eax
c010536b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010536e:	31 d0                	xor    %edx,%eax
c0105370:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105375:	85 c0                	test   %eax,%eax
c0105377:	74 24                	je     c010539d <boot_map_segment+0x3b>
c0105379:	c7 44 24 0c 22 c9 10 	movl   $0xc010c922,0xc(%esp)
c0105380:	c0 
c0105381:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105388:	c0 
c0105389:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105390:	00 
c0105391:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105398:	e8 38 ba ff ff       	call   c0100dd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010539d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01053a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053a7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01053ac:	89 c2                	mov    %eax,%edx
c01053ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01053b1:	01 c2                	add    %eax,%edx
c01053b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053b6:	01 d0                	add    %edx,%eax
c01053b8:	83 e8 01             	sub    $0x1,%eax
c01053bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01053be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01053c6:	f7 75 f0             	divl   -0x10(%ebp)
c01053c9:	89 d0                	mov    %edx,%eax
c01053cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01053ce:	29 c2                	sub    %eax,%edx
c01053d0:	89 d0                	mov    %edx,%eax
c01053d2:	c1 e8 0c             	shr    $0xc,%eax
c01053d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01053d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053db:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01053e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053e6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01053e9:	8b 45 14             	mov    0x14(%ebp),%eax
c01053ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01053f7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01053fa:	eb 6b                	jmp    c0105467 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01053fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105403:	00 
c0105404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105407:	89 44 24 04          	mov    %eax,0x4(%esp)
c010540b:	8b 45 08             	mov    0x8(%ebp),%eax
c010540e:	89 04 24             	mov    %eax,(%esp)
c0105411:	e8 d1 01 00 00       	call   c01055e7 <get_pte>
c0105416:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105419:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010541d:	75 24                	jne    c0105443 <boot_map_segment+0xe1>
c010541f:	c7 44 24 0c 4e c9 10 	movl   $0xc010c94e,0xc(%esp)
c0105426:	c0 
c0105427:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010542e:	c0 
c010542f:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105436:	00 
c0105437:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010543e:	e8 92 b9 ff ff       	call   c0100dd5 <__panic>
        *ptep = pa | PTE_P | perm;
c0105443:	8b 45 18             	mov    0x18(%ebp),%eax
c0105446:	8b 55 14             	mov    0x14(%ebp),%edx
c0105449:	09 d0                	or     %edx,%eax
c010544b:	83 c8 01             	or     $0x1,%eax
c010544e:	89 c2                	mov    %eax,%edx
c0105450:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105453:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105455:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105459:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105460:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010546b:	75 8f                	jne    c01053fc <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010546d:	c9                   	leave  
c010546e:	c3                   	ret    

c010546f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010546f:	55                   	push   %ebp
c0105470:	89 e5                	mov    %esp,%ebp
c0105472:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105475:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010547c:	e8 ff f9 ff ff       	call   c0104e80 <alloc_pages>
c0105481:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105488:	75 1c                	jne    c01054a6 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010548a:	c7 44 24 08 5b c9 10 	movl   $0xc010c95b,0x8(%esp)
c0105491:	c0 
c0105492:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105499:	00 
c010549a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01054a1:	e8 2f b9 ff ff       	call   c0100dd5 <__panic>
    }
    return page2kva(p);
c01054a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054a9:	89 04 24             	mov    %eax,(%esp)
c01054ac:	e8 20 f7 ff ff       	call   c0104bd1 <page2kva>
}
c01054b1:	c9                   	leave  
c01054b2:	c3                   	ret    

c01054b3 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01054b3:	55                   	push   %ebp
c01054b4:	89 e5                	mov    %esp,%ebp
c01054b6:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01054b9:	e8 70 f9 ff ff       	call   c0104e2e <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01054be:	e8 85 fa ff ff       	call   c0104f48 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01054c3:	e8 67 09 00 00       	call   c0105e2f <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01054c8:	e8 a2 ff ff ff       	call   c010546f <boot_alloc_page>
c01054cd:	a3 e4 be 19 c0       	mov    %eax,0xc019bee4
    memset(boot_pgdir, 0, PGSIZE);
c01054d2:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01054d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01054de:	00 
c01054df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01054e6:	00 
c01054e7:	89 04 24             	mov    %eax,(%esp)
c01054ea:	e8 1d 64 00 00       	call   c010b90c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01054ef:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01054f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054f7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01054fe:	77 23                	ja     c0105523 <pmm_init+0x70>
c0105500:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105503:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105507:	c7 44 24 08 f0 c8 10 	movl   $0xc010c8f0,0x8(%esp)
c010550e:	c0 
c010550f:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105516:	00 
c0105517:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010551e:	e8 b2 b8 ff ff       	call   c0100dd5 <__panic>
c0105523:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105526:	05 00 00 00 40       	add    $0x40000000,%eax
c010552b:	a3 c8 df 19 c0       	mov    %eax,0xc019dfc8

    check_pgdir();
c0105530:	e8 18 09 00 00       	call   c0105e4d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105535:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010553a:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105540:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105545:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105548:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010554f:	77 23                	ja     c0105574 <pmm_init+0xc1>
c0105551:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105554:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105558:	c7 44 24 08 f0 c8 10 	movl   $0xc010c8f0,0x8(%esp)
c010555f:	c0 
c0105560:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105567:	00 
c0105568:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010556f:	e8 61 b8 ff ff       	call   c0100dd5 <__panic>
c0105574:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105577:	05 00 00 00 40       	add    $0x40000000,%eax
c010557c:	83 c8 03             	or     $0x3,%eax
c010557f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105581:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105586:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010558d:	00 
c010558e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105595:	00 
c0105596:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010559d:	38 
c010559e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01055a5:	c0 
c01055a6:	89 04 24             	mov    %eax,(%esp)
c01055a9:	e8 b4 fd ff ff       	call   c0105362 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01055ae:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01055b3:	8b 15 e4 be 19 c0    	mov    0xc019bee4,%edx
c01055b9:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01055bf:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01055c1:	e8 63 fd ff ff       	call   c0105329 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01055c6:	e8 74 f7 ff ff       	call   c0104d3f <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01055cb:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01055d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01055d6:	e8 0d 0f 00 00       	call   c01064e8 <check_boot_pgdir>

    print_pgdir();
c01055db:	e8 95 13 00 00       	call   c0106975 <print_pgdir>
    
    kmalloc_init();
c01055e0:	e8 e6 f2 ff ff       	call   c01048cb <kmalloc_init>

}
c01055e5:	c9                   	leave  
c01055e6:	c3                   	ret    

c01055e7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01055e7:	55                   	push   %ebp
c01055e8:	89 e5                	mov    %esp,%ebp
c01055ea:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01055ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055f0:	c1 e8 16             	shr    $0x16,%eax
c01055f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01055fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01055fd:	01 d0                	add    %edx,%eax
c01055ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0105602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105605:	8b 00                	mov    (%eax),%eax
c0105607:	83 e0 01             	and    $0x1,%eax
c010560a:	85 c0                	test   %eax,%eax
c010560c:	0f 85 b9 00 00 00    	jne    c01056cb <get_pte+0xe4>
        if (!create) return 0;
c0105612:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105616:	75 0a                	jne    c0105622 <get_pte+0x3b>
c0105618:	b8 00 00 00 00       	mov    $0x0,%eax
c010561d:	e9 05 01 00 00       	jmp    c0105727 <get_pte+0x140>
        struct Page *new_page = alloc_page();
c0105622:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105629:	e8 52 f8 ff ff       	call   c0104e80 <alloc_pages>
c010562e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (!new_page) return 0;
c0105631:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105635:	75 0a                	jne    c0105641 <get_pte+0x5a>
c0105637:	b8 00 00 00 00       	mov    $0x0,%eax
c010563c:	e9 e6 00 00 00       	jmp    c0105727 <get_pte+0x140>
        set_page_ref(new_page, 1);
c0105641:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105648:	00 
c0105649:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010564c:	89 04 24             	mov    %eax,(%esp)
c010564f:	e8 31 f6 ff ff       	call   c0104c85 <set_page_ref>
        uintptr_t pa = page2pa(new_page);
c0105654:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105657:	89 04 24             	mov    %eax,(%esp)
c010565a:	e8 17 f5 ff ff       	call   c0104b76 <page2pa>
c010565f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0105662:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105665:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105668:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010566b:	c1 e8 0c             	shr    $0xc,%eax
c010566e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105671:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0105676:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105679:	72 23                	jb     c010569e <get_pte+0xb7>
c010567b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010567e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105682:	c7 44 24 08 4c c8 10 	movl   $0xc010c84c,0x8(%esp)
c0105689:	c0 
c010568a:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0105691:	00 
c0105692:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105699:	e8 37 b7 ff ff       	call   c0100dd5 <__panic>
c010569e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056a1:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01056a6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01056ad:	00 
c01056ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056b5:	00 
c01056b6:	89 04 24             	mov    %eax,(%esp)
c01056b9:	e8 4e 62 00 00       	call   c010b90c <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01056be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056c1:	83 c8 07             	or     $0x7,%eax
c01056c4:	89 c2                	mov    %eax,%edx
c01056c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c9:	89 10                	mov    %edx,(%eax)
    }
    return (pte_t *)KADDR(PDE_ADDR(*pdep)) + PTX(la);
c01056cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056ce:	8b 00                	mov    (%eax),%eax
c01056d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01056d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01056d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056db:	c1 e8 0c             	shr    $0xc,%eax
c01056de:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01056e1:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c01056e6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01056e9:	72 23                	jb     c010570e <get_pte+0x127>
c01056eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056f2:	c7 44 24 08 4c c8 10 	movl   $0xc010c84c,0x8(%esp)
c01056f9:	c0 
c01056fa:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c0105701:	00 
c0105702:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105709:	e8 c7 b6 ff ff       	call   c0100dd5 <__panic>
c010570e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105711:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105716:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105719:	c1 ea 0c             	shr    $0xc,%edx
c010571c:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105722:	c1 e2 02             	shl    $0x2,%edx
c0105725:	01 d0                	add    %edx,%eax
}
c0105727:	c9                   	leave  
c0105728:	c3                   	ret    

c0105729 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105729:	55                   	push   %ebp
c010572a:	89 e5                	mov    %esp,%ebp
c010572c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010572f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105736:	00 
c0105737:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010573e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105741:	89 04 24             	mov    %eax,(%esp)
c0105744:	e8 9e fe ff ff       	call   c01055e7 <get_pte>
c0105749:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010574c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105750:	74 08                	je     c010575a <get_page+0x31>
        *ptep_store = ptep;
c0105752:	8b 45 10             	mov    0x10(%ebp),%eax
c0105755:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105758:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010575a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010575e:	74 1b                	je     c010577b <get_page+0x52>
c0105760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105763:	8b 00                	mov    (%eax),%eax
c0105765:	83 e0 01             	and    $0x1,%eax
c0105768:	85 c0                	test   %eax,%eax
c010576a:	74 0f                	je     c010577b <get_page+0x52>
        return pte2page(*ptep);
c010576c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010576f:	8b 00                	mov    (%eax),%eax
c0105771:	89 04 24             	mov    %eax,(%esp)
c0105774:	e8 ac f4 ff ff       	call   c0104c25 <pte2page>
c0105779:	eb 05                	jmp    c0105780 <get_page+0x57>
    }
    return NULL;
c010577b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105780:	c9                   	leave  
c0105781:	c3                   	ret    

c0105782 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105782:	55                   	push   %ebp
c0105783:	89 e5                	mov    %esp,%ebp
c0105785:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0105788:	8b 45 10             	mov    0x10(%ebp),%eax
c010578b:	8b 00                	mov    (%eax),%eax
c010578d:	83 e0 01             	and    $0x1,%eax
c0105790:	85 c0                	test   %eax,%eax
c0105792:	74 4d                	je     c01057e1 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0105794:	8b 45 10             	mov    0x10(%ebp),%eax
c0105797:	8b 00                	mov    (%eax),%eax
c0105799:	89 04 24             	mov    %eax,(%esp)
c010579c:	e8 84 f4 ff ff       	call   c0104c25 <pte2page>
c01057a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (!page_ref_dec(page))
c01057a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057a7:	89 04 24             	mov    %eax,(%esp)
c01057aa:	e8 fa f4 ff ff       	call   c0104ca9 <page_ref_dec>
c01057af:	85 c0                	test   %eax,%eax
c01057b1:	75 13                	jne    c01057c6 <page_remove_pte+0x44>
            free_page(page);
c01057b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01057ba:	00 
c01057bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057be:	89 04 24             	mov    %eax,(%esp)
c01057c1:	e8 25 f7 ff ff       	call   c0104eeb <free_pages>
        *ptep = 0;
c01057c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01057c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d9:	89 04 24             	mov    %eax,(%esp)
c01057dc:	e8 1d 05 00 00       	call   c0105cfe <tlb_invalidate>
    }
}
c01057e1:	c9                   	leave  
c01057e2:	c3                   	ret    

c01057e3 <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c01057e3:	55                   	push   %ebp
c01057e4:	89 e5                	mov    %esp,%ebp
c01057e6:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c01057e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ec:	25 ff 0f 00 00       	and    $0xfff,%eax
c01057f1:	85 c0                	test   %eax,%eax
c01057f3:	75 0c                	jne    c0105801 <unmap_range+0x1e>
c01057f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f8:	25 ff 0f 00 00       	and    $0xfff,%eax
c01057fd:	85 c0                	test   %eax,%eax
c01057ff:	74 24                	je     c0105825 <unmap_range+0x42>
c0105801:	c7 44 24 0c 74 c9 10 	movl   $0xc010c974,0xc(%esp)
c0105808:	c0 
c0105809:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105810:	c0 
c0105811:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c0105818:	00 
c0105819:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105820:	e8 b0 b5 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105825:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c010582c:	76 11                	jbe    c010583f <unmap_range+0x5c>
c010582e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105831:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105834:	73 09                	jae    c010583f <unmap_range+0x5c>
c0105836:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c010583d:	76 24                	jbe    c0105863 <unmap_range+0x80>
c010583f:	c7 44 24 0c 9d c9 10 	movl   $0xc010c99d,0xc(%esp)
c0105846:	c0 
c0105847:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010584e:	c0 
c010584f:	c7 44 24 04 d3 01 00 	movl   $0x1d3,0x4(%esp)
c0105856:	00 
c0105857:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010585e:	e8 72 b5 ff ff       	call   c0100dd5 <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105863:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010586a:	00 
c010586b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105872:	8b 45 08             	mov    0x8(%ebp),%eax
c0105875:	89 04 24             	mov    %eax,(%esp)
c0105878:	e8 6a fd ff ff       	call   c01055e7 <get_pte>
c010587d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105880:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105884:	75 18                	jne    c010589e <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105886:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105889:	05 00 00 40 00       	add    $0x400000,%eax
c010588e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105891:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105894:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105899:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c010589c:	eb 29                	jmp    c01058c7 <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c010589e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a1:	8b 00                	mov    (%eax),%eax
c01058a3:	85 c0                	test   %eax,%eax
c01058a5:	74 19                	je     c01058c0 <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c01058a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b8:	89 04 24             	mov    %eax,(%esp)
c01058bb:	e8 c2 fe ff ff       	call   c0105782 <page_remove_pte>
        }
        start += PGSIZE;
c01058c0:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c01058c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058cb:	74 08                	je     c01058d5 <unmap_range+0xf2>
c01058cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d0:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058d3:	72 8e                	jb     c0105863 <unmap_range+0x80>
}
c01058d5:	c9                   	leave  
c01058d6:	c3                   	ret    

c01058d7 <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c01058d7:	55                   	push   %ebp
c01058d8:	89 e5                	mov    %esp,%ebp
c01058da:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c01058dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01058e5:	85 c0                	test   %eax,%eax
c01058e7:	75 0c                	jne    c01058f5 <exit_range+0x1e>
c01058e9:	8b 45 10             	mov    0x10(%ebp),%eax
c01058ec:	25 ff 0f 00 00       	and    $0xfff,%eax
c01058f1:	85 c0                	test   %eax,%eax
c01058f3:	74 24                	je     c0105919 <exit_range+0x42>
c01058f5:	c7 44 24 0c 74 c9 10 	movl   $0xc010c974,0xc(%esp)
c01058fc:	c0 
c01058fd:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105904:	c0 
c0105905:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c010590c:	00 
c010590d:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105914:	e8 bc b4 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105919:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105920:	76 11                	jbe    c0105933 <exit_range+0x5c>
c0105922:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105925:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105928:	73 09                	jae    c0105933 <exit_range+0x5c>
c010592a:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105931:	76 24                	jbe    c0105957 <exit_range+0x80>
c0105933:	c7 44 24 0c 9d c9 10 	movl   $0xc010c99d,0xc(%esp)
c010593a:	c0 
c010593b:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105942:	c0 
c0105943:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c010594a:	00 
c010594b:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105952:	e8 7e b4 ff ff       	call   c0100dd5 <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105957:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010595d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105960:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105965:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105968:	8b 45 0c             	mov    0xc(%ebp),%eax
c010596b:	c1 e8 16             	shr    $0x16,%eax
c010596e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105971:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105974:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010597b:	8b 45 08             	mov    0x8(%ebp),%eax
c010597e:	01 d0                	add    %edx,%eax
c0105980:	8b 00                	mov    (%eax),%eax
c0105982:	83 e0 01             	and    $0x1,%eax
c0105985:	85 c0                	test   %eax,%eax
c0105987:	74 3e                	je     c01059c7 <exit_range+0xf0>
            free_page(pde2page(pgdir[pde_idx]));
c0105989:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010598c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105993:	8b 45 08             	mov    0x8(%ebp),%eax
c0105996:	01 d0                	add    %edx,%eax
c0105998:	8b 00                	mov    (%eax),%eax
c010599a:	89 04 24             	mov    %eax,(%esp)
c010599d:	e8 c1 f2 ff ff       	call   c0104c63 <pde2page>
c01059a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01059a9:	00 
c01059aa:	89 04 24             	mov    %eax,(%esp)
c01059ad:	e8 39 f5 ff ff       	call   c0104eeb <free_pages>
            pgdir[pde_idx] = 0;
c01059b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01059bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bf:	01 d0                	add    %edx,%eax
c01059c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c01059c7:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c01059ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059d2:	74 08                	je     c01059dc <exit_range+0x105>
c01059d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d7:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059da:	72 8c                	jb     c0105968 <exit_range+0x91>
}
c01059dc:	c9                   	leave  
c01059dd:	c3                   	ret    

c01059de <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c01059de:	55                   	push   %ebp
c01059df:	89 e5                	mov    %esp,%ebp
c01059e1:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c01059e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01059e7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059ec:	85 c0                	test   %eax,%eax
c01059ee:	75 0c                	jne    c01059fc <copy_range+0x1e>
c01059f0:	8b 45 14             	mov    0x14(%ebp),%eax
c01059f3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01059f8:	85 c0                	test   %eax,%eax
c01059fa:	74 24                	je     c0105a20 <copy_range+0x42>
c01059fc:	c7 44 24 0c 74 c9 10 	movl   $0xc010c974,0xc(%esp)
c0105a03:	c0 
c0105a04:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105a0b:	c0 
c0105a0c:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0105a13:	00 
c0105a14:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105a1b:	e8 b5 b3 ff ff       	call   c0100dd5 <__panic>
    assert(USER_ACCESS(start, end));
c0105a20:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105a27:	76 11                	jbe    c0105a3a <copy_range+0x5c>
c0105a29:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a2c:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105a2f:	73 09                	jae    c0105a3a <copy_range+0x5c>
c0105a31:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105a38:	76 24                	jbe    c0105a5e <copy_range+0x80>
c0105a3a:	c7 44 24 0c 9d c9 10 	movl   $0xc010c99d,0xc(%esp)
c0105a41:	c0 
c0105a42:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105a49:	c0 
c0105a4a:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0105a51:	00 
c0105a52:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105a59:	e8 77 b3 ff ff       	call   c0100dd5 <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105a5e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a65:	00 
c0105a66:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a70:	89 04 24             	mov    %eax,(%esp)
c0105a73:	e8 6f fb ff ff       	call   c01055e7 <get_pte>
c0105a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a7f:	75 1b                	jne    c0105a9c <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105a81:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a84:	05 00 00 40 00       	add    $0x400000,%eax
c0105a89:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a8f:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105a94:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105a97:	e9 4c 01 00 00       	jmp    c0105be8 <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a9f:	8b 00                	mov    (%eax),%eax
c0105aa1:	83 e0 01             	and    $0x1,%eax
c0105aa4:	85 c0                	test   %eax,%eax
c0105aa6:	0f 84 35 01 00 00    	je     c0105be1 <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105aac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105ab3:	00 
c0105ab4:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abe:	89 04 24             	mov    %eax,(%esp)
c0105ac1:	e8 21 fb ff ff       	call   c01055e7 <get_pte>
c0105ac6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ac9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105acd:	75 0a                	jne    c0105ad9 <copy_range+0xfb>
                return -E_NO_MEM;
c0105acf:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105ad4:	e9 26 01 00 00       	jmp    c0105bff <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105adc:	8b 00                	mov    (%eax),%eax
c0105ade:	83 e0 07             	and    $0x7,%eax
c0105ae1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ae7:	8b 00                	mov    (%eax),%eax
c0105ae9:	89 04 24             	mov    %eax,(%esp)
c0105aec:	e8 34 f1 ff ff       	call   c0104c25 <pte2page>
c0105af1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105af4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105afb:	e8 80 f3 ff ff       	call   c0104e80 <alloc_pages>
c0105b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105b03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b07:	75 24                	jne    c0105b2d <copy_range+0x14f>
c0105b09:	c7 44 24 0c b5 c9 10 	movl   $0xc010c9b5,0xc(%esp)
c0105b10:	c0 
c0105b11:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105b18:	c0 
c0105b19:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105b20:	00 
c0105b21:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105b28:	e8 a8 b2 ff ff       	call   c0100dd5 <__panic>
        assert(npage!=NULL);
c0105b2d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105b31:	75 24                	jne    c0105b57 <copy_range+0x179>
c0105b33:	c7 44 24 0c c0 c9 10 	movl   $0xc010c9c0,0xc(%esp)
c0105b3a:	c0 
c0105b3b:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105b42:	c0 
c0105b43:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105b4a:	00 
c0105b4b:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105b52:	e8 7e b2 ff ff       	call   c0100dd5 <__panic>
        int ret=0;
c0105b57:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
        void *src_kvaddr = page2kva(page);
c0105b5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b61:	89 04 24             	mov    %eax,(%esp)
c0105b64:	e8 68 f0 ff ff       	call   c0104bd1 <page2kva>
c0105b69:	89 45 d8             	mov    %eax,-0x28(%ebp)
        void *dst_kvaddr = page2kva(npage);
c0105b6c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b6f:	89 04 24             	mov    %eax,(%esp)
c0105b72:	e8 5a f0 ff ff       	call   c0104bd1 <page2kva>
c0105b77:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105b7a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b81:	00 
c0105b82:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105b8c:	89 04 24             	mov    %eax,(%esp)
c0105b8f:	e8 5a 5e 00 00       	call   c010b9ee <memcpy>
        ret = page_insert(to, npage, start, perm);
c0105b94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b9b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b9e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bac:	89 04 24             	mov    %eax,(%esp)
c0105baf:	e8 91 00 00 00       	call   c0105c45 <page_insert>
c0105bb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(ret == 0);
c0105bb7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105bbb:	74 24                	je     c0105be1 <copy_range+0x203>
c0105bbd:	c7 44 24 0c cc c9 10 	movl   $0xc010c9cc,0xc(%esp)
c0105bc4:	c0 
c0105bc5:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105bcc:	c0 
c0105bcd:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0105bd4:	00 
c0105bd5:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105bdc:	e8 f4 b1 ff ff       	call   c0100dd5 <__panic>
        }
        start += PGSIZE;
c0105be1:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105be8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bec:	74 0c                	je     c0105bfa <copy_range+0x21c>
c0105bee:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bf1:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105bf4:	0f 82 64 fe ff ff    	jb     c0105a5e <copy_range+0x80>
    return 0;
c0105bfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bff:	c9                   	leave  
c0105c00:	c3                   	ret    

c0105c01 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105c01:	55                   	push   %ebp
c0105c02:	89 e5                	mov    %esp,%ebp
c0105c04:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105c07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105c0e:	00 
c0105c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c19:	89 04 24             	mov    %eax,(%esp)
c0105c1c:	e8 c6 f9 ff ff       	call   c01055e7 <get_pte>
c0105c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c28:	74 19                	je     c0105c43 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c2d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3b:	89 04 24             	mov    %eax,(%esp)
c0105c3e:	e8 3f fb ff ff       	call   c0105782 <page_remove_pte>
    }
}
c0105c43:	c9                   	leave  
c0105c44:	c3                   	ret    

c0105c45 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105c45:	55                   	push   %ebp
c0105c46:	89 e5                	mov    %esp,%ebp
c0105c48:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105c4b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105c52:	00 
c0105c53:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5d:	89 04 24             	mov    %eax,(%esp)
c0105c60:	e8 82 f9 ff ff       	call   c01055e7 <get_pte>
c0105c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105c6c:	75 0a                	jne    c0105c78 <page_insert+0x33>
        return -E_NO_MEM;
c0105c6e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105c73:	e9 84 00 00 00       	jmp    c0105cfc <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105c78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c7b:	89 04 24             	mov    %eax,(%esp)
c0105c7e:	e8 0f f0 ff ff       	call   c0104c92 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c86:	8b 00                	mov    (%eax),%eax
c0105c88:	83 e0 01             	and    $0x1,%eax
c0105c8b:	85 c0                	test   %eax,%eax
c0105c8d:	74 3e                	je     c0105ccd <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c92:	8b 00                	mov    (%eax),%eax
c0105c94:	89 04 24             	mov    %eax,(%esp)
c0105c97:	e8 89 ef ff ff       	call   c0104c25 <pte2page>
c0105c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ca2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ca5:	75 0d                	jne    c0105cb4 <page_insert+0x6f>
            page_ref_dec(page);
c0105ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105caa:	89 04 24             	mov    %eax,(%esp)
c0105cad:	e8 f7 ef ff ff       	call   c0104ca9 <page_ref_dec>
c0105cb2:	eb 19                	jmp    c0105ccd <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cb7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105cbb:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc5:	89 04 24             	mov    %eax,(%esp)
c0105cc8:	e8 b5 fa ff ff       	call   c0105782 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd0:	89 04 24             	mov    %eax,(%esp)
c0105cd3:	e8 9e ee ff ff       	call   c0104b76 <page2pa>
c0105cd8:	0b 45 14             	or     0x14(%ebp),%eax
c0105cdb:	83 c8 01             	or     $0x1,%eax
c0105cde:	89 c2                	mov    %eax,%edx
c0105ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ce3:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105ce5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cef:	89 04 24             	mov    %eax,(%esp)
c0105cf2:	e8 07 00 00 00       	call   c0105cfe <tlb_invalidate>
    return 0;
c0105cf7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cfc:	c9                   	leave  
c0105cfd:	c3                   	ret    

c0105cfe <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105cfe:	55                   	push   %ebp
c0105cff:	89 e5                	mov    %esp,%ebp
c0105d01:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105d04:	0f 20 d8             	mov    %cr3,%eax
c0105d07:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105d0d:	89 c2                	mov    %eax,%edx
c0105d0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d15:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105d1c:	77 23                	ja     c0105d41 <tlb_invalidate+0x43>
c0105d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d21:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d25:	c7 44 24 08 f0 c8 10 	movl   $0xc010c8f0,0x8(%esp)
c0105d2c:	c0 
c0105d2d:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0105d34:	00 
c0105d35:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105d3c:	e8 94 b0 ff ff       	call   c0100dd5 <__panic>
c0105d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d44:	05 00 00 00 40       	add    $0x40000000,%eax
c0105d49:	39 c2                	cmp    %eax,%edx
c0105d4b:	75 0c                	jne    c0105d59 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d50:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d56:	0f 01 38             	invlpg (%eax)
    }
}
c0105d59:	c9                   	leave  
c0105d5a:	c3                   	ret    

c0105d5b <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105d5b:	55                   	push   %ebp
c0105d5c:	89 e5                	mov    %esp,%ebp
c0105d5e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105d61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105d68:	e8 13 f1 ff ff       	call   c0104e80 <alloc_pages>
c0105d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105d70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d74:	0f 84 b0 00 00 00    	je     c0105e2a <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105d7a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d84:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d92:	89 04 24             	mov    %eax,(%esp)
c0105d95:	e8 ab fe ff ff       	call   c0105c45 <page_insert>
c0105d9a:	85 c0                	test   %eax,%eax
c0105d9c:	74 1a                	je     c0105db8 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105d9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105da5:	00 
c0105da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105da9:	89 04 24             	mov    %eax,(%esp)
c0105dac:	e8 3a f1 ff ff       	call   c0104eeb <free_pages>
            return NULL;
c0105db1:	b8 00 00 00 00       	mov    $0x0,%eax
c0105db6:	eb 75                	jmp    c0105e2d <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0105db8:	a1 6c bf 19 c0       	mov    0xc019bf6c,%eax
c0105dbd:	85 c0                	test   %eax,%eax
c0105dbf:	74 69                	je     c0105e2a <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c0105dc1:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c0105dc6:	85 c0                	test   %eax,%eax
c0105dc8:	74 60                	je     c0105e2a <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0105dca:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c0105dcf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105dd6:	00 
c0105dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105dda:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105dde:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105de1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105de5:	89 04 24             	mov    %eax,(%esp)
c0105de8:	e8 51 0e 00 00       	call   c0106c3e <swap_map_swappable>
                page->pra_vaddr=la;
c0105ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105df0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105df3:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c0105df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105df9:	89 04 24             	mov    %eax,(%esp)
c0105dfc:	e8 7a ee ff ff       	call   c0104c7b <page_ref>
c0105e01:	83 f8 01             	cmp    $0x1,%eax
c0105e04:	74 24                	je     c0105e2a <pgdir_alloc_page+0xcf>
c0105e06:	c7 44 24 0c d5 c9 10 	movl   $0xc010c9d5,0xc(%esp)
c0105e0d:	c0 
c0105e0e:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105e15:	c0 
c0105e16:	c7 44 24 04 68 02 00 	movl   $0x268,0x4(%esp)
c0105e1d:	00 
c0105e1e:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105e25:	e8 ab af ff ff       	call   c0100dd5 <__panic>
            }
        }

    }

    return page;
c0105e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105e2d:	c9                   	leave  
c0105e2e:	c3                   	ret    

c0105e2f <check_alloc_page>:

static void
check_alloc_page(void) {
c0105e2f:	55                   	push   %ebp
c0105e30:	89 e5                	mov    %esp,%ebp
c0105e32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105e35:	a1 c4 df 19 c0       	mov    0xc019dfc4,%eax
c0105e3a:	8b 40 18             	mov    0x18(%eax),%eax
c0105e3d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105e3f:	c7 04 24 ec c9 10 c0 	movl   $0xc010c9ec,(%esp)
c0105e46:	e8 08 a5 ff ff       	call   c0100353 <cprintf>
}
c0105e4b:	c9                   	leave  
c0105e4c:	c3                   	ret    

c0105e4d <check_pgdir>:

static void
check_pgdir(void) {
c0105e4d:	55                   	push   %ebp
c0105e4e:	89 e5                	mov    %esp,%ebp
c0105e50:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105e53:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0105e58:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105e5d:	76 24                	jbe    c0105e83 <check_pgdir+0x36>
c0105e5f:	c7 44 24 0c 0b ca 10 	movl   $0xc010ca0b,0xc(%esp)
c0105e66:	c0 
c0105e67:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105e6e:	c0 
c0105e6f:	c7 44 24 04 80 02 00 	movl   $0x280,0x4(%esp)
c0105e76:	00 
c0105e77:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105e7e:	e8 52 af ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105e83:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105e88:	85 c0                	test   %eax,%eax
c0105e8a:	74 0e                	je     c0105e9a <check_pgdir+0x4d>
c0105e8c:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105e91:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105e96:	85 c0                	test   %eax,%eax
c0105e98:	74 24                	je     c0105ebe <check_pgdir+0x71>
c0105e9a:	c7 44 24 0c 28 ca 10 	movl   $0xc010ca28,0xc(%esp)
c0105ea1:	c0 
c0105ea2:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105ea9:	c0 
c0105eaa:	c7 44 24 04 81 02 00 	movl   $0x281,0x4(%esp)
c0105eb1:	00 
c0105eb2:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105eb9:	e8 17 af ff ff       	call   c0100dd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105ebe:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105ec3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105eca:	00 
c0105ecb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105ed2:	00 
c0105ed3:	89 04 24             	mov    %eax,(%esp)
c0105ed6:	e8 4e f8 ff ff       	call   c0105729 <get_page>
c0105edb:	85 c0                	test   %eax,%eax
c0105edd:	74 24                	je     c0105f03 <check_pgdir+0xb6>
c0105edf:	c7 44 24 0c 60 ca 10 	movl   $0xc010ca60,0xc(%esp)
c0105ee6:	c0 
c0105ee7:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105eee:	c0 
c0105eef:	c7 44 24 04 82 02 00 	movl   $0x282,0x4(%esp)
c0105ef6:	00 
c0105ef7:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105efe:	e8 d2 ae ff ff       	call   c0100dd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105f03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105f0a:	e8 71 ef ff ff       	call   c0104e80 <alloc_pages>
c0105f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105f12:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105f17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105f1e:	00 
c0105f1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105f26:	00 
c0105f27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f2a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f2e:	89 04 24             	mov    %eax,(%esp)
c0105f31:	e8 0f fd ff ff       	call   c0105c45 <page_insert>
c0105f36:	85 c0                	test   %eax,%eax
c0105f38:	74 24                	je     c0105f5e <check_pgdir+0x111>
c0105f3a:	c7 44 24 0c 88 ca 10 	movl   $0xc010ca88,0xc(%esp)
c0105f41:	c0 
c0105f42:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105f49:	c0 
c0105f4a:	c7 44 24 04 86 02 00 	movl   $0x286,0x4(%esp)
c0105f51:	00 
c0105f52:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105f59:	e8 77 ae ff ff       	call   c0100dd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105f5e:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0105f63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105f6a:	00 
c0105f6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105f72:	00 
c0105f73:	89 04 24             	mov    %eax,(%esp)
c0105f76:	e8 6c f6 ff ff       	call   c01055e7 <get_pte>
c0105f7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f82:	75 24                	jne    c0105fa8 <check_pgdir+0x15b>
c0105f84:	c7 44 24 0c b4 ca 10 	movl   $0xc010cab4,0xc(%esp)
c0105f8b:	c0 
c0105f8c:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105f93:	c0 
c0105f94:	c7 44 24 04 89 02 00 	movl   $0x289,0x4(%esp)
c0105f9b:	00 
c0105f9c:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105fa3:	e8 2d ae ff ff       	call   c0100dd5 <__panic>
    assert(pte2page(*ptep) == p1);
c0105fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fab:	8b 00                	mov    (%eax),%eax
c0105fad:	89 04 24             	mov    %eax,(%esp)
c0105fb0:	e8 70 ec ff ff       	call   c0104c25 <pte2page>
c0105fb5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105fb8:	74 24                	je     c0105fde <check_pgdir+0x191>
c0105fba:	c7 44 24 0c e1 ca 10 	movl   $0xc010cae1,0xc(%esp)
c0105fc1:	c0 
c0105fc2:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105fc9:	c0 
c0105fca:	c7 44 24 04 8a 02 00 	movl   $0x28a,0x4(%esp)
c0105fd1:	00 
c0105fd2:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0105fd9:	e8 f7 ad ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 1);
c0105fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fe1:	89 04 24             	mov    %eax,(%esp)
c0105fe4:	e8 92 ec ff ff       	call   c0104c7b <page_ref>
c0105fe9:	83 f8 01             	cmp    $0x1,%eax
c0105fec:	74 24                	je     c0106012 <check_pgdir+0x1c5>
c0105fee:	c7 44 24 0c f7 ca 10 	movl   $0xc010caf7,0xc(%esp)
c0105ff5:	c0 
c0105ff6:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0105ffd:	c0 
c0105ffe:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
c0106005:	00 
c0106006:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010600d:	e8 c3 ad ff ff       	call   c0100dd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0106012:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0106017:	8b 00                	mov    (%eax),%eax
c0106019:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010601e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106021:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106024:	c1 e8 0c             	shr    $0xc,%eax
c0106027:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010602a:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c010602f:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0106032:	72 23                	jb     c0106057 <check_pgdir+0x20a>
c0106034:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106037:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010603b:	c7 44 24 08 4c c8 10 	movl   $0xc010c84c,0x8(%esp)
c0106042:	c0 
c0106043:	c7 44 24 04 8d 02 00 	movl   $0x28d,0x4(%esp)
c010604a:	00 
c010604b:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106052:	e8 7e ad ff ff       	call   c0100dd5 <__panic>
c0106057:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010605a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010605f:	83 c0 04             	add    $0x4,%eax
c0106062:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0106065:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010606a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106071:	00 
c0106072:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106079:	00 
c010607a:	89 04 24             	mov    %eax,(%esp)
c010607d:	e8 65 f5 ff ff       	call   c01055e7 <get_pte>
c0106082:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106085:	74 24                	je     c01060ab <check_pgdir+0x25e>
c0106087:	c7 44 24 0c 0c cb 10 	movl   $0xc010cb0c,0xc(%esp)
c010608e:	c0 
c010608f:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106096:	c0 
c0106097:	c7 44 24 04 8e 02 00 	movl   $0x28e,0x4(%esp)
c010609e:	00 
c010609f:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01060a6:	e8 2a ad ff ff       	call   c0100dd5 <__panic>

    p2 = alloc_page();
c01060ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01060b2:	e8 c9 ed ff ff       	call   c0104e80 <alloc_pages>
c01060b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01060ba:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01060bf:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01060c6:	00 
c01060c7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01060ce:	00 
c01060cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01060d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060d6:	89 04 24             	mov    %eax,(%esp)
c01060d9:	e8 67 fb ff ff       	call   c0105c45 <page_insert>
c01060de:	85 c0                	test   %eax,%eax
c01060e0:	74 24                	je     c0106106 <check_pgdir+0x2b9>
c01060e2:	c7 44 24 0c 34 cb 10 	movl   $0xc010cb34,0xc(%esp)
c01060e9:	c0 
c01060ea:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01060f1:	c0 
c01060f2:	c7 44 24 04 91 02 00 	movl   $0x291,0x4(%esp)
c01060f9:	00 
c01060fa:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106101:	e8 cf ac ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106106:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010610b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106112:	00 
c0106113:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010611a:	00 
c010611b:	89 04 24             	mov    %eax,(%esp)
c010611e:	e8 c4 f4 ff ff       	call   c01055e7 <get_pte>
c0106123:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106126:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010612a:	75 24                	jne    c0106150 <check_pgdir+0x303>
c010612c:	c7 44 24 0c 6c cb 10 	movl   $0xc010cb6c,0xc(%esp)
c0106133:	c0 
c0106134:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010613b:	c0 
c010613c:	c7 44 24 04 92 02 00 	movl   $0x292,0x4(%esp)
c0106143:	00 
c0106144:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010614b:	e8 85 ac ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_U);
c0106150:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106153:	8b 00                	mov    (%eax),%eax
c0106155:	83 e0 04             	and    $0x4,%eax
c0106158:	85 c0                	test   %eax,%eax
c010615a:	75 24                	jne    c0106180 <check_pgdir+0x333>
c010615c:	c7 44 24 0c 9c cb 10 	movl   $0xc010cb9c,0xc(%esp)
c0106163:	c0 
c0106164:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010616b:	c0 
c010616c:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c0106173:	00 
c0106174:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010617b:	e8 55 ac ff ff       	call   c0100dd5 <__panic>
    assert(*ptep & PTE_W);
c0106180:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106183:	8b 00                	mov    (%eax),%eax
c0106185:	83 e0 02             	and    $0x2,%eax
c0106188:	85 c0                	test   %eax,%eax
c010618a:	75 24                	jne    c01061b0 <check_pgdir+0x363>
c010618c:	c7 44 24 0c aa cb 10 	movl   $0xc010cbaa,0xc(%esp)
c0106193:	c0 
c0106194:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010619b:	c0 
c010619c:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c01061a3:	00 
c01061a4:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01061ab:	e8 25 ac ff ff       	call   c0100dd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01061b0:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01061b5:	8b 00                	mov    (%eax),%eax
c01061b7:	83 e0 04             	and    $0x4,%eax
c01061ba:	85 c0                	test   %eax,%eax
c01061bc:	75 24                	jne    c01061e2 <check_pgdir+0x395>
c01061be:	c7 44 24 0c b8 cb 10 	movl   $0xc010cbb8,0xc(%esp)
c01061c5:	c0 
c01061c6:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01061cd:	c0 
c01061ce:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c01061d5:	00 
c01061d6:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01061dd:	e8 f3 ab ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 1);
c01061e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061e5:	89 04 24             	mov    %eax,(%esp)
c01061e8:	e8 8e ea ff ff       	call   c0104c7b <page_ref>
c01061ed:	83 f8 01             	cmp    $0x1,%eax
c01061f0:	74 24                	je     c0106216 <check_pgdir+0x3c9>
c01061f2:	c7 44 24 0c ce cb 10 	movl   $0xc010cbce,0xc(%esp)
c01061f9:	c0 
c01061fa:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106201:	c0 
c0106202:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c0106209:	00 
c010620a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106211:	e8 bf ab ff ff       	call   c0100dd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0106216:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010621b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106222:	00 
c0106223:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010622a:	00 
c010622b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010622e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106232:	89 04 24             	mov    %eax,(%esp)
c0106235:	e8 0b fa ff ff       	call   c0105c45 <page_insert>
c010623a:	85 c0                	test   %eax,%eax
c010623c:	74 24                	je     c0106262 <check_pgdir+0x415>
c010623e:	c7 44 24 0c e0 cb 10 	movl   $0xc010cbe0,0xc(%esp)
c0106245:	c0 
c0106246:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010624d:	c0 
c010624e:	c7 44 24 04 98 02 00 	movl   $0x298,0x4(%esp)
c0106255:	00 
c0106256:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010625d:	e8 73 ab ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p1) == 2);
c0106262:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106265:	89 04 24             	mov    %eax,(%esp)
c0106268:	e8 0e ea ff ff       	call   c0104c7b <page_ref>
c010626d:	83 f8 02             	cmp    $0x2,%eax
c0106270:	74 24                	je     c0106296 <check_pgdir+0x449>
c0106272:	c7 44 24 0c 0c cc 10 	movl   $0xc010cc0c,0xc(%esp)
c0106279:	c0 
c010627a:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106281:	c0 
c0106282:	c7 44 24 04 99 02 00 	movl   $0x299,0x4(%esp)
c0106289:	00 
c010628a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106291:	e8 3f ab ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c0106296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106299:	89 04 24             	mov    %eax,(%esp)
c010629c:	e8 da e9 ff ff       	call   c0104c7b <page_ref>
c01062a1:	85 c0                	test   %eax,%eax
c01062a3:	74 24                	je     c01062c9 <check_pgdir+0x47c>
c01062a5:	c7 44 24 0c 1e cc 10 	movl   $0xc010cc1e,0xc(%esp)
c01062ac:	c0 
c01062ad:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01062b4:	c0 
c01062b5:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c01062bc:	00 
c01062bd:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01062c4:	e8 0c ab ff ff       	call   c0100dd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01062c9:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01062ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062d5:	00 
c01062d6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01062dd:	00 
c01062de:	89 04 24             	mov    %eax,(%esp)
c01062e1:	e8 01 f3 ff ff       	call   c01055e7 <get_pte>
c01062e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01062e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01062ed:	75 24                	jne    c0106313 <check_pgdir+0x4c6>
c01062ef:	c7 44 24 0c 6c cb 10 	movl   $0xc010cb6c,0xc(%esp)
c01062f6:	c0 
c01062f7:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01062fe:	c0 
c01062ff:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c0106306:	00 
c0106307:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010630e:	e8 c2 aa ff ff       	call   c0100dd5 <__panic>
    assert(pte2page(*ptep) == p1);
c0106313:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106316:	8b 00                	mov    (%eax),%eax
c0106318:	89 04 24             	mov    %eax,(%esp)
c010631b:	e8 05 e9 ff ff       	call   c0104c25 <pte2page>
c0106320:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106323:	74 24                	je     c0106349 <check_pgdir+0x4fc>
c0106325:	c7 44 24 0c e1 ca 10 	movl   $0xc010cae1,0xc(%esp)
c010632c:	c0 
c010632d:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106334:	c0 
c0106335:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c010633c:	00 
c010633d:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106344:	e8 8c aa ff ff       	call   c0100dd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c0106349:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010634c:	8b 00                	mov    (%eax),%eax
c010634e:	83 e0 04             	and    $0x4,%eax
c0106351:	85 c0                	test   %eax,%eax
c0106353:	74 24                	je     c0106379 <check_pgdir+0x52c>
c0106355:	c7 44 24 0c 30 cc 10 	movl   $0xc010cc30,0xc(%esp)
c010635c:	c0 
c010635d:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106364:	c0 
c0106365:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c010636c:	00 
c010636d:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106374:	e8 5c aa ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106379:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010637e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106385:	00 
c0106386:	89 04 24             	mov    %eax,(%esp)
c0106389:	e8 73 f8 ff ff       	call   c0105c01 <page_remove>
    assert(page_ref(p1) == 1);
c010638e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106391:	89 04 24             	mov    %eax,(%esp)
c0106394:	e8 e2 e8 ff ff       	call   c0104c7b <page_ref>
c0106399:	83 f8 01             	cmp    $0x1,%eax
c010639c:	74 24                	je     c01063c2 <check_pgdir+0x575>
c010639e:	c7 44 24 0c f7 ca 10 	movl   $0xc010caf7,0xc(%esp)
c01063a5:	c0 
c01063a6:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01063ad:	c0 
c01063ae:	c7 44 24 04 a0 02 00 	movl   $0x2a0,0x4(%esp)
c01063b5:	00 
c01063b6:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01063bd:	e8 13 aa ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c01063c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063c5:	89 04 24             	mov    %eax,(%esp)
c01063c8:	e8 ae e8 ff ff       	call   c0104c7b <page_ref>
c01063cd:	85 c0                	test   %eax,%eax
c01063cf:	74 24                	je     c01063f5 <check_pgdir+0x5a8>
c01063d1:	c7 44 24 0c 1e cc 10 	movl   $0xc010cc1e,0xc(%esp)
c01063d8:	c0 
c01063d9:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01063e0:	c0 
c01063e1:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
c01063e8:	00 
c01063e9:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01063f0:	e8 e0 a9 ff ff       	call   c0100dd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01063f5:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01063fa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106401:	00 
c0106402:	89 04 24             	mov    %eax,(%esp)
c0106405:	e8 f7 f7 ff ff       	call   c0105c01 <page_remove>
    assert(page_ref(p1) == 0);
c010640a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010640d:	89 04 24             	mov    %eax,(%esp)
c0106410:	e8 66 e8 ff ff       	call   c0104c7b <page_ref>
c0106415:	85 c0                	test   %eax,%eax
c0106417:	74 24                	je     c010643d <check_pgdir+0x5f0>
c0106419:	c7 44 24 0c 45 cc 10 	movl   $0xc010cc45,0xc(%esp)
c0106420:	c0 
c0106421:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106428:	c0 
c0106429:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c0106430:	00 
c0106431:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106438:	e8 98 a9 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p2) == 0);
c010643d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106440:	89 04 24             	mov    %eax,(%esp)
c0106443:	e8 33 e8 ff ff       	call   c0104c7b <page_ref>
c0106448:	85 c0                	test   %eax,%eax
c010644a:	74 24                	je     c0106470 <check_pgdir+0x623>
c010644c:	c7 44 24 0c 1e cc 10 	movl   $0xc010cc1e,0xc(%esp)
c0106453:	c0 
c0106454:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010645b:	c0 
c010645c:	c7 44 24 04 a5 02 00 	movl   $0x2a5,0x4(%esp)
c0106463:	00 
c0106464:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c010646b:	e8 65 a9 ff ff       	call   c0100dd5 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0106470:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0106475:	8b 00                	mov    (%eax),%eax
c0106477:	89 04 24             	mov    %eax,(%esp)
c010647a:	e8 e4 e7 ff ff       	call   c0104c63 <pde2page>
c010647f:	89 04 24             	mov    %eax,(%esp)
c0106482:	e8 f4 e7 ff ff       	call   c0104c7b <page_ref>
c0106487:	83 f8 01             	cmp    $0x1,%eax
c010648a:	74 24                	je     c01064b0 <check_pgdir+0x663>
c010648c:	c7 44 24 0c 58 cc 10 	movl   $0xc010cc58,0xc(%esp)
c0106493:	c0 
c0106494:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c010649b:	c0 
c010649c:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c01064a3:	00 
c01064a4:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01064ab:	e8 25 a9 ff ff       	call   c0100dd5 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01064b0:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01064b5:	8b 00                	mov    (%eax),%eax
c01064b7:	89 04 24             	mov    %eax,(%esp)
c01064ba:	e8 a4 e7 ff ff       	call   c0104c63 <pde2page>
c01064bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01064c6:	00 
c01064c7:	89 04 24             	mov    %eax,(%esp)
c01064ca:	e8 1c ea ff ff       	call   c0104eeb <free_pages>
    boot_pgdir[0] = 0;
c01064cf:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01064d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01064da:	c7 04 24 7f cc 10 c0 	movl   $0xc010cc7f,(%esp)
c01064e1:	e8 6d 9e ff ff       	call   c0100353 <cprintf>
}
c01064e6:	c9                   	leave  
c01064e7:	c3                   	ret    

c01064e8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01064e8:	55                   	push   %ebp
c01064e9:	89 e5                	mov    %esp,%ebp
c01064eb:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01064ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01064f5:	e9 ca 00 00 00       	jmp    c01065c4 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01064fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01064fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106500:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106503:	c1 e8 0c             	shr    $0xc,%eax
c0106506:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106509:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c010650e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106511:	72 23                	jb     c0106536 <check_boot_pgdir+0x4e>
c0106513:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106516:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010651a:	c7 44 24 08 4c c8 10 	movl   $0xc010c84c,0x8(%esp)
c0106521:	c0 
c0106522:	c7 44 24 04 b3 02 00 	movl   $0x2b3,0x4(%esp)
c0106529:	00 
c010652a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106531:	e8 9f a8 ff ff       	call   c0100dd5 <__panic>
c0106536:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106539:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010653e:	89 c2                	mov    %eax,%edx
c0106540:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0106545:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010654c:	00 
c010654d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106551:	89 04 24             	mov    %eax,(%esp)
c0106554:	e8 8e f0 ff ff       	call   c01055e7 <get_pte>
c0106559:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010655c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106560:	75 24                	jne    c0106586 <check_boot_pgdir+0x9e>
c0106562:	c7 44 24 0c 9c cc 10 	movl   $0xc010cc9c,0xc(%esp)
c0106569:	c0 
c010656a:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106571:	c0 
c0106572:	c7 44 24 04 b3 02 00 	movl   $0x2b3,0x4(%esp)
c0106579:	00 
c010657a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106581:	e8 4f a8 ff ff       	call   c0100dd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106586:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106589:	8b 00                	mov    (%eax),%eax
c010658b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106590:	89 c2                	mov    %eax,%edx
c0106592:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106595:	39 c2                	cmp    %eax,%edx
c0106597:	74 24                	je     c01065bd <check_boot_pgdir+0xd5>
c0106599:	c7 44 24 0c d9 cc 10 	movl   $0xc010ccd9,0xc(%esp)
c01065a0:	c0 
c01065a1:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01065a8:	c0 
c01065a9:	c7 44 24 04 b4 02 00 	movl   $0x2b4,0x4(%esp)
c01065b0:	00 
c01065b1:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01065b8:	e8 18 a8 ff ff       	call   c0100dd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01065bd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01065c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01065c7:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c01065cc:	39 c2                	cmp    %eax,%edx
c01065ce:	0f 82 26 ff ff ff    	jb     c01064fa <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01065d4:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01065d9:	05 ac 0f 00 00       	add    $0xfac,%eax
c01065de:	8b 00                	mov    (%eax),%eax
c01065e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01065e5:	89 c2                	mov    %eax,%edx
c01065e7:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c01065ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01065ef:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01065f6:	77 23                	ja     c010661b <check_boot_pgdir+0x133>
c01065f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01065ff:	c7 44 24 08 f0 c8 10 	movl   $0xc010c8f0,0x8(%esp)
c0106606:	c0 
c0106607:	c7 44 24 04 b7 02 00 	movl   $0x2b7,0x4(%esp)
c010660e:	00 
c010660f:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106616:	e8 ba a7 ff ff       	call   c0100dd5 <__panic>
c010661b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010661e:	05 00 00 00 40       	add    $0x40000000,%eax
c0106623:	39 c2                	cmp    %eax,%edx
c0106625:	74 24                	je     c010664b <check_boot_pgdir+0x163>
c0106627:	c7 44 24 0c f0 cc 10 	movl   $0xc010ccf0,0xc(%esp)
c010662e:	c0 
c010662f:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106636:	c0 
c0106637:	c7 44 24 04 b7 02 00 	movl   $0x2b7,0x4(%esp)
c010663e:	00 
c010663f:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106646:	e8 8a a7 ff ff       	call   c0100dd5 <__panic>

    assert(boot_pgdir[0] == 0);
c010664b:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c0106650:	8b 00                	mov    (%eax),%eax
c0106652:	85 c0                	test   %eax,%eax
c0106654:	74 24                	je     c010667a <check_boot_pgdir+0x192>
c0106656:	c7 44 24 0c 24 cd 10 	movl   $0xc010cd24,0xc(%esp)
c010665d:	c0 
c010665e:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106665:	c0 
c0106666:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c010666d:	00 
c010666e:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106675:	e8 5b a7 ff ff       	call   c0100dd5 <__panic>

    struct Page *p;
    p = alloc_page();
c010667a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106681:	e8 fa e7 ff ff       	call   c0104e80 <alloc_pages>
c0106686:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106689:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010668e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106695:	00 
c0106696:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010669d:	00 
c010669e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01066a1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066a5:	89 04 24             	mov    %eax,(%esp)
c01066a8:	e8 98 f5 ff ff       	call   c0105c45 <page_insert>
c01066ad:	85 c0                	test   %eax,%eax
c01066af:	74 24                	je     c01066d5 <check_boot_pgdir+0x1ed>
c01066b1:	c7 44 24 0c 38 cd 10 	movl   $0xc010cd38,0xc(%esp)
c01066b8:	c0 
c01066b9:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01066c0:	c0 
c01066c1:	c7 44 24 04 bd 02 00 	movl   $0x2bd,0x4(%esp)
c01066c8:	00 
c01066c9:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01066d0:	e8 00 a7 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 1);
c01066d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01066d8:	89 04 24             	mov    %eax,(%esp)
c01066db:	e8 9b e5 ff ff       	call   c0104c7b <page_ref>
c01066e0:	83 f8 01             	cmp    $0x1,%eax
c01066e3:	74 24                	je     c0106709 <check_boot_pgdir+0x221>
c01066e5:	c7 44 24 0c 66 cd 10 	movl   $0xc010cd66,0xc(%esp)
c01066ec:	c0 
c01066ed:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01066f4:	c0 
c01066f5:	c7 44 24 04 be 02 00 	movl   $0x2be,0x4(%esp)
c01066fc:	00 
c01066fd:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106704:	e8 cc a6 ff ff       	call   c0100dd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0106709:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010670e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106715:	00 
c0106716:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010671d:	00 
c010671e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106721:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106725:	89 04 24             	mov    %eax,(%esp)
c0106728:	e8 18 f5 ff ff       	call   c0105c45 <page_insert>
c010672d:	85 c0                	test   %eax,%eax
c010672f:	74 24                	je     c0106755 <check_boot_pgdir+0x26d>
c0106731:	c7 44 24 0c 78 cd 10 	movl   $0xc010cd78,0xc(%esp)
c0106738:	c0 
c0106739:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106740:	c0 
c0106741:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c0106748:	00 
c0106749:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106750:	e8 80 a6 ff ff       	call   c0100dd5 <__panic>
    assert(page_ref(p) == 2);
c0106755:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106758:	89 04 24             	mov    %eax,(%esp)
c010675b:	e8 1b e5 ff ff       	call   c0104c7b <page_ref>
c0106760:	83 f8 02             	cmp    $0x2,%eax
c0106763:	74 24                	je     c0106789 <check_boot_pgdir+0x2a1>
c0106765:	c7 44 24 0c af cd 10 	movl   $0xc010cdaf,0xc(%esp)
c010676c:	c0 
c010676d:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106774:	c0 
c0106775:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c010677c:	00 
c010677d:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106784:	e8 4c a6 ff ff       	call   c0100dd5 <__panic>

    const char *str = "ucore: Hello world!!";
c0106789:	c7 45 dc c0 cd 10 c0 	movl   $0xc010cdc0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106790:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106793:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106797:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010679e:	e8 92 4e 00 00       	call   c010b635 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01067a3:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01067aa:	00 
c01067ab:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01067b2:	e8 f7 4e 00 00       	call   c010b6ae <strcmp>
c01067b7:	85 c0                	test   %eax,%eax
c01067b9:	74 24                	je     c01067df <check_boot_pgdir+0x2f7>
c01067bb:	c7 44 24 0c d8 cd 10 	movl   $0xc010cdd8,0xc(%esp)
c01067c2:	c0 
c01067c3:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c01067ca:	c0 
c01067cb:	c7 44 24 04 c4 02 00 	movl   $0x2c4,0x4(%esp)
c01067d2:	00 
c01067d3:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c01067da:	e8 f6 a5 ff ff       	call   c0100dd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01067df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01067e2:	89 04 24             	mov    %eax,(%esp)
c01067e5:	e8 e7 e3 ff ff       	call   c0104bd1 <page2kva>
c01067ea:	05 00 01 00 00       	add    $0x100,%eax
c01067ef:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01067f2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01067f9:	e8 df 4d 00 00       	call   c010b5dd <strlen>
c01067fe:	85 c0                	test   %eax,%eax
c0106800:	74 24                	je     c0106826 <check_boot_pgdir+0x33e>
c0106802:	c7 44 24 0c 10 ce 10 	movl   $0xc010ce10,0xc(%esp)
c0106809:	c0 
c010680a:	c7 44 24 08 39 c9 10 	movl   $0xc010c939,0x8(%esp)
c0106811:	c0 
c0106812:	c7 44 24 04 c7 02 00 	movl   $0x2c7,0x4(%esp)
c0106819:	00 
c010681a:	c7 04 24 14 c9 10 c0 	movl   $0xc010c914,(%esp)
c0106821:	e8 af a5 ff ff       	call   c0100dd5 <__panic>

    free_page(p);
c0106826:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010682d:	00 
c010682e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106831:	89 04 24             	mov    %eax,(%esp)
c0106834:	e8 b2 e6 ff ff       	call   c0104eeb <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0106839:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010683e:	8b 00                	mov    (%eax),%eax
c0106840:	89 04 24             	mov    %eax,(%esp)
c0106843:	e8 1b e4 ff ff       	call   c0104c63 <pde2page>
c0106848:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010684f:	00 
c0106850:	89 04 24             	mov    %eax,(%esp)
c0106853:	e8 93 e6 ff ff       	call   c0104eeb <free_pages>
    boot_pgdir[0] = 0;
c0106858:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010685d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106863:	c7 04 24 34 ce 10 c0 	movl   $0xc010ce34,(%esp)
c010686a:	e8 e4 9a ff ff       	call   c0100353 <cprintf>
}
c010686f:	c9                   	leave  
c0106870:	c3                   	ret    

c0106871 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106871:	55                   	push   %ebp
c0106872:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106874:	8b 45 08             	mov    0x8(%ebp),%eax
c0106877:	83 e0 04             	and    $0x4,%eax
c010687a:	85 c0                	test   %eax,%eax
c010687c:	74 07                	je     c0106885 <perm2str+0x14>
c010687e:	b8 75 00 00 00       	mov    $0x75,%eax
c0106883:	eb 05                	jmp    c010688a <perm2str+0x19>
c0106885:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010688a:	a2 68 bf 19 c0       	mov    %al,0xc019bf68
    str[1] = 'r';
c010688f:	c6 05 69 bf 19 c0 72 	movb   $0x72,0xc019bf69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106896:	8b 45 08             	mov    0x8(%ebp),%eax
c0106899:	83 e0 02             	and    $0x2,%eax
c010689c:	85 c0                	test   %eax,%eax
c010689e:	74 07                	je     c01068a7 <perm2str+0x36>
c01068a0:	b8 77 00 00 00       	mov    $0x77,%eax
c01068a5:	eb 05                	jmp    c01068ac <perm2str+0x3b>
c01068a7:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01068ac:	a2 6a bf 19 c0       	mov    %al,0xc019bf6a
    str[3] = '\0';
c01068b1:	c6 05 6b bf 19 c0 00 	movb   $0x0,0xc019bf6b
    return str;
c01068b8:	b8 68 bf 19 c0       	mov    $0xc019bf68,%eax
}
c01068bd:	5d                   	pop    %ebp
c01068be:	c3                   	ret    

c01068bf <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01068bf:	55                   	push   %ebp
c01068c0:	89 e5                	mov    %esp,%ebp
c01068c2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01068c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01068c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01068cb:	72 0a                	jb     c01068d7 <get_pgtable_items+0x18>
        return 0;
c01068cd:	b8 00 00 00 00       	mov    $0x0,%eax
c01068d2:	e9 9c 00 00 00       	jmp    c0106973 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01068d7:	eb 04                	jmp    c01068dd <get_pgtable_items+0x1e>
        start ++;
c01068d9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01068dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01068e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01068e3:	73 18                	jae    c01068fd <get_pgtable_items+0x3e>
c01068e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01068e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01068ef:	8b 45 14             	mov    0x14(%ebp),%eax
c01068f2:	01 d0                	add    %edx,%eax
c01068f4:	8b 00                	mov    (%eax),%eax
c01068f6:	83 e0 01             	and    $0x1,%eax
c01068f9:	85 c0                	test   %eax,%eax
c01068fb:	74 dc                	je     c01068d9 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01068fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0106900:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106903:	73 69                	jae    c010696e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0106905:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106909:	74 08                	je     c0106913 <get_pgtable_items+0x54>
            *left_store = start;
c010690b:	8b 45 18             	mov    0x18(%ebp),%eax
c010690e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106911:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106913:	8b 45 10             	mov    0x10(%ebp),%eax
c0106916:	8d 50 01             	lea    0x1(%eax),%edx
c0106919:	89 55 10             	mov    %edx,0x10(%ebp)
c010691c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106923:	8b 45 14             	mov    0x14(%ebp),%eax
c0106926:	01 d0                	add    %edx,%eax
c0106928:	8b 00                	mov    (%eax),%eax
c010692a:	83 e0 07             	and    $0x7,%eax
c010692d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106930:	eb 04                	jmp    c0106936 <get_pgtable_items+0x77>
            start ++;
c0106932:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106936:	8b 45 10             	mov    0x10(%ebp),%eax
c0106939:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010693c:	73 1d                	jae    c010695b <get_pgtable_items+0x9c>
c010693e:	8b 45 10             	mov    0x10(%ebp),%eax
c0106941:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0106948:	8b 45 14             	mov    0x14(%ebp),%eax
c010694b:	01 d0                	add    %edx,%eax
c010694d:	8b 00                	mov    (%eax),%eax
c010694f:	83 e0 07             	and    $0x7,%eax
c0106952:	89 c2                	mov    %eax,%edx
c0106954:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106957:	39 c2                	cmp    %eax,%edx
c0106959:	74 d7                	je     c0106932 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010695b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010695f:	74 08                	je     c0106969 <get_pgtable_items+0xaa>
            *right_store = start;
c0106961:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106964:	8b 55 10             	mov    0x10(%ebp),%edx
c0106967:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106969:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010696c:	eb 05                	jmp    c0106973 <get_pgtable_items+0xb4>
    }
    return 0;
c010696e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106973:	c9                   	leave  
c0106974:	c3                   	ret    

c0106975 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106975:	55                   	push   %ebp
c0106976:	89 e5                	mov    %esp,%ebp
c0106978:	57                   	push   %edi
c0106979:	56                   	push   %esi
c010697a:	53                   	push   %ebx
c010697b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010697e:	c7 04 24 54 ce 10 c0 	movl   $0xc010ce54,(%esp)
c0106985:	e8 c9 99 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c010698a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106991:	e9 fa 00 00 00       	jmp    c0106a90 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106999:	89 04 24             	mov    %eax,(%esp)
c010699c:	e8 d0 fe ff ff       	call   c0106871 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01069a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01069a4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01069a7:	29 d1                	sub    %edx,%ecx
c01069a9:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01069ab:	89 d6                	mov    %edx,%esi
c01069ad:	c1 e6 16             	shl    $0x16,%esi
c01069b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01069b3:	89 d3                	mov    %edx,%ebx
c01069b5:	c1 e3 16             	shl    $0x16,%ebx
c01069b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01069bb:	89 d1                	mov    %edx,%ecx
c01069bd:	c1 e1 16             	shl    $0x16,%ecx
c01069c0:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01069c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01069c6:	29 d7                	sub    %edx,%edi
c01069c8:	89 fa                	mov    %edi,%edx
c01069ca:	89 44 24 14          	mov    %eax,0x14(%esp)
c01069ce:	89 74 24 10          	mov    %esi,0x10(%esp)
c01069d2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01069d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01069da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069de:	c7 04 24 85 ce 10 c0 	movl   $0xc010ce85,(%esp)
c01069e5:	e8 69 99 ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01069ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01069ed:	c1 e0 0a             	shl    $0xa,%eax
c01069f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01069f3:	eb 54                	jmp    c0106a49 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01069f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069f8:	89 04 24             	mov    %eax,(%esp)
c01069fb:	e8 71 fe ff ff       	call   c0106871 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106a00:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106a03:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106a06:	29 d1                	sub    %edx,%ecx
c0106a08:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106a0a:	89 d6                	mov    %edx,%esi
c0106a0c:	c1 e6 0c             	shl    $0xc,%esi
c0106a0f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106a12:	89 d3                	mov    %edx,%ebx
c0106a14:	c1 e3 0c             	shl    $0xc,%ebx
c0106a17:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106a1a:	c1 e2 0c             	shl    $0xc,%edx
c0106a1d:	89 d1                	mov    %edx,%ecx
c0106a1f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106a22:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106a25:	29 d7                	sub    %edx,%edi
c0106a27:	89 fa                	mov    %edi,%edx
c0106a29:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106a2d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106a31:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106a35:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106a39:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a3d:	c7 04 24 a4 ce 10 c0 	movl   $0xc010cea4,(%esp)
c0106a44:	e8 0a 99 ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106a49:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106a4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106a51:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106a54:	89 ce                	mov    %ecx,%esi
c0106a56:	c1 e6 0a             	shl    $0xa,%esi
c0106a59:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106a5c:	89 cb                	mov    %ecx,%ebx
c0106a5e:	c1 e3 0a             	shl    $0xa,%ebx
c0106a61:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106a64:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106a68:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106a6b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106a6f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106a73:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106a77:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106a7b:	89 1c 24             	mov    %ebx,(%esp)
c0106a7e:	e8 3c fe ff ff       	call   c01068bf <get_pgtable_items>
c0106a83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106a86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106a8a:	0f 85 65 ff ff ff    	jne    c01069f5 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106a90:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0106a95:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a98:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106a9b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106a9f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106aa2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106aa6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106aae:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106ab5:	00 
c0106ab6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106abd:	e8 fd fd ff ff       	call   c01068bf <get_pgtable_items>
c0106ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106ac5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106ac9:	0f 85 c7 fe ff ff    	jne    c0106996 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106acf:	c7 04 24 c8 ce 10 c0 	movl   $0xc010cec8,(%esp)
c0106ad6:	e8 78 98 ff ff       	call   c0100353 <cprintf>
}
c0106adb:	83 c4 4c             	add    $0x4c,%esp
c0106ade:	5b                   	pop    %ebx
c0106adf:	5e                   	pop    %esi
c0106ae0:	5f                   	pop    %edi
c0106ae1:	5d                   	pop    %ebp
c0106ae2:	c3                   	ret    

c0106ae3 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106ae3:	55                   	push   %ebp
c0106ae4:	89 e5                	mov    %esp,%ebp
c0106ae6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106aec:	c1 e8 0c             	shr    $0xc,%eax
c0106aef:	89 c2                	mov    %eax,%edx
c0106af1:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0106af6:	39 c2                	cmp    %eax,%edx
c0106af8:	72 1c                	jb     c0106b16 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106afa:	c7 44 24 08 fc ce 10 	movl   $0xc010cefc,0x8(%esp)
c0106b01:	c0 
c0106b02:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106b09:	00 
c0106b0a:	c7 04 24 1b cf 10 c0 	movl   $0xc010cf1b,(%esp)
c0106b11:	e8 bf a2 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106b16:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0106b1b:	8b 55 08             	mov    0x8(%ebp),%edx
c0106b1e:	c1 ea 0c             	shr    $0xc,%edx
c0106b21:	c1 e2 05             	shl    $0x5,%edx
c0106b24:	01 d0                	add    %edx,%eax
}
c0106b26:	c9                   	leave  
c0106b27:	c3                   	ret    

c0106b28 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106b28:	55                   	push   %ebp
c0106b29:	89 e5                	mov    %esp,%ebp
c0106b2b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b31:	83 e0 01             	and    $0x1,%eax
c0106b34:	85 c0                	test   %eax,%eax
c0106b36:	75 1c                	jne    c0106b54 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106b38:	c7 44 24 08 2c cf 10 	movl   $0xc010cf2c,0x8(%esp)
c0106b3f:	c0 
c0106b40:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106b47:	00 
c0106b48:	c7 04 24 1b cf 10 c0 	movl   $0xc010cf1b,(%esp)
c0106b4f:	e8 81 a2 ff ff       	call   c0100dd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106b54:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106b5c:	89 04 24             	mov    %eax,(%esp)
c0106b5f:	e8 7f ff ff ff       	call   c0106ae3 <pa2page>
}
c0106b64:	c9                   	leave  
c0106b65:	c3                   	ret    

c0106b66 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106b66:	55                   	push   %ebp
c0106b67:	89 e5                	mov    %esp,%ebp
c0106b69:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106b74:	89 04 24             	mov    %eax,(%esp)
c0106b77:	e8 67 ff ff ff       	call   c0106ae3 <pa2page>
}
c0106b7c:	c9                   	leave  
c0106b7d:	c3                   	ret    

c0106b7e <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106b7e:	55                   	push   %ebp
c0106b7f:	89 e5                	mov    %esp,%ebp
c0106b81:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106b84:	e8 a6 22 00 00       	call   c0108e2f <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106b89:	a1 7c e0 19 c0       	mov    0xc019e07c,%eax
c0106b8e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106b93:	76 0c                	jbe    c0106ba1 <swap_init+0x23>
c0106b95:	a1 7c e0 19 c0       	mov    0xc019e07c,%eax
c0106b9a:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106b9f:	76 25                	jbe    c0106bc6 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106ba1:	a1 7c e0 19 c0       	mov    0xc019e07c,%eax
c0106ba6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106baa:	c7 44 24 08 4d cf 10 	movl   $0xc010cf4d,0x8(%esp)
c0106bb1:	c0 
c0106bb2:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106bb9:	00 
c0106bba:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106bc1:	e8 0f a2 ff ff       	call   c0100dd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106bc6:	c7 05 74 bf 19 c0 60 	movl   $0xc0129a60,0xc019bf74
c0106bcd:	9a 12 c0 
     int r = sm->init();
c0106bd0:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106bd5:	8b 40 04             	mov    0x4(%eax),%eax
c0106bd8:	ff d0                	call   *%eax
c0106bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106bdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106be1:	75 26                	jne    c0106c09 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106be3:	c7 05 6c bf 19 c0 01 	movl   $0x1,0xc019bf6c
c0106bea:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106bed:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106bf2:	8b 00                	mov    (%eax),%eax
c0106bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106bf8:	c7 04 24 77 cf 10 c0 	movl   $0xc010cf77,(%esp)
c0106bff:	e8 4f 97 ff ff       	call   c0100353 <cprintf>
          check_swap();
c0106c04:	e8 a4 04 00 00       	call   c01070ad <check_swap>
     }

     return r;
c0106c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106c0c:	c9                   	leave  
c0106c0d:	c3                   	ret    

c0106c0e <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106c0e:	55                   	push   %ebp
c0106c0f:	89 e5                	mov    %esp,%ebp
c0106c11:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106c14:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106c19:	8b 40 08             	mov    0x8(%eax),%eax
c0106c1c:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c1f:	89 14 24             	mov    %edx,(%esp)
c0106c22:	ff d0                	call   *%eax
}
c0106c24:	c9                   	leave  
c0106c25:	c3                   	ret    

c0106c26 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106c26:	55                   	push   %ebp
c0106c27:	89 e5                	mov    %esp,%ebp
c0106c29:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106c2c:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106c31:	8b 40 0c             	mov    0xc(%eax),%eax
c0106c34:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c37:	89 14 24             	mov    %edx,(%esp)
c0106c3a:	ff d0                	call   *%eax
}
c0106c3c:	c9                   	leave  
c0106c3d:	c3                   	ret    

c0106c3e <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106c3e:	55                   	push   %ebp
c0106c3f:	89 e5                	mov    %esp,%ebp
c0106c41:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106c44:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106c49:	8b 40 10             	mov    0x10(%eax),%eax
c0106c4c:	8b 55 14             	mov    0x14(%ebp),%edx
c0106c4f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106c53:	8b 55 10             	mov    0x10(%ebp),%edx
c0106c56:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c5d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c61:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c64:	89 14 24             	mov    %edx,(%esp)
c0106c67:	ff d0                	call   *%eax
}
c0106c69:	c9                   	leave  
c0106c6a:	c3                   	ret    

c0106c6b <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106c6b:	55                   	push   %ebp
c0106c6c:	89 e5                	mov    %esp,%ebp
c0106c6e:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106c71:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106c76:	8b 40 14             	mov    0x14(%eax),%eax
c0106c79:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106c7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c80:	8b 55 08             	mov    0x8(%ebp),%edx
c0106c83:	89 14 24             	mov    %edx,(%esp)
c0106c86:	ff d0                	call   *%eax
}
c0106c88:	c9                   	leave  
c0106c89:	c3                   	ret    

c0106c8a <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106c8a:	55                   	push   %ebp
c0106c8b:	89 e5                	mov    %esp,%ebp
c0106c8d:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106c90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106c97:	e9 5a 01 00 00       	jmp    c0106df6 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106c9c:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106ca1:	8b 40 18             	mov    0x18(%eax),%eax
c0106ca4:	8b 55 10             	mov    0x10(%ebp),%edx
c0106ca7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106cab:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106cae:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cb2:	8b 55 08             	mov    0x8(%ebp),%edx
c0106cb5:	89 14 24             	mov    %edx,(%esp)
c0106cb8:	ff d0                	call   *%eax
c0106cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106cbd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106cc1:	74 18                	je     c0106cdb <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106cca:	c7 04 24 8c cf 10 c0 	movl   $0xc010cf8c,(%esp)
c0106cd1:	e8 7d 96 ff ff       	call   c0100353 <cprintf>
c0106cd6:	e9 27 01 00 00       	jmp    c0106e02 <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106cdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cde:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ce7:	8b 40 0c             	mov    0xc(%eax),%eax
c0106cea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106cf1:	00 
c0106cf2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106cf5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cf9:	89 04 24             	mov    %eax,(%esp)
c0106cfc:	e8 e6 e8 ff ff       	call   c01055e7 <get_pte>
c0106d01:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d07:	8b 00                	mov    (%eax),%eax
c0106d09:	83 e0 01             	and    $0x1,%eax
c0106d0c:	85 c0                	test   %eax,%eax
c0106d0e:	75 24                	jne    c0106d34 <swap_out+0xaa>
c0106d10:	c7 44 24 0c b9 cf 10 	movl   $0xc010cfb9,0xc(%esp)
c0106d17:	c0 
c0106d18:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106d1f:	c0 
c0106d20:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106d27:	00 
c0106d28:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106d2f:	e8 a1 a0 ff ff       	call   c0100dd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106d34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d37:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d3a:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106d3d:	c1 ea 0c             	shr    $0xc,%edx
c0106d40:	83 c2 01             	add    $0x1,%edx
c0106d43:	c1 e2 08             	shl    $0x8,%edx
c0106d46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d4a:	89 14 24             	mov    %edx,(%esp)
c0106d4d:	e8 97 21 00 00       	call   c0108ee9 <swapfs_write>
c0106d52:	85 c0                	test   %eax,%eax
c0106d54:	74 34                	je     c0106d8a <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106d56:	c7 04 24 e3 cf 10 c0 	movl   $0xc010cfe3,(%esp)
c0106d5d:	e8 f1 95 ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c0106d62:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c0106d67:	8b 40 10             	mov    0x10(%eax),%eax
c0106d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106d6d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106d74:	00 
c0106d75:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106d79:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d7c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106d80:	8b 55 08             	mov    0x8(%ebp),%edx
c0106d83:	89 14 24             	mov    %edx,(%esp)
c0106d86:	ff d0                	call   *%eax
c0106d88:	eb 68                	jmp    c0106df2 <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106d8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d8d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106d90:	c1 e8 0c             	shr    $0xc,%eax
c0106d93:	83 c0 01             	add    $0x1,%eax
c0106d96:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106d9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106d9d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106da4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106da8:	c7 04 24 fc cf 10 c0 	movl   $0xc010cffc,(%esp)
c0106daf:	e8 9f 95 ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106db7:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106dba:	c1 e8 0c             	shr    $0xc,%eax
c0106dbd:	83 c0 01             	add    $0x1,%eax
c0106dc0:	c1 e0 08             	shl    $0x8,%eax
c0106dc3:	89 c2                	mov    %eax,%edx
c0106dc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106dc8:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106dcd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106dd4:	00 
c0106dd5:	89 04 24             	mov    %eax,(%esp)
c0106dd8:	e8 0e e1 ff ff       	call   c0104eeb <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106ddd:	8b 45 08             	mov    0x8(%ebp),%eax
c0106de0:	8b 40 0c             	mov    0xc(%eax),%eax
c0106de3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106de6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106dea:	89 04 24             	mov    %eax,(%esp)
c0106ded:	e8 0c ef ff ff       	call   c0105cfe <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106df2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106df9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106dfc:	0f 85 9a fe ff ff    	jne    c0106c9c <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106e05:	c9                   	leave  
c0106e06:	c3                   	ret    

c0106e07 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106e07:	55                   	push   %ebp
c0106e08:	89 e5                	mov    %esp,%ebp
c0106e0a:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106e0d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106e14:	e8 67 e0 ff ff       	call   c0104e80 <alloc_pages>
c0106e19:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106e1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e20:	75 24                	jne    c0106e46 <swap_in+0x3f>
c0106e22:	c7 44 24 0c 3c d0 10 	movl   $0xc010d03c,0xc(%esp)
c0106e29:	c0 
c0106e2a:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106e31:	c0 
c0106e32:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0106e39:	00 
c0106e3a:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106e41:	e8 8f 9f ff ff       	call   c0100dd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106e46:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e49:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106e53:	00 
c0106e54:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106e57:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e5b:	89 04 24             	mov    %eax,(%esp)
c0106e5e:	e8 84 e7 ff ff       	call   c01055e7 <get_pte>
c0106e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106e69:	8b 00                	mov    (%eax),%eax
c0106e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106e6e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106e72:	89 04 24             	mov    %eax,(%esp)
c0106e75:	e8 fd 1f 00 00       	call   c0108e77 <swapfs_read>
c0106e7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106e7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106e81:	74 2a                	je     c0106ead <swap_in+0xa6>
     {
        assert(r!=0);
c0106e83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106e87:	75 24                	jne    c0106ead <swap_in+0xa6>
c0106e89:	c7 44 24 0c 49 d0 10 	movl   $0xc010d049,0xc(%esp)
c0106e90:	c0 
c0106e91:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106e98:	c0 
c0106e99:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c0106ea0:	00 
c0106ea1:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106ea8:	e8 28 9f ff ff       	call   c0100dd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eb0:	8b 00                	mov    (%eax),%eax
c0106eb2:	c1 e8 08             	shr    $0x8,%eax
c0106eb5:	89 c2                	mov    %eax,%edx
c0106eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106eba:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106ebe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106ec2:	c7 04 24 50 d0 10 c0 	movl   $0xc010d050,(%esp)
c0106ec9:	e8 85 94 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c0106ece:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ed1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106ed4:	89 10                	mov    %edx,(%eax)
     return 0;
c0106ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106edb:	c9                   	leave  
c0106edc:	c3                   	ret    

c0106edd <check_content_set>:



static inline void
check_content_set(void)
{
c0106edd:	55                   	push   %ebp
c0106ede:	89 e5                	mov    %esp,%ebp
c0106ee0:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106ee3:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106ee8:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106eeb:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106ef0:	83 f8 01             	cmp    $0x1,%eax
c0106ef3:	74 24                	je     c0106f19 <check_content_set+0x3c>
c0106ef5:	c7 44 24 0c 8e d0 10 	movl   $0xc010d08e,0xc(%esp)
c0106efc:	c0 
c0106efd:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106f04:	c0 
c0106f05:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106f0c:	00 
c0106f0d:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106f14:	e8 bc 9e ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106f19:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106f1e:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106f21:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106f26:	83 f8 01             	cmp    $0x1,%eax
c0106f29:	74 24                	je     c0106f4f <check_content_set+0x72>
c0106f2b:	c7 44 24 0c 8e d0 10 	movl   $0xc010d08e,0xc(%esp)
c0106f32:	c0 
c0106f33:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106f3a:	c0 
c0106f3b:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106f42:	00 
c0106f43:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106f4a:	e8 86 9e ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106f4f:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106f54:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106f57:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106f5c:	83 f8 02             	cmp    $0x2,%eax
c0106f5f:	74 24                	je     c0106f85 <check_content_set+0xa8>
c0106f61:	c7 44 24 0c 9d d0 10 	movl   $0xc010d09d,0xc(%esp)
c0106f68:	c0 
c0106f69:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106f70:	c0 
c0106f71:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106f78:	00 
c0106f79:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106f80:	e8 50 9e ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106f85:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106f8a:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106f8d:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106f92:	83 f8 02             	cmp    $0x2,%eax
c0106f95:	74 24                	je     c0106fbb <check_content_set+0xde>
c0106f97:	c7 44 24 0c 9d d0 10 	movl   $0xc010d09d,0xc(%esp)
c0106f9e:	c0 
c0106f9f:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106fa6:	c0 
c0106fa7:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106fae:	00 
c0106faf:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106fb6:	e8 1a 9e ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106fbb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106fc0:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106fc3:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106fc8:	83 f8 03             	cmp    $0x3,%eax
c0106fcb:	74 24                	je     c0106ff1 <check_content_set+0x114>
c0106fcd:	c7 44 24 0c ac d0 10 	movl   $0xc010d0ac,0xc(%esp)
c0106fd4:	c0 
c0106fd5:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0106fdc:	c0 
c0106fdd:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106fe4:	00 
c0106fe5:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0106fec:	e8 e4 9d ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106ff1:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106ff6:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106ff9:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0106ffe:	83 f8 03             	cmp    $0x3,%eax
c0107001:	74 24                	je     c0107027 <check_content_set+0x14a>
c0107003:	c7 44 24 0c ac d0 10 	movl   $0xc010d0ac,0xc(%esp)
c010700a:	c0 
c010700b:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107012:	c0 
c0107013:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010701a:	00 
c010701b:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107022:	e8 ae 9d ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0107027:	b8 00 40 00 00       	mov    $0x4000,%eax
c010702c:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010702f:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107034:	83 f8 04             	cmp    $0x4,%eax
c0107037:	74 24                	je     c010705d <check_content_set+0x180>
c0107039:	c7 44 24 0c bb d0 10 	movl   $0xc010d0bb,0xc(%esp)
c0107040:	c0 
c0107041:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107048:	c0 
c0107049:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0107050:	00 
c0107051:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107058:	e8 78 9d ff ff       	call   c0100dd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c010705d:	b8 10 40 00 00       	mov    $0x4010,%eax
c0107062:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0107065:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c010706a:	83 f8 04             	cmp    $0x4,%eax
c010706d:	74 24                	je     c0107093 <check_content_set+0x1b6>
c010706f:	c7 44 24 0c bb d0 10 	movl   $0xc010d0bb,0xc(%esp)
c0107076:	c0 
c0107077:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c010707e:	c0 
c010707f:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0107086:	00 
c0107087:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c010708e:	e8 42 9d ff ff       	call   c0100dd5 <__panic>
}
c0107093:	c9                   	leave  
c0107094:	c3                   	ret    

c0107095 <check_content_access>:

static inline int
check_content_access(void)
{
c0107095:	55                   	push   %ebp
c0107096:	89 e5                	mov    %esp,%ebp
c0107098:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c010709b:	a1 74 bf 19 c0       	mov    0xc019bf74,%eax
c01070a0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01070a3:	ff d0                	call   *%eax
c01070a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01070a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01070ab:	c9                   	leave  
c01070ac:	c3                   	ret    

c01070ad <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01070ad:	55                   	push   %ebp
c01070ae:	89 e5                	mov    %esp,%ebp
c01070b0:	53                   	push   %ebx
c01070b1:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01070b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01070bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01070c2:	c7 45 e8 b8 df 19 c0 	movl   $0xc019dfb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01070c9:	eb 6b                	jmp    c0107136 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01070cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01070ce:	83 e8 0c             	sub    $0xc,%eax
c01070d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01070d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01070d7:	83 c0 04             	add    $0x4,%eax
c01070da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c01070e1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01070e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01070e7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01070ea:	0f a3 10             	bt     %edx,(%eax)
c01070ed:	19 c0                	sbb    %eax,%eax
c01070ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c01070f2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01070f6:	0f 95 c0             	setne  %al
c01070f9:	0f b6 c0             	movzbl %al,%eax
c01070fc:	85 c0                	test   %eax,%eax
c01070fe:	75 24                	jne    c0107124 <check_swap+0x77>
c0107100:	c7 44 24 0c ca d0 10 	movl   $0xc010d0ca,0xc(%esp)
c0107107:	c0 
c0107108:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c010710f:	c0 
c0107110:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0107117:	00 
c0107118:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c010711f:	e8 b1 9c ff ff       	call   c0100dd5 <__panic>
        count ++, total += p->property;
c0107124:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010712b:	8b 50 08             	mov    0x8(%eax),%edx
c010712e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107131:	01 d0                	add    %edx,%eax
c0107133:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107136:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107139:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010713c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010713f:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107142:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107145:	81 7d e8 b8 df 19 c0 	cmpl   $0xc019dfb8,-0x18(%ebp)
c010714c:	0f 85 79 ff ff ff    	jne    c01070cb <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0107152:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0107155:	e8 c3 dd ff ff       	call   c0104f1d <nr_free_pages>
c010715a:	39 c3                	cmp    %eax,%ebx
c010715c:	74 24                	je     c0107182 <check_swap+0xd5>
c010715e:	c7 44 24 0c da d0 10 	movl   $0xc010d0da,0xc(%esp)
c0107165:	c0 
c0107166:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c010716d:	c0 
c010716e:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0107175:	00 
c0107176:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c010717d:	e8 53 9c ff ff       	call   c0100dd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0107182:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107185:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107189:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010718c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107190:	c7 04 24 f4 d0 10 c0 	movl   $0xc010d0f4,(%esp)
c0107197:	e8 b7 91 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c010719c:	e8 5e 0a 00 00       	call   c0107bff <mm_create>
c01071a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01071a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01071a8:	75 24                	jne    c01071ce <check_swap+0x121>
c01071aa:	c7 44 24 0c 1a d1 10 	movl   $0xc010d11a,0xc(%esp)
c01071b1:	c0 
c01071b2:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01071b9:	c0 
c01071ba:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c01071c1:	00 
c01071c2:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01071c9:	e8 07 9c ff ff       	call   c0100dd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01071ce:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c01071d3:	85 c0                	test   %eax,%eax
c01071d5:	74 24                	je     c01071fb <check_swap+0x14e>
c01071d7:	c7 44 24 0c 25 d1 10 	movl   $0xc010d125,0xc(%esp)
c01071de:	c0 
c01071df:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01071e6:	c0 
c01071e7:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01071ee:	00 
c01071ef:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01071f6:	e8 da 9b ff ff       	call   c0100dd5 <__panic>

     check_mm_struct = mm;
c01071fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01071fe:	a3 ac e0 19 c0       	mov    %eax,0xc019e0ac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107203:	8b 15 e4 be 19 c0    	mov    0xc019bee4,%edx
c0107209:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010720c:	89 50 0c             	mov    %edx,0xc(%eax)
c010720f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107212:	8b 40 0c             	mov    0xc(%eax),%eax
c0107215:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0107218:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010721b:	8b 00                	mov    (%eax),%eax
c010721d:	85 c0                	test   %eax,%eax
c010721f:	74 24                	je     c0107245 <check_swap+0x198>
c0107221:	c7 44 24 0c 3d d1 10 	movl   $0xc010d13d,0xc(%esp)
c0107228:	c0 
c0107229:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107230:	c0 
c0107231:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0107238:	00 
c0107239:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107240:	e8 90 9b ff ff       	call   c0100dd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0107245:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c010724c:	00 
c010724d:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0107254:	00 
c0107255:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c010725c:	e8 37 0a 00 00       	call   c0107c98 <vma_create>
c0107261:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0107264:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107268:	75 24                	jne    c010728e <check_swap+0x1e1>
c010726a:	c7 44 24 0c 4b d1 10 	movl   $0xc010d14b,0xc(%esp)
c0107271:	c0 
c0107272:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107279:	c0 
c010727a:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107281:	00 
c0107282:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107289:	e8 47 9b ff ff       	call   c0100dd5 <__panic>

     insert_vma_struct(mm, vma);
c010728e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107291:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107295:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107298:	89 04 24             	mov    %eax,(%esp)
c010729b:	e8 88 0b 00 00       	call   c0107e28 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01072a0:	c7 04 24 58 d1 10 c0 	movl   $0xc010d158,(%esp)
c01072a7:	e8 a7 90 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c01072ac:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01072b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072b6:	8b 40 0c             	mov    0xc(%eax),%eax
c01072b9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01072c0:	00 
c01072c1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01072c8:	00 
c01072c9:	89 04 24             	mov    %eax,(%esp)
c01072cc:	e8 16 e3 ff ff       	call   c01055e7 <get_pte>
c01072d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01072d4:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c01072d8:	75 24                	jne    c01072fe <check_swap+0x251>
c01072da:	c7 44 24 0c 8c d1 10 	movl   $0xc010d18c,0xc(%esp)
c01072e1:	c0 
c01072e2:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01072e9:	c0 
c01072ea:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01072f1:	00 
c01072f2:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01072f9:	e8 d7 9a ff ff       	call   c0100dd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01072fe:	c7 04 24 a0 d1 10 c0 	movl   $0xc010d1a0,(%esp)
c0107305:	e8 49 90 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010730a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107311:	e9 a3 00 00 00       	jmp    c01073b9 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0107316:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010731d:	e8 5e db ff ff       	call   c0104e80 <alloc_pages>
c0107322:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107325:	89 04 95 e0 df 19 c0 	mov    %eax,-0x3fe62020(,%edx,4)
          assert(check_rp[i] != NULL );
c010732c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010732f:	8b 04 85 e0 df 19 c0 	mov    -0x3fe62020(,%eax,4),%eax
c0107336:	85 c0                	test   %eax,%eax
c0107338:	75 24                	jne    c010735e <check_swap+0x2b1>
c010733a:	c7 44 24 0c c4 d1 10 	movl   $0xc010d1c4,0xc(%esp)
c0107341:	c0 
c0107342:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107349:	c0 
c010734a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0107351:	00 
c0107352:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107359:	e8 77 9a ff ff       	call   c0100dd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c010735e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107361:	8b 04 85 e0 df 19 c0 	mov    -0x3fe62020(,%eax,4),%eax
c0107368:	83 c0 04             	add    $0x4,%eax
c010736b:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0107372:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107375:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107378:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010737b:	0f a3 10             	bt     %edx,(%eax)
c010737e:	19 c0                	sbb    %eax,%eax
c0107380:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0107383:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0107387:	0f 95 c0             	setne  %al
c010738a:	0f b6 c0             	movzbl %al,%eax
c010738d:	85 c0                	test   %eax,%eax
c010738f:	74 24                	je     c01073b5 <check_swap+0x308>
c0107391:	c7 44 24 0c d8 d1 10 	movl   $0xc010d1d8,0xc(%esp)
c0107398:	c0 
c0107399:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01073a0:	c0 
c01073a1:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c01073a8:	00 
c01073a9:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01073b0:	e8 20 9a ff ff       	call   c0100dd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01073b5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01073b9:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01073bd:	0f 8e 53 ff ff ff    	jle    c0107316 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01073c3:	a1 b8 df 19 c0       	mov    0xc019dfb8,%eax
c01073c8:	8b 15 bc df 19 c0    	mov    0xc019dfbc,%edx
c01073ce:	89 45 98             	mov    %eax,-0x68(%ebp)
c01073d1:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01073d4:	c7 45 a8 b8 df 19 c0 	movl   $0xc019dfb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01073db:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01073de:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01073e1:	89 50 04             	mov    %edx,0x4(%eax)
c01073e4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01073e7:	8b 50 04             	mov    0x4(%eax),%edx
c01073ea:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01073ed:	89 10                	mov    %edx,(%eax)
c01073ef:	c7 45 a4 b8 df 19 c0 	movl   $0xc019dfb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01073f6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01073f9:	8b 40 04             	mov    0x4(%eax),%eax
c01073fc:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01073ff:	0f 94 c0             	sete   %al
c0107402:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0107405:	85 c0                	test   %eax,%eax
c0107407:	75 24                	jne    c010742d <check_swap+0x380>
c0107409:	c7 44 24 0c f3 d1 10 	movl   $0xc010d1f3,0xc(%esp)
c0107410:	c0 
c0107411:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107418:	c0 
c0107419:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0107420:	00 
c0107421:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107428:	e8 a8 99 ff ff       	call   c0100dd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c010742d:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0107432:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0107435:	c7 05 c0 df 19 c0 00 	movl   $0x0,0xc019dfc0
c010743c:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010743f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107446:	eb 1e                	jmp    c0107466 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0107448:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010744b:	8b 04 85 e0 df 19 c0 	mov    -0x3fe62020(,%eax,4),%eax
c0107452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107459:	00 
c010745a:	89 04 24             	mov    %eax,(%esp)
c010745d:	e8 89 da ff ff       	call   c0104eeb <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107462:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107466:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010746a:	7e dc                	jle    c0107448 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c010746c:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c0107471:	83 f8 04             	cmp    $0x4,%eax
c0107474:	74 24                	je     c010749a <check_swap+0x3ed>
c0107476:	c7 44 24 0c 0c d2 10 	movl   $0xc010d20c,0xc(%esp)
c010747d:	c0 
c010747e:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107485:	c0 
c0107486:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010748d:	00 
c010748e:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107495:	e8 3b 99 ff ff       	call   c0100dd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c010749a:	c7 04 24 30 d2 10 c0 	movl   $0xc010d230,(%esp)
c01074a1:	e8 ad 8e ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01074a6:	c7 05 78 bf 19 c0 00 	movl   $0x0,0xc019bf78
c01074ad:	00 00 00 
     
     check_content_set();
c01074b0:	e8 28 fa ff ff       	call   c0106edd <check_content_set>
     assert( nr_free == 0);         
c01074b5:	a1 c0 df 19 c0       	mov    0xc019dfc0,%eax
c01074ba:	85 c0                	test   %eax,%eax
c01074bc:	74 24                	je     c01074e2 <check_swap+0x435>
c01074be:	c7 44 24 0c 57 d2 10 	movl   $0xc010d257,0xc(%esp)
c01074c5:	c0 
c01074c6:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01074cd:	c0 
c01074ce:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c01074d5:	00 
c01074d6:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01074dd:	e8 f3 98 ff ff       	call   c0100dd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01074e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01074e9:	eb 26                	jmp    c0107511 <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01074eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074ee:	c7 04 85 00 e0 19 c0 	movl   $0xffffffff,-0x3fe62000(,%eax,4)
c01074f5:	ff ff ff ff 
c01074f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01074fc:	8b 14 85 00 e0 19 c0 	mov    -0x3fe62000(,%eax,4),%edx
c0107503:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107506:	89 14 85 40 e0 19 c0 	mov    %edx,-0x3fe61fc0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010750d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107511:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0107515:	7e d4                	jle    c01074eb <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107517:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010751e:	e9 eb 00 00 00       	jmp    c010760e <check_swap+0x561>
         check_ptep[i]=0;
c0107523:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107526:	c7 04 85 94 e0 19 c0 	movl   $0x0,-0x3fe61f6c(,%eax,4)
c010752d:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0107531:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107534:	83 c0 01             	add    $0x1,%eax
c0107537:	c1 e0 0c             	shl    $0xc,%eax
c010753a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107541:	00 
c0107542:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107546:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107549:	89 04 24             	mov    %eax,(%esp)
c010754c:	e8 96 e0 ff ff       	call   c01055e7 <get_pte>
c0107551:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107554:	89 04 95 94 e0 19 c0 	mov    %eax,-0x3fe61f6c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c010755b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010755e:	8b 04 85 94 e0 19 c0 	mov    -0x3fe61f6c(,%eax,4),%eax
c0107565:	85 c0                	test   %eax,%eax
c0107567:	75 24                	jne    c010758d <check_swap+0x4e0>
c0107569:	c7 44 24 0c 64 d2 10 	movl   $0xc010d264,0xc(%esp)
c0107570:	c0 
c0107571:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107578:	c0 
c0107579:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0107580:	00 
c0107581:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107588:	e8 48 98 ff ff       	call   c0100dd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010758d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107590:	8b 04 85 94 e0 19 c0 	mov    -0x3fe61f6c(,%eax,4),%eax
c0107597:	8b 00                	mov    (%eax),%eax
c0107599:	89 04 24             	mov    %eax,(%esp)
c010759c:	e8 87 f5 ff ff       	call   c0106b28 <pte2page>
c01075a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01075a4:	8b 14 95 e0 df 19 c0 	mov    -0x3fe62020(,%edx,4),%edx
c01075ab:	39 d0                	cmp    %edx,%eax
c01075ad:	74 24                	je     c01075d3 <check_swap+0x526>
c01075af:	c7 44 24 0c 7c d2 10 	movl   $0xc010d27c,0xc(%esp)
c01075b6:	c0 
c01075b7:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01075be:	c0 
c01075bf:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01075c6:	00 
c01075c7:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c01075ce:	e8 02 98 ff ff       	call   c0100dd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c01075d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075d6:	8b 04 85 94 e0 19 c0 	mov    -0x3fe61f6c(,%eax,4),%eax
c01075dd:	8b 00                	mov    (%eax),%eax
c01075df:	83 e0 01             	and    $0x1,%eax
c01075e2:	85 c0                	test   %eax,%eax
c01075e4:	75 24                	jne    c010760a <check_swap+0x55d>
c01075e6:	c7 44 24 0c a4 d2 10 	movl   $0xc010d2a4,0xc(%esp)
c01075ed:	c0 
c01075ee:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c01075f5:	c0 
c01075f6:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01075fd:	00 
c01075fe:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107605:	e8 cb 97 ff ff       	call   c0100dd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010760a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010760e:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107612:	0f 8e 0b ff ff ff    	jle    c0107523 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0107618:	c7 04 24 c0 d2 10 c0 	movl   $0xc010d2c0,(%esp)
c010761f:	e8 2f 8d ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0107624:	e8 6c fa ff ff       	call   c0107095 <check_content_access>
c0107629:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c010762c:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107630:	74 24                	je     c0107656 <check_swap+0x5a9>
c0107632:	c7 44 24 0c e6 d2 10 	movl   $0xc010d2e6,0xc(%esp)
c0107639:	c0 
c010763a:	c7 44 24 08 ce cf 10 	movl   $0xc010cfce,0x8(%esp)
c0107641:	c0 
c0107642:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0107649:	00 
c010764a:	c7 04 24 68 cf 10 c0 	movl   $0xc010cf68,(%esp)
c0107651:	e8 7f 97 ff ff       	call   c0100dd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107656:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010765d:	eb 1e                	jmp    c010767d <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c010765f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107662:	8b 04 85 e0 df 19 c0 	mov    -0x3fe62020(,%eax,4),%eax
c0107669:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107670:	00 
c0107671:	89 04 24             	mov    %eax,(%esp)
c0107674:	e8 72 d8 ff ff       	call   c0104eeb <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107679:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010767d:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107681:	7e dc                	jle    c010765f <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pde2page(pgdir[0]));
c0107683:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107686:	8b 00                	mov    (%eax),%eax
c0107688:	89 04 24             	mov    %eax,(%esp)
c010768b:	e8 d6 f4 ff ff       	call   c0106b66 <pde2page>
c0107690:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107697:	00 
c0107698:	89 04 24             	mov    %eax,(%esp)
c010769b:	e8 4b d8 ff ff       	call   c0104eeb <free_pages>
     pgdir[0] = 0;
c01076a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01076a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c01076a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01076ac:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c01076b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01076b6:	89 04 24             	mov    %eax,(%esp)
c01076b9:	e8 9a 08 00 00       	call   c0107f58 <mm_destroy>
     check_mm_struct = NULL;
c01076be:	c7 05 ac e0 19 c0 00 	movl   $0x0,0xc019e0ac
c01076c5:	00 00 00 
     
     nr_free = nr_free_store;
c01076c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01076cb:	a3 c0 df 19 c0       	mov    %eax,0xc019dfc0
     free_list = free_list_store;
c01076d0:	8b 45 98             	mov    -0x68(%ebp),%eax
c01076d3:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01076d6:	a3 b8 df 19 c0       	mov    %eax,0xc019dfb8
c01076db:	89 15 bc df 19 c0    	mov    %edx,0xc019dfbc

     
     le = &free_list;
c01076e1:	c7 45 e8 b8 df 19 c0 	movl   $0xc019dfb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01076e8:	eb 1d                	jmp    c0107707 <check_swap+0x65a>
         struct Page *p = le2page(le, page_link);
c01076ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076ed:	83 e8 0c             	sub    $0xc,%eax
c01076f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c01076f3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01076f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01076fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01076fd:	8b 40 08             	mov    0x8(%eax),%eax
c0107700:	29 c2                	sub    %eax,%edx
c0107702:	89 d0                	mov    %edx,%eax
c0107704:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107707:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010770a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010770d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107710:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107713:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107716:	81 7d e8 b8 df 19 c0 	cmpl   $0xc019dfb8,-0x18(%ebp)
c010771d:	75 cb                	jne    c01076ea <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c010771f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107722:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107726:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010772d:	c7 04 24 ed d2 10 c0 	movl   $0xc010d2ed,(%esp)
c0107734:	e8 1a 8c ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0107739:	c7 04 24 07 d3 10 c0 	movl   $0xc010d307,(%esp)
c0107740:	e8 0e 8c ff ff       	call   c0100353 <cprintf>
}
c0107745:	83 c4 74             	add    $0x74,%esp
c0107748:	5b                   	pop    %ebx
c0107749:	5d                   	pop    %ebp
c010774a:	c3                   	ret    

c010774b <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c010774b:	55                   	push   %ebp
c010774c:	89 e5                	mov    %esp,%ebp
c010774e:	83 ec 10             	sub    $0x10,%esp
c0107751:	c7 45 fc a4 e0 19 c0 	movl   $0xc019e0a4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107758:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010775b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010775e:	89 50 04             	mov    %edx,0x4(%eax)
c0107761:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107764:	8b 50 04             	mov    0x4(%eax),%edx
c0107767:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010776a:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c010776c:	8b 45 08             	mov    0x8(%ebp),%eax
c010776f:	c7 40 14 a4 e0 19 c0 	movl   $0xc019e0a4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107776:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010777b:	c9                   	leave  
c010777c:	c3                   	ret    

c010777d <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010777d:	55                   	push   %ebp
c010777e:	89 e5                	mov    %esp,%ebp
c0107780:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107783:	8b 45 08             	mov    0x8(%ebp),%eax
c0107786:	8b 40 14             	mov    0x14(%eax),%eax
c0107789:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c010778c:	8b 45 10             	mov    0x10(%ebp),%eax
c010778f:	83 c0 14             	add    $0x14,%eax
c0107792:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107795:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107799:	74 06                	je     c01077a1 <_fifo_map_swappable+0x24>
c010779b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010779f:	75 24                	jne    c01077c5 <_fifo_map_swappable+0x48>
c01077a1:	c7 44 24 0c 20 d3 10 	movl   $0xc010d320,0xc(%esp)
c01077a8:	c0 
c01077a9:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c01077b0:	c0 
c01077b1:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c01077b8:	00 
c01077b9:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c01077c0:	e8 10 96 ff ff       	call   c0100dd5 <__panic>
c01077c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01077cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01077ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01077d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077d4:	8b 40 04             	mov    0x4(%eax),%eax
c01077d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01077da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01077dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01077e0:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01077e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01077e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01077ec:	89 10                	mov    %edx,(%eax)
c01077ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077f1:	8b 10                	mov    (%eax),%edx
c01077f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01077f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01077f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077fc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01077ff:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107805:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107808:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2013011303*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
c010780a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010780f:	c9                   	leave  
c0107810:	c3                   	ret    

c0107811 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107811:	55                   	push   %ebp
c0107812:	89 e5                	mov    %esp,%ebp
c0107814:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107817:	8b 45 08             	mov    0x8(%ebp),%eax
c010781a:	8b 40 14             	mov    0x14(%eax),%eax
c010781d:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107820:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107824:	75 24                	jne    c010784a <_fifo_swap_out_victim+0x39>
c0107826:	c7 44 24 0c 67 d3 10 	movl   $0xc010d367,0xc(%esp)
c010782d:	c0 
c010782e:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107835:	c0 
c0107836:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c010783d:	00 
c010783e:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107845:	e8 8b 95 ff ff       	call   c0100dd5 <__panic>
     assert(in_tick==0);
c010784a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010784e:	74 24                	je     c0107874 <_fifo_swap_out_victim+0x63>
c0107850:	c7 44 24 0c 74 d3 10 	movl   $0xc010d374,0xc(%esp)
c0107857:	c0 
c0107858:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c010785f:	c0 
c0107860:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107867:	00 
c0107868:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c010786f:	e8 61 95 ff ff       	call   c0100dd5 <__panic>
c0107874:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107877:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010787a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010787d:	8b 00                	mov    (%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2013011303*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = list_prev(head);
c010787f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     *ptr_page = le2page(le, pra_page_link);
c0107882:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107885:	8d 50 ec             	lea    -0x14(%eax),%edx
c0107888:	8b 45 0c             	mov    0xc(%ebp),%eax
c010788b:	89 10                	mov    %edx,(%eax)
c010788d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107890:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107893:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107896:	8b 40 04             	mov    0x4(%eax),%eax
c0107899:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010789c:	8b 12                	mov    (%edx),%edx
c010789e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01078a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01078a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01078aa:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01078ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01078b3:	89 10                	mov    %edx,(%eax)
     list_del(le);
     return 0;
c01078b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01078ba:	c9                   	leave  
c01078bb:	c3                   	ret    

c01078bc <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01078bc:	55                   	push   %ebp
c01078bd:	89 e5                	mov    %esp,%ebp
c01078bf:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c01078c2:	c7 04 24 80 d3 10 c0 	movl   $0xc010d380,(%esp)
c01078c9:	e8 85 8a ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c01078ce:	b8 00 30 00 00       	mov    $0x3000,%eax
c01078d3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c01078d6:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c01078db:	83 f8 04             	cmp    $0x4,%eax
c01078de:	74 24                	je     c0107904 <_fifo_check_swap+0x48>
c01078e0:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c01078e7:	c0 
c01078e8:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c01078ef:	c0 
c01078f0:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
c01078f7:	00 
c01078f8:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c01078ff:	e8 d1 94 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107904:	c7 04 24 b8 d3 10 c0 	movl   $0xc010d3b8,(%esp)
c010790b:	e8 43 8a ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107910:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107915:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107918:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c010791d:	83 f8 04             	cmp    $0x4,%eax
c0107920:	74 24                	je     c0107946 <_fifo_check_swap+0x8a>
c0107922:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c0107929:	c0 
c010792a:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107931:	c0 
c0107932:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0107939:	00 
c010793a:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107941:	e8 8f 94 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107946:	c7 04 24 e0 d3 10 c0 	movl   $0xc010d3e0,(%esp)
c010794d:	e8 01 8a ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107952:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107957:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c010795a:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c010795f:	83 f8 04             	cmp    $0x4,%eax
c0107962:	74 24                	je     c0107988 <_fifo_check_swap+0xcc>
c0107964:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c010796b:	c0 
c010796c:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107973:	c0 
c0107974:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c010797b:	00 
c010797c:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107983:	e8 4d 94 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107988:	c7 04 24 08 d4 10 c0 	movl   $0xc010d408,(%esp)
c010798f:	e8 bf 89 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107994:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107999:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c010799c:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c01079a1:	83 f8 04             	cmp    $0x4,%eax
c01079a4:	74 24                	je     c01079ca <_fifo_check_swap+0x10e>
c01079a6:	c7 44 24 0c a6 d3 10 	movl   $0xc010d3a6,0xc(%esp)
c01079ad:	c0 
c01079ae:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c01079b5:	c0 
c01079b6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01079bd:	00 
c01079be:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c01079c5:	e8 0b 94 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01079ca:	c7 04 24 30 d4 10 c0 	movl   $0xc010d430,(%esp)
c01079d1:	e8 7d 89 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01079d6:	b8 00 50 00 00       	mov    $0x5000,%eax
c01079db:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c01079de:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c01079e3:	83 f8 05             	cmp    $0x5,%eax
c01079e6:	74 24                	je     c0107a0c <_fifo_check_swap+0x150>
c01079e8:	c7 44 24 0c 56 d4 10 	movl   $0xc010d456,0xc(%esp)
c01079ef:	c0 
c01079f0:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c01079f7:	c0 
c01079f8:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c01079ff:	00 
c0107a00:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107a07:	e8 c9 93 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107a0c:	c7 04 24 08 d4 10 c0 	movl   $0xc010d408,(%esp)
c0107a13:	e8 3b 89 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107a18:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107a1d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107a20:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107a25:	83 f8 05             	cmp    $0x5,%eax
c0107a28:	74 24                	je     c0107a4e <_fifo_check_swap+0x192>
c0107a2a:	c7 44 24 0c 56 d4 10 	movl   $0xc010d456,0xc(%esp)
c0107a31:	c0 
c0107a32:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107a39:	c0 
c0107a3a:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107a41:	00 
c0107a42:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107a49:	e8 87 93 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107a4e:	c7 04 24 b8 d3 10 c0 	movl   $0xc010d3b8,(%esp)
c0107a55:	e8 f9 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107a5a:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107a5f:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107a62:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107a67:	83 f8 06             	cmp    $0x6,%eax
c0107a6a:	74 24                	je     c0107a90 <_fifo_check_swap+0x1d4>
c0107a6c:	c7 44 24 0c 65 d4 10 	movl   $0xc010d465,0xc(%esp)
c0107a73:	c0 
c0107a74:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107a7b:	c0 
c0107a7c:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107a83:	00 
c0107a84:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107a8b:	e8 45 93 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107a90:	c7 04 24 08 d4 10 c0 	movl   $0xc010d408,(%esp)
c0107a97:	e8 b7 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107a9c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107aa1:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107aa4:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107aa9:	83 f8 07             	cmp    $0x7,%eax
c0107aac:	74 24                	je     c0107ad2 <_fifo_check_swap+0x216>
c0107aae:	c7 44 24 0c 74 d4 10 	movl   $0xc010d474,0xc(%esp)
c0107ab5:	c0 
c0107ab6:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107abd:	c0 
c0107abe:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107ac5:	00 
c0107ac6:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107acd:	e8 03 93 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107ad2:	c7 04 24 80 d3 10 c0 	movl   $0xc010d380,(%esp)
c0107ad9:	e8 75 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107ade:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107ae3:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107ae6:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107aeb:	83 f8 08             	cmp    $0x8,%eax
c0107aee:	74 24                	je     c0107b14 <_fifo_check_swap+0x258>
c0107af0:	c7 44 24 0c 83 d4 10 	movl   $0xc010d483,0xc(%esp)
c0107af7:	c0 
c0107af8:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107aff:	c0 
c0107b00:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107b07:	00 
c0107b08:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107b0f:	e8 c1 92 ff ff       	call   c0100dd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107b14:	c7 04 24 e0 d3 10 c0 	movl   $0xc010d3e0,(%esp)
c0107b1b:	e8 33 88 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107b20:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107b25:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107b28:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0107b2d:	83 f8 09             	cmp    $0x9,%eax
c0107b30:	74 24                	je     c0107b56 <_fifo_check_swap+0x29a>
c0107b32:	c7 44 24 0c 92 d4 10 	movl   $0xc010d492,0xc(%esp)
c0107b39:	c0 
c0107b3a:	c7 44 24 08 3e d3 10 	movl   $0xc010d33e,0x8(%esp)
c0107b41:	c0 
c0107b42:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107b49:	00 
c0107b4a:	c7 04 24 53 d3 10 c0 	movl   $0xc010d353,(%esp)
c0107b51:	e8 7f 92 ff ff       	call   c0100dd5 <__panic>
    return 0;
c0107b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b5b:	c9                   	leave  
c0107b5c:	c3                   	ret    

c0107b5d <_fifo_init>:


static int
_fifo_init(void)
{
c0107b5d:	55                   	push   %ebp
c0107b5e:	89 e5                	mov    %esp,%ebp
    return 0;
c0107b60:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b65:	5d                   	pop    %ebp
c0107b66:	c3                   	ret    

c0107b67 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107b67:	55                   	push   %ebp
c0107b68:	89 e5                	mov    %esp,%ebp
    return 0;
c0107b6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107b6f:	5d                   	pop    %ebp
c0107b70:	c3                   	ret    

c0107b71 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107b71:	55                   	push   %ebp
c0107b72:	89 e5                	mov    %esp,%ebp
c0107b74:	b8 00 00 00 00       	mov    $0x0,%eax
c0107b79:	5d                   	pop    %ebp
c0107b7a:	c3                   	ret    

c0107b7b <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107b7b:	55                   	push   %ebp
c0107b7c:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107b87:	5d                   	pop    %ebp
c0107b88:	c3                   	ret    

c0107b89 <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107b89:	55                   	push   %ebp
c0107b8a:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107b8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b8f:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107b92:	5d                   	pop    %ebp
c0107b93:	c3                   	ret    

c0107b94 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107b94:	55                   	push   %ebp
c0107b95:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107b9d:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107ba0:	5d                   	pop    %ebp
c0107ba1:	c3                   	ret    

c0107ba2 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107ba2:	55                   	push   %ebp
c0107ba3:	89 e5                	mov    %esp,%ebp
c0107ba5:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bab:	c1 e8 0c             	shr    $0xc,%eax
c0107bae:	89 c2                	mov    %eax,%edx
c0107bb0:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0107bb5:	39 c2                	cmp    %eax,%edx
c0107bb7:	72 1c                	jb     c0107bd5 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107bb9:	c7 44 24 08 b4 d4 10 	movl   $0xc010d4b4,0x8(%esp)
c0107bc0:	c0 
c0107bc1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107bc8:	00 
c0107bc9:	c7 04 24 d3 d4 10 c0 	movl   $0xc010d4d3,(%esp)
c0107bd0:	e8 00 92 ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c0107bd5:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0107bda:	8b 55 08             	mov    0x8(%ebp),%edx
c0107bdd:	c1 ea 0c             	shr    $0xc,%edx
c0107be0:	c1 e2 05             	shl    $0x5,%edx
c0107be3:	01 d0                	add    %edx,%eax
}
c0107be5:	c9                   	leave  
c0107be6:	c3                   	ret    

c0107be7 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0107be7:	55                   	push   %ebp
c0107be8:	89 e5                	mov    %esp,%ebp
c0107bea:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107bf5:	89 04 24             	mov    %eax,(%esp)
c0107bf8:	e8 a5 ff ff ff       	call   c0107ba2 <pa2page>
}
c0107bfd:	c9                   	leave  
c0107bfe:	c3                   	ret    

c0107bff <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107bff:	55                   	push   %ebp
c0107c00:	89 e5                	mov    %esp,%ebp
c0107c02:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107c05:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107c0c:	e8 fa cd ff ff       	call   c0104a0b <kmalloc>
c0107c11:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107c14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107c18:	74 79                	je     c0107c93 <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107c26:	89 50 04             	mov    %edx,0x4(%eax)
c0107c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c2c:	8b 50 04             	mov    0x4(%eax),%edx
c0107c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c32:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c4b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107c52:	a1 6c bf 19 c0       	mov    0xc019bf6c,%eax
c0107c57:	85 c0                	test   %eax,%eax
c0107c59:	74 0d                	je     c0107c68 <mm_create+0x69>
c0107c5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c5e:	89 04 24             	mov    %eax,(%esp)
c0107c61:	e8 a8 ef ff ff       	call   c0106c0e <swap_init_mm>
c0107c66:	eb 0a                	jmp    c0107c72 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c6b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0107c72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0107c79:	00 
c0107c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c7d:	89 04 24             	mov    %eax,(%esp)
c0107c80:	e8 0f ff ff ff       	call   c0107b94 <set_mm_count>
        lock_init(&(mm->mm_lock));
c0107c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c88:	83 c0 1c             	add    $0x1c,%eax
c0107c8b:	89 04 24             	mov    %eax,(%esp)
c0107c8e:	e8 e8 fe ff ff       	call   c0107b7b <lock_init>
    }    
    return mm;
c0107c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107c96:	c9                   	leave  
c0107c97:	c3                   	ret    

c0107c98 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107c98:	55                   	push   %ebp
c0107c99:	89 e5                	mov    %esp,%ebp
c0107c9b:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107c9e:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107ca5:	e8 61 cd ff ff       	call   c0104a0b <kmalloc>
c0107caa:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107cb1:	74 1b                	je     c0107cce <vma_create+0x36>
        vma->vm_start = vm_start;
c0107cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cb6:	8b 55 08             	mov    0x8(%ebp),%edx
c0107cb9:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cbf:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107cc2:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cc8:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ccb:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107cd1:	c9                   	leave  
c0107cd2:	c3                   	ret    

c0107cd3 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107cd3:	55                   	push   %ebp
c0107cd4:	89 e5                	mov    %esp,%ebp
c0107cd6:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107ce0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107ce4:	0f 84 95 00 00 00    	je     c0107d7f <find_vma+0xac>
        vma = mm->mmap_cache;
c0107cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ced:	8b 40 08             	mov    0x8(%eax),%eax
c0107cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c0107cf3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107cf7:	74 16                	je     c0107d0f <find_vma+0x3c>
c0107cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107cfc:	8b 40 04             	mov    0x4(%eax),%eax
c0107cff:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d02:	77 0b                	ja     c0107d0f <find_vma+0x3c>
c0107d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d07:	8b 40 08             	mov    0x8(%eax),%eax
c0107d0a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d0d:	77 61                	ja     c0107d70 <find_vma+0x9d>
                bool found = 0;
c0107d0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107d22:	eb 28                	jmp    c0107d4c <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d27:	83 e8 10             	sub    $0x10,%eax
c0107d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107d2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d30:	8b 40 04             	mov    0x4(%eax),%eax
c0107d33:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d36:	77 14                	ja     c0107d4c <find_vma+0x79>
c0107d38:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107d3b:	8b 40 08             	mov    0x8(%eax),%eax
c0107d3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107d41:	76 09                	jbe    c0107d4c <find_vma+0x79>
                        found = 1;
c0107d43:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107d4a:	eb 17                	jmp    c0107d63 <find_vma+0x90>
c0107d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107d52:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107d55:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107d61:	75 c1                	jne    c0107d24 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107d63:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107d67:	75 07                	jne    c0107d70 <find_vma+0x9d>
                    vma = NULL;
c0107d69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107d70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107d74:	74 09                	je     c0107d7f <find_vma+0xac>
            mm->mmap_cache = vma;
c0107d76:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d79:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107d7c:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107d82:	c9                   	leave  
c0107d83:	c3                   	ret    

c0107d84 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107d84:	55                   	push   %ebp
c0107d85:	89 e5                	mov    %esp,%ebp
c0107d87:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d8d:	8b 50 04             	mov    0x4(%eax),%edx
c0107d90:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d93:	8b 40 08             	mov    0x8(%eax),%eax
c0107d96:	39 c2                	cmp    %eax,%edx
c0107d98:	72 24                	jb     c0107dbe <check_vma_overlap+0x3a>
c0107d9a:	c7 44 24 0c e1 d4 10 	movl   $0xc010d4e1,0xc(%esp)
c0107da1:	c0 
c0107da2:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0107da9:	c0 
c0107daa:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0107db1:	00 
c0107db2:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0107db9:	e8 17 90 ff ff       	call   c0100dd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107dbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0107dc1:	8b 50 08             	mov    0x8(%eax),%edx
c0107dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dc7:	8b 40 04             	mov    0x4(%eax),%eax
c0107dca:	39 c2                	cmp    %eax,%edx
c0107dcc:	76 24                	jbe    c0107df2 <check_vma_overlap+0x6e>
c0107dce:	c7 44 24 0c 24 d5 10 	movl   $0xc010d524,0xc(%esp)
c0107dd5:	c0 
c0107dd6:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0107ddd:	c0 
c0107dde:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107de5:	00 
c0107de6:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0107ded:	e8 e3 8f ff ff       	call   c0100dd5 <__panic>
    assert(next->vm_start < next->vm_end);
c0107df2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107df5:	8b 50 04             	mov    0x4(%eax),%edx
c0107df8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dfb:	8b 40 08             	mov    0x8(%eax),%eax
c0107dfe:	39 c2                	cmp    %eax,%edx
c0107e00:	72 24                	jb     c0107e26 <check_vma_overlap+0xa2>
c0107e02:	c7 44 24 0c 43 d5 10 	movl   $0xc010d543,0xc(%esp)
c0107e09:	c0 
c0107e0a:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0107e11:	c0 
c0107e12:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0107e19:	00 
c0107e1a:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0107e21:	e8 af 8f ff ff       	call   c0100dd5 <__panic>
}
c0107e26:	c9                   	leave  
c0107e27:	c3                   	ret    

c0107e28 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107e28:	55                   	push   %ebp
c0107e29:	89 e5                	mov    %esp,%ebp
c0107e2b:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e31:	8b 50 04             	mov    0x4(%eax),%edx
c0107e34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e37:	8b 40 08             	mov    0x8(%eax),%eax
c0107e3a:	39 c2                	cmp    %eax,%edx
c0107e3c:	72 24                	jb     c0107e62 <insert_vma_struct+0x3a>
c0107e3e:	c7 44 24 0c 61 d5 10 	movl   $0xc010d561,0xc(%esp)
c0107e45:	c0 
c0107e46:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0107e4d:	c0 
c0107e4e:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107e55:	00 
c0107e56:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0107e5d:	e8 73 8f ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107e62:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107e68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e6b:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107e74:	eb 21                	jmp    c0107e97 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107e76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e79:	83 e8 10             	sub    $0x10,%eax
c0107e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e82:	8b 50 04             	mov    0x4(%eax),%edx
c0107e85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e88:	8b 40 04             	mov    0x4(%eax),%eax
c0107e8b:	39 c2                	cmp    %eax,%edx
c0107e8d:	76 02                	jbe    c0107e91 <insert_vma_struct+0x69>
                break;
c0107e8f:	eb 1d                	jmp    c0107eae <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ea0:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ea9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107eac:	75 c8                	jne    c0107e76 <insert_vma_struct+0x4e>
c0107eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eb1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107eb7:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107eba:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ec0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107ec3:	74 15                	je     c0107eda <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ec8:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ece:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ed2:	89 14 24             	mov    %edx,(%esp)
c0107ed5:	e8 aa fe ff ff       	call   c0107d84 <check_vma_overlap>
    }
    if (le_next != list) {
c0107eda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107edd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107ee0:	74 15                	je     c0107ef7 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107ee2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ee5:	83 e8 10             	sub    $0x10,%eax
c0107ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107eec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107eef:	89 04 24             	mov    %eax,(%esp)
c0107ef2:	e8 8d fe ff ff       	call   c0107d84 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107efa:	8b 55 08             	mov    0x8(%ebp),%edx
c0107efd:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107eff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f02:	8d 50 10             	lea    0x10(%eax),%edx
c0107f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f08:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107f0b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107f0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107f11:	8b 40 04             	mov    0x4(%eax),%eax
c0107f14:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107f17:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107f1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107f1d:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107f20:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107f23:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107f26:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107f29:	89 10                	mov    %edx,(%eax)
c0107f2b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107f2e:	8b 10                	mov    (%eax),%edx
c0107f30:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107f33:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107f36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107f39:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107f3c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107f3f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107f42:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107f45:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107f47:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f4a:	8b 40 10             	mov    0x10(%eax),%eax
c0107f4d:	8d 50 01             	lea    0x1(%eax),%edx
c0107f50:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f53:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107f56:	c9                   	leave  
c0107f57:	c3                   	ret    

c0107f58 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107f58:	55                   	push   %ebp
c0107f59:	89 e5                	mov    %esp,%ebp
c0107f5b:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c0107f5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f61:	89 04 24             	mov    %eax,(%esp)
c0107f64:	e8 20 fc ff ff       	call   c0107b89 <mm_count>
c0107f69:	85 c0                	test   %eax,%eax
c0107f6b:	74 24                	je     c0107f91 <mm_destroy+0x39>
c0107f6d:	c7 44 24 0c 7d d5 10 	movl   $0xc010d57d,0xc(%esp)
c0107f74:	c0 
c0107f75:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0107f7c:	c0 
c0107f7d:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0107f84:	00 
c0107f85:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0107f8c:	e8 44 8e ff ff       	call   c0100dd5 <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c0107f91:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107f97:	eb 36                	jmp    c0107fcf <mm_destroy+0x77>
c0107f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107f9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107fa2:	8b 40 04             	mov    0x4(%eax),%eax
c0107fa5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107fa8:	8b 12                	mov    (%edx),%edx
c0107faa:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107fad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107fb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107fb6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107fbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107fbf:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107fc4:	83 e8 10             	sub    $0x10,%eax
c0107fc7:	89 04 24             	mov    %eax,(%esp)
c0107fca:	e8 57 ca ff ff       	call   c0104a26 <kfree>
c0107fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107fd8:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107fdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107fe1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107fe4:	75 b3                	jne    c0107f99 <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe9:	89 04 24             	mov    %eax,(%esp)
c0107fec:	e8 35 ca ff ff       	call   c0104a26 <kfree>
    mm=NULL;
c0107ff1:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107ff8:	c9                   	leave  
c0107ff9:	c3                   	ret    

c0107ffa <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c0107ffa:	55                   	push   %ebp
c0107ffb:	89 e5                	mov    %esp,%ebp
c0107ffd:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c0108000:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108003:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108006:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108009:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010800e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108011:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c0108018:	8b 45 10             	mov    0x10(%ebp),%eax
c010801b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010801e:	01 c2                	add    %eax,%edx
c0108020:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108023:	01 d0                	add    %edx,%eax
c0108025:	83 e8 01             	sub    $0x1,%eax
c0108028:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010802b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010802e:	ba 00 00 00 00       	mov    $0x0,%edx
c0108033:	f7 75 e8             	divl   -0x18(%ebp)
c0108036:	89 d0                	mov    %edx,%eax
c0108038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010803b:	29 c2                	sub    %eax,%edx
c010803d:	89 d0                	mov    %edx,%eax
c010803f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c0108042:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c0108049:	76 11                	jbe    c010805c <mm_map+0x62>
c010804b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010804e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108051:	73 09                	jae    c010805c <mm_map+0x62>
c0108053:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c010805a:	76 0a                	jbe    c0108066 <mm_map+0x6c>
        return -E_INVAL;
c010805c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108061:	e9 ae 00 00 00       	jmp    c0108114 <mm_map+0x11a>
    }

    assert(mm != NULL);
c0108066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010806a:	75 24                	jne    c0108090 <mm_map+0x96>
c010806c:	c7 44 24 0c 8f d5 10 	movl   $0xc010d58f,0xc(%esp)
c0108073:	c0 
c0108074:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c010807b:	c0 
c010807c:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0108083:	00 
c0108084:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c010808b:	e8 45 8d ff ff       	call   c0100dd5 <__panic>

    int ret = -E_INVAL;
c0108090:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c0108097:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010809a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010809e:	8b 45 08             	mov    0x8(%ebp),%eax
c01080a1:	89 04 24             	mov    %eax,(%esp)
c01080a4:	e8 2a fc ff ff       	call   c0107cd3 <find_vma>
c01080a9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01080ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01080b0:	74 0d                	je     c01080bf <mm_map+0xc5>
c01080b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080b5:	8b 40 04             	mov    0x4(%eax),%eax
c01080b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01080bb:	73 02                	jae    c01080bf <mm_map+0xc5>
        goto out;
c01080bd:	eb 52                	jmp    c0108111 <mm_map+0x117>
    }
    ret = -E_NO_MEM;
c01080bf:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c01080c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01080c9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01080d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01080d7:	89 04 24             	mov    %eax,(%esp)
c01080da:	e8 b9 fb ff ff       	call   c0107c98 <vma_create>
c01080df:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01080e2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01080e6:	75 02                	jne    c01080ea <mm_map+0xf0>
        goto out;
c01080e8:	eb 27                	jmp    c0108111 <mm_map+0x117>
    }
    insert_vma_struct(mm, vma);
c01080ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f4:	89 04 24             	mov    %eax,(%esp)
c01080f7:	e8 2c fd ff ff       	call   c0107e28 <insert_vma_struct>
    if (vma_store != NULL) {
c01080fc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0108100:	74 08                	je     c010810a <mm_map+0x110>
        *vma_store = vma;
c0108102:	8b 45 18             	mov    0x18(%ebp),%eax
c0108105:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108108:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c010810a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

out:
    return ret;
c0108111:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108114:	c9                   	leave  
c0108115:	c3                   	ret    

c0108116 <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c0108116:	55                   	push   %ebp
c0108117:	89 e5                	mov    %esp,%ebp
c0108119:	56                   	push   %esi
c010811a:	53                   	push   %ebx
c010811b:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c010811e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108122:	74 06                	je     c010812a <dup_mmap+0x14>
c0108124:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108128:	75 24                	jne    c010814e <dup_mmap+0x38>
c010812a:	c7 44 24 0c 9a d5 10 	movl   $0xc010d59a,0xc(%esp)
c0108131:	c0 
c0108132:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108139:	c0 
c010813a:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0108141:	00 
c0108142:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108149:	e8 87 8c ff ff       	call   c0100dd5 <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c010814e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108151:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108154:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108157:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c010815a:	e9 92 00 00 00       	jmp    c01081f1 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c010815f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108162:	83 e8 10             	sub    $0x10,%eax
c0108165:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c0108168:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010816b:	8b 48 0c             	mov    0xc(%eax),%ecx
c010816e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108171:	8b 50 08             	mov    0x8(%eax),%edx
c0108174:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108177:	8b 40 04             	mov    0x4(%eax),%eax
c010817a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010817e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108182:	89 04 24             	mov    %eax,(%esp)
c0108185:	e8 0e fb ff ff       	call   c0107c98 <vma_create>
c010818a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c010818d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108191:	75 07                	jne    c010819a <dup_mmap+0x84>
            return -E_NO_MEM;
c0108193:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0108198:	eb 76                	jmp    c0108210 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c010819a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010819d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01081a4:	89 04 24             	mov    %eax,(%esp)
c01081a7:	e8 7c fc ff ff       	call   c0107e28 <insert_vma_struct>

        bool share = 0;
c01081ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c01081b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081b6:	8b 58 08             	mov    0x8(%eax),%ebx
c01081b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01081bc:	8b 48 04             	mov    0x4(%eax),%ecx
c01081bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081c2:	8b 50 0c             	mov    0xc(%eax),%edx
c01081c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01081c8:	8b 40 0c             	mov    0xc(%eax),%eax
c01081cb:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01081ce:	89 74 24 10          	mov    %esi,0x10(%esp)
c01081d2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01081d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01081da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081de:	89 04 24             	mov    %eax,(%esp)
c01081e1:	e8 f8 d7 ff ff       	call   c01059de <copy_range>
c01081e6:	85 c0                	test   %eax,%eax
c01081e8:	74 07                	je     c01081f1 <dup_mmap+0xdb>
            return -E_NO_MEM;
c01081ea:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01081ef:	eb 1f                	jmp    c0108210 <dup_mmap+0xfa>
c01081f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01081f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01081f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01081fa:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c01081fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01081ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108202:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108205:	0f 85 54 ff ff ff    	jne    c010815f <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c010820b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108210:	83 c4 40             	add    $0x40,%esp
c0108213:	5b                   	pop    %ebx
c0108214:	5e                   	pop    %esi
c0108215:	5d                   	pop    %ebp
c0108216:	c3                   	ret    

c0108217 <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c0108217:	55                   	push   %ebp
c0108218:	89 e5                	mov    %esp,%ebp
c010821a:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c010821d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108221:	74 0f                	je     c0108232 <exit_mmap+0x1b>
c0108223:	8b 45 08             	mov    0x8(%ebp),%eax
c0108226:	89 04 24             	mov    %eax,(%esp)
c0108229:	e8 5b f9 ff ff       	call   c0107b89 <mm_count>
c010822e:	85 c0                	test   %eax,%eax
c0108230:	74 24                	je     c0108256 <exit_mmap+0x3f>
c0108232:	c7 44 24 0c b8 d5 10 	movl   $0xc010d5b8,0xc(%esp)
c0108239:	c0 
c010823a:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108241:	c0 
c0108242:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0108249:	00 
c010824a:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108251:	e8 7f 8b ff ff       	call   c0100dd5 <__panic>
    pde_t *pgdir = mm->pgdir;
c0108256:	8b 45 08             	mov    0x8(%ebp),%eax
c0108259:	8b 40 0c             	mov    0xc(%eax),%eax
c010825c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c010825f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108262:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108265:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108268:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c010826b:	eb 28                	jmp    c0108295 <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108270:	83 e8 10             	sub    $0x10,%eax
c0108273:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c0108276:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108279:	8b 50 08             	mov    0x8(%eax),%edx
c010827c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010827f:	8b 40 04             	mov    0x4(%eax),%eax
c0108282:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108286:	89 44 24 04          	mov    %eax,0x4(%esp)
c010828a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010828d:	89 04 24             	mov    %eax,(%esp)
c0108290:	e8 4e d5 ff ff       	call   c01057e3 <unmap_range>
c0108295:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108298:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010829b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010829e:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c01082a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082aa:	75 c1                	jne    c010826d <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01082ac:	eb 28                	jmp    c01082d6 <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c01082ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082b1:	83 e8 10             	sub    $0x10,%eax
c01082b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c01082b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082ba:	8b 50 08             	mov    0x8(%eax),%edx
c01082bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082c0:	8b 40 04             	mov    0x4(%eax),%eax
c01082c3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01082c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082ce:	89 04 24             	mov    %eax,(%esp)
c01082d1:	e8 01 d6 ff ff       	call   c01058d7 <exit_range>
c01082d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01082dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082df:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01082e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082eb:	75 c1                	jne    c01082ae <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c01082ed:	c9                   	leave  
c01082ee:	c3                   	ret    

c01082ef <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c01082ef:	55                   	push   %ebp
c01082f0:	89 e5                	mov    %esp,%ebp
c01082f2:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c01082f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01082f8:	8b 55 18             	mov    0x18(%ebp),%edx
c01082fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01082ff:	8b 55 14             	mov    0x14(%ebp),%edx
c0108302:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108306:	89 44 24 04          	mov    %eax,0x4(%esp)
c010830a:	8b 45 08             	mov    0x8(%ebp),%eax
c010830d:	89 04 24             	mov    %eax,(%esp)
c0108310:	e8 79 09 00 00       	call   c0108c8e <user_mem_check>
c0108315:	85 c0                	test   %eax,%eax
c0108317:	75 07                	jne    c0108320 <copy_from_user+0x31>
        return 0;
c0108319:	b8 00 00 00 00       	mov    $0x0,%eax
c010831e:	eb 1e                	jmp    c010833e <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c0108320:	8b 45 14             	mov    0x14(%ebp),%eax
c0108323:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108327:	8b 45 10             	mov    0x10(%ebp),%eax
c010832a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010832e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108331:	89 04 24             	mov    %eax,(%esp)
c0108334:	e8 b5 36 00 00       	call   c010b9ee <memcpy>
    return 1;
c0108339:	b8 01 00 00 00       	mov    $0x1,%eax
}
c010833e:	c9                   	leave  
c010833f:	c3                   	ret    

c0108340 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c0108340:	55                   	push   %ebp
c0108341:	89 e5                	mov    %esp,%ebp
c0108343:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c0108346:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108349:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108350:	00 
c0108351:	8b 55 14             	mov    0x14(%ebp),%edx
c0108354:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108358:	89 44 24 04          	mov    %eax,0x4(%esp)
c010835c:	8b 45 08             	mov    0x8(%ebp),%eax
c010835f:	89 04 24             	mov    %eax,(%esp)
c0108362:	e8 27 09 00 00       	call   c0108c8e <user_mem_check>
c0108367:	85 c0                	test   %eax,%eax
c0108369:	75 07                	jne    c0108372 <copy_to_user+0x32>
        return 0;
c010836b:	b8 00 00 00 00       	mov    $0x0,%eax
c0108370:	eb 1e                	jmp    c0108390 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c0108372:	8b 45 14             	mov    0x14(%ebp),%eax
c0108375:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108379:	8b 45 10             	mov    0x10(%ebp),%eax
c010837c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108380:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108383:	89 04 24             	mov    %eax,(%esp)
c0108386:	e8 63 36 00 00       	call   c010b9ee <memcpy>
    return 1;
c010838b:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108390:	c9                   	leave  
c0108391:	c3                   	ret    

c0108392 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0108392:	55                   	push   %ebp
c0108393:	89 e5                	mov    %esp,%ebp
c0108395:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0108398:	e8 02 00 00 00       	call   c010839f <check_vmm>
}
c010839d:	c9                   	leave  
c010839e:	c3                   	ret    

c010839f <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010839f:	55                   	push   %ebp
c01083a0:	89 e5                	mov    %esp,%ebp
c01083a2:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01083a5:	e8 73 cb ff ff       	call   c0104f1d <nr_free_pages>
c01083aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01083ad:	e8 13 00 00 00       	call   c01083c5 <check_vma_struct>
    check_pgfault();
c01083b2:	e8 a7 04 00 00       	call   c010885e <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c01083b7:	c7 04 24 d8 d5 10 c0 	movl   $0xc010d5d8,(%esp)
c01083be:	e8 90 7f ff ff       	call   c0100353 <cprintf>
}
c01083c3:	c9                   	leave  
c01083c4:	c3                   	ret    

c01083c5 <check_vma_struct>:

static void
check_vma_struct(void) {
c01083c5:	55                   	push   %ebp
c01083c6:	89 e5                	mov    %esp,%ebp
c01083c8:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01083cb:	e8 4d cb ff ff       	call   c0104f1d <nr_free_pages>
c01083d0:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01083d3:	e8 27 f8 ff ff       	call   c0107bff <mm_create>
c01083d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01083db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01083df:	75 24                	jne    c0108405 <check_vma_struct+0x40>
c01083e1:	c7 44 24 0c 8f d5 10 	movl   $0xc010d58f,0xc(%esp)
c01083e8:	c0 
c01083e9:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01083f0:	c0 
c01083f1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01083f8:	00 
c01083f9:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108400:	e8 d0 89 ff ff       	call   c0100dd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0108405:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010840c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010840f:	89 d0                	mov    %edx,%eax
c0108411:	c1 e0 02             	shl    $0x2,%eax
c0108414:	01 d0                	add    %edx,%eax
c0108416:	01 c0                	add    %eax,%eax
c0108418:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010841b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010841e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108421:	eb 70                	jmp    c0108493 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0108423:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108426:	89 d0                	mov    %edx,%eax
c0108428:	c1 e0 02             	shl    $0x2,%eax
c010842b:	01 d0                	add    %edx,%eax
c010842d:	83 c0 02             	add    $0x2,%eax
c0108430:	89 c1                	mov    %eax,%ecx
c0108432:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108435:	89 d0                	mov    %edx,%eax
c0108437:	c1 e0 02             	shl    $0x2,%eax
c010843a:	01 d0                	add    %edx,%eax
c010843c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108443:	00 
c0108444:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0108448:	89 04 24             	mov    %eax,(%esp)
c010844b:	e8 48 f8 ff ff       	call   c0107c98 <vma_create>
c0108450:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0108453:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108457:	75 24                	jne    c010847d <check_vma_struct+0xb8>
c0108459:	c7 44 24 0c f0 d5 10 	movl   $0xc010d5f0,0xc(%esp)
c0108460:	c0 
c0108461:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108468:	c0 
c0108469:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108470:	00 
c0108471:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108478:	e8 58 89 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c010847d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108480:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108484:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108487:	89 04 24             	mov    %eax,(%esp)
c010848a:	e8 99 f9 ff ff       	call   c0107e28 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c010848f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108493:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108497:	7f 8a                	jg     c0108423 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010849c:	83 c0 01             	add    $0x1,%eax
c010849f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01084a2:	eb 70                	jmp    c0108514 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01084a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084a7:	89 d0                	mov    %edx,%eax
c01084a9:	c1 e0 02             	shl    $0x2,%eax
c01084ac:	01 d0                	add    %edx,%eax
c01084ae:	83 c0 02             	add    $0x2,%eax
c01084b1:	89 c1                	mov    %eax,%ecx
c01084b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01084b6:	89 d0                	mov    %edx,%eax
c01084b8:	c1 e0 02             	shl    $0x2,%eax
c01084bb:	01 d0                	add    %edx,%eax
c01084bd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01084c4:	00 
c01084c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01084c9:	89 04 24             	mov    %eax,(%esp)
c01084cc:	e8 c7 f7 ff ff       	call   c0107c98 <vma_create>
c01084d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01084d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01084d8:	75 24                	jne    c01084fe <check_vma_struct+0x139>
c01084da:	c7 44 24 0c f0 d5 10 	movl   $0xc010d5f0,0xc(%esp)
c01084e1:	c0 
c01084e2:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01084e9:	c0 
c01084ea:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01084f1:	00 
c01084f2:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01084f9:	e8 d7 88 ff ff       	call   c0100dd5 <__panic>
        insert_vma_struct(mm, vma);
c01084fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108501:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108505:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108508:	89 04 24             	mov    %eax,(%esp)
c010850b:	e8 18 f9 ff ff       	call   c0107e28 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0108510:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108514:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108517:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010851a:	7e 88                	jle    c01084a4 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010851c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010851f:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0108522:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0108525:	8b 40 04             	mov    0x4(%eax),%eax
c0108528:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010852b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0108532:	e9 97 00 00 00       	jmp    c01085ce <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0108537:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010853a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010853d:	75 24                	jne    c0108563 <check_vma_struct+0x19e>
c010853f:	c7 44 24 0c fc d5 10 	movl   $0xc010d5fc,0xc(%esp)
c0108546:	c0 
c0108547:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c010854e:	c0 
c010854f:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0108556:	00 
c0108557:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c010855e:	e8 72 88 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0108563:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108566:	83 e8 10             	sub    $0x10,%eax
c0108569:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c010856c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010856f:	8b 48 04             	mov    0x4(%eax),%ecx
c0108572:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108575:	89 d0                	mov    %edx,%eax
c0108577:	c1 e0 02             	shl    $0x2,%eax
c010857a:	01 d0                	add    %edx,%eax
c010857c:	39 c1                	cmp    %eax,%ecx
c010857e:	75 17                	jne    c0108597 <check_vma_struct+0x1d2>
c0108580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108583:	8b 48 08             	mov    0x8(%eax),%ecx
c0108586:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108589:	89 d0                	mov    %edx,%eax
c010858b:	c1 e0 02             	shl    $0x2,%eax
c010858e:	01 d0                	add    %edx,%eax
c0108590:	83 c0 02             	add    $0x2,%eax
c0108593:	39 c1                	cmp    %eax,%ecx
c0108595:	74 24                	je     c01085bb <check_vma_struct+0x1f6>
c0108597:	c7 44 24 0c 14 d6 10 	movl   $0xc010d614,0xc(%esp)
c010859e:	c0 
c010859f:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01085a6:	c0 
c01085a7:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c01085ae:	00 
c01085af:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01085b6:	e8 1a 88 ff ff       	call   c0100dd5 <__panic>
c01085bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01085be:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01085c1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01085c4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01085c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01085ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01085ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01085d4:	0f 8e 5d ff ff ff    	jle    c0108537 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01085da:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01085e1:	e9 cd 01 00 00       	jmp    c01087b3 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01085e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085f0:	89 04 24             	mov    %eax,(%esp)
c01085f3:	e8 db f6 ff ff       	call   c0107cd3 <find_vma>
c01085f8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c01085fb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01085ff:	75 24                	jne    c0108625 <check_vma_struct+0x260>
c0108601:	c7 44 24 0c 49 d6 10 	movl   $0xc010d649,0xc(%esp)
c0108608:	c0 
c0108609:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108610:	c0 
c0108611:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0108618:	00 
c0108619:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108620:	e8 b0 87 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0108625:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108628:	83 c0 01             	add    $0x1,%eax
c010862b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010862f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108632:	89 04 24             	mov    %eax,(%esp)
c0108635:	e8 99 f6 ff ff       	call   c0107cd3 <find_vma>
c010863a:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010863d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0108641:	75 24                	jne    c0108667 <check_vma_struct+0x2a2>
c0108643:	c7 44 24 0c 56 d6 10 	movl   $0xc010d656,0xc(%esp)
c010864a:	c0 
c010864b:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108652:	c0 
c0108653:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c010865a:	00 
c010865b:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108662:	e8 6e 87 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0108667:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010866a:	83 c0 02             	add    $0x2,%eax
c010866d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108671:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108674:	89 04 24             	mov    %eax,(%esp)
c0108677:	e8 57 f6 ff ff       	call   c0107cd3 <find_vma>
c010867c:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c010867f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0108683:	74 24                	je     c01086a9 <check_vma_struct+0x2e4>
c0108685:	c7 44 24 0c 63 d6 10 	movl   $0xc010d663,0xc(%esp)
c010868c:	c0 
c010868d:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108694:	c0 
c0108695:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010869c:	00 
c010869d:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01086a4:	e8 2c 87 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01086a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ac:	83 c0 03             	add    $0x3,%eax
c01086af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086b6:	89 04 24             	mov    %eax,(%esp)
c01086b9:	e8 15 f6 ff ff       	call   c0107cd3 <find_vma>
c01086be:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01086c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01086c5:	74 24                	je     c01086eb <check_vma_struct+0x326>
c01086c7:	c7 44 24 0c 70 d6 10 	movl   $0xc010d670,0xc(%esp)
c01086ce:	c0 
c01086cf:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01086d6:	c0 
c01086d7:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c01086de:	00 
c01086df:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01086e6:	e8 ea 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c01086eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ee:	83 c0 04             	add    $0x4,%eax
c01086f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01086f8:	89 04 24             	mov    %eax,(%esp)
c01086fb:	e8 d3 f5 ff ff       	call   c0107cd3 <find_vma>
c0108700:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0108703:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0108707:	74 24                	je     c010872d <check_vma_struct+0x368>
c0108709:	c7 44 24 0c 7d d6 10 	movl   $0xc010d67d,0xc(%esp)
c0108710:	c0 
c0108711:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108718:	c0 
c0108719:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0108720:	00 
c0108721:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108728:	e8 a8 86 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c010872d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108730:	8b 50 04             	mov    0x4(%eax),%edx
c0108733:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108736:	39 c2                	cmp    %eax,%edx
c0108738:	75 10                	jne    c010874a <check_vma_struct+0x385>
c010873a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010873d:	8b 50 08             	mov    0x8(%eax),%edx
c0108740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108743:	83 c0 02             	add    $0x2,%eax
c0108746:	39 c2                	cmp    %eax,%edx
c0108748:	74 24                	je     c010876e <check_vma_struct+0x3a9>
c010874a:	c7 44 24 0c 8c d6 10 	movl   $0xc010d68c,0xc(%esp)
c0108751:	c0 
c0108752:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108759:	c0 
c010875a:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0108761:	00 
c0108762:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108769:	e8 67 86 ff ff       	call   c0100dd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c010876e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108771:	8b 50 04             	mov    0x4(%eax),%edx
c0108774:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108777:	39 c2                	cmp    %eax,%edx
c0108779:	75 10                	jne    c010878b <check_vma_struct+0x3c6>
c010877b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010877e:	8b 50 08             	mov    0x8(%eax),%edx
c0108781:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108784:	83 c0 02             	add    $0x2,%eax
c0108787:	39 c2                	cmp    %eax,%edx
c0108789:	74 24                	je     c01087af <check_vma_struct+0x3ea>
c010878b:	c7 44 24 0c bc d6 10 	movl   $0xc010d6bc,0xc(%esp)
c0108792:	c0 
c0108793:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c010879a:	c0 
c010879b:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01087a2:	00 
c01087a3:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01087aa:	e8 26 86 ff ff       	call   c0100dd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01087af:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c01087b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01087b6:	89 d0                	mov    %edx,%eax
c01087b8:	c1 e0 02             	shl    $0x2,%eax
c01087bb:	01 d0                	add    %edx,%eax
c01087bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01087c0:	0f 8d 20 fe ff ff    	jge    c01085e6 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01087c6:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01087cd:	eb 70                	jmp    c010883f <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01087cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01087d9:	89 04 24             	mov    %eax,(%esp)
c01087dc:	e8 f2 f4 ff ff       	call   c0107cd3 <find_vma>
c01087e1:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01087e4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01087e8:	74 27                	je     c0108811 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01087ea:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01087ed:	8b 50 08             	mov    0x8(%eax),%edx
c01087f0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01087f3:	8b 40 04             	mov    0x4(%eax),%eax
c01087f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01087fa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01087fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108801:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108805:	c7 04 24 ec d6 10 c0 	movl   $0xc010d6ec,(%esp)
c010880c:	e8 42 7b ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0108811:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108815:	74 24                	je     c010883b <check_vma_struct+0x476>
c0108817:	c7 44 24 0c 11 d7 10 	movl   $0xc010d711,0xc(%esp)
c010881e:	c0 
c010881f:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108826:	c0 
c0108827:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c010882e:	00 
c010882f:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108836:	e8 9a 85 ff ff       	call   c0100dd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010883b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010883f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108843:	79 8a                	jns    c01087cf <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108845:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108848:	89 04 24             	mov    %eax,(%esp)
c010884b:	e8 08 f7 ff ff       	call   c0107f58 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108850:	c7 04 24 28 d7 10 c0 	movl   $0xc010d728,(%esp)
c0108857:	e8 f7 7a ff ff       	call   c0100353 <cprintf>
}
c010885c:	c9                   	leave  
c010885d:	c3                   	ret    

c010885e <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c010885e:	55                   	push   %ebp
c010885f:	89 e5                	mov    %esp,%ebp
c0108861:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108864:	e8 b4 c6 ff ff       	call   c0104f1d <nr_free_pages>
c0108869:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010886c:	e8 8e f3 ff ff       	call   c0107bff <mm_create>
c0108871:	a3 ac e0 19 c0       	mov    %eax,0xc019e0ac
    assert(check_mm_struct != NULL);
c0108876:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c010887b:	85 c0                	test   %eax,%eax
c010887d:	75 24                	jne    c01088a3 <check_pgfault+0x45>
c010887f:	c7 44 24 0c 47 d7 10 	movl   $0xc010d747,0xc(%esp)
c0108886:	c0 
c0108887:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c010888e:	c0 
c010888f:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108896:	00 
c0108897:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c010889e:	e8 32 85 ff ff       	call   c0100dd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c01088a3:	a1 ac e0 19 c0       	mov    0xc019e0ac,%eax
c01088a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c01088ab:	8b 15 e4 be 19 c0    	mov    0xc019bee4,%edx
c01088b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088b4:	89 50 0c             	mov    %edx,0xc(%eax)
c01088b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088ba:	8b 40 0c             	mov    0xc(%eax),%eax
c01088bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01088c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088c3:	8b 00                	mov    (%eax),%eax
c01088c5:	85 c0                	test   %eax,%eax
c01088c7:	74 24                	je     c01088ed <check_pgfault+0x8f>
c01088c9:	c7 44 24 0c 5f d7 10 	movl   $0xc010d75f,0xc(%esp)
c01088d0:	c0 
c01088d1:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01088d8:	c0 
c01088d9:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c01088e0:	00 
c01088e1:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c01088e8:	e8 e8 84 ff ff       	call   c0100dd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01088ed:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01088f4:	00 
c01088f5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01088fc:	00 
c01088fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108904:	e8 8f f3 ff ff       	call   c0107c98 <vma_create>
c0108909:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c010890c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108910:	75 24                	jne    c0108936 <check_pgfault+0xd8>
c0108912:	c7 44 24 0c f0 d5 10 	movl   $0xc010d5f0,0xc(%esp)
c0108919:	c0 
c010891a:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108921:	c0 
c0108922:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108929:	00 
c010892a:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108931:	e8 9f 84 ff ff       	call   c0100dd5 <__panic>

    insert_vma_struct(mm, vma);
c0108936:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108939:	89 44 24 04          	mov    %eax,0x4(%esp)
c010893d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108940:	89 04 24             	mov    %eax,(%esp)
c0108943:	e8 e0 f4 ff ff       	call   c0107e28 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108948:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c010894f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108952:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108956:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108959:	89 04 24             	mov    %eax,(%esp)
c010895c:	e8 72 f3 ff ff       	call   c0107cd3 <find_vma>
c0108961:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108964:	74 24                	je     c010898a <check_pgfault+0x12c>
c0108966:	c7 44 24 0c 6d d7 10 	movl   $0xc010d76d,0xc(%esp)
c010896d:	c0 
c010896e:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108975:	c0 
c0108976:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c010897d:	00 
c010897e:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108985:	e8 4b 84 ff ff       	call   c0100dd5 <__panic>

    int i, sum = 0;
c010898a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108991:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108998:	eb 17                	jmp    c01089b1 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c010899a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010899d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089a0:	01 d0                	add    %edx,%eax
c01089a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01089a5:	88 10                	mov    %dl,(%eax)
        sum += i;
c01089a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089aa:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c01089ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01089b1:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01089b5:	7e e3                	jle    c010899a <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01089b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01089be:	eb 15                	jmp    c01089d5 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c01089c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01089c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089c6:	01 d0                	add    %edx,%eax
c01089c8:	0f b6 00             	movzbl (%eax),%eax
c01089cb:	0f be c0             	movsbl %al,%eax
c01089ce:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01089d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01089d5:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01089d9:	7e e5                	jle    c01089c0 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01089db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01089df:	74 24                	je     c0108a05 <check_pgfault+0x1a7>
c01089e1:	c7 44 24 0c 87 d7 10 	movl   $0xc010d787,0xc(%esp)
c01089e8:	c0 
c01089e9:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c01089f0:	c0 
c01089f1:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c01089f8:	00 
c01089f9:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108a00:	e8 d0 83 ff ff       	call   c0100dd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108a05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108a08:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108a0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108a0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108a13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a1a:	89 04 24             	mov    %eax,(%esp)
c0108a1d:	e8 df d1 ff ff       	call   c0105c01 <page_remove>
    free_page(pde2page(pgdir[0]));
c0108a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a25:	8b 00                	mov    (%eax),%eax
c0108a27:	89 04 24             	mov    %eax,(%esp)
c0108a2a:	e8 b8 f1 ff ff       	call   c0107be7 <pde2page>
c0108a2f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108a36:	00 
c0108a37:	89 04 24             	mov    %eax,(%esp)
c0108a3a:	e8 ac c4 ff ff       	call   c0104eeb <free_pages>
    pgdir[0] = 0;
c0108a3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108a42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108a48:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a4b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108a52:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a55:	89 04 24             	mov    %eax,(%esp)
c0108a58:	e8 fb f4 ff ff       	call   c0107f58 <mm_destroy>
    check_mm_struct = NULL;
c0108a5d:	c7 05 ac e0 19 c0 00 	movl   $0x0,0xc019e0ac
c0108a64:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108a67:	e8 b1 c4 ff ff       	call   c0104f1d <nr_free_pages>
c0108a6c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108a6f:	74 24                	je     c0108a95 <check_pgfault+0x237>
c0108a71:	c7 44 24 0c 90 d7 10 	movl   $0xc010d790,0xc(%esp)
c0108a78:	c0 
c0108a79:	c7 44 24 08 ff d4 10 	movl   $0xc010d4ff,0x8(%esp)
c0108a80:	c0 
c0108a81:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108a88:	00 
c0108a89:	c7 04 24 14 d5 10 c0 	movl   $0xc010d514,(%esp)
c0108a90:	e8 40 83 ff ff       	call   c0100dd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108a95:	c7 04 24 b7 d7 10 c0 	movl   $0xc010d7b7,(%esp)
c0108a9c:	e8 b2 78 ff ff       	call   c0100353 <cprintf>
}
c0108aa1:	c9                   	leave  
c0108aa2:	c3                   	ret    

c0108aa3 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108aa3:	55                   	push   %ebp
c0108aa4:	89 e5                	mov    %esp,%ebp
c0108aa6:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108aa9:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108ab0:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aba:	89 04 24             	mov    %eax,(%esp)
c0108abd:	e8 11 f2 ff ff       	call   c0107cd3 <find_vma>
c0108ac2:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108ac5:	a1 78 bf 19 c0       	mov    0xc019bf78,%eax
c0108aca:	83 c0 01             	add    $0x1,%eax
c0108acd:	a3 78 bf 19 c0       	mov    %eax,0xc019bf78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108ad2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108ad6:	74 0b                	je     c0108ae3 <do_pgfault+0x40>
c0108ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108adb:	8b 40 04             	mov    0x4(%eax),%eax
c0108ade:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108ae1:	76 18                	jbe    c0108afb <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108ae3:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108aea:	c7 04 24 d4 d7 10 c0 	movl   $0xc010d7d4,(%esp)
c0108af1:	e8 5d 78 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108af6:	e9 8e 01 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
    }
    //check the error_code
    switch (error_code & 3) {
c0108afb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108afe:	83 e0 03             	and    $0x3,%eax
c0108b01:	85 c0                	test   %eax,%eax
c0108b03:	74 36                	je     c0108b3b <do_pgfault+0x98>
c0108b05:	83 f8 01             	cmp    $0x1,%eax
c0108b08:	74 20                	je     c0108b2a <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b0d:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b10:	83 e0 02             	and    $0x2,%eax
c0108b13:	85 c0                	test   %eax,%eax
c0108b15:	75 11                	jne    c0108b28 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108b17:	c7 04 24 04 d8 10 c0 	movl   $0xc010d804,(%esp)
c0108b1e:	e8 30 78 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108b23:	e9 61 01 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
        }
        break;
c0108b28:	eb 2f                	jmp    c0108b59 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108b2a:	c7 04 24 64 d8 10 c0 	movl   $0xc010d864,(%esp)
c0108b31:	e8 1d 78 ff ff       	call   c0100353 <cprintf>
        goto failed;
c0108b36:	e9 4e 01 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108b3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b3e:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b41:	83 e0 05             	and    $0x5,%eax
c0108b44:	85 c0                	test   %eax,%eax
c0108b46:	75 11                	jne    c0108b59 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108b48:	c7 04 24 9c d8 10 c0 	movl   $0xc010d89c,(%esp)
c0108b4f:	e8 ff 77 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108b54:	e9 30 01 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108b59:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b63:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b66:	83 e0 02             	and    $0x2,%eax
c0108b69:	85 c0                	test   %eax,%eax
c0108b6b:	74 04                	je     c0108b71 <do_pgfault+0xce>
        perm |= PTE_W;
c0108b6d:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108b71:	8b 45 10             	mov    0x10(%ebp),%eax
c0108b74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108b7f:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108b82:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108b89:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    * VARIABLES:
    *   mm->pgdir : the PDT of these vma
    *
    */
    /*LAB3 EXERCISE 1: 2013011303*/
    ptep = get_pte(mm->pgdir, addr, 1); //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
c0108b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b93:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b96:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108b9d:	00 
c0108b9e:	8b 55 10             	mov    0x10(%ebp),%edx
c0108ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108ba5:	89 04 24             	mov    %eax,(%esp)
c0108ba8:	e8 3a ca ff ff       	call   c01055e7 <get_pte>
c0108bad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (!ptep) goto failed;
c0108bb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108bb4:	75 05                	jne    c0108bbb <do_pgfault+0x118>
c0108bb6:	e9 ce 00 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
    if (*ptep == 0) {
c0108bbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bbe:	8b 00                	mov    (%eax),%eax
c0108bc0:	85 c0                	test   %eax,%eax
c0108bc2:	75 2f                	jne    c0108bf3 <do_pgfault+0x150>
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
        struct Page *page = pgdir_alloc_page(mm->pgdir, addr, perm);
c0108bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bc7:	8b 40 0c             	mov    0xc(%eax),%eax
c0108bca:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108bcd:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108bd1:	8b 55 10             	mov    0x10(%ebp),%edx
c0108bd4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108bd8:	89 04 24             	mov    %eax,(%esp)
c0108bdb:	e8 7b d1 ff ff       	call   c0105d5b <pgdir_alloc_page>
c0108be0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (!page) goto failed;
c0108be3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108be7:	75 05                	jne    c0108bee <do_pgfault+0x14b>
c0108be9:	e9 9b 00 00 00       	jmp    c0108c89 <do_pgfault+0x1e6>
c0108bee:	e9 8f 00 00 00       	jmp    c0108c82 <do_pgfault+0x1df>
		     If the vma includes this addr is writable, then we can set the page writable by rewrite the *ptep.
		     This method could be used to implement the Copy on Write (COW) thchnology(a fast fork process method).
		  2) *ptep & PTE_P == 0 & but *ptep!=0, it means this pte is a  swap entry.
		     We should add the LAB3's results here.
     */
        if(swap_init_ok) {
c0108bf3:	a1 6c bf 19 c0       	mov    0xc019bf6c,%eax
c0108bf8:	85 c0                	test   %eax,%eax
c0108bfa:	74 6f                	je     c0108c6b <do_pgfault+0x1c8>
            struct Page *page=NULL;
c0108bfc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
                                    //(1）According to the mm AND addr, try to load the content of right disk page
                                    //    into the memory which page managed.
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                    //(3) make the page swappable.
            ret = swap_in(mm, addr, &page);
c0108c03:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0108c06:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c14:	89 04 24             	mov    %eax,(%esp)
c0108c17:	e8 eb e1 ff ff       	call   c0106e07 <swap_in>
c0108c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) goto failed;
c0108c1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108c23:	75 64                	jne    c0108c89 <do_pgfault+0x1e6>
            page_insert(mm->pgdir, page, addr, perm);
c0108c25:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c2b:	8b 40 0c             	mov    0xc(%eax),%eax
c0108c2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108c31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0108c35:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108c38:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108c3c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108c40:	89 04 24             	mov    %eax,(%esp)
c0108c43:	e8 fd cf ff ff       	call   c0105c45 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0108c48:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c4b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108c52:	00 
c0108c53:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108c57:	8b 45 10             	mov    0x10(%ebp),%eax
c0108c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c61:	89 04 24             	mov    %eax,(%esp)
c0108c64:	e8 d5 df ff ff       	call   c0106c3e <swap_map_swappable>
c0108c69:	eb 17                	jmp    c0108c82 <do_pgfault+0x1df>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c6e:	8b 00                	mov    (%eax),%eax
c0108c70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108c74:	c7 04 24 00 d9 10 c0 	movl   $0xc010d900,(%esp)
c0108c7b:	e8 d3 76 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108c80:	eb 07                	jmp    c0108c89 <do_pgfault+0x1e6>
        }
   }
   ret = 0;
c0108c82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0108c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108c8c:	c9                   	leave  
c0108c8d:	c3                   	ret    

c0108c8e <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c0108c8e:	55                   	push   %ebp
c0108c8f:	89 e5                	mov    %esp,%ebp
c0108c91:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c0108c94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108c98:	0f 84 e0 00 00 00    	je     c0108d7e <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c0108c9e:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0108ca5:	76 1c                	jbe    c0108cc3 <user_mem_check+0x35>
c0108ca7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108caa:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108cad:	01 d0                	add    %edx,%eax
c0108caf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108cb2:	76 0f                	jbe    c0108cc3 <user_mem_check+0x35>
c0108cb4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108cba:	01 d0                	add    %edx,%eax
c0108cbc:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c0108cc1:	76 0a                	jbe    c0108ccd <user_mem_check+0x3f>
            return 0;
c0108cc3:	b8 00 00 00 00       	mov    $0x0,%eax
c0108cc8:	e9 e2 00 00 00       	jmp    c0108daf <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c0108ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108cd3:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cd6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108cd9:	01 d0                	add    %edx,%eax
c0108cdb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c0108cde:	e9 88 00 00 00       	jmp    c0108d6b <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c0108ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ced:	89 04 24             	mov    %eax,(%esp)
c0108cf0:	e8 de ef ff ff       	call   c0107cd3 <find_vma>
c0108cf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108cf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108cfc:	74 0b                	je     c0108d09 <user_mem_check+0x7b>
c0108cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d01:	8b 40 04             	mov    0x4(%eax),%eax
c0108d04:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108d07:	76 0a                	jbe    c0108d13 <user_mem_check+0x85>
                return 0;
c0108d09:	b8 00 00 00 00       	mov    $0x0,%eax
c0108d0e:	e9 9c 00 00 00       	jmp    c0108daf <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c0108d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d16:	8b 50 0c             	mov    0xc(%eax),%edx
c0108d19:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108d1d:	74 07                	je     c0108d26 <user_mem_check+0x98>
c0108d1f:	b8 02 00 00 00       	mov    $0x2,%eax
c0108d24:	eb 05                	jmp    c0108d2b <user_mem_check+0x9d>
c0108d26:	b8 01 00 00 00       	mov    $0x1,%eax
c0108d2b:	21 d0                	and    %edx,%eax
c0108d2d:	85 c0                	test   %eax,%eax
c0108d2f:	75 07                	jne    c0108d38 <user_mem_check+0xaa>
                return 0;
c0108d31:	b8 00 00 00 00       	mov    $0x0,%eax
c0108d36:	eb 77                	jmp    c0108daf <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0108d38:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0108d3c:	74 24                	je     c0108d62 <user_mem_check+0xd4>
c0108d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d41:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d44:	83 e0 08             	and    $0x8,%eax
c0108d47:	85 c0                	test   %eax,%eax
c0108d49:	74 17                	je     c0108d62 <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0108d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d4e:	8b 40 04             	mov    0x4(%eax),%eax
c0108d51:	05 00 10 00 00       	add    $0x1000,%eax
c0108d56:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0108d59:	76 07                	jbe    c0108d62 <user_mem_check+0xd4>
                    return 0;
c0108d5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0108d60:	eb 4d                	jmp    c0108daf <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c0108d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d65:	8b 40 08             	mov    0x8(%eax),%eax
c0108d68:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0108d6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108d71:	0f 82 6c ff ff ff    	jb     c0108ce3 <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0108d77:	b8 01 00 00 00       	mov    $0x1,%eax
c0108d7c:	eb 31                	jmp    c0108daf <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0108d7e:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c0108d85:	76 23                	jbe    c0108daa <user_mem_check+0x11c>
c0108d87:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108d8d:	01 d0                	add    %edx,%eax
c0108d8f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108d92:	76 16                	jbe    c0108daa <user_mem_check+0x11c>
c0108d94:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d97:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108d9a:	01 d0                	add    %edx,%eax
c0108d9c:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c0108da1:	77 07                	ja     c0108daa <user_mem_check+0x11c>
c0108da3:	b8 01 00 00 00       	mov    $0x1,%eax
c0108da8:	eb 05                	jmp    c0108daf <user_mem_check+0x121>
c0108daa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108daf:	c9                   	leave  
c0108db0:	c3                   	ret    

c0108db1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108db1:	55                   	push   %ebp
c0108db2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108db4:	8b 55 08             	mov    0x8(%ebp),%edx
c0108db7:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0108dbc:	29 c2                	sub    %eax,%edx
c0108dbe:	89 d0                	mov    %edx,%eax
c0108dc0:	c1 f8 05             	sar    $0x5,%eax
}
c0108dc3:	5d                   	pop    %ebp
c0108dc4:	c3                   	ret    

c0108dc5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108dc5:	55                   	push   %ebp
c0108dc6:	89 e5                	mov    %esp,%ebp
c0108dc8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0108dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dce:	89 04 24             	mov    %eax,(%esp)
c0108dd1:	e8 db ff ff ff       	call   c0108db1 <page2ppn>
c0108dd6:	c1 e0 0c             	shl    $0xc,%eax
}
c0108dd9:	c9                   	leave  
c0108dda:	c3                   	ret    

c0108ddb <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0108ddb:	55                   	push   %ebp
c0108ddc:	89 e5                	mov    %esp,%ebp
c0108dde:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108de1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108de4:	89 04 24             	mov    %eax,(%esp)
c0108de7:	e8 d9 ff ff ff       	call   c0108dc5 <page2pa>
c0108dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108def:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108df2:	c1 e8 0c             	shr    $0xc,%eax
c0108df5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108df8:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c0108dfd:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108e00:	72 23                	jb     c0108e25 <page2kva+0x4a>
c0108e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e05:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108e09:	c7 44 24 08 28 d9 10 	movl   $0xc010d928,0x8(%esp)
c0108e10:	c0 
c0108e11:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0108e18:	00 
c0108e19:	c7 04 24 4b d9 10 c0 	movl   $0xc010d94b,(%esp)
c0108e20:	e8 b0 7f ff ff       	call   c0100dd5 <__panic>
c0108e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108e28:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108e2d:	c9                   	leave  
c0108e2e:	c3                   	ret    

c0108e2f <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108e2f:	55                   	push   %ebp
c0108e30:	89 e5                	mov    %esp,%ebp
c0108e32:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108e35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108e3c:	e8 e4 8c ff ff       	call   c0101b25 <ide_device_valid>
c0108e41:	85 c0                	test   %eax,%eax
c0108e43:	75 1c                	jne    c0108e61 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108e45:	c7 44 24 08 59 d9 10 	movl   $0xc010d959,0x8(%esp)
c0108e4c:	c0 
c0108e4d:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108e54:	00 
c0108e55:	c7 04 24 73 d9 10 c0 	movl   $0xc010d973,(%esp)
c0108e5c:	e8 74 7f ff ff       	call   c0100dd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108e61:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108e68:	e8 f7 8c ff ff       	call   c0101b64 <ide_device_size>
c0108e6d:	c1 e8 03             	shr    $0x3,%eax
c0108e70:	a3 7c e0 19 c0       	mov    %eax,0xc019e07c
}
c0108e75:	c9                   	leave  
c0108e76:	c3                   	ret    

c0108e77 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108e77:	55                   	push   %ebp
c0108e78:	89 e5                	mov    %esp,%ebp
c0108e7a:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108e7d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e80:	89 04 24             	mov    %eax,(%esp)
c0108e83:	e8 53 ff ff ff       	call   c0108ddb <page2kva>
c0108e88:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e8b:	c1 ea 08             	shr    $0x8,%edx
c0108e8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108e95:	74 0b                	je     c0108ea2 <swapfs_read+0x2b>
c0108e97:	8b 15 7c e0 19 c0    	mov    0xc019e07c,%edx
c0108e9d:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108ea0:	72 23                	jb     c0108ec5 <swapfs_read+0x4e>
c0108ea2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ea5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108ea9:	c7 44 24 08 84 d9 10 	movl   $0xc010d984,0x8(%esp)
c0108eb0:	c0 
c0108eb1:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108eb8:	00 
c0108eb9:	c7 04 24 73 d9 10 c0 	movl   $0xc010d973,(%esp)
c0108ec0:	e8 10 7f ff ff       	call   c0100dd5 <__panic>
c0108ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108ec8:	c1 e2 03             	shl    $0x3,%edx
c0108ecb:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108ed2:	00 
c0108ed3:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ed7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108edb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108ee2:	e8 bc 8c ff ff       	call   c0101ba3 <ide_read_secs>
}
c0108ee7:	c9                   	leave  
c0108ee8:	c3                   	ret    

c0108ee9 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0108ee9:	55                   	push   %ebp
c0108eea:	89 e5                	mov    %esp,%ebp
c0108eec:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108eef:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ef2:	89 04 24             	mov    %eax,(%esp)
c0108ef5:	e8 e1 fe ff ff       	call   c0108ddb <page2kva>
c0108efa:	8b 55 08             	mov    0x8(%ebp),%edx
c0108efd:	c1 ea 08             	shr    $0x8,%edx
c0108f00:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108f03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108f07:	74 0b                	je     c0108f14 <swapfs_write+0x2b>
c0108f09:	8b 15 7c e0 19 c0    	mov    0xc019e07c,%edx
c0108f0f:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108f12:	72 23                	jb     c0108f37 <swapfs_write+0x4e>
c0108f14:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f17:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108f1b:	c7 44 24 08 84 d9 10 	movl   $0xc010d984,0x8(%esp)
c0108f22:	c0 
c0108f23:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108f2a:	00 
c0108f2b:	c7 04 24 73 d9 10 c0 	movl   $0xc010d973,(%esp)
c0108f32:	e8 9e 7e ff ff       	call   c0100dd5 <__panic>
c0108f37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108f3a:	c1 e2 03             	shl    $0x3,%edx
c0108f3d:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108f44:	00 
c0108f45:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108f49:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108f54:	e8 8c 8e ff ff       	call   c0101de5 <ide_write_secs>
}
c0108f59:	c9                   	leave  
c0108f5a:	c3                   	ret    

c0108f5b <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108f5b:	52                   	push   %edx
    call *%ebx              # call fn
c0108f5c:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108f5e:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108f5f:	e8 d8 0b 00 00       	call   c0109b3c <do_exit>

c0108f64 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c0108f64:	55                   	push   %ebp
c0108f65:	89 e5                	mov    %esp,%ebp
c0108f67:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0108f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f70:	0f ab 02             	bts    %eax,(%edx)
c0108f73:	19 c0                	sbb    %eax,%eax
c0108f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0108f78:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108f7c:	0f 95 c0             	setne  %al
c0108f7f:	0f b6 c0             	movzbl %al,%eax
}
c0108f82:	c9                   	leave  
c0108f83:	c3                   	ret    

c0108f84 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c0108f84:	55                   	push   %ebp
c0108f85:	89 e5                	mov    %esp,%ebp
c0108f87:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c0108f8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108f8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f90:	0f b3 02             	btr    %eax,(%edx)
c0108f93:	19 c0                	sbb    %eax,%eax
c0108f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return oldbit != 0;
c0108f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108f9c:	0f 95 c0             	setne  %al
c0108f9f:	0f b6 c0             	movzbl %al,%eax
}
c0108fa2:	c9                   	leave  
c0108fa3:	c3                   	ret    

c0108fa4 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0108fa4:	55                   	push   %ebp
c0108fa5:	89 e5                	mov    %esp,%ebp
c0108fa7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108faa:	9c                   	pushf  
c0108fab:	58                   	pop    %eax
c0108fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108fb2:	25 00 02 00 00       	and    $0x200,%eax
c0108fb7:	85 c0                	test   %eax,%eax
c0108fb9:	74 0c                	je     c0108fc7 <__intr_save+0x23>
        intr_disable();
c0108fbb:	e8 6d 90 ff ff       	call   c010202d <intr_disable>
        return 1;
c0108fc0:	b8 01 00 00 00       	mov    $0x1,%eax
c0108fc5:	eb 05                	jmp    c0108fcc <__intr_save+0x28>
    }
    return 0;
c0108fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108fcc:	c9                   	leave  
c0108fcd:	c3                   	ret    

c0108fce <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108fce:	55                   	push   %ebp
c0108fcf:	89 e5                	mov    %esp,%ebp
c0108fd1:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108fd4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108fd8:	74 05                	je     c0108fdf <__intr_restore+0x11>
        intr_enable();
c0108fda:	e8 48 90 ff ff       	call   c0102027 <intr_enable>
    }
}
c0108fdf:	c9                   	leave  
c0108fe0:	c3                   	ret    

c0108fe1 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0108fe1:	55                   	push   %ebp
c0108fe2:	89 e5                	mov    %esp,%ebp
c0108fe4:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c0108fe7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108fee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108ff5:	e8 6a ff ff ff       	call   c0108f64 <test_and_set_bit>
c0108ffa:	85 c0                	test   %eax,%eax
c0108ffc:	0f 94 c0             	sete   %al
c0108fff:	0f b6 c0             	movzbl %al,%eax
}
c0109002:	c9                   	leave  
c0109003:	c3                   	ret    

c0109004 <lock>:

static inline void
lock(lock_t *lock) {
c0109004:	55                   	push   %ebp
c0109005:	89 e5                	mov    %esp,%ebp
c0109007:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c010900a:	eb 05                	jmp    c0109011 <lock+0xd>
        schedule();
c010900c:	e8 90 1b 00 00       	call   c010aba1 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0109011:	8b 45 08             	mov    0x8(%ebp),%eax
c0109014:	89 04 24             	mov    %eax,(%esp)
c0109017:	e8 c5 ff ff ff       	call   c0108fe1 <try_lock>
c010901c:	85 c0                	test   %eax,%eax
c010901e:	74 ec                	je     c010900c <lock+0x8>
        schedule();
    }
}
c0109020:	c9                   	leave  
c0109021:	c3                   	ret    

c0109022 <unlock>:

static inline void
unlock(lock_t *lock) {
c0109022:	55                   	push   %ebp
c0109023:	89 e5                	mov    %esp,%ebp
c0109025:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c0109028:	8b 45 08             	mov    0x8(%ebp),%eax
c010902b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010902f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109036:	e8 49 ff ff ff       	call   c0108f84 <test_and_clear_bit>
c010903b:	85 c0                	test   %eax,%eax
c010903d:	75 1c                	jne    c010905b <unlock+0x39>
        panic("Unlock failed.\n");
c010903f:	c7 44 24 08 a4 d9 10 	movl   $0xc010d9a4,0x8(%esp)
c0109046:	c0 
c0109047:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c010904e:	00 
c010904f:	c7 04 24 b4 d9 10 c0 	movl   $0xc010d9b4,(%esp)
c0109056:	e8 7a 7d ff ff       	call   c0100dd5 <__panic>
    }
}
c010905b:	c9                   	leave  
c010905c:	c3                   	ret    

c010905d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010905d:	55                   	push   %ebp
c010905e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0109060:	8b 55 08             	mov    0x8(%ebp),%edx
c0109063:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c0109068:	29 c2                	sub    %eax,%edx
c010906a:	89 d0                	mov    %edx,%eax
c010906c:	c1 f8 05             	sar    $0x5,%eax
}
c010906f:	5d                   	pop    %ebp
c0109070:	c3                   	ret    

c0109071 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0109071:	55                   	push   %ebp
c0109072:	89 e5                	mov    %esp,%ebp
c0109074:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0109077:	8b 45 08             	mov    0x8(%ebp),%eax
c010907a:	89 04 24             	mov    %eax,(%esp)
c010907d:	e8 db ff ff ff       	call   c010905d <page2ppn>
c0109082:	c1 e0 0c             	shl    $0xc,%eax
}
c0109085:	c9                   	leave  
c0109086:	c3                   	ret    

c0109087 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0109087:	55                   	push   %ebp
c0109088:	89 e5                	mov    %esp,%ebp
c010908a:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010908d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109090:	c1 e8 0c             	shr    $0xc,%eax
c0109093:	89 c2                	mov    %eax,%edx
c0109095:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c010909a:	39 c2                	cmp    %eax,%edx
c010909c:	72 1c                	jb     c01090ba <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010909e:	c7 44 24 08 c8 d9 10 	movl   $0xc010d9c8,0x8(%esp)
c01090a5:	c0 
c01090a6:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01090ad:	00 
c01090ae:	c7 04 24 e7 d9 10 c0 	movl   $0xc010d9e7,(%esp)
c01090b5:	e8 1b 7d ff ff       	call   c0100dd5 <__panic>
    }
    return &pages[PPN(pa)];
c01090ba:	a1 cc df 19 c0       	mov    0xc019dfcc,%eax
c01090bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01090c2:	c1 ea 0c             	shr    $0xc,%edx
c01090c5:	c1 e2 05             	shl    $0x5,%edx
c01090c8:	01 d0                	add    %edx,%eax
}
c01090ca:	c9                   	leave  
c01090cb:	c3                   	ret    

c01090cc <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01090cc:	55                   	push   %ebp
c01090cd:	89 e5                	mov    %esp,%ebp
c01090cf:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01090d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01090d5:	89 04 24             	mov    %eax,(%esp)
c01090d8:	e8 94 ff ff ff       	call   c0109071 <page2pa>
c01090dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090e3:	c1 e8 0c             	shr    $0xc,%eax
c01090e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090e9:	a1 e0 be 19 c0       	mov    0xc019bee0,%eax
c01090ee:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01090f1:	72 23                	jb     c0109116 <page2kva+0x4a>
c01090f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01090f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01090fa:	c7 44 24 08 f8 d9 10 	movl   $0xc010d9f8,0x8(%esp)
c0109101:	c0 
c0109102:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109109:	00 
c010910a:	c7 04 24 e7 d9 10 c0 	movl   $0xc010d9e7,(%esp)
c0109111:	e8 bf 7c ff ff       	call   c0100dd5 <__panic>
c0109116:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109119:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010911e:	c9                   	leave  
c010911f:	c3                   	ret    

c0109120 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0109120:	55                   	push   %ebp
c0109121:	89 e5                	mov    %esp,%ebp
c0109123:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0109126:	8b 45 08             	mov    0x8(%ebp),%eax
c0109129:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010912c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0109133:	77 23                	ja     c0109158 <kva2page+0x38>
c0109135:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109138:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010913c:	c7 44 24 08 1c da 10 	movl   $0xc010da1c,0x8(%esp)
c0109143:	c0 
c0109144:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010914b:	00 
c010914c:	c7 04 24 e7 d9 10 c0 	movl   $0xc010d9e7,(%esp)
c0109153:	e8 7d 7c ff ff       	call   c0100dd5 <__panic>
c0109158:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010915b:	05 00 00 00 40       	add    $0x40000000,%eax
c0109160:	89 04 24             	mov    %eax,(%esp)
c0109163:	e8 1f ff ff ff       	call   c0109087 <pa2page>
}
c0109168:	c9                   	leave  
c0109169:	c3                   	ret    

c010916a <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c010916a:	55                   	push   %ebp
c010916b:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c010916d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109170:	8b 40 18             	mov    0x18(%eax),%eax
c0109173:	8d 50 01             	lea    0x1(%eax),%edx
c0109176:	8b 45 08             	mov    0x8(%ebp),%eax
c0109179:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c010917c:	8b 45 08             	mov    0x8(%ebp),%eax
c010917f:	8b 40 18             	mov    0x18(%eax),%eax
}
c0109182:	5d                   	pop    %ebp
c0109183:	c3                   	ret    

c0109184 <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c0109184:	55                   	push   %ebp
c0109185:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c0109187:	8b 45 08             	mov    0x8(%ebp),%eax
c010918a:	8b 40 18             	mov    0x18(%eax),%eax
c010918d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109190:	8b 45 08             	mov    0x8(%ebp),%eax
c0109193:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c0109196:	8b 45 08             	mov    0x8(%ebp),%eax
c0109199:	8b 40 18             	mov    0x18(%eax),%eax
}
c010919c:	5d                   	pop    %ebp
c010919d:	c3                   	ret    

c010919e <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c010919e:	55                   	push   %ebp
c010919f:	89 e5                	mov    %esp,%ebp
c01091a1:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01091a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01091a8:	74 0e                	je     c01091b8 <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c01091aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ad:	83 c0 1c             	add    $0x1c,%eax
c01091b0:	89 04 24             	mov    %eax,(%esp)
c01091b3:	e8 4c fe ff ff       	call   c0109004 <lock>
    }
}
c01091b8:	c9                   	leave  
c01091b9:	c3                   	ret    

c01091ba <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c01091ba:	55                   	push   %ebp
c01091bb:	89 e5                	mov    %esp,%ebp
c01091bd:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01091c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01091c4:	74 0e                	je     c01091d4 <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c01091c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01091c9:	83 c0 1c             	add    $0x1c,%eax
c01091cc:	89 04 24             	mov    %eax,(%esp)
c01091cf:	e8 4e fe ff ff       	call   c0109022 <unlock>
    }
}
c01091d4:	c9                   	leave  
c01091d5:	c3                   	ret    

c01091d6 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01091d6:	55                   	push   %ebp
c01091d7:	89 e5                	mov    %esp,%ebp
c01091d9:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01091dc:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c01091e3:	e8 23 b8 ff ff       	call   c0104a0b <kmalloc>
c01091e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01091eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01091ef:	74 3a                	je     c010922b <alloc_proc+0x55>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        memset(proc, 0, sizeof(struct proc_struct));
c01091f1:	c7 44 24 08 7c 00 00 	movl   $0x7c,0x8(%esp)
c01091f8:	00 
c01091f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109200:	00 
c0109201:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109204:	89 04 24             	mov    %eax,(%esp)
c0109207:	e8 00 27 00 00       	call   c010b90c <memset>
        proc->state = PROC_UNINIT;
c010920c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010920f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c0109215:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109218:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->cr3 = boot_cr3;
c010921f:	8b 15 c8 df 19 c0    	mov    0xc019dfc8,%edx
c0109225:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109228:	89 50 40             	mov    %edx,0x40(%eax)
     * below fields(add in LAB5) in proc_struct need to be initialized	
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
	 */
    }
    return proc;
c010922b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010922e:	c9                   	leave  
c010922f:	c3                   	ret    

c0109230 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0109230:	55                   	push   %ebp
c0109231:	89 e5                	mov    %esp,%ebp
c0109233:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c0109236:	8b 45 08             	mov    0x8(%ebp),%eax
c0109239:	83 c0 48             	add    $0x48,%eax
c010923c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109243:	00 
c0109244:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010924b:	00 
c010924c:	89 04 24             	mov    %eax,(%esp)
c010924f:	e8 b8 26 00 00       	call   c010b90c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c0109254:	8b 45 08             	mov    0x8(%ebp),%eax
c0109257:	8d 50 48             	lea    0x48(%eax),%edx
c010925a:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109261:	00 
c0109262:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109265:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109269:	89 14 24             	mov    %edx,(%esp)
c010926c:	e8 7d 27 00 00       	call   c010b9ee <memcpy>
}
c0109271:	c9                   	leave  
c0109272:	c3                   	ret    

c0109273 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c0109273:	55                   	push   %ebp
c0109274:	89 e5                	mov    %esp,%ebp
c0109276:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0109279:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109280:	00 
c0109281:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109288:	00 
c0109289:	c7 04 24 a4 df 19 c0 	movl   $0xc019dfa4,(%esp)
c0109290:	e8 77 26 00 00       	call   c010b90c <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c0109295:	8b 45 08             	mov    0x8(%ebp),%eax
c0109298:	83 c0 48             	add    $0x48,%eax
c010929b:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01092a2:	00 
c01092a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01092a7:	c7 04 24 a4 df 19 c0 	movl   $0xc019dfa4,(%esp)
c01092ae:	e8 3b 27 00 00       	call   c010b9ee <memcpy>
}
c01092b3:	c9                   	leave  
c01092b4:	c3                   	ret    

c01092b5 <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c01092b5:	55                   	push   %ebp
c01092b6:	89 e5                	mov    %esp,%ebp
c01092b8:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c01092bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01092be:	83 c0 58             	add    $0x58,%eax
c01092c1:	c7 45 fc b0 e0 19 c0 	movl   $0xc019e0b0,-0x4(%ebp)
c01092c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01092cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01092ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01092d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01092d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01092d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01092da:	8b 40 04             	mov    0x4(%eax),%eax
c01092dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01092e0:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01092e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01092e6:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01092e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01092ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092ef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01092f2:	89 10                	mov    %edx,(%eax)
c01092f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01092f7:	8b 10                	mov    (%eax),%edx
c01092f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01092fc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01092ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109305:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109308:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010930b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010930e:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c0109310:	8b 45 08             	mov    0x8(%ebp),%eax
c0109313:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c010931a:	8b 45 08             	mov    0x8(%ebp),%eax
c010931d:	8b 40 14             	mov    0x14(%eax),%eax
c0109320:	8b 50 70             	mov    0x70(%eax),%edx
c0109323:	8b 45 08             	mov    0x8(%ebp),%eax
c0109326:	89 50 78             	mov    %edx,0x78(%eax)
c0109329:	8b 45 08             	mov    0x8(%ebp),%eax
c010932c:	8b 40 78             	mov    0x78(%eax),%eax
c010932f:	85 c0                	test   %eax,%eax
c0109331:	74 0c                	je     c010933f <set_links+0x8a>
        proc->optr->yptr = proc;
c0109333:	8b 45 08             	mov    0x8(%ebp),%eax
c0109336:	8b 40 78             	mov    0x78(%eax),%eax
c0109339:	8b 55 08             	mov    0x8(%ebp),%edx
c010933c:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c010933f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109342:	8b 40 14             	mov    0x14(%eax),%eax
c0109345:	8b 55 08             	mov    0x8(%ebp),%edx
c0109348:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c010934b:	a1 a0 df 19 c0       	mov    0xc019dfa0,%eax
c0109350:	83 c0 01             	add    $0x1,%eax
c0109353:	a3 a0 df 19 c0       	mov    %eax,0xc019dfa0
}
c0109358:	c9                   	leave  
c0109359:	c3                   	ret    

c010935a <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c010935a:	55                   	push   %ebp
c010935b:	89 e5                	mov    %esp,%ebp
c010935d:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c0109360:	8b 45 08             	mov    0x8(%ebp),%eax
c0109363:	83 c0 58             	add    $0x58,%eax
c0109366:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109369:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010936c:	8b 40 04             	mov    0x4(%eax),%eax
c010936f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109372:	8b 12                	mov    (%edx),%edx
c0109374:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109377:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010937a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010937d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109380:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109383:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109386:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109389:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c010938b:	8b 45 08             	mov    0x8(%ebp),%eax
c010938e:	8b 40 78             	mov    0x78(%eax),%eax
c0109391:	85 c0                	test   %eax,%eax
c0109393:	74 0f                	je     c01093a4 <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c0109395:	8b 45 08             	mov    0x8(%ebp),%eax
c0109398:	8b 40 78             	mov    0x78(%eax),%eax
c010939b:	8b 55 08             	mov    0x8(%ebp),%edx
c010939e:	8b 52 74             	mov    0x74(%edx),%edx
c01093a1:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c01093a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01093a7:	8b 40 74             	mov    0x74(%eax),%eax
c01093aa:	85 c0                	test   %eax,%eax
c01093ac:	74 11                	je     c01093bf <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c01093ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b1:	8b 40 74             	mov    0x74(%eax),%eax
c01093b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01093b7:	8b 52 78             	mov    0x78(%edx),%edx
c01093ba:	89 50 78             	mov    %edx,0x78(%eax)
c01093bd:	eb 0f                	jmp    c01093ce <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c01093bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01093c2:	8b 40 14             	mov    0x14(%eax),%eax
c01093c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01093c8:	8b 52 78             	mov    0x78(%edx),%edx
c01093cb:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c01093ce:	a1 a0 df 19 c0       	mov    0xc019dfa0,%eax
c01093d3:	83 e8 01             	sub    $0x1,%eax
c01093d6:	a3 a0 df 19 c0       	mov    %eax,0xc019dfa0
}
c01093db:	c9                   	leave  
c01093dc:	c3                   	ret    

c01093dd <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01093dd:	55                   	push   %ebp
c01093de:	89 e5                	mov    %esp,%ebp
c01093e0:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01093e3:	c7 45 f8 b0 e0 19 c0 	movl   $0xc019e0b0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01093ea:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c01093ef:	83 c0 01             	add    $0x1,%eax
c01093f2:	a3 80 9a 12 c0       	mov    %eax,0xc0129a80
c01093f7:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c01093fc:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109401:	7e 0c                	jle    c010940f <get_pid+0x32>
        last_pid = 1;
c0109403:	c7 05 80 9a 12 c0 01 	movl   $0x1,0xc0129a80
c010940a:	00 00 00 
        goto inside;
c010940d:	eb 13                	jmp    c0109422 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010940f:	8b 15 80 9a 12 c0    	mov    0xc0129a80,%edx
c0109415:	a1 84 9a 12 c0       	mov    0xc0129a84,%eax
c010941a:	39 c2                	cmp    %eax,%edx
c010941c:	0f 8c ac 00 00 00    	jl     c01094ce <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0109422:	c7 05 84 9a 12 c0 00 	movl   $0x2000,0xc0129a84
c0109429:	20 00 00 
    repeat:
        le = list;
c010942c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010942f:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0109432:	eb 7f                	jmp    c01094b3 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0109434:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109437:	83 e8 58             	sub    $0x58,%eax
c010943a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109440:	8b 50 04             	mov    0x4(%eax),%edx
c0109443:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c0109448:	39 c2                	cmp    %eax,%edx
c010944a:	75 3e                	jne    c010948a <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c010944c:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c0109451:	83 c0 01             	add    $0x1,%eax
c0109454:	a3 80 9a 12 c0       	mov    %eax,0xc0129a80
c0109459:	8b 15 80 9a 12 c0    	mov    0xc0129a80,%edx
c010945f:	a1 84 9a 12 c0       	mov    0xc0129a84,%eax
c0109464:	39 c2                	cmp    %eax,%edx
c0109466:	7c 4b                	jl     c01094b3 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0109468:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c010946d:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0109472:	7e 0a                	jle    c010947e <get_pid+0xa1>
                        last_pid = 1;
c0109474:	c7 05 80 9a 12 c0 01 	movl   $0x1,0xc0129a80
c010947b:	00 00 00 
                    }
                    next_safe = MAX_PID;
c010947e:	c7 05 84 9a 12 c0 00 	movl   $0x2000,0xc0129a84
c0109485:	20 00 00 
                    goto repeat;
c0109488:	eb a2                	jmp    c010942c <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c010948a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010948d:	8b 50 04             	mov    0x4(%eax),%edx
c0109490:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
c0109495:	39 c2                	cmp    %eax,%edx
c0109497:	7e 1a                	jle    c01094b3 <get_pid+0xd6>
c0109499:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010949c:	8b 50 04             	mov    0x4(%eax),%edx
c010949f:	a1 84 9a 12 c0       	mov    0xc0129a84,%eax
c01094a4:	39 c2                	cmp    %eax,%edx
c01094a6:	7d 0b                	jge    c01094b3 <get_pid+0xd6>
                next_safe = proc->pid;
c01094a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01094ab:	8b 40 04             	mov    0x4(%eax),%eax
c01094ae:	a3 84 9a 12 c0       	mov    %eax,0xc0129a84
c01094b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01094b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01094b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094bc:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c01094bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01094c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01094c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01094c8:	0f 85 66 ff ff ff    	jne    c0109434 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c01094ce:	a1 80 9a 12 c0       	mov    0xc0129a80,%eax
}
c01094d3:	c9                   	leave  
c01094d4:	c3                   	ret    

c01094d5 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c01094d5:	55                   	push   %ebp
c01094d6:	89 e5                	mov    %esp,%ebp
c01094d8:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01094db:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01094e0:	39 45 08             	cmp    %eax,0x8(%ebp)
c01094e3:	74 63                	je     c0109548 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01094e5:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c01094ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01094ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01094f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01094f3:	e8 ac fa ff ff       	call   c0108fa4 <__intr_save>
c01094f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01094fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01094fe:	a3 88 bf 19 c0       	mov    %eax,0xc019bf88
            load_esp0(next->kstack + KSTACKSIZE);
c0109503:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109506:	8b 40 0c             	mov    0xc(%eax),%eax
c0109509:	05 00 20 00 00       	add    $0x2000,%eax
c010950e:	89 04 24             	mov    %eax,(%esp)
c0109511:	e8 1c b8 ff ff       	call   c0104d32 <load_esp0>
            lcr3(next->cr3);
c0109516:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109519:	8b 40 40             	mov    0x40(%eax),%eax
c010951c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010951f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109522:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0109525:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109528:	8d 50 1c             	lea    0x1c(%eax),%edx
c010952b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010952e:	83 c0 1c             	add    $0x1c,%eax
c0109531:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109535:	89 04 24             	mov    %eax,(%esp)
c0109538:	e8 6c 15 00 00       	call   c010aaa9 <switch_to>
        }
        local_intr_restore(intr_flag);
c010953d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109540:	89 04 24             	mov    %eax,(%esp)
c0109543:	e8 86 fa ff ff       	call   c0108fce <__intr_restore>
    }
}
c0109548:	c9                   	leave  
c0109549:	c3                   	ret    

c010954a <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c010954a:	55                   	push   %ebp
c010954b:	89 e5                	mov    %esp,%ebp
c010954d:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0109550:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109555:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109558:	89 04 24             	mov    %eax,(%esp)
c010955b:	e8 a2 94 ff ff       	call   c0102a02 <forkrets>
}
c0109560:	c9                   	leave  
c0109561:	c3                   	ret    

c0109562 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0109562:	55                   	push   %ebp
c0109563:	89 e5                	mov    %esp,%ebp
c0109565:	53                   	push   %ebx
c0109566:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0109569:	8b 45 08             	mov    0x8(%ebp),%eax
c010956c:	8d 58 60             	lea    0x60(%eax),%ebx
c010956f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109572:	8b 40 04             	mov    0x4(%eax),%eax
c0109575:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010957c:	00 
c010957d:	89 04 24             	mov    %eax,(%esp)
c0109580:	e8 da 18 00 00       	call   c010ae5f <hash32>
c0109585:	c1 e0 03             	shl    $0x3,%eax
c0109588:	05 a0 bf 19 c0       	add    $0xc019bfa0,%eax
c010958d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109590:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0109593:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109596:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109599:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010959c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010959f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095a2:	8b 40 04             	mov    0x4(%eax),%eax
c01095a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095a8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01095ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01095ae:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01095b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01095b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01095b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01095ba:	89 10                	mov    %edx,(%eax)
c01095bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01095bf:	8b 10                	mov    (%eax),%edx
c01095c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01095c4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01095c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01095ca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01095cd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01095d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01095d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01095d6:	89 10                	mov    %edx,(%eax)
}
c01095d8:	83 c4 34             	add    $0x34,%esp
c01095db:	5b                   	pop    %ebx
c01095dc:	5d                   	pop    %ebp
c01095dd:	c3                   	ret    

c01095de <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c01095de:	55                   	push   %ebp
c01095df:	89 e5                	mov    %esp,%ebp
c01095e1:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c01095e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01095e7:	83 c0 60             	add    $0x60,%eax
c01095ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01095ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01095f0:	8b 40 04             	mov    0x4(%eax),%eax
c01095f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01095f6:	8b 12                	mov    (%edx),%edx
c01095f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01095fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01095fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109601:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109604:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109607:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010960a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010960d:	89 10                	mov    %edx,(%eax)
}
c010960f:	c9                   	leave  
c0109610:	c3                   	ret    

c0109611 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0109611:	55                   	push   %ebp
c0109612:	89 e5                	mov    %esp,%ebp
c0109614:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0109617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010961b:	7e 5f                	jle    c010967c <find_proc+0x6b>
c010961d:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0109624:	7f 56                	jg     c010967c <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0109626:	8b 45 08             	mov    0x8(%ebp),%eax
c0109629:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109630:	00 
c0109631:	89 04 24             	mov    %eax,(%esp)
c0109634:	e8 26 18 00 00       	call   c010ae5f <hash32>
c0109639:	c1 e0 03             	shl    $0x3,%eax
c010963c:	05 a0 bf 19 c0       	add    $0xc019bfa0,%eax
c0109641:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109644:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109647:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c010964a:	eb 19                	jmp    c0109665 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c010964c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010964f:	83 e8 60             	sub    $0x60,%eax
c0109652:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0109655:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109658:	8b 40 04             	mov    0x4(%eax),%eax
c010965b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010965e:	75 05                	jne    c0109665 <find_proc+0x54>
                return proc;
c0109660:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109663:	eb 1c                	jmp    c0109681 <find_proc+0x70>
c0109665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109668:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010966b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010966e:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109671:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109674:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109677:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010967a:	75 d0                	jne    c010964c <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c010967c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109681:	c9                   	leave  
c0109682:	c3                   	ret    

c0109683 <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0109683:	55                   	push   %ebp
c0109684:	89 e5                	mov    %esp,%ebp
c0109686:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0109689:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109690:	00 
c0109691:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109698:	00 
c0109699:	8d 45 ac             	lea    -0x54(%ebp),%eax
c010969c:	89 04 24             	mov    %eax,(%esp)
c010969f:	e8 68 22 00 00       	call   c010b90c <memset>
    tf.tf_cs = KERNEL_CS;
c01096a4:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c01096aa:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c01096b0:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01096b4:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c01096b8:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c01096bc:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c01096c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01096c3:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c01096c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c01096cc:	b8 5b 8f 10 c0       	mov    $0xc0108f5b,%eax
c01096d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c01096d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01096d7:	80 cc 01             	or     $0x1,%ah
c01096da:	89 c2                	mov    %eax,%edx
c01096dc:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01096df:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01096ea:	00 
c01096eb:	89 14 24             	mov    %edx,(%esp)
c01096ee:	e8 25 03 00 00       	call   c0109a18 <do_fork>
}
c01096f3:	c9                   	leave  
c01096f4:	c3                   	ret    

c01096f5 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c01096f5:	55                   	push   %ebp
c01096f6:	89 e5                	mov    %esp,%ebp
c01096f8:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c01096fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109702:	e8 79 b7 ff ff       	call   c0104e80 <alloc_pages>
c0109707:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010970a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010970e:	74 1a                	je     c010972a <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0109710:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109713:	89 04 24             	mov    %eax,(%esp)
c0109716:	e8 b1 f9 ff ff       	call   c01090cc <page2kva>
c010971b:	89 c2                	mov    %eax,%edx
c010971d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109720:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0109723:	b8 00 00 00 00       	mov    $0x0,%eax
c0109728:	eb 05                	jmp    c010972f <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c010972a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c010972f:	c9                   	leave  
c0109730:	c3                   	ret    

c0109731 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0109731:	55                   	push   %ebp
c0109732:	89 e5                	mov    %esp,%ebp
c0109734:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0109737:	8b 45 08             	mov    0x8(%ebp),%eax
c010973a:	8b 40 0c             	mov    0xc(%eax),%eax
c010973d:	89 04 24             	mov    %eax,(%esp)
c0109740:	e8 db f9 ff ff       	call   c0109120 <kva2page>
c0109745:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010974c:	00 
c010974d:	89 04 24             	mov    %eax,(%esp)
c0109750:	e8 96 b7 ff ff       	call   c0104eeb <free_pages>
}
c0109755:	c9                   	leave  
c0109756:	c3                   	ret    

c0109757 <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c0109757:	55                   	push   %ebp
c0109758:	89 e5                	mov    %esp,%ebp
c010975a:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c010975d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109764:	e8 17 b7 ff ff       	call   c0104e80 <alloc_pages>
c0109769:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010976c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109770:	75 0a                	jne    c010977c <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109772:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0109777:	e9 80 00 00 00       	jmp    c01097fc <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c010977c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010977f:	89 04 24             	mov    %eax,(%esp)
c0109782:	e8 45 f9 ff ff       	call   c01090cc <page2kva>
c0109787:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c010978a:	a1 e4 be 19 c0       	mov    0xc019bee4,%eax
c010978f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0109796:	00 
c0109797:	89 44 24 04          	mov    %eax,0x4(%esp)
c010979b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010979e:	89 04 24             	mov    %eax,(%esp)
c01097a1:	e8 48 22 00 00       	call   c010b9ee <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c01097a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097a9:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01097af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01097b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01097b5:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c01097bc:	77 23                	ja     c01097e1 <setup_pgdir+0x8a>
c01097be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01097c5:	c7 44 24 08 1c da 10 	movl   $0xc010da1c,0x8(%esp)
c01097cc:	c0 
c01097cd:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01097d4:	00 
c01097d5:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c01097dc:	e8 f4 75 ff ff       	call   c0100dd5 <__panic>
c01097e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097e4:	05 00 00 00 40       	add    $0x40000000,%eax
c01097e9:	83 c8 03             	or     $0x3,%eax
c01097ec:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c01097ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01097f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01097f4:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c01097f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01097fc:	c9                   	leave  
c01097fd:	c3                   	ret    

c01097fe <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c01097fe:	55                   	push   %ebp
c01097ff:	89 e5                	mov    %esp,%ebp
c0109801:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109804:	8b 45 08             	mov    0x8(%ebp),%eax
c0109807:	8b 40 0c             	mov    0xc(%eax),%eax
c010980a:	89 04 24             	mov    %eax,(%esp)
c010980d:	e8 0e f9 ff ff       	call   c0109120 <kva2page>
c0109812:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109819:	00 
c010981a:	89 04 24             	mov    %eax,(%esp)
c010981d:	e8 c9 b6 ff ff       	call   c0104eeb <free_pages>
}
c0109822:	c9                   	leave  
c0109823:	c3                   	ret    

c0109824 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109824:	55                   	push   %ebp
c0109825:	89 e5                	mov    %esp,%ebp
c0109827:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c010982a:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010982f:	8b 40 18             	mov    0x18(%eax),%eax
c0109832:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109835:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109839:	75 0a                	jne    c0109845 <copy_mm+0x21>
        return 0;
c010983b:	b8 00 00 00 00       	mov    $0x0,%eax
c0109840:	e9 f9 00 00 00       	jmp    c010993e <copy_mm+0x11a>
    }
    if (clone_flags & CLONE_VM) {
c0109845:	8b 45 08             	mov    0x8(%ebp),%eax
c0109848:	25 00 01 00 00       	and    $0x100,%eax
c010984d:	85 c0                	test   %eax,%eax
c010984f:	74 08                	je     c0109859 <copy_mm+0x35>
        mm = oldmm;
c0109851:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109854:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109857:	eb 78                	jmp    c01098d1 <copy_mm+0xad>
    }

    int ret = -E_NO_MEM;
c0109859:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109860:	e8 9a e3 ff ff       	call   c0107bff <mm_create>
c0109865:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010986c:	75 05                	jne    c0109873 <copy_mm+0x4f>
        goto bad_mm;
c010986e:	e9 c8 00 00 00       	jmp    c010993b <copy_mm+0x117>
    }
    if (setup_pgdir(mm) != 0) {
c0109873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109876:	89 04 24             	mov    %eax,(%esp)
c0109879:	e8 d9 fe ff ff       	call   c0109757 <setup_pgdir>
c010987e:	85 c0                	test   %eax,%eax
c0109880:	74 05                	je     c0109887 <copy_mm+0x63>
        goto bad_pgdir_cleanup_mm;
c0109882:	e9 a9 00 00 00       	jmp    c0109930 <copy_mm+0x10c>
    }

    lock_mm(oldmm);
c0109887:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010988a:	89 04 24             	mov    %eax,(%esp)
c010988d:	e8 0c f9 ff ff       	call   c010919e <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109892:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109895:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109899:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010989c:	89 04 24             	mov    %eax,(%esp)
c010989f:	e8 72 e8 ff ff       	call   c0108116 <dup_mmap>
c01098a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c01098a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01098aa:	89 04 24             	mov    %eax,(%esp)
c01098ad:	e8 08 f9 ff ff       	call   c01091ba <unlock_mm>

    if (ret != 0) {
c01098b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01098b6:	74 19                	je     c01098d1 <copy_mm+0xad>
        goto bad_dup_cleanup_mmap;
c01098b8:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c01098b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098bc:	89 04 24             	mov    %eax,(%esp)
c01098bf:	e8 53 e9 ff ff       	call   c0108217 <exit_mmap>
    put_pgdir(mm);
c01098c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098c7:	89 04 24             	mov    %eax,(%esp)
c01098ca:	e8 2f ff ff ff       	call   c01097fe <put_pgdir>
c01098cf:	eb 5f                	jmp    c0109930 <copy_mm+0x10c>
    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c01098d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098d4:	89 04 24             	mov    %eax,(%esp)
c01098d7:	e8 8e f8 ff ff       	call   c010916a <mm_count_inc>
    proc->mm = mm;
c01098dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098df:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098e2:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c01098e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01098e8:	8b 40 0c             	mov    0xc(%eax),%eax
c01098eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01098ee:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c01098f5:	77 23                	ja     c010991a <copy_mm+0xf6>
c01098f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01098fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01098fe:	c7 44 24 08 1c da 10 	movl   $0xc010da1c,0x8(%esp)
c0109905:	c0 
c0109906:	c7 44 24 04 53 01 00 	movl   $0x153,0x4(%esp)
c010990d:	00 
c010990e:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109915:	e8 bb 74 ff ff       	call   c0100dd5 <__panic>
c010991a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010991d:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109923:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109926:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109929:	b8 00 00 00 00       	mov    $0x0,%eax
c010992e:	eb 0e                	jmp    c010993e <copy_mm+0x11a>
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109930:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109933:	89 04 24             	mov    %eax,(%esp)
c0109936:	e8 1d e6 ff ff       	call   c0107f58 <mm_destroy>
bad_mm:
    return ret;
c010993b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010993e:	c9                   	leave  
c010993f:	c3                   	ret    

c0109940 <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109940:	55                   	push   %ebp
c0109941:	89 e5                	mov    %esp,%ebp
c0109943:	57                   	push   %edi
c0109944:	56                   	push   %esi
c0109945:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109946:	8b 45 08             	mov    0x8(%ebp),%eax
c0109949:	8b 40 0c             	mov    0xc(%eax),%eax
c010994c:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109951:	89 c2                	mov    %eax,%edx
c0109953:	8b 45 08             	mov    0x8(%ebp),%eax
c0109956:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109959:	8b 45 08             	mov    0x8(%ebp),%eax
c010995c:	8b 40 3c             	mov    0x3c(%eax),%eax
c010995f:	8b 55 10             	mov    0x10(%ebp),%edx
c0109962:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109967:	89 c1                	mov    %eax,%ecx
c0109969:	83 e1 01             	and    $0x1,%ecx
c010996c:	85 c9                	test   %ecx,%ecx
c010996e:	74 0e                	je     c010997e <copy_thread+0x3e>
c0109970:	0f b6 0a             	movzbl (%edx),%ecx
c0109973:	88 08                	mov    %cl,(%eax)
c0109975:	83 c0 01             	add    $0x1,%eax
c0109978:	83 c2 01             	add    $0x1,%edx
c010997b:	83 eb 01             	sub    $0x1,%ebx
c010997e:	89 c1                	mov    %eax,%ecx
c0109980:	83 e1 02             	and    $0x2,%ecx
c0109983:	85 c9                	test   %ecx,%ecx
c0109985:	74 0f                	je     c0109996 <copy_thread+0x56>
c0109987:	0f b7 0a             	movzwl (%edx),%ecx
c010998a:	66 89 08             	mov    %cx,(%eax)
c010998d:	83 c0 02             	add    $0x2,%eax
c0109990:	83 c2 02             	add    $0x2,%edx
c0109993:	83 eb 02             	sub    $0x2,%ebx
c0109996:	89 d9                	mov    %ebx,%ecx
c0109998:	c1 e9 02             	shr    $0x2,%ecx
c010999b:	89 c7                	mov    %eax,%edi
c010999d:	89 d6                	mov    %edx,%esi
c010999f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01099a1:	89 f2                	mov    %esi,%edx
c01099a3:	89 f8                	mov    %edi,%eax
c01099a5:	b9 00 00 00 00       	mov    $0x0,%ecx
c01099aa:	89 de                	mov    %ebx,%esi
c01099ac:	83 e6 02             	and    $0x2,%esi
c01099af:	85 f6                	test   %esi,%esi
c01099b1:	74 0b                	je     c01099be <copy_thread+0x7e>
c01099b3:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c01099b7:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c01099bb:	83 c1 02             	add    $0x2,%ecx
c01099be:	83 e3 01             	and    $0x1,%ebx
c01099c1:	85 db                	test   %ebx,%ebx
c01099c3:	74 07                	je     c01099cc <copy_thread+0x8c>
c01099c5:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c01099c9:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c01099cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01099cf:	8b 40 3c             	mov    0x3c(%eax),%eax
c01099d2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c01099d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01099dc:	8b 40 3c             	mov    0x3c(%eax),%eax
c01099df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01099e2:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c01099e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01099e8:	8b 40 3c             	mov    0x3c(%eax),%eax
c01099eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01099ee:	8b 52 3c             	mov    0x3c(%edx),%edx
c01099f1:	8b 52 40             	mov    0x40(%edx),%edx
c01099f4:	80 ce 02             	or     $0x2,%dh
c01099f7:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c01099fa:	ba 4a 95 10 c0       	mov    $0xc010954a,%edx
c01099ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a02:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109a05:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a08:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109a0b:	89 c2                	mov    %eax,%edx
c0109a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a10:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109a13:	5b                   	pop    %ebx
c0109a14:	5e                   	pop    %esi
c0109a15:	5f                   	pop    %edi
c0109a16:	5d                   	pop    %ebp
c0109a17:	c3                   	ret    

c0109a18 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109a18:	55                   	push   %ebp
c0109a19:	89 e5                	mov    %esp,%ebp
c0109a1b:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109a1e:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109a25:	a1 a0 df 19 c0       	mov    0xc019dfa0,%eax
c0109a2a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109a2f:	7e 05                	jle    c0109a36 <do_fork+0x1e>
        goto fork_out;
c0109a31:	e9 f2 00 00 00       	jmp    c0109b28 <do_fork+0x110>
    }
    ret = -E_NO_MEM;
c0109a36:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    //    1. call alloc_proc to allocate a proc_struct
    proc = alloc_proc();
c0109a3d:	e8 94 f7 ff ff       	call   c01091d6 <alloc_proc>
c0109a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!proc) goto fork_out;
c0109a45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109a49:	75 05                	jne    c0109a50 <do_fork+0x38>
c0109a4b:	e9 d8 00 00 00       	jmp    c0109b28 <do_fork+0x110>
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc)) goto bad_fork_cleanup_proc;
c0109a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a53:	89 04 24             	mov    %eax,(%esp)
c0109a56:	e8 9a fc ff ff       	call   c01096f5 <setup_kstack>
c0109a5b:	85 c0                	test   %eax,%eax
c0109a5d:	74 05                	je     c0109a64 <do_fork+0x4c>
c0109a5f:	e9 c9 00 00 00       	jmp    c0109b2d <do_fork+0x115>
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc)) goto bad_fork_cleanup_kstack;
c0109a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a6e:	89 04 24             	mov    %eax,(%esp)
c0109a71:	e8 ae fd ff ff       	call   c0109824 <copy_mm>
c0109a76:	85 c0                	test   %eax,%eax
c0109a78:	74 11                	je     c0109a8b <do_fork+0x73>
c0109a7a:	90                   	nop
	
fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a7e:	89 04 24             	mov    %eax,(%esp)
c0109a81:	e8 ab fc ff ff       	call   c0109731 <put_kstack>
c0109a86:	e9 a2 00 00 00       	jmp    c0109b2d <do_fork+0x115>
    //    2. call setup_kstack to allocate a kernel stack for child process
    if (setup_kstack(proc)) goto bad_fork_cleanup_proc;
    //    3. call copy_mm to dup OR share mm according clone_flag
    if (copy_mm(clone_flags, proc)) goto bad_fork_cleanup_kstack;
    //    4. call copy_thread to setup tf & context in proc_struct
    copy_thread(proc, stack, tf);
c0109a8b:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a9c:	89 04 24             	mov    %eax,(%esp)
c0109a9f:	e8 9c fe ff ff       	call   c0109940 <copy_thread>
    //    5. insert proc_struct into hash_list && proc_list
    proc->parent = current;
c0109aa4:	8b 15 88 bf 19 c0    	mov    0xc019bf88,%edx
c0109aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109aad:	89 50 14             	mov    %edx,0x14(%eax)
    assert(current->wait_state == 0);
c0109ab0:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109ab5:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109ab8:	85 c0                	test   %eax,%eax
c0109aba:	74 24                	je     c0109ae0 <do_fork+0xc8>
c0109abc:	c7 44 24 0c 54 da 10 	movl   $0xc010da54,0xc(%esp)
c0109ac3:	c0 
c0109ac4:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c0109acb:	c0 
c0109acc:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0109ad3:	00 
c0109ad4:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109adb:	e8 f5 72 ff ff       	call   c0100dd5 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c0109ae0:	e8 bf f4 ff ff       	call   c0108fa4 <__intr_save>
c0109ae5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    proc->pid = get_pid();
c0109ae8:	e8 f0 f8 ff ff       	call   c01093dd <get_pid>
c0109aed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109af0:	89 42 04             	mov    %eax,0x4(%edx)
    hash_proc(proc);
c0109af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109af6:	89 04 24             	mov    %eax,(%esp)
c0109af9:	e8 64 fa ff ff       	call   c0109562 <hash_proc>
    set_links(proc);
c0109afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b01:	89 04 24             	mov    %eax,(%esp)
c0109b04:	e8 ac f7 ff ff       	call   c01092b5 <set_links>
    local_intr_restore(intr_flag);
c0109b09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b0c:	89 04 24             	mov    %eax,(%esp)
c0109b0f:	e8 ba f4 ff ff       	call   c0108fce <__intr_restore>
    //    6. call wakup_proc to make the new child process RUNNABLE
    wakeup_proc(proc);
c0109b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b17:	89 04 24             	mov    %eax,(%esp)
c0109b1a:	e8 fe 0f 00 00       	call   c010ab1d <wakeup_proc>
    //    7. set ret vaule using child proc's pid
    ret = proc->pid;
c0109b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b22:	8b 40 04             	mov    0x4(%eax),%eax
c0109b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */
	
fork_out:
    return ret;
c0109b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b2b:	eb 0d                	jmp    c0109b3a <do_fork+0x122>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0109b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b30:	89 04 24             	mov    %eax,(%esp)
c0109b33:	e8 ee ae ff ff       	call   c0104a26 <kfree>
    goto fork_out;
c0109b38:	eb ee                	jmp    c0109b28 <do_fork+0x110>
}
c0109b3a:	c9                   	leave  
c0109b3b:	c3                   	ret    

c0109b3c <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0109b3c:	55                   	push   %ebp
c0109b3d:	89 e5                	mov    %esp,%ebp
c0109b3f:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c0109b42:	8b 15 88 bf 19 c0    	mov    0xc019bf88,%edx
c0109b48:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c0109b4d:	39 c2                	cmp    %eax,%edx
c0109b4f:	75 1c                	jne    c0109b6d <do_exit+0x31>
        panic("idleproc exit.\n");
c0109b51:	c7 44 24 08 82 da 10 	movl   $0xc010da82,0x8(%esp)
c0109b58:	c0 
c0109b59:	c7 44 24 04 bb 01 00 	movl   $0x1bb,0x4(%esp)
c0109b60:	00 
c0109b61:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109b68:	e8 68 72 ff ff       	call   c0100dd5 <__panic>
    }
    if (current == initproc) {
c0109b6d:	8b 15 88 bf 19 c0    	mov    0xc019bf88,%edx
c0109b73:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109b78:	39 c2                	cmp    %eax,%edx
c0109b7a:	75 1c                	jne    c0109b98 <do_exit+0x5c>
        panic("initproc exit.\n");
c0109b7c:	c7 44 24 08 92 da 10 	movl   $0xc010da92,0x8(%esp)
c0109b83:	c0 
c0109b84:	c7 44 24 04 be 01 00 	movl   $0x1be,0x4(%esp)
c0109b8b:	00 
c0109b8c:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109b93:	e8 3d 72 ff ff       	call   c0100dd5 <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c0109b98:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109b9d:	8b 40 18             	mov    0x18(%eax),%eax
c0109ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c0109ba3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109ba7:	74 4a                	je     c0109bf3 <do_exit+0xb7>
        lcr3(boot_cr3);
c0109ba9:	a1 c8 df 19 c0       	mov    0xc019dfc8,%eax
c0109bae:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bb4:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c0109bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bba:	89 04 24             	mov    %eax,(%esp)
c0109bbd:	e8 c2 f5 ff ff       	call   c0109184 <mm_count_dec>
c0109bc2:	85 c0                	test   %eax,%eax
c0109bc4:	75 21                	jne    c0109be7 <do_exit+0xab>
            exit_mmap(mm);
c0109bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bc9:	89 04 24             	mov    %eax,(%esp)
c0109bcc:	e8 46 e6 ff ff       	call   c0108217 <exit_mmap>
            put_pgdir(mm);
c0109bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bd4:	89 04 24             	mov    %eax,(%esp)
c0109bd7:	e8 22 fc ff ff       	call   c01097fe <put_pgdir>
            mm_destroy(mm);
c0109bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bdf:	89 04 24             	mov    %eax,(%esp)
c0109be2:	e8 71 e3 ff ff       	call   c0107f58 <mm_destroy>
        }
        current->mm = NULL;
c0109be7:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109bec:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c0109bf3:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109bf8:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c0109bfe:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109c03:	8b 55 08             	mov    0x8(%ebp),%edx
c0109c06:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c0109c09:	e8 96 f3 ff ff       	call   c0108fa4 <__intr_save>
c0109c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c0109c11:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109c16:	8b 40 14             	mov    0x14(%eax),%eax
c0109c19:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c0109c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c1f:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109c22:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109c27:	75 10                	jne    c0109c39 <do_exit+0xfd>
            wakeup_proc(proc);
c0109c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c2c:	89 04 24             	mov    %eax,(%esp)
c0109c2f:	e8 e9 0e 00 00       	call   c010ab1d <wakeup_proc>
        }
        while (current->cptr != NULL) {
c0109c34:	e9 8b 00 00 00       	jmp    c0109cc4 <do_exit+0x188>
c0109c39:	e9 86 00 00 00       	jmp    c0109cc4 <do_exit+0x188>
            proc = current->cptr;
c0109c3e:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109c43:	8b 40 70             	mov    0x70(%eax),%eax
c0109c46:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c0109c49:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109c4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c51:	8b 52 78             	mov    0x78(%edx),%edx
c0109c54:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c0109c57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c5a:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c0109c61:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109c66:	8b 50 70             	mov    0x70(%eax),%edx
c0109c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c6c:	89 50 78             	mov    %edx,0x78(%eax)
c0109c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c72:	8b 40 78             	mov    0x78(%eax),%eax
c0109c75:	85 c0                	test   %eax,%eax
c0109c77:	74 0e                	je     c0109c87 <do_exit+0x14b>
                initproc->cptr->yptr = proc;
c0109c79:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109c7e:	8b 40 70             	mov    0x70(%eax),%eax
c0109c81:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c84:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c0109c87:	8b 15 84 bf 19 c0    	mov    0xc019bf84,%edx
c0109c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c90:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c0109c93:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109c98:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c9b:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c0109c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ca1:	8b 00                	mov    (%eax),%eax
c0109ca3:	83 f8 03             	cmp    $0x3,%eax
c0109ca6:	75 1c                	jne    c0109cc4 <do_exit+0x188>
                if (initproc->wait_state == WT_CHILD) {
c0109ca8:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109cad:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109cb0:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c0109cb5:	75 0d                	jne    c0109cc4 <do_exit+0x188>
                    wakeup_proc(initproc);
c0109cb7:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c0109cbc:	89 04 24             	mov    %eax,(%esp)
c0109cbf:	e8 59 0e 00 00       	call   c010ab1d <wakeup_proc>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c0109cc4:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109cc9:	8b 40 70             	mov    0x70(%eax),%eax
c0109ccc:	85 c0                	test   %eax,%eax
c0109cce:	0f 85 6a ff ff ff    	jne    c0109c3e <do_exit+0x102>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c0109cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109cd7:	89 04 24             	mov    %eax,(%esp)
c0109cda:	e8 ef f2 ff ff       	call   c0108fce <__intr_restore>
    
    schedule();
c0109cdf:	e8 bd 0e 00 00       	call   c010aba1 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c0109ce4:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109ce9:	8b 40 04             	mov    0x4(%eax),%eax
c0109cec:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109cf0:	c7 44 24 08 a4 da 10 	movl   $0xc010daa4,0x8(%esp)
c0109cf7:	c0 
c0109cf8:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0109cff:	00 
c0109d00:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109d07:	e8 c9 70 ff ff       	call   c0100dd5 <__panic>

c0109d0c <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c0109d0c:	55                   	push   %ebp
c0109d0d:	89 e5                	mov    %esp,%ebp
c0109d0f:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c0109d12:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c0109d17:	8b 40 18             	mov    0x18(%eax),%eax
c0109d1a:	85 c0                	test   %eax,%eax
c0109d1c:	74 1c                	je     c0109d3a <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c0109d1e:	c7 44 24 08 c4 da 10 	movl   $0xc010dac4,0x8(%esp)
c0109d25:	c0 
c0109d26:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0109d2d:	00 
c0109d2e:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c0109d35:	e8 9b 70 ff ff       	call   c0100dd5 <__panic>
    }

    int ret = -E_NO_MEM;
c0109d3a:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c0109d41:	e8 b9 de ff ff       	call   c0107bff <mm_create>
c0109d46:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109d49:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0109d4d:	75 06                	jne    c0109d55 <load_icode+0x49>
        goto bad_mm;
c0109d4f:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c0109d50:	e9 ef 05 00 00       	jmp    c010a344 <load_icode+0x638>
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c0109d55:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109d58:	89 04 24             	mov    %eax,(%esp)
c0109d5b:	e8 f7 f9 ff ff       	call   c0109757 <setup_pgdir>
c0109d60:	85 c0                	test   %eax,%eax
c0109d62:	74 05                	je     c0109d69 <load_icode+0x5d>
        goto bad_pgdir_cleanup_mm;
c0109d64:	e9 f6 05 00 00       	jmp    c010a35f <load_icode+0x653>
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c0109d69:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d6c:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c0109d6f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d72:	8b 50 1c             	mov    0x1c(%eax),%edx
c0109d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d78:	01 d0                	add    %edx,%eax
c0109d7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c0109d7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d80:	8b 00                	mov    (%eax),%eax
c0109d82:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c0109d87:	74 0c                	je     c0109d95 <load_icode+0x89>
        ret = -E_INVAL_ELF;
c0109d89:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c0109d90:	e9 bf 05 00 00       	jmp    c010a354 <load_icode+0x648>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c0109d95:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0109d98:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0109d9c:	0f b7 c0             	movzwl %ax,%eax
c0109d9f:	c1 e0 05             	shl    $0x5,%eax
c0109da2:	89 c2                	mov    %eax,%edx
c0109da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109da7:	01 d0                	add    %edx,%eax
c0109da9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c0109dac:	e9 13 03 00 00       	jmp    c010a0c4 <load_icode+0x3b8>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c0109db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109db4:	8b 00                	mov    (%eax),%eax
c0109db6:	83 f8 01             	cmp    $0x1,%eax
c0109db9:	74 05                	je     c0109dc0 <load_icode+0xb4>
            continue ;
c0109dbb:	e9 00 03 00 00       	jmp    c010a0c0 <load_icode+0x3b4>
        }
        if (ph->p_filesz > ph->p_memsz) {
c0109dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dc3:	8b 50 10             	mov    0x10(%eax),%edx
c0109dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dc9:	8b 40 14             	mov    0x14(%eax),%eax
c0109dcc:	39 c2                	cmp    %eax,%edx
c0109dce:	76 0c                	jbe    c0109ddc <load_icode+0xd0>
            ret = -E_INVAL_ELF;
c0109dd0:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c0109dd7:	e9 6d 05 00 00       	jmp    c010a349 <load_icode+0x63d>
        }
        if (ph->p_filesz == 0) {
c0109ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ddf:	8b 40 10             	mov    0x10(%eax),%eax
c0109de2:	85 c0                	test   %eax,%eax
c0109de4:	75 05                	jne    c0109deb <load_icode+0xdf>
            continue ;
c0109de6:	e9 d5 02 00 00       	jmp    c010a0c0 <load_icode+0x3b4>
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c0109deb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0109df2:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c0109df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109dfc:	8b 40 18             	mov    0x18(%eax),%eax
c0109dff:	83 e0 01             	and    $0x1,%eax
c0109e02:	85 c0                	test   %eax,%eax
c0109e04:	74 04                	je     c0109e0a <load_icode+0xfe>
c0109e06:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c0109e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e0d:	8b 40 18             	mov    0x18(%eax),%eax
c0109e10:	83 e0 02             	and    $0x2,%eax
c0109e13:	85 c0                	test   %eax,%eax
c0109e15:	74 04                	je     c0109e1b <load_icode+0x10f>
c0109e17:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c0109e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e1e:	8b 40 18             	mov    0x18(%eax),%eax
c0109e21:	83 e0 04             	and    $0x4,%eax
c0109e24:	85 c0                	test   %eax,%eax
c0109e26:	74 04                	je     c0109e2c <load_icode+0x120>
c0109e28:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c0109e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109e2f:	83 e0 02             	and    $0x2,%eax
c0109e32:	85 c0                	test   %eax,%eax
c0109e34:	74 04                	je     c0109e3a <load_icode+0x12e>
c0109e36:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c0109e3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e3d:	8b 50 14             	mov    0x14(%eax),%edx
c0109e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e43:	8b 40 08             	mov    0x8(%eax),%eax
c0109e46:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c0109e4d:	00 
c0109e4e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0109e51:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0109e55:	89 54 24 08          	mov    %edx,0x8(%esp)
c0109e59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109e60:	89 04 24             	mov    %eax,(%esp)
c0109e63:	e8 92 e1 ff ff       	call   c0107ffa <mm_map>
c0109e68:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109e6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109e6f:	74 05                	je     c0109e76 <load_icode+0x16a>
            goto bad_cleanup_mmap;
c0109e71:	e9 d3 04 00 00       	jmp    c010a349 <load_icode+0x63d>
        }
        unsigned char *from = binary + ph->p_offset;
c0109e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e79:	8b 50 04             	mov    0x4(%eax),%edx
c0109e7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e7f:	01 d0                	add    %edx,%eax
c0109e81:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c0109e84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109e87:	8b 40 08             	mov    0x8(%eax),%eax
c0109e8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109e8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109e90:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0109e93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0109e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0109e9b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c0109e9e:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c0109ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ea8:	8b 50 08             	mov    0x8(%eax),%edx
c0109eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109eae:	8b 40 10             	mov    0x10(%eax),%eax
c0109eb1:	01 d0                	add    %edx,%eax
c0109eb3:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c0109eb6:	e9 90 00 00 00       	jmp    c0109f4b <load_icode+0x23f>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c0109ebb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109ebe:	8b 40 0c             	mov    0xc(%eax),%eax
c0109ec1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109ec4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0109ec8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109ecb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109ecf:	89 04 24             	mov    %eax,(%esp)
c0109ed2:	e8 84 be ff ff       	call   c0105d5b <pgdir_alloc_page>
c0109ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109eda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109ede:	75 05                	jne    c0109ee5 <load_icode+0x1d9>
                goto bad_cleanup_mmap;
c0109ee0:	e9 64 04 00 00       	jmp    c010a349 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c0109ee5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109ee8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109eeb:	29 c2                	sub    %eax,%edx
c0109eed:	89 d0                	mov    %edx,%eax
c0109eef:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0109ef2:	b8 00 10 00 00       	mov    $0x1000,%eax
c0109ef7:	2b 45 bc             	sub    -0x44(%ebp),%eax
c0109efa:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0109efd:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c0109f04:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109f07:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f0a:	73 0d                	jae    c0109f19 <load_icode+0x20d>
                size -= la - end;
c0109f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109f0f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0109f12:	29 c2                	sub    %eax,%edx
c0109f14:	89 d0                	mov    %edx,%eax
c0109f16:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c0109f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f1c:	89 04 24             	mov    %eax,(%esp)
c0109f1f:	e8 a8 f1 ff ff       	call   c01090cc <page2kva>
c0109f24:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0109f27:	01 c2                	add    %eax,%edx
c0109f29:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f30:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109f33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f37:	89 14 24             	mov    %edx,(%esp)
c0109f3a:	e8 af 1a 00 00       	call   c010b9ee <memcpy>
            start += size, from += size;
c0109f3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f42:	01 45 d8             	add    %eax,-0x28(%ebp)
c0109f45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f48:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c0109f4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f4e:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109f51:	0f 82 64 ff ff ff    	jb     c0109ebb <load_icode+0x1af>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c0109f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f5a:	8b 50 08             	mov    0x8(%eax),%edx
c0109f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f60:	8b 40 14             	mov    0x14(%eax),%eax
c0109f63:	01 d0                	add    %edx,%eax
c0109f65:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c0109f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f6b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109f6e:	0f 83 b0 00 00 00    	jae    c010a024 <load_icode+0x318>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c0109f74:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109f77:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109f7a:	75 05                	jne    c0109f81 <load_icode+0x275>
                continue ;
c0109f7c:	e9 3f 01 00 00       	jmp    c010a0c0 <load_icode+0x3b4>
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c0109f81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109f84:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109f87:	29 c2                	sub    %eax,%edx
c0109f89:	89 d0                	mov    %edx,%eax
c0109f8b:	05 00 10 00 00       	add    $0x1000,%eax
c0109f90:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0109f93:	b8 00 10 00 00       	mov    $0x1000,%eax
c0109f98:	2b 45 bc             	sub    -0x44(%ebp),%eax
c0109f9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c0109f9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109fa1:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109fa4:	73 0d                	jae    c0109fb3 <load_icode+0x2a7>
                size -= la - end;
c0109fa6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0109fa9:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0109fac:	29 c2                	sub    %eax,%edx
c0109fae:	89 d0                	mov    %edx,%eax
c0109fb0:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c0109fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fb6:	89 04 24             	mov    %eax,(%esp)
c0109fb9:	e8 0e f1 ff ff       	call   c01090cc <page2kva>
c0109fbe:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0109fc1:	01 c2                	add    %eax,%edx
c0109fc3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109fc6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109fca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109fd1:	00 
c0109fd2:	89 14 24             	mov    %edx,(%esp)
c0109fd5:	e8 32 19 00 00       	call   c010b90c <memset>
            start += size;
c0109fda:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109fdd:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c0109fe0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109fe3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109fe6:	73 08                	jae    c0109ff0 <load_icode+0x2e4>
c0109fe8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109feb:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c0109fee:	74 34                	je     c010a024 <load_icode+0x318>
c0109ff0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0109ff3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109ff6:	72 08                	jb     c010a000 <load_icode+0x2f4>
c0109ff8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109ffb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0109ffe:	74 24                	je     c010a024 <load_icode+0x318>
c010a000:	c7 44 24 0c ec da 10 	movl   $0xc010daec,0xc(%esp)
c010a007:	c0 
c010a008:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a00f:	c0 
c010a010:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010a017:	00 
c010a018:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a01f:	e8 b1 6d ff ff       	call   c0100dd5 <__panic>
        }
        while (start < end) {
c010a024:	e9 8b 00 00 00       	jmp    c010a0b4 <load_icode+0x3a8>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a029:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a02c:	8b 40 0c             	mov    0xc(%eax),%eax
c010a02f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a032:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a036:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a039:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a03d:	89 04 24             	mov    %eax,(%esp)
c010a040:	e8 16 bd ff ff       	call   c0105d5b <pgdir_alloc_page>
c010a045:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a048:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a04c:	75 05                	jne    c010a053 <load_icode+0x347>
                goto bad_cleanup_mmap;
c010a04e:	e9 f6 02 00 00       	jmp    c010a349 <load_icode+0x63d>
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a053:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a056:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a059:	29 c2                	sub    %eax,%edx
c010a05b:	89 d0                	mov    %edx,%eax
c010a05d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a060:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a065:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a068:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a06b:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a072:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a075:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a078:	73 0d                	jae    c010a087 <load_icode+0x37b>
                size -= la - end;
c010a07a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a07d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a080:	29 c2                	sub    %eax,%edx
c010a082:	89 d0                	mov    %edx,%eax
c010a084:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a087:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a08a:	89 04 24             	mov    %eax,(%esp)
c010a08d:	e8 3a f0 ff ff       	call   c01090cc <page2kva>
c010a092:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010a095:	01 c2                	add    %eax,%edx
c010a097:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a09a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a09e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a0a5:	00 
c010a0a6:	89 14 24             	mov    %edx,(%esp)
c010a0a9:	e8 5e 18 00 00       	call   c010b90c <memset>
            start += size;
c010a0ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a0b1:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a0b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a0b7:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a0ba:	0f 82 69 ff ff ff    	jb     c010a029 <load_icode+0x31d>
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a0c0:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a0c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0c7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a0ca:	0f 82 e1 fc ff ff    	jb     c0109db1 <load_icode+0xa5>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a0d0:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a0d7:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a0de:	00 
c010a0df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a0e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a0e6:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a0ed:	00 
c010a0ee:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a0f5:	af 
c010a0f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a0f9:	89 04 24             	mov    %eax,(%esp)
c010a0fc:	e8 f9 de ff ff       	call   c0107ffa <mm_map>
c010a101:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a108:	74 05                	je     c010a10f <load_icode+0x403>
        goto bad_cleanup_mmap;
c010a10a:	e9 3a 02 00 00       	jmp    c010a349 <load_icode+0x63d>
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a10f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a112:	8b 40 0c             	mov    0xc(%eax),%eax
c010a115:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a11c:	00 
c010a11d:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a124:	af 
c010a125:	89 04 24             	mov    %eax,(%esp)
c010a128:	e8 2e bc ff ff       	call   c0105d5b <pgdir_alloc_page>
c010a12d:	85 c0                	test   %eax,%eax
c010a12f:	75 24                	jne    c010a155 <load_icode+0x449>
c010a131:	c7 44 24 0c 28 db 10 	movl   $0xc010db28,0xc(%esp)
c010a138:	c0 
c010a139:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a140:	c0 
c010a141:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c010a148:	00 
c010a149:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a150:	e8 80 6c ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a155:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a158:	8b 40 0c             	mov    0xc(%eax),%eax
c010a15b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a162:	00 
c010a163:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a16a:	af 
c010a16b:	89 04 24             	mov    %eax,(%esp)
c010a16e:	e8 e8 bb ff ff       	call   c0105d5b <pgdir_alloc_page>
c010a173:	85 c0                	test   %eax,%eax
c010a175:	75 24                	jne    c010a19b <load_icode+0x48f>
c010a177:	c7 44 24 0c 6c db 10 	movl   $0xc010db6c,0xc(%esp)
c010a17e:	c0 
c010a17f:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a186:	c0 
c010a187:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c010a18e:	00 
c010a18f:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a196:	e8 3a 6c ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a19b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a19e:	8b 40 0c             	mov    0xc(%eax),%eax
c010a1a1:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a1a8:	00 
c010a1a9:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a1b0:	af 
c010a1b1:	89 04 24             	mov    %eax,(%esp)
c010a1b4:	e8 a2 bb ff ff       	call   c0105d5b <pgdir_alloc_page>
c010a1b9:	85 c0                	test   %eax,%eax
c010a1bb:	75 24                	jne    c010a1e1 <load_icode+0x4d5>
c010a1bd:	c7 44 24 0c b0 db 10 	movl   $0xc010dbb0,0xc(%esp)
c010a1c4:	c0 
c010a1c5:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a1cc:	c0 
c010a1cd:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c010a1d4:	00 
c010a1d5:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a1dc:	e8 f4 6b ff ff       	call   c0100dd5 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a1e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a1e4:	8b 40 0c             	mov    0xc(%eax),%eax
c010a1e7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a1ee:	00 
c010a1ef:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a1f6:	af 
c010a1f7:	89 04 24             	mov    %eax,(%esp)
c010a1fa:	e8 5c bb ff ff       	call   c0105d5b <pgdir_alloc_page>
c010a1ff:	85 c0                	test   %eax,%eax
c010a201:	75 24                	jne    c010a227 <load_icode+0x51b>
c010a203:	c7 44 24 0c f4 db 10 	movl   $0xc010dbf4,0xc(%esp)
c010a20a:	c0 
c010a20b:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a212:	c0 
c010a213:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c010a21a:	00 
c010a21b:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a222:	e8 ae 6b ff ff       	call   c0100dd5 <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a227:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a22a:	89 04 24             	mov    %eax,(%esp)
c010a22d:	e8 38 ef ff ff       	call   c010916a <mm_count_inc>
    current->mm = mm;
c010a232:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a237:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a23a:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a23d:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a242:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a245:	8b 52 0c             	mov    0xc(%edx),%edx
c010a248:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a24b:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a252:	77 23                	ja     c010a277 <load_icode+0x56b>
c010a254:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a257:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a25b:	c7 44 24 08 1c da 10 	movl   $0xc010da1c,0x8(%esp)
c010a262:	c0 
c010a263:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c010a26a:	00 
c010a26b:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a272:	e8 5e 6b ff ff       	call   c0100dd5 <__panic>
c010a277:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a27a:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a280:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a283:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a286:	8b 40 0c             	mov    0xc(%eax),%eax
c010a289:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a28c:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a293:	77 23                	ja     c010a2b8 <load_icode+0x5ac>
c010a295:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a298:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a29c:	c7 44 24 08 1c da 10 	movl   $0xc010da1c,0x8(%esp)
c010a2a3:	c0 
c010a2a4:	c7 44 24 04 62 02 00 	movl   $0x262,0x4(%esp)
c010a2ab:	00 
c010a2ac:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a2b3:	e8 1d 6b ff ff       	call   c0100dd5 <__panic>
c010a2b8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a2bb:	05 00 00 00 40       	add    $0x40000000,%eax
c010a2c0:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a2c3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a2c6:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a2c9:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a2ce:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a2d1:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a2d4:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a2db:	00 
c010a2dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a2e3:	00 
c010a2e4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2e7:	89 04 24             	mov    %eax,(%esp)
c010a2ea:	e8 1d 16 00 00       	call   c010b90c <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a2ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2f2:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a2f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a2fb:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a301:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a304:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a308:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a30b:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a30f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a312:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a316:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a319:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a31d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a320:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a327:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a32a:	8b 50 18             	mov    0x18(%eax),%edx
c010a32d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a330:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a333:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a336:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    ret = 0;
c010a33d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a344:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a347:	eb 23                	jmp    c010a36c <load_icode+0x660>
bad_cleanup_mmap:
    exit_mmap(mm);
c010a349:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a34c:	89 04 24             	mov    %eax,(%esp)
c010a34f:	e8 c3 de ff ff       	call   c0108217 <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a354:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a357:	89 04 24             	mov    %eax,(%esp)
c010a35a:	e8 9f f4 ff ff       	call   c01097fe <put_pgdir>
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a35f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a362:	89 04 24             	mov    %eax,(%esp)
c010a365:	e8 ee db ff ff       	call   c0107f58 <mm_destroy>
bad_mm:
    goto out;
c010a36a:	eb d8                	jmp    c010a344 <load_icode+0x638>
}
c010a36c:	c9                   	leave  
c010a36d:	c3                   	ret    

c010a36e <do_execve>:

// do_execve - call exit_mmap(mm)&pug_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a36e:	55                   	push   %ebp
c010a36f:	89 e5                	mov    %esp,%ebp
c010a371:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a374:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a379:	8b 40 18             	mov    0x18(%eax),%eax
c010a37c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a37f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a382:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a389:	00 
c010a38a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a38d:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a391:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a395:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a398:	89 04 24             	mov    %eax,(%esp)
c010a39b:	e8 ee e8 ff ff       	call   c0108c8e <user_mem_check>
c010a3a0:	85 c0                	test   %eax,%eax
c010a3a2:	75 0a                	jne    c010a3ae <do_execve+0x40>
        return -E_INVAL;
c010a3a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a3a9:	e9 f4 00 00 00       	jmp    c010a4a2 <do_execve+0x134>
    }
    if (len > PROC_NAME_LEN) {
c010a3ae:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a3b2:	76 07                	jbe    c010a3bb <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a3b4:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a3bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a3c2:	00 
c010a3c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a3ca:	00 
c010a3cb:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a3ce:	89 04 24             	mov    %eax,(%esp)
c010a3d1:	e8 36 15 00 00       	call   c010b90c <memset>
    memcpy(local_name, name, len);
c010a3d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a3d9:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a3dd:	8b 45 08             	mov    0x8(%ebp),%eax
c010a3e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a3e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a3e7:	89 04 24             	mov    %eax,(%esp)
c010a3ea:	e8 ff 15 00 00       	call   c010b9ee <memcpy>

    if (mm != NULL) {
c010a3ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a3f3:	74 4a                	je     c010a43f <do_execve+0xd1>
        lcr3(boot_cr3);
c010a3f5:	a1 c8 df 19 c0       	mov    0xc019dfc8,%eax
c010a3fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a400:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a403:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a406:	89 04 24             	mov    %eax,(%esp)
c010a409:	e8 76 ed ff ff       	call   c0109184 <mm_count_dec>
c010a40e:	85 c0                	test   %eax,%eax
c010a410:	75 21                	jne    c010a433 <do_execve+0xc5>
            exit_mmap(mm);
c010a412:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a415:	89 04 24             	mov    %eax,(%esp)
c010a418:	e8 fa dd ff ff       	call   c0108217 <exit_mmap>
            put_pgdir(mm);
c010a41d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a420:	89 04 24             	mov    %eax,(%esp)
c010a423:	e8 d6 f3 ff ff       	call   c01097fe <put_pgdir>
            mm_destroy(mm);
c010a428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a42b:	89 04 24             	mov    %eax,(%esp)
c010a42e:	e8 25 db ff ff       	call   c0107f58 <mm_destroy>
        }
        current->mm = NULL;
c010a433:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a438:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a43f:	8b 45 14             	mov    0x14(%ebp),%eax
c010a442:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a446:	8b 45 10             	mov    0x10(%ebp),%eax
c010a449:	89 04 24             	mov    %eax,(%esp)
c010a44c:	e8 bb f8 ff ff       	call   c0109d0c <load_icode>
c010a451:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a454:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a458:	74 2f                	je     c010a489 <do_execve+0x11b>
        goto execve_exit;
c010a45a:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a45b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a45e:	89 04 24             	mov    %eax,(%esp)
c010a461:	e8 d6 f6 ff ff       	call   c0109b3c <do_exit>
    panic("already exit: %e.\n", ret);
c010a466:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a469:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a46d:	c7 44 24 08 37 dc 10 	movl   $0xc010dc37,0x8(%esp)
c010a474:	c0 
c010a475:	c7 44 24 04 a4 02 00 	movl   $0x2a4,0x4(%esp)
c010a47c:	00 
c010a47d:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a484:	e8 4c 69 ff ff       	call   c0100dd5 <__panic>
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a489:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a48e:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a491:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a495:	89 04 24             	mov    %eax,(%esp)
c010a498:	e8 93 ed ff ff       	call   c0109230 <set_proc_name>
    return 0;
c010a49d:	b8 00 00 00 00       	mov    $0x0,%eax

execve_exit:
    do_exit(ret);
    panic("already exit: %e.\n", ret);
}
c010a4a2:	c9                   	leave  
c010a4a3:	c3                   	ret    

c010a4a4 <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a4a4:	55                   	push   %ebp
c010a4a5:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a4a7:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a4ac:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a4b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a4b8:	5d                   	pop    %ebp
c010a4b9:	c3                   	ret    

c010a4ba <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a4ba:	55                   	push   %ebp
c010a4bb:	89 e5                	mov    %esp,%ebp
c010a4bd:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a4c0:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a4c5:	8b 40 18             	mov    0x18(%eax),%eax
c010a4c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a4cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a4cf:	74 30                	je     c010a501 <do_wait+0x47>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a4d4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a4db:	00 
c010a4dc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a4e3:	00 
c010a4e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a4e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a4eb:	89 04 24             	mov    %eax,(%esp)
c010a4ee:	e8 9b e7 ff ff       	call   c0108c8e <user_mem_check>
c010a4f3:	85 c0                	test   %eax,%eax
c010a4f5:	75 0a                	jne    c010a501 <do_wait+0x47>
            return -E_INVAL;
c010a4f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a4fc:	e9 4b 01 00 00       	jmp    c010a64c <do_wait+0x192>
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a501:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a50c:	74 39                	je     c010a547 <do_wait+0x8d>
        proc = find_proc(pid);
c010a50e:	8b 45 08             	mov    0x8(%ebp),%eax
c010a511:	89 04 24             	mov    %eax,(%esp)
c010a514:	e8 f8 f0 ff ff       	call   c0109611 <find_proc>
c010a519:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010a51c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a520:	74 54                	je     c010a576 <do_wait+0xbc>
c010a522:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a525:	8b 50 14             	mov    0x14(%eax),%edx
c010a528:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a52d:	39 c2                	cmp    %eax,%edx
c010a52f:	75 45                	jne    c010a576 <do_wait+0xbc>
            haskid = 1;
c010a531:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a538:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a53b:	8b 00                	mov    (%eax),%eax
c010a53d:	83 f8 03             	cmp    $0x3,%eax
c010a540:	75 34                	jne    c010a576 <do_wait+0xbc>
                goto found;
c010a542:	e9 80 00 00 00       	jmp    c010a5c7 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
c010a547:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a54c:	8b 40 70             	mov    0x70(%eax),%eax
c010a54f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010a552:	eb 1c                	jmp    c010a570 <do_wait+0xb6>
            haskid = 1;
c010a554:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010a55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a55e:	8b 00                	mov    (%eax),%eax
c010a560:	83 f8 03             	cmp    $0x3,%eax
c010a563:	75 02                	jne    c010a567 <do_wait+0xad>
                goto found;
c010a565:	eb 60                	jmp    c010a5c7 <do_wait+0x10d>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010a567:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a56a:	8b 40 78             	mov    0x78(%eax),%eax
c010a56d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a574:	75 de                	jne    c010a554 <do_wait+0x9a>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010a576:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a57a:	74 41                	je     c010a5bd <do_wait+0x103>
        current->state = PROC_SLEEPING;
c010a57c:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a581:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010a587:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a58c:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010a593:	e8 09 06 00 00       	call   c010aba1 <schedule>
        if (current->flags & PF_EXITING) {
c010a598:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a59d:	8b 40 44             	mov    0x44(%eax),%eax
c010a5a0:	83 e0 01             	and    $0x1,%eax
c010a5a3:	85 c0                	test   %eax,%eax
c010a5a5:	74 11                	je     c010a5b8 <do_wait+0xfe>
            do_exit(-E_KILLED);
c010a5a7:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010a5ae:	e8 89 f5 ff ff       	call   c0109b3c <do_exit>
        }
        goto repeat;
c010a5b3:	e9 49 ff ff ff       	jmp    c010a501 <do_wait+0x47>
c010a5b8:	e9 44 ff ff ff       	jmp    c010a501 <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010a5bd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010a5c2:	e9 85 00 00 00       	jmp    c010a64c <do_wait+0x192>

found:
    if (proc == idleproc || proc == initproc) {
c010a5c7:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a5cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a5cf:	74 0a                	je     c010a5db <do_wait+0x121>
c010a5d1:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010a5d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010a5d9:	75 1c                	jne    c010a5f7 <do_wait+0x13d>
        panic("wait idleproc or initproc.\n");
c010a5db:	c7 44 24 08 4a dc 10 	movl   $0xc010dc4a,0x8(%esp)
c010a5e2:	c0 
c010a5e3:	c7 44 24 04 dd 02 00 	movl   $0x2dd,0x4(%esp)
c010a5ea:	00 
c010a5eb:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a5f2:	e8 de 67 ff ff       	call   c0100dd5 <__panic>
    }
    if (code_store != NULL) {
c010a5f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a5fb:	74 0b                	je     c010a608 <do_wait+0x14e>
        *code_store = proc->exit_code;
c010a5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a600:	8b 50 68             	mov    0x68(%eax),%edx
c010a603:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a606:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010a608:	e8 97 e9 ff ff       	call   c0108fa4 <__intr_save>
c010a60d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010a610:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a613:	89 04 24             	mov    %eax,(%esp)
c010a616:	e8 c3 ef ff ff       	call   c01095de <unhash_proc>
        remove_links(proc);
c010a61b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a61e:	89 04 24             	mov    %eax,(%esp)
c010a621:	e8 34 ed ff ff       	call   c010935a <remove_links>
    }
    local_intr_restore(intr_flag);
c010a626:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a629:	89 04 24             	mov    %eax,(%esp)
c010a62c:	e8 9d e9 ff ff       	call   c0108fce <__intr_restore>
    put_kstack(proc);
c010a631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a634:	89 04 24             	mov    %eax,(%esp)
c010a637:	e8 f5 f0 ff ff       	call   c0109731 <put_kstack>
    kfree(proc);
c010a63c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a63f:	89 04 24             	mov    %eax,(%esp)
c010a642:	e8 df a3 ff ff       	call   c0104a26 <kfree>
    return 0;
c010a647:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a64c:	c9                   	leave  
c010a64d:	c3                   	ret    

c010a64e <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010a64e:	55                   	push   %ebp
c010a64f:	89 e5                	mov    %esp,%ebp
c010a651:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010a654:	8b 45 08             	mov    0x8(%ebp),%eax
c010a657:	89 04 24             	mov    %eax,(%esp)
c010a65a:	e8 b2 ef ff ff       	call   c0109611 <find_proc>
c010a65f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a666:	74 41                	je     c010a6a9 <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010a668:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a66b:	8b 40 44             	mov    0x44(%eax),%eax
c010a66e:	83 e0 01             	and    $0x1,%eax
c010a671:	85 c0                	test   %eax,%eax
c010a673:	75 2d                	jne    c010a6a2 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010a675:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a678:	8b 40 44             	mov    0x44(%eax),%eax
c010a67b:	83 c8 01             	or     $0x1,%eax
c010a67e:	89 c2                	mov    %eax,%edx
c010a680:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a683:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010a686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a689:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a68c:	85 c0                	test   %eax,%eax
c010a68e:	79 0b                	jns    c010a69b <do_kill+0x4d>
                wakeup_proc(proc);
c010a690:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a693:	89 04 24             	mov    %eax,(%esp)
c010a696:	e8 82 04 00 00       	call   c010ab1d <wakeup_proc>
            }
            return 0;
c010a69b:	b8 00 00 00 00       	mov    $0x0,%eax
c010a6a0:	eb 0c                	jmp    c010a6ae <do_kill+0x60>
        }
        return -E_KILLED;
c010a6a2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010a6a7:	eb 05                	jmp    c010a6ae <do_kill+0x60>
    }
    return -E_INVAL;
c010a6a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010a6ae:	c9                   	leave  
c010a6af:	c3                   	ret    

c010a6b0 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010a6b0:	55                   	push   %ebp
c010a6b1:	89 e5                	mov    %esp,%ebp
c010a6b3:	57                   	push   %edi
c010a6b4:	56                   	push   %esi
c010a6b5:	53                   	push   %ebx
c010a6b6:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010a6b9:	8b 45 08             	mov    0x8(%ebp),%eax
c010a6bc:	89 04 24             	mov    %eax,(%esp)
c010a6bf:	e8 19 0f 00 00       	call   c010b5dd <strlen>
c010a6c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010a6c7:	b8 04 00 00 00       	mov    $0x4,%eax
c010a6cc:	8b 55 08             	mov    0x8(%ebp),%edx
c010a6cf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010a6d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010a6d5:	8b 75 10             	mov    0x10(%ebp),%esi
c010a6d8:	89 f7                	mov    %esi,%edi
c010a6da:	cd 80                	int    $0x80
c010a6dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010a6df:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010a6e2:	83 c4 2c             	add    $0x2c,%esp
c010a6e5:	5b                   	pop    %ebx
c010a6e6:	5e                   	pop    %esi
c010a6e7:	5f                   	pop    %edi
c010a6e8:	5d                   	pop    %ebp
c010a6e9:	c3                   	ret    

c010a6ea <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010a6ea:	55                   	push   %ebp
c010a6eb:	89 e5                	mov    %esp,%ebp
c010a6ed:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010a6f0:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010a6f5:	8b 40 04             	mov    0x4(%eax),%eax
c010a6f8:	c7 44 24 08 66 dc 10 	movl   $0xc010dc66,0x8(%esp)
c010a6ff:	c0 
c010a700:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a704:	c7 04 24 70 dc 10 c0 	movl   $0xc010dc70,(%esp)
c010a70b:	e8 43 5c ff ff       	call   c0100353 <cprintf>
c010a710:	b8 e2 78 00 00       	mov    $0x78e2,%eax
c010a715:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a719:	c7 44 24 04 79 e8 15 	movl   $0xc015e879,0x4(%esp)
c010a720:	c0 
c010a721:	c7 04 24 66 dc 10 c0 	movl   $0xc010dc66,(%esp)
c010a728:	e8 83 ff ff ff       	call   c010a6b0 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010a72d:	c7 44 24 08 97 dc 10 	movl   $0xc010dc97,0x8(%esp)
c010a734:	c0 
c010a735:	c7 44 24 04 26 03 00 	movl   $0x326,0x4(%esp)
c010a73c:	00 
c010a73d:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a744:	e8 8c 66 ff ff       	call   c0100dd5 <__panic>

c010a749 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010a749:	55                   	push   %ebp
c010a74a:	89 e5                	mov    %esp,%ebp
c010a74c:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010a74f:	e8 c9 a7 ff ff       	call   c0104f1d <nr_free_pages>
c010a754:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010a757:	e8 92 a1 ff ff       	call   c01048ee <kallocated>
c010a75c:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010a75f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010a766:	00 
c010a767:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a76e:	00 
c010a76f:	c7 04 24 ea a6 10 c0 	movl   $0xc010a6ea,(%esp)
c010a776:	e8 08 ef ff ff       	call   c0109683 <kernel_thread>
c010a77b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010a77e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010a782:	7f 1c                	jg     c010a7a0 <init_main+0x57>
        panic("create user_main failed.\n");
c010a784:	c7 44 24 08 b1 dc 10 	movl   $0xc010dcb1,0x8(%esp)
c010a78b:	c0 
c010a78c:	c7 44 24 04 31 03 00 	movl   $0x331,0x4(%esp)
c010a793:	00 
c010a794:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a79b:	e8 35 66 ff ff       	call   c0100dd5 <__panic>
    }

    while (do_wait(0, NULL) == 0) {
c010a7a0:	eb 05                	jmp    c010a7a7 <init_main+0x5e>
        schedule();
c010a7a2:	e8 fa 03 00 00       	call   c010aba1 <schedule>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010a7a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a7ae:	00 
c010a7af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010a7b6:	e8 ff fc ff ff       	call   c010a4ba <do_wait>
c010a7bb:	85 c0                	test   %eax,%eax
c010a7bd:	74 e3                	je     c010a7a2 <init_main+0x59>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010a7bf:	c7 04 24 cc dc 10 c0 	movl   $0xc010dccc,(%esp)
c010a7c6:	e8 88 5b ff ff       	call   c0100353 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010a7cb:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010a7d0:	8b 40 70             	mov    0x70(%eax),%eax
c010a7d3:	85 c0                	test   %eax,%eax
c010a7d5:	75 18                	jne    c010a7ef <init_main+0xa6>
c010a7d7:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010a7dc:	8b 40 74             	mov    0x74(%eax),%eax
c010a7df:	85 c0                	test   %eax,%eax
c010a7e1:	75 0c                	jne    c010a7ef <init_main+0xa6>
c010a7e3:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010a7e8:	8b 40 78             	mov    0x78(%eax),%eax
c010a7eb:	85 c0                	test   %eax,%eax
c010a7ed:	74 24                	je     c010a813 <init_main+0xca>
c010a7ef:	c7 44 24 0c f0 dc 10 	movl   $0xc010dcf0,0xc(%esp)
c010a7f6:	c0 
c010a7f7:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a7fe:	c0 
c010a7ff:	c7 44 24 04 39 03 00 	movl   $0x339,0x4(%esp)
c010a806:	00 
c010a807:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a80e:	e8 c2 65 ff ff       	call   c0100dd5 <__panic>
    assert(nr_process == 2);
c010a813:	a1 a0 df 19 c0       	mov    0xc019dfa0,%eax
c010a818:	83 f8 02             	cmp    $0x2,%eax
c010a81b:	74 24                	je     c010a841 <init_main+0xf8>
c010a81d:	c7 44 24 0c 3b dd 10 	movl   $0xc010dd3b,0xc(%esp)
c010a824:	c0 
c010a825:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a82c:	c0 
c010a82d:	c7 44 24 04 3a 03 00 	movl   $0x33a,0x4(%esp)
c010a834:	00 
c010a835:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a83c:	e8 94 65 ff ff       	call   c0100dd5 <__panic>
c010a841:	c7 45 e8 b0 e0 19 c0 	movl   $0xc019e0b0,-0x18(%ebp)
c010a848:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a84b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010a84e:	8b 15 84 bf 19 c0    	mov    0xc019bf84,%edx
c010a854:	83 c2 58             	add    $0x58,%edx
c010a857:	39 d0                	cmp    %edx,%eax
c010a859:	74 24                	je     c010a87f <init_main+0x136>
c010a85b:	c7 44 24 0c 4c dd 10 	movl   $0xc010dd4c,0xc(%esp)
c010a862:	c0 
c010a863:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a86a:	c0 
c010a86b:	c7 44 24 04 3b 03 00 	movl   $0x33b,0x4(%esp)
c010a872:	00 
c010a873:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a87a:	e8 56 65 ff ff       	call   c0100dd5 <__panic>
c010a87f:	c7 45 e4 b0 e0 19 c0 	movl   $0xc019e0b0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010a886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010a889:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010a88b:	8b 15 84 bf 19 c0    	mov    0xc019bf84,%edx
c010a891:	83 c2 58             	add    $0x58,%edx
c010a894:	39 d0                	cmp    %edx,%eax
c010a896:	74 24                	je     c010a8bc <init_main+0x173>
c010a898:	c7 44 24 0c 7c dd 10 	movl   $0xc010dd7c,0xc(%esp)
c010a89f:	c0 
c010a8a0:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010a8a7:	c0 
c010a8a8:	c7 44 24 04 3c 03 00 	movl   $0x33c,0x4(%esp)
c010a8af:	00 
c010a8b0:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a8b7:	e8 19 65 ff ff       	call   c0100dd5 <__panic>

    cprintf("init check memory pass.\n");
c010a8bc:	c7 04 24 ac dd 10 c0 	movl   $0xc010ddac,(%esp)
c010a8c3:	e8 8b 5a ff ff       	call   c0100353 <cprintf>
    return 0;
c010a8c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a8cd:	c9                   	leave  
c010a8ce:	c3                   	ret    

c010a8cf <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010a8cf:	55                   	push   %ebp
c010a8d0:	89 e5                	mov    %esp,%ebp
c010a8d2:	83 ec 28             	sub    $0x28,%esp
c010a8d5:	c7 45 ec b0 e0 19 c0 	movl   $0xc019e0b0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010a8dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a8df:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a8e2:	89 50 04             	mov    %edx,0x4(%eax)
c010a8e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a8e8:	8b 50 04             	mov    0x4(%eax),%edx
c010a8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a8ee:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010a8f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010a8f7:	eb 26                	jmp    c010a91f <proc_init+0x50>
        list_init(hash_list + i);
c010a8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8fc:	c1 e0 03             	shl    $0x3,%eax
c010a8ff:	05 a0 bf 19 c0       	add    $0xc019bfa0,%eax
c010a904:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010a907:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a90a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010a90d:	89 50 04             	mov    %edx,0x4(%eax)
c010a910:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a913:	8b 50 04             	mov    0x4(%eax),%edx
c010a916:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a919:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010a91b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010a91f:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010a926:	7e d1                	jle    c010a8f9 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010a928:	e8 a9 e8 ff ff       	call   c01091d6 <alloc_proc>
c010a92d:	a3 80 bf 19 c0       	mov    %eax,0xc019bf80
c010a932:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a937:	85 c0                	test   %eax,%eax
c010a939:	75 1c                	jne    c010a957 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010a93b:	c7 44 24 08 c5 dd 10 	movl   $0xc010ddc5,0x8(%esp)
c010a942:	c0 
c010a943:	c7 44 24 04 4e 03 00 	movl   $0x34e,0x4(%esp)
c010a94a:	00 
c010a94b:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a952:	e8 7e 64 ff ff       	call   c0100dd5 <__panic>
    }

    idleproc->pid = 0;
c010a957:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a95c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010a963:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a968:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010a96e:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a973:	ba 00 70 12 c0       	mov    $0xc0127000,%edx
c010a978:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010a97b:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a980:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010a987:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a98c:	c7 44 24 04 dd dd 10 	movl   $0xc010dddd,0x4(%esp)
c010a993:	c0 
c010a994:	89 04 24             	mov    %eax,(%esp)
c010a997:	e8 94 e8 ff ff       	call   c0109230 <set_proc_name>
    nr_process ++;
c010a99c:	a1 a0 df 19 c0       	mov    0xc019dfa0,%eax
c010a9a1:	83 c0 01             	add    $0x1,%eax
c010a9a4:	a3 a0 df 19 c0       	mov    %eax,0xc019dfa0

    current = idleproc;
c010a9a9:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010a9ae:	a3 88 bf 19 c0       	mov    %eax,0xc019bf88

    int pid = kernel_thread(init_main, NULL, 0);
c010a9b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010a9ba:	00 
c010a9bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a9c2:	00 
c010a9c3:	c7 04 24 49 a7 10 c0 	movl   $0xc010a749,(%esp)
c010a9ca:	e8 b4 ec ff ff       	call   c0109683 <kernel_thread>
c010a9cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010a9d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a9d6:	7f 1c                	jg     c010a9f4 <proc_init+0x125>
        panic("create init_main failed.\n");
c010a9d8:	c7 44 24 08 e2 dd 10 	movl   $0xc010dde2,0x8(%esp)
c010a9df:	c0 
c010a9e0:	c7 44 24 04 5c 03 00 	movl   $0x35c,0x4(%esp)
c010a9e7:	00 
c010a9e8:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010a9ef:	e8 e1 63 ff ff       	call   c0100dd5 <__panic>
    }

    initproc = find_proc(pid);
c010a9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a9f7:	89 04 24             	mov    %eax,(%esp)
c010a9fa:	e8 12 ec ff ff       	call   c0109611 <find_proc>
c010a9ff:	a3 84 bf 19 c0       	mov    %eax,0xc019bf84
    set_proc_name(initproc, "init");
c010aa04:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010aa09:	c7 44 24 04 fc dd 10 	movl   $0xc010ddfc,0x4(%esp)
c010aa10:	c0 
c010aa11:	89 04 24             	mov    %eax,(%esp)
c010aa14:	e8 17 e8 ff ff       	call   c0109230 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010aa19:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010aa1e:	85 c0                	test   %eax,%eax
c010aa20:	74 0c                	je     c010aa2e <proc_init+0x15f>
c010aa22:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010aa27:	8b 40 04             	mov    0x4(%eax),%eax
c010aa2a:	85 c0                	test   %eax,%eax
c010aa2c:	74 24                	je     c010aa52 <proc_init+0x183>
c010aa2e:	c7 44 24 0c 04 de 10 	movl   $0xc010de04,0xc(%esp)
c010aa35:	c0 
c010aa36:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010aa3d:	c0 
c010aa3e:	c7 44 24 04 62 03 00 	movl   $0x362,0x4(%esp)
c010aa45:	00 
c010aa46:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010aa4d:	e8 83 63 ff ff       	call   c0100dd5 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010aa52:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010aa57:	85 c0                	test   %eax,%eax
c010aa59:	74 0d                	je     c010aa68 <proc_init+0x199>
c010aa5b:	a1 84 bf 19 c0       	mov    0xc019bf84,%eax
c010aa60:	8b 40 04             	mov    0x4(%eax),%eax
c010aa63:	83 f8 01             	cmp    $0x1,%eax
c010aa66:	74 24                	je     c010aa8c <proc_init+0x1bd>
c010aa68:	c7 44 24 0c 2c de 10 	movl   $0xc010de2c,0xc(%esp)
c010aa6f:	c0 
c010aa70:	c7 44 24 08 6d da 10 	movl   $0xc010da6d,0x8(%esp)
c010aa77:	c0 
c010aa78:	c7 44 24 04 63 03 00 	movl   $0x363,0x4(%esp)
c010aa7f:	00 
c010aa80:	c7 04 24 40 da 10 c0 	movl   $0xc010da40,(%esp)
c010aa87:	e8 49 63 ff ff       	call   c0100dd5 <__panic>
}
c010aa8c:	c9                   	leave  
c010aa8d:	c3                   	ret    

c010aa8e <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010aa8e:	55                   	push   %ebp
c010aa8f:	89 e5                	mov    %esp,%ebp
c010aa91:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c010aa94:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010aa99:	8b 40 10             	mov    0x10(%eax),%eax
c010aa9c:	85 c0                	test   %eax,%eax
c010aa9e:	74 07                	je     c010aaa7 <cpu_idle+0x19>
            schedule();
c010aaa0:	e8 fc 00 00 00       	call   c010aba1 <schedule>
        }
    }
c010aaa5:	eb ed                	jmp    c010aa94 <cpu_idle+0x6>
c010aaa7:	eb eb                	jmp    c010aa94 <cpu_idle+0x6>

c010aaa9 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010aaa9:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010aaad:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010aaaf:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010aab2:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010aab5:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010aab8:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010aabb:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010aabe:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010aac1:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010aac4:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010aac8:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010aacb:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010aace:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010aad1:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010aad4:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010aad7:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010aada:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010aadd:	ff 30                	pushl  (%eax)

    ret
c010aadf:	c3                   	ret    

c010aae0 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010aae0:	55                   	push   %ebp
c010aae1:	89 e5                	mov    %esp,%ebp
c010aae3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010aae6:	9c                   	pushf  
c010aae7:	58                   	pop    %eax
c010aae8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c010aaeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010aaee:	25 00 02 00 00       	and    $0x200,%eax
c010aaf3:	85 c0                	test   %eax,%eax
c010aaf5:	74 0c                	je     c010ab03 <__intr_save+0x23>
        intr_disable();
c010aaf7:	e8 31 75 ff ff       	call   c010202d <intr_disable>
        return 1;
c010aafc:	b8 01 00 00 00       	mov    $0x1,%eax
c010ab01:	eb 05                	jmp    c010ab08 <__intr_save+0x28>
    }
    return 0;
c010ab03:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ab08:	c9                   	leave  
c010ab09:	c3                   	ret    

c010ab0a <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010ab0a:	55                   	push   %ebp
c010ab0b:	89 e5                	mov    %esp,%ebp
c010ab0d:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010ab10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010ab14:	74 05                	je     c010ab1b <__intr_restore+0x11>
        intr_enable();
c010ab16:	e8 0c 75 ff ff       	call   c0102027 <intr_enable>
    }
}
c010ab1b:	c9                   	leave  
c010ab1c:	c3                   	ret    

c010ab1d <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010ab1d:	55                   	push   %ebp
c010ab1e:	89 e5                	mov    %esp,%ebp
c010ab20:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010ab23:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab26:	8b 00                	mov    (%eax),%eax
c010ab28:	83 f8 03             	cmp    $0x3,%eax
c010ab2b:	75 24                	jne    c010ab51 <wakeup_proc+0x34>
c010ab2d:	c7 44 24 0c 53 de 10 	movl   $0xc010de53,0xc(%esp)
c010ab34:	c0 
c010ab35:	c7 44 24 08 6e de 10 	movl   $0xc010de6e,0x8(%esp)
c010ab3c:	c0 
c010ab3d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010ab44:	00 
c010ab45:	c7 04 24 83 de 10 c0 	movl   $0xc010de83,(%esp)
c010ab4c:	e8 84 62 ff ff       	call   c0100dd5 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010ab51:	e8 8a ff ff ff       	call   c010aae0 <__intr_save>
c010ab56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010ab59:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab5c:	8b 00                	mov    (%eax),%eax
c010ab5e:	83 f8 02             	cmp    $0x2,%eax
c010ab61:	74 15                	je     c010ab78 <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010ab63:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab66:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010ab6c:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab6f:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010ab76:	eb 1c                	jmp    c010ab94 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010ab78:	c7 44 24 08 99 de 10 	movl   $0xc010de99,0x8(%esp)
c010ab7f:	c0 
c010ab80:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010ab87:	00 
c010ab88:	c7 04 24 83 de 10 c0 	movl   $0xc010de83,(%esp)
c010ab8f:	e8 ad 62 ff ff       	call   c0100e41 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010ab94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab97:	89 04 24             	mov    %eax,(%esp)
c010ab9a:	e8 6b ff ff ff       	call   c010ab0a <__intr_restore>
}
c010ab9f:	c9                   	leave  
c010aba0:	c3                   	ret    

c010aba1 <schedule>:

void
schedule(void) {
c010aba1:	55                   	push   %ebp
c010aba2:	89 e5                	mov    %esp,%ebp
c010aba4:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010aba7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010abae:	e8 2d ff ff ff       	call   c010aae0 <__intr_save>
c010abb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010abb6:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010abbb:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010abc2:	8b 15 88 bf 19 c0    	mov    0xc019bf88,%edx
c010abc8:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010abcd:	39 c2                	cmp    %eax,%edx
c010abcf:	74 0a                	je     c010abdb <schedule+0x3a>
c010abd1:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010abd6:	83 c0 58             	add    $0x58,%eax
c010abd9:	eb 05                	jmp    c010abe0 <schedule+0x3f>
c010abdb:	b8 b0 e0 19 c0       	mov    $0xc019e0b0,%eax
c010abe0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010abe3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010abe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010abe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010abec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010abef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010abf2:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010abf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010abf8:	81 7d f4 b0 e0 19 c0 	cmpl   $0xc019e0b0,-0xc(%ebp)
c010abff:	74 15                	je     c010ac16 <schedule+0x75>
                next = le2proc(le, list_link);
c010ac01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac04:	83 e8 58             	sub    $0x58,%eax
c010ac07:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010ac0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac0d:	8b 00                	mov    (%eax),%eax
c010ac0f:	83 f8 02             	cmp    $0x2,%eax
c010ac12:	75 02                	jne    c010ac16 <schedule+0x75>
                    break;
c010ac14:	eb 08                	jmp    c010ac1e <schedule+0x7d>
                }
            }
        } while (le != last);
c010ac16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac19:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010ac1c:	75 cb                	jne    c010abe9 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010ac1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010ac22:	74 0a                	je     c010ac2e <schedule+0x8d>
c010ac24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac27:	8b 00                	mov    (%eax),%eax
c010ac29:	83 f8 02             	cmp    $0x2,%eax
c010ac2c:	74 08                	je     c010ac36 <schedule+0x95>
            next = idleproc;
c010ac2e:	a1 80 bf 19 c0       	mov    0xc019bf80,%eax
c010ac33:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010ac36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac39:	8b 40 08             	mov    0x8(%eax),%eax
c010ac3c:	8d 50 01             	lea    0x1(%eax),%edx
c010ac3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac42:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010ac45:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ac4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010ac4d:	74 0b                	je     c010ac5a <schedule+0xb9>
            proc_run(next);
c010ac4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ac52:	89 04 24             	mov    %eax,(%esp)
c010ac55:	e8 7b e8 ff ff       	call   c01094d5 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010ac5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ac5d:	89 04 24             	mov    %eax,(%esp)
c010ac60:	e8 a5 fe ff ff       	call   c010ab0a <__intr_restore>
}
c010ac65:	c9                   	leave  
c010ac66:	c3                   	ret    

c010ac67 <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010ac67:	55                   	push   %ebp
c010ac68:	89 e5                	mov    %esp,%ebp
c010ac6a:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010ac6d:	8b 45 08             	mov    0x8(%ebp),%eax
c010ac70:	8b 00                	mov    (%eax),%eax
c010ac72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010ac75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac78:	89 04 24             	mov    %eax,(%esp)
c010ac7b:	e8 bc ee ff ff       	call   c0109b3c <do_exit>
}
c010ac80:	c9                   	leave  
c010ac81:	c3                   	ret    

c010ac82 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010ac82:	55                   	push   %ebp
c010ac83:	89 e5                	mov    %esp,%ebp
c010ac85:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010ac88:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ac8d:	8b 40 3c             	mov    0x3c(%eax),%eax
c010ac90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010ac93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac96:	8b 40 44             	mov    0x44(%eax),%eax
c010ac99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010ac9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ac9f:	89 44 24 08          	mov    %eax,0x8(%esp)
c010aca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aca6:	89 44 24 04          	mov    %eax,0x4(%esp)
c010acaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010acb1:	e8 62 ed ff ff       	call   c0109a18 <do_fork>
}
c010acb6:	c9                   	leave  
c010acb7:	c3                   	ret    

c010acb8 <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010acb8:	55                   	push   %ebp
c010acb9:	89 e5                	mov    %esp,%ebp
c010acbb:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010acbe:	8b 45 08             	mov    0x8(%ebp),%eax
c010acc1:	8b 00                	mov    (%eax),%eax
c010acc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010acc6:	8b 45 08             	mov    0x8(%ebp),%eax
c010acc9:	83 c0 04             	add    $0x4,%eax
c010accc:	8b 00                	mov    (%eax),%eax
c010acce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010acd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010acd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010acd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010acdb:	89 04 24             	mov    %eax,(%esp)
c010acde:	e8 d7 f7 ff ff       	call   c010a4ba <do_wait>
}
c010ace3:	c9                   	leave  
c010ace4:	c3                   	ret    

c010ace5 <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010ace5:	55                   	push   %ebp
c010ace6:	89 e5                	mov    %esp,%ebp
c010ace8:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010aceb:	8b 45 08             	mov    0x8(%ebp),%eax
c010acee:	8b 00                	mov    (%eax),%eax
c010acf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010acf3:	8b 45 08             	mov    0x8(%ebp),%eax
c010acf6:	8b 40 04             	mov    0x4(%eax),%eax
c010acf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010acfc:	8b 45 08             	mov    0x8(%ebp),%eax
c010acff:	83 c0 08             	add    $0x8,%eax
c010ad02:	8b 00                	mov    (%eax),%eax
c010ad04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010ad07:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad0a:	8b 40 0c             	mov    0xc(%eax),%eax
c010ad0d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010ad10:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ad13:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010ad17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ad1a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010ad1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ad21:	89 44 24 04          	mov    %eax,0x4(%esp)
c010ad25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ad28:	89 04 24             	mov    %eax,(%esp)
c010ad2b:	e8 3e f6 ff ff       	call   c010a36e <do_execve>
}
c010ad30:	c9                   	leave  
c010ad31:	c3                   	ret    

c010ad32 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010ad32:	55                   	push   %ebp
c010ad33:	89 e5                	mov    %esp,%ebp
c010ad35:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010ad38:	e8 67 f7 ff ff       	call   c010a4a4 <do_yield>
}
c010ad3d:	c9                   	leave  
c010ad3e:	c3                   	ret    

c010ad3f <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010ad3f:	55                   	push   %ebp
c010ad40:	89 e5                	mov    %esp,%ebp
c010ad42:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010ad45:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad48:	8b 00                	mov    (%eax),%eax
c010ad4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010ad4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ad50:	89 04 24             	mov    %eax,(%esp)
c010ad53:	e8 f6 f8 ff ff       	call   c010a64e <do_kill>
}
c010ad58:	c9                   	leave  
c010ad59:	c3                   	ret    

c010ad5a <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010ad5a:	55                   	push   %ebp
c010ad5b:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010ad5d:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ad62:	8b 40 04             	mov    0x4(%eax),%eax
}
c010ad65:	5d                   	pop    %ebp
c010ad66:	c3                   	ret    

c010ad67 <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010ad67:	55                   	push   %ebp
c010ad68:	89 e5                	mov    %esp,%ebp
c010ad6a:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010ad6d:	8b 45 08             	mov    0x8(%ebp),%eax
c010ad70:	8b 00                	mov    (%eax),%eax
c010ad72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010ad75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ad78:	89 04 24             	mov    %eax,(%esp)
c010ad7b:	e8 f9 55 ff ff       	call   c0100379 <cputchar>
    return 0;
c010ad80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ad85:	c9                   	leave  
c010ad86:	c3                   	ret    

c010ad87 <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010ad87:	55                   	push   %ebp
c010ad88:	89 e5                	mov    %esp,%ebp
c010ad8a:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010ad8d:	e8 e3 bb ff ff       	call   c0106975 <print_pgdir>
    return 0;
c010ad92:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ad97:	c9                   	leave  
c010ad98:	c3                   	ret    

c010ad99 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010ad99:	55                   	push   %ebp
c010ad9a:	89 e5                	mov    %esp,%ebp
c010ad9c:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010ad9f:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ada4:	8b 40 3c             	mov    0x3c(%eax),%eax
c010ada7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010adaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010adad:	8b 40 1c             	mov    0x1c(%eax),%eax
c010adb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010adb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010adb7:	78 5e                	js     c010ae17 <syscall+0x7e>
c010adb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010adbc:	83 f8 1f             	cmp    $0x1f,%eax
c010adbf:	77 56                	ja     c010ae17 <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010adc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010adc4:	8b 04 85 a0 9a 12 c0 	mov    -0x3fed6560(,%eax,4),%eax
c010adcb:	85 c0                	test   %eax,%eax
c010adcd:	74 48                	je     c010ae17 <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010adcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010add2:	8b 40 14             	mov    0x14(%eax),%eax
c010add5:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010add8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010addb:	8b 40 18             	mov    0x18(%eax),%eax
c010adde:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010ade1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ade4:	8b 40 10             	mov    0x10(%eax),%eax
c010ade7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010adea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aded:	8b 00                	mov    (%eax),%eax
c010adef:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010adf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010adf5:	8b 40 04             	mov    0x4(%eax),%eax
c010adf8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010adfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010adfe:	8b 04 85 a0 9a 12 c0 	mov    -0x3fed6560(,%eax,4),%eax
c010ae05:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010ae08:	89 14 24             	mov    %edx,(%esp)
c010ae0b:	ff d0                	call   *%eax
c010ae0d:	89 c2                	mov    %eax,%edx
c010ae0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae12:	89 50 1c             	mov    %edx,0x1c(%eax)
            return ;
c010ae15:	eb 46                	jmp    c010ae5d <syscall+0xc4>
        }
    }
    print_trapframe(tf);
c010ae17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ae1a:	89 04 24             	mov    %eax,(%esp)
c010ae1d:	e8 51 75 ff ff       	call   c0102373 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010ae22:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ae27:	8d 50 48             	lea    0x48(%eax),%edx
c010ae2a:	a1 88 bf 19 c0       	mov    0xc019bf88,%eax
c010ae2f:	8b 40 04             	mov    0x4(%eax),%eax
c010ae32:	89 54 24 14          	mov    %edx,0x14(%esp)
c010ae36:	89 44 24 10          	mov    %eax,0x10(%esp)
c010ae3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ae3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010ae41:	c7 44 24 08 b4 de 10 	movl   $0xc010deb4,0x8(%esp)
c010ae48:	c0 
c010ae49:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010ae50:	00 
c010ae51:	c7 04 24 e0 de 10 c0 	movl   $0xc010dee0,(%esp)
c010ae58:	e8 78 5f ff ff       	call   c0100dd5 <__panic>
            num, current->pid, current->name);
}
c010ae5d:	c9                   	leave  
c010ae5e:	c3                   	ret    

c010ae5f <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010ae5f:	55                   	push   %ebp
c010ae60:	89 e5                	mov    %esp,%ebp
c010ae62:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010ae65:	8b 45 08             	mov    0x8(%ebp),%eax
c010ae68:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010ae6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c010ae71:	b8 20 00 00 00       	mov    $0x20,%eax
c010ae76:	2b 45 0c             	sub    0xc(%ebp),%eax
c010ae79:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010ae7c:	89 c1                	mov    %eax,%ecx
c010ae7e:	d3 ea                	shr    %cl,%edx
c010ae80:	89 d0                	mov    %edx,%eax
}
c010ae82:	c9                   	leave  
c010ae83:	c3                   	ret    

c010ae84 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010ae84:	55                   	push   %ebp
c010ae85:	89 e5                	mov    %esp,%ebp
c010ae87:	83 ec 58             	sub    $0x58,%esp
c010ae8a:	8b 45 10             	mov    0x10(%ebp),%eax
c010ae8d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010ae90:	8b 45 14             	mov    0x14(%ebp),%eax
c010ae93:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010ae96:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010ae99:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010ae9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010ae9f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010aea2:	8b 45 18             	mov    0x18(%ebp),%eax
c010aea5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010aea8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010aeab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010aeae:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010aeb1:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010aeb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aeb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aeba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aebe:	74 1c                	je     c010aedc <printnum+0x58>
c010aec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aec3:	ba 00 00 00 00       	mov    $0x0,%edx
c010aec8:	f7 75 e4             	divl   -0x1c(%ebp)
c010aecb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010aece:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aed1:	ba 00 00 00 00       	mov    $0x0,%edx
c010aed6:	f7 75 e4             	divl   -0x1c(%ebp)
c010aed9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010aedc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010aedf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010aee2:	f7 75 e4             	divl   -0x1c(%ebp)
c010aee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010aee8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010aeeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010aeee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010aef1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010aef4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010aef7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010aefa:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010aefd:	8b 45 18             	mov    0x18(%ebp),%eax
c010af00:	ba 00 00 00 00       	mov    $0x0,%edx
c010af05:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010af08:	77 56                	ja     c010af60 <printnum+0xdc>
c010af0a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010af0d:	72 05                	jb     c010af14 <printnum+0x90>
c010af0f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010af12:	77 4c                	ja     c010af60 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010af14:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010af17:	8d 50 ff             	lea    -0x1(%eax),%edx
c010af1a:	8b 45 20             	mov    0x20(%ebp),%eax
c010af1d:	89 44 24 18          	mov    %eax,0x18(%esp)
c010af21:	89 54 24 14          	mov    %edx,0x14(%esp)
c010af25:	8b 45 18             	mov    0x18(%ebp),%eax
c010af28:	89 44 24 10          	mov    %eax,0x10(%esp)
c010af2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010af2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010af32:	89 44 24 08          	mov    %eax,0x8(%esp)
c010af36:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010af3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010af3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af41:	8b 45 08             	mov    0x8(%ebp),%eax
c010af44:	89 04 24             	mov    %eax,(%esp)
c010af47:	e8 38 ff ff ff       	call   c010ae84 <printnum>
c010af4c:	eb 1c                	jmp    c010af6a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010af4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010af51:	89 44 24 04          	mov    %eax,0x4(%esp)
c010af55:	8b 45 20             	mov    0x20(%ebp),%eax
c010af58:	89 04 24             	mov    %eax,(%esp)
c010af5b:	8b 45 08             	mov    0x8(%ebp),%eax
c010af5e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010af60:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010af64:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010af68:	7f e4                	jg     c010af4e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010af6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010af6d:	05 04 e0 10 c0       	add    $0xc010e004,%eax
c010af72:	0f b6 00             	movzbl (%eax),%eax
c010af75:	0f be c0             	movsbl %al,%eax
c010af78:	8b 55 0c             	mov    0xc(%ebp),%edx
c010af7b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010af7f:	89 04 24             	mov    %eax,(%esp)
c010af82:	8b 45 08             	mov    0x8(%ebp),%eax
c010af85:	ff d0                	call   *%eax
}
c010af87:	c9                   	leave  
c010af88:	c3                   	ret    

c010af89 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010af89:	55                   	push   %ebp
c010af8a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010af8c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010af90:	7e 14                	jle    c010afa6 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010af92:	8b 45 08             	mov    0x8(%ebp),%eax
c010af95:	8b 00                	mov    (%eax),%eax
c010af97:	8d 48 08             	lea    0x8(%eax),%ecx
c010af9a:	8b 55 08             	mov    0x8(%ebp),%edx
c010af9d:	89 0a                	mov    %ecx,(%edx)
c010af9f:	8b 50 04             	mov    0x4(%eax),%edx
c010afa2:	8b 00                	mov    (%eax),%eax
c010afa4:	eb 30                	jmp    c010afd6 <getuint+0x4d>
    }
    else if (lflag) {
c010afa6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010afaa:	74 16                	je     c010afc2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010afac:	8b 45 08             	mov    0x8(%ebp),%eax
c010afaf:	8b 00                	mov    (%eax),%eax
c010afb1:	8d 48 04             	lea    0x4(%eax),%ecx
c010afb4:	8b 55 08             	mov    0x8(%ebp),%edx
c010afb7:	89 0a                	mov    %ecx,(%edx)
c010afb9:	8b 00                	mov    (%eax),%eax
c010afbb:	ba 00 00 00 00       	mov    $0x0,%edx
c010afc0:	eb 14                	jmp    c010afd6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010afc2:	8b 45 08             	mov    0x8(%ebp),%eax
c010afc5:	8b 00                	mov    (%eax),%eax
c010afc7:	8d 48 04             	lea    0x4(%eax),%ecx
c010afca:	8b 55 08             	mov    0x8(%ebp),%edx
c010afcd:	89 0a                	mov    %ecx,(%edx)
c010afcf:	8b 00                	mov    (%eax),%eax
c010afd1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010afd6:	5d                   	pop    %ebp
c010afd7:	c3                   	ret    

c010afd8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010afd8:	55                   	push   %ebp
c010afd9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010afdb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010afdf:	7e 14                	jle    c010aff5 <getint+0x1d>
        return va_arg(*ap, long long);
c010afe1:	8b 45 08             	mov    0x8(%ebp),%eax
c010afe4:	8b 00                	mov    (%eax),%eax
c010afe6:	8d 48 08             	lea    0x8(%eax),%ecx
c010afe9:	8b 55 08             	mov    0x8(%ebp),%edx
c010afec:	89 0a                	mov    %ecx,(%edx)
c010afee:	8b 50 04             	mov    0x4(%eax),%edx
c010aff1:	8b 00                	mov    (%eax),%eax
c010aff3:	eb 28                	jmp    c010b01d <getint+0x45>
    }
    else if (lflag) {
c010aff5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010aff9:	74 12                	je     c010b00d <getint+0x35>
        return va_arg(*ap, long);
c010affb:	8b 45 08             	mov    0x8(%ebp),%eax
c010affe:	8b 00                	mov    (%eax),%eax
c010b000:	8d 48 04             	lea    0x4(%eax),%ecx
c010b003:	8b 55 08             	mov    0x8(%ebp),%edx
c010b006:	89 0a                	mov    %ecx,(%edx)
c010b008:	8b 00                	mov    (%eax),%eax
c010b00a:	99                   	cltd   
c010b00b:	eb 10                	jmp    c010b01d <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010b00d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b010:	8b 00                	mov    (%eax),%eax
c010b012:	8d 48 04             	lea    0x4(%eax),%ecx
c010b015:	8b 55 08             	mov    0x8(%ebp),%edx
c010b018:	89 0a                	mov    %ecx,(%edx)
c010b01a:	8b 00                	mov    (%eax),%eax
c010b01c:	99                   	cltd   
    }
}
c010b01d:	5d                   	pop    %ebp
c010b01e:	c3                   	ret    

c010b01f <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b01f:	55                   	push   %ebp
c010b020:	89 e5                	mov    %esp,%ebp
c010b022:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b025:	8d 45 14             	lea    0x14(%ebp),%eax
c010b028:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010b02b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b02e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b032:	8b 45 10             	mov    0x10(%ebp),%eax
c010b035:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b039:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b03c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b040:	8b 45 08             	mov    0x8(%ebp),%eax
c010b043:	89 04 24             	mov    %eax,(%esp)
c010b046:	e8 02 00 00 00       	call   c010b04d <vprintfmt>
    va_end(ap);
}
c010b04b:	c9                   	leave  
c010b04c:	c3                   	ret    

c010b04d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b04d:	55                   	push   %ebp
c010b04e:	89 e5                	mov    %esp,%ebp
c010b050:	56                   	push   %esi
c010b051:	53                   	push   %ebx
c010b052:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b055:	eb 18                	jmp    c010b06f <vprintfmt+0x22>
            if (ch == '\0') {
c010b057:	85 db                	test   %ebx,%ebx
c010b059:	75 05                	jne    c010b060 <vprintfmt+0x13>
                return;
c010b05b:	e9 d1 03 00 00       	jmp    c010b431 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010b060:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b063:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b067:	89 1c 24             	mov    %ebx,(%esp)
c010b06a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b06d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b06f:	8b 45 10             	mov    0x10(%ebp),%eax
c010b072:	8d 50 01             	lea    0x1(%eax),%edx
c010b075:	89 55 10             	mov    %edx,0x10(%ebp)
c010b078:	0f b6 00             	movzbl (%eax),%eax
c010b07b:	0f b6 d8             	movzbl %al,%ebx
c010b07e:	83 fb 25             	cmp    $0x25,%ebx
c010b081:	75 d4                	jne    c010b057 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b083:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b087:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b08e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b091:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b094:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b09b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b09e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b0a1:	8b 45 10             	mov    0x10(%ebp),%eax
c010b0a4:	8d 50 01             	lea    0x1(%eax),%edx
c010b0a7:	89 55 10             	mov    %edx,0x10(%ebp)
c010b0aa:	0f b6 00             	movzbl (%eax),%eax
c010b0ad:	0f b6 d8             	movzbl %al,%ebx
c010b0b0:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010b0b3:	83 f8 55             	cmp    $0x55,%eax
c010b0b6:	0f 87 44 03 00 00    	ja     c010b400 <vprintfmt+0x3b3>
c010b0bc:	8b 04 85 28 e0 10 c0 	mov    -0x3fef1fd8(,%eax,4),%eax
c010b0c3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b0c5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b0c9:	eb d6                	jmp    c010b0a1 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b0cb:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b0cf:	eb d0                	jmp    c010b0a1 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b0d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b0d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b0db:	89 d0                	mov    %edx,%eax
c010b0dd:	c1 e0 02             	shl    $0x2,%eax
c010b0e0:	01 d0                	add    %edx,%eax
c010b0e2:	01 c0                	add    %eax,%eax
c010b0e4:	01 d8                	add    %ebx,%eax
c010b0e6:	83 e8 30             	sub    $0x30,%eax
c010b0e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b0ec:	8b 45 10             	mov    0x10(%ebp),%eax
c010b0ef:	0f b6 00             	movzbl (%eax),%eax
c010b0f2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b0f5:	83 fb 2f             	cmp    $0x2f,%ebx
c010b0f8:	7e 0b                	jle    c010b105 <vprintfmt+0xb8>
c010b0fa:	83 fb 39             	cmp    $0x39,%ebx
c010b0fd:	7f 06                	jg     c010b105 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b0ff:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b103:	eb d3                	jmp    c010b0d8 <vprintfmt+0x8b>
            goto process_precision;
c010b105:	eb 33                	jmp    c010b13a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010b107:	8b 45 14             	mov    0x14(%ebp),%eax
c010b10a:	8d 50 04             	lea    0x4(%eax),%edx
c010b10d:	89 55 14             	mov    %edx,0x14(%ebp)
c010b110:	8b 00                	mov    (%eax),%eax
c010b112:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b115:	eb 23                	jmp    c010b13a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010b117:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b11b:	79 0c                	jns    c010b129 <vprintfmt+0xdc>
                width = 0;
c010b11d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b124:	e9 78 ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>
c010b129:	e9 73 ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010b12e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b135:	e9 67 ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010b13a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b13e:	79 12                	jns    c010b152 <vprintfmt+0x105>
                width = precision, precision = -1;
c010b140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b143:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b146:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b14d:	e9 4f ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>
c010b152:	e9 4a ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b157:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b15b:	e9 41 ff ff ff       	jmp    c010b0a1 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b160:	8b 45 14             	mov    0x14(%ebp),%eax
c010b163:	8d 50 04             	lea    0x4(%eax),%edx
c010b166:	89 55 14             	mov    %edx,0x14(%ebp)
c010b169:	8b 00                	mov    (%eax),%eax
c010b16b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b16e:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b172:	89 04 24             	mov    %eax,(%esp)
c010b175:	8b 45 08             	mov    0x8(%ebp),%eax
c010b178:	ff d0                	call   *%eax
            break;
c010b17a:	e9 ac 02 00 00       	jmp    c010b42b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b17f:	8b 45 14             	mov    0x14(%ebp),%eax
c010b182:	8d 50 04             	lea    0x4(%eax),%edx
c010b185:	89 55 14             	mov    %edx,0x14(%ebp)
c010b188:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b18a:	85 db                	test   %ebx,%ebx
c010b18c:	79 02                	jns    c010b190 <vprintfmt+0x143>
                err = -err;
c010b18e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b190:	83 fb 18             	cmp    $0x18,%ebx
c010b193:	7f 0b                	jg     c010b1a0 <vprintfmt+0x153>
c010b195:	8b 34 9d a0 df 10 c0 	mov    -0x3fef2060(,%ebx,4),%esi
c010b19c:	85 f6                	test   %esi,%esi
c010b19e:	75 23                	jne    c010b1c3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010b1a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b1a4:	c7 44 24 08 15 e0 10 	movl   $0xc010e015,0x8(%esp)
c010b1ab:	c0 
c010b1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b1af:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1b3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1b6:	89 04 24             	mov    %eax,(%esp)
c010b1b9:	e8 61 fe ff ff       	call   c010b01f <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b1be:	e9 68 02 00 00       	jmp    c010b42b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b1c3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b1c7:	c7 44 24 08 1e e0 10 	movl   $0xc010e01e,0x8(%esp)
c010b1ce:	c0 
c010b1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b1d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1d6:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1d9:	89 04 24             	mov    %eax,(%esp)
c010b1dc:	e8 3e fe ff ff       	call   c010b01f <printfmt>
            }
            break;
c010b1e1:	e9 45 02 00 00       	jmp    c010b42b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b1e6:	8b 45 14             	mov    0x14(%ebp),%eax
c010b1e9:	8d 50 04             	lea    0x4(%eax),%edx
c010b1ec:	89 55 14             	mov    %edx,0x14(%ebp)
c010b1ef:	8b 30                	mov    (%eax),%esi
c010b1f1:	85 f6                	test   %esi,%esi
c010b1f3:	75 05                	jne    c010b1fa <vprintfmt+0x1ad>
                p = "(null)";
c010b1f5:	be 21 e0 10 c0       	mov    $0xc010e021,%esi
            }
            if (width > 0 && padc != '-') {
c010b1fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b1fe:	7e 3e                	jle    c010b23e <vprintfmt+0x1f1>
c010b200:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b204:	74 38                	je     c010b23e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b206:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b20c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b210:	89 34 24             	mov    %esi,(%esp)
c010b213:	e8 ed 03 00 00       	call   c010b605 <strnlen>
c010b218:	29 c3                	sub    %eax,%ebx
c010b21a:	89 d8                	mov    %ebx,%eax
c010b21c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b21f:	eb 17                	jmp    c010b238 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010b221:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b225:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b228:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b22c:	89 04 24             	mov    %eax,(%esp)
c010b22f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b232:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b234:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b238:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b23c:	7f e3                	jg     c010b221 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b23e:	eb 38                	jmp    c010b278 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b240:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b244:	74 1f                	je     c010b265 <vprintfmt+0x218>
c010b246:	83 fb 1f             	cmp    $0x1f,%ebx
c010b249:	7e 05                	jle    c010b250 <vprintfmt+0x203>
c010b24b:	83 fb 7e             	cmp    $0x7e,%ebx
c010b24e:	7e 15                	jle    c010b265 <vprintfmt+0x218>
                    putch('?', putdat);
c010b250:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b253:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b257:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b25e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b261:	ff d0                	call   *%eax
c010b263:	eb 0f                	jmp    c010b274 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010b265:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b268:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b26c:	89 1c 24             	mov    %ebx,(%esp)
c010b26f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b272:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b274:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b278:	89 f0                	mov    %esi,%eax
c010b27a:	8d 70 01             	lea    0x1(%eax),%esi
c010b27d:	0f b6 00             	movzbl (%eax),%eax
c010b280:	0f be d8             	movsbl %al,%ebx
c010b283:	85 db                	test   %ebx,%ebx
c010b285:	74 10                	je     c010b297 <vprintfmt+0x24a>
c010b287:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b28b:	78 b3                	js     c010b240 <vprintfmt+0x1f3>
c010b28d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b291:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b295:	79 a9                	jns    c010b240 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b297:	eb 17                	jmp    c010b2b0 <vprintfmt+0x263>
                putch(' ', putdat);
c010b299:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b29c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b2a0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b2a7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2aa:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b2ac:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b2b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b2b4:	7f e3                	jg     c010b299 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010b2b6:	e9 70 01 00 00       	jmp    c010b42b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b2bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b2be:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b2c2:	8d 45 14             	lea    0x14(%ebp),%eax
c010b2c5:	89 04 24             	mov    %eax,(%esp)
c010b2c8:	e8 0b fd ff ff       	call   c010afd8 <getint>
c010b2cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b2d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b2d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b2d9:	85 d2                	test   %edx,%edx
c010b2db:	79 26                	jns    c010b303 <vprintfmt+0x2b6>
                putch('-', putdat);
c010b2dd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b2e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b2e4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b2eb:	8b 45 08             	mov    0x8(%ebp),%eax
c010b2ee:	ff d0                	call   *%eax
                num = -(long long)num;
c010b2f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b2f6:	f7 d8                	neg    %eax
c010b2f8:	83 d2 00             	adc    $0x0,%edx
c010b2fb:	f7 da                	neg    %edx
c010b2fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b300:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b303:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b30a:	e9 a8 00 00 00       	jmp    c010b3b7 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b30f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b312:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b316:	8d 45 14             	lea    0x14(%ebp),%eax
c010b319:	89 04 24             	mov    %eax,(%esp)
c010b31c:	e8 68 fc ff ff       	call   c010af89 <getuint>
c010b321:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b324:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b327:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b32e:	e9 84 00 00 00       	jmp    c010b3b7 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b333:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b33a:	8d 45 14             	lea    0x14(%ebp),%eax
c010b33d:	89 04 24             	mov    %eax,(%esp)
c010b340:	e8 44 fc ff ff       	call   c010af89 <getuint>
c010b345:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b348:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b34b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b352:	eb 63                	jmp    c010b3b7 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010b354:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b35b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b362:	8b 45 08             	mov    0x8(%ebp),%eax
c010b365:	ff d0                	call   *%eax
            putch('x', putdat);
c010b367:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b36a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b36e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b375:	8b 45 08             	mov    0x8(%ebp),%eax
c010b378:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b37a:	8b 45 14             	mov    0x14(%ebp),%eax
c010b37d:	8d 50 04             	lea    0x4(%eax),%edx
c010b380:	89 55 14             	mov    %edx,0x14(%ebp)
c010b383:	8b 00                	mov    (%eax),%eax
c010b385:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b38f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b396:	eb 1f                	jmp    c010b3b7 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b398:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b39b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b39f:	8d 45 14             	lea    0x14(%ebp),%eax
c010b3a2:	89 04 24             	mov    %eax,(%esp)
c010b3a5:	e8 df fb ff ff       	call   c010af89 <getuint>
c010b3aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b3ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b3b0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b3b7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b3bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b3be:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b3c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b3c5:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b3c9:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b3cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b3d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b3d3:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b3d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b3db:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b3de:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b3e2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3e5:	89 04 24             	mov    %eax,(%esp)
c010b3e8:	e8 97 fa ff ff       	call   c010ae84 <printnum>
            break;
c010b3ed:	eb 3c                	jmp    c010b42b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b3f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b3f6:	89 1c 24             	mov    %ebx,(%esp)
c010b3f9:	8b 45 08             	mov    0x8(%ebp),%eax
c010b3fc:	ff d0                	call   *%eax
            break;
c010b3fe:	eb 2b                	jmp    c010b42b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b400:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b403:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b407:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b40e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b411:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b413:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b417:	eb 04                	jmp    c010b41d <vprintfmt+0x3d0>
c010b419:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b41d:	8b 45 10             	mov    0x10(%ebp),%eax
c010b420:	83 e8 01             	sub    $0x1,%eax
c010b423:	0f b6 00             	movzbl (%eax),%eax
c010b426:	3c 25                	cmp    $0x25,%al
c010b428:	75 ef                	jne    c010b419 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010b42a:	90                   	nop
        }
    }
c010b42b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b42c:	e9 3e fc ff ff       	jmp    c010b06f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b431:	83 c4 40             	add    $0x40,%esp
c010b434:	5b                   	pop    %ebx
c010b435:	5e                   	pop    %esi
c010b436:	5d                   	pop    %ebp
c010b437:	c3                   	ret    

c010b438 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b438:	55                   	push   %ebp
c010b439:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b43b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b43e:	8b 40 08             	mov    0x8(%eax),%eax
c010b441:	8d 50 01             	lea    0x1(%eax),%edx
c010b444:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b447:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b44a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b44d:	8b 10                	mov    (%eax),%edx
c010b44f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b452:	8b 40 04             	mov    0x4(%eax),%eax
c010b455:	39 c2                	cmp    %eax,%edx
c010b457:	73 12                	jae    c010b46b <sprintputch+0x33>
        *b->buf ++ = ch;
c010b459:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b45c:	8b 00                	mov    (%eax),%eax
c010b45e:	8d 48 01             	lea    0x1(%eax),%ecx
c010b461:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b464:	89 0a                	mov    %ecx,(%edx)
c010b466:	8b 55 08             	mov    0x8(%ebp),%edx
c010b469:	88 10                	mov    %dl,(%eax)
    }
}
c010b46b:	5d                   	pop    %ebp
c010b46c:	c3                   	ret    

c010b46d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b46d:	55                   	push   %ebp
c010b46e:	89 e5                	mov    %esp,%ebp
c010b470:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b473:	8d 45 14             	lea    0x14(%ebp),%eax
c010b476:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010b479:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b47c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b480:	8b 45 10             	mov    0x10(%ebp),%eax
c010b483:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b48a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b48e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b491:	89 04 24             	mov    %eax,(%esp)
c010b494:	e8 08 00 00 00       	call   c010b4a1 <vsnprintf>
c010b499:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b49f:	c9                   	leave  
c010b4a0:	c3                   	ret    

c010b4a1 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b4a1:	55                   	push   %ebp
c010b4a2:	89 e5                	mov    %esp,%ebp
c010b4a4:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b4a7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b4b0:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b4b3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4b6:	01 d0                	add    %edx,%eax
c010b4b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b4bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010b4c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b4c6:	74 0a                	je     c010b4d2 <vsnprintf+0x31>
c010b4c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b4ce:	39 c2                	cmp    %eax,%edx
c010b4d0:	76 07                	jbe    c010b4d9 <vsnprintf+0x38>
        return -E_INVAL;
c010b4d2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010b4d7:	eb 2a                	jmp    c010b503 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010b4d9:	8b 45 14             	mov    0x14(%ebp),%eax
c010b4dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b4e0:	8b 45 10             	mov    0x10(%ebp),%eax
c010b4e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b4e7:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010b4ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b4ee:	c7 04 24 38 b4 10 c0 	movl   $0xc010b438,(%esp)
c010b4f5:	e8 53 fb ff ff       	call   c010b04d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010b4fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b4fd:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010b500:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b503:	c9                   	leave  
c010b504:	c3                   	ret    

c010b505 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010b505:	55                   	push   %ebp
c010b506:	89 e5                	mov    %esp,%ebp
c010b508:	57                   	push   %edi
c010b509:	56                   	push   %esi
c010b50a:	53                   	push   %ebx
c010b50b:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010b50e:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c010b513:	8b 15 24 9b 12 c0    	mov    0xc0129b24,%edx
c010b519:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010b51f:	6b f0 05             	imul   $0x5,%eax,%esi
c010b522:	01 f7                	add    %esi,%edi
c010b524:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010b529:	f7 e6                	mul    %esi
c010b52b:	8d 34 17             	lea    (%edi,%edx,1),%esi
c010b52e:	89 f2                	mov    %esi,%edx
c010b530:	83 c0 0b             	add    $0xb,%eax
c010b533:	83 d2 00             	adc    $0x0,%edx
c010b536:	89 c7                	mov    %eax,%edi
c010b538:	83 e7 ff             	and    $0xffffffff,%edi
c010b53b:	89 f9                	mov    %edi,%ecx
c010b53d:	0f b7 da             	movzwl %dx,%ebx
c010b540:	89 0d 20 9b 12 c0    	mov    %ecx,0xc0129b20
c010b546:	89 1d 24 9b 12 c0    	mov    %ebx,0xc0129b24
    unsigned long long result = (next >> 12);
c010b54c:	a1 20 9b 12 c0       	mov    0xc0129b20,%eax
c010b551:	8b 15 24 9b 12 c0    	mov    0xc0129b24,%edx
c010b557:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010b55b:	c1 ea 0c             	shr    $0xc,%edx
c010b55e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b561:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010b564:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010b56b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b56e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b571:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b574:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b577:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b57a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b57d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b581:	74 1c                	je     c010b59f <rand+0x9a>
c010b583:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b586:	ba 00 00 00 00       	mov    $0x0,%edx
c010b58b:	f7 75 dc             	divl   -0x24(%ebp)
c010b58e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010b591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b594:	ba 00 00 00 00       	mov    $0x0,%edx
c010b599:	f7 75 dc             	divl   -0x24(%ebp)
c010b59c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b59f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b5a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b5a5:	f7 75 dc             	divl   -0x24(%ebp)
c010b5a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010b5ab:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b5ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b5b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b5b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b5b7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010b5ba:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010b5bd:	83 c4 24             	add    $0x24,%esp
c010b5c0:	5b                   	pop    %ebx
c010b5c1:	5e                   	pop    %esi
c010b5c2:	5f                   	pop    %edi
c010b5c3:	5d                   	pop    %ebp
c010b5c4:	c3                   	ret    

c010b5c5 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010b5c5:	55                   	push   %ebp
c010b5c6:	89 e5                	mov    %esp,%ebp
    next = seed;
c010b5c8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5cb:	ba 00 00 00 00       	mov    $0x0,%edx
c010b5d0:	a3 20 9b 12 c0       	mov    %eax,0xc0129b20
c010b5d5:	89 15 24 9b 12 c0    	mov    %edx,0xc0129b24
}
c010b5db:	5d                   	pop    %ebp
c010b5dc:	c3                   	ret    

c010b5dd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010b5dd:	55                   	push   %ebp
c010b5de:	89 e5                	mov    %esp,%ebp
c010b5e0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b5e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010b5ea:	eb 04                	jmp    c010b5f0 <strlen+0x13>
        cnt ++;
c010b5ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010b5f0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5f3:	8d 50 01             	lea    0x1(%eax),%edx
c010b5f6:	89 55 08             	mov    %edx,0x8(%ebp)
c010b5f9:	0f b6 00             	movzbl (%eax),%eax
c010b5fc:	84 c0                	test   %al,%al
c010b5fe:	75 ec                	jne    c010b5ec <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010b600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b603:	c9                   	leave  
c010b604:	c3                   	ret    

c010b605 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010b605:	55                   	push   %ebp
c010b606:	89 e5                	mov    %esp,%ebp
c010b608:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010b60b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010b612:	eb 04                	jmp    c010b618 <strnlen+0x13>
        cnt ++;
c010b614:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010b618:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b61b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010b61e:	73 10                	jae    c010b630 <strnlen+0x2b>
c010b620:	8b 45 08             	mov    0x8(%ebp),%eax
c010b623:	8d 50 01             	lea    0x1(%eax),%edx
c010b626:	89 55 08             	mov    %edx,0x8(%ebp)
c010b629:	0f b6 00             	movzbl (%eax),%eax
c010b62c:	84 c0                	test   %al,%al
c010b62e:	75 e4                	jne    c010b614 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010b630:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010b633:	c9                   	leave  
c010b634:	c3                   	ret    

c010b635 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010b635:	55                   	push   %ebp
c010b636:	89 e5                	mov    %esp,%ebp
c010b638:	57                   	push   %edi
c010b639:	56                   	push   %esi
c010b63a:	83 ec 20             	sub    $0x20,%esp
c010b63d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b640:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b643:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b646:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010b649:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b64c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b64f:	89 d1                	mov    %edx,%ecx
c010b651:	89 c2                	mov    %eax,%edx
c010b653:	89 ce                	mov    %ecx,%esi
c010b655:	89 d7                	mov    %edx,%edi
c010b657:	ac                   	lods   %ds:(%esi),%al
c010b658:	aa                   	stos   %al,%es:(%edi)
c010b659:	84 c0                	test   %al,%al
c010b65b:	75 fa                	jne    c010b657 <strcpy+0x22>
c010b65d:	89 fa                	mov    %edi,%edx
c010b65f:	89 f1                	mov    %esi,%ecx
c010b661:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010b664:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010b667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010b66a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010b66d:	83 c4 20             	add    $0x20,%esp
c010b670:	5e                   	pop    %esi
c010b671:	5f                   	pop    %edi
c010b672:	5d                   	pop    %ebp
c010b673:	c3                   	ret    

c010b674 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010b674:	55                   	push   %ebp
c010b675:	89 e5                	mov    %esp,%ebp
c010b677:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010b67a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b67d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010b680:	eb 21                	jmp    c010b6a3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010b682:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b685:	0f b6 10             	movzbl (%eax),%edx
c010b688:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b68b:	88 10                	mov    %dl,(%eax)
c010b68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010b690:	0f b6 00             	movzbl (%eax),%eax
c010b693:	84 c0                	test   %al,%al
c010b695:	74 04                	je     c010b69b <strncpy+0x27>
            src ++;
c010b697:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010b69b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010b69f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010b6a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b6a7:	75 d9                	jne    c010b682 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010b6a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b6ac:	c9                   	leave  
c010b6ad:	c3                   	ret    

c010b6ae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010b6ae:	55                   	push   %ebp
c010b6af:	89 e5                	mov    %esp,%ebp
c010b6b1:	57                   	push   %edi
c010b6b2:	56                   	push   %esi
c010b6b3:	83 ec 20             	sub    $0x20,%esp
c010b6b6:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b6bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010b6c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b6c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b6c8:	89 d1                	mov    %edx,%ecx
c010b6ca:	89 c2                	mov    %eax,%edx
c010b6cc:	89 ce                	mov    %ecx,%esi
c010b6ce:	89 d7                	mov    %edx,%edi
c010b6d0:	ac                   	lods   %ds:(%esi),%al
c010b6d1:	ae                   	scas   %es:(%edi),%al
c010b6d2:	75 08                	jne    c010b6dc <strcmp+0x2e>
c010b6d4:	84 c0                	test   %al,%al
c010b6d6:	75 f8                	jne    c010b6d0 <strcmp+0x22>
c010b6d8:	31 c0                	xor    %eax,%eax
c010b6da:	eb 04                	jmp    c010b6e0 <strcmp+0x32>
c010b6dc:	19 c0                	sbb    %eax,%eax
c010b6de:	0c 01                	or     $0x1,%al
c010b6e0:	89 fa                	mov    %edi,%edx
c010b6e2:	89 f1                	mov    %esi,%ecx
c010b6e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b6e7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010b6ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010b6ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010b6f0:	83 c4 20             	add    $0x20,%esp
c010b6f3:	5e                   	pop    %esi
c010b6f4:	5f                   	pop    %edi
c010b6f5:	5d                   	pop    %ebp
c010b6f6:	c3                   	ret    

c010b6f7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010b6f7:	55                   	push   %ebp
c010b6f8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b6fa:	eb 0c                	jmp    c010b708 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010b6fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b700:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b704:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010b708:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b70c:	74 1a                	je     c010b728 <strncmp+0x31>
c010b70e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b711:	0f b6 00             	movzbl (%eax),%eax
c010b714:	84 c0                	test   %al,%al
c010b716:	74 10                	je     c010b728 <strncmp+0x31>
c010b718:	8b 45 08             	mov    0x8(%ebp),%eax
c010b71b:	0f b6 10             	movzbl (%eax),%edx
c010b71e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b721:	0f b6 00             	movzbl (%eax),%eax
c010b724:	38 c2                	cmp    %al,%dl
c010b726:	74 d4                	je     c010b6fc <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010b728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b72c:	74 18                	je     c010b746 <strncmp+0x4f>
c010b72e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b731:	0f b6 00             	movzbl (%eax),%eax
c010b734:	0f b6 d0             	movzbl %al,%edx
c010b737:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b73a:	0f b6 00             	movzbl (%eax),%eax
c010b73d:	0f b6 c0             	movzbl %al,%eax
c010b740:	29 c2                	sub    %eax,%edx
c010b742:	89 d0                	mov    %edx,%eax
c010b744:	eb 05                	jmp    c010b74b <strncmp+0x54>
c010b746:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b74b:	5d                   	pop    %ebp
c010b74c:	c3                   	ret    

c010b74d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010b74d:	55                   	push   %ebp
c010b74e:	89 e5                	mov    %esp,%ebp
c010b750:	83 ec 04             	sub    $0x4,%esp
c010b753:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b756:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010b759:	eb 14                	jmp    c010b76f <strchr+0x22>
        if (*s == c) {
c010b75b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b75e:	0f b6 00             	movzbl (%eax),%eax
c010b761:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010b764:	75 05                	jne    c010b76b <strchr+0x1e>
            return (char *)s;
c010b766:	8b 45 08             	mov    0x8(%ebp),%eax
c010b769:	eb 13                	jmp    c010b77e <strchr+0x31>
        }
        s ++;
c010b76b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010b76f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b772:	0f b6 00             	movzbl (%eax),%eax
c010b775:	84 c0                	test   %al,%al
c010b777:	75 e2                	jne    c010b75b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010b779:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b77e:	c9                   	leave  
c010b77f:	c3                   	ret    

c010b780 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010b780:	55                   	push   %ebp
c010b781:	89 e5                	mov    %esp,%ebp
c010b783:	83 ec 04             	sub    $0x4,%esp
c010b786:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b789:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010b78c:	eb 11                	jmp    c010b79f <strfind+0x1f>
        if (*s == c) {
c010b78e:	8b 45 08             	mov    0x8(%ebp),%eax
c010b791:	0f b6 00             	movzbl (%eax),%eax
c010b794:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010b797:	75 02                	jne    c010b79b <strfind+0x1b>
            break;
c010b799:	eb 0e                	jmp    c010b7a9 <strfind+0x29>
        }
        s ++;
c010b79b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010b79f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7a2:	0f b6 00             	movzbl (%eax),%eax
c010b7a5:	84 c0                	test   %al,%al
c010b7a7:	75 e5                	jne    c010b78e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010b7a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010b7ac:	c9                   	leave  
c010b7ad:	c3                   	ret    

c010b7ae <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010b7ae:	55                   	push   %ebp
c010b7af:	89 e5                	mov    %esp,%ebp
c010b7b1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010b7b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010b7bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010b7c2:	eb 04                	jmp    c010b7c8 <strtol+0x1a>
        s ++;
c010b7c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010b7c8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7cb:	0f b6 00             	movzbl (%eax),%eax
c010b7ce:	3c 20                	cmp    $0x20,%al
c010b7d0:	74 f2                	je     c010b7c4 <strtol+0x16>
c010b7d2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7d5:	0f b6 00             	movzbl (%eax),%eax
c010b7d8:	3c 09                	cmp    $0x9,%al
c010b7da:	74 e8                	je     c010b7c4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010b7dc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7df:	0f b6 00             	movzbl (%eax),%eax
c010b7e2:	3c 2b                	cmp    $0x2b,%al
c010b7e4:	75 06                	jne    c010b7ec <strtol+0x3e>
        s ++;
c010b7e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b7ea:	eb 15                	jmp    c010b801 <strtol+0x53>
    }
    else if (*s == '-') {
c010b7ec:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7ef:	0f b6 00             	movzbl (%eax),%eax
c010b7f2:	3c 2d                	cmp    $0x2d,%al
c010b7f4:	75 0b                	jne    c010b801 <strtol+0x53>
        s ++, neg = 1;
c010b7f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b7fa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010b801:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b805:	74 06                	je     c010b80d <strtol+0x5f>
c010b807:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010b80b:	75 24                	jne    c010b831 <strtol+0x83>
c010b80d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b810:	0f b6 00             	movzbl (%eax),%eax
c010b813:	3c 30                	cmp    $0x30,%al
c010b815:	75 1a                	jne    c010b831 <strtol+0x83>
c010b817:	8b 45 08             	mov    0x8(%ebp),%eax
c010b81a:	83 c0 01             	add    $0x1,%eax
c010b81d:	0f b6 00             	movzbl (%eax),%eax
c010b820:	3c 78                	cmp    $0x78,%al
c010b822:	75 0d                	jne    c010b831 <strtol+0x83>
        s += 2, base = 16;
c010b824:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010b828:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010b82f:	eb 2a                	jmp    c010b85b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010b831:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b835:	75 17                	jne    c010b84e <strtol+0xa0>
c010b837:	8b 45 08             	mov    0x8(%ebp),%eax
c010b83a:	0f b6 00             	movzbl (%eax),%eax
c010b83d:	3c 30                	cmp    $0x30,%al
c010b83f:	75 0d                	jne    c010b84e <strtol+0xa0>
        s ++, base = 8;
c010b841:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b845:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010b84c:	eb 0d                	jmp    c010b85b <strtol+0xad>
    }
    else if (base == 0) {
c010b84e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010b852:	75 07                	jne    c010b85b <strtol+0xad>
        base = 10;
c010b854:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010b85b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b85e:	0f b6 00             	movzbl (%eax),%eax
c010b861:	3c 2f                	cmp    $0x2f,%al
c010b863:	7e 1b                	jle    c010b880 <strtol+0xd2>
c010b865:	8b 45 08             	mov    0x8(%ebp),%eax
c010b868:	0f b6 00             	movzbl (%eax),%eax
c010b86b:	3c 39                	cmp    $0x39,%al
c010b86d:	7f 11                	jg     c010b880 <strtol+0xd2>
            dig = *s - '0';
c010b86f:	8b 45 08             	mov    0x8(%ebp),%eax
c010b872:	0f b6 00             	movzbl (%eax),%eax
c010b875:	0f be c0             	movsbl %al,%eax
c010b878:	83 e8 30             	sub    $0x30,%eax
c010b87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b87e:	eb 48                	jmp    c010b8c8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010b880:	8b 45 08             	mov    0x8(%ebp),%eax
c010b883:	0f b6 00             	movzbl (%eax),%eax
c010b886:	3c 60                	cmp    $0x60,%al
c010b888:	7e 1b                	jle    c010b8a5 <strtol+0xf7>
c010b88a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b88d:	0f b6 00             	movzbl (%eax),%eax
c010b890:	3c 7a                	cmp    $0x7a,%al
c010b892:	7f 11                	jg     c010b8a5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010b894:	8b 45 08             	mov    0x8(%ebp),%eax
c010b897:	0f b6 00             	movzbl (%eax),%eax
c010b89a:	0f be c0             	movsbl %al,%eax
c010b89d:	83 e8 57             	sub    $0x57,%eax
c010b8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b8a3:	eb 23                	jmp    c010b8c8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010b8a5:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8a8:	0f b6 00             	movzbl (%eax),%eax
c010b8ab:	3c 40                	cmp    $0x40,%al
c010b8ad:	7e 3d                	jle    c010b8ec <strtol+0x13e>
c010b8af:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8b2:	0f b6 00             	movzbl (%eax),%eax
c010b8b5:	3c 5a                	cmp    $0x5a,%al
c010b8b7:	7f 33                	jg     c010b8ec <strtol+0x13e>
            dig = *s - 'A' + 10;
c010b8b9:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8bc:	0f b6 00             	movzbl (%eax),%eax
c010b8bf:	0f be c0             	movsbl %al,%eax
c010b8c2:	83 e8 37             	sub    $0x37,%eax
c010b8c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010b8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b8cb:	3b 45 10             	cmp    0x10(%ebp),%eax
c010b8ce:	7c 02                	jl     c010b8d2 <strtol+0x124>
            break;
c010b8d0:	eb 1a                	jmp    c010b8ec <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c010b8d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010b8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010b8d9:	0f af 45 10          	imul   0x10(%ebp),%eax
c010b8dd:	89 c2                	mov    %eax,%edx
c010b8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b8e2:	01 d0                	add    %edx,%eax
c010b8e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010b8e7:	e9 6f ff ff ff       	jmp    c010b85b <strtol+0xad>

    if (endptr) {
c010b8ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b8f0:	74 08                	je     c010b8fa <strtol+0x14c>
        *endptr = (char *) s;
c010b8f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8f5:	8b 55 08             	mov    0x8(%ebp),%edx
c010b8f8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010b8fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010b8fe:	74 07                	je     c010b907 <strtol+0x159>
c010b900:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010b903:	f7 d8                	neg    %eax
c010b905:	eb 03                	jmp    c010b90a <strtol+0x15c>
c010b907:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010b90a:	c9                   	leave  
c010b90b:	c3                   	ret    

c010b90c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010b90c:	55                   	push   %ebp
c010b90d:	89 e5                	mov    %esp,%ebp
c010b90f:	57                   	push   %edi
c010b910:	83 ec 24             	sub    $0x24,%esp
c010b913:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b916:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010b919:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010b91d:	8b 55 08             	mov    0x8(%ebp),%edx
c010b920:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010b923:	88 45 f7             	mov    %al,-0x9(%ebp)
c010b926:	8b 45 10             	mov    0x10(%ebp),%eax
c010b929:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010b92c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010b92f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010b933:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010b936:	89 d7                	mov    %edx,%edi
c010b938:	f3 aa                	rep stos %al,%es:(%edi)
c010b93a:	89 fa                	mov    %edi,%edx
c010b93c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010b93f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010b942:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010b945:	83 c4 24             	add    $0x24,%esp
c010b948:	5f                   	pop    %edi
c010b949:	5d                   	pop    %ebp
c010b94a:	c3                   	ret    

c010b94b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010b94b:	55                   	push   %ebp
c010b94c:	89 e5                	mov    %esp,%ebp
c010b94e:	57                   	push   %edi
c010b94f:	56                   	push   %esi
c010b950:	53                   	push   %ebx
c010b951:	83 ec 30             	sub    $0x30,%esp
c010b954:	8b 45 08             	mov    0x8(%ebp),%eax
c010b957:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b95a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b95d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b960:	8b 45 10             	mov    0x10(%ebp),%eax
c010b963:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010b966:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b969:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010b96c:	73 42                	jae    c010b9b0 <memmove+0x65>
c010b96e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b974:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b977:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b97a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b97d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010b980:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b983:	c1 e8 02             	shr    $0x2,%eax
c010b986:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010b988:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b98b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b98e:	89 d7                	mov    %edx,%edi
c010b990:	89 c6                	mov    %eax,%esi
c010b992:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010b994:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010b997:	83 e1 03             	and    $0x3,%ecx
c010b99a:	74 02                	je     c010b99e <memmove+0x53>
c010b99c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010b99e:	89 f0                	mov    %esi,%eax
c010b9a0:	89 fa                	mov    %edi,%edx
c010b9a2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010b9a5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010b9a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010b9ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b9ae:	eb 36                	jmp    c010b9e6 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010b9b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b9b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b9b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b9b9:	01 c2                	add    %eax,%edx
c010b9bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b9be:	8d 48 ff             	lea    -0x1(%eax),%ecx
c010b9c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b9c4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010b9c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b9ca:	89 c1                	mov    %eax,%ecx
c010b9cc:	89 d8                	mov    %ebx,%eax
c010b9ce:	89 d6                	mov    %edx,%esi
c010b9d0:	89 c7                	mov    %eax,%edi
c010b9d2:	fd                   	std    
c010b9d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010b9d5:	fc                   	cld    
c010b9d6:	89 f8                	mov    %edi,%eax
c010b9d8:	89 f2                	mov    %esi,%edx
c010b9da:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010b9dd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010b9e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010b9e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010b9e6:	83 c4 30             	add    $0x30,%esp
c010b9e9:	5b                   	pop    %ebx
c010b9ea:	5e                   	pop    %esi
c010b9eb:	5f                   	pop    %edi
c010b9ec:	5d                   	pop    %ebp
c010b9ed:	c3                   	ret    

c010b9ee <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010b9ee:	55                   	push   %ebp
c010b9ef:	89 e5                	mov    %esp,%ebp
c010b9f1:	57                   	push   %edi
c010b9f2:	56                   	push   %esi
c010b9f3:	83 ec 20             	sub    $0x20,%esp
c010b9f6:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b9fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010ba02:	8b 45 10             	mov    0x10(%ebp),%eax
c010ba05:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010ba08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ba0b:	c1 e8 02             	shr    $0x2,%eax
c010ba0e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010ba10:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010ba13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ba16:	89 d7                	mov    %edx,%edi
c010ba18:	89 c6                	mov    %eax,%esi
c010ba1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010ba1c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010ba1f:	83 e1 03             	and    $0x3,%ecx
c010ba22:	74 02                	je     c010ba26 <memcpy+0x38>
c010ba24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010ba26:	89 f0                	mov    %esi,%eax
c010ba28:	89 fa                	mov    %edi,%edx
c010ba2a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010ba2d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010ba30:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010ba33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010ba36:	83 c4 20             	add    $0x20,%esp
c010ba39:	5e                   	pop    %esi
c010ba3a:	5f                   	pop    %edi
c010ba3b:	5d                   	pop    %ebp
c010ba3c:	c3                   	ret    

c010ba3d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010ba3d:	55                   	push   %ebp
c010ba3e:	89 e5                	mov    %esp,%ebp
c010ba40:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010ba43:	8b 45 08             	mov    0x8(%ebp),%eax
c010ba46:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010ba49:	8b 45 0c             	mov    0xc(%ebp),%eax
c010ba4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010ba4f:	eb 30                	jmp    c010ba81 <memcmp+0x44>
        if (*s1 != *s2) {
c010ba51:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ba54:	0f b6 10             	movzbl (%eax),%edx
c010ba57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ba5a:	0f b6 00             	movzbl (%eax),%eax
c010ba5d:	38 c2                	cmp    %al,%dl
c010ba5f:	74 18                	je     c010ba79 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010ba61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010ba64:	0f b6 00             	movzbl (%eax),%eax
c010ba67:	0f b6 d0             	movzbl %al,%edx
c010ba6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010ba6d:	0f b6 00             	movzbl (%eax),%eax
c010ba70:	0f b6 c0             	movzbl %al,%eax
c010ba73:	29 c2                	sub    %eax,%edx
c010ba75:	89 d0                	mov    %edx,%eax
c010ba77:	eb 1a                	jmp    c010ba93 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c010ba79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010ba7d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010ba81:	8b 45 10             	mov    0x10(%ebp),%eax
c010ba84:	8d 50 ff             	lea    -0x1(%eax),%edx
c010ba87:	89 55 10             	mov    %edx,0x10(%ebp)
c010ba8a:	85 c0                	test   %eax,%eax
c010ba8c:	75 c3                	jne    c010ba51 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010ba8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ba93:	c9                   	leave  
c010ba94:	c3                   	ret    
